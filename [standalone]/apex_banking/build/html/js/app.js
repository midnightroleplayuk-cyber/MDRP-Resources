/* ============================================================
   Apex Banking — NUI app
   ============================================================ */
(() => {
'use strict';

const RES = (typeof GetParentResourceName === 'function')
    ? GetParentResourceName() : 'apex_banking';

const $  = (sel, root = document) => root.querySelector(sel);
const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));
const on = (el, ev, cb, opts) => el && el.addEventListener(ev, cb, opts);

const post = (name, data = {}) =>
    fetch(`https://${RES}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    }).then(r => r.json()).catch(() => ({}));

// Fire-and-forget sound trigger that routes through the Lua
// `play_sound` NUI callback into PlaySoundFrontend.
const Sound = (alias) => post('play_sound', { alias });

// `mutate` wraps post() with a guaranteed force-refresh after
// the server replies. Every banking operation that changes
// money/state on the server should go through this so the UI
// repaints even when the broadcast event is delayed.
async function mutate(name, payload) {
    const r = await post(name, payload);
    await post('bank_force_refresh');
    return r;
}

// ─── Runtime config (filled by Lua "bootstrap") ────────
const Runtime = {
    theme: {},
    currency: { symbol: '$', position: 'before' },
    iban: { groupBy: 4, prefix: 'AP' },
    pin: { length: 4 },
    fees: {}, limits: {}, savings: {}, loans: {}, subAccounts: {},
    locale: {},
};

// ─── i18n ──────────────────────────────────────────────
// Tiny translator over the active language table that Lua pushes
// on bootstrap (English base merged with the configured
// Config.locale, so any missing key falls back to English).
//   t('key')           → translated string (or the key if absent)
//   t('key', a, b, …)  → same, with each %s replaced in order
const t = (key, ...args) => {
    let s = (Runtime.locale && Runtime.locale[key]);
    if (s == null) s = key;
    if (args.length) {
        let i = 0;
        s = String(s).replace(/%s/g, () => (i < args.length ? String(args[i++]) : '%s'));
    }
    return s;
};

// ─── Formatters ───────────────────────────────────────
const fmtMoney = (n) => {
    n = Math.floor(Number(n) || 0);
    const neg = n < 0; n = Math.abs(n);
    const s = n.toLocaleString('en-US');
    const cur = Runtime.currency || { symbol: '$', position: 'before' };
    return (neg ? '-' : '') + (cur.position === 'after' ? `${s} ${cur.symbol}` : `${cur.symbol}${s}`);
};
const fmtIban = (i) => {
    if (!i) return '';
    const gb = (Runtime.iban && Runtime.iban.groupBy) || 4;
    // Chunk the WHOLE string (letters included) so the result matches
    // the server's pretty format everywhere: AP24 8810 4471 092.
    // (The old version split the 2-letter prefix off first, producing
    // a second, conflicting grouping in dropdowns/recipients.)
    const raw = String(i).replace(/\s+/g, '');
    const parts = [];
    for (let p = 0; p < raw.length; p += gb) parts.push(raw.slice(p, p + gb));
    return parts.join(' ');
};
const fmtDate = (ts) => {
    if (!ts) return '—';
    const d = new Date(ts * 1000);
    const pad = (x) => String(x).padStart(2, '0');
    return `${pad(d.getDate())}/${pad(d.getMonth() + 1)} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
};

// ── Count-up money displays ─────────────────────────────
// Tweens a money element toward its new value (premium feel on
// open and after deposits/transfers). Masked (privacy) values are
// written directly. First paint counts up from $0 — the reveal
// runs right after the loader clears, so it reads as intentional.
function animateMoney(el, target, masked, maskStr) {
    if (!el) return;
    if (masked) { delete el.dataset.cv; el.textContent = maskStr || '••••'; return; }
    target = Math.floor(Number(target) || 0);
    let from = Number(el.dataset.cv);
    if (!Number.isFinite(from)) from = 0;
    el.dataset.cv = String(target);
    if (from === target) { el.textContent = fmtMoney(target); return; }
    if (el._cntRaf) cancelAnimationFrame(el._cntRaf);
    const t0 = performance.now(), dur = 700;
    const ease = (x) => 1 - Math.pow(1 - x, 3);
    const step = (now) => {
        const p = Math.min(1, (now - t0) / dur);
        el.textContent = fmtMoney(from + (target - from) * ease(p));
        if (p < 1) el._cntRaf = requestAnimationFrame(step);
        else delete el._cntRaf;
    };
    el._cntRaf = requestAnimationFrame(step);
}

// ── Brand colour helpers (module-level so applyTheme can use
//    them on bootstrap, before the Bank module finishes loading) ──
const esc = (s) => String(s ?? '').replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
})[c]);

function _hexToRgb(hex) {
    const h = (hex || '').replace('#', '');
    const n = h.length === 3 ? h.split('').map(c => c + c).join('') : h;
    return {
        r: parseInt(n.slice(0, 2), 16) || 0,
        g: parseInt(n.slice(2, 4), 16) || 0,
        b: parseInt(n.slice(4, 6), 16) || 0,
    };
}
function _rgbToHsl({ r, g, b }) {
    r/=255; g/=255; b/=255;
    const mx = Math.max(r,g,b), mn = Math.min(r,g,b);
    let h, s, l = (mx + mn) / 2;
    if (mx === mn) { h = s = 0 }
    else {
        const d = mx - mn;
        s = l > .5 ? d / (2 - mx - mn) : d / (mx + mn);
        switch (mx) {
            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
            case g: h = (b - r) / d + 2; break;
            case b: h = (r - g) / d + 4; break;
        }
        h /= 6;
    }
    return { h: h * 360, s: s * 100, l: l * 100 };
}
function _hslToHex(h, s, l) {
    h /= 360; s /= 100; l /= 100;
    const hue2rgb = (p, q, t) => {
        if (t < 0) t += 1; if (t > 1) t -= 1;
        if (t < 1/6) return p + (q - p) * 6 * t;
        if (t < 1/2) return q;
        if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
        return p;
    };
    let r, g, b;
    if (s === 0) { r = g = b = l }
    else {
        const q = l < .5 ? l * (1 + s) : l + s - l * s;
        const p = 2 * l - q;
        r = hue2rgb(p, q, h + 1/3);
        g = hue2rgb(p, q, h);
        b = hue2rgb(p, q, h - 1/3);
    }
    const to = (x) => Math.round(x * 255).toString(16).padStart(2, '0');
    return '#' + to(r) + to(g) + to(b);
}
function _hexToRgba(hex, a) {
    const { r, g, b } = _hexToRgb(hex);
    return `rgba(${r},${g},${b},${a})`;
}

// Single source of truth for re-tinting the whole brand ramp.
// Called by applyTheme on bootstrap AND by the Settings picker so
// the entire UI follows the chosen colour from the first paint.
function applyBrandRamp(hex) {
    if (!hex) return;
    const root = document.documentElement.style;
    const { h, s } = _rgbToHsl(_hexToRgb(hex));
    const ramp = {
        50: 96, 100: 92, 200: 84, 300: 75, 400: 65,
        500: null, 600: 47, 700: 38, 800: 30, 900: 22,
    };
    Object.entries(ramp).forEach(([step, l]) => {
        const v = l == null ? hex : _hslToHex(h, s, l);
        root.setProperty(`--brand-${step}`, v);
    });
    [['a05', .05], ['a08', .08], ['a12', .12],
     ['a18', .18], ['a25', .25], ['a40', .40]]
    .forEach(([k, a]) => root.setProperty(`--brand-${k}`, _hexToRgba(hex, a)));
}

// Re-tint the surface/line ramp from a chosen background base hex.
// The layered dark look is preserved via FIXED lightness deltas
// (so the UI stays readable for any pick) while the hue/saturation
// follow the chosen colour. Base #131314 reproduces the default
// neutral ramp exactly. Called on load (saved pref) and live from
// the Settings background picker.
// Surfaces, lines and text derived from one background colour. `mode`
// picks the direction: dark (the stock look — surfaces rise from a near
// black base) or light (a bright page, cards brighter still, dark type).
const DARK_TEXT = { 1: '#F4F4F5', 2: '#A8A8AD', 3: '#7C7C82', 4: '#565659' };
function applyBackgroundRamp(hex, mode) {
    if (!hex) return;
    const root = document.documentElement.style;
    const { h, s, l } = _rgbToHsl(_hexToRgb(hex));
    const clamp = (v, lo, hi) => Math.max(lo, Math.min(hi, v));
    const light = mode === 'light';
    document.documentElement.dataset.mode = light ? 'light' : 'dark';

    if (light) {
        const base = clamp(l, 90, 98);    // surface-1: the page, kept bright
        const sat  = Math.min(s, 40);
        const set = (name, dl) => root.setProperty(name, _hslToHex(h, sat, clamp(base + dl, 0, 100)));
        set('--surface-0', -4);  set('--surface-1', 0);   set('--surface-2', 2);
        set('--surface-3', -3);  set('--surface-4', -8);  set('--surface-5', -13);
        set('--line-1', -8);     set('--line-2', -13);    set('--line-3', -20);  set('--line-4', -30);
        root.setProperty('--text-1', _hslToHex(h, Math.min(s, 30), 10));
        root.setProperty('--text-2', _hslToHex(h, Math.min(s, 20), 32));
        root.setProperty('--text-3', _hslToHex(h, Math.min(s, 16), 46));
        root.setProperty('--text-4', _hslToHex(h, Math.min(s, 12), 60));
        root.setProperty('--lip', 'inset 0 1px 0 rgba(255,255,255,.75)');
        root.setProperty('--shadow-card', '0 1px 2px rgba(20,20,30,.06), 0 14px 34px -16px rgba(20,20,30,.18)');
        root.setProperty('--shadow-pop', '0 2px 8px rgba(20,20,30,.10), 0 30px 80px -20px rgba(20,20,30,.28)');
        return;
    }

    const base = clamp(l, 3.5, 12);   // surface-1 lightness, kept dark for contrast
    const sat  = Math.min(s, 50);     // avoid neon surfaces on vivid picks
    const set = (name, dl) => root.setProperty(name, _hslToHex(h, sat, clamp(base + dl, 0, 100)));
    set('--surface-0', -3.5); set('--surface-1', 0);   set('--surface-2', 3);
    set('--surface-3', 7);    set('--surface-4', 11);  set('--surface-5', 15);
    set('--line-1', 5);       set('--line-2', 9.5);    set('--line-3', 15.5); set('--line-4', 23);
    Object.keys(DARK_TEXT).forEach((k) => root.setProperty('--text-' + k, DARK_TEXT[k]));
    root.setProperty('--lip', 'inset 0 1px 0 rgba(255,255,255,.04)');
    root.setProperty('--shadow-card', '0 1px 2px rgba(0,0,0,.35), 0 14px 34px -16px rgba(0,0,0,.55)');
    root.setProperty('--shadow-pop', '0 2px 8px rgba(0,0,0,.4), 0 30px 80px -20px rgba(0,0,0,.75)');
}

// The player's own background lives in localStorage (per device). It can
// throw or come back empty in a private window, so every read is guarded.
function personalBg() {
    try { return (JSON.parse(localStorage.getItem('apex_banking_prefs') || '{}') || {}).bg || null; }
    catch (_) { return null; }
}

function applyTheme(theme) {
    if (!theme) return;
    // Recompute the FULL brand ramp from the chosen hex so every
    // --brand-* token (50…900 + alpha variants) updates, not just
    // --brand-500. Without this, every selector that reads
    // --brand-300 / --brand-400 / --brand-a12 stays stuck on the
    // ramp computed from the config default.
    if (theme.brand) applyBrandRamp(theme.brand);
}

// ═══════════════════════════════════════════════════════
// THEME PRESETS (/bankadmin)
// Each preset is a complete look — mode, colours, type and shape.
// Design only; nothing functional changes. 'apex' is the stock look.
// Presets write their type/shape tokens inline on :root; colours go
// through the same ramps the personal picker uses.
// ═══════════════════════════════════════════════════════
const SANS_DEFAULT = "'Geist', 'Inter', system-ui, -apple-system, 'Segoe UI', sans-serif";
const MONO_DEFAULT = "'Geist Mono', 'JetBrains Mono', ui-monospace, Consolas, monospace";
const THEMES = {
    apex:     { name: 'Apex',     mode: 'dark',  brand: '#1F5EFF', bg: '#131314', radius: 1 },
    obsidian: { name: 'Obsidian', mode: 'dark',  brand: '#8AB4FF', bg: '#0B0B0C', radius: 0.35 },
    fleeca:   { name: 'Fleeca',   mode: 'dark',  brand: '#1C7E50', bg: '#101A14', radius: 0.7,  display: 'Georgia, "Times New Roman", serif' },
    maze:     { name: 'Maze',     mode: 'dark',  brand: '#E11D2E', bg: '#161618', radius: 0.25, sans: '"Segoe UI", Arial, sans-serif' },
    midnight: { name: 'Midnight', mode: 'dark',  brand: '#38BDF8', bg: '#0F172A', radius: 1.15 },
    neon:     { name: 'Neon',     mode: 'dark',  brand: '#D946EF', bg: '#140D20', radius: 0.5 },
    terminal: { name: 'Terminal', mode: 'dark',  brand: '#35D07F', bg: '#080C09', radius: 0.15, sans: MONO_DEFAULT },
    royal:    { name: 'Royal',    mode: 'dark',  brand: '#D9A845', bg: '#1A1226', radius: 0.85, display: 'Cambria, Georgia, serif' },
    paper:    { name: 'Paper',    mode: 'light', brand: '#1B3A6B', bg: '#F3EFE6', radius: 0.8,  display: 'Georgia, "Times New Roman", serif' },
    snow:     { name: 'Snow',     mode: 'light', brand: '#2563EB', bg: '#F7F8FA', radius: 0.8,  sans: '"Segoe UI", Arial, sans-serif' },
    sand:     { name: 'Sand',     mode: 'light', brand: '#C2410C', bg: '#F4EBDC', radius: 1.4,  sans: '"Trebuchet MS", "Segoe UI", sans-serif' },
    ember:    { name: 'Ember',    mode: 'dark',  brand: '#F97316', bg: '#1B1613', radius: 0.6,  display: '"Segoe UI Black", "Arial Black", "Segoe UI", sans-serif' },
};
const THEME_ORDER = Object.keys(THEMES);
const RADII = { xs: 6, sm: 8, md: 12, lg: 16, xl: 22, '2xl': 28 };

function applyThemePreset(id) {
    const key = THEMES[id] ? id : 'apex';
    const def = THEMES[key];
    const root = document.documentElement;
    if (key === 'apex') root.removeAttribute('data-theme'); else root.setAttribute('data-theme', key);
    root.dataset.mode = def.mode;
    const st = root.style;
    st.setProperty('--sans', def.sans || SANS_DEFAULT);
    st.setProperty('--display', def.display || def.sans || SANS_DEFAULT);
    Object.keys(RADII).forEach((k) => st.setProperty('--r-' + k, Math.round(RADII[k] * def.radius) + 'px'));
    return def;
}

// ─── Layout presets: WHERE things sit (css `[data-layout]`) ───
// Independent of the colour presets; 'classic' is the stock structure.
const LAYOUTS = {
    classic: { name: 'Classic' },
    topnav:  { name: 'Top nav' },
    mirror:  { name: 'Mirror' },
    focus:   { name: 'Focus' },
    banner:  { name: 'Banner' },
    split:   { name: 'Split' },
};
const LAYOUT_ORDER = Object.keys(LAYOUTS);
function applyLayoutPreset(id) {
    const key = LAYOUTS[id] ? id : 'classic';
    const root = document.documentElement;
    if (key === 'classic') root.removeAttribute('data-layout'); else root.setAttribute('data-layout', key);
    try { Bank.repaintChart && Bank.repaintChart(); } catch (_) { /* chart not on screen */ }
    return LAYOUTS[key];
}

// The whole look in one call: preset first, then the two colours on
// top of it. Admin mode wins; off, the player's own picks apply on the
// stock preset (Runtime.theme.brand already holds their brand).
function applyAdminLook(at) {
    at = at || {};
    const on = at.enabled === true;
    applyLayoutPreset(on && at.layout ? at.layout : 'classic');
    const def = applyThemePreset(on && at.theme ? at.theme : 'apex');
    const brand = (on && at.brand) || (Runtime.theme && Runtime.theme.brand) || def.brand;
    const bg = on ? (at.bg || def.bg) : (personalBg() || def.bg);
    Runtime.theme = Runtime.theme || {};
    Runtime.theme.brand = brand;
    Runtime.theme.bg = on ? (at.bg || null) : null;
    applyBrandRamp(brand);
    applyBackgroundRamp(bg, def.mode);
}

// ═══════════════════════════════════════════════════════
// FEATURE TOGGLES (/bankadmin)
// The server enforces them; this only hides what cannot be used so
// nobody clicks into a "disabled" answer.
// ═══════════════════════════════════════════════════════
function applyFeatures(f) {
    f = (f && typeof f === 'object') ? f : {};
    Runtime.features = f;
    const off = (k) => f[k] === false;
    const setNav = (tab, hidden) => { const b = document.querySelector(`.nav-item[data-tab="${tab}"]`); if (b) b.hidden = hidden; };
    setNav('transfer', off('transfers'));
    setNav('cards',    off('cards'));
    setNav('history',  off('history'));
    setNav('savings',  off('savings'));
    setNav('loans',    off('loans'));
    setNav('settings', off('settings'));
    setNav('society',  off('subAccounts') && off('business'));
    if (off('vehicleFinance')) setNav('vehicles', true);   // otherwise data-driven
    if (off('billing'))        setNav('billing', true);
    const sub = document.getElementById('sub-section'); if (sub) sub.hidden = off('subAccounts');
    const biz = document.getElementById('biz-section'); if (biz && off('business')) biz.hidden = true;
    const quick = (k, hidden) => { const b = document.querySelector(`.quick-tile[data-quick="${k}"]`); if (b) b.hidden = hidden; };
    quick('transfer', off('transfers'));
    quick('card',     off('cards'));
    const eye = document.getElementById('overview-eye'); if (eye) eye.hidden = off('privacyMode');
    const priv = document.getElementById('set-privacy');
    const privRow = priv && priv.closest('.setting-row'); if (privRow) privRow.hidden = off('privacyMode');
    if (off('privacyMode') && Privacy.get()) Privacy.set(false);
    // a group label with nothing visible under it goes too
    $$('.nav-group').forEach((g) => {
        let n = g.nextElementSibling, any = false;
        while (n && !n.classList.contains('nav-group')) {
            if (n.classList.contains('nav-item') && !n.hidden) any = true;
            n = n.nextElementSibling;
        }
        g.hidden = !any;
    });
    // never leave the player on a tab that just vanished
    const active = document.querySelector('.nav-item.active');
    if (active && active.hidden) { const ov = document.querySelector('.nav-item[data-tab="overview"]'); if (ov) ov.click(); }
}

// ═══════════════════════════════════════════════════════
// PRIVACY MODE — global mask for monetary displays.
// Anything rendered via money() is masked while ON. Use the
// raw fmtMoney() for inputs, typed-amount confirmations and
// other places where the user must see the real number.
// ═══════════════════════════════════════════════════════
const Privacy = (() => {
    let enabled = false;
    return {
        get() { return enabled },
        set(v) {
            enabled = !!v;
            document.body.classList.toggle('privacy-on', enabled);
        },
        toggle() { this.set(!enabled); return enabled },
    };
})();

// Mask-aware money formatter (used everywhere a value is rendered
// for display). Inputs / typed previews stay raw via fmtMoney.
const money = (n) => Privacy.get() ? '••••••' : fmtMoney(n);

function applyLocale(loc) {
    if (!loc) return;
    // Keep the active table available to t() for dynamically-rendered
    // strings (cards, history rows, toasts, ATM, …).
    Runtime.locale = loc;
    if (loc.__lang) { try { document.documentElement.lang = loc.__lang; } catch (_) {} }

    // Generic, attribute-driven translation of every STATIC element in
    // index.html. Each element opts in via a data-attribute carrying a
    // locale key:
    //   data-i18n        → textContent
    //   data-i18n-html   → innerHTML   (strings that contain inline markup, e.g. <br>)
    //   data-i18n-ph     → placeholder attribute
    //   data-i18n-title  → title attribute
    //   data-i18n-aria   → aria-label attribute
    // Missing keys are left untouched so the English authored in the
    // HTML stays as the fallback.
    $$('[data-i18n]').forEach(el => {
        const v = loc[el.dataset.i18n]; if (v != null) el.textContent = v;
    });
    $$('[data-i18n-html]').forEach(el => {
        const v = loc[el.dataset.i18nHtml]; if (v != null) el.innerHTML = v;
    });
    $$('[data-i18n-ph]').forEach(el => {
        const v = loc[el.dataset.i18nPh]; if (v != null) el.setAttribute('placeholder', v);
    });
    $$('[data-i18n-title]').forEach(el => {
        const v = loc[el.dataset.i18nTitle]; if (v != null) el.setAttribute('title', v);
    });
    $$('[data-i18n-aria]').forEach(el => {
        const v = loc[el.dataset.i18nAria]; if (v != null) el.setAttribute('aria-label', v);
    });

    // Wordmark — appears in several places and is split into two
    // independently-coloured halves, so it stays a special case.
    if (loc.wm_first)  {
        const w = $('#wm-first'); if (w) w.textContent = loc.wm_first;
        const lf = $('#loading-wm-first'); if (lf) lf.textContent = loc.wm_first;
    }
    if (loc.wm_second) {
        const w = $('#wm-second'); if (w) w.textContent = loc.wm_second;
        const ls = $('#loading-wm-second'); if (ls) ls.textContent = loc.wm_second;
    }
}

// ═══════════════════════════════════════════════════════
// LOADING SCREEN — minimal auto-progress
// ───────────────────────────────────────────────────────
// No user interaction. Shows the panel, plays a brief indeterminate
// sweep with a status caption, then resolves so the dashboard can
// reveal. Cancel-safe: if Lua fires bank_close mid-loader, the
// awaiting open() chain unwinds cleanly.
// ═══════════════════════════════════════════════════════
const Loader = (() => {
    const overlay = document.getElementById('loading-overlay');
    const status  = document.getElementById('loader-fp-status');
    const fill    = document.getElementById('loader-bar-fill');

    let resolver = null;
    let timers = [];

    function clear() {
        timers.forEach(t => clearTimeout(t));
        timers = [];
    }

    function play(totalMs = 1600) {
        // Built lazily (not at module-load) so Runtime.locale — pushed by
        // Lua on bootstrap — is already populated when the loader runs.
        const STEPS = [
            t('js_loader_step_connect'),
            t('js_loader_step_auth'),
            t('js_loader_step_decrypt'),
            t('js_loader_step_finalise'),
        ];
        return new Promise(resolve => {
            clear();
            resolver = resolve;
            overlay.hidden = false;

            // Reset the bar to 0 without animating, then let the
            // notches below ease it forward.
            if (fill) {
                fill.style.transition = 'none';
                fill.style.width = '0%';
                void fill.offsetWidth;        // force reflow
                fill.style.transition = '';
            }
            if (status) status.textContent = STEPS[0];
            Sound('open');

            const n = STEPS.length;
            STEPS.forEach((label, i) => {
                timers.push(setTimeout(() => {
                    if (status) status.textContent = label;
                    if (fill) fill.style.width = Math.round(((i + 1) / n) * 100) + '%';
                }, Math.max(0, totalMs * (i / n))));
            });

            timers.push(setTimeout(() => {
                clear();
                if (fill) fill.style.width = '100%';
                Sound('ready');
                overlay.hidden = true;
                const r = resolver; resolver = null;
                if (r) r();
            }, Math.max(500, totalMs)));
        });
    }

    function hide() {
        clear();
        overlay.hidden = true;
        if (resolver) {
            const r = resolver; resolver = null;
            r();
        }
    }

    return { play, hide };
})();

// ═══════════════════════════════════════════════════════
// NOTIFY (fallback only — Lua prefers apex_notify)
// ═══════════════════════════════════════════════════════
const Notify = (() => {
    let host;
    const ensure = () => {
        if (!host) host = document.getElementById('notify-container');
        return host;
    };
    return ({ title = t('js_notify_default_title'), message, type = 'info', duration = 5000, position = 'top-right' }) => {
        const root = ensure(); if (!root) return;
        root.className = `notify-container pos-${position}`;
        const el = document.createElement('div');
        el.className = `notify-card ${type}`;
        const icon = type === 'error' ? 'fa-circle-xmark'
                  : type === 'success' ? 'fa-circle-check'
                  : type === 'warning' ? 'fa-triangle-exclamation'
                  : 'fa-circle-info';
        el.innerHTML = `
            <div class="notify-header">
                <i class="notify-icon fa-solid ${icon}"></i>
                <span class="notify-title">${title}</span>
            </div>
            <div class="notify-body">${message ?? ''}</div>
            <div class="notify-progress"><div class="notify-progress-bar"></div></div>`;
        root.appendChild(el);
        const bar = el.querySelector('.notify-progress-bar');
        bar.animate([{ transform: 'scaleX(1)' }, { transform: 'scaleX(0)' }],
            { duration, easing: 'linear' });
        setTimeout(() => el.remove(), duration);
    };
})();

// ═══════════════════════════════════════════════════════
// 3D WORLD ICON
// ═══════════════════════════════════════════════════════
const WorldIcon = (() => {
    const el = document.getElementById('world-icon');
    const icon = document.getElementById('world-icon-i');
    const lbl  = document.getElementById('world-icon-label');
    const ICON_FA = {
        hand: 'fa-hand', building: 'fa-building-columns',
        'credit-card': 'fa-credit-card',
    };
    // Hide timer lets the CSS fade-out complete before the
    // element gets [hidden] applied — without this, the next
    // show() teleports the marker visibly through stale coords.
    let hideTimer;
    return {
        show({ x, y, scale = 1, label, icon: ic = 'building' }) {
            // never float over one of our own panels (bank / onboarding / ATM)
            if (['bank-overlay', 'onb-overlay', 'atm-overlay'].some(id => { const o = document.getElementById(id); return o && !o.hidden; })) { this.hide(); return; }
            clearTimeout(hideTimer);
            el.hidden = false;
            el.style.left = `${x * window.innerWidth}px`;
            el.style.top  = `${y * window.innerHeight}px`;
            // The translate keeps the centre over the world point;
            // the scale comes from distance for a subtle depth cue.
            el.style.setProperty('--scale', scale);
            el.classList.add('show');
            if (lbl) lbl.textContent = label || '';
            if (icon) icon.className = `fa-solid ${ICON_FA[ic] || 'fa-hand'}`;
        },
        hide() {
            el.classList.remove('show');
            clearTimeout(hideTimer);
            hideTimer = setTimeout(() => { el.hidden = true }, 220);
        },
    };
})();

// ═══════════════════════════════════════════════════════
// ONBOARDING (standalone modal)
// ═══════════════════════════════════════════════════════
const Onboarding = (() => {
    const overlay = document.getElementById('onb-overlay');
    let pin = '';

    function open() {
        overlay.hidden = false;
        showStep('welcome');
        setPin('');
    }
    function close() { overlay.hidden = true }

    function showStep(step) {
        $$('.onb-step').forEach(el => el.hidden = el.dataset.step !== step);
        $$('.onb-pstep').forEach(el => {
            el.classList.remove('active', 'done');
            const order = ['welcome', 'pin', 'fingerprint', 'success'];
            const a = order.indexOf(el.dataset.pstep);
            const b = order.indexOf(step);
            if (a < b) el.classList.add('done');
            else if (a === b) el.classList.add('active');
        });
    }

    function setPin(p) {
        pin = p;
        const len = (Runtime.pin && Runtime.pin.length) || 4;
        $$('#onb-pin-row .pin-dot').forEach((d, i) => d.classList.toggle('filled', i < p.length));
        $('#onb-confirm-pin').disabled = p.length !== len;
    }

    on($('#onb-numpad'), 'click', (e) => {
        const k = e.target.closest('button')?.dataset.k; if (!k) return;
        Sound('click');
        if (k === 'C') return setPin('');
        if (k === '←') return setPin(pin.slice(0, -1));
        const len = (Runtime.pin && Runtime.pin.length) || 4;
        if (pin.length < len) setPin(pin + k);
    });

    on($('#onb-go'),   'click', () => { setPin(''); showStep('pin'); });
    on($('#onb-back'), 'click', () => showStep('welcome'));

    // Step 2 → Step 3 (just transition; the scan starts on click)
    on($('#onb-confirm-pin'), 'click', () => {
        Sound('select');
        $('#fp-progress-fill').style.width = '0%';
        $('#fp-status').textContent = t('js_fp_click_to_begin');
        $('#fp-scanner').classList.remove('scanning', 'done');
        $('#privacy-checkbox').checked = false;
        showStep('fingerprint');
        // /bankadmin switched the fingerprint ceremony off: the account
        // opens straight away, no scanner click needed.
        if (Runtime.features && Runtime.features.onboarding === false) runScan();
    });

    let fpScanning = false;
    async function runScan() {
        if (fpScanning) return;
        fpScanning = true;
        Sound('select');
        $('#fp-scanner').classList.add('scanning');
        $('#privacy-toggle').classList.add('locked');
        $('#fp-status').textContent = t('js_fp_scanning');
        animateFp();
        const r = await post('bank_open_account', { pin });
        fpScanning = false;
        if (r.ok) {
            Sound('chime');
            $('#fp-scanner').classList.remove('scanning');
            $('#fp-scanner').classList.add('done');
            $('#onb-summary-iban').textContent = (r.data && r.data.ibanPretty) || '—';
            $('#onb-summary-name').textContent = (r.data && r.data.ownerName) || '—';
            const cn = $('#onb-card-name'); if (cn) cn.textContent = (r.data && r.data.ownerName) || '—';
            showStep('success');
        } else {
            Sound('error');
            Notify({ type: 'error', message: t('js_onb_open_failed', (r.why || 'unknown')) });
            $('#fp-scanner').classList.remove('scanning');
            $('#privacy-toggle').classList.remove('locked');
            showStep('pin');
        }
    }

    on($('#fp-scanner'), 'click', runScan);

    on($('#onb-finish'), 'click', async () => {
        const privacy = $('#privacy-checkbox').checked;
        // Set the privacy flag BEFORE the bank opens so the very
        // first render already masks the balances.
        Bank.setPrivacy(privacy);
        close();
        await post('onb_finish', { privacy });
    });

    function animateFp() {
        let p = 0;
        $('#fp-progress-fill').style.width = '0%';
        const id = setInterval(() => {
            p += 2;
            $('#fp-progress-fill').style.width = p + '%';
            if (p >= 100) { clearInterval(id); $('#fp-status').textContent = t('js_fp_verified') }
        }, 90);
    }

    return { open, close };
})();

// ═══════════════════════════════════════════════════════
// CHART (cashflow + breakdown helpers)
// ═══════════════════════════════════════════════════════
// Simple line chart: ONE net-cashflow line per day, brand-tinted,
// with horizontal gridlines, Y-axis value labels and X-axis date
// labels. Avoids the dual-line clutter of the previous version.
// V2: paired income / expense bars per day with a soft net line on top.
function renderFlowChart(svg, days) {
    if (!svg) return;
    const rect = svg.getBoundingClientRect();
    const W = Math.max(220, Math.round(rect.width  || 700));
    const H = Math.max(140, Math.round(rect.height || 200));
    svg.setAttribute('viewBox', `0 0 ${W} ${H}`);
    svg.innerHTML = '';

    const css   = getComputedStyle(document.documentElement);
    const brand = (css.getPropertyValue('--brand-500') || '#1F5EFF').trim();
    const brandHi = (css.getPropertyValue('--brand-300') || '#859BFF').trim();
    const outC  = (css.getPropertyValue('--surface-5') || '#38383C').trim();
    const text3 = (css.getPropertyValue('--text-3')    || '#7C7C82').trim();
    const text4 = (css.getPropertyValue('--text-4')    || '#565659').trim();
    const line1 = (css.getPropertyValue('--line-1')    || '#1F1F21').trim();
    const NS = 'http://www.w3.org/2000/svg';
    const el = (tag, attrs) => { const n = document.createElementNS(NS, tag); for (const k in attrs) n.setAttribute(k, attrs[k]); return n; };
    const compact = (v) => {
        const abs = Math.abs(v); const sign = v < 0 ? '-' : '';
        if (abs === 0) return '$0';
        if (abs >= 1000) { const k = abs / 1000; return sign + '$' + (k % 1 === 0 ? k : k.toFixed(1)) + 'k'; }
        return sign + '$' + Math.round(abs);
    };

    const P = { t: 14, r: 8, b: 28, l: 48 };
    const innerW = W - P.l - P.r;
    const innerH = H - P.t - P.b;

    const hasData = days && days.some(d => (d.in || 0) > 0 || (d.out || 0) > 0);
    if (hasData) {
        const maxV = Math.max(1, ...days.map(d => Math.max(d.in || 0, d.out || 0)));
        // round step (1/2/2.5/5 × 10^n) so there are at most 5 intervals
        const pow = Math.pow(10, Math.floor(Math.log10(maxV / 5)));
        const step = [1, 2, 2.5, 5, 10].map(m => m * pow).find(s => Math.ceil(maxV / s) <= 5) || pow * 10;
        const steps = Math.max(1, Math.ceil(maxV / step));
        const niceMax = step * steps;
        const yFor = (v) => P.t + innerH - (v / niceMax) * innerH;

        Array.from({ length: steps + 1 }, (_, i) => (steps - i) / steps).forEach(f => {
            const y = yFor(Math.round(niceMax * f));
            svg.appendChild(el('line', { x1: P.l, x2: W - P.r, y1: y, y2: y, stroke: f === 0 ? text4 : line1, 'stroke-width': 1, 'shape-rendering': 'crispEdges', 'stroke-opacity': f === 0 ? .6 : 1 }));
            const tx = el('text', { x: P.l - 10, y: y + 4, 'text-anchor': 'end', fill: text3, 'font-size': 11, 'font-family': 'Geist Mono, JetBrains Mono, monospace', 'font-weight': 500 });
            tx.textContent = compact(Math.round(niceMax * f));
            svg.appendChild(tx);
        });

        const slot = innerW / days.length;
        const bw = Math.max(6, Math.min(22, slot * .26));
        const defs = el('defs', {});
        defs.innerHTML = `<linearGradient id="apex-bar-in" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="${brandHi}"/><stop offset="100%" stop-color="${brand}"/></linearGradient>`;
        svg.appendChild(defs);
        const bar = (x, v, fill) => {
            const h = Math.max(v > 0 ? 3 : 0, (v / niceMax) * innerH);
            if (!h) return;
            const r = Math.min(5, bw / 2);
            const y = P.t + innerH - h;
            svg.appendChild(el('path', { d: `M${x},${y + h} V${y + r} Q${x},${y} ${x + r},${y} H${x + bw - r} Q${x + bw},${y} ${x + bw},${y + r} V${y + h} Z`, fill }));
        };
        const nets = [];
        days.forEach((d, i) => {
            const cx = P.l + slot * i + slot / 2;
            bar(cx - bw - 2, d.in || 0, 'url(#apex-bar-in)');
            bar(cx + 2, d.out || 0, outC);
            nets.push([cx, yFor(Math.max(0, (d.in || 0) - (d.out || 0)))]);
            const lb = el('text', { x: cx, y: H - 9, 'text-anchor': 'middle', fill: i === days.length - 1 ? '#fff' : text3, 'font-size': 11, 'font-family': 'Geist, Inter, sans-serif', 'font-weight': 600 });
            lb.textContent = d.label || '';
            svg.appendChild(lb);
        });
        // net line (positive part only — the bars already carry the losses)
        let path = `M ${nets[0][0]},${nets[0][1]}`;
        for (let i = 1; i < nets.length; i++) {
            const [x0, y0] = nets[i - 1], [x1, y1] = nets[i];
            const mx = (x0 + x1) / 2;
            path += ` C ${mx},${y0} ${mx},${y1} ${x1},${y1}`;
        }
        svg.appendChild(el('path', { d: path, fill: 'none', stroke: '#fff', 'stroke-opacity': .5, 'stroke-width': 1.5, 'stroke-dasharray': '4 4' }));
        nets.forEach(([x, y]) => svg.appendChild(el('circle', { cx: x, cy: y, r: 2.5, fill: '#fff', 'fill-opacity': .8 })));
        return;
    }

    if (!hasData) {
        const noActivityLabel = t('js_chart_no_activity');
        const tn = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        tn.setAttribute('x', W/2); tn.setAttribute('y', H/2);
        tn.setAttribute('text-anchor', 'middle');
        tn.setAttribute('fill', text4);
        tn.setAttribute('font-size', '12');
        tn.setAttribute('font-family', 'Inter, system-ui, sans-serif');
        tn.textContent = noActivityLabel;
        svg.appendChild(tn);
        return;
    }

}

function renderBreakdown(wrap, rows) {
    wrap.innerHTML = '';
    if (!rows.length) {
        wrap.innerHTML = `<div class="tx-empty">${t('js_breakdown_empty')}</div>`;
        return;
    }
    // V2: one stacked bar for the whole week + a ranked category list
    const total = Math.max(1, rows.reduce((n, r) => n + r.amount, 0));
    const PALETTE = [
        ['var(--brand-400)', 'var(--brand-a12)'],
        ['#34C77B', 'rgba(52,199,123,.12)'],
        ['#FFC53D', 'rgba(255,197,61,.12)'],
        ['#F0556D', 'rgba(240,85,109,.12)'],
        ['#B07CFF', 'rgba(176,124,255,.12)'],
        ['#8E8FA3', 'rgba(142,143,163,.14)'],
    ];
    const stack = document.createElement('div');
    stack.className = 'bk-stack';
    rows.forEach((r, i) => {
        const s = document.createElement('span');
        s.style.flex = String(Math.max(.02, r.amount / total));
        s.style.background = PALETTE[i % PALETTE.length][0];
        stack.appendChild(s);
    });
    wrap.appendChild(stack);
    rows.slice(0, 5).forEach((r, i) => {
        const [c, bg] = PALETTE[i % PALETTE.length];
        const div = document.createElement('div');
        div.className = 'bk-row';
        div.style.setProperty('--_c', c);
        div.style.setProperty('--_bg', bg);
        div.innerHTML = `
            <span class="bk-ic"><i class="fa-solid ${r.icon}"></i></span>
            <span class="bk-label"><span>${esc(r.label)}</span><small>${Math.round((r.amount / total) * 100)}%</small></span>
            <strong>${money(r.amount)}</strong>`;
        wrap.appendChild(div);
    });
}

// Day-grouped transaction list (Today / Yesterday / dd Mon), with the
// day's net on the right of each header.
function renderTxList(wrap, rows, nodeFn, myIban) {
    wrap.innerHTML = '';
    const start = new Date(); start.setHours(0, 0, 0, 0);
    const today = Math.floor(start.getTime() / 1000);
    const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    let curKey = null, head = null, net = 0;
    const flush = () => { if (head) head.querySelector('small').textContent = (net >= 0 ? '+' : '−') + money(Math.abs(net)); };
    rows.forEach(r => {
        const d = new Date((r.ts || 0) * 1000); d.setHours(0, 0, 0, 0);
        const dayTs = Math.floor(d.getTime() / 1000);
        const key = String(dayTs);
        if (key !== curKey) {
            flush();
            curKey = key; net = 0;
            const label = dayTs === today ? t('v2_today') : dayTs === today - 86400 ? t('v2_yesterday')
                : (() => { try { return d.toLocaleDateString((Runtime.locale && Runtime.locale.__lang) || 'en', { day: 'numeric', month: 'short' }).replace('.', ''); } catch (_) { return `${d.getDate()} ${MONTHS[d.getMonth()]}`; } })();
            head = document.createElement('div');
            head.className = 'tx-day';
            head.innerHTML = `<span>${esc(label)}</span><small></small>`;
            wrap.appendChild(head);
        }
        const isOut = r.from_iban === myIban && r.kind !== 'transfer_in';
        net += isOut ? -(r.amount || 0) : (r.amount || 0);
        wrap.appendChild(nodeFn(r));
    });
    flush();
}

// ═══════════════════════════════════════════════════════
// BANK MAIN UI
// ═══════════════════════════════════════════════════════
const Bank = (() => {
    const overlay = document.getElementById('bank-overlay');
    let state = {
        account: null, history: [], cards: [], society: [],
        business: [], credit: null,
        loan: null, savings: null,
        billing: { enabled: false, received: [], societyReceived: [], societySent: [] },
        currentTab: 'overview', historyFilter: '', balanceHidden: false,
    };

    // Store locale KEYS here (not translated strings): this object is
    // built once at module-load, before Lua's bootstrap populates
    // Runtime.locale, so translation is deferred to switchTab() via t().
    const tabMeta = {
        overview: { icon: 'fa-house-chimney', eyebrow: 'js_tab_overview_eyebrow', title: 'js_tab_overview_title' },
        transfer: { icon: 'fa-paper-plane',   eyebrow: 'js_tab_transfer_eyebrow', title: 'js_tab_transfer_title' },
        cards:    { icon: 'fa-credit-card',   eyebrow: 'js_tab_cards_eyebrow',     title: 'js_tab_cards_title' },
        savings:  { icon: 'fa-piggy-bank',    eyebrow: 'js_tab_savings_eyebrow',   title: 'js_tab_savings_title' },
        loans:    { icon: 'fa-hand-holding-dollar', eyebrow: 'js_tab_loans_eyebrow', title: 'js_tab_loans_title' },
        vehicles: { icon: 'fa-car',           eyebrow: 'js_tab_vehicles_eyebrow', title: 'js_tab_vehicles_title' },
        society:  { icon: 'fa-briefcase',     eyebrow: 'js_tab_society_eyebrow',  title: 'js_tab_society_title' },
        billing:  { icon: 'fa-file-invoice-dollar', eyebrow: 'js_tab_billing_eyebrow', title: 'js_tab_billing_title' },
        history:  { icon: 'fa-clock-rotate-left', eyebrow: 'js_tab_history_eyebrow', title: 'js_tab_history_title' },
        settings: { icon: 'fa-sliders',       eyebrow: 'js_tab_settings_eyebrow',  title: 'js_tab_settings_title' },
    };

    // In-shell loader: covers the panel interior while data populates
    // behind it, then fades. It reads like a terminal bringing a session
    // up — each step spins, then locks with a check, and the bar tracks
    // the steps. Cancel-safe: a fresh run clears stale timers.
    let shellTimers = [];
    function runShellLoader(totalMs = 1400) {
        const el = document.getElementById('bank-loader');
        if (!el) return Promise.resolve();
        const status = document.getElementById('bank-loader-status');
        const fill   = document.getElementById('bl-fill');
        shellTimers.forEach(clearTimeout);
        shellTimers = [];
        // three plain statuses; the bar tracks them
        const STEPS = [
            t('js_shell_step_biometric'),
            t('js_shell_step_decrypt'),
            t('js_shell_step_verified'),
        ];
        const n = STEPS.length;
        const enter = (i) => {
            if (status) status.textContent = STEPS[i];
            if (fill) fill.style.width = Math.round(((i + 1) / n) * 100) + '%';
        };
        return new Promise(resolve => {
            el.classList.remove('hide');
            if (fill) fill.style.width = '0%';
            enter(0);
            for (let i = 1; i < n; i++) {
                shellTimers.push(setTimeout(() => enter(i), totalMs * (i / n)));
            }
            shellTimers.push(setTimeout(() => {
                el.classList.add('hide');
                resolve();
            }, Math.max(600, totalMs)));
        });
    }

    async function open({ bank, initial, skipLoader } = {}) {
        if (bank && bank.label) {
            $('#bank-name').textContent = bank.label;
            const bl = $('#bl-name'); if (bl) bl.textContent = bank.label;
        }
        // Shell-first reveal: show the panel immediately with the
        // in-shell loader covering the dashboard, then fade it to
        // unveil the data (which populates behind it). No bank info is
        // visible until the loader clears.
        const _bl = document.getElementById('bank-loader');
        if (skipLoader) { if (_bl) _bl.classList.add('hide'); }
        else { runShellLoader(1600); }
        overlay.hidden = false;
        post('bank_focus');
        setTimeout(() => post('bank_focus'), 120);
        // Pre-paint the Settings theme swatches so the user sees them
        // immediately when navigating to the Settings tab (instead of
        // having to click "Reset" first).
        try { initPersonalControls(); } catch (_) {}
        try { initAdminControls();    } catch (_) {}
        switchTab(initial || 'overview');
        refreshVehFin();
        startClock();
    }
    function close(notifyLua = true) {
        overlay.hidden = true;
        stopClock();
        resetMugshot();          // the Lua side frees the headshot slot on close
        try { ColorPicker.close(); } catch (_) {}
        if (notifyLua) post('bank_close');
    }

    let clockTimer;
    function startClock() {
        const el = document.getElementById('bank-clock');
        if (!el) return;
        const tick = () => {
            const d = new Date();
            el.textContent = `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
        };
        tick();
        clearInterval(clockTimer);
        clockTimer = setInterval(tick, 15000);
    }
    function stopClock() { clearInterval(clockTimer); }

    function switchTab(name) {
        try { ColorPicker.close(); } catch (_) {}
        state.currentTab = name;
        $$('.nav-item').forEach(b => b.classList.toggle('active', b.dataset.tab === name));
        $$('#bank-body .pane').forEach(p => p.hidden = p.dataset.pane !== name);
        const body = $('#bank-body');
        if (body) body.classList.toggle('tab-overview', name === 'overview');
        const m = tabMeta[name];
        if (m) {
            // (the topbar icon chip was removed — title + eyebrow only)
            $('#bank-tab-eyebrow').textContent = t(m.eyebrow);
            $('#bank-tab-title').textContent = t(m.title);
        }
        if (name === 'vehicles') refreshVehFin();
        // Reset every scrollable surface inside the bank so the
        // user always lands at the top of the freshly-revealed tab.
        // Covers the body itself plus all inner scroll containers
        // (recent activity, breakdown, history, contacts, panes…).
        resetBankScroll();
    }

    // Iterate every element that can scroll inside the bank shell
    // and rewind it to scrollTop = 0. Called on tab switches and
    // on initial open so the dashboard never re-opens halfway
    // down a list.
    function resetBankScroll() {
        const body = $('#bank-body'); if (body) body.scrollTop = 0;
        $$('#bank-overlay .pane').forEach(p => { p.scrollTop = 0 });
        $$('#bank-overlay .tx-list, ' +
           '#bank-overlay .breakdown, ' +
           '#bank-overlay .contact-list, ' +
           '#bank-overlay .billing-list, ' +
           '#bank-overlay .biz-list, ' +
           '#bank-overlay .sub-list, ' +
           '#bank-overlay .card-stack').forEach(el => { el.scrollTop = 0 });
    }

    // ─── Aggregation helpers (income/expense in last 7d) ──
    function aggregate(history, myIban) {
        const cutoff = Math.floor(Date.now() / 1000) - 7 * 86400;
        const days = [];
        const dayLabel = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
        const today = new Date();
        today.setHours(0,0,0,0);
        for (let i = 6; i >= 0; i--) {
            const d = new Date(today); d.setDate(d.getDate() - i);
            days.push({
                ts: Math.floor(d.getTime() / 1000),
                label: (() => { try { return d.toLocaleDateString((Runtime.locale && Runtime.locale.__lang) || 'en', { weekday: 'short' }).replace('.', ''); } catch (_) { return dayLabel[d.getDay()]; } })(),
                in: 0, out: 0,
            });
        }
        let totalIn = 0, totalOut = 0, atmOut = 0, txInCount = 0, txOutCount = 0, atmCount = 0;
        const byCat = {};

        history.forEach(r => {
            if (r.ts < cutoff) return;
            const isOut = r.from_iban === myIban && r.kind !== 'transfer_in';
            const isIn  = r.to_iban === myIban && !isOut;
            const day = days.find(d => r.ts >= d.ts && r.ts < d.ts + 86400);

            if (isIn) {
                totalIn += r.amount; txInCount++;
                if (day) day.in += r.amount;
            } else if (isOut) {
                totalOut += r.amount; txOutCount++;
                if (day) day.out += r.amount;
            }
            if (/atm/.test(r.kind) && isOut) { atmOut += r.amount; atmCount++; }

            // categorise for breakdown
            if (isOut) {
                let cat = 'Other';
                if (/atm/.test(r.kind))           cat = 'ATM Withdrawals';
                else if (/billing/.test(r.kind))  cat = 'Billing payments';
                else if (/transfer/.test(r.kind)) cat = 'Transfers';
                else if (r.kind === 'fee')        cat = 'Fees';
                else if (r.kind === 'withdraw')   cat = 'Cash withdrawals';
                else if (r.kind === 'loan_repay') cat = 'Loan repayment';
                else if (r.kind === 'savings_in') cat = 'Savings';
                byCat[cat] = (byCat[cat] || 0) + r.amount;
            }
        });

        const catLabel = {
            'ATM Withdrawals': t('js_cat_atm_withdrawals'),
            'Billing payments': t('js_cat_billing_payments'),
            'Transfers': t('js_cat_transfers'),
            'Fees': t('js_cat_fees'),
            'Cash withdrawals': t('js_cat_cash_withdrawals'),
            'Loan repayment': t('js_cat_loan_repayment'),
            'Savings': t('js_cat_savings'),
            'Other': t('js_cat_other'),
        };
        const breakdown = Object.entries(byCat)
            .map(([cat, amount]) => ({
                label: catLabel[cat] || cat, amount,
                icon: ({
                    'ATM Withdrawals': 'fa-credit-card',
                    'Billing payments': 'fa-file-invoice-dollar',
                    'Transfers': 'fa-paper-plane',
                    'Fees': 'fa-receipt',
                    'Cash withdrawals': 'fa-arrow-up',
                    'Loan repayment': 'fa-hand-holding-dollar',
                    'Savings': 'fa-piggy-bank',
                    'Other': 'fa-circle',
                }[cat] || 'fa-circle'),
            }))
            .sort((a, b) => b.amount - a.amount);

        return { days, totalIn, totalOut, atmOut, txInCount, txOutCount, atmCount, breakdown };
    }

    // ─── Renders ────────────────────────────────────────
    function renderSnapshot() {
        const a = state.account; if (!a) return;
        const ibanFmt = a.ibanPretty || fmtIban(a.iban);
        $('#bid-name').textContent = a.ownerName || '—';
        $('#bid-iban').textContent = ibanFmt;
        $('#bid-cash').textContent = money(a.cash);
        $('#bid-savings').textContent = money(a.savings);

        // The hero block uses ••••• whenever privacy mode is on
        // (mirrored via state.balanceHidden); other surfaces use
        // the global Privacy gate.
        animateMoney($('#hero-balance'), a.balance + (a.savings || 0), state.balanceHidden, '••••••');
        animateMoney($('#hero-bank'),    a.balance, state.balanceHidden, '••••');
        animateMoney($('#hero-cash'),    a.cash,    state.balanceHidden, '••••');
        animateMoney($('#hero-savings'), a.savings, state.balanceHidden, '••••');
        const tag = $('#hero-tag');
        if (tag) {
            const now = new Date();
            tag.innerHTML = `<i class="fa-solid fa-circle-check"></i> ${esc(t('v2_updated', `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`))}`;
        }
        $('#hero-iban').textContent = ibanFmt;
        $('#set-iban-display').textContent = ibanFmt;
        $('#set-holder').textContent = a.ownerName || '—';

        // V2: initials avatar, greeting, allocation bar
        const initials = String(a.ownerName || '?').trim().split(/\s+/).map(w => w[0] || '').join('').slice(0, 2).toUpperCase();
        const av = $('#bid-avatar');
        if (av && !av.classList.contains('has-mug')) {
            av.textContent = initials || '—';
            loadMugshot(av);
        }
        const hg = $('#hero-greet');
        if (hg) {
            const h = new Date().getHours();
            const greet = t(h < 12 ? 'v2_greet_morning' : h < 19 ? 'v2_greet_afternoon' : 'v2_greet_evening');
            hg.textContent = `${greet}, ${String(a.ownerName || '').split(/\s+/)[0] || ''}`;
        }
        const parts = [Math.max(0, a.balance || 0), Math.max(0, a.cash || 0), Math.max(0, a.savings || 0)];
        const sum = parts.reduce((x, y) => x + y, 0);
        ['#alloc-bank', '#alloc-cash', '#alloc-savings'].forEach((sel, i) => {
            const seg = $(sel); if (!seg) return;
            const f = sum > 0 ? parts[i] / sum : (i === 0 ? 1 : 0);
            seg.style.flexGrow = String(f);
            seg.style.flexBasis = '0';
            seg.style.display = f > 0 ? '' : 'none';
        });

        // Transfer "from" dropdown
        const sel = $('#tx-from');
        sel.innerHTML = '';
        const opt = document.createElement('option');
        opt.value = a.iban;
        opt.textContent = `${t('js_tx_from_main')} · ${fmtIban(a.iban)} · ${money(a.balance)}`;
        sel.appendChild(opt);
        (state.society || []).forEach(s => {
            const o = document.createElement('option');
            o.value = s.iban;
            o.textContent = `${s.label} · ${fmtIban(s.iban)} · ${money(s.balance)}`;
            sel.appendChild(o);
        });

        // Badges — minimalist: hide the count entirely when 0.
        // The cards nav no longer carries a counter; only Business
        // keeps the partner-count chip.
        const setBadge = (el, n) => {
            if (!el) return;
            el.textContent = n > 0 ? String(n) : '';
            el.dataset.empty = n > 0 ? 'false' : 'true';
        };
        setBadge($('#nav-society-badge'), state.society.length);

        const billingEnabled = !!(state.billing && state.billing.enabled)
            && !(Runtime.features && Runtime.features.billing === false);
        const billingNav = $('#nav-billing');
        if (billingNav) billingNav.hidden = !billingEnabled;
        const billingFilter = $('#hf-billing');
        if (billingFilter) billingFilter.hidden = !billingEnabled;
        if (!billingEnabled && state.currentTab === 'billing') switchTab('overview');
        if (!billingEnabled && state.historyFilter === 'billing') {
            state.historyFilter = '';
            $$('.hf-pill').forEach(x => x.classList.toggle('active', x.dataset.kind === ''));
        }
        const pendingBilling = billingEnabled
            ? (state.billing.received || []).concat(state.billing.societyReceived || [])
                .filter(inv => inv.status === 'sent').length
            : 0;
        setBadge($('#nav-billing-badge'), pendingBilling);
    }

    // Real character portrait (native GTA headshot rendered by the client,
    // same method as apex_bossmenu). Initials stay until the photo decodes.
    let mugPending = false, mugTries = 0;
    function loadMugshot(av) {
        if (mugPending || mugTries >= 3) return;
        mugPending = true; mugTries++;
        post('bank_mugshot').then(r => {
            mugPending = false;
            if (!r || !r.ok || !r.url) { setTimeout(() => loadMugshot(av), 1500); return; }
            const img = new Image();
            img.alt = '';
            img.onload = () => {
                av.textContent = '';
                av.appendChild(img);
                av.classList.add('has-mug');
                av.classList.toggle('mug-opaque', !!r.opaque);
            };
            img.onerror = () => setTimeout(() => loadMugshot(av), 800);   // txd not streamed yet
            img.src = r.url;
        }).catch(() => { mugPending = false; });
    }
    function resetMugshot() {
        mugTries = 0; mugPending = false;
        const av = $('#bid-avatar');
        if (av) { av.classList.remove('has-mug', 'mug-opaque'); av.textContent = '—'; }
    }

    // ─── Vehicle financing (apex_dealerships — soft integration) ───
    // The tab only exists while apex_dealerships is running; otherwise
    // the nav item stays hidden and banking works exactly as before.
    function refreshVehFin() {
        post('vf_refresh').then(r => {
            const d = (r && r.ok && r.data) || {};
            state.vehfin = (d && d.available) ? d : { available: false, vehicles: [] };
            renderVehFin();
        }).catch(() => {});
    }

    function renderVehFin() {
        const d = state.vehfin || { available: false };
        const list = Array.isArray(d.vehicles) ? d.vehicles : [];
        const nav = $('#nav-vehicles');
        if (nav) nav.hidden = !d.available || (Runtime.features && Runtime.features.vehicleFinance === false);
        const badge = $('#nav-vehicles-badge');
        if (badge) {
            badge.textContent = list.length > 0 ? String(list.length) : '';
            badge.dataset.empty = list.length > 0 ? 'false' : 'true';
        }
        if (!d.available) {
            if (state.currentTab === 'vehicles') switchTab('overview');
            return;
        }
        const wrap = $('#vf-list'); if (!wrap) return;
        const count = $('#vf-count'); if (count) count.textContent = String(list.length);
        const sum = $('#vf-summary');
        wrap.innerHTML = '';
        if (!list.length) {
            if (sum) sum.hidden = true;
            wrap.innerHTML = `
                <div class="vf-empty">
                    <span class="vf-empty-ic"><i class="fa-solid fa-car-side"></i></span>
                    <strong>${esc(t('vf_empty'))}</strong>
                    <small>${esc(t('v2_vf_empty_sub'))}</small>
                </div>`;
            return;
        }
        const now = Math.floor(Date.now() / 1000);
        const fmtLeft = (s) => s >= 86400 ? `${Math.floor(s / 86400)}d ${Math.floor((s % 86400) / 3600)}h`
            : `${Math.floor(s / 3600)}h ${Math.floor((s % 3600) / 60)}m`;
        if (sum) {
            const owed = list.reduce((n, v) => n + (Number(v.owed) || 0), 0);
            const perCycle = list.reduce((n, v) => n + (Number(v.payment) || 0), 0);
            const soon = list.reduce((a, v) => (!a || (v.nextDue || 0) < (a.nextDue || 0)) ? v : a, null);
            sum.hidden = false;
            sum.innerHTML = `
                <div class="vf-sum"><span class="vf-sum-ic"><i class="fa-solid fa-file-invoice-dollar"></i></span><div><small>${esc(t('vf_remaining'))}</small><strong>${money(owed)}</strong></div></div>
                <div class="vf-sum"><span class="vf-sum-ic"><i class="fa-solid fa-calendar-day"></i></span><div><small>${esc(t('vf_installment'))}</small><strong>${money(perCycle)}</strong></div></div>
                <div class="vf-sum"><span class="vf-sum-ic"><i class="fa-regular fa-clock"></i></span><div><small>${esc(t('vf_next_due'))}</small><strong>${soon ? esc(fmtLeft(Math.max(0, (soon.nextDue || 0) - now))) : '—'}</strong></div></div>`;
        }
        list.forEach(v => {
            const dueIn = Math.max(0, (v.nextDue || 0) - now);
            const urgent = dueIn < 3600 || v.missed > 0;
            const el = document.createElement('div');
            el.className = 'vf-veh' + (urgent ? ' urgent' : '');
            el.innerHTML = `
                <div class="vf-head">
                    <span class="vf-car-ic"><i class="fa-solid fa-car-side"></i></span>
                    <div class="vf-title">
                        <strong></strong>
                        <small>${esc(t('vf_installment'))} · ${money(v.payment)} × ${esc(v.paymentsLeft)}</small>
                    </div>
                    <span class="vf-plate">${esc(v.plate)}</span>
                </div>
                <div class="vf-due${urgent ? ' urgent' : ''}">
                    <i class="fa-regular fa-clock"></i>
                    <span>${esc(t('vf_next_due'))}</span>
                    <strong>${esc(fmtLeft(dueIn))}</strong>
                    ${v.missed ? `<span class="vf-missed"><i class="fa-solid fa-triangle-exclamation"></i> ${esc(t('vf_missed'))}: ${esc(v.missed)}</span>` : ''}
                </div>
                <div class="loan-stats vf-stats">
                    <div><span>${t('vf_remaining')}</span><strong>${money(v.owed)}</strong></div>
                    <div><span>${t('vf_payoff')}</span><strong>${money(v.payoff)}</strong></div>
                    <div><span>${t('v2_vf_left')}</span><strong>${esc(v.paymentsLeft)}</strong></div>
                </div>
                <div class="vf-actions">
                    <button class="btn btn-ghost" data-vf-pay="${esc(v.plate)}">${t('vf_pay_installment')} · ${money(v.payment)}</button>
                    <button class="btn btn-primary" data-vf-payoff="${esc(v.plate)}">${t('vf_pay_off')} · ${money(v.payoff)}</button>
                </div>`;
            el.querySelector('.vf-title strong').textContent = `${v.brand || ''} ${v.name || v.model || ''}`.trim();
            wrap.appendChild(el);
        });        const doPay = (plate, full) => post('vf_pay', { plate, full }).then(r => {
            if (r && r.ok) post('bank_force_refresh');
            refreshVehFin();
        });
        wrap.querySelectorAll('[data-vf-pay]').forEach(b =>
            b.addEventListener('click', () => doPay(b.dataset.vfPay, false)));
        wrap.querySelectorAll('[data-vf-payoff]').forEach(b =>
            b.addEventListener('click', () => doPay(b.dataset.vfPayoff, true)));
    }

    function renderOverview() {
        const a = state.account; if (!a) return;
        const agg = aggregate(state.history, a.iban);

        // KPI
        $('#kpi-in').textContent  = money(agg.totalIn);
        $('#kpi-in-delta').textContent = t(agg.txInCount === 1 ? 'js_txn_one' : 'js_txn_many', agg.txInCount);
        $('#kpi-out').textContent = money(agg.totalOut);
        $('#kpi-out-delta').textContent = t(agg.txOutCount === 1 ? 'js_txn_one' : 'js_txn_many', agg.txOutCount);
        $('#kpi-atm').textContent = money(agg.atmOut);
        $('#kpi-atm-delta').textContent = t(agg.atmCount === 1 ? 'js_session_one' : 'js_session_many', agg.atmCount);

        // Net change over the week next to the hero balance
        const delta = $('#hero-delta');
        if (delta) {
            const net = agg.totalIn - agg.totalOut;
            delta.className = 'hero-delta ' + (net > 0 ? 'up' : net < 0 ? 'down' : '');
            delta.innerHTML = `<i class="fa-solid ${net >= 0 ? 'fa-arrow-trend-up' : 'fa-arrow-trend-down'}"></i> ${net >= 0 ? '+' : '−'}${money(Math.abs(net))} · ${esc(t('ov_7d'))}`;
        }

        // Primary card (first active one, else the first)
        renderOverviewCard();

        // Chart + breakdown
        renderFlowChart($('#chart-flow'), agg.days);
        renderBreakdown($('#breakdown'), agg.breakdown);

        // Recent — grouped by day; the card scrolls internally.
        const wrap = $('#overview-tx');
        const rows = (state.history || []).slice(0, 14);
        if (!rows.length) wrap.innerHTML = `<div class="tx-empty">${t('js_ov_empty')}</div>`;
        else renderTxList(wrap, rows, txNode, a.iban);
    }

    // Realistic metal card markup, shared by the overview and Cards tab.
    function cardHTML(c, opts = {}) {
        const tail = String(c.serial || '0000').padStart(4, '0').slice(-4);
        const frozen = !!c.frozen;
        return `
            <div class="dcard${frozen ? ' frozen' : ''}">
                <div class="dcard-texture"></div>
                <div class="dcard-sheen"></div>
                <div class="dcard-top">
                    <div class="dcard-brand">DEBIT</div>
                    <div class="dcard-top-right">
                        ${opts.status === false ? '' : `<span class="dcard-status">${frozen ? t('js_card_frozen') : t('js_card_active')}</span>`}
                        <i class="fa-solid fa-wifi dcard-wifi" aria-hidden="true"></i>
                    </div>
                </div>
                <div class="dcard-chip"></div>
                <div class="dcard-number">••••&nbsp;&nbsp;••••&nbsp;&nbsp;••••&nbsp;&nbsp;${esc(tail)}</div>
                <div class="dcard-foot">
                    <div>
                        <small>${t('js_card_holder')}</small>
                        <strong>${esc(c.owner_name || '—')}</strong>
                    </div>
                    <div>
                        <small>${t('js_card_serial')}</small>
                        <strong>${esc(c.serial || '—')}</strong>
                    </div>
                    <div class="dcard-network"><span></span><span></span></div>
                </div>
            </div>`;
    }

    function renderOverviewCard() {
        const slot = $('#ov-card'), meta = $('#ov-card-meta');
        if (!slot) return;
        const cards = state.cards || [];
        const c = cards.find(x => !x.frozen) || cards[0];
        if (!c) {
            slot.innerHTML = `<button class="ov-card-empty" data-jump="cards"><i class="fa-regular fa-credit-card"></i><span>${esc(t('js_cards_empty'))}</span></button>`;
            const b = slot.querySelector('[data-jump]'); if (b) on(b, 'click', () => switchTab('cards'));
            if (meta) meta.innerHTML = '';
            return;
        }
        slot.innerHTML = cardHTML(c, { status: false });
        if (meta) {
            meta.innerHTML = `
                <div><strong>${esc(t('v2_primary_card'))}</strong><small>•••• ${esc(String(c.serial || '').slice(-4))} · ${esc(c.frozen ? t('js_card_frozen') : t('js_card_active'))}</small></div>
                <button class="btn btn-ghost btn-sm" data-jump-cards><span>${esc(t('ui_cards'))}</span> <i class="fa-solid fa-arrow-right"></i></button>`;
            const b = meta.querySelector('[data-jump-cards]'); if (b) on(b, 'click', () => switchTab('cards'));
        }
    }

    function renderHistory() {
        const wrap = $('#tx-list'); wrap.innerHTML = '';
        const filter = state.historyFilter;
        const matches = (r) => {
            if (!filter) return true;
            if (filter === 'transfer') return /transfer/.test(r.kind);
            if (filter === 'atm')      return /atm/.test(r.kind);
            if (filter === 'billing')  return /billing/.test(r.kind);
            if (filter === 'deposit')  return r.kind === 'deposit' || r.kind === 'atm_deposit';
            if (filter === 'withdraw') return r.kind === 'withdraw' || r.kind === 'atm_withdraw';
            return r.kind === filter || (filter === 'fee' && r.kind === 'fee');
        };
        const rows = (state.history || []).filter(matches);
        $('#history-count').textContent = t(rows.length === 1 ? 'js_txn_one' : 'js_txn_many', rows.length);
        if (!rows.length) wrap.innerHTML = `<div class="tx-empty">${t('js_history_empty')}</div>`;
        else renderTxList(wrap, rows, txNode, state.account?.iban);
    }

    function txNode(r) {
        const div = document.createElement('div');
        div.className = 'tx-row';
        const myIban = state.account?.iban;
        const isOut = (r.from_iban === myIban) && r.kind !== 'transfer_in';
        const isIn  = (r.to_iban === myIban) && !isOut;
        let cls = 'in', sign = '+', icon = 'fa-arrow-down';

        if (r.kind === 'fee')             { cls = 'fee'; sign = '−'; icon = 'fa-receipt'; }
        else if (/atm/.test(r.kind))      { cls = 'atm'; icon = 'fa-credit-card'; sign = isIn ? '+' : '−'; }
        else if (/billing/.test(r.kind))  { cls = isIn ? 'in' : 'out'; sign = isIn ? '+' : '−'; icon = 'fa-file-invoice-dollar'; }
        else if (/transfer/.test(r.kind)) { cls = isIn ? 'in' : 'out'; sign = isIn ? '+' : '−'; icon = isIn ? 'fa-arrow-down' : 'fa-paper-plane'; }
        else if (r.kind === 'deposit')    { cls = 'in'; sign = '+'; icon = 'fa-arrow-down'; }
        else if (r.kind === 'withdraw')   { cls = 'out'; sign = '−'; icon = 'fa-arrow-up'; }
        else if (r.kind === 'loan_grant') { cls = 'in'; sign = '+'; icon = 'fa-hand-holding-dollar'; }
        else if (r.kind === 'loan_repay') { cls = 'out'; sign = '−'; icon = 'fa-hand-holding-dollar'; }
        else if (r.kind === 'savings_in') { cls = 'out'; sign = '−'; icon = 'fa-piggy-bank'; }
        else if (r.kind === 'savings_out'){ cls = 'in'; sign = '+'; icon = 'fa-piggy-bank'; }
        else if (r.kind === 'sub_in')     { cls = 'in'; sign = '+'; icon = 'fa-briefcase'; }
        else if (r.kind === 'sub_out')    { cls = 'out'; sign = '−'; icon = 'fa-briefcase'; }

        const amountCls = sign === '+' ? 'pos' : 'neg';
        const kindLabel = cls === 'fee' ? t('hist_fees')
            : cls === 'atm' ? t('hist_atm')
            : /billing/.test(r.kind) ? t('hist_billing')
            : /transfer/.test(r.kind) ? t('hist_transfers')
            : sign === '+' ? t('hist_deposits')
            : t('hist_withdrawals');
        const d = new Date((r.ts || 0) * 1000);
        const hhmm = `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
        div.innerHTML = `
            <div class="tx-ic ${cls}"><i class="fa-solid ${icon}"></i></div>
            <div class="tx-meta">
                <div class="tx-label">${esc(r.label || r.kind)}</div>
                <div class="tx-sub">${hhmm} · ${esc(r.actor || '')}</div>
            </div>
            <span class="tx-kind">${esc(kindLabel)}</span>
            <div class="tx-amount ${amountCls}">${sign} ${money(r.amount)}</div>`;
        return div;
    }

    function renderCards() {
        const wrap = $('#card-stack'); wrap.innerHTML = '';
        if (!state.cards.length) {
            wrap.innerHTML = `<div class="tx-empty">${t('js_cards_empty')}</div>`;
            return;
        }
        state.cards.forEach(c => {
            const el = document.createElement('div');
            el.className = 'dcard-wrap';
            const frozen = !!c.frozen;
            el.innerHTML = `
                ${cardHTML(c)}
                <div class="dcard-actions">
                    <button data-act="freeze">
                        ${frozen
                            ? `<i class="fa-solid fa-sun"></i> ${t('js_card_unfreeze')}`
                            : `<i class="fa-solid fa-snowflake"></i> ${t('js_card_freeze')}`}
                    </button>
                    <button data-act="revoke" class="danger">
                        <i class="fa-solid fa-trash-can"></i> ${t('js_card_revoke')}
                    </button>
                </div>`;
            on(el.querySelector('[data-act="freeze"]'), 'click', async () => {
                await mutate('bank_card_freeze', { serial: c.serial, frozen: !c.frozen });
            });
            on(el.querySelector('[data-act="revoke"]'), 'click', async () => {
                if (await confirmDialog(t('js_card_revoke_title'), t('js_card_revoke_body'))) {
                    await mutate('bank_card_revoke', { serial: c.serial });
                }
            });
            wrap.appendChild(el);
        });

        // Ghost "issue" tile — fills the next grid slot and gives the
        // CTA a natural home next to the existing cards.
        const ghost = document.createElement('button');
        ghost.className = 'dcard-ghost';
        ghost.innerHTML = `
            <span class="dcard-ghost-ic"><i class="fa-solid fa-plus"></i></span>
            <strong>${t('js_card_issue_new')}</strong>
            <small>${t('js_card_linked_main')}</small>`;
        on(ghost, 'click', () => { const b = $('#card-issue'); if (b) b.click(); });
        wrap.appendChild(ghost);
    }

    function renderSavings() {
        const a = state.account, s = state.savings;
        const balance = (s && s.balance) || (a && a.savings) || 0;
        $('#savings-balance').textContent = money(balance);

        const rate = (Runtime.savings && Runtime.savings.ratePerTick) || 0;
        const tickM = (Runtime.savings && Runtime.savings.tickMinutes) || 60;
        const ticksPerDay = (24 * 60) / Math.max(1, tickM);
        const dayMul = Math.pow(1 + rate, ticksPerDay);
        const aprPct = ((dayMul - 1) * 365 * 100).toFixed(2);
        $('#savings-apy').textContent = `${aprPct}%`;
        // APY ring: full circle = 25% APY (keeps typical rates readable)
        const ring = $('.savings-apy-ring .ring-fill');
        if (ring) {
            const C = 2 * Math.PI * 50;
            ring.style.strokeDasharray = String(C);
            ring.style.strokeDashoffset = String(C * (1 - Math.min(1, Math.max(.02, Number(aprPct) / 25))));
        }
        $('#savings-tick').textContent = `${tickM} min`;
        $('#savings-lockin').textContent = `${(Runtime.savings && Runtime.savings.lockInMinutes) || 180} min`;

        // Projected compounding interest on the current balance — purely
        // informational, fills the "How your pot grows" panel.
        const projDay   = $('#savings-proj-day');
        const projWeek  = $('#savings-proj-week');
        const projMonth = $('#savings-proj-month');
        if (projDay)   projDay.textContent   = money(balance * (dayMul - 1));
        if (projWeek)  projWeek.textContent  = money(balance * (Math.pow(dayMul, 7)  - 1));
        if (projMonth) projMonth.textContent = money(balance * (Math.pow(dayMul, 30) - 1));

        if (s && s.openedAt) {
            const since = Math.floor((Date.now() / 1000 - s.openedAt) / 60);
            $('#savings-status').textContent = since < ((Runtime.savings && Runtime.savings.lockInMinutes) || 0)
                ? t('js_savings_locked')
                : t('js_savings_active');
        } else {
            $('#savings-status').textContent = balance > 0 ? t('js_savings_active') : t('js_savings_idle');
        }

        // Early-close warn?
        const lockMins = (Runtime.savings && Runtime.savings.lockInMinutes) || 0;
        const opened   = (s && s.openedAt) || 0;
        const stillLocked = opened > 0 && (Date.now()/1000 - opened) < lockMins * 60;
        $('#savings-warn').hidden = !stillLocked;
    }

    function renderLoans() {
        // Null-safe setter — Settings tab or Onboarding may not
        // have any of these elements present yet.
        const setText = (sel, txt) => { const el = $(sel); if (el) el.textContent = txt; };
        const setHTML = (sel, html) => { const el = $(sel); if (el) el.innerHTML = html; };

        const interest = (Runtime.loans && Runtime.loans.interestPct) || 0;
        const termDays = (Runtime.loans && Runtime.loans.termDays) || 7;

        const noEl = $('#loan-no'), activeEl = $('#loan-active');
        if (state.loan) {
            if (noEl)     noEl.hidden = true;
            if (activeEl) activeEl.hidden = false;
            setText('#loan-stat-amount',    money(state.loan.amount));
            setText('#loan-stat-interest',  money(state.loan.interest));
            setText('#loan-stat-remaining', money(state.loan.remaining));
            setText('#loan-stat-due',       fmtDate(state.loan.dueAt));

            setText('#loan-hero-title', t('js_loan_remaining', money(state.loan.remaining)));
            const total = state.loan.amount + state.loan.interest;
            const paid  = total - state.loan.remaining;
            const pct   = total > 0 ? Math.min(100, Math.max(0, (paid / total) * 100)) : 0;
            const fill  = $('#loan-hero-fill'); if (fill) fill.style.width = pct.toFixed(1) + '%';
            setHTML('#loan-hero-meta',
                t('js_loan_hero_meta', money(paid), money(total), fmtDate(state.loan.dueAt)));
        } else {
            if (noEl)     noEl.hidden = false;
            if (activeEl) activeEl.hidden = true;
            setText('#loan-hero-title', t('js_loan_no_active'));
            const fill  = $('#loan-hero-fill'); if (fill) fill.style.width = '0%';
            // Restore the canonical IDs inside the meta line so the
            // next render can find them again (innerHTML replacements
            // earlier may have wiped them).
            setHTML('#loan-hero-meta',
                t('js_loan_hero_meta_idle',
                    `<strong id="loan-interest-pct">${(interest * 100).toFixed(0)}%</strong>`,
                    `<strong id="loan-term-days">${termDays}</strong>`));
        }

        // ── Credit standing side card ──────────────────────────
        const score = state.credit && Number(state.credit.score);
        const hasScore = Number.isFinite(score) && score > 0;
        const tierFor = (s) =>
            s >= 800 ? t('js_credit_excellent') : s >= 740 ? t('js_credit_very_good') : s >= 670 ? t('js_credit_good') : s >= 580 ? t('js_credit_fair') : t('js_credit_poor');
        setText('#loan-credit-score', hasScore ? String(Math.round(score)) : '—');
        setText('#loan-credit-tier',  hasScore ? tierFor(score) : t('js_credit_no_score'));
        const arc = $('#loan-credit-arc');
        if (arc) {
            // Map a 300–850 style range onto the gauge arc; clamp for safety.
            const pct = hasScore ? Math.min(1, Math.max(0, (score - 300) / 550)) : 0;
            const LEN = 144.6;                       // π × r(46)
            arc.style.strokeDasharray  = String(LEN);
            arc.style.strokeDashoffset = String(LEN * (1 - pct));
        }
        setText('#loan-side-interest', `${(interest * 100).toFixed(0)}%`);
        setText('#loan-side-term',     `${termDays} days`);
        setText('#loan-side-status',   state.loan ? t('js_loan_status_active') : t('js_loan_no_active'));
    }

    function renderSociety() {
        const wrap = $('#sub-list'); wrap.innerHTML = '';
        if (!state.society.length) {
            wrap.innerHTML = `<div class="tx-empty">${t('js_sub_empty')}</div>`;
            return;
        }
        state.society.forEach(s => {
            const el = document.createElement('div');
            el.className = 'sub-card';
            const isOwner = s.is_owner == 1 || s.is_owner === true;
            el.innerHTML = `
                <div class="sub-card-head">
                    <div>
                        <div class="sub-name">
                            ${s.label}
                            <span class="sub-pill ${isOwner ? 'owner' : ''}">${isOwner ? t('js_sub_owner') : t('js_sub_partner')}</span>
                        </div>
                        <div class="sub-iban">${s.ibanFmt || fmtIban(s.iban)}</div>
                    </div>
                    <div class="sub-balance">${money(s.balance)}</div>
                    <div class="sub-actions">
                        <button class="btn btn-ghost btn-sm" data-act="deposit"><i class="fa-solid fa-arrow-down"></i> ${t('js_sub_in')}</button>
                        <button class="btn btn-ghost btn-sm" data-act="withdraw"><i class="fa-solid fa-arrow-up"></i> ${t('js_sub_out')}</button>
                        ${isOwner ? '<button class="btn btn-ghost btn-sm" data-act="rename"><i class="fa-solid fa-pen"></i></button>' : ''}
                        ${isOwner ? '<button class="btn btn-ghost btn-sm" data-act="disband"><i class="fa-solid fa-trash-can"></i></button>' : ''}
                    </div>
                </div>
                <div class="sub-body">
                    <div class="sub-section">
                        <h4>${t('js_sub_partners_count', (s.partners || []).length)}</h4>
                        <div class="sub-partners" data-role="partners"></div>
                        ${isOwner ? `<button class="btn btn-ghost btn-sm" data-act="add-partner" style="margin-top:8px"><i class="fa-solid fa-plus"></i> ${t('js_sub_add_partner')}</button>` : ''}
                    </div>
                    <div class="sub-section">
                        <h4>${t('js_sub_quick_info')}</h4>
                        <div class="muted" style="line-height:1.7">
                            ${t('js_sub_owner_label')} <strong style="color:var(--text-1)">${s.owner_name || '—'}</strong><br>
                            ${t('js_sub_created_label')} ${fmtDate(s.ts)}
                        </div>
                    </div>
                </div>`;
            const parts = el.querySelector('[data-role="partners"]');
            (s.partners || []).forEach(p => {
                const r = document.createElement('div');
                r.className = 'sub-partner';
                const perms = p.perms || {};
                const tags = ['view', 'deposit', 'withdraw', 'transfer', 'manage']
                    .filter(k => perms[k]).map(k => k[0].toUpperCase()).join(' · ');
                r.innerHTML = `
                    <span class="sub-partner-name">${p.partner_name}</span>
                    <span class="sub-partner-perms">${tags || '—'} · ${money(p.daily_limit || 0)}/d</span>
                    ${isOwner ? '<button class="btn btn-ghost btn-sm" data-act="rm-partner"><i class="fa-solid fa-xmark"></i></button>' : ''}`;
                if (isOwner) on(r.querySelector('[data-act="rm-partner"]'), 'click', async () => {
                    await post('bank_sub_partner_remove', { subId: s.id, identifier: p.identifier });
                });
                parts.appendChild(r);
            });

            on(el.querySelector('[data-act="deposit"]'), 'click', async () => {
                const v = await promptDialog(t('js_sub_deposit_to', s.label), t('js_cash_amount'), 'number');
                if (v) await post('bank_sub_deposit', { subId: s.id, amount: Number(v) });
            });
            on(el.querySelector('[data-act="withdraw"]'), 'click', async () => {
                const v = await promptDialog(t('js_sub_withdraw_from', s.label), t('js_cash_amount'), 'number');
                if (v) await post('bank_sub_withdraw', { subId: s.id, amount: Number(v) });
            });
            if (isOwner) {
                on(el.querySelector('[data-act="rename"]'), 'click', async () => {
                    const v = await promptDialog(t('js_sub_rename_title'), t('js_sub_rename_label'), 'text', s.label);
                    if (v == null) return;
                    await post('bank_sub_rename', { subId: s.id, label: v });
                });
                on(el.querySelector('[data-act="disband"]'), 'click', async () => {
                    if (await confirmDialog(t('js_sub_dissolve_title', s.label), t('js_sub_dissolve_body', money(s.balance)))) {
                        await post('bank_sub_disband', { subId: s.id });
                    }
                });
                on(el.querySelector('[data-act="add-partner"]'), 'click', () => addPartnerFlow(s.id));
            }
            wrap.appendChild(el);
        });
    }

    function renderBusiness() {
        const section = $('#biz-section');
        const list    = $('#biz-list');
        if (!section || !list) return;
        const rows = state.business || [];
        if (!rows.length || (Runtime.features && Runtime.features.business === false)) {
            section.hidden = true;
            list.innerHTML = '';
            return;
        }
        section.hidden = false;

        // Preserve any text the user is currently editing so a live
        // refresh from the server doesn't wipe their work.
        const dirty = {};
        list.querySelectorAll('.biz-card input[data-w], .biz-card input[data-iv], .biz-card input[id^="biz-ivl-"]').forEach(inp => {
            const card = inp.closest('.biz-card');
            const job  = card && card.dataset.job;
            if (!job) return;
            let key;
            if (inp.dataset.w !== undefined)         key = 'w:'  + inp.dataset.w;
            else if (inp.dataset.iv !== undefined)   key = 'iv:' + inp.dataset.iv;
            else if (inp.id)                         key = inp.id;
            else return;
            dirty[job] = dirty[job] || {};
            dirty[job][key] = inp.value;
        });

        list.innerHTML = '';
        rows.forEach(b => {
            const el = document.createElement('div');
            el.className = 'biz-card';
            el.dataset.job = b.job;
            const d = dirty[b.job] || {};
            const nextPay = b.nextPayAt
                ? t('js_biz_next_payroll', fmtDate(b.nextPayAt))
                : t('js_biz_payroll_idle');

            const grades = Object.entries(b.grades || {}).sort((a, c) => Number(a[0]) - Number(c[0]));
            let cycleTotal = 0;
            const gradeRows = grades.map(([gradeStr, g]) => {
                const grade = Number(gradeStr);
                // Prefer the value the user is currently typing
                // (preserved across refreshes) over server state.
                const origW = b.wages?.[gradeStr] ?? g.wage ?? 0;
                const origI = b.intervals?.[gradeStr] ?? '';
                const wage  = d['w:'  + grade] ?? origW;
                const ivl   = d['iv:' + grade] ?? origI;
                cycleTotal += Number(wage) || 0;
                const dirtyRow = String(wage) !== String(origW) || String(ivl) !== String(origI);
                return `
                    <div class="biz-wage-row${dirtyRow ? ' dirty' : ''}">
                        <span class="biz-grade">${grade}</span>
                        <span class="biz-grade-label">${esc(g.label || t('js_biz_grade_n', grade))}</span>
                        <span class="biz-wage-input">
                            <span class="pre">$</span>
                            <input type="number" data-w="${grade}" data-orig="${esc(origW)}" value="${esc(wage)}" min="0">
                        </span>
                        <span class="biz-iv-input">
                            <input type="number" data-iv="${grade}" data-orig="${esc(origI)}" value="${esc(ivl)}" min="0" placeholder="${esc(b.payInterval)}">
                            <span class="suf">min</span>
                        </span>
                    </div>`;
            }).join('');

            const now = Math.floor(Date.now() / 1000);
            const cycleS = Math.max(60, (Number(b.payInterval) || 60) * 60);
            const leftS = b.nextPayAt ? Math.max(0, b.nextPayAt - now) : 0;
            const pct = b.nextPayAt ? Math.min(100, Math.max(0, (1 - leftS / cycleS) * 100)) : 0;
            const leftTxt = !b.nextPayAt ? t('js_biz_payroll_idle')
                : leftS >= 3600 ? `${Math.floor(leftS / 3600)}h ${Math.floor((leftS % 3600) / 60)}m`
                : `${Math.max(1, Math.ceil(leftS / 60))} min`;
            const ivlNow = d['biz-ivl-' + b.job] ?? b.payInterval;
            const presets = [15, 30, 60, 120].map(m =>
                `<button class="ivl-preset${Number(ivlNow) === m ? ' active' : ''}" data-ivl-preset="${m}">${m}</button>`).join('');
            const initials = String(b.label || b.job || '?').trim().split(/\s+/).map(w => w[0] || '').join('').slice(0, 2).toUpperCase();

            el.innerHTML = `
                <div class="biz-head">
                    <div class="biz-logo">${esc(initials)}</div>
                    <div class="biz-id">
                        <div class="biz-name">${esc(b.label)}<span class="biz-pill boss"><i class="fa-solid fa-crown"></i> ${t('js_biz_boss')}</span></div>
                        <div class="biz-job">
                            <span class="biz-job-key">${esc(b.job)}</span>
                            <span class="biz-job-sep">·</span>
                            <span>${esc(nextPay)}</span>
                        </div>
                    </div>
                    <div class="biz-stats">
                        <div class="biz-stat">
                            <small>${t('v2_biz_cycle')}</small>
                            <strong data-role="cycle-total">${money(cycleTotal)}</strong>
                        </div>
                        <div class="biz-stat">
                            <small>${t('v2_biz_grades')}</small>
                            <strong>${grades.length}</strong>
                        </div>
                        <div class="biz-treasury">
                            <small>${t('js_biz_treasury')}</small>
                            <strong>${money(b.balance)}</strong>
                        </div>
                    </div>
                </div>
                <div class="biz-body">
                    <div class="biz-col">
                        <div>
                            <h4>${t('js_biz_treasury')}</h4>
                            <div class="biz-actions">
                                <button class="biz-action" data-act="deposit">
                                    <span class="biz-action-ic in"><i class="fa-solid fa-arrow-down"></i></span>
                                    <strong>${t('js_biz_deposit')}</strong><small>${t('v2_biz_dep_sub')}</small>
                                </button>
                                <button class="biz-action" data-act="withdraw">
                                    <span class="biz-action-ic out"><i class="fa-solid fa-arrow-up"></i></span>
                                    <strong>${t('js_biz_withdraw')}</strong><small>${t('v2_biz_wd_sub')}</small>
                                </button>
                                <button class="biz-action primary" data-act="bonus">
                                    <span class="biz-action-ic"><i class="fa-solid fa-gift"></i></span>
                                    <strong>${t('js_biz_bonus')}</strong><small>${t('v2_biz_bonus_sub')}</small>
                                </button>
                            </div>
                        </div>

                        <div class="biz-payroll">
                            <div class="biz-payroll-top">
                                <span class="biz-payroll-ic"><i class="fa-regular fa-clock"></i></span>
                                <div>
                                    <small>${t('v2_biz_next')}</small>
                                    <strong>${esc(leftTxt)}</strong>
                                </div>
                                <span class="chip">${t('js_biz_interval')} · ${esc(b.payInterval)} min</span>
                            </div>
                            <div class="biz-payroll-bar"><span style="width:${pct.toFixed(1)}%"></span></div>
                        </div>

                        <div>
                            <h4>${t('js_biz_default_pay_interval')}</h4>
                            <div class="biz-interval-row">
                                <div class="ivl-presets">${presets}</div>
                                <span class="biz-interval-input">
                                    <input type="number" id="biz-ivl-${b.job}" value="${esc(ivlNow)}" min="${Runtime.business?.minPayInterval || 5}" max="${Runtime.business?.maxPayInterval || 1440}">
                                    <span class="biz-interval-suffix">min</span>
                                </span>
                                <button class="btn btn-ghost btn-sm" data-act="set-interval"><i class="fa-solid fa-check"></i> ${t('js_biz_apply')}</button>
                            </div>
                        </div>
                    </div>

                    <div class="biz-col biz-wages-col">
                        <h4>${t('js_biz_wages_interval')}</h4>
                        <div class="biz-table">
                            <div class="biz-wages-head">
                                <span></span>
                                <span>${t('js_biz_grade')}</span>
                                <span class="ta-r">${t('js_biz_wage')}</span>
                                <span class="ta-r">${t('js_biz_interval')}</span>
                            </div>
                            <div class="biz-wages">${gradeRows || `<div class="muted">${t('js_biz_no_grades')}</div>`}</div>
                        </div>
                        <div class="biz-save-row">
                            <span class="biz-unsaved" data-role="unsaved" hidden><i class="fa-solid fa-circle"></i> ${t('v2_biz_unsaved')}</span>
                            <span class="biz-total">${t('v2_biz_cycle')}: <strong data-role="cycle-total2">${money(cycleTotal)}</strong></span>
                            <button class="btn btn-primary" data-act="save-wages"><i class="fa-solid fa-floppy-disk"></i> ${t('js_biz_save_changes')}</button>
                        </div>
                    </div>
                </div>`;

            // live dirty state + per-cycle total while the boss types
            const syncDirty = () => {
                let total = 0, any = false;
                el.querySelectorAll('.biz-wage-row').forEach(row => {
                    const w = row.querySelector('input[data-w]'), iv = row.querySelector('input[data-iv]');
                    total += Number(w.value) || 0;
                    const dr = w.value !== w.dataset.orig || iv.value !== iv.dataset.orig;
                    row.classList.toggle('dirty', dr);
                    if (dr) any = true;
                });
                el.querySelectorAll('[data-role="cycle-total"], [data-role="cycle-total2"]').forEach(x => { x.textContent = money(total); });
                const u = el.querySelector('[data-role="unsaved"]'); if (u) u.hidden = !any;
                el.classList.toggle('has-dirty', any);
            };
            el.querySelectorAll('.biz-wage-row input').forEach(inp => on(inp, 'input', syncDirty));
            syncDirty();
            el.querySelectorAll('[data-ivl-preset]').forEach(bt => on(bt, 'click', () => {
                const inp = el.querySelector('#biz-ivl-' + b.job);
                if (inp) inp.value = bt.dataset.ivlPreset;
                el.querySelectorAll('[data-ivl-preset]').forEach(x => x.classList.toggle('active', x === bt));
            }));
            // Belt-and-braces: every business mutation triggers an
            // explicit refresh after the server reply lands, so the
            // UI repaints even if the server's broadcast event is
            // delayed by the framework.
            const mutate = async (name, payload) => {
                const r = await post(name, payload);
                await post('bank_force_refresh');
                return r;
            };

            on(el.querySelector('[data-act="deposit"]'), 'click', async () => {
                const v = await promptDialog(t('js_biz_deposit_dot', b.label), t('js_cash_amount'), 'number');
                if (v) await mutate('bank_biz_deposit', { job: b.job, amount: Number(v) });
            });
            on(el.querySelector('[data-act="withdraw"]'), 'click', async () => {
                const v = await promptDialog(t('js_biz_withdraw_dot', b.label), t('js_amount'), 'number');
                if (v) await mutate('bank_biz_withdraw', { job: b.job, amount: Number(v) });
            });
            on(el.querySelector('[data-act="bonus"]'), 'click', () => bonusFlow(b));
            on(el.querySelector('[data-act="set-interval"]'), 'click', async () => {
                const v = Number(el.querySelector('#biz-ivl-' + b.job).value);
                if (!v) return;
                await mutate('bank_biz_set_interval', { job: b.job, minutes: v });
            });
            on(el.querySelector('[data-act="save-wages"]'), 'click', async () => {
                // SNAPSHOT the values FIRST so mid-save refreshes
                // (which would rebuild the DOM) can't lose data.
                const wagesPayload = [];
                const ivlPayload   = [];
                el.querySelectorAll('input[data-w]').forEach(inp => {
                    wagesPayload.push({
                        grade: Number(inp.dataset.w),
                        wage:  Number(inp.value) || 0,
                    });
                });
                el.querySelectorAll('input[data-iv]').forEach(inp => {
                    ivlPayload.push({
                        grade:   Number(inp.dataset.iv),
                        minutes: inp.value === '' ? 0 : Number(inp.value),
                    });
                });

                // Fire all updates in parallel — the dom won't be
                // touched between them because we already snapshotted.
                await Promise.all([
                    ...wagesPayload.map(p => post('bank_biz_set_wage', {
                        job: b.job, grade: p.grade, wage: p.wage,
                    })),
                    ...ivlPayload.map(p => post('bank_biz_set_grade_interval', {
                        job: b.job, grade: p.grade, minutes: p.minutes,
                    })),
                ]);
                await post('bank_force_refresh');
                Notify({ type: 'success', message: t('js_biz_wages_saved') });
            });

            list.appendChild(el);
        });
    }

    function invoiceStatusLabel(status) {
        return ({
            sent: t('js_inv_status_pending'),
            paid: t('js_inv_status_paid'),
            declined: t('js_inv_status_declined'),
            expired: t('js_inv_status_expired'),
            cancelled: t('js_inv_status_cancelled'),
            draft: t('js_inv_status_draft'),
        })[status] || status || t('js_inv_status_unknown');
    }

    function billingReason(why) {
        return ({
            no_funds: t('js_bill_no_funds'),
            no_society_funds: t('js_bill_no_society_funds'),
            no_perm: t('js_bill_no_perm'),
            not_found: t('js_bill_not_found'),
            already_paid: t('js_bill_already_paid'),
            expired: t('js_bill_expired'),
            bad_state: t('js_bill_bad_state'),
            method_disabled: t('js_bill_method_disabled'),
            billing_missing: t('js_bill_billing_missing'),
            billing_error: t('js_bill_billing_error'),
        })[why] || t('js_bill_op_failed');
    }

    async function payBillingInvoice(inv, method) {
        const body = method === 'society'
            ? t('js_bill_pay_society_body', money(inv.total))
            : t('js_bill_pay_bank_body', money(inv.total));
        if (!await confirmDialog(t('js_bill_pay_title', (inv.number || inv.id)), body)) return;

        const r = await mutate('bank_billing_pay', { id: inv.id, method });
        if (r && r.ok) {
            Sound('cashOut');
            Notify({ type: 'success', message: t('js_bill_paid_toast') });
        } else {
            Sound('error');
            Notify({ type: 'error', message: billingReason(r && r.why) });
        }
    }

    async function declineBillingInvoice(inv) {
        if (!await confirmDialog(t('js_bill_decline_title', (inv.number || inv.id)), t('js_bill_decline_body'))) return;

        const r = await mutate('bank_billing_decline', { id: inv.id });
        if (r && r.ok) Notify({ type: 'info', message: t('js_bill_declined_toast') });
        else Notify({ type: 'error', message: billingReason(r && r.why) });
    }

    function renderBillingRows(target, rows, mode) {
        const wrap = $(target);
        if (!wrap) return;
        rows = rows || [];
        if (!rows.length) {
            const msg = mode === 'personal'
                ? t('js_bill_empty_personal')
                : mode === 'society'
                    ? t('js_bill_empty_society')
                    : t('js_bill_empty_sent');
            wrap.innerHTML =
                `<div class="billing-empty">
                    <span class="billing-empty-ic"><i class="fa-solid fa-inbox"></i></span>
                    <span>${msg}</span>
                </div>`;
            return;
        }

        wrap.innerHTML = '';
        rows.forEach(inv => {
            const row = document.createElement('div');
            row.className = 'billing-row';
            const isPending = inv.status === 'sent';
            const primary = mode === 'sent'
                ? t('js_bill_row_to', esc(inv.recipient_name || inv.recipient_id || '—'))
                : t('js_bill_row_from', esc(inv.issuer_name || '—'));
            const sentBy = mode === 'sent' && inv.issued_by_name
                ? t('js_bill_row_by', esc(inv.issued_by_name))
                : '';

            let actions = '';
            if (mode === 'personal' && isPending) {
                actions = `
                    <div class="billing-actions">
                        <button class="btn btn-danger btn-sm" data-act="decline"><i class="fa-solid fa-xmark"></i> ${t('js_bill_decline_btn')}</button>
                        <button class="btn btn-primary btn-sm" data-act="pay"><i class="fa-solid fa-credit-card"></i> ${t('js_bill_pay_btn')}</button>
                    </div>`;
            } else if (mode === 'society' && isPending) {
                actions = `
                    <div class="billing-actions">
                        <button class="btn btn-primary btn-sm" data-act="pay-society"><i class="fa-solid fa-briefcase"></i> ${t('js_bill_pay_treasury_btn')}</button>
                    </div>`;
            }

            row.innerHTML = `
                <div class="billing-ic"><i class="fa-solid fa-file-invoice-dollar"></i></div>
                <div class="billing-meta">
                    <strong>${esc(inv.title || t('js_bill_default_title'))} · <code>#${esc(inv.number || inv.id)}</code></strong>
                    <small>${primary}${sentBy} · ${t('js_bill_due', fmtDate(Number(inv.due_at) || 0))}</small>
                </div>
                <div class="billing-amount">${money(inv.total)}</div>
                <div class="billing-status ${esc(inv.status || '')}">${invoiceStatusLabel(inv.status)}</div>
                ${actions}`;

            const pay = row.querySelector('[data-act="pay"]');
            if (pay) on(pay, 'click', () => payBillingInvoice(inv, 'bank'));
            const paySociety = row.querySelector('[data-act="pay-society"]');
            if (paySociety) on(paySociety, 'click', () => payBillingInvoice(inv, 'society'));
            const decline = row.querySelector('[data-act="decline"]');
            if (decline) on(decline, 'click', () => declineBillingInvoice(inv));

            wrap.appendChild(row);
        });
    }

    function renderBilling() {
        const data = state.billing || {};
        const enabled = !!data.enabled;
        const nav = $('#nav-billing');
        if (nav) nav.hidden = !enabled;
        if (!enabled) return;

        const personal = data.received || [];
        const societyReceived = data.societyReceived || [];
        const societySent = data.societySent || [];
        const pendingPersonal = personal.filter(inv => inv.status === 'sent');
        const pendingSociety = societyReceived.filter(inv => inv.status === 'sent');
        const sum = rows => rows.reduce((n, inv) => n + (Number(inv.total) || 0), 0);

        $('#billing-personal-due').textContent = money(sum(pendingPersonal));
        $('#billing-personal-count').textContent = t('js_bill_pending_count', pendingPersonal.length);
        $('#billing-society-due').textContent = money(sum(pendingSociety));
        $('#billing-society-count').textContent = data.job ? t('js_bill_pending_count', pendingSociety.length) : t('js_bill_boss_access_only');
        $('#billing-sent-count').textContent = t(societySent.length === 1 ? 'js_invoice_one' : 'js_invoice_many', societySent.length);
        $('#billing-job-label').textContent = data.job ? t('js_bill_boss_view', (data.job.label || data.job.name)) : t('js_bill_no_boss_access');

        const societySection = $('#billing-society-section');
        const sentSection = $('#billing-sent-section');
        if (societySection) societySection.hidden = !data.job;
        if (sentSection) sentSection.hidden = !data.job;

        renderBillingRows('#billing-personal-list', personal, 'personal');
        if (data.job) {
            renderBillingRows('#billing-society-list', societyReceived, 'society');
            renderBillingRows('#billing-sent-list', societySent, 'sent');
        }
    }

    async function bonusFlow(biz) {
        const overlay = $('#input-overlay');
        const fields  = $('#input-fields');
        $('#input-title').textContent = t('js_bonus_title', biz.label);
        fields.innerHTML = '';
        const wrap = document.createElement('div');
        wrap.style.cssText = 'display:flex;flex-direction:column;gap:10px';
        wrap.innerHTML = `
            <div class="form-row">
                <label>${t('js_bonus_recipient')}</label>
                <select class="apex-input" id="bonus-target"></select>
            </div>
            <div class="form-row">
                <label>${t('js_amount')}</label>
                <div class="amount-input">
                    <span class="amount-symbol">$</span>
                    <input type="number" min="1" class="apex-input mono" id="bonus-amount" placeholder="0">
                </div>
            </div>
            <div class="form-row">
                <label>${t('js_bonus_reason')}</label>
                <input class="apex-input" id="bonus-reason" placeholder="${t('js_bonus_reason_ph')}">
            </div>
            <button class="btn btn-primary btn-block" id="bonus-send">
                <i class="fa-solid fa-gift"></i> ${t('js_bonus_send')}
            </button>`;
        fields.appendChild(wrap);
        overlay.hidden = false;

        // Roster
        const rosterRes = await post('bank_biz_roster', { job: biz.job });
        const roster = (rosterRes && rosterRes.data) || [];
        const sel = wrap.querySelector('#bonus-target');
        if (!roster.length) {
            sel.innerHTML = `<option value="">${t('js_no_employees_online')}</option>`;
        } else {
            sel.innerHTML = roster.map(r =>
                `<option value="${r.source}">${t('js_bonus_roster_opt', r.name, r.grade)}</option>`).join('');
        }
        on(wrap.querySelector('#bonus-send'), 'click', async () => {
            const target = Number(sel.value);
            const amount = Number(wrap.querySelector('#bonus-amount').value);
            const reason = wrap.querySelector('#bonus-reason').value;
            if (!target || !amount) return;
            overlay.hidden = true;
            const r = await post('bank_biz_bonus', { job: biz.job, target, amount, reason });
            if (!r.ok) Notify({ type: 'error', message: t('js_bonus_failed', (r.why || 'unknown')) });
        });
    }

    function renderContacts() {
        const wrap = $('#contact-list'); wrap.innerHTML = '';
        const seen = new Set();
        const contacts = [];
        (state.history || []).forEach(r => {
            const iban = r.from_iban === state.account?.iban ? r.to_iban : r.from_iban;
            if (!iban || iban === state.account?.iban || seen.has(iban)) return;
            seen.add(iban);
            const name = r.kind === 'transfer_out' ? (r.actor || iban) : (r.actor || iban);
            contacts.push({ iban, name });
        });
        if (!contacts.length) {
            wrap.innerHTML = `<div class="tx-empty">${t('js_contacts_empty')}</div>`;
            return;
        }
        contacts.slice(0, 8).forEach(c => {
            const row = document.createElement('div');
            row.className = 'contact-row';
            const initials = (c.name || c.iban || '?').slice(0, 2).toUpperCase();
            row.innerHTML = `
                <div class="contact-avatar">${initials}</div>
                <div class="contact-info">
                    <strong>${c.name}</strong>
                    <code>${fmtIban(c.iban)}</code>
                </div>
                <i class="fa-solid fa-arrow-right" style="color:var(--text-3)"></i>`;
            on(row, 'click', () => {
                switchTab('transfer');
                $('#tx-to').value = fmtIban(c.iban);
                $('#tx-to').dispatchEvent(new Event('input'));
            });
            wrap.appendChild(row);
        });
    }

    async function addPartnerFlow(subId) {
        const r = await post('bank_sub_partner_add', {});
        const nearby = (r && r.data && r.data.nearby) || [];
        const overlay = document.getElementById('input-overlay');
        const fields = document.getElementById('input-fields');
        $('#input-title').textContent = t('js_add_partner');
        fields.innerHTML = '';

        // Two tabs: Nearby players (default) + by IBAN.
        const wrap = document.createElement('div');
        wrap.className = 'partner-picker';
        wrap.innerHTML = `
            <div class="partner-tabs">
                <button class="partner-tab active" data-pt="nearby"><i class="fa-solid fa-people-arrows"></i> ${t('js_pp_nearby')}</button>
                <button class="partner-tab"        data-pt="iban"><i class="fa-solid fa-id-card"></i> ${t('js_pp_by_iban')}</button>
            </div>
            <div class="partner-body" data-body="nearby"></div>
            <div class="partner-body" data-body="iban" hidden>
                <div class="form-row">
                    <label>${t('js_pp_recipient_iban')}</label>
                    <input class="apex-input mono" id="pp-iban" placeholder="AP 1234 5678 90" spellcheck="false">
                </div>
                <div class="tx-resolve" id="pp-resolve" hidden>
                    <i class="fa-solid fa-circle-check"></i>
                    <span id="pp-name">—</span>
                    <small>${t('js_pp_main_account')}</small>
                </div>
                <div class="tx-resolve bad" id="pp-bad" hidden>
                    <i class="fa-solid fa-circle-xmark"></i>
                    <span id="pp-bad-msg">${t('js_pp_iban_not_found')}</span>
                </div>
                <button class="btn btn-primary btn-block" id="pp-add-iban" disabled>
                    <i class="fa-solid fa-user-plus"></i> ${t('js_add_partner')}
                </button>
            </div>`;
        fields.appendChild(wrap);

        // Tab switcher
        wrap.querySelectorAll('.partner-tab').forEach(t => on(t, 'click', () => {
            wrap.querySelectorAll('.partner-tab').forEach(x => x.classList.toggle('active', x === t));
            wrap.querySelectorAll('.partner-body').forEach(b => {
                b.hidden = b.dataset.body !== t.dataset.pt;
            });
        }));

        // Nearby tab content
        const nearbyBody = wrap.querySelector('[data-body="nearby"]');
        if (!nearby.length) {
            nearbyBody.innerHTML = `<div class="tx-empty">${t('js_pp_no_nearby')}</div>`;
        } else {
            const list = document.createElement('div');
            list.style.cssText = 'display:flex;flex-direction:column;gap:6px';
            nearby.forEach(n => {
                const b = document.createElement('button');
                b.className = 'btn btn-ghost btn-block';
                b.style.justifyContent = 'flex-start';
                b.innerHTML = `<i class="fa-solid fa-user"></i> <span style="flex:1;text-align:left">${n.name}</span> <small style="opacity:.6">#${n.source}</small>`;
                on(b, 'click', async () => {
                    overlay.hidden = true;
                    const perms = { view: true, deposit: true, withdraw: false, transfer: false, manage: false };
                    const r2 = await post('bank_sub_partner_commit', {
                        subId, target: n.source, perms, dailyLimit: 0,
                    });
                    if (!r2.ok) {
                        Notify({ type: 'error',
                            message: r2.why === 'self' ? t('js_pp_self')
                                  :  r2.why === 'exists' ? t('js_pp_player_exists')
                                  :  t('js_pp_add_failed') });
                    }
                });
                list.appendChild(b);
            });
            nearbyBody.appendChild(list);
        }

        // IBAN tab live resolver
        let resolved = null, lookupTimer;
        const ibanInput  = wrap.querySelector('#pp-iban');
        const okBox      = wrap.querySelector('#pp-resolve');
        const badBox     = wrap.querySelector('#pp-bad');
        const addBtn     = wrap.querySelector('#pp-add-iban');
        on(ibanInput, 'input', () => {
            clearTimeout(lookupTimer);
            const raw = ibanInput.value.replace(/\s+/g, '');
            if (raw.length < 6) {
                resolved = null;
                okBox.hidden = true; badBox.hidden = true;
                addBtn.disabled = true; return;
            }
            lookupTimer = setTimeout(async () => {
                const r2 = await post('bank_iban_lookup', { iban: raw });
                if (r2 && r2.data) {
                    // Block self
                    if (state.account && r2.data.iban === state.account.iban) {
                        resolved = null;
                        okBox.hidden = true;
                        badBox.hidden = false;
                        wrap.querySelector('#pp-bad-msg').textContent = t('js_pp_self');
                        addBtn.disabled = true;
                        return;
                    }
                    if (r2.data.kind !== 'main') {
                        resolved = null;
                        okBox.hidden = true;
                        badBox.hidden = false;
                        wrap.querySelector('#pp-bad-msg').textContent = t('js_pp_only_personal');
                        addBtn.disabled = true;
                        return;
                    }
                    resolved = r2.data;
                    wrap.querySelector('#pp-name').textContent = r2.data.ownerName || '—';
                    okBox.hidden = false; badBox.hidden = true;
                    addBtn.disabled = false;
                } else {
                    resolved = null;
                    okBox.hidden = true;
                    badBox.hidden = false;
                    wrap.querySelector('#pp-bad-msg').textContent = t('js_pp_iban_not_found');
                    addBtn.disabled = true;
                }
            }, 220);
        });
        on(addBtn, 'click', async () => {
            if (!resolved) return;
            overlay.hidden = true;
            const perms = { view: true, deposit: true, withdraw: false, transfer: false, manage: false };
            const r3 = await post('bank_sub_partner_commit', {
                subId, iban: resolved.iban, perms, dailyLimit: 0,
            });
            if (!r3.ok) {
                Notify({ type: 'error',
                    message: r3.why === 'self' ? t('js_pp_self')
                          :  r3.why === 'exists' ? t('js_pp_iban_exists')
                          :  t('js_pp_add_failed') });
            }
        });

        overlay.hidden = false;
    }

    // ─── Bind UI ─────────────────────────────────────────
    on($('#bank-nav'), 'click', (e) => {
        const b = e.target.closest('.nav-item'); if (!b) return;
        Sound('select');
        switchTab(b.dataset.tab);
        if (b.dataset.tab === 'history') renderHistory();
        if (b.dataset.tab === 'settings') {
            try { initPersonalControls(); } catch (_) {}
            try { initAdminControls();    } catch (_) {}
        }
    });
    on($('#bank-close'),   'click', () => { Sound('back'); close(); });
    on($('#bank-refresh'), 'click', () => post('bank_refresh'));

    on($('#overview-eye'), 'click', () => {
        state.balanceHidden = !state.balanceHidden;
        Privacy.set(state.balanceHidden);
        const ico = $('#overview-eye i');
        if (ico) ico.className = state.balanceHidden ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
        try { renderSnapshot(); } catch (_) {}
        try { renderOverview(); } catch (_) {}
        try { renderHistory();  } catch (_) {}
        try { renderSavings();  } catch (_) {}
        try { renderLoans();    } catch (_) {}
        try { renderSociety();  } catch (_) {}
        try { renderBilling();  } catch (_) {}
    });

    on(document.querySelector('.quick-strip'), 'click', async (e) => {
        const b = e.target.closest('.quick-tile'); if (!b) return;
        if (b.dataset.quick === 'deposit') {
            const v = await promptDialog(t('js_quick_deposit_title'), t('js_quick_deposit_body'), 'number');
            if (v) await post('bank_deposit', { amount: Number(v) });
        } else if (b.dataset.quick === 'withdraw') {
            const v = await promptDialog(t('js_quick_withdraw_title'), t('js_quick_withdraw_body'), 'number');
            if (v) await post('bank_withdraw', { amount: Number(v) });
        } else if (b.dataset.quick === 'transfer') switchTab('transfer');
        else if (b.dataset.quick === 'card') await post('bank_card_issue');
    });
    on($('#hero-copy'), 'click', () => {
        const i = state.account && state.account.iban;
        if (i) {
            navigator.clipboard?.writeText(i);
            Notify({ type: 'info', message: t('js_iban_copied') });
        }
    });
    $$('[data-jump-tab]').forEach(b => on(b, 'click', () => switchTab(b.dataset.jumpTab)));

    // Transfer
    // Live "receipt" on the right: recipient + amount follow the form.
    const setPreviewParty = (name, iban) => {
        const av = $('#txp-avatar'), nm = $('#txp-name'), ib = $('#txp-iban');
        if (nm) nm.textContent = name || '—';
        if (ib) ib.textContent = iban ? fmtIban(iban) : '—';
        if (av) {
            const ini = name ? String(name).trim().split(/\s+/).map(w => w[0] || '').join('').slice(0, 2).toUpperCase() : '';
            av.classList.toggle('on', !!name);
            av.innerHTML = ini ? esc(ini) : '<i class="fa-solid fa-user"></i>';
        }
    };
    let resolveTimer;
    on($('#tx-to'), 'input', () => {
        clearTimeout(resolveTimer);
        resolveTimer = setTimeout(async () => {
            const v = $('#tx-to').value.replace(/\s+/g, '');
            if (!v || v.length < 6) {
                $('#tx-resolve').hidden = true;
                $('#tx-resolve-bad').hidden = true;
                $('#tx-send').disabled = true;
                setPreviewParty(null, null);
                return;
            }
            const r = await post('bank_transfer_resolve', { iban: v });
            if (r && r.data) {
                $('#tx-resolve').hidden = false; $('#tx-resolve-bad').hidden = true;
                $('#tx-resolve-name').textContent = r.data.ownerName || '—';
                const labels = { sub: t('js_tx_label_sub'), business: t('js_tx_label_business'), main: t('js_tx_label_main') };
                $('#tx-resolve-label').textContent = labels[r.data.kind] || t('js_tx_label_main');
                $('#tx-send').disabled = false;
                setPreviewParty(r.data.ownerName || '—', v);
            } else {
                $('#tx-resolve').hidden = true; $('#tx-resolve-bad').hidden = false;
                $('#tx-send').disabled = true;
                setPreviewParty(null, null);
            }
        }, 250);
    });
    const updateTxSummary = () => {
        const amount = Math.max(0, Math.floor(Number($('#tx-amount').value) || 0));
        const fees = Runtime.fees || {};
        const fee = Math.floor((fees.transferDomestic || 0) + amount * (fees.transferPct || 0));
        $('#ts-amount').textContent = money(amount);
        $('#ts-fee').textContent = money(fee);
        $('#ts-total').textContent = money(amount + fee);
        const big = $('#txp-amount'); if (big) big.textContent = money(amount);
    };
    on($('#tx-amount'), 'input', updateTxSummary);
    $$('.amount-presets [data-add]').forEach(b => {
        on(b, 'click', () => {
            $('#tx-amount').value = (Number($('#tx-amount').value) || 0) + Number(b.dataset.add);
            updateTxSummary();
        });
    });
    on($('#tx-send'), 'click', async () => {
        const r = await post('bank_transfer_send', {
            fromIban: $('#tx-from').value,
            toIban: $('#tx-to').value.replace(/\s+/g, ''),
            amount: Number($('#tx-amount').value),
            reason: $('#tx-reason').value || t('js_tx_default_reason'),
        });
        if (r.ok) {
            Sound('cashIn');
            $('#tx-to').value = ''; $('#tx-amount').value = ''; $('#tx-reason').value = '';
            $('#tx-resolve').hidden = true; $('#tx-send').disabled = true;
            setPreviewParty(null, null);
            updateTxSummary();
        } else {
            Sound('error');
            Notify({ type: 'error', message: t('js_transfer_failed', (r.why || 'unknown')) });
        }
    });

    // Cards
    on($('#card-issue'), 'click', async () => await post('bank_card_issue'));

    // Savings
    $$('[data-savings-add]').forEach(b => on(b, 'click', () => {
        $('#savings-amount').value = (Number($('#savings-amount').value) || 0) + Number(b.dataset.savingsAdd);
    }));
    on($('#savings-deposit'), 'click', async () => {
        const v = Number($('#savings-amount').value); if (!v) return;
        const r = await post('bank_savings_open', { amount: v });
        if (r.ok) $('#savings-amount').value = '';
    });
    on($('#savings-close'), 'click', async () => {
        if (await confirmDialog(t('js_savings_close_title'), t('js_savings_close_body'))) {
            await post('bank_savings_close');
        }
    });

    // Loans
    $$('[data-loan-add]').forEach(b => on(b, 'click', () => {
        $('#loan-amount').value = (Number($('#loan-amount').value) || 0) + Number(b.dataset.loanAdd);
        $('#loan-amount').dispatchEvent(new Event('input'));
    }));
    const updateLoanSummary = () => {
        const amt = Math.max(0, Math.floor(Number($('#loan-amount').value) || 0));
        const pct = (Runtime.loans && Runtime.loans.interestPct) || 0;
        const interest = Math.floor(amt * pct);
        $('#ls-amount').textContent = money(amt);
        $('#ls-interest').textContent = money(interest);
        $('#ls-total').textContent = money(amt + interest);
    };
    on($('#loan-amount'), 'input', updateLoanSummary);
    on($('#loan-take'), 'click', async () => {
        const v = Number($('#loan-amount').value); if (!v) return;
        const r = await mutate('bank_loan_take', { amount: v });
        if (r.ok) { $('#loan-amount').value = ''; updateLoanSummary(); }
    });
    // Repay quick-amounts: fill the input with a % of the outstanding
    // balance (25 / 50 / 100), capped at what's actually owed.
    $$('[data-repay-pct]').forEach(b => on(b, 'click', () => {
        const remaining = (state.loan && Number(state.loan.remaining)) || 0;
        const pct = Number(b.dataset.repayPct) || 0;
        const amt = Math.max(0, Math.floor(remaining * pct / 100));
        const input = $('#loan-repay-amount');
        if (input) { input.value = amt || ''; input.dispatchEvent(new Event('input')); }
    }));
    on($('#loan-repay'), 'click', async () => {
        const v = Number($('#loan-repay-amount').value); if (!v) return;
        const r = await mutate('bank_loan_repay', { amount: v });
        if (r.ok) $('#loan-repay-amount').value = '';
    });

    // Society
    on($('#sub-new'), 'click', async () => {
        const v = await promptDialog(t('js_sub_new_title'), t('js_sub_new_label'), 'text');
        if (v == null) return;
        await mutate('bank_sub_create', { label: v });
    });

    // History filter
    on($('#history-filter'), 'click', (e) => {
        const b = e.target.closest('.hf-pill'); if (!b) return;
        $$('.hf-pill').forEach(x => x.classList.remove('active'));
        b.classList.add('active');
        state.historyFilter = b.dataset.kind || '';
        renderHistory();
    });

    // Bank search (filters history list inline)
    on($('#bank-search'), 'input', () => {
        const q = $('#bank-search').value.toLowerCase();
        if (!q) { switchTab(state.currentTab); return; }
        switchTab('history');
        const filtered = (state.history || []).filter(r =>
            (r.label || '').toLowerCase().includes(q)
            || (r.from_iban || '').toLowerCase().includes(q)
            || (r.to_iban || '').toLowerCase().includes(q)
            || (r.actor || '').toLowerCase().includes(q)
        );
        const wrap = $('#tx-list'); wrap.innerHTML = '';
        $('#history-count').textContent = t('js_search_match_count', filtered.length);
        if (!filtered.length) wrap.innerHTML = `<div class="tx-empty">${t('js_search_no_matches')}</div>`;
        else renderTxList(wrap, filtered, txNode, state.account?.iban);
    });

    // Settings
    on($('#set-pin'), 'click', async () => {
        const v = await promptDialog(t('js_pin_change_title'), t('js_pin_change_body', ((Runtime.pin && Runtime.pin.length) || 4)), 'pin');
        if (v == null) return;
        const r = await post('bank_set_pin', { pin: v });
        if (!r.ok) Notify({ type: 'error', message: t('js_pin_change_failed') });
        else Notify({ type: 'success', message: t('js_pin_updated') });
    });
    on($('#set-iban'), 'click', async () => {
        const fee = (Runtime.fees && Runtime.fees.changeIban) || 0;
        if (await confirmDialog(t('js_rotate_iban_title'), t('js_rotate_iban_body', money(fee)))) {
            await post('bank_rotate_iban');
        }
    });

    // Persistent "Privacy mode" toggle in Settings — flipping it
    // here is identical to clicking the eye in Overview, but the
    // value is stored locally so it sticks across reopens.
    on($('#set-privacy'), 'change', (e) => {
        const v = e.target.checked;
        state.balanceHidden = v;
        Privacy.set(v);
        savePersonal({ privacy: v });
        const eye = $('#overview-eye i');
        if (eye) eye.className = v ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
        try { renderSnapshot(); } catch (_) {}
        try { renderOverview(); } catch (_) {}
        try { renderHistory();  } catch (_) {}
        try { renderSavings();  } catch (_) {}
        try { renderLoans();    } catch (_) {}
        try { renderSociety();  } catch (_) {}
        try { renderBilling();  } catch (_) {}
    });

    // ─── Theme & Size (personal + admin) ──────────────────
    const DEFAULT_BRAND = '#1F5EFF';
    const COLOR_PRESETS = [
        '#1F5EFF', '#8D21E8', '#FF4F8B', '#FFA940', '#FFD43B',
        '#34C77B', '#1FB3B5', '#4E9CE5', '#E5564B', '#A8A8AD',
    ];

    // Background base tones (≈ surface-1 level). The full surface/line
    // ramp is derived from whichever the player picks; #131314 is the
    // stock neutral charcoal.
    const DEFAULT_BG = '#131314';
    const BG_PRESETS = [
        '#131314', '#0A0A0B', '#0E1320', '#101A16', '#191020',
        '#1A1410', '#101719', '#1C1014', '#0D1117', '#15131A',
    ];

    // ── Colour math helpers ──────────────────────────────
    // Convert any CSS hex to HSL, then build the whole brand
    // ramp (50/100/200/300/400/500/600/700/800/900) by walking
    // lightness, plus the rgba(brand,alpha) variants used across
    // the stylesheet. Result: every "blue" pixel (button, glow,
    // border accent) re-tints to whatever the user picks.
    const _clamp = (v, lo, hi) => Math.max(lo, Math.min(hi, v));
    function hexToRgb(hex) {
        const h = hex.replace('#', '');
        const n = h.length === 3
            ? h.split('').map(c => c + c).join('')
            : h;
        return {
            r: parseInt(n.slice(0, 2), 16),
            g: parseInt(n.slice(2, 4), 16),
            b: parseInt(n.slice(4, 6), 16),
        };
    }
    function rgbToHsl({ r, g, b }) {
        r/=255; g/=255; b/=255;
        const mx = Math.max(r,g,b), mn = Math.min(r,g,b);
        let h, s, l = (mx + mn) / 2;
        if (mx === mn) { h = s = 0 }
        else {
            const d = mx - mn;
            s = l > .5 ? d / (2 - mx - mn) : d / (mx + mn);
            switch (mx) {
                case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                case g: h = (b - r) / d + 2; break;
                case b: h = (r - g) / d + 4; break;
            }
            h /= 6;
        }
        return { h: h * 360, s: s * 100, l: l * 100 };
    }
    function hslToHex(h, s, l) {
        h /= 360; s /= 100; l /= 100;
        const hue2rgb = (p, q, t) => {
            if (t < 0) t += 1; if (t > 1) t -= 1;
            if (t < 1/6) return p + (q - p) * 6 * t;
            if (t < 1/2) return q;
            if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
            return p;
        };
        let r, g, b;
        if (s === 0) { r = g = b = l }
        else {
            const q = l < .5 ? l * (1 + s) : l + s - l * s;
            const p = 2 * l - q;
            r = hue2rgb(p, q, h + 1/3);
            g = hue2rgb(p, q, h);
            b = hue2rgb(p, q, h - 1/3);
        }
        const to = (x) => Math.round(x * 255).toString(16).padStart(2, '0');
        return '#' + to(r) + to(g) + to(b);
    }
    function hexToRgba(hex, a) {
        const { r, g, b } = hexToRgb(hex);
        return `rgba(${r},${g},${b},${a})`;
    }

    function applyBrand(hex) {
        // Single source of truth for the ramp lives at module
        // level (so bootstrap can use it before Bank loads).
        applyBrandRamp(hex);

        // The cashflow chart reads brand colours via getComputedStyle
        // inside renderFlowChart — so it needs an explicit re-render
        // when the theme changes (the CSS vars updated but the SVG
        // strokes are hard-coded at draw time). Coalesce so dragging
        // the colour picker doesn't fire dozens of repaints.
        if (applyBrand._raf) cancelAnimationFrame(applyBrand._raf);
        applyBrand._raf = requestAnimationFrame(() => {
            const chart = $('#chart-flow');
            if (chart && typeof Bank !== 'undefined') {
                try { Bank.repaintChart && Bank.repaintChart(); } catch (_) {}
            }
        });
    }
    function applySize(size) {
        const shell = $('.bank-shell'); if (!shell) return;
        shell.dataset.size = size;
    }
    // Background base colour → derive the whole surface/line ramp.
    // Coalesce a chart repaint so dragging the picker stays smooth
    // (the cashflow SVG bakes a couple of surface tones at draw time).
    function applyBackground(hex) {
        applyBackgroundRamp(hex);
        if (applyBackground._raf) cancelAnimationFrame(applyBackground._raf);
        applyBackground._raf = requestAnimationFrame(() => {
            if (typeof Bank !== 'undefined') {
                try { Bank.repaintChart && Bank.repaintChart(); } catch (_) {}
            }
        });
    }

    function paintPresets(container, current, onPick) {
        container.innerHTML = '';
        COLOR_PRESETS.forEach(c => {
            const b = document.createElement('button');
            b.className = 'preset-swatch';
            if (c.toLowerCase() === (current || '').toLowerCase()) b.classList.add('active');
            b.style.setProperty('--_c', c);
            on(b, 'click', () => {
                $$('.preset-swatch', container).forEach(x => x.classList.remove('active'));
                b.classList.add('active');
                onPick(c);
            });
            container.appendChild(b);
        });
    }

    // ── Personal preferences ──
    //
    // Brand colour lives in the DB (per-character), surfaced via
    // Runtime.theme.brand on bootstrap. Size remains in
    // localStorage since it's a per-device convenience and not
    // worth a DB round-trip.
    const savedPersonal = (() => {
        try { return JSON.parse(localStorage.getItem('apex_banking_prefs') || '{}'); }
        catch (_) { return {}; }
    })();
    if (savedPersonal.size) applySize(savedPersonal.size);
    if (savedPersonal.bg) applyBackgroundRamp(savedPersonal.bg);
    // Bootstrap already pushed Runtime.theme.brand with either the
    // player's saved colour or the config default, and applyTheme()
    // wrote it onto --brand-500. Re-run applyBrand() to populate
    // the full ramp (--brand-50…900 + alpha variants).
    if (Runtime.theme && Runtime.theme.brand) applyBrand(Runtime.theme.brand);

    function savePersonal(patch) {
        Object.assign(savedPersonal, patch);
        try { localStorage.setItem('apex_banking_prefs', JSON.stringify(savedPersonal)); }
        catch (_) {}
    }

    function initPersonalControls() {
        const current = Runtime.theme?.brand || DEFAULT_BRAND;
        $('#theme-color-input').value = current;
        paintSwatchBig($('#theme-color-input'));
        $('#theme-color-hex').textContent = current.toUpperCase();
        paintPresets($('#theme-presets'), current, (c) => {
            applyBrand(c);
            $('#theme-color-input').value = c;
            $('#theme-color-hex').textContent = c.toUpperCase();
            persistBrand(c);
        });

        const curSize = savedPersonal.size || 'l';
        applySize(curSize);
        $$('#size-grid .size-btn').forEach(b => {
            b.classList.toggle('active', b.dataset.size === curSize);
        });

        // Background colour (localStorage-backed, per device — like size).
        const curBg = savedPersonal.bg || DEFAULT_BG;
        const bgInput = $('#theme-bg-input'), bgHex = $('#theme-bg-hex'), bgPresets = $('#theme-bg-presets');
        if (bgInput)  { bgInput.value = curBg; paintSwatchBig(bgInput); }
        if (bgHex)    bgHex.textContent = curBg.toUpperCase();
        if (bgPresets) paintBgPresets(bgPresets, curBg, pickBg);
    }

    // Paint the visible chip of a .color-swatch-big with its input's
    // current value (the CSS default left every chip brand-blue, which
    // made the Background row's preview look wrong/broken).
    function paintSwatchBig(input) {
        if (!input) return;
        const chip = input.closest('.color-swatch-big');
        if (chip) chip.style.background = input.value;
    }

    function pickBg(c) {
        applyBackground(c);
        const bgInput = $('#theme-bg-input'), bgHex = $('#theme-bg-hex');
        if (bgInput) { bgInput.value = c; paintSwatchBig(bgInput); }
        if (bgHex)   bgHex.textContent = c.toUpperCase();
        savePersonal({ bg: c });
    }
    // Background swatches show the chosen base tone itself (not the
    // brand tint), so paint them with the literal preset colour.
    function paintBgPresets(container, current, onPick) {
        container.innerHTML = '';
        BG_PRESETS.forEach(c => {
            const b = document.createElement('button');
            b.className = 'preset-swatch';
            if (c.toLowerCase() === (current || '').toLowerCase()) b.classList.add('active');
            b.style.setProperty('--_c', c);
            on(b, 'click', () => {
                $$('.preset-swatch', container).forEach(x => x.classList.remove('active'));
                b.classList.add('active');
                onPick(c);
            });
            container.appendChild(b);
        });
    }

    // Debounced DB write so dragging the colour picker doesn't
    // hammer the server with one save per pixel.
    let _brandSaveTimer;
    function persistBrand(hex) {
        if (Runtime.theme) Runtime.theme.brand = hex;
        clearTimeout(_brandSaveTimer);
        _brandSaveTimer = setTimeout(() => {
            post('bank_prefs_set_brand', { brand: hex });
        }, 350);
    }

    on($('#theme-color-input'), 'input', (e) => {
        const c = e.target.value;
        applyBrand(c);
        paintSwatchBig(e.target);
        $('#theme-color-hex').textContent = c.toUpperCase();
        persistBrand(c);
        paintPresets($('#theme-presets'), c, (x) => {
            applyBrand(x);
            $('#theme-color-input').value = x;
            $('#theme-color-hex').textContent = x.toUpperCase();
            persistBrand(x);
        });
    });

    on($('#theme-bg-input'), 'input', (e) => {
        const c = e.target.value;
        const bgHex = $('#theme-bg-hex'); if (bgHex) bgHex.textContent = c.toUpperCase();
        applyBackground(c);
        paintSwatchBig(e.target);
        savePersonal({ bg: c });
        const bgPresets = $('#theme-bg-presets');
        if (bgPresets) paintBgPresets(bgPresets, c, pickBg);
    });

    on($('#size-grid'), 'click', (e) => {
        const b = e.target.closest('.size-btn'); if (!b) return;
        const size = b.dataset.size;
        $$('#size-grid .size-btn').forEach(x => x.classList.toggle('active', x === b));
        applySize(size);
        savePersonal({ size });
    });

    on($('#theme-reset-personal'), 'click', async () => {
        const r = await post('bank_prefs_reset_brand');
        // Server replies with the config-default brand so we can
        // immediately repaint without waiting for the next bootstrap.
        const fallback = (r && r.data && r.data.brand) || DEFAULT_BRAND;
        if (Runtime.theme) Runtime.theme.brand = fallback;
        applyBrand(fallback);
        applyBackground(DEFAULT_BG);
        applySize('l');
        savePersonal({ size: null, bg: null });
        $('#theme-color-input').value = fallback;
        $('#theme-color-hex').textContent = fallback.toUpperCase();
        $$('#size-grid .size-btn').forEach(x => x.classList.toggle('active', x.dataset.size === 'l'));
        paintPresets($('#theme-presets'), fallback, () => {});
        initPersonalControls();
        Notify({ type: 'info', message: t('js_appearance_reset') });
    });

    // ── Admin controls ──
    // Whether you are an admin is decided by the SERVER (ACE) and arrives in
    // the bootstrap. The panel is merely hidden from everyone else — every
    // action behind it is re-checked server-side.
    function initAdminControls() {
        const card = $('#admin-appearance');
        if (!card) return;
        if (!Runtime.isAdmin) { card.hidden = true; return; }
        card.hidden = false;

        const at = Runtime.adminTheme || {};
        const current = at.brand || Runtime.theme?.brand || DEFAULT_BRAND;

        const toggle = $('#admin-mode-toggle');
        if (toggle) toggle.checked = at.enabled === true;
        paintAdminState(at.enabled === true);

        $('#theme-admin-color-input').value = current;
        $('#theme-admin-color-hex').textContent = current.toUpperCase();
        paintPresets($('#theme-admin-presets'), current, (c) => {
            $('#theme-admin-color-input').value = c;
            $('#theme-admin-color-hex').textContent = c.toUpperCase();
        });
    }

    // admin mode OFF greys out the colour controls: they do nothing until it
    // is on, and a control that silently does nothing is a support ticket
    function paintAdminState(enabled) {
        const card = $('#admin-appearance');
        if (card) card.classList.toggle('admin-mode-on', !!enabled);
        const st = $('#admin-mode-state');
        if (st) st.textContent = t(enabled ? 'set_admin_mode_on' : 'set_admin_mode_off');
    }

    on($('#admin-mode-toggle'), 'change', async (e) => {
        const enabled = e.target.checked;
        const brand = $('#theme-admin-color-input').value;
        const r = await post('bank_theme_broadcast', { enabled, brand });
        if (!r || !r.ok) {
            e.target.checked = !enabled;   // the server refused: put it back
            Notify({ type: 'error', message: r?.why === 'not_admin' ? t('js_not_authorised') : t('js_broadcast_failed') });
            return;
        }
        if (Runtime.adminTheme) Runtime.adminTheme.enabled = enabled;
        paintAdminState(enabled);
        Notify({ type: 'success', message: t(enabled ? 'js_admin_mode_on' : 'js_admin_mode_off') });
    });

    on($('#theme-admin-color-input'), 'input', (e) => {
        const c = e.target.value;
        $('#theme-admin-color-hex').textContent = c.toUpperCase();
        paintPresets($('#theme-admin-presets'), c, (x) => {
            $('#theme-admin-color-input').value = x;
            $('#theme-admin-color-hex').textContent = x.toUpperCase();
        });
    });

    on($('#theme-admin-broadcast'), 'click', async () => {
        const c = $('#theme-admin-color-input').value;
        if (!await confirmDialog(t('js_broadcast_title'), t('js_broadcast_body', c.toUpperCase()))) return;
        // broadcasting a colour implies turning admin mode on — otherwise the
        // button would appear to do nothing
        const r = await post('bank_theme_broadcast', { enabled: true, brand: c });
        if (r && r.ok) {
            const toggle = $('#admin-mode-toggle');
            if (toggle) toggle.checked = true;
            if (Runtime.adminTheme) { Runtime.adminTheme.enabled = true; Runtime.adminTheme.brand = c; }
            paintAdminState(true);
            Notify({ type: 'success', message: t('js_broadcast_ok') });
        } else {
            Notify({ type: 'error', message: r?.why === 'not_admin' ? t('js_not_authorised') : t('js_broadcast_failed') });
        }
    });

    // "Reset to default" = switch admin mode OFF: every player gets their own
    // colour back (personal pick, or the config default if they never chose).
    on($('#theme-admin-reset'), 'click', async () => {
        if (!await confirmDialog(t('js_reset_brand_title'), t('js_reset_brand_body'))) return;
        const r = await post('bank_theme_broadcast', { enabled: false, brand: DEFAULT_BRAND });
        if (r && r.ok) {
            const toggle = $('#admin-mode-toggle');
            if (toggle) toggle.checked = false;
            if (Runtime.adminTheme) Runtime.adminTheme.enabled = false;
            paintAdminState(false);
            Notify({ type: 'success', message: t('js_reset_brand_ok') });
        }
    });

    // Keep the cashflow chart matched to its box at every shell size —
    // redraw whenever the SVG's box changes (size setting, tab reveal,
    // fullscreen). Without this the viewBox keeps the dimensions from
    // the first draw and `meet` letterboxes it (empty side gutters).
    (() => {
        const el = $('#chart-flow');
        if (!el || typeof ResizeObserver === 'undefined') return;
        let raf, lastW = 0, lastH = 0;
        const ro = new ResizeObserver((entries) => {
            const r = entries[entries.length - 1].contentRect;
            if (!r.width || !r.height) return;            // hidden tab
            if (Math.abs(r.width - lastW) < 1 && Math.abs(r.height - lastH) < 1) return;
            lastW = r.width; lastH = r.height;
            cancelAnimationFrame(raf);
            raf = requestAnimationFrame(() => {
                try {
                    const a = state.account; if (!a) return;
                    renderFlowChart(el, aggregate(state.history, a.iban).days);
                } catch (_) {}
            });
        });
        ro.observe(el);
    })();

    return {
        open, close,
        setPrivacy(v) {
            state.balanceHidden = !!v;
            Privacy.set(!!v);
            const eye = $('#overview-eye i');
            if (eye) eye.className = state.balanceHidden ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
        },
        repaintChart() {
            // Re-run the chart-only render with the current state,
            // bypassing the full overview refresh.
            try {
                const a = state.account; if (!a) return;
                const agg = aggregate(state.history, a.iban);
                renderFlowChart($('#chart-flow'), agg.days);
            } catch (_) {}
        },
        applyData(payload) {
            if (payload.needsOnboarding) {
                close();
                Onboarding.open();
                return;
            }
            Object.assign(state, payload);
            // Isolate every render in a try/catch so a thrown error
            // in one section (typically a stray null DOM reference)
            // never prevents the rest of the dashboard from updating.
            const safe = (fn, label) => {
                try { fn(); } catch (e) {
                    console.error('[apex_banking] render', label, e);
                }
            };
            safe(renderSnapshot, 'snapshot');
            safe(renderOverview, 'overview');
            safe(renderHistory,  'history');
            safe(renderCards,    'cards');
            safe(renderSavings,  'savings');
            safe(renderLoans,    'loans');
            safe(renderBusiness, 'business');
            safe(renderSociety,  'society');
            safe(renderBilling,  'billing');
            safe(renderContacts, 'contacts');
            const feeEl = $('#rotate-iban-fee');
            if (feeEl) feeEl.textContent = t('js_rotate_iban_fee', money((Runtime.fees && Runtime.fees.changeIban) || 0));
        },
    };
})();

// ═══════════════════════════════════════════════════════
// ATM
// ═══════════════════════════════════════════════════════
const Atm = (() => {
    const overlay = document.getElementById('atm-overlay');
    let card = null, snapshot = null, pin = '', clockTimer;

    function setState(s) {
        $$('#atm-overlay .atm-state').forEach(el => el.hidden = el.dataset.state !== s);
        // Rewind the receipt and any other inner scrollers so the
        // freshly-shown state always lands at the top.
        $$('#atm-overlay .atm-stage, #atm-overlay .atm-receipt')
            .forEach(el => { el.scrollTop = 0 });
    }
    function setPin(p) {
        pin = p;
        $$('#atm-pin-row .pin-dot').forEach((d, i) => d.classList.toggle('filled', i < p.length));
        if (p.length === ((Runtime.pin && Runtime.pin.length) || 4)) {
            (async () => {
                const r = await post('atm_auth', { pin });
                if (r && r.ok && r.snapshot) {
                    snapshot = r.snapshot;
                    // Safe set: not every element exists in every
                    // layout (the old withdraw/deposit sub-states
                    // were removed when we collapsed everything into
                    // one menu view).
                    const set = (sel, txt) => { const el = $(sel); if (el) el.textContent = txt; };
                    set('#atm-greeting-name', snapshot.owner || '—');
                    set('#atm-balance',       money(snapshot.balance));
                    set('#atm-iban-foot',     fmtIban(snapshot.iban));
                    set('#atm-cap',           money((Runtime.limits && Runtime.limits.maxWithdraw) || 0));
                    set('#atm-daily-cap',     money((Runtime.limits && Runtime.limits.dailyAtmWithdraw) || 0));
                    set('#atm-fee-display',   money((Runtime.fees && Runtime.fees.atmWithdraw) || 0));
                    set('#atm-balance-wd',    money(snapshot.balance));
                    set('#atm-balance-dp',    money(snapshot.balance));
                    setState('menu');
                    refreshAtmHistory();
                } else {
                    Sound('error');
                    pin = '';
                    $$('#atm-pin-row .pin-dot').forEach(d => d.classList.remove('filled'));
                    const row = $('#atm-pin-row');
                    if (row) {
                        row.classList.remove('shake'); void row.offsetWidth; row.classList.add('shake');
                    }
                    const why = (r && r.why) || 'unknown';
                    if (why === 'wrong') {
                        Notify({ type: 'error', message: t('js_atm_wrong_pin') });
                        return;
                    }
                    if (why === 'locked') {
                        Notify({ type: 'error', message: t('js_atm_card_locked') });
                        return;
                    }
                    Notify({ type: 'error', message: t('js_atm_error', atmReason(why)) });
                }
            })();
        }
    }

    function open(payload) {
        card = payload.card || {};
        pin = '';
        overlay.hidden = false;
        post('atm_focus');
        setTimeout(() => post('atm_focus'), 120);
        Sound('cardIn');
        $('#atm-card-owner').textContent = card.owner || '—';
        $('#atm-card-iban').textContent = card.ibanFmt || fmtIban(card.iban);
        $('#atm-card-serial').textContent = card.serial || '00000';
        $('#atm-pin-tries').textContent = (Runtime.pin && Runtime.pin.maxTries) || 3;
        $$('#atm-pin-row .pin-dot').forEach(d => d.classList.remove('filled'));
        setState('pin');
        startClock();
    }
    function close(notifyLua = true) {
        if (!overlay.hidden) Sound('cardOut');
        overlay.hidden = true;
        snapshot = null; card = null; pin = '';
        stopClock();
        if (notifyLua) post('atm_close');
    }
    function startClock() {
        const tick = () => {
            const d = new Date();
            const pad = x => String(x).padStart(2, '0');
            $('#atm-time').textContent = `${pad(d.getHours())}:${pad(d.getMinutes())}`;
        };
        tick(); clockTimer = setInterval(tick, 30000);
    }
    function stopClock() { if (clockTimer) clearInterval(clockTimer) }

    // Numpad
    on($('#atm-numpad'), 'click', (e) => {
        const k = e.target.closest('button')?.dataset.k; if (!k) return;
        Sound('click');
        if (k === 'C') return setPin('');
        if (k === '←') return setPin(pin.slice(0, -1));
        const len = (Runtime.pin && Runtime.pin.length) || 4;
        if (pin.length < len) setPin(pin + k);
    });
    on($('#atm-cancel'), 'click', close);
    on($('#atm-side-cancel'), 'click', close);

    // Menu actions — legacy 4-tile grid (kept for compatibility
    // if the action-grid HTML ever returns). Safely no-ops when
    // the new unified layout removed it.
    on(document.querySelector('.atm-state[data-state="menu"] .atm-action-grid'), 'click', (e) => {
        if (!e || !e.target) return;
        const b = e.target.closest('.atm-action'); if (!b) return;
        const a = b.dataset.act;
        if (a === 'withdraw') setState('withdraw');
        else if (a === 'deposit') setState('deposit');
        else if (a === 'balance') {
            $('#atm-receipt').innerHTML = `
                <div class="atm-receipt-row"><span>${t('js_atm_available_balance')}</span><strong>${money(snapshot.balance)}</strong></div>
                <div class="atm-receipt-row"><span>${t('js_atm_account_holder')}</span><strong>${snapshot.owner}</strong></div>
                <div class="atm-receipt-row"><span>${t('js_atm_iban')}</span><strong>${fmtIban(snapshot.iban)}</strong></div>
                <div class="atm-receipt-row"><span>${t('js_atm_card_serial')}</span><strong>${snapshot.serial}</strong></div>
                <div class="atm-receipt-row"><span>${t('js_atm_per_tx_cap')}</span><strong>${money((Runtime.limits && Runtime.limits.maxWithdraw) || 0)}</strong></div>
                <div class="atm-receipt-row"><span>${t('js_atm_daily_limit')}</span><strong>${money((Runtime.limits && Runtime.limits.dailyAtmWithdraw) || 0)}</strong></div>`;
            setState('receipt');
        } else if (a === 'exit') close();
    });
    $$('[data-state-back]').forEach(b => on(b, 'click', () => setState('menu')));

    // ── Unified ATM bindings ────────────────────────────
    // Quick-amount buttons in the Withdraw column fill the
    // withdraw amount input, and similarly for Deposit.
    $$('[data-w-amount]').forEach(b => on(b, 'click', () => {
        const a = $('#atm-w-amount'); if (!a) return;
        a.value = b.dataset.wAmount;
    }));
    $$('[data-d-amount]').forEach(b => on(b, 'click', () => {
        const a = $('#atm-d-amount'); if (!a) return;
        a.value = b.dataset.dAmount;
    }));
    on($('#atm-eject-btn'), 'click', close);
    on($('#atm-error-back'), 'click', () => setState(snapshot ? 'menu' : 'pin'));

    // Null-safe setter — the unified ATM doesn't have separate
    // sub-state balance displays (#atm-balance-wd / -dp) so we
    // can't unconditionally write to them. Without this guard a
    // missing element threw and aborted the post-action refresh,
    // which is why the Recent ATM activity wasn't updating live.
    const setAtm = (sel, txt) => { const el = $(sel); if (el) el.textContent = txt; };

    on($('#atm-w-go'), 'click', async () => {
        const amount = Math.floor(Number($('#atm-w-amount').value) || 0);
        if (amount <= 0) return;
        const r = await post('atm_withdraw', { amount });
        if (r.ok) {
            Sound('cashOut');
            snapshot.balance = r.extra && r.extra.balance;
            setAtm('#atm-balance',    money(snapshot.balance));
            setAtm('#atm-balance-wd', money(snapshot.balance));
            setAtm('#atm-balance-dp', money(snapshot.balance));
            const w = $('#atm-w-amount'); if (w) w.value = '';
            setState('menu');
            refreshAtmHistory();
        } else {
            Sound('error');
            setAtm('#atm-error-msg', atmReason(r.why));
            setState('error');
        }
    });
    on($('#atm-d-go'), 'click', async () => {
        const amount = Math.floor(Number($('#atm-d-amount').value) || 0);
        if (amount <= 0) return;
        const r = await post('atm_deposit', { amount });
        if (r.ok) {
            Sound('cashIn');
            snapshot.balance = r.extra && r.extra.balance;
            setAtm('#atm-balance',    money(snapshot.balance));
            setAtm('#atm-balance-wd', money(snapshot.balance));
            setAtm('#atm-balance-dp', money(snapshot.balance));
            const d = $('#atm-d-amount'); if (d) d.value = '';
            setState('menu');
            refreshAtmHistory();
        } else {
            Sound('error');
            setAtm('#atm-error-msg', atmReason(r.why));
            setState('error');
        }
    });

    // Recent ATM activity — fetches a short list from the server
    // and renders it into the receipt panel. Called after auth and
    // after each successful withdraw/deposit so the list stays
    // current.
    async function refreshAtmHistory() {
        const wrap = $('#atm-receipt'); if (!wrap) return;
        wrap.innerHTML = `<div class="atm-receipt-empty">${t('js_loading')}</div>`;
        const r = await post('atm_history');
        const rows = (r && r.data) || [];
        if (!rows.length) {
            wrap.innerHTML = `<div class="atm-receipt-empty">${t('js_atm_no_activity')}</div>`;
            return;
        }
        const myIban = snapshot && snapshot.iban;
        wrap.innerHTML = rows.map(tx => {
            const isOut = tx.kind === 'atm_withdraw';
            const sign  = isOut ? '-' : '+';
            const cls   = isOut ? 'neg' : 'pos';
            const ic    = isOut ? 'fa-arrow-up' : 'fa-arrow-down';
            return `
                <div class="atm-receipt-row">
                    <span><i class="fa-solid ${ic}"></i> ${isOut ? t('js_atm_withdraw') : t('js_atm_deposit')}</span>
                    <strong class="${cls}">${sign}${money(tx.amount)}</strong>
                </div>`;
        }).join('');
    }

    on($('#atm-eye'), 'click', () => {
        const cur = $('#atm-balance').textContent;
        $('#atm-balance').textContent = cur.includes('•') ? money(snapshot.balance) : '••••••';
        const i = $('#atm-eye i');
        i.className = cur.includes('•') ? 'fa-solid fa-eye' : 'fa-solid fa-eye-slash';
    });

    function atmReason(w) {
        if (w === 'no_funds') return t('js_atm_no_funds');
        if (w === 'no_cash') return t('js_atm_no_cash');
        if (w === 'over_limit') return t('js_atm_over_limit', money((Runtime.limits && Runtime.limits.maxWithdraw) || 0));
        if (w === 'daily') return t('js_atm_daily');
        if (w === 'wrong') return t('js_atm_wrong');
        if (w === 'locked') return t('js_atm_locked');
        if (w === 'missing') return t('js_atm_missing');
        if (w === 'no_card') return t('js_atm_no_card');
        if (w === 'no_account') return t('js_atm_no_account');
        if (w === 'account_frozen') return t('js_atm_account_frozen');
        if (w === 'frozen') return t('js_atm_frozen');
        if (w === 'offline') return t('js_atm_offline');
        return t('js_atm_op_failed');
    }

    return { open, close };
})();

// ═══════════════════════════════════════════════════════
// CONFIRM + PROMPT
// ═══════════════════════════════════════════════════════
let _alertResolve, _inputResolve;
function confirmDialog(title, content) {
    return new Promise(res => {
        $('#alert-title').textContent = title;
        $('#alert-content').textContent = content || '';
        document.getElementById('alert-overlay').hidden = false;
        _alertResolve = res;
    });
}
document.getElementById('alert-overlay').addEventListener('click', (e) => {
    const a = e.target.dataset.action;
    if (a === 'alert-yes' || a === 'alert-no') {
        document.getElementById('alert-overlay').hidden = true;
        _alertResolve?.(a === 'alert-yes');
    }
});

function promptDialog(title, label, type = 'text', initial = '') {
    return new Promise(res => {
        $('#input-title').textContent = title;
        const fields = document.getElementById('input-fields');
        fields.innerHTML = '';
        const row = document.createElement('div');
        row.className = 'form-row';
        const lab = document.createElement('label'); lab.textContent = label;
        const inp = document.createElement('input');
        inp.className = 'apex-input mono';
        inp.id = '_prompt_input';
        inp.value = initial;
        if (type === 'number') { inp.type = 'number'; inp.min = '1'; inp.placeholder = '0' }
        else if (type === 'pin') {
            inp.type = 'password'; inp.inputMode = 'numeric';
            inp.maxLength = (Runtime.pin && Runtime.pin.length) || 4;
            inp.placeholder = t('js_prompt_enter_pin');
        } else { inp.type = 'text'; inp.placeholder = t('js_prompt_type_here') }
        row.append(lab, inp); fields.appendChild(row);
        document.getElementById('input-overlay').hidden = false;
        setTimeout(() => inp.focus(), 30);
        _inputResolve = res;
    });
}
document.getElementById('input-overlay').addEventListener('click', (e) => {
    const a = e.target.dataset.action;
    if (a === 'input-submit') {
        document.getElementById('input-overlay').hidden = true;
        _inputResolve?.($('#_prompt_input')?.value);
    } else if (a === 'input-cancel') {
        document.getElementById('input-overlay').hidden = true;
        _inputResolve?.(null);
    }
});

// ═══════════════════════════════════════════════════════
// COLOUR PICKER — <input type="color"> never opens inside CEF, so
// every .color-swatch-big opens this popover instead. It writes the
// hex into the (hidden) input it wraps and fires `input`, so every
// existing listener keeps working untouched.
// ═══════════════════════════════════════════════════════
const ColorPicker = (() => {
    let pop, sv, svKnob, hue, hueKnob, prev, hexIn, target = null, swatch = null;
    let H = 220, S = 1, V = 1;

    function hexToHsv(hex) {
        const { r, g, b } = _hexToRgb(hex);
        const rr = r / 255, gg = g / 255, bb = b / 255;
        const mx = Math.max(rr, gg, bb), mn = Math.min(rr, gg, bb), d = mx - mn;
        let h = 0;
        if (d) {
            if (mx === rr) h = ((gg - bb) / d) % 6;
            else if (mx === gg) h = (bb - rr) / d + 2;
            else h = (rr - gg) / d + 4;
            h *= 60; if (h < 0) h += 360;
        }
        return { h, s: mx ? d / mx : 0, v: mx };
    }
    function hsvToHex(h, s, v) {
        const c = v * s, x = c * (1 - Math.abs(((h / 60) % 2) - 1)), m = v - c;
        let r = 0, g = 0, b = 0;
        if (h < 60) [r, g, b] = [c, x, 0]; else if (h < 120) [r, g, b] = [x, c, 0];
        else if (h < 180) [r, g, b] = [0, c, x]; else if (h < 240) [r, g, b] = [0, x, c];
        else if (h < 300) [r, g, b] = [x, 0, c]; else [r, g, b] = [c, 0, x];
        const to = (n) => Math.round((n + m) * 255).toString(16).padStart(2, '0');
        return ('#' + to(r) + to(g) + to(b)).toUpperCase();
    }

    function paint(fire) {
        sv.style.background = hsvToHex(H, 1, 1);
        svKnob.style.left = (S * 100) + '%';
        svKnob.style.top = ((1 - V) * 100) + '%';
        hueKnob.style.left = (H / 360 * 100) + '%';
        const hex = hsvToHex(H, S, V);
        prev.style.background = hex;
        if (document.activeElement !== hexIn) hexIn.value = hex;
        if (fire && target) {
            target.value = hex;
            if (swatch) swatch.style.background = hex;
            target.dispatchEvent(new Event('input', { bubbles: true }));
        }
    }

    function drag(el, fn) {
        on(el, 'mousedown', (e) => {
            e.preventDefault();
            const move = (ev) => {
                const r = el.getBoundingClientRect();
                fn(Math.min(1, Math.max(0, (ev.clientX - r.left) / r.width)),
                   Math.min(1, Math.max(0, (ev.clientY - r.top) / r.height)));
                paint(true);
            };
            move(e);
            const up = () => { window.removeEventListener('mousemove', move); window.removeEventListener('mouseup', up); };
            window.addEventListener('mousemove', move);
            window.addEventListener('mouseup', up);
        });
    }

    function build() {
        pop = document.createElement('div');
        pop.className = 'cp-pop';
        pop.hidden = true;
        pop.innerHTML = `
            <div class="cp-sv"><span class="cp-sv-knob"></span></div>
            <div class="cp-hue"><span class="cp-hue-knob"></span></div>
            <div class="cp-row"><span class="cp-preview"></span><input class="cp-hex" maxlength="7" spellcheck="false"></div>`;
        document.body.appendChild(pop);
        sv = $('.cp-sv', pop); svKnob = $('.cp-sv-knob', pop);
        hue = $('.cp-hue', pop); hueKnob = $('.cp-hue-knob', pop);
        prev = $('.cp-preview', pop); hexIn = $('.cp-hex', pop);
        drag(sv, (x, y) => { S = x; V = 1 - y; });
        drag(hue, (x) => { H = Math.min(359.9, x * 360); });
        on(hexIn, 'input', () => {
            let v = hexIn.value.trim(); if (v[0] !== '#') v = '#' + v;
            if (/^#[0-9a-f]{6}$/i.test(v)) { ({ h: H, s: S, v: V } = hexToHsv(v)); paint(true); }
        });
        on(pop, 'mousedown', (e) => e.stopPropagation());
        on(document, 'mousedown', () => close());
    }

    function open(input, anchor) {
        if (!pop) build();
        target = input; swatch = anchor;
        ({ h: H, s: S, v: V } = hexToHsv(input.value || '#1F5EFF'));
        pop.hidden = false;
        const r = anchor.getBoundingClientRect();
        const w = 248, h = 250;
        pop.style.left = Math.max(8, Math.min(window.innerWidth - w - 8, r.right - w)) + 'px';
        pop.style.top = (r.bottom + h + 8 > window.innerHeight ? r.top - h - 8 : r.bottom + 8) + 'px';
        paint(false);
    }
    function close() { if (pop) pop.hidden = true; target = null; swatch = null; }
    function isOpen() { return !!(pop && !pop.hidden); }

    on(document, 'click', (e) => {
        const sw = e.target.closest && e.target.closest('.color-swatch-big');
        if (!sw) return;
        e.preventDefault();
        const input = sw.querySelector('input');
        if (input) open(input, sw);
    });
    on(document, 'mousedown', (e) => {
        if (e.target.closest && e.target.closest('.color-swatch-big')) e.stopPropagation();
    }, true);

    return { open, close, isOpen };
})();

// ═══════════════════════════════════════════════════════
// Fingerprint world overlay
// ═══════════════════════════════════════════════════════
const FpWorld = (() => {
    const el = document.getElementById('fp-world');
    const bar = document.getElementById('fp-world-fill');
    let timer;
    return {
        start(durationMs) {
            el.hidden = false;
            bar.style.width = '0%';
            const start = performance.now();
            clearInterval(timer);
            timer = setInterval(() => {
                const t = (performance.now() - start) / durationMs;
                if (t >= 1) { bar.style.width = '100%'; clearInterval(timer); return; }
                bar.style.width = (t * 100).toFixed(0) + '%';
            }, 60);
        },
        done() { clearInterval(timer); el.hidden = true },
    };
})();

// ═══════════════════════════════════════════════════════
// ADMIN PANEL (/bankadmin)
// A standalone overlay: it opens anywhere, not only at a bank. The
// server decides who is an admin and re-checks every action, so this
// side is presentation only. Sections: dashboard · features · accounts
// · placed ATMs · appearance (theme presets + the two colours).
// ═══════════════════════════════════════════════════════
const AdminPanel = (() => {
    const el = () => $('#admin-overlay');
    const PRESETS = ['#1F5EFF', '#2DD4BF', '#22C55E', '#F59E0B', '#F0556D', '#A855F7', '#0EA5E9', '#E11D48'];
    const BG_PRESETS = ['#131314', '#0E1116', '#101A15', '#1A1012', '#12101A', '#0D1620', '#191512', '#F4F1EA'];
    const DEF_BRAND = '#1F5EFF';
    const FEATURE_ICONS = {
        transfers: 'fa-paper-plane', cards: 'fa-credit-card', atm: 'fa-money-check-dollar', savings: 'fa-piggy-bank',
        loans: 'fa-hand-holding-dollar', subAccounts: 'fa-users', business: 'fa-briefcase', billing: 'fa-file-invoice-dollar',
        vehicleFinance: 'fa-car', history: 'fa-clock-rotate-left', privacyMode: 'fa-eye-slash', settings: 'fa-sliders',
        onboarding: 'fa-fingerprint', blips: 'fa-map-location-dot', worldMarkers: 'fa-location-dot',
        interactAnim: 'fa-person', sounds: 'fa-volume-high',
    };
    const INBOUND = /(_in$|^deposit$|^atm_deposit$|grant|credit|^savings_out$)/;

    let data = { atms: [], models: [], theme: {}, features: {}, editable: [], defaults: {}, stats: {} };
    // what the Appearance tab is editing (bg null = the preset's own)
    let look = { enabled: false, theme: 'apex', layout: 'classic', brand: DEF_BRAND, bg: null };
    let previewing = false;
    let current = 'dash';

    // Per-pane state. Accounts and the ledger are paged, filtered and
    // searched SERVER-side, so these are query arguments, not views over a
    // cached array: an online player sitting on page 3 still has to show up.
    const ACC0    = () => ({ search: '', filter: 'all', page: 0, total: 0, pageSize: 25, rows: [] });
    const LEDGER0 = () => ({ search: '', kind: 'all', page: 0, total: 0, pageSize: 40, kindsBuilt: false });
    let accQ   = ACC0();
    let biz    = { rows: [], search: '' };
    let loans  = { scope: 'active', rows: [] };
    let ledger = LEDGER0();
    let drawer = { id: null, data: null };
    let typeTimer = null;

    const esc = (s) => String(s == null ? '' : s).replace(/[&<>"']/g,
        (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
    const one = (n) => Number(n || 0).toFixed(1);
    const fmtInt = (n) => Number(n || 0).toLocaleString('en-US');
    const initials = (name) => String(name || '?').split(/\s+/).map((w) => w[0] || '').join('').slice(0, 2).toUpperCase();
    const ago = (ts) => {
        const d = Math.max(0, Math.floor(Date.now() / 1000) - Number(ts || 0));
        if (d < 60) return t('adm_ago_now');
        if (d < 3600) return t('adm_ago_m', Math.floor(d / 60));
        if (d < 86400) return t('adm_ago_h', Math.floor(d / 3600));
        return t('adm_ago_d', Math.floor(d / 86400));
    };
    const uptime = (sec) => {
        sec = Number(sec || 0);
        const h = Math.floor(sec / 3600), m = Math.floor((sec % 3600) / 60);
        return h > 0 ? `${h}h ${m}m` : `${m}m`;
    };
    const themeName = (id) => (THEMES[id] ? THEMES[id].name : THEMES.apex.name);

    // ── Dashboard ──
    function renderDash() {
        const s = data.stats || {};
        const kpis = [
            { ic: 'fa-users',                  label: t('adm_k_accounts'), value: fmtInt(s.accounts),      sub: t('adm_k_frozen_n', fmtInt(s.frozen)) },
            { ic: 'fa-circle-dot',             label: t('adm_k_online'),   value: fmtInt(s.online),        sub: t('adm_k_uptime', uptime(s.uptime)) },
            { ic: 'fa-piggy-bank',             label: t('adm_k_savings'),  value: fmtMoney(s.savings),     sub: t('adm_k_locked_n', fmtInt(s.locked)) },
            { ic: 'fa-credit-card',            label: t('adm_k_cards'),    value: fmtInt(s.cards),         sub: t('adm_k_cards_frozen', fmtInt(s.cardsFrozen)) },
            { ic: 'fa-hand-holding-dollar',    label: t('adm_k_loans'),    value: fmtInt(s.loans),         sub: t('adm_k_loans_rem', fmtMoney(s.loansRemaining)) },
            { ic: 'fa-arrow-right-arrow-left', label: t('adm_k_volume'),   value: fmtMoney(s.volume24),    sub: t('adm_k_tx_n', fmtInt(s.tx24), fmtMoney(s.fees24)) },
            { ic: 'fa-money-check-dollar',     label: t('adm_k_atms'),     value: fmtInt(s.atms),          sub: t('adm_k_atms_sub') },
            { ic: 'fa-people-group',           label: t('adm_k_subs'),     value: fmtInt(s.subAccounts),   sub: fmtMoney(s.subBalance) },
        ];
        $('#adm-kpis').innerHTML = kpis.map((k) => `<div class="adm-kpi">
            <span class="adm-kpi-ic"><i class="fa-solid ${k.ic}"></i></span>
            <div class="adm-kpi-body"><span class="adm-kpi-label">${esc(k.label)}</span><strong>${esc(k.value)}</strong><small>${esc(k.sub)}</small></div>
        </div>`).join('');
        $('#adm-chip-online b').textContent = fmtInt(s.online);

        const rec = Array.isArray(s.recent) ? s.recent : [];
        $('#adm-recent').innerHTML = rec.length ? rec.map((r) => {
            const inbound = INBOUND.test(String(r.kind || ''));
            const kind = String(r.kind || '').replace(/_/g, ' ');
            return `<div class="adm-recent-row">
                <span class="adm-recent-ic ${inbound ? 'in' : 'out'}"><i class="fa-solid ${inbound ? 'fa-arrow-down' : 'fa-arrow-up'}"></i></span>
                <div class="adm-recent-main"><strong>${esc(r.label || kind)}</strong><small>${esc(kind)} · ${esc(r.actor || '—')} · ${esc(ago(r.ts))}</small></div>
                <span class="adm-recent-amt ${inbound ? 'in' : ''}">${inbound ? '+' : '−'}${esc(fmtMoney(r.amount))}</span>
            </div>`;
        }).join('') : `<div class="adm-recent-empty">${esc(t('adm_recent_empty'))}</div>`;
        renderStatus();
    }

    function renderStatus() {
        const th = data.theme || {}, f = data.features || {};
        const off = Object.keys(f).filter((k) => f[k] === false && (data.editable || []).includes(k));
        const brand = th.brand || DEF_BRAND;
        const rows = [
            [t('adm_look_status'), `<span class="adm-tag ${th.enabled ? 'ok' : ''}">${esc(t(th.enabled ? 'adm_look_on' : 'adm_look_off'))}</span>`],
            [t('adm_status_theme'), `<b>${esc(th.enabled && th.theme ? themeName(th.theme) : themeName('apex'))}</b>`],
            [t('adm_status_layout'), `<b>${esc((LAYOUTS[th.enabled && th.layout] || LAYOUTS.classic).name)}</b>`],
            [t('adm_brand'), `<span class="sw" style="background:${esc(brand)}"></span><b class="mono">${esc(String(brand).toUpperCase())}</b>`],
            [t('adm_bg'), th.enabled && th.bg ? `<span class="sw" style="background:${esc(th.bg)}"></span><b class="mono">${esc(String(th.bg).toUpperCase())}</b>` : `<b>${esc(t('adm_bg_default'))}</b>`],
            [t('adm_status_features_off'), off.length ? `<b>${esc(off.map((k) => t('adm_f_' + k)).join(', '))}</b>` : `<span class="adm-tag ok">${esc(t('adm_status_all_on'))}</span>`],
            [t('adm_k_atms'), `<b class="mono">${esc(fmtInt((data.atms || []).length))}</b>`],
        ];
        $('#adm-status-list').innerHTML = rows.map(([k, v]) => `<div class="adm-status-row"><span>${esc(k)}</span>${v}</div>`).join('');
    }

    // ── Features ──
    function renderFeatures() {
        const f = data.features || {}, defs = data.defaults || {};
        const list = Array.isArray(data.editable) && data.editable.length ? data.editable : Object.keys(FEATURE_ICONS);
        let offCount = 0;
        $('#adm-feature-list').innerHTML = list.map((k) => {
            const on = f[k] !== false;
            if (!on) offCount++;
            const changed = (defs[k] !== false) !== on;
            return `<div class="adm-feature${on ? '' : ' off'}" data-key="${esc(k)}">
                <span class="adm-feature-ic"><i class="fa-solid ${FEATURE_ICONS[k] || 'fa-toggle-on'}"></i></span>
                <div class="adm-feature-body"><strong>${esc(t('adm_f_' + k))}</strong><span class="muted">${esc(t('adm_f_' + k + '_d'))}</span></div>
                ${changed ? `<span class="adm-tag warn">${esc(t('adm_f_changed'))}</span>` : ''}
                <label class="apex-switch"><input type="checkbox" data-feature="${esc(k)}"${on ? ' checked' : ''}><span class="apex-switch-track"><span class="apex-switch-thumb"></span></span></label>
            </div>`;
        }).join('');
        const badge = $('#adm-features-off');
        badge.textContent = String(offCount);
        badge.dataset.empty = String(offCount === 0);
    }

    on($('#adm-feature-list'), 'change', async (e) => {
        const input = e.target.closest('input[data-feature]');
        if (!input) return;
        const key = input.dataset.feature, value = input.checked;
        input.disabled = true;
        const r = await post('admin_features_set', { features: { [key]: value } });
        input.disabled = false;
        if (r && r.ok) {
            data.features = (r.data && typeof r.data === 'object') ? r.data : Object.assign({}, data.features, { [key]: value });
            renderFeatures();
            renderStatus();
            Notify({ type: 'success', message: t(value ? 'adm_f_on' : 'adm_f_off', t('adm_f_' + key)) });
        } else {
            input.checked = !value;
            Notify({ type: 'error', message: r && r.why === 'not_admin' ? t('js_not_authorised') : t('adm_f_failed') });
        }
    });

    // ── Shared plumbing for the data panes ──
    const arr = (x) => (Array.isArray(x) ? x : []);
    const num = (v) => Math.max(0, Math.floor(Number(v) || 0));

    // One error surface for every admin callback. The server answers
    // { ok, why, data } across the board, so `why` is the whole story.
    const WHY = {
        not_admin: 'js_not_authorised', no_account: 'adm_err_no_account', no_loan: 'adm_err_no_loan',
        no_card: 'adm_err_no_card', target_offline: 'adm_err_target_offline', offline: 'adm_err_target_offline',
        bad_amount: 'adm_err_amount', amount: 'adm_err_amount', mode: 'adm_err_mode',
        account: 'adm_err_account', action: 'adm_err_action', pin_format: 'adm_err_pin',
        bad_pin: 'adm_err_pin', not_found: 'adm_err_not_found', disabled: 'adm_err_disabled',
        no_funds: 'adm_err_no_funds',
    };
    const failMsg = (r) => t(WHY[r && r.why] || 'adm_err_generic');

    // Returns the payload, or null once it has already shown the error.
    async function call(name, payload) {
        const r = await post(name, payload || {});
        if (!r || !r.ok) { Notify({ type: 'error', message: failMsg(r) }); return null; }
        return r.data !== undefined ? r.data : true;
    }

    const emptyBox = (ic, title, sub) => `<div class="adm-empty">
        <span class="adm-empty-ic"><i class="fa-solid ${ic}"></i></span>
        <strong>${esc(title)}</strong>
        ${sub ? `<small>${esc(sub)}</small>` : ''}
    </div>`;
    const loadingBox = () => `<div class="adm-loading">${esc(t('adm_loading'))}</div>`;
    // A null balance means the server could not read that wallet, not zero.
    const money = (v) => (v == null ? '<span class="muted">—</span>' : esc(fmtMoney(v)));

    // Segmented controls: one `.on` button, the value on the container.
    function segPick(btn) {
        const seg = btn.closest('.adm-seg');
        if (!seg) return;
        seg.dataset.value = btn.dataset.v;
        $$('button', seg).forEach((b) => b.classList.toggle('on', b === btn));
    }
    function segReset(sel, value) {
        const seg = $(sel);
        if (!seg) return;
        seg.dataset.value = value;
        $$('button', seg).forEach((b) => b.classList.toggle('on', b.dataset.v === value));
    }

    // Shared pager painter: the server owns total/page/pageSize.
    function pager(prefix, page, total, pageSize) {
        const pages = Math.max(1, Math.ceil((Number(total) || 0) / (Number(pageSize) || 1)));
        const box = $('#adm-' + prefix + '-pager');
        if (box) box.hidden = pages <= 1;
        const count = $('#adm-' + prefix + '-count');
        if (count) count.textContent = t('adm_page_of', page + 1, pages, fmtInt(total));
        const prev = $('#adm-' + prefix + '-prev'), next = $('#adm-' + prefix + '-next');
        if (prev) prev.disabled = page <= 0;
        if (next) next.disabled = page >= pages - 1;
    }

    // ── Accounts ──
    async function loadPlayers() {
        const host = $('#adm-acc-list');
        if (host && !host.children.length) host.innerHTML = loadingBox();
        const d = await call('admin_players', {
            search: accQ.search, page: accQ.page, filter: accQ.filter,
        });
        if (!d) return;
        accQ.rows     = arr(d.rows);
        accQ.total    = Number(d.total) || 0;
        accQ.page     = Number(d.page) || 0;
        accQ.pageSize = Number(d.pageSize) || accQ.pageSize;
        renderPlayers();
    }

    function renderPlayers() {
        const host = $('#adm-acc-list');
        if (!host) return;
        const rows = accQ.rows;
        const sum = $('#adm-acc-summary');
        if (sum) sum.textContent = accQ.total ? t('adm_acc_summary', fmtInt(accQ.total)) : '';
        pager('acc', accQ.page, accQ.total, accQ.pageSize);
        if (!rows.length) {
            host.innerHTML = emptyBox('fa-users', t('adm_acc_none'), t('adm_acc_hint'));
            return;
        }
        host.innerHTML = `<div class="adm-thead adm-cols-acc">
                <span>${esc(t('adm_col_holder'))}</span>
                <span>${esc(t('adm_col_iban'))}</span>
                <span class="ta-r">${esc(t('adm_col_bank'))}</span>
                <span class="ta-r">${esc(t('adm_col_cash'))}</span>
                <span class="ta-r">${esc(t('adm_col_savings'))}</span>
                <span>${esc(t('adm_col_status'))}</span>
                <span></span>
            </div>` + rows.map((a) => `<div class="adm-trow adm-cols-acc" data-open="${esc(a.identifier)}" role="button" tabindex="0">
                <span class="adm-cell">
                    <strong><span class="adm-dot${a.source ? ' on' : ''}"></span>${esc(a.name || '—')}</strong>
                    <small class="adm-mini">${esc(t(a.source ? 'adm_acc_online' : 'adm_acc_offline'))}</small>
                </span>
                <span><code class="mono adm-mini">${esc(a.ibanFmt || fmtIban(a.iban))}</code></span>
                <span class="ta-r mono">${money(a.bank)}</span>
                <span class="ta-r mono">${money(a.cash)}</span>
                <span class="ta-r mono">${esc(fmtMoney(a.savings))}</span>
                <span class="adm-flags">
                    ${a.frozen ? `<span class="adm-tag danger"><i class="fa-solid fa-snowflake"></i>${esc(t('adm_acc_frozen'))}</span>` : ''}
                    ${a.locked ? `<span class="adm-tag warn"><i class="fa-solid fa-lock"></i>${esc(t('adm_acc_locked'))}</span>` : ''}
                    ${!a.frozen && !a.locked ? `<span class="adm-tag ok">${esc(t('adm_flag_ok'))}</span>` : ''}
                </span>
                <span class="ta-r"><i class="fa-solid fa-chevron-right adm-go"></i></span>
            </div>`).join('');
    }

    on($('#adm-acc-q'), 'input', (e) => {
        accQ.search = e.target.value;
        accQ.page = 0;
        clearTimeout(typeTimer);
        typeTimer = setTimeout(loadPlayers, 260);
    });
    on($('#adm-acc-q'), 'keydown', (e) => {
        if (e.key !== 'Enter') return;
        e.preventDefault();
        clearTimeout(typeTimer);
        loadPlayers();
    });
    on($('#adm-acc-filter'), 'click', (e) => {
        const b = e.target.closest('button[data-v]');
        if (!b) return;
        segPick(b);
        accQ.filter = b.dataset.v;
        accQ.page = 0;
        loadPlayers();
    });
    on($('#adm-acc-prev'), 'click', () => { if (accQ.page > 0) { accQ.page--; loadPlayers(); } });
    on($('#adm-acc-next'), 'click', () => { accQ.page++; loadPlayers(); });
    on($('#adm-acc-list'), 'click', (e) => {
        const row = e.target.closest('[data-open]');
        if (row) openDrawer(row.dataset.open);
    });

    // ── Account drawer ──
    // Offline characters are NOT blocked here: the server edits them
    // straight in the framework table and answers for itself.
    async function openDrawer(identifier) {
        const d = await call('admin_player', { identifier });
        if (!d) return;
        drawer.id = identifier;
        drawer.data = d;
        const cards = arr(d.cards), subs = arr(d.subs), history = arr(d.history);

        $('#adm-drawer-name').textContent = d.name || '—';
        $('#adm-drawer-iban').textContent = d.ibanFmt || fmtIban(d.iban);
        const st = $('#adm-drawer-state');
        st.className = 'adm-tag' + (d.frozen ? ' danger' : d.source ? ' ok' : '');
        st.textContent = t(d.frozen ? 'adm_acc_frozen' : d.source ? 'adm_acc_online' : 'adm_acc_offline');

        const locked = Number(d.lockedUntil || 0) > Date.now() || Number(d.pinTries || 0) > 0;
        const wallets = [
            { key: 'bank',    label: t('adm_col_bank'),    value: d.bank,    ic: 'fa-building-columns' },
            { key: 'cash',    label: t('adm_col_cash'),    value: d.cash,    ic: 'fa-wallet' },
            { key: 'savings', label: t('adm_col_savings'), value: d.savings, ic: 'fa-piggy-bank' },
        ];

        $('#adm-drawer-body').innerHTML = `
            <div class="adm-dblock">
                <div class="adm-dhead">
                    <h4>${esc(t('adm_d_balances'))}</h4>
                    <span class="muted">${esc(d.job && d.job.label ? d.job.label : d.identifier)}</span>
                </div>
                <div class="input-ic adm-dreason">
                    <i class="fa-solid fa-pen-nib"></i>
                    <input class="apex-input" id="adm-d-reason" type="text" maxlength="60" autocomplete="off"
                           placeholder="${esc(t('adm_reason_ph'))}">
                </div>
                ${wallets.map((w) => `<div class="adm-wallet${w.value == null ? ' off' : ''}">
                    <span class="adm-wallet-ic"><i class="fa-solid ${w.ic}"></i></span>
                    <div class="adm-wallet-id">
                        <small>${esc(w.label)}</small>
                        <strong class="mono">${money(w.value)}</strong>
                    </div>
                    <div class="adm-wallet-edit">
                        <input class="apex-input adm-amount mono" type="number" min="0" step="1" placeholder="0" data-acct="${esc(w.key)}">
                        <button class="btn btn-sm btn-ghost" data-money="add"    data-acct="${esc(w.key)}" title="${esc(t('adm_money_add'))}"><i class="fa-solid fa-plus"></i></button>
                        <button class="btn btn-sm btn-ghost" data-money="remove" data-acct="${esc(w.key)}" title="${esc(t('adm_money_remove'))}"><i class="fa-solid fa-minus"></i></button>
                        <button class="btn btn-sm btn-ghost" data-money="set"    data-acct="${esc(w.key)}" title="${esc(t('adm_money_set'))}"><i class="fa-solid fa-equals"></i></button>
                    </div>
                </div>`).join('')}
            </div>

            <div class="adm-dacts">
                <button class="btn btn-sm ${d.frozen ? 'btn-primary' : 'btn-ghost'}" data-act="freeze">
                    <i class="fa-solid ${d.frozen ? 'fa-sun' : 'fa-snowflake'}"></i> ${esc(t(d.frozen ? 'adm_acc_unfreeze' : 'adm_acc_freeze'))}
                </button>
                <button class="btn btn-sm btn-ghost" data-act="unlock"${locked ? '' : ' disabled'}>
                    <i class="fa-solid fa-lock-open"></i> ${esc(t('adm_act_unlock'))}
                </button>
                <button class="btn btn-sm btn-ghost" data-act="setpin"><i class="fa-solid fa-key"></i> ${esc(t('adm_acc_setpin'))}</button>
                <button class="btn btn-sm btn-ghost" data-act="iban"><i class="fa-solid fa-rotate"></i> ${esc(t('adm_act_iban'))}</button>
                <button class="btn btn-sm btn-ghost" data-act="issue"><i class="fa-solid fa-credit-card"></i> ${esc(t('adm_act_issue'))}</button>
                <button class="btn btn-sm btn-danger" data-act="wipe"><i class="fa-solid fa-trash"></i> ${esc(t('adm_act_wipe'))}</button>
            </div>

            <div class="adm-dblock">
                <div class="adm-dhead">
                    <h4>${esc(t('adm_d_cards'))}</h4>
                    <span class="muted">${esc(fmtInt(cards.length))}</span>
                </div>
                ${cards.length ? cards.map((c) => `<div class="adm-dline">
                    <div class="adm-dline-id">
                        <strong class="mono">${esc(c.serial)}</strong>
                        <small>${esc(fmtDate(c.ts))}</small>
                    </div>
                    ${Number(c.frozen) === 1 ? `<span class="adm-tag danger">${esc(t('adm_acc_frozen'))}</span>` : ''}
                    <div class="adm-dline-acts">
                        <button class="btn btn-sm btn-ghost" data-card="${Number(c.frozen) === 1 ? 'unfreeze' : 'freeze'}" data-serial="${esc(c.serial)}" title="${esc(t(Number(c.frozen) === 1 ? 'adm_card_unfreeze' : 'adm_card_freeze'))}"><i class="fa-solid fa-snowflake"></i></button>
                        <button class="btn btn-sm btn-danger" data-card="revoke" data-serial="${esc(c.serial)}" title="${esc(t('adm_card_revoke'))}"><i class="fa-solid fa-xmark"></i></button>
                    </div>
                </div>`).join('') : `<div class="adm-dempty">${esc(t('adm_d_no_cards'))}</div>`}
            </div>

            <div class="adm-dblock">
                <div class="adm-dhead">
                    <h4>${esc(t('adm_d_loan'))}</h4>
                    <span class="muted">${d.credit && d.credit.tier ? esc(d.credit.tier) : ''}</span>
                </div>
                ${d.loan ? `<div class="adm-dline">
                    <div class="adm-dline-id">
                        <strong class="mono">${esc(fmtMoney(d.loan.remaining))}</strong>
                        <small>${esc(t('adm_loan_of', fmtMoney((Number(d.loan.amount) || 0) + (Number(d.loan.interest) || 0)), fmtDate(d.loan.dueAt)))}</small>
                    </div>
                    <div class="adm-dline-acts">
                        <button class="btn btn-sm btn-ghost" data-loan="extend"  data-id="${esc(d.loan.id)}">${esc(t('adm_loan_extend'))}</button>
                        <button class="btn btn-sm btn-ghost" data-loan="settle"  data-id="${esc(d.loan.id)}">${esc(t('adm_loan_settle'))}</button>
                        <button class="btn btn-sm btn-danger" data-loan="forgive" data-id="${esc(d.loan.id)}">${esc(t('adm_loan_forgive'))}</button>
                    </div>
                </div>` : `<div class="adm-dempty">${esc(t('adm_d_no_loan'))}</div>`}
            </div>

            ${subs.length ? `<div class="adm-dblock">
                <div class="adm-dhead">
                    <h4>${esc(t('adm_d_subs'))}</h4>
                    <span class="muted">${esc(fmtInt(subs.length))}</span>
                </div>
                ${subs.map((s) => `<div class="adm-dline">
                    <div class="adm-dline-id">
                        <strong>${esc(s.label || '—')}</strong>
                        <small class="mono">${esc(fmtIban(s.iban))}</small>
                    </div>
                    <strong class="mono">${esc(fmtMoney(s.balance))}</strong>
                </div>`).join('')}
            </div>` : ''}

            <div class="adm-dblock">
                <div class="adm-dhead">
                    <h4>${esc(t('adm_d_recent'))}</h4>
                    <span class="muted">${esc(fmtInt(history.length))}</span>
                </div>
                ${history.length ? history.map((h) => {
                    const out = h.from_iban === d.iban;
                    return `<div class="adm-dline tight">
                        <div class="adm-dline-id">
                            <strong>${esc(h.label || String(h.kind || '').replace(/_/g, ' '))}</strong>
                            <small>${esc(fmtDate(h.ts))} · ${esc(String(h.kind || '').replace(/_/g, ' '))}</small>
                        </div>
                        <strong class="mono adm-amt${out ? '' : ' in'}">${out ? '−' : '+'}${esc(fmtMoney(h.amount))}</strong>
                    </div>`;
                }).join('') : `<div class="adm-dempty">${esc(t('adm_d_no_tx'))}</div>`}
            </div>`;

        const dr = $('#adm-drawer');
        dr.hidden = false;
        requestAnimationFrame(() => dr.classList.add('open'));
        $('#adm-drawer-body').scrollTop = 0;
    }

    function closeDrawer() {
        const dr = $('#adm-drawer');
        if (!dr || dr.hidden) return;
        dr.classList.remove('open');
        drawer.id = null;
        drawer.data = null;
        setTimeout(() => { dr.hidden = true; }, 180);
    }

    async function reopenDrawer() {
        if (drawer.id) await openDrawer(drawer.id);
        if (current === 'accounts') loadPlayers();
    }

    on($('#adm-drawer-close'), 'click', closeDrawer);

    // One delegated handler for the drawer: its body is rebuilt wholesale
    // on every action, so per-node listeners would leak.
    on($('#adm-drawer'), 'click', async (e) => {
        const identifier = drawer.id;
        if (!identifier) return;
        const host = $('#adm-drawer');

        const moneyBtn = e.target.closest('button[data-money]');
        if (moneyBtn) {
            const account = moneyBtn.dataset.acct;
            const mode = moneyBtn.dataset.money;
            const input = $(`.adm-amount[data-acct="${account}"]`, host);
            const amount = num(input && input.value);
            if (!amount && mode !== 'set') { Notify({ type: 'error', message: t('adm_err_amount') }); return; }
            const reasonEl = $('#adm-d-reason', host);
            const reason = ((reasonEl && reasonEl.value) || '').trim().slice(0, 60);
            const body = t('adm_confirm_money_' + mode, fmtMoney(amount), t('adm_col_' + account), drawer.data && drawer.data.name || identifier);
            if (!await confirmDialog(t('adm_confirm_title'), body)) return;
            const r = await call('admin_money', { identifier, account, mode, amount, reason });
            if (!r) return;
            Notify({ type: 'success', message: t('adm_done_money', fmtMoney(r.value)) });
            reopenDrawer();
            return;
        }

        const cardBtn = e.target.closest('button[data-card]');
        if (cardBtn) {
            const action = cardBtn.dataset.card, serial = cardBtn.dataset.serial;
            if (action === 'revoke'
                && !await confirmDialog(t('adm_confirm_title'), t('adm_confirm_card_revoke', serial))) return;
            if (!await call('admin_card', { identifier, action, serial })) return;
            Notify({ type: 'success', message: t('adm_done_card_' + action) });
            reopenDrawer();
            return;
        }

        const loanBtn = e.target.closest('button[data-loan]');
        if (loanBtn) { doLoan(loanBtn.dataset.loan, Number(loanBtn.dataset.id)); return; }

        const act = e.target.closest('button[data-act]');
        if (!act) return;
        switch (act.dataset.act) {
            case 'freeze': {
                const frozen = !(drawer.data && drawer.data.frozen);
                if (frozen && !await confirmDialog(t('adm_acc_freeze_title'),
                    t('adm_acc_freeze_body', (drawer.data && drawer.data.name) || identifier))) return;
                if (!await call('admin_freeze', { identifier, frozen })) return;
                Notify({ type: 'success', message: t(frozen ? 'adm_acc_frozen_ok' : 'adm_acc_unfrozen_ok') });
                reopenDrawer();
                break;
            }
            case 'unlock':
                // No pin field => the server clears tries + lockout.
                if (!await call('admin_resetpin', { identifier })) return;
                Notify({ type: 'success', message: t('adm_acc_lock_reset_ok') });
                reopenDrawer();
                break;
            case 'setpin': {
                const len = (Runtime.pin && Runtime.pin.length) || 4;
                const pin = await promptDialog(t('adm_acc_setpin'), t('adm_acc_pin_hint', len), 'pin');
                if (pin == null) return;
                if (!new RegExp(`^\\d{${len}}$`).test(String(pin).trim())) {
                    Notify({ type: 'error', message: t('adm_err_pin') });
                    return;
                }
                if (!await call('admin_resetpin', { identifier, pin: String(pin).trim() })) return;
                Notify({ type: 'success', message: t('adm_acc_pin_ok') });
                break;
            }
            case 'iban':
                if (!await confirmDialog(t('adm_confirm_title'), t('adm_confirm_iban'))) return;
                if (!await call('admin_iban', { identifier })) return;
                Notify({ type: 'success', message: t('adm_done_iban') });
                reopenDrawer();
                break;
            case 'issue':
                if (!await call('admin_card', { identifier, action: 'issue' })) return;
                Notify({ type: 'success', message: t('adm_done_card_issue') });
                reopenDrawer();
                break;
            case 'wipe': {
                if (!await confirmDialog(t('adm_confirm_title'), t('adm_confirm_wipe'))) return;
                const typed = await promptDialog(t('adm_act_wipe'), t('adm_prompt_wipe'), 'text');
                if (String(typed || '').trim().toUpperCase() !== 'WIPE') {
                    Notify({ type: 'info', message: t('adm_cancelled') });
                    return;
                }
                if (!await call('admin_wipe', { identifier })) return;
                Notify({ type: 'success', message: t('adm_done_wipe') });
                closeDrawer();
                loadPlayers();
                break;
            }
        }
    });

    // ── Treasuries ──
    async function loadBusiness() {
        const host = $('#adm-biz-table');
        if (host && !host.children.length) host.innerHTML = loadingBox();
        const rows = await call('admin_business');
        if (!rows) return;
        biz.rows = arr(rows);
        renderBusiness();
    }

    function renderBusiness() {
        const host = $('#adm-biz-table');
        if (!host) return;
        const q = biz.search.trim().toLowerCase();
        const rows = biz.rows.filter((r) => !q
            || String(r.label || '').toLowerCase().indexOf(q) >= 0
            || String(r.job || '').toLowerCase().indexOf(q) >= 0);
        const held = biz.rows.reduce((a, r) => a + (Number(r.balance) || 0), 0);
        const sum = $('#adm-biz-summary');
        if (sum) sum.textContent = t('adm_biz_summary', fmtInt(biz.rows.length), fmtMoney(held));
        if (!rows.length) {
            host.innerHTML = emptyBox('fa-briefcase', t('adm_biz_none'), t('adm_biz_none_sub'));
            return;
        }
        host.innerHTML = rows.map((r) => `<div class="adm-biz" data-job="${esc(r.job)}">
            <span class="adm-biz-ic"><i class="fa-solid fa-briefcase"></i></span>
            <div class="adm-biz-id">
                <strong>${esc(r.label || r.job)}</strong>
                <span class="mono">${esc(r.job)} · ${esc(r.ibanFmt || fmtIban(r.iban))}</span>
            </div>
            <div class="adm-biz-stat"><small>${esc(t('adm_col_balance'))}</small><strong class="mono">${esc(fmtMoney(r.balance))}</strong></div>
            <div class="adm-biz-stat"><small>${esc(t('adm_col_staff'))}</small><strong class="mono">${esc(fmtInt(r.employees))}</strong></div>
            <div class="adm-biz-stat"><small>${esc(t('adm_col_payroll'))}</small><strong>${esc(t('adm_biz_every', fmtInt(r.payInterval)) + (r.sync ? ' · ' + t('adm_biz_synced') : ''))}</strong></div>
            <div class="adm-biz-adjust">
                <div class="adm-seg" data-role="mode" data-value="add">
                    <button type="button" class="on" data-v="add" title="${esc(t('adm_money_add'))}"><i class="fa-solid fa-plus"></i></button>
                    <button type="button" data-v="remove" title="${esc(t('adm_money_remove'))}"><i class="fa-solid fa-minus"></i></button>
                    <button type="button" data-v="set" title="${esc(t('adm_money_set'))}"><i class="fa-solid fa-equals"></i></button>
                </div>
                <input class="apex-input adm-amount mono" type="number" min="0" step="1" placeholder="0" data-role="amount">
                <button class="btn btn-sm btn-primary" data-act="bizmoney"><i class="fa-solid fa-check"></i> ${esc(t('adm_apply_short'))}</button>
            </div>
        </div>`).join('');
    }

    on($('#adm-biz-q'), 'input', (e) => { biz.search = e.target.value; renderBusiness(); });
    on($('#adm-biz-table'), 'click', async (e) => {
        const segBtn = e.target.closest('.adm-seg button');
        if (segBtn) { segPick(segBtn); return; }
        const btn = e.target.closest('button[data-act="bizmoney"]');
        if (!btn) return;
        const row = btn.closest('.adm-biz');
        const job = row && row.dataset.job;
        if (!job) return;
        const mode = row.querySelector('[data-role="mode"]').dataset.value;
        const input = row.querySelector('[data-role="amount"]');
        const amount = num(input && input.value);
        if (!amount && mode !== 'set') { Notify({ type: 'error', message: t('adm_err_amount') }); return; }
        if (!await confirmDialog(t('adm_confirm_title'), t('adm_confirm_biz_' + mode, fmtMoney(amount), job))) return;
        const r = await call('admin_business_money', { job, mode, amount });
        if (!r) return;
        if (input) input.value = '';
        Notify({ type: 'success', message: t('adm_done_biz', fmtMoney(r.balance)) });
        loadBusiness();
    });
    on($('#adm-payroll'), 'click', async () => {
        if (!await confirmDialog(t('adm_confirm_title'), t('adm_confirm_payroll'))) return;
        const r = await call('admin_payroll');
        if (!r) return;
        Notify({ type: 'success', message: t('adm_done_payroll', fmtInt(r.count), fmtMoney(r.amount)) });
        loadBusiness();
    });

    // ── Loans ──
    async function loadLoans() {
        const host = $('#adm-loan-table');
        if (host && !host.children.length) host.innerHTML = loadingBox();
        const raw = await call('admin_loans', { scope: loans.scope });
        if (!raw) return;
        loans.rows = arr(raw);
        renderLoans();
    }

    function renderLoans() {
        const host = $('#adm-loan-table');
        if (!host) return;
        const rows = loans.rows;
        const outstanding = rows.reduce((a, r) => a + (Number(r.remaining) || 0), 0);
        const overdue = rows.filter((r) => r.overdue).length;
        const sum = $('#adm-loan-summary');
        if (sum) sum.textContent = t('adm_loan_summary', fmtInt(rows.length), fmtMoney(outstanding), fmtInt(overdue));
        const badge = $('#adm-loan-overdue');
        if (badge && loans.scope === 'active') {
            badge.textContent = String(overdue);
            badge.dataset.empty = String(overdue === 0);
        }
        if (!rows.length) {
            host.innerHTML = emptyBox('fa-hand-holding-dollar', t('adm_loan_none'), t('adm_loan_none_sub'));
            return;
        }
        const active = loans.scope === 'active';
        host.innerHTML = `<div class="adm-thead adm-cols-loan">
                <span>${esc(t('adm_col_borrower'))}</span>
                <span class="ta-r">${esc(t('adm_col_borrowed'))}</span>
                <span class="ta-r">${esc(t('adm_col_interest'))}</span>
                <span class="ta-r">${esc(t('adm_col_remaining'))}</span>
                <span>${esc(t('adm_col_due'))}</span>
                <span></span>
            </div>` + rows.map((r) => `<div class="adm-trow adm-cols-loan">
                <span class="adm-cell" data-open="${esc(r.identifier)}" role="button" tabindex="0">
                    <strong>${esc(r.name || r.identifier)}</strong>
                    <code class="mono adm-mini">${esc(fmtIban(r.iban))}</code>
                </span>
                <span class="ta-r mono">${esc(fmtMoney(r.amount))}</span>
                <span class="ta-r mono">${esc(fmtMoney(r.interest))}</span>
                <span class="ta-r mono"><strong>${esc(fmtMoney(r.remaining))}</strong></span>
                <span>${r.overdue
                    ? `<span class="adm-tag danger"><i class="fa-solid fa-triangle-exclamation"></i>${esc(t('adm_loan_overdue', fmtDate(r.dueAt)))}</span>`
                    : `<span class="muted">${esc(fmtDate(r.closedAt || r.dueAt))}</span>`}</span>
                <span class="adm-rowacts">${active ? `
                    <button class="btn btn-sm btn-ghost" data-loan="extend"  data-id="${esc(r.id)}">${esc(t('adm_loan_extend'))}</button>
                    <button class="btn btn-sm btn-ghost" data-loan="settle"  data-id="${esc(r.id)}">${esc(t('adm_loan_settle'))}</button>
                    <button class="btn btn-sm btn-danger" data-loan="forgive" data-id="${esc(r.id)}">${esc(t('adm_loan_forgive'))}</button>`
                    : `<span class="adm-tag ok">${esc(t('adm_loan_closed'))}</span>`}</span>
            </div>`).join('');
    }

    // Shared by the Loans pane and the drawer's loan block.
    async function doLoan(action, id) {
        if (!id) return;
        const extra = {};
        if (action === 'extend') {
            const days = await promptDialog(t('adm_loan_extend'), t('adm_prompt_days'), 'number', '7');
            const n = Math.floor(Number(days) || 0);
            if (!(n > 0)) return;
            extra.days = Math.min(30, n);
        } else if (!await confirmDialog(t('adm_confirm_title'), t('adm_confirm_loan_' + action))) {
            return;
        }
        if (!await call('admin_loan_action', Object.assign({ id, action }, extra))) return;
        Notify({ type: 'success', message: t('adm_done_loan') });
        if (current === 'loans') loadLoans();
        if (drawer.id) reopenDrawer();
    }

    on($('#adm-loan-scope'), 'click', (e) => {
        const b = e.target.closest('button[data-v]');
        if (!b) return;
        segPick(b);
        loans.scope = b.dataset.v;
        loadLoans();
    });
    on($('#adm-loan-table'), 'click', (e) => {
        const lb = e.target.closest('button[data-loan]');
        if (lb) { doLoan(lb.dataset.loan, Number(lb.dataset.id)); return; }
        // The drawer floats over the whole shell, so the borrower opens
        // from here without leaving the Loans pane.
        const cell = e.target.closest('[data-open]');
        if (cell) openDrawer(cell.dataset.open);
    });

    // ── Ledger ──
    async function loadLedger() {
        const host = $('#adm-ledger-table');
        if (host && !host.children.length) host.innerHTML = loadingBox();
        const d = await call('admin_ledger', {
            search: ledger.search, kind: ledger.kind, page: ledger.page,
        });
        if (!d) return;
        ledger.total    = Number(d.total) || 0;
        ledger.page     = Number(d.page) || 0;
        ledger.pageSize = Number(d.pageSize) || ledger.pageSize;

        // The kinds come from the table itself, so they are built once and
        // then left alone — rebuilding them would fight the active filter.
        const kinds = $('#adm-ledger-kinds');
        if (kinds && !ledger.kindsBuilt) {
            ledger.kindsBuilt = true;
            kinds.innerHTML = [{ k: 'all', l: t('adm_filter_all') }]
                .concat(arr(d.kinds).map((k) => ({ k: String(k), l: String(k).replace(/_/g, ' ') })))
                .map((o) => `<button class="adm-pill${o.k === ledger.kind ? ' on' : ''}" data-kind="${esc(o.k)}">${esc(o.l)}</button>`)
                .join('');
        }

        const sum = $('#adm-ledger-summary');
        if (sum) sum.textContent = t('adm_ledger_summary', fmtInt(ledger.total));
        pager('ledger', ledger.page, ledger.total, ledger.pageSize);

        if (!host) return;
        const rows = arr(d.rows);
        if (!rows.length) {
            host.innerHTML = emptyBox('fa-receipt', t('adm_ledger_none'), t('adm_ledger_none_sub'));
            return;
        }
        host.innerHTML = `<div class="adm-thead adm-cols-ledger">
                <span>${esc(t('adm_col_when'))}</span>
                <span>${esc(t('adm_col_kind'))}</span>
                <span>${esc(t('adm_col_movement'))}</span>
                <span>${esc(t('adm_col_actor'))}</span>
                <span class="ta-r">${esc(t('adm_col_amount'))}</span>
                <span class="ta-r">${esc(t('adm_col_fee'))}</span>
            </div>` + rows.map((r) => `<div class="adm-trow adm-cols-ledger">
                <span class="muted mono adm-mini">${esc(fmtDate(r.ts))}</span>
                <span><span class="adm-tag">${esc(String(r.kind || '').replace(/_/g, ' '))}</span></span>
                <span class="adm-cell">
                    <strong>${esc(r.label || '—')}</strong>
                    <code class="mono adm-mini">${esc(r.from_iban ? fmtIban(r.from_iban) : '—')} → ${esc(r.to_iban ? fmtIban(r.to_iban) : '—')}</code>
                </span>
                <span class="muted adm-mini">${esc(r.actor || '—')}</span>
                <span class="ta-r mono"><strong>${esc(fmtMoney(r.amount))}</strong></span>
                <span class="ta-r mono muted">${r.fee ? esc(fmtMoney(r.fee)) : '—'}</span>
            </div>`).join('');
    }

    on($('#adm-ledger-q'), 'input', (e) => {
        ledger.search = e.target.value;
        ledger.page = 0;
        clearTimeout(typeTimer);
        typeTimer = setTimeout(loadLedger, 260);
    });
    on($('#adm-ledger-kinds'), 'click', (e) => {
        const b = e.target.closest('button[data-kind]');
        if (!b) return;
        $$('#adm-ledger-kinds .adm-pill').forEach((x) => x.classList.toggle('on', x === b));
        ledger.kind = b.dataset.kind;
        ledger.page = 0;
        loadLedger();
    });
    on($('#adm-ledger-prev'), 'click', () => { if (ledger.page > 0) { ledger.page--; loadLedger(); } });
    on($('#adm-ledger-next'), 'click', () => { ledger.page++; loadLedger(); });

    // ── Audit ──
    async function loadAudit() {
        const host = $('#adm-audit-table');
        if (host && !host.children.length) host.innerHTML = loadingBox();
        const raw = await call('admin_audit');
        if (!raw) return;
        const rows = arr(raw);
        const sum = $('#adm-audit-summary');
        if (sum) sum.textContent = t('adm_audit_summary', fmtInt(rows.length));
        if (!host) return;
        if (!rows.length) {
            host.innerHTML = emptyBox('fa-clipboard-list', t('adm_audit_none'), t('adm_audit_none_sub'));
            return;
        }
        host.innerHTML = `<div class="adm-thead adm-cols-audit">
                <span>${esc(t('adm_col_when'))}</span>
                <span>${esc(t('adm_col_admin'))}</span>
                <span>${esc(t('adm_col_action'))}</span>
                <span>${esc(t('adm_col_target'))}</span>
                <span class="ta-r">${esc(t('adm_col_amount'))}</span>
            </div>` + rows.map((r) => `<div class="adm-trow adm-cols-audit">
                <span class="muted mono adm-mini">${esc(fmtDate(r.ts))}</span>
                <span><strong>${esc(r.admin_name || '—')}</strong></span>
                <span class="adm-cell">
                    <span class="adm-tag">${esc(String(r.action || '—').replace(/_/g, ' '))}</span>
                    ${r.detail ? `<small class="adm-mini muted">${esc(r.detail)}</small>` : ''}
                </span>
                <span>${esc(r.target_name || '—')}</span>
                <span class="ta-r mono">${Number(r.amount) ? esc(fmtMoney(r.amount)) : '<span class="muted">—</span>'}</span>
            </div>`).join('');
    }

    // ── Dashboard payload ──
    // admin_dash answers with the grouped economy snapshot; renderDash()
    // was built on the flat one admin_refresh carries. Accept both so
    // neither side of the contract can blank the dashboard.
    function normStats(d) {
        if (!d || typeof d !== 'object') return null;
        if (!d.accounts || typeof d.accounts !== 'object') return d;
        const old = data.stats || {};
        const g = (o, k) => (o && o[k] != null ? o[k] : 0);
        return {
            accounts: g(d.accounts, 'total'), frozen: g(d.accounts, 'frozen'),
            savings: g(d.accounts, 'savings'), locked: old.locked || 0,
            online: d.online != null ? d.online : (old.online || 0), uptime: old.uptime || 0,
            cards: g(d.cards, 'total'), cardsFrozen: g(d.cards, 'frozen'),
            loans: g(d.loans, 'active'), loansRemaining: g(d.loans, 'outstanding'),
            volume24: g(d.tx, 'volume'), tx24: g(d.tx, 'count'), fees24: g(d.tx, 'fees'),
            subAccounts: g(d.subs, 'total'), subBalance: g(d.subs, 'balance'),
            atms: (data.atms || []).length,
            recent: Array.isArray(d.recent) ? d.recent : (old.recent || []),
        };
    }

    // Deliberately NOT through call(): a server that never registered
    // admin_dash should leave the admin_refresh paint alone, not shout.
    async function loadDash() {
        const r = await post('admin_dash');
        if (!r || !r.ok) return;
        const s = normStats(r.data);
        if (!s) return;
        data.stats = s;
        renderDash();
    }

    function loadView(name) {
        if (name === 'dash') loadDash();
        else if (name === 'accounts') loadPlayers();
        else if (name === 'treasuries') loadBusiness();
        else if (name === 'loans') loadLoans();
        else if (name === 'ledger') loadLedger();
        else if (name === 'audit') loadAudit();
    }

    // ── Placed ATMs ──
    function renderAtms() {
        const list = $('#adm-atm-list');
        const rows = Array.isArray(data.atms) ? data.atms : [];
        const count = $('#adm-atm-count');
        count.textContent = String(rows.length);
        count.dataset.empty = String(rows.length === 0);
        $('#adm-atm-summary').textContent = t('adm_atm_summary', rows.length);
        if (!rows.length) {
            list.innerHTML = `<div class="adm-empty">
                <span class="adm-empty-ic"><i class="fa-solid fa-money-check-dollar"></i></span>
                <strong>${esc(t('adm_atm_none'))}</strong>
                <small>${esc(t('adm_atm_none_sub'))}</small>
            </div>`;
            return;
        }
        list.innerHTML = rows.map((r) => `<div class="adm-atm" data-id="${r.id}">
            <span class="adm-atm-ic"><i class="fa-solid fa-money-check-dollar"></i></span>
            <div class="adm-atm-main">
                <span class="adm-atm-model">${esc(r.model)}</span>
                <span class="adm-atm-meta">
                    <span>#${r.id}</span>
                    <span>${one(r.x)}, ${one(r.y)}, ${one(r.z)}</span>
                    <span class="adm-atm-dist">${esc(t('adm_atm_distance', Math.round(r.distance || 0)))}</span>
                </span>
            </div>
            <div class="adm-atm-actions">
                <button class="btn btn-sm btn-ghost" data-act="goto"><i class="fa-solid fa-location-arrow"></i> ${esc(t('adm_atm_goto'))}</button>
                <button class="btn btn-sm btn-danger" data-act="remove"><i class="fa-solid fa-trash"></i> ${esc(t('adm_atm_remove'))}</button>
            </div>
        </div>`).join('');
    }

    on($('#adm-atm-place'), 'click', () => { post('admin_atm_place'); close(false); });
    // both calibrators take over the screen at the nearest ATM
    on($('#adm-atm-calib-buttons'), 'click', () => { post('admin_atm_calibrate', { kind: 'buttons' }); close(false); });
    on($('#adm-atm-calib-screen'),  'click', () => { post('admin_atm_calibrate', { kind: 'screen' });  close(false); });
    on($('#adm-atm-list'), 'click', async (e) => {
        const btn = e.target.closest('button[data-act]');
        if (!btn) return;
        const row = btn.closest('.adm-atm');
        const id = Number(row && row.dataset.id);
        if (!id) return;
        if (btn.dataset.act === 'goto') { post('admin_atm_goto', { id }); close(false); return; }
        if (!await confirmDialog(t('adm_atm_remove_title'), t('adm_atm_remove_body', '#' + id))) return;
        const r = await post('admin_atm_remove', { id });
        if (r && r.ok) {
            if (r.data) { data = Object.assign(data, r.data); renderAtms(); renderStatus(); } else { refresh(true); }
            Notify({ type: 'success', message: t('adm_atm_removed') });
        } else {
            Notify({ type: 'error', message: t('js_not_authorised') });
        }
    });

    // ── Appearance ──
    function presetRow(container, list, currentHex, onPick) {
        if (!container) return;
        container.innerHTML = '';
        list.forEach((c) => {
            const b = document.createElement('button');
            b.className = 'preset-swatch';
            if (c.toUpperCase() === String(currentHex || '').toUpperCase()) b.classList.add('active');
            b.style.setProperty('--_c', c);
            b.title = c;
            on(b, 'click', () => onPick(c));
            container.appendChild(b);
        });
    }
    function paintSwatch(input) {
        const chip = input && input.closest('.color-swatch-big');
        if (chip) chip.style.background = input.value;
    }
    const themeDef = () => THEMES[look.theme] || THEMES.apex;
    const effectiveBg = () => look.bg || themeDef().bg;

    // The panel itself is built on the bank's tokens, so previewing means
    // painting the real thing. Nothing reaches other players until Apply.
    function preview() {
        previewing = true;
        applyLayoutPreset(look.layout);
        const def = applyThemePreset(look.theme);
        applyBrandRamp(look.brand);
        applyBackgroundRamp(effectiveBg(), def.mode);
        paintMini();
    }
    function paintMini() {
        const bg = effectiveBg();
        const c = _hexToRgb(themeDef().mode === 'light' ? '#111726' : bg);
        const dark = (w) => `rgb(${Math.round(c.r * (1 - w))},${Math.round(c.g * (1 - w))},${Math.round(c.b * (1 - w))})`;
        $('#adm-prev-atm').style.background = `linear-gradient(180deg, ${dark(0)} 0%, ${dark(0.35)} 45%, ${dark(0.62)} 100%)`;
        $('#adm-prev-panel').style.background = bg;
        $$('.adm-prev-pill, .adm-prev-chip').forEach((x) => { x.style.background = look.brand; });
    }

    // Tiles are DIVs on purpose: the game's CEF does not lay out the
    // children of a flex-column <button> the way desktop Chromium does
    // (the art collapsed to its sidebar in-game). Each tile is a small
    // mock of the real dashboard in that preset's colours and shape.
    function renderThemes() {
        $('#adm-theme-grid').innerHTML = THEME_ORDER.map((id) => {
            const d = THEMES[id];
            const radius = Math.round(6 * d.radius);
            return `<div class="adm-theme${look.theme === id ? ' active' : ''}" data-theme-id="${id}" data-mode="${d.mode}" role="button" tabindex="0"
                style="--tb:${d.brand};--tg:${d.bg};--tr:${radius}px;${d.display ? `--tf:${d.display.replace(/"/g, '&quot;')}` : ''}">
                <div class="ta">
                    <div class="ta-side"><i class="ta-mark"></i><b class="on"></b><b></b><b></b><b></b></div>
                    <div class="ta-main">
                        <div class="ta-top"><b></b><i></i></div>
                        <div class="ta-hero"><span class="ta-amt">$109,350</span><span class="ta-pill"></span><span class="ta-bar"><i></i></span></div>
                        <div class="ta-cards"><span class="ta-card"><i></i><b></b></span><span class="ta-card"><i></i><b></b></span></div>
                    </div>
                </div>
                <div class="adm-theme-name">${esc(d.name)}${d.mode === 'light' ? `<span class="adm-theme-mode">${esc(t('adm_t_light'))}</span>` : ''}</div>
                <div class="adm-theme-desc">${esc(t('adm_t_' + id))}</div>
            </div>`;
        }).join('');
    }
    // Layout tiles: a schematic of where nav / hero / cards sit.
    function renderLayouts() {
        $('#adm-layout-grid').innerHTML = LAYOUT_ORDER.map((id) => `<div class="adm-layout${look.layout === id ? ' active' : ''}" data-layout-id="${id}" role="button" tabindex="0">
            <div class="la" data-l="${id}"><i class="la-nav"></i><i class="la-hero"></i><i class="la-a"></i><i class="la-b"></i><i class="la-c"></i></div>
            <span class="adm-layout-name">${esc(LAYOUTS[id].name)}</span>
            <span class="adm-layout-desc">${esc(t('adm_l_' + id))}</span>
        </div>`).join('');
    }
    on($('#adm-layout-grid'), 'click', (e) => {
        const b = e.target.closest('.adm-layout');
        if (!b || !LAYOUTS[b.dataset.layoutId]) return;
        look.layout = b.dataset.layoutId;
        renderLayouts();
        preview();
    });

    on($('#adm-theme-grid'), 'click', (e) => {
        const b = e.target.closest('.adm-theme');
        if (!b) return;
        const id = b.dataset.themeId;
        if (!THEMES[id]) return;
        look.theme = id;
        look.brand = THEMES[id].brand;
        look.bg = null;
        renderThemes();
        paintColours();
        preview();
    });

    function paintColours() {
        const def = themeDef();
        $('#adm-brand-input').value = look.brand;
        $('#adm-brand-hex').textContent = String(look.brand).toUpperCase();
        $('#adm-bg-input').value = effectiveBg();
        $('#adm-bg-hex').textContent = look.bg ? String(look.bg).toUpperCase() : t('adm_bg_theme', def.name);
        paintSwatch($('#adm-brand-input'));
        paintSwatch($('#adm-bg-input'));
        presetRow($('#adm-brand-presets'), PRESETS, look.brand, pickBrand);
        presetRow($('#adm-bg-presets'), BG_PRESETS, look.bg || '', pickBg);
        paintMini();
    }
    function pickBrand(c) { look.brand = c; paintColours(); preview(); }
    function pickBg(c) { look.bg = c; paintColours(); preview(); }
    on($('#adm-brand-input'), 'input', (e) => pickBrand(e.target.value));
    on($('#adm-bg-input'), 'input', (e) => pickBg(e.target.value));
    on($('#adm-bg-clear'), 'click', () => { look.bg = null; paintColours(); preview(); });

    // No on/off switch: this panel is admin-only, so "Apply to everyone"
    // is the switch. The rail just states what players are getting.
    function paintMode(enabled) {
        const rail = $('#adm-mode');
        if (rail) rail.classList.toggle('on', !!enabled);
        const v = $('#adm-mode-value');
        if (v) v.textContent = t(enabled ? 'adm_look_on' : 'adm_look_off');
    }

    function renderLook() {
        const th = data.theme || {};
        look = {
            enabled: th.enabled === true,
            theme: (th.enabled && THEMES[th.theme]) ? th.theme : 'apex',
            layout: (th.enabled && LAYOUTS[th.layout]) ? th.layout : 'classic',
            brand: th.brand || DEF_BRAND,
            bg: (th.enabled && th.bg) || null,
        };
        paintMode(look.enabled);
        renderLayouts();
        renderThemes();
        paintColours();
    }

    // Applying implies switching admin mode on — otherwise the button
    // would appear to do nothing. bg:false clears the override so every
    // client falls back to the preset's own background.
    async function send(enabled) {
        const def = themeDef();
        const payload = {
            enabled,
            brand: look.brand || DEF_BRAND,
            bg: look.bg || false,
            theme: look.theme === 'apex' ? false : look.theme,
            layout: look.layout === 'classic' ? false : look.layout,
            mode: def.mode,
        };
        const r = await post('admin_theme_set', payload);
        if (!r || !r.ok) {
            Notify({ type: 'error', message: r && r.why === 'not_admin' ? t('js_not_authorised') : t('js_broadcast_failed') });
            return null;
        }
        data.theme = { enabled, brand: payload.brand, bg: look.bg || null, theme: enabled ? look.theme : null, layout: enabled ? look.layout : null, mode: def.mode };
        previewing = false;          // what is on screen is now the truth
        paintMode(enabled);
        renderStatus();
        return r;
    }

    on($('#adm-look-apply'), 'click', async () => {
        if (!await confirmDialog(t('adm_apply_title'), t('adm_apply_body', themeDef().name, String(look.brand).toUpperCase()))) return;
        const r = await send(true);
        if (r) Notify({ type: 'success', message: t('js_broadcast_ok') });
    });
    on($('#adm-look-reset'), 'click', async () => {
        if (!await confirmDialog(t('js_reset_brand_title'), t('js_reset_brand_body'))) return;
        look = { enabled: false, theme: 'apex', layout: 'classic', brand: DEF_BRAND, bg: null };
        const r = await send(false);
        if (!r) return;
        renderLook();
        Notify({ type: 'success', message: t('js_reset_brand_ok') });
    });

    // ── Shell ──
    function tab(name) {
        current = name;
        $$('.adm-nav-item').forEach((b) => b.classList.toggle('active', b.dataset.atab === name));
        $$('.adm-pane').forEach((p) => { p.hidden = p.dataset.apane !== name; });
        const title = $('#adm-top-title');
        if (title) title.textContent = t('adm_tab_' + name);
        closeDrawer();
        const body = $('.adm-body');
        if (body) body.scrollTop = 0;
        // Entering a data pane always re-reads it: stale economy figures
        // are worse than half a second of waiting.
        loadView(name);
    }
    $$('.adm-nav-item').forEach((b) => on(b, 'click', () => tab(b.dataset.atab)));

    function renderAll() {
        renderDash();
        renderFeatures();
        renderAtms();
        renderLook();
        renderPlayers();
    }

    async function refresh(silent) {
        const r = await post('admin_refresh');
        if (r && r.ok && r.data) {
            data = r.data;
            renderAll();
            loadView(current);
        } else if (!silent) {
            Notify({ type: 'error', message: t('js_not_authorised') });
        }
    }

    function open(payload) {
        data = payload || data;
        accQ = ACC0();
        ledger = LEDGER0();
        biz = { rows: [], search: '' };
        loans = { scope: 'active', rows: [] };
        ['#adm-acc-q', '#adm-biz-q', '#adm-ledger-q'].forEach((s) => { const i = $(s); if (i) i.value = ''; });
        const kinds = $('#adm-ledger-kinds');
        if (kinds) kinds.innerHTML = '';
        segReset('#adm-acc-filter', 'all');
        segReset('#adm-loan-scope', 'active');
        previewing = false;
        el().hidden = false;
        renderAll();
        tab('dash');
    }

    function close(notify = true) {
        if (el().hidden) return;
        closeDrawer();
        el().hidden = true;
        try { ColorPicker.close(); } catch (_) { /* never opened */ }
        // drop an unapplied preview: back to what the server says
        if (previewing) { previewing = false; applyAdminLook(Runtime.adminTheme); }
        if (notify) post('admin_close');
    }

    on($('#adm-close'), 'click', () => close());
    on($('#adm-x'), 'click', () => close());
    on($('#adm-refresh'), 'click', () => refresh());

    return { open, close, refresh, isOpen: () => !el().hidden };
})();

// ═══════════════════════════════════════════════════════
// MESSAGE PIPE
// ═══════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════
// THEME SHOWCASE (/bankshowcase)
// Cycles every preset on THIS client only — a demo reel for videos.
// Nothing is sent to the server; stopping restores the real look.
// ═══════════════════════════════════════════════════════
const ThemeShowcase = (() => {
    let timer = null, idx = 0;
    const badge = () => document.getElementById('theme-showcase-badge');

    function show(id) {
        const def = applyThemePreset(id);
        // every step also moves the structure along, so the reel shows
        // theme × layout combinations instead of colours alone
        const lay = applyLayoutPreset(LAYOUT_ORDER[idx % LAYOUT_ORDER.length]);
        applyBrandRamp(def.brand);
        applyBackgroundRamp(def.bg, def.mode);
        const b = badge();
        if (b) b.textContent = def.name + ' · ' + lay.name;   // no re-animation: at fast intervals it would never settle
        try { Bank.repaintChart && Bank.repaintChart(); } catch (_) { /* no chart on screen */ }
    }
    function start(interval) {
        stop(false);
        const b = badge();
        if (b) { b.hidden = false; b.classList.remove('pop'); void b.offsetWidth; b.classList.add('pop'); }
        idx = 0;
        show(THEME_ORDER[0]);
        timer = setInterval(() => { idx = (idx + 1) % THEME_ORDER.length; show(THEME_ORDER[idx]); },
            Math.max(80, Number(interval) || 700));
    }
    function stop(restore = true) {
        if (timer) { clearInterval(timer); timer = null; }
        const b = badge(); if (b) b.hidden = true;
        if (restore) { applyAdminLook(Runtime.adminTheme); post('bank_showcase_ended'); }
    }
    return { start, stop, running: () => !!timer };
})();

window.addEventListener('message', (ev) => {
    const msg = ev.data; if (!msg || !msg.action) return;
    const p = msg.payload || {};
    switch (msg.action) {
        case 'bootstrap':
            Object.assign(Runtime, p);
            applyTheme(p.theme);
            applyLocale(p.locale);
            // admin mode may already be running a preset / background
            applyAdminLook(p.adminTheme);
            applyFeatures(p.features);
            break;

        case 'features': applyFeatures(p); break;
        case 'themeShowcase': p.on ? ThemeShowcase.start(p.interval) : ThemeShowcase.stop(true); break;

        // An admin flipped the server-wide appearance: repaint immediately,
        // even if the bank panel is open right now.
        case 'adminTheme':
            // Lua already resolved the brand (admin colour, or the player's
            // own when admin mode went off); the preset and background
            // follow from the admin state.
            Runtime.adminTheme = { enabled: p.enabled === true, brand: p.brand, bg: p.bg, theme: p.theme, mode: p.mode, layout: p.layout };
            Runtime.theme = Runtime.theme || {};
            if (p.brand) Runtime.theme.brand = p.brand;
            applyAdminLook(Runtime.adminTheme);
            break;

        // /bankadmin
        case 'adminOpen':  AdminPanel.open(p);      break;
        case 'adminClose': AdminPanel.close(false); break;
        // World icon: Lua sends the fields at the message root
        // (not nested in payload), so pass the whole message.
        case 'show3DIcon': WorldIcon.show(msg); break;
        case 'hide3DIcon': WorldIcon.hide();   break;
        case 'notify':     Notify(p);          break;

        // Onboarding
        case 'onb_open':   Onboarding.open();  break;
        case 'onb_close':  Onboarding.close(); break;

        // Bank — Bank.open() returns a promise (loader sequence)
        // but the router doesn't have to await it; data messages
        // will queue and apply once the overlay is up.
        case 'bank_open':  Bank.open(p);       break;
        case 'bank_close': if (ThemeShowcase.running()) ThemeShowcase.stop(true); Bank.close(false); Loader.hide(); break;
        case 'bank_data':  Bank.applyData(p);  break;

        // Fingerprint world overlay
        case 'fp_start':    FpWorld.start(p.duration || 4500); break;
        case 'fp_progress': FpWorld.start(p.duration || 4500); break;
        case 'fp_done':     FpWorld.done(); break;

        // ATM
        case 'atm_open':   Atm.open(p);   break;
        case 'atm_close':  Atm.close(false);   break;

        // Admin ATM placer (ghost placement controls panel)
        case 'atmplacer_open':
        case 'atmplacer_update': {
            const el = document.getElementById('atmplacer');
            if (el) el.hidden = false;
            const m = document.getElementById('atmplacer-model');
            if (m && p.model) {
                m.textContent = p.total > 1 ? `${p.model} · ${p.idx}/${p.total}` : p.model;
            }
            break;
        }
        case 'atmplacer_close': {
            const el = document.getElementById('atmplacer');
            if (el) el.hidden = true;
            break;
        }
    }
});

// ESC handler — both Bank.close() and Atm.close() already post
// to Lua, which releases NUI focus and the cursor.
window.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    if (ColorPicker.isOpen()) { ColorPicker.close(); return; }
    if (AdminPanel.isOpen())  { AdminPanel.close(); return; }
    if (!document.getElementById('atm-overlay').hidden)        Atm.close();
    else if (!document.getElementById('bank-overlay').hidden)  Bank.close();
    else if (!document.getElementById('onb-overlay').hidden)   {
        // Onboarding: just close the modal and let go of focus.
        document.getElementById('onb-overlay').hidden = true;
        post('bank_close');
    }
});

})();
