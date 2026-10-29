import { useEffect, useMemo, useState } from "react";
import {
  Clock,
  Play,
  Square,
  Truck,
  Bot,
  ShoppingBag,
  Utensils,
  Check,
  X,
  Settings,
  Trophy,
  DollarSign,
  Users,
  Boxes,
  Megaphone,
  TrendingUp,
  Plus,
  Minus,
  UserPlus,
  Trash2,
  Info,
  MapPin,
  CalendarClock,
  ChevronRight,
  Footprints,
  Briefcase,
} from "lucide-react";
import { fetchNui, useNuiEvent, usePushFallback } from "../../lib/nui";
import { ChatSheet, ChatButton, useChatUnreadSet } from "../DeliveryChat";
import { cn } from "../../lib/utils";
import { _L } from "../../lib/locale";
import { usePhone, money } from "../store";
import { Screen, TopBar, Empty, Spinner, ItemImg, Sheet } from "../ui";

// Icon + label for a ticket's CHANNEL. `npc` says the customer is an AI, NOT how the
// order arrived — an NPC can place a delivery, so the bot icon only stands in for a
// walk-in. (It used to override outright, which is why NPC deliveries read "Walk-in".)
const TYPE_ICON: Record<string, any> = { delivery: Truck, pickup: ShoppingBag, dine_in: Utensils, walk_in: Footprints };
const ticketChannel = (t: any): string => {
  const c = t?.channel || t?.orderType;
  return c === "delivery" || c === "dine_in" || c === "pickup" ? c : "walk_in";
};
const ticketIcon = (t: any) => {
  const c = ticketChannel(t);
  return (t?.npc && c === "walk_in") ? Bot : TYPE_ICON[c] || ShoppingBag;
};
const ticketTypeLabel = (t: any) => {
  const c = ticketChannel(t);
  return (t?.npc && c === "walk_in") ? _L("phone.work.walk_in") : _L("order.channel_" + c);
};

function useEmployment(paramRid?: number) {
  const { home } = usePhone();
  const employment: any[] = home?.employment || [];
  const [rid, setRid] = useState<number | null>(paramRid ?? employment[0]?.id ?? null);
  const active = employment.find((e) => e.id === rid);
  return { employment, rid, setRid, active };
}

function fmtDur(seconds: number) {
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  return h > 0 ? _L("phone.work.dur_hm", h, m) : _L("phone.work.dur_m", m);
}

function modText(mods?: any[]) {
  if (!mods || mods.length === 0) return "";
  return mods
    .map((m: any) => (m.removed ? _L("phone.work.mod_no", m.label) : _L("phone.work.mod_add", m.label)))
    .join(", ");
}

// Does OUR phone hold the claim on this delivery? A delivery has exactly ONE driver:
// the first employee to accept it holds it until they cancel, serve it, or leave the
// server. The server enforces all of it by identifier; this only decides what to show.
const isMyDelivery = (t: any, me?: number) => !!(t.driver && me != null && t.driver.server === me);

// The ticket's PRIMARY actions, as full-width stacked rows — at most a delivery row
// ("Accept Delivery" → "Set Waypoint", or an inert "With <driver>") above "Serve
// Order". Destructive actions are deliberately NOT here: cancelling a delivery or
// voiding a paid order lives in the detail sheet (the info button), so a mis-tap on a
// crowded queue card can never refund an order out from under the kitchen.
function TicketActions({
  t,
  me,
  ready,
  compact,
  onServe,
  onAccept,
  onWaypoint,
  onChat,
  chatUnread,
}: {
  t: any;
  me?: number;
  ready?: boolean;
  compact?: boolean;
  onServe: () => void;
  onAccept: () => void;
  onWaypoint: () => void;
  onChat?: () => void;
  chatUnread?: boolean;
}) {
  const row = cn(
    "flex w-full items-center justify-center gap-1.5 rounded-full px-3 text-sm font-bold",
    compact ? "py-2.5" : "py-3"
  );
  const mine = isMyDelivery(t, me);
  const claimedByOther = ticketChannel(t) === "delivery" && t.driver && !mine;
  // A delivery is served by ITS driver and nobody else — you have to hold the run to
  // hand it over. So Serve isn't merely disabled for a ticket that isn't yours, it's
  // absent: the only thing an unclaimed delivery offers is Accept. (The server rejects
  // it either way; this just stops the queue advertising an action that would fail.)
  const canServe = ticketChannel(t) !== "delivery" || mine;

  return (
    <div className={cn("space-y-2", compact ? "mt-2.5" : "")}>
      {ticketChannel(t) === "delivery" &&
        (claimedByOther ? (
          <div className={cn(row, "bg-muted text-muted-foreground")}>
            <Truck className="h-4 w-4" />{" "}
            {_L("phone.work.with_driver", t.driver.name || _L("phone.work.a_driver"))}
          </div>
        ) : mine ? (
          // A waypoint is a single global slot anything can clear, so the driver needs
          // it re-settable for the whole run — not just at the moment they accepted.
          <button onClick={onWaypoint} className={cn(row, "bg-brand text-brand-ink")}>
            <MapPin className="h-4 w-4" /> {_L("phone.work.set_waypoint")}
          </button>
        ) : ready ? (
          <button onClick={onAccept} className={cn(row, "bg-muted")}>
            <Truck className="h-4 w-4" /> {_L("phone.work.accept_delivery")}
          </button>
        ) : null)}
      {canServe && (
        <button
          disabled={!ready}
          onClick={onServe}
          className={cn(row, ready ? "bg-ok text-white" : "bg-muted text-muted-foreground")}
        >
          <Check className="h-4 w-4" /> {ready ? _L("phone.work.serve_order") : _L("phone.work.not_ready")}
        </button>
      )}
      {/* ALWAYS the last row — a secondary action shouldn't sit between the two things
          the driver is actually here to do. Only the driver holding the run can talk to
          the customer; the server gates it the same way, so this never offers a chat
          that would be rejected. Never on an NPC ticket: there's nobody on the far end,
          so the thread would just sit empty. */}
      {mine && !t.npc && onChat && (
        <ChatButton unread={chatUnread} onClick={onChat} className={row} label={_L("phone.work.message_customer")} />
      )}
    </div>
  );
}

// The destructive half of the ticket, sheet-only. The two cancels are NOT the same
// action and the copy has to say so: dropping a delivery just releases the claim so
// another driver can pick the run up, while cancelling the order voids it and refunds
// the customer. Each carries its consequence as a subtitle rather than hiding behind a
// confirm step — the sheet is already a deliberate second tap to reach.
function DangerRow({
  label,
  hint,
  icon: Icon,
  onClick,
}: {
  label: string;
  hint: string;
  icon: any;
  onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      className="flex w-full items-center gap-3 rounded-xl border border-destructive/25 bg-destructive/5 px-3 py-2.5 text-left active:scale-[0.99]"
    >
      <Icon className="h-4 w-4 shrink-0 text-destructive" />
      <span className="min-w-0 flex-1">
        <span className="block text-sm font-bold text-destructive">{label}</span>
        <span className="block text-[0.7rem] leading-tight text-muted-foreground">{hint}</span>
      </span>
    </button>
  );
}

// A full-detail ticket sheet: every line with its photo + mods, the customer /
// order-type / delivery meta, fulfillment state, and the serve/delivery/cancel
// actions. Opened from a ticket's info button in the queue.
function TicketSheet({
  t,
  currency,
  onClose,
  onServe,
  onAccept,
  onCancelDelivery,
  onWaypoint,
  onCancel,
  onChat,
  chatUnread,
  me,
}: {
  t: any;
  currency: string;
  onClose: () => void;
  onServe: () => void;
  onAccept: () => void;
  onCancelDelivery: () => void;
  onWaypoint: () => void;
  onCancel: () => void;
  onChat?: () => void;
  chatUnread?: boolean;
  me?: number;
}) {
  const ready = t.fulfill?.ready;
  const Icon = ticketIcon(t);
  const label = ticketTypeLabel(t);
  return (
    <Sheet onClose={onClose}>
      <>
        <div className="pf-grab" />
        {/* header */}
        <div className="flex items-center gap-3 px-4 pb-3 pt-1">
          <span className="grid h-11 w-11 place-items-center rounded-xl bg-muted">
            <Icon className="h-5 w-5" />
          </span>
          <div className="min-w-0 flex-1">
            <div className="font-display text-lg font-extrabold leading-tight">
              {_L("phone.work.ticket_no", t.ticket)}
            </div>
            <div className="text-[0.72rem] text-muted-foreground">
              {label} · {t.customer || _L("phone.guest")}
            </div>
          </div>
          <span className="font-mono text-base font-bold">{money(currency, t.total)}</span>
        </div>

        {/* meta (delivery address / scheduled) */}
        {(t.address || t.scheduled) && (
          <div className="mx-4 mb-3 space-y-1.5 rounded-xl border border-border bg-card px-3 py-2 text-[0.76rem]">
            {t.address && (
              <div className="flex items-start gap-2">
                <MapPin className="mt-0.5 h-3.5 w-3.5 shrink-0 text-brand" />
                <span className="text-foreground">{t.address}</span>
              </div>
            )}
            {t.scheduled && (
              <div className="flex items-center gap-2">
                <CalendarClock className="h-3.5 w-3.5 shrink-0 text-brand" />
                <span className="text-foreground">{_L("phone.work.scheduled", t.scheduled)}</span>
              </div>
            )}
          </div>
        )}

        {/* line items with photos — scrolls if long */}
        <div className="min-h-0 flex-1 overflow-y-auto px-4">
          <div className="space-y-2">
            {(t.lines || []).map((l: any, i: number) => (
              <div key={i} className="flex items-center gap-3 rounded-xl border border-border bg-card p-2">
                <ItemImg src={l.image} alt={l.label} className="h-12 w-12 shrink-0 rounded-lg bg-muted" />
                <div className="min-w-0 flex-1">
                  <div className="truncate text-sm font-semibold">
                    <span className="font-mono text-muted-foreground">{l.qty}×</span> {l.label}
                  </div>
                  {l.mods && l.mods.length > 0 && (
                    <div className="truncate text-[0.7rem] text-muted-foreground">{modText(l.mods)}</div>
                  )}
                </div>
                <span className="font-mono text-[0.78rem] text-muted-foreground">
                  {money(currency, (l.price || 0) * (l.qty || 1))}
                </span>
              </div>
            ))}
          </div>

          {!ready && t.fulfill?.missing && (
            <div className="mt-3 rounded-lg bg-warn/15 px-3 py-2 text-[0.74rem] text-warn">
              {_L("phone.work.still_cooking", t.fulfill.missing.join(", "))}
            </div>
          )}
        </div>

        {/* actions — primaries stacked, then the destructive options this sheet owns */}
        <div className="space-y-3 border-t border-border p-4" style={{ paddingBottom: "calc(1rem + var(--pf-bottom))" }}>
          <TicketActions
            t={t}
            me={me}
            ready={ready}
            onServe={onServe}
            onAccept={onAccept}
            onWaypoint={onWaypoint}
            onChat={onChat}
            chatUnread={chatUnread}
          />
          <div className="space-y-2">
            {isMyDelivery(t, me) && (
              <DangerRow
                label={_L("phone.work.cancel_delivery")}
                hint={_L("phone.work.cancel_delivery_hint")}
                icon={Truck}
                onClick={onCancelDelivery}
              />
            )}
            <DangerRow
              label={_L("phone.work.cancel_order")}
              hint={_L("phone.work.cancel_order_hint")}
              icon={X}
              onClick={onCancel}
            />
          </div>
        </div>
      </>
    </Sheet>
  );
}

function RestaurantChips({ employment, rid, setRid }: any) {
  if (employment.length < 2) return null;
  return (
    <div className="pf-rail px-4 pb-2 pt-3">
      {employment.map((e: any) => (
        <button
          key={e.id}
          onClick={() => setRid(e.id)}
          className={cn(
            "rounded-full border px-3 py-1.5 text-sm font-semibold",
            rid === e.id ? "border-brand bg-brand text-brand-ink" : "border-border bg-card"
          )}
        >
          {e.label}
        </button>
      ))}
    </div>
  );
}

// ─── KITCHEN (KDS) ────────────────────────────────────────────────────────────
export function Kitchen({ params }: { params?: any }) {
  const { home, go, currency, toast } = usePhone();
  const { employment, rid, setRid, active } = useEmployment(params?.rid);
  const [tickets, setTickets] = useState<any[]>([]);
  const [shift, setShift] = useState<any>(null);
  const [detailId, setDetailId] = useState<number | null>(null);
  // Delivery chat: which ticket's thread is open, plus per-ticket unread dots for the
  // rest of the queue (a driver can hold one run while another ticket messages them).
  const [chatId, setChatId] = useState<number | null>(null);
  const chatUnread = useChatUnreadSet(chatId);
  // Our own server id, carried by BOTH the ticket seed and the live broadcast — it's how
  // a claimed delivery is recognised as OURS (see DeliveryAction).
  const [me, setMe] = useState<number | undefined>(undefined);
  const canManage =
    active && (active.isBoss || active.isOwner
      || ["manage_menu", "view_finances", "manage_employees", "manage_stock", "manage_payroll"].some((p) => active.perms?.[p]));

  const loadTickets = () =>
    rid &&
    fetchNui("phone:tickets", { id: rid }).then((d) => {
      if (!d?.ok) return;
      setTickets(d.tickets || []);
      if (typeof d.me === "number") setMe(d.me);
    });
  const loadShift = () => rid && fetchNui("phone:shiftStatus", { id: rid }).then((d) => d?.ok && setShift(d));
  useEffect(() => {
    setTickets([]);
    loadTickets();
    loadShift();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rid]);

  useNuiEvent("orders", (d) => {
    if (d.rid !== rid) return;
    setTickets(d.orders || []);
    if (typeof d.me === "number") setMe(d.me);
  });

  // The kitchen queue is the one screen that's useless if it goes stale, so on a phone
  // that can't push (Quasar) it re-fetches on a timer instead. No-op on lb-phone.
  usePushFallback(loadTickets, 4000);

  const clock = async () => {
    const cb = shift?.clockedIn ? "phone:clockOut" : "phone:clockIn";
    const res = await fetchNui(cb, { id: rid });
    if (res?.ok) {
      toast(shift?.clockedIn ? _L("phone.work.clocked_out") : _L("phone.work.clocked_in"));
      loadShift();
    } else toast(res?.error || _L("phone.work.failed"), "err");
  };

  const complete = async (t: any) => {
    // the first packed vessel that completes this ticket (a meal or a takeaway bag);
    // `mealItem` tells the server which of the two to hand over
    const opt = t.fulfill?.mealOptions?.[0];
    const res = await fetchNui("phone:completeOrder", { id: rid, orderId: t.orderId, mealSig: opt?.sig, mealItem: opt?.item });
    if (res?.ok) {
      toast(_L("phone.work.ticket_served", t.ticket));
      setDetailId(null);
      loadTickets();
    } else toast(res?.error || _L("phone.work.complete_failed"), "err");
  };
  const cancel = async (t: any) => {
    const res = await fetchNui("phone:cancelOrder", { id: rid, orderId: t.orderId });
    if (res?.ok) {
      setDetailId(null);
      loadTickets();
    } else toast(res?.error || _L("phone.work.cancel_failed"), "err");
  };
  const acceptDelivery = async (t: any) => {
    const res = await fetchNui("phone:startDelivery", { id: rid, orderId: t.orderId });
    if (res?.ok) toast(_L("phone.work.delivery_accepted"));
    else toast(res?.error || _L("phone.work.failed"), "err");
  };
  const setWaypoint = async (t: any) => {
    const res = await fetchNui("phone:setWaypoint", { id: rid, orderId: t.orderId });
    if (!res?.ok) toast(res?.error || _L("phone.work.no_location"), "err");
  };
  const cancelDelivery = async (t: any) => {
    const res = await fetchNui("phone:cancelDelivery", { id: rid, orderId: t.orderId });
    if (res?.ok) toast(_L("phone.work.delivery_cancelled"));
    else toast(res?.error || _L("phone.work.failed"), "err");
  };

  if (!rid)
    return <Empty title={_L("phone.work.no_team")} hint={_L("phone.work.no_team_hint")} />;

  return (
    <Screen className="pb-20">
      <TopBar
        title={_L("phone.kitchen.title")}
        subtitle={active?.label}
        right={
          <button onClick={() => go("leaderboard", { rid })} className="grid h-8 w-8 place-items-center rounded-full bg-muted">
            <Trophy className="h-4 w-4 text-warn" />
          </button>
        }
      />
      <RestaurantChips employment={employment} rid={rid} setRid={setRid} />

      {/* shift + manage */}
      <div className={cn("flex gap-2 px-4 pb-3", employment.length < 2 && "pt-3")}>
        <button
          onClick={clock}
          className={cn(
            "flex flex-1 items-center justify-center gap-2 rounded-2xl px-3 py-2.5 font-bold active:scale-[0.99]",
            shift?.clockedIn ? "bg-destructive text-destructive-foreground" : "bg-brand text-brand-ink"
          )}
        >
          {shift?.clockedIn ? <Square className="h-4 w-4" /> : <Play className="h-4 w-4" />}
          {shift?.clockedIn ? _L("phone.work.clock_out") : _L("phone.work.clock_in")}
        </button>
        <button onClick={() => go("staff", { rid })} className="grid place-items-center rounded-2xl bg-muted px-4">
          <Clock className="h-5 w-5" />
        </button>
        {canManage && (
          <button onClick={() => go("manage", { rid })} className="grid place-items-center rounded-2xl bg-muted px-4">
            <Settings className="h-5 w-5" />
          </button>
        )}
      </div>

      {/* queue */}
      <div className="flex items-center justify-between px-4 pb-2">
        <h2 className="font-display text-base font-bold">{_L("phone.kitchen.queue")}</h2>
        <span className="text-[0.72rem] text-muted-foreground">
          {_L("phone.kitchen.open_count", tickets.length)}
        </span>
      </div>
      {tickets.length === 0 ? (
        <Empty
          icon={<Check className="h-8 w-8" />}
          title={_L("phone.kitchen.empty")}
          hint={_L("phone.kitchen.empty_hint")}
        />
      ) : (
        <div className="space-y-2 px-4">
          {tickets.map((t) => {
            const Icon = ticketIcon(t);
            const ready = t.fulfill?.ready;
            return (
              <div
                key={t.orderId}
                className={cn("rounded-2xl border bg-card p-3", ready ? "border-ok/50" : "border-border")}
              >
                <div className="flex items-center gap-2">
                  <span className="grid h-8 w-8 place-items-center rounded-lg bg-muted">
                    <Icon className="h-4 w-4" />
                  </span>
                  <div className="flex-1">
                    <div className="font-display font-bold leading-tight">
                      #{t.ticket}{" "}
                      <span className="text-sm font-normal text-muted-foreground">
                        {t.customer || _L("phone.guest")}
                      </span>
                    </div>
                    <div className="text-[0.66rem] uppercase tracking-wide text-muted-foreground">
                      {ticketTypeLabel(t)}
                    </div>
                  </div>
                  <span className="font-mono text-sm">{money(currency, t.total)}</span>
                  <button
                    onClick={() => setDetailId(t.orderId)}
                    className="grid h-8 w-8 shrink-0 place-items-center rounded-full bg-muted text-muted-foreground active:scale-90"
                    aria-label={_L("phone.kitchen.details")}
                  >
                    <Info className="h-4 w-4" />
                  </button>
                </div>

                {/* photo strip — tap to open full details */}
                <button
                  onClick={() => setDetailId(t.orderId)}
                  className="mt-2 flex w-full items-center gap-2 text-left"
                >
                  <div className="flex flex-1 flex-wrap gap-1.5">
                    {(t.lines || []).map((l: any, i: number) => (
                      <span key={i} className="relative">
                        <ItemImg src={l.image} alt={l.label} className="h-9 w-9 rounded-lg bg-muted" />
                        {l.qty > 1 && (
                          <span className="absolute -right-1 -top-1 grid h-4 min-w-4 place-items-center rounded-full bg-brand px-1 font-mono text-[0.55rem] font-bold text-brand-ink">
                            {l.qty}
                          </span>
                        )}
                      </span>
                    ))}
                  </div>
                </button>

                <div className="mt-2 space-y-0.5 font-mono text-[0.78rem]">
                  {(t.lines || []).map((l: any, i: number) => (
                    <div key={i} className="flex justify-between text-muted-foreground">
                      <span className="text-foreground">
                        {l.qty}× {l.label}
                      </span>
                      {l.mods && l.mods.length > 0 && (
                        <span className="truncate pl-2 text-right text-[0.66rem]">
                          {l.mods
                            .map((m: any) => (m.removed ? _L("phone.work.mod_no", m.label) : m.label))
                            .join(", ")}
                        </span>
                      )}
                    </div>
                  ))}
                </div>

                {!ready && t.fulfill?.missing && (
                  <div className="mt-2 rounded-lg bg-warn/15 px-2 py-1 text-[0.7rem] text-warn">
                    {_L("phone.work.still_cooking", t.fulfill.missing.join(", "))}
                  </div>
                )}

                <TicketActions
                  t={t}
                  me={me}
                  ready={ready}
                  compact
                  onServe={() => complete(t)}
                  onAccept={() => acceptDelivery(t)}
                  onWaypoint={() => setWaypoint(t)}
                  onChat={() => setChatId(t.orderId)}
                  chatUnread={chatUnread.has(t.orderId)}
                />
              </div>
            );
          })}
        </div>
      )}

      {detailId != null && (() => {
        const t = tickets.find((x) => x.orderId === detailId);
        if (!t) return null;
        return (
          <TicketSheet
            t={t}
            currency={currency}
            onClose={() => setDetailId(null)}
            onServe={() => complete(t)}
            onAccept={() => acceptDelivery(t)}
            onCancelDelivery={() => cancelDelivery(t)}
            onWaypoint={() => setWaypoint(t)}
            onCancel={() => cancel(t)}
            onChat={() => setChatId(t.orderId)}
            chatUnread={chatUnread.has(t.orderId)}
            me={me}
          />
        );
      })()}

      {chatId != null && (() => {
        const t = tickets.find((x) => x.orderId === chatId);
        // Held open by orderId, not by the ticket object: if the run is served or
        // cancelled while the thread is up, the ticket leaves the queue and the sheet
        // closes itself rather than rendering against a stale row.
        if (!t) return null;
        return (
          <ChatSheet
            rid={rid}
            orderId={chatId}
            title={_L("phone.kitchen.chat_title", t.ticket, t.customer || _L("phone.guest"))}
            onClose={() => setChatId(null)}
          />
        );
      })()}
    </Screen>
  );
}

// ─── STAFF (shift + tip pool) ─────────────────────────────────────────────────
export function Staff({ params }: { params?: any }) {
  const { back, currency, toast } = usePhone();
  const rid = params?.rid;
  const [shift, setShift] = useState<any>(null);
  const [tick, setTick] = useState(0);

  const load = () => fetchNui("phone:shiftStatus", { id: rid }).then((d) => d?.ok && setShift(d));
  useEffect(() => {
    load();
    const t = setInterval(() => setTick((n) => n + 1), 1000);
    return () => clearInterval(t);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rid]);

  const clock = async () => {
    const cb = shift?.clockedIn ? "phone:clockOut" : "phone:clockIn";
    const res = await fetchNui(cb, { id: rid });
    if (res?.ok) {
      toast(shift?.clockedIn ? _L("phone.work.clocked_out") : _L("phone.work.clocked_in"));
      load();
    } else toast(res?.error || _L("phone.work.failed"), "err");
  };

  const elapsed = shift?.since ? Math.max(0, Math.floor(Date.now() / 1000) - shift.since) : 0;
  const roster: any[] = shift?.roster || [];

  return (
    <Screen className="pb-8">
      <TopBar title={_L("phone.shift.title")} onBack={back} />
      <div className="space-y-4 p-4">
        <div className="rounded-2xl border border-border bg-card p-4 text-center">
          <div className="text-[0.66rem] font-bold uppercase tracking-wider text-muted-foreground">
            {shift?.clockedIn ? _L("phone.shift.on_clock") : _L("phone.shift.off_duty")}
          </div>
          <div className="my-1 font-mono text-3xl font-extrabold tabular-nums">
            {shift?.clockedIn ? fmtDur(elapsed) : "—"}
          </div>
          <div className="text-[0.72rem] text-muted-foreground">
            {_L("phone.shift.tips_label")}{" "}
            <span className="font-mono font-bold text-foreground">{money(currency, shift?.tips || 0)}</span>
          </div>
          <button
            onClick={clock}
            className={cn(
              "mt-3 w-full rounded-full px-4 py-3 font-bold active:scale-[0.99]",
              shift?.clockedIn ? "bg-destructive text-destructive-foreground" : "bg-brand text-brand-ink"
            )}
          >
            {shift?.clockedIn ? _L("phone.work.clock_out") : _L("phone.work.clock_in")}
          </button>
        </div>

        <section>
          <h2 className="mb-2 font-display text-base font-bold">{_L("phone.shift.tip_pool")}</h2>
          <p className="mb-2 text-[0.72rem] text-muted-foreground">{_L("phone.shift.tip_pool_hint")}</p>
          {roster.length === 0 ? (
            <Empty title={_L("phone.shift.nobody_in")} hint={_L("phone.shift.nobody_in_hint")} />
          ) : (
            <div className="space-y-1.5">
              {roster.map((m, i) => (
                <div key={i} className="flex items-center justify-between rounded-xl border border-border bg-card px-3 py-2">
                  <span className="flex items-center gap-2 text-sm font-medium">
                    <Users className="h-4 w-4 text-muted-foreground" /> {m.name}
                  </span>
                  <span className="font-mono text-sm">{money(currency, m.tips || 0)}</span>
                </div>
              ))}
            </div>
          )}
        </section>
      </div>
    </Screen>
  );
}

// ─── MANAGE (owner hub) ───────────────────────────────────────────────────────
// MOBILE-FIRST: this used to be a horizontal rail of pill tabs, which is exactly the
// pattern a phone-width screen can't hold — with five sections the last ones scrolled
// off the edge and were effectively unreachable. It's now a HUB → DETAIL flow (the
// Settings-app shape): the landing screen is a full-width list of sections, each one
// tappable at thumb size with a live summary line, and picking one pushes it as its
// own screen with a back arrow to the hub. That scales to any number of sections
// without ever putting a control out of reach, and every row is one tap deep.
const MANAGE_TABS = [
  { id: "sales", key: "phone.manage.tab_sales", hint: "phone.manage.hint_sales", icon: TrendingUp, perm: "view_finances" },
  { id: "menu", key: "phone.manage.tab_menu", hint: "phone.manage.hint_menu", icon: Utensils, perm: "manage_menu" },
  { id: "staff", key: "phone.manage.tab_staff", hint: "phone.manage.hint_staff", icon: Users, perm: "manage_employees" },
  // Paying the staff: the tip pool goes out to the roster, the wage bill comes out of
  // the balance. One permission, `manage_payroll`, which a boss holds implicitly.
  { id: "payroll", key: "phone.manage.tab_payroll", hint: "phone.manage.hint_payroll", icon: DollarSign, perm: "manage_payroll" },
  { id: "stock", key: "phone.manage.tab_stock", hint: "phone.manage.hint_stock", icon: Boxes, perm: "manage_stock" },
  { id: "promos", key: "phone.manage.tab_promos", hint: "phone.manage.hint_promos", icon: Megaphone, perm: "manage_menu" },
];

export function Manage({ params }: { params: any }) {
  const { back, home, currency } = usePhone();
  const rid = params.rid;
  const emp = (home?.employment || []).find((e: any) => e.id === rid);
  // A BOSS GRADE holds everything here, exactly like the owner or an admin: the
  // server's ResolvePerms says so, and `isOwner` is kept as an alias of it.
  // null = the hub. A section is pushed over it, never squeezed alongside it.
  const [section, setSection] = useState<string | null>(null);
  const [mgmt, setMgmt] = useState<any>(null);

  // Supply runs move BUYING to a depot counter, but the Stock screen stays: moving
  // stock between the larder and your own pockets is not a purchase and has nothing to
  // do with a depot. The screen swaps its buy button for deposit/withdraw.
  const supplyRuns = mgmt?.supplyRuns;
  const allowed = MANAGE_TABS.filter((t) => emp?.isBoss || emp?.isOwner || emp?.perms?.[t.perm]);

  const loadMgmt = () => fetchNui("phone:mgmtData", { id: rid }).then((d) => d?.ok && setMgmt(d));
  useEffect(() => {
    loadMgmt();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rid]);

  // A one-line "what's in here" for each row, so the hub is worth looking at rather
  // than a menu you tap through. Read off the management payload we already load.
  const summary = (id: string): string | undefined => {
    if (!mgmt) return undefined;
    switch (id) {
      case "sales": return _L("phone.manage.sum_sales", money(currency, mgmt.restaurant?.balance || 0));
      case "menu": return _L("phone.manage.sum_menu", (mgmt.priceList || []).length);
      // Headcount is the JOB's roster now (there are no employee rows), and an
      // unassigned restaurant can employ nobody at all — say that, since it's the one
      // state where every control on the Staff screen is dead.
      case "staff": return mgmt.jobMissing
        ? _L("phone.manage.sum_no_job")
        : _L("phone.manage.sum_staff", (mgmt.roster || []).length);
      case "payroll": return _L("phone.manage.sum_payroll", money(currency, mgmt.tipPool || 0));
      case "stock": {
        const out = (mgmt.supplies || []).filter((s: any) => s.installed && s.stock <= 0).length;
        return out > 0 ? _L("phone.manage.sum_stock_out", out) : _L("phone.manage.sum_stock_ok");
      }
      case "promos": return _L("phone.manage.sum_promos");
    }
  };

  // ── a section, pushed over the hub ──
  if (section) {
    const t = allowed.find((x) => x.id === section);
    return (
      <Screen className="pb-8">
        <TopBar title={t ? _L(t.key) : _L("phone.manage.title")} subtitle={emp?.label} onBack={() => setSection(null)} />
        <div className="p-4">
          {section === "sales" && <SalesTab rid={rid} onChange={loadMgmt} />}
          {section === "menu" && <MenuTab rid={rid} mgmt={mgmt} reload={loadMgmt} />}
          {section === "staff" && <StaffTab rid={rid} mgmt={mgmt} reload={loadMgmt} />}
          {section === "payroll" && <PayrollTab rid={rid} mgmt={mgmt} reload={loadMgmt} />}
          {section === "stock" && <StockTab rid={rid} mgmt={mgmt} reload={loadMgmt} />}
          {section === "promos" && <PromosTab rid={rid} />}
        </div>
      </Screen>
    );
  }

  // ── the hub ──
  return (
    <Screen className="pb-8">
      <TopBar title={_L("phone.manage.title")} subtitle={emp?.label} onBack={back} />
      <div className="space-y-2 p-4">
        {/* Buying left this screen with supply runs on, so say where it went rather
            than letting the missing button read as a permission problem. */}
        {supplyRuns?.enabled && (emp?.isBoss || emp?.isOwner || emp?.perms?.manage_stock) && (
          <div className="flex items-center gap-2 rounded-2xl border border-border bg-card p-3 text-[0.72rem] text-muted-foreground">
            <Boxes className="h-4 w-4 shrink-0 text-brand" />
            <span className="min-w-0 flex-1">{_L("phone.manage.stock_at_depot")}</span>
            {(supplyRuns.pending || []).length > 0 && (
              <span className="shrink-0 font-mono">{(supplyRuns.pending || []).length}</span>
            )}
          </div>
        )}
        {allowed.length === 0 ? (
          <Empty title={_L("phone.manage.no_access")} hint={_L("phone.manage.no_access_hint")} />
        ) : (
          allowed.map((t) => {
            const Icon = t.icon;
            const sum = summary(t.id);
            return (
              <button
                key={t.id}
                onClick={() => setSection(t.id)}
                className="pf-elev flex w-full items-center gap-3 rounded-2xl border border-border bg-card p-3.5 text-left active:scale-[0.99]"
              >
                <span className="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-brand/10 text-brand">
                  <Icon className="h-5 w-5" />
                </span>
                <span className="min-w-0 flex-1">
                  <span className="block font-display text-base font-bold leading-tight">{_L(t.key)}</span>
                  <span className="mt-0.5 block truncate text-[0.72rem] text-muted-foreground">
                    {sum || _L(t.hint)}
                  </span>
                </span>
                <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground" />
              </button>
            );
          })
        )}
      </div>
    </Screen>
  );
}

function SalesTab({ rid, onChange }: { rid: number; onChange: () => void }) {
  const { currency, toast, ask } = usePhone();
  const [a, setA] = useState<any>(null);
  const load = () => fetchNui("phone:analytics", { id: rid }).then((d) => d?.ok && setA(d));
  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rid]);
  if (!a) return <Spinner />;
  const maxPeak = Math.max(1, ...a.peak.map((p: any) => p.orders));

  const bank = async (dir: "deposit" | "withdraw") => {
    const raw = await ask({
      title: dir === "deposit" ? _L("phone.sales.deposit_title") : _L("phone.sales.withdraw_title"),
      label: _L("phone.sales.balance_is", money(currency, a.balance)),
      kind: "number",
      prefix: currency,
      placeholder: "0",
      confirm: dir === "deposit" ? _L("phone.sales.deposit") : _L("phone.sales.withdraw"),
    });
    const amount = Math.floor(Number(raw));
    if (!amount || amount <= 0) return;
    const res = await fetchNui(`phone:${dir}`, { id: rid, amount });
    if (res?.ok) {
      toast(dir === "deposit" ? _L("phone.sales.deposited") : _L("phone.sales.withdrawn"));
      load();
      onChange();
    } else toast(res?.error || _L("phone.work.failed"), "err");
  };

  return (
    <div className="space-y-4">
      <div className="rounded-2xl border border-border bg-card p-4">
        <div className="text-[0.66rem] font-bold uppercase tracking-wider text-muted-foreground">
          {_L("phone.sales.balance")}
        </div>
        <div className="font-mono text-3xl font-extrabold">{money(currency, a.balance)}</div>
        <div className="mt-2 flex gap-2">
          <button onClick={() => bank("deposit")} className="flex-1 rounded-full bg-muted py-2 text-sm font-bold">
            {_L("phone.sales.deposit")}
          </button>
          <button onClick={() => bank("withdraw")} className="flex-1 rounded-full bg-brand py-2 text-sm font-bold text-brand-ink">
            {_L("phone.sales.withdraw")}
          </button>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-2">
        <Kpi label={_L("phone.sales.kpi_revenue")} value={money(currency, a.revenue)} />
        <Kpi label={_L("phone.sales.kpi_tickets")} value={String(a.tickets)} />
        <Kpi label={_L("phone.sales.kpi_avg")} value={money(currency, a.avgTicket)} />
        <Kpi label={_L("phone.sales.kpi_payroll")} value={money(currency, a.payroll)} />
      </div>

      <section>
        <h3 className="mb-2 font-display font-bold">{_L("phone.sales.peak_hours")}</h3>
        <div className="flex h-24 items-end gap-0.5 rounded-2xl border border-border bg-card p-2">
          {a.peak.map((p: any) => (
            <div key={p.hour} className="flex flex-1 flex-col items-center gap-1">
              <div
                className="w-full rounded-sm bg-brand"
                style={{ height: `${(p.orders / maxPeak) * 100}%`, minHeight: p.orders ? 3 : 0 }}
                title={_L("phone.sales.peak_tip", p.hour, p.orders)}
              />
            </div>
          ))}
        </div>
        <div className="mt-1 flex justify-between text-[0.6rem] text-muted-foreground">
          <span>{_L("phone.sales.hour_12a")}</span>
          <span>{_L("phone.sales.hour_6a")}</span>
          <span>{_L("phone.sales.hour_12p")}</span>
          <span>{_L("phone.sales.hour_6p")}</span>
          <span>{_L("phone.sales.hour_11p")}</span>
        </div>
      </section>

      <section>
        <h3 className="mb-2 font-display font-bold">{_L("phone.sales.best_sellers")}</h3>
        {a.bestSellers.length === 0 ? (
          <div className="text-[0.72rem] text-muted-foreground">{_L("phone.sales.no_sales")}</div>
        ) : (
          <div className="space-y-1.5">
            {a.bestSellers.map((s: any, i: number) => (
              <div key={i} className="flex items-center gap-2 rounded-xl border border-border bg-card px-3 py-2">
                <span className="font-mono text-sm text-muted-foreground">{i + 1}</span>
                <span className="flex-1 text-sm font-medium">{s.label}</span>
                <span className="font-mono text-sm">{_L("phone.sales.sold", s.qty)}</span>
              </div>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}

function Kpi({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-2xl border border-border bg-card p-3">
      <div className="text-[0.62rem] uppercase tracking-wide text-muted-foreground">{label}</div>
      <div className="font-mono text-lg font-bold">{value}</div>
    </div>
  );
}

function MenuTab({ rid, mgmt, reload }: { rid: number; mgmt: any; reload: () => void }) {
  const { currency, toast, ask } = usePhone();
  if (!mgmt) return <Spinner />;
  const items: any[] = mgmt.priceList || [];

  const toggle = async (it: any) => {
    const res = await fetchNui("phone:saveMenuItem", { id: rid, key: it.key, price: it.price, enabled: !it.enabled });
    if (res?.ok) reload();
    else toast(res?.error || _L("phone.work.failed"), "err");
  };
  const reprice = async (it: any) => {
    const raw = await ask({
      title: _L("phone.menu.price_title", it.label),
      label: _L("phone.menu.price_hint"),
      kind: "number",
      prefix: currency,
      initial: it.price,
      confirm: _L("phone.menu.save_price"),
    });
    const price = Math.floor(Number(raw));
    if (!price || price <= 0) return;
    const res = await fetchNui("phone:saveMenuItem", { id: rid, key: it.key, price, enabled: it.enabled });
    if (res?.ok) reload();
    else toast(res?.error || _L("phone.work.failed"), "err");
  };

  return (
    <div className="space-y-1.5">
      {items.length === 0 && (
        <Empty title={_L("phone.menu.empty")} hint={_L("phone.menu.empty_hint")} />
      )}
      {items.map((it) => (
        <div key={it.key} className="flex items-center gap-2 rounded-xl border border-border bg-card px-3 py-2">
          {/* the sellable's own art — priceList has carried `image` all along */}
          <ItemImg src={it.image} alt={it.label} className="h-9 w-9 shrink-0 rounded-lg bg-muted/40 object-contain" />
          <div className="min-w-0 flex-1">
            <div className="truncate text-sm font-semibold">{it.label}</div>
            <button onClick={() => reprice(it)} className="font-mono text-[0.72rem] text-primary">
              {_L("phone.menu.edit_price", money(currency, it.price))}
            </button>
          </div>
          <button
            onClick={() => toggle(it)}
            className={cn(
              "rounded-full px-2.5 py-1 text-[0.68rem] font-bold",
              it.enabled ? "bg-ok/20 text-ok" : "bg-muted text-muted-foreground"
            )}
          >
            {it.enabled ? _L("phone.menu.available") : _L("phone.menu.sold_out")}
          </button>
        </div>
      ))}
    </div>
  );
}

// A restaurant with no JOB assigned can employ nobody: there is no grade ladder to hire
// into and no rank to pay. Both staff screens lead with this instead of offering
// controls that can only fail — and the fix is an admin's, not the boss's.
function NoJob() {
  return (
    <Empty
      icon={<Briefcase className="h-8 w-8" />}
      title={_L("phone.staff.no_job")}
      hint={_L("phone.staff.no_job_hint")}
    />
  );
}

// THE JOB ROSTER. Employment is the framework's job now: staff are whoever holds it, at
// the rank their grade names. So this lists `roster` (not employee rows of ours), moves
// people between the JOB's grades, and shows each one's pay from the RANK — there is no
// per-person commission left to edit.
function StaffTab({ rid, mgmt, reload }: { rid: number; mgmt: any; reload: () => void }) {
  const { toast } = usePhone();
  if (!mgmt) return <Spinner />;
  if (mgmt.jobMissing) return <NoJob />;
  const roster: any[] = mgmt.roster || [];
  const nearby: any[] = mgmt.nearby || [];
  const grades: any[] = mgmt.job?.grades || [];
  const ranks: any[] = mgmt.ranks || [];
  const rankFor = (grade: number) => ranks.find((r) => Number(r.grade) === Number(grade));

  // Hiring writes a JOB onto a loaded player, so the target is a server id — never a
  // row of ours. The lowest grade in the ladder is the entry rank.
  const entryGrade = grades.length ? Math.min(...grades.map((g) => Number(g.grade) || 0)) : 0;
  const hire = async (p: any) => {
    const res = await fetchNui("phone:hire", { id: rid, serverId: p.id, grade: entryGrade });
    if (res?.ok) {
      toast(_L("phone.staff.hired", p.name));
      reload();
    } else toast(res?.error || _L("phone.work.failed"), "err");
  };
  const fire = async (e: any) => {
    const res = await fetchNui("phone:fire", { id: rid, identifier: e.identifier });
    if (res?.ok) reload();
    else toast(res?.error || _L("phone.work.failed"), "err");
  };
  const setGrade = async (e: any, grade: number) => {
    const res = await fetchNui("phone:setGrade", { id: rid, identifier: e.identifier, grade });
    if (!res?.ok) toast(res?.error || _L("phone.work.failed"), "err");
    reload();
  };

  return (
    <div className="space-y-4">
      <p className="flex items-center gap-1.5 text-[0.7rem] text-muted-foreground">
        <Briefcase className="h-3.5 w-3.5" /> {_L("phone.staff.job_is", mgmt.job?.label || mgmt.job?.name || "")}
      </p>

      <section>
        <h3 className="mb-2 font-display font-bold">{_L("phone.staff.team")}</h3>
        {roster.length === 0 ? (
          <div className="text-[0.72rem] text-muted-foreground">{_L("phone.staff.no_roster")}</div>
        ) : (
          <div className="space-y-1.5">
            {roster.map((e) => {
              const rank = rankFor(e.grade ?? 0);
              return (
                <div key={e.identifier} className="flex items-center gap-2 rounded-xl border border-border bg-card px-3 py-2">
                  <div className="min-w-0 flex-1">
                    <div className="truncate text-sm font-semibold">
                      {e.name}
                      {e.boss && <span className="ml-1.5 text-[0.62rem] font-bold text-brand">{_L("phone.staff.boss")}</span>}
                    </div>
                    {/* pay is the RANK's, shared by everyone on that grade */}
                    <div className="text-[0.7rem] text-muted-foreground">
                      {_L("phone.staff.rank_meta", e.gradeLabel || String(e.grade ?? 0), rank?.commission ?? 0)}
                    </div>
                  </div>
                  <select
                    value={Number(e.grade ?? 0)}
                    onChange={(ev) => setGrade(e, Number(ev.target.value))}
                    className="rounded-lg border border-border bg-background px-1 py-1 text-xs"
                  >
                    {grades.map((g) => (
                      <option key={g.grade} value={g.grade}>
                        {g.label}
                      </option>
                    ))}
                  </select>
                  <button onClick={() => fire(e)} className="grid h-8 w-8 place-items-center rounded-full bg-muted text-destructive">
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              );
            })}
          </div>
        )}
      </section>

      <section>
        <h3 className="mb-2 font-display font-bold">{_L("phone.staff.hire_nearby")}</h3>
        {nearby.length === 0 ? (
          <div className="text-[0.72rem] text-muted-foreground">{_L("phone.staff.nobody_nearby")}</div>
        ) : (
          <div className="space-y-1.5">
            {nearby.map((p) => (
              <button
                key={p.id}
                onClick={() => hire(p)}
                className="flex w-full items-center gap-2 rounded-xl border border-border bg-card px-3 py-2 text-left active:scale-[0.99]"
              >
                <UserPlus className="h-4 w-4 text-primary" />
                <span className="flex-1 text-sm font-medium">{p.name}</span>
                <span className="text-[0.7rem] font-bold text-primary">{_L("phone.staff.hire")}</span>
              </button>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}

// PAYING THE STAFF. Two pots, one permission: TIPS are staff money the restaurant only
// holds (unpaid rows — the balance never sees them), split among the roster on payout;
// SALARIES come out of the balance, per rank, and a run is atomic (the server refuses
// the whole thing if the balance can't cover it), which is why the bill is shown first.
//
// Rank PAY is editable here (a boss on the move needs it), but the permission MATRIX is
// deliberately not: a nine-checkbox grid per grade doesn't fit a phone, and the
// fullscreen management panel's Ranks tab owns it. The existing permissions ride back
// with every save so editing pay can never blank them.
function PayrollTab({ rid, mgmt, reload }: { rid: number; mgmt: any; reload: () => void }) {
  const { currency, toast, ask } = usePhone();
  const [busy, setBusy] = useState(false);
  if (!mgmt) return <Spinner />;
  if (mgmt.jobMissing) return <NoJob />;

  const ranks: any[] = mgmt.ranks || [];
  const roster: any[] = mgmt.roster || [];
  const history: any[] = mgmt.payroll || [];
  const balance: number = mgmt.restaurant?.balance || 0;
  const tipPool: number = mgmt.tipPool || 0;
  const isBoss = !!mgmt.isBoss;

  const salaryFor = (grade: number) =>
    Math.max(0, Math.floor(Number(ranks.find((r) => Number(r.grade) === Number(grade))?.salary) || 0));
  const bill = roster.reduce((sum, m) => sum + salaryFor(m.grade ?? 0), 0);

  const run = async (event: "phone:payTips" | "phone:runPayroll") => {
    if (busy) return;
    setBusy(true);
    const res = await fetchNui<any>(event, { id: rid });
    setBusy(false);
    if (res?.ok) toast(_L("phone.payroll.paid", money(currency, res.paid || 0), res.recipients || 0));
    else toast(res?.error || _L("phone.work.failed"), "err");
    reload();
  };

  const editRank = async (rank: any, field: "commission" | "salary") => {
    const raw = await ask({
      title: field === "commission" ? _L("phone.payroll.commission_title", rank.label) : _L("phone.payroll.salary_title", rank.label),
      label: field === "commission" ? _L("phone.payroll.commission_hint") : _L("phone.payroll.salary_hint"),
      kind: "number",
      prefix: field === "salary" ? currency : undefined,
      initial: field === "commission" ? rank.commission : rank.salary,
      confirm: _L("phone.payroll.save"),
    });
    if (raw == null || raw === "") return;
    const v = Math.max(0, Math.floor(Number(raw) || 0));
    const res = await fetchNui<any>("phone:setRank", {
      id: rid, grade: rank.grade,
      // ALWAYS resend the permission set: setRank writes the submitted one whole, so
      // omitting it would strip the rank of everything it may do.
      permissions: rank.permissions || {},
      commission: field === "commission" ? Math.min(100, v) : rank.commission,
      salary: field === "salary" ? v : rank.salary,
    });
    if (!res?.ok) toast(res?.error || _L("phone.work.failed"), "err");
    reload();
  };

  return (
    <div className="space-y-4">
      {/* the tip pool */}
      <div className="rounded-2xl border border-border bg-card p-4">
        <div className="text-[0.66rem] font-bold uppercase tracking-wider text-muted-foreground">
          {_L("phone.payroll.tip_pool")}
        </div>
        <div className="font-mono text-3xl font-extrabold tabular-nums">{money(currency, tipPool)}</div>
        <p className="mt-1 text-[0.7rem] text-muted-foreground">{_L("phone.payroll.tip_pool_hint")}</p>
        <button
          disabled={busy || tipPool <= 0}
          onClick={() => run("phone:payTips")}
          className="mt-2 w-full rounded-full bg-brand py-2.5 font-bold text-brand-ink disabled:opacity-50"
        >
          {_L("phone.payroll.pay_tips")}
        </button>
      </div>

      {/* the wage bill */}
      <div className="rounded-2xl border border-border bg-card p-4">
        <div className="text-[0.66rem] font-bold uppercase tracking-wider text-muted-foreground">
          {_L("phone.payroll.bill")}
        </div>
        <div className="font-mono text-3xl font-extrabold tabular-nums">{money(currency, bill)}</div>
        <p className="mt-1 text-[0.7rem] text-muted-foreground">
          {bill <= 0
            ? _L("phone.payroll.nobody_owed")
            : bill > balance
            ? _L("phone.payroll.short", money(currency, balance))
            : _L("phone.payroll.bill_hint", roster.length, money(currency, balance))}
        </p>
        <button
          disabled={busy || bill <= 0 || bill > balance}
          onClick={() => run("phone:runPayroll")}
          className="mt-2 w-full rounded-full bg-brand py-2.5 font-bold text-brand-ink disabled:opacity-50"
        >
          {_L("phone.payroll.run")}
        </button>
      </div>

      {/* pay by rank — boss-only, exactly like the server's gate on setRank */}
      {isBoss && (
        <section>
          <h3 className="mb-2 font-display font-bold">{_L("phone.payroll.ranks")}</h3>
          <p className="mb-2 text-[0.7rem] text-muted-foreground">{_L("phone.payroll.ranks_hint")}</p>
          <div className="space-y-1.5">
            {ranks.map((r) => (
              <div key={r.grade} className="flex items-center gap-2 rounded-xl border border-border bg-card px-3 py-2">
                <div className="min-w-0 flex-1">
                  <div className="truncate text-sm font-semibold">
                    <span className="font-mono text-muted-foreground tabular-nums">{r.grade}</span> {r.label}
                    {r.boss && <span className="ml-1.5 text-[0.62rem] font-bold text-brand">{_L("phone.staff.boss")}</span>}
                  </div>
                </div>
                <button onClick={() => editRank(r, "commission")} className="rounded-full bg-muted px-2.5 py-1 font-mono text-[0.7rem] font-bold tabular-nums">
                  {r.commission}%
                </button>
                <button onClick={() => editRank(r, "salary")} className="rounded-full bg-muted px-2.5 py-1 font-mono text-[0.7rem] font-bold tabular-nums">
                  {money(currency, r.salary)}
                </button>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* what has already gone out, so nobody pays the same wages twice */}
      <section>
        <h3 className="mb-2 font-display font-bold">{_L("phone.payroll.history")}</h3>
        {history.length === 0 ? (
          <div className="text-[0.72rem] text-muted-foreground">{_L("phone.payroll.no_history")}</div>
        ) : (
          <div className="space-y-1.5">
            {history.map((p, i) => (
              <div key={i} className="flex items-center gap-2 rounded-xl border border-border bg-card px-3 py-2">
                <div className="min-w-0 flex-1">
                  <div className="truncate text-sm font-medium">{p.name || p.identifier}</div>
                  <div className="font-mono text-[0.66rem] text-muted-foreground">
                    {(p.kind === "tips" ? _L("phone.payroll.kind_tips") : _L("phone.payroll.kind_salary"))} · {p.paid_at || ""}
                  </div>
                </div>
                <span className="font-mono text-sm font-bold tabular-nums text-ok">{money(currency, p.amount)}</span>
              </div>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}

function StockTab({ rid, mgmt, reload }: { rid: number; mgmt: any; reload: () => void }) {
  const { currency, toast } = usePhone();
  const [qty, setQty] = useState<Record<string, number>>({});
  if (!mgmt) return <Spinner />;
  const supplies: any[] = mgmt.supplies || [];

  // With supply runs on there is nothing to buy here: ordering happens at a depot
  // counter, and this screen becomes the way stock moves between the larder and your
  // own pockets. The server refuses an off-site purchase either way, so this is which
  // control is worth offering, not a security boundary.
  const canBuy = !mgmt.supplyRuns?.enabled;

  const buy = async (s: any) => {
    const q = qty[s.key || s.item] || 10;
    const res = await fetchNui("phone:buyStock", { id: rid, key: s.key || s.item, item: s.item, qty: q });
    if (res?.ok) {
      toast(_L("phone.stock.bought", q, s.label));
      reload();
    } else toast(res?.error || _L("phone.work.failed"), "err");
  };

  const move = (event: "phone:depositStock" | "phone:withdrawStock", s: any) => async () => {
    const q = qty[s.key || s.item] || 10;
    const res = await fetchNui(event, { id: rid, key: s.key || s.item, item: s.item, qty: q });
    if (res?.ok) reload(); else toast(res?.error || _L("phone.work.failed"), "err");
  };

  return (
    <div className="space-y-1.5">
      {supplies.length === 0 && <Empty title={_L("phone.stock.empty")} />}
      {supplies.map((s) => {
        const q = qty[s.key || s.item] || 10;
        const low = (s.stock || 0) < 10;
        return (
          <div key={s.key || s.item} className="flex items-center gap-2 rounded-xl border border-border bg-card px-3 py-2">
            {/* the supply's own inventory art — the payload has carried `image` all
                along, this row just never drew it */}
            <ItemImg src={s.image} alt={s.label} className="h-9 w-9 shrink-0 rounded-lg bg-muted/40 object-contain" />
            <div className="min-w-0 flex-1">
              <div className="truncate text-sm font-semibold">{s.label}</div>
              <div className="text-[0.7rem]">
                <span className={cn("font-mono", low ? "text-warn" : "text-muted-foreground")}>
                  {_L("phone.stock.in_stock", s.stock)}
                  {low && _L("phone.stock.low")}
                </span>
                <span className="text-muted-foreground">{_L("phone.stock.each", money(currency, s.cost))}</span>
              </div>
            </div>
            <div className="flex items-center gap-1 rounded-full border border-border px-1">
              <button onClick={() => setQty((m) => ({ ...m, [s.key || s.item]: Math.max(1, q - 5) }))}>
                <Minus className="h-3.5 w-3.5" />
              </button>
              <span className="w-6 text-center font-mono text-xs">{q}</span>
              <button onClick={() => setQty((m) => ({ ...m, [s.key || s.item]: q + 5 }))}>
                <Plus className="h-3.5 w-3.5" />
              </button>
            </div>
            {canBuy ? (
              <button onClick={() => buy(s)} className="rounded-full bg-brand px-2.5 py-1.5 text-[0.7rem] font-bold text-brand-ink">
                {_L("phone.stock.buy")}
              </button>
            ) : s.movable ? (
              <>
                <button onClick={move("phone:depositStock", s)} disabled={(s.held || 0) < q}
                  className="rounded-full border border-border px-2.5 py-1.5 text-[0.7rem] font-bold disabled:opacity-40">
                  {_L("phone.stock.deposit")}
                </button>
                <button onClick={move("phone:withdrawStock", s)} disabled={(s.stock || 0) < q}
                  className="rounded-full border border-border px-2.5 py-1.5 text-[0.7rem] font-bold disabled:opacity-40">
                  {_L("phone.stock.withdraw")}
                </button>
              </>
            ) : null}
          </div>
        );
      })}
    </div>
  );
}

function PromosTab({ rid }: { rid: number }) {
  const { toast } = usePhone();
  const [promos, setPromos] = useState<any[]>([]);
  const [label, setLabel] = useState("");
  const [percent, setPercent] = useState(15);
  const [kind, setKind] = useState<"discount" | "happy_hour">("discount");

  const load = () => fetchNui("phone:promos", { id: rid }).then((d) => d?.ok && setPromos(d.promos || []));
  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rid]);

  const save = async () => {
    if (!label.trim()) return toast(_L("phone.promos.need_name"), "err");
    const res = await fetchNui("phone:savePromo", { id: rid, label, percent, kind, active: true });
    if (res?.ok) {
      toast(_L("phone.promos.pushed"));
      setLabel("");
      load();
    } else toast(res?.error || _L("phone.work.failed"), "err");
  };
  const del = async (p: any) => {
    await fetchNui("phone:deletePromo", { id: rid, promoId: p.id });
    load();
  };
  const toggle = async (p: any) => {
    await fetchNui("phone:savePromo", { id: rid, promoId: p.id, label: p.label, percent: p.percent, kind: p.kind, active: !p.active });
    load();
  };

  return (
    <div className="space-y-4">
      <div className="rounded-2xl border border-border bg-card p-3">
        <div className="mb-2 text-[0.66rem] font-bold uppercase tracking-wider text-muted-foreground">
          {_L("phone.promos.new")}
        </div>
        <input
          value={label}
          onChange={(e) => setLabel(e.target.value)}
          placeholder={_L("phone.promos.name_placeholder")}
          className="mb-2 w-full rounded-xl border border-border bg-background px-3 py-2 text-sm outline-none"
        />
        <div className="mb-2 flex gap-2">
          {(["discount", "happy_hour"] as const).map((k) => (
            <button
              key={k}
              onClick={() => setKind(k)}
              className={cn(
                "flex-1 rounded-full py-1.5 text-[0.72rem] font-bold",
                kind === k ? "bg-brand text-brand-ink" : "bg-muted text-muted-foreground"
              )}
            >
              {k === "discount" ? _L("phone.promos.kind_discount") : _L("phone.promos.kind_happy_hour")}
            </button>
          ))}
        </div>
        <div className="mb-2 flex items-center gap-2">
          <input
            type="range"
            min={5}
            max={60}
            step={5}
            value={percent}
            onChange={(e) => setPercent(Number(e.target.value))}
            className="flex-1 accent-[rgb(var(--brand))]"
          />
          <span className="w-12 text-right font-mono font-bold">{percent}%</span>
        </div>
        <button onClick={save} className="flex w-full items-center justify-center gap-1 rounded-full bg-brand py-2.5 font-bold text-brand-ink">
          <Megaphone className="h-4 w-4" /> {_L("phone.promos.push")}
        </button>
      </div>

      <div className="space-y-1.5">
        {promos.map((p) => (
          <div key={p.id} className="flex items-center gap-2 rounded-xl border border-border bg-card px-3 py-2">
            <div className="flex-1">
              <div className="text-sm font-semibold">{p.label}</div>
              <div className="text-[0.7rem] text-muted-foreground">
                {_L(
                  "phone.promos.row_meta",
                  p.percent,
                  p.kind === "happy_hour"
                    ? _L("phone.promos.kind_happy_hour")
                    : _L("phone.promos.kind_discount")
                )}
              </div>
            </div>
            <button
              onClick={() => toggle(p)}
              className={cn(
                "rounded-full px-2.5 py-1 text-[0.68rem] font-bold",
                p.active ? "bg-ok/20 text-ok" : "bg-muted text-muted-foreground"
              )}
            >
              {p.active ? _L("phone.promos.live") : _L("phone.promos.off")}
            </button>
            <button onClick={() => del(p)} className="grid h-8 w-8 place-items-center rounded-full bg-muted text-destructive">
              <Trash2 className="h-4 w-4" />
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
