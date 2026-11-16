/* ════════════════════════════════════════════════════════════
   APEX BILLING — UI logic
   ════════════════════════════════════════════════════════════ */
'use strict';

const $  = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
const on = (el, ev, fn) => el && el.addEventListener(ev, fn);

const RES = (() => {
    try { return window.GetParentResourceName ? GetParentResourceName() : 'apex_billing'; }
    catch (_) { return 'apex_billing'; }
})();
async function post(name, payload) {
    try {
        const res = await fetch(`https://${RES}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload || {}),
        });
        return await res.json();
    } catch (_) { return null; }
}

const COLOR_PRESETS = [
    '#1F5EFF', '#8D21E8', '#FF4F8B', '#FFA940', '#FFD43B',
    '#34C77B', '#1FB3B5', '#4E9CE5', '#E5564B', '#A8A8AD',
];
const DEFAULT_BRAND = '#1F5EFF';

// Background presets — tasteful dark surfaces. We sample only the HUE +
// saturation of a chosen colour; the surface ramp is always kept dark so
// text contrast stays readable no matter what is picked.
const BG_PRESETS = [
    '#0A0A0B', '#0B1733', '#1B0B33', '#2B0B16',
    '#07141F', '#241026', '#241603', '#101015',
];
const DEFAULT_BG = '#0A0A0B';
const SURFACE_VARS = ['--surface-0', '--surface-1', '--surface-2', '--surface-3', '--surface-4', '--line-1', '--line-2', '--line-3'];

const Runtime = { theme: {}, currency: { symbol: '$', position: 'before' }, locale: {} };
const state = {
    received: [], societyReceived: [], society: [],
    societySnap: null, societies: [], nearby: [],
    identifier: null, canIssue: false,
    // Personal (player → player) billing
    canIssuePersonal: false, sentPersonal: [], me: { name: '' },
    issueAs: 'society',   // 'society' | 'player' — only matters when both are allowed
    currentTab: 'overview', rxKind: 'nearby',
    composer: {
        title: '', notes: '',
        recipient: { id: '', name: '', type: 'player' },
        items: [{ label: '', qty: 1, price: 0 }],
    },
    prefs: loadPrefs(),
};

/* ─── Prefs (localStorage) ─── */
function loadPrefs() {
    try { return JSON.parse(localStorage.getItem('apex_billing_prefs') || '{}'); } catch (_) { return {}; }
}
function savePrefs(patch) {
    Object.assign(state.prefs, patch);
    try { localStorage.setItem('apex_billing_prefs', JSON.stringify(state.prefs)); } catch (_) {}
}

/* ─── Helpers ─── */
function money(n) {
    n = Math.floor(Number(n) || 0);
    const neg = n < 0; n = Math.abs(n);
    const cur = Runtime.currency || { symbol: '$', position: 'before' };
    const s = n.toLocaleString('en-US');
    return (neg ? '-' : '') + (cur.position === 'after' ? `${s} ${cur.symbol}` : `${cur.symbol}${s}`);
}
function currencySymbol() {
    const cur = Runtime.currency || {};
    return cur.symbol || '$';
}
function currencyPosition() {
    const cur = Runtime.currency || {};
    return cur.position === 'after' ? 'after' : 'before';
}
function numberInputValue(value, min) {
    if (value === '' || value == null) return '';
    const n = Number(value);
    if (!Number.isFinite(n)) return '';
    return Math.max(min, n);
}
function fmtDate(ts) {
    if (!ts) return '—';
    const d = new Date(Number(ts) * 1000);
    const pad = x => String(x).padStart(2, '0');
    return `${pad(d.getDate())}/${pad(d.getMonth() + 1)} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}
function statusLabel(s) {
    return ({ sent: 'Pending', paid: 'Paid', declined: 'Declined', expired: 'Expired', cancelled: 'Cancelled', draft: 'Draft' })[s] || s;
}
/* Robust formatter for created_at — the MySQL driver sometimes
   hands us a string ("2026-05-22 14:33:00"), a Date instance, or
   even a number. Normalise everything to a "DD/MM HH:mm" string.
   Without this guard, the modal renderer threw on Date objects. */
function fmtCreatedAt(v) {
    if (v == null || v === '') return '—';
    if (typeof v === 'number') return fmtDate(v);
    if (v instanceof Date) {
        const pad = x => String(x).padStart(2, '0');
        return `${pad(v.getDate())}/${pad(v.getMonth() + 1)} ${pad(v.getHours())}:${pad(v.getMinutes())}`;
    }
    const s = String(v);
    // MySQL "YYYY-MM-DD HH:mm:ss" → "DD/MM HH:mm"
    const m = s.match(/^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})/);
    if (m) return `${m[3]}/${m[2]} ${m[4]}:${m[5]}`;
    return s.slice(0, 16);
}
function escapeHtml(s) {
    return String(s || '').replace(/[&<>"']/g, c => ({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' })[c]);
}

/* ─── Brand ramp ─── */
function _hexToRgb(hex) {
    const h = (hex || '').replace('#', '');
    const n = h.length === 3 ? h.split('').map(c => c + c).join('') : h;
    return { r: parseInt(n.slice(0,2), 16) || 0, g: parseInt(n.slice(2,4), 16) || 0, b: parseInt(n.slice(4,6), 16) || 0 };
}
function _rgbToHsl({ r, g, b }) {
    r/=255; g/=255; b/=255;
    const mx = Math.max(r,g,b), mn = Math.min(r,g,b);
    let h, s, l = (mx + mn) / 2;
    if (mx === mn) { h = s = 0; }
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
    if (s === 0) { r = g = b = l; }
    else {
        const q = l < .5 ? l * (1 + s) : l + s - l * s;
        const p = 2 * l - q;
        r = hue2rgb(p, q, h + 1/3); g = hue2rgb(p, q, h); b = hue2rgb(p, q, h - 1/3);
    }
    const to = (x) => Math.round(x * 255).toString(16).padStart(2, '0');
    return '#' + to(r) + to(g) + to(b);
}
function _hexToRgba(hex, a) { const { r, g, b } = _hexToRgb(hex); return `rgba(${r},${g},${b},${a})`; }
function applyBrand(hex) {
    if (!hex) return;
    const root = document.documentElement.style;
    const { h, s } = _rgbToHsl(_hexToRgb(hex));
    const ramp = { 50: 96, 100: 92, 200: 84, 300: 75, 400: 65, 500: null, 600: 47, 700: 38, 800: 30, 900: 22 };
    Object.entries(ramp).forEach(([step, l]) => {
        const v = l == null ? hex : _hslToHex(h, s, l);
        root.setProperty(`--brand-${step}`, v);
    });
    [['a05',.05],['a08',.08],['a12',.12],['a18',.18],['a25',.25],['a40',.40]]
        .forEach(([k,a]) => root.setProperty(`--brand-${k}`, _hexToRgba(hex, a)));
}

/* ─── Background ramp ─── */
// Re-tint every dark surface from a single base colour. Only the hue +
// saturation are sampled; a fixed (dark) lightness is forced per step so
// the panel always stays legible.
function applyBackground(hex) {
    if (!hex) return;
    const root = document.documentElement.style;
    // Default → revert to the stylesheet's original dark surfaces (no tint),
    // exactly as the script ships out of the box.
    if (String(hex).toLowerCase() === DEFAULT_BG.toLowerCase()) {
        SURFACE_VARS.forEach((v) => root.removeProperty(v));
        return;
    }
    const { h, s } = _rgbToHsl(_hexToRgb(hex));
    const sat = Math.min(s, 42);
    const steps = {
        '--surface-0': 4.5, '--surface-1': 8, '--surface-2': 11,
        '--surface-3': 14.5, '--surface-4': 18.5,
        '--line-1': 12.5, '--line-2': 16.5, '--line-3': 23,
    };
    Object.entries(steps).forEach(([v, l]) => root.setProperty(v, _hslToHex(h, sat, l)));
}

/* ─── Position ─── */
function applyPosition(pos) {
    $('#billing-overlay').dataset.pos = pos || 'center';
    $$('.pos-btn').forEach(b => b.classList.toggle('active', b.dataset.pos === (pos || 'center')));
}

/* ─── Notify / Dialog ─── */
const Notify = (() => {
    const host = $('#notify-container');
    return ({ title = 'Billing', message = '', type = 'info', duration = 3500 } = {}) => {
        const el = document.createElement('div');
        el.className = `notify-card ${type}`;
        el.innerHTML = `<strong>${escapeHtml(title)}</strong><small>${escapeHtml(message)}</small>`;
        host.appendChild(el);
        setTimeout(() => el.remove(), duration);
    };
})();
function confirmDlg(title, body) {
    return new Promise(resolve => {
        $('#dlg-title').textContent = title; $('#dlg-body').textContent = body;
        $('#dlg-input-wrap').hidden = true;
        $('#dialog-overlay').hidden = false;
        const ok = $('#dlg-ok'), cancel = $('#dlg-cancel');
        const close = (v) => { $('#dialog-overlay').hidden = true; ok.onclick = cancel.onclick = null; resolve(v); };
        ok.onclick     = () => close(true);
        cancel.onclick = () => close(false);
    });
}

/* ════════════════════════════════════════════════════════════
   TABS + FOOTER
   ════════════════════════════════════════════════════════════ */
function switchTab(name) {
    state.currentTab = name;
    // Scoped to the player panel — the admin panel reuses .bp-tab
    // for its own nav and must not be swept by this.
    $$('#billing-overlay .bp-tab').forEach(b => b.classList.toggle('active', b.dataset.tab === name));
    $$('.pane').forEach(p => p.hidden = p.dataset.pane !== name);
    $('#bp-footer').hidden = name !== 'new';
    $('#bp-body').scrollTop = 0;
    $$('.inv-list').forEach(el => el.scrollTop = 0);
}

/* ════════════════════════════════════════════════════════════
   COMPOSER
   ════════════════════════════════════════════════════════════ */
function renderLineItems() {
    const wrap = $('#li-table'); wrap.innerHTML = '';
    state.composer.items.forEach((it, i) => {
        const row = document.createElement('div');
        row.className = 'li-row';
        const qtyValue = numberInputValue(it.qty, 1);
        const priceValue = numberInputValue(it.price, 0);
        const moneyPos = currencyPosition();
        row.innerHTML = `
            <input class="apex-input" placeholder="Description" value="${escapeHtml(it.label || '')}">
            <input class="apex-input" type="number" min="1" placeholder="Qty" value="${qtyValue === '' ? '' : qtyValue}">
            <div class="li-money ${moneyPos === 'after' ? 'is-after' : ''}">
                <span>${escapeHtml(currencySymbol())}</span>
                <input class="apex-input" type="number" min="0" step="1" placeholder="Value" value="${priceValue === '' ? '' : priceValue}">
            </div>
            <button class="li-del" title="Remove"><i class="fa-solid fa-xmark"></i></button>
        `;
        const [a, b, moneyWrap, d] = row.children;
        const c = $('input', moneyWrap);
        on(a, 'input', (e) => { it.label = e.target.value; updateTotals(); });
        on(b, 'input', (e) => {
            it.qty = e.target.value === '' ? '' : Math.max(1, Number(e.target.value) || 1);
            updateTotals();
        });
        on(c, 'input', (e) => {
            it.price = e.target.value === '' ? '' : Math.max(0, Number(e.target.value) || 0);
            updateTotals();
        });
        on(d, 'click', () => {
            state.composer.items.splice(i, 1);
            if (!state.composer.items.length) state.composer.items.push({ label: '', qty: 1, price: 0 });
            renderLineItems(); updateTotals();
        });
        wrap.appendChild(row);
    });
}
function renderQuickAmounts() {
    const wrap = $('#qa-row'); wrap.innerHTML = '';
    (Runtime.quickAmounts || [50, 100, 250, 500, 1000, 2500]).forEach(a => {
        const b = document.createElement('button');
        b.className = 'qa-pill'; b.textContent = '+' + money(a);
        on(b, 'click', () => {
            const last = state.composer.items[state.composer.items.length - 1];
            if (last && !last.price) { last.price = a; if (!last.label) last.label = 'Item'; }
            else state.composer.items.push({ label: 'Item', qty: 1, price: a });
            renderLineItems(); updateTotals();
        });
        wrap.appendChild(b);
    });
}
function totalsOf(items, vat) {
    let sub = 0;
    items.forEach(it => { sub += (Math.max(1, Number(it.qty) || 1)) * (Math.max(0, Number(it.price) || 0)); });
    const tax = Math.floor(sub * (vat / 100));
    return { sub, tax, total: sub + tax };
}
function updateTotals() {
    const vat = Math.max(0, Number($('#inv-vat').value) || 0);
    const { sub, tax, total } = totalsOf(state.composer.items, vat);
    $('#bp-sub').textContent   = money(sub);
    $('#bp-tax').textContent   = money(tax);
    $('#bp-total').textContent = money(total);
    $('#bp-vat-r').textContent = vat + '%';
}

/* ─── Who is billing: society or personal ─── */
// Returns 'society', 'player' or null (cannot issue at all).
function issueMode() {
    const soc = !!state.canIssue, per = !!state.canIssuePersonal;
    if (soc && per) return state.issueAs === 'player' ? 'player' : 'society';
    if (soc) return 'society';
    if (per) return 'player';
    return null;
}
function switchIssueAs(as) {
    state.issueAs = as === 'player' ? 'player' : 'society';
    applyIssuanceGate(state.canIssue, !!state.societySnap);
}
function renderIssuer() {
    const icon = $('#issuer-icon');
    if (issueMode() === 'player') {
        $('#issuer-label').textContent = (state.me && state.me.name) || 'You';
        $('#issuer-grade').textContent = 'Personal invoice · paid into your bank';
        if (icon) icon.className = 'fa-solid fa-user';
    } else if (state.societySnap) {
        $('#issuer-label').textContent = state.societySnap.label || '—';
        $('#issuer-grade').textContent = `Grade ${state.societySnap.grade}${state.societySnap.isBoss ? ' · Boss' : ''}`;
        if (icon) icon.className = 'fa-solid fa-briefcase';
    }
}

/* ─── Recipient picker (nearby / id / society) ─── */
function switchRxKind(kind) {
    state.rxKind = kind;
    $$('.rx-tab').forEach(b => b.classList.toggle('active', b.dataset.rx === kind));
    $('#rx-nearby-select').hidden  = kind !== 'nearby';
    $('#rx-society-select').hidden = kind !== 'society';
}
function renderNearby() {
    const sel = $('#rx-nearby-select');
    sel.innerHTML = '<option value="">Pick a nearby player…</option>';
    (state.nearby || []).forEach(p => {
        const opt = document.createElement('option');
        opt.value = p.identifier;
        opt.dataset.name = p.name;
        opt.textContent = p.name;
        sel.appendChild(opt);
    });
}
function renderSocieties() {
    const sel = $('#rx-society-select');
    sel.innerHTML = '<option value="">Pick a society…</option>';
    (state.societies || []).forEach(s => {
        // Don't allow billing your own society
        if (state.societySnap && s.name === state.societySnap.name) return;
        const opt = document.createElement('option');
        opt.value = s.name;
        opt.dataset.name = s.label;
        opt.textContent = s.label;
        sel.appendChild(opt);
    });
}
function currentRecipient() {
    if (state.rxKind === 'society') {
        const sel = $('#rx-society-select');
        const opt = sel.options[sel.selectedIndex];
        return { id: sel.value, name: opt && opt.dataset.name || '', type: 'society' };
    }
    const sel = $('#rx-nearby-select');
    const opt = sel.options[sel.selectedIndex];
    return { id: sel.value, name: opt && opt.dataset.name || '', type: 'player' };
}

/* ─── Send / Preview ─── */
async function sendInvoice() {
    const c = state.composer;
    const vat = Math.max(0, Number($('#inv-vat').value) || 0);
    const dueDays = Math.max(1, Number($('#inv-due').value) || 7);
    const dueAt = Math.floor(Date.now() / 1000) + dueDays * 86400;
    const rx = currentRecipient();
    if (!rx.id) { Notify({ type: 'error', message: 'Pick a recipient.' }); return; }
    const items = c.items
        .map(it => ({ label: (it.label || '').trim() || 'Item', qty: Math.max(1, Number(it.qty) || 1), price: Math.max(0, Number(it.price) || 0) }))
        .filter(it => it.price > 0);
    if (!items.length) { Notify({ type: 'error', message: 'Add at least one paid line item.' }); return; }
    const r = await post('invoice_issue', {
        issueAs: issueMode() || 'society',
        recipientId: rx.id, recipientName: rx.name, recipientType: rx.type,
        title: ($('#inv-title').value || '').trim() || 'Invoice',
        items, vatRate: vat / 100, dueAt,
        notes: ($('#inv-notes').value || '').trim(),
    });
    if (r && r.ok) {
        Notify({ type: 'success', title: 'Invoice sent', message: 'Recipient notified.' });
        state.composer = { title: '', notes: '', recipient: { id: '', name: '', type: 'player' }, items: [{ label: '', qty: 1, price: 0 }] };
        $('#inv-title').value = ''; $('#inv-notes').value = '';
        $('#rx-nearby-select').value = ''; $('#rx-society-select').value = '';
        renderLineItems(); updateTotals();
    } else {
        Notify({ type: 'error', title: 'Send failed', message: reasonText(r && r.why) });
    }
}
function previewInvoice() {
    const c = state.composer;
    const vat = Math.max(0, Number($('#inv-vat').value) || 0);
    const dueDays = Math.max(1, Number($('#inv-due').value) || 7);
    const items = c.items
        .map(it => ({ label: (it.label || '').trim() || 'Item', qty: Math.max(1, Number(it.qty) || 1), price: Math.max(0, Number(it.price) || 0) }))
        .filter(it => it.price > 0);
    if (!items.length) { Notify({ type: 'warning', message: 'Add items to preview.' }); return; }
    const { sub, tax, total } = totalsOf(items, vat);
    const rx = currentRecipient();
    const personal = issueMode() === 'player';
    const fake = {
        id: 0, number: 'PREVIEW',
        issuer_type: personal ? 'player' : 'society',
        issuer_name: personal
            ? ((state.me && state.me.name) || 'You')
            : ((state.societySnap && state.societySnap.label) || 'Society'),
        recipient_name: rx.name || rx.id || '—',
        recipient_type: rx.type, recipient_id: rx.id,
        title: ($('#inv-title').value || '').trim() || 'Invoice',
        notes: ($('#inv-notes').value || '').trim(),
        items, subtotal: sub, tax, total, vat_rate: vat / 100, status: 'draft',
        due_at: Math.floor(Date.now() / 1000) + dueDays * 86400,
        created_at: new Date().toISOString().slice(0, 16).replace('T', ' '),
    };
    renderInvoiceModal(fake, { previewOnly: true });
}

function reasonText(w) {
    return ({
        no_perm: 'You are not allowed to do that.',
        no_item: 'You are missing the required item for your job.',
        no_recipient: 'Pick a recipient first.',
        self: 'You cannot bill yourself.',
        too_low: 'Total is below the minimum.',
        too_high: 'Total exceeds the maximum.',
        too_many_items: 'Too many line items.',
        too_many_pending: 'Too many pending invoices.',
        not_found: 'Invoice not found.',
        already_paid: 'This invoice has already been paid.',
        expired: 'This invoice has expired.',
        bad_state: 'Cannot act on this invoice in its current state.',
        no_funds: 'Insufficient funds.',
        no_society_funds: 'The society treasury cannot cover this invoice.',
        method_disabled: 'This payment method is disabled.',
    })[w] || 'Operation failed.';
}

/* ════════════════════════════════════════════════════════════
   LISTS
   ════════════════════════════════════════════════════════════ */
function renderInvList(target, rows, kind) {
    const wrap = $(target);
    if (!rows || !rows.length) {
        wrap.innerHTML = `<div class="inv-empty">Nothing here yet.</div>`;
        return;
    }
    wrap.innerHTML = '';
    rows.forEach(inv => {
        const row = document.createElement('div');
        const counter = (kind === 'sent' || kind === 'society') ? inv.recipient_name : inv.issuer_name;
        const sentBy = kind === 'society' && inv.issued_by_name
            ? ` · by ${escapeHtml(inv.issued_by_name)}`
            : '';

        // Decide which inline actions to expose. Pay button only
        // shows on actionable invoices — recipient's own, society
        // boss for society-recipient invoices, etc.
        const canAct = inv.status === 'sent';
        const meIsRecipient = canAct && state.identifier
            && inv.recipient_type === 'player' && inv.recipient_id === state.identifier;
        const meIsSocietyRx = canAct && inv.recipient_type === 'society'
            && state.societySnap && inv.recipient_id === state.societySnap.name
            && state.societySnap.isBoss;

        let actionsHtml = '';
        if (meIsRecipient) {
            actionsHtml = `
                <div class="inv-actions">
                    <button class="btn btn-primary" data-act="pay"><i class="fa-solid fa-credit-card"></i> Pay</button>
                    <button class="btn btn-ghost"   data-act="decline" title="Decline"><i class="fa-solid fa-xmark"></i></button>
                </div>`;
        } else if (meIsSocietyRx) {
            actionsHtml = `
                <div class="inv-actions">
                    <button class="btn btn-primary" data-act="pay-society"><i class="fa-solid fa-briefcase"></i> Pay (treasury)</button>
                </div>`;
        }

        row.className = 'inv-row' + (actionsHtml ? ' has-actions' : '');
        row.innerHTML = `
            <div class="inv-ic"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            <div class="inv-meta">
                <strong>${escapeHtml(inv.title || 'Invoice')} · <code>#${escapeHtml(inv.number)}</code></strong>
                <small>${kind === 'received' ? 'From ' : 'To '} ${escapeHtml(counter || '—')}${sentBy} · due ${fmtDate(inv.due_at)}</small>
            </div>
            <div class="inv-amount">${money(inv.total)}</div>
            <div class="inv-status ${inv.status}">${statusLabel(inv.status)}</div>
            ${actionsHtml}
        `;

        // Row click → open full modal. Action button clicks are
        // intercepted so they don't also pop the modal.
        on(row, 'click', () => openInvoice(inv.id));
        const stop = (e) => { e.stopPropagation(); };
        const pay = row.querySelector('[data-act="pay"]');
        if (pay) on(pay, 'click', (e) => { stop(e); onPay(inv.id, 'bank'); });
        const paySoc = row.querySelector('[data-act="pay-society"]');
        if (paySoc) on(paySoc, 'click', (e) => { stop(e); onPay(inv.id, 'society'); });
        const dec = row.querySelector('[data-act="decline"]');
        if (dec) on(dec, 'click', (e) => { stop(e); onDecline(inv.id); });

        wrap.appendChild(row);
    });
}

/* ────────────────────────────────────────────────────────────
   OVERVIEW dashboard
   ──────────────────────────────────────────────────────────── */
function renderOverview(allReceived, pending, overdue) {
    const outstanding = pending.concat(overdue)
        .reduce((s, r) => s + (Number(r.total) || 0), 0);
    $('#ov-outstanding').textContent = money(outstanding);
    $('#ov-pending').textContent = String(pending.length);
    $('#ov-overdue').textContent = String(overdue.length);

    const weekAgo = Math.floor(Date.now() / 1000) - 7 * 86400;
    const paid7 = allReceived
        .filter(r => r.status === 'paid' && (r.paid_at || 0) >= weekAgo)
        .reduce((s, r) => s + (Number(r.total) || 0), 0);
    $('#ov-paid-7d').textContent = money(paid7);
    $('#ov-total').textContent   = String(allReceived.length);

    if (state.societySnap) {
        $('#ov-society-tile').hidden = false;
        $('#ov-treasury').textContent = money(state.societySnap.treasury || 0);
    } else {
        $('#ov-society-tile').hidden = true;
    }

    // Latest 6 invoices
    renderInvList('#ov-list', allReceived.slice(0, 6), 'received');
}

/* ════════════════════════════════════════════════════════════
   INVOICE MODAL (paper view)
   ════════════════════════════════════════════════════════════ */
async function openInvoice(id) {
    const r = await post('invoice_get', { id });
    if (!r || !r.ok || !r.data) { Notify({ type: 'error', message: 'Invoice not found.' }); return; }
    renderInvoiceModal(r.data, { previewOnly: false });
}
async function lookupByNumber(number) {
    if (!number) return;
    const r = await post('invoice_lookup', { number });
    if (!r || !r.ok || !r.data) { Notify({ type: 'error', message: 'Invoice not found.' }); return; }
    renderInvoiceModal(r.data, { previewOnly: false, paymentOnBehalf: true });
}
function renderInvoiceModal(inv, opts) {
    opts = opts || {};
    try {
    const items = Array.isArray(inv.items) ? inv.items : [];
    const sub = Number(inv.subtotal) || 0, tax = Number(inv.tax) || 0, total = Number(inv.total) || 0;
    const vat = (Number(inv.vat_rate) || 0) * 100;
    const stampClass = inv.status === 'paid' ? 'paid'
                     : inv.status === 'declined' ? 'declined'
                     : inv.status === 'expired' ? 'expired'
                     : '';

    const recipientLine = inv.recipient_type === 'society'
        ? `<small>SOCIETY · ${escapeHtml(inv.recipient_id || '').toUpperCase()}</small>`
        : `<small>CITIZEN ${escapeHtml(String(inv.recipient_id || '').slice(0, 18))}</small>`;

    $('#invoice-paper').innerHTML = `
        <div class="paper-stamp ${stampClass}">${statusLabel(inv.status).toUpperCase()}</div>

        <header class="paper-top">
            <div class="paper-issuer">
                <div class="paper-logo"><i class="fa-solid fa-file-invoice-dollar"></i></div>
                <div class="paper-issuer-meta">
                    <strong>${escapeHtml(inv.issuer_name)}</strong>
                    <small>${inv.issuer_type === 'society' ? 'Authorised business' : 'Private invoice'}</small>
                </div>
            </div>
            <div class="paper-ref">
                <div class="paper-eyebrow">Invoice</div>
                <div class="paper-number">${escapeHtml(inv.number)}</div>
                <dl class="paper-dl">
                    <div><dt>Issued</dt><dd>${escapeHtml(fmtCreatedAt(inv.created_at))}</dd></div>
                    <div><dt>Due</dt><dd>${fmtDate(inv.due_at)}</dd></div>
                </dl>
            </div>
        </header>

        <section class="paper-billto">
            <div class="paper-block-title">Billed to</div>
            <strong>${escapeHtml(inv.recipient_name)}</strong>
            ${recipientLine}
        </section>

        <section class="paper-items">
            <table>
                <thead>
                    <tr><th>Description</th><th class="num">Qty</th><th class="num">Unit</th><th class="num">Amount</th></tr>
                </thead>
                <tbody>
                    ${items.map(it => {
                        const t = (Math.max(1, Number(it.qty) || 1)) * (Math.max(0, Number(it.price) || 0));
                        return `<tr>
                            <td>${escapeHtml(it.label || '—')}</td>
                            <td class="num">${it.qty || 1}</td>
                            <td class="num">${money(it.price || 0)}</td>
                            <td class="num bold">${money(t)}</td>
                        </tr>`;
                    }).join('')}
                </tbody>
            </table>
        </section>

        <section class="paper-totals">
            <div><span>Subtotal</span><strong>${money(sub)}</strong></div>
            <div><span>VAT <small>${vat.toFixed(0)}%</small></span><strong>${money(tax)}</strong></div>
            <div class="grand"><span>TOTAL DUE</span><strong>${money(total)}</strong></div>
        </section>

        <footer class="paper-foot">
            <div class="paper-notes">
                <div class="paper-block-title">Notes</div>
                <p>${inv.notes ? escapeHtml(inv.notes) : 'Thank you for your prompt payment.'}</p>
            </div>
            <div class="paper-sig">
                <span class="sig-name">${escapeHtml(inv.issuer_name || '')}</span>
                <span class="sig-line"></span>
                <small>${escapeHtml(inv.issuer_name || '')} · Authorised signatory</small>
            </div>
        </footer>

        <div class="paper-bottom">
            <span>Apex Billing · Generated electronically</span>
            <span class="paper-bottom-ref">REF #${escapeHtml(inv.number)}</span>
        </div>
    `;

    const actions = $('#im-actions'); actions.innerHTML = '';
    if (opts.previewOnly) {
        // No actions in preview
    } else if (inv.status === 'sent') {
        const meIsRecipient = (state.identifier && inv.recipient_type === 'player' && inv.recipient_id === state.identifier);
        const meIsSocietyRx = (inv.recipient_type === 'society' && state.societySnap && inv.recipient_id === state.societySnap.name);
        const meIsIssuer    = (state.identifier && inv.issuer_type === 'player' && inv.issuer_id === state.identifier);

        if (meIsSocietyRx) {
            actions.innerHTML = `
                <button class="btn btn-danger"  id="im-decline"><i class="fa-solid fa-xmark"></i> Decline</button>
                <button class="btn btn-primary" id="im-pay"><i class="fa-solid fa-briefcase"></i> Pay from treasury · ${money(total)}</button>
            `;
            on($('#im-pay'),     'click', () => onPay(inv.id, 'society'));
            on($('#im-decline'), 'click', () => onDecline(inv.id));
        } else if (meIsRecipient) {
            actions.innerHTML = `
                <button class="btn btn-danger"  id="im-decline"><i class="fa-solid fa-xmark"></i> Decline</button>
                <button class="btn btn-primary" id="im-pay"><i class="fa-solid fa-credit-card"></i> Pay ${money(total)}</button>
            `;
            on($('#im-pay'),     'click', () => onPay(inv.id, 'bank'));
            on($('#im-decline'), 'click', () => onDecline(inv.id));
        } else if (meIsIssuer || (state.societySnap && inv.issuer_type === 'society' && inv.issuer_job === state.societySnap.name)) {
            actions.innerHTML = `<button class="btn btn-danger" id="im-cancel"><i class="fa-solid fa-ban"></i> Cancel invoice</button>`;
            on($('#im-cancel'), 'click', () => onCancel(inv.id));
        } else if (opts.paymentOnBehalf) {
            actions.innerHTML = `
                <button class="btn btn-primary" id="im-pay"><i class="fa-solid fa-credit-card"></i> Pay on their behalf · ${money(total)}</button>
            `;
            on($('#im-pay'), 'click', () => onPay(inv.id, 'bank'));
        }
    }
    $('#invoice-overlay').hidden = false;
    // Ensure NUI focus so the recipient can click the buttons even
    // when the main panel is closed (auto-pop on receipt).
    post('ui_focus');
    } catch (e) {
        // Never let a render failure leave the player stuck with
        // NUI focus and no visible UI.
        console.error('[apex_billing] modal render failed:', e);
        $('#invoice-overlay').hidden = true;
        post('invoice_modal_closed');
        Notify({ type: 'error', message: 'Could not display the invoice.' });
    }
}

// Helper — closes the invoice modal AND releases NUI focus when
// the billing panel isn't open. Without this the mouse stayed on
// screen after dismissing an auto-popped invoice.
function closeInvoiceModal() {
    $('#invoice-overlay').hidden = true;
    post('invoice_modal_closed');
}

async function onPay(id, method) {
    const ok = await confirmDlg('Pay invoice', method === 'society' ? 'Payment will be deducted from the society treasury.' : 'The total will be charged to your bank account.');
    if (!ok) return;
    const r = await post('invoice_pay', { id, method: method || 'bank' });
    if (r && r.ok) Notify({ type: 'success', message: 'Invoice paid.' });
    else Notify({ type: 'error', message: reasonText(r && r.why) });
    closeInvoiceModal();
}
async function onDecline(id) {
    const ok = await confirmDlg('Decline invoice', 'The sender will be notified.');
    if (!ok) return;
    const r = await post('invoice_decline', { id });
    if (r && r.ok) Notify({ type: 'info', message: 'Invoice declined.' });
    else Notify({ type: 'error', message: reasonText(r && r.why) });
    closeInvoiceModal();
}
async function onCancel(id) {
    const ok = await confirmDlg('Cancel invoice', 'You will not be able to undo this.');
    if (!ok) return;
    const r = await post('invoice_cancel', { id });
    if (r && r.ok) Notify({ type: 'info', message: 'Invoice cancelled.' });
    else Notify({ type: 'error', message: reasonText(r && r.why) });
    closeInvoiceModal();
}

/* ════════════════════════════════════════════════════════════
   SOCIETY
   ════════════════════════════════════════════════════════════ */
function renderSociety() {
    const s = state.societySnap;
    if (!s) return;
    $('#soc-treasury').textContent    = money(s.treasury || 0);
    const st = s.stats || {};
    $('#soc-pending').textContent     = String(st.pending || 0);
    $('#soc-paid').textContent        = String(st.paid || 0);
    $('#soc-revenue').textContent     = money(st.revenue || 0);
    $('#soc-outstanding').textContent = money(st.outstanding || 0);
    renderInvList('#society-list', state.society, 'society');
    $('#society-count').textContent = String((state.society || []).length);
}

/* ════════════════════════════════════════════════════════════
   APPLY DATA / GATE
   ════════════════════════════════════════════════════════════ */
function applyData(p) {
    const inv = p.invoices || {};
    state.identifier      = inv.identifier || state.identifier;
    state.canIssue        = !!inv.canIssue;
    state.canIssuePersonal = !!inv.canIssuePersonal;
    state.sentPersonal    = inv.sentPersonal || [];
    state.me              = inv.me || state.me;
    state.received        = inv.received || [];
    state.societyReceived = inv.societyReceived || [];
    state.society         = inv.society || [];
    state.societySnap     = p.society || null;
    state.nearby          = p.nearby || [];
    state.societies       = p.societies || [];

    // Merge personal + society-received into the user's "received".
    const allReceived = state.received.concat(state.societyReceived);
    // Filtered views
    const now = Math.floor(Date.now() / 1000);
    const pending = allReceived.filter(r => r.status === 'sent' && (r.due_at || 0) >= now);
    const overdue = allReceived.filter(r => r.status === 'sent' && (r.due_at || 0) > 0 && r.due_at < now);

    $('#bp-pending-badge').textContent = String(pending.length);
    $('#bp-pending-badge').dataset.empty = pending.length > 0 ? 'false' : 'true';
    $('#bp-overdue-badge').textContent = String(overdue.length);
    $('#bp-overdue-badge').dataset.empty = overdue.length > 0 ? 'false' : 'true';

    $('#invoices-count').textContent = String(allReceived.length);
    $('#pending-count').textContent  = String(pending.length);
    $('#overdue-count').textContent  = String(overdue.length);

    renderInvList('#invoices-list', allReceived, 'received');
    renderInvList('#pending-list',  pending,     'received');
    renderInvList('#overdue-list',  overdue,     'received');
    renderInvList('#sent-list',     state.sentPersonal, 'sent');
    $('#sent-count').textContent = String(state.sentPersonal.length);
    renderOverview(allReceived, pending, overdue);
    renderSociety();
    renderNearby();
    renderSocieties();

    // Gate the UI based on canIssue / canIssuePersonal (also paints
    // the issuer card for the current mode).
    applyIssuanceGate(state.canIssue, !!state.societySnap);

    // Society pill
    const pill = $('#bp-job-pill');
    if (state.canIssue && state.societySnap) {
        $('#bp-job-pill-text').textContent = `${state.societySnap.label} · G${state.societySnap.grade}`;
        pill.hidden = false;
    } else {
        pill.hidden = true;
    }
}

function applyIssuanceGate(canIssue, hasSociety) {
    const canPersonal = !!state.canIssuePersonal;
    const both = canIssue && canPersonal;
    // state.issueAs only changes when the player clicks the switch, so
    // gaining a society job later still starts on "Society".
    const personalMode = issueMode() === 'player';

    $('#bp-tab-new').hidden     = !(canIssue || canPersonal);
    $('#bp-tab-society').hidden = !(canIssue && hasSociety);
    $('#bp-tab-sent').hidden    = !(canPersonal || (state.sentPersonal || []).length > 0);
    // Society / Personal switch only when the player can do both.
    $('#issue-as-tabs').hidden  = !both;
    $$('.ia-tab').forEach(b => b.classList.toggle('active', b.dataset.as === state.issueAs));
    // Personal invoices go to players only, never to a society.
    $('#rx-tab-society').hidden = !canIssue || personalMode;
    if (personalMode && state.rxKind === 'society') switchRxKind('nearby');
    renderIssuer();

    // Footer only visible on the New tab
    $('#bp-footer').hidden = state.currentTab !== 'new';
    // If user was on a tab they no longer have, jump.
    const active = document.querySelector('#billing-overlay .bp-tab.active');
    if (active && active.hidden) switchTab('invoices');
    $('#bp-subtitle').textContent = both
        ? 'Bill other players yourself or on behalf of your society'
        : canIssue
            ? 'Issue and manage invoices on behalf of your society'
            : canPersonal
                ? 'Bill other players and pay the invoices you receive'
                : 'Pay or decline the invoices you receive';
}

/* ════════════════════════════════════════════════════════════
   OPEN / CLOSE
   ════════════════════════════════════════════════════════════ */
function open() {
    $('#billing-overlay').hidden = false;
    // Always start on the Overview dashboard.
    switchTab('overview');
}
function close() {
    $('#billing-overlay').hidden = true;
    $('#invoice-overlay').hidden = true;
    $('#settings-overlay').hidden = true;
    $('#dialog-overlay').hidden = true;
    post('billing_close');
}

/* ════════════════════════════════════════════════════════════
   ADMIN PANEL  (/billingadmin)

   Entirely separate from the player panel: its own overlay, its
   own state, its own NUI callbacks. Nothing here is authoritative
   — every admin_* callback is re-gated on the server.
   ════════════════════════════════════════════════════════════ */
const admin = {
    isOpen: false,
    tab: 'overview',
    q: '', status: 'all', society: 'all',
    page: 1, pages: 1, total: 0,
    rows: [], stats: null,
    socRows: [], socLoaded: false,
    searchTimer: null,
    busy: false,
};

function adminSwitchTab(name) {
    admin.tab = name;
    $$('#admin-overlay .bp-tab').forEach(b => b.classList.toggle('active', b.dataset.atab === name));
    $$('.apane').forEach(p => p.hidden = p.dataset.apane !== name);
    $('#ad-body').scrollTop = 0;
    if (name === 'invoices' && !admin.rows.length) adminSearch();
    if (name === 'societies' && !admin.socLoaded) adminLoadSocieties();
}

/* ─── Overview ─── */
function adminRenderStats(s) {
    if (!s) return;
    admin.stats = s;
    $('#ad-outstanding').textContent = money(s.outstanding);
    $('#ad-pending').textContent     = String(s.pending || 0);
    $('#ad-overdue').textContent     = String(s.overdue || 0);
    $('#ad-revenue').textContent     = money(s.revenue);
    $('#ad-paid7').textContent       = money(s.paid7d);
    $('#ad-total').textContent       = String(s.total || 0);

    // Status chips double as filter shortcuts into the Invoices tab.
    const chips = [
        ['sent',      'Pending',   s.pending],
        ['overdue',   'Overdue',   s.overdue],
        ['paid',      'Paid',      s.paid],
        ['declined',  'Declined',  s.declined],
        ['expired',   'Expired',   s.expired],
        ['cancelled', 'Cancelled', s.cancelled],
    ];
    const wrap = $('#ad-status-chips');
    wrap.innerHTML = '';
    chips.forEach(([key, label, n]) => {
        const b = document.createElement('button');
        b.className = 'ad-chip';
        b.innerHTML = `${escapeHtml(label)} <b>${Number(n) || 0}</b>`;
        on(b, 'click', () => {
            admin.status = key;
            $('#ad-status').value = key;
            admin.page = 1;
            adminSwitchTab('invoices');
            adminSearch();
        });
        wrap.appendChild(b);
    });

    const top = $('#ad-top-table');
    const rows = s.top || [];
    if (!rows.length) {
        top.innerHTML = `<div class="ad-empty">No society invoices yet.</div>`;
        return;
    }
    top.innerHTML =
        `<div class="ad-tr head"><span>Society</span><span class="ad-num">Invoices</span>` +
        `<span class="ad-num">Collected</span><span class="ad-num">Outstanding</span><span></span></div>` +
        rows.map(r => `
            <div class="ad-tr">
                <div><strong>${escapeHtml(r.label || r.job)}</strong><small>${escapeHtml(r.job)}</small></div>
                <span class="ad-num">${Number(r.n) || 0}</span>
                <span class="ad-num pos">${money(r.revenue)}</span>
                <span class="ad-num">${money(r.outstanding)}</span>
                <span></span>
            </div>`).join('');
}

async function adminRefreshStats() {
    const s = await post('admin_stats');
    if (s && typeof s === 'object') adminRenderStats(s);
}

/* ─── Invoice search ─── */
function adminQueueSearch() {
    clearTimeout(admin.searchTimer);
    admin.searchTimer = setTimeout(() => { admin.page = 1; adminSearch(); }, 260);
}

async function adminSearch() {
    const r = await post('admin_search', {
        q: admin.q, status: admin.status, society: admin.society,
        page: admin.page, pageSize: 25,
    });
    if (!r) return;
    admin.rows  = r.rows || [];
    admin.total = Number(r.total) || 0;
    admin.page  = Number(r.page) || 1;
    admin.pages = Number(r.pages) || 1;
    adminRenderList();
}

function adminStatusMeta(inv) {
    // An invoice that is still 'sent' but past due reads as
    // overdue everywhere else in the UI — keep that consistent.
    const now = Math.floor(Date.now() / 1000);
    if (inv.status === 'sent' && (inv.due_at || 0) > 0 && inv.due_at < now) {
        return { cls: 'expired', label: 'Overdue' };
    }
    return { cls: inv.status, label: statusLabel(inv.status) };
}

function adminRenderList() {
    const wrap = $('#ad-list');
    $('#ad-count').textContent = String(admin.total);
    $('#ad-page-label').textContent = `Page ${admin.page} of ${admin.pages}`;
    $('#ad-prev').disabled = admin.page <= 1;
    $('#ad-next').disabled = admin.page >= admin.pages;

    if (!admin.rows.length) {
        wrap.innerHTML = `<div class="inv-empty">No invoice matches these filters.</div>`;
        return;
    }
    wrap.innerHTML = '';
    admin.rows.forEach(inv => {
        const st = adminStatusMeta(inv);
        const isPending = inv.status === 'sent';
        const by = inv.issued_by_name ? ` by ${escapeHtml(inv.issued_by_name)}` : '';

        const acts = [];
        if (isPending) {
            acts.push(['paid',   'fa-circle-check', 'Mark as paid (no money moves)', '']);
            acts.push(['extend', 'fa-calendar-plus', 'Extend due date by 7 days', '']);
            acts.push(['void',   'fa-ban', 'Void this invoice', '']);
        } else {
            acts.push(['reopen', 'fa-rotate-left', 'Reopen as pending', '']);
        }
        acts.push(['delete', 'fa-trash', 'Delete permanently', 'danger']);

        const row = document.createElement('div');
        row.className = 'inv-row ad-row has-actions';
        row.innerHTML = `
            <div class="inv-ic"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            <div class="inv-meta">
                <strong>${escapeHtml(inv.title || 'Invoice')} · <code>#${escapeHtml(inv.number)}</code></strong>
                <small><em>${escapeHtml(inv.issuer_name || '—')}</em>${by} → <em>${escapeHtml(inv.recipient_name || '—')}</em>
                       · due ${fmtDate(inv.due_at)}</small>
            </div>
            <div class="inv-amount">${money(inv.total)}</div>
            <div class="inv-status ${st.cls}">${escapeHtml(st.label)}</div>
            <div class="ad-acts">
                ${acts.map(([a, icon, title, extra]) =>
                    `<button class="ad-act ${extra}" data-aact="${a}" title="${escapeHtml(title)}"><i class="fa-solid ${icon}"></i></button>`
                ).join('')}
            </div>
        `;

        on(row, 'click', () => adminOpenInvoice(inv.id));
        $$('[data-aact]', row).forEach(btn => on(btn, 'click', (e) => {
            e.stopPropagation();
            adminAction(inv, btn.dataset.aact);
        }));
        wrap.appendChild(row);
    });
}

async function adminOpenInvoice(id) {
    const r = await post('admin_get', { id });
    if (!r || !r.ok || !r.data) { Notify({ type: 'error', message: 'Invoice not found.' }); return; }
    // previewOnly keeps the pay/decline buttons off — an admin is
    // not the recipient and must not settle from here.
    renderInvoiceModal(r.data, { previewOnly: true });
}

const ADMIN_CONFIRM = {
    paid:   ['Mark as paid', 'This only corrects the ledger — no money is moved and the issuer is not credited.'],
    void:   ['Void invoice', 'The invoice becomes Cancelled and can no longer be paid.'],
    delete: ['Delete invoice', 'The invoice is removed from the database. This cannot be undone.'],
    reopen: ['Reopen invoice', 'The invoice goes back to Pending with the due date pushed out 7 days.'],
};

async function adminAction(inv, action) {
    if (admin.busy) return;
    const c = ADMIN_CONFIRM[action];
    if (c) {
        const ok = await confirmDlg(c[0], `#${inv.number} — ${c[1]}`);
        if (!ok) return;
    }
    admin.busy = true;
    const r = await post('admin_action', { id: inv.id, action, days: 7 });
    admin.busy = false;
    if (r && r.ok) {
        Notify({ type: 'success', title: 'Done', message: `Invoice #${inv.number} updated.` });
        adminSearch(); adminRefreshStats();
        admin.socLoaded = false;
    } else {
        Notify({ type: 'error', title: 'Failed', message: adminReason(r && r.why) });
    }
}

function adminReason(w) {
    return ({
        no_perm:    'You are not authorised.',
        disabled:   'The admin panel is disabled in the config.',
        not_found:  'Invoice not found.',
        bad_action: 'Unknown action.',
        bad_state:  'Cannot act on this invoice in its current state.',
    })[w] || 'Operation failed.';
}

/* ─── Societies ─── */
async function adminLoadSocieties() {
    const r = await post('admin_societies');
    admin.socRows = (r && r.rows) || [];
    admin.socLoaded = true;
    const wrap = $('#ad-soc-table');
    $('#ad-soc-count').textContent = String(admin.socRows.length);
    if (!admin.socRows.length) {
        wrap.innerHTML = `<div class="ad-empty">No societies configured.</div>`;
        return;
    }
    wrap.innerHTML =
        `<div class="ad-tr head"><span>Society</span><span class="ad-num">Treasury</span>` +
        `<span class="ad-num">Pending</span><span class="ad-num">Collected</span><span class="ad-num">Outstanding</span></div>` +
        admin.socRows.map(r => `
            <div class="ad-tr">
                <div><strong>${escapeHtml(r.label)}</strong><small>${escapeHtml(r.name)}${r.inConfig ? '' : ' · not in config'}</small></div>
                <span class="ad-num pos">${money(r.treasury)}</span>
                <span class="ad-num">${Number(r.pending) || 0}</span>
                <span class="ad-num">${money(r.revenue)}</span>
                <span class="ad-num">${money(r.outstanding)}</span>
            </div>`).join('');
}

/* ─── Tools ─── */
async function adminTool(tool) {
    if (admin.busy) return;
    if (tool === 'purge') {
        const days = Math.max(1, Number($('#ad-purge-days').value) || 30);
        const ok = await confirmDlg('Purge settled invoices',
            `Permanently delete every paid, declined, cancelled or expired invoice older than ${days} days. This cannot be undone.`);
        if (!ok) return;
        admin.busy = true;
        const r = await post('admin_tool', { tool, days });
        admin.busy = false;
        adminToolResult(r);
        return;
    }
    admin.busy = true;
    const r = await post('admin_tool', { tool });
    admin.busy = false;
    adminToolResult(r);
}

function adminToolResult(r) {
    if (r && r.ok) {
        Notify({ type: 'success', title: 'Done', message: (r.data && r.data.message) || 'Completed.' });
        adminRefreshStats();
        admin.socLoaded = false;
        if (admin.tab === 'invoices') adminSearch(); else admin.rows = [];
    } else {
        Notify({ type: 'error', title: 'Failed', message: adminReason(r && r.why) });
    }
}

/* ─── Open / close ─── */
function adminOpen(boot) {
    admin.isOpen = true;
    $('#admin-overlay').hidden = false;
    // Tell Lua the JS actually ran. If this never arrives, the client
    // is serving a stale cached app.js and Lua will say so out loud.
    post('admin_ready');
    $('#ad-who').textContent = (boot && boot.who) || 'Admin';

    const sel = $('#ad-society');
    sel.innerHTML = '<option value="all">All societies</option>';
    ((boot && boot.societies) || []).forEach(s => {
        const o = document.createElement('option');
        o.value = s.name; o.textContent = s.label;
        sel.appendChild(o);
    });
    sel.value = admin.society;

    adminRenderStats(boot && boot.stats);
    adminSwitchTab('overview');
}

function adminClose() {
    admin.isOpen = false;
    $('#admin-overlay').hidden = true;
    $('#invoice-overlay').hidden = true;
    $('#dialog-overlay').hidden = true;
    post('admin_close');
}

function adminWire() {
    $$('#admin-overlay .bp-tab').forEach(b => on(b, 'click', () => adminSwitchTab(b.dataset.atab)));
    on($('#ad-close'), 'click', adminClose);
    on($('#ad-refresh'), 'click', () => {
        adminRefreshStats();
        admin.socLoaded = false;
        if (admin.tab === 'invoices') adminSearch();
        if (admin.tab === 'societies') adminLoadSocieties();
    });

    on($('#ad-q'), 'input', (e) => { admin.q = e.target.value; adminQueueSearch(); });
    on($('#ad-status'),  'change', (e) => { admin.status = e.target.value;  admin.page = 1; adminSearch(); });
    on($('#ad-society'), 'change', (e) => { admin.society = e.target.value; admin.page = 1; adminSearch(); });
    on($('#ad-prev'), 'click', () => { if (admin.page > 1) { admin.page--; adminSearch(); } });
    on($('#ad-next'), 'click', () => { if (admin.page < admin.pages) { admin.page++; adminSearch(); } });

    $$('[data-tool]').forEach(b => on(b, 'click', () => adminTool(b.dataset.tool)));
}

/* ════════════════════════════════════════════════════════════
   SETTINGS — color presets + position picker
   ════════════════════════════════════════════════════════════ */
function paintPresets() {
    const wrap = $('#theme-presets'); wrap.innerHTML = '';
    const current = (state.prefs.brand || (Runtime.theme && Runtime.theme.brand) || DEFAULT_BRAND).toLowerCase();
    COLOR_PRESETS.forEach(c => {
        const b = document.createElement('button');
        b.className = 'preset-swatch';
        b.style.setProperty('--_c', c);
        if (c.toLowerCase() === current) b.classList.add('active');
        on(b, 'click', () => {
            applyBrand(c); $('#theme-color').value = c; $('#theme-color-hex').textContent = c.toUpperCase();
            savePrefs({ brand: c });
            $$('#theme-presets .preset-swatch').forEach(x => x.classList.toggle('active', x === b));
        });
        wrap.appendChild(b);
    });
}

function paintBgPresets() {
    const wrap = $('#bg-presets'); if (!wrap) return; wrap.innerHTML = '';
    const current = (state.prefs.bg || (Runtime.theme && Runtime.theme.bg) || DEFAULT_BG).toLowerCase();
    BG_PRESETS.forEach(c => {
        const b = document.createElement('button');
        b.className = 'preset-swatch';
        b.style.setProperty('--_c', c);
        if (c.toLowerCase() === current) b.classList.add('active');
        on(b, 'click', () => {
            applyBackground(c); $('#bg-color').value = c; $('#bg-color-hex').textContent = c.toUpperCase();
            savePrefs({ bg: c });
            $$('#bg-presets .preset-swatch').forEach(x => x.classList.toggle('active', x === b));
        });
        wrap.appendChild(b);
    });
}

/* ════════════════════════════════════════════════════════════
   WIRING
   ════════════════════════════════════════════════════════════ */
function wire() {
    $$('#billing-overlay .bp-tab').forEach(b => on(b, 'click', () => switchTab(b.dataset.tab)));
    $$('.rx-tab').forEach(b => on(b, 'click', () => switchRxKind(b.dataset.rx)));
    $$('.ia-tab').forEach(b => on(b, 'click', () => switchIssueAs(b.dataset.as)));
    adminWire();

    on($('#bp-close'),    'click', close);
    on($('#bp-settings'), 'click', () => { $('#settings-overlay').hidden = false; });
    on($('#settings-close'), 'click', () => { $('#settings-overlay').hidden = true; });

    on($('#li-add'),    'click', () => { state.composer.items.push({ label: '', qty: 1, price: 0 }); renderLineItems(); updateTotals(); });
    on($('#send-inv'),  'click', sendInvoice);
    on($('#bp-preview'),'click', previewInvoice);
    on($('#inv-title'), 'input', (e) => { state.composer.title = e.target.value; });
    on($('#inv-notes'), 'input', (e) => { state.composer.notes = e.target.value; });
    on($('#inv-vat'),   'input', updateTotals);

    // Pay-by-reference (overview pane)
    on($('#ref-lookup-ov'), 'click', () => lookupByNumber(($('#ref-input-ov').value || '').trim()));
    on($('#ref-input-ov'),  'keydown', (e) => { if (e.key === 'Enter') lookupByNumber(($('#ref-input-ov').value || '').trim()); });

    // Invoice modal close (X button) — also releases NUI focus
    // when the modal was popped standalone on receipt.
    on($('#im-close'), 'click', closeInvoiceModal);
    // Click outside the modal also closes it.
    on($('#invoice-overlay'), 'click', (e) => {
        if (e.target === $('#invoice-overlay')) closeInvoiceModal();
    });

    // Theme picker
    on($('#theme-color'), 'input', (e) => {
        applyBrand(e.target.value);
        $('#theme-color-hex').textContent = e.target.value.toUpperCase();
        savePrefs({ brand: e.target.value });
        paintPresets();
    });
    on($('#theme-reset'), 'click', () => {
        const c = (Runtime.theme && Runtime.theme.brand) || DEFAULT_BRAND;
        applyBrand(c); $('#theme-color').value = c; $('#theme-color-hex').textContent = c.toUpperCase();
        savePrefs({ brand: null });
        paintPresets();
    });

    // Background picker
    on($('#bg-color'), 'input', (e) => {
        applyBackground(e.target.value);
        $('#bg-color-hex').textContent = e.target.value.toUpperCase();
        savePrefs({ bg: e.target.value });
        paintBgPresets();
    });
    on($('#bg-reset'), 'click', () => {
        const c = (Runtime.theme && Runtime.theme.bg) || DEFAULT_BG;
        applyBackground(c); $('#bg-color').value = c; $('#bg-color-hex').textContent = c.toUpperCase();
        savePrefs({ bg: null });
        paintBgPresets();
    });

    // ESC handling — closes the topmost open overlay
    document.addEventListener('keydown', (e) => {
        if (e.key !== 'Escape') return;
        if (!$('#dialog-overlay').hidden)   { $('#dialog-overlay').hidden = true; return; }
        if (!$('#settings-overlay').hidden) { $('#settings-overlay').hidden = true; return; }
        if (!$('#invoice-overlay').hidden)  { closeInvoiceModal(); return; }
        if (admin.isOpen)                   { adminClose(); return; }
        close();
    });
}

/* ════════════════════════════════════════════════════════════
   MESSAGE PIPE
   ════════════════════════════════════════════════════════════ */
window.addEventListener('message', (ev) => {
    const msg = ev.data; if (!msg || !msg.action) return;
    const p = msg.payload || {};
    switch (msg.action) {
        case 'bootstrap':
            Object.assign(Runtime, p);
            // Apply saved prefs (brand, pos) — fall through to Config defaults otherwise
            const initialBrand = state.prefs.brand || (p.theme && p.theme.brand) || DEFAULT_BRAND;
            applyBrand(initialBrand);
            $('#theme-color').value = initialBrand;
            $('#theme-color-hex').textContent = initialBrand.toUpperCase();
            const initialBg = state.prefs.bg || (p.theme && p.theme.bg) || DEFAULT_BG;
            applyBackground(initialBg);
            if ($('#bg-color')) $('#bg-color').value = initialBg;
            if ($('#bg-color-hex')) $('#bg-color-hex').textContent = initialBg.toUpperCase();
            applyPosition(state.prefs.pos || 'center');
            paintPresets();
            paintBgPresets();
            if (p.locale) {
                if (p.locale.wm_first)  $('#wm-first').textContent  = p.locale.wm_first;
                if (p.locale.wm_second) $('#wm-second').textContent = p.locale.wm_second;
            }
            renderLineItems(); renderQuickAmounts(); updateTotals();
            break;
        case 'billing_open':   open(); break;
        case 'billing_close':  $('#billing-overlay').hidden = true; break;
        case 'billing_data':   applyData(p); break;
        case 'open_invoice':   openInvoice(p.id); break;
        case 'invoice_received':
            // Auto-pop the realistic invoice modal on receipt.
            openInvoice(p.id);
            break;
        case 'notify':         Notify({ title: p.title, message: p.message, type: p.type, duration: p.duration }); break;

        /* ─── Admin panel ─── */
        case 'admin_open':     adminOpen(p); break;
        case 'admin_close':    admin.isOpen = false; $('#admin-overlay').hidden = true; break;
        case 'admin_stale':
            // Something changed server-side while the panel is open.
            if (admin.isOpen) {
                adminRefreshStats();
                admin.socLoaded = false;
                if (admin.tab === 'invoices') adminSearch();
                if (admin.tab === 'societies') adminLoadSocieties();
            }
            break;
    }
});

document.addEventListener('DOMContentLoaded', () => {
    wire();
    renderLineItems(); renderQuickAmounts(); updateTotals();
});
