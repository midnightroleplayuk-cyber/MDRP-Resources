export type ItemData = {
  name: string;
  label: string;
  stack: boolean;
  usable: boolean;
  close: boolean;
  count: number;
  description?: string;
  buttons?: string[];
  ammoName?: string;
  image?: string;
  /** Base weight of a single unit, in grams. */
  weight?: number;
  /** Explicit grid footprint override: `grid = { 3, 2 }` in data/items.lua. */
  grid?: [number, number] | { w: number; h: number };
  /** Explicit rarity override: `rarity = 'legendary'` in data/items.lua. */
  rarity?: string;
  weapon?: boolean;
  ammo?: boolean;
  component?: boolean;
  tint?: boolean;
};
