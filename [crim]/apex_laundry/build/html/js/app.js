/* ============================================================
   Apex Laundry — NUI app
   ============================================================ */
(() => {
'use strict';

const RES = (typeof GetParentResourceName === 'function')
    ? GetParentResourceName() : 'apex_laundry';

const $  = (s, r = document) => r.querySelector(s);
const on = (el, ev, cb, opts) => el && el.addEventListener(ev, cb, opts);

const post = (name, data = {}) =>
    fetch(`https://${RES}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    }).then(r => r.json().catch(() => ({}))).catch(() => ({}));

// Fire-and-forget click SFX (no-op server-side unless Config.features.sounds).
const Sound = (alias) => { if (Runtime.features && Runtime.features.sounds) post('play_sound', { alias }); };

// ─── Runtime (filled by the Lua "bootstrap" message) ────
const Runtime = {
    theme: {},
    currency: { symbol: '$', position: 'before' },
    economy: { baseValue: 1000, washTime: 5, cleanerCost: 1, taxPercent: 5, maxCleaners: 500, upgradePayment: 'cash' },
    upgrades: {},
    items: {},
    features: {},
    locale: {},
    colorPresets: [],
    prefs: {},
    player: { dirty: 0, cleaners: 0, upgradeBalance: 0 },
    machine: null,
};

// Per-player UI defaults. brand/bg = null → fall back to Config.theme.
const DEFAULT_PREFS = { brand: null, bg: null, position: 'left', opacity: 1, scale: 1 };
const BG_PRESETS = ['#1A1A1B', '#0A0A0B', '#16161A', '#1C1620', '#141A18', '#1A1416'];

// ─── i18n ───────────────────────────────────────────────
const t = (key, ...args) => {
    let s = (Runtime.locale && Runtime.locale[key]);
    if (s == null) s = key;
    if (args.length) {
        let i = 0;
        s = String(s).replace(/%s/g, () => (i < args.length ? String(args[i++]) : '%s'));
    }
    return s;
};

const esc = (s) => String(s ?? '').replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
})[c]);

// ─── Formatters ─────────────────────────────────────────
const fmtMoney = (n) => {
    n = Math.floor(Number(n) || 0);
    const neg = n < 0; n = Math.abs(n);
    const s = n.toLocaleString('en-US');
    const cur = Runtime.currency || { symbol: '$', position: 'before' };
    return (neg ? '-' : '') + (cur.position === 'after' ? `${s} ${cur.symbol}` : `${cur.symbol}${s}`);
};
const fmtInt = (n) => (Math.floor(Number(n) || 0)).toLocaleString('en-US');
const fmtTime = (sec) => {
    sec = Math.max(0, Math.floor(Number(sec) || 0));
    const h = Math.floor(sec / 3600), m = Math.floor((sec % 3600) / 60), s = sec % 60;
    const pad = (x) => String(x).padStart(2, '0');
    return h > 0 ? `${h}:${pad(m)}:${pad(s)}` : `${pad(m)}:${pad(s)}`;
};
// Cost is money for cash/bank modes, a unit count for item modes.
const fmtCost = (price) => {
    const mode = Runtime.economy.upgradePayment || 'cash';
    if (mode === 'clean_item' || mode === 'dirty_item') return `${fmtInt(price)}×`;
    return fmtMoney(price);
};

// ═══════════════════════════════════════════════════════
// THEME — recompute the full brand ramp from one hex
// ═══════════════════════════════════════════════════════
function _hexToRgb(hex) {
    const h = (hex || '').replace('#', '');
    const n = h.length === 3 ? h.split('').map(c => c + c).join('') : h;
    return { r: parseInt(n.slice(0,2),16)||0, g: parseInt(n.slice(2,4),16)||0, b: parseInt(n.slice(4,6),16)||0 };
}
function _rgbToHsl({ r, g, b }) {
    r/=255; g/=255; b/=255;
    const mx = Math.max(r,g,b), mn = Math.min(r,g,b);
    let h = 0, s = 0; const l = (mx+mn)/2;
    if (mx !== mn) {
        const d = mx - mn;
        s = l > .5 ? d/(2-mx-mn) : d/(mx+mn);
        if (mx === r) h = (g-b)/d + (g < b ? 6 : 0);
        else if (mx === g) h = (b-r)/d + 2;
        else h = (r-g)/d + 4;
        h *= 60;
    }
    return { h, s: s*100, l: l*100 };
}
function _hslToHex(h, s, l) {
    s/=100; l/=100;
    const k = (n) => (n + h/30) % 12;
    const a = s * Math.min(l, 1-l);
    const f = (n) => l - a * Math.max(-1, Math.min(k(n)-3, Math.min(9-k(n), 1)));
    const to = (x) => Math.round(255*x).toString(16).padStart(2,'0');
    return `#${to(f(0))}${to(f(8))}${to(f(4))}`;
}
function applyBrandRamp(hex) {
    const root = document.documentElement.style;
    const { h, s } = _rgbToHsl(_hexToRgb(hex));
    const sat = Math.min(s, 92);
    const ramp = { 50:96, 100:91, 200:82, 300:72, 400:64, 500:56, 600:48, 700:40, 800:32, 900:24 };
    for (const [k, l] of Object.entries(ramp)) root.setProperty(`--brand-${k}`, _hslToHex(h, sat, l));
    const a = (v) => `hsla(${h.toFixed(0)}, ${sat.toFixed(0)}%, 56%, ${v})`;
    root.setProperty('--brand-a05', a(.05)); root.setProperty('--brand-a08', a(.08));
    root.setProperty('--brand-a12', a(.12)); root.setProperty('--brand-a18', a(.18));
    root.setProperty('--brand-a25', a(.25)); root.setProperty('--brand-a40', a(.40));
}
function applyTheme(theme) {
    if (!theme) return;
    // Recompute the full brand ramp from the chosen hex. --accent and
    // --accent-a* are defined in CSS as var(--brand-*), so they follow
    // the brand automatically (flat, bossmenu-style — no separate accent).
    if (theme.brand) applyBrandRamp(theme.brand);
}

// ── Per-player layout (position / size / opacity), live via CSS vars ──
function applyLayout(p) {
    const panel = $('#panel'); if (!panel) return;
    const pos = p.position || 'left';
    if (pos === 'center') {
        panel.style.setProperty('--ui-left', '50%');
        panel.style.setProperty('--ui-right', 'auto');
        panel.style.setProperty('--ui-tx', '-50%');
        panel.style.transformOrigin = 'center center';
    } else if (pos === 'right') {
        panel.style.setProperty('--ui-left', 'auto');
        panel.style.setProperty('--ui-right', '3.4vw');
        panel.style.setProperty('--ui-tx', '0px');
        panel.style.transformOrigin = 'right center';
    } else {
        panel.style.setProperty('--ui-left', '3.4vw');
        panel.style.setProperty('--ui-right', 'auto');
        panel.style.setProperty('--ui-tx', '0px');
        panel.style.transformOrigin = 'left center';
    }
    panel.style.setProperty('--ui-scale', String(p.scale || 1));
    panel.style.setProperty('--ui-opacity', String(p.opacity != null ? p.opacity : 1));
}

// Apply a full prefs object (brand + background + layout). Missing
// brand/bg fall back to the server default (Config.theme).
function applyPrefs(p) {
    p = Object.assign({}, DEFAULT_PREFS, p || {});
    Runtime.prefs = p;
    applyTheme({ brand: p.brand || (Runtime.theme && Runtime.theme.brand) || '#ff5be4' });
    const bg = p.bg || (Runtime.theme && Runtime.theme.bgCard) || '#1A1A1B';
    document.documentElement.style.setProperty('--bg-card', bg);
    applyLayout(p);
}

function applyLocale(loc) {
    if (!loc) return;
    Runtime.locale = loc;
    if (loc.__lang) { try { document.documentElement.lang = loc.__lang; } catch (_) {} }
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const v = loc[el.dataset.i18n]; if (v != null) el.textContent = v;
    });
    document.querySelectorAll('[data-i18n-aria]').forEach(el => {
        const v = loc[el.dataset.i18nAria]; if (v != null) el.setAttribute('aria-label', v);
    });
    const f = $('#wm-first'), s = $('#wm-second');
    if (loc.wm_first && f)  f.textContent = loc.wm_first;
    if (loc.wm_second && s) s.textContent = loc.wm_second;
}

// ═══════════════════════════════════════════════════════
// NOTIFICATIONS (built-in fallback toast)
// ═══════════════════════════════════════════════════════
const ICONS = { success: 'fa-circle-check', error: 'fa-circle-xmark', warning: 'fa-triangle-exclamation', info: 'fa-circle-info' };
function Notify(p) {
    const wrap = $('#notify-container'); if (!wrap) return;
    const kind = p.type || 'info';
    const el = document.createElement('div');
    el.className = `toast is-${kind}`;
    el.innerHTML = `
        <div class="toast-ic"><i class="fa-solid ${ICONS[kind] || ICONS.info}"></i></div>
        <div class="toast-body">
            <div class="toast-title">${esc(p.title || 'Laundromat')}</div>
            <div class="toast-msg">${esc(p.message || '')}</div>
        </div>`;
    wrap.appendChild(el);
    setTimeout(() => {
        el.style.transition = 'opacity .25s, transform .25s';
        el.style.opacity = '0'; el.style.transform = 'translateX(12px)';
        setTimeout(() => el.remove(), 260);
    }, Math.max(1500, p.duration || 4500));
}

// ═══════════════════════════════════════════════════════
// IN-WORLD ICON
// ═══════════════════════════════════════════════════════
const WorldIcon = (() => {
    const el = $('#world-3d-icon');
    return {
        show(msg) {
            if (!el) return;
            const x = (Number(msg.x) || 0) * window.innerWidth;
            const y = (Number(msg.y) || 0) * window.innerHeight;
            const scale = Number(msg.scale) || 1;
            el.style.left = x + 'px';
            el.style.top  = y + 'px';
            el.style.transform = `translate(-50%, -50%) scale(${scale})`;
            const ic = $('#w3d-icon'); if (ic) ic.className = 'fa-solid fa-' + (msg.icon || 'soap');
            const lbl = $('#w3d-label'); if (lbl && msg.label) lbl.textContent = msg.label;
            const keyEl = document.querySelector('.w3d-key'); if (keyEl) keyEl.textContent = msg.key || 'E';
            el.hidden = false;
        },
        hide() { if (el) el.hidden = true; },
    };
})();

// ═══════════════════════════════════════════════════════
// PANEL
// ═══════════════════════════════════════════════════════
const RING_R = 76;
const RING_C = 2 * Math.PI * RING_R;

const Panel = (() => {
    const el = $('#panel');
    let timer = null;
    let remaining = 0, total = 0, ready = false;

    function stopTimer() { if (timer) { clearInterval(timer); timer = null; } }

    function setStatus() {
        const pill = $('#status-pill'), txt = $('#status-text');
        if (!pill || !txt) return;
        const m = Runtime.machine;
        pill.classList.remove('is-idle', 'is-washing', 'is-ready');
        if (m && m.progress) {
            if (ready || m.progress.ready) { pill.classList.add('is-ready'); txt.textContent = t('ui_status_ready'); }
            else { pill.classList.add('is-washing'); txt.textContent = t('ui_status_washing'); }
        } else {
            pill.classList.add('is-idle'); txt.textContent = t('ui_status_idle');
        }
    }

    // ── Cleaners card (static markup, dynamic numbers) ──
    function renderCleaners() {
        const m = Runtime.machine, eco = Runtime.economy;
        const max = eco.maxCleaners || 500;
        const cnt = (m && m.cleaners) || 0;
        $('#cleaners-count').textContent = fmtInt(cnt);
        $('#cleaners-max').textContent = '/ ' + fmtInt(max);
        const fill = $('#cleaners-fill');
        const pct = Math.max(0, Math.min(100, (cnt / max) * 100));
        fill.style.width = pct + '%';
        fill.classList.toggle('is-empty', cnt <= 0);
        fill.classList.toggle('is-low', cnt > 0 && pct < 20);
        $('#player-cleaners').textContent = fmtInt(Runtime.player.cleaners);
        const dep = $('#btn-deposit');
        if (dep) dep.classList.toggle('is-disabled', (Runtime.player.cleaners || 0) <= 0);
    }

    // ── Wash card ──
    function renderWash() {
        const card = $('#wash-card');
        const m = Runtime.machine;
        if (!card || !m) return;

        if (m.progress) {
            stopTimer();
            total = m.progress.total || 1;
            remaining = Math.max(0, m.progress.remaining || 0);
            ready = m.progress.ready || remaining <= 0;
            const showCancel = Runtime.features.cancel !== false;
            card.innerHTML = `
                <div class="card-head">
                    <div class="card-ic"><i class="fa-solid fa-soap"></i></div>
                    <div class="card-head-tx">
                        <div class="card-title">${esc(t('ui_active'))}</div>
                        <div class="card-sub">${esc(t('ui_wash_sub'))}</div>
                    </div>
                </div>
                <div class="wash-active">
                    <div class="ring-wrap">
                        <svg class="ring" viewBox="0 0 168 168">
                            <defs><linearGradient id="washGrad" x1="0" y1="0" x2="1" y2="1">
                                <stop offset="0" stop-color="var(--brand-500)"></stop>
                                <stop offset="1" stop-color="var(--accent)"></stop>
                            </linearGradient></defs>
                            <circle class="ring-track" cx="84" cy="84" r="${RING_R}"></circle>
                            <circle class="ring-arc" id="ring-arc" cx="84" cy="84" r="${RING_R}"
                                stroke-dasharray="${RING_C}" stroke-dashoffset="${RING_C}"></circle>
                        </svg>
                        <div class="ring-center">
                            <div class="ring-time" id="ring-time">00:00</div>
                            <div class="ring-label">${esc(t('ui_remaining'))}</div>
                            <div class="ring-pct" id="ring-pct">0%</div>
                        </div>
                    </div>
                    <div class="wash-flow">
                        <div class="flow-side">
                            <div class="flow-k">${esc(t('ui_dirty'))}</div>
                            <div class="flow-v dirty">${esc(fmtMoney(m.progress.amount))}</div>
                        </div>
                        <div class="flow-arrow"><i class="fa-solid fa-arrow-right-long"></i></div>
                        <div class="flow-side">
                            <div class="flow-k">${esc(t('ui_payout'))}</div>
                            <div class="flow-v clean">${esc(fmtMoney(m.progress.result))}</div>
                        </div>
                    </div>
                    <div class="wash-actions">
                        ${showCancel ? `<button class="btn btn-danger" id="wash-cancel"><i class="fa-solid fa-xmark"></i>${esc(t('ui_cancel'))}</button>` : ''}
                        <button class="btn btn-success btn-block" id="wash-collect"><i class="fa-solid fa-hand-holding-dollar"></i>${esc(t('ui_collect'))}</button>
                    </div>
                </div>`;
            on($('#wash-cancel'), 'click', confirmCancel);
            on($('#wash-collect'), 'click', () => act('collect', {}, $('#wash-collect')));
            tickRender();
            timer = setInterval(() => {
                if (remaining > 0) { remaining -= 1; tickRender(); }
                if (remaining <= 0 && !ready) { ready = true; tickRender(); setStatus(); }
            }, 1000);
        } else {
            stopTimer(); ready = false;
            // Preserve any amount the player is mid-typing across a
            // re-render (e.g. a machineChanged push from another actor).
            const prevInput = $('#wash-input');
            const prevVal = prevInput ? prevInput.value : '';
            const hadFocus = document.activeElement === prevInput;
            const sym = Runtime.currency.symbol || '$';
            card.innerHTML = `
                <div class="card-head">
                    <div class="card-ic ic-green"><i class="fa-solid fa-money-bill-transfer"></i></div>
                    <div class="card-head-tx">
                        <div class="card-title">${esc(t('ui_wash'))}</div>
                        <div class="card-sub">${esc(t('ui_wash_sub'))}</div>
                    </div>
                </div>
                <div class="wash-amount">
                    <span class="cur">${esc(sym)}</span>
                    <input id="wash-input" type="number" min="1" inputmode="numeric" placeholder="${esc(t('ui_amount_ph'))}">
                    <button class="chip" id="wash-max" type="button">${esc(t('ui_max'))}</button>
                </div>
                <div class="stat-grid">
                    <div class="stat"><div class="stat-k"><i class="fa-solid fa-box-open"></i>${esc(t('ui_on_hand'))}</div><div class="stat-v" id="st-dirty">${esc(fmtMoney(Runtime.player.dirty))}</div></div>
                    <div class="stat"><div class="stat-k"><i class="fa-solid fa-bottle-droplet"></i>${esc(t('ui_needs'))}</div><div class="stat-v" id="st-need">0</div></div>
                    <div class="stat"><div class="stat-k"><i class="fa-solid fa-gauge-high"></i>${esc(t('ui_capacity'))}</div><div class="stat-v" id="st-cap">${esc(fmtMoney(m.limit))}</div></div>
                    <div class="stat"><div class="stat-k"><i class="fa-solid fa-hand-holding-dollar"></i>${esc(t('ui_you_get'))}</div><div class="stat-v is-good" id="st-get">${esc(sym)}0</div></div>
                </div>
                <button class="btn btn-primary btn-block btn-lg is-disabled" id="wash-start"><i class="fa-solid fa-soap"></i>${esc(t('ui_start'))}</button>`;
            const input = $('#wash-input');
            if (prevVal) input.value = prevVal;
            on(input, 'input', updateWashCalc);
            on(input, 'keydown', (e) => { if (e.key === 'Enter') startWash(); });
            on($('#wash-max'), 'click', () => {
                const cap = m.limit || 0;
                input.value = String(Math.min(cap, Math.floor(Runtime.player.dirty || 0)) || cap);
                updateWashCalc(); input.focus();
            });
            on($('#wash-start'), 'click', startWash);
            updateWashCalc();
            if (hadFocus) input.focus();
        }
    }

    function tickRender() {
        const arc = $('#ring-arc'), time = $('#ring-time'), pct = $('#ring-pct');
        if (!arc) return;
        const done = total > 0 ? (total - remaining) / total : 1;
        const clamped = Math.max(0, Math.min(1, done));
        arc.style.strokeDashoffset = String(RING_C * (1 - clamped));
        if (time) time.textContent = ready ? t('ui_complete') : fmtTime(remaining);
        if (pct) pct.textContent = Math.round(clamped * 100) + '%';
        const collect = $('#wash-collect');
        if (collect) collect.classList.toggle('is-disabled', !ready);
    }

    function updateWashCalc() {
        const m = Runtime.machine, eco = Runtime.economy;
        const input = $('#wash-input'); if (!input) return;
        const amount = Math.floor(Number(input.value) || 0);
        const base = eco.baseValue || 1000;
        const need = amount > 0 ? Math.ceil(amount / base) * (eco.cleanerCost || 1) : 0;
        const tax = Math.floor(amount * ((eco.taxPercent || 0) / 100));
        const get = Math.max(0, amount - tax);

        const needEl = $('#st-need'), getEl = $('#st-get');
        if (needEl) {
            needEl.textContent = fmtInt(need);
            needEl.classList.toggle('is-bad', need > ((m && m.cleaners) || 0));
            needEl.classList.remove('is-good');
        }
        if (getEl) getEl.textContent = fmtMoney(get);

        const overCap = amount > (m.limit || 0);
        const noDirty = amount > (Runtime.player.dirty || 0);
        const noClean = need > ((m && m.cleaners) || 0);
        const valid = amount > 0 && !overCap && !noDirty && !noClean;
        const start = $('#wash-start');
        if (start) start.classList.toggle('is-disabled', !valid);
    }

    function startWash() {
        const input = $('#wash-input'); if (!input) return;
        const amount = Math.floor(Number(input.value) || 0);
        if (amount <= 0) return;
        act('start_wash', { amount }, $('#wash-start'));
    }

    // ── Upgrades ──
    function renderUpgrades() {
        const wrap = $('#upg-wrap'), grid = $('#upg-grid');
        const ups = Runtime.upgrades || {}, feats = Runtime.features || {};
        const m = Runtime.machine;
        if (!grid || !m) return;
        const order = [
            { key: 'efficiency', feat: 'upgradeEffic' },
            { key: 'potency',    feat: 'upgradePotncy' },
        ];
        let html = '';
        let any = false;
        for (const { key, feat } of order) {
            const def = ups[key];
            if (!def || def.enabled === false) continue;
            if (feats[feat] === false || feats.upgrades === false) continue;
            any = true;
            const levels = def.levels || [];
            const max = levels.length;
            const cur = (m.upgrades && m.upgrades[key]) || 0;
            const maxed = cur >= max;
            const price = maxed ? 0 : (levels[cur] && levels[cur].price) || 0;
            const cant = !maxed && (Runtime.player.upgradeBalance || 0) < price;
            let segs = '';
            for (let i = 0; i < max; i++) segs += `<div class="seg ${i < cur ? 'on' : ''}"></div>`;
            html += `
                <div class="upg-card ${maxed ? 'maxed' : ''}">
                    <div class="upg-top">
                        <div class="upg-ic"><i class="${esc(def.icon || 'fa-solid fa-arrow-up')}"></i></div>
                        <div class="upg-meta">
                            <div class="upg-name">${esc(t('up_' + key))}
                                <span class="upg-info"><i class="fa-solid fa-circle-info"></i>
                                    <span class="tip">${esc(t('up_' + key + '_desc'))}</span>
                                </span>
                            </div>
                            <div class="upg-lvl">${esc(t('ui_level'))} <b>${cur}</b> / ${max}</div>
                        </div>
                    </div>
                    <div class="segs">${segs}</div>
                    <div class="upg-foot">
                        ${maxed
                            ? `<span class="maxed-tag"><i class="fa-solid fa-check"></i>${esc(t('ui_max_level'))}</span>`
                            : `<div class="upg-price ${cant ? 'cant' : ''}">${esc(t('ui_upgrade'))} · <b>${esc(fmtCost(price))}</b></div>
                               <button class="btn btn-primary ${cant ? 'is-disabled' : ''}" data-upg="${key}" data-price="${price}">${esc(t('ui_upgrade'))}</button>`}
                    </div>
                </div>`;
        }
        grid.innerHTML = html;
        if (wrap) wrap.hidden = !any;
        grid.querySelectorAll('[data-upg]').forEach(btn => {
            on(btn, 'click', () => confirmUpgrade(btn.dataset.upg, Number(btn.dataset.price)));
        });
    }

    // ── Footer meta ──
    function renderMeta() {
        const eco = Runtime.economy, m = Runtime.machine;
        $('#meta-tax').textContent = (eco.taxPercent || 0) + '%';
        $('#meta-speed').textContent = `${eco.washTime || 0}s / ${fmtMoney(eco.baseValue || 0)}`;
        $('#meta-cap').textContent = fmtMoney((m && m.limit) || 0);
    }

    function render() {
        const m = Runtime.machine; if (!m) return;
        const lbl = $('#machine-label'); if (lbl) lbl.textContent = m.label || t('ui_subtitle');
        setStatus();
        renderCleaners();
        renderWash();
        renderUpgrades();
        renderMeta();
    }

    return {
        open(p) {
            if (p.machine) Runtime.machine = p.machine;
            if (p.player)  Runtime.player = p.player;
            el.hidden = false;
            el.style.animation = 'none'; el.offsetHeight; el.style.animation = '';
            render();
        },
        update(p) {
            if (p.machine) Runtime.machine = p.machine;
            if (p.player)  Runtime.player = p.player;
            if (el.hidden) return;
            render();
        },
        close() {
            stopTimer();
            el.hidden = true;
            Modal.close();
        },
    };
})();

// ═══════════════════════════════════════════════════════
// MODAL
// ═══════════════════════════════════════════════════════
const Modal = (() => {
    const scrim = $('#modal');
    let onOk = null;
    function close() { if (scrim) scrim.hidden = true; onOk = null; }
    function open({ icon, iconClass, title, text, confirmText, confirmClass, onConfirm }) {
        const ic = $('#modal-ic');
        ic.className = 'modal-ic' + (iconClass ? ' ' + iconClass : '');
        ic.innerHTML = `<i class="fa-solid ${icon || 'fa-triangle-exclamation'}"></i>`;
        $('#modal-title').textContent = title || '';
        $('#modal-text').innerHTML = text || '';
        const cf = $('#modal-confirm');
        cf.textContent = confirmText || t('md_confirm');
        cf.className = 'btn ' + (confirmClass || 'btn-primary');
        onOk = onConfirm;
        scrim.hidden = false;
    }
    on($('#modal-confirm'), 'click', () => { const f = onOk; close(); if (f) f(); });
    on($('#modal-cancel'), 'click', close);
    on(scrim, 'click', (e) => { if (e.target === scrim) close(); });
    return { open, close };
})();

// ═══════════════════════════════════════════════════════
// SETTINGS (per-player — persisted via KVP through Lua)
// ═══════════════════════════════════════════════════════
const Settings = (() => {
    const scrim = $('#settings');
    const persist = () => post('save_prefs', Runtime.prefs);

    function renderSwatches() {
        const presets = (Runtime.colorPresets && Runtime.colorPresets.length)
            ? Runtime.colorPresets : ['#ff5be4'];
        const brandWrap = $('#set-brand');
        brandWrap.innerHTML = presets.map(c =>
            `<div class="swatch" data-brand="${esc(c)}" style="background:${esc(c)}"></div>`).join('');
        const bgWrap = $('#set-bg');
        bgWrap.innerHTML = BG_PRESETS.map(c =>
            `<div class="swatch" data-bg="${esc(c)}" style="background:${esc(c)}"></div>`).join('');
        brandWrap.querySelectorAll('[data-brand]').forEach(el => on(el, 'click', () => {
            Runtime.prefs.brand = el.dataset.brand; applyPrefs(Runtime.prefs); persist(); sync();
        }));
        bgWrap.querySelectorAll('[data-bg]').forEach(el => on(el, 'click', () => {
            Runtime.prefs.bg = el.dataset.bg; applyPrefs(Runtime.prefs); persist(); sync();
        }));
    }

    function sync() {
        const p = Runtime.prefs;
        const curBrand = String(p.brand || (Runtime.theme && Runtime.theme.brand) || '').toLowerCase();
        $('#set-brand').querySelectorAll('[data-brand]').forEach(el =>
            el.classList.toggle('active', (el.dataset.brand || '').toLowerCase() === curBrand));
        const curBg = String(p.bg || (Runtime.theme && Runtime.theme.bgCard) || '#1A1A1B').toLowerCase();
        $('#set-bg').querySelectorAll('[data-bg]').forEach(el =>
            el.classList.toggle('active', (el.dataset.bg || '').toLowerCase() === curBg));
        $('#set-pos').querySelectorAll('[data-pos]').forEach(el =>
            el.classList.toggle('active', el.dataset.pos === (p.position || 'left')));
        $('#set-size').querySelectorAll('[data-size]').forEach(el =>
            el.classList.toggle('active', Number(el.dataset.size) === Number(p.scale || 1)));
        const op = Math.round((p.opacity != null ? p.opacity : 1) * 100);
        const slider = $('#set-opacity'); if (slider) slider.value = String(op);
        const ov = $('#set-opacity-val'); if (ov) ov.textContent = op + '%';
    }

    on($('#set-pos'), 'click', (e) => {
        const b = e.target.closest('[data-pos]'); if (!b) return;
        Runtime.prefs.position = b.dataset.pos; applyLayout(Runtime.prefs); persist(); sync();
    });
    on($('#set-size'), 'click', (e) => {
        const b = e.target.closest('[data-size]'); if (!b) return;
        Runtime.prefs.scale = Number(b.dataset.size); applyLayout(Runtime.prefs); persist(); sync();
    });
    on($('#set-opacity'), 'input', (e) => {
        Runtime.prefs.opacity = Number(e.target.value) / 100;
        const ov = $('#set-opacity-val'); if (ov) ov.textContent = e.target.value + '%';
        applyLayout(Runtime.prefs);
    });
    on($('#set-opacity'), 'change', persist);
    on($('#settings-close'), 'click', () => close());
    on($('#settings-reset'), 'click', () => {
        Runtime.prefs = Object.assign({}, DEFAULT_PREFS);
        applyPrefs(Runtime.prefs); persist(); renderSwatches(); sync();
    });
    on(scrim, 'click', (e) => { if (e.target === scrim) close(); });

    function open() { renderSwatches(); sync(); scrim.hidden = false; }
    function close() { scrim.hidden = true; }
    return { open, close, isOpen: () => !scrim.hidden };
})();

on($('#btn-settings'), 'click', () => Settings.open());

// ═══════════════════════════════════════════════════════
// CUSTOM DROPDOWN (themed) — used by the creator menu
// ═══════════════════════════════════════════════════════
function closeAllDropdowns() {
    document.querySelectorAll('.dd.open').forEach(d => {
        d.classList.remove('open');
        const m = d.querySelector('.dd-menu'); if (m) m.hidden = true;
    });
}
document.addEventListener('click', closeAllDropdowns);

function buildDropdown(container, { items, value, placeholder, onPick }) {
    if (!container) return;
    const sel = (items || []).find(i => String(i.value) === String(value));
    container.classList.add('dd');
    container.innerHTML = `
        <button class="dd-btn" type="button">
            <span class="dd-val">${esc(sel ? sel.label : (placeholder || '—'))}</span>
            <i class="fa-solid fa-chevron-down"></i>
        </button>
        <div class="dd-menu" hidden>${
            (items && items.length)
                ? items.map(i => `<div class="dd-item" data-v="${esc(i.value)}">${esc(i.label)}</div>`).join('')
                : '<div class="dd-item muted">—</div>'
        }</div>`;
    const btn  = container.querySelector('.dd-btn');
    const menu = container.querySelector('.dd-menu');
    on(btn, 'click', (e) => {
        e.stopPropagation();
        const isOpen = container.classList.contains('open');
        closeAllDropdowns();
        if (!isOpen) { container.classList.add('open'); menu.hidden = false; }
    });
    menu.querySelectorAll('.dd-item[data-v]').forEach(el => on(el, 'click', (e) => {
        e.stopPropagation();
        container.classList.remove('open'); menu.hidden = true;
        onPick(el.dataset.v, el.textContent);
    }));
}

// ═══════════════════════════════════════════════════════
// CREATOR — creation menu (model + access by job/grade)
// ═══════════════════════════════════════════════════════
const CreatorMenu = (() => {
    const scrim = $('#creator-menu');
    let models = [], jobs = [];
    let state = { model: null, invisible: false, public: false, jobGrades: {} };

    function renderModels() {
        const wrap = $('#cm-models');
        wrap.innerHTML = models.map(m =>
            `<div class="cm-model" data-model="${esc(m.model)}"><i class="fa-solid fa-cube"></i>${esc(m.label || m.model)}</div>`).join('');
        wrap.querySelectorAll('[data-model]').forEach(el => on(el, 'click', () => {
            state.model = el.dataset.model; syncModels(); syncPlace();
        }));
        syncModels();
    }
    function syncModels() {
        $('#cm-models').querySelectorAll('[data-model]').forEach(el =>
            el.classList.toggle('active', el.dataset.model === state.model));
    }

    function renderJobDD() {
        const avail = jobs.filter(j => !(j.name in state.jobGrades))
                          .map(j => ({ value: j.name, label: j.label || j.name }));
        buildDropdown($('#cm-job-dd'), {
            items: avail, value: '', placeholder: t('cr_add_job'),
            onPick: (jobName) => { state.jobGrades[jobName] = 0; renderJobList(); renderJobDD(); syncPlace(); },
        });
    }

    function renderJobList() {
        const wrap = $('#cm-joblist');
        const names = Object.keys(state.jobGrades);
        const empty = $('#cm-jobs-empty'); if (empty) empty.hidden = names.length > 0;
        wrap.innerHTML = '';
        names.forEach(jobName => {
            const job = jobs.find(j => j.name === jobName) || { name: jobName, label: jobName, grades: [] };
            const row = document.createElement('div');
            row.className = 'cm-jobrow';
            row.innerHTML = `<span class="cm-jobname">${esc(job.label || jobName)}</span><div class="dd"></div><button class="cm-jobrm" type="button"><i class="fa-solid fa-xmark"></i></button>`;
            wrap.appendChild(row);
            const grades = (job.grades && job.grades.length) ? job.grades : [{ grade: 0, label: 'Grade 0' }];
            const items = grades.map(g => ({ value: g.grade, label: `${t('cr_grade')} ${g.grade}` }));
            buildDropdown(row.querySelector('.dd'), {
                items, value: state.jobGrades[jobName], placeholder: t('cr_grade'),
                onPick: (v) => { state.jobGrades[jobName] = Number(v) || 0; },
            });
            on(row.querySelector('.cm-jobrm'), 'click', () => {
                delete state.jobGrades[jobName]; renderJobList(); renderJobDD(); syncPlace();
            });
        });
    }

    function syncPlace() {
        $('#cm-place').classList.toggle('is-disabled', !state.model);
    }

    on($('#cm-public'), 'change', () => {
        state.public = $('#cm-public').checked;
        $('#cm-jobs-wrap').style.display = state.public ? 'none' : '';
    });
    on($('#cm-invisible'), 'change', () => { state.invisible = $('#cm-invisible').checked; });
    on($('#cm-close'),  'click', () => { post('creator_menu_cancel'); close(); });
    on($('#cm-cancel'), 'click', () => { post('creator_menu_cancel'); close(); });
    on($('#cm-place'),  'click', () => {
        if (!state.model) return;
        const permission = state.public ? { public: true } : { jobGrades: state.jobGrades };
        post('creator_menu_place', { model: state.model, invisible: state.invisible, permission });
        close();
    });

    function open(payload) {
        models = (payload && payload.models) || [];
        jobs   = (payload && payload.jobs) || [];
        state  = { model: (models[0] && models[0].model) || null, invisible: false, public: false, jobGrades: {} };
        $('#cm-public').checked = false;
        $('#cm-invisible').checked = false;
        $('#cm-jobs-wrap').style.display = '';
        renderModels(); renderJobDD(); renderJobList(); syncPlace();
        scrim.hidden = false;
    }
    function close() { scrim.hidden = true; closeAllDropdowns(); }
    return { open, close, isOpen: () => !scrim.hidden };
})();

// Placement controls HUD
function setHudInvis(on) {
    const el = $('#cr-hud-invis'); if (!el) return;
    el.textContent = on ? 'ON' : 'OFF';
    el.classList.toggle('is-on', !!on);
    el.classList.toggle('is-off', !on);
}

// ═══════════════════════════════════════════════════════
// ACTIONS
// ═══════════════════════════════════════════════════════
async function act(name, payload, btn) {
    // Use a dedicated loading class so we never fight the state-driven
    // 'is-disabled' that renderCleaners()/render() own.
    if (btn) btn.classList.add('is-loading');
    Sound('SELECT');
    await post(name, payload);
    // Repaint arrives via the Lua-pushed "update" message; just
    // clear the loading state if the button still exists.
    if (btn) btn.classList.remove('is-loading');
}

function confirmCancel() {
    Modal.open({
        icon: 'fa-rotate-left', iconClass: 'danger',
        title: t('md_cancel_title'), text: esc(t('md_cancel_text')),
        confirmText: t('ui_cancel'), confirmClass: 'btn-danger',
        onConfirm: () => act('cancel_wash', {}),
    });
}

function confirmUpgrade(kind, price) {
    const def = Runtime.upgrades[kind];
    const max = (def && def.levels && def.levels.length) || 0;
    const cur = (Runtime.machine && Runtime.machine.upgrades && Runtime.machine.upgrades[kind]) || 0;
    if (cur >= max) return;
    if ((Runtime.player.upgradeBalance || 0) < price) { return; }
    const name = t('up_' + kind);
    Modal.open({
        icon: 'fa-arrow-up', iconClass: 'brand',
        title: t('md_upgrade_title'),
        text: t('md_upgrade_text', `<b>${esc(name)}</b>`, cur + 1, `<b>${esc(fmtCost(price))}</b>`),
        confirmText: t('md_confirm'),
        onConfirm: () => act('upgrade', { kind }),
    });
}

function doDeposit() {
    const input = $('#cleaner-input');
    const amount = Math.floor(Number(input && input.value) || 0);
    if (amount <= 0) return;
    act('deposit_cleaners', { amount }, $('#btn-deposit'));
}

function closePanel() { post('close'); Panel.close(); }

// ─── Static wiring (cleaners card + header) ─────────────
on($('#btn-close'), 'click', closePanel);
on($('#btn-deposit'), 'click', doDeposit);
document.querySelectorAll('.step').forEach(b => on(b, 'click', () => {
    const input = $('#cleaner-input'); if (!input) return;
    const v = Math.max(1, (Math.floor(Number(input.value) || 0)) + Number(b.dataset.step));
    input.value = String(v);
}));
on($('#cleaner-input'), 'keydown', (e) => { if (e.key === 'Enter') doDeposit(); });

// ═══════════════════════════════════════════════════════
// MESSAGE PIPE
// ═══════════════════════════════════════════════════════
window.addEventListener('message', (ev) => {
    const msg = ev.data; if (!msg || !msg.action) return;
    const p = msg.payload || {};
    switch (msg.action) {
        case 'bootstrap':
            Object.assign(Runtime, {
                theme: p.theme || {}, currency: p.currency || Runtime.currency,
                economy: p.economy || Runtime.economy, upgrades: p.upgrades || {},
                items: p.items || {}, features: p.features || {},
                colorPresets: p.colorPresets || Runtime.colorPresets,
            });
            applyTheme(p.theme);
            applyLocale(p.locale);
            applyPrefs(p.prefs || {});   // per-player overrides over the default theme
            break;
        case 'open':   Panel.open(p);   break;
        case 'update': Panel.update(p); break;
        case 'close':  Panel.close();   break;
        case 'notify': Notify(p);       break;
        case 'show3DIcon': WorldIcon.show(msg); break;
        case 'hide3DIcon': WorldIcon.hide();    break;

        // Creator
        case 'creator_menu_open':  CreatorMenu.open(p);  break;
        case 'creator_menu_close': CreatorMenu.close();  break;
        case 'creator_hud_open':   $('#creator-hud').hidden = false; setHudInvis(p.invisible); break;
        case 'creator_hud_update': setHudInvis(p.invisible); break;
        case 'creator_hud_close':  $('#creator-hud').hidden = true; break;
    }
});

window.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    if (!$('#modal').hidden) { Modal.close(); return; }
    if (CreatorMenu.isOpen()) { post('creator_menu_cancel'); CreatorMenu.close(); return; }
    if (Settings.isOpen()) { Settings.close(); return; }
    if (!$('#panel').hidden) closePanel();
});

})();
