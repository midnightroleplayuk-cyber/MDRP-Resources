'use strict';
/* Civilian / gang handheld. Shares post(), esc(), clamp(), sleep() and DEV from app.js. */

const CW = 1024, CH = 1536, CIV_BODY_RIGHT = 780;

const C = {
    open: false,
    power: 'off',          // off | boot | on
    freq: 0,               // tuned frequency (0 = none)
    private: false,
    edit: null,            // string while typing
    tx: false, rx: false,
    msg: null,
    volume: 50,
    speaker: true,
    cfg: { enabled: true, min: 501, max: 999, decimals: true, tones: { clickTx: true, clickRx: true, keyBeep: true } },
    ui: { scale: .78, offset: 40, hud: true },
    powerHold: 1000,
    talkKey: 'AltLeft',
};

try {
    const p = JSON.parse(localStorage.getItem('vinewood_radio:walkie') || '{}');
    if (typeof p.volume === 'number') C.volume = p.volume;
    if (typeof p.last === 'number') C.last = p.last;
} catch { }
const civSave = () => { try { localStorage.setItem('vinewood_radio:walkie', JSON.stringify({ volume: C.volume, last: C.last })); } catch { } };

/* ---------------- Tones (deliberately plain, nothing like Sepura) ---------------- */
let civAc;
const civLevel = () => clamp(C.volume / 100, 0, 1) * .5;
function civTone(freq, dur, type = 'sine', gain = .12) {
    try {
        civAc = civAc || new AudioContext();
        const o = civAc.createOscillator(), g = civAc.createGain(), t = civAc.currentTime;
        o.type = type; o.frequency.value = freq;
        g.gain.setValueAtTime(gain * civLevel(), t);
        g.gain.exponentialRampToValueAtTime(.0001, t + dur);
        o.connect(g).connect(civAc.destination);
        o.start(t); o.stop(t + dur);
    } catch { }
}
const CLICK = {
    on: new Audio('sounds/mic_click_on.wav'),
    off: new Audio('sounds/mic_click_off.wav'),
};
Object.values(CLICK).forEach(a => { a.preload = 'auto'; });
function civClick(which) {
    const a = CLICK[which].cloneNode();
    a.volume = clamp(C.volume / 100, 0, 1);
    a.play().catch(() => { });
}
const civKeyBeep = () => C.cfg.tones.keyBeep && civTone(2000, .035, 'square', .05);

/* ---------------- Helpers ---------------- */
let civMsgTimer;
function civMsg(text, ms = 1500) {
    C.msg = text;
    clearTimeout(civMsgTimer);
    civMsgTimer = setTimeout(() => { C.msg = null; civRender(); }, ms);
    civRender();
}
const fmtFreq = f => f ? (C.cfg.decimals ? Number(f).toFixed(1) : String(f)) : '---.-';

/* ---------------- Power / tuning ---------------- */
async function civPowerOn() {
    if (C.power !== 'off') return;
    C.power = 'boot'; civRender();
    const pending = post('civPower', { on: true, volume: C.volume });
    await sleep(700);
    const res = await pending;
    if (!res || !res.ok) {
        C.power = 'off'; civRender();
        return;
    }
    C.power = 'on';
    C.freq = 0; C.private = false;
    C.speaker = res.speaker !== false;
    civTone(1200, .08); civRender();
    if (C.last) civTune(C.last, true);
}

function civPowerOff(local = false) {
    if (C.power === 'off') return;
    C.power = 'off';
    C.freq = 0; C.tx = C.rx = false; C.edit = null; C.msg = null;
    if (!local) post('civPower', { on: false });
    civRender();
}

const ERR = { range: 'Out of range', encrypted: 'Encrypted', off: 'Power off' };

async function civTune(value, quiet = false) {
    const f = parseFloat(value);
    if (Number.isNaN(f)) return civMsg('Invalid');
    const r = await post('civSetChannel', { channel: f });
    if (r && r.ok) {
        C.freq = r.channel;
        C.private = !!r.private;
        C.last = r.channel; civSave();
        if (!quiet) civMsg(C.private ? 'Private channel' : 'Tuned');
    } else if (!quiet) {
        civTone(400, .25, 'square', .06);
        civMsg(ERR[r && r.reason] || 'Failed');
    }
    civRender();
}

let civVolTimer;
function civSetVolume(v) {
    C.volume = clamp(v, 0, 100);
    civSave();
    civMsg(`Vol ${C.volume}%`, 900);
    clearTimeout(civVolTimer);
    civVolTimer = setTimeout(() => post('civVolume', { volume: C.volume }), 250);
}

async function civToggleSpeaker() {
    const r = await post('civSetSpeaker', { on: !C.speaker });
    if (r && typeof r.speaker === 'boolean') C.speaker = r.speaker;
    if (r && r.ok) civMsg(C.speaker ? 'Loudspeaker' : 'Earpiece');
    else civMsg(r && r.reason === 'no_earpiece' ? 'No earpiece' : 'Unavailable');
}

/* ---------------- Keys ---------------- */
function civPress(k, long = false) {
    if (C.power === 'off') { if (k === 'knob' || (k === 'red' && long)) civPowerOn(); return; }
    if (C.power !== 'on') return;
    if ((k === 'knob' || k === 'red') && long) return civPowerOff();
    if (k === 'knob') return;
    if (k === 'red') k = 'back';
    if (k === '*') k = '.';
    if (k === '#') k = C.edit != null ? 'ok' : 'top';
    if (k === 'green' || k === 'centre') k = 'ok';
    if (k === 'left') k = 'vdn';
    if (k === 'right') k = 'vup';

    civKeyBeep();

    if (k === 'top') return civToggleSpeaker();
    if (/^\d$/.test(k) || k === '.') {
        let e = C.edit ?? '';
        if (k === '.' && (!C.cfg.decimals || e.includes('.'))) return;
        if (e.includes('.') && e.split('.')[1].length >= 1) return;
        if (e.replace('.', '').length >= 4) return;
        C.edit = e + k;
        return civRender();
    }
    if (k === 'ok') {
        if (C.edit) { const v = C.edit; C.edit = null; civTune(v); }
        return civRender();
    }
    if (k === 'back') {
        if (C.edit) { C.edit = C.edit.slice(0, -1) || null; civRender(); }
        return;
    }
    if (k === 'up' || k === 'down') {
        C.edit = null;
        const base = C.freq || C.cfg.min - (k === 'up' ? 1 : -1);
        const next = clamp(Math.floor(base) + (k === 'up' ? 1 : -1), C.cfg.min, C.cfg.max);
        return civTune(next);
    }
    if (k === 'vdn') return civSetVolume(C.volume - 10);
    if (k === 'vup') return civSetVolume(C.volume + 10);
}

/* ---------------- Render ---------------- */
function civRender() {
    const lcd = document.getElementById('civlcd');
    const w = document.getElementById('walkie');
    if (!lcd) return;

    w.classList.toggle('lit', C.power !== 'off');
    lcd.className = C.tx ? 'tx' : C.rx ? 'rx' : '';

    if (C.power === 'off') { lcd.innerHTML = ''; return civHud(); }
    if (C.power === 'boot') { lcd.innerHTML = `<div class="cl-mid"><span class="cl-brand">COMTEL</span></div>`; return civHud(); }

    const sig = C.freq ? '<span class="cl-sig"><i></i><i></i><i></i><i></i></span>' : '<span class="cl-sig off"><i></i><i></i><i></i><i></i></span>';
    const tag = C.tx ? '<b class="cl-tag">TX</b>' : C.rx ? '<b class="cl-tag">RX</b>' : '';
    const big = C.edit != null ? `${esc(C.edit)}<span class="cl-caret">_</span>` : fmtFreq(C.freq);
    const foot = C.msg ? esc(C.msg) : C.edit != null ? 'Enter freq, OK to tune' : C.private ? 'Private' : C.freq ? 'MHz' : 'Not tuned';

    lcd.innerHTML = `
        <div class="cl-top">${sig}${tag}<span class="cl-grow"></span><span class="cl-audio">${C.speaker ? 'SPK' : 'EAR'}</span><span>V${Math.round(C.volume / 10)}</span><span class="cl-batt"><b></b></span></div>
        <div class="cl-label">${C.edit != null ? 'Frequency' : C.freq ? 'Channel' : ''}</div>
        <div class="cl-mid"><span class="cl-freq">${big}</span></div>
        <div class="cl-foot">${foot}</div>
        <div class="cl-soft"><span>OK</span><span>${C.edit != null ? 'Clear' : ''}</span></div>`;
    civHud();
}

function civHud() {
    const el = document.getElementById('civhud');
    if (!C.ui.hud || C.open || C.power !== 'on') { el.className = 'hidden'; return; }
    el.className = C.tx ? 'tx' : C.rx ? 'rx' : '';
    el.innerHTML = `<span>${fmtFreq(C.freq)}</span>${C.tx ? '<span class="hs">TX</span>' : C.rx ? '<span class="hs">RX</span>' : ''}`;
}

/* ---------------- Build device ---------------- */
// Hotspots in native image pixels: [centreX, centreY, width, height]
const CIV_KEYS = {
    green: [390, 1080, 82, 92], red: [640, 1080, 82, 92],
    up: [515, 1041, 84, 40], down: [515, 1139, 84, 40],
    left: [451, 1090, 40, 84], right: [579, 1090, 40, 84],
    centre: [515, 1090, 54, 54],
    1: [397, 1190, 94, 60], 2: [514, 1190, 94, 60], 3: [631, 1190, 94, 60],
    4: [397, 1263, 94, 60], 5: [514, 1263, 94, 60], 6: [631, 1263, 94, 60],
    7: [397, 1336, 94, 60], 8: [514, 1336, 94, 60], 9: [631, 1336, 94, 60],
    '*': [397, 1410, 94, 60], 0: [514, 1410, 94, 60], '#': [631, 1410, 94, 60],
    knob: [388, 428, 132, 112],
    top: [525, 492, 74, 24],
    side: [243, 720, 26, 160],
};
const CIV_HOLD = ['knob', 'red'];

function civBuild() {
    const el = document.createElement('div');
    el.id = 'walkie';
    el.className = 'hidden';
    el.innerHTML = `
    <img class="shell" src="img/walkie.png" alt="" draggable="false">
    <div id="civlcd"></div>
    <div id="civkeys"></div>`;
    document.body.append(el);

    const hud = document.createElement('div');
    hud.id = 'civhud';
    hud.className = 'hidden';
    document.body.append(hud);

    const wrap = el.querySelector('#civkeys');
    for (const [k, [x, y, w, h]] of Object.entries(CIV_KEYS)) {
        const d = document.createElement('div');
        d.className = 'ckey';
        Object.assign(d.style, { left: `${x - w / 2}px`, top: `${y - h / 2}px`, width: `${w}px`, height: `${h}px` });
        if (k === 'side') { // orange side button = push to talk
            d.addEventListener('pointerdown', e => { e.preventDefault(); d.classList.add('down'); civPtt(true); });
            const release = () => { d.classList.remove('down'); civPtt(false); };
            d.addEventListener('pointerup', release);
            d.addEventListener('pointerleave', release);
            wrap.append(d);
            continue;
        }
        let timer = null, fired = false;
        d.addEventListener('pointerdown', e => {
            e.preventDefault();
            d.classList.add('down');
            if (!CIV_HOLD.includes(k)) return civPress(k);
            fired = false;
            timer = setTimeout(() => { fired = true; civPress(k, true); }, C.powerHold);
        });
        d.addEventListener('pointerup', () => {
            d.classList.remove('down');
            if (timer) { clearTimeout(timer); timer = null; if (!fired) civPress(k); }
        });
        d.addEventListener('pointerleave', () => { d.classList.remove('down'); if (timer) { clearTimeout(timer); timer = null; } });
        wrap.append(d);
    }
    const wheel = e => {
        e.preventDefault();
        if (C.power === 'on') civPress(e.deltaY > 0 ? 'down' : 'up');
    };
    el.querySelector('#civlcd').addEventListener('wheel', wheel, { passive: false });
    wrap.children[Object.keys(CIV_KEYS).indexOf('knob')].addEventListener('wheel', wheel, { passive: false });
}

function civLayout() {
    const k = innerHeight * (C.ui.scale || .78) / CH;
    const st = document.documentElement.style;
    st.setProperty('--ck', k);
    st.setProperty('--cx', `${(CW - CIV_BODY_RIGHT) * k - (C.ui.offset ?? 40)}px`);
}
addEventListener('resize', civLayout);

/* ---------------- Input & messages ---------------- */
let civPttDown = false;
function civPtt(down) {
    if (down === civPttDown) return;
    if (down && (C.power !== 'on' || !C.freq)) return;
    civPttDown = down;
    post('ptt', { down });
}
addEventListener('blur', () => civPtt(false));

const CIV_KB = { ArrowUp: 'up', ArrowDown: 'down', ArrowLeft: 'vdn', ArrowRight: 'vup', Enter: 'ok', Backspace: 'back', '.': '.' };
addEventListener('keydown', e => {
    if (!C.open) return;
    if (e.key === 'Escape') { e.preventDefault(); return; } // closes on keyup
    if (e.code === C.talkKey) { e.preventDefault(); if (!e.repeat) civPtt(true); return; }
    if (CIV_KB[e.key]) civPress(CIV_KB[e.key]);
    else if (/^[0-9]$/.test(e.key)) civPress(e.key);
});

addEventListener('keyup', e => {
    if (!C.open) return;
    if (e.code === C.talkKey) { e.preventDefault(); civPtt(false); return; }
    if (e.key === 'Escape') { civPtt(false); post('civClose'); }
});

addEventListener('message', ({ data: msg }) => {
    const d = msg.data || {};
    switch (msg.action) {
        case 'civ:open':
            if (d.talkKey) C.talkKey = d.talkKey;
            C.open = true;
            document.getElementById('walkie').classList.remove('hidden');
            break;
        case 'civ:close':
            civPttDown = false;
            C.open = false;
            document.getElementById('walkie').classList.add('hidden');
            break;
        case 'civ:tx':
            if (C.power !== 'on') return;
            C.tx = !!d.active;
            if (C.cfg.tones.clickTx) civClick(C.tx ? 'on' : 'off');
            break;
        case 'civ:rx':
            if (C.power !== 'on') return;
            C.rx = !!d.active;
            if (C.cfg.tones.clickRx) civClick(C.rx ? 'on' : 'off');
            break;
        case 'civ:forceOff':
            civPowerOff(true);
            return;
        case 'civ:speaker':
            C.speaker = !!d.on;
            civMsg(C.speaker ? 'Loudspeaker' : 'Earpiece');
            return;
        case 'civ:kicked':
            C.freq = 0; C.private = false;
            civMsg('Encrypted');
            return;
        default:
            return;
    }
    civRender();
});

(async () => {
    civBuild();
    const cfg = await post('ready');
    if (cfg) {
        if (cfg.civ) C.cfg = { ...C.cfg, ...cfg.civ, tones: { ...C.cfg.tones, ...(cfg.civ.tones || {}) } };
        if (cfg.ui) C.ui = { ...C.ui, ...cfg.ui };
        if (cfg.powerHold) C.powerHold = cfg.powerHold;
        if (cfg.talkKey) C.talkKey = cfg.talkKey;
    }
    civLayout();
    civRender();
})();
