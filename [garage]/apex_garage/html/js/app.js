/* ============================================================
   apex_garage — NUI logic
   Contract with Lua:
     Lua -> JS : { action, payload }  (open|refresh|close|show3DIcon|hide3DIcon|impoundForm)
     JS -> Lua : POST /<callback>     -> { ok, ... }
   ============================================================ */
(() => {
'use strict';

const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'apex_garage';
const $  = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
// `opts` is forwarded verbatim: callers that need the CAPTURE phase (the parking
// overlay's ESC handler, which must swallow the event before the shared bubble
// handler tears down the whole admin panel) pass `true` here.
const on = (el, ev, cb, opts) => el && el.addEventListener(ev, cb, opts);

const post = (name, data = {}) =>
    fetch(`https://${RES}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    }).then(r => r.json()).catch(() => ({}));

// ---- state ----------------------------------------------------------------
const ST = {
    garage: {}, vehicles: [], transfers: [], categories: [],
    i18n: {}, currency: { symbol: '$', position: 'before' },
    fees: {}, me: { cash: 0, bank: 0 }, images: false,
    previewReady: false, previewPending: null, previewKey: null,
    enablePlayerTransfer: false, enableGarageTransfer: false,
    instantSell: { enabled: false, percent: 0 },
    selected: null, filter: 'all', sort: 'name', search: '',
};

// Keys the JS builds but locales/*.lua does not ship yet. Same contract as the
// data-i18n literals in index.html: English is the fallback, never the key name.
// When a key lands in locales/, the dictionary wins and the entry here is inert.
const T_EN = {
    ed_stock_mode:       'Stock mode',
    ed_spawn_code:       'Spawn code',
    ed_stock:            'Stock',
    ed_stock_start:      'Starting stock',
    ed_veh_edit:         'Edit vehicle',
    ed_veh_fleet_hint:   'Only an admin can change which vehicles this garage offers. The boss adjusts how many.',
    adm_boss_empty_adm:  'An admin defines this fleet in /apexgarage.',
    ui_edit:             'Edit',
};

const t = (k) => (ST.i18n && ST.i18n[k]) || T_EN[k] || k;

// ---- static-markup hydration ----------------------------------------------
// index.html ships its literals in English. That is the fallback, not a bug: if
// the dictionary never arrives, or arrives partial, the user reads English
// instead of a raw key or an empty box. Every hydrated node therefore carries
// both the key (data-i18n*) and the English text it replaces.
//
// TIMING. This walk is reachable ONLY from setI18n(), and setI18n() only fires
// once a dict has actually landed — so it can never run against an empty ST.i18n
// and paint keys over the markup. There is deliberately no DOMContentLoaded call:
// at parse time the correct text is already in the DOM.
//
// Attribute forms:
//   data-i18n              -> textContent
//   data-i18n-placeholder  -> placeholder
//   data-i18n-title        -> title
//   data-i18n-tip          -> title + data-tip (the dock's tooltip pair)
const I18N_ATTRS = [
    ['data-i18n-placeholder', (el, v) => { el.placeholder = v; }],
    ['data-i18n-title',       (el, v) => { el.title = v; }],
    ['data-i18n-tip',         (el, v) => { el.title = v; el.setAttribute('data-tip', v); }],
];
function hydrateI18n(root = document) {
    const d = ST.i18n;
    if (!d) return;
    // A key the dict does not carry is skipped, never blanked — the English node
    // stays exactly as authored. This is what makes a partial locale safe.
    $$('[data-i18n]', root).forEach(el => {
        const v = d[el.getAttribute('data-i18n')];
        if (typeof v === 'string' && v) el.textContent = v;
    });
    I18N_ATTRS.forEach(([attr, set]) => $$(`[${attr}]`, root).forEach(el => {
        const v = d[el.getAttribute(attr)];
        if (typeof v === 'string' && v) set(el, v);
    }));
}

// The single funnel for "a dictionary arrived". Every payload that can carry one
// goes through here, so hydration can never be forgotten at a new call site —
// and a later payload that replaces the dict re-hydrates automatically.
// Falsy/!object input keeps whatever was already cached (payloads after the
// first legitimately omit the dict).
function setI18n(dict) {
    if (dict && typeof dict === 'object') ST.i18n = dict;
    hydrateI18n();
}

const esc = (s) => String(s == null ? '' : s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
const money = (n) => {
    n = Math.floor(Number(n) || 0);
    const s = Math.abs(n).toLocaleString('en-US');
    const sign = n < 0 ? '-' : '';
    return ST.currency.position === 'after' ? `${sign}${s}${ST.currency.symbol}` : `${sign}${ST.currency.symbol}${s}`;
};
const monogram = (label) => {
    const w = String(label || 'V').trim().split(/\s+/);
    return ((w[0] || 'V')[0] + (w[1] ? w[1][0] : (w[0] || 'V')[1] || '')).toUpperCase();
};

// centred empty state — muted grey icon, no emoji
const emptyState = (icon, title, sub) =>
    `<div class="empty-state"><i class="fa-solid ${icon} empty-ico"></i>` +
    `<div class="empty-title">${esc(title)}</div>` +
    (sub ? `<div class="empty-sub">${esc(sub)}</div>` : '') + `</div>`;

// ---- vehicle images (same method as apex_dealerships) ---------------------
// Candidate URLs, best first: local html/images/<spawncode>.<ext>, then the
// fallback URL. There's no way to ask if a file exists from the NUI, so the
// <img> onerror walks the list; running out reveals the monogram underneath.
function imageCandidates(spawn) {
    const cfg = ST.images;
    if (!cfg || !spawn) return [];
    const out = [];
    const m = String(spawn).toLowerCase();
    if (cfg.custom && cfg.base) (cfg.exts || ['png']).forEach(ext => out.push(`${cfg.base}${encodeURIComponent(m)}.${ext}`));
    // fallbackUrl accepts a single URL or a list of sources, tried in order —
    // no single CDN has every vehicle, so chaining them fills most of the gaps.
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

// monogram rendered UNDER the image: a 404 simply reveals it, never a hole
function imgTag(spawn, fallbackText) {
    const cands = imageCandidates(spawn);
    const mono = `<span class="mono-fallback">${esc(fallbackText)}</span>`;
    if (!cands.length) return mono;
    return mono + `<img src="${cands[0]}" data-i="0" data-cands="${cands.join('|')}" onload="apxImgOk(this)" onerror="apxImgFail(this)">`;
}

// ---- theme ----------------------------------------------------------------
// HSL ramp helpers — same method as apex_dealerships / apex_bossmenu, so a
// server that re-skins one Apex resource gets the identical result in all of them.
const _HEX6 = /^#[0-9a-fA-F]{6}$/;

const _hexToRgb = (hex) => {
    const h = (hex || '').replace('#', '');
    const n = h.length === 3 ? h.split('').map(c => c + c).join('') : h;
    return { r: parseInt(n.slice(0, 2), 16) || 0, g: parseInt(n.slice(2, 4), 16) || 0, b: parseInt(n.slice(4, 6), 16) || 0 };
};
const _rgbToHsl = ({ r, g, b }) => {
    r /= 255; g /= 255; b /= 255;
    const mx = Math.max(r, g, b), mn = Math.min(r, g, b);
    let h, s;
    const l = (mx + mn) / 2;
    if (mx === mn) { h = s = 0; }
    else {
        const d = mx - mn;
        s = l > .5 ? d / (2 - mx - mn) : d / (mx + mn);
        switch (mx) {
            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
            case g: h = (b - r) / d + 2; break;
            default: h = (r - g) / d + 4;
        }
        h /= 6;
    }
    return { h: h * 360, s: s * 100, l: l * 100 };
};
const _hslToHex = (h, s, l) => {
    h /= 360; s /= 100; l /= 100;
    const f = (p, q, t) => {
        if (t < 0) t += 1; if (t > 1) t -= 1;
        if (t < 1 / 6) return p + (q - p) * 6 * t;
        if (t < 1 / 2) return q;
        if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
        return p;
    };
    let r, g, b;
    if (s === 0) { r = g = b = l; }
    else {
        const q = l < .5 ? l * (1 + s) : l + s - l * s;
        const p = 2 * l - q;
        r = f(p, q, h + 1 / 3); g = f(p, q, h); b = f(p, q, h - 1 / 3);
    }
    const to = x => Math.round(x * 255).toString(16).padStart(2, '0');
    return '#' + to(r) + to(g) + to(b);
};
const _clamp01 = (n) => Math.max(0, Math.min(100, n));

// The whole UI is painted from two colours: `brand` and `bg`. Everything else —
// the lighter brand shades, the translucent brand alphas, the surface ramp and
// the border ramp — is derived here, so an admin only ever picks two.
//
// Defensive on purpose: a malformed hex leaves the CURRENT palette alone rather
// than writing garbage into the custom properties and blanking the interface.
function applyTheme(theme) {
    if (!theme || !_HEX6.test(theme.brand || '')) return;
    const root = document.documentElement.style;

    const rgb = _hexToRgb(theme.brand);
    const { h, s } = _rgbToHsl(rgb);
    root.setProperty('--brand-500', theme.brand);
    root.setProperty('--brand-600', _HEX6.test(theme.brandDark || '') ? theme.brandDark : _hslToHex(h, s, 47));
    // Dark-UI defaults; re-emitted below once we know the background direction
    // (they're used as TEXT, so on a light background they must go DARKER).
    root.setProperty('--brand-400', _hslToHex(h, s, 65));
    root.setProperty('--brand-300', _hslToHex(h, s, 75));
    [['a06', .06], ['a10', .10], ['a15', .15], ['a25', .25], ['a40', .40]]
        .forEach(([k, a]) => root.setProperty(`--brand-${k}`, `rgba(${rgb.r},${rgb.g},${rgb.b},${a})`));

    // Anything painted ON the brand (primary buttons, the world plate badge, the
    // switch knob) needs a foreground that survives a LIGHT brand — white on
    // #FFFF00 is 1.07:1. Pick by relative luminance, not by lightness, because
    // yellow and blue at the same HSL L read completely differently.
    const _lin = (c) => { c /= 255; return c <= .03928 ? c / 12.92 : Math.pow((c + .055) / 1.055, 2.4); };
    const lum = .2126 * _lin(rgb.r) + .7152 * _lin(rgb.g) + .0722 * _lin(rgb.b);
    root.setProperty('--brand-ink', lum > .55 ? '#0C0C0E' : '#FFFFFF');

    if (!_HEX6.test(theme.bg || '')) return;
    // The picked colour is the BASE tone (the sidebar level); the page background
    // sits one step BELOW it and every other surface above, so the ramp still
    // separates properly when an admin picks a light background — `dark` flips
    // the direction of every step.
    const bg = _rgbToHsl(_hexToRgb(theme.bg));
    const dark = bg.l < 50;
    const sat = Math.min(bg.s, 22);                     // keep the surfaces near-neutral
    const step = (d) => _hslToHex(bg.h, sat, _clamp01(bg.l + (dark ? d : -d)));

    // Accent TEXT shades. 65/75 only reads on a dark UI; on a light one the same
    // hue at 75% L is ~2.3:1 against the surface, so flip to darker shades.
    root.setProperty('--brand-400', _hslToHex(h, s, dark ? 65 : 42));
    root.setProperty('--brand-300', _hslToHex(h, s, dark ? 75 : 34));

    root.setProperty('--bg', step(-3.5));
    // The sidebar IS the base tone of the ramp, so it has to go through the same
    // saturation clamp as every other surface — using the raw pick left a vivid
    // #FF0000 rail next to muted brick cards.
    root.setProperty('--bg-sidebar', _hslToHex(bg.h, sat, _clamp01(bg.l)));
    // The floating in-world panels (garage list/detail, textui, placer, dock) are
    // a translucent version of the sidebar tone — they carry --text-1, so leaving
    // them near-black would put near-black text on near-black under a light theme.
    const glass = _hexToRgb(_hslToHex(bg.h, sat, _clamp01(bg.l + (dark ? -1.5 : 1.5))));
    root.setProperty('--bg-glass', `rgba(${glass.r},${glass.g},${glass.b},.94)`);
    root.setProperty('--bg-card', step(3));
    root.setProperty('--bg-raised', step(7));
    root.setProperty('--surface-3', step(7));
    root.setProperty('--surface-4', step(10));
    root.setProperty('--border', step(5));
    root.setProperty('--border-hi', step(9.5));
    root.setProperty('--line-3', step(15.5));
    root.setProperty('--line-4', step(23));

    // Ink flips to dark on a light background, so a bright theme stays readable.
    const ink = dark ? '244,244,245' : '12,12,14';
    root.setProperty('--text-1', dark ? '#F4F4F5' : '#0C0C0E');
    [['text-2', .72], ['text-3', .55], ['text-4', .38]]
        .forEach(([k, a]) => root.setProperty(`--${k}`, `rgba(${ink},${a})`));

    // Separators, inner rims and the thumbnail sheen are white washes that only
    // exist on a dark UI — on a light background they'd be white-on-white and
    // every row separator would vanish, so flip them to black washes. Shadows
    // likewise get much lighter, otherwise cards cast near-opaque black on white.
    const wash = dark ? '255,255,255' : '0,0,0';
    root.setProperty('--hairline',   `rgba(${wash},${dark ? .045 : .10})`);
    root.setProperty('--inset-rim',  `rgba(${wash},${dark ? .03 : .04})`);
    root.setProperty('--hover-wash', `rgba(${wash},${dark ? .016 : .035})`);
    root.setProperty('--gloss',      `rgba(${wash},${dark ? .06 : .04})`);
    // Status colours keep their HUE (green = stored, red = apreendido — that
    // meaning must never move with the brand), but they ARE used as foreground
    // text on badges/chips/toasts, so their LIGHTNESS has to react to the
    // background: #34C77B on near-white is ~1.9:1. Cap them on a light theme and
    // deepen the wash a touch so the fill is still visible.
    [['info', '#4E9CE5'], ['green', '#34C77B'], ['yellow', '#E5A93C'], ['red', '#E5564B']]
        .forEach(([k, base]) => {
            const c = _rgbToHsl(_hexToRgb(base));
            const solid = _hslToHex(c.h, c.s, dark ? c.l : Math.min(c.l, 38));
            const sr = _hexToRgb(solid);
            root.setProperty(`--${k}`, solid);
            root.setProperty(`--${k}-a`, `rgba(${sr.r},${sr.g},${sr.b},${dark ? .12 : .16})`);
            // channels only, so borders/glows/gradients elsewhere can pick their
            // own alpha off the SAME derived colour instead of freezing the dark
            // theme's hex (a badge whose text went deep-green on Daylight but
            // whose border stayed mint reads as a rendering bug)
            root.setProperty(`--${k}-rgb`, `${sr.r},${sr.g},${sr.b}`);
        });

    root.setProperty('--shadow-rgb', '0,0,0');
    [['a1', .40, .10], ['a2', .50, .14], ['a3', .60, .18], ['a4', .70, .22]]
        .forEach(([k, d, l]) => root.setProperty(`--shadow-${k}`, String(dark ? d : l)));
}

// ============================================================
// custom dropdown (native <select> popups can't be styled in CEF)
// ============================================================
/* Dropdown placement.

   An open .dd-menu is position:absolute, so it is clipped by the nearest
   scrolling ancestor rather than merely running off the screen — the impound
   form's time picker sits low inside .modal-body and lost most of its list to
   that. Measuring against that ancestor (not the viewport) is what makes the
   difference, so find it first. */
const DD_ITEM = 35, DD_PAD = 8, DD_MIN_ITEMS = 3, DD_MAX_ITEMS = 4;

function ddClipRect(el) {
    for (let p = el.parentElement; p; p = p.parentElement) {
        const o = getComputedStyle(p).overflowY;
        if (o === 'auto' || o === 'scroll' || o === 'hidden') return p.getBoundingClientRect();
    }
    return { top: 0, bottom: window.innerHeight };
}

// Decide which way the menu opens and how tall it may be. The FLOOR is the part
// that matters: a picker that opens showing one and a half options is unusable,
// so it never renders shorter than three even if that means overhanging a little.
function ddPlace(root, menu, btn) {
    const clip = ddClipRect(root), r = btn.getBoundingClientRect();
    const gap = 5, edge = 8;
    const below = clip.bottom - r.bottom - gap - edge;
    const above = r.top - clip.top - gap - edge;
    const floor = DD_MIN_ITEMS * DD_ITEM + DD_PAD;
    const want = Math.min(DD_MAX_ITEMS * DD_ITEM + DD_PAD, menu.scrollHeight);

    const up = below < Math.min(want, floor) && above > below;
    root.classList.toggle('up', up);
    menu.style.maxHeight = Math.max(floor, Math.min(want, up ? above : below)) + 'px';
}

function ddCloseAll() {
    $$('.dd.open').forEach(d => {
        d.classList.remove('open', 'up');
        const m = $('.dd-menu', d);
        if (m) { m.hidden = true; m.style.maxHeight = ''; }
    });
}

function makeDropdown(rootId, getOptions, getValue, onPick) {
    const root = $('#' + rootId);
    if (!root) return { render() {} };
    // clone the button to drop listeners from a previous makeDropdown() on the
    // same element (dd-cat/dd-sort are rebuilt on every open) — otherwise the
    // toggle handler would stack and the menu would open then instantly close.
    let btn = $('.dd-btn', root);
    const fresh = btn.cloneNode(true);
    btn.parentNode.replaceChild(fresh, btn);
    btn = fresh;
    const menu = $('.dd-menu', root), label = $('.dd-label', root);
    const close = () => {
        root.classList.remove('open', 'up');
        menu.hidden = true;
        menu.style.maxHeight = '';   // let ddPlace decide afresh on the next open
    };
    const render = () => {
        const opts = getOptions(), val = getValue();
        menu.innerHTML = '';
        opts.forEach(o => {
            const b = document.createElement('button');
            b.className = 'dd-item' + (o.value === val ? ' active' : '');
            b.innerHTML = (o.icon ? `<i class="fa-solid ${o.icon}" style="width:14px;text-align:center;color:var(--brand-400)"></i>` : '') + esc(o.label);
            on(b, 'click', () => { close(); onPick(o.value); });
            menu.appendChild(b);
        });
        const cur = opts.find(o => o.value === val);
        if (label) label.textContent = cur ? cur.label : '';
    };
    on(btn, 'click', (e) => {
        e.stopPropagation();
        const wasOpen = root.classList.contains('open');
        ddCloseAll();
        if (!wasOpen) {
            render();
            root.classList.add('open');
            menu.hidden = false;
            // After it is in the DOM and visible: scrollHeight is 0 while hidden,
            // so measuring any earlier gives the wrong answer every time.
            ddPlace(root, menu, btn);
        }
    });
    return { render };
}
on(document, 'click', ddCloseAll);

let ddCat, ddSort;

// ============================================================
// OPEN / RENDER
// ============================================================
function openGarage(p) {
    ST.garage   = p.garage || {};
    ST.vehicles = p.vehicles || [];
    ST.transfers = p.transfers || [];
    ST.categories = p.categories || [];
    // never blank a dict the TextUI seed already cached
    setI18n(p.i18n);
    ST.currency = p.currency || ST.currency;
    ST.fees = p.fees || {};
    ST.images = p.images || false;
    ST.me = p.me || { cash: 0, bank: 0 };
    ST.enablePlayerTransfer = !!p.enablePlayerTransfer;
    ST.enableGarageTransfer = !!p.enableGarageTransfer;
    ST.instantSell = p.instantSell || { enabled: false, percent: 0 };
    ST.selected = null; ST.filter = 'all'; ST.search = '';
    ST.previewReady = false; ST.previewPending = null; ST.previewKey = null;
    applyTheme(p.theme);

    const isImp = ST.garage.type === 'impound';
    $('#g-mode').textContent = isImp ? t('ui_impound') : t('ui_garage');
    $('#g-mark-ico').className = 'fa-solid ' + (isImp ? 'fa-car-burst' : 'fa-warehouse');
    $('#g-name').textContent = ST.garage.label || '';
    $('#g-cash-label').textContent = t('ui_cash');
    $('#g-bank-label').textContent = t('ui_bank');
    $('#g-search').placeholder = t('ui_search');

    updateMoney();

    // dropdowns
    ddCat = makeDropdown('dd-cat', catOptions, () => ST.filter, (v) => { ST.filter = v; ddCat.render(); renderList(); });
    ddSort = makeDropdown('dd-sort', sortOptions, () => ST.sort, (v) => { ST.sort = v; ddSort.render(); renderList(); });
    ddCat.render(); ddSort.render();

    // renderList() auto-selects the first vehicle, which un-hides #g-detail —
    // so it must not be force-hidden afterwards.
    renderList();
    show('#garage');
}

function updateMoney() {
    $('#g-cash').textContent = money(ST.me.cash);
    $('#g-bank').textContent = money(ST.me.bank);
}

function catOptions() {
    const present = new Set(ST.vehicles.map(v => v.class || 'car'));
    const opts = [{ value: 'all', label: t('ui_all'), icon: 'fa-layer-group' }];
    (ST.categories || []).forEach(c => {
        if (present.has(c.key)) opts.push({ value: c.key, label: c.label, icon: c.icon });
    });
    return opts;
}
function sortOptions() {
    return [
        { value: 'name',   label: t('ui_sort_name'),   icon: 'fa-arrow-down-a-z' },
        { value: 'status', label: t('ui_sort_status'), icon: 'fa-signal' },
    ];
}

function filtered() {
    let list = ST.vehicles.slice();
    if (ST.filter !== 'all') list = list.filter(v => (v.class || 'car') === ST.filter);
    if (ST.search) {
        const q = ST.search.toLowerCase();
        list = list.filter(v =>
            (v.label || '').toLowerCase().includes(q) ||
            (v.nickname || '').toLowerCase().includes(q) ||
            (v.plate || '').toLowerCase().includes(q));
    }
    if (ST.sort === 'status') {
        const rank = v => v.impound ? 2 : (v.inGarage && !v.out ? 0 : 1);
        list.sort((a, b) => rank(a) - rank(b) || (a.label || '').localeCompare(b.label || ''));
    } else {
        list.sort((a, b) => (a.nickname || a.label || '').localeCompare(b.nickname || b.label || ''));
    }
    return list;
}

// Who the officer roster files a vehicle under. `owner` is a raw framework
// identifier and is only a last resort — a licence string is not a player to a
// human reader, but it is still better than collapsing several people into one
// "Unknown" bucket.
function ownerOf(v) { return v.ownerName || v.owner || t('ui_unknown_owner'); }

function statusOf(v) {
    if (v.impound) return { key: 'impound', cls: 'impound', badge: 'badge-red', label: t('ui_status_impound') };
    if (!v.inGarage || v.out) return { key: 'out', cls: 'out', badge: 'badge-yellow', label: t('ui_status_out') };
    return { key: 'stored', cls: 'stored', badge: 'badge-green', label: t('ui_status_stored') };
}

function renderList() {
    const list = filtered();
    const wrap = $('#g-list');
    wrap.innerHTML = '';
    $('#g-count').textContent = t(list.length === 1 ? 'ui_count_one' : 'ui_count_many').replace('%s', list.length);

    const empty = $('#g-empty');
    if (!ST.vehicles.length) {
        empty.hidden = false;
        $('#g-empty-text').textContent = ST.garage.type === 'impound' ? t('ui_empty_impound') : t('ui_empty');
    } else {
        empty.hidden = true;
    }

    // OFFICER ROSTER (D). An officer opens the impound to answer "who has cars in
    // here", so the rail becomes a list of PLAYERS with their vehicles nested
    // under them, rather than one flat grid in which two owners' cars interleave.
    // Cards keep their own click/detail behaviour, so Release stays per-vehicle.
    const roster = ST.garage.type === 'impound' && !!ST.garage.officer;
    if (roster) {
        list.sort((a, b) =>
            String(ownerOf(a)).localeCompare(String(ownerOf(b))) ||
            (a.label || '').localeCompare(b.label || ''));
    }
    let lastOwner = null;

    list.forEach((v) => {
        if (roster) {
            const who = ownerOf(v);
            if (who !== lastOwner) {
                lastOwner = who;
                const n = list.filter(x => ownerOf(x) === who).length;
                const head = document.createElement('div');
                head.className = 'veh-group';
                head.innerHTML = `<i class="fa-solid fa-user"></i>` +
                    `<span class="vg-name">${esc(who)}</span>` +
                    `<span class="chip">${n}</span>`;
                wrap.appendChild(head);
            }
        }
        const st = statusOf(v);
        const card = document.createElement('div');
        card.className = 'veh-card' + (v.out ? ' oos' : '') + (ST.selected === v ? ' active' : '');
        card.innerHTML = `
            <div class="veh-thumb">${imgTag(v.spawn, monogram(v.label))}</div>
            <div class="veh-info">
                <div class="veh-brand">${esc(v.nickname || (v.class === 'air' ? t('ui_brand_air') : v.class === 'sea' ? t('ui_brand_sea') : t('ui_brand_car')))}</div>
                <div class="veh-name">${esc(v.label || t('ui_vehicle'))}${v.financed ? '<i class="fa-solid fa-file-invoice-dollar veh-fin" title="' + esc(t('ui_financed')) + '"></i>' : ''}</div>
                <div class="veh-plate">${esc(v.plate || '')}${typeof v.km === 'number' && v.km > 0 ? ' · ' + v.km.toLocaleString('en-US') + ' km' : ''}</div>
            </div>
            <div class="veh-dot ${st.cls}" title="${esc(st.label)}"></div>`;
        // Move the highlight in place. Calling renderList() here would rebuild
        // every card, recreating each <img> — which made all the thumbnails
        // visibly reload on every selection.
        on(card, 'click', () => {
            if (ST.selected === v) return;
            ST.selected = v;
            $$('.veh-card', wrap).forEach(c => c.classList.remove('active'));
            card.classList.add('active');
            renderDetail(v);
        });
        wrap.appendChild(card);
    });

    // Never open on an empty detail pane: if nothing is selected (first open) or
    // the selection was filtered out, fall back to the first vehicle so the
    // panel — and the world preview — always start on something.
    if (!ST.selected || list.indexOf(ST.selected) === -1) {
        if (list.length) {
            ST.selected = list[0];
            const cards = $$('.veh-card', wrap);
            cards.forEach(c => c.classList.remove('active'));
            if (cards[0]) cards[0].classList.add('active');
            renderDetail(list[0]);
        } else {
            $('#g-detail').hidden = true;
        }
    }
}

function bar(icon, label, val) {
    const v = Math.max(0, Math.min(100, Math.round(val)));
    const cls = v <= 20 ? 'bad' : (v <= 45 ? 'warn' : '');
    return `<div class="stat-row">
        <div class="stat-label"><i class="fa-solid ${icon}"></i>${esc(label)}</div>
        <div class="stat-bar"><div class="stat-fill ${cls}" style="width:${v}%"></div></div>
        <div class="stat-val">${v}%</div></div>`;
}

// ---- impound availability -------------------------------------------------
// What the server ACTUALLY sends (Impound.List / Impound.StatusMap) is
// `retrievalAt` — an absolute unix timestamp in SECONDS — and `ready`, its own
// verdict at the moment the list was built. There is no `readyIn`; reading one
// produced Number(undefined) → NaN, and the countdown never displayed.
//
// An absolute moment also needs no list stamp to stay honest: a panel left open
// keeps counting down on its own, because the target does not move.
//
// `ready` remains the ONLY thing that decides whether the action is offered —
// the clock below is presentation, so a fast or skewed client cannot talk itself
// into an early collection.
function impRemaining(v) {
    if (v.ready) return 0;
    const at = Number(v.retrievalAt);
    if (!isFinite(at) || at <= 0) return 0;
    return Math.max(0, Math.round(at - Date.now() / 1000));
}

// Which lot the car is sitting in, and who filed it. Named `garageLabel` /
// `impoundedBy` by both server producers (Impound.StatusMap decorating an
// ordinary garage row, and Impound.List inside the lot itself); the older
// `impoundLabel` / `officerName` are kept as fallbacks so neither side of the
// wire has to change in lockstep with the other.
function impLotLabel(v) { return v.garageLabel || v.impoundLabel || ''; }
function impOfficer(v)  { return v.impoundedBy || v.officerName || ''; }

function impDuration(sec) {
    sec = Math.max(0, Math.floor(Number(sec) || 0));
    const h = Math.floor(sec / 3600);
    const m = Math.ceil((sec % 3600) / 60);
    if (h && m) return t('ui_dur_hm').replace('%h', h).replace('%m', m);
    if (h) return t('ui_dur_h').replace('%s', h);
    // never round a live wait down to "0m" — it reads as "you can go now"
    return t('ui_dur_m').replace('%s', Math.max(1, m));
}

function renderDetail(v) {
    const det = $('#g-detail');
    det.hidden = false;
    // swap the world preview to this vehicle (guarded: the preview dock block
    // lives at the bottom of this file and is optional in trimmed builds)
    if (window.apxPreview) window.apxPreview(v);
    const st = statusOf(v);

    // Only rebuild the hero <img> when the vehicle actually changed — a plain
    // list refresh would otherwise make the picture flash.
    const hero = $('#d-hero');
    const heroKey = String(v.spawn || v.plate || '');
    if (hero.dataset.key !== heroKey) {
        hero.dataset.key = heroKey;
        hero.className = 'det-hero veh-thumb';
        hero.innerHTML = imgTag(v.spawn, monogram(v.label));
    }

    $('#d-brand').textContent = ST.garage.label || '';
    $('#d-name').textContent = v.label || t('ui_vehicle');
    $('#d-plate').textContent = v.plate || '';
    const badge = $('#d-status');
    badge.className = 'badge ' + st.badge;
    badge.textContent = st.label;

    const nick = $('#d-nick');
    if (v.nickname) { nick.hidden = false; $('#d-nick-text').textContent = v.nickname; } else { nick.hidden = true; }

    $('#d-stats').innerHTML =
        bar('fa-gas-pump', t('ui_fuel'), v.fuel) +
        bar('fa-gears', t('ui_engine'), v.engine) +
        bar('fa-car-side', t('ui_body'), v.body);

    // financing (only present if apex_dealerships added the columns)
    const fin = $('#d-fin');
    if (v.financed) {
        fin.hidden = false;
        $('#d-fin-text').textContent = t('ui_financed');
        $('#d-fin-owed').textContent = money(v.owed || 0);
    } else {
        fin.hidden = true;
    }

    // meta chips (mileage)
    const meta = $('#d-meta');
    const chips = [];
    if (typeof v.km === 'number') chips.push(`<span class="meta-chip"><i class="fa-solid fa-road"></i>${v.km.toLocaleString('en-US')} km</span>`);
    meta.innerHTML = chips.join('');

    // impound info block — this is requirement B's payload: an owner standing in
    // an ORDINARY garage must be able to read what happened to their car without
    // going anywhere, so every line below renders in both garage types.
    const imp = $('#d-impound');
    if (v.impound) {
        imp.hidden = false;
        const lines = [];
        const line = (label, val, cls) =>
            `<div class="imp-line"><span>${esc(label)}</span><span class="${cls || ''}">${esc(val)}</span></div>`;

        // The owner is named to an officer only: it is the one field the owner
        // already knows and the one an officer needs to act on.
        if (ST.garage.officer) lines.push(line(t('ui_owner'), ownerOf(v)));
        const where = impLotLabel(v), who = impOfficer(v);
        if (where) lines.push(line(t('ui_impound_held_at'), where));
        if (who)   lines.push(line(t('ui_impound_officer'), who));
        // An empty reason is a legitimate value, not missing data — say so
        // explicitly rather than leaving a blank right-hand column. This line is
        // requirement B's core: an owner in an ORDINARY garage learns WHY the car
        // is gone without walking to the lot.
        lines.push(line(t('ui_reason'), v.reason || t('ui_impound_no_reason'), 'imp-reason'));

        if (v.retrievable) {
            lines.push(line(t('ui_impound_release'), t('ui_impound_release_owner'), 'imp-ok'));
            const left = impRemaining(v);
            lines.push(line(t('ui_impound_available'),
                left > 0 ? impDuration(left) : t('ui_impound_available_now')));
            lines.push(line(t('ui_impound_cost'), v.fee ? money(v.fee) : t('ui_impound_free')));
        } else {
            lines.push(line(t('ui_impound_release'), t('ui_impound_release_police'), 'imp-lock'));
        }
        $('#di-lines').innerHTML = lines.join('');
    } else {
        imp.hidden = true;
    }

    renderActions(v);
}

/* A take-out is not instant: the claim is a server round trip and the vehicle
   model may still have to stream in, so several seconds can pass between the
   click and the car existing. The button used to stay live for all of it with no
   feedback whatsoever, so people pressed it again — and the second press is the
   one that failed, because the server answers a concurrent claim with 'busy' and
   a repeat of a claim that already landed with 'already_out'. An error toast then
   appeared over a take-out that was actually working, which is what the report
   "you have to click several times" describes.

   Any handler that talks to Lua returns the post() promise, and post() settles
   exactly when the Lua callback calls cb() — i.e. when the work is genuinely
   done. So holding the button dead until it settles needs no timers and no
   guessing. Handlers that just open a sub-panel return undefined and are left
   alone. client/modules/spawn.lua carries the same guard, because this file is
   owner-editable and a reskin can drop this one. */
function actionBtn(cls, icon, label, handler, disabled) {
    const b = document.createElement('button');
    b.className = 'btn ' + cls;
    b.innerHTML = `<i class="fa-solid ${icon}"></i><span>${esc(label)}</span>`;
    if (disabled) { b.disabled = true; return b; }
    on(b, 'click', () => {
        if (b.disabled) return;
        let r;
        try { r = handler(); } catch (e) { return; }
        if (r && typeof r.then === 'function') {
            b.disabled = true;
            b.classList.add('is-busy');
            r.then(() => {}, () => {}).then(() => {
                b.disabled = false;
                b.classList.remove('is-busy');
            });
        }
    });
    return b;
}

function renderActions(v) {
    const box = $('#d-actions');
    box.innerHTML = '';

    if (v.impound) {
        // Standing in an ORDINARY garage looking at an impounded car (B). There is
        // no take-out here at all — the car is not in this building. The control
        // exists purely to say so, because an absent button reads as a rendering
        // fault and a live one reads as a car you can drive away.
        //
        // WHY it is dead comes off `blocked`, the e_ locale suffix the server
        // already sends for exactly this everywhere else in the list (see the
        // generic branch at the bottom of this function) — the reason belongs on
        // the control, not in a toast fired after a click that looked valid. The
        // lot is appended so the same control also says WHERE the car went.
        if (ST.garage.type !== 'impound') {
            const where = impLotLabel(v);
            const why = v.blocked ? t('e_' + v.blocked) : t('ui_at_impound');
            const b = actionBtn('btn-primary btn-lg btn-truncate', 'fa-car-burst',
                where ? `${why} · ${where}` : why, null, true);
            // The impound reason itself is already a line in the detail block
            // above; repeat it on hover so the control is self-explanatory.
            b.title = v.reason || t('ui_impound_no_reason');
            box.appendChild(b);
            return;
        }

        if (v.officer) {
            box.appendChild(actionBtn('btn-primary btn-lg', 'fa-car', t('ui_drive'),
                () => post('impoundTakeOut', { plate: v.plate, mode: 'officer' })));
            // The escape hatch for a locked car: hand it back without spawning it,
            // so the owner picks it up from a garage in their own time.
            box.appendChild(actionBtn('btn-ghost', 'fa-rotate-left', t('ui_release'),
                () => post('impoundRelease', { plate: v.plate })));
            return;
        }

        // Owner side. Why the car cannot be collected belongs ON the button — a
        // live button that answers with a toast reads as a failed action rather
        // than one that was never available. Same convention as v.blocked below.
        if (!v.retrievable) {
            box.appendChild(actionBtn('btn-primary btn-lg', 'fa-lock', t('ui_impound_release_police'), null, true));
            return;
        }
        const left = impRemaining(v);
        if (!v.ready) {
            box.appendChild(actionBtn('btn-primary btn-lg', 'fa-hourglass-half',
                t('ui_impound_wait').replace('%s', impDuration(left)), null, true));
            return;
        }
        // Zero is a real price, not "unset" — say Free rather than dropping the
        // suffix, so a free collection still explains itself.
        box.appendChild(actionBtn('btn-primary btn-lg', 'fa-hand-holding-dollar',
            `${t('ui_recover')} · ${v.fee ? money(v.fee) : t('ui_impound_free')}`,
            () => post('impoundTakeOut', { plate: v.plate, mode: 'owner' })));
        return;
    }

    if (v.spawner) {
        box.appendChild(actionBtn('btn-primary btn-lg', 'fa-car', t('ui_drive'),
            () => post('takeOut', { plate: v.plate, spawnerIndex: v.spawnerIndex })));
        return;
    }

    // v.out is the server's RESOLVED answer: this plate is still physically in
    // the world, so pulling it again would duplicate the car. State that on the
    // button itself — clicking a live button only to be told "already out" by a
    // toast reads as the action having failed, when it was never available.
    // The server sends WHY a car cannot be taken, as an e_ locale suffix, so the
    // reason sits on the button instead of arriving as a toast after a click that
    // looked like it should work. A car merely out in the world is never blocked —
    // that is the Recover case, and the fee is what resolves it.
    if (v.blocked) {
        box.appendChild(actionBtn('btn-primary btn-lg', 'fa-car-on', t('e_' + v.blocked), null, true));
    } else {
        const leftOut = !v.inGarage;
        const takeLabel = leftOut && ST.fees.ret
            ? `${t('ui_return_drive')} · ${money(ST.fees.ret)}`
            : t('ui_drive');
        box.appendChild(actionBtn('btn-primary btn-lg', leftOut ? 'fa-truck-ramp-box' : 'fa-car',
            takeLabel, () => post('takeOut', { plate: v.plate })));
    }

    if (ST.enableGarageTransfer || ST.enablePlayerTransfer) {
        box.appendChild(actionBtn('btn-ghost', 'fa-right-left', t('ui_transfer'), () => openTransfer(v)));
    }
    box.appendChild(actionBtn('btn-ghost', 'fa-tag', t('ui_nickname_set'), () => openNick(v)));

    // Instant sell — only where apex_dealerships supplies a price, and never
    // for a financed car (the server refuses those anyway). Job/gang garages
    // hold society cars filed under the job key, which the server can never
    // sell, so the button must not appear there at all.
    const personal = ST.garage.type === 'public' || ST.garage.type === 'private';
    if (personal && ST.instantSell && ST.instantSell.enabled && !v.financed) {
        const label = v.sellValue ? `${t('ui_sell')} · ${money(v.sellValue)}` : t('ui_sell');
        box.appendChild(actionBtn('btn-ghost', 'fa-hand-holding-dollar', label, () => openSell(v)));
    }
}

// ---- instant sell confirmation ----
function openSell(v) {
    const name = v.nickname || v.label || v.plate;
    const amount = v.sellValue ? money(v.sellValue) : '—';
    const ov = document.createElement('div'); ov.className = 'overlay';
    ov.innerHTML = `<div class="modal modal-sm">
        <div class="modal-head"><div><div class="eyebrow">APEX GARAGE</div><div class="modal-title">${esc(t('ui_sell_title'))}</div></div><button class="icon-btn sl-x"><i class="fa-solid fa-xmark"></i></button></div>
        <div class="modal-body">
            <div class="muted">${esc(t('ui_sell_confirm').replace('%s', name).replace('%s', amount))}</div>
        </div>
        <div class="modal-foot"><button class="btn btn-ghost sl-c">${esc(t('ui_cancel'))}</button><button class="btn btn-primary btn-lg sl-ok">${esc(t('ui_sell'))}</button></div></div>`;
    document.body.appendChild(ov);
    on($('.sl-x', ov), 'click', () => ov.remove());
    on($('.sl-c', ov), 'click', () => ov.remove());
    on($('.sl-ok', ov), 'click', () => { post('sellVehicle', { plate: v.plate }); ov.remove(); });
}

// ============================================================
// TRANSFER MODAL
// ============================================================
let trState = { veh: null, tab: 'garage', garageId: null, playerId: null };

function openTransfer(v) {
    trState = { veh: v, tab: ST.enableGarageTransfer ? 'garage' : 'player', garageId: null, playerId: null };
    $('#tr-title').textContent = t('ui_transfer_title');
    $('#tr-garage-label').textContent = t('ui_transfer_pick_garage');
    $('#tr-player-label').textContent = t('ui_transfer_pick_player');
    $('#tr-fee-label').textContent = t('ui_fee');
    $('#tr-fee').textContent = money(ST.fees.transfer || 0);
    $('#tr-cancel').textContent = t('ui_cancel');
    $('#tr-confirm').textContent = t('ui_confirm');

    // segmented tabs
    const seg = $('#tr-seg');
    seg.innerHTML = '';
    const tabs = [];
    if (ST.enableGarageTransfer) tabs.push({ k: 'garage', l: t('ui_transfer_garage') });
    if (ST.enablePlayerTransfer) tabs.push({ k: 'player', l: t('ui_transfer_player') });
    tabs.forEach(tb => {
        const b = document.createElement('button');
        b.textContent = tb.l;
        b.className = trState.tab === tb.k ? 'active' : '';
        on(b, 'click', () => { trState.tab = tb.k; renderTransferTab(); });
        seg.appendChild(b);
    });
    seg.hidden = tabs.length < 2;

    renderTransferTab();
    show('#transfer-overlay');
}

function renderTransferTab() {
    $$('#tr-seg button').forEach(b => b.classList.toggle('active',
        (trState.tab === 'garage' && b.textContent === t('ui_transfer_garage')) ||
        (trState.tab === 'player' && b.textContent === t('ui_transfer_player'))));
    $('#tr-garage-block').hidden = trState.tab !== 'garage';
    $('#tr-player-block').hidden = trState.tab !== 'player';
    trState.garageId = null; trState.playerId = null;
    updateTransferConfirm();

    if (trState.tab === 'garage') {
        const wrap = $('#tr-garages');
        wrap.innerHTML = '';
        ST.transfers.filter(g => g.id !== ST.garage.id).forEach(g => {
            const it = document.createElement('div');
            it.className = 'pick-item';
            it.innerHTML = `<span>${esc(g.label)}</span>`;
            on(it, 'click', () => {
                trState.garageId = g.id;
                $$('#tr-garages .pick-item').forEach(x => x.classList.remove('active'));
                it.classList.add('active'); updateTransferConfirm();
            });
            wrap.appendChild(it);
        });
    } else {
        const wrap = $('#tr-players');
        wrap.innerHTML = `<div class="muted" style="padding:8px">…</div>`;
        post('nearbyPlayers').then(r => {
            const players = (r && r.players) || [];
            wrap.innerHTML = '';
            if (!players.length) { wrap.innerHTML = `<div class="muted" style="padding:8px">${esc(t('ui_transfer_no_players'))}</div>`; return; }
            players.forEach(pl => {
                const it = document.createElement('div');
                it.className = 'pick-item';
                it.innerHTML = `<span>${esc(pl.name)}</span><span class="pid">#${pl.id}</span>`;
                on(it, 'click', () => {
                    trState.playerId = pl.id;
                    $$('#tr-players .pick-item').forEach(x => x.classList.remove('active'));
                    it.classList.add('active'); updateTransferConfirm();
                });
                wrap.appendChild(it);
            });
        });
    }
}

function updateTransferConfirm() {
    const ok = trState.tab === 'garage' ? !!trState.garageId : !!trState.playerId;
    $('#tr-confirm').disabled = !ok;
}

on($('#tr-confirm'), 'click', () => {
    const v = trState.veh; if (!v) return;
    if (trState.tab === 'garage' && trState.garageId) {
        post('transferGarage', { plate: v.plate, garageId: trState.garageId });
    } else if (trState.tab === 'player' && trState.playerId) {
        post('transferPlayer', { plate: v.plate, targetId: trState.playerId });
    }
    hide('#transfer-overlay');
});
on($('#tr-cancel'), 'click', () => hide('#transfer-overlay'));
on($('#tr-close'), 'click', () => hide('#transfer-overlay'));

// ============================================================
// NICKNAME MODAL
// ============================================================
let nickVeh = null;
function openNick(v) {
    nickVeh = v;
    $('#nk-title').textContent = t('ui_nickname');
    $('#nk-input').value = v.nickname || '';
    $('#nk-input').placeholder = t('ui_nickname_ph');
    $('#nk-cancel').textContent = t('ui_cancel');
    show('#nick-overlay');
    setTimeout(() => $('#nk-input').focus(), 30);
}
on($('#nk-confirm'), 'click', () => {
    if (!nickVeh) return;
    post('nickname', { plate: nickVeh.plate, nickname: $('#nk-input').value.trim() });
    hide('#nick-overlay');
});
on($('#nk-cancel'), 'click', () => hide('#nick-overlay'));
on($('#nk-close'), 'click', () => hide('#nick-overlay'));

// ============================================================
// IMPOUND FORM
// ============================================================
// `retrievable` starts FALSE. Letting the owner buy the car back is the weaker
// outcome and the only one the officer can grant, so it has to be an explicit
// act; a locked car can always be released later, an un-locked one cannot be
// taken back once the owner has paid.
let impForm = { retrievable: false, time: 0, fee: 0, lot: '' };
let ddTime, ddLot;

// One place decides what the switch looks like AND whether the dependent fields
// exist, so the two can never disagree.
function syncImpRetrievable() {
    const sw = $('#im-retr'), box = $('#im-retr-fields');
    if (sw) { sw.classList.toggle('on', !!impForm.retrievable); sw.setAttribute('aria-checked', String(!!impForm.retrievable)); }
    if (box) box.hidden = !impForm.retrievable;
}

function openImpoundForm(p) {
    // The lot list is fetched by Lua behind the officer check and only then sent
    // here — an empty list means "the server will file it at the nearest lot",
    // which is the pre-existing behaviour and stays the fallback.
    const lots  = Array.isArray(p.lots) ? p.lots : [];
    const times = (p.timeOptions && p.timeOptions.length) ? p.timeOptions : [0];
    impForm = { retrievable: false, time: times[0], fee: 0, lot: lots.length ? lots[0].id : '' };
    setI18n(p.i18n);
    ST.currency = p.currency || ST.currency;
    applyTheme(p.theme);

    $('#im-title').textContent = t('ui_impound_title');
    $('#im-veh').textContent = p.label || '';
    $('#im-plate').textContent = p.plate || '';
    $('#im-lot-l').textContent = t('ui_impound_lot');
    $('#im-reason-l').textContent = t('ui_impound_reason');
    $('#im-reason').value = '';
    $('#im-reason').placeholder = t('ui_impound_reason_ph');
    $('#im-retr-l').textContent = t('ui_impound_retrievable');
    $('#im-retr-d').textContent = t('ui_impound_retrievable_desc');
    $('#im-time-l').textContent = t('ui_impound_time');
    $('#im-cost-l').textContent = t('ui_impound_cost');
    $('#im-confirm-l').textContent = t('ui_impound_confirm');
    $('#im-cancel').textContent = t('ui_cancel');
    $('#im-fee').value = 0;

    // lot dropdown (a native <select> cannot be styled in CEF — see makeDropdown)
    ddLot = makeDropdown('dd-lot',
        () => (lots.length ? lots.map(l => ({ value: l.id, label: l.label || l.id, icon: 'fa-car-burst' }))
                           : [{ value: '', label: t('ui_impound_lot_nearest'), icon: 'fa-location-crosshairs' }]),
        () => impForm.lot,
        (v) => { impForm.lot = v; ddLot.render(); });
    ddLot.render();

    // time dropdown — the zero option is not "unset", it is "collectable now"
    ddTime = makeDropdown('dd-time',
        () => times.map(h => ({ value: h, label: h === 0 ? t('ui_time_now') : t('ui_hours').replace('%s', h) })),
        () => impForm.time,
        (v) => { impForm.time = v; ddTime.render(); });
    ddTime.render();

    syncImpRetrievable();
    show('#impound-overlay');
}

on($('#im-retr'), 'click', () => {
    impForm.retrievable = !impForm.retrievable;
    // Reset on the way OFF, not on the way back on: leaving a typed fee and an
    // hour count in the payload would put a real deadline and a real price on a
    // car nobody is allowed to collect.
    if (!impForm.retrievable) { $('#im-fee').value = 0; }
    syncImpRetrievable();
});

on($('#im-confirm'), 'click', () => {
    const retr = !!impForm.retrievable;
    post('impoundConfirm', {
        garageId: impForm.lot || '',
        reason: $('#im-reason').value.trim(),
        retrievable: retr,
        // A locked car has no availability and no price by definition; sending
        // zeroes keeps the record coherent regardless of what the hidden fields
        // happen to hold.
        time: retr ? impForm.time : 0,
        fee: retr ? Math.max(0, parseInt($('#im-fee').value, 10) || 0) : 0,
    });
    hide('#impound-overlay');
});
on($('#im-cancel'), 'click', () => { post('impoundCancel'); hide('#impound-overlay'); });
on($('#im-close'), 'click', () => { post('impoundCancel'); hide('#impound-overlay'); });

// ============================================================
// 3D world prompt
// ============================================================
const w3d = $('#world-3d-icon');
function show3D(m) {
    applyTheme(m.theme);        // carried only when the badge first appears
    w3d.hidden = false;
    w3d.style.transform = `translate(-50%,-50%) translate(${m.x * 100}vw, ${m.y * 100}vh) scale(${m.scale})`;
    $('#w3d-icon').className = 'fa-solid fa-' + (m.icon || 'warehouse');
    $('#w3d-label').textContent = m.label || '';
    $('.w3d-key', w3d).textContent = m.key || 'E';
}
function hide3D() { w3d.hidden = true; }

// ============================================================
// screen helpers
// ============================================================
function show(sel) { $(sel).hidden = false; }
function hide(sel) { $(sel).hidden = true; }
function anyModalOpen() { return $$('.overlay').some(o => !o.hidden); }
function closeAll() {
    // the private screen holds focus of its own, so it can't just be hidden
    if ($('#priv-overlay')) closePrivate();
    hide('#garage'); $$('.overlay').forEach(o => o.hidden = true);
    ST.selected = null;
}

// search
on($('#g-search'), 'input', (e) => { ST.search = e.target.value; renderList(); });

// leave
on($('#g-close'), 'click', () => { closeAll(); post('close'); });

// ESC
on(document, 'keydown', (e) => {
    if (e.key !== 'Escape') return;
    // dynamically-added overlays (player picker / vehicle dialog) close first
    const temps = $$('.overlay').filter(o => !o.id && !o.hidden);
    if (temps.length) { temps[temps.length - 1].remove(); return; }
    // the private-garage screen owns the focus, so it has to hand it back
    if ($('#priv-overlay')) { closePrivate(); return; }
    if (!$('#impound-overlay').hidden) { post('impoundCancel'); hide('#impound-overlay'); return; }
    if (ED.open) { closeEditor(); return; }
    if (!$('#admin').hidden) { closeAdmin(); post('admClose'); return; }
    if (!$('#boss').hidden) { closeBoss(); post('bossClose'); return; }
    if (anyModalOpen()) { $$('.overlay').forEach(o => o.hidden = true); return; }
    if (!$('#garage').hidden) { closeAll(); post('close'); }
});

// ============================================================
// message bus
// ============================================================
window.addEventListener('message', (ev) => {
    const msg = ev.data; if (!msg || !msg.action) return;
    switch (msg.action) {
        case 'open':        openGarage(msg.payload || {}); break;
        case 'refresh':     onRefresh(msg.payload || {}); break;
        case 'close':       closeAll(); break;
        case 'impoundForm': openImpoundForm(msg.payload || {}); break;
        case 'show3DIcon':  show3D(msg); break;
        case 'hide3DIcon':  hide3D(); break;
        case 'preview_ready': onPreviewReady(msg.ok); break;
        case 'textui':      msg.show ? showTui(msg) : hideTui(); break;
        case 'textui_progress': setTuiProgress(msg.pct); break;
        case 'placer':      msg.show ? showPlacer(msg) : hidePlacer(); break;
        case 'admin_open':    openAdmin(msg.payload || {}); break;
        case 'admin_refresh': admSetGarages((msg.payload || {}).garages || []); break;
        case 'admin_close':   closeAdmin(); break;
        case 'admin_hide':    $('#admin').hidden = true; $('#g-editor-overlay').hidden = true; break;
        case 'admin_show':    $('#admin').hidden = false; if (ED.open) $('#g-editor-overlay').hidden = false; break;
        case 'admDraft':      onDraft(msg.payload || {}); break;
        case 'boss_open':    openBossPanel(msg.payload || {}); break;
        case 'boss_refresh': bossSetGarages((msg.payload || {}).garages || []); break;
        case 'boss_close':   closeBoss(); break;
        // a live re-skin: repaint whatever is on screen, panel open or not
        case 'theme':        onThemeBroadcast(msg.payload || {}); break;
        // dictionary seed / re-seed — see the READY HANDSHAKE note at the foot
        case 'i18n':         onI18n(msg); break;
        case 'theme_open':   openThemePane(msg.payload || {}); break;
        case 'park_open':    openPark(msg.payload || {}); break;
        case 'private_open':    openPrivate(msg.payload || {}); break;
        case 'private_refresh': renderPrivate(msg.payload || {}); break;
        case 'park_refresh': pkSet(msg.payload || {}); break;
        case 'park_close':   closePark(); break;
    }
});

// ---- in-script TextUI + placer help ----
// The sentence ("Press [E] to open garage") is composed here, not in Lua:
// the label Lua sends is a standalone phrase ("Open garage") that we lowercase
// and slot in. The connecting words come from the locale table, which cannot be
// borrowed from a garage payload — the pill is up long before one arrives. Lua
// seeds ST.i18n over the 'i18n' message on the ready handshake (and re-seeds it
// on a locale change); a textui message may also carry a dict as a fallback
// while no handshake has completed yet, so both paths are honoured here.
// The English strings below are a last-resort fallback for a missing/partial
// dict — never render a raw key.
const TUI_POS = { right: 'tui-right', left: 'tui-left', top: 'tui-top', bottom: 'tui-bottom' };
const lowerFirst = (s) => (s ? s.charAt(0).toLowerCase() + s.slice(1) : '');
const tuiWord = (k, fallback) => {
    const v = ST.i18n && ST.i18n[k];
    return (typeof v === 'string' && v) ? v : fallback;
};

// A dictionary that lands while the pill is already on screen has to repaint it:
// the words below are baked into the DOM at render time, and Lua will not re-push
// a textui message for a player who has not moved. Only the two connecting words
// come from the table, so this is a two-node update, not a re-render — the
// slide-in animation is deliberately not replayed.
function onI18n(m) {
    setI18n(m && m.i18n);
    if (!$('#textui').hidden) {
        $('#tui-pre').textContent = tuiWord('ui_press_prefix', 'Press');
        $('#tui-suf').textContent = tuiWord('ui_press_suffix', 'to');
    }
}

function showTui(m) {
    // Normally seeded by the handshake; a message may still carry one as the
    // no-handshake-yet fallback. Later messages omit it, so keep what we cached.
    setI18n(m.i18n);
    applyTheme(m.theme);
    const el = $('#textui');
    $('#tui-ico').className = 'fa-solid fa-' + (m.icon || 'warehouse');
    $('#tui-key').textContent = m.key || 'E';
    $('#tui-pre').textContent = tuiWord('ui_press_prefix', 'Press');
    $('#tui-suf').textContent = tuiWord('ui_press_suffix', 'to');
    $('#tui-label').textContent = lowerFirst(m.text || '');

    setTuiProgress(0);              // a new prompt never inherits the old ring
    el.className = TUI_POS[m.position] || TUI_POS.right;
    el.hidden = false;
    // Un-hiding an element does not replay its CSS animation, so drop the class,
    // force a reflow to flush it, then put it back — that restarts the slide-in
    // on every appearance instead of only the first one.
    void el.offsetWidth;
    el.classList.add('tui-in');
}
function hideTui() {
    const el = $('#textui');
    el.classList.remove('tui-in');
    el.hidden = true;
    setTuiProgress(0);              // never leave a stale outline behind
}

// Hold-to-interact outline. The <rect> carries pathLength="100", so the offset
// is literally the remaining percentage — no perimeter maths, and it stays
// correct if the badge is ever resized. At 0 the outline is hidden outright
// rather than merely emptied, so nothing shows on a plain tap.
function setTuiProgress(pct) {
    const ring = $('#tui-ring');
    if (!ring) return;
    let p = Number(pct);
    if (!isFinite(p) || p < 0) p = 0; else if (p > 1) p = 1;
    ring.classList.toggle('on', p > 0);
    ring.firstElementChild.style.strokeDashoffset = String(100 - p * 100);
}
function showPlacer(m) {
    applyTheme(m.theme);
    $('#placer-title').textContent = m.title || '';
    const keys = (m.keys && m.keys.length) ? m.keys
        : [{ k: 'Scroll', l: m.rot || tuiWord('prompt_key_radius', 'Radius') }, { k: 'E', l: tuiWord('prompt_key_place', 'Place') }, { k: 'X', l: tuiWord('prompt_key_cancel', 'Cancel') }];
    $('#placer-keys').innerHTML = keys.map(x => `<span><b class="pk">${esc(x.k)}</b>${esc(x.l)}</span>`).join('');
    $('#placer').hidden = false;
}
function hidePlacer() { $('#placer').hidden = true; }

function onRefresh(p) {
    ST.vehicles = p.vehicles || [];
    if (p.me) { ST.me = p.me; updateMoney(); }
    // keep the selected vehicle by plate if it still exists
    const selPlate = ST.selected && ST.selected.plate;
    ST.selected = ST.vehicles.find(v => v.plate === selPlate) || null;
    if (ddCat) ddCat.render();
    renderList();
    if (ST.selected) renderDetail(ST.selected); else $('#g-detail').hidden = true;
}

// ============================================================
// ADMIN PANEL
// ============================================================
const ADM = { garages: [], filter: 'all', view: 'garages' };   // view: garages | parking | theme
const ED  = { open: false, gid: null, draft: null,
              state: { spawns: [], zone: null, store: false },   // pushed by Lua (admDraft)
              existing: { owners: 0 } };

function openAdmin(p) {
    setI18n(p.i18n);
    if (p.currency) ST.currency = p.currency;
    if (p.categories) ST.categories = p.categories;
    applyTheme(p.theme);
    admSetGarages(p.garages || []);
    $('#admin').hidden = false;
    $('#g-editor-overlay').hidden = true;
    ED.open = false;
}
function closeAdmin() {
    thmRestore();   // drop any unsaved colour drag before the panel goes away
    $('#admin').hidden = true; $('#g-editor-overlay').hidden = true; ED.open = false;
}
function admSetGarages(g) {
    ADM.garages = g || [];
    $('#adm-count').textContent = t(ADM.garages.length === 1 ? 'adm_count_one' : 'adm_count_many').replace('%s', ADM.garages.length);
    renderAdmNav(); renderAdmList();
}

// `l` holds a locale KEY, not a label: this table is built at load time, before
// the i18n dictionary arrives with the panel payload, so it is resolved lazily
// in renderAdmNav() below.
const ADM_FILTERS = [
    { k: 'all', l: 'ui_all', i: 'fa-layer-group' },
    { k: 'public', l: 'adm_type_public', i: 'fa-warehouse' },
    { k: 'job', l: 'adm_type_job', i: 'fa-briefcase' },
    { k: 'private', l: 'adm_type_private', i: 'fa-lock' },
    { k: 'impound', l: 'adm_type_impound', i: 'fa-car-burst' },
];
function renderAdmNav() {
    const nav = $('#adm-nav'); nav.innerHTML = '';
    ADM_FILTERS.forEach(f => {
        const n = ADM.garages.filter(g => f.k === 'all' || g.type === f.k).length;
        const b = document.createElement('button');
        b.className = (ADM.view === 'garages' && ADM.filter === f.k) ? 'active' : '';
        b.innerHTML = `<i class="fa-solid ${f.i}"></i><span>${esc(t(f.l))}</span><span style="flex:0;color:var(--text-4);font-size:10px">${n}</span>`;
        on(b, 'click', () => { thmRestore(); ADM.view = 'garages'; ADM.filter = f.k; renderAdmNav(); renderAdmList(); });
        nav.appendChild(b);
    });

    // Action entry rather than a type filter, so it sits under the filters with
    // a divider instead of pretending to be one of them.
    const sep = document.createElement('div');
    sep.style.cssText = 'height:1px;background:var(--border);margin:8px 4px';
    nav.appendChild(sep);

    const park = document.createElement('button');
    park.className = ADM.view === 'parking' ? 'active' : '';
    park.innerHTML = `<i class="fa-solid fa-square-parking"></i><span>${esc(t('pk_title'))}</span>`;
    // Lua answers with park_open, which flips the view and fills PK — the pane
    // then renders in place, no modal.
    on(park, 'click', () => { thmRestore(); post('parkOpen'); });
    nav.appendChild(park);

    const thm = document.createElement('button');
    thm.className = ADM.view === 'theme' ? 'active' : '';
    thm.innerHTML = `<i class="fa-solid fa-palette"></i><span>${esc(t('ui_theme'))}</span>`;
    // Same shape as parking: Lua answers with theme_open, which flips the view
    // and fills TH — the pane then renders in place.
    on(thm, 'click', () => post('themeOpen'));
    nav.appendChild(thm);
}

// The topbar belongs to whichever view is showing.
// Titles are resolved lazily: this table is built at load time, before the i18n
// dictionary arrives with the panel payload.
const ADM_VIEWS = {
    garages: { title: () => t('adm_garages'), icon: 'fa-warehouse' },
    parking: { title: () => t('pk_title'), icon: 'fa-square-parking' },
    theme:   { title: () => t('ui_theme'), icon: 'fa-palette' },
};
function syncAdmTopbar() {
    const v = ADM_VIEWS[ADM.view] || ADM_VIEWS.garages;
    const ttl = $('#adm-title'); if (ttl) ttl.textContent = v.title();
    const ico = $('.mg-tab-icon i', $('#admin'));
    if (ico) ico.className = 'fa-solid ' + v.icon;
    const nw = $('#adm-new'); if (nw) nw.hidden = ADM.view !== 'garages';   // "New garage" is garages-only
}
function admIcon(type) { return type === 'private' ? 'fa-lock' : (type === 'job' ? 'fa-briefcase' : (type === 'impound' ? 'fa-car-burst' : 'fa-warehouse')); }
function renderAdmList() {
    syncAdmTopbar();
    // The appearance pane lays its two columns out side by side and lets each one
    // scroll on its own, so the pane must stop scrolling for that view only.
    $('#adm-pane').classList.toggle('pane-fill', ADM.view === 'theme');
    if (ADM.view === 'parking') return renderPark();
    if (ADM.view === 'theme') return renderTheme();
    const pane = $('#adm-pane'); pane.innerHTML = '';
    const list = ADM.garages.filter(g => ADM.filter === 'all' || g.type === ADM.filter);
    if (!list.length) { pane.innerHTML = emptyState('fa-warehouse', t('adm_empty'), t('adm_empty_sub')); return; }
    list.forEach(g => {
        const row = document.createElement('div'); row.className = 'adm-row';
        // Where this garage lives. A config garage (shared/config.lua) is listed
        // so the admin can SEE it and teleport to it, but it has no editor and no
        // delete: it is edited in the file and the resource is restarted.
        const readonly = !!g.readonly;
        const sub = [g.source === 'config' ? t('adm_src_config') : t('adm_src_created'), g.type, g.class, (g.spawns || 0) + ' spawn(s)'];
        if (g.type === 'job') { sub.push(g.job || '—'); sub.push(g.vehiclesType); if (g.vehiclesType === 'spawner') { sub.push(g.stockMode); sub.push(t('adm_row_vehicles').replace('%s', g.count || 0)); } }
        row.innerHTML = `
            <div class="adm-row-ico"><i class="fa-solid ${admIcon(g.type)}"></i></div>
            <div class="adm-row-main"><div class="adm-row-title">${esc(g.label)}${readonly ? ` <span class="chip" style="margin-left:6px;vertical-align:middle">${esc(t('adm_src_config_chip'))}</span>` : ''}</div><div class="adm-row-sub">${esc(sub.join(' · '))}${readonly ? ` · ${esc(t('adm_src_config_hint'))}` : ''}</div></div>
            <div class="adm-row-actions">
                <button class="icon-action brand adm-tp" title="${esc(t('adm_tp_garage'))}"><i class="fa-solid fa-location-arrow"></i></button>
                ${readonly ? '' : `<button class="btn btn-ghost btn-sm adm-edit"><i class="fa-solid fa-pen"></i></button>
                <button class="btn btn-ghost btn-sm adm-del"><i class="fa-solid fa-trash"></i></button>`}
            </div>`;
        on($('.adm-tp', row), 'click', () => post('admTeleport', { kind: 'garage', gid: g.id }));
        if (readonly) { pane.appendChild(row); return; }
        on($('.adm-edit', row), 'click', () => openEditor(g));
        const del = $('.adm-del', row);
        on(del, 'click', () => {
            if (del.dataset.armed === '1') { post('admDelete', { gid: g.id }); return; }
            del.dataset.armed = '1'; del.classList.add('btn-danger'); del.innerHTML = '<i class="fa-solid fa-check"></i>';
            setTimeout(() => { if (del.isConnected) { del.dataset.armed = ''; del.classList.remove('btn-danger'); del.innerHTML = '<i class="fa-solid fa-trash"></i>'; } }, 2500);
        });
        pane.appendChild(row);
    });
}

// ---- editor ----
function defaultDraft() {
    return { gid: null, label: '', type: 'public', class: 'car', vehiclesType: 'personal',
             stockMode: 'infinite', job: '', minGrade: 0, bossGrade: 0, zoneShape: 'poly',
             ownerIds: [], owners: [], vehicles: [] };
}
// Stock mode only exists for a JOB + SPAWNER garage — that is the only shape the
// editor even renders the control for. Anywhere else the value is meaningless,
// but it used to survive in the draft: pick "by stock" on a spawner, switch the
// garage to personal or owned (or away from job entirely), save, and stock_mode
// = stock was persisted on a garage full of players' own cars — where the
// capacity check now answers "not infinite" and can refuse an ordinary personal
// vehicle. Normalised here, at every point the draft is built or changed, rather
// than in the save: the draft must never HOLD a value the garage cannot have.
function syncStockMode(d) {
    if (d.type !== 'job' || d.vehiclesType !== 'spawner') d.stockMode = 'infinite';
    return d;
}
function openEditor(g) {
    ED.state = { spawns: [], zone: null, store: false };
    // Lua seeds its draft from the stored record and pushes it back as admDraft
    post('admEditorOpen', { gid: g ? g.id : '' });
    if (g) {
        ED.gid = g.id;
        ED.existing = { owners: g.ownerCount || 0 };
        ED.draft = { gid: g.id, label: g.label, type: g.type, class: g.class,
                     vehiclesType: g.vehiclesType || 'personal', stockMode: g.stockMode || 'infinite',
                     job: g.job || '', minGrade: g.minGrade || 0, bossGrade: g.bossGrade || 0,
                     zoneShape: (g.zone && g.zone.shape) || 'poly',
                     ownerIds: [], owners: [], vehicles: (g.vehicles || []).map(v => ({ model: v.model, label: v.label, stock: v.stock || 0, minGrade: v.minGrade || 0 })) };
    } else {
        ED.gid = null; ED.existing = { owners: 0 }; ED.draft = defaultDraft();
    }
    // A garage saved before this was enforced can already carry the stale value;
    // opening it must not let that value ride back out on the next save.
    syncStockMode(ED.draft);
    ED.open = true;
    $('#ed-title').textContent = g ? t('adm_edit_garage') : t('adm_new_garage');
    renderEditor();
    $('#g-editor-overlay').hidden = false;
}

function onDraft(p) {
    ED.state = { spawns: p.spawns || [], zone: p.zone || null, store: !!p.store };
    if (ED.open) renderEditor();
}
function closeEditor() { ED.open = false; $('#g-editor-overlay').hidden = true; }

// An option may carry `badge` (a count); it renders as the same .chip the section
// heads use, so a seg can double as a tab strip without a second control.
function seg(id, current, opts) {
    return `<div class="seg" id="${id}">` + opts.map(o => `<button data-v="${o.v}" class="${current === o.v ? 'active' : ''}">${esc(o.l)}${o.badge != null ? ` <span class="chip">${esc(o.badge)}</span>` : ''}</button>`).join('') + `</div>`;
}
function wireSeg(id, onPick) { $$('#' + id + ' button').forEach(b => on(b, 'click', () => onPick(b.dataset.v))); }

function renderEditor() {
    const d = ED.draft;
    const isJob = d.type === 'job', isPriv = d.type === 'private', isImpound = d.type === 'impound';
    const isSpawner = isJob && d.vehiclesType === 'spawner';

    let html = `<div class="ed-sec">
        <div class="ed-sec-head"><i class="fa-solid fa-id-card"></i><span>${esc(t('ed_identification'))}</span></div>
        <div class="ed-grid">
        <div class="ed-field full"><label>${esc(t('ui_name'))}</label><input id="ed-label" type="text" maxlength="64" value="${esc(d.label)}" placeholder="${esc(t('ed_name_ph'))}"></div>
        <div class="ed-field full"><label>${esc(t('ed_type'))}</label>${seg('ed-type', d.type, [{v:'public',l:t('adm_type_public')},{v:'job',l:t('adm_type_job')},{v:'private',l:t('adm_type_private')},{v:'impound',l:t('adm_type_impound')}])}</div>
        <div class="ed-field"><label>${esc(t('ui_class'))}</label>${seg('ed-class', d.class, [{v:'car',l:t('ed_class_land')},{v:'air',l:t('ed_class_air')},{v:'sea',l:t('ed_class_sea')}])}</div>`;
    if (isJob || isImpound) {
        html += `<div class="ed-field"><label>${esc(isImpound ? t('ed_officer_job') : t('adm_type_job'))}</label><input id="ed-job" type="text" maxlength="48" value="${esc(d.job)}" placeholder="police"></div>`;
    }
    if (isJob) {
        html += `<div class="ed-field"><label>${esc(t('ed_veh_mode'))}</label>${seg('ed-mode', d.vehiclesType, [{v:'personal',l:t('ed_veh_mode_personal')},{v:'owned',l:t('ed_veh_mode_company')},{v:'spawner',l:t('ed_veh_mode_list')}])}</div>`;
        if (isSpawner) html += `<div class="ed-field"><label>${esc(t('ed_stock_mode'))}</label>${seg('ed-stock', d.stockMode, [{v:'infinite',l:t('ed_stock_infinite')},{v:'stock',l:t('ed_stock_by_stock')}])}</div>`;
        html += `<div class="ed-field"><label>${esc(t('ui_min_grade'))}</label><input id="ed-mingrade" type="number" min="0" value="${d.minGrade}"></div>
        <div class="ed-field"><label>${esc(t('ed_boss_grade'))}</label><input id="ed-bossgrade" type="number" min="0" value="${d.bossGrade}"></div>`;
    }
    if (isPriv) {
        html += `<div class="ed-field full"><label>${esc(t('ed_owners'))}</label><div class="ed-owners" id="ed-owners"></div>
            <button class="btn btn-ghost btn-sm" id="ed-owner-add" style="margin-top:6px;align-self:flex-start"><i class="fa-solid fa-user-plus"></i> ${esc(t('ed_owner_add'))}</button></div>`;
    }
    html += `</div></div>`;

    // ---------- world placement ----------
    const st = ED.state;
    const zoneSet = !!st.zone;
    const zoneSub = zoneSet
        ? (st.zone.shape === 'poly' ? t('ed_zone_poly').replace('%s', st.zone.points) : t('ed_zone_circle').replace('%s', st.zone.r ?? '?'))
        : t('ed_zone_unset');
    const storeSub = st.store ? t('ed_store_set') : t('ed_store_unset');

    html += `<div class="ed-sec">
        <div class="ed-sec-head"><i class="fa-solid fa-map-location-dot"></i><span>${esc(t('ed_placement'))}</span></div>
        <div class="ed-cards">

            <div class="ed-card"><div class="ed-card-row">
                <div class="ed-card-ico"><i class="fa-solid ${d.zoneShape === 'poly' ? 'fa-draw-polygon' : 'fa-circle-dot'}"></i></div>
                <div class="ed-card-body">
                    <div class="ed-card-title">${esc(t('ed_zone'))}</div>
                    <div class="ed-card-sub">${esc(zoneSub)}</div>
                </div>
                <div class="ed-card-actions">
                    <span class="chip ${zoneSet ? 'chip-ok' : ''}">${esc(zoneSet ? t('ui_state_set') : t('ui_state_unset'))}</span>
                    <div style="width:150px">${seg('ed-zshape', d.zoneShape, [{v:'poly',l:t('ui_shape_corners')},{v:'circle',l:t('ui_shape_circle')}])}</div>
                    ${zoneSet ? `<button class="icon-action brand" data-tp="zone" title="${esc(t('ed_tp_zone'))}"><i class="fa-solid fa-location-arrow"></i></button>` : ''}
                    <button class="btn btn-ghost btn-sm" data-place="zone">${esc(t('ui_set'))}</button>
                </div>
            </div></div>

            <div class="ed-card">
                <div class="ed-card-row">
                    <div class="ed-card-ico"><i class="fa-solid fa-square-parking"></i></div>
                    <div class="ed-card-body">
                        <div class="ed-card-title">${esc(t('ed_spawns'))}</div>
                        <div class="ed-card-sub">${esc(t('ed_spawns_sub'))}</div>
                    </div>
                    <div class="ed-card-actions">
                        <span class="chip ${st.spawns.length ? 'chip-ok' : ''}">${esc(st.spawns.length || t('ui_none'))}</span>
                        <button class="btn btn-ghost btn-sm" data-place="spawn"><i class="fa-solid fa-plus"></i> ${esc(t('ui_place'))}</button>
                        ${st.spawns.length ? `<button class="btn btn-ghost btn-sm" data-place="spawn_clear">${esc(t('ui_clear'))}</button>` : ''}
                    </div>
                </div>
                ${st.spawns.length ? `<div class="ed-spawn-list">${st.spawns.map((s, i) => `
                    <div class="ed-spawn">
                        <span class="ed-spawn-n">${i + 1}</span>
                        <span class="ed-spawn-co mono">${(s.x || 0).toFixed(1)}, ${(s.y || 0).toFixed(1)}, ${(s.z || 0).toFixed(1)}</span>
                        <span class="ed-spawn-h mono">${Math.round(s.w || 0)}°</span>
                        <button class="icon-action brand" data-tp="spawn" data-i="${i + 1}" title="${esc(t('ui_teleport'))}"><i class="fa-solid fa-location-arrow"></i></button>
                        <button class="icon-action danger" data-del="${i + 1}" title="${esc(t('ui_remove'))}"><i class="fa-solid fa-xmark"></i></button>
                    </div>`).join('')}</div>` : ''}
            </div>

            <div class="ed-card"><div class="ed-card-row">
                <div class="ed-card-ico"><i class="fa-solid fa-warehouse"></i></div>
                <div class="ed-card-body">
                    <div class="ed-card-title">${esc(t('ed_store_point'))}</div>
                    <div class="ed-card-sub">${esc(storeSub)}</div>
                </div>
                <div class="ed-card-actions">
                    ${st.store ? `<span class="chip chip-ok">${esc(t('ui_state_set'))}</span>
                        <button class="icon-action brand" data-tp="store" title="${esc(t('ui_teleport'))}"><i class="fa-solid fa-location-arrow"></i></button>
                        <button class="icon-action danger" data-storeclear title="${esc(t('ui_remove'))}"><i class="fa-solid fa-xmark"></i></button>` : ''}
                    <button class="btn btn-ghost btn-sm" data-place="store">${esc(t('ui_set'))}</button>
                </div>
            </div></div>

        </div>
    </div>`;

    // ---------- job vehicle list ----------
    if (isSpawner) {
        html += `<div class="ed-sec">
            <div class="ed-sec-head"><i class="fa-solid fa-car"></i><span>${esc(t('ed_list_vehicles'))}</span></div>
            <div class="ed-veh-list" id="ed-veh-list"></div>
            <button class="btn btn-ghost btn-sm" id="ed-veh-add" style="align-self:flex-start"><i class="fa-solid fa-plus"></i> ${esc(t('ui_add_vehicle'))}</button>
        </div>`;
    }

    $('#ed-body').innerHTML = html;
    $('#ed-foot').innerHTML =
        (ED.gid ? `<button class="btn btn-danger-ghost" id="ed-del"><i class="fa-solid fa-trash"></i> ${esc(t('ui_delete'))}</button>` : `<span></span>`) +
        `<div class="ed-foot-r">
            <button class="btn btn-ghost" id="ed-cancel">${esc(t('ui_cancel'))}</button>
            <button class="btn btn-primary btn-lg" id="ed-save"><i class="fa-solid fa-floppy-disk"></i> ${esc(t('ui_save'))}</button>
        </div>`;
    wireEditor();
}

function wireEditor() {
    const d = ED.draft;
    const bind = (id, key, num) => { const el = $('#' + id); if (el) on(el, 'input', e => d[key] = num ? (parseInt(e.target.value, 10) || 0) : e.target.value); };
    bind('ed-label', 'label'); bind('ed-job', 'job'); bind('ed-mingrade', 'minGrade', true); bind('ed-bossgrade', 'bossGrade', true);
    wireSeg('ed-type', v => { d.type = v; syncStockMode(d); renderEditor(); });
    wireSeg('ed-class', v => { d.class = v; renderEditor(); });
    if ($('#ed-mode')) wireSeg('ed-mode', v => { d.vehiclesType = v; syncStockMode(d); renderEditor(); });
    // Re-render like every other seg: the .active class is stamped at render
    // time, and the vehicle rows show/hide their stock column off this value.
    // Without the re-render the click landed on the draft but nothing moved,
    // which read as "the button is not clickable".
    if ($('#ed-stock')) wireSeg('ed-stock', v => { if (d.stockMode !== v) { d.stockMode = v; renderEditor(); } });
    if ($('#ed-zshape')) wireSeg('ed-zshape', v => { d.zoneShape = v; renderEditor(); });

    $$('[data-place]').forEach(b => on(b, 'click', () =>
        post('admPlace', { kind: b.dataset.place, class: d.class, shape: d.zoneShape,
                           r: ED.state.zone ? ED.state.zone.r : null })));
    $$('[data-tp]').forEach(b => on(b, 'click', () =>
        post('admTeleport', { kind: b.dataset.tp, index: b.dataset.i ? parseInt(b.dataset.i, 10) : undefined })));
    $$('[data-del]').forEach(b => on(b, 'click', () => post('admSpawnDelete', { index: parseInt(b.dataset.del, 10) })));
    const sc = $('[data-storeclear]'); if (sc) on(sc, 'click', () => post('admStoreClear'));

    if ($('#ed-owner-add')) { on($('#ed-owner-add'), 'click', addOwner); renderOwners(); }
    if ($('#ed-veh-add')) { on($('#ed-veh-add'), 'click', addVehicleRow); renderVehicles(); }
    if ($('#ed-del')) on($('#ed-del'), 'click', () => { post('admDelete', { gid: ED.gid }); closeEditor(); });
    on($('#ed-cancel'), 'click', closeEditor);
    on($('#ed-save'), 'click', saveEditor);
}

function renderOwners() {
    const wrap = $('#ed-owners'); if (!wrap) return;
    wrap.innerHTML = '';
    ED.draft.owners.forEach((o, i) => {
        const chip = document.createElement('span'); chip.className = 'ed-owner-chip';
        chip.innerHTML = `${esc(o.name)} <i class="fa-solid fa-xmark"></i>`;
        on($('i', chip), 'click', () => { ED.draft.owners.splice(i, 1); ED.draft.ownerIds = ED.draft.owners.map(x => x.id); renderOwners(); });
        wrap.appendChild(chip);
    });
    if (!ED.draft.owners.length) {
        wrap.innerHTML = ED.existing.owners
            ? `<span class="hint">${esc(t('ed_owners_existing').replace('%s', ED.existing.owners))}</span>`
            : `<span class="hint">${esc(t('ed_owners_none'))}</span>`;
    }
}
async function addOwner() {
    const r = await post('admPlayers');
    showPicker(t('adm_pick_player'), ((r && r.players) || []).map(p => ({ label: p.name, sub: '#' + p.id, val: p })), (p) => {
        if (!ED.draft.owners.find(o => o.id === p.id)) {
            ED.draft.owners.push({ id: p.id, name: p.name });
            ED.draft.ownerIds = ED.draft.owners.map(x => x.id);
            renderOwners();
        }
    });
}

function renderVehicles() {
    const wrap = $('#ed-veh-list'); if (!wrap) return;
    // The stock column is gated on the mode: offering a number that the server
    // ignores in 'infinite' mode would invite the owner to set it and expect it
    // to mean something.
    const byStock = ED.draft.stockMode === 'stock';
    wrap.innerHTML = '';
    ED.draft.vehicles.forEach((v, i) => {
        const row = document.createElement('div'); row.className = 'ed-veh';
        row.innerHTML = `<span class="evn">${esc(v.label || v.model)}</span><span class="evm">${esc(v.model)}</span>
            <span class="evg">${esc(t('ui_grade').replace('%s', v.minGrade || 0))}</span>
            <span style="margin-left:auto;display:flex;align-items:center;gap:8px">
            ${byStock ? `<span class="evs">${esc(t('ed_stock'))}</span>
                <div class="stock-step"><button data-d="-1">−</button><span>${v.stock || 0}</span><button data-d="1">+</button></div>` : ''}
            <button class="icon-action brand ev-edit" title="${esc(t('ui_edit'))}"><i class="fa-solid fa-pen"></i></button>
            <button class="icon-action danger ev-del" title="${esc(t('ui_remove'))}"><i class="fa-solid fa-xmark"></i></button></span>`;
        if (byStock) {
            $$('.stock-step button', row).forEach(b => on(b, 'click', () => {
                v.stock = Math.max(0, (v.stock || 0) + parseInt(b.dataset.d, 10));
                renderVehicles();
            }));
        }
        on($('.ev-edit', row), 'click', () => {
            showVehicleDialog(veh => { ED.draft.vehicles[i] = veh; renderVehicles(); }, { veh: v, stock: byStock });
        });
        on($('.ev-del', row), 'click', () => { ED.draft.vehicles.splice(i, 1); renderVehicles(); });
        wrap.appendChild(row);
    });
    if (!ED.draft.vehicles.length) wrap.innerHTML = `<span class="hint">${esc(t('ed_no_vehicles'))}</span>`;
}
function addVehicleRow() {
    showVehicleDialog((veh) => { ED.draft.vehicles.push(veh); renderVehicles(); },
                      { stock: ED.draft.stockMode === 'stock' });
}

async function saveEditor() {
    const d = ED.draft;
    const payload = {
        gid: d.gid || '', label: (d.label || '').trim(), type: d.type, class: d.class,
        vehiclesType: d.vehiclesType, stockMode: d.stockMode, job: (d.job || '').trim(),
        minGrade: d.minGrade, bossGrade: d.bossGrade,
    };
    if (d.type === 'private') payload.ownerIds = d.ownerIds;
    if (d.type === 'job' && d.vehiclesType === 'spawner') payload.vehicles = d.vehicles;
    const r = await post('admSave', payload);
    if (r && r.ok) closeEditor();
}

// ---- reusable overlays (picker + vehicle dialog) ----
function showPicker(title, items, onPick) {
    const ov = document.createElement('div'); ov.className = 'overlay';
    ov.innerHTML = `<div class="modal modal-sm"><div class="modal-head"><div><div class="eyebrow">APEX GARAGE</div><div class="modal-title">${esc(title)}</div></div><button class="icon-btn pk-x"><i class="fa-solid fa-xmark"></i></button></div><div class="modal-body"><div class="pick-list pk-list"></div></div></div>`;
    document.body.appendChild(ov);
    const list = $('.pk-list', ov);
    if (!items.length) list.innerHTML = `<div class="muted" style="padding:10px">${esc(t('adm_nobody_online'))}</div>`;
    items.forEach(it => {
        const el = document.createElement('div'); el.className = 'pick-item';
        el.innerHTML = `<span>${esc(it.label)}</span>${it.sub ? `<span class="pid">${esc(it.sub)}</span>` : ''}`;
        on(el, 'click', () => { onPick(it.val); ov.remove(); });
        list.appendChild(el);
    });
    on($('.pk-x', ov), 'click', () => ov.remove());
}
// opts.veh  -> edit that entry instead of adding a new one (fields pre-filled)
// opts.stock -> show the starting-stock field (garage is in 'stock' mode)
function showVehicleDialog(onOk, opts) {
    opts = opts || {};
    const cur = opts.veh || null;
    const ov = document.createElement('div'); ov.className = 'overlay';
    ov.innerHTML = `<div class="modal modal-sm"><div class="modal-head"><div><div class="eyebrow">APEX GARAGE</div><div class="modal-title">${esc(cur ? t('ed_veh_edit') : t('ui_add_vehicle'))}</div></div></div>
        <div class="modal-body">
            <div class="sec-title">${esc(t('ed_spawn_code'))}</div><input id="vd-model" type="text" placeholder="police" spellcheck="false" value="${esc(cur ? cur.model : '')}">
            <div class="sec-title">${esc(t('ui_name'))}</div><input id="vd-label" type="text" placeholder="${esc(t('ui_optional'))}" value="${esc(cur && cur.label !== cur.model ? cur.label : '')}">
            <div class="sec-title">${esc(t('ui_min_grade'))}</div><input id="vd-grade" type="number" min="0" value="${cur ? (cur.minGrade || 0) : 0}">
            ${opts.stock ? `<div class="sec-title">${esc(t('ed_stock_start'))}</div><input id="vd-stock" type="number" min="0" value="${cur ? (cur.stock || 0) : 0}">` : ''}
        </div>
        <div class="modal-foot"><button class="btn btn-ghost vd-c">${esc(t('ui_cancel'))}</button><button class="btn btn-primary btn-lg vd-ok">${esc(cur ? t('ui_save') : t('ui_add'))}</button></div></div>`;
    document.body.appendChild(ov);
    on($('.vd-c', ov), 'click', () => ov.remove());
    on($('.vd-ok', ov), 'click', () => {
        const model = ($('#vd-model', ov).value || '').trim().toLowerCase();
        if (!model) return;
        // No stock field on screen means the value must not be invented here:
        // keep whatever the entry already carried so switching a garage to
        // 'infinite' and back does not silently zero the shelf.
        const stockEl = $('#vd-stock', ov);
        const stock = stockEl ? (parseInt(stockEl.value, 10) || 0) : (cur ? (cur.stock || 0) : 0);
        onOk({ model, label: ($('#vd-label', ov).value || '').trim() || model, stock: Math.max(0, stock), minGrade: parseInt($('#vd-grade', ov).value, 10) || 0 });
        ov.remove();
    });
    setTimeout(() => $('#vd-model', ov).focus(), 30);
}

// ============================================================
// PRIVATE GARAGES (/garagensprivadas)
//   Built from the same modal + pick-list primitives as the pickers above, so
//   it lives inside OUR document and follows applyTheme — the ox_lib context
//   menu it replaces rendered in ox_lib's frame and could never be themed.
// ============================================================
const PRIV = { canCreate: false, classes: [] };

function closePrivate() {
    const ov = $('#priv-overlay');
    if (ov) ov.remove();
    post('privClose');
}

function openPrivate(p) {
    applyTheme(p.theme);
    setI18n(p.i18n);
    if ($('#priv-overlay')) $('#priv-overlay').remove();
    const ov = document.createElement('div');
    ov.className = 'overlay'; ov.id = 'priv-overlay';
    ov.innerHTML = `<div class="modal modal-sm">
        <div class="modal-head"><div><div class="eyebrow">APEX GARAGE</div><div class="modal-title">${esc(t('adm_priv_title'))}</div></div><button class="icon-btn pv-x"><i class="fa-solid fa-xmark"></i></button></div>
        <div class="modal-body"><div class="pick-list pv-list"></div></div>
        <div class="modal-foot pv-foot"></div></div>`;
    document.body.appendChild(ov);
    on($('.pv-x', ov), 'click', closePrivate);
    renderPrivate(p);
}

function renderPrivate(p) {
    const ov = $('#priv-overlay');
    if (!ov) return;
    applyTheme(p.theme);
    PRIV.canCreate = !!p.canCreate;
    PRIV.classes = p.classes || [];

    const list = $('.pv-list', ov);
    list.innerHTML = '';
    const garages = p.garages || [];
    if (!garages.length) {
        list.innerHTML = `<div class="muted" style="padding:10px">${esc(t('adm_priv_empty'))}</div>`;
    }
    garages.forEach(g => {
        const el = document.createElement('div');
        el.className = 'pick-item';
        el.innerHTML = `<span>${esc(g.label)}</span><span class="pid">${esc(g.class)}</span>`;
        on(el, 'click', () => confirmDeletePrivate(g));
        list.appendChild(el);
    });

    const foot = $('.pv-foot', ov);
    foot.innerHTML = PRIV.canCreate
        ? `<button class="btn btn-primary btn-lg pv-new">${esc(t('adm_priv_create_here'))}</button>`
        : `<button class="btn btn-ghost pv-c">${esc(t('ui_close'))}</button>`;
    on($('.pv-new', ov), 'click', createPrivateDialog);
    on($('.pv-c', ov), 'click', closePrivate);
}

// No id on these two, so the shared ESC handler pops them before the screen
// underneath — same convention as the player picker.
function confirmDeletePrivate(g) {
    const ov = document.createElement('div'); ov.className = 'overlay';
    ov.innerHTML = `<div class="modal modal-sm"><div class="modal-head"><div><div class="eyebrow">APEX GARAGE</div><div class="modal-title">${esc(g.label)}</div></div></div>
        <div class="modal-body"><div class="muted">${esc(t('adm_priv_delete_confirm'))}</div></div>
        <div class="modal-foot"><button class="btn btn-ghost pd-c">${esc(t('ui_cancel'))}</button><button class="btn btn-primary btn-lg pd-ok">${esc(t('ui_remove'))}</button></div></div>`;
    document.body.appendChild(ov);
    on($('.pd-c', ov), 'click', () => ov.remove());
    on($('.pd-ok', ov), 'click', () => { ov.remove(); post('privDelete', { id: g.id }); });
}

function createPrivateDialog() {
    const ov = document.createElement('div'); ov.className = 'overlay';
    // Class is a row of buttons, not a native <select> — CEF can't style the
    // popup of one (see the custom dropdown further up).
    const classes = PRIV.classes.length ? PRIV.classes : [{ value: 'car', label: t('adm_class_car_fallback') }];
    let cls = classes[0].value;
    const opts = classes.map((c, i) =>
        `<button class="btn ${i === 0 ? 'btn-primary' : 'btn-ghost'} pn-cls" data-v="${esc(c.value)}">${esc(c.label)}</button>`).join('');
    ov.innerHTML = `<div class="modal modal-sm"><div class="modal-head"><div><div class="eyebrow">APEX GARAGE</div><div class="modal-title">${esc(t('adm_priv_create_title'))}</div></div></div>
        <div class="modal-body">
            <div class="sec-title">${esc(t('ui_name'))}</div><input id="pv-label" type="text" maxlength="64" spellcheck="false">
            <div class="sec-title">${esc(t('ui_class'))}</div><div style="display:flex;gap:8px;flex-wrap:wrap">${opts}</div>
        </div>
        <div class="modal-foot"><button class="btn btn-ghost pn-c">${esc(t('ui_cancel'))}</button><button class="btn btn-primary btn-lg pn-ok">${esc(t('ui_create'))}</button></div></div>`;
    document.body.appendChild(ov);
    $$('.pn-cls', ov).forEach(b => on(b, 'click', () => {
        cls = b.dataset.v;
        $$('.pn-cls', ov).forEach(o => o.className = 'btn ' + (o === b ? 'btn-primary' : 'btn-ghost') + ' pn-cls');
    }));
    on($('.pn-c', ov), 'click', () => ov.remove());
    on($('.pn-ok', ov), 'click', () => {
        const label = ($('#pv-label', ov).value || '').trim();
        if (!label) return;
        ov.remove();
        post('privCreate', { label, class: cls });
    });
    setTimeout(() => $('#pv-label', ov).focus(), 30);
}

// static admin chrome
on($('#adm-new'), 'click', () => openEditor(null));
on($('#adm-close'), 'click', () => { closeAdmin(); post('admClose'); });
on($('#adm-close-2'), 'click', () => { closeAdmin(); post('admClose'); });
on($('#ed-close'), 'click', closeEditor);
on($('#adm-collapse'), 'click', () => { const s = $('.adm-shell'); if (s) s.classList.toggle('rail-collapsed'); });

// ============================================================
// BOSS MANAGEMENT PANEL (company garage)
// ============================================================
const BOSS = { garages: [], current: null };

function openBossPanel(p) {
    setI18n(p.i18n);
    applyTheme(p.theme);
    $('#boss-job').textContent = p.job || t('adm_company_fallback');
    bossSetGarages(p.garages || []);
    $('#boss').hidden = false;
}
function closeBoss() { $('#boss').hidden = true; }
function bossSetGarages(g) {
    BOSS.garages = g || [];
    if (!BOSS.garages.length) { closeBoss(); return; }
    if (!BOSS.current || !BOSS.garages.find(x => x.id === BOSS.current)) BOSS.current = BOSS.garages[0].id;
    renderBossNav(); renderBossPane();
}
function bossCurrent() { return BOSS.garages.find(g => g.id === BOSS.current); }
function renderBossNav() {
    const nav = $('#boss-nav'); nav.innerHTML = '';
    BOSS.garages.forEach(g => {
        const b = document.createElement('button');
        b.className = BOSS.current === g.id ? 'active' : '';
        b.innerHTML = `<i class="fa-solid fa-warehouse"></i><span>${esc(g.label)}</span>`;
        on(b, 'click', () => { BOSS.current = g.id; renderBossNav(); renderBossPane(); });
        nav.appendChild(b);
    });
}
function renderBossPane() {
    const g = bossCurrent(), pane = $('#boss-pane'); pane.innerHTML = '';
    if (!g) return;
    $('#boss-title').textContent = g.label;
    const stockMode = g.stockMode === 'stock';
    const vehicles = g.vehicles || [];

    const head = document.createElement('div');
    head.innerHTML = `<div style="display:flex;align-items:center;gap:8px;margin-bottom:2px">
        <span class="boss-badge"><i class="fa-solid fa-car"></i>${esc(t(vehicles.length === 1 ? 'ui_count_one' : 'ui_count_many').replace('%s', vehicles.length))}</span>
        <span class="boss-badge">${esc(stockMode ? t('adm_boss_stock') : t('adm_boss_infinite'))}</span></div>`;
    pane.appendChild(head);

    // The fleet is defined by the server owner in /apexgarage; the boss only
    // operates it. No add/remove is offered here because the server refuses
    // both regardless, and an armed button that always errors is worse than
    // no button at all.
    if (!vehicles.length) {
        pane.insertAdjacentHTML('beforeend', emptyState('fa-car', t('adm_boss_empty'), t('adm_boss_empty_adm')));
        return;
    }
    pane.insertAdjacentHTML('beforeend', `<div class="hint" style="margin-bottom:8px">${esc(t('ed_veh_fleet_hint'))}</div>`);
    vehicles.forEach((v, i) => {
        const idx = i + 1;   // server vehicle list is 1-based
        const row = document.createElement('div'); row.className = 'adm-row';
        const stepper = stockMode ? `<div class="stock-step"><button data-d="-1">−</button><span>${v.stock || 0}</span><button data-d="1">+</button></div>` : '';
        row.innerHTML = `<div class="adm-row-ico"><i class="fa-solid fa-car"></i></div>
            <div class="adm-row-main"><div class="adm-row-title">${esc(v.label || v.model)}</div><div class="adm-row-sub">${esc(v.model)} · ${esc(t('ui_grade').replace('%s', v.minGrade || 0))}</div></div>
            <div class="adm-row-actions">${stepper}</div>`;
        if (stockMode) {
            $$('.stock-step button', row).forEach(b => on(b, 'click', () => {
                const nv = Math.max(0, (v.stock || 0) + parseInt(b.dataset.d, 10));
                post('bossSetStock', { gid: g.id, index: idx, stock: nv });
            }));
        }
        pane.appendChild(row);
    });
}

on($('#boss-close'), 'click', () => { closeBoss(); post('bossClose'); });
on($('#boss-close-2'), 'click', () => { closeBoss(); post('bossClose'); });
on($('#boss-collapse'), 'click', () => { const s = $('.boss-shell'); if (s) s.classList.toggle('rail-collapsed'); });


// ============================================================
// PREVIEW CAMERA DOCK
// The Lua side owns the camera; the UI only ever nudges it. The dock's
// visibility is tied to the garage screen by observing #garage's `hidden`
// attribute — that way it follows openGarage()/closeAll()/admin_hide without
// any of them having to know the dock exists.
// ============================================================
let pvSyncDock = () => {};

(function initPreviewDock() {
    const dock = $('#pv-dock');
    const garage = $('#garage');
    if (!dock || !garage) return;

    // Also gated on previewReady: with Config.preview.enabled = false the Lua
    // side never starts a session, so showing camera controls would advertise a
    // feature that is switched off.
    const syncDock = () => { dock.hidden = garage.hidden || !ST.previewReady; };
    pvSyncDock = syncDock;
    new MutationObserver(syncDock).observe(garage, { attributes: true, attributeFilter: ['hidden'] });
    syncDock();

    const autoBtn = $('#pv-auto');

    on($('#pv-left'),  'click', () => { post('previewRotate', { dir: -1 }); autoBtn.classList.remove('active'); });
    on($('#pv-right'), 'click', () => { post('previewRotate', { dir: 1 });  autoBtn.classList.remove('active'); });
    on($('#pv-out'),   'click', () => post('previewZoom', { delta: 1 }));   // bigger radius = further away
    on($('#pv-in'),    'click', () => post('previewZoom', { delta: -1 }));

    on(autoBtn, 'click', () => post('previewAuto').then(r => {
        autoBtn.classList.toggle('active', !!(r && r.auto));
    }));

    on($('#pv-reset'), 'click', () => post('previewReset').then(() => {
        // ResetCam() restores the configured autoRotate default, so the button
        // must go back to reflecting it rather than keeping a stale off state.
        autoBtn.classList.add('active');
    }));
})();

// Called by renderDetail(v): asks Lua to swap the world preview to this vehicle.
// v.model is the stored model HASH (a number) — Preview.Show() expects exactly
// that, so it is passed through untouched. The PLATE goes with it: Lua keeps this
// vehicle's real paint/wheels/livery cached on its own side and looks it up by
// plate, so the showroom car is the player's car and not a random repaint. No
// props ever reach this page — the plate is the whole contract.
window.apxPreview = (v) => {
    if (!v || v.model == null) return;
    // Dedupe on model AND plate: two cars of the same model with different paint
    // are different previews, but re-selecting the same row must not make
    // Preview.Show() delete and respawn the car (that reads as a flicker on every
    // list refresh).
    const key = `${v.model}|${v.plate || ''}`;
    if (ST.previewKey === key) return;
    ST.previewKey = key;
    // Preview.Start() yields; asking for a model before it finishes would abort
    // it. Hold the last request and let onPreviewReady() flush it.
    const req = { model: v.model, plate: v.plate || '' };
    if (!ST.previewReady) { ST.previewPending = req; return; }
    post('preview', req);
};

function onPreviewReady(ok) {
    ST.previewReady = !!ok;
    pvSyncDock();
    if (ST.previewReady && ST.previewPending != null) {
        post('preview', ST.previewPending);
        ST.previewPending = null;
    }
}

// ============================================================
// PARKING ADMIN — /apexgarage -> Parking
//   Self-contained overlay: the admin rail is built from ADM_FILTERS and can't
//   take a new section, so this lives beside the panel instead of inside it.
// ============================================================
// `tab` is the visible section ('parking' | 'noparking' | 'settings'). It has to
// live in state because renderPark() repaints the whole pane on every toggle and
// on every park_refresh — a tab held in the DOM would snap back on each of those.
const PK = { s: {}, perms: [], vehicles: [], zones: [], tab: 'parking' };

const PK_DEFAULTS = {
    enabled: true, mode: 'public', noCollision: true,
    maxPerPlayer: 2, overlapRadius: 3.5, jobs: [], allowJobVehicles: false,
    blockInGarageZones: false,
};

// A refresh (zone added/removed, perm granted) carries only the volatile lists,
// so settings are merged ONLY when the payload actually has them — otherwise the
// admin's unsaved edits, captured by pkReadInputs(), would be thrown away.
function pkSet(p) {
    if (p.settings) {
        PK.s = Object.assign({}, PK_DEFAULTS, p.settings);
        PK.s.jobs = Array.isArray(PK.s.jobs) ? PK.s.jobs : [];
    }
    // an empty Lua table arrives as {}, not [] — normalise so renderPark can map
    if (p.perms !== undefined) PK.perms = Array.isArray(p.perms) ? p.perms : [];
    if (p.vehicles !== undefined) PK.vehicles = Array.isArray(p.vehicles) ? p.vehicles : [];
    if (p.zones !== undefined) PK.zones = Array.isArray(p.zones) ? p.zones : [];
    renderPark();
}
// Parking lives in the admin panel's own pane (no modal): the rail switches the
// view and the pane renders in place, like every other section.
function openPark(p) {
    applyTheme(p.theme);
    ADM.view = 'parking';
    $('#admin').hidden = false;
    renderAdmNav();
    pkSet(p);            // -> renderPark()
}
function closePark() {
    ADM.view = 'garages';
    renderAdmNav();
    renderAdmList();
}

// ============================================================
// APPEARANCE — the server-wide UI theme
//   Two colours drive the entire palette (see applyTheme). The pane previews
//   them on the running interface as the admin drags, so what they see IS the
//   result; nothing reaches the other players until "Save".
// ============================================================
const TH = {
    cur:   { brand: '#1F5EFF', brandDark: '#0048F0', bg: '#131314' },
    def:   { brand: '#1F5EFF', brandDark: '#0048F0', bg: '#131314' },
    saved: { brand: '#1F5EFF', brandDark: '#0048F0', bg: '#131314' },
};

// Curated one-click colours. The wheel stays available for anything else, but
// most admins only want a decent accent — and these are pre-checked to stay
// readable once applyTheme() derives the whole ramp from them.
const BRAND_SWATCHES = ['#1F5EFF', '#4E9CE5', '#34C77B', '#E5A93C', '#E5564B', '#A66DF0', '#F0B429', '#0BA5A4'];
const BG_SWATCHES    = ['#131314', '#0A0A0B', '#0F1218', '#101616', '#15110F', '#141019', '#0E1614', '#181613'];

// Full skins (accent + background as a matched pair). 'Daylight' is the only
// light background — it is what exercises the light-mode branch of applyTheme.
const THEME_PRESETS = [
    { name: 'Apex Blue',   brand: '#1F5EFF', bg: '#131314' },
    { name: 'Emerald',     brand: '#1C7E50', bg: '#0E1614' },
    { name: 'Crimson',     brand: '#E5343E', bg: '#17110F' },
    { name: 'Violet',      brand: '#A66DF0', bg: '#141019' },
    { name: 'Amber',       brand: '#F0B429', bg: '#181613' },
    { name: 'Cyan',        brand: '#0BA5A4', bg: '#101616' },
    { name: 'Hot Pink',    brand: '#FF2D8A', bg: '#191016' },
    { name: 'Midnight',    brand: '#4E9CE5', bg: '#0F1218' },
    { name: 'Carbon Lime', brand: '#9BE515', bg: '#101610' },
    { name: 'Daylight',    brand: '#1F5EFF', bg: '#EFEFF2' },
];

// A picked brand needs a pressed/hover shade too. Deriving it here (rather than
// letting the server fall back to the brand itself) keeps buttons from losing
// their pressed state whenever an admin re-skins.
function thmDark(brand) {
    if (!_HEX6.test(brand || '')) return brand;
    const { h, s } = _rgbToHsl(_hexToRgb(brand));
    return _hslToHex(h, s, 47);
}

function thmNormalise(t, fallback) {
    const src = t || {};
    const out = Object.assign({}, fallback);
    if (_HEX6.test(src.brand || '')) out.brand = src.brand;
    if (_HEX6.test(src.bg || '')) out.bg = src.bg;
    out.brandDark = _HEX6.test(src.brandDark || '') ? src.brandDark : thmDark(out.brand);
    return out;
}

function openThemePane(p) {
    TH.def   = thmNormalise(p.default, TH.def);
    TH.saved = thmNormalise(p.theme, TH.def);
    TH.cur   = Object.assign({}, TH.saved);
    // The one pane dedicated to colours must not inherit them from whoever
    // happened to open it — it paints from its own payload like every screen.
    applyTheme(TH.saved);
    ADM.view = 'theme';
    $('#admin').hidden = false;
    renderAdmNav();
    renderAdmList();
}

// Leaving the pane with unsaved drags would strand the admin's own UI in colours
// nobody else has. Anything not saved is thrown away on the way out.
function thmRestore() {
    if (ADM.view !== 'theme') return;
    TH.cur = Object.assign({}, TH.saved);
    applyTheme(TH.saved);
}

function thmPreview() { applyTheme(TH.cur); }

// A re-skin pushed by the server is the new truth — it supersedes whatever the
// admin was previewing, so the draft is dropped rather than left floating on top
// of colours that changed underneath it.
function onThemeBroadcast(p) {
    TH.saved = thmNormalise(p, TH.saved);
    TH.cur   = Object.assign({}, TH.saved);
    applyTheme(TH.saved);
    if (ADM.view === 'theme' && !$('#admin').hidden) renderTheme();
}

function renderTheme() {
    const pane = $('#adm-pane');
    const d = TH.cur;
    const eq = (a, b) => String(a || '').toUpperCase() === String(b || '').toUpperCase();
    const swatches = (list, key, sel) => list.map(c =>
        `<button class="color-preset${eq(c, sel) ? ' active' : ''}" data-sw="${key}" data-c="${c}" style="background:${c}" title="${c}"></button>`).join('');
    const pick = (id, key, label, list) => `<div class="theme-row">
            <label class="theme-pick">
                <input type="color" id="th-${id}" value="${esc(d[key])}">
                <div>
                    <div class="tp-name">${esc(label)}</div>
                    <div class="tp-hex mono" id="th-${id}-hex">${esc(String(d[key]).toUpperCase())}</div>
                </div>
            </label>
            <div class="color-presets">${swatches(list, key, d[key])}</div>
        </div>`;

    pane.innerHTML = `<div class="adm-theme">
        <div class="adm-theme-left">
            <div class="mg-section-card">
                <div class="chart-title">${esc(t('ui_theme_colors'))}</div>
                ${pick('brand', 'brand', t('ui_theme_brand'), BRAND_SWATCHES)}
                ${pick('bg', 'bg', t('ui_theme_bg'), BG_SWATCHES)}
                <div class="hint">${esc(t('ui_theme_derive'))}</div>
            </div>

            <div class="mg-section-card">
                <div class="chart-title">${esc(t('ui_theme_presets'))}</div>
                <div class="theme-presets">
                    ${THEME_PRESETS.map((p, i) => `
                        <button class="theme-preset${eq(p.brand, d.brand) && eq(p.bg, d.bg) ? ' active' : ''}" data-preset="${i}">
                            <span class="tpv" style="background:${p.bg}"><span style="background:${p.brand}"></span></span>
                            <span class="tpn">${esc(p.name)}</span>
                        </button>`).join('')}
                </div>
            </div>

            <div class="theme-actions">
                <button class="btn btn-ghost" id="th-reset"><i class="fa-solid fa-rotate-left"></i> ${esc(t('ui_theme_reset_def'))}</button>
                <button class="btn btn-primary" id="th-save"><i class="fa-solid fa-floppy-disk"></i> ${esc(t('ui_theme_apply'))}</button>
            </div>
        </div>

        <div class="mg-section-card adm-theme-right">
            <div class="chart-title">${esc(t('ui_theme_preview'))}</div>
            <div class="theme-demo">
                <div class="theme-demo-rail">
                    <span class="td-mark"><i class="fa-solid fa-warehouse"></i></span>
                    <span class="td-line active"></span><span class="td-line"></span>
                    <span class="td-line"></span><span class="td-line"></span>
                </div>
                <div class="theme-demo-body">
                    <div class="theme-demo-top">
                        <span class="td-chip"><i class="fa-solid fa-car-side"></i></span>
                        <div>
                            <div class="eyebrow">APEX GARAGE</div>
                            <div class="td-title">${esc(t('ui_theme_demo_title'))}</div>
                        </div>
                        <span class="badge badge-brand" style="margin-left:auto">${esc(t('ui_theme_demo_stored'))}</span>
                        <span class="badge badge-yellow">${esc(t('ui_theme_demo_finance'))}</span>
                    </div>
                    <div class="theme-demo-kpis">
                        <div class="td-kpi accent">
                            <div class="td-kpi-ic"><i class="fa-solid fa-warehouse"></i></div>
                            <div>
                                <div class="td-kpi-label">${esc(t('ui_theme_demo_kpi_stored'))}</div>
                                <div class="td-kpi-val mono">12</div>
                            </div>
                        </div>
                        <div class="td-kpi">
                            <div class="td-kpi-ic"><i class="fa-solid fa-road"></i></div>
                            <div>
                                <div class="td-kpi-label">${esc(t('ui_theme_demo_kpi_out'))}</div>
                                <div class="td-kpi-val mono">3</div>
                            </div>
                        </div>
                    </div>
                    <div class="theme-demo-bars">
                        ${[38, 62, 45, 88, 54, 71, 96].map(h =>
                            `<div class="cbar"><div class="cbar-fill" style="height:${h}%"></div></div>`).join('')}
                    </div>
                    <div class="theme-demo-row">
                        <span class="tdr-thumb"><i class="fa-solid fa-car-side"></i></span>
                        <div>
                            <div class="tdr-name">Elegy Retro Custom</div>
                            <div class="tdr-sub mono">54-KL-27 · 18 420 km</div>
                        </div>
                        <span class="tdr-state">${esc(t('ui_theme_demo_stored'))}</span>
                    </div>
                    <div class="theme-demo-btns">
                        <button class="btn btn-primary btn-sm"><i class="fa-solid fa-key"></i> ${esc(t('ui_theme_demo_take'))}</button>
                        <button class="btn btn-ghost btn-sm"><i class="fa-solid fa-right-left"></i> ${esc(t('ui_theme_demo_transfer'))}</button>
                        <input type="text" class="td-input" value="${esc(t('ui_theme_demo_search'))}" readonly>
                    </div>
                </div>
            </div>
        </div>
    </div>`;

    // The whole document repaints from the custom properties, so nothing here is
    // re-rendered on a colour change — only the swatch/preset selection rings,
    // which are markup state rather than palette state.
    const repaintActive = () => {
        $$('[data-sw]', pane).forEach(b =>
            b.classList.toggle('active', eq(b.dataset.c, d[b.dataset.sw])));
        $$('[data-preset]', pane).forEach(b => {
            const p = THEME_PRESETS[Number(b.dataset.preset)];
            b.classList.toggle('active', eq(p.brand, d.brand) && eq(p.bg, d.bg));
        });
    };
    const setColour = (key, hex) => {
        const v = String(hex || '').toUpperCase();
        if (!_HEX6.test(v)) return;
        d[key] = v;
        // The brand needs its pressed/hover shade derived here, otherwise the
        // saved theme collapses --brand-600 onto --brand-500 and the buttons
        // lose the shade they had in the preview.
        if (key === 'brand') d.brandDark = thmDark(v);
        // keep the native picker in step when the change came from a swatch
        const inp = $('#th-' + key); if (inp) inp.value = v;
        const lbl = $('#th-' + key + '-hex'); if (lbl) lbl.textContent = v;
        thmPreview();
        repaintActive();
    };

    // `input` (not `change`) so the preview follows the colour wheel while it is
    // being dragged — that live feedback is the whole point of the pane.
    on($('#th-brand'), 'input', e => setColour('brand', e.target.value));
    on($('#th-bg'), 'input', e => setColour('bg', e.target.value));
    $$('[data-sw]', pane).forEach(b => on(b, 'click', () => setColour(b.dataset.sw, b.dataset.c)));
    $$('[data-preset]', pane).forEach(b => on(b, 'click', () => {
        const p = THEME_PRESETS[Number(b.dataset.preset)];
        setColour('brand', p.brand);
        setColour('bg', p.bg);
    }));

    on($('#th-save'), 'click', () => {
        post('themeSave', { brand: TH.cur.brand, brandDark: TH.cur.brandDark, bg: TH.cur.bg })
            .then((r) => {
                if (r && r.ok) {
                    TH.saved = thmNormalise(r.theme, TH.cur);
                } else {
                    // server refused — never leave the admin on a colour nobody else has
                    TH.saved = Object.assign({}, TH.saved);
                }
                TH.cur = Object.assign({}, TH.saved);
                applyTheme(TH.saved);
                if (ADM.view === 'theme') renderTheme();
            });
    });

    on($('#th-reset'), 'click', () => {
        post('themeReset', {}).then((r) => {
            if (r && r.ok) {
                TH.saved = thmNormalise(r.theme, TH.def);
                TH.cur = Object.assign({}, TH.saved);
                applyTheme(TH.saved);
            }
            if (ADM.view === 'theme') renderTheme();
        });
    });
}

// The numeric/text fields are uncontrolled, so pull them into state before any
// re-render (a seg click) throws the DOM away.
function pkReadInputs() {
    const max = $('#pk-max'), rad = $('#pk-rad'), jobs = $('#pk-jobs');
    if (max) PK.s.maxPerPlayer = Math.max(0, Number(max.value) || 0);
    if (rad) PK.s.overlapRadius = Math.max(0.5, Number(rad.value) || 3.5);
    if (jobs) PK.s.jobs = jobs.value.split(',').map(x => x.trim()).filter(Boolean);
}

function renderPark() {
    const s = PK.s;
    const sw = (id, isOn) => `<button class="switch ${isOn ? 'on' : ''}" id="${id}" role="switch" aria-checked="${!!isOn}"></button>`;
    const row = (label, desc, ctl) => `<div class="set-row">
        <div class="set-txt"><div class="set-label">${esc(label)}</div>${desc ? `<div class="set-desc">${esc(desc)}</div>` : ''}</div>
        <div class="set-ctl">${ctl}</div>
    </div>`;

    // ---- tab strip (always mounted; the sections below are exclusive) ----
    let h = `<div class="pk-tabs">` + seg('pk-tab', PK.tab, [
        { v: 'parking',   l: t('pk_tab_parking'),   badge: PK.vehicles.length },
        { v: 'noparking', l: t('pk_tab_noparking'), badge: PK.zones.length },
        { v: 'settings',  l: t('pk_tab_settings') },
    ]) + `</div>`;

    // ---- SETTINGS ----
    if (PK.tab === 'settings') {
    h += `<div class="ed-sec">
        <div class="ed-sec-head"><i class="fa-solid fa-sliders"></i><span>${esc(t('pk_settings'))}</span></div>
        <div class="set-list">
            ${row(t('pk_enabled'), t('pk_enabled_desc'), sw('pk-enabled', s.enabled))}
            ${row(t('pk_nocol'), t('pk_nocol_desc'), sw('pk-nocol', s.noCollision))}
            ${row(t('pk_jobveh'), t('pk_jobveh_desc'), sw('pk-jobveh', s.allowJobVehicles))}
            ${row(t('pk_nogarage'), t('pk_nogarage_desc'), sw('pk-nogarage', s.blockInGarageZones))}
            ${row(t('pk_who'), t('pk_who_desc'),
                seg('pk-mode', s.mode, [{ v: 'public', l: t('pk_mode_public') }, { v: 'job', l: t('pk_mode_job') }, { v: 'permission', l: t('pk_mode_permission') }]))}
            ${s.mode === 'job' ? row(t('pk_jobs'), t('pk_jobs_desc'),
                `<input class="set-wide" id="pk-jobs" type="text" spellcheck="false" placeholder="police, ambulance" value="${esc(s.jobs.join(', '))}">`) : ''}
            ${row(t('pk_max'), t('pk_max_desc'),
                `<input class="set-num" id="pk-max" type="number" min="0" max="100" value="${Number(s.maxPerPlayer) || 0}"><span class="set-unit">${esc(t('pk_unit_count'))}</span>`)}
            ${row(t('pk_radius'), t('pk_radius_desc'),
                `<input class="set-num" id="pk-rad" type="number" min="0.5" max="50" step="0.5" value="${Number(s.overlapRadius) || 3.5}"><span class="set-unit">m</span>`)}
        </div>
    </div>`;

    // ---- permissions (only meaningful in "By permission" mode) ----
    // Lives on Settings because it is the detail of the 'permission' mode: the
    // seg that turns it on is two rows above it.
    if (s.mode === 'permission') {
    h += `<div class="ed-sec">
        <div class="ed-sec-head"><i class="fa-solid fa-user-shield"></i><span>${esc(t('pk_perms'))}</span>
            <button class="btn btn-ghost btn-sm pk-head-act" id="pk-grant"><i class="fa-solid fa-plus"></i> ${esc(t('pk_grant'))}</button>
        </div>`;
    h += !PK.perms.length
        ? emptyState('fa-user-shield', t('pk_perms_empty'), t('pk_perms_empty_sub')).replace('empty-state', 'empty-state compact')
        : `<div class="set-list">` + PK.perms.map(p => `
            <div class="pk-row">
                <div class="pk-row-main">
                    <div class="pk-row-top">${esc(p.name || t('pk_offline'))}</div>
                    <div class="pk-row-sub">${esc(p.identifier)}</div>
                </div>
                <button class="icon-action danger pk-revoke" data-id="${esc(p.identifier)}" title="${esc(t('pk_revoke'))}"><i class="fa-solid fa-xmark"></i></button>
            </div>`).join('') + `</div>`;
    h += `</div>`;
    }   // end permissions section
    }   // end SETTINGS tab

    // ---- NO PARKING: the blacklist zones ----
    if (PK.tab === 'noparking') {
    h += `<div class="ed-sec">
        <div class="ed-sec-head"><i class="fa-solid fa-ban"></i><span>${esc(t('pk_zones'))}</span>
            <span class="chip pk-head-act">${PK.zones.length}</span>
            <button class="btn btn-ghost btn-sm" id="pk-zone-poly"><i class="fa-solid fa-draw-polygon"></i> ${esc(t('ui_shape_corners'))}</button>
            <button class="btn btn-ghost btn-sm" id="pk-zone-circle"><i class="fa-solid fa-circle-dot"></i> ${esc(t('ui_shape_circle'))}</button>
        </div>`;
    h += !PK.zones.length
        ? emptyState('fa-ban', t('pk_zones_empty'), t('pk_zones_empty_sub')).replace('empty-state', 'empty-state compact')
        : `<div class="set-list">` + PK.zones.map(z => `
            <div class="pk-row">
                <div class="pk-row-main">
                    <div class="pk-row-top">
                        <span>${esc(z.label || t('pk_zone'))}</span>
                        <span class="chip">${esc(z.shape === 'poly' ? t('pk_zone_corners').replace('%s', z.points) : t('pk_zone_radius').replace('%s', z.r != null ? z.r : '?'))}</span>
                    </div>
                    <div class="pk-row-sub">${Number(z.x || 0).toFixed(1)}, ${Number(z.y || 0).toFixed(1)}, ${Number(z.z || 0).toFixed(1)}</div>
                </div>
                <button class="icon-action brand pk-ztp" data-x="${z.x}" data-y="${z.y}" data-z="${z.z}" title="${esc(t('ui_teleport'))}"><i class="fa-solid fa-location-arrow"></i></button>
                <button class="icon-action danger pk-zdel" data-id="${z.id}" title="${esc(t('ui_remove'))}"><i class="fa-solid fa-trash"></i></button>
            </div>`).join('') + `</div>`;
    h += `</div>`;
    }   // end NO PARKING tab

    // ---- PARKING: the parked vehicles ----
    if (PK.tab === 'parking') {
    h += `<div class="ed-sec">
        <div class="ed-sec-head"><i class="fa-solid fa-car-side"></i><span>${esc(t('pk_parked'))}</span>
            <span class="badge pk-head-act">${PK.vehicles.length}</span>
        </div>`;
    h += !PK.vehicles.length
        ? emptyState('fa-car-side', t('pk_parked_empty'), t('pk_parked_empty_sub')).replace('empty-state', 'empty-state compact')
        : `<div class="set-list">` + PK.vehicles.map(v => `
            <div class="pk-row">
                <div class="pk-row-main">
                    <div class="pk-row-top">
                        <span class="plate-chip mono">${esc(v.plate)}</span>
                        <span class="set-desc" style="margin:0">${esc(v.name || v.owner || '—')}</span>
                    </div>
                    <div class="pk-row-sub">${esc(v.x)}, ${esc(v.y)}, ${esc(v.z)}</div>
                </div>
                <button class="icon-action danger pk-del" data-id="${esc(v.id)}" title="${esc(t('ui_remove'))}"><i class="fa-solid fa-trash"></i></button>
            </div>`).join('') + `</div>`;
    h += `</div>`;
    }   // end PARKING tab

    // the pane has no modal footer, so the save action rides along at the end.
    // It sits OUTSIDE the tab branches: pkSave() posts the whole settings object
    // from PK.s, so saving works identically from all three tabs.
    h += `<div class="pane-foot">
        <span class="foot-note">${esc(t('pk_save_note'))}</span>
        <button class="btn btn-primary btn-lg" id="pk-save"><i class="fa-solid fa-floppy-disk"></i> ${esc(t('ui_save'))}</button>
    </div>`;

    $('#adm-pane').innerHTML = h;

    // wiring — every seg reads the free-text fields first so nothing is lost
    const reRender = (patch) => { pkReadInputs(); Object.assign(PK.s, patch); renderPark(); };

    // Switching tab unmounts #pk-max / #pk-rad / #pk-jobs. pkReadInputs() must run
    // while they are still in the DOM, otherwise its `if (el)` guards go quiet and
    // the admin's typed value is silently replaced by the stale one in PK.s on the
    // next save. Same discipline as reRender() above.
    wireSeg('pk-tab', v => { pkReadInputs(); PK.tab = v; renderPark(); });

    const toggle = (id, key) => on($('#' + id), 'click', () => reRender({ [key]: !PK.s[key] }));
    toggle('pk-enabled', 'enabled');
    toggle('pk-nocol',   'noCollision');
    toggle('pk-jobveh',  'allowJobVehicles');
    toggle('pk-nogarage', 'blockInGarageZones');
    wireSeg('pk-mode',   v => reRender({ mode: v }));

    // Drawing a zone leaves the panel for the placer and comes back through a
    // park_refresh, so unsaved settings are committed first.
    // NOTE: these buttons live on the No-parking tab, where the settings inputs
    // are NOT mounted — this pkReadInputs() is a deliberate no-op there. It is
    // safe because the tab-switch handler above already harvested them, so PK.s
    // is current and pkSave() persists what the admin actually typed.
    const addZone = async (shape) => {
        pkReadInputs();
        await pkSave();
        post('parkZoneAdd', { shape, label: `Zone ${PK.zones.length + 1}` });
    };
    on($('#pk-zone-poly'),   'click', () => addZone('poly'));
    on($('#pk-zone-circle'), 'click', () => addZone('circle'));
    $$('#adm-pane .pk-ztp').forEach(b => on(b, 'click', () =>
        post('parkZoneTp', { x: Number(b.dataset.x), y: Number(b.dataset.y), z: Number(b.dataset.z) })));
    $$('#adm-pane .pk-zdel').forEach(b => on(b, 'click', () => {
        pkReadInputs();
        post('parkZoneDelete', { id: Number(b.dataset.id) });
    }));

    on($('#pk-grant'), 'click', async () => {
        pkReadInputs();
        const r = await post('admPlayers');
        const items = ((r && r.players) || []).map(p => ({ label: p.name, sub: '#' + p.id, val: p.id }));
        showPicker(t('pk_grant_title'), items, async (id) => { await post('parkGrant', { targetId: id }); });
    });
    $$('#adm-pane .pk-revoke').forEach(b => on(b, 'click', async () => {
        pkReadInputs();
        await post('parkRevoke', { identifier: b.dataset.id });
    }));
    $$('#adm-pane .pk-del').forEach(b => on(b, 'click', async () => {
        pkReadInputs();
        await post('parkDelete', { id: Number(b.dataset.id) });
    }));
    on($('#pk-save'), 'click', pkSave);
}

async function pkSave() {
    pkReadInputs();
    const r = await post('parkSave', {
        enabled: !!PK.s.enabled,
        mode: PK.s.mode,
        noCollision: !!PK.s.noCollision,
        allowJobVehicles: !!PK.s.allowJobVehicles,
        blockInGarageZones: !!PK.s.blockInGarageZones,
        maxPerPlayer: PK.s.maxPerPlayer,
        overlapRadius: PK.s.overlapRadius,
        jobs: PK.s.jobs,
    });
    // Stay on the pane. Lua only acks {ok} (no park_refresh follows a save), so
    // this repaint is purely from local PK.s — which pkReadInputs() just made
    // current. PK.tab is untouched, so the admin stays on the tab they saved from.
    if (r && r.ok) renderPark();
}

// entry point from the admin topbar
// (the Parking entry now lives in the rail nav — see renderAdmNav)

// ESC in the parking view steps back to the garage list rather than tearing the
// whole admin panel down. Capture phase runs before the shared ESC handler, so
// swallowing the event here keeps the panel open.
on(document, 'keydown', (e) => {
    if (e.key !== 'Escape') return;
    if ($('#admin').hidden || ADM.view !== 'parking') return;
    // a picker stacked on top gets priority; let the shared handler take it
    if ($$('.overlay').some(o => !o.id && !o.hidden)) return;
    e.stopImmediatePropagation();
    closePark();
}, true);

// ============================================================
// READY HANDSHAKE
//   Lua holds the server-wide theme, the locale table and the state of any
//   prompt that is already up, all long before this page finishes parsing — and
//   a SendNUIMessage that lands first is dropped by CEF with no error and no
//   retry. Worse, those pushes de-dupe Lua-side, so a dropped one is never
//   re-sent: a player standing still in a garage zone during a live restart
//   would keep an unthemed, unlocalised or absent pill indefinitely.
//
//   So we announce ourselves instead of being guessed at. Lua answers /uiReady
//   by re-seeding EVERYTHING the page cannot rebuild alone — dictionary, theme,
//   3D prompt, TextUI pill — in that order.
//
//   This POST being the LAST statement in the file is the load-bearing part of
//   the contract, not a style choice: the window 'message' listener above is
//   registered at parse time, so by the time Lua sees this call the page is
//   provably able to receive. Everything Lua sends in response is therefore
//   guaranteed routed, which is what the plain one-shot push could not promise.
// ============================================================
//   Retried until Lua acknowledges: the page and the client scripts start at the
//   same moment, so the very first POST can beat RegisterNUICallback('uiReady')
//   and 404 — silently, since post() swallows failures.
(function announceReady(tries) {
    post('uiReady').then(r => {
        if (r && r.ok) return;
        if (tries < 20) setTimeout(() => announceReady(tries + 1), 250);
    });
})(0);
})();
