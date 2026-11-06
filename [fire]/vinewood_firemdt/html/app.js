/* vinewood_firemdt — NUI */
const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'vinewood_firemdt';

const S = {
    cfg: null, perms: {}, me: { callsign: null, status: null, incident: null, x: 0, y: 0, z: 0, heading: 0 },
    units: [], incidents: {}, logs: {}, hydrants: {}, risks: {}, sops: {},
    messages: [], unread: 0, view: 'incident', open: false, pendingAck: null,
    selRisk: null, selHaz: null, selSop: null, rescue: null, scan: null,
    map: { auto: true, zoom: 1, measuring: false, measure: [], follow: 'me' },
};

/* ── Helpers ─────────────────────────────── */
const $ = (s, r = document) => r.querySelector(s);
const esc = v => String(v ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const dist = (a, b) => Math.hypot((a.x || 0) - (b.x || 0), (a.y || 0) - (b.y || 0));
const lengths = m => Math.ceil(m / (S.cfg?.hoseLength || 25));
const fmtDist = m => m >= 1000 ? (m / 1000).toFixed(2) + ' km' : Math.round(m) + ' m';
const fmtTime = ts => ts ? new Date(ts * 1000).toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' }) : '';
const fmtDate = ts => ts ? new Date(ts * 1000).toLocaleString('en-GB', { day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' }) : '';

async function post(name, data = {}) {
    try {
        const r = await fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) });
        return await r.json();
    } catch (e) { return null; }
}
async function srv(name, ...args) {
    const r = await post('server', { name: 'vfmdt:' + name, args });
    return r || [false, 'No response'];
}

function toast(title, text = '', kind = 'info') {
    const el = document.createElement('div');
    el.className = `toast ${kind}`;
    el.innerHTML = `<b>${esc(title)}</b>${esc(text)}`;
    $('#toasts').appendChild(el);
    setTimeout(() => el.remove(), 6000);
}

let audioCtx;
function tone(pattern = [[880, .18], [660, .18], [880, .18], [660, .18]]) {
    if (!S.cfg?.tone) return;
    try {
        audioCtx = audioCtx || new AudioContext();
        let t = audioCtx.currentTime;
        for (const [f, d] of pattern) {
            const o = audioCtx.createOscillator(), g = audioCtx.createGain();
            o.type = 'square'; o.frequency.value = f;
            g.gain.value = S.cfg.volume ?? .3;
            o.connect(g); g.connect(audioCtx.destination);
            o.start(t); o.stop(t + d); t += d + .04;
        }
    } catch (e) { }
}

function statusDef(code) { return (S.cfg?.statuses || []).find(s => s.code === code); }
function myIncident() { return S.me.incident ? S.incidents[S.me.incident] : null; }
function openIncidents() { return Object.values(S.incidents).filter(i => i.status === 'open').sort((a, b) => b.id - a.id); }
function refPoint() { const inc = myIncident(); return inc ? { x: inc.x, y: inc.y } : S.me; }

/* ── Modal ───────────────────────────────── */
function modal(html, onMount) {
    $('#modalCard').innerHTML = html;
    $('#modal').classList.remove('hidden');
    onMount && onMount($('#modalCard'));
}
function closeModal() { $('#modal').classList.add('hidden'); $('#modalCard').innerHTML = ''; }
$('#modal').addEventListener('click', e => { if (e.target.id === 'modal') closeModal(); });

function confirmBox(text, label = 'Confirm', kind = 'stop') {
    return new Promise(res => {
        modal(`<h2>${esc(text)}</h2><div class="row" style="justify-content:flex-end;margin-top:14px">
            <button class="btn" data-a="no">Cancel</button><button class="btn ${kind}" data-a="yes">${esc(label)}</button></div>`, m => {
            m.querySelector('[data-a=no]').onclick = () => { closeModal(); res(false); };
            m.querySelector('[data-a=yes]').onclick = () => { closeModal(); res(true); };
        });
    });
}

/* ── Frame ───────────────────────────────── */
function fit() {
    const t = $('#terminal');
    const s = Math.min(window.innerWidth / 1340, window.innerHeight / 840, 1.25);
    t.style.transform = `scale(${s})`;
}
window.addEventListener('resize', fit);

const tick = () => { $('#clock').textContent = new Date().toLocaleTimeString('en-GB'); };
tick(); setInterval(tick, 1000);

function renderHeader() {
    $('#callsignBtn').textContent = S.me.callsign || 'Sign on';
    const inc = myIncident();
    const chip = $('#incChip');
    if (inc) { chip.textContent = `${inc.ref || '#' + inc.id}  ${inc.type}`; chip.classList.remove('hidden'); }
    else chip.classList.add('hidden');
    $('#controlTab').classList.toggle('hidden', !S.perms.control);
    const b = $('#msgBadge'); b.textContent = S.unread; b.classList.toggle('hidden', S.unread === 0);
}

function renderStatus() {
    const strip = $('#statusStrip');
    strip.innerHTML = (S.cfg?.statuses || []).map(s => `
        <button class="skey ${S.me.status === s.code ? 'on' : ''} ${s.emergency ? 'priority' : ''}" style="--lamp:${s.colour}" data-code="${s.code}" ${S.me.callsign ? '' : 'disabled'}>
            <span class="lamp"></span><span class="num">${s.code}</span><span class="lbl">${esc(s.label)}</span>
        </button>`).join('');
    strip.querySelectorAll('.skey').forEach(b => b.onclick = async () => {
        const code = +b.dataset.code;
        if (!S.me.callsign) return signOnModal();
        if (statusDef(code)?.emergency && !(await confirmBox('Send priority status 0? All units will be alerted.', 'Send priority'))) return;
        const [ok] = await srv('setStatus', code);
        if (ok) { S.me.status = code; renderStatus(); }
    });
}

function signOnModal() {
    modal(`<h2>Sign on to the MDT</h2>
        <div class="field"><label>Appliance callsign</label><input id="csIn" maxlength="24" placeholder="e.g. 01P1" value="${esc(S.me.callsign || '')}"></div>
        <p class="muted small">Crews on the same appliance can sign on with the same callsign.</p>
        <div class="row" style="justify-content:space-between;margin-top:14px">
            ${S.me.callsign ? '<button class="btn stop" id="soBtn">Sign off</button>' : '<span></span>'}
            <div class="row"><button class="btn" id="cnBtn">Cancel</button><button class="btn go" id="siBtn">Sign on</button></div>
        </div>`, m => {
        const inp = m.querySelector('#csIn'); inp.focus();
        m.querySelector('#cnBtn').onclick = closeModal;
        const go = async () => {
            const [ok, err] = await srv('signOn', inp.value.trim());
            if (!ok) return toast('Sign on failed', err || '', 'error');
            S.me.callsign = inp.value.trim().toUpperCase();
            if (S.me.status == null) S.me.status = S.cfg.statuses.find(s => s.code === 2) ? 2 : S.cfg.statuses[0].code;
            closeModal(); renderHeader(); renderStatus(); render();
        };
        m.querySelector('#siBtn').onclick = go;
        inp.onkeydown = e => { if (e.key === 'Enter') go(); };
        const so = m.querySelector('#soBtn');
        if (so) so.onclick = async () => {
            await srv('signOff');
            S.me.callsign = null; S.me.status = null; S.me.incident = null;
            closeModal(); renderHeader(); renderStatus(); render();
        };
    });
}
$('#callsignBtn').onclick = signOnModal;
$('#closeBtn').onclick = () => post('close');

$('#rail').addEventListener('click', e => {
    const b = e.target.closest('button[data-view]'); if (!b) return;
    go(b.dataset.view);
});
function go(view) {
    S.view = view;
    document.querySelectorAll('#rail button').forEach(b => b.classList.toggle('active', b.dataset.view === view));
    if (view === 'messages') { S.unread = 0; renderHeader(); }
    render();
}

/* ── Views ───────────────────────────────── */
const Views = {};
function render() {
    const v = $('#view');
    stopMap();
    v.style.padding = '';
    v.innerHTML = '';
    (Views[S.view] || Views.incident)(v);
}

/* Incident / mobilising */
Views.incident = v => {
    const inc = myIncident();
    if (!S.me.callsign) {
        v.innerHTML = `<div class="empty"><h2>Not signed on</h2><p>Sign on with your appliance callsign to receive mobilisations.</p><br><button class="btn go big" id="soNow">Sign on</button></div>`;
        $('#soNow').onclick = signOnModal; return;
    }
    if (!inc) return renderIncidentList(v);

    const d = dist(S.me, inc);
    const risks = (inc.risks || []).map(id => S.risks[id]).filter(Boolean);
    v.innerHTML = `<div class="split">
      <div>
        <div class="panel" id="incHeader"></div>
        <div class="panel">
          <h3 style="margin-top:0">Assistance message</h3>
          <div class="quick">${S.cfg.assistance.map(a => `<button class="btn" data-assist="${esc(a)}">${esc(a)}</button>`).join('')}</div>
          <h3>Informative message</h3>
          <textarea id="infoMsg" placeholder="e.g. Two-storey house 10 x 15 m, 50% of ground floor alight, two BA in use, one hose reel jet."></textarea>
          <div class="row" style="margin-top:8px;justify-content:space-between">
            <button class="btn" id="sendMsg">Send as message</button>
            <div class="row"><button class="btn" style="background:var(--blue);border-color:var(--blue)" id="sendInfo">Send informative</button>
            <button class="btn go" id="sendStop">Send stop message</button></div>
          </div>
        </div>
      </div>
      <div>
        <div class="panel">
          <div class="row" style="justify-content:space-between"><h3 style="margin:0">Incident log</h3><span class="muted small">${esc(inc.ref || '')}</span></div>
          <div class="log" id="incLog" style="margin-top:10px"><div class="muted">Loading…</div></div>
        </div>
        <div class="panel"><h3 style="margin-top:0">Nearest water</h3><div id="incWater"></div></div>
      </div>
    </div>`;
    refreshIncidentHeader();
    refreshWater();
    v.querySelectorAll('[data-assist]').forEach(b => b.onclick = () => sendMessage('assistance', b.dataset.assist));
    $('#sendInfo').onclick = () => { const t = $('#infoMsg').value.trim(); if (t) sendMessage('informative', t).then(() => $('#infoMsg').value = ''); };
    $('#sendMsg').onclick = () => { const t = $('#infoMsg').value.trim(); if (t) sendMessage('message', t).then(() => $('#infoMsg').value = ''); };
    $('#sendStop').onclick = async () => {
        const t = $('#infoMsg').value.trim() || 'Stop message. No further assistance required.';
        if (await confirmBox('Send stop message?', 'Send stop', 'go')) sendMessage('stop', t).then(() => $('#infoMsg').value = '');
    };
    loadLog(inc.id);
};

function refreshIncidentHeader() {
    const el = $('#incHeader'); const inc = myIncident(); if (!el || !inc) return;
    const d = dist(S.me, inc);
    const risks = (inc.risks || []).map(id => S.risks[id]).filter(Boolean);
    const ack = S.pendingAck === inc.id;
    el.innerHTML = `
      <div class="inc-head">
        <div><div class="inc-type">${esc(inc.type)}</div><div class="inc-loc">${esc(inc.location)}</div></div>
        <div class="inc-ref">${esc(inc.ref || '')}<br><span class="pill ${inc.priority?.includes('1') ? 'red' : 'amber'}">${esc(inc.priority)}</span></div>
      </div>
      ${risks.length ? `<div class="risk-banner"><div>Risk information on file: ${risks.map(r => `<button data-risk="${r.id}">${esc(r.name)} (level ${r.level})</button>`).join(', ')}</div></div>` : ''}
      <dl class="kv">
        <dt>Received</dt><dd>${fmtDate(inc.created_at)}</dd>
        ${inc.caller ? `<dt>Caller</dt><dd>${esc(inc.caller)}</dd>` : ''}
        <dt>Details</dt><dd>${esc(inc.details || 'None')}</dd>
        <dt>Attending</dt><dd>${esc((inc.units || []).join(', ') || 'None')}</dd>
        <dt>Distance</dt><dd><b>${fmtDist(d)}</b></dd>
      </dl>
      <div class="row" style="margin-top:14px">
        ${ack ? '<button class="btn go big" id="ackBtn">Acknowledge mobilisation</button>' : ''}
        <button class="btn warn big" id="routeBtn">Set route</button>
        <button class="btn" id="mapBtn">Open map</button>
        <div class="spacer" style="flex:1"></div>
        <button class="btn" id="offBtn">Book off incident</button>
      </div>`;
    el.querySelectorAll('[data-risk]').forEach(b => b.onclick = () => { S.selRisk = +b.dataset.risk; go('risks'); });
    $('#routeBtn').onclick = () => post('setRoute', { x: inc.x, y: inc.y });
    $('#mapBtn').onclick = () => go('map');
    if (ack) $('#ackBtn').onclick = acknowledge;
    $('#offBtn').onclick = async () => {
        if (!(await confirmBox('Book off this incident?', 'Book off', 'warn'))) return;
        const [ok] = await srv('incident:detach');
        if (ok) { S.me.incident = null; renderHeader(); render(); }
    };
}

function nearestHydrants(p, n = 3) {
    return Object.values(S.hydrants).map(h => ({ ...h, d: dist(h, p) })).sort((a, b) => a.d - b.d).slice(0, n);
}

function refreshWater() {
    const el = $('#incWater'); const inc = myIncident(); if (!el || !inc) return;
    const list = nearestHydrants(inc, 4);
    el.innerHTML = list.length ? `<div class="list">${list.map(h => `
        <div class="item" data-h="${h.id}"><span class="dot" style="background:${h.status === 'Serviceable' ? 'var(--blue)' : 'var(--red)'}"></span>
        <div class="grow"><div class="t">${esc(h.code)} <span class="muted small">${esc(h.type)}</span></div>
        <div class="s">${esc(h.status)}${h.defect ? ' - ' + esc(h.defect) : ''}</div></div>
        <div style="text-align:right"><b>${fmtDist(h.d)}</b><div class="small muted">${lengths(h.d)} lengths</div></div></div>`).join('')}</div>`
        : '<div class="muted">No hydrants recorded near this incident.</div>';
    el.querySelectorAll('[data-h]').forEach(i => i.onclick = () => { const h = S.hydrants[i.dataset.h]; post('setRoute', { x: h.x, y: h.y }); });
}

async function loadLog(id) {
    const [rows] = await srv('incident:log', id);
    S.logs[id] = rows || [];
    refreshLog();
}
function refreshLog() {
    const el = $('#incLog'); const inc = myIncident(); if (!el || !inc) return;
    const rows = S.logs[inc.id] || [];
    el.innerHTML = rows.length ? rows.slice().reverse().map(e => `
        <div class="log-e ${esc(e.kind)}"><div class="when">${fmtTime(e.created_at)} ${esc(e.callsign || '')} ${esc(e.author || '')}</div>
        ${e.kind === 'assistance' ? '<b>Assistance: </b>' : e.kind === 'informative' ? '<b>Informative: </b>' : e.kind === 'stop' ? '<b>Stop: </b>' : ''}${esc(e.text)}</div>`).join('')
        : '<div class="muted">No entries yet.</div>';
}

async function sendMessage(kind, text) {
    const inc = myIncident(); if (!inc) return;
    const [ok, err] = await srv('incident:message', inc.id, kind, text);
    if (!ok) toast('Message not sent', err || '', 'error');
    else toast(`Sent to ${S.cfg.branding.controlName}`, text, 'success');
}

function renderIncidentList(v) {
    const list = openIncidents();
    v.innerHTML = `<h2>Open incidents</h2>
      <div class="list" id="openList">${list.length ? '' : '<div class="empty">No open incidents. You will be alerted when mobilised.</div>'}</div>
      <h3>Incident history</h3>
      <div class="row"><input id="histQ" placeholder="Search by reference, address or type" style="flex:1"><button class="btn" id="histBtn">Search</button></div>
      <div class="list" id="histList" style="margin-top:8px"></div>`;
    $('#openList').innerHTML += list.map(i => `
        <div class="item"><span class="pill ${i.priority?.includes('1') ? 'red' : 'amber'}">${esc(i.priority)}</span>
        <div class="grow"><div class="t">${esc(i.type)}</div><div class="s">${esc(i.location)} - ${esc(i.ref)} - ${fmtTime(i.created_at)} - ${esc((i.units || []).join(', ') || 'No units')}</div></div>
        <b>${fmtDist(dist(S.me, i))}</b><button class="btn go" data-book="${i.id}">Book on</button></div>`).join('');
    v.querySelectorAll('[data-book]').forEach(b => b.onclick = async () => {
        const [ok] = await srv('incident:attach', +b.dataset.book);
        if (ok) { S.me.incident = +b.dataset.book; renderHeader(); render(); }
    });
    const search = async () => {
        const [rows] = await srv('incident:history', $('#histQ').value.trim());
        $('#histList').innerHTML = (rows || []).map(i => `<div class="item" data-hist="${i.id}"><div class="grow"><div class="t">${esc(i.ref)} ${esc(i.type)}</div>
            <div class="s">${esc(i.location)} - ${fmtDate(i.created_at)}</div></div><span class="pill">Closed</span></div>`).join('') || '<div class="muted">No closed incidents found.</div>';
        $('#histList').querySelectorAll('[data-hist]').forEach(r => r.onclick = () => historyModal(rows.find(x => x.id === +r.dataset.hist)));
    };
    $('#histBtn').onclick = search; $('#histQ').onkeydown = e => e.key === 'Enter' && search();
}

async function historyModal(inc) {
    const [rows] = await srv('incident:log', inc.id);
    modal(`<h2>${esc(inc.ref)} ${esc(inc.type)}</h2><p>${esc(inc.location)}</p><p class="muted small">${fmtDate(inc.created_at)} to ${fmtDate(inc.closed_at)}</p>
        <div class="log" style="margin-top:12px">${(rows || []).map(e => `<div class="log-e ${esc(e.kind)}"><div class="when">${fmtTime(e.created_at)} ${esc(e.callsign || '')} ${esc(e.author || '')}</div>${esc(e.text)}</div>`).join('')}</div>
        <div class="row" style="justify-content:flex-end;margin-top:14px"><button class="btn" id="hc">Close</button></div>`, m => m.querySelector('#hc').onclick = closeModal);
}

async function acknowledge() {
    const id = S.pendingAck; if (!id) return;
    await srv('incident:accept', id);
    S.pendingAck = null; S.me.incident = id;
    S.me.status = S.cfg.statuses.find(s => s.code === 3) ? 3 : S.me.status;
    const inc = S.incidents[id];
    if (inc) post('setRoute', { x: inc.x, y: inc.y });
    $('#mobilise').classList.add('hidden');
    renderHeader(); renderStatus(); go('incident');
}
$('#mobAccept').onclick = acknowledge;

/* ── Tactical map ────────────────────────── */
let mapRaf = null, mapLast = 0;
function stopMap() { if (mapRaf) cancelAnimationFrame(mapRaf); mapRaf = null; }

Views.map = v => {
    v.style.padding = '12px';
    v.innerHTML = `<div class="map-wrap" style="height:calc(100% - 2px)">
      <div class="map-box"><canvas id="tac"></canvas>
        <div class="map-ctrls">
          <button id="zIn" title="Zoom in">+</button><button id="zOut" title="Zoom out">−</button>
          <button id="zAuto" class="${S.map.auto ? 'on' : ''}" title="Auto scale">A</button>
          <button id="mTool" class="${S.map.measuring ? 'on' : ''}" title="Measure">⟷</button>
          <button id="cTool" title="Centre on incident / me">◎</button>
          ${S.perms.control && S.cfg.mapImage?.enabled ? '<button id="calTool" title="Calibrate map image" style="font-size:12px">Cal</button>' : ''}
        </div>
      </div>
      <div>
        <div class="panel"><label>Distance to incident</label><div class="readout" id="rInc">-</div></div>
        <div class="panel"><label>Nearest hydrant to incident</label><div class="readout" id="rHyd">-</div><div class="small muted" id="rHydS"></div></div>
        <div class="panel"><label>Measurement</label><div class="readout" id="rMeas">-</div><div class="small muted" id="rMeasS">Tap the measure tool, then two points on the map.</div></div>
        <div class="panel">
          <button class="btn warn" style="width:100%" id="mRoute">Route to incident</button>
          <button class="btn" style="width:100%;margin-top:6px" id="mRouteH">Route to nearest hydrant</button>
          <button class="btn" style="width:100%;margin-top:6px" id="mBlips">Show hydrants on GPS</button>
        </div>
        <div class="small muted" style="margin-top:8px">Scale adjusts automatically as you approach the incident.</div>
      </div></div>`;
    const cv = $('#tac');
    const resize = () => { const r = cv.getBoundingClientRect(); cv.width = r.width; cv.height = r.height; };
    resize();
    $('#zIn').onclick = () => { S.map.auto = false; S.map.zoom = Math.min(S.map.zoom * 1.5, 40); syncMapBtns(); };
    $('#zOut').onclick = () => { S.map.auto = false; S.map.zoom = Math.max(S.map.zoom / 1.5, .05); syncMapBtns(); };
    $('#zAuto').onclick = () => { S.map.auto = !S.map.auto; S.map.zoom = 1; syncMapBtns(); };
    $('#mTool').onclick = () => { S.map.measuring = !S.map.measuring; S.map.measure = []; syncMapBtns(); };
    $('#cTool').onclick = () => { S.map.follow = S.map.follow === 'me' ? 'incident' : 'me'; };
    const cal = $('#calTool'); if (cal) cal.onclick = startCalibration;
    loadMapImage();
    $('#mRoute').onclick = () => { const i = myIncident(); if (i) post('setRoute', { x: i.x, y: i.y }); else toast('No incident', 'Book on to an incident first.', 'warn'); };
    $('#mRouteH').onclick = () => { const h = nearestHydrants(refPoint(), 1)[0]; if (h) post('setRoute', { x: h.x, y: h.y }); };
    $('#mBlips').onclick = async () => {
        const p = refPoint(); const r = S.cfg.hydrantRadius;
        const list = Object.values(S.hydrants).filter(h => dist(h, p) <= r);
        const n = await post('hydrantBlips', { list });
        toast('Hydrants on GPS', `${n || 0} hydrants within ${r} m shown.`, 'success');
    };
    cv.addEventListener('click', e => {
        const r = cv.getBoundingClientRect();
        const scaleX = cv.width / r.width;
        const w = screenToWorld((e.clientX - r.left) * scaleX, (e.clientY - r.top) * scaleX);
        if (CAL.active) return calibrationTap(w);
        if (!S.map.measuring) return;
        if (S.map.measure.length >= 2) S.map.measure = [];
        S.map.measure.push(w);
    });
    const loop = t => {
        mapRaf = requestAnimationFrame(loop);
        if (t - mapLast < 66) return; mapLast = t;
        if (cv.width !== Math.round(cv.getBoundingClientRect().width)) resize();
        drawMap(cv);
    };
    mapRaf = requestAnimationFrame(loop);
};
function syncMapBtns() {
    $('#zAuto')?.classList.toggle('on', S.map.auto);
    $('#mTool')?.classList.toggle('on', S.map.measuring);
}

let MP = { cx: 0, cy: 0, scale: 1, w: 0, h: 0 };
let mapImg = null;
function loadMapImage() {
    const mi = S.cfg?.mapImage;
    if (!mi?.enabled || mapImg) return;
    mapImg = new Image();
    mapImg.src = mi.file;
}
// Calibration: tap your real position on the map at two places far apart
const CAL = { active: false, samples: [] };
function startCalibration() {
    CAL.active = true; CAL.samples = [];
    S.map.measuring = false; syncMapBtns();
    toast('Calibration step 1 of 2', 'Tap exactly where you are standing on the map image.', 'warn');
}
function calibrationTap(world) {
    const mi = S.cfg.mapImage, size = mapImg.naturalWidth, sizeY = mapImg.naturalHeight;
    // which image pixel did they tap, using the current bounds
    const px = (world.x - mi.minX) / (mi.maxX - mi.minX) * size;
    const py = (mi.maxY - world.y) / (mi.maxY - mi.minY) * sizeY;
    CAL.samples.push({ px, py, wx: S.me.x, wy: S.me.y });
    if (CAL.samples.length === 1) return toast('Calibration step 2 of 2', 'Now drive at least 1 km away, open the map and tap your position again.', 'warn');
    const [a, b] = CAL.samples;
    if (Math.abs(a.wx - b.wx) < 500 || Math.abs(a.wy - b.wy) < 500) {
        CAL.samples = [b];
        return toast('Points too close', 'Move at least 500 m north/south and east/west of the first point, then tap again.', 'error');
    }
    const sx = (b.px - a.px) / (b.wx - a.wx);   // px per metre east
    const sy = (b.py - a.py) / (a.wy - b.wy);   // px per metre north
    const minX = a.wx - a.px / sx, maxX = minX + size / sx;
    const maxY = a.wy + a.py / sy, minY = maxY - sizeY / sy;
    Object.assign(mi, { minX, maxX, minY, maxY });
    CAL.active = false; CAL.samples = [];
    post('calibrated', { minX, maxX, minY, maxY });
    toast('Map calibrated', 'Values printed to the F8 console. Paste them into Config.MapImage.', 'success');
}
function screenToWorld(sx, sy) { return { x: MP.cx + (sx - MP.w / 2) / MP.scale, y: MP.cy - (sy - MP.h / 2) / MP.scale }; }
function W2S(p) { return [MP.w / 2 + (p.x - MP.cx) * MP.scale, MP.h / 2 - (p.y - MP.cy) * MP.scale]; }

function drawMap(cv) {
    const ctx = cv.getContext('2d'); const w = cv.width, h = cv.height;
    const inc = myIncident();
    const centre = (S.map.follow === 'incident' && inc) ? inc : S.me;
    let range;
    if (S.map.auto && inc) range = Math.max(S.cfg.mapMin, Math.min(S.cfg.mapMax, dist(S.me, inc) * (S.map.follow === 'incident' ? 1.2 : 1.25)));
    else range = 200 / S.map.zoom;
    if (S.map.auto && !inc) range = 200;
    MP = { cx: centre.x, cy: centre.y, scale: (Math.min(w, h) / 2) / range, w, h };

    ctx.fillStyle = '#192026'; ctx.fillRect(0, 0, w, h);
    const mi = S.cfg.mapImage;
    // fade the image out when zoomed in past what its resolution can show
    const ppmNative = mapImg?.naturalWidth ? mapImg.naturalWidth / (mi.maxX - mi.minX) : 0;
    const upscale = ppmNative ? MP.scale / ppmNative : 99;
    const imgAlpha = Math.max(0, Math.min(1, (mi.fadeEnd - upscale) / (mi.fadeEnd - mi.fadeStart)));
    if (mapImg && mapImg.complete && mapImg.naturalWidth && imgAlpha > 0) {
        ctx.fillStyle = mi.sea || '#0f8fb5'; ctx.globalAlpha = imgAlpha; ctx.fillRect(0, 0, w, h);
        const iw = mapImg.naturalWidth, ih = mapImg.naturalHeight;
        const ppmX = iw / (mi.maxX - mi.minX), ppmY = ih / (mi.maxY - mi.minY);
        const tl0 = screenToWorld(0, 0), br0 = screenToWorld(w, h);
        const sx0 = (tl0.x - mi.minX) * ppmX, sy0 = (mi.maxY - tl0.y) * ppmY;
        const sw = (br0.x - tl0.x) * ppmX, sh = (tl0.y - br0.y) * ppmY;
        ctx.imageSmoothingQuality = 'high';
        ctx.drawImage(mapImg, sx0, sy0, sw, sh, 0, 0, w, h);
        if (mi.dim) { ctx.fillStyle = `rgba(20,26,32,${mi.dim})`; ctx.fillRect(0, 0, w, h); }
        ctx.globalAlpha = 1;
    }
    const imgShown = imgAlpha > .5;

    // grid
    const steps = [5, 10, 25, 50, 100, 250, 500, 1000, 2500];
    const step = steps.find(s => s * MP.scale > 70) || 2500;
    ctx.strokeStyle = imgShown ? 'rgba(255,255,255,.07)' : '#26303a'; ctx.lineWidth = 1;
    const tl = screenToWorld(0, 0), br = screenToWorld(w, h);
    for (let x = Math.floor(tl.x / step) * step; x < br.x; x += step) { const [sx] = W2S({ x, y: 0 }); ctx.beginPath(); ctx.moveTo(sx, 0); ctx.lineTo(sx, h); ctx.stroke(); }
    for (let y = Math.floor(br.y / step) * step; y < tl.y; y += step) { const [, sy] = W2S({ x: 0, y }); ctx.beginPath(); ctx.moveTo(0, sy); ctx.lineTo(w, sy); ctx.stroke(); }

    // risk sites
    for (const r of Object.values(S.risks)) {
        const [sx, sy] = W2S(r); const rad = (r.radius || 50) * MP.scale;
        if (sx < -rad || sy < -rad || sx > w + rad || sy > h + rad) continue;
        const col = r.level >= 3 ? '200,16,46' : r.level === 2 ? '242,194,0' : '46,158,91';
        ctx.fillStyle = `rgba(${col},.12)`; ctx.strokeStyle = `rgba(${col},.8)`; ctx.setLineDash([6, 4]);
        ctx.beginPath(); ctx.arc(sx, sy, rad, 0, Math.PI * 2); ctx.fill(); ctx.stroke(); ctx.setLineDash([]);
        ctx.fillStyle = `rgb(${col})`; ctx.font = '600 13px Barlow, sans-serif'; ctx.textAlign = 'center'; ctx.fillText(r.name, sx, sy + rad + 16); ctx.textAlign = 'left';
    }

    // hydrants
    for (const hy of Object.values(S.hydrants)) {
        const [sx, sy] = W2S(hy); if (sx < -10 || sy < -10 || sx > w + 10 || sy > h + 10) continue;
        const ok = hy.status === 'Serviceable';
        ctx.fillStyle = ok ? '#3b82c4' : '#c8102e'; ctx.strokeStyle = '#fff'; ctx.lineWidth = 1.5;
        ctx.beginPath(); ctx.rect(sx - 6, sy - 6, 12, 12); ctx.fill(); ctx.stroke();
        ctx.fillStyle = '#fff'; ctx.font = '700 10px Barlow, sans-serif'; ctx.fillText('H', sx - 3.5, sy + 3.5);
        if (!ok) { ctx.strokeStyle = '#fff'; ctx.beginPath(); ctx.moveTo(sx - 8, sy - 8); ctx.lineTo(sx + 8, sy + 8); ctx.stroke(); }
        if (MP.scale > .6) { ctx.fillStyle = '#b9c7d4'; ctx.font = '500 11px Barlow, sans-serif'; ctx.fillText(hy.code, sx + 9, sy + 4); }
    }

    // incident
    if (inc) {
        const [ix, iy] = W2S(inc); const [mx, my] = W2S(S.me);
        ctx.strokeStyle = 'rgba(242,194,0,.7)'; ctx.setLineDash([8, 6]); ctx.lineWidth = 2;
        ctx.beginPath(); ctx.moveTo(mx, my); ctx.lineTo(ix, iy); ctx.stroke(); ctx.setLineDash([]);
        const pulse = 4 + 3 * Math.sin(Date.now() / 250);
        ctx.fillStyle = '#c8102e'; ctx.strokeStyle = '#fff'; ctx.lineWidth = 2;
        ctx.beginPath(); ctx.moveTo(ix, iy - 12 - pulse); ctx.lineTo(ix + 12 + pulse, iy); ctx.lineTo(ix, iy + 12 + pulse); ctx.lineTo(ix - 12 - pulse, iy); ctx.closePath(); ctx.fill(); ctx.stroke();
        ctx.fillStyle = '#fff'; ctx.font = '700 14px Barlow, sans-serif'; ctx.fillText(inc.type, ix + 20, iy + 5);
    }

    // other units
    for (const u of S.units) {
        if (u.x == null || u.src === S.serverId) continue;
        const [sx, sy] = W2S(u); if (sx < -20 || sy < -20 || sx > w + 20 || sy > h + 20) continue;
        ctx.fillStyle = statusDef(u.status)?.colour || '#999'; ctx.strokeStyle = '#111'; ctx.lineWidth = 2;
        ctx.beginPath(); ctx.arc(sx, sy, 7, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
        ctx.fillStyle = '#e9edf0'; ctx.font = '700 12px "Barlow Condensed", sans-serif'; ctx.fillText(`${u.callsign} (${u.status})`, sx + 10, sy + 4);
    }

    // me
    {
        const [sx, sy] = W2S(S.me); const a = -(S.me.heading || 0) * Math.PI / 180;
        ctx.save(); ctx.translate(sx, sy); ctx.rotate(a);
        ctx.fillStyle = '#f2c200'; ctx.strokeStyle = '#111'; ctx.lineWidth = 2;
        ctx.beginPath(); ctx.moveTo(0, -14); ctx.lineTo(9, 10); ctx.lineTo(0, 5); ctx.lineTo(-9, 10); ctx.closePath(); ctx.fill(); ctx.stroke();
        ctx.restore();
    }

    // measurement
    if (S.map.measure.length) {
        ctx.strokeStyle = '#fff'; ctx.fillStyle = '#fff'; ctx.lineWidth = 2;
        const pts = S.map.measure.map(W2S);
        pts.forEach(([x, y]) => { ctx.beginPath(); ctx.arc(x, y, 5, 0, Math.PI * 2); ctx.fill(); });
        if (pts.length === 2) { ctx.beginPath(); ctx.moveTo(...pts[0]); ctx.lineTo(...pts[1]); ctx.stroke(); }
    }

    // scale bar
    ctx.fillStyle = 'rgba(21,25,29,.85)'; ctx.fillRect(10, h - 38, step * MP.scale + 20, 28);
    ctx.fillStyle = '#e9edf0'; ctx.fillRect(20, h - 18, step * MP.scale, 4);
    ctx.font = '600 12px Barlow, sans-serif'; ctx.fillText(fmtDist(step), 20, h - 24);
    ctx.fillStyle = 'rgba(21,25,29,.85)'; ctx.fillRect(w - 48, h - 34, 38, 24); ctx.fillStyle = '#e9edf0'; ctx.fillText('N ↑', w - 40, h - 17);

    // readouts
    $('#rInc').textContent = inc ? fmtDist(dist(S.me, inc)) : '-';
    const nh = inc ? nearestHydrants(inc, 1)[0] : null;
    $('#rHyd').textContent = nh ? `${fmtDist(nh.d)}` : '-';
    $('#rHydS').textContent = nh ? `${nh.code}, ${nh.status} - ${lengths(nh.d)} lengths of ${S.cfg.hoseLength} m hose` : '';
    if (S.map.measure.length === 2) {
        const d = dist(S.map.measure[0], S.map.measure[1]);
        $('#rMeas').textContent = fmtDist(d);
        $('#rMeasS').textContent = `${lengths(d)} lengths of ${S.cfg.hoseLength} m hose`;
    }
}

/* ── Hydrants ────────────────────────────── */
Views.hydrants = v => {
    const p = refPoint();
    const list = Object.values(S.hydrants).map(h => ({ ...h, d: dist(h, p) })).sort((a, b) => a.d - b.d).slice(0, 60);
    v.innerHTML = `<div class="row" style="justify-content:space-between"><h2>Hydrants and water supplies</h2>
        <div class="row">${S.perms.editHydrants ? '<button class="btn" id="hScan">Scan nearby hydrants</button><button class="btn go" id="hAdd">Add at my position</button>' : ''}</div></div>
      <p class="muted small" style="margin-bottom:10px">Sorted by distance from ${myIncident() ? 'your incident' : 'you'}.</p>
      <div id="scanBox"></div>
      <div class="list">${list.length ? list.map(h => `
        <div class="item"><span class="dot" style="background:${h.status === 'Serviceable' ? 'var(--blue)' : 'var(--red)'}"></span>
          <div class="grow"><div class="t">${esc(h.code)} <span class="muted small">${esc(h.type)}</span></div>
          <div class="s">${esc(h.status)}${h.defect ? ' - ' + esc(h.defect) : ''} - updated ${fmtDate(h.updated_at)} by ${esc(h.updated_by || '')}</div></div>
          <div style="text-align:right;min-width:90px"><b>${fmtDist(h.d)}</b><div class="small muted">${lengths(h.d)} lengths</div></div>
          <button class="btn sm" data-route="${h.id}">Route</button>
          ${S.perms.editHydrants ? `<button class="btn sm" data-edit="${h.id}">Edit</button>` : ''}
        </div>`).join('') : '<div class="empty">No hydrants recorded yet. Stand at a hydrant and add it at your position.</div>'}</div>`;
    v.querySelectorAll('[data-route]').forEach(b => b.onclick = () => { const h = S.hydrants[b.dataset.route]; post('setRoute', { x: h.x, y: h.y }); });
    v.querySelectorAll('[data-edit]').forEach(b => b.onclick = () => hydrantModal(S.hydrants[b.dataset.edit]));
    const add = $('#hAdd'); if (add) add.onclick = async () => { const p = await post('myPosition'); hydrantModal({ x: p.x, y: p.y, z: p.z, type: S.cfg.hydrantTypes[0], status: S.cfg.hydrantStatuses[0], street: p.street }); };
    const scan = $('#hScan'); if (scan) scan.onclick = async () => {
        const found = await post('scanHydrants') || [];
        const box = $('#scanBox');
        box.innerHTML = `<div class="panel" style="margin-bottom:12px"><h3 style="margin-top:0">Hydrants found within 80 m</h3>
          ${found.length ? found.map((f, i) => {
            const known = Object.values(S.hydrants).some(h => dist(h, f) < 3);
            return `<div class="row" style="justify-content:space-between;padding:6px 0;border-bottom:1px solid var(--line)">
              <span>${esc(f.street)} <span class="muted small">${f.dist} m - ${esc(f.model)}</span></span>
              ${known ? '<span class="pill blue">On register</span>' : `<button class="btn sm go" data-add="${i}">Add to register</button>`}</div>`;
        }).join('') : '<div class="muted">No hydrant props near you.</div>'}</div>`;
        box.querySelectorAll('[data-add]').forEach(b => b.onclick = () => {
            const f = found[+b.dataset.add];
            hydrantModal({ x: f.x, y: f.y, z: f.z, type: f.model.includes('driser') ? 'Dry riser inlet' : 'Pillar', status: S.cfg.hydrantStatuses[0], street: f.street });
        });
    };
};

function hydrantModal(h) {
    const opt = (arr, sel) => arr.map(a => `<option ${a === sel ? 'selected' : ''}>${esc(a)}</option>`).join('');
    modal(`<h2>${h.id ? 'Edit hydrant ' + esc(h.code) : 'Add hydrant'}</h2>
      ${h.street ? `<p class="muted" style="margin-bottom:10px">${esc(h.street)}</p>` : ''}
      <div class="grid2">
        <div class="field"><label>Hydrant ID</label><input id="hc" value="${esc(h.code || '')}" placeholder="Leave blank to number automatically"></div>
        <div class="field"><label>Type</label><select id="ht">${opt(S.cfg.hydrantTypes, h.type)}</select></div>
      </div>
      <div class="field"><label>Status</label><select id="hs">${opt(S.cfg.hydrantStatuses, h.status)}</select></div>
      <div class="field"><label>Defect notes</label><textarea id="hd" placeholder="e.g. Cover seized, low pressure">${esc(h.defect || '')}</textarea></div>
      <div class="row" style="justify-content:space-between;margin-top:10px">
        ${h.id && S.perms.editRisks ? '<button class="btn stop" id="hDel">Delete</button>' : '<span></span>'}
        <div class="row">${h.id ? '<button class="btn" id="hMove">Move to my position</button>' : ''}<button class="btn" id="hCancel">Cancel</button><button class="btn go" id="hSave">Save hydrant</button></div>
      </div>`, m => {
        m.querySelector('#hCancel').onclick = closeModal;
        const mv = m.querySelector('#hMove'); if (mv) mv.onclick = async () => { const p = await post('myPosition'); h.x = p.x; h.y = p.y; h.z = p.z; toast('Position updated', 'Save to confirm.'); };
        m.querySelector('#hSave').onclick = async () => {
            const [ok, err] = await srv('hydrant:save', { id: h.id, x: h.x, y: h.y, z: h.z, code: $('#hc').value.trim(), type: $('#ht').value, status: $('#hs').value, defect: $('#hd').value.trim() });
            if (!ok) return toast('Hydrant not saved', err || '', 'error');
            closeModal(); toast('Hydrant saved', '', 'success');
        };
        const del = m.querySelector('#hDel'); if (del) del.onclick = async () => {
            if (!(await confirmBox(`Delete hydrant ${h.code}?`, 'Delete'))) return;
            await srv('hydrant:delete', h.id);
        };
    });
}

/* ── Risk information (SSRI) ─────────────── */
Views.risks = v => {
    v.innerHTML = `<div class="row" style="justify-content:space-between"><h2>Operational risk information</h2>
      ${S.perms.editRisks ? '<button class="btn go" id="rNew">Add risk record</button>' : ''}</div>
      <div class="split"><div><input id="rQ" placeholder="Search site name or address" style="margin-bottom:8px"><div class="list" id="rList"></div></div>
      <div id="rDetail"></div></div>`;
    const draw = () => {
        const q = $('#rQ').value.toLowerCase(); const p = refPoint();
        const list = Object.values(S.risks).filter(r => !q || (r.name + ' ' + r.address).toLowerCase().includes(q))
            .map(r => ({ ...r, d: dist(r, p) })).sort((a, b) => a.d - b.d);
        $('#rList').innerHTML = list.map(r => {
            const lv = S.cfg.riskLevels.find(l => l.level === r.level);
            return `<div class="item ${S.selRisk === r.id ? 'sel' : ''}" data-r="${r.id}"><span class="dot" style="background:${lv?.colour}"></span>
              <div class="grow"><div class="t">${esc(r.name)}</div><div class="s">${esc(r.address)}</div></div><b>${fmtDist(r.d)}</b></div>`;
        }).join('') || '<div class="empty">No risk records.</div>';
        $('#rList').querySelectorAll('[data-r]').forEach(i => i.onclick = () => { S.selRisk = +i.dataset.r; draw(); });
        drawRisk();
    };
    const drawRisk = () => {
        const r = S.risks[S.selRisk]; const el = $('#rDetail');
        if (!r) { el.innerHTML = '<div class="empty">Select a site to view its risk information.</div>'; return; }
        const lv = S.cfg.riskLevels.find(l => l.level === r.level);
        el.innerHTML = `<div class="panel">
          <div class="inc-head"><div><div class="inc-type" style="font-size:26px">${esc(r.name)}</div><div class="muted">${esc(r.address)}</div></div>
          <span class="pill" style="background:${lv?.colour};color:${r.level === 2 ? '#1b1b1b' : '#fff'}">${esc(lv?.label)}</span></div>
          <dl class="kv">
            <dt>Hazards</dt><dd>${esc(r.hazards || 'None recorded')}</dd>
            <dt>Access</dt><dd>${esc(r.access || '-')}</dd>
            <dt>Water</dt><dd>${esc(r.water || '-')}</dd>
            <dt>Contacts</dt><dd>${esc(r.contacts || '-')}</dd>
            <dt>Notes</dt><dd>${esc(r.notes || '-')}</dd>
            <dt>Updated</dt><dd>${fmtDate(r.updated_at)} by ${esc(r.updated_by || '')}</dd>
          </dl>
          <div class="row" style="margin-top:12px"><button class="btn warn" id="rRoute">Set route</button>${S.perms.editRisks ? '<button class="btn" id="rEdit">Edit</button>' : ''}</div></div>`;
        $('#rRoute').onclick = () => post('setRoute', { x: r.x, y: r.y });
        const e = $('#rEdit'); if (e) e.onclick = () => riskModal(r);
    };
    $('#rQ').oninput = draw;
    const n = $('#rNew'); if (n) n.onclick = async () => { const p = await post('myPosition'); riskModal({ x: p.x, y: p.y, z: p.z, address: p.street, level: 1, radius: 50 }); };
    draw();
};

function riskModal(r) {
    modal(`<h2>${r.id ? 'Edit risk record' : 'New risk record'}</h2>
      <div class="field"><label>Site name</label><input id="rn" value="${esc(r.name || '')}"></div>
      <div class="field"><label>Address</label><input id="ra" value="${esc(r.address || '')}"></div>
      <div class="grid2">
        <div class="field"><label>Risk level</label><select id="rl">${S.cfg.riskLevels.map(l => `<option value="${l.level}" ${l.level === r.level ? 'selected' : ''}>${esc(l.label)}</option>`).join('')}</select></div>
        <div class="field"><label>Site radius (m)</label><input id="rr" type="number" value="${r.radius || 50}"></div>
      </div>
      <div class="field"><label>Hazards</label><textarea id="rh" placeholder="e.g. Acetylene cylinders in rear workshop, asbestos roof">${esc(r.hazards || '')}</textarea></div>
      <div class="field"><label>Access</label><textarea id="rac" placeholder="Gate codes, appliance access, key holder box">${esc(r.access || '')}</textarea></div>
      <div class="field"><label>Water supplies</label><textarea id="rw">${esc(r.water || '')}</textarea></div>
      <div class="field"><label>Contacts</label><input id="rc" value="${esc(r.contacts || '')}"></div>
      <div class="field"><label>Notes</label><textarea id="rno">${esc(r.notes || '')}</textarea></div>
      <div class="row" style="justify-content:space-between;margin-top:10px">
        ${r.id ? '<button class="btn stop" id="rDel">Delete</button>' : '<span></span>'}
        <div class="row"><button class="btn" id="rPos">Use my position</button><button class="btn" id="rCancel">Cancel</button><button class="btn go" id="rSave">Save record</button></div>
      </div>`, m => {
        m.querySelector('#rCancel').onclick = closeModal;
        m.querySelector('#rPos').onclick = async () => { const p = await post('myPosition'); r.x = p.x; r.y = p.y; r.z = p.z; toast('Position set', p.street); };
        m.querySelector('#rSave').onclick = async () => {
            const [ok, err] = await srv('risk:save', {
                id: r.id, x: r.x, y: r.y, z: r.z, name: $('#rn').value.trim(), address: $('#ra').value.trim(), level: +$('#rl').value,
                radius: +$('#rr').value, hazards: $('#rh').value, access: $('#rac').value, water: $('#rw').value, contacts: $('#rc').value, notes: $('#rno').value,
            });
            if (!ok) return toast('Record not saved', err || '', 'error');
            S.selRisk = r.id || err; closeModal(); toast('Risk record saved', '', 'success');
        };
        const del = m.querySelector('#rDel'); if (del) del.onclick = async () => {
            if (!(await confirmBox(`Delete ${r.name}?`, 'Delete'))) return;
            await srv('risk:delete', r.id); S.selRisk = null;
        };
    });
}

/* ── HazMat ──────────────────────────────── */
Views.hazmat = v => {
    v.innerHTML = `<h2>Hazardous materials</h2>
      <div class="split"><div><input id="zQ" placeholder="UN number or substance name" style="margin-bottom:8px"><div class="list" id="zList"></div></div><div id="zDetail"></div></div>`;
    const draw = () => {
        const q = $('#zQ').value.toLowerCase().trim();
        const list = S.cfg.hazmat.filter(z => !q || z.un.includes(q) || z.name.toLowerCase().includes(q) || (z.eac || '').toLowerCase() === q);
        $('#zList').innerHTML = list.map(z => `<div class="item ${S.selHaz === z.un ? 'sel' : ''}" data-z="${esc(z.un)}">
            <span class="pill amber">UN ${esc(z.un)}</span><div class="grow"><div class="t">${esc(z.name)}</div><div class="s">${esc(z.class || '')}</div></div></div>`).join('')
            || '<div class="empty">No substance matches. Check the UN number on the vehicle plate.</div>';
        $('#zList').querySelectorAll('[data-z]').forEach(i => i.onclick = () => { S.selHaz = i.dataset.z; draw(); });
        const z = S.cfg.hazmat.find(x => x.un === S.selHaz);
        $('#zDetail').innerHTML = z ? `<div class="panel">
            <div class="row" style="align-items:flex-start;gap:18px">
              <div class="un-plate">${z.eac ? `<span>${esc(z.eac)}</span>` : ''}<span>${esc(z.un)}</span></div>
              <div><div class="inc-type" style="font-size:26px">${esc(z.name)}</div><div class="muted">${esc(z.class || '')}</div></div>
            </div>
            <dl class="kv"><dt>Hazards</dt><dd>${esc(z.hazards || '-')}</dd><dt>PPE</dt><dd>${esc(z.ppe || '-')}</dd>
            <dt>Actions</dt><dd>${esc(z.actions || '-')}</dd><dt>Firefighting</dt><dd>${esc(z.fire || '-')}</dd></dl></div>`
            : '<div class="empty">Search by the UN number on the orange plate.</div>';
    };
    $('#zQ').oninput = draw; draw();
};

/* ── Vehicle rescue ──────────────────────── */
Views.rescue = v => {
    const r = S.rescue;
    v.innerHTML = `<div class="row" style="justify-content:space-between"><h2>Vehicle rescue data</h2><button class="btn warn big" id="vScan">Scan nearest vehicle</button></div>
      <div id="vOut">${r ? '' : '<div class="empty">Stand next to the casualty vehicle and scan it to see fuel type, battery location, airbags and cut zones.</div>'}</div>`;
    $('#vScan').onclick = async () => {
        const res = await post('scanVehicle');
        if (!res || res.error) return toast('Scan failed', res?.error || '', 'error');
        S.rescue = res; render();
    };
    if (r) {
        const s = r.sheet || {};
        const hv = s.fuel === 'Electric' || s.fuel === 'Hybrid' || s.fuel === 'Hydrogen';
        $('#vOut').innerHTML = `<div class="panel">
          <div class="inc-head"><div><div class="inc-type">${esc(r.make)} ${esc(r.label && r.label !== 'NULL' ? r.label : r.model)}</div>
          <div class="muted">Plate ${esc(r.plate)} - ${esc(r.classInfo?.label || 'Class ' + r.class)}</div></div>
          ${hv ? '<span class="pill red" style="font-size:16px;padding:8px 12px">High voltage</span>' : `<span class="pill">${esc(s.fuel || 'Fuel unknown')}</span>`}</div>
          ${r.onFire ? '<div class="risk-banner"><div>Vehicle is on fire</div></div>' : ''}
          <dl class="kv">
            <dt>Fuel / drive</dt><dd>${esc(s.fuel || 'Not on file - treat as unknown')}</dd>
            <dt>Battery</dt><dd>${esc(s.battery || '-')}</dd>
            <dt>Airbags</dt><dd>${esc(s.airbags || '-')}</dd>
            <dt>Cut zones</dt><dd>${esc(s.cutZones || '-')}</dd>
            <dt>Notes</dt><dd>${esc(s.notes || '')}${s.notes ? '\n' : ''}${esc(r.classInfo?.notes || '')}</dd>
            <dt>Occupants</dt><dd>${r.occupants}</dd>
            <dt>Engine</dt><dd>${r.engineHealth < 300 ? 'Heavily damaged' : r.engineHealth < 700 ? 'Damaged' : 'Intact'}</dd>
          </dl></div>`;
    }
};

/* ── Procedures ──────────────────────────── */
Views.sops = v => {
    const list = Object.values(S.sops).sort((a, b) => (a.category + a.title).localeCompare(b.category + b.title));
    const cats = [...new Set(list.map(s => s.category))];
    v.innerHTML = `<div class="row" style="justify-content:space-between"><h2>Policies and procedures</h2>${S.perms.editSops ? '<button class="btn go" id="sNew">Add procedure</button>' : ''}</div>
      <div class="split" style="grid-template-columns:300px 1fr"><div>${cats.map(c => `<h3>${esc(c)}</h3><div class="list">${list.filter(s => s.category === c).map(s =>
        `<div class="item ${S.selSop === s.id ? 'sel' : ''}" data-s="${s.id}"><div class="grow"><div class="t">${esc(s.title)}</div></div></div>`).join('')}</div>`).join('') || '<div class="empty">No procedures.</div>'}</div>
      <div id="sBody"></div></div>`;
    v.querySelectorAll('[data-s]').forEach(i => i.onclick = () => { S.selSop = +i.dataset.s; render(); });
    const s = S.sops[S.selSop];
    $('#sBody').innerHTML = s ? `<div class="panel"><div class="muted small">${esc(s.category)}</div><h2>${esc(s.title)}</h2><div class="sop-body">${esc(s.body)}</div>
        <div class="row muted small" style="margin-top:14px;justify-content:space-between"><span>Updated ${fmtDate(s.updated_at)} by ${esc(s.updated_by || '')}</span>
        ${S.perms.editSops ? '<button class="btn sm" id="sEdit">Edit</button>' : ''}</div></div>` : '<div class="empty">Select a procedure to read it.</div>';
    const e = $('#sEdit'); if (e) e.onclick = () => sopModal(s);
    const n = $('#sNew'); if (n) n.onclick = () => sopModal({ category: 'SOP' });
};

function sopModal(s) {
    modal(`<h2>${s.id ? 'Edit procedure' : 'New procedure'}</h2>
      <div class="grid2"><div class="field"><label>Category</label><input id="sc" value="${esc(s.category || '')}"></div>
      <div class="field"><label>Title</label><input id="st" value="${esc(s.title || '')}"></div></div>
      <div class="field"><label>Content</label><textarea id="sb" style="min-height:260px">${esc(s.body || '')}</textarea></div>
      <div class="row" style="justify-content:space-between;margin-top:10px">${s.id ? '<button class="btn stop" id="sDel">Delete</button>' : '<span></span>'}
      <div class="row"><button class="btn" id="sCancel">Cancel</button><button class="btn go" id="sSave">Save procedure</button></div></div>`, m => {
        m.querySelector('#sCancel').onclick = closeModal;
        m.querySelector('#sSave').onclick = async () => {
            const [ok, id] = await srv('sop:save', { id: s.id, category: $('#sc').value.trim() || 'General', title: $('#st').value.trim(), body: $('#sb').value });
            if (!ok) return toast('Procedure not saved', id || '', 'error');
            S.selSop = s.id || id; closeModal(); toast('Procedure saved', '', 'success');
        };
        const d = m.querySelector('#sDel'); if (d) d.onclick = async () => { if (await confirmBox(`Delete ${s.title}?`, 'Delete')) { await srv('sop:delete', s.id); S.selSop = null; } };
    });
}

/* ── Messages ────────────────────────────── */
Views.messages = v => {
    v.innerHTML = `<h2>Messages</h2>
      <div class="panel"><label>Message to ${esc(S.cfg.branding.controlName)}</label>
      <div class="row"><input id="mIn" placeholder="Type a message" style="flex:1"><button class="btn go" id="mSend">Send</button></div></div>
      <div class="list" id="mList" style="margin-top:12px"></div>`;
    const draw = () => {
        $('#mList').innerHTML = S.messages.slice().reverse().map(m => `<div class="item" style="cursor:default"><div class="grow">
            <div class="t">${esc(m.from)} <span class="muted small">${esc(m.name || '')} ${fmtTime(m.at)}</span></div><div>${esc(m.text)}</div></div>
            ${m.toControl ? '<span class="pill">To control</span>' : ''}</div>`).join('') || '<div class="empty">No messages this shift.</div>';
    };
    const send = async () => {
        const t = $('#mIn').value.trim(); if (!t) return;
        const [ok] = await srv('unit:message', t);
        if (ok) { S.messages.push({ from: S.me.callsign, name: 'You', text: t, at: Date.now() / 1000, toControl: true }); $('#mIn').value = ''; draw(); }
        else toast('Not sent', 'Sign on first.', 'error');
    };
    $('#mSend').onclick = send; $('#mIn').onkeydown = e => e.key === 'Enter' && send();
    draw();
};

/* ── Fire Control ────────────────────────── */
Views.control = v => {
    if (!S.perms.control) return Views.incident(v);
    const opt = arr => arr.map(a => `<option>${esc(a)}</option>`).join('');
    v.innerHTML = `<div class="split">
      <div>
        <div class="panel"><h3 style="margin-top:0">Create incident</h3>
          <div class="grid2"><div class="field"><label>Incident type</label><select id="cType">${opt(S.cfg.incidentTypes)}</select></div>
          <div class="field"><label>Priority</label><select id="cPri">${opt(S.cfg.priorities)}</select></div></div>
          <div class="field"><label>Location</label><div class="row"><input id="cLoc" style="flex:1" placeholder="Use waypoint or my position"><button class="btn sm" id="cWp">Use waypoint</button><button class="btn sm" id="cMe">My position</button></div></div>
          <div class="grid2"><div class="field"><label>Caller</label><input id="cCaller"></div><div class="field"><label>Coordinates</label><input id="cXY" disabled></div></div>
          <div class="field"><label>Details</label><textarea id="cDet" placeholder="e.g. Smoke issuing from first-floor window, persons reported"></textarea></div>
          <button class="btn stop big" id="cCreate" style="width:100%">Create incident</button>
        </div>
        <div class="panel"><h3 style="margin-top:0">Message units</h3>
          <div class="row"><select id="cTo" style="width:180px"></select><input id="cMsg" style="flex:1" placeholder="Message"><button class="btn go" id="cSend">Send</button></div></div>
      </div>
      <div>
        <div class="panel"><h3 style="margin-top:0">Open incidents</h3><div class="list" id="cIncs"></div></div>
        <div class="panel units-board"><h3 style="margin-top:0">Appliances</h3><div class="list" id="cUnits"></div></div>
      </div></div>`;
    let loc = null;
    const setLoc = p => { if (!p || p.error) return toast('No location', p?.error || '', 'error'); loc = p; $('#cLoc').value = p.street; $('#cXY').value = `${p.x.toFixed(1)}, ${p.y.toFixed(1)}`; };
    $('#cWp').onclick = async () => setLoc(await post('waypointPosition'));
    $('#cMe').onclick = async () => setLoc(await post('myPosition'));
    $('#cCreate').onclick = async () => {
        if (!loc) return toast('Set a location', 'Place a waypoint on the map or use your position.', 'warn');
        const [ok, err] = await srv('incident:create', { type: $('#cType').value, priority: $('#cPri').value, location: $('#cLoc').value.trim() || loc.street,
            coords: { x: loc.x, y: loc.y, z: loc.z }, details: $('#cDet').value.trim(), caller: $('#cCaller').value.trim() });
        if (!ok) return toast('Incident not created', err || '', 'error');
        toast('Incident created', 'Now mobilise appliances.', 'success');
        $('#cDet').value = ''; $('#cCaller').value = ''; loc = null; $('#cLoc').value = ''; $('#cXY').value = '';
        mobiliseModal(err);
    };
    $('#cSend').onclick = async () => {
        const t = $('#cMsg').value.trim(); if (!t) return;
        const [ok] = await srv('control:message', $('#cTo').value, t);
        if (ok) { $('#cMsg').value = ''; toast('Message sent', '', 'success'); }
    };
    refreshControl();
};

function refreshControl() {
    if (S.view !== 'control' || !$('#cIncs')) return;
    const list = openIncidents();
    $('#cIncs').innerHTML = list.map(i => `<div class="item" style="cursor:default"><span class="pill ${i.priority?.includes('1') ? 'red' : 'amber'}">${esc(i.priority)}</span>
        <div class="grow"><div class="t">${esc(i.ref)} ${esc(i.type)}</div><div class="s">${esc(i.location)} - ${esc((i.units || []).join(', ') || 'No units')}</div></div>
        <button class="btn sm warn" data-mob="${i.id}">Mobilise</button><button class="btn sm" data-close="${i.id}">Close</button></div>`).join('') || '<div class="muted">No open incidents.</div>';
    $('#cIncs').querySelectorAll('[data-mob]').forEach(b => b.onclick = () => mobiliseModal(+b.dataset.mob));
    $('#cIncs').querySelectorAll('[data-close]').forEach(b => b.onclick = async () => {
        if (await confirmBox('Close this incident?', 'Close incident')) srv('incident:close', +b.dataset.close);
    });
    $('#cUnits').innerHTML = S.units.map(u => {
        const sd = statusDef(u.status); const inc = u.incident ? S.incidents[u.incident] : null;
        return `<div class="item"><span class="dot" style="background:${sd?.colour}"></span><div class="grow"><div class="t">${esc(u.callsign)} <span class="muted small">${esc(u.name)}</span></div>
            <div class="s">${u.status} ${esc(sd?.label || '')}${inc ? ' - ' + esc(inc.ref) : ''}</div></div></div>`;
    }).join('') || '<div class="muted">No appliances signed on.</div>';
    const to = $('#cTo'); if (to) {
        const cur = to.value;
        to.innerHTML = '<option value="all">All appliances</option>' + S.units.map(u => `<option value="${u.src}">${esc(u.callsign)} (${esc(u.name)})</option>`).join('');
        if ([...to.options].some(o => o.value === cur)) to.value = cur;
    }
}

function mobiliseModal(id) {
    const inc = S.incidents[id];
    const avail = S.units.slice().sort((a, b) => dist(a, inc || {}) - dist(b, inc || {}));
    modal(`<h2>Mobilise to ${esc(inc?.ref || '')}</h2><p class="muted" style="margin-bottom:10px">${esc(inc?.type || '')} - ${esc(inc?.location || '')}</p>
      <div class="list">${avail.map(u => {
        const sd = statusDef(u.status); const busy = u.incident && u.incident !== id;
        return `<label class="check"><input type="checkbox" value="${u.src}" ${u.incident === id ? 'checked disabled' : ''}>
          <span class="dot" style="background:${sd?.colour}"></span><span style="flex:1"><b>${esc(u.callsign)}</b> <span class="muted small">${u.status} ${esc(sd?.label || '')}${busy ? ' - committed elsewhere' : ''}</span></span>
          <span class="small">${inc && u.x != null ? fmtDist(dist(u, inc)) : ''}</span></label>`;
      }).join('') || '<div class="muted">No appliances signed on.</div>'}</div>
      <div class="row" style="justify-content:flex-end;margin-top:14px"><button class="btn" id="mbC">Cancel</button><button class="btn stop" id="mbGo">Mobilise selected</button></div>`, m => {
        m.querySelector('#mbC').onclick = closeModal;
        m.querySelector('#mbGo').onclick = async () => {
            const sel = [...m.querySelectorAll('input:checked:not(:disabled)')].map(c => +c.value);
            if (!sel.length) return toast('Select at least one appliance', '', 'warn');
            const [ok, n] = await srv('incident:mobilise', id, sel);
            closeModal();
            toast(ok ? `${n} appliance(s) mobilised` : 'Mobilisation failed', '', ok ? 'success' : 'error');
        };
    });
}

/* ── Sync from server ────────────────────── */
function onSync(kind, d) {
    switch (kind) {
        case 'units': {
            S.units = d || [];
            const mine = S.units.find(u => u.src === S.serverId);
            if (mine) {
                const changed = mine.status !== S.me.status || mine.incident !== S.me.incident;
                S.me.status = mine.status; S.me.incident = mine.incident;
                if (changed) { renderStatus(); renderHeader(); if (S.open && S.view === 'incident') render(); }
            }
            refreshControl();
            if (S.view === 'incident') refreshIncidentHeader();
            break;
        }
        case 'incident':
            S.incidents[d.id] = d;
            if (d.status === 'closed' && S.me.incident === d.id) { S.me.incident = null; toast('Incident closed', `${d.ref} has been closed by ${S.cfg.branding.controlName}.`, 'info'); if (S.view === 'incident') render(); }
            renderHeader(); refreshControl();
            if (S.view === 'incident') { if (!myIncident() && S.open) render(); else refreshIncidentHeader(); }
            break;
        case 'log':
            if (S.logs[d.incident_id]) { S.logs[d.incident_id].push(d); refreshLog(); }
            if (S.me.incident === d.incident_id && (d.kind === 'risk')) toast('Risk information', d.text, 'warn');
            break;
        case 'hydrant': S.hydrants[d.id] = d; if (S.view === 'hydrants') render(); if (S.view === 'incident') refreshWater(); break;
        case 'hydrantDelete': delete S.hydrants[d]; closeModal(); if (S.view === 'hydrants') render(); break;
        case 'risk': S.risks[d.id] = d; if (S.view === 'risks') render(); break;
        case 'riskDelete': delete S.risks[d]; closeModal(); if (S.view === 'risks') render(); break;
        case 'sop': S.sops[d.id] = d; if (S.view === 'sops') render(); break;
        case 'sopDelete': delete S.sops[d]; closeModal(); if (S.view === 'sops') render(); break;
        case 'message':
            S.messages.push(d);
            if (!(S.open && S.view === 'messages')) S.unread++;
            renderHeader();
            if (S.open) toast(d.from, d.text, 'info');
            if (S.view === 'messages' && S.open) render();
            tone([[1200, .1], [1200, .1]]);
            break;
        case 'priority':
            toast(`Priority: ${d.callsign}`, `${d.name} has sent status 0.`, 'error');
            tone([[1400, .25], [900, .25], [1400, .25], [900, .25], [1400, .25]]);
            break;
    }
}

function showMobilise(inc) {
    S.incidents[inc.id] = inc;
    S.pendingAck = inc.id;
    $('#mobType').textContent = inc.type;
    $('#mobLoc').textContent = inc.location;
    $('#mobMeta').textContent = `${inc.ref} - ${inc.priority}${inc.risks?.length ? ' - RISK INFORMATION ON FILE' : ''}`;
    $('#mobilise').classList.remove('hidden');
    tone();
    if (!S.open) setTimeout(() => { if (!S.open) $('#mobilise').classList.add('hidden'); }, 25000);
}

/* ── NUI messages ────────────────────────── */
window.addEventListener('message', e => {
    const m = e.data || {};
    switch (m.action) {
        case 'config':
            S.cfg = m.data;
            $('#brandName').textContent = S.cfg.branding.serviceName;
            if (S.cfg.branding.logo) { $('#brandLogo').src = S.cfg.branding.logo; $('#brandLogo').classList.remove('hidden'); }
            $('#controlTab').textContent = S.cfg.branding.controlName;
            break;
        case 'open': {
            const d = m.data;
            S.perms = d.perms || {};
            S.serverId = d.serverId;
            S.units = d.units || [];
            S.incidents = {}; (d.incidents || []).forEach(i => S.incidents[i.id] = i);
            S.hydrants = {}; (d.hydrants || []).forEach(h => S.hydrants[h.id] = h);
            S.risks = {}; (d.risks || []).forEach(r => S.risks[r.id] = r);
            S.sops = {}; (d.sops || []).forEach(s => S.sops[s.id] = s);
            if (d.me) { S.me.callsign = d.me.callsign; S.me.status = d.me.status; S.me.incident = d.me.incident; }
            S.open = true;
            document.body.classList.add('mdt-open');
            $('#shell').classList.remove('hidden');
            fit(); renderHeader(); renderStatus(); render();
            if (!S.me.callsign) signOnModal();
            break;
        }
        case 'close':
            S.open = false; stopMap(); closeModal();
            document.body.classList.remove('mdt-open');
            $('#shell').classList.add('hidden');
            break;
        case 'me':
            Object.assign(S.me, m.data);
            break;
        case 'sync': onSync(m.kind, m.data); break;
        case 'mobilise': showMobilise(m.data); break;
    }
});

document.addEventListener('keydown', e => {
    if (e.key !== 'Escape' || !S.open) return;
    if (!$('#modal').classList.contains('hidden')) return closeModal();
    post('close');
});
