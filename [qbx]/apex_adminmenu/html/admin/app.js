/* ============================================================
   Apex Admin Panel — UI controller
   ============================================================ */
'use strict';

const NUI = 'apex_adminmenu';
// The build this PAGE belongs to, read from the ?v= on its own <script>
// tag (html/admin/index.html). The server reports its own version in the
// bootstrap; when the two differ, old page files are being served from
// the client's cache (or the folders were mixed) and the panel says so
// instead of letting "I updated and nothing changed" go unexplained.
const APP_VERSION = (() => {
    try {
        const src = document.currentScript && document.currentScript.src;
        const m = src && /[?&]v=([0-9][0-9.]*)/.exec(src);
        return m ? m[1] : null;
    } catch (_) { return null; }
})();
const $   = (sel, root = document) => root.querySelector(sel);
const $$  = (sel, root = document) => Array.from(root.querySelectorAll(sel));

// ── NUI fetch wrappers ───────────────────────────────────
function fire(name, ...args) {
    return fetch(`https://${NUI}/panel:event`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, args })
    });
}
// After a fire(), reload twice: once quickly and once more a little later.
// fire() cannot tell when the server finished its database write, and a
// single short timer regularly reloaded BEFORE it, so the change looked like
// it had not happened until the page was reopened.
function reloadSoon(loader) {
    setTimeout(loader, 350);
    setTimeout(loader, 1300);
}
async function callback(name, ...args) {
    const res = await fetch(`https://${NUI}/panel:cb`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, args })
    });
    let data = null;
    try { data = await res.json(); } catch { return null; }
    // Seed the avatar cache with every license->url pair embedded in the
    // payload so the cache survives across renders.
    try { harvestAvatars(data); } catch (_) {}
    // After the page renderer paints its new markup (next frame),
    // walk every avatar element and paint it from the cache. This is
    // the safety net that guarantees the picture appears regardless
    // of which code path produced the DOM.
    scheduleAvatarRepaint();
    return data;
}

// Coalesce multiple paint requests into a single rAF tick.
let _repaintQueued = false;
function scheduleAvatarRepaint() {
    if (_repaintQueued) return;
    _repaintQueued = true;
    requestAnimationFrame(() => {
        _repaintQueued = false;
        repaintAllAvatars();
    });
}
function repaintAllAvatars() {
    document.querySelectorAll('[data-license]').forEach(el => {
        // Don't bother short-circuiting: paintAvatarNode does that.
        paintAvatarNode(el);
    });
}
async function myCoords() {
    const r = await fetch(`https://${NUI}/panel:myCoords`, { method: 'POST', body: '{}' });
    try { return await r.json(); } catch { return { x: 0, y: 0, z: 0 }; }
}

// ── State ────────────────────────────────────────────────
const state = {
    page: 'home', boot: null,
    home: null, mapInstance: null, mapMarkers: [],
    players: [], selectedPlayer: null,
    moderation: { tab: 'bans' },
    chat: { tab: 'staff', channel: 'staff' },
    items: [], selectedItem: null,
    vehicles: [], selectedVehicle: null,
    resources: [], resTab: 'all',
    events: [],
    eventLogs: { rows: [], rules: [], filter: '', live: true },
    staff: { groups: {}, members: {} },
    blips: [], selectedBlip: null,
    settings: {}
};

// ── Page routing ─────────────────────────────────────────

// ── Avatar system ─────────────────────────────────────────
// Single source of truth for every Steam avatar in the panel.
// Once we learn a license -> URL mapping (from any response or from
// the async `panel:avatarReady` broadcast) we keep it forever, and
// every new `.ap-av[data-license=...]` element that appears in the
// DOM is patched automatically by the MutationObserver below.
//
// This kills the "avatar shows up, then disappears on next render"
// bug entirely: even if the next callback returns `avatar: null`
// for a player, we still paint the cached image.
const avatarCache = new Map();          // license -> url
const avatarPending = new Map();        // url -> Promise<boolean> (preload state)

function rememberAvatar(license, url) {
    if (!license || !url) return;
    avatarCache.set(license, url);
    // Preload the image once so subsequent paints are instant.
    if (!avatarPending.has(url)) {
        avatarPending.set(url, new Promise(resolve => {
            const img = new Image();
            img.onload  = () => resolve(true);
            img.onerror = () => resolve(false);
            img.src = url;
        }));
    }
}

// Paints a single avatar element with the cached image (if any).
// Idempotent — safe to call repeatedly on the same node. Works on
// both `.ap-av` and the sidebar/topbar "me" widgets, which are
// tagged with data-license but use different class names.
// Preload results, shared across every avatar node using the same URL so
// a picture is only ever fetched once per panel session.
const avatarProbe = new Map();   // url -> Promise<boolean>

function probeAvatar(url) {
    if (avatarProbe.has(url)) return avatarProbe.get(url);
    const p = new Promise(resolve => {
        const img = new Image();
        img.onload  = () => resolve(true);
        img.onerror = () => resolve(false);
        img.src = url;
    });
    avatarProbe.set(url, p);
    return p;
}

function paintAvatarNode(el) {
    if (!el || el.dataset.avatarPainted === '1') return;
    const lic = el.getAttribute('data-license');
    if (!lic) return;
    const url = avatarCache.get(lic);
    if (!url) return;

    // A background-image has no onerror, so the old code removed the
    // letter fallback and THEN set the URL. When the Steam avatar 404'd
    // (no Steam identifier, private profile, resolver miss) the result
    // was a permanently empty circle with the letter already gone.
    // Probe the URL first and only swap once it genuinely loads.
    el.dataset.avatarPainted = '1';   // claim it so we don't probe twice
    probeAvatar(url).then(ok => {
        if (!ok) {
            // Leave the letter in place and allow a later, better URL.
            el.dataset.avatarPainted = '0';
            return;
        }
        el.style.backgroundImage = `url(${JSON.stringify(url)})`;
        el.style.backgroundSize = 'cover';
        el.style.backgroundPosition = 'center';
        el.classList.add('has-img');
        const fb = el.querySelector('.ap-av-fallback');
        if (fb) fb.remove();
    });
}

// Renders a div with a Steam avatar URL or a letter fallback.
// Tags the element with data-license so the broadcast + observer
// can patch it in-place. If we already cached an URL for this
// license, render WITH the image straight away.
function avatar(url, fallback, cls, license) {
    if (license && url) rememberAvatar(license, url);
    if (license && !url) url = avatarCache.get(license) || null;

    const klass = 'ap-av' + (cls ? ' ' + cls : '');
    const initial = (fallback || '?').toString().substring(0, 1).toUpperCase();

    // The letter is ALWAYS rendered, and the picture is applied later by
    // paintAvatarNode once the URL is confirmed to load. Baking the URL
    // straight into the markup (what this used to do) meant a dead Steam
    // avatar left a blank circle with no letter to fall back to.
    //
    // When there's no license we have nothing to key the repaint on, so
    // an URL supplied directly is used as-is.
    if (!license) {
        return url
            ? `<div class="${klass} has-img" style="background-image:url(${JSON.stringify(url)});background-size:cover;background-position:center"></div>`
            : `<div class="${klass}"><span class="ap-av-fallback">${initial}</span></div>`;
    }

    return `<div class="${klass}" data-license="${escapeHTML(license)}" data-avatar-painted="0">`
         + `<span class="ap-av-fallback">${initial}</span></div>`;
}

// Broadcast handler — server pushed a fresh license->url mapping.
// Cache it and repaint every matching node currently in the DOM
// regardless of class (catches `.ap-av`, `#ap-me-avatar`, `#tb-me-av`,
// and any future avatar element that uses data-license).
function applyAvatarToAll(license, url) {
    if (!license || !url) return;
    rememberAvatar(license, url);
    let lic;
    try { lic = CSS.escape(license); } catch (_) { lic = license; }
    document.querySelectorAll(`[data-license="${lic}"]`)
        .forEach(el => {
            // Force a fresh paint even if previously painted (handles
            // the case where the URL itself changed).
            el.dataset.avatarPainted = '0';
            paintAvatarNode(el);
        });
    // Also schedule a full repaint pass so any element rendered after
    // the selector ran above still gets the picture.
    scheduleAvatarRepaint();
}

// Walk a payload tree returned from the server and seed the cache
// with every {license, avatar} pair we can find. Lets us avoid
// the network round-trip when the user re-opens a panel page that
// re-renders elements with avatar=null.
//
// Generic recursive walk — covers every nested structure the server
// might send without us having to enumerate them by hand.
function harvestAvatars(payload, depth) {
    if (!payload || depth > 6) return;
    depth = depth || 0;
    if (Array.isArray(payload)) {
        payload.forEach(item => harvestAvatars(item, depth + 1));
        return;
    }
    if (typeof payload !== 'object') return;

    // Common pairs the server emits.
    if (payload.license    && payload.avatar)        rememberAvatar(payload.license,    payload.avatar);
    if (payload.target     && payload.target_avatar) rememberAvatar(payload.target,     payload.target_avatar);
    if (payload.target_lic && payload.target_avatar) rememberAvatar(payload.target_lic, payload.target_avatar);
    if (payload.author_lic && payload.author_avatar) rememberAvatar(payload.author_lic, payload.author_avatar);
    if (payload.admin_lic  && payload.admin_avatar)  rememberAvatar(payload.admin_lic,  payload.admin_avatar);
    if (payload.set_by_lic && payload.set_by_avatar) rememberAvatar(payload.set_by_lic, payload.set_by_avatar);

    // Recurse into every nested object/array. We avoid recursing into
    // strings/numbers and guard depth to defend against pathological cycles.
    for (const k in payload) {
        const v = payload[k];
        if (v && typeof v === 'object') harvestAvatars(v, depth + 1);
    }
}

// MutationObserver — paint every `[data-license]` element that enters
// the DOM (because of a re-render), AND every existing element whose
// `data-license` attribute is set/changed after creation. Combined
// with the eager paint inside `avatar()`, this is what keeps the
// picture stable across page switches and detail reloads even when
// the server response is missing avatar URLs.
const avatarObserver = new MutationObserver(records => {
    for (const r of records) {
        if (r.type === 'childList') {
            for (const node of r.addedNodes) {
                if (node.nodeType !== 1) continue;
                if (node.matches?.('[data-license]')) paintAvatarNode(node);
                node.querySelectorAll?.('[data-license]').forEach(paintAvatarNode);
            }
        } else if (r.type === 'attributes' && r.attributeName === 'data-license') {
            // The attribute itself changed — reset and re-paint.
            r.target.dataset.avatarPainted = '0';
            paintAvatarNode(r.target);
        }
    }
});
function startAvatarObserver() {
    if (!document.body) return;
    avatarObserver.observe(document.body, {
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter: ['data-license']
    });
    // Paint anything that was already in the DOM before we started.
    document.querySelectorAll('[data-license]').forEach(paintAvatarNode);
}
document.addEventListener('DOMContentLoaded', startAvatarObserver, { once: true });
if (document.body) startAvatarObserver();
function escapeHTML(s) {
    if (s == null) return '';
    return String(s).replace(/[&<>"']/g, ch => ({
        '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;'
    }[ch]));
}

/* ============================================================
   BEHAVIOUR PREFERENCES
   ------------------------------------------------------------
   Small, local prefs that change how the panel behaves rather than
   how it looks. Each one is applied through a single function so
   the boot path, the settings pane and the Save button can all use
   the same code and never drift apart.
   ============================================================ */
const PREF_DEFAULTS = {
    default_page:        'home',
    remember_page:       false,
    confirm_destructive: true,
    streamer:            false,
    compact:             false,
    reduce_motion:       false,
    clock_24:            true,
    auto_refresh:        15,
    last_page:           'home'   // written by setPage when remember_page is on
};

function prefRead(key) {
    const def = PREF_DEFAULTS[key];
    let raw;
    try { raw = localStorage.getItem('ap-pref-' + key); } catch (_) { raw = null; }
    if (raw === null || raw === undefined) return def;
    if (typeof def === 'boolean') return raw === '1';
    if (typeof def === 'number')  { const n = parseInt(raw, 10); return isNaN(n) ? def : n; }
    return raw;
}
function prefWrite(key, value) {
    try {
        localStorage.setItem('ap-pref-' + key,
            typeof value === 'boolean' ? (value ? '1' : '0') : String(value));
    } catch (_) {}
}

// Density / motion / streamer are pure presentation flags on <html>;
// the CSS does the rest.
function applyPrefs() {
    const root = document.documentElement;
    root.dataset.density  = prefRead('compact') ? 'compact' : 'normal';
    root.dataset.motion   = prefRead('reduce_motion') ? 'reduced' : 'full';
    root.dataset.streamer = prefRead('streamer') ? 'on' : 'off';
}
applyPrefs();

// Timestamp formatter honouring the 12/24-hour preference. Everything
// that prints a time should go through this.
function fmtTime(value) {
    let d;
    if (value instanceof Date) d = value;
    else if (typeof value === 'string') {
        d = new Date(value.replace(' ', 'T'));
        if (isNaN(d.getTime())) {
            // Not parseable — fall back to the raw HH:MM slice the old
            // code used, so a odd server format still shows something.
            return value.toString().slice(11, 16);
        }
    } else d = new Date();
    return d.toLocaleTimeString([], {
        hour: '2-digit', minute: '2-digit', hour12: !prefRead('clock_24')
    });
}

// ── Permission gates ─────────────────────────────────────
// The server re-checks every action; these only stop the panel from
// offering what the server is going to refuse. `boot.can` is worked out
// server-side with the same PanelHasPerm the gates use, so it is right
// for ACE-only admins too, whose `permissions` list arrives empty.
// Missing entirely → allowed, and the server decides.
const NO_WATCH = 'Your staff group needs the players.spectate permission to watch screens or spectate.';
function panelCan(key) {
    const c = state.boot && state.boot.can;
    return !c || c[key] !== false;
}
const PAGE_GATES = { monitoring: 'spectate' };
function pageAllowed(page) {
    const key = PAGE_GATES[page];
    return !key || panelCan(key);
}
function applyPermGates() {
    $$('.ap-nav-item').forEach(b => { b.style.display = pageAllowed(b.dataset.page) ? '' : 'none'; });
}

function setPage(page) {
    if (!pageAllowed(page)) {
        showToast(NO_WATCH, 'error');
        return;
    }
    state.page = page;
    if (prefRead('remember_page')) prefWrite('last_page', page);
    // Pages render their selects lazily; wrap any new ones and refresh
    // labels for selects whose value was set programmatically.
    setTimeout(() => { AP_DD.scan(); AP_DD.syncAll(); }, 0);
    $$('.ap-nav-item').forEach(b => b.classList.toggle('active', b.dataset.page === page));
    $$('.ap-page').forEach(p => p.toggleAttribute('hidden', p.dataset.page !== page));
    const loader = pageLoaders[page];
    if (loader) loader();
    // Whenever the Home page becomes visible, force the Leaflet map
    // to recompute its size. Without this it stays cut off when the
    // layout finishes settling after the page transition.
    if (page === 'home' && typeof invalidateMapSizeMulti === 'function') {
        invalidateMapSizeMulti();
    }
}

// ── Bootstrap / message handler ──────────────────────────
window.addEventListener('message', e => {
    const d = e.data;
    switch (d.action) {
        case 'panel:open':
            // Seed the avatar cache from the snapshot the server bundled
            // into the bootstrap. This puts every known license -> url
            // pair into the cache BEFORE the home page renders, so the
            // first paint already shows pictures (no "click on profile
            // first" workaround needed).
            if (d.boot && d.boot.avatarSnapshot) {
                for (const [lic, url] of Object.entries(d.boot.avatarSnapshot)) {
                    rememberAvatar(lic, url);
                }
            }
            harvestAvatars(d.boot);
            openPanel(d.boot);
            break;
        case 'panel:close':      closePanel(); break;
        // Server verdicts on panel actions (refusals with the missing
        // permission, confirmations). Drawn here because anything drawn
        // outside the focused panel is drawn underneath it.
        case 'panel:toast':      showToast(d.message || '', d.kind || 'info', d.duration || 6000); break;
        // Lua read a key for the Settings > Keybinds overlay (see captureKey).
        case 'panel:keyCaptured':
            if (state.keyCapture) state.keyCapture.accept(d.key);
            break;
        // Lua took the NUI focus back after another NUI dropped it.
        case 'panel:refocus':
            if (!$('#ap-root').classList.contains('hidden')) claimPanelKeyboardFocus();
            break;
        // F8 `apexpaneldiag`: report what the page sees, printed by Lua.
        case 'panel:diag': {
            const ae = document.activeElement;
            fetch(`https://${NUI}/panel:diagReport`, { method: 'POST', body: JSON.stringify({
                version:        state.boot && state.boot.version,
                pageVersion:    APP_VERSION,
                page:           state.page,
                rootHidden:     $('#ap-root').classList.contains('hidden'),
                hasFocus:       document.hasFocus(),
                parentHasFocus: parentHasFocus(),
                activeElement:  ae ? (ae.id || ae.tagName) : null,
                keyCapture:     !!state.keyCapture,
                escGuard:       !!state.escGuard,
                modalOpen:      !$('#ap-modal').classList.contains('hidden'),
                overlay:        !!document.querySelector('.ap-keycap-overlay'),
                toasts:         document.querySelectorAll('#ap-toasts .ap-toast').length,
                staffCards:     document.querySelectorAll('#st-members-grid .ap-staff-card').length,
            }) }).catch(() => {});
            break;
        }
        case 'panel:console':    appendConsoleLine(d.line); break;
        case 'panel:chatMsg':    harvestAvatars(d.msg); appendChatMsg(d.msg); break;
        case 'panel:timeSync':
            $('#st-clock').textContent =
                `${String(d.hour).padStart(2,'0')}:${String(d.minute).padStart(2,'0')}`;
            break;

        case 'panel:avatarReady':
            // Server finished fetching a Steam avatar — patch any
            // visible <div class="ap-av"> currently rendered for that
            // license, so the UI updates without a page refresh.
            applyAvatarToAll(d.license, d.url);
            break;

        case 'panel:settingsSaved':
            // Authoritative result of a global-settings save. Until this
            // existed the page claimed success unconditionally, so a save
            // the server refused was indistinguishable from one that
            // worked — the whole "my webhooks get deleted" report.
            onGlobalSettingsSaved(d.ok, d.message, d.settings);
            break;
    }
});

// ── Sidebar collapse ─────────────────────────────────────
function applySideCollapsed(state) {
    const shell = $('.ap-shell');
    if (!shell) return;
    shell.classList.toggle('side-collapsed', !!state);
    try { localStorage.setItem('ap-side-collapsed', state ? '1' : '0'); } catch (_) {}
}
document.addEventListener('click', e => {
    if (!e.target.closest('#ap-side-collapse')) return;
    const shell = $('.ap-shell');
    applySideCollapsed(!shell.classList.contains('side-collapsed'));
});

// ── Size selector wiring ─────────────────────────────────
// The HTML uses #set-size-picker. The picker only shows up on the
// Settings page but the size is applied to <ap-root> so it persists
// across every page.
// Only two presets exist now. Anything else — including the 's'/'m'
// values still sitting in existing users' localStorage — is coerced to
// Large, otherwise the shell would fall back to its unstyled default.
const PANEL_SIZES = ['l', 'xl'];
function applyPanelSize(size) {
    if (!PANEL_SIZES.includes(size)) size = 'l';
    const root = $('#ap-root');
    if (root) root.dataset.size = size;
    try { localStorage.setItem('ap-size', size); } catch (_) {}
    $$('#set-size-picker button').forEach(b =>
        b.classList.toggle('active', b.dataset.size === size));
}
document.addEventListener('click', e => {
    const btn = e.target.closest('#set-size-picker button');
    if (btn) applyPanelSize(btn.dataset.size);
});

// ── Theme & Brand wiring ─────────────────────────────────
// Updating --brand (and a couple of derived RGBA tokens) on :root
// recolours everything in the panel that uses the brand colour.
function hexToRgb(hex) {
    const m = /^#?([0-9a-fA-F]{6})$/.exec((hex || '').trim());
    if (!m) return { r: 26, g: 114, b: 73 };
    const n = parseInt(m[1], 16);
    return { r: (n >> 16) & 255, g: (n >> 8) & 255, b: n & 255 };
}
function applyTheme(hex) {
    if (!hex || !/^#?[0-9a-fA-F]{6}$/.test(hex)) return;
    if (hex[0] !== '#') hex = '#' + hex;
    const { r, g, b } = hexToRgb(hex);
    const root = document.documentElement;
    // Override every brand-derived custom prop used across the panel.
    // The base palette in styles.css uses fixed rgba(31,94,255,…)
    // tokens, so we need to substitute them all for the live brand
    // colour to propagate everywhere (cards, pills, badges, etc.).
    root.style.setProperty('--brand',      hex);
    root.style.setProperty('--brand-500',  hex);
    root.style.setProperty('--brand-rgb',  `${r}, ${g}, ${b}`);
    root.style.setProperty('--brand-a05', `rgba(${r}, ${g}, ${b}, 0.05)`);
    root.style.setProperty('--brand-a08', `rgba(${r}, ${g}, ${b}, 0.08)`);
    root.style.setProperty('--brand-a12', `rgba(${r}, ${g}, ${b}, 0.12)`);
    root.style.setProperty('--brand-a18', `rgba(${r}, ${g}, ${b}, 0.18)`);
    root.style.setProperty('--brand-a25', `rgba(${r}, ${g}, ${b}, 0.25)`);
    root.style.setProperty('--brand-a40', `rgba(${r}, ${g}, ${b}, 0.40)`);
    root.style.setProperty('--brand-soft', `rgba(${r}, ${g}, ${b}, 0.10)`);
    root.style.setProperty('--brand-line', `rgba(${r}, ${g}, ${b}, 0.32)`);

    // The static hex steps of the ramp have to move too. They were left
    // at their blue defaults, so on a Crimson theme the primary button
    // still flashed BLUE on hover (--brand-600) and the nav icon chip
    // stayed blue (--brand-300). Derive them from the chosen colour by
    // shifting lightness, keeping its hue and saturation.
    const { h, s, l } = rgbToHsl(r, g, b);
    root.style.setProperty('--brand-300', hslCss(h, s, Math.min(96, l + 18)));
    root.style.setProperty('--brand-400', hslCss(h, s, Math.min(92, l + 9)));
    root.style.setProperty('--brand-600', hslCss(h, s, Math.max(6,  l - 9)));
    root.style.setProperty('--brand-700', hslCss(h, s, Math.max(4,  l - 18)));
    try { localStorage.setItem('ap-theme', hex); } catch (_) {}
    // Reflect the active preset in the swatch picker.
    $$('#set-theme-presets button').forEach(btn =>
        btn.classList.toggle('active', (btn.dataset.theme || '').toLowerCase() === hex.toLowerCase()));
    const custom = $('#set-theme-custom'); if (custom && custom.value !== hex) custom.value = hex;
    const hexIn  = $('#set-theme-hex');    if (hexIn  && hexIn.value  !== hex) hexIn.value  = hex;
}
// Restore on load.
try {
    const saved = localStorage.getItem('ap-theme');
    if (saved) applyTheme(saved);
} catch (_) {}
// Apex default brand, mirrored by the Reset button.
const BRAND_DEFAULT = '#1F5EFF';

// Preset swatch click + reset.
document.addEventListener('click', e => {
    const btn = e.target.closest('#set-theme-presets button');
    if (btn && btn.dataset.theme) applyTheme(btn.dataset.theme);
    if (e.target.closest('#set-theme-reset')) applyTheme(BRAND_DEFAULT);
});
// Native colour picker + hex text input.
document.addEventListener('input', e => {
    if (e.target?.id === 'set-theme-custom') applyTheme(e.target.value);
    if (e.target?.id === 'set-theme-hex')    applyTheme(e.target.value);
});
// ── Background colour wiring ─────────────────────────────
// The whole panel is built on a surface ladder (--surface-0 … -5) plus a
// line ladder (--line-1 … -4). Every card, input and border resolves
// through those, so recolouring the base and re-deriving the rest
// re-skins the entire panel from one value.
//
// Derivation keeps the picked hue + saturation and only moves lightness,
// by the same deltas the canonical Apex ladder uses relative to its
// #0A0A0B base. That way "Deep Forest" produces a coherent green-tinted
// stack rather than a green floor under grey cards.
const BG_DEFAULT = '#0A0A0B';
const SURFACE_DELTAS = { 1: 3.1, 2: 5.9, 3: 9.6, 4: 12.6, 5: 18.2 };
const LINE_DELTAS    = { 1: 8.0, 2: 12.6, 3: 18.2, 4: 26.7 };

function rgbToHsl(r, g, b) {
    r /= 255; g /= 255; b /= 255;
    const max = Math.max(r, g, b), min = Math.min(r, g, b);
    let h = 0, s = 0;
    const l = (max + min) / 2;
    const d = max - min;
    if (d) {
        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
        if (max === r)      h = ((g - b) / d + (g < b ? 6 : 0));
        else if (max === g) h = ((b - r) / d + 2);
        else                h = ((r - g) / d + 4);
        h *= 60;
    }
    return { h, s: s * 100, l: l * 100 };
}
function hslCss(h, s, l) {
    return `hsl(${h.toFixed(1)}, ${s.toFixed(1)}%, ${Math.min(100, Math.max(0, l)).toFixed(1)}%)`;
}

// Clear the inline ladder so stylesheet rules (notably the
// `html[data-mode="light"]` block) can take over again.
function clearBackgroundOverride() {
    const root = document.documentElement;
    root.style.removeProperty('--surface-0');
    for (const step of Object.keys(SURFACE_DELTAS)) root.style.removeProperty(`--surface-${step}`);
    for (const step of Object.keys(LINE_DELTAS))    root.style.removeProperty(`--line-${step}`);
}

function applyBackground(hex) {
    if (!hex || !/^#?[0-9a-fA-F]{6}$/.test(hex)) return;
    if (hex[0] !== '#') hex = '#' + hex;

    // Persist the choice regardless of mode, so switching light → dark
    // brings the user's background back.
    try { localStorage.setItem('ap-bg', hex); } catch (_) {}

    // The custom background is a DARK-MODE feature. Writing the ladder
    // inline on <html> beats every stylesheet rule, which is exactly how
    // it broke light mode: the light block's --surface-*/--line-* never
    // won, so light mode ended up with dark surfaces and (from the
    // uncontested light text tokens) dark text on top of them.
    if (document.documentElement.dataset.mode === 'light') {
        clearBackgroundOverride();
        syncBackgroundControls(hex, true);
        return;
    }

    const { r, g, b } = hexToRgb(hex);
    const { h, s } = rgbToHsl(r, g, b);
    let { l } = rgbToHsl(r, g, b);

    // This is a dark UI: every text token is near-white. Letting the base
    // go light would make the panel unreadable, so the floor is clamped.
    // Presets stay well inside this.
    l = Math.min(l, 26);

    const root = document.documentElement;
    root.style.setProperty('--surface-0', hslCss(h, s, l));
    for (const [step, d] of Object.entries(SURFACE_DELTAS)) {
        root.style.setProperty(`--surface-${step}`, hslCss(h, s, l + d));
    }
    for (const [step, d] of Object.entries(LINE_DELTAS)) {
        root.style.setProperty(`--line-${step}`, hslCss(h, s, l + d));
    }

    syncBackgroundControls(hex, false);
}

// Reflect the value in the picker, and grey the whole card out in light
// mode so it's obvious why it has no effect there.
function syncBackgroundControls(hex, disabled) {
    $$('#set-bg-presets button').forEach(btn => {
        btn.classList.toggle('active', (btn.dataset.bg || '').toLowerCase() === hex.toLowerCase());
        btn.disabled = disabled;
    });
    const c = $('#set-bg-custom'); if (c) { if (c.value !== hex) c.value = hex; c.disabled = disabled; }
    const t = $('#set-bg-hex');    if (t) { if (t.value  !== hex) t.value  = hex; t.disabled = disabled; }
    const r = $('#set-bg-reset');  if (r) r.disabled = disabled;
    const note = $('#set-bg-note');
    if (note) note.hidden = !disabled;
}

// Restore on load.
try {
    const savedBg = localStorage.getItem('ap-bg');
    if (savedBg) applyBackground(savedBg);
} catch (_) {}

document.addEventListener('click', e => {
    const btn = e.target.closest('#set-bg-presets button');
    if (btn && btn.dataset.bg) applyBackground(btn.dataset.bg);
    if (e.target.closest('#set-bg-reset')) applyBackground(BG_DEFAULT);
});
document.addEventListener('input', e => {
    if (e.target?.id === 'set-bg-custom') applyBackground(e.target.value);
    if (e.target?.id === 'set-bg-hex')    applyBackground(e.target.value);
});

/* ============================================================
   CUSTOM DROPDOWNS
   ------------------------------------------------------------
   CEF will not style the native <option> popup — it is drawn by the
   OS, which is why every <select> in the panel opened as an unstyled
   white-on-black list. Same reason apex_garage ships its own.

   This is progressive enhancement, not a replacement: the real
   <select> stays in the DOM (hidden) and remains the source of truth.
   Picking an item sets `select.value` and dispatches a `change` event,
   so every existing listener and every `val('set-x')` read keeps
   working untouched — no call sites had to change.

   Menu items are rebuilt each time it opens, so selects whose
   <option>s are repopulated at runtime (job filters, player pickers)
   need no extra wiring.
   ============================================================ */
const AP_DD = (() => {
    let current = null;

    function closeOpen() {
        if (!current) return;
        current.wrap.classList.remove('open');
        current.menu.hidden = true;
        current = null;
    }

    function labelFor(sel) {
        const opt = sel.options[sel.selectedIndex];
        return opt ? opt.textContent : '';
    }

    function renderMenu(dd) {
        const { sel, menu } = dd;
        menu.innerHTML = '';
        Array.from(sel.options).forEach((opt, i) => {
            const item = document.createElement('button');
            item.type = 'button';
            item.className = 'ap-dd-item'
                + (i === sel.selectedIndex ? ' active' : '')
                + (opt.disabled ? ' disabled' : '');
            item.textContent = opt.textContent;
            item.dataset.idx = String(i);
            if (opt.disabled) item.tabIndex = -1;
            menu.appendChild(item);
        });
    }

    function pick(dd, idx) {
        const { sel } = dd;
        const opt = sel.options[idx];
        if (!opt || opt.disabled) return;
        sel.selectedIndex = idx;
        sync(dd);
        closeOpen();
        // Let the rest of the app react exactly as it did with a native
        // select. `change` (not `input`) is what selects fire natively.
        sel.dispatchEvent(new Event('change', { bubbles: true }));
    }

    function sync(dd) { dd.label.textContent = labelFor(dd.sel); }

    function open(dd) {
        if (current === dd) { closeOpen(); return; }
        closeOpen();
        renderMenu(dd);
        dd.wrap.classList.add('open');
        dd.menu.hidden = false;
        current = dd;

        // Flip upwards when there isn't room below.
        const r = dd.btn.getBoundingClientRect();
        const spaceBelow = window.innerHeight - r.bottom;
        dd.menu.classList.toggle('up', spaceBelow < 220 && r.top > spaceBelow);

        const active = dd.menu.querySelector('.ap-dd-item.active');
        if (active) active.scrollIntoView({ block: 'nearest' });
    }

    function build(sel) {
        if (sel.dataset.apDd === '1') return;
        sel.dataset.apDd = '1';

        const wrap = document.createElement('div');
        wrap.className = 'ap-dd' + (sel.classList.contains('ap-input-sm') ? ' sm' : '');
        sel.parentNode.insertBefore(wrap, sel);
        wrap.appendChild(sel);

        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'ap-dd-btn';
        btn.innerHTML = '<span class="ap-dd-label"></span><i class="fa-solid fa-chevron-down"></i>';

        const menu = document.createElement('div');
        menu.className = 'ap-dd-menu';
        menu.hidden = true;

        wrap.appendChild(btn);
        wrap.appendChild(menu);

        const dd = { sel, wrap, btn, menu, label: btn.querySelector('.ap-dd-label') };
        sel._dd = dd;
        sync(dd);

        btn.addEventListener('click', e => { e.stopPropagation(); open(dd); });
        menu.addEventListener('click', e => {
            const item = e.target.closest('.ap-dd-item');
            if (!item) return;
            e.stopPropagation();
            pick(dd, Number(item.dataset.idx));
        });

        // Keep the button label honest if other code sets .value and
        // dispatches change itself.
        sel.addEventListener('change', () => sync(dd));

        btn.addEventListener('keydown', e => {
            if (e.key === 'Enter' || e.key === ' ' || e.key === 'ArrowDown') {
                e.preventDefault(); open(dd);
            }
        });
        menu.addEventListener('keydown', e => {
            const items = Array.from(menu.querySelectorAll('.ap-dd-item:not(.disabled)'));
            const at = items.indexOf(document.activeElement);
            if (e.key === 'Escape')    { e.preventDefault(); closeOpen(); btn.focus(); }
            if (e.key === 'ArrowDown') { e.preventDefault(); (items[at + 1] || items[0])?.focus(); }
            if (e.key === 'ArrowUp')   { e.preventDefault(); (items[at - 1] || items[items.length - 1])?.focus(); }
        });
    }

    document.addEventListener('click', closeOpen);
    document.addEventListener('keydown', e => { if (e.key === 'Escape') closeOpen(); });

    // Selects injected later (modals, player pickers, job lists, the
    // event-rule dialog) get wrapped as soon as they land in the DOM,
    // so nothing has to remember to call scan().
    const observer = new MutationObserver(records => {
        let found = false;
        for (const r of records) {
            for (const node of r.addedNodes) {
                if (node.nodeType !== 1) continue;
                if (node.tagName === 'SELECT' || node.querySelector?.('select')) { found = true; break; }
            }
            if (found) break;
        }
        if (found) $$('select').forEach(build);
    });
    document.addEventListener('DOMContentLoaded', () => {
        $$('select').forEach(build);
        observer.observe(document.body, { childList: true, subtree: true });
    });

    return {
        // Wrap every select that doesn't have a dropdown yet.
        scan() { $$('select').forEach(build); },
        // Re-read labels — for code that assigns .value without firing change.
        syncAll() { $$('select').forEach(s => { if (s._dd) sync(s._dd); }); }
    };
})();

/* Behaviour controls. Everything applies instantly — nothing here needs
   the Save button, which only exists for the server-side settings. */
const PREF_CONTROLS = {
    'set-default-page':        { key: 'default_page',        type: 'value' },
    'set-auto-refresh':        { key: 'auto_refresh',        type: 'int'   },
    'set-remember-page':       { key: 'remember_page',       type: 'check' },
    'set-confirm-destructive': { key: 'confirm_destructive', type: 'check' },
    'set-streamer':            { key: 'streamer',            type: 'check' },
    'set-compact':             { key: 'compact',             type: 'check' },
    'set-reduce-motion':       { key: 'reduce_motion',       type: 'check' },
    'set-clock-24':            { key: 'clock_24',            type: 'check' }
};

document.addEventListener('change', e => {
    const spec = PREF_CONTROLS[e.target?.id];
    if (!spec) return;

    const value = spec.type === 'check' ? !!e.target.checked
                : spec.type === 'int'   ? (parseInt(e.target.value, 10) || 0)
                : e.target.value;
    prefWrite(spec.key, value);
    applyPrefs();

    // Side effects that need more than a data-attribute.
    if (spec.key === 'auto_refresh' && typeof restartHomeStatsTicker === 'function') {
        restartHomeStatsTicker();
    }
    if (spec.key === 'remember_page' && value) prefWrite('last_page', state.page || 'home');
    if (spec.key === 'clock_24') {
        // Repaint anything already showing a timestamp.
        if (state.page === 'chats' && typeof window.apxReloadChat === 'function') window.apxReloadChat();
    }
});

// Live brand hex — reads the current --brand (themed by applyTheme) so
// canvas/Leaflet colours that can't use CSS vars still follow the theme.
function brandColor() {
    const c = getComputedStyle(document.documentElement).getPropertyValue('--brand').trim();
    return c || '#1F5EFF';
}

// ── Custom tooltip for [title] attributes ────────────────
// Native `title` tooltips are slow and clip behind sticky containers.
// We move the text into `data-tip` so the browser stops rendering its
// native bubble, and paint our own at the top of the stack instead.
(function () {
    let tipEl = null;
    function ensureTip() {
        if (tipEl) return tipEl;
        tipEl = document.createElement('div');
        tipEl.className = 'ap-tooltip';
        document.body.appendChild(tipEl);
        return tipEl;
    }
    function show(text, x, y) {
        const tip = ensureTip();
        tip.textContent = text;
        tip.classList.toggle('wrap', text.length > 40);
        // Position above + slightly right of the cursor; flip near edges.
        tip.style.left = (x + 14) + 'px';
        tip.style.top  = (y + 18) + 'px';
        requestAnimationFrame(() => {
            const r = tip.getBoundingClientRect();
            if (r.right > window.innerWidth - 8) {
                tip.style.left = (x - r.width - 12) + 'px';
            }
            if (r.bottom > window.innerHeight - 8) {
                tip.style.top = (y - r.height - 12) + 'px';
            }
            tip.classList.add('show');
        });
    }
    function hide() {
        if (tipEl) tipEl.classList.remove('show');
    }
    function targetText(el) {
        return el.dataset.tip || el.getAttribute('title') || '';
    }
    // Promote `title` to `data-tip` so the browser's native tooltip
    // doesn't fight with ours. Done once, lazily, when we encounter
    // each element.
    function adoptTitle(el) {
        if (!el || el.dataset.tip || !el.hasAttribute('title')) return;
        const t = el.getAttribute('title');
        if (!t) return;
        el.dataset.tip = t;
        el.removeAttribute('title');
    }
    document.addEventListener('mouseover', e => {
        const el = e.target.closest('[title], [data-tip]');
        if (!el) return;
        adoptTitle(el);
        const txt = targetText(el);
        if (!txt) return;
        show(txt, e.clientX, e.clientY);
    });
    document.addEventListener('mousemove', e => {
        if (!tipEl || !tipEl.classList.contains('show')) return;
        // Reposition without re-rendering text.
        tipEl.style.left = (e.clientX + 14) + 'px';
        tipEl.style.top  = (e.clientY + 18) + 'px';
    });
    document.addEventListener('mouseout', e => {
        const to = e.relatedTarget;
        if (!to || !to.closest?.('[title], [data-tip]')) hide();
    });
    document.addEventListener('click', hide, true);
})();

// ── Settings tabs ────────────────────────────────────────
document.addEventListener('click', e => {
    const tab = e.target.closest('.ap-set-tab');
    if (!tab) return;
    const target = tab.dataset.setTab;
    $$('.ap-set-tab').forEach(t => t.classList.toggle('active', t === tab));
    $$('.ap-set-tab-content').forEach(p => {
        p.toggleAttribute('hidden', p.dataset.setPane !== target);
    });
});

// ── Display mode (dark / light) ──────────────────────────
function applyDisplayMode(mode) {
    if (mode !== 'light' && mode !== 'dark') mode = 'dark';
    const root = document.documentElement;
    root.dataset.mode = mode;
    try { localStorage.setItem('ap-mode', mode); } catch (_) {}
    $$('#set-mode-picker button').forEach(b => b.classList.toggle('active', b.dataset.mode === mode));

    // The panel runs in an iframe inside the quick menu's page. Tell the
    // parent so the F9 menu switches with it instead of staying dark.
    try {
        if (window.parent && window.parent !== window) {
            window.parent.postMessage({ action: 'apex:mode', mode }, '*');
        }
    } catch (_) {}

    // The custom background writes the surface/line ladder inline on
    // <html>, which outranks the light-mode stylesheet block. Re-running
    // it here re-applies it in dark mode and clears it in light mode, so
    // switching modes actually changes the surfaces.
    if (typeof applyBackground === 'function') {
        let bg = BG_DEFAULT;
        try { bg = localStorage.getItem('ap-bg') || BG_DEFAULT; } catch (_) {}
        applyBackground(bg);
    }
}
try {
    const saved = localStorage.getItem('ap-mode');
    if (saved) applyDisplayMode(saved);
} catch (_) {}
document.addEventListener('click', e => {
    const btn = e.target.closest('#set-mode-picker button');
    if (btn) applyDisplayMode(btn.dataset.mode);
});

// ── Panel opacity ────────────────────────────────────────
function applyPanelOpacity(pct) {
    let v = parseInt(pct, 10);
    if (!Number.isFinite(v)) v = 100;
    v = Math.max(60, Math.min(100, v));
    const shell = document.querySelector('.ap-shell');
    if (shell) shell.style.opacity = (v / 100).toString();
    const ro = $('#set-opacity-readout'); if (ro) ro.textContent = v + '%';
    const sl = $('#set-opacity'); if (sl && sl.value != v) sl.value = v;
    try { localStorage.setItem('ap-opacity', String(v)); } catch (_) {}
}
try {
    const saved = parseInt(localStorage.getItem('ap-opacity') || '100', 10);
    applyPanelOpacity(saved);
} catch (_) {}
document.addEventListener('input', e => {
    if (e.target?.id === 'set-opacity') applyPanelOpacity(e.target.value);
});

function openPanel(boot) {
    state.boot = boot || {};
    // Vehicle thumbnail config (Config.VehicleImages), resolved client-side
    // because the nui:// base URL needs the live resource name.
    state.images = state.boot.images || false;
    $('#ap-root').classList.remove('hidden');
    // Restore the user's preferred panel size + sidebar state.
    let savedSize = 'l';
    let savedCollapsed = false;
    try {
        savedSize = localStorage.getItem('ap-size') || 'l';
        savedCollapsed = localStorage.getItem('ap-side-collapsed') === '1';
    } catch (_) {}
    applyPanelSize(savedSize);
    applySideCollapsed(savedCollapsed);
    claimPanelKeyboardFocus();
    startFocusKeeper();
    $('#ap-me-name').textContent  = boot.name || '—';
    $('#ap-me-group').textContent = boot.groupLabel || boot.group || '—';
    // The running build, from the server's manifest. A screenshot of the
    // sidebar settles "did the update land?" without any console access.
    // When this page's own build differs, both are shown and a warning
    // explains it: the client is still running cached page files.
    const verEl = $('#ap-version');
    const mismatch = !!(APP_VERSION && boot.version && APP_VERSION !== boot.version);
    if (verEl) {
        verEl.textContent = mismatch
            ? `server v${boot.version} · page v${APP_VERSION}`
            : (boot.version ? 'v' + boot.version : (APP_VERSION ? 'page v' + APP_VERSION : ''));
        verEl.classList.toggle('mismatch', mismatch);
    }
    if (mismatch) {
        showToast(`Version mismatch: the server runs apex_adminmenu v${boot.version} but this panel page is v${APP_VERSION}. `
            + 'Old files are still being served. Restart the server (not only the resource) and reconnect; if it persists, there are two copies of the resource.', 'warning', 15000);
    }
    // Top-right "me" widget.
    const tbMeName = $('#tb-me-name');
    if (tbMeName) tbMeName.textContent = boot.name || '—';

    // Tag the "me" avatar elements with the admin's license BEFORE
    // painting so the observer recognises them and so the cache + the
    // panel:avatarReady broadcast can keep them in sync.
    if (boot.license) {
        $('#tb-me-av')?.setAttribute('data-license', boot.license);
        $('#ap-me-avatar')?.setAttribute('data-license', boot.license);
    }
    if (boot.license && boot.avatar) rememberAvatar(boot.license, boot.avatar);
    const paintMe = url => {
        const apply = el => {
            if (!el) return;
            if (url) {
                el.style.backgroundImage = `url(${JSON.stringify(url)})`;
                el.style.backgroundSize  = 'cover';
                el.style.backgroundPosition = 'center';
                el.classList.add('has-img');
                el.innerHTML = '';
                el.dataset.avatarPainted = '1';
            } else {
                el.style.backgroundImage = '';
                el.classList.remove('has-img');
                el.dataset.avatarPainted = '0';
                el.innerHTML = `<span class="ap-av-fallback">${(boot.name || '?').substring(0,1).toUpperCase()}</span>`;
            }
        };
        apply($('#ap-me-avatar'));
        apply($('#tb-me-av'));
    };
    paintMe(boot.avatar || (boot.license && avatarCache.get(boot.license)));

    startTopbarTicker();
    applyPermGates();
    // Land on the remembered page when that's enabled, otherwise the
    // configured default. Guard against a stale page id from an older
    // build so the panel can never open on a page that no longer exists,
    // or on one this staff member is no longer allowed to see.
    let landing = prefRead('remember_page') ? prefRead('last_page') : prefRead('default_page');
    if (!document.querySelector(`.ap-page[data-page="${landing}"]`) || !pageAllowed(landing)) landing = 'home';
    setPage(landing);
}

// ── Global topbar — live uptime + players + announce ────
function fmtUptime(sec) {
    sec = Math.max(0, parseInt(sec, 10) || 0);
    const d = Math.floor(sec / 86400);
    const h = Math.floor((sec % 86400) / 3600);
    const m = Math.floor((sec % 3600) / 60);
    if (d > 0) return `${d}d ${h}h ${m}m`;
    if (h > 0) return `${h}h ${m}m`;
    return `${m}m`;
}

let topbarTicker = null;
let topbarBase   = null; // { uptime, fetchedAt }
async function refreshTopbar() {
    const r = await callback('topbar');
    if (!r) return;
    topbarBase = { uptime: r.uptime, fetchedAt: Date.now() };
    const tbP = $('#tb-players');
    if (tbP) tbP.textContent = `${r.playerCount}/${r.maxSlots}`;
    if (r.avatar) applyAvatarToAll(state.boot?.license, r.avatar);
}
function tickTopbar() {
    if (!topbarBase) return;
    const elapsed = Math.floor((Date.now() - topbarBase.fetchedAt) / 1000);
    const up = $('#tb-uptime');
    if (up) up.textContent = fmtUptime(topbarBase.uptime + elapsed);
}
function startTopbarTicker() {
    if (topbarTicker) return;
    refreshTopbar();
    // Tick the visible uptime every second; re-fetch on the interval the
    // user picked in Settings → Behaviour (0 = never auto-refresh, the
    // uptime still counts up locally).
    topbarTicker = setInterval(() => {
        tickTopbar();
        const every = prefRead('auto_refresh');
        if (every > 0 && Math.random() < 1 / every) refreshTopbar();
    }, 1000);
    // First full refresh fast.
    setTimeout(refreshTopbar, 1500);
}

// Announce button — opens a richer modal (type + target).
document.addEventListener('click', e => {
    if (!e.target.closest('#tb-announce')) return;
    openAnnounceModal();
});

function openAnnounceModal() {
    const modal = $('#ap-modal');
    const body  = $('#ap-modal-body');
    const title = $('#ap-modal-title');
    if (!modal || !body) return;
    title.textContent = 'Server Announcement';
    body.innerHTML = `
        <div class="ap-announce-form">
            <label class="ap-form-row">
                <span>Title (optional)</span>
                <input class="ap-input" id="ap-announce-title" placeholder="Server announcement" maxlength="60">
            </label>
            <label class="ap-form-row">
                <span>Message</span>
                <textarea class="ap-input" id="ap-announce-msg" rows="3" placeholder="What do you want to say?"></textarea>
            </label>

            <div class="ap-form-row">
                <span>Type</span>
                <div class="ap-announce-types">
                    <button type="button" class="ap-announce-type active" data-type="info">
                        <i class="fa-solid fa-circle-info"></i> Info
                    </button>
                    <button type="button" class="ap-announce-type" data-type="success">
                        <i class="fa-solid fa-circle-check"></i> Success
                    </button>
                    <button type="button" class="ap-announce-type" data-type="warning">
                        <i class="fa-solid fa-triangle-exclamation"></i> Warning
                    </button>
                    <button type="button" class="ap-announce-type" data-type="error">
                        <i class="fa-solid fa-circle-exclamation"></i> Error
                    </button>
                </div>
            </div>

            <div class="ap-form-row">
                <span>Screen position</span>
                <div class="ap-announce-positions" id="ap-announce-positions">
                    <button type="button" data-pos="top-left"      title="Top left">↖</button>
                    <button type="button" data-pos="top-center" class="active" title="Top center">↑</button>
                    <button type="button" data-pos="top-right"     title="Top right">↗</button>
                    <button type="button" data-pos="middle-left"   title="Middle left">←</button>
                    <button type="button" data-pos="middle-center" title="Center">●</button>
                    <button type="button" data-pos="middle-right"  title="Middle right">→</button>
                    <button type="button" data-pos="bottom-left"   title="Bottom left">↙</button>
                    <button type="button" data-pos="bottom-center" title="Bottom center">↓</button>
                    <button type="button" data-pos="bottom-right"  title="Bottom right">↘</button>
                </div>
            </div>

            <label class="ap-form-row">
                <span>Duration (seconds)</span>
                <input class="ap-input" id="ap-announce-duration" type="number" min="2" max="60" value="8">
            </label>

            <label class="ap-form-row">
                <span>Target</span>
                <select class="ap-input" id="ap-announce-target">
                    <option value="all">Everyone on the server</option>
                    <option value="staff">Only staff</option>
                    <option value="job">Players with a specific job…</option>
                    <option value="id">A single player by ID…</option>
                </select>
            </label>

            <label class="ap-form-row ap-announce-extra" id="ap-announce-extra" style="display:none">
                <span id="ap-announce-extra-lbl">Job name</span>
                <input class="ap-input mono" id="ap-announce-extra-input" placeholder="police">
            </label>
        </div>`;
    modal.classList.remove('hidden');

    // Wire type chips.
    body.querySelectorAll('.ap-announce-type').forEach(btn => {
        btn.addEventListener('click', () => {
            body.querySelectorAll('.ap-announce-type').forEach(b => b.classList.toggle('active', b === btn));
        });
    });

    // Wire the 3x3 position grid.
    body.querySelectorAll('.ap-announce-positions button').forEach(btn => {
        btn.addEventListener('click', () => {
            body.querySelectorAll('.ap-announce-positions button')
                .forEach(b => b.classList.toggle('active', b === btn));
        });
    });

    // Toggle the extra field for job / id targets.
    const targetSel = $('#ap-announce-target');
    const extra     = $('#ap-announce-extra');
    const extraLbl  = $('#ap-announce-extra-lbl');
    const extraIn   = $('#ap-announce-extra-input');
    targetSel.addEventListener('change', () => {
        if (targetSel.value === 'job') {
            extra.style.display = '';
            extraLbl.textContent = 'Job name';
            extraIn.placeholder  = 'police';
        } else if (targetSel.value === 'id') {
            extra.style.display = '';
            extraLbl.textContent = 'Server ID';
            extraIn.placeholder  = '12';
        } else {
            extra.style.display = 'none';
        }
    });

    // Rewire ok/cancel buttons just for this modal.
    const ok = $('#ap-modal-ok'), cancel = $('#ap-modal-cancel'), close = $('#ap-modal-close');
    const newOk = ok.cloneNode(true);     ok.replaceWith(newOk);
    const newCa = cancel.cloneNode(true); cancel.replaceWith(newCa);
    const newCl = close.cloneNode(true);  close.replaceWith(newCl);
    newOk.textContent = 'Send';
    const finish = (commit) => {
        if (commit) {
            const msg = ($('#ap-announce-msg').value || '').trim();
            if (!msg) { showToast('Message is empty.', 'warning'); return; }
            const annTitle = ($('#ap-announce-title').value || '').trim();
            const type     = body.querySelector('.ap-announce-type.active')?.dataset.type || 'info';
            const position = body.querySelector('.ap-announce-positions button.active')?.dataset.pos || 'top-center';
            const duration = Math.max(2, Math.min(60, parseInt($('#ap-announce-duration').value, 10) || 8));
            let target = targetSel.value;
            if (target === 'job') target = 'job:' + (extraIn.value.trim() || '');
            if (target === 'id')  target = 'id:'  + (extraIn.value.trim() || '');
            fire('announce', {
                message: msg,
                title:   annTitle,
                type, position, duration,
                target
            });
            // The server confirms ("Announcement sent to …") or explains the
            // refusal; claiming success here hid both.
            showToast('Sending announcement…', 'info', 2000);
        }
        modal.classList.add('hidden');
    };
    newOk.addEventListener('click', () => finish(true));
    newCa.addEventListener('click', () => finish(false));
    newCl.addEventListener('click', () => finish(false));
    setTimeout(() => $('#ap-announce-msg')?.focus(), 50);
}
/* ============================================================
   Topbar quick-search (Ctrl+K command palette)
   ============================================================
   Indexes everything searchable in the panel — pages, online
   players, jobs, resources — and offers them as a dropdown
   below the input. Enter activates the highlighted result;
   arrow keys move the highlight; Esc closes the popup. */
const QUICKSEARCH = (() => {
    const PAGE_ITEMS = [
        { kind: 'page', label: 'Home',          icon: 'fa-house',           hint: 'Dashboard + map',          page: 'home'      },
        { kind: 'page', label: 'Players',       icon: 'fa-users',           hint: 'Online players',           page: 'players'   },
        { kind: 'page', label: 'Monitoring',    icon: 'fa-eye',             hint: 'Watch streams',            page: 'monitoring'},
        { kind: 'page', label: 'Moderation',    icon: 'fa-gavel',           hint: 'Bans / warns / jails',     page: 'moderation'},
        { kind: 'page', label: 'Chats',         icon: 'fa-comments',        hint: 'Staff chat & DMs',         page: 'chats'     },
        { kind: 'page', label: 'Items',         icon: 'fa-boxes-stacked',   hint: 'Items database',           page: 'items'     },
        { kind: 'page', label: 'Vehicles',      icon: 'fa-car',             hint: 'Vehicles database',        page: 'vehicles'  },
        { kind: 'page', label: 'Console',       icon: 'fa-terminal',        hint: 'Server console',           page: 'console'   },
        { kind: 'page', label: 'Event Logs',    icon: 'fa-bolt',            hint: 'Event capture + rules',    page: 'events'    },
        { kind: 'page', label: 'Staff',         icon: 'fa-id-card-clip',    hint: 'Members & groups',         page: 'staff'     },
        { kind: 'page', label: 'Jobs',          icon: 'fa-briefcase',       hint: 'Framework jobs',           page: 'jobs'      },
        { kind: 'page', label: 'Blips',         icon: 'fa-location-dot',    hint: 'Map markers',              page: 'blips'     },
        { kind: 'page', label: 'Logs',          icon: 'fa-clock-rotate-left',hint: 'Audit trail',             page: 'logs'      },
        { kind: 'page', label: 'Settings',      icon: 'fa-sliders',         hint: 'Personal preferences',     page: 'settings'  }
    ];

    let highlightIdx = 0;
    let currentResults = [];

    function score(needle, hay) {
        if (!hay) return -1;
        const h = hay.toLowerCase();
        const n = needle.toLowerCase();
        if (h === n) return 1000;
        if (h.startsWith(n)) return 500;
        if (h.includes(n)) return 250;
        // Fuzzy: every char of needle present in order? small score.
        let ni = 0;
        for (let i = 0; i < h.length && ni < n.length; i++) if (h[i] === n[ni]) ni++;
        return ni === n.length ? 50 : -1;
    }

    function buildIndex() {
        // Pages this staff member may open; players / jobs / resources
        // are pulled from the live state caches we already maintain.
        const out = PAGE_ITEMS.filter(p => pageAllowed(p.page));
        // Online players (from home cache OR players cache).
        const pool = (state.home?.players?.length ? state.home.players : state.players) || [];
        pool.forEach(p => {
            out.push({
                kind: 'player',
                label: p.name,
                icon: 'fa-user',
                hint: `#${p.id}${p.job ? ' · ' + p.job : ''}${p.isStaff ? ' · staff' : ''}`,
                playerId: p.id,
                license: p.license
            });
        });
        // Jobs.
        (state.jobs?.list || []).forEach(j => {
            out.push({
                kind: 'job',
                label: j.label || j.name,
                icon: 'fa-briefcase',
                hint: 'Job · ' + j.name,
                jobName: j.name
            });
        });
        // Resources (loaded when the Console page has been visited).
        (state.resources || []).forEach(r => {
            out.push({
                kind: 'resource',
                label: r.name,
                icon: 'fa-cube',
                hint: 'Resource · ' + (r.state === 'started' ? 'running' : 'stopped'),
                resource: r.name
            });
        });
        return out;
    }

    function search(q) {
        q = (q || '').trim();
        if (!q) { currentResults = []; return []; }
        const index = buildIndex();
        const scored = index
            .map(item => ({ item, s: Math.max(score(q, item.label), score(q, item.hint || '')) }))
            .filter(r => r.s > 0)
            .sort((a, b) => b.s - a.s)
            .slice(0, 12)
            .map(r => r.item);
        currentResults = scored;
        return scored;
    }

    function render(results) {
        const wrap = $('#tb-search-results');
        if (!wrap) return;
        if (results.length === 0) {
            wrap.innerHTML = `<div class="ap-tb-search-empty">No matches</div>`;
            wrap.hidden = false;
            return;
        }
        wrap.innerHTML = results.map((r, i) => `
            <div class="ap-tb-search-row${i === highlightIdx ? ' active' : ''}" data-idx="${i}">
                <i class="fa-solid ${r.icon}"></i>
                <div class="ap-tb-search-meta">
                    <span class="ap-tb-search-label">${escapeHTML(r.label)}</span>
                    <span class="ap-tb-search-hint">${escapeHTML(r.hint || '')}</span>
                </div>
                <span class="ap-tb-search-kind">${escapeHTML(r.kind)}</span>
            </div>`).join('');
        wrap.hidden = false;
        wrap.querySelectorAll('.ap-tb-search-row').forEach(row => {
            row.addEventListener('mouseenter', () => {
                highlightIdx = Number(row.dataset.idx);
                wrap.querySelectorAll('.ap-tb-search-row').forEach((r, i) =>
                    r.classList.toggle('active', i === highlightIdx));
            });
            row.addEventListener('click', () => activate(currentResults[Number(row.dataset.idx)]));
        });
    }

    function activate(item) {
        if (!item) return;
        close();
        if (item.kind === 'page')     { setPage(item.page); }
        else if (item.kind === 'player')   {
            setPage('players');
            setTimeout(() => selectPlayer(item.playerId), 180);
        }
        else if (item.kind === 'job') {
            setPage('jobs');
            setTimeout(() => {
                const j = (state.jobs?.list || []).find(x => x.name === item.jobName);
                if (j && typeof openJobEditor === 'function') openJobEditor(j);
            }, 180);
        }
        else if (item.kind === 'resource') {
            setPage('console');
            setTimeout(() => { const s = $('#res-search'); if (s) { s.value = item.resource; s.dispatchEvent(new Event('input')); } }, 180);
        }
    }

    function close() {
        const wrap = $('#tb-search-results');
        if (wrap) wrap.hidden = true;
        const input = $('#tb-search');
        if (input) input.blur();
    }

    function onInput() {
        const v = $('#tb-search').value || '';
        if (!v.trim()) { $('#tb-search-results').hidden = true; return; }
        highlightIdx = 0;
        render(search(v));
    }

    function onKey(e) {
        const wrap = $('#tb-search-results');
        if (e.key === 'Escape') { close(); return; }
        if (!currentResults.length) return;
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            highlightIdx = (highlightIdx + 1) % currentResults.length;
            render(currentResults);
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            highlightIdx = (highlightIdx - 1 + currentResults.length) % currentResults.length;
            render(currentResults);
        } else if (e.key === 'Enter') {
            e.preventDefault();
            activate(currentResults[highlightIdx]);
        }
    }

    // Wire on DOM ready.
    function wire() {
        const input = $('#tb-search');
        if (!input) return;
        input.addEventListener('input', onInput);
        input.addEventListener('keydown', onKey);
        input.addEventListener('focus', () => { if ((input.value || '').trim()) onInput(); });
        // Click outside closes the popup.
        document.addEventListener('mousedown', e => {
            if (!e.target.closest('#tb-search-wrap')) close();
        });
    }
    if (document.readyState !== 'loading') wire();
    else document.addEventListener('DOMContentLoaded', wire);

    return { open: () => $('#tb-search')?.focus(), close };
})();

// Ctrl+K / ⌘K opens the palette.
document.addEventListener('keydown', e => {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        QUICKSEARCH.open();
    }
});
function closePanel() {
    // Stop what we started. Only the tile's own close button used to end
    // a stream, so closing the panel with ESC left the watched player
    // capturing and uploading a frame every 1.5s to nobody.
    Array.from(state.monWatched.keys()).forEach(id => stopMonitor(id));
    // A key capture left open must not outlive the panel: its Esc guard
    // would otherwise block Esc on the next open until it timed out.
    if (state.keyCapture) state.keyCapture.cancel();
    stopFocusKeeper();
    $('#ap-root').classList.add('hidden');
}

// ── Keyboard-focus keeper ────────────────────────────────
// CEF delivers key events to the focused document only, and this panel is
// an iframe: the focus can sit on the parent page (panel opened by key, or
// the quick menu / reports pane came and went underneath) and every key
// typed into the chat or a form goes nowhere, while the mouse still works.
// While the panel is open, check twice a second and pull the keyboard back
// whenever the focus is somewhere in THIS resource's page but not in the
// panel. Focus held by another resource's UI (a death screen, a phone) is
// left alone: the parent then does not have it either.
let focusKeeper = null;
function parentHasFocus() {
    try { return !!(window.parent && window.parent !== window && window.parent.document.hasFocus()); } catch (_) { return false; }
}
function startFocusKeeper() {
    if (focusKeeper) return;
    focusKeeper = setInterval(() => {
        if ($('#ap-root').classList.contains('hidden')) return;
        if (document.hasFocus()) return;
        if (!parentHasFocus()) return;
        claimPanelKeyboardFocus();
    }, 500);
}
function stopFocusKeeper() {
    if (focusKeeper) { clearInterval(focusKeeper); focusKeeper = null; }
}

// While a key-capture overlay is up (Settings > Keybinds), Escape cancels
// the capture and must not close the panel. The Lua Escape watch gets the
// same guard through panel:escGuard.
function setEscGuard(on) {
    state.escGuard = !!on;
    fetch(`https://${NUI}/panel:escGuard`, { method: 'POST', body: JSON.stringify({ on: !!on }) }).catch(() => {});
    // The parent page (html/script.js) closes the panel on Escape too, for
    // the case where keyboard focus sits on IT rather than on this iframe.
    // It must hold the same guard, or the Esc that cancels a key capture
    // closes the whole panel from there.
    try {
        if (window.parent && window.parent !== window) {
            window.parent.postMessage({ action: 'apex:escGuard', on: !!on }, '*');
        }
    } catch (_) {}
}

// Keyboard focus. SetNuiFocus hands the keyboard to CEF, but CEF gives it
// to no document until something is clicked — and this panel is an iframe,
// so after a key-opened panel (F6, no click) or another NUI closing on top
// of us the keys go to the parent page and typing in the panel does
// nothing. Claim it on open and whenever Lua tells us it took the NUI
// focus back (panel:refocus), restoring the field that had it.
function claimPanelKeyboardFocus() {
    try { window.focus(); } catch (_) {}
    const root = $('#ap-root');
    if (!root) return;
    if (!root.hasAttribute('tabindex')) root.setAttribute('tabindex', '-1');
    requestAnimationFrame(() => {
        const ae = document.activeElement;
        const target = (ae && ae !== document.body && ae !== document.documentElement && root.contains(ae)) ? ae : root;
        try { target.focus({ preventScroll: true }); } catch (_) { try { target.focus(); } catch (_) {} }
    });
}
document.addEventListener('keyup', e => {
    if (e.key === 'Escape' && !state.escGuard && !$('#ap-root').classList.contains('hidden')) {
        fetch(`https://${NUI}/panel:close`, { method: 'POST', body: '{}' });
    }
});

// ── Nav wiring ───────────────────────────────────────────
$$('.ap-nav-item').forEach(b => b.addEventListener('click', () => setPage(b.dataset.page)));
$('#ap-close').addEventListener('click', () =>
    fetch(`https://${NUI}/panel:close`, { method: 'POST', body: '{}' }));

/* ============================================================
   HOME — map + cards
   ============================================================ */

// GTA V map (gtamap.xyz tiles + CRS Simple) — same setup as gfx_mdt.
const CENTER_X = 117.3, CENTER_Y = 172.8, SCALE_X = 0.02072, SCALE_Y = 0.0205;

// Map style catalogue. Each entry lists one or more tileset URL
// templates (tried in order — first one that serves valid tiles wins)
// plus an optional CSS filter applied on top. All URLs share the
// gtamap.xyz CRS so markers stay aligned across styles.
//
// Sources used (all public, no API key):
//   • gtamap.xyz             — Atlas (always available)
//   • gta5.dev/maps          — Satellite tiles published by gta5.dev
//   • github.com/dexyfex     — additional GTA tile sets mirrored on jsDelivr
const MAP_STYLES = {
    atlas: {
        urls: ['https://www.gtamap.xyz/mapStyles/styleAtlas/{z}/{x}/{y}.jpg']
    },
    satellite: {
        urls: [
            'https://gta5.dev/maps/satellite/{z}/{x}/{y}.png',
            'https://cdn.jsdelivr.net/gh/dexyfex/CodeWalker@master/CodeWalker/Resources/MapResources/MinimapSatellite/{z}/{x}/{y}.png'
        ]
    },
    street: {
        urls: ['https://gta5.dev/maps/streets/{z}/{x}/{y}.png']
    },
    painted: {
        urls: ['https://gta5.dev/maps/painted/{z}/{x}/{y}.png']
    },
    // Pure-filter variants of Atlas — guaranteed to work because they
    // re-use the Atlas tileset and only change the visual look.
    dark: {
        urls: ['https://www.gtamap.xyz/mapStyles/styleAtlas/{z}/{x}/{y}.jpg'],
        filter: 'invert(0.92) hue-rotate(180deg) saturate(0.85) brightness(0.95)'
    }
};

const MAP_ERROR_TILE = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNgAAIAAAUAAeImBZsAAAAASUVORK5CYII=';

function makeTileLayer(url) {
    return L.tileLayer(url, {
        noWrap: true,
        errorTileUrl: MAP_ERROR_TILE,
        crossOrigin: true
    });
}

function applyTilePaneFilter(filter) {
    const pane = state.mapInstance && state.mapInstance.getPane('tilePane');
    if (!pane) return;
    pane.style.transition = 'filter .25s ease';
    pane.style.filter = filter || '';
}

function buildMap() {
    if (state.mapInstance) return state.mapInstance;
    const CRS = L.extend({}, L.CRS.Simple, {
        projection: L.Projection.LonLat,
        scale: z => Math.pow(2, z),
        zoom:  s => Math.log(s) / Math.LN2,
        distance: (a, b) => {
            const dx = b.lng - a.lng, dy = b.lat - a.lat;
            return Math.sqrt(dx * dx + dy * dy);
        },
        transformation: new L.Transformation(SCALE_X, CENTER_X, -SCALE_Y, CENTER_Y),
        infinite: true
    });
    const map = L.map('ap-map', {
        crs: CRS, minZoom: 3, maxZoom: 5, zoom: 4, center: [0, 0],
        zoomControl: true, preferCanvas: true,
        maxBounds: [[8000.0, -5500.0], [-8000.0, 5500.0]]
    });
    // Atlas is the only supported style now — the floating picker was
    // removed because the alternative tile sources were unreliable.
    state.mapInstance = map;
    state.mapStyle = null;
    setMapStyle('atlas');
    return map;
}

// Swap the active tile layer in-place. Tries each URL listed in the
// style's `urls` array (auto-fallback when a CDN goes down) and, if
// all of them fail, falls back to the always-available Atlas style.
function setMapStyle(name) {
    const cfg = MAP_STYLES[name];
    if (!cfg) return;
    const map = state.mapInstance;
    if (!map) return;

    // Remove any previous layer.
    if (state.mapTileLayer) {
        map.removeLayer(state.mapTileLayer);
        state.mapTileLayer = null;
    }

    // Try each URL in order with a small error budget — if too many
    // tiles fail on a URL we move on to the next, finally falling back
    // to Atlas as a last resort.
    const urls = (cfg.urls || []).slice();
    function tryNext() {
        if (urls.length === 0) {
            if (name !== 'atlas') return setMapStyle('atlas');
            return;
        }
        const url = urls.shift();
        const layer = makeTileLayer(url);
        let errs = 0;
        layer.on('tileerror', () => {
            errs++;
            if (errs >= 3) {
                map.removeLayer(layer);
                console.warn('[map] dropping unreachable tile URL: ' + url);
                tryNext();
            }
        });
        layer.addTo(map);
        state.mapTileLayer = layer;
    }
    tryNext();

    state.mapStyle = name;
    applyTilePaneFilter(cfg.filter);

    try { localStorage.setItem('ap-map-style', name); } catch (_) {}
    $$('.ap-map-style-item').forEach(b =>
        b.classList.toggle('active', b.dataset.style === name));
    $('#ap-map-style')?.classList.remove('open');
}

// Wire up the floating style picker.
document.addEventListener('click', e => {
    if (e.target.closest('#ap-map-style-btn')) {
        e.stopPropagation();
        $('#ap-map-style')?.classList.toggle('open');
        return;
    }
    const item = e.target.closest('.ap-map-style-item');
    if (item) { setMapStyle(item.dataset.style); return; }
    // Click outside closes the menu.
    if (!e.target.closest('#ap-map-style')) {
        $('#ap-map-style')?.classList.remove('open');
    }
});

// Layer registry per tab so we can swap them cleanly.
state.mapLayers = { players: [], heatmap: null, zones: [] };

function clearMapLayers() {
    const map = state.mapInstance;
    if (!map) return;
    state.mapLayers.players.forEach(m => map.removeLayer(m));
    state.mapLayers.zones.forEach(z => map.removeLayer(z));
    if (state.mapLayers.heatmap) map.removeLayer(state.mapLayers.heatmap);
    state.mapLayers = { players: [], heatmap: null, zones: [] };
}

// Per-type colours so the operator can tell roles apart on the
// map at a glance. The class on the blip div drives the colour via
// CSS variables defined alongside `.ap-blip`.
const MAP_JOB_COLORS = {
    police:   '#4E9CE5',
    sheriff:  '#4E9CE5',
    bcso:     '#4E9CE5',
    state:    '#4E9CE5',
    ambulance:'#E5564B',
    medic:    '#E5564B',
    ems:      '#E5564B',
    doctor:   '#E5564B',
    mechanic: '#E5A93C',
    taxi:     '#F0B429',
    cardealer:'#A66DF0',
    realestate:'#A66DF0',
    judge:    '#A66DF0',
    lawyer:   '#A66DF0',
    reporter: '#34C77B',
    unemployed:'#7C7C82'
};
function colourForPlayer(p) {
    if (p.isStaff)            return '#A66DF0';
    const c = MAP_JOB_COLORS[(p.job || '').toLowerCase()];
    if (c) return c;
    return brandColor();
}
function filterPlayers(players) {
    const mode = $('#map-filter-mode')?.value || 'all';
    const job  = ($('#map-filter-job')?.value || '').toLowerCase();
    return (players || []).filter(p => {
        if (mode === 'staff')           return !!p.isStaff;
        if (mode === 'vehicles')        return !!p.vehicle;
        if (mode === 'players_vehicles') return true;     // we render both layers below
        if (mode === 'job')             return job && (p.job || '').toLowerCase() === job;
        return true;
    });
}

// Build a single Leaflet marker for one player at one coord set,
// optionally as a vehicle pin (car icon) rather than a player dot.
function buildPlayerMarker(p, opts) {
    const col = colourForPlayer(p);
    const isVehicle = !!opts?.vehicle;
    const coords = isVehicle && p.vehicleCoords ? p.vehicleCoords : p.coords;
    const icon = isVehicle
        ? `<div class="ap-blip ap-blip-veh" style="--blip:${col}" title="${escapeHTML(p.name)} (${escapeHTML(p.vehicle || '?')})"><i class="fa-solid fa-car"></i></div>`
        : `<div class="ap-blip" style="--blip:${col}" title="${escapeHTML(p.name)}${p.job ? ' · ' + p.job : ''}"></div>`;
    const m = L.marker([coords.y, coords.x], {
        icon: L.divIcon({ className: 'ap-blip-icon', html: icon, iconSize: [16, 16] })
    });
    const jobLine = p.job ? `<small>Job: <b>${escapeHTML(p.job)}</b></small><br>` : '';
    const vehLine = p.vehicle ? `<small>Vehicle: <b>${escapeHTML(p.vehicle)}</b></small><br>` : '';
    const staffLine = p.isStaff ? `<small style="color:#A66DF0"><i class="fa-solid fa-shield-halved"></i> Staff member</small><br>` : '';
    m.bindPopup(
        `<strong>${escapeHTML(p.name)}</strong><br><small>ID ${p.id}</small><br>
         ${staffLine}${jobLine}${vehLine}
         <button class="ap-btn ghost" onclick="window._tp(${p.id})">Teleport</button>
         <button class="ap-btn primary" onclick="window._rev(${p.id})">Revive</button>`
    );
    return m;
}

function drawPlayers(players) {
    const map = buildMap();
    const list = filterPlayers(players);
    const mode = $('#map-filter-mode')?.value || 'all';
    const markers = [];
    list.forEach(p => {
        if (mode === 'vehicles') {
            // Vehicle-only: one marker per player at vehicle coords (or
            // ped coords as fallback). If they're not in a vehicle and
            // we have no vehicleCoords either, still drop a car pin so
            // the operator can see who matches the filter.
            markers.push(buildPlayerMarker(p, { vehicle: true }));
        } else if (mode === 'players_vehicles') {
            // Combined: always a player dot, plus a separate car pin
            // when the player is currently in a vehicle. Two markers
            // share the same Leaflet group so the layer toggle clears
            // both at once.
            markers.push(buildPlayerMarker(p, { vehicle: false }));
            if (p.vehicleCoords) {
                markers.push(buildPlayerMarker(p, { vehicle: true }));
            }
        } else {
            markers.push(buildPlayerMarker(p, { vehicle: false }));
        }
    });
    markers.forEach(m => m.addTo(map));
    state.mapLayers.players = markers;
    return;
}

// Stale code path kept for safety — older callers might still use it.
function _drawPlayersLegacy(players) {
    const map = buildMap();
    const list = filterPlayers(players);
    const mode = $('#map-filter-mode')?.value || 'all';
    state.mapLayers.players = list.map(p => {
        const col = colourForPlayer(p);
        const coords = (mode === 'vehicles' && p.vehicleCoords) ? p.vehicleCoords : p.coords;
        const isVehiclePin = (mode === 'vehicles');
        const icon = isVehiclePin
            ? `<div class="ap-blip ap-blip-veh" style="--blip:${col}" title="${escapeHTML(p.name)} (${escapeHTML(p.vehicle || 'on foot')})"><i class="fa-solid fa-car"></i></div>`
            : `<div class="ap-blip" style="--blip:${col}" title="${escapeHTML(p.name)}${p.job ? ' · ' + p.job : ''}"></div>`;
        const m = L.marker([coords.y, coords.x], {
            icon: L.divIcon({
                className: 'ap-blip-icon',
                html: icon,
                iconSize: [16, 16]
            })
        });
        const jobLine = p.job ? `<small>Job: <b>${escapeHTML(p.job)}</b></small><br>` : '';
        const vehLine = p.vehicle ? `<small>Vehicle: <b>${escapeHTML(p.vehicle)}</b></small><br>` : '';
        const staffLine = p.isStaff ? `<small style="color:#A66DF0"><i class="fa-solid fa-shield-halved"></i> Staff member</small><br>` : '';
        m.bindPopup(
            `<strong>${escapeHTML(p.name)}</strong><br><small>ID ${p.id}</small><br>
             ${staffLine}${jobLine}${vehLine}
             <button class="ap-btn ghost" onclick="window._tp(${p.id})">Teleport</button>
             <button class="ap-btn primary" onclick="window._rev(${p.id})">Revive</button>`
        );
        m.addTo(map);
        return m;
    });
}

// Rebuild the "By job" dropdown from the current player list.
function populateMapJobFilter() {
    const sel = $('#map-filter-job');
    if (!sel || !state.home) return;
    const jobs = Array.from(new Set((state.home.players || [])
        .map(p => p.job).filter(Boolean))).sort();
    const prev = sel.value;
    sel.innerHTML = '<option value="">Pick a job…</option>' +
        jobs.map(j => `<option ${j === prev ? 'selected' : ''}>${escapeHTML(j)}</option>`).join('');
}
document.addEventListener('change', e => {
    if (e.target?.id === 'map-filter-mode') {
        $('#map-filter-job').style.display = e.target.value === 'job' ? '' : 'none';
        populateMapJobFilter();
        if (state.home) refreshMapMarkers(state.home.players);
    }
    if (e.target?.id === 'map-filter-job' && state.home) {
        refreshMapMarkers(state.home.players);
    }
});

function drawHeatmap(players) {
    const map = buildMap();
    // Density-grid heatmap implemented without external plugin.
    // Bucket by 200-unit cells, draw a translucent circle per bucket.
    const cells = {};
    (players || []).forEach(p => {
        const cx = Math.round(p.coords.x / 200) * 200;
        const cy = Math.round(p.coords.y / 200) * 200;
        const k = cx + ':' + cy;
        cells[k] = (cells[k] || { x: cx, y: cy, n: 0 });
        cells[k].n += 1;
    });
    const group = L.layerGroup();
    Object.values(cells).forEach(c => {
        const intensity = Math.min(1, c.n / 5); // 5+ players in a cell = max
        const _bc = brandColor();
        L.circle([c.y, c.x], {
            radius: 90 + intensity * 80,
            color: _bc,
            weight: 1,
            fillColor: _bc,
            fillOpacity: 0.10 + intensity * 0.35
        }).addTo(group);
    });
    group.addTo(map);
    state.mapLayers.heatmap = group;
}

async function drawZones() {
    const map = buildMap();
    const blips = await callback('blips') || [];
    state.mapLayers.zones = blips.map(b => {
        const circle = L.circle([b.y, b.x], {
            radius: 60,
            color: '#E5A93C',
            weight: 2,
            fillColor: '#E5A93C',
            fillOpacity: 0.18
        });
        circle.bindPopup(`<strong>${b.label}</strong><br><small>${b.category}</small>`);
        circle.addTo(map);
        return circle;
    });
}

async function setMapTab(tab) {
    state.mapTab = tab;
    $$('[data-map-tab]').forEach(b => b.classList.toggle('active', b.dataset.mapTab === tab));
    clearMapLayers();
    if (!state.home) return;
    if (tab === 'players')      drawPlayers(state.home.players);
    else if (tab === 'heatmap') drawHeatmap(state.home.players);
    else if (tab === 'zones')   await drawZones();
}

// Leaflet caches the container size when the map is first created
// and stops rendering tiles correctly if the container was 0×0 or
// in a hidden flex item at that moment. We poke it a few times on
// staggered timers so it picks up the real size as the layout
// finishes settling — much more robust than a single setTimeout.
function invalidateMapSize() {
    if (!state.mapInstance) return;
    try { state.mapInstance.invalidateSize({ animate: false }); } catch (_) {}
}
function invalidateMapSizeMulti() {
    // Fire on the next animation frame, then again at 50/150/400/800 ms.
    // Covers: first paint, post-flexbox-settle, post-image-load, and
    // tab-switch races.
    requestAnimationFrame(invalidateMapSize);
    [50, 150, 400, 800].forEach(t => setTimeout(invalidateMapSize, t));
}

function refreshMapMarkers(players) {
    buildMap();
    clearMapLayers();
    const tab = state.mapTab || 'players';
    if (tab === 'players')      drawPlayers(players);
    else if (tab === 'heatmap') drawHeatmap(players);
    else if (tab === 'zones')   drawZones();
    invalidateMapSizeMulti();
}

// Wire map tabs once.
$$('[data-map-tab]').forEach(b => b.addEventListener('click', () => setMapTab(b.dataset.mapTab)));

window._tp  = (id) => fire('teleportTo', id);
window._rev = (id) => fire('revivePlayer', id);

let homeTicker = null;
function startHomeTicker() {
    if (homeTicker) return;
    homeTicker = setInterval(() => {
        if (state.page !== 'home' || !state.home) return;
        // Vehicle delete countdown.
        if (typeof state.home.vehicleDelete?.in_ === 'number') {
            state.home.vehicleDelete.in_ = Math.max(0, state.home.vehicleDelete.in_ - 1);
            const s = state.home.vehicleDelete.in_;
            const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), sec = s % 60;
            $('#vd-countdown').textContent = `${String(h).padStart(2,'0')}h ${String(m).padStart(2,'0')}m ${String(sec).padStart(2,'0')}s`;
        }
        // Clock auto-advance every 30s (matches default server tick of 2 min/sec).
        if (!state.home.time.paused) {
            state.home._clockAccum = (state.home._clockAccum || 0) + 1;
            if (state.home._clockAccum >= 30) {
                state.home._clockAccum = 0;
                let total = state.home.time.hour * 60 + state.home.time.minute + 1;
                total = total % (24 * 60);
                state.home.time.hour   = Math.floor(total / 60);
                state.home.time.minute = total % 60;
                $('#st-clock').textContent =
                    `${String(state.home.time.hour).padStart(2,'0')}:${String(state.home.time.minute).padStart(2,'0')}`;
            }
        }
    }, 1000);
}

async function loadHome() {
    const data = await callback('home');
    if (!data) return;
    state.home = data;
    startHomeTicker();
    startHomeStatsTicker();    // KPIs + chart + alerts poller

    // Map
    buildMap();
    populateMapJobFilter();
    refreshMapMarkers(data.players);
    invalidateMapSizeMulti();   // extra safety on first open

    // First KPI render uses the players data we already have so the
    // tiles aren't blank while the dedicated stats callback runs.
    renderHomeKpis({
        players:    data.players?.length ?? 0,
        maxSlots:   data.maxSlots,
        staff:      (data.players || []).filter(p => p.isStaff).length
    });
    refreshHomeStats();      // fire the deeper stats callback right away

    // KPI cards
    const fmtTime = s => {
        const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), sec = s % 60;
        return `${String(h).padStart(2, '0')}h ${String(m).padStart(2, '0')}m ${String(sec).padStart(2, '0')}s`;
    };
    $('#vd-countdown').textContent = fmtTime(data.vehicleDelete.in_);
    $('#st-clock').textContent = `${String(data.time.hour).padStart(2, '0')}:${String(data.time.minute).padStart(2, '0')}`;
    applyWeatherUI(data.weather.current);

    // Latest players — show Steam avatar image when available, otherwise
    // a letter fallback. Tagged with data-license so panel:avatarReady
    // can patch it in-place when the server resolves the Steam image.
    const latest = $('#home-latest');
    latest.innerHTML = '';
    const players = (data.players || []).slice(0, 14);
    if (players.length === 0) {
        const empty = document.createElement('div');
        empty.className = 'ap-empty-mini';
        empty.textContent = 'No players online';
        latest.appendChild(empty);
    } else {
        players.forEach(p => {
            const div = document.createElement('div');
            div.className = 'ap-latest-av ap-av';
            div.title = `${p.name} (#${p.id})`;
            if (p.license) div.setAttribute('data-license', p.license);
            // Prefer cached URL (might be fresher than what the server
            // bundled in this response).
            const url = (p.license && avatarCache.get(p.license)) || p.avatar;
            if (url) {
                div.classList.add('has-img');
                div.style.backgroundImage = `url(${JSON.stringify(url)})`;
                div.style.backgroundSize  = 'cover';
                div.style.backgroundPosition = 'center';
                div.dataset.avatarPainted = '1';
                if (p.license) rememberAvatar(p.license, url);
            } else {
                div.innerHTML = `<span class="ap-av-fallback">${(p.name || '?').substring(0, 1).toUpperCase()}</span>`;
            }
            div.addEventListener('click', () => {
                setPage('players');
                // Wait for the page to load its list, then highlight + open
                // the full profile (re-uses the Players page detail panel
                // with every available action).
                setTimeout(() => selectPlayer(p.id), 180);
            });
            latest.appendChild(div);
        });
    }
}

/* Map a GTA weather code to an icon class + a friendly label. */
const WX_MAP = {
    EXTRASUNNY: { icon: 'fa-sun',                 label: 'Extra Sunny' },
    CLEAR:      { icon: 'fa-cloud-sun',           label: 'Clear' },
    CLOUDS:     { icon: 'fa-cloud',               label: 'Clouds' },
    OVERCAST:   { icon: 'fa-cloud-meatball',      label: 'Overcast' },
    RAIN:       { icon: 'fa-cloud-showers-heavy', label: 'Rain' },
    THUNDER:    { icon: 'fa-cloud-bolt',          label: 'Thunder' },
    FOGGY:      { icon: 'fa-smog',                label: 'Foggy' },
    SNOW:       { icon: 'fa-snowflake',           label: 'Snow' },
    BLIZZARD:   { icon: 'fa-icicles',             label: 'Blizzard' }
};
function applyWeatherUI(wx) {
    wx = (wx || 'CLEAR').toUpperCase();
    const cfg = WX_MAP[wx] || WX_MAP.CLEAR;
    const icon = $('#wx-head-icon');
    if (icon) {
        // Swap only the FontAwesome glyph class — keep every other class
        // (including any future utility classes) so the CSS brand styling
        // continues to apply.
        [...icon.classList].forEach(c => { if (c.startsWith('fa-') && c !== 'fa-solid') icon.classList.remove(c); });
        icon.classList.add('fa-solid', cfg.icon);
    }
    const state = $('#wx-state'); if (state) state.textContent = cfg.label;
    const sel = $('#wx-select'); if (sel) sel.value = wx;
    $$('.ap-wx-chip').forEach(b => b.classList.toggle('active', b.dataset.wx === wx));
}

/* ============================================================
   HOME — KPI tiles + chart + alerts (server stats poller)
   ============================================================ */
state.homeStats = null;
let homeStatsTicker = null;
function startHomeStatsTicker() {
    if (homeStatsTicker) return;
    if (prefRead('auto_refresh') <= 0) return;   // manual only
    homeStatsTicker = setInterval(() => {
        if (state.page !== 'home') return;
        refreshHomeStats();
    }, Math.max(5, prefRead('auto_refresh')) * 1000);
}

// Applied when the interval changes so it takes effect immediately
// rather than on the next panel open.
function restartHomeStatsTicker() {
    if (homeStatsTicker) { clearInterval(homeStatsTicker); homeStatsTicker = null; }
    startHomeStatsTicker();
}

async function refreshHomeStats() {
    const data = await callback('homeStats') || null;
    if (!data) return;
    state.homeStats = data;
    renderHomeKpis(data);
}

function renderHomeKpis(s) {
    if (!s) return;
    const setK = (id, val) => { const el = $('#' + id); if (el) el.textContent = val; };
    setK('kpi-players',   `${s.players ?? 0} / ${s.maxSlots ?? '∞'}`);
    setK('kpi-staff',      String(s.staff ?? 0));
    setK('kpi-new-today',  String(s.newToday ?? 0));
    setK('kpi-mem',        s.memMB != null ? Math.round(s.memMB) + ' MB' : '—');
}

$('#vd-update').addEventListener('click', () => { fire('vehicleDeleteUpdate'); loadHome(); });
$('#st-update').addEventListener('click', () => {
    // Update = pop the editor and let the staffer set HH:MM directly.
    const current = $('#st-clock').textContent || '12:00';
    promptModal('Set server time', 'HH:MM', current, val => {
        const [h, m] = (val || '').split(':').map(n => parseInt(n, 10));
        if (Number.isFinite(h) && Number.isFinite(m)) {
            fire('setTime', h, m);
            $('#st-clock').textContent = `${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}`;
        }
    });
});
// Clicking the clock value itself does the same thing.
$('#st-clock').style.cursor = 'pointer';
$('#st-clock').addEventListener('click', () => $('#st-update').click());

// Weather chips — click to apply the weather instantly. The
// previous Apply button + dropdown were removed; chips ARE the UI.
document.addEventListener('click', e => {
    const chip = e.target.closest('.ap-wx-chip');
    if (!chip) return;
    const wx = chip.dataset.wx;
    const hidden = $('#wx-select');
    if (hidden) hidden.value = wx;
    applyWeatherUI(wx);
    fire('setWeather', wx);
    if (state.home && state.home.weather) state.home.weather.current = wx;
});
$('#home-tp-id-btn').addEventListener('click', () => {
    const id = parseInt($('#home-tp-id').value, 10);
    if (id) fire('teleportTo', id);
});
$('#home-revive-circle').addEventListener('click', async () => {
    const data = await callback('home');
    (data?.players || []).forEach(p => fire('revivePlayer', p.id));
});

/* ============================================================
   PLAYERS
   ============================================================ */
async function loadPlayers(q = '') {
    state.players = await callback('players', q) || [];
    renderPlayerList();
}

// Render the player list incrementally. Existing rows keep their avatar
// nodes (and any background-image already patched by panel:avatarReady)
// so re-rendering on selection no longer wipes the picture. We also
// preserve scroll position by only diffing what changed.
function renderPlayerList() {
    const list = $('#players-list');
    if (!list) return;
    const prevScroll = list.scrollTop;
    const existing = new Map();
    list.querySelectorAll('.ap-player-row').forEach(r => existing.set(Number(r.dataset.id), r));

    const frag = document.createDocumentFragment();
    state.players.forEach(p => {
        let row = existing.get(p.id);
        if (!row) {
            row = document.createElement('div');
            row.className = 'ap-player-row';
            row.dataset.id = p.id;
            row.innerHTML = `
                ${avatar(p.avatar, p.name, '', p.license)}
                <div class="ap-player-meta">
                    <span class="ap-player-name">${escapeHTML(p.name)}</span>
                    <span class="ap-player-sub">
                        <span class="ap-list-item-id">#${p.id}</span>
                    </span>
                </div>
                <i class="fa-solid fa-chevron-right" style="font-size:10px;color:var(--text-mute)"></i>`;
            row.addEventListener('click', () => selectPlayer(p.id));
        } else {
            // Row already exists — only touch what may have changed.
            existing.delete(p.id);
            const av = row.querySelector('.ap-av');
            if (av && !av.classList.contains('has-img')) {
                // Use whichever URL we have: the response or the cache.
                const url = p.avatar || (p.license && avatarCache.get(p.license));
                if (url) {
                    if (p.license) rememberAvatar(p.license, url);
                    av.style.backgroundImage = `url(${JSON.stringify(url)})`;
                    av.style.backgroundSize = 'cover';
                    av.style.backgroundPosition = 'center';
                    av.classList.add('has-img');
                    av.innerHTML = '';
                    av.dataset.avatarPainted = '1';
                }
            }
        }
        row.classList.toggle('selected', state.selectedPlayer === p.id);
        frag.appendChild(row);
    });
    // Drop rows for players that disappeared.
    existing.forEach(r => r.remove());
    list.innerHTML = '';
    list.appendChild(frag);
    // Defensive final pass: paint every avatar from the cache regardless
    // of whether the helper had the URL at the moment the markup was
    // generated. This mirrors how the sidebar paints `#ap-me-avatar`
    // exactly once and the picture never disappears.
    list.querySelectorAll('[data-license]').forEach(el => {
        el.dataset.avatarPainted = '0';
        paintAvatarNode(el);
    });
    list.scrollTop = prevScroll;
}

async function selectPlayer(id) {
    state.selectedPlayer = id;
    const detail = $('#players-detail');
    if (detail) {
        detail.innerHTML = `<div class="ap-empty">
            <i class="fa-solid fa-spinner fa-spin"></i>
            <div style="margin-top:6px">Loading player…</div>
        </div>`;
    }
    // Just update the highlight — DO NOT reload the full list (that
    // destroys the avatar nodes and produces the flicker the user saw).
    document.querySelectorAll('#players-list .ap-player-row').forEach(r => {
        r.classList.toggle('selected', Number(r.dataset.id) === id);
    });
    const d = await callback('playerDetail', id);
    if (!d) {
        if (detail) detail.innerHTML = `<div class="ap-empty">
            <i class="fa-solid fa-triangle-exclamation" style="color:var(--warning)"></i>
            <div style="margin-top:6px">Could not load player detail (no permission or player left)</div>
        </div>`;
        return;
    }

    const fw = d.framework || {};
    const ci = fw.charinfo || {};
    const accountsHTML = (fw.accounts || []).length
        ? fw.accounts.map(a => `
            <div class="ap-pd-kv">
                <span class="ap-pd-kv-key">${escapeHTML(a.name)}</span>
                <span class="ap-pd-kv-val">$${(a.amount || 0).toLocaleString()}</span>
            </div>`).join('')
        : '<small class="ap-muted">No accounts</small>';

    // Character information is rendered as a grid of small "stat
    // chips" — easier to scan than the old key/value rows and every
    // chip's value is click-to-copy.
    const charFacts = [];
    if (fw.framework === 'qb') {
        const fullName = ((ci.firstname || '') + ' ' + (ci.lastname || '')).trim();
        charFacts.push({ label: 'Name',         icon: 'fa-id-card',  value: fullName || '—' });
        charFacts.push({ label: 'Character ID', icon: 'fa-hashtag',  value: fw.cid || '—', mono: true });
        if (ci.birthdate) charFacts.push({ label: 'Birthday', icon: 'fa-cake-candles', value: ci.birthdate });
        if (ci.phone)     charFacts.push({ label: 'Phone',    icon: 'fa-phone',        value: ci.phone, mono: true });
        const jobLabel = (fw.job?.label || fw.job?.name || '—') + (fw.job?.grade?.name ? ' · ' + fw.job.grade.name : '');
        charFacts.push({ label: 'Job', icon: 'fa-briefcase', value: jobLabel });
        if (fw.gang?.name) charFacts.push({ label: 'Gang', icon: 'fa-users-rectangle', value: fw.gang.label || fw.gang.name });
    } else {
        charFacts.push({ label: 'Identifier', icon: 'fa-fingerprint', value: fw.cid || '—', mono: true });
        const jobLabel = (fw.job?.label || fw.job?.name || '—') + (fw.job?.grade_label ? ' · ' + fw.job.grade_label : '');
        charFacts.push({ label: 'Job', icon: 'fa-briefcase', value: jobLabel });
    }
    // Account-level stats (registered date + playtime). Both come
    // from apex_player_stats via the playerDetail callback.
    if (d.first_seen) charFacts.push({ label: 'Registered', icon: 'fa-calendar-plus', value: d.first_seen });
    if (d.last_login) charFacts.push({ label: 'Last login', icon: 'fa-right-to-bracket', value: d.last_login });
    if (d.playtime != null) {
        const total = Number(d.playtime) || 0;
        const h = Math.floor(total / 3600), m = Math.floor((total % 3600) / 60);
        charFacts.push({ label: 'Playtime', icon: 'fa-stopwatch',
            value: (h > 0 ? h + 'h ' : '') + m + 'm' });
    }

    const charHTML = `<div class="ap-pd-chips">
        ${charFacts.map(f => `
            <button type="button" class="ap-pd-chip${f.mono ? ' mono' : ''}"
                    data-copy="${escapeHTML(String(f.value))}"
                    title="Click to copy">
                <i class="fa-solid ${f.icon}"></i>
                <div class="ap-pd-chip-meta">
                    <span class="ap-pd-chip-label">${escapeHTML(f.label)}</span>
                    <span class="ap-pd-chip-val">${escapeHTML(String(f.value))}</span>
                </div>
            </button>`).join('')}
    </div>`;

    const ids = d.ids || {};
    const idEntries = [...new Set(Object.entries(ids).map(([k, v]) => String(v)))];
    // Include the primary license as a chip too, so it sits with the
    // other identifiers (consistent style) instead of a separate line.
    if (d.license && !idEntries.includes(String(d.license))) idEntries.push(String(d.license));
    const idChips = idEntries.map(v =>
        `<div class="ap-id-row">
            <code>${escapeHTML(v)}</code>
            <button type="button" class="ap-id-copy" data-copy="${escapeHTML(v)}" title="Copy"><i class="fa-solid fa-copy"></i></button>
        </div>`).join('');

    const hp     = Number.isFinite(d.health) ? d.health : 0;
    const arm    = Number.isFinite(d.armor)  ? d.armor  : 0;
    const hpPct  = Math.min(100, Math.max(0, hp));
    const armPct = Math.min(100, Math.max(0, arm));

    // Render the flag badge if the player has one set.
    const FLAG_META = {
        none:       { label: 'None',       color: '#7C7C82', icon: 'fa-circle' },
        suspicious: { label: 'Suspicious', color: '#E5A93C', icon: 'fa-triangle-exclamation' },
        trusted:    { label: 'Trusted',    color: '#34C77B', icon: 'fa-shield-halved' },
        streamer:   { label: 'Streamer',   color: '#A66DF0', icon: 'fa-video' },
        vip:        { label: 'VIP',        color: '#F0B429', icon: 'fa-crown' },
        flagged:    { label: 'Flagged',    color: '#E5564B', icon: 'fa-flag' }
    };
    const flagKey   = (d.flag && d.flag.flag) || 'none';
    const flagMeta  = FLAG_META[flagKey] || FLAG_META.none;
    const flagBadge = flagKey === 'none'
        ? `<button class="ap-pd-flag-badge none" onclick="window._setFlag(${d.id})"><i class="fa-solid fa-flag"></i> Set flag</button>`
        : `<button class="ap-pd-flag-badge" style="--flag-color:${flagMeta.color}" onclick="window._setFlag(${d.id})">
              <i class="fa-solid ${flagMeta.icon}"></i> ${escapeHTML(flagMeta.label)}
              ${d.flag && d.flag.note ? `<small>· ${escapeHTML(d.flag.note)}</small>` : ''}
           </button>`;

    $('#players-detail').innerHTML = `
        <div class="ap-pd-header">
            ${avatar(d.avatar, d.name, 'xl square', d.license)}
            <div class="ap-pd-headinfo">
                <h3>${escapeHTML(d.name)}</h3>
                <div class="ap-pd-pills">
                    <span class="ap-pd-pill">Server ID: <b>${d.id}</b></span>
                    <span class="ap-pd-pill">Ping: <b>${d.ping}ms</b></span>
                    ${d.vehicle ? `<span class="ap-pd-pill"><i class="fa-solid fa-car"></i> <b>${escapeHTML(d.vehicle)}</b></span>` : ''}
                    <span class="ap-pd-pill warn">Warnings: <b>${(d.warnings||[]).length}</b></span>
                    <span class="ap-pd-pill error">Bans: <b>${(d.bans||[]).length}</b></span>
                </div>
                <div class="ap-pd-flag-row">${flagBadge}</div>
            </div>
        </div>

        <div class="ap-pd-stats">
            <div class="ap-pd-stat">
                <div class="ap-pd-stat-head"><span>Health</span><span>${hpPct}/100</span></div>
                <div class="ap-pd-stat-val">${hp}</div>
                <div class="ap-pd-bar"><div style="width:${hpPct}%;background:var(--success)"></div></div>
            </div>
            <div class="ap-pd-stat">
                <div class="ap-pd-stat-head"><span>Armor</span><span>${armPct}/100</span></div>
                <div class="ap-pd-stat-val">${arm}</div>
                <div class="ap-pd-bar"><div style="width:${armPct}%;background:var(--info)"></div></div>
            </div>
        </div>

        <div class="ap-pd-grid">
            <div class="ap-pd-block">
                <div class="ap-pd-block-title">Character Information</div>
                ${charHTML}
            </div>
            <div class="ap-pd-block">
                <div class="ap-pd-block-title">Accounts</div>
                ${accountsHTML}
            </div>
            <div class="ap-pd-block">
                <div class="ap-pd-block-title">Identifiers</div>
                <div class="ap-pd-identifiers">${idChips || '<small class="ap-muted">None</small>'}</div>
            </div>
        </div>

        <div class="ap-pd-actions-wrap">
            <div class="ap-pd-actions-group">
                <div class="ap-pd-actions-title"><i class="fa-solid fa-bolt"></i> Interactions</div>
                <div class="ap-pd-actions">
                    ${panelCan('spectate') ? `
                    <button class="ap-pd-action" data-tone="brand" onclick="window._spec(${d.id})"><i class="fa-solid fa-eye"></i> Spectate</button>
                    <button class="ap-pd-action" data-tone="brand" onclick="window._watch(${d.id})"><i class="fa-solid fa-display"></i> Watch screen</button>` : ''}
                    <button class="ap-pd-action" data-tone="brand" onclick="window._dm(${d.id})"><i class="fa-solid fa-message"></i> DM</button>
                    <button class="ap-pd-action" data-tone="brand" onclick="window._setFlag(${d.id})"><i class="fa-solid fa-flag"></i> Set Flag</button>
                    ${panelCan('spectate') ? `
                    <button class="ap-pd-action" data-tone="brand" onclick="window._screenshot(${d.id})"><i class="fa-solid fa-camera"></i> Screenshot</button>` : ''}
                    <button class="ap-pd-action" data-tone="brand" onclick="window._copyLicense('${escapeHTML(d.license || '')}')"><i class="fa-solid fa-copy"></i> Copy License</button>
                </div>
            </div>

            <div class="ap-pd-actions-group">
                <div class="ap-pd-actions-title"><i class="fa-solid fa-location-arrow"></i> Movement</div>
                <div class="ap-pd-actions">
                    <button class="ap-pd-action" data-tone="info" onclick="window._tp(${d.id})"><i class="fa-solid fa-location-arrow"></i> Teleport</button>
                    <button class="ap-pd-action" data-tone="info" onclick="window._goto(${d.id})"><i class="fa-solid fa-route"></i> Go to</button>
                    <button class="ap-pd-action" data-tone="info" onclick="window._bring(${d.id})"><i class="fa-solid fa-person-arrow-down-to-line"></i> Bring</button>
                    <button class="ap-pd-action" data-tone="info" onclick="window._freeze(${d.id})"><i class="fa-solid fa-snowflake"></i> Freeze</button>
                    <button class="ap-pd-action" data-tone="info" onclick="window._unfreeze(${d.id})"><i class="fa-solid fa-fire"></i> Unfreeze</button>
                </div>
            </div>

            <div class="ap-pd-actions-group">
                <div class="ap-pd-actions-title"><i class="fa-solid fa-heart-pulse"></i> Health &amp; State</div>
                <div class="ap-pd-actions">
                    <button class="ap-pd-action" data-tone="success" onclick="window._rev(${d.id})"><i class="fa-solid fa-bed-pulse"></i> Revive</button>
                    <button class="ap-pd-action" data-tone="success" onclick="window._heal(${d.id})"><i class="fa-solid fa-heart"></i> Heal</button>
                    <button class="ap-pd-action" data-tone="success" onclick="window._setHealth(${d.id})"><i class="fa-solid fa-heart-pulse"></i> Set HP</button>
                    <button class="ap-pd-action" data-tone="success" onclick="window._setArmor(${d.id})"><i class="fa-solid fa-shield"></i> Set Armor</button>
                    <button class="ap-pd-action" data-tone="success" onclick="window._respawn(${d.id})"><i class="fa-solid fa-skull"></i> Respawn</button>
                </div>
            </div>

            <div class="ap-pd-actions-group">
                <div class="ap-pd-actions-title"><i class="fa-solid fa-coins"></i> Inventory &amp; Money</div>
                <div class="ap-pd-actions">
                    <button class="ap-pd-action" data-tone="accent" onclick="window._giveMoney(${d.id})"><i class="fa-solid fa-money-bill"></i> Give Money</button>
                    <button class="ap-pd-action" data-tone="accent" onclick="window._giveItem(${d.id})"><i class="fa-solid fa-box"></i> Give Item</button>
                    <button class="ap-pd-action" data-tone="accent" onclick="window._removeItem(${d.id})"><i class="fa-solid fa-box-archive"></i> Remove Item</button>
                    <button class="ap-pd-action" data-tone="accent" onclick="window._giveWeapon(${d.id})"><i class="fa-solid fa-gun"></i> Give Weapon</button>
                </div>
            </div>

            <div class="ap-pd-actions-group">
                <div class="ap-pd-actions-title"><i class="fa-solid fa-car"></i> Vehicle</div>
                <div class="ap-pd-actions">
                    <button class="ap-pd-action" data-tone="accent" onclick="window._giveVehicle(${d.id})"><i class="fa-solid fa-car"></i> Give Vehicle</button>
                    <button class="ap-pd-action" data-tone="accent" onclick="window._fixVehicle(${d.id})"><i class="fa-solid fa-wrench"></i> Fix Vehicle</button>
                    <button class="ap-pd-action" data-tone="accent" onclick="window._cleanVehicle(${d.id})"><i class="fa-solid fa-broom"></i> Clean Vehicle</button>
                </div>
            </div>

            <div class="ap-pd-actions-group">
                <div class="ap-pd-actions-title"><i class="fa-solid fa-gavel"></i> Moderation</div>
                <div class="ap-pd-actions">
                    <button class="ap-pd-action" data-tone="warning" onclick="window._warn(${d.id})"><i class="fa-solid fa-triangle-exclamation"></i> Warn</button>
                    <button class="ap-pd-action" data-tone="info"    onclick="window._jail(${d.id})"><i class="fa-solid fa-handcuffs"></i> Jail</button>
                    <button class="ap-pd-action" data-tone="warning" onclick="window._kick(${d.id})"><i class="fa-solid fa-door-open"></i> Kick</button>
                    <button class="ap-pd-action" data-tone="danger"  onclick="window._ban(${d.id})"><i class="fa-solid fa-gavel"></i> Ban</button>
                </div>
            </div>

            <div class="ap-pd-actions-group">
                <div class="ap-pd-actions-title"><i class="fa-solid fa-triangle-exclamation"></i> Danger zone</div>
                <div class="ap-pd-actions">
                    <button class="ap-pd-action" data-tone="danger" onclick="window._resetAccount('${escapeHTML(d.license || '')}', '${escapeHTML(d.name || '')}')">
                        <i class="fa-solid fa-rotate-left"></i> Reset account
                    </button>
                </div>
            </div>
        </div>

        <div class="ap-pd-block">
            <div class="ap-pd-block-title">Inventory (${(fw.inventory||[]).length} items)</div>
            <div class="ap-pd-inv">
                ${(fw.inventory||[]).slice(0, 24).map(it => `
                    <div class="ap-pd-inv-item" title="${escapeHTML(it.label || it.name)}">
                        <img class="ap-pd-inv-img" src="${itemImageSrc(it)}" alt=""
                             data-cands="${escapeHTML(itemImageCandidates(it).join('|'))}" data-i="0"
                             onerror="window.apxItemImgFailIcon(this,'fa-solid fa-box ap-pd-inv-fallback')">
                        <span class="ap-pd-inv-count">×${it.amount}</span>
                        <span class="ap-pd-inv-label">${escapeHTML(it.label || it.name)}</span>
                    </div>`).join('') || '<small class="ap-muted">Empty</small>'}
            </div>
        </div>

        <div class="ap-pd-block">
            <div class="ap-pd-block-title">Recent staff actions on this player</div>
            ${(d.logs || []).slice(0, 10).map(l => {
                // created_at arrives as a raw epoch (ms or s) — format it.
                let n = Number(l.created_at), ts = l.created_at;
                if (isFinite(n)) { if (n < 1e12) n *= 1000; const dt = new Date(n); if (!isNaN(dt.getTime())) ts = dt.toLocaleString(); }
                return `
                <div class="ap-pd-kv">
                    <span class="ap-pd-kv-key">${escapeHTML(String(ts))} · ${escapeHTML(l.admin)}</span>
                    <span class="ap-pd-kv-val">${escapeHTML(l.action)} ${l.details ? '· ' + escapeHTML(l.details) : ''}</span>
                </div>`;
            }).join('') || '<small class="ap-muted">None</small>'}
        </div>
    `;
    // Synchronously paint every avatar in the freshly-rendered detail
    // panel from the cache. Without this the big header avatar can
    // flash empty until the MutationObserver gets around to it.
    $('#players-detail').querySelectorAll('[data-license]').forEach(el => {
        el.dataset.avatarPainted = '0';
        paintAvatarNode(el);
    });
}
window._heal     = id => fire('healPlayer', id);
window._bring    = id => fire('bringPlayer', id);
window._freeze   = id => fire('freezePlayer', id, true);
window._kick     = id => promptModal('Kick player', 'Reason', '', r => fire('kickPlayer', id, r));
window._ban      = id => promptModal('Ban player', 'Reason', '', r =>
    promptModal('Ban player', 'Hours (or "perm")', 'perm', h => fire('banFromPanel', id, r, h)));
window._giveMoney = id => promptModal('Account', 'bank / cash / black_money', 'bank', acc =>
    promptModal('Amount', '$', '1000', amt => fire('giveMoneyTo', id, acc, amt)));
window._giveItem = id => promptModal('Item name', 'name', '', name =>
    promptModal('Amount', '#', '1', amt => fire('giveItemTo', id, name, amt)));
// Items page give-flow: the quantity is set inline in the detail
// panel; this just reads it and opens the player picker.
window._giveStep = d => { const i = document.getElementById('give-qty'); if (i) i.value = Math.max(1, (parseInt(i.value, 10) || 1) + d); };
window._giveSet  = n => { const i = document.getElementById('give-qty'); if (i) i.value = n; };
window._giveItemFlow = (itemName) => {
    const qi  = document.getElementById('give-qty');
    const qty = Math.max(1, parseInt(qi && qi.value, 10) || 1);
    pickPlayer(p => { if (p) fire('giveItemTo', p.id, itemName, qty); },
        { title: `Give ${qty}× "${itemName}" to…` });
};
window._dm = id => { setPage('chats'); setTimeout(() => Chat.openDM(id), 200); };
// In-game spectate: the panel closes and the camera follows the player.
// This button used to open a screen stream on the Monitoring page, which
// is not what "Spectate" means to anyone; that is "Watch screen" now.
window._spec = id => {
    if (!panelCan('spectate')) return showToast(NO_WATCH, 'error');
    fire('spectatePlayer', id);
};
// Takes the id only. The name used to travel inside the onclick as
// '${escapeHTML(name)}', and the attribute decodes &#39; back to a quote,
// so any name with an apostrophe broke the button with a syntax error.
window._watch = id => {
    if (!panelCan('spectate')) return showToast(NO_WATCH, 'error');
    setPage('monitoring');
    setTimeout(() => {
        // Look up name + avatar + license from the cached player lists so
        // the monitoring tile and bottom bar can show the Steam image too.
        const cached = (state.players || []).find(p => p.id === id)
                    || (state._monPlayers || []).find(p => p.id === id);
        if (!state.monWatched.has(id)) toggleMonitor(id, cached?.name || `#${id}`, cached?.avatar, cached?.license);
    }, 200);
};
window._warn = (id) => promptModal('Warn player', 'Reason', '', r => r && fire('warnPlayer', id, r));
window._jail = (id) => promptModal('Jail player', 'Minutes', '10', m => {
    promptModal('Jail player', 'Reason', '', r => fire('jailPlayer', id, parseInt(m, 10), r));
});

// Extra actions — most piggy-back on existing server events. The ones
// without a dedicated server event fall back to a console command via
// `execCommand` (server side filters by perm).
window._goto       = id => fire('teleportTo', id);
window._unfreeze   = id => fire('freezePlayer', id, false);
window._removeItem = id => promptModal('Item name', 'name', '', name =>
    promptModal('Amount', '#', '1', amt => fire('removeItemFrom', id, name, parseInt(amt, 10) || 1)));
window._giveWeapon = id => promptModal('Weapon hash/name', 'WEAPON_PISTOL', 'WEAPON_PISTOL', w =>
    promptModal('Ammo', '#', '100', a => fire('giveWeaponTo', id, w, parseInt(a, 10) || 100)));
window._setHealth  = id => promptModal('Set health', '0–200', '200', h => fire('setHealthOf', id, parseInt(h, 10)));
window._setArmor   = id => promptModal('Set armor', '0–100', '100', a => fire('setArmorOf',  id, parseInt(a, 10)));
window._fixVehicle    = id => fire('fixVehicleOf',   id);
window._cleanVehicle  = id => fire('cleanVehicleOf', id);
window._giveVehicle   = id => promptModal('Vehicle model', 'sultanrs', 'adder', m => fire('spawnVehicleFor', id, m));
window._respawn       = id => fire('respawnPlayer',  id);
window._screenshot = (id) => {
    showToast('Capturing screenshot…', 'info');
    fire('screenshotPlayer', id);
};

// Server pushes the assembled screenshot back via NUI message.
window.addEventListener('message', e => {
    if (e.data?.action !== 'panel:screenshot') return;
    showScreenshotModal(e.data.dataUri, e.data.target, e.data.name);
});

function showScreenshotModal(dataUri, targetId, targetName) {
    const modal = $('#ap-modal');
    const body  = $('#ap-modal-body');
    const title = $('#ap-modal-title');
    title.textContent = `Screenshot · ${targetName || 'Player'} (#${targetId})`;
    body.innerHTML = `<div class="ap-screenshot-wrap">
        <img class="ap-screenshot-img" src="${dataUri}" alt="screenshot">
        <small class="ap-muted">Captured ${new Date().toLocaleTimeString()}</small>
    </div>`;
    modal.classList.remove('hidden');
    const ok = $('#ap-modal-ok'), cancel = $('#ap-modal-cancel'), close = $('#ap-modal-close');
    const newOk = ok.cloneNode(true); ok.replaceWith(newOk); newOk.textContent = 'Close';
    const newCa = cancel.cloneNode(true); cancel.replaceWith(newCa); newCa.style.display = 'none';
    const newCl = close.cloneNode(true); close.replaceWith(newCl);
    const finish = () => modal.classList.add('hidden');
    newOk.addEventListener('click', finish);
    newCl.addEventListener('click', finish);
}

// Destructive: wipes every DB row tied to this license. Asks for
// an explicit double-confirmation by requiring the operator to
// type the player's name to enable the OK button.
window._resetAccount = async (license, name) => {
    if (!license) {
        showToast('Cannot reset: no license available.', 'warning');
        return;
    }
    const modal = $('#ap-modal');
    const body  = $('#ap-modal-body');
    const title = $('#ap-modal-title');
    title.textContent = 'Reset account · DANGER';
    body.innerHTML = `
        <div class="ap-reset-warn">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <div>
                <strong>This will permanently erase the player's account.</strong>
                <p>Removes them from <code>users</code> / <code>players</code>, their characters,
                vehicles, properties, banking accounts, inventories, and every Apex panel
                record (warnings, bans, jails, flags, stats, logs). <b>This cannot be undone.</b></p>
            </div>
        </div>
        <label class="ap-form-row">
            <span>License</span>
            <input class="ap-input mono" value="${escapeHTML(license)}" readonly>
        </label>
        <label class="ap-form-row">
            <span>Type the player's name to confirm: <code>${escapeHTML(name)}</code></span>
            <input class="ap-input" id="ap-reset-confirm" placeholder="${escapeHTML(name)}">
        </label>`;
    modal.classList.remove('hidden');

    const ok = $('#ap-modal-ok'), cancel = $('#ap-modal-cancel'), close = $('#ap-modal-close');
    const newOk = ok.cloneNode(true);     ok.replaceWith(newOk);
    const newCa = cancel.cloneNode(true); cancel.replaceWith(newCa);
    const newCl = close.cloneNode(true);  close.replaceWith(newCl);
    newOk.textContent = 'Reset everything';
    newOk.classList.add('danger');
    newOk.disabled = true;

    const confirmIn = $('#ap-reset-confirm');
    confirmIn.addEventListener('input', () => {
        newOk.disabled = (confirmIn.value || '').trim().toLowerCase() !== (name || '').toLowerCase();
    });

    const finish = (commit) => {
        if (commit) {
            fire('resetAccount', license);
            showToast('Reset request sent.', 'success');
        }
        modal.classList.add('hidden');
    };
    newOk.addEventListener('click', () => finish(true));
    newCa.addEventListener('click', () => finish(false));
    newCl.addEventListener('click', () => finish(false));
    setTimeout(() => confirmIn.focus(), 50);
};

window._copyLicense   = lic => {
    try { navigator.clipboard.writeText(lic); } catch (_) {}
};

// Flag modal — staff-only quick tag (Suspicious / Trusted / VIP …)
const FLAG_OPTS = [
    { key: 'none',       label: 'Clear flag', color: '#7C7C82', icon: 'fa-circle' },
    { key: 'suspicious', label: 'Suspicious', color: '#E5A93C', icon: 'fa-triangle-exclamation' },
    { key: 'trusted',    label: 'Trusted',    color: '#34C77B', icon: 'fa-shield-halved' },
    { key: 'streamer',   label: 'Streamer',   color: '#A66DF0', icon: 'fa-video' },
    { key: 'vip',        label: 'VIP',        color: '#F0B429', icon: 'fa-crown' },
    { key: 'flagged',    label: 'Flagged',    color: '#E5564B', icon: 'fa-flag' }
];
window._setFlag = (id) => {
    const modal = $('#ap-modal');
    const body  = $('#ap-modal-body');
    const title = $('#ap-modal-title');
    if (!modal || !body) return;
    title.textContent = 'Set player flag';
    body.innerHTML = `
        <div class="ap-flag-grid">
            ${FLAG_OPTS.map(f => `
                <button class="ap-flag-opt" data-flag="${f.key}" style="--flag-color:${f.color}">
                    <i class="fa-solid ${f.icon}"></i>
                    <span>${escapeHTML(f.label)}</span>
                </button>`).join('')}
        </div>
        <label class="ap-form-row" style="margin-top:12px">
            <span>Note (optional)</span>
            <input class="ap-input" id="ap-flag-note" placeholder="Why is this flag being set?">
        </label>`;
    modal.classList.remove('hidden');

    body.querySelectorAll('.ap-flag-opt').forEach(b => {
        b.addEventListener('click', () => {
            const flag = b.dataset.flag;
            const note = ($('#ap-flag-note') && $('#ap-flag-note').value) || '';
            fire('setFlag', id, flag, note);
            modal.classList.add('hidden');
            // Refresh the player detail so the badge updates immediately.
            setTimeout(() => selectPlayer(id), 250);
        });
    });
};

$('#players-search').addEventListener('input', e => loadPlayers(e.target.value));

/* ============================================================
   MODERATION
   ============================================================ */
function setModTab(tab) {
    state.moderation.tab = tab;
    $$('[data-mod-tab]').forEach(b => b.classList.toggle('active', b.dataset.modTab === tab));
    loadModeration();
}
$$('[data-mod-tab]').forEach(b => b.addEventListener('click', () => setModTab(b.dataset.modTab)));
$('#mod-search').addEventListener('input', () => loadModeration());

async function loadModeration() {
    const q = $('#mod-search').value;
    const tab = state.moderation.tab;
    const rows = await callback(tab, q) || [];
    const thead = $('#mod-table thead');
    const tbody = $('#mod-table tbody');
    const emptyRow = (cols, label) => `<tr class="ap-empty-tr"><td colspan="${cols}" class="ap-empty-cell"><div class="ap-empty" style="padding:36px 16px;display:flex;flex-direction:column;align-items:center;justify-content:center"><i class="fa-solid fa-gavel"></i><div style="margin-top:6px">${label}</div></div></td></tr>`;
    if (tab === 'bans') {
        thead.innerHTML = `<tr><th>Player</th><th>Reason</th><th>Admin</th><th>Date</th><th>Expires</th><th>Actions</th></tr>`;
        if (!rows.length) { tbody.innerHTML = emptyRow(6, 'No bans on record'); return; }
        tbody.innerHTML = rows.map(r => {
            const expired = r.time_left !== undefined && r.time_left !== null && r.time_left <= 0;
            return `<tr>
                <td>${r.player || '—'}<br><small class="ap-muted ap-ident">${r.license || ''}</small></td>
                <td>${r.reason || ''}</td>
                <td>${r.author || ''}</td>
                <td><small>${r.created_at || ''}</small></td>
                <td>${expired ? '<span class="ap-pill expired">Expired</span>' : (r.time_left + ' s')}</td>
                <td><button class="ap-btn danger" onclick="window._unban('${r.license}')"><i class="fa-solid fa-lock-open"></i></button></td>
            </tr>`;
        }).join('');
    } else if (tab === 'warnings') {
        thead.innerHTML = `<tr><th>Player</th><th>Reason</th><th>Admin</th><th>Date</th></tr>`;
        if (!rows.length) { tbody.innerHTML = emptyRow(4, 'No warnings on record'); return; }
        tbody.innerHTML = rows.map(r => `<tr>
            <td>${r.player}<br><small class="ap-muted">${r.target}</small></td>
            <td>${r.reason}</td>
            <td>${r.admin}</td>
            <td><small>${r.created_at}</small></td>
        </tr>`).join('');
    } else {
        thead.innerHTML = `<tr><th>Player</th><th>Reason</th><th>Admin</th><th>Minutes</th><th>Status</th></tr>`;
        if (!rows.length) { tbody.innerHTML = emptyRow(5, 'No jail records'); return; }
        tbody.innerHTML = rows.map(r => `<tr>
            <td>${r.player}<br><small class="ap-muted">${r.target}</small></td>
            <td>${r.reason}</td>
            <td>${r.admin}</td>
            <td>${r.minutes}</td>
            <td>${r.released ? '<span class="ap-pill expired">Released</span>' : '<span class="ap-pill active">Active</span>'}</td>
        </tr>`).join('');
    }
}
window._unban = (lic) => fire('unban', lic).then(() => loadModeration());

/* ── Moderation: Create Ban / Warn / Jail modal ──────────
   The single "Create" button on the page adapts to the active
   tab. The modal lets the admin pick a target (online player
   from a typeahead, or a raw license string for offline) plus
   the kind-specific fields. */
function updateModCreateLabel() {
    const btn = $('#mod-create');
    if (!btn) return;
    const tab = state.moderation.tab;
    const labels = { bans: '+ Create Ban', warnings: '+ Create Warning', jails: '+ Create Jail' };
    btn.innerHTML = `<i class="fa-solid fa-plus"></i> ${labels[tab] || '+ Create'}`;
}

function openModerationModal() {
    const tab = state.moderation.tab;
    const kind = tab === 'bans' ? 'ban' : tab === 'warnings' ? 'warn' : 'jail';
    const titleText = kind === 'ban' ? 'Create ban' : kind === 'warn' ? 'Create warning' : 'Create jail sentence';

    const modal = $('#ap-modal');
    const body  = $('#ap-modal-body');
    const title = $('#ap-modal-title');
    if (!modal || !body) return;
    title.textContent = titleText;

    const durationBlock = kind === 'warn' ? '' : `
        <label class="ap-form-row">
            <span>${kind === 'ban' ? 'Duration (hours, or "perm")' : 'Duration (minutes)'}</span>
            <input class="ap-input mono" id="mod-create-duration"
                placeholder="${kind === 'ban' ? '24, 168, perm…' : '15'}"
                value="${kind === 'ban' ? '24' : '15'}">
        </label>`;

    body.innerHTML = `
        <div class="ap-mod-create-form">
            <label class="ap-form-row">
                <span>Target (online player or license)</span>
                <div class="ap-mod-target-wrap">
                    <input class="ap-input" id="mod-create-target"
                        placeholder="Type a name, ID or license:xxxx" autocomplete="off">
                    <div class="ap-mod-target-list" id="mod-create-suggest" hidden></div>
                </div>
            </label>
            ${durationBlock}
            <label class="ap-form-row">
                <span>Reason</span>
                <textarea class="ap-input" id="mod-create-reason" rows="3"
                    placeholder="${kind === 'ban' ? 'Cheating · video link…'
                                 : kind === 'warn' ? 'Verbal abuse in chat…'
                                 : 'Reckless driving, RDM, etc.'}"></textarea>
            </label>
        </div>`;
    modal.classList.remove('hidden');

    // Lightweight typeahead — calls the existing players callback.
    let resolved = null;     // { id, name, license } | null
    const tgtIn = $('#mod-create-target');
    const sugg  = $('#mod-create-suggest');
    let lastQ = '';
    const lookup = async () => {
        const q = tgtIn.value.trim();
        if (q === lastQ) return; lastQ = q;
        if (!q) { sugg.hidden = true; resolved = null; return; }
        // Direct license? bypass autocomplete.
        if (q.startsWith('license:')) {
            resolved = { license: q };
            sugg.hidden = true; return;
        }
        const list = await callback('players', q) || [];
        if (list.length === 0) { sugg.hidden = true; return; }
        sugg.innerHTML = list.slice(0, 8).map(p => `
            <div class="ap-mod-target-row" data-id="${p.id}" data-name="${escapeHTML(p.name)}" data-license="${escapeHTML(p.license || '')}">
                ${avatar(p.avatar, p.name, 'sm', p.license)}
                <div class="ap-mod-target-meta">
                    <strong>${escapeHTML(p.name)}</strong>
                    <small>#${p.id}${p.license ? ' · ' + escapeHTML(p.license) : ''}</small>
                </div>
            </div>`).join('');
        sugg.hidden = false;
        sugg.querySelectorAll('.ap-mod-target-row').forEach(row => {
            row.addEventListener('click', () => {
                resolved = {
                    id:      Number(row.dataset.id),
                    name:    row.dataset.name,
                    license: row.dataset.license
                };
                tgtIn.value = resolved.name + ' (#' + resolved.id + ')';
                sugg.hidden = true;
            });
        });
    };
    tgtIn.addEventListener('input', lookup);
    setTimeout(() => tgtIn.focus(), 50);

    // Wire modal buttons.
    const ok = $('#ap-modal-ok'), cancel = $('#ap-modal-cancel'), close = $('#ap-modal-close');
    const newOk = ok.cloneNode(true);     ok.replaceWith(newOk);
    const newCa = cancel.cloneNode(true); cancel.replaceWith(newCa);
    const newCl = close.cloneNode(true);  close.replaceWith(newCl);
    newOk.textContent = titleText;
    if (kind === 'ban') newOk.classList.add('danger');

    const finish = (commit) => {
        if (!commit) { modal.classList.add('hidden'); return; }
        const reason = ($('#mod-create-reason').value || '').trim();
        if (!reason) { showToast('Reason is required.', 'warning'); return; }

        // Figure out the target.
        const raw = tgtIn.value.trim();
        let targetId = resolved?.id || null;
        let license  = resolved?.license || null;
        // Bare numeric input → player ID.
        if (!targetId && /^\d+$/.test(raw)) targetId = parseInt(raw, 10);
        // Bare license: string.
        if (!license && raw.startsWith('license:')) license = raw;
        if (!targetId && !license) {
            showToast('Pick an online player or paste a license.', 'warning');
            return;
        }

        if (kind === 'ban') {
            const hours = ($('#mod-create-duration').value || '24').trim();
            if (targetId) fire('banFromPanel', targetId, reason, hours);
            else          fire('banFromPanelByLicense', license, reason, hours);
        } else if (kind === 'warn') {
            if (targetId) fire('warnPlayer', targetId, reason);
            else          fire('warnPlayerByLicense', license, reason);
        } else {
            const minutes = parseInt($('#mod-create-duration').value, 10) || 15;
            if (targetId) fire('jailPlayer', targetId, minutes, reason);
            else          fire('jailPlayerByLicense', license, minutes, reason);
        }
        showToast(`${titleText} sent.`, 'success');
        modal.classList.add('hidden');
        reloadSoon(loadModeration);
    };
    newOk.addEventListener('click', () => finish(true));
    newCa.addEventListener('click', () => finish(false));
    newCl.addEventListener('click', () => finish(false));
}

// Update button label whenever the tab changes.
const _origSetModTab = setModTab;
setModTab = function (tab) {
    _origSetModTab(tab);
    updateModCreateLabel();
};
// Click handler — replaces the old prompt-based stub.
$('#mod-create').addEventListener('click', openModerationModal);
// First-paint label sync.
setTimeout(updateModCreateLabel, 0);

/* ============================================================
   CHATS — channels + DMs, Discord-style
   ============================================================ */
const Chat = (function () {
    let active = 'staff';
    let activeMeta = { label: 'Staff', avatar: null, isDM: false };
    let channels = [];

    function isDM(name) { return name && name.indexOf('dm:') === 0; }

    async function loadChannels() {
        channels = await callback('channels') || [];
        renderRail();
    }
    function renderRail() {
        const channelsRail = $('#chat-rail-channels');
        const dmsRail      = $('#chat-rail-dms');
        if (!channelsRail || !dmsRail) return;
        channelsRail.innerHTML = '';
        dmsRail.innerHTML = '';
        // Seed the cache from this batch first so the avatar helper
        // can bake URLs directly into the DM rail markup.
        channels.forEach(c => {
            if (c.kind === 'dm' && c.peer && c.avatar) rememberAvatar(c.peer, c.avatar);
        });
        channels.forEach(c => {
            const row = document.createElement('button');
            row.className = 'ap-chat-channel' + (c.name === active ? ' active' : '') + (c.kind === 'dm' ? ' dm' : '');
            const icon = c.kind === 'dm'
                ? avatar(c.avatar, c.label, '', c.peer)
                : `<i class="fa-solid fa-${c.name === 'staff' ? 'shield-halved' : 'flag'}"></i>`;
            row.innerHTML = `
                ${icon}
                <div class="ap-chat-channel-text">
                    <strong>${escapeHTML(c.label)}</strong>
                    <small>${c.kind === 'dm' ? 'Direct message' : (c.name === 'staff' ? 'Live admin chat' : 'Discussion')}</small>
                </div>`;
            row.addEventListener('click', () => switchTo(c));
            (c.kind === 'dm' ? dmsRail : channelsRail).appendChild(row);
        });
        if (channels.length && !channels.find(c => c.name === active)) {
            switchTo(channels[0]);
        }
        // Defensive paint pass so every DM rail avatar shows up even if
        // the server response was missing the URL.
        [channelsRail, dmsRail].forEach(rail => {
            rail.querySelectorAll('[data-license]').forEach(el => {
                el.dataset.avatarPainted = '0';
                paintAvatarNode(el);
            });
        });
    }

    async function switchTo(channel) {
        active = channel.name;
        activeMeta = channel;
        // Header
        const head = $('#chat-head-title'); if (head) head.textContent = channel.label;
        const sub  = $('#chat-head-sub');   if (sub)  sub.textContent  =
            channel.kind === 'dm' ? 'Direct message' :
            (channel.name === 'staff' ? 'Live admin chat' : 'Discussion');
        const icon = $('#chat-head-icon');
        if (icon) {
            icon.className = 'fa-solid fa-' +
                (channel.kind === 'dm' ? 'user' : (channel.name === 'staff' ? 'shield-halved' : 'flag'));
        }
        renderRail();
        await refresh();
    }

    // Exposed so the Behaviour tab can repaint timestamps when the
    // 12/24-hour preference changes.
    window.apxReloadChat = () => refresh();

    async function refresh() {
        const rows = await callback('chat', active) || [];
        renderMessages(rows.reverse());
        const cnt = $('#chat-head-count');
        if (cnt) cnt.textContent = `${rows.length} message${rows.length === 1 ? '' : 's'}`;
    }

    function renderMessages(rows) {
        const wrap = $('#chat-msgs');
        if (!wrap) return;
        wrap.innerHTML = '';
        if (!rows.length) {
            wrap.innerHTML = `<div class="ap-empty ap-chat-empty">
                <i class="fa-regular fa-comments"></i>
                <div>No messages yet. Say hi!</div>
            </div>`;
            return;
        }
        // Seed cache first so the avatar helper bakes URLs into markup.
        rows.forEach(m => {
            if (m.author_lic && m.avatar) rememberAvatar(m.author_lic, m.avatar);
        });
        let prev = null, prevDay = null;
        rows.forEach(m => {
            const day = dayKey(m);
            if (day && day !== prevDay) {
                wrap.appendChild(buildDaySep(day));
                prevDay = day;
                prev = null;      // a new day always starts a fresh turn
            }
            const el = buildMsg(m, prev);
            // Stash the source row so append() can group against it later.
            el._msg = m;
            wrap.appendChild(el);
            prev = m;
        });
        // Defensive synchronous paint of every chat avatar — no waiting
        // on the MutationObserver, the picture shows up instantly.
        wrap.querySelectorAll('[data-license]').forEach(el => {
            el.dataset.avatarPainted = '0';
            paintAvatarNode(el);
        });
        wrap.scrollTop = wrap.scrollHeight;
    }

    // Two messages belong to the same "turn" when the same author sent
    // them within five minutes of each other — the second one then drops
    // its avatar and name and tucks up against the first.
    function isContinuation(m, prev) {
        if (!prev || !m) return false;
        if ((prev.author_lic || prev.author) !== (m.author_lic || m.author)) return false;
        const a = Date.parse((prev.created_at || '').replace(' ', 'T'));
        const b = Date.parse((m.created_at || '').replace(' ', 'T'));
        if (isNaN(a) || isNaN(b)) return true;   // no usable timestamps → group
        return Math.abs(b - a) < 5 * 60 * 1000;
    }

    function dayKey(m) {
        return (m && m.created_at ? String(m.created_at) : '').slice(0, 10);
    }

    function dayLabel(key) {
        if (!key) return '';
        const today = new Date();
        const iso = d => d.toISOString().slice(0, 10);
        if (key === iso(today)) return 'Today';
        const y = new Date(today); y.setDate(y.getDate() - 1);
        if (key === iso(y)) return 'Yesterday';
        return key;
    }

    function buildDaySep(key) {
        const div = document.createElement('div');
        div.className = 'ap-chat-daysep';
        div.dataset.day = key;
        div.textContent = dayLabel(key);
        return div;
    }

    function buildMsg(m, prev) {
        const div = document.createElement('div');
        const isMe = m.author_lic && state.boot && state.boot.license === m.author_lic;
        div.className = 'ap-chat-msg'
            + (isMe ? ' me' : '')
            + (isContinuation(m, prev) ? ' cont' : '');
        const time = fmtTime(m.created_at || new Date());
        // Pass author_lic so panel:avatarReady can patch the picture in-place
        // when the Steam resolver finishes asynchronously.
        div.innerHTML = `
            ${avatar(m.avatar, m.author, '', m.author_lic)}
            <div class="ap-chat-msg-body">
                <div class="ap-chat-msg-meta">
                    <span class="ap-chat-msg-author">${escapeHTML(m.author || 'Unknown')}</span>
                    <span class="ap-chat-msg-time">${time}</span>
                </div>
                <div class="ap-chat-msg-text">${escapeHTML(m.text || '')}</div>
            </div>`;
        return div;
    }

    function append(m) {
        if (m.channel !== active) {
            // Mark unread (refresh rail) and bail; future tick refresh handles count.
            return;
        }
        const wrap = $('#chat-msgs');
        if (!wrap) return;
        if (m.author_lic && m.avatar) rememberAvatar(m.author_lic, m.avatar);
        const empty = wrap.querySelector('.ap-empty');
        if (empty) empty.remove();

        // Group against the last message already on screen, and open a new
        // day separator if this one crossed midnight.
        // (`:last-of-type` would be wrong here — it matches on tag name, and
        // both messages and separators are divs.)
        const msgEls  = wrap.querySelectorAll('.ap-chat-msg');
        const last    = msgEls[msgEls.length - 1] || null;
        let prevMsg   = last ? last._msg : null;

        const day     = dayKey(m);
        const sepEls  = wrap.querySelectorAll('.ap-chat-daysep');
        const lastSep = sepEls[sepEls.length - 1] || null;
        if (day && (!lastSep || lastSep.dataset.day !== day)) {
            wrap.appendChild(buildDaySep(day));
            prevMsg = null;   // new day starts a fresh turn
        }

        const msgEl = buildMsg(m, prevMsg);
        msgEl._msg = m;
        wrap.appendChild(msgEl);
        // Paint the new message's avatar straight away.
        msgEl.querySelectorAll('[data-license]').forEach(el => {
            el.dataset.avatarPainted = '0';
            paintAvatarNode(el);
        });
        wrap.scrollTop = wrap.scrollHeight;
    }

    async function send() {
        const input = $('#chat-input');
        if (!input) return;
        const t = input.value.trim();
        if (!t) return;
        fire('chatSend', active, t);
        input.value = '';
        try { input.focus(); } catch (_) {}
    }

    // The message box takes the keyboard as soon as the page shows, so the
    // first keystroke lands in it instead of in whatever had focus before.
    function focusInput() {
        const input = $('#chat-input');
        if (!input) return;
        requestAnimationFrame(() => { try { input.focus({ preventScroll: true }); } catch (_) {} });
    }

    async function openDMByPlayerId(targetId) {
        const dm = await callback('openDM', targetId);
        if (!dm) return;
        await loadChannels();
        const ch = channels.find(c => c.name === dm.name) || dm;
        switchTo(ch);
    }

    // ── New DM modal logic ─────────────────────────────────
    async function refreshNewDMList(q) {
        const wrap = $('#chat-newdm-list');
        if (!wrap) return;
        const players = await callback('players', q || '') || [];
        wrap.innerHTML = '';
        if (!players.length) {
            wrap.innerHTML = `<div class="ap-newdm-empty">
                <i class="fa-solid fa-user-slash"></i>
                <span>${q ? 'No player matches that search.' : 'No other players online.'}</span>
            </div>`;
            return;
        }
        players.forEach(p => {
            const row = document.createElement('div');
            row.className = 'ap-chat-newdm-row';
            row.innerHTML = `${avatar(p.avatar, p.name, 'sm', p.license)}
                <span class="ap-newdm-name">${escapeHTML(p.name)}</span>
                <span class="ap-newdm-id">#${escapeHTML(String(p.id))}</span>
                <i class="fa-solid fa-paper-plane ap-newdm-go"></i>`;
            row.addEventListener('click', async () => {
                $('#chat-newdm').classList.remove('open');
                await openDMByPlayerId(p.id);
            });
            wrap.appendChild(row);
        });
    }

    // Public wiring
    document.addEventListener('click', e => {
        if (e.target.closest('#chat-send')) send();
        if (e.target.closest('#chat-newdm-btn')) {
            $('#chat-newdm').classList.toggle('open');
            if ($('#chat-newdm').classList.contains('open')) {
                $('#chat-newdm-q').value = '';
                refreshNewDMList('');
                setTimeout(() => $('#chat-newdm-q')?.focus(), 50);
            }
        }
    });
    document.addEventListener('keydown', e => {
        if (e.target?.id === 'chat-input' && e.key === 'Enter') send();
        if (e.target?.id === 'chat-newdm-q') refreshNewDMList(e.target.value);
    });

    return {
        load:    async () => { await loadChannels(); await refresh(); focusInput(); },
        append:  append,
        openDM:  openDMByPlayerId
    };
})();
function loadChat() { return Chat.load(); }
function appendChatMsg(m) { Chat.append(m); }

/* ============================================================
   ITEMS / VEHICLES
   ============================================================ */
// Icon bases for every inventory whose layout we know. These load
// directly because both pages live inside the FiveM CEF.
//
// This used to be the single hardcoded ox_inventory path, so on a
// qb-inventory server every icon 404'd into the generic box glyph. The
// server resolves an absolute nui:// URL for the Items catalogue (only
// it knows which provider actually answered), but the Player Detail
// inventory arrives as bare item names, so those walk the candidate list
// with <img onerror> exactly the way vehicle thumbnails do below.
const ITEM_IMAGE_BASES = [
    'nui://ox_inventory/web/images/',
    'nui://qb-inventory/html/images/',
    'nui://ps-inventory/html/images/',
    'nui://qs-inventory/html/images/',
    'nui://origen_inventory/html/images/',
    'nui://codem-inventory/html/itemimages/'
];
function itemImageCandidates(it) {
    if (!it) return [];
    const img = it.image;
    if (img && img.includes('://')) return [img];   // absolute — server resolved it
    const file = img || (it.name ? it.name + '.png' : null);
    if (!file) return [];
    return ITEM_IMAGE_BASES.map(b => b + file);
}
function itemImageSrc(it) {
    return itemImageCandidates(it)[0] || '';
}
// Walk the candidate list on each 404; when it runs out, reveal whatever
// fallback glyph the caller put next to the <img>.
window.apxItemImgFail = (img) => {
    const list = (img.dataset.cands || '').split('|').filter(Boolean);
    const next = Number(img.dataset.i || 0) + 1;
    if (next < list.length) { img.dataset.i = String(next); img.src = list[next]; return; }
    img.style.display = 'none';
    const glyph = img.nextElementSibling;
    if (glyph) glyph.style.display = 'flex';
};
// Same walk, but for the places that swap the <img> out for an icon.
window.apxItemImgFailIcon = (img, cls) => {
    const list = (img.dataset.cands || '').split('|').filter(Boolean);
    const next = Number(img.dataset.i || 0) + 1;
    if (next < list.length) { img.dataset.i = String(next); img.src = list[next]; return; }
    img.replaceWith(Object.assign(document.createElement('i'), { className: cls }));
};

async function loadItems() {
    // An EMPTY Lua table crosses the NUI boundary as JSON `{}`, an object,
    // not `[]`. `await callback('items') || []` therefore kept the truthy
    // `{}` and the very next line threw "state.items.filter is not a
    // function" — as an UNHANDLED PROMISE REJECTION, because setPage calls
    // its loader without await or catch. That error only ever appeared in
    // CEF devtools, never in F8, which is why an empty catalogue looked
    // like the page simply doing nothing at all. Coerce to a real array.
    const res = await callback('items');
    state.items = Array.isArray(res) ? res : [];
    renderItems('');
    $('#items-search').oninput = e => renderItems(e.target.value);
}
function renderItems(q) {
    const grid = $('#items-grid');
    const needle = (q || '').toLowerCase();
    grid.innerHTML = '';
    // `it.label` was read unguarded; one item with a null label took the
    // whole render down the same silent path described in loadItems.
    const rows = (state.items || []).filter(it => {
        if (!needle) return true;
        const label = String(it.label || '').toLowerCase();
        const name  = String(it.name  || '').toLowerCase();
        return label.includes(needle) || name.includes(needle);
    });
    // Never leave the panel blank with no explanation again — a page that
    // renders nothing is indistinguishable from a page that is broken.
    if (!rows.length) {
        grid.innerHTML = `
            <div class="ap-empty">
                <i class="fa-solid fa-boxes-stacked"></i>
                <div>${state.items && state.items.length
                    ? 'No item matches that search.'
                    : 'No items found. Check the server console for the apex_adminmenu item-catalogue warning.'}</div>
            </div>`;
        return;
    }
    rows.forEach(it => {
            const card = document.createElement('div');
            card.className = 'ap-grid-item';
            const cands = itemImageCandidates(it);
            card.innerHTML = `
                <img class="ap-gi-img" src="${cands[0] || ''}" alt=""
                     data-cands="${escapeHTML(cands.join('|'))}" data-i="0"
                     onerror="window.apxItemImgFail(this)">
                <div class="ap-gi-icon" style="display:none"><i class="fa-solid fa-box"></i></div>
                <div class="ap-gi-name">${escapeHTML(it.label || it.name || '')}</div>
                <div class="ap-gi-id">${escapeHTML(it.name || '')}</div>`;
            card.addEventListener('click', () => {
                state.selectedItem = it.name;
                $$('.ap-grid-item').forEach(x => x.classList.remove('selected'));
                card.classList.add('selected');
                const icands = itemImageCandidates(it);
                $('#items-detail').innerHTML = `
                    <div class="ap-item-preview">
                        <div class="ap-item-preview-imgwrap">
                            <img src="${icands[0] || ''}" alt="" class="ap-item-preview-img"
                                 data-cands="${escapeHTML(icands.join('|'))}" data-i="0"
                                 onerror="window.apxItemImgFailIcon(this,'fa-solid fa-box ap-item-preview-fallback')">
                        </div>
                        <h3 class="ap-item-preview-name">${escapeHTML(it.label || it.name || '')}</h3>
                        <div class="ap-pd-pills ap-item-preview-pills">
                            <span class="ap-pd-pill">Name: <b>${escapeHTML(it.name)}</b></span>
                            ${it.weight ? `<span class="ap-pd-pill">Weight: <b>${it.weight}</b></span>` : ''}
                        </div>
                    </div>
                    <div class="ap-pd-block ap-give">
                        <div class="ap-pd-block-title">Give this item</div>
                        <div class="ap-give-qty">
                            <span class="ap-give-qty-label">Quantity</span>
                            <div class="ap-give-stepper">
                                <button type="button" class="ap-give-step" onclick="window._giveStep(-1)" title="Less"><i class="fa-solid fa-minus"></i></button>
                                <input type="number" id="give-qty" class="ap-input" min="1" value="1">
                                <button type="button" class="ap-give-step" onclick="window._giveStep(1)" title="More"><i class="fa-solid fa-plus"></i></button>
                            </div>
                        </div>
                        <div class="ap-give-quick">
                            <button type="button" class="ap-give-chip" onclick="window._giveSet(1)">×1</button>
                            <button type="button" class="ap-give-chip" onclick="window._giveSet(5)">×5</button>
                            <button type="button" class="ap-give-chip" onclick="window._giveSet(10)">×10</button>
                            <button type="button" class="ap-give-chip" onclick="window._giveSet(50)">×50</button>
                        </div>
                        <button class="ap-btn primary ap-give-btn" onclick="window._giveItemFlow('${escapeHTML(it.name)}')">
                            <i class="fa-solid fa-user-plus"></i> Give to player…
                        </button>
                        <small class="ap-muted ap-give-hint">Opens a searchable player picker.</small>
                    </div>`;
            });
            grid.appendChild(card);
        });
}

/* ── Vehicle images — ported verbatim from apex_garage ────────
   Candidate URLs, best first: local html/images/<spawncode>.<ext>, then
   the fallback URL(s). There's no way to ask whether a file exists from
   the NUI, so the <img> onerror walks the list; running out reveals the
   monogram rendered underneath, so a 404 is never a hole.
   ──────────────────────────────────────────────────────────── */
function vehImageCandidates(spawn) {
    const cfg = state.images;
    if (!cfg || !spawn) return [];
    const out = [];
    const m = String(spawn).toLowerCase();
    if (cfg.custom && cfg.base) {
        (cfg.exts || ['png']).forEach(ext => out.push(`${cfg.base}${encodeURIComponent(m)}.${ext}`));
    }
    const urls = Array.isArray(cfg.url) ? cfg.url : (cfg.url ? [cfg.url] : []);
    urls.forEach(u => out.push(String(u).replace('%s', encodeURIComponent(m))));
    return out;
}
window.apxImgFail = (img) => {
    const list = (img.dataset.cands || '').split('|').filter(Boolean);
    const next = Number(img.dataset.i || 0) + 1;
    if (next < list.length) { img.dataset.i = String(next); img.src = list[next]; return; }
    if (img.parentElement) img.parentElement.classList.remove('has-img');
    img.remove();
};
window.apxImgOk = (img) => { if (img.parentElement) img.parentElement.classList.add('has-img'); };

function vehThumb(spawn, label, cls) {
    const cands = vehImageCandidates(spawn);
    // A car glyph rather than the vehicle's initials: two letters on a tile
    // reads as a broken avatar, while the icon reads as "no picture yet".
    const mono  = `<span class="mono-fallback" title="${escapeHTML(label || '')}"><i class="fa-solid fa-car-side"></i></span>`;
    const inner = cands.length
        ? mono + `<img src="${cands[0]}" data-i="0" data-cands="${cands.join('|')}" onload="apxImgOk(this)" onerror="apxImgFail(this)" alt="">`
        : mono;
    return `<div class="${cls || 'ap-veh-thumb'}">${inner}</div>`;
}

// The server no longer ships the whole owned-vehicles table on every
// visit — that was a 1000+ row query and payload each time the page was
// opened. It returns one capped page, and searching queries the database.
//
// The first page is kept aside so the local filter still works over it.
// That matters on ESX, where the model is a hash inside a JSON blob and
// the readable name ("Adder") only exists after the client resolves it —
// SQL cannot search on something that is computed here.
let vehSearchTimer = null;

async function loadVehicles(q) {
    const term = (q || '').trim();
    const rows = await callback('vehicles', term) || [];

    if (term === '') state.vehiclesBase = rows;
    state.vehicles = rows;
    state.vehiclesQuery = term;

    renderVehicles(q || '');

    const box = $('#vehs-search');
    if (box && !box.dataset.wired) {
        box.dataset.wired = '1';
        box.addEventListener('input', e => {
            const v = e.target.value;
            renderVehicles(v);                       // instant, over what is loaded
            clearTimeout(vehSearchTimer);
            vehSearchTimer = setTimeout(() => loadVehicles(v), 300);   // then the DB
        });
    }
}

function renderVehicles(q) {
    const grid = $('#vehs-grid');
    const needle = (q || '').toLowerCase();
    grid.innerHTML = '';

    // Merge the loaded page with the search results, de-duplicated by
    // plate, so a model-name match from the first page is not lost just
    // because the SQL search could not see it.
    const seen = new Set();
    const pool = [];
    for (const v of [...(state.vehicles || []), ...(state.vehiclesBase || [])]) {
        const key = (v.plate || '') + '|' + (v.owner || '');
        if (seen.has(key)) continue;
        seen.add(key);
        pool.push(v);
    }

    const filtered = pool.filter(v =>
        !needle ||
        (v.label    || '').toLowerCase().includes(needle) ||
        (v.model    || '').toLowerCase().includes(needle) ||
        (v.plate    || '').toLowerCase().includes(needle) ||
        (v.ownerName|| '').toLowerCase().includes(needle));
    if (filtered.length === 0) {
        // Center the empty-state so its icon lines up with the detail
        // panel's "Select a vehicle" placeholder on the right.
        grid.style.alignContent = 'center';
        grid.innerHTML = `<div class="ap-empty" style="padding:24px 12px;grid-column:1/-1">
            <i class="fa-solid fa-car"></i>
            <div style="margin-top:6px">No vehicles found</div>
            ${needle ? '<div style="margin-top:4px;font-size:12px;opacity:.7">Searching by plate or owner looks through the whole database.</div>' : ''}
        </div>`;
        return;
    }
    grid.style.alignContent = '';

    // The list is one capped page, not the entire table. Say so, otherwise
    // "my car isn't in the panel" looks like a bug instead of a full page.
    // A page that came back exactly full is the only reliable tell that
    // there is more behind it — hence the size arriving in the bootstrap.
    const pageSize = Number(state.boot?.vehPageSize) || 0;
    const capped   = pageSize > 0 && (state.vehicles || []).length >= pageSize;

    grid.innerHTML = (capped ? `<div class="ap-empty" style="padding:8px 12px;grid-column:1/-1;font-size:12px;opacity:.75">
            <i class="fa-solid fa-circle-info"></i>
            Showing ${filtered.length} of many — search by plate or owner to look through the whole database.
        </div>` : '') + filtered.map((v, i) => {
        const state = (v.state === 'stored' ? 'In garage' : 'Out');
        return `
        <div class="ap-veh-card" data-veh-idx="${i}" data-plate="${escapeHTML(v.plate || '')}" tabindex="0">
            <div class="ap-veh-card-head">
                <span class="ap-veh-plate" data-copy="${escapeHTML(v.plate || '')}" title="Click to copy plate">${escapeHTML(v.plate || '???')}</span>
                <span class="ap-veh-state ${v.state || ''}">${state}</span>
            </div>
            <div class="ap-veh-identity">
                ${vehThumb(v.spawn, v.label || v.model)}
                <div class="ap-veh-model">${escapeHTML(v.label || v.model || '—')}</div>
            </div>
            <div class="ap-veh-meta">
                <small><i class="fa-solid fa-user"></i> ${escapeHTML(v.ownerName || v.owner || '—')}</small>
                ${v.garage ? `<small><i class="fa-solid fa-warehouse"></i> ${escapeHTML(v.garage)}</small>` : ''}
            </div>
            <div class="ap-veh-actions">
                <button class="ap-btn ghost ap-btn-sm" data-copy="${escapeHTML(v.plate || '')}" title="Copy plate"><i class="fa-solid fa-copy"></i></button>
                <button class="ap-btn ghost ap-btn-sm" data-veh-act="track" data-plate="${escapeHTML(v.plate || '')}" title="Show on map"><i class="fa-solid fa-location-crosshairs"></i></button>
                <button class="ap-btn ghost ap-btn-sm" data-veh-act="give" data-model="${escapeHTML(v.model || '')}" title="Spawn this model for a player"><i class="fa-solid fa-gift"></i></button>
                <button class="ap-btn danger ap-btn-sm" data-veh-act="delete" data-plate="${escapeHTML(v.plate || '')}" data-owner="${escapeHTML(v.ownerName || '')}" title="Delete vehicle"><i class="fa-solid fa-trash"></i></button>
            </div>
        </div>`;
    }).join('');
    grid.querySelectorAll('[data-veh-act="give"]').forEach(btn => {
        btn.addEventListener('click', () => {
            const model = btn.dataset.model;
            if (!model) return;
            pickPlayer(p => { if (p) fire('spawnVehicleFor', p.id, model); },
                { title: `Spawn "${model}" for…` });
        });
    });
    grid.querySelectorAll('[data-veh-act="delete"]').forEach(btn => {
        btn.addEventListener('click', async () => {
            const plate = btn.dataset.plate, owner = btn.dataset.owner || 'this owner';
            const ok = await confirmDialog('Delete vehicle',
                `Delete vehicle ${plate} owned by ${owner}? This cannot be undone.`,
                { okLabel: 'Delete', danger: true });
            if (!ok) return;
            fire('deleteVehicle', plate);
            reloadSoon(loadVehicles);
        });
    });
    grid.querySelectorAll('[data-veh-act="track"]').forEach(btn => {
        btn.addEventListener('click', () => {
            showToast('Vehicle tracking is only available while the vehicle is online.', 'info');
        });
    });

    // Card selection. The cards had no click handler at all — only the
    // four action buttons did — so the detail pane was stuck on
    // "Select a vehicle to view owners" no matter what you clicked.
    grid.querySelectorAll('.ap-veh-card').forEach(card => {
        const open = () => {
            // Ignore clicks that landed on an action button or the
            // click-to-copy plate; those have their own behaviour.
            const veh = filtered[Number(card.dataset.vehIdx)];
            if (!veh) return;
            grid.querySelectorAll('.ap-veh-card.selected')
                .forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            renderVehicleDetail(veh);
        };
        card.addEventListener('click', e => {
            if (e.target.closest('[data-veh-act]') || e.target.closest('[data-copy]')) return;
            open();
        });
        card.addEventListener('keydown', e => {
            if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); open(); }
        });
    });
}

// Detail pane for one vehicle: hero image, plate, owner and state.
function renderVehicleDetail(v) {
    const pane = $('#vehs-detail');
    if (!pane) return;
    pane.classList.remove('ap-detail-center');

    const stateLabel = v.state === 'stored' ? 'In garage' : 'Out';
    const rows = [
        ['Plate',   v.plate],
        ['Model',   v.label || v.model],
        ['Spawn code', v.spawn || '—'],
        ['Owner',   v.ownerName || v.owner],
        ['Licence', v.owner],
        ['Garage',  v.garage],
        ['State',   stateLabel]
    ];

    pane.innerHTML = `
        ${vehThumb(v.spawn, v.label || v.model, 'ap-veh-hero')}
        <div class="ap-veh-detail-head">
            <span class="ap-veh-plate">${escapeHTML(v.plate || '???')}</span>
            <span class="ap-veh-state ${v.state || ''}">${stateLabel}</span>
        </div>
        <h3 class="ap-veh-detail-title">${escapeHTML(v.label || v.model || '—')}</h3>
        <div class="ap-veh-detail-rows">
            ${rows.filter(([, val]) => val !== undefined && val !== null && val !== '').map(([k, val]) => `
                <div class="ap-veh-detail-row">
                    <span>${escapeHTML(k)}</span>
                    <strong class="mono">${escapeHTML(String(val))}</strong>
                </div>`).join('')}
        </div>
        <div class="ap-veh-detail-actions">
            <button class="ap-btn ghost" data-copy="${escapeHTML(v.plate || '')}">
                <i class="fa-solid fa-copy"></i> Copy plate
            </button>
            <button class="ap-btn ghost" id="veh-detail-give">
                <i class="fa-solid fa-gift"></i> Spawn for player
            </button>
        </div>`;

    const give = $('#veh-detail-give');
    if (give) give.addEventListener('click', () => {
        if (!v.model) return;
        pickPlayer(p => { if (p) fire('spawnVehicleFor', p.id, v.spawn || v.model); },
            { title: `Spawn "${v.label || v.model}" for…` });
    });
}

/* ============================================================
   CONSOLE
   ============================================================ */
// txAdmin-style console palette — FiveM emits `^N` colour markers
// where N is 0..9. We map each one to a Tailwind-ish console hex.
const CON_COLOURS = {
    '0': '#bfbfbf', // reset / default
    '1': '#FF5555', // red
    '2': '#50FA7B', // green
    '3': '#F1FA8C', // yellow
    '4': '#8BE9FD', // blue
    '5': '#FF79C6', // pink
    '6': '#BD93F9', // purple
    '7': '#F8F8F2', // white
    '8': '#6272A4', // grey
    '9': '#FFB86C'  // orange
};
// Match `^N` markers anywhere in the string. Anything between two
// markers takes the colour of the leading marker.
function consoleSegmentsFor(text) {
    const segs = [];
    let cur = { col: '#bfbfbf', txt: '' };
    let i = 0;
    while (i < text.length) {
        const ch = text[i];
        if (ch === '^' && i + 1 < text.length && CON_COLOURS[text[i + 1]]) {
            if (cur.txt !== '') { segs.push(cur); cur = { col: CON_COLOURS[text[i + 1]], txt: '' }; }
            else { cur.col = CON_COLOURS[text[i + 1]]; }
            i += 2;
        } else {
            cur.txt += ch;
            i++;
        }
    }
    if (cur.txt !== '') segs.push(cur);
    return segs;
}

function appendConsoleLine(line) {
    if (!line) return;
    const log = $('#con-log');
    if (!log) return;
    const div = document.createElement('div');

    // Classify line for the gutter colour stripe + base text colour.
    const raw = (line.text || '').toString();
    const stripped = raw.replace(/\^[0-9]/g, '');
    let cls = 'ap-con-line';
    const lower = stripped.toLowerCase();
    if (line.type === 'cmd' || stripped.startsWith('> '))  cls += ' cmd';
    else if (line.type === 'error' || lower.includes('error') || lower.includes('failed') || raw.includes('^1'))
        cls += ' error';
    else if (lower.includes('warn') || raw.includes('^3'))
        cls += ' warn';
    else if (lower.startsWith('resource ') || stripped.startsWith('[') || raw.includes('^2'))
        cls += ' info';
    else if (lower.includes('script:'))
        cls += ' script';
    div.className = cls;

    // Time stamp prefix — keeps txAdmin's "[12:45:09]" feel without
    // depending on the server clock.
    const now = new Date();
    const ts = `${String(now.getHours()).padStart(2,'0')}:${String(now.getMinutes()).padStart(2,'0')}:${String(now.getSeconds()).padStart(2,'0')}`;
    const tsSpan = document.createElement('span');
    tsSpan.className = 'ap-con-ts';
    tsSpan.textContent = `[${ts}]`;
    div.appendChild(tsSpan);

    // Body — parse FiveM colour markers into coloured spans.
    const body = document.createElement('span');
    body.className = 'ap-con-body';
    consoleSegmentsFor(raw).forEach(seg => {
        const s = document.createElement('span');
        s.style.color = seg.col;
        s.textContent = seg.txt;
        body.appendChild(s);
    });
    div.appendChild(body);

    log.appendChild(div);
    log.scrollTop = log.scrollHeight;
}
async function loadConsole() {
    const rows = await callback('consoleHistory') || [];
    const log = $('#con-log');
    log.innerHTML = '';
    rows.forEach(appendConsoleLine);
    loadResources();
}
$('#con-send').addEventListener('click', () => {
    const cmd = $('#con-cmd').value.trim();
    if (!cmd) return;
    fire('consoleExec', cmd);
    appendConsoleLine({ text: '> ' + cmd, type: 'cmd' });
    $('#con-cmd').value = '';
});
$('#con-cmd').addEventListener('keydown', e => { if (e.key === 'Enter') $('#con-send').click(); });
$('#con-clear').addEventListener('click', () => $('#con-log').innerHTML = '');

async function loadResources() {
    state.resources = await callback('resources') || [];
    renderResources('');
    $('#res-search').oninput = e => renderResources(e.target.value);
}
function renderResources(q) {
    const wrap = $('#res-list');
    const needle = (q || '').toLowerCase();
    wrap.innerHTML = '';
    state.resources
        .filter(r => state.resTab === 'all' || (state.resTab === 'started' && r.state === 'started') || (state.resTab === 'stopped' && r.state !== 'started'))
        .filter(r => !needle || r.name.toLowerCase().includes(needle))
        .forEach(r => {
            const div = document.createElement('div');
            div.className = 'ap-list-item';
            div.innerHTML = `<span class="ap-list-item-name">${r.name}</span>
                <span class="ap-pill ${r.state === 'started' ? 'active' : 'expired'}">${r.state}</span>
                <button class="ap-icon-btn" title="Restart" onclick="window._res('${r.name}','restart')"><i class="fa-solid fa-rotate"></i></button>
                <button class="ap-icon-btn" title="${r.state === 'started' ? 'Stop' : 'Start'}" onclick="window._res('${r.name}','${r.state === 'started' ? 'stop' : 'start'}')"><i class="fa-solid fa-${r.state === 'started' ? 'stop' : 'play'}"></i></button>`;
            wrap.appendChild(div);
        });
}
window._res = (n, a) => { fire('resourceAction', n, a); reloadSoon(loadResources); };
$$('[data-res-tab]').forEach(b => b.addEventListener('click', () => {
    state.resTab = b.dataset.resTab;
    $$('[data-res-tab]').forEach(x => x.classList.toggle('active', x === b));
    renderResources($('#res-search').value);
}));

/* ============================================================
   EVENTS
   ============================================================ */
/* ============================================================
   EVENT LOGS — server / client event capture & rules
   ============================================================ */
state.eventLogs  = {
    rows: [],        // captured events (newest first)
    rules: [],       // rules from server
    filter: '',      // search box value
    live: true,      // append new events to the rows array
    tab: 'all'       // 'all' | 'blocked' | 'hidden' | 'webhook'
};

async function loadEvents() {
    const data = await callback('eventLogs') || { rows: [], rules: [] };
    state.eventLogs.rows  = data.rows  || [];
    state.eventLogs.rules = data.rules || [];
    renderEventFeed();
    renderEventRules();
}

// Match an event name against a stored rule. Supports trailing
// wildcards (e.g. "esx:*" matches "esx:onPlayerSpawn").
function eventMatchesRule(evName, rule) {
    if (!rule || !rule.event) return false;
    const pat = rule.event;
    if (pat === evName) return true;
    if (pat.endsWith('*')) return evName.startsWith(pat.slice(0, -1));
    return false;
}
function ruleFor(evName) {
    const rules = state.eventLogs.rules || [];
    return rules.find(r => Number(r.enabled) === 1 && eventMatchesRule(evName, r)) || null;
}

const EV_ACTION_META = {
    log:     { icon: 'fa-eye',                 colour: 'var(--info)',    label: 'Log only' },
    block:   { icon: 'fa-ban',                 colour: 'var(--error)',   label: 'Blocked'  },
    hide:    { icon: 'fa-eye-slash',           colour: 'var(--text-mute)', label: 'Hidden' },
    webhook: { icon: 'fa-brands fa-discord',   colour: '#5865F2',        label: 'Discord webhook' }
};

function renderEventFeed() {
    const wrap = $('#ev-feed');
    if (!wrap) return;

    const q   = (state.eventLogs.filter || '').toLowerCase();
    const tab = state.eventLogs.tab || 'all';

    // Apply search + tab filter while computing counts in one pass.
    const counts = { all: 0, blocked: 0, hidden: 0, webhook: 0 };
    const filtered = [];
    state.eventLogs.rows.forEach(r => {
        if (q && !(r.event?.toLowerCase().includes(q) || (r.src_name || '').toLowerCase().includes(q))) return;
        const matched = ruleFor(r.event);
        const act = matched?.action || 'log';
        counts.all++;
        if (act === 'block')   counts.blocked++;
        if (act === 'hide')    counts.hidden++;
        if (act === 'webhook') counts.webhook++;
        if (tab === 'all')     return filtered.push({ row: r, rule: matched, act });
        if (tab === act)       filtered.push({ row: r, rule: matched, act });
    });

    // Update tab counters.
    $('#ev-count-all')     && ($('#ev-count-all').textContent     = counts.all);
    $('#ev-count-blocked') && ($('#ev-count-blocked').textContent = counts.blocked);
    $('#ev-count-hidden')  && ($('#ev-count-hidden').textContent  = counts.hidden);
    $('#ev-count-webhook') && ($('#ev-count-webhook').textContent = counts.webhook);

    if (filtered.length === 0) {
        wrap.innerHTML = `<div class="ap-empty" style="padding:40px 14px">
            <i class="fa-solid fa-bolt"></i>
            <div style="margin-top:6px">
                ${tab === 'all'
                    ? 'No events captured yet.'
                    : `No events tagged as <b>${escapeHTML(tab)}</b> right now.`}
            </div>
        </div>`;
        return;
    }

    wrap.innerHTML = filtered.map(({ row: r, rule, act }) => {
        const time = (r.created_at || '').slice(11, 19);
        const meta = EV_ACTION_META[act] || EV_ACTION_META.log;
        const badge = rule
            ? `<span class="ap-event-badge" style="--badge:${meta.colour}" title="Matched rule: ${escapeHTML(rule.event)} → ${escapeHTML(act)}${rule.webhook_key ? ' (' + rule.webhook_key + ')' : ''}">
                  <i class="fa-solid ${meta.icon}"></i> ${escapeHTML(meta.label)}
               </span>`
            : '';
        const payload = r.payload ? `<pre class="ap-event-payload">${escapeHTML(r.payload)}</pre>` : '';
        return `
        <div class="ap-event-row" data-event="${escapeHTML(r.event)}" data-act="${act}">
            <span class="ap-event-time">${time}</span>
            <code class="ap-event-name" data-copy="${escapeHTML(r.event)}" title="Click to copy event name">${escapeHTML(r.event)}</code>
            ${r.src_name
                ? `<span class="ap-event-src" title="src ${r.source}">${escapeHTML(r.src_name)}</span>`
                : '<span class="ap-event-src empty">—</span>'}
            ${badge}
            <div class="ap-event-actions">
                <button data-ev-act="copy"  title="Copy event name"><i class="fa-solid fa-copy"></i></button>
                <button data-ev-act="rule"  title="Create or edit rule"><i class="fa-solid fa-filter"></i></button>
                <button data-ev-act="block" title="Block this event"><i class="fa-solid fa-ban"></i></button>
                <button data-ev-act="hide"  title="Hide from feed"><i class="fa-solid fa-eye-slash"></i></button>
                <button data-ev-act="webhook" title="Forward to Discord"><i class="fa-brands fa-discord"></i></button>
            </div>
            ${payload}
        </div>`;
    }).join('');

    // Wire interactions.
    wrap.querySelectorAll('.ap-event-row').forEach(row => {
        const ev = row.dataset.event;
        // Copy event name when clicking the code span.
        row.querySelector('.ap-event-name')?.addEventListener('click', () => {
            copyToClipboard(ev);
            showToast('Copied: ' + ev, 'info', 2000);
        });
        // Action buttons.
        row.querySelectorAll('[data-ev-act]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const act = btn.dataset.evAct;
                if (act === 'copy') {
                    copyToClipboard(ev);
                    showToast('Copied: ' + ev, 'info', 2000);
                    return;
                }
                if (act === 'rule') {
                    const existing = ruleFor(ev) || null;
                    openEventRuleModal(ev, existing);
                    return;
                }
                // For block / hide / webhook — if a rule for this exact
                // event already exists, update it; otherwise create one.
                const existing = (state.eventLogs.rules || []).find(r => r.event === ev);
                applyQuickRule(ev, act, existing);
            });
        });
    });
}

// Clipboard helper that falls back to a hidden textarea when the
// Clipboard API isn't available (FiveM NUI can be flaky here).
function copyToClipboard(text) {
    try {
        if (navigator.clipboard?.writeText) {
            navigator.clipboard.writeText(text);
            return;
        }
    } catch (_) {}
    const ta = document.createElement('textarea');
    ta.value = text;
    ta.style.position = 'fixed';
    ta.style.opacity  = '0';
    document.body.appendChild(ta);
    ta.select();
    try { document.execCommand('copy'); } catch (_) {}
    ta.remove();
}

// Global click handler: any element with `data-copy="..."` copies
// its value to the clipboard and shows a quick toast. Lets every
// new "copyable" chip / pill be wired up without per-component JS.
document.addEventListener('click', e => {
    const el = e.target.closest('[data-copy]');
    if (!el) return;
    const text = el.getAttribute('data-copy');
    if (!text) return;
    copyToClipboard(text);
    showToast('Copied: ' + (text.length > 40 ? text.slice(0, 40) + '…' : text), 'info', 1800);
});

// Create / update a rule from the one-click action buttons.
function applyQuickRule(event, action, existing) {
    const payload = {
        event,
        action,
        enabled: true,
        webhook_key: action === 'webhook' ? 'global' : null
    };
    if (existing && existing.id) payload.id = existing.id;
    fire('saveEventRule', payload);

    // Optimistic update so the badge appears instantly. The server
    // push (panel:eventRules) reconciles afterwards.
    const next = (state.eventLogs.rules || []).filter(r => r.event !== event);
    next.unshift({
        id: existing?.id || ('local-' + Date.now()),
        event, action, enabled: 1,
        webhook_key: payload.webhook_key
    });
    state.eventLogs.rules = next;
    renderEventFeed();
    renderEventRules();

    const verb = action === 'block' ? 'Blocked' :
                 action === 'hide'  ? 'Hidden'  :
                 action === 'webhook' ? 'Forwarding to Discord' :
                 'Logging';
    showToast(`${verb}: ${event}`, 'success');
}

function renderEventRules() {
    const wrap = $('#ev-rules-list');
    if (!wrap) return;
    const rules = state.eventLogs.rules || [];
    if (rules.length === 0) {
        wrap.innerHTML = `<div class="ap-empty" style="padding:20px 12px">
            <i class="fa-solid fa-filter"></i>
            <div style="margin-top:6px">No rules yet.</div>
            <small class="ap-muted" style="margin-top:4px;display:block">
                Click an event in the feed to block/hide/forward it.
            </small>
        </div>`;
        return;
    }
    wrap.innerHTML = rules.map(r => {
        const act = r.action || 'log';
        const meta = EV_ACTION_META[act] || EV_ACTION_META.log;
        const enabled = Number(r.enabled) === 1;
        return `
        <div class="ap-events-rule ${enabled ? '' : 'disabled'}" data-id="${r.id}" data-action="${escapeHTML(act)}">
            <div class="ap-events-rule-head">
                <span class="ap-events-rule-act act-${escapeHTML(act)}" style="--badge:${meta.colour}">
                    <i class="fa-solid ${meta.icon}"></i>
                </span>
                <div class="ap-events-rule-info">
                    <code title="${escapeHTML(r.event)}">${escapeHTML(r.event)}</code>
                    <small>${escapeHTML(meta.label)}${r.webhook_key ? ' · ' + escapeHTML(r.webhook_key) : ''}</small>
                </div>
            </div>
            <div class="ap-events-rule-foot">
                <label class="ap-switch-mini-wrap" title="Enable / disable rule">
                    <input type="checkbox" class="ap-switch-mini" ${enabled ? 'checked' : ''} data-act="toggle">
                </label>
                <button class="ap-icon-btn" data-act="edit" title="Edit rule"><i class="fa-solid fa-pen"></i></button>
                <button class="ap-icon-btn danger" data-act="delete" title="Delete rule"><i class="fa-solid fa-trash"></i></button>
            </div>
        </div>`;
    }).join('');

    wrap.querySelectorAll('.ap-events-rule').forEach(card => {
        const id = card.dataset.id;
        const rule = (state.eventLogs.rules || []).find(r => String(r.id) === id);
        card.querySelector('[data-act="toggle"]')?.addEventListener('change', e => {
            fire('saveEventRule', { id: typeof rule?.id === 'number' ? rule.id : null, event: rule?.event, action: rule?.action, webhook_key: rule?.webhook_key, enabled: e.target.checked });
            if (rule) rule.enabled = e.target.checked ? 1 : 0;
            renderEventFeed();
            renderEventRules();
        });
        card.querySelector('[data-act="delete"]')?.addEventListener('click', async () => {
            const ok = await confirmDialog('Delete rule', `Remove rule for "${rule?.event || id}"?`, { okLabel: 'Delete', danger: true });
            if (!ok) return;
            if (typeof rule?.id === 'number') fire('deleteEventRule', rule.id);
            state.eventLogs.rules = (state.eventLogs.rules || []).filter(r => String(r.id) !== id);
            renderEventFeed();
            renderEventRules();
        });
        card.querySelector('[data-act="edit"]')?.addEventListener('click', () => {
            if (rule) openEventRuleModal(rule.event, rule);
        });
    });
}

function openEventRuleModal(eventName, existing) {
    const modal = $('#ap-modal');
    const body  = $('#ap-modal-body');
    const title = $('#ap-modal-title');
    const isEdit = !!(existing && existing.id);
    title.textContent = isEdit ? 'Edit event rule' : 'New event rule';
    const curAction = (existing && existing.action) || 'log';
    const curHook   = (existing && existing.webhook_key) || 'global';
    const evVal     = isEdit ? existing.event : (eventName || '');
    body.innerHTML = `
        <label class="ap-form-row"><span>Event</span>
            <input class="ap-input mono" id="ev-rule-event" value="${escapeHTML(evVal)}" placeholder="esx:onPlayerSpawn or QBCore:Server:*"></label>
        <label class="ap-form-row"><span>Action</span>
            <select class="ap-input" id="ev-rule-action">
                <option value="log"     ${curAction==='log'    ?'selected':''}>Log only</option>
                <option value="block"   ${curAction==='block'  ?'selected':''}>Block (drop the event)</option>
                <option value="hide"    ${curAction==='hide'   ?'selected':''}>Hide from feed</option>
                <option value="webhook" ${curAction==='webhook'?'selected':''}>Forward to Discord</option>
            </select>
        </label>
        <label class="ap-form-row" id="ev-rule-hook-row" style="display:${curAction==='webhook'?'':'none'}"><span>Webhook category</span>
            <select class="ap-input" id="ev-rule-hook">
                <option value="global"     ${curHook==='global'    ?'selected':''}>Catch-all</option>
                <option value="moderation" ${curHook==='moderation'?'selected':''}>Moderation</option>
                <option value="player"     ${curHook==='player'    ?'selected':''}>Player</option>
                <option value="vehicle"    ${curHook==='vehicle'   ?'selected':''}>Vehicle</option>
                <option value="economy"    ${curHook==='economy'   ?'selected':''}>Economy</option>
                <option value="staff"      ${curHook==='staff'     ?'selected':''}>Staff</option>
                <option value="reports"    ${curHook==='reports'   ?'selected':''}>Reports</option>
                <option value="login"      ${curHook==='login'     ?'selected':''}>Login</option>
                <option value="console"    ${curHook==='console'   ?'selected':''}>Console</option>
            </select>
        </label>
        <small class="ap-muted">
            Tip: use a trailing <code>*</code> for wildcards (e.g. <code>esx:*</code> matches every ESX event).
        </small>`;
    modal.classList.remove('hidden');
    $('#ev-rule-action').addEventListener('change', e => {
        $('#ev-rule-hook-row').style.display = e.target.value === 'webhook' ? '' : 'none';
    });
    const ok = $('#ap-modal-ok'), cancel = $('#ap-modal-cancel'), close = $('#ap-modal-close');
    const newOk = ok.cloneNode(true); ok.replaceWith(newOk); newOk.textContent = isEdit ? 'Save changes' : 'Create rule';
    const newCa = cancel.cloneNode(true); cancel.replaceWith(newCa);
    const newCl = close.cloneNode(true); close.replaceWith(newCl);
    const finish = (commit) => {
        if (commit) {
            const event  = $('#ev-rule-event').value.trim();
            const action = $('#ev-rule-action').value;
            if (!event) { showToast('Event name is required.', 'warning'); return; }
            const payload = {
                event, action,
                webhook_key: action === 'webhook' ? $('#ev-rule-hook').value : null,
                enabled:     true
            };
            if (isEdit) payload.id = existing.id;
            fire('saveEventRule', payload);
            showToast(isEdit ? 'Rule updated.' : 'Rule created.', 'success');
        }
        modal.classList.add('hidden');
    };
    newOk.addEventListener('click', () => finish(true));
    newCa.addEventListener('click', () => finish(false));
    newCl.addEventListener('click', () => finish(false));
}

// Live event push from the server. We buffer regardless of which
// page is active so that when the admin switches to Event Logs they
// see the latest rows even if they were on another page when they
// arrived. Re-rendering only happens when the page is actually open.
window.addEventListener('message', e => {
    if (!state.eventLogs) state.eventLogs = { rows: [], rules: [], filter: '', live: true };
    const a = e.data?.action;
    if (a === 'panel:event') {
        if (state.eventLogs.live === false) return;
        state.eventLogs.rows.unshift(e.data.row);
        if (state.eventLogs.rows.length > 500) state.eventLogs.rows.length = 500;
        if (state.page === 'events') renderEventFeed();
    } else if (a === 'panel:eventRules') {
        state.eventLogs.rules = e.data.rules || [];
        if (state.page === 'events') renderEventRules();
    } else if (a === 'panel:eventLogsCleared') {
        state.eventLogs.rows = [];
        if (state.page === 'events') renderEventFeed();
    }
});

// Page-level wiring.
document.addEventListener('click', e => {
    if (e.target.closest('#ev-refresh')) loadEvents();
    if (e.target.closest('#ev-clear'))   { fire('clearEventLogs'); reloadSoon(loadEvents); }
    if (e.target.closest('#ev-rule-new')) openEventRuleModal('');
    const tab = e.target.closest('.ap-ev-tab');
    if (tab) {
        state.eventLogs.tab = tab.dataset.evTab || 'all';
        $$('.ap-ev-tab').forEach(t => t.classList.toggle('active', t === tab));
        renderEventFeed();
    }
});
document.addEventListener('input', e => {
    if (e.target?.id === 'ev-search') { state.eventLogs.filter = e.target.value; renderEventFeed(); }
});
document.addEventListener('change', e => {
    if (e.target?.id === 'ev-live') state.eventLogs.live = e.target.checked;
});

/* ============================================================
   STAFF
   ============================================================ */
async function loadStaff() {
    const res = await callback('staff');
    // null = the server refused (it has already said why in a toast).
    state.staff = res || { groups: {}, members: {}, denied: true };
    renderStaffMembers();
    renderStaffGroups();
    renderStaffMe();
}

// "You are: Owner · all permissions" above the lists, from the bootstrap.
// An admin who cannot see why a button does nothing can now read what
// their own group holds right next to the groups they edit.
function renderStaffMe() {
    const el = $('#st-me');
    if (!el) return;
    const b = state.boot || {};
    const perms = Array.isArray(b.permissions) ? b.permissions : null;
    const label = b.groupLabel || b.group || '—';
    let what;
    if (!perms) what = 'no staff group';
    else if (perms.includes('*')) what = 'all permissions';
    else if (perms.length === 0) what = 'NO permissions';
    else what = `${perms.length} permission${perms.length === 1 ? '' : 's'}`;
    const src = b.permSource === 'ace-fallback' ? ' (ACE admin, Admin set)'
              : b.permSource === 'framework'    ? ' (framework group)' : '';
    el.innerHTML = `<i class="fa-solid fa-id-badge"></i> You are <strong>${escapeHTML(label)}</strong> · ${escapeHTML(what)}${escapeHTML(src)}`;
    el.title = perms ? perms.join(', ') : '';
    el.classList.toggle('warn', !!perms && perms.length === 0);
}

// Second net for the "same admin twice" report: whatever the server sent,
// two entries whose licenses are the same account in different spellings
// (license:X / X / license2:… / char1:X) collapse into one card. Online
// wins, then a Staff-page row over a framework-detected one. The server
// does the same merge (PanelLicKey); this keeps the page right even if a
// stale server file is still running underneath a fresh page.
function staffKey(lic) {
    return String(lic || '').trim().toLowerCase().replace(/^char\d+:/, '').replace(/^license2?:/, '');
}
function dedupeStaffEntries(entries) {
    const byKey = new Map();
    const rank = ([, m]) => (m.online ? 2 : 0) + (m.source !== 'framework' ? 1 : 0);
    for (const e of entries) {
        const k = staffKey(e[0]) || e[0];
        const prev = byKey.get(k);
        if (!prev || rank(e) > rank(prev)) byKey.set(k, e);
    }
    return Array.from(byKey.values());
}

function renderStaffMembers() {
    const wrap = document.querySelector('#st-members-grid');
    if (!wrap) return;
    const groups  = state.staff.groups || {};
    const entries = dedupeStaffEntries(Object.entries(state.staff.members || {}));
    // Sort: online first, then by group hierarchy, then by nickname.
    entries.sort((a, b) => {
        const [, ma] = a, [, mb] = b;
        if (!!mb.online - !!ma.online) return (!!mb.online) - (!!ma.online);
        const ha = groups[ma.group_name]?.hierarchy ?? 999;
        const hb = groups[mb.group_name]?.hierarchy ?? 999;
        if (ha !== hb) return ha - hb;
        return (ma.nickname || '').localeCompare(mb.nickname || '');
    });

    if (entries.length === 0) {
        wrap.innerHTML = state.staff.denied
            ? `<div class="ap-empty" style="padding:40px 16px">
                <i class="fa-solid fa-lock"></i>
                <div style="margin-top:6px">Your group needs <code>staff.read</code> to see this page</div>
              </div>`
            : `<div class="ap-empty" style="padding:40px 16px">
                <i class="fa-regular fa-user"></i>
                <div style="margin-top:6px">No staff members yet</div>
              </div>`;
        return;
    }

    // Seed cache from this response.
    entries.forEach(([lic, m]) => {
        if (lic && m.avatar) rememberAvatar(lic, m.avatar);
    });

    wrap.innerHTML = entries.map(([lic, m]) => {
        const grp     = groups[m.group_name] || {};
        const color   = grp.color || '#7C7C82';
        const label   = grp.label || m.group_name || '—';
        const url     = m.avatar || avatarCache.get(lic) || '';
        const initial = (m.nickname || '?').toString().substring(0, 1).toUpperCase();
        const onlineBadge = m.online
            ? `<span class="ap-staff-dot online" title="Online"></span>`
            : `<span class="ap-staff-dot offline" title="Offline"></span>`;
        const sourceTag = m.source === 'framework'
            ? `<span class="ap-staff-source" title="Detected from framework group">FRAMEWORK</span>`
            : '';
        const lastSeen = m.last_seen ? (() => {
            // last_seen comes through as a raw epoch (ms or s) — format it
            // to a readable local date instead of dumping the number.
            let n = Number(m.last_seen), txt = m.last_seen;
            if (isFinite(n)) { if (n < 1e12) n *= 1000; const dt = new Date(n); if (!isNaN(dt.getTime())) txt = dt.toLocaleString(); }
            return `<small class="ap-muted">Last seen ${escapeHTML(String(txt))}</small>`;
        })() : '';
        const editable = m.source !== 'framework';   // framework-detected entries aren't in apex_staff
        return `
        <div class="ap-staff-card" style="--group-color:${color}">
            <div class="ap-staff-card-top">
                <div class="ap-staff-av ap-av${url ? ' has-img' : ''}"
                     data-license="${escapeHTML(lic)}"
                     data-avatar-painted="${url ? 1 : 0}"
                     style="${url ? `background-image:url(${JSON.stringify(url)});background-size:cover;background-position:center` : ''}">
                    ${url ? '' : `<span class="ap-av-fallback">${initial}</span>`}
                </div>
                ${onlineBadge}
            </div>
            <div class="ap-staff-card-body">
                <div class="ap-staff-name">${escapeHTML(m.nickname || m.last_name || '—')}</div>
                <div class="ap-staff-group">
                    <span class="ap-staff-group-dot" style="background:${color}"></span>
                    <span style="color:${color}">${escapeHTML(label)}</span>
                    ${sourceTag}
                </div>
                <code class="ap-staff-lic" title="${escapeHTML(lic)}">${escapeHTML(lic)}</code>
                ${lastSeen}
            </div>
            <div class="ap-staff-card-actions">
                ${m.online_id ? `<button class="ap-icon-btn" title="Open profile" onclick="window._openPlayer(${m.online_id})"><i class="fa-solid fa-arrow-up-right-from-square"></i></button>` : ''}
                ${editable ? `<button class="ap-icon-btn" title="Edit" onclick="window._mEdit('${escapeHTML(lic)}')"><i class="fa-solid fa-pen"></i></button>` : ''}
                <button class="ap-icon-btn danger" title="${editable ? 'Remove staff' : 'Staff through a framework group — cannot be removed here'}" onclick="window._mDel('${escapeHTML(lic)}')"><i class="fa-solid fa-trash"></i></button>
            </div>
        </div>`;
    }).join('');

    // Synchronous paint pass for the avatars we just rendered.
    wrap.querySelectorAll('[data-license]').forEach(el => {
        el.dataset.avatarPainted = '0';
        paintAvatarNode(el);
    });
}

function renderStaffGroups() {
    const wrap = document.querySelector('#st-groups-grid');
    if (!wrap) return;
    const groups = state.staff.groups || {};
    // Count members in each group.
    const memberCount = {};
    Object.values(state.staff.members || {}).forEach(m => {
        memberCount[m.group_name] = (memberCount[m.group_name] || 0) + 1;
    });
    const entries = Object.entries(groups).sort((a, b) => a[1].hierarchy - b[1].hierarchy);
    if (entries.length === 0) {
        wrap.innerHTML = `<div class="ap-empty" style="padding:40px 16px">
            <i class="fa-solid fa-layer-group"></i>
            <div style="margin-top:6px">${state.staff.denied ? 'Your group needs <code>staff.read</code> to see the groups' : 'No staff groups'}</div>
        </div>`;
        return;
    }
    wrap.innerHTML = entries.map(([name, g]) => {
        const color = g.color || '#1F5EFF';
        const count = memberCount[name] || 0;
        const list  = g.permissions || [];
        // "1 permission" for the owner's ["*"] read as a broken group to a
        // customer, who then tried to "fix" it. Say what it means.
        const permsText = list.includes('*') ? '<strong>All</strong><small>permissions</small>'
            : list.length === 0 ? '<strong class="ap-danger-text">None</strong><small>permissions · nothing works</small>'
            : `<strong>${list.length}</strong><small>permission${list.length === 1 ? '' : 's'}</small>`;
        return `
        <div class="ap-staff-group-card" style="--group-color:${color}">
            <div class="ap-staff-group-card-head">
                <div class="ap-staff-group-id">
                    <span class="ap-staff-group-hex">#${g.hierarchy}</span>
                    <div>
                        <div class="ap-staff-group-label" style="color:${color}">${escapeHTML(g.label)}</div>
                        <code class="ap-staff-group-name">${escapeHTML(name)}</code>
                    </div>
                </div>
                <div class="ap-staff-group-actions">
                    <button class="ap-icon-btn" title="Edit" onclick="window._gEdit('${escapeHTML(name)}')"><i class="fa-solid fa-pen"></i></button>
                    ${name !== 'owner' ? `<button class="ap-icon-btn danger" title="Delete" onclick="window._gDel('${escapeHTML(name)}')"><i class="fa-solid fa-trash"></i></button>` : ''}
                </div>
            </div>
            <div class="ap-staff-group-stats">
                <div class="ap-staff-group-stat">
                    <i class="fa-solid fa-users"></i>
                    <strong>${count}</strong>
                    <small>member${count === 1 ? '' : 's'}</small>
                </div>
                <div class="ap-staff-group-stat" title="${escapeHTML(list.join(', '))}">
                    <i class="fa-solid fa-key"></i>
                    ${permsText}
                </div>
            </div>
        </div>`;
    }).join('');
}

// Quick "open profile" used by staff cards for online members.
window._openPlayer = (id) => {
    setPage('players');
    setTimeout(() => selectPlayer(id), 180);
};
// Staff changes wait for the server's verdict (staff* callbacks) and then
// reload, instead of firing and reloading on a 300 ms guess that usually beat
// the database write. A refusal comes back with its reason as a toast.
async function staffAction(name, ...args) {
    const res = await callback(name, ...args);
    if (!res || res.ok !== true) {
        showToast((res && res.error) || 'The server did not answer. Is apex_adminmenu up to date and restarted?', 'error', 6000);
        return false;
    }
    await loadStaff();
    return true;
}
// Group names the prompt offers, with the most common pick first.
function staffGroupHint() {
    const names = Object.keys(state.staff.groups || {});
    names.sort((a, b) => (state.staff.groups[a]?.hierarchy ?? 99) - (state.staff.groups[b]?.hierarchy ?? 99));
    return names.length ? names.join(', ') : 'owner, admin, moderator, helper';
}
function staffDefaultGroup() {
    const g = state.staff.groups || {};
    return g.moderator ? 'moderator' : (Object.keys(g).find(n => n !== 'owner') || 'moderator');
}
/* ── Permission catalogue ─────────────────────────────────────
   Every key the server gates on (server/adminpanel.lua, PanelRequire /
   PanelHasPerm), grouped by namespace. `ns.*` grants a whole block and `*`
   grants everything. The group editor below is built from this list, so
   an operator never has to type keys by hand again: the old editor was
   three chained text prompts and a comma-separated string, which is how a
   custom group ended up with zero permissions and "nothing works". */
const PERM_CATALOG = [
    { ns: 'players',    label: 'Players',       actions: [['read', 'View players, Home map'], ['teleport', 'Teleport / bring'], ['revive', 'Revive / respawn'], ['heal', 'Heal, set health / armour'], ['freeze', 'Freeze'], ['spectate', 'Spectate, watch screen, screenshot'], ['flag', 'Flag players']] },
    { ns: 'moderation', label: 'Moderation',    actions: [['kick', 'Kick'], ['ban', 'Ban / unban'], ['warn', 'Warn'], ['jail', 'Jail']] },
    { ns: 'money',      label: 'Money',         actions: [['give', 'Give money']] },
    { ns: 'items',      label: 'Items',         actions: [['read', 'Items page'], ['give', 'Give / remove items and weapons']] },
    { ns: 'vehicles',   label: 'Vehicles',      actions: [['read', 'Vehicles page'], ['spawn', 'Spawn for a player'], ['fix', 'Fix / clean'], ['delete', 'Delete vehicles']] },
    { ns: 'jobs',       label: 'Jobs',          actions: [['read', 'Jobs page'], ['write', 'Create, edit, delete jobs']] },
    { ns: 'utility',    label: 'Utility',       actions: [['announce', 'Announce'], ['time', 'Set time'], ['weather', 'Set weather']] },
    { ns: 'chat',       label: 'Staff chat',    actions: [['read', 'Read'], ['write', 'Send messages']] },
    { ns: 'reports',    label: 'Reports',       actions: [['read', 'View reports'], ['assist', 'Accept / assist']] },
    { ns: 'console',    label: 'Console',       actions: [['read', 'Read the live console'], ['exec', 'Run commands']] },
    { ns: 'resources',  label: 'Resources',     actions: [['read', 'List resources'], ['write', 'Start / stop / restart']] },
    { ns: 'events',     label: 'Events',        actions: [['read', 'View events'], ['write', 'Create / edit events']] },
    { ns: 'blips',      label: 'Blips',         actions: [['read', 'View blips'], ['write', 'Create / edit blips']] },
    { ns: 'logs',       label: 'Logs',          actions: [['read', 'Logs page']] },
    { ns: 'settings',   label: 'Server settings', actions: [['write', 'Save server settings, webhooks, event rules']] },
    { ns: 'staff',      label: 'Staff',         actions: [['read', 'Staff page'], ['write', 'Manage members and groups']] },
];
// PERM-PURE-BEGIN (covered by perm_test.js)
// A permission list -> editor state: { all, ns: { [ns]: { all, actions:Set } }, extra: [] }.
function permsToEditorState(list) {
    const st = { all: false, ns: {}, extra: [] };
    PERM_CATALOG.forEach(c => { st.ns[c.ns] = { all: false, actions: new Set() }; });
    (list || []).forEach(raw => {
        const p = String(raw || '').trim();
        if (!p) return;
        if (p === '*') { st.all = true; return; }
        const dot = p.indexOf('.');
        const ns = dot > 0 ? p.slice(0, dot) : p, act = dot > 0 ? p.slice(dot + 1) : '';
        const cat = PERM_CATALOG.find(c => c.ns === ns);
        if (!cat) { st.extra.push(p); return; }
        if (act === '*') { st.ns[ns].all = true; return; }
        if (cat.actions.some(a => a[0] === act)) st.ns[ns].actions.add(act);
        else st.extra.push(p);
    });
    return st;
}
// Editor state -> the list saved to the server. `*` alone when everything is
// granted; `ns.*` only when that block's "all" box is ticked (single actions
// stay single, so what the operator sees is what gets stored); unknown keys
// the group already had are kept so an edit never silently drops something
// another script reads.
function editorStateToPerms(st) {
    if (st.all) return ['*'];
    const out = [];
    PERM_CATALOG.forEach(c => {
        const s = st.ns[c.ns];
        if (!s) return;
        if (s.all) { out.push(c.ns + '.*'); return; }
        c.actions.forEach(a => { if (s.actions.has(a[0])) out.push(c.ns + '.' + a[0]); });
    });
    (st.extra || []).forEach(p => { if (!out.includes(p)) out.push(p); });
    return out;
}
// PERM-PURE-END

const GROUP_COLORS = ['#E5564B', '#1F5EFF', '#4E9CE5', '#E5A93C', '#34C77B', '#A66DF0', '#F06292', '#8D6E63', '#7C7C82'];

// Group editor: label, internal name (new groups only), rank, colour and the
// permission checklist. Replaces the three chained prompts.
function openGroupEditor(name) {
    const isNew = !name;
    const g = isNew ? { label: '', hierarchy: 5, color: '#1F5EFF', permissions: [] } : (state.staff.groups[name] || {});
    const st = permsToEditorState(g.permissions || []);
    const modal = $('#ap-modal');
    modal.classList.add('ap-modal-wide');
    $('#ap-modal-title').textContent = isNew ? 'New staff group' : `Edit group · ${name}`;
    const body = $('#ap-modal-body');
    body.innerHTML = `
        <div class="ap-group-editor">
            <div class="ap-group-editor-fields">
                <label class="ap-form-row"><span>Label</span>
                    <input class="ap-input" id="ge-label" value="${escapeHTML(g.label || '')}" placeholder="Server Management"></label>
                <label class="ap-form-row"><span>Internal name</span>
                    <input class="ap-input" id="ge-name" value="${escapeHTML(name || '')}" placeholder="servermanagement" ${isNew ? '' : 'disabled'}></label>
                <label class="ap-form-row"><span>Rank (0 = top, owner)</span>
                    <input class="ap-input" id="ge-rank" type="number" min="0" max="99" value="${escapeHTML(String(g.hierarchy ?? 5))}"></label>
                <div class="ap-form-row"><span>Colour</span>
                    <div class="ap-group-colors" id="ge-colors">${GROUP_COLORS.map(c => `<button type="button" class="ap-group-color${(g.color || '').toLowerCase() === c.toLowerCase() ? ' active' : ''}" data-color="${c}" style="background:${c}"></button>`).join('')}</div>
                </div>
            </div>
            <label class="ap-switch-row ap-perm-all">
                <span><strong>All permissions (*)</strong><small>Owner level: every page and every action, including managing staff.</small></span>
                <input type="checkbox" id="ge-all" ${st.all ? 'checked' : ''}>
            </label>
            <div class="ap-perm-grid" id="ge-perms"></div>
            <div class="ap-perm-summary" id="ge-summary"></div>
        </div>`;
    let color = g.color || '#1F5EFF';
    body.querySelectorAll('.ap-group-color').forEach(b => b.addEventListener('click', () => {
        color = b.dataset.color;
        body.querySelectorAll('.ap-group-color').forEach(x => x.classList.toggle('active', x === b));
    }));

    const grid = $('#ge-perms');
    function renderGrid() {
        const all = $('#ge-all').checked;
        grid.classList.toggle('disabled', all);
        grid.innerHTML = PERM_CATALOG.map(c => {
            const s = st.ns[c.ns];
            return `
            <div class="ap-perm-ns" data-ns="${c.ns}">
                <label class="ap-perm-ns-head">
                    <input type="checkbox" data-ns-all="${c.ns}" ${s.all ? 'checked' : ''}>
                    <strong>${escapeHTML(c.label)}</strong><code>${c.ns}.*</code>
                </label>
                ${c.actions.map(([a, lbl]) => `
                <label class="ap-perm-row${s.all ? ' implied' : ''}">
                    <input type="checkbox" data-perm="${c.ns}.${a}" ${s.all || s.actions.has(a) ? 'checked' : ''} ${s.all ? 'disabled' : ''}>
                    <span>${escapeHTML(lbl)}</span><code>${c.ns}.${a}</code>
                </label>`).join('')}
            </div>`;
        }).join('');
        renderSummary();
    }
    function renderSummary() {
        const list = editorStateToPerms(currentState());
        const el = $('#ge-summary');
        if (list.includes('*')) el.innerHTML = '<i class="fa-solid fa-crown"></i> This group can do everything.';
        else if (list.length === 0) el.innerHTML = '<i class="fa-solid fa-triangle-exclamation"></i> <strong>No permissions:</strong> members of this group can open the panel and do nothing else.';
        else el.innerHTML = `<i class="fa-solid fa-key"></i> ${list.length} entr${list.length === 1 ? 'y' : 'ies'}: <code>${escapeHTML(list.join(', '))}</code>`;
        el.classList.toggle('warn', list.length === 0);
    }
    function currentState() {
        return { all: $('#ge-all').checked, ns: st.ns, extra: st.extra };
    }
    grid.addEventListener('change', e => {
        const t = e.target;
        if (t.dataset.nsAll) { st.ns[t.dataset.nsAll].all = t.checked; renderGrid(); return; }
        if (t.dataset.perm) {
            const [ns, act] = t.dataset.perm.split('.');
            if (t.checked) st.ns[ns].actions.add(act); else st.ns[ns].actions.delete(act);
            renderSummary();
        }
    });
    $('#ge-all').addEventListener('change', renderGrid);
    renderGrid();

    const okBtn = replaceWithClone('#ap-modal-ok'), cancelBtn = replaceWithClone('#ap-modal-cancel'), closeBtn = replaceWithClone('#ap-modal-close');
    okBtn.textContent = isNew ? 'Create group' : 'Save group';
    cancelBtn.textContent = 'Cancel';
    const hide = () => { modal.classList.add('hidden'); modal.classList.remove('ap-modal-wide'); };
    cancelBtn.addEventListener('click', hide);
    closeBtn.addEventListener('click', hide);
    okBtn.addEventListener('click', async () => {
        const label = $('#ge-label').value.trim();
        const iname = (isNew ? $('#ge-name').value : name).trim().toLowerCase().replace(/[^a-z0-9_-]/g, '');
        const rank  = parseInt($('#ge-rank').value, 10);
        if (!iname) { showToast('The group needs an internal name (letters, numbers, _ or -).', 'warning'); return; }
        if (!label) { showToast('Give the group a label.', 'warning'); return; }
        if (isNew && state.staff.groups[iname]) { showToast(`A group called "${iname}" already exists.`, 'warning'); return; }
        const perms = editorStateToPerms(currentState());
        okBtn.disabled = true;
        const ok = await staffAction('staffSaveGroup', iname, label, isNaN(rank) ? 5 : rank, perms, color);
        okBtn.disabled = false;
        if (ok) {
            hide();
            showToast(isNew ? `Group "${label}" created.` : `Group "${label}" saved.`, 'success');
            if (perms.length === 0) showToast('That group has no permissions yet: its members can open the panel and nothing else.', 'warning', 7000);
        }
    });
    modal.classList.remove('hidden');
    setTimeout(() => $(isNew ? '#ge-name' : '#ge-label')?.focus(), 30);
}

// Member editor: license / server id, nickname and a group picker.
function openMemberEditor(lic) {
    const isNew = !lic;
    const m = isNew ? {} : (state.staff.members[lic] || {});
    const groups = Object.entries(state.staff.groups || {}).sort((a, b) => (a[1].hierarchy ?? 99) - (b[1].hierarchy ?? 99));
    const current = m.group_name || staffDefaultGroup();
    $('#ap-modal-title').textContent = isNew ? 'Add staff member' : `Edit member · ${m.nickname || lic}`;
    const body = $('#ap-modal-body');
    body.innerHTML = `
        <label class="ap-form-row"><span>${isNew ? 'License (license:…) or server ID of an online player' : 'License'}</span>
            <input class="ap-input" id="me-lic" value="${escapeHTML(lic || '')}" placeholder="12  or  license:0123abcd…" ${isNew ? '' : 'disabled'}></label>
        <label class="ap-form-row"><span>Nickname (empty = their FiveM name)</span>
            <input class="ap-input" id="me-nick" value="${escapeHTML(m.nickname || '')}"></label>
        <label class="ap-form-row"><span>Group</span>
            <select class="ap-input" id="me-group">${groups.map(([n, g]) => {
                const list = g.permissions || [];
                const hint = list.includes('*') ? 'all permissions' : list.length === 0 ? 'NO permissions' : `${list.length} permission${list.length === 1 ? '' : 's'}`;
                return `<option value="${escapeHTML(n)}" ${n === current ? 'selected' : ''}>${escapeHTML(g.label || n)} (${escapeHTML(n)}) · ${hint}</option>`;
            }).join('')}</select></label>
        <div class="ap-perm-summary" id="me-summary"></div>`;
    const sel = $('#me-group');
    const summarise = () => {
        const g = state.staff.groups[sel.value] || {};
        const list = g.permissions || [];
        const el = $('#me-summary');
        if (list.includes('*')) el.innerHTML = '<i class="fa-solid fa-crown"></i> Owner level: everything.';
        else if (list.length === 0) el.innerHTML = '<i class="fa-solid fa-triangle-exclamation"></i> <strong>This group has no permissions.</strong> Edit it under Staff Groups first.';
        else el.innerHTML = `<i class="fa-solid fa-key"></i> <code>${escapeHTML(list.join(', '))}</code>`;
        el.classList.toggle('warn', list.length === 0);
    };
    sel.addEventListener('change', summarise);
    summarise();
    const okBtn = replaceWithClone('#ap-modal-ok'), cancelBtn = replaceWithClone('#ap-modal-cancel'), closeBtn = replaceWithClone('#ap-modal-close');
    okBtn.textContent = isNew ? 'Add member' : 'Save member';
    cancelBtn.textContent = 'Cancel';
    const hide = () => $('#ap-modal').classList.add('hidden');
    cancelBtn.addEventListener('click', hide);
    closeBtn.addEventListener('click', hide);
    okBtn.addEventListener('click', async () => {
        const who  = (isNew ? $('#me-lic').value : lic).trim();
        const nick = $('#me-nick').value.trim();
        if (!who) { showToast('Enter a license or the server ID of an online player.', 'warning'); return; }
        okBtn.disabled = true;
        const ok = await staffAction('staffSaveMember', who, nick, sel.value, m.avatar || '');
        okBtn.disabled = false;
        if (ok) { hide(); showToast(isNew ? 'Staff member added.' : 'Staff member saved.', 'success'); }
    });
    $('#ap-modal').classList.remove('hidden');
    setTimeout(() => $(isNew ? '#me-lic' : '#me-nick')?.focus(), 30);
}

window._mEdit = (lic) => openMemberEditor(lic);
window._mDel = async (lic) => {
    const m = state.staff.members[lic] || {};
    // A framework-detected card has no row here to remove. The old flow
    // confirmed, "removed" nothing and showed the card again — "nothing
    // changed". Say what is going on instead.
    if (m.source === 'framework') {
        showToast(`${m.nickname || lic} is staff through the framework group "${m.group_name || '?'}", not through this page. `
            + 'Change their group in your framework (users.group / players.permission) or server.cfg; there is nothing to remove here.', 'info', 9000);
        return;
    }
    if (!await confirmDialog('Remove staff member', `Remove ${m.nickname || lic} from the staff list? They keep any framework group they have.`, { okLabel: 'Remove', danger: true })) return;
    if (await staffAction('staffRemoveMember', lic)) showToast('Staff member removed.', 'success');
};
window._gEdit = (name) => openGroupEditor(name);
window._gDel = async (name) => {
    if (!await confirmDialog('Delete staff group', `Delete the group "${name}"? Members left in it lose every permission until they are moved.`, { okLabel: 'Delete', danger: true })) return;
    if (await staffAction('staffDeleteGroup', name)) showToast('Group deleted.', 'success');
};
$('#st-member-add').addEventListener('click', () => openMemberEditor(null));
$('#st-group-add').addEventListener('click', () => openGroupEditor(null));

/* ============================================================
   BLIPS
   ============================================================ */
/* ============================================================
   BLIPS — full design with color/sprite pickers
   ============================================================ */

// Colour palette taken from the GTA blip colour table (1-25 most-used).
const BLIP_COLORS = [
    { id: 0,  hex: '#FFFFFF', name: 'White' },
    { id: 1,  hex: '#E5564B', name: 'Red' },
    { id: 2,  hex: '#34C77B', name: 'Green' },
    { id: 3,  hex: '#4E9CE5', name: 'Blue' },
    { id: 4,  hex: '#FFFFFF', name: 'White 2' },
    { id: 5,  hex: '#F0B429', name: 'Yellow' },
    { id: 6,  hex: '#E5A93C', name: 'Light Orange' },
    { id: 7,  hex: '#A66DF0', name: 'Purple' },
    { id: 8,  hex: '#F26DA7', name: 'Pink' },
    { id: 9,  hex: '#E5A93C', name: 'Orange' },
    { id: 10, hex: '#7D7D7D', name: 'Light Gray' },
    { id: 11, hex: '#88BC4F', name: 'Lime' },
    { id: 12, hex: '#5E6E6E', name: 'Dark Cyan' },
    { id: 13, hex: '#AC9C7A', name: 'Beige' },
    { id: 14, hex: '#666666', name: 'Gray' },
    { id: 15, hex: '#E5564B', name: 'Red 2' },
    { id: 16, hex: '#E5A93C', name: 'Orange 2' },
    { id: 17, hex: '#34C77B', name: 'Green 2' },
    { id: 18, hex: '#4E9CE5', name: 'Blue 2' },
    { id: 19, hex: '#A66DF0', name: 'Purple 2' },
    { id: 20, hex: '#1F6FB6', name: 'Navy' },
    { id: 21, hex: '#1F8A4F', name: 'Forest' },
    { id: 22, hex: '#7C2D2D', name: 'Burgundy' },
    { id: 23, hex: '#D1D1D1', name: 'Silver' },
    { id: 24, hex: '#E5564B', name: 'Bright Red' },
    { id: 25, hex: '#88BC4F', name: 'Toxic' }
];

// Curated short list of common sprites with friendly names.
// Blip catalogue — id, name, and (optional) explicit image filename.
// When `img` is missing we default to `<name>.png`. The FiveM docs CDN
// serves these directly so we don't need to bundle any artwork.
const BLIP_SPRITES = [
    { id: 0,   name: 'radar_higher',         img: 'radar_higher.gif' },
    { id: 1,   name: 'radar_level' },
    { id: 2,   name: 'radar_lower',          img: 'radar_lower.gif' },
    { id: 3,   name: 'radar_police_ped',     img: 'radar_police_ped.gif' },
    { id: 4,   name: 'radar_wanted_radius' },
    { id: 5,   name: 'radar_area_blip' },
    { id: 6,   name: 'radar_centre' },
    { id: 7,   name: 'radar_north' },
    { id: 8,   name: 'radar_waypoint' },
    { id: 9,   name: 'radar_radius_blip' },
    { id: 10,  name: 'radar_radius_outline_blip' },
    { id: 11,  name: 'radar_weapon_higher',  img: 'radar_weapon_higher.gif' },
    { id: 12,  name: 'radar_weapon_lower',   img: 'radar_weapon_lower.gif' },
    { id: 13,  name: 'radar_higher_ai',      img: 'radar_higher_ai.gif' },
    { id: 14,  name: 'radar_lower_ai',       img: 'radar_lower_ai.gif' },
    { id: 15,  name: 'radar_police_heli_spin' },
    { id: 16,  name: 'radar_police_plane_move' },
    { id: 27,  name: 'radar_mp_crew' },
    { id: 28,  name: 'radar_mp_friendlies' },
    { id: 36,  name: 'radar_cable_car' },
    { id: 38,  name: 'radar_dollar_sign' },
    { id: 40,  name: 'radar_dropoff' },
    { id: 50,  name: 'radar_pickup' },
    { id: 51,  name: 'radar_destination' },
    { id: 52,  name: 'radar_target_a' },
    { id: 53,  name: 'radar_target_b' },
    { id: 54,  name: 'radar_target_c' },
    { id: 55,  name: 'radar_target_d' },
    { id: 56,  name: 'radar_garage' },
    { id: 57,  name: 'radar_minigun' },
    { id: 58,  name: 'radar_grenade' },
    { id: 60,  name: 'radar_blimp' },
    { id: 67,  name: 'radar_ammu_nation' },
    { id: 68,  name: 'radar_barber' },
    { id: 69,  name: 'radar_bar' },
    { id: 71,  name: 'radar_bowling' },
    { id: 73,  name: 'radar_camera' },
    { id: 76,  name: 'radar_cinema' },
    { id: 77,  name: 'radar_chopper' },
    { id: 78,  name: 'radar_clothes' },
    { id: 80,  name: 'radar_coke' },
    { id: 84,  name: 'radar_devin' },
    { id: 85,  name: 'radar_drugs_package' },
    { id: 89,  name: 'radar_eye' },
    { id: 93,  name: 'radar_garage_2' },
    { id: 100, name: 'radar_garbage' },
    { id: 106, name: 'radar_golf_flag' },
    { id: 108, name: 'radar_gun' },
    { id: 110, name: 'radar_helicopter' },
    { id: 119, name: 'radar_house' },
    { id: 123, name: 'radar_jewelry' },
    { id: 126, name: 'radar_lester' },
    { id: 134, name: 'radar_friend' },
    { id: 135, name: 'radar_lift' },
    { id: 137, name: 'radar_meal' },
    { id: 140, name: 'radar_money' },
    { id: 141, name: 'radar_movie' },
    { id: 146, name: 'radar_michael' },
    { id: 147, name: 'radar_franklin' },
    { id: 148, name: 'radar_trevor' },
    { id: 156, name: 'radar_paintball' },
    { id: 161, name: 'radar_phone' },
    { id: 162, name: 'radar_pickup' },
    { id: 184, name: 'radar_property' },
    { id: 188, name: 'radar_repair' },
    { id: 197, name: 'radar_safe' },
    { id: 207, name: 'radar_solomon' },
    { id: 225, name: 'radar_stripclub' },
    { id: 227, name: 'radar_target_a' },
    { id: 270, name: 'radar_lifeinvader' },
    { id: 280, name: 'radar_tools' },
    { id: 285, name: 'radar_tow_truck' },
    { id: 308, name: 'radar_vehicle' },
    { id: 351, name: 'radar_doctor' },
    { id: 357, name: 'radar_fire_station' },
    { id: 362, name: 'radar_lawyer' },
    { id: 364, name: 'radar_bahama_mamas' },
    { id: 374, name: 'radar_chinese' },
    { id: 401, name: 'radar_mechanic' },
    { id: 402, name: 'radar_mp_friend' },
    { id: 408, name: 'radar_police' },
    { id: 411, name: 'radar_pool' },
    { id: 415, name: 'radar_tennis' },
    { id: 416, name: 'radar_taxi' },
    { id: 419, name: 'radar_ammu_nation_2' },
    { id: 421, name: 'radar_ammu_nation_3' },
    { id: 426, name: 'radar_lester_franklin' },
    { id: 432, name: 'radar_bank' },
    { id: 466, name: 'radar_lsc' },
    { id: 478, name: 'radar_house_purchase' },
    { id: 484, name: 'radar_construction' },
    { id: 487, name: 'radar_admin' },
    { id: 488, name: 'radar_truck' },
    { id: 514, name: 'radar_hospital' },
    { id: 524, name: 'radar_repair' },
    { id: 525, name: 'radar_truck_with_blip' },
    { id: 535, name: 'radar_shooting_range' },
    { id: 545, name: 'radar_office' },
    { id: 556, name: 'radar_finance' },
    { id: 557, name: 'radar_helicopter_2' },
    { id: 568, name: 'radar_ceo' },
    { id: 569, name: 'radar_personal_vehicle' },
    { id: 570, name: 'radar_warehouse' },
    { id: 605, name: 'radar_executive' },
    { id: 617, name: 'radar_bunker' },
    { id: 643, name: 'radar_arena_yellow' },
    { id: 658, name: 'radar_arena_blue' },
    { id: 738, name: 'radar_arcade' }
];

// Build a FiveM docs blip image URL. `?` `radar_xxx` -> filename.
function blipImgUrl(s) {
    const file = s.img || (s.name + '.png');
    return `https://docs.fivem.net/blips/${file}`;
}

async function loadBlips() {
    state.blips = await callback('blips') || [];
    renderBlipsList();
    populateCategoryFilter();
    if (!state.selectedBlip) openBlipEditor({});
}

function populateCategoryFilter() {
    const sel = $('#blip-cat-filter'); if (!sel) return;
    const prev = sel.value || '';
    const cats = Array.from(new Set(state.blips.map(b => b.category || 'Uncategorized'))).sort();
    sel.innerHTML = '<option value="">All categories</option>' +
        cats.map(c => `<option ${c === prev ? 'selected' : ''}>${escapeHTML(c)}</option>`).join('');
}

function renderBlipsList() {
    const wrap = $('#blips-list'); if (!wrap) return;
    const filter = $('#blip-cat-filter')?.value || '';
    wrap.innerHTML = '';

    const byCat = {};
    state.blips
        .filter(b => !filter || (b.category || 'Uncategorized') === filter)
        .forEach(b => {
            const c = b.category || 'Uncategorized';
            (byCat[c] = byCat[c] || []).push(b);
        });

    if (Object.keys(byCat).length === 0) {
        wrap.innerHTML = '<div class="ap-empty" style="padding:30px 12px"><i class="fa-solid fa-location-dot"></i><div style="margin-top:6px">No blips yet</div></div>';
        return;
    }

    Object.entries(byCat).forEach(([cat, blips]) => {
        const h = document.createElement('div');
        h.className = 'ap-blip-cat-label';
        h.textContent = cat;
        wrap.appendChild(h);
        blips.forEach(b => {
            const div = document.createElement('div');
            div.className = 'ap-blip-item' + (state.selectedBlip?.id === b.id ? ' selected' : '');
            const c = BLIP_COLORS.find(c => c.id === b.color) || BLIP_COLORS[0];
            div.innerHTML = `
                <span class="ap-blip-item-name" style="color:${c.hex}">${escapeHTML(b.label || '(no name)')}</span>
                <button class="ap-blip-item-del" title="Delete"><i class="fa-solid fa-trash"></i></button>`;
            div.querySelector('.ap-blip-item-del').addEventListener('click', e => {
                e.stopPropagation();
                fire('deleteBlip', b.id);
                reloadSoon(loadBlips);
            });
            div.addEventListener('click', () => openBlipEditor(b));
            wrap.appendChild(div);
        });
    });
}

function openBlipEditor(b) {
    state.selectedBlip = b || {};
    const v = id => $('#' + id);
    v('be-label').value   = b.label || '';
    v('be-cat').value     = b.category || 'Uncategorized';
    v('be-x').value       = b.x ?? 0;
    v('be-y').value       = b.y ?? 0;
    v('be-z').value       = b.z ?? 0;
    v('be-coords').value  = (b.x !== undefined)
        ? `${(b.x || 0).toFixed(2)}, ${(b.y || 0).toFixed(2)}, ${(b.z || 0).toFixed(2)}`
        : '';
    v('be-display').value = b.display ?? 4;
    v('be-scale').value   = b.scale ?? 1;
    v('be-short').checked = !!b.short_range;
    v('be-color').value   = b.color ?? 1;
    v('be-sprite').value  = b.sprite ?? 1;
    v('be-id').value      = b.id ?? '';

    renderColorGrid(b.color ?? 1, '');
    renderSpriteGrid(b.sprite ?? 1, '');
    renderBlipsList(); // highlight selection
}

function renderColorGrid(active, q) {
    const grid = $('#be-color-grid'); if (!grid) return;
    grid.innerHTML = '';
    const needle = (q || '').toLowerCase();
    BLIP_COLORS
        .filter(c => !needle || c.name.toLowerCase().includes(needle) || String(c.id) === needle)
        .forEach(c => {
            const dot = document.createElement('div');
            dot.className = 'ap-color-dot' + (c.id === active ? ' active' : '');
            dot.style.background = c.hex;
            dot.textContent = c.id;
            dot.title = c.name;
            dot.addEventListener('click', () => {
                $('#be-color').value = c.id;
                renderColorGrid(c.id, $('#be-color-search').value);
                renderBlipsList(); // colour name in list changes
            });
            grid.appendChild(dot);
        });
}

function renderSpriteGrid(active, q) {
    const grid = $('#be-sprite-grid'); if (!grid) return;
    grid.innerHTML = '';
    const needle = (q || '').toLowerCase();
    const matches = BLIP_SPRITES.filter(s =>
        !needle || s.name.toLowerCase().includes(needle) || String(s.id).includes(needle));

    if (matches.length === 0) {
        grid.innerHTML = `<div class="ap-empty" style="grid-column:1/-1;padding:30px 12px">
            <i class="fa-regular fa-image"></i>
            <div style="margin-top:6px">No sprites match "${escapeHTML(q || '')}"</div>
        </div>`;
        return;
    }

    matches.forEach(s => {
        const cell = document.createElement('button');
        cell.type = 'button';
        cell.className = 'ap-sprite-cell' + (s.id === active ? ' active' : '');
        cell.title = `${s.id} · ${s.name}`;
        const url   = blipImgUrl(s);
        const label = s.name.replace(/^radar_/, '');
        cell.innerHTML = `
            <div class="ap-sprite-cell-icon">
                <img src="${url}" alt="${escapeHTML(label)}" loading="lazy"
                     onerror="this.classList.add('failed');this.replaceWith(Object.assign(document.createElement('i'),{className:'fa-solid fa-location-dot ap-sprite-fallback'}))">
            </div>
            <div class="ap-sprite-cell-name">
                <span class="ap-sprite-id">${s.id}</span>
                <span class="ap-sprite-lbl">${escapeHTML(label)}</span>
            </div>`;
        cell.addEventListener('click', () => {
            $('#be-sprite').value = s.id;
            renderSpriteGrid(s.id, $('#be-sprite-search').value);
        });
        grid.appendChild(cell);
    });
}

// Wire-ups (live).
document.addEventListener('click', e => {
    if (e.target.closest('#blip-new')) openBlipEditor({});
    if (e.target.closest('#be-coords-btn')) {
        myCoords().then(c => {
            $('#be-x').value = c.x.toFixed(2);
            $('#be-y').value = c.y.toFixed(2);
            $('#be-z').value = c.z.toFixed(2);
            $('#be-coords').value = `${c.x.toFixed(2)}, ${c.y.toFixed(2)}, ${c.z.toFixed(2)}`;
        });
    }
    if (e.target.closest('#be-save')) {
        const id = parseInt($('#be-id').value, 10);
        fire('saveBlip', {
            id:    Number.isFinite(id) ? id : null,
            label: $('#be-label').value,
            category: $('#be-cat').value || 'Uncategorized',
            x: parseFloat($('#be-x').value) || 0,
            y: parseFloat($('#be-y').value) || 0,
            z: parseFloat($('#be-z').value) || 0,
            sprite:  parseInt($('#be-sprite').value, 10) || 1,
            color:   parseInt($('#be-color').value, 10) || 1,
            scale:   parseFloat($('#be-scale').value) || 1,
            display: parseInt($('#be-display').value, 10) || 4,
            short_range: $('#be-short').checked
        });
        reloadSoon(loadBlips);
    }
});
document.addEventListener('input', e => {
    if (e.target?.id === 'blip-cat-filter')   renderBlipsList();
    if (e.target?.id === 'be-color-search')   renderColorGrid(parseInt($('#be-color').value, 10), e.target.value);
    if (e.target?.id === 'be-sprite-search')  renderSpriteGrid(parseInt($('#be-sprite').value, 10), e.target.value);
});

/* ============================================================
   LOGS
   ============================================================ */
async function loadLogs() {
    const rows = await callback('logs', {
        category:  $('#logs-cat').value,
        admin_lic: $('#logs-admin').value,
        q:         $('#logs-q').value
    }) || [];
    $('#logs-table thead').innerHTML = `<tr><th>When</th><th>Admin</th><th>Category</th><th>Action</th><th>Target</th><th>Details</th></tr>`;
    if (!rows.length) {
        $('#logs-table tbody').innerHTML = `<tr><td colspan="6"><div class="ap-empty" style="padding:36px 16px"><i class="fa-solid fa-clipboard-list"></i><div style="margin-top:6px">No log entries match these filters</div></div></td></tr>`;
        return;
    }
    $('#logs-table tbody').innerHTML = rows.map(r => `<tr>
        <td><small>${r.created_at}</small></td>
        <td>${r.admin}<br><small class="ap-muted ap-ident">${r.admin_lic}</small></td>
        <td><span class="ap-pill active">${r.category}</span></td>
        <td>${r.action}</td>
        <td>${r.target || '—'}</td>
        <td><small>${r.details || ''}</small></td>
    </tr>`).join('');
}
$('#logs-refresh').addEventListener('click', loadLogs);

/* ============================================================
   SETTINGS
   ============================================================ */
function setAvatarPreview(dataUri) {
    const wrap = $('#set-avatar-preview');
    if (!wrap) return;
    if (dataUri) {
        wrap.innerHTML = '';
        wrap.style.backgroundImage = `url(${JSON.stringify(dataUri)})`;
    } else {
        wrap.style.backgroundImage = '';
        wrap.innerHTML = '<i class="fa-solid fa-user-large"></i>';
    }
}

const setVal = (id, val) => { const el = $('#' + id); if (el) el.value = val; };
const setChk = (id, val) => { const el = $('#' + id); if (el) el.checked = val; };

async function loadSettings() {
    state.settings = await callback('settings') || {};

    // Re-fetching the server copy must not throw away webhook URLs the
    // operator has typed but not saved yet — this runs on every visit to
    // the Settings page, so leaving a tab and coming back used to wipe them.
    const pendingHooks = {};
    if (state.webhooksDirty && state.webhooksDirty.size) {
        const current = (state.globalSettings && state.globalSettings['discord.webhooks']) || {};
        state.webhooksDirty.forEach(k => { pendingHooks[k] = current[k] || ''; });
    }

    state.globalSettings = await callback('globalSettings') || {};

    if (Object.keys(pendingHooks).length) {
        state.globalSettings['discord.webhooks'] =
            Object.assign({}, state.globalSettings['discord.webhooks'] || {}, pendingHooks);
    }

    state.keybinds = await callback('keybinds') || defaultKeybinds();

    // Apply remembered theme + size BEFORE rendering anything else
    // so the rest of the page paints with the right brand colour.
    applyTheme(state.settings.theme || localStorage.getItem('ap-theme') || '#1F5EFF');
    applyBackground(state.settings.bg || localStorage.getItem('ap-bg') || BG_DEFAULT);
    applyPanelSize(state.settings.size || localStorage.getItem('ap-size') || 'l');
    applyDisplayMode(state.settings.mode || localStorage.getItem('ap-mode') || 'dark');
    applyPanelOpacity(state.settings.opacity ?? parseInt(localStorage.getItem('ap-opacity') || '100', 10));

    setChk('set-notif-staff',   state.settings.notif_staff   !== false);
    setChk('set-notif-reports', state.settings.notif_reports !== false);
    setChk('set-notif-off',     !!state.settings.notif_off);
    setChk('set-notif-sound',   state.settings.notif_sound   !== false);
    setVal('set-notif-pos',     state.settings.notif_pos || 'top-right');
    // ── Behaviour tab ───────────────────────────────────────
    setVal('set-auto-refresh',        String(prefRead('auto_refresh')));
    setVal('set-default-page',        prefRead('default_page'));
    setChk('set-remember-page',       prefRead('remember_page'));
    setChk('set-confirm-destructive', prefRead('confirm_destructive'));
    setChk('set-streamer',            prefRead('streamer'));
    setChk('set-compact',             prefRead('compact'));
    setChk('set-reduce-motion',       prefRead('reduce_motion'));
    setChk('set-clock-24',            prefRead('clock_24'));

    // Every setVal() above assigns .value directly, which does NOT fire
    // change — refresh the custom dropdown labels so they don't show a
    // stale option.
    AP_DD.scan();
    AP_DD.syncAll();
    setVal('set-tag-format',    state.settings.tag_format || '[{group}] {name}');
    setChk('set-tag-enable',    !!state.settings.tag_enabled);

    // Global (server-wide) settings — Discord config etc.
    const g = state.globalSettings || {};
    setChk('set-discord-enabled', g['discord.enabled'] !== false);
    setVal('set-discord-username', g['discord.username'] || 'Apex Admin');
    setVal('set-discord-avatar',   g['discord.avatar']   || '');
    // Seed the live preview of the bot identity.
    const namePrev = $('#set-discord-name-preview');
    if (namePrev) namePrev.textContent = g['discord.username'] || 'Apex Admin';
    const avPrev = $('#set-discord-av-preview');
    if (avPrev) {
        const avUrl = g['discord.avatar'] || '';
        if (avUrl) {
            avPrev.style.backgroundImage  = `url(${JSON.stringify(avUrl)})`;
            avPrev.style.backgroundSize   = 'cover';
            avPrev.style.backgroundPosition = 'center';
            avPrev.classList.add('has-img');
            avPrev.innerHTML = '';
        } else {
            avPrev.style.backgroundImage = '';
            avPrev.classList.remove('has-img');
            avPrev.innerHTML = '<i class="fa-brands fa-discord"></i>';
        }
    }
    const evt = g['discord.log_events'] || {};
    setChk('set-evt-moderation', evt.moderation !== false);
    setChk('set-evt-economy',    evt.economy    !== false);
    setChk('set-evt-player',     evt.player     !== false);
    setChk('set-evt-vehicle',    evt.vehicle    !== false);
    setChk('set-evt-staff',      evt.staff      !== false);
    setChk('set-evt-console',    evt.console    !== false);
    setChk('set-evt-reports',    evt.reports    !== false);

    renderWebhookGrid();
    renderKeybindsList();
    updateTagPreview();

    // Apply live UI prefs immediately.
    applyNotificationPosition(state.settings.notif_pos || 'top-right');

    // Also refresh the avatar shown next to the user name in the sidebar.
    if (state.settings.avatar) {
        const me = $('#ap-me-avatar');
        if (me) me.style.backgroundImage = `url(${JSON.stringify(state.settings.avatar)})`;
    }
}

// ── Default keybinds + action catalogue ──────────────────
function defaultKeybinds() {
    return {
        open_panel:     { key: 'F6',    desc: 'Open Admin Panel' },
        open_quickmenu: { key: 'F7',    desc: 'Open Quick Menu' },
        open_reports:   { key: 'PRIOR', desc: 'Reports · Accept next pending' },
        toggle_noclip:  { key: 'F4',    desc: 'Toggle NoClip' }
    };
}
const KEYBIND_ACTIONS = [
    { id: 'open_panel',     label: 'Open Admin Panel',          icon: 'fa-shield-halved' },
    { id: 'open_quickmenu', label: 'Open Quick Menu',           icon: 'fa-bolt' },
    { id: 'open_reports',   label: 'Reports: Accept next',     icon: 'fa-flag' },
    { id: 'resolve_report', label: 'Reports: Resolve current', icon: 'fa-circle-check' },
    { id: 'toggle_noclip',  label: 'Toggle NoClip',             icon: 'fa-person-walking' },
    { id: 'toggle_wallhack',label: 'Toggle Wallhack',           icon: 'fa-eye' },
    { id: 'toggle_stafftag',label: 'Toggle Staff Tag',          icon: 'fa-id-badge' },
    { id: 'spectate_closest',label:'Spectate closest player',   icon: 'fa-binoculars' }
];

function renderKeybindsList() {
    const wrap = $('#set-keybinds-list');
    if (!wrap) return;
    const binds = state.keybinds || {};
    const rows = Object.entries(binds);
    if (rows.length === 0) {
        wrap.innerHTML = `<div class="ap-empty" style="padding:24px 14px">
            <i class="fa-solid fa-keyboard"></i>
            <div style="margin-top:6px">No keybinds yet. Click <b>+ New</b>.</div>
        </div>`;
        return;
    }
    wrap.innerHTML = rows.map(([action, bind]) => {
        const meta = KEYBIND_ACTIONS.find(a => a.id === action) || { label: action, icon: 'fa-circle' };
        return `
        <div class="ap-keybind-row" data-action="${escapeHTML(action)}">
            <div class="ap-keybind-meta">
                <i class="fa-solid ${meta.icon}"></i>
                <div>
                    <strong>${escapeHTML(meta.label)}</strong>
                    <small>${escapeHTML(bind.desc || '')}</small>
                </div>
            </div>
            <button class="ap-keybind-key" data-action="rebind">
                <span>${escapeHTML(bind.key || '—')}</span>
                <i class="fa-solid fa-pen"></i>
            </button>
            <button class="ap-icon-btn danger" data-action="remove" title="Remove keybind">
                <i class="fa-solid fa-trash"></i>
            </button>
        </div>`;
    }).join('');
    wrap.querySelectorAll('.ap-keybind-row').forEach(row => {
        const action = row.dataset.action;
        row.querySelector('[data-action="rebind"]').addEventListener('click', () => captureKey(action));
        row.querySelector('[data-action="remove"]').addEventListener('click', () => {
            delete state.keybinds[action];
            renderKeybindsList();
            fire('saveKeybinds', state.keybinds);
        });
    });
}

// Modal-driven key capture — opens a small overlay, listens for the
// next keypress (excluding modifiers), shows what was caught.
//
// Three ways for the key to arrive, because one was not enough: this
// document's keydown (the normal case), the PARENT document's keydown
// (this panel is an iframe; CEF delivers keys to whichever document holds
// focus, and after a key-opened panel or another NUI taking the focus
// frame that is the parent, not us), and `panel:keyCaptured` from Lua,
// which reads the keyboard through the raw-key natives and does not care
// about document focus at all. The first one to answer wins; the others
// find the capture already closed. There is also a Cancel button and a
// 20 s timeout, so the overlay can never again sit on "Waiting…" with
// every button underneath it unreachable.
const KEYCAP_TIMEOUT_MS = 20000;
state.keyCapture = null;
// Each capture owns the Esc guard until 250 ms after it closes (the keyup of
// the cancelling Escape lands after the keydown). A capture opened inside
// that window must not have its guard dropped by the previous one's timer,
// so the release checks that no newer capture has started since.
let keycapSeq = 0;

function captureKey(action) {
    if (state.keyCapture) state.keyCapture.cancel();
    const mySeq = ++keycapSeq;
    const meta = KEYBIND_ACTIONS.find(a => a.id === action) || { label: action };
    const overlay = document.createElement('div');
    overlay.className = 'ap-keycap-overlay';
    overlay.tabIndex = -1;
    overlay.innerHTML = `
        <div class="ap-keycap-card">
            <i class="fa-solid fa-keyboard"></i>
            <h3>Press a key for "${escapeHTML(meta.label)}"</h3>
            <p>Allowed keys: F1–F12, letters, digits, numpad, PageUp/Down, Home/End, Insert/Delete. Press <kbd>Esc</kbd> to cancel.</p>
            <div class="ap-keycap-hint" id="ap-keycap-hint">Waiting for a key…</div>
            <button type="button" class="ap-btn ap-keycap-cancel" id="ap-keycap-cancel"><i class="fa-solid fa-xmark"></i> Cancel</button>
        </div>`;
    document.body.appendChild(overlay);
    setEscGuard(true);
    // Put the keyboard on this document, in case the click that got us
    // here did not (see the note above).
    try { window.focus(); } catch (_) {}
    try { overlay.focus({ preventScroll: true }); } catch (_) {}

    let done = false;
    const hadKey = !!(state.keybinds[action] && state.keybinds[action].key);

    const accept = k => {
        if (done) return;
        state.keybinds[action] = state.keybinds[action] || {};
        state.keybinds[action].key  = k;
        state.keybinds[action].desc = meta.label;
        $('#ap-keycap-hint').textContent = k;
        renderKeybindsList();
        // The server answers with a toast: "Keybinds saved." or the
        // database error that used to be swallowed.
        fire('saveKeybinds', state.keybinds);
        cleanup();
    };
    const onKey = e => {
        if (done) return;
        e.preventDefault();
        e.stopPropagation();
        if (e.key === 'Escape') return cleanup();
        const k = normaliseKeyForFiveM(e);
        if (!k) {
            $('#ap-keycap-hint').textContent = `Unsupported key "${e.key}". Try another`;
            return;
        }
        accept(k);
    };
    let parentDoc = null;
    try {
        if (window.parent && window.parent !== window) parentDoc = window.parent.document;
    } catch (_) { parentDoc = null; }

    const timer = setTimeout(() => {
        if (done) return;
        showToast('Key capture closed: no key was pressed within 20 seconds.', 'info');
        cleanup();
    }, KEYCAP_TIMEOUT_MS);

    function cleanup() {
        if (done) return;
        done = true;
        clearTimeout(timer);
        document.removeEventListener('keydown', onKey, true);
        if (parentDoc) { try { parentDoc.removeEventListener('keydown', onKey, true); } catch (_) {} }
        overlay.remove();
        state.keyCapture = null;
        // A cancelled capture for an action that never had a key leaves no
        // empty "—" row behind.
        if (!hadKey && state.keybinds[action] && !state.keybinds[action].key) {
            delete state.keybinds[action];
            renderKeybindsList();
        }
        // The keyup of the cancelling Escape arrives after this keydown;
        // keep the guard up until it has passed — unless a newer capture
        // has taken the guard over in the meantime.
        setTimeout(() => { if (keycapSeq === mySeq) setEscGuard(false); }, 250);
    }
    document.addEventListener('keydown', onKey, true);
    if (parentDoc) { try { parentDoc.addEventListener('keydown', onKey, true); } catch (_) {} }
    overlay.querySelector('#ap-keycap-cancel').addEventListener('click', e => { e.stopPropagation(); cleanup(); });

    state.keyCapture = {
        // From Lua (panel:keyCaptured): a key name in RegisterKeyMapping
        // spelling, or ESCAPE to cancel.
        accept: name => {
            if (done) return;
            const k = String(name || '').toUpperCase();
            if (!k) return;
            if (k === 'ESCAPE') return cleanup();
            accept(k);
        },
        cancel: cleanup
    };
}

// Translates a browser KeyboardEvent into the string FiveM's
// RegisterKeyMapping expects (e.g. "F4", "K", "PRIOR" for PageUp).
function normaliseKeyForFiveM(e) {
    const code = e.code || '';
    if (/^F\d{1,2}$/.test(code)) return code;
    if (/^Key[A-Z]$/.test(code)) return code.slice(3);
    if (/^Digit\d$/.test(code))  return code.slice(5);
    if (/^Numpad\d$/.test(code)) return 'NUMPAD' + code.slice(6);
    const map = {
        'PageUp':     'PRIOR',
        'PageDown':   'NEXT',
        'Home':       'HOME',
        'End':        'END',
        'Insert':     'INSERT',
        'Delete':     'DELETE',
        'NumpadAdd':  'ADD',
        'NumpadSubtract': 'SUBTRACT',
        'NumpadMultiply': 'MULTIPLY',
        'NumpadDivide':   'DIVIDE',
        'NumpadEnter':    'NUMPADENTER',
        'BracketLeft':  'LBRACKET',
        'BracketRight': 'RBRACKET',
        'Backslash':    'BACKSLASH',
        'Semicolon':    'SEMICOLON',
        'Quote':        'APOSTROPHE',
        'Comma':        'COMMA',
        'Period':       'PERIOD',
        'Slash':        'SLASH',
        'Minus':        'MINUS',
        'Equal':        'PLUS',
        'Tab':          'TAB',
        'CapsLock':     'CAPITAL'
    };
    if (map[code]) return map[code];
    return null;
}

document.addEventListener('click', e => {
    if (!e.target.closest('#set-keybind-new')) return;
    // Pick the first action that isn't bound yet.
    const used = new Set(Object.keys(state.keybinds || {}));
    const next = KEYBIND_ACTIONS.find(a => !used.has(a.id));
    if (!next) { showToast('Every available action already has a keybind.', 'info'); return; }
    state.keybinds[next.id] = { key: '', desc: next.label };
    renderKeybindsList();
    captureKey(next.id);
});

// ── Discord webhook UI ─────────────────────────────────────
const WEBHOOK_CATEGORIES = [
    { key: 'moderation', label: 'Moderation',    icon: 'fa-gavel',         tone: 'error',   desc: 'Bans / kicks / warns / jails' },
    { key: 'economy',    label: 'Economy',       icon: 'fa-coins',         tone: 'warning', desc: 'Money / items / weapons given' },
    { key: 'player',     label: 'Player',        icon: 'fa-user-large',    tone: 'brand',   desc: 'Heal / revive / freeze / teleport' },
    { key: 'vehicle',    label: 'Vehicle',       icon: 'fa-car',           tone: 'info',    desc: 'Spawn / fix / clean / delete' },
    { key: 'staff',      label: 'Staff',         icon: 'fa-id-card-clip',  tone: 'violet',  desc: 'Logins / off-duty / config changes' },
    { key: 'console',    label: 'Console',       icon: 'fa-terminal',      tone: 'grey',    desc: 'Server-side commands' },
    { key: 'reports',    label: 'Reports',       icon: 'fa-flag',          tone: 'amber',   desc: 'Created / accepted / resolved' },
    { key: 'login',      label: 'Login / Join',  icon: 'fa-door-open',     tone: 'success', desc: 'Player connections & disconnects' },
    { key: 'global',     label: 'Catch-all',     icon: 'fa-globe',         tone: 'brand',   desc: 'Anything that lacks a dedicated route' }
];

// Quick sanity check on a webhook URL. Returns 'ok' | 'empty' | 'invalid'.
function classifyWebhook(url) {
    if (!url) return 'empty';
    const trimmed = url.trim();
    if (trimmed === '') return 'empty';
    if (/^https:\/\/(discord(app)?\.com|ptb\.discord\.com|canary\.discord\.com)\/api\/(v\d+\/)?webhooks\/\d+\/[A-Za-z0-9_-]+/.test(trimmed)) return 'ok';
    return 'invalid';
}

// Categories the operator has edited but not yet saved. loadSettings()
// re-fetches the server copy every time the Settings page is opened, and
// without this it overwrote whatever was half-typed in the boxes — switch
// to another tab and back and the URLs were simply gone.
state.webhooksDirty = new Set();

function renderWebhookGrid() {
    const wrap = $('#set-webhook-grid');
    if (!wrap) return;
    const hooks = (state.globalSettings && state.globalSettings['discord.webhooks']) || {};

    // The server blanks the URLs for anyone who may not edit them. Showing
    // empty, editable boxes that then refuse to save is precisely the
    // behaviour that read as "the panel deleted my webhooks" — so say it.
    const masked = !!(state.globalSettings && state.globalSettings._masked);
    if (masked) {
        wrap.innerHTML = `<div class="ap-empty" style="padding:20px 12px">
            <i class="fa-solid fa-lock"></i>
            <div style="margin-top:6px">Webhook URLs are hidden</div>
            <div style="margin-top:4px;font-size:12px;opacity:.7">
                Your staff group needs the <b>settings.*</b> permission to view or change them.
            </div>
        </div>`;
        return;
    }

    wrap.innerHTML = WEBHOOK_CATEGORIES.map(c => {
        const url = hooks[c.key] || '';
        // Named `st`, not `state`: this used to shadow the global panel
        // state object for the whole of this callback.
        const st  = classifyWebhook(url);
        const dirty = state.webhooksDirty.has(c.key);
        return `
        <div class="ap-discord-route" data-tone="${c.tone}" data-state="${st}">
            <div class="ap-discord-route-icon"><i class="fa-solid ${c.icon}"></i></div>
            <div class="ap-discord-route-meta">
                <strong>${escapeHTML(c.label)}</strong>
                <small>${dirty ? 'Unsaved — press Save changes' : escapeHTML(c.desc)}</small>
            </div>
            <div class="ap-discord-route-input">
                <i class="fa-brands fa-discord"></i>
                <input class="ap-input mono ap-webhook-input" data-key="${c.key}"
                       placeholder="https://discord.com/api/webhooks/..."
                       value="${escapeHTML(url)}">
                <button class="ap-discord-route-clear" data-clear="${c.key}" title="Clear"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <div class="ap-discord-route-status" title="${st === 'ok' ? 'Valid webhook URL' : st === 'invalid' ? 'URL does not look like a Discord webhook' : 'Disabled (empty)'}">
                <i class="fa-solid ${st === 'ok' ? 'fa-circle-check' : st === 'invalid' ? 'fa-triangle-exclamation' : 'fa-circle'}"></i>
            </div>
        </div>`;
    }).join('');
}

document.addEventListener('input', e => {
    if (e.target.classList?.contains('ap-webhook-input')) {
        state.globalSettings = state.globalSettings || {};
        state.globalSettings['discord.webhooks'] = state.globalSettings['discord.webhooks'] || {};
        const url = e.target.value.trim();
        state.globalSettings['discord.webhooks'][e.target.dataset.key] = url;
        state.webhooksDirty.add(e.target.dataset.key);
        // Live update of the validity indicator next to the input.
        const route = e.target.closest('.ap-discord-route');
        if (route) route.dataset.state = classifyWebhook(url);
    }
    // Bot identity live preview.
    if (e.target?.id === 'set-discord-username') {
        $('#set-discord-name-preview') && ($('#set-discord-name-preview').textContent = e.target.value || 'Apex Admin');
    }
    if (e.target?.id === 'set-discord-avatar') {
        const av = $('#set-discord-av-preview');
        if (!av) return;
        const url = e.target.value.trim();
        if (url) {
            av.style.backgroundImage  = `url(${JSON.stringify(url)})`;
            av.style.backgroundSize   = 'cover';
            av.style.backgroundPosition = 'center';
            av.classList.add('has-img');
            av.innerHTML = '';
        } else {
            av.style.backgroundImage = '';
            av.classList.remove('has-img');
            av.innerHTML = '<i class="fa-brands fa-discord"></i>';
        }
    }
});

document.addEventListener('click', e => {
    if (e.target.closest('#set-test-webhook')) {
        fire('testWebhook');
        showToast('Test message sent to your webhooks.', 'info');
        return;
    }
    const clearBtn = e.target.closest('.ap-discord-route-clear');
    if (clearBtn) {
        const key = clearBtn.dataset.clear;
        state.globalSettings = state.globalSettings || {};
        state.globalSettings['discord.webhooks'] = state.globalSettings['discord.webhooks'] || {};
        state.globalSettings['discord.webhooks'][key] = '';
        // Clearing is an edit like any other: it only reaches the server
        // when Save changes is pressed, so it has to survive a re-render.
        state.webhooksDirty.add(key);
        renderWebhookGrid();
    }
});

// Authoritative answer from the server for a global-settings save.
function onGlobalSettingsSaved(ok, message, settings) {
    if (ok) {
        state.webhooksDirty.clear();
        // Re-seed from the server's own copy so what is on screen is what
        // is actually stored — including any normalisation it applied.
        if (settings && typeof settings === 'object') state.globalSettings = settings;
        renderWebhookGrid();
        showToast(message || 'Settings saved.', 'success');
        return;
    }
    // Keep the typed values on screen and flagged as unsaved: they are the
    // operator's work and the server just told us it did not store them.
    showToast(message || 'Settings could not be saved.', 'error');
}

// Notification position applied to the toast container immediately.
function applyNotificationPosition(pos) {
    const c = document.getElementById('ap-toasts');
    if (!c) return;
    c.dataset.pos = pos || 'top-right';
}

// Avatar capture wire-up.
async function captureFace() {
    const btn = $('#set-avatar-snap'); if (!btn) return;
    btn.disabled = true;
    const oldHTML = btn.innerHTML;
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Capturing…';
    try {
        const res = await fetch(`https://${NUI}/panel:faceshot`, { method: 'POST', body: '{}' });
        const data = await res.json();
        if (data && data.dataUri) {
            state.settings = state.settings || {};
            state.settings.avatar = data.dataUri;
            setAvatarPreview(data.dataUri);
            const me = $('#ap-me-avatar');
            if (me) me.style.backgroundImage = `url(${JSON.stringify(data.dataUri)})`;
            // Persist immediately so it's available on next open.
            fire('saveSettings', state.settings);
        }
    } catch (_) {}
    btn.disabled = false;
    btn.innerHTML = oldHTML;
}
document.addEventListener('click', e => {
    if (e.target.closest('#set-avatar-snap'))  captureFace();
    if (e.target.closest('#set-avatar-clear')) {
        state.settings = state.settings || {};
        state.settings.avatar = '';
        setAvatarPreview('');
        const me = $('#ap-me-avatar'); if (me) me.style.backgroundImage = '';
        fire('saveSettings', state.settings);
    }
});
function updateTagPreview() {
    const f = $('#set-tag-format').value
        .replace('{group}', state.boot.groupLabel || state.boot.group || 'Staff')
        .replace('{name}',  state.boot.name || 'Player')
        .replace('{svid}',  'ID')
        .replace('{char_name}', state.boot.name || 'Player')
        .replace('{charId}', '1');
    $('#set-tag-preview').textContent = f;
}
$('#set-tag-format').addEventListener('input', updateTagPreview);
const val = id => { const el = $('#' + id); return el ? el.value : ''; };
const chk = id => { const el = $('#' + id); return el ? el.checked : false; };

document.addEventListener('click', e => {
    if (!e.target.closest('#set-save')) return;
    // Personal settings (per-staff JSON blob).
    const personal = {
        theme:         localStorage.getItem('ap-theme')   || '#1F5EFF',
        bg:            localStorage.getItem('ap-bg')      || BG_DEFAULT,
        size:          localStorage.getItem('ap-size')    || 'l',
        mode:          localStorage.getItem('ap-mode')    || 'dark',
        opacity:       parseInt(localStorage.getItem('ap-opacity') || '100', 10),
        notif_staff:   chk('set-notif-staff'),
        notif_reports: chk('set-notif-reports'),
        notif_off:     chk('set-notif-off'),
        notif_sound:   chk('set-notif-sound'),
        notif_pos:     val('set-notif-pos'),
        auto_refresh:  prefRead('auto_refresh'),
        tag_format:    val('set-tag-format'),
        tag_enabled:   chk('set-tag-enable')
    };
    fire('saveSettings', personal);
    state.settings = personal;
    applyNotificationPosition(personal.notif_pos);
    // Tag enable toggle pushes immediately so the floating tag appears
    // / disappears without waiting for the next re-open of the panel.
    fire('setStaffTag', personal.tag_enabled);

    // Global settings — only the operator-side toggles. The webhook
    // URLs are already mirrored into state.globalSettings by the
    // input listener above; we ship the whole blob.
    const evt = {
        moderation: chk('set-evt-moderation'),
        economy:    chk('set-evt-economy'),
        player:     chk('set-evt-player'),
        vehicle:    chk('set-evt-vehicle'),
        staff:      chk('set-evt-staff'),
        console:    chk('set-evt-console'),
        reports:    chk('set-evt-reports')
    };
    state.globalSettings = state.globalSettings || {};
    state.globalSettings['discord.enabled']    = chk('set-discord-enabled');
    state.globalSettings['discord.username']   = val('set-discord-username') || 'Apex Admin';
    state.globalSettings['discord.avatar']     = val('set-discord-avatar') || '';
    state.globalSettings['discord.log_events'] = evt;

    // Read the boxes directly instead of trusting the mirror the `input`
    // listener maintains. A value pasted programmatically, or restored by
    // the browser's form cache, never fires `input` — so it existed on
    // screen, was never mirrored, and was dropped on save.
    const hooks = Object.assign({}, state.globalSettings['discord.webhooks'] || {});
    $$('.ap-webhook-input').forEach(inp => { hooks[inp.dataset.key] = inp.value.trim(); });
    state.globalSettings['discord.webhooks'] = hooks;

    fire('saveGlobalSettings', state.globalSettings);

    // No success toast here. The server answers on
    // apex_adminmenu:panel:globalSettingsSaved and onGlobalSettingsSaved()
    // reports what actually happened — this used to claim success even
    // when the save was refused outright.
    showToast('Saving…', 'info');
});

/* ============================================================
   MONITORING — screen frames relayed by the server (see the
   "Spectate stream" sections of client/ and server/adminpanel.lua)
   ============================================================ */
// Watched set so we can toggle add/remove from the list without
// duplicates and without accidentally closing previous tiles.
state.monWatched = new Map();   // id -> { name, tileEl, timer }

function renderMonList(players) {
    const list = $('#mon-list');
    list.innerHTML = '';
    if (!players || players.length === 0) {
        list.innerHTML = `<div class="ap-empty" style="padding:36px 16px">
            <i class="fa-regular fa-user"></i>
            <div style="margin-top:6px">No online players</div>
        </div>`;
        return;
    }
    // Seed the cache from this response first so the avatar helper
    // can bake URLs straight into the markup.
    players.forEach(p => { if (p.license && p.avatar) rememberAvatar(p.license, p.avatar); });
    players.forEach(p => {
        const watching = state.monWatched.has(p.id);
        const div = document.createElement('div');
        div.className = 'ap-mon-row' + (watching ? ' watching' : '');
        div.innerHTML = `
            <div class="ap-mon-row-av">
                ${avatar(p.avatar, p.name, 'lg square', p.license)}
                <span class="ap-mon-row-status"></span>
            </div>
            <div class="ap-mon-row-info">
                <div class="ap-mon-row-top">
                    <span class="ap-mon-row-name">${escapeHTML(p.name)}</span>
                    <span class="ap-list-item-id">#${p.id}</span>
                </div>
                <div class="ap-mon-row-meta">
                    <span><i class="fa-solid fa-signal"></i> ${p.ping || 0}ms</span>
                    ${p.onDuty ? '<span class="ap-mon-row-duty"><i class="fa-solid fa-circle-check"></i> ON DUTY</span>' : ''}
                    ${watching ? '<span class="ap-mon-row-live">● LIVE</span>' : ''}
                </div>
            </div>
            <button class="ap-mon-row-toggle ${watching ? 'on' : ''}" title="${watching ? 'Stop watching' : 'Start watching'}">
                <i class="fa-solid fa-${watching ? 'circle-stop' : 'play'}"></i>
            </button>`;
        div.addEventListener('click', e => {
            e.stopPropagation();
            toggleMonitor(p.id, p.name, p.avatar, p.license);
        });
        list.appendChild(div);
    });
    // Defensive final pass: paint every avatar from the cache. Mirrors
    // the strategy used by the player list — guarantees the picture
    // shows up regardless of whether the avatar URL was in the row
    // payload or only in the cache.
    list.querySelectorAll('[data-license]').forEach(el => {
        el.dataset.avatarPainted = '0';
        paintAvatarNode(el);
    });
}
function renderEmptyStreams() {
    if (state.monWatched.size === 0) {
        $('#mon-streams').innerHTML =
            `<div class="ap-empty">
                <i class="fa-solid fa-eye"></i>
                <div style="margin-top:6px;font-size:14px;color:var(--text)">No active streams</div>
                <div style="margin-top:4px">Click a player on the right to start monitoring them.</div>
            </div>`;
    }
}
async function loadMonitoring() {
    // The player list is players.read; watching is players.spectate. A group
    // with only the second one would otherwise see "No online players".
    if (!panelCan('playersRead')) {
        state._monPlayers = [];
        $('#mon-list').innerHTML = `<div class="ap-empty" style="padding:36px 16px">
            <i class="fa-solid fa-lock"></i>
            <div style="margin-top:6px">Listing players needs the players.read permission</div>
        </div>`;
        renderEmptyStreams();
        return;
    }
    const players = await callback('players', '') || [];
    state._monPlayers = players;
    renderMonList(players);
    renderEmptyStreams();
    // Bottom bar starts empty until the admin selects a stream.
    const bar = $('.ap-mon-bottom');
    if (bar && state.monWatched.size === 0) bar.classList.add('empty');
}
function toggleMonitor(id, name, av, license) {
    if (state.monWatched.has(id)) return stopMonitor(id);
    startMonitor(id, name, av, license);
    renderMonList(state._monPlayers || []);
}
function startMonitor(id, name, av, license) {
    const wrap = $('#mon-streams');
    const empty = wrap.querySelector('.ap-empty');
    if (empty) empty.remove();

    // Seed the cache from the passed-in URL so the helper bakes it in.
    if (license && av) rememberAvatar(license, av);

    const tile = document.createElement('div');
    tile.className = 'ap-stream';
    tile.innerHTML = `
        <div class="ap-stream-head">
            ${avatar(av, name, 'sm', license)}
            <div class="ap-stream-head-info">
                <span class="ap-stream-head-name">${escapeHTML(name)}</span>
                <span class="ap-stream-head-sub">
                    <span class="ap-list-item-id">#${id}</span>
                    <span class="ap-stream-live">LIVE</span>
                </span>
            </div>
        </div>
        <div class="ap-stream-empty">
            <i class="fa-solid fa-spinner fa-spin"></i>
            <span>Connecting to stream…</span>
        </div>
        <div class="ap-stream-foot">
            <span><i class="fa-regular fa-clock"></i> Just now</span>
            <div class="ap-stream-foot-actions">
                <button class="ap-stream-foot-btn" title="Spectate in-game" onclick="window._spec(${id})"><i class="fa-solid fa-eye"></i></button>
                <button class="ap-stream-foot-btn" title="Teleport"  onclick="window._tp(${id})"><i class="fa-solid fa-location-arrow"></i></button>
                <button class="ap-stream-foot-btn" title="Open detail" onclick="window._openPlayer(${id})"><i class="fa-solid fa-arrow-up-right-from-square"></i></button>
            </div>
        </div>
        <button class="ap-stream-close" title="Stop"><i class="fa-solid fa-xmark"></i></button>`;
    tile.querySelector('.ap-stream-close').addEventListener('click', e => {
        e.stopPropagation();
        stopMonitor(id);
    });
    // Click anywhere on the tile = make it the active target for the
    // bottom action bar.
    tile.addEventListener('click', () => setMonTarget(id));
    wrap.appendChild(tile);
    // Synchronously paint the tile's avatar from cache.
    tile.querySelectorAll('[data-license]').forEach(el => {
        el.dataset.avatarPainted = '0';
        paintAvatarNode(el);
    });

    // Ask the server to start a spectate stream for our local player.
    fire('startSpectateStream', id);

    state.monWatched.set(id, { name, tileEl: tile, startedAt: Date.now(), avatar: av, license });
    // Auto-select the freshly opened tile.
    setMonTarget(id);
    updateMonCounter();
}
function updateMonCounter() {
    const n = state.monWatched.size;
    const el = $('#mon-counter');
    if (el) el.textContent = `${n} active`;
}

// ── Monitoring bottom action bar ─────────────────────────
state.monTarget = null;
function setMonTarget(id) {
    const entry = state.monWatched.get(id);
    if (!entry) return;
    state.monTarget = id;
    // Highlight the active tile
    state.monWatched.forEach((e, k) => {
        e.tileEl?.classList.toggle('selected', k === id);
    });
    const bar = $('.ap-mon-bottom'); if (bar) bar.classList.remove('empty');
    $('#mon-bottom-name').textContent = entry.name;
    $('#mon-bottom-sub').textContent  = `Server ID #${id} · LIVE`;
    const av = $('#mon-bottom-av');
    if (av) {
        // Tag with license so the observer + broadcast can patch this
        // avatar when the Steam URL resolves asynchronously.
        if (entry.license) av.setAttribute('data-license', entry.license);
        else av.removeAttribute('data-license');
        const url = entry.avatar || (entry.license && avatarCache.get(entry.license)) || null;
        if (url) {
            if (entry.license) rememberAvatar(entry.license, url);
            av.style.backgroundImage = `url(${JSON.stringify(url)})`;
            av.style.backgroundSize = 'cover';
            av.style.backgroundPosition = 'center';
            av.classList.add('has-img');
            av.innerHTML = '';
            av.dataset.avatarPainted = '1';
        } else {
            av.style.backgroundImage = '';
            av.classList.remove('has-img');
            av.dataset.avatarPainted = '0';
            av.innerHTML = `<span class="ap-av-fallback">${(entry.name || '?').substring(0,1).toUpperCase()}</span>`;
        }
    }
}
function clearMonTargetIfStopped(id) {
    if (state.monTarget === id) {
        state.monTarget = null;
        const bar = $('.ap-mon-bottom'); if (bar) bar.classList.add('empty');
        $('#mon-bottom-name').textContent = 'No stream selected';
        $('#mon-bottom-sub').textContent  = 'Pick one of the active streams above';
        const av = $('#mon-bottom-av');
        if (av) {
            av.style.backgroundImage = '';
            av.classList.remove('has-img');
            av.removeAttribute('data-license');
            av.innerHTML = '';
        }
    }
}
// Wire bottom-bar buttons to the actions we already have.
document.addEventListener('click', e => {
    const btn = e.target.closest('[data-mon-act]'); if (!btn) return;
    const id = state.monTarget; if (!id) return;
    const entry = state.monWatched.get(id);
    const act = btn.dataset.monAct;
    switch (act) {
        case 'spectate': window._spec(id); break;
        case 'teleport': fire('teleportTo',   id); break;
        case 'bring':    fire('bringPlayer',  id); break;
        case 'revive':   fire('revivePlayer', id); break;
        case 'heal':     fire('healPlayer',   id); break;
        case 'freeze':   fire('freezePlayer', id, true); break;
        case 'warn':     window._warn?.(id); break;
        case 'jail':     window._jail?.(id); break;
        case 'kick':     window._kick?.(id); break;
        case 'ban':      window._ban?.(id); break;
        case 'open':     window._openPlayer?.(id); break;
    }
});
window._openPlayer = id => { setPage('players'); setTimeout(() => selectPlayer(id), 200); };
function stopMonitor(id) {
    const entry = state.monWatched.get(id);
    if (!entry) return;
    fire('stopSpectateStream', id);
    if (entry.tileEl && entry.tileEl.parentNode) entry.tileEl.remove();
    state.monWatched.delete(id);
    renderMonList(state._monPlayers || []);
    renderEmptyStreams();
    updateMonCounter();
    clearMonTargetIfStopped(id);
}
document.addEventListener('click', e => {
    if (!e.target.closest('#mon-stop-all')) return;
    Array.from(state.monWatched.keys()).forEach(id => stopMonitor(id));
});
// Live search filter for the right rail.
document.addEventListener('input', e => {
    if (e.target?.id !== 'mon-search') return;
    const q = (e.target.value || '').toLowerCase();
    const filtered = (state._monPlayers || []).filter(p =>
        p.name.toLowerCase().includes(q) || String(p.id).includes(q));
    renderMonList(filtered);
});

// Frame stream from server -> updates the matching tile.
window.addEventListener('message', e => {
    const d = e.data || {};
    if (d.action === 'panel:specFrame') {
        const entry = state.monWatched.get(d.targetId);
        if (!entry) return;
        if (!entry.imgEl) {
            entry.tileEl.querySelector('.ap-stream-empty')?.remove();
            const img = document.createElement('img');
            img.className = 'ap-stream-img';
            // Decode off the main thread so a new frame never stalls the UI.
            img.decoding = 'async';
            entry.tileEl.insertBefore(img, entry.tileEl.firstChild);
            entry.imgEl = img;
        }
        entry.imgEl.src = d.dataUri;
    } else if (d.action === 'panel:specError') {
        const entry = state.monWatched.get(d.targetId);
        if (!entry) return;
        const ph = entry.tileEl.querySelector('.ap-stream-empty');
        if (ph) {
            ph.innerHTML = `<i class="fa-solid fa-triangle-exclamation" style="color:var(--warning)"></i>
                <span style="text-align:center;padding:0 12px">${d.message || 'No frames'}</span>`;
        }
    }
});

/* ============================================================
   Generic modal helper
   ============================================================ */
// ── In-panel toast + confirm helpers ──────────────────────
// Stand-ins for window.alert() / window.confirm() so we never
// trigger FiveM's native JS dialog (the title-bar Windows popup).
function ensureToastContainer() {
    let c = document.getElementById('ap-toasts');
    if (!c) {
        c = document.createElement('div');
        c.id = 'ap-toasts';
        c.className = 'ap-toasts';
        document.body.appendChild(c);
    }
    return c;
}
function showToast(message, kind = 'info', timeout = 3200) {
    const c = ensureToastContainer();
    const t = document.createElement('div');
    t.className = `ap-toast ap-toast-${kind}`;
    const icon = kind === 'error'   ? 'fa-circle-exclamation'
              : kind === 'warning' ? 'fa-triangle-exclamation'
              : kind === 'success' ? 'fa-circle-check'
              :                      'fa-circle-info';
    t.innerHTML = `<i class="fa-solid ${icon}"></i><span>${escapeHTML(message)}</span>`;
    c.appendChild(t);
    requestAnimationFrame(() => t.classList.add('show'));
    setTimeout(() => {
        t.classList.remove('show');
        setTimeout(() => t.remove(), 220);
    }, timeout);
}
window.notify = showToast;

// In-panel confirm dialog — reuses the modal markup. Resolves to
// true/false via a Promise so callers can `await confirmDialog(...)`.
function confirmDialog(title, message, opts = {}) {
    // "Confirm destructive actions" off: every caller awaits this, so
    // resolving true immediately just skips the prompt and lets the
    // action through. Nothing else needs to know about the preference.
    if (!prefRead('confirm_destructive')) return Promise.resolve(true);

    return new Promise(resolve => {
        $('#ap-modal-title').textContent = title;
        $('#ap-modal-body').innerHTML = `
            <div class="ap-confirm-body">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <p>${escapeHTML(message)}</p>
            </div>`;
        $('#ap-modal').classList.remove('hidden');
        // Rewire the modal buttons just for this call so old listeners
        // don't pile up.
        const ok     = $('#ap-modal-ok');
        const cancel = $('#ap-modal-cancel');
        const close  = $('#ap-modal-close');
        const newOk = ok.cloneNode(true);     ok.replaceWith(newOk);
        const newCa = cancel.cloneNode(true); cancel.replaceWith(newCa);
        const newCl = close.cloneNode(true);  close.replaceWith(newCl);
        newOk.textContent = opts.okLabel || 'Confirm';
        newCa.textContent = opts.cancelLabel || 'Cancel';
        if (opts.danger) newOk.classList.add('danger'); else newOk.classList.remove('danger');
        const finish = (val) => {
            $('#ap-modal').classList.add('hidden');
            resolve(val);
        };
        newOk.addEventListener('click',     () => finish(true));
        newCa.addEventListener('click',     () => finish(false));
        newCl.addEventListener('click',     () => finish(false));
    });
}

function promptModal(title, label, def, ok) {
    $('#ap-modal-title').textContent = title;
    $('#ap-modal-body').innerHTML = `<label class="ap-form-row"><span>${label}</span>
        <input class="ap-input" id="ap-modal-input" value="${(def || '').replace(/"/g, '&quot;')}"></label>`;
    $('#ap-modal').classList.remove('hidden');

    // Strip listeners from the PREVIOUS use on open, not on finish.
    //
    // The old code only cleaned up inside finish(), so cancelling left
    // that call's `finish` closure attached to #ap-modal-ok. Open Kick →
    // Cancel → open Ban → press OK and BOTH closures ran: the kick fired
    // carrying the ban dialog's text. Every destructive action in the
    // panel (_kick/_ban/_warn/_jail/_giveMoney/_setHealth…) routes through
    // here. confirmDialog and pickPlayer clone on open, which is why they
    // never showed this.
    const okBtn     = replaceWithClone('#ap-modal-ok');
    const cancelBtn = replaceWithClone('#ap-modal-cancel');
    const closeBtn  = replaceWithClone('#ap-modal-close');

    const input = $('#ap-modal-input');
    input.focus(); input.select();

    const hide = () => $('#ap-modal').classList.add('hidden');
    const finish = () => {
        const v = input.value;
        hide();
        if (ok) ok(v);
    };

    okBtn.addEventListener('click', finish);
    cancelBtn.addEventListener('click', hide);
    closeBtn.addEventListener('click', hide);
    input.addEventListener('keydown', e => { if (e.key === 'Enter') finish(); });
}

// Replace a node with a clean clone (drops every listener) and return it.
function replaceWithClone(sel) {
    const el = $(sel);
    if (!el) return el;
    const fresh = el.cloneNode(true);
    el.replaceWith(fresh);
    return fresh;
}

/* ------------------------------------------------------------
   Reusable searchable player picker. Opens the shared modal with
   a live-filtered list of ONLINE players (by ID, name or license)
   and calls onPick(player) with the chosen row. Used by the Items,
   Vehicles and Jobs pages.
   ------------------------------------------------------------ */
async function pickPlayer(onPick, opts = {}) {
    if (!document.getElementById('ap-pp-style')) {
        const st = document.createElement('style');
        st.id = 'ap-pp-style';
        st.textContent = '.ap-pp-row{transition:border-color .15s,background .15s;cursor:pointer}'
                       + '.ap-pp-row:hover{border-color:var(--brand)!important;background:var(--bg-raised)!important}';
        document.head.appendChild(st);
    }
    $('#ap-modal-title').textContent = opts.title || 'Select a player';
    $('#ap-modal-body').innerHTML = `
        <label class="ap-form-row"><span>Search by ID, name or license</span>
            <input class="ap-input" id="ap-pp-search" placeholder="e.g. 12 or John" autocomplete="off"></label>
        <div id="ap-pp-list" style="margin-top:10px;max-height:320px;overflow-y:auto;display:flex;flex-direction:column;gap:6px"></div>`;
    $('#ap-modal').classList.remove('hidden');

    // Clear stale listeners on the shared modal buttons and hide OK
    // (selection happens by clicking a row).
    ['ok', 'cancel', 'close'].forEach(b => {
        const el = $('#ap-modal-' + b);
        if (el) el.replaceWith(el.cloneNode(true));
    });
    const okBtn = $('#ap-modal-ok');
    if (okBtn) okBtn.style.display = 'none';
    const close = () => { $('#ap-modal').classList.add('hidden'); if (okBtn) okBtn.style.display = ''; };
    $('#ap-modal-cancel').addEventListener('click', close);
    $('#ap-modal-close').addEventListener('click', close);

    // Reuse the cached online list, else fetch it.
    let players = (state.players || []).filter(p => p.online !== false);
    if (!players.length) players = (await callback('players', '', 'online')) || [];

    const listEl = $('#ap-pp-list');
    const search = $('#ap-pp-search');
    const draw = (needle) => {
        const n = (needle || '').toLowerCase().trim();
        const rows = players.filter(p => !n
            || String(p.id) === n || String(p.id).includes(n)
            || (p.name || '').toLowerCase().includes(n)
            || (p.license || '').toLowerCase().includes(n));
        if (!rows.length) {
            listEl.innerHTML = '<div class="ap-muted" style="padding:16px;text-align:center">No players match</div>';
            return;
        }
        listEl.innerHTML = rows.map(p => `
            <button class="ap-pp-row" data-id="${p.id}" style="display:flex;align-items:center;gap:10px;padding:8px 10px;border:1px solid var(--border);border-radius:var(--r-3);background:var(--bg-sidebar);text-align:left;width:100%">
                <span style="width:30px;height:30px;border-radius:8px;flex-shrink:0;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:var(--text-sub);background:var(--bg-raised) center/cover no-repeat${p.avatar ? `;background-image:url('${p.avatar}')` : ''}">${p.avatar ? '' : escapeHTML((p.name || '?').charAt(0).toUpperCase())}</span>
                <span style="flex:1;min-width:0">
                    <span style="display:block;font-weight:600;color:var(--text);overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${escapeHTML(p.name || 'Unknown')}</span>
                    <span class="ap-muted" style="font-size:11px">ID ${p.id}${p.license ? ' · ' + escapeHTML(p.license) : ''}</span>
                </span>
                <i class="fa-solid fa-chevron-right" style="color:var(--text-mute);font-size:11px"></i>
            </button>`).join('');
        listEl.querySelectorAll('.ap-pp-row').forEach(el => el.addEventListener('click', () => {
            const id = parseInt(el.dataset.id, 10);
            close();
            onPick(players.find(x => x.id === id) || { id });
        }));
    };
    draw('');
    search.focus();
    search.addEventListener('input', e => draw(e.target.value));
}

/* ============================================================
   JOBS
   ============================================================ */
state.jobs = { list: [], framework: 'unknown', backend: 'unknown', selected: null, draft: null, filter: '' };

async function loadJobs() {
    const res = await callback('jobs') || { jobs: [], framework: 'unknown', backend: 'unknown' };
    state.jobs.list      = res.jobs || [];
    state.jobs.framework = res.framework || 'unknown';
    state.jobs.backend   = res.backend   || (res.framework === 'qb' ? 'qbcore' : 'esx');
    // Reflect the source-of-truth in the page subtitle so admins can
    // tell at a glance whether jobs are being read from QBox, QBCore
    // or the ESX `jobs`/`job_grades` DB tables.
    const sub = document.querySelector('.ap-page[data-page="jobs"] .ap-page-head .ap-muted');
    if (sub) {
        const label = state.jobs.backend === 'qbox'   ? 'QBox (qbx_core)'
                    : state.jobs.backend === 'qbcore' ? 'QBCore (shared.lua)'
                    : 'ESX (jobs / job_grades tables)';
        sub.innerHTML = `Source: <b>${label}</b> · Create, edit and remove framework jobs &amp; grades`;
    }
    renderJobsList();
    // Restore selection if the job still exists; otherwise clear.
    if (state.jobs.selected) {
        const still = state.jobs.list.find(j => j.name === state.jobs.selected);
        if (still) {
            openJobEditor(still);
            return;
        }
    }
    state.jobs.selected = null;
    state.jobs.draft    = null;
    renderJobEmptyEditor();
}

function renderJobsList() {
    const list   = $('#jobs-list');
    const count  = $('#jobs-count');
    if (!list) return;
    const q = (state.jobs.filter || '').toLowerCase();
    const filtered = state.jobs.list.filter(j =>
        !q || (j.label || '').toLowerCase().includes(q) || (j.name || '').toLowerCase().includes(q));
    if (count) count.textContent = String(filtered.length);
    if (filtered.length === 0) {
        list.innerHTML = `<div class="ap-empty" style="padding:24px 16px">
            <i class="fa-solid fa-briefcase"></i>
            <div style="margin-top:6px">${q ? 'No jobs match' : 'No jobs found'}</div>
        </div>`;
        return;
    }
    list.innerHTML = filtered.map(j => {
        const sel = state.jobs.selected === j.name ? ' selected' : '';
        const usage = j.usage > 0
            ? `<span class="ap-jobs-usage" title="${j.usage} player(s) currently have this job">${j.usage}</span>`
            : '';
        // Saved to the database, not yet in ESX's live job pool — the server
        // will only honour it after /refreshjobs or a restart.
        const pending = j.pending
            ? `<span class="ap-jobs-pending" title="Saved, but ESX has not reloaded it yet — run /refreshjobs or restart es_extended">
                   <i class="fa-solid fa-clock-rotate-left"></i>
               </span>`
            : '';
        return `
        <div class="ap-jobs-item${sel}" data-job="${escapeHTML(j.name)}">
            <div class="ap-jobs-item-icon"><i class="fa-solid fa-briefcase"></i></div>
            <div class="ap-jobs-item-meta">
                <strong>${escapeHTML(j.label || j.name)}</strong>
                <code>${escapeHTML(j.name)}</code>
            </div>
            <div class="ap-jobs-item-tail">
                <span class="ap-jobs-grades-pill" title="${(j.grades || []).length} grade(s)">
                    <i class="fa-solid fa-layer-group"></i> ${(j.grades || []).length}
                </span>
                ${pending}${usage}
            </div>
        </div>`;
    }).join('');
    list.querySelectorAll('.ap-jobs-item').forEach(el => {
        el.addEventListener('click', () => {
            const name = el.dataset.job;
            const job  = state.jobs.list.find(j => j.name === name);
            if (job) openJobEditor(job);
        });
    });
}

function renderJobEmptyEditor() {
    const main = $('#jobs-main');
    if (!main) return;
    main.innerHTML = `<div class="ap-empty">
        <i class="fa-solid fa-briefcase"></i>
        <div style="margin-top:6px">Select a job to edit, or create a new one</div>
    </div>`;
}

function openJobEditor(job) {
    state.jobs.selected = job.name;
    // Deep-clone so editing the draft doesn't mutate the cached list
    // until the user clicks Save.
    state.jobs.draft = JSON.parse(JSON.stringify(job));
    state.jobs.draft.oldName = job.name;   // for renames
    renderJobsList();          // highlight the selected row
    renderJobEditor();
}

function openJobEditorNew() {
    state.jobs.selected = null;
    state.jobs.draft = {
        name:    '',
        label:   '',
        oldName: null,
        grades:  [
            { grade: 0, name: 'unemployed', label: 'Unemployed', payment: 0, isboss: false }
        ]
    };
    renderJobsList();
    renderJobEditor();
}

function renderJobEditor() {
    const main = $('#jobs-main');
    const d    = state.jobs.draft;
    if (!main || !d) return;
    // QBCore + QBox share the same in-memory job structure so the
    // editor renders the same set of fields for both.
    const isQB    = state.jobs.backend === 'qbcore' || state.jobs.backend === 'qbox';
    const isNew   = !d.oldName;
    const usage   = isNew ? 0 : ((state.jobs.list.find(j => j.name === d.oldName) || {}).usage || 0);

    main.innerHTML = `
        <header class="ap-jobs-editor-head">
            <div class="ap-jobs-editor-title">
                <i class="fa-solid fa-briefcase"></i>
                <div>
                    <h3>${isNew ? 'New Job' : escapeHTML(d.label || d.name)}</h3>
                    <small>${isNew ? 'Define a new framework job' : `Editing <code>${escapeHTML(d.oldName)}</code> · ${usage} player(s) using this job`}</small>
                </div>
            </div>
            <div class="ap-jobs-editor-actions">
                ${isNew ? '' : `<button class="ap-btn danger" id="job-delete"><i class="fa-solid fa-trash"></i> Delete</button>`}
                <button class="ap-btn primary" id="job-save"><i class="fa-solid fa-floppy-disk"></i> Save</button>
            </div>
        </header>

        <div class="ap-jobs-editor-body">
            <div class="ap-jobs-editor-section">
                <div class="ap-jobs-editor-section-title">Identity</div>
                <div class="ap-jobs-fields">
                    <label class="ap-form-row">
                        <span>Internal name</span>
                        <input class="ap-input mono" id="job-name" value="${escapeHTML(d.name || '')}" placeholder="police" maxlength="60">
                    </label>
                    <label class="ap-form-row">
                        <span>Display label</span>
                        <input class="ap-input" id="job-label" value="${escapeHTML(d.label || '')}" placeholder="Police Officer">
                    </label>
                    ${isQB ? `
                    <label class="ap-form-row">
                        <span>Type</span>
                        <select class="ap-input" id="job-type">
                            <option value="none"   ${d.type === 'none'   || !d.type ? 'selected' : ''}>None</option>
                            <option value="leo"    ${d.type === 'leo'    ? 'selected' : ''}>LEO</option>
                            <option value="ems"    ${d.type === 'ems'    ? 'selected' : ''}>EMS</option>
                            <option value="gov"    ${d.type === 'gov'    ? 'selected' : ''}>Government</option>
                            <option value="civil"  ${d.type === 'civil'  ? 'selected' : ''}>Civilian</option>
                        </select>
                    </label>
                    <label class="ap-switch-row">
                        <span>Default duty (on at spawn)</span>
                        <input type="checkbox" id="job-defaultduty" ${d.defaultDuty ? 'checked' : ''}>
                    </label>
                    <label class="ap-switch-row">
                        <span>Off-duty pay</span>
                        <input type="checkbox" id="job-offdutypay" ${d.offDutyPay ? 'checked' : ''}>
                    </label>
                    ` : ''}
                </div>
            </div>

            <div class="ap-jobs-editor-section">
                <div class="ap-jobs-editor-section-title">
                    <span>Grades</span>
                    <button class="ap-btn ghost ap-btn-sm" id="job-add-grade">
                        <i class="fa-solid fa-plus"></i> Add Grade
                    </button>
                </div>
                <div class="ap-jobs-grades" id="job-grades"></div>
            </div>

            <div class="ap-jobs-editor-section">
                <div class="ap-jobs-editor-section-title">Assign to player</div>
                <div class="ap-jobs-fields">
                    <div style="display:flex; align-items:flex-end; gap:10px; flex-wrap:wrap">
                        <label class="ap-form-row" style="flex:1 1 160px; min-width:140px; margin:0">
                            <span>Grade</span>
                            <select class="ap-input" id="job-assign-grade">
                                ${(d.grades || []).slice().sort((a, b) => Number(a.grade) - Number(b.grade))
                                    .map(g => `<option value="${Number(g.grade)}">${escapeHTML(g.label || g.name || ('Grade ' + g.grade))} · grade ${Number(g.grade)}</option>`).join('')}
                            </select>
                        </label>
                        <button class="ap-btn primary" id="job-assign-btn" ${isNew ? 'disabled' : ''} style="flex-shrink:0">
                            <i class="fa-solid fa-user-plus"></i> Assign to player…
                        </button>
                    </div>
                    ${isNew ? '<small class="ap-muted">Save the job first, then you can assign it to players.</small>' : ''}
                </div>
            </div>
        </div>
    `;

    renderJobGrades();

    $('#job-save').addEventListener('click', saveJobDraft);
    const assignBtn = $('#job-assign-btn');
    if (assignBtn) assignBtn.addEventListener('click', () => {
        const jobName = d.oldName || d.name;
        if (!jobName) return;
        const sel = $('#job-assign-grade');
        const grade = sel ? (parseInt(sel.value, 10) || 0) : 0;
        pickPlayer(p => { if (p) fire('setPlayerJob', p.id, jobName, grade); },
            { title: `Assign "${jobName}" to…` });
    });
    $('#job-add-grade').addEventListener('click', () => {
        const used = (d.grades || []).map(g => Number(g.grade));
        let next = 0; while (used.includes(next)) next++;
        d.grades.push({ grade: next, name: 'grade_' + next, label: 'Grade ' + next, payment: 0, isboss: false });
        renderJobGrades();
    });
    if (!isNew) {
        $('#job-delete')?.addEventListener('click', async () => {
            const ok = await confirmDialog(
                'Delete job',
                `Delete job "${d.oldName}"? This cannot be undone.`,
                { okLabel: 'Delete', danger: true }
            );
            if (!ok) return;
            fire('deleteJob', d.oldName);
            reloadSoon(loadJobs);
        });
    }
    // Live sync of identity fields back into draft.
    $('#job-name').addEventListener('input',  e => d.name  = e.target.value.toLowerCase().replace(/[^a-z0-9_\-]/g, ''));
    $('#job-label').addEventListener('input', e => d.label = e.target.value);
    $('#job-type')?.addEventListener('change', e => d.type = e.target.value);
    $('#job-defaultduty')?.addEventListener('change', e => d.defaultDuty = e.target.checked);
    $('#job-offdutypay')?.addEventListener('change',  e => d.offDutyPay  = e.target.checked);
}

// Heuristic — any grade whose name/label hints at leadership is
// auto-flagged as boss when the draft is built. Operators can still
// untick it manually.
const BOSS_KEYWORDS = ['boss', 'chief', 'owner', 'ceo', 'leader', 'director', 'supervisor', 'commander', 'sheriff', 'captain'];
function looksLikeBoss(g) {
    const blob = ((g.name || '') + ' ' + (g.label || '')).toLowerCase();
    return BOSS_KEYWORDS.some(k => blob.includes(k));
}

function renderJobGrades() {
    const wrap = $('#job-grades');
    const d    = state.jobs.draft;
    if (!wrap || !d) return;
    const isQB = state.jobs.backend === 'qbcore' || state.jobs.backend === 'qbox';
    d.grades.sort((a, b) => Number(a.grade) - Number(b.grade));
    // Auto-flag bosses on first render (won't overwrite an explicit
    // false the operator already chose, because we only flip when the
    // current value is falsy).
    d.grades.forEach(g => { if (!g.isboss && looksLikeBoss(g)) g.isboss = true; });

    wrap.innerHTML = d.grades.map((g, idx) => `
        <div class="ap-jobs-grade-row${g.isboss ? ' is-boss' : ''}" data-idx="${idx}">
            <div class="ap-jobs-grade-badge" title="Grade ${g.grade ?? 0}">
                <i class="fa-solid ${g.isboss ? 'fa-crown' : 'fa-hashtag'}"></i>
                <input class="ap-input mono ap-jobs-grade-badge-input" type="number" min="0" max="99"
                       value="${g.grade ?? 0}" data-field="grade" title="Grade number">
            </div>
            <div class="ap-jobs-grade-fields">
                <div class="ap-jobs-grade-field">
                    <label>Internal name</label>
                    <input class="ap-input mono" value="${escapeHTML(g.name || '')}" placeholder="boss" data-field="name">
                </div>
                ${isQB ? '' : `
                <div class="ap-jobs-grade-field">
                    <label>Label</label>
                    <input class="ap-input" value="${escapeHTML(g.label || '')}" placeholder="Chief of Police" data-field="label">
                </div>`}
                <div class="ap-jobs-grade-field ap-jobs-grade-pay">
                    <label>Payment</label>
                    <div class="ap-jobs-grade-pay-wrap">
                        <span class="ap-jobs-grade-pay-prefix">$</span>
                        <input class="ap-input mono" type="number" min="0" value="${g.payment ?? g.salary ?? 0}" data-field="payment">
                    </div>
                </div>
            </div>
            <button type="button" class="ap-jobs-grade-boss${g.isboss ? ' active' : ''}" data-field="isboss" title="Toggle boss permissions">
                <i class="fa-solid fa-crown"></i>
                <span>Boss</span>
            </button>
            <button class="ap-icon-btn danger" data-action="remove-grade" title="Remove grade">
                <i class="fa-solid fa-trash"></i>
            </button>
        </div>
    `).join('');

    wrap.querySelectorAll('.ap-jobs-grade-row').forEach(row => {
        const idx = Number(row.dataset.idx);

        // Text/number inputs sync straight to draft.
        row.querySelectorAll('input[data-field]').forEach(input => {
            input.addEventListener('input', () => {
                const f = input.dataset.field;
                d.grades[idx][f] = input.type === 'number' ? (Number(input.value) || 0) : input.value;
            });
        });

        // Boss toggle is now a real button — clicking it flips the
        // value, the row gets the .is-boss class, and the crown icon
        // takes over the badge so the state is obvious at a glance.
        const bossBtn = row.querySelector('.ap-jobs-grade-boss');
        bossBtn?.addEventListener('click', () => {
            d.grades[idx].isboss = !d.grades[idx].isboss;
            renderJobGrades();
        });

        row.querySelector('[data-action="remove-grade"]')?.addEventListener('click', () => {
            if (d.grades.length <= 1) {
                showToast('A job must have at least one grade.', 'warning');
                return;
            }
            d.grades.splice(idx, 1);
            renderJobGrades();
        });
    });
}

function saveJobDraft() {
    const d = state.jobs.draft;
    if (!d) return;
    if (!d.name  || d.name.length === 0)  { showToast('Internal name is required.',   'warning'); return; }
    if (!d.label || d.label.length === 0) { showToast('Display label is required.',   'warning'); return; }
    if (!d.grades || d.grades.length === 0) { showToast('At least one grade is required.', 'warning'); return; }
    fire('saveJob', {
        oldName:     d.oldName || null,
        name:        d.name,
        label:       d.label,
        type:        d.type,
        defaultDuty: d.defaultDuty,
        offDutyPay:  d.offDutyPay,
        grades:      d.grades
    });
    state.jobs.selected = d.name;
    reloadSoon(loadJobs);
}

// Page-level wiring.
document.addEventListener('click', e => {
    if (e.target.closest('#jobs-new')) openJobEditorNew();
});
document.addEventListener('input', e => {
    if (e.target?.id === 'jobs-search') {
        state.jobs.filter = e.target.value;
        renderJobsList();
    }
});

/* ============================================================
   Page registry
   ============================================================ */
const pageLoaders = {
    home:       loadHome,
    players:    () => loadPlayers(''),
    monitoring: loadMonitoring,
    moderation: loadModeration,
    chats:      loadChat,
    items:      loadItems,
    vehicles:   loadVehicles,
    console:    loadConsole,
    events:     loadEvents,
    staff:      loadStaff,
    jobs:       loadJobs,
    blips:      loadBlips,
    logs:       loadLogs,
    settings:   loadSettings
};
