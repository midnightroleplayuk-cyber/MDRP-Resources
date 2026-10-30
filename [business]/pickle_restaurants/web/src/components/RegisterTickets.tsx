import { useEffect, useState } from "react";
import { fetchNui } from "@/lib/nui";
import { Button } from "@/components/ui/button";
import { money, cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { Trash2, Check, X, Loader2, Ban, UtensilsCrossed, ShoppingBag } from "lucide-react";
import {
  Thumb, OptRow, arr, groupLines,
  type Ticket, type MealOption, type MealItem, type OptView, type VesselNeed,
} from "@/components/OrderBuilder";
import { drinkLineImageUrl } from "@/lib/localImages";
import TicketTimer from "@/components/TicketTimer";
import { channelIcon, channelLabel, isDelivery, orderChannel } from "@/lib/orders";

// The staff-facing ticket list + fulfillment UI (complete / cancel / meal picker),
// shared by BOTH the full-screen register panel (views/Register.tsx) and the in-world
// register DUI (views/RegisterDui.tsx) so the two can't drift. Purely prop-driven:
// the owner passes the live ticket list (seeded from the open payload, kept current
// off the server's `orders` broadcast) and this renders + acts on it. `big` scales it
// up for the in-world screen, whose virtual cursor wants larger aim targets.
export function Tickets({ id, tickets, big }: { id: number; tickets: Ticket[]; big?: boolean }) {
  // The meal picker is owned here (not per-card) so it overlays the ticket LIST
  // area only — dimming the content, not the panel header — and centres in it.
  const [picker, setPicker] = useState<{ orderId: number; meals: MealOption[]; needs: VesselNeed[] } | null>(null);
  const [busy, setBusy] = useState(false);
  // Drop the picker if its ticket left the list (completed/cancelled elsewhere).
  useEffect(() => {
    if (picker && !tickets.some((t) => t.orderId === picker.orderId)) setPicker(null);
  }, [tickets]); // eslint-disable-line react-hooks/exhaustive-deps

  // Hand over EVERY package the cashier picked — a ticket for a pizza and a cake is
  // two packages, so this is a list, not one choice. Each entry's `item` says which
  // vessel it is (a serving-tray meal or a Restaurant Bag); the server re-validates
  // every one of them and claims any further vessel the ticket still needs itself.
  const fulfillMeals = async (picks: { sig: string; item?: string }[]) => {
    if (!picker) return;
    setBusy(true);
    await fetchNui("sales:completeOrder", { id, orderId: picker.orderId, vessels: picks });
    setBusy(false);
    setPicker(null); // (also clears via the `orders` broadcast on success)
  };

  if (tickets.length === 0) return <div className={cn("py-8 text-center text-muted-foreground", big ? "text-lg" : "text-sm")}>{_L("register.no_tickets")}</div>;
  return (
    <div className="relative h-full">
      <div className={cn("h-full overflow-y-auto pr-1 pb-4", big ? "space-y-3" : "space-y-2")}>
        {tickets.map((t) => (
          <TicketCard key={t.orderId} id={id} t={t} big={big}
            onOpenPicker={(meals, needs) => setPicker({ orderId: t.orderId, meals, needs })} />
        ))}
      </div>
      {picker && (
        <MealPicker meals={picker.meals} needs={picker.needs} busy={busy} big={big}
          onFulfill={fulfillMeals} onClose={() => setPicker(null)} />
      )}
    </div>
  );
}

function TicketCard({ id, t, big, onOpenPicker }: { id: number; t: Ticket; big?: boolean; onOpenPicker: (meals: MealOption[], needs: VesselNeed[]) => void }) {
  const [confirmCancel, setConfirmCancel] = useState(false);
  const [busy, setBusy] = useState(false);

  const f = t.fulfill;
  const mealOptions = arr<MealOption>(f?.mealOptions);
  const needs = arr<VesselNeed>(f?.needs);
  const missing = arr<string>(f?.missing);

  // Fire the action; the ticket drops out of the list when the server's `orders`
  // broadcast lands (near-instant). On failure the server notifies and the list
  // is unchanged, so we just un-busy.
  const act = async (event: string, extra?: Record<string, unknown>) => {
    setBusy(true);
    await fetchNui(event, { id, orderId: t.orderId, ...extra });
    setBusy(false);
  };

  const btn = cn("inline-flex items-center gap-1.5 rounded-md font-semibold shadow-sm transition-colors disabled:opacity-50",
    big ? "px-4 py-2.5 text-sm" : "px-3 py-1.5 text-xs");
  const ic = big ? "h-4 w-4" : "h-3.5 w-3.5";

  // How the order arrived. A DELIVERY is the one a cashier must not try to hand
  // across the counter — only its claimed driver can complete it, at the customer's
  // door — so it's called out on the slip rather than looking like every walk-in.
  const delivery = isDelivery(t);
  const ChannelIcon = channelIcon(t);

  return (
    <div className="drop-shadow-md">
      <div className={cn("receipt rounded-t-sm", big ? "px-4 pb-4 pt-4" : "px-3.5 pb-3 pt-3")}>
        <div className="mb-2 flex items-center justify-between gap-2">
          <div className="flex min-w-0 items-center gap-2">
            <span className={cn("shrink-0 rounded-sm bg-muted px-1.5 py-0.5 font-mono font-bold uppercase tracking-wider tabular-nums", big ? "text-xs" : "text-[10px]")}>
              {_L("register.ticket_num", t.ticket)}
            </span>
            {/* No name on the PUBLIC feed: the always-on counter board and the orders
                screen are seeded/pushed with the projected ticket list (publicOrders in
                modules/sales), which drops the customer's name, address and driver so a
                passerby's screen isn't a directory of who ordered what. The ticket number
                beside this is the identity there — so render nothing rather than an empty
                slot. A cashier's own session gets the full list and shows the name. */}
            {t.customer && (
              <span className={cn("truncate font-medium", big ? "text-base" : "text-sm")}>{t.customer}</span>
            )}
          </div>
          <div className="flex shrink-0 items-center gap-2">
            {/* NPC walk-ins run out of patience — show the time left + radial so the
                cashier knows how long the order will still be here to fulfill. */}
            {t.npc && t.expiresIn != null && (
              <TicketTimer expiresIn={t.expiresIn} patience={t.patience} size={big ? 40 : 34} />
            )}
            <span className={cn("font-mono font-bold tabular-nums", big ? "text-base" : "text-sm")}>{money(t.total)}</span>
          </div>
        </div>
        {/* the channel strip: what kind of order this is, and for a delivery the
            drop address + who (if anyone) has claimed the run */}
        <div className={cn("mb-2 flex flex-wrap items-center gap-x-2 gap-y-1", big ? "text-[11px]" : "text-[10px]")}>
          <span className={cn("tape flex items-center gap-1 rounded-sm px-1.5 py-0.5",
            delivery ? "bg-primary/15 text-primary" : "bg-muted text-muted-foreground")}>
            <ChannelIcon className={big ? "h-3.5 w-3.5" : "h-3 w-3"} /> {channelLabel(t)}
          </span>
          {t.scheduled && <span className="text-muted-foreground">{_L("phone.work.scheduled", t.scheduled)}</span>}
          {delivery && t.address && <span className="truncate text-muted-foreground">{_L("order.delivery_to", t.address)}</span>}
          {delivery && (
            <span className={cn("truncate", t.driver?.name ? "text-muted-foreground" : "font-semibold text-destructive")}>
              {t.driver?.name ? _L("order.delivery_driver", t.driver.name) : _L("order.delivery_unclaimed")}
            </span>
          )}
        </div>
        <div className="receipt-rule mb-2" />
        <div className="mb-3 space-y-1">
          {groupLines(t.lines).map((b, bi) => {
            if (b.type === "item") {
              const l = b.line;
              const mods = Array.isArray(l.mods) ? l.mods : [];
              return (
                <div key={bi} className="flex items-center gap-2 rounded-sm bg-muted/50 p-1.5">
                  <Thumb src={drinkLineImageUrl(l.kind, l.variant)} fallbackSrc={l.image} className={cn("shrink-0", big ? "h-11 w-11" : "h-9 w-9")} />
                  <div className="min-w-0 flex-1">
                    <div className={cn("truncate font-medium", big ? "text-sm" : "text-xs")}>{l.label}</div>
                    <OptRow added={mods.filter((m) => !m.removed)} removed={mods.filter((m) => m.removed)} />
                  </div>
                  <span className={cn("shrink-0 font-mono font-semibold tabular-nums text-muted-foreground", big ? "text-sm" : "text-xs")}>×{l.qty}</span>
                </div>
              );
            }
          })}
        </div>
        {/* the pool can't complete this order yet. Shown even when packages ARE on
            offer: they may only cover part of the ticket now that partial ones are
            listed, and "what's still short" is exactly what the cashier needs. */}
        {!f?.ok && missing.length > 0 && (
          <div className="mb-2.5 rounded-sm bg-destructive/10 px-2 py-1.5 text-[11px] font-medium text-destructive">
            {_L("register.missing", missing.join(", "))}
          </div>
        )}
        <div className="flex justify-end gap-2">
          {confirmCancel ? (
            <>
              <span className="mr-auto self-center text-xs text-muted-foreground">{_L("register.confirm_cancel")}</span>
              <button disabled={busy} onClick={() => setConfirmCancel(false)}
                className={cn("rounded-md font-semibold text-muted-foreground transition-colors hover:text-foreground disabled:opacity-50", big ? "px-4 py-2.5 text-sm" : "px-3 py-1.5 text-xs")}>
                {_L("register.keep")}
              </button>
              <button disabled={busy} onClick={() => act("sales:cancelOrder")}
                className={cn(btn, "bg-destructive text-white hover:bg-[rgb(var(--danger-hover))]")}>
                <X className={ic} /> {_L("register.cancel_refund")}
              </button>
            </>
          ) : (
            <>
              {/* A delivery is completed by its claimed driver at the customer's door
                  (the server rejects a counter hand-off), so the POS offers no Complete
                  for one — say why instead of showing a button that always fails. */}
              {delivery && (
                <span className={cn("mr-auto self-center text-muted-foreground", big ? "text-xs" : "text-[11px]")}>
                  {_L("order.delivery_hand_off")}
                </span>
              )}
              <button disabled={busy} onClick={() => setConfirmCancel(true)}
                className={cn("inline-flex items-center gap-1.5 rounded-md border border-border font-semibold text-foreground transition-colors hover:border-destructive hover:text-destructive disabled:opacity-50", big ? "px-4 py-2.5 text-sm" : "px-3 py-1.5 text-xs")}>
                <Trash2 className={ic} /> {_L("register.cancel")}
              </button>
              {!delivery && (<>
              {/* a packed vessel — a meal or a takeaway bag — (with any single items)
                  can complete this order: open the in-depth picker to review the
                  contents and hand one over */}
              {mealOptions.length > 0 && (
                <button disabled={busy} onClick={() => onOpenPicker(mealOptions, needs)}
                  className={cn(btn, "border border-primary/50 bg-primary/10 text-primary hover:bg-primary/20")}>
                  {mealOptions.every((m) => m.bag) ? <ShoppingBag className={ic} /> : <UtensilsCrossed className={ic} />}
                  {" "}
                  {_L(mealOptions.some((m) => m.bag) ? "register.fulfill_with_packed" : "register.fulfill_with_meal", mealOptions.length)}
                </button>
              )}
              {f?.ok ? (
                <button disabled={busy} onClick={() => act("sales:completeOrder")}
                  className={cn(btn, "bg-primary text-primary-foreground hover:bg-[rgb(var(--brand-hover))]")}>
                  {busy ? <Loader2 className={cn(ic, "animate-spin")} /> : <Check className={ic} />} {_L("register.complete")}
                </button>
              ) : mealOptions.length === 0 ? (
                <button disabled title={missing.length ? _L("register.missing", missing.join(", ")) : undefined}
                  className={cn("inline-flex cursor-not-allowed items-center gap-1.5 rounded-md border border-border font-semibold text-muted-foreground opacity-70", big ? "px-4 py-2.5 text-sm" : "px-3 py-1.5 text-xs")}>
                  <Ban className={ic} /> {_L("register.not_complete")}
                </button>
              ) : null}
              </>)}
            </>
          )}
        </div>
      </div>
      <div className="tear-b" />
    </div>
  );
}

// The in-depth fulfillment picker: a modal listing every package in the pool that
// carries something this ticket asked for, each shown with its FULL contents — item
// images + toppings (item images / colour swatches) + names — so the cashier reviews
// exactly what they're handing over.
//
// SEVERAL PACKAGES AT ONCE. A pizza and a cake are two different foods, so they are
// two different packages, and a picker that only took one made that ticket
// impossible to fulfil. Selection is per package (with a quantity when the pool holds
// identical copies), and the tally at the foot adds their `covers` up against the
// ticket's `needs` — so the button only goes live once the selection actually covers
// the order. Nothing here decides what may be handed over: the server re-plans against
// the same picks and refuses anything that doesn't add up.
//
// Rendered as an ABSOLUTE overlay so it dims + centres over the ticket LIST only
// (never the panel header), and fades its backdrop + card in on mount and out on close.
function MealPicker({ meals, needs, busy, big, onFulfill, onClose }: {
  meals: MealOption[]; needs: VesselNeed[]; busy: boolean; big?: boolean;
  onFulfill: (picks: { sig: string; item?: string }[]) => void; onClose: () => void;
}) {
  const [visible, setVisible] = useState(false);
  // how many of each package is being handed over, keyed item|sig
  const [picked, setPicked] = useState<Record<string, number>>({});
  // fade in on mount (next frame so the transition has a 0→1 to animate)
  useEffect(() => { const r = requestAnimationFrame(() => setVisible(true)); return () => cancelAnimationFrame(r); }, []);
  // fade out, then unmount via the parent's onClose
  const close = () => { setVisible(false); window.setTimeout(onClose, 180); };

  const key = (m: MealOption) => (m.item || "") + "|" + m.sig;
  const qty = (m: MealOption) => picked[key(m)] || 0;
  // Click a package to add one; clicking past the last copy in the pool takes it back
  // off — one control, no steppers to aim at with the in-world cursor.
  const bump = (m: MealOption) => {
    const k = key(m);
    const max = Math.max(1, m.count || 1);
    const next = (picked[k] || 0) + 1;
    setPicked({ ...picked, [k]: next > max ? 0 : next });
  };
  // What the current selection takes off the ticket, per need.
  const covered: Record<string, number> = {};
  for (const m of meals) {
    const n = qty(m);
    if (n <= 0) continue;
    for (const [k, v] of Object.entries(m.covers || {})) covered[k] = (covered[k] || 0) + v * n;
  }
  const enough = needs.length > 0 && needs.every((n) => (covered[n.id] || 0) >= n.need);
  const total = Object.values(picked).reduce((a, b) => a + b, 0);
  const fulfill = () => {
    const picks: { sig: string; item?: string }[] = [];
    for (const m of meals) for (let i = 0; i < qty(m); i++) picks.push({ sig: m.sig, item: m.item });
    if (picks.length === 0) return;
    setVisible(false);
    window.setTimeout(() => onFulfill(picks), 160);
  };
  return (
    <div
      className={cn("absolute inset-0 z-30 flex items-center justify-center p-4 transition-opacity duration-200",
        visible ? "opacity-100" : "opacity-0")}
      onClick={close}
    >
      <div className="absolute inset-0 bg-black/50" />
      <div
        className={cn("relative flex max-h-full w-full flex-col rounded-lg border border-border bg-card shadow-2xl transition-transform duration-200",
          big ? "max-w-lg" : "max-w-md", visible ? "scale-100" : "scale-95")}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center gap-2 border-b border-border px-4 py-3">
          <UtensilsCrossed className="h-4 w-4 text-primary" />
          <span className="font-semibold">
            {_L(meals.some((m) => m.bag) ? "register.packed_picker_title" : "register.meal_picker_title")}
          </span>
          <span className="rounded-full bg-muted px-1.5 py-0.5 font-mono text-[10px] font-bold tabular-nums text-muted-foreground">{meals.length}</span>
          <button onClick={close} className="ml-auto text-muted-foreground transition-colors hover:text-foreground"><X className="h-4 w-4" /></button>
        </div>
        {/* WHAT THE TICKET STILL NEEDS PACKED, ticked off live as packages are
            selected. Without it, picking two of anything is guesswork. */}
        {needs.length > 0 && (
          <div className="flex flex-wrap gap-1.5 border-b border-border px-3 py-2">
            {needs.map((n) => {
              const got = Math.min(covered[n.id] || 0, n.need);
              return (
                <span key={n.id}
                  className={cn("inline-flex items-center gap-1 rounded-full px-2 py-0.5 font-mono text-[10px] font-bold tabular-nums",
                    got >= n.need ? "bg-primary/15 text-primary" : "bg-muted text-muted-foreground")}>
                  {got >= n.need && <Check className="h-3 w-3" />}
                  {n.label} {got}/{n.need}
                </span>
              );
            })}
          </div>
        )}
        <div className="min-h-0 flex-1 space-y-2 overflow-y-auto p-3">
          {meals.map((m, mi) => {
            const items = arr<MealItem>(m.items);
            const n = qty(m);
            const max = Math.max(1, m.count || 1);
            return (
              <button key={m.item + m.sig} type="button" onClick={() => bump(m)}
                className={cn("w-full rounded-lg border p-3 text-left transition-colors",
                  n > 0 ? "border-primary bg-primary/10" : "border-border bg-muted/30 hover:border-primary/50")}>
                <div className="tape mb-2 flex items-center gap-1.5 text-muted-foreground">
                  {m.bag ? <ShoppingBag className="h-3 w-3" /> : <UtensilsCrossed className="h-3 w-3" />}
                  {_L(m.bag ? "register.bag_n" : "register.meal_n", mi + 1)}
                  {max > 1 && (
                    <span className="rounded-full bg-muted px-1.5 font-mono text-[10px] tabular-nums text-muted-foreground">×{max}</span>
                  )}
                  {n > 0 && (
                    <span className="ml-auto inline-flex items-center gap-1 rounded-full bg-primary px-2 py-0.5 font-mono text-[10px] font-bold tabular-nums text-primary-foreground">
                      <Check className="h-3 w-3" />{n > 1 ? `×${n}` : _L("register.picked")}
                    </span>
                  )}
                </div>
                <div className="space-y-2">
                  {items.map((it, i) => (
                    <div key={i} className="flex items-start gap-2.5 rounded-sm bg-card/60 p-1.5">
                      <Thumb src={it.image} className="h-11 w-11 shrink-0" />
                      <div className="min-w-0 flex-1">
                        <div className="text-sm font-medium">{it.label}</div>
                        {arr<OptView>(it.mods).length > 0 && (
                          <div className="mt-1 space-y-0.5">
                            {arr<OptView>(it.mods).map((o, j) => (
                              <div key={j} className="flex items-center gap-1.5">
                                {o.image
                                  ? <Thumb src={o.image} className="h-4 w-4" />
                                  : <span className="h-3 w-3 shrink-0 rounded-full border border-border" style={{ backgroundColor: o.color || "transparent" }} />}
                                <span className="truncate text-[11px] text-muted-foreground">{o.label}</span>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </button>
            );
          })}
        </div>
        {/* One hand-over for the whole selection. Live only once the tally above says
            the picks cover the ticket — the server re-plans against exactly these
            picks, so a button that lied would just produce a refusal notification. */}
        <div className="border-t border-border p-3">
          <Button className="w-full" size="sm" disabled={busy || !enough} onClick={fulfill}>
            {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <Check className="h-4 w-4" />}
            {" "}
            {total > 0 ? _L("register.hand_over_n", total) : _L("register.pick_packages")}
          </Button>
        </div>
      </div>
    </div>
  );
}
