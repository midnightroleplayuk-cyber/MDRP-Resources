/* Dispatcher console. Shares esc(), ago(), locationLine() and friends with app.js. */
const con = {
    alerts: new Map(),   // id -> alert (nui format) + receivedAt
    units: [],
    services: [],
    filter: new Set(),
    selected: null,
    author: 'Control',
    outcomes: [],
    priorities: [],
    fresh: new Set(),    // ids that arrived while open (highlighted until selected)
    pendingSelect: null,
    radio: false,        // vinewood_radio running
    map: null,           // { image, size, bounds }
    call: null,          // { state, label, target, startedAt }
};
window.VD_CONSOLE_OPEN = false;

const $c = (id) => document.getElementById(id);
const conEl = $c('console');

async function conAction(name, data = {}) {
    try {
        const res = await fetch(`https://${RESOURCE}/consoleAction`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ action: name, data }),
        });
        return await res.json();
    } catch {
        return { ok: false, err: 'No response from the game.' };
    }
}

let toastTimer;
function conToast(text, bad = false) {
    const el = $c('conToast');
    el.textContent = text;
    el.classList.toggle('bad', bad);
    el.classList.remove('hidden');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => el.classList.add('hidden'), 3500);
}

function stamp(a, previous) {
    a.receivedAt = previous ? previous.receivedAt : Date.now() - (a.age || 0) * 1000;
    return a;
}
const ageOf = (a) => Math.max(0, (Date.now() - a.receivedAt) / 1000);

function visibleAlerts() {
    return [...con.alerts.values()]
        .filter((a) => (a.services || []).some((s) => con.filter.has(s.key)))
        .sort((x, y) => (x.priority - y.priority) || (y.receivedAt - x.receivedAt));
}

const unitById = (src) => con.units.find((u) => u.src === src);

/* ---------- Filters ---------- */

function renderFilters() {
    $c('conFilters').innerHTML = con.services.map((s) => `
        <button type="button" class="chip" aria-pressed="${con.filter.has(s.key)}" data-svc="${esc(s.key)}" style="--c:${esc(s.colour)}">
            ${esc(s.label)}
        </button>`).join('');
}

$c('conFilters').addEventListener('click', (e) => {
    const b = e.target.closest('[data-svc]');
    if (!b) return;
    const key = b.dataset.svc;
    if (con.filter.has(key) && con.filter.size > 1) con.filter.delete(key); else con.filter.add(key);
    renderFilters();
    renderCalls();
    renderUnits();
});

/* ---------- Calls list ---------- */

function renderCalls() {
    const list = visibleAlerts();
    $c('conCount').textContent = list.length;
    $c('conCalls').innerHTML = list.length ? list.map((a) => {
        const svc = a.services?.[0]?.colour || '#1b3f9a';
        const loc = a.location && (a.location.street || a.location.zone) ? esc(a.location.street || a.location.zone) : 'Locating…';
        const units = a.attachedUnits?.length || 0;
        return `
        <li>
            <button type="button" class="call-row ${con.selected === a.id ? 'selected' : ''} ${con.fresh.has(a.id) ? 'fresh' : ''}" data-id="${a.id}">
                <span class="strip" style="--svc:${esc(svc)}"></span>
                <span class="row-main">
                    <span class="row-top"><span class="ref">#${a.id}</span>
                        <span class="pill grade-${Number(a.priority) || 2}">${esc(a.grade)}</span>
                        <span class="spacer"></span><span class="when">${ago(ageOf(a))}</span></span>
                    <span class="row-title">${esc(a.title)}</span>
                    <span class="row-sub">${loc}</span>
                    <span class="row-units ${units ? 'has' : ''}">${units ? `${units} attached: ${a.attachedUnits.map((u) => esc(u.label)).join(', ')}` : 'No units attached'}</span>
                </span>
            </button>
        </li>`;
    }).join('') : '<li class="empty">No open calls.</li>';
}

$c('conCalls').addEventListener('click', (e) => {
    const b = e.target.closest('[data-id]');
    if (!b) return;
    select(Number(b.dataset.id));
});

function select(id) {
    con.selected = id;
    con.fresh.delete(id);
    renderCalls();
    renderDetail(true);
    renderUnits();
}

/* ---------- Detail ---------- */

function eligibleUnits(a) {
    const keys = (a.services || []).map((s) => s.key);
    const attached = new Set((a.attachedUnits || []).map((u) => u.src));
    return con.units.filter((u) => keys.includes(u.service) && !attached.has(u.src));
}

function unitStatus(u) {
    if (u.panic) return { text: 'Panic', cls: 'panic' };
    if (u.calls && u.calls.length) return { text: `On #${u.calls.join(', #')}`, cls: 'busy' };
    return { text: 'Available', cls: 'free' };
}

function renderDetail(reset = false) {
    const box = $c('conDetail');
    const a = con.alerts.get(con.selected);

    // don't redraw under an open dropdown
    if (!reset && document.activeElement?.tagName === 'SELECT' && box.contains(document.activeElement)) return;

    // keep anything the dispatcher was typing or had picked
    const assignPick = !reset && box.querySelector('#detAssign') ? box.querySelector('#detAssign').value : null;
    const note = box.querySelector('#detNote');
    const draft = !reset && note ? note.value : '';
    const typing = !reset && note && document.activeElement === note;
    const closeOpen = !reset && box.querySelector('#detClose:not([hidden])');
    const outcomeDraft = closeOpen ? box.querySelector('#detOutcome').value : '';

    if (!a) {
        box.innerHTML = `<div class="det-empty"><p>Select a call to see its details.</p>
            <button type="button" class="btn primary" data-act="new">Create a new call</button></div>`;
        return;
    }

    const svcPills = (a.services || []).map((s) => `<span class="pill svc" style="--c:${esc(s.colour)}">${esc(s.label)}</span>`).join('');
    const facts = [];
    const unit = unitLine(a.unit);
    if (unit) facts.push(['Unit', unit]);
    facts.push(['Location', locationLine(a.location)]);
    const vehicle = vehicleLine(a);
    if (vehicle) facts.push(['Vehicle', vehicle]);
    if (a.weapon) facts.push(['Weapon', esc(a.weapon)]);
    const caller = callerLine(a.caller);
    if (caller) facts.push(['Caller', caller]);

    const attached = (a.attachedUnits || []).map((u) => `
        <li class="att"><span class="dot" style="--c:${esc((con.services.find((s) => s.key === u.service) || {}).colour || '#888')}"></span>
            <b>${esc(u.label)}</b>
            <button type="button" class="btn tiny" data-standdown="${u.src}">Stand down</button></li>`).join('');

    const eligible = eligibleUnits(a);
    const assignOptions = eligible.map((u) => {
        const st = unitStatus(u);
        return `<option value="${u.src}">${esc(u.label)} (${esc(u.serviceLabel)}, ${esc(st.text.toLowerCase())}, ${esc(u.distance)})</option>`;
    }).join('');

    const notes = (a.notes || []).map((n) => `<li><span class="who">${esc(n.author)}</span> ${esc(n.text)} <span class="sub">${ago(n.age || 0)}</span></li>`).join('');

    box.innerHTML = `
        <div class="det-head">
            <div class="meta"><span class="ref">#${a.id}</span>${svcPills}<span class="spacer"></span><span class="when">${ago(ageOf(a))}</span></div>
            <div class="det-tools">
                <label class="grade-pick">Grade
                    <select id="detGrade">${con.priorities.map((p) => `<option value="${p.value}" ${p.value === a.priority ? 'selected' : ''}>${esc(p.label)}</option>`).join('')}</select>
                </label>
                ${con.map ? '<button type="button" class="btn" data-act="relocate">Change location</button>' : ''}
                <button type="button" class="btn" data-act="waypoint">Set waypoint</button>
                <button type="button" class="btn danger" data-act="close">Close call</button>
            </div>
        </div>
        <h2 class="det-title">${esc(a.title)}</h2>
        ${a.description ? `<p class="desc">${esc(a.description)}</p>` : ''}
        <dl class="facts">${facts.map(([k, v]) => `<dt>${k}</dt><dd>${v}</dd>`).join('')}</dl>

        <div id="detClose" class="det-close" hidden>
            <h3>Close call #${a.id}</h3>
            <div class="outcomes">${con.outcomes.map((o) => `<button type="button" class="chip" data-outcome="${esc(o)}">${esc(o)}</button>`).join('')}</div>
            <div class="row">
                <input id="detOutcome" maxlength="120" placeholder="Outcome" aria-label="Outcome">
                <button type="button" class="btn danger" data-act="confirmClose">Close call</button>
                <button type="button" class="btn" data-act="cancelClose">Cancel</button>
            </div>
        </div>

        <div class="det-section">
            <h3>Attached units</h3>
            ${attached ? `<ul class="att-list">${attached}</ul>` : '<p class="sub">No units attached.</p>'}
            ${con.radio && (a.attachedUnits || []).some((u) => unitById(u.src)?.radio)
                ? '<button type="button" class="btn tiny" data-act="moveAttached">Move attached units to a talkgroup</button>' : ''}
            <div class="row">
                ${eligible.length
                    ? `<select id="detAssign" aria-label="Unit to assign">${assignOptions}</select>
                       <button type="button" class="btn primary" data-act="assign">Assign</button>`
                    : '<p class="sub">No other units on duty for this call.</p>'}
            </div>
        </div>

        <div class="det-section">
            <h3>Updates</h3>
            ${notes ? `<ol class="notes">${notes}</ol>` : '<p class="sub">No updates yet.</p>'}
            <div class="row">
                <input id="detNote" maxlength="200" placeholder="Update as ${esc(con.author)}" aria-label="Update for call ${a.id}">
                <button type="button" class="btn" data-act="note">Post update</button>
            </div>
        </div>`;

    const assignEl = box.querySelector('#detAssign');
    if (assignEl && assignPick && [...assignEl.options].some((o) => o.value === assignPick)) assignEl.value = assignPick;
    const input = box.querySelector('#detNote');
    input.value = draft;
    if (typing) input.focus();
    if (closeOpen) {
        box.querySelector('#detClose').hidden = false;
        box.querySelector('#detOutcome').value = outcomeDraft;
    }
}

async function postNote() {
    const input = $c('detNote');
    const text = input.value.trim();
    if (!text) { input.focus(); return; }
    const r = await conAction('note', { id: con.selected, text });
    if (!r.ok) return conToast(r.err || 'Update not posted.', true);
    input.value = '';
}

$c('conDetail').addEventListener('click', async (e) => {
    const standDown = e.target.closest('[data-standdown]');
    if (standDown) {
        const r = await conAction('unassign', { id: con.selected, unit: Number(standDown.dataset.standdown) });
        return r.ok ? conToast('Unit stood down.') : conToast(r.err, true);
    }
    const outcome = e.target.closest('[data-outcome]');
    if (outcome) { $c('detOutcome').value = outcome.dataset.outcome; return; }

    const btn = e.target.closest('[data-act]');
    if (!btn) return;
    const a = con.alerts.get(con.selected);
    switch (btn.dataset.act) {
        case 'new': return newCallModal();
        case 'waypoint':
            if (a?.coords) post('consoleWaypoint', a.coords);
            return conToast('Waypoint set.');
        case 'close':
            $c('detClose').hidden = false;
            $c('detOutcome').focus();
            return;
        case 'cancelClose':
            $c('detClose').hidden = true;
            return;
        case 'confirmClose': {
            const r = await conAction('close', { id: con.selected, outcome: $c('detOutcome').value.trim() });
            return r.ok ? conToast(`Call #${a.id} closed.`) : conToast(r.err, true);
        }
        case 'assign': {
            const unit = Number($c('detAssign').value);
            const r = await conAction('assign', { id: con.selected, unit });
            return r.ok ? conToast(`${unitById(unit)?.label || 'Unit'} assigned.`) : conToast(r.err, true);
        }
        case 'note': return postNote();
        case 'relocate':
            return openMapPicker({
                title: `Move call #${a.id}: ${a.title}`,
                initial: a.coords,
                confirm: 'Move call here',
                onPick: async (coords) => {
                    const r = await conAction('relocate', { id: a.id, coords });
                    if (!r.ok) { conToast(r.err, true); return false; }
                    conToast(`Call #${a.id} moved. Attached units have a new waypoint.`);
                    return true;
                },
            });
        case 'moveAttached':
            return talkgroupPicker((a.attachedUnits || []).map((u) => u.src).filter((s) => unitById(s)?.radio));
    }
});

/* ---------- Radio: talkgroup picker + call bar ---------- */

async function talkgroupPicker(units) {
    if (!units.length) return conToast('None of those units have a radio on.', true);
    const r = await conAction('radioGroups', { units });
    if (!r.ok) return conToast(r.err, true);
    const names = units.map((s) => unitById(s)?.label || 'unit');
    const current = units.length === 1 ? unitById(units[0])?.radio?.tg : null;
    const folders = [];
    for (const g of r.groups) {
        let f = folders.find((x) => x.label === g.folder);
        if (!f) folders.push(f = { label: g.folder, groups: [] });
        f.groups.push(g);
    }
    const m = $c('conModal');
    m.innerHTML = `
        <div class="con-form tg-picker" role="dialog" aria-labelledby="tgTitle">
            <h2 id="tgTitle">Move ${esc(names.length === 1 ? names[0] : `${names.length} units`)}</h2>
            ${names.length > 1 ? `<p class="sub">${esc(names.join(', '))}</p>` : ''}
            ${folders.length ? folders.map((f) => `
                <h3>${esc(f.label)}</h3>
                <div class="tg-grid">${f.groups.map((g) => `
                    <button type="button" class="tg ${g.id === current ? 'current' : ''}" data-tg="${esc(g.id)}" ${g.id === current ? 'aria-current="true"' : ''}>
                        ${esc(g.name)}${g.id === current ? '<span class="sub">Current</span>' : ''}</button>`).join('')}
                </div>`).join('') : '<p class="sub">No talkgroup is open to all of these units.</p>'}
            <div class="row end"><button type="button" class="btn" data-tgcancel>Cancel</button></div>
        </div>`;
    m.classList.remove('hidden');
    m.querySelector('[data-tgcancel]').addEventListener('click', closeConModal);
    m.querySelectorAll('[data-tg]').forEach((b) => b.addEventListener('click', async () => {
        const res = await conAction('setTalkgroup', { units, tg: b.dataset.tg });
        closeConModal();
        if (!res.ok) return conToast(res.err, true);
        const tgName = r.groups.find((g) => g.id === b.dataset.tg)?.name || 'talkgroup';
        conToast(res.failed?.length
            ? `Moved ${res.moved} to ${tgName}. ${res.failed.join('. ')}`
            : `${names.length === 1 ? names[0] : `${res.moved} units`} moved to ${tgName}.`, !!res.failed?.length);
    }));
    m.querySelector('[data-tg]')?.focus();
}

const CALL_END = { no_answer: 'No answer', rejected: 'Call rejected', unavailable: 'Unit unavailable', ended: 'Call ended' };
const mmss = (s) => `${Math.floor(s / 60)}:${String(Math.floor(s % 60)).padStart(2, '0')}`;

function renderCallBar() {
    const bar = $c('conCallBar');
    const c = con.call;
    if (!c) { bar.classList.add('hidden'); bar.innerHTML = ''; return; }
    bar.classList.remove('hidden');
    bar.classList.toggle('active', c.state === 'active');
    bar.innerHTML = c.state === 'active'
        ? `<span class="call-dot" aria-hidden="true"></span><span><b>On call with ${esc(c.label)}</b> <span class="call-time">${mmss((Date.now() - c.startedAt) / 1000)}</span><br><span class="sub">Just talk, no push-to-talk needed</span></span>
           <button type="button" class="btn danger tiny" data-hangup>Hang up</button>`
        : `<span class="call-dot ringing" aria-hidden="true"></span><span><b>Calling ${esc(c.label)}…</b></span>
           <button type="button" class="btn tiny" data-hangup>Cancel</button>`;
}

$c('conCallBar').addEventListener('click', async (e) => {
    if (!e.target.closest('[data-hangup]')) return;
    await conAction('radioHangup');
});

setInterval(() => {
    if (window.VD_CONSOLE_OPEN && con.call?.state === 'active') {
        const t = $c('conCallBar').querySelector('.call-time');
        if (t) t.textContent = mmss((Date.now() - con.call.startedAt) / 1000);
    }
}, 1000);

$c('conDetail').addEventListener('change', async (e) => {
    if (e.target.id !== 'detGrade') return;
    const r = await conAction('grade', { id: con.selected, priority: Number(e.target.value) });
    if (!r.ok) conToast(r.err, true);
});

$c('conDetail').addEventListener('keydown', (e) => {
    if (e.key !== 'Enter') return;
    if (e.target.id === 'detNote') { e.preventDefault(); postNote(); }
    if (e.target.id === 'detOutcome') { e.preventDefault(); $c('conDetail').querySelector('[data-act="confirmClose"]').click(); }
});

/* ---------- Units ---------- */

function renderUnits() {
    const units = con.units.filter((u) => con.filter.has(u.service));
    $c('conUnitCount').textContent = units.length;
    const a = con.alerts.get(con.selected);
    const canAssign = new Set(a ? eligibleUnits(a).map((u) => u.src) : []);

    const groups = con.services.filter((s) => con.filter.has(s.key)).map((s) => {
        const list = units.filter((u) => u.service === s.key);
        if (!list.length) return '';
        return `<h3 class="grp" style="--c:${esc(s.colour)}">${esc(s.label)} <span class="count">${list.length}</span></h3>
            <ul class="unit-list">${list.map((u) => {
                const st = unitStatus(u);
                return `<li class="unit">
                    <div class="u-top"><b>${esc(u.label)}</b>${u.callsign ? ` <span class="sub">${esc(u.name)}</span>` : ''}
                        <span class="spacer"></span><span class="status ${st.cls}">${esc(st.text)}</span></div>
                    <div class="u-sub">${esc(u.location || 'Unknown')}, ${esc(u.distance)}. ${esc(u.vehicle)}${u.lights ? ', lights on' : ''}</div>
                    ${con.radio ? `<div class="u-radio">${u.radio
                        ? `Radio <b>${esc(u.radio.talkgroup || 'No talkgroup')}</b> <span class="sub">ISSI ${esc(u.radio.issi)}</span>${u.radio.inCall ? ' <span class="status busy">In call</span>' : ''}`
                        : '<span class="sub">Radio off</span>'}</div>` : ''}
                    <div class="u-actions">
                        ${canAssign.has(u.src) ? `<button type="button" class="btn tiny primary" data-uassign="${u.src}">Assign to #${a.id}</button>` : ''}
                        ${u.calls.length ? `<button type="button" class="btn tiny" data-ucall="${u.calls[0]}">View #${u.calls[0]}</button>` : ''}
                        ${con.radio && u.radio ? `<button type="button" class="btn tiny" data-ucallunit="${u.src}" ${con.call || u.radio.inCall ? 'disabled' : ''}>Call</button>
                        <button type="button" class="btn tiny" data-uchan="${u.src}">Channel</button>` : ''}
                        <button type="button" class="btn tiny" data-uwp="${u.src}">Waypoint</button>
                    </div>
                </li>`;
            }).join('')}</ul>`;
    }).join('');
    $c('conUnits').innerHTML = groups || '<p class="empty">No units on duty.</p>';
}

$c('conUnits').addEventListener('click', async (e) => {
    const assign = e.target.closest('[data-uassign]');
    if (assign) {
        const unit = Number(assign.dataset.uassign);
        const r = await conAction('assign', { id: con.selected, unit });
        return r.ok ? conToast(`${unitById(unit)?.label || 'Unit'} assigned.`) : conToast(r.err, true);
    }
    const callUnit = e.target.closest('[data-ucallunit]');
    if (callUnit) {
        const unit = Number(callUnit.dataset.ucallunit);
        const r = await conAction('radioCall', { unit });
        if (!r.ok) return conToast(r.err, true);
        con.call = { state: 'ringing', label: unitById(unit)?.label || 'unit', target: unit };
        renderCallBar();
        renderUnits();
        return;
    }
    const chan = e.target.closest('[data-uchan]');
    if (chan) return talkgroupPicker([Number(chan.dataset.uchan)]);
    const view = e.target.closest('[data-ucall]');
    if (view) return select(Number(view.dataset.ucall));
    const wp = e.target.closest('[data-uwp]');
    if (wp) {
        const u = unitById(Number(wp.dataset.uwp));
        if (u) { post('consoleWaypoint', u.coords); conToast(`Waypoint set to ${u.label}.`); }
    }
});

/* ---------- New call ---------- */

function closeConModal() {
    $c('conModal').classList.add('hidden');
    $c('conModal').innerHTML = '';
}

function newCallModal() {
    const m = $c('conModal');
    m.innerHTML = `
        <form class="con-form" id="ncForm" novalidate>
            <h2>New call</h2>
            <label for="ncTitle">Title</label>
            <input id="ncTitle" maxlength="64" required placeholder="e.g. Concern for welfare">
            <label for="ncDesc">Details</label>
            <textarea id="ncDesc" maxlength="300" rows="3" placeholder="What has been reported"></textarea>
            <div class="two">
                <div><label for="ncGrade">Grade</label>
                    <select id="ncGrade">${con.priorities.map((p) => `<option value="${p.value}" ${p.value === 2 ? 'selected' : ''}>${esc(p.label)}</option>`).join('')}</select></div>
                <div><label for="ncCaller">Caller (optional)</label><input id="ncCaller" maxlength="48" placeholder="Name or number"></div>
            </div>
            <fieldset><legend>Services</legend>
                ${con.services.map((s) => `<label class="check"><input type="checkbox" value="${esc(s.key)}" ${con.filter.has(s.key) && con.filter.size === 1 ? 'checked' : ''}> ${esc(s.label)}</label>`).join('')}
            </fieldset>
            <fieldset class="where"><legend>Location</legend>
                ${con.map ? `<label class="check"><input type="radio" name="ncWhere" value="map" checked> Pick on map</label>` : ''}
                <label class="check"><input type="radio" name="ncWhere" value="waypoint" ${con.map ? '' : 'checked'}> My map waypoint</label>
                <label class="check"><input type="radio" name="ncWhere" value="self"> My position</label>
            </fieldset>
            ${con.map ? `<div class="picked"><span id="ncPicked" class="sub">No location picked yet</span>
                <button type="button" class="btn tiny" data-nc="map">Open map</button></div>` : ''}
            <p id="ncErr" class="err" role="alert"></p>
            <div class="row end">
                <button type="button" class="btn" data-nc="cancel">Cancel</button>
                <button type="submit" class="btn primary">Create call</button>
            </div>
        </form>`;
    m.classList.remove('hidden');
    $c('ncTitle').focus();

    m.querySelector('[data-nc="cancel"]').addEventListener('click', closeConModal);
    let picked = null;
    const openPicker = () => openMapPicker({
        title: 'Pick a location for the new call',
        initial: picked,
        confirm: 'Use this location',
        onPick: (coords, where) => {
            picked = coords;
            $c('ncPicked').textContent = where || 'Location picked';
            $c('ncPicked').classList.remove('sub');
            m.querySelector('input[name="ncWhere"][value="map"]').checked = true;
            return true;
        },
    });
    m.querySelector('[data-nc="map"]')?.addEventListener('click', openPicker);
    m.querySelector('input[name="ncWhere"][value="map"]')?.addEventListener('change', () => { if (!picked) openPicker(); });
    $c('ncForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const services = [...m.querySelectorAll('fieldset input[type="checkbox"]:checked')].map((i) => i.value);
        const data = {
            title: $c('ncTitle').value.trim(),
            description: $c('ncDesc').value.trim(),
            priority: Number($c('ncGrade').value),
            caller: $c('ncCaller').value.trim(),
            services,
            where: m.querySelector('input[name="ncWhere"]:checked').value,
        };
        if (data.where === 'map') {
            if (!picked) { $c('ncErr').textContent = 'Pick a location on the map.'; return openPicker(); }
            data.coords = picked;
        }
        const err = $c('ncErr');
        if (!data.title) { err.textContent = 'Give the call a title.'; $c('ncTitle').focus(); return; }
        if (!services.length) { err.textContent = 'Choose at least one service.'; return; }
        const r = await conAction('create', data);
        if (!r.ok) { err.textContent = r.err || 'The call could not be created.'; return; }
        con.pendingSelect = r.id;
        closeConModal();
        conToast(`Call #${r.id} created.`);
    });
}

$c('conNew').addEventListener('click', newCallModal);

/* ---------- Open / close ---------- */

function hideConsole() {
    conEl.classList.add('hidden');
    window.VD_CONSOLE_OPEN = false;
    closeConModal();
}

$c('conHide').addEventListener('click', () => { hideConsole(); post('consoleClose'); });
$c('conLogout').addEventListener('click', () => { hideConsole(); post('consoleLogout'); });

document.addEventListener('keydown', (e) => {
    if (!window.VD_CONSOLE_OPEN) return;
    if (e.key === 'Escape') {
        if (!$c('conMap').classList.contains('hidden')) return closeMapPicker();
        if (!$c('conModal').classList.contains('hidden')) return closeConModal();
        hideConsole();
        post('consoleClose');
        return;
    }
    const typing = ['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement?.tagName);
    if (typing || !['ArrowUp', 'ArrowDown'].includes(e.key)) return;
    e.preventDefault();
    const list = visibleAlerts();
    if (!list.length) return;
    const i = list.findIndex((a) => a.id === con.selected);
    const next = e.key === 'ArrowDown' ? Math.min(list.length - 1, i + 1) : Math.max(0, i - 1);
    select(list[i === -1 ? 0 : next].id);
});

setInterval(() => {
    if (!window.VD_CONSOLE_OPEN) return;
    renderCalls();
    const when = $c('conDetail').querySelector('.det-head .when');
    const a = con.alerts.get(con.selected);
    if (when && a) when.textContent = ago(ageOf(a));
}, 20000);

window.addEventListener('message', ({ data }) => {
    switch (data.action) {
        case 'consoleOpen': {
            con.alerts = new Map((data.alerts || []).map((a) => [a.id, stamp(a)]));
            con.units = data.units || [];
            con.services = data.services || [];
            if (!con.filter.size) con.services.forEach((s) => con.filter.add(s.key));
            con.author = data.author || 'Control';
            con.outcomes = data.outcomes || [];
            con.priorities = data.priorities || [];
            con.radio = !!data.radio;
            con.map = data.map || null;
            con.call = data.call ? { ...data.call, startedAt: Date.now() - (data.call.elapsed || 0) * 1000 } : null;
            renderCallBar();
            con.fresh.clear();
            $c('conAuthor').textContent = `Signed in as ${con.author}`;
            if (con.selected && !con.alerts.has(con.selected)) con.selected = null;
            if (!con.selected) con.selected = visibleAlerts()[0]?.id ?? null;
            renderFilters();
            renderCalls();
            renderDetail(true);
            renderUnits();
            conEl.classList.remove('hidden');
            window.VD_CONSOLE_OPEN = true;
            // the console replaces the pop-up feed while it's open
            for (const id of [...live.keys()]) dismiss(id);
            break;
        }
        case 'consoleClose':
            hideConsole();
            break;
        case 'consoleAlert': {
            const a = data.alert;
            const prev = con.alerts.get(a.id);
            con.alerts.set(a.id, stamp(a, prev));
            if (data.isNew && !prev) con.fresh.add(a.id);
            if (con.pendingSelect === a.id) { con.pendingSelect = null; select(a.id); break; }
            if (!con.selected) con.selected = a.id;
            renderCalls();
            if (con.selected === a.id) renderDetail();
            renderUnits();
            break;
        }
        case 'consoleRemove':
            con.alerts.delete(data.id);
            con.fresh.delete(data.id);
            if (con.selected === data.id) {
                con.selected = visibleAlerts()[0]?.id ?? null;
                renderDetail(true);
            }
            renderCalls();
            renderUnits();
            break;
        case 'consoleCall': {
            const c = data.call;
            if (c.state === 'ended') {
                conToast(`${c.label}: ${CALL_END[c.reason] || 'Call ended'}`, c.reason !== 'ended');
                con.call = null;
            } else {
                con.call = { ...(con.call || {}), state: c.state, label: c.label, target: c.target };
                if (c.state === 'active') { con.call.startedAt = Date.now(); conToast(`Connected to ${c.label}.`); }
            }
            renderCallBar();
            renderUnits();
            break;
        }
        case 'consoleUnits':
            con.units = data.units || [];
            renderUnits();
            // refresh the assign list without losing what's being typed
            if (con.selected) renderDetail();
            break;
    }
});


/* ---------- Map picker ---------- */

const mapState = { scale: 1, tx: 0, ty: 0, fit: 1, pin: null, opts: null, resolveSeq: 0 };

function worldToPx(x, y) {
    const { size, bounds: b } = con.map;
    return { px: (x - b.left) / (b.right - b.left) * size, py: (b.top - y) / (b.top - b.bottom) * size };
}
function pxToWorld(px, py) {
    const { size, bounds: b } = con.map;
    return { x: b.left + px / size * (b.right - b.left), y: b.top - py / size * (b.top - b.bottom) };
}

function closeMapPicker() {
    const el = $c('conMap');
    el.classList.add('hidden');
    el.innerHTML = '';
    mapState.opts = null;
}

function applyMapTransform() {
    const layer = $c('mapLayer');
    if (!layer) return;
    layer.style.transform = `translate(${mapState.tx}px, ${mapState.ty}px) scale(${mapState.scale})`;
    layer.style.setProperty('--inv', 1 / mapState.scale);
}

function clampMap() {
    const view = $c('mapView').getBoundingClientRect();
    const w = con.map.size * mapState.scale;
    // keep at least a third of the view covered by map
    const minX = view.width / 3 - w, maxX = view.width * 2 / 3;
    const minY = view.height / 3 - w, maxY = view.height * 2 / 3;
    mapState.tx = Math.min(maxX, Math.max(minX, mapState.tx));
    mapState.ty = Math.min(maxY, Math.max(minY, mapState.ty));
}

function zoomAt(factor, cx, cy) {
    const next = Math.min(mapState.fit * 10, Math.max(mapState.fit, mapState.scale * factor));
    mapState.tx = cx - (cx - mapState.tx) * (next / mapState.scale);
    mapState.ty = cy - (cy - mapState.ty) * (next / mapState.scale);
    mapState.scale = next;
    clampMap();
    applyMapTransform();
}

function centreOn(px, py, scale) {
    const view = $c('mapView').getBoundingClientRect();
    mapState.scale = scale;
    mapState.tx = view.width / 2 - px * scale;
    mapState.ty = view.height / 2 - py * scale;
    clampMap();
    applyMapTransform();
}

async function placePin(px, py) {
    const world = pxToWorld(px, py);
    mapState.pin = world;
    const pin = $c('mapPin');
    pin.style.left = `${px}px`;
    pin.style.top = `${py}px`;
    pin.classList.remove('hidden');
    const where = $c('mapWhere');
    where.innerHTML = `<b>Finding street…</b> <span class="sub">${Math.round(world.x)}, ${Math.round(world.y)}</span>`;
    $c('mapUse').disabled = false;

    const seq = ++mapState.resolveSeq;
    let loc = {};
    try {
        const res = await fetch(`https://${RESOURCE}/consoleResolve`, {
            method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(world),
        });
        loc = await res.json();
    } catch { /* preview in a browser */ }
    if (seq !== mapState.resolveSeq || !$c('mapWhere')) return;
    const road = [loc.street, loc.cross].filter(Boolean).join(' / ');
    mapState.pinLabel = [road, loc.zone].filter(Boolean).join(', ') || 'Unknown location';
    where.innerHTML = `<b>${esc(mapState.pinLabel)}</b> <span class="sub">${Math.round(world.x)}, ${Math.round(world.y)}</span>`;
}

function mapMarkers() {
    const out = [];
    for (const a of con.alerts.values()) {
        if (!a.coords) continue;
        const { px, py } = worldToPx(a.coords.x, a.coords.y);
        out.push(`<div class="mk mk-call g${Number(a.priority) || 2}" style="left:${px}px;top:${py}px" title="#${a.id} ${esc(a.title)}"><span>#${a.id}</span></div>`);
    }
    for (const u of con.units) {
        if (!u.coords) continue;
        const { px, py } = worldToPx(u.coords.x, u.coords.y);
        out.push(`<div class="mk mk-unit ${u.panic ? 'panic' : ''}" style="left:${px}px;top:${py}px;--c:${esc(u.colour)}" title="${esc(u.label)}"><span>${esc(u.label)}</span></div>`);
    }
    return out.join('');
}

function openMapPicker(opts) {
    if (!con.map) return conToast('The map is turned off in the config.', true);
    mapState.opts = opts;
    mapState.pin = null;
    mapState.pinLabel = null;
    const el = $c('conMap');
    el.innerHTML = `
        <div class="map-panel">
            <header class="map-head">
                <div><h2 id="mapTitle">${esc(opts.title || 'Pick a location')}</h2>
                    <p class="sub">Click the map to place the pin. Scroll to zoom, drag to move around.</p></div>
                <div class="map-legend"><span class="mk-key mk-call"></span>Calls <span class="mk-key mk-unit"></span>Units</div>
                <div class="map-zoom" role="group" aria-label="Zoom">
                    <button type="button" class="btn" data-zoom="in" aria-label="Zoom in">+</button>
                    <button type="button" class="btn" data-zoom="out" aria-label="Zoom out">&minus;</button>
                    <button type="button" class="btn" data-zoom="fit">Whole map</button>
                </div>
            </header>
            <div class="map-view" id="mapView">
                <div class="map-layer" id="mapLayer" style="width:${con.map.size}px;height:${con.map.size}px">
                    <img src="${esc(con.map.image)}" alt="" draggable="false" width="${con.map.size}" height="${con.map.size}">
                    ${mapMarkers()}
                    <div id="mapPin" class="map-pin hidden" aria-hidden="true"></div>
                </div>
            </div>
            <footer class="map-foot">
                <div id="mapWhere" class="map-where"><span class="sub">No location picked</span></div>
                <button type="button" class="btn" data-map="cancel">Cancel</button>
                <button type="button" class="btn primary" id="mapUse" disabled>${esc(opts.confirm || 'Use this location')}</button>
            </footer>
        </div>`;
    el.classList.remove('hidden');

    const view = $c('mapView');
    const rect = view.getBoundingClientRect();
    mapState.fit = Math.min(rect.width, rect.height) / con.map.size;
    if (opts.initial && Number.isFinite(opts.initial.x)) {
        const { px, py } = worldToPx(opts.initial.x, opts.initial.y);
        centreOn(px, py, mapState.fit * 3);
        placePin(px, py);
    } else {
        centreOn(con.map.size / 2, con.map.size / 2, mapState.fit);
    }

    view.addEventListener('wheel', (e) => {
        e.preventDefault();
        const r = view.getBoundingClientRect();
        zoomAt(e.deltaY < 0 ? 1.25 : 0.8, e.clientX - r.left, e.clientY - r.top);
    }, { passive: false });

    let drag = null;
    view.addEventListener('pointerdown', (e) => {
        drag = { x: e.clientX, y: e.clientY, tx: mapState.tx, ty: mapState.ty, moved: false };
        view.setPointerCapture(e.pointerId);
    });
    view.addEventListener('pointermove', (e) => {
        if (!drag) return;
        const dx = e.clientX - drag.x, dy = e.clientY - drag.y;
        if (!drag.moved && Math.hypot(dx, dy) < 4) return;
        drag.moved = true;
        view.classList.add('dragging');
        mapState.tx = drag.tx + dx;
        mapState.ty = drag.ty + dy;
        clampMap();
        applyMapTransform();
    });
    view.addEventListener('pointerup', (e) => {
        if (!drag) return;
        const wasDrag = drag.moved;
        drag = null;
        view.classList.remove('dragging');
        if (wasDrag) return;
        const r = view.getBoundingClientRect();
        const px = (e.clientX - r.left - mapState.tx) / mapState.scale;
        const py = (e.clientY - r.top - mapState.ty) / mapState.scale;
        if (px < 0 || py < 0 || px > con.map.size || py > con.map.size) return;
        placePin(px, py);
    });

    el.querySelector('.map-zoom').addEventListener('click', (e) => {
        const b = e.target.closest('[data-zoom]');
        if (!b) return;
        const r = view.getBoundingClientRect();
        if (b.dataset.zoom === 'fit') return centreOn(con.map.size / 2, con.map.size / 2, mapState.fit);
        zoomAt(b.dataset.zoom === 'in' ? 1.5 : 1 / 1.5, r.width / 2, r.height / 2);
    });
    el.querySelector('[data-map="cancel"]').addEventListener('click', closeMapPicker);
    $c('mapUse').addEventListener('click', async () => {
        if (!mapState.pin) return;
        const btn = $c('mapUse');
        btn.disabled = true;
        const done = await opts.onPick({ x: mapState.pin.x, y: mapState.pin.y }, mapState.pinLabel);
        if (done !== false) closeMapPicker(); else btn.disabled = false;
    });
    $c('mapUse').focus();
}
