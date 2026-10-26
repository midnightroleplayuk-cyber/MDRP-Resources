'use strict';
const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'vinewood-emsmdt';
const S = { boot: null, page: 'dashboard', params: {}, prf: null, prfTab: 'incident', counts: {} };

/* ---------- utils ---------- */
const $ = (s, el = document) => el.querySelector(s);
const $$ = (s, el = document) => [...el.querySelectorAll(s)];
const esc = (v) => String(v ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const nowHM = () => new Date().toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' });
function fmt(v, timeOnly) {
  if (!v) return '';
  const d = typeof v === 'number' ? new Date(v) : new Date(String(v).replace(' ', 'T'));
  if (isNaN(d)) return esc(v);
  const t = d.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' });
  return timeOnly ? t : `${d.toLocaleDateString('en-GB')} ${t}`;
}
function getPath(o, p) { return p.split('.').reduce((a, k) => (a == null ? a : a[k]), o); }
function setPath(o, p, v) { const ks = p.split('.'); const last = ks.pop(); ks.reduce((a, k) => (a[k] ??= {}), o)[last] = v; }

async function post(name, body) {
  const r = await fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body || {}) });
  return r.json();
}
async function api(action, data) {
  try {
    const r = await post('request', { action, data });
    if (!r || r.ok === false) { toast((r && r.err) || 'The request failed.', true); return null; }
    return r;
  } catch (e) { toast('Could not reach the server.', true); return null; }
}
function toast(msg, err) {
  const el = document.createElement('div');
  el.className = 'toast' + (err ? ' err' : '');
  el.textContent = msg;
  $('#toasts').appendChild(el);
  setTimeout(() => el.remove(), err ? 5000 : 3000);
}
function openModal(html, mount) {
  $('#modalCard').innerHTML = html;
  $('#modal').classList.remove('hidden');
  mount && mount($('#modalCard'));
  const f = $('#modalCard input, #modalCard select, #modalCard textarea'); f && f.focus();
}
function closeModal() { emsCallNotes = null; $('#modal').classList.add('hidden'); $('#modalCard').innerHTML = ''; $('#modalCard').style.width = ''; }
function confirmBox(title, text, okLabel, danger) {
  return new Promise((res) => {
    openModal(`<h3>${esc(title)}</h3><p>${esc(text)}</p>
      <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn ${danger ? 'danger' : 'primary'}" data-ok>${esc(okLabel)}</button></div>`, (m) => {
      $('[data-x]', m).onclick = () => { closeModal(); res(false); };
      $('[data-ok]', m).onclick = () => { closeModal(); res(true); };
    });
  });
}
const options = (arr, sel, valKey, labKey) => arr.map((o) => {
  const v = typeof o === 'object' ? o[valKey] : o; const l = typeof o === 'object' ? o[labKey] : o;
  return `<option value="${esc(v)}" ${String(v) === String(sel) ? 'selected' : ''}>${esc(l)}</option>`;
}).join('');

/* ---------- clinical ---------- */
function news2(o) {
  if (!o) return null;
  const n = (x) => (x === '' || x == null ? null : Number(x));
  let s = 0, c = 0;
  const rr = n(o.rr), sp = n(o.spo2), sbp = n(o.sbp), hr = n(o.hr), t = n(o.temp);
  if (rr != null) { c++; s += rr <= 8 ? 3 : rr <= 11 ? 1 : rr <= 20 ? 0 : rr <= 24 ? 2 : 3; }
  if (sp != null) { c++; s += sp <= 91 ? 3 : sp <= 93 ? 2 : sp <= 95 ? 1 : 0; }
  if (o.o2) s += 2;
  if (sbp != null) { c++; s += sbp <= 90 ? 3 : sbp <= 100 ? 2 : sbp <= 110 ? 1 : sbp <= 219 ? 0 : 3; }
  if (hr != null) { c++; s += hr <= 40 ? 3 : hr <= 50 ? 1 : hr <= 90 ? 0 : hr <= 110 ? 1 : hr <= 130 ? 2 : 3; }
  if (o.avpu) { c++; s += o.avpu === 'A' ? 0 : 3; }
  if (t != null) { c++; s += t <= 35 ? 3 : t <= 36 ? 1 : t <= 38 ? 0 : t <= 39 ? 1 : 2; }
  return c ? s : null;
}
function newsBadge(v) {
  if (v == null || v === '') return '<span class="news none" title="NEWS2 not scored">–</span>';
  const cls = v >= 7 ? 'high' : v >= 5 ? 'med' : '';
  return `<span class="news ${cls}" title="NEWS2 ${v}">${v}</span>`;
}
const isArrestRhythm = (name) => !!(S.boot.lists.rhythms.find((r) => r.name === name) || {}).arrest;
const catBadge = (c) => `<span class="cat c${c}">Cat ${c}</span>`;
const hospitalLabel = (id) => (S.boot.lists.hospitals.find((h) => h.id === id) || {}).label || id || '';

/* ---------- shell ---------- */
const PAGES = {
  dashboard: { title: 'Dashboard', render: renderDashboard },
  incidents: { title: 'Incidents', render: renderIncidents },
  incident: { title: 'Incident', render: renderIncident, hidden: true },
  patients: { title: 'Patients', render: renderPatients },
  patient: { title: 'Patient record', render: renderPatient, hidden: true },
  reports: { title: 'ePRFs', render: renderReports },
  prf: { title: 'ePRF', render: renderPRF, hidden: true },
  admissions: { title: 'Admissions', render: renderAdmissions },
  injury: { title: 'Police requests', render: renderInjury, count: 'pendingRequests' },
  erk: { title: 'Revive kit log', render: renderERK },
  training: { title: 'Training', render: renderTraining, needs: 'training' },
  staff: { title: 'Staff record', render: renderStaff, hidden: true },
  audit: { title: 'Audit log', render: renderAudit, supervisor: true },
};
const NAV_PARENT = { incident: 'incidents', patient: 'patients', prf: 'reports', staff: 'training' };

function renderNav() {
  const active = NAV_PARENT[S.page] || S.page;
  $('#nav').innerHTML = Object.entries(PAGES)
    .filter(([, p]) => !p.hidden && (!p.supervisor || S.boot.me.rank.supervisor) && (p.needs !== 'training' || (S.boot.training && S.boot.training.enabled)))
    .map(([k, p]) => {
      const n = p.count && S.counts[p.count];
      return `<button data-go="${k}" class="${k === active ? 'active' : ''}">${esc(p.title)}${n ? `<span class="count">${n}</span>` : ''}</button>`;
    }).join('');
  $$('#nav [data-go]').forEach((b) => (b.onclick = () => go(b.dataset.go)));
}

async function go(page, params = {}) {
  if (S.page === 'prf' && page !== 'prf' && S.prfDirty) {
    if (!(await confirmBox('Leave without saving?', 'Your changes to this ePRF have not been saved.', 'Leave', true))) return;
  }
  S.prfDirty = false; S.prfEdit = null;
  S.page = page; S.params = params;
  $('#pageTitle').textContent = PAGES[page].title;
  renderNav();
  $('#page').innerHTML = '<p class="empty">Loading…</p>';
  await PAGES[page].render($('#page'), params);
}

function applyBranding(b) {
  const r = document.documentElement.style;
  b.primary && r.setProperty('--primary', b.primary);
  b.secondary && r.setProperty('--secondary', b.secondary);
  $('#brand').innerHTML = (b.logo ? `<img src="${esc(b.logo)}" alt="">` : '') +
    `<div><div class="short">${esc(b.short)}</div><div class="long">${esc(b.name)}</div></div>`;
  $('#footer').textContent = b.footer || '';
  document.title = `${b.short} MDT`;
}

async function boot() {
  const r = await api('boot');
  if (!r) return false;
  S.boot = r;
  applyBranding(r.branding);
  $('#meName').textContent = r.me.name;
  $('#meRank').textContent = r.me.rank.label;
  $('#callsign').value = r.me.callsign || '';
  $('#callsign').dataset.prev = r.me.callsign || '';
  $('#status').innerHTML = options(r.lists.statuses, r.me.status);
  return true;
}

$('#callsign').addEventListener('change', async (e) => {
  const r = await api('unit.set', { callsign: e.target.value });
  if (r) { e.target.value = r.callsign; e.target.dataset.prev = r.callsign || ''; toast(`Callsign set to ${r.callsign || 'none'}.`); }
  else e.target.value = e.target.dataset.prev || '';
});

$('#status').addEventListener('change', async (e) => { const r = await api('unit.set', { status: e.target.value }); r && toast(`Status: ${r.status}`); });
$('#closeBtn').onclick = () => post('close');
document.addEventListener('keydown', (e) => {
  if (e.key !== 'Escape') return;
  if (!$('#modal').classList.contains('hidden')) closeModal(); else post('close');
});

window.addEventListener('message', async (e) => {
  const m = e.data || {};
  if (m.action === 'open') {
    $('#tablet').classList.remove('hidden');
    if (await boot()) go(S.page === 'prf' && S.prf ? 'prf' : 'dashboard', S.page === 'prf' && S.prf ? { id: S.prf.id } : {});
  } else if (m.action === 'close') {
    $('#tablet').classList.add('hidden'); closeModal();
  } else if (m.action === 'refresh') {
    queueRefresh(m.what);
  }
});

// Busy dispatch can fire many events a second. Collect them and redraw once after a
// short pause, so every open MDT isn't re-rendering and calling the server each time.
const REFRESH_MAP = { calls: ['dashboard'], incidents: ['dashboard', 'incidents', 'incident'], units: ['dashboard'], admissions: ['admissions', 'dashboard'], injury: ['injury', 'dashboard'] };
const pendingRefresh = new Set(); let refreshTimer = null;
function queueRefresh(what) {
  if (what === 'scope') { boot().then((ok) => ok && toast('Your clinical scope has been updated.')); return; }
  if (what) pendingRefresh.add(what);
  clearTimeout(refreshTimer);
  refreshTimer = setTimeout(flushRefresh, 1000);
}
function flushRefresh() {
  refreshTimer = null;
  if ($('#tablet').classList.contains('hidden')) { pendingRefresh.clear(); return; }
  if (pendingRefresh.has('calls') && emsCallNotes) { refreshCallNotes(); pendingRefresh.delete('calls'); pendingRefresh.add('calls-page'); }
  const whats = [...pendingRefresh].map((w) => (w === 'calls-page' ? 'calls' : w));
  if (!whats.some((w) => (REFRESH_MAP[w] || []).includes(S.page))) { pendingRefresh.clear(); return; }
  // A dialog is open or someone is typing: try again shortly rather than wiping their input
  if (!$('#modal').classList.contains('hidden') || isTyping()) { refreshTimer = setTimeout(flushRefresh, 1500); return; }
  pendingRefresh.clear();
  PAGES[S.page].render($('#page'), S.params);
}
// Don't redraw under someone typing in a search box or form on the page
function isTyping() { const a = document.activeElement; return !!(a && $('#page').contains(a) && /^(INPUT|TEXTAREA|SELECT)$/.test(a.tagName) && a.value); }

/* ---------- vinewood-dispatch calls ---------- */
let emsCallNotes = null;   // dispatchId whose updates modal is open
function callExtras(c) {
  const bits = [];
  if (c.unit) bits.push(`Unit: ${esc(c.unit)}`);
  if (c.vehicle) bits.push(`Vehicle: ${esc(c.vehicle)}`);
  if (c.caller) bits.push(`Caller: ${esc(c.caller)}`);
  if (c.unitNames && c.unitNames.length) bits.push(`Attached: ${esc(c.unitNames.join(', '))}`);
  const latest = c.notes && c.notes.length ? c.notes[c.notes.length - 1] : null;
  const note = latest ? `<div class="call-note"><b>${esc(latest.author)}</b> ${esc(latest.text)}</div>` : '';
  return (bits.length ? `<div class="sub">${bits.join(', ')}</div>` : '') + note;
}
function agoText(secs) {
  const m = Math.floor((secs || 0) / 60);
  return m < 1 ? 'just now' : m < 60 ? `${m} min ago` : `${Math.floor(m / 60)} h ${m % 60} min ago`;
}
function renderCallNotes(c) {
  const box = $('#cnList');
  if (!box) return;
  if (!c) { box.innerHTML = '<p class="empty">This call has been closed.</p>'; return; }
  box.innerHTML = c.notes && c.notes.length
    ? `<ol class="call-notes">${c.notes.map((n) => `<li><b>${esc(n.author)}</b> ${esc(n.text)} <span class="muted">${agoText(n.age)}</span></li>`).join('')}</ol>`
    : '<p class="empty">No updates yet.</p>';
  box.scrollTop = box.scrollHeight;
}
async function refreshCallNotes() {
  const id = emsCallNotes;
  const dc = await api('dispatch.list');
  if (!dc || emsCallNotes !== id) return;
  renderCallNotes(dc.calls.find((x) => x.dispatchId === id));
}
function callNotesModal(c) {
  emsCallNotes = c.dispatchId;
  openModal(`<h3>Call #${c.dispatchId}: ${esc(c.title)}</h3><p class="muted">${esc(c.location || 'No location')}</p>
    <div id="cnList" class="call-notes-box"></div>
    <label class="f" for="cnText">Add an update</label>
    <input id="cnText" maxlength="200" style="width:100%" placeholder="What's happening at the call">
    <div class="row end" style="margin-top:12px"><button class="btn" data-cnx>Close</button><button class="btn primary" data-cnpost>Post update</button></div>`, (m) => {
    const input = $('#cnText', m);
    const send = async () => {
      const text = input.value.trim();
      if (!text) { input.focus(); return; }
      const r = await api('dispatch.note', { id: c.dispatchId, text });
      if (!r) return;
      input.value = '';
      refreshCallNotes();
    };
    $('[data-cnx]', m).onclick = () => { emsCallNotes = null; closeModal(); };
    $('[data-cnpost]', m).onclick = send;
    input.onkeydown = (e) => { if (e.key === 'Enter') { e.preventDefault(); send(); } };
  });
  renderCallNotes(c);
}

/* ---------- dashboard ---------- */
async function renderDashboard(el) {
  const [r, dc] = await Promise.all([api('dashboard'), api('dispatch.list')]); if (!r) return;
  const calls = dc ? dc.calls : [];
  S.counts.pendingRequests = r.pendingRequests; renderNav();
  const cat1 = r.incidents.filter((i) => i.category === 1).length;
  const tAlerts = (S.boot.training && S.boot.training.alerts) || []; const sNotes = S.boot.me.rank.scopeNotes || [];
  el.innerHTML = `
    ${sNotes.length ? `<div class="alert red"><strong>Your scope is reduced.</strong> ${sNotes.map(esc).join(' ')} <a href="#" id="toMyTraining">View your training</a></div>` : ''}
    ${tAlerts.length ? `<div class="alert yellow"><strong>Training due:</strong> ${tAlerts.map((a) => `${esc(a.title)} ${a.days < 0 ? `expired ${-a.days} day${a.days === -1 ? '' : 's'} ago` : a.days === 0 ? 'expires today' : `expires in ${a.days} day${a.days === 1 ? '' : 's'}`}`).join('; ')}. ${sNotes.length ? '' : '<a href="#" id="toMyTraining">View your training</a>'}</div>` : ''}
    <div class="stats">
      <div class="stat"><b>${r.incidents.length}</b><span>Open incidents</span></div>
      <div class="stat"><b style="color:${cat1 ? 'var(--red)' : 'inherit'}">${cat1}</b><span>Cat 1 waiting</span></div>
      <div class="stat"><b>${r.units.length}</b><span>Clinicians on duty</span></div>
      <div class="stat"><b>${r.admitted}</b><span>Patients admitted</span></div>
    </div>
    <div class="cols">
      <div>
        ${dc && (dc.source || calls.length) ? `<section class="panel"><div class="panel-head"><h2>Live 999 calls <small>${esc(dc.source || '')}</small></h2><button class="btn small" id="rfCalls">Refresh</button></div>
          ${calls.length ? `<ul class="list">${calls.map((c, n) => `<li class="${c.attached ? 'call-attached' : ''}">${catBadge(c.category)}<div class="main"><strong>${c.dispatchId ? `<span class="call-ref">#${c.dispatchId}</span> ` : ''}${c.code ? esc(c.code) + ' ' : ''}${esc(c.title)}</strong>
            <div class="sub">${esc(c.location || 'No location')}, ${fmt((c.time || 0) * 1000, true)}${c.message ? '. ' + esc(c.message) : ''}</div>
            ${callExtras(c)}</div>
            ${c.dispatchId ? `<button class="btn small ${c.attached ? '' : 'primary'}" data-catt="${n}">${c.attached ? 'Detach' : 'Attach'}</button>
            <button class="btn small" data-cnotes="${n}">Updates${c.notes && c.notes.length ? ` (${c.notes.length})` : ''}</button>` : ''}
            ${!c.dispatchId && c.coords ? `<button class="btn small" data-cwp="${n}">Waypoint</button>` : ''}
            ${c.incident ? `<button class="btn small" data-inc-open="${c.incident}">Incident #${c.incident}</button>` : `<button class="btn primary small" data-raise="${n}">Raise incident</button>`}</li>`).join('')}</ul>` : '<p class="empty">No ambulance calls right now.</p>'}
        </section>` : ''}
        <section class="panel"><div class="panel-head"><h2>Open incidents</h2><button class="btn primary small" id="newInc">New incident</button></div>
          ${r.incidents.length ? `<ul class="list">${r.incidents.map(incidentRow).join('')}</ul>` : '<p class="empty">No open incidents. New 999 calls will appear here.</p>'}
        </section>
        <section class="panel"><div class="panel-head"><h2>Your draft ePRFs</h2><button class="btn small" id="newPrf">Start ePRF</button></div>
          ${r.drafts.length ? `<ul class="list">${r.drafts.map((d) => `<li class="click" data-prf="${d.id}"><div class="main"><strong>${esc(d.patient_name || 'Patient not set')}</strong><div class="sub">${esc(d.ref)}, last saved ${fmt(d.updated_at)}</div></div><span class="tag yellow">Draft</span></li>`).join('')}</ul>` : '<p class="empty">No drafts. Start an ePRF when you reach a patient.</p>'}
        </section>
      </div>
      <section class="panel"><h2>On duty</h2>
        ${r.units.length ? `<ul class="list">${r.units.map((u) => `<li><div class="main"><strong>${u.callsign ? esc(u.callsign) + ' ' : ''}${esc(u.name)}</strong><div class="sub">${esc(u.rank)}${u.incident ? `, incident #${u.incident}` : ''}</div></div><span class="status-pill s-${esc(u.status)}">${esc(u.status)}</span></li>`).join('')}</ul>` : '<p class="empty">No one else is on duty.</p>'}
        ${r.pendingRequests ? `<div class="alert yellow" style="margin:14px 0 0">${r.pendingRequests} police request${r.pendingRequests > 1 ? 's' : ''} waiting for an injury statement. <a href="#" id="toInj">Review</a></div>` : ''}
      </section>
    </div>`;
  bindIncidentRows(el);
  $('#newInc', el).onclick = newIncidentModal;
  $('#newPrf', el).onclick = () => startPRF({});
  const mt = $('#toMyTraining', el); mt && (mt.onclick = (e) => { e.preventDefault(); go('staff', { cid: S.boot.me.cid }); });
  const rf = $('#rfCalls', el); rf && (rf.onclick = () => renderDashboard(el));
  $$('[data-cwp]', el).forEach((b) => (b.onclick = () => post('waypoint', calls[+b.dataset.cwp].coords)));
  $$('[data-catt]', el).forEach((b) => (b.onclick = () => {
    const c = calls[+b.dataset.catt];
    b.disabled = true;
    post('dispatchRespond', { id: c.dispatchId, coords: c.coords, unitSrc: c.unitSrc });
  }));
  $$('[data-cnotes]', el).forEach((b) => (b.onclick = () => callNotesModal(calls[+b.dataset.cnotes])));
  $$('[data-inc-open]', el).forEach((b) => (b.onclick = () => go('incident', { id: b.dataset.incOpen })));
  $$('[data-raise]', el).forEach((b) => (b.onclick = async () => {
    const c = calls[+b.dataset.raise];
    const details = [c.message, c.unit && `Unit: ${c.unit}`, c.vehicle && `Vehicle: ${c.vehicle}`, c.caller && `Caller: ${c.caller}`,
      ...(c.notes || []).map((x) => `${x.author}: ${x.text}`)].filter(Boolean).join('\n');
    const res = await api('incidents.create', { callId: c.id, dispatchId: c.dispatchId, title: (c.code ? c.code + ' ' : '') + c.title, details, location: c.location || '', coords: c.coords, category: c.category, source: c.source });
    if (res) { toast(res.existing ? 'Already raised. Opening it.' : 'Incident raised from the call.'); go('incident', { id: res.id }); }
  }));
  $$('[data-prf]', el).forEach((li) => (li.onclick = () => go('prf', { id: li.dataset.prf })));
  const ti = $('#toInj', el); ti && (ti.onclick = (e) => { e.preventDefault(); go('injury'); });
}

function incidentRow(i) {
  const units = (i.units || []).map((u) => u.callsign || u.name).join(', ');
  return `<li class="click" data-inc="${i.id}">${catBadge(i.category)}<div class="main"><strong>${esc(i.title)}</strong>
    <div class="sub">${esc(i.location || 'No location')}, ${fmt(i.created_at, true)}${units ? `. Units: ${esc(units)}` : '. No units assigned'}</div></div>
    ${i.hems_requested ? '<span class="tag yellow">HEMS</span>' : ''}</li>`;
}
function bindIncidentRows(el) { $$('[data-inc]', el).forEach((li) => (li.onclick = () => go('incident', { id: li.dataset.inc }))); }

/* ---------- incidents ---------- */
function newIncidentModal() {
  const cats = S.boot.lists.categories;
  openModal(`<h3>New incident</h3><p>Raise a job for the ambulance service. Everyone on duty is notified.</p>
    <div class="grid2">
      <label class="f spanall"><span>Title</span><input id="iTitle" placeholder="e.g. RTC, motorcyclist off"></label>
      <label class="f"><span>Category</span><select id="iCat">${cats.map((c) => `<option value="${c.id}" ${c.id === 2 ? 'selected' : ''}>${c.label}: ${esc(c.desc)}</option>`).join('')}</select></label>
      <label class="f"><span>Location</span><input id="iLoc" placeholder="Street or landmark"></label>
      <label class="f spanall"><span>Details</span><textarea id="iDet"></textarea></label>
      <label class="check spanall"><input type="checkbox" id="iMine" checked> Use my current location for the waypoint</label>
    </div>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Raise incident</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => {
      const r = await api('incidents.create', { title: $('#iTitle').value, category: $('#iCat').value, location: $('#iLoc').value, details: $('#iDet').value, useMyLocation: $('#iMine').checked });
      if (r) { closeModal(); toast('Incident raised.'); go('incident', { id: r.id }); }
    };
  });
}

async function renderIncidents(el, p) {
  const status = p.status || 'open';
  const r = await api('incidents.list', { status }); if (!r) return;
  el.innerHTML = `<section class="panel"><div class="panel-head">
      <div class="row"><button class="btn small ${status === 'open' ? 'primary' : ''}" data-s="open">Open</button><button class="btn small ${status === 'closed' ? 'primary' : ''}" data-s="closed">Closed</button></div>
      <button class="btn primary small" id="newInc">New incident</button></div>
    ${r.incidents.length ? `<ul class="list">${r.incidents.map(incidentRow).join('')}</ul>` : `<p class="empty">${status === 'open' ? 'No open incidents.' : 'No closed incidents yet.'}</p>`}</section>`;
  $$('[data-s]', el).forEach((b) => (b.onclick = () => go('incidents', { status: b.dataset.s })));
  $('#newInc', el).onclick = newIncidentModal;
  bindIncidentRows(el);
}

async function renderIncident(el, p) {
  const r = await api('incidents.get', { id: p.id }); if (!r) return;
  const i = r.incident; const me = S.boot.me;
  const attached = (i.units || []).some((u) => u.cid === me.cid);
  const cat = S.boot.lists.categories.find((c) => c.id === i.category) || {};
  el.innerHTML = `
    ${i.hems_requested ? '<div class="alert yellow">HEMS has been requested for this incident.</div>' : ''}
    <div class="cols"><section class="panel">
      <div class="panel-head"><div class="row">${catBadge(i.category)}<h2>${esc(i.title)}</h2></div><span class="tag ${i.status === 'open' ? 'green' : ''}">${i.status === 'open' ? 'Open' : 'Closed'}</span></div>
      <div class="readonly"><dl>
        <dt>Category</dt><dd>${esc(cat.label)}: ${esc(cat.desc)}</dd>
        <dt>Location</dt><dd>${esc(i.location || 'Not given')}</dd>
        <dt>Raised</dt><dd>${fmt(i.created_at)} by ${esc(i.created_by)}${i.source && i.source !== 'mdt' ? ` (via ${esc(i.source)})` : ''}</dd>
        ${i.dispatch_id ? `<dt>Dispatch call</dt><dd>#${esc(i.dispatch_id)}. Attaching here also attaches you to the call.</dd>` : ''}
        <dt>Details</dt><dd>${esc(i.details || 'None')}</dd>
      </dl></div>
      <div class="row" style="margin-top:16px">
        ${i.status === 'open' ? `<button class="btn primary" id="attach">${attached ? 'Leave incident' : 'Attach my unit'}</button>` : ''}
        ${i.coords ? '<button class="btn" id="wp">Set waypoint</button>' : ''}
        <button class="btn" id="prf">Start ePRF for this incident</button>
        ${i.status === 'open' && !i.hems_requested ? '<button class="btn hems" id="hems">Request HEMS</button>' : ''}
        ${i.status === 'open' ? '<button class="btn danger" id="close">Close incident</button>' : (me.rank.supervisor ? '<button class="btn" id="reopen">Reopen</button>' : '')}
      </div></section>
      <div>
        <section class="panel"><h2>Units</h2>${(i.units || []).length ? `<ul class="list">${i.units.map((u) => `<li><div class="main"><strong>${u.callsign ? esc(u.callsign) + ' ' : ''}${esc(u.name)}</strong></div></li>`).join('')}</ul>` : '<p class="empty">No units attached.</p>'}</section>
        <section class="panel"><h2>ePRFs</h2>${r.reports.length ? `<ul class="list">${r.reports.map((x) => `<li class="click" data-prf="${x.id}"><div class="main"><strong>${esc(x.patient_name || 'Patient not set')}</strong><div class="sub">${esc(x.ref)}, ${esc(x.author_name)}</div></div><span class="tag ${x.status === 'final' ? 'green' : 'yellow'}">${x.status === 'final' ? 'Final' : 'Draft'}</span></li>`).join('')}</ul>` : '<p class="empty">No ePRFs yet.</p>'}</section>
      </div></div>`;
  const b = (id, fn) => { const x = $('#' + id, el); x && (x.onclick = fn); };
  b('attach', async () => { (await api('incidents.attach', { id: i.id, detach: attached })) && renderIncident(el, p); });
  b('wp', () => post('waypoint', i.coords));
  b('prf', () => startPRF({ incidentId: i.id }));
  b('close', async () => { if (await confirmBox('Close incident?', 'Attached units will be cleared.', 'Close incident', true)) (await api('incidents.close', { id: i.id })) && go('incidents'); });
  b('reopen', async () => { (await api('incidents.reopen', { id: i.id })) && renderIncident(el, p); });
  b('hems', () => openModal(`<h3>Request HEMS</h3><p>Critical care paramedics on duty will be alerted.</p>
      <label class="f"><span>Reason</span><textarea id="hR" placeholder="e.g. Motorcyclist, GCS 8, suspected major trauma"></textarea></label>
      <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn hems" data-ok>Request HEMS</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => {
      const r2 = await api('incidents.hems', { id: i.id, reason: $('#hR').value });
      if (r2) { closeModal(); toast(r2.notified ? `HEMS requested. ${r2.notified} critical care clinician${r2.notified > 1 ? 's' : ''} alerted.` : 'HEMS requested. No critical care clinicians are on duty.', !r2.notified); renderIncident(el, p); }
    };
  }));
  $$('[data-prf]', el).forEach((li) => (li.onclick = () => go('prf', { id: li.dataset.prf })));
}

/* ---------- patients ---------- */
function askReason(person) {
  openModal(`<h3>Open ${esc(person.name)}'s record</h3><p>Record access is logged. Choose why you need it.</p>
    <label class="f"><span>Reason</span><select id="rsn">${options(S.boot.lists.auditReasons)}</select></label>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Open record</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = () => { const reason = $('#rsn').value; closeModal(); go('patient', { cid: person.cid, reason }); };
  });
}

function personRow(p) {
  const flags = (p.flags || []).map((f) => `<span class="tag red">${esc(f)}</span>`).join('');
  return `<li class="click" data-cid="${esc(p.cid)}" data-name="${esc(p.name)}"><div class="main"><strong>${esc(p.name)}</strong>
    <div class="sub">${esc(p.cid)}${p.dob ? `, born ${esc(p.dob)}` : ''}${p.sex ? `, ${esc(p.sex)}` : ''}</div></div>
    ${p.hasAllergies ? '<span class="tag yellow">Allergies</span>' : ''}${flags}</li>`;
}

async function renderPatients(el) {
  el.innerHTML = `<section class="panel"><h2>Find a patient</h2>
    <input id="q" placeholder="Name or citizen ID" autocomplete="off">
    <ul class="list" id="res" style="margin-top:10px"></ul><p class="empty" id="hint">Type at least two letters.</p></section>`;
  let timer;
  $('#q', el).oninput = (e) => {
    clearTimeout(timer);
    timer = setTimeout(async () => {
      const term = e.target.value.trim();
      if (term.length < 2) { $('#res').innerHTML = ''; $('#hint').textContent = 'Type at least two letters.'; return; }
      const r = await api('people.search', { term }); if (!r) return;
      $('#res').innerHTML = r.people.map(personRow).join('');
      $('#hint').textContent = r.people.length ? '' : `No one matches "${term}".`;
      $$('#res [data-cid]').forEach((li) => (li.onclick = () => askReason({ cid: li.dataset.cid, name: li.dataset.name })));
    }, 250);
  };
  $('#q', el).focus();
}

async function renderPatient(el, p) {
  const r = await api('patient.open', { cid: p.cid, reason: p.reason }); if (!r) return;
  const rec = r.record || {}; const pe = r.person; const me = S.boot.me;
  const current = r.admissions.find((a) => !a.discharged_at);
  $('#pageTitle').textContent = pe.name;
  el.innerHTML = `
    ${current ? `<div class="alert yellow">Currently admitted to ${esc(current.hospital_label)} since ${fmt(current.admitted_at)}.</div>` : ''}
    ${rec.allergies ? `<div class="alert red"><strong>Allergies:</strong> ${esc(rec.allergies)}</div>` : ''}
    <div class="cols"><div>
      <section class="panel"><div class="panel-head"><h2>Clinical record</h2><button class="btn primary small" id="save">Save record</button></div>
        <div class="grid3">
          <label class="f"><span>Citizen ID</span><input value="${esc(pe.cid)}" disabled></label>
          <label class="f"><span>Date of birth</span><input value="${esc(pe.dob || '')}" disabled></label>
          <label class="f"><span>Blood type</span><select id="bt">${options(['', 'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'], rec.blood_type)}</select></label>
          <label class="f spanall"><span>Allergies</span><input id="al" value="${esc(rec.allergies || '')}" placeholder="None known"></label>
          <label class="f"><span>Conditions</span><textarea id="co">${esc(rec.conditions || '')}</textarea></label>
          <label class="f"><span>Regular medication</span><textarea id="rm">${esc(rec.regular_meds || '')}</textarea></label>
          <label class="f"><span>Next of kin</span><textarea id="nk">${esc(rec.nok || '')}</textarea></label>
          <label class="f spanall"><span>Clinical notes</span><textarea id="nt">${esc(rec.notes || '')}</textarea></label>
          <label class="f spanall"><span>Alerts (comma separated, e.g. DNACPR, Violent, Diabetic)</span><input id="fl" value="${esc((rec.flags || []).join(', '))}"></label>
        </div></section>
      <section class="panel"><div class="panel-head"><h2>ePRFs</h2><button class="btn small" id="newPrf">Start ePRF</button></div>
        ${r.reports.length ? `<table class="t"><tr><th></th><th>Ref</th><th>Date</th><th>Outcome</th><th>Clinician</th></tr>${r.reports.map((x) => `<tr class="click" data-prf="${x.id}"><td>${newsBadge(x.news2)}</td><td>${esc(x.ref)}${x.flatline ? ' <span class="tag red">Flatline</span>' : ''}</td><td>${fmt(x.created_at)}</td><td>${x.status === 'final' ? esc(x.outcome_label || '') : '<span class="tag yellow">Draft</span>'}</td><td>${esc(x.author_name)}</td></tr>`).join('')}</table>` : '<p class="empty">No ePRFs for this patient.</p>'}
      </section></div>
      <div>
        <section class="panel"><div class="panel-head"><h2>Prescriptions</h2>${me.rank.prescribe ? '<button class="btn small" id="rx">Prescribe</button>' : ''}</div>
          ${r.prescriptions.length ? `<ul class="list">${r.prescriptions.map((x) => `<li><div class="main"><strong>${x.qty ? esc(x.qty) + 'x ' : ''}${esc(x.drug)} ${esc(x.dose || '')}</strong>${x.instructions ? `<div class="sub">${esc(x.instructions)}</div>` : ''}<div class="sub">${esc(x.prescriber_name)}, ${fmt(x.created_at)}${x.status === 'collected' && x.handed_by ? `. Handed over by ${esc(x.handed_by)}` : ''}</div></div>
            ${x.status === 'pending' ? `<button class="btn small primary" data-hand="${x.id}">Hand over</button><button class="btn small danger" data-rxc="${x.id}" aria-label="Cancel prescription">✕</button>` : `<span class="tag ${x.status === 'cancelled' ? 'red' : 'green'}">${x.status === 'cancelled' ? 'Cancelled' : 'Collected'}</span>`}</li>`).join('')}</ul>` : `<p class="empty">No prescriptions.${me.rank.prescribe ? '' : ` ${esc(me.rank.label)}s cannot prescribe.`}</p>`}
        </section>
        <section class="panel"><h2>Admissions</h2>
          ${r.admissions.length ? `<ul class="list">${r.admissions.map((a) => `<li><div class="main"><strong>${esc(a.hospital_label)}</strong><div class="sub">${fmt(a.admitted_at)}${a.discharged_at ? ` to ${fmt(a.discharged_at)}` : ', still admitted'}</div></div></li>`).join('')}</ul>` : '<p class="empty">No admissions.</p>'}
        </section>
      </div></div>`;
  $('#save', el).onclick = async () => {
    const fields = { blood_type: $('#bt').value, allergies: $('#al').value, conditions: $('#co').value, regular_meds: $('#rm').value, nok: $('#nk').value, notes: $('#nt').value, flags: $('#fl').value.split(',').map((s) => s.trim()).filter(Boolean) };
    (await api('patient.save', { cid: pe.cid, fields })) && toast('Record saved.');
  };
  $('#newPrf', el).onclick = () => startPRF({ cid: pe.cid });
  $$('[data-prf]', el).forEach((tr) => (tr.onclick = () => go('prf', { id: tr.dataset.prf })));
  $$('[data-hand]', el).forEach((b) => (b.onclick = async () => {
    const res = await api('prescription.handover', { id: b.dataset.hand });
    if (res) { toast(res.message); renderPatient(el, p); }
  }));
  $$('[data-rxc]', el).forEach((b) => (b.onclick = async () => {
    if (!(await confirmBox('Cancel prescription?', 'It will no longer be available to hand over.', 'Cancel prescription', true))) return;
    (await api('prescription.cancel', { id: b.dataset.rxc })) && renderPatient(el, p);
  }));
  const rx = $('#rx', el);
  rx && (rx.onclick = () => {
    const meds = S.boot.lists.meds.filter((m) => m.prescribe && m.allowed);
    if (!meds.length) return toast('Nothing in your formulary can be prescribed.', true);
    const opt = (m) => `<option value="${esc(m.name)}" ${m.missing ? 'disabled' : ''}>${esc(m.name)}${m.missing ? ' (item missing from inventory)' : ''}</option>`;
    openModal(`<h3>Prescribe for ${esc(pe.name)}</h3><p>The patient is handed the medication if they're standing with you. If not, it's saved and you can hand it over later.</p>
      <div class="grid3"><label class="f span2"><span>Medication</span><select id="pd">${meds.map(opt).join('')}</select></label>
      <label class="f"><span>Quantity</span><input id="pq" type="number" min="1"></label>
      <label class="f"><span>Dose</span><input id="pdo"></label>
      <label class="f span2"><span>Instructions</span><input id="pin" placeholder="e.g. One every 6 hours for pain"></label></div>
      <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Prescribe</button></div>`, (m) => {
      const sync = () => { const x = meds.find((y) => y.name === $('#pd').value); if (!x) return; $('#pdo').value = x.dose || ''; $('#pq').value = x.qty || 1; $('#pq').max = x.maxQty || 10; };
      const first = meds.find((x) => !x.missing); if (first) $('#pd').value = first.name;
      $('#pd', m).onchange = sync; sync();
      $('[data-x]', m).onclick = closeModal;
      $('[data-ok]', m).onclick = async () => {
        const res = await api('prescription.add', { cid: pe.cid, drug: $('#pd').value, qty: $('#pq').value, dose: $('#pdo').value, instructions: $('#pin').value });
        if (res) { closeModal(); toast(res.message); renderPatient(el, p); }
      };
    });
  });
}

/* ---------- ePRFs ---------- */
async function startPRF(o) {
  const r = await api('report.new', o);
  if (r) { toast(`${r.ref} started.`); go('prf', { id: r.id }); }
}

async function renderReports(el) {
  el.innerHTML = `<section class="panel"><div class="panel-head"><h2>Patient report forms</h2><button class="btn primary small" id="newPrf">Start ePRF</button></div>
    <input id="q" placeholder="Search by reference, patient or clinician"><div id="res" style="margin-top:10px"></div></section>`;
  const load = async (term) => {
    const r = await api('report.list', { term }); if (!r) return;
    $('#res').innerHTML = r.reports.length ? `<table class="t"><tr><th></th><th>Ref</th><th>Patient</th><th>Date</th><th>Outcome</th><th>Clinician</th></tr>${r.reports.map((x) => `<tr class="click" data-prf="${x.id}"><td>${newsBadge(x.news2)}</td><td>${esc(x.ref)}${x.flatline ? ' <span class="tag red">Flatline</span>' : ''}</td><td>${esc(x.patient_name || '—')}</td><td>${fmt(x.created_at)}</td><td>${x.status === 'final' ? esc(x.outcome_label || '') : '<span class="tag yellow">Draft</span>'}</td><td>${esc(x.author_name)}</td></tr>`).join('')}</table>` : '<p class="empty">No ePRFs match.</p>';
    $$('#res [data-prf]').forEach((tr) => (tr.onclick = () => go('prf', { id: tr.dataset.prf })));
  };
  let t; $('#q', el).oninput = (e) => { clearTimeout(t); t = setTimeout(() => load(e.target.value), 250); };
  $('#newPrf', el).onclick = () => startPRF({});
  load('');
}

const TABS = [
  ['incident', 'Incident'], ['assessment', 'Assessment'], ['obs', 'Observations'],
  ['ecg', 'ECG and arrest'], ['treatment', 'Treatment'], ['outcome', 'Outcome and handover'],
];

async function renderPRF(el, p) {
  const r = await api('report.get', { id: p.id }); if (!r) return;
  S.prf = r.report; S.prfDirty = false; S.prfEdit = null;
  if (!TABS.find((t) => t[0] === S.prfTab)) S.prfTab = 'incident';
  drawPRF(el);
}

function prfFlatline() { const e = S.prf.data.ecg; return !!(e.arrest || isArrestRhythm(e.rhythm)); }

function drawPRF(el) {
  const R = S.prf; const isFinal = R.status === 'final'; const final = isFinal && !S.prfEdit; const d = R.data;
  $('#pageTitle').textContent = R.ref;
  const lastObs = d.obs[d.obs.length - 1];
  const flat = prfFlatline();
  el.innerHTML = `
    <div class="prf-head"><div>
        <h2>${esc(R.patient_name || 'Patient not set')} ${S.prfEdit ? '<span class="tag yellow">Editing</span>' : isFinal ? '<span class="tag green">Finalised</span>' : '<span class="tag yellow">Draft</span>'}${(R.revisions || []).length ? ` <span class="tag">Edited ${R.revisions.length}×</span>` : ''}</h2>
        <div class="muted">${esc(R.ref)}, started ${fmt(R.created_at)} by ${esc(R.author_name)}${R.incident_id ? `, <a href="#" id="toInc">incident #${R.incident_id}</a>` : ''}</div>
        <div class="muted">Crew: ${(d.crew || []).map((c) => `${esc(c.name)} (${esc(c.rank)})`).join(', ')}</div>
      </div>
      <div class="row">${newsBadge(lastObs ? (lastObs.news2 ?? news2(lastObs)) : null)}
        ${final ? `${R.canEdit ? '<button class="btn primary" id="editPrf">Edit ePRF</button>' : ''}<button class="btn" id="amend">Add amendment</button>`
          : S.prfEdit ? '<button class="btn" id="cancelEdit">Cancel editing</button><button class="btn primary" id="saveEdit">Save changes</button>'
          : `<button class="btn danger small" id="discard">Discard draft</button><button class="btn" id="saveD">Save draft</button><button class="btn primary" id="fin">Finalise</button>`}
      </div></div>
    ${flat && S.boot.lists.flatlineRule ? '<div class="alert red"><strong>Patient flatlined.</strong> They must be conveyed to hospital, even if revived.</div>' : ''}
    ${S.prfEdit ? `<div class="alert yellow"><strong>Editing a finalised ePRF.</strong> Reason: ${esc(S.prfEdit.reason)}. The previous version is kept in the edit history.</div>` : ''}
    ${!final ? patientPicker(R) : ''}
    <div class="tabs">${TABS.map(([k, l]) => `<button data-tab="${k}" class="${S.prfTab === k ? 'active' : ''}">${l}${k === 'ecg' && flat ? '<span class="dot"></span>' : ''}</button>`).join('')}</div>
    <section class="panel" id="tabBody">${final ? prfReadonly(S.prfTab) : prfTabEdit(S.prfTab)}</section>
    ${(R.revisions || []).length ? `<section class="panel"><h2>Edit history</h2><ul class="list">${R.revisions.map((v) => `<li><div class="main"><strong>${esc(v.edited_by)}, ${fmt(v.created_at)}</strong><div>${esc(v.reason)}</div><div class="sub">Changed: ${esc(v.changes)}</div></div><button class="btn small" data-rev="${v.id}">Previous version</button></li>`).join('')}</ul></section>` : ''}
    ${(R.amendments || []).length ? `<section class="panel"><h2>Amendments</h2><ul class="list">${R.amendments.map((a) => `<li><div class="main"><strong>${esc(a.by)} (${esc(a.rank)}), ${esc(a.at)}</strong><div>${esc(a.note)}</div></div></li>`).join('')}</ul></section>` : ''}`;

  $$('[data-tab]', el).forEach((b) => (b.onclick = () => { S.prfTab = b.dataset.tab; drawPRF(el); }));
  const ti = $('#toInc', el); ti && (ti.onclick = (e) => { e.preventDefault(); go('incident', { id: R.incident_id }); });
  $$('[data-rev]', el).forEach((b) => (b.onclick = () => revisionModal(b.dataset.rev)));
  if (final) {
    $('#amend', el).onclick = () => amendModal(el);
    const ep = $('#editPrf', el); ep && (ep.onclick = () => startEdit(el));
    return;
  }
  bindPRFInputs(el);
  if (S.prfEdit) {
    $('#cancelEdit', el).onclick = async () => {
      if (S.prfDirty && !(await confirmBox('Discard your changes?', 'The ePRF will go back to how it was.', 'Discard changes', true))) return;
      renderPRF(el, { id: R.id });
    };
    $('#saveEdit', el).onclick = () => savePRF(el, true);
    return;
  }
  $('#saveD', el).onclick = () => savePRF(el, false);
  $('#fin', el).onclick = async () => { if (await confirmBox('Finalise this ePRF?', 'It will be locked. Later changes are added as amendments.', 'Finalise')) savePRF(el, true); };
  $('#discard', el).onclick = async () => { if (await confirmBox('Discard this draft?', 'The draft will be deleted.', 'Discard', true)) { (await api('report.delete', { id: R.id })) && (S.prfDirty = false, go('reports')); } };
}

function patientPicker(R) {
  return `<section class="panel"><div class="grid3">
    <label class="f span2"><span>Patient${R.citizenid ? ` (linked to ${esc(R.citizenid)})` : ''}</span>
      <input id="pp" placeholder="Search name or ID to link, or type a name for an unknown patient" value="${esc(R.patient_name || '')}" autocomplete="off">
      <ul class="list" id="ppRes"></ul></label>
    <label class="f"><span>Location</span><input id="loc" value="${esc(R.location || '')}"></label>
  </div></section>`;
}

function field(path, label, type = 'input', extra = '') {
  const v = getPath(S.prf.data, path) ?? '';
  if (type === 'textarea') return `<label class="f ${extra}"><span>${label}</span><textarea data-bind="${path}">${esc(v)}</textarea></label>`;
  return `<label class="f ${extra}"><span>${label}</span><input data-bind="${path}" value="${esc(v)}"></label>`;
}

function prfTabEdit(tab) {
  const d = S.prf.data; const L = S.boot.lists;
  if (tab === 'incident') return `<div class="grid3">
    ${field('incident.time_call', 'Time of call')}${field('incident.time_scene', 'Time on scene')}${field('incident.time_left', 'Time left scene')}
    ${field('incident.mechanism', 'Mechanism / what happened', 'textarea', 'spanall')}</div>`;
  if (tab === 'assessment') return `<div class="grid2">
    ${field('assessment.complaint', 'Presenting complaint', 'input', 'spanall')}
    ${field('assessment.history', 'History', 'textarea', 'spanall')}
    ${field('assessment.airway', 'Airway', 'textarea')}${field('assessment.breathing', 'Breathing', 'textarea')}
    ${field('assessment.circulation', 'Circulation', 'textarea')}${field('assessment.disability', 'Disability', 'textarea')}
    ${field('assessment.exposure', 'Exposure / injuries found', 'textarea', 'spanall')}</div>`;
  if (tab === 'obs') return `
    ${d.obs.length ? `<table class="t"><tr><th>Time</th><th>HR</th><th>BP</th><th>RR</th><th>SpO₂</th><th>O₂</th><th>Temp</th><th>AVPU</th><th>GCS</th><th>BM</th><th>Pain</th><th>NEWS2</th><th>By</th><th></th></tr>
      ${d.obs.map((o, i) => `<tr><td>${esc(o.time)}</td><td>${esc(o.hr)}</td><td>${esc(o.sbp)}${o.dbp ? '/' + esc(o.dbp) : ''}</td><td>${esc(o.rr)}</td><td>${esc(o.spo2)}</td><td>${o.o2 ? 'Yes' : ''}</td><td>${esc(o.temp)}</td><td>${esc(o.avpu)}</td><td>${esc(o.gcs)}</td><td>${esc(o.bm)}</td><td>${esc(o.pain)}</td><td>${newsBadge(o.news2 ?? news2(o))}</td><td>${esc(o.by || 'Unsaved')}${editedMark(o)}</td><td class="nowrap"><button class="btn small" data-ed="obs:${i}" aria-label="Edit">✎</button> <button class="btn small danger" data-rm="obs:${i}" aria-label="Remove">✕</button></td></tr>`).join('')}</table>` : '<p class="empty">No observations yet. Record a set below.</p>'}
    <h2 style="margin-top:18px">Record observations</h2>
    <div class="grid4" id="obsForm">
      <label class="f"><span>Time</span><input data-o="time" value="${nowHM()}"></label>
      <label class="f"><span>Heart rate</span><input data-o="hr" inputmode="numeric"></label>
      <label class="f"><span>Systolic BP</span><input data-o="sbp" inputmode="numeric"></label>
      <label class="f"><span>Diastolic BP</span><input data-o="dbp" inputmode="numeric"></label>
      <label class="f"><span>Resp. rate</span><input data-o="rr" inputmode="numeric"></label>
      <label class="f"><span>SpO₂ %</span><input data-o="spo2" inputmode="numeric"></label>
      <label class="f"><span>Temp °C</span><input data-o="temp" inputmode="decimal"></label>
      <label class="f"><span>AVPU</span><select data-o="avpu">${options([['', '—'], ['A', 'Alert'], ['C', 'New confusion'], ['V', 'Voice'], ['P', 'Pain'], ['U', 'Unresponsive']].map(([v, l]) => ({ v, l })), '', 'v', 'l')}</select></label>
      <label class="f"><span>GCS</span><input data-o="gcs" inputmode="numeric"></label>
      <label class="f"><span>Blood glucose</span><input data-o="bm" inputmode="decimal"></label>
      <label class="f"><span>Pain (0–10)</span><input data-o="pain" inputmode="numeric"></label>
      <label class="check" style="align-self:end;padding-bottom:8px"><input type="checkbox" data-o="o2"> On oxygen</label>
    </div>
    <div class="row" style="margin-top:12px"><span id="liveNews">${newsBadge(null)}</span><span class="muted">NEWS2 updates as you type</span>
      <span style="flex:1"></span><button class="btn" id="pull">Pull vitals from patient</button><button class="btn primary" id="addObs">Add observations</button></div>`;
  if (tab === 'ecg') return `<div class="grid3">
    <label class="f"><span>Rhythm</span><select data-bind="ecg.rhythm">${options(L.rhythms.map((r) => r.name), d.ecg.rhythm)}</select></label>
    <label class="f"><span>Shocks delivered</span><input data-bind="ecg.shocks" inputmode="numeric" value="${esc(d.ecg.shocks)}"></label>
    <label class="f"><span>ROSC time</span><input data-bind="ecg.rosc_time" value="${esc(d.ecg.rosc_time)}" placeholder="If revived"></label>
    <label class="check spanall"><input type="checkbox" data-bind="ecg.arrest" ${d.ecg.arrest ? 'checked' : ''}> Patient flatlined or was in cardiac arrest at any point</label>
    ${field('ecg.notes', 'ECG notes', 'textarea', 'spanall')}</div>`;
  if (tab === 'treatment') {
    const meds = L.meds.filter((m) => m.scene); const ints = L.interventions;
    return `<h2>Medication given</h2>
      ${d.meds.length ? `<table class="t"><tr><th>Time</th><th>Drug</th><th>Dose</th><th>Route</th><th>Given by</th><th></th></tr>${d.meds.map((m, i) => `<tr><td>${esc(m.time)}</td><td>${esc(m.name)}</td><td>${esc(m.dose)}</td><td>${esc(m.route)}</td><td>${m.by ? `${esc(m.by)} (${esc(m.by_rank)})` : 'Unsaved'}${editedMark(m)}</td><td class="nowrap"><button class="btn small" data-ed="meds:${i}" aria-label="Edit">✎</button> <button class="btn small danger" data-rm="meds:${i}" aria-label="Remove">✕</button></td></tr>`).join('')}</table>` : '<p class="empty">No medication recorded.</p>'}
      <div class="grid4" style="margin-top:10px">
        <label class="f"><span>Drug</span><select id="mName">${meds.map((m) => `<option value="${esc(m.name)}" ${m.allowed ? '' : 'disabled'}>${esc(m.name)}${m.allowed ? '' : ' (outside your scope)'}</option>`).join('')}</select></label>
        <label class="f"><span>Dose</span><input id="mDose"></label>
        <label class="f"><span>Route</span><select id="mRoute"></select></label>
        <label class="f"><span>Time</span><input id="mTime" value="${nowHM()}"></label>
      </div>
      <div class="row end" style="margin-top:10px"><span class="opt-why" style="flex:1">${esc(S.boot.me.rank.label)}: ${S.boot.me.rank.formulary === 'full' ? 'full formulary' : 'limited formulary'}${S.boot.me.rank.transfuse ? ', can transfuse blood' : ', cannot transfuse blood'}.</span><button class="btn primary" id="addMed">Add medication</button></div>
      <h2 style="margin-top:22px">Interventions</h2>
      ${d.interventions.length ? `<table class="t"><tr><th>Time</th><th>Intervention</th><th>Notes</th><th>By</th><th></th></tr>${d.interventions.map((x, i) => `<tr><td>${esc(x.time)}</td><td>${esc(x.name)}</td><td>${esc(x.notes)}</td><td>${esc(x.by || 'Unsaved')}${editedMark(x)}</td><td class="nowrap"><button class="btn small" data-ed="interventions:${i}" aria-label="Edit">✎</button> <button class="btn small danger" data-rm="interventions:${i}" aria-label="Remove">✕</button></td></tr>`).join('')}</table>` : '<p class="empty">No interventions recorded.</p>'}
      <div class="grid4" style="margin-top:10px">
        <label class="f"><span>Intervention</span><select id="iName">${ints.map((x) => `<option value="${esc(x.name)}" ${x.allowed ? '' : 'disabled'}>${esc(x.name)}${x.allowed ? '' : ' (outside your scope)'}</option>`).join('')}</select></label>
        <label class="f span2"><span>Notes</span><input id="iNotes"></label>
        <label class="f"><span>Time</span><input id="iTime" value="${nowHM()}"></label>
      </div>
      <div class="row end" style="margin-top:10px"><button class="btn primary" id="addInt">Add intervention</button></div>`;
  }
  if (tab === 'outcome') {
    const flat = prfFlatline();
    const allowed = L.flatlineOutcomes || {};
    return `<div class="grid2">
      <label class="f"><span>Outcome</span><select data-bind="outcome.outcome"><option value="">Choose an outcome</option>${L.outcomes.map((o) => `<option value="${o.id}" ${d.outcome.outcome === o.id ? 'selected' : ''} ${flat && L.flatlineRule && !allowed[o.id] ? 'disabled' : ''}>${esc(o.label)}${flat && L.flatlineRule && !allowed[o.id] ? ' (not allowed after flatline)' : ''}</option>`).join('')}</select></label>
      <label class="f"><span>Receiving hospital</span><select data-bind="outcome.hospital"><option value="">None</option>${L.hospitals.map((h) => `<option value="${h.id}" ${d.outcome.hospital === h.id ? 'selected' : ''}>${esc(h.label)}</option>`).join('')}</select></label>
      ${field('outcome.notes', 'Outcome notes / safety-netting advice', 'textarea', 'spanall')}
    </div>
    <h2 style="margin-top:18px">ATMIST handover</h2>
    <div class="grid2">
      ${field('outcome.atmist.age', 'Age / sex')}${field('outcome.atmist.time', 'Time of incident')}
      ${field('outcome.atmist.mechanism', 'Mechanism', 'textarea')}${field('outcome.atmist.injuries', 'Injuries / illness', 'textarea')}
      ${field('outcome.atmist.signs', 'Signs (vitals)', 'textarea')}${field('outcome.atmist.treatment', 'Treatment given', 'textarea')}
    </div><div class="row end" style="margin-top:10px"><button class="btn small" id="fillAtmist">Fill from this ePRF</button></div>`;
  }
  return '';
}

function prfReadonly(tab) {
  const d = S.prf.data; const R = S.prf;
  const dl = (rows) => `<div class="readonly"><dl>${rows.map(([k, v]) => `<dt>${k}</dt><dd>${esc(v || '—')}</dd>`).join('')}</dl></div>`;
  if (tab === 'incident') return dl([['Time of call', d.incident.time_call], ['On scene', d.incident.time_scene], ['Left scene', d.incident.time_left], ['Location', R.location], ['Mechanism', d.incident.mechanism]]);
  if (tab === 'assessment') return dl([['Complaint', d.assessment.complaint], ['History', d.assessment.history], ['Airway', d.assessment.airway], ['Breathing', d.assessment.breathing], ['Circulation', d.assessment.circulation], ['Disability', d.assessment.disability], ['Exposure', d.assessment.exposure]]);
  if (tab === 'ecg') return dl([['Rhythm', d.ecg.rhythm], ['Flatline / arrest', prfFlatline() ? 'Yes' : 'No'], ['Shocks', String(d.ecg.shocks ?? 0)], ['ROSC', d.ecg.rosc_time], ['Notes', d.ecg.notes]]);
  if (tab === 'outcome') return dl([['Outcome', R.outcome_label], ['Hospital', R.hospital_label], ['Notes', d.outcome.notes], ['A — Age/sex', d.outcome.atmist.age], ['T — Time', d.outcome.atmist.time], ['M — Mechanism', d.outcome.atmist.mechanism], ['I — Injuries', d.outcome.atmist.injuries], ['S — Signs', d.outcome.atmist.signs], ['T — Treatment', d.outcome.atmist.treatment]]);
  // obs & treatment reuse the edit tables without forms
  const tmp = document.createElement('div'); tmp.innerHTML = prfTabEdit(tab);
  $$('[data-rm]', tmp).forEach((b) => b.closest('td').remove());
  if (tab === 'obs') { $$('#obsForm, #obsForm ~ *', tmp).forEach((x) => x.remove()); $$('h2', tmp).forEach((x) => x.remove()); }
  if (tab === 'treatment') { $$('.grid4, .row.end', tmp).forEach((x) => x.remove()); }
  return tmp.innerHTML;
}

function bindPRFInputs(el) {
  const mark = () => (S.prfDirty = true);
  $$('[data-bind]', el).forEach((inp) => {
    const ev = inp.type === 'checkbox' || inp.tagName === 'SELECT' ? 'change' : 'input';
    inp.addEventListener(ev, () => {
      setPath(S.prf.data, inp.dataset.bind, inp.type === 'checkbox' ? inp.checked : inp.value);
      mark();
      if (inp.dataset.bind === 'ecg.arrest' || inp.dataset.bind === 'ecg.rhythm') drawPRF(el);
      if (inp.dataset.bind === 'outcome.outcome' && inp.value === 'conveyed' && !S.prf.data.outcome.hospital) toast('Choose the receiving hospital.');
    });
  });
  $$('[data-ed]', el).forEach((b) => (b.onclick = () => { const [list, i] = b.dataset.ed.split(':'); editEntryModal(el, list, +i); }));
  $$('[data-rm]', el).forEach((b) => (b.onclick = () => {
    const [list, i] = b.dataset.rm.split(':'); S.prf.data[list].splice(+i, 1); mark(); drawPRF(el);
  }));

  // patient picker
  const pp = $('#pp', el);
  if (pp) {
    let t;
    pp.oninput = () => {
      mark(); S.prf._patientName = pp.value; S.prf._cid = '';
      clearTimeout(t);
      t = setTimeout(async () => {
        if (pp.value.trim().length < 2) { $('#ppRes').innerHTML = ''; return; }
        const r = await api('people.search', { term: pp.value.trim() }); if (!r) return;
        $('#ppRes').innerHTML = r.people.slice(0, 6).map(personRow).join('');
        $$('#ppRes [data-cid]').forEach((li) => (li.onclick = () => {
          S.prf._cid = li.dataset.cid; S.prf.patient_name = li.dataset.name; S.prf.citizenid = li.dataset.cid; pp.value = li.dataset.name; $('#ppRes').innerHTML = '';
          toast(`Linked to ${li.dataset.name}.`);
        }));
      }, 250);
    };
    $('#loc', el).oninput = (e) => { S.prf.location = e.target.value; mark(); };
  }

  // obs form
  const obsForm = $('#obsForm', el);
  if (obsForm) {
    const read = () => { const o = {}; $$('[data-o]', obsForm).forEach((x) => (o[x.dataset.o] = x.type === 'checkbox' ? x.checked : x.value.trim())); return o; };
    obsForm.oninput = obsForm.onchange = () => ($('#liveNews').innerHTML = newsBadge(news2(read())));
    $('#addObs', el).onclick = () => {
      const o = read();
      if (!['hr', 'sbp', 'rr', 'spo2', 'temp', 'gcs', 'bm', 'pain', 'avpu'].some((k) => o[k])) return toast('Enter at least one observation.', true);
      o.news2 = news2(o); S.prf.data.obs.push(o); mark(); drawPRF(el);
    };
    $('#pull', el).onclick = async () => {
      const n = await post('nearestPatient');
      if (!n || !n.target) return toast('No patient within 5 metres.', true);
      const r = await api('vitals.pull', { target: n.target }); if (!r) return;
      Object.entries(r.vitals).forEach(([k, v]) => { const x = $(`[data-o="${k}"]`, obsForm); if (x && v != null) x.type === 'checkbox' ? (x.checked = !!v) : (x.value = v); });
      $('[data-o="time"]', obsForm).value = nowHM();
      $('#liveNews').innerHTML = newsBadge(news2(read()));
      const d = S.prf.data, ex = r.extra || {}; const notes = [];
      if (r.patient && !S.prf.citizenid) { S.prf._cid = r.patient.cid; S.prf.patient_name = r.patient.name; S.prf.citizenid = r.patient.cid; $('#pp').value = r.patient.name; }
      if (ex.rhythm && (!d.ecg.rhythm || d.ecg.rhythm === 'Not recorded' || ex.arrest)) { d.ecg.rhythm = ex.rhythm; notes.push(`ECG ${ex.rhythm}`); }
      if (ex.arrest && !d.ecg.arrest) { d.ecg.arrest = true; notes.push('marked as flatlined'); }
      if (ex.findings && !(d.assessment.exposure || '').includes(ex.findings)) { d.assessment.exposure = [d.assessment.exposure, ex.findings].filter(Boolean).join('\n'); notes.push('injuries added to Exposure'); }
      if (ex.bloodType) notes.push(`blood type ${ex.bloodType}`);
      S.prfDirty = true;
      toast(`Vitals pulled${notes.length ? ': ' + notes.join(', ') : ''}. Check them, then add.`);
    };
  }

  // treatment
  const mName = $('#mName', el);
  if (mName) {
    const firstAllowed = S.boot.lists.meds.find((m) => m.allowed && m.scene); if (firstAllowed) mName.value = firstAllowed.name;
    const sync = () => { const m = S.boot.lists.meds.find((x) => x.name === mName.value); if (!m) return; $('#mDose').value = m.dose || ''; $('#mRoute').innerHTML = options(m.routes || []); };
    mName.onchange = sync; sync();
    $('#addMed', el).onclick = () => {
      const m = S.boot.lists.meds.find((x) => x.name === mName.value);
      if (!m || !m.allowed) return toast(m ? m.why : 'Choose a medication.', true);
      S.prf.data.meds.push({ name: m.name, dose: $('#mDose').value, route: $('#mRoute').value, time: $('#mTime').value }); mark(); drawPRF(el);
    };
    const iName = $('#iName', el);
    const firstInt = S.boot.lists.interventions.find((x) => x.allowed); if (firstInt) iName.value = firstInt.name;
    $('#addInt', el).onclick = () => {
      const x = S.boot.lists.interventions.find((y) => y.name === iName.value);
      if (!x || !x.allowed) return toast(x ? x.why : 'Choose an intervention.', true);
      S.prf.data.interventions.push({ name: x.name, notes: $('#iNotes').value, time: $('#iTime').value }); mark(); drawPRF(el);
    };
  }

  const fa = $('#fillAtmist', el);
  fa && (fa.onclick = () => {
    const d = S.prf.data; const o = d.obs[d.obs.length - 1]; const a = d.outcome.atmist;
    a.time = a.time || d.incident.time_call;
    a.mechanism = a.mechanism || d.incident.mechanism;
    a.injuries = a.injuries || [d.assessment.complaint, d.assessment.exposure].filter(Boolean).join('. ');
    if (o) a.signs = `HR ${o.hr || '-'}, BP ${o.sbp || '-'}/${o.dbp || '-'}, RR ${o.rr || '-'}, SpO₂ ${o.spo2 || '-'}%, GCS ${o.gcs || '-'}, NEWS2 ${o.news2 ?? news2(o) ?? '-'}`;
    a.treatment = [...d.meds.map((m) => `${m.name} ${m.dose} ${m.route}`), ...d.interventions.map((x) => x.name)].join(', ') || a.treatment;
    mark(); drawPRF(el);
  });
}

async function savePRF(el, finalise) {
  const R = S.prf;
  const editReason = S.prfEdit ? S.prfEdit.reason : undefined;
  const r = await api('report.save', { id: R.id, data: R.data, cid: R._cid || '', patientName: R._patientName, location: R.location, finalise, editReason });
  if (!r) return;
  S.prfDirty = false;
  toast(editReason ? (r.unchanged ? 'Nothing changed.' : `${R.ref} updated: ${r.changes.join(', ')}.`) : finalise ? `${R.ref} finalised.` : 'Draft saved.');
  renderPRF(el, { id: R.id });
}

const editedMark = (e) => (e.edited_by ? `<div class="sub muted">Edited by ${esc(e.edited_by)}${e.edited_at ? ', ' + esc(e.edited_at) : ''}</div>` : '');

function startEdit(el) {
  openModal(`<h3>Edit ${esc(S.prf.ref)}</h3><p>This ePRF is finalised. Your changes are logged with your name, and the current version is kept in the edit history.</p>
    <label class="f"><span>Reason for editing</span><input id="er" placeholder="e.g. Wrong drug dose recorded, corrected to 2.5 mg"></label>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Start editing</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = () => {
      const reason = $('#er').value.trim();
      if (reason.length < 4) return toast('Give a reason for editing.', true);
      closeModal(); S.prfEdit = { reason }; drawPRF(el);
    };
  });
}

function editEntryModal(el, list, i) {
  const e = S.prf.data[list][i]; if (!e) return;
  const L = S.boot.lists; let body = '';
  const inp = (k, label, extra = '') => `<label class="f ${extra}"><span>${label}</span><input data-k="${k}" value="${esc(e[k] ?? '')}"></label>`;
  if (list === 'obs') {
    body = `<div class="grid4">${inp('time', 'Time')}${inp('hr', 'Heart rate')}${inp('sbp', 'Systolic BP')}${inp('dbp', 'Diastolic BP')}${inp('rr', 'Resp. rate')}${inp('spo2', 'SpO₂ %')}${inp('temp', 'Temp °C')}
      <label class="f"><span>AVPU</span><select data-k="avpu">${options([['', '—'], ['A', 'Alert'], ['C', 'New confusion'], ['V', 'Voice'], ['P', 'Pain'], ['U', 'Unresponsive']].map(([v, l]) => ({ v, l })), e.avpu || '', 'v', 'l')}</select></label>
      ${inp('gcs', 'GCS')}${inp('bm', 'Blood glucose')}${inp('pain', 'Pain (0–10)')}
      <label class="check" style="align-self:end;padding-bottom:8px"><input type="checkbox" data-k="o2" ${e.o2 ? 'checked' : ''}> On oxygen</label></div>`;
  } else if (list === 'meds') {
    const meds = L.meds.filter((m) => m.scene || m.name === e.name);
    if (!meds.some((m) => m.name === e.name)) meds.unshift({ name: e.name, allowed: true });
    body = `<div class="grid2"><label class="f spanall"><span>Drug</span><select data-k="name">${meds.map((m) => `<option value="${esc(m.name)}" ${m.name === e.name ? 'selected' : ''} ${m.allowed || m.name === e.name ? '' : 'disabled'}>${esc(m.name)}${m.allowed || m.name === e.name ? '' : ' (outside your scope)'}</option>`).join('')}</select></label>
      ${inp('dose', 'Dose')}<label class="f"><span>Route</span><input data-k="route" value="${esc(e.route || '')}"></label>${inp('time', 'Time')}</div>`;
  } else {
    const ints = L.interventions.some((x) => x.name === e.name) ? L.interventions : [{ name: e.name, allowed: true }, ...L.interventions];
    body = `<div class="grid2"><label class="f spanall"><span>Intervention</span><select data-k="name">${ints.map((x) => `<option value="${esc(x.name)}" ${x.name === e.name ? 'selected' : ''} ${x.allowed || x.name === e.name ? '' : 'disabled'}>${esc(x.name)}${x.allowed || x.name === e.name ? '' : ' (outside your scope)'}</option>`).join('')}</select></label>
      ${inp('time', 'Time')}${inp('notes', 'Notes')}</div>`;
  }
  openModal(`<h3>Edit ${list === 'obs' ? 'observations' : list === 'meds' ? 'medication' : 'intervention'}</h3>
    <p>${e.by ? `Recorded by ${esc(e.by)}. They stay the author; your name is added as the editor.` : 'Not saved yet.'}</p>${body}
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Update</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = () => {
      $$('[data-k]', m).forEach((x) => (e[x.dataset.k] = x.type === 'checkbox' ? x.checked : x.value.trim()));
      if (list === 'obs') e.news2 = news2(e);
      S.prfDirty = true; closeModal(); drawPRF(el);
      toast('Updated. Save to keep the change.');
    };
  });
}

async function revisionModal(id) {
  const r = await api('report.revision', { id }); if (!r) return;
  const v = r.revision; const keep = S.prf;
  S.prf = { ...keep, data: v.data, location: v.location, outcome_label: v.outcome_label, hospital_label: v.hospital_label, status: 'final' };
  const html = TABS.map(([k, l]) => `<h3 style="margin-top:16px">${l}</h3>${prfReadonly(k)}`).join('');
  S.prf = keep;
  openModal(`<h3>${esc(v.ref)} before the edit</h3><p>Replaced on ${fmt(v.created_at)} by ${esc(v.edited_by)}. Reason: ${esc(v.reason)}. Changed: ${esc(v.changes)}.</p>
    <div class="muted">Patient: ${esc(v.patient_name || '—')}</div>${html}
    <div class="row end"><button class="btn primary" data-x>Close</button></div>`, (m) => { $('[data-x]', m).onclick = closeModal; });
  $('#modalCard').style.width = 'min(900px, 92vw)';
}

function amendModal(el) {
  openModal(`<h3>Add amendment</h3><p>Amendments are added below the finalised ePRF with your name and the time.</p>
    <label class="f"><span>Amendment</span><textarea id="am"></textarea></label>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Add amendment</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => { if (await api('report.amend', { id: S.prf.id, note: $('#am').value })) { closeModal(); toast('Amendment added.'); renderPRF(el, { id: S.prf.id }); } };
  });
}

/* ---------- admissions ---------- */
async function renderAdmissions(el, p) {
  const current = p.current !== false; const hospital = p.hospital || '';
  const r = await api('admissions.list', { current, hospital }); if (!r) return;
  el.innerHTML = `<section class="panel"><div class="panel-head">
      <div class="row"><button class="btn small ${current ? 'primary' : ''}" data-c="1">Admitted now</button><button class="btn small ${!current ? 'primary' : ''}" data-c="0">Discharged</button></div>
      <select id="hosp" style="width:auto"><option value="">All hospitals</option>${options(S.boot.lists.hospitals, hospital, 'id', 'label')}</select></div>
    ${r.admissions.length ? `<table class="t"><tr><th>Patient</th><th>Hospital</th><th>Reason</th><th>Admitted</th><th>${current ? '' : 'Discharged'}</th><th></th></tr>${r.admissions.map((a) => `<tr><td><strong>${esc(a.patient_name || '—')}</strong>${a.ref ? `<div class="muted">${esc(a.ref)}</div>` : ''}</td><td>${esc(a.hospital_label)}</td><td>${esc(a.reason || '')}</td><td>${fmt(a.admitted_at)}<div class="muted">${esc(a.admitted_by)}</div></td><td>${a.discharged_at ? `${fmt(a.discharged_at)}<div class="muted">${esc(a.discharged_by)}</div>` : ''}</td><td>${current ? `<button class="btn small" data-dis="${a.id}" data-name="${esc(a.patient_name)}">Discharge</button>` : ''}${a.report_id ? ` <button class="btn small" data-prf="${a.report_id}">ePRF</button>` : ''}</td></tr>`).join('')}</table>` : `<p class="empty">${current ? 'No patients are admitted right now.' : 'No discharges yet.'}</p>`}</section>`;
  $$('[data-c]', el).forEach((b) => (b.onclick = () => go('admissions', { current: b.dataset.c === '1', hospital })));
  $('#hosp', el).onchange = (e) => go('admissions', { current, hospital: e.target.value });
  $$('[data-prf]', el).forEach((b) => (b.onclick = () => go('prf', { id: b.dataset.prf })));
  $$('[data-dis]', el).forEach((b) => (b.onclick = () => openModal(`<h3>Discharge ${esc(b.dataset.name)}</h3><p>Record discharge notes and any follow-up advice.</p>
    <label class="f"><span>Discharge notes</span><textarea id="dn"></textarea></label>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Discharge patient</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => { if (await api('admissions.discharge', { id: b.dataset.dis, notes: $('#dn').value })) { closeModal(); toast('Patient discharged.'); renderAdmissions(el, p); } };
  })));
}

/* ---------- police requests ---------- */
async function renderInjury(el, p) {
  const done = p.status === 'done';
  const r = await api('injury.list', { status: done ? 'done' : 'pending' }); if (!r) return;
  if (!done) { S.counts.pendingRequests = r.requests.length; renderNav(); }
  el.innerHTML = `<section class="panel"><div class="panel-head"><div class="row">
      <button class="btn small ${!done ? 'primary' : ''}" data-s="pending">Waiting</button><button class="btn small ${done ? 'primary' : ''}" data-s="done">Answered</button></div>
      <span class="muted">Police see your statement only, never the full ePRF.</span></div>
    ${r.requests.length ? `<ul class="list">${r.requests.map((q) => `<li><div class="main"><strong>Case ${esc(q.case_ref)}: ${esc(q.patient_name || 'Unknown patient')}</strong>
      <div class="sub">Requested by ${esc(q.officer_name || 'police')} on ${fmt(q.created_at)}</div>${q.notes ? `<div>${esc(q.notes)}</div>` : ''}
      ${done ? `<div style="margin-top:6px"><span class="tag ${q.status === 'fulfilled' ? 'green' : 'red'}">${q.status === 'fulfilled' ? 'Provided' : 'Declined'}</span> ${esc(q.responded_by)}: ${esc(q.statement)}</div>` : ''}</div>
      ${!done ? `<button class="btn primary small" data-ans="${q.id}">Respond</button>` : ''}</li>`).join('')}</ul>` : `<p class="empty">${done ? 'No answered requests.' : 'No police requests waiting.'}</p>`}</section>`;
  $$('[data-s]', el).forEach((b) => (b.onclick = () => go('injury', { status: b.dataset.s })));
  $$('[data-ans]', el).forEach((b) => (b.onclick = async () => {
    const q = r.requests.find((x) => String(x.id) === b.dataset.ans);
    const rep = q.citizenid ? await api('injury.reportsFor', { cid: q.citizenid }) : { reports: [] };
    openModal(`<h3>Injury statement for case ${esc(q.case_ref)}</h3><p>Describe the injuries found and treatment given. Only this statement is shared with police.</p>
      <label class="f"><span>Linked ePRF (optional)</span><select id="rr"><option value="">None</option>${(rep ? rep.reports : []).map((x) => `<option value="${x.id}">${esc(x.ref)}, ${fmt(x.created_at)}, ${esc(x.outcome_label || '')}</option>`).join('')}</select></label>
      <label class="f" style="margin-top:10px"><span>Statement</span><textarea id="st" style="min-height:140px"></textarea></label>
      <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn danger" data-no>Decline</button><button class="btn primary" data-ok>Send statement</button></div>`, (m) => {
      $('[data-x]', m).onclick = closeModal;
      $('[data-ok]', m).onclick = async () => { if (await api('injury.respond', { id: q.id, reportId: $('#rr').value, statement: $('#st').value })) { closeModal(); toast('Statement sent to police.'); renderInjury(el, p); } };
      $('[data-no]', m).onclick = async () => { if (await api('injury.respond', { id: q.id, decline: true, statement: $('#st').value })) { closeModal(); toast('Request declined.'); renderInjury(el, p); } };
    });
  }));
}

/* ---------- ERK ---------- */
async function renderERK(el) {
  const r = await api('erk.list'); if (!r) return;
  el.innerHTML = `<div class="alert yellow">The Emergency Revive Kit is out of character. Use it only for bugs, glitches or players killed by modders, and log every use here.</div>
    <section class="panel"><div class="panel-head"><h2>Uses</h2><button class="btn primary small" id="add">Log a use</button></div>
    ${r.entries.length ? `<table class="t"><tr><th>When</th><th>Used by</th><th>Player</th><th>Reason</th><th>Notes</th></tr>${r.entries.map((e) => `<tr><td>${fmt(e.created_at)}</td><td>${esc(e.used_by_name)}</td><td>${esc(e.target_name || '—')}</td><td>${esc(e.reason)}</td><td>${esc(e.notes)}</td></tr>`).join('')}</table>` : '<p class="empty">No uses logged.</p>'}</section>`;
  $('#add', el).onclick = () => openModal(`<h3>Log a revive kit use</h3><p>This goes to the OOC log and staff webhook, not the patient's record.</p>
    <div class="grid2"><label class="f"><span>Player name</span><input id="en"></label><label class="f"><span>Citizen ID (optional)</span><input id="ec"></label>
    <label class="f spanall"><span>Reason</span><select id="er">${options(S.boot.lists.erkReasons)}</select></label>
    <label class="f spanall"><span>Notes</span><textarea id="eno" placeholder="What happened"></textarea></label></div>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Log use</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => { if (await api('erk.add', { name: $('#en').value, cid: $('#ec').value, reason: $('#er').value, notes: $('#eno').value })) { closeModal(); toast('Use logged.'); renderERK(el); } };
  });
}

/* ---------- audit ---------- */
async function renderAudit(el) {
  el.innerHTML = `<section class="panel"><input id="q" placeholder="Search by clinician, patient or action"><div id="res" style="margin-top:10px"></div></section>`;
  const load = async (term) => {
    const r = await api('audit.list', { term }); if (!r) return;
    $('#res').innerHTML = r.entries.length ? `<table class="t"><tr><th>When</th><th>Clinician</th><th>Action</th><th>Record</th><th>Reason</th></tr>${r.entries.map((e) => `<tr><td>${fmt(e.created_at)}</td><td>${esc(e.actor_name)}</td><td>${esc(e.action)}</td><td>${esc(e.target)}</td><td>${esc(e.reason)}</td></tr>`).join('')}</table>` : '<p class="empty">No entries match.</p>';
  };
  let t; $('#q', el).oninput = (e) => { clearTimeout(t); t = setTimeout(() => load(e.target.value), 250); };
  load('');
}

/* ---------- training and qualifications ---------- */
const dOnly = (v) => { const f = fmt(v); return f ? f.split(' ')[0] : ''; };
function isoDate(v) {
  if (!v) return '';
  const d = typeof v === 'number' ? new Date(v) : new Date(String(v).replace(' ', 'T'));
  if (isNaN(d)) return '';
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
}
const today = () => isoDate(Date.now());
const ST_PILL = { valid: ['green', 'Valid'], expiring: ['yellow', 'Expiring'], expired: ['red', 'Expired'], revoked: ['red', 'Revoked'], failed: ['red', 'Not passed'], none: ['', 'Not held'] };
const stPill = (st) => { const [c, l] = ST_PILL[st] || ST_PILL.none; return `<span class="tag ${c}">${l}</span>`; };
const PROB = { none: 'Not on probation', active: 'On probation', extended: 'Probation extended', passed: 'Probation passed', failed: 'Probation not passed' };
function probText(s) {
  if (!s.probation_status || s.probation_status === 'none') return '<span class="muted">—</span>';
  const live = s.probation_status === 'active' || s.probation_status === 'extended';
  const d = Number(s.probation_days);
  return `<span class="tag ${live ? (d < 0 ? 'red' : 'yellow') : s.probation_status === 'passed' ? 'green' : 'red'}">${PROB[s.probation_status]}</span>${live && s.probation_end ? `<div class="sub">${d < 0 ? 'Review overdue' : `Ends ${dOnly(s.probation_end)}`}</div>` : ''}`;
}

async function renderTraining(el, p) {
  const inactive = !!p.inactive;
  const r = await api('training.roster', { term: p.term || '', inactive }); if (!r) return;
  const total = r.competencies.length;
  const name = (code) => (r.competencies.find((c) => c.id === code) || {}).label || code;
  el.innerHTML = `
    <section class="panel"><div class="panel-head">
      <div class="row"><button class="btn small ${!inactive ? 'primary' : ''}" data-act="0">Current staff</button><button class="btn small ${inactive ? 'primary' : ''}" data-act="1">Left the service</button>
        <input id="tq" placeholder="Search staff" value="${esc(p.term || '')}" style="width:220px"></div>
      <div class="row">${r.canManage && r.enforceScope ? '<button class="btn small" id="seed">Sign off existing rank holders</button>' : ''}${r.canTrain ? '<button class="btn primary small" id="addStaff">Add staff member</button>' : ''}</div></div>
      ${r.staff.length ? `<table class="t"><tr><th>Staff member</th><th>Probation</th><th>Competencies</th><th>Needs attention</th><th>Last on duty</th></tr>
        ${r.staff.map((x) => {
          const due = Object.entries(x.comps).filter(([, st]) => st === 'expired' || st === 'expiring');
          return `<tr class="click" data-staff="${esc(x.citizenid)}"><td><strong>${esc(x.name)}</strong><div class="sub">${esc(x.rank_label || '')}</div></td>
            <td>${probText(x)}</td><td>${x.counts.valid} of ${total}</td>
            <td>${due.length ? due.map(([c, st]) => `<span class="tag ${st === 'expired' ? 'red' : 'yellow'}">${esc(name(c))}</span>`).join('') : '<span class="muted">—</span>'}</td>
            <td>${x.last_seen ? dOnly(x.last_seen) : '<span class="muted">Not yet</span>'}</td></tr>`;
        }).join('')}</table>` : `<p class="empty">${inactive ? 'No former staff.' : 'No staff records yet. Clinicians are added when they first open the MDT.'}</p>`}
    </section>
    ${r.enforceScope ? `<p class="muted" style="font-size:13px">Scope that needs a valid competency: ${Object.entries(r.scopeRequires || {}).map(([k, v]) => `${esc({ transfuse: 'blood transfusion', prescribe: 'prescribing', hems: 'HEMS taskings' }[k] || k)} (${esc(name(v))})`).join(', ')}.</p>` : ''}`;
  $$('[data-act]', el).forEach((b) => (b.onclick = () => go('training', { inactive: b.dataset.act === '1', term: $('#tq').value })));
  let t; $('#tq', el).oninput = (e) => { clearTimeout(t); t = setTimeout(() => go('training', { inactive, term: e.target.value }).then(() => { const q = $('#tq'); q.focus(); q.setSelectionRange(q.value.length, q.value.length); }), 300); };
  $$('[data-staff]', el).forEach((tr) => (tr.onclick = () => go('staff', { cid: tr.dataset.staff })));
  const seed = $('#seed', el);
  seed && (seed.onclick = async () => {
    if (!(await confirmBox('Sign off existing rank holders?', 'Everyone whose rank already gives transfusion, prescribing or HEMS is signed off for the matching competency, dated today. Use this once when you first turn on training records.', 'Sign them off'))) return;
    const res = await api('training.seed'); if (res) { toast(`${res.count} sign-off${res.count === 1 ? '' : 's'} added.`); renderTraining(el, p); }
  });
  const add = $('#addStaff', el);
  add && (add.onclick = () => openModal(`<h3>Add staff member</h3><p>For new starters who haven't opened the MDT yet. Everyone else is added automatically.</p>
    <input id="asq" placeholder="Name or citizen ID" autocomplete="off"><ul class="list" id="asr" style="margin-top:8px"></ul>
    <div class="row end"><button class="btn" data-x>Cancel</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    let tt; $('#asq', m).oninput = (e) => { clearTimeout(tt); tt = setTimeout(async () => {
      if (e.target.value.trim().length < 2) return;
      const pr = await api('people.search', { term: e.target.value.trim() }); if (!pr) return;
      $('#asr').innerHTML = pr.people.slice(0, 6).map(personRow).join('') || '<li class="muted">No one found.</li>';
      $$('#asr [data-cid]').forEach((li) => (li.onclick = async () => { const a = await api('training.add', { cid: li.dataset.cid }); if (a) { closeModal(); go('staff', { cid: a.cid }); } }));
    }, 250); };
  }));
}

async function renderStaff(el, p) {
  const r = await api('training.staff', { cid: p.cid }); if (!r) return;
  const s = r.staff; const sc = r.scope;
  $('#pageTitle').textContent = s.name;
  const yes = (v) => (v ? 'Yes' : 'No');
  el.innerHTML = `
    ${sc.notes.length ? `<div class="alert red"><strong>Scope reduced.</strong> ${sc.notes.map(esc).join(' ')}</div>` : ''}
    <div class="cols"><div>
      <section class="panel"><div class="panel-head"><h2>Competencies</h2></div>
        <table class="t"><tr><th>Competency</th><th>Status</th><th>Signed off</th><th>Expires</th><th></th></tr>
        ${r.competencies.map((c) => { const q = c.record; return `<tr><td><strong>${esc(c.label)}</strong>${c.expiryMonths ? `<div class="sub">Renew every ${c.expiryMonths} months</div>` : '<div class="sub">Does not expire</div>'}</td>
          <td>${stPill(c.status)}${c.status === 'revoked' && q ? `<div class="sub">${esc(q.revoke_reason || '')}</div>` : ''}</td>
          <td>${q ? `${dOnly(q.issued_at)}<div class="sub">${esc(q.issued_by || '')}</div>` : ''}</td>
          <td>${q && q.expires_at ? dOnly(q.expires_at) : q ? '—' : ''}</td>
          <td class="nowrap">${r.canTrain && !(r.isMe && !r.canManage) ? `<button class="btn small" data-sign="${c.id}" data-label="${esc(c.label)}">${c.status === 'none' ? 'Sign off' : 'Renew'}</button>` : ''}
            ${r.canManage && q && !q.revoked_at && c.status !== 'expired' ? ` <button class="btn small danger" data-revoke="${q.id}" data-label="${esc(c.label)}">Revoke</button>` : ''}</td></tr>`; }).join('')}
        </table></section>
      <section class="panel"><div class="panel-head"><h2>Courses</h2>${r.canTrain ? '<button class="btn small primary" id="addCourse">Record course</button>' : ''}</div>
        ${r.courses.length ? `<table class="t"><tr><th>Course</th><th>Result</th><th>Date</th><th>Refresher due</th><th>Trainer</th></tr>${r.courses.map((c) => `<tr><td><strong>${esc(c.title)}</strong>${c.notes ? `<div class="sub">${esc(c.notes)}</div>` : ''}</td><td>${c.result === 'fail' ? stPill('failed') : stPill(c.status)}${c.score ? `<div class="sub">${esc(c.score)}</div>` : ''}</td><td>${dOnly(c.issued_at)}</td><td>${c.expires_at ? dOnly(c.expires_at) : '—'}</td><td>${esc(c.issued_by)}</td></tr>`).join('')}</table>` : '<p class="empty">No courses recorded.</p>'}
      </section>
      <section class="panel"><div class="panel-head"><h2>Certificates</h2>${r.canTrain ? '<button class="btn small" id="addCert">Issue certificate</button>' : ''}</div>
        ${r.certificates.length ? `<table class="t"><tr><th>Certificate</th><th>Reference</th><th>Issued</th><th>Expires</th><th></th></tr>${r.certificates.map((c) => `<tr><td><strong>${esc(c.title)}</strong><div class="sub">${esc(c.issued_by)}</div></td><td>${esc(c.ref || '')}</td><td>${dOnly(c.issued_at)}</td><td>${c.expires_at ? dOnly(c.expires_at) : '—'} ${c.revoked_at || c.expires_at ? stPill(c.status) : ''}</td><td>${r.canManage && !c.revoked_at ? `<button class="btn small danger" data-revoke="${c.id}" data-label="${esc(c.title)}">Revoke</button>` : ''}</td></tr>`).join('')}</table>` : '<p class="empty">No certificates issued.</p>'}
      </section>
    </div><div>
      <section class="panel"><div class="panel-head"><h2>Staff details</h2>${r.canManage ? '<button class="btn small" id="editStaff">Edit</button>' : ''}</div>
        <div class="readonly"><dl>
          <dt>Rank</dt><dd>${esc(s.rank_label || '')}</dd>
          <dt>Joined</dt><dd>${s.joined_at ? dOnly(s.joined_at) : '—'}</dd>
          <dt>Last on duty</dt><dd>${s.last_seen ? fmt(s.last_seen) : 'Not yet'}</dd>
          <dt>Status</dt><dd>${s.active ? 'Current' : 'Left the service'}</dd>
          ${s.notes ? `<dt>Notes</dt><dd>${esc(s.notes)}</dd>` : ''}
        </dl></div></section>
      <section class="panel"><h2>Clinical scope</h2><div class="readonly"><dl>
        <dt>Formulary</dt><dd>${sc.formulary === 'full' ? 'Full' : 'Limited (Epinephrine, Morphine, Narcan, Paracetamol)'}</dd>
        <dt>Prescribing</dt><dd>${yes(sc.prescribe)}</dd><dt>Blood transfusion</dt><dd>${yes(sc.transfuse)}</dd><dt>HEMS taskings</dt><dd>${yes(sc.hems)}</dd>
      </dl></div></section>
      <section class="panel"><div class="panel-head"><h2>Probation</h2>${r.canManage ? '<button class="btn small" id="editProb">Manage</button>' : ''}</div>
        ${probText(s)}
        ${s.probation_start ? `<div class="sub" style="margin-top:6px">Started ${dOnly(s.probation_start)}${s.probation_end ? `, ${['passed', 'failed'].includes(s.probation_status) ? 'ended' : 'ends'} ${dOnly(s.probation_end)}` : ''}</div>` : ''}
        ${s.probation_notes ? `<div style="margin-top:6px;white-space:pre-wrap">${esc(s.probation_notes)}</div>` : ''}</section>
      <section class="panel"><h2>History</h2>${r.history.length ? `<ul class="list">${r.history.map((h) => `<li><div class="main"><strong>${esc(h.event)}</strong>${h.detail ? `<div>${esc(h.detail)}</div>` : ''}<div class="sub">${fmt(h.created_at)}${h.actor ? `, ${esc(h.actor)}` : ''}</div></div></li>`).join('')}</ul>` : '<p class="empty">Nothing yet.</p>'}</section>
    </div></div>`;
  const reload = () => renderStaff(el, p);

  $$('[data-sign]', el).forEach((b) => (b.onclick = () => openModal(`<h3>Sign off: ${esc(b.dataset.label)}</h3><p>${esc(s.name)} is signed off from this date. The expiry is set from it automatically.</p>
    <div class="grid2"><label class="f"><span>Date</span><input id="sd" type="date" value="${today()}"></label>
    <label class="f spanall"><span>Notes</span><input id="sn" placeholder="e.g. Observed on three supervised jobs"></label></div>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Sign off</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => { if (await api('training.signoff', { cid: s.citizenid, code: b.dataset.sign, date: $('#sd').value, notes: $('#sn').value })) { closeModal(); toast('Signed off.'); reload(); } };
  })));

  $$('[data-revoke]', el).forEach((b) => (b.onclick = () => openModal(`<h3>Revoke: ${esc(b.dataset.label)}</h3><p>${esc(s.name)} loses this straight away${r.competencies.some((c) => c.label === b.dataset.label) ? ', including any clinical scope that depends on it' : ''}. The record is kept.</p>
    <label class="f"><span>Reason</span><input id="rr" placeholder="e.g. Failed reassessment"></label>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn danger" data-ok>Revoke</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => { if (await api('training.revoke', { id: b.dataset.revoke, reason: $('#rr').value })) { closeModal(); toast('Revoked.'); reload(); } };
  })));

  const ac = $('#addCourse', el);
  ac && (ac.onclick = () => openModal(`<h3>Record course</h3><p>A pass signs off the competencies the course covers.</p>
    <div class="grid2"><label class="f spanall"><span>Course</span><select id="cc">${r.courseList.map((c) => `<option value="${esc(c.id)}">${esc(c.label)}</option>`).join('')}</select></label>
    <label class="f"><span>Date</span><input id="cd" type="date" value="${today()}"></label>
    <label class="f"><span>Result</span><select id="cr"><option value="pass">Passed</option><option value="fail">Not passed</option></select></label>
    <label class="f"><span>Score (optional)</span><input id="cs" placeholder="e.g. 86%"></label>
    <label class="f spanall"><span>Notes</span><input id="cn"></label></div>
    <p class="sub" id="cg" style="margin-top:10px"></p>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Record course</button></div>`, (m) => {
    const showGrants = () => { const c = r.courseList.find((x) => x.id === $('#cc').value) || {}; const g = (c.grants || []).map((id) => (r.competencies.find((x) => x.id === id) || {}).label || id);
      $('#cg').textContent = $('#cr').value === 'pass' && g.length ? `Signs off: ${g.join(', ')}.` : ''; };
    $('#cc', m).onchange = showGrants; $('#cr', m).onchange = showGrants; showGrants();
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => {
      const res = await api('training.course', { cid: s.citizenid, code: $('#cc').value, date: $('#cd').value, result: $('#cr').value, score: $('#cs').value, notes: $('#cn').value });
      if (res) { closeModal(); toast(res.granted.length ? `Recorded. Signed off: ${res.granted.join(', ')}.` : 'Course recorded.'); reload(); }
    };
  }));

  const cert = $('#addCert', el);
  cert && (cert.onclick = () => openModal(`<h3>Issue certificate</h3><p>A reference number is created automatically.</p>
    <div class="grid2"><label class="f spanall"><span>Title</span><input id="ct" placeholder="e.g. Certificate of competence: Paramedic"></label>
    <label class="f"><span>Issued</span><input id="ci" type="date" value="${today()}"></label>
    <label class="f"><span>Expires (optional)</span><input id="ce" type="date"></label>
    <label class="f spanall"><span>Notes</span><input id="cno"></label></div>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Issue</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => { const res = await api('training.certificate', { cid: s.citizenid, title: $('#ct').value, date: $('#ci').value, expires: $('#ce').value, notes: $('#cno').value }); if (res) { closeModal(); toast(`Certificate ${res.ref} issued.`); reload(); } };
  }));

  const ep = $('#editProb', el);
  ep && (ep.onclick = () => {
    const weeks = 6; const start = isoDate(s.probation_start) || today();
    const end = isoDate(s.probation_end) || isoDate(Date.now() + weeks * 7 * 864e5);
    openModal(`<h3>Probation: ${esc(s.name)}</h3>
      <div class="grid2"><label class="f spanall"><span>Status</span><select id="ps">${Object.entries(PROB).map(([k, l]) => `<option value="${k}" ${k === (s.probation_status || 'none') ? 'selected' : ''}>${l}</option>`).join('')}</select></label>
      <label class="f"><span>Start</span><input id="pst" type="date" value="${start}"></label><label class="f"><span>End / review date</span><input id="pe" type="date" value="${end}"></label>
      <label class="f spanall"><span>Notes</span><textarea id="pn">${esc(s.probation_notes || '')}</textarea></label></div>
      <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Save</button></div>`, (m) => {
      $('[data-x]', m).onclick = closeModal;
      $('[data-ok]', m).onclick = async () => { if (await api('training.probation', { cid: s.citizenid, status: $('#ps').value, start: $('#pst').value, end: $('#pe').value, notes: $('#pn').value })) { closeModal(); toast('Probation updated.'); reload(); } };
    });
  });

  const es = $('#editStaff', el);
  es && (es.onclick = () => openModal(`<h3>Staff details: ${esc(s.name)}</h3><p>Rank comes from the job grade and updates when they next open the MDT.</p>
    <div class="grid2"><label class="f"><span>Joined</span><input id="ej" type="date" value="${isoDate(s.joined_at)}"></label>
    <label class="check" style="align-self:end;padding-bottom:8px"><input type="checkbox" id="ea" ${s.active ? '' : 'checked'}> Left the service</label>
    <label class="f spanall"><span>Notes</span><textarea id="en">${esc(s.notes || '')}</textarea></label></div>
    <div class="row end"><button class="btn" data-x>Cancel</button><button class="btn primary" data-ok>Save</button></div>`, (m) => {
    $('[data-x]', m).onclick = closeModal;
    $('[data-ok]', m).onclick = async () => { if (await api('training.update', { cid: s.citizenid, joined: $('#ej').value, notes: $('#en').value, active: !$('#ea').checked })) { closeModal(); toast('Saved.'); reload(); } };
  }));
}
