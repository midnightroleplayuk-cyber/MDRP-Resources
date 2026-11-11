/* vinewood-moj NUI. Staff system (/moj) and the public portal (/mycase). */
'use strict';

const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'vinewood-moj';
const $ = (s, el = document) => el.querySelector(s);
const $$ = (s, el = document) => Array.from(el.querySelectorAll(s));
const main = $('#main');
const state = { mode: null, me: null, cfg: {}, view: 'dashboard', params: {}, data: null, serverTime: 0 };

const esc = (v) => String(v ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const pad = (n) => String(n).padStart(2, '0');
function fmtDate(ts, time = true) {
    if (!ts) return '';
    const d = new Date(Number(ts) * 1000);
    return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()}${time ? ` ${pad(d.getHours())}:${pad(d.getMinutes())}` : ''}`;
}
const fmtTime = (ts) => { const d = new Date(Number(ts) * 1000); return `${pad(d.getHours())}:${pad(d.getMinutes())}`; };
const toInput = (ts) => { const d = new Date(Number(ts) * 1000); return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`; };
const fromInput = (v) => (v ? Math.floor(new Date(v).getTime() / 1000) : null);
const money = (n) => `${state.cfg.currency || '£'}${Number(n || 0).toLocaleString('en-GB')}`;
const tag = (t, c = '') => `<span class="tag ${c}">${esc(t)}</span>`;
const now = () => Math.floor(Date.now() / 1000);

const CREST = `<svg viewBox="0 0 48 48" aria-hidden="true"><g fill="none" stroke="#fff" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
<path d="M24 6v34M14 40h20M10 14h28M24 10l-2-4h4z"/><path d="M10 14l-6 13h12zM38 14l-6 13h12z"/><path d="M4 27a6 4 0 0 0 12 0M32 27a6 4 0 0 0 12 0"/></g></svg>`;

async function post(name, body) {
    try {
        const r = await fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body || {}) });
        return await r.json();
    } catch (e) { return { error: 'No connection.' }; }
}
async function api(action, data = {}, quiet = false) {
    const r = (await post('request', { action, data })) || {};
    if (r.error && !quiet) toast(r.error, true);
    if (r.serverTime) state.serverTime = r.serverTime;
    return r;
}
async function portalApi(action, data = {}) {
    const r = (await post('portal', { action, data })) || {};
    if (r.error) toast(r.error, true);
    return r;
}

let toastTimer;
function toast(msg, bad = false) {
    const t = $('#toast');
    t.textContent = msg;
    t.className = `toast${bad ? ' bad' : ''}`;
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => t.classList.add('hidden'), 3500);
}

/* ---------- modals ---------- */
const modal = $('#modal');
function openModal(html, wide = false) {
    const box = $('.box', modal);
    box.className = `box${wide ? ' wide' : ''}`;
    box.innerHTML = html;
    modal.classList.remove('hidden');
    return box;
}
function closeModal() { modal.classList.add('hidden'); $('.box', modal).innerHTML = ''; }
modal.addEventListener('mousedown', (e) => { if (e.target === modal) closeModal(); });

function confirmModal(text, onYes, yesLabel = 'Confirm', danger = false) {
    const box = openModal(`<h2>Are you sure?</h2><p>${esc(text)}</p>
        <div class="btn-row"><button class="btn ${danger ? 'warning' : ''}" id="mYes">${esc(yesLabel)}</button><button class="btn secondary" id="mNo">Cancel</button></div>`);
    $('#mNo', box).onclick = closeModal;
    $('#mYes', box).onclick = async () => { $('#mYes', box).disabled = true; await onYes(); closeModal(); };
}

/** fields: [{ id, label, type: 'text'|'textarea'|'number'|'datetime'|'select', options, value, hint }] */
function formModal(title, fields, submitLabel, onSubmit, intro = '') {
    const box = openModal(`<h2>${esc(title)}</h2>${intro}
        ${fields.map((f) => `<label for="f_${f.id}">${esc(f.label)}</label>${f.hint ? `<div class="hint">${esc(f.hint)}</div>` : ''}${fieldHtml(f)}`).join('')}
        <div id="fErr"></div>
        <div class="btn-row"><button class="btn" id="fGo">${esc(submitLabel)}</button><button class="btn secondary" id="fCancel">Cancel</button></div>`);
    $('#fCancel', box).onclick = closeModal;
    $('#fGo', box).onclick = async () => {
        const vals = {};
        fields.forEach((f) => {
            const el = $(`#f_${f.id}`, box);
            vals[f.id] = f.type === 'datetime' ? fromInput(el.value) : f.type === 'number' ? Number(el.value) : el.value;
        });
        $('#fGo', box).disabled = true;
        const r = await onSubmit(vals);
        $('#fGo', box).disabled = false;
        if (r && r.error) { $('#fErr', box).innerHTML = `<p class="err">${esc(r.error)}</p>`; return; }
        closeModal();
    };
    return box;
}
function fieldHtml(f) {
    const v = f.value ?? '';
    if (f.type === 'textarea') return `<textarea id="f_${f.id}">${esc(v)}</textarea>`;
    if (f.type === 'select') return `<select id="f_${f.id}">${f.options.map((o) => `<option value="${esc(o.value)}" ${String(o.value) === String(v) ? 'selected' : ''}>${esc(o.label)}</option>`).join('')}</select>`;
    if (f.type === 'datetime') return `<input type="datetime-local" id="f_${f.id}" value="${v ? toInput(v) : ''}">`;
    if (f.type === 'number') return `<input type="number" id="f_${f.id}" value="${esc(v)}" ${f.min !== undefined ? `min="${f.min}"` : ''}>`;
    return `<input type="text" id="f_${f.id}" value="${esc(v)}" placeholder="${esc(f.placeholder || '')}">`;
}

/* ---------- shell ---------- */
const NAV = {
    judge: ['dashboard', 'list', 'cases', 'civil', 'warrants', 'prison', 'probation', 'fines'],
    clerk: ['dashboard', 'list', 'cases', 'civil', 'warrants', 'prison', 'fines'],
    cps: ['dashboard', 'list', 'cases', 'warrants'],
    defence: ['dashboard', 'list', 'cases', 'civil', 'warrants'],
    probation: ['dashboard', 'probation', 'cases', 'prison', 'warrants'],
    prison: ['dashboard', 'prison', 'warrants'],
    police: ['dashboard', 'list', 'cases', 'warrants', 'prison'],
};
const NAV_LABEL = { dashboard: 'Overview', list: 'Court lists', cases: 'Cases', civil: 'Civil claims', warrants: 'Warrants', prison: 'Prison', probation: 'Probation', fines: 'Fines' };
const VIEWS = {};

function can(...roles) { return state.me && roles.includes(state.me.role); }

function drawShell() {
    $('#crest').innerHTML = state.cfg.crest ? `<img src="${esc(state.cfg.crest)}" alt="">` : CREST;
    $('#svcName').textContent = state.mode === 'portal' ? state.cfg.courtsName || 'HM Courts & Tribunals Service' : state.cfg.serviceName || 'Ministry of Justice';
    $('#svcSub').textContent = state.mode === 'portal' ? 'Your justice account' : state.cfg.courtsName || '';
    if (state.mode === 'portal') {
        $('#who').innerHTML = `<strong>${esc(state.data?.name || '')}</strong>`;
        $('#nav').classList.add('hidden');
        return;
    }
    if (state.mode === 'custody') {
        $('#svcSub').textContent = 'Court custody';
        $('#who').innerHTML = `<strong>${esc(state.me?.name || '')}</strong>${esc(state.me?.label || '')}`;
        $('#nav').classList.add('hidden');
        return;
    }
    if (state.mode === 'rooms') {
        $('#svcSub').textContent = 'Courtroom setup';
        $('#who').innerHTML = '<strong>Server admin</strong>';
        $('#nav').classList.add('hidden');
        return;
    }
    $('#nav').classList.remove('hidden');
    $('#who').innerHTML = `${state.room && state.room.screens ? '<button class="btn small" id="scrBtn" style="margin-right:14px;vertical-align:middle">Screens</button>' : ''}<span style="display:inline-block;vertical-align:middle"><strong>${esc(state.me.name)}</strong>${esc(state.me.label)}</span>`;
    if ($('#scrBtn')) $('#scrBtn').onclick = () => screensModal();
    const items = (NAV[state.me.role] || ['dashboard']).filter((v) => v !== 'civil' || state.cfg.civil);
    $('#nav').innerHTML = items.map((v) => `<button data-nav="${v}" class="${state.view === v || (state.view === 'case' && v === 'cases') || (state.view === 'order' && v === 'probation') || (state.view === 'claim' && v === 'civil') ? 'active' : ''}">${NAV_LABEL[v]}</button>`).join('');
    $$('#nav [data-nav]').forEach((b) => (b.onclick = () => go(b.dataset.nav)));
}

async function go(view, params = {}) {
    state.view = view;
    state.params = params;
    drawShell();
    main.innerHTML = '<p class="muted">Loading…</p>';
    main.scrollTop = 0;
    await VIEWS[view](params);
}
const refresh = () => VIEWS[state.view](state.params);

window.addEventListener('message', async (e) => {
    const m = e.data || {};
    if (m.action === 'open') {
        state.mode = m.mode;
        showDevice(m.device || 'none', m.extra || {});
        if (m.mode === 'portal') {
            state.view = 'portal';
            await VIEWS.portal();
        } else if (m.mode === 'custody') {
            const r = await api('init');
            if (r.error) return close();
            state.me = r.me;
            state.cfg = r.cfg;
            state.view = 'custody';
            await VIEWS.custody();
        } else if (m.mode === 'rooms') {
            state.view = 'rooms';
            await VIEWS.rooms({ open: m.extra && m.extra.roomId });
        } else {
            const r = await api('init');
            if (r.error) return close();
            state.me = r.me;
            state.cfg = r.cfg;
            state.room = r.room || null;
            go(state.me.role === 'prison' ? 'prison' : state.me.role === 'probation' ? 'probation' : 'dashboard');
        }
    } else if (m.action === 'mic') {
        $('#micBadge').classList.toggle('hidden', !m.on);
        if (m.on) $('#micLabel').textContent = m.label || '';
    } else if (m.action === 'hint') {
        $('#hint').classList.toggle('hidden', !m.text);
        if (m.text) $('#hint').textContent = m.text;
    } else if (m.action === 'close') {
        hideDevice();
        closeModal();
    }
});
function close() { post('close'); hideDevice(); closeModal(); }

/* Device frame: tablet for /moj and /mycase, laptop in a courtroom, none for the editor. */
let clockTimer;
function showDevice(kind, extra) {
    const dev = $('#device');
    dev.className = `device ${['tablet', 'laptop'].includes(kind) ? kind : 'none'}`;
    $('#sbLeft').textContent = kind === 'laptop'
        ? `${extra.room ? extra.room + ' · ' : ''}${state.cfg.courtsName || 'HM Courts & Tribunals Service'} secure laptop`
        : `${state.cfg.serviceName || 'Ministry of Justice'} · Secure`;
    const tick = () => { const d = new Date(); $('#sbTime').textContent = `${pad(d.getHours())}:${pad(d.getMinutes())}`; };
    tick();
    clearInterval(clockTimer);
    clockTimer = setInterval(tick, 15000);
}
function hideDevice() { $('#device').classList.add('hidden'); clearInterval(clockTimer); }
$('#closeBtn').onclick = close;
document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    if (!modal.classList.contains('hidden')) closeModal(); else close();
});

/* ---------- shared bits ---------- */
const STATUS_TAG = { listed: 'blue', awaiting_trial: 'purple', awaiting_sentence: 'amber', sentenced: 'red', acquitted: 'green', discontinued: 'grey', dismissed: 'green' };
const caseStatus = (s) => tag(state.cfg.statuses?.[s] || s, STATUS_TAG[s] || '');
const CUSTODY_TAG = { remand: 'red', custody: 'red', at_large: 'red', police_custody: 'amber', court_bail: 'yellow', bail: 'yellow' };
const custodyTag = (s) => (s && s !== 'none' ? tag(state.cfg.custody?.[s] || s, CUSTODY_TAG[s] || 'grey') : '');
const hType = (t) => state.cfg.hearingTypes?.[t] || t;
const chargeList = (charges) => (charges || []).filter((c) => c.verdict !== 'withdrawn').map((c) => esc(c.offence)).join('<br>');
const courtLabel = (id) => (state.cfg.courts || []).find((c) => c.id === id)?.label || id || '';

function hearingsTable(rows, showCase = true) {
    if (!rows.length) return '<p class="empty">Nothing listed.</p>';
    return `<div class="table-wrap"><table><tr><th>Time</th>${showCase ? '<th>Case</th><th>Defendant</th>' : ''}<th>Hearing</th><th>Court</th><th>Custody</th><th></th></tr>
        ${rows.map((h) => {
            const late = h.status === 'listed' && h.scheduled_at < (state.serverTime || now()) - 600;
            return `<tr class="click" data-case="${h.case_id}"><td><strong>${fmtTime(h.scheduled_at)}</strong><br><span class="muted small">${fmtDate(h.scheduled_at, false)}</span></td>
            ${showCase ? `<td>${esc(h.ref)}</td><td><span class="dot ${h.online ? 'on' : ''}" title="${h.online ? 'In the city' : 'Not in the city'}"></span>${esc(h.subject_name)}<br><span class="muted small">${chargeList(h.charges)}</span></td>` : ''}
            <td>${esc(hType(h.type))}</td><td>${esc(courtLabel(h.court_id))}${h.room_id ? `<div class="muted small">${esc(((state.cfg.rooms || []).find((x) => x.id === h.room_id) || {}).label || '')}</div>` : ''}</td><td>${custodyTag(h.custody_status)}</td>
            <td>${h.status === 'open' ? tag(h.auto ? 'Auto court' : 'In court', 'green') : late ? tag('Waiting', 'red') : ''}</td></tr>`;
        }).join('')}</table></div>`;
}
function bindCaseRows(el) { $$('[data-case]', el).forEach((r) => (r.onclick = () => go('case', { id: Number(r.dataset.case) }))); }

/* ---------- overview ---------- */
VIEWS.dashboard = async () => {
    const r = await api('dashboard');
    if (r.error) return;
    const s = r.stats;
    main.innerHTML = `<div class="head"><div><span class="caption">${esc(state.me.label)}</span><h1>Overview</h1></div></div>
        <div class="stats">
            <div class="stat"><div class="v">${s.today}</div><div class="t">Hearings today</div></div>
            <div class="stat ${s.overdue ? 'red' : ''}"><div class="v">${s.overdue}</div><div class="t">Waiting for a judge</div></div>
            <div class="stat purple"><div class="v">${s.open}</div><div class="t">Open cases</div></div>
            <div class="stat red"><div class="v">${s.warrants}</div><div class="t">Active warrants</div></div>
            <div class="stat"><div class="v">${s.prisoners}</div><div class="t">In custody</div></div>
            <div class="stat green"><div class="v">${s.orders}</div><div class="t">Live orders</div></div>
        </div>
        ${state.cfg.autoCourt ? '<p class="muted small">Hearings no judge has opened are dealt with by the auto court after the grace period.</p>' : ''}
        ${r.myOrders ? `<h2>Your caseload</h2>${ordersTable(r.myOrders)}<p class="muted">${r.unassigned} orders have no responsible officer. <button class="link" id="goUn">View unassigned</button></p>` : ''}
        ${r.list ? `<h2>Coming up</h2>${hearingsTable(r.list)}` : ''}`;
    bindCaseRows(main);
    bindOrderRows(main);
    if ($('#goUn')) $('#goUn').onclick = () => go('probation', { filter: 'unassigned' });
};

/* ---------- court lists ---------- */
VIEWS.list = async (p) => {
    const day = p.day ?? 0;
    const courtId = p.courtId || '';
    const d = new Date(); d.setHours(0, 0, 0, 0); d.setDate(d.getDate() + day);
    const from = Math.floor(d.getTime() / 1000);
    const r = await api('courtList', { from: day === 0 ? from : from, to: from + 86400, courtId });
    if (r.error) return;
    const label = day === 0 ? 'Today' : day === 1 ? 'Tomorrow' : day === -1 ? 'Yesterday' : fmtDate(from, false);
    main.innerHTML = `<div class="head"><div><span class="caption">Daily cause list</span><h1>${esc(label)}</h1></div></div>
        <div class="toolbar">
            <div class="seg">${[-1, 0, 1, 2, 3, 4].map((n) => `<button data-day="${n}" class="${n === day ? 'on' : ''}">${n === 0 ? 'Today' : n === 1 ? 'Tomorrow' : n === -1 ? 'Yesterday' : fmtDate(from + (n - day) * 86400, false).slice(0, 5)}</button>`).join('')}</div>
            <div><label for="lCourt">Court</label><select id="lCourt"><option value="">All courts</option>${(state.cfg.courts || []).map((c) => `<option value="${esc(c.id)}" ${c.id === courtId ? 'selected' : ''}>${esc(c.label)}</option>`).join('')}</select></div>
        </div>
        ${hearingsTable(r.results)}`;
    $$('[data-day]').forEach((b) => (b.onclick = () => go('list', { day: Number(b.dataset.day), courtId })));
    $('#lCourt').onchange = (e) => go('list', { day, courtId: e.target.value });
    bindCaseRows(main);
};

/* ---------- cases ---------- */
VIEWS.cases = async (p) => {
    const status = p.status || 'open';
    const r = await api('searchCases', { q: p.q || '', status });
    if (r.error) return;
    main.innerHTML = `<div class="head"><div><span class="caption">${state.me.role === 'defence' ? 'Your clients' : 'All courts'}</span><h1>Cases</h1></div>
        <div class="actions">${can('judge', 'clerk', 'cps') ? '<button class="btn" id="newCase">Open a case</button>' : ''}</div></div>
        <div class="toolbar">
            <div style="flex:1"><label for="cQ">Search</label><input type="text" id="cQ" value="${esc(p.q || '')}" placeholder="Name, case number, custody reference or citizen ID"></div>
            <div class="seg">${[['open', 'Open'], ['closed', 'Concluded'], ['all', 'All']].map(([k, l]) => `<button data-st="${k}" class="${k === status ? 'on' : ''}">${l}</button>`).join('')}</div>
        </div>
        ${r.results.length ? `<div class="table-wrap"><table><tr><th>Case</th><th>Defendant</th><th>Charges</th><th>Court</th><th>Status</th><th>Custody</th></tr>
        ${r.results.map((c) => `<tr class="click" data-case="${c.id}"><td><strong>${esc(c.ref)}</strong><br><span class="muted small">${fmtDate(c.updated_at, false)}</span></td>
            <td>${esc(c.subject_name)}</td><td class="small">${chargeList(c.charges)}</td><td>${c.court_kind === 'crown' ? 'Crown' : "Magistrates'"}</td>
            <td>${caseStatus(c.status)}</td><td>${custodyTag(c.custody_status)}</td></tr>`).join('')}</table></div>` : '<p class="empty">No cases found.</p>'}`;
    let t;
    $('#cQ').oninput = (e) => { clearTimeout(t); t = setTimeout(() => go('cases', { q: e.target.value, status }).then(() => { const i = $('#cQ'); i.focus(); i.setSelectionRange(i.value.length, i.value.length); }), 350); };
    $$('[data-st]').forEach((b) => (b.onclick = () => go('cases', { q: p.q, status: b.dataset.st })));
    if ($('#newCase')) $('#newCase').onclick = newCaseModal;
    bindCaseRows(main);
};

function personPicker(box, onPick) {
    const input = $('#pp', box), out = $('#ppRes', box);
    let t;
    input.oninput = () => {
        clearTimeout(t);
        t = setTimeout(async () => {
            if (input.value.trim().length < 2) { out.innerHTML = ''; return; }
            const r = await api('searchPeople', { q: input.value }, true);
            out.innerHTML = (r.results || []).map((p) => `<button data-cid="${esc(p.cid)}" data-name="${esc(p.name)}">${esc(p.name)} <span class="muted small">${esc(p.cid)}${p.dob ? ` · ${esc(p.dob)}` : ''}</span></button>`).join('') || '<p class="empty" style="padding:8px">No one found.</p>';
            $$('button', out).forEach((b) => (b.onclick = () => { onPick(b.dataset.cid, b.dataset.name); out.innerHTML = ''; input.value = b.dataset.name; }));
        }, 300);
    };
}

function newCaseModal() {
    let cid = null;
    const charges = [];
    const box = openModal(`<h2>Open a case</h2><p class="lead">For a summons, or where the charge didn't come through the police MDT.</p>
        <label for="pp">Defendant</label><input type="text" id="pp" placeholder="Search by name or citizen ID"><div class="results" id="ppRes"></div>
        <label for="chSel">Charges</label><div class="inline-input"><select id="chSel">${(state.cfg.offences || []).map((o) => `<option>${esc(o.name)}</option>`).join('')}</select><button class="btn secondary small" id="chAdd">Add charge</button></div>
        <div class="chips" id="chips"></div>
        <div class="grid2"><div><label for="nKind">Court</label><select id="nKind"><option value="">Decide from the charges</option><option value="magistrates">Magistrates' court</option><option value="crown">Crown Court</option></select></div>
        <div><label for="nAt">First hearing</label><input type="datetime-local" id="nAt"><div class="hint">Empty = next sitting after the usual notice.</div></div></div>
        <label for="nSum">Case summary</label><textarea id="nSum"></textarea>
        <div id="nErr"></div><div class="btn-row"><button class="btn" id="nGo">Open case</button><button class="btn secondary" id="nCancel">Cancel</button></div>`);
    personPicker(box, (c) => (cid = c));
    const drawChips = () => ($('#chips', box).innerHTML = charges.map((c, i) => `<span class="chip">${esc(c)}<button data-rm="${i}">&times;</button></span>`).join(''));
    $('#chAdd', box).onclick = () => { const v = $('#chSel', box).value; if (!charges.includes(v)) charges.push(v); drawChips(); bindRm(); };
    const bindRm = () => $$('[data-rm]', box).forEach((b) => (b.onclick = () => { charges.splice(Number(b.dataset.rm), 1); drawChips(); bindRm(); }));
    $('#nCancel', box).onclick = closeModal;
    $('#nGo', box).onclick = async () => {
        const r = await api('createCase', { cid, charges, courtKind: $('#nKind', box).value, at: fromInput($('#nAt', box).value), summary: $('#nSum', box).value }, true);
        if (r.error) { $('#nErr', box).innerHTML = `<p class="err">${esc(r.error)}</p>`; return; }
        closeModal(); toast('Case opened and listed.'); go('case', { id: r.id });
    };
}

/* ---------- case ---------- */
const PLEA = { guilty: 'Guilty', not_guilty: 'Not guilty' };
const VERDICT = { guilty: ['Convicted', 'red'], not_guilty: ['Acquitted', 'green'], withdrawn: ['Withdrawn', 'grey'] };

VIEWS.case = async (p) => {
    const r = await api('getCase', { id: p.id });
    if (r.error) return go('cases');
    const c = r.case;
    state.case = c;
    const open = c.hearings.find((h) => h.status === 'open');
    const next = c.hearings.filter((h) => h.status === 'listed').sort((a, b) => a.scheduled_at - b.scheduled_at)[0];
    const closed = ['sentenced', 'acquitted', 'discontinued', 'dismissed'].includes(c.status);
    const activeWarrants = (c.warrants || []).filter((w) => w.status === 'active');

    main.innerHTML = `<div class="head"><div><span class="caption">${esc(c.courtLabel)} · ${esc(c.ref)}</span><h1>${esc(c.subject_name)}</h1>
            <div class="chips" style="margin-top:8px">${caseStatus(c.status)} ${custodyTag(c.custody_status)} ${c.online ? tag('In the city', 'green') : ''}</div></div>
        <div class="actions">
            ${can('judge', 'clerk') ? '<button class="btn secondary small" id="aList">List a hearing</button><button class="btn secondary small" id="aSol">Defence solicitor</button>' : ''}
            ${can('cps') && !closed ? '<button class="btn warning small" id="aWd">Withdraw or discontinue</button>' : ''}
            ${can('judge', 'clerk', 'cps') ? '<button class="btn secondary small" id="aNote">Add note</button>' : ''}
            ${can('judge', 'clerk', 'cps', 'defence') ? '<button class="btn secondary small" id="aGuide">Sentencing guide</button>' : ''}
        </div></div>
        ${activeWarrants.map((w) => `<div class="banner red"><strong>${esc(state.cfg.warrantTypes?.[w.type] || w.type)}</strong>${esc(w.reason || '')} <span class="muted">(${fmtDate(w.created_at)})</span></div>`).join('')}
        ${c.custodyNow ? `<div class="banner amber"><strong>In custody: ${esc(state.cfg.prisonKinds?.[c.custodyNow.kind] || c.custodyNow.kind)}</strong>${c.custodyNow.kind === 'remand' ? 'Held on remand until the court decides.' : `${Math.max(0, c.custodyNow.release_minutes - c.custodyNow.served_minutes)} minutes left before release.`}</div>` : ''}
        ${open ? hearingPanel(c, open) : ''}
        ${!open && next ? `<div class="panel"><h3>Next hearing</h3><p style="margin:0"><strong>${esc(hType(next.type))}</strong> on ${fmtDate(next.scheduled_at)} at ${esc(courtLabel(next.court_id))}</p>
            ${next.scheduled_at < now() - 60 ? `<p class="muted small">Due. ${state.cfg.autoCourt ? 'The auto court will take it if no judge opens it.' : ''}</p>` : ''}
            <div class="btn-row">${can('judge') ? `<button class="btn" data-openh="${next.id}">Open hearing</button>` : ''}${can('judge', 'clerk') ? `<button class="btn secondary" data-vacate="${next.id}">Vacate</button>` : ''}</div></div>` : ''}
        <div class="cols"><div>
            <h2>Charges</h2>
            <table><tr><th>Offence</th><th>Plea</th><th>Outcome</th></tr>
            ${c.charges.map((ch) => `<tr><td>${esc(ch.offence)}</td><td>${ch.plea ? esc(PLEA[ch.plea]) + (ch.pleaStage ? ` <span class="muted small">(${esc(ch.pleaStage)})</span>` : '') : '<span class="muted">Not yet entered</span>'}</td>
                <td>${ch.verdict ? tag(VERDICT[ch.verdict][0], VERDICT[ch.verdict][1]) : ''}</td></tr>`).join('')}</table>
            ${c.summary && c.log ? `<h2>Case summary</h2><div class="inset" style="white-space:pre-wrap">${esc(c.summary)}</div>` : ''}
            ${(c.evidence || []).length ? `<h2>Evidence</h2><table><tr><th>Type</th><th>Detail</th></tr>${c.evidence.map((e) => `<tr><td>${esc(e.type)}</td><td>${esc(e.detail)}</td></tr>`).join('')}</table>` : ''}
            ${(c.statements || []).length ? `<h2>Witness statements (MG11)</h2>${c.statements.map((s) => `<div class="statement"><strong>${esc(s.maker_name)}</strong> <span class="muted small">${esc(s.kind)}${s.occupation ? `, ${esc(s.occupation)}` : ''} · signed ${fmtDate(s.signed_at)}</span><br>${esc(s.body)}</div>`).join('')}` : ''}
            ${exhibitsHtml('case', c)}
            ${c.sentences.length ? `<h2>Sentence</h2>${c.sentences.map((s) => `<div class="panel"><strong>${esc(s.summary)}</strong><p class="muted small" style="margin:6px 0 0">${s.auto ? 'Auto court' : esc(s.passed_by)} · ${fmtDate(s.created_at)}</p>${s.components?.remarks ? `<div class="inset">${esc(s.components.remarks)}</div>` : ''}</div>`).join('')}` : ''}
            ${c.orders.length ? `<h2>Orders</h2>${ordersTable(c.orders)}` : ''}
            ${c.fines.length ? `<h2>Financial orders</h2>${finesTable(c.fines)}` : ''}
        </div><div>
            <h2>Details</h2>
            <dl class="summary">
                <dt>Citizen ID</dt><dd>${esc(c.cid)}</dd>
                <dt>Court</dt><dd>${esc(c.courtLabel)}</dd>
                <dt>Custody</dt><dd>${esc(c.custodyLabel)}</dd>
                ${(c.bail_conditions || []).length ? `<dt>Bail conditions</dt><dd>${c.bail_conditions.map((b) => `${esc(b.label)}${b.value ? `: ${esc(b.value)}` : ''}`).join('<br>')}</dd>` : ''}
                <dt>Prosecutor</dt><dd>${esc(c.prosecutor || 'Crown Prosecution Service')}</dd>
                <dt>Defence</dt><dd>${esc(c.solicitor_name || 'Unrepresented')}</dd>
                <dt>Officer in case</dt><dd>${esc(c.officer_name || '')}</dd>
                ${c.custody_ref ? `<dt>Custody record</dt><dd>${esc(c.custody_ref)}</dd>` : ''}
                <dt>Opened</dt><dd>${fmtDate(c.created_at)}</dd>
            </dl>
            <h2>Hearings</h2>
            ${c.hearings.length ? `<ul class="log">${c.hearings.map((h) => `<li><strong>${esc(hType(h.type))}</strong> · ${fmtDate(h.scheduled_at)} ${hearingStatus(h)}
                ${h.judge_name ? `<div class="meta">${h.auto ? 'Auto court' : esc(h.judge_name)}</div>` : ''}${h.result ? `<div class="small">${esc(h.result)}</div>` : ''}</li>`).join('')}</ul>` : '<p class="empty">None.</p>'}
            ${c.log ? `<h2>Case log</h2><ul class="log">${c.log.slice().reverse().map((l) => `<li><div class="meta">${fmtDate(l.at)} · ${esc(l.by)}</div>${esc(l.text)}</li>`).join('')}</ul>` : ''}
        </div></div>`;

    bindOrderRows(main);
    $$('[data-openh]').forEach((b) => (b.onclick = async () => { const x = await api('openHearing', { id: Number(b.dataset.openh) }); if (x.ok) { toast('Hearing opened. The defendant has been told.'); refresh(); } }));
    $$('[data-vacate]').forEach((b) => (b.onclick = () => formModal('Vacate hearing', [{ id: 'reason', label: 'Reason', type: 'text' }], 'Vacate', async (v) => {
        const x = await api('vacateHearing', { id: Number(b.dataset.vacate), reason: v.reason }, true); if (x.ok) { toast('Hearing vacated.'); refresh(); } return x;
    })));
    if ($('#aList')) $('#aList').onclick = () => listModal(c);
    if ($('#aSol')) $('#aSol').onclick = () => solicitorModal(c);
    if ($('#aNote')) $('#aNote').onclick = () => formModal('Add a note to the case', [{ id: 'text', label: 'Note', type: 'textarea' }], 'Add note', async (v) => {
        const x = await api('caseNote', { id: c.id, text: v.text }, true); if (x.ok) refresh(); return x;
    });
    if ($('#aWd')) $('#aWd').onclick = () => withdrawModal(c);
    if ($('#aGuide')) $('#aGuide').onclick = () => sentenceModal(c, null);
    if (open) bindHearing(c, open);
    bindExhibits('case', c);
};

function hearingStatus(h) {
    const m = { listed: ['Listed', 'blue'], open: ['In court', 'green'], done: ['Heard', 'grey'], adjourned: ['Adjourned', 'purple'], fta: ['Failed to appear', 'red'], vacated: ['Vacated', 'grey'] };
    const [t, col] = m[h.status] || [h.status, ''];
    return tag(t, col);
}

function listModal(c) {
    formModal('List a hearing', [
        { id: 'type', label: 'Hearing', type: 'select', options: Object.entries(state.cfg.hearingTypes).map(([value, label]) => ({ value, label })), value: c.status === 'awaiting_trial' ? 'trial' : c.status === 'awaiting_sentence' ? 'sentence' : 'mention' },
        { id: 'courtId', label: 'Court', type: 'select', options: state.cfg.courts.map((x) => ({ value: x.id, label: x.label })), value: c.court_id },
        { id: 'roomId', label: 'Courtroom', type: 'select', hint: 'Shown on listing boards. Must be a courtroom of the court above. Set automatically when a judge opens the hearing from a courtroom laptop.',
          options: [{ value: '', label: 'Not decided yet' }].concat((state.cfg.rooms || []).map((x) => ({ value: x.id, label: `${x.label} (${courtLabel(x.court_id)})` }))) },
        { id: 'at', label: 'Date and time', type: 'datetime', value: now() + 3600 },
    ], 'List hearing', async (v) => {
        const x = await api('listHearing', { id: c.id, ...v, roomId: v.roomId ? Number(v.roomId) : null }, true); if (x.ok) { toast('Listed. The defendant has been notified.'); refresh(); } return x;
    });
}

function solicitorModal(c) {
    let cid = null;
    const box = openModal(`<h2>Defence solicitor</h2><p>Currently: <strong>${esc(c.solicitor_name || 'Unrepresented')}</strong></p>
        <label for="pp">Assign a solicitor</label><input type="text" id="pp" placeholder="Search by name"><div class="results" id="ppRes"></div>
        <div id="sErr"></div><div class="btn-row"><button class="btn" id="sGo">Assign</button>${c.solicitor_cid ? '<button class="btn warning" id="sRm">Remove</button>' : ''}<button class="btn secondary" id="sNo">Cancel</button></div>`);
    personPicker(box, (x) => (cid = x));
    $('#sNo', box).onclick = closeModal;
    $('#sGo', box).onclick = async () => { if (!cid) return; const x = await api('assignSolicitor', { id: c.id, cid }); if (x.ok) { closeModal(); refresh(); } };
    if ($('#sRm', box)) $('#sRm', box).onclick = async () => { const x = await api('assignSolicitor', { id: c.id }); if (x.ok) { closeModal(); refresh(); } };
}

function withdrawModal(c) {
    const opts = [{ value: '', label: 'Discontinue the whole case' }].concat(
        c.charges.map((ch, i) => (!ch.verdict ? { value: String(i + 1), label: `Withdraw: ${ch.offence}` } : null)).filter(Boolean));
    formModal('Withdraw or discontinue', [
        { id: 'index', label: 'What', type: 'select', options: opts },
        { id: 'reason', label: 'Reason', type: 'textarea', hint: 'Recorded on the case and given to the court.' },
    ], 'Confirm', async (v) => {
        const x = await api('withdraw', { id: c.id, index: v.index ? Number(v.index) : null, reason: v.reason }, true);
        if (x.ok) { toast('Done.'); refresh(); } return x;
    });
}

/* ---------- the hearing (judge) ---------- */
function hearingPanel(c, h) {
    if (h.auto) return `<div class="panel hearing"><h2>${esc(hType(h.type))}: auto court</h2><p>The auto court is dealing with this hearing now.</p></div>`;
    if (!can('judge')) return `<div class="panel hearing"><h2>${esc(hType(h.type))} in progress</h2><p>Before ${esc(h.judge_name || 'the court')}.</p></div>`;
    const needPlea = c.charges.filter((ch) => !ch.plea && !ch.verdict);
    const needVerdict = c.charges.filter((ch) => ch.plea === 'not_guilty' && !ch.verdict);
    const closed = ['sentenced', 'acquitted', 'discontinued', 'dismissed'].includes(c.status);
    let n = 0;
    const step = (title, body) => `<div class="step"><h3><span class="num">${++n}</span>${title}</h3>${body}</div>`;
    const typeOpts = Object.entries(state.cfg.hearingTypes).map(([v, l]) => `<option value="${v}" ${v === (needVerdict.length ? 'trial' : c.status === 'awaiting_sentence' ? 'sentence' : 'mention') ? 'selected' : ''}>${esc(l)}</option>`).join('');
    const breachOrder = h.type === 'breach' ? (c.orders || []).find((o) => o.id === h.order_id) : null;

    return `<div class="panel hearing"><h2>${esc(hType(h.type))}: in court</h2>
        <p class="muted" style="margin-top:-4px">${esc(c.courtLabel)} · opened by ${esc(h.judge_name || '')} · defendant ${c.online ? 'in the city' : '<strong>not in the city</strong>'}</p>
        ${step('Attendance', `${c.production ? (h.booked_at
                ? `<p class="small" style="margin:2px 0 6px">${tag('Booked in', 'green')} at the court custody desk ${fmtTime(h.booked_at)} by ${esc(h.booked_by || '')}${h.booking_notes ? ` · ${esc(h.booking_notes)}` : ''}</p>`
                : `<div class="inset" style="margin:4px 0 8px"><strong>${esc(c.productionLabel)}.</strong> Not booked in yet. They must be booked in at the court custody desk before they can be marked present.</div>`) : ''}
            <div class="btn-row" style="margin-top:4px"><button class="btn secondary small" id="hPresent" ${c.production && !h.booked_at ? 'disabled' : ''}>Defendant present</button>
            ${c.production === 'custody' && !h.booked_at ? '<span class="muted small">In custody: if they can\'t be produced, adjourn below.</span>' : '<button class="btn warning small" id="hFta">Failed to appear (warrant)</button>'}</div>`)}
        ${needPlea.length ? step('Pleas', `${needPlea.map((ch) => { const i = c.charges.indexOf(ch) + 1; return `<div class="inline-input" style="margin:6px 0"><span>${esc(ch.offence)}</span>
            <select data-plea="${i}"><option value="">Choose</option><option value="guilty">Guilty</option><option value="not_guilty">Not guilty</option></select></div>`; }).join('')}
            <div class="btn-row"><button class="btn small" id="hPlea">Enter pleas</button></div>`) : ''}
        ${needVerdict.length ? step('Trial verdicts', `${needVerdict.map((ch) => { const i = c.charges.indexOf(ch) + 1; return `<div class="inline-input" style="margin:6px 0"><span>${esc(ch.offence)}</span>
            <select data-verdict="${i}"><option value="">Choose</option><option value="guilty">Guilty</option><option value="not_guilty">Not guilty</option></select></div>`; }).join('')}
            <div class="btn-row"><button class="btn small" id="hVerdict">Record verdicts</button></div>`) : ''}
        ${!closed ? step('Bail', `<div class="checks">
            <label><input type="radio" name="bd" value="unconditional"> Unconditional bail</label>
            <label><input type="radio" name="bd" value="conditional" ${c.custody_status === 'court_bail' || c.custody_status === 'bail' ? 'checked' : ''}> Conditional bail</label>
            <label><input type="radio" name="bd" value="remand" ${c.custody_status === 'remand' ? 'checked' : ''}> Remand in custody</label></div>
            <div id="bConds" class="checks">${state.cfg.bailConditions.map((b) => { const cur = (c.bail_conditions || []).find((x) => x.id === b.id);
                return `<div class="inline-input"><label><input type="checkbox" data-bc="${b.id}" ${cur ? 'checked' : ''}> ${esc(b.label)}</label>${b.input ? `<input type="text" data-bcv="${b.id}" value="${esc(cur?.value || '')}" placeholder="${esc(b.placeholder || '')}">` : '<span></span>'}</div>`; }).join('')}</div>
            <div class="btn-row"><button class="btn secondary small" id="hBail">Record bail decision</button></div>`) : ''}
        ${c.status === 'awaiting_sentence' && h.type !== 'breach' ? step('Sentence', `<p class="muted" style="margin:0">Convicted of ${c.charges.filter((x) => x.verdict === 'guilty').length} offence(s).</p><div class="btn-row"><button class="btn" id="hSentence">Sentence</button></div>`) : ''}
        ${h.type === 'breach' ? step('Breach', breachOrder ? `<p style="margin:0">${esc(breachOrder.kindLabel)} ${esc(breachOrder.ref || '')}: ${breachOrder.hours_done}/${breachOrder.hours_required} hours done, ${breachOrder.warnings} warnings.</p>
            <div class="grid2"><div><label for="bAct">Deal with the breach</label><select id="bAct">
                <option value="extra_hours">Add unpaid work hours, order continues</option>
                ${breachOrder.kind === 'suspended' ? `<option value="activate">Activate the suspended sentence (${breachOrder.custody_months} months)</option>` : ''}
                <option value="resentence">Revoke and resentence</option><option value="revoke_only">Revoke the order, no further penalty</option>
                <option value="no_action">Not proved / no action</option></select></div>
            <div><label for="bHrs">Extra hours</label><input type="number" id="bHrs" value="20" min="1"></div></div>
            <div class="btn-row"><button class="btn small" id="hBreach">Confirm</button></div>` : '<p class="muted">The order could not be found.</p>') : ''}
        ${step('Adjourn or conclude', `<div class="grid3"><div><label for="aType">Next hearing</label><select id="aType">${typeOpts}</select></div>
            <div><label for="aAt">When</label><input type="datetime-local" id="aAt"><div class="hint">Empty = next available slot</div></div>
            <div><label for="aWhy">Reason</label><input type="text" id="aWhy" placeholder="e.g. for trial, reports"></div></div>
            <div class="btn-row"><button class="btn secondary small" id="hAdj">Adjourn</button><button class="btn secondary small" id="hEnd">Conclude hearing</button></div>`)}
    </div>`;
}

function bindHearing(c, h) {
    if (h.auto || !can('judge')) return;
    const id = h.id;
    const done = (msg) => (x) => { if (x.ok) { toast(msg); refresh(); } };
    if ($('#hPresent')) $('#hPresent').onclick = async () => done('Recorded.')(await api('appearance', { id, present: true }));
    if ($('#hFta')) $('#hFta').onclick = () => confirmModal('Record that the defendant failed to appear? A warrant will be issued and police told.', async () => done('Warrant issued.')(await api('appearance', { id, present: false })), 'Issue warrant', true);
    if ($('#hPlea')) $('#hPlea').onclick = async () => {
        const pleas = {}; $$('[data-plea]').forEach((s) => { if (s.value) pleas[s.dataset.plea] = s.value; });
        done('Pleas entered.')(await api('plea', { id, pleas }));
    };
    if ($('#hVerdict')) $('#hVerdict').onclick = async () => {
        const verdicts = {}; $$('[data-verdict]').forEach((s) => { if (s.value) verdicts[s.dataset.verdict] = s.value; });
        done('Verdicts recorded.')(await api('verdict', { id, verdicts }));
    };
    if ($('#hBail')) $('#hBail').onclick = async () => {
        const decision = ($('input[name=bd]:checked') || {}).value;
        if (!decision) return toast('Choose a bail decision.', true);
        const conditions = $$('[data-bc]').filter((b) => b.checked).map((b) => ({ id: b.dataset.bc, value: ($(`[data-bcv="${b.dataset.bc}"]`) || {}).value }));
        done('Bail decision recorded.')(await api('bail', { id: c.id, decision, conditions }));
    };
    if ($('#hSentence')) $('#hSentence').onclick = () => sentenceModal(c, h);
    if ($('#hBreach')) $('#hBreach').onclick = async () => {
        const action = $('#bAct').value;
        if (action === 'resentence') return sentenceModal(c, h, true);
        done('Breach dealt with.')(await api('breach', { id, action, hours: Number($('#bHrs').value) }));
    };
    $('#hAdj').onclick = async () => done('Adjourned and relisted.')(await api('adjourn', { id, type: $('#aType').value, at: fromInput($('#aAt').value), reason: $('#aWhy').value }));
    $('#hEnd').onclick = () => formModal('Conclude hearing', [{ id: 'result', label: 'Result', type: 'text', placeholder: 'e.g. Bail extended, no further hearing needed today' }], 'Conclude', async (v) => {
        const x = await api('concludeHearing', { id, result: v.result }, true); if (x.ok) refresh(); return x;
    });
}

/* ---------- sentencing (guide for everyone, the form for a judge in a hearing) ---------- */
function guideHtml(g) {
    if (!g) return '<p class="empty">No guide available.</p>';
    return `<div class="guide"><div class="muted small">Guideline outcome</div><div class="big">${esc(g.outcomeLabel)}${g.custodyMonths ? `: ${g.custodyMonths} months` : ''}${g.hours ? `, ${g.hours} hours unpaid work` : ''}${g.fine ? `, ${money(g.fine)} fine` : ''}</div>
        <div class="small" style="margin-top:6px">${esc(g.plea)} (${g.reduction}% credit) · ${g.previous} previous conviction${g.previous === 1 ? '' : 's'}${g.banMonths ? ` · disqualification ${g.banMonths} months` : ''}${g.points ? ` · ${g.points} points` : ''}</div>
        ${g.factors.length ? `<div class="small muted" style="margin-top:4px">Factors: ${g.factors.map(esc).join('; ')}</div>` : ''}
        ${g.notes.map((n) => `<p class="err" style="margin-top:8px">${esc(n)}</p>`).join('')}</div>
        <table><tr><th>Offence</th><th>Venue</th><th>Maximum</th><th class="num">Months</th><th class="num">Fine</th></tr>
        ${g.perOffence.map((o) => `<tr><td>${esc(o.offence)}${o.notes ? `<div class="muted small">${esc(o.notes)}</div>` : ''}${o.driving ? `<div class="small">${esc(o.driving)}</div>` : ''}</td><td>${esc(o.court)}</td><td>${esc(o.max)}</td><td class="num">${o.months}</td><td class="num">${o.fine ? money(o.fine) : ''}</td></tr>`).join('')}</table>`;
}

async function sentenceModal(c, h, breachResentence = false) {
    const judging = h && can('judge');
    const factors = (list, kind) => list.filter((f) => !f.auto).map((f) => `<label><input type="checkbox" data-${kind}="${f.id}"> ${esc(f.label)}</label>`).join('');
    const box = openModal(`<h2>${judging ? 'Sentence' : 'Sentencing guide'}: ${esc(c.subject_name)}</h2>
        <p class="lead">${esc(c.ref)} · ${esc(c.courtLabel)}. Guidance only: the court decides the sentence.</p>
        <div class="cols"><div>
            <div id="gOut"><p class="muted">Working it out…</p></div>
            <h3 style="margin-top:16px">Adjust the guide</h3>
            <div class="grid2"><div class="checks"><strong class="small">Aggravating</strong>${factors(state.cfg.aggravating, 'agg')}</div>
            <div class="checks"><strong class="small">Mitigating</strong>${factors(state.cfg.mitigating, 'mit')}</div></div>
            <label for="gPlea">Plea</label><select id="gPlea"><option value="">As recorded on the case</option>${state.cfg.pleas.map((p) => `<option value="${p.id}">${esc(p.label)}</option>`).join('')}</select>
            <div class="btn-row"><button class="btn secondary small" id="gRe">Recalculate</button></div>
        </div>
        ${judging ? `<div><h3>Sentence of the court</h3>
            <label for="sOut">Disposal</label><select id="sOut">${Object.entries(state.cfg.outcomes).map(([v, l]) => `<option value="${v}">${esc(l)}</option>`).join('')}</select>
            <div class="grid2"><div><label for="sMonths">Custody (months)</label><input type="number" id="sMonths" min="0" value="0"></div>
            <div><label for="sSus">Suspended for (days)</label><input type="number" id="sSus" min="0" value="${state.cfg.suspendDays || 14}"></div></div>
            <label for="sHours">Unpaid work (hours)</label><input type="number" id="sHours" min="0" value="0">
            <div class="checks"><strong class="small">Requirements</strong>
                <div class="inline-input"><label><input type="checkbox" id="rCur"> Curfew</label><span class="inline-input"><input type="text" id="rFrom" value="21:00"><input type="text" id="rTo" value="07:00"></span></div>
                <div class="inline-input"><label><input type="checkbox" id="rExc"> Exclusion zone</label><select id="rZone">${(state.cfg.zones || []).map((z) => `<option value="${esc(z.id)}">${esc(z.label)}</option>`).join('')}</select></div>
                <label><input type="checkbox" id="rSup"> Supervision by the Probation Service</label>
            </div>
            <div class="grid3"><div><label for="sFine">Fine</label><input type="number" id="sFine" min="0" value="0"></div>
            <div><label for="sComp">Compensation</label><input type="number" id="sComp" min="0" value="0"></div>
            <div><label for="sCosts">Costs</label><input type="number" id="sCosts" min="0" value="0"></div></div>
            <div class="grid3"><div><label for="sBan">Ban (months)</label><input type="number" id="sBan" min="0" value="0"></div>
            <div><label for="sPts">Points</label><input type="number" id="sPts" min="0" max="12" value="0"></div>
            <div><label for="sCode">DVLA code</label><input type="text" id="sCode" placeholder="e.g. DD40"></div></div>
            <label for="sRem">Sentencing remarks</label><textarea id="sRem"></textarea>
            <div id="sErr"></div>
            <div class="btn-row"><button class="btn" id="sGo">Pass sentence</button><button class="btn secondary" id="sNo">Cancel</button></div>
        </div>` : '<div><div class="btn-row"><button class="btn secondary" id="sNo">Close</button></div></div>'}</div>`, true);

    const fill = (g) => {
        if (!judging || !g) return;
        $('#sOut', box).value = g.outcome;
        $('#sMonths', box).value = g.custodyMonths || 0;
        $('#sSus', box).value = g.suspendDays || state.cfg.suspendDays || 14;
        $('#sHours', box).value = g.hours || 0;
        $('#sFine', box).value = g.fine || 0;
        $('#sBan', box).value = g.banMonths || 0;
        $('#sPts', box).value = g.points || 0;
        $('#sCode', box).value = g.code || '';
    };
    const load = async (first) => {
        const r = await api('guide', {
            id: c.id, plea: $('#gPlea', box).value || undefined,
            aggravating: $$('[data-agg]', box).filter((x) => x.checked).map((x) => x.dataset.agg),
            mitigating: $$('[data-mit]', box).filter((x) => x.checked).map((x) => x.dataset.mit),
        });
        $('#gOut', box).innerHTML = guideHtml(r.guide);
        if (first || judging) fill(r.guide);
    };
    $('#gRe', box).onclick = () => load(false);
    $('#sNo', box).onclick = closeModal;
    if (judging) {
        $('#sGo', box).onclick = async () => {
            const requirements = [];
            if ($('#rCur', box).checked) requirements.push({ type: 'curfew', from: $('#rFrom', box).value.trim(), to: $('#rTo', box).value.trim() });
            if ($('#rExc', box).checked) requirements.push({ type: 'exclusion', zone: $('#rZone', box).value });
            if ($('#rSup', box).checked) requirements.push({ type: 'supervision' });
            const components = {
                outcome: $('#sOut', box).value, custodyMonths: Number($('#sMonths', box).value), suspendDays: Number($('#sSus', box).value),
                hours: Number($('#sHours', box).value), requirements, fine: Number($('#sFine', box).value), compensation: Number($('#sComp', box).value),
                costs: Number($('#sCosts', box).value), banMonths: Number($('#sBan', box).value), points: Number($('#sPts', box).value),
                code: $('#sCode', box).value.trim(), remarks: $('#sRem', box).value,
            };
            $('#sGo', box).disabled = true;
            const r = breachResentence
                ? await api('breach', { id: h.id, action: 'resentence', components }, true)
                : await api('sentence', { id: h.id, components }, true);
            $('#sGo', box).disabled = false;
            if (r.error) { $('#sErr', box).innerHTML = `<p class="err">${esc(r.error)}</p>`; return; }
            closeModal();
            toast(`Sentence passed: ${r.summary || 'recorded'}`);
            (r.notes || []).forEach((n, i) => setTimeout(() => toast(n, /NOT/.test(n)), 3600 * (i + 1)));
            refresh();
        };
    }
    load(true);
}

/* ---------- shared tables ---------- */
const ORDER_TAG = { active: 'green', completed: 'grey', breached: 'red', revoked: 'red' };
function ordersTable(rows) {
    if (!rows.length) return '<p class="empty">None.</p>';
    return `<div class="table-wrap"><table><tr><th>Order</th><th>Offender</th><th>Unpaid work</th><th>Warnings</th><th>Ends</th><th>Status</th></tr>
        ${rows.map((o) => `<tr class="click" data-order="${o.id}"><td><strong>${esc(o.ref || '')}</strong><br><span class="small">${esc(state.cfg.orderKinds?.[o.kind] || o.kind)}</span></td>
        <td>${o.online !== undefined ? `<span class="dot ${o.online ? 'on' : ''}"></span>` : ''}${esc(o.subject_name)}${o.officer_name ? `<br><span class="muted small">${esc(o.officer_name)}</span>` : ''}</td>
        <td>${o.hours_required ? `${o.hours_done} / ${o.hours_required}<div class="progress"><div style="width:${Math.min(100, (o.hours_done / o.hours_required) * 100)}%"></div></div>` : '<span class="muted">None</span>'}</td>
        <td>${o.warnings ? tag(String(o.warnings), 'amber') : '0'}</td><td>${o.ends_at ? fmtDate(o.ends_at, false) : ''}</td>
        <td>${o.status ? tag(o.status, ORDER_TAG[o.status] || '') : ''}</td></tr>`).join('')}</table></div>`;
}
function bindOrderRows(el) {
    if (!can('probation', 'judge')) return;
    $$('[data-order]', el).forEach((r) => (r.onclick = () => go('order', { id: Number(r.dataset.order) })));
}
const FINE_TAG = { unpaid: 'blue', default: 'red', paid: 'green', written_off: 'grey' };
const FINE_LABEL = { fine: 'Fine', compensation: 'Compensation', surcharge: 'Victim surcharge', costs: 'Costs' };
function finesTable(rows, actions = '') {
    if (!rows.length) return '<p class="empty">None.</p>';
    return `<div class="table-wrap"><table><tr><th>Reference</th>${actions === 'staff' ? '<th>Person</th>' : ''}<th>Type</th><th class="num">Amount</th><th>Due</th><th>Status</th><th></th></tr>
        ${rows.map((f) => `<tr><td>${esc(f.ref || '')}</td>${actions === 'staff' ? `<td>${esc(f.subject_name)}</td>` : ''}<td>${esc(FINE_LABEL[f.kind] || f.kind)}</td>
        <td class="num">${money(f.amount)}${f.amount !== f.original ? `<br><span class="muted small">was ${money(f.original)}</span>` : ''}</td>
        <td>${f.due_at ? fmtDate(f.due_at, false) : ''}</td><td>${tag(f.status === 'default' ? 'In default' : f.status.replace('_', ' '), FINE_TAG[f.status] || '')}</td>
        <td>${actions === 'staff' && can('judge') && (f.status === 'unpaid' || f.status === 'default') ? `<button class="btn secondary small" data-wo="${f.id}">Write off</button>` : ''}
            ${actions === 'portal' && (f.status === 'unpaid' || f.status === 'default') ? `<button class="btn small" data-pay="${f.id}">Pay ${money(f.amount)}</button>` : ''}</td></tr>`).join('')}</table></div>`;
}

/* ---------- warrants ---------- */
VIEWS.warrants = async (p) => {
    const status = p.status || 'active';
    const r = await api('warrants', { status });
    if (r.error) return;
    main.innerHTML = `<div class="head"><div><span class="caption">Issued by the court</span><h1>Warrants</h1></div></div>
        <div class="toolbar"><div class="seg">${[['active', 'Active'], ['closed', 'Executed or cancelled']].map(([k, l]) => `<button data-ws="${k}" class="${k === status ? 'on' : ''}">${l}</button>`).join('')}</div></div>
        ${state.cfg.mdt ? '<p class="muted small">Active warrants also show on the police MDT. When police mark one executed there, the case comes back before the court.</p>' : ''}
        ${r.results.length ? `<div class="table-wrap"><table><tr><th>Issued</th><th>Person</th><th>Type</th><th>Reason</th><th>Status</th><th></th></tr>
        ${r.results.map((w) => `<tr><td>${fmtDate(w.created_at)}</td><td>${esc(w.subject_name || w.cid)}</td><td>${esc(state.cfg.warrantTypes?.[w.type] || w.type)}</td>
            <td class="small">${esc(w.reason || '')}${w.case_id ? `<br><button class="link small" data-case-link="${w.case_id}">View case</button>` : ''}</td>
            <td>${tag(w.status, w.status === 'active' ? 'red' : w.status === 'executed' ? 'green' : 'grey')}${w.closed_by ? `<div class="muted small">${esc(w.closed_by)}</div>` : ''}</td>
            <td style="white-space:nowrap">${w.status === 'active' ? `${can('judge', 'clerk', 'police', 'prison') ? `<button class="btn small" data-wx="${w.id}">Executed</button> ` : ''}${can('judge') || (can('clerk') && state.me.supervisor) ? `<button class="btn secondary small" data-wc="${w.id}">Cancel</button>` : ''}` : ''}</td></tr>`).join('')}</table></div>`
            : '<p class="empty">No warrants.</p>'}`;
    $$('[data-ws]').forEach((b) => (b.onclick = () => go('warrants', { status: b.dataset.ws })));
    $$('[data-case-link]').forEach((b) => (b.onclick = () => go('case', { id: Number(b.dataset.caseLink) })));
    $$('[data-wx]').forEach((b) => (b.onclick = () => confirmModal('Mark this warrant executed? The case will be listed straight back before the court.', async () => {
        const x = await api('executeWarrant', { id: Number(b.dataset.wx) }); if (x.ok) { toast('Warrant executed.'); refresh(); }
    }, 'Executed')));
    $$('[data-wc]').forEach((b) => (b.onclick = () => confirmModal('Cancel this warrant?', async () => {
        const x = await api('cancelWarrant', { id: Number(b.dataset.wc) }); if (x.ok) { toast('Warrant cancelled.'); refresh(); }
    }, 'Cancel warrant', true)));
};

/* ---------- prison ---------- */
VIEWS.prison = async () => {
    const r = await api('prisonRoll');
    if (r.error) return;
    main.innerHTML = `<div class="head"><div><span class="caption">${esc(r.prison)}</span><h1>Prison roll</h1></div></div>
        <p class="lead">Time is served while the prisoner is in the city. ${r.minutesPerMonth} minute${r.minutesPerMonth === 1 ? '' : 's'} per month of sentence.
            Prisoners are held by <strong>${esc(r.holder === 'builtin' ? 'the built-in prison' : r.holder === 'vinewood_prison' ? 'Vinewood HMP' : r.holder)}</strong>.</p>
        ${r.results.length ? `<div class="table-wrap"><table><tr><th>Prisoner</th><th>Type</th><th>Received</th><th class="num">Served</th><th class="num">Left</th><th></th></tr>
        ${r.results.map((p) => `<tr><td><span class="dot ${p.online ? 'on' : ''}"></span>${esc(p.subject_name || p.cid)}${p.prisonNo ? ` <span class="muted small">${esc(p.prisonNo)}${p.cell ? ` · ${esc(p.cell)}` : ''}</span>` : ''}${p.liveStatus === 'ual' ? ' ' + tag('Unlawfully at large', 'red') : ''}${p.release_reason ? `<div class="muted small">${esc(p.release_reason)}</div>` : ''}</td>
            <td>${tag(state.cfg.prisonKinds?.[p.kind] || p.kind, p.kind === 'remand' ? 'amber' : p.kind === 'recall' ? 'purple' : 'red')}</td>
            <td>${fmtDate(p.created_at)}</td><td class="num">${p.served_minutes} min</td>
            <td class="num">${p.kind === 'remand' ? '<span class="muted">Until court</span>' : `${p.leftLive ?? Math.max(0, p.release_minutes - p.served_minutes)} min`}</td>
            <td>${can('judge') || (can('prison') && state.me.supervisor) ? `<button class="btn secondary small" data-rel="${p.id}">Release</button>` : ''}
                ${p.case_id && can('judge', 'clerk', 'police', 'probation') ? `<button class="link small" data-case-link="${p.case_id}">Case</button>` : ''}</td></tr>`).join('')}</table></div>`
            : '<p class="empty">No one is in custody.</p>'}`;
    $$('[data-case-link]').forEach((b) => (b.onclick = () => go('case', { id: Number(b.dataset.caseLink) })));
    $$('[data-rel]').forEach((b) => (b.onclick = () => formModal('Release from custody', [{ id: 'reason', label: 'Reason', type: 'text', placeholder: 'e.g. Bail granted on appeal, sentence varied' }],
        'Release', async (v) => { const x = await api('releasePrisoner', { id: Number(b.dataset.rel), reason: v.reason }, true); if (x.ok) { toast('Released.'); refresh(); } return x; },
        '<p class="lead">Sentenced prisoners released early go onto licence.</p>')));
};

/* ---------- fines ---------- */
VIEWS.fines = async (p) => {
    const status = p.status || 'unpaid';
    const r = await api('fines', { status });
    if (r.error) return;
    main.innerHTML = `<div class="head"><div><span class="caption">Financial orders</span><h1>Fines</h1></div></div>
        <div class="toolbar"><div class="seg">${[['unpaid', 'Outstanding'], ['default', 'In default'], ['paid', 'Paid']].map(([k, l]) => `<button data-fs="${k}" class="${k === status ? 'on' : ''}">${l}</button>`).join('')}</div></div>
        ${finesTable(r.results, 'staff')}`;
    $$('[data-fs]').forEach((b) => (b.onclick = () => go('fines', { status: b.dataset.fs })));
    $$('[data-wo]').forEach((b) => (b.onclick = () => confirmModal('Write off this amount?', async () => {
        const x = await api('writeOffFine', { id: Number(b.dataset.wo) }); if (x.ok) { toast('Written off.'); refresh(); }
    }, 'Write off', true)));
};

/* ---------- probation ---------- */
VIEWS.probation = async (p) => {
    const filter = p.filter || (can('probation') ? 'mine' : 'all');
    const r = await api('caseload', { filter, q: p.q || '' });
    if (r.error) return;
    main.innerHTML = `<div class="head"><div><span class="caption">Probation Service</span><h1>Caseload</h1></div></div>
        <div class="toolbar">
            <div class="seg">${[['mine', 'Mine'], ['unassigned', 'Unassigned'], ['all', 'All live'], ['closed', 'Ended']].filter(([k]) => can('probation') || k !== 'mine').map(([k, l]) => `<button data-pf="${k}" class="${k === filter ? 'on' : ''}">${l}</button>`).join('')}</div>
            <div style="flex:1"><label for="pQ">Search</label><input type="text" id="pQ" value="${esc(p.q || '')}" placeholder="Name or order reference"></div>
        </div>
        ${ordersTable(r.results)}`;
    $$('[data-pf]').forEach((b) => (b.onclick = () => go('probation', { filter: b.dataset.pf, q: p.q })));
    let t;
    $('#pQ').oninput = (e) => { clearTimeout(t); t = setTimeout(() => go('probation', { filter, q: e.target.value }).then(() => { const i = $('#pQ'); i.focus(); i.setSelectionRange(i.value.length, i.value.length); }), 350); };
    bindOrderRows(main);
};

VIEWS.order = async (p) => {
    const r = await api('getOrder', { id: p.id });
    if (r.error) return go('probation');
    const o = r.order;
    const live = o.status === 'active';
    const prob = can('probation');
    const reqRow = (q, i) => {
        let detail = '', act = '';
        if (q.type === 'curfew') {
            detail = q.coords ? '<span class="tag green">Tag active</span>' : '<span class="tag amber">No address set: not monitored</span>';
            if (prob && live) act = `<button class="btn secondary small" data-loc="curfew" data-from="me">Address = my position</button> <button class="btn secondary small" data-loc="curfew" data-from="offender" ${o.online ? '' : 'disabled'}>Address = offender's position</button>`;
        } else if (q.type === 'exclusion') {
            detail = `${q.radius ? `${Math.round(q.radius)} m zone` : ''} ${q.coords ? '<span class="tag green">Tag active</span>' : ''}`;
        }
        return `<tr><td>${esc(q.label || q.type)}</td><td>${detail}</td><td style="text-align:right">${act}</td></tr>`;
    };
    const warnLimit = state.cfg.warnLimit || 2;
    main.innerHTML = `<div class="head"><div><span class="caption">${esc(o.kindLabel)} · ${esc(o.ref || '')}</span><h1>${esc(o.subject_name)}</h1>
            <div class="chips" style="margin-top:8px">${tag(o.status, ORDER_TAG[o.status] || '')} ${o.online ? tag('In the city', 'green') : ''} ${o.warnings ? tag(`${o.warnings} warning${o.warnings === 1 ? '' : 's'}`, 'amber') : ''}</div></div>
        <div class="actions">${prob && live ? `
            ${o.officer_cid !== state.me.cid ? '<button class="btn small" id="oTake">Take this case</button>' : ''}
            <button class="btn secondary small" id="oNote">Contact note</button>
            <button class="btn secondary small" id="oBook">Book appointment</button>
            ${o.hours_required ? '<button class="btn secondary small" id="oHrs">Credit hours</button>' : ''}
            <button class="btn secondary small" id="oZone">Add exclusion zone here</button>
            <button class="btn warning small" id="oWarn">Warning</button>
            <button class="btn warning small" id="oBreach">${o.kind === 'licence' ? 'Recall to prison' : 'Breach to court'}</button>` : ''}
            ${live && (state.me.supervisor || can('judge')) ? '<button class="btn secondary small" id="oEnd">End early</button>' : ''}
        </div></div>
        <div class="cols"><div>
            ${o.hours_required ? `<h2>Unpaid work</h2><p style="margin:0"><strong>${o.hours_done}</strong> of ${o.hours_required} hours done</p>
                <div class="progress"><div style="width:${Math.min(100, (o.hours_done / o.hours_required) * 100)}%"></div></div>` : ''}
            <h2>Requirements</h2>
            ${(o.requirements || []).length ? `<table>${o.requirements.map(reqRow).join('')}</table>` : '<p class="empty">No requirements beyond keeping out of trouble.</p>'}
            <h2>Appointments</h2>
            ${o.appointments.length ? `<table><tr><th>When</th><th>Where</th><th>Status</th><th></th></tr>${o.appointments.map((a) => `<tr><td>${fmtDate(a.at)}</td><td>${esc(a.location || '')}</td>
                <td>${tag(a.status, a.status === 'attended' ? 'green' : a.status === 'missed' ? 'red' : a.status === 'cancelled' ? 'grey' : 'blue')}${a.notes ? `<div class="small muted">${esc(a.notes)}</div>` : ''}</td>
                <td style="white-space:nowrap;text-align:right">${prob && a.status === 'booked' ? `<button class="btn small" data-ap="${a.id}" data-st="attended">Attended</button> <button class="btn warning small" data-ap="${a.id}" data-st="missed">Missed</button> <button class="btn secondary small" data-ap="${a.id}" data-st="cancelled">Cancel</button>` : ''}</td></tr>`).join('')}</table>`
                : '<p class="empty">None booked.</p>'}
        </div><div>
            <h2>Details</h2>
            <dl class="summary">
                <dt>Order</dt><dd>${esc(o.kindLabel)}</dd>
                ${o.sentence ? `<dt>Sentence</dt><dd>${esc(o.sentence.summary)}<div class="muted small">${esc(o.sentence.passed_by || '')}, ${fmtDate(o.sentence.created_at, false)}</div></dd>` : ''}
                ${o.case ? `<dt>Case</dt><dd><button class="link" id="oCase">${esc(o.case.ref)}</button><div class="small">${chargeList(o.case.charges)}</div></dd>` : ''}
                ${o.custody_months ? `<dt>Suspended term</dt><dd>${o.custody_months} months</dd>` : ''}
                <dt>Responsible officer</dt><dd>${esc(o.officer_name || 'Not assigned')}</dd>
                <dt>Warnings</dt><dd>${o.warnings || 0} (breach action at ${warnLimit})</dd>
                <dt>Made</dt><dd>${fmtDate(o.created_at)}</dd>
                <dt>Ends</dt><dd>${o.ends_at ? fmtDate(o.ends_at) : 'When the hours are done'}</dd>
            </dl>
            <h2>Contact log</h2>
            <ul class="log">${(o.log || []).slice().reverse().map((l) => `<li><div class="meta">${fmtDate(l.at)} · ${esc(l.by)}</div>${esc(l.text)}</li>`).join('')}</ul>
        </div></div>`;

    const done = (msg) => (x) => { if (x.ok) { toast(msg); refresh(); } return x; };
    if ($('#oCase')) $('#oCase').onclick = () => go('case', { id: o.case.id });
    if ($('#oTake')) $('#oTake').onclick = async () => done('You are now the responsible officer.')(await api('takeOrder', { id: o.id }));
    if ($('#oNote')) $('#oNote').onclick = () => formModal('Contact note', [{ id: 'text', label: 'Note', type: 'textarea' }], 'Save', async (v) => done('Saved.')(await api('orderNote', { id: o.id, text: v.text }, true)));
    if ($('#oBook')) $('#oBook').onclick = () => formModal('Book an appointment', [
        { id: 'at', label: 'Date and time', type: 'datetime', value: now() + 3600 },
        { id: 'location', label: 'Where', type: 'text', value: state.cfg.office || '' },
    ], 'Book', async (v) => done('Booked. The offender has been told.')(await api('bookAppointment', { id: o.id, ...v }, true)));
    if ($('#oHrs')) $('#oHrs').onclick = () => formModal('Credit unpaid work hours', [{ id: 'hours', label: 'Hours', type: 'number', value: 4, min: 1 }], 'Credit',
        async (v) => done('Hours credited.')(await api('creditHours', { id: o.id, hours: v.hours }, true)), '<p class="lead">For work supervised in person rather than through the work sites.</p>');
    if ($('#oZone')) $('#oZone').onclick = () => formModal('Exclusion zone at your position', [
        { id: 'label', label: 'Name of the area', type: 'text', placeholder: 'e.g. Victim\'s address, Vanilla Unicorn' },
        { id: 'radius', label: 'Radius (metres)', type: 'number', value: 120, min: 20 },
    ], 'Add zone', async (v) => done('Zone added. The tag is monitoring it.')(await api('setLocation', { id: o.id, kind: 'exclusion', from: 'me', ...v }, true)));
    if ($('#oWarn')) $('#oWarn').onclick = () => formModal('Formal warning', [{ id: 'reason', label: 'Reason', type: 'textarea' }], 'Issue warning',
        async (v) => done('Warning issued.')(await api('warnOrder', { id: o.id, reason: v.reason }, true)), `<p class="lead">At ${warnLimit} warnings breach action is taken automatically.</p>`);
    if ($('#oBreach')) $('#oBreach').onclick = () => formModal(o.kind === 'licence' ? 'Recall to prison' : 'Breach proceedings', [{ id: 'reason', label: 'Reason', type: 'textarea' }],
        o.kind === 'licence' ? 'Recall' : 'Send to court', async (v) => done(o.kind === 'licence' ? 'Recalled.' : 'Breach listed before the court.')(await api('breachOrder', { id: o.id, reason: v.reason }, true)),
        `<p class="lead">${o.kind === 'licence' ? 'The offender returns to prison for a fixed term. If they are not in the city a recall warrant is issued.' : 'A breach hearing is listed on the original case.'}</p>`);
    if ($('#oEnd')) $('#oEnd').onclick = () => formModal('End the order early', [{ id: 'reason', label: 'Reason', type: 'text' }], 'End order',
        async (v) => done('Order ended.')(await api('completeOrder', { id: o.id, reason: v.reason }, true)));
    $$('[data-loc]').forEach((b) => (b.onclick = async () => done('Curfew address set. The tag is live.')(await api('setLocation', { id: o.id, kind: 'curfew', from: b.dataset.from === 'offender' ? 'offender' : 'me' }))));
    $$('[data-ap]').forEach((b) => (b.onclick = () => {
        if (b.dataset.st === 'attended') return api('markAppointment', { id: Number(b.dataset.ap), status: 'attended' }).then(done('Recorded.'));
        formModal(b.dataset.st === 'missed' ? 'Missed appointment' : 'Cancel appointment', [{ id: 'notes', label: 'Notes', type: 'text' }], 'Save',
            async (v) => done(b.dataset.st === 'missed' ? 'Recorded. A warning has been issued.' : 'Cancelled.')(await api('markAppointment', { id: Number(b.dataset.ap), status: b.dataset.st, notes: v.notes }, true)));
    }));
};

/* ---------- public portal (/mycase) ---------- */
VIEWS.portal = async () => {
    const r = await portalApi('load');
    if (r.error) return;
    state.data = r;
    state.cfg = r.cfg;
    drawShell();
    const cases = r.cases || [];
    const upcoming = cases.filter((c) => c.next).sort((a, b) => a.next.scheduled_at - b.next.scheduled_at);
    const owed = (r.fines || []).filter((f) => f.status === 'unpaid' || f.status === 'default');
    const work = (r.orders || []).filter((o) => o.hours_required > o.hours_done);
    const custody = r.custody;
    main.innerHTML = `<div class="head"><div><span class="caption">${esc(r.cfg.courtsName)}</span><h1>Your justice account</h1></div>
        <div class="actions"><button class="btn secondary small" id="pRef">Refresh</button></div></div>
        ${custody ? `<div class="banner amber"><strong>You are in custody</strong>${custody.kind === 'remand' ? 'You are remanded until your next court hearing.' : `${Math.max(0, custody.release_minutes - custody.served_minutes)} minutes left to serve in the city.`}</div>` : ''}
        ${(r.warrants || []).map((w) => `<div class="banner red"><strong>There is a warrant for your arrest</strong>${esc(r.cfg.warrantTypes?.[w.type] || '')}. Hand yourself in at a police station as soon as possible.</div>`).join('')}

        <h2>Court dates</h2>
        ${upcoming.length ? `<table><tr><th>When</th><th>Hearing</th><th>Where</th><th>Case</th><th></th></tr>${upcoming.map((c) => {
            const court = (r.cfg.courts || []).find((x) => x.id === c.next.court_id);
            return `<tr><td><strong>${fmtDate(c.next.scheduled_at)}</strong></td><td>${esc(r.cfg.hearingTypes?.[c.next.type] || c.next.type)}</td><td>${esc(court?.label || '')}</td><td>${esc(c.ref)}</td>
            <td>${court ? `<button class="btn secondary small" data-court="${esc(court.id)}">Set waypoint</button>` : ''}</td></tr>`; }).join('')}</table>
            <p class="small muted">If you do not attend, a warrant can be issued for your arrest. If no judge is sitting, your case may be dealt with by the court system and you will be asked for your plea.</p>`
            : '<p class="empty">You have no court dates.</p>'}

        ${work.length ? `<h2>Unpaid work</h2>${work.map((o) => `<div class="panel"><strong>${esc(r.cfg.orderKinds?.[o.kind] || o.kind)} ${esc(o.ref || '')}</strong>
            <p style="margin:6px 0 0">${o.hours_done} of ${o.hours_required} hours done. Each task counts for ${r.cfg.hoursPerTask} hours.</p>
            <div class="progress"><div style="width:${Math.min(100, (o.hours_done / o.hours_required) * 100)}%"></div></div></div>`).join('')}
            <table><tr><th>Work site</th><th>Task</th><th></th></tr>${(r.cfg.sites || []).map((s, i) => `<tr><td>${esc(s.label)}</td><td>${esc(s.task || '')}</td>
            <td style="text-align:right;white-space:nowrap"><button class="btn secondary small" data-site-wp="${i + 1}">Set waypoint</button> <button class="btn small" data-site="${i + 1}">Start work here</button></td></tr>`).join('')}</table>
            <p class="small muted">Go to the site, then start work. You can also type /unpaidwork at any site.</p>` : ''}

        ${(r.orders || []).length ? `<h2>Your orders</h2><table><tr><th>Order</th><th>Requirements</th><th>Ends</th><th>Warnings</th></tr>${r.orders.map((o) => `<tr>
            <td><strong>${esc(r.cfg.orderKinds?.[o.kind] || o.kind)}</strong><br><span class="muted small">${esc(o.ref || '')}</span></td>
            <td>${(o.requirements || []).map((q) => esc(q.label)).join('<br>') || '<span class="muted">None</span>'}${o.officer_name ? `<div class="small muted">Probation officer: ${esc(o.officer_name)}</div>` : ''}</td>
            <td>${o.ends_at ? fmtDate(o.ends_at) : 'When the hours are done'}</td><td>${o.warnings || 0}</td></tr>`).join('')}</table>` : ''}

        ${(r.appointments || []).length ? `<h2>Probation appointments</h2><table><tr><th>When</th><th>Where</th></tr>${r.appointments.map((a) => `<tr><td>${fmtDate(a.at)}</td><td>${esc(a.location || '')}</td></tr>`).join('')}</table>` : ''}

        <h2>Fines and payments</h2>
        ${owed.length ? `<p>You owe <strong>${money(owed.reduce((s, f) => s + f.amount, 0))}</strong>. Unpaid fines go up and can lead to a warrant.</p>` : ''}
        ${finesTable(r.fines || [], 'portal')}

        ${(r.civil || []).length || r.cfg.litigantInPerson || r.cfg.businessCanIssue ? `<h2>Civil claims</h2>
            ${r.cfg.litigantInPerson || r.cfg.businessCanIssue ? '<div class="btn-row" style="margin:0 0 10px"><button class="btn secondary small" id="pIssue">Take someone to court</button></div>' : ''}
            ${(r.civil || []).length ? `<table><tr><th>Claim</th><th>Parties</th><th>Status</th><th></th></tr>${r.civil.map((c) => {
                const payer = (c.judgment && c.judgment.payer) || 'defendant';
                const owe = c.status === 'judgment' && payer === c.side ? Math.max(0, c.total_due - c.paid) : 0;
                const due = c.status === 'issued' && c.side === 'defendant';
                return `<tr><td><strong>${esc(c.ref)}</strong><br><span class="muted small">${esc(c.typeLabel || '')}</span></td>
                <td>${partyName(c, 'claimant')} <span class="muted">v</span> ${partyName(c, 'defendant')}<div class="small muted">${c.forBusiness ? `${esc(c.forBusiness)} is the ${c.side}` : `You are the ${c.side}`}</div></td>
                <td>${tag(c.statusLabel || c.status, CIVIL_TAG[c.status] || '')}${c.ccj ? ' ' + tag('CCJ', 'red') : ''}
                    ${due ? `<div class="small"><strong>Respond by ${fmtDate(c.response_due)}</strong></div>` : ''}
                    ${c.status === 'listed' && c.hearing_at ? `<div class="small">Hearing ${fmtDate(c.hearing_at)}</div>` : ''}
                    ${c.judgment && c.judgment.order ? `<div class="small">Order: ${esc(c.judgment.order)}</div>` : ''}
                    ${c.status === 'judgment' && payer !== c.side ? `<div class="small">${money(Math.max(0, c.total_due - c.paid))} still owed to ${c.forBusiness ? esc(c.forBusiness) : 'you'} · due ${fmtDate(c.judgment_due, false)}</div>` : ''}</td>
                <td style="white-space:nowrap;text-align:right">${due ? `<button class="btn small" data-cresp="${c.id}">Respond</button>` : ''}
                    ${owe ? `<button class="btn small" data-cpay="${c.id}" data-owe="${owe}">Pay ${money(owe)}</button>` : ''}
                    ${c.side === 'claimant' && ['issued', 'defended', 'listed'].includes(c.status) ? `<button class="btn secondary small" data-cend="${c.id}">Withdraw or settle</button>` : ''}</td></tr>`;
            }).join('')}</table>` : '<p class="empty">No civil claims.</p>'}` : ''}

        <h2>Your cases</h2>
        ${cases.length ? `<table><tr><th>Case</th><th>Charges</th><th>Status</th></tr>${cases.map((c) => `<tr><td><strong>${esc(c.ref)}</strong><br><span class="muted small">${esc(c.courtLabel || '')}</span></td>
            <td class="small">${chargeList(c.charges)}</td><td>${tag(r.cfg.statuses?.[c.status] || c.status, STATUS_TAG[c.status] || '')}${c.solicitor_name ? `<div class="small muted">Solicitor: ${esc(c.solicitor_name)}</div>` : ''}</td></tr>`).join('')}</table>`
            : '<p class="empty">You have no court cases.</p>'}`;

    $('#pRef').onclick = () => VIEWS.portal();
    $$('[data-cresp]').forEach((b) => (b.onclick = () => formModal('Respond to the claim', [
        { id: 'kind', label: 'Your response', type: 'select', options: [{ value: 'defend', label: 'I dispute the claim (defend it)' }, { value: 'admit', label: 'I admit the whole claim' }] },
        { id: 'text', label: 'Why you dispute it, or a note with your admission', type: 'textarea' },
    ], 'Send response', async (v) => { const x = await portalApi('civilRespond', { id: Number(b.dataset.cresp), ...v }); if (x.ok) { toast('Response sent to the court.'); VIEWS.portal(); } return x; },
        '<p class="lead">If you admit it, judgment is entered against you and you will need to pay. If you defend it, the court will list a hearing.</p>')));
    $$('[data-cpay]').forEach((b) => (b.onclick = () => formModal('Pay a County Court judgment', [
        { id: 'amount', label: `Amount (up to ${money(Number(b.dataset.owe))})`, type: 'number', value: Number(b.dataset.owe), min: 1 },
    ], 'Pay', async (v) => { const x = await portalApi('civilPay', { id: Number(b.dataset.cpay), amount: v.amount }); if (x.ok) { toast(x.satisfied ? 'Paid in full. The judgment is satisfied.' : 'Payment made.'); VIEWS.portal(); } return x; },
        '<p class="lead">The money goes straight to the other party. Paying in full stops a CCJ being registered, or marks it satisfied.</p>')));
    $$('[data-cend]').forEach((b) => (b.onclick = () => formModal('Withdraw or settle', [
        { id: 'status', label: 'Outcome', type: 'select', options: [{ value: 'settled', label: "We've settled it between us" }, { value: 'withdrawn', label: 'Withdraw my claim' }] },
        { id: 'reason', label: 'Note', type: 'text' },
    ], 'Confirm', async (v) => { const x = await portalApi('civilEnd', { id: Number(b.dataset.cend), ...v }); if (x.ok) { toast('Done.'); VIEWS.portal(); } return x; })));
    if ($('#pIssue')) $('#pIssue').onclick = () => issueClaimModal((x) => portalApi('civilIssue', x), (q, kind) => portalApi('searchPeople', { q, kind }), (x) => portalApi('civilFee', x), () => VIEWS.portal(),
        { inPerson: r.cfg.litigantInPerson, business: r.cfg.businessCanIssue ? r.business : null });
    $$('[data-pay]').forEach((b) => (b.onclick = () => confirmModal(`Pay ${b.textContent.replace('Pay ', '')} from your bank account?`, async () => {
        const x = await portalApi('pay', { id: Number(b.dataset.pay) }); if (x.ok) { toast('Paid. Thank you.'); VIEWS.portal(); }
    }, 'Pay now')));
    $$('[data-court]').forEach((b) => (b.onclick = () => {
        const court = (r.cfg.courts || []).find((x) => x.id === b.dataset.court);
        post('portal', { action: 'courtWaypoint', data: { id: court.id } }); toast('Waypoint set.');
    }));
    $$('[data-site-wp]').forEach((b) => (b.onclick = () => { portalApi('waypoint', { site: Number(b.dataset.siteWp) }); toast('Waypoint set.'); }));
    $$('[data-site]').forEach((b) => (b.onclick = () => post('startWork', { site: Number(b.dataset.site) })));
};


/* ---------- courtroom setup (/courtrooms, admins) ---------- */
async function roomsApi(action, data = {}, quiet = false) {
    const r = (await post('rooms', { action, data })) || {};
    if (r.error && !quiet) toast(r.error, true);
    return r;
}
const ICON = {
    laptop: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="4" width="16" height="11" rx="1"/><path d="M2 19h20"/></svg>',
    mic: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="3" width="6" height="11" rx="3"/><path d="M5 11a7 7 0 0 0 14 0M12 18v3"/></svg>',
    custody: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="10" width="14" height="10" rx="1"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg>',
};
const POINT_NAME = { laptop: 'Laptop', mic: 'Microphone', custody: 'Custody desk', screen: 'Screen' };
ICON.screen = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="12" rx="1"/><path d="M8 20h8M12 16v4"/></svg>';

VIEWS.rooms = async (p = {}) => {
    const r = await roomsApi('list');
    if (r.error) return close();
    state.rooms = r;
    state.cfg = Object.assign({}, state.cfg, { courts: r.courts });
    if (p.open) return VIEWS.room({ id: p.open });
    state.view = 'rooms';
    drawShell();
    const courtName = (id) => (r.courts || []).find((c) => c.id === id)?.label || id || '';
    const KIND_TAG = { magistrates: 'blue', crown: 'purple', county: 'green' };
    main.innerHTML = `<div class="head"><div><span class="caption">Server admin</span><h1>Courts and courtrooms</h1></div></div>
        <h2 style="margin-top:0">Courts</h2>
        <p class="lead">The courts cases are heard in. Each court can have one or more courtrooms. A court's waypoint is where defendants are sent if it has no courtroom yet.</p>
        <table><tr><th>Court</th><th>Type</th><th class="num">Courtrooms</th><th>Custody desk</th><th>Waypoint</th><th></th></tr>
            ${(r.courts || []).map((c) => `<tr><td><strong>${esc(c.label)}</strong>${c.civilDefault ? ' ' + tag('Civil default', 'green') : ''}<div class="muted small">${esc(c.id)}</div></td>
            <td>${tag(c.kindLabel || c.kind, KIND_TAG[c.kind] || '')}</td><td class="num">${c.rooms}</td>
            <td>${c.desks ? tag(c.desks === 1 ? '1 desk' : c.desks + ' desks', 'green') : c.kind === 'county' ? '<span class="muted">Not needed</span>' : '<span class="muted">None</span>'}
                ${c.kind !== 'county' ? ` <button class="link small" data-cdesk="${esc(c.id)}">Place a desk</button>` : ''}</td>
            <td>${c.hasCoords ? 'Set' : c.rooms ? '<span class="muted">Uses its courtroom</span>' : '<span class="muted">Not set</span>'}</td>
            <td style="white-space:nowrap;text-align:right"><button class="btn secondary small" data-cedit="${esc(c.id)}">Edit</button> <button class="btn warning small" data-cdel="${esc(c.id)}">Delete</button></td></tr>`).join('')}</table>
        <div class="btn-row" style="margin-bottom:8px"><button class="btn secondary" id="cNew">New court</button></div>
        ${(r.courts || []).some((c) => (c.deskList || []).length) ? `<h3 style="margin-top:18px">Custody desks</h3>
            <p class="lead" style="margin-bottom:8px">One per court building's custody suite (or more for a big building). Defendants are booked in here and the officer picks their courtroom.</p>
            <table><tr><th>Court</th><th>Desk</th><th>How</th><th></th></tr>${(r.courts || []).flatMap((c) => (c.deskList || []).map((d, i) => `<tr>
                <td>${esc(c.label)}</td><td><strong>${esc(d.label || 'Custody suite')}</strong></td>
                <td>${d.mode === 'pick' ? tag('Map object', 'blue') : d.prop ? tag('Spawned', 'green') : '<span class="muted small">Marked spot</span>'}</td>
                <td style="white-space:nowrap;text-align:right"><button class="btn secondary small" data-dtp="${esc(c.id)}:${i + 1}">Go to</button>
                    <button class="btn warning small" data-drm="${esc(c.id)}:${i + 1}">Remove</button></td></tr>`)).join('')}</table>` : ''}
        <div class="head" style="margin-top:28px;margin-bottom:10px"><h2 style="margin:0">Courtrooms</h2><div class="actions"><button class="btn secondary" id="rShowAll">Show all room areas</button><button class="btn" id="rNew">New courtroom here</button></div></div>
        ${(r.overlaps || []).map((o) => `<div class="banner amber"><strong>${esc(o.a)} and ${esc(o.b)} overlap</strong>${o.shapes < 2
            ? "At least one of them is still a circle. Open each room and use <b>Draw the room's shape</b> so its area follows the walls."
            : 'Their drawn shapes cross. Open one and redraw it so the walls line up.'} Until then, screens and microphones in the overlap use whichever room is the better match.</div>`).join('')}
        <p class="lead">Stand in the middle of the room in game and create it. Then place laptops on the desks and microphones by the bench, witness box, dock and advocates' seats.</p>
        ${!r.voice ? '<div class="banner red"><strong>pma-voice is not running</strong>Microphones need pma-voice to carry voices across the room.</div>' : ''}
        ${!r.target ? '<div class="banner amber"><strong>ox_target is not running</strong>Laptops and microphones fall back to an E prompt.</div>' : ''}
        ${r.rooms.length ? `<table><tr><th>Courtroom</th><th>Court</th><th>Area</th><th class="num">Laptops</th><th class="num">Microphones</th></tr>
            ${r.rooms.map((x) => `<tr class="click" data-room="${x.id}"><td><strong>${esc(x.label)}</strong></td><td>${esc(courtName(x.court_id))}</td>
            <td>${x.shape ? tag(`Shape · ${x.shape.points.length} corners`, 'green') : tag(`Circle · ${Math.round(x.radius)} m`, 'amber')}</td><td class="num">${(x.points || []).filter((q) => q.kind === 'laptop').length}</td>
            <td class="num">${(x.points || []).filter((q) => q.kind === 'mic').length}</td></tr>`).join('')}</table>`
            : '<p class="empty">No courtrooms yet.</p>'}
        <div class="head" style="margin-top:28px;margin-bottom:10px"><h2 style="margin:0">Listing boards</h2><div class="actions"><button class="btn" id="bNew">Place a listing board</button></div></div>
        <p class="lead">TVs in hallways and foyers showing today's list: time, courtroom, case, hearing and whether it's in court now.</p>
        ${(r.boards || []).length ? `<table><tr><th>Board</th><th>Shows</th><th>Names</th><th>Picture</th><th></th></tr>${r.boards.map((b) => `<tr>
            <td><strong>${esc(b.label)}</strong><div class="muted small">${b.point && b.point.mode === 'pick' ? 'TV in the map' : 'Spawned TV'}</div></td>
            <td class="small">${(b.courts || []).length ? b.courts.map(courtName).map(esc).join('<br>') : 'All courts'}</td>
            <td class="small">${esc(((r.nameStyles || []).find((x) => x.id === b.names) || {}).label || b.names)}</td>
            <td>${b.point && b.point.geo ? tag('Fitted', 'green') : tag('Not fitted', 'amber')}</td>
            <td style="white-space:nowrap;text-align:right"><button class="btn secondary small" data-badj="${b.id}">Adjust picture</button> <button class="btn secondary small" data-btp="${b.id}">Go to</button>
                <button class="btn secondary small" data-bedit="${b.id}">Edit</button> <button class="btn warning small" data-brm="${b.id}">Remove</button></td></tr>`).join('')}</table>`
            : '<p class="empty">No listing boards yet.</p>'}`;
    $$('[data-room]').forEach((t) => (t.onclick = () => VIEWS.room({ id: Number(t.dataset.room) })));
    $('#rShowAll').onclick = () => post('roomsShowArea', {});
    const boardForm = (b) => {
        const courtChecks = (r.courts || []).map((c) => `<label><input type="checkbox" data-bcourt="${esc(c.id)}" ${b && (b.courts || []).includes(c.id) ? 'checked' : ''}> ${esc(c.label)}</label>`).join('');
        const box = openModal(`<h2>${b ? 'Edit listing board' : 'Place a listing board'}</h2>
            <label for="bLabel">Name</label><input type="text" id="bLabel" value="${esc(b ? b.label : '')}" placeholder="e.g. Ground floor foyer, Crown Court corridor">
            <label>Courts it shows</label><div class="hint">None ticked = every court.</div><div class="checks">${courtChecks}</div>
            <label for="bNames">Defendant names</label><select id="bNames">${(r.nameStyles || []).map((x) => `<option value="${esc(x.id)}" ${(b ? b.names : 'full') === x.id ? 'selected' : ''}>${esc(x.label)}</option>`).join('')}</select>
            <div class="hint">Businesses in civil cases are always shown in full.</div>
            ${b ? '' : `<label>How to place it</label><div class="checks">
                <label><input type="radio" name="bMode" value="pick" checked> <strong>Use a TV already in the building</strong> (aim at it, E to choose)</label>
                <label><input type="radio" name="bMode" value="spawn"> <strong>Spawn a TV</strong></label></div>
                <div id="bModelWrap" class="hidden"><label for="bModel">TV model</label><select id="bModel">${(r.screens || []).map((m) => `<option value="${m.index}">${esc(m.label)}</option>`).join('')}</select></div>
                <div class="inset small">Then fit the list to the screen: <strong>←/→</strong> width, <strong>↑/↓</strong> height, <strong>Shift</strong> to move, scroll in or out, <strong>F</strong> other side, <strong>E</strong> to save.</div>`}
            <div id="bErr"></div><div class="btn-row"><button class="btn" id="bGo">${b ? 'Save' : 'Select it in the building'}</button><button class="btn secondary" id="bNo">Cancel</button></div>`);
        $$('input[name=bMode]', box).forEach((x) => (x.onchange = () => {
            const spawn = ($('input[name=bMode]:checked', box) || {}).value === 'spawn';
            $('#bModelWrap', box).classList.toggle('hidden', !spawn);
            $('#bGo', box).textContent = spawn ? 'Place it' : 'Select it in the building';
        }));
        $('#bNo', box).onclick = closeModal;
        $('#bGo', box).onclick = async () => {
            const label = $('#bLabel', box).value.trim();
            if (!label) { $('#bErr', box).innerHTML = '<p class="err">Give the board a name.</p>'; return; }
            const courts = $$('[data-bcourt]', box).filter((x) => x.checked).map((x) => x.dataset.bcourt);
            const names = $('#bNames', box).value;
            if (b) {
                const x = await roomsApi('boardUpdate', { boardId: b.id, label, courts, names }, true);
                if (x.error) { $('#bErr', box).innerHTML = `<p class="err">${esc(x.error)}</p>`; return; }
                closeModal(); VIEWS.rooms(); return;
            }
            const mode = ($('input[name=bMode]:checked', box) || {}).value || 'pick';
            const model = Number($('#bModel', box).value);
            closeModal();
            post('boardPlace', { label, courts, names, mode, model });
        };
    };
    $('#bNew').onclick = () => boardForm(null);
    $$('[data-bedit]').forEach((x) => (x.onclick = () => boardForm((r.boards || []).find((b) => b.id === Number(x.dataset.bedit)))));
    $$('[data-badj]').forEach((x) => (x.onclick = () => post('boardAdjust', { boardId: Number(x.dataset.badj) })));
    $$('[data-btp]').forEach((x) => (x.onclick = async () => { const y = await roomsApi('boardTeleport', { boardId: Number(x.dataset.btp) }); if (y.ok) toast('Teleported.'); }));
    $$('[data-brm]').forEach((x) => (x.onclick = () => confirmModal('Remove this listing board?', async () => {
        const y = await roomsApi('boardRemove', { boardId: Number(x.dataset.brm) }); if (y.ok) VIEWS.rooms();
    }, 'Remove', true)));
    const courtForm = (c) => {
        const box = formModal(c ? `Edit ${c.label}` : 'New court', [
            { id: 'label', label: 'Name', type: 'text', value: c ? c.label : '', placeholder: "e.g. Sandy Shores Magistrates' Court" },
            { id: 'kind', label: 'Type', type: 'select', options: (r.kinds || []).map((k) => ({ value: k.id, label: k.label })), value: c ? c.kind : 'magistrates',
              hint: "Magistrates' courts hear most criminal cases, the Crown Court serious ones, the County Court civil claims." },
        ], c ? 'Save' : 'Create court', async (v) => {
            const extra = { here: $('#cHere', box).checked, civilDefault: $('#cCivil', box).checked, clearCoords: $('#cClear', box) ? $('#cClear', box).checked : false };
            const x = await roomsApi(c ? 'courtUpdate' : 'courtCreate', { courtId: c && c.id, ...v, ...extra }, true);
            if (x.ok) { toast(c ? 'Court saved.' : 'Court created.'); VIEWS.rooms(); }
            return x;
        }, c && c.rooms ? `<p class="lead">${c.rooms} courtroom${c.rooms === 1 ? ' belongs' : 's belong'} to this court. Renaming it updates everywhere it's shown.</p>` : '');
        $('#fErr', box).insertAdjacentHTML('beforebegin', `<div class="checks" style="margin-top:12px">
            <label><input type="checkbox" id="cHere"> Set the court's waypoint to where I'm standing</label>
            ${c && c.hasCoords ? '<label><input type="checkbox" id="cClear"> Remove the waypoint (use its courtroom instead)</label>' : ''}
            <label><input type="checkbox" id="cCivil" ${c && c.civilDefault ? 'checked' : ''}> Default court for new civil claims (County Courts only)</label></div>`);
    };
    $('#cNew').onclick = () => courtForm(null);
    $$('[data-cdesk]').forEach((b) => (b.onclick = () => {
        const c = (r.courts || []).find((x) => x.id === b.dataset.cdesk);
        const box = openModal(`<h2>Custody desk for ${esc(c.label)}</h2>
            <p class="lead">Put it in the building's custody suite or cells. It can be anywhere in the building. Defendants who must be produced, and those in serious cases, are booked in here, and the officer chooses which courtroom they go to.</p>
            <label for="dLabel">Name</label><input type="text" id="dLabel" placeholder="e.g. Custody suite, Cells (lower ground)">
            <label>How to place it</label><div class="checks">
                <label><input type="radio" name="dMode" value="pick" checked> <strong>Use a computer already there</strong> (aim at it, E to choose)</label>
                <label><input type="radio" name="dMode" value="spawn"> <strong>Spawn a laptop prop</strong></label>
                <label><input type="radio" name="dMode" value="spot"> <strong>Just mark the spot</strong></label></div>
            <div class="btn-row"><button class="btn" id="dGo">Place it</button><button class="btn secondary" id="dNo">Cancel</button></div>`);
        $('#dNo', box).onclick = closeModal;
        $('#dGo', box).onclick = () => {
            const label = $('#dLabel', box).value.trim();
            const mode = ($('input[name=dMode]:checked', box) || {}).value || 'pick';
            closeModal();
            post('deskPlace', { courtId: c.id, label, mode });
        };
    }));
    $$('[data-dtp]').forEach((b) => (b.onclick = async () => {
        const [courtId, index] = b.dataset.dtp.split(':');
        const x = await roomsApi('courtDeskTeleport', { courtId, index: Number(index) }); if (x.ok) toast('Teleported.');
    }));
    $$('[data-drm]').forEach((b) => (b.onclick = () => confirmModal('Remove this custody desk?', async () => {
        const [courtId, index] = b.dataset.drm.split(':');
        const x = await roomsApi('courtDeskRemove', { courtId, index: Number(index) }); if (x.ok) VIEWS.rooms();
    }, 'Remove', true)));
    $$('[data-cedit]').forEach((b) => (b.onclick = () => courtForm((r.courts || []).find((c) => c.id === b.dataset.cedit))));
    $$('[data-cdel]').forEach((b) => (b.onclick = () => {
        const c = (r.courts || []).find((x) => x.id === b.dataset.cdel);
        confirmModal(`Delete ${c.label}? Only courts with no cases, hearings, claims or courtrooms can be deleted.`, async () => {
            const x = await roomsApi('courtDelete', { courtId: c.id });
            if (x.ok) { toast('Court deleted.'); VIEWS.rooms(); }
        }, 'Delete court', true);
    }));
    $('#rNew').onclick = () => formModal('New courtroom', [
        { id: 'label', label: 'Name', type: 'text', placeholder: 'e.g. Court 1' },
        { id: 'courtId', label: 'Court', type: 'select', options: r.courts.map((c) => ({ value: c.id, label: c.label })) },
        { id: 'radius', label: 'Size (metres from the centre)', type: 'number', value: 18, min: 5, hint: 'Should cover the whole room. Microphones carry this far unless you set their own range.' },
    ], 'Create here', async (v) => {
        const x = await roomsApi('create', v, true);
        if (x.ok) { toast("Courtroom created. Now draw the room's shape so its area follows the walls."); state.rooms = await roomsApi('list'); VIEWS.room({ id: x.id }); }
        return x;
    }, '<p class="lead">Your current position becomes the centre of the room.</p>');
};

VIEWS.room = async (p) => {
    const r = state.rooms && state.rooms.rooms ? state.rooms : await roomsApi('list');
    let room = (r.rooms || []).find((x) => x.id === p.id);
    if (!room) { const fresh = await roomsApi('list'); state.rooms = fresh; room = fresh.rooms.find((x) => x.id === p.id); }
    if (!room) return VIEWS.rooms();
    state.view = 'room';
    drawShell();
    const roles = r.roles || [];
    const roleName = (id) => roles.find((x) => x.id === id)?.label || id;
    const pts = room.points || [];
    main.innerHTML = `<div class="head"><div><span class="caption"><button class="link" id="rBack">Courtrooms</button> · ${esc((r.courts || []).find((c) => c.id === room.court_id)?.label || '')}</span><h1>${esc(room.label)}</h1></div>
        <div class="actions"><button class="btn secondary small" id="rTp">Teleport to centre</button><button class="btn secondary small" id="rEdit">Edit</button><button class="btn warning small" id="rDel">Delete</button></div></div>
        <div class="panel" style="display:flex;align-items:center;gap:14px;flex-wrap:wrap">
            <div style="flex:1;min-width:260px"><strong>Area:</strong> ${room.shape
                ? `drawn shape, ${room.shape.points.length} corners, ${(room.shape.maxZ - room.shape.minZ).toFixed(1)} m tall`
                : `circle, ${Math.round(room.radius)} m from the centre <span class="muted small">(draw the shape so it follows the walls)</span>`}</div>
            <button class="btn small" id="rShape">${room.shape ? 'Redraw the shape' : "Draw the room's shape"}</button>
            <button class="btn secondary small" id="rArea">Show area</button>
            ${room.shape ? '<button class="btn secondary small" id="rNoShape">Remove shape</button>' : ''}
        </div>
        <p class="small muted" style="margin-top:-6px">Drawing: aim at each corner of the floor and press <strong>E</strong>, <strong>Backspace</strong> undoes the last corner, <strong>Page Up/Down</strong> sets the ceiling height, <strong>Enter</strong> saves, <strong>G</strong> cancels. Neighbouring rooms are shown so you can line the walls up.</p>
        <div class="btn-row" style="margin:0 0 18px">
            <button class="btn" id="addLaptop"><span class="point-kind">${ICON.laptop} Place a laptop</span></button>
            <button class="btn" id="addMic"><span class="point-kind">${ICON.mic} Place a microphone</span></button>
            <button class="btn" id="addScreen"><span class="point-kind">${ICON.screen} Place a screen</span></button>
        </div>
        <p class="lead">Placing closes this screen. Pick something already in your MLO by aiming at it (it's outlined) and pressing <strong>E</strong>, or spawn a prop: aim, scroll to turn, <strong>↑/↓</strong> to raise or lower, <strong>E</strong> to place. <strong>Backspace</strong> cancels. Anyone within ${esc(String(r.micReach || 1.6))} m of a live microphone is heard across the room.</p>
        ${pts.length ? `<table><tr><th>Point</th><th>Name</th><th>Who</th><th>Prop</th><th></th></tr>${pts.map((q, i) => `<tr>
            <td><span class="point-kind">${ICON[q.kind] || ''} ${POINT_NAME[q.kind] || q.kind}</span></td>
            <td>${esc(q.label || '')}</td>
            <td class="small">${q.kind === 'laptop' ? ((q.roles || []).length ? q.roles.map(roleName).map(esc).join(', ') : 'All court staff') : q.kind === 'custody' ? 'Police, prison officers and court staff book defendants in' : q.kind === 'screen' ? (q.mode === 'pick' ? (r.overlay ? `Map TV${q.geo ? ' · picture fitted' : ' · <strong>not fitted yet</strong>'}` : `Map TV · render target ${esc(q.target || 'tvscreen')}`) : esc(((r.screens || []).find((m) => m.index === (q.model || 1)) || {}).label || 'Screen')) : `Carries ${Math.round(q.range || r.micRange || room.radius)} m`}</td>
            <td>${q.mode === 'pick' ? tag('Map object', 'blue') : q.prop ? tag('Spawned', 'green') : '<span class="muted small">Marked spot</span>'}</td>
            <td style="white-space:nowrap;text-align:right">${q.kind === 'screen' && r.overlay ? `<button class="btn secondary small" data-padj="${i + 1}">Adjust picture</button> ` : ''}<button class="btn secondary small" data-ptp="${i + 1}">Go to</button> <button class="btn secondary small" data-pedit="${i + 1}">Edit</button> <button class="btn warning small" data-prm="${i + 1}">Remove</button></td></tr>`).join('')}</table>`
            : '<p class="empty">Nothing placed yet.</p>'}`;

    const reload = async () => { state.rooms = await roomsApi('list'); VIEWS.room({ id: room.id }); };
    $('#rBack').onclick = () => VIEWS.rooms();
    $('#rTp').onclick = async () => { const x = await roomsApi('teleport', { id: room.id }); if (x.ok) toast('Teleported.'); };
    $('#rShape').onclick = () => post('roomsShape', { id: room.id });
    $('#rArea').onclick = () => post('roomsShowArea', { id: room.id });
    if ($('#rNoShape')) $('#rNoShape').onclick = () => confirmModal("Remove this room's shape and go back to the circle?", async () => {
        const x = await roomsApi('clearShape', { id: room.id }); if (x.ok) reload();
    }, 'Remove shape', true);
    $('#rEdit').onclick = () => {
        const box = formModal('Edit courtroom', [
            { id: 'label', label: 'Name', type: 'text', value: room.label },
            { id: 'courtId', label: 'Court', type: 'select', options: r.courts.map((c) => ({ value: c.id, label: c.label })), value: room.court_id },
            { id: 'radius', label: room.shape ? 'Circle size (only used if you remove the drawn shape)' : 'Size (metres from the centre)', type: 'number',
              value: Math.round(room.shape ? ((room.circle || {}).radius || room.radius) : room.radius), min: 3, hint: room.shape ? '' : "Better: close this and use Draw the room's shape." },
        ], 'Save', async (v) => { const x = await roomsApi('update', { id: room.id, ...v, recentre: $('#recentre', box).checked }, true); if (x.ok) reload(); return x; });
        $('#fErr', box).insertAdjacentHTML('beforebegin', '<div class="checks"><label><input type="checkbox" id="recentre"> Move the centre to where I am standing</label></div>');
    };
    $('#rDel').onclick = () => confirmModal(`Delete ${room.label} and everything placed in it?`, async () => {
        const x = await roomsApi('delete', { id: room.id }); if (x.ok) { state.rooms = null; VIEWS.rooms(); }
    }, 'Delete courtroom', true);

    const pointForm = (kind, existing, index) => {
        const isLaptop = kind === 'laptop', isDesk = kind === 'custody', isScreen = kind === 'screen';
        const cur = existing || {};
        const thing = isLaptop ? 'a laptop' : isDesk ? 'the custody desk' : isScreen ? 'a screen' : 'a microphone';
        const propName = isScreen ? 'TV' : isLaptop || isDesk ? 'laptop' : 'table microphone';
        // How it's placed: spawn our prop, pick an object already in the MLO, or (not screens) just mark the spot.
        const modes = [
            ['pick', `Use one already in the room`, `Aim at the ${isScreen ? 'TV' : isLaptop || isDesk ? 'laptop or computer' : 'microphone'} in your MLO. It is outlined; press E to choose it.`],
            ['spawn', `Spawn a ${propName} prop`, isScreen ? 'Aim at the wall or a stand. A ghost shows where the TV will go.' : 'Aim at the desk. A ghost shows where it will go.'],
        ];
        if (!isScreen) modes.push(['spot', 'Just mark the spot', 'No prop. Use this where the furniture is part of the building and cannot be selected.']);
        const box = openModal(`<h2>${existing ? 'Edit' : 'Place'} ${thing}</h2>
            ${isDesk ? '<p class="lead">Defendants in custody, and in serious cases, are booked in here before their hearing. Put it in the court cells or custody suite. It can be anywhere in the building: it doesn\'t need to be inside this courtroom.</p>' : ''}
            ${isScreen ? `<p class="lead">A TV that shows video evidence played from a courtroom laptop. Every screen in this room shows the same exhibit${r.overlay ? '; TVs of the same model in other rooms are not affected' : ''}.</p>
                ${r.overlay ? '<div class="inset small">After you place or pick it, you fit the picture to the TV: <strong>←/→</strong> width, <strong>↑/↓</strong> height, hold <strong>Shift</strong> to move it, scroll to bring it in or out, <strong>F</strong> if it\'s on the wrong side, <strong>E</strong> to save.</div>' : ''}` : ''}
            ${existing ? `<p class="small muted">${cur.mode === 'pick' ? 'Uses an object in the map' : cur.prop ? 'Spawned prop' : 'Marked spot'}. To change how it's placed, remove it and place it again.</p>` : `
            <label>How to place it</label>
            <div class="checks">${modes.map(([v, l, h], i) => `<label style="align-items:flex-start"><input type="radio" name="pMode" value="${v}" ${i === 0 ? 'checked' : ''} style="margin-top:2px"><span><strong>${l}</strong><br><span class="hint" style="margin:0">${h}</span></span></label>`).join('')}</div>`}
            ${isScreen && !existing ? `<div id="pSpawnOpts" class="hidden"><label for="pModel">TV model</label><select id="pModel">${(r.screens || []).map((m) => `<option value="${m.index}">${esc(m.label)}</option>`).join('')}</select></div>
                <div id="pPickOpts" ${r.overlay ? 'style="display:none"' : ''}><label for="pTarget">Render target</label><div class="hint">Only needed for a custom TV model. Known TVs fill this in automatically. Most GTA TVs use <strong>tvscreen</strong>.</div>
                <input type="text" id="pTarget" value="tvscreen"></div>` : ''}
            <label for="pLabel">Name</label><input type="text" id="pLabel" value="${esc(cur.label || '')}" placeholder="${isLaptop ? "e.g. Judge's bench, Clerk, Prosecution, Defence" : isDesk ? 'e.g. Court custody suite' : isScreen ? 'e.g. Jury screen, Public gallery' : 'e.g. Bench, Witness box, Dock'}">
            ${isLaptop ? `<label>Who can use it</label><div class="hint">None ticked = all court staff.</div><div class="checks">${roles.map((x) => `<label><input type="checkbox" data-role="${esc(x.id)}" ${(cur.roles || []).includes(x.id) ? 'checked' : ''}> ${esc(x.label)}</label>`).join('')}</div>` : ''}
            ${kind === 'mic' ? `<label for="pRange">Carries (metres)</label><div class="hint">Empty = the room's size (${Math.round(room.radius)} m).</div><input type="number" id="pRange" min="3" value="${esc(cur.range || '')}">` : ''}
            <div id="pErr"></div><div class="btn-row"><button class="btn" id="pGo">${existing ? 'Save' : 'Place it'}</button><button class="btn secondary" id="pNo">Cancel</button></div>`);
        const mode = () => (($('input[name=pMode]:checked', box) || {}).value) || 'pick';
        $$('input[name=pMode]', box).forEach((x) => (x.onchange = () => {
            if ($('#pSpawnOpts', box)) $('#pSpawnOpts', box).classList.toggle('hidden', mode() !== 'spawn');
            if ($('#pPickOpts', box)) $('#pPickOpts', box).classList.toggle('hidden', mode() !== 'pick');
            $('#pGo', box).textContent = mode() === 'pick' ? 'Select it in the room' : 'Place it';
        }));
        if (!existing) $('#pGo', box).textContent = 'Select it in the room';
        $('#pNo', box).onclick = closeModal;
        $('#pGo', box).onclick = async () => {
            const data = {
                label: $('#pLabel', box).value.trim(),
                roles: isLaptop ? $$('[data-role]', box).filter((x) => x.checked).map((x) => x.dataset.role) : undefined,
                range: kind === 'mic' && $('#pRange', box).value ? Number($('#pRange', box).value) : undefined,
            };
            if (existing) {
                const x = await roomsApi('updatePoint', { id: room.id, index, ...data, range: kind === 'mic' ? (data.range ?? false) : undefined }, true);
                if (x.error) { $('#pErr', box).innerHTML = `<p class="err">${esc(x.error)}</p>`; return; }
                closeModal(); reload(); return;
            }
            const m = mode();
            if (isScreen && m === 'pick' && !r.overlay && !/^[A-Za-z0-9_]+$/.test($('#pTarget', box).value.trim())) {
                $('#pErr', box).innerHTML = '<p class="err">Enter a render target name (letters, numbers and _ only).</p>'; return;
            }
            // Read everything from the form before closing it (closing empties the modal).
            const model = isScreen && m === 'spawn' ? Number($('#pModel', box).value) : undefined;
            const target = isScreen && m === 'pick' ? $('#pTarget', box).value.trim() : undefined;
            closeModal();
            post('roomsPlace', { id: room.id, kind, mode: m, prop: m === 'spawn', ...data, model, target });
        };
    };
    $('#addLaptop').onclick = () => pointForm('laptop');
    $('#addMic').onclick = () => pointForm('mic');
    $('#addScreen').onclick = () => pointForm('screen');
    $$('[data-ptp]').forEach((b) => (b.onclick = async () => { const x = await roomsApi('teleport', { id: room.id, index: Number(b.dataset.ptp) }); if (x.ok) toast('Teleported.'); }));
    $$('[data-padj]').forEach((b) => (b.onclick = () => post('roomsAdjust', { id: room.id, index: Number(b.dataset.padj) })));
    $$('[data-pedit]').forEach((b) => (b.onclick = () => { const i = Number(b.dataset.pedit); pointForm(pts[i - 1].kind, pts[i - 1], i); }));
    $$('[data-prm]').forEach((b) => (b.onclick = () => confirmModal('Remove this point?', async () => {
        const x = await roomsApi('removePoint', { id: room.id, index: Number(b.dataset.prm) }); if (x.ok) reload();
    }, 'Remove', true)));
};


/* ---------- court custody desk ---------- */
VIEWS.custody = async () => {
    const r = await api('custodyBoard');
    if (r.error) return;
    drawShell();
    const pending = r.results.filter((x) => !x.booked_at);
    main.innerHTML = `<div class="head"><div><span class="caption">${esc(r.room)}</span><h1>Court custody${r.court ? `: ${esc(r.court)}` : ''}</h1></div>
        <div class="actions"><button class="btn secondary small" id="cuRef">Refresh</button></div></div>
        <p class="lead">Defendants in custody, and in serious cases, must be booked in here before their hearing can go ahead. They need to be with you at the desk (within ${Math.round(r.range)} m).</p>
        <div class="stats" style="max-width:520px"><div class="stat ${pending.length ? 'red' : 'green'}"><div class="v">${pending.length}</div><div class="t">To book in</div></div>
            <div class="stat green"><div class="v">${r.results.length - pending.length}</div><div class="t">In court custody</div></div></div>
        ${r.results.length ? `<table><tr><th>Time</th><th>Defendant</th><th>Why</th><th>Courtroom</th><th>Where they are</th><th>Status</th><th></th></tr>${r.results.map((x) => `<tr>
            <td><strong>${fmtTime(x.at)}</strong><br><span class="muted small">${esc(hType(x.type))}</span></td>
            <td><strong>${esc(x.name)}</strong><br><span class="muted small">${esc(x.ref)}</span><div class="small">${chargeList(x.charges)}</div></td>
            <td>${tag(x.need === 'custody' ? 'Produce from custody' : 'Surrender to court', x.need === 'custody' ? 'red' : 'amber')}<br><span class="muted small">${esc(x.custody || '')}</span></td>
            <td>${x.room_id ? esc(((r.rooms || []).find((y) => y.id === x.room_id) || {}).label || '') : '<span class="muted">Not chosen</span>'}</td>
            <td>${!x.online ? '<span class="muted">Not in the city</span>' : x.distance <= r.range ? tag('At the desk', 'green') : `${x.distance} m away`}</td>
            <td>${x.booked_at ? `${tag('Booked in', 'green')}<div class="muted small">${fmtTime(x.booked_at)} · ${esc(x.booked_by || '')}</div>${x.notes ? `<div class="small">${esc(x.notes)}</div>` : ''}` : tag('Not booked in', 'grey')}</td>
            <td>${!x.booked_at ? `<button class="btn small" data-book="${x.id}" ${x.online && x.distance <= r.range ? '' : 'disabled'}>Book in</button>` : ''}</td></tr>`).join('')}</table>`
            : '<p class="empty">No one due at this court needs booking in.</p>'}`;
    $('#cuRef').onclick = () => VIEWS.custody();
    $$('[data-book]').forEach((b) => (b.onclick = () => {
        const x = r.results.find((y) => y.id === Number(b.dataset.book));
        const fields = [];
        if ((r.rooms || []).length) fields.push({ id: 'roomId', label: 'Courtroom', type: 'select', value: x.room_id || '',
            hint: 'Where they will be heard. Shown on the listing boards and told to the judge.',
            options: (x.room_id ? [] : [{ value: '', label: 'Choose a courtroom' }]).concat(r.rooms.map((y) => ({ value: y.id, label: y.label }))) });
        fields.push({ id: 'notes', label: 'Notes', type: 'textarea', hint: 'Escort, risk, property held, medication. Seen by the judge.' });
        formModal(`Book in ${x.name}`, fields, 'Book in', async (v) => {
            const res = await api('bookIn', { id: x.id, notes: v.notes, roomId: v.roomId ? Number(v.roomId) : null }, true);
            if (res.ok) { toast(`${x.name} booked in. The judge has been told.`); VIEWS.custody(); }
            return res;
        }, `<p class="lead">${esc(x.ref)} · ${esc(hType(x.type))} at ${fmtTime(x.at)}</p>`);
    }));
};

/* ---------- civil claims (County Court) ---------- */
const CIVIL_TAG = { issued: 'blue', defended: 'purple', listed: 'purple', judgment: 'amber', satisfied: 'green', order: 'green', dismissed: 'grey', withdrawn: 'grey', settled: 'green', struck_out: 'grey' };
const civilStatus = (c) => tag(c.statusLabel || c.status, CIVIL_TAG[c.status] || '');
const civilAmount = (c) => (c.amount > 0 ? money(c.amount) : esc(c.remedy || ''));
const civilOpen = (c) => ['issued', 'defended', 'listed'].includes(c.status);

VIEWS.civil = async (p = {}) => {
    const status = p.status || 'open';
    const r = await api('civilList', { status, q: p.q || '' });
    if (r.error) return;
    const canIssue = (state.cfg.civilOpenRoles || []).includes(state.me.role);
    main.innerHTML = `<div class="head"><div><span class="caption">County Court${state.me.role === 'defence' ? ' · claims you act in' : ''}</span><h1>Civil claims</h1></div>
        <div class="actions">${canIssue ? '<button class="btn" id="cvNew">Issue a claim</button>' : ''}</div></div>
        <div class="toolbar">
            <div style="flex:1"><label for="cvQ">Search</label><input type="text" id="cvQ" value="${esc(p.q || '')}" placeholder="Claim number or party name"></div>
            <div class="seg">${[['open', 'Open'], ['closed', 'Concluded'], ['all', 'All']].map(([k, l]) => `<button data-cs="${k}" class="${k === status ? 'on' : ''}">${l}</button>`).join('')}</div>
        </div>
        ${r.results.length ? `<table><tr><th>Claim</th><th>Parties</th><th>Type</th><th class="num">Claimed</th><th>Next</th><th>Status</th></tr>${r.results.map((c) => `<tr class="click" data-claim="${c.id}">
            <td><strong>${esc(c.ref)}</strong><br><span class="muted small">${fmtDate(c.created_at, false)}</span></td>
            <td>${partyName(c, 'claimant')} <span class="muted">v</span> ${partyName(c, 'defendant')}</td><td class="small">${esc(c.typeLabel)}</td>
            <td class="num">${civilAmount(c)}</td>
            <td class="small">${c.status === 'issued' ? `Response due ${fmtDate(c.response_due)}` : c.status === 'listed' && c.hearing_at ? `Hearing ${fmtDate(c.hearing_at)}` : c.status === 'defended' ? 'Needs a hearing date' : ''}</td>
            <td>${civilStatus(c)}${c.ccj ? ' ' + tag('CCJ', 'red') : ''}${c.hearing_open ? ' ' + tag('In court', 'green') : ''}</td></tr>`).join('')}</table>`
            : '<p class="empty">No claims.</p>'}`;
    let t;
    $('#cvQ').oninput = (e) => { clearTimeout(t); t = setTimeout(() => go('civil', { status, q: e.target.value }).then(() => { const i = $('#cvQ'); i.focus(); i.setSelectionRange(i.value.length, i.value.length); }), 350); };
    $$('[data-cs]').forEach((b) => (b.onclick = () => go('civil', { status: b.dataset.cs, q: p.q })));
    $$('[data-claim]').forEach((b) => (b.onclick = () => go('claim', { id: Number(b.dataset.claim) })));
    if ($('#cvNew')) $('#cvNew').onclick = () => issueClaimModal((x) => api('civilIssue', x, true), (q, kind) => api('searchParties', { q, kind }, true), (x) => api('civilFee', x, true), (id) => go('claim', { id }));
};

/** Shared by staff (solicitor) and the public portal.
 *  opts.inPerson = issuing for yourself; opts.business = { id, name } when a boss can issue for their business. */
function issueClaimModal(send, search, feeFn, done, opts = {}) {
    const parties = { claimant: { kind: 'person', id: null }, defendant: { kind: 'person', id: null } };
    const types = state.cfg.civilTypes || [];
    const biz = state.cfg.businesses;
    const kindSeg = (side) => biz ? `<div class="seg" style="margin-bottom:6px" data-kseg="${side}"><button data-k="person" class="on">A person</button><button data-k="business">A business</button></div>` : '';
    const portal = opts.inPerson || opts.business;
    const claimantBlock = !portal
        ? `<label>Claimant (your client)</label>${kindSeg('claimant')}<input type="text" id="ppC" placeholder="Search by name"><div class="results" id="ppCRes"></div>`
        : `<label for="asWho">Bringing the claim</label><select id="asWho">${opts.inPerson ? '<option value="me">You, in person</option>' : ''}${opts.business ? `<option value="biz">${esc(opts.business.name)} (your business)</option>` : ''}</select>`;
    const box = openModal(`<h2>Issue a County Court claim</h2>
        <p class="lead" id="cLead"></p>
        ${claimantBlock}
        <label>Defendant (who the claim is against)</label>${kindSeg('defendant')}<input type="text" id="ppD" placeholder="Search by name"><div class="results" id="ppDRes"></div>
        <div class="grid2"><div><label for="cType">Type of claim</label><select id="cType">${types.map((x) => `<option value="${esc(x.id)}">${esc(x.label)}</option>`).join('')}</select></div>
        <div><label for="cAmt">Amount claimed (${esc(state.cfg.currency || '£')})</label><input type="number" id="cAmt" min="0" value="0"><div class="hint">0 if you're not claiming money.</div></div></div>
        <label for="cRem">Order you want the court to make</label><div class="hint">For injunctions and property claims, e.g. "Return the vehicle", "Stop contacting the claimant".</div><input type="text" id="cRem">
        <label for="cPart">Particulars of claim</label><div class="hint">What happened, when, and why the defendant owes it.</div><textarea id="cPart" style="min-height:120px"></textarea>
        <p id="cFee" class="small"></p><div id="cErr"></div>
        <div class="btn-row"><button class="btn" id="cGo">Issue claim and pay fee</button><button class="btn secondary" id="cNo">Cancel</button></div>`, true);
    const lead = () => {
        const asBiz = portal && $('#asWho', box) && $('#asWho', box).value === 'biz';
        $('#cLead', box).textContent = !portal ? 'You are issuing this claim on behalf of your client. The court fee comes out of your account.'
            : asBiz ? `You are bringing this claim for ${opts.business.name}. The court fee comes out of the business account.`
            : 'You are bringing this claim yourself. The court fee comes out of your bank account.';
    };
    lead();
    if ($('#asWho', box)) $('#asWho', box).onchange = lead;
    const picker = (side, input, out) => {
        let t;
        const run = async () => {
            const v = $(input, box).value.trim();
            if (v.length < 2) { $(out, box).innerHTML = ''; return; }
            const r = await search(v, parties[side].kind);
            $(out, box).innerHTML = (r.results || []).map((p) => `<button data-cid="${esc(p.cid)}" data-name="${esc(p.name)}">${esc(p.name)} <span class="muted small">${parties[side].kind === 'business' ? 'Business' : esc(p.cid)}</span></button>`).join('') || '<p class="empty" style="padding:8px">None found.</p>';
            $$('button', $(out, box)).forEach((b) => (b.onclick = () => { parties[side].id = b.dataset.cid; $(out, box).innerHTML = ''; $(input, box).value = b.dataset.name; }));
        };
        $(input, box).oninput = () => { parties[side].id = null; clearTimeout(t); t = setTimeout(run, 300); };
        const seg = $(`[data-kseg="${side}"]`, box);
        if (seg) $$('button', seg).forEach((b) => (b.onclick = () => {
            $$('button', seg).forEach((x) => x.classList.toggle('on', x === b));
            parties[side].kind = b.dataset.k; parties[side].id = null;
            $(input, box).value = ''; $(out, box).innerHTML = '';
            $(input, box).placeholder = b.dataset.k === 'business' ? 'Search businesses' : 'Search by name';
        }));
    };
    if (!portal) picker('claimant', '#ppC', '#ppCRes');
    picker('defendant', '#ppD', '#ppDRes');
    const fee = async () => { const r = await feeFn({ type: $('#cType', box).value, amount: Number($('#cAmt', box).value) }); $('#cFee', box).innerHTML = `Court fee: <strong>${money(r.fee || 0)}</strong>`; };
    $('#cType', box).onchange = fee; $('#cAmt', box).oninput = fee; fee();
    $('#cNo', box).onclick = closeModal;
    $('#cGo', box).onclick = async () => {
        $('#cGo', box).disabled = true;
        const r = await send({
            claimant: parties.claimant.id, claimantKind: parties.claimant.kind,
            defendant: parties.defendant.id, defendantKind: parties.defendant.kind,
            asBusiness: portal && $('#asWho', box) && $('#asWho', box).value === 'biz',
            type: $('#cType', box).value, amount: Number($('#cAmt', box).value), remedy: $('#cRem', box).value, particulars: $('#cPart', box).value,
        });
        $('#cGo', box).disabled = false;
        if (r.error) { $('#cErr', box).innerHTML = `<p class="err">${esc(r.error)}</p>`; return; }
        closeModal(); toast('Claim issued and served on the defendant.'); done(r.id);
    };
}

const partyName = (c, side) => `${esc(c[side + '_name'])}${c[side + '_kind'] === 'business' ? ' ' + tag('Business', 'grey') : ''}`;

VIEWS.claim = async (p) => {
    const r = await api('civilGet', { id: p.id });
    if (r.error) return go('civil');
    const c = r.claim;
    state.claim = c;
    const side = c.mySide;
    const judge = can('judge'), court = can('judge', 'clerk');
    const decided = c.status === 'judgment' || !civilOpen(c);
    const j = c.judgment || {};
    const owed = Math.max(0, (c.total_due || 0) - (c.paid || 0));
    const overdue = c.status === 'issued' && c.response_due < now();
    main.innerHTML = `<div class="head"><div><span class="caption">${esc(c.courtLabel)} · ${esc(c.ref)}${side ? ` · you act for the ${side}` : ''}</span>
            <h1>${esc(c.claimant_name)} <span class="muted" style="font-weight:400">v</span> ${esc(c.defendant_name)}</h1>
            <div class="chips" style="margin-top:8px">${civilStatus(c)} ${c.ccj ? tag('CCJ registered', 'red') : ''} ${c.hearing_open ? tag('In court', 'green') : ''}</div></div>
        <div class="actions">
            ${court && civilOpen(c) ? '<button class="btn secondary small" id="cvList">List hearing</button><button class="btn secondary small" id="cvSol">Solicitors</button>' : ''}
            ${judge && civilOpen(c) && !c.hearing_open ? '<button class="btn small" id="cvOpen">Open hearing</button>' : ''}
            ${side === 'defendant' && c.status === 'issued' ? '<button class="btn small" id="cvResp">Respond to claim</button>' : ''}
            ${(side === 'claimant' || judge) && overdue ? '<button class="btn secondary small" id="cvDef">Judgment in default</button>' : ''}
            ${side === 'claimant' && civilOpen(c) ? '<button class="btn secondary small" id="cvWd">Withdraw or settle</button>' : ''}
            ${judge && civilOpen(c) ? '<button class="btn warning small" id="cvStrike">Strike out</button>' : ''}
            <button class="btn secondary small" id="cvNote">Add note</button>
        </div></div>
        ${c.hearing_open && judge ? `<div class="panel hearing"><h2>Hearing: in court</h2>
            <p class="muted" style="margin-top:-4px">Claimant ${c.claimantOnline ? 'in the city' : '<strong>not in the city</strong>'}${c.claimant_kind === 'business' ? ' (a boss)' : ''} · Defendant ${c.defendantOnline ? 'in the city' : '<strong>not in the city</strong>'}${c.defendant_kind === 'business' ? ' (a boss)' : ''}</p>
            <div class="step"><h3><span class="num">1</span>Judgment</h3>
                <div class="grid3"><div><label for="jFor">Judgment for</label><select id="jFor"><option value="claimant">The claimant</option><option value="defendant">The defendant (claim dismissed)</option></select></div>
                <div><label for="jAmt">Amount awarded</label><input type="number" id="jAmt" min="0" value="${c.amount || 0}"></div>
                <div><label for="jCosts">Costs</label><input type="number" id="jCosts" min="0" value="${c.fee || 0}"><div class="hint">Paid by the losing side.</div></div></div>
                <label for="jOrder">Order (optional)</label><div class="hint">An injunction or other order.${c.defendant_kind === 'business' ? ' The business\'s bosses are told.' : " It is added to the defendant's MDT record so police can enforce it."}</div><input type="text" id="jOrder" value="${esc(c.amount > 0 ? '' : c.remedy || '')}">
                <div class="btn-row"><button class="btn" id="jGo">Give judgment</button></div></div>
            <div class="step"><h3><span class="num">2</span>Adjourn</h3>
                <div class="grid2"><div><label for="jAt">Next hearing</label><input type="datetime-local" id="jAt"></div><div><label for="jWhy">Reason</label><input type="text" id="jWhy"></div></div>
                <div class="btn-row"><button class="btn secondary small" id="jAdj">Adjourn</button></div></div>
        </div>` : ''}
        ${c.status === 'issued' ? `<div class="banner ${overdue ? 'red' : ''}"><strong>${overdue ? 'Response overdue' : 'Waiting for the defendant to respond'}</strong>Response due ${fmtDate(c.response_due)}.${overdue ? ' Judgment in default can be entered.' : ''}</div>` : ''}
        ${c.status === 'listed' && c.hearing_at && !c.hearing_open ? `<div class="panel"><h3>Hearing</h3><p style="margin:0">${fmtDate(c.hearing_at)} at ${esc(c.courtLabel)}</p></div>` : ''}
        ${j.at ? `<div class="panel"><h3>Judgment</h3><p style="margin:0"><strong>${j.forParty === 'claimant' ? 'For the claimant' : 'For the defendant'}</strong>${j.how ? ` (${esc(j.how)})` : ''}
            ${j.amount ? ` · ${money(j.amount)}` : ''}${j.costs ? ` · costs ${money(j.costs)}` : ''}</p>${j.order ? `<div class="inset">${esc(j.order)}</div>` : ''}
            ${c.total_due ? `<p class="small">${j.payer === 'claimant' ? 'Claimant' : 'Defendant'} to pay ${money(c.total_due)} by ${fmtDate(c.judgment_due, false)} · paid ${money(c.paid)} · ${owed ? `${money(owed)} outstanding` : 'paid in full'}</p>` : ''}
            <p class="muted small" style="margin:6px 0 0">${esc(j.by || '')} · ${fmtDate(j.at)}</p></div>` : ''}
        <div class="cols"><div>
            <h2>Particulars of claim</h2><div class="inset" style="white-space:pre-wrap">${esc(c.particulars || '')}</div>
            ${c.remedy ? `<p><strong>Order sought:</strong> ${esc(c.remedy)}</p>` : ''}
            ${c.response && c.response.kind ? `<h2>${c.response.kind === 'admit' ? 'Admission' : 'Defence'}</h2><div class="inset" style="white-space:pre-wrap">${esc(c.response.text || (c.response.kind === 'admit' ? 'The defendant admits the claim.' : ''))}</div>
                <p class="muted small">${esc(c.response.by || '')} · ${fmtDate(c.response.at)}</p>` : ''}
            ${exhibitsHtml('claim', c)}
        </div><div>
            <h2>Details</h2>
            <dl class="summary">
                <dt>Type</dt><dd>${esc(c.typeLabel)}</dd>
                <dt>Claimed</dt><dd>${civilAmount(c)}</dd>
                <dt>Claimant</dt><dd>${partyName(c, 'claimant')}<div class="muted small">${c.claimant_sol_name ? `Solicitor: ${esc(c.claimant_sol_name)}` : c.claimant_kind === 'business' ? 'Represented by its bosses' : 'In person'}</div></dd>
                <dt>Defendant</dt><dd>${partyName(c, 'defendant')}<div class="muted small">${c.defendant_sol_name ? `Solicitor: ${esc(c.defendant_sol_name)}` : c.defendant_kind === 'business' ? 'Represented by its bosses' : 'Unrepresented'}</div></dd>
                <dt>Court fee</dt><dd>${money(c.fee)}</dd>
                <dt>Issued</dt><dd>${fmtDate(c.created_at)}</dd>
            </dl>
            <h2>Claim log</h2><ul class="log">${(c.log || []).slice().reverse().map((l) => `<li><div class="meta">${fmtDate(l.at)} · ${esc(l.by)}</div>${esc(l.text)}</li>`).join('')}</ul>
        </div></div>`;

    const done = (msg) => (x) => { if (x.ok) { toast(msg); refresh(); } return x; };
    const on = (id, fn) => { if ($(id)) $(id).onclick = fn; };
    on('#cvList', () => formModal('List a hearing', [
        { id: 'courtId', label: 'Court', type: 'select', options: (state.cfg.courts || []).map((x) => ({ value: x.id, label: x.label })), value: c.hearing_court || state.cfg.civilCourt },
        { id: 'roomId', label: 'Courtroom', type: 'select', hint: 'Shown on listing boards.',
          options: [{ value: '', label: 'Not decided yet' }].concat((state.cfg.rooms || []).map((x) => ({ value: x.id, label: `${x.label} (${courtLabel(x.court_id)})` }))) },
        { id: 'at', label: 'Date and time', type: 'datetime', value: now() + 3600 },
    ], 'List hearing', async (v) => done('Listed. Both parties have been told.')(await api('civilListHearing', { id: c.id, ...v, roomId: v.roomId ? Number(v.roomId) : null }, true))));
    on('#cvSol', () => formModal('Solicitors', [
        { id: 'side', label: 'Acting for', type: 'select', options: [{ value: 'defendant', label: 'The defendant' }, { value: 'claimant', label: 'The claimant' }] },
        { id: 'cid', label: "Solicitor's citizen ID", type: 'text', hint: 'Leave empty to remove the solicitor.' },
    ], 'Save', async (v) => done('Saved.')(await api('civilAssign', { id: c.id, ...v }, true))));
    on('#cvOpen', async () => done('Hearing opened. The parties have been told.')(await api('civilOpen', { id: c.id })));
    on('#cvResp', () => formModal('Respond to the claim', [
        { id: 'kind', label: 'Response', type: 'select', options: [{ value: 'defend', label: 'Defend the claim' }, { value: 'admit', label: 'Admit the whole claim' }] },
        { id: 'text', label: 'Defence, or a note with the admission', type: 'textarea', hint: 'Why the claim is disputed. Admitting enters judgment for the claimant.' },
    ], 'Submit response', async (v) => done('Response filed.')(await api('civilRespond', { id: c.id, ...v }, true))));
    on('#cvDef', () => confirmModal(`Enter judgment in default for ${civilAmount(c).replace(/<[^>]+>/g, '')}? The defendant has not responded.`, async () => done('Judgment entered.')(await api('civilDefault', { id: c.id })), 'Enter judgment'));
    on('#cvWd', () => formModal('Withdraw or settle', [
        { id: 'status', label: 'Outcome', type: 'select', options: [{ value: 'settled', label: 'Settled between the parties' }, { value: 'withdrawn', label: 'Withdraw the claim' }] },
        { id: 'reason', label: 'Note', type: 'text' },
    ], 'Confirm', async (v) => done('Done.')(await api('civilEnd', { id: c.id, ...v }, true))));
    on('#cvStrike', () => formModal('Strike out the claim', [{ id: 'reason', label: 'Reason', type: 'textarea' }], 'Strike out',
        async (v) => done('Struck out.')(await api('civilEnd', { id: c.id, status: 'struck_out', reason: v.reason }, true))));
    on('#cvNote', () => formModal('Add a note', [{ id: 'text', label: 'Note', type: 'textarea' }], 'Add note', async (v) => done('Added.')(await api('civilNote', { id: c.id, text: v.text }, true))));
    on('#jGo', async () => done('Judgment given. The parties have been told.')(await api('civilJudge', {
        id: c.id, forParty: $('#jFor').value, amount: Number($('#jAmt').value), costs: Number($('#jCosts').value), order: $('#jOrder').value,
    })));
    bindExhibits('claim', c);
    on('#jAdj', async () => done('Adjourned.')(await api('civilAdjourn', { id: c.id, at: fromInput($('#jAt').value), reason: $('#jWhy').value })));
};


/* ---------- video exhibits and the courtroom screens ---------- */
const VIDEO_KIND = { medal: 'Medal', youtube: 'YouTube', twitch: 'Twitch', streamable: 'Streamable', vimeo: 'Vimeo', dailymotion: 'Dailymotion',
    tiktok: 'TikTok', gdrive: 'Google Drive', dropbox: 'Dropbox', imgur: 'Imgur', gyazo: 'Gyazo', file: 'File' };
const sourceOf = (x) => x.source || x.providerLabel || VIDEO_KIND[x.provider || x.kind] || 'Video';

function exhibitsHtml(ownerKind, owner) {
    const list = owner.exhibits || [];
    const canAdd = can('judge', 'clerk', 'cps', 'defence');
    const onScreens = state.room && state.room.screens;
    return `<h2>Video exhibits</h2>
        ${list.length ? `<table><tr><th>Exhibit</th><th>Source</th><th>Added</th><th></th></tr>${list.map((x, i) => `<tr>
            <td><strong>${esc(x.label)}</strong></td><td>${tag(sourceOf(x), 'grey')}</td>
            <td class="small muted">${esc(x.by || '')}<br>${fmtDate(x.at)}</td>
            <td style="white-space:nowrap;text-align:right">${onScreens ? `<button class="btn small" data-exshow="${i + 1}">Show on screens</button> ` : ''}
                ${can('judge') || x.by ? `<button class="btn secondary small" data-exrm="${i + 1}">Remove</button>` : ''}</td></tr>`).join('')}</table>`
            : '<p class="empty">No video exhibits.</p>'}
        ${!onScreens && list.length ? '<p class="small muted">Open this from a courtroom laptop to show exhibits on its screens.</p>' : ''}
        ${canAdd ? `<div class="btn-row" style="margin-top:8px"><button class="btn secondary small" id="exAdd">Add a video exhibit</button></div>` : ''}`;
}

function bindExhibits(ownerKind, owner) {
    if ($('#exAdd')) $('#exAdd').onclick = () => formModal('Add a video exhibit', [
        { id: 'label', label: 'Exhibit name', type: 'text', placeholder: 'e.g. PH/1 bodycam, Dashcam from NB21, CCTV Legion Square' },
        { id: 'url', label: 'Link', type: 'text', placeholder: 'https://medal.tv/... or https://youtu.be/...', hint: 'Medal, YouTube, Twitch, Streamable, Vimeo, Dailymotion, TikTok, Google Drive, Dropbox, Imgur, Gyazo, or a direct video or image file.' },
    ], 'Add exhibit', async (v) => { const x = await api('addExhibit', { ownerKind, ownerId: owner.id, ...v }, true); if (x.ok) { toast('Exhibit added.'); refresh(); } return x; });
    $$('[data-exshow]').forEach((b) => (b.onclick = async () => {
        const x = await api('screenPlay', { ownerKind, ownerId: owner.id, index: Number(b.dataset.exshow) });
        if (x.ok) toast(`Now showing: ${x.now.label}`);
    }));
    $$('[data-exrm]').forEach((b) => (b.onclick = () => confirmModal('Remove this exhibit from the case?', async () => {
        const x = await api('removeExhibit', { ownerKind, ownerId: owner.id, index: Number(b.dataset.exrm) }); if (x.ok) refresh();
    }, 'Remove', true)));
}

async function screensModal() {
    const st = await api('screenStatus');
    if (st.error) return;
    const owner = state.view === 'case' ? { kind: 'case', o: state.case } : state.view === 'claim' ? { kind: 'claim', o: state.claim } : null;
    const list = owner && owner.o ? owner.o.exhibits || [] : [];
    const box = openModal(`<h2>Screens: ${esc(st.room || '')}</h2>
        <div class="panel" style="margin-bottom:14px">${st.now ? `<strong>Now showing:</strong> ${esc(st.now.label)} ${tag(sourceOf(st.now), 'grey')}
            <div class="muted small">${esc(st.now.by || '')} · started ${fmtTime(st.now.startedAt)}${st.now.ref ? ` · ${esc(st.now.ref)}` : ''}</div>
            <div class="btn-row"><button class="btn secondary small" id="sRe">Play from the start</button><button class="btn warning small" id="sStop">Stop</button></div>`
            : '<span class="muted">The screens are showing the court slate.</span>'}</div>
        ${list.length ? `<h3>Exhibits on ${esc(owner.o.ref || 'this case')}</h3><table>${list.map((x, i) => `<tr><td><strong>${esc(x.label)}</strong> ${tag(sourceOf(x), 'grey')}</td>
            <td style="text-align:right"><button class="btn small" data-sx="${i + 1}">Show</button></td></tr>`).join('')}</table>` : ''}
        <h3 style="margin-top:16px">Play a link</h3>
        <label for="sLabel">Name</label><input type="text" id="sLabel" placeholder="e.g. Defence exhibit D/1">
        <label for="sUrl">Link</label><div class="hint">${esc(st.sources || 'Medal, YouTube or a direct video file')}. Timestamps in YouTube, Twitch, Vimeo and Dailymotion links are kept. Only people in this courtroom see and hear it.</div>
        <input type="text" id="sUrl" placeholder="https://medal.tv/games/gta-v/clips/...">
        <div id="sErr"></div>
        <div class="btn-row"><button class="btn" id="sPlay">Show on screens</button><button class="btn secondary" id="sClose">Close</button></div>`);
    const after = (msg) => (x) => { if (x.ok) { toast(msg); closeModal(); } else if (x.error) $('#sErr', box).innerHTML = `<p class="err">${esc(x.error)}</p>`; };
    $('#sClose', box).onclick = closeModal;
    $('#sPlay', box).onclick = async () => after('Now showing on the screens.')(await api('screenPlay', { url: $('#sUrl', box).value, label: $('#sLabel', box).value }, true));
    if ($('#sRe', box)) $('#sRe', box).onclick = async () => after('Playing from the start.')(await api('screenRestart', {}, true));
    if ($('#sStop', box)) $('#sStop', box).onclick = async () => after('Screens back to the court slate.')(await api('screenStop', {}, true));
    $$('[data-sx]', box).forEach((b) => (b.onclick = async () => after('Now showing on the screens.')(await api('screenPlay', { ownerKind: owner.kind, ownerId: owner.o.id, index: Number(b.dataset.sx) }, true))));
}
