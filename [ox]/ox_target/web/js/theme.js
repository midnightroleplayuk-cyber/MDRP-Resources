// Volt Circuit theme engine — resolves a small settings object into CSS vars
// and body flags so the whole UI re-skins live (personal or admin-forced).

export const DEFAULT_THEME = {
  brand: '#C8FF00',
  bg: '#0C0D0E',
  text: '#F2F4EE',
  alpha: 0.94, // card opacity 0-1
  radius: 2, // px
  notch: 7, // px, 0 disables the 45° cut
  reticle: 'eye', // eye (default — Gonçalo prefere o olho, não mira) | ticks | dot | ring | square
  scale: 1, // reticle scale
  anim: 'cascade', // cascade | sweep | scale | fade | none
  speed: 1, // animation speed multiplier
  offsetX: 24, // options offset from center (pt)
  monoLabels: false,
  showIndex: true,
};

export const PRESETS = [
  { id: 'volt', label: 'Volt', brand: '#C8FF00', bg: '#0C0D0E' },
  { id: 'crimson', label: 'Crimson', brand: '#FF2E4D', bg: '#0E0A0B' },
  { id: 'ember', label: 'Ember', brand: '#FF6B1A', bg: '#0E0B0A' },
  { id: 'cyan', label: 'Cyan', brand: '#22D3EE', bg: '#0A0D0E' },
  { id: 'arctic', label: 'Arctic', brand: '#38BDF8', bg: '#0A0C0E' },
  { id: 'emerald', label: 'Emerald', brand: '#22C55E', bg: '#0A0E0B' },
  { id: 'magenta', label: 'Magenta', brand: '#FF2ECC', bg: '#0E0A0D' },
  { id: 'gold', label: 'Gold', brand: '#FFB020', bg: '#0E0C0A' },
  { id: 'mono', label: 'Mono', brand: '#F2F4EE', bg: '#0C0D0E' },
  { id: 'violet', label: 'Violet', brand: '#9D6BFF', bg: '#0C0A0E' },
];

const RETICLES = ['ticks', 'dot', 'ring', 'square', 'eye'];
const ANIMS = ['cascade', 'sweep', 'scale', 'fade', 'none'];

export const hexToRgb = (hex) => {
  const clean = (hex || '').replace('#', '');
  const full = clean.length === 3 ? clean.split('').map((c) => c + c).join('') : clean;
  const r = parseInt(full.substring(0, 2), 16) || 0;
  const g = parseInt(full.substring(2, 4), 16) || 0;
  const b = parseInt(full.substring(4, 6), 16) || 0;
  return [r, g, b];
};

const isHex = (v) => /^#[0-9a-fA-F]{6}$/.test(v || '');

const clamp = (v, min, max, fallback) => {
  const n = Number(v);
  if (Number.isNaN(n)) return fallback;
  return Math.min(max, Math.max(min, n));
};

// Merge + validate untrusted input (KVP / admin broadcast) into a safe theme.
export const sanitize = (partial) => {
  const s = { ...DEFAULT_THEME, ...(partial || {}) };
  if (!isHex(s.brand)) s.brand = DEFAULT_THEME.brand;
  if (!isHex(s.bg)) s.bg = DEFAULT_THEME.bg;
  if (!isHex(s.text)) s.text = DEFAULT_THEME.text;
  s.alpha = clamp(s.alpha, 0.3, 1, DEFAULT_THEME.alpha);
  s.radius = Math.round(clamp(s.radius, 0, 12, DEFAULT_THEME.radius));
  s.notch = Math.round(clamp(s.notch, 0, 14, DEFAULT_THEME.notch));
  s.scale = clamp(s.scale, 0.5, 1.8, DEFAULT_THEME.scale);
  s.speed = clamp(s.speed, 0.4, 2.2, DEFAULT_THEME.speed);
  s.offsetX = Math.round(clamp(s.offsetX, 8, 70, DEFAULT_THEME.offsetX));
  if (!RETICLES.includes(s.reticle)) s.reticle = DEFAULT_THEME.reticle;
  if (!ANIMS.includes(s.anim)) s.anim = DEFAULT_THEME.anim;
  s.monoLabels = !!s.monoLabels;
  s.showIndex = !!s.showIndex;
  return s;
};

export const applyTheme = (partial) => {
  const s = sanitize(partial);
  const root = document.documentElement;
  const [br, bg, bb] = hexToRgb(s.brand);
  const lum = (0.2126 * br + 0.7152 * bg + 0.0722 * bb) / 255;

  root.style.setProperty('--brand', s.brand);
  root.style.setProperty('--brand-rgb', `${br}, ${bg}, ${bb}`);
  // Ink over brand — never white on light accents (Volt rule).
  root.style.setProperty('--brand-ink', lum > 0.35 ? '#0a0c02' : '#ffffff');
  root.style.setProperty('--card-rgb', hexToRgb(s.bg).join(', '));
  root.style.setProperty('--card-alpha', s.alpha.toFixed(2));
  root.style.setProperty('--text-rgb', hexToRgb(s.text).join(', '));
  root.style.setProperty('--text-1', s.text);
  root.style.setProperty('--radius', `${s.radius}px`);
  root.style.setProperty('--notch', `${s.notch}px`);
  root.style.setProperty('--ret-scale', String(s.scale));
  root.style.setProperty('--anim-ms', `${Math.round(260 / s.speed)}ms`);
  root.style.setProperty('--anim-stagger', `${Math.round(45 / s.speed)}ms`);
  root.style.setProperty('--offset-x', `${s.offsetX}pt`);

  document.body.dataset.reticle = s.reticle;
  document.body.dataset.anim = s.anim;
  document.body.classList.toggle('mono-labels', s.monoLabels);
  document.body.classList.toggle('show-index', s.showIndex);

  return s;
};
