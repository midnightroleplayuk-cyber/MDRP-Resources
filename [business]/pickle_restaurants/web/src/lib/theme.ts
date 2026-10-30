// Per-restaurant theming. A restaurant's in-game config carries a tiny theme
// seed — { primary, mode, radius } — and the WHOLE palette is derived from it
// here: surfaces take the seed's hue in OKLCH (relative-color derivation),
// interaction washes and status colors are OKLab blends. The derivation runs in
// JS (not CSS color-mix/relative-color syntax) because FiveM's CEF predates
// both — every token is emitted as a plain "R G B" triplet custom property that
// index.css / Tailwind consume via rgb(var(--x) / alpha), which works on any
// Chromium. Every restaurant-scoped view payload (management, register,
// cooking, payconfirm) includes `theme`; App.tsx applies it on open and resets
// to the default when the view closes.

export type ThemeConfig = {
  primary?: string; // #rrggbb brand seed
  mode?: string; // "dark" (midnight) | "paper"
  radius?: string; // "sharp" | "soft" | "round"
};

export const DEFAULT_THEME: Required<ThemeConfig> = {
  primary: "#ff7a2e",
  mode: "dark",
  radius: "soft",
};

/** Curated seeds for the in-game theme editor (label shown on hover). */
export const THEME_PRESETS: { label: string; hex: string }[] = [
  { label: "Flame", hex: "#ff7a2e" },
  { label: "Ketchup", hex: "#e23d32" },
  { label: "Mustard", hex: "#e5a819" },
  { label: "Guacamole", hex: "#7bae3c" },
  { label: "Matcha", hex: "#3d9970" },
  { label: "Blue Raspberry", hex: "#3f8fe8" },
  { label: "Grape Soda", hex: "#8a63d2" },
  { label: "Bubblegum", hex: "#e9679b" },
  { label: "Espresso", hex: "#8a6248" },
  { label: "Charcoal", hex: "#8a8a8a" },
];

const HEX = /^#[0-9a-f]{6}$/i;
const MODES = new Set(["dark", "paper"]);
const RADII = new Set(["sharp", "soft", "round"]);

export function normalizeTheme(t?: ThemeConfig | null): Required<ThemeConfig> {
  return {
    primary: t?.primary && HEX.test(t.primary) ? t.primary.toLowerCase() : DEFAULT_THEME.primary,
    mode: t?.mode && MODES.has(t.mode) ? t.mode : DEFAULT_THEME.mode,
    radius: t?.radius && RADII.has(t.radius) ? t.radius : DEFAULT_THEME.radius,
  };
}

// ─── color math: sRGB ⇄ OKLab/OKLCH ──────────────────────────────────────────

type RGB = [number, number, number]; // 0..1, gamma-encoded
type Lab = [number, number, number];

const hexToRgb = (hex: string): RGB => [
  parseInt(hex.slice(1, 3), 16) / 255,
  parseInt(hex.slice(3, 5), 16) / 255,
  parseInt(hex.slice(5, 7), 16) / 255,
];
const lin = (c: number) => (c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4));
const unlin = (c: number) => (c <= 0.0031308 ? 12.92 * c : 1.055 * Math.pow(c, 1 / 2.4) - 0.055);

function rgbToOklab([r, g, b]: RGB): Lab {
  const lr = lin(r), lg = lin(g), lb = lin(b);
  const l = Math.cbrt(0.4122214708 * lr + 0.5363325363 * lg + 0.0514459929 * lb);
  const m = Math.cbrt(0.2119034982 * lr + 0.6806995451 * lg + 0.1073969566 * lb);
  const s = Math.cbrt(0.0883024619 * lr + 0.2817188376 * lg + 0.6299787005 * lb);
  return [
    0.2104542553 * l + 0.793617785 * m - 0.0040720468 * s,
    1.9779984951 * l - 2.428592205 * m + 0.4505937099 * s,
    0.0259040371 * l + 0.7827717662 * m - 0.808675766 * s,
  ];
}

function oklabToRgb([L, a, b]: Lab): RGB {
  const l = Math.pow(L + 0.3963377774 * a + 0.2158037573 * b, 3);
  const m = Math.pow(L - 0.1055613458 * a - 0.0638541728 * b, 3);
  const s = Math.pow(L - 0.0894841775 * a - 1.291485548 * b, 3);
  return [
    unlin(4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s),
    unlin(-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s),
    unlin(-0.0041960863 * l - 0.7034186147 * m + 1.707614701 * s),
  ];
}

const inGamut = (c: RGB) => c.every((v) => v >= -0.0001 && v <= 1.0001);

/** OKLCH → sRGB triplet string, desaturating toward the L axis until in gamut. */
function oklch(L: number, C: number, H: number): string {
  let c = C;
  let rgb = oklabToRgb([L, c * Math.cos(H), c * Math.sin(H)]);
  for (let i = 0; i < 12 && !inGamut(rgb); i++) {
    c *= 0.85;
    rgb = oklabToRgb([L, c * Math.cos(H), c * Math.sin(H)]);
  }
  return rgb.map((v) => Math.round(Math.min(Math.max(v, 0), 1) * 255)).join(" ");
}

/** Blend two gamma sRGB colors in OKLab (t = share of `a`), → triplet string. */
function mixLab(a: RGB, b: RGB, t: number): string {
  const la = rgbToOklab(a), lb = rgbToOklab(b);
  const out = oklabToRgb([
    la[0] * t + lb[0] * (1 - t),
    la[1] * t + lb[1] * (1 - t),
    la[2] * t + lb[2] * (1 - t),
  ]);
  return out.map((v) => Math.round(Math.min(Math.max(v, 0), 1) * 255)).join(" ");
}

const tripletToRgb = (s: string): RGB => s.split(" ").map((v) => Number(v) / 255) as RGB;

// ─── the palette ─────────────────────────────────────────────────────────────

// Per-mode dials: lightness for each surface + how much seed chroma bleeds in.
const DIALS = {
  dark: { bg: 0.17, card: 0.215, card2: 0.265, line: 0.335, ink: 0.965, mute: 0.72, tint: 0.16 },
  paper: { bg: 0.93, card: 0.975, card2: 0.885, line: 0.8, ink: 0.24, mute: 0.5, tint: 0.09 },
};

export function applyTheme(t?: ThemeConfig | null) {
  const cfg = normalizeTheme(t);
  const root = document.documentElement;
  const seed = hexToRgb(cfg.primary);
  const [sl, sa, sb] = rgbToOklab(seed);
  const C = Math.sqrt(sa * sa + sb * sb);
  const H = Math.atan2(sb, sa);
  const d = DIALS[cfg.mode as "dark" | "paper"] ?? DIALS.dark;

  const set = (k: string, v: string) => root.style.setProperty(k, v);
  const brand = seed.map((v) => Math.round(v * 255)).join(" ");

  // surfaces borrow the seed's hue — the relative-color derivation, in JS
  const bg = oklch(d.bg, C * d.tint, H);
  const card = oklch(d.card, C * d.tint, H);
  const card2 = oklch(d.card2, C * d.tint * 1.1, H);
  const ink = oklch(d.ink, C * 0.04, H);
  set("--brand", brand);
  set("--bg", bg);
  set("--card", card);
  set("--card-2", card2);
  set("--line", oklch(d.line, C * d.tint * 1.5, H));
  set("--ink", ink);
  set("--ink-mute", oklch(d.mute, C * 0.09, H));

  // blends: sunken wells, the brand hover wash, brand-nudged status colors
  set("--sunk", mixLab(tripletToRgb(bg), tripletToRgb(card), 0.62));
  set("--wash", mixLab(seed, tripletToRgb(card2), 0.11));
  set("--ok", mixLab(hexToRgb("#45a563"), seed, 0.88));
  set("--warn", mixLab(hexToRgb("#d9962b"), seed, 0.86));
  const danger = mixLab(hexToRgb("#e0433f"), seed, 0.9);
  set("--danger", danger);

  // thermal-receipt paper: always light, faintly brand-tinted, in BOTH modes
  const paper = mixLab(seed, hexToRgb("#f8f4ec"), 0.05);
  set("--paper", paper);
  set("--paper-ink", "42 33 22");
  set("--paper-mute", mixLab(hexToRgb("#2a2116"), tripletToRgb(paper), 0.52));

  // text on brand: 0.25 rather than the naive 0.5 — mid-luminance seeds
  // (oranges, teals) get far better contrast from a dark ink than from white
  const lum = 0.2126 * lin(seed[0]) + 0.7152 * lin(seed[1]) + 0.0722 * lin(seed[2]);
  set(
    "--brand-ink",
    lum > 0.25 ? mixLab(seed, hexToRgb("#160d05"), 0.28) : mixLab(seed, hexToRgb("#ffffff"), 0.1)
  );

  // interaction states: the brand pressed toward the ink
  const inkRgb = tripletToRgb(ink);
  set("--brand-hover", mixLab(seed, inkRgb, 0.86));
  set("--brand-active", mixLab(seed, inkRgb, 0.78));
  set("--danger-hover", mixLab(tripletToRgb(danger), inkRgb, 0.85));

  root.dataset.mode = cfg.mode;
  root.dataset.radius = cfg.radius;
}
