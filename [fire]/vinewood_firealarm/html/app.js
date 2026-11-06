'use strict';
const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'vinewood_firealarm';
const post = (name, data = {}) =>
  fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) })
    .then(r => r.json()).catch(() => null);
const $ = s => document.querySelector(s);
const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const pad = n => String(n).padStart(2, '0');
const arr = v => Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []);

function toast(msg) {
  const t = $('#toast');
  t.textContent = msg;
  t.classList.remove('hidden');
  clearTimeout(toast._t);
  toast._t = setTimeout(() => t.classList.add('hidden'), 2600);
}

/* =====================================================================
   SOUND — sounders and panel buzzer generated with Web Audio
   ===================================================================== */
// Recorded sounders: seamless loops in html/sounds, played gaplessly through Web Audio
const SAMPLES = { bs_alternating: 'sounds/bs_sounder_alternating.ogg' };

const Snd = {
  ctx: null, master: null, gate: null, osc: null, tone: null, next: 0, phase: 0, vol: 0, bz: null,
  buffers: {}, src: null,
  init() {
    if (this.ctx) return;
    const C = window.AudioContext || window.webkitAudioContext;
    const c = this.ctx = new C();
    this.master = c.createGain(); this.master.gain.value = 0; this.master.connect(c.destination);
    const filt = c.createBiquadFilter(); filt.type = 'lowpass'; filt.frequency.value = 3200; filt.connect(this.master);
    this.gate = c.createGain(); this.gate.gain.value = 0; this.gate.connect(filt);
    this.osc = c.createOscillator(); this.osc.type = 'square'; this.osc.frequency.value = 970; this.osc.connect(this.gate); this.osc.start();
    const bg = c.createGain(); bg.gain.value = 0; bg.connect(c.destination);
    const bo = c.createOscillator(); bo.type = 'sine'; bo.frequency.value = 2850; bo.connect(bg); bo.start();
    this.bz = { gain: bg, on: false, next: 0 };
    for (const [name, url] of Object.entries(SAMPLES)) {
      fetch(url).then(r => r.arrayBuffer()).then(b => c.decodeAudioData(b)).then(buf => { this.buffers[name] = buf; })
        .catch(err => console.log(`[vinewood_firealarm] could not load ${url}: ${err}`));
    }
    setInterval(() => this.tick(), 100);
  },
  resume() {
    if (this.ctx && this.ctx.state === 'suspended') this.ctx.resume().catch(() => {});
  },
  setAlarm(vol, tone) {
    this.init(); this.resume();
    if (tone !== this.tone) {
      this.tone = tone;
      this.stopSample();
      this.osc.frequency.cancelScheduledValues(0);
      this.gate.gain.cancelScheduledValues(0);
      this.next = this.ctx.currentTime; this.phase = 0;
    }
    this.vol = vol;
    this.master.gain.setTargetAtTime(vol, this.ctx.currentTime, 0.08);
  },
  setBuzzer(on) {
    this.init(); this.resume();
    if (on === this.bz.on) return;
    this.bz.on = on;
    if (!on) { this.bz.gain.gain.cancelScheduledValues(0); this.bz.gain.gain.setValueAtTime(0, this.ctx.currentTime); }
    this.bz.next = this.ctx.currentTime;
  },
  startSample(buf) {
    const c = this.ctx, src = c.createBufferSource();
    src.buffer = buf; src.loop = true; src.loopStart = 0; src.loopEnd = buf.duration;
    src.connect(this.master); src.start();
    this.src = src;
    this.gate.gain.cancelScheduledValues(0);
    this.gate.gain.setValueAtTime(0, c.currentTime);
  },
  stopSample() {
    if (this.src) { try { this.src.stop(); } catch (e) {} this.src.disconnect(); this.src = null; }
  },
  click() {
    this.init(); this.resume();
    const c = this.ctx, o = c.createOscillator(), g = c.createGain();
    o.frequency.value = 3100; g.gain.value = 0.025;
    o.connect(g); g.connect(c.destination);
    o.start(); o.stop(c.currentTime + 0.035);
  },
  tick() {
    const c = this.ctx, t = c.currentTime, ahead = t + 0.6;
    const sample = SAMPLES[this.tone];
    if (sample) {
      const buf = this.buffers[this.tone];
      if (buf && !this.src) this.startSample(buf);
    }
    if (this.vol > 0 && !this.src) {
      if (this.next < t) this.next = t;
      const f = this.osc.frequency, g = this.gate.gain;
      while (this.next < ahead) {
        const n = this.next;
        switch (sample ? 'alternating' : this.tone) {
          case 'continuous': f.setValueAtTime(970, n); g.setValueAtTime(1, n); this.next += 0.5; break;
          case 'pulsed': f.setValueAtTime(970, n); g.setValueAtTime(this.phase++ % 2 === 0 ? 1 : 0, n); this.next += 1.0; break;
          case 'sweep': g.setValueAtTime(1, n); f.setValueAtTime(800, n); f.linearRampToValueAtTime(970, n + 0.92); this.next += 1.0; break;
          default: f.setValueAtTime(this.phase++ % 2 === 0 ? 800 : 970, n); g.setValueAtTime(1, n); this.next += 0.25;
        }
      }
    }
    if (this.bz.on) {
      if (this.bz.next < t) this.bz.next = t;
      while (this.bz.next < ahead) {
        const n = this.bz.next;
        this.bz.gain.gain.setValueAtTime(0.045, n);
        this.bz.gain.gain.setValueAtTime(0, n + 0.35);
        this.bz.next += 0.7;
      }
    }
  },
};

/* =====================================================================
   CONTROL PANEL
   ===================================================================== */
const P = {
  open: false, sys: null, st: null, level: 1, maxZones: 8,
  screen: 'status', code: '', idx: 0, alarmIdx: 0,
  msg: null, msgUntil: 0, buzzerMuted: false, lamp: false, lastZones: 0, offset: 0, busy: false,
};

const zoneName = z => (P.sys && arr(P.sys.zones)[z - 1]) || `Zone ${z}`;
const nowS = () => Date.now() / 1000 + P.offset;
const fmtClock = ts => { const d = new Date(ts * 1000); return `${pad(d.getHours())}:${pad(d.getMinutes())}`; };
const fmtStamp = ts => { const d = new Date(ts * 1000); return `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())} ${pad(d.getDate())}/${pad(d.getMonth() + 1)}`; };
const fmtDate = ts => new Date(ts * 1000).toLocaleDateString('en-GB', { weekday: 'short', day: 'numeric', month: 'short', year: 'numeric' });
const sounding = st => ((st.fire || st.evacuate) && !st.silenced) || st.testSounding;

function setState(st) {
  if (!st) return;
  st.zones = arr(st.zones); st.active = arr(st.active); st.disabled = arr(st.disabled); st.events = arr(st.events); st.sprinklers = arr(st.sprinklers);
  if (st.serverTime) P.offset = st.serverTime - Date.now() / 1000;
  if (st.zones.length > P.lastZones) P.buzzerMuted = false;
  if (!st.fire && !st.evacuate) { P.buzzerMuted = false; P.alarmIdx = 0; }
  P.lastZones = st.zones.length;
  if (P.alarmIdx >= st.zones.length) P.alarmIdx = 0;
  P.st = st;
  updateBuzzer();
  render();
}

function updateBuzzer() {
  const st = P.st;
  Snd.setBuzzer(!!(P.open && st && (st.fire || st.evacuate) && !st.silenced && !P.buzzerMuted));
}

function flash(msg) {
  P.msg = msg; P.msgUntil = Date.now() + 2600;
  render();
  setTimeout(render, 2700);
}

function menuItems() {
  const it = [
    { k: 'evac', t: 'Evacuate building' },
    { k: 'zones', t: 'Disable or enable zones' },
    { k: 'events', t: 'Event log' },
    { k: 'lamp', t: 'Lamp test' },
    { k: 'sounders', t: 'Test sounders' },
  ];
  if (P.st && arr(P.st.sprinklers).length) it.unshift({ k: 'sprinklersOff', t: 'Shut off sprinklers' });
  if (P.level >= 3) it.push({ k: 'test', t: P.st.test ? 'Turn test mode off' : 'Turn test mode on' });
  it.push({ k: 'exit', t: 'Exit access level' });
  return it;
}

function renderLeds() {
  const st = P.st, lamp = P.lamp;
  const fire = $('#led-fire'), fault = $('#led-fault');
  fire.className = 'led red' + (lamp || st.fire ? ' on' : '') + (!lamp && st.fire && !st.silenced ? ' flash' : '');
  fault.className = 'led amber' + (lamp || st.disabled.length || st.test ? ' on' : '');
  let html = '';
  for (let z = 1; z <= P.maxZones; z++) {
    let cls = 'led';
    if (lamp) cls += ' red on';
    else if (st.zones.includes(z)) cls += ' red on' + (st.silenced ? '' : ' flash');
    else if (st.disabled.includes(z)) cls += ' amber on';
    html += `<div class="zone-row"><span class="${cls}"></span>Zone ${z}</div>`;
  }
  $('#zone-leds').innerHTML = html;
  $('#keyswitch').classList.toggle('on', P.level >= 2);
}

function footer() {
  const right = P.level >= 2 ? '✓ Menu' : 'Key in code for level 2';
  return `<div class="foot"><span>Access level ${P.level}</span><span>${right}</span></div>`;
}

function lcdStatus() {
  const st = P.st, sys = P.sys, now = nowS();
  const bar = `<div class="bar"><span>${esc(sys.label)}</span><span>${fmtClock(now)}</span></div>`;
  if (P.msg && Date.now() < P.msgUntil) {
    return bar + `<div class="body"><div class="center"><div class="mid">${esc(P.msg)}</div></div></div>` + footer();
  }
  let body = '';
  if (st.fire) {
    const z = st.zones[P.alarmIdx];
    const devs = arr(sys.devices).filter(d => d.zone === z && st.active.includes(d.id)).map(d => d.label);
    body += `<div class="big ${st.silenced ? '' : 'blink'}">FIRE</div>`;
    body += `<div class="mid">Z${pad(z)} ${esc(zoneName(z))}</div>`;
    body += `<div>${devs.length ? esc(devs.join(', ')) : 'Zone input'}</div>`;
    body += `<div class="dim">Alarm ${P.alarmIdx + 1} of ${st.zones.length}${P.alarmIdx === 0 ? ' (first)' : ''}${st.zones.length > 1 ? '  ▲▼' : ''}</div>`;
    body += `<div>${st.silenced ? 'Sounders silenced' : 'Sounders active'}${st.sprinklers.length ? '  ·  Sprinklers on' : ''}</div>`;
    if (sys.dispatch) {
      const left = Math.max(0, Math.ceil((st.alarmAt + sys.dispatchDelay) - now));
      body += `<div>${st.dispatched ? 'Fire service called' : `Calling fire service in ${left}s`}</div>`;
    }
  } else if (st.evacuate) {
    body += `<div class="big ${st.silenced ? '' : 'blink'}">EVACUATE</div>`;
    body += `<div>${st.silenced ? 'Sounders silenced' : 'All sounders active'}</div>`;
    body += `<div class="dim">Reset to clear</div>`;
  } else if (st.testSounding && !st.test) {
    body += `<div class="center"><div class="big">SOUNDER TEST</div><div>Sounders running</div></div>`;
  } else if (st.test) {
    body += `<div class="big">TEST MODE</div>`;
    body += `<div>${st.testSounding ? 'Sounders running' : 'Activate devices to test'}</div>`;
    body += `<div class="dim">Fire service will not be called</div>`;
  } else {
    body += `<div class="center"><div class="mid">System normal</div><div class="big">${fmtClock(now)}</div><div class="dim">${fmtDate(now)}</div></div>`;
  }
  if (st.disabled.length) body += `<div>Disabled: ${st.disabled.map(z => 'Z' + pad(z)).join(' ')}</div>`;
  return bar + `<div class="body">${body}</div>` + footer();
}

function lcdCode() {
  const shown = P.code ? '•'.repeat(P.code.length) : '_';
  return `<div class="bar"><span>Access</span><span>${fmtClock(nowS())}</span></div>
    <div class="body"><div class="center"><div class="mid">Enter access code</div><div class="code">${shown}</div><div class="dim">✓ Enter   ← Delete</div></div></div>`;
}

function lcdMenu() {
  const items = menuItems();
  const rows = items.map((it, i) => `<div class="row ${i === P.idx ? 'sel' : ''}"><span>${esc(it.t)}</span><span></span></div>`).join('');
  return `<div class="bar"><span>Menu</span><span>Level ${P.level}</span></div><div class="body">${rows}</div>
    <div class="foot"><span>▲▼ Choose</span><span>✓ Select  ← Back</span></div>`;
}

function lcdZones() {
  const st = P.st;
  let rows = '';
  for (let z = 1; z <= P.maxZones; z++) {
    const s = st.zones.includes(z) ? 'Fire' : (st.disabled.includes(z) ? 'Disabled' : 'Normal');
    rows += `<div class="row ev ${z - 1 === P.idx ? 'sel' : ''}"><span>Z${pad(z)} ${esc(zoneName(z))}</span><span>${s}</span></div>`;
  }
  return `<div class="bar"><span>Zones</span><span>Level ${P.level}</span></div><div class="body">${rows}</div>
    <div class="foot"><span>▲▼ Choose</span><span>✓ Disable/enable  ← Back</span></div>`;
}

function lcdEvents() {
  const ev = P.st.events;
  if (!ev.length) return `<div class="bar"><span>Event log</span><span>0</span></div><div class="body"><div class="center dim">No events recorded</div></div><div class="foot"><span></span><span>← Back</span></div>`;
  const per = P.level >= 3 ? 4 : 7;
  const rows = ev.slice(P.idx, P.idx + per).map(e =>
    `<div class="ev"><span class="t">${fmtStamp(e.t)}</span>${esc(e.text)}${e.actor && P.level >= 3 ? `<div class="dim">  ${esc(e.actor)}</div>` : ''}</div>`).join('');
  return `<div class="bar"><span>Event log</span><span>${P.idx + 1}/${ev.length}</span></div><div class="body">${rows}</div>
    <div class="foot"><span>▲▼ Scroll</span><span>← Back</span></div>`;
}

function lcdConfirm() {
  return `<div class="bar"><span>Evacuate</span><span>Level ${P.level}</span></div>
    <div class="body"><div class="center"><div class="mid">Sound all sounders?</div><div class="dim">The building will be evacuated</div><div>✓ Confirm   ← Cancel</div></div></div>`;
}

function render() {
  if (!P.open || !P.st) return;
  renderLeds();
  const map = { status: lcdStatus, code: lcdCode, menu: lcdMenu, zones: lcdZones, events: lcdEvents, confirmEvac: lcdConfirm };
  $('#lcd').innerHTML = (map[P.screen] || lcdStatus)();
}
setInterval(() => { if (P.open) render(); }, 1000);

async function action(name, arg) {
  P.busy = true;
  const r = await post('panelAction', { action: name, arg });
  P.busy = false;
  if (!r) return null;
  if (r.level) P.level = r.level;
  if (r.state) setState(r.state);
  if (!r.ok && r.msg) flash(r.msg);
  return r;
}

async function submitCode() {
  const code = P.code; P.code = ''; P.screen = 'status';
  P.busy = true;
  const r = await post('panelCode', { code });
  P.busy = false;
  if (r && r.ok) { P.level = r.level; flash(`Access level ${r.level}`); }
  else flash((r && r.msg) || 'Invalid code');
}

function lampTest() {
  P.lamp = true; P.screen = 'status';
  Snd.setBuzzer(true);
  flash('Lamp test');
  setTimeout(() => { P.lamp = false; updateBuzzer(); render(); }, 3000);
}

async function pick() {
  const it = menuItems()[P.idx];
  if (!it) return;
  if (it.k === 'evac') { P.screen = 'confirmEvac'; }
  else if (it.k === 'zones') { P.screen = 'zones'; P.idx = 0; }
  else if (it.k === 'events') {
    if (P.level >= 3) { const r = await post('panelRefresh'); if (r && r.state) setState(r.state); }
    P.screen = 'events'; P.idx = 0;
  }
  else if (it.k === 'lamp') { lampTest(); return; }
  else if (it.k === 'sprinklersOff') { const r = await action('sprinklersOff'); P.screen = 'status'; if (r && r.ok) flash('Sprinklers shut off'); return; }
  else if (it.k === 'sounders') { const r = await action('sounderTest'); P.screen = 'status'; if (r && r.ok) flash('Sounder test running'); return; }
  else if (it.k === 'test') { const r = await action('testMode'); P.screen = 'status'; if (r && r.ok) flash(P.st.test ? 'Test mode on' : 'Test mode off'); }
  else if (it.k === 'exit') { await action('logout'); P.screen = 'status'; flash(`Access level ${P.level}`); return; }
  render();
}

function nav(dir) {
  const st = P.st;
  if (P.screen === 'status' && st.fire && st.zones.length > 1) P.alarmIdx = (P.alarmIdx + dir + st.zones.length) % st.zones.length;
  else if (P.screen === 'menu') P.idx = Math.min(Math.max(P.idx + dir, 0), menuItems().length - 1);
  else if (P.screen === 'zones') P.idx = Math.min(Math.max(P.idx + dir, 0), P.maxZones - 1);
  else if (P.screen === 'events') P.idx = Math.min(Math.max(P.idx + dir, 0), Math.max(st.events.length - 1, 0));
  render();
}

async function onKey(k) {
  Snd.click();
  if (P.busy || P.lamp) return;
  const st = P.st;

  if (/^\d$/.test(k)) {
    if (P.screen === 'zones') { const z = +k; if (z >= 1 && z <= P.maxZones) { P.idx = z - 1; render(); } return; }
    if (P.screen === 'status' || P.screen === 'code') {
      P.screen = 'code';
      if (P.code.length < 6) P.code += k;
      render();
    }
    return;
  }

  switch (k) {
    case 'ok':
      if (P.screen === 'code') return submitCode();
      if (P.screen === 'status') { if (P.level >= 2) { P.screen = 'menu'; P.idx = 0; } else P.screen = 'code'; break; }
      if (P.screen === 'menu') return pick();
      if (P.screen === 'zones') { await action('toggleZone', P.idx + 1); break; }
      if (P.screen === 'confirmEvac') { const r = await action('evacuate'); P.screen = 'status'; if (r && r.ok) flash('Evacuate activated'); return; }
      break;
    case 'back':
      if (P.screen === 'code') { if (P.code) P.code = P.code.slice(0, -1); else P.screen = 'status'; }
      else if (P.screen === 'menu') P.screen = 'status';
      else if (['zones', 'events', 'confirmEvac'].includes(P.screen)) { P.screen = 'menu'; P.idx = 0; }
      break;
    case 'up': case 'left': return nav(-1);
    case 'down': case 'right': return nav(1);
    case 'silence': {
      const live = (st.fire || st.evacuate) && !st.silenced;
      if (live || st.testSounding) {
        P.buzzerMuted = true; updateBuzzer();
        if (P.level < 2) return flash('Buzzer muted. Level 2 needed to silence sounders');
        const r = await action('silence'); if (r && r.ok) flash('Sounders silenced');
        return;
      }
      if ((st.fire || st.evacuate) && st.silenced) {
        if (P.level < 2) return flash('Access level 2 required');
        const r = await action('resound'); if (r && r.ok) flash('Sounders resounded');
        return;
      }
      return flash('Nothing to silence');
    }
    case 'reset': {
      if (P.level < 2) return flash('Access level 2 required');
      const r = await action('reset'); if (r && r.ok) flash('System reset');
      return;
    }
  }
  render();
}

document.querySelectorAll('#panel .key').forEach(b => b.addEventListener('click', () => onKey(b.dataset.k)));
$('#keyswitch').addEventListener('click', async () => {
  Snd.click();
  if (P.level >= 2) {
    await action('logout');
    flash(P.level >= 2 ? 'Your role keeps level 2 access' : 'Access level 1');
  } else { P.screen = 'code'; P.code = ''; render(); }
});

function openPanel(d) {
  P.sys = d.system; P.level = d.level; P.maxZones = d.maxZones || 8;
  P.screen = 'status'; P.code = ''; P.idx = 0; P.alarmIdx = 0; P.msg = null; P.lamp = false;
  P.lastZones = arr(d.state.zones).length;
  P.open = true;
  $('#panel').classList.remove('hidden');
  setState(d.state);
}

function closePanel(notify = true) {
  if (!P.open) return;
  P.open = false;
  Snd.setBuzzer(false);
  $('#panel').classList.add('hidden');
  if (notify) post('panelClose');
}

/* =====================================================================
   ADMIN / COMMISSIONING
   ===================================================================== */
const TYPE = {
  panel: { name: 'Control panel', ico: 'CP' },
  mcp: { name: 'Call point', ico: 'MCP' },
  sounder: { name: 'Sounder', ico: 'S' },
  detector: { name: 'Detector', ico: 'D' },
  sprinkler: { name: 'Sprinkler', ico: 'SP' },
};
const TONE_NAMES = { bs_alternating: 'BS two-tone, recorded (800/970Hz 2Hz)', alternating: 'Two-tone, generated (800/970Hz)', continuous: 'Continuous (970Hz)', pulsed: 'Pulsed alert', sweep: 'Sweep' };

const A = { open: false, systems: [], sel: null, maxZones: 8, tones: Object.keys(TONE_NAMES), place: { type: 'mcp', zone: 1, label: '', mode: 'prop' } };
const curSys = () => A.systems.find(s => s.id === A.sel);

function sysStatus(s) {
  const st = s.state || {};
  if (st.fire) return { led: 'red on flash', text: 'In alarm' };
  if (st.evacuate) return { led: 'red on', text: 'Evacuating' };
  if (st.test) return { led: 'amber on', text: 'Test mode' };
  if (arr(st.disabled).length) return { led: 'amber on', text: 'Zones disabled' };
  return { led: 'green on', text: 'Normal' };
}

function renderList() {
  $('#adm-list').innerHTML = A.systems.length ? A.systems.map(s => {
    const st = sysStatus(s);
    return `<button class="adm-item ${s.id === A.sel ? 'active' : ''}" data-id="${s.id}">
      <span class="led ${st.led}"></span><span>${esc(s.label)}<small>${arr(s.devices).length} devices, ${st.text.toLowerCase()}</small></span></button>`;
  }).join('') : `<div class="hint">No systems yet.</div>`;
  document.querySelectorAll('.adm-item').forEach(b => b.addEventListener('click', () => { A.sel = +b.dataset.id; renderAdmin(); }));
}

function zoneOptions(sel, s) {
  let o = '';
  for (let z = 1; z <= A.maxZones; z++) o += `<option value="${z}" ${+sel === z ? 'selected' : ''}>Z${z} ${esc(arr(s && s.zones)[z - 1] || '')}</option>`;
  return o;
}

function renderAdmin() {
  renderList();
  const main = $('#adm-main');
  if (A.sel === null) {
    main.innerHTML = `<div class="empty"><strong>Set up a fire alarm for a business</strong><span>Choose a system on the left, or create a new one.</span></div>`;
    return;
  }
  const s = A.sel === 'new' ? null : curSys();
  if (A.sel !== 'new' && !s) { A.sel = null; return renderAdmin(); }
  const v = s || { label: '', job: '', jobGrade: 0, userCode: '', engineerCode: '', tone: 'bs_alternating', radius: 40, dispatch: true, dispatchDelay: 30, zones: [] };
  const zones = arr(v.zones);
  let zoneInputs = '';
  for (let z = 1; z <= A.maxZones; z++) zoneInputs += `<label class="zone-in"><b>Z${z}</b><input data-zone="${z}" value="${esc(zones[z - 1] || `Zone ${z}`)}" maxlength="40"></label>`;

  main.innerHTML = `
    <h2>${s ? esc(s.label) : 'New system'}</h2>
    <p class="sub">${s ? `System #${s.id}` : 'Save the details first, then place the panel and devices in the world.'}</p>
    <h3>Details</h3>
    <div class="grid">
      <label class="f">Business name<input id="f-label" value="${esc(v.label)}" maxlength="100" placeholder="Burger Shot, Vespucci"></label>
      <label class="f">Owner job<input id="f-job" value="${esc(v.job)}" placeholder="burgershot"></label>
      <label class="f">Minimum grade<input id="f-grade" type="number" min="0" value="${+v.jobGrade || 0}"></label>
      <label class="f">User code (level 2)<input id="f-ucode" value="${esc(v.userCode)}" inputmode="numeric" maxlength="6" placeholder="4–6 digits"></label>
      <label class="f">Engineer code (level 3)<input id="f-ecode" value="${esc(v.engineerCode)}" inputmode="numeric" maxlength="6" placeholder="Optional"></label>
      <label class="f">Sounder tone<select id="f-tone">${A.tones.map(t => `<option value="${t}" ${t === v.tone ? 'selected' : ''}>${TONE_NAMES[t] || t}</option>`).join('')}</select></label>
      <label class="f">Sound range (m)<input id="f-radius" type="number" min="5" max="200" value="${+v.radius}"></label>
      <label class="f check"><input id="f-dispatch" type="checkbox" ${v.dispatch ? 'checked' : ''}>Call fire service (ARC)</label>
      <label class="f">ARC delay (seconds)<input id="f-delay" type="number" min="0" max="600" value="${+v.dispatchDelay}"></label>
    </div>
    <h3>Zone names</h3>
    <div class="grid zones-grid">${zoneInputs}</div>
    <div class="actions">
      <button class="btn primary" id="f-save">${s ? 'Save changes' : 'Create system'}</button>
      ${s ? `<button class="btn danger" id="f-delete">Delete system</button>` : ''}
    </div>
    ${s ? `<h3>Devices</h3><div id="adm-devices"></div><h3>Live status</h3><div id="adm-live"></div>` : ''}`;

  $('#f-save').addEventListener('click', saveSystem);
  if (s) {
    $('#f-delete').addEventListener('click', deleteSystem);
    renderDevices(); renderLive();
  }
}

function renderDevices() {
  const s = curSys(), box = $('#adm-devices');
  if (!s || !box) return;
  const p = A.place, st = s.state || {}, active = arr(st.active);
  const rows = arr(s.devices).map(d => `
    <tr data-dev="${d.id}">
      <td><span class="type"><span class="dev-ico ${d.type}">${TYPE[d.type].ico}</span>${TYPE[d.type].name}</span></td>
      <td><input data-f="label" value="${esc(d.label)}" maxlength="40"></td>
      <td><select data-f="zone">${zoneOptions(d.zone, s)}</select></td>
      <td><span class="tag">${d.mode === 'prop' ? 'Prop' : 'Target'}, ${esc(d.surface || 'wall')}${active.includes(d.id) ? ', <b style="color:#ff6a6a">active</b>' : ''}</span></td>
      <td class="ops">
        <button class="btn sm" data-op="move">Move</button>
        <button class="btn sm" data-op="goto">Go to</button>
        <button class="btn sm danger" data-op="remove">Remove</button>
      </td>
    </tr>`).join('');

  box.innerHTML = `
    <div class="place">
      <label class="f">Device<select id="p-type">${Object.keys(TYPE).map(t => `<option value="${t}" ${t === p.type ? 'selected' : ''}>${TYPE[t].name}</option>`).join('')}</select></label>
      <label class="f">Zone<select id="p-zone">${zoneOptions(p.zone, s)}</select></label>
      <label class="f">Label<input id="p-label" value="${esc(p.label)}" maxlength="40" placeholder="Rear fire exit"></label>
      <label class="f">Placed as<span class="seg"><button data-mode="prop" class="${p.mode === 'prop' ? 'on' : ''}">Prop</button><button data-mode="target" class="${p.mode === 'target' ? 'on' : ''}">Target point</button></span></label>
      <button class="btn primary" id="p-go">Place in world</button>
    </div>
    <p class="hint">Sprinklers go on the ceiling and only operate when a detector in their zone picks up fire or smoke. Aim at a wall or ceiling. Scroll rotates (hold Shift for fine), G toggles surface snap, E or Enter places, Backspace cancels. Sounders are where the alarm is heard from; if a system has none, every device sounds.</p>
    ${rows ? `<table class="dev"><thead><tr><th>Type</th><th>Label</th><th>Zone</th><th>Placement</th><th></th></tr></thead><tbody>${rows}</tbody></table>` : `<p class="hint">No devices yet. Start with the control panel.</p>`}`;

  $('#p-type').addEventListener('change', e => A.place.type = e.target.value);
  $('#p-zone').addEventListener('change', e => A.place.zone = +e.target.value);
  $('#p-label').addEventListener('input', e => A.place.label = e.target.value);
  box.querySelectorAll('.seg button').forEach(b => b.addEventListener('click', () => { A.place.mode = b.dataset.mode; renderDevices(); }));
  $('#p-go').addEventListener('click', () => {
    post('adminPlace', { id: s.id, type: p.type, zone: p.zone, label: p.label, mode: p.mode });
    A.place.label = '';
  });

  box.querySelectorAll('tr[data-dev]').forEach(tr => {
    const devId = +tr.dataset.dev, d = arr(s.devices).find(x => x.id === devId);
    tr.querySelector('[data-f="label"]').addEventListener('change', e => updateDevice(devId, { label: e.target.value }));
    tr.querySelector('[data-f="zone"]').addEventListener('change', e => updateDevice(devId, { zone: +e.target.value }));
    tr.querySelector('[data-op="move"]').addEventListener('click', () => post('adminPlace', { id: s.id, devId, type: d.type, mode: d.mode }));
    tr.querySelector('[data-op="goto"]').addEventListener('click', () => post('adminTeleport', { x: d.x, y: d.y, z: d.z }));
    tr.querySelector('[data-op="remove"]').addEventListener('click', async () => {
      const r = await post('adminDeleteDevice', { id: s.id, devId });
      if (r && r.systems) { A.systems = arr(r.systems); renderList(); renderDevices(); }
    });
  });
}

function renderLive() {
  const s = curSys(), box = $('#adm-live');
  if (!s || !box) return;
  const st = s.state || {}, ss = sysStatus(s);
  const zones = arr(st.zones), events = arr(st.events);
  box.innerHTML = `
    <div class="live">
      <div class="box">
        <div class="status"><span class="led ${ss.led}"></span>${ss.text}</div>
        ${zones.length ? `<div class="hint">In alarm: ${zones.map(z => `Z${z} ${esc(arr(s.zones)[z - 1] || '')}`).join(', ')}</div>` : ''}
        ${arr(st.sprinklers).length ? `<div class="hint" style="color:#7fb8ff">Sprinklers operating: ${arr(st.sprinklers).length} head(s)</div>` : ''}
        <div class="inline"><select id="l-zone">${zoneOptions(1, s)}</select><button class="btn" id="l-trigger">Trigger zone</button></div>
        <div class="inline"><button class="btn" id="l-sounders">Test sounders</button><button class="btn danger" id="l-reset">Force reset</button><button class="btn ghost" id="l-refresh">Refresh</button></div>
        <p class="hint">Force reset clears everything, including call points still latched in alarm.</p>
      </div>
      <div class="box">
        <div class="status">Event log</div>
        <div class="log">${events.length ? events.map(e => `<div><time>${fmtStamp(e.t)}</time>${esc(e.text)}${e.actor ? ` <em>${esc(e.actor)}</em>` : ''}</div>`).join('') : '<div class="hint">Nothing logged since the last restart.</div>'}</div>
      </div>
    </div>`;
  $('#l-trigger').addEventListener('click', async () => {
    const r = await post('adminTrigger', { id: s.id, zone: +$('#l-zone').value });
    if (r && r.systems) { A.systems = arr(r.systems); renderList(); renderLive(); renderDevices(); toast('Zone triggered'); }
  });
  $('#l-sounders').addEventListener('click', async () => {
    const r = await post('adminSounderTest', { id: s.id });
    if (r && r.systems) { A.systems = arr(r.systems); renderList(); renderLive(); toast('Sounders running for a few seconds'); }
  });
  $('#l-reset').addEventListener('click', async () => {
    const r = await post('adminReset', { id: s.id });
    if (r && r.systems) { A.systems = arr(r.systems); renderList(); renderLive(); renderDevices(); toast('System reset'); }
  });
  $('#l-refresh').addEventListener('click', refreshAdmin);
}

async function refreshAdmin() {
  const r = await post('adminRefresh');
  if (r && r.systems) { A.systems = arr(r.systems); renderList(); renderLive(); renderDevices(); }
}

async function updateDevice(devId, fields) {
  const r = await post('adminUpdateDevice', { id: A.sel, devId, fields });
  if (r && r.systems) { A.systems = arr(r.systems); renderList(); renderDevices(); toast('Device updated'); }
}

async function saveSystem() {
  const zones = [];
  document.querySelectorAll('[data-zone]').forEach(i => zones[+i.dataset.zone - 1] = i.value.trim());
  const data = {
    id: A.sel === 'new' ? null : A.sel,
    label: $('#f-label').value.trim(),
    job: $('#f-job').value.trim(),
    jobGrade: +$('#f-grade').value || 0,
    userCode: $('#f-ucode').value.trim(),
    engineerCode: $('#f-ecode').value.trim(),
    tone: $('#f-tone').value,
    radius: +$('#f-radius').value,
    dispatch: $('#f-dispatch').checked,
    dispatchDelay: +$('#f-delay').value,
    zones,
  };
  if (!data.label) return toast('Give the system a business name');
  if (data.userCode && !/^\d{4,6}$/.test(data.userCode)) return toast('User code must be 4 to 6 digits');
  if (data.engineerCode && !/^\d{4,6}$/.test(data.engineerCode)) return toast('Engineer code must be 4 to 6 digits');
  const r = await post('adminSave', data);
  if (!r || !r.ok) return toast((r && r.msg) || 'Save failed');
  const created = A.sel === 'new';
  A.systems = arr(r.systems); A.sel = r.id;
  renderAdmin();
  toast(created ? 'System created. Now place the panel.' : 'Changes saved');
}

async function deleteSystem() {
  const s = curSys();
  if (!s) return;
  const btn = $('#f-delete');
  if (btn.dataset.armed !== '1') { btn.dataset.armed = '1'; btn.textContent = 'Click again to delete'; setTimeout(() => { if (btn.isConnected) { btn.dataset.armed = ''; btn.textContent = 'Delete system'; } }, 3000); return; }
  const r = await post('adminDelete', { id: s.id });
  if (r && r.systems) { A.systems = arr(r.systems); A.sel = null; renderAdmin(); toast('System deleted'); }
}

function openAdmin(d) {
  A.systems = arr(d.systems);
  if (d.maxZones) A.maxZones = d.maxZones;
  if (d.tones) A.tones = arr(d.tones);
  if (d.select !== undefined) A.sel = d.select;
  if (A.sel !== null && A.sel !== 'new' && !curSys()) A.sel = null;
  A.open = true;
  $('#admin').classList.remove('hidden');
  renderAdmin();
}

function closeAdmin(notify = true) {
  if (!A.open) return;
  A.open = false;
  $('#admin').classList.add('hidden');
  if (notify) post('adminClose');
}

$('#adm-new').addEventListener('click', () => { A.sel = 'new'; renderAdmin(); });
$('#adm-close').addEventListener('click', () => closeAdmin());

/* =====================================================================
   MESSAGES + KEYBOARD
   ===================================================================== */
window.addEventListener('message', e => {
  const d = e.data || {};
  switch (d.action) {
    case 'openPanel': openPanel(d); break;
    case 'panelState': if (P.open) setState(d.state); break;
    case 'panelSystem': if (P.open) { P.sys = d.system; render(); } break;
    case 'closePanel': closePanel(false); break;
    case 'sound': Snd.setAlarm(d.volume || 0, d.tone || 'bs_alternating'); break;
    case 'openAdmin': openAdmin(d); break;
    case 'adminShow': openAdmin(d); break;
    case 'adminHide': A.open = false; $('#admin').classList.add('hidden'); if (document.activeElement) document.activeElement.blur(); break;
  }
});

window.addEventListener('keydown', e => {
  if (e.key === 'Escape') { if (P.open) closePanel(); else if (A.open) closeAdmin(); return; }
  if (!P.open) return;
  const map = { Enter: 'ok', Backspace: 'back', ArrowUp: 'up', ArrowDown: 'down', ArrowLeft: 'left', ArrowRight: 'right' };
  const k = /^\d$/.test(e.key) ? e.key : map[e.key];
  if (!k) return;
  e.preventDefault();
  const btn = document.querySelector(`#panel .key[data-k="${k}"]`);
  if (btn) { btn.classList.add('pressed'); setTimeout(() => btn.classList.remove('pressed'), 90); }
  onKey(k);
});
