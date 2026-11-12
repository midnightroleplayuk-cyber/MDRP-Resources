'use strict';

const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'vinewood_multichar';
const $ = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => [...r.querySelectorAll(s)];
const esc = (v) => String(v ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

async function post(name, data) {
    try {
        const r = await fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data || {}) });
        return await r.json();
    } catch (e) { return null; }
}

// Lua sends empty tables as {} sometimes, so make anything list-like a real array
const arr = (v) => Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []);
function normScene(sc) {
    if (!sc) return sc;
    sc.spots = arr(sc.spots); sc.props = arr(sc.props);
    sc.camera = sc.camera || {}; sc.camera.intro = arr(sc.camera.intro); sc.camera.dof = sc.camera.dof || { enabled: true, strength: 0.7 };
    sc.env = sc.env || {};
    return sc;
}
function normAdmin(d) {
    d.scenes = arr(d.scenes).map(normScene);
    d.overrides = arr(d.overrides);
    d.players = arr(d.players).map((p) => Object.assign(p, { breakdown: arr(p.breakdown) }));
    d.discord = d.discord || {}; d.discord.roles = arr(d.discord.roles);
    d.settings.aceBonuses = arr(d.settings.aceBonuses); d.settings.discordRoles = arr(d.settings.discordRoles);
    return d;
}
function normSelect(d) { d.characters = arr(d.characters); d.breakdown = arr(d.breakdown); return d; }

function toast(text, type = 'info') {
    const el = document.createElement('div');
    el.className = `toast ${type}`;
    el.textContent = text;
    $('#toasts').appendChild(el);
    setTimeout(() => el.remove(), 4200);
}

function loading(show, text = '') {
    $('#loading').hidden = !show;
    $('#loadingText').textContent = text;
}

/* ═════════════════════ Theme ═════════════════════ */
const FONTS = {
    bigshoulders: { label: 'Big Shoulders', css: "'Big Shoulders Display', 'Arial Narrow', sans-serif" },
    oswald: { label: 'Oswald', css: "'Oswald', 'Arial Narrow', sans-serif" },
    bebas: { label: 'Bebas Neue', css: "'Bebas Neue', 'Oswald', sans-serif" },
    rajdhani: { label: 'Rajdhani', css: "'Rajdhani', 'Arial Narrow', sans-serif" },
    playfair: { label: 'Playfair', css: "'Playfair Display', Georgia, serif" },
    cinzel: { label: 'Cinzel', css: "'Cinzel', Georgia, serif" },
};
const PRESETS = [
    { id: 'sodium', label: 'Sodium', accent: '#F2A93B', surface: '#0E1218', text: '#F3EFE6', bar: '#000000' },
    { id: 'police', label: 'Blue light', accent: '#3D8BFF', surface: '#0B1220', text: '#EEF3FF', bar: '#000000' },
    { id: 'emerald', label: 'Emerald', accent: '#2FBF71', surface: '#0B1612', text: '#ECF5EF', bar: '#000000' },
    { id: 'royal', label: 'Royal', accent: '#8B5CF6', surface: '#120E1E', text: '#F1EEFB', bar: '#05030A' },
    { id: 'crimson', label: 'Crimson', accent: '#E5484D', surface: '#170C0E', text: '#F8EEEE', bar: '#000000' },
    { id: 'ice', label: 'Ice', accent: '#7DD3FC', surface: '#0C141B', text: '#EEF7FC', bar: '#02060A' },
    { id: 'rose', label: 'Rose gold', accent: '#E8A39A', surface: '#151012', text: '#F8F0EE', bar: '#000000' },
    { id: 'mono', label: 'Mono', accent: '#E8E8E8', surface: '#0F0F10', text: '#F5F5F5', bar: '#000000' },
];
const SWATCHES = ['#F2A93B', '#FFD166', '#E5484D', '#F472B6', '#8B5CF6', '#3D8BFF', '#7DD3FC', '#2FBF71', '#A3E635', '#E8A39A', '#FFFFFF', '#9CA3AF', '#0E1218', '#0B1220', '#000000', '#1F2937'];

const hexRgb = (h) => { const n = parseInt((h || '#000000').slice(1), 16); return [(n >> 16) & 255, (n >> 8) & 255, n & 255]; };
const lum = (h) => { const [r, g, b] = hexRgb(h).map((v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4; }); return 0.2126 * r + 0.7152 * g + 0.0722 * b; };
let liveTheme = null;

function applyTheme(t) {
    if (!t) return;
    liveTheme = t;
    const r = document.documentElement.style;
    r.setProperty('--accent', t.accent); r.setProperty('--accent-rgb', hexRgb(t.accent).join(', '));
    r.setProperty('--on-accent', lum(t.accent) > 0.45 ? '#14100A' : '#FFFFFF');
    r.setProperty('--surface', t.surface); r.setProperty('--surface-rgb', hexRgb(t.surface).join(', '));
    r.setProperty('--text', t.text); r.setProperty('--text-rgb', hexRgb(t.text).join(', '));
    r.setProperty('--danger', t.danger || '#E5484D');
    r.setProperty('--bar', t.bar);
    r.setProperty('--vignette', t.vignette ?? 0.75);
    r.setProperty('--display', (FONTS[t.font] || FONTS.bigshoulders).css);
    const sc = $('#select');
    sc.classList.toggle('right', t.layout === 'right');
    sc.classList.toggle('nobars', t.letterbox === false);
    sc.classList.toggle('noframe', t.frame === false);
}

// The NUI browser caches images hard, so tag the logo with the save revision
function logoSrc(t) {
    if (!t || !t.logo) return '';
    if (!t.rev) return t.logo;
    return t.logo + (t.logo.includes('?') ? '&' : '?') + 'v=' + t.rev;
}

function brandHTML(t, size) {
    const src = logoSrc(t);
    const img = src ? `<img src="${esc(src)}" alt="" style="height:${size}px;max-width:${size * 3}px" onerror="this.remove()">` : '';
    const name = t.showName !== false || !src
        ? `<div class="brand-text"><span class="brand-name">${esc(t.serverName || '')}</span>${t.tagline ? `<span class="brand-tag">${esc(t.tagline)}</span>` : ''}</div>` : '';
    return img + name;
}

/* colour picker */
const picker = { el: null, h: 0, s: 0, v: 0, cb: null, anchor: null };
function hexToHsv(hex) {
    let [r, g, b] = hexRgb(hex).map((x) => x / 255);
    const max = Math.max(r, g, b), min = Math.min(r, g, b), d = max - min;
    let h = 0;
    if (d) {
        if (max === r) h = ((g - b) / d) % 6; else if (max === g) h = (b - r) / d + 2; else h = (r - g) / d + 4;
        h *= 60; if (h < 0) h += 360;
    }
    return [h, max ? d / max : 0, max];
}
function hsvToHex(h, s, v) {
    const f = (n) => { const k = (n + h / 60) % 6; return v - v * s * Math.max(Math.min(k, 4 - k, 1), 0); };
    return '#' + [f(5), f(3), f(1)].map((x) => Math.round(x * 255).toString(16).padStart(2, '0')).join('').toUpperCase();
}
function pickerPaint(fromInput) {
    const hex = hsvToHex(picker.h, picker.s, picker.v);
    $('#pickSv').style.backgroundColor = `hsl(${picker.h}, 100%, 50%)`;
    $('#pickSvKnob').style.left = `${picker.s * 100}%`; $('#pickSvKnob').style.top = `${(1 - picker.v) * 100}%`;
    $('#pickHueKnob').style.left = `${(picker.h / 360) * 100}%`;
    $('#pickChip').style.background = hex;
    if (!fromInput) $('#pickHex').value = hex;
    if (picker.cb) picker.cb(hex);
}
function openPicker(anchor, value, cb) {
    [picker.h, picker.s, picker.v] = hexToHsv(value);
    picker.cb = null; picker.anchor = anchor;
    const p = $('#picker'); p.hidden = false;
    const r = anchor.getBoundingClientRect();
    p.style.left = `${Math.min(window.innerWidth - 252, r.left)}px`;
    p.style.top = `${Math.min(window.innerHeight - 290, r.bottom + 6)}px`;
    pickerPaint();
    picker.cb = cb;
}
function closePicker() { $('#picker').hidden = true; picker.cb = null; picker.anchor = null; }
function drag(el, fn) {
    el.addEventListener('pointerdown', (e) => {
        const move = (ev) => { const r = el.getBoundingClientRect(); fn(Math.min(1, Math.max(0, (ev.clientX - r.left) / r.width)), Math.min(1, Math.max(0, (ev.clientY - r.top) / r.height))); pickerPaint(); };
        move(e);
        const up = () => { window.removeEventListener('pointermove', move); window.removeEventListener('pointerup', up); };
        window.addEventListener('pointermove', move); window.addEventListener('pointerup', up);
    });
}
drag($('#pickSv'), (x, y) => { picker.s = x; picker.v = 1 - y; });
drag($('#pickHue'), (x) => { picker.h = x * 360; });
$('#pickHex').addEventListener('input', (e) => {
    let v = e.target.value.trim(); if (!v.startsWith('#')) v = '#' + v;
    if (/^#[0-9a-f]{6}$/i.test(v)) { [picker.h, picker.s, picker.v] = hexToHsv(v); pickerPaint(true); }
});
$('#pickSwatches').innerHTML = SWATCHES.map((c) => `<button style="background:${c}" data-sw="${c}" aria-label="${c}"></button>`).join('');
$$('#pickSwatches button').forEach((b) => b.onclick = () => { [picker.h, picker.s, picker.v] = hexToHsv(b.dataset.sw); pickerPaint(); });
document.addEventListener('pointerdown', (e) => {
    if ($('#picker').hidden) return;
    if (e.target.closest('#picker') || (picker.anchor && picker.anchor.contains(e.target))) return;
    closePicker();
});

/* ═════════════════════ Selection ═════════════════════ */
const sel = { data: null, selected: 1, cfg: null, busy: false, createSlot: null, deleting: null };

const money = (n) => {
    const cur = sel.cfg?.ui?.Currency || '£';
    const loc = sel.cfg?.ui?.Locale || 'en-GB';
    try {
        if (cur === '£') return new Intl.NumberFormat(loc, { style: 'currency', currency: 'GBP', maximumFractionDigits: 0 }).format(n || 0);
    } catch (e) { /* fall through */ }
    return cur + Math.round(n || 0).toLocaleString(loc);
};

function fmtDate(v, withTime) {
    if (!v) return '–';
    let d;
    if (typeof v === 'number') d = new Date(v);
    else if (/^\d{4}-\d{2}-\d{2}$/.test(v)) { const [y, m, dd] = v.split('-'); d = new Date(+y, +m - 1, +dd); }
    else if (/^\d{2}\/\d{2}\/\d{4}$/.test(v)) return v;
    else d = new Date(v);
    if (isNaN(d)) return String(v);
    return d.toLocaleDateString(sel.cfg?.ui?.Locale || 'en-GB', withTime ? { day: 'numeric', month: 'short', year: 'numeric' } : { day: '2-digit', month: '2-digit', year: 'numeric' });
}

function charBySlot(slot) { return sel.data.characters.find((c) => c.slot === slot); }

function slotState(slot) {
    const c = charBySlot(slot);
    if (c) return c.locked ? { kind: 'lockedchar', c } : { kind: 'char', c };
    if (slot > sel.data.allowed) return { kind: 'locked' };
    return { kind: 'empty' };
}

function renderRoster() {
    const d = sel.data;
    const used = d.characters.length;
    const t = liveTheme || {};
    $('#brand').innerHTML = brandHTML(t, t.logoSize || 64);
    let pips = '';
    for (let i = 1; i <= Math.min(d.display, 16); i++) pips += `<i class="${charBySlot(i) ? 'used' : (i > d.allowed ? 'locked' : '')}"></i>`;
    $('#slotsMeter').innerHTML = `<div class="pips">${pips}</div><span><b>${used}</b> of <b>${d.allowed}</b> slots used</span>`;

    let html = '';
    for (let slot = 1; slot <= d.display; slot++) {
        const st = slotState(slot);
        const on = slot === sel.selected ? ' on' : '';
        const num = `<span class="num">${String(slot).padStart(2, '0')}</span>`;
        let inner;
        if (st.kind === 'char' || st.kind === 'lockedchar') {
            const c = st.c, locked = st.kind === 'lockedchar';
            const job = [c.job, c.grade].filter(Boolean).join(', ');
            inner = `<div><div class="name">${locked ? '<span class="lock"></span>' : ''}${esc(c.firstname)} ${esc(c.lastname)}</div>
                <div class="meta">${locked ? 'In a locked slot' : esc(job || 'Unemployed')}</div></div>`;
            html += `<button class="slot${locked ? ' locked' : ''}${on}" data-slot="${slot}">${num}${inner}</button>`;
        } else if (st.kind === 'empty') {
            html += `<button class="slot empty${on}" data-slot="${slot}">${num}<div><div class="name"><span class="plus"></span>New character</div><div class="meta">Empty slot</div></div></button>`;
        } else {
            html += `<button class="slot locked${on}" data-slot="${slot}">${num}<div><div class="name"><span class="lock"></span>Locked</div><div class="meta">Unlock for more characters</div></div></button>`;
        }
    }
    $('#roster').innerHTML = html;
    $$('#roster .slot').forEach((b) => b.addEventListener('click', () => choose(+b.dataset.slot)));
    const on = $('#roster .slot.on'); if (on) on.scrollIntoView({ block: 'nearest' });
    renderDetail();
    renderInfo();
}

/* floating card next to the character */
const anchor = { show: false, x: 0, y: 0, slot: 0 };
function renderInfo() {
    const st = slotState(sel.selected);
    const card = $('#info');
    if (st.kind !== 'char' && st.kind !== 'lockedchar') { card.hidden = true; placeInfo(); return; }
    const c = st.c;
    const row = (label, value, sub) => value ? `<dt>${label}</dt><dd>${esc(value)}${sub ? `<small>${esc(sub)}</small>` : ''}</dd>` : '';
    card.innerHTML = `
        <div class="info-head"><div class="info-name">${esc(c.firstname)}<br>${esc(c.lastname)}</div><span class="info-slot">Slot ${c.slot}</span></div>
        <div class="info-tags">
            <span class="tag">${c.gender === 'female' ? 'Female' : 'Male'}</span>
            ${c.locked ? '<span class="tag accent">Locked slot</span>' : ''}
        </div>
        <dl class="info-rows">
            ${row('Job', c.job || 'Unemployed', c.grade)}
            ${c.gang ? `<dt>Gang</dt><dd class="gang-cell">${c.gangLogo ? `<img src="${esc(c.gangLogo)}" alt="" onerror="this.remove()">` : (c.gangColour ? `<i style="background:${esc(c.gangColour)}"></i>` : '')}<span>${esc(c.gang)}${c.gangRank ? `<small>${esc(c.gangRank)}</small>` : ''}</span></dd>` : row('Gang', 'Not affiliated')}
            ${row('Born', fmtDate(c.dob))}
            ${row('Nationality', c.nationality)}
            ${row('Phone', c.phone)}
        </dl>`;
    card.hidden = false;
    placeInfo();
}

function placeInfo() {
    const card = $('#info'), tether = $('#tether');
    const visible = anchor.show && anchor.slot === sel.selected && !card.hidden && $('#create').hidden;
    card.classList.toggle('on', visible);
    tether.classList.toggle('on', visible);
    if (!visible) return;
    const W = window.innerWidth, H = window.innerHeight;
    const ax = anchor.x * W, ay = anchor.y * H;
    const cw = card.offsetWidth, ch = card.offsetHeight;
    const gap = 90;
    // sit on the right of the character unless that runs off screen (or into a right-hand roster)
    const rightRoom = W - (ax + gap + cw) > W * 0.04 && !$('#select').classList.contains('right');
    const dir = rightRoom ? 1 : -1;
    let left = dir === 1 ? ax + gap : ax - gap - cw;
    let top = ay - 46;
    top = Math.max(H * 0.11, Math.min(H * 0.86 - ch, top));
    card.style.transform = `translate(${Math.round(left)}px, ${Math.round(top)}px)`;
    const cardEdge = dir === 1 ? left : left + cw;
    const elbowY = top + 34;
    const elbowX = ax + dir * Math.min(36, gap * 0.4);
    $('#tetherLine').setAttribute('points', `${ax},${ay} ${elbowX},${elbowY} ${cardEdge},${elbowY}`);
    $('#tetherDot').setAttribute('cx', ax); $('#tetherDot').setAttribute('cy', ay);
}
window.addEventListener('resize', placeInfo);

function renderDetail() {
    const st = slotState(sel.selected);
    const detail = $('#detail'), actions = $('#actions');
    const cc = sel.cfg.character;
    const stat = (label, value, big) => `<dl class="stat${big ? ' big' : ''}"><dt>${label}</dt><dd>${esc(value)}</dd></dl>`;

    if (st.kind === 'char') {
        const c = st.c;
        detail.innerHTML = stat('Bank', money(c.bank), true) + stat('Cash', money(c.cash), true)
            + stat('Last played', fmtDate(c.lastPlayed, true));
        actions.innerHTML = `${sel.data.allowDelete !== false ? '<button class="btn ghost" id="btnDelete">Delete</button>' : ''}
            <button class="btn primary" id="btnPlay">Play as ${esc(c.firstname)} <kbd>Enter</kbd></button>`;
        $('#btnPlay').onclick = () => play(c);
        if (sel.data.allowDelete !== false) $('#btnDelete').onclick = () => openDelete(c);
    } else if (st.kind === 'empty') {
        detail.innerHTML = `<p class="note">This slot is free. Create someone new to start a fresh story.</p>`;
        actions.innerHTML = `<button class="btn primary" id="btnCreate">Create character <kbd>Enter</kbd></button>`;
        $('#btnCreate').onclick = () => openCreate(sel.selected);
    } else {
        const link = sel.data.lockedLink ? ` <b>${esc(sel.data.lockedLink)}</b>` : '';
        const extra = st.kind === 'lockedchar' ? 'This character sits above your current slot allowance. ' : '';
        detail.innerHTML = `<p class="note">${extra}${esc(sel.data.lockedText || '')}${link}</p>`;
        actions.innerHTML = '';
    }
}

function choose(slot) {
    if (sel.busy) return;
    closeCreate();
    sel.selected = slot;
    renderRoster();
    post('select', { op: 'focus', slot });
}

async function play(c) {
    if (sel.busy) return;
    sel.busy = true;
    const ok = await post('select', { op: 'play', id: c.id });
    sel.busy = false;
    if (!ok) return;
}

/* create */
function openCreate(slot) {
    sel.createSlot = slot;
    const cc = sel.cfg.character;
    const f = $('#createForm');
    f.reset();
    $('#createErr').textContent = '';
    $('#createSlot').textContent = `Slot ${slot}`;
    $('#nationality').innerHTML = cc.nationalities.map((n) => `<option${n === cc.defaultNationality ? ' selected' : ''}>${esc(n)}</option>`).join('');
    const now = new Date();
    const max = new Date(now.getFullYear() - cc.minAge, now.getMonth(), now.getDate());
    const min = new Date(now.getFullYear() - cc.maxAge, now.getMonth(), now.getDate());
    const iso = (d) => d.toISOString().slice(0, 10);
    f.dob.max = iso(max); f.dob.min = iso(min);
    f.dob.value = iso(new Date(now.getFullYear() - 25, 0, 1));
    $('#create').hidden = false;
    $('#actions').hidden = true;
    placeInfo();
    f.firstname.focus();
}
function closeCreate() { $('#create').hidden = true; $('#actions').hidden = false; placeInfo(); }

$('#createCancel').onclick = closeCreate;
$('#createForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    if (sel.busy) return;
    const f = e.target, cc = sel.cfg.character;
    const data = {
        firstname: f.firstname.value.trim(),
        lastname: f.lastname.value.trim(),
        dob: f.dob.value,
        gender: f.gender.value,
        nationality: f.nationality.value,
    };
    const nameOk = (n) => n.length >= cc.nameMin && n.length <= cc.nameMax && /^[\p{L}\s'-]+$/u.test(n);
    if (!nameOk(data.firstname) || !nameOk(data.lastname)) {
        $('#createErr').textContent = `Names need ${cc.nameMin}–${cc.nameMax} letters. Hyphens, spaces and apostrophes are fine.`;
        return;
    }
    if (!data.dob) { $('#createErr').textContent = 'Pick a date of birth.'; return; }
    $('#createErr').textContent = '';
    sel.busy = true;
    await post('select', { op: 'create', slot: sel.createSlot, data });
    sel.busy = false;
});

/* delete */
function openDelete(c) {
    sel.deleting = c;
    const full = `${c.firstname} ${c.lastname}`;
    $('#delText').textContent = `${full} will be gone for good, including their money and items.`;
    const needName = sel.cfg.character.confirmName;
    $('#delConfirmWrap').hidden = !needName;
    $('#delConfirm').value = '';
    $('#delGo').disabled = needName;
    $('#deleteModal').hidden = false;
    if (needName) $('#delConfirm').focus();
}
$('#delConfirm').addEventListener('input', (e) => {
    const c = sel.deleting;
    $('#delGo').disabled = e.target.value.trim().toLowerCase() !== `${c.firstname} ${c.lastname}`.toLowerCase();
});
$('#delCancel').onclick = () => { $('#deleteModal').hidden = true; };
$('#delGo').onclick = async () => {
    const c = sel.deleting;
    $('#deleteModal').hidden = true;
    sel.busy = true;
    await post('select', { op: 'delete', id: c.id });
    sel.busy = false;
};

function openSelect(d) {
    sel.data = d; sel.cfg = d.config; sel.selected = d.selected || 1;
    applyTheme(d.theme);
    const screen = $('#select');
    screen.hidden = false;
    screen.classList.add('intro');
    closeCreate();
    renderRoster();
    requestAnimationFrame(() => requestAnimationFrame(() => screen.classList.remove('intro')));
}

/* ═════════════════════ Admin ═════════════════════ */
const adm = { data: null, tab: 'scenes', draft: null };

const TAB_TITLES = { scenes: 'Scenes', slots: 'Slots', players: 'Players', discord: 'Discord', appearance: 'Appearance' };

function adminBrand() {
    const t = adm.draft.theme || {};
    const img = t.logo ? `<img src="${esc(logoSrc(t))}" alt="" onerror="this.remove()">` : '';
    $('#adminBrand').innerHTML = `${img}<div>${esc(t.serverName || 'Vinewood')}<small>Character selection</small></div>`;
}

function openAdmin(d) {
    adm.data = normAdmin(d);
    adm.draft = JSON.parse(JSON.stringify(adm.data.settings));
    applyTheme(adm.draft.theme);
    $('#adminFw').textContent = `Framework: ${adm.data.framework}`;
    $('#admin').hidden = false;
    renderAdmin();
}
function closeAdmin() {
    closePicker();
    if (adm.data) applyTheme(adm.data.settings.theme); // drop unsaved theme previews
    $('#admin').hidden = true;
    post('admin', { op: 'close' });
}
$('#adminClose').onclick = closeAdmin;
$$('.tabs button').forEach((b) => b.addEventListener('click', () => {
    adm.tab = b.dataset.tab;
    $$('.tabs button').forEach((x) => x.classList.toggle('on', x === b));
    closePicker();
    renderAdmin();
}));

function applyAdmin(res) {
    if (!res) { toast('That did not work. Check the server console.', 'error'); return false; }
    if (res.error) { toast(res.error, 'error'); return false; }
    adm.data = normAdmin(res);
    adm.draft = JSON.parse(JSON.stringify(adm.data.settings));
    applyTheme(adm.draft.theme);
    renderAdmin();
    return true;
}

async function saveSettings(msg = 'Settings saved.') {
    const res = await post('admin', { op: 'saveSettings', settings: adm.draft });
    if (applyAdmin(res)) toast(msg, 'success');
}

function renderAdmin() {
    const body = $('#adminBody');
    $('#adminTitle').textContent = TAB_TITLES[adm.tab];
    adminBrand();
    const fn = { scenes: adminScenes, slots: adminSlots, players: adminPlayers, discord: adminDiscord, appearance: adminAppearance }[adm.tab];
    const scroll = body.scrollTop;
    body.innerHTML = fn();
    body.scrollTop = scroll;
    bindAdmin(body);
    if (adm.tab === 'appearance') bindAppearance(body);
}

function adminAppearance() {
    const t = adm.draft.theme;
    const colour = (key, label) => `<button class="colour" data-colour="${key}"><i style="background:${t[key]}"></i><span>${label}<small>${t[key]}</small></span></button>`;
    const seg = (key, opts) => `<div class="segctl">${opts.map(([v, l]) => `<button data-seg="${key}" data-val="${v}" class="${String(t[key]) === String(v) ? 'on' : ''}">${l}</button>`).join('')}</div>`;
    const pvLogo = t.logo ? `<img src="${esc(logoSrc(t))}" style="height:${Math.round(t.logoSize / 3.2)}px" alt="" onerror="this.remove()">` : '';
    const pvName = t.showName !== false || !t.logo ? esc(t.serverName) : '';
    return `<div class="appear">
        <div class="controls">
            <div class="card">
                <h3>Colour presets</h3>
                <div class="presets">${PRESETS.map((p) => `<button class="preset ${t.preset === p.id ? 'on' : ''}" data-preset="${p.id}"><i style="background:${p.accent}"></i>${p.label}</button>`).join('')}</div>
            </div>
            <div class="card">
                <h3>Colours</h3>
                <div class="colours">${colour('accent', 'Accent')}${colour('surface', 'Panels & shading')}${colour('text', 'Text')}${colour('bar', 'Letterbox bars')}${colour('danger', 'Warnings')}</div>
            </div>
            <div class="card">
                <h3>Branding</h3>
                <div class="grid" style="grid-template-columns:1fr 1fr;margin-bottom:12px">
                    <label>Server name<input data-theme="serverName" value="${esc(t.serverName)}" maxlength="40"></label>
                    <label>Tagline<input data-theme="tagline" value="${esc(t.tagline)}" maxlength="80"></label>
                </div>
                <label>Logo<input data-theme="logo" value="${esc(t.logo)}" placeholder="https://… or img/logo.png"></label>
                <p class="help" style="margin:6px 0 12px">Paste an https image link, or drop a file into <b>web/img/</b> and type <b>img/yourfile.png</b>. Transparent PNG, SVG or WebP looks best.</p>
                <label>Logo size<div class="range-row"><input type="range" min="24" max="160" value="${t.logoSize}" data-theme="logoSize" data-num><output>${t.logoSize}px</output></div></label>
                <label class="check" style="margin-top:10px"><input type="checkbox" data-theme="showName" ${t.showName !== false ? 'checked' : ''}>Show the server name next to the logo</label>
            </div>
            <div class="card">
                <h3>Heading font</h3>
                <div class="fonts">${Object.entries(FONTS).map(([id, f]) => `<button class="font-opt ${t.font === id ? 'on' : ''}" data-font="${id}" style="font-family:${f.css}">Ada Price<small>${f.label}</small></button>`).join('')}</div>
            </div>
            <div class="card">
                <h3>Layout</h3>
                <div class="toolbar" style="margin-bottom:12px"><span style="font-size:13px;color:var(--muted)">Character list on the</span>${seg('layout', [['left', 'Left'], ['right', 'Right']])}</div>
                <label>Shading behind the list<div class="range-row"><input type="range" min="0" max="1" step="0.05" value="${t.vignette}" data-theme="vignette" data-num><output>${Math.round(t.vignette * 100)}%</output></div></label>
                <div class="toggles" style="margin-top:12px">
                    <label class="check"><input type="checkbox" data-theme="letterbox" ${t.letterbox !== false ? 'checked' : ''}>Solid letterbox bars</label>
                    <label class="check"><input type="checkbox" data-theme="frame" ${t.frame !== false ? 'checked' : ''}>Viewfinder corners</label>
                </div>
            </div>
        </div>
        <div class="preview">
            <div class="pv ${t.layout === 'right' ? 'right' : ''} ${t.letterbox === false ? 'nobars' : ''} ${t.frame === false ? 'noframe' : ''}">
                <div class="pv-vig"></div>
                <div class="pv-frame"><i></i><i></i><i></i><i></i></div>
                <div class="pv-bar top"><div class="pv-brand">${pvLogo}${pvName}</div><div class="pv-pips"><i class="u"></i><i class="u"></i><i></i></div></div>
                <div class="pv-roster">
                    <div class="pv-row on"><b>Ada Price</b><span>Police Constable</span></div>
                    <div class="pv-row"><b>Tommy Reid</b><span>Mechanic</span></div>
                    <div class="pv-row"><b>New character</b><span>Empty slot</span></div>
                </div>
                <div class="pv-bar bottom"><div class="pv-stats"><span><small>Bank</small>£24,310</span><span><small>Cash</small>£820</span></div><span class="pv-play">Play as Ada</span></div>
            </div>
            <p class="help" style="margin-top:10px">Live preview. Changes show here and across this menu straight away; players see them after you save.</p>
            <div class="preview-actions">
                <button class="btn ghost" data-action="resetTheme">Reset to defaults</button>
                <button class="btn primary" data-action="saveSettings">Save appearance</button>
            </div>
        </div>
    </div>`;
}

const THEME_DEFAULTS = { preset: 'sodium', accent: '#F2A93B', surface: '#0E1218', text: '#F3EFE6', danger: '#E5484D', bar: '#000000', font: 'bigshoulders', logoSize: 64, showName: true, letterbox: true, frame: true, vignette: 0.75, layout: 'left' };

function bindAppearance(root) {
    const t = adm.draft.theme;
    const live = (rerender = true) => { applyTheme(t); if (rerender) renderAdmin(); };
    $$('[data-preset]', root).forEach((b) => b.onclick = () => {
        const p = PRESETS.find((x) => x.id === b.dataset.preset);
        Object.assign(t, { preset: p.id, accent: p.accent, surface: p.surface, text: p.text, bar: p.bar });
        live();
    });
    $$('[data-colour]', root).forEach((b) => b.onclick = () => {
        const key = b.dataset.colour;
        openPicker(b, t[key], (hex) => {
            t[key] = hex; t.preset = 'custom';
            const chip = $(`[data-colour="${key}"]`, $('#adminBody'));
            if (chip) { $('i', chip).style.background = hex; $('small', chip).textContent = hex; }
            applyTheme(t);
            $$('.preset.on', root).forEach((x) => x.classList.remove('on'));
        });
    });
    $$('[data-theme]', root).forEach((el) => {
        const handler = () => {
            const k = el.dataset.theme;
            t[k] = el.type === 'checkbox' ? el.checked : (el.dataset.num !== undefined ? Number(el.value) : el.value.trim());
            if (el.type === 'range') {
                const out = el.parentElement.querySelector('output');
                if (out) out.textContent = k === 'vignette' ? `${Math.round(t[k] * 100)}%` : `${t[k]}px`;
                applyTheme(t);
                return;
            }
            live();
        };
        el.addEventListener(el.type === 'range' ? 'input' : 'change', handler);
        if (el.type === 'range') el.addEventListener('change', () => live());
    });
    $$('[data-font]', root).forEach((b) => b.onclick = () => { t.font = b.dataset.font; live(); });
    $$('[data-seg]', root).forEach((b) => b.onclick = () => { t[b.dataset.seg] = b.dataset.val; live(); });
}

function adminScenes() {
    const s = adm.draft, scenes = adm.data.scenes;
    const rows = scenes.map((sc) => `
        <tr class="${sc.enabled ? '' : 'off'}">
            <td>${esc(sc.name)}</td>
            <td class="num">${(sc.spots || []).length}</td>
            <td class="num">${(sc.props || []).length}</td>
            <td class="num">${(sc.camera?.intro || []).length}</td>
            <td><input type="number" min="0" max="100" value="${sc.weight}" data-weight="${sc.id}" style="width:70px"></td>
            <td><label class="check"><input type="checkbox" data-toggle="${sc.id}" ${sc.enabled ? 'checked' : ''}>${sc.enabled ? 'On' : 'Off'}</label></td>
            <td style="text-align:right;white-space:nowrap">
                <button class="btn ghost small" data-edit="${sc.id}">Edit in game</button>
                <button class="btn ghost small" data-preview="${sc.id}">Preview</button>
                <button class="btn ghost small" data-dup="${sc.id}">Duplicate</button>
                <button class="btn ghost small" data-del="${sc.id}">Delete</button>
            </td>
        </tr>`).join('');
    return `
        <section>
            <div class="toolbar">
                <label>Which scene players see
                    <select data-set="sceneMode">
                        <option value="random" ${s.sceneMode !== 'fixed' ? 'selected' : ''}>Random, by weight</option>
                        <option value="fixed" ${s.sceneMode === 'fixed' ? 'selected' : ''}>Always the same scene</option>
                    </select>
                </label>
                ${s.sceneMode === 'fixed' ? `<label>Scene
                    <select data-set="fixedScene" data-num>${scenes.map((sc) => `<option value="${sc.id}" ${s.fixedScene === sc.id ? 'selected' : ''}>${esc(sc.name)}</option>`).join('')}</select>
                </label>` : ''}
                <button class="btn ghost" data-action="saveMode">Save</button>
                <span style="flex:1"></span>
                <button class="btn primary" data-action="newScene">New scene</button>
            </div>
            <p class="help">Weight decides how often a scene comes up in random mode. A scene with weight 0 or turned off is never picked. With no scenes, players see the fallback scene from config.lua.</p>
            ${scenes.length ? `<table><thead><tr><th>Name</th><th>Spots</th><th>Props</th><th>Keyframes</th><th>Weight</th><th>Live</th><th></th></tr></thead><tbody>${rows}</tbody></table>`
            : `<p class="empty-state">No scenes yet. Create one, and you'll fly a camera around the map to place characters, props and camera moves.</p>`}
        </section>`;
}

function adminSlots() {
    const s = adm.draft;
    const aces = (s.aceBonuses || []).map((a, i) => `
        <tr><td><input value="${esc(a.ace)}" data-ace="${i}" data-field="ace"></td>
        <td><input value="${esc(a.label)}" data-ace="${i}" data-field="label"></td>
        <td><input type="number" value="${a.slots}" data-ace="${i}" data-field="slots" style="width:80px"></td>
        <td style="text-align:right"><button class="btn ghost small" data-ace-del="${i}">Remove</button></td></tr>`).join('');
    return `
        <section>
            <h3>Everyone</h3>
            <div class="grid">
                <label>Base slots<input type="number" min="1" max="50" value="${s.base}" data-set="base" data-num></label>
                <label>Maximum slots<input type="number" min="1" max="50" value="${s.max}" data-set="max" data-num></label>
                <label>Locked slots to show<input type="number" min="0" max="10" value="${s.showLocked}" data-set="showLocked" data-num></label>
            </div>
            <label class="check"><input type="checkbox" data-set="stack" ${s.stack ? 'checked' : ''}>Bonuses add together (off: only the biggest bonus counts)</label>
            <label class="check" style="margin-top:8px"><input type="checkbox" data-set="lockExcess" ${s.lockExcess ? 'checked' : ''}>Lock characters sitting above a player's allowance</label>
            <label class="check" style="margin-top:8px"><input type="checkbox" data-set="allowDelete" ${s.allowDelete !== false ? 'checked' : ''}>Players can delete their own characters</label>
            <div class="grid" style="margin-top:14px">
                <label class="full" style="grid-column:1/-1">Text on locked slots<input value="${esc(s.lockedText)}" data-set="lockedText"></label>
                <label>Link shown on locked slots<input value="${esc(s.lockedLink)}" data-set="lockedLink"></label>
            </div>
        </section>
        <section>
            <h3>ACE permission bonuses</h3>
            <p class="help">Give a group extra slots in server.cfg, for example <b>add_ace group.vip vinewood.multichar.vip allow</b>, then list the permission here.</p>
            <table><thead><tr><th>Permission</th><th>Label</th><th>Extra slots</th><th></th></tr></thead><tbody>${aces}</tbody></table>
            <div class="add-row"><button class="btn ghost small" data-action="addAce">Add permission</button></div>
        </section>
        <section><button class="btn primary" data-action="saveSettings">Save slot settings</button></section>`;
}

function adminPlayers() {
    const players = adm.data.players.map((p) => `
        <tr><td class="num">${p.id}</td><td>${esc(p.name)}</td>
        <td class="num">${p.allowed}</td>
        <td class="breakdown">${p.breakdown.map((b) => `${esc(b.label)} ${b.slots >= 0 ? '+' : ''}${b.slots}`).join(', ')}</td>
        <td style="text-align:right"><button class="btn ghost small" data-pick="${p.id}">Adjust</button></td></tr>`).join('');
    const overrides = adm.data.overrides.map((o) => `
        <tr><td>${esc(o.name || '–')}<div class="breakdown">${esc(o.identifier)}</div></td>
        <td>${o.mode === 'set' ? 'Exactly' : 'Extra'}</td><td class="num">${o.slots}</td>
        <td>${esc(o.note || '')}</td><td class="breakdown">${esc(o.set_by || '')}</td>
        <td style="text-align:right"><button class="btn ghost small" data-ovr-del="${esc(o.identifier)}">Remove</button></td></tr>`).join('');
    return `
        <section>
            <h3>Give someone slots</h3>
            <p class="help">Use an online server id, or paste a licence or Discord identifier for someone offline (license:abc… or discord:123…). Extra adds on top of everything else; Exactly ignores all other bonuses.</p>
            <div class="toolbar">
                <label style="flex:2">Server id or identifier<input id="ovrId" placeholder="12 or license:abc123"></label>
                <label>Type<select id="ovrMode"><option value="add">Extra slots</option><option value="set">Exactly</option></select></label>
                <label style="max-width:110px">Slots<input id="ovrSlots" type="number" value="1"></label>
                <label style="flex:2">Note<input id="ovrNote" placeholder="e.g. Tebex VIP until March"></label>
                <button class="btn primary" data-action="saveOverride">Save</button>
            </div>
        </section>
        <section>
            <h3>Online now</h3>
            ${players ? `<table><thead><tr><th>ID</th><th>Name</th><th>Slots</th><th>Made up of</th><th></th></tr></thead><tbody>${players}</tbody></table>` : '<p class="empty-state">Nobody else is online.</p>'}
        </section>
        <section>
            <h3>Personal overrides</h3>
            ${overrides ? `<table><thead><tr><th>Player</th><th>Type</th><th>Slots</th><th>Note</th><th>Set by</th><th></th></tr></thead><tbody>${overrides}</tbody></table>` : '<p class="empty-state">No personal overrides yet.</p>'}
        </section>`;
}

function adminDiscord() {
    const s = adm.draft, dc = adm.data.discord;
    const roles = dc.roles || [];
    const roleSelect = (r, i) => roles.length
        ? `<select data-role="${i}" data-field="roleId"><option value="">Pick a role</option>${roles.map((g) => `<option value="${g.id}" ${g.id === r.roleId ? 'selected' : ''}>${esc(g.name)}</option>`).join('')}${r.roleId && !roles.find((g) => g.id === r.roleId) ? `<option value="${esc(r.roleId)}" selected>${esc(r.roleId)}</option>` : ''}</select>`
        : `<input value="${esc(r.roleId)}" data-role="${i}" data-field="roleId" placeholder="Role id">`;
    const rows = (s.discordRoles || []).map((r, i) => `
        <tr><td>${roleSelect(r, i)}</td>
        <td><input value="${esc(r.label)}" data-role="${i}" data-field="label"></td>
        <td><input type="number" value="${r.slots}" data-role="${i}" data-field="slots" style="width:80px"></td>
        <td style="text-align:right"><button class="btn ghost small" data-role-del="${i}">Remove</button></td></tr>`).join('');
    return `
        <section>
            <div class="toolbar">
                <span class="pill ${dc.enabled ? 'on' : 'warn'}">${dc.enabled ? 'Connected' : 'Not set up'}</span>
                <span style="flex:1"></span>
                <button class="btn ghost small" data-action="refreshDiscord">Refresh roles</button>
            </div>
            <p class="help">${dc.enabled
                ? 'Players with these roles in your Discord get extra slots. Roles are re-checked every few minutes and each time someone opens the selection screen.'
                : 'Turn Discord on in server/config_server.lua with your bot token and server id, then restart the resource. Until then, role bonuses below are saved but not applied.'}</p>
            <table><thead><tr><th>Discord role</th><th>Label</th><th>Extra slots</th><th></th></tr></thead><tbody>${rows}</tbody></table>
            <div class="add-row"><button class="btn ghost small" data-action="addRole">Add role</button></div>
        </section>
        <section><button class="btn primary" data-action="saveSettings">Save Discord roles</button></section>`;
}

function bindAdmin(root) {
    const s = adm.draft;
    $$('[data-set]', root).forEach((el) => el.addEventListener('change', () => {
        const k = el.dataset.set;
        s[k] = el.type === 'checkbox' ? el.checked : (el.dataset.num !== undefined ? Number(el.value) : el.value);
        if (k === 'sceneMode') { if (s.sceneMode === 'fixed' && !s.fixedScene && adm.data.scenes[0]) s.fixedScene = adm.data.scenes[0].id; renderAdmin(); }
    }));
    $$('[data-ace]', root).forEach((el) => el.addEventListener('change', () => {
        const a = s.aceBonuses[+el.dataset.ace]; a[el.dataset.field] = el.type === 'number' ? Number(el.value) : el.value;
    }));
    $$('[data-role]', root).forEach((el) => el.addEventListener('change', () => {
        const r = s.discordRoles[+el.dataset.role];
        r[el.dataset.field] = el.type === 'number' ? Number(el.value) : el.value;
        if (el.dataset.field === 'roleId' && el.tagName === 'SELECT' && (!r.label || /^\d+$/.test(r.label))) {
            const g = adm.data.discord.roles.find((x) => x.id === el.value); if (g) { r.label = g.name; renderAdmin(); }
        }
    }));
    $$('[data-ace-del]', root).forEach((b) => b.onclick = () => { s.aceBonuses.splice(+b.dataset.aceDel, 1); renderAdmin(); });
    $$('[data-role-del]', root).forEach((b) => b.onclick = () => { s.discordRoles.splice(+b.dataset.roleDel, 1); renderAdmin(); });

    const sceneAction = async (action, id, value) => applyAdmin(await post('admin', { op: 'sceneAction', action, id, value }));
    $$('[data-toggle]', root).forEach((el) => el.onchange = () => sceneAction('toggle', +el.dataset.toggle, el.checked));
    $$('[data-weight]', root).forEach((el) => el.onchange = () => sceneAction('weight', +el.dataset.weight, Number(el.value)));
    $$('[data-dup]', root).forEach((b) => b.onclick = () => sceneAction('duplicate', +b.dataset.dup));
    $$('[data-del]', root).forEach((b) => b.onclick = () => {
        if (b.dataset.confirm) return sceneAction('delete', +b.dataset.del);
        b.dataset.confirm = '1'; b.textContent = 'Confirm delete'; b.classList.add('danger');
    });
    $$('[data-edit]', root).forEach((b) => b.onclick = async () => { $('#admin').hidden = true; await post('admin', { op: 'editScene', id: +b.dataset.edit }); });
    $$('[data-preview]', root).forEach((b) => b.onclick = async () => { $('#admin').hidden = true; await post('admin', { op: 'previewScene', id: +b.dataset.preview }); });
    $$('[data-pick]', root).forEach((b) => b.onclick = () => { $('#ovrId').value = b.dataset.pick; $('#ovrSlots').focus(); });
    $$('[data-ovr-del]', root).forEach((b) => b.onclick = async () => {
        if (applyAdmin(await post('admin', { op: 'removeOverride', identifier: b.dataset.ovrDel }))) toast('Override removed.', 'success');
    });

    $$('[data-action]', root).forEach((b) => b.onclick = async () => {
        const a = b.dataset.action;
        if (a === 'newScene') { $('#admin').hidden = true; await post('admin', { op: 'newScene' }); }
        else if (a === 'saveSettings' || a === 'saveMode') { closePicker(); saveSettings(); }
        else if (a === 'resetTheme') { Object.assign(adm.draft.theme, THEME_DEFAULTS); applyTheme(adm.draft.theme); renderAdmin(); toast('Defaults restored. Save to keep them.'); }
        else if (a === 'addAce') { s.aceBonuses = s.aceBonuses || []; s.aceBonuses.push({ ace: 'vinewood.multichar.', label: 'New group', slots: 1 }); renderAdmin(); }
        else if (a === 'addRole') { s.discordRoles = s.discordRoles || []; s.discordRoles.push({ roleId: '', label: '', slots: 1 }); renderAdmin(); }
        else if (a === 'refreshDiscord') { if (applyAdmin(await post('admin', { op: 'refresh', discord: true }))) toast('Discord roles refreshed.', 'success'); }
        else if (a === 'saveOverride') {
            const override = { identifier: $('#ovrId').value.trim(), mode: $('#ovrMode').value, slots: Number($('#ovrSlots').value), note: $('#ovrNote').value.trim() };
            if (!override.identifier) return toast('Enter a server id or identifier.', 'error');
            if (applyAdmin(await post('admin', { op: 'setOverride', override }))) toast('Slots saved.', 'success');
        }
    });
}

/* ═════════════════════ Editor ═════════════════════ */
const ed = { scene: null, poses: [], bones: [], eases: [], weathers: [], tab: 'path', expanded: { spot: 1, prop: 0, key: 0 }, mode: 'ui', playing: false,
    orbit: { spot: 1, radius: 3, height: 0.6, endHeight: 0.6, degrees: 180, points: 8, duration: 8000, dir: 'cw', fov: 40, start: 0, replace: false } };

const edOp = (op, extra) => post('editor', Object.assign({ op }, extra || {}));
const n = (v, dp = 3) => Number(Number(v).toFixed(dp));
const EASE_LABELS = { linear: 'Linear', easeInOutSine: 'Gentle', easeInOutCubic: 'Smooth', easeInOutQuint: 'Dramatic', easeOutQuart: 'Fast start', easeOutExpo: 'Snap in', easeInQuad: 'Slow start' };

function xyzFields(prefix, v, step = 0.01) {
    return ['x', 'y', 'z'].map((k) => `<label>${prefix} ${k.toUpperCase()}<input type="number" step="${step}" value="${n(v?.[k] ?? 0)}" data-xyz="${k}"></label>`).join('');
}

function poseOptions(pose) {
    const cur = pose.type === 'preset' ? pose.preset : pose.type;
    return ed.poses.map((p) => `<option value="preset:${p.id}" ${pose.type === 'preset' && pose.preset === p.id ? 'selected' : ''}>${esc(p.label)}</option>`).join('')
        + `<option value="anim" ${cur === 'anim' ? 'selected' : ''}>Custom animation</option>`
        + `<option value="scenario" ${cur === 'scenario' ? 'selected' : ''}>Custom scenario</option>`;
}
const easeOpts = (v) => ed.eases.map((e) => `<option value="${e}" ${e === v ? 'selected' : ''}>${EASE_LABELS[e] || e}</option>`).join('');

function card(kind, i, title, sub, actions, body) {
    const open = ed.expanded[kind] === i;
    return `<div class="ecard ${open ? 'open' : ''}" data-${kind}="${i}">
        <button class="ecard-head" data-toggle-card="${kind}:${i}">
            <span class="ecard-num">${String(i).padStart(2, '0')}</span>
            <span class="ecard-title"><b>${title}</b>${sub ? `<small>${sub}</small>` : ''}</span>
            <span class="chev" aria-hidden="true"></span>
        </button>
        ${open ? `<div class="ecard-body"><div class="ecard-actions">${actions}</div>${body}</div>` : ''}
    </div>`;
}

function tabScene(s) {
    return `<div class="egroup"><h4>Live</h4>
        <label class="check"><input type="checkbox" data-meta="enabled" ${s.enabled ? 'checked' : ''}>Players can get this scene</label>
        <div class="fields"><label>Weight<input type="number" min="0" max="100" value="${s.weight}" data-meta="weight"></label></div></div>
    <div class="egroup"><h4>Weather and time</h4><div class="fields">
        <label class="full">Weather<select data-meta="env.weather">${ed.weathers.map((w) => `<option ${w === s.env.weather ? 'selected' : ''}>${w}</option>`).join('')}</select></label>
        <label>Hour<input type="number" min="0" max="23" value="${s.env.hour}" data-meta="env.hour"></label>
        <label>Minute<input type="number" min="0" max="59" value="${s.env.minute}" data-meta="env.minute"></label>
        <label class="check full"><input type="checkbox" data-meta="env.freeze" ${s.env.freeze ? 'checked' : ''}>Hold the time of day</label>
    </div></div>`;
}

function tabCamera(s) {
    const cam = s.camera;
    return `<div class="egroup"><h4>Between characters</h4><div class="fields">
        <label>Move time (ms)<input type="number" step="100" min="100" value="${cam.transition}" data-meta="camera.transition"></label>
        <label>Feel<select data-meta="camera.ease">${easeOpts(cam.ease)}</select></label>
    </div></div>
    <div class="egroup"><h4>Lens</h4><div class="fields">
        <label>Handheld sway<input type="number" step="0.01" min="0" max="2" value="${cam.shake}" data-meta="camera.shake"></label>
        <label>Background blur<input type="number" step="0.05" min="0" max="1" value="${cam.dof.strength}" data-meta="camera.dof.strength"></label>
        <label class="check full"><input type="checkbox" data-meta="camera.dof.enabled" ${cam.dof.enabled ? 'checked' : ''}>Depth of field on characters</label>
    </div></div>`;
}

function tabSpots(s) {
    const items = s.spots.map((sp, idx) => {
        const i = idx + 1, p = sp.pose || { type: 'none' }; sp.pose = p;
        const poseLabel = p.type === 'preset' ? (ed.poses.find((x) => x.id === p.preset)?.label || p.preset) : (p.type === 'anim' ? 'Custom animation' : p.type === 'scenario' ? p.scenario || 'Scenario' : 'Standing');
        const actions = `<button class="chip" data-sop="moveSpot">Move</button><button class="chip" data-sop="gotoSpot">Look</button>
            <button class="chip" data-sop="camView">Shot from my view</button>${sp.cam ? '<button class="chip" data-sop="camAuto">Auto shot</button>' : ''}
            <button class="chip danger" data-sop="removeSpot">Remove</button>`;
        const body = `<div class="fields">
                <label class="full">Pose<select data-pose>${poseOptions(p)}</select></label>
                ${p.type === 'anim' ? `<label class="full">Dictionary<input data-pf="dict" value="${esc(p.dict || '')}"></label><label>Clip<input data-pf="clip" value="${esc(p.clip || '')}"></label><label>Flag<input type="number" data-pf="flag" value="${p.flag ?? 1}"></label>` : ''}
                ${p.type === 'scenario' ? `<label class="full">Scenario<input data-pf="scenario" value="${esc(p.scenario || '')}" placeholder="WORLD_HUMAN_SMOKING"></label>` : ''}
                <label>Heading<input type="number" step="1" value="${n(sp.heading, 1)}" data-heading></label>
                <label>Shot<input disabled value="${sp.cam ? 'Custom' : 'Automatic'}"></label>
            </div>
            <div class="fields three" data-spos>${xyzFields('', sp.pos)}</div>
            <div class="sub-h">Hand prop</div>
            <div class="fields" data-hprop>
                <label>Model<input data-hp="model" value="${esc(sp.prop?.model || '')}" placeholder="prop_npc_phone_02"></label>
                <label>Bone<select data-hp="bone">${ed.bones.map((b) => `<option value="${b.id}" ${(sp.prop?.bone ?? 57005) === b.id ? 'selected' : ''}>${esc(b.label)}</option>`).join('')}</select></label>
            </div>
            <div class="fields three" data-hoff>${xyzFields('Off', sp.prop?.offset)}</div>
            <div class="fields three" data-hrot>${xyzFields('Rot', sp.prop?.rot, 1)}</div>
            <div class="ecard-actions"><button class="chip" data-sop="applyProp">Apply prop</button>${sp.prop ? '<button class="chip danger" data-sop="clearProp">Remove prop</button>' : ''}</div>`;
        return card('spot', i, `Spot ${i}`, esc(poseLabel) + (sp.prop ? ` · ${esc(sp.prop.model)}` : ''), actions, body);
    }).join('');
    return `<p class="ehelp">Each character slot stands on a spot. With fewer spots than slots, characters take turns.</p>${items || '<p class="eempty">No spots yet.</p>'}
        <button class="btn ghost wide" data-op="addSpot">Add character spot</button>`;
}

function tabProps(s) {
    const items = s.props.map((p, idx) => {
        const i = idx + 1;
        const actions = `<button class="chip" data-pop="moveProp">Move</button><button class="chip" data-pop="duplicateProp">Duplicate</button><button class="chip danger" data-pop="removeProp">Remove</button>`;
        const body = `<div class="fields three" data-ppos>${xyzFields('', p.pos)}</div>
            <div class="fields three" data-prot>${xyzFields('Rot', p.rot, 1)}</div>
            <label class="check" style="margin-top:10px"><input type="checkbox" data-pcol ${p.collision ? 'checked' : ''}>Collision</label>`;
        return card('prop', i, esc(p.model), p.collision ? '' : 'No collision', actions, body);
    }).join('');
    return `${items || '<p class="eempty">No props yet.</p>'}
        <div class="add-inline"><input id="propModel" placeholder="Model, e.g. prop_table_03"><button class="btn ghost" data-op="addProp">Add</button></div>`;
}

function tabPath(s) {
    const cam = s.camera, o = ed.orbit;
    const spotOpts = (v, withNone) => (withNone ? `<option value="0" ${!v ? 'selected' : ''}>Free (use my angle)</option>` : '')
        + s.spots.map((_, i) => `<option value="${i + 1}" ${v === i + 1 ? 'selected' : ''}>Track spot ${i + 1}</option>`).join('');
    const total = cam.intro.reduce((t, k, i) => t + (i ? k.duration : 0) + (k.hold || 0), 0);
    const keys = cam.intro.map((k, idx) => {
        const i = idx + 1;
        const sub = [i > 1 ? `${(k.duration / 1000).toFixed(1)}s` : 'Start', k.hold ? `hold ${(k.hold / 1000).toFixed(1)}s` : '', k.aim ? `tracks spot ${k.aim}` : '', k.rot.y ? `roll ${n(k.rot.y, 0)}°` : ''].filter(Boolean).join(' · ');
        const actions = `<button class="chip" data-kop="gotoKeyframe">Look</button><button class="chip" data-kop="replaceKeyframe">Use my view</button>
            <button class="chip" data-kop="up" ${i === 1 ? 'disabled' : ''}>Up</button><button class="chip" data-kop="down" ${i === cam.intro.length ? 'disabled' : ''}>Down</button>
            <button class="chip danger" data-kop="removeKeyframe">Remove</button>`;
        const body = `<div class="fields">
            ${i === 1 ? '' : `<label>Travel time (ms)<input type="number" step="100" min="0" value="${k.duration}" data-kf="duration"></label>`}
            <label>Pause here (ms)<input type="number" step="100" min="0" value="${k.hold}" data-kf="hold"></label>
            <label>Field of view<input type="number" step="1" min="5" max="130" value="${n(k.fov, 1)}" data-kf="fov"></label>
            <label>Roll (°)<input type="number" step="1" min="-90" max="90" value="${n(k.rot.y || 0, 1)}" data-kf="roll"></label>
            <label class="full">Aim<select data-kf="aim">${spotOpts(k.aim, true)}</select></label>
            ${i === 1 || cam.flow ? '' : `<label class="full">Easing into this keyframe<select data-kf="ease">${easeOpts(k.ease)}</select></label>`}
        </div>`;
        return card('key', i, `Keyframe ${i}`, sub, actions, body);
    }).join('');

    return `<div class="egroup"><h4>Motion</h4>
        <div class="segctl wide">
            <button data-motion="flow" class="${cam.flow ? 'on' : ''}">Continuous</button>
            <button data-motion="step" class="${cam.flow ? '' : 'on'}">Stop at each keyframe</button>
        </div>
        <p class="ehelp">${cam.flow ? 'One smooth move through every keyframe. Only “Pause here” stops the camera.' : 'The camera eases in and out of every keyframe.'}</p>
        <div class="fields">
            ${cam.flow ? `<label>Overall feel<select data-meta="camera.pathEase">${easeOpts(cam.pathEase)}</select></label>` : ''}
            <label class="check ${cam.flow ? '' : 'full'}"><input type="checkbox" data-meta="camera.glide" ${cam.glide ? 'checked' : ''}>Glide into first character</label>
        </div>
        <div class="path-stats"><span><b>${cam.intro.length}</b> keyframes</span><span><b>${(total / 1000).toFixed(1)}s</b> total</span>
            <button class="chip" data-op="evenSpeed">Even out speed</button>${cam.intro.length ? '<button class="chip danger" data-op="clearPath">Clear</button>' : ''}</div>
    </div>
    <div class="egroup"><h4>Keyframes</h4>
        ${keys || '<p class="eempty">Fly somewhere and press <kbd>C</kbd>, or add from your view.</p>'}
        <button class="btn ghost wide" data-op="addKeyframe">Add keyframe from my view</button>
    </div>
    <div class="egroup"><h4>Orbit move</h4>
        <p class="ehelp">Builds keyframes in an arc around a character, always tracking them.</p>
        <div class="fields" data-orbit>
            <label class="full">Around<select data-o="spot">${s.spots.map((_, i) => `<option value="${i + 1}" ${o.spot === i + 1 ? 'selected' : ''}>Spot ${i + 1}</option>`).join('') || '<option>No spots yet</option>'}</select></label>
            <label>Distance (m)<input type="number" step="0.1" value="${o.radius}" data-o="radius"></label>
            <label>Sweep (°)<input type="number" step="15" value="${o.degrees}" data-o="degrees"></label>
            <label>Start height (m)<input type="number" step="0.1" value="${o.height}" data-o="height"></label>
            <label>End height (m)<input type="number" step="0.1" value="${o.endHeight}" data-o="endHeight"></label>
            <label>Start angle (°)<input type="number" step="15" value="${o.start}" data-o="start"></label>
            <label>Length (ms)<input type="number" step="500" value="${o.duration}" data-o="duration"></label>
            <label>Keyframes<input type="number" min="3" max="24" value="${o.points}" data-o="points"></label>
            <label>Field of view<input type="number" value="${o.fov}" data-o="fov"></label>
            <div class="segctl full"><button data-odir="cw" class="${o.dir === 'cw' ? 'on' : ''}">Clockwise</button><button data-odir="ccw" class="${o.dir === 'ccw' ? 'on' : ''}">Anticlockwise</button></div>
            <label class="check full"><input type="checkbox" data-o="replace" ${o.replace ? 'checked' : ''}>Replace the current path</label>
        </div>
        <button class="btn ghost wide" data-op="orbit">Build orbit</button>
    </div>`;
}

function renderEditor() {
    const s = ed.scene;
    $('#edName').value = s.name;
    $('#edId').textContent = s.id ? `#${s.id}` : 'Unsaved';
    const tabs = [['path', 'Path', s.camera.intro.length], ['spots', 'Spots', s.spots.length], ['props', 'Props', s.props.length], ['camera', 'Camera'], ['scene', 'Scene']];
    $('#edTabs').innerHTML = tabs.map(([id, label, count]) => `<button data-etab="${id}" class="${ed.tab === id ? 'on' : ''}">${label}${count !== undefined ? `<span>${count}</span>` : ''}</button>`).join('');
    $$('#edTabs button').forEach((b) => b.onclick = () => { ed.tab = b.dataset.etab; $('#edBody').scrollTop = 0; renderEditor(); });
    const body = $('#edBody');
    const scroll = body.scrollTop;
    body.innerHTML = { scene: tabScene, camera: tabCamera, spots: tabSpots, props: tabProps, path: tabPath }[ed.tab](s);
    body.scrollTop = scroll;
    bindEditor(body);
}

function readXYZ(wrap) {
    const o = {}; $$('[data-xyz]', wrap).forEach((i) => { o[i.dataset.xyz] = Number(i.value); }); return o;
}

function bindEditor(root) {
    $$('[data-toggle-card]', root).forEach((b) => b.onclick = () => {
        const [kind, i] = b.dataset.toggleCard.split(':');
        ed.expanded[kind] = ed.expanded[kind] === +i ? 0 : +i;
        renderEditor();
    });

    $$('[data-meta]', root).forEach((el) => el.addEventListener('change', () => {
        const path = el.dataset.meta.split('.');
        const val = el.type === 'checkbox' ? el.checked : (el.type === 'number' ? Number(el.value) : el.value);
        const payload = {}; let cur = payload;
        path.forEach((p, i) => { if (i === path.length - 1) cur[p] = val; else { cur[p] = cur[p] || {}; cur = cur[p]; } });
        edOp('meta', payload);
    }));
    $$('[data-motion]', root).forEach((b) => b.onclick = () => edOp('meta', { camera: { flow: b.dataset.motion === 'flow' } }));

    $$('[data-op]', root).forEach((b) => b.onclick = () => {
        const op = b.dataset.op;
        if (op === 'addProp') edOp('addProp', { model: $('#propModel').value.trim() });
        else if (op === 'orbit') edOp('orbit', { orbit: ed.orbit });
        else if (op === 'clearPath') { if (b.dataset.confirm) edOp('clearPath'); else { b.dataset.confirm = 1; b.textContent = 'Sure?'; } }
        else edOp(op);
    });

    $$('[data-o]', root).forEach((el) => el.onchange = () => {
        const k = el.dataset.o;
        ed.orbit[k] = el.type === 'checkbox' ? el.checked : Number(el.value);
    });
    $$('[data-odir]', root).forEach((b) => b.onclick = () => { ed.orbit.dir = b.dataset.odir; renderEditor(); });

    $$('[data-spot]', root).forEach((item) => {
        const index = +item.dataset.spot;
        const sp = ed.scene.spots[index - 1];
        if (!item.classList.contains('open')) return;
        const upd = (fields) => edOp('updateSpot', { index, fields });
        $('[data-pose]', item).onchange = (e) => {
            const v = e.target.value;
            if (v.startsWith('preset:')) upd({ pose: { type: 'preset', preset: v.slice(7) } });
            else upd({ pose: { type: v, dict: sp.pose.dict, clip: sp.pose.clip, flag: sp.pose.flag ?? 1, scenario: sp.pose.scenario } });
        };
        $$('[data-pf]', item).forEach((i) => i.onchange = () => {
            const pose = Object.assign({}, sp.pose); pose[i.dataset.pf] = i.type === 'number' ? Number(i.value) : i.value.trim(); upd({ pose });
        });
        $('[data-heading]', item).onchange = (e) => upd({ heading: Number(e.target.value) });
        $$('[data-spos] input', item).forEach((i) => i.onchange = () => upd({ pos: readXYZ($('[data-spos]', item)) }));
        $$('[data-sop]', item).forEach((b) => b.onclick = () => {
            const a = b.dataset.sop;
            if (a === 'camView') edOp('spotCam', { index });
            else if (a === 'camAuto') edOp('spotCam', { index, auto: true });
            else if (a === 'applyProp') {
                const model = $('[data-hp="model"]', item).value.trim();
                if (!model) return toast('Type a prop model first.', 'error');
                upd({ prop: { model, bone: Number($('[data-hp="bone"]', item).value), offset: readXYZ($('[data-hoff]', item)), rot: readXYZ($('[data-hrot]', item)) } });
            } else if (a === 'clearProp') upd({ prop: false });
            else edOp(a, { index });
        });
    });

    $$('[data-prop]', root).forEach((item) => {
        const index = +item.dataset.prop;
        if (!item.classList.contains('open')) return;
        $$('[data-pop]', item).forEach((b) => b.onclick = () => edOp(b.dataset.pop, { index }));
        $$('[data-ppos] input', item).forEach((i) => i.onchange = () => edOp('updateProp', { index, fields: { pos: readXYZ($('[data-ppos]', item)) } }));
        $$('[data-prot] input', item).forEach((i) => i.onchange = () => edOp('updateProp', { index, fields: { rot: readXYZ($('[data-prot]', item)) } }));
        $('[data-pcol]', item).onchange = (e) => edOp('updateProp', { index, fields: { collision: e.target.checked } });
    });

    $$('[data-key]', root).forEach((item) => {
        const index = +item.dataset.key;
        if (!item.classList.contains('open')) return;
        $$('[data-kf]', item).forEach((i) => i.onchange = () => edOp('updateKeyframe', { index, fields: { [i.dataset.kf]: i.dataset.kf === 'ease' ? i.value : Number(i.value) } }));
        $$('[data-kop]', item).forEach((b) => b.onclick = () => {
            const a = b.dataset.kop;
            if (a === 'up' || a === 'down') { edOp('moveKeyframe', { index, dir: a === 'up' ? -1 : 1 }); ed.expanded.key = index + (a === 'up' ? -1 : 1); }
            else edOp(a, { index });
        });
    });
}

$('#edName').addEventListener('change', (e) => edOp('meta', { name: e.target.value.trim() || 'Untitled scene' }));
$$('.ed-foot [data-op], .ed-head [data-op]').forEach((b) => b.onclick = () => edOp(b.dataset.op));

function renderHints(d) {
    const h = $('#hints');
    h.hidden = false;
    h.innerHTML = d.items.map(([k, label]) => `<span><kbd>${esc(k)}</kbd>${esc(label)}</span>`).join('');
    ed.mode = d.mode;
    const e = $('#editor');
    e.classList.toggle('fly', d.mode === 'fly' || d.mode === 'placing');
    e.classList.toggle('playing', d.mode === 'playing');
}

/* ═════════════════════ Messages & keys ═════════════════════ */
window.addEventListener('message', (e) => {
    const { action, data } = e.data || {};
    switch (action) {
        case 'select:open': openSelect(normSelect(data)); break;
        case 'select:update': sel.data = Object.assign(sel.data, normSelect(data)); sel.selected = data.selected || sel.selected; renderRoster(); break;
        case 'select:anchor': Object.assign(anchor, data); if (!$('#select').hidden) placeInfo(); break;
        case 'select:close': $('#select').hidden = true; $('#deleteModal').hidden = true; break;
        case 'admin:open': openAdmin(data); break;
        case 'admin:close': $('#admin').hidden = true; break;
        case 'editor:open':
            Object.assign(ed, { scene: normScene(data.scene), poses: arr(data.poses), bones: arr(data.bones), eases: arr(data.eases), weathers: arr(data.weathers) });
            $('#editor').hidden = false; renderEditor(); break;
        case 'editor:scene': ed.scene = normScene(data); if (!$('#editor').hidden) renderEditor(); break;
        case 'editor:hint': data.items = arr(data.items).map(arr); renderHints(data); break;
        case 'editor:playing': ed.playing = data; break;
        case 'editor:close': $('#editor').hidden = true; $('#hints').hidden = true; break;
        case 'theme': {
            // live update after an admin saves. Don't trample someone mid-edit in the Appearance tab.
            if (adm.data) adm.data.settings.theme = data;
            const editing = !$('#admin').hidden && adm.tab === 'appearance';
            if (!editing) {
                if (adm.draft) adm.draft.theme = JSON.parse(JSON.stringify(data));
                applyTheme(data);
                if (!$('#select').hidden && sel.data) renderRoster();
                if (!$('#admin').hidden) renderAdmin();
            }
            break;
        }
        case 'loading': loading(data.show, data.text); break;
        case 'toast': toast(data.text, data.type); break;
    }
});

window.addEventListener('keydown', (e) => {
    // Editor: Tab hands control to the camera
    if (!$('#editor').hidden && e.key === 'Tab') {
        e.preventDefault();
        if (ed.mode === 'ui') edOp('focus', { fly: true });
        return;
    }
    if (!$('#picker').hidden && e.key === 'Escape') { closePicker(); return; }
    if (!$('#admin').hidden && e.key === 'Escape') { closeAdmin(); return; }
    if (!$('#deleteModal').hidden && e.key === 'Escape') { $('#deleteModal').hidden = true; return; }
    if (!$('#create').hidden && e.key === 'Escape') { closeCreate(); return; }

    const selectOpen = !$('#select').hidden && $('#create').hidden && $('#deleteModal').hidden;
    if (!selectOpen || !sel.data) return;
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
        e.preventDefault();
        const next = Math.min(sel.data.display, Math.max(1, sel.selected + (e.key === 'ArrowDown' ? 1 : -1)));
        if (next !== sel.selected) choose(next);
    } else if (e.key === 'Enter') {
        const st = slotState(sel.selected);
        if (st.kind === 'char') play(st.c);
        else if (st.kind === 'empty') openCreate(sel.selected);
    }
});
