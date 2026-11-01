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
    judge: ['dashboard', 'list', 'cases', 'warrants', 'prison', 'probation', 'fines'],
    clerk: ['dashboard', 'list', 'cases', 'warrants', 'prison', 'fines'],
    cps: ['dashboard', 'list', 'cases', 'warrants'],
    defence: ['dashboard', 'list', 'cases', 'warrants'],
    probation: ['dashboard', 'probation', 'cases', 'prison', 'warrants'],
    prison: ['dashboard', 'prison', 'warrants'],
    police: ['dashboard', 'list', 'cases', 'warrants', 'prison'],
};
const NAV_LABEL = { dashboard: 'Overview', list: 'Court lists', cases: 'Cases', warrants: 'Warrants', prison: 'Prison', probation: 'Probation', fines: 'Fines' };
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
    $('#nav').classList.remove('hidden');
    $('#who').innerHTML = `<strong>${esc(state.me.name)}</strong>${esc(state.me.label)}`;
    const items = NAV[state.me.role] || ['dashboard'];
    $('#nav').innerHTML = items.map((v) => `<button data-nav="${v}" class="${state.view === v || (state.view === 'case' && v === 'cases') || (state.view === 'order' && v === 'probation') ? 'active' : ''}">${NAV_LABEL[v]}</button>`).join('');
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
        $('#app').classList.remove('hidden');
        if (m.mode === 'portal') {
            state.view = 'portal';
            await VIEWS.portal();
        } else {
            const r = await api('init');
            if (r.error) return close();
            state.me = r.me;
            state.cfg = r.cfg;
            go(state.me.role === 'prison' ? 'prison' : state.me.role === 'probation' ? 'probation' : 'dashboard');
        }
    } else if (m.action === 'close') {
        $('#app').classList.add('hidden');
        closeModal();
    }
});
function close() { post('close'); $('#app').classList.add('hidden'); closeModal(); }
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
            <td>${esc(hType(h.type))}</td><td>${esc(courtLabel(h.court_id))}</td><td>${custodyTag(h.custody_status)}</td>
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
        { id: 'at', label: 'Date and time', type: 'datetime', value: now() + 3600 },
    ], 'List hearing', async (v) => {
        const x = await api('listHearing', { id: c.id, ...v }, true); if (x.ok) { toast('Listed. The defendant has been notified.'); refresh(); } return x;
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
        ${step('Attendance', `<div class="btn-row" style="margin-top:4px"><button class="btn secondary small" id="hPresent">Defendant present</button><button class="btn warning small" id="hFta">Failed to appear (warrant)</button></div>`)}
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

        <h2>Your cases</h2>
        ${cases.length ? `<table><tr><th>Case</th><th>Charges</th><th>Status</th></tr>${cases.map((c) => `<tr><td><strong>${esc(c.ref)}</strong><br><span class="muted small">${esc(c.courtLabel || '')}</span></td>
            <td class="small">${chargeList(c.charges)}</td><td>${tag(r.cfg.statuses?.[c.status] || c.status, STATUS_TAG[c.status] || '')}${c.solicitor_name ? `<div class="small muted">Solicitor: ${esc(c.solicitor_name)}</div>` : ''}</td></tr>`).join('')}</table>`
            : '<p class="empty">You have no court cases.</p>'}`;

    $('#pRef').onclick = () => VIEWS.portal();
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
