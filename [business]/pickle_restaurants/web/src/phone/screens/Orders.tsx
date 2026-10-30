import { useCallback, useEffect, useMemo, useState } from "react";
import {
  Truck,
  ShoppingBag,
  Utensils,
  CheckCircle2,
  Camera,
  Star,
  ClipboardList,
} from "lucide-react";
import { fetchNui, useNuiEvent, usePushFallback } from "../../lib/nui";
import { cn } from "../../lib/utils";
import { _L } from "../../lib/locale";
import { usePhone, money } from "../store";
import { Screen, TopBar, ItemImg, Empty, Spinner, Stars } from "../ui";
import { OrderMap } from "../map/OrderMap";
import { ChatSheet, ChatButton, useChatUnread } from "../DeliveryChat";

const TYPE_ICON: Record<string, any> = { delivery: Truck, pickup: ShoppingBag, dine_in: Utensils };

// Resolved per render, never at module scope — the locale table arrives after import.
const typeLabel = (t?: string) =>
  t === "delivery"
    ? _L("phone.order_type.delivery")
    : t === "dine_in"
    ? _L("phone.order_type.dine_in")
    : _L("phone.order_type.pickup");

// The three phases the customer sees. "Ready" wording flips for delivery, and a
// delivery that's cooked but unclaimed says so rather than pretending it's moving.
function steps(o: any) {
  const delivery = o.type === "delivery";
  return [
    { key: "placed", label: _L("phone.track.placed") },
    {
      key: "cooking",
      label:
        delivery && o.ready && !o.driving
          ? _L("phone.track.waiting_driver")
          : _L("phone.track.cooking"),
    },
    { key: "ready", label: delivery ? _L("phone.track.on_the_way") : _L("phone.track.ready_pickup") },
    { key: "done", label: _L("phone.track.completed") },
  ];
}

function phaseIndex(o: any) {
  if (o.status === "completed") return 3;
  if (o.status === "cancelled") return -1;
  // `ready` means the KITCHEN can fulfil the ticket from its pool — nothing more. For a
  // pickup that genuinely is the last step before collection, but a delivery isn't "on
  // the way" until a driver has actually claimed the run, so it gates on `driving`.
  // Reading `ready` as movement is what had orders announcing a driver nobody assigned.
  if (o.type === "delivery") return o.driving ? 2 : 1;
  return o.ready ? 2 : 1;
}

// ─── orders list ──────────────────────────────────────────────────────────────
export function Orders() {
  const { home, currency, go } = usePhone();
  const [tab, setTab] = useState<"active" | "past">("active");
  const orders: any[] = home?.orders || [];
  const active = orders.filter((o) => o.status === "open");
  const past = orders.filter((o) => o.status !== "open");
  const list = tab === "active" ? active : past;

  return (
    <Screen className="pb-20">
      <TopBar title={_L("phone.orders.title")} />
      <div className="flex gap-2 px-4 pb-2 pt-3">
        {(["active", "past"] as const).map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={cn(
              "rounded-full px-3 py-1.5 text-sm font-semibold",
              tab === t ? "bg-brand text-brand-ink" : "bg-muted text-muted-foreground"
            )}
          >
            {t === "active" ? _L("phone.orders.tab_active") : _L("phone.orders.tab_past")}{" "}
            {t === "active" && active.length > 0 && `· ${active.length}`}
          </button>
        ))}
      </div>

      {list.length === 0 ? (
        <Empty
          icon={<ClipboardList className="h-8 w-8" />}
          title={tab === "active" ? _L("phone.orders.empty_active") : _L("phone.orders.empty_past")}
          hint={
            tab === "active"
              ? _L("phone.orders.empty_active_hint")
              : _L("phone.orders.empty_past_hint")
          }
        />
      ) : (
        <div className="space-y-2 px-4">
          {list.map((o) => {
            const Icon = TYPE_ICON[o.type] || ShoppingBag;
            const pi = phaseIndex(o);
            return (
              <button
                key={o.orderId}
                onClick={() => go("order", { orderId: o.orderId, rid: o.restaurantId })}
                className="flex w-full items-center gap-3 rounded-2xl border border-border bg-card p-3 text-left active:scale-[0.99]"
              >
                {o.lines?.[0]?.image ? (
                  <ItemImg src={o.lines[0].image} alt={o.lines[0].label} className="h-11 w-11 shrink-0 rounded-xl bg-muted" />
                ) : (
                  <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-muted text-foreground">
                    <Icon className="h-5 w-5" />
                  </span>
                )}
                <div className="min-w-0 flex-1">
                  <div className="truncate font-semibold">{o.restaurant}</div>
                  <div className="text-[0.72rem] text-muted-foreground">
                    #{o.ticket} · {typeLabel(o.type)} ·{" "}
                    {o.status === "open" ? (
                      <span className="font-semibold text-primary">{steps(o)[pi]?.label}</span>
                    ) : o.status === "cancelled" ? (
                      _L("phone.orders.status_cancelled")
                    ) : (
                      _L("phone.orders.status_completed")
                    )}
                  </div>
                </div>
                <span className="font-mono text-sm">{money(currency, o.total)}</span>
              </button>
            );
          })}
        </div>
      )}
    </Screen>
  );
}

// ─── live tracking hero ───────────────────────────────────────────────────────
export function OrderTrack({ params }: { params: any }) {
  const { home, currency, back, toast, refreshHome } = usePhone();
  const rid = params.rid;
  const seed = (home?.orders || []).find((o: any) => o.orderId === params.orderId);
  const [order, setOrder] = useState<any>(seed || { orderId: params.orderId, status: "open", type: "pickup", lines: [] });
  const [reviewing, setReviewing] = useState(false);
  // Whether this ticket's DETAIL actually exists. Opening a ticket the home payload
  // hasn't got yet (a fresh order, or a reconnect) left the page rendering an empty
  // shell that looked broken. Re-ask for home once, then say which it is.
  const [probe, setProbe] = useState<"ok" | "loading" | "missing">(seed ? "ok" : "loading");

  useEffect(() => {
    if (probe !== "loading") return;
    let cancelled = false;
    (async () => {
      const d = await refreshHome();
      if (cancelled) return;
      const found = (d?.orders || []).find((o: any) => o.orderId === params.orderId);
      if (found) {
        setOrder((o: any) => ({ ...found, ...o, ...found }));
        setProbe("ok");
      } else setProbe("missing");
    })();
    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Live: the server broadcasts open tickets for this restaurant. Update our
  // ready-flag off it; when our ticket drops out of the open list, it's completed.
  useNuiEvent("orders", (d) => {
    if (d.rid !== rid) return;
    const mine = (d.orders || []).find((t: any) => t.orderId === params.orderId);
    if (mine) {
      // Back-fill the fields the broadcast carries but a cold-opened ticket lacks —
      // without these the page renders only the order-type chip and nothing else.
      setOrder((o: any) => ({
        ...o,
        status: "open",
        ready: !!mine.fulfill?.ready,
        // The claimed driver rides the same broadcast (AnnotateOrders stamps it), so
        // the stepper flips to "On the way" the moment someone accepts — and back if
        // they drop the run.
        driving: !!mine.driver,
        lines: mine.lines || o.lines,
        total: mine.total ?? o.total,
        ticket: o.ticket ?? mine.ticket,
        type: o.type || mine.orderType || mine.type,
        map: o.map || mine.map,
      }));
      if (probe === "loading") setProbe("ok");
    } else {
      setOrder((o: any) => (o.status === "open" ? { ...o, status: "completed", ready: true } : o));
      fetchNui("phone:endDeliveryBlip", {});
    }
  });

  // Order tracking is push-fed too (the `orders` broadcast above drives the phase
  // stepper). On a pushless phone, re-ask for home and merge THIS ticket's row back
  // in, so it still advances from cooking → ready → served. Absence isn't treated as
  // completion here (unlike the broadcast handler, which reads a list of only OPEN
  // tickets): home carries finished orders too, so a missing row means a hiccup, not
  // a hand-off. No-op on lb-phone.
  const pollTicket = useCallback(async () => {
    const d = await refreshHome();
    const found = (d?.orders || []).find((o: any) => o.orderId === params.orderId);
    if (found) setOrder((o: any) => ({ ...o, ...found }));
  }, [refreshHome, params.orderId]);
  usePushFallback(pollTicket, 6000);

  const [chatting, setChatting] = useState(false);
  const unread = useChatUnread(order.status === "open" ? params.orderId : null, chatting);

  const stepList = steps(order);
  const pi = phaseIndex(order);
  const Icon = TYPE_ICON[order.type] || ShoppingBag;

  return (
    <Screen className="pb-6">
      <TopBar
        title={order.ticket != null ? _L("phone.track.ticket_no", order.ticket) : _L("phone.track.title")}
        subtitle={order.restaurant}
        onBack={back}
      />
      {probe === "loading" && <Spinner label={_L("phone.track.loading")} />}
      {probe === "missing" && (
        <Empty title={_L("phone.track.missing")} hint={_L("phone.track.missing_hint")} />
      )}

      {/* status ticket */}
      <div className="mx-auto mt-2 max-w-sm px-4">
        <div className="receipt relative px-5 pb-6 pt-5">
          <div className="flex items-center justify-between">
            <span className="tape text-paper-muted">{typeLabel(order.type)}</span>
            <Icon className="h-5 w-5 text-paper-ink/70" />
          </div>
          <div className="mt-2 font-display text-2xl font-extrabold text-paper-ink">
            {order.status === "completed"
              ? _L("phone.track.all_done")
              : order.status === "cancelled"
              ? _L("phone.track.cancelled")
              : stepList[pi]?.label}
          </div>

          {/* stepper */}
          {order.status !== "cancelled" && (
            <div className="mt-4 flex items-center">
              {stepList.map((s, i) => (
                <div key={s.key} className="flex flex-1 items-center last:flex-none">
                  <div
                    className={cn(
                      "pf-track-dot",
                      i < pi && "done",
                      i === pi && order.status !== "completed" && "active",
                      order.status === "completed" && "done"
                    )}
                  />
                  {i < stepList.length - 1 && (
                    <div className={cn("pf-track-line", (i < pi || order.status === "completed") && "done")} />
                  )}
                </div>
              ))}
            </div>
          )}

          {/* Live map — restaurant, drop-off and the driver, under the stepper. */}
          {order.map?.restaurant && order.status !== "cancelled" && (
            <div className="mt-4">
              <OrderMap
                orderId={order.orderId}
                data={{
                  restaurant: order.map.restaurant,
                  dest: order.map.dest,
                  type: order.map.type || (order.type === "delivery" ? "delivery" : "pickup"),
                }}
              />
            </div>
          )}

          {order.type === "delivery" && pi >= 2 && order.status === "open" && (
            <>
              <div className="mt-3 flex items-center gap-2 rounded-lg bg-paper-muted/15 px-3 py-2 text-[0.78rem] text-paper-ink">
                <Truck className="h-4 w-4" /> {_L("phone.track.driver_note")}
              </div>
              {/* Only once a driver holds the run: before that there's nobody on the
                  other end, and the server would reject the send anyway. */}
              <ChatButton unread={unread} onClick={() => setChatting(true)} className="mt-2 w-full" label={_L("phone.track.message_driver")} />
            </>
          )}

          <div className="receipt-rule my-4" />
          <div className="space-y-1.5 font-mono text-sm text-paper-ink">
            {(order.lines || []).map((l: any, i: number) => (
              <div key={i} className="flex justify-between">
                <span>
                  {l.qty}× {l.label}
                </span>
                <span>{money(currency, (l.price || 0) * (l.qty || 1))}</span>
              </div>
            ))}
            <div className="mt-2 flex justify-between border-t border-paper-muted/40 pt-2 font-bold">
              <span>{_L("phone.track.total")}</span>
              <span>{money(currency, order.total || 0)}</span>
            </div>
          </div>
        </div>
        {/* the perforated tear-off edge — a SIBLING strip, never a class on the card */}
        <div className="tear-b" />
      </div>

      {/* completed → review prompt */}
      {order.status === "completed" && !order.rated && !reviewing && (
        <div className="mx-4 mt-4 flex items-center gap-3 rounded-2xl border border-border bg-card p-3">
          <CheckCircle2 className="h-6 w-6 text-ok" />
          <div className="flex-1 text-sm">{_L("phone.review.prompt")}</div>
          <button
            onClick={() => setReviewing(true)}
            className="rounded-full bg-brand px-3 py-1.5 text-sm font-bold text-brand-ink"
          >
            {_L("phone.review.rate")}
          </button>
        </div>
      )}

      {chatting && (
        <ChatSheet
          rid={rid}
          orderId={params.orderId}
          title={_L("phone.track.ticket_no", order.ticket ?? "—")}
          onClose={() => setChatting(false)}
        />
      )}

      {reviewing && (
        <ReviewSheet
          rid={rid}
          orderId={order.orderId}
          onClose={() => setReviewing(false)}
          onDone={async () => {
            setReviewing(false);
            setOrder((o: any) => ({ ...o, rated: true }));
            toast(_L("phone.review.thanks"));
            await refreshHome();
          }}
        />
      )}
    </Screen>
  );
}

// ─── review sheet (optional photo via lb-phone camera) ────────────────────────
export function ReviewSheet({
  rid,
  orderId,
  onClose,
  onDone,
}: {
  rid: number;
  orderId?: number;
  onClose: () => void;
  onDone: () => void;
}) {
  const { toast } = usePhone();
  const [rating, setRating] = useState(5);
  const [comment, setComment] = useState("");
  const [photo, setPhoto] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const attach = () => {
    const cam = (window as any).useCamera || (window as any).selectGallery;
    if (typeof cam === "function") {
      cam((url: string) => url && setPhoto(url));
    } else {
      toast(_L("phone.review.no_camera"), "err");
    }
  };

  const submit = async () => {
    setBusy(true);
    const res = await fetchNui("phone:submitReview", { id: rid, orderId, rating, comment, photo });
    setBusy(false);
    if (res?.ok) onDone();
    else toast(res?.error || _L("phone.review.submit_failed"), "err");
  };

  return (
    <>
      <div className="pf-scrim" onClick={onClose} />
      <div className="pf-sheet">
        <div className="pf-grab" />
        <div className="p-4">
          <div className="font-display text-lg font-extrabold">{_L("phone.review.title")}</div>
          <div className="mt-3 flex justify-center">
            <Stars value={rating} size={34} onPick={setRating} />
          </div>
          <textarea
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            placeholder={_L("phone.review.comment_placeholder")}
            rows={3}
            className="mt-3 w-full resize-none rounded-xl border border-border bg-background p-3 text-sm outline-none placeholder:text-muted-foreground"
          />
          <button
            onClick={attach}
            className="mt-2 flex items-center gap-2 rounded-xl border border-border bg-card px-3 py-2 text-sm font-semibold active:scale-[0.99]"
          >
            <Camera className="h-4 w-4" />{" "}
            {photo ? _L("phone.review.photo_attached") : _L("phone.review.add_photo")}
          </button>
          {photo && <img src={photo} className="mt-2 h-28 w-full rounded-xl object-cover" />}
          <button
            disabled={busy}
            onClick={submit}
            className="mt-4 w-full rounded-full bg-brand px-4 py-3 font-bold text-brand-ink disabled:opacity-60"
          >
            {busy ? _L("phone.review.submitting") : _L("phone.review.submit")}
          </button>
        </div>
      </div>
    </>
  );
}
