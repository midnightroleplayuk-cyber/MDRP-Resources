/* apex_dealerships — NUI app (vanilla, IIFE, Apex pattern) */
(() => {
'use strict';

const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'apex_dealerships';
const $  = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
const on = (el, ev, cb, opts) => el && el.addEventListener(ev, cb, opts);
// Lua json.encode serializes empty tables as {} — normalize to a real array
const arr = (v) => Array.isArray(v) ? v : [];

// The world prompt is the hottest path in the page (it can update as fast as
// the player moves), so its nodes are resolved once and its last values are
// remembered — a querySelector + textContent write per frame is a layout per
// frame for nothing.
let _w3d = null;
const w3d = () => {
    if (!_w3d || !_w3d.box.isConnected) {
        _w3d = {
            box: document.querySelector('#world-3d-icon'),
            icon: document.querySelector('#w3d-icon'),
            label: document.querySelector('#w3d-label'),
            key: document.querySelector('.w3d-key'),
            lastIcon: null, lastLabel: null, lastKey: null,
        };
    }
    return _w3d;
};

const post = (name, data = {}) =>
    fetch(`https://${RES}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    }).then(r => r.json()).catch(() => ({}));

// ====================================================================
// Runtime / i18n / formatting
// ====================================================================
const Runtime = {
    theme: null, currency: { symbol: '$', position: 'before' },
    locale: {}, notify: { position: 'top-right', duration: 5000, title: 'Dealership' },
    images: false,   // { custom, base, exts, url } — see imageCandidates()
    finance: { downMin: .1, downMax: .6, terms: [6, 12, 24], apr: .12, intervalHours: 12 },
    categories: [],
};

const t = (key, ...args) => {
    let s = Runtime.locale[key] || key;
    args.forEach(a => { s = s.replace('%s', a).replace('%d', a); });
    return s;
};

const fmtMoney = (n) => {
    n = Math.floor(Number(n) || 0);
    const neg = n < 0; if (neg) n = -n;
    const s = n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    const out = Runtime.currency.position === 'after' ? s + Runtime.currency.symbol : Runtime.currency.symbol + s;
    return (neg ? '-' : '') + out;
};

// HSL brand ramp re-tinting — same method as apex_bossmenu/apex_banking
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

// The whole UI is painted from two colours: `brand` and `bg`. Every surface,
// border and text alpha is derived from them, so an admin only picks two.
function applyTheme(theme) {
    if (!theme || !theme.brand) return;
    const root = document.documentElement.style;
    const rgb = _hexToRgb(theme.brand);
    const { h, s } = _rgbToHsl(rgb);
    root.setProperty('--brand-500', theme.brand);
    root.setProperty('--brand-600', theme.brandDark || _hslToHex(h, s, 47));
    root.setProperty('--brand-400', _hslToHex(h, s, 65));
    root.setProperty('--brand-300', _hslToHex(h, s, 75));
    [['a06', .06], ['a10', .10], ['a15', .15], ['a25', .25], ['a40', .4]]
        .forEach(([k, a]) => root.setProperty(`--brand-${k}`, `rgba(${rgb.r},${rgb.g},${rgb.b},${a})`));

    if (!theme.bg) return;
    // Same ramp as apex_bossmenu: the picked colour is the BASE (sidebar level);
    // the page background sits one step below it and every other surface above.
    const bg = _rgbToHsl(_hexToRgb(theme.bg));
    const dark = bg.l < 50;
    const sat = Math.min(bg.s, 22);                       // keep surfaces neutral
    const step = (d) => _hslToHex(bg.h, sat, _clamp01(bg.l + (dark ? d : -d)));

    root.setProperty('--bg', step(-3.5));
    root.setProperty('--surface-0', step(-3.5));
    root.setProperty('--bg-sidebar', theme.bg);
    root.setProperty('--surface-1', theme.bg);
    root.setProperty('--bg-card', step(3));
    root.setProperty('--surface-2', step(3));
    root.setProperty('--bg-raised', step(7));
    root.setProperty('--surface-3', step(7));
    root.setProperty('--surface-4', step(10));
    root.setProperty('--surface-5', step(15));
    root.setProperty('--border', step(5));
    root.setProperty('--line-1', step(5));
    root.setProperty('--border-hi', step(9.5));
    root.setProperty('--line-2', step(9.5));
    root.setProperty('--line-3', step(15.5));
    root.setProperty('--line-4', step(23));

    // text flips to dark ink on a light background, so a bright theme stays readable
    const ink = dark ? '244,244,245' : '12,12,14';
    root.setProperty('--text-1', dark ? '#F4F4F5' : '#0C0C0E');
    [['text-2', .72], ['text-3', .55], ['text-4', .38]]
        .forEach(([k, a]) => root.setProperty(`--${k}`, `rgba(${ink},${a})`));
}

function applyLocaleStatics() {
    $('#btn-testdrive-label').textContent = t('ui_test_drive');
    $('#btn-buy-label').textContent = t('ui_buy');
    $('#btn-directsale-label').textContent = t('ui_sell_to_customer');
    $('#tab-primary').textContent = t('ui_primary');
    $('#tab-secondary').textContent = t('ui_secondary');
    $('#sec-colors').textContent = t('ui_colors');
    $('#sr-search').placeholder = t('ui_search');
    $('#co-eyebrow').textContent = t('ui_checkout');
    $('#co-price-label').textContent = t('ui_price');
    $('#co-discount-label').textContent = t('ui_discount');
    $('#co-payment-label').textContent = t('ui_payment');
    $('#co-down-label').textContent = t('ui_down_payment');
    $('#co-term-label').textContent = t('ui_term');
    $('#co-fs-today').textContent = t('ui_pay_today');
    $('#co-fs-inst').textContent = t('ui_per_installment');
    $('#co-fs-interest').textContent = t('ui_interest');
    $('#co-fs-total').textContent = t('ui_total_cost');
    $('#co-coupon-label').textContent = t('ui_coupon');
    $('#co-coupon-apply').textContent = t('ui_apply');
    $('#co-customer-label').textContent = t('ui_customer');
    $('#co-cancel').textContent = t('ui_cancel');
    $('#co-confirm').textContent = t('ui_confirm_purchase');
    $('#mg-collapse-label').textContent = t('ui_collapse');
    $('#fin-title').textContent = t('ui_my_finance');
    $('#td-eyebrow').textContent = t('ui_td_title');
    $('#sr-cash-label').textContent = t('ui_cash');
    $('#sr-bank-label').textContent = t('ui_bank');
    $('#sr-custom-label').textContent = t('ui_custom');
    // camera dock tooltips
    [['ctl-rot-left', 'ui_rotate_left'], ['ctl-auto', 'ui_autorotate'], ['ctl-rot-right', 'ui_rotate_right'],
     ['ctl-zoom-out', 'ui_zoom_out'], ['ctl-zoom-in', 'ui_zoom_in'], ['ctl-reset', 'ui_reset_cam']]
        .forEach(([id, key]) => {
            const el = $('#' + id);
            if (el) { el.classList.add('tip'); el.dataset.tip = t(key); el.removeAttribute('title'); }
        });
    $('#sr-leave-label').textContent = t('ui_leave_showroom');
    $('#co-direct-td-label').textContent = t('ui_td_for_customer');
    $('#sr-notice-text').textContent = t('ui_ask_employee');
}

// ====================================================================
// Notifications — ONE path only: handed to Lua, which shows them with ox_lib.
// The old in-NUI toast was a second, parallel system: the same event could be
// announced by both and you saw it twice.
// ====================================================================
function Notify(p) {
    if (!p || !p.message) return;
    post('ui_notify', {
        message: p.message,
        type: p.type || 'info',
        duration: p.duration || null,
    });
}

const notifyErr = (why) => Notify({ type: 'error', message: t('e_' + (why || 'nil')) });

// ====================================================================
// Dropdowns — ONE look for the whole script.
// A native <select> popup cannot be styled in CEF (it renders as an OS list),
// so every <select> is upgraded in place to the same custom dropdown the
// showroom uses. The original element stays in the DOM (hidden) and keeps
// its value + change events, so no call site has to change.
// ====================================================================
function upgradeSelect(sel) {
    if (!sel || sel.dataset.dd === '1') return;
    sel.dataset.dd = '1';

    const wrap = document.createElement('div');
    wrap.className = 'dd dd-native';
    sel.parentNode.insertBefore(wrap, sel);
    wrap.appendChild(sel);
    sel.classList.add('dd-hidden');

    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'dd-btn';
    btn.innerHTML = `<span class="dd-label"></span><i class="fa-solid fa-chevron-down dd-caret"></i>`;
    const menu = document.createElement('div');
    menu.className = 'dd-menu';
    menu.hidden = true;
    wrap.appendChild(btn);
    wrap.appendChild(menu);

    const label = () => {
        const o = sel.options[sel.selectedIndex];
        btn.querySelector('.dd-label').textContent = o ? o.textContent : '';
    };

    const build = () => {
        menu.innerHTML = '';
        Array.from(sel.children).forEach(node => {
            if (node.tagName === 'OPTGROUP') {
                const g = document.createElement('div');
                g.className = 'dd-group';
                g.textContent = node.label;
                menu.appendChild(g);
                Array.from(node.children).forEach(o => menu.appendChild(item(o)));
            } else if (node.tagName === 'OPTION') {
                menu.appendChild(item(node));
            }
        });
    };
    const item = (o) => {
        const b = document.createElement('button');
        b.type = 'button';
        b.className = 'dd-item' + (o.selected ? ' active' : '');
        b.textContent = o.textContent;
        on(b, 'click', () => {
            sel.value = o.value;
            sel.dispatchEvent(new Event('change', { bubbles: true }));
            close();
            label();
            build();
        });
        return b;
    };

    const close = () => { wrap.classList.remove('open'); menu.hidden = true; };
    on(btn, 'click', (e) => {
        e.stopPropagation();
        const opening = menu.hidden;
        $$('.dd.open').forEach(d => { d.classList.remove('open'); const m = d.querySelector('.dd-menu'); if (m) m.hidden = true; });
        if (!opening) return;
        build();
        menu.hidden = false;
        wrap.classList.add('open');
    });
    document.addEventListener('click', close);

    // keep the button in sync when code changes the value programmatically
    sel.addEventListener('change', label);
    label();
}

// upgrade every select that appears (panes are re-rendered constantly)
function upgradeSelects(root) {
    $$('select', root || document).forEach(upgradeSelect);
}
new MutationObserver(() => upgradeSelects()).observe(document.body, { childList: true, subtree: true });

// ====================================================================
// Tooltips — a single fixed element, so scroll panes never clip them
// ====================================================================
// hideTooltip() is called whenever a panel closes: the button under the
// cursor disappears without ever firing `mouseout`, so the tooltip used to
// stay painted on screen forever (with the UI already gone).
let hideTooltip = () => {};
(() => {
    const tip = $('#tooltip');
    const PAD = 6;
    let target = null;

    hideTooltip = () => {
        target = null;
        tip.classList.remove('show');
        tip.hidden = true;
    };

    const place = () => {
        if (!target) return;
        const r = target.getBoundingClientRect();
        const tw = tip.offsetWidth, th = tip.offsetHeight;
        let left = r.left + r.width / 2 - tw / 2;
        left = Math.max(PAD, Math.min(left, window.innerWidth - tw - PAD));
        let top = r.top - th - 8;
        tip.classList.toggle('below', top < PAD);
        if (top < PAD) top = r.bottom + 8;
        tip.style.left = left + 'px';
        tip.style.top = top + 'px';
    };

    document.addEventListener('mouseover', (e) => {
        const el = e.target.closest('.tip[data-tip]');
        if (!el || el === target) return;
        target = el;
        tip.textContent = el.dataset.tip;
        tip.hidden = false;
        requestAnimationFrame(() => { place(); tip.classList.add('show'); });
    });
    document.addEventListener('mouseout', (e) => {
        if (!target) return;
        if (e.relatedTarget && target.contains(e.relatedTarget)) return;
        target = null;
        tip.classList.remove('show');
        tip.hidden = true;
    });
    window.addEventListener('scroll', () => { if (target) place(); }, true);
})();

// ====================================================================
// Showroom
// ====================================================================
const SR = {
    open: false, data: null, selected: null,
    cat: 'all', search: '', sort: 'default',
    slot: 'primary', paints: { primary: null, secondary: null },
};

// a category's domain (land / air / sea) — vehicles inherit it
function catDomain(key) {
    const c = arr(Runtime.categories).find(x => x.key === key);
    return (c && c.domain) || 'land';
}
const DOMAIN_ICONS = { land: 'fa-car', air: 'fa-helicopter', sea: 'fa-ship' };
const domainLabel = (d) => t('ui_domain_' + d);

function catLabel(key) {
    const c = Runtime.categories.find(c => c.key === key);
    return c ? c.label : key;
}

function monogram(v) {
    return (v.brand || v.name || '?').split(/\s+/).map(w => w[0]).join('').slice(0, 2).toUpperCase();
}

// Where a vehicle's picture can come from, best first:
//   1. the server's own file:  build/html/images/<spawncode>.<ext>
//   2. the configured fallback URL (base-game screenshots)
// There is no way to ASK whether a file exists from inside the NUI, so the
// candidates are walked with the <img> onerror event: each failure moves to the
// next one, and running out of candidates leaves the monogram in place.
function imageCandidates(model) {
    const cfg = Runtime.images;
    if (!cfg || !model) return [];
    const out = [];
    const m = String(model).toLowerCase();
    if (cfg.custom && cfg.base) {
        (cfg.exts || ['png']).forEach(ext => out.push(`${cfg.base}${encodeURIComponent(m)}.${ext}`));
    }
    if (cfg.url) out.push(String(cfg.url).replace('%s', encodeURIComponent(m)));
    return out;
}

// walks to the next candidate; called from the <img>'s onerror
window.apxImgFail = (img) => {
    const list = (img.dataset.cands || '').split('|').filter(Boolean);
    const next = Number(img.dataset.i || 0) + 1;
    if (next < list.length) {
        img.dataset.i = String(next);
        img.src = list[next];
        return;
    }
    // out of candidates: drop the image and let the monogram underneath show
    if (img.parentElement) img.parentElement.classList.remove('has-img');
    img.remove();
};

// a picture actually loaded: hide the monogram behind it (a transparent PNG
// would otherwise have the initials showing through the car)
window.apxImgOk = (img) => {
    if (img.parentElement) img.parentElement.classList.add('has-img');
};

function imgTag(model, fallbackText) {
    const cands = imageCandidates(model);
    if (!cands.length) return `<span class="mono-fallback">${fallbackText}</span>`;
    // The monogram is rendered UNDER the image: a picture that 404s (an addon
    // car with no custom file) simply reveals it instead of leaving a hole.
    return `<span class="mono-fallback">${fallbackText}</span>`
        + `<img src="${cands[0]}" data-i="0" data-cands="${cands.join('|')}"`
        + ` onload="apxImgOk(this)" onerror="apxImgFail(this)">`;
}

// vehicle thumbnail used across the showroom + manager tables
function vehThumb(v, cls) {
    return `<div class="veh-thumb ${cls || ''}">${imgTag(v.model, monogram(v))}</div>`;
}

// a table cell that shows the car with its picture
function vehCell(v) {
    return `<td><div class="tbl-veh">
        ${vehThumb(v, 'thumb-sm')}
        <div class="tbl-veh-info">
            <div class="tbl-veh-name">${v.brand || ''} ${v.name}</div>
            <div class="tbl-veh-sub"><span class="mono">${v.model}</span> · ${catLabel(v.category)}</div>
        </div>
    </div></td>`;
}

function stockBadge(v) {
    if (v.stock < 0) return '';   // public stand: no stock concept, no badge
    if (v.stock === 0) return `<span class="badge badge-red">${t('ui_out_of_stock')}</span>`;
    if (v.stock >= 9999) return `<span class="badge badge-green">${t('ui_unlimited')}</span>`;
    return `<span class="badge badge-blue">${v.stock} ${t('ui_in_stock')}</span>`;
}

// ── custom dropdown component (styled, left-aligned) ──
function makeDropdown(rootId, onChange) {
    const root = $('#' + rootId);
    const btn = $('.dd-btn', root);
    const menu = $('.dd-menu', root);
    const label = $('.dd-label', root);
    const dd = { value: null, options: [] };

    const close = () => { root.classList.remove('open'); menu.hidden = true; };
    const render = () => {
        menu.innerHTML = '';
        dd.options.forEach(o => {
            const b = document.createElement('button');
            b.className = 'dd-item' + (o.value === dd.value ? ' active' : '');
            b.textContent = o.label;
            on(b, 'click', () => { dd.set(o.value); close(); onChange(o.value); });
            menu.appendChild(b);
        });
    };
    dd.set = (value) => {
        dd.value = value;
        const cur = dd.options.find(o => o.value === value);
        label.textContent = cur ? cur.label : '';
        render();
    };
    dd.setOptions = (options, value) => { dd.options = options; dd.set(value); };
    on(btn, 'click', (e) => {
        e.stopPropagation();
        $$('.dd.open').forEach(x => { if (x !== root) { x.classList.remove('open'); $('.dd-menu', x).hidden = true; } });
        const open = root.classList.toggle('open');
        menu.hidden = !open;
    });
    document.addEventListener('click', (e) => { if (!root.contains(e.target)) close(); });
    return dd;
}

const ddCat  = makeDropdown('dd-cat',  v => { SR.cat = v; renderList(); });
const ddSort = makeDropdown('dd-sort', v => { SR.sort = v; renderList(); });

function populateFilters() {
    const counts = {};
    SR.data.vehicles.forEach(v => { counts[v.category] = (counts[v.category] || 0) + 1; });
    SR.cat = 'all';
    ddCat.setOptions(
        [{ value: 'all', label: `${t('ui_all')} (${SR.data.vehicles.length})` }].concat(
            Runtime.categories.filter(c => counts[c.key])
                .map(c => ({ value: c.key, label: `${c.label} (${counts[c.key]})` }))),
        'all');

    const sb = t('ui_sort_by');
    SR.sort = 'default';
    ddSort.setOptions([
        { value: 'default',      label: `${sb}: ${t('ui_category')}` },
        { value: 'name',         label: `${sb}: ${t('ui_name')}` },
        { value: 'availability', label: `${sb}: ${t('ui_availability')}` },
        { value: 'cheapest',     label: `${sb}: ${t('ui_cheapest')}` },
        { value: 'expensive',    label: `${sb}: ${t('ui_most_expensive')}` },
    ], 'default');
}

const SORTERS = {
    name:         (a, b) => `${a.brand} ${a.name}`.localeCompare(`${b.brand} ${b.name}`),
    availability: (a, b) => {
        const sv = s => s < 0 ? Infinity : s;   // -1 = public stand, always available
        return (sv(b.stock) - sv(a.stock)) || (a.price - b.price);
    },
    cheapest:     (a, b) => a.price - b.price,
    expensive:    (a, b) => b.price - a.price,
};

function renderList() {
    const list = $('#sr-list');
    list.innerHTML = '';
    const q = SR.search.toLowerCase();
    const items = SR.data.vehicles.filter(v =>
        (SR.cat === 'all' || v.category === SR.cat) &&
        (!q || `${v.brand} ${v.name} ${v.model}`.toLowerCase().includes(q)));
    if (SORTERS[SR.sort]) items.sort(SORTERS[SR.sort]);
    if (!items.length) {
        list.innerHTML = emptyHtml('fa-car', 'ui_no_results');
        return;
    }
    items.forEach(v => {
        const card = document.createElement('div');
        card.className = 'veh-card' + (SR.selected && SR.selected.model === v.model ? ' active' : '')
            + (v.stock === 0 ? ' oos' : '');
        card.innerHTML = `
            ${vehThumb(v)}
            <div class="veh-info">
                <div class="veh-brand"></div>
                <div class="veh-name"></div>
                <div class="veh-price mono">${fmtMoney(v.price)}</div>
            </div>
            <div class="veh-stockb">${stockBadge(v)}</div>`;
        card.querySelector('.veh-brand').textContent = v.brand || '';
        card.querySelector('.veh-name').textContent = v.name;
        on(card, 'click', () => selectVehicle(v));
        list.appendChild(card);
    });
}

const STAT_DEFS = [
    ['ui_top_speed',   v => (v.stats?.speed || 0) / 55,        v => Math.round((v.stats?.speed || 0) * 3.6)],
    ['ui_acceleration', v => (v.stats?.accel || 0) / .5,       v => Math.round(Math.min(1, (v.stats?.accel || 0) / .5) * 100)],
    ['ui_braking',     v => (v.stats?.braking || 0) / 1.2,     v => Math.round(Math.min(1, (v.stats?.braking || 0) / 1.2) * 100)],
    ['ui_handling',    v => ((v.stats?.traction || 1) - 1) / 2, v => Math.round(Math.min(1, ((v.stats?.traction || 1) - 1) / 2) * 100)],
];

function renderDetail() {
    const v = SR.selected;
    const box = $('#sr-detail');
    if (!v) { box.hidden = true; return; }
    box.hidden = false;
    $('#det-brand').textContent = v.brand || '';
    $('#det-name').textContent = v.name;
    $('#det-price').textContent = fmtMoney(v.price);
    $('#det-stock').innerHTML = `${stockBadge(v)} <span class="badge badge-brand">${catLabel(v.category)}</span>`
        + (v.stats?.seats ? ` <span class="badge badge-blue">${v.stats.seats} ${t('ui_seats')}</span>` : '');

    const stats = $('#det-stats');
    stats.innerHTML = '';
    STAT_DEFS.forEach(([key, normFn, valFn]) => {
        const pct = Math.min(100, Math.max(3, normFn(v) * 100));
        const row = document.createElement('div');
        row.className = 'stat-row';
        row.innerHTML = `
            <div class="stat-label">${t(key)}</div>
            <div class="stat-bar"><div class="stat-fill" style="width:${pct}%"></div></div>
            <div class="stat-val mono">${valFn(v)}</div>`;
        stats.appendChild(row);
    });

    // self-purchase off: hide Buy entirely (staff still sell via "Sell to Customer")
    $('#btn-testdrive').hidden = SR.ds || !SR.data.testDrive;
    $('#btn-buy').hidden = !!SR.ds || !!SR.data.purchaseDisabled;
    $('#btn-buy').disabled = v.stock === 0;
    $('#btn-buy-label').textContent = t('ui_buy');
    $('#btn-directsale').hidden = !SR.data.isSeller;
    $('#sr-notice').hidden = !SR.data.purchaseDisabled || !!SR.ds;
}

function renderSwatches() {
    const wrap = $('#sr-swatches');
    wrap.innerHTML = '';
    (SR.data.colors || []).forEach(c => {
        const b = document.createElement('button');
        b.className = 'swatch';
        b.style.background = `rgb(${c.r},${c.g},${c.b})`;
        b.title = c.name;
        const cur = SR.paints[SR.slot];
        if (cur && cur.r === c.r && cur.g === c.g && cur.b === c.b) b.classList.add('active');
        on(b, 'click', () => {
            SR.paints[SR.slot] = c;
            post('sr_color', { slot: SR.slot, r: c.r, g: c.g, b: c.b });
            renderSwatches();
        });
        wrap.appendChild(b);
    });
}

function selectVehicle(v) {
    SR.selected = v;
    SR.paints = { primary: null, secondary: null };
    post('sr_select', { model: v.model });
    renderList();
    renderDetail();
    renderSwatches();
}

function openShowroom(snap) {
    SR.open = true;
    snap.vehicles = arr(snap.vehicles);
    snap.societies = arr(snap.societies);
    snap.colors = arr(snap.colors);
    if (snap.finance) snap.finance.terms = arr(snap.finance.terms);
    SR.data = snap;
    // direct sale mode: panels only — no 3D preview, no camera controls, no paint
    SR.ds = !!snap.directSale;
    $('#orbit-layer').style.display = SR.ds ? 'none' : '';
    $('.sr-controls').hidden = SR.ds;
    $('#det-paint').hidden = SR.ds;
    SR.cat = 'all';
    SR.search = '';
    SR.selected = snap.vehicles[0] || null;
    SR.paints = { primary: null, secondary: null };
    $('#sr-dealer-name').textContent = snap.label;
    $('#sr-cash').textContent = fmtMoney(snap.money?.cash || 0);
    $('#sr-bank').textContent = fmtMoney(snap.money?.bank || 0);
    $('#sr-search').value = '';
    setAutoUI(true);
    populateFilters();
    renderList();
    renderDetail();
    renderSwatches();
    $('#showroom').hidden = false;
}

function closeShowroomUI() {
    SR.open = false;
    hideTooltip();
    $('#showroom').hidden = true;
    closeCheckout();
}

// orbit drag / zoom
(() => {
    const layer = $('#orbit-layer');
    let dragging = false, lastX = 0, lastY = 0, accX = 0, accY = 0, raf = null;
    const flush = () => {
        raf = null;
        if (accX || accY) { post('sr_orbit', { dx: accX, dy: accY }); accX = 0; accY = 0; }
    };
    on(layer, 'pointerdown', e => {
        dragging = true; lastX = e.clientX; lastY = e.clientY;
        layer.classList.add('dragging');
        layer.setPointerCapture(e.pointerId);
        setAutoUI(false);
        post('sr_autorotate', { enabled: false });
    });
    on(layer, 'pointermove', e => {
        if (!dragging) return;
        accX += e.clientX - lastX;
        accY += e.clientY - lastY;
        lastX = e.clientX; lastY = e.clientY;
        if (!raf) raf = requestAnimationFrame(flush);
    });
    const stop = () => { dragging = false; layer.classList.remove('dragging'); };
    on(layer, 'pointerup', stop);
    on(layer, 'pointercancel', stop);
    // zoom only when the wheel happens over the 3D area — panels keep their own scroll
    on(layer, 'wheel', e => {
        if (SR.open && !CO.open) post('sr_zoom', { dir: Math.sign(e.deltaY) });
    });
})();

on($('#sr-search'), 'input', e => { SR.search = e.target.value; renderList(); });
on($('#sr-close'), 'click', () => post('ui_close'));

// ── camera control dock ──
function setAutoUI(enabled) {
    SR.auto = enabled;
    $('#ctl-auto').classList.toggle('active', enabled);
}
function holdRepeat(id, fn, intervalMs) {
    const btn = $('#' + id);
    let timer = null;
    const stop = () => { if (timer) { clearInterval(timer); timer = null; } };
    on(btn, 'pointerdown', () => { fn(); timer = setInterval(fn, intervalMs || 50); });
    on(btn, 'pointerup', stop);
    on(btn, 'pointerleave', stop);
}
holdRepeat('ctl-rot-left',  () => { if (SR.auto) { setAutoUI(false); post('sr_autorotate', { enabled: false }); } post('sr_orbit', { dx: -5, dy: 0 }); });
holdRepeat('ctl-rot-right', () => { if (SR.auto) { setAutoUI(false); post('sr_autorotate', { enabled: false }); } post('sr_orbit', { dx: 5, dy: 0 }); });
holdRepeat('ctl-zoom-out', () => post('sr_zoom', { dir: 1 }), 130);
holdRepeat('ctl-zoom-in',  () => post('sr_zoom', { dir: -1 }), 130);
on($('#ctl-auto'), 'click', () => {
    setAutoUI(!SR.auto);
    post('sr_autorotate', { enabled: SR.auto });
});
on($('#ctl-reset'), 'click', () => post('sr_reset'));
$$('.paint-tab').forEach(tab => on(tab, 'click', () => {
    $$('.paint-tab').forEach(x => x.classList.remove('active'));
    tab.classList.add('active');
    SR.slot = tab.dataset.slot;
    renderSwatches();
}));

// custom paint colour — live preview while dragging the picker
on($('#sr-custom'), 'input', e => {
    const hex = e.target.value;
    $('#sr-custom-hex').textContent = hex.toUpperCase();
    const c = _hexToRgb(hex);
    SR.paints[SR.slot] = { r: c.r, g: c.g, b: c.b, name: 'Custom' };
    post('sr_color', { slot: SR.slot, r: c.r, g: c.g, b: c.b });
    renderSwatches();
});

// ====================================================================
// Checkout
// ====================================================================
const CO = {
    open: false, sellerMode: false,
    method: 'bank', financed: false,
    down: 10, term: 12,
    coupon: null, discount: 0,
    customerId: null,
};

// per-dealership finance params (fall back to the global config)
const finParams = () => (SR.data && SR.data.finance) || Runtime.finance;

function financeQuote(price) {
    const f = finParams();
    const downAmt = Math.floor(price * CO.down / 100);
    const principal = price - downAmt;
    const interest = Math.floor(principal * f.apr * (CO.term / 12));
    const total = principal + interest;
    const payment = Math.ceil(total / CO.term);
    return { downAmt, principal, interest, payment, totalCost: downAmt + total };
}

function renderCheckout() {
    const v = SR.selected;
    if (!v) return;
    const price = v.price - CO.discount;
    $('#co-title').textContent = `${v.brand} ${v.name}`;
    $('#co-price').textContent = fmtMoney(price);
    $('#co-discount-row').hidden = !CO.discount;
    if (CO.discount) $('#co-discount').textContent = '-' + fmtMoney(CO.discount);

    // methods — in seller mode the SELLER picks how the customer will pay
    // (the customer reviews the full offer in their consent dialog)
    const seg = $('#co-methods');
    seg.innerHTML = '';
    const methods = [['cash', t('ui_cash')], ['bank', t('ui_bank')]];
    if (!CO.sellerMode) {
        arr(SR.data.societies).forEach(s => methods.push(['society', `${t('ui_society')} (${s.label})`]));
    }
    if (SR.data.finance?.enabled && (CO.sellerMode || SR.data.finance?.allowed)) {
        methods.push(['finance', t('ui_finance')]);
    }
    methods.forEach(([key, label]) => {
        const b = document.createElement('button');
        b.textContent = label;
        const active = key === 'finance' ? CO.financed : (!CO.financed && CO.method === key);
        if (active) b.classList.add('active');
        on(b, 'click', () => {
            if (key === 'finance') { CO.financed = true; }
            else { CO.financed = false; CO.method = key; }
            renderCheckout();
        });
        seg.appendChild(b);
    });
    seg.hidden = false;
    $('#co-payment-label').hidden = false;

    // finance block
    const fin = $('#co-finance');
    fin.hidden = !CO.financed;
    if (CO.financed) {
        const f = finParams();
        const slider = $('#co-down');
        slider.min = Math.round(f.downMin * 100);
        slider.max = Math.round((f.downMax || .6) * 100);
        slider.value = CO.down;
        $('#co-down-val').textContent = CO.down + '%';
        const terms = $('#co-terms');
        terms.innerHTML = '';
        arr(f.terms).forEach(term => {
            const b = document.createElement('button');
            b.textContent = term;
            if (term === CO.term) b.classList.add('active');
            on(b, 'click', () => { CO.term = term; renderCheckout(); });
            terms.appendChild(b);
        });
        const q = financeQuote(price);
        $('#co-fs-today-v').textContent = fmtMoney(q.downAmt);
        $('#co-fs-inst-v').textContent = `${fmtMoney(q.payment)} ${t('ui_every_hours', finParams().intervalHours || Runtime.finance.intervalHours)}`;
        $('#co-fs-interest-v').textContent = fmtMoney(q.interest);
        $('#co-fs-total-v').textContent = fmtMoney(q.totalCost);
    }

    // seller mode: customer picker + customer test drive
    $('#co-customer-block').hidden = !CO.sellerMode;
    $('#co-confirm').disabled = CO.sellerMode && !CO.customerId;
    if (CO.sellerMode) {
        $('#co-direct-td').hidden = !SR.data.testDrive;
        $('#co-direct-td').disabled = !CO.customerId;
        // per-player coupon limits are checked against the CUSTOMER, so a
        // coupon can only be previewed once one is selected
        $('#co-coupon-apply').disabled = !CO.customerId;
        $('#co-coupon').disabled = !CO.customerId;
    }
}

async function openCheckout(sellerMode) {
    if (!SR.selected) return;
    const f = finParams();
    CO.open = true;
    CO.sellerMode = !!sellerMode;
    CO.method = 'bank';
    CO.financed = false;
    CO.down = Math.round((f.downMin || .1) * 100);
    CO.term = arr(f.terms)[Math.floor(arr(f.terms).length / 2)] || 12;
    CO.coupon = null;
    CO.discount = 0;
    CO.customerId = null;
    $('#co-coupon').value = '';
    $('#co-coupon').className = '';
    $('#checkout-overlay').hidden = false;
    renderCheckout();

    if (sellerMode) {
        const r = await post('sr_nearby');
        const wrap = $('#co-customers');
        wrap.innerHTML = '';
        const players = arr(r.ok && r.data);
        if (!players.length) {
            wrap.innerHTML = `<div class="empty">${t('ui_no_customers')}</div>`;
        }
        players.forEach(p => {
            const item = document.createElement('div');
            item.className = 'cust-item';
            item.innerHTML = `<span></span><span class="cid mono">#${p.id}</span>`;
            item.querySelector('span').textContent = p.name;
            on(item, 'click', () => {
                CO.customerId = p.id;
                $$('.cust-item', wrap).forEach(x => x.classList.remove('active'));
                item.classList.add('active');
                renderCheckout();
            });
            wrap.appendChild(item);
        });
    }
}

function closeCheckout() {
    CO.open = false;
    $('#checkout-overlay').hidden = true;
}

on($('#btn-buy'), 'click', () => openCheckout(false));
on($('#btn-directsale'), 'click', () => openCheckout(true));
on($('#btn-testdrive'), 'click', () => {
    if (SR.selected) post('sr_testdrive', { model: SR.selected.model });
});
on($('#co-close'), 'click', closeCheckout);
on($('#co-cancel'), 'click', closeCheckout);
on($('#co-direct-td'), 'click', async () => {
    if (!SR.selected || !CO.customerId) return;
    const btn = $('#co-direct-td');
    btn.disabled = true;
    btn.querySelector('span').textContent = t('ui_waiting_customer');
    const r = await post('sr_direct_td', { model: SR.selected.model, customerId: CO.customerId });
    btn.disabled = false;
    btn.querySelector('span').textContent = t('ui_td_for_customer');
    if (!r.ok) return notifyErr(r.why);
    Notify({ type: 'success', message: t('ui_td_started') });
});
on($('#co-down'), 'input', e => { CO.down = Number(e.target.value); renderCheckout(); });

on($('#co-coupon-apply'), 'click', async () => {
    const input = $('#co-coupon');
    const code = input.value.trim().toUpperCase();
    if (!code || !SR.selected) return;
    const r = await post('sr_coupon', {
        model: SR.selected.model, code, financed: CO.financed,
        customerId: CO.sellerMode ? CO.customerId : null,
    });
    if (r.ok && r.data) {
        CO.coupon = r.data.code;
        CO.discount = r.data.discount;
        input.className = 'ok';
        $('#co-coupon-apply').textContent = t('ui_applied');
        renderCheckout();
    } else {
        CO.coupon = null;
        CO.discount = 0;
        input.className = 'bad';
        notifyErr(r.why);
        renderCheckout();
    }
});

on($('#co-confirm'), 'click', async () => {
    if (!SR.selected) return;
    const btn = $('#co-confirm');
    btn.disabled = true;
    if (CO.sellerMode) {
        btn.textContent = t('ui_waiting_customer');
        const r = await post('sr_directsale', {
            model: SR.selected.model, customerId: CO.customerId, coupon: CO.coupon,
            method: CO.method,
            finance: CO.financed ? { down: CO.down / 100, term: CO.term } : null,
        });
        btn.textContent = t('ui_confirm_purchase');
        btn.disabled = false;
        if (!r.ok) { notifyErr(r.why); return; }
        closeCheckout();
    } else {
        const payload = {
            model: SR.selected.model,
            method: CO.method,
            coupon: CO.coupon,
            finance: CO.financed ? { down: CO.down / 100, term: CO.term } : null,
        };
        const r = await post('sr_buy', payload);
        btn.disabled = false;
        if (!r.ok) { notifyErr(r.why); return; }
        closeCheckout();
    }
});

// ====================================================================
// Generic dialog (consent / offers)
// ====================================================================
const DLG = { open: false, kind: null };

function openDialog(kind, eyebrow, title, bodyHtml, buttons, wide) {
    DLG.open = true;
    DLG.kind = kind;
    $('#dialog-overlay .modal').classList.toggle('modal-sm', !wide);
    $('#dlg-eyebrow').textContent = eyebrow;
    $('#dlg-title').textContent = title;
    $('#dlg-body').innerHTML = bodyHtml;
    const foot = $('#dlg-foot');
    foot.innerHTML = '';
    buttons.forEach(([label, cls, fn]) => {
        const b = document.createElement('button');
        b.className = `btn ${cls}`;
        b.textContent = label;
        on(b, 'click', fn);
        foot.appendChild(b);
    });
    $('#dialog-overlay').hidden = false;
}

const emptyHtml = (icon, textKey) =>
    `<div class="empty"><i class="fa-solid ${icon || 'fa-inbox'}"></i><span>${t(textKey || 'ui_no_results')}</span></div>`;

function closeDialog() {
    DLG.open = false;
    DLG.kind = null;
    $('#dialog-overlay').hidden = true;
}

function directSaleOffer(p) {
    // the seller already picked the payment method / finance plan —
    // the customer reviews the complete offer and accepts or declines
    const methodBadge = (p.plan
        ? `<span class="badge badge-yellow">${t('ui_finance')}</span>`
        : `<span class="badge badge-brand">${t(p.method === 'cash' ? 'ui_cash' : 'ui_bank')}</span>`)
        + (p.discount > 0 ? ` <span class="badge badge-green">${t('ui_discount')} -${fmtMoney(p.discount)}</span>` : '');
    const finLines = p.plan ? `
        <div class="fin-summary">
            <div class="fin-line"><span>${t('ui_pay_today')}</span><span class="mono">${fmtMoney(p.plan.down)}</span></div>
            <div class="fin-line"><span>${t('ui_per_installment')}</span><span class="mono">${fmtMoney(p.plan.payment)} × ${p.plan.term}</span></div>
        </div>` : '';
    const body = `
        <div class="dlg-line">${t('ui_direct_offer', p.seller, p.label)}</div>
        <div class="dlg-highlight">${p.brand} ${p.name}</div>
        <div class="dlg-price mono">${fmtMoney(p.price)}</div>
        <div>${methodBadge}</div>
        ${finLines}`;
    openDialog('direct_sale', p.label, t('ui_checkout'), body, [
        [t('ui_decline'), 'btn-ghost', () => { closeDialog(); post('dialog_answer', { accept: false }); }],
        [t('ui_accept'), 'btn-primary', () => { closeDialog(); post('dialog_answer', { accept: true }); }],
    ]);
}

function testDriveOffer(p) {
    openDialog('testdrive', p.label, t('ui_test_drive'),
        `<div class="dlg-line">${t('ui_td_offer', p.seller, `${p.brand} ${p.name}`)}</div>`, [
        [t('ui_decline'), 'btn-ghost', () => { closeDialog(); post('dialog_answer', { accept: false }); }],
        [t('ui_accept'), 'btn-primary', () => { closeDialog(); post('dialog_answer', { accept: true }); }],
    ]);
}

function hireOffer(p) {
    openDialog('hire', p.dealership, t('ui_hire'),
        `<div class="dlg-line">${t('ui_hire_offer', p.by, p.dealership, p.role)}</div>`, [
        [t('ui_decline'), 'btn-ghost', () => { closeDialog(); post('dialog_answer', { accept: false }); }],
        [t('ui_accept'), 'btn-primary', () => { closeDialog(); post('dialog_answer', { accept: true }); }],
    ]);
}

function sellOffer(p) {
    openDialog('sell', p.plate, t('ui_sell_title'),
        `<div class="dlg-line">${t('ui_sell_body', fmtMoney(p.value), p.percent, `${p.brand} ${p.name}`)}</div>
         <div class="dlg-price mono">${fmtMoney(p.value)}</div>`, [
        [t('ui_cancel'), 'btn-ghost', () => { closeDialog(); post('sell_answer', { accept: false }); }],
        [t('ui_confirm'), 'btn-primary', () => { closeDialog(); post('sell_answer', { accept: true }); }],
    ]);
}

// ====================================================================
// Test drive HUD
// ====================================================================
function tdTick(left) {
    const el = $('#td-timer');
    const m = Math.floor(left / 60), s = left % 60;
    el.textContent = `${m}:${s.toString().padStart(2, '0')}`;
    el.classList.toggle('low', left <= 15);
}

// ====================================================================
// Management
// ====================================================================
const MG = { open: false, data: null, tab: 'overview' };

const MG_TABS = [
    ['overview',  'fa-chart-line',   'ui_overview',  null],
    ['inventory', 'fa-warehouse',    'ui_inventory', 'MANAGE_STOCK'],
    ['orders',    'fa-truck',        'ui_orders',    'VIEW_RECORDS'],
    ['sales',     'fa-receipt',      'ui_sales',     'VIEW_RECORDS'],
    // staff tab only when the dealership does NOT run on a framework job
    // (job-based stands are staffed through the job / apex_bossmenu)
    ['employees', 'fa-users',        'ui_employees', 'MANAGE_EMPLOYEES', '__nojob'],
    ['coupons',   'fa-ticket',       'ui_coupons',   'MANAGE_STOCK'],
    ['settings',  'fa-gear',         'ui_settings',  'ADMIN'],
    // NO catalog / stock tabs here: both are configured in /dealerships
];

function mgCan(perm, extra) {
    if (extra === '__nojob' && MG.data.info && MG.data.info.bossJob) return false;
    if (!perm) return true;
    if (perm === '__admin') return MG.data.isAdmin;
    return !!MG.data.perms[perm];
}

function openManagement(snap) {
    MG.open = true;
    snap.stock = arr(snap.stock);
    snap.graph = arr(snap.graph);
    snap.roles = arr(snap.roles);
    MG.data = snap;
    MG.tab = 'overview';
    const roleLabel = snap.role === 'serverAdmin' ? 'ADMIN' : snap.role;
    $('#mg-dealer-name').textContent = snap.label;
    $('#mg-dealer-role').textContent = roleLabel;
    $('#mg-me-name').textContent = snap.name || '';
    $('#mg-me-role').textContent = roleLabel;
    // avatar: initials on the brand gradient, with the real in-game headshot
    // layered on top once the client resolves it (same as apex_bossmenu).
    // The <img> is only created WITH a src — an empty-src img fires onerror
    // in CEF and would delete itself before the headshot ever arrives.
    const initials = String(snap.name || '?').trim().split(/\s+/).slice(0, 2)
        .map(w => w[0] || '').join('').toUpperCase() || '?';
    const av = $('#mg-me-avatar');
    av.classList.remove('has-mug');
    av.textContent = initials;
    // The <img> is attached with its src set straight away (exactly like
    // apex_bossmenu does): waiting for onload before attaching meant a slow
    // nui-img decode left the avatar on the initials forever.
    const loadMug = (attempt) => {
        post('mg_headshot').then(r => {
            if (!MG.open) return;
            if (!r || !r.url) {
                if (attempt < 3) setTimeout(() => loadMug(attempt + 1), 800);
                return;
            }
            av.querySelectorAll('img').forEach(i => i.remove());
            const img = document.createElement('img');
            img.alt = '';
            // the opaque headshot carries a dark backdrop baked in — blend it
            // away so the brand colour shows behind the face
            if (r.opaque) img.classList.add('mug-opaque');
            // hide the initials once the photo is really there: with `screen`
            // blending the white letters would otherwise show THROUGH the face
            img.onload = () => av.classList.add('has-mug');
            img.onerror = () => {
                img.remove();
                av.classList.remove('has-mug');
                if (attempt < 3) setTimeout(() => loadMug(attempt + 1), 800);
            };
            img.src = r.url;
            av.appendChild(img);
        }).catch(() => {});
    };
    loadMug(0);
    // restore the collapsed rail preference
    $('.mg-shell').classList.toggle('rail-collapsed', localStorage.getItem('apexdealer-rail') === '1');
    renderMgNav();
    renderMgPane();
    $('#mgmt').hidden = false;
}

function closeManagementUI() {
    MG.open = false;
    hideTooltip();
    $('#mgmt').hidden = true;
}

function renderMgNav() {
    const nav = $('#mg-nav');
    nav.innerHTML = '';
    MG_TABS.forEach(([key, icon, label, perm, extra]) => {
        if (!mgCan(perm, extra)) return;
        const b = document.createElement('button');
        b.className = MG.tab === key ? 'active' : '';
        b.innerHTML = `<i class="fa-solid ${icon}"></i><span>${t(label)}</span>`;
        on(b, 'click', () => { MG.tab = key; renderMgNav(); renderMgPane(); });
        nav.appendChild(b);
    });
}

function paneHeader(labelKey) {
    $('#mg-eyebrow').textContent = MG.data.label;
    $('#mg-title').textContent = t(labelKey);
}

async function renderMgPane() {
    const pane = $('#mg-pane');
    pane.innerHTML = '';
    const tab = MG.tab;
    const def = MG_TABS.find(([key]) => key === tab);
    if (def) $('#mg-tab-ico').className = `fa-solid ${def[1]}`;
    if (tab === 'overview') return renderOverview(pane);
    if (tab === 'inventory') return renderInventory(pane);
    if (tab === 'orders') return renderOrders(pane);
    if (tab === 'sales') return renderSales(pane, 1, '');
    if (tab === 'employees') return renderEmployees(pane);
    if (tab === 'coupons') return renderCoupons(pane);
    if (tab === 'settings') return renderSettings(pane);
}

function renderOverview(pane) {
    paneHeader('ui_overview');
    const d = MG.data;
    const salesWord = t('ui_sales').toLowerCase();
    const kpi = (icon, label, val, sub, accent) => `
        <div class="kpi ${accent ? 'kpi-accent' : ''}">
            <div class="kpi-ic"><i class="fa-solid ${icon}"></i></div>
            <div class="kpi-body">
                <div class="kpi-label">${label}</div>
                <div class="kpi-val mono">${val}</div>
                ${sub ? `<div class="kpi-sub">${sub}</div>` : ''}
            </div>
        </div>`;

    let html = `<div class="kpi-strip">
        ${kpi('fa-vault', t('ui_balance'), fmtMoney(d.balance), null, true)}
        ${kpi('fa-bolt', t('ui_today'), fmtMoney(d.stats.today.revenue), `${d.stats.today.sales} ${salesWord}`)}
        ${kpi('fa-calendar-week', t('ui_week'), fmtMoney(d.stats.week.revenue), `${d.stats.week.sales} ${salesWord}`)}
        ${kpi('fa-chart-column', t('ui_month'), fmtMoney(d.stats.month.revenue), `${d.stats.month.sales} ${salesWord}`)}
    </div>`;

    // main grid: chart (wide) + treasury / meta side card
    const max = Math.max(1, ...d.graph.map(g => g.revenue));
    let bars = '';
    d.graph.forEach(g => {
        const h = Math.max(2, Math.round(g.revenue / max * 100));
        bars += `<div class="cbar" title="${fmtMoney(g.revenue)}">
            <div class="cbar-val mono">${g.revenue ? fmtMoney(g.revenue) : ''}</div>
            <div class="cbar-fill" style="height:${h}%"></div>
            <div class="cbar-day">${g.day.slice(5)}</div></div>`;
    });

    const treasuryCard = d.perms.MANAGE_FINANCES ? `
        <div class="ov-side-block">
            <div class="chart-title">${t('ui_treasury')}</div>
            ${d.society ? `<div class="tile-sub" style="margin-bottom:8px">
                <i class="fa-solid fa-building-columns"></i> ${t('ui_treasury_society', esc(d.society))}</div>` : ''}
            <input type="number" id="tr-amount" min="1" placeholder="${t('ui_amount')}" class="mono">
            <div class="ov-side-actions">
                <button class="btn btn-ghost btn-sm" id="tr-deposit"><i class="fa-solid fa-arrow-down"></i> ${t('ui_deposit')}</button>
                <button class="btn btn-primary btn-sm" id="tr-withdraw"><i class="fa-solid fa-arrow-up"></i> ${t('ui_withdraw')}</button>
            </div>
        </div>` : '';

    // without the treasury card the aside would be a mostly-empty 260px column,
    // so the remaining block becomes a full-width strip under the chart instead
    html += `<div class="ov-grid${treasuryCard ? '' : ' ov-grid-solo'}">
        <div class="chart">
            <div class="chart-title">${t('ui_revenue')} · ${t('ui_week')}</div>
            <div class="chart-bars">${bars}</div>
        </div>
        <div class="ov-side">
            ${treasuryCard}
            <div class="ov-side-block">
                <div class="fin-line"><span>${t('ui_lifetime_revenue')}</span><strong class="mono">${fmtMoney(d.lifetime)}</strong></div>
                <div class="fin-line"><span>${t('ui_commission')}</span><strong class="mono">${d.commission}%</strong></div>
                <div class="fin-line"><span>${t('ui_stock')}</span><strong class="mono">${arr(d.stock).reduce((a, s) => a + (s.stock || 0), 0)}</strong></div>
            </div>
        </div>
    </div>`;

    // recent sales with vehicle thumbnails
    const recent = arr(d.recent);
    const vehName = (model) => {
        const s = arr(d.stock).find(x => x.model === model);
        return s ? `${s.brand} ${s.name}` : model;
    };
    html += `<div class="mg-section-card ov-recent"><div class="chart-title">${t('ui_recent_sales')}</div>`;
    if (!recent.length) html += emptyHtml('fa-receipt', 'ui_no_sales');
    else {
        html += `<div class="recent-list">` + recent.map(s => {
            const fallback = (s.model || '?').slice(0, 2).toUpperCase();
            const thumb = imgTag(s.model, fallback);
            return `<div class="recent-item">
                <div class="veh-thumb">${thumb}</div>
                <div class="recent-info">
                    <div class="recent-name">${vehName(s.model)}</div>
                    <div class="recent-sub">${s.buyer_name || ''} · <span class="mono">${s.plate}</span> · ${s.created_at}</div>
                </div>
                <span class="badge ${s.kind === 'buyback' ? 'badge-red' : s.kind === 'finance' ? 'badge-yellow' : 'badge-green'}">${s.kind}</span>
                <div class="recent-amount mono">${fmtMoney(s.amount)}</div>
            </div>`;
        }).join('') + `</div>`;
    }
    html += `</div>`;
    pane.innerHTML = html;

    const trAct = async (name) => {
        const amount = Number($('#tr-amount').value);
        if (!amount || amount <= 0) return;
        const r = await post(name, { amount });
        if (!r.ok) return notifyErr(r.why);
        await refreshMg();
    };
    on($('#tr-deposit'), 'click', () => trAct('mg_deposit'));
    on($('#tr-withdraw'), 'click', () => trAct('mg_withdraw'));
}

async function refreshMg() {
    const r = await post('mg_refresh', {});
    if (r.ok && r.data) {
        MG.data = r.data;
        renderMgPane();
    }
}

// ── Delivery configuration (trucking mission) ──
// Pick the orders + quantities and the trailer. The capacity rules are the
// same the server enforces: a car carrier has 6 slots (small 1, medium 1.5),
// a container carries exactly one large vehicle.
async function deliveryModal() {
    const r = await post('mg_stockrun_pending', { dealership: MG.data.dealership });
    if (!r.ok) return notifyErr(r.why);
    const d = r.data || {};
    const orders = arr(d.orders).filter(o => o.available > 0);
    const maxSlots = Number(d.maxSlots) || 6;
    const maxVehicles = Number(d.maxVehicles) || 4;   // physical decks on the trailer
    const slotSize = d.slotSize || { small: 1, medium: 1.5 };

    if (!orders.length) return Notify({ type: 'error', message: t('e_run_no_selection') });

    let trailer = orders.every(o => o.size === 'large') ? 'container' : 'car';
    const sel = {};                       // orderId -> qty

    const sizeBadge = (s) => `<span class="badge ${s === 'large' ? 'badge-red' : s === 'small' ? 'badge-green' : 'badge-yellow'}">${t('ui_size_' + s)}</span>`;

    const body = `
        <div class="sec-title">${t('ui_trailer')}</div>
        <div class="seg" id="dl-trailer">
            <button data-tr="car" class="${trailer === 'car' ? 'active' : ''}">
                <i class="fa-solid fa-truck-ramp-box"></i> ${t('ui_trailer_car')}</button>
            <button data-tr="container" class="${trailer === 'container' ? 'active' : ''}">
                <i class="fa-solid fa-box"></i> ${t('ui_trailer_container')}</button>
        </div>
        <div class="tile-sub" style="margin:6px 0 10px" id="dl-trailer-hint"></div>

        <div class="sec-title">${t('ui_orders')}</div>
        <div class="veh-pick-list" id="dl-orders"></div>

        <div class="dl-capacity">
            <div class="dl-cap-bar"><div class="dl-cap-fill" id="dl-cap-fill"></div></div>
            <div class="dl-cap-txt"><span id="dl-cap-label"></span></div>
        </div>`;

    openDialog('delivery', MG.data.label, t('ui_stockrun_start'), body, [
        [t('ui_cancel'), 'btn-ghost', () => closeDialog()],
        [t('ui_stockrun_go'), 'btn-primary', () => {
            const picked = Object.keys(sel).filter(id => sel[id] > 0)
                .map(id => ({ id: Number(id), qty: sel[id] }));
            if (!picked.length) return Notify({ type: 'error', message: t('e_run_no_selection') });
            closeDialog();
            hideTooltip();
            post('mg_stockrun', {
                dealership: MG.data.dealership, trailerType: trailer, orders: picked,
            });
        }],
    ], true);

    const usable = () => orders.filter(o => trailer === 'container' ? o.size === 'large' : o.size !== 'large');
    const usedSlots = () => usable().reduce((a, o) => a + (sel[o.id] || 0) * (slotSize[o.size] || 1), 0);
    const usedUnits = () => usable().reduce((a, o) => a + (sel[o.id] || 0), 0);

    const paint = () => {
        const list = usable();
        $('#dl-trailer-hint').textContent = t(trailer === 'container' ? 'ui_trailer_container_hint' : 'ui_trailer_car_hint');
        $('#dl-orders').innerHTML = list.length ? list.map(o => `
            <div class="dl-order">
                <div class="dl-order-info">
                    <div class="tbl-veh-name">${esc(o.name)} ${sizeBadge(o.size)}</div>
                    <div class="tbl-veh-sub mono">${esc(o.model)} · ${t('ui_adm_vehicles')}: ${o.available}/${o.quantity}${o.inTransit ? ` · ${o.inTransit} ${t('ui_in_transit').toLowerCase()}` : ''} · ${fmtMoney(o.costEach)} ${t('ui_each')}</div>
                </div>
                <div class="dl-qty">
                    <button class="btn btn-ghost btn-sm" data-minus="${o.id}">−</button>
                    <span class="mono" id="dl-q-${o.id}">${sel[o.id] || 0}</span>
                    <button class="btn btn-ghost btn-sm" data-plus="${o.id}">+</button>
                </div>
            </div>`).join('') : emptyHtml('fa-boxes-stacked', 'ui_no_orders');

        const cap = trailer === 'container' ? 1 : maxSlots;
        const used = trailer === 'container' ? usedUnits() : usedSlots();
        const units = usedUnits();
        const pct = Math.min(100, (used / cap) * 100);
        const fill = $('#dl-cap-fill');
        fill.style.width = pct + '%';
        fill.classList.toggle('full', used >= cap || (trailer === 'car' && units >= maxVehicles));
        $('#dl-cap-label').innerHTML = trailer === 'container'
            ? `${t('ui_capacity')}: <b class="mono">${used}/1</b> ${t('ui_size_large').toLowerCase()}`
            : `${t('ui_capacity')}: <b class="mono">${used.toFixed(1)}/${cap}</b> ${t('ui_slots')}
               · <b class="mono">${units}/${maxVehicles}</b> ${t('ui_decks')}`;

        $$('#dl-orders [data-plus]').forEach(b => on(b, 'click', () => {
            const o = orders.find(x => x.id === Number(b.dataset.plus));
            const cur = sel[o.id] || 0;
            if (cur >= o.available) return;
            const capNow = trailer === 'container' ? 1 : maxSlots;
            const usedNow = trailer === 'container' ? usedUnits() : usedSlots();
            const add = trailer === 'container' ? 1 : (slotSize[o.size] || 1);
            if (usedNow + add > capNow) return Notify({ type: 'error', message: t('e_run_capacity') });
            // the trailer physically holds only `maxVehicles` bodies
            if (trailer === 'car' && usedUnits() + 1 > maxVehicles) {
                return Notify({ type: 'error', message: t('e_run_decks', maxVehicles) });
            }
            sel[o.id] = cur + 1;
            paint();
        }));
        $$('#dl-orders [data-minus]').forEach(b => on(b, 'click', () => {
            const id = Number(b.dataset.minus);
            sel[id] = Math.max(0, (sel[id] || 0) - 1);
            paint();
        }));
    };

    $$('#dl-trailer button').forEach(b => on(b, 'click', () => {
        trailer = b.dataset.tr;
        Object.keys(sel).forEach(k => delete sel[k]);   // capacity rules changed
        $$('#dl-trailer button').forEach(x => x.classList.toggle('active', x === b));
        paint();
    }));
    paint();
}


// modal listing every placed showcase vehicle, with delete buttons
function showcaseModal(showcase) {
    const vehOf = (model) => arr(MG.data.stock).find(x => x.model === model) || { model, name: model };
    const body = showcase.length
        ? `<div class="recent-list">${showcase.map(x => {
            const v = vehOf(x.model);
            return `<div class="recent-item">
                ${vehThumb(v, 'thumb-sm')}
                <div class="recent-info">
                    <div class="recent-name">${v.brand || ''} ${v.name}</div>
                    <div class="recent-sub mono">${x.model}</div>
                </div>
                <button class="btn btn-danger btn-sm tip" data-showrm="${x.id}" data-tip="${t('ui_delete')}"><i class="fa-solid fa-trash"></i></button>
            </div>`;
        }).join('')}</div>`
        : emptyHtml('fa-car-side');
    openDialog('showcase', MG.data.label, t('ui_showcase'), body, [
        [t('ui_close'), 'btn-ghost', () => closeDialog()],
    ], true);
    $$('#dlg-body button[data-showrm]').forEach(b => on(b, 'click', async () => {
        const r = await post('mg_showcase_remove', { id: Number(b.dataset.showrm), dealership: MG.data.dealership });
        if (!r.ok) return notifyErr(r.why);
        closeDialog();
        renderMgPane();
    }));
}

async function renderInventory(pane) {
    paneHeader('ui_inventory');
    const showR = await post('mg_showcase_list', {});
    if (!MG.open || MG.tab !== 'inventory') return;   // user switched tabs mid-await
    const showcase = arr(showR.ok && showR.data).filter(x => x.dealership === MG.data.dealership);
    const rows = MG.data.stock.map((s, i) => `
        <tr data-i="${i}">
            ${vehCell(s)}
            <td class="num mono muted">${fmtMoney(s.basePrice)}</td>
            <td class="num"><input type="number" class="price-in" value="${s.price}" min="${s.priceFloor}" max="${s.priceCeil}"></td>
            <td class="num">${s.stock > 0
                ? `<span class="badge badge-blue mono">${s.stock}</span>`
                : `<span class="badge badge-red mono">0</span>`}</td>
            <td class="num mono muted">${fmtMoney(s.wholesale)}</td>
            <td class="num"><input type="number" class="qty qty-in" value="1" min="1" max="25"></td>
            <td class="row-actions">
                <button class="btn btn-ghost btn-sm act-price tip" data-tip="${t('ui_save_price')}"><i class="fa-solid fa-tag"></i></button>
                <button class="btn btn-primary btn-sm act-order tip" data-tip="${t('ui_order_hint')}"><i class="fa-solid fa-truck-fast"></i></button>
                <button class="btn btn-ghost btn-sm act-show tip" data-tip="${t('ui_place_here')}"><i class="fa-solid fa-car-side"></i></button>
            </td>
        </tr>`).join('');
    let html = `<div class="mg-head-row">
        <span class="muted">${MG.data.stock.length} ${t('ui_inventory').toLowerCase()}</span>
        <div style="display:flex;align-items:center;gap:10px;margin-left:auto">
            <span class="badge ${(MG.data.balance || 0) > 0 ? 'badge-brand' : 'badge-red'}">
                <i class="fa-solid fa-vault"></i> ${t('ui_treasury')}: <span class="mono">${fmtMoney(MG.data.balance || 0)}</span>
            </span>
            <button class="btn btn-ghost btn-sm" id="show-showcase">
                <i class="fa-solid fa-car-side"></i> ${t('ui_showcase')} (${showcase.length})
            </button>
        </div>
    </div>
    <div class="tile-sub" style="margin-bottom:8px">${t('ui_order_pay_hint')}</div>`;
    html += `<table class="tbl tbl-veh-table"><thead><tr>
        <th>${t('ui_model')}</th><th class="num">${t('ui_base_price')}</th><th class="num">${t('ui_price')}</th>
        <th class="num">${t('ui_stock')}</th><th class="num">${t('ui_wholesale')}</th><th class="num">${t('ui_quantity')}</th><th></th>
        </tr></thead><tbody>${rows}</tbody></table>`;
    pane.innerHTML = html;
    on($('#show-showcase'), 'click', () => showcaseModal(showcase));

    $$('tr[data-i]', pane).forEach(tr => {
        const s = MG.data.stock[Number(tr.dataset.i)];
        on($('.act-price', tr), 'click', async () => {
            const price = Number($('.price-in', tr).value);
            const r = await post('mg_price', { model: s.model, price });
            if (!r.ok) return notifyErr(r.why);
            await refreshMg();
        });
        on($('.act-order', tr), 'click', async () => {
            const quantity = Number($('.qty-in', tr).value) || 1;
            const cost = (s.wholesale || 0) * quantity;
            // ordering is paid from the DEALERSHIP treasury, not your pocket —
            // say so plainly instead of letting the server bounce it back
            if (cost > (MG.data.balance || 0)) {
                return Notify({
                    type: 'error',
                    message: t('e_biz_insufficient_detail', fmtMoney(cost), fmtMoney(MG.data.balance || 0)),
                });
            }
            const r = await post('mg_order', { model: s.model, quantity });
            if (!r.ok) return notifyErr(r.why);
            Notify({ type: 'success', message: `${t('ui_order_stock')}: ${s.name} x${quantity} · ${fmtMoney(cost)}` });
            // with stock runs on, ordering immediately puts you behind the wheel:
            // the truck spawns at the stand's stock point and off you go
            if (MG.data.stockPickup) {
                hideTooltip();
                post('mg_stockrun', { dealership: MG.data.dealership });
                return;
            }
            await refreshMg();
        });
        on($('.act-show', tr), 'click', () => {
            // the showcase is independent of the showroom: boats/aircraft keep
            // the height you place them at
            post('mg_showcase_place', {
                model: s.model, dealership: MG.data.dealership, domain: catDomain(s.category),
            });
        });
    });
}

async function renderOrders(pane) {
    paneHeader('ui_orders');
    const r = await post('mg_orders', {});
    if (!MG.open || MG.tab !== 'orders') return;
    if (!r.ok) { pane.innerHTML = emptyHtml('fa-triangle-exclamation'); return; }
    const rows = arr(r.data.rows), now = r.data.now;
    if (!rows.length) { pane.innerHTML = emptyHtml('fa-truck', 'ui_no_orders'); return; }

    // trucking missions: nothing is delivered by a timer — an employee has to
    // configure a delivery (orders + quantities + trailer) and truck it in
    const pickup = !!MG.data.stockPickup;
    const pending = pickup ? rows.filter(o => !o.fulfilled) : [];

    let html = '';
    if (pickup) {
        // the explainer lives in an "i" instead of a wall of text under the table
        html += `<div class="mg-head-row">
            <span class="muted">${pending.length} ${t('ui_orders').toLowerCase()}
                <i class="fa-solid fa-circle-info tip head-info" data-tip="${esc(t('ui_stockrun_hint'))}"></i>
            </span>
            ${pending.length ? `<button class="btn btn-primary btn-sm" id="or-run">
                <i class="fa-solid fa-truck-ramp-box"></i> ${t('ui_stockrun_start')}</button>` : ''}
        </div>`;
    }
    html += `<table class="tbl"><thead><tr>
        <th>${t('ui_model')}</th><th class="num">${t('ui_quantity')}</th><th class="num">${t('ui_price')}</th>
        <th>${t('ui_ordered_by')}</th><th>${t('ui_type')}</th><th></th></tr></thead>
        <tbody>${rows.map(o => {
            const left = Math.max(0, o.deliver_at - now);
            const done = Number(o.delivered || 0);
            let status;
            if (o.fulfilled) status = `<span class="badge badge-green">${t('ui_delivered')}</span>`;
            else if (pickup && done > 0) status = `<span class="badge badge-yellow"><i class="fa-solid fa-truck"></i> ${done}/${o.quantity}</span>`;
            else if (pickup) status = `<span class="badge badge-brand"><i class="fa-solid fa-boxes-stacked"></i> ${t('ui_awaiting_pickup')}</span>`;
            else if (left > 0) status = `<span class="badge badge-yellow">${t('ui_in_transit')} · ${Math.ceil(left / 60)}m</span>`;
            else status = `<span class="badge badge-yellow">${t('ui_in_transit')}</span>`;
            return `<tr>
                <td><b>${o.model}</b></td>
                <td class="num mono">${done > 0 ? `${done}/${o.quantity}` : o.quantity}</td>
                <td class="num mono">${fmtMoney(o.cost)}</td>
                <td>${o.ordered_by || ''}</td>
                <td>${status}</td>
                <td class="row-actions">${(o.fulfilled || done > 0) ? '' :
                    `<button class="btn btn-danger btn-sm" data-cancel="${o.id}">${t('ui_cancel_order')}</button>`}</td>
            </tr>`;
        }).join('')}</tbody></table>`;
    pane.innerHTML = html;

    on($('#or-run'), 'click', () => deliveryModal());
    $$('button[data-cancel]', pane).forEach(b => on(b, 'click', async () => {
        if (b.disabled) return;
        b.disabled = true;                       // no double-click on a stale row
        const r2 = await post('mg_cancel', { id: Number(b.dataset.cancel) });
        if (!r2.ok && r2.why !== 'order_gone') notifyErr(r2.why);
        await refreshMg();                       // always resync the list
        renderMgPane();
    }));
}

async function renderSales(pane, page, search) {
    paneHeader('ui_sales');
    const r = await post('mg_sales', { page, search });
    if (!MG.open || MG.tab !== 'sales') return;
    if (!r.ok) { pane.innerHTML = `<div class="empty">${t('e_' + r.why)}</div>`; return; }
    const d = r.data;
    d.rows = arr(d.rows);
    let html = `<div class="search-wrap"><i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" id="sales-search" placeholder="${t('ui_search')}" value="${search || ''}" style="width:100%;padding-left:34px"></div>`;
    if (!d.rows.length) html += emptyHtml('fa-receipt', 'ui_no_sales');
    else {
        html += `<table class="tbl"><thead><tr>
            <th>${t('ui_date')}</th><th>${t('ui_model')}</th><th>${t('ui_plate')}</th>
            <th>${t('ui_buyer')}</th><th>${t('ui_type')}</th><th class="num">${t('ui_amount')}</th></tr></thead>
            <tbody>${d.rows.map(s => `<tr>
                <td class="mono">${(s.created_at || '').toString().slice(0, 10)}</td>
                <td><b>${s.model}</b></td>
                <td class="mono">${s.plate}</td>
                <td>${s.buyer_name || ''}${s.seller_name ? `<div class="tile-sub">${t('ui_seller')}: ${s.seller_name}</div>` : ''}</td>
                <td><span class="badge ${s.kind === 'buyback' ? 'badge-red' : s.kind === 'finance' ? 'badge-yellow' : 'badge-green'}">${s.kind}</span></td>
                <td class="num mono">${fmtMoney(s.amount)}</td>
            </tr>`).join('')}</tbody></table>`;
        html += `<div class="pager">
            <button class="btn btn-ghost btn-sm" id="pg-prev" ${d.page <= 1 ? 'disabled' : ''}>&laquo;</button>
            <span>${t('ui_page')} ${d.page}/${d.pages}</span>
            <button class="btn btn-ghost btn-sm" id="pg-next" ${d.page >= d.pages ? 'disabled' : ''}>&raquo;</button></div>`;
    }
    pane.innerHTML = html;
    let timer;
    on($('#sales-search'), 'input', e => {
        clearTimeout(timer);
        timer = setTimeout(() => renderSales(pane, 1, e.target.value), 350);
    });
    on($('#pg-prev'), 'click', () => renderSales(pane, d.page - 1, search));
    on($('#pg-next'), 'click', () => renderSales(pane, d.page + 1, search));
}

// hire modal: pick a nearby player + role (admins can also self-hire)
async function hireModal() {
    const roles = arr(MG.data.roles);
    const r = await post('mg_nearby', {});
    const nearby = arr(r.ok && r.data);
    const body = `
        <div class="form-grid" style="margin-top:0">
            <div class="form-field full"><label>${t('ui_customer')}</label>
                <select id="hire-target">${nearby.length
                    ? nearby.map(p => `<option value="${p.id}">${p.name} (#${p.id})</option>`).join('')
                    : `<option value="">${t('ui_no_customers')}</option>`}</select></div>
            <div class="form-field full"><label>${t('ui_role')}</label>
                <select id="hire-role">${roles.map(x => `<option>${x}</option>`).join('')}</select></div>
        </div>
        ${MG.data.isAdmin ? `<button class="btn btn-ghost btn-block" id="hire-self" style="margin-top:10px">
            <i class="fa-solid fa-user-shield"></i> ${t('ui_hire_self')}</button>` : ''}`;
    openDialog('hire', MG.data.label, t('ui_hire'), body, [
        [t('ui_cancel'), 'btn-ghost', () => closeDialog()],
        [t('ui_hire'), 'btn-primary', async () => {
            const targetId = Number($('#hire-target').value);
            if (!targetId) return notifyErr('bad_customer');
            const btn = $$('#dlg-foot .btn-primary')[0];
            btn.disabled = true;
            btn.textContent = t('ui_waiting_customer');
            const res = await post('mg_hire', { targetId, role: $('#hire-role').value });
            btn.disabled = false;
            btn.textContent = t('ui_hire');
            if (!res.ok) return notifyErr(res.why);
            closeDialog();
            renderMgPane();
        }],
    ], true);
    on($('#hire-self'), 'click', async () => {
        const res = await post('mg_hire', { role: $('#hire-role').value });
        if (!res.ok) return notifyErr(res.why);
        closeDialog();
        renderMgPane();
    });
}

async function renderEmployees(pane) {
    paneHeader('ui_employees');
    const r = await post('mg_employees', {});
    if (!MG.open || MG.tab !== 'employees') return;
    if (!r.ok) { pane.innerHTML = emptyHtml('fa-triangle-exclamation'); return; }
    const rows = arr(r.data);
    const roles = arr(MG.data.roles);
    let html = `<div class="mg-head-row">
        <span class="muted">${rows.length} ${t('ui_employees').toLowerCase()}</span>
        <button class="btn btn-primary btn-sm" id="emp-add"><i class="fa-solid fa-user-plus"></i> ${t('ui_hire')}</button>
    </div>`;
    if (!rows.length) html += emptyHtml('fa-users');
    else {
        html += `<table class="tbl"><thead><tr>
            <th>${t('ui_name')}</th><th>${t('ui_role')}</th><th>${t('ui_hired')}</th><th></th></tr></thead>
            <tbody>${rows.map(e => `<tr>
                <td><b>${e.name}</b></td>
                <td><select data-role="${e.id}">${roles.map(x =>
                    `<option ${x === e.role ? 'selected' : ''}>${x}</option>`).join('')}</select></td>
                <td class="mono">${e.hired_at || ''}</td>
                <td class="row-actions">
                    <button class="btn btn-danger btn-sm tip" data-fire="${e.id}" data-tip="${t('ui_fire')}"><i class="fa-solid fa-user-xmark"></i></button></td>
            </tr>`).join('')}</tbody></table>`;
    }
    pane.innerHTML = html;
    on($('#emp-add'), 'click', hireModal);
    $$('select[data-role]', pane).forEach(sel => on(sel, 'change', async () => {
        const res = await post('mg_role', { id: Number(sel.dataset.role), role: sel.value });
        if (!res.ok) { notifyErr(res.why); renderMgPane(); }
    }));
    $$('button[data-fire]', pane).forEach(b => on(b, 'click', async () => {
        const res = await post('mg_fire', { id: Number(b.dataset.fire) });
        if (!res.ok) return notifyErr(res.why);
        renderMgPane();
    }));
}

function couponBadges(c) {
    const out = [];
    if (c.expires_at && c.expires_at > 0) {
        const d = new Date(c.expires_at * 1000);
        out.push(`<span class="badge badge-yellow"><i class="fa-solid fa-clock"></i>${d.getDate()}/${d.getMonth() + 1}</span>`);
    }
    if (c.per_player && c.per_player > 0) out.push(`<span class="badge badge-blue">${c.per_player}/${t('ui_customer').toLowerCase()}</span>`);
    try {
        const v = c.vehicle_restrictions ? JSON.parse(c.vehicle_restrictions) : [];
        if (v.length) out.push(`<span class="badge badge-brand"><i class="fa-solid fa-car"></i>${v.length}</span>`);
        const cats = c.category_restrictions ? JSON.parse(c.category_restrictions) : [];
        if (cats.length) out.push(`<span class="badge badge-brand"><i class="fa-solid fa-layer-group"></i>${cats.length}</span>`);
    } catch (_) {}
    if (!c.allow_finance) out.push(`<span class="badge badge-red">${t('ui_finance')} ✕</span>`);
    return out.join(' ');
}

function couponModal() {
    const stock = arr(MG.data.stock);
    const cats = arr(MG.data.info && MG.data.info.categories);
    const swRow = (id, label, extraHtml) => `
        <div class="switch-row">
            <label class="sw"><input type="checkbox" id="${id}"><span class="sw-track"></span></label>
            <span class="sw-label">${label}</span>
            ${extraHtml || ''}
        </div>`;
    const body = `
        <div class="form-field full" style="margin-bottom:10px">
            <label>${t('ui_code')}</label>
            <div class="coupon-row">
                <input type="text" id="cp-code" maxlength="40" spellcheck="false">
                <button class="btn btn-ghost btn-sm" id="cp-gen"><i class="fa-solid fa-wand-magic-sparkles"></i> ${t('ui_generate')}</button>
            </div>
        </div>
        <div class="form-grid" style="margin-top:0">
            <div class="form-field"><label>${t('ui_type')}</label>
                <select id="cp-type"><option value="percent">${t('ui_percent')}</option><option value="amount">${t('ui_fixed')}</option></select></div>
            <div class="form-field"><label>${t('ui_discount')}</label><input type="number" id="cp-value" min="1" value="10"></div>
        </div>
        <div class="switch-stack">
            ${swRow('cp-lim-uses', t('ui_limit_uses'), `<input type="number" class="sw-input" id="cp-max" min="1" value="10" hidden>`)}
            ${swRow('cp-lim-pp', t('ui_limit_pp'), `<input type="number" class="sw-input" id="cp-pp" min="1" value="1" hidden>`)}
            ${swRow('cp-exp', t('ui_set_expiry'), `<input type="number" class="sw-input" id="cp-days" min="1" value="7" hidden> <span class="sw-suffix" id="cp-days-lbl" hidden>${t('ui_days')}</span>`)}
            ${swRow('cp-rveh', t('ui_restrict_vehicles'))}
            <select id="cp-veh" multiple size="5" class="multi" hidden>
                ${stock.map(s => `<option value="${s.model}">${s.brand} ${s.name}</option>`).join('')}
            </select>
            ${swRow('cp-rcat', t('ui_restrict_categories'))}
            <select id="cp-cat" multiple size="4" class="multi" hidden>
                ${cats.map(k => `<option value="${k}">${catLabel(k)}</option>`).join('')}
            </select>
            ${swRow('cp-fin', t('ui_allow_financed'))}
        </div>`;

    openDialog('coupon', MG.data.label, t('ui_new_coupon'), body, [
        [t('ui_cancel'), 'btn-ghost', () => closeDialog()],
        [t('ui_new_coupon'), 'btn-primary', async () => {
            const sel = (id) => $$(`#${id} option:checked`).map(o => o.value);
            const payload = {
                code: $('#cp-code').value,
                discountType: $('#cp-type').value,
                discountValue: Number($('#cp-value').value),
                maxUses: $('#cp-lim-uses').checked ? Number($('#cp-max').value) : 0,
                perPlayer: $('#cp-lim-pp').checked ? Number($('#cp-pp').value) : 0,
                expiresAt: $('#cp-exp').checked
                    ? Math.floor(Date.now() / 1000) + (Number($('#cp-days').value) || 7) * 86400 : 0,
                vehicles: $('#cp-rveh').checked ? sel('cp-veh') : [],
                categories: $('#cp-rcat').checked ? sel('cp-cat') : [],
                allowFinance: $('#cp-fin').checked,
            };
            const r = await post('mg_coupon_new', payload);
            if (!r.ok) return notifyErr(r.why);
            closeDialog();
            renderMgPane();
        }],
    ], true);

    $('#cp-fin').checked = true;
    on($('#cp-gen'), 'click', () => {
        const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
        let code = '';
        for (let i = 0; i < 8; i++) code += chars[Math.floor(Math.random() * chars.length)];
        $('#cp-code').value = code;
    });
    const bindToggle = (sw, ...els) => on($('#' + sw), 'change', e =>
        els.forEach(id => { const el = $('#' + id); if (el) el.hidden = !e.target.checked; }));
    bindToggle('cp-lim-uses', 'cp-max');
    bindToggle('cp-lim-pp', 'cp-pp');
    bindToggle('cp-exp', 'cp-days', 'cp-days-lbl');
    bindToggle('cp-rveh', 'cp-veh');
    bindToggle('cp-rcat', 'cp-cat');
}

async function renderCoupons(pane) {
    paneHeader('ui_coupons');
    const r = await post('mg_coupons', {});
    if (!MG.open || MG.tab !== 'coupons') return;
    if (!r.ok) { pane.innerHTML = emptyHtml('fa-triangle-exclamation'); return; }
    r.data = arr(r.data);
    let html = `<div class="mg-head-row">
        <span class="muted">${r.data.length} ${t('ui_coupons').toLowerCase()}</span>
        <button class="btn btn-primary btn-sm" id="cp-add"><i class="fa-solid fa-plus"></i> ${t('ui_new_coupon')}</button>
    </div>`;
    if (!r.data.length) html += emptyHtml('fa-ticket');
    else {
        html += `<table class="tbl"><thead><tr>
            <th>${t('ui_code')}</th><th>${t('ui_discount')}</th><th class="num">${t('ui_uses')}</th>
            <th>${t('ui_limits')}</th><th></th><th></th></tr></thead>
            <tbody>${r.data.map(c => `<tr>
                <td class="mono"><b>${c.code}</b></td>
                <td>${c.discount_type === 'percent' ? c.discount_value + '%' : fmtMoney(c.discount_value)}</td>
                <td class="num mono">${c.current_uses}${c.max_uses ? '/' + c.max_uses : ''}</td>
                <td>${couponBadges(c)}</td>
                <td><span class="badge ${c.active ? 'badge-green' : 'badge-red'}">${c.active ? t('ui_active') : t('ui_inactive')}</span></td>
                <td class="row-actions">
                    <button class="btn btn-ghost btn-sm tip" data-tgl="${c.id}" data-tip="${c.active ? t('ui_inactive') : t('ui_active')}"><i class="fa-solid fa-power-off"></i></button>
                    <button class="btn btn-danger btn-sm tip" data-del="${c.id}" data-tip="${t('ui_delete')}"><i class="fa-solid fa-trash"></i></button></td>
            </tr>`).join('')}</tbody></table>`;
    }
    pane.innerHTML = html;
    on($('#cp-add'), 'click', couponModal);
    $$('button[data-tgl]', pane).forEach(b => on(b, 'click', async () => {
        await post('mg_coupon_tgl', { id: Number(b.dataset.tgl) });
        renderMgPane();
    }));
    $$('button[data-del]', pane).forEach(b => on(b, 'click', async () => {
        await post('mg_coupon_del', { id: Number(b.dataset.del) });
        renderMgPane();
    }));
}

function renderSettings(pane) {
    paneHeader('ui_settings');
    const info = MG.data.info || {};
    const line = (label, value) =>
        `<div class="fin-line"><span>${label}</span><strong>${value}</strong></div>`;
    const yesNo = v => v
        ? `<span class="badge badge-green">${t('ui_active')}</span>`
        : `<span class="badge badge-red">${t('ui_inactive')}</span>`;

    const st = MG.data.settings || {};
    const fp = MG.data.financeParams || Runtime.finance;

    // stands are not bought or sold: ownership is a job or an admin assignment
    const saleCard = '';

    pane.innerHTML = `
        <div class="mg-section-card">
            <div class="chart-title">${t('ui_commission_rate')}</div>
            <div class="treasury">
                <input type="number" id="st-comm" min="0" max="${MG.data.maxCommission}" value="${MG.data.commission}">
                <button class="btn btn-primary" id="st-save">${t('ui_save')}</button>
            </div>
            <div class="tile-sub" style="margin-top:8px">${t('ui_commission_hint')}</div>
        </div>
        <div class="mg-section-card">
            <div class="chart-title">${t('ui_sale_settings')}</div>
            <div class="switch-stack">
                <div class="switch-row">
                    <label class="sw"><input type="checkbox" id="st-nopurchase" ${st.purchaseDisabled ? 'checked' : ''}><span class="sw-track"></span></label>
                    <span class="sw-label">${t('ui_disable_purchase')}</span>
                </div>
                <div class="switch-row">
                    <label class="sw"><input type="checkbox" id="st-nofinance" ${st.financeDisabled ? 'checked' : ''}><span class="sw-track"></span></label>
                    <span class="sw-label">${t('ui_disable_finance')}</span>
                </div>
            </div>
            <div class="form-grid">
                <div class="form-field"><label>${t('ui_apr')}</label>
                    <input type="number" id="st-apr" min="0" max="50" step="0.5" value="${Math.round((fp.apr || 0) * 1000) / 10}"></div>
                <div class="form-field"><label>${t('ui_down_min')}</label>
                    <input type="number" id="st-down" min="5" max="60" value="${Math.round((fp.downMin || .1) * 100)}"></div>
                <div class="form-field full"><label>${t('ui_terms_csv')}</label>
                    <input type="text" id="st-terms" value="${arr(fp.terms).join(', ')}" spellcheck="false"></div>
                <div class="form-field full">
                    <button class="btn btn-primary btn-block" id="st-save-settings">${t('ui_save')}</button></div>
            </div>
        </div>
        ${saleCard}
        <div class="mg-section-card">
            <div class="chart-title">${t('ui_business_info')}</div>
            ${MG.data.ownerName && !MG.data.isOwner ? line(t('ui_stand_owner'), esc(MG.data.ownerName)) : ''}
            ${line(t('ui_staff'), info.bossJob
                ? `<span class="badge badge-brand"><i class="fa-solid fa-briefcase"></i> ${info.bossJob}</span>`
                : t('ui_staff_internal'))}
            ${line(t('ui_wholesale'), Math.round((MG.data.wholesaleRate || 0) * 100) + '%')}
            ${line(t('ui_price_range'), Math.round((info.priceFloor || 0) * 100) + '% – ' + Math.round((info.priceCeil || 0) * 100) + '%')}
            ${line(t('ui_order_time'), (MG.data.orderMinutes || 0) + ' min')}
            ${line(t('ui_sellback'), (info.sellPercent || 0) + '%')}
            ${line(t('ui_test_drive'), yesNo(info.testDrive))}
            ${line(t('ui_finance_title'), yesNo(info.finance))}
            ${line(t('ui_category'), arr(info.categories).map(catLabel).join(' · '))}
        </div>`;

    on($('#st-save'), 'click', async () => {
        const r = await post('mg_commission', { commission: Number($('#st-comm').value) });
        if (!r.ok) return notifyErr(r.why);
        await refreshMg();
    });
    on($('#st-save-settings'), 'click', async () => {
        const terms = $('#st-terms').value.split(/[,;\s]+/).map(Number).filter(n => n >= 2 && n <= 48);
        const r = await post('mg_settings', {
            purchaseDisabled: $('#st-nopurchase').checked,
            financeDisabled: $('#st-nofinance').checked,
            apr: Number($('#st-apr').value),
            downMin: Number($('#st-down').value),
            terms,
        });
        if (!r.ok) return notifyErr(r.why);
        await refreshMg();
    });
}

function catalogModal(v) {
    const body = `
        <div class="form-grid" style="margin-top:0">
            <div class="form-field"><label>${t('ui_model')}</label>
                <input type="text" id="cv-model" value="${v ? v.model : ''}" ${v ? 'readonly' : ''} spellcheck="false"></div>
            <div class="form-field"><label>${t('ui_brand')}</label><input type="text" id="cv-brand" value="${v ? v.brand : ''}"></div>
            <div class="form-field"><label>${t('ui_name')}</label><input type="text" id="cv-name" value="${v ? v.name : ''}"></div>
            <div class="form-field"><label>${t('ui_category')}</label>
                <select id="cv-cat">${DOMAINS.map(dom => {
                    const list = arr(Runtime.categories).filter(c => (c.domain || 'land') === dom);
                    if (!list.length) return '';
                    return `<optgroup label="${domainLabel(dom)}">${list.map(c =>
                        `<option value="${c.key}" ${v && v.category === c.key ? 'selected' : ''}>${esc(c.label)}</option>`).join('')}</optgroup>`;
                }).join('')}</select></div>
            <div class="form-field full"><label>${t('ui_price')}</label><input type="number" id="cv-price" min="1" value="${v ? v.price : ''}"></div>
            <div class="form-field"><label>${t('ui_min_price')}</label>
                <input type="number" id="cv-min" min="0" placeholder="${t('ui_optional')}" value="${v && v.min_price ? v.min_price : ''}"></div>
            <div class="form-field"><label>${t('ui_max_price')}</label>
                <input type="number" id="cv-max" min="0" placeholder="${t('ui_optional')}" value="${v && v.max_price ? v.max_price : ''}"></div>
            <div class="form-field full"><div class="tile-sub">${t('ui_price_bounds_hint')}</div></div>
        </div>`;
    openDialog('catalog', t('ui_catalog'), v ? `${v.brand} ${v.name}` : t('ui_add_vehicle'), body, [
        [t('ui_cancel'), 'btn-ghost', () => closeDialog()],
        [t('ui_save'), 'btn-primary', async () => {
            const r = await post('ad_upsert', {
                model: $('#cv-model').value, brand: $('#cv-brand').value,
                name: $('#cv-name').value, category: $('#cv-cat').value,
                price: Number($('#cv-price').value),
                minPrice: Number($('#cv-min').value) || 0,
                maxPrice: Number($('#cv-max').value) || 0,
            });
            if (!r.ok) return notifyErr(r.why);
            closeDialog();
            if (MG.open) renderMgPane();
            if (ADM.open) refreshCatalogData();
        }],
    ], true);
}


on($('#mg-close'), 'click', () => post('ui_close'));
on($('#mg-close-2'), 'click', () => post('ui_close'));
on($('#mg-collapse'), 'click', () => {
    const collapsed = $('.mg-shell').classList.toggle('rail-collapsed');
    localStorage.setItem('apexdealer-rail', collapsed ? '1' : '0');
});

// ====================================================================
// Showcase placer help panel (no focus — the Lua side owns the keys)
// ====================================================================
function openPlacer(p) {
    closeManagementUI();
    $('#placer-title').textContent = (p.title || p.model || '').toUpperCase();
    $('#pk-rot').textContent = p.rotLabel || t('ui_placer_rotate');
    $('#pk-place').textContent = t('ui_placer_place');
    $('#pk-cancel').textContent = t('ui_cancel');
    $('#pk-hide').textContent = t('ui_placer_hide');
    // admin zone pickers have no H key — hide that hint
    $('#pk-hide').parentElement.style.display = p.title ? 'none' : '';
    $('#placer').hidden = false;
    $('.placer-panel').style.opacity = 1;
}

// ====================================================================
// My finance
// ====================================================================
function renderFinance(data) {
    const body = $('#fin-body');
    data.vehicles = arr(data.vehicles);
    if (!data.vehicles.length) {
        body.innerHTML = `<div class="empty">${t('ui_no_financed')}</div>
            <div class="fin-line dim"><span>${t('ui_bank_balance')}</span><span class="mono">${fmtMoney(data.bank)}</span></div>`;
        return;
    }
    body.innerHTML = data.vehicles.map(v => {
        const dueIn = Math.max(0, v.nextDue - Math.floor(Date.now() / 1000));
        const h = Math.floor(dueIn / 3600), m = Math.floor((dueIn % 3600) / 60);
        return `<div class="mg-section-card">
            <div style="display:flex;justify-content:space-between;align-items:center">
                <div><b>${v.brand} ${v.name}</b> <span class="badge badge-brand mono">${v.plate}</span></div>
                ${v.missed ? `<span class="badge badge-red">${t('ui_missed')}: ${v.missed}</span>` : ''}
            </div>
            <div class="fin-summary" style="margin-top:10px">
                <div class="fin-line"><span>${t('ui_remaining')}</span><span class="mono">${fmtMoney(v.owed)}</span></div>
                <div class="fin-line"><span>${t('ui_per_installment')}</span><span class="mono">${fmtMoney(v.payment)} × ${v.paymentsLeft}</span></div>
                <div class="fin-line dim"><span>${t('ui_next_due')}</span><span class="mono">${h}h ${m}m</span></div>
                <div class="fin-line dim"><span>${t('ui_payoff_value')}</span><span class="mono">${fmtMoney(v.payoff)}</span></div>
            </div>
            <div class="treasury">
                <button class="btn btn-ghost" data-pay="${v.plate}">${t('ui_pay_installment')} · ${fmtMoney(v.payment)}</button>
                <button class="btn btn-primary" data-payoff="${v.plate}">${t('ui_payoff')} · ${fmtMoney(v.payoff)}</button>
            </div></div>`;
    }).join('') + `<div class="fin-line dim" style="margin-top:10px"><span>${t('ui_bank_balance')}</span><span class="mono">${fmtMoney(data.bank)}</span></div>`;

    const pay = async (plate, full) => {
        const r = await post('fin_pay', { plate, full });
        if (!r.ok) return notifyErr(r.why);
        const r2 = await post('fin_refresh');
        if (r2.ok) renderFinance(r2.data);
    };
    $$('button[data-pay]', body).forEach(b => on(b, 'click', () => pay(b.dataset.pay, false)));
    $$('button[data-payoff]', body).forEach(b => on(b, 'click', () => pay(b.dataset.payoff, true)));
}

on($('#fin-close'), 'click', () => {
    $('#finance-overlay').hidden = true;
    post('ui_close');
});

// ====================================================================
// ADMIN PANEL (v2) — stands / listings / catalog / import
// ====================================================================
const ADM = {
    open: false, data: null, tab: 'stands',
    map: null, mapBuilt: false, markers: [],
    search: '', selected: null,
    draft: null, listingDraft: null, editorKind: null,
    picking: false,
    catSearch: '', catFilter: '',
    importSources: null, importResult: null, impUpdate: false,
    themeDraft: null, themePreview: false,
};

const esc = (s) => String(s == null ? '' : s)
    .replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));

const ADM_TABS = [
    ['stands',     'fa-shop',        'ui_adm_stands'],
    ['listings',   'fa-list-check',  'ui_adm_listings'],
    ['categories', 'fa-tags',        'ui_adm_categories'],
    ['catalog',    'fa-database',    'ui_catalog'],
    ['import',     'fa-file-import', 'ui_adm_import'],
    ['theme',      'fa-palette',     'ui_adm_theme'],
];

// the exact swatch palettes apex_bossmenu ships (brand + background).
// First background entry = the script default (Config.theme.bg).
const BRAND_SWATCHES = ['#1F5EFF', '#4E9CE5', '#34C77B', '#E5A93C', '#E5564B', '#A66DF0', '#F0B429', '#0BA5A4'];
const BG_SWATCHES    = ['#131314', '#0A0A0B', '#0F1218', '#101616', '#15110F', '#141019', '#0E1614', '#181613'];

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

function openAdmin(data) {
    ADM.open = true;
    ADM.themeDraft = null;
    ADM.themePreview = false;
    data.stands = arr(data.stands);
    data.listings = arr(data.listings);
    data.catalog = arr(data.catalog);
    data.jobs = arr(data.jobs);
    data.categories = arr(data.categories);
    ADM.data = data;
    $('#adm-count').textContent = `${data.stands.length} ${t('ui_adm_stands').toLowerCase()}`;
    $('#adm-fw').textContent = String(data.framework || '').toUpperCase();
    $('.adm-shell').classList.toggle('rail-collapsed', localStorage.getItem('apexdealer-rail') === '1');
    renderAdmNav();
    renderAdmPane();
    $('#admin').hidden = false;
}

function closeAdminUI() {
    ADM.open = false;
    ADM.picking = false;
    hideTooltip();
    revertThemePreview();
    ADM.themeDraft = null;
    closeEditor();
    destroyAdmMap();
    $('#admin').hidden = true;
}

function destroyAdmMap() {
    if (ADM.map) { try { ADM.map.remove(); } catch (_) {} }
    ADM.map = null; ADM.mapBuilt = false; ADM.markers = [];
}

async function refreshAdm() {
    const r = await post('adm_refresh', {});
    if (!r.ok || !r.data) return;
    const d = r.data;
    d.stands = arr(d.stands); d.listings = arr(d.listings);
    d.catalog = arr(d.catalog); d.jobs = arr(d.jobs); d.categories = arr(d.categories);
    ADM.data = d;
    $('#adm-count').textContent = `${d.stands.length} ${t('ui_adm_stands').toLowerCase()}`;
    renderAdmPane();
}

function applyStands(resData) {
    if (resData && resData.stands) ADM.data.stands = arr(resData.stands);
    $('#adm-count').textContent = `${ADM.data.stands.length} ${t('ui_adm_stands').toLowerCase()}`;
    renderAdmPane();
}

function renderAdmNav() {
    const nav = $('#adm-nav');
    nav.innerHTML = '';
    ADM_TABS.forEach(([key, icon, label]) => {
        const b = document.createElement('button');
        b.className = ADM.tab === key ? 'active' : '';
        b.innerHTML = `<i class="fa-solid ${icon}"></i><span>${t(label)}</span>`;
        on(b, 'click', () => { ADM.tab = key; renderAdmNav(); renderAdmPane(); });
        nav.appendChild(b);
    });
}

// an unsaved theme preview must never survive leaving the tab / closing the panel
function revertThemePreview() {
    if (!ADM.themePreview) return;
    ADM.themePreview = false;
    applyTheme(Runtime.theme);
}

function renderAdmPane() {
    const pane = $('#adm-pane');
    revertThemePreview();
    destroyAdmMap();
    pane.classList.toggle('pane-fill', ADM.tab === 'stands' || ADM.tab === 'theme' || ADM.tab === 'import');
    pane.innerHTML = '';
    const def = ADM_TABS.find(([k]) => k === ADM.tab);
    if (def) $('#adm-tab-ico').className = `fa-solid ${def[1]}`;
    $('#adm-title').textContent = t(def ? def[2] : 'ui_adm_stands');
    if (ADM.tab === 'stands') return renderAdmStands(pane);
    if (ADM.tab === 'listings') return renderAdmListings(pane);
    if (ADM.tab === 'categories') return renderAdmCategories(pane);
    if (ADM.tab === 'catalog') return renderAdmCatalog(pane);
    if (ADM.tab === 'import') return renderAdmImport(pane);
    if (ADM.tab === 'theme') return renderAdmTheme(pane);
}

// ── Categories: custom categories, grouped by domain ──
function renderAdmCategories(pane) {
    const cats = arr(ADM.data.categories);
    const counts = {};
    arr(ADM.data.catalog).forEach(v => { counts[v.category] = (counts[v.category] || 0) + 1; });
    const usedBy = (key) => ADM.data.stands.filter(s => {
        const dd = s.data && s.data.domains;
        if (dd) return DOMAINS.some(k => dd[k] && arr(dd[k].categories).includes(key));
        return arr(s.data && s.data.categories).includes(key);
    }).length;

    let html = `<div class="mg-head-row">
        <span class="muted">${cats.length} ${t('ui_adm_categories').toLowerCase()}</span>
        <button class="btn btn-primary btn-sm" id="cat-add"><i class="fa-solid fa-plus"></i> ${t('ui_adm_new_category')}</button>
    </div>
    <div class="tile-sub" style="margin-bottom:12px;max-width:760px">${t('ui_adm_categories_hint')}</div>`;

    // a domain with few categories takes half a row, so air + sea sit side by
    // side instead of leaving the page half empty. A leftover narrow card would
    // sit alone next to a gap, so it spans the full row instead.
    const domLists = DOMAINS.map(dom => ({ dom, list: cats.filter(c => (c.domain || 'land') === dom) }));
    const wide = domLists.map(x => x.list.length > 4);
    if (wide.filter(w => !w).length % 2 === 1) {
        for (let i = wide.length - 1; i >= 0; i--) { if (!wide[i]) { wide[i] = true; break; } }
    }

    html += '<div class="cat-domains">';
    domLists.forEach(({ dom, list }, di) => {
        html += `<div class="mg-section-card cat-dom${wide[di] ? ' cat-dom-wide' : ''}">
            <div class="chart-title"><i class="fa-solid ${DOMAIN_ICONS[dom]}"></i> ${domainLabel(dom)}
                <span class="muted" style="margin-left:auto;font-weight:500">${list.length}</span></div>
            ${list.length ? `<div class="cat-grid">${list.map(c => `
                <div class="cat-card">
                    <div class="cat-info">
                        <div class="cat-name">${esc(c.label)}</div>
                        <div class="cat-key mono">${esc(c.key)}</div>
                    </div>
                    <div class="cat-badges">
                        <span class="badge badge-brand">${counts[c.key] || 0} ${t('ui_adm_vehicles').toLowerCase()}</span>
                        ${usedBy(c.key) ? `<span class="badge badge-yellow">${usedBy(c.key)} ${t('ui_adm_stands').toLowerCase()}</span>` : ''}
                    </div>
                    <div class="cat-actions">
                        <button class="btn btn-ghost btn-sm tip" data-ced2="${esc(c.key)}" data-tip="${t('ui_edit')}"><i class="fa-solid fa-pen"></i></button>
                        <button class="btn btn-danger btn-sm tip" data-cdel2="${esc(c.key)}" data-tip="${t('ui_delete')}"><i class="fa-solid fa-trash"></i></button>
                    </div>
                </div>`).join('')}</div>` : emptyHtml('fa-tags')}
        </div>`;
    });
    html += '</div>';
    pane.innerHTML = html;

    on($('#cat-add'), 'click', () => categoryModal(null));
    $$('[data-ced2]', pane).forEach(b => on(b, 'click', () =>
        categoryModal(cats.find(c => c.key === b.dataset.ced2))));
    $$('[data-cdel2]', pane).forEach(b => on(b, 'click', () =>
        deleteCategoryDialog(cats.find(c => c.key === b.dataset.cdel2), counts[b.dataset.cdel2] || 0)));
}

function categoryModal(c) {
    const isNew = !c;
    const body = `
        <div class="form-grid" style="margin-top:0">
            <div class="form-field"><label>${t('ui_adm_cat_key')}</label>
                <input type="text" id="cc-key" value="${c ? esc(c.key) : ''}" ${c ? 'readonly' : ''} spellcheck="false" placeholder="supercars"></div>
            <div class="form-field"><label>${t('ui_name')}</label>
                <input type="text" id="cc-label" value="${c ? esc(c.label) : ''}" placeholder="Super Cars"></div>
            <div class="form-field full"><label>${t('ui_adm_domain')}</label>
                <div class="seg" id="cc-dom">
                    ${DOMAINS.map(k => `<button data-d="${k}" class="${(c ? (c.domain || 'land') : 'land') === k ? 'active' : ''}">
                        <i class="fa-solid ${DOMAIN_ICONS[k]}"></i> ${domainLabel(k)}</button>`).join('')}
                </div></div>
            <div class="form-field full"><label>${t('ui_adm_cat_sort')}</label>
                <input type="number" id="cc-sort" min="0" max="9999" value="${c ? c.sort : 500}"></div>
            <div class="form-field full"><div class="tile-sub">${t(isNew ? 'ui_adm_cat_hint' : 'ui_adm_cat_hint_edit')}</div></div>
        </div>`;
    let domain = c ? (c.domain || 'land') : 'land';
    openDialog('category', t('ui_adm_categories'), c ? c.label : t('ui_adm_new_category'), body, [
        [t('ui_cancel'), 'btn-ghost', () => closeDialog()],
        [t('ui_save'), 'btn-primary', async () => {
            const r = await post('adm_cat_save', {
                key: $('#cc-key').value, label: $('#cc-label').value,
                domain, sort: Number($('#cc-sort').value) || 500,
            });
            if (!r.ok) return notifyErr(r.why);
            closeDialog();
            ADM.data.categories = arr(r.data && r.data.categories);
            Runtime.categories = ADM.data.categories;
            renderAdmPane();
        }],
    ], true);
    $$('#cc-dom button').forEach(b => on(b, 'click', () => {
        domain = b.dataset.d;
        $$('#cc-dom button').forEach(x => x.classList.toggle('active', x === b));
    }));
}

function deleteCategoryDialog(c, count) {
    if (!c) return;
    const others = arr(ADM.data.categories).filter(x => x.key !== c.key && (x.domain || 'land') === (c.domain || 'land'));
    let moveTo = others[0] ? others[0].key : null;
    const body = count > 0
        ? `<div class="dlg-line">${t('ui_adm_cat_delete_used', count)}</div>
           ${others.length
                ? `<div class="form-field" style="margin-top:10px"><label>${t('ui_adm_cat_move')}</label>
                     <select id="cd-move">${others.map(o => `<option value="${esc(o.key)}">${esc(o.label)}</option>`).join('')}</select></div>`
                : `<div class="tile-sub" style="margin-top:8px">${t('ui_adm_cat_no_target')}</div>`}`
        : `<div class="dlg-line">${t('ui_adm_cat_delete', esc(c.label))}</div>`;
    openDialog('catdel', t('ui_adm_categories'), c.label, body, [
        [t('ui_cancel'), 'btn-ghost', () => closeDialog()],
        [t('ui_delete'), 'btn-danger', async () => {
            if (count > 0 && !others.length) return;
            const sel = $('#cd-move');
            const r = await post('adm_cat_del', { key: c.key, moveTo: count > 0 ? (sel ? sel.value : moveTo) : null });
            if (!r.ok) return notifyErr(r.why);
            closeDialog();
            ADM.data.categories = arr(r.data && r.data.categories);
            Runtime.categories = ADM.data.categories;
            await refreshCatalogData();
            refreshAdm();
        }],
    ]);
}

// ── Appearance: brand + background for EVERY player's UI ──
function renderAdmTheme(pane) {
    const cur = ADM.data.theme || Runtime.theme || {};
    const def = ADM.data.themeDefault || {};
    const d = ADM.themeDraft || { brand: cur.brand, bg: cur.bg };
    ADM.themeDraft = d;
    const eq = (a, b) => String(a).toUpperCase() === String(b).toUpperCase();
    const swatches = (list, key, sel) => list.map(c =>
        `<button class="color-preset ${eq(c, sel) ? 'active' : ''}" data-sw="${key}" data-c="${c}" style="background:${c}"></button>`).join('');

    pane.innerHTML = `
    <div class="adm-theme">
        <div class="adm-theme-left">
            <div class="mg-section-card">
                <div class="chart-title">${t('ui_adm_theme_colors')}</div>
                <div class="theme-row">
                    <label class="theme-pick">
                        <input type="color" id="th-brand" value="${d.brand}">
                        <div><div class="tp-name">${t('ui_adm_theme_brand')}</div>
                        <div class="tp-hex mono" id="th-brand-hex">${d.brand}</div></div>
                    </label>
                    <div class="color-presets">${swatches(BRAND_SWATCHES, 'brand', d.brand)}</div>
                </div>
                <div class="theme-row">
                    <label class="theme-pick">
                        <input type="color" id="th-bg" value="${d.bg}">
                        <div><div class="tp-name">${t('ui_adm_theme_bg')}</div>
                        <div class="tp-hex mono" id="th-bg-hex">${d.bg}</div></div>
                    </label>
                    <div class="color-presets">${swatches(BG_SWATCHES, 'bg', d.bg)}</div>
                </div>
                <div class="tile-sub" style="margin-top:4px">${t('ui_adm_theme_hint')}</div>
            </div>

            <div class="mg-section-card">
                <div class="chart-title">${t('ui_adm_theme_presets')}</div>
                <div class="theme-presets">
                    ${THEME_PRESETS.map((p, i) => `
                        <button class="theme-preset ${eq(p.brand, d.brand) && eq(p.bg, d.bg) ? 'active' : ''}" data-preset="${i}">
                            <span class="tpv" style="background:${p.bg}"><span style="background:${p.brand}"></span></span>
                            <span class="tpn">${p.name}</span>
                        </button>`).join('')}
                </div>
            </div>

            <div class="theme-actions">
                <button class="btn btn-ghost" id="th-reset"><i class="fa-solid fa-rotate-left"></i> ${t('ui_adm_theme_reset')}</button>
                <button class="btn btn-primary" id="th-save"><i class="fa-solid fa-floppy-disk"></i> ${t('ui_adm_theme_apply')}</button>
            </div>
        </div>

        <div class="mg-section-card adm-theme-right">
            <div class="chart-title">${t('ui_adm_theme_preview')}</div>
            <div class="theme-demo">
                <div class="theme-demo-rail">
                    <span class="td-mark"><i class="fa-solid fa-car"></i></span>
                    <span class="td-line active"></span><span class="td-line"></span>
                    <span class="td-line"></span><span class="td-line"></span>
                </div>
                <div class="theme-demo-body">
                    <div class="theme-demo-top">
                        <span class="td-chip"><i class="fa-solid fa-gauge-high"></i></span>
                        <div><div class="eyebrow">APEX DEALERSHIPS</div>
                        <div class="td-title">${t('ui_overview')}</div></div>
                        <span class="badge badge-brand" style="margin-left:auto">${t('ui_finance')}</span>
                        <span class="badge badge-green">${t('ui_active')}</span>
                    </div>
                    <div class="theme-demo-kpis">
                        <div class="kpi kpi-accent">
                            <div class="kpi-ic"><i class="fa-solid fa-vault"></i></div>
                            <div class="kpi-body"><div class="kpi-label">${t('ui_balance')}</div>
                            <div class="kpi-val mono">${fmtMoney(482500)}</div></div>
                        </div>
                        <div class="kpi">
                            <div class="kpi-ic"><i class="fa-solid fa-bolt"></i></div>
                            <div class="kpi-body"><div class="kpi-label">${t('ui_today')}</div>
                            <div class="kpi-val mono">${fmtMoney(96000)}</div></div>
                        </div>
                    </div>
                    <div class="theme-demo-bars">
                        ${[38, 62, 45, 88, 54, 71, 96].map(h =>
                            `<div class="cbar"><div class="cbar-fill" style="height:${h}%"></div></div>`).join('')}
                    </div>
                    <div class="theme-demo-row">
                        <span class="tdr-thumb"><i class="fa-solid fa-car-side"></i></span>
                        <div><div class="tdr-name">Pegassi Zentorno</div>
                        <div class="tdr-sub mono">zentorno · super</div></div>
                        <span class="mono tdr-price">${fmtMoney(870000)}</span>
                    </div>
                    <div class="theme-demo-btns">
                        <button class="btn btn-primary btn-sm"><i class="fa-solid fa-cart-shopping"></i> ${t('ui_buy')}</button>
                        <button class="btn btn-ghost btn-sm"><i class="fa-solid fa-stopwatch"></i> ${t('ui_test_drive')}</button>
                        <input type="text" class="td-input" value="${t('ui_search')}" readonly>
                    </div>
                </div>
            </div>
        </div>
    </div>`;

    const preview = () => {
        ADM.themePreview = true;
        applyTheme({ brand: d.brand, bg: d.bg });
    };
    const repaintSwatches = () => {
        $$('[data-sw]', pane).forEach(b => b.classList.toggle('active',
            eq(b.dataset.c, b.dataset.sw === 'brand' ? d.brand : d.bg)));
        $$('[data-preset]', pane).forEach(b => {
            const p = THEME_PRESETS[Number(b.dataset.preset)];
            b.classList.toggle('active', eq(p.brand, d.brand) && eq(p.bg, d.bg));
        });
    };
    const setColor = (key, hex) => {
        d[key] = hex.toUpperCase();
        $(key === 'brand' ? '#th-brand' : '#th-bg').value = d[key];
        $(key === 'brand' ? '#th-brand-hex' : '#th-bg-hex').textContent = d[key];
        preview();
        repaintSwatches();
    };
    on($('#th-brand'), 'input', e => setColor('brand', e.target.value));
    on($('#th-bg'), 'input', e => setColor('bg', e.target.value));
    $$('[data-sw]', pane).forEach(b => on(b, 'click', () => setColor(b.dataset.sw, b.dataset.c)));
    $$('[data-preset]', pane).forEach(b => on(b, 'click', () => {
        const p = THEME_PRESETS[Number(b.dataset.preset)];
        d.brand = p.brand; d.bg = p.bg;
        setColor('brand', p.brand);
        setColor('bg', p.bg);
    }));
    on($('#th-save'), 'click', async () => {
        const r = await post('adm_theme', { brand: d.brand, bg: d.bg });
        if (!r.ok) return notifyErr(r.why);
        ADM.themePreview = false;              // the server echo repaints everyone
        ADM.data.theme = r.data.theme;
        Notify({ type: 'success', message: t('n_theme_saved') });
    });
    on($('#th-reset'), 'click', async () => {
        const r = await post('adm_theme', { reset: true });
        if (!r.ok) return notifyErr(r.why);
        ADM.themePreview = false;
        ADM.data.theme = r.data.theme;
        ADM.themeDraft = { brand: r.data.theme.brand, bg: r.data.theme.bg };
        renderAdmTheme(pane);
        Notify({ type: 'success', message: t('n_theme_saved') });
    });
}

// ── Stands: list + live GTA map (same Leaflet setup as apex_bossmenu) ──
const ADM_MAP_TILE = 'https://www.gtamap.xyz/mapStyles/styleAtlas/{z}/{x}/{y}.jpg';
const ADM_CX = 117.3, ADM_CY = 172.8, ADM_SX = 0.02072, ADM_SY = 0.0205;

function ensureAdmMap() {
    if (ADM.mapBuilt) return ADM.map;
    const target = $('#adm-map');
    if (!target || typeof L === 'undefined') return null;
    const CRS = L.extend({}, L.CRS.Simple, {
        projection: L.Projection.LonLat,
        scale: z => Math.pow(2, z),
        zoom : s => Math.log(s) / Math.LN2,
        distance: (a, b) => {
            const dx = b.lng - a.lng, dy = b.lat - a.lat;
            return Math.sqrt(dx * dx + dy * dy);
        },
        transformation: new L.Transformation(ADM_SX, ADM_CX, -ADM_SY, ADM_CY),
        infinite: true,
    });
    const map = L.map('adm-map', {
        crs: CRS, minZoom: 2, maxZoom: 5, zoom: 3, center: [0, 0],
        zoomControl: true, preferCanvas: true, attributionControl: false,
        maxBounds: [[8000.0, -5500.0], [-8000.0, 5500.0]],
    });
    L.tileLayer(ADM_MAP_TILE, { minZoom: 2, maxZoom: 5, noWrap: true }).addTo(map);
    ADM.map = map;
    ADM.mapBuilt = true;
    setTimeout(() => { try { map.invalidateSize(); } catch (_) {} }, 100);
    return map;
}

// every showroom point of a stand: one per domain (legacy stands keep theirs
// at the top level)
function standPoints(s) {
    const d = s.data || {};
    const out = [];
    if (d.domains) {
        DOMAINS.forEach(k => {
            const b = d.domains[k];
            if (b && b.showroom) out.push({ domain: k, p: b.showroom });
        });
    } else if (d.showroom) {
        out.push({ domain: 'land', p: d.showroom });
    }
    return out;
}

function renderAdmMapMarkers() {
    const map = ensureAdmMap();
    if (!map) return;
    ADM.markers.forEach(m => map.removeLayer(m));
    ADM.markers = [];
    ADM.data.stands.forEach(s => {
        standPoints(s).forEach(({ domain, p }) => {
            const cls = s.enabled ? 'adm-pin' : 'adm-pin off';
            const ic = (DOMAIN_ICONS[domain] || 'fa-car');
            const icon = L.divIcon({ className: '', html: `<div class="${cls}"><i class="fa-solid ${ic}"></i></div>`,
                iconSize: [22, 22], iconAnchor: [11, 11] });
            const m = L.marker([p.y, p.x], { icon });
            m.bindPopup(`<b>${esc(s.label)}</b><br><span style="opacity:.6" class="mono">${esc(s.id)} · ${domainLabel(domain)}</span>`);
            m.on('click', () => selectStandCard(s.id));
            m.addTo(map);
            ADM.markers.push(m);
        });
    });
}

function selectStandCard(id) {
    ADM.selected = id;
    $$('.stand-card').forEach(c => c.classList.toggle('selected', c.dataset.stand === id));
    const el = $(`.stand-card[data-stand="${id}"]`);
    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

function standCardHtml(s) {
    const d = s.data || {};
    // v3 stands keep their vehicles per domain; legacy ones at the top level
    const blocks = d.domains
        ? DOMAINS.filter(k => d.domains[k]).map(k => ({ domain: k, blk: d.domains[k] }))
        : [{ domain: 'land', blk: { categories: d.categories, listing: d.listing } }];

    const badges = [
        s.enabled ? '' : `<span class="badge badge-red">${t('ui_inactive')}</span>`,
        d.type === 'owned'
            ? `<span class="badge badge-yellow">${t('ui_adm_owned')}</span>`
            : `<span class="badge badge-brand">${t('ui_adm_selfservice')}</span>`,
    ].join('');

    const src = blocks.map(({ domain, blk }) => {
        const listing = blk.listing ? ADM.data.listings.find(l => l.id === blk.listing) : null;
        const cats = arr(blk.categories);
        const what = listing
            ? `${esc(listing.name)} · ${listing.count}`
            : `${cats.slice(0, 3).map(catLabel).join(' · ')}${cats.length > 3 ? ' +' + (cats.length - 3) : ''}`;
        return `<span><i class="fa-solid ${DOMAIN_ICONS[domain]}"></i>${what}</span>`;
    }).join('');
    const stocked = (d.stockMode || (d.type === 'owned' ? 'stocked' : 'unlimited')) === 'stocked';
    return `<div class="stand-card ${s.enabled ? '' : 'disabled'} ${ADM.selected === s.id ? 'selected' : ''}" data-stand="${s.id}">
        <div class="stand-head">
            <span class="stand-ic"><i class="fa-solid fa-shop"></i></span>
            <div><div class="stand-name">${esc(s.label)}</div><div class="stand-id mono">${esc(s.id)}</div></div>
            <div class="stand-badges">${badges}</div>
        </div>
        <div class="stand-meta">
            ${src}
            <span><i class="fa-solid fa-boxes-stacked"></i>${t(stocked ? 'ui_adm_stocked' : 'ui_adm_unlimited')}</span>
            ${d.bossJob ? `<span><i class="fa-solid fa-briefcase"></i>${esc(d.bossJob)}</span>` : ''}
            ${s.ownerName ? `<span><i class="fa-solid fa-user-tie"></i>${esc(s.ownerName)}</span>` : ''}
            ${d.type === 'owned' ? `<span><i class="fa-solid fa-vault"></i><span class="mono">${fmtMoney(s.balance)}</span></span>` : ''}
        </div>
        <div class="stand-actions">
            <button class="btn btn-ghost btn-sm tip" data-ed="${s.id}" data-tip="${t('ui_edit')}"><i class="fa-solid fa-pen"></i></button>
            <button class="btn btn-ghost btn-sm tip" data-loc="${s.id}" data-tip="${t('ui_adm_locate')}"><i class="fa-solid fa-location-crosshairs"></i></button>
            ${stocked ? `<button class="btn btn-ghost btn-sm tip" data-stock="${s.id}" data-tip="${t('ui_stock')}"><i class="fa-solid fa-boxes-stacked"></i></button>` : ''}
            <button class="btn btn-ghost btn-sm tip" data-show="${s.id}" data-tip="${t('ui_showcase')}"><i class="fa-solid fa-car-side"></i></button>
            <button class="btn btn-ghost btn-sm tip" data-dup="${s.id}" data-tip="${t('ui_adm_duplicate')}"><i class="fa-solid fa-copy"></i></button>
            ${d.type === 'owned' ? `
            <button class="btn btn-ghost btn-sm tip" data-owner="${s.id}" data-tip="${t('ui_adm_owner')}"><i class="fa-solid fa-user-gear"></i></button>` : ''}
            <span class="spacer"></span>
            <button class="btn btn-ghost btn-sm tip" data-tgl="${s.id}" data-tip="${t(s.enabled ? 'ui_adm_disable' : 'ui_adm_enable')}"><i class="fa-solid fa-power-off"></i></button>
            <button class="btn btn-danger btn-sm tip" data-del="${s.id}" data-tip="${t('ui_delete')}"><i class="fa-solid fa-trash"></i></button>
        </div>
    </div>`;
}

function renderAdmStands(pane) {
    const q = ADM.search.toLowerCase();
    const stands = ADM.data.stands.filter(s => !q || s.label.toLowerCase().includes(q) || s.id.includes(q));
    pane.innerHTML = `
    <div class="adm-stands">
        <div class="adm-stands-left">
            <div class="mg-head-row">
                <span class="muted">${ADM.data.stands.length} ${t('ui_adm_stands').toLowerCase()}</span>
                <button class="btn btn-primary btn-sm" id="st-new"><i class="fa-solid fa-plus"></i> ${t('ui_adm_new_stand')}</button>
            </div>
            <div class="search-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="st-search" placeholder="${t('ui_adm_search_stands')}" value="${esc(ADM.search)}">
            </div>
            <div class="stand-list" id="stand-list">
                ${stands.length ? stands.map(standCardHtml).join('') : emptyHtml('fa-shop')}
            </div>
        </div>
        <div class="adm-map-wrap"><div id="adm-map"></div></div>
    </div>`;
    renderAdmMapMarkers();

    on($('#st-new'), 'click', () => openStandEditor(null));
    on($('#st-search'), 'input', e => {
        ADM.search = e.target.value;
        const list = $('#stand-list');
        const qq = ADM.search.toLowerCase();
        const rows = ADM.data.stands.filter(s => !qq || s.label.toLowerCase().includes(qq) || s.id.includes(qq));
        list.innerHTML = rows.length ? rows.map(standCardHtml).join('') : emptyHtml('fa-shop');
        wireStandCards();
    });
    wireStandCards();
}

function standById(id) { return ADM.data.stands.find(s => s.id === id); }

function wireStandCards() {
    const root = $('#stand-list');
    if (!root) return;
    $$('.stand-card', root).forEach(c => on(c, 'click', () => selectStandCard(c.dataset.stand)));
    $$('[data-ed]', root).forEach(b => on(b, 'click', e => { e.stopPropagation(); openStandEditor(standById(b.dataset.ed)); }));
    $$('[data-loc]', root).forEach(b => on(b, 'click', e => {
        e.stopPropagation();
        const s = standById(b.dataset.loc);
        const first = s ? standPoints(s)[0] : null;
        const map = ensureAdmMap();
        if (first && map) map.setView([first.p.y, first.p.x], 5, { animate: true });
        selectStandCard(b.dataset.loc);
    }));
    $$('[data-dup]', root).forEach(b => on(b, 'click', async e => {
        e.stopPropagation();
        const r = await post('adm_dup_stand', { id: b.dataset.dup });
        if (!r.ok) return notifyErr(r.why);
        applyStands(r.data);
    }));
    $$('[data-tgl]', root).forEach(b => on(b, 'click', async e => {
        e.stopPropagation();
        const r = await post('adm_toggle_stand', { id: b.dataset.tgl });
        if (!r.ok) return notifyErr(r.why);
        applyStands(r.data);
    }));
    $$('[data-del]', root).forEach(b => on(b, 'click', e => {
        e.stopPropagation();
        const s = standById(b.dataset.del);
        if (!s) return;
        openDialog('deletestand', s.label, t('ui_delete'),
            `<div class="dlg-line">${t('ui_adm_delete_confirm', esc(s.label))}</div>`, [
            [t('ui_cancel'), 'btn-ghost', () => closeDialog()],
            [t('ui_delete'), 'btn-danger', async () => {
                const r = await post('adm_del_stand', { id: s.id });
                if (!r.ok) return notifyErr(r.why);
                closeDialog();
                applyStands(r.data);
            }],
        ]);
    }));
    $$('[data-owner]', root).forEach(b => on(b, 'click', e => { e.stopPropagation(); ownerDialog(standById(b.dataset.owner)); }));
    $$('[data-show]', root).forEach(b => on(b, 'click', e => { e.stopPropagation(); admShowcaseModal(standById(b.dataset.show)); }));
    $$('[data-stock]', root).forEach(b => on(b, 'click', e => { e.stopPropagation(); admStockModal(standById(b.dataset.stock)); }));
}

// Stock of a stand — moved out of the manager panel: stock (like the catalog)
// is a server-admin thing, the manager only ORDERS it.
async function admStockModal(s) {
    if (!s) return;
    const r = await post('adm_stock_list', { id: s.id });
    if (!r.ok) return notifyErr(r.why);
    const rows = arr(r.data && r.data.rows);
    let search = '';
    let bulkMode = 'set';

    const body = `
        <div class="search-wrap" style="margin-bottom:8px">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" id="st-search" placeholder="${t('ui_search')}">
        </div>
        <div class="st-bulk">
            <div class="seg seg-sm" id="st-bulk-mode">
                <button data-bmode="set" class="active">${t('ui_adm_stock_set')}</button>
                <button data-bmode="add">${t('ui_adm_stock_add')}</button>
                <button data-bmode="remove">${t('ui_adm_stock_remove')}</button>
                <button data-bmode="random">${t('ui_adm_stock_random')}</button>
            </div>
            <input type="number" id="st-bulk-amt" class="mono" min="0" max="9999" value="5">
            <button class="btn btn-primary btn-sm" id="st-bulk-go">
                <i class="fa-solid fa-layer-group"></i> <span id="st-bulk-lbl"></span></button>
        </div>
        <div class="tile-sub" id="st-bulk-note" style="margin-bottom:8px;color:var(--brand-300)"></div>
        <div class="tile-sub" style="margin-bottom:8px">${t('ui_adm_stock_hint')}</div>
        <div class="veh-pick-list" id="st-rows"></div>`;

    openDialog('admstock', s.label, t('ui_stock'), body, [
        [t('ui_close'), 'btn-ghost', () => closeDialog()],
    ], true);

    // the bulk action always applies to what is on screen: no filter = every
    // vehicle the stand sells, a filter = only the matches
    const filtered = () => {
        const q = search.toLowerCase();
        return rows.filter(v => !q
            || v.name.toLowerCase().includes(q)
            || v.model.includes(q)
            || String(v.brand || '').toLowerCase().includes(q));
    };

    const paintBulk = () => {
        $('#st-bulk-lbl').textContent = t('ui_adm_stock_apply_all', filtered().length);
    };

    $$('#st-bulk-mode [data-bmode]').forEach(b => on(b, 'click', () => {
        bulkMode = b.dataset.bmode;
        $$('#st-bulk-mode [data-bmode]').forEach(x => x.classList.toggle('active', x === b));
        $('#st-bulk-note').textContent = bulkMode === 'random' ? t('ui_adm_stock_random_hint') : '';
    }));

    on($('#st-bulk-go'), 'click', async () => {
        const list = filtered();
        if (!list.length) return;
        const amount = Math.max(0, Math.min(9999, Number($('#st-bulk-amt').value) || 0));
        const res = await post('adm_stock_bulk', {
            id: s.id, mode: bulkMode, amount,
            models: list.map(v => v.model),
        });
        if (!res.ok) return notifyErr(res.why);
        // the server owns the result (random rolls happen there)
        const stocks = (res.data && res.data.stocks) || {};
        list.forEach(v => { if (stocks[v.model] !== undefined) v.stock = stocks[v.model]; });
        paint();
        const zeros = list.filter(v => !v.stock).length;
        Notify({
            type: 'success',
            message: bulkMode === 'random'
                ? t('ui_adm_stock_bulk_random_done', list.length, zeros)
                : t('ui_adm_stock_bulk_done', list.length),
        });
    });

    const paint = () => {
        const list = filtered();
        paintBulk();
        $('#st-rows').innerHTML = list.length ? list.map(v => `
            <div class="dl-order" data-strow="${v.model}">
                ${vehThumb(v, 'thumb-sm')}
                <div class="dl-order-info">
                    <div class="tbl-veh-name">${esc(v.brand || '')} ${esc(v.name)}</div>
                    <div class="tbl-veh-sub mono">${v.model} · ${catLabel(v.category)} · ${fmtMoney(v.price)}</div>
                </div>
                <div class="dl-qty">
                    <input type="number" class="st-val mono" min="0" max="9999" value="${v.stock}">
                    <button class="btn btn-primary btn-sm st-save tip" data-tip="${t('ui_save')}"><i class="fa-solid fa-check"></i></button>
                </div>
            </div>`).join('') : emptyHtml('fa-car');

        $$('#st-rows [data-strow]').forEach(row => {
            const model = row.dataset.strow;
            on($('.st-save', row), 'click', async () => {
                const stock = Math.max(0, Math.min(9999, Number($('.st-val', row).value) || 0));
                const res = await post('adm_setstock', { dealership: s.id, model, stock });
                if (!res.ok) return notifyErr(res.why);
                const hit = rows.find(x => x.model === model);
                if (hit) hit.stock = stock;
                Notify({ type: 'success', message: `${t('ui_stock')}: ${model} = ${stock}` });
            });
        });
    };

    on($('#st-search'), 'input', e => { search = e.target.value; paint(); });
    paint();
}

// Showcase vehicles for ANY stand (self-service ones have no manager panel, so
// this is the only way to dress their floor)
async function admShowcaseModal(s) {
    if (!s) return;
    const r = await post('adm_showcase_list', { dealership: s.id });
    const placed = arr(r.ok && r.data).filter(x => x.dealership === s.id);

    // what this stand sells (the placer refuses anything else)
    const d = s.data || {};
    const keys = new Set();
    const blocks = d.domains ? DOMAINS.filter(k => d.domains[k]).map(k => d.domains[k]) : [d];
    blocks.forEach(b => {
        if (b.listing) {
            const l = ADM.data.listings.find(x => x.id === b.listing);
            arr(l && l.vehicles).forEach(m => keys.add(m));
        } else {
            arr(b.categories).forEach(c => {
                ADM.data.catalog.filter(v => v.category === c).forEach(v => keys.add(v.model));
            });
        }
    });
    const sellable = ADM.data.catalog.filter(v => keys.has(v.model));

    let search = '';
    const body = `
        <div class="sec-title">${t('ui_showcase')} · ${placed.length}</div>
        <div id="sc-placed">${placed.length ? '' : emptyHtml('fa-car-side')}</div>
        <div class="sec-title" style="margin-top:12px">${t('ui_place_here')}</div>
        <div class="search-wrap" style="margin-bottom:8px">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" id="sc-search" placeholder="${t('ui_search')}">
        </div>
        <div class="veh-pick-list" id="sc-pick"></div>`;

    openDialog('admshowcase', s.label, t('ui_showcase'), body, [
        [t('ui_close'), 'btn-ghost', () => closeDialog()],
    ], true);

    const paintPlaced = () => {
        const root = $('#sc-placed');
        if (!placed.length) { root.innerHTML = emptyHtml('fa-car-side'); return; }
        root.innerHTML = `<div class="recent-list">${placed.map(x => {
            const v = ADM.data.catalog.find(c => c.model === x.model) || { model: x.model, name: x.model };
            return `<div class="recent-item">
                ${vehThumb(v, 'thumb-sm')}
                <div class="recent-info">
                    <div class="recent-name">${esc(v.brand || '')} ${esc(v.name)}</div>
                    <div class="recent-sub mono">${esc(x.model)}</div>
                </div>
                <button class="btn btn-danger btn-sm tip" data-scdel="${x.id}" data-tip="${t('ui_delete')}"><i class="fa-solid fa-trash"></i></button>
            </div>`;
        }).join('')}</div>`;
        $$('#sc-placed [data-scdel]').forEach(b => on(b, 'click', async () => {
            const r2 = await post('adm_showcase_del', { id: Number(b.dataset.scdel), dealership: s.id });
            if (!r2.ok) return notifyErr(r2.why);
            const i = placed.findIndex(x => x.id === Number(b.dataset.scdel));
            if (i >= 0) placed.splice(i, 1);
            paintPlaced();
        }));
    };

    const paintPick = () => {
        const q = search.toLowerCase();
        const list = sellable.filter(v => !q
            || v.name.toLowerCase().includes(q)
            || v.model.includes(q)
            || String(v.brand || '').toLowerCase().includes(q));
        $('#sc-pick').innerHTML = list.length ? list.slice(0, 300).map(v => `
            <div class="veh-pick-row sc-row" data-scadd="${v.model}">
                ${vehThumb(v, 'thumb-sm')}
                <span class="vp-name">
                    <span class="tbl-veh-name">${esc(v.brand || '')} ${esc(v.name)}</span>
                    <span class="tbl-veh-sub mono">${v.model}</span>
                </span>
                <span class="badge badge-brand">${catLabel(v.category)}</span>
                <span class="sc-add"><i class="fa-solid fa-plus"></i></span>
            </div>`).join('') : emptyHtml('fa-car');
        $$('#sc-pick [data-scadd]').forEach(row => on(row, 'click', () => {
            const model = row.dataset.scadd;
            closeDialog();
            // the placer closes the admin panel and hands the player the ghost
            post('mg_showcase_place', {
                model, dealership: s.id, domain: catDomain((sellable.find(v => v.model === model) || {}).category),
            });
        }));
    };

    on($('#sc-search'), 'input', e => { search = e.target.value; paintPick(); });
    paintPlaced();
    paintPick();
}

async function ownerDialog(s) {
    if (!s) return;
    const r = await post('mg_nearby', {});
    const players = arr(r.ok && r.data);
    const body = `
        ${s.ownerName
            ? `<div class="fin-line"><span>${t('ui_stand_owner')}</span><strong>${esc(s.ownerName)}</strong></div>`
            : `<div class="dlg-line">${t('ui_adm_no_owner')}</div>`}
        <div class="sec-title">${t('ui_adm_assign_owner')}</div>
        ${players.length
            ? `<div class="cust-list">${players.map(p =>
                `<button class="cust-item" data-own="${p.id}"><i class="fa-solid fa-user"></i> ${esc(p.name)} <span class="cid mono">#${p.id}</span></button>`).join('')}</div>`
            : emptyHtml('fa-user-slash', 'ui_no_customers')}`;
    const buttons = [];
    if (s.ownerName) buttons.push([t('ui_adm_clear_owner'), 'btn-danger', async () => {
        const r2 = await post('adm_set_owner', { id: s.id });
        if (!r2.ok) return notifyErr(r2.why);
        closeDialog();
        applyStands(r2.data);
    }]);
    buttons.push([t('ui_close'), 'btn-ghost', () => closeDialog()]);
    openDialog('admowner', s.label, t('ui_adm_owner'), body, buttons, true);
    $$('#dlg-body [data-own]').forEach(b => on(b, 'click', async () => {
        const r2 = await post('adm_set_owner', { id: s.id, targetId: Number(b.dataset.own) });
        if (!r2.ok) return notifyErr(r2.why);
        closeDialog();
        applyStands(r2.data);
    }));
}


// ── Stand editor ──
function gradesToThresholds(gr) {
    const out = { Sales: null, Supervisor: null, Manager: null };
    if (gr) Object.keys(gr).forEach(g => {
        const role = gr[g], n = Number(g);
        if (out[role] === null || out[role] === undefined || n < out[role]) out[role] = n;
    });
    if (out.Sales == null && out.Supervisor == null && out.Manager == null) {
        out.Sales = 0; out.Supervisor = 1; out.Manager = 2;
    }
    return out;
}

function thresholdsToGrades(th) {
    const out = {};
    ['Sales', 'Supervisor', 'Manager'].forEach(r => {
        if (th[r] !== null && th[r] !== undefined && th[r] !== '') out[String(th[r])] = r;
    });
    return out;
}

const DOMAINS = ['land', 'air', 'sea'];

function emptyDomainBlock() {
    return {
        enabled: false, useListing: false, listing: null, categories: [],
        showroom: null, preview: null, testDriveSpawn: null, deliverySpawns: [],
    };
}

function standDraftFrom(s) {
    const d = s ? (s.data || {}) : {};
    const blip = d.blip || {};

    // v3: per-domain blocks. Legacy stands keep everything at the top level —
    // migrate that into the land block so old stands open correctly.
    const domains = {};
    DOMAINS.forEach(k => { domains[k] = emptyDomainBlock(); });
    if (d.domains && typeof d.domains === 'object') {
        DOMAINS.forEach(k => {
            const b = d.domains[k];
            if (!b) return;
            domains[k] = {
                enabled: b.enabled !== false,
                useListing: !!b.listing,
                listing: b.listing || null,
                categories: arr(b.categories).slice(),
                showroom: b.showroom || null,
                preview: b.preview || null,
                testDriveSpawn: b.testDriveSpawn || null,
                deliverySpawns: arr(b.deliverySpawns).slice(),
            };
        });
    } else if (s) {
        domains.land = {
            enabled: true,
            useListing: !!d.listing,
            listing: d.listing || null,
            categories: arr(d.categories).slice(),
            showroom: d.showroom || null,
            preview: d.preview || null,
            testDriveSpawn: d.testDriveSpawn || null,
            deliverySpawns: arr(d.deliverySpawns).slice(),
        };
    } else {
        domains.land.enabled = true;      // a new stand starts as a car dealer
    }

    return {
        id: s ? s.id : '',
        label: s ? s.label : '',
        type: d.type === 'owned' ? 'owned' : 'self-service',
        stockMode: d.stockMode === 'stocked' ? 'stocked' : 'unlimited',
        domains,
        tab: DOMAINS.find(k => domains[k].enabled) || 'land',
        bossJob: d.bossJob || '',
        gradeRoles: gradesToThresholds(d.gradeRoles),
        jobWhitelist: arr(d.jobWhitelist).slice(),
        societyJobs: arr(d.societyJobs).slice(),
        management: d.management || null,
        sellPoint: d.sellPoint || null,
        bossPoint: d.bossPoint || null,
        stockPoint: d.stockPoint || null,
        ped: d.ped ? { model: d.ped.model || '', coords: d.ped.coords || null } : { model: '', coords: null },
        blip: {
            enabled: s ? blip.enabled !== false && blip.enabled !== undefined : true,
            sprite: blip.sprite || 326, color: (blip.color === 0 ? 0 : blip.color) || 38,
            scale: blip.scale || 0.7, label: blip.label || '',
        },
        enableTestDrive: d.enableTestDrive !== false,
        enableFinance: d.enableFinance !== false,
        enableSell: d.enableSell !== false,
        sellPercent: d.sellPercent || 60,
    };
}

function openStandEditor(s) {
    ADM.editorKind = 'stand';
    ADM.draft = standDraftFrom(s);
    $('#editor-overlay').hidden = false;
    renderStandEditor();
}

function closeEditor() {
    ADM.editorKind = null;
    ADM.draft = null;
    ADM.listingDraft = null;
    $('#editor-overlay').hidden = true;
}

function fmtPointState(v) {
    if (!v) return t('ui_adm_not_set');
    let s = `${v.x.toFixed(1)}, ${v.y.toFixed(1)}, ${v.z.toFixed(1)}`;
    if (v.w !== null && v.w !== undefined) s += ` · ${Math.round(v.w)}°`;
    if (v.r) s += ` · r${Number(v.r).toFixed(1)}`;
    return s;
}

function zoneRowHtml(slot, icon, labelKey, mode, required, value) {
    return `<div class="zone-row ${value ? 'set' : ''}">
        <span class="zr-ic"><i class="fa-solid ${icon}"></i></span>
        <div><div class="zr-label">${t(labelKey)}${required ? '<span class="zone-req">*</span>' : ''}</div>
        <div class="zr-state ${value ? 'mono' : ''}">${fmtPointState(value)}</div></div>
        <div class="zr-actions">
            <button class="btn btn-ghost btn-sm" data-pick="${slot}" data-mode="${mode}"><i class="fa-solid fa-location-crosshairs"></i> ${t('ui_adm_pick_world')}</button>
            <button class="btn btn-ghost btn-sm" data-mypos="${slot}"><i class="fa-solid fa-person"></i> ${t('ui_adm_my_position')}</button>
        </div>
    </div>`;
}

// slots are addressed as "domain.field" (e.g. "air.preview") or a plain field
// for the stand-wide ones (management, sellPoint, bossPoint, ped)
function slotRef(slot) {
    const d = ADM.draft;
    const dot = slot.indexOf('.');
    if (dot < 0) return { obj: d, key: slot };
    return { obj: d.domains[slot.slice(0, dot)], key: slot.slice(dot + 1) };
}

function slotValue(slot) {
    const { obj, key } = slotRef(slot);
    if (!obj) return null;
    if (key === 'ped') return obj.ped && obj.ped.coords;
    return obj[key];
}

// a fitting ghost model for the picker: the first vehicle this block sells
function pickerModel(domain) {
    const d = ADM.draft;
    const blk = d.domains[domain] || {};
    if (blk.useListing && blk.listing) {
        const l = ADM.data.listings.find(x => x.id === blk.listing);
        if (l && l.vehicles && l.vehicles[0]) return l.vehicles[0];
    }
    const hit = ADM.data.catalog.find(v => arr(blk.categories).includes(v.category));
    if (hit) return hit.model;
    return domain === 'air' ? 'frogger' : domain === 'sea' ? 'dinghy' : 'adder';
}

function startPick(slot, mode) {
    ADM.picking = true;
    $('#admin').hidden = true;
    $('#editor-overlay').hidden = true;
    const dot = slot.indexOf('.');
    const domain = dot > 0 ? slot.slice(0, dot) : 'land';
    const cur = slotValue(slot);
    post('adm_pick', {
        slot, mode,
        model: mode === 'vehicle' ? pickerModel(domain) : null,
        radius: (cur && cur.r) || null,
        title: t('ui_adm_pick_title'),
    });
}

function admPickResult(p) {
    if (!ADM.picking) return;
    ADM.picking = false;
    if (ADM.open) $('#admin').hidden = false;
    if (ADM.editorKind) $('#editor-overlay').hidden = false;
    if (p && p.result && p.slot && ADM.draft) applyPick(p.slot, p.result);
    if (ADM.editorKind === 'stand') renderStandEditor();
}

function applyPick(slot, res) {
    const { obj, key } = slotRef(slot);
    if (!obj) return;
    if (key === 'delivery+') obj.deliverySpawns.push(res);
    else if (key === 'ped') obj.ped.coords = res;
    else obj[key] = res;
}

// default radius per point slot (only points have a radius; spots have a heading)
const POINT_SLOTS = { showroom: 3.0, management: 2.5, sellPoint: 5.0, bossPoint: 2.0 };

async function myPos(slot) {
    const r = await post('adm_mypos', {});
    if (!r.ok || !r.data) return;
    const pos = r.data;
    const key = slot.indexOf('.') > 0 ? slot.slice(slot.indexOf('.') + 1) : slot;
    if (POINT_SLOTS[key] !== undefined) {
        const cur = slotValue(slot);
        applyPick(slot, { x: pos.x, y: pos.y, z: pos.z, r: (cur && cur.r) || POINT_SLOTS[key] });
    } else {
        applyPick(slot, { x: pos.x, y: pos.y, z: pos.z, w: pos.w });
    }
    renderStandEditor();
}

function renderStandEditor() {
    const d = ADM.draft;
    if (!d) return;
    const owned = d.type === 'owned';
    $('#ed-eyebrow').textContent = t('ui_adm_stands').toUpperCase();
    $('#ed-title').textContent = d.id ? (d.label || d.id) : t('ui_adm_new_stand');

    const dom = d.tab;
    const blk = d.domains[dom];
    const catChips = ADM.data.categories.filter(c => (c.domain || 'land') === dom).map(c =>
        `<button class="chip ${arr(blk.categories).includes(c.key) ? 'active' : ''}" data-cat="${c.key}">${esc(c.label)}</button>`).join('');
    const listingOpts = `<option value="">—</option>` + ADM.data.listings.map(l =>
        `<option value="${l.id}" ${blk.listing === l.id ? 'selected' : ''}>${esc(l.name)} (${l.count})</option>`).join('');
    const jobOpts = `<option value="">${t('ui_adm_no_job')}</option>` + ADM.data.jobs.map(j =>
        `<option value="${esc(j.name)}" ${d.bossJob === j.name ? 'selected' : ''}>${esc(j.label)} (${esc(j.name)})</option>`).join('');
    const job = ADM.data.jobs.find(j => j.name === d.bossJob);
    const gradeOpts = (sel) => `<option value="">—</option>` + arr(job && job.grades).map(g =>
        `<option value="${g.grade}" ${String(sel) === String(g.grade) ? 'selected' : ''}>${g.grade} · ${esc(g.label)}</option>`).join('');
    const jobChips = (list, key) => ADM.data.jobs.map(j =>
        `<button class="chip ${list.includes(j.name) ? 'active' : ''}" data-jl="${key}" data-job="${esc(j.name)}">${esc(j.name)}</button>`).join('');

    const zones = `
        ${zoneRowHtml(dom + '.showroom', 'fa-door-open', 'ui_zone_showroom', 'point', true, blk.showroom)}
        ${zoneRowHtml(dom + '.preview', 'fa-camera', 'ui_zone_preview', 'vehicle', true, blk.preview)}
        ${d.enableTestDrive ? zoneRowHtml(dom + '.testDriveSpawn', 'fa-stopwatch', 'ui_zone_testdrive', 'vehicle', true, blk.testDriveSpawn) : ''}
        <div class="ed-sec-title" style="margin-top:12px"><i class="fa-solid fa-truck-ramp-box"></i> ${t('ui_zone_delivery')}<span class="zone-req">*</span><span class="hint">${t('ui_zone_delivery_hint')}</span></div>
        ${arr(blk.deliverySpawns).map((s, i) => `
        <div class="zone-row set">
            <span class="zr-ic"><i class="fa-solid fa-square-parking"></i></span>
            <div><div class="zr-label">${t('ui_zone_bay')} ${i + 1}</div>
            <div class="zr-state mono">${fmtPointState(s)}</div></div>
            <div class="zr-actions"><button class="btn btn-danger btn-sm" data-delspawn="${i}"><i class="fa-solid fa-trash"></i></button></div>
        </div>`).join('')}
        <div class="zone-row">
            <span class="zr-ic"><i class="fa-solid fa-plus"></i></span>
            <div><div class="zr-label">${t('ui_zone_add_bay')}</div></div>
            <div class="zr-actions">
                <button class="btn btn-ghost btn-sm" data-pick="${dom}.delivery+" data-mode="vehicle"><i class="fa-solid fa-location-crosshairs"></i> ${t('ui_adm_pick_world')}</button>
                <button class="btn btn-ghost btn-sm" data-mypos="${dom}.delivery+"><i class="fa-solid fa-person"></i> ${t('ui_adm_my_position')}</button>
            </div>
        </div>`;

    const standZones = `
        ${owned ? zoneRowHtml('management', 'fa-briefcase', 'ui_zone_management', 'point', true, d.management) : ''}
        ${d.enableSell ? zoneRowHtml('sellPoint', 'fa-money-bill-wave', 'ui_zone_sell', 'point', true, d.sellPoint) : ''}
        ${owned ? zoneRowHtml('bossPoint', 'fa-crown', 'ui_zone_boss', 'point', false, d.bossPoint) : ''}
        ${d.stockMode === 'stocked'
            ? zoneRowHtml('stockPoint', 'fa-truck-ramp-box', 'ui_zone_stock', 'vehicle', true, d.stockPoint)
              + `<div class="tile-sub">${t('ui_zone_stock_hint')}</div>`
            : ''}`;

    $('#ed-body').innerHTML = `
        <div class="ed-section">
            <div class="ed-sec-title"><i class="fa-solid fa-shop"></i> ${t('ui_adm_identity')}</div>
            <div class="form-grid" style="margin-top:0">
                <div class="form-field full"><label>${t('ui_name')}</label>
                    <input type="text" id="se-label" value="${esc(d.label)}" maxlength="60"></div>
                <div class="form-field"><label>${t('ui_type')}</label>
                    <div class="seg">
                        <button data-seg="type" data-val="self-service" class="${!owned ? 'active' : ''}">${t('ui_adm_selfservice')}</button>
                        <button data-seg="type" data-val="owned" class="${owned ? 'active' : ''}">${t('ui_adm_owned')}</button>
                    </div></div>
                <div class="form-field"><label>${t('ui_stock')}</label>
                    <div class="seg">
                        <button data-seg="stockMode" data-val="unlimited" class="${d.stockMode !== 'stocked' ? 'active' : ''}">${t('ui_adm_unlimited')}</button>
                        <button data-seg="stockMode" data-val="stocked" class="${d.stockMode === 'stocked' ? 'active' : ''}">${t('ui_adm_stocked')}</button>
                    </div></div>
            </div>
        </div>

        <div class="ed-section">
            <div class="ed-sec-title"><i class="fa-solid fa-layer-group"></i> ${t('ui_adm_domains')}
                <span class="hint">${t('ui_adm_domains_hint')}</span></div>
            <div class="dom-tabs">
                ${DOMAINS.map(k => `
                    <button class="dom-tab ${d.tab === k ? 'active' : ''} ${d.domains[k].enabled ? 'on' : ''}" data-domtab="${k}">
                        <i class="fa-solid ${DOMAIN_ICONS[k]}"></i>
                        <span>${domainLabel(k)}</span>
                        ${d.domains[k].enabled ? '<i class="fa-solid fa-circle-check dom-on"></i>' : ''}
                    </button>`).join('')}
            </div>

            <div class="dom-panel">
                <div class="switch-row" style="margin-bottom:10px">
                    <label class="sw"><input type="checkbox" id="se-domon" ${blk.enabled ? 'checked' : ''}><span class="sw-track"></span></label>
                    <span class="sw-label">${t('ui_adm_domain_enable', domainLabel(dom))}</span>
                </div>

                ${blk.enabled ? `
                <div class="ed-sec-title"><i class="fa-solid ${DOMAIN_ICONS[dom]}"></i> ${t('ui_adm_vehicles')}</div>
                <div class="seg" style="margin-bottom:10px">
                    <button data-dseg="useListing" data-val="0" class="${!blk.useListing ? 'active' : ''}">${t('ui_adm_by_categories')}</button>
                    <button data-dseg="useListing" data-val="1" class="${blk.useListing ? 'active' : ''}">${t('ui_adm_by_listing')}</button>
                </div>
                ${blk.useListing
                    ? `<div class="form-field"><label>${t('ui_adm_listing')}</label><select id="se-listing">${listingOpts}</select></div>`
                    : (catChips
                        ? `<div class="chip-row">${catChips}</div>`
                        : `<div class="tile-sub">${t('ui_adm_no_cats_domain')}</div>`)}

                <div class="ed-sec-title" style="margin-top:14px"><i class="fa-solid fa-map-location-dot"></i> ${t('ui_adm_zones')}
                    <span class="hint">${t('ui_adm_zones_hint')}</span></div>
                ${zones}` : `<div class="tile-sub">${t('ui_adm_domain_off', domainLabel(dom))}</div>`}
            </div>
        </div>

        <div class="ed-section">
            <div class="ed-sec-title"><i class="fa-solid fa-location-dot"></i> ${t('ui_adm_stand_zones')}</div>
            ${standZones || `<div class="tile-sub">${t('ui_adm_no_stand_zones')}</div>`}
        </div>

        ${owned ? `
        <div class="ed-section">
            <div class="ed-sec-title"><i class="fa-solid fa-briefcase"></i> ${t('ui_adm_job_perms')}<span class="hint">${t('ui_adm_job_hint')}</span></div>
            <div class="form-grid" style="margin-top:0">
                <div class="form-field full"><label>${t('ui_adm_boss_job')}</label><select id="se-job">${jobOpts}</select></div>
                ${d.bossJob && job ? `
                <div class="form-field"><label>Sales</label><select data-role="Sales">${gradeOpts(d.gradeRoles.Sales)}</select></div>
                <div class="form-field"><label>Supervisor</label><select data-role="Supervisor">${gradeOpts(d.gradeRoles.Supervisor)}</select></div>
                <div class="form-field"><label>Manager</label><select data-role="Manager">${gradeOpts(d.gradeRoles.Manager)}</select></div>` : ''}
            </div>
        </div>` : ''}

        <div class="ed-section">
            <div class="ed-sec-title"><i class="fa-solid fa-lock"></i> ${t('ui_adm_access')}<span class="hint">${t('ui_adm_access_hint')}</span></div>
            <div class="zr-label" style="margin-bottom:6px">${t('ui_adm_whitelist')}</div>
            <div class="chip-row" style="margin-bottom:12px">${jobChips(d.jobWhitelist, 'jobWhitelist')}</div>
            <div class="zr-label" style="margin-bottom:6px">${t('ui_adm_society')}</div>
            <div class="chip-row">${jobChips(d.societyJobs, 'societyJobs')}</div>
        </div>

        <div class="ed-section">
            <div class="ed-sec-title"><i class="fa-solid fa-toggle-on"></i> ${t('ui_adm_features')}</div>
            <div class="switch-stack">
                <div class="switch-row">
                    <label class="sw"><input type="checkbox" id="se-td" ${d.enableTestDrive ? 'checked' : ''}><span class="sw-track"></span></label>
                    <span class="sw-label">${t('ui_test_drive')}</span>
                </div>
                <div class="switch-row">
                    <label class="sw"><input type="checkbox" id="se-fin" ${d.enableFinance ? 'checked' : ''}><span class="sw-track"></span></label>
                    <span class="sw-label">${t('ui_finance_title')}</span>
                </div>
                <div class="switch-row">
                    <label class="sw"><input type="checkbox" id="se-sell" ${d.enableSell ? 'checked' : ''}><span class="sw-track"></span></label>
                    <span class="sw-label">${t('ui_sellback')}</span>
                </div>
            </div>
            ${d.enableSell ? `<div class="form-field" style="margin-top:10px;max-width:200px"><label>${t('ui_sellback')} (%)</label>
                <input type="number" id="se-sellpct" min="5" max="100" value="${d.sellPercent}"></div>` : ''}
        </div>

        <div class="ed-section">
            <div class="ed-sec-title"><i class="fa-solid fa-map-pin"></i> ${t('ui_adm_blip')}</div>
            <div class="switch-row" style="margin-bottom:10px">
                <label class="sw"><input type="checkbox" id="se-blip" ${d.blip.enabled ? 'checked' : ''}><span class="sw-track"></span></label>
                <span class="sw-label">${t('ui_adm_blip_show')}</span>
            </div>
            ${d.blip.enabled ? `<div class="form-grid" style="margin-top:0">
                <div class="form-field"><label>${t('ui_adm_blip_sprite')}</label><input type="number" id="se-bsprite" min="1" max="826" value="${d.blip.sprite}"></div>
                <div class="form-field"><label>${t('ui_adm_blip_color')}</label><input type="number" id="se-bcolor" min="0" max="85" value="${d.blip.color}"></div>
                <div class="form-field"><label>${t('ui_adm_blip_scale')} — <span class="mono" id="se-bscale-v">${d.blip.scale}</span></label>
                    <input type="range" id="se-bscale" min="0.3" max="1.5" step="0.05" value="${d.blip.scale}"></div>
                <div class="form-field"><label>${t('ui_adm_blip_label')}</label><input type="text" id="se-blabel" value="${esc(d.blip.label)}" placeholder="${esc(d.label)}"></div>
            </div>` : ''}
        </div>

        <div class="ed-section">
            <div class="ed-sec-title"><i class="fa-solid fa-user-tie"></i> ${t('ui_adm_ped')}<span class="hint">${t('ui_adm_ped_hint')}</span></div>
            <div class="form-grid" style="margin-top:0">
                <div class="form-field"><label>${t('ui_model')}</label>
                    <input type="text" id="se-pedmodel" value="${esc(d.ped.model)}" spellcheck="false" placeholder="a_m_y_business_03"></div>
                <div class="form-field"><label>${t('ui_adm_position')}</label>
                    <button class="btn btn-ghost" id="se-pedpos"><i class="fa-solid fa-person"></i>
                        ${d.ped.coords ? `<span class="mono">${d.ped.coords.x.toFixed(1)}, ${d.ped.coords.y.toFixed(1)}</span>` : t('ui_adm_my_position')}</button></div>
            </div>
        </div>`;

    const foot = $('#ed-foot');
    foot.innerHTML = '';
    const mkBtn = (label, cls, fn) => {
        const b = document.createElement('button');
        b.className = `btn ${cls}`;
        b.innerHTML = label;
        on(b, 'click', fn);
        foot.appendChild(b);
        return b;
    };
    mkBtn(t('ui_cancel'), 'btn-ghost', () => closeEditor());
    mkBtn(`<i class="fa-solid fa-floppy-disk"></i> ${t('ui_save')}`, 'btn-primary', saveStand);

    // ── bindings ──
    const body = $('#ed-body');
    on($('#se-label'), 'input', e => { d.label = e.target.value; });
    $$('[data-seg]', body).forEach(b => on(b, 'click', () => {
        d[b.dataset.seg] = b.dataset.val;
        renderStandEditor();
    }));
    // domain tabs + per-domain controls
    $$('[data-domtab]', body).forEach(b => on(b, 'click', () => {
        d.tab = b.dataset.domtab;
        renderStandEditor();
    }));
    on($('#se-domon'), 'change', e => {
        blk.enabled = e.target.checked;
        renderStandEditor();
    });
    $$('[data-dseg]', body).forEach(b => on(b, 'click', () => {
        if (b.dataset.dseg === 'useListing') blk.useListing = b.dataset.val === '1';
        renderStandEditor();
    }));
    $$('[data-cat]', body).forEach(b => on(b, 'click', () => {
        const k = b.dataset.cat;
        const i = blk.categories.indexOf(k);
        if (i >= 0) blk.categories.splice(i, 1); else blk.categories.push(k);
        b.classList.toggle('active');
    }));
    on($('#se-listing'), 'change', e => { blk.listing = Number(e.target.value) || null; });
    on($('#se-job'), 'change', e => { d.bossJob = e.target.value; renderStandEditor(); });
    $$('select[data-role]', body).forEach(s => on(s, 'change', () => {
        d.gradeRoles[s.dataset.role] = s.value === '' ? null : Number(s.value);
    }));
    $$('[data-jl]', body).forEach(b => on(b, 'click', () => {
        const list = d[b.dataset.jl];
        const j = b.dataset.job;
        const i = list.indexOf(j);
        if (i >= 0) list.splice(i, 1); else list.push(j);
        b.classList.toggle('active');
    }));
    $$('[data-pick]', body).forEach(b => on(b, 'click', () => startPick(b.dataset.pick, b.dataset.mode)));
    $$('[data-mypos]', body).forEach(b => on(b, 'click', () => myPos(b.dataset.mypos)));
    $$('[data-delspawn]', body).forEach(b => on(b, 'click', () => {
        blk.deliverySpawns.splice(Number(b.dataset.delspawn), 1);
        renderStandEditor();
    }));
    on($('#se-td'), 'change', e => { d.enableTestDrive = e.target.checked; renderStandEditor(); });
    on($('#se-fin'), 'change', e => { d.enableFinance = e.target.checked; });
    on($('#se-sell'), 'change', e => { d.enableSell = e.target.checked; renderStandEditor(); });
    on($('#se-sellpct'), 'input', e => { d.sellPercent = Number(e.target.value) || 60; });
    on($('#se-blip'), 'change', e => { d.blip.enabled = e.target.checked; renderStandEditor(); });
    on($('#se-bsprite'), 'input', e => { d.blip.sprite = Number(e.target.value) || 326; });
    on($('#se-bcolor'), 'input', e => { d.blip.color = Number(e.target.value) || 0; });
    on($('#se-bscale'), 'input', e => {
        d.blip.scale = Number(e.target.value) || 0.7;
        const v = $('#se-bscale-v');
        if (v) v.textContent = d.blip.scale;
    });
    on($('#se-blabel'), 'input', e => { d.blip.label = e.target.value; });
    on($('#se-pedmodel'), 'input', e => { d.ped.model = e.target.value; });
    on($('#se-pedpos'), 'click', () => myPos('ped'));
}

async function saveStand() {
    const d = ADM.draft;
    if (!d) return;
    if (!d.label.trim()) return notifyErr('bad_input');

    const domains = {};
    DOMAINS.forEach(k => {
        const b = d.domains[k];
        if (!b.enabled) return;
        domains[k] = {
            enabled: true,
            listing: b.useListing ? b.listing : null,
            categories: b.useListing ? [] : b.categories,
            showroom: b.showroom, preview: b.preview,
            testDriveSpawn: b.testDriveSpawn, deliverySpawns: b.deliverySpawns,
        };
    });

    const payload = {
        id: d.id, label: d.label,
        type: d.type, stockMode: d.stockMode,
        domains,
        bossJob: d.type === 'owned' ? d.bossJob : '',
        gradeRoles: (d.type === 'owned' && d.bossJob) ? thresholdsToGrades(d.gradeRoles) : null,
        jobWhitelist: d.jobWhitelist, societyJobs: d.societyJobs,
        management: d.management, sellPoint: d.sellPoint, bossPoint: d.bossPoint,
        stockPoint: d.stockPoint,
        ped: d.ped.model ? d.ped : null,
        blip: d.blip,
        enableTestDrive: d.enableTestDrive, enableFinance: d.enableFinance, enableSell: d.enableSell,
        sellPercent: Number(d.sellPercent) || 60,
    };
    const r = await post('adm_save_stand', payload);
    if (!r.ok) return notifyErr(r.why);
    closeEditor();
    Notify({ type: 'success', message: t('n_stand_saved') });
    applyStands(r.data);
}

on($('#ed-close'), 'click', () => closeEditor());

// ── Listings ──
function renderAdmListings(pane) {
    const ls = ADM.data.listings;
    // v3 stands reference a listing per domain; legacy ones at the top level
    const usedBy = (id) => ADM.data.stands.filter(s => {
        const d = s.data || {};
        if (d.domains) return DOMAINS.some(k => d.domains[k] && d.domains[k].listing === id);
        return d.listing === id;
    });
    let html = `<div class="mg-head-row">
        <span class="muted">${ls.length} ${t('ui_adm_listings').toLowerCase()}</span>
        <button class="btn btn-primary btn-sm" id="lst-add"><i class="fa-solid fa-plus"></i> ${t('ui_adm_new_listing')}</button>
    </div>`;
    if (!ls.length) html += emptyHtml('fa-list-check', 'ui_adm_no_listings');
    else html += `<div class="listing-grid">` + ls.map(l => `
        <div class="stand-card">
            <div class="stand-head">
                <span class="stand-ic"><i class="fa-solid fa-list-check"></i></span>
                <div><div class="stand-name">${esc(l.name)}</div>
                <div class="stand-id">${l.count} ${t('ui_adm_vehicles').toLowerCase()}</div></div>
                <div class="stand-badges">${usedBy(l.id).map(s => `<span class="badge badge-brand">${esc(s.label)}</span>`).join('')}</div>
            </div>
            <div class="stand-actions">
                <button class="btn btn-ghost btn-sm" data-led="${l.id}"><i class="fa-solid fa-pen"></i> ${t('ui_edit')}</button>
                <button class="btn btn-ghost btn-sm" data-ldup="${l.id}"><i class="fa-solid fa-copy"></i> ${t('ui_adm_duplicate')}</button>
                <span class="spacer"></span>
                <button class="btn btn-danger btn-sm tip" data-ldel="${l.id}" data-tip="${t('ui_delete')}"><i class="fa-solid fa-trash"></i></button>
            </div>
        </div>`).join('') + `</div>`;
    pane.innerHTML = html;

    on($('#lst-add'), 'click', () => openListingEditor(null));
    $$('[data-led]', pane).forEach(b => on(b, 'click', () =>
        openListingEditor(ls.find(l => l.id === Number(b.dataset.led)))));
    $$('[data-ldup]', pane).forEach(b => on(b, 'click', async () => {
        const r = await post('adm_listing_dup', { id: Number(b.dataset.ldup) });
        if (!r.ok) return notifyErr(r.why);
        ADM.data.listings = arr(r.data && r.data.listings);
        renderAdmPane();
    }));
    $$('[data-ldel]', pane).forEach(b => on(b, 'click', () => {
        const id = Number(b.dataset.ldel);
        const l = ls.find(x => x.id === id);
        const stands = usedBy(id);
        const del = async () => {
            const r = await post('adm_listing_del', { id });
            if (!r.ok) return notifyErr(r.why);
            closeDialog();
            ADM.data.listings = arr(r.data && r.data.listings);
            await refreshAdm();
        };
        if (!stands.length) return del();
        // the stands using it fall back to the categories the listing covered
        openDialog('lstdel', l ? l.name : '', t('ui_delete'),
            `<div class="dlg-line">${t('ui_adm_listing_delete_used', stands.length)}</div>
             <div class="chip-row" style="margin-top:8px">${stands.map(s => `<span class="chip active">${esc(s.label)}</span>`).join('')}</div>`, [
            [t('ui_cancel'), 'btn-ghost', () => closeDialog()],
            [t('ui_delete'), 'btn-danger', del],
        ], true);
    }));
}

function openListingEditor(l) {
    ADM.editorKind = 'listing';
    ADM.listingDraft = {
        id: l ? l.id : null,
        name: l ? l.name : '',
        vehicles: new Set(l ? arr(l.vehicles) : []),
        search: '',
    };
    $('#editor-overlay').hidden = false;
    renderListingEditor();
}

function renderListingEditor(focusSearch) {
    const d = ADM.listingDraft;
    if (!d) return;
    $('#ed-eyebrow').textContent = t('ui_adm_listings').toUpperCase();
    $('#ed-title').textContent = d.id ? d.name : t('ui_adm_new_listing');
    const q = d.search.toLowerCase();
    let rows = '';
    ADM.data.categories.forEach(c => {
        const vs = ADM.data.catalog.filter(v => v.category === c.key &&
            (!q || v.name.toLowerCase().includes(q) || v.model.includes(q) || String(v.brand || '').toLowerCase().includes(q)));
        if (!vs.length) return;
        rows += `<div class="veh-pick-cat">${c.label} · ${vs.length}</div>`;
        rows += vs.map(v => `<div class="veh-pick-row ${d.vehicles.has(v.model) ? 'checked' : ''}" data-vm="${v.model}">
            <span class="vp-check"><i class="fa-solid fa-check"></i></span>
            <span class="vp-name">${esc(v.brand)} ${esc(v.name)} <span class="mono" style="opacity:.5">${v.model}</span></span>
            <span class="vp-price mono">${fmtMoney(v.price)}</span>
        </div>`).join('');
    });
    $('#ed-body').innerHTML = `
        <div class="form-grid" style="margin-top:0">
            <div class="form-field full"><label>${t('ui_name')}</label><input type="text" id="le-name" value="${esc(d.name)}" maxlength="60"></div>
        </div>
        <div class="search-wrap" style="margin:10px 0">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" id="le-search" placeholder="${t('ui_search')}" value="${esc(d.search)}">
        </div>
        <div class="veh-pick-list">${rows || emptyHtml('fa-car')}</div>`;

    const foot = $('#ed-foot');
    foot.innerHTML = `<span class="muted" style="margin-right:auto;align-self:center" id="le-count">${d.vehicles.size} ${t('ui_adm_vehicles').toLowerCase()}</span>`;
    const cancel = document.createElement('button');
    cancel.className = 'btn btn-ghost';
    cancel.textContent = t('ui_cancel');
    on(cancel, 'click', () => closeEditor());
    foot.appendChild(cancel);
    const save = document.createElement('button');
    save.className = 'btn btn-primary';
    save.innerHTML = `<i class="fa-solid fa-floppy-disk"></i> ${t('ui_save')}`;
    on(save, 'click', async () => {
        if (!d.name.trim()) return notifyErr('bad_input');
        const r = await post('adm_listing_save', { id: d.id, name: d.name, vehicles: Array.from(d.vehicles) });
        if (!r.ok) return notifyErr(r.why);
        closeEditor();
        ADM.data.listings = arr(r.data && r.data.listings);
        renderAdmPane();
    });
    foot.appendChild(save);

    on($('#le-name'), 'input', e => { d.name = e.target.value; });
    on($('#le-search'), 'input', e => {
        d.search = e.target.value;
        renderListingEditor(true);
    });
    if (focusSearch) {
        const el = $('#le-search');
        el.focus();
        el.setSelectionRange(el.value.length, el.value.length);
    }
    $$('.veh-pick-row', $('#ed-body')).forEach(r => on(r, 'click', () => {
        const m = r.dataset.vm;
        if (d.vehicles.has(m)) d.vehicles.delete(m); else d.vehicles.add(m);
        r.classList.toggle('checked');
        $('#le-count').textContent = `${d.vehicles.size} ${t('ui_adm_vehicles').toLowerCase()}`;
    }));
}

// ── Catalog (admin) ──
async function refreshCatalogData() {
    const r = await post('ad_catalog', {});
    if (r.ok) ADM.data.catalog = arr(r.data);
    if (ADM.open && (ADM.tab === 'catalog' || ADM.tab === 'import')) renderAdmPane();
}

function renderAdmCatalog(pane, keepFocus) {
    const q = ADM.catSearch.toLowerCase();
    const cf = ADM.catFilter;
    const list = ADM.data.catalog.filter(v => (!cf || v.category === cf) &&
        (!q || v.name.toLowerCase().includes(q) || v.model.includes(q) || String(v.brand || '').toLowerCase().includes(q)));
    pane.innerHTML = `
        <div class="mg-head-row">
            <span class="muted">${list.length} / ${ADM.data.catalog.length} ${t('ui_adm_vehicles').toLowerCase()}</span>
            <div style="display:flex;gap:8px;align-items:center">
                <select id="ac-cat">
                    <option value="">${t('ui_all')}</option>
                    ${ADM.data.categories.map(c => `<option value="${c.key}" ${cf === c.key ? 'selected' : ''}>${c.label}</option>`).join('')}
                </select>
                <button class="btn btn-primary btn-sm" id="ac-add"><i class="fa-solid fa-plus"></i> ${t('ui_add_vehicle')}</button>
            </div>
        </div>
        <div class="search-wrap" style="margin-bottom:10px">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" id="ac-search" placeholder="${t('ui_search')}" value="${esc(ADM.catSearch)}">
        </div>
        ${list.length ? `<table class="tbl tbl-veh-table"><thead><tr>
            <th>${t('ui_model')}</th><th>${t('ui_category')}</th><th class="num">${t('ui_price')}</th>
            <th class="num">${t('ui_price_bounds')}</th><th></th></tr></thead>
            <tbody>${list.slice(0, 500).map(v => `<tr>
                ${vehCell(v)}
                <td><span class="badge badge-brand">${catLabel(v.category)}</span></td>
                <td class="num mono">${fmtMoney(v.price)}</td>
                <td class="num mono ${v.min_price || v.max_price ? '' : 'muted'}">${
                    v.min_price || v.max_price
                        ? `${v.min_price ? fmtMoney(v.min_price) : '—'} · ${v.max_price ? fmtMoney(v.max_price) : '—'}`
                        : '—'}</td>
                <td class="row-actions">
                    <button class="btn btn-ghost btn-sm tip" data-ced="${v.model}" data-tip="${t('ui_edit')}"><i class="fa-solid fa-pen"></i></button>
                    <button class="btn btn-danger btn-sm tip" data-cdel="${v.model}" data-tip="${t('ui_delete')}"><i class="fa-solid fa-trash"></i></button></td>
            </tr>`).join('')}</tbody></table>` : emptyHtml('fa-database')}`;

    on($('#ac-cat'), 'change', e => { ADM.catFilter = e.target.value; renderAdmCatalog(pane); });
    on($('#ac-search'), 'input', e => {
        ADM.catSearch = e.target.value;
        renderAdmCatalog(pane, true);
    });
    if (keepFocus) {
        const el = $('#ac-search');
        el.focus();
        el.setSelectionRange(el.value.length, el.value.length);
    }
    on($('#ac-add'), 'click', () => catalogModal(null));
    $$('[data-ced]', pane).forEach(b => on(b, 'click', () =>
        catalogModal(ADM.data.catalog.find(v => v.model === b.dataset.ced))));
    $$('[data-cdel]', pane).forEach(b => on(b, 'click', async () => {
        const r = await post('ad_delete', { model: b.dataset.cdel });
        if (!r.ok) return notifyErr(r.why);
        refreshCatalogData();
    }));
}

// ── Import ──
const IMP_META = {
    default:  { icon: 'fa-box-archive', kind: 'ui_adm_src_builtin' },
    qb:       { icon: 'fa-cubes',       kind: 'ui_adm_src_framework' },
    esx:      { icon: 'fa-server',      kind: 'ui_adm_src_framework' },
    resource: { icon: 'fa-folder-open', kind: 'ui_adm_src_resource' },
};

async function renderAdmImport(pane) {
    pane.innerHTML = `<div class="empty"><i class="fa-solid fa-spinner fa-spin"></i><span>${t('ui_adm_scanning')}</span></div>`;
    if (!ADM.importSources) {
        const r = await post('adm_import_scan', {});
        if (!ADM.open || ADM.tab !== 'import') return;
        if (!r.ok) { pane.innerHTML = emptyHtml('fa-triangle-exclamation'); return; }
        ADM.importSources = arr(r.data);
    }
    if (!ADM.open || ADM.tab !== 'import') return;

    const srcs = ADM.importSources;
    const totalFound = srcs.reduce((a, s) => a + (Number(s.count) || 0), 0);
    const inCatalog = arr(ADM.data.catalog).length;

    const stat = (icon, value, label, accent) => `
        <div class="imp-stat ${accent ? 'imp-stat-accent' : ''}">
            <span class="imp-stat-ic"><i class="fa-solid ${icon}"></i></span>
            <div>
                <div class="imp-stat-v mono">${value}</div>
                <div class="imp-stat-l">${label}</div>
            </div>
        </div>`;

    pane.innerHTML = `
    <div class="imp-head">
        <div class="imp-stats">
            ${stat('fa-plug', srcs.length, t('ui_adm_sources'))}
            ${stat('fa-magnifying-glass-chart', totalFound, t('ui_adm_found_total'))}
            ${stat('fa-database', inCatalog, t('ui_adm_in_catalog'), true)}
        </div>
        <div class="imp-head-right">
            <label class="imp-toggle">
                <span class="sw"><input type="checkbox" id="imp-update" ${ADM.impUpdate ? 'checked' : ''}><span class="sw-track"></span></span>
                <span class="sw-label">${t('ui_adm_update_existing')}</span>
                <i class="fa-solid fa-circle-info tip head-info" data-tip="${esc(t('ui_adm_update_tip'))}"></i>
            </label>
            <button class="btn btn-ghost btn-sm" id="imp-rescan"><i class="fa-solid fa-rotate"></i> ${t('ui_adm_rescan')}</button>
        </div>
    </div>

    ${ADM.importResult ? `<div class="import-result"><i class="fa-solid fa-circle-check"></i>
        ${t('ui_adm_import_done', ADM.importResult.added, ADM.importResult.updated, ADM.importResult.skipped)}</div>` : ''}

    <div class="imp-body">
        <div class="imp-list">
            ${srcs.length ? srcs.map((s, i) => {
                const meta = IMP_META[s.key] || IMP_META.resource;
                return `<div class="import-card">
                    <span class="imp-ic"><i class="fa-solid ${meta.icon}"></i></span>
                    <div class="imp-info">
                        <div class="imp-name">${esc(s.label)}</div>
                        <div class="imp-sub">
                            <span class="badge badge-brand">${t(meta.kind)}</span>
                            <span class="mono">${s.count} ${t('ui_adm_vehicles').toLowerCase()}</span>
                            ${s.path ? `<span class="mono imp-path">${esc(s.path)}</span>` : ''}
                        </div>
                    </div>
                    <button class="btn btn-primary btn-sm" data-imp="${i}">
                        <i class="fa-solid fa-file-import"></i> ${t('ui_adm_import')}</button>
                </div>`;
            }).join('') : emptyHtml('fa-file-import', 'ui_adm_no_sources')}
        </div>

        <aside class="imp-aside">
            <div class="mg-section-card">
                <div class="chart-title"><i class="fa-solid fa-circle-info"></i> ${t('ui_adm_why_title')}</div>
                <div class="tile-sub">${t('ui_adm_why_body')}</div>
                <ul class="imp-why">
                    <li><i class="fa-solid fa-check"></i> <code class="mono">vehicles.lua</code></li>
                    <li><i class="fa-solid fa-check"></i> <code class="mono">shared/vehicles.lua</code></li>
                    <li><i class="fa-solid fa-check"></i> <code class="mono">config/vehicles.lua</code></li>
                    <li><i class="fa-solid fa-check"></i> <code class="mono">data/vehicles.lua</code></li>
                    <li><i class="fa-solid fa-check"></i> <code class="mono">vehicles.json</code></li>
                    <li><i class="fa-solid fa-check"></i> <code class="mono">config.lua</code> / <code class="mono">shared/config.lua</code></li>
                </ul>
                <div class="tile-sub">${t('ui_adm_why_note')}</div>
            </div>
            <div class="mg-section-card imp-tool">
                <div class="chart-title"><i class="fa-solid fa-wand-magic-sparkles"></i> ${t('ui_adm_tool_title')}</div>
                <div class="tile-sub">${t('ui_adm_tool_body')}</div>
                <div class="imp-tool-path mono">apex_dealerships/tools/apex_vehicle_import.bat</div>
            </div>
        </aside>
    </div>`;

    on($('#imp-update'), 'change', e => { ADM.impUpdate = e.target.checked; });
    on($('#imp-rescan'), 'click', () => { ADM.importSources = null; ADM.importResult = null; renderAdmPane(); });

    $$('button[data-imp]', pane).forEach(b => on(b, 'click', async () => {
        const s = ADM.importSources[Number(b.dataset.imp)];
        if (!s) return;
        b.disabled = true;
        b.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i>`;
        const r = await post('adm_import_run', {
            source: s.key, resource: s.resource, path: s.path,
            update: !!ADM.impUpdate,
        });
        if (!r.ok) { renderAdmPane(); return notifyErr(r.why); }
        ADM.importResult = r.data;
        ADM.importSources = null;      // counts changed — rescan next render
        const rc = await post('ad_catalog', {});
        if (rc.ok) ADM.data.catalog = arr(rc.data);
        renderAdmPane();
        Notify({ type: 'success', message: t('ui_adm_import_done', r.data.added, r.data.updated, r.data.skipped) });
    }));
}

// ── shell events ──
on($('#adm-close'), 'click', () => post('ui_close'));
on($('#adm-close-2'), 'click', () => post('ui_close'));
on($('#adm-collapse'), 'click', () => {
    const collapsed = $('.adm-shell').classList.toggle('rail-collapsed');
    localStorage.setItem('apexdealer-rail', collapsed ? '1' : '0');
});


// ====================================================================
// Message router
// ====================================================================
window.addEventListener('message', (ev) => {
    const msg = ev.data;
    if (!msg || !msg.action) return;
    const p = msg.payload || {};
    switch (msg.action) {
        case 'bootstrap':
            Object.assign(Runtime, p);
            Runtime.categories = arr(Runtime.categories);
            if (Runtime.finance) Runtime.finance.terms = arr(Runtime.finance.terms);
            applyTheme(p.theme);
            applyLocaleStatics();
            break;
        case 'theme':
            // server-wide theme (admin changed it, or we just joined)
            Runtime.theme = p;
            ADM.themePreview = false;
            applyTheme(p);
            break;
        case 'categories':
            // admin added/edited categories — every UI picks them up live
            Runtime.categories = arr(p);
            if (ADM.open && ADM.data) ADM.data.categories = Runtime.categories;
            break;
        case 'show3DIcon': {
            // this can arrive many times a second while the player moves, so
            // the nodes are looked up once and the label/icon/key are only
            // written when they actually change (each write forces a layout)
            const w = w3d();
            w.box.style.left = ((Number(msg.x) || 0) * window.innerWidth) + 'px';
            w.box.style.top  = ((Number(msg.y) || 0) * window.innerHeight) + 'px';
            w.box.style.transform = `translate(-50%, -50%) scale(${Number(msg.scale) || 1})`;

            const icon = 'fa-solid fa-' + (msg.icon || 'car');
            if (w.lastIcon !== icon) { w.icon.className = icon; w.lastIcon = icon; }

            const label = msg.label || '';
            if (w.lastLabel !== label) { w.label.textContent = label; w.lastLabel = label; }

            // key === '' means "no keybind" (e.g. the trailer hitch): hide the
            // key chip and bob the icon instead of asking for a press
            const key = (msg.key === null || msg.key === undefined) ? '' : String(msg.key);
            if (w.lastKey !== key) {
                const hasKey = key !== '';
                w.key.hidden = !hasKey;
                if (hasKey) w.key.textContent = key;
                w.box.classList.toggle('w3d-bob', !hasKey);
                w.lastKey = key;
            }

            if (w.box.hidden) w.box.hidden = false;
            break;
        }
        case 'hide3DIcon': { const w = w3d(); if (!w.box.hidden) w.box.hidden = true; break; }
        case 'showroom_open': openShowroom(p); break;
        case 'showroom_close': closeShowroomUI(); break;
        case 'management_open': openManagement(p); break;
        case 'management_close': closeManagementUI(); break;
        case 'admin_open': openAdmin(p); break;
        case 'admin_close': closeAdminUI(); break;
        case 'admin_showcase_open': {
            // back from the ghost placer: land straight in the same modal
            const s = ADM.data && ADM.data.stands.find(x => x.id === p.dealership);
            if (s) admShowcaseModal(s);
            break;
        }
        case 'admin_pick_result': admPickResult(p); break;
        case 'placer_open': openPlacer(p); break;
        case 'placer_close': $('#placer').hidden = true; break;
        case 'placer_show': $('.placer-panel').style.opacity = 1; break;
        case 'placer_hide': $('.placer-panel').style.opacity = 0; break;
        case 'finance_open':
            $('#finance-overlay').hidden = false;
            renderFinance(p);
            break;
        case 'direct_sale_offer': directSaleOffer(p); break;
        case 'hire_offer': hireOffer(p); break;
        case 'testdrive_offer': testDriveOffer(p); break;
        case 'sell_offer': sellOffer(p); break;
        case 'dialog_close': closeDialog(); break;
        case 'td_start':
            $('#td-hint').textContent = t('ui_td_hint', p.endCommand);
            tdTick(p.seconds);
            $('#td-hud').hidden = false;
            break;
        case 'td_tick': tdTick(p.left); break;
        case 'td_end': $('#td-hud').hidden = true; break;
        case 'close_all':
            closeShowroomUI();
            closeManagementUI();
            closeAdminUI();
            $('#placer').hidden = true;
            closeDialog();
            $('#finance-overlay').hidden = true;
            break;
    }
});

// ====================================================================
// ESC handling — close the top-most layer
// ====================================================================
window.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    if (DLG.open) {
        const kind = DLG.kind;
        closeDialog();
        if (kind === 'sell') post('sell_answer', { accept: false });
        else if (kind === 'deletestand' || kind === 'admowner' || kind === 'catalog'
              || kind === 'category' || kind === 'catdel' || kind === 'lstdel' || kind === 'setstock'
              || kind === 'admshowcase' || kind === 'showcase' || kind === 'delivery') { /* admin-side dialog: just close */ }
        else post('dialog_answer', { accept: false });
        return;
    }
    if (ADM.editorKind) { closeEditor(); return; }
    if (CO.open) { closeCheckout(); return; }
    if (!$('#finance-overlay').hidden) {
        $('#finance-overlay').hidden = true;
        post('ui_close');
        return;
    }
    if (MG.open || SR.open || ADM.open) post('ui_close');
});

post('ui_ready');
})();
