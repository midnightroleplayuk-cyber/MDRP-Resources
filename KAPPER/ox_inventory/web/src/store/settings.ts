import { createSelector, createSlice, PayloadAction } from '@reduxjs/toolkit';
import type { RootState } from '.';

export type SlotShape = 'rounded' | 'square';
export type TitleShape = 'rounded' | 'square' | 'circle' | 'hexagon' | 'diamond';
export type UiSize = 'small' | 'medium' | 'large';

// Scale factor applied to the whole inventory for each size. Kept gentle so
// "large" never runs off-screen and "small" stays crisp.
export const UI_SIZE_SCALE: Record<UiSize, number> = {
  small: 0.8,
  medium: 0.9,
  large: 1,
};

/** Everything a template (and the server-wide theme) can drive. */
export interface VisualSettings {
  themeColor: string; // brand accent (hex)
  bgColor: string; // panel/background base (hex)
  bgOpacity: number; // 0-100, opacity applied to panel/slot surfaces
  slotShape: SlotShape;
  titleShape: TitleShape;
  uiSize: UiSize;
  showWeight: boolean; // show the weight number + pips
  showStats: boolean; // show the health/armour/hunger/thirst bars
  showProfileCard: boolean; // show the player profile card (left column)
  showItemNames: boolean; // always show item names (no hover needed)
  showClock: boolean; // top-nav clock
  showTemp: boolean; // top-nav temperature
  showLocation: boolean; // top-nav location
  showEscHint: boolean; // bottom-right ESC · Fechar hint
  gridSpatial: boolean; // Tarkov grid — items span cells according to their size
  rarityColors: boolean; // tint each filled slot by the item's rarity
}

/** A theme pushed by an admin. `locked` means players cannot override it. */
export interface GlobalTheme {
  settings: Partial<VisualSettings>;
  locked: boolean;
}

export interface SettingsState extends VisualSettings {
  /** id of the active template, or `custom` once any single knob is touched. */
  template: string;
  /** Player holds the `ox_inventory.admin` ace (told by the server). */
  isAdmin: boolean;
  /** Admin is broadcasting: every change they make is pushed to every player. */
  adminMode: boolean;
  /** Admin's intent for the lock flag of the theme they broadcast. */
  adminLock: boolean;
  /** The locked server-wide theme currently in force, if any. */
  enforced: GlobalTheme | null;
}

export const VISUAL_KEYS: (keyof VisualSettings)[] = [
  'themeColor',
  'bgColor',
  'bgOpacity',
  'slotShape',
  'titleShape',
  'uiSize',
  'showWeight',
  'showStats',
  'showProfileCard',
  'showItemNames',
  'showClock',
  'showTemp',
  'showLocation',
  'showEscHint',
  'gridSpatial',
  'rarityColors',
];

/** Strips the runtime-only fields — what we persist and what we send to the server. */
export const pickVisual = (state: VisualSettings): VisualSettings =>
  VISUAL_KEYS.reduce((acc, key) => {
    (acc as any)[key] = state[key];
    return acc;
  }, {} as VisualSettings);

export const THEME_PRESETS: { label: string; value: string }[] = [
  { label: 'Volt', value: '#c8ff00' },
  { label: 'Apex Blue', value: '#1f5eff' },
  { label: 'Sky', value: '#0ea5e9' },
  { label: 'Cyan', value: '#22d3ee' },
  { label: 'Emerald', value: '#22c55e' },
  { label: 'Violet', value: '#8b5cf6' },
  { label: 'Pink', value: '#ec4899' },
  { label: 'Amber', value: '#f59e0b' },
  { label: 'Red', value: '#ef4444' },
];

// Predefined background bases (dark neutrals + subtle tints) — custom still available.
// `label` is the English fallback; `labelKey` is looked up in the locale file at
// render time (these consts are built at import, before the locale is fetched).
export const BG_PRESETS: { label: string; labelKey: string; value: string }[] = [
  { label: 'Volt Black', labelKey: 'ui_bg_volt', value: '#070808' },
  { label: 'Black', labelKey: 'ui_bg_black', value: '#0a0a0b' },
  { label: 'Charcoal', labelKey: 'ui_bg_charcoal', value: '#121316' },
  { label: 'Graphite', labelKey: 'ui_bg_graphite', value: '#16181d' },
  { label: 'Midnight', labelKey: 'ui_bg_midnight', value: '#0a111f' },
  { label: 'Emerald', labelKey: 'ui_bg_emerald', value: '#0a1410' },
  { label: 'Wine', labelKey: 'ui_bg_wine', value: '#170b0e' },
  { label: 'Violet', labelKey: 'ui_bg_violet', value: '#120b1a' },
];

export interface InventoryTemplate {
  id: string;
  label: string;
  /** English fallback for the description; `descKey` wins when localised. */
  desc: string;
  descKey: string;
  values: VisualSettings;
}

// Each template is a *complete* visual state, so switching between them is
// deterministic (no leftovers from the previous look). They intentionally pull
// every knob — colour, opacity, geometry, scale and chrome — so each reads as a
// genuinely different inventory rather than a recolour.
export const TEMPLATES: InventoryTemplate[] = [
  {
    id: 'volt',
    label: 'Volt Circuit',
    desc: 'Volt on near-black · flat editorial · the default',
    descKey: 'ui_tpl_volt',
    values: {
      themeColor: '#c8ff00',
      bgColor: '#070808',
      bgOpacity: 92,
      slotShape: 'square',
      titleShape: 'square',
      uiSize: 'medium',
      showWeight: true,
      showStats: true,
      showProfileCard: true,
      showItemNames: false,
      showClock: true,
      showTemp: true,
      showLocation: true,
      showEscHint: true,
      gridSpatial: false,
      rarityColors: false,
    },
  },
  {
    id: 'apex',
    label: 'Apex',
    desc: 'Floating blue glass',
    descKey: 'ui_tpl_apex',
    values: {
      themeColor: '#3b82f6',
      bgColor: '#0a0a0b',
      bgOpacity: 20,
      slotShape: 'rounded',
      titleShape: 'rounded',
      uiSize: 'medium',
      showWeight: true,
      showStats: true,
      showProfileCard: true,
      showItemNames: false,
      showClock: true,
      showTemp: true,
      showLocation: true,
      showEscHint: true,
      gridSpatial: false,
      rarityColors: false,
    },
  },
  {
    id: 'arctic',
    label: 'Arctic',
    desc: 'Near-transparent frosted glass · large',
    descKey: 'ui_tpl_arctic',
    values: {
      themeColor: '#22d3ee',
      bgColor: '#0a111f',
      bgOpacity: 20,
      slotShape: 'rounded',
      titleShape: 'circle',
      uiSize: 'large',
      showWeight: false,
      showStats: true,
      showProfileCard: true,
      showItemNames: true,
      showClock: true,
      showTemp: true,
      showLocation: true,
      showEscHint: true,
      gridSpatial: false,
      rarityColors: false,
    },
  },
  {
    id: 'neon',
    label: 'Neon',
    desc: 'Purple/pink hexagons · city at night',
    descKey: 'ui_tpl_neon',
    values: {
      themeColor: '#ec4899',
      bgColor: '#120b1a',
      bgOpacity: 42,
      slotShape: 'rounded',
      titleShape: 'hexagon',
      uiSize: 'large',
      showWeight: true,
      showStats: true,
      showProfileCard: true,
      showItemNames: false,
      showClock: true,
      showTemp: true,
      showLocation: true,
      showEscHint: true,
      gridSpatial: false,
      rarityColors: true,
    },
  },
  {
    id: 'emerald',
    label: 'Emerald',
    desc: 'Tactical green · diamonds',
    descKey: 'ui_tpl_emerald',
    values: {
      themeColor: '#22c55e',
      bgColor: '#0a1410',
      bgOpacity: 70,
      slotShape: 'rounded',
      titleShape: 'diamond',
      uiSize: 'medium',
      showWeight: true,
      showStats: true,
      showProfileCard: true,
      showItemNames: false,
      showClock: true,
      showTemp: true,
      showLocation: false,
      showEscHint: true,
      gridSpatial: false,
      rarityColors: false,
    },
  },
  {
    id: 'bloodline',
    label: 'Bloodline',
    desc: 'Heavy red · no HUD clutter',
    descKey: 'ui_tpl_bloodline',
    values: {
      themeColor: '#ef4444',
      bgColor: '#170b0e',
      bgOpacity: 88,
      slotShape: 'square',
      titleShape: 'hexagon',
      uiSize: 'medium',
      showWeight: true,
      showStats: true,
      showProfileCard: true,
      showItemNames: false,
      showClock: false,
      showTemp: false,
      showLocation: true,
      showEscHint: false,
      gridSpatial: false,
      rarityColors: true,
    },
  },
  {
    id: 'amber',
    label: 'Amber Command',
    desc: 'Compact amber · ops terminal',
    descKey: 'ui_tpl_amber',
    values: {
      themeColor: '#f59e0b',
      bgColor: '#121316',
      bgOpacity: 62,
      slotShape: 'square',
      titleShape: 'circle',
      uiSize: 'small',
      showWeight: true,
      showStats: true,
      showProfileCard: false,
      showItemNames: true,
      showClock: true,
      showTemp: true,
      showLocation: true,
      showEscHint: true,
      gridSpatial: false,
      rarityColors: false,
    },
  },
  {
    id: 'blackout',
    label: 'Blackout',
    desc: 'Opaque minimal black · just the grid',
    descKey: 'ui_tpl_blackout',
    values: {
      themeColor: '#e4e4e7',
      bgColor: '#000000',
      bgOpacity: 100,
      slotShape: 'square',
      titleShape: 'square',
      uiSize: 'small',
      showWeight: false,
      showStats: false,
      showProfileCard: false,
      showItemNames: false,
      showClock: false,
      showTemp: false,
      showLocation: false,
      showEscHint: false,
      gridSpatial: false,
      rarityColors: false,
    },
  },
];

export const CUSTOM_TEMPLATE = 'custom';

/** Returns the id of the template that exactly matches `state`, else `custom`. */
export const matchTemplate = (state: VisualSettings): string => {
  const found = TEMPLATES.find((tpl) => VISUAL_KEYS.every((key) => tpl.values[key] === state[key]));
  return found ? found.id : CUSTOM_TEMPLATE;
};

const defaultVisual: VisualSettings = TEMPLATES[0].values;

const defaultState: SettingsState = {
  ...defaultVisual,
  template: TEMPLATES[0].id,
  isAdmin: false,
  adminMode: false,
  adminLock: false,
  enforced: null,
};

// Bumped suffix so every client adopts the new Apex blue defaults instead of an
// old persisted theme.
const STORAGE_KEY = 'ox_inventory_settings_aaa_v4';

// Runtime-only fields never come from localStorage — the server re-tells us the
// admin flag and the live theme on every UI load.
const runtimeDefaults = () => ({ isAdmin: false, adminMode: false, adminLock: false, enforced: null });

const loadSettings = (): SettingsState => {
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return defaultState;
    const merged: SettingsState = { ...defaultState, ...JSON.parse(raw), ...runtimeDefaults() };
    // The Tarkov theme (multi-cell spatial grid) was removed. Anyone still on it
    // — or with the spatial grid switched on in a custom theme — is migrated to
    // the normal Apex look. Everyone else keeps their own colours/layout.
    if ((merged as any).gridSpatial || merged.template === 'tarkov') {
      Object.assign(merged, defaultVisual);
    }
    (merged as any).gridSpatial = false;
    merged.template = matchTemplate(merged);
    return merged;
  } catch {
    return defaultState;
  }
};

const persist = (state: SettingsState) => {
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify({ ...pickVisual(state), template: state.template }));
  } catch {
    // ignore (e.g. storage disabled)
  }
};

/** Applies a single-knob change: the active template no longer matches exactly. */
const touched = (state: SettingsState) => {
  state.template = matchTemplate(state);
  persist(state);
};

export const settingsSlice = createSlice({
  name: 'settings',
  initialState: loadSettings(),
  reducers: {
    setThemeColor(state, action: PayloadAction<string>) {
      state.themeColor = action.payload;
      touched(state);
    },
    setBgColor(state, action: PayloadAction<string>) {
      state.bgColor = action.payload;
      touched(state);
    },
    setBgOpacity(state, action: PayloadAction<number>) {
      state.bgOpacity = action.payload;
      touched(state);
    },
    setSlotShape(state, action: PayloadAction<SlotShape>) {
      state.slotShape = action.payload;
      touched(state);
    },
    setTitleShape(state, action: PayloadAction<TitleShape>) {
      state.titleShape = action.payload;
      touched(state);
    },
    setUiSize(state, action: PayloadAction<UiSize>) {
      state.uiSize = action.payload;
      touched(state);
    },
    setShowWeight(state, action: PayloadAction<boolean>) {
      state.showWeight = action.payload;
      touched(state);
    },
    setShowStats(state, action: PayloadAction<boolean>) {
      state.showStats = action.payload;
      touched(state);
    },
    setShowProfileCard(state, action: PayloadAction<boolean>) {
      state.showProfileCard = action.payload;
      touched(state);
    },
    setShowItemNames(state, action: PayloadAction<boolean>) {
      state.showItemNames = action.payload;
      touched(state);
    },
    setShowClock(state, action: PayloadAction<boolean>) {
      state.showClock = action.payload;
      touched(state);
    },
    setShowTemp(state, action: PayloadAction<boolean>) {
      state.showTemp = action.payload;
      touched(state);
    },
    setShowLocation(state, action: PayloadAction<boolean>) {
      state.showLocation = action.payload;
      touched(state);
    },
    setShowEscHint(state, action: PayloadAction<boolean>) {
      state.showEscHint = action.payload;
      touched(state);
    },
    setGridSpatial(state, action: PayloadAction<boolean>) {
      state.gridSpatial = action.payload;
      touched(state);
    },
    setRarityColors(state, action: PayloadAction<boolean>) {
      state.rarityColors = action.payload;
      touched(state);
    },

    /** Applies a whole template in one go. */
    applyTemplate(state, action: PayloadAction<string>) {
      const tpl = TEMPLATES.find((t) => t.id === action.payload);
      if (!tpl) return;
      Object.assign(state, tpl.values);
      state.template = tpl.id;
      persist(state);
    },

    resetSettings(state) {
      const next: SettingsState = {
        ...defaultState,
        isAdmin: state.isAdmin,
        adminMode: state.adminMode,
        adminLock: state.adminLock,
        enforced: state.enforced,
      };
      persist(next);
      return next;
    },

    // ── Admin / server-wide theme ────────────────────────────────

    /** Told by the server on UI load. */
    setIsAdmin(state, action: PayloadAction<boolean>) {
      state.isAdmin = action.payload;
      if (!action.payload) state.adminMode = false;
    },

    setAdminMode(state, action: PayloadAction<boolean>) {
      if (!state.isAdmin) return;
      state.adminMode = action.payload;

      // Entering admin mode: start editing from whatever the server currently
      // enforces, so the admin never silently reverts the live theme.
      if (action.payload && state.enforced) {
        Object.assign(state, state.enforced.settings);
        state.template = matchTemplate(state);
      }
    },

    setAdminLock(state, action: PayloadAction<boolean>) {
      if (!state.isAdmin) return;
      state.adminLock = action.payload;
    },

    /**
     * A theme arrived from the server (initial load, live admin edit, or clear).
     *
     * - `locked` → kept aside in `enforced` and merged on read, so the player's
     *   own settings survive untouched underneath and come back if it's lifted.
     * - unlocked → merged into (and persisted as) the player's own settings, who
     *   may then change anything they like.
     */
    receiveGlobalTheme(state, action: PayloadAction<GlobalTheme | null>) {
      const theme = action.payload;

      if (!theme) {
        state.enforced = null;
        return;
      }

      if (theme.locked) {
        state.enforced = theme;
        state.adminLock = state.isAdmin ? true : state.adminLock;
        return;
      }

      state.enforced = null;
      // Admins driving the broadcast already hold these values locally.
      if (!state.adminMode) {
        Object.assign(state, theme.settings);
        state.template = matchTemplate(state);
        persist(state);
      }
    },
  },
});

export const {
  setThemeColor,
  setBgColor,
  setBgOpacity,
  setSlotShape,
  setTitleShape,
  setUiSize,
  setShowWeight,
  setShowStats,
  setShowProfileCard,
  setShowItemNames,
  setShowClock,
  setShowTemp,
  setShowLocation,
  setShowEscHint,
  setGridSpatial,
  setRarityColors,
  applyTemplate,
  resetSettings,
  setIsAdmin,
  setAdminMode,
  setAdminLock,
  receiveGlobalTheme,
} = settingsSlice.actions;

/** Raw slice — admin flags, the enforced theme, the player's own preferences. */
export const selectRawSettings = (state: RootState) => state.settings;

/**
 * What the UI actually renders with. A locked server theme wins over the
 * player's preferences — except for an admin who is actively broadcasting, who
 * needs to see their own edits live.
 */
export const selectSettings = createSelector([selectRawSettings], (state): SettingsState => {
  if (!state.enforced?.locked || state.adminMode) return state;
  return { ...state, ...state.enforced.settings };
});

/** True when the player may not change the look (a locked theme is in force). */
export const selectReadOnly = createSelector(
  [selectRawSettings],
  (state) => !!state.enforced?.locked && !state.adminMode
);

export default settingsSlice.reducer;
