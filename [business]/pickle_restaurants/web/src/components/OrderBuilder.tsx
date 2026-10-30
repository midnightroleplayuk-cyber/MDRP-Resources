import { useEffect, useMemo, useState } from "react";
import { fetchNui } from "@/lib/nui";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { money, cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { flavorModImageUrl, itemImageUrl } from "@/lib/localImages";
import {
  Plus, Minus, Trash2, User, Receipt, Check, X, Loader2, ImageOff, SlidersHorizontal, Ban, ShoppingBag,
  Wallet, Banknote, CreditCard,
} from "lucide-react";

// Shared point-of-sale building blocks used by the staff register — both the
// full-screen NUI panel (views/Register.tsx) and the in-world register DUI
// (views/RegisterDui.tsx) — and the customer self-service kiosk DUI
// (views/KioskDui.tsx), so the catalog grid, modifier picker, cart and pricing can
// never drift between them. The kiosk's only behavioural differences: no "who pays"
// customer picker (the customer always pays for their own order) and a different
// submit event. The `big` prop selects the large in-world layout independently of
// those behaviours (see the OrderBuilder doc-comment).

export type Mod = { id: string; label: string; item?: string; price?: number; default?: boolean; image?: string; group?: string; color?: string };
export type Cat = { key: string; item: string; variant: string; label: string; kind: string; group?: string; price: number; image?: string; modifiers?: Mod[] };
export type LineMod = { id?: string; label: string; price?: number; added?: boolean; removed?: boolean; image?: string; color?: string };
export type Line = { item: string; variant: string; label: string; price: number; qty: number; kind: string; image?: string; mods?: LineMod[] };

// Group a ticket's lines into render blocks. Kept as a (now trivial) indirection so
// the ticket renderers stay one shape regardless of how lines are grouped later.
export type LineBlock = { type: "item"; line: Line };
export function groupLines(lines: Line[]): LineBlock[] {
  return lines.map((line) => ({ type: "item" as const, line }));
}
// A selected option to render as an image chip (added extra, or a removed default).
export type OptView = { label: string; image?: string; color?: string };
// One layer of a meal, spelled out for the in-depth picker: the item's label +
// image, plus its toppings (cheese/lettuce as item images, frosting/sprinkles as
// coloured swatches).
export type MealItem = { item: string; label: string; image?: string; mods?: OptView[] };
// A meal in the shared pool that (with single items) would complete the whole
// order — offered as a fulfillment option. `items` is its full contents.
// A packed VESSEL in the pool that can fill a ticket: a serving-tray meal or a
// takeaway Restaurant Bag (`bag`). `item` is the inventory item handed over — it
// rides back to the server on fulfilment so it knows which one to consume.
// `covers` is what this package would take OFF the ticket, keyed by the same
// "item|variation" id the ticket's `needs` use — the picker adds it up across
// everything selected, which is how a pizza in one box and a cake in another
// together complete an order neither could alone. `completes` is the one-package
// case; `count` is how many identical copies of this exact packing are in the pool.
export type MealOption = {
  sig: string; item?: string; bag?: boolean; label: string; items?: MealItem[];
  covers?: Record<string, number>; completes?: boolean; count?: number;
};
// One thing the ticket still needs PACKED (the loose pool can't cover it).
export type VesselNeed = { id: string; item: string; label: string; need: number };
// Per-ticket fulfillment state from the shared cooked-items pool (server-computed).
// `ok` = completable as it stands (singles, plus any vessels the server claims by
// itself); `mealOptions` = packages that carry something the ticket asked for;
// `needs` = what must come packed; `missing` = the shortfall when nothing covers it.
export type Fulfill = { ok: boolean; mealOptions?: MealOption[]; needs?: VesselNeed[]; missing?: string[] };
// `npc` flags an AI walk-in customer; those carry a patience countdown (`expiresIn`
// seconds left at send time, ticked down locally) out of `patience` total seconds
// (the radial's denominator). Player tickets have npc=false and no timer fields.
// `channel` is how the order arrived (delivery / pickup / dine_in / walk_in), resolved
// server-side by OrderChannel; `npc` is orthogonal (an AI customer can order delivery).
// `address` / `driver` are the delivery's drop point and whoever claimed the run.
export type Ticket = { orderId: number; ticket: number; customer: string; lines: Line[]; total: number; fulfill?: Fulfill; npc?: boolean; expiresIn?: number; patience?: number; channel?: string; orderType?: string; address?: string; scheduled?: string; driver?: { name?: string; server?: number } };
export type Near = { id: number; name: string };
// A cart entry: one catalog item — which item, how many, selected modifier ids.
export type CartEntry = { type: "item"; catKey: string; qty: number; sel: string[] };

// A resolved cart row for rendering/pricing: the item + its added/removed mods.
type CartBlock = { ck: string; type: "item"; cat: Cat; qty: number; price: number; added: Mod[]; removed: Mod[] };

// Coerce a server list to a real array. Lua/JSON encodes an EMPTY list as `{}`
// (an object, not `[]`), so a plain `x || []` would keep that `{}` and any
// `.map`/`.filter` on it would throw and take the whole panel down.
export const arr = <T,>(x: unknown): T[] => (Array.isArray(x) ? (x as T[]) : []);

// Inventory thumbnail from a direct nui:// url the server resolved, with a
// graceful fallback (different inventories store images differently). `fallbackSrc`
// is tried if `src` is absent or fails to load — used so a supplied per-flavor
// drink image (web/public/items/) that isn't present degrades to the generic
// inventory image we showed before, then to the placeholder.
export function Thumb({ src, fallbackSrc, className }: { src?: string; fallbackSrc?: string; className?: string }) {
  const chain = [src, fallbackSrc].filter(Boolean) as string[];
  const [idx, setIdx] = useState(0);
  useEffect(() => setIdx(0), [src, fallbackSrc]);
  const cur = chain[idx];
  if (!cur) {
    return (
      <div className={cn("flex items-center justify-center rounded bg-muted/60 text-muted-foreground", className)}>
        <ImageOff className="h-1/2 w-1/2" />
      </div>
    );
  }
  return <img src={cur} onError={() => setIdx((i) => i + 1)} className={cn("rounded object-contain", className)} />;
}

// A drink flavor's picker art. Tries the supplied per-flavor image FIRST (that's
// the curated art the server dropped in web/public/items/), then any inventory
// image the flavor's legacy item still has, then the flavor's colour swatch, then
// a placeholder — so supplied art always wins and an unsupplied flavor degrades to
// exactly what the tile showed before, never a broken icon.
function FlavorThumb({ src, fallbackSrc, color, className }: { src?: string; fallbackSrc?: string; color?: string; className?: string }) {
  const chain = [src, fallbackSrc].filter(Boolean) as string[];
  const [idx, setIdx] = useState(0);
  useEffect(() => setIdx(0), [src, fallbackSrc]);
  const cur = chain[idx];
  if (cur) return <img src={cur} onError={() => setIdx((i) => i + 1)} className={cn("rounded object-contain", className)} />;
  if (color) return <span className={cn("rounded-full border border-border", className)} style={{ backgroundColor: color }} />;
  return <div className={cn("grid place-items-center rounded bg-muted/60 text-muted-foreground", className)}><ImageOff className="h-1/2 w-1/2" /></div>;
}

// The image a drink card/line/option shows. A drink's own image is the empty
// generic drink item, so it borrows a real flavor's art instead of a placeholder:
// the CHOSEN flavor when the selection is known (a cart line), else the
// FIRST flavor (catalog grid card, mirroring the dialog header). Returns undefined
// for non-drinks (callers keep the item's own image); every caller still falls back
// to items/<item>.png.
function drinkCardSrc(cat: { kind?: string; modifiers?: { id: string }[] }, chosen?: { id: string }[]): string | undefined {
  if (cat.kind !== "drink") return undefined;
  const sel = chosen?.find((m) => m.id.startsWith("flavor:"))?.id;
  const first = cat.modifiers?.find((m) => m.id.startsWith("flavor:"))?.id;
  return flavorModImageUrl(sel ?? first);
}

export const KIND_LABEL: Record<string, string> = {
  recipe: "register.kind_recipe",
  assembly: "register.kind_assembly",
  craft: "register.kind_craft",
  drink: "register.kind_drink",
  finish: "register.kind_finish",
};

// The additions (+X) / removals (no Y) a selection implies, plus the price the
// selected add-ons add on top of the base — computed identically on the server.
export function resolveMods(cat: Cat, sel: string[]) {
  const set = new Set(sel);
  const added: Mod[] = [], removed: Mod[] = [];
  let extra = 0;
  for (const m of cat.modifiers || []) {
    const on = set.has(m.id);
    if (on && !m.default) { added.push(m); extra += m.price || 0; }
    else if (m.default && !on) removed.push(m);
  }
  return { added, removed, extra };
}

// A single selected-option chip: the modifier's item image (or a flavor colour
// swatch), captioned by its label on hover. A removed default is dimmed and
// crossed out so "no lettuce" reads at a glance without any text. Styled for
// the receipt paper it always sits on (cart lines, tickets).
export function OptChip({ o, removed }: { o: OptView; removed?: boolean }) {
  return (
    <span
      title={(removed ? _L("register.opt_no") + " " : "") + o.label}
      className={cn(
        "relative flex h-6 w-6 shrink-0 items-center justify-center rounded border bg-muted",
        removed ? "border-destructive/50" : "border-border",
      )}
    >
      {o.image
        ? <Thumb src={o.image} className={cn("h-5 w-5", removed && "opacity-40")} />
        : o.color
          ? <span className={cn("h-4 w-4 rounded-full border border-border", removed && "opacity-40")} style={{ backgroundColor: o.color }} />
          : <div className={cn("grid h-5 w-5 place-items-center rounded text-muted-foreground", removed && "opacity-40")}><ImageOff className="h-3 w-3" /></div>}
      {removed && (
        <span className="pointer-events-none absolute inset-0 flex items-center justify-center text-destructive"><Ban className="h-4 w-4" /></span>
      )}
    </span>
  );
}

// The secondary row of an item line: its selected options rendered as image
// chips (added extras first, then crossed-out removed defaults). Empty = nothing.
export function OptRow({ added, removed }: { added: OptView[]; removed: OptView[] }) {
  if (added.length === 0 && removed.length === 0) return null;
  return (
    <div className="mt-1 flex flex-wrap items-center gap-1">
      {added.map((o, i) => <OptChip key={"a" + i} o={o} />)}
      {removed.map((o, i) => <OptChip key={"r" + i} o={o} removed />)}
    </div>
  );
}

// A single modifier tile: item image, or a flavor colour swatch, or a fallback.
// `big` scales it up for the kiosk's larger dialogs.
function ModTile({ m, on, onClick, big }: { m: Mod; on: boolean; onClick: () => void; big?: boolean }) {
  // a drink flavor modifier (id "flavor:<output>") prefers its supplied per-flavor
  // art (web/public/items/<output>.png) over the flavor's legacy inventory image,
  // then that image, then its colour swatch (all handled by FlavorThumb)
  const flavorImg = flavorModImageUrl(m.id);
  const sz = big ? "h-16 w-16" : "h-12 w-12";
  return (
    <button onClick={onClick}
      className={cn("relative flex flex-col items-center rounded-lg border text-center transition-colors",
        big ? "gap-1.5 p-3" : "gap-1 p-2",
        on ? "border-primary bg-primary/10 ring-1 ring-primary" : "border-border hover:border-primary/50 hover:bg-accent/50")}>
      {on && (
        <span className={cn("absolute right-1 top-1 grid place-items-center rounded-full bg-primary text-primary-foreground", big ? "h-5 w-5" : "h-4 w-4")}>
          <Check className={big ? "h-3.5 w-3.5" : "h-3 w-3"} />
        </span>
      )}
      {flavorImg
        ? <FlavorThumb src={flavorImg} fallbackSrc={m.image} color={m.color} className={sz} />
        : m.image
          ? <Thumb src={m.image} className={sz} />
        : m.color
          ? <span className={cn("rounded-full border border-border", sz)} style={{ backgroundColor: m.color }} />
          : <div className={cn("grid place-items-center rounded bg-muted/60 text-muted-foreground", sz)}><ImageOff className="h-1/2 w-1/2" /></div>}
      <span className={cn("line-clamp-2 font-medium leading-tight", big ? "text-sm" : "text-xs")}>
        {m.label}
        {m.default && <span className={cn("ml-1 text-muted-foreground", big ? "text-[11px]" : "text-[9px]")}>{_L("register.mod_default")}</span>}
      </span>
      {!!m.price && !m.default && <span className={cn("text-muted-foreground", big ? "text-sm" : "text-[11px]")}>+{money(m.price)}</span>}
    </button>
  );
}

function FilterChip({ active, onClick, big, children }: { active: boolean; onClick: () => void; big?: boolean; children: React.ReactNode }) {
  return (
    <button onClick={onClick}
      className={cn("rounded-full border font-mono font-semibold uppercase tracking-wider transition-colors",
        big ? "px-5 py-2.5 text-base" : "px-2.5 py-1 text-[10px]",
        active ? "border-primary/40 bg-primary/15 text-primary" : "border-border text-muted-foreground hover:bg-accent hover:text-foreground")}>
      {children}
    </button>
  );
}

// The who-pays selector on the in-world register DUI's review sheet: a click target
// (not a native <select>, which the virtual cursor can't open) for "Myself" + each
// nearby player the cashier can charge.
function CustomerChip({ active, onClick, children }: { active: boolean; onClick: () => void; children: React.ReactNode }) {
  return (
    <button onClick={onClick}
      className={cn("rounded-full border px-4 py-2 text-base font-medium transition-colors",
        active ? "border-primary bg-primary/15 text-primary ring-1 ring-primary" : "border-border text-muted-foreground hover:bg-accent hover:text-foreground")}>
      {children}
    </button>
  );
}

// The catalog + modifier picker + cart. In "register" mode the cashier can charge
// a nearby player (the customer picker); in "kiosk" mode the customer always pays
// for their own order (no picker) and the submit reads "Place Order". `onOrdered`
// fires with the new ticket number after a successful submit.
//
// `big` forces the large, in-world layout (big cards + a checkout review sheet)
// used on an interactive DUI screen, whose virtual cursor needs generous aim
// targets. The kiosk mode always implies it; the staff register DUI passes it
// explicitly while keeping register SEMANTICS (the customer picker + "Charge" +
// createOrder). The full-screen register NUI leaves it off for the dense POS layout.
export function OrderBuilder({
  id, catalog, nearby, mode, big: bigProp, onOrdered,
}: {
  id: number;
  catalog: Cat[];
  nearby?: Near[];
  mode: "register" | "kiosk";
  big?: boolean;
  onOrdered?: (ticket?: number) => void;
}) {
  const [cart, setCart] = useState<Record<string, CartEntry>>({});
  const [customer, setCustomer] = useState(0); // 0 = Myself
  const [kind, setKind] = useState<string>("all");
  const [busy, setBusy] = useState(false);
  const [modFor, setModFor] = useState<Cat | null>(null); // item being customised
  const [modSel, setModSel] = useState<string[]>([]);
  const [modQty, setModQty] = useState(1); // how many to add from the item dialog
  const [reviewing, setReviewing] = useState(false); // kiosk: the cart-review sheet is open
  // Cash or card. Cash leads because it is what a counter has always taken here, and
  // it is the wallet a customer standing at a till is most likely to reach for; the
  // server normalises whatever arrives, so this only chooses a default.
  const [payment, setPayment] = useState<"cash" | "bank">("cash");

  // Group by the admin-authored `group` label (e.g. "Sandwiches", "Drinks") rather
  // than the internal `kind` string ("recipe", "assembly"…). Ungrouped items fall
  // into a sentinel "" bucket that sorts last, matching BuildMenuBoard's order.
  const UNGROUPED = "";
  const kinds = useMemo(() => {
    const seen = new Set<string>();
    const groups: string[] = [];
    for (const c of catalog) {
      const g = c.group || UNGROUPED;
      if (!seen.has(g)) { seen.add(g); groups.push(g); }
    }
    // Sort: named groups case-insensitive, ungrouped last.
    groups.sort((a, b) => {
      if (a === UNGROUPED && b !== UNGROUPED) return 1;
      if (b === UNGROUPED && a !== UNGROUPED) return -1;
      return a.toLowerCase().localeCompare(b.toLowerCase());
    });
    return groups;
  }, [catalog]);
  const shown = kind === "all" ? catalog : catalog.filter((c) => (c.group || UNGROUPED) === kind);
  const byKey = useMemo(() => Object.fromEntries(catalog.map((c) => [c.key, c])), [catalog]);

  const itemCartKey = (catKey: string, sel: string[]) => "i#" + catKey + "#" + [...sel].sort().join(",");

  const addItemEntry = (catKey: string, sel: string[], qty = 1) => setCart((c) => {
    const ck = itemCartKey(catKey, sel);
    const prev = c[ck];
    return { ...c, [ck]: { type: "item", catKey, sel, qty: Math.min(10, (prev?.qty || 0) + qty) } };
  });
  const changeQty = (ck: string, delta: number) => setCart((c) => {
    const prev = c[ck]; if (!prev) return c;
    const q = Math.min(10, prev.qty + delta);
    const next = { ...c };
    if (q <= 0) delete next[ck]; else next[ck] = { ...prev, qty: q };
    return next;
  });
  const removeEntry = (ck: string) => setCart((c) => { const n = { ...c }; delete n[ck]; return n; });

  // The modifier ids a freshly-opened option starts with: its defaults, plus — for a
  // drink (a single-choice flavor group with no default) — the first flavor, so the
  // picker always opens with a flavor chosen (a drink must carry one).
  const seedSel = (c?: { kind?: string; modifiers?: Mod[] }): string[] => {
    const base = (c?.modifiers || []).filter((m) => m.default).map((m) => m.id);
    if (c?.kind === "drink" && !base.length && c.modifiers && c.modifiers.length) base.push(c.modifiers[0].id);
    return base;
  };
  // Click a card: always open the item dialog (choose modifiers + quantity, then
  // add) — even a plain item with no modifiers gets a confirming "Add to Order"
  // step and a quantity picker, so the register matches the kiosk exactly.
  const clickCard = (c: Cat) => {
    setModFor(c);
    setModSel(seedSel(c));
    setModQty(1);
  };
  // Ungrouped modifiers toggle freely; a grouped modifier is single-choice —
  // picking one clears the rest of its group, clicking the picked one = none.
  const toggleModOn = (mods: Mod[], sel: string[], m: Mod): string[] => {
    if (!m.group) return sel.includes(m.id) ? sel.filter((x) => x !== m.id) : [...sel, m.id];
    const groupIds = new Set(mods.filter((x) => x.group === m.group).map((x) => x.id));
    const without = sel.filter((x) => !groupIds.has(x));
    return sel.includes(m.id) ? without : [...without, m.id];
  };
  const toggleMod = (m: Mod) => setModSel((s) => toggleModOn(modFor?.modifiers || [], s, m));
  // Cart blocks — one resolved row per cart entry.
  const blocks = Object.entries(cart).map(([ck, e]) => {
    const cat = byKey[e.catKey];
    if (!cat) return null;
    const { added, removed, extra } = resolveMods(cat, e.sel);
    return { ck, type: "item" as const, cat, qty: e.qty, price: cat.price + extra, added, removed };
  }).filter(Boolean) as CartBlock[];
  const total = blocks.reduce((s, b) => s + b.price * b.qty, 0);
  const count = blocks.reduce((s, b) => s + b.qty, 0);

  // The wire form of the cart: keys + counts + modifier ids, never labels or prices —
  // the server re-derives those from its own priced catalog.
  const cartWire = () => Object.values(cart).map((e) => ({ key: e.catKey, qty: e.qty, mods: e.sel }));

  const submit = async () => {
    if (blocks.length === 0 || busy) return;
    setBusy(true);
    const cartArr = cartWire();
    const event = mode === "kiosk" ? "sales:kioskOrder" : "sales:createOrder";
    const payload = mode === "kiosk"
      ? { id, cart: cartArr, payment }
      : { id, customer, cart: cartArr, payment };
    const res: any = await fetchNui(event, payload);
    setBusy(false);
    if (res && res.ok) {
      setCart({}); // register: the new ticket arrives via the `orders` broadcast
      onOrdered?.(res.ticket);
    }
  };

  const modExtra = modFor ? resolveMods(modFor, modSel).extra : 0;
  // The customise dialog's header image. For a drink the generic "Restaurant Drink"
  // has no art of its own, so the CHOSEN flavor's image leads; otherwise the item's
  // own image, then a supplied items/<item>.png (e.g. a generic drink.png).
  const selFlavorId = modFor?.modifiers?.find((m) => modSel.includes(m.id) && m.id.startsWith("flavor:"))?.id;
  const modHeaderSrc = flavorModImageUrl(selFlavorId) ?? modFor?.image;
  const modHeaderFallback = itemImageUrl(modFor?.item);
  // Large in-world layout: the kiosk always, and the staff register DUI on request.
  // Drives every SIZE/LAYOUT decision below; `mode` still drives BEHAVIOUR (who-pays
  // picker, submit event + button copy), so the register DUI reads big but still
  // charges a customer.
  const big = mode === "kiosk" || !!bigProp;

  // Cash / card. Chips, not a native <select>: the in-world screens are driven by a
  // virtual cursor that cannot open a native dropdown (the same reason the big
  // layout's customer picker is a chip row).
  const payRow = (big = false) => (
    <div>
      <div className={cn("tape flex items-center gap-2 text-muted-foreground", big ? "mb-1.5" : "mb-1")}>
        <Wallet className={big ? "h-4 w-4" : "h-3.5 w-3.5"} /> {_L("register.payment")}
      </div>
      <div className="flex gap-2">
        {(["cash", "bank"] as const).map((p) => (
          <button key={p} onClick={() => setPayment(p)}
            className={cn("flex items-center gap-2 rounded-full border font-medium transition-colors",
              big ? "px-4 py-2 text-base" : "px-3 py-1 text-xs",
              payment === p
                ? "border-primary bg-primary/15 text-primary ring-1 ring-primary"
                : "border-border text-muted-foreground hover:bg-accent hover:text-foreground")}>
            {p === "cash" ? <Banknote className={big ? "h-5 w-5" : "h-3.5 w-3.5"} /> : <CreditCard className={big ? "h-5 w-5" : "h-3.5 w-3.5"} />}
            {_L(p === "cash" ? "register.pay_cash" : "register.pay_card")}
          </button>
        ))}
      </div>
    </div>
  );

  // Quantity stepper + remove for a cart row. `big` scales it up for the kiosk
  // review sheet (the in-world screen needs larger touch/aim targets).
  const qtyCtrl = (b: CartBlock, big = false) => (
    <div className={cn("flex shrink-0 items-center", big ? "gap-2" : "gap-1")}>
      <button onClick={() => changeQty(b.ck, -1)} className={cn("grid place-items-center rounded border border-border transition-colors hover:bg-accent", big ? "h-10 w-10" : "h-6 w-6")}><Minus className={big ? "h-5 w-5" : "h-3 w-3"} /></button>
      <span className={cn("text-center font-mono tabular-nums", big ? "w-8 text-lg" : "w-5 text-xs")}>{b.qty}</span>
      <button onClick={() => changeQty(b.ck, 1)} className={cn("grid place-items-center rounded border border-border transition-colors hover:bg-accent", big ? "h-10 w-10" : "h-6 w-6")}><Plus className={big ? "h-5 w-5" : "h-3 w-3"} /></button>
      <button onClick={() => removeEntry(b.ck)} className={cn("grid place-items-center rounded text-muted-foreground transition-colors hover:text-destructive", big ? "h-10 w-10" : "h-6 w-6")}><Trash2 className={big ? "h-5 w-5" : "h-3 w-3"} /></button>
    </div>
  );

  // One cart row. Shared by the register receipt (`big=false`) and the kiosk
  // review sheet (`big=true`).
  const cartLine = (b: CartBlock, big = false) => {
      return (
        <div key={b.ck} className={cn("flex items-center rounded-sm bg-muted/50", big ? "gap-4 p-4" : "gap-2 p-1.5")}>
          <Thumb src={drinkCardSrc(b.cat, b.added) ?? b.cat.image} fallbackSrc={itemImageUrl(b.cat.item)} className={cn("shrink-0", big ? "h-16 w-16" : "h-8 w-8")} />
          <div className="min-w-0 flex-1">
            <div className={cn("truncate font-medium", big ? "text-lg" : "text-xs")}>{b.cat.label}</div>
            <OptRow added={b.added} removed={b.removed} />
            <div className={cn("font-mono tabular-nums text-muted-foreground", big ? "text-base" : "text-[11px]")}>{money(b.price)}</div>
          </div>
          {qtyCtrl(b, big)}
        </div>
      );
  };

  // The modifier dialog is an absolute overlay shared by both layouts (register
  // grid and kiosk column).
  const dialogs = (
    <>
      {/* modifier dialog */}
      {modFor && (
        <div className={cn(big ? "fixed" : "absolute", "inset-0 z-40 flex items-center justify-center bg-black/50", big ? "p-10" : "p-4")} onClick={() => setModFor(null)}>
          <div className={cn("w-full rounded-2xl border border-border bg-card shadow-xl", big ? "max-w-xl p-6" : "max-w-sm p-4")} onClick={(e) => e.stopPropagation()}>
            <div className={cn("flex items-center", big ? "mb-5 gap-4" : "mb-3 gap-2")}>
              <Thumb src={modHeaderSrc} fallbackSrc={modHeaderFallback} className={cn("shrink-0", big ? "h-16 w-16" : "h-10 w-10")} />
              <div className="min-w-0 flex-1">
                <div className={cn("truncate font-semibold", big && "text-2xl")}>{modFor.label}</div>
                <div className={cn("text-muted-foreground", big ? "text-lg" : "text-xs")}>{money(modFor.price)}</div>
              </div>
              <button onClick={() => setModFor(null)} className="text-muted-foreground hover:text-foreground"><X className={big ? "h-7 w-7" : "h-4 w-4"} /></button>
            </div>
            {(modFor.modifiers || []).length > 0 && (
              <div className={cn("overflow-y-auto p-0.5", big ? "max-h-[46vh] space-y-4" : "max-h-72 space-y-3")}>
                {(() => {
                  const all = modFor.modifiers || [];
                  const ungrouped = all.filter((m) => !m.group);
                  const groupNames = Array.from(new Set(all.filter((m) => m.group).map((m) => m.group as string)));
                  return (
                    <>
                      {ungrouped.length > 0 && (
                        <div className="grid grid-cols-3 gap-2">
                          {ungrouped.map((m) => <ModTile key={m.id} m={m} big={big} on={modSel.includes(m.id)} onClick={() => toggleMod(m)} />)}
                        </div>
                      )}
                      {groupNames.map((g) => (
                        <div key={g}>
                          <div className={cn("mb-1 font-semibold uppercase tracking-wide text-muted-foreground", big ? "text-sm" : "text-xs")}>{g}</div>
                          <div className="grid grid-cols-3 gap-2">
                            {all.filter((m) => m.group === g).map((m) => <ModTile key={m.id} m={m} big={big} on={modSel.includes(m.id)} onClick={() => toggleMod(m)} />)}
                          </div>
                        </div>
                      ))}
                    </>
                  );
                })()}
              </div>
            )}
            <div className={cn("flex items-center justify-between gap-3", big ? "mt-5" : "mt-3")}>
              <div className={cn("flex items-center", big ? "gap-3" : "gap-2")}>
                <button onClick={() => setModQty((q) => Math.max(1, q - 1))} disabled={modQty <= 1}
                  className={cn("grid place-items-center rounded-md border border-border transition-colors hover:bg-accent disabled:opacity-40", big ? "h-12 w-12" : "h-9 w-9")}><Minus className={big ? "h-6 w-6" : "h-4 w-4"} /></button>
                <span className={cn("text-center font-mono font-semibold tabular-nums", big ? "w-10 text-2xl" : "w-8 text-lg")}>{modQty}</span>
                <button onClick={() => setModQty((q) => Math.min(10, q + 1))} disabled={modQty >= 10}
                  className={cn("grid place-items-center rounded-md border border-border transition-colors hover:bg-accent disabled:opacity-40", big ? "h-12 w-12" : "h-9 w-9")}><Plus className={big ? "h-6 w-6" : "h-4 w-4"} /></button>
              </div>
              <Button size={big ? "lg" : "sm"} className={cn(big && "h-14 gap-2.5 px-8 text-xl")} onClick={() => { addItemEntry(modFor.key, modSel, modQty); setModFor(null); }}>
                <Plus className={big ? "h-6 w-6" : "h-4 w-4"} /> {_L("register.add_to_order")} · {money((modFor.price + modExtra) * modQty)}
              </Button>
            </div>
          </div>
        </div>
      )}

    </>
  );

  // ── Kiosk layout ──────────────────────────────────────────────────────────
  // Portrait self-service screen: the menu owns the FULL width (big, readable
  // cards) and the cart collapses to a fixed footer (bag count + total + a single
  // Checkout button). Checkout opens a review sheet — the only place to edit qty
  // or remove, since the side receipt is gone — where the order is finally placed.
  if (big) {
    return (
      <div className="relative flex h-full flex-col bg-background">
        <div className="flex shrink-0 flex-wrap gap-2 px-5 pb-3 pt-5">
          <FilterChip big active={kind === "all"} onClick={() => setKind("all")}>{_L("register.all_items")}</FilterChip>
          {kinds.map((k) => (
            <FilterChip big key={k} active={kind === k} onClick={() => setKind(k)}>{k || _L("register.kind_recipe")}</FilterChip>
          ))}
        </div>

        <div className="min-h-0 flex-1 space-y-4 overflow-y-auto px-5 pb-4">
          {catalog.length === 0 && <div className="py-12 text-center text-base text-muted-foreground">{_L("register.no_catalog")}</div>}
            <div className="grid grid-cols-3 gap-4">
              {shown.map((c) => {
                const customisable = !!(c.modifiers && c.modifiers.length);
                return (
                  <button key={c.key} onClick={() => clickCard(c)}
                    className="relative flex flex-col items-center gap-3 rounded-2xl border border-border/80 bg-card p-5 text-center transition-colors hover:border-primary/50 hover:bg-accent/60 active:bg-accent">
                    {customisable && (
                      <span className="absolute right-3 top-3 text-primary/70" title={_L("register.customisable")}><SlidersHorizontal className="h-6 w-6" /></span>
                    )}
                    <Thumb src={drinkCardSrc(c) ?? c.image} fallbackSrc={itemImageUrl(c.item)} className="h-28 w-28" />
                    <span className="line-clamp-2 text-xl font-semibold leading-snug">{c.label}</span>
                    <span className="font-mono text-lg font-bold tabular-nums text-primary">{money(c.price)}</span>
                  </button>
                );
              })}
            </div>
        </div>

        {/* fixed footer — bag count, total, and the single Checkout button */}
        <div className="mx-5 mb-1 shrink-0 rounded-2xl border border-border bg-card px-6 py-4 shadow-lg">
          <div className="flex items-center gap-5">
            <div className="relative shrink-0">
              <ShoppingBag className="h-11 w-11 text-primary" />
              {count > 0 && (
                <span className="absolute -right-2 -top-2 grid h-7 min-w-7 place-items-center rounded-full bg-primary px-1.5 font-mono text-sm font-bold text-primary-foreground tabular-nums">{count}</span>
              )}
            </div>
            <div className="min-w-0 flex-1">
              <div className="tape text-base text-muted-foreground">{_L("register.total")}</div>
              <div className="font-mono text-4xl font-bold leading-none tabular-nums">{money(total)}</div>
            </div>
            <Button size="lg" className="h-20 shrink-0 gap-2.5 px-12 text-2xl" disabled={count === 0} onClick={() => setReviewing(true)}>
              <ShoppingBag className="h-7 w-7" /> {_L("order.checkout")}
            </Button>
          </div>
        </div>

        {/* review sheet — the full bag, editable, then Place Order */}
        {reviewing && (
          <div className="absolute inset-0 z-30 flex flex-col bg-background">
            <div className="flex shrink-0 items-center justify-between gap-3 border-b border-border px-6 py-5">
              <div className="font-display text-3xl font-semibold">{_L("order.review_title")}</div>
              <button onClick={() => setReviewing(false)} className="grid h-12 w-12 place-items-center rounded-full text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"><X className="h-7 w-7" /></button>
            </div>
            <div className="min-h-0 flex-1 space-y-3 overflow-y-auto px-6 py-4">
              {blocks.length === 0
                ? <div className="py-12 text-center text-lg text-muted-foreground">{_L("register.empty_cart")}</div>
                : blocks.map((b) => cartLine(b, true))}
            </div>
            <div className="shrink-0 space-y-3 border-t border-border bg-card px-6 py-4">
              {/* who pays — register only; a kiosk customer always pays for their own.
                  A click-based row (not a native <select>, which a virtual cursor on the
                  in-world screen can't drive). */}
              {mode === "register" && (
                <div>
                  <div className="tape mb-1.5 flex items-center gap-2 text-muted-foreground"><User className="h-4 w-4" /> {_L("register.customer")}</div>
                  <div className="flex flex-wrap gap-2">
                    <CustomerChip active={customer === 0} onClick={() => setCustomer(0)}>{_L("register.myself")}</CustomerChip>
                    {(nearby || []).map((p) => (
                      <CustomerChip key={p.id} active={customer === p.id} onClick={() => setCustomer(p.id)}>{p.name}</CustomerChip>
                    ))}
                  </div>
                </div>
              )}
              {payRow(true)}
              <div className="flex items-center justify-between font-mono text-2xl font-bold">
                <span className="uppercase tracking-widest">{_L("register.total")}</span>
                <span className="tabular-nums">{money(total)}</span>
              </div>
              <div className="flex gap-3">
                <Button variant="outline" size="lg" className="h-16 flex-1 text-xl" onClick={() => setReviewing(false)}>{_L("order.add_more")}</Button>
                <Button size="lg" className="h-16 flex-[2] gap-2.5 text-xl" disabled={blocks.length === 0 || busy} onClick={submit}>
                  {busy
                    ? <><Loader2 className="h-6 w-6 animate-spin" /> {mode === "register" ? _L("register.waiting") : _L("order.placing")}</>
                    : <><Receipt className="h-6 w-6" /> {mode === "register" ? _L("register.charge", money(total)) : _L("order.place", money(total))}</>}
                </Button>
              </div>
            </div>
          </div>
        )}

        {dialogs}
      </div>
    );
  }

  return (
    <div className="relative grid h-full grid-cols-5 gap-4">
      {/* catalog */}
      <div className="col-span-3 flex min-h-0 flex-col">
        <div className="mb-2 flex shrink-0 flex-wrap gap-1.5">
          <FilterChip active={kind === "all"} onClick={() => setKind("all")}>{_L("register.all_items")}</FilterChip>
          {kinds.map((k) => (
            <FilterChip key={k} active={kind === k} onClick={() => setKind(k)}>{k || _L("register.kind_recipe")}</FilterChip>
          ))}
        </div>
        <div className="min-h-0 flex-1 space-y-2 overflow-y-auto pr-1 pb-4">
          {catalog.length === 0 && <div className="py-8 text-center text-sm text-muted-foreground">{_L("register.no_catalog")}</div>}
            <div className="grid grid-cols-3 gap-2">
              {shown.map((c) => {
                const customisable = !!(c.modifiers && c.modifiers.length);
                return (
                  <button key={c.key} onClick={() => clickCard(c)}
                    className="relative flex flex-col items-center gap-1.5 rounded-lg border border-border/80 bg-card p-2 text-center transition-colors hover:border-primary/50 hover:bg-accent/60 active:bg-accent">
                    {customisable && (
                      <span className="absolute right-1 top-1 text-primary/70" title={_L("register.customisable")}><SlidersHorizontal className="h-3.5 w-3.5" /></span>
                    )}
                    <Thumb src={drinkCardSrc(c) ?? c.image} fallbackSrc={itemImageUrl(c.item)} className="h-12 w-12" />
                    <span className="line-clamp-2 text-xs font-medium leading-tight">{c.label}</span>
                    <span className="font-mono text-[11px] tabular-nums text-muted-foreground">{money(c.price)}</span>
                  </button>
                );
              })}
            </div>
        </div>
      </div>

      {/* cart — the order prints onto the register tape as it's built (themed
          receipt surface + a torn bottom edge, matching the tickets) */}
      <div className="col-span-2 flex min-h-0 flex-col drop-shadow-lg">
        <div className="receipt shrink-0 rounded-t-sm px-3 pb-1.5 pt-2.5">
          <div className="flex items-center justify-between">
            <span className="tape">{_L("register.cart")}</span>
            <Receipt className="h-3.5 w-3.5 text-muted-foreground" />
          </div>
          <div className="receipt-rule mt-2" />
        </div>
        <div className="receipt min-h-0 flex-1 space-y-1 overflow-y-auto px-2.5 py-1.5">
          {blocks.length === 0 && (
            <div className="py-6 text-center font-mono text-[11px] uppercase tracking-widest text-muted-foreground">
              {_L("register.empty_cart")}
            </div>
          )}
          {blocks.map((b) => cartLine(b))}
        </div>
        <div className="receipt shrink-0 space-y-2 px-3 pb-3 pt-1.5">
          <div className="receipt-rule" />
          <div className="flex items-center justify-between pt-1 font-mono text-sm font-bold">
            <span className="uppercase tracking-widest">{_L("register.total")}</span>
            <span className="tabular-nums">{money(total)}</span>
          </div>
          {payRow()}
          {!big && (
            <label className="flex items-center gap-2 text-xs text-muted-foreground">
              <User className="h-3.5 w-3.5" />
              <select value={customer} onChange={(e) => setCustomer(Number(e.target.value))}
                className="h-8 flex-1 rounded-md border border-input bg-muted/50 px-2 text-xs text-foreground focus-visible:border-primary/60 focus-visible:outline-none">
                <option value={0}>{_L("register.myself")}</option>
                {(nearby || []).map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
              </select>
            </label>
          )}
          <Button className="w-full" disabled={blocks.length === 0 || busy} onClick={submit}>
            {busy
              ? <><Loader2 className="h-4 w-4 animate-spin" /> {big ? _L("order.placing") : _L("register.waiting")}</>
              : <><Receipt className="h-4 w-4" /> {big ? _L("order.place", money(total)) : _L("register.charge", money(total))}</>}
          </Button>
        </div>
        <div className="tear-b shrink-0" />
      </div>

      {dialogs}
    </div>
  );
}
