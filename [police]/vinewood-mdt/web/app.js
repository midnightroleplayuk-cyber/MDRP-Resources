'use strict';

const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'vinewood-mdt';
const $ = (s, el = document) => el.querySelector(s);
const main = $('#main');

const state = { cfg: null, view: 'home', cid: null, profile: null, tab: 'activity', player: null };

/* ---------- icons ---------- */
const ICON_PATHS = {
    home: '<path d="M3 11l9-8 9 8"/><path d="M5 10v10h5v-6h4v6h5V10"/>',
    user: '<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-6.5 8-6.5s8 2.5 8 6.5"/>',
    users: '<circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c0-3.6 2.9-5.6 6.5-5.6s6.5 2 6.5 5.6"/><circle cx="17" cy="9" r="2.8"/><path d="M16.5 14.6c3 .2 5 2 5 5"/>',
    car: '<path d="M3 16v-3l2.2-5.2A2 2 0 0 1 7 6.5h10a2 2 0 0 1 1.8 1.3L21 13v3"/><path d="M2 16h20v3h-3v-1.5H5V19H2z"/><path d="M6.5 12.5h.01M17.5 12.5h.01"/><path d="M5 12h14"/>',
    alert: '<path d="M12 3.5l9.5 16.5h-19z"/><path d="M12 10v4.5M12 17.2h.01"/>',
    lock: '<rect x="5" y="10.5" width="14" height="10.5" rx="1.5"/><path d="M8 10.5V7.5a4 4 0 0 1 8 0v3"/><path d="M12 14.5v2.5"/>',
    pin: '<path d="M12 21s-7-6.2-7-11.5a7 7 0 0 1 14 0C19 14.8 12 21 12 21z"/><circle cx="12" cy="9.5" r="2.5"/>',
    warrant: '<path d="M6 3h9l4 4v14H6z"/><path d="M14 3v5h5"/><path d="M9 12.5h6M9 16.5h4"/>',
    video: '<rect x="2.5" y="6.5" width="13" height="11" rx="1.5"/><path d="M15.5 10.5l6-3.5v10l-6-3.5"/>',
    scale: '<path d="M12 3v18M6 21h12M4 7h16"/><path d="M7 7l-3 6.5a3 3 0 0 0 6 0z"/><path d="M17 7l-3 6.5a3 3 0 0 0 6 0z"/>',
    briefcase: '<rect x="3" y="7.5" width="18" height="12.5" rx="1.5"/><path d="M9 7.5V5h6v2.5M3 13h18"/>',
    search: '<circle cx="11" cy="11" r="6.5"/><path d="M20 20l-4.3-4.3"/>',
    refresh: '<path d="M20 12a8 8 0 1 1-2.4-5.7"/><path d="M20 4v5h-5"/>',
    plus: '<path d="M12 5v14M5 12h14"/>',
    note: '<path d="M4 20h4L19.5 8.5l-4-4L4 16z"/><path d="M13.5 6.5l4 4"/>',
    back: '<path d="M10 6l-6 6 6 6M4 12h16"/>',
    report: '<path d="M6 3h9l4 4v14H6z"/><path d="M9 11h6M9 14.5h6M9 18h4"/>',
    clipboard: '<rect x="5" y="4.5" width="14" height="17" rx="1.5"/><path d="M9 3h6v3H9z"/><path d="M8.5 11h1M12 11h3.5M8.5 15h1M12 15h3.5"/>',
    box: '<path d="M3 7.5l9-4.5 9 4.5v9L12 21l-9-4.5z"/><path d="M3 7.5l9 4.5 9-4.5M12 12v9"/>',
    bulb: '<path d="M9 18h6M10 21h4"/><path d="M12 3a6 6 0 0 0-3.6 10.8c.6.5 1.1 1.3 1.1 2.2h5c0-.9.5-1.7 1.1-2.2A6 6 0 0 0 12 3z"/>',
    id: '<rect x="2.5" y="5" width="19" height="14" rx="1.5"/><circle cx="8.5" cy="11" r="2.3"/><path d="M5 16c.6-1.7 2-2.5 3.5-2.5S11.4 14.3 12 16M14.5 10h4M14.5 13.5h4"/>',
    gavel: '<path d="M13.5 4l6.5 6.5-2.5 2.5L11 6.5z"/><path d="M12.2 11.8L4 20"/><path d="M14 21h7"/>',
    cuffs: '<circle cx="7" cy="15.5" r="4"/><circle cx="17" cy="15.5" r="4"/><path d="M7 11.5V8a3 3 0 0 1 3-3h4a3 3 0 0 1 3 3v3.5"/>',
    userx: '<circle cx="10" cy="8" r="4"/><path d="M3 21c0-4 3.2-6.5 7-6.5 1.4 0 2.6.3 3.7.9"/><path d="M16 15l5 5M21 15l-5 5"/>',
    zap: '<path d="M13 2.5L4 14h7l-1 7.5L19 10h-7z"/>',
    target: '<circle cx="12" cy="12" r="7.5"/><circle cx="12" cy="12" r="2.5"/><path d="M12 2v4M12 18v4M2 12h4M18 12h4"/>',
    pill: '<path d="M10.2 3.8a5.2 5.2 0 0 1 7.4 7.4l-6.4 6.4a5.2 5.2 0 0 1-7.4-7.4z"/><path d="M7 10.5l6.5 6.5"/>',
    run: '<path d="M10 3H5v18h5"/><path d="M14 7.5l4.5 4.5-4.5 4.5M18.5 12H9"/>',
    heart: '<path d="M12 20s-8-5-8-11a4 4 0 0 1 8-1.2A4 4 0 0 1 20 9c0 6-8 11-8 11z"/>',
    question: '<circle cx="12" cy="12" r="9"/><path d="M9.6 9.3a2.5 2.5 0 0 1 4.8.9c0 1.7-2.4 2.2-2.4 3.8M12 17.3h.01"/>',
    biohazard: '<circle cx="12" cy="12" r="2.5"/><circle cx="12" cy="6" r="3"/><circle cx="6.8" cy="15" r="3"/><circle cx="17.2" cy="15" r="3"/>',
    clock: '<circle cx="12" cy="12" r="8.5"/><path d="M12 7.5V12l3 2"/>',
    shield: '<path d="M12 3l8 3v6c0 4.5-3.4 8.3-8 9-4.6-.7-8-4.5-8-9V6z"/><path d="M8.5 12l2.5 2.5 4.5-5"/>',
    camera: '<path d="M3 8h4l2-3h6l2 3h4v11H3z"/><circle cx="12" cy="13" r="3.5"/>',
    radio: '<rect x="4" y="8" width="16" height="13" rx="1.5"/><path d="M8 8l9-5"/><circle cx="9" cy="14.5" r="2.5"/><path d="M14 13h3M14 16h3"/>',
    nav: '<path d="M3 11l18-8-8 18-2-8z"/>',
};
const icon = (name, cls = '') => `<svg class="i ${cls}" viewBox="0 0 24 24" aria-hidden="true">${ICON_PATHS[name] || ICON_PATHS.alert}</svg>`;

const MARKER_ICONS = {
    Wanted: 'userx', Violent: 'zap', Weapons: 'target', Drugs: 'pill', Escaper: 'run', Associates: 'users',
    'Mental health': 'heart', 'Self-harm': 'heart', Missing: 'question', Contagious: 'biohazard', Ailment: 'heart',
};

function crestSvg() {
    const pts = [];
    for (let i = 0; i < 16; i++) {
        const r = i % 2 ? 13 : 21, a = (Math.PI / 8) * i - Math.PI / 2;
        pts.push(`${(22 + r * Math.cos(a)).toFixed(1)},${(23 + r * Math.sin(a)).toFixed(1)}`);
    }
    return `<svg viewBox="0 0 44 44" aria-hidden="true">
        <polygon points="${pts.join(' ')}" fill="#E8EDF5" stroke="#9AA9C2" stroke-width=".8"/>
        <circle cx="22" cy="23" r="10.5" fill="#1E3A8A" stroke="#E8EDF5" stroke-width="1.6"/>
        <circle cx="22" cy="23" r="5.2" fill="#C8102E"/>
        <path d="M15.5 6.5l2 3.2 2.2-2.6 2.3 2.8 2.3-2.8 2.2 2.6 2-3.2v4.8h-13z" fill="#F2C230" stroke="#8C6A10" stroke-width=".5"/>
    </svg>`;
}

/* ---------- utilities ---------- */
const esc = (v) => String(v ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const pad = (n) => String(n).padStart(2, '0');
const MONTHS = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
function fmtDate(ts, withTime = true) {
    if (!ts) return '';
    const d = new Date(Number(ts) * 1000);
    const date = `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()}`;
    return withTime ? `${date} ${pad(d.getHours())}:${pad(d.getMinutes())}` : date;
}
function fmtTime(ts) { const d = new Date(Number(ts) * 1000); return `${pad(d.getHours())}:${pad(d.getMinutes())}`; }
function fmtClock(ms) {
    const s = Math.max(0, Math.floor(ms / 1000));
    const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), r = s % 60;
    return h ? `${h}:${pad(m)}:${pad(r)}` : `${pad(m)}:${pad(r)}`;
}
const nowSecs = () => Math.floor(Date.now() / 1000);
const vrm = (plate, cls = '') => `<span class="vrm ${cls}">${esc(String(plate || '').trim().toUpperCase())}</span>`;
const fullName = (p) => `${p.firstname || ''} ${p.lastname || ''}`.trim() || 'Unknown';
const pill = (text, color = '') => `<span class="pill ${color}">${esc(text)}</span>`;
const truncate = (s, n = 90) => { s = String(s || ''); return s.length > n ? s.slice(0, n - 1) + '…' : s; };
function ageFrom(dob) {
    if (!dob) return null;
    let m = String(dob).match(/^(\d{4})-(\d{2})-(\d{2})/), y, mo, d;
    if (m) [y, mo, d] = [m[1], m[2], m[3]];
    else if ((m = String(dob).match(/^(\d{2})\/(\d{2})\/(\d{4})/))) [d, mo, y] = [m[1], m[2], m[3]];
    else return null;
    const b = new Date(+y, +mo - 1, +d), n = new Date();
    let age = n.getFullYear() - b.getFullYear();
    if (n < new Date(n.getFullYear(), b.getMonth(), b.getDate())) age--;
    return age;
}
function ukDate(dob) {
    const m = String(dob || '').match(/^(\d{4})-(\d{2})-(\d{2})/);
    return m ? `${m[3]}/${m[2]}/${m[1]}` : (dob || '');
}
const gradePill = (g) => pill(g === 'Grade 1' ? 'Priority' : g || 'Grade 3', { 'Grade 1': 'red', 'Grade 2': 'orange', 'Grade 3': 'amber' }[g] || '');
const incidentStatusPill = (s) => pill(s, { Open: 'blue', 'In progress': 'amber', Closed: 'green' }[s] || '');
function outcomePill(o) {
    const map = { 'In custody': 'blue', Charged: 'red', 'Remanded in custody': 'red', 'Released on bail': 'amber', 'Released under investigation': 'amber',
        'No further action': 'green', 'Simple caution': 'green', 'Community resolution': 'green', 'Fixed penalty notice': 'green' };
    const short = { 'Released on bail': 'Bailed', 'Released under investigation': 'RUI', 'No further action': 'NFA', 'Remanded in custody': 'Remanded', 'Simple caution': 'Caution', 'Community resolution': 'Comm. resolution', 'Fixed penalty notice': 'FPN' };
    return pill(short[o] || o || 'Processing', map[o] || 'amber');
}

async function api(action, data = {}) {
    try {
        const body = { ...data, _reason: state.purpose || null };
        const r = await fetch(`https://${RES}/request`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ action, data: body }) });
        const json = await r.json();
        if (json && json.needReason) {
            const reason = await askPurpose();
            if (!reason) return { error: 'cancelled' };
            return api(action, data);
        }
        if (json && json.error) toast(json.error, true);
        return json || {};
    } catch (e) {
        toast('Could not reach the server.', true);
        return { error: 'network' };
    }
}
async function nui(name) {
    try { return await (await fetch(`https://${RES}/${name}`, { method: 'POST', body: '{}' })).json(); } catch (e) { return {}; }
}

let toastTimer;
function toast(msg, isError = false) {
    const t = $('#toast');
    t.textContent = msg;
    t.className = 'toast' + (isError ? ' error' : '');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => t.classList.add('hidden'), 4500);
}

function bailType(id) { return (state.cfg.bailTypes || []).find((b) => b.id === id) || { label: id }; }

/* ---------- open / close ---------- */
window.addEventListener('message', async (e) => {
    const m = e.data || {};
    if (m.action === 'open') {
        $('#tablet').classList.remove('hidden');
        if (!state.cfg) await boot();
        else { render(); refreshOfficer(); }
    } else if (m.action === 'close') {
        setPurpose(null);
        stopPlayer();
        $('#tablet').classList.add('hidden');
        closeModal();
    } else if (m.action === 'callsChanged') {
        callsChanged();
    } else if (m.action === 'bailNotice') {
        showBailNotice(m.bail, m.force);
    } else if (m.action === 'anprState') {
        $('#anprHud').classList.toggle('hidden', !m.on);
    } else if (m.action === 'anprRead') {
        const el = $(m.camera === 'Front' ? '#anprFront' : '#anprRear');
        el.textContent = m.plate; el.classList.add('flash'); setTimeout(() => el.classList.remove('flash'), 400);
    } else if (m.action === 'anprLive') {
        const put = (sel, t) => {
            const el = $(sel);
            el.textContent = t ? `${t.speed} ${m.unit}` : '';
            el.classList.toggle('over', !!(t && t.over));
        };
        if (m.front) $('#anprFront').textContent = m.front.plate;
        if (m.rear) $('#anprRear').textContent = m.rear.plate;
        put('#anprFrontSpd', m.front); put('#anprRearSpd', m.rear);
        $('#anprSpd').classList.remove('hidden');
        $('#anprLimit').textContent = m.limit || '-';
        $('#anprOwn').textContent = `${m.patrol} ${m.unit}`;
    } else if (m.action === 'anprLocked') {
        const el = $('#anprFront');
        el.classList.add('locked'); setTimeout(() => el.classList.remove('locked'), 2500);
    } else if (m.action === 'anprHit') {
        showAnprHit(m.hit, m.key);
    } else if (m.action === 'anprLayoutLoad') {
        applyAnprLayout(m.layout);
    } else if (m.action === 'anprLayoutEdit') {
        startAnprLayout();
    } else if (m.action === 'anprDismiss') {
        $('#anprAlert').classList.add('hidden');
    } else if (m.action === 'hideForPhoto') {
        $('#tablet').style.visibility = m.hide ? 'hidden' : '';
        $('#modal').style.visibility = m.hide ? 'hidden' : '';
    } else if (m.action === 'fineNotice') {
        showFineNotice(m.fine, m.force);
    } else if (m.action === 'signStatement') {
        showSignStatement(m.statement);
    } else if (m.action === 'stopSearchNotice') {
        showStopSearchNotice(m.rec, m.force);
    } else if (m.action === 'goVehicle') {
        if (!state.purpose && state.cfg && state.cfg.audit) setPurpose('Vehicle stop');
        const wait = () => state.cfg ? go('vehicle', { plate: m.plate }) : setTimeout(wait, 100);
        wait();
    }
});

function close() { fetch(`https://${RES}/close`, { method: 'POST', body: '{}' }); }
$('#closeBtn').addEventListener('click', close);
document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape' || $('#tablet').classList.contains('hidden')) return;
    if (!$('#modal').classList.contains('hidden')) closeModal();
    else close();
});

function navItems() {
    const c = state.cfg;
    if (c.role === 'defence') return [['defence', 'briefcase', 'My clients']];
    const interviews = c.interviews ? [['interviews', 'video', 'CCTV / Interviews']] : [];
    if (c.role === 'cps') return [['cps', 'scale', 'CPS'], ...(c.sentencing ? [['sentencing', 'gavel', 'Sentencing guide']] : []), ...interviews];
    return [
        ['home', 'home', 'Dashboard'], ...(c.dispatch ? [['calls', 'radio', 'Live calls']] : []), ['people', 'user', 'Persons'], ['vehicles', 'car', 'Vehicles'],
        ['incidents', 'alert', 'Incidents'], ['custody', 'lock', 'Custody'], ['intel', 'bulb', 'Intelligence'],
        ['warrants', 'warrant', 'Warrants'], ...(c.stopSearch ? [['stopsearch', 'search', 'Stop and search']] : []),
        ...(c.fines ? [['fines', 'report', 'Fines and TORs']] : []),
        ...(c.sentencing ? [['sentencing', 'gavel', 'Sentencing guide']] : []),
        ...(c.anpr ? [['anpr', 'camera', 'ANPR']] : []), ...interviews, ...(c.cps ? [['cps', 'scale', 'CPS']] : []),
        ...(c.audit && c.audit.canView ? [['audit', 'shield', 'Audit log']] : []),
    ];
}

async function boot() {
    const cfg = await api('init');
    if (cfg.error) return;
    state.cfg = cfg;
    $('#forceName').textContent = cfg.force.name;
    $('#crest').innerHTML = cfg.crest ? `<img src="${esc(cfg.crest)}" alt="">` : crestSvg();
    $('#officerName').textContent = cfg.officer.name;
    $('#duty').classList.toggle('off', cfg.onduty === false);
    $('#duty').lastChild.textContent = cfg.onduty === false ? 'Off duty' : 'On duty';
    if (cfg.audit && cfg.role === 'police') {
        const chip = document.createElement('button');
        chip.id = 'purposeChip'; chip.className = 'purpose';
        chip.addEventListener('click', () => askPurpose(true));
        $('.officer').prepend(chip);
        setPurpose(null);
    }
    $('#nav').innerHTML = navItems().map(([v, ic, label]) => `<button data-view="${v}">${icon(ic)}<span>${label}</span></button>`).join('');
    go({ cps: 'cps', defence: 'defence' }[cfg.role] || 'home');
}

// Callsign or rank can change between openings (/callsign in vinewood-dispatch, promotions), so refresh the header.
async function refreshOfficer() {
    const cfg = await api('init');
    if (cfg.error || !state.cfg) return;
    state.cfg.officer = cfg.officer;
    state.cfg.grade = cfg.grade;
    $('#officerName').textContent = cfg.officer.name;
}

function tick() {
    const d = new Date();
    $('#clockTime').textContent = `${pad(d.getHours())}:${pad(d.getMinutes())}`;
    $('#clockDate').textContent = `${pad(d.getDate())} ${MONTHS[d.getMonth()]} ${d.getFullYear()}`;
}
tick(); setInterval(tick, 1000);

$('#nav').addEventListener('click', (e) => {
    const b = e.target.closest('button[data-view]');
    if (b) go(b.dataset.view);
});

function go(view, extra = {}) {
    stopPlayer();
    state.view = view;
    Object.assign(state, extra);
    const navFor = { person: 'people', vehicle: 'vehicles', incident: 'incidents', interview: state.cfg && state.cfg.role === 'defence' ? 'defence' : 'interviews', cpsCase: 'cps', defenceCase: 'defence' };
    document.querySelectorAll('#nav button').forEach((b) => b.classList.toggle('active', b.dataset.view === (navFor[view] || view)));
    render();
}

function render() {
    if (!state.cfg) return;
    main.scrollTop = 0;
    ({
        home: viewHome, people: viewPeople, person: viewPerson, vehicles: viewVehicles, vehicle: viewVehicle,
        incidents: viewIncidents, incident: viewIncident, calls: viewCalls, anpr: viewAnpr, stopsearch: viewStopSearch, audit: viewAudit, fines: viewFines, sentencing: viewSentencing, custody: viewCustody, intel: viewIntel, warrants: viewWarrants,
        interviews: viewInterviews, interview: viewInterview, cps: viewCps, cpsCase: viewCpsCase, defence: viewDefence, defenceCase: viewDefenceCase,
    })[state.view]();
}

const pageHead = (title, sub, right = '', back = '') => `<div class="page-head">${back}<div class="grow"><h1>${title}</h1>${sub ? `<p class="sub">${sub}</p>` : ''}</div>${right}</div>`;
const backBtn = (id, label = 'Back to search') => `<button class="btn small" id="${id}">${icon('back')}${label}</button>`;
const panelHead = (title, right = '') => `<div class="head"><h2>${title}</h2>${right}</div>`;
const viewAll = (id) => `<button class="btn tiny" id="${id}">View all</button>`;

/* ---------- dashboard ---------- */
async function viewHome() {
    main.innerHTML = pageHead('Dashboard', 'Overview of current activity and alerts') + '<div id="homeBody" class="muted">Loading</div>';
    const d = await api('home');
    if (d.error || state.view !== 'home') return;
    const s = d.stats || {};
    const stat = (id, ic, n, label, hot) => `<button class="stat ${hot && n > 0 ? 'hot' : ''}" id="${id}"><span class="ico">${icon(ic)}</span><span><span class="n">${n || 0}</span><span class="l">${label}</span></span></button>`;

    const callRows = (d.calls || []).length ? `<table>${d.calls.map((c) => `<tr class="click" data-call="1">
            <td style="width:110px">${gradePill(c.grade)}</td>
            <td><b>${esc(c.code ? `${c.code} ${c.title}` : c.title)}</b><br><span class="muted">${esc(c.location || 'Location unknown')}</span></td>
            <td style="text-align:right">${fmtTime(c.time)}</td></tr>`).join('')}</table>` : '<p class="empty">No live calls.</p>';
    const live = (d.live || []).length ? `<table>${d.live.map((i) => `<tr class="click" data-inc="${i.id}">
            <td style="width:110px">${gradePill(i.grade)}</td>
            <td><b>${esc(i.type)}</b><br><span class="muted">${esc(i.location || 'Location not recorded')}</span></td>
            <td style="text-align:right">${fmtTime(i.created_at)}</td></tr>`).join('')}</table>`
        : '<p class="empty">No open incidents.</p>';
    const searches = (d.searches || []).length ? `<table>${d.searches.map((q) => `<tr class="click" data-q="${esc(q.q)}" data-kind="${esc(q.kind)}">
            <td>${icon(q.kind === 'Vehicle search' ? 'car' : 'user')}</td><td><b>${esc(q.q)}</b></td><td class="muted">${esc(q.kind)}</td><td style="text-align:right">${fmtTime(q.at)}</td></tr>`).join('')}</table>`
        : '<p class="empty">Your searches will appear here.</p>';
    const sys = (d.system || []).map((x) => `<div class="sys ${x.online ? '' : 'off'}"><i></i><div><b>${esc(x.label)}</b><span>${x.online ? 'Online' : 'Offline'}</span>${x.detail ? `<small>${esc(x.detail)}</small>` : ''}</div></div>`).join('');
    const bails = d.bails.length ? `<table><tr><th>Name</th><th>Bail</th><th>Answer at</th><th>Status</th></tr>${d.bails.map((b) => `<tr class="click" data-cid="${esc(b.cid)}">
            <td class="strong">${esc(b.name)}</td><td>${esc(bailType(b.type).label)}</td><td>${esc(b.station || '')}<br><span class="muted">${fmtDate(b.returnAt)}</span></td>
            <td>${b.overdue ? pill('Overdue', 'red') : pill('Due', 'amber')}</td></tr>`).join('')}</table>` : '<p class="empty">Nobody is due to answer bail in the next 48 hours.</p>';
    const cps = (d.cps || []).length ? `<div class="panel section">${panelHead('CPS decisions this week')}<table>${d.cps.map((c) => `<tr class="click" data-case="${c.id}">
            <td class="strong">${esc(c.name)}<br><span class="muted">${esc(c.custodyRef || '')}</span></td><td>${cpsChip(c.status)}</td><td>${esc(c.lawyer || '')}</td><td class="muted">${fmtDate(c.updatedAt)}</td></tr>`).join('')}</table></div>` : '';

    $('#homeBody').outerHTML = `
        <div class="grid4">
            ${s.activeCalls !== undefined && s.activeCalls !== null ? stat('sInc', 'clipboard', s.activeCalls, 'Active calls') : stat('sInc', 'clipboard', s.openIncidents, 'Open incidents')}
            ${stat('sWanted', 'user', s.wanted, 'Wanted persons', true)}
            ${stat('sStolen', 'car', s.stolen, 'Stolen vehicles', true)}
            ${stat('sBail', 'report', s.bailDue, 'Bail due in 48 hours')}
        </div>
        <div class="grid2 section">
            ${d.dispatch ? `<div class="panel">${panelHead('Live calls', viewAll('vaCalls'))}${callRows}</div>` : `<div class="panel">${panelHead('Live incidents', viewAll('vaInc'))}${live}</div>`}
            <div class="panel">${panelHead('Recent searches')}${searches}</div>
        </div>
        <div class="panel section">${panelHead('System status')}<div class="grid-auto">${sys}</div></div>
        <div class="panel section">${panelHead('Bail returns')}${bails}</div>
        ${cps}`;
    $('#sInc').addEventListener('click', () => go(d.dispatch ? 'calls' : 'incidents'));
    $('#vaInc')?.addEventListener('click', () => go('incidents'));
    $('#vaCalls')?.addEventListener('click', () => go('calls'));
    main.querySelectorAll('[data-call]').forEach((r) => r.addEventListener('click', () => go('calls')));
    $('#sWanted').addEventListener('click', () => go('people', { peopleForm: null }));
    $('#sStolen').addEventListener('click', () => go('vehicles', { lastVehQ: '', vehMarker: 'Stolen' }));
    $('#sBail').addEventListener('click', () => go('custody'));
    main.querySelectorAll('[data-inc]').forEach((r) => r.addEventListener('click', () => go('incident', { incidentId: r.dataset.inc })));
    main.querySelectorAll('[data-cid]').forEach((r) => r.addEventListener('click', () => openPerson(r.dataset.cid)));
    main.querySelectorAll('[data-case]').forEach((r) => r.addEventListener('click', () => go('cpsCase', { caseId: r.dataset.case, caseReturn: 'home' })));
    main.querySelectorAll('[data-q]').forEach((r) => r.addEventListener('click', () => {
        if (r.dataset.kind === 'Vehicle search') go('vehicles', { lastVehQ: r.dataset.q });
        else {
            const parts = r.dataset.q.split(' ');
            go('people', { peopleForm: parts.length > 1 ? { first: parts[0], last: parts.slice(1).join(' ') } : { ref: r.dataset.q } });
        }
    }));
}

/* ---------- persons ---------- */
function viewPeople() {
    const f = state.peopleForm || {};
    main.innerHTML = pageHead('Person search', 'Search PNC for a person by name, date of birth or PNC ID') + `
        <form class="panel" id="ps">
            <div class="form-row" style="grid-template-columns:repeat(4,minmax(0,1fr))">
                <div><label for="pFirst">First name</label><input id="pFirst" autocomplete="off" value="${esc(f.first || '')}"></div>
                <div><label for="pLast">Last name</label><input id="pLast" autocomplete="off" value="${esc(f.last || '')}"></div>
                <div><label for="pDob">Date of birth</label><input id="pDob" type="date" value="${esc(f.dob || '')}"></div>
                <div><label for="pRef">PNC ID</label><input id="pRef" autocomplete="off" placeholder="Enter PNC ID" value="${esc(f.ref || '')}"></div>
            </div>
            <div class="form-actions"><button class="btn primary wide">${icon('search')}Search</button><button class="btn wide" type="button" id="pClear">${icon('refresh')}Clear</button></div>
        </form>
        <div id="pr"></div>`;
    $('#ps').addEventListener('submit', (e) => {
        e.preventDefault();
        state.peopleForm = { first: $('#pFirst').value, last: $('#pLast').value, dob: $('#pDob').value, ref: $('#pRef').value };
        searchPeople();
    });
    $('#pClear').addEventListener('click', () => { state.peopleForm = null; viewPeople(); });
    $('#pFirst').focus();
    if (state.peopleForm) searchPeople();
    else loadWanted();
}

// Shown under the search box until you search: everyone currently wanted.
async function loadWanted() {
    const el = $('#pr');
    if (!el) return;
    const d = await api('wantedPeople');
    if (d.error || state.view !== 'people' || state.peopleForm) return;
    el.innerHTML = `<div class="panel section">${panelHead(`Wanted persons (${d.results.length})`)}
        ${d.results.length ? `<div class="table-wrap"><table><tr><th>Name</th><th>DOB</th><th>PNC ID</th><th>Wanted for</th><th>Since</th><th></th></tr>
            ${d.results.map((p) => `<tr class="click" data-cid="${esc(p.cid)}"><td class="strong">${esc(fullName(p))} ${p.online ? '<span class="chip online">In city</span>' : ''}</td>
            <td>${esc(ukDate(p.dob))}</td><td>${esc(p.cid)}</td><td>${p.warrantType ? `${esc(warrantLabel(p.warrantType))}: ` : ''}${esc(truncate(p.why, 70))}</td>
            <td>${fmtDate(p.since, false)}</td><td class="go">›</td></tr>`).join('')}</table></div>`
            : '<p class="empty">Nobody is wanted.</p>'}</div>`;
    el.querySelectorAll('[data-cid]').forEach((r) => r.addEventListener('click', () => openPerson(r.dataset.cid)));
}

async function searchPeople() {
    const d = await api('searchPeople', state.peopleForm);
    const el = $('#pr');
    if (d.error || !el) return;
    const statusPill = (s) => ({ wanted: pill('Wanted', 'red'), caution: pill('Caution', 'amber'), clear: pill('Clear', 'green') }[s]);
    el.innerHTML = `<div class="panel section">${panelHead(`Search results (${d.results.length})`)}${d.results.length ? `<div class="table-wrap"><table>
        <tr><th>Name</th><th>DOB</th><th>PNC ID</th><th>Address</th><th>Status</th><th></th></tr>
        ${d.results.map((p) => `<tr class="click" data-cid="${esc(p.cid)}">
            <td class="strong">${esc(fullName(p))}</td><td>${esc(ukDate(p.dob))}</td><td>${esc(p.cid)}</td>
            <td>${esc(p.address || '')}</td><td>${statusPill(p.status)}</td><td class="go">›</td></tr>`).join('')}
        </table></div>` : '<p class="empty">No matches. Check the spelling, or search by surname only.</p>'}</div>`;
    el.querySelectorAll('[data-cid]').forEach((b) => b.addEventListener('click', () => openPerson(b.dataset.cid)));
}

function openPerson(cid, tab = 'activity') { go('person', { cid, tab, profile: null }); }

async function viewPerson() {
    main.innerHTML = `<p class="muted">Loading record</p>`;
    const d = await api('getPerson', { cid: state.cid });
    if (d.error) { main.innerHTML = `<p class="empty">${esc(d.error)}</p>`; return; }
    state.profile = d;
    drawPerson();
    if (state.pendingCustody) { const inc = state.pendingCustody; state.pendingCustody = null; custodyModal(inc); }
}

function drawPerson() {
    const d = state.profile, p = d.person, cfg = state.cfg;
    const activeBail = d.bail.find((b) => b.status === 'active');
    const activeWarrants = (d.warrants || []).filter((w) => w.status === 'active');
    const wantedTypes = (cfg.warrantTypes || []).filter((w) => w.wanted).map((w) => w.id);
    const wanted = activeWarrants.some((w) => wantedTypes.includes(w.type)) || d.markers.some((m) => m.marker === 'Wanted');
    const dvla = d.licences.find((l) => l.dvla);
    const home = d.housing[0];
    const age = ageFrom(p.dob);

    const tiles = [];
    if (wanted && !d.markers.some((m) => m.marker === 'Wanted')) tiles.push({ marker: 'Wanted', note: 'Active warrant' });
    d.markers.forEach((m) => tiles.push(m));
    const highRisk = tiles.some((m) => (cfg.highRisk || {})[m.marker]);

    const licenceSum = () => {
        if (!dvla) return pill('No record');
        if (dvla.banned) return pill('Disqualified', 'red');
        if ((dvla.items || []).some((i) => i.status === 'valid')) return pill('Full', 'green');
        if (dvla.provisional) return pill('Provisional', 'amber');
        return pill('None', 'red');
    };

    const tabs = [
        ['activity', 'Activity', d.activity.length], ['overview', 'Licences and address'], ['vehicles', 'Vehicles', d.vehicles.length],
        ['custody', 'Custody', d.records.length], ['bail', 'Bail', d.bail.length], ['incidents', 'Incidents', d.incidents.length],
        ['intel', 'Intelligence', d.intel.length], ['notes', 'Notes', d.notes.length], ['warrants', 'Warrants', d.warrants.length],
    ];
    if (cfg.stopSearch) tabs.push(['stopsearch', 'Stop and search', (d.stopSearch || []).length]);
    if (cfg.fines) tabs.push(['fines', 'Fines']);
    tabs.push(['evidence', 'Evidence', (d.evidence || []).length]);
    if (d.court) tabs.push(['court', 'Court and sentences', (d.court.cases || []).length]);
    if (d.interviews) tabs.push(['interviews', 'Interviews', d.interviews.length]);
    if (cfg.audit && cfg.audit.canView) tabs.push(['access', 'Access log']);

    main.innerHTML = `
        ${pageHead('Person record', `PNC ID: ${esc(p.cid)}`, `<div class="actions">
            <button class="btn primary small" id="aReport">${icon('report')}Create report</button>
            <button class="btn primary small" id="aNote">${icon('note')}Add note</button>
            <button class="btn small" id="aCustody">${icon('lock')}Custody record</button>
            <button class="btn small" id="aBail" ${activeBail ? 'disabled title="Already on bail"' : ''}>Release on bail</button>
            <button class="btn small" id="aMarker">${icon('plus')}Marker</button>
        </div>`, backBtn('pBack'))}
        <div class="record-top">
            <div>
                <div class="mugshot" ${p.photo ? `style="background-image:url('${esc(p.photo)}')"` : ''}>${p.photo ? '' : icon('user')}</div>
                ${(p.photos || []).length ? `<p class="muted" style="font-size:12px;margin:6px 0 0">Custody photo ${fmtDate(p.photos[0].created_at, false)}${p.photos.length > 1 ? ` · <a href="#" id="morePhotos" style="color:#9CC3FF">${p.photos.length} photos</a>` : ''}</p>` : ''}
                ${cfg.mugshot && p.online ? `<button class="btn small" id="aPhoto" style="width:100%;margin-top:8px">${icon('camera')}Take custody photo</button>` : ''}
            </div>
            <div class="who">
                <h1>${esc(fullName(p))} ${p.online ? '<span class="chip online">In city</span>' : ''}</h1>
                <dl class="kv">
                    <dt>DOB:</dt><dd>${esc(ukDate(p.dob) || 'Not recorded')}${age !== null ? ` (${age})` : ''}</dd>
                    <dt>Gender:</dt><dd>${esc(p.sex || 'Not recorded')}</dd>
                    <dt>PNC ID:</dt><dd>${esc(p.cid)}</dd>
                    <dt>Address:</dt><dd>${home ? esc([home.label, home.address].filter(Boolean).join(', ')) : 'No fixed abode on record'}</dd>
                    <dt>Nationality:</dt><dd>${esc(p.nationality || 'Not recorded')}</dd>
                    <dt>Phone:</dt><dd>${esc(p.phone || 'Not recorded')}</dd>
                    ${cfg.fingerprints ? `<dt>Fingerprints:</dt><dd>${d.prints ? `On database <span class="muted">(${fmtDate(d.prints.created_at, false)})</span>` : `Not on database ${p.online ? '<button class="btn tiny" id="aPrints">Take prints</button>' : ''}`}</dd>` : ''}
                    ${cfg.forensics ? `<dt>DNA:</dt><dd>${d.dna ? `On database <span class="muted">(${fmtDate(d.dna.created_at, false)})</span>` : `Not on database ${p.online ? '<button class="btn tiny" id="aDna">Take sample</button>' : ''}`}</dd>` : ''}
                </dl>
            </div>
            <div class="markers ${tiles.length ? '' : 'none'}">
                <div class="head">${icon('alert')}Warning markers${highRisk ? pill('High risk', 'red') : ''}</div>
                ${tiles.length ? `<div class="tiles">${tiles.map((m) => `<div class="tile" title="${esc(m.note || '')}">${icon(MARKER_ICONS[m.marker] || 'alert')}${esc(m.marker)}
                    ${m.id && cfg.officer.supervisor ? `<button class="x" data-unmark="${m.id}" aria-label="Remove ${esc(m.marker)} marker">&times;</button>` : ''}</div>`).join('')}</div>`
                    : '<p class="muted">No warning markers on this record.</p>'}
            </div>
        </div>
        <div class="summary">
            <button class="sum" data-jump="overview"><div class="t">Driving licence</div><div class="v">${icon('id')}<span>${licenceSum()}${dvla && dvla.points ? `<br><span class="link">${dvla.points} penalty points</span>` : ''}</span></div></button>
            <button class="sum" data-jump="vehicles"><div class="t">Vehicles</div><div class="v">${icon('car')}<span><span class="n">${d.vehicles.length}</span><br><span class="link">View vehicles</span></span></div></button>
            <button class="sum" data-jump="custody"><div class="t">Previous convictions</div><div class="v">${icon('gavel')}<span><span class="n">${d.convictions || 0}</span><br><span class="link">View convictions</span></span></div></button>
            <button class="sum" data-jump="custody"><div class="t">Previous arrests</div><div class="v">${icon('cuffs')}<span><span class="n">${d.records.length}</span><br><span class="link">View arrests</span></span></div></button>
        </div>
        ${d.admitted ? `<div class="banner bail"><strong>In hospital</strong>Admitted to ${esc(d.admitted.hospital || 'hospital')} since ${fmtDate(d.admitted.admitted_at)}.</div>` : ''}
        ${d.court && d.court.custody ? `<div class="banner warn"><strong>In prison: ${esc(d.court.custody.label)}</strong>${esc(d.court.custody.prison || '')}${d.court.custody.left !== undefined && d.court.custody.left !== null ? `, ${d.court.custody.left} minutes until release.` : ', held until their next court hearing.'}</div>` : ''}
        ${d.court && !d.court.custody ? (d.court.orders || []).filter((o) => o.kind === 'licence' || o.kind === 'suspended' || o.kind === 'community').map((o) => `<div class="banner bail"><strong>${esc(o.kindLabel || o.kind)}</strong>${o.kind === 'licence' ? 'Released on licence and supervised by probation.' : 'Subject to a court order.'}${(o.requirements || []).filter((q) => q.type !== 'supervision').length ? ` Requirements: ${(o.requirements || []).filter((q) => q.type !== 'supervision').map((q) => esc(q.label)).join(', ')}.` : ''}</div>`).join('') : ''}
        ${activeBail ? bailBanner(activeBail) : ''}
        ${d.prisonStatus ? `<div class="banner warn"><strong>In prison${d.prisonStatus.prison ? `: ${esc(d.prisonStatus.prison)}` : ''}</strong>
            ${d.prisonStatus.prison_no ? `Prison number ${esc(d.prisonStatus.prison_no)}. ` : ''}${d.prisonStatus.cell ? `Cell ${esc(d.prisonStatus.cell)}. ` : ''}${d.prisonStatus.release_at ? `Expected release ${fmtDate(d.prisonStatus.release_at)}.` : ''}</div>` : ''}
        ${activeWarrants.map((w) => `<div class="banner warn"><strong>${esc(warrantLabel(w.type))}</strong>${esc(w.reason || '')} <span class="muted">(${esc(w.issued_by || '')}, ${fmtDate(w.created_at, false)})</span></div>`).join('')}
        <div class="tabs" role="tablist">${tabs.map(([id, label, n]) => `<button role="tab" data-tab="${id}" class="${state.tab === id ? 'active' : ''}">${label}${n !== undefined ? `<span class="count">${n}</span>` : ''}</button>`).join('')}</div>
        <div id="tabBody"></div>`;

    $('#pBack').addEventListener('click', () => go('people'));
    main.querySelectorAll('[data-tab]').forEach((b) => b.addEventListener('click', () => { state.tab = b.dataset.tab; drawPerson(); }));
    // Tabs scroll sideways with the mouse wheel when they don't all fit; keep the active one in view.
    const tabBar = main.querySelector('.tabs');
    tabBar.addEventListener('wheel', (e) => { if (tabBar.scrollWidth > tabBar.clientWidth) { e.preventDefault(); tabBar.scrollLeft += e.deltaY + e.deltaX; } }, { passive: false });
    tabBar.querySelector('.active')?.scrollIntoView({ block: 'nearest', inline: 'nearest' });
    main.querySelectorAll('[data-jump]').forEach((b) => b.addEventListener('click', () => { state.tab = b.dataset.jump; drawPerson(); }));
    main.querySelectorAll('[data-unmark]').forEach((b) => b.addEventListener('click', async (e) => {
        e.stopPropagation();
        const r = await api('removeMarker', { id: b.dataset.unmark });
        if (r.ok) { toast('Marker removed.'); viewPerson(); }
    }));
    $('#aReport').addEventListener('click', () => incidentModal({ linkKind: 'person', linkId: p.cid, linkName: fullName(p) }));
    $('#aNote').addEventListener('click', () => noteModal('person', p.cid, fullName(p)));
    $('#aCustody').addEventListener('click', () => custodyModal());
    $('#aBail').addEventListener('click', () => bailModal());
    $('#aMarker').addEventListener('click', () => markerModal('person', p.cid));
    $('#aPrints')?.addEventListener('click', () => confirmModal('Take their fingerprints and add them to the database? Earlier lifts are checked against them straight away.', async () => {
        const r = await api('takePrints', { cid: p.cid });
        if (r.ok) { toast(r.already ? 'Their prints are already on the database.' : 'Fingerprints taken and added to the database.'); viewPerson(); }
    }));
    $('#aDna')?.addEventListener('click', () => confirmModal('Take a DNA sample and add it to the database? Earlier scene samples are checked against it straight away.', async () => {
        const r = await api('takeDNA', { cid: p.cid });
        if (r.ok) { toast(r.already ? 'Their DNA is already on the database.' : 'DNA sample taken and added to the database.'); viewPerson(); }
    }));
    $('#aPhoto')?.addEventListener('click', () => takeMugshot(p.cid, (d.records.find((r) => r.clock) || {}).id));
    $('#morePhotos')?.addEventListener('click', (e) => { e.preventDefault(); photosModal(p); });

    const body = $('#tabBody');
    ({ activity: tabActivity, overview: tabOverview, vehicles: tabVehicles, custody: tabCustody, bail: tabBail, incidents: tabIncidents,
        intel: tabIntel, notes: tabNotes, warrants: tabWarrants, interviews: tabInterviews, stopsearch: tabStopSearch, access: tabAccess, fines: tabFines, court: tabCourt, evidence: tabEvidence })[state.tab](body, d);
}

function activityTable(list) {
    if (!list.length) return '<p class="empty">Nothing recorded yet.</p>';
    return `<div class="table-wrap"><table><tr><th>Date</th><th>Type</th><th>Details</th><th>Officer</th></tr>
        ${list.map((a) => `<tr><td>${fmtDate(a.at, false)}</td><td>${esc(a.type)}</td><td>${esc(truncate(a.detail, 110))}</td><td>${esc(a.officer || 'System')}</td></tr>`).join('')}</table></div>`;
}
function tabActivity(body, d) { body.innerHTML = `<div class="panel flush">${activityTable(d.activity)}</div>`; }

function tabIncidents(body, d) {
    body.innerHTML = d.incidents.length ? `<div class="panel flush"><table><tr><th>Incident no.</th><th>Type</th><th>Role</th><th>Location</th><th>Date</th><th>Status</th><th></th></tr>
        ${d.incidents.map((i) => `<tr class="click" data-inc="${i.id}"><td class="strong">${esc(i.ref)}</td><td>${esc(i.type)}</td><td>${esc(i.role || '')}</td><td>${esc(i.location || '')}</td>
        <td>${fmtDate(i.created_at)}</td><td>${incidentStatusPill(i.status)}</td><td class="go">›</td></tr>`).join('')}</table></div>`
        : '<p class="empty">Not linked to any incidents.</p>';
    body.querySelectorAll('[data-inc]').forEach((r) => r.addEventListener('click', () => go('incident', { incidentId: r.dataset.inc })));
}

function intelTable(list, showSubject = false) {
    if (!list.length) return '<p class="empty">No intelligence recorded.</p>';
    return `<div class="table-wrap"><table><tr><th>Date</th>${showSubject ? '<th>Subject</th>' : ''}<th>Grading</th><th>Intelligence</th><th>Officer</th></tr>
        ${list.map((x) => `<tr ${showSubject && x.subject_id ? `class="click" data-subject="${esc(x.subject_type)}" data-sid="${esc(x.subject_id)}"` : ''}>
            <td>${fmtDate(x.created_at, false)}</td>${showSubject ? `<td class="strong">${esc(x.subject_label || x.subject_id || 'General')}</td>` : ''}
            <td><span class="grading">${esc(x.grading || '')}</span></td><td style="white-space:pre-wrap">${esc(x.text)}</td><td>${esc(x.officer_name || '')}</td></tr>`).join('')}</table></div>`;
}
function tabIntel(body, d) {
    body.innerHTML = `<div class="actions" style="margin-bottom:10px"><button class="btn small primary" id="addIntel">${icon('plus')}Submit intelligence</button></div><div class="panel flush">${intelTable(d.intel)}</div>`;
    $('#addIntel').addEventListener('click', () => intelModal({ kind: 'person', id: d.person.cid, label: fullName(d.person) }));
}

function notesList(list) {
    if (!list.length) return '<p class="empty">No notes yet.</p>';
    return list.map((n) => `<div class="record"><div class="meta">${fmtDate(n.created_at)}, ${esc(n.officer_name || '')}</div><p style="white-space:pre-wrap">${esc(n.text)}</p></div>`).join('');
}
function tabNotes(body, d) {
    body.innerHTML = `<div class="actions" style="margin-bottom:12px"><button class="btn small primary" id="addNote2">${icon('note')}Add note</button></div>${notesList(d.notes)}`;
    $('#addNote2').addEventListener('click', () => noteModal('person', d.person.cid, fullName(d.person)));
}

function tabWarrants(body, d) {
    body.innerHTML = `<div class="actions" style="margin-bottom:10px"><button class="btn small primary" id="addWarrant">${icon('plus')}Record warrant</button></div>
        <div class="panel flush">${warrantTable(d.warrants)}</div>`;
    $('#addWarrant').addEventListener('click', () => warrantModal({ cid: d.person.cid, name: fullName(d.person) }));
    bindWarrantActions(body, viewPerson);
}

function licenceSummary(l) {
    if (l.banned) return '<span class="status disqualified">Disqualified</span>';
    const valid = (l.items || []).some((i) => i.status === 'valid');
    if (valid) return `<span class="status valid">Full licence</span>${l.points ? ` <span class="muted">${l.points} pts</span>` : ''}`;
    if (l.provisional) return '<span class="status provisional">Provisional only</span>';
    return '<span class="status none">No entitlement</span>';
}

function conditionsList(conds) {
    if (!conds || !conds.length) return '<p class="muted">No conditions.</p>';
    return `<ul>${conds.map((c) => `<li>${esc(c.label)}${c.value ? `: ${esc(c.value)}` : ''}</li>`).join('')}</ul>`;
}

function bailBanner(b) {
    const t = bailType(b.type);
    const when = b.returnAt ? `Answer at ${esc(b.station)} on ${fmtDate(b.returnAt)}.` : 'No return date set.';
    return `<div class="banner ${b.overdue ? 'warn' : 'bail'}">
        <strong>${b.overdue ? 'Failed to answer bail' : esc(t.label)}${b.custodyRef ? ` <span class="muted">${esc(b.custodyRef)}</span>` : ''}</strong>
        ${when} Bailed by ${esc(b.officer || 'unknown')} on ${fmtDate(b.createdAt, false)}.
        ${conditionsList(b.conditions)}
    </div>`;
}

/* ----- overview: licences + housing ----- */
function tabOverview(body, d) {
    const blocks = d.licences.map((l) => l.dvla ? dvlaPanel(l) : `
        <div class="panel"><div class="head"><h3>${esc(l.title)}</h3></div>
        <table><tr><th>Licence</th><th>Status</th></tr>
        ${l.items.map((i) => `<tr><td>${esc(i.label)}</td><td><span class="status ${esc(i.status)}">${statusLabel(i.status)}</span>${i.detail ? `<br><span class="muted">${esc(i.detail)}</span>` : ''}</td></tr>`).join('')}
        </table></div>`).join('') || `<div class="panel"><p class="muted">No licences found in any licensing system.</p></div>`;

    const homes = d.housing.length ? `<table><tr><th>Property</th><th>Address</th><th>Held as</th></tr>
        ${d.housing.map((h) => `<tr><td>${esc(h.label)}<br><span class="muted">${esc(h.source)}</span></td><td>${esc(h.address || 'Not resolved')}</td><td>${esc(h.role || '')}</td></tr>`).join('')}</table>`
        : `<p class="muted">No property held in any housing system. Record them as no fixed abode if that is confirmed.</p>`;

    body.innerHTML = `<div class="grid2"><div>${blocks}</div><div class="panel"><div class="head"><h3>Addresses</h3></div>${homes}</div></div>`;

    const dv = body.querySelector('[data-dvla]');
    if (dv) {
        dv.querySelector('#aEndorse')?.addEventListener('click', () => endorseModal());
        dv.querySelector('#aDisq')?.addEventListener('click', () => disqualifyModal());
        dv.querySelector('#aLift')?.addEventListener('click', async () => {
            const r = await api('liftDisqualification', { cid: state.cid });
            if (r.ok) { toast(r.queued ? 'Queued: the disqualification lifts when they next log in.' : 'Disqualification lifted.'); viewPerson(); }
        });
        dv.querySelector('#aClearPts')?.addEventListener('click', () => confirmModal('Clear all penalty points from this licence? Use this for a successful appeal or an error.', async () => {
            const r = await api('clearPoints', { cid: state.cid });
            if (r.ok) { toast(r.queued ? 'Queued: points clear when they next log in.' : 'Points cleared.'); viewPerson(); }
        }));
        dv.querySelector('#aClearPending')?.addEventListener('click', () => confirmModal('Cancel everything waiting to apply to this licence?', async () => {
            const r = await api('clearPendingLicence', { cid: state.cid });
            if (r.ok) { toast('Queued actions cancelled.'); viewPerson(); }
        }));
        dv.querySelectorAll('[data-revoke]').forEach((b) => b.addEventListener('click', () => confirmModal('Revoke this licence category? They will need to pass the test again.', async () => {
            const r = await api('revokeCategory', { cid: state.cid, category: b.dataset.revoke });
            if (r.ok) { toast('Category revoked.'); viewPerson(); }
        })));
    }
}

function statusLabel(s) {
    return { valid: 'Valid', revoked: 'Revoked', suspended: 'Suspended', provisional: 'Provisional', disqualified: 'Disqualified', none: 'Not held' }[s] || s;
}

function dvlaPanel(l) {
    const pts = Number(l.points) || 0;
    const pct = Math.min(100, Math.round((pts / 12) * 100));
    const ban = l.ban || {};
    const banUntil = ban.until_ || ban['until'];
    const canAct = state.cfg.dvla && l.canEndorse;
    const sup = state.cfg.officer.supervisor;
    const why = l.queue ? '' : 'disabled title="Driver must be in the city"';
    const pendingText = (p) => ({
        points: `${esc(p.code || '')} ${p.points || ''} pts${p.reason ? ` - ${esc(p.reason)}` : ''}`,
        ban: `Disqualification${p.days ? ` for ${p.days} days` : ' until further order'}${p.reason ? ` - ${esc(p.reason)}` : ''}`,
        unban: 'Lift disqualification', clearpoints: 'Clear all points',
    }[p.action] || esc(p.action));
    return `<div class="panel" data-dvla>
        <div class="head"><h3>${esc(l.title)}</h3>${l.number ? `<span class="muted">${esc(l.number)}</span>` : ''}</div>
        ${l.banned ? `<div class="banner warn" style="margin:0 0 12px"><strong>${ban.pending ? 'Disqualification waiting to apply' : 'Disqualified from driving'}</strong>
            ${ban.pending ? 'Applies when they next log in.' : ban.permanent || !banUntil ? 'Until further order.' : `Until ${fmtDate(banUntil, false)}.`} ${esc(ban.reason || '')}${ban.by ? ` <span class="muted">(${esc(ban.by)})</span>` : ''}</div>` : ''}
        <table><tr><th>Category</th><th>Status</th><th></th></tr>
        ${l.items.map((i) => `<tr><td>${esc(i.label)}</td><td><span class="status ${esc(i.status)}">${statusLabel(i.status)}</span></td>
            <td style="text-align:right">${i.key && sup && l.canRevoke ? `<button class="btn tiny" data-revoke="${esc(i.key)}">Revoke</button>` : ''}</td></tr>`).join('')}</table>
        ${l.categories ? `<p class="muted" style="margin-top:8px">Categories ${esc(l.categories)}${l.expiry ? `, expires ${esc(l.expiry)}` : ''}</p>` : ''}
        <h3 style="margin-top:14px">Penalty points</h3>
        <div class="points"><span class="n">${pts}</span><span class="muted">of 12 before totting up</span></div>
        <div class="meter"><i class="${pts >= 12 ? 'full' : ''}" style="width:${pct}%"></i></div>
        ${(l.endorsements || []).length ? `<table><tr><th>Code</th><th>Pts</th><th>Offence</th><th>Expires</th></tr>
            ${l.endorsements.map((e) => `<tr><td>${esc(e.code)}</td><td>${esc(e.points)}</td><td>${esc(e.reason || '')}<br><span class="muted">${esc(e.officer || '')}, ${fmtDate(e.issued, false)}</span></td><td>${fmtDate(e.expires, false)}</td></tr>`).join('')}</table>`
            : '<p class="muted">No current endorsements.</p>'}
        ${(l.pending || []).length ? `<div class="banner bail" style="margin:12px 0 0"><strong>Waiting for the driver to log in</strong>
            <ul>${l.pending.map((p) => `<li>${pendingText(p)}${p.by ? ` <span class="muted">(${esc(p.by)})</span>` : ''}</li>`).join('')}</ul>
            ${sup ? '<button class="btn tiny" id="aClearPending" style="margin-top:6px">Cancel queued actions</button>' : ''}</div>` : ''}
        <div class="actions" style="margin-top:12px">
            <button class="btn small" id="aEndorse" ${canAct ? '' : why}>Endorse licence</button>
            ${l.banned
                ? `<button class="btn small" id="aLift" ${canAct && sup ? '' : 'disabled'}>Lift disqualification</button>`
                : `<button class="btn small danger" id="aDisq" ${canAct ? '' : why}>Disqualify</button>`}
            ${pts > 0 && sup ? `<button class="btn small" id="aClearPts" ${canAct ? '' : why}>Clear points</button>` : ''}
        </div>
        ${!l.online ? `<p class="muted" style="margin-top:8px">${l.queue ? 'Driver not in the city. Points and bans you issue are queued and apply when they next log in.' : 'Read from the last saved record. Endorsing needs the driver in the city.'}</p>` : ''}
    </div>`;
}

/* ----- custody ----- */
function tabCustody(body, d) {
    if (!d.records.length) { body.innerHTML = '<p class="empty">No custody records. Use New custody record to book them in.</p>'; return; }
    body.innerHTML = d.records.map((r) => `
        <div class="record">
            <div class="meta">${esc(r.ref || '')} &nbsp; ${fmtDate(r.created_at)} &nbsp; ${esc(r.officer_name || '')}</div>
            <h3>${outcomePill(r.outcome)} ${r.cps ? cpsChip(r.cps.status) : ''} ${r.incident_id ? `<button class="btn tiny" data-increc="${r.incident_id}">Open incident</button>` : ''}</h3>
            <ul>${(r.offences || []).map((o) => `<li>${esc(o)}</li>`).join('')}</ul>
            ${r.clock ? clockPanel(r) : ''}
            ${(() => {
                const linked = (d.interviews || []).filter((s) => r.ref && s.caseRef === r.ref);
                return linked.length ? `<div class="linked-interviews"><b>${icon('video')}Interviews for this case</b>${linked.map((s) => `<button class="btn tiny" data-iid="${s.id}">${fmtDate(Math.floor((s.startedAt || 0) / (s.startedAt > 1e11 ? 1000 : 1)))} · ${fmtClock(s.duration)} · ${esc(s.officer || '')}</button>`).join('')}</div>` : '';
            })()}
            ${r.narrative ? `<p>${esc(r.narrative)}</p>` : ''}
            ${r.defence ? `<p>Solicitor: <strong>${esc(r.defence.solicitor)}</strong> <span class="muted">assigned by ${esc(r.defence.assignedBy || '')}, ${fmtDate(r.defence.at)}</span></p>` : ''}
            <div class="actions">
                ${state.cfg.defence ? (r.defence
                    ? `<button class="btn small" data-disc="${r.id}">Edit disclosure</button><button class="btn small" data-unsol="${r.defence.id}">Remove solicitor</button>`
                    : `<button class="btn small" data-sol="${r.id}">Assign solicitor</button>`) : ''}
                ${r.cps ? `<button class="btn small" data-case="${r.cps.id}">Open CPS file</button>` : ''}
                ${state.cfg.cps && r.outcome !== 'No further action' && (!r.cps || ['nfa', 'withdrawn'].includes(r.cps.status)) && r.outcome !== 'Charged' ? `<button class="btn small primary" data-cpsrec="${r.id}">Submit to CPS</button>` : ''}
                ${r.outcome !== 'No further action' && r.outcome !== 'Charged' && (!r.cps || !['pending', 'more_evidence'].includes(r.cps.status) || state.cfg.cps.policeCanWithdraw) ? `<button class="btn small" data-nfarec="${r.id}">No further action</button>` : ''}
                ${r.outcome === state.cfg.outcomes[0] ? `<button class="btn small primary" data-outrec="${r.id}">Record outcome</button>` : ''}
                ${!d.bail.some((b) => b.status === 'active') ? `<button class="btn small" data-bailrec="${r.id}">Release on bail</button>` : ''}
                ${state.cfg.interviews ? `<button class="btn small" data-iref="${esc(r.ref || '')}">Find interviews</button>` : ''}
                ${state.cfg.sentencing ? `<button class="btn small" data-sent="${r.id}">${icon('gavel')}Sentencing guidance</button>` : ''}
                ${state.cfg.officer.supervisor ? `<button class="btn small danger" data-delrec="${r.id}">Delete</button>` : ''}
            </div>
        </div>`).join('');
    body.querySelectorAll('[data-review]').forEach((b) => b.addEventListener('click', () => reviewModal(d.records.find((r) => String(r.id) === b.dataset.review))));
    body.querySelectorAll('[data-sent]').forEach((b) => b.addEventListener('click', () => {
        const r = d.records.find((x) => String(x.id) === b.dataset.sent);
        sentencingModal({ offences: r.offences || [], cid: d.person.cid, name: fullName(d.person), recordId: r.id, ref: r.ref });
    }));
    body.querySelectorAll('.linked-interviews [data-iid]').forEach((b) => b.addEventListener('click', () => go('interview', { interviewId: b.dataset.iid, returnTo: 'person' })));
    body.querySelectorAll('[data-extend]').forEach((b) => b.addEventListener('click', () => extendDetentionModal(d.records.find((r) => String(r.id) === b.dataset.extend))));
    body.querySelectorAll('[data-photo]').forEach((b) => b.addEventListener('click', () => takeMugshot(d.person.cid, b.dataset.photo)));
    body.querySelectorAll('[data-increc]').forEach((b) => b.addEventListener('click', () => go('incident', { incidentId: b.dataset.increc })));
    body.querySelectorAll('[data-outrec]').forEach((b) => b.addEventListener('click', () => outcomeModal(d.records.find((r) => String(r.id) === b.dataset.outrec))));
    body.querySelectorAll('[data-bailrec]').forEach((b) => b.addEventListener('click', () => {
        const rec = d.records.find((r) => String(r.id) === b.dataset.bailrec);
        bailModal(rec);
    }));
    body.querySelectorAll('[data-iref]').forEach((b) => b.addEventListener('click', () => go('interviews', { lastInterviewQ: b.dataset.iref })));
    body.querySelectorAll('[data-case]').forEach((b) => b.addEventListener('click', () => go('cpsCase', { caseId: b.dataset.case, caseReturn: 'person' })));
    const recById = (id) => d.records.find((r) => String(r.id) === id);
    body.querySelectorAll('[data-sol]').forEach((b) => b.addEventListener('click', () => solicitorModal(recById(b.dataset.sol))));
    body.querySelectorAll('[data-disc]').forEach((b) => b.addEventListener('click', () => disclosureModal(recById(b.dataset.disc))));
    body.querySelectorAll('[data-unsol]').forEach((b) => b.addEventListener('click', () => confirmModal('Remove the solicitor? They will lose access to this case straight away.', async () => {
        const r = await api('removeSolicitor', { id: b.dataset.unsol });
        if (r.ok) { toast('Solicitor removed.'); viewPerson(); }
    })));
    body.querySelectorAll('[data-cpsrec]').forEach((b) => b.addEventListener('click', () => cpsSubmitModal(d.records.find((r) => String(r.id) === b.dataset.cpsrec))));
    body.querySelectorAll('[data-nfarec]').forEach((b) => b.addEventListener('click', () => {
        const rec = d.records.find((r) => String(r.id) === b.dataset.nfarec);
        nfaModal(rec.cps && ['pending', 'more_evidence'].includes(rec.cps.status)
            ? 'This case is with the CPS. Taking no further action withdraws it from them.'
            : 'This ends the case, cancels any bail for it and tells them if they are in the city.',
            (reason) => api('nfa', { recordId: rec.id, reason }));
    }));
    body.querySelectorAll('[data-delrec]').forEach((b) => b.addEventListener('click', () => confirmModal('Delete this custody record? This cannot be undone.', async () => {
        const r = await api('deleteRecord', { id: b.dataset.delrec });
        if (r.ok) { toast('Record deleted.'); viewPerson(); }
    })));
}

/* ----- bail ----- */
function tabBail(body, d) {
    if (!d.bail.length) { body.innerHTML = '<p class="empty">No bail history.</p>'; return; }
    const statusText = { active: 'Active', answered: 'Answered', breached: 'Breached', cancelled: 'Cancelled', nfa: 'No further action' };
    body.innerHTML = d.bail.map((b) => `
        <div class="record ${b.status === 'active' ? (b.overdue ? 'bail-overdue' : 'bail-active') : ''}">
            <div class="meta">${esc(b.custodyRef || `Bail ${b.id}`)} &nbsp; granted ${fmtDate(b.createdAt)} by ${esc(b.officer || '')}</div>
            <h3>${esc(bailType(b.type).label)} <span class="chip ${b.status === 'active' ? (b.overdue ? 'warn' : 'amber') : (b.status === 'breached' ? 'warn' : '')}">${b.overdue ? 'Overdue' : statusText[b.status] || b.status}</span></h3>
            ${b.returnAt ? `<p>Answer at ${esc(b.station)} on ${fmtDate(b.returnAt)}.</p>` : ''}
            <ul>${(b.offences || []).map((o) => `<li>${esc(o)}</li>`).join('')}</ul>
            ${conditionsList(b.conditions)}
            ${b.notes ? `<p class="muted">${esc(b.notes)}</p>` : ''}
            ${b.closedBy ? `<p class="muted">Closed by ${esc(b.closedBy)} on ${fmtDate(b.updatedAt)}</p>` : ''}
            ${b.status === 'active' ? `<div class="actions">
                <button class="btn small primary" data-bact="answered" data-id="${b.id}">Answered bail</button>
                ${b.returnAt ? `<button class="btn small" data-bext="${b.id}">Change return date</button>` : ''}
                <button class="btn small" data-bnfa="${b.id}">No further action</button>
                <button class="btn small danger" data-bact="breached" data-id="${b.id}">Record breach</button>
                <button class="btn small" data-bact="cancelled" data-id="${b.id}">Cancel bail</button>
            </div>` : ''}
        </div>`).join('');
    const msgs = { answered: 'Marked as answered.', breached: 'Breach recorded. A wanted marker has been added.', cancelled: 'Bail cancelled.' };
    body.querySelectorAll('[data-bact]').forEach((b) => b.addEventListener('click', () => {
        const run = async () => {
            const r = await api('updateBail', { id: b.dataset.id, action: b.dataset.bact });
            if (r.ok) { toast(msgs[b.dataset.bact]); viewPerson(); }
        };
        if (b.dataset.bact === 'breached') confirmModal('Record a breach of bail? This adds a wanted marker to their record.', run);
        else run();
    }));
    body.querySelectorAll('[data-bnfa]').forEach((b) => b.addEventListener('click', () => nfaModal(
        'This ends the bail and the case it relates to, and tells them if they are in the city.',
        (reason) => api('updateBail', { id: b.dataset.bnfa, action: 'nfa', reason }))));
    body.querySelectorAll('[data-bext]').forEach((b) => b.addEventListener('click', () => extendModal(d.bail.find((x) => String(x.id) === b.dataset.bext))));
}

/* ----- interviews tab ----- */
function tabInterviews(body, d) {
    if (!d.interviews.length) { body.innerHTML = '<p class="empty">No recorded interviews match this person or their custody references.</p>'; return; }
    body.innerHTML = interviewRows(d.interviews);
    bindInterviewRows(body);
}

function interviewRows(list) {
    return `<div class="rows">${list.map((s) => `
        <button class="row" data-iid="${s.id}">
            <span class="name">${esc(s.interviewee || 'Unknown')}<br><span class="muted">${esc(s.caseRef || 'No case reference')}</span></span>
            <span>${esc(s.room || '')}<br><span class="muted">${esc(s.officer || '')}</span></span>
            <span>${fmtDate(Math.floor((s.startedAt || 0) / (s.startedAt > 1e11 ? 1000 : 1)))}<br><span class="muted">${fmtClock(s.duration)}</span></span>
            <span>${s.status === 'recording' ? '<span class="chip amber">Recording</span>' : '<span class="chip">Play</span>'}</span>
        </button>`).join('')}</div>`;
}
function bindInterviewRows(el) {
    el.querySelectorAll('[data-iid]').forEach((b) => b.addEventListener('click', () => go('interview', { interviewId: b.dataset.iid, returnTo: state.view })));
}

/* ----- person: vehicles tab ----- */
function tabVehicles(body, d) {
    if (!d.vehicles.length) { body.innerHTML = '<p class="empty">No vehicles registered to this person.</p>'; return; }
    body.innerHTML = `<div class="panel flush"><table><tr><th>VRM</th><th>Vehicle</th><th>Status</th><th></th></tr>
        ${d.vehicles.map((v) => `<tr class="click" data-plate="${esc(v.plate)}"><td>${vrm(v.plate)}</td><td>${esc(v.modelLabel || v.model)}</td>
        <td>${vehicleStatus(v.markers, v.flags)} ${(v.flags || []).length > 1 ? flagChips(v.flags) : ''}</td><td class="go">›</td></tr>`).join('')}</table></div>`;
    body.querySelectorAll('[data-plate]').forEach((r) => r.addEventListener('click', () => go('vehicle', { plate: r.dataset.plate })));
}

// Worst problem first: markers, then MID / MOT / VED flags from vinewood-vehicleservices.
function vehicleStatus(markers = [], flags = []) {
    const names = markers.map((m) => m.marker);
    if (names.includes('Stolen')) return pill('Stolen', 'red');
    if (names.includes('Seize s.165')) return pill('Seize', 'red');
    const red = (flags || []).find((f) => f.level === 'red');
    if (red) return pill(red.label, 'red');
    if (names.includes('No insurance')) return pill('No insurance', 'amber');
    if (names.length) return pill(names[0], 'amber');
    if ((flags || []).length) return pill(flags[0].label, 'amber');
    return pill('Clear', 'green');
}
// All the MID / MOT / VED problems as small chips, for tables.
const flagChips = (flags = []) => flags.map((f) => `<span class="chip ${f.level === 'red' ? 'warn' : 'amber'}">${esc(f.label)}</span>`).join(' ');

const MID_TEXT = { insured: 'Insured', void: 'Not insured (keeper changed)', expired: 'Insurance expired', none: 'No insurance' };
const MOT_TEXT = { valid: 'Valid', dangerous: 'Failed - dangerous defects', expired: 'Expired', failed: 'Failed', none: 'No MOT on record' };
const VED_TEXT = { taxed: 'Taxed', sorn: 'SORN', untaxed: 'Untaxed', none: 'Untaxed' };
function servicesRows(v) {
    const m = v.mid || {}, t = v.mot || {}, x = v.ved || {};
    const drivers = m.policyNo ? (m.anyDriver ? 'Any driver' : ['Policyholder', ...(m.drivers || []).map((d) => esc(d.name))].join(', ')) : '';
    const last = t.last ? `<br><small class="muted">Last test ${esc(String(t.last.result || '').toUpperCase())} ${esc(t.last.date || '')} at ${esc(t.last.garage || '-')}${(t.last.defects || []).length ? ': ' + t.last.defects.map((d) => esc(d.label)).join(', ') : ''}</small>` : '';
    const vedExtra = x.status === 'taxed' ? ` · until ${esc(x.expires || '')}${x.band ? ` · ${esc(x.band)}` : ''}`
        : x.status === 'sorn' ? ` · since ${esc(x.since || '')}` : x.keeperChanged ? ' · ended on change of keeper' : x.expires ? ` · expired ${esc(x.expires)}` : '';
    return `
        <dt>Insurance (MID):</dt><dd class="${m.status === 'insured' ? 'ok' : 'bad'}">${MID_TEXT[m.status] || esc(m.status || 'Unknown')}
            ${m.policyNo ? `<br><small class="muted">${esc(m.coverLabel || '')} · ${esc(m.holder || '')} · ${esc(m.policyNo)} · ${m.status === 'insured' ? 'expires' : 'expired'} ${esc(m.expires || '')}<br>Drivers: ${drivers}</small>` : ''}</dd>
        <dt>MOT:</dt><dd class="${t.status === 'valid' ? 'ok' : 'bad'}">${MOT_TEXT[t.status] || esc(t.status || 'Unknown')}${t.expires ? ` · expiry ${esc(t.expires)}` : ''}${last}</dd>
        <dt>Tax (VED):</dt><dd class="${x.status === 'taxed' ? 'ok' : 'bad'}">${VED_TEXT[x.status] || esc(x.status || 'Unknown')}${vedExtra}</dd>`;
}

/* ---------- vehicles ---------- */
function viewVehicles() {
    main.innerHTML = pageHead('Vehicle search', 'Search for a vehicle by registration') + `
        <form class="panel" id="vs">
            <div class="form-row" style="grid-template-columns:minmax(0,280px)">
                <div><label for="vq">Registration (VRM)</label><div class="suggest-wrap"><input id="vq" autocomplete="off" style="text-transform:uppercase" placeholder="e.g. AB12 CDE" value="${esc(state.lastVehQ || '')}"><div class="suggest hidden" id="vSuggest"></div></div></div>
            </div>
            <div class="form-actions"><button class="btn primary wide">${icon('search')}Search</button><button class="btn wide" type="button" id="vClear">${icon('refresh')}Clear</button></div>
        </form>
        <div id="vr"></div>`;
    $('#vs').addEventListener('submit', (e) => { e.preventDefault(); state.lastVehQ = $('#vq').value; searchVehicles(); });
    $('#vClear').addEventListener('click', () => { state.lastVehQ = ''; viewVehicles(); });
    plateSuggest($('#vq'), $('#vSuggest'));
    $('#vq').focus();
    if (state.lastVehQ) searchVehicles();
    else loadFlagged();
}

// Shown under the search box until you search: vehicles carrying a marker, Stolen first.
async function loadFlagged() {
    const marker = state.vehMarker || 'Stolen';
    const el = $('#vr');
    if (!el) return;
    const d = await api('flaggedVehicles', { marker });
    if (d.error || state.view !== 'vehicles' || state.lastVehQ) return;
    const markers = state.cfg.markers.vehicle || [];
    el.innerHTML = `<div class="panel section">
        ${panelHead(`${esc(marker)} vehicles (${d.results.length})`)}
        <div class="filters" id="vmF">${markers.map((m) => `<button type="button" data-m="${esc(m)}" class="${m === marker ? 'active' : ''}">${esc(m)}${d.counts[m] ? ` (${d.counts[m]})` : ''}</button>`).join('')}</div>
        ${d.results.length ? `<div class="table-wrap"><table><tr><th>VRM</th><th>Vehicle</th><th>Registered keeper</th><th>Details</th><th>Marked</th><th></th></tr>
            ${d.results.map((v) => `<tr class="click" data-plate="${esc(v.plate)}"><td>${vrm(v.plate)}</td><td>${esc(v.modelLabel || v.model || 'Not registered')}</td>
            <td>${esc(v.ownerName || (v.owner ? v.owner : 'No registered keeper'))}</td><td>${esc(truncate(v.note || '', 70))}</td>
            <td>${fmtDate(v.at, false)}<br><span class="muted">${esc(v.officer || '')}</span></td><td class="go">›</td></tr>`).join('')}</table></div>`
            : `<p class="empty">No vehicles are marked ${esc(marker.toLowerCase())}.</p>`}
    </div>`;
    el.querySelectorAll('[data-m]').forEach((b) => b.addEventListener('click', () => { state.vehMarker = b.dataset.m; loadFlagged(); }));
    el.querySelectorAll('[data-plate]').forEach((r) => r.addEventListener('click', () => go('vehicle', { plate: r.dataset.plate })));
}

async function searchVehicles() {
    const d = await api('searchVehicles', { q: state.lastVehQ });
    const el = $('#vr');
    if (d.error || !el) return;
    const lic = { valid: ['green', 'Licensed'], provisional: ['amber', 'Provisional'], disqualified: ['red', 'Disqualified'], none: ['red', 'No licence'] };
    el.innerHTML = `<div class="panel section">${panelHead(`Search results (${d.results.length})`)}${d.results.length ? `<div class="table-wrap"><table>
        <tr><th>VRM</th><th>Vehicle</th><th>Registered keeper</th><th>Keeper licence</th><th>Status</th><th></th></tr>
        ${d.results.map((v) => `<tr class="click" data-plate="${esc(v.plate)}">
            <td>${vrm(v.plate)}</td><td>${esc(v.modelLabel || v.model)}</td>
            <td>${esc(v.ownerName || 'Unknown')} ${v.ownerBail ? pill(v.ownerBail.overdue ? 'FTA bail' : 'On bail', v.ownerBail.overdue ? 'red' : 'amber') : ''}</td>
            <td>${v.ownerLicence ? pill(lic[v.ownerLicence][1], lic[v.ownerLicence][0]) : '<span class="muted">No record</span>'}</td>
            <td>${vehicleStatus(v.markers, v.flags)}${(v.flags || []).length > 1 ? `<br>${flagChips(v.flags)}` : ''}</td><td class="go">›</td></tr>`).join('')}</table></div>`
        : '<p class="empty">No registered keeper found. The vehicle may be unregistered.</p>'}</div>`;
    el.querySelectorAll('[data-plate]').forEach((r) => r.addEventListener('click', () => go('vehicle', { plate: r.dataset.plate })));
}

async function viewVehicle() {
    main.innerHTML = '<p class="muted">Loading vehicle</p>';
    const d = await api('getVehicle', { plate: state.plate });
    if (d.error) { main.innerHTML = `<p class="empty">${esc(d.error)}</p>`; return; }
    const v = d.vehicle, names = v.markers.map((m) => m.marker);
    const lic = { valid: 'Full licence', provisional: 'Provisional only', disqualified: 'Disqualified', none: 'No licence' };
    const img = v.spawn ? `https://docs.fivem.net/vehicles/${encodeURIComponent(v.spawn)}.webp` : null;
    main.innerHTML = `
        ${pageHead('Vehicle record', '', `<div class="actions">
            <button class="btn primary small" id="vReport">${icon('report')}Create report</button>
            <button class="btn primary small" id="vNote">${icon('note')}Add note</button>
            <button class="btn small" id="vIntel">${icon('bulb')}Intelligence</button>
            ${state.cfg.anpr ? `<button class="btn small" id="vAnpr">${icon('camera')}Add to ANPR</button>` : ''}
            ${v.services ? `<button class="btn small" id="vDriver">${icon('id')}Check driver</button>` : ''}
            <button class="btn small" id="vMarker">${icon('plus')}Marker</button></div>`, backBtn('vBack'))}
        <div class="record-top" style="grid-template-columns:300px minmax(0,1fr) minmax(0,1.1fr)">
            <div class="carshot" id="carshot">${icon('car')}</div>
            <div class="who">
                <h1>${vrm(v.plate)} ${vehicleStatus(v.markers, v.flags).replace('class="pill', 'class="pill big')}</h1>
                <dl class="kv">
                    <dt>Vehicle:</dt><dd>${esc(v.modelLabel || v.model)}</dd>
                    <dt>Class:</dt><dd>${esc(v.class || 'Not recorded')}</dd>
                    <dt>Model code:</dt><dd>${esc(v.spawn || '')}</dd>
                    <dt>Markers:</dt><dd>${v.markers.length ? v.markers.map((m) => `<span class="chip warn" title="${esc(m.note || '')}">${esc(m.marker)}${state.cfg.officer.supervisor ? `<button data-vunmark="${m.id}" aria-label="Remove ${esc(m.marker)} marker">&times;</button>` : ''}</span>`).join(' ') : 'None'}</dd>
                    <dt>ANPR:</dt><dd>${(v.anpr || []).length ? v.anpr.map((a) => `<span class="chip warn" title="${esc(a.action || '')}">${esc(a.reason)}</span>`).join(' ') : 'Not on ANPR'}</dd>
                </dl>
            </div>
            <div class="panel">
                <h2 style="margin-bottom:10px">Registration details</h2>
                <dl class="kv">
                    <dt>Registered keeper:</dt><dd>${v.keeper ? `<a href="#" id="vKeeper" style="color:#9CC3FF">${esc(v.keeper.name)}</a>` : 'Unknown'}</dd>
                    <dt>Address:</dt><dd>${esc(v.keeperAddress || 'Not on record')}</dd>
                    <dt>Keeper licence:</dt><dd class="${v.keeperLicence === 'valid' ? 'ok' : (v.keeperLicence ? 'bad' : '')}">${esc(lic[v.keeperLicence] || 'No record')}</dd>
                    ${v.services ? servicesRows(v) : `<dt>Insurance:</dt><dd class="${names.includes('No insurance') ? 'bad' : ''}">${names.includes('No insurance') ? 'Not insured' : 'No marker'}</dd>`}
                    <dt>Keeper status:</dt><dd class="${v.keeperWanted || (v.keeperBail && v.keeperBail.overdue) ? 'bad' : ''}">${v.keeperWanted ? 'Wanted' : v.keeperBail ? (v.keeperBail.overdue ? 'Failed to answer bail' : 'On bail') : 'No trace'}</dd>
                </dl>
            </div>
        </div>
        ${v.keeperBail && (v.keeperBail.conditions || []).some((c) => c.id === 'vehicle') ? '<div class="banner warn">Keeper is bailed not to drive any motor vehicle.</div>' : ''}
        <div class="summary">
            <div class="sum"><div class="t">Linked persons</div><div class="v">${icon('user')}<span class="n">${d.linked.length}</span></div></div>
            <div class="sum"><div class="t">Incidents</div><div class="v">${icon('alert')}<span class="n">${d.incidents.length}</span></div></div>
            <div class="sum"><div class="t">Intelligence</div><div class="v">${icon('bulb')}<span class="n">${d.intel.length}</span></div></div>
            <div class="sum"><div class="t">Notes</div><div class="v">${icon('note')}<span class="n">${d.notes.length}</span></div></div>
        </div>
        <div class="panel flush section">${panelHead('Recent activity')}${activityTable(d.activity)}</div>
        <div class="grid2 section">
            <div class="panel flush">${panelHead('Linked persons')}${d.linked.length ? `<table>${d.linked.map((l) => `<tr class="click" data-cid="${esc(l.cid)}"><td class="strong">${esc(l.name)}</td><td>${esc(l.role)}</td><td class="go">›</td></tr>`).join('')}</table>` : '<p class="empty" style="padding:14px">Nobody linked.</p>'}</div>
            <div class="panel flush">${panelHead('Incidents')}${d.incidents.length ? `<table>${d.incidents.map((i) => `<tr class="click" data-inc="${i.id}"><td class="strong">${esc(i.ref)}</td><td>${esc(i.type)}</td><td>${fmtDate(i.created_at, false)}</td><td>${incidentStatusPill(i.status)}</td></tr>`).join('')}</table>` : '<p class="empty" style="padding:14px">No incidents.</p>'}</div>
        </div>
        <div class="grid2 section">
            <div class="panel flush">${panelHead('Intelligence')}${intelTable(d.intel)}</div>
            <div class="panel">${panelHead('Notes')}${notesList(d.notes)}</div>
        </div>`;
    if (img) {
        const probe = new Image();
        probe.onload = () => { const c = $('#carshot'); if (c) { c.style.backgroundImage = `url('${img}')`; c.innerHTML = ''; } };
        probe.src = img;
    }
    $('#vBack').addEventListener('click', () => go('vehicles'));
    $('#vReport').addEventListener('click', () => incidentModal({ linkKind: 'vehicle', linkId: v.plate, linkName: v.plate }));
    $('#vNote').addEventListener('click', () => noteModal('vehicle', v.plate, v.plate));
    $('#vIntel').addEventListener('click', () => intelModal({ kind: 'vehicle', id: v.plate, label: v.plate }));
    $('#vMarker').addEventListener('click', () => markerModal('vehicle', v.plate, viewVehicle));
    $('#vAnpr')?.addEventListener('click', () => anprModal(v.plate, viewVehicle));
    $('#vDriver')?.addEventListener('click', () => checkDriverModal(v));
    main.querySelectorAll('[data-vunmark]').forEach((b) => b.addEventListener('click', () => confirmModal('Remove this marker from the vehicle? ANPR will stop alerting on it.', async () => {
        const r = await api('removeMarker', { id: b.dataset.vunmark });
        if (r.ok) { toast('Marker removed.'); viewVehicle(); }
    })));
    $('#vKeeper')?.addEventListener('click', (e) => { e.preventDefault(); openPerson(v.keeper.cid); });
    main.querySelectorAll('[data-cid]').forEach((r) => r.addEventListener('click', () => openPerson(r.dataset.cid)));
    main.querySelectorAll('[data-inc]').forEach((r) => r.addEventListener('click', () => go('incident', { incidentId: r.dataset.inc })));
}

/* ---------- ANPR ---------- */
const anprKey = (p) => String(p || '').toUpperCase().replace(/[^A-Z0-9]/g, '');
function reasonPills(reasons = []) {
    return reasons.map((r) => pill(r.label, r.level === 'red' ? 'red' : 'amber')).join(' ');
}
function viewAnpr() {
    const tab = state.anprTab || 'hits';
    main.innerHTML = pageHead('ANPR', 'Automatic number plate recognition: hits from in-car units and roadside cameras',
        `<button class="btn primary" id="anprNew">${icon('plus')}Add plate to ANPR</button>`) + `
        <div class="grid3" id="anprStats"></div>
        <div class="filters section" id="anprTabs"><button data-t="hits">Recent hits</button><button data-t="markers">Plates on ANPR</button>${state.cfg.speed ? '<button data-t="speed">Speed detections</button>' : ''}<button data-t="setup">Cameras and fitted vehicles</button></div>
        <div class="panel flush" id="anprBody"><p class="muted" style="padding:14px">Loading</p></div>`;
    main.querySelectorAll('#anprTabs button').forEach((b) => {
        b.classList.toggle('active', b.dataset.t === tab);
        b.addEventListener('click', () => { state.anprTab = b.dataset.t; viewAnpr(); });
    });
    $('#anprNew').addEventListener('click', () => anprModal('', viewAnpr));
    loadAnpr(tab);
}
async function loadAnpr(tab) {
    if (tab === 'setup') { loadAnprSetup(); }
    if (tab === 'speed') { loadSpeed(); }
    const d = await api('anprList');
    if (d.error || state.view !== 'anpr') return;
    const today = d.hits.filter((h) => nowSecs() - h.created_at < 86400).length;
    $('#anprStats').innerHTML = `
        <div class="stat"><span class="ico">${icon('camera')}</span><span><span class="n">${d.units}</span><span class="l">In-car units active</span></span></div>
        <div class="stat"><span class="ico">${icon('pin')}</span><span><span class="n">${d.cameras}</span><span class="l">Roadside cameras</span></span></div>
        <div class="stat ${today ? 'hot' : ''}"><span class="ico">${icon('alert')}</span><span><span class="n">${today}</span><span class="l">Hits in the last 24 hours</span></span></div>`;
    const el = $('#anprBody');
    if (tab === 'setup' || tab === 'speed') return;
    if (tab === 'hits') {
        el.innerHTML = d.hits.length ? `<div class="table-wrap"><table><tr><th>Time</th><th>VRM</th><th>Vehicle</th><th>Hit</th><th>Read by</th><th>Location</th></tr>
            ${d.hits.map((h) => `<tr class="click" data-plate="${esc(h.plate)}"><td>${fmtDate(h.created_at)}</td><td>${vrm(h.plate)}</td><td>${esc(h.model || '')}</td>
            <td>${reasonPills(h.reasons)}</td><td>${esc(h.officer_name || h.source || '')}</td><td>${esc(h.location || '')}</td></tr>`).join('')}</table></div>`
            : '<p class="empty" style="padding:14px">No ANPR hits yet.</p>';
        el.querySelectorAll('[data-plate]').forEach((r) => r.addEventListener('click', () => go('vehicle', { plate: r.dataset.plate })));
    } else {
        el.innerHTML = d.markers.length ? `<div class="table-wrap"><table><tr><th>VRM</th><th>Reason</th><th>Action</th><th>Added by</th><th>Expires</th><th></th></tr>
            ${d.markers.map((m) => `<tr><td>${vrm(m.plate)}</td><td>${esc(m.reason)}${m.note ? `<br><span class="muted">${esc(truncate(m.note, 80))}</span>` : ''}</td>
            <td>${esc(m.action || '')}</td><td>${esc(m.officer_name || '')}<br><span class="muted">${fmtDate(m.created_at, false)}</span></td>
            <td>${m.expires_at ? fmtDate(m.expires_at) : 'No expiry'}</td>
            <td style="text-align:right"><button class="btn tiny" data-rm="${m.id}">Remove</button></td></tr>`).join('')}</table></div>`
            : '<p class="empty" style="padding:14px">No plates on ANPR. Add one to be alerted when it passes a camera.</p>';
        el.querySelectorAll('[data-rm]').forEach((b) => b.addEventListener('click', () => confirmModal('Take this plate off ANPR?', async () => {
            const r = await api('anprRemove', { id: b.dataset.rm });
            if (!r.ok) return;
            viewAnpr();
            if ((r.stillHits || []).length) {
                // Something other than the ANPR entry still causes a hit: say what, and offer the vehicle record.
                openModal(`<h1>${vrm(r.plate)} is off ANPR</h1>
                    <p>It will still alert, because of:</p><ul>${r.stillHits.map((x) => `<li>${esc(x)}</li>`).join('')}</ul>
                    <p class="muted">Vehicle markers are removed on the vehicle record by a supervisor. Keeper hits stop when the keeper's warrant, disqualification or bail ends.</p>
                    <div class="actions"><button class="btn" data-close>Close</button><button class="btn primary" id="rmOpen">Open vehicle record</button></div>`, (m) => {
                    m.querySelector('#rmOpen').addEventListener('click', () => { closeModal(); go('vehicle', { plate: r.plate }); });
                });
            } else toast('Removed from ANPR. It will no longer alert.');
        })));
    }
}
async function loadAnprSetup() {
    const d = await api('anprSetup');
    const el = $('#anprBody');
    if (d.error || !el || state.view !== 'anpr') return;
    const man = d.canManage;
    el.innerHTML = `<div style="padding:14px">
        <p class="muted" style="margin:0 0 12px">Place cameras and fit vehicles in game with <b>/${esc(d.command)}</b>${man ? '' : ' (supervisors)'}: stand where a camera should read, or sit in the vehicle to fit.</p>
        <h2 style="margin-bottom:8px">Roadside cameras (${d.cameras.length})</h2>
        ${d.cameras.length ? `<table><tr><th>Name</th><th>Read distance</th><th>Added</th><th>Status</th><th></th></tr>
            ${d.cameras.map((c) => `<tr><td class="strong">${esc(c.name)}</td><td>${Math.round(c.radius)} m</td>
            <td>${c.source === 'config' ? '<span class="muted">config.lua</span>' : esc(c.addedBy || 'In game')}</td>
            <td>${c.active ? pill('On', 'green') : pill('Off')}</td>
            <td style="text-align:right;white-space:nowrap">${man && c.source !== 'config' ? `<button class="btn tiny" data-ctog="${esc(c.id)}">${c.active ? 'Switch off' : 'Switch on'}</button> <button class="btn tiny" data-cdel="${esc(c.id)}">Remove</button>` : ''}</td></tr>`).join('')}</table>`
            : '<p class="empty">No cameras yet.</p>'}
        <h2 style="margin:18px 0 8px">Fitted vehicles</h2>
        ${(d.fitted.length || d.configModels.length) ? `<table><tr><th>Fitted</th><th>Type</th><th>Added by</th><th></th></tr>
            ${d.fitted.map((f) => `<tr><td class="strong">${esc(f.label || f.value)}</td><td>${f.kind === 'model' ? 'Every vehicle of this model' : 'This vehicle only'}</td>
                <td>${esc(f.added_by || '')}</td><td style="text-align:right">${man ? `<button class="btn tiny" data-fdel="${f.id}">Remove</button>` : ''}</td></tr>`).join('')}
            ${d.configModels.map((m) => `<tr><td class="strong">${esc(m)}</td><td>Every vehicle of this model</td><td class="muted">config.lua</td><td></td></tr>`).join('')}</table>`
            : '<p class="empty">Nothing listed, so every emergency vehicle has ANPR.</p>'}
    </div>`;
    const act = async (kind, id) => { const r = await api('anprSetupRemove', { kind, id }); if (r.ok) { toast('ANPR setup updated.'); loadAnprSetup(); } };
    el.querySelectorAll('[data-ctog]').forEach((b) => b.addEventListener('click', () => act('cameraToggle', b.dataset.ctog)));
    el.querySelectorAll('[data-cdel]').forEach((b) => b.addEventListener('click', () => confirmModal('Remove this camera?', () => act('camera', b.dataset.cdel))));
    el.querySelectorAll('[data-fdel]').forEach((b) => b.addEventListener('click', () => confirmModal('Take ANPR off this?', () => act('fitted', b.dataset.fdel))));
}
/* ---------- speed detections ---------- */
async function loadSpeed() {
    const d = await api('speedList', {});
    const el = $('#anprBody');
    if (d.error || !el || state.view !== 'anpr') return;
    const tol = d.tolerance || { percent: 10, plus: 2 };
    el.innerHTML = `<p class="muted" style="padding:12px 14px 0;margin:0">Speeds from in-car ANPR (automatic or locked with the lock key) and speed cameras. Over the limit means more than the limit + ${tol.percent}% + ${tol.plus} ${esc(d.unit)}.</p>
        ${d.results.length ? `<div class="table-wrap"><table><tr><th>Time</th><th>VRM</th><th>Keeper</th><th>Speed</th><th>Device</th><th>Location</th><th></th></tr>
        ${d.results.map((r) => `<tr><td>${fmtDate(r.created_at)}</td><td>${vrm(r.realPlate || r.plate)}<br><span class="muted">${esc(r.model || '')}</span></td>
            <td>${esc(r.keeper || (r.owner ? r.owner : 'Not registered'))}</td>
            <td>${r.over ? pill(`${r.speed} in a ${r.speed_limit}`, 'red') : pill(`${r.speed}${r.speed_limit ? ` in a ${r.speed_limit}` : ''}`, '')}<br><span class="muted">${esc(r.unit || d.unit)}${r.patrol_speed ? ` · patrol ${r.patrol_speed}` : ''}${r.locked ? ' · locked' : ''}</span></td>
            <td>${esc(r.device || '')}<br><span class="muted">${esc(r.officer_name || '')}</span></td><td>${esc(r.location || '')}</td>
            <td style="text-align:right;white-space:nowrap">${r.fine_ref ? pill(r.fine_ref, 'green') : (r.over && r.owner && state.cfg.fines ? `<button class="btn tiny" data-tk="${r.id}">Ticket keeper</button>` : '')}
                ${r.realPlate ? ` <button class="btn tiny" data-veh="${esc(r.realPlate)}">Vehicle</button>` : ''}</td></tr>`).join('')}</table></div>`
        : '<p class="empty" style="padding:14px">No speeds recorded yet.</p>'}`;
    el.querySelectorAll('[data-veh]').forEach((b) => b.addEventListener('click', () => go('vehicle', { plate: b.dataset.veh })));
    el.querySelectorAll('[data-tk]').forEach((b) => b.addEventListener('click', () => {
        const r = d.results.find((x) => String(x.id) === b.dataset.tk);
        fineModal({ cid: r.owner, name: r.keeper || r.owner, plate: r.realPlate || r.plate, location: r.location, codes: ['SP30'],
            notes: `${r.speed} ${r.unit || d.unit} in a ${r.speed_limit} limit, ${r.device}${r.officer_name ? ` (${r.officer_name})` : ''}, ${fmtDate(r.created_at)}`,
            onIssued: (f) => api('speedTicketed', { id: r.id, ref: f.ref }) });
    }));
}

function anprModal(plate, after) {
    const actions = (state.cfg.anpr && state.cfg.anpr.actions) || ['Stop vehicle'];
    openModal(`<h1>Add plate to ANPR</h1><p class="muted">Officers with in-car ANPR and every roadside camera will alert on this plate. Any plate can be added, including false plates.</p>
        <div class="two"><div><label for="aPlate">Registration</label><div class="suggest-wrap"><input id="aPlate" autocomplete="off" style="text-transform:uppercase" value="${esc(plate || '')}" aria-autocomplete="list" aria-controls="aSuggest"><div class="suggest hidden" id="aSuggest" role="listbox"></div></div></div>
        <div><label for="aFor">For</label><select id="aFor"><option value="24">24 hours</option><option value="168" selected>7 days</option><option value="672">28 days</option><option value="0">No expiry</option></select></div></div>
        <label for="aReason">Reason</label><input id="aReason" placeholder="e.g. Used in armed robbery LSP-2026-01543">
        <label for="aAction">Action on sighting</label><select id="aAction">${actions.map((a) => `<option>${esc(a)}</option>`).join('')}</select>
        <label for="aNote">Information for officers</label><textarea id="aNote" placeholder="Occupants, risks, who to contact"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="aSave">Add to ANPR</button></div>`, (m) => {
        plateSuggest(m.querySelector('#aPlate'), m.querySelector('#aSuggest'));
        m.querySelector('#aSave').addEventListener('click', async () => {
            const r = await api('anprAdd', { plate: m.querySelector('#aPlate').value, hours: m.querySelector('#aFor').value,
                reason: m.querySelector('#aReason').value, action: m.querySelector('#aAction').value, note: m.querySelector('#aNote').value });
            if (!r.ok) return;
            closeModal(); toast(r.updated ? 'That plate was already on ANPR. Its details have been updated.' : 'Plate added to ANPR.'); after && after();
        });
    });
}

/* Shows matching plates under a registration box as the officer types. */
function plateSuggest(input, list) {
    let timer, seq = 0, items = [], index = -1;
    const close = () => { list.classList.add('hidden'); index = -1; };
    const pick = (i) => { if (!items[i]) return; input.value = items[i].plate.toUpperCase(); close(); input.focus(); };
    const highlight = () => list.querySelectorAll('button').forEach((b, i) => b.classList.toggle('on', i === index));
    const run = async () => {
        const q = input.value.trim();
        if (anprKey(q).length < 2) { close(); return; }
        const mine = ++seq;
        const d = await fetch(`https://${RES}/request`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ action: 'plateSuggest', data: { q } }) })
            .then((r) => r.json()).catch(() => ({ results: [] }));
        if (mine !== seq || document.activeElement !== input) return;
        items = d.results || [];
        index = -1;
        list.innerHTML = items.length ? items.map((v, i) => `<button type="button" role="option" data-i="${i}">
                ${vrm(v.plate)}
                <span class="d">${esc(v.modelLabel || v.model || (v.registered ? 'Registered vehicle' : 'Unregistered plate'))}${v.keeper ? ` · ${esc(v.keeper)}` : ''}</span>
                <span class="m">${v.onAnpr ? `<span class="tag">Already on ANPR: ${esc(v.onAnpr)}</span>` : v.seen ? `Last ANPR hit ${fmtDate(v.seen)}` : v.registered ? 'Registered' : ''}</span>
            </button>`).join('') : '<div class="none">No matching plates. You can still add it.</div>';
        list.classList.remove('hidden');
        list.querySelectorAll('[data-i]').forEach((b) => b.addEventListener('mousedown', (e) => { e.preventDefault(); pick(+b.dataset.i); }));
    };
    input.addEventListener('input', () => { clearTimeout(timer); timer = setTimeout(run, 250); });
    input.addEventListener('keydown', (e) => {
        if (list.classList.contains('hidden') || !items.length) return;
        if (e.key === 'ArrowDown') { e.preventDefault(); index = (index + 1) % items.length; highlight(); }
        else if (e.key === 'ArrowUp') { e.preventDefault(); index = (index - 1 + items.length) % items.length; highlight(); }
        else if (e.key === 'Enter' && index >= 0) { e.preventDefault(); pick(index); }
        else if (e.key === 'Escape') { e.stopPropagation(); close(); }
    });
    input.addEventListener('blur', () => setTimeout(close, 150));
}

/* ---------- ANPR layout: drag the strip and the alert ---------- */
// Positions are stored as percentages of the screen so they work at any resolution.
function placeEl(el, pos) {
    if (!pos) { el.style.left = el.style.top = el.style.right = el.style.bottom = el.style.transform = ''; return; }
    el.style.left = `${pos.x}%`; el.style.top = `${pos.y}%`;
    el.style.right = 'auto'; el.style.bottom = 'auto'; el.style.transform = 'none';
}
let anprLayout = null;
function applyAnprLayout(layout) {
    anprLayout = layout || null;
    placeEl($('#anprHud'), layout && layout.hud);
    placeEl($('#anprAlert'), layout && layout.alert);
}
function startAnprLayout() {
    const hud = $('#anprHud'), alert = $('#anprAlert'), bar = $('#layoutBar');
    const wasHud = !hud.classList.contains('hidden'), wasAlert = !alert.classList.contains('hidden');
    const before = anprLayout;
    // Sample content so there is something to drag.
    if (!wasAlert) {
        showAnprHit({ plate: 'AB12 CDE', model: 'Example vehicle', keeper: 'Example keeper', camera: 'Front', location: 'Example Road',
            reasons: [{ label: 'Example hit', level: 'red', action: 'This is where hits will appear.' }] }, null);
        clearTimeout(anprTimer);
    }
    hud.classList.remove('hidden'); alert.classList.remove('hidden'); bar.classList.remove('hidden');
    [hud, alert].forEach((el) => el.classList.add('editing'));

    const drag = (el) => (e) => {
        e.preventDefault();
        const r = el.getBoundingClientRect();
        const dx = e.clientX - r.left, dy = e.clientY - r.top;
        placeEl(el, { x: (r.left / innerWidth) * 100, y: (r.top / innerHeight) * 100 });
        const move = (ev) => {
            const x = Math.min(Math.max(ev.clientX - dx, 0), innerWidth - r.width);
            const y = Math.min(Math.max(ev.clientY - dy, 0), innerHeight - r.height);
            placeEl(el, { x: (x / innerWidth) * 100, y: (y / innerHeight) * 100 });
        };
        const up = () => { removeEventListener('mousemove', move); removeEventListener('mouseup', up); };
        addEventListener('mousemove', move); addEventListener('mouseup', up);
    };
    const hudDown = drag(hud), alertDown = drag(alert);
    hud.addEventListener('mousedown', hudDown); alert.addEventListener('mousedown', alertDown);

    const posOf = (el) => ({ x: parseFloat(el.style.left) || 0, y: parseFloat(el.style.top) || 0 });
    const finish = (payload) => {
        hud.removeEventListener('mousedown', hudDown); alert.removeEventListener('mousedown', alertDown);
        [hud, alert].forEach((el) => el.classList.remove('editing'));
        bar.classList.add('hidden');
        hud.classList.toggle('hidden', !wasHud);
        alert.classList.toggle('hidden', !wasAlert);
        $('#layoutSave').onclick = $('#layoutReset').onclick = $('#layoutCancel').onclick = null;
        fetch(`https://${RES}/anprLayoutSave`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) });
    };
    $('#layoutSave').onclick = () => {
        const moved = (el) => el.style.left ? posOf(el) : null;
        finish({ layout: { hud: moved(hud), alert: moved(alert) } });
    };
    $('#layoutReset').onclick = () => { applyAnprLayout(null); finish({ reset: true }); };
    $('#layoutCancel').onclick = () => { applyAnprLayout(before); finish({}); };
}

/* in-game alert, shown without the MDT open */
let anprTimer, audioCtx;
function beep(red) {
    try {
        audioCtx = audioCtx || new (window.AudioContext || window.webkitAudioContext)();
        const pattern = red ? [0, .18, .36] : [0, .22];
        pattern.forEach((t) => {
            const o = audioCtx.createOscillator(), g = audioCtx.createGain();
            o.type = 'square'; o.frequency.value = red ? 1100 : 880;
            g.gain.setValueAtTime(.08, audioCtx.currentTime + t);
            g.gain.exponentialRampToValueAtTime(.0001, audioCtx.currentTime + t + .14);
            o.connect(g); g.connect(audioCtx.destination);
            o.start(audioCtx.currentTime + t); o.stop(audioCtx.currentTime + t + .15);
        });
    } catch (e) { /* no audio */ }
}
function showAnprHit(h, key) {
    const red = (h.reasons || []).some((r) => r.level === 'red');
    const top = (h.reasons || [])[0] || {};
    const el = $('#anprAlert');
    el.className = `anpr-alert ${red ? '' : 'amber'}`;
    el.innerHTML = `<div class="top"><b>ANPR hit${h.camera === 'fixed' ? '' : ` - ${esc(h.camera || '')}`}</b><span class="muted">${fmtTime(nowSecs())}</span></div>
        <span class="vrm plate">${esc(String(h.plate).toUpperCase())}</span>
        <div style="margin-top:8px">${esc(h.model || 'Unknown vehicle')}${h.keeper ? ` <span class="muted">· keeper ${esc(h.keeper)}</span>` : ''}</div>
        <ul>${(h.reasons || []).map((r) => `<li>${esc(r.label)}</li>`).join('')}</ul>
        ${top.action ? `<div class="act">${esc(top.action)}</div>` : ''}
        ${h.note ? `<p class="muted" style="margin:8px 0 0">${esc(h.note)}</p>` : ''}
        <div class="foot"><span>${esc(h.cameraName || h.location || '')}</span>${key ? `<span><kbd>${esc(key)}</kbd> open record</span>` : ''}</div>`;
    beep(red);
    clearTimeout(anprTimer);
    anprTimer = setTimeout(() => el.classList.add('hidden'), 20000);
}

/* ---------- live calls ---------- */
let callsTimer;
function ago(ts) {
    const m = Math.max(0, Math.floor((nowSecs() - ts) / 60));
    return m < 1 ? 'Just now' : m < 60 ? `${m} min ago` : `${Math.floor(m / 60)} h ${m % 60} min ago`;
}
function viewCalls() {
    main.innerHTML = pageHead('Live calls', 'Calls from dispatch. Updates as calls change.', `<button class="btn" id="cRefresh">${icon('refresh')}Refresh</button>`) +
        '<div class="panel flush" id="callList"><p class="muted" style="padding:14px">Loading</p></div>';
    $('#cRefresh').addEventListener('click', loadCalls);
    loadCalls();
    clearInterval(callsTimer);
    callsTimer = setInterval(() => { if (state.view === 'calls' && !$('#tablet').classList.contains('hidden')) loadCalls(); else clearInterval(callsTimer); }, 10000);
}
let lastCalls = [];
let openCallNotes = null;   // dispatchId whose updates modal is open
function callDetail(c) {
    const lines = [];
    if (c.message) lines.push(esc(truncate(c.message, 120)));
    if (c.unit) lines.push(`Unit: ${esc(c.unit)}`);
    if (c.vehicle) lines.push(`Vehicle: ${esc(c.vehicle)}`);
    if (c.weapon) lines.push(`Weapon: ${esc(c.weapon)}`);
    if (c.caller) lines.push(`Caller: ${esc(c.caller)}`);
    const latest = c.notes && c.notes.length ? c.notes[c.notes.length - 1] : null;
    if (latest) lines.push(`<span class="call-note"><b>${esc(latest.author)}</b> ${esc(truncate(latest.text, 100))}</span>`);
    return lines.length ? `<br><span class="muted">${lines.join('<br>')}</span>` : '';
}
async function loadCalls() {
    const d = await api('dispatchCalls');
    const el = $('#callList');
    if (d.error || !el) return;
    if (!d.dispatch) { el.innerHTML = '<p class="empty" style="padding:14px">No dispatch script is connected. See Config.Dispatch.</p>'; return; }
    lastCalls = d.calls;
    el.innerHTML = d.calls.length ? `<div class="table-wrap"><table><tr><th>Grade</th><th>Call</th><th>Location</th><th>Received</th><th>Units</th><th>Source</th><th></th></tr>
        ${d.calls.map((c, i) => `<tr class="${c.attached ? 'call-attached' : ''}"><td>${gradePill(c.grade)}</td>
            <td>${c.dispatchId ? `<span class="muted">#${c.dispatchId}</span> ` : ''}<b>${esc(c.code ? `${c.code} ${c.title}` : c.title)}</b>${callDetail(c)}</td>
            <td>${esc(c.location || 'Unknown')}</td><td>${fmtTime(c.time)}<br><span class="muted">${ago(c.time)}</span></td>
            <td>${c.unitNames && c.unitNames.length ? esc(c.unitNames.join(', ')) : (c.units || 0)}</td><td class="muted">${esc(c.source)}</td>
            <td style="text-align:right;white-space:nowrap">
                ${c.dispatchId ? `<button class="btn tiny ${c.attached ? '' : 'call-attach'}" data-att="${i}">${c.attached ? 'Detach' : 'Attach'}</button>
                <button class="btn tiny" data-notes="${i}">Updates${c.notes && c.notes.length ? ` (${c.notes.length})` : ''}</button> ` : ''}
                ${!c.dispatchId && c.coords ? `<button class="btn tiny" data-wp="${i}">${icon('nav')}Waypoint</button> ` : ''}<button class="btn tiny" data-mk="${i}">Create incident</button></td></tr>`).join('')}
        </table></div>` : `<p class="empty" style="padding:14px">No live calls. Connected to ${esc(d.dispatch)}.</p>`;
    el.querySelectorAll('[data-wp]').forEach((b) => b.addEventListener('click', () => {
        const c = d.calls[+b.dataset.wp].coords;
        fetch(`https://${RES}/waypoint`, { method: 'POST', body: JSON.stringify(c) });
    }));
    el.querySelectorAll('[data-att]').forEach((b) => b.addEventListener('click', () => {
        const c = d.calls[+b.dataset.att];
        b.disabled = true;
        fetch(`https://${RES}/dispatchRespond`, { method: 'POST', body: JSON.stringify({ id: c.dispatchId, coords: c.coords, unitSrc: c.unitSrc }) });
    }));
    el.querySelectorAll('[data-notes]').forEach((b) => b.addEventListener('click', () => callNotesModal(d.calls[+b.dataset.notes].dispatchId)));
    el.querySelectorAll('[data-mk]').forEach((b) => b.addEventListener('click', () => incidentFromCall(d.calls[+b.dataset.mk])));
    if (openCallNotes) renderCallNotes();
}
function renderCallNotes() {
    const box = $('#cnList');
    const c = lastCalls.find((x) => x.dispatchId === openCallNotes);
    if (!box) { openCallNotes = null; return; }
    if (!c) { box.innerHTML = '<p class="empty">This call has been closed.</p>'; return; }
    box.innerHTML = c.notes.length
        ? `<ol class="call-notes">${c.notes.map((n) => `<li><b>${esc(n.author)}</b> ${esc(n.text)} <span class="muted">${ago(nowSecs() - (n.age || 0))}</span></li>`).join('')}</ol>`
        : '<p class="empty">No updates yet.</p>';
    box.scrollTop = box.scrollHeight;
}
function callNotesModal(dispatchId) {
    const c = lastCalls.find((x) => x.dispatchId === dispatchId);
    if (!c) return;
    openCallNotes = dispatchId;
    openModal(`<h1>Call #${c.dispatchId}: ${esc(c.title)}</h1><p class="muted">${esc(c.location || 'Location unknown')}</p>
        <div id="cnList" class="call-notes-box"></div>
        <label for="cnText">Add an update</label>
        <input id="cnText" maxlength="200" placeholder="What's happening at the call">
        <div class="actions"><button class="btn" data-close>Close</button><button class="btn primary" id="cnPost">Post update</button></div>`, (m) => {
        const post = async () => {
            const input = m.querySelector('#cnText');
            const text = input.value.trim();
            if (!text) { input.focus(); return; }
            const r = await api('dispatchNote', { id: dispatchId, text });
            if (r.error) { toast(r.error, true); return; }
            input.value = '';
            loadCalls();
        };
        m.querySelector('#cnPost').addEventListener('click', post);
        m.querySelector('#cnText').addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); post(); } });
    });
    renderCallNotes();
}
let callsChangedTimer;
function callsChanged() {
    clearTimeout(callsChangedTimer);
    callsChangedTimer = setTimeout(() => {
        if ($('#tablet').classList.contains('hidden')) return;
        if (state.view === 'calls') loadCalls();
    }, 400);
}
async function incidentFromCall(c) {
    const r = await api('createIncident', {
        type: state.cfg.incidentTypes.find((t) => (c.title || '').toLowerCase().includes(t.toLowerCase().split(' ')[0])) || 'Other',
        grade: c.grade, location: c.location, coords: c.coords,
        narrative: [c.code, c.title, c.message].filter(Boolean).join(' - ')
            + [c.vehicle && `Vehicle: ${c.vehicle}`, c.weapon && `Weapon: ${c.weapon}`, c.caller && `Caller: ${c.caller}`].filter(Boolean).map((l) => `\n${l}`).join('')
            + (c.notes || []).map((n) => `\n${n.author}: ${n.text}`).join('')
            + `\nFrom ${c.source}${c.dispatchId ? ` call #${c.dispatchId}` : ''} at ${fmtTime(c.time)}.`,
    });
    if (r.ok) { toast(`Incident ${r.ref} created from the call.`); go('incident', { incidentId: r.id }); }
}

/* Roadside: pick the driver, see if they're insured to drive this vehicle and can legally drive. */
async function checkDriverModal(v) {
    const near = await api('nearbyPeople');
    openModal(`<h1>Check driver</h1><p class="muted">${vrm(v.plate)} ${esc(v.modelLabel || '')}</p>
        <label for="cdWho">Driver</label>
        <select id="cdWho">${(near.results || []).map((p) => `<option value="${esc(p.cid)}">${esc(fullName(p))} (${p.distance} m)</option>`).join('') || '<option value="">Nobody nearby</option>'}</select>
        <div id="cdOut" style="margin-top:14px"></div>
        <div class="actions"><button class="btn" data-close>Close</button><button class="btn primary" id="cdGo">Check</button></div>`, (m) => {
        m.querySelector('#cdGo').addEventListener('click', async () => {
            const cid = m.querySelector('#cdWho').value;
            if (!cid) return;
            const r = await api('checkDriver', { plate: v.plate, cid });
            if (r.error) return;
            const lic = { valid: ['ok', 'Full licence'], provisional: ['bad', 'Provisional only'], disqualified: ['bad', 'Disqualified'], none: ['bad', 'No licence'] }[r.licence] || ['', 'No DVLA record'];
            const ins = r.insured === true ? ['ok', 'Insured to drive this vehicle'] : r.insured === false ? ['bad', 'Not insured to drive this vehicle'] : ['', 'Insurance not available'];
            const anyBad = r.insured === false || ['disqualified', 'none', 'provisional'].includes(r.licence) || r.wanted || (r.bail && (r.bail.conditions || []).some((c) => c.id === 'vehicle'));
            m.querySelector('#cdOut').innerHTML = `<div class="banner ${anyBad ? 'warn' : 'info'}" style="margin:0"><strong>${esc(r.name)}</strong>
                <dl class="kv" style="grid-template-columns:120px 1fr;margin-top:6px">
                    <dt>Insurance:</dt><dd class="${ins[0]}">${ins[1]}</dd>
                    <dt>Licence:</dt><dd class="${lic[0]}">${lic[1]}${r.points ? ` · ${r.points} points` : ''}</dd>
                    ${r.wanted ? '<dt>PNC:</dt><dd class="bad">Wanted</dd>' : ''}
                    ${r.bail && (r.bail.conditions || []).some((c) => c.id === 'vehicle') ? '<dt>Bail:</dt><dd class="bad">Bailed not to drive</dd>' : ''}
                </dl>
                ${r.insured === false ? '<p style="margin:8px 0 0">Driving without insurance: IN10, s.143 RTA 1988. Vehicle can be seized under s.165.</p>' : ''}
                <div class="actions" style="margin-top:8px"><button class="btn small" id="cdOpen">Open driver</button></div></div>`;
            m.querySelector('#cdOpen').addEventListener('click', () => { closeModal(); openPerson(cid); });
        });
    });
}

/* ---------- incidents ---------- */
function viewIncidents() {
    const f = state.incForm || {};
    const cfg = state.cfg;
    main.innerHTML = pageHead('Incidents', 'Search and view incident and crime reports', `<button class="btn primary" id="newInc">${icon('plus')}New incident</button>`) + `
        <form class="panel" id="incF">
            <div class="form-row" style="grid-template-columns:repeat(5,minmax(0,1fr))">
                <div><label for="iRef">Incident number</label><input id="iRef" placeholder="${esc(cfg.force.short)}-XXXX" value="${esc(f.ref || '')}"></div>
                <div><label for="iType">Type</label><select id="iType"><option value="">Any</option>${cfg.incidentTypes.map((t) => `<option ${t === f.type ? 'selected' : ''}>${esc(t)}</option>`).join('')}</select></div>
                <div><label for="iStatus">Status</label><select id="iStatus"><option value="">Any</option>${cfg.incidentStatuses.map((t) => `<option ${t === f.status ? 'selected' : ''}>${esc(t)}</option>`).join('')}</select></div>
                <div><label for="iFrom">From date</label><input id="iFrom" type="date" value="${esc(f.from || '')}"></div>
                <div><label for="iTo">To date</label><input id="iTo" type="date" value="${esc(f.to || '')}"></div>
            </div>
            <div class="form-actions"><button class="btn primary wide">${icon('search')}Search</button><button class="btn wide" type="button" id="iClear">${icon('refresh')}Clear</button></div>
        </form>
        <div class="panel flush section"><div class="head" style="padding:12px 14px 0"><h2>Recent incidents</h2></div><div id="incList"><p class="muted" style="padding:14px">Loading</p></div></div>
        <div class="panel flush section"><div class="head" style="padding:12px 14px 0"><h2>Custody</h2>${viewAll('vaCus')}</div><div id="incCustody"></div></div>`;
    $('#newInc').addEventListener('click', () => incidentModal({}));
    $('#incF').addEventListener('submit', (e) => {
        e.preventDefault();
        state.incForm = { ref: $('#iRef').value, type: $('#iType').value, status: $('#iStatus').value, from: $('#iFrom').value, to: $('#iTo').value };
        loadIncidents();
    });
    $('#iClear').addEventListener('click', () => { state.incForm = null; viewIncidents(); });
    $('#vaCus').addEventListener('click', () => go('custody'));
    loadIncidents();
    loadCustodyInto($('#incCustody'), 'all', 6);
}

async function loadIncidents() {
    const f = state.incForm || {};
    const day = (v, end) => v ? Math.floor(new Date(`${v}T${end ? '23:59:59' : '00:00:00'}`).getTime() / 1000) : null;
    const d = await api('searchIncidents', { ref: f.ref, type: f.type || null, status: f.status || null, from: day(f.from), to: day(f.to, true) });
    const el = $('#incList');
    if (d.error || !el) return;
    el.innerHTML = d.results.length ? `<div class="table-wrap"><table><tr><th>Incident no.</th><th>Type</th><th>Location</th><th>Date/time</th><th>Grade</th><th>Status</th><th></th></tr>
        ${d.results.map((i) => `<tr class="click" data-inc="${i.id}"><td class="strong">${esc(i.ref)}</td><td>${esc(i.type)}</td><td>${esc(i.location || '')}</td>
        <td>${fmtDate(i.created_at)}</td><td>${gradePill(i.grade)}</td><td>${incidentStatusPill(i.status)}</td><td class="go">›</td></tr>`).join('')}</table></div>`
        : '<p class="empty" style="padding:14px">No incidents match. Create one with New incident.</p>';
    el.querySelectorAll('[data-inc]').forEach((r) => r.addEventListener('click', () => go('incident', { incidentId: r.dataset.inc })));
}

async function incidentModal(link) {
    const cfg = state.cfg;
    const here = await nui('location');
    openModal(`<h1>New incident</h1>${link.linkName ? `<p class="muted">Linked to ${esc(link.linkName)}</p>` : ''}
        <div class="two">
            <div><label for="nType">Type</label><select id="nType">${cfg.incidentTypes.map((t) => `<option>${esc(t)}</option>`).join('')}</select></div>
            <div><label for="nGrade">Grade</label><select id="nGrade">${cfg.incidentGrades.map((g, i) => `<option ${i === 1 ? 'selected' : ''}>${esc(g)}</option>`).join('')}</select></div>
        </div>
        ${link.linkKind === 'person' ? `<label for="nRole">${esc(link.linkName)} is the</label><select id="nRole">${cfg.incidentRoles.map((r) => `<option>${esc(r)}</option>`).join('')}</select>` : ''}
        <label for="nLoc">Location</label><input id="nLoc" value="${esc(here.location || '')}" placeholder="Street and area">
        <label for="nNar">Details</label><textarea id="nNar" placeholder="What was reported and what officers found"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="nSave">Create incident</button></div>`, (m) => {
        m.querySelector('#nSave').addEventListener('click', async () => {
            const r = await api('createIncident', {
                type: m.querySelector('#nType').value, grade: m.querySelector('#nGrade').value, location: m.querySelector('#nLoc').value,
                coords: here.coords, narrative: m.querySelector('#nNar').value,
                linkKind: link.linkKind, linkId: link.linkId, linkRole: m.querySelector('#nRole') ? m.querySelector('#nRole').value : 'Involved',
            });
            if (!r.ok) return;
            closeModal(); toast(`Incident ${r.ref} created.`);
            go('incident', { incidentId: r.id });
        });
    });
}

async function viewIncident() {
    main.innerHTML = '<p class="muted">Loading incident</p>';
    const d = await api('getIncident', { id: state.incidentId });
    if (d.error) { main.innerHTML = `<p class="empty">${esc(d.error)}</p>`; return; }
    const i = d.incident, cfg = state.cfg;
    main.innerHTML = `
        ${pageHead(`${esc(i.ref)}`, `${esc(i.type)}, ${esc(i.location || 'location not recorded')}`, `<div class="actions">
            <select id="incStatus" style="width:auto">${cfg.incidentStatuses.map((s) => `<option ${s === i.status ? 'selected' : ''}>${esc(s)}</option>`).join('')}</select>
            <select id="incGrade" style="width:auto">${cfg.incidentGrades.map((s) => `<option ${s === i.grade ? 'selected' : ''}>${esc(s)}</option>`).join('')}</select></div>`, backBtn('iBack', 'Back to incidents'))}
        <div class="chips" style="margin:-4px 0 14px">${gradePill(i.grade)} ${incidentStatusPill(i.status)} <span class="muted">Raised by ${esc(i.officer_name || '')}, ${fmtDate(i.created_at)}</span></div>
        <div class="case-grid">
            <div>
                <div class="panel">${panelHead('Details')}
                    <textarea id="incNar" style="min-height:150px">${esc(i.narrative || '')}</textarea>
                    <div class="actions" style="margin-top:10px;justify-content:flex-end"><button class="btn small primary" id="incSave">Save details</button></div>
                </div>
                <div class="panel">${panelHead(`Evidence (${d.evidence.length})`, `<div class="actions">${cfg.forensics ? `<button class="btn small" id="bagFx">${icon('target')}Bag forensic samples</button>` : ''}${cfg.evidenceStorage ? `<button class="btn small primary" id="seizeEx">${icon('box')}Seize from suspect</button>` : ''}<button class="btn small" id="addEx">${icon('plus')}Add exhibit</button></div>`)}
                    ${d.evidence.length ? d.evidence.map((e) => `<div class="exhibit">
                        <div><div class="ref">${esc(e.exhibit_ref)}</div>${e.photo ? `<div class="photo" style="background-image:url('${esc(e.photo)}')"></div>` : ''}</div>
                        <div><b>${esc(e.type)}</b>: ${esc(e.description)}
                            <div class="muted" style="font-size:13px">${e.seized_from_name ? `Seized from ${esc(e.seized_from_name)}. ` : ''}${e.found_at ? `Found at ${esc(e.found_at)}. ` : ''}Seized by ${esc(e.officer_name || '')}</div>
                            ${e.suspect_name ? `<div style="font-size:13px;margin-top:3px">Linked suspect: <a href="#" data-cid="${esc(e.suspect_cid)}" style="color:#9CC3FF">${esc(e.suspect_name)}</a></div>` : ''}
                            ${e.forensic ? forensicBox(e) : ''}
                            ${e.bag ? `<div class="bag">${e.bag.length ? e.bag.map((it) => `<span class="chip">${esc(it.count)}x ${esc(it.label)}${it.serial ? ` <span class="muted">#${esc(it.serial)}</span>` : ''}</span>`).join('') : '<span class="muted">Bag is empty</span>'}</div>` : ''}
                            <ul class="cont">${(e.continuity || []).map((c) => `<li>${fmtDate(c.at)} ${esc(c.by)}: ${esc(c.text)}</li>`).join('')}</ul></div>
                        <div style="text-align:right">${pill(e.status, ['Returned to owner', 'Destroyed'].includes(e.status) ? 'green' : e.status === 'Sent for forensics' ? 'amber' : 'blue')}<br>
                            <div class="ex-actions">
                                ${cfg.evidenceStorage && !e.forensic && e.status !== 'Destroyed' ? `<button class="btn tiny" data-bag="${e.id}">Open bag</button>` : ''}
                                ${e.forensic && e.lab_status === 'not_sent' ? `<button class="btn tiny" data-lab="${e.id}">Send to lab</button>` : ''}
                                <button class="btn tiny" data-move="${e.id}">Update</button>
                                <button class="btn tiny" data-link="${e.id}">${e.suspect_name ? 'Change suspect' : 'Link suspect'}</button>
                                ${e.stash_id && e.seized_from && !['Returned to owner', 'Destroyed'].includes(e.status) ? `<button class="btn tiny" data-ret="${e.id}">Return to owner</button>` : ''}
                                ${cfg.officer.supervisor && e.status !== 'Destroyed' ? `<button class="btn tiny" data-destroy="${e.id}">Destroy</button>` : ''}
                            </div></div>
                    </div>`).join('') : '<p class="empty">No exhibits recorded. Add anything seized, photographed or recovered.</p>'}
                </div>
                ${cfg.statements ? `<div class="panel" id="stmtPanel">${panelHead('Statements', `<button class="btn small primary" id="addSt">${icon('note')}Take statement</button>`)}<div id="stmtList" class="muted">Loading</div></div>` : ''}
            </div>
            <div>
                <div class="panel flush">${panelHead('People', `<button class="btn tiny" id="linkP">Link person</button>`)}
                    ${d.people.length ? `<table>${d.people.map((l) => `<tr><td class="strong"><a href="#" data-cid="${esc(l.subject_id)}" style="color:#9CC3FF">${esc(l.label)}</a></td><td>${esc(l.role || '')}</td>
                        <td style="text-align:right;white-space:nowrap"><button class="btn tiny" data-book="${esc(l.subject_id)}">Book in</button> <button class="btn tiny" data-unlink="${l.id}" aria-label="Unlink">&times;</button></td></tr>`).join('')}</table>`
                        : '<p class="empty" style="padding:0 14px 14px">Nobody linked yet.</p>'}
                </div>
                <div class="panel flush">${panelHead('Vehicles', `<button class="btn tiny" id="linkV">Link vehicle</button>`)}
                    ${d.vehicles.length ? `<table>${d.vehicles.map((l) => `<tr><td><a href="#" data-plate="${esc(l.subject_id)}" style="color:#9CC3FF">${vrm(l.label || l.subject_id)}</a></td><td>${esc(l.role || '')}</td>
                        <td style="text-align:right"><button class="btn tiny" data-unlink="${l.id}" aria-label="Unlink">&times;</button></td></tr>`).join('')}</table>`
                        : '<p class="empty" style="padding:0 14px 14px">No vehicles linked.</p>'}
                </div>
                ${d.interviews ? `<div class="panel flush">${panelHead('Interviews')}${d.interviews.length ? interviewRows(d.interviews)
                    : `<p class="empty" style="padding:0 14px 14px">None yet. Interviews started with ${esc(i.ref)} or a custody reference from this incident appear here.</p>`}</div>` : ''}
                ${d.injury ? `<div class="panel flush">${panelHead('Injury statements', `<button class="btn tiny" id="reqInj">Request from ambulance</button>`)}
                    ${d.injury.length ? `<table>${d.injury.map((q) => `<tr><td class="strong">${esc(q.patientName || '')}<br><span class="muted">Requested ${fmtDate(q.requestedAt)} by ${esc(q.officerName || '')}</span>
                        ${q.status === 'pending' ? '' : `<div style="margin-top:6px;white-space:pre-wrap">${esc(q.statement || '')}</div><span class="muted">${esc(q.clinician || '')}, ${fmtDate(q.respondedAt)}${q.ePRFRef ? `, ePRF ${esc(q.ePRFRef)}` : ''}</span>`}</td>
                        <td style="text-align:right;vertical-align:top">${q.status === 'pending' ? pill('Waiting', 'amber') : q.status === 'fulfilled' ? pill('Provided', 'green') : pill('Declined', 'red')}</td></tr>`).join('')}</table>`
                        : '<p class="empty" style="padding:0 14px 14px">None requested. Ask the ambulance service to describe the injuries of anyone linked to this incident.</p>'}</div>` : ''}
                <div class="panel flush">${panelHead('Custody from this incident')}
                    ${d.records.length ? `<table>${d.records.map((r) => `<tr class="click" data-rec="${esc(r.cid)}"><td class="strong">${esc(r.subject_name)}<br><span class="muted">${esc(r.ref)}</span></td><td>${outcomePill(r.outcome)}</td></tr>`).join('')}</table>`
                        : '<p class="empty" style="padding:0 14px 14px">Nobody arrested yet. Use Book in on a linked person.</p>'}
                </div>
            </div>
        </div>`;
    const id = i.id;
    $('#iBack').addEventListener('click', () => go('incidents'));
    $('#incStatus').addEventListener('change', async (e) => { const r = await api('updateIncident', { id, status: e.target.value }); if (r.ok) { toast(`Incident marked ${e.target.value.toLowerCase()}.`); viewIncident(); } });
    $('#incGrade').addEventListener('change', async (e) => { const r = await api('updateIncident', { id, grade: e.target.value }); if (r.ok) viewIncident(); });
    $('#incSave').addEventListener('click', async () => { const r = await api('updateIncident', { id, narrative: $('#incNar').value }); if (r.ok) toast('Details saved.'); });
    $('#addEx').addEventListener('click', () => evidenceModal(i, d.people));
    $('#seizeEx')?.addEventListener('click', () => seizeModal(i, d.people));
    $('#bagFx')?.addEventListener('click', () => bagSamplesModal(i));
    main.querySelectorAll('[data-lab]').forEach((b) => b.addEventListener('click', async () => {
        const r = await api('sendToLab', { id: b.dataset.lab });
        if (r.ok) { toast(`Sent to the lab. Results in about ${r.minutes} minutes.`); viewIncident(); }
    }));
    const exById = (id) => d.evidence.find((e) => String(e.id) === String(id));
    main.querySelectorAll('[data-bag]').forEach((b) => b.addEventListener('click', () => openEvidenceBag(b.dataset.bag)));
    main.querySelectorAll('[data-link]').forEach((b) => b.addEventListener('click', () => linkSuspectModal(exById(b.dataset.link), d.people)));
    main.querySelectorAll('[data-ret]').forEach((b) => b.addEventListener('click', () => {
        const e = exById(b.dataset.ret);
        confirmModal(`Give everything in ${e.exhibit_ref} back to ${e.seized_from_name || 'the owner'}? Stand next to them.`, async () => {
            const r = await api('evidenceReturn', { id: e.id });
            if (r.ok) { toast(r.returned.length ? `Returned: ${r.returned.join(', ')}${r.kept ? `. ${r.kept} item(s) kept, they could not carry them.` : ''}` : 'Nothing to return.'); viewIncident(); }
        });
    }));
    main.querySelectorAll('[data-destroy]').forEach((b) => b.addEventListener('click', () => {
        const e = exById(b.dataset.destroy);
        openModal(`<h1>Destroy ${esc(e.exhibit_ref)}</h1><p class="muted">Everything in the evidence bag is deleted. This cannot be undone.</p>
            <label for="dsR">Authority / reason</label><input id="dsR" placeholder="e.g. Court ordered forfeiture and destruction">
            <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn danger" id="dsGo">Destroy</button></div>`, (m) => {
            m.querySelector('#dsGo').addEventListener('click', async () => {
                const r = await api('evidenceDestroy', { id: e.id, reason: m.querySelector('#dsR').value });
                if (r.ok) { closeModal(); toast('Exhibit destroyed.'); viewIncident(); }
            });
        });
    }));
    if (cfg.statements) {
        $('#addSt').addEventListener('click', () => statementModal(i, d.people));
        loadStatements(i.id);
    }
    $('#linkP').addEventListener('click', () => linkModal(id, 'person'));
    $('#linkV').addEventListener('click', () => linkModal(id, 'vehicle'));
    main.querySelectorAll('[data-move]').forEach((b) => b.addEventListener('click', () => moveEvidenceModal(d.evidence.find((e) => String(e.id) === b.dataset.move))));
    main.querySelectorAll('[data-unlink]').forEach((b) => b.addEventListener('click', async () => { const r = await api('unlinkIncident', { id: b.dataset.unlink }); if (r.ok) viewIncident(); }));
    main.querySelectorAll('[data-cid]').forEach((a) => a.addEventListener('click', (e) => { e.preventDefault(); openPerson(a.dataset.cid); }));
    main.querySelectorAll('[data-rec]').forEach((a) => a.addEventListener('click', () => openPerson(a.dataset.rec, 'custody')));
    main.querySelectorAll('[data-plate]').forEach((a) => a.addEventListener('click', (e) => { e.preventDefault(); go('vehicle', { plate: a.dataset.plate }); }));
    main.querySelectorAll('[data-iid]').forEach((b) => b.addEventListener('click', () => go('interview', { interviewId: b.dataset.iid, returnTo: 'incident' })));
    main.querySelectorAll('[data-book]').forEach((b) => b.addEventListener('click', () => go('person', { cid: b.dataset.book, tab: 'custody', profile: null, pendingCustody: id })));
    const ri = $('#reqInj'); if (ri) ri.addEventListener('click', () => injuryRequestModal(i, d.people));
}

function injuryRequestModal(incident, people) {
    if (!people.length) { toast('Link the injured person to this incident first.', true); return; }
    openModal(`<h1>Request injury statement</h1><p class="muted">${esc(incident.ref)}. Ambulance clinicians on duty are notified. You will see their statement here, not their medical record.</p>
        <label for="ijP">Person</label><select id="ijP">${people.map((l) => `<option value="${esc(l.subject_id)}">${esc(l.label)} (${esc(l.role || 'Involved')})</option>`).join('')}</select>
        <label for="ijN">What do you need?</label><textarea id="ijN" placeholder="e.g. Assault on Legion Square, need a description of facial injuries for charging"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="ijGo">Send request</button></div>`, (m) => {
        m.querySelector('#ijGo').addEventListener('click', async () => {
            const r = await api('requestInjury', { incidentId: incident.id, cid: m.querySelector('#ijP').value, notes: m.querySelector('#ijN').value });
            if (r.ok) { closeModal(); toast('Request sent to the ambulance service.'); viewIncident(); }
        });
    });
}

function linkModal(incidentId, kind) {
    const cfg = state.cfg;
    if (kind === 'vehicle') {
        openModal(`<h1>Link vehicle</h1><label for="lPlate">Registration</label><div class="suggest-wrap"><input id="lPlate" autocomplete="off" style="text-transform:uppercase"><div class="suggest hidden" id="lSuggest"></div></div>
            <label for="lRole">Involvement</label><select id="lRole">${['Involved', 'Suspect', 'Victim'].map((r) => `<option>${r}</option>`).join('')}</select>
            <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="lSave">Link vehicle</button></div>`, (m) => {
            plateSuggest(m.querySelector('#lPlate'), m.querySelector('#lSuggest'));
            m.querySelector('#lSave').addEventListener('click', async () => {
                const r = await api('linkIncident', { incidentId, kind: 'vehicle', id: m.querySelector('#lPlate').value.trim().toUpperCase(), role: m.querySelector('#lRole').value });
                if (r.ok) { closeModal(); viewIncident(); }
            });
        });
        return;
    }
    openModal(`<h1>Link person</h1>
        <label for="lName">Name or PNC ID</label>
        <input id="lName" autocomplete="off" placeholder="Start typing a name, e.g. james smith">
        <label for="lRole">Role</label><select id="lRole">${cfg.incidentRoles.map((r) => `<option>${esc(r)}</option>`).join('')}</select>
        <div id="lResults" style="margin-top:14px"></div>
        <div class="actions"><button class="btn" data-close>Cancel</button></div>`, (m) => {
        const host = m.querySelector('#lResults');
        const input = m.querySelector('#lName');
        const draw = (title, list, emptyText) => {
            host.innerHTML = `<h2 style="margin-bottom:8px">${title}</h2>` + (list.length ? `<table>${list.map((p) => `<tr>
                <td class="strong">${esc(fullName(p))} ${p.online ? '<span class="chip online">In city</span>' : ''}</td>
                <td>${p.distance !== undefined ? `${p.distance} m away` : esc(ukDate(p.dob))}</td><td class="muted">${esc(p.cid)}</td>
                <td style="text-align:right"><button class="btn tiny" data-pick="${esc(p.cid)}">Link</button></td></tr>`).join('')}</table>` : `<p class="muted">${emptyText}</p>`);
            host.querySelectorAll('[data-pick]').forEach((b) => b.addEventListener('click', async () => {
                const r = await api('linkIncident', { incidentId, kind: 'person', id: b.dataset.pick, role: m.querySelector('#lRole').value });
                if (r.ok) { closeModal(); viewIncident(); }
            }));
        };
        const nearby = async () => {
            const d = await api('nearbyPeople');
            if (!d.error) draw('People near you', d.results, 'Nobody else is in the city.');
        };
        let timer, seq = 0;
        const search = async () => {
            const q = input.value.trim();
            if (q.length < 2) { nearby(); return; }
            const mine = ++seq;
            const d = await fetch(`https://${RES}/request`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ action: 'searchPeople', data: { q, quick: true } }) })
                .then((r) => r.json()).catch(() => ({ error: 'network' }));
            if (mine !== seq || d.error) return;
            draw(`Results for "${esc(q)}"`, d.results, 'No matches. Try just the surname, or check the spelling.');
        };
        input.addEventListener('input', () => { clearTimeout(timer); timer = setTimeout(search, 300); });
        input.addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); clearTimeout(timer); search(); } });
        nearby();
    });
}

function evidenceModal(incident, people) {
    const cfg = state.cfg;
    openModal(`<h1>Add exhibit</h1><p class="muted">${esc(incident.ref)}. An exhibit reference is given in your initials.</p>
        <div class="two">
            <div><label for="eType">Type</label><select id="eType">${cfg.evidenceTypes.map((t) => `<option>${esc(t)}</option>`).join('')}</select></div>
            <div><label for="eStatus">Status</label><select id="eStatus">${cfg.evidenceStatuses.map((t) => `<option>${esc(t)}</option>`).join('')}</select></div>
        </div>
        <label for="eDesc">Description</label><input id="eDesc" placeholder="e.g. Black flick knife, 8cm blade">
        <div class="two">
            <div><label for="eFrom">Seized from</label><select id="eFrom"><option value="">Nobody / found</option>${people.map((p) => `<option value="${esc(p.subject_id)}">${esc(p.label)}</option>`).join('')}</select></div>
            <div><label for="eAt">Found at</label><input id="eAt" placeholder="e.g. Driver's footwell"></div>
        </div>
        <label for="ePhoto">Photo link (optional)</label><input id="ePhoto" placeholder="https://">
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="eSave">Add exhibit</button></div>`, (m) => {
        m.querySelector('#eSave').addEventListener('click', async () => {
            const r = await api('addEvidence', {
                incidentId: incident.id, type: m.querySelector('#eType').value, status: m.querySelector('#eStatus').value,
                description: m.querySelector('#eDesc').value, seizedFrom: m.querySelector('#eFrom').value || null,
                foundAt: m.querySelector('#eAt').value, photo: m.querySelector('#ePhoto').value,
            });
            if (!r.ok) return;
            closeModal(); toast(`Exhibit ${r.ref} recorded.`); viewIncident();
        });
    });
}

function moveEvidenceModal(e) {
    openModal(`<h1>Update exhibit ${esc(e.exhibit_ref)}</h1><p class="muted">${esc(e.description)}</p>
        <label for="mvS">Now</label><select id="mvS">${state.cfg.evidenceStatuses.map((s) => `<option ${s === e.status ? 'selected' : ''}>${esc(s)}</option>`).join('')}</select>
        <label for="mvN">Continuity note</label><input id="mvN" placeholder="e.g. Booked into Mission Row property store, bag M00451">
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="mvSave">Update exhibit</button></div>`, (m) => {
        m.querySelector('#mvSave').addEventListener('click', async () => {
            const r = await api('moveEvidence', { id: e.id, status: m.querySelector('#mvS').value, note: m.querySelector('#mvN').value });
            if (r.ok) { closeModal(); viewIncident(); }
        });
    });
}

/* ---------- forensics ---------- */
function forensicBox(e) {
    const f = e.forensic || {}, r = e.lab_result;
    let body;
    if (e.lab_status === 'at_lab') body = `${pill('At the lab', 'amber')} <span class="muted">results due ${fmtTime(e.lab_due)}</span>`;
    else if (e.lab_status === 'complete' && r) {
        const lines = [];
        if (r.kind === 'print') {
            if (r.match) lines.push(`Fingerprint match: <a href="#" data-cid="${esc(r.match.cid)}" style="color:#9CC3FF">${esc(r.match.name)}</a>${r.lateMatch ? ' <span class="muted">(database hit after testing)</span>' : ''}`);
            else if (r.noMatch) lines.push(`Prints <b>${esc(r.printRef)}</b>: no match on the database yet. They will match when the person is printed.`);
            else lines.push('No usable prints.');
        }
        if (r.kind === 'casing') lines.push(`<b>${esc(r.weapon || 'Firearm')}</b>${r.serial ? `, fired from serial <b>${esc(r.serial)}</b>` : ', no serial recovered'}`);
        if (r.kind !== 'print' && r.match) lines.push(`DNA match: <a href="#" data-cid="${esc(r.match.cid)}" style="color:#9CC3FF">${esc(r.match.name)}</a>${r.lateMatch ? ' <span class="muted">(database hit after testing)</span>' : ''}`);
        else if (r.kind !== 'print' && r.noMatch) lines.push(`DNA profile <b>${esc(r.profile)}</b>: no match on the database yet. It will match when they are sampled.`);
        else if (r.kind === 'blood') lines.push('No usable DNA.');
        if ((r.otherScenes || []).length) lines.push(`Same weapon fired at: ${r.otherScenes.map(esc).join(', ')}`);
        if ((r.seizedWeapons || []).length) lines.push(`Matches seized weapon: ${r.seizedWeapons.map(esc).join(', ')}`);
        body = lines.map((l) => `<div>${l}</div>`).join('');
    } else body = `<span class="muted">Not tested yet${f.collectedBy ? `. Collected by ${esc(f.collectedBy)}` : ''}.</span>`;
    return `<div class="forensic-box"><span class="muted" style="font-size:11px;text-transform:uppercase;letter-spacing:.04em">${f.kind === 'casing' ? 'Ballistics' : f.kind === 'print' ? 'Fingerprints' : 'DNA'}</span>${body}</div>`;
}

async function bagSamplesModal(incident) {
    const d = await api('mySamples');
    if (d.error) return;
    openModal(`<h1>Bag forensic samples</h1><p class="muted">Samples you collected at scenes with <b>/forensics</b> (or a torch), and prints you lifted from vehicles. Each one becomes an exhibit on ${esc(incident.ref)}.</p>
        ${d.results.length ? `<div class="offence-list">${d.results.map((t) => `<label class="check"><input type="checkbox" data-sample="${t.id}" checked>
            <span><b>${t.type === 'casing' ? `Shell casing (${esc(t.weapon || 'unknown')})` : t.type === 'print' ? `Fingerprint lift (${esc(t.weapon || 'vehicle')})` : 'Blood swab'}</b><br><span class="muted">${esc(t.location || '')} · ${fmtTime(t.collected_at)}</span></span></label>`).join('')}</div>`
            : '<p class="empty">You have no unbagged samples. Collect them at the scene first.</p>'}
        <div class="actions"><button class="btn" data-close>Cancel</button>${d.results.length ? '<button class="btn primary" id="bsGo">Bag on this incident</button>' : ''}</div>`, (m) => {
        m.querySelector('#bsGo')?.addEventListener('click', async () => {
            const ids = [...m.querySelectorAll('[data-sample]:checked')].map((c) => c.dataset.sample);
            const r = await api('bagSamples', { incidentId: incident.id, ids });
            if (r.ok) { closeModal(); toast(`Bagged as ${r.refs.join(', ')}. Send them to the lab from the exhibit.`); viewIncident(); }
        });
    });
}

/* ---------- evidence storage ---------- */
function exhibitTable(list, showIncident = true) {
    if (!list.length) return '<p class="empty" style="padding:14px">No exhibits.</p>';
    return `<div class="table-wrap"><table><tr><th>Exhibit</th>${showIncident ? '<th>Incident</th>' : ''}<th>Description</th><th>In the bag</th><th>Link</th><th>Status</th></tr>
        ${list.map((e) => `<tr ${showIncident ? `class="click" data-inc="${e.incident_id}"` : ''}><td class="strong">${esc(e.exhibit_ref)}<br><span class="muted">${fmtDate(e.created_at, false)}</span></td>
        ${showIncident ? `<td>${esc(e.incident_ref || '')}</td>` : ''}
        <td>${esc(e.type)}: ${esc(e.description)}${e.lab_result && e.lab_result.match ? `<br><span class="chip ok">${e.lab_result.kind === 'print' ? 'Fingerprint' : 'DNA'} match: ${esc(e.lab_result.match.name)}</span>` : ''}${e.lab_result && e.lab_result.serial ? `<br><span class="muted">Serial ${esc(e.lab_result.serial)}</span>` : ''}${e.lab_status === 'at_lab' ? '<br><span class="muted">At the lab</span>' : ''}</td>
        <td>${e.bag ? (e.bag.length ? e.bag.map((it) => `${esc(it.count)}x ${esc(it.label)}`).join('<br>') : '<span class="muted">Empty</span>') : '<span class="muted">Not bagged</span>'}</td>
        <td>${[e.seized_from_name ? `Seized from ${esc(e.seized_from_name)}` : '', e.suspect_name && e.suspect_name !== e.seized_from_name ? `Suspect ${esc(e.suspect_name)}` : ''].filter(Boolean).join('<br>') || '<span class="muted">-</span>'}</td>
        <td>${pill(e.status, ['Returned to owner', 'Destroyed'].includes(e.status) ? 'green' : e.status === 'Sent for forensics' ? 'amber' : 'blue')}</td></tr>`).join('')}</table></div>`;
}
function tabEvidence(body, d) {
    body.innerHTML = `<p class="muted" style="margin-bottom:10px">Exhibits seized from this person or linked to them as a suspect.</p><div class="panel flush">${exhibitTable(d.evidence || [])}</div>`;
    body.querySelectorAll('[data-inc]').forEach((r) => r.addEventListener('click', () => go('incident', { incidentId: r.dataset.inc })));
}

async function openEvidenceBag(id) {
    try {
        const r = await fetch(`https://${RES}/openEvidence`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ id }) }).then((x) => x.json());
        if (r.error) toast(r.error, true);
    } catch (e) { toast('Could not open the evidence bag.', true); }
}

// Pick the suspect, tick what to take from their inventory, and it goes into a new exhibit bag.
function seizeModal(incident, people) {
    const cfg = state.cfg;
    const suspects = people.filter((p) => p.role === 'Suspect');
    const list = suspects.length ? suspects : people;
    openModal(`<h1>Seize from suspect</h1><p class="muted">${esc(incident.ref)}. Items move from their inventory into a sealed evidence bag linked to them.</p>
        <label for="szWho">Person</label>
        <select id="szWho">${list.map((p) => `<option value="${esc(p.subject_id)}">${esc(p.label)} (${esc(p.role || '')})</option>`).join('') || '<option value="">Link the suspect to the incident first</option>'}</select>
        <div class="actions" style="justify-content:flex-start;margin-top:10px"><button class="btn small" id="szLoad">${icon('search')}Search their pockets</button></div>
        <div id="szItems" style="margin-top:10px"></div>
        <div class="two">
            <div><label for="szType">Exhibit type</label><select id="szType">${cfg.evidenceTypes.map((t) => `<option>${esc(t)}</option>`).join('')}</select></div>
            <div><label for="szAt">Found at</label><input id="szAt" placeholder="e.g. Left jacket pocket"></div>
        </div>
        <label for="szDesc">Description (optional)</label><input id="szDesc" placeholder="Left blank, it lists the items">
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="szGo" disabled>Seize into evidence</button></div>`, (m) => {
        const host = m.querySelector('#szItems'), goBtn = m.querySelector('#szGo');
        m.querySelector('#szLoad').addEventListener('click', async () => {
            const cid = m.querySelector('#szWho').value;
            if (!cid) return;
            const r = await api('evidenceInventory', { cid });
            if (r.error) return;
            host.innerHTML = r.items.length ? `<div class="offence-list">${r.items.map((it) => `<label class="check">
                <input type="checkbox" data-slot="${it.slot}"><span><b>${esc(it.label)}</b>${it.serial ? ` <span class="muted">#${esc(it.serial)}</span>` : ''}</span>
                <input type="number" min="1" max="${it.count}" value="${it.count}" data-count="${it.slot}" style="width:70px;padding:4px 6px" aria-label="How many"> <span class="amt">of ${it.count}</span></label>`).join('')}</div>`
                : '<p class="muted">Nothing on them.</p>';
            const sync = () => { goBtn.disabled = !host.querySelector('[data-slot]:checked'); };
            host.querySelectorAll('[data-slot]').forEach((c) => c.addEventListener('change', sync));
            sync();
        });
        goBtn.addEventListener('click', async () => {
            const items = [...host.querySelectorAll('[data-slot]:checked')].map((c) => ({ slot: +c.dataset.slot, count: +host.querySelector(`[data-count="${c.dataset.slot}"]`).value }));
            const r = await api('seizeItems', { incidentId: incident.id, cid: m.querySelector('#szWho').value, items,
                type: m.querySelector('#szType').value, foundAt: m.querySelector('#szAt').value, description: m.querySelector('#szDesc').value });
            if (!r.ok) return;
            closeModal(); toast(`Exhibit ${r.ref}: ${r.moved.join(', ')} seized.`); viewIncident();
        });
    });
}

function linkSuspectModal(e, people) {
    openModal(`<h1>Link ${esc(e.exhibit_ref)} to a suspect</h1><p class="muted">${esc(e.description)}</p>
        <label for="lsWho">Suspect</label>
        <select id="lsWho"><option value="">Nobody (remove the link)</option>${people.map((p) => `<option value="${esc(p.subject_id)}" ${p.subject_id === e.suspect_cid ? 'selected' : ''}>${esc(p.label)} (${esc(p.role || '')})</option>`).join('')}</select>
        <p class="muted" style="font-size:12px;margin-top:6px">Only people linked to this incident are listed. The exhibit then shows on their record and in their CPS file.</p>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="lsGo">Save</button></div>`, (m) => {
        m.querySelector('#lsGo').addEventListener('click', async () => {
            const r = await api('evidenceLinkSuspect', { id: e.id, cid: m.querySelector('#lsWho').value || null });
            if (r.ok) { closeModal(); toast('Exhibit linked.'); viewIncident(); }
        });
    });
}

/* ---------- custody ---------- */
function viewCustody() {
    const f = state.custodyFilter || 'in';
    main.innerHTML = pageHead('Custody', 'Everyone booked in, and the outcome of each custody record') + `
        <div class="filters" id="cusF"><button data-f="in">In custody</button><button data-f="all">All records</button></div>
        <div class="panel flush" id="cusList"></div>`;
    main.querySelectorAll('#cusF button').forEach((b) => {
        b.classList.toggle('active', b.dataset.f === f);
        b.addEventListener('click', () => { state.custodyFilter = b.dataset.f; viewCustody(); });
    });
    loadCustodyInto($('#cusList'), f, 60);
}

async function loadCustodyInto(el, filter, limit) {
    const d = await api('custodyList', { filter });
    if (d.error || !el) return;
    const rows = d.results.slice(0, limit);
    el.innerHTML = rows.length ? `<div class="table-wrap"><table><tr><th>Name</th><th>DOB</th><th>Arrested for</th><th>Arrested by</th><th>Time</th><th>Custody clock</th><th>Status</th></tr>
        ${rows.map((r) => `<tr class="click" data-cid="${esc(r.cid)}"><td class="strong">${esc(r.subject_name)}<br><span class="muted">${esc(r.ref || '')}</span></td>
        <td>${esc(ukDate(r.dob))}</td><td>${esc(truncate((r.offences || [])[0], 50))}${(r.offences || []).length > 1 ? ` <span class="muted">+${r.offences.length - 1}</span>` : ''}</td>
        <td>${esc(r.officer_name || '')}</td><td>${fmtDate(r.created_at)}</td><td>${r.clock ? clockPill(r.clock) : '<span class="muted">-</span>'}</td><td>${outcomePill(r.outcome)}</td></tr>`).join('')}</table></div>`
        : `<p class="empty" style="padding:14px">${filter === 'in' ? 'Nobody is in custody.' : 'No custody records yet.'}</p>`;
    el.querySelectorAll('[data-cid]').forEach((r) => r.addEventListener('click', () => openPerson(r.dataset.cid, 'custody')));
}

function outcomeModal(rec) {
    const outs = state.cfg.outcomes.slice(1);
    openModal(`<h1>Record outcome</h1><p class="muted">${esc(rec.subject_name)}, ${esc(rec.ref)}</p>
        <label for="oSel">Outcome</label><select id="oSel">${outs.map((o) => `<option>${esc(o)}</option>`).join('')}</select>
        ${state.cfg.prison ? `<div id="oRemand" class="hidden"><p class="muted" style="margin-top:10px">Sends them to ${esc(state.cfg.prison)} on remand until court.</p>
            <label for="oMin">Remand length (minutes)</label><input id="oMin" type="number" min="1" value="${esc(String(state.cfg.remandMinutes || 60))}"></div>` : ''}
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="oSave">Save outcome</button></div>`, (m) => {
        const sel = m.querySelector('#oSel');
        const syncRemand = () => m.querySelector('#oRemand')?.classList.toggle('hidden', sel.value !== 'Remanded in custody');
        sel.addEventListener('change', syncRemand); syncRemand();
        m.querySelector('#oSave').addEventListener('click', async () => {
            const o = m.querySelector('#oSel').value;
            if (o === 'Released on bail' || o === 'Released under investigation') { closeModal(); bailModal(rec, o === 'Released under investigation' ? 'rui' : null); return; }
            if (o === 'No further action') { closeModal(); nfaModal('This ends the case and tells them if they are in the city.', (reason) => api('nfa', { recordId: rec.id, reason })); return; }
            const r = await api('setOutcome', { id: rec.id, outcome: o, minutes: m.querySelector('#oMin') ? m.querySelector('#oMin').value : null });
            if (r.ok) { closeModal(); toast(r.prison ? `Remanded. ${r.prison}` : 'Outcome saved.'); viewPerson(); }
        });
    });
}

/* ---------- intelligence ---------- */
function viewIntel() {
    main.innerHTML = pageHead('Intelligence', 'Graded intelligence on people, vehicles and places (3x5x2)', `<button class="btn primary" id="newIntel">${icon('plus')}Submit intelligence</button>`) + `
        <form class="panel" id="intF"><div class="form-row" style="grid-template-columns:minmax(0,1fr) auto"><div><label for="intQ">Search</label>
        <input id="intQ" placeholder="Name, registration or keyword" value="${esc(state.intelQ || '')}"></div><button class="btn primary wide">${icon('search')}Search</button></div></form>
        <div class="panel flush section" id="intList"></div>`;
    $('#newIntel').addEventListener('click', () => intelModal({ kind: 'general' }));
    $('#intF').addEventListener('submit', (e) => { e.preventDefault(); state.intelQ = $('#intQ').value; loadIntel(); });
    loadIntel();
}
async function loadIntel() {
    const d = await api('searchIntel', { q: state.intelQ || null });
    const el = $('#intList');
    if (d.error || !el) return;
    el.innerHTML = intelTable(d.results, true);
    el.querySelectorAll('[data-subject]').forEach((r) => r.addEventListener('click', () => {
        if (r.dataset.subject === 'person') openPerson(r.dataset.sid, 'intel');
        else if (r.dataset.subject === 'vehicle') go('vehicle', { plate: r.dataset.sid });
    }));
}

function intelModal(subject) {
    const g = state.cfg.intel;
    const opts = (list, def) => list.map((x) => `<option value="${x.id}" ${x.id === def ? 'selected' : ''}>${esc(x.label)}</option>`).join('');
    openModal(`<h1>Submit intelligence</h1>
        ${subject.kind === 'general' ? `<div class="two"><div><label for="inKind">About</label><select id="inKind"><option value="general">A place or topic</option><option value="person">A person (PNC ID)</option><option value="vehicle">A vehicle (VRM)</option></select></div>
            <div><label for="inId">Reference or subject</label><input id="inId" placeholder="e.g. Grove Street"></div></div>` : `<p class="muted">About ${esc(subject.label)}</p>`}
        <div class="three">
            <div><label for="inS">Source</label><select id="inS">${opts(g.source, '2')}</select></div>
            <div><label for="inA">Intelligence</label><select id="inA">${opts(g.assessment, 'C')}</select></div>
            <div><label for="inH">Handling</label><select id="inH">${opts(g.handling, 'P')}</select></div>
        </div>
        <label for="inT">Intelligence</label><textarea id="inT" placeholder="What is known, when and how. Keep source details out."></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="inSave">Submit intelligence</button></div>`, (m) => {
        m.querySelector('#inSave').addEventListener('click', async () => {
            let kind = subject.kind, id = subject.id, label = subject.label;
            if (kind === 'general') {
                kind = m.querySelector('#inKind').value;
                const v = m.querySelector('#inId').value.trim();
                if (kind === 'general') { id = null; label = v || 'General'; } else { id = kind === 'vehicle' ? v.toUpperCase() : v; label = id; }
            }
            const r = await api('addIntel', { kind, id, label, source: m.querySelector('#inS').value, assessment: m.querySelector('#inA').value, handling: m.querySelector('#inH').value, text: m.querySelector('#inT').value });
            if (!r.ok) return;
            closeModal(); toast('Intelligence submitted.'); render();
        });
    });
}

/* ---------- warrants ---------- */
const warrantLabel = (id) => ((state.cfg.warrantTypes || []).find((w) => w.id === id) || { label: id }).label;
function warrantTable(list) {
    if (!list.length) return '<p class="empty" style="padding:14px">No warrants.</p>';
    return `<div class="table-wrap"><table><tr><th>Type</th><th>Subject</th><th>Grounds</th><th>Recorded by</th><th>Status</th><th></th></tr>
        ${list.map((w) => `<tr><td class="strong">${esc(warrantLabel(w.type))}<br><span class="muted">${fmtDate(w.created_at, false)}</span></td>
        <td>${w.cid ? `<a href="#" data-cid="${esc(w.cid)}" style="color:#9CC3FF">${esc(w.subject_name || w.cid)}</a>` : ''}${w.address ? `<br>${esc(w.address)}` : ''}</td>
        <td>${esc(truncate(w.reason, 90))}</td><td>${esc(w.issued_by || '')}</td>
        <td>${w.status === 'active' ? pill('Active', 'red') : pill(w.status, w.status === 'executed' ? 'green' : '')}</td>
        <td style="text-align:right;white-space:nowrap">${w.status === 'active' ? `<button class="btn tiny" data-wx="${w.id}">Executed</button> <button class="btn tiny" data-wc="${w.id}">Cancel</button>` : ''}</td></tr>`).join('')}</table></div>`;
}
function bindWarrantActions(el, after) {
    el.querySelectorAll('[data-wx]').forEach((b) => b.addEventListener('click', async () => { const r = await api('closeWarrant', { id: b.dataset.wx, status: 'executed' }); if (r.ok) { toast('Warrant executed.'); after(); } }));
    el.querySelectorAll('[data-wc]').forEach((b) => b.addEventListener('click', () => confirmModal('Cancel this warrant?', async () => { const r = await api('closeWarrant', { id: b.dataset.wc, status: 'cancelled' }); if (r.ok) { toast('Warrant cancelled.'); after(); } })));
    el.querySelectorAll('[data-cid]').forEach((a) => a.addEventListener('click', (e) => { e.preventDefault(); openPerson(a.dataset.cid); }));
}
function viewWarrants() {
    const f = state.warrantFilter || 'active';
    main.innerHTML = pageHead('Warrants', 'Arrest and search warrants on the system', `<button class="btn primary" id="newW">${icon('plus')}Record warrant</button>`) + `
        <div class="filters" id="wF"><button data-f="active">Active</button><button data-f="closed">Executed or cancelled</button></div>
        <div class="panel flush" id="wList"></div>`;
    main.querySelectorAll('#wF button').forEach((b) => {
        b.classList.toggle('active', b.dataset.f === f);
        b.addEventListener('click', () => { state.warrantFilter = b.dataset.f; viewWarrants(); });
    });
    $('#newW').addEventListener('click', () => warrantModal({}));
    (async () => {
        const d = await api('listWarrants', { status: f });
        const el = $('#wList');
        if (d.error || !el) return;
        el.innerHTML = warrantTable(d.results);
        bindWarrantActions(el, viewWarrants);
    })();
}
function warrantModal(subject) {
    const types = state.cfg.warrantTypes;
    openModal(`<h1>Record warrant</h1>
        <label for="wT">Type</label><select id="wT">${types.map((t) => `<option value="${t.id}">${esc(t.label)}</option>`).join('')}</select>
        <div class="two"><div><label for="wCid">Person (PNC ID)</label><input id="wCid" value="${esc(subject.cid || '')}" placeholder="Needed for arrest warrants"></div>
        <div><label for="wAddr">Address</label><input id="wAddr" placeholder="Needed for search warrants"></div></div>
        <label for="wR">Grounds</label><textarea id="wR" placeholder="Offence, issuing court, and anything officers need to know"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="wSave">Record warrant</button></div>`, (m) => {
        m.querySelector('#wSave').addEventListener('click', async () => {
            const r = await api('issueWarrant', { type: m.querySelector('#wT').value, cid: m.querySelector('#wCid').value.trim() || null, address: m.querySelector('#wAddr').value, reason: m.querySelector('#wR').value });
            if (!r.ok) return;
            closeModal(); toast('Warrant recorded.'); render();
        });
    });
}

/* ---------- lawful purpose (audit) ---------- */
function setPurpose(p) {
    state.purpose = p;
    const chip = $('#purposeChip');
    if (chip) {
        chip.textContent = p ? `Purpose: ${p}` : 'Set purpose';
        chip.classList.toggle('unset', !p);
    }
}
let purposeWaiters = null;
let purposeCancel = null;   // lets Escape / closing the modal answer "no reason"

function askPurpose(change = false) {
    if (purposeWaiters) return new Promise((res) => purposeWaiters.push(res));
    purposeWaiters = [];
    const reasons = (state.cfg.audit && state.cfg.audit.reasons) || [];
    return new Promise((resolve) => {
        const done = (val) => {
            if (!purposeWaiters) return;
            const waiters = purposeWaiters;
            purposeWaiters = null;
            purposeCancel = null;
            closeModal();
            if (val) setPurpose(val);
            resolve(val); waiters.forEach((w) => w(val));
        };
        openModal(`<h1>${change ? 'Change purpose' : 'Reason for this check'}</h1>
            <p class="muted">PNC checks are logged. Choose why you are accessing records; it applies until you close the MDT or change it.</p>
            <div class="purpose-grid">${reasons.map((r) => `<button class="btn ${r === state.purpose ? 'primary' : ''}" data-p="${esc(r)}">${esc(r)}</button>`).join('')}</div>
            <div class="actions"><button class="btn" id="pCancel">Cancel</button></div>`, (m) => {
            m.querySelectorAll('[data-p]').forEach((b) => b.addEventListener('click', () => done(b.dataset.p)));
            m.querySelector('#pCancel').addEventListener('click', () => done(null));
        });
        purposeCancel = () => done(null);
    });
}

/* ---------- custody clock ---------- */
const hrs = (h) => `${Math.floor(h)}h ${pad(Math.round((h % 1) * 60) % 60)}m`;
function clockPill(c) {
    if (c.overLimit) return pill(`${hrs(c.hours)} - over limit`, 'red');
    if (c.reviewOverdue) return pill(`${hrs(c.hours)} - review due`, 'amber');
    return pill(`${hrs(c.hours)} of ${c.limit}h`, 'blue');
}
function clockPanel(r) {
    const c = r.clock, cfg = state.cfg;
    const pct = Math.min(100, (c.hours / c.limit) * 100);
    return `<div class="clock-panel ${c.overLimit ? 'bad' : c.reviewOverdue ? 'warn' : ''}">
        <div class="clock-top"><b>Custody clock</b><span>${hrs(c.hours)} of ${c.limit} hours${c.extension ? ` (extended: ${esc(c.extension.label)})` : ''}</span></div>
        <div class="meter"><i class="${c.overLimit ? 'full' : ''}" style="width:${pct}%"></i></div>
        <div class="clock-meta">
            <span>${c.overLimit ? '<b style="color:#FF6A63">Detention limit reached. Charge, release or extend now.</b>'
                : c.reviewOverdue ? `<b style="color:var(--amber)">Review ${c.reviews.length + 1} is overdue</b> (due at ${c.nextReview}h)`
                : `Next review at ${c.nextReview}h, ${fmtTime(c.reviewDueAt)}`}</span>
            <span class="muted">1 custody hour = ${c.hourLength} min</span>
        </div>
        ${c.reviews.length ? `<ul class="cont">${c.reviews.map((v, i) => `<li>Review ${i + 1}, ${fmtTime(v.at)} by ${esc(v.by)}: ${esc(v.reason)}${v.note ? `. ${esc(v.note)}` : ''}</li>`).join('')}</ul>` : ''}
        <div class="actions" style="margin-top:8px">
            <button class="btn tiny" data-review="${r.id}" ${(cfg.grade || 0) < (cfg.custody.reviewGrade || 0) ? 'disabled title="Inspector or above"' : ''}>Record review</button>
            <button class="btn tiny" data-extend="${r.id}">Extend detention</button>
            ${cfg.mugshot ? `<button class="btn tiny" data-photo="${r.id}">${icon('camera')}Custody photo</button>` : ''}
        </div>
    </div>`;
}
function reviewModal(r) {
    const reasons = state.cfg.custody.reviewReasons;
    openModal(`<h1>Review of detention</h1><p class="muted">${esc(r.subject_name || '')}, ${esc(r.ref)}. ${hrs(r.clock.hours)} in custody.</p>
        <label for="rvR">Detention continues because</label><select id="rvR">${reasons.map((x) => `<option>${esc(x)}</option>`).join('')}</select>
        <label for="rvN">Notes, including any representations from the detainee or solicitor</label><textarea id="rvN"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="rvSave">Authorise continued detention</button></div>`, (m) => {
        m.querySelector('#rvSave').addEventListener('click', async () => {
            const res = await api('custodyReview', { id: r.id, reason: m.querySelector('#rvR').value, note: m.querySelector('#rvN').value });
            if (res.ok) { closeModal(); toast('Review recorded.'); render(); }
        });
    });
}
function extendDetentionModal(r) {
    const exts = state.cfg.custody.extensions.filter((e) => e.hours > r.clock.limit);
    if (!exts.length) { toast('Detention cannot be extended any further.', true); return; }
    openModal(`<h1>Extend detention</h1><p class="muted">${esc(r.subject_name || '')}, ${esc(r.ref)}. Currently a ${r.clock.limit} hour limit.</p>
        <label for="exS">Authority</label><select id="exS">${exts.map((e) => `<option value="${e.id}">${esc(e.label)}</option>`).join('')}</select>
        <label for="exN">Grounds</label><textarea id="exN" placeholder="Indictable offence, investigation conducted diligently and expeditiously, and why more time is needed"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="exSave">Extend</button></div>`, (m) => {
        m.querySelector('#exSave').addEventListener('click', async () => {
            const res = await api('custodyExtend', { id: r.id, extension: m.querySelector('#exS').value, note: m.querySelector('#exN').value });
            if (res.ok) { closeModal(); toast('Detention extended.'); render(); }
        });
    });
}

/* ---------- custody photos ---------- */
async function takeMugshot(cid, recordId) {
    toast('Taking custody photo. Keep still.');
    try {
        const r = await fetch(`https://${RES}/mugshot`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ cid, recordId: recordId || null }) }).then((x) => x.json());
        if (r.error) { toast(r.error, true); return; }
        toast('Custody photo saved.');
        if (state.view === 'person') viewPerson();
    } catch (e) { toast('The photo failed.', true); }
}
function photosModal(p) {
    openModal(`<h1>Custody photos</h1><p class="muted">${esc(fullName(p))}</p>
        <div class="photo-grid">${p.photos.map((x) => `<figure><div class="mugshot" style="background-image:url('${esc(x.url)}')"></div>
        <figcaption>${fmtDate(x.created_at)}<br>${esc(x.officer_name || '')}</figcaption></figure>`).join('')}</div>
        <div class="actions"><button class="btn" data-close>Close</button></div>`);
}

/* ---------- stop and search ---------- */
const powerLabel = (id) => (((state.cfg.stopSearch && state.cfg.stopSearch.powers) || []).find((p) => p.id === id) || { label: id }).label;
const ssOutcomePill = (o) => pill(o, o === 'Arrest' ? 'red' : o === 'No further action' ? 'green' : 'amber');
function stopSearchTable(list, showName = true) {
    if (!list.length) return '<p class="empty" style="padding:14px">No stop and search records.</p>';
    return `<div class="table-wrap"><table><tr><th>Ref</th>${showName ? '<th>Person</th>' : ''}<th>Power</th><th>Object</th><th>Location</th><th>Officer</th><th>Outcome</th></tr>
        ${list.map((x) => `<tr class="click" data-ss="${x.id}"><td class="strong">${esc(x.ref)}<br><span class="muted">${fmtDate(x.created_at)}</span></td>
        ${showName ? `<td>${x.cid ? esc(x.subject_name) : `<span class="muted">${esc(truncate(x.description, 40))}</span>`}</td>` : ''}
        <td>${esc(truncate(powerLabel(x.power), 34))}</td><td>${esc(x.object)}</td><td>${esc(x.location || '')}</td>
        <td>${esc(x.officer_name || '')}</td><td>${ssOutcomePill(x.outcome)}</td></tr>`).join('')}</table></div>`;
}
function bindStopSearch(el, list) {
    el.querySelectorAll('[data-ss]').forEach((r) => r.addEventListener('click', () => stopSearchView(list.find((x) => String(x.id) === r.dataset.ss))));
}
function stopSearchView(x) {
    openModal(`<h1>${esc(x.ref)}</h1><p class="muted">${fmtDate(x.created_at)}, ${esc(x.officer_name || '')}</p>
        <dl class="kv" style="grid-template-columns:170px 1fr">
            <dt>Person</dt><dd>${x.cid ? esc(x.subject_name) : esc(x.description || 'Not given')}</dd>
            ${x.plate ? `<dt>Vehicle</dt><dd>${vrm(x.plate)}</dd>` : ''}
            <dt>Power</dt><dd>${esc(powerLabel(x.power))}</dd>
            ${x.authorisation ? `<dt>Authorisation</dt><dd>${esc(x.authorisation)}</dd>` : ''}
            <dt>Object of search</dt><dd>${esc(x.object)}</dd>
            <dt>Grounds</dt><dd style="white-space:pre-wrap">${esc(x.grounds || 'Not required for this power')}</dd>
            <dt>Location</dt><dd>${esc(x.location || '')}</dd>
            <dt>Found</dt><dd>${esc(x.found || 'Nothing')}</dd>
            <dt>Outcome</dt><dd>${ssOutcomePill(x.outcome)}</dd>
            <dt>GOWISELY given</dt><dd>${x.gowisely ? 'Yes' : 'No'}</dd>
            <dt>Record given</dt><dd>${x.receipt ? 'Yes' : 'No, person not in the city'}</dd>
        </dl>
        <div class="actions">${x.cid ? `<button class="btn" id="ssOpen">Open person</button>` : ''}<button class="btn primary" data-close>Close</button></div>`, (m) => {
        m.querySelector('#ssOpen')?.addEventListener('click', () => { closeModal(); openPerson(x.cid, 'stopsearch'); });
    });
}
function viewStopSearch() {
    main.innerHTML = pageHead('Stop and search', 'Searches recorded by officers, with grounds and outcomes', `<button class="btn primary" id="ssNew">${icon('plus')}New stop and search</button>`) +
        '<div class="panel flush" id="ssList"><p class="muted" style="padding:14px">Loading</p></div>';
    $('#ssNew').addEventListener('click', () => stopSearchModal({}));
    (async () => {
        const d = await api('stopSearchList', {});
        const el = $('#ssList');
        if (d.error || !el) return;
        el.innerHTML = stopSearchTable(d.results);
        bindStopSearch(el, d.results);
    })();
}
function tabStopSearch(body, d) {
    body.innerHTML = `<div class="actions" style="margin-bottom:10px"><button class="btn small primary" id="ssNew2">${icon('plus')}Record stop and search</button></div>
        <div class="panel flush">${stopSearchTable(d.stopSearch || [], false)}</div>`;
    $('#ssNew2').addEventListener('click', () => stopSearchModal({ cid: d.person.cid, name: fullName(d.person) }));
    bindStopSearch(body, d.stopSearch || []);
}
async function stopSearchModal(pre) {
    const c = state.cfg.stopSearch;
    const here = await nui('location');
    const near = pre.cid ? { results: [] } : await api('nearbyPeople');
    const GOWISELY = [
        ['G', 'Grounds for the search'], ['O', 'Object of the search'], ['W', 'Warrant card shown (if not in uniform)'],
        ['I', 'Identity of the officer'], ['S', 'Station the officer works from'], ['E', 'Entitlement to a copy of the record'],
        ['L', 'Legal power being used'], ['Y', 'You are detained for the purpose of a search'],
    ];
    openModal(`<h1>Stop and search</h1>
        <label for="ssWho">Person searched</label>
        ${pre.cid ? `<input id="ssWho" value="${esc(pre.name)}" disabled>`
            : `<select id="ssWho"><option value="">Would not give a name / not known</option>${(near.results || []).map((p) => `<option value="${esc(p.cid)}">${esc(fullName(p))} (${p.distance} m)</option>`).join('')}</select>
               <input id="ssDesc" style="margin-top:8px" placeholder="Description if no name: sex, age range, clothing">`}
        <div class="two">
            <div><label for="ssPower">Power</label><select id="ssPower">${c.powers.map((p) => `<option value="${p.id}">${esc(p.label)}</option>`).join('')}</select></div>
            <div><label for="ssObj">Searching for</label><select id="ssObj">${c.objects.map((o) => `<option>${esc(o)}</option>`).join('')}</select></div>
        </div>
        <div id="ssAuthRow" class="hidden"><label for="ssAuth">Authorisation</label><input id="ssAuth" placeholder="Authorising officer, area and times, e.g. Insp 77 Patel, Grove St, 18:00-06:00"></div>
        <div id="ssGroundsRow"><label for="ssGrounds">Reasonable grounds for suspicion</label>
            <textarea id="ssGrounds" placeholder="What you saw, heard or were told that made you suspect they had the item. Not appearance, age or reputation alone."></textarea></div>
        <div class="two">
            <div><label for="ssLoc">Location</label><input id="ssLoc" value="${esc(here.location || '')}"></div>
            <div><label for="ssPlate">Vehicle searched (optional)</label><input id="ssPlate" style="text-transform:uppercase"></div>
        </div>
        <label for="ssFound">Found</label><input id="ssFound" placeholder="Nothing found, or what was found">
        <label for="ssOut">Outcome</label><select id="ssOut">${c.outcomes.map((o) => `<option>${esc(o)}</option>`).join('')}</select>
        <label>GOWISELY: I told them</label>
        <div class="gowisely">${GOWISELY.map(([k, t]) => `<label class="check"><input type="checkbox" data-gw="${k}"><b>${k}</b> ${esc(t)}</label>`).join('')}</div>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="ssSave">Record search</button></div>`, (m) => {
        const power = m.querySelector('#ssPower');
        const sync = () => {
            const p = c.powers.find((x) => x.id === power.value);
            m.querySelector('#ssAuthRow').classList.toggle('hidden', !p.authorisation);
            m.querySelector('#ssGroundsRow').classList.toggle('hidden', !!p.authorisation);
        };
        power.addEventListener('change', sync); sync();
        m.querySelector('#ssSave').addEventListener('click', async () => {
            const needed = [...m.querySelectorAll('[data-gw]')].filter((t) => t.dataset.gw !== 'W');
            if (needed.some((t) => !t.checked)) { toast('Tick each part of GOWISELY you told them.', true); return; }
            const cid = pre.cid || m.querySelector('#ssWho').value || null;
            const outcome = m.querySelector('#ssOut').value;
            const r = await api('stopSearchCreate', {
                cid, description: m.querySelector('#ssDesc') ? m.querySelector('#ssDesc').value : null,
                power: power.value, object: m.querySelector('#ssObj').value, authorisation: m.querySelector('#ssAuth').value,
                grounds: m.querySelector('#ssGrounds').value, location: m.querySelector('#ssLoc').value, coords: here.coords,
                plate: m.querySelector('#ssPlate').value || null, found: m.querySelector('#ssFound').value, outcome, gowisely: true,
            });
            if (!r.ok) return;
            closeModal();
            toast(`${r.ref} recorded.${r.receipt ? ' They have been given a copy.' : ''}`);
            if (outcome === 'Arrest' && cid) go('person', { cid, tab: 'custody', profile: null, pendingCustody: 'new' });
            else render();
        });
    });
}
function showStopSearchNotice(rec, force) {
    const el = $('#bailNotice');
    el.innerHTML = `<h3>${esc(force)}: Record of stop and search</h3>
        <p class="small">${esc(rec.ref)}, ${fmtDate(rec.at)}</p>
        <p>You were searched under <b>${esc(rec.power)}</b> for <b>${esc((rec.object || '').toLowerCase())}</b> by ${esc(rec.officer)}.</p>
        ${rec.grounds ? `<p>Grounds: ${esc(rec.grounds)}</p>` : ''}
        <p>Outcome: ${esc(rec.outcome)}</p>
        <p class="small">You can ask for a copy of this record within 3 months, quoting the reference above.</p>`;
    el.classList.remove('hidden');
    clearTimeout(noticeTimer);
    noticeTimer = setTimeout(() => el.classList.add('hidden'), 25000);
}

/* ---------- audit log ---------- */
function auditTable(rows) {
    if (!rows.length) return '<p class="empty" style="padding:14px">Nothing logged.</p>';
    return `<div class="table-wrap"><table><tr><th>When</th><th>Officer</th><th>Action</th><th>Subject</th><th>Reason</th><th>Detail</th></tr>
        ${rows.map((a) => `<tr><td>${fmtDate(a.created_at)}</td><td class="strong">${esc(a.officer_name || '')}</td><td>${esc(a.action)}</td>
        <td>${esc(a.subject_label || a.subject_id || '')}</td><td>${a.reason ? esc(a.reason) : '<span class="muted">-</span>'}</td><td class="muted">${esc(a.detail || '')}</td></tr>`).join('')}</table></div>`;
}
function viewAudit() {
    const f = state.auditForm || {};
    main.innerHTML = pageHead('Audit log', 'Every PNC check and sensitive change, with the reason given') + `
        <form class="panel" id="auF"><div class="form-row" style="grid-template-columns:repeat(4,minmax(0,1fr))">
            <div><label for="auO">Officer</label><input id="auO" value="${esc(f.officer || '')}" placeholder="Name or callsign"></div>
            <div><label for="auS">Subject</label><input id="auS" value="${esc(f.subject || '')}" placeholder="Name, PNC ID or VRM"></div>
            <div><label for="auFrom">From</label><input id="auFrom" type="date" value="${esc(f.from || '')}"></div>
            <div><label for="auTo">To</label><input id="auTo" type="date" value="${esc(f.to || '')}"></div>
        </div><div class="form-actions"><button class="btn primary wide">${icon('search')}Search</button><button class="btn wide" type="button" id="auClear">${icon('refresh')}Clear</button></div></form>
        <div class="panel flush section" id="auList"><p class="muted" style="padding:14px">Loading</p></div>`;
    $('#auF').addEventListener('submit', (e) => { e.preventDefault(); state.auditForm = { officer: $('#auO').value, subject: $('#auS').value, from: $('#auFrom').value, to: $('#auTo').value }; loadAudit(); });
    $('#auClear').addEventListener('click', () => { state.auditForm = null; viewAudit(); });
    loadAudit();
}
async function loadAudit() {
    const f = state.auditForm || {};
    const day = (v, end) => v ? Math.floor(new Date(`${v}T${end ? '23:59:59' : '00:00:00'}`).getTime() / 1000) : null;
    const d = await api('auditLog', { officer: f.officer, subject: f.subject, from: day(f.from), to: day(f.to, true) });
    const el = $('#auList');
    if (d.error || !el) return;
    el.innerHTML = auditTable(d.results);
}
async function tabAccess(body, d) {
    body.innerHTML = '<p class="muted">Loading</p>';
    const r = await api('auditLog', { subjectType: 'person', subjectId: d.person.cid });
    if (r.error) return;
    body.innerHTML = `<p class="muted" style="margin-bottom:10px">Everyone who has opened this record, and why. Name searches are on the Audit log page.</p><div class="panel flush">${auditTable(r.results)}</div>`;
}

/* ---------- fines and traffic offence reports ---------- */
const cur = (n) => `${(state.cfg.fines && state.cfg.fines.currency) || '£'}${Math.floor(n || 0)}`;
function fineStatusPill(f) {
    if (f.status === 'paid') return pill('Paid', 'green');
    if (f.status === 'cancelled') return pill('Cancelled');
    if (f.status === 'court') return pill('To court', 'blue');
    return f.overdue ? pill('Unpaid - overdue', 'red') : pill('Unpaid', 'amber');
}
function fineTable(list, showName = true) {
    if (!list.length) return '<p class="empty" style="padding:14px">Nothing issued.</p>';
    return `<div class="table-wrap"><table><tr><th>Ref</th>${showName ? '<th>Person</th>' : ''}<th>Offences</th><th>Amount</th><th>Points</th><th>Officer</th><th>Status</th></tr>
        ${list.map((f) => `<tr class="click" data-fine="${f.id}"><td class="strong">${esc(f.ref)}<br><span class="muted">${fmtDate(f.created_at)}</span></td>
        ${showName ? `<td>${esc(f.subject_name)}</td>` : ''}
        <td>${(f.offences || []).map((o) => esc(o.code === 'TOR' ? o.label : `${o.code} ${o.label}`)).join('<br>')}</td>
        <td>${f.type === 'TOR' && f.status === 'court' ? '<span class="muted">Court</span>' : cur(f.amount)}${f.increased ? ' <span class="muted">(+increase)</span>' : ''}</td>
        <td>${f.points || 0}</td><td>${esc(f.officer_name || '')}</td><td>${fineStatusPill(f)}</td></tr>`).join('')}</table></div>`;
}
function bindFines(el, list, after) {
    el.querySelectorAll('[data-fine]').forEach((r) => r.addEventListener('click', () => fineView(list.find((f) => String(f.id) === r.dataset.fine), after)));
}
function fineView(f, after) {
    const sup = state.cfg.officer.supervisor;
    openModal(`<h1>${esc(f.ref)}</h1><p class="muted">${fmtDate(f.created_at)}, ${esc(f.officer_name || '')}</p>
        <dl class="kv" style="grid-template-columns:160px 1fr">
            <dt>Type</dt><dd>${f.type === 'FPN' ? 'Fixed penalty notice' : f.type === 'PND' ? 'Penalty notice for disorder' : 'Traffic offence report'}</dd>
            <dt>Person</dt><dd>${esc(f.subject_name)}</dd>
            ${f.plate ? `<dt>Vehicle</dt><dd>${vrm(f.plate)}</dd>` : ''}
            <dt>Offences</dt><dd>${(f.offences || []).map((o) => `${esc(o.code === 'TOR' ? '' : o.code + ' ')}${esc(o.label)}${o.amount ? ` (${cur(o.amount)}${o.points ? `, ${o.points} pts` : ''})` : ''}`).join('<br>')}</dd>
            <dt>Amount</dt><dd>${f.type === 'TOR' && f.status === 'court' ? 'Decided by the court' : cur(f.amount)}</dd>
            ${f.due_at ? `<dt>Pay by</dt><dd>${fmtDate(f.due_at, false)}${f.overdue ? ' <b style="color:#FF6A63">overdue</b>' : ''}</dd>` : ''}
            ${f.paid_at ? `<dt>Paid</dt><dd>${fmtDate(f.paid_at)}</dd>` : ''}
            <dt>Location</dt><dd>${esc(f.location || '')}</dd>
            ${f.notes ? `<dt>Notes</dt><dd>${esc(f.notes)}</dd>` : ''}
            ${f.court_result ? `<dt>Court / notes</dt><dd style="white-space:pre-wrap">${esc(f.court_result)}</dd>` : ''}
            <dt>Status</dt><dd>${fineStatusPill(f)}</dd>
        </dl>
        <div class="actions">
            ${f.status === 'court' && sup ? '<button class="btn primary" id="fCourt">Record court result</button>' : ''}
            ${['unpaid', 'court'].includes(f.status) && sup ? '<button class="btn danger" id="fCancel">Cancel</button>' : ''}
            <button class="btn" data-close>Close</button></div>`, (m) => {
        m.querySelector('#fCourt')?.addEventListener('click', () => courtResultModal(f, after));
        m.querySelector('#fCancel')?.addEventListener('click', () => {
            closeModal();
            openModal(`<h1>Cancel ${esc(f.ref)}</h1><label for="fcR">Reason</label><input id="fcR">
                <div class="actions"><button class="btn" data-close>Back</button><button class="btn danger" id="fcGo">Cancel it</button></div>`, (m2) => {
                m2.querySelector('#fcGo').addEventListener('click', async () => {
                    const r = await api('cancelFine', { id: f.id, reason: m2.querySelector('#fcR').value });
                    if (r.ok) { closeModal(); toast('Cancelled.'); after && after(); }
                });
            });
        });
    });
}
function courtResultModal(f, after) {
    closeModal();
    openModal(`<h1>Court result</h1><p class="muted">${esc(f.ref)}, ${esc(f.subject_name)}</p>
        <label for="crR">Result</label><textarea id="crR" placeholder="e.g. Guilty plea, Los Santos Magistrates, fined and endorsed"></textarea>
        <div class="two"><div><label for="crA">Fine (${esc((state.cfg.fines || {}).currency || '£')})</label><input id="crA" type="number" min="0" value="0"></div>
        <div><label for="crP">Penalty points</label><input id="crP" type="number" min="0" max="11" value="0"></div></div>
        <label class="check" style="margin-top:12px"><input type="checkbox" id="crB"> Disqualify from driving</label>
        <div id="crBRow" class="hidden"><label for="crD">Days (0 = until further order)</label><input id="crD" type="number" min="0" value="180"></div>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="crSave">Save result</button></div>`, (m) => {
        m.querySelector('#crB').addEventListener('change', (e) => m.querySelector('#crBRow').classList.toggle('hidden', !e.target.checked));
        m.querySelector('#crSave').addEventListener('click', async () => {
            const r = await api('fineCourtResult', { id: f.id, result: m.querySelector('#crR').value, amount: m.querySelector('#crA').value, points: m.querySelector('#crP').value,
                ban: m.querySelector('#crB').checked, banDays: m.querySelector('#crD').value });
            if (!r.ok) return;
            closeModal(); toast(['Court result saved.', ...(r.notes || [])].join(' ')); after && after();
        });
    });
}
function viewFines() {
    const f = state.fineFilter || 'unpaid';
    main.innerHTML = pageHead('Fines and TORs', 'Fixed penalties, penalty notices for disorder and traffic offence reports', `<button class="btn primary" id="fNew">${icon('plus')}Issue</button>`) + `
        <div class="filters" id="fF"><button data-f="unpaid">Unpaid</button><button data-f="court">Awaiting court</button><button data-f="paid">Paid</button><button data-f="">All</button></div>
        <div class="panel flush" id="fList"><p class="muted" style="padding:14px">Loading</p></div>`;
    main.querySelectorAll('#fF button').forEach((b) => {
        b.classList.toggle('active', b.dataset.f === f);
        b.addEventListener('click', () => { state.fineFilter = b.dataset.f; viewFines(); });
    });
    $('#fNew').addEventListener('click', () => fineModal({}));
    (async () => {
        const d = await api('finesList', { status: f || null });
        const el = $('#fList');
        if (d.error || !el) return;
        el.innerHTML = fineTable(d.results);
        bindFines(el, d.results, viewFines);
    })();
}
/* ---------- court (vinewood-moj) ---------- */
function tabCourt(body, d) {
    const c = d.court || {};
    const cases = c.cases || [];
    const caseColour = { sentenced: 'red', acquitted: 'green', discontinued: '', dismissed: 'green', awaiting_trial: 'amber', awaiting_sentence: 'amber', listed: 'amber' };
    body.innerHTML = `
        ${c.finesOwed ? `<p class="muted">Court fines outstanding: <b style="color:var(--amber)">${esc(c.currency || '£')}${Number(c.finesOwed).toLocaleString('en-GB')}</b></p>` : ''}
        <div class="panel flush">${cases.length ? `<div class="table-wrap"><table><tr><th>Case</th><th>Charges</th><th>Status</th><th>Next hearing</th><th>Defence</th></tr>
            ${cases.map((x) => `<tr><td class="strong">${esc(x.ref)}<br><span class="muted">${esc(x.court || '')}</span>${x.custodyRef ? `<br><span class="muted">${esc(x.custodyRef)}</span>` : ''}</td>
            <td>${(x.charges || []).map((ch) => `${esc(ch.offence)}${ch.verdict === 'guilty' ? ' ' + pill('Convicted', 'red') : ch.verdict === 'not_guilty' ? ' ' + pill('Acquitted', 'green') : ch.verdict === 'withdrawn' ? ' ' + pill('Withdrawn') : ''}`).join('<br>')}</td>
            <td>${pill(x.statusLabel || x.status, caseColour[x.status] || '')}<br><span class="muted">${esc(x.custody || '')}</span></td>
            <td>${x.next ? `${esc(x.next.type)}<br><span class="muted">${fmtDate(x.next.at)}, ${esc(x.next.court)}</span>` : '<span class="muted">None</span>'}</td>
            <td>${esc(x.solicitor || '')}</td></tr>`).join('')}</table></div>` : '<p class="empty" style="padding:14px">No court cases.</p>'}</div>
        ${(c.sentences || []).length ? `<h3 style="margin:16px 0 8px">Sentences</h3><div class="panel flush"><div class="table-wrap"><table><tr><th>Date</th><th>Sentence</th><th>Passed by</th></tr>
            ${c.sentences.map((x) => `<tr><td>${fmtDate(x.created_at, false)}</td><td>${esc(x.summary)}</td><td>${x.auto ? 'Auto court' : esc(x.passed_by || '')}</td></tr>`).join('')}</table></div></div>` : ''}
        ${(c.orders || []).length ? `<h3 style="margin:16px 0 8px">Live orders</h3><div class="panel flush"><div class="table-wrap"><table><tr><th>Order</th><th>Requirements</th><th>Unpaid work</th><th>Probation officer</th></tr>
            ${c.orders.map((o) => `<tr><td class="strong">${esc(o.kindLabel || o.kind)}<br><span class="muted">${esc(o.ref || '')}</span></td>
            <td>${(o.requirements || []).map((q) => esc(q.label)).join('<br>') || '<span class="muted">None</span>'}</td>
            <td>${o.hours_required ? `${o.hours_done} / ${o.hours_required} hours` : ''}</td><td>${esc(o.officer_name || 'Not assigned')}</td></tr>`).join('')}</table></div></div>` : ''}`;
}

async function tabFines(body, d) {
    body.innerHTML = '<p class="muted">Loading</p>';
    const r = await api('finesList', { cid: d.person.cid });
    if (r.error) return;
    const owed = r.results.filter((f) => f.status === 'unpaid').reduce((a, f) => a + f.amount, 0);
    body.innerHTML = `<div class="actions" style="margin-bottom:10px;align-items:center"><button class="btn small primary" id="fNew2">${icon('plus')}Issue fine or TOR</button>
        ${owed ? `<span class="muted">Outstanding: <b style="color:var(--amber)">${cur(owed)}</b></span>` : ''}</div><div class="panel flush">${fineTable(r.results, false)}</div>`;
    $('#fNew2').addEventListener('click', () => fineModal({ cid: d.person.cid, name: fullName(d.person) }));
    bindFines(body, r.results, viewPerson);
}
async function fineModal(pre) {
    const c = state.cfg.fines;
    const here = await nui('location');
    const near = pre.cid ? { results: [] } : await api('nearbyPeople');
    openModal(`<h1>Issue fine or traffic offence report</h1>
        <label for="fWho">Person</label>
        ${pre.cid ? `<input id="fWho" value="${esc(pre.name)}" disabled>`
            : `<select id="fWho">${(near.results || []).map((p) => `<option value="${esc(p.cid)}">${esc(fullName(p))} (${p.distance} m)</option>`).join('') || '<option value="">Nobody nearby</option>'}</select>`}
        <label>Type</label>
        <div class="filters" id="fType"><button type="button" data-t="FPN" class="active">Fixed penalty (traffic)</button><button type="button" data-t="PND">Penalty notice for disorder</button><button type="button" data-t="TOR">Report for court (TOR)</button></div>
        <label>Offences</label><div class="offence-list" id="fOff"></div>
        <div id="fOther" class="hidden"><label for="fOt">Other offence for court</label><input id="fOt" placeholder="e.g. Driving without due care, s.3 RTA 1988"></div>
        <div class="two"><div><label for="fLoc">Location</label><input id="fLoc" value="${esc(here.location || '')}"></div>
        <div><label for="fPlate">Vehicle (optional)</label><input id="fPlate" style="text-transform:uppercase" value="${esc(pre.plate || '')}"></div></div>
        <label for="fNotes">Notes</label><input id="fNotes" placeholder="Speed recorded, device, anything the court needs" value="${esc(pre.notes || '')}">
        <div class="fine-total"><span id="fSum" class="muted">Choose offences</span><b id="fAmt"></b></div>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="fSave">Issue</button></div>`, (m) => {
        let type = 'FPN';
        const drawList = () => {
            const list = c.offences.filter((o) => type === 'TOR' || o.type === type);
            m.querySelector('#fOff').innerHTML = list.map((o) => `<label class="check"><input type="checkbox" value="${esc(o.code)}" data-amt="${o.amount}" data-pts="${o.points || 0}">
                <span><b>${esc(o.code)}</b> ${esc(o.label)}</span><span class="amt">${type === 'TOR' ? '' : cur(o.amount)}${o.points ? ` · ${o.points} pts` : ''}</span></label>`).join('');
            m.querySelector('#fOther').classList.toggle('hidden', type !== 'TOR');
            m.querySelectorAll('#fOff input').forEach((i) => i.addEventListener('change', total));
            m.querySelector('#fSave').textContent = type === 'TOR' ? 'Report for court' : 'Issue penalty';
            total();
        };
        const total = () => {
            const picked = [...m.querySelectorAll('#fOff input:checked')];
            const amt = picked.reduce((a, i) => a + +i.dataset.amt, 0), pts = picked.reduce((a, i) => a + +i.dataset.pts, 0);
            m.querySelector('#fSum').textContent = picked.length ? `${picked.length} offence(s)${pts ? `, ${pts} penalty points` : ''}${type !== 'TOR' ? `, pay within ${c.dueDays} days` : ', decided at court'}` : 'Choose offences';
            m.querySelector('#fAmt').textContent = type === 'TOR' ? '' : cur(amt);
        };
        if (pre.location) m.querySelector('#fLoc').value = pre.location;
        m.querySelectorAll('#fType button').forEach((b) => b.addEventListener('click', () => {
            type = b.dataset.t;
            m.querySelectorAll('#fType button').forEach((x) => x.classList.toggle('active', x === b));
            drawList();
        }));
        drawList();
        (pre.codes || []).forEach((code) => { const i = m.querySelector(`#fOff input[value="${code}"]`); if (i) { i.checked = true; } });
        if ((pre.codes || []).length) m.querySelector('#fOff input')?.dispatchEvent(new Event('change'));
        m.querySelector('#fSave').addEventListener('click', async () => {
            const cid = pre.cid || m.querySelector('#fWho').value;
            if (!cid) { toast('Choose the person.', true); return; }
            const r = await api('issueFine', { cid, type, codes: [...m.querySelectorAll('#fOff input:checked')].map((i) => i.value),
                other: m.querySelector('#fOt').value, location: m.querySelector('#fLoc').value, plate: m.querySelector('#fPlate').value || null,
                notes: m.querySelector('#fNotes').value });
            if (!r.ok) return;
            closeModal();
            toast(`${r.ref} issued.${(r.endorsed || []).length ? ' ' + r.endorsed.join('. ') + '.' : ''}`);
            if (pre.onIssued) await pre.onIssued(r);
            render();
        });
    });
}
function showFineNotice(f, force) {
    const el = $('#bailNotice');
    const title = f.type === 'TOR' ? 'Traffic offence report' : f.type === 'PND' ? 'Penalty notice for disorder' : 'Fixed penalty notice';
    el.innerHTML = `<h3>${esc(force)}: ${title}</h3><p class="small">${esc(f.ref)}, issued by ${esc(f.officer)}</p>
        <ul>${(f.offences || []).map((o) => `<li>${esc(o.label)}</li>`).join('')}</ul>
        ${f.type === 'TOR' ? '<p>You have been reported. The case will be decided at court.</p>'
            : `<p>Pay <b>${cur(f.amount)}</b> by ${fmtDate(f.due, false)}${f.points ? `. ${f.points} penalty points have been added to your licence` : ''}.</p>
               <p class="small">Use /${esc(f.command || 'fines')} to pay. Unpaid penalties are registered as a fine and increased.</p>`}`;
    el.classList.remove('hidden');
    clearTimeout(noticeTimer);
    noticeTimer = setTimeout(() => el.classList.add('hidden'), 25000);
}

/* ---------- statements (MG11) ---------- */
const stPill = (s) => pill(s === 'signed' ? 'Signed' : s === 'refused' ? 'Refused to sign' : 'Awaiting signature', s === 'signed' ? 'green' : s === 'refused' ? 'red' : 'amber');
function statementRows(list) {
    if (!list.length) return '<p class="empty">No statements yet.</p>';
    return `<table>${list.map((st) => `<tr class="click" data-st="${st.id}"><td class="strong">${esc(st.maker_name || '')}<br><span class="muted">${esc(st.kind)} statement</span></td>
        <td>${fmtDate(st.created_at)}<br><span class="muted">${esc(st.taken_by || '')}</span></td><td style="text-align:right">${stPill(st.status)}</td></tr>`).join('')}</table>`;
}
function bindStatementRows(el, list) {
    el.querySelectorAll('[data-st]').forEach((r) => r.addEventListener('click', () => statementView(list.find((x) => String(x.id) === r.dataset.st))));
}
async function loadStatements(incidentId) {
    const d = await api('statementsFor', { incidentId });
    const el = $('#stmtList');
    if (d.error || !el) return;
    el.className = '';
    el.innerHTML = statementRows(d.results);
    bindStatementRows(el, d.results);
}
function statementView(st) {
    const decl = (state.cfg.statements || {}).declaration || '';
    openModal(`<div class="form-head"><span>Witness statement (MG11)</span><span>${esc(state.cfg.force.name)}</span></div>
        <h1>${esc(st.maker_name || '')}</h1><p class="muted">${esc(st.kind)} statement${st.occupation ? `, ${esc(st.occupation)}` : ''}. Taken by ${esc(st.taken_by || '')} on ${fmtDate(st.created_at)}.</p>
        <div class="body">${esc(st.body)}</div>
        <div class="decl">${esc(decl)}</div>
        <p style="margin-top:10px">${stPill(st.status)}${st.signed_at ? ` <span class="muted">${fmtDate(st.signed_at)}</span>` : ''}</p>
        <div class="actions">${st.status !== 'signed' && state.cfg.role === 'police' ? '<button class="btn" id="stResend">Send for signature again</button>' : ''}<button class="btn primary" data-close>Close</button></div>`, (m) => {
        m.querySelector('#stResend')?.addEventListener('click', async () => {
            const r = await api('resendStatement', { id: st.id });
            if (r.ok) { closeModal(); toast('Sent for signature.'); }
        });
    });
    $('#modalBody').parentElement.classList.add('mg11');
}
function statementModal(incident, people) {
    const s = state.cfg.statements;
    openModal(`<h1>Take statement</h1><p class="muted">${esc(incident.ref)}</p>
        <div class="two">
            <div><label for="stK">Type</label><select id="stK">${s.kinds.map((k) => `<option>${esc(k)}</option>`).join('')}</select></div>
            <div id="stWhoRow" class="hidden"><label for="stW">Statement of</label><select id="stW">${people.map((p) => `<option value="${esc(p.subject_id)}">${esc(p.label)} (${esc(p.role || '')})</option>`).join('') || '<option value="">Link the person to the incident first</option>'}</select></div>
        </div>
        <label for="stO">Occupation (optional)</label><input id="stO">
        <label for="stB">Statement</label><textarea id="stB" style="min-height:240px" placeholder="In the first person, in their own words: what they saw, heard and did, in order, with times and places."></textarea>
        <p class="muted" style="font-size:12px;margin-top:8px" id="stHint">Officer statements are signed by you when saved.</p>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="stSave">Save statement</button></div>`, (m) => {
        const kind = m.querySelector('#stK');
        const sync = () => {
            const officer = kind.value === 'Officer';
            m.querySelector('#stWhoRow').classList.toggle('hidden', officer);
            m.querySelector('#stHint').textContent = officer ? 'Officer statements are signed by you when saved.' : 'It will be sent to them to read and sign on their screen.';
            m.querySelector('#stSave').textContent = officer ? 'Sign and save' : 'Save and send for signature';
        };
        kind.addEventListener('change', sync); sync();
        m.querySelector('#stSave').addEventListener('click', async () => {
            const r = await api('takeStatement', { incidentId: incident.id, kind: kind.value, makerCid: m.querySelector('#stW').value || null,
                occupation: m.querySelector('#stO').value, body: m.querySelector('#stB').value });
            if (!r.ok) return;
            closeModal();
            toast(r.status === 'signed' ? 'Statement signed and saved.' : r.sent ? 'Statement sent for their signature.' : 'Saved. They are not in the city, so send it for signature later.');
            loadStatements(incident.id);
        });
    });
}
// Shown to the witness: read it, type their name to sign, or refuse.
function showSignStatement(st) {
    const card = $('#signCard');
    card.innerHTML = `<div class="form-head"><span>Witness statement (MG11)</span><span>${esc(st.force)}</span></div>
        <h1>Your ${esc(st.kind.toLowerCase())} statement</h1><p class="muted">Taken by ${esc(st.takenBy)}. Read it carefully before signing.</p>
        <div class="body">${esc(st.body)}</div>
        <div class="decl">${esc(st.declaration)}</div>
        <label for="sgName" style="margin-top:12px">Type your full name to sign</label><input id="sgName" autocomplete="off" placeholder="${esc(st.name)}">
        <div class="actions"><button class="btn" id="sgNo">Refuse to sign</button><button class="btn primary" id="sgYes" disabled>Sign statement</button></div>`;
    $('#signOverlay').classList.remove('hidden');
    const input = $('#sgName'), yes = $('#sgYes');
    const norm = (v) => v.toLowerCase().replace(/\s+/g, ' ').trim();
    input.addEventListener('input', () => { yes.disabled = norm(input.value) !== norm(st.name); });
    const answer = (accept) => {
        $('#signOverlay').classList.add('hidden');
        fetch(`https://${RES}/statementSign`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ id: st.id, accept }) });
    };
    yes.addEventListener('click', () => answer(true));
    $('#sgNo').addEventListener('click', () => answer(false));
    input.focus();
}

/* ---------- sentencing guidance ---------- */
const COURT_LABEL = { summary: 'Magistrates only', either: 'Either way', indictable: 'Crown Court only' };
const COURT_SHORT = { summary: 'Summary', either: 'Either way', indictable: 'Indictable' };
const OOC_LABEL = { cr: 'Community resolution', caution: 'Simple caution', pnd: 'Penalty notice' };

// "s.1 Theft, Theft Act 1968" -> { name, act, guide }
function guideFor(full) {
    for (const a of state.cfg.offences) {
        if (full.endsWith(`, ${a.act}`)) {
            const name = full.slice(0, -(a.act.length + 2));
            return { name, act: a.act, guide: state.cfg.sentencing.Offences[name] || null };
        }
    }
    return { name: full, act: '', guide: state.cfg.sentencing.Offences[full] || null };
}
const jailTxt = (n) => {
    const S = state.cfg.sentencing;
    const v = n >= 2 ? Math.round(n) : Math.round(n * 10) / 10;
    return `${v} ${S.JailUnit || 'months'}${S.MinutesPerUnit && S.MinutesPerUnit !== 1 ? ` (${Math.round(v * S.MinutesPerUnit)} min)` : ''}`;
};
const rangeTxt = (g) => [
    g.fine ? `Fine ${cur(g.fine[0])}–${cur(g.fine[1])}` : '',
    g.community ? 'Community order' : '',
    g.jail && g.jail[1] > 0 ? `Custody ${g.jail[0]}–${g.jail[1]} ${state.cfg.sentencing.JailUnit || 'months'}` : '',
].filter(Boolean).join(' · ') || 'Not imprisonable';

function viewSentencing() {
    const S = state.cfg.sentencing;
    const q = (state.sentQ || '').toLowerCase();
    main.innerHTML = pageHead('Sentencing guide', `What each offence usually gets, from out-of-court disposals to custody. ${esc(S.Notice || '')}`,
        `<button class="btn primary" id="sCalc">${icon('gavel')}Sentencing calculator</button>`) + `
        <form class="panel" id="sF"><div class="form-row" style="grid-template-columns:minmax(0,1fr)"><div><label for="sQ">Find an offence</label>
        <input id="sQ" value="${esc(state.sentQ || '')}" placeholder="e.g. theft, s.47, dangerous driving"></div></div></form>
        <div id="sList" class="section"></div>`;
    const draw = () => {
        const term = ($('#sQ').value || '').toLowerCase();
        state.sentQ = term;
        $('#sList').innerHTML = state.cfg.offences.map((a) => {
            const rows = a.items.filter((o) => !term || `${o} ${a.act}`.toLowerCase().includes(term));
            if (!rows.length) return '';
            return `<div class="panel flush section">${panelHead(esc(a.act))}<div class="table-wrap"><table class="sent-table">
                <colgroup><col style="width:33%"><col style="width:10%"><col style="width:14%"><col style="width:17%"><col><col style="width:28px"></colgroup>
                <tr><th>Offence</th><th>Court</th><th>Maximum</th><th>Out of court</th><th>Guide range</th><th></th></tr>
                ${rows.map((o) => {
                    const g = S.Offences[o];
                    if (!g) return `<tr><td class="strong">${esc(o)}</td><td colspan="5" class="muted">No guidance set. Add it in sentencing.lua.</td></tr>`;
                    const ooc = Object.keys(g.ooc || {}).filter((k) => g.ooc[k]);
                    return `<tr class="click" data-off="${esc(`${o}, ${a.act}`)}"><td class="strong">${esc(o)}${g.notes ? `<br><span class="muted" style="font-weight:400;font-size:12px">${esc(g.notes)}</span>` : ''}</td>
                        <td>${pill(COURT_SHORT[g.court] || g.court, g.court === 'indictable' ? 'red' : g.court === 'either' ? 'amber' : 'blue')}</td>
                        <td>${esc(g.max)}</td>
                        <td>${ooc.length ? `<div class="chips">${ooc.map((k) => `<span class="chip ok">${OOC_LABEL[k]}</span>`).join('')}</div>` : '<span class="muted">Charge</span>'}</td>
                        <td>${esc(rangeTxt(g))}${g.driving ? `<br><span class="muted" style="font-size:12px">${esc(g.driving)}</span>` : ''}</td><td class="go">›</td></tr>`;
                }).join('')}</table></div></div>`;
        }).join('') || '<p class="empty">No offences match.</p>';
        $('#sList').querySelectorAll('[data-off]').forEach((r) => r.addEventListener('click', () => sentencingModal({ offences: [r.dataset.off] })));
    };
    $('#sQ').addEventListener('input', draw);
    $('#sF').addEventListener('submit', (e) => e.preventDefault());
    $('#sCalc').addEventListener('click', () => sentencingModal({ offences: [] }));
    draw();
}

// Works out a suggested disposal from the offences, the person's record and the factors ticked.
async function sentencingModal(opts) {
    const S = state.cfg.sentencing;
    const ctx = opts.cid ? await api('sentencingContext', { cid: opts.cid, recordId: opts.recordId }) : { convictions: 0, cautions: 0 };
    if (ctx.error) return;
    const auto = { previous: ctx.convictions > 0, onbail: !!ctx.onBail, nopcs: ctx.convictions === 0 && !!opts.cid };
    openModal(`<div id="sentForm"><h1>Sentencing guidance</h1>
        <p class="muted">${opts.name ? `${esc(opts.name)}${opts.ref ? `, ${esc(opts.ref)}` : ''}. ` : ''}${opts.cid ? `${ctx.convictions} previous conviction(s)${ctx.fromCourt ? ' from court records' : ''}, ${ctx.cautions} caution(s) or community resolution(s)${ctx.onBail ? ', on bail' : ''}.` : 'Pick the offences and factors.'}</p>
        <label>Offences</label>${offencePicker(opts.offences || [])}
        <div class="two">
            <div><label>Aggravating</label><div class="factor-list">${S.Aggravating.map((f) => `<label class="check"><input type="checkbox" data-agg="${f.id}" ${auto[f.id] ? 'checked' : ''}>${esc(f.label)}${f.id === 'previous' && ctx.convictions ? ` (${ctx.convictions})` : ''}</label>`).join('')}</div></div>
            <div><label>Mitigating</label><div class="factor-list">${S.Mitigating.map((f) => `<label class="check"><input type="checkbox" data-mit="${f.id}" ${auto[f.id] ? 'checked' : ''}>${esc(f.label)}</label>`).join('')}</div></div>
        </div>
        <div class="two">
            <div><label for="sPlea">Plea</label><select id="sPlea">${S.Pleas.map((p) => `<option value="${p.id}">${esc(p.label)}</option>`).join('')}</select></div>
            <div><label>&nbsp;</label><label class="check" style="margin-top:8px"><input type="checkbox" id="sAdmit"> Admitted the offence in interview</label></div>
        </div>
        <div id="sOut" class="sentence-out"></div>
        <p class="muted" style="font-size:12px;margin-top:8px">${esc(S.Notice || '')}</p>
        <div class="actions"><button class="btn primary" data-close>Close</button></div></div>`, (m) => {
        const form = m.querySelector('#sentForm');
        const calc = () => { form.querySelector('#sOut').innerHTML = renderSentence(form, S, ctx); };
        form.addEventListener('change', calc);
        calc();
    });
}

function renderSentence(m, S, ctx) {
    const picked = pickedOffences(m).map(guideFor);
    if (!picked.length) return '<p class="muted">Tick at least one offence.</p>';
    const missing = picked.filter((p) => !p.guide);
    const offs = picked.filter((p) => p.guide);
    if (!offs.length) return '<p class="muted">No guidance is set for these offences yet.</p>';

    const ticked = (attr) => [...m.querySelectorAll(`[${attr}]:checked`)].map((i) => i.getAttribute(attr));
    const aggIds = ticked('data-agg'), mitIds = ticked('data-mit');
    let agg = 0, mit = 0;
    for (const f of S.Aggravating) if (aggIds.includes(f.id)) agg += f.perConviction ? Math.min(f.cap || 1, f.weight * Math.max(1, ctx.convictions || 0)) : f.weight;
    for (const f of S.Mitigating) if (mitIds.includes(f.id)) mit += f.weight;
    const factor = Math.max(0.5, 1 + agg - mit);
    const plea = S.Pleas.find((p) => p.id === m.querySelector('#sPlea').value) || { reduction: 0 };
    const admitted = m.querySelector('#sAdmit').checked;
    const serious = aggIds.some((id) => ['weapon', 'emergency', 'hostility'].includes(id));

    // Out-of-court: every offence has to allow it, it has to be admitted, and no recent convictions.
    const oocKinds = ['cr', 'caution', 'pnd'].filter((k) => offs.every((o) => o.guide.ooc && o.guide.ooc[k]));
    const oocOk = oocKinds.length && admitted && (ctx.convictions || 0) === 0 && !serious && !aggIds.includes('onbail');

    // Custody: lead offence, plus a share of the others (totality), then factors and plea.
    const custodial = offs.filter((o) => o.guide.jail && o.guide.jail[1] > 0);
    const start = (g) => g.jail[0] + (g.jail[1] - g.jail[0]) * 0.4;
    let tier = '', jailLine = '', fineLine = '';
    if (custodial.length) {
        custodial.sort((a, b) => b.guide.jail[1] - a.guide.jail[1]);
        const lead = custodial[0].guide;
        let n = start(lead) + custodial.slice(1).reduce((t, o) => t + start(o.guide) * 0.25, 0);
        n *= factor;
        const ceiling = Math.min(custodial.reduce((t, o) => t + o.guide.jail[1], 0), lead.jail[1] * 1.5);
        n = Math.min(Math.max(n, lead.jail[0]), ceiling);
        const before = n;
        n *= 1 - (plea.reduction || 0);
        const low = Math.max(lead.jail[0] * (1 - (plea.reduction || 0)), n * 0.8), high = n * 1.2;
        const threshold = lead.jail[0] === 0 && n < Math.max(2, lead.jail[1] * 0.15);
        if (threshold) {
            tier = 'Fine or community order';
            jailLine = `Below the custody threshold. If custody were imposed: about ${jailTxt(n)}.`;
        } else if (lead.jail[0] === 0 && n <= 24) {
            tier = 'Custody threshold passed: suspended sentence possible';
            jailLine = `About ${jailTxt(low)} to ${jailTxt(high)}${plea.reduction ? ` (from ${jailTxt(before)} before the plea reduction)` : ''}.`;
        } else {
            tier = 'Immediate custody';
            jailLine = `About ${jailTxt(low)} to ${jailTxt(high)}${plea.reduction ? ` (from ${jailTxt(before)} before the plea reduction)` : ''}.`;
        }
    } else {
        tier = 'Fine';
    }
    const fined = offs.filter((o) => o.guide.fine);
    if (fined.length && (!custodial.length || tier.startsWith('Fine'))) {
        const lo = fined.reduce((t, o) => t + o.guide.fine[0], 0), hi = fined.reduce((t, o) => t + o.guide.fine[1], 0);
        const mid = (lo + (hi - lo) * 0.4) * factor * (1 - (plea.reduction || 0));
        fineLine = `Fine of about ${cur(Math.max(lo, mid * 0.8))} to ${cur(Math.min(hi * 1.5, mid * 1.2))}.`;
    }
    const indictable = offs.some((o) => o.guide.court === 'indictable');
    const driving = offs.filter((o) => o.guide.driving).map((o) => `${o.name}: ${o.guide.driving}`);
    const notes = offs.filter((o) => o.guide.notes).map((o) => `${o.name}: ${o.guide.notes}`);

    return `
        ${oocOk ? `<div class="banner info" style="margin:0 0 10px"><strong>Out-of-court disposal suitable</strong>${oocKinds.map((k) => OOC_LABEL[k]).join(', ')}. Admitted, no previous convictions, no serious aggravation. Charge instead if the victim objects or it is not in the public interest.</div>` : ''}
        <div class="sentence-tier ${tier === 'Immediate custody' ? 'red' : tier.startsWith('Custody') ? 'amber' : 'green'}">
            <span class="muted">${oocOk ? 'If charged' : 'Suggested sentence'}</span><b>${esc(tier)}</b>
            ${jailLine ? `<div>${jailLine}</div>` : ''}${fineLine ? `<div>${fineLine}</div>` : ''}
        </div>
        <dl class="kv" style="grid-template-columns:150px 1fr;margin-top:10px;font-size:14px">
            <dt>Court</dt><dd>${indictable ? 'Crown Court (indictable only)' : offs.some((o) => o.guide.court === 'either') ? 'Magistrates or Crown Court' : 'Magistrates'}</dd>
            <dt>Factors</dt><dd>${agg ? `+${Math.round(agg * 100)}% aggravating` : 'No aggravating'}${mit ? `, −${Math.round(mit * 100)}% mitigating` : ''}</dd>
            <dt>Plea</dt><dd>${plea.reduction ? `${Math.round(plea.reduction * 100)}% reduction` : 'No reduction'}</dd>
            ${driving.length ? `<dt>Driving</dt><dd>${driving.map(esc).join('<br>')}</dd>` : ''}
        </dl>
        ${notes.length ? `<ul class="cont" style="margin-top:8px">${notes.map((n) => `<li>${esc(n)}</li>`).join('')}</ul>` : ''}
        ${missing.length ? `<p class="muted" style="font-size:12px">No guidance set for: ${missing.map((x) => esc(x.name)).join(', ')}.</p>` : ''}`;
}

/* ---------- notes ---------- */
function noteModal(kind, id, label) {
    openModal(`<h1>Add note</h1><p class="muted">${esc(label)}</p><textarea id="ntT" style="min-height:130px" placeholder="What other officers should know"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="ntSave">Add note</button></div>`, (m) => {
        m.querySelector('#ntSave').addEventListener('click', async () => {
            const r = await api('addNote', { kind, id, text: m.querySelector('#ntT').value });
            if (r.ok) { closeModal(); toast('Note added.'); render(); }
        });
    });
}

/* ---------- interviews ---------- */
function viewInterviews() {
    main.innerHTML = pageHead('CCTV / Interviews', 'Recorded interviews by case reference, interviewee or interviewing officer') + `
        <form class="panel" id="is"><div class="form-row" style="grid-template-columns:minmax(0,1fr) auto"><div><label for="iq">Case reference or name</label>
        <input id="iq" autocomplete="off" value="${esc(state.lastInterviewQ || '')}"></div><button class="btn primary wide">${icon('search')}Search</button></div></form>
        <div id="ir" class="section"></div>`;
    $('#is').addEventListener('submit', (e) => { e.preventDefault(); searchInterviews($('#iq').value); });
    searchInterviews(state.lastInterviewQ || '');
}

async function searchInterviews(q) {
    state.lastInterviewQ = q;
    const d = await api('searchInterviews', { q });
    const el = $('#ir');
    if (d.error || !el) return;
    el.innerHTML = d.results.length ? interviewRows(d.results) : '<p class="empty">No interviews match that search.</p>';
    bindInterviewRows(el);
}

async function viewInterview() {
    main.innerHTML = '<p class="muted">Loading interview</p>';
    const d = await api('getInterview', { id: state.interviewId });
    if (d.error) { main.innerHTML = `<p class="empty">${esc(d.error)}</p>`; return; }
    const s = d.interview;
    const back = { person: 'Back to person', cpsCase: 'Back to case file', defenceCase: 'Back to client', incident: 'Back to incident' }[state.returnTo] || 'Back to recordings';
    main.innerHTML = `
        <button class="btn small" id="iBack">${back}</button>
        <h1 style="margin-top:14px">${esc(s.interviewee || 'Interview')}</h1>
        <p class="muted">${esc(s.caseRef || 'No case reference')}, ${esc(s.room || '')}, conducted by ${esc(s.officer || 'unknown')}</p>
        ${s.solicitor ? `<p>Solicitor: ${esc(s.solicitor)}</p>` : ''}
        ${s.notes ? `<p>${esc(s.notes)}</p>` : ''}
        <div id="playerHost" style="margin-top:16px"></div>`;
    $('#iBack').addEventListener('click', () => go(['person', 'cpsCase', 'defenceCase', 'incident'].includes(state.returnTo) ? state.returnTo : 'interviews'));
    state.player = new InterviewPlayer($('#playerHost'), s);
}

function stopPlayer() {
    if (state.player) { state.player.destroy(); state.player = null; }
}

/* Plays every speaker track and the CCTV video against one clock. */
class InterviewPlayer {
    constructor(host, session) {
        this.host = host;
        this.tracks = (session.tracks || []).filter((t) => t.url && t.status !== 'failed');
        this.failed = (session.tracks || []).filter((t) => !t.url || t.status === 'failed');
        this.total = Math.max(session.duration || 0, ...this.tracks.map((t) => t.offset + (t.duration || 0)), 1000);
        this.t = 0; this.playing = false; this.muted = new Set();
        this.speakers = [...new Set([...this.tracks, ...this.failed].filter((t) => t.kind !== 'video').map((t) => t.speaker || 'Unknown'))];
        this.build();
        this.raf = requestAnimationFrame(() => this.loop());
    }

    build() {
        const video = this.tracks.filter((t) => t.kind === 'video');
        if (!this.tracks.length) {
            this.host.innerHTML = '<div class="player"><p class="muted">This interview has no playable recordings. Uploads may still be processing, or they failed.</p></div>';
            return;
        }
        this.host.innerHTML = `<div class="player">
            ${video.length ? '<video id="ipVideo" muted playsinline></video>' : ''}
            <div class="transport">
                <button class="btn primary" id="ipPlay">Play</button>
                <input type="range" id="ipSeek" min="0" max="${this.total}" step="100" value="0" aria-label="Position">
                <span class="time" id="ipTime">00:00 / ${fmtClock(this.total)}</span>
            </div>
            ${this.speakers.map((sp) => `<div class="track" data-speaker="${esc(sp)}">
                <span>${esc(sp)}</span>
                <div class="lane">${[...this.tracks, ...this.failed].filter((t) => t.kind !== 'video' && (t.speaker || 'Unknown') === sp).map((t) =>
                    `<span class="seg ${!t.url || t.status === 'failed' ? 'failed' : ''}" title="${esc(t.note || '')}" style="left:${(t.offset / this.total) * 100}%;width:${Math.max(0.4, ((t.duration || 0) / this.total) * 100)}%"></span>`).join('')}
                    <span class="head" style="left:0"></span></div>
                <button class="btn small" data-mute="${esc(sp)}">Mute</button>
            </div>`).join('')}
            ${this.failed.length ? `<p class="muted" style="margin-top:10px">${this.failed.length} part(s) failed to upload and are shown hatched.</p>` : ''}
        </div>`;

        this.audio = this.tracks.filter((t) => t.kind !== 'video').map((t) => {
            const el = new Audio(); el.preload = 'auto'; el.src = t.url;
            el.addEventListener('loadedmetadata', () => { if (!t.duration && isFinite(el.duration)) t.duration = el.duration * 1000; });
            return { t, el };
        });
        this.video = video.map((t) => {
            const el = $('#ipVideo', this.host); el.src = t.url; return { t, el };
        }).slice(0, 1);

        $('#ipPlay', this.host).addEventListener('click', () => this.toggle());
        $('#ipSeek', this.host).addEventListener('input', (e) => this.seek(Number(e.target.value)));
        this.host.querySelectorAll('[data-mute]').forEach((b) => b.addEventListener('click', () => {
            const sp = b.dataset.mute;
            if (this.muted.has(sp)) this.muted.delete(sp); else this.muted.add(sp);
            b.textContent = this.muted.has(sp) ? 'Unmute' : 'Mute';
            b.closest('.track').classList.toggle('muted', this.muted.has(sp));
        }));
    }

    toggle() {
        this.playing = !this.playing;
        if (this.playing && this.t >= this.total) this.t = 0;
        this.last = performance.now();
        $('#ipPlay', this.host).textContent = this.playing ? 'Pause' : 'Play';
        if (!this.playing) this.allMedia().forEach(({ el }) => el.pause());
    }

    seek(ms) {
        this.t = ms;
        this.allMedia().forEach(({ el }) => { el.dataset.sync = '1'; });
    }

    allMedia() { return [...(this.audio || []), ...(this.video || [])]; }

    sync({ t, el }, isVideo) {
        const local = this.t - t.offset;
        const len = t.duration || (isFinite(el.duration) ? el.duration * 1000 : 0);
        const inside = local >= 0 && (len === 0 || local < len);
        if (!this.playing || !inside) { if (!el.paused) el.pause(); return; }
        if (!isVideo) el.muted = this.muted.has(t.speaker || 'Unknown');
        const drift = Math.abs(el.currentTime * 1000 - local);
        if (el.dataset.sync === '1' || drift > 350) { el.currentTime = local / 1000; el.dataset.sync = '0'; }
        if (el.paused) el.play().catch(() => {});
    }

    loop() {
        const now = performance.now();
        if (this.playing) {
            this.t += now - (this.last || now);
            if (this.t >= this.total) { this.t = this.total; this.toggle(); }
        }
        this.last = now;
        (this.audio || []).forEach((a) => this.sync(a, false));
        (this.video || []).forEach((v) => this.sync(v, true));
        const seek = $('#ipSeek', this.host);
        if (seek && document.activeElement !== seek) seek.value = this.t;
        const time = $('#ipTime', this.host);
        if (time) time.textContent = `${fmtClock(this.t)} / ${fmtClock(this.total)}`;
        this.host.querySelectorAll('.head').forEach((h) => { h.style.left = `${(this.t / this.total) * 100}%`; });
        this.raf = requestAnimationFrame(() => this.loop());
    }

    destroy() {
        cancelAnimationFrame(this.raf);
        this.allMedia().forEach(({ el }) => { el.pause(); el.removeAttribute('src'); el.load(); });
    }
}

/* ---------- modals ---------- */
function openModal(html, onBind) {
    $('#modalBody').parentElement.classList.remove('mg11');
    $('#modalBody').innerHTML = html;
    $('#modal').classList.remove('hidden');
    $('#modalBody').querySelectorAll('[data-close]').forEach((b) => b.addEventListener('click', closeModal));
    onBind && onBind($('#modalBody'));
    const f = $('#modalBody').querySelector('input, select, textarea');
    f && f.focus();
}
function closeModal() {
    openCallNotes = null;
    $('#modal').classList.add('hidden'); $('#modalBody').innerHTML = '';
    if (typeof purposeCancel === 'function') { const c = purposeCancel; purposeCancel = null; c(); }
}

function confirmModal(text, onYes) {
    openModal(`<p>${esc(text)}</p><div class="actions"><button class="btn" data-close>Keep it</button><button class="btn danger" id="yes">Confirm</button></div>`,
        (m) => m.querySelector('#yes').addEventListener('click', () => { closeModal(); onYes(); }));
}

function offencePicker(selected = []) {
    return `<div class="offence-picker">${state.cfg.offences.map((a) => `<h4>${esc(a.act)}</h4>${a.items.map((o) => {
        const full = `${o}, ${a.act}`;
        const g = state.cfg.sentencing && state.cfg.sentencing.Offences[o];
        const hint = g ? `${COURT_LABEL[g.court] || ''} · max ${g.max}` : '';
        return `<label class="check" title="${esc(hint)}"><input type="checkbox" value="${esc(full)}" ${selected.includes(full) ? 'checked' : ''}>${esc(o)}${g ? ` <span class="muted" style="font-size:12px">${esc(COURT_SHORT[g.court] || '')}</span>` : ''}</label>`;
    }).join('')}`).join('')}</div>`;
}
const pickedOffences = (m) => [...m.querySelectorAll('.offence-picker input:checked')].map((i) => i.value);

function custodyModal(incidentId) {
    const p = state.profile.person;
    const incidents = state.profile.incidents || [];
    openModal(`<h1>Custody record</h1><p class="muted">${esc(fullName(p))}, ${esc(p.cid)}</p>
        <label for="cInc">Incident</label><select id="cInc"><option value="">Not linked to an incident</option>${incidents.map((i) => `<option value="${i.id}" ${String(i.id) === String(incidentId) ? 'selected' : ''}>${esc(i.ref)}: ${esc(i.type)}</option>`).join('')}</select>
        <label>Offences</label>${offencePicker()}
        <label for="cOut">Outcome</label><select id="cOut">${state.cfg.outcomes.map((o) => `<option>${esc(o)}</option>`).join('')}</select>
        <label for="cNar">Circumstances of arrest</label><textarea id="cNar" placeholder="Grounds, necessity and what was found"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="cSave">Save record</button></div>`, (m) => {
        m.querySelector('#cSave').addEventListener('click', async () => {
            const outcome = m.querySelector('#cOut').value;
            const r = await api('createRecord', { cid: p.cid, offences: pickedOffences(m), outcome, narrative: m.querySelector('#cNar').value, incidentId: m.querySelector('#cInc').value || null });
            if (!r.ok) return;
            closeModal();
            toast(`Custody record ${r.ref} saved.`);
            state.tab = 'custody';
            if (outcome === 'Released on bail' || outcome === 'Released under investigation') {
                await viewPerson();
                const rec = state.profile.records.find((x) => x.id === r.id);
                bailModal(rec, outcome === 'Released under investigation' ? 'rui' : null);
            } else viewPerson();
        });
    });
}

function toLocalInput(ts) {
    const d = new Date(ts * 1000);
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function bailModal(record, presetType) {
    const d = state.profile, p = d.person, cfg = state.cfg;
    const home = (d.housing.find((h) => h.role === 'Owner') || d.housing[0]);
    const homeAddr = home ? [home.label, home.address].filter(Boolean).join(', ') : '';
    const def = nowSecs() + cfg.defaultBailDays * 86400;
    openModal(`<h1>Release on bail</h1><p class="muted">${esc(fullName(p))}${record ? `, custody ${esc(record.ref)}` : ''}</p>
        <label for="bType">Type</label>
        <select id="bType">${cfg.bailTypes.map((t) => `<option value="${t.id}" ${t.id === presetType ? 'selected' : ''}>${esc(t.label)}</option>`).join('')}</select>
        <div id="bDateRow" class="two">
            <div><label for="bAt">Answer bail on</label><input type="datetime-local" id="bAt" value="${toLocalInput(def)}"></div>
            <div><label for="bSt">At</label><select id="bSt">${cfg.stations.map((s) => `<option>${esc(s)}</option>`).join('')}</select></div>
        </div>
        ${record ? `<label>Offences</label><ul>${(record.offences || []).map((o) => `<li>${esc(o)}</li>`).join('')}</ul>` : `<label>Offences</label>${offencePicker()}`}
        <label>Conditions</label>
        <div>${cfg.bailConditions.map((c) => `<div class="cond">
            <label class="check"><input type="checkbox" data-cond="${c.id}">${esc(c.label)}</label>
            ${c.input ? `<input type="text" data-condval="${c.id}" class="hidden" placeholder="${esc(c.placeholder || '')}" value="${c.input === 'address' ? esc(homeAddr) : ''}">` : ''}
        </div>`).join('')}</div>
        <label for="bNotes">Notes</label><textarea id="bNotes" placeholder="Reasons for conditions, sureties, anything the next officer needs"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="bSave">Release on bail</button></div>`, (m) => {
        const typeSel = m.querySelector('#bType');
        const syncType = () => {
            const t = cfg.bailTypes.find((x) => x.id === typeSel.value);
            m.querySelector('#bDateRow').classList.toggle('hidden', !t.needsDate);
            m.querySelector('#bSave').textContent = t.id === 'rui' ? 'Release under investigation' : 'Release on bail';
        };
        typeSel.addEventListener('change', syncType); syncType();
        m.querySelectorAll('[data-cond]').forEach((cb) => cb.addEventListener('change', () => {
            const v = m.querySelector(`[data-condval="${cb.dataset.cond}"]`);
            if (v) { v.classList.toggle('hidden', !cb.checked); if (cb.checked) v.focus(); }
        }));
        m.querySelector('#bSave').addEventListener('click', async () => {
            const conditions = [...m.querySelectorAll('[data-cond]:checked')].map((cb) => {
                const v = m.querySelector(`[data-condval="${cb.dataset.cond}"]`);
                return { id: cb.dataset.cond, value: v ? v.value : null };
            });
            const at = m.querySelector('#bAt').value;
            const r = await api('releaseOnBail', {
                cid: p.cid,
                type: typeSel.value,
                recordId: record ? record.id : null,
                offences: record ? record.offences : pickedOffences(m),
                returnAt: at ? Math.floor(new Date(at).getTime() / 1000) : null,
                station: m.querySelector('#bSt').value,
                conditions,
                notes: m.querySelector('#bNotes').value,
            });
            if (!r.ok) return;
            closeModal();
            toast(p.online ? 'Released. They have been given their bail notice.' : 'Released. Bail recorded.');
            state.tab = 'bail';
            viewPerson();
        });
    });
}

function extendModal(b) {
    const cfg = state.cfg;
    openModal(`<h1>Change return date</h1>
        <div class="two"><div><label for="eAt">Answer bail on</label><input type="datetime-local" id="eAt" value="${toLocalInput(b.returnAt)}"></div>
        <div><label for="eSt">At</label><select id="eSt">${cfg.stations.map((s) => `<option ${s === b.station ? 'selected' : ''}>${esc(s)}</option>`).join('')}</select></div></div>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="eSave">Save date</button></div>`, (m) => {
        m.querySelector('#eSave').addEventListener('click', async () => {
            const r = await api('updateBail', { id: b.id, action: 'extend', returnAt: Math.floor(new Date(m.querySelector('#eAt').value).getTime() / 1000), station: m.querySelector('#eSt').value });
            if (r.ok) { closeModal(); toast('Return date saved.'); viewPerson(); }
        });
    });
}

function markerModal(kind, id, after) {
    openModal(`<h1>Add warning marker</h1><p class="muted">${kind === 'vehicle' ? vrm(id) : esc(fullName(state.profile.person))}</p>
        <label for="mSel">Marker</label><select id="mSel">${state.cfg.markers[kind].map((m) => `<option>${esc(m)}</option>`).join('')}</select>
        <label for="mNote">Details</label><input id="mNote" placeholder="What officers need to know">
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="mSave">Add marker</button></div>`, (m) => {
        m.querySelector('#mSave').addEventListener('click', async () => {
            const r = await api('addMarker', { kind, id, marker: m.querySelector('#mSel').value, note: m.querySelector('#mNote').value });
            if (!r.ok) return;
            closeModal(); toast('Marker added.');
            if (after) after(); else viewPerson();
        });
    });
}

function endorseModal() {
    const codes = state.cfg.endorsementCodes;
    openModal(`<h1>Endorse licence</h1><p class="muted">Points total 12 or more triggers a totting-up disqualification.</p>
        <label for="enCode">Offence code</label><select id="enCode">${codes.map((c, i) => `<option value="${i}">${esc(c.code)}: ${esc(c.label)}</option>`).join('')}</select>
        <label for="enPts">Points</label><input id="enPts" type="number" min="1" max="11" value="${codes[0] ? codes[0].points : 3}">
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="enSave">Endorse licence</button></div>`, (m) => {
        const sel = m.querySelector('#enCode');
        sel.addEventListener('change', () => { m.querySelector('#enPts').value = codes[sel.value].points; });
        m.querySelector('#enSave').addEventListener('click', async () => {
            const c = codes[sel.value];
            const r = await api('endorse', { cid: state.cid, code: c.code, reason: c.label, points: m.querySelector('#enPts').value });
            if (!r.ok) return;
            closeModal();
            toast(r.queued ? 'Endorsement queued. It applies when the driver next logs in.'
                : r.autoBanned ? `Endorsed. ${r.total} points reached: driver disqualified under totting up.` : `Endorsed. Licence now carries ${r.total} points.`, r.autoBanned);
            viewPerson();
        });
    });
}

function disqualifyModal() {
    openModal(`<h1>Disqualify from driving</h1>
        <label for="dqDays">Length</label>
        <select id="dqDays"><option value="56">56 days</option><option value="180" selected>6 months</option><option value="365">12 months</option><option value="730">2 years</option><option value="1095">3 years</option><option value="0">Until further order</option></select>
        <label for="dqWhy">Reason</label><input id="dqWhy" placeholder="e.g. Interim disqualification, s.26 RTOA 1988">
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn danger" id="dqSave">Disqualify</button></div>`, (m) => {
        m.querySelector('#dqSave').addEventListener('click', async () => {
            const days = Number(m.querySelector('#dqDays').value);
            const r = await api('disqualify', { cid: state.cid, days: days || null, reason: m.querySelector('#dqWhy').value });
            if (r.ok) { closeModal(); toast(r.queued ? 'Disqualification queued. It applies when the driver next logs in.' : 'Driver disqualified.'); viewPerson(); }
        });
    });
}

/* ---------- no further action ---------- */
function nfaModal(text, send) {
    const reasons = (state.cfg.cps && state.cfg.cps.nfaReasons) || ['Evidential difficulties', 'Not in the public interest'];
    openModal(`<h1>No further action</h1><p>${esc(text)}</p>
        <label for="nfaWhy">Reason</label><select id="nfaWhy">${reasons.map((r) => `<option>${esc(r)}</option>`).join('')}<option value="__other">Other</option></select>
        <input id="nfaOther" class="hidden" style="margin-top:8px" placeholder="Reason">
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="nfaSave">Take no further action</button></div>`, (m) => {
        const sel = m.querySelector('#nfaWhy'), other = m.querySelector('#nfaOther');
        sel.addEventListener('change', () => other.classList.toggle('hidden', sel.value !== '__other'));
        m.querySelector('#nfaSave').addEventListener('click', async () => {
            const reason = sel.value === '__other' ? other.value : sel.value;
            const r = await send(reason);
            if (!r.ok) return;
            closeModal(); toast('No further action recorded.');
            render();
        });
    });
}

/* ---------- CPS ---------- */
const CPS_STATUS = {
    pending: ['amber', 'With CPS'],
    more_evidence: ['amber', 'Further evidence requested'],
    charge: ['warn', 'Charge authorised'],
    nfa: ['ok', 'CPS: no further action'],
    withdrawn: ['', 'Withdrawn'],
};
function cpsChip(status) {
    const [cls, label] = CPS_STATUS[status] || ['', status];
    return `<span class="chip ${cls}">${esc(label)}</span>`;
}

function evidenceEditor(host) {
    const types = state.cfg.cps.evidenceTypes;
    const add = (e = {}) => {
        const row = document.createElement('div');
        row.className = 'evi-row';
        row.innerHTML = `<select aria-label="Evidence type">${types.map((t) => `<option ${t === e.type ? 'selected' : ''}>${esc(t)}</option>`).join('')}</select>
            <input placeholder="What it shows" aria-label="What it shows" value="${esc(e.detail || '')}">
            <input placeholder="Exhibit ref or link (optional)" aria-label="Exhibit reference" value="${esc(e.link || '')}">
            <button class="btn small" type="button" aria-label="Remove item">&times;</button>`;
        row.querySelector('button').addEventListener('click', () => row.remove());
        list.appendChild(row);
    };
    host.innerHTML = '<div class="evi-list"></div><button class="btn small" type="button">Add evidence</button>';
    const list = host.querySelector('.evi-list');
    host.querySelector(':scope > button').addEventListener('click', () => add());
    add();
    return () => [...list.querySelectorAll('.evi-row')].map((r) => {
        const [type, detail, link] = r.querySelectorAll('select, input');
        return { type: type.value, detail: detail.value, link: link.value };
    }).filter((e) => e.detail.trim());
}

function cpsSubmitModal(rec) {
    const p = state.profile.person;
    openModal(`<h1>Submit to CPS</h1><p class="muted">${esc(fullName(p))}, ${esc(rec.ref)}. Ask for a charging decision.</p>
        <label>Proposed charges</label>${offencePicker(rec.offences || [])}
        <label for="cpsSum">Case summary</label>
        <textarea id="cpsSum" style="min-height:140px" placeholder="What happened, how the suspect is identified, what they said in interview, and any defence raised">${esc(rec.narrative || '')}</textarea>
        <label>Evidence relied on</label><div id="cpsEvi"></div>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="cpsSend">Submit to CPS</button></div>`, (m) => {
        const getEvidence = evidenceEditor(m.querySelector('#cpsEvi'));
        m.querySelector('#cpsSend').addEventListener('click', async () => {
            const r = await api('submitCps', { recordId: rec.id, offences: pickedOffences(m), summary: m.querySelector('#cpsSum').value, evidence: getEvidence() });
            if (!r.ok) return;
            closeModal(); toast('Case submitted. You will be told when the CPS decides.');
            viewPerson();
        });
    });
}

function viewCps() {
    const f = state.cpsFilter || 'pending';
    main.innerHTML = `${pageHead('Crown Prosecution Service', state.cfg.role === 'cps' ? 'Cases referred by the police for a charging decision' : 'Cases your force has referred for a charging decision')}
        <div class="filters" id="cpsF">
            <button data-f="pending">Awaiting decision</button>
            <button data-f="more_evidence">Further evidence requested</button>
            <button data-f="decided">Decided</button>
        </div><div id="cpsList" class="muted">Loading</div>`;
    main.querySelectorAll('#cpsF button').forEach((b) => {
        b.classList.toggle('active', b.dataset.f === f);
        b.addEventListener('click', () => { state.cpsFilter = b.dataset.f; viewCps(); });
    });
    loadCps(f);
}

async function loadCps(f) {
    const d = await api('cpsQueue', { filter: f });
    const el = $('#cpsList');
    if (d.error || !el) return;
    const n = d.counts || {};
    main.querySelectorAll('#cpsF button').forEach((b) => {
        const c = b.dataset.f === 'decided' ? (n.charge || 0) + (n.nfa || 0) + (n.withdrawn || 0) : (n[b.dataset.f] || 0);
        b.textContent = `${b.textContent.replace(/ \(\d+\)$/, '')} (${c})`;
    });
    const empty = { pending: 'No cases are waiting for a decision.', more_evidence: 'No cases are waiting on the police.', decided: 'No decisions yet.' }[f];
    el.className = '';
    el.innerHTML = d.cases.length ? `<div class="rows">${d.cases.map((c) => `
        <button class="row" data-case="${c.id}">
            <span class="name">${esc(c.name)}<br><span class="muted">${esc(c.custodyRef || '')}</span></span>
            <span>${esc((c.offences || [])[0] || '')}${(c.offences || []).length > 1 ? ` <span class="muted">+${c.offences.length - 1}</span>` : ''}</span>
            <span>${esc(c.officer || '')}<br><span class="muted">submitted ${fmtDate(c.submittedAt)}</span></span>
            <span>${cpsChip(c.status)}</span>
        </button>`).join('')}</div>` : `<p class="empty">${empty}</p>`;
    el.querySelectorAll('[data-case]').forEach((b) => b.addEventListener('click', () => go('cpsCase', { caseId: b.dataset.case, caseReturn: 'cps' })));
}

async function viewCpsCase() {
    main.innerHTML = '<p class="muted">Loading case file</p>';
    const d = await api('cpsCase', { id: state.caseId });
    if (d.error) { main.innerHTML = `<p class="empty">${esc(d.error)}</p>`; return; }
    const c = d.case, isCps = state.cfg.role === 'cps';
    const back = { person: 'Back to person', home: 'Back to briefing' }[state.caseReturn] || 'Back to cases';
    const test = (v) => v === 'met' ? '<span class="status valid">Met</span>' : v === 'not_met' ? '<span class="status revoked">Not met</span>' : '<span class="muted">Not assessed</span>';

    main.innerHTML = `
        <button class="btn small" id="cBack">${back}</button>
        <div class="head" style="display:flex;justify-content:space-between;align-items:start;margin-top:14px">
            <div><h1>${esc(c.name)}</h1><p class="muted">${esc(c.custodyRef || '')}, submitted by ${esc(c.officer || '')} on ${fmtDate(c.submittedAt)}</p></div>
            ${cpsChip(c.status)}
        </div>
        ${d.bail ? bailBanner(d.bail) : ''}
        ${c.status === 'more_evidence' ? `<div class="banner bail"><strong>Action plan from ${esc(c.lawyer || 'the CPS')}</strong>${esc(c.actionPlan || '')}</div>` : ''}
        ${['charge', 'nfa'].includes(c.status) ? `<div class="banner ${c.status === 'charge' ? 'warn' : 'bail'}">
            <strong>${c.status === 'charge' ? 'Charge authorised' : 'No further action'} by ${esc(c.lawyer || '')}, ${fmtDate(c.decidedAt)}</strong>
            Evidential stage: ${test(c.evidential)}. Public interest stage: ${test(c.publicInterest)}.
            ${c.status === 'charge' ? `<ul>${(c.charges || []).map((x) => `<li>${esc(x)}</li>`).join('')}</ul>` : ''}
            <p style="margin-top:6px">${esc(c.reason || '')}</p></div>` : ''}
        <div class="case-grid" style="margin-top:18px">
            <div>
                <div class="panel"><h3>Proposed charges</h3><ul>${(c.offences || []).map((o) => `<li>${esc(o)}</li>`).join('')}</ul></div>
                <div class="panel"><h3>Case summary</h3><p style="white-space:pre-wrap">${esc(c.summary || '')}</p></div>
                <div class="panel"><h3>Evidence</h3>${(c.evidence || []).length ? `<table><tr><th>Type</th><th>What it shows</th><th>Ref</th></tr>
                    ${c.evidence.map((e) => `<tr><td>${esc(e.type)}</td><td>${esc(e.detail)}</td><td class="muted">${esc(e.link || '')}</td></tr>`).join('')}</table>` : '<p class="muted">None listed.</p>'}</div>
                ${d.record && d.record.narrative ? `<div class="panel"><h3>Arrest record</h3><p style="white-space:pre-wrap">${esc(d.record.narrative)}</p></div>` : ''}
                ${(d.statements || []).length ? `<div class="panel"><h3>Statements (${d.statements.length})</h3>${statementRows(d.statements)}</div>` : ''}
                ${(d.exhibits || []).length ? `<div class="panel flush">${panelHead(`Exhibits (${d.exhibits.length})`)}${exhibitTable(d.exhibits, false)}</div>` : ''}
                ${d.injury && (d.injury.list.length || d.injury.pending) ? `<div class="panel"><h3>Injury statements (${d.injury.list.length})</h3>
                    ${d.injury.list.map((q) => `<div class="record"><div class="meta">${esc(q.patientName || '')} · ${esc(q.clinician || '')}, ${fmtDate(q.respondedAt)}${q.ePRFRef ? ` · ePRF ${esc(q.ePRFRef)}` : ''}</div>
                        <p style="white-space:pre-wrap">${esc(q.statement || '')}</p></div>`).join('')}
                    ${d.injury.pending ? `<p class="muted">${d.injury.pending} request(s) to the ambulance service still waiting on ${esc(d.injury.incidentRef || 'the incident')}.</p>` : ''}</div>` : ''}
                <div id="caseAction"></div>
            </div>
            <div>
                ${d.interviews ? `<div class="panel"><h3>Interviews</h3>${d.interviews.length ? interviewRows(d.interviews) : '<p class="muted">No recorded interviews found.</p>'}</div>` : ''}
                <div class="panel"><h3>Previous custody</h3>${d.prior.length ? d.prior.map((p) => `<div class="record" style="margin-bottom:10px">
                    <div class="meta">${esc(p.ref || '')}, ${fmtDate(p.created_at, false)}</div>${esc(p.outcome || '')}
                    <ul>${(p.offences || []).map((o) => `<li>${esc(o)}</li>`).join('')}</ul></div>`).join('') : '<p class="muted">No previous custody records.</p>'}</div>
                <div class="panel"><h3>History</h3><div class="log">${(c.log || []).map((l) => `<div><div class="meta">${fmtDate(l.at)}, ${esc(l.by)}</div>${esc(l.text)}</div>`).join('')}</div></div>
            </div>
        </div>`;

    $('#cBack').addEventListener('click', () => go(state.caseReturn === 'person' || state.caseReturn === 'home' ? state.caseReturn : 'cps'));
    main.querySelectorAll('[data-iid]').forEach((b) => b.addEventListener('click', () => go('interview', { interviewId: b.dataset.iid, returnTo: 'cpsCase' })));
    bindStatementRows(main, d.statements || []);

    const host = $('#caseAction');
    if (isCps && c.status === 'pending') decisionForm(host, c);
    if (!isCps && c.status === 'more_evidence') resubmitForm(host, c);
}

function decisionForm(host, c) {
    const s = { evidential: null, publicInterest: null, decision: null };
    host.innerHTML = `<div class="panel">
        <h3>Charging decision</h3>
        <p class="muted">Apply the Full Code Test. Charge only if there is a realistic prospect of conviction and a prosecution is in the public interest.</p>
        <div class="stage"><span>Evidential stage: is there a realistic prospect of conviction?</span>
            <span class="seg-toggle" data-stage="evidential"><button data-v="met">Met</button><button data-v="not_met">Not met</button></span></div>
        <div class="stage" id="piRow"><span>Public interest stage: is a prosecution required?</span>
            <span class="seg-toggle" data-stage="publicInterest"><button data-v="met">Met</button><button data-v="not_met">Not met</button></span></div>
        <div class="decision">
            <button data-d="charge">Charge<span>Both stages met</span></button>
            <button data-d="nfa">No further action<span>A stage is not met</span></button>
            <button data-d="more_evidence">Further evidence<span>Send an action plan</span></button>
        </div>
        <div id="dCharge" class="hidden"><label>Charges</label>${offencePicker(c.offences || [])}</div>
        ${state.cfg.sentencing ? `<button class="btn small" type="button" id="dSent" style="margin-top:10px">${icon('gavel')}Sentencing guidance for these charges</button>` : ''}
        <div id="dPlan" class="hidden"><label for="dPlanT">Action plan for the officer</label><textarea id="dPlanT" placeholder="What evidence is needed and why"></textarea></div>
        <div id="dReason"><label for="dReasonT">Reasons</label><textarea id="dReasonT" placeholder="Record your reasoning against each stage"></textarea></div>
        <div class="actions" style="justify-content:flex-end;margin-top:14px"><button class="btn primary" id="dSave" disabled>Record decision</button></div>
    </div>`;

    const sync = () => {
        host.querySelectorAll('.seg-toggle').forEach((t) => t.querySelectorAll('button').forEach((b) => {
            const on = s[t.dataset.stage] === b.dataset.v;
            b.classList.toggle('on', on); b.classList.toggle(b.dataset.v, on);
        }));
        // The public interest stage is only considered once the evidential stage is met.
        host.querySelector('#piRow').classList.toggle('hidden', s.evidential !== 'met');
        if (s.evidential !== 'met') s.publicInterest = null;
        const allowed = {
            charge: s.evidential === 'met' && s.publicInterest === 'met',
            nfa: s.evidential === 'not_met' || (s.evidential === 'met' && s.publicInterest === 'not_met'),
            more_evidence: true,
        };
        if (s.decision && !allowed[s.decision]) s.decision = null;
        host.querySelectorAll('[data-d]').forEach((b) => { b.disabled = !allowed[b.dataset.d]; b.classList.toggle('on', s.decision === b.dataset.d); });
        host.querySelector('#dCharge').classList.toggle('hidden', s.decision !== 'charge');
        host.querySelector('#dPlan').classList.toggle('hidden', s.decision !== 'more_evidence');
        host.querySelector('#dReason').classList.toggle('hidden', s.decision === 'more_evidence');
        const save = host.querySelector('#dSave');
        save.disabled = !s.decision;
        save.textContent = { charge: 'Authorise charge', nfa: 'Take no further action', more_evidence: 'Send action plan' }[s.decision] || 'Record decision';
    };
    host.querySelector('#dSent')?.addEventListener('click', () => {
        const picked = pickedOffences(host);
        sentencingModal({ offences: picked.length ? picked : (c.offences || []), cid: c.cid, name: c.name, recordId: c.recordId, ref: c.custodyRef });
    });
    host.querySelectorAll('.seg-toggle button').forEach((b) => b.addEventListener('click', () => { s[b.closest('.seg-toggle').dataset.stage] = b.dataset.v; sync(); }));
    host.querySelectorAll('[data-d]').forEach((b) => b.addEventListener('click', () => { s.decision = b.dataset.d; sync(); }));
    sync();

    host.querySelector('#dSave').addEventListener('click', () => {
        const send = async () => {
            const r = await api('cpsDecide', {
                id: c.id, decision: s.decision, evidential: s.evidential, publicInterest: s.publicInterest,
                charges: pickedOffences(host), reason: host.querySelector('#dReasonT').value, actionPlan: host.querySelector('#dPlanT').value,
            });
            if (!r.ok) return;
            toast({ charge: 'Charge authorised. The officer has been told.', nfa: 'No further action recorded. Bail has been cancelled.', more_evidence: 'Action plan sent to the officer.' }[s.decision]);
            viewCpsCase();
        };
        if (s.decision === 'more_evidence') send();
        else confirmModal(s.decision === 'charge' ? 'Authorise these charges? The suspect and officer will be told.' : 'Take no further action? This closes the case and cancels any bail.', send);
    });
}

function resubmitForm(host, c) {
    host.innerHTML = `<div class="panel"><h3>Respond to the action plan</h3>
        <label>New evidence</label><div id="rEvi"></div>
        <label for="rResp">Response to the CPS</label><textarea id="rResp" placeholder="What you did for each action"></textarea>
        <div class="actions" style="justify-content:flex-end;margin-top:14px"><button class="btn primary" id="rSend">Resubmit to CPS</button></div></div>`;
    const getEvidence = evidenceEditor(host.querySelector('#rEvi'));
    host.querySelector('#rSend').addEventListener('click', async () => {
        const r = await api('cpsResubmit', { id: c.id, evidence: getEvidence(), response: host.querySelector('#rResp').value });
        if (r.ok) { toast('Resubmitted to the CPS.'); viewCpsCase(); }
    });
}

/* ---------- defence solicitors ---------- */
const DISCLOSURE_HINT = 'Pre-interview disclosure: what your client was arrested for, when and where, and the evidence you intend to put to them. Only what you choose to disclose goes to the solicitor.';

function solicitorModal(rec) {
    openModal(`<h1>Assign solicitor</h1><p class="muted">${esc(rec.subject_name)}, ${esc(rec.ref)}</p>
        <label for="solQ">Solicitor</label>
        <input id="solQ" autocomplete="off" placeholder="Start typing a solicitor's name">
        <div id="solResults" style="margin-top:10px" class="muted">Loading solicitors in the city</div>
        <label for="solDisc">Disclosure</label>
        <textarea id="solDisc" style="min-height:150px" placeholder="${esc(DISCLOSURE_HINT)}"></textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="solSave" disabled>Assign solicitor</button></div>`, async (m) => {
        let chosen = null;
        const host = m.querySelector('#solResults'), save = m.querySelector('#solSave');
        const draw = (title, list, emptyText) => {
            host.className = '';
            host.innerHTML = `<h2 style="margin-bottom:6px">${title}</h2>` + (list.length ? `<table>${list.map((s) => `<tr class="click ${chosen === s.cid ? 'chosen' : ''}" data-sol="${esc(s.cid)}">
                <td class="strong">${esc(s.name)} ${s.online ? '<span class="chip online">In city</span>' : ''}</td><td class="muted">${esc(s.firm || s.job || '')}</td>
                <td style="text-align:right">${chosen === s.cid ? pill('Selected', 'blue') : '<button class="btn tiny" type="button">Select</button>'}</td></tr>`).join('')}</table>`
                : `<p class="muted">${emptyText}</p>`);
            host.querySelectorAll('[data-sol]').forEach((r) => r.addEventListener('click', () => {
                chosen = r.dataset.sol; save.disabled = false; draw(title, list, emptyText);
            }));
        };
        const online = async () => {
            const d = await api('solicitorList');
            if (!d.error) draw('Solicitors in the city', d.solicitors || [], 'No solicitors are in the city. Search by name to assign one who is not.');
        };
        let timer, seq = 0;
        const input = m.querySelector('#solQ');
        input.addEventListener('input', () => {
            clearTimeout(timer);
            timer = setTimeout(async () => {
                const q = input.value.trim();
                if (q.length < 2) { online(); return; }
                const mine = ++seq;
                const d = await api('solicitorSearch', { q });
                if (mine !== seq || d.error) return;
                draw(`Solicitors matching "${esc(q)}"`, d.results, 'No solicitor by that name. Check the spelling, and that they have a solicitor job.');
            }, 300);
        });
        online();
        save.addEventListener('click', async () => {
            if (!chosen) return;
            const r = await api('assignSolicitor', { recordId: rec.id, solicitorCid: chosen, disclosure: m.querySelector('#solDisc').value });
            if (!r.ok) return;
            closeModal(); toast('Solicitor assigned. They can now read the disclosure.');
            viewPerson();
        });
    });
}

function disclosureModal(rec) {
    openModal(`<h1>Disclosure</h1><p class="muted">${esc(rec.subject_name)}, ${esc(rec.ref)}, for ${esc(rec.defence.solicitor)}</p>
        <textarea id="discT" style="min-height:200px" placeholder="${esc(DISCLOSURE_HINT)}">${esc(rec.defence.disclosure || '')}</textarea>
        <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="discSave">Save disclosure</button></div>`, (m) => {
        m.querySelector('#discSave').addEventListener('click', async () => {
            const r = await api('updateDisclosure', { id: rec.defence.id, disclosure: m.querySelector('#discT').value });
            if (r.ok) { closeModal(); toast('Disclosure saved. The solicitor has been told.'); viewPerson(); }
        });
    });
}

async function viewDefence() {
    main.innerHTML = pageHead('My clients', 'Cases the custody officer has assigned to you') + '<div id="defList" class="muted">Loading</div>';
    const d = await api('defenceCases');
    const el = $('#defList');
    if (d.error || !el) return;
    el.className = '';
    el.innerHTML = d.cases.length ? `<div class="rows">${d.cases.map((c) => `
        <button class="row" data-def="${c.id}">
            <span class="name">${esc(c.name)}<br><span class="muted">${esc(c.ref || '')}</span></span>
            <span>Arrested ${fmtDate(c.arrestedAt)}</span>
            <span>${esc(c.outcome || 'In custody')}<br><span class="muted">assigned by ${esc(c.assignedBy || '')}</span></span>
            <span class="chip">Open</span>
        </button>`).join('')}</div>` : '<p class="empty">You have no clients assigned. The custody officer assigns you when your client asks for you.</p>';
    el.querySelectorAll('[data-def]').forEach((b) => b.addEventListener('click', () => go('defenceCase', { defenceId: b.dataset.def })));
}

async function viewDefenceCase() {
    main.innerHTML = '<p class="muted">Loading disclosure</p>';
    const d = await api('defenceCase', { id: state.defenceId });
    if (d.error) { main.innerHTML = `<p class="empty">${esc(d.error)}</p><button class="btn small" id="dBack">Back to clients</button>`; $('#dBack').addEventListener('click', () => go('defence')); return; }
    const c = d.case;
    main.innerHTML = `
        <button class="btn small" id="dBack">Back to clients</button>
        <h1 style="margin-top:14px">${esc(c.client.name)}</h1>
        <p class="muted">${esc(c.ref || '')}, arrested ${fmtDate(c.arrestedAt)}${c.client.dob ? `, born ${esc(c.client.dob)}` : ''}</p>
        <div class="chips">${c.client.online ? '<span class="chip online">In the city</span>' : ''}<span class="chip">${esc(c.outcome || 'In custody')}</span>
            ${c.cps ? cpsChip(c.cps.status) : ''}</div>
        ${c.bail ? bailBanner(c.bail) : ''}
        <div class="case-grid" style="margin-top:18px">
            <div>
                <div class="panel"><div class="head"><h3>Pre-interview disclosure</h3><span class="muted">${esc(c.assignedBy || '')}, ${fmtDate(c.updatedAt)}</span></div>
                    ${c.disclosure ? `<p style="white-space:pre-wrap">${esc(c.disclosure)}</p>` : '<p class="muted">The officer has not written any disclosure yet. Ask the custody officer before your client is interviewed.</p>'}</div>
                ${c.narrative ? `<div class="panel"><h3>Circumstances of arrest</h3><p style="white-space:pre-wrap">${esc(c.narrative)}</p></div>` : ''}
                ${c.notes ? `<div class="panel">${panelHead('My notes', '<span class="muted" style="font-size:12px">Private. The police and CPS cannot see these.</span>')}
                    <textarea id="dnBody" placeholder="Instructions, account given, things to raise, follow-ups"></textarea>
                    <div class="actions" style="margin-top:8px;justify-content:flex-end"><button class="btn small primary" id="dnAdd">${icon('note')}Add note</button></div>
                    <div id="dnList" style="margin-top:10px">${c.notes.length ? c.notes.map((n) => `<div class="record" data-note="${n.id}">
                        <div class="meta">${fmtDate(n.created_at)}${n.updated_at !== n.created_at ? ` · edited ${fmtDate(n.updated_at)}` : ''}${n.case_ref && n.case_ref !== c.ref ? ` · ${esc(n.case_ref)}` : ''}</div>
                        <p style="white-space:pre-wrap">${esc(n.body)}</p>
                        <div class="actions"><button class="btn tiny" data-nedit="${n.id}">Edit</button><button class="btn tiny" data-ndel="${n.id}">Delete</button></div></div>`).join('')
                        : '<p class="muted">No notes yet.</p>'}</div></div>` : ''}
            </div>
            <div>
                ${c.offences ? `<div class="panel"><h3>Arrested on suspicion of</h3><ul>${c.offences.map((o) => `<li>${esc(o)}</li>`).join('')}</ul></div>` : ''}
                ${c.cps && c.cps.status === 'charge' ? `<div class="panel"><h3>Charges authorised</h3><ul>${(c.cps.charges || []).map((o) => `<li>${esc(o)}</li>`).join('')}</ul></div>` : ''}
                ${c.interviews ? `<div class="panel"><h3>Interview recordings</h3>${c.interviews.length ? interviewRows(c.interviews) : '<p class="muted">No recordings under this custody reference yet.</p>'}</div>` : ''}
                ${c.history ? clientHistoryPanel(c.history) : ''}
            </div>
        </div>`;
    $('#dBack').addEventListener('click', () => go('defence'));
    main.querySelectorAll('[data-iid]').forEach((b) => b.addEventListener('click', () => go('interview', { interviewId: b.dataset.iid, returnTo: 'defenceCase' })));
    $('#dnAdd')?.addEventListener('click', async () => {
        const r = await api('defenceNoteSave', { caseId: c.id, body: $('#dnBody').value });
        if (r.ok) { toast('Note saved.'); viewDefenceCase(); }
    });
    main.querySelectorAll('[data-nedit]').forEach((b) => b.addEventListener('click', () => {
        const n = c.notes.find((x) => String(x.id) === b.dataset.nedit);
        openModal(`<h1>Edit note</h1><textarea id="neBody" style="min-height:180px">${esc(n.body)}</textarea>
            <div class="actions"><button class="btn" data-close>Cancel</button><button class="btn primary" id="neSave">Save</button></div>`, (m) => {
            m.querySelector('#neSave').addEventListener('click', async () => {
                const r = await api('defenceNoteSave', { caseId: c.id, noteId: n.id, body: m.querySelector('#neBody').value });
                if (r.ok) { closeModal(); toast('Note updated.'); viewDefenceCase(); }
            });
        });
    }));
    main.querySelectorAll('[data-ndel]').forEach((b) => b.addEventListener('click', () => confirmModal('Delete this note?', async () => {
        const r = await api('defenceNoteDelete', { noteId: b.dataset.ndel });
        if (r.ok) { toast('Note deleted.'); viewDefenceCase(); }
    })));
}

function clientHistoryPanel(h) {
    const bailLabel = (t) => ((state.cfg.bailTypes || []).find((b) => b.id === t) || { label: t }).label;
    return `<div class="panel"><h3>Client history</h3>
        <p class="muted" style="margin-bottom:10px">${h.convictions} previous conviction(s), ${h.cautions} caution(s) or community resolution(s).</p>
        ${h.records.length ? h.records.map((r) => `<div class="record" style="margin-bottom:10px">
            <div class="meta">${esc(r.ref || '')}, ${fmtDate(r.at, false)}</div>${outcomePill(r.outcome)}
            <ul>${(r.offences || []).map((o) => `<li>${esc(o)}</li>`).join('')}</ul></div>`).join('') : '<p class="muted">No previous custody records.</p>'}
        ${(h.sentences || []).length ? `<h3 style="margin-top:12px">Court sentences</h3><table>${h.sentences.map((x) => `<tr><td>${fmtDate(x.at, false)}</td><td>${esc(x.summary || '')}</td></tr>`).join('')}</table>` : ''}
        ${h.bail.length ? `<h3 style="margin-top:12px">Bail</h3><table>${h.bail.map((b) => `<tr><td>${esc(bailLabel(b.type))}<br><span class="muted">${esc(b.ref || '')}</span></td>
            <td>${fmtDate(b.at, false)}</td><td style="text-align:right">${pill(b.status === 'breached' ? 'Breached' : b.status === 'active' ? 'Active' : b.status === 'nfa' ? 'NFA' : b.status, b.status === 'breached' ? 'red' : b.status === 'active' ? 'amber' : '')}</td></tr>`).join('')}</table>` : ''}
        ${h.fines.length ? `<h3 style="margin-top:12px">Fines and penalties</h3><table>${h.fines.map((f) => `<tr><td>${esc(f.ref)}<br><span class="muted">${(f.offences || []).map((o) => esc(o.label)).join(', ')}</span></td>
            <td>${f.type === 'TOR' && f.status === 'court' ? 'Court' : cur(f.amount)}</td><td style="text-align:right">${pill(f.status === 'paid' ? 'Paid' : f.status === 'court' ? 'To court' : 'Unpaid', f.status === 'paid' ? 'green' : 'amber')}</td></tr>`).join('')}</table>` : ''}
    </div>`;
}

/* ---------- notice for the person released ---------- */
let noticeTimer;
function showBailNotice(b, force) {
    const el = $('#bailNotice');
    const t = (b.type === 'rui') ? 'Released under investigation' : 'Notice of bail';
    el.innerHTML = `<h3>${esc(force)}: ${t}</h3>
        ${b.custodyRef ? `<p class="small">${esc(b.custodyRef)}</p>` : ''}
        ${b.returnAt ? `<p>You must surrender to custody at <strong>${esc(b.station)}</strong> on <strong>${fmtDate(b.returnAt)}</strong>.</p>` : '<p>You will be contacted when a decision is made.</p>'}
        ${(b.conditions || []).length ? `<p>Conditions:</p><ul>${b.conditions.map((c) => `<li>${esc(c.label)}${c.value ? `: ${esc(c.value)}` : ''}</li>`).join('')}</ul>` : ''}
        <p class="small">Failing to surrender is an offence under s.6 Bail Act 1976.</p>`;
    el.classList.remove('hidden');
    clearTimeout(noticeTimer);
    noticeTimer = setTimeout(() => el.classList.add('hidden'), 25000);
}
