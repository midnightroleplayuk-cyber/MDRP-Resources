import { useEffect, useMemo, useState } from "react";
import {
  Plus,
  Minus,
  Star,
  Heart,
  Truck,
  ShoppingBag,
  Utensils,
  Clock,
  Ticket,
  ChevronRight,
  CalendarClock,
} from "lucide-react";
import { fetchNui } from "../../lib/nui";
import { cn } from "../../lib/utils";
import { _L } from "../../lib/locale";
import { usePhone, money, CatalogItem, Mod } from "../store";
import { Screen, TopBar, Spinner, ItemImg, Rating, PromoTag, PunchCard, Empty } from "../ui";

// ─── modifier selection model ─────────────────────────────────────────────────
type ModState = Record<string, boolean>;

function groupMods(mods: Mod[] = []) {
  const groups: Record<string, Mod[]> = {};
  for (const m of mods) {
    const g = m.group || "__addons";
    (groups[g] = groups[g] || []).push(m);
  }
  return groups;
}

function defaultModState(item: CatalogItem): ModState {
  const st: ModState = {};
  const groups = groupMods(item.modifiers);
  for (const [g, list] of Object.entries(groups)) {
    if (g === "__addons") {
      list.forEach((m) => (st[m.id] = !!m.default));
    } else {
      const pick = list.find((m) => m.default) || list[0];
      if (pick) st[pick.id] = true;
    }
  }
  return st;
}

function priceOf(item: CatalogItem, st: ModState) {
  let p = item.price;
  for (const m of item.modifiers || []) if (st[m.id]) p += m.price || 0;
  return p;
}

// ─── item options sheet ───────────────────────────────────────────────────────
function ItemSheet({
  item,
  onClose,
  onAdd,
}: {
  item: CatalogItem;
  onClose: () => void;
  onAdd: (qty: number, st: ModState) => void;
}) {
  const { currency } = usePhone();
  const [st, setSt] = useState<ModState>(() => defaultModState(item));
  const [qty, setQty] = useState(1);
  const groups = useMemo(() => groupMods(item.modifiers), [item]);
  const unit = priceOf(item, st);
  // A drink has no image of its own (all flavors are the one generic drink item), so
  // the sheet header shows the CHOSEN flavor's art, falling back to the item image.
  const chosenFlavorImg = (item.modifiers || []).find(
    (m) => st[m.id] && m.id.startsWith("flavor:")
  )?.image;

  const pickRadio = (list: Mod[], id: string) =>
    setSt((s) => {
      const next = { ...s };
      list.forEach((m) => (next[m.id] = m.id === id));
      return next;
    });

  return (
    <>
      <div className="pf-scrim" onClick={onClose} />
      <div className="pf-sheet">
        <div className="pf-grab" />
        <div className="max-h-[70vh] overflow-y-auto px-4 pb-2">
          <div className="flex gap-3 pt-1">
            <ItemImg src={chosenFlavorImg || item.image} className="h-16 w-16 rounded-xl" />
            <div className="min-w-0 flex-1">
              <div className="font-display text-lg font-extrabold leading-tight">{item.label}</div>
              <div className="font-mono text-sm text-muted-foreground">
                {money(currency, item.price)}
              </div>
            </div>
          </div>

          {Object.entries(groups).map(([g, list]) => {
            const isAddon = g === "__addons";
            return (
              <div key={g} className="mt-4">
                <div className="tape mb-1.5 text-muted-foreground">
                  {isAddon ? _L("phone.item.addons") : list[0]?.group || _L("phone.item.choose_one")}
                </div>
                <div className="space-y-1.5">
                  {list.map((m) => {
                    const on = !!st[m.id];
                    return (
                      <button
                        key={m.id}
                        onClick={() =>
                          isAddon
                            ? setSt((s) => ({ ...s, [m.id]: !s[m.id] }))
                            : pickRadio(list, m.id)
                        }
                        className={cn(
                          "flex w-full items-center gap-2 rounded-xl border px-3 py-2 text-left active:scale-[0.99]",
                          on ? "border-brand bg-brand/10" : "border-border bg-card"
                        )}
                      >
                        <span
                          className={cn(
                            "grid h-5 w-5 place-items-center rounded-full border-2",
                            isAddon ? "rounded-md" : "rounded-full",
                            on ? "border-brand bg-brand text-brand-ink" : "border-border"
                          )}
                        >
                          {on && <Star className="h-3 w-3" fill="currentColor" />}
                        </span>
                        {(m.image || m.color) && (
                          m.image ? (
                            <ItemImg src={m.image} className="h-8 w-8 shrink-0 rounded-lg" />
                          ) : (
                            <span
                              className="h-8 w-8 shrink-0 rounded-lg border border-border"
                              style={{ backgroundColor: m.color }}
                            />
                          )
                        )}
                        <span className="flex-1 text-sm font-medium">{m.label}</span>
                        {m.price ? (
                          <span className="font-mono text-xs text-muted-foreground">
                            +{money(currency, m.price)}
                          </span>
                        ) : null}
                      </button>
                    );
                  })}
                </div>
              </div>
            );
          })}
        </div>

        <div className="flex items-center gap-3 border-t border-border p-3">
          <div className="flex items-center gap-3 rounded-full border border-border px-2 py-1">
            <button onClick={() => setQty((q) => Math.max(1, q - 1))} className="p-1">
              <Minus className="h-4 w-4" />
            </button>
            <span className="w-5 text-center font-mono font-bold">{qty}</span>
            <button onClick={() => setQty((q) => Math.min(10, q + 1))} className="p-1">
              <Plus className="h-4 w-4" />
            </button>
          </div>
          <button
            onClick={() => onAdd(qty, st)}
            className="flex flex-1 items-center justify-between rounded-full bg-brand px-4 py-2.5 font-bold text-brand-ink active:scale-[0.99]"
          >
            <span>{_L("phone.item.add_to_cart")}</span>
            <span className="font-mono">{money(currency, unit * qty)}</span>
          </button>
        </div>
      </div>
    </>
  );
}

// ─── storefront ───────────────────────────────────────────────────────────────
export function Restaurant({ params }: { params: any }) {
  const { back, addToCart, currency, go, refreshHome } = usePhone();
  const rid = params.rid;
  const [data, setData] = useState<any>(null);
  const [sheet, setSheet] = useState<{ item?: CatalogItem } | null>(null);

  useEffect(() => {
    let live = true;
    fetchNui("phone:menu", { id: rid }).then((d) => {
      if (!live) return;
      if (d?.ok) setData(d);
    });
    return () => {
      live = false;
    };
  }, [rid]);

  // Reorder: seed the cart from a saved favorite (best-effort by key match).
  useEffect(() => {
    if (data && params.reorder?.cart) {
      const byKey: Record<string, CatalogItem> = {};
      (data.catalog || []).forEach((c: CatalogItem) => (byKey[c.key] = c));
      params.reorder.cart.forEach((e: any) => {
        const it = byKey[e.key];
        if (it) {
          const st: ModState = {};
          (e.mods || []).forEach((id: string) => (st[id] = true));
          addLine(it, e.qty || 1, st);
        }
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data]);

  const addLine = (item: CatalogItem, qty: number, st: ModState) => {
    const selected = (item.modifiers || []).filter((m) => st[m.id]);
    const mods = selected.map((m) => m.id);
    const modLabels = selected.map((m) => m.label);
    // a drink line shows its CHOSEN flavor's art (the item's own image is the generic
    // drink); everything else keeps the item image
    const flavorImg = selected.find((m) => m.id.startsWith("flavor:"))?.image;
    addToCart(rid, data.label, {
      key: item.key,
      label: item.label,
      image: flavorImg || item.image,
      price: priceOf(item, st),
      qty,
      mods,
      modLabels,
    });
  };

  if (!data) return <Spinner />;

  const groups: Record<string, CatalogItem[]> = {};
  (data.catalog || []).forEach((c: CatalogItem) => {
    const g = c.kind === "drink" ? _L("phone.rest.drinks") : _L("phone.rest.menu");
    (groups[g] = groups[g] || []).push(c);
  });

  return (
    <Screen className="pb-24">
      <div className="relative h-40 w-full bg-muted">
        <ItemImg src={data.brand} className="h-full w-full" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/10 to-black/30" />
        <div className="absolute inset-x-0 top-0">
          <TopBar transparent onBack={back} right={<span className="w-8" />} />
        </div>
        <div className="absolute bottom-3 left-4 right-4 text-white">
          <h1 className="font-display text-2xl font-extrabold drop-shadow">{data.label}</h1>
          <div className="mt-1 flex items-center gap-3">
            <Rating value={data.rating} count={data.reviewCount} />
            {data.promo && <PromoTag label={_L("phone.promo.percent_off", data.promo.percent)} />}
          </div>
        </div>
      </div>

      {/* loyalty strip */}
      {data.loyalty?.on && (
        <div className="mx-4 mt-3 rounded-2xl border border-border bg-card p-3">
          <div className="mb-2 flex items-center justify-between">
            <span className="tape text-muted-foreground">{_L("phone.rest.punch_card")}</span>
            <span className="text-[0.72rem] text-muted-foreground">
              {_L(
                "phone.rest.punch_progress",
                data.loyalty.punches % data.loyalty.goal,
                data.loyalty.goal
              )}
            </span>
          </div>
          <PunchCard punches={data.loyalty.punches} goal={data.loyalty.goal} />
        </div>
      )}

      {/* reserve a table — lives on the storefront, not the rewards hub: booking is a
          thing you do TO a restaurant, so it belongs where you're already looking at
          one. Always PRESENT: a place with no seat anchors placed shows it greyed with
          the reason, rather than the row silently not existing (which reads exactly
          like the feature being missing). `seats` is only 0 when the server really
          says so — undefined means an older server payload, so the row still works. */}
      <button
        onClick={data.seats === 0 ? undefined : () => go("reserve", { rid, label: data.label })}
        disabled={data.seats === 0}
        className={cn(
          "mx-4 mt-3 flex w-[calc(100%-2rem)] items-center gap-3 rounded-2xl border border-border bg-card p-3 text-left",
          data.seats === 0 ? "opacity-60" : "active:scale-[0.99]"
        )}
      >
        <span className="grid h-10 w-10 place-items-center rounded-full bg-brand/10 text-primary">
          <CalendarClock className="h-5 w-5" />
        </span>
        <div className="min-w-0 flex-1">
          <div className="font-semibold leading-tight">{_L("phone.reserve.title")}</div>
          <div className="text-[0.7rem] text-muted-foreground">
            {/* A reservation HOLDS SEATS now — there is no private booth to enter, so
                the copy promises what it actually does. */}
            {data.seats === 0 ? _L("phone.reserve.no_seats") : _L("phone.reserve.storefront_hint")}
          </div>
        </div>
        {data.seats !== 0 && <ChevronRight className="h-4 w-4 text-muted-foreground" />}
      </button>

      {/* menu sections */}
      {Object.entries(groups).map(([g, list]) => (
        <section key={g} className="mt-4">
          <h2 className="mb-2 px-4 font-display text-base font-bold">{g}</h2>
          <div className="divide-y divide-border">
            {list.map((it) => (
              <button
                key={it.key}
                onClick={() => setSheet({ item: it })}
                className="flex w-full items-center gap-3 px-4 py-2.5 text-left active:bg-muted/40"
              >
                <ItemImg src={it.image} className="h-16 w-16 rounded-xl" />
                <div className="min-w-0 flex-1">
                  <div className="font-semibold leading-tight">{it.label}</div>
                  <div className="mt-1 font-mono text-sm text-muted-foreground">
                    {money(currency, it.price)}
                  </div>
                </div>
                <span className="grid h-8 w-8 place-items-center rounded-full bg-brand text-brand-ink">
                  <Plus className="h-4 w-4" strokeWidth={3} />
                </span>
              </button>
            ))}
          </div>
        </section>
      ))}

      {(data.catalog?.length || 0) === 0 && (
        <Empty title={_L("phone.rest.empty_menu")} hint={_L("phone.rest.empty_menu_hint")} />
      )}

      {sheet?.item && (
        <ItemSheet
          item={sheet.item}
          onClose={() => setSheet(null)}
          onAdd={(qty, st) => {
            addLine(sheet.item!, qty, st);
            setSheet(null);
          }}
        />
      )}
    </Screen>
  );
}

// ─── checkout ─────────────────────────────────────────────────────────────────
// Label lookups are resolved per render, never at module scope — the locale table
// arrives from Lua after this module is imported.
const TYPES = [
  { id: "delivery", key: "phone.order_type.delivery", icon: Truck },
  { id: "pickup", key: "phone.order_type.pickup", icon: ShoppingBag },
  { id: "dine_in", key: "phone.order_type.dine_in", icon: Utensils },
];
const SCHED = [
  { id: "", key: "phone.checkout.sched_asap" },
  { id: "+15", key: "phone.checkout.sched_15" },
  { id: "+30", key: "phone.checkout.sched_30" },
  { id: "+60", key: "phone.checkout.sched_60" },
];

export function Checkout({ params }: { params: any }) {
  const { cart, setQty, clearCart, currency, back, go, refreshHome, toast } = usePhone();
  const [type, setType] = useState("delivery");
  const [sched, setSched] = useState("");
  const [redeem, setRedeem] = useState(false);
  const [placing, setPlacing] = useState(false);
  const [menu, setMenu] = useState<any>(null);

  useEffect(() => {
    if (cart)
      fetchNui("phone:menu", { id: cart.rid }).then((d) => {
        if (d?.ok) setMenu(d);
      });
  }, [cart?.rid]);

  const subtotal = cart ? cart.lines.reduce((n, l) => n + l.price * l.qty, 0) : 0;
  const promoPct = menu?.promo?.percent || 0;
  const canRedeem = menu?.loyalty?.on && (menu?.loyalty?.punches || 0) >= (menu?.loyalty?.goal || 999);
  const cheapest = cart?.lines.length ? Math.min(...cart.lines.map((l) => l.price)) : 0;
  const redeemOff = redeem && canRedeem ? cheapest : 0;
  const total = Math.max(0, Math.round((subtotal - redeemOff) * (100 - promoPct)) / 100);

  if (!cart) {
    return (
      <Screen>
        <TopBar title={_L("phone.checkout.title")} onBack={back} />
        <Empty
          icon={<ShoppingBag className="h-8 w-8" />}
          title={_L("phone.checkout.empty")}
          hint={_L("phone.checkout.empty_hint")}
        />
      </Screen>
    );
  }

  const place = async () => {
    setPlacing(true);
    const serverCart = cart.lines.map((l) => ({ key: l.key, qty: l.qty, mods: l.mods }));
    const res = await fetchNui("phone:placeOrder", {
      id: cart.rid,
      cart: serverCart,
      orderType: type,
      scheduled: sched || null,
      redeem: redeem && canRedeem,
    });
    setPlacing(false);
    if (res?.ok) {
      toast(_L("phone.checkout.placed", res.ticket));
      clearCart();
      await refreshHome();
      go("order", { orderId: res.orderId, rid: cart.rid });
    } else {
      toast(res?.error || _L("phone.checkout.place_failed"), "err");
    }
  };

  const saveFav = async () => {
    const serverCart = cart.lines.map((l) => ({ key: l.key, qty: l.qty, mods: l.mods }));
    const res = await fetchNui("phone:saveFavorite", { id: cart.rid, label: cart.label, cart: serverCart });
    if (res?.ok) {
      toast(_L("phone.checkout.saved_fav"));
      refreshHome();
    } else toast(res?.error || _L("phone.checkout.save_failed"), "err");
  };

  return (
    <Screen className="pb-4">
      <TopBar
        title={_L("phone.checkout.title")}
        subtitle={cart.label}
        onBack={back}
        right={
          <button
            onClick={saveFav}
            className="grid h-8 w-8 place-items-center rounded-full bg-muted"
            title={_L("phone.checkout.save_for_later")}
          >
            <Heart className="h-4 w-4" />
          </button>
        }
      />
      <div className="space-y-4 p-4">
        {/* type */}
        <div>
          <div className="tape mb-1.5 text-muted-foreground">{_L("phone.checkout.how")}</div>
          <div className="grid grid-cols-3 gap-2">
            {TYPES.map((t) => {
              const Icon = t.icon;
              return (
                <button
                  key={t.id}
                  onClick={() => setType(t.id)}
                  className={cn(
                    "flex flex-col items-center gap-1 rounded-2xl border py-3 active:scale-[0.98]",
                    type === t.id ? "border-brand bg-brand/10 text-primary" : "border-border bg-card"
                  )}
                >
                  <Icon className="h-5 w-5" />
                  <span className="text-[0.72rem] font-semibold">{_L(t.key)}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* schedule */}
        <div>
          <div className="tape mb-1.5 flex items-center gap-1 text-muted-foreground">
            <Clock className="h-3 w-3" /> {_L("phone.checkout.when")}
          </div>
          <div className="pf-rail">
            {SCHED.map((s) => (
              <button
                key={s.id}
                onClick={() => setSched(s.id)}
                className={cn(
                  "rounded-full border px-3 py-1.5 text-[0.76rem] font-semibold",
                  sched === s.id ? "border-brand bg-brand text-brand-ink" : "border-border bg-card"
                )}
              >
                {_L(s.key)}
              </button>
            ))}
          </div>
          <p className="mt-1 text-[0.68rem] text-muted-foreground">
            {_L("phone.checkout.sched_hint")}
          </p>
        </div>

        {/* lines */}
        <div className="rounded-2xl border border-border bg-card">
          {cart.lines.map((l) => (
            <div key={l.uid} className="flex items-center gap-3 border-b border-border px-3 py-2.5 last:border-0">
              <ItemImg src={l.image} className="h-11 w-11 rounded-lg" />
              <div className="min-w-0 flex-1">
                <div className="truncate text-sm font-semibold">{l.label}</div>
                {l.modLabels.length > 0 && (
                  <div className="truncate text-[0.68rem] text-muted-foreground">
                    {l.modLabels.join(" · ")}
                  </div>
                )}
              </div>
              <div className="flex items-center gap-2 rounded-full border border-border px-1.5 py-0.5">
                <button onClick={() => setQty(l.uid, l.qty - 1)}>
                  <Minus className="h-3.5 w-3.5" />
                </button>
                <span className="w-4 text-center font-mono text-sm">{l.qty}</span>
                <button onClick={() => setQty(l.uid, Math.min(10, l.qty + 1))}>
                  <Plus className="h-3.5 w-3.5" />
                </button>
              </div>
              <div className="w-14 text-right font-mono text-sm">{money(currency, l.price * l.qty)}</div>
            </div>
          ))}
        </div>

        {/* loyalty redeem */}
        {canRedeem && (
          <button
            onClick={() => setRedeem((v) => !v)}
            className={cn(
              "flex w-full items-center gap-3 rounded-2xl border p-3 text-left active:scale-[0.99]",
              redeem ? "border-brand bg-brand/10" : "border-border bg-card"
            )}
          >
            <Ticket className={cn("h-5 w-5", redeem ? "text-primary" : "text-muted-foreground")} />
            <div className="flex-1">
              <div className="text-sm font-semibold">{_L("phone.checkout.redeem")}</div>
              <div className="text-[0.7rem] text-muted-foreground">
                {_L("phone.checkout.redeem_hint")}
              </div>
            </div>
            <span
              className={cn(
                "h-5 w-9 rounded-full p-0.5 transition-colors",
                redeem ? "bg-brand" : "bg-muted"
              )}
            >
              <span className={cn("block h-4 w-4 rounded-full bg-white transition-transform", redeem && "translate-x-4")} />
            </span>
          </button>
        )}

        {/* totals */}
        <div className="space-y-1 rounded-2xl border border-border bg-card p-3 font-mono text-sm">
          <Row label={_L("phone.checkout.subtotal")} value={money(currency, subtotal)} />
          {promoPct > 0 && (
            <Row
              label={_L("phone.checkout.promo_row", promoPct)}
              value={`-${money(currency, (subtotal * promoPct) / 100)}`}
              accent
            />
          )}
          {redeemOff > 0 && (
            <Row label={_L("phone.checkout.free_item")} value={`-${money(currency, redeemOff)}`} accent />
          )}
          <div className="my-1 border-t border-border" />
          <Row label={_L("phone.checkout.total")} value={money(currency, total)} big />
        </div>
      </div>

      <div className="px-4">
        <button
          disabled={placing}
          onClick={place}
          className="flex w-full items-center justify-center gap-2 rounded-full bg-brand px-4 py-3.5 font-bold text-brand-ink active:scale-[0.99] disabled:opacity-60"
        >
          {placing
            ? _L("phone.checkout.placing")
            : _L("phone.checkout.place", money(currency, total))}
        </button>
      </div>
    </Screen>
  );
}

function Row({ label, value, big, accent }: { label: string; value: string; big?: boolean; accent?: boolean }) {
  return (
    <div className={cn("flex justify-between", big && "text-base font-bold")}>
      <span className={cn(!big && "text-muted-foreground", accent && "text-primary")}>{label}</span>
      <span className={accent ? "text-primary" : ""}>{value}</span>
    </div>
  );
}
