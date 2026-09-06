import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import type { RootState } from '.';

export interface JobGrade {
  grade: number;
  label: string;
}

export interface JobEntry {
  name: string;
  label: string;
  grades: JobGrade[];
}

export interface StashCoords {
  x: number;
  y: number;
  z: number;
}

export interface StashTarget {
  coords?: StashCoords;
  heading?: number;
  size?: StashCoords;
  label?: string;
}

export interface StashProp {
  enabled: boolean;
  model?: string;
  coords?: StashCoords;
  rotation?: { x: number; y: number; z: number };
}

// A single placed location for a shop / bench: position + facing.
export interface PlacedLocation {
  x: number;
  y: number;
  z: number;
  heading?: number;
}

export interface CustomStash {
  name: string;
  label: string;
  owner?: string | boolean;
  slots: number;
  maxWeight: number;
  groups?: Record<string, number>;
  coords?: StashCoords;
  target?: StashTarget;
  prop?: StashProp;
  instance?: number;
}

export interface ItemEntry {
  name: string;
  label: string;
}

export interface RecipeIngredient {
  name: string;
  count: number;
}

export interface CraftRecipe {
  name: string; // resulting item
  count: number;
  duration: number;
  ingredients: RecipeIngredient[];
}

export interface CraftBench {
  id: string;
  label: string;
  groups?: Record<string, number>;
  recipes: CraftRecipe[];
  coords?: StashCoords;
  target?: StashTarget;
  prop?: StashProp;
}

export interface ShopProduct {
  name: string;
  price: number;
  currency?: string;
  grade?: number;
  license?: string;
}

export interface ShopPed {
  enabled: boolean;
  model?: string;
}

export interface CustomShop {
  id: string;
  label: string;
  groups?: Record<string, number>;
  inventory: ShopProduct[];
  coords?: StashCoords | StashCoords[];
  prop?: StashProp;
  ped?: ShopPed;
  // Per-shop map blip overrides (undefined = use the global shop appearance).
  blipSprite?: number;
  blipColor?: number;
}

export interface MarkerConfig {
  type: number;
  color: { r: number; g: number; b: number };
  alpha: number;
  scale: number;
  bob: boolean;
}

export interface BlipConfig {
  sprite: number;
  color: number;
  scale: number;
  alpha: number;
  shortRange: boolean;
  display: number; // 2 = both, 3 = minimap only, 5 = main map only
  name?: string;
}

// One marker + blip configuration block (per type).
export interface AppearanceBlock {
  marker: MarkerConfig;
  blip: BlipConfig;
}

export type AppearanceKind = 'stash' | 'craft' | 'shop';

// Full per-type appearance config.
export type Appearance = Record<AppearanceKind, AppearanceBlock>;

export const DEFAULT_BLOCK: AppearanceBlock = {
  marker: { type: 21, color: { r: 31, g: 94, b: 255 }, alpha: 180, scale: 0.4, bob: true },
  blip: { sprite: 566, color: 31, scale: 0.7, alpha: 255, shortRange: true, display: 2, name: '' },
};

export const DEFAULT_APPEARANCE: Appearance = {
  stash: DEFAULT_BLOCK,
  craft: DEFAULT_BLOCK,
  shop: DEFAULT_BLOCK,
};

interface StashAdminState {
  open: boolean;
  stashes: CustomStash[];
  jobs: JobEntry[];
  benches: CraftBench[];
  items: ItemEntry[];
  shops: CustomShop[];
  currencies: string[];
  appearance: Appearance;
}

const initialState: StashAdminState = {
  open: false,
  stashes: [],
  jobs: [],
  benches: [],
  items: [],
  shops: [],
  currencies: ['money', 'black_money'],
  appearance: DEFAULT_APPEARANCE,
};

export const stashAdminSlice = createSlice({
  name: 'stashAdmin',
  initialState,
  reducers: {
    openStashAdmin(state, action: PayloadAction<{ stashes: CustomStash[]; jobs: JobEntry[] }>) {
      state.open = true;
      state.stashes = action.payload.stashes || [];
      state.jobs = action.payload.jobs || [];
    },
    closeStashAdmin(state) {
      state.open = false;
    },
    setCraftAdminData(state, action: PayloadAction<{ benches: CraftBench[]; items: ItemEntry[] }>) {
      state.benches = action.payload.benches || [];
      state.items = action.payload.items || [];
    },
    upsertStash(state, action: PayloadAction<CustomStash>) {
      const idx = state.stashes.findIndex((s) => s.name === action.payload.name);
      if (idx !== -1) state.stashes[idx] = action.payload;
      else state.stashes.push(action.payload);
    },
    removeStash(state, action: PayloadAction<string>) {
      state.stashes = state.stashes.filter((s) => s.name !== action.payload);
    },
    upsertBench(state, action: PayloadAction<CraftBench>) {
      const idx = state.benches.findIndex((b) => b.id === action.payload.id);
      if (idx !== -1) state.benches[idx] = action.payload;
      else state.benches.push(action.payload);
    },
    removeBench(state, action: PayloadAction<string>) {
      state.benches = state.benches.filter((b) => b.id !== action.payload);
    },
    setShopAdminData(
      state,
      action: PayloadAction<{ shops: CustomShop[]; items: ItemEntry[]; currencies: string[] }>
    ) {
      state.shops = action.payload.shops || [];
      if (action.payload.items?.length) state.items = action.payload.items;
      if (action.payload.currencies?.length) state.currencies = action.payload.currencies;
    },
    upsertShop(state, action: PayloadAction<CustomShop>) {
      const idx = state.shops.findIndex((s) => s.id === action.payload.id);
      if (idx !== -1) state.shops[idx] = action.payload;
      else state.shops.push(action.payload);
    },
    removeShop(state, action: PayloadAction<string>) {
      state.shops = state.shops.filter((s) => s.id !== action.payload);
    },
    setAppearance(state, action: PayloadAction<Appearance>) {
      state.appearance = action.payload;
    },
  },
});

export const {
  openStashAdmin,
  closeStashAdmin,
  setCraftAdminData,
  setShopAdminData,
  upsertStash,
  removeStash,
  upsertBench,
  removeBench,
  upsertShop,
  removeShop,
  setAppearance,
} = stashAdminSlice.actions;

export const selectStashAdmin = (state: RootState) => state.stashAdmin;

export default stashAdminSlice.reducer;
