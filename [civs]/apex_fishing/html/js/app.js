/* ============================================================
   Apex Fishing — NUI
   ============================================================ */
const RES = (() => {
    try { return window.GetParentResourceName ? window.GetParentResourceName() : 'apex_fishing'; }
    catch { return 'apex_fishing'; }
})();

const post = (name, data = {}) =>
    fetch(`https://${RES}/${name}`, { method: 'POST', body: JSON.stringify(data) }).catch(() => {});

const fmt = (n) => '£' + Number(n || 0).toLocaleString('en-US');
// Compact money for tight spots (sidebar): exact under 1M, abbreviated
// above (e.g. $1.2M) so the value never gets clipped in a narrow chip.
const fmtCash = (n) => {
    n = Math.round(Number(n) || 0);
    const a = Math.abs(n);
    if (a >= 1e9) return '$' + (n / 1e9).toFixed(2).replace(/\.?0+$/, '') + 'B';
    if (a >= 1e6) return '$' + (n / 1e6).toFixed(2).replace(/\.?0+$/, '') + 'M';
    return '$' + n.toLocaleString('en-US');
};
const $   = (sel, root = document) => root.querySelector(sel);
const $$  = (sel, root = document) => Array.from(root.querySelectorAll(sel));

// Count-up: animate an element's number from its last value to `to`.
// Skips the animation when the value is unchanged (stored on the
// element) so re-renders don't re-trigger it. fmtFn receives an int.
function animateNumber(el, to, fmtFn) {
    if (!el) return;
    fmtFn = fmtFn || ((n) => Math.round(n).toLocaleString('en-US'));
    to = Number(to) || 0;
    const from = parseFloat(el.dataset.val);
    el.dataset.val = to;
    if (!isFinite(from) || from === to) { el.textContent = fmtFn(to); return; }
    const dur = 600, start = performance.now();
    const tick = (now) => {
        const p = Math.min(1, (now - start) / dur);
        const eased = 1 - Math.pow(1 - p, 3);
        el.textContent = fmtFn(Math.round(from + (to - from) * eased));
        if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
}

let STATE = {
    snap: null,
    rods: [], fish: [], junk: [], boats: [], rarities: {},
    zones: {}, conditions: null,
    upgrades: [],
    baitCost: 12,
    imgBase: 'nui://ox_inventory/web/images/',
};

// Helpers — image URL + safe img fallback. If a PNG is missing the
// browser shows a broken icon; we hide it via onerror so the parent
// container takes over (usually a Font Awesome fallback below).
const imgUrl  = (item) => item ? `${STATE.imgBase}${item}.png` : '';
const imgTag  = (item, extraClass = '') => item
    ? `<img class="item-img ${extraClass}" src="${imgUrl(item)}" alt="" onerror="this.style.display='none'">`
    : '';
// Boat preview image (FiveM docs hosts a webp per vehicle spawn name)
const boatImgUrl = (model) => model ? `https://docs.fivem.net/vehicles/${model}.webp` : '';
const boatImgTag = (model) => model
    ? `<img class="boat-img" src="${boatImgUrl(model)}" alt="" onerror="this.style.display='none'">`
    : '';

// ═══════════════════════════════════════════════════════════
// SETTINGS — brand color, opacity, UI scale
// Persists to localStorage so choices survive sessions.
// ═══════════════════════════════════════════════════════════
const Settings = (() => {
    const KEY = 'apex_fishing_settings_v1';
    const root = document.documentElement;
    const defaults = { brand: '#1F5EFF', bg: '#080B12', opacity: 1.0, scale: 1.0 };
    let state = { ...defaults };
    // Which keys the player has explicitly saved — a server-config
    // default (Config.theme) only fills the ones the user never set,
    // so the player's own choice always wins.
    let userKeys = new Set();

    function load() {
        try {
            const raw = localStorage.getItem(KEY);
            if (raw) {
                const o = JSON.parse(raw);
                state = { ...defaults, ...o };
                userKeys = new Set(Object.keys(o));
            }
        } catch {}
        apply();
    }
    function save() {
        try { localStorage.setItem(KEY, JSON.stringify(state)); } catch {}
        // Once a player engages with Settings their saved state is
        // authoritative over any server-config default.
        userKeys = new Set(Object.keys(state));
    }

    // Convert hex to rgb tuple for the alpha tokens.
    function hexToRgb(hex) {
        const m = hex.replace('#', '');
        const n = parseInt(m, 16);
        if (m.length === 6) return [n >> 16 & 255, n >> 8 & 255, n & 255];
        return [31, 94, 255];
    }
    function hexShade(hex, percent) {
        const [r, g, b] = hexToRgb(hex);
        const f = percent < 0 ? 0 : 255;
        const t = Math.abs(percent);
        const sh = (c) => Math.round((f - c) * t + c);
        return `rgb(${sh(r)}, ${sh(g)}, ${sh(b)})`;
    }
    // Lighten a base toward white by `p` (0..1) — used to derive the
    // whole surface/line stack from one master background colour.
    function mixWhite(hex, p) {
        const [r, g, b] = hexToRgb(hex);
        const m = (c) => Math.round(c + (255 - c) * p);
        return `rgb(${m(r)}, ${m(g)}, ${m(b)})`;
    }
    // Re-tint every panel surface + border from the chosen background.
    // The step ramp mirrors the original neutral design so the default
    // looks familiar — just deeper and cooler.
    function applyBackground(bg) {
        root.style.setProperty('--surface-0', bg);
        root.style.setProperty('--surface-1', mixWhite(bg, 0.045));
        root.style.setProperty('--surface-2', mixWhite(bg, 0.085));
        root.style.setProperty('--surface-3', mixWhite(bg, 0.140));
        root.style.setProperty('--surface-4', mixWhite(bg, 0.200));
        root.style.setProperty('--surface-5', mixWhite(bg, 0.270));
        root.style.setProperty('--line-1',    mixWhite(bg, 0.070));
        root.style.setProperty('--line-2',    mixWhite(bg, 0.120));
        root.style.setProperty('--line-3',    mixWhite(bg, 0.210));
        root.style.setProperty('--line-4',    mixWhite(bg, 0.300));
    }

    function apply() {
        applyBackground(state.bg);
        const [r, g, b] = hexToRgb(state.brand);
        // Map the brand token + its alpha variants
        root.style.setProperty('--brand-500', state.brand);
        root.style.setProperty('--brand-400', hexShade(state.brand,  0.18));
        root.style.setProperty('--brand-300', hexShade(state.brand,  0.36));
        root.style.setProperty('--brand-600', hexShade(state.brand, -0.10));
        root.style.setProperty('--brand-700', hexShade(state.brand, -0.20));
        // Keep the legacy --teal-* aliases tracking the brand.
        root.style.setProperty('--teal-400', hexShade(state.brand, 0.18));
        root.style.setProperty('--teal-500', state.brand);
        const rgb = `${r}, ${g}, ${b}`;
        root.style.setProperty('--brand-a08', `rgba(${rgb}, .08)`);
        root.style.setProperty('--brand-a12', `rgba(${rgb}, .12)`);
        root.style.setProperty('--brand-a18', `rgba(${rgb}, .18)`);
        root.style.setProperty('--brand-a25', `rgba(${rgb}, .25)`);
        root.style.setProperty('--brand-a40', `rgba(${rgb}, .40)`);
        // Opacity + scale applied to the panel itself
        root.style.setProperty('--ui-opacity', state.opacity);
        root.style.setProperty('--ui-scale', state.scale);
    }

    // ── Modal wiring (run after DOMContentLoaded since elements exist statically) ──
    const overlay = () => $('#settings-modal');

    // Toggle the `.active` ring within one swatch group.
    function markActive(groupSel, activeEl) {
        $$(`${groupSel} .swatch`).forEach(s => s.classList.toggle('active', s === activeEl));
    }
    // Sync a swatch group to the current value. If no preset matches,
    // the custom (eyedropper) swatch gets the active ring instead.
    function syncSwatch(groupSel, attr, value, customSel, customInputSel) {
        let matched = false;
        $$(`${groupSel} .swatch`).forEach(s => {
            if (s.classList.contains('swatch-custom')) return;
            const on = (s.dataset[attr] || '').toLowerCase() === (value || '').toLowerCase();
            if (on) matched = true;
            s.classList.toggle('active', on);
        });
        const custom = $(customSel);
        if (custom) custom.classList.toggle('active', !matched);
        const ci = $(customInputSel);
        if (ci) ci.value = value;
    }

    function open() {
        const el = overlay(); if (!el) return;
        el.hidden = false;
        // sync controls to state
        syncSwatch('#settings-colors', 'color', state.brand, '#brand-custom', '#brand-custom-input');
        syncSwatch('#settings-bg',     'bg',    state.bg,    '#bg-custom',    '#bg-custom-input');
        const op = $('#settings-opacity'); if (op) op.value = state.opacity;
        const sc = $('#settings-scale');   if (sc) sc.value = state.scale;
        const opV = $('#settings-opacity-val'); if (opV) opV.textContent = Math.round(state.opacity * 100) + '%';
        const scV = $('#settings-scale-val');   if (scV) scV.textContent = Math.round(state.scale * 100) + '%';
    }
    function close() {
        const el = overlay(); if (el) el.hidden = true;
    }

    // Initialise event handlers — these elements exist in markup
    document.addEventListener('click', (ev) => {
        if (ev.target.closest('#panel-settings-btn'))   { open(); return; }
        if (ev.target.closest('#settings-close-btn'))   { close(); return; }
        // Preset swatch click (custom/eyedropper swatches are handled
        // by their native colour input via the 'input' event below).
        const sw = ev.target.closest('.swatch');
        if (sw && !sw.classList.contains('swatch-custom')) {
            const grp = sw.closest('.color-swatches');
            if (grp && grp.id === 'settings-bg') {
                state.bg = sw.dataset.bg;
                markActive('#settings-bg', sw);
                const ci = $('#bg-custom-input'); if (ci) ci.value = state.bg;
            } else {
                state.brand = sw.dataset.color;
                markActive('#settings-colors', sw);
                const ci = $('#brand-custom-input'); if (ci) ci.value = state.brand;
            }
            apply(); save();
            post('play_sound', { alias: 'click' });
        }
        if (ev.target.closest('#settings-reset')) {
            state = { ...defaults };
            apply(); save(); open();   // re-open to sync controls
        }
        if (ev.target.closest('#settings-modal') &&
            !ev.target.closest('.settings-card')) {
            close();
        }
    });
    document.addEventListener('input', (ev) => {
        if (ev.target.id === 'settings-opacity') {
            state.opacity = parseFloat(ev.target.value);
            $('#settings-opacity-val').textContent = Math.round(state.opacity * 100) + '%';
            apply(); save();
        }
        if (ev.target.id === 'settings-scale') {
            state.scale = parseFloat(ev.target.value);
            $('#settings-scale-val').textContent = Math.round(state.scale * 100) + '%';
            apply(); save();
        }
        // Custom colour pickers (brand + background)
        if (ev.target.id === 'brand-custom-input') {
            state.brand = ev.target.value;
            markActive('#settings-colors', $('#brand-custom'));
            apply(); save();
        }
        if (ev.target.id === 'bg-custom-input') {
            state.bg = ev.target.value;
            markActive('#settings-bg', $('#bg-custom'));
            apply(); save();
        }
    });

    // Adopt server-config theme defaults (Config.theme) for any colour
    // the player hasn't personally chosen, then re-assert the full
    // (user) theme so nothing else can stomp it on panel open.
    function applyServerTheme(theme) {
        if (theme) {
            if (theme.brand && !userKeys.has('brand')) state.brand = theme.brand;
            if (theme.bg    && !userKeys.has('bg'))    state.bg    = theme.bg;
        }
        apply();
    }

    load();
    return { open, close, applyServerTheme, get state() { return state } };
})();

// ═══════════════════════════════════════════════════════════
// NOTIFY FALLBACK
// ═══════════════════════════════════════════════════════════
const Notify = (() => {
    const root = $('#notify-container');
    const ICON = { info: 'fa-circle-info', success: 'fa-circle-check', warning: 'fa-triangle-exclamation', error: 'fa-circle-xmark' };
    return ({ title = 'Fishing', message = '', type = 'info', duration = 4000 }) => {
        const el = document.createElement('div');
        el.className = `notify-card ${type}`;
        el.innerHTML = `
            <div class="notify-header">
                <i class="fa-solid ${ICON[type] || ICON.info} notify-icon"></i>
                <span>${title}</span>
            </div>
            <div class="notify-body">${message}</div>
            <div class="notify-bar"><i></i></div>`;
        root.appendChild(el);
        const bar = el.querySelector('.notify-bar > i');
        bar.animate([{ transform: 'scaleX(1)' }, { transform: 'scaleX(0)' }],
            { duration, easing: 'linear' });
        setTimeout(() => el.remove(), duration);
    };
})();

// ═══════════════════════════════════════════════════════════
// WORLD 3D ICON
// ═══════════════════════════════════════════════════════════
const WorldIcon = (() => {
    const el       = $('#world-icon');
    const icon     = $('#world-icon-i');
    const lbl      = $('#world-icon-label');
    const key      = $('#world-icon-key');
    const actions  = $('#world-icon-actions');
    const ICON_FA  = {
        fish:    'fa-fish',
        boat:    'fa-anchor',
        money:   'fa-sack-dollar',
        cart:    'fa-shop',
        building:'fa-building-columns',
        hand:    'fa-hand',
    };
    let hideTimer;
    return {
        show({ x, y, label, icon: ic = 'fish', actions: acts, key: k = 'E' }) {
            clearTimeout(hideTimer);
            el.hidden = false;
            el.style.left = `${x * window.innerWidth}px`;
            el.style.top  = `${y * window.innerHeight}px`;
            el.classList.add('show');
            if (lbl) lbl.textContent = label || '';
            if (key) key.textContent = k;
            if (icon) icon.className = `fa-solid ${ICON_FA[ic] || 'fa-fish'}`;
            // Multi-action support
            if (Array.isArray(acts) && acts.length) {
                actions.hidden = false;
                actions.innerHTML = acts.map((a, i) => `
                    <div class="wa">
                        <span class="wa-k">${a.key || (i+1)}</span>
                        <i class="fa-solid ${ICON_FA[a.icon] || 'fa-fish'}"></i>
                        <span>${a.label || 'Action'}</span>
                    </div>`).join('');
            } else {
                actions.hidden = true;
                actions.innerHTML = '';
            }
        },
        hide() {
            el.classList.remove('show');
            clearTimeout(hideTimer);
            hideTimer = setTimeout(() => { el.hidden = true }, 220);
        },
    };
})();

// ═══════════════════════════════════════════════════════════
// BITE ALERT — flashes when the fish strikes (before minigame)
// ═══════════════════════════════════════════════════════════
const BiteAlert = (() => {
    const el      = $('#bite-alert');
    const titleEl = $('#bite-alert-title');
    const subEl   = $('#bite-alert-sub');
    let timer;
    function show(payload = {}) {
        if (!el) return;
        if (payload.title && titleEl) titleEl.textContent = payload.title;
        if (payload.sub   && subEl)   subEl.textContent   = payload.sub;
        el.hidden = false;
        // Restart the entrance animation on every strike.
        const card = el.querySelector('.bite-alert-card');
        if (card) { card.style.animation = 'none'; void card.offsetWidth; card.style.animation = ''; }
        clearTimeout(timer);
        timer = setTimeout(hide, payload.duration || 1200);
    }
    function hide() {
        clearTimeout(timer);
        if (el) el.hidden = true;
    }
    return { show, hide };
})();

// ═══════════════════════════════════════════════════════════
// CATCH MODAL — Keep / Release
// ═══════════════════════════════════════════════════════════
const CatchModal = (() => {
    const el       = $('#catch-modal');
    const strip    = $('#catch-rarity-strip');
    const rarity   = $('#catch-rarity');
    const name     = $('#catch-name');
    const desc     = $('#catch-desc');
    const cnt      = $('#catch-stat-count');
    const chance   = $('#catch-stat-chance');
    const xpEl     = $('#catch-stat-xp');
    const wWrap    = $('#catch-stat-weight-wrap');
    const wEl      = $('#catch-stat-weight');
    const recEl    = $('#catch-record');
    const arcFg    = $('#catch-arc-fg');
    const fishIc   = $('#catch-fish-i');
    const fishWrap = $('.catch-fish');
    const keepBtn  = $('#catch-keep');
    const relBtn   = $('#catch-release');
    const sparkles = $('#catch-sparkles');

    let currentToken = null;
    let timer;

    // Rarity-scaled FX: tier classes + a sparkle burst for big catches.
    function applyTier(rarityKey) {
        const tier = String(rarityKey || 'common').toLowerCase();
        el.classList.remove('tier-high', 'tier-mythic');
        const big = tier === 'legendary' || tier === 'mythic';
        if (big) el.classList.add('tier-high');
        if (tier === 'mythic') el.classList.add('tier-mythic');

        if (!sparkles) return;
        if (big) {
            const n = tier === 'mythic' ? 14 : 9;
            let html = '';
            for (let i = 0; i < n; i++) {
                const ang = (i / n) * Math.PI * 2;
                const rad = 36 + (i % 3) * 10;
                const x = (50 + Math.cos(ang) * rad).toFixed(1);
                const y = (50 + Math.sin(ang) * rad).toFixed(1);
                const delay = (i * 0.13).toFixed(2);
                html += `<span class="spark" style="left:${x}%;top:${y}%;animation-delay:${delay}s"></span>`;
            }
            sparkles.innerHTML = html;
        } else {
            sparkles.innerHTML = '';
        }
    }

    function onKey(e) {
        if (!currentToken) return;
        if (e.code === 'KeyK' || e.code === 'Enter')  commit('keep');
        if (e.code === 'KeyR' || e.code === 'Escape') commit('release');
    }
    function commit(action) {
        if (!currentToken) return;
        post('catch_resolve', { token: currentToken, action });
        close();
    }
    function close() {
        clearTimeout(timer);
        el.hidden = true;
        currentToken = null;
        el.classList.remove('tier-high', 'tier-mythic');
        if (sparkles) sparkles.innerHTML = '';
        document.removeEventListener('keydown', onKey);
    }

    keepBtn.addEventListener('click', () => commit('keep'));
    relBtn .addEventListener('click', () => commit('release'));

    function open(payload) {
        currentToken = payload.token || ('t_' + Date.now());
        const color = payload.color || '#BEFF40';
        if (payload.imgBase) STATE.imgBase = payload.imgBase;

        rarity.textContent = payload.rarity || 'Common';
        name.textContent   = payload.label  || 'Catch';
        if (desc) desc.textContent = payload.desc ||
            'Congratulations! You caught a fish. Will something even bigger come your way next time?';

        cnt.textContent    = `${payload.totalOfKind != null ? payload.totalOfKind : 1}×`;
        chance.textContent = `${Math.round((payload.chance || 0.35) * 100)}%`;
        if (xpEl) xpEl.textContent = payload.xp != null ? `+${payload.xp}` : '+0';

        // Weight + personal-best record (fish only — junk has no weight).
        if (wWrap && wEl) {
            if (payload.weightStr) { wEl.textContent = payload.weightStr; wWrap.hidden = false; }
            else wWrap.hidden = true;
        }
        if (recEl) recEl.hidden = !payload.isRecord;

        // Rarity strip + accent var on the card.
        if (strip) strip.style.background = color;
        el.style.setProperty('--_c', color);

        // Progress arc (0..1) on the orb.
        if (arcFg) {
            const circumference = 2 * Math.PI * 54;
            const offset = circumference - circumference * (payload.arcFill != null ? payload.arcFill : 0.4);
            arcFg.style.strokeDasharray  = `${circumference}`;
            arcFg.style.strokeDashoffset = `${offset}`;
            arcFg.style.stroke = color;
        }

        // Fish artwork: real item image with the FA icon as a fallback.
        if (fishWrap && fishIc) {
            fishWrap.style.color = color;
            const existingImg = fishWrap.querySelector('img');
            if (existingImg) existingImg.remove();
            if (payload.item) {
                const im = document.createElement('img');
                im.src = imgUrl(payload.item);
                im.alt = '';
                im.onerror = () => { im.style.display = 'none'; fishIc.style.display = ''; };
                im.onload  = () => { fishIc.style.display = 'none'; };
                fishWrap.appendChild(im);
            } else {
                fishIc.style.display = '';
            }
            fishIc.className = `fa-solid fa-${payload.icon || 'fish'}`;
        }

        // Junk → "Discard" instead of "Release".
        relBtn.textContent = payload.junk ? 'Discard' : 'Release';

        applyTier(payload.rarityKey || payload.rarity);
        el.hidden = false;
        document.addEventListener('keydown', onKey);

        // Auto-keep after 12s so an AFK player doesn't lose the catch.
        // Skipped for the showcase preview — it holds until dismissed.
        clearTimeout(timer);
        if (!payload.preview) timer = setTimeout(() => commit('keep'), 12000);
    }

    return { open, close };
})();

// ═══════════════════════════════════════════════════════════
// MINIGAME — Q / E to push the cursor, SPACE to catch
//
// The fish drifts left/right on the track. A small "catch zone"
// follows the fish (and is slightly larger). The player's cursor
// moves with discrete Q / E key taps (and accelerates when held).
// Every frame the cursor is inside the catch zone fills the meter;
// outside, the meter drains. SPACE attempts a catch — succeeds if
// the meter is past `catchThreshold` AND the cursor is in the zone
// at that instant. Time-out = miss.
// ═══════════════════════════════════════════════════════════
const Minigame = (() => {
    const overlay = $('#minigame');
    const trackEl = $('#mg-fish').parentElement;
    const fishEl  = $('#mg-fish');
    const zoneEl  = $('#mg-zone');
    const meterEl = $('#mg-meter');
    const frameEl = $('.mg-frame');

    let raf = null;
    let state = null;
    // Active key holds (rapid-fire if user holds Q or E down)
    const held = { q: false, e: false };

    // Track usable range (excludes the 50px reserved for each key
    // button on the sides).
    const KEY_PAD = 8;        // % of width reserved each side
    const TRACK_MIN = KEY_PAD;
    const TRACK_MAX = 100 - KEY_PAD;

    // Game-side input arrives via the `minigame_key` NUI message
    // (Lua reads native controls because SetNuiFocusKeepInput keeps
    // keys flowing to the game, not the browser). Q and E send
    // {phase:'down'} on press and {phase:'up'} on release so we can
    // do CONTINUOUS movement while held — tap-only nudges weren't
    // strong enough to catch up with the moving fish.
    function handleKey(key, phase) {
        if (!state) return;
        if (key === 'q') {
            if (phase === 'down') { held.q = true; nudge(-1); }
            if (phase === 'up')     held.q = false;
        }
        if (key === 'e') {
            if (phase === 'down') { held.e = true; nudge( 1); }
            if (phase === 'up')     held.e = false;
        }
        if (key === 'space')  { attemptCatch(); }
        if (key === 'escape') { finish(false); }
    }
    function onKeyDown(e) {
        if (!state) return;
        if (e.code === 'KeyQ')   { e.preventDefault(); if (!held.q) handleKey('q', 'down'); }
        if (e.code === 'KeyE')   { e.preventDefault(); if (!held.e) handleKey('e', 'down'); }
        if (e.code === 'Space')  { e.preventDefault(); handleKey('space'); }
        if (e.code === 'Escape') { handleKey('escape'); }
    }
    function onKeyUp(e) {
        if (!state) return;
        if (e.code === 'KeyQ') handleKey('q', 'up');
        if (e.code === 'KeyE') handleKey('e', 'up');
    }
    function nudge(dir) {
        // Small kick on the initial press so a quick tap moves the
        // zone a couple of percent (not a big leap).
        state.zoneVel += dir * 0.8;
    }

    function loop() {
        if (!state) return;
        const now = performance.now();
        const dt  = Math.min(50, now - state.last);
        state.last = now;
        state.elapsed += dt;

        // ─── Player controls the ZONE (the highlighted area) ───
        // Q/E push the zone left/right. The player must keep the
        // zone aligned with the autonomously-moving fish.
        if (held.q) state.zoneVel -= 0.30;
        if (held.e) state.zoneVel += 0.30;
        state.zoneVel *= 0.86;
        state.zonePos += state.zoneVel * (dt / 16);

        const halfZone = state.zoneWidth / 2;
        const zoneMin  = TRACK_MIN + halfZone;
        const zoneMax  = TRACK_MAX - halfZone;
        if (state.zonePos < zoneMin) { state.zonePos = zoneMin; state.zoneVel *= -0.3; }
        if (state.zonePos > zoneMax) { state.zonePos = zoneMax; state.zoneVel *= -0.3; }

        const zoneLeft = state.zonePos - halfZone;
        zoneEl.style.left  = `${zoneLeft}%`;
        zoneEl.style.width = `${state.zoneWidth}%`;

        // ─── Fish swims autonomously end-to-end ───
        // Smooth sine sweep so it reaches both ends of the bar.
        const t = state.elapsed / 1000;
        const range = (TRACK_MAX - TRACK_MIN) * 0.46;
        const prevFishPos = state.fishPos;
        state.fishPos = ((TRACK_MIN + TRACK_MAX) / 2)
            + Math.sin(t * state.fishSpeed + state.fishPhase) * range;
        fishEl.style.left = `${state.fishPos}%`;

        // Flip the fish horizontally when it reverses direction.
        const movingRight = state.fishPos > prevFishPos;
        if (movingRight !== state.fishMovingRight) {
            state.fishMovingRight = movingRight;
            fishEl.classList.toggle('flipped', !movingRight);
        }

        // ─── Meter logic — fills while fish is INSIDE the zone ───
        const fishInZone = state.fishPos >= zoneLeft && state.fishPos <= zoneLeft + state.zoneWidth;
        if (fishInZone) {
            state.meter = Math.min(1, state.meter + dt * state.fillRate);
            zoneEl.classList.add('hot');
        } else {
            state.meter = Math.max(0, state.meter - dt * state.drainRate);
            zoneEl.classList.remove('hot');
        }
        meterEl.style.width = `${state.meter * 100}%`;
        // Tension glow on the frame scales with the meter (the "fight").
        if (frameEl) frameEl.style.setProperty('--tension', state.meter.toFixed(3));

        // Player must press SPACE to lock in the catch.
        if (state.elapsed >= state.durationMs) { finish(false); return; }
        raf = requestAnimationFrame(loop);
    }

    function attemptCatch() {
        if (!state) return;
        // Success if the meter has filled past the threshold. The
        // player builds up meter by keeping the zone over the fish.
        if (state.meter >= state.catchThreshold) finish(true);
    }

    function finish(success) {
        if (!state) return;
        if (raf) cancelAnimationFrame(raf);
        const accuracy = state.meter;
        const perfect  = accuracy >= state.perfectThreshold;
        overlay.hidden = true;
        state = null;
        held.q = held.e = false;
        document.removeEventListener('keydown', onKeyDown);
        document.removeEventListener('keyup', onKeyUp);
        post('minigame_done', { success, accuracy, perfect });
    }

    function start(payload) {
        if (state) return;
        // Zone (controlled by player) spawns on the LEFT, fish
        // spawns on the RIGHT — forces the player to actively chase
        // the fish with Q/E to bring the zone over it.
        const zoneStart = TRACK_MIN + (TRACK_MAX - TRACK_MIN) * 0.15;
        const fishStart = TRACK_MIN + (TRACK_MAX - TRACK_MIN) * 0.85;
        state = {
            elapsed: 0, last: performance.now(),
            zonePos: zoneStart, zoneVel: 0,
            fishPos: fishStart,
            fishPhase: Math.PI * 0.5,    // start with sin ≈ +1.0 = far right
            fishSpeed: payload.fishSpeed || 0.85,
            fishMovingRight: false,      // initial sweep is LEFT-ward
            zoneWidth: payload.zoneWidth || 24,
            meter: 0,
            // Meter fill/drain are config-driven (per-rarity), so a
            // Mythic genuinely fights back vs a Common.
            fillRate:         payload.fillRate         || 0.0020,
            drainRate:        payload.drainRate        || 0.0004,
            catchThreshold:   payload.catchThreshold   || 0.45,
            perfectThreshold: payload.perfectThreshold || 0.90,
            durationMs:       payload.durationMs       || 16000,
        };
        meterEl.style.width = '0%';
        zoneEl.classList.remove('hot');
        fishEl.classList.add('flipped');   // fish initially swims left
        overlay.hidden = false;
        document.addEventListener('keydown', onKeyDown);
        document.addEventListener('keyup', onKeyUp);
        raf = requestAnimationFrame(loop);
    }

    function forceClose() {
        if (raf) cancelAnimationFrame(raf);
        state = null;
        held.q = held.e = false;
        overlay.hidden = true;
        document.removeEventListener('keydown', onKeyDown);
        document.removeEventListener('keyup', onKeyUp);
    }

    return { start, forceClose, key: (k, p) => handleKey(k, p) };
})();

// ═══════════════════════════════════════════════════════════
// PANEL
// ═══════════════════════════════════════════════════════════
const Panel = (() => {
    const overlay = $('#panel');
    const closeBtn = $('#panel-close-btn');
    let openNow = false;
    let tourneyTimer = null;   // weekly-tournament countdown ticker

    function open(payload) {
        STATE.rods     = payload.rods || [];
        STATE.fish     = payload.fish || [];
        STATE.junk     = payload.junk || [];
        STATE.boats    = payload.boats || [];
        STATE.rarities = payload.rarities || {};
        STATE.zones    = payload.zones || {};
        STATE.upgrades = payload.upgrades || [];
        STATE.conditions = payload.conditions || STATE.conditions;
        STATE.baitCost = payload.baitCost || 12;
        STATE.features = payload.features || {};
        STATE.locale   = payload.locale   || {};

        // Hide nav buttons + tab panes for disabled features
        const featureMap = {
            overview: 'enableOverview', guide: 'enableGuide',
            shop: 'enableShop', sell: 'enableSell', boats: 'enableBoats',
            ranking: 'enableRanking', upgrades: 'enableUpgrades',
        };
        Object.entries(featureMap).forEach(([tab, key]) => {
            const enabled = STATE.features[key] !== false;
            $$(`.nav-btn[data-tab="${tab}"]`).forEach(b => b.hidden = !enabled);
            $$(`.tab[data-pane="${tab}"]`).forEach(t => { if (!enabled) t.classList.remove('active'); });
        });
        const settingsBtn = $('#panel-settings-btn');
        if (settingsBtn) settingsBtn.hidden = STATE.features.enableSettings === false;
        STATE.imgBase  = payload.imgBase || STATE.imgBase;
        STATE.snap     = payload.snapshot || {};
        // Server-config theme (Config.theme) acts as the DEFAULT brand
        // + background; the player's own Settings choice always wins
        // and is re-asserted here so nothing stomps it on open.
        Settings.applyServerTheme(payload.theme);
        renderAll();
        overlay.hidden = false;
        openNow = true;
        document.addEventListener('keydown', onKey);
    }

    function close() {
        if (tourneyTimer) { clearInterval(tourneyTimer); tourneyTimer = null; }
        // Idempotent: a stray 'panel_close' message from Lua (e.g.
        // during onResourceStop) must not cause a second post back
        // and re-enter the close flow.
        if (!openNow) { overlay.hidden = true; return; }
        overlay.hidden = true;
        openNow = false;
        document.removeEventListener('keydown', onKey);
        post('panel_close');
    }

    function onKey(e) { if (e.code === 'Escape') close(); }
    closeBtn.addEventListener('click', close);

    // Tabs
    $$('.nav-btn').forEach(btn => btn.addEventListener('click', () => switchTab(btn.dataset.tab)));
    function switchTab(name) {
        $$('.nav-btn').forEach(b => b.classList.toggle('active', b.dataset.tab === name));
        $$('.tab').forEach(t => t.classList.toggle('active', t.dataset.pane === name));
        const titles = {
            overview: 'Overview', guide: 'Fishing Guide', shop: 'Rod Shop',
            sell: 'Sell Fish', boats: 'Boat Rental', ranking: 'Ranking',
            upgrades: 'Upgrades',
        };
        $('#page-title').textContent = titles[name] || 'Fishing';
        post('play_sound', { alias: 'click' });
    }

    function refresh(snap) {
        STATE.snap = snap || STATE.snap;
        renderAll();
    }

    function renderAll() {
        renderProfile();
        renderOverview();
        renderConditions();
        renderGuide();
        renderShop();
        renderSell();
        renderBoats();
        renderRanking();
        renderTournament();
        renderUpgrades();
    }

    // ── Sidebar profile (name + avatar + cash + level) ──
    function renderProfile() {
        const s = STATE.snap || {};
        const name = (s.name && String(s.name).trim()) || 'Angler';
        const set = (sel, val) => { const el = $(sel); if (el) el.textContent = val; };
        set('#sp-name', name);
        if (s.title) set('#sp-title', s.title);
        animateNumber($('#sp-cash'), s.money, fmtCash);
        set('#sp-fishlevel', s.level || 0);
        set('#sp-level-badge', s.level || 0);

        // XP progress toward the next level (mirrors the hero bar).
        const xpCur  = Math.max(0, (s.xp || 0) - (s.prevLvlXp || 0));
        const xpNeed = Math.max(1, (s.nextLvlXp || 0) - (s.prevLvlXp || 0));
        set('#sp-xp-cur', xpCur.toLocaleString());
        set('#sp-xp-need', xpNeed.toLocaleString());
        set('#sp-xp-next', 'Lv ' + ((s.level || 0) + 1));
        const xpFill = $('#sp-xp-fill');
        if (xpFill) xpFill.style.width = Math.min(100, (xpCur / xpNeed) * 100) + '%';

        // Initials disc (first letters of up to two name parts).
        const initials = name.split(/\s+/).map(w => w[0] || '')
            .slice(0, 2).join('').toUpperCase() || 'A';
        const iniEl = $('#sp-initials');
        if (iniEl) iniEl.textContent = initials;

        // Optional RP character photo — falls back to the disc on
        // any load failure (or when no URL was provided).
        const img = $('#sp-avatar-img');
        const av  = $('#sp-avatar');
        if (img) {
            if (s.avatar) {
                img.onerror = () => { img.hidden = true; if (iniEl) iniEl.hidden = false; if (av) av.classList.remove('skeleton'); };
                img.onload  = () => { img.hidden = false; if (iniEl) iniEl.hidden = true; if (av) av.classList.remove('skeleton'); };
                if (img.getAttribute('src') !== s.avatar) { if (av) av.classList.add('skeleton'); img.src = s.avatar; }
            } else {
                img.hidden = true; img.removeAttribute('src');
                if (iniEl) iniEl.hidden = false;
                if (av) av.classList.remove('skeleton');
            }
        }
    }

    // ── Upgrades ──
    function fmtUpgradeValue(value, display) {
        const pct = Math.round((value || 0) * 100);
        switch (display) {
            case 'percent':    return `+${pct}%`;
            case 'reduction':  return `−${pct}%`;
            case 'multiplier': return `×${(value || 0).toFixed(2)}`;
            default:           return `${value}`;
        }
    }
    function renderUpgrades() {
        const s = STATE.snap || {};
        const available = (s.xpAvailable != null) ? s.xpAvailable : Math.max(0, (s.xp || 0) - (s.xpSpent || 0));
        const xpEl = $('#upgrades-xp');
        if (xpEl) xpEl.textContent = available.toLocaleString();

        const owned = s.upgrades || {};
        const grid = $('#upgrades-grid');
        if (!grid) return;
        grid.innerHTML = (STATE.upgrades || []).map(u => {
            const level    = owned[u.id] || 0;
            const maxed    = level >= u.maxLevel;
            const nextCost = maxed ? null : u.costs[level];       // costs[0] = level 1, etc.
            const nextVal  = maxed ? null : u.values[level];
            const curVal   = level > 0 ? u.values[level - 1] : null;
            const canBuy   = !maxed && available >= nextCost;
            const dots = Array.from({ length: u.maxLevel }, (_, i) =>
                `<span class="ulvl ${i < level ? 'on' : ''}"></span>`).join('');
            return `
                <div class="upgrade-card ${maxed ? 'maxed' : ''}">
                    <div class="upgrade-icon"><i class="fa-solid ${u.icon || 'fa-bolt'}"></i></div>
                    <div class="upgrade-info">
                        <div class="upgrade-name">${u.label} <span class="upgrade-lvl">Lv ${level}/${u.maxLevel}</span></div>
                        <div class="upgrade-desc">${u.description || ''}</div>
                        <div class="upgrade-levels">${dots}</div>
                        ${curVal != null
                            ? `<div class="upgrade-current">Currently <b>${fmtUpgradeValue(curVal, u.display)}</b></div>`
                            : ''}
                    </div>
                    <div class="upgrade-action">
                        ${maxed
                            ? `<button class="btn btn-ghost btn-block" disabled><i class="fa-solid fa-check"></i> Maxed</button>`
                            : `
                                <div class="upgrade-next">
                                    <span>Next</span>
                                    <strong>${fmtUpgradeValue(nextVal, u.display)}</strong>
                                </div>
                                <button class="btn btn-primary btn-block" data-buy-upgrade="${u.id}" ${canBuy ? '' : 'disabled'}>
                                    ${nextCost.toLocaleString()} XP
                                </button>`}
                    </div>
                </div>`;
        }).join('');
    }
    // Buy upgrade (event delegation — the grid re-renders on refresh)
    document.addEventListener('click', (ev) => {
        const btn = ev.target.closest('[data-buy-upgrade]');
        if (!btn || btn.disabled) return;
        post('buy_upgrade', { id: btn.dataset.buyUpgrade });
        post('play_sound', { alias: 'purchase' });
    });

    // ── Conditions (live zone) ──
    function renderConditions() {
        const c = STATE.conditions; if (!c) return;
        const z = STATE.zones[c.zone] || {};
        $('#cond-zone-lbl').textContent  = z.label || c.zone || '—';
        const dEl = $('#cond-depth-lbl');
        if (dEl) dEl.textContent = `${(c.depth || 0).toFixed(1)} m`;

        $('#cond-zone').style.setProperty('--_c',
            c.zone === 'deep' ? 'var(--brand-400)' : 'var(--green)');
        $('#cond-depth').style.setProperty('--_c', 'var(--text-2)');

        const zIcon = $('#cond-zone').querySelector('i');
        if (zIcon) zIcon.className = `fa-solid fa-${z.icon || 'water'}`;

        $('#cond-hint').textContent = c.zone === 'deep'
            ? 'Deep-sea waters: rare and legendary species are far more likely. Watch your line tension.'
            : 'Coastal waters: smaller, more common species. Take a boat into open water for the big game.';
    }

    // ── Overview ──
    function renderOverview() {
        const s = STATE.snap || {};
        $('#hero-level').textContent = s.level || 0;
        animateNumber($('#hero-total'), s.totalCatch || 0);
        const best = s.bestRarity ? (STATE.rarities[s.bestRarity] || {}).label || '—' : '—';
        $('#hero-best').textContent = best;
        $('#hero-bait').textContent = s.bait || 0;
        // Overview wallet banner (moved out of the hero strip)
        animateNumber($('#ow-cash'), s.money, fmt);
        const owBait = $('#ow-bait'); if (owBait) owBait.textContent = (s.bait || 0).toLocaleString();
        const xpCur = Math.max(0, (s.xp || 0) - (s.prevLvlXp || 0));
        const xpNeed = Math.max(1, (s.nextLvlXp || 0) - (s.prevLvlXp || 0));
        $('#xp-cur').textContent = xpCur;
        $('#xp-need').textContent = xpNeed;
        $('#xp-fill').style.width = `${Math.min(100, (xpCur / xpNeed) * 100)}%`;

        // Rod list — show current owned + active highlight
        const rodList = $('#rod-list');
        const owned = STATE.rods.filter(r => s.rodInv && s.rodInv[r.id]);
        const activeRod = owned.length ? owned.reduce((a, b) =>
            (b.requiredLevel > a.requiredLevel) ? b : a) : null;
        rodList.innerHTML = STATE.rods.map(rod => {
            const isOwned  = s.rodInv && s.rodInv[rod.id];
            const isActive = activeRod && activeRod.id === rod.id;
            const cls = isActive ? 'active' : (isOwned ? 'owned' : 'locked');
            const badge = isActive ? `<span class="rod-badge">Equipped</span>` :
                          (isOwned ? `<span class="rod-badge" style="background:var(--surface-4)">Owned</span>` :
                          `<span class="rod-badge" style="background:var(--surface-4)">Lv ${rod.requiredLevel}</span>`);
            return `
                <div class="rod-row ${cls}">
                    <div class="rod-thumb">${imgTag(rod.id)}<i class="fa-solid fa-fishing-rod"></i></div>
                    <div class="rod-meta">
                        <strong>${rod.label}</strong>
                        <small>Up to ${(rod.maxRarity || 'rare').toUpperCase()} catches</small>
                    </div>
                    ${badge}
                </div>`;
        }).join('');

        // ── Capability strip — visualise rarities the equipped rod
        // can pull. Owned-but-not-equipped rods are unaffected; we
        // show capability of the currently active rod (= the best
        // one the player owns; same logic as findBestOwnedRod
        // server-side).
        const order = ['common', 'uncommon', 'rare', 'epic', 'legendary', 'mythic'];
        const capMax = activeRod ? order.indexOf(activeRod.maxRarity || 'rare') : -1;
        const capSub = $('#capability-sub');
        if (capSub) {
            capSub.textContent = activeRod
                ? `${activeRod.label} · pulls up to ${(activeRod.maxRarity || 'rare').toUpperCase()}`
                : 'No rod equipped';
        }
        const capEl = $('#capability-bars');
        if (capEl) {
            capEl.innerHTML = order.map((r, idx) => {
                const isOn = idx <= capMax;
                const info = STATE.rarities[r] || {};
                const colour = info.color || 'var(--brand-500)';
                return `
                    <span class="cap ${isOn ? 'on' : 'off'}" style="--_c:${colour}">
                        <span class="cap-dot"></span>
                        <span class="cap-lbl">${(info.label || r).toUpperCase()}</span>
                    </span>`;
            }).join('');
        }
    }

    // ── Guide ──
    // The guide unifies fish + junk under one filterable grid.
    // Two filters: Type (all/coast/deep/junk) and Rarity. They're
    // independent and intersect. Show/hide instead of re-render so
    // the chip handlers stay attached and selection is preserved.
    const filters = { type: 'all', rarity: 'all' };

    function fishCardHTML(entry, isJunk) {
        if (isJunk) {
            const sell = entry.money ? `<b>${fmt(entry.money.min)}-${fmt(entry.money.max)}</b> · cash`
                       : entry.weapon ? `<b>Weapon</b>`
                       : `<b>${fmt(entry.sell)}</b> · sells`;
            return `
                <div class="guide-card" style="--_c:var(--rarity-junk)"
                     data-type="junk" data-rarity="junk">
                    <div class="gthumb">${imgTag(entry.item)}</div>
                    <div class="gtext">
                        <div class="grarity">JUNK</div>
                        <div class="gname">${entry.label}</div>
                        <div class="gprice">${sell}</div>
                    </div>
                </div>`;
        }
        const r = STATE.rarities[entry.rarity] || {};
        const z = entry.zone || 'coast';
        const zoneLabel = z === 'deep' ? 'Deep Sea' : (z === 'any' ? 'Any' : 'Coast');
        // For Type filter purposes, treat 'any' as matching both.
        const typeTag = z === 'deep' ? 'deep' : (z === 'any' ? 'coast deep' : 'coast');

        // Collection (Pokédex) state — caught species show a ✓ (+ their
        // personal-best weight when weights are on); undiscovered ones
        // are silhouetted. Gated by Config.features.enableCollection.
        const records      = (STATE.snap && STATE.snap.records) || {};
        const collectionOn = !!(STATE.snap && STATE.snap.collectionEnabled);
        const weightOn     = !!(STATE.snap && STATE.snap.weightEnabled !== false);
        const unit         = (STATE.snap && STATE.snap.weightUnit) || 'kg';
        let collClass = '', nameOut = entry.label, priceOut = `<b>${fmt(entry.sell)}</b> · sells`;
        if (collectionOn) {
            const best = records[entry.item];
            if (best != null) {
                collClass = ' caught';
                priceOut  = (weightOn && best > 0)
                    ? `<b>${fmt(entry.sell)}</b> · best ${Number(best).toFixed(1)} ${unit}`
                    : `<b>${fmt(entry.sell)}</b> · sells`;
            } else {
                collClass = ' locked';
                nameOut   = '???';
                priceOut  = 'Undiscovered';
            }
        }
        return `
            <div class="guide-card${collClass}" style="--_c:${r.color || 'var(--brand-500)'}"
                 data-type="${typeTag}" data-rarity="${entry.rarity}">
                <span class="gzone ${z}">${zoneLabel}</span>
                <div class="gthumb">${imgTag(entry.item)}</div>
                <div class="gtext">
                    <div class="grarity">${(r.label || entry.rarity).toUpperCase()}</div>
                    <div class="gname">${nameOut}</div>
                    <div class="gprice">${priceOut}</div>
                </div>
            </div>`;
    }

    function applyGuideFilters() {
        const grid = $('#guide-grid'); if (!grid) return;
        const cards = $$('.guide-card', grid);
        let shown = 0;
        cards.forEach(c => {
            const ts = (c.dataset.type || '').split(' ');
            const rs = c.dataset.rarity || '';
            const typeOk = filters.type === 'all' || ts.includes(filters.type);
            const rarOk  = filters.rarity === 'all' || rs === filters.rarity;
            const ok = typeOk && rarOk;
            c.hidden = !ok;
            if (ok) shown++;
        });
        const titleEl = $('#guide-title');
        const countEl = $('#guide-count');
        const emptyEl = $('#guide-empty');
        if (titleEl) {
            const T = filters.type === 'junk' ? 'Junk'
                     : filters.type === 'coast' ? 'Coastal Species'
                     : filters.type === 'deep' ? 'Deep-Sea Species'
                     : 'All Species';
            const R = filters.rarity === 'all' ? '' : ` — ${filters.rarity}`;
            titleEl.textContent = T + (R ? R.toUpperCase() : '');
        }
        if (countEl) countEl.textContent = `${shown} ${shown === 1 ? 'entry' : 'entries'}`;
        if (emptyEl) emptyEl.hidden = shown !== 0;
        grid.hidden = shown === 0;
    }

    function renderGuide() {
        const grid = $('#guide-grid'); if (!grid) return;
        const fishHtml = STATE.fish.map(f => fishCardHTML(f, false)).join('');
        const junkHtml = STATE.junk.map(j => fishCardHTML(j, true)).join('');
        grid.innerHTML = fishHtml + junkHtml;

        // Collection (Pokédex) counter — discovered fish species / total.
        const records      = (STATE.snap && STATE.snap.records) || {};
        const collectionOn = !!(STATE.snap && STATE.snap.collectionEnabled);
        const collEl = $('#guide-collection');
        if (collEl) {
            if (collectionOn) {
                const total = STATE.fish.length;
                const got   = STATE.fish.filter(f => records[f.item] != null).length;
                const nEl = $('#guide-collection-n'); if (nEl) nEl.textContent = got;
                const tEl = $('#guide-collection-t'); if (tEl) tEl.textContent = total;
                collEl.hidden = false;
            } else {
                collEl.hidden = true;
            }
        }
        applyGuideFilters();
    }

    // Chip event wiring (delegated)
    document.addEventListener('click', (ev) => {
        const chip = ev.target.closest('.chip'); if (!chip) return;
        const group = chip.closest('.chips'); if (!group) return;
        const which = group.id === 'chips-type' ? 'type' : 'rarity';
        const val   = chip.dataset[which];
        filters[which] = val;
        $$('.chip', group).forEach(c => c.classList.toggle('active', c === chip));
        applyGuideFilters();
        post('play_sound', { alias: 'click' });
    });

    // ── Shop ──
    function renderShop() {
        const s = STATE.snap || {};
        $('#bait-price').textContent = fmt(STATE.baitCost);
        $('#bait-own').textContent = s.bait || 0;
        // Bait artwork — pulls from ox_inventory's web/images.
        const baitImg = $('#bait-thumb img');
        if (baitImg) baitImg.src = imgUrl('fishing_bait');

        $('#shop-grid').innerHTML = STATE.rods.map(rod => {
            const isOwned = s.rodInv && s.rodInv[rod.id];
            const locked  = (s.level || 0) < (rod.requiredLevel || 0);
            const meta = `
                <div class="shop-meta">
                    <div>Max rarity: <b>${(rod.maxRarity || 'rare').toUpperCase()}</b></div>
                    <div>Catch bonus: <b>+${Math.round((rod.catchBonus || 0) * 100)}%</b></div>
                    <div>Required level: <b>${rod.requiredLevel}</b></div>
                </div>`;
            const btn = isOwned ? `<button class="btn btn-ghost btn-block" disabled>Already owned</button>`
                       : locked ? `<button class="btn btn-ghost btn-block" disabled>Locked</button>`
                       : `<button class="btn btn-primary btn-block" data-buy="${rod.id}">Buy for ${fmt(rod.price)}</button>`;
            return `
                <div class="shop-card ${isOwned ? 'owned' : ''}">
                    <div class="shop-top">
                        <div class="shop-head">
                            <div class="shop-name">${rod.label}</div>
                            <div class="shop-price">${fmt(rod.price)}</div>
                        </div>
                        <div class="shop-icon">${imgTag(rod.id, 'shop-img')}<i class="fa-solid fa-fishing-rod"></i></div>
                    </div>
                    ${meta}
                    ${btn}
                </div>`;
        }).join('');
        $$('#shop-grid [data-buy]').forEach(b => b.addEventListener('click', () => {
            post('buy_rod', { id: b.dataset.buy });
            post('play_sound', { alias: 'purchase' });
        }));
    }

    // Bait buy
    $('#bait-buy').addEventListener('click', () => {
        const q = Math.max(1, parseInt($('#bait-qty').value) || 1);
        post('buy_bait', { qty: q });
        post('play_sound', { alias: 'purchase' });
    });
    $$('.qty-btn').forEach(b => b.addEventListener('click', () => {
        const inp = $('#bait-qty');
        const d = parseInt(b.dataset.q);
        inp.value = Math.max(1, Math.min(100, (parseInt(inp.value) || 1) + d));
    }));

    // ── Sell ──
    function renderSell() {
        const s = STATE.snap || {};
        const rows = [];
        for (const f of STATE.fish) {
            const c = (s.fishInv && s.fishInv[f.item]) || 0;
            if (c <= 0) continue;
            const r = STATE.rarities[f.rarity] || {};
            rows.push({ item: f.item, label: f.label, color: r.color, qty: c, sell: f.sell });
        }
        for (const j of STATE.junk) {
            const c = (s.junkInv && s.junkInv[j.item]) || 0;
            if (c <= 0 || !j.sell) continue;
            rows.push({ item: j.item, label: j.label, color: 'var(--rarity-junk)', qty: c, sell: j.sell });
        }
        const list = $('#sell-list');
        if (rows.length === 0) {
            list.classList.add('is-empty');
            list.innerHTML = `
                <div class="empty">
                    <div class="empty-icon"><i class="fa-solid fa-fish"></i></div>
                    <div class="empty-title">Your bucket is empty</div>
                    <div class="empty-sub">Cast a line and come back with something to sell.</div>
                </div>`;
            $('#sell-all').disabled = true;
            return;
        }
        list.classList.remove('is-empty');
        $('#sell-all').disabled = false;
        list.innerHTML = rows.map(r => `
            <div class="sell-row" style="--_c:${r.color}">
                <div class="sell-thumb">${imgTag(r.item)}</div>
                <div class="sell-info">
                    <div class="sell-rarity"></div>
                    <div class="sell-name">${r.label}</div>
                    <div class="sell-qty">${r.qty} in bucket · ${fmt(r.sell)} each</div>
                </div>
                <div class="sell-price">${fmt(r.sell * r.qty)}</div>
                <button class="btn btn-primary" data-sell="${r.item}" data-qty="${r.qty}">
                    <i class="fa-solid fa-sack-dollar"></i> Sell ${r.qty}
                </button>
            </div>`).join('');
        $$('#sell-list [data-sell]').forEach(b => b.addEventListener('click', () => {
            post('sell_one', { item: b.dataset.sell, qty: parseInt(b.dataset.qty) || 1 });
            post('play_sound', { alias: 'cash' });
        }));
    }
    $('#sell-all').addEventListener('click', () => {
        post('sell_all');
        post('play_sound', { alias: 'cash' });
    });

    // ── Boats ──
    function renderBoats() {
        const s = STATE.snap || {};
        $('#boat-grid').innerHTML = STATE.boats.map(b => {
            const locked = b.requiredLevel && (s.level || 0) < b.requiredLevel;
            return `
                <div class="boat-card ${locked ? 'locked' : ''}">
                    <div class="boat-header">
                        <div class="boat-title">
                            <h4 class="boat-name">${b.label}</h4>
                            <span class="boat-sub">${b.requiredLevel ? `Level ${b.requiredLevel}+` : 'Boat'}</span>
                        </div>
                        <span class="boat-price-tag">${fmt(b.price)}</span>
                    </div>
                    <div class="boat-preview skeleton">
                        ${boatImgTag(b.model)}
                        <i class="fa-solid fa-anchor"></i>
                    </div>
                    <button class="btn btn-primary btn-block" data-rent="${b.model}" ${locked ? 'disabled' : ''}>
                        ${locked ? '<i class="fa-solid fa-lock"></i> Locked' : '<i class="fa-solid fa-key"></i> Rent boat'}
                    </button>
                </div>`;
        }).join('');
        $$('#boat-grid [data-rent]').forEach(b => b.addEventListener('click', () => {
            post('rent_boat', { model: b.dataset.rent });
            post('play_sound', { alias: 'purchase' });
        }));
        // Drop the skeleton shimmer once each remote boat webp resolves.
        $$('#boat-grid .boat-preview').forEach(p => {
            const img = p.querySelector('img');
            if (!img) { p.classList.remove('skeleton'); return; }
            const done = () => p.classList.remove('skeleton');
            if (img.complete) done();
            else { img.addEventListener('load', done); img.addEventListener('error', done); }
        });
    }
    $('#recover-boat').addEventListener('click', () => {
        post('recover_boat');
        post('play_sound', { alias: 'click' });
    });

    // ── Ranking ──
    const RARITY_ORDER = ['junk','common','uncommon','rare','epic','legendary','mythic'];
    function renderRanking() {
        const s = STATE.snap || {};

        // Leaderboard — Top 3 (gold/silver/bronze)
        const lb = (s.leaderboard) || [];
        const lbEl = $('#leaderboard');
        if (lbEl) {
            if (lb.length === 0) {
                lbEl.innerHTML = `
                    <div class="empty">
                        <div class="empty-icon"><i class="fa-solid fa-trophy"></i></div>
                        <div class="empty-title">No one on the board yet</div>
                        <div class="empty-sub">Be the first to catch a fish and you'll appear here.</div>
                    </div>`;
            } else {
                const tiers = ['gold','silver','bronze'];
                const trophies = ['fa-crown','fa-medal','fa-award'];
                lbEl.innerHTML = lb.map((p, i) => {
                    const rarity = (STATE.rarities[p.best_rarity] || {});
                    return `
                    <div class="lb-row ${tiers[i] || ''}">
                        <div class="lb-rank"><i class="fa-solid ${trophies[i] || 'fa-hashtag'}"></i><span>${i + 1}</span></div>
                        <div class="lb-info">
                            <div class="lb-name">${p.name || 'Anonymous'}</div>
                            <div class="lb-meta">Level ${p.level || 0} · ${(p.total_catch || 0).toLocaleString()} catches${p.best_rarity ? ` · Best: <b style="color:${rarity.color || '#fff'}">${(rarity.label || p.best_rarity).toUpperCase()}</b>` : ''}</div>
                        </div>
                        <div class="lb-xp">${(p.xp || 0).toLocaleString()}<span>XP</span></div>
                    </div>`;
                }).join('');
            }
        }

        // Your standing — 12 level tiers
        const max = 12;
        const xpForLevel = (L) => Math.floor(Math.pow(L, 1.35) * 250);
        const tiers = [];
        for (let i = 1; i <= max; i++) {
            tiers.push(`
                <div class="rank-tier ${(s.level || 0) >= i ? 'reached' : ''}">
                    <div class="rt-num">${i}</div>
                    <div class="rt-xp">${xpForLevel(i)} XP</div>
                </div>`);
        }
        $('#rank-tiers').innerHTML = tiers.join('');

        // Your Statistics — personal numbers
        const setStat = (id, val) => { const el = $(id); if (el) el.textContent = val; };
        setStat('#stats-catches', (s.totalCatch || 0).toLocaleString());
        const bestEl = $('#stats-best');
        if (bestEl) {
            if (s.bestRarity) {
                const rar = STATE.rarities[s.bestRarity] || {};
                bestEl.textContent = (rar.label || s.bestRarity);
                bestEl.style.color = rar.color || '';
            } else {
                bestEl.textContent = '—';
                bestEl.style.color = '';
            }
        }
        setStat('#stats-xp',    (s.xp || 0).toLocaleString());
        setStat('#stats-level', s.level || 0);

        // Rarity ladder — sorted compact horizontal list
        const rgEl = $('#rarity-grid');
        if (rgEl) {
            rgEl.innerHTML = RARITY_ORDER
                .filter(k => STATE.rarities[k])
                .map(k => {
                    const r = STATE.rarities[k];
                    return `
                        <div class="rarity-pill" style="--_c:${r.color}">
                            <div class="rp-name">${r.label}</div>
                            <div class="rp-xp">+${r.xp} XP</div>
                        </div>`;
                }).join('');
        }
    }

    // ── Weekly tournament ──
    function fmtCountdown(secs) {
        let s = Math.max(0, Math.floor(secs));
        const d = Math.floor(s / 86400); s -= d * 86400;
        const h = Math.floor(s / 3600);  s -= h * 3600;
        const m = Math.floor(s / 60);    s -= m * 60;
        if (d > 0) return `${d}d ${h}h left`;
        if (h > 0) return `${h}h ${m}m left`;
        return `${m}m ${s}s left`;
    }
    function updateTourneyCountdown() {
        const el = $('#tourney-countdown'); if (!el) return;
        const ends = STATE.tourneyEndsAt || 0;
        el.innerHTML = `<i class="fa-solid fa-hourglass-half"></i> ${fmtCountdown(ends - Date.now() / 1000)}`;
    }
    function renderTournament() {
        const t    = (STATE.snap && STATE.snap.tournament) || {};
        const card = $('#tourney-card');
        // Hide the whole card when the feature is disabled server-side.
        if (card) card.hidden = (t.enabled === false);
        if (t.enabled === false) {
            if (tourneyTimer) { clearInterval(tourneyTimer); tourneyTimer = null; }
            return;
        }
        const list = $('#tourney-list');
        const top  = t.top || [];
        if (list) {
            if (!top.length) {
                list.innerHTML = `
                    <div class="empty">
                        <div class="empty-icon"><i class="fa-solid fa-stopwatch"></i></div>
                        <div class="empty-title">No entries this week yet</div>
                        <div class="empty-sub">Catch a fish to put your name on the weekly board.</div>
                    </div>`;
            } else {
                list.innerHTML = top.map((p, i) => `
                    <div class="tourney-row r${i + 1}">
                        <div class="tourney-pos">${i + 1}</div>
                        <div class="tourney-id">
                            <div class="tourney-name">${p.name || 'Angler'}</div>
                            <div class="tourney-meta">${(p.total_catch || 0).toLocaleString()} total catches</div>
                        </div>
                        <div class="tourney-xp">${(p.week_xp || 0).toLocaleString()}<span>XP THIS WEEK</span></div>
                    </div>`).join('');
            }
        }
        STATE.tourneyEndsAt = t.endsAt || 0;
        updateTourneyCountdown();
        if (tourneyTimer) clearInterval(tourneyTimer);
        tourneyTimer = setInterval(updateTourneyCountdown, 1000);
    }

    return { open, close, refresh, switchTab, renderConditions };
})();

// ═══════════════════════════════════════════════════════════
// NUI MESSAGE BUS
// ═══════════════════════════════════════════════════════════
window.addEventListener('message', (ev) => {
    const msg = ev.data || {};
    switch (msg.action) {
        case 'show3DIcon':   WorldIcon.show(msg); break;
        case 'hide3DIcon':   WorldIcon.hide(); break;
        case 'notify':       Notify(msg.payload || {}); break;
        case 'catch_modal':  CatchModal.open(msg.payload || {}); break;
        case 'catch_modal_close': CatchModal.close(); break;
        case 'bite_alert':       BiteAlert.show(msg.payload || {}); break;
        case 'bite_alert_hide':  BiteAlert.hide(); break;
        case 'minigame_start': BiteAlert.hide(); Minigame.start(msg.payload || {}); break;
        case 'minigame_key':   Minigame.key(msg.key, msg.phase); break;
        case 'minigame_force_close': BiteAlert.hide(); Minigame.forceClose(); break;
        case 'panel_open':   Panel.open(msg.payload || {}); break;
        case 'panel_close':  Panel.close(); break;
        case 'panel_refresh': Panel.refresh((msg.payload || {}).snapshot); break;
        case 'panel_switch_tab': Panel.switchTab(msg.tab); break;
        case 'conditions': {
            STATE.conditions = msg.payload || STATE.conditions;
            if (!$('#panel').hidden) {
                // Only re-render the lightweight conditions widget
                // — the rest of the panel doesn't depend on it.
                Panel.renderConditions && Panel.renderConditions();
            }
            break;
        }
    }
});

// Escape closes the panel as a safety net
document.addEventListener('keydown', (e) => {
    if (e.code === 'Escape' && !$('#panel').hidden) Panel.close();
});
