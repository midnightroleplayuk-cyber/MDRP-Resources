// Local, server-supplied artwork for NON-INVENTORY restaurant items.
//
// A handful of cooking cards are kitchen EQUIPMENT, not installed inventory items
// (see CLAUDE.md: "equipment, never an item") — the serving tray, pizza box, the
// baking trays, the restaurant bag and the drink cup lid. They collapse into ONE
// consolidated item (or none at all), so there is no per-item inventory image to
// draw and the cards fall back to a generic vector icon.
//
// This lets a server SUPPLY its own art for them: drop a PNG named below into
// `web/public/items/` and rebuild. Vite copies `web/public/` to the build root
// (`nui/`, which fxmanifest serves via `nui/**/*`) and `base: "./"` makes the path
// resolve relative to the loaded NUI/DUI page, so the file is reachable as
// `items/<name>.png`. A missing file simply falls back to the icon — nothing breaks
// and the folder is optional.
//
// NOTE: this is the 2D CARD artwork only. The in-world prop is still the 3D model
// configured on the equipment (tray_model / box models / bag_model / lid model).

// URL for a supplied image, relative to the NUI page (survives `emptyOutDir` rebuilds
// because it lives in web/public/, not in the generated nui/ output).
export const localItemUrl = (name: string) => `items/${name}.png`;

// The canonical filename (sans extension) for each non-inventory equipment card,
// keyed by its card `kind` and — where one kind has variants — `kind:subkind`.
// THIS IS THE MANIFEST: the list of images a server can supply. Keep it in sync
// with web/public/items/README.md.
export const EQUIP_IMAGE: Record<string, string> = {
  tray: "serving_tray", // kitchen prep — Serving Tray
  pizzabox: "pizza_box", // kitchen prep — Pizza Box
  bag: "restaurant_bag", // kitchen prep — Restaurant Bag
  lid: "cup_lid", // soda machine — Cup Lid
  "baketray:caketin": "cake_tin", // kitchen prep — Cake Tin
  "baketray:cookietray": "cookie_tray", // kitchen prep — Cookie Tray
};

// Resolve the supplied-image URL for an equipment card, or undefined if the kind
// isn't a supported non-inventory item. Variant kinds (baking trays) key on
// `kind:subkind` first, then fall back to the bare kind.
export const equipImageUrl = (kind: string, subkind?: string): string | undefined => {
  const name = (subkind && EQUIP_IMAGE[`${kind}:${subkind}`]) || EQUIP_IMAGE[kind];
  return name ? localItemUrl(name) : undefined;
};

// ── Drinks ────────────────────────────────────────────────────────────────────
// Every poured drink collapses into the ONE generic drink item, its flavor riding
// as metadata — so a flavor has no inventory image of its own. The join key is the
// drink's `output` (the `drinks[].output` config key). Drop web/public/items/<output>.png
// (e.g. items/soda.png, items/grape_soda.png) to give each flavor its card art.
// The output surfaces to the NUI three ways, one per drink-facing surface:
//   • a cooking tray entry's `flavor`             (getTray, modules/cooking)
//   • a POS line's `variant` when kind === "drink" (resolveOrderLines, modules/sales)
//   • a flavor modifier's id "flavor:<output>"     (BuildPricedCatalog, modules/sales)

// A poured-drink tray card, keyed by the entry's flavor output.
export const drinkImageUrl = (output?: string): string | undefined =>
  output ? localItemUrl(output) : undefined;

// A POS catalog/ticket line — only a drink line (kind "drink") resolves a per-flavor
// image, from its `variant` (the chosen flavor output).
export const drinkLineImageUrl = (kind?: string, variant?: string): string | undefined =>
  kind === "drink" && variant ? localItemUrl(variant) : undefined;

// A drink flavor MODIFIER tile in the POS picker (its id is "flavor:<output>").
export const flavorModImageUrl = (id?: string): string | undefined =>
  id && id.startsWith("flavor:") ? localItemUrl(id.slice("flavor:".length)) : undefined;

// A supplied image for ANY catalog item that lacks an inventory image, keyed by
// its item id (items/<item>.png). Used as a last-resort POS fallback — e.g. drop
// items/drink.png to art the generic "Restaurant Drink" card/dialog header (the
// drink item with no flavor chosen yet).
export const itemImageUrl = (item?: string): string | undefined =>
  item ? localItemUrl(item) : undefined;
