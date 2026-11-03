'use strict';

const DEV = typeof GetParentResourceName !== 'function';
const RES = DEV ? 'vinewood_radio' : GetParentResourceName();
const IMG_W = 1024, IMG_H = 1536, BODY_RIGHT = 775; // radio body's right edge in the PNG

const $ = s => document.querySelector(s);
const sleep = ms => new Promise(r => setTimeout(r, ms));
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

// Hotspots in native image pixels: [centreX, centreY, width, height]
const KEYS = {
    softL: [398, 1053, 74, 56], softR: [652, 1053, 74, 56],
    up: [525, 1051, 104, 44], down: [525, 1159, 104, 44],
    left: [458, 1105, 46, 86], right: [592, 1105, 46, 86],
    green: [403, 1143, 74, 64], red: [646, 1143, 74, 64],
    1: [412, 1217, 86, 58], 2: [525, 1217, 86, 58], 3: [637, 1217, 86, 58],
    4: [412, 1287, 86, 58], 5: [525, 1287, 86, 58], 6: [637, 1287, 86, 58],
    7: [412, 1357, 86, 58], 8: [525, 1357, 86, 58], 9: [637, 1357, 86, 58],
    '*': [412, 1427, 86, 58], 0: [525, 1427, 86, 58], '#': [637, 1427, 86, 58],
    knob: [392, 462, 118, 118],
    emerg: [525, 521, 84, 30],
    ptt: [256, 795, 32, 340],
};
const HOLD_KEYS = ['red', 'knob', 'emerg'];

const S = {
    open: false,
    power: 'off',        // off | boot | on | denied | down
    boot: 0,
    denyText: '',
    data: null,          // issi, callsign, service, name, folders
    flat: [],
    tg: 0,               // displayed index
    attached: 0,         // index actually joined
    attaching: false,
    screen: 'home', stack: [], cur: 0, ctx: {},
    volume: 60,
    bright: 100,
    keyTones: true,
    speaker: false,
    me: null,
    talking: new Set(),
    listVisible: true,
    listMoving: false,
    listPos: null,      // { x, y } as fractions of the screen
    listScale: 1,
    tx: false, rx: null,
    dial: '', edit: '',
    ptp: null,           // { state: out|ringing|in|active, peer, start }
    emergency: false,
    alert: null,
    dir: [],
    toast: null,
    cfg: {
        sounds: { volume: .6, listenerClose: true, outgoingRing: true },
        ui: { scale: .78, offset: 40, hud: true },
        emergencyHold: 1000, powerHold: 1000, ptp: true, emergency: true, talkKey: 'AltLeft',
        radioList: { enabled: true, visibleByDefault: true, maxRows: 12 },
    },
};

try {
    const p = JSON.parse(localStorage.getItem('vinewood_radio:prefs') || '{}');
    if (typeof p.bright === 'number') S.bright = p.bright;
    if (typeof p.keyTones === 'boolean') S.keyTones = p.keyTones;
    if (typeof p.listVisible === 'boolean') S.listVisible = p.listVisible;
    if (p.listPos && typeof p.listPos.x === 'number') S.listPos = p.listPos;
    if (typeof p.listScale === 'number') S.listScale = p.listScale;
} catch { /* storage unavailable */ }
const savePrefs = () => { try { localStorage.setItem('vinewood_radio:prefs', JSON.stringify({ bright: S.bright, keyTones: S.keyTones, listVisible: S.listVisible, listPos: S.listPos, listScale: S.listScale })); } catch { } };

/* ---------------- Lua bridge ---------------- */
async function post(name, data = {}) {
    if (DEV) return mock(name, data);
    try {
        const r = await fetch(`https://${RES}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data),
        });
        return await r.json();
    } catch { return null; }
}

/* ---------------- Audio ---------------- */
const AUD = {};
['PTT', 'CLOSE', 'PTP'].forEach(n => { AUD[n] = new Audio(`sounds/${n}.wav`); AUD[n].preload = 'auto'; });
const level = () => clamp((S.cfg.sounds.volume ?? .6) * (S.volume / 100), 0, 1);

function play(name, loop = false) {
    const base = AUD[name];
    if (!base) return;
    const a = loop ? base : base.cloneNode();
    a.loop = loop;
    a.volume = level();
    a.currentTime = 0;
    a.play().catch(() => { });
}
function stopLoop(name) {
    const a = AUD[name];
    if (!a) return;
    a.pause(); a.loop = false; a.currentTime = 0;
}

let ac;
function beep(freqs, dur = .05, gain = .06) {
    try {
        ac = ac || new AudioContext();
        let t = ac.currentTime;
        for (const f of freqs) {
            const o = ac.createOscillator(), g = ac.createGain();
            o.type = 'square';
            o.frequency.value = f;
            g.gain.value = gain * level() * 1.6;
            o.connect(g).connect(ac.destination);
            o.start(t); o.stop(t + dur);
            t += dur;
        }
    } catch { }
}
const keyBeep = () => S.keyTones && beep([1400], .04, .05);
const emergencyTone = () => beep([988, 1319, 988, 1319, 988, 1319, 988, 1319], .2, .07);

/* ---------------- Helpers ---------------- */
let toastTimer;
function toast(msg, ms = 1800) {
    S.toast = msg;
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => { S.toast = null; render(); }, ms);
    render();
}

function go(screen, ctx = {}) {
    S.stack.push({ screen: S.screen, cur: S.cur, ctx: S.ctx });
    S.screen = screen; S.cur = 0; S.ctx = ctx;
    render();
}
function back() {
    const p = S.stack.pop();
    if (!p) return goHome();
    S.screen = p.screen; S.cur = p.cur; S.ctx = p.ctx;
    render();
}
function goHome() {
    S.stack = []; S.screen = 'home'; S.cur = 0; S.ctx = {};
    render();
}

const attachedId = () => (S.flat[S.attached] || {}).id;
function channelUnits() {
    const id = attachedId();
    if (!id) return [];
    return S.dir.filter(u => u.tg === id).sort((a, b) => a.callsign.localeCompare(b.callsign, 'en-GB', { numeric: true }));
}
const byCallsign = (a, b) => a.callsign.localeCompare(b.callsign, 'en-GB', { numeric: true });
const unitsOn = id => id === '*' ? [...S.dir].sort(byCallsign) : S.dir.filter(u => u.tg === id).sort(byCallsign);

// Talkgroups that currently have units on them: yours first, then your folders' order,
// then any others (e.g. another service's groups), then "All units".
function unitPages() {
    const mine = attachedId();
    const seen = new Set(), pages = [];
    const add = (id, name) => { if (id && !seen.has(id)) { seen.add(id); pages.push({ id, name }); } };
    add(mine, (S.flat[S.attached] || {}).name);
    S.flat.forEach(g => { if (S.dir.some(u => u.tg === g.id)) add(g.id, g.name); });
    S.dir.forEach(u => { if (u.tg) add(u.tg, u.talkgroup || u.tg); });
    pages.push({ id: '*', name: 'All units' });
    return pages;
}

const isTalking = u => (u.src === S.me && S.tx) || S.talking.has(u.src);

const peerName = p => p ? (p.callsign || p.issi) : '';
const lookup = issi => S.dir.find(u => u.issi === issi);

/* ---------------- Talkgroups ---------------- */
function flatten() {
    S.flat = [];
    (S.data.folders || []).forEach(f => f.groups.forEach(g => S.flat.push({ ...g, folder: f.label })));
}

let joinTimer;
function selectTG(idx, now = false) {
    if (!S.flat.length) return;
    S.tg = (idx + S.flat.length) % S.flat.length;
    S.attaching = S.tg !== S.attached;
    clearTimeout(joinTimer);
    render();
    if (S.attaching) joinTimer = setTimeout(join, now ? 0 : 450);
}
async function join() {
    const want = S.tg;
    const g = S.flat[want];
    const r = await post('setTalkgroup', { id: g.id });
    if (want !== S.tg) return; // user moved on while we waited
    if (r && r.ok) S.attached = want;
    else { S.tg = S.attached; toast('Not permitted'); }
    S.attaching = false;
    render();
}

async function toggleSpeaker() {
    const r = await post('setSpeaker', { on: !S.speaker });
    if (r && r.ok) { S.speaker = !!r.speaker; toast(S.speaker ? 'Loudspeaker on' : 'Earpiece'); }
    else toast('Not available');
}

let volTimer;
function setVolume(v) {
    S.volume = clamp(v, 0, 100);
    toast(`Volume ${S.volume}%`, 900);
    clearTimeout(volTimer);
    volTimer = setTimeout(() => post('setVolume', { volume: S.volume }), 300);
}

/* ---------------- Power ---------------- */
const DENY = {
    no_item: ['No terminal fitted', ''],
    unauthorised: ['Not registered', 'Terminal not authorised'],
    off_duty: ['Not registered', 'Sign on duty first'],
    grade: ['Not registered', 'Access level too low'],
    no_character: ['Not registered', 'No user'],
    reprogrammed: ['Deregistered', 'Role changed'],
    duplicate: ['Deregistered', 'ISSI in use'],
    remote: ['Disabled', 'Stunned by control'],
    error: ['No service', 'Network error'],
    switch: ['Powered off', 'Handheld radio in use'],
};

async function powerOn() {
    if (S.power !== 'off') return;
    S.power = 'boot'; S.boot = 0; render();
    const pending = post('power', { on: true });
    await sleep(1100); S.boot = 1; render();
    await sleep(950); S.boot = 2; render();
    const res = await pending;
    await sleep(700);
    if (!res || !res.ok) return deny((res && res.reason) || 'error');

    S.data = res;
    S.me = res.me ?? null;
    S.talking = new Set();
    S.volume = res.volume ?? 60;
    S.speaker = !!res.speaker;
    S.dir = res.directory || [];
    flatten();
    const i = Math.max(0, S.flat.findIndex(g => g.id === res.tg));
    S.tg = S.attached = i;
    S.attaching = false;
    S.power = 'on';
    goHome();
    beep([880, 1320], .07, .05);
}

async function deny(reason) {
    S.power = 'denied';
    S.denyText = DENY[reason] || DENY.error;
    resetLive();
    render();
    await sleep(2800);
    if (S.power === 'denied') { S.power = 'off'; render(); }
}

function resetLive() {
    stopLoop('PTP');
    S.tx = false; S.rx = null; S.ptp = null; S.emergency = false; S.alert = null;
    S.talking = new Set();
    S.toast = null; S.stack = []; S.screen = 'home';
}

async function powerOff() {
    if (S.power !== 'on') return;
    S.power = 'down';
    resetLive();
    render();
    post('power', { on: false });
    await sleep(900);
    S.power = 'off';
    render();
}

/* ---------------- PTP / Emergency ---------------- */
function dialIssi(issi) {
    if (!S.cfg.ptp) return;
    if (!issi) return toast('Enter an ISSI');
    if (issi === S.data.issi) return toast('Invalid number');
    S.ptp = { state: 'out', peer: lookup(issi) || { issi } };
    post('ptpDial', { issi });
    render();
}

async function triggerEmergency() {
    if (!S.cfg.emergency || S.emergency) return;
    const r = await post('emergency');
    if (r && r.ok) {
        S.emergency = true;
        emergencyTone();
        render();
    } else toast('Emergency unavailable');
}
function cancelEmergency() {
    S.emergency = false;
    post('emergencyCancel');
    toast('Emergency cancelled');
}

/* ---------------- Key handling ---------------- */
function press(k, long = false) {
    if (S.power === 'off') {
        if (k === 'knob' || (k === 'red' && long)) powerOn();
        return;
    }
    if (S.power !== 'on') return;

    if ((k === 'red' || k === 'knob') && long) return powerOff();
    if (k === 'knob') return;
    if (k === 'emerg') {
        if (long) triggerEmergency();
        else toast('Hold for emergency', 1200);
        return;
    }

    keyBeep();

    if (S.alert) {
        if (['softL', 'softR', 'green', 'red'].includes(k)) { S.alert = null; render(); }
        return;
    }
    if (S.emergency) {
        if (k === 'red' || k === 'softR') cancelEmergency();
        return;
    }
    if (S.ptp) return ptpKey(k);

    (HANDLERS[S.screen] || listKey)(k);
}

function ptpKey(k) {
    const st = S.ptp.state;
    if (st === 'in') {
        if (k === 'green' || k === 'softL') { post('ptpAnswer'); stopLoop('PTP'); }
        else if (k === 'red' || k === 'softR') post('ptpEnd');
        return;
    }
    if (k === 'red' || k === 'softR') {
        if (st === 'out') { S.ptp = null; stopLoop('PTP'); render(); }
        post('ptpEnd');
    }
}

const isDigit = k => /^\d$/.test(k);

const HANDLERS = {
    home(k) {
        if (k === 'up') selectTG(S.tg - 1);
        else if (k === 'down') selectTG(S.tg + 1);
        else if (k === 'left') setVolume(S.volume - 10);
        else if (k === 'right') setVolume(S.volume + 10);
        else if (k === 'softL') go('menu');
        else if (k === 'softR') go('members', { tg: attachedId() });
        else if (k === 'green' && S.cfg.ptp) { S.dial = ''; go('dial'); }
        else if (isDigit(k) && S.cfg.ptp) { S.dial = k; go('dial'); }
        else if (k === '#') toggleSpeaker();
    },
    dial(k) {
        if (isDigit(k)) { if (S.dial.length < 8) S.dial += k; render(); }
        else if (k === 'green' || k === 'softL') dialIssi(S.dial);
        else if (k === 'softR') { if (S.dial) { S.dial = S.dial.slice(0, -1); render(); } else back(); }
        else if (k === 'red') goHome();
    },
    edit(k) {
        if (isDigit(k)) typeChar(k);
        else if (k === 'softL' || k === 'green') saveCallsign();
        else if (k === 'softR') back();
        else if (k === 'red') goHome();
    },
    about(k) {
        if (k === 'softR') back();
        else if (k === 'red') goHome();
    },
};

function typeChar(c) {
    if (S.edit.length >= (S.cfg.callsignMax || 24) || !/^[A-Za-z0-9 \-/]$/.test(c)) return;
    S.edit += c.toUpperCase();
    render();
}
async function saveCallsign() {
    const r = await post('setCallsign', { callsign: S.edit });
    if (r && r.callsign) { S.data.callsign = r.callsign; toast('Callsign saved'); back(); }
    else toast('Invalid callsign');
}

const LISTS = {
    menu: {
        title: () => 'Menu',
        items: () => [
            { label: 'Units', value: S.dir.length, act: () => go('members') },
            { label: 'Talkgroups', act: () => go('folders') },
            { label: 'Contacts', act: () => go('contacts') },
            ...(S.cfg.ptp ? [{ label: 'Dial ISSI', act: () => { S.dial = ''; go('dial'); } }] : []),
            { label: 'Settings', act: () => go('settings') },
        ],
    },
    folders: {
        title: () => 'Talkgroups',
        items: () => (S.data.folders || []).map((f, i) => ({ label: f.label, value: f.groups.length, act: () => go('groups', { fi: i }) })),
    },
    groups: {
        title: () => S.data.folders[S.ctx.fi].label,
        items: () => S.data.folders[S.ctx.fi].groups.map(g => {
            const idx = S.flat.findIndex(x => x.id === g.id);
            return { label: g.name, value: idx === S.attached ? 'Active' : '', act: () => { selectTG(idx, true); goHome(); } };
        }),
    },
    members: {
        // ◀ / ▶ flips between talkgroups with units on, so you can call someone on another channel
        title: () => {
            const pages = unitPages();
            const i = Math.max(0, pages.findIndex(p => p.id === (S.ctx.tg || attachedId())));
            return `◀ ${pages[i].name} ▶`;
        },
        empty: 'Nobody on this talkgroup',
        nav: dir => {
            const pages = unitPages();
            const i = Math.max(0, pages.findIndex(p => p.id === (S.ctx.tg || attachedId())));
            S.ctx = { tg: pages[(i + dir + pages.length) % pages.length].id };
            S.cur = 0;
            render();
        },
        items: () => {
            const id = S.ctx.tg || attachedId();
            return unitsOn(id).map(u => ({
                label: u.callsign,
                value: isTalking(u) ? 'TX' : u.src === S.me ? 'You' : u.inCall ? 'In call'
                    : id === '*' ? (u.talkgroup || '') : u.issi,
                act: () => { if (u.src !== S.me) dialIssi(u.issi); else toast('That is you'); },
            }));
        },
        soft: ['Call', 'Back'],
    },
    contacts: {
        title: () => 'Contacts',
        empty: 'No other terminals online',
        items: () => S.dir
            .filter(u => u.issi !== S.data.issi)
            .sort((a, b) => a.callsign.localeCompare(b.callsign))
            .map(u => ({ label: u.callsign, value: `${u.service} ${u.issi}`, act: () => dialIssi(u.issi) })),
    },
    settings: {
        title: () => 'Settings',
        items: () => [
            { label: 'Volume', value: `${S.volume}%`, adj: d => setVolume(S.volume + d * 10) },
            { label: 'Brightness', value: `${S.bright}%`, adj: d => { S.bright = clamp(S.bright + d * 10, 30, 100); savePrefs(); render(); } },
            { label: 'Audio', value: S.speaker ? 'Speaker' : 'Earpiece', act: toggleSpeaker, adj: toggleSpeaker },
            { label: 'Key tones', value: S.keyTones ? 'On' : 'Off', act: toggleTones, adj: toggleTones },
            { label: 'Callsign', value: S.data.callsign, act: () => { S.edit = S.data.callsign; go('edit'); } },
            { label: 'Terminal info', act: () => go('about') },
        ],
    },
};
function toggleTones() { S.keyTones = !S.keyTones; savePrefs(); render(); }

function listKey(k) {
    const L = LISTS[S.screen];
    if (!L) return goHome();
    const items = L.items();
    const it = items[S.cur];
    const n = Math.max(1, items.length);

    if (k === 'up') S.cur = (S.cur - 1 + n) % n;
    else if (k === 'down') S.cur = (S.cur + 1) % n;
    else if ((k === 'left' || k === 'right') && L.nav) return L.nav(k === 'right' ? 1 : -1);
    else if ((k === 'left' || k === 'right') && it && it.adj) return it.adj(k === 'right' ? 1 : -1);
    else if ((k === 'softL' || k === 'green') && it && it.act) return it.act();
    else if (k === 'softR') return back();
    else if (k === 'red') return goHome();
    else if (isDigit(k)) {
        const i = +k - 1;
        if (i >= 0 && i < items.length) { S.cur = i; if (items[i].act) return items[i].act(); }
    }
    render();
}

/* ---------------- Rendering ---------------- */
function bar() {
    const d = new Date();
    const t = `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
    return `<div class="bar"><span class="sig"><i></i><i></i><i></i><i></i></span><span>TMO</span>${S.emergency ? '<span class="flag">EMER</span>' : ''}<span class="grow"></span>${S.speaker ? SPK_ICON : ''}<span>${t}</span><span class="batt"><b></b></span></div>`;
}
const SPK_ICON = '<svg class="spk" viewBox="0 0 16 14" width="16" height="14"><path d="M1 5h3l4-3.5v11L4 9H1z" fill="currentColor"/><path d="M10.5 4.2a4 4 0 0 1 0 5.6M12.6 2.3a7 7 0 0 1 0 9.4" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round"/></svg>';
const soft = (l = '', r = '') => `<div class="soft"><span>${l}</span><span>${r}</span></div>`;
const scr = (cls, html) => `<div class="scr ${cls}">${html}</div>`;

function viewHome() {
    const g = S.flat[S.tg];
    if (!g) return scr('', bar() + `<div class="pane"><div class="small">No talkgroups assigned</div></div>` + soft('Menu', ''));
    let cls = '', line = 'Standby';
    if (S.tx) { cls = 'tx'; line = 'Transmitting'; }
    else if (S.rx) { cls = 'rx'; line = esc(S.rx); }
    else if (S.attaching) { cls = 'att'; line = 'Attaching…'; }
    return scr('', bar() + `
        <div class="home ${cls}">
            <div class="folder"><span>${esc(g.folder)}</span><span>${channelUnits().length} on channel</span></div>
            <div class="tgw"><div class="tg">${esc(g.name)}</div></div>
            <div class="line">${line}</div>
            <div class="who"><span>ISSI ${esc(S.data.issi)}</span><span>${esc(S.data.callsign)}</span></div>
        </div>` + soft('Menu', 'Channel'));
}

function viewList() {
    const L = LISTS[S.screen];
    const items = L.items();
    const max = 4;
    if (S.cur >= items.length) S.cur = Math.max(0, items.length - 1);
    const start = Math.max(0, Math.min(S.cur - 1, items.length - max));
    const rows = items.length
        ? items.slice(start, start + max).map((it, i) =>
            `<div class="item${start + i === S.cur ? ' sel' : ''}"><span>${esc(it.label)}</span><small>${esc(it.value ?? '')}</small></div>`).join('')
        : `<div class="empty">${esc(L.empty || 'Nothing here')}</div>`;
    const sb = items.length > max
        ? `<div class="scrollbar"><b style="top:${start / items.length * 100}%;height:${max / items.length * 100}%"></b></div>` : '';
    return scr('', bar() +
        `<div class="title">${esc(L.title())}<span>${items.length ? `${S.cur + 1}/${items.length}` : ''}</span></div>` +
        `<div class="list">${rows}${sb}</div>` + soft(items.length ? (L.soft ? L.soft[0] : 'Select') : '', L.soft ? L.soft[1] : 'Back'));
}

function viewDial() {
    return scr('', bar() + `<div class="title">Individual call</div>
        <div class="pane"><div class="small">Enter ISSI</div><div class="digits">${esc(S.dial)}<span class="caret"></span></div></div>` +
        soft('Call', S.dial ? 'Clear' : 'Back'));
}

function viewEdit() {
    return scr('', bar() + `<div class="title">Callsign</div>
        <div class="pane"><div class="big${S.edit.length > 12 ? ' long' : ''}">${esc(S.edit)}<span class="caret"></span></div><div class="small">Type on your keyboard (${S.edit.length}/${S.cfg.callsignMax || 24})</div></div>` +
        soft('Save', 'Back'));
}

function viewAbout() {
    const d = S.data, g = S.flat[S.attached];
    const row = (a, b) => `<div><dt>${a}</dt><dd>${esc(b)}</dd></div>`;
    return scr('', bar() + `<div class="title">Terminal info</div>
        <dl class="rows">${row('ISSI', d.issi)}${row('Callsign', d.callsign)}${row('Service', d.service)}${row('User', d.name)}${row('Talkgroup', g ? g.name : 'None')}</dl>` +
        soft('', 'Back'));
}

function viewPtp() {
    const p = S.ptp, name = esc(peerName(p.peer));
    const sub = esc([p.peer.service, p.peer.issi].filter(Boolean).join(' '));
    if (p.state === 'in') {
        return scr('ring', bar() + `<div class="title">Incoming call</div>
            <div class="pane"><div class="big">${name}</div><div class="small">${sub}</div></div>` + soft('Answer', 'Reject'));
    }
    if (p.state === 'active') {
        const s = Math.floor((Date.now() - p.start) / 1000);
        const t = `${String(Math.floor(s / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`;
        return scr('', bar() + `<div class="title">Individual call<span>${t}</span></div>
            <div class="pane"><div class="small">Connected</div><div class="big">${name}</div><div class="small">${sub}</div></div>` + soft('', 'End'));
    }
    return scr('ring', bar() + `<div class="title">Individual call</div>
        <div class="pane"><div class="small">${p.state === 'ringing' ? 'Ringing' : 'Calling'}</div><div class="big">${name}</div><div class="small">${sub}</div></div>` + soft('', 'Cancel'));
}

function viewEmergency() {
    const g = S.flat[S.attached];
    return scr('emergency', bar() + `<div class="pane"><div class="big">EMERGENCY</div><div class="small">Alert sent on ${esc(g ? g.name : 'network')}</div></div>` + soft('', 'Cancel'));
}

function viewAlert() {
    const a = S.alert;
    return scr('alert', `<div class="pane"><div class="small">Emergency activation</div><div class="big">${esc(a.callsign)}</div>
        <div class="small">${esc(a.talkgroup)}${a.street ? '<br>' + esc(a.street) : ''}</div></div>` + soft('OK', ''));
}

function viewPower() {
    if (S.power === 'boot') {
        if (S.boot === 0) return scr('boot0', `<div class="mark">SEPTRA</div><div class="sub">TETRA terminal</div>`);
        if (S.boot === 1) return scr('', `<div class="pane"><div class="small">Self test</div><div class="progress"><b></b></div></div>`);
        return scr('', bar() + `<div class="pane"><div class="small">Searching for network…</div></div>`);
    }
    if (S.power === 'denied') {
        return scr('', `<div class="pane"><div class="big denied">${esc(S.denyText[0])}</div><div class="small">${esc(S.denyText[1])}</div></div>`);
    }
    if (S.power === 'down') return scr('', `<div class="pane"><div class="small">Powering off</div></div>`);
    return '';
}

function render() {
    const el = $('#screen');
    let html;
    if (S.power !== 'on') html = viewPower();
    else if (S.alert) html = viewAlert();
    else if (S.emergency) html = viewEmergency();
    else if (S.ptp) html = viewPtp();
    else if (S.screen === 'home') html = viewHome();
    else if (S.screen === 'dial') html = viewDial();
    else if (S.screen === 'edit') html = viewEdit();
    else if (S.screen === 'about') html = viewAbout();
    else html = viewList();

    if (S.toast && S.power === 'on') html += `<div class="toast">${esc(S.toast)}</div>`;
    el.className = S.power === 'off' ? 'off' : '';
    el.style.filter = `brightness(${S.bright / 100})`;
    el.innerHTML = html;
    renderHud();
}

const SAMPLE_UNITS = [
    { src: -1, callsign: 'NB 1190', service: 'Police' },
    { src: -2, callsign: 'NB 2210', service: 'Police' },
    { src: -3, callsign: 'AMB 14', service: 'Ambulance' },
];

function placeList(el) {
    el.style.transform = `scale(${S.listScale})`;
    el.style.transformOrigin = S.listPos ? '0 0' : '100% 0';
    if (S.listPos) {
        el.style.left = `${S.listPos.x * 100}%`;
        el.style.top = `${S.listPos.y * 100}%`;
        el.style.right = 'auto';
    } else {
        el.style.left = ''; el.style.top = ''; el.style.right = '';
    }
}

function renderList() {
    const el = $('#rlist');
    const rl = S.cfg.radioList || {};
    const g = S.flat[S.attached];
    const live = S.power === 'on' && g;

    if (!S.listMoving && (!rl.enabled || !S.listVisible || S.open || !live)) { el.className = 'hidden'; return; }

    const units = live ? channelUnits() : SAMPLE_UNITS;
    const title = live ? g.name : 'OPS 1';
    const max = rl.maxRows || 12;
    const rows = units.slice(0, max).map(u => {
        const cls = [live && isTalking(u) ? 'talk' : '', u.src === S.me ? 'me' : ''].join(' ');
        return `<li class="${cls}${u.inCall ? ' call' : ''}"><i></i><span>${esc(u.callsign)}</span><small>${u.inCall ? 'In call' : esc(u.service)}</small></li>`;
    }).join('');
    const more = units.length > max ? `<li class="more">+${units.length - max} more</li>` : '';
    const hint = S.listMoving
        ? `<footer>Drag to move, scroll to resize<br>R to reset, Enter or Esc to save</footer>` : '';

    el.className = S.listMoving ? 'moving' : '';
    placeList(el);
    el.innerHTML = `<header><b>${esc(title)}</b><span>${units.length}</span></header><ul>${rows}${more}</ul>${hint}`;
}

/* ---- Move mode ---- */
let moveKeyArmed = null;
function finishListMove() {
    if (!S.listMoving) return;
    S.listMoving = false;
    savePrefs();
    post('listMoveDone');
    render();
}

(() => {
    const el = $('#rlist');
    let drag = null;
    el.addEventListener('pointerdown', e => {
        if (!S.listMoving) return;
        e.preventDefault();
        const r = el.getBoundingClientRect();
        drag = { dx: e.clientX - r.left, dy: e.clientY - r.top };
        el.setPointerCapture(e.pointerId);
    });
    el.addEventListener('pointermove', e => {
        if (!drag) return;
        const r = el.getBoundingClientRect();
        const x = clamp(e.clientX - drag.dx, 0, innerWidth - r.width);
        const y = clamp(e.clientY - drag.dy, 0, innerHeight - r.height);
        S.listPos = { x: x / innerWidth, y: y / innerHeight };
        placeList(el);
    });
    el.addEventListener('pointerup', () => { drag = null; });
    el.addEventListener('wheel', e => {
        if (!S.listMoving) return;
        e.preventDefault();
        S.listScale = Math.round(clamp(S.listScale + (e.deltaY < 0 ? .05 : -.05), .6, 1.6) * 100) / 100;
        placeList(el);
    }, { passive: false });
})();

function renderHud() {
    renderList();
    const el = $('#hud');
    if (!S.cfg.ui.hud || S.open || S.power !== 'on') { el.className = 'hidden'; return; }
    const g = S.flat[S.attached];
    let cls = '', status = '';
    if (S.alert) { cls = 'emerg'; status = `Emergency ${S.alert.callsign}`; }
    else if (S.emergency) { cls = 'emerg'; status = 'Emergency sent'; }
    else if (S.ptp) {
        cls = 'ptp';
        const n = peerName(S.ptp.peer);
        status = S.ptp.state === 'in' ? `Call from ${n}` : S.ptp.state === 'active' ? `In call ${n}` : `Calling ${n}`;
    }
    else if (S.tx) { cls = 'tx'; status = 'TX'; }
    else if (S.rx) { cls = 'rx'; status = S.rx; }
    el.className = cls;
    el.innerHTML = `${S.speaker ? SPK_ICON : ''}<span class="hg">${esc(g ? g.name : '')}</span>${status ? `<span class="hs">${esc(status)}</span>` : ''}`;
}

/* ---------------- Layout & input ---------------- */
function layout() {
    const k = innerHeight * (S.cfg.ui.scale || .78) / IMG_H;
    const st = document.documentElement.style;
    st.setProperty('--k', k);
    st.setProperty('--x', `${(IMG_W - BODY_RIGHT) * k - (S.cfg.ui.offset ?? 40)}px`);
}
addEventListener('resize', layout);

function buildKeys() {
    const wrap = $('#keys');
    for (const [k, [cx, cy, w, h]] of Object.entries(KEYS)) {
        const d = document.createElement('div');
        d.className = 'key';
        Object.assign(d.style, { left: `${cx - w / 2}px`, top: `${cy - h / 2}px`, width: `${w}px`, height: `${h}px` });

        if (k === 'ptt') {
            d.addEventListener('pointerdown', e => { e.preventDefault(); d.classList.add('down'); ptt(true); });
            const release = () => { d.classList.remove('down'); ptt(false); };
            d.addEventListener('pointerup', release);
            d.addEventListener('pointerleave', release);
            wrap.append(d);
            continue;
        }

        let timer = null, fired = false;
        d.addEventListener('pointerdown', e => {
            e.preventDefault();
            d.classList.add('down');
            if (!HOLD_KEYS.includes(k)) return press(k);
            fired = false;
            const ms = k === 'emerg' ? S.cfg.emergencyHold : S.cfg.powerHold;
            timer = setTimeout(() => { fired = true; press(k, true); }, ms);
        });
        const up = () => {
            d.classList.remove('down');
            if (timer) { clearTimeout(timer); timer = null; if (!fired) press(k); }
        };
        d.addEventListener('pointerup', up);
        d.addEventListener('pointerleave', () => { d.classList.remove('down'); if (timer) { clearTimeout(timer); timer = null; } });
        wrap.append(d);
    }

    const wheel = e => {
        e.preventDefault();
        if (S.power !== 'on') return;
        const dir = e.deltaY > 0 ? 1 : -1;
        if (S.screen === 'home' && !S.ptp && !S.alert && !S.emergency) { keyBeep(); selectTG(S.tg + dir); }
        else press(dir > 0 ? 'down' : 'up');
    };
    $('#screen').addEventListener('wheel', wheel, { passive: false });
    wrap.children[Object.keys(KEYS).indexOf('knob')].addEventListener('wheel', wheel, { passive: false });
}

let pttDown = false;
function ptt(down) {
    if (down === pttDown) return;
    if (down && S.power !== 'on') return;
    pttDown = down;
    post('ptt', { down });
}
addEventListener('blur', () => ptt(false));

const KB = { ArrowUp: 'up', ArrowDown: 'down', ArrowLeft: 'left', ArrowRight: 'right', Enter: 'softL', Backspace: 'softR' };
addEventListener('keydown', e => {
    if (S.listMoving) {
        e.preventDefault();
        if (e.key === 'Enter' || e.key === 'Escape') moveKeyArmed = e.key;
        if (e.key === 'r' || e.key === 'R') { S.listPos = null; S.listScale = 1; render(); }
        return;
    }
    if (!S.open) return;
    if (e.key === 'Escape') { e.preventDefault(); return; } // closes on keyup, see below
    if (e.code === S.cfg.talkKey) { e.preventDefault(); if (!e.repeat) ptt(true); return; }
    if (S.power === 'on' && S.screen === 'edit' && !S.ptp && !S.alert && !S.emergency) {
        if (e.key === 'Backspace') { S.edit = S.edit.slice(0, -1); render(); return; }
        if (e.key.length === 1) { typeChar(e.key); return; }
    }
    if (KB[e.key]) press(KB[e.key]);
    else if (/^[0-9]$/.test(e.key)) press(e.key);
});

// Close on key RELEASE: if we closed on keydown, GTA would receive the Escape key-up
// without its key-down once focus returns, which can leave the pause menu unresponsive.
addEventListener('keyup', e => {
    if (S.listMoving) {
        // Only a key that was pressed during move mode counts. The Enter used to send
        // /radiolistmove from chat is released after move mode starts, and must be ignored.
        if ((e.key === 'Escape' || e.key === 'Enter') && moveKeyArmed === e.key) finishListMove();
        return;
    }
    if (!S.open) return;
    if (e.code === S.cfg.talkKey) { e.preventDefault(); ptt(false); return; }
    if (e.key === 'Escape') { ptt(false); post('close'); }
});

/* ---------------- Messages from Lua ---------------- */
const PTP_END = {
    unavailable: 'Not available', busy: 'Busy', no_answer: 'No answer', rejected: 'Call rejected',
    ended: 'Call ended', restricted: 'Not permitted', invalid: 'Invalid number',
};

addEventListener('message', ({ data: msg }) => {
    const d = msg.data || {};
    switch (msg.action) {
        case 'listMove':
            moveKeyArmed = null;
            S.listMoving = true;
            break;
        case 'toggleList':
            S.listVisible = !S.listVisible;
            savePrefs();
            break;
        case 'open':
            if (d.talkKey) S.cfg.talkKey = d.talkKey;
            S.open = true;
            $('#radio').classList.remove('hidden');
            break;
        case 'close':
            pttDown = false;
            S.open = false;
            $('#radio').classList.add('hidden');
            break;
        case 'tx':
            if (S.power !== 'on') return;
            S.tx = !!d.active;
            play(S.tx ? 'PTT' : 'CLOSE');
            break;
        case 'rx':
            if (S.power !== 'on') return;
            if (d.active) { S.rx = d.label; if (d.src != null) S.talking.add(d.src); }
            else {
                if (d.src != null) S.talking.delete(d.src);
                S.rx = null;
                if (S.cfg.sounds.listenerClose) play('CLOSE');
            }
            break;
        case 'directory':
            S.dir = Array.isArray(d) ? d : [];
            if (S.ptp && S.ptp.peer) S.ptp.peer = lookup(S.ptp.peer.issi) || S.ptp.peer;
            break;
        case 'ptpRinging':
            if (!S.ptp) return;
            S.ptp.state = 'ringing';
            S.ptp.peer = d;
            if (S.cfg.sounds.outgoingRing) play('PTP', true);
            break;
        case 'ptpIncoming':
            S.ptp = { state: 'in', peer: d };
            play('PTP', true);
            break;
        case 'ptpConnected':
            if (!S.ptp) return;
            stopLoop('PTP');
            S.ptp.state = 'active';
            S.ptp.start = Date.now();
            break;
        case 'ptpEnded':
            stopLoop('PTP');
            if (S.ptp) { S.ptp = null; play('CLOSE'); }
            toast(PTP_END[d.reason] || 'Call ended');
            if (S.screen === 'dial') goHome();
            return;
        case 'emergencyAlert':
            S.alert = d;
            emergencyTone();
            break;
        case 'emergencyCleared':
            if (S.alert && S.alert.issi === d.issi) { S.alert = null; toast('Emergency cleared'); return; }
            break;
        case 'forceOff':
            stopLoop('PTP');
            if (S.power === 'on' || S.power === 'boot') deny(d.reason || 'remote');
            return;
    }
    render();
});

setInterval(() => {
    if (S.power === 'on' && (S.screen === 'home' || (S.ptp && S.ptp.state === 'active'))) render();
}, 1000);

/* ---------------- Boot ---------------- */
(async () => {
    buildKeys();
    const cfg = await post('ready');
    if (cfg) {
        S.cfg = { ...S.cfg, ...cfg, sounds: { ...S.cfg.sounds, ...(cfg.sounds || {}) }, ui: { ...S.cfg.ui, ...(cfg.ui || {}) } };
    }
    layout();
    render();
    if (DEV) {
        document.body.style.background = '#3a4048';
        window.postMessage({ action: location.search.includes('walkie') ? 'civ:open' : 'open' });
    }
})();

/* ---------------- Browser preview (no FiveM) ---------------- */
async function mock(name, data) {
    await sleep(120);
    if (name === 'power' && data.on) return {
        ok: true, me: 1, issi: '1042', callsign: 'NB 4521', service: 'Police', name: 'Sam Patel', volume: 60, tg: 'pol_ops1',
        folders: [
            { label: 'Police', groups: [{ id: 'pol_ops1', name: 'OPS 1' }, { id: 'pol_ops2', name: 'OPS 2' }, { id: 'pol_tac1', name: 'TAC 1' }, { id: 'pol_roads', name: 'ROADS' }, { id: 'pol_arv', name: 'ARV' }] },
            { label: 'Interop', groups: [{ id: 'ess_1', name: 'ESS 1' }, { id: 'ess_major', name: 'MAJOR INC' }] },
        ],
        directory: [
            { src: 1, issi: '1042', callsign: 'NB 4521', service: 'Police', tg: 'pol_ops1' },
            { src: 2, issi: '1007', callsign: 'NB 2210', service: 'Police', tg: 'pol_ops1' },
            { src: 4, issi: '1013', callsign: 'NB 3307', service: 'Police', tg: 'pol_ops1' },
            { src: 5, issi: '1021', callsign: 'NB 1190', service: 'Police', tg: 'pol_ops1' },
            { src: 3, issi: '2003', callsign: 'AMB 14', service: 'Ambulance', tg: 'ess_1', talkgroup: 'ESS 1' },
            { src: 6, issi: '1031', callsign: 'TANGO 41', service: 'Police', tg: 'pol_arv', talkgroup: 'ARV' },
            { src: 7, issi: '1033', callsign: 'TANGO 42', service: 'Police', tg: 'pol_arv', talkgroup: 'ARV' },
        ],
    };
    if (name === 'setTalkgroup') return { ok: true };
    if (name === 'setSpeaker') return { ok: true, speaker: data.on };
    if (name === 'civSetSpeaker') return data.on ? { ok: true, speaker: true } : { ok: false, reason: 'no_earpiece', speaker: true };
    if (name === 'setCallsign') return { callsign: data.callsign };
    if (name === 'emergency') return { ok: true };
    if (name === 'ptpDial') setTimeout(() => window.postMessage({ action: 'ptpRinging', data: lookup(data.issi) || { issi: data.issi } }), 400);
    if (name === 'close') return 1;
    if (name === 'civPower') return { ok: true };
    if (name === 'civSetChannel') return Number(data.channel) === 600 ? { ok: false, reason: 'encrypted' } : { ok: true, channel: Number(data.channel), private: false };
    return null;
}
