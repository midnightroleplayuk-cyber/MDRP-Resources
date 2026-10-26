const RESOURCE = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'vinewood-dispatch';

const feed = document.getElementById('feed');
const historyEl = document.getElementById('history');
const log = document.getElementById('log');
const muteBox = document.getElementById('mute');

const cfg = {
    position: 'top-right', duration: 30, max: 4, respondKey: 'Y', dismissKey: 'DELETE',
    historyKey: 'F9', sticky: [1], showMissed: true, muted: false,
};
let missed = 0;
const missedEl = document.createElement('div');
missedEl.className = 'missed hidden';
missedEl.setAttribute('role', 'status');

function renderMissed() {
    if (!cfg.showMissed || missed === 0) { missedEl.classList.add('hidden'); return; }
    missedEl.innerHTML = `<b>${missed}</b> missed ${missed === 1 ? 'call' : 'calls'}<span class="sub">Press <kbd>${esc(keyLabel(cfg.historyKey))}</kbd> for the log</span>`;
    missedEl.classList.remove('hidden');
}
const KEY_LABELS = { DELETE: 'Del', BACK: 'Backspace', RETURN: 'Enter', PAGEUP: 'PgUp', PAGEDOWN: 'PgDn' };
const keyLabel = (k) => KEY_LABELS[String(k || '').toUpperCase()] || k;
const isSticky = (a) => (cfg.sticky || []).includes(Number(a.priority));
const live = new Map();   // id -> { el, alert, timeout, shownAt }
let logAlerts = [];

const esc = (value) => String(value ?? '').replace(/[&<>"']/g, (c) => (
    { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]
));

function post(name, data = {}) {
    return fetch(`https://${RESOURCE}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data),
    }).catch(() => {});
}

function ago(seconds) {
    if (seconds < 45) return 'just now';
    const m = Math.round(seconds / 60);
    if (m < 60) return `${m} min ago`;
    return `${Math.floor(m / 60)} hr ${m % 60} min ago`;
}

function locationLine(l) {
    if (!l || l.pending || (!l.street && !l.zone)) return '<span class="sub">Locating…</span>';
    const road = [l.street, l.cross].filter(Boolean).map(esc).join(' / ');
    const area = l.zone ? `<span class="sub">${road ? ', ' : ''}${esc(l.zone)}</span>` : '';
    const postal = l.postal ? `<span class="sub">, postal ${esc(l.postal)}</span>` : '';
    return `${road}${area}${postal}`;
}

function vehicleLine(a) {
    const v = a.vehicle;
    if (!v) return null;
    const name = [v.colour, v.make, v.model].filter(Boolean).map(esc).join(' ');
    const parts = [name || 'Unknown vehicle'];
    if (v.plate) parts.push(`plate ${esc(v.plate)}`);
    if (a.heading) parts.push(`heading ${esc(a.heading)}`);
    return parts.join(', ');
}

function callerLine(c) {
    if (!c || (!c.name && !c.phone)) return null;
    return [c.name, c.phone].filter(Boolean).map(esc).join(', ');
}

function unitLine(u) {
    if (!u || (!u.name && !u.callsign)) return null;
    return u.callsign ? `${esc(u.callsign)} <span class="sub">(${esc(u.name)})</span>` : esc(u.name);
}

function notesHTML(a) {
    const notes = a.notes || [];
    const list = notes.length
        ? `<ol class="notes">${notes.map((n) => `
            <li><span class="who">${esc(n.author)}</span> ${esc(n.text)} <span class="sub">${ago(n.age || 0)}</span></li>`).join('')}
           </ol>`
        : '';
    return `
        <div class="updates">
            ${list}
            <div class="note-form">
                <input type="text" maxlength="200" placeholder="Add an update to this call" aria-label="Update for call ${a.id}">
                <button type="button" class="btn" data-act="note">Post update</button>
            </div>
        </div>`;
}

function footer(a, mode) {
    const clear = mode === 'live' && isSticky(a) && !a.attached
        ? `<span class="hint"><kbd>${esc(keyLabel(cfg.dismissKey))}</kbd>Clear</span>` : '';
    const n = a.responders?.length || 0;
    const units = n
        ? `<span class="units has">${n} attached: ${a.responders.map(esc).join(', ')}</span>`
        : '<span class="units">No units attached</span>';

    if (mode === 'log') {
        return `
            <div class="foot">${units}
                <div class="actions">
                    <button type="button" class="btn" data-act="waypoint">Set waypoint</button>
                    <button type="button" class="btn ${a.attached ? '' : 'primary'}" data-act="respond">${a.attached ? 'Detach' : 'Attach'}</button>
                </div>
            </div>`;
    }

    const hint = a.attached
        ? '<span class="hint on">Attached</span>'
        : `<span class="hint"><kbd>${esc(keyLabel(cfg.respondKey))}</kbd>Attach</span>`;
    return `<div class="foot">${units}<span class="hints">${clear}${hint}</span></div>`;
}

function cardHTML(a, mode, age, sticky = false) {
    const svc = a.services?.[0]?.colour || '#1b3f9a';
    const pills = (a.services || [])
        .map((s) => `<span class="pill svc" style="--c:${esc(s.colour)}">${esc(s.label)}</span>`)
        .join('');

    const facts = [];
    const unit = unitLine(a.unit);
    if (unit) facts.push(['Unit', unit]);
    facts.push(['Location', locationLine(a.location)]);
    const vehicle = vehicleLine(a);
    if (vehicle) facts.push(['Vehicle', vehicle]);
    if (a.weapon) facts.push(['Weapon', esc(a.weapon)]);
    const caller = callerLine(a.caller);
    if (caller) facts.push(['Caller', caller]);
    facts.push(['Distance', esc(a.distance)]);
    const latest = a.notes?.length ? a.notes[a.notes.length - 1] : null;
    if (mode === 'live' && latest) facts.push(['Update', `<span class="who">${esc(latest.author)}</span> ${esc(latest.text)}`]);

    return `
        <div class="strip" style="--svc:${esc(svc)}"></div>
        <div class="body">
            <div class="meta">
                <span class="ref">#${esc(a.id)}</span>
                <span class="pill grade-${Number(a.priority) || 2}">${esc(a.grade)}</span>
                ${pills}
                ${a.code ? `<span class="code">${esc(a.code)}</span>` : ''}
                <span class="spacer"></span>
                <span class="when">${ago(age)}</span>
            </div>
            <h2 class="title">${esc(a.title)}</h2>
            ${a.description ? `<p class="desc">${esc(a.description)}</p>` : ''}
            <dl class="facts">${facts.map(([k, v]) => `<dt>${k}</dt><dd>${v}</dd>`).join('')}</dl>
            ${mode === 'log' ? notesHTML(a) : ''}
            ${footer(a, mode)}
        </div>
        ${mode === 'live' && !sticky ? `<div class="timer" style="--svc:${esc(svc)};animation-duration:${cfg.duration}s"></div>` : ''}`;
}

/* ---------- Live feed ---------- */

function dismiss(id, reason) {
    const entry = live.get(id);
    if (!entry) return;
    // timed out or pushed off screen without being attached: count it as missed
    if ((reason === 'timeout' || reason === 'overflow') && !entry.alert.attached) {
        missed += 1;
        renderMissed();
    }
    clearTimeout(entry.timeout);
    live.delete(id);
    entry.el.classList.add('leaving');
    entry.el.addEventListener('animationend', () => entry.el.remove(), { once: true });
    setTimeout(() => entry.el.remove(), 400);
}

function showAlert(a) {
    if (live.has(a.id)) dismiss(a.id);

    const el = document.createElement('article');
    el.className = 'card';
    el.innerHTML = cardHTML(a, 'live', a.age || 0, isSticky(a));
    feed.prepend(el);

    const entry = { el, alert: a, shownAt: Date.now(), sticky: isSticky(a) };
    if (!entry.sticky) entry.timeout = setTimeout(() => dismiss(a.id, 'timeout'), cfg.duration * 1000);
    live.set(a.id, entry);

    const ids = [...live.keys()];
    while (ids.length > cfg.max) dismiss(ids.shift(), 'overflow');
}

function updateLive(a) {
    const entry = live.get(a.id);
    if (!entry) return;
    entry.alert = a;
    const timer = entry.el.querySelector('.timer');
    const elapsed = (Date.now() - entry.shownAt) / 1000;
    entry.el.innerHTML = cardHTML(a, 'live', (a.age || 0) + elapsed, entry.sticky);
    // sticky alerts clear a few seconds after you attach
    if (entry.sticky && a.attached && !entry.timeout) entry.timeout = setTimeout(() => dismiss(a.id), 4000);
    // keep the countdown where it was
    const newTimer = entry.el.querySelector('.timer');
    if (timer && newTimer) newTimer.style.animationDelay = `-${elapsed}s`;
}

/* ---------- Log ---------- */

function renderLog() {
    if (!logAlerts.length) {
        log.innerHTML = '<li class="empty">No alerts in the last 30 minutes.</li>';
        return;
    }
    log.innerHTML = '';
    for (const a of logAlerts) {
        const li = document.createElement('li');
        li.className = 'card';
        li.dataset.id = a.id;
        li.innerHTML = cardHTML(a, 'log', a.age || 0);
        log.appendChild(li);
    }
}

function replaceLogCard(id) {
    const a = logAlerts.find((x) => x.id === id);
    const li = log.querySelector(`.card[data-id="${id}"]`);
    if (!a || !li) return;
    const input = li.querySelector('.note-form input');
    const draft = input ? input.value : '';
    const focused = input && document.activeElement === input;
    li.innerHTML = cardHTML(a, 'log', a.age || 0);
    const next = li.querySelector('.note-form input');
    if (next) {
        next.value = draft;
        if (focused) next.focus();
    }
}

function postNote(card) {
    const input = card.querySelector('.note-form input');
    const text = input.value.trim();
    if (!text) { input.focus(); return; }
    post('addNote', { id: Number(card.dataset.id), text });
    input.value = '';
}

log.addEventListener('click', (e) => {
    const btn = e.target.closest('button[data-act]');
    if (!btn) return;
    const card = btn.closest('.card');
    const id = Number(card.dataset.id);
    const a = logAlerts.find((x) => x.id === id);
    if (!a) return;
    if (btn.dataset.act === 'note') return postNote(card);
    post(btn.dataset.act, { id, coords: a.coords, unitSrc: a.unitSrc });
});

log.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && e.target.matches('.note-form input')) {
        e.preventDefault();
        postNote(e.target.closest('.card'));
    }
});

function closeHistory() {
    historyEl.classList.add('hidden');
    post('close');
}

document.getElementById('close').addEventListener('click', closeHistory);
historyEl.addEventListener('click', (e) => { if (e.target === historyEl) closeHistory(); });
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !historyEl.classList.contains('hidden')) closeHistory();
});
document.getElementById('callsign').addEventListener('click', () => {
    historyEl.classList.add('hidden');
    post('editCallsign');
});
muteBox.addEventListener('change', () => {
    cfg.muted = muteBox.checked;
    post('mute', { muted: cfg.muted });
});

/* ---------- Messages from Lua ---------- */

window.addEventListener('message', ({ data }) => {
    switch (data.action) {
        case 'config':
            Object.assign(cfg, data.config);
            feed.className = `pos-${cfg.position}`;
            if (!missedEl.isConnected) feed.append(missedEl);
            renderMissed();
            break;
        case 'dismissNewest': {
            const ids = [...live.keys()];
            if (ids.length) dismiss(ids[ids.length - 1]);
            break;
        }
        case 'newAlert':
            showAlert(data.alert);
            break;
        case 'updateAlert': {
            updateLive(data.alert);
            const i = logAlerts.findIndex((x) => x.id === data.alert.id);
            if (i !== -1) {
                logAlerts[i] = { ...data.alert, age: logAlerts[i].age };
                replaceLogCard(data.alert.id);
            }
            break;
        }
        case 'patchLog': {
            const a = logAlerts.find((x) => x.id === data.id);
            if (a) {
                if (data.responders) {
                    a.responders = data.responders;
                    a.attached = data.attached;
                }
                if (data.notes) a.notes = data.notes;
                replaceLogCard(data.id);
            }
            break;
        }
        case 'removeAlert':
            dismiss(data.id);
            logAlerts = logAlerts.filter((x) => x.id !== data.id);
            if (!historyEl.classList.contains('hidden')) renderLog();
            break;
        case 'openHistory':
            // everything on screen has now been seen
            missed = 0;
            renderMissed();
            for (const id of [...live.keys()]) dismiss(id);
            logAlerts = data.alerts || [];
            muteBox.checked = !!data.muted;
            {
                const btn = document.getElementById('callsign');
                if (data.callsign === undefined || data.callsign === null) {
                    btn.classList.add('hidden');
                } else {
                    btn.classList.remove('hidden');
                    btn.innerHTML = data.callsign
                        ? `Callsign <b>${esc(data.callsign)}</b>`
                        : 'Set your callsign';
                }
            }
            renderLog();
            historyEl.classList.remove('hidden');
            document.getElementById('close').focus();
            break;
    }
});
