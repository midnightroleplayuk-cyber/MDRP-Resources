import { useEffect, useMemo, useRef, useState, type ReactNode } from "react";
import { fetchNui, useNuiEvent } from "@/lib/nui";
import { Badge } from "@/components/ui/badge";
import { X, Flame, CupSoda, Sandwich, UtensilsCrossed, Carrot, ChefHat, CookingPot, Heater, Microwave, CircleDot, Search, Trash2, ChevronUp, ChevronDown, Timer, Package, ShoppingBag, Wrench } from "lucide-react";
import { cn, prettyItem } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { equipImageUrl, drinkImageUrl } from "@/lib/localImages";

// kind "finish" = a finish tool (frosting): flavors is picked on the card, then the
// tube is rubbed over a cooked target on the prep table until fully coated.
// `variant` = which FACE of a multi-faced ingredient this card is (one item,
// several toys: the bar shows a card per variant, all spending the same stock).
// It rides the drag and is recorded on the reservation, so the bagged instance
// keeps its identity.
type Ingredient = { kind: string; item: string; label: string; image?: string; count?: number; canMake?: boolean; model?: string; dual?: boolean; subkind?: string; variant?: string; locked?: boolean; group?: string; flavors?: { id: string; label: string; color?: string }[] };

// Swatch colors for the flavor squares on a finish card. The config can carry a
// per-flavor `color`; these cover the default flavors on servers seeded before
// colors existed (and anything unknown gets the neutral fallback).
const FLAVOR_COLORS: Record<string, string> = {
  strawberry: "#f472b6",
  chocolate: "#8b5a2b",
  glazed: "#f0c36d",
  vanilla: "#f3e5ab",
  pickle: "#65a30d",
};
const flavorColor = (fl: { id: string; color?: string }) => fl.color || FLAVOR_COLORS[fl.id] || "#9ca3af";
type SideInfo = { state: string; percent: number; cooking?: boolean };
// One aggregated component of a build stack (bun halves collapse to one bun).
type TrayComp = { item: string; label: string; image?: string; count: number };
// The melted-topping state riding a tray/inventory entry: which ingredient sits
// on it and how far along the melt is. Display comes from `top`/`topModel`.
type TopState = { item: string; state: number | string };
type TrayEntry = {
  item: string; count: number; label?: string; image?: string; model?: string;
  dual?: boolean; top?: TopState; topModel?: string; decompose?: boolean; uncooked?: boolean; cookStation?: string;
  // per-build-variation identity: sig addresses exactly this variation on the server;
  // stack/stackState render its full layer tower; extras (toppings over the base
  // recipe) and comps (full component list) tell otherwise-identical entries apart.
  // source "inv" = an inventory-held product listed alongside the tray ("Item" pill).
  sig?: string; stack?: string[]; stackState?: string; extras?: TrayComp[]; comps?: TrayComp[]; source?: string;
  // a serving-tray meal: sets back down at prep as its full tray, layout intact
  meal?: boolean;
  // a meal made in a pizza box — sets back down as its box (lid open), not a tray
  boxed?: boolean;
  // a made TAKEOUT BOX (a bag-kind food: soup, salad…): renders as the box pair with
  // the food's image (`quad`) drawn inside it, never as a build tower
  takeout?: boolean; quad?: string; quadCrop?: Crop; lidModel?: string;
  // a packed RESTAURANT BAG: the flag, and how many things the customer will find
  // inside it. Both stores (tray + inventory) send these and `comps`.
  bag?: boolean;
  contents?: number;
  // a finished (frosted…) product's recorded flavor, e.g. "Strawberry"
  flavorLabel?: string;
  // a poured drink's flavor output key (e.g. "soda") — picks its per-flavor card
  // art (items/<flavor>.png), falling back to the generic drink image
  flavor?: string;
  // which finish tool last applied to this product (e.g. "frosting") — lets a
  // finish tool gate on a prior finish (sprinkles require frosting) client-side
  finishTool?: string;
  // a burnt cook output — sorted to the back of the bar and offered the bin
  burnt?: boolean;
  // whether this can be POCKETED (Take / Take all). Server-resolved: most cooked
  // products are tray-only by design — they never exist as inventory items and
  // reach a customer packed into a meal or a bag — and burnt food is
  // unexchangeable, so `trayToInventory` refuses both. Absent = bin only.
  takeable?: boolean;
  // A pocketed serving: THE RESTAURANT ITEM holding this product. It is listed as
  // the food it holds (the server unwraps it) but no kitchen gesture can address
  // it — every one names an item, and the name a drag would carry is the vessel's.
  // One click puts it back on the kitchen tray, where it is an ordinary cooked item
  // again. `wrapped` = don't drag me; `stow` = offer the button.
  wrapped?: boolean;
  stow?: boolean;
  // freshness: seconds left until this item spoils when the tray was last fetched
  // (absent = never expires). The card counts it down locally and shows a red timer
  // in the final minute.
  expiresIn?: number;
};
// A buildable recipe (kitchen prep) with its output + components resolved for the tooltip.
type RecipeComp = { item: string; label: string; image?: string };
type RecipeCat = {
  output: string; label: string; image?: string; components: RecipeComp[];
  // Takeout-box crafts only: this food exists and its components match, but the
  // restaurant's group list doesn't carry it. Listed rather than hidden — a silent
  // drop made an access rule look exactly like a broken recipe — and named with the
  // group that unlocks it, which is an admin's one-line fix.
  locked?: boolean; group?: string;
};
// The hovered stack's live snapshot: where it is on screen + what it provides.
// A hovered serving tray sends { tray: true, tid, count } instead (Make Meal
// tooltip); a pizza box additionally carries { box: true, open } (lid state —
// clicking the box toggles it).
type PrepTip = {
  sid?: number; onScreen: boolean; x: number; y: number; provides?: Record<string, number>;
  tray?: boolean; box?: boolean; open?: boolean; boxing?: boolean; tid?: number; count?: number;
  // a baking tray (cake tin / cookie tray): no Make Meal — a hint to rub the mix in
  // (empty) or drag it to the hotbar (filled).
  bake?: boolean; filled?: boolean;
  // a Restaurant Bag: "Bag It Up" instead of Make Meal — the takeaway carrier, so
  // its tooltip just lists what's been packed into it.
  bag?: boolean;
  // a TAKEOUT BOX: the vessel every bag-kind food (soup, salad…) is created in. Its
  // tooltip lists the contents AND ranks the foods they form ("Create <food>"),
  // exactly the way a build stack ranks recipes. Hinged lid like the pizza box.
  takeout?: boolean;
  contents?: PrepContent[];
  // A MADE takeout box standing on the prep table: one finished product, not a build,
  // so there are no recipes to rank — it names itself instead.
  product?: { label?: string; image?: string };
  // The item under the cursor, sent for any OTHER placed part. Used the same way as
  // `product` above when the pile ranks no recipe (a finished sandwich): the NUI
  // resolves it against the recipe catalogue to name it and list what it's made of.
  // `puid` addresses that exact part, so its tooltip can act on it (Disassemble)
  // after the cursor has left the prop and travelled onto the tooltip itself.
  item?: string; puid?: number;
};
// One aggregated item sitting in a takeaway vessel (shown in its tooltip).
type PrepContent = { item: string; label?: string; image?: string; qty: number };
// A recipe scored against a stack: how many components are satisfied + what's short.
type Ranked = { rec: RecipeCat; matched: number; ready: boolean; missing: { item: string; label: string; image?: string; short: number }[] };
type ChipItem = {
  uid: number; onScreen: boolean; x: number; y: number;
  state?: string;                         // single items
  dual?: boolean;                         // dual patties below
  single?: boolean;                       // oven/fryer/soda gated single item (progress below)
  locked?: boolean;                       // in a lowered fryer basket / mid-pour — can't be grabbed
  percent?: number; gate?: boolean; method?: string; burningSoon?: boolean;
  ice?: boolean; needLid?: boolean;       // soda cups: ice dispensed / lid still required
  sides?: SideInfo[]; cooking?: number;   // per-face progress + which face is on the grill
  // a melting ingredient sitting on a dual-sided item: which one + its melt state
  topping?: { item: string; state: string; model?: string }; // state "none" | "applied" | "melted"
  give?: string; giveLabel?: string; giveImage?: string;
};

// Resolve a topping ingredient's display label/image from whatever catalogue
// entry mentions it; falls back to a prettified codename so it never reads raw.
type ItemMetaMap = Record<string, { label?: string; image?: string }>;
// A normalised (0..1) source rectangle cropped in the admin panel; forwarded to the
// world render untouched so what was cropped is what's painted.
type Crop = { x: number; y: number; w: number; h: number };
const metaLabel = (meta: ItemMetaMap | undefined, item: string) => meta?.[item]?.label || prettyItem(item);
const metaImage = (meta: ItemMetaMap | undefined, item: string) => meta?.[item]?.image;
const topMelted = (state: number | string) => state === 2 || state === "2" || state === "melted";

// The stovetop's camera views as icon tabs (sidebar left of the item listings):
// a cooktop for the stovetop, the same oven icon twice with a #1/#2 badge.
// These label tables are built through LAZY getters (memoized on first call), never
// eager module-scope literals: `_L()` at module scope runs at IMPORT time, before
// loadLocale() has populated the string table, and would freeze to the raw key.
// Resolving on first render (after the locale has loaded) is what makes them localize.
let _stoveViews: { key: string; label: string; icon: any; num?: number }[] | null = null;
const STOVE_VIEWS = () => (_stoveViews ??= [
  { key: "stovetop", label: _L("cook.view_stovetop"), icon: Heater },
  { key: "door1", label: _L("cook.view_oven_door_1"), icon: Microwave, num: 1 },
  { key: "door2", label: _L("cook.view_oven_door_2"), icon: Microwave, num: 2 },
]);

let _stationMeta: Record<string, { label: string; icon: any; hint: string }> | null = null;
const STATION_META = () => (_stationMeta ??= {
  fryer: { label: _L("cook.station_fryer_label"), icon: Flame, hint: _L("cook.station_fryer_hint") },
  stovetop: { label: _L("cook.station_stovetop_label"), icon: Flame, hint: _L("cook.station_stovetop_hint") },
  soda_machine: { label: _L("cook.station_soda_label"), icon: CupSoda, hint: _L("cook.station_soda_hint") },
  kitchen_prep: { label: _L("cook.station_prep_label"), icon: Sandwich, hint: _L("cook.station_prep_hint") },
});

let _stateStyle: Record<string, { label: string; cls: string }> | null = null;
const STATE_STYLE = () => (_stateStyle ??= {
  raw: { label: _L("cook.state_raw"), cls: "bg-rose-500/80 border-rose-300" },
  filling: { label: _L("cook.state_filling"), cls: "bg-sky-500/80 border-sky-300" },
  cooked: { label: _L("cook.state_cooked"), cls: "bg-emerald-500/80 border-emerald-300" },
  done: { label: _L("cook.state_ready"), cls: "bg-emerald-500/80 border-emerald-300" },
  burnt: { label: _L("cook.state_burnt"), cls: "bg-zinc-800/90 border-zinc-500" },
  // soda cups
  empty: { label: _L("cook.state_empty"), cls: "bg-zinc-600/80 border-zinc-400" },
  filled: { label: _L("cook.state_filled"), cls: "bg-emerald-500/80 border-emerald-300" },
  capped: { label: _L("cook.state_ready"), cls: "bg-emerald-500/80 border-emerald-300" },
});

const stateMeta = (s?: string) => STATE_STYLE()[s || "raw"] || STATE_STYLE().raw;

// Item thumbnail that quietly disappears if the inventory has no image for it — or,
// when a `fallback` node is given (e.g. a vector icon for a non-inventory equipment
// card), renders that instead of vanishing when the image is absent or fails to load.
function ItemThumb({ src, alt, className, fallback }: { src?: string; alt: string; className?: string; fallback?: ReactNode }) {
  const [broken, setBroken] = useState(false);
  useEffect(() => setBroken(false), [src]);
  if (!src || broken) return <>{fallback ?? null}</>;
  return <img src={src} alt={alt} draggable={false} onError={() => setBroken(true)} className={className} />;
}

const inRect = (x: number, y: number, r: DOMRect) =>
  x >= r.left && x <= r.right && y >= r.top && y <= r.bottom;

// "+ 2 toppings" — how many extras ride on top of the base recipe (tooltip header);
// the per-topping detail lives in the "Made with" list below it.
const extrasCount = (e?: TrayEntry) => (e?.extras ?? []).reduce((n, c) => n + c.count, 0);

// A packed VESSEL (Restaurant Bag / takeout box) has no base recipe to diff against,
// so "toppings" is the wrong question for it entirely — it describes itself by what is
// INSIDE it, the same way its inventory slot does (stackDescription, server-side, off
// the very same layers). Without this a bag of drumsticks read "Drumsticks" in the
// inventory and "No toppings" on its kitchen card.
const isVessel = (e?: TrayEntry) => !!(e?.bag || e?.takeout);
const contentsSummary = (e?: TrayEntry) =>
  (e?.comps ?? []).map((c) => (c.count > 1 ? `${c.label} ×${c.count}` : c.label)).join(", ");

// ── tray-card toppings row ────────────────────────────────────────────────────
// A fixed-height row on every tray card: square icons for the toppings that fit,
// "+X" for the overflow, grey "No toppings" when the build is exactly the base
// recipe — so all cards keep the same spacing.

const TOPPING_SLOTS = 4;

function ToppingsRow({ e }: { e: TrayEntry }) {
  const units: TrayComp[] = [];
  // a vessel's `extras` are always empty (nothing to diff against) — show what is
  // packed inside it instead, so the row never reads as an empty build
  for (const c of (isVessel(e) ? e.comps : e.extras) || []) for (let n = 0; n < c.count; n++) units.push(c);
  if (units.length === 0) {
    return <div className="flex h-[18px] items-center text-[9px] text-muted-foreground/70">{_L("cook.no_toppings")}</div>;
  }
  const shown = units.slice(0, units.length > TOPPING_SLOTS ? TOPPING_SLOTS - 1 : TOPPING_SLOTS);
  const over = units.length - shown.length;
  return (
    <div className="flex h-[18px] items-center justify-center gap-0.5">
      {shown.map((c, i) => (
        <div
          key={c.item + i}
          className="flex h-4 w-4 shrink-0 items-center justify-center rounded-sm border border-border/60 bg-background/60"
        >
          <ItemThumb src={c.image} alt={c.label} className="h-3.5 w-3.5 object-contain" />
        </div>
      ))}
      {over > 0 && (
        <span className="rounded-sm border border-border/60 bg-background/60 px-1 text-[9px] font-semibold tabular-nums text-muted-foreground">
          +{over}
        </span>
      )}
    </div>
  );
}

// ── bar-item hover tooltip ────────────────────────────────────────────────────
// Floats above a hovered tray/ingredient card: what the item is, what it's made
// of (with icons), its cheese state, and what you can do with it here. Anchored
// fixed so the bar's horizontal scroll can't clip it. When the entry has actions
// (Take / Discard) the tooltip is interactive — the cursor can travel onto it and
// it pins itself open while hovered, like the prep recipe tooltip.

type BarTip = { x: number; y: number; tray?: TrayEntry; ing?: Ingredient; hint?: string };

function BarTooltip({ tip, actions, onPin, meta }: { tip: BarTip; actions?: ReactNode; onPin: (pinned: boolean) => void; meta?: ItemMetaMap }) {
  const e = tip.tray;
  const ing = tip.ing;
  const label = e ? e.label || prettyItem(e.item) : ing?.label || "";
  const image = e ? e.image : ing?.image;
  const count = e ? e.count : ing?.count;
  // clamp the w-56 (224px) card inside the viewport; the caret keeps pointing at
  // the card's centre even when the box has been shoved off-centre to fit
  const HALF = 112, MARGIN = 8;
  const x = Math.min(Math.max(tip.x, HALF + MARGIN), window.innerWidth - HALF - MARGIN);
  const caretShift = Math.min(Math.max(tip.x - x, -HALF + 16), HALF - 16);
  return (
    <div
      // NOTE: the fade-in animation lives on the INNER card — its keyframes set
      // `transform`, which would override this centering translate mid-animation
      // (the tooltip would start off to the right/below and slide into place)
      onPointerEnter={() => actions && onPin(true)}
      onPointerLeave={() => actions && onPin(false)}
      className={cn(
        "fixed z-50 -translate-x-1/2 -translate-y-[104%]",
        actions ? "pointer-events-auto" : "pointer-events-none"
      )}
      style={{ left: x, top: tip.y }}
    >
      <div className="relative w-56 animate-fade-in rounded-xl border border-border bg-card p-3 shadow-2xl">
        <div className="flex items-center gap-2">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-md bg-muted/50">
            <ItemThumb src={image} alt={label} className="h-9 w-9 object-contain" />
          </div>
          <div className="min-w-0">
            <div className="flex items-center gap-1.5">
              <span className="truncate text-sm font-semibold">{label}</span>
              {e?.source === "inv" && (
                <span className="shrink-0 rounded border border-border bg-secondary px-1 py-px text-[9px] font-semibold uppercase tracking-wide text-muted-foreground">
                  {_L("cook.item_badge")}
                </span>
              )}
            </div>
            {e &&
              (e.meal ? (
                <div className="truncate text-[11px] font-medium text-amber-300">
                  {e.boxed ? _L("cook.boxed_pizza_meal") : _L("cook.serving_tray_meal")}
                </div>
              ) : e.flavorLabel ? (
                <div className="truncate text-[11px] font-medium text-pink-300">{e.flavorLabel}</div>
              ) : isVessel(e) && contentsSummary(e) ? (
                <div className="truncate text-[11px] font-medium text-amber-300">{contentsSummary(e)}</div>
              ) : extrasCount(e) > 0 ? (
                <div className="truncate text-[11px] font-medium text-amber-300">
                  {extrasCount(e) === 1 ? _L("cook.topping_one", extrasCount(e)) : _L("cook.toppings_other", extrasCount(e))}
                </div>
              ) : (
                <div className="truncate text-[11px] font-medium text-muted-foreground">{_L("cook.no_toppings")}</div>
              ))}
          </div>
          {count != null && (
            <span className="ml-auto shrink-0 rounded bg-secondary px-1.5 py-0.5 text-[11px] font-semibold tabular-nums">
              ×{count}
            </span>
          )}
        </div>

        {e?.top && (
          <div className="mt-2 flex items-center gap-1.5 text-[11px] text-amber-300">
            <ItemThumb src={e.topModel ? undefined : metaImage(meta, e.top.item)} alt="" className="h-3.5 w-3.5 object-contain" />
            {topMelted(e.top.state) ? _L("cook.top_melted_in", metaLabel(meta, e.top.item)) : _L("cook.top_applied", metaLabel(meta, e.top.item))}
          </div>
        )}

        {e?.comps && e.comps.length > 0 && (
          <>
            <div className="mt-2.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
              {_L("cook.made_with")}
            </div>
            <div className="mt-1 space-y-1">
              {e.comps.map((c, i) => (
                <div key={c.item + i} className="flex items-center gap-1.5 text-[11px]">
                  <div className="flex h-5 w-5 shrink-0 items-center justify-center rounded bg-muted/50">
                    <ItemThumb src={c.image} alt={c.label} className="h-4 w-4 object-contain" />
                  </div>
                  <span className="truncate">{c.label}</span>
                  {c.count > 1 && <span className="ml-auto shrink-0 tabular-nums text-muted-foreground">×{c.count}</span>}
                </div>
              ))}
            </div>
          </>
        )}

        {tip.hint && (
          <div className="mt-2.5 border-t border-border/60 pt-2 text-[11px] leading-snug text-muted-foreground">
            {tip.hint}
          </div>
        )}
        {actions}
        {/* caret pointing down at the card */}
        <div
          className="absolute top-full h-0 w-0 -translate-x-1/2 border-x-[6px] border-t-[6px] border-x-transparent border-t-card"
          style={{ left: `calc(50% + ${caretShift}px)` }}
        />
      </div>
    </div>
  );
}

// ── hover status panel ────────────────────────────────────────────────────────

function SideRow({ name, side }: { name: string; side?: SideInfo }) {
  const st = stateMeta(side?.state);
  const cooking = !!side?.cooking;
  const done = side?.state === "burnt";
  const pct = Math.round((side?.percent ?? 0) * 100);
  return (
    <div className={cn("rounded-md border px-2 py-1.5",
      cooking ? "border-primary/50 bg-primary/10" : "border-white/10 bg-black/25")}>
      <div className="flex items-center justify-between text-[11px]">
        <span className="flex items-center gap-1 text-muted-foreground">
          <Flame className={cn("h-3 w-3", cooking ? "text-primary" : "text-transparent")} />
          {name}
        </span>
        <span className={cn("rounded px-1.5 py-0.5 text-[10px] font-semibold text-white", st.cls)}>{st.label}</span>
      </div>
      <div className="mt-1 flex items-center gap-1.5">
        <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-muted">
          <div
            className={cn("h-full rounded-full transition-[width] duration-150 ease-linear",
              done ? "bg-zinc-500" : cooking ? "bg-primary" : "bg-primary/40")}
            style={{ width: `${pct}%` }}
          />
        </div>
        <span className="shrink-0 text-[9px] tabular-nums text-muted-foreground">
          {done ? _L("cook.done") : `${pct}%`}
        </span>
      </div>
    </div>
  );
}

function StatusPanel({ c, meta }: { c: ChipItem; meta?: ItemMetaMap }) {
  if (!c.dual) {
    // oven / fryer / soda item: live progress bar, collect-now, next-step hints
    if (c.single) {
      const st = stateMeta(c.state);
      const pct = Math.round((c.percent ?? 0) * 100);
      const done = c.state === "burnt";
      const pausedHint = c.method === "soda"
        ? (c.state === "empty"
            ? _L("cook.hint_click_tap_pour")
            : c.state === "filled"
              ? (c.needLid ? _L("cook.hint_drag_lid_finish") : _L("cook.hint_drag_bar_collect"))
              : c.state === "capped"
                ? _L("cook.hint_drag_bar_collect")
                : null)
        : !c.gate
          ? (c.method === "oven" ? _L("cook.hint_close_door_bake") : _L("cook.hint_lower_basket_fry"))
          : c.locked
            ? _L("cook.hint_raise_basket")
            : null;
      return (
        <div className="w-56 rounded-xl border border-border bg-card p-3 shadow-2xl">
          <div className="flex items-center gap-2">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-md bg-muted/50">
              <ItemThumb src={c.giveImage} alt={c.giveLabel || ""} className="h-9 w-9 object-contain" />
            </div>
            <div className="min-w-0">
              <div className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">{_L("cook.collect_now")}</div>
              <div className="truncate text-sm font-semibold">{c.giveLabel || "—"}</div>
            </div>
            <span className={cn("ml-auto shrink-0 rounded px-1.5 py-0.5 text-[10px] font-semibold text-white", st.cls)}>{st.label}</span>
          </div>
          <div className="mt-2.5 flex items-center gap-1.5">
            <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-muted">
              <div
                className={cn("h-full rounded-full transition-[width] duration-150 ease-linear",
                  done ? "bg-zinc-500" : c.gate ? "bg-primary" : "bg-primary/40")}
                style={{ width: `${pct}%` }}
              />
            </div>
            <span className="shrink-0 text-[9px] tabular-nums text-muted-foreground">{done ? _L("cook.done") : `${pct}%`}</span>
          </div>
          {c.burningSoon && !done && (
            <div className="mt-2 text-[11px] font-semibold text-amber-400">{_L("cook.burning_soon")}</div>
          )}
          {c.ice && (
            <div className="mt-2 flex items-center gap-1.5 text-[11px] text-sky-300">{_L("cook.ice_added")}</div>
          )}
          {pausedHint && <div className="mt-2 text-[11px] text-muted-foreground">{pausedHint}</div>}
        </div>
      );
    }
    const st = stateMeta(c.state);
    return (
      <div className="flex items-center gap-2 rounded-lg border border-border bg-card px-3 py-2 text-xs font-semibold shadow-2xl">
        <span className={cn("rounded px-1.5 py-0.5 text-[10px] text-white", st.cls)}>{st.label}</span>
      </div>
    );
  }
  const sides = c.sides || [];
  return (
    <div className="w-60 rounded-xl border border-border bg-card p-3 shadow-2xl">
      <div className="flex items-center gap-2">
        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-md bg-muted/50">
          <ItemThumb src={c.giveImage} alt={c.giveLabel || ""} className="h-9 w-9 object-contain" />
        </div>
        <div className="min-w-0">
          <div className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">{_L("cook.collect_now")}</div>
          <div className="truncate text-sm font-semibold">{c.giveLabel || "—"}</div>
        </div>
      </div>

      {/* both faces with their own progress; the flame marks the grill side */}
      <div className="mt-2.5 space-y-1.5">
        <SideRow name={_L("cook.side_1")} side={sides[0]} />
        <SideRow name={_L("cook.side_2")} side={sides[1]} />
      </div>

      {c.topping && c.topping.state !== "none" && (
        <div className="mt-2 flex items-center gap-1.5 text-[11px] text-amber-300">
          <ItemThumb src={metaImage(meta, c.topping.item)} alt="" className="h-3.5 w-3.5 object-contain" />
          {c.topping.state === "melted" ? _L("cook.top_melted", metaLabel(meta, c.topping.item)) : _L("cook.top_melting", metaLabel(meta, c.topping.item))}
        </div>
      )}
    </div>
  );
}

// Rank recipes for a stack, Minecraft-style: the ones it most relates to first.
// Score by components already satisfied (desc), then ready recipes, then fewest
// missing. Only the required components matter — extras on the stack (an alteration,
// e.g. a donut on a burger) never disqualify a recipe. Top 3 are shown.
function rankRecipes(recipes: RecipeCat[], provides: Record<string, number>): Ranked[] {
  const scored = recipes.map((rec) => {
    const need: Record<string, number> = {};
    const meta: Record<string, { label: string; image?: string }> = {};
    rec.components.forEach((c) => {
      need[c.item] = (need[c.item] || 0) + 1;
      meta[c.item] = { label: c.label, image: c.image };
    });
    let matched = 0;
    const missing: Ranked["missing"] = [];
    for (const item in need) {
      const have = provides[item] || 0;
      matched += Math.min(have, need[item]);
      if (have < need[item]) missing.push({ item, label: meta[item].label, image: meta[item].image, short: need[item] - have });
    }
    return { rec, matched, ready: missing.length === 0, missing };
  });
  return scored
    // only recipes the stack actually relates to (shares at least one component)
    .filter((s) => s.matched > 0)
    .sort(
      (a, b) =>
        // a craft this restaurant can't carry never outranks one it can — it's
        // listed to EXPLAIN itself, not to be the default pick
        Number(!!a.rec.locked) - Number(!!b.rec.locked) ||
        b.matched - a.matched ||
        Number(b.ready) - Number(a.ready) ||
        a.missing.length - b.missing.length ||
        a.rec.label.localeCompare(b.rec.label)
    )
    .slice(0, 3);
}

// Floating recipe guide over the hovered stack. Shows the 3 most-related recipes as
// clickable thumbnails (first selected by default); the selected one lists what's
// still missing, and reveals a Make button once the stack satisfies it.
function BuildTooltip({
  ranked, selected, onSelect, onMake, onPin,
}: {
  ranked: Ranked[];
  selected: Ranked | null;
  onSelect: (output: string) => void;
  onMake: () => void;
  onPin: (pinned: boolean) => void;
}) {
  return (
    <div
      onPointerEnter={() => onPin(true)}
      onPointerLeave={() => onPin(false)}
      className="w-64 rounded-xl border border-border bg-card p-3 shadow-2xl"
    >
      {ranked.length === 0 ? (
        <div className="text-xs text-muted-foreground">{_L("cook.no_matching_recipes")}</div>
      ) : (
        <>
          <div className="mb-2 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
            {_L("cook.recipes_click_compare")}
          </div>
          <div className="flex gap-2">
            {ranked.map((r) => {
              const active = selected?.rec.output === r.rec.output;
              return (
                <button
                  key={r.rec.output}
                  onClick={() => onSelect(r.rec.output)}
                  title={r.rec.label}
                  className={cn(
                    "relative flex h-14 w-14 shrink-0 items-center justify-center rounded-lg border bg-muted/40 transition",
                    active ? "border-primary ring-2 ring-primary/50" : "border-border hover:border-primary/60"
                  )}
                >
                  <ItemThumb src={r.rec.image} alt={r.rec.label} className="h-10 w-10 object-contain" />
                  {r.ready && (
                    <span className="absolute -right-1 -top-1 flex h-4 w-4 items-center justify-center rounded-full bg-emerald-500 text-[9px] font-bold text-white">
                      ✓
                    </span>
                  )}
                </button>
              );
            })}
          </div>

          {selected && (
            <div className="mt-3">
              <div className="truncate text-sm font-semibold">{selected.rec.label}</div>
              {selected.ready ? (
                <div className="mt-1 text-[11px] font-medium text-emerald-400">{_L("cook.ready_to_make")}</div>
              ) : (
                <>
                  <div className="mt-1.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
                    {_L("cook.still_needs")}
                  </div>
                  <div className="mt-1 flex flex-wrap gap-1.5">
                    {selected.missing.map((m) => (
                      <span
                        key={m.item}
                        className="flex items-center gap-1 rounded bg-secondary px-1.5 py-0.5 text-[11px]"
                      >
                        <ItemThumb src={m.image} alt={m.label} className="h-4 w-4 object-contain" />
                        {m.label}{m.short > 1 ? ` ×${m.short}` : ""}
                      </span>
                    ))}
                  </div>
                </>
              )}
              <button
                disabled={!selected.ready}
                onClick={onMake}
                className={cn(
                  "mt-3 w-full rounded-md px-3 py-1.5 text-xs font-semibold transition",
                  selected.ready
                    ? "bg-primary text-primary-foreground hover:opacity-90"
                    : "cursor-not-allowed bg-muted text-muted-foreground"
                )}
              >
                {_L("cook.make")}
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}

// Floating hint over a hovered baking tray (cake tin / cookie tray): rub the mix in
// while empty, drag it to the hotbar once filled. No Make Meal — a baking tray isn't
// a meal surface; the mix + tray produce an oven-ready raw bake.
function BakeTrayTooltip({ filled, onPin }: { filled: boolean; onPin: (pinned: boolean) => void }) {
  return (
    <div
      onPointerEnter={() => onPin(true)}
      onPointerLeave={() => onPin(false)}
      className="w-60 rounded-xl border border-border bg-card p-3 shadow-2xl"
    >
      <div className="flex items-center gap-2">
        <CookingPot className="h-4 w-4 shrink-0 text-primary" />
        <span className="text-sm font-semibold">{_L("cook.baking_tray")}</span>
      </div>
      <div className="mt-2 text-[11px] leading-snug text-muted-foreground">
        {filled ? _L("cook.baketray_filled_hint") : _L("cook.baketray_empty_hint")}
      </div>
    </div>
  );
}

// Floating tooltip over the hovered serving tray / pizza box: item count + the
// Make Meal / Box It Up button. The whole arrangement (every pile, exact
// offsets) becomes one meal item; a box's meal is flagged so it sets back down
// as its box. A box also explains its click-to-toggle lid.
function MealTooltip({
  count, box, bag, open, boxing, contents, onMake, onTakeOut, onPin,
}: {
  count: number;
  box?: boolean;
  bag?: boolean;
  open?: boolean;
  boxing?: boolean;
  // What's in the vessel right now. The RESTAURANT BAG lists it here for the same
  // reason the takeout box does: a packed bag hides its contents in the world, and
  // a food with no prop of its own (a soup) has nothing to show there even when
  // it's open — so a count alone left the cook guessing what they'd packed.
  contents?: PrepContent[];
  onMake: () => void;
  onTakeOut: () => void;
  onPin: (pinned: boolean) => void;
}) {
  const Icon = bag ? ShoppingBag : box ? Package : UtensilsCrossed;
  const hint = bag
    ? count === 0
      ? _L("cook.bag_empty_hint")
      : _L("cook.bag_full_hint")
    : box
    ? boxing
      ? _L("cook.box_closing_hint")
      : count === 0
        ? open
          ? _L("cook.box_empty_open_hint")
          : _L("cook.box_empty_closed_hint")
        : _L("cook.box_full_hint")
    : count === 0
      ? _L("cook.tray_empty_hint")
      : _L("cook.tray_full_hint");
  const canAct = count > 0 && !boxing;
  return (
    <div
      onPointerEnter={() => onPin(true)}
      onPointerLeave={() => onPin(false)}
      className="w-60 rounded-xl border border-border bg-card p-3 shadow-2xl"
    >
      <div className="flex items-center gap-2">
        <Icon className="h-4 w-4 shrink-0 text-primary" />
        <span className="text-sm font-semibold">{bag ? _L("cook.restaurant_bag") : box ? _L("cook.pizza_box") : _L("cook.serving_tray")}</span>
        <span className="ml-auto shrink-0 rounded bg-secondary px-1.5 py-0.5 text-[11px] font-semibold tabular-nums">
          {!bag && box
            ? count === 0
              ? _L("cook.box_empty_badge")
              : _L("cook.box_pizza_inside")
            : count === 1
              ? _L("cook.item_one", count)
              : _L("cook.items_other", count)}
        </span>
      </div>
      {/* the packed list — every item by name and picture, whether or not it has a
          world model. Shown for the bag; the tray's contents are visible on it. */}
      {bag && (contents?.length ?? 0) > 0 && (
        <div className="mt-2 flex flex-wrap gap-1.5">
          {contents!.map((c) => (
            <span key={c.item} className="flex items-center gap-1 rounded bg-secondary px-1.5 py-0.5 text-[11px]">
              {c.image ? <ItemThumb src={c.image} alt={c.label || prettyItem(c.item)} className="h-4 w-4 object-contain" /> : null}
              {c.label || prettyItem(c.item)}{c.qty > 1 ? ` ×${c.qty}` : ""}
            </span>
          ))}
        </div>
      )}
      <div className="mt-2 text-[11px] leading-snug text-muted-foreground">{hint}</div>
      <div className="mt-3 flex gap-1.5">
        <button
          disabled={!canAct}
          onClick={onMake}
          className={cn(
            "flex-1 rounded-md px-3 py-1.5 text-xs font-semibold transition",
            canAct
              ? "bg-primary text-primary-foreground hover:opacity-90"
              : "cursor-not-allowed bg-muted text-muted-foreground"
          )}
        >
          {bag ? _L("cook.bag_it_up") : box ? (boxing ? _L("cook.box_closing") : _L("cook.box_it_up")) : _L("cook.make_meal")}
        </button>
        {/* The BAG conceals what's dropped in it exactly like the takeout box, so it
            needs the same way back out — without this, a wrong item dropped into a bag
            could only be recovered by bagging it up and taking the bag apart. */}
        {(box || bag) && count > 0 && (
          <button
            disabled={!canAct}
            onClick={onTakeOut}
            className={cn(
              "rounded-md px-2.5 py-1.5 text-xs font-semibold transition",
              canAct
                ? "bg-secondary text-foreground hover:bg-accent"
                : "cursor-not-allowed bg-muted text-muted-foreground"
            )}
          >
            {_L("cook.box_take_out")}
          </button>
        )}
      </div>
    </div>
  );
}

// Floating tooltip over a MADE product standing on the prep table — today that's a
// finished takeout box (a soup, a salad). It satisfies no recipe, so the recipe guide
// showed nothing at all and the box read as an unlabelled prop; this names it with the
// food's own art and says what it's for.
function ProductTooltip({ product, onDisassemble, onPin }: {
  // `eyebrow` names the KIND above the food (the vessel for a boxed one, "Finished
  // Item" for a plain product); `components` lists what it was built from, which is
  // the only thing a finished build has left to say about itself.
  product: { label?: string; image?: string; eyebrow?: string; components?: RecipeComp[] };
  // Present only for a product that can be un-made: takes it apart WHERE IT STANDS,
  // its components landing back on the table in its place.
  onDisassemble?: () => void;
  onPin: (pinned: boolean) => void;
}) {
  return (
    <div
      onPointerEnter={() => onPin(true)}
      onPointerLeave={() => onPin(false)}
      className="w-56 rounded-xl border border-border bg-card p-3 shadow-2xl"
    >
      <div className="flex items-center gap-2.5">
        {product.image ? (
          <ItemThumb src={product.image} alt={product.label || ""} className="h-10 w-10 shrink-0 object-contain" />
        ) : (
          <Package className="h-10 w-10 shrink-0 p-2 text-muted-foreground" />
        )}
        <div className="min-w-0">
          <div className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
            {product.eyebrow || _L("cook.takeout_box")}
          </div>
          {/* the FOOD's name is the headline; the vessel is only the eyebrow above it.
              Falling back to the vessel name here would print "Takeout Box" twice. */}
          <div className="truncate text-sm font-semibold">{product.label || _L("cook.unknown_food")}</div>
        </div>
      </div>
      {product.components && product.components.length > 0 && (
        <>
          <div className="mt-2.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
            {_L("cook.made_with")}
          </div>
          <div className="mt-1 space-y-1">
            {product.components.map((c, i) => (
              <div key={c.item + i} className="flex items-center gap-1.5 text-[11px]">
                <div className="flex h-5 w-5 shrink-0 items-center justify-center rounded bg-muted/50">
                  <ItemThumb src={c.image} alt={c.label} className="h-4 w-4 object-contain" />
                </div>
                <span className="truncate">{c.label}</span>
              </div>
            ))}
          </div>
        </>
      )}
      <div className="mt-2 text-[11px] leading-snug text-muted-foreground">{_L("cook.product_hint")}</div>
      {onDisassemble && (
        <button
          onClick={onDisassemble}
          className="mt-2.5 flex w-full items-center justify-center gap-1.5 rounded-md bg-secondary px-3 py-1.5 text-[11px] font-semibold text-foreground transition hover:bg-accent"
        >
          <Wrench className="h-3 w-3" />
          {_L("cook.disassemble")}
        </button>
      )}
    </div>
  );
}

// Floating tooltip over a hovered TAKEOUT BOX — the vessel every bag-kind food
// (soup, salad…) is created in. Lists what's in the box and, like the burger build
// guide, ranks the FOODS its contents most relate to — closest first, each showing
// what it still needs — revealing "Create <food>" once they match one. The server
// always creates the best match; the ranking just makes the match (and any
// shortfall) visible instead of a blind "nothing happens" on click. The box closes
// itself before creating, so the button doubles as the lid's cue.
//
// The box's contents are HIDDEN in the world (a packed container, not an open tray),
// so this tooltip is the ONLY place they're visible — and the only way they come back
// out, via Take Out.
function BagTooltip({
  contents, ranked, selected, count, open, boxing, onSelect, onBag, onTakeOut, onPin,
}: {
  contents: PrepContent[];
  ranked: Ranked[];
  selected: Ranked | null;
  count: number;
  open?: boolean;
  boxing?: boolean;
  onSelect: (output: string) => void;
  onBag: () => void;
  onTakeOut: () => void;
  onPin: (pinned: boolean) => void;
}) {
  const ready = !!selected?.ready && !selected?.rec.locked && !boxing;
  return (
    <div
      onPointerEnter={() => onPin(true)}
      onPointerLeave={() => onPin(false)}
      className="w-64 rounded-xl border border-border bg-card p-3 shadow-2xl"
    >
      <div className="flex items-center gap-2">
        <Package className="h-4 w-4 shrink-0 text-primary" />
        <span className="text-sm font-semibold">{_L("cook.takeout_box")}</span>
        <span className="ml-auto shrink-0 rounded bg-secondary px-1.5 py-0.5 text-[11px] font-semibold tabular-nums">
          {count === 1 ? _L("cook.item_one", count) : _L("cook.items_other", count)}
        </span>
      </div>

      {/* what's in the bag right now — the contents list, in place of floating pills */}
      {contents.length > 0 && (
        <div className="mt-2 flex flex-wrap gap-1.5">
          {contents.map((c) => (
            <span key={c.item} className="flex items-center gap-1 rounded bg-secondary px-1.5 py-0.5 text-[11px]">
              {c.image ? <ItemThumb src={c.image} alt={c.label || prettyItem(c.item)} className="h-4 w-4 object-contain" /> : null}
              {c.label || prettyItem(c.item)}{c.qty > 1 ? ` ×${c.qty}` : ""}
            </span>
          ))}
        </div>
      )}

      {/* food-match ranking — the bag-kind foods the contents most closely form */}
      {ranked.length === 0 ? (
        <div className="mt-2 text-[11px] leading-snug text-muted-foreground">
          {count === 0
            ? (open ? _L("cook.takeout_empty_open_hint") : _L("cook.takeout_empty_closed_hint"))
            : _L("cook.bag_no_craft")}
        </div>
      ) : (
        <>
          <div className="mb-1.5 mt-3 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
            {_L("cook.bag_makes")}
          </div>
          {/* the FOOD each match makes, as its own item art + label — the box hides
              its contents, so the picture of what comes out is the thing to show */}
          <div className="flex flex-wrap gap-1.5">
            {ranked.map((r) => {
              const active = selected?.rec.output === r.rec.output;
              return (
                <button
                  key={r.rec.output}
                  onClick={() => onSelect(r.rec.output)}
                  className={cn(
                    "flex items-center gap-1.5 rounded-md border px-2 py-1 text-[11px] font-medium transition",
                    active ? "border-primary ring-2 ring-primary/40" : "border-border hover:border-primary/60"
                  )}
                >
                  {r.rec.image ? (
                    <ItemThumb src={r.rec.image} alt={r.rec.label} className="h-5 w-5 shrink-0 object-contain" />
                  ) : null}
                  {r.rec.label}
                  {r.ready && <span className="text-emerald-400">✓</span>}
                </button>
              );
            })}
          </div>

          {/* the contents form this food, but the restaurant doesn't carry its group:
              say so, and say which group — nothing else in the kitchen can. */}
          {selected?.rec.locked && (
            <div className="mt-2.5 rounded-md border border-amber-500/40 bg-amber-500/10 px-2 py-1.5 text-[11px] leading-snug text-amber-200">
              {_L("cook.takeout_group_locked", selected.rec.label, selected.rec.group || "?")}
            </div>
          )}

          {selected && !selected.ready && !selected.rec.locked && (
            <>
              <div className="mt-2.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
                {_L("cook.still_needs")}
              </div>
              <div className="mt-1 flex flex-wrap gap-1.5">
                {selected.missing.map((m) => (
                  <span key={m.item} className="flex items-center gap-1 rounded bg-secondary px-1.5 py-0.5 text-[11px]">
                    <ItemThumb src={m.image} alt={m.label} className="h-4 w-4 object-contain" />
                    {m.label}{m.short > 1 ? ` ×${m.short}` : ""}
                  </span>
                ))}
              </div>
            </>
          )}
        </>
      )}

      {/* what the box will BE once created: the food's own item art, big enough to
          read — this is the "food item for the takeout box" the props no longer show */}
      {selected && !selected.rec.locked && (
        <div className="mt-3 flex items-center gap-2 rounded-lg border border-border bg-secondary/60 p-2">
          {selected.rec.image ? (
            <ItemThumb src={selected.rec.image} alt={selected.rec.label} className="h-9 w-9 shrink-0 object-contain" />
          ) : (
            <Package className="h-9 w-9 shrink-0 p-1.5 text-muted-foreground" />
          )}
          <div className="min-w-0">
            <div className="text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
              {_L("cook.takeout_makes")}
            </div>
            <div className="truncate text-xs font-semibold">{selected.rec.label}</div>
          </div>
        </div>
      )}

      <div className="mt-3 flex gap-1.5">
        <button
          disabled={!ready}
          onClick={onBag}
          className={cn(
            "flex-1 rounded-md px-3 py-1.5 text-xs font-semibold transition",
            ready ? "bg-primary text-primary-foreground hover:opacity-90" : "cursor-not-allowed bg-muted text-muted-foreground"
          )}
        >
          {boxing
            ? _L("cook.box_closing")
            : selected
              ? _L("cook.takeout_create", selected.rec.label)
              : _L("cook.takeout_create_generic")}
        </button>
        {/* the contents are invisible inside the box, so this is the only way back out */}
        {count > 0 && (
          <button
            disabled={!!boxing}
            onClick={onTakeOut}
            className={cn(
              "shrink-0 rounded-md px-2.5 py-1.5 text-xs font-semibold transition",
              boxing ? "cursor-not-allowed bg-muted text-muted-foreground" : "bg-secondary text-foreground hover:bg-accent"
            )}
          >
            {_L("cook.box_take_out")}
          </button>
        )}
      </div>
    </div>
  );
}

export default function Cooking({ data }: { data: any }) {
  const [station, setStation] = useState<string>(data?.station || "fryer");
  const [ingredients, setIngredients] = useState<Ingredient[]>(data?.ingredients || []);
  const [items, setItems] = useState<ChipItem[]>([]);
  const [hovered, setHovered] = useState<number | null>(null);
  const [view, setView] = useState<string>("stovetop");
  const [tray, setTray] = useState<TrayEntry[]>([]);
  const [tab, setTab] = useState<"packaging" | "ingredients" | "cooked" | "uncooked">("ingredients");
  // bar organisation: text filter over the cards, one-row strip vs wrapped grid,
  // and the card whose bin button is waiting for its confirming second click
  const [query, setQuery] = useState("");
  const [expanded, setExpanded] = useState(false);
  const [confirmKey, setConfirmKey] = useState<string | null>(null);
  const confirmTimer = useRef<number | null>(null);
  // kitchen-prep recipe + craft catalogues + the hovered stack/bag's tooltip snapshot
  const [recipes, setRecipes] = useState<RecipeCat[]>([]);
  const [crafts, setCrafts] = useState<RecipeCat[]>([]);
  const [tip, setTip] = useState<PrepTip | null>(null);
  const [tipShow, setTipShow] = useState(false);
  const [selectedOutput, setSelectedOutput] = useState<string | null>(null);
  const [selectedCraftId, setSelectedCraftId] = useState<string | null>(null);
  // last hovered uid — keeps the tooltip's (live) content during fade-out
  const [lastUid, setLastUid] = useState<number | null>(null);
  const [dragging, setDragging] = useState(false);
  // instructional drop-zone shown while a drag is in progress (null = no drag)
  const [dragHint, setDragHint] = useState<string | null>(null);
  // floating 2D ghost for a topping (cheese) drag onto a patty
  const [ghost, setGhost] = useState<{ x: number; y: number; label: string; image?: string } | null>(null);
  // hover tooltip for a bar card (tray item / ingredient): contents + what to do with it
  const [barTip, setBarTip] = useState<BarTip | null>(null);
  const barRef = useRef<HTMLDivElement>(null);
  const barPinnedRef = useRef(false);          // cursor is over the bar tooltip's actions
  const barTipTimer = useRef<number | null>(null);
  const tipPinnedRef = useRef(false);           // cursor is over the build tooltip
  const tipHideTimer = useRef<number | null>(null);
  const itemsRef = useRef<ChipItem[]>([]);
  const hoveredRef = useRef<number | null>(null);
  const placingRef = useRef(false);          // dragging an ingredient out of the bar
  const toppingRef = useRef<{ item: string; model?: string } | null>(null); // dragging a melting topping onto a patty
  const lidRef = useRef<string | null>(null);     // dragging a lid onto a filled soda cup
  const finishRef = useRef<string | null>(null); // rubbing a finish tool (frosting) over a target
  const bakeMixRef = useRef<string | null>(null); // rubbing the baking mix over an empty baking tray
  const condimentRef = useRef<string | null>(null); // squeezing a condiment bottle over a build stack
  const [finishFlavor, setFinishFlavor] = useState<Record<string, string>>({}); // chosen flavor per finish tool
  const prepDragRef = useRef<{ source: string; item: string; model?: string | null; pill?: boolean; decompose?: boolean; sig?: string } | null>(null); // dragging a NEW part (or a product/meal to take apart) onto the prep table
  const prepHoveredRef = useRef<number | null>(null); // placed prep part under the cursor (grab target)
  const trayHoveredRef = useRef<number | null>(null); // placed serving tray/box under the cursor (grab target)
  const trayHoveredBoxRef = useRef(false); // the hovered tray is a pizza box (click toggles its lid)
  // a press on a pizza box: undecided between a click (lid toggle) and a drag (grab)
  const pendingBoxRef = useRef<{ tid: number; x: number; y: number } | null>(null);
  const prepMoveRef = useRef<{ puid?: number; tray?: boolean } | null>(null); // re-dragging a placed prep part / a whole serving tray
  const trayPlaceRef = useRef(false); // dragging a fresh serving tray out of the bar
  const worldRef = useRef<{ uid: number | null; startX: number; startY: number; dragging: boolean } | null>(null);
  // Dragging a cross-category item auto-switches the bar to that item's category so
  // you can see where it lands; prevTabRef remembers the tab to fall BACK to if the
  // drag doesn't finish on the prep table (cancel / drop on the bar). tabRef mirrors
  // `tab` so the []-deps pointer handlers read the live value.
  const prevTabRef = useRef<"packaging" | "ingredients" | "cooked" | "uncooked" | null>(null);
  const tabRef = useRef(tab);
  useEffect(() => { tabRef.current = tab; }, [tab]);
  // dragging a prop FROM the world/prep table (grill collect, prep restack/remove) —
  // the hotbar becomes the prominent orange drop zone against a dimmed backdrop
  const [worldDragging, setWorldDragging] = useState(false);
  // switch the bar to a dragged item's category, remembering where we came from
  const dragSwitchTab = (cat: "packaging" | "ingredients" | "cooked" | "uncooked") => {
    if (tabRef.current !== cat) {
      if (prevTabRef.current === null) prevTabRef.current = tabRef.current;
      setTab(cat);
    }
  };
  // end of drag: keep the switched-to category if it landed on the prep, else revert
  const endDragTab = (droppedOnPrep: boolean) => {
    const prev = prevTabRef.current;
    prevTabRef.current = null;
    if (prev !== null && !droppedOnPrep) setTab(prev);
  };

  useEffect(() => {
    setStation(data?.station || "fryer");
    setIngredients(data?.ingredients || []);
    setView("stovetop");
    setTab("ingredients");
    setTip(null);
    setTipShow(false);
    setQuery("");
    setConfirmKey(null);
  }, [data]);

  useNuiEvent("cookingIngredients", (d) => { setIngredients(d.ingredients || []); setBarTip(null); });
  // finish drag concluded on the Lua side (fully coated & applied, or rejected)
  useNuiEvent("cookingFinishDone", () => {
    finishRef.current = null;
    setDragging(false);
    setDragHint(null);
  });
  // baking-mix drag concluded on the Lua side (tray filled, or rejected)
  useNuiEvent("cookingBakeDone", () => {
    bakeMixRef.current = null;
    setDragging(false);
    setDragHint(null);
  });
  // condiment drag concluded on the Lua side (squeeze finished & applied, or rejected)
  useNuiEvent("cookingCondimentDone", () => {
    condimentRef.current = null;
    setDragging(false);
    setDragHint(null);
  });
  // when the tray was last fetched — the freshness countdown is measured from here
  const [trayAt, setTrayAt] = useState(() => Date.now());
  const [nowMs, setNowMs] = useState(() => Date.now());
  useNuiEvent("cookingTray", (d) => { setTray(d.tray || []); setTrayAt(Date.now()); setBarTip(null); });
  // 1s tick so the red expiry countdown updates while the panel is open
  useEffect(() => {
    const t = window.setInterval(() => setNowMs(Date.now()), 1000);
    return () => window.clearInterval(t);
  }, []);
  // seconds left before an entry spoils (null = never / already gone). Counts down
  // locally from expiresIn measured at the last tray fetch.
  const expirySecs = (e: TrayEntry): number | null => {
    if (e.expiresIn == null) return null;
    return Math.max(0, Math.round(e.expiresIn - (nowMs - trayAt) / 1000));
  };
  // M:SS for a minute or more, else Ns — a compact live countdown label
  const fmtExpiry = (s: number): string =>
    s >= 60 ? `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}` : `${s}s`;
  // When a countdown reaches 0, ask the server to re-pull the tray (it purges spoiled
  // rows on fetch) so the item drops immediately instead of waiting for the sweep.
  // Throttled so a small client/server clock skew can't spin a tight refetch loop.
  const lastReapRef = useRef(0);
  useEffect(() => {
    const anyExpired = tray.some((e) => { const s = expirySecs(e); return s != null && s <= 0; });
    if (anyExpired && Date.now() - lastReapRef.current > 2500) {
      lastReapRef.current = Date.now();
      fetchNui("cooking:refreshTray");
    }
  }, [nowMs, tray, trayAt]);
  useNuiEvent("cookingRecipes", (d) => setRecipes(d.recipes || []));
  useNuiEvent("cookingCrafts", (d) => setCrafts(d.crafts || []));
  useNuiEvent("cookingItems", (d) => {
    const its: ChipItem[] = d.items || [];
    itemsRef.current = its;
    hoveredRef.current = d.hovered ?? null;
    prepHoveredRef.current = d.prepHovered ?? null;
    trayHoveredRef.current = d.prepTrayHovered ?? null;
    trayHoveredBoxRef.current = !!d.prepTrayBox;
    setItems(its);
    setHovered(d.hovered ?? null);

    // Prep tooltip: the client sends the hovered stack (or nothing). While a stack
    // is hovered, keep the tooltip live and shown; when the cursor leaves, hold it
    // briefly so the player can travel onto it to click — and keep it up as long as
    // the cursor is actually over it (pinned).
    const pt: PrepTip | null = d.prepTip ?? null;
    if (pt) {
      if (tipHideTimer.current) { clearTimeout(tipHideTimer.current); tipHideTimer.current = null; }
      setTip(pt);
      setTipShow(true);
    } else if (!tipPinnedRef.current && tipShow && !tipHideTimer.current) {
      tipHideTimer.current = window.setTimeout(() => {
        tipHideTimer.current = null;
        if (!tipPinnedRef.current) setTipShow(false);
      }, 220);
    }
  });

  const isStove = station === "stovetop";
  const isPrep = station === "kitchen_prep";
  const isFryer = station === "fryer";
  // the tray splits into ready "Cooked Items" and still-raw "Uncooked Items"
  // (things like an uncooked pizza that still need the oven/fryer)
  const cookedItems = tray.filter((e) => !e.uncooked);
  const uncookedItems = tray.filter((e) => e.uncooked);
  const cookedTotal = cookedItems.reduce((n, e) => n + e.count, 0);
  const uncookedTotal = uncookedItems.reduce((n, e) => n + e.count, 0);
  // burnt food actually binnable here — the sweep only reaches the tray store,
  // never inventory-held ("Item") entries
  const burntTotal = cookedItems.reduce((n, e) => n + (e.burnt && e.source !== "inv" ? e.count : 0), 0);
  // text filter (matches the name, flavor, and component/topping names) + a stable
  // sort: alphabetical, burnt last — so the bin candidates never hide mid-strip
  const q = query.trim().toLowerCase();
  const trayMatches = (e: TrayEntry) =>
    !q ||
    [e.label || prettyItem(e.item), e.flavorLabel, ...(e.comps || []).map((c) => c.label), ...(e.extras || []).map((c) => c.label)]
      .some((t) => !!t && t.toLowerCase().includes(q));
  const sortTray = (list: TrayEntry[]) =>
    [...list].sort(
      (a, b) =>
        Number(!!a.burnt) - Number(!!b.burnt) ||
        (a.label || prettyItem(a.item)).localeCompare(b.label || prettyItem(b.item)) ||
        (a.sig || "").localeCompare(b.sig || "")
    );
  const trayListAll = tab === "uncooked" ? uncookedItems : cookedItems;
  const trayList = sortTray(trayListAll.filter(trayMatches));
  // kitchen equipment (serving tray, pizza box, baking tray) is its own "Containers &
  // Packaging" category — the gear food gets arranged on/in — split out of both the
  // raw ingredients and the cooked-food tabs so neither is crowded by it
  const isEquipment = (ing: Ingredient) =>
    ing.kind === "tray" || ing.kind === "pizzabox" || ing.kind === "baketray" || ing.kind === "bag" || ing.kind === "takeout";
  const equipmentCards = isPrep
    ? ingredients.filter((ing) => isEquipment(ing) && (!q || ing.label.toLowerCase().includes(q)))
    : [];
  const shownIngredients = ingredients.filter((ing) => !isEquipment(ing) && (!q || ing.label.toLowerCase().includes(q)));
  const switchView = (key: string) => {
    setView(key);
    fetchNui("cooking:setView", { view: key });
  };

  // Always render the *live* item for the active uid (never a frozen snapshot),
  // so a flip's swapped top/bottom + progress update immediately. The tooltip
  // fades when nothing is hovered or while dragging.
  useEffect(() => {
    if (hovered != null) setLastUid(hovered);
  }, [hovered]);
  const activeUid = hovered ?? lastUid;
  const shownChip = activeUid != null ? items.find((c) => c.uid === activeUid) : undefined;
  const panelVisible = hovered != null && !!shownChip && !!shownChip.onScreen && !dragging;

  // ── prep recipe tooltip: rank recipes for the hovered stack, keep a selection ──
  const ranked = useMemo(
    () => (tip ? rankRecipes(recipes, tip.provides || {}) : []),
    [recipes, tip]
  );
  // Default the selection to the most-related recipe; keep the player's pick while
  // it stays in the top 3, otherwise fall back to the first.
  const selected = ranked.find((r) => r.rec.output === selectedOutput) || ranked[0] || null;
  useEffect(() => {
    if (ranked.length && !ranked.some((r) => r.rec.output === selectedOutput)) {
      setSelectedOutput(ranked[0].rec.output);
    }
  }, [ranked, selectedOutput]);
  // A fresh stack resets the pick to its top recipe.
  useEffect(() => { setSelectedOutput(null); }, [tip?.sid]);

  // ── the Restaurant Bag tooltip: rank CRAFTS against the bag's contents exactly the
  //    way recipes rank against a stack, so the closest craft (and what it still needs)
  //    shows the same "Minecraft-style" way burgers do; keep a selection to compare. ──
  const bagRanked = useMemo(
    () => (tip?.takeout ? rankRecipes(crafts, tip.provides || {}) : []),
    [crafts, tip]
  );
  // Prop-based bag contents don't carry a label/image (only model-less pills do), so
  // resolve them from the catalogues (bar ingredients + craft/recipe components) for a
  // readable contents list.
  const itemMeta = useMemo(() => {
    const m: Record<string, { label?: string; image?: string }> = {};
    const add = (item?: string, label?: string, image?: string) => {
      if (!item) return;
      const cur = m[item] || {};
      m[item] = { label: cur.label ?? label, image: cur.image ?? image };
    };
    ingredients.forEach((i) => add(i.item, i.label, i.image));
    crafts.forEach((c) => c.components.forEach((k) => add(k.item, k.label, k.image)));
    recipes.forEach((r) => r.components.forEach((k) => add(k.item, k.label, k.image)));
    return m;
  }, [ingredients, crafts, recipes]);
  const bagContentsResolved = useMemo(
    () => (tip?.contents || []).map((c) => ({
      ...c,
      label: c.label || itemMeta[c.item]?.label,
      image: c.image || itemMeta[c.item]?.image,
    })),
    [tip?.contents, itemMeta]
  );
  const craftSelected = bagRanked.find((r) => r.rec.output === selectedCraftId) || bagRanked[0] || null;
  useEffect(() => {
    if (bagRanked.length && !bagRanked.some((r) => r.rec.output === selectedCraftId)) {
      setSelectedCraftId(bagRanked[0].rec.output);
    }
  }, [bagRanked, selectedCraftId]);
  // A fresh bag resets the pick to its top craft.
  useEffect(() => { setSelectedCraftId(null); }, [tip?.tid]);

  // A MADE product hovered on the table: it is a component of nothing, so the recipe
  // guide ranks nothing and the pile would fall silent. Name it from the recipe
  // catalogue instead — the boxed-food case (`tip.product`) generalized to every
  // finished build, which is what a freshly made sandwich standing on the prep table
  // is. Only consulted when nothing ranks, so a product used as a LAYER in a bigger
  // build still shows the guide.
  const madeProduct = useMemo(() => {
    if (!tip?.item || tip.product || tip.tray || ranked.length > 0) return null;
    const rec = recipes.find((r) => r.output === tip.item);
    if (!rec) return null;
    return { label: rec.label, image: rec.image, components: rec.components, eyebrow: _L("cook.finished_item") };
  }, [tip?.item, tip?.product, tip?.tray, ranked, recipes]);
  // A tray/box tooltip always shows; a build stack's only shows once it relates to a
  // recipe (an unranked pile has nothing to say). A MADE product — a takeout box set
  // back down, or any finished build — is neither: it ranks nothing, but it still has
  // to identify itself.
  const tipVisible = isPrep && tipShow && !!tip && !!tip.onScreen && !dragging
    && (tip.tray || tip.product || madeProduct ? true : ranked.length > 0);
  const onTipPin = (pinned: boolean) => {
    tipPinnedRef.current = pinned;
    if (pinned) {
      if (tipHideTimer.current) { clearTimeout(tipHideTimer.current); tipHideTimer.current = null; }
    } else {
      setTipShow(false); // left the tooltip and the stack — dismiss
    }
  };
  const onTipMake = () => {
    if (!tip || !selected?.ready) return;
    fetchNui("cooking:prepMakeStack", { sid: tip.sid, output: selected.rec.output });
    setTipShow(false);
    setTip(null);
    tipPinnedRef.current = false;
  };
  // The hovered product's Disassemble: un-make it WHERE IT STANDS. The Lua side
  // releases its reservation, un-makes it, and drops the component parts into its
  // place in the pile — so the parts land on the table instead of needing anywhere
  // to be carried to, which is the whole reason this lives here and not on a bar card.
  const onProductDisassemble = () => {
    if (tip?.puid == null) return;
    fetchNui("cooking:prepDisassemble", { puid: tip.puid });
    setTipShow(false);
    setTip(null);
    tipPinnedRef.current = false;
  };
  // the hovered serving tray's Make Meal / pizza box's Box It Up — the whole
  // arrangement becomes one item (a box closes its lid first, Lua-side)
  const onMealMake = () => {
    if (!tip?.tray || !(tip.count || 0) || tip.boxing) return;
    fetchNui("cooking:prepMakeMeal", { tid: tip.tid });
    setTipShow(false);
    setTip(null);
    tipPinnedRef.current = false;
  };
  // the box tooltip's Take Out — the pizza slides back out onto the table
  const onBoxTakeOut = () => {
    // both lidded vessels empty this way: the pizza box (one pile) and the takeout
    // box (whose contents are hidden in-world, so this is their only way out)
    if (!(tip?.box || tip?.takeout) || !(tip.count || 0) || tip.boxing) return;
    fetchNui("cooking:boxTakeOut", { tid: tip.tid });
    setTipShow(false);
    setTip(null);
    tipPinnedRef.current = false;
  };

  // ── the bin: two clicks to throw away (arm, then confirm within 2.5s) ────────
  const armConfirm = (key: string) => {
    setConfirmKey(key);
    if (confirmTimer.current) clearTimeout(confirmTimer.current);
    confirmTimer.current = window.setTimeout(() => setConfirmKey(null), 2500);
  };
  const discardEntry = (e: TrayEntry, key: string) => {
    if (confirmKey !== key) return armConfirm(key);
    setConfirmKey(null);
    fetchNui("cooking:trayDiscard", { item: e.item, count: e.count, sig: e.sig || "" });
  };
  const discardBurnt = () => {
    if (confirmKey !== "__burnt__") return armConfirm("__burnt__");
    setConfirmKey(null);
    fetchNui("cooking:trayDiscard", { burnt_only: true });
  };

  // ── drag ingredients out of the bar (live in-world placement) ───────────────
  const startPlace = (e: React.PointerEvent, ing: Ingredient) => {
    e.preventDefault();
    placingRef.current = true;
    setTab("ingredients");
    setDragging(true);
    fetchNui("cooking:beginPlace", { kind: ing.kind, item: ing.item });
  };
  // an uncooked tray item (e.g. an uncooked pizza) can be dragged straight into its
  // own station to cook — consumed from the tray rather than the inventory.
  const canCookHere = (e: TrayEntry) => !isPrep && !!e.uncooked && e.cookStation === station;

  // one contextual "what can I do with this here" line for the hover tooltip
  const trayHint = (e: TrayEntry): string => {
    if (isPrep && e.meal) return _L("cook.trayhint_meal");
    if (isPrep && e.decompose) return _L("cook.trayhint_decompose");
    if (isPrep) return _L("cook.trayhint_build");
    if (canCookHere(e)) return station === "fryer" ? _L("cook.trayhint_cook_fryer") : _L("cook.trayhint_cook_oven");
    if (e.uncooked) return _L("cook.trayhint_still_raw", e.cookStation === "fryer" ? _L("cook.station_word_fryer") : _L("cook.station_word_stovetop_oven"));
    if (e.stow) return _L("cook.trayhint_stow");
    if (e.source === "inv") return _L("cook.trayhint_in_inventory");
    if (e.burnt) return _L("cook.trayhint_burnt");
    return _L("cook.trayhint_take");
  };
  const ingHint = (ing: Ingredient): string => {
    // the gate first: a locked card is shown precisely so it can say why
    if (ing.locked) return _L("cook.ing_group_locked", ing.group || "?");
    if (ing.kind === "tray") return _L("cook.inghint_tray");
    if (ing.kind === "pizzabox") return _L("cook.inghint_pizzabox");
    if (ing.kind === "bag") return _L("cook.inghint_bag");
    if (ing.kind === "takeout") return _L("cook.inghint_takeout");
    if (ing.kind === "topping") return _L("cook.inghint_topping");
    if (ing.kind === "finish") return _L("cook.inghint_finish");
    if (ing.kind === "condiment") return _L("cook.inghint_condiment");
    if (ing.kind === "drink") return _L("cook.inghint_drink");
    if (ing.kind === "lid") return _L("cook.inghint_lid");
    if (isPrep) return _L("cook.inghint_prep");
    return station === "fryer" ? _L("cook.inghint_fryer") : _L("cook.inghint_stovetop");
  };
  const showBarTip = (ev: React.PointerEvent, tip: Omit<BarTip, "x" | "y">) => {
    if (barTipTimer.current) { clearTimeout(barTipTimer.current); barTipTimer.current = null; }
    barPinnedRef.current = false;
    const r = (ev.currentTarget as HTMLElement).getBoundingClientRect();
    setBarTip({ x: r.left + r.width / 2, y: r.top, ...tip });
  };
  // Close the card tooltip outright (a drag starts): it's rendered only while not
  // dragging, so leaving it PINNED would pop it straight back open on release —
  // its own pointer-leave can never fire once it has been unmounted.
  const dismissBarTip = () => {
    if (barTipTimer.current) { clearTimeout(barTipTimer.current); barTipTimer.current = null; }
    barPinnedRef.current = false;
    setBarTip(null);
  };
  // Leaving a card holds the tooltip briefly so the cursor can travel up onto its
  // action buttons; while hovered (pinned) it stays until the cursor leaves it.
  const hideBarTip = () => {
    if (barTipTimer.current) clearTimeout(barTipTimer.current);
    barTipTimer.current = window.setTimeout(() => {
      barTipTimer.current = null;
      if (!barPinnedRef.current) setBarTip(null);
    }, 250);
  };
  const onBarTipPin = (pinned: boolean) => {
    barPinnedRef.current = pinned;
    if (pinned) {
      if (barTipTimer.current) { clearTimeout(barTipTimer.current); barTipTimer.current = null; }
    } else {
      setBarTip(null); // left the tooltip and the card — dismiss
    }
  };
  const takeEntry = (e: TrayEntry, count: number) =>
    fetchNui("cooking:trayToInventory", { item: e.item, count, sig: e.sig || "" });
  // unwrap a pocketed serving back onto the kitchen tray. The SIG is the wrapper's
  // own variation — the server reads what it holds off the slot, never off this.
  const stowEntry = (e: TrayEntry, count = 1) =>
    fetchNui("cooking:invToTray", { count, sig: e.sig || "" });
  const startTrayCook = (ev: React.PointerEvent, e: TrayEntry) => {
    ev.preventDefault();
    placingRef.current = true;
    setDragging(true);
    fetchNui("cooking:beginPlace", { kind: "cook", item: e.item, source: e.source || "tray", sig: e.sig || "" });
  };
  // the serving tray / pizza box (kitchen prep): equipment, not an item — drag it
  // onto the table, arrange food on/in it, then turn the whole thing into one
  // meal item (kind "box" places the pizza box, lid closed).
  const startTrayPlace = (e: React.PointerEvent, kind?: string) => {
    e.preventDefault();
    trayPlaceRef.current = true;
    setDragging(true);
    setDragHint(
      kind === "box" ? _L("cook.draghint_box_down")
        : kind === "bag" ? _L("cook.draghint_bag_down")
        : kind === "takeout" ? _L("cook.draghint_takeout_down")
        : _L("cook.draghint_tray_down")
    );
    fetchNui("cooking:beginTrayPlace", { kind });
  };
  // the lid (soda machine): dragged as its real 3D prop and released over a
  // filled cup to press it on — same gesture as a cheese slice on a patty.
  const startLid = (e: React.PointerEvent, ing: Ingredient) => {
    e.preventDefault();
    lidRef.current = ing.item;
    setTab("ingredients");
    setDragging(true);
    fetchNui("cooking:beginLid", { item: ing.item, model: ing.model });
  };
  // toppings (cheese) aren't placed in the world — they're dragged onto a patty.
  // The real slice prop renders in 3D under the cursor (no 2D pill); releasing
  // over a cooked patty applies it.
  const startTopping = (e: React.PointerEvent, ing: Ingredient) => {
    e.preventDefault();
    toppingRef.current = { item: ing.item, model: ing.model };
    setTab("ingredients");
    setDragging(true);
    fetchNui("cooking:beginTopping", { item: ing.item, model: ing.model });
  };
  // finish tools (frosting): the chosen flavor rides the drag; the tube renders in
  // 3D under the cursor and is rubbed over a cooked target until fully coated —
  // the Lua side commits at full coverage (cookingFinishDone ends the drag state).
  const startFinish = (e: React.PointerEvent, ing: Ingredient) => {
    e.preventDefault();
    const flavor = finishFlavor[ing.item] ?? ing.flavors?.[0]?.id;
    if (!flavor) return;
    finishRef.current = ing.item;
    setTab("ingredients");
    setDragging(true);
    setDragHint(_L("cook.draghint_rub_tube"));
    fetchNui("cooking:beginFinish", { item: ing.item, flavor });
  };
  // baking mix: dragged as its bowl prop and rubbed over a placed EMPTY baking tray
  // (cake tin / cookie tray) until full — the Lua side fills the tray at full coverage
  // (cookingBakeDone ends the drag state).
  const startBakeMix = (e: React.PointerEvent, ing: Ingredient) => {
    e.preventDefault();
    bakeMixRef.current = ing.item;
    setTab("ingredients");
    setDragging(true);
    setDragHint(_L("cook.draghint_bakemix"));
    fetchNui("cooking:beginBakeMix", { item: ing.item });
  };
  // condiment bottle: dragged as its container prop and held over a build stack — the
  // bottle flips upside-down and squeezes once, laying a sauce layer on top (the Lua
  // side commits at squeeze end; cookingCondimentDone ends the drag state).
  const startCondiment = (e: React.PointerEvent, ing: Ingredient) => {
    e.preventDefault();
    condimentRef.current = ing.item;
    setTab("ingredients");
    setDragging(true);
    setDragHint(_L("cook.draghint_condiment"));
    fetchNui("cooking:beginCondiment", { item: ing.item });
  };
  // at the prep station, drag a tray item / ingredient onto the table to add a
  // layer. With a model it spawns a live 3D prop that follows the cursor (like the
  // stovetop); without one it falls back to a 2D ghost + auto-stack.
  const startPrepDrag = (
    e: React.PointerEvent, source: string,
    entry: { item: string; model?: string; label?: string; image?: string; dual?: boolean; top?: TopState; topModel?: string; decompose?: boolean; meal?: boolean; uncooked?: boolean; sig?: string; variant?: string; stack?: string[]; stackState?: string; finishTool?: string; takeout?: boolean; quad?: string; quadCrop?: Crop; lidModel?: string }
  ) => {
    e.preventDefault();
    // A bun is one item spawned as a bottom+top pair (handled client-side), so no
    // half hint is needed here.
    //
    // TAKING A PRODUCT APART IS AN EXPLICIT CHOICE, MADE ON THE TABLE. A finished
    // product used to come apart into its components the moment it was dropped,
    // which made it impossible to put the product itself anywhere — dropping a
    // burger in the Restaurant Bag bagged a bun and a patty instead of a burger. So
    // it drags as ITSELF (the normal place path) and lands whole; hovering it out on
    // the table then offers Disassemble (cooking:prepDisassemble), which un-makes it
    // in place, where the parts have somewhere to go.
    // A MEAL is the exception and always un-makes on drop: it isn't one food but a
    // tray arrangement, and setting it down IS its tray coming back (there is no
    // single "meal prop" to place).
    const decompose = !!entry.decompose && !!entry.meal;
    // the exact build variation this drag addresses: tray entries always carry a
    // sig; inventory PRODUCT entries carry one too (slot metadata). Plain
    // Ingredients-bar components have none — they reserve item-wide.
    const sig = entry.sig ?? (source === "tray" ? "" : undefined);
    // model doubles as the "3D drag in progress" marker on release — a stack-only
    // entry uses its base layer so the endPrepPlace commit path still runs
    const dragModel = entry.model || (entry.stack && entry.stack.length > 1 ? entry.stack[0] : null);
    prepDragRef.current = { source, item: entry.item, model: dragModel, decompose, sig };
    // stay on the tab the card actually lives in: tray entries AND inventory-held
    // products (they carry a sig) file under Cooked/Uncooked; only true
    // Ingredients-bar components switch to Ingredients
    const fromTab = source === "tray" || entry.sig !== undefined;
    dragSwitchTab(fromTab ? (entry.uncooked ? "uncooked" : "cooked") : "ingredients");
    setDragging(true);
    dismissBarTip(); // the drag may have started ON the tooltip (Disassemble)
    setDragHint(decompose ? _L("cook.draghint_prep_apart") : _L("cook.draghint_prep_stack"));
    if (decompose) {
      // preview the whole component stack (peeked, nothing consumed) under the
      // cursor; source tells the server which store holds it (tray vs inventory)
      fetchNui("cooking:beginPrepDecompose", { item: entry.item, sig, source });
    } else if (entry.model || (entry.stack && entry.stack.length > 1)) {
      // a product carrying a build stack (e.g. a cooked pizza) drags as its whole
      // layer tower, not just the base model
      fetchNui("cooking:beginPrepPlace", {
        item: entry.item, model: entry.model,
        dual: entry.dual ? 1 : 0, top: entry.top, topModel: entry.topModel,
        sig, variant: entry.variant,
        stack: entry.stack, state: entry.stackState, finishTool: entry.finishTool,
        // A made takeout box: the box pair + the food image drawn inside it, at the
        // exact source rect the admin cropped (the world quad honours it).
        // The two pictures are NOT interchangeable — `quad` is what's painted inside
        // the open box, `image` is the food's card art — and the box carries the
        // FOOD's name, not the vessel's, so both ride along for the hover tooltip.
        takeout: entry.takeout ? 1 : 0, lidModel: entry.lidModel,
        image: entry.quad, imageCrop: entry.quadCrop,
        label: entry.label, itemImage: entry.image,
      });
    } else {
      // A model-less component (no prop): still run the Lua drag so it can be dropped
      // into the Restaurant Bag as an ent-less "pill" part. There's no world prop to
      // preview, so the 2D ghost gives cursor feedback; `pill` routes release to
      // endPrepPlace (the pill only lands in a bag; refused elsewhere, server-side).
      prepDragRef.current = { source, item: entry.item, model: null, pill: true, sig };
      fetchNui("cooking:beginPrepPlace", {
        item: entry.item, source, sig, variant: entry.variant,
        label: entry.label || prettyItem(entry.item), image: entry.image,
      });
      setGhost({ x: e.clientX, y: e.clientY, label: entry.label || prettyItem(entry.item), image: entry.image });
    }
  };

  // ── world interaction: drag the real prop, or click it (flip) / the grill ───
  const onWorldDown = (e: React.PointerEvent) => {
    if (e.button !== 0) return;
    e.preventDefault();
    // at prep, pressing on a placed part grabs it to restack freely
    if (isPrep) {
      const puid = prepHoveredRef.current;
      if (puid != null) {
        prepMoveRef.current = { puid };
        setDragging(true);
        setWorldDragging(true);
        dragSwitchTab("cooked"); // a placed part is a cooked product
        setDragHint(_L("cook.draghint_restack"));
        fetchNui("cooking:prepGrab", { puid });
        return;
      }
      // no part hovered: grab the serving tray itself (with everything on it)
      const tid = trayHoveredRef.current;
      if (tid != null) {
        // a pizza box waits to see what the press becomes: a click toggles the
        // lid, moving past the drag threshold grabs the whole box (onMove)
        if (trayHoveredBoxRef.current) {
          pendingBoxRef.current = { tid, x: e.clientX, y: e.clientY };
          return;
        }
        prepMoveRef.current = { tray: true };
        setDragging(true);
        setWorldDragging(true);
        dragSwitchTab("cooked");
        setDragHint(_L("cook.draghint_tray_meal"));
        fetchNui("cooking:trayGrab", { tid });
      }
      return;
    }
    worldRef.current = { uid: hoveredRef.current, startX: e.clientX, startY: e.clientY, dragging: false };
  };

  useEffect(() => {
    const DRAG_THRESH = 49; // px^2 (~7px) before a press becomes a drag (vs a click/flip)
    const onMove = (e: PointerEvent) => {
      // only the no-model prep fallback uses a 2D ghost now (everything else is 3D)
      if (prepDragRef.current && !prepDragRef.current.model) setGhost((g) => (g ? { ...g, x: e.clientX, y: e.clientY } : g));
      // a pressed pizza box that travels past the threshold becomes a grab drag
      const pb = pendingBoxRef.current;
      if (pb) {
        const dx = e.clientX - pb.x, dy = e.clientY - pb.y;
        if (dx * dx + dy * dy > DRAG_THRESH) {
          pendingBoxRef.current = null;
          prepMoveRef.current = { tray: true };
          setDragging(true);
          setWorldDragging(true);
          dragSwitchTab("cooked");
          setDragHint(_L("cook.draghint_box_meal"));
          fetchNui("cooking:trayGrab", { tid: pb.tid });
        }
      }
      const w = worldRef.current;
      if (w && w.uid != null && !w.dragging) {
        const dx = e.clientX - w.startX, dy = e.clientY - w.startY;
        if (dx * dx + dy * dy > DRAG_THRESH) {
          // an item in a lowered fryer basket can't be grabbed at all — the drag
          // never starts (no reaching into hot oil; raise the basket first)
          if (itemsRef.current.find((c) => c.uid === w.uid)?.locked) return;
          w.dragging = true;
          setDragging(true);       // hide the tooltip while moving the prop
          setWorldDragging(true);  // darken the hotbar as the drop zone
          setDragHint(_L("cook.draghint_collect_down"));
          dragSwitchTab("cooked"); // dragging a cooked prop -> show where it'll land
          fetchNui("cooking:beginMove", { uid: w.uid });
        }
      }
    };
    const onUp = (e: PointerEvent) => {
      const overBar = !!barRef.current && inRect(e.clientX, e.clientY, barRef.current.getBoundingClientRect());
      setDragging(false);
      setDragHint(null);
      setWorldDragging(false);
      // keep the drag's category only when it lands on the prep (not on the bar /
      // cancelled) — else fall back to the tab we were browsing before the drag
      endDragTab(!overBar);

      // a press on a pizza box that never became a drag: a click — toggle the lid
      if (pendingBoxRef.current) {
        const tid = pendingBoxRef.current.tid;
        pendingBoxRef.current = null;
        fetchNui("cooking:boxToggle", { tid });
        return;
      }

      // dragging a fresh serving tray / pizza box out of the bar: drop on the
      // table places it
      if (trayPlaceRef.current) {
        trayPlaceRef.current = false;
        fetchNui("cooking:endTrayPlace", { cancel: overBar });
        return;
      }

      // re-dragged a placed prep part (or a grabbed serving tray): drop on the bar
      // removes it (a tray becomes its meal), else it stays / moves
      if (prepMoveRef.current) {
        prepMoveRef.current = null;
        fetchNui("cooking:prepDrop", { cancel: overBar });
        return;
      }

      // finish tool (frosting) released before full coverage: cancels harmlessly
      // (coverage resets, nothing consumed). At full coverage the Lua side already
      // committed and cleared the drag via cookingFinishDone.
      if (finishRef.current) {
        finishRef.current = null;
        fetchNui("cooking:endFinish", { cancel: overBar });
        return;
      }

      // baking mix released before the tray is full: cancels harmlessly (nothing
      // consumed). At full coverage the Lua side already filled the tray and cleared
      // the drag via cookingBakeDone.
      if (bakeMixRef.current) {
        bakeMixRef.current = null;
        fetchNui("cooking:endBakeMix", { cancel: overBar });
        return;
      }

      // condiment bottle released before the squeeze finishes: cancels harmlessly
      // (nothing reserved/consumed). At squeeze end the Lua side already committed
      // the sauce layer and cleared the drag via cookingCondimentDone.
      if (condimentRef.current) {
        condimentRef.current = null;
        fetchNui("cooking:endCondiment", {});
        return;
      }

      // lid dropped onto a filled soda cup — the live 3D lid ends here; the
      // server caps the hovered cup (or it just cancels).
      if (lidRef.current) {
        lidRef.current = null;
        const uid = hoveredRef.current;
        fetchNui("cooking:endLid", { uid: overBar ? null : uid, cancel: overBar });
        return;
      }

      // topping (cheese) dropped onto a patty — the live 3D slice ends here; the
      // server sticks it on the hovered patty (or it just cancels).
      if (toppingRef.current) {
        const t = toppingRef.current;
        toppingRef.current = null;
        const uid = hoveredRef.current;
        fetchNui("cooking:endTopping", { uid: overBar ? null : uid, cancel: overBar, item: t.item });
        return;
      }

      // prep-table drag dropped onto the table (anywhere but the bar)
      if (prepDragRef.current) {
        const p = prepDragRef.current;
        prepDragRef.current = null;
        setGhost(null);
        if (p.decompose) {
          // a finished product — take it apart into its component stack on drop
          // (a meal recreates its full tray + arrangement)
          fetchNui("cooking:endPrepDecompose", { cancel: overBar, item: p.item, sig: p.sig, source: p.source });
        } else if (p.model || p.pill) {
          // live 3D placement (or a model-less pill destined for a bag) — commit,
          // or cancel back over the bar
          fetchNui("cooking:endPrepPlace", { cancel: overBar, source: p.source, item: p.item, sig: p.sig });
        } else if (!overBar) {
          fetchNui("cooking:prepAdd", { source: p.source, item: p.item, sig: p.sig });
        }
        return;
      }

      // ingredient placement from the bar
      if (placingRef.current) {
        placingRef.current = false;
        fetchNui("cooking:endPlace", { cancel: overBar });
      }

      // world prop interaction
      const w = worldRef.current;
      worldRef.current = null;
      if (w) {
        if (w.uid != null) {
          if (w.dragging) {
            if (overBar) fetchNui("cooking:collect", { uid: w.uid });
            else fetchNui("cooking:endMove", { cancel: false });
          } else {
            // a click (no drag) on a patty flips it; only dual patties flip. A
            // click on a soda cup falls through to the tap under the cursor —
            // the cup sits right below its nozzle, so it must not eat the click.
            const it = itemsRef.current.find((c) => c.uid === w.uid);
            if (it?.dual) fetchNui("cooking:flip", { uid: w.uid });
            else if (it?.method === "soda") fetchNui("cooking:worldClick");
          }
        } else if (!w.dragging) {
          // clicked empty grill -> toggle the oven door under the cursor
          fetchNui("cooking:worldClick");
        }
      }
    };
    window.addEventListener("pointermove", onMove);
    window.addEventListener("pointerup", onUp);
    return () => {
      window.removeEventListener("pointermove", onMove);
      window.removeEventListener("pointerup", onUp);
    };
  }, []);

  useEffect(() => () => { if (confirmTimer.current) clearTimeout(confirmTimer.current); }, []);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key !== "Escape") return;
      // Escape inside the search box clears it and leaves the box; the next
      // Escape closes the station
      const t = e.target as HTMLElement | null;
      if (t && t.tagName === "INPUT") { (t as HTMLInputElement).blur(); setQuery(""); return; }
      fetchNui("cooking:close");
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, []);

  // 1 / 2 jump to that oven door; pressing the door you're already looking at
  // comes back up to the cooktop, so one key both opens and closes a door view.
  useEffect(() => {
    if (!isStove) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key !== "1" && e.key !== "2") return;
      const t = e.target as HTMLElement | null;
      if (t && (t.tagName === "INPUT" || t.tagName === "TEXTAREA" || t.isContentEditable)) return;
      const door = e.key === "1" ? "door1" : "door2";
      switchView(view === door ? "stovetop" : door);
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [isStove, view]);

  const meta = STATION_META()[station] || STATION_META().fryer;
  const Icon = meta.icon;

  const draggable = (ing: Ingredient) =>
    // a card the restaurant's GROUPS don't carry is shown (so the gate explains
    // itself) but can never be dragged — the server refuses it in prepAdd anyway
    ing.locked ? false :
    // tray + pizza box + lid are kitchen equipment, never gated on an item count
    ing.kind === "tray" || ing.kind === "pizzabox" || ing.kind === "bag" || ing.kind === "takeout" || ing.kind === "lid"
      ? true : ing.kind === "assembly" ? !!ing.canMake : (ing.count || 0) > 0;

  // One-row strip by default (wheel scrolls it sideways); expanded — or while
  // searching — the strip wraps into a scrollable grid. A drag always collapses
  // back to one row so the bar never covers the kitchen mid-gesture.
  const gridMode = (expanded || !!q) && !dragging;
  const rowCls = cn(
    "min-h-[132px] gap-2 pb-1",
    gridMode ? "flex max-h-[40vh] flex-wrap content-start overflow-y-auto pr-1 pb-4" : "flex items-center overflow-x-auto"
  );
  const onRowWheel = (e: React.WheelEvent<HTMLDivElement>) => {
    if (gridMode) return;
    if (Math.abs(e.deltaY) > Math.abs(e.deltaX)) e.currentTarget.scrollLeft += e.deltaY;
  };

  // Take / Discard live on the hovered card's tooltip, not the card itself —
  // tray-held entries only (inventory "Item" entries are already taken).
  const entryKey = (e: TrayEntry) => e.item + "|" + (e.sig || "") + "|" + (e.source || "tray");
  const tipEntry = barTip?.tray;
  const tipKey = tipEntry ? entryKey(tipEntry) : "";
  // Taking a product apart is offered on the PLACED item's own tooltip out on the
  // table (ProductTooltip), never here: a card in the bar has nowhere to put the
  // parts, and the whole point of dragging one out is that it lands as itself.
  // A POCKETED SERVING goes back the way it came: one button that unwraps the
  // Restaurant Item onto this restaurant's kitchen tray, where it is an ordinary
  // cooked item again. This is the receiving half of handing food to another
  // worker — and the only kitchen action a wrapped serving has, which is why it is
  // the tooltip's whole action row rather than one button among several.
  const tipActions =
    tipEntry && tipEntry.stow ? (
      <div className="mt-2.5 flex items-center gap-1.5 border-t border-border/60 pt-2.5">
        <button
          onClick={() => stowEntry(tipEntry)}
          className="rounded-md bg-secondary px-2.5 py-1 text-[11px] font-semibold text-foreground transition hover:bg-accent"
        >
          {_L("cook.stow")}
        </button>
        {tipEntry.count > 1 && (
          <button
            onClick={() => stowEntry(tipEntry, tipEntry.count)}
            className="rounded-md bg-secondary px-2.5 py-1 text-[11px] font-semibold text-foreground transition hover:bg-accent"
          >
            {_L("cook.stow_all")}
          </button>
        )}
      </div>
    ) : tipEntry && tipEntry.source !== "inv" ? (
      <div className="mt-2.5 flex items-center gap-1.5 border-t border-border/60 pt-2.5">
        {/* Take / Take all only for something the inventory can actually HOLD. Most
            cooked products are tray-only by design (cooked fries have no item to
            become — they leave the kitchen inside a meal or a bag) and burnt food is
            unexchangeable, so the server refuses both; the flag is its answer, not a
            guess made here. The bin is still offered — it's the only way to clear
            those. */}
        {tipEntry.takeable && (<>
        <button
          onClick={() => takeEntry(tipEntry, 1)}
          className="rounded-md bg-secondary px-2.5 py-1 text-[11px] font-semibold text-foreground transition hover:bg-accent"
        >
          {tipEntry.count > 1 ? _L("cook.take_1") : _L("cook.take")}
        </button>
        {tipEntry.count > 1 && (
          <button
            onClick={() => takeEntry(tipEntry, tipEntry.count)}
            className="rounded-md bg-secondary px-2.5 py-1 text-[11px] font-semibold text-foreground transition hover:bg-accent"
          >
            {_L("cook.take_all")}
          </button>
        )}
        </>)}
        <button
          onClick={() => discardEntry(tipEntry, tipKey)}
          className={cn(
            "ml-auto flex items-center gap-1 rounded-md px-2.5 py-1 text-[11px] font-semibold transition",
            confirmKey === tipKey
              ? "bg-red-500/25 text-red-200 ring-1 ring-red-500"
              : "bg-secondary text-foreground hover:bg-red-500/20 hover:text-red-200"
          )}
        >
          <Trash2 className="h-3 w-3" />
          {confirmKey === tipKey ? _L("cook.confirm") : _L("cook.discard")}
        </button>
      </div>
    ) : null;

  return (
    <>
      {/* world layer — press to grab/drag the hovered prop, click to flip it or
          toggle an oven door. The status panel above sits over this layer but is
          click-through, so clicks still reach the patty. */}
      <div className="fixed inset-0" onPointerDown={onWorldDown} />

      {/* instructional dotted drop-zone for a drag OUT of the bar (onto the world/table).
          A drag FROM the world shows the same modal over the hotbar instead (above). */}
      {dragHint && !worldDragging && (
        <div className="pointer-events-none fixed inset-x-0 bottom-44 top-20 z-30 flex items-center justify-center px-6">
          <div className="flex flex-col items-center gap-2 rounded-2xl border-2 border-dashed border-primary/60 bg-primary/5 px-12 py-10 text-center">
            <UtensilsCrossed className="h-8 w-8 text-primary/80" />
            <span className="text-sm font-semibold text-primary">{dragHint}</span>
          </div>
        </div>
      )}


      {/* hover status panel — fades in/out over the hovered prop, click-through */}
      <div
        className={cn(
          "pointer-events-none fixed z-40 -translate-x-1/2 -translate-y-[120%] transition-all duration-200 ease-out",
          panelVisible ? "opacity-100 scale-100" : "opacity-0 scale-95"
        )}
        style={{ left: `${(shownChip?.x ?? 0.5) * 100}%`, top: `${(shownChip?.y ?? 0.5) * 100}%` }}
      >
        <div className="relative">
          {shownChip && <StatusPanel c={shownChip} meta={itemMeta} />}
          {/* caret pointing down at the prop */}
          <div className="absolute left-1/2 top-full h-0 w-0 -translate-x-1/2 border-x-[6px] border-t-[6px] border-x-transparent border-t-card" />
        </div>
      </div>

      {/* prep recipe tooltip — floats over the hovered stack; interactive (unlike the
          status panel) so recipes can be picked and the stack built from here */}
      <div
        className={cn(
          "fixed z-40 -translate-x-1/2 -translate-y-[120%] transition-all duration-200 ease-out",
          tipVisible ? "opacity-100 scale-100" : "pointer-events-none opacity-0 scale-95"
        )}
        style={{ left: `${(tip?.x ?? 0.5) * 100}%`, top: `${(tip?.y ?? 0.5) * 100}%` }}
      >
        <div className="relative">
          {tip?.bake ? (
            <BakeTrayTooltip filled={!!tip.filled} onPin={onTipPin} />
          ) : tip?.product ? (
            <ProductTooltip product={tip.product} onPin={onTipPin} />
          ) : tip?.takeout ? (
            <BagTooltip contents={bagContentsResolved} ranked={bagRanked} selected={craftSelected}
              count={tip.count || 0} open={!!tip.open} boxing={!!tip.boxing}
              onSelect={setSelectedCraftId} onBag={onMealMake} onTakeOut={onBoxTakeOut} onPin={onTipPin} />
          ) : tip?.tray ? (
            <MealTooltip count={tip.count || 0} box={!!tip.box} bag={!!tip.bag} open={!!tip.open} boxing={!!tip.boxing}
              contents={tip.contents}
              onMake={onMealMake} onTakeOut={onBoxTakeOut} onPin={onTipPin} />
          ) : madeProduct ? (
            <ProductTooltip product={madeProduct} onDisassemble={onProductDisassemble} onPin={onTipPin} />
          ) : (
            <BuildTooltip ranked={ranked} selected={selected} onSelect={setSelectedOutput} onMake={onTipMake} onPin={onTipPin} />
          )}
          <div className="absolute left-1/2 top-full h-0 w-0 -translate-x-1/2 border-x-[6px] border-t-[6px] border-x-transparent border-t-card" />
        </div>
      </div>

      {/* hover tooltip for a bar card (tray item / ingredient) */}
      {barTip && !dragging && <BarTooltip tip={barTip} actions={tipActions} onPin={onBarTipPin} meta={itemMeta} />}

      {/* floating ghost while dragging a topping (cheese) onto a patty */}
      {ghost && (
        <div
          style={{ left: ghost.x, top: ghost.y }}
          className="pointer-events-none fixed z-50 flex -translate-x-1/2 -translate-y-1/2 items-center gap-1.5 rounded-lg border border-primary/60 bg-card px-2 py-1 text-xs font-semibold shadow-2xl"
        >
          <ItemThumb src={ghost.image} alt={ghost.label} className="h-6 w-6 object-contain" />
          {ghost.label}
        </div>
      )}

      {/* full-width bottom bar — the kitchen rail, wearing the franchise theme */}
      <div
        ref={barRef}
        className="fixed inset-x-0 bottom-0 animate-fade-in border-t border-border bg-background px-4 py-3 shadow-2xl"
      >
        <div className="brand-hairline absolute inset-x-0 top-0 h-0.5" />
        {/* dragging a prop FROM the world: a SEPARATE dark overlay laid over the whole
            hotbar, with the dotted drop-zone modal centred on it — the hotbar itself is
            the drop target (drop here to collect / make a meal). */}
        {worldDragging && (
          <div className="pointer-events-none absolute inset-0 z-20 flex items-center justify-center bg-black/25">
            <div className="flex items-center gap-2 rounded-2xl border-2 border-dashed border-primary/60 bg-primary/5 px-10 py-4">
              <UtensilsCrossed className="h-6 w-6 text-primary/80" />
              <span className="text-sm font-semibold text-primary">{dragHint || _L("cook.drop_here_collect")}</span>
            </div>
          </div>
        )}
        <div className="mb-2 flex items-center justify-between">
          <div className="flex min-w-0 items-center gap-2.5">
            <div className="grid h-7 w-7 shrink-0 place-items-center rounded-md bg-primary/15 text-primary">
              <Icon className="h-4 w-4" />
            </div>
            <span className="font-display text-sm font-bold tracking-tight">{meta.label}</span>
            <span className="truncate text-xs text-muted-foreground">{meta.hint}</span>
          </div>
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <UtensilsCrossed className="h-3.5 w-3.5" />
            {_L("cook.drag_cooked_here")}
            <button onClick={() => fetchNui("cooking:close")} className="ml-2 rounded-md p-1 hover:bg-accent">
              <X className="h-4 w-4" />
            </button>
          </div>
        </div>

        <div className="flex gap-3">
          {/* stovetop view switcher — icon tabs for the cooktop and each oven door;
              the pictures do the talking (labels only on hover) */}
          {isStove && (
            <div className="flex shrink-0 flex-col justify-center gap-1.5 border-r border-border pr-3">
              {STOVE_VIEWS().map((v) => {
                const VIcon = v.icon;
                const active = view === v.key;
                return (
                  <button
                    key={v.key}
                    title={v.label}
                    onClick={() => switchView(v.key)}
                    className={cn(
                      "relative flex h-10 w-10 items-center justify-center rounded-lg border transition",
                      active
                        ? "border-primary bg-primary text-primary-foreground"
                        : "border-border bg-secondary text-muted-foreground hover:border-primary/60 hover:text-foreground"
                    )}
                  >
                    <VIcon className="h-5 w-5" />
                    {v.num != null && (
                      <span
                        className={cn(
                          "absolute -bottom-1 -right-1 flex h-4 w-4 items-center justify-center rounded-full border text-[9px] font-bold",
                          active
                            ? "border-primary bg-background text-primary"
                            : "border-border bg-background text-muted-foreground"
                        )}
                      >
                        {v.num}
                      </span>
                    )}
                  </button>
                );
              })}
            </div>
          )}

          <div className="min-w-0 flex-1">
        {/* tabs: raw ingredients · ready cooked items · still-raw uncooked items —
            plus the bar tools on the right: burnt sweep, search, one-row/grid toggle */}
        <div className="mb-2 flex items-center gap-1">
          {(([
            // Containers & Packaging (serving trays, pizza boxes, baking trays) leads the
            // strip — the kitchen equipment food gets arranged on/in. Only shown at the
            // prep table (the sole station with equipment); other stations start at
            // Ingredients. Kept as its own category so cooked food isn't crowded by gear.
            ...(isPrep ? [["packaging", _L("cook.tab_packaging"), Package, equipmentCards.length]] : []),
            ["ingredients", _L("cook.tab_ingredients"), Carrot, shownIngredients.length],
            ["cooked", _L("cook.tab_cooked_items"), ChefHat, cookedTotal],
            ["uncooked", _L("cook.tab_uncooked_items"), CookingPot, uncookedTotal],
          ]) as ["packaging" | "ingredients" | "cooked" | "uncooked", string, React.ComponentType<{ className?: string }>, number][]).map(([key, label, TabIcon, count]) => (
            <button
              key={key}
              onClick={() => setTab(key)}
              className={cn(
                "flex items-center gap-1.5 rounded-md px-3 py-1 text-xs font-semibold transition",
                tab === key ? "bg-primary text-primary-foreground" : "bg-secondary text-muted-foreground hover:bg-accent"
              )}
            >
              <TabIcon className="h-3.5 w-3.5" />
              {label}
              {count > 0 ? ` (${count})` : ""}
            </button>
          ))}
          <div className="ml-auto flex items-center gap-1.5">
            {tab === "cooked" && burntTotal > 0 && (
              <button
                onClick={discardBurnt}
                className={cn(
                  "flex items-center gap-1 rounded-md border px-2 py-1 text-[11px] font-semibold transition",
                  confirmKey === "__burnt__"
                    ? "border-red-500 bg-red-500/20 text-red-200"
                    : "border-border bg-secondary text-foreground hover:border-red-500/60 hover:text-red-200"
                )}
              >
                <Trash2 className="h-3.5 w-3.5" />
                {confirmKey === "__burnt__" ? _L("cook.click_again_confirm") : _L("cook.discard_burnt", burntTotal)}
              </button>
            )}
            <div className="relative">
              <Search className="pointer-events-none absolute left-2 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-muted-foreground" />
              <input
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder={_L("cook.search_placeholder")}
                className="h-[26px] w-40 rounded-md border border-border bg-muted/50 pl-7 pr-6 text-xs outline-none placeholder:text-muted-foreground/70 focus:border-primary/60"
              />
              {query && (
                <button
                  onClick={() => setQuery("")}
                  className="absolute right-1 top-1/2 -translate-y-1/2 rounded p-0.5 text-muted-foreground hover:text-foreground"
                >
                  <X className="h-3 w-3" />
                </button>
              )}
            </div>
            <button
              title={expanded ? _L("cook.collapse_row") : _L("cook.show_grid")}
              onClick={() => setExpanded((v) => !v)}
              className={cn(
                "flex h-[26px] w-[26px] items-center justify-center rounded-md border transition",
                expanded
                  ? "border-primary bg-primary text-primary-foreground"
                  : "border-border bg-secondary text-muted-foreground hover:border-primary/60 hover:text-foreground"
              )}
            >
              {expanded ? <ChevronDown className="h-4 w-4" /> : <ChevronUp className="h-4 w-4" />}
            </button>
          </div>
        </div>

        {tab === "ingredients" ? (
          <div className={rowCls} onWheel={onRowWheel}>
            {shownIngredients.length === 0 && (
              <div className="text-sm text-muted-foreground">
                {q && ingredients.length > 0
                  ? _L("cook.no_matches", query.trim())
                  : _L("cook.no_ingredients")}
              </div>
            )}
            {shownIngredients.map((ing, i) => {
              const can = draggable(ing);
              const onDown = (e: React.PointerEvent) => {
                if (!can) return;
                setBarTip(null);
                if (ing.kind === "tray") startTrayPlace(e);
                else if (ing.kind === "pizzabox") startTrayPlace(e, "box");
                else if (ing.kind === "bag") startTrayPlace(e, "bag");
                else if (ing.kind === "takeout") startTrayPlace(e, "takeout");
                else if (ing.kind === "lid") startLid(e, ing);
                else if (ing.kind === "topping") startTopping(e, ing);
                else if (ing.kind === "finish") startFinish(e, ing);
                else if (ing.kind === "bakemix") startBakeMix(e, ing);
                else if (ing.kind === "condiment") startCondiment(e, ing);
                else if (isPrep) startPrepDrag(e, "inv", { item: ing.item, model: ing.model, label: ing.label, image: ing.image, dual: ing.dual, variant: ing.variant });
                else startPlace(e, ing);
              };
              return (
                <div
                  key={ing.item + i}
                  onPointerDown={onDown}
                  onPointerEnter={(ev) => showBarTip(ev, { ing, hint: can || ing.locked ? ingHint(ing) : undefined })}
                  onPointerLeave={hideBarTip}
                  className={cn(
                    "relative flex h-32 shrink-0 touch-none select-none flex-col items-center justify-center gap-1 rounded-lg border text-center text-xs font-medium",
                    ing.kind === "finish" ? "w-32" : "w-28",
                    can
                      ? "cursor-grab border-border/80 bg-card hover:border-primary/50 hover:bg-accent/60 active:cursor-grabbing"
                      : "cursor-not-allowed border-dashed border-border/60 bg-muted/40 opacity-60"
                  )}
                >
                  {ing.kind === "tray" ? (
                    <UtensilsCrossed className="h-10 w-10 text-primary/80" />
                  ) : ing.kind === "pizzabox" ? (
                    <Package className="h-10 w-10 text-primary/80" />
                  ) : ing.kind === "bag" ? (
                    <ShoppingBag className="h-10 w-10 text-primary/80" />
                  ) : ing.kind === "lid" ? (
                    <ItemThumb
                      src={equipImageUrl("lid")}
                      alt={ing.label}
                      className="h-10 w-10 object-contain"
                      fallback={<CircleDot className="h-10 w-10 text-primary/80" />}
                    />
                  ) : (
                    <ItemThumb src={ing.image} alt={ing.label} className={ing.kind === "finish" ? "h-8 w-8 object-contain" : "h-10 w-10 object-contain"} />
                  )}
                  <span className="w-full truncate px-1.5 leading-tight">{ing.label}</span>
                  {ing.kind === "tray" && (
                    <span className="text-[10px] text-muted-foreground">{_L("cook.build_a_meal")}</span>
                  )}
                  {ing.kind === "pizzabox" && (
                    <span className="text-[10px] text-muted-foreground">{_L("cook.boxes_a_pizza")}</span>
                  )}
                  {ing.kind === "bag" && (
                    <span className="text-[10px] text-muted-foreground">{_L("cook.pack_a_bag")}</span>
                  )}
                  {ing.kind === "takeout" && (
                    <span className="text-[10px] text-muted-foreground">{_L("cook.craft_in_bag")}</span>
                  )}
                  {ing.kind === "lid" && (
                    <span className="text-[10px] text-muted-foreground">{_L("cook.caps_filled_drink")}</span>
                  )}
                  {/* finish tool: flavor picked right on the card (colored swatch
                      squares, hover for the flavor name), then drag to apply.
                      NOTE: native title tooltips don't render in NUI/CEF, so each
                      swatch carries its own CSS group-hover label. */}
                  {ing.kind === "finish" && !!ing.flavors?.length && (
                    <div className="mx-auto flex w-[70%] flex-wrap items-center justify-center gap-1">
                      {ing.flavors.map((fl) => {
                        const active = (finishFlavor[ing.item] ?? ing.flavors![0].id) === fl.id;
                        return (
                          <div key={fl.id} className="group relative">
                            <button
                              aria-label={fl.label}
                              onPointerDown={(ev) => ev.stopPropagation()}
                              onClick={() => setFinishFlavor((m) => ({ ...m, [ing.item]: fl.id }))}
                              style={{ backgroundColor: flavorColor(fl) }}
                              className={cn(
                                "block h-5 w-5 shrink-0 rounded-md border transition",
                                active
                                  ? "scale-110 border-white ring-2 ring-primary"
                                  : "border-black/40 opacity-70 hover:opacity-100"
                              )}
                            />
                            <span className="pointer-events-none absolute -top-6 left-1/2 z-50 hidden -translate-x-1/2 whitespace-nowrap rounded border border-border bg-card px-1.5 py-0.5 text-[9px] font-semibold text-foreground shadow-lg group-hover:block">
                              {fl.label}
                            </span>
                          </div>
                        );
                      })}
                    </div>
                  )}
                  {ing.kind !== "assembly" && ing.kind !== "tray" && ing.kind !== "pizzabox" && ing.kind !== "bag" && ing.kind !== "takeout" && ing.kind !== "lid" && (
                    <Badge variant="secondary" className="absolute right-1 top-1">{ing.count ?? 0}</Badge>
                  )}
                  {ing.kind === "assembly" && !ing.canMake && (
                    <span className="text-[10px] text-muted-foreground">{_L("cook.missing_parts")}</span>
                  )}
                  {/* stocked but not on this restaurant's menu — the card exists to
                      say so (hover names the group an admin has to add) */}
                  {ing.locked && (
                    <span className="text-[10px] font-semibold uppercase tracking-wide text-muted-foreground">
                      {_L("cook.locked")}
                    </span>
                  )}
                </div>
              );
            })}
          </div>
        ) : tab === "packaging" ? (
          <div className={rowCls} onWheel={onRowWheel}>
            {/* Containers & Packaging: the serving tray, pizza box and baking trays the
                cooked food gets arranged on/in — same drag-to-place gesture as before */}
            {equipmentCards.length === 0 && (
              <div className="text-sm text-muted-foreground">
                {q && ingredients.some(isEquipment)
                  ? _L("cook.no_matches", query.trim())
                  : _L("cook.no_packaging")}
              </div>
            )}
            {equipmentCards.map((ing) => (
              <div
                key={"equip-" + ing.kind + (ing.subkind || "")}
                onPointerDown={(e) => {
                  setBarTip(null);
                  if (ing.kind === "tray") startTrayPlace(e);
                  else if (ing.kind === "baketray") startTrayPlace(e, ing.subkind);
                  else if (ing.kind === "bag") startTrayPlace(e, "bag");
                  else if (ing.kind === "takeout") startTrayPlace(e, "takeout");
                  else startTrayPlace(e, "box");
                }}
                onPointerEnter={(ev) => showBarTip(ev, { ing, hint: ingHint(ing) })}
                onPointerLeave={hideBarTip}
                className="relative flex h-32 w-28 shrink-0 cursor-grab touch-none select-none flex-col items-center justify-center gap-1 rounded-lg border border-border/80 bg-card text-center text-xs font-medium hover:border-primary/50 hover:bg-accent/60 active:cursor-grabbing"
              >
                {/* A server-supplied image (web/public/items/, see lib/localImages)
                    replaces the placeholder icon when present; missing → the icon. */}
                <ItemThumb
                  src={equipImageUrl(ing.kind, ing.subkind)}
                  alt={ing.label}
                  className="h-10 w-10 object-contain"
                  fallback={
                    ing.kind === "tray" ? (
                      <UtensilsCrossed className="h-10 w-10 text-primary/80" />
                    ) : ing.kind === "baketray" ? (
                      <CookingPot className="h-10 w-10 text-primary/80" />
                    ) : ing.kind === "bag" ? (
                      <ShoppingBag className="h-10 w-10 text-primary/80" />
                    ) : (
                      <Package className="h-10 w-10 text-primary/80" />
                    )
                  }
                />
                <span className="w-full truncate px-1.5 leading-tight">{ing.label}</span>
                <span className="text-[10px] text-muted-foreground">
                  {ing.kind === "tray" ? _L("cook.build_a_meal")
                    : ing.kind === "baketray" ? _L("cook.rub_in_mix")
                    : ing.kind === "bag" ? _L("cook.pack_a_bag")
                    : ing.kind === "takeout" ? _L("cook.craft_in_bag")
                    : _L("cook.boxes_a_pizza")}
                </span>
              </div>
            ))}
          </div>
        ) : (
          <div className={rowCls} onWheel={onRowWheel}>
            {trayList.length === 0 && (
              <div className="text-sm text-muted-foreground">
                {q && trayListAll.length > 0
                  ? _L("cook.no_matches", query.trim())
                  : tab === "uncooked"
                    ? _L("cook.no_uncooked_items")
                    : _L("cook.no_cooked_items")}
              </div>
            )}
            {trayList.map((e, i) => {
              const cookHere = canCookHere(e);
              const fromInv = e.source === "inv";
              const cardKey = e.item + "|" + (e.sig || "") + "|" + (e.source || "tray") + "|" + i;
              // freshness: show a red countdown only in the final minute before it spoils
              const secs = expirySecs(e);
              const expiring = secs != null && secs > 0 && secs <= 59;
              return (
              <div
                key={cardKey}
                onPointerDown={(ev) => {
                  setBarTip(null);
                  // a pocketed serving has to be put back in the kitchen first (the
                  // tooltip's button) — it is a sealed vessel, not a loose product
                  if (e.wrapped) return;
                  if (isPrep) startPrepDrag(ev, e.source || "tray", e);
                  else if (cookHere) startTrayCook(ev, e);
                }}
                onPointerEnter={(ev) => showBarTip(ev, { tray: e, hint: trayHint(e) })}
                onPointerLeave={hideBarTip}
                className={cn(
                  "relative flex h-32 w-28 shrink-0 touch-none select-none flex-col items-center rounded-lg border bg-card pt-2 text-center text-xs font-medium",
                  e.burnt ? "border-red-900/70 bg-red-950/25" : "border-border/80",
                  e.wrapped ? "hover:border-border" :
                  (isPrep || cookHere) ? "cursor-grab hover:border-primary/50 hover:bg-accent/60 active:cursor-grabbing" : e.burnt ? "hover:border-red-800" : "hover:border-border"
                )}
              >
                {/* content block centered in the space above the action row */}
                <div className="flex min-h-0 w-full flex-1 flex-col items-center justify-center gap-0.5">
                  {/* a poured drink prefers its supplied per-flavor art, falling back
                      to the generic drink image (then nothing); everything else uses
                      its own inventory image as before */}
                  <ItemThumb
                    src={e.flavor ? drinkImageUrl(e.flavor) : e.image}
                    alt={e.label || prettyItem(e.item)}
                    className="h-10 w-10 object-contain"
                    fallback={e.flavor && e.image ? <ItemThumb src={e.image} alt={e.label || prettyItem(e.item)} className="h-10 w-10 object-contain" /> : undefined}
                  />
                  <span className="w-full truncate px-1.5 leading-tight">{e.label || prettyItem(e.item)}</span>
                  {/* flavor line for finished (frosted) products; toppings row for
                      everything else — fixed height so every card lines up */}
                  {e.flavorLabel ? (
                    <div className="flex h-[18px] items-center text-[9px] font-semibold text-pink-300">{e.flavorLabel}</div>
                  ) : (
                    <ToppingsRow e={e} />
                  )}
                </div>
                {/* hint chips pinned to the card's bottom edge — the actionable
                    buttons (Take / Discard) live on the hover tooltip instead */}
                <div className="flex w-full flex-col items-center gap-0.5 pb-1.5">
                  {cookHere && (
                    <span className="rounded bg-primary/15 px-1.5 py-0.5 text-[9px] font-semibold text-primary">
                      {station === "fryer" ? _L("cook.drag_into_basket") : _L("cook.drag_into_oven")}
                    </span>
                  )}
                </div>
                <Badge variant="secondary" className="absolute right-1 top-1">{e.count}</Badge>
                {/* origin marker (inventory item) + cheese state + freshness countdown.
                    The timer is always shown for a tray item that can spoil, red only
                    in its final minute. */}
                <div className="absolute left-1 top-1 flex items-center gap-0.5">
                  {secs != null && (
                    <span className={cn(
                      "flex items-center gap-0.5 rounded px-1 py-px text-[9px] font-bold tabular-nums",
                      expiring
                        ? "bg-red-500/25 text-red-300 ring-1 ring-red-500/40"
                        : "border border-border bg-background/70 text-muted-foreground"
                    )}>
                      <Timer className="h-2.5 w-2.5" />{fmtExpiry(secs)}
                    </span>
                  )}
                  {fromInv && (
                    <span className="rounded border border-border bg-background/70 px-1 py-px text-[8px] font-semibold uppercase tracking-wide text-muted-foreground">
                      {_L("cook.item_badge")}
                    </span>
                  )}
                  {e.top && (
                    metaImage(itemMeta, e.top.item)
                      ? <ItemThumb src={metaImage(itemMeta, e.top.item)} alt="" className="h-4 w-4 object-contain" />
                      : <span className="text-sm">🧀</span>
                  )}
                </div>
              </div>
              );
            })}
          </div>
        )}
          </div>
        </div>
      </div>
    </>
  );
}
