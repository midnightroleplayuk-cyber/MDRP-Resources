import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Field, TextField, NumberField, Select, Toggle, GroupField } from "@/components/form";
import ItemPicker, { type Item } from "@/components/ItemPicker";
import { Modal } from "@/components/ui/modal";
import { PhotoField, type PhotoEntry, type PhotoAspect } from "@/components/Branding";
import { cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { Plus, Trash2, TriangleAlert, ImageOff, ChevronDown, ChevronRight, Link2, ImagePlus, Pencil } from "lucide-react";

// A custom per-item image map (item name → { url, crop }), authored on the item
// thumbnails in the admin menu editors and stored in the `item_images` setting. When
// present it overrides the item's catalogue image everywhere it's shown. See
// `ItemField`'s editable thumbnail + `EntryThumb`.
export type ItemImages = Record<string, PhotoEntry>;
export type SetItemImage = (item: string, entry: PhotoEntry | null) => void;

// The item-image crop frame: a square (inventory-thumbnail shape). LAZY getter so
// `_L()` resolves at render, not module import.
let _itemPhoto: PhotoAspect | null = null;
const ITEM_PHOTO = (): PhotoAspect => (_itemPhoto ??= { label: _L("menu.item_image"), w: 512, h: 512, hint: _L("menu.item_image_hint") });
// The crop frame for the picture painted INSIDE a takeout box: the same rectangle
// the world quad is drawn at (Config.BoxQuad in core/shared.lua, metres — embedded
// config, fed to the panel read-only), so what an admin crops here is exactly what
// lands in the box. Falls back to the shipped values if the payload hasn't arrived.
export const BOX_PHOTO = (quad?: { w?: number; h?: number }): PhotoAspect => ({
  label: _L("menu.box_image"),
  w: Math.round((Number(quad?.w) || 0.295) * 1000),
  h: Math.round((Number(quad?.h) || 0.2) * 1000),
  hint: _L("menu.box_image_hint"),
});

// ─── shared item thumbnail ─────────────────────────────────────────────────────
// Inventory thumbnail for an item, with a graceful fallback when the image is
// missing or fails to load (different inventories store images differently).
export function ItemImage({ items, name, className }: { items: Item[]; name: string; className?: string }) {
  const img = items.find((i) => i.name === name)?.image;
  const [broken, setBroken] = useState(false);
  useEffect(() => setBroken(false), [img]); // a different item gets a fresh try
  if (!name || !img || broken) {
    return (
      <div className={cn("flex items-center justify-center rounded bg-muted/60 text-muted-foreground", className)}>
        <ImageOff className="h-1/2 w-1/2" />
      </div>
    );
  }
  return <img src={img} alt={name} onError={() => setBroken(true)} className={cn("rounded object-contain", className)} />;
}

// A thumbnail that prefers a custom item image (the live `itemImages` map, so it
// updates the instant one is set) and otherwise falls back to the catalogue image /
// icon via ItemImage. Custom photos render cover (they're real photos, not icons).
export function EntryThumb({ items, name, itemImages, className, url }: {
  items: Item[]; name: string; itemImages?: ItemImages; className?: string;
  /** An explicit image that wins over everything — a food's own authored picture,
   *  which belongs to no inventory item. */
  url?: string;
}) {
  const custom = url ? { url } : name ? itemImages?.[name] : undefined;
  const [broken, setBroken] = useState(false);
  useEffect(() => setBroken(false), [custom?.url]);
  if (custom?.url && !broken) {
    return <img src={custom.url} alt={name} onError={() => setBroken(true)} className={cn("rounded object-cover", className)} />;
  }
  return <ItemImage items={items} name={name} className={className} />;
}

// "frosting" / "raw_beef_patty" -> "Frosting" / "Raw Beef Patty". Fallback for a
// codename with no catalogue label, so names never render lowercase.
export function prettyName(name: string) {
  return name.replace(/[_-]+/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
}

export function labelOf(items: Item[], name: string) {
  if (!name) return "—";
  return items.find((i) => i.name === name)?.label ?? prettyName(name);
}

const modSlug = (s: string) => (s || "").toLowerCase().replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "");

// ─── the three menu shapes ─────────────────────────────────────────────────────
// Annotations (valid/missing/defaultPrice/tap/…) ride these from the server; they
// are stripped by Menu's clean() on the way back out.

export type Modifier = { id: string; label: string; item?: string; price?: number; default?: boolean };

export type Step =
  | { type: "assemble"; output?: string; label?: string; model?: string; components?: string[] }
  | {
      type: "cook"; input?: string; station: "fryer" | "stovetop";
      method?: "grill" | "oven" | "fry"; raw_model?: string; cooked_model?: string; burnt_model?: string;
      output?: string; output_burnt?: string; cook_ms?: number; burn_ms?: number; dual_sided?: 0 | 1 | boolean;
      output_count?: number; container_model?: string; expire_seconds?: number | null;
      serving_model?: string; serving_burnt_model?: string;
    }
  | { type: "pour"; input?: string; flavor?: string; model?: string; fill_ms?: number; color?: [number, number, number] };

// The eat/drink animations a food can be assigned (the `consume_anims` setting,
// seeded with defaults server-side and editable in Settings → Eating).
export type ConsumeAnim = { id: string; label?: string; dict: string; clip: string; prop?: string; ms?: number };
// What eating ONE serving of a food does. Anything left blank falls back to the
// global `consume` setting, so a food only states what makes it different.
export type FoodConsume = {
  hunger?: number | null; thirst?: number | null;
  /** Stress RELIEF (0-100). Drains a bar rather than filling one — what a DLC toy
   *  out of a kid's meal does. Never inherits the global fallback. */
  stress?: number | null;
  anim?: string;
  /** How many mouthfuls one serving takes. 1 = used in one go (a toy). */
  bites?: number | null;
};

export type Food = {
  id?: string;
  label?: string;
  kind: "interactive" | "bag";
  group?: string | null;
  steps?: Step[];
  components?: string[];
  /** The food's OWN picture as an ITEM — the kitchen bar card, the POS, a bag's
   *  contents menu, the inventory slot. */
  image?: PhotoEntry | null;
  /** What's painted on the quad INSIDE an open takeout box, when the card art
   *  doesn't work lying in a box. Falls back to `image`. Bag-kind foods only. */
  box_image?: PhotoEntry | null;
  consume?: FoodConsume;
  modifiers?: Modifier[];
  // server annotations
  valid?: boolean; missing?: string[]; defaultPrice?: number;
  box_item_installed?: boolean; serving_item_installed?: boolean; tap?: number;
  /** which part of this food consumes nothing — it can't be made in-game until
   *  it does ("components" | "cook_input" | "pour_cup" | "steps"). */
  no_input?: string;
  duplicate_input?: string; invalid_models?: string[];
  /** Set when the entry came from an installed DLC pack (its id). Such an entry
   *  is contributed by that pack's resource at runtime and is never stored here,
   *  so the panel shows it but never edits or saves it. */
  dlc?: string;
};

export type Tool = {
  id?: string; item?: string; tool_model?: string; group?: string | null;
  mode: "layer" | "decorate" | "fill";
  applied_model?: string;
  rub_dist?: number;
  targets?: {
    item?: string; output?: string; mode: "overlay" | "replace"; requires_finish?: string;
    flavors?: { id?: string; label?: string; model?: string; color?: string }[];
  }[];
  trays?: { kind?: string; label?: string; tray_model?: string; output?: string; raw_model?: string; slots?: number; group?: string }[];
  valid?: boolean; missing?: string[]; invalid_models?: string[];
  /** Contributed by an installed DLC pack (its id) — read-only here. */
  dlc?: string;
};

export type IngredientDef = {
  item?: string; model?: string; group?: string | null; label?: string;
  box_base?: boolean;
  halves?: { top_model?: string; bottom_model?: string };
  melts?: { applied_model?: string; melted_model?: string; melt_ms?: number };
  /** What USING one does, for an ingredient that is a thing in its own right
   *  rather than a component — a toy dropped in a bag is played with, not eaten.
   *  Resolved by ConsumeSpecFor when no food claims the item. */
  consume?: FoodConsume;
  valid?: boolean; missing?: string[]; invalid_models?: string[];
  /** Contributed by an installed DLC pack (its id) — read-only here. */
  dlc?: string;
};

// The cook methods valid for a station (fryer is always a basket fry).
// LAZY getter (memoized): `_L()` resolves at render, not at module import — a
// module-scope `_L()` runs before loadLocale() and would freeze to the raw key.
let _methods: Record<string, { value: string; label: string }[]> | null = null;
const METHODS = () => (_methods ??= {
  fryer: [{ value: "fry", label: _L("recipes.method_fry") }],
  stovetop: [
    { value: "grill", label: _L("recipes.method_grill") },
    { value: "oven", label: _L("recipes.method_oven") },
  ],
});

// Derived sub-badge for a food row: where (and in what order) it gets made.
// (`kind === "bag"` is the historical stored key for "made in the takeout box" —
// see the preset list in views/admin/Menu.tsx.)
export function foodSubBadge(food: Food): string {
  if (food.kind === "bag") return _L("menu.sub_bag");
  const steps = food.steps ?? [];
  if (steps.some((s) => s.type === "pour")) {
    return food.tap ? _L("menu.sub_fountain_tap", food.tap) : _L("menu.sub_fountain");
  }
  const cook = steps.find((s) => s.type === "cook") as Extract<Step, { type: "cook" }> | undefined;
  const cookLabel = cook
    ? cook.station === "fryer"
      ? _L("menu.sub_fryer")
      : cook.method === "oven"
        ? _L("menu.sub_oven")
        : _L("menu.sub_grill")
    : null;
  const hasAsm = steps.some((s) => s.type === "assemble");
  if (cookLabel && hasAsm) {
    const ci = steps.findIndex((s) => s.type === "cook");
    const ai = steps.findIndex((s) => s.type === "assemble");
    return ci < ai ? `${cookLabel} + ${_L("menu.sub_prep")}` : `${_L("menu.sub_prep")} + ${cookLabel}`;
  }
  if (cookLabel) return cookLabel;
  return _L("menu.sub_prep");
}

// A food's OWN picture for the row list, if it has one (foods author their own art
// rather than borrowing an item's — see foodImageItem for the fallback).
export function foodImageUrl(food: Food): string | undefined {
  return food.image?.url || undefined;
}

// The item whose catalogue image best represents a food in the row list, for a food
// with no picture of its own. A bag-kind food has no such item — it authors its
// own `image`, so there's nothing to borrow.
export function foodImageItem(food: Food): string {
  if (food.kind === "bag") return "";
  const steps = food.steps ?? [];
  for (let i = steps.length - 1; i >= 0; i--) {
    const s = steps[i];
    if (s.type === "pour") return s.input || "";
    if (s.output) return s.output;
    if (s.type === "cook" && s.input) return s.input;
  }
  return "";
}

// ─── small shared editor pieces ────────────────────────────────────────────────

// Drink pour-stream colors are stored as an [r, g, b] triplet (the soda-machine
// stream reads it, AND it's the order-UI flavor swatch). Convert to/from the hex
// the native colour picker speaks.
const rgbToHex = (c: any): string => {
  if (Array.isArray(c) && c.length >= 3) {
    const h = (n: number) => Math.max(0, Math.min(255, Math.floor(Number(n) || 0))).toString(16).padStart(2, "0");
    return "#" + h(c[0]) + h(c[1]) + h(c[2]);
  }
  return "#8899aa";
};
const hexToRgb = (hex: string): [number, number, number] => {
  const m = /^#?([0-9a-fA-F]{6})$/.exec((hex || "").trim());
  if (!m) return [136, 153, 170];
  const n = parseInt(m[1], 16);
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
};

// A prop-model text field with the "not found in-game" amber warning fed by the
// server-side annotateModels pass.
function ModelField({
  label, hint, value, onChange, badModels, className, placeholder,
}: {
  label: string; hint?: string; value: string; onChange: (v: string) => void;
  badModels: Set<string>; className?: string; placeholder?: string;
}) {
  const invalid = !!value && badModels.has(value);
  return (
    <div className={className}>
      <TextField label={label} hint={hint} value={value} placeholder={placeholder} onChange={onChange} />
      {invalid && (
        <div className="mt-1 flex items-center gap-1 text-[11px] text-amber-500">
          <TriangleAlert className="h-3 w-3" /> {_L("recipes.not_found")}
        </div>
      )}
    </div>
  );
}

// An item field with the catalogue thumbnail beside the picker. When `onSetItemImage`
// is supplied the thumbnail becomes a button that opens the custom-image editor for
// the CURRENT item value (so a server can give proper art to tray-only products — a
// burger, a burnt patty — that have no inventory image). The chosen url overrides the
// item's image everywhere it's shown.
function ItemField({
  label, hint, items, value, onChange, allowFree, placeholder, className, itemImages, onSetItemImage,
}: {
  label: string; hint?: string; items: Item[]; value: string; onChange: (v: string) => void;
  allowFree?: boolean; placeholder?: string; className?: string;
  itemImages?: ItemImages; onSetItemImage?: SetItemImage;
}) {
  const [editImg, setEditImg] = useState(false);
  const editable = !!onSetItemImage && !!value;
  return (
    <Field label={label} hint={hint} className={className}>
      <div className="flex items-center gap-2">
        {editable ? (
          <button type="button" onClick={() => setEditImg(true)} title={_L("menu.set_item_image")}
            className="group relative h-9 w-9 shrink-0 overflow-hidden rounded outline-none focus-visible:ring-2 focus-visible:ring-primary/60">
            <EntryThumb items={items} name={value || ""} itemImages={itemImages} className="h-9 w-9" />
            <span className="absolute inset-0 flex items-center justify-center bg-black/45 text-white opacity-0 transition-opacity group-hover:opacity-100">
              {itemImages?.[value]?.url ? <Pencil className="h-3.5 w-3.5" /> : <ImagePlus className="h-3.5 w-3.5" />}
            </span>
          </button>
        ) : (
          <EntryThumb items={items} name={value || ""} itemImages={itemImages} className="h-9 w-9 shrink-0" />
        )}
        <div className="min-w-0 flex-1">
          <ItemPicker items={items} value={value || ""} onChange={onChange} allowFree={allowFree} placeholder={placeholder} />
        </div>
      </div>
      {editImg && onSetItemImage && (
        <ItemImageModal
          item={value}
          items={items}
          entry={itemImages?.[value] || null}
          onChange={(e) => onSetItemImage(value, e)}
          onClose={() => setEditImg(false)}
        />
      )}
    </Field>
  );
}

// The custom-image editor dialog for one item: a square-cropped photo (reusing the
// same PhotoField URL+crop picker as the brand textures). Clearing it (Remove)
// falls the item back to its catalogue image / icon.
function ItemImageModal({ item, items, entry, onChange, onClose }: {
  item: string; items: Item[]; entry: PhotoEntry | null; onChange: (e: PhotoEntry | null) => void; onClose: () => void;
}) {
  return (
    <Modal open onClose={onClose} title={labelOf(items, item)} subtitle={_L("menu.item_image")} icon={<ImagePlus className="h-4 w-4" />}
      footer={<Button size="sm" onClick={onClose}>{_L("recipes.done")}</Button>}>
      <p className="mb-3 text-xs text-muted-foreground">{_L("menu.item_image_desc")}</p>
      <div className="w-48">
        <PhotoField aspect={ITEM_PHOTO()} entry={entry} onChange={onChange} empty={_L("menu.item_image_hint")} />
      </div>
    </Modal>
  );
}

// Customer POS modifiers — add cheese, no lettuce… Ticket instructions + pricing;
// the kitchen match is item-only. Shared by every food kind.
export function ModifierListEditor({ mods, onChange, items }: { mods: Modifier[]; onChange: (mods: Modifier[]) => void; items: Item[] }) {
  const updateMod = (mi: number, patch: Partial<Modifier>) => {
    const next = mods.map((m, idx) => {
      if (idx !== mi) return m;
      const merged = { ...m, ...patch };
      merged.id = modSlug(merged.item || merged.label) || `mod${mi}`; // keep id in sync with item/label
      return merged;
    });
    onChange(next);
  };
  return (
    <Field label={_L("settings.modifiers")} hint={_L("settings.modifiers_hint")} className="mt-3">
      <div className="space-y-2">
        {mods.map((m, mi) => (
          <div key={mi} className="flex items-end gap-2 rounded-md border border-border/60 p-2">
            <TextField label={_L("settings.mod_label")} className="w-24" value={m.label || ""} onChange={(v) => updateMod(mi, { label: v })} />
            <div className="flex-1"><Field label={_L("settings.mod_item")}><ItemPicker items={items} value={m.item || ""} onChange={(v) => updateMod(mi, { item: v })} /></Field></div>
            <NumberField label={_L("settings.mod_price")} className="w-20" value={Number(m.price || 0)} min={0} onChange={(v) => updateMod(mi, { price: v })} />
            <div className="pb-1.5"><Toggle checked={!!m.default} onChange={(v) => updateMod(mi, { default: v })} label={_L("settings.mod_default")} /></div>
            <Button size="icon" variant="ghost" onClick={() => onChange(mods.filter((_, idx) => idx !== mi))}><Trash2 className="h-4 w-4" /></Button>
          </div>
        ))}
        <Button size="sm" variant="outline" onClick={() => onChange([...mods, { id: "", label: "", item: "", price: 0, default: false }])}>
          <Plus className="h-4 w-4" /> {_L("settings.add_modifier")}
        </Button>
      </div>
    </Field>
  );
}

// A plain add/remove list of component items (assemble steps, bag contents).
// DELIBERATELY NOT `allowFree`: a component has to be
// something that already exists — an installed inventory item (authored in Supplies)
// or a kitchen product this menu creates — and `items` here is that combined list
// (Menu's `compItems`). Typing a name the search doesn't find used to commit it as a
// brand-new "kitchen item", which silently authored a component nothing in the
// kitchen can ever produce: the recipe then simply never matched, with no way to see
// why from the build itself.
function ComponentList({ comps, onChange, items }: { comps: string[]; onChange: (comps: string[]) => void; items: Item[] }) {
  return (
    <div className="space-y-2">
      {comps.map((c, ci) => (
        <div key={ci} className="flex gap-2">
          <ItemPicker className="flex-1" items={items} value={c} onChange={(v) => onChange(comps.map((x, idx) => (idx === ci ? v : x)))} />
          <Button size="icon" variant="ghost" onClick={() => onChange(comps.filter((_, idx) => idx !== ci))}><Trash2 className="h-4 w-4" /></Button>
        </div>
      ))}
      <Button size="sm" variant="outline" onClick={() => onChange([...comps, ""])}><Plus className="h-4 w-4" /> {_L("settings.add_component")}</Button>
    </div>
  );
}

// ─── FoodForm: one recipe, interactive (ordered steps) or bag ──────────────────

// The card frame every step renders in: type title, position, remove button.
function StepShell({ title, onRemove, children }: { title: string; onRemove: () => void; children: React.ReactNode }) {
  return (
    <div className="rounded-lg border border-border/70 p-2.5">
      <div className="mb-2 flex items-center justify-between gap-2">
        <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">{title}</span>
        <Button size="icon" variant="ghost" onClick={onRemove}><Trash2 className="h-4 w-4" /></Button>
      </div>
      {children}
    </div>
  );
}

function AssembleStepCard({
  step, isMiddle, suggestedId, items, compItems, badModels, onChange, onRemove, itemImages, onSetItemImage,
}: {
  step: Extract<Step, { type: "assemble" }>; isMiddle: boolean; suggestedId: string;
  items: Item[];
  /** items ∪ kitchen products — what this step's COMPONENTS may be picked from. */
  compItems?: Item[];
  badModels: Set<string>; onChange: (patch: any) => void; onRemove: () => void;
  itemImages?: ItemImages; onSetItemImage?: SetItemImage;
}) {
  return (
    <StepShell title={_L("steps.assemble_title")} onRemove={onRemove}>
      <div className="grid grid-cols-2 gap-3">
        <div>
          <ItemField label={_L("steps.assemble_output")} items={items} value={step.output || ""} allowFree
            itemImages={itemImages} onSetItemImage={onSetItemImage}
            placeholder={isMiddle ? `raw_${suggestedId}` : undefined} onChange={(v) => onChange({ output: v })} />
          {isMiddle && (
            <div className="mt-1 flex items-center gap-1 text-[11px] text-muted-foreground">
              <Link2 className="h-3 w-3" /> {_L("steps.intermediate_hint")}
            </div>
          )}
        </div>
        <ModelField label={_L("settings.prop_model")} value={step.model || ""} onChange={(v) => onChange({ model: v })} badModels={badModels} />
      </div>
      <Field label={_L("settings.components")} className="mt-3">
        <ComponentList comps={step.components ?? []} onChange={(c) => onChange({ components: c })} items={compItems ?? items} />
      </Field>
    </StepShell>
  );
}

function CookStepCard({
  step, fedByPrevious, items, badModels, onChange, onRemove, itemImages, onSetItemImage,
}: {
  step: Extract<Step, { type: "cook" }>; fedByPrevious: boolean;
  items: Item[]; badModels: Set<string>; onChange: (patch: any) => void; onRemove: () => void;
  itemImages?: ItemImages; onSetItemImage?: SetItemImage;
}) {
  const [advanced, setAdvanced] = useState(false);
  const stationLabel = step.station === "fryer" ? _L("recipes.station_fryer") : _L("recipes.station_stovetop");
  return (
    <StepShell title={_L("steps.cook_title", stationLabel)} onRemove={onRemove}>
      {/* 6-col grid so short rows can stretch: no field ever leaves dead space
          at the end of its row (outputs split 3/3, times fill when fryer). */}
      <div className="grid grid-cols-6 gap-3">
        {fedByPrevious && !step.input ? (
          <Field label={_L("recipes.input_item")} className="col-span-2">
            <div className="flex h-9 items-center gap-1.5 rounded-md border border-dashed border-border bg-muted/40 px-3 text-xs text-muted-foreground">
              <Link2 className="h-3.5 w-3.5 shrink-0" /> {_L("steps.fed_by_previous")}
            </div>
          </Field>
        ) : (
          <ItemField label={_L("recipes.input_item")} className="col-span-2" items={items} value={step.input || ""} allowFree
            onChange={(v) => onChange({ input: v })} />
        )}
        <Select label={_L("recipes.station")} className="col-span-2" value={step.station}
          onChange={(v) => onChange({ station: v, method: (METHODS()[v] || [])[0]?.value || "grill" })}
          options={[{ value: "fryer", label: _L("recipes.station_fryer") }, { value: "stovetop", label: _L("recipes.station_stovetop") }]} />
        <Select label={_L("recipes.method")} className="col-span-2" value={step.method || (METHODS()[step.station] || [])[0]?.value || "grill"}
          onChange={(v) => onChange({ method: v })} options={METHODS()[step.station] || METHODS().stovetop} />
        <ModelField label={_L("recipes.raw_model")} className="col-span-2" value={step.raw_model || ""} onChange={(v) => onChange({ raw_model: v })} badModels={badModels} />
        <ModelField label={_L("recipes.cooked_model")} className="col-span-2" value={step.cooked_model || ""} onChange={(v) => onChange({ cooked_model: v })} badModels={badModels} />
        <ModelField label={_L("recipes.burnt_model")} className="col-span-2" value={step.burnt_model || ""} onChange={(v) => onChange({ burnt_model: v })} badModels={badModels} />
        <ItemField label={_L("recipes.cooked_output")} className="col-span-3" items={items} value={step.output || ""} allowFree
          itemImages={itemImages} onSetItemImage={onSetItemImage}
          onChange={(v) => onChange({ output: v })} />
        <ItemField label={_L("recipes.burnt_output")} className="col-span-3" items={items} value={step.output_burnt || ""} allowFree
          itemImages={itemImages} onSetItemImage={onSetItemImage}
          placeholder={step.output ? `burnt_${step.output}` : undefined} onChange={(v) => onChange({ output_burnt: v })} />
        <NumberField label={_L("recipes.cook_time")} className={step.station === "stovetop" ? "col-span-2" : "col-span-3"}
          value={step.cook_ms ?? 15000} min={0} step={1000} onChange={(v) => onChange({ cook_ms: v })} />
        <NumberField label={_L("recipes.burn_time")} className={step.station === "stovetop" ? "col-span-2" : "col-span-3"}
          value={step.burn_ms ?? 15000} min={0} step={1000} onChange={(v) => onChange({ burn_ms: v })} />
        {step.station === "stovetop" && (
          <div className="col-span-2 flex items-end pb-1.5">
            <Toggle checked={!!step.dual_sided} onChange={(v) => onChange({ dual_sided: v })} label={_L("recipes.dual_sided_short")} />
          </div>
        )}
      </div>

      {/* rarely-touched extras live behind one fold so the card stays approachable */}
      <button type="button" onClick={() => setAdvanced((v) => !v)}
        className="mt-3 flex items-center gap-1 text-xs font-semibold text-muted-foreground transition-colors hover:text-foreground">
        {advanced ? <ChevronDown className="h-3.5 w-3.5" /> : <ChevronRight className="h-3.5 w-3.5" />} {_L("steps.advanced")}
      </button>
      {advanced && (
        <div className="mt-2 grid grid-cols-6 gap-3">
          <NumberField label={_L("recipes.output_count")} className="col-span-2" value={step.output_count ?? 1} min={1} step={1} onChange={(v) => onChange({ output_count: v })} />
          <ModelField label={_L("recipes.container_model")} className="col-span-2" value={step.container_model || ""} onChange={(v) => onChange({ container_model: v })} badModels={badModels} />
          <TextField label={_L("recipes.expiry")} hint={_L("recipes.expiry_hint")} className="col-span-2"
            value={step.expire_seconds == null ? "" : String(step.expire_seconds)}
            onChange={(v) => onChange({ expire_seconds: v === "" ? null : Number(v) })} />
          <ModelField label={_L("steps.serving_model")} hint={_L("steps.serving_model_hint")} className="col-span-3"
            value={step.serving_model || ""} onChange={(v) => onChange({ serving_model: v })} badModels={badModels} />
          <ModelField label={_L("steps.serving_burnt_model")} hint={_L("steps.serving_burnt_model_hint")} className="col-span-3"
            value={step.serving_burnt_model || ""} onChange={(v) => onChange({ serving_burnt_model: v })} badModels={badModels} />
        </div>
      )}
    </StepShell>
  );
}

function PourStepCard({
  step, items, badModels, onChange, onRemove,
}: {
  step: Extract<Step, { type: "pour" }>;
  items: Item[]; badModels: Set<string>; onChange: (patch: any) => void; onRemove: () => void;
}) {
  // The poured flavor's internal key is derived from the food's label upstream
  // (in FoodForm) — there is no manual flavor-key field here.
  const hex = rgbToHex(step.color);
  return (
    <StepShell title={_L("steps.pour_title")} onRemove={onRemove}>
      <div className="grid grid-cols-2 gap-3">
        <ItemField label={_L("steps.pour_cup")} items={items} value={step.input || ""} onChange={(v) => onChange({ input: v })} />
        <ModelField label={_L("settings.prop_model")} value={step.model || ""} onChange={(v) => onChange({ model: v })} badModels={badModels} />
        <NumberField label={_L("settings.fill_time")} value={Number(step.fill_ms ?? 3000)} min={0} step={500} onChange={(v) => onChange({ fill_ms: v })} />
        <Field label={_L("settings.drink_color")} hint={_L("settings.drink_color_hint")}>
          <div className="flex items-center gap-2">
            <input type="color" value={hex} onChange={(e) => onChange({ color: hexToRgb(e.target.value) })}
              className="h-9 w-12 shrink-0 cursor-pointer rounded border border-input bg-transparent p-0.5" />
            <span className="font-mono text-xs uppercase text-muted-foreground">{hex}</span>
          </div>
        </Field>
      </div>
    </StepShell>
  );
}

// A food's OWN picture + what eating one serving does. Every food has both, whether
// it's cooked, assembled, poured or made in a takeout box — a food is never
// identified by borrowing an inventory item.
function FoodIdentity({ food, onChange, anims, boxQuad }: {
  food: Food; onChange: (patch: any) => void; anims: ConsumeAnim[];
  boxQuad?: { w?: number; h?: number };
}) {
  const c = food.consume ?? {};
  const setConsume = (patch: Partial<FoodConsume>) => onChange({ consume: { ...c, ...patch } });
  return (
    <div className="mt-3 flex flex-wrap items-start gap-4 rounded-md border border-border/60 p-3">
      <div className="w-32">
        <div className="mb-1.5 text-xs font-medium text-muted-foreground">{_L("menu.food_image")}</div>
        <PhotoField aspect={ITEM_PHOTO()} entry={food.image ?? null}
          onChange={(e) => onChange({ image: e })} empty={_L("menu.food_image_hint")} />
      </div>
      {/* a bag-kind food is served in the takeout box, and the picture lying in the
          box often wants to be a different shot from the card art */}
      {food.kind === "bag" && (
        <div className="w-32">
          <div className="mb-1.5 text-xs font-medium text-muted-foreground">{_L("menu.box_image")}</div>
          {/* cropped at the box quad's own shape, so the crop IS what's painted */}
          <PhotoField aspect={BOX_PHOTO(boxQuad)} entry={food.box_image ?? null}
            onChange={(e) => onChange({ box_image: e })} empty={_L("menu.box_image_hint")} />
        </div>
      )}
      <div className="min-w-[16rem] flex-1">
        <div className="mb-1.5 text-xs font-medium text-muted-foreground">{_L("menu.when_eaten")}</div>
        <div className="grid grid-cols-4 gap-3">
          <Select label={_L("menu.consume_anim")} value={c.anim || ""} onChange={(v) => setConsume({ anim: v })}
            options={[{ value: "", label: _L("menu.consume_anim_default") },
                      ...anims.map((a) => ({ value: a.id, label: a.label || a.id }))]} />
          {/* 0-100 percentages of the framework's needs bars; the server clamps them */}
          <NumberField label={_L("menu.consume_hunger")} value={Number(c.hunger ?? 0)} min={0}
            onChange={(v) => setConsume({ hunger: Math.max(0, Math.min(100, v)) })} />
          <NumberField label={_L("menu.consume_thirst")} value={Number(c.thirst ?? 0)} min={0}
            onChange={(v) => setConsume({ thirst: Math.max(0, Math.min(100, v)) })} />
          {/* How many mouthfuls ONE serving takes — nuggets go in one, a burger in
              three. The serving is SPLIT across them (each bite restores its share,
              the last settles the remainder), so this changes the pace of eating,
              never how much a food feeds. 0 = follow Settings → Eating; the field
              stores null for that, because a stored 0 would clamp to a 1-bite food. */}
          <NumberField label={_L("menu.consume_bites")} value={Number(c.bites ?? 0)} min={0}
            onChange={(v) => setConsume({ bites: v > 0 ? Math.min(20, Math.floor(v)) : null })} />
        </div>
        <div className="mt-1.5 text-[11px] text-muted-foreground">{_L("menu.when_eaten_hint")}</div>
      </div>
    </div>
  );
}

export function FoodForm({ food, onChange, items, compItems, groups, itemImages, onSetItemImage, anims, boxQuad }: {
  food: Food; onChange: (patch: any) => void; items: Item[];
  /** items ∪ kitchen products — everything a COMPONENT is allowed to be. Falls back
   *  to the plain item catalogue when a caller doesn't supply it. */
  compItems?: Item[];
  groups: string[];
  itemImages?: ItemImages; onSetItemImage?: SetItemImage; anims?: ConsumeAnim[];
  boxQuad?: { w?: number; h?: number };
}) {
  const comps = compItems ?? items;
  const steps: Step[] = food.steps ?? [];
  const badModels = new Set(food.invalid_models || []);
  const patchStep = (i: number, patch: any) => onChange({ steps: steps.map((s, idx) => (idx === i ? { ...s, ...patch } : s)) });
  const removeStep = (i: number) => onChange({ steps: steps.filter((_, idx) => idx !== i) });
  const hasCook = steps.some((s) => s.type === "cook");
  const hasPour = steps.some((s) => s.type === "pour");
  const suggestedId = modSlug(food.label || food.id || "");

  return (
    <>
      <div className="grid grid-cols-3 items-start gap-3">
        {/* the label is the single source of truth: a drink's poured-flavor key is
            auto-derived from it here, so there's no separate internal-key field */}
        <TextField label={_L("settings.label")} value={food.label || ""} onChange={(v) => {
          const patch: any = { label: v };
          if (hasPour) patch.steps = steps.map((s) => (s.type === "pour" ? { ...s, flavor: modSlug(v) } : s));
          onChange(patch);
        }} />
        <GroupField label={_L("settings.group_field")} hint={_L("settings.group_field_hint")}
          value={food.group || ""} groups={groups} onChange={(v) => onChange({ group: v })} />
        {/* the kind is decided at creation (preset) and fixed after — shown, not edited */}
        <Field label={_L("menu.kind_field")}>
          <div className="flex h-9 items-center">
            <Badge variant="outline">{food.kind === "bag" ? _L("menu.sub_bag") : foodSubBadge(food)}</Badge>
          </div>
        </Field>
      </div>

      <FoodIdentity food={food} onChange={onChange} anims={anims ?? []} boxQuad={boxQuad} />

      {food.kind === "bag" ? (
        <>
          <Field label={_L("settings.components")} className="mt-3">
            <ComponentList comps={food.components ?? []} onChange={(c) => onChange({ components: c })} items={comps} />
          </Field>
        </>
      ) : (
        <div className="mt-3 space-y-2">
          {steps.map((s, i) =>
            s.type === "assemble" ? (
              <AssembleStepCard key={i} step={s} isMiddle={i < steps.length - 1} suggestedId={suggestedId}
                items={items} compItems={comps} badModels={badModels} onChange={(p) => patchStep(i, p)} onRemove={() => removeStep(i)}
                itemImages={itemImages} onSetItemImage={onSetItemImage} />
            ) : s.type === "cook" ? (
              <CookStepCard key={i} step={s} fedByPrevious={i > 0}
                items={items} badModels={badModels} onChange={(p) => patchStep(i, p)} onRemove={() => removeStep(i)}
                itemImages={itemImages} onSetItemImage={onSetItemImage} />
            ) : (
              <PourStepCard key={i} step={s}
                items={items} badModels={badModels} onChange={(p) => patchStep(i, p)} onRemove={() => removeStep(i)} />
            )
          )}
          {/* valid additions only: at most one cook step; a pour stands alone */}
          {!hasPour && (
            <div className="flex gap-2">
              <Button size="sm" variant="outline" onClick={() => onChange({ steps: [...steps, { type: "assemble", components: [] } as Step] })}>
                <Plus className="h-4 w-4" /> {_L("steps.add_assemble")}
              </Button>
              {!hasCook && (
                <Button size="sm" variant="outline" onClick={() => onChange({ steps: [...steps, { type: "cook", station: "stovetop", method: "grill", cook_ms: 15000, burn_ms: 15000 } as Step] })}>
                  <Plus className="h-4 w-4" /> {_L("steps.add_cook")}
                </Button>
              )}
            </div>
          )}
        </div>
      )}

      <ModifierListEditor mods={food.modifiers ?? []} onChange={(m) => onChange({ modifiers: m })} items={items} />
    </>
  );
}

// ─── ToolForm: applies something to food (sauce layer / decorate / fill a tray) ─

// One flavor row inside a decorate target: id/label/model + a hex colour swatch.
// Finish flavor colours are stored as hex strings (unlike pour colours' triplets).
function FlavorRow({ fl, onChange, onRemove }: { fl: any; onChange: (patch: any) => void; onRemove: () => void }) {
  const hex = /^#?[0-9a-fA-F]{6}$/.test(fl.color || "") ? (fl.color[0] === "#" ? fl.color : "#" + fl.color) : "#cccccc";
  return (
    <div className="flex items-end gap-2 rounded-md border border-border/60 p-2">
      {/* internal id is auto-derived from the label (no manual key entry) */}
      <TextField label={_L("settings.flavor_label")} className="w-40" value={fl.label || ""}
        onChange={(v) => onChange({ label: v, id: modSlug(v) })} />
      <div className="flex-1"><TextField label={_L("settings.flavor_model")} value={fl.model || ""} onChange={(v) => onChange({ model: v })} /></div>
      <label className="flex shrink-0 flex-col gap-1">
        <span className="text-xs text-muted-foreground">{_L("settings.flavor_color")}</span>
        <input type="color" value={hex} onChange={(e) => onChange({ color: e.target.value })}
          className="h-9 w-10 cursor-pointer rounded border border-input bg-transparent p-0.5" />
      </label>
      <Button size="icon" variant="ghost" onClick={onRemove}><Trash2 className="h-4 w-4" /></Button>
    </div>
  );
}

// One target card: which cooked item this tool decorates, what it produces, the
// apply mode, an optional pre-requisite finish, and the flavor list.
// `finishOptions` are the other finishes this one can require first — picked from a
// dropdown, never typed as a raw key.
function TargetCard({ target, items, finishOptions, onChange, onRemove }:
  { target: any; items: Item[]; finishOptions: { value: string; label: string }[]; onChange: (patch: any) => void; onRemove: () => void }) {
  const flavors: any[] = target.flavors ?? [];
  const updateFlavor = (fi: number, patch: any) => onChange({ flavors: flavors.map((f, i) => (i === fi ? { ...f, ...patch } : f)) });
  // A configured requirement whose finish no longer exists still needs to show as a
  // choice so it isn't silently dropped when the admin opens the card.
  const requireOpts = [{ value: "", label: _L("settings.finish_requires_none") }, ...finishOptions];
  if (target.requires_finish && !finishOptions.some((o) => o.value === target.requires_finish)) {
    requireOpts.push({ value: target.requires_finish, label: labelOf(items, target.requires_finish) });
  }
  return (
    <div className="rounded-lg border border-border/70 p-2.5">
      <div className="mb-2 flex items-start justify-between gap-2">
        <div className="grid flex-1 grid-cols-2 gap-2">
          <Field label={_L("settings.finish_target_item")}><ItemPicker items={items} value={target.item || ""} onChange={(v) => onChange({ item: v })} /></Field>
          <Field label={_L("settings.finish_target_output")}><ItemPicker items={items} value={target.output || ""} onChange={(v) => onChange({ output: v })} /></Field>
          <Select label={_L("settings.finish_mode")} value={target.mode || "overlay"} onChange={(v) => onChange({ mode: v })}
            options={[{ value: "overlay", label: _L("settings.finish_mode_overlay") }, { value: "replace", label: _L("settings.finish_mode_replace") }]} />
          <Select label={_L("settings.finish_requires")} hint={_L("settings.finish_requires_hint")}
            value={target.requires_finish || ""} onChange={(v) => onChange({ requires_finish: v || undefined })}
            options={requireOpts} />
        </div>
        <Button size="icon" variant="ghost" onClick={onRemove}><Trash2 className="h-4 w-4" /></Button>
      </div>
      <Field label={_L("settings.finish_flavors")}>
        <div className="space-y-2">
          {flavors.map((fl, fi) => (
            <FlavorRow key={fi} fl={fl} onChange={(p) => updateFlavor(fi, p)}
              onRemove={() => onChange({ flavors: flavors.filter((_, i) => i !== fi) })} />
          ))}
          <Button size="sm" variant="outline" onClick={() => onChange({ flavors: [...flavors, { id: "", label: "", model: "", color: "#cccccc" }] })}>
            <Plus className="h-4 w-4" /> {_L("settings.finish_add_flavor")}
          </Button>
        </div>
      </Field>
    </div>
  );
}

// One bake-tray row inside a fill tool: the tray placed on the prep table and
// what rubbing the tool's mix into it produces.
function TrayRow({ tray, items, badModels, onChange, onRemove }:
  { tray: any; items: Item[]; badModels: Set<string>; onChange: (patch: any) => void; onRemove: () => void }) {
  return (
    <div className="rounded-lg border border-border/70 p-2.5">
      <div className="flex items-start justify-between gap-2">
        <div className="grid flex-1 grid-cols-2 gap-2">
          {/* internal kind is auto-derived from the label (no manual key entry) */}
          <TextField label={_L("settings.label")} value={tray.label || ""}
            onChange={(v) => onChange({ label: v, kind: modSlug(v) })} />
          <ModelField label={_L("tool.tray_model")} value={tray.tray_model || ""} onChange={(v) => onChange({ tray_model: v })} badModels={badModels} />
          <ModelField label={_L("tool.tray_raw_model")} hint={_L("tool.tray_raw_model_hint")}
            value={tray.raw_model || ""} onChange={(v) => onChange({ raw_model: v })} badModels={badModels} />
          <Field label={_L("tool.tray_output")} hint={_L("tool.tray_output_hint")}>
            <ItemPicker items={items} value={tray.output || ""} allowFree onChange={(v) => onChange({ output: v })} />
          </Field>
          <div className="grid grid-cols-2 gap-2">
            <NumberField label={_L("tool.tray_slots")} hint={_L("tool.tray_slots_hint")}
              value={Number(tray.slots ?? 0)} min={0} step={1} onChange={(v) => onChange({ slots: v > 0 ? v : undefined })} />
            <TextField label={_L("settings.group_field")} value={tray.group || ""} onChange={(v) => onChange({ group: v || undefined })} />
          </div>
        </div>
        <Button size="icon" variant="ghost" onClick={onRemove}><Trash2 className="h-4 w-4" /></Button>
      </div>
    </div>
  );
}

export function ToolForm({ tool, cost, allTools, onChange, onChangeCost, items, groups, itemImages, onSetItemImage }:
  { tool: Tool; cost: number; allTools: Tool[]; onChange: (patch: any) => void; onChangeCost: (v: number) => void;
    items: Item[]; groups: string[]; itemImages?: ItemImages; onSetItemImage?: SetItemImage }) {
  const badModels = new Set(tool.invalid_models || []);
  const targets: any[] = tool.targets ?? [];
  // Other decorate finishes this one can require first (a finish can't require
  // itself) — offered as a dropdown so the admin never types a raw finish key.
  const finishOptions = (allTools || [])
    .filter((t) => t.mode === "decorate" && t.item && t.item !== tool.item)
    .map((t) => ({ value: t.item as string, label: labelOf(items, t.item as string) }));
  const trays: any[] = tool.trays ?? [];
  const updateTarget = (ti: number, patch: any) => onChange({ targets: targets.map((t, i) => (i === ti ? { ...t, ...patch } : t)) });
  const updateTray = (ti: number, patch: any) => onChange({ trays: trays.map((t, i) => (i === ti ? { ...t, ...patch } : t)) });
  return (
    <>
      <div className="grid grid-cols-2 gap-3">
        <ItemField label={_L("settings.finish_tool")} items={items} value={tool.item || ""} onChange={(v) => onChange({ item: v })}
          itemImages={itemImages} onSetItemImage={onSetItemImage} />
        <NumberField label={_L("settings.finish_cost")} hint={_L("settings.finish_cost_hint")}
          value={cost} min={0} onChange={onChangeCost} />
        <ModelField label={_L("settings.finish_tool_model")} value={tool.tool_model || ""} onChange={(v) => onChange({ tool_model: v })} badModels={badModels} />
        <GroupField label={_L("settings.group_field")} hint={_L("settings.group_field_hint")}
          value={tool.group || ""} groups={groups} onChange={(v) => onChange({ group: v })} />
        <Select label={_L("tool.mode")} value={tool.mode || "layer"} onChange={(v) => onChange({ mode: v })}
          options={[
            { value: "layer", label: _L("tool.mode_layer") },
            { value: "decorate", label: _L("tool.mode_decorate") },
            { value: "fill", label: _L("tool.mode_fill") },
          ]} />
        {tool.mode !== "layer" && (
          <NumberField label={_L("settings.finish_rub_dist")} hint={_L("settings.finish_rub_dist_hint")}
            value={Number(tool.rub_dist ?? 1.2)} min={0} step={0.1} onChange={(v) => onChange({ rub_dist: v })} />
        )}
        {tool.mode === "layer" && (
          <ModelField label={_L("tool.applied_model")} hint={_L("tool.applied_model_hint")}
            value={tool.applied_model || ""} onChange={(v) => onChange({ applied_model: v })} badModels={badModels} />
        )}
      </div>

      {tool.mode === "decorate" && (
        <Field label={_L("settings.finish_targets")} hint={_L("settings.finish_targets_hint")} className="mt-3">
          <div className="space-y-2">
            {targets.map((t, ti) => (
              <TargetCard key={ti} target={t} items={items} finishOptions={finishOptions} onChange={(p) => updateTarget(ti, p)}
                onRemove={() => onChange({ targets: targets.filter((_, i) => i !== ti) })} />
            ))}
            <Button size="sm" variant="outline" onClick={() => onChange({ targets: [...targets, { item: "", output: "", mode: "overlay", flavors: [] }] })}>
              <Plus className="h-4 w-4" /> {_L("settings.finish_add_target")}
            </Button>
          </div>
        </Field>
      )}

      {tool.mode === "fill" && (
        <Field label={_L("tool.trays")} hint={_L("tool.trays_hint")} className="mt-3">
          <div className="space-y-2">
            {trays.map((t, ti) => (
              <TrayRow key={ti} tray={t} items={items} badModels={badModels} onChange={(p) => updateTray(ti, p)}
                onRemove={() => onChange({ trays: trays.filter((_, i) => i !== ti) })} />
            ))}
            <Button size="sm" variant="outline" onClick={() => onChange({ trays: [...trays, { kind: "", label: "", tray_model: "", output: "", raw_model: "" }] })}>
              <Plus className="h-4 w-4" /> {_L("tool.add_tray")}
            </Button>
          </div>
        </Field>
      )}
    </>
  );
}

// ─── IngredientForm: a stackable component with behavior properties ─────────────

// A property toggle that reveals its detail fields: short name + one-line
// plain-language explanation, so the behaviors are self-describing.
function PropertyBlock({
  checked, onToggle, label, blurb, children, cols = 3,
}: {
  checked: boolean; onToggle: (v: boolean) => void; label: string; blurb: string; children?: React.ReactNode; cols?: 2 | 3;
}) {
  return (
    <div className={cn("rounded-lg border p-2.5", checked ? "border-primary/40 bg-primary/5" : "border-border/70")}>
      <Toggle checked={checked} onChange={onToggle} label={label} />
      <p className="ml-11 mt-0.5 text-[11px] text-muted-foreground">{blurb}</p>
      {checked && children && <div className={cn("mt-2.5 grid gap-3", cols === 2 ? "grid-cols-2" : "grid-cols-3")}>{children}</div>}
    </div>
  );
}

export function IngredientForm({ ing, cost, onChange, onChangeCost, items, groups, itemImages, onSetItemImage }:
  { ing: IngredientDef; cost: number; onChange: (patch: any) => void; onChangeCost: (v: number) => void;
    items: Item[]; groups: string[]; itemImages?: ItemImages; onSetItemImage?: SetItemImage }) {
  const badModels = new Set(ing.invalid_models || []);
  const halves = ing.halves;
  const melts = ing.melts;
  return (
    <>
      <div className="grid grid-cols-2 gap-3">
        <ItemField label={_L("ing.item")} items={items} value={ing.item || ""} onChange={(v) => onChange({ item: v })}
          itemImages={itemImages} onSetItemImage={onSetItemImage} />
        <NumberField label={_L("settings.finish_cost")} hint={_L("settings.finish_cost_hint")}
          value={cost} min={0} onChange={onChangeCost} />
        <ModelField label={_L("settings.prop_model")} value={ing.model || ""} onChange={(v) => onChange({ model: v })} badModels={badModels} />
        <GroupField label={_L("settings.group_field")} hint={_L("settings.group_field_hint")}
          value={ing.group || ""} groups={groups} onChange={(v) => onChange({ group: v })} />
      </div>

      <div className="mt-3 space-y-2">
        <PropertyBlock checked={!!halves} label={_L("ing.prop_halves")} blurb={_L("ing.prop_halves_blurb")} cols={2}
          onToggle={(v) => onChange({ halves: v ? { top_model: "", bottom_model: "" } : undefined })}>
          <ModelField label={_L("ing.halves_top")} value={halves?.top_model || ""}
            onChange={(v) => onChange({ halves: { ...halves, top_model: v } })} badModels={badModels} />
          <ModelField label={_L("ing.halves_bottom")} value={halves?.bottom_model || ""}
            onChange={(v) => onChange({ halves: { ...halves, bottom_model: v } })} badModels={badModels} />
        </PropertyBlock>

        <PropertyBlock checked={!!melts} label={_L("ing.prop_melts")} blurb={_L("ing.prop_melts_blurb")}
          onToggle={(v) => onChange({ melts: v ? { applied_model: "", melted_model: "", melt_ms: 6000 } : undefined })}>
          <ModelField label={_L("ing.melts_applied")} value={melts?.applied_model || ""}
            onChange={(v) => onChange({ melts: { ...melts, applied_model: v } })} badModels={badModels} />
          <ModelField label={_L("ing.melts_melted")} value={melts?.melted_model || ""}
            onChange={(v) => onChange({ melts: { ...melts, melted_model: v } })} badModels={badModels} />
          <NumberField label={_L("ing.melts_time")} value={Number(melts?.melt_ms ?? 6000)} min={0} step={500}
            onChange={(v) => onChange({ melts: { ...melts, melt_ms: v } })} />
        </PropertyBlock>

        <PropertyBlock checked={!!ing.box_base} label={_L("ing.prop_boxbase")} blurb={_L("ing.prop_boxbase_blurb")}
          onToggle={(v) => onChange({ box_base: v || undefined })} />
      </div>
    </>
  );
}
