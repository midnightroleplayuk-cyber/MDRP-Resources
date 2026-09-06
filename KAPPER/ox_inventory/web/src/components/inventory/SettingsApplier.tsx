import { useEffect } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import {
  GlobalTheme,
  receiveGlobalTheme,
  selectSettings,
  setIsAdmin,
  SlotShape,
  TitleShape,
  UI_SIZE_SCALE,
} from '../../store/settings';
import useNuiEvent from '../../hooks/useNuiEvent';

/**
 * Payload of the `uiTheme` NUI message (modules/uitheme/client.lua).
 *  • on UI load  → { isAdmin, theme: GlobalTheme | false }
 *  • admin push  → { settings, locked }
 *  • admin clear → { cleared: true }
 */
interface UiThemeMessage extends Partial<GlobalTheme> {
  isAdmin?: boolean;
  theme?: GlobalTheme | false;
  cleared?: boolean;
}

const hexToRgb = (hex: string): string => {
  const clean = hex.replace('#', '');
  const full =
    clean.length === 3
      ? clean
          .split('')
          .map((c) => c + c)
          .join('')
      : clean;
  const r = parseInt(full.substring(0, 2), 16) || 0;
  const g = parseInt(full.substring(2, 4), 16) || 0;
  const b = parseInt(full.substring(4, 6), 16) || 0;
  return `${r}, ${g}, ${b}`;
};

const darken = (hex: string, amount = 0.18): string => {
  const [r, g, b] = hexToRgb(hex)
    .split(', ')
    .map((n) => parseInt(n, 10));
  const d = (c: number) => Math.max(0, Math.round(c * (1 - amount)));
  return `rgb(${d(r)}, ${d(g)}, ${d(b)})`;
};

// Raised panels (player card, top nav, action bar, status…) sit a touch lighter
// than the background so they read as glass. Returns an "r, g, b" string for use
// inside rgba(var(--panel-rgb), …).
const lightenRgb = (hex: string, amount = 12): string => {
  const [r, g, b] = hexToRgb(hex)
    .split(', ')
    .map((n) => parseInt(n, 10));
  const l = (c: number) => Math.min(255, c + amount);
  return `${l(r)}, ${l(g)}, ${l(b)}`;
};

// Volt Circuit is sharp: "rounded" tops out at the design system's radius-lg.
const SLOT_RADIUS: Record<SlotShape, string> = {
  rounded: '4px',
  square: '2px',
};

// Title badge: radius + optional clip-path for polygonal shapes.
const TITLE_RADIUS: Record<TitleShape, string> = {
  rounded: '4px',
  square: '3px',
  circle: '50%',
  hexagon: '0px',
  diamond: '0px',
};

const HEXAGON = 'polygon(25% 5%, 75% 5%, 100% 50%, 75% 95%, 25% 95%, 0% 50%)';
const DIAMOND = 'polygon(50% 0%, 100% 50%, 50% 100%, 0% 50%)';

const TITLE_CLIP: Record<TitleShape, string> = {
  rounded: 'none',
  square: 'none',
  circle: 'none',
  hexagon: HEXAGON,
  diamond: DIAMOND,
};

// Reads the settings store and pushes the values into CSS custom properties +
// body classes so the whole UI re-themes instantly.
const SettingsApplier: React.FC = () => {
  const settings = useAppSelector(selectSettings);
  const dispatch = useAppDispatch();

  useNuiEvent<UiThemeMessage>('uiTheme', (data) => {
    if (!data) return;

    if (typeof data.isAdmin === 'boolean') dispatch(setIsAdmin(data.isAdmin));

    if (data.cleared) return void dispatch(receiveGlobalTheme(null));

    // Initial load carries the stored theme under `theme` (false when none).
    if ('theme' in data) return void dispatch(receiveGlobalTheme(data.theme || null));

    if (data.settings) dispatch(receiveGlobalTheme({ settings: data.settings, locked: !!data.locked }));
  });

  useEffect(() => {
    const root = document.documentElement;
    root.style.setProperty('--brand', settings.themeColor);
    root.style.setProperty('--brand-dark', darken(settings.themeColor));
    root.style.setProperty('--brand-rgb', hexToRgb(settings.themeColor));
    // Ink over brand: near-black on light accents (volt rule — never white),
    // white only when the accent itself is dark.
    const [br, bg2, bb] = hexToRgb(settings.themeColor)
      .split(', ')
      .map((n) => parseInt(n, 10));
    const brandLum = (0.2126 * br + 0.7152 * bg2 + 0.0722 * bb) / 255;
    root.style.setProperty('--brand-ink', brandLum > 0.35 ? '#0a0c02' : '#ffffff');
    root.style.setProperty('--bg-rgb', hexToRgb(settings.bgColor));
    const op = settings.bgOpacity / 100;
    root.style.setProperty('--bg-opacity', op.toFixed(3));
    // Pre-computed (no calc() inside rgba, which some CEF builds mishandle).
    root.style.setProperty('--slot-opacity', Math.min(1, op + 0.06).toFixed(3));
    // Raised panels: colour + opacity. Opacity follows the slider (offset so panels
    // stay a little more solid than the bg) → the whole UI fades together.
    root.style.setProperty('--panel-rgb', lightenRgb(settings.bgColor, 12));
    root.style.setProperty('--panel-opacity', Math.min(1, op + 0.3).toFixed(3));
    root.style.setProperty('--slot-radius', SLOT_RADIUS[settings.slotShape]);
    root.style.setProperty('--title-radius', TITLE_RADIUS[settings.titleShape]);
    root.style.setProperty('--title-clip', TITLE_CLIP[settings.titleShape]);
    root.style.setProperty('--ui-scale', String(UI_SIZE_SCALE[settings.uiSize]));
    // Cursor is always the default light arrow (custom tint removed).
    const cursorColor = '#f4f4f5';
    root.style.setProperty('--cursor-color', cursorColor);
    const svg = encodeURIComponent(
      `<svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 26 26"><path d="M4 2 L4 21 L9 16.5 L12.2 23.5 L15.2 22 L12 15 L18.5 15 Z" fill="${cursorColor}" stroke="#0a0a0b" stroke-width="1.2" stroke-linejoin="round"/></svg>`
    )
      .replace(/'/g, '%27')
      .replace(/"/g, '%22');
    root.style.setProperty('--cursor-arrow', `url("data:image/svg+xml,${svg}") 3 2, auto`);

    // Visibility toggles (weight + player stats + always-on item names)
    root.classList.toggle('hide-weight', !settings.showWeight);
    root.classList.toggle('hide-stats', !settings.showStats);
    root.classList.toggle('show-item-names', settings.showItemNames);
  }, [
    settings.themeColor,
    settings.bgColor,
    settings.bgOpacity,
    settings.slotShape,
    settings.titleShape,
    settings.uiSize,
    settings.showWeight,
    settings.showStats,
    settings.showItemNames,
  ]);

  return null;
};

export default SettingsApplier;
