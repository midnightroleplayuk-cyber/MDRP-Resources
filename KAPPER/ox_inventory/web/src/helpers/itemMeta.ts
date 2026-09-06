import { Items } from '../store/items';
import type { Slot } from '../typings';

/**
 * Tarkov-style grid footprint + rarity tier for an item.
 *
 * Resolution order, most specific first:
 *   1. an explicit `grid = { 3, 2 }` / `rarity = 'legendary'` on the item
 *      definition (data/items.lua, data/weapons.lua),
 *   2. the item's class (weapon / component / ammo) and name,
 *   3. its weight.
 *
 * The footprint is purely visual: the item still occupies a single logical slot
 * server-side, because ox_inventory addresses inventories by slot index.
 */

export interface GridSize {
  w: number;
  h: number;
}

/** The inventory grid is 5 columns wide ($gridCols) and shows 4 rows. */
const MAX_W = 5;
const MAX_H = 4;

const ONE_BY_ONE: GridSize = { w: 1, h: 1 };

// Weapon classes, matched against the (lowercased) item name.
// NOTE: `\b` is useless here — the names are `weapon_mg`, and `_` is a word
// character, so `\bmg\b` never matches. Anchor on the underscore instead.
const LONG_GUN = /(rifle|shotgun|sniper|carbine|musket|gusenberg|minigun|railgun|launcher|combatmg|lmg|_mg$|_mg_|_rpg$|_rpg_)/;
const SMG = /(smg|machinepistol|combatpdw)/;
const HANDGUN = /(pistol|revolver|flaregun|stungun|doubleaction)/;
const MELEE = /(bat|crowbar|golfclub|hammer|hatchet|knuckle|machete|switchblade|nightstick|wrench|battleaxe|dagger|poolcue|knife|bottle|candycane)/;
// GTA registers a pile of tools as "weapons". They are not loot, and should not
// be sized or coloured like a sidearm.
const TOOL = /(extinguisher|petrolcan|fertilizercan|hazardcan|flashlight|metaldetector|garbagebag|handcuffs|briefcase|_hose)/;

// Non-weapon items whose name reliably implies a bulky footprint.
const BULKY = /(armou?r|vest|bulletproof|plate|backpack|parachute|duffel|toolbox|jerry|canister)/;
const TALL = /(medkit|firstaid|first_aid|ifak|defib|bandage_kit|crowbar|shovel|axe)/;

const asSize = (w: number, h: number): GridSize => ({
  w: Math.max(1, Math.min(MAX_W, Math.floor(w))),
  h: Math.max(1, Math.min(MAX_H, Math.floor(h))),
});

/** Reads an explicit `grid` override, accepting `{3, 2}` or `{ w = 3, h = 2 }`. */
const explicitGrid = (grid: unknown): GridSize | null => {
  if (Array.isArray(grid) && grid.length >= 2) {
    const [w, h] = grid;
    if (typeof w === 'number' && typeof h === 'number') return asSize(w, h);
    return null;
  }

  if (grid && typeof grid === 'object') {
    const { w, h } = grid as { w?: unknown; h?: unknown };
    if (typeof w === 'number' && typeof h === 'number') return asSize(w, h);
  }

  return null;
};

/**
 * @param slot the rendered slot (its `weight` is the whole stack's)
 */
export const getItemSize = (slot: Slot): GridSize => {
  if (!slot.name) return ONE_BY_ONE;

  const data = Items[slot.name];
  const explicit = explicitGrid(data?.grid);
  if (explicit) return explicit;

  const name = slot.name.toLowerCase();

  // Attachments, tints and ammo boxes are always a single cell.
  if (data && (data.component || data.tint || data.ammo)) return ONE_BY_ONE;

  if (data && data.weapon) {
    // Throwables (grenades, molotovs…) stack and stay 1x1.
    if (data.stack) return ONE_BY_ONE;
    if (TOOL.test(name)) return asSize(1, 2);
    // Footprints tuned for a 5-wide / 4-tall pocket: a 3-wide rifle ate six
    // cells and forced two extra rows (everything below got clipped). 2x2 for
    // long guns keeps them clearly the biggest items while packing cleanly
    // against the 1x1 loot and 2x1 sidearms.
    if (LONG_GUN.test(name)) return asSize(2, 2);
    if (SMG.test(name)) return asSize(2, 2);
    if (HANDGUN.test(name)) return asSize(2, 1);
    if (MELEE.test(name)) return asSize(1, 2);
    return asSize(2, 1);
  }

  if (BULKY.test(name)) return asSize(2, 2);
  if (TALL.test(name)) return asSize(1, 2);

  // Fall back to the unit weight — a single elk should not fit in a matchbox.
  const unitWeight = data?.weight ?? (slot.count ? (slot.weight ?? 0) / slot.count : slot.weight ?? 0);

  if (unitWeight >= 25000) return asSize(2, 2);
  if (unitWeight >= 8000) return asSize(2, 1);

  return ONE_BY_ONE;
};

/** Extra cells an item consumes beyond the single one it is drawn in. */
export const getExtraCells = (slot: Slot): number => {
  const { w, h } = getItemSize(slot);
  return w * h - 1;
};

// ── Rarity ──────────────────────────────────────────────────────

export type Rarity = 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary';

const RARITIES: Rarity[] = ['common', 'uncommon', 'rare', 'epic', 'legendary'];

export const RARITY_COLORS: Record<Rarity, string> = {
  common: '#8b8b93',
  uncommon: '#22c55e',
  rare: '#3b82f6',
  epic: '#a855f7',
  legendary: '#f59e0b',
};

/** Same colours as `RARITY_COLORS`, as `r, g, b` for use inside rgba(). */
export const RARITY_RGB: Record<Rarity, string> = {
  common: '139, 139, 147',
  uncommon: '34, 197, 94',
  rare: '59, 130, 246',
  epic: '168, 85, 247',
  legendary: '245, 158, 11',
};

/** English fallbacks — localised at render via `Locale['ui_rarity_<tier>']`. */
export const RARITY_LABELS: Record<Rarity, string> = {
  common: 'Common',
  uncommon: 'Uncommon',
  rare: 'Rare',
  epic: 'Epic',
  legendary: 'Legendary',
};

const isRarity = (value: unknown): value is Rarity => RARITIES.includes(value as Rarity);

const LEGENDARY = /(gold|diamond|rolex|artefact|artifact|sasquatch|great_bison|white_stag|goldbar)/;
const EPIC = /(grizzly|cougar|elk|stag|painting|jewel|emerald|ruby|sapphire)/;

export const getItemRarity = (slot: Slot): Rarity => {
  if (!slot.name) return 'common';

  // A per-item override wins, and so does per-instance metadata (so a crafted or
  // looted variant can outrank its base item).
  const metaRarity = slot.metadata?.rarity;
  if (isRarity(metaRarity)) return metaRarity;

  const data = Items[slot.name];
  const itemRarity = data?.rarity;
  if (isRarity(itemRarity)) return itemRarity;

  const name = slot.name.toLowerCase();

  if (LEGENDARY.test(name)) return 'legendary';
  if (EPIC.test(name)) return 'epic';

  if (data && data.weapon) {
    if (TOOL.test(name)) return 'common'; // extinguishers, cans, torches…
    if (data.stack) return 'uncommon'; // throwables
    if (LONG_GUN.test(name)) return 'epic';
    return 'rare';
  }

  if (data && (data.component || data.tint)) return 'uncommon';

  return 'common';
};
