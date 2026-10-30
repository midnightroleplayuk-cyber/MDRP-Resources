import { useMemo, useState } from "react";
import { fetchNui } from "@/lib/nui";
import { useAutoSave } from "@/lib/autosave";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { type Item } from "@/components/ItemPicker";
import {
  ItemImage, EntryThumb, labelOf, prettyName, foodSubBadge, foodImageItem, foodImageUrl,
  type ConsumeAnim,
  FoodForm, ToolForm, IngredientForm,
  type Food, type Step, type Tool, type IngredientDef, type ItemImages,
} from "@/components/editors";
import { Modal } from "@/components/ui/modal";
import { Truncate } from "@/components/ui/truncate";
import { cn } from "@/lib/utils";
import { _L } from "@/lib/locale";
import { Plus, Trash2, Pencil, TriangleAlert, EyeOff, Check, Loader2, Tags, ChevronDown, UtensilsCrossed, Wrench, Layers, Download, RotateCcw, Search, X, Package } from "lucide-react";

// The shipped default menu (DEFAULT_FOODS/TOOLS/INGREDIENTS, sent verbatim in the
// admin payload) — the source list for the Import Defaults dialog.
type DefaultMenu = { foods?: Food[]; tools?: Tool[]; ingredients?: IngredientDef[] };

// Which kinds a Menu instance shows/creates. "food" = the sellable dishes & drinks;
// "ingredients" = the components they're built from (raw ingredients) plus the tools
// that apply things to them (condiments, finishes).
type Scope = "food" | "ingredients";

type Props = {
  scope: Scope;
  foods: Food[]; tools: Tool[]; ingredients: IngredientDef[]; defaults?: DefaultMenu | null;
  settings: Record<string, any>; items: Item[]; groups: string[]; onSaved: () => void;
  /** Kitchen products (a cooked patty, raw_pizza, a frosted cake): authored by the
   *  menu, never installed items, and legitimate COMPONENTS of another recipe. The
   *  component pickers offer these alongside `items` — with everything a component
   *  may be on one list, those pickers no longer accept free text. */
  products?: Item[];
  /** Buy-in costs with every installed pack's defaults underneath the authored map —
   *  what a cost field shows when this server hasn't set one of its own. */
  ingredientCosts?: Record<string, number>;
  /** READ-ONLY, from core/shared.lua's Config.BoxQuad (never a setting): the takeout
   *  box's picture rectangle, whose aspect the "Inside the box" cropper locks to. */
  boxQuad?: { w?: number; h?: number };
};

// strip the server-side annotations (valid/missing/defaultPrice/tap/…) so we
// never persist them back into the settings blob when saving the whole array.
// Kept in local state for display; removed only on the way out to the server.
const clean = (e: any) => {
  const {
    valid, missing, defaultPrice, invalid_models,
    box_item_installed, serving_item_installed, tap, duplicate_input, no_input,
    ...rest
  } = e;
  return rest;
};

// The New Recipe presets: each seeds a steps skeleton (or the bag kind) so the
// editor opens already shaped like the dish being made. The one-line description
// is the point — the menu explains itself.
// LAZY getter (memoized): `_L()` resolves at render, not at module import — a
// module-scope `_L()` runs before loadLocale() and would freeze to the raw key.
type Preset = { key: string; label: string; desc: string; make: () => Partial<Food> };
let _presets: Preset[] | null = null;
const PRESETS = (): Preset[] => (_presets ??= [
  {
    key: "cook", label: _L("menu.preset_cook"), desc: _L("menu.preset_cook_desc"),
    make: () => ({ kind: "interactive", steps: [{ type: "cook", station: "fryer", method: "fry", cook_ms: 15000, burn_ms: 15000 }] }),
  },
  {
    key: "assemble", label: _L("menu.preset_assemble"), desc: _L("menu.preset_assemble_desc"),
    make: () => ({ kind: "interactive", steps: [{ type: "assemble", components: [] }] }),
  },
  {
    key: "cook_assemble", label: _L("menu.preset_cook_assemble"), desc: _L("menu.preset_cook_assemble_desc"),
    make: () => ({
      kind: "interactive",
      steps: [
        { type: "cook", station: "stovetop", method: "grill", cook_ms: 15000, burn_ms: 15000 },
        { type: "assemble", components: [] },
      ],
    }),
  },
  {
    key: "assemble_bake", label: _L("menu.preset_assemble_bake"), desc: _L("menu.preset_assemble_bake_desc"),
    make: () => ({
      kind: "interactive",
      steps: [
        { type: "assemble", components: [] },
        { type: "cook", station: "stovetop", method: "oven", cook_ms: 15000, burn_ms: 15000 },
      ],
    }),
  },
  {
    key: "pour", label: _L("menu.preset_pour"), desc: _L("menu.preset_pour_desc"),
    make: () => ({ kind: "interactive", steps: [{ type: "pour", fill_ms: 3000 }] }),
  },
  {
    // `kind: "bag"` is the STORED key and stays as-is (every saved food, the whole
    // server-side derivation layer and the POS variant grammar read it). What it
    // means is "made in the TAKEOUT BOX" — the Restaurant Bag was the vessel before
    // the box existed, and is now the takeaway carrier instead. Only the copy moved.
    key: "bag", label: _L("menu.preset_bag"), desc: _L("menu.preset_bag_desc"),
    make: () => ({ kind: "bag", components: [] }),
  },
]);

export default function Menu({ scope, foods, tools, ingredients, defaults, settings, boxQuad, items, products, groups, ingredientCosts, onSaved }: Props) {
  // What a COMPONENT may be: an installed inventory item, or a kitchen product this
  // menu authors (tray-only things like a cooked patty or raw_pizza, which the
  // inventory catalogue can never list). One list of everything valid is what lets
  // the component pickers refuse free text — a name off this list is a typo.
  const compItems = useMemo(() => {
    const known = new Set((items || []).map((i) => i.name));
    return [...(items || []), ...(products || []).filter((p) => !known.has(p.name))];
  }, [items, products]);
  const showFood = scope === "food";
  const showIng = scope === "ingredients";
  // Kinds this tab renders (food-only vs tool+ingredient).
  const scopeKinds = showFood ? ["food"] : ["tool", "ing"];
  // The whole menu lives in the settings blob as three arrays, each saved whole
  // via the batched settings autosave (the server sanitizes + rebuilds + syncs).
  // DLC-CONTRIBUTED entries arrive in these same arrays (the server merges installed
  // packs into the three menu getters, which is what makes a pack work everywhere
  // without special cases) carrying a `dlc` mark. They are split OUT of the editable
  // state here rather than filtered at render time: these lists are saved WHOLE by
  // the autosave below, and content that belongs to a pack must never be written
  // into this server's settings — it would outlive the pack that defines it. The
  // server refuses such a write too (the sanitizers drop marked entries); keeping
  // them out of the editable state is what stops the panel from making the attempt,
  // and from renumbering an admin's rows around entries they can't touch.
  const isDlc = (e: any) => !!e?.dlc;
  const dlcEntries = useMemo(() => ({
    foods: (Array.isArray(foods) ? foods : []).filter(isDlc),
    tools: (Array.isArray(tools) ? tools : []).filter(isDlc),
    ingredients: (Array.isArray(ingredients) ? ingredients : []).filter(isDlc),
  }), [foods, tools, ingredients]);
  const [foodList, setFoodList] = useState<Food[]>(() => (Array.isArray(foods) ? foods : []).filter((f) => !isDlc(f)));
  const [toolList, setToolList] = useState<Tool[]>(() => (Array.isArray(tools) ? tools : []).filter((t) => !isDlc(t)));
  const [ingList, setIngList] = useState<IngredientDef[]>(() => (Array.isArray(ingredients) ? ingredients : []).filter((i) => !isDlc(i)));
  // Tools + ingredients buy their stock via the ingredient_costs map (keyed by
  // the item — saved whole so other costs aren't clobbered).
  // The AUTHORED cost map — only what this server has actually typed. Seeding it
  // from the effective map instead would write every installed pack's default price
  // into the settings table on the next save, freezing prices the pack should still
  // be able to update.
  const [costs, setCosts] = useState<Record<string, number>>(() => ({ ...(settings?.ingredient_costs || {}) }));
  // The EFFECTIVE map (authored over each pack's defaults) — what a cost field
  // DISPLAYS when this server hasn't set one. Without it a DLC-priced item read $0,
  // and saving that 0 would have written a free toy over the pack's price.
  const effectiveCosts: Record<string, number> = ingredientCosts || {};
  const costFor = (key?: string) =>
    (key && (costs[key] ?? effectiveCosts[key])) || 0;

  // Custom per-item images (item → { url, crop }), the `item_images` setting. Held
  // live so an image set on a burger/burnt-patty updates the row + field thumbnails
  // instantly; saved whole (missing keys aren't clobbered — it's the full map).
  const [itemImages, setItemImages] = useState<ItemImages>(() => ({ ...(settings?.item_images || {}) }));
  const foodStatus = useAutoSave(() => fetchNui("admin:saveSettings", { settings: { foods: foodList.map(clean) } }).then(onSaved), [foodList]);
  const toolStatus = useAutoSave(() => fetchNui("admin:saveSettings", { settings: { tools: toolList.map(clean) } }).then(onSaved), [toolList]);
  const ingStatus = useAutoSave(() => fetchNui("admin:saveSettings", { settings: { ingredients: ingList.map(clean) } }).then(onSaved), [ingList]);
  const costStatus = useAutoSave(() => fetchNui("admin:saveSettings", { settings: { ingredient_costs: costs } }).then(onSaved), [costs]);
  const allStatus = [foodStatus, toolStatus, ingStatus, costStatus];

  // Set/clear a custom image for one item (from an ItemField thumbnail). A null entry
  // removes the override so the item falls back to its catalogue image / icon. Saved
  // through a TARGETED server merge (not the whole map) so an edit here can't clobber
  // one made in the other tab; the local map is updated optimistically for instant art.
  const setItemImage = (item: string, entry: any) => {
    if (!item) return;
    const clean = entry && entry.url ? { url: String(entry.url), crop: entry.crop || null } : null;
    setItemImages((m) => {
      const next = { ...m };
      if (clean) next[item] = clean; else delete next[item];
      return next;
    });
    fetchNui("admin:setItemImage", { item, url: clean?.url || "", crop: clean?.crop || undefined }).then(onSaved);
  };
  const listStatus = allStatus.includes("saving") ? "saving" : allStatus.includes("saved") ? "saved" : "idle";

  const updateFood = (i: number, patch: any) => setFoodList((l) => l.map((f, idx) => (idx === i ? { ...f, ...patch } : f)));
  const updateTool = (i: number, patch: any) => setToolList((l) => l.map((t, idx) => (idx === i ? { ...t, ...patch } : t)));
  const updateIng = (i: number, patch: any) => setIngList((l) => l.map((g, idx) => (idx === i ? { ...g, ...patch } : g)));
  const setCost = (item: string | undefined, v: number) => {
    if (!item) return;
    setCosts((c) => ({ ...c, [item]: Math.max(0, Math.floor(v || 0)) }));
  };

  // Creating/editing happens in a modal dialog (an inline editor fought the
  // scrolling list). `editKey` ("food:3" / "tool:1" / …) names the open entry;
  // `picking` shows the New-Recipe preset chooser instead. At most one is set.
  const [editKey, setEditKey] = useState<string | null>(null);
  const [newOpen, setNewOpen] = useState(false);
  // "New Recipe" first asks WHAT it is (kind + preset) before showing any fields.
  const [picking, setPicking] = useState(false);
  // The Import Defaults dialog (restore deleted shipped entries / reset edited ones).
  const [importing, setImporting] = useState(false);
  // Free-text filter over the grouped list (matched against the entry's display
  // label, its kind, and its group name).
  const [search, setSearch] = useState("");
  // Closing the editor prunes anything with NO IDENTITY at all — a food's id is
  // derived from its label server-side, so a food that was created and never named
  // is dropped on save. Pruning it here keeps the list honest instead of showing a
  // row that quietly vanishes on the next refresh.
  const close = () => {
    setEditKey(null); setPicking(false); setImporting(false);
    setFoodList((l) => l.filter((f) => !!(f.id || (f.label || "").trim())));
    setToolList((l) => l.filter((t) => !!(t.id || (t.item || "").trim())));
    setIngList((l) => l.filter((i) => !!(i.item || "").trim()));
  };

  const addFood = (preset: Preset) => {
    setPicking(false);
    setFoodList((l) => {
      const next = [...l, { label: "", group: "", modifiers: [], ...preset.make() } as Food];
      setEditKey(`food:${next.length - 1}`);
      return next;
    });
  };
  const addTool = () => {
    setNewOpen(false);
    setToolList((l) => {
      const next = [...l, { item: "", tool_model: "", mode: "layer", applied_model: "", group: "" } as Tool];
      setEditKey(`tool:${next.length - 1}`);
      return next;
    });
  };
  const addIngredient = () => {
    setNewOpen(false);
    setIngList((l) => {
      const next = [...l, { item: "", model: "", group: "" } as IngredientDef];
      setEditKey(`ing:${next.length - 1}`);
      return next;
    });
  };

  // ── Import Defaults ──────────────────────────────────────────────────────────
  // Every shipped default, flagged present/missing against the CURRENT lists
  // (foods/tools by id, ingredients by item — same identity SeedUnifiedMenu uses).
  // Restoring appends a copy; resetting replaces the entry in place. Both go out
  // through the normal list autosave, so the server sanitizes + rebuilds as usual.
  type DefaultRow = { kind: "food" | "tool" | "ing"; key: string; label: string; img: string; present: boolean; def: any };
  const defaultRows = useMemo<DefaultRow[]>(() => {
    const rows: DefaultRow[] = [];
    if (showFood) (defaults?.foods ?? []).forEach((d) => rows.push({
      kind: "food", key: `food:${d.id}`, label: d.label || prettyName(d.id || ""), img: foodImageItem(d),
      present: foodList.some((f) => !!f.id && f.id === d.id), def: d,
    }));
    if (showIng) (defaults?.tools ?? []).forEach((d) => rows.push({
      kind: "tool", key: `tool:${d.id}`, label: d.item ? labelOf(items, d.item) : prettyName(d.id || ""), img: d.item || "",
      present: toolList.some((t) => !!t.id && t.id === d.id), def: d,
    }));
    if (showIng) (defaults?.ingredients ?? []).forEach((d) => rows.push({
      kind: "ing", key: `ing:${d.item}`, label: labelOf(items, d.item || ""), img: d.item || "",
      present: ingList.some((g) => !!g.item && g.item === d.item), def: d,
    }));
    return rows;
  }, [defaults, foodList, toolList, ingList, items, showFood, showIng]);
  const missingDefaults = defaultRows.filter((r) => !r.present);

  const restoreDefault = (row: DefaultRow) => {
    const def = JSON.parse(JSON.stringify(row.def)); // never share the payload's object
    const put = <T,>(list: T[], at: number): T[] => (at >= 0 ? list.map((e, i) => (i === at ? def : e)) : [...list, def]);
    if (row.kind === "food") setFoodList((l) => put(l, l.findIndex((f) => !!f.id && f.id === row.def.id)));
    else if (row.kind === "tool") setToolList((l) => put(l, l.findIndex((t) => !!t.id && t.id === row.def.id)));
    else setIngList((l) => put(l, l.findIndex((g) => !!g.item && g.item === row.def.item)));
  };

  const KIND_LABEL: Record<string, string> = { food: "menu.kind_recipe", tool: "menu.kind_tool", ing: "menu.kind_ingredient" };
  // which part of a food consumes nothing (server annotation `no_input`)
  const NO_INPUT_LABEL: Record<string, string> = {
    components: "menu.no_components", cook_input: "menu.no_cook_input",
    pour_cup: "menu.no_pour_cup", steps: "menu.no_steps",
  };

  // Build the unified, grouped row list.
  const groupsOut = useMemo(() => {
    type Row = { kind: string; key: string; group: string; sortLabel: string; index: number; data: any;
                 // set on a row that is one FACE of a multi-faced ingredient: the
                 // variant it shows, and the parent entry it is defined by
                 variant?: any };
    const rows: Row[] = [];

    // A variants ingredient is ONE authored entry with several faces (one
    // `restaurant_toy` holding five toys). List the FACES: that is what the kitchen
    // bar offers, what the larder stocks and prices, and what a customer ends up
    // with — a single "Toy" row answers none of the questions this tab is for.
    // Every face still points at its parent `index`, so editing or deleting any of
    // them acts on the one entry that defines them all.
    const pushIng = (g: any, index: number, keyBase: string) => {
      const group = (g.group as string) || "";
      const base = g.label || (g.item ? labelOf(items, g.item) : "");
      const vs = Array.isArray(g.variants) ? g.variants : [];
      if (vs.length === 0) {
        rows.push({ kind: "ing", key: keyBase, group, sortLabel: base, index, data: g });
        return;
      }
      vs.forEach((v: any) => rows.push({
        kind: "ing", key: `${keyBase}:${v.id}`, group,
        sortLabel: v.label || v.id || base, index, data: g, variant: v,
      }));
    };
    if (showFood) foodList.forEach((f, i) => rows.push({
      kind: "food", key: `food:${i}`, group: (f.group as string) || "",
      sortLabel: f.label || (f.id ? prettyName(f.id) : labelOf(items, foodImageItem(f))), index: i, data: f,
    }));
    if (showIng) toolList.forEach((t, i) => rows.push({
      kind: "tool", key: `tool:${i}`, group: (t.group as string) || "",
      sortLabel: t.item ? labelOf(items, t.item) : "", index: i, data: t,
    }));
    if (showIng) ingList.forEach((g, i) => pushIng(g, i, `ing:${i}`));
    // DLC rows sit in the SAME grouped list as everything else — a pack's toy is part
    // of this menu, and hiding it in a separate drawer would make "why can't a
    // restaurant carrying this group cook that?" much harder to answer. They carry no
    // list slot (index -1) because there is nothing here to edit: a pack owns its
    // content, and the row's only control is what the restaurant pays for the item.
    if (showFood) dlcEntries.foods.forEach((f: any) => rows.push({
      kind: "food", key: `dlcfood:${f.id}`, group: (f.group as string) || "",
      sortLabel: f.label || (f.id ? prettyName(f.id) : labelOf(items, foodImageItem(f))), index: -1, data: f,
    }));
    if (showIng) dlcEntries.tools.forEach((t: any) => rows.push({
      kind: "tool", key: `dlctool:${t.id}`, group: (t.group as string) || "",
      sortLabel: t.item ? labelOf(items, t.item) : "", index: -1, data: t,
    }));
    if (showIng) dlcEntries.ingredients.forEach((g: any) => pushIng(g, -1, `dlcing:${g.item}`));

    const q = search.trim().toLowerCase();
    const shown = q
      ? rows.filter((r) =>
          r.sortLabel.toLowerCase().includes(q) ||
          r.group.toLowerCase().includes(q) ||
          // a face is searchable by what it IS ("toy"), which is the badge it wears
          (!!r.variant && String(r.data.label || "").toLowerCase().includes(q)) ||
          _L(KIND_LABEL[r.kind]).toLowerCase().includes(q))
      : rows;

    const by: Record<string, Row[]> = {};
    shown.forEach((r) => { (by[r.group] ||= []).push(r); });
    const order = ["food", "tool", "ing"];
    const names = Object.keys(by).sort((a, b) => (a === "" ? 1 : b === "" ? -1 : a.localeCompare(b)));
    return names.map((g) => ({
      name: g,
      rows: by[g].sort((a, b) => (order.indexOf(a.kind) - order.indexOf(b.kind)) || a.sortLabel.localeCompare(b.sortLabel)),
    }));
  }, [foodList, toolList, ingList, dlcEntries, items, search, showFood, showIng]);

  // The eat/drink animations a food can be assigned (Settings → Eating). Foods
  // reference one by id; an empty pick means "the global default".
  const consumeAnims: ConsumeAnim[] = Array.isArray(settings?.consume_anims) ? settings.consume_anims : [];

  const imgItem = (row: any) =>
    row.kind === "food" ? foodImageItem(row.data)
    : row.kind === "tool" ? row.data.item
    : row.data.item;

  // The entry the dialog is editing, resolved live from the lists by index (the
  // lists only change via the dialog's own patches or a delete that closes it,
  // so the index stays valid while open).
  const editing = editKey ? (() => {
    const [kind, idxStr] = editKey.split(":");
    const index = Number(idxStr);
    // `data` is a plain union across the three kinds; the `kind` tag guards each
    // use, so treat it as any (matching how the row list already types data).
    const data: any = kind === "food" ? foodList[index] : kind === "tool" ? toolList[index] : ingList[index];
    return data ? { kind, index, data } : null;
  })() : null;

  const KIND_ICON: Record<string, JSX.Element> = {
    food: <UtensilsCrossed className="h-4 w-4" />,
    tool: <Wrench className="h-4 w-4" />,
    ing: <Layers className="h-4 w-4" />,
  };
  const editTitle = editing
    ? editing.kind === "food"
      ? (editing.data.label || (editing.data.id ? prettyName(editing.data.id) : _L("menu.kind_recipe")))
      : editing.kind === "tool"
        ? (editing.data.item ? labelOf(items, editing.data.item) : _L("menu.kind_tool"))
        : (editing.data.label || (editing.data.item ? labelOf(items, editing.data.item) : _L("menu.kind_ingredient")))
    : "";

  return (
    <div className="flex min-h-0 flex-1 flex-col gap-3">
      <div className="flex shrink-0 items-start justify-between gap-2">
        <p className="text-xs text-muted-foreground">{_L(showFood ? "menu.intro_food" : "menu.intro_ingredients")}</p>
        <div className="flex shrink-0 items-center gap-2">
          {listStatus === "saving" && <span className="flex items-center gap-1 text-xs text-muted-foreground"><Loader2 className="h-3 w-3 animate-spin" /> {_L("recipes.saving")}</span>}
          {listStatus === "saved" && <span className="flex items-center gap-1 text-xs text-muted-foreground"><Check className="h-3 w-3 text-primary" /> {_L("recipes.saved")}</span>}
          <div className="relative">
            <Button size="sm" onClick={() => setNewOpen((v) => !v)}><Plus className="h-4 w-4" /> {_L("menu.new")} <ChevronDown className="h-3 w-3" /></Button>
            {newOpen && (
              <div className="absolute right-0 z-10 mt-1 w-52 overflow-hidden rounded-md border border-border bg-popover shadow-md">
                {showFood && <button className="block w-full px-3 py-2 text-left text-sm hover:bg-accent" onClick={() => { setNewOpen(false); setPicking(true); setEditKey(null); }}>{_L("menu.new_recipe")}</button>}
                {showIng && <button className="block w-full px-3 py-2 text-left text-sm hover:bg-accent" onClick={addTool}>{_L("menu.new_tool")}</button>}
                {showIng && <button className="block w-full px-3 py-2 text-left text-sm hover:bg-accent" onClick={addIngredient}>{_L("menu.new_ingredient")}</button>}
                {defaultRows.length > 0 && (
                  <>
                    <div className="my-1 border-t border-border" />
                    <button className="flex w-full items-center gap-1.5 px-3 py-2 text-left text-sm hover:bg-accent"
                      onClick={() => { setNewOpen(false); setEditKey(null); setPicking(false); setImporting(true); }}>
                      <Download className="h-3.5 w-3.5 text-muted-foreground" /> {_L("menu.import_defaults")}
                    </button>
                  </>
                )}
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="flex shrink-0 items-center gap-2 rounded-md border border-input bg-muted/50 px-2.5">
        <Search className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder={_L("menu.search_placeholder")}
          className="h-9 w-full bg-transparent text-sm outline-none placeholder:text-muted-foreground"
        />
        {search && (
          <button className="shrink-0 text-muted-foreground hover:text-foreground" onClick={() => setSearch("")}>
            <X className="h-3.5 w-3.5" />
          </button>
        )}
      </div>

      <div className="min-h-0 flex-1 space-y-4 overflow-y-auto pr-1 pb-4">
        {groupsOut.length === 0 && (
          <div className="py-6 text-center text-sm text-muted-foreground">
            {search.trim() ? _L("menu.no_match", search.trim()) : _L(showFood ? "menu.none_yet_food" : "menu.none_yet_ingredients")}
          </div>
        )}

        {groupsOut.map((grp) => (
          <div key={grp.name || "__ungrouped__"} className="space-y-2">
            <div className="flex items-center gap-2 px-1 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
              <Tags className="h-3.5 w-3.5" /> {grp.name || _L("menu.ungrouped")}
            </div>
            {grp.rows.map((row) => {
              const d = row.data;
              const invalid = d.valid === false;
              const isEditing = editKey === row.key;
              const badModels = (d.invalid_models as string[]) || [];
              return (
                <div key={row.key} className={cn("rounded-lg border p-3", invalid ? "border-destructive/50 bg-destructive/5" : "border-border")}>
                  <div className="flex items-center justify-between gap-2">
                    <div className="flex min-w-0 items-center gap-3">
                      <EntryThumb items={items} name={imgItem(row)} itemImages={itemImages} className="h-10 w-10 shrink-0"
                        url={row.variant?.image || (row.kind === "food" ? foodImageUrl(row.data) : undefined)} />
                      <div className="min-w-0">
                        <div className="flex flex-wrap items-center gap-2">
                          <Truncate className="font-medium">{row.sortLabel || "—"}</Truncate>
                          {/* A FACE wears what its parent says it IS ("Toy"), not the
                              generic kind — five rows badged "Ingredient" say nothing
                              about what they are, and the parent's label is exactly
                              the word for a family of faces. */}
                          <Badge variant="secondary">{row.variant ? (d.label || _L(KIND_LABEL[row.kind])) : _L(KIND_LABEL[row.kind])}</Badge>
                          {/* Contributed by an installed pack, not authored here. */}
                          {!!d.dlc && (
                            <Badge variant="outline" className="gap-1 border-primary/50 text-primary">
                              <Package className="h-3 w-3" /> {_L("menu.dlc_badge")}
                            </Badge>
                          )}
                          {row.kind === "food" && <Badge variant="outline">{foodSubBadge(d)}</Badge>}
                          {row.kind === "food" && d.serving_item_installed === false && (
                            <Badge variant="destructive" className="gap-1"><TriangleAlert className="h-3 w-3" /> {_L("menu.drink_not_installed")}</Badge>
                          )}
                          {row.kind === "food" && d.box_item_installed === false && (
                            <Badge variant="destructive" className="gap-1"><TriangleAlert className="h-3 w-3" /> {_L("menu.box_not_installed")}</Badge>
                          )}
                          {/* nothing is made from nothing: a step that consumes
                              nothing is refused in-game, so say which one is empty */}
                          {row.kind === "food" && !!d.no_input && (
                            <Badge variant="destructive" className="gap-1"><TriangleAlert className="h-3 w-3" /> {_L(NO_INPUT_LABEL[d.no_input] || "menu.no_input")}</Badge>
                          )}
                          {row.kind === "food" && !!d.duplicate_input && (
                            <Badge variant="destructive" className="gap-1"><TriangleAlert className="h-3 w-3" /> {_L("menu.duplicate_input")}</Badge>
                          )}
                          {/* A FACE is priced per face, so it shows ITS default, not
                              the parent entry's. */}
                          {(() => {
                            const dp = row.variant ? row.variant.defaultPrice : d.defaultPrice;
                            return typeof dp === "number" && dp > 0 ? (
                              <Badge variant="outline" className="text-emerald-500">{_L("menu.default_price", dp)}</Badge>
                            ) : null;
                          })()}
                          {invalid && (
                            <Badge variant="destructive" className="gap-1"><TriangleAlert className="h-3 w-3" /> {_L("recipes.needs_fixing")}</Badge>
                          )}
                          {badModels.length > 0 && (
                            <Badge variant="outline" className="gap-1 border-amber-500/60 text-amber-500"><TriangleAlert className="h-3 w-3" /> {_L("recipes.invalid_model")}</Badge>
                          )}
                        </div>
                        {/* A FACE of a multi-faced ingredient. The tab lists faces
                            because that's what the kitchen and the larder deal in,
                            but they are all one item and one authored entry — say so,
                            or five rows read as five items to install. */}
                        {!!row.variant && (
                          <div className="mt-1 flex flex-wrap items-center gap-1 text-[11px] text-muted-foreground">
                            <Layers className="h-3 w-3" />
                            {_L("menu.variant_of", d.label || d.item)}
                          </div>
                        )}
                        {invalid && Array.isArray(d.missing) && d.missing.length > 0 && (
                          <div className="mt-1 flex flex-wrap items-center gap-1 text-xs text-destructive">
                            <EyeOff className="h-3 w-3" /> {_L("recipes.hidden_missing")}
                            {d.missing.map((m: string) => <span key={m} className="font-mono">{m}</span>)}
                          </div>
                        )}
                      </div>
                    </div>
                    {/* A DLC entry is the PACK's: models, group, behaviour and the
                        entry itself all come from that resource, so this row has
                        nothing to edit and nothing to delete. The one thing that IS
                        the server's — what it pays for the item — is edited in
                        Settings → Ingredient Costs, where every cost lives. */}
                    {d.dlc ? null : (
                    <div className="flex shrink-0 items-center gap-2">
                      <Button size="sm" variant={isEditing ? "secondary" : "outline"} onClick={() => { setPicking(false); setEditKey(row.key); }}><Pencil className="h-4 w-4" /></Button>
                      {/* A deleted DEFAULT entry re-seeds on next restart (the embedded
                          default menu is recoverable); admin-added ones stay gone. */}
                      <Button size="sm" variant="destructive" onClick={() => {
                        close();
                        if (row.kind === "food") setFoodList((l) => l.filter((_, i) => i !== row.index));
                        else if (row.kind === "tool") setToolList((l) => l.filter((_, i) => i !== row.index));
                        else setIngList((l) => l.filter((_, i) => i !== row.index));
                      }}><Trash2 className="h-4 w-4" /></Button>
                    </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        ))}
      </div>

      {/* New Recipe: pick what kind of thing it is FIRST — each preset seeds the
          right step skeleton, so the editor opens already making sense. */}
      <Modal
        open={picking}
        onClose={close}
        title={_L("menu.new_recipe")}
        subtitle={_L("menu.preset_title")}
        icon={<UtensilsCrossed className="h-4 w-4" />}
        size="lg"
      >
        <div className="grid grid-cols-2 gap-2">
          {PRESETS().map((p) => (
            <button
              key={p.key}
              onClick={() => addFood(p)}
              className="rounded-lg border border-border bg-card p-3 text-left transition-colors hover:border-primary/60 hover:bg-accent/60"
            >
              <div className="text-sm font-semibold">{p.label}</div>
              <div className="mt-0.5 text-[11px] leading-snug text-muted-foreground">{p.desc}</div>
            </button>
          ))}
        </div>
      </Modal>

      {/* Import Defaults: the shipped menu, restorable entry-by-entry. A missing
          default (deleted, or pre-dating an update) gets Restore; a present one
          gets Reset — replacing the current entry with the shipped version. */}
      <Modal
        open={importing}
        onClose={close}
        title={_L("menu.import_defaults")}
        subtitle={_L("menu.import_defaults_sub")}
        icon={<Download className="h-4 w-4" />}
        size="lg"
        footer={
          missingDefaults.length > 0 ? (
            <Button size="sm" onClick={() => missingDefaults.forEach(restoreDefault)}>
              <Download className="h-4 w-4" /> {_L("menu.import_all", missingDefaults.length)}
            </Button>
          ) : (
            <Button size="sm" variant="outline" onClick={close}>{_L("recipes.done")}</Button>
          )
        }
      >
        <div className="space-y-1.5">
          {missingDefaults.length === 0 && (
            <p className="pb-1 text-center text-xs text-muted-foreground">{_L("menu.import_all_present")}</p>
          )}
          {defaultRows.map((row) => (
            <div key={row.key} className="flex items-center justify-between gap-2 rounded-lg border border-border p-2">
              <div className="flex min-w-0 items-center gap-2.5">
                <ItemImage items={items} name={row.img} className="h-8 w-8 shrink-0" />
                <Truncate className="text-sm font-medium">{row.label}</Truncate>
                <Badge variant="secondary" className="shrink-0">{_L(KIND_LABEL[row.kind])}</Badge>
              </div>
              <div className="flex shrink-0 items-center gap-2">
                {row.present ? (
                  <>
                    <span className="flex items-center gap-1 text-[11px] text-muted-foreground">
                      <Check className="h-3 w-3 text-primary" /> {_L("menu.import_on_menu")}
                    </span>
                    <Button size="sm" variant="outline" onClick={() => restoreDefault(row)}>
                      <RotateCcw className="h-3.5 w-3.5" /> {_L("menu.import_reset")}
                    </Button>
                  </>
                ) : (
                  <Button size="sm" onClick={() => restoreDefault(row)}>
                    <Download className="h-3.5 w-3.5" /> {_L("menu.import_restore")}
                  </Button>
                )}
              </div>
            </div>
          ))}
        </div>
      </Modal>

      {/* Create / edit an entry in a dialog (replaces the old inline editor). */}
      <Modal
        open={!!editing}
        onClose={close}
        title={editTitle}
        subtitle={editing ? _L(KIND_LABEL[editing.kind]) : ""}
        icon={editing ? KIND_ICON[editing.kind] : null}
        size={editing?.kind === "food" ? "xl" : "lg"}
        footer={<Button size="sm" onClick={close}>{_L("recipes.done")}</Button>}
      >
        {editing?.kind === "food" && (
          <FoodForm food={editing.data} onChange={(p) => updateFood(editing.index, p)} items={items} groups={groups}
            compItems={compItems}
            itemImages={itemImages} onSetItemImage={setItemImage} anims={consumeAnims} boxQuad={boxQuad} />
        )}
        {editing?.kind === "tool" && (
          <ToolForm
            tool={editing.data}
            cost={costFor(editing.data.item)}
            allTools={toolList}
            onChange={(p) => updateTool(editing.index, p)}
            onChangeCost={(v) => setCost(editing.data.item, v)}
            items={items}
            groups={groups}
            itemImages={itemImages}
            onSetItemImage={setItemImage}
          />
        )}
        {editing?.kind === "ing" && (
          <IngredientForm
            ing={editing.data}
            cost={costFor(editing.data.item)}
            onChange={(p) => updateIng(editing.index, p)}
            onChangeCost={(v) => setCost(editing.data.item, v)}
            items={items}
            groups={groups}
            itemImages={itemImages}
            onSetItemImage={setItemImage}
          />
        )}
      </Modal>
    </div>
  );
}
