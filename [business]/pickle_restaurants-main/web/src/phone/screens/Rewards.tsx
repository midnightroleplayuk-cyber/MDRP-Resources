import { useEffect, useState } from "react";
import {
  Trophy,
  ChevronRight,
  Award,
  Lock,
  X,
  Medal,
  Briefcase,
  Armchair,
  UserPlus,
  Users,
} from "lucide-react";
import { fetchNui } from "../../lib/nui";
import { cn } from "../../lib/utils";
import { _L } from "../../lib/locale";
import { usePhone, money } from "../store";
import { Screen, TopBar, PunchCard, Empty, Spinner } from "../ui";

// ─── rewards hub ──────────────────────────────────────────────────────────────
export function Rewards() {
  const { home, go } = usePhone();
  const loyalty: any[] = home?.loyalty || [];
  const achievements: any[] = home?.achievements || [];
  const unlocked = achievements.filter((a) => a.unlocked).length;

  return (
    <Screen className="pb-20">
      <TopBar title={_L("phone.rewards.title")} />
      <div className="space-y-4 p-4">
        {/* Booking a table used to sit beside this as a second card; it moved onto the
            restaurant's own storefront (screens/Restaurant.tsx), where the restaurant
            being booked is already the thing on screen. */}
        <button
          onClick={() => go("leaderboard")}
          className="flex w-full items-center gap-3 rounded-2xl border border-border bg-card p-3 text-left active:scale-[0.98]"
        >
          <span className="grid h-10 w-10 place-items-center rounded-full bg-warn/10 text-warn">
            <Trophy className="h-5 w-5" />
          </span>
          <div className="min-w-0 flex-1">
            <div className="font-semibold leading-tight">{_L("phone.leaderboard.title")}</div>
            <div className="text-[0.7rem] text-muted-foreground">{_L("phone.rewards.leaderboard_hint")}</div>
          </div>
          <ChevronRight className="h-4 w-4 text-muted-foreground" />
        </button>

        {/* punch cards */}
        <section>
          <h2 className="mb-2 font-display text-base font-bold">{_L("phone.rewards.punch_cards")}</h2>
          {loyalty.length === 0 ? (
            <Empty title={_L("phone.rewards.no_cards")} hint={_L("phone.rewards.no_cards_hint")} />
          ) : (
            <div className="space-y-3">
              {loyalty.map((l) => (
                <div key={l.id} className="rounded-2xl border border-border bg-card p-3">
                  <div className="mb-2 flex items-center justify-between">
                    <span className="font-semibold">{l.label}</span>
                    <span className="text-[0.72rem] text-muted-foreground">
                      {l.punches % l.goal}/{l.goal}
                      {l.punches >= l.goal && (
                        <span className="ml-1 font-bold text-warn">{_L("phone.rewards.free_ready")}</span>
                      )}
                    </span>
                  </div>
                  <PunchCard punches={l.punches} goal={l.goal} />
                </div>
              ))}
            </div>
          )}
        </section>

        {/* achievements */}
        <section>
          <div className="mb-2 flex items-center justify-between">
            <h2 className="font-display text-base font-bold">{_L("phone.rewards.achievements")}</h2>
            <span className="text-[0.72rem] text-muted-foreground">
              {unlocked}/{achievements.length}
            </span>
          </div>
          <div className="space-y-2">
            {achievements.map((a) => (
              <div
                key={a.key}
                className={cn(
                  "flex items-center gap-3 rounded-2xl border p-3",
                  a.unlocked ? "border-brand/40 bg-brand/5" : "border-border bg-card"
                )}
              >
                <span
                  className={cn(
                    "grid h-10 w-10 place-items-center rounded-full",
                    a.unlocked ? "bg-brand text-brand-ink" : "bg-muted text-muted-foreground"
                  )}
                >
                  {a.unlocked ? <Award className="h-5 w-5" /> : <Lock className="h-4 w-4" />}
                </span>
                <div className="min-w-0 flex-1">
                  <div className="font-semibold leading-tight">{a.label}</div>
                  <div className="text-[0.7rem] text-muted-foreground">{a.desc}</div>
                  <div className="mt-1.5 h-1.5 overflow-hidden rounded-full bg-muted">
                    <div
                      className="h-full rounded-full bg-brand"
                      style={{ width: `${Math.min(100, (a.progress / a.goal) * 100)}%` }}
                    />
                  </div>
                </div>
                <span className="font-mono text-[0.72rem] text-muted-foreground">
                  {a.progress}/{a.goal}
                </span>
              </div>
            ))}
          </div>
        </section>
      </div>
    </Screen>
  );
}

// ─── reservations ─────────────────────────────────────────────────────────────
// A RESERVATION HOLDS SPECIFIC SEATS. There is no booth and no instance any more: the
// server allocates real seat anchors for a timeslot, and only the holder plus the
// guests they grant may sit on them. So this screen books seats, shows which ones it
// holds, and manages the guest list — there is nothing to "enter".
//
// The slot list is CANONICAL SERVER DATA (`reservation_slots`), never a copy here: the
// server validates a booking against it, so a hardcoded array could offer a time that
// can't be booked. Only the DISPLAY of "now" is localized — a clock time reads the same
// in any language.
const slotLabel = (s?: string) => (!s || s === "now" || s === "Now" ? _L("phone.reserve.slot_now") : s);

export function Reserve({ params }: { params?: any }) {
  const { home, back, toast } = usePhone();
  const restaurants: any[] = home?.restaurants || [];
  // Opened FROM a storefront (the only way in now), so the restaurant is already
  // chosen — the picker rail would only offer a way to book somewhere else than the
  // page you came from. It stays as the fallback for a params-less open.
  const pinned: number | null = params?.rid ?? null;
  const [rid, setRid] = useState<number | null>(pinned ?? restaurants[0]?.id ?? null);
  const [party, setParty] = useState(2);
  const [slot, setSlot] = useState<string>("");
  const [avail, setAvail] = useState<any>(null);
  // Only used when there is no restaurant to ask about (a params-less open on a phone
  // whose feed is empty): the caller's booking still has to be visible and cancellable.
  const [loose, setLoose] = useState<any[]>([]);
  const [busy, setBusy] = useState(false);

  const loadAvail = (r: number | null) => {
    setAvail(null);
    if (r != null) fetchNui("phone:reserveAvailability", { id: r }).then((d) => d?.ok && setAvail(d));
  };
  const loadLoose = () => fetchNui("phone:myReservations", {}).then((d) => d?.ok && setLoose(d.reservations || []));
  useEffect(() => { loadLoose(); }, []);
  useEffect(() => { loadAvail(rid); }, [rid]);

  const capacity: number = avail?.capacity ?? 0;
  const maxParty: number = avail?.maxParty ?? 12;
  const slots: { id: string; taken: number; remaining: number }[] = avail?.slots || [];
  // ONE active reservation per person, anywhere — the server enforces it, so this is a
  // single object, not a list. `avail` carries it even when it belongs to another
  // restaurant, because that is exactly what makes booking here impossible.
  const mine = avail ? avail.mine : (loose[0] || null);
  const mineHere = !!mine && mine.restaurantId === rid;

  // The first render has no slot chosen; land on the server's first slot ("now") once
  // the canonical list arrives, or on the slot the caller is already booked into.
  useEffect(() => {
    if (!slots.length) return;
    const want = mineHere ? mine.slot : slot;
    if (!slots.some((s) => s.id === want)) setSlot(mineHere ? mine.slot : slots[0].id);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [avail]);

  const cur = slots.find((s) => s.id === slot);
  // `remaining` comes STRAIGHT from the server — no capacity arithmetic here. It is
  // already "how many seats this player could hold in this slot": the server excludes
  // the caller's OWN held seats from the taken count, so for the slot they're booked
  // into it counts their seats as still theirs to keep. That makes it the cap for a
  // party TOTAL directly, with no seatCount to add back on.
  const cap = Math.max(1, Math.min(maxParty, cur ? cur.remaining : maxParty));
  const noSeats = avail != null && capacity <= 0;
  // Booking elsewhere / at another time is refused server-side (one reservation per
  // person), so say WHICH mismatch it is instead of letting the button just fail.
  const blockedOther = !!mine && !mineHere;
  const blockedSlot = mineHere && mine.slot !== slot;
  const held: number = mineHere ? (mine.seatCount || 0) : 0;
  // Asking for what you already hold is a no-op the server reports as success; the
  // button should say so rather than inviting a pointless round trip.
  const nothingToAdd = mineHere && party <= held;

  useEffect(() => {
    // Keep the stepper inside what the chosen slot can actually give, and never below
    // the seats already held (a reservation is only ever grown here — giving seats back
    // is what cancelling is).
    setParty((p) => Math.max(Math.max(1, held), Math.min(cap, p)));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cap, held]);

  const reload = () => { loadAvail(rid); loadLoose(); };

  const book = async () => {
    if (!rid) return;
    setBusy(true);
    const res = await fetchNui("phone:reserve", { id: rid, party, slot });
    setBusy(false);
    if (res?.ok) {
      toast(_L("phone.reserve.booked"));
      reload();
    } else toast(res?.error || _L("phone.reserve.book_failed"), "err");
  };

  const cancel = async (r: any) => {
    const res = await fetchNui("phone:cancelReservation", { id: r.id });
    if (res?.ok) toast(_L("phone.reserve.cancelled"));
    else toast(res?.error || _L("phone.reserve.book_failed"), "err");
    reload();
  };

  return (
    <Screen className="pb-8">
      <TopBar title={_L("phone.reserve.title")} onBack={back} />
      <div className="space-y-4 p-4">
        <div>
          <div className="tape mb-1.5 text-muted-foreground">{_L("phone.reserve.restaurant")}</div>
          {pinned != null ? (
            <div className="rounded-2xl border border-border bg-card px-3 py-2 font-semibold">
              {params?.label || restaurants.find((r) => r.id === pinned)?.label || ""}
            </div>
          ) : (
            <div className="pf-rail">
              {restaurants.map((r) => (
                <button
                  key={r.id}
                  onClick={() => setRid(r.id)}
                  className={cn(
                    "rounded-full border px-3 py-1.5 text-sm font-semibold",
                    rid === r.id ? "border-brand bg-brand text-brand-ink" : "border-border bg-card"
                  )}
                >
                  {r.label}
                </button>
              ))}
            </div>
          )}
        </div>

        <div>
          <div className="mb-1.5 flex items-center justify-between">
            <span className="tape text-muted-foreground">{_L("phone.reserve.party_size")}</span>
            <span className="text-[0.66rem] text-muted-foreground">{_L("phone.reserve.party_cap", cap)}</span>
          </div>
          <div className="flex items-center gap-3">
            <button onClick={() => setParty((p) => Math.max(Math.max(1, held), p - 1))} className="grid h-9 w-9 place-items-center rounded-full bg-muted">
              −
            </button>
            <span className="w-8 text-center font-mono text-lg font-bold tabular-nums">{party}</span>
            <button onClick={() => setParty((p) => Math.min(cap, p + 1))} className="grid h-9 w-9 place-items-center rounded-full bg-muted">
              +
            </button>
            {/* A party is a TOTAL, so an existing booking's seats count towards it —
                the stepper can't go below what's already held. */}
            {held > 0 && (
              <span className="text-[0.66rem] text-muted-foreground">{_L("phone.reserve.already_hold", held)}</span>
            )}
          </div>
        </div>

        <div>
          <div className="mb-1.5 flex items-center justify-between">
            <span className="tape text-muted-foreground">{_L("phone.reserve.time")}</span>
            {avail && !noSeats && (
              <span className="text-[0.66rem] text-muted-foreground">
                {capacity === 1
                  ? _L("phone.reserve.seat_one", capacity)
                  : _L("phone.reserve.seat_many", capacity)}
              </span>
            )}
          </div>
          {/* The slot picker WRAPS, it does not scroll. The slots are a short authored
              list, and chips carrying a clock time plus a "N left" line need ~440px
              against a phone screen's ~360 — so as a `pf-rail` (overflow-x with a
              hidden scrollbar) the last time sat half past the edge and read as
              clipped rather than as scrollable. A rail is right for the restaurant
              list above, which is genuinely open-ended; a time picker should show
              every option at once. */}
          {noSeats ? (
            <p className="rounded-xl border border-border bg-card px-3 py-2 text-[0.74rem] text-muted-foreground">
              {_L("phone.reserve.no_seats")}
            </p>
          ) : (
          <div className="flex flex-wrap gap-2">
            {slots.map((s) => {
              const full = s.remaining <= 0;
              return (
                <button
                  key={s.id}
                  disabled={full}
                  onClick={() => setSlot(s.id)}
                  className={cn(
                    // whitespace-nowrap: never break a clock across lines ("6:00" / "PM")
                    "flex flex-col items-center whitespace-nowrap rounded-2xl border px-3 py-1.5 text-sm font-semibold",
                    slot === s.id ? "border-brand bg-brand text-brand-ink" : "border-border bg-card",
                    full && "opacity-40"
                  )}
                >
                  {slotLabel(s.id)}
                  <span className={cn("font-mono text-[0.6rem] font-medium tabular-nums", slot === s.id ? "text-brand-ink/80" : "text-muted-foreground")}>
                    {full ? _L("phone.reserve.full") : _L("phone.reserve.left", s.remaining)}
                  </span>
                </button>
              );
            })}
          </div>
          )}
        </div>

        {(blockedOther || blockedSlot) && (
          <p className="rounded-xl border border-border bg-card px-3 py-2 text-[0.74rem] text-muted-foreground">
            {blockedOther
              ? _L("phone.reserve.other_restaurant", mine.restaurant)
              : _L("phone.reserve.other_slot", slotLabel(mine.slot))}
          </p>
        )}

        <button
          disabled={busy || !rid || noSeats || blockedOther || blockedSlot || nothingToAdd || (cur ? cur.remaining <= 0 : false)}
          onClick={book}
          className="w-full rounded-full bg-brand px-4 py-3 font-bold text-brand-ink disabled:opacity-60"
        >
          {busy
            ? _L("phone.reserve.booking")
            : noSeats
            ? _L("phone.reserve.btn_no_seats")
            : cur && cur.remaining <= 0
            ? _L("phone.reserve.btn_full")
            : nothingToAdd
            ? _L("phone.reserve.btn_booked")
            : held > 0
            ? _L("phone.reserve.btn_add_seats", party - held)
            : _L("phone.reserve.btn_book")}
        </button>

        {mine && (
          <section>
            <h2 className="mb-2 font-display text-base font-bold">{_L("phone.reserve.mine")}</h2>
            <MyReservation res={mine} onCancel={() => cancel(mine)} />
          </section>
        )}
      </div>
    </Screen>
  );
}

// The booking itself: which restaurant and time, the SEATS it holds (that's what a
// reservation is now), and who else may use them.
function MyReservation({ res, onCancel }: { res: any; onCancel: () => void }) {
  const { toast, ask } = usePhone();
  const [guests, setGuests] = useState<any[]>(res.guests || []);
  const [maxGuests, setMaxGuests] = useState<number>(res.maxGuests ?? 12);

  const load = () =>
    fetchNui("phone:reservationGuests", { id: res.id }).then((d) => {
      if (!d?.ok) return;
      setGuests(d.guests || []);
      if (typeof d.maxGuests === "number") setMaxGuests(d.maxGuests);
    });
  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [res.id]);

  // Granting takes a SERVER ID on purpose: you're inviting somebody standing in front
  // of you, and their player id is the only handle one player can read off another.
  // There's no nearby-player list on a customer's phone, so it's typed — through the
  // CEF-safe ask() modal, since FiveM's CEF suppresses window.prompt().
  const grant = async () => {
    const raw = await ask({
      title: _L("phone.reserve.guest_add_title"),
      label: _L("phone.reserve.guest_add_label", guests.length, maxGuests),
      kind: "number",
      placeholder: "1",
      confirm: _L("phone.reserve.guest_add_confirm"),
    });
    const serverId = Math.floor(Number(raw));
    if (!serverId || serverId <= 0) return;
    const d = await fetchNui<any>("phone:grantGuest", { id: res.id, serverId });
    if (d?.ok) {
      toast(_L("phone.reserve.guest_added"));
      setGuests(d.guests || []);
    } else toast(d?.error || _L("phone.reserve.guest_failed"), "err");
  };

  const revoke = async (g: any) => {
    const d = await fetchNui<any>("phone:revokeGuest", { id: res.id, identifier: g.identifier });
    if (d?.ok) {
      toast(_L("phone.reserve.guest_removed"));
      setGuests(d.guests || []);
    } else toast(d?.error || _L("phone.reserve.guest_failed"), "err");
  };

  const seats: number[] = res.seats || [];

  return (
    <div className="space-y-2 rounded-2xl border border-border bg-card p-3">
      <div className="flex items-center gap-3">
        <div className="min-w-0 flex-1">
          <div className="font-semibold">{res.restaurant}</div>
          <div className="text-[0.72rem] text-muted-foreground">
            {_L("phone.reserve.party_of", res.party)} · {slotLabel(res.slot)}
          </div>
        </div>
        <button onClick={onCancel} className="grid h-8 w-8 place-items-center rounded-full bg-muted" title={_L("phone.reserve.cancel")}>
          <X className="h-4 w-4" />
        </button>
      </div>

      {/* the actual anchors — a party of four that only got three seats must not read
          as four, which is why the server sends the real list */}
      <div>
        <div className="tape mb-1 text-muted-foreground">{_L("phone.reserve.seats_held", seats.length)}</div>
        <div className="flex flex-wrap gap-1.5">
          {seats.map((pid) => (
            <span key={pid} className="flex items-center gap-1 rounded-full border border-border px-2 py-0.5 text-[0.66rem]">
              <Armchair className="h-3 w-3 text-brand" />
              <span className="font-mono tabular-nums">#{pid}</span>
            </span>
          ))}
        </div>
        <p className="mt-1 text-[0.66rem] text-muted-foreground">{_L("phone.reserve.seats_hint")}</p>
      </div>

      {/* guests — per RESERVATION, so a granted guest may use any of its seats */}
      <div>
        <div className="mb-1 flex items-center justify-between">
          <span className="tape text-muted-foreground">{_L("phone.reserve.guests", guests.length, maxGuests)}</span>
          <button
            onClick={grant}
            disabled={guests.length >= maxGuests}
            className="flex items-center gap-1 rounded-full bg-brand px-2.5 py-1 text-[0.68rem] font-bold text-brand-ink disabled:opacity-50"
          >
            <UserPlus className="h-3.5 w-3.5" /> {_L("phone.reserve.guest_add")}
          </button>
        </div>
        {guests.length === 0 ? (
          <p className="text-[0.68rem] text-muted-foreground">{_L("phone.reserve.no_guests")}</p>
        ) : (
          <div className="space-y-1.5">
            {guests.map((g) => (
              <div key={g.identifier} className="flex items-center gap-2 rounded-xl border border-border px-2.5 py-1.5">
                <Users className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
                <span className="min-w-0 flex-1 truncate text-sm">{g.name || g.identifier}</span>
                {/* online-ness says whether revoking has any effect right now — a
                    seated guest isn't thrown out, they just can't sit back down */}
                {g.online && <span className="text-[0.62rem] font-bold text-ok">{_L("phone.reserve.guest_online")}</span>}
                <button onClick={() => revoke(g)} className="grid h-7 w-7 shrink-0 place-items-center rounded-full bg-muted">
                  <X className="h-3.5 w-3.5" />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

// ─── leaderboard ──────────────────────────────────────────────────────────────
export function Leaderboard({ params }: { params?: any }) {
  const { home, back, currency } = usePhone();
  const employment: any[] = home?.employment || [];
  const [scope, setScope] = useState<number | null>(params?.rid ?? null);
  const [rows, setRows] = useState<any[] | null>(null);

  useEffect(() => {
    setRows(null);
    fetchNui("phone:leaderboard", { id: scope }).then((d) => setRows(d?.leaderboard || []));
  }, [scope]);

  return (
    <Screen className="pb-8">
      <TopBar title={_L("phone.leaderboard.title")} onBack={back} />
      <div className="flex gap-2 px-4 pb-2">
        <button
          onClick={() => setScope(null)}
          className={cn("rounded-full px-3 py-1.5 text-sm font-semibold", scope == null ? "bg-brand text-brand-ink" : "bg-muted text-muted-foreground")}
        >
          {_L("phone.leaderboard.server_wide")}
        </button>
        {employment.map((e) => (
          <button
            key={e.id}
            onClick={() => setScope(e.id)}
            className={cn("rounded-full px-3 py-1.5 text-sm font-semibold", scope === e.id ? "bg-brand text-brand-ink" : "bg-muted text-muted-foreground")}
          >
            {e.label}
          </button>
        ))}
      </div>

      {rows == null ? (
        <Spinner />
      ) : rows.length === 0 ? (
        <Empty
          icon={<Medal className="h-8 w-8" />}
          title={_L("phone.leaderboard.empty")}
          hint={_L("phone.leaderboard.empty_hint")}
        />
      ) : (
        <div className="space-y-1.5 px-4">
          {rows.map((r, i) => (
            <div
              key={i}
              className={cn(
                "flex items-center gap-3 rounded-2xl border p-3",
                r.me ? "border-brand bg-brand/10" : "border-border bg-card"
              )}
            >
              <span
                className={cn(
                  "grid h-8 w-8 place-items-center rounded-full font-mono font-bold",
                  i === 0 ? "bg-warn text-black" : i === 1 ? "bg-muted-foreground/30" : i === 2 ? "bg-brand/40" : "bg-muted text-muted-foreground"
                )}
              >
                {i + 1}
              </span>
              <div className="min-w-0 flex-1">
                <div className="truncate font-semibold">
                  {r.name}{" "}
                  {r.me && <span className="text-[0.68rem] text-primary">{_L("phone.leaderboard.you")}</span>}
                </div>
                <div className="text-[0.72rem] text-muted-foreground">
                  {_L("phone.leaderboard.earned", money(currency, r.revenue))}
                </div>
              </div>
              <div className="text-right">
                <div className="font-mono font-bold">{r.cooked}</div>
                <div className="text-[0.62rem] text-muted-foreground">{_L("phone.leaderboard.cooked")}</div>
              </div>
            </div>
          ))}
        </div>
      )}
    </Screen>
  );
}

// ─── profile ──────────────────────────────────────────────────────────────────
export function Profile() {
  const { home, go } = usePhone();
  const employment: any[] = home?.employment || [];
  const orders: any[] = home?.orders || [];
  const achievements: any[] = home?.achievements || [];
  const totalPunches = (home?.loyalty || []).reduce((n: number, l: any) => n + (l.punches || 0), 0);

  return (
    <Screen className="pb-20">
      <TopBar title={_L("phone.profile.title")} />
      <div className="space-y-4 p-4">
        <div className="flex items-center gap-3 rounded-2xl border border-border bg-card p-4">
          <span className="grid h-14 w-14 place-items-center rounded-full bg-brand font-display text-xl font-extrabold text-brand-ink">
            {(home?.name || "?").charAt(0)}
          </span>
          <div>
            <div className="font-display text-lg font-extrabold">{home?.name || _L("phone.guest")}</div>
            <div className="text-[0.72rem] text-muted-foreground">{_L("phone.profile.member")}</div>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-2 text-center">
          <Stat label={_L("phone.profile.stat_orders")} value={orders.length} />
          <Stat label={_L("phone.profile.stat_punches")} value={totalPunches} />
          <Stat
            label={_L("phone.profile.stat_badges")}
            value={achievements.filter((a) => a.unlocked).length}
          />
        </div>

        {employment.length > 0 && (
          <section>
            <h2 className="mb-2 font-display text-base font-bold">{_L("phone.profile.where_you_work")}</h2>
            <div className="space-y-2">
              {employment.map((e) => (
                <button
                  key={e.id}
                  onClick={() => go("staff", { rid: e.id })}
                  className="flex w-full items-center gap-3 rounded-2xl border border-border bg-card p-3 text-left active:scale-[0.99]"
                >
                  <Briefcase className="h-5 w-5 text-primary" />
                  <div className="flex-1">
                    <div className="font-semibold">{e.label}</div>
                    {/* Employment is a JOB now, so the line names the GRADE you hold
                        there — a boss grade is not the owner but reads the same way. */}
                    <div className="text-[0.7rem] text-muted-foreground">
                      {e.gradeLabel || (e.isBoss || e.isOwner ? _L("phone.profile.owner") : _L("phone.profile.staff"))}
                      {e.clockedIn && <span className="ml-1 text-ok">{_L("phone.profile.on_shift")}</span>}
                    </div>
                  </div>
                  <ChevronRight className="h-5 w-5 text-muted-foreground" />
                </button>
              ))}
            </div>
          </section>
        )}
      </div>
    </Screen>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-2xl border border-border bg-card p-3">
      <div className="font-mono text-xl font-bold">{value}</div>
      <div className="text-[0.66rem] uppercase tracking-wide text-muted-foreground">{label}</div>
    </div>
  );
}
