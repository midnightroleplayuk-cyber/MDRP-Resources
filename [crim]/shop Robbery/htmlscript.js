const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'JW_247robbery';

const $ = (id) => document.getElementById(id);

function post(name, data) {
  return fetch(`https://${RES}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data || {}),
  }).then((r) => r.json()).catch(() => null);
}

let TX = {};

function T(key, def) {
  return TX[key] !== undefined ? TX[key] : def;
}

function fmt(str, v) {
  return String(str).replace('%s', v).replace('%d', v);
}

function fmtMoney(n) {
  return '$' + Number(n || 0).toLocaleString(T('ui_num', 'de-DE'));
}

function applyTexts(t) {
  if (!t) return;
  TX = t;
  const set = (id, key) => {
    const el = $(id);
    if (el && TX[key] !== undefined) el.textContent = TX[key];
  };
  set('lp-title', 'ui_lockpick_title');
  set('lp-keychip', 'ui_lockpick_key');
  set('lp-hint', 'ui_lockpick_hint');
  set('d-title', 'ui_dial_title');
  set('d-turn', 'ui_dial_turn');
  set('d-set', 'ui_dial_set');
  set('d-esc', 'ui_dial_close');
  set('d-sub', 'ui_dial_sub');
  set('s-title', 'ui_shake_title');
  set('s-left', 'ui_shake_left');
  set('s-right', 'ui_shake_right');
  set('s-sub', 'ui_shake_sub');
  set('k-title', 'ui_keypad_title');
  set('k-test', 'ui_keypad_test');
  set('k-del', 'ui_keypad_del');
  set('k-sub', 'ui_keypad_sub');
  set('wi-title', 'ui_wires_title');
  set('wi-sub', 'ui_wires_sub');
  set('g-title', 'ui_grab_title');
  set('g-rlabel', 'ui_grab_risk');
  set('g-hint', 'ui_grab_hint');
  set('g-bag', 'ui_grab_bag');
  set('r-title', 'ui_rummage_title');
  set('r-sub', 'ui_rummage_sub');
  set('sc-title', 'ui_scratch_title');
  set('sc-sub', 'ui_scratch_sub');
}

function hexToRgba(hex, a) {
  const m = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex || '');
  if (!m) return `rgba(62, 224, 122, ${a})`;
  return `rgba(${parseInt(m[1], 16)}, ${parseInt(m[2], 16)}, ${parseInt(m[3], 16)}, ${a})`;
}

function applyColors(c) {
  if (!c) return;
  const r = document.documentElement.style;
  if (c.accent) { r.setProperty('--accent', c.accent); r.setProperty('--accent-zone', hexToRgba(c.accent, 0.3)); }
  if (c.accentDim) r.setProperty('--accent-dim', c.accentDim);
  if (c.danger) r.setProperty('--danger', c.danger);
  if (c.bg) r.setProperty('--bg', c.bg);
  if (c.text) r.setProperty('--text', c.text);
}

function hideAll() {
  $('lockpick').classList.remove('show');
  $('grab').classList.remove('show');
  $('dial').classList.remove('show');
  $('shake').classList.remove('show');
  $('keypad').classList.remove('show');
  $('wires').classList.remove('show');
  $('scratch').classList.remove('show');
  $('rummage').classList.remove('show');
  lp.running = false;
  grab.active = false;
  dial.active = false;
  shake.active = false;
  keypad.active = false;
  wires.active = false;
  scratch.active = false;
  rummage.active = false;
}

/* ---------------- Sounds (WebAudio, keine Dateien noetig) ---------------- */

let AC = null;

function beep(freq, dur, type, gain) {
  try {
    AC = AC || new AudioContext();
    const o = AC.createOscillator();
    const g = AC.createGain();
    o.type = type || 'sine';
    o.frequency.value = freq;
    g.gain.value = gain || 0.05;
    o.connect(g);
    g.connect(AC.destination);
    o.start();
    g.gain.exponentialRampToValueAtTime(0.0001, AC.currentTime + dur);
    o.stop(AC.currentTime + dur);
  } catch (e) {}
}

const snd = {
  tick: () => beep(1500, 0.045, 'square', 0.028),
  click: () => { beep(300, 0.09, 'square', 0.09); beep(150, 0.12, 'sine', 0.07); },
  good: () => { beep(520, 0.1, 'sine', 0.06); setTimeout(() => beep(780, 0.14, 'sine', 0.06), 90); },
  bad: () => beep(120, 0.28, 'sawtooth', 0.07),
  win: () => { beep(520, 0.1, 'sine', 0.07); setTimeout(() => beep(660, 0.1, 'sine', 0.07), 100); setTimeout(() => beep(880, 0.2, 'sine', 0.07), 200); },
};

/* ---------------- Status Widget ---------------- */

let widgetTimer = null;

let camsLabel = 'Kameras';

function widgetCams(value, dead) {
  const el = $('w-cams');
  if (!value) {
    el.style.display = 'none';
    return;
  }
  el.style.display = '';
  el.textContent = camsLabel + ' ' + value;
  el.className = 'w-cams ' + (dead ? 'off' : 'on');
}

function widgetLabel(id, text, bonus) {
  const el = $(id);
  el.textContent = text || '';
  if (bonus) {
    const b = document.createElement('span');
    b.className = 'w-bonus';
    b.textContent = bonus;
    el.appendChild(b);
  }
}

function widgetShow(msg) {
  clearTimeout(widgetTimer);
  const L = msg.labels || {};
  $('w-title').textContent = msg.label ? msg.title + ' · ' + msg.label : msg.title;
  $('w-police').textContent = msg.police || '';
  $('w-police').style.display = msg.police ? '' : 'none';
  $('w-step').textContent = msg.step || '';
  $('w-step').classList.remove('warn');
  widgetLabel('wl-regs', L.regs);
  widgetLabel('wl-shelf', L.shelf, L.bonus);
  widgetLabel('wl-vend', L.vend, L.bonus);
  widgetLabel('wl-safe', L.safe, L.bonus);
  widgetLabel('wl-loot', L.loot);
  camsLabel = L.cams || 'Kameras';
  $('wv-regs').textContent = msg.regs || '';
  $('wv-shelf').textContent = msg.shelf || '';
  $('wc-shelf').style.display = msg.shelf ? '' : 'none';
  $('wv-vend').textContent = msg.vend || '';
  $('wc-vend').style.display = msg.vend ? '' : 'none';
  $('wv-safe').textContent = msg.safe || '';
  $('wc-safe').style.display = msg.safe ? '' : 'none';
  widgetCams(msg.cams, msg.camsDead);
  $('w-perfect').textContent = msg.perfect || '';
  $('w-perfect').style.display = msg.perfect ? '' : 'none';
  $('wv-loot').textContent = fmtMoney(msg.loot);
  $('widget').classList.add('show');
}

function widgetUpdate(msg) {
  if (msg.step !== undefined) $('w-step').textContent = msg.step;
  if (msg.warn !== undefined) $('w-step').classList.toggle('warn', msg.warn === true);
  if (msg.regs !== undefined) $('wv-regs').textContent = msg.regs;
  if (msg.shelf !== undefined) $('wv-shelf').textContent = msg.shelf;
  if (msg.vend !== undefined) $('wv-vend').textContent = msg.vend;
  if (msg.safe !== undefined) $('wv-safe').textContent = msg.safe;
  if (msg.cams !== undefined) widgetCams(msg.cams, msg.camsDead);
  if (msg.loot !== undefined) $('wv-loot').textContent = fmtMoney(msg.loot);
}

function widgetEnd(msg) {
  $('w-step').textContent = msg.step || '';
  $('w-step').classList.remove('warn');
  if (msg.loot !== undefined) $('wv-loot').textContent = fmtMoney(msg.loot);
  $('w-police').style.display = 'none';
  $('w-cams').style.display = 'none';
  $('w-perfect').style.display = 'none';
  clearTimeout(widgetTimer);
  widgetTimer = setTimeout(() => $('widget').classList.remove('show'), 3500);
}

/* ---------------- Lockpick ---------------- */

const lp = {
  running: false,
  ctx: null,       // { shopId, regIdx }
  cfg: null,
  pin: 0,
  attempts: 0,
  pos: 0,
  dir: 1,
  speed: 0,
  zoneStart: 0,
  zoneWidth: 0,
  locked: false,   // kurze Sperre nach Treffer/Fehlversuch
};

function lpRenderPins() {
  const el = $('lp-pins');
  el.innerHTML = '';
  for (let i = 0; i < lp.cfg.pins; i++) {
    const d = document.createElement('div');
    d.className = 'pin' + (i < lp.pin ? ' set' : i === lp.pin ? ' active' : '');
    el.appendChild(d);
  }
  $('lp-tries').textContent = '✕'.repeat(lp.attempts);
}

function lpNewZone() {
  lp.zoneWidth = Math.max(6, lp.cfg.window * Math.pow(0.85, lp.pin));
  lp.zoneStart = 5 + Math.random() * (90 - lp.zoneWidth);
  const z = $('lp-zone');
  z.style.left = lp.zoneStart + '%';
  z.style.width = lp.zoneWidth + '%';
  lp.speed = (0.9 + lp.pin * 0.25) * lp.cfg.speed;
  lp.pos = 0;
  lp.dir = 1;
}

function lpStart(msg) {
  lp.cfg = msg.cfg;
  lp.ctx = { shopId: msg.shopId, regIdx: msg.regIdx };
  lp.pin = 0;
  lp.attempts = msg.cfg.attempts;
  lp.running = true;
  lp.locked = false;
  lpRenderPins();
  lpNewZone();
  $('lockpick').classList.add('show');
  lp.last = performance.now();
  requestAnimationFrame(lpTick);
}

function lpTick() {
  if (!lp.running) return;
  // an die Zeit gekoppelt, sonst laeuft der Balken auf 144 Hz doppelt so schnell
  const now = performance.now();
  const step = Math.min(50, now - (lp.last || now)) / (1000 / 60);
  lp.last = now;
  if (!lp.locked) {
    lp.pos += lp.speed * lp.dir * step;
    if (lp.pos >= 100) { lp.pos = 100; lp.dir = -1; }
    if (lp.pos <= 0) { lp.pos = 0; lp.dir = 1; }
    $('lp-cursor').style.left = `calc(${lp.pos}% - 2px)`;
  }
  requestAnimationFrame(lpTick);
}

function lpFinish(success) {
  lp.running = false;
  hideAll();
  post('lockpickDone', { success, shopId: lp.ctx.shopId, regIdx: lp.ctx.regIdx });
}

function lpPress() {
  if (!lp.running || lp.locked) return;
  const inZone = lp.pos >= lp.zoneStart && lp.pos <= lp.zoneStart + lp.zoneWidth;
  const panel = document.querySelector('#lockpick .panel');
  lp.locked = true;
  if (inZone) {
    lp.pin++;
    panel.classList.remove('flash-good');
    void panel.offsetWidth;
    panel.classList.add('flash-good');
    lpRenderPins();
    if (lp.pin >= lp.cfg.pins) return lpFinish(true);
    setTimeout(() => { lpNewZone(); lp.locked = false; }, 300);
  } else {
    lp.attempts--;
    panel.classList.remove('flash-bad');
    void panel.offsetWidth;
    panel.classList.add('flash-bad');
    lpRenderPins();
    if (lp.attempts <= 0) return lpFinish(false);
    setTimeout(() => { lp.locked = false; }, 300);
  }
}

/* ---------------- Geldgriff ---------------- */

const grab = {
  active: false,
  ctx: null,
  busy: false,
  done: false,
};

function grabRenderStacks(count) {
  const el = $('g-stacks');
  el.innerHTML = '';
  for (let i = 0; i < count; i++) {
    const s = document.createElement('div');
    s.className = 'stack';
    s.textContent = '💵';
    s.addEventListener('click', () => grabOne(s));
    el.appendChild(s);
  }
}

function grabSetRisk(pct) {
  $('g-risk').style.width = Math.min(100, pct) + '%';
  $('g-pct').textContent = pct + '%';
}

function grabStart(msg) {
  grab.active = true;
  grab.ctx = { shopId: msg.shopId, regIdx: msg.regIdx };
  grab.busy = false;
  grab.done = false;
  $('g-total').textContent = fmtMoney(msg.info.total);
  $('g-msg').textContent = '';
  $('g-msg').className = 'g-msg';
  grabSetRisk(msg.info.chance);
  grabRenderStacks(msg.info.left);
  $('grab').classList.add('show');
}

async function grabOne(stackEl) {
  if (!grab.active || grab.busy || grab.done) return;
  grab.busy = true;
  const res = await post('grabOne', grab.ctx);
  grab.busy = false;
  if (!res) return;

  stackEl.classList.add('taken');

  if (res.dye) {
    grab.done = true;
    const msg = $('g-msg');
    msg.textContent = fmt(T('ui_grab_dye', 'Färbepatrone geplatzt! Behalten: %s'), fmtMoney(res.kept));
    msg.className = 'g-msg bad';
    grabSetRisk(100);
    return;
  }
  if (res.empty) {
    grab.done = true;
    $('g-total').textContent = fmtMoney(res.total);
    const msg = $('g-msg');
    msg.textContent = fmt(T('ui_grab_empty', 'Kasse leer. Beute: %s'), fmtMoney(res.total));
    msg.className = 'g-msg good';
    return;
  }

  $('g-total').textContent = fmtMoney(res.total);
  const msg = $('g-msg');
  msg.textContent = '+' + fmtMoney(res.value);
  msg.className = 'g-msg good';
  grabSetRisk(res.chance);
}

function grabBag() {
  if (!grab.active || grab.busy || grab.done) return;
  grab.active = false;
  post('grabStop', grab.ctx);
}

$('g-bag').addEventListener('click', grabBag);

/* ---------------- Tresor Dial ---------------- */

const dial = {
  active: false,
  pos: 0,
  lastInt: -1,
  restTimer: null,
  keys: { left: null, right: null },
  stages: 3,
  stage: 1,
  maxStrikes: 3,
  strikes: 0,
  locked: false,
  lastTs: 0,
  speedMul: 1,
};

function dialBuildDisc() {
  const disc = $('d-disc');
  if (disc.dataset.built) return;
  disc.dataset.built = '1';
  for (let i = 0; i < 100; i++) {
    const t = document.createElement('div');
    t.className = 'd-tick' + (i % 10 === 0 ? ' big' : '');
    t.style.transform = `rotate(${i * 3.6}deg)`;
    disc.appendChild(t);
  }
  for (let i = 0; i < 10; i++) {
    const l = document.createElement('div');
    l.className = 'd-label';
    l.style.transform = `rotate(${i * 36}deg)`;
    l.innerHTML = `<span>${i * 10}</span>`;
    disc.appendChild(l);
  }
}

function dialNudge(dir) {
  if (!dial.active || dial.locked) return;
  dial.pos += dir;
}

function dialRenderStages() {
  const el = $('d-stages');
  el.innerHTML = '';
  for (let i = 1; i <= dial.stages; i++) {
    const d = document.createElement('div');
    d.className = 'd-stage' + (i < dial.stage ? ' set' : i === dial.stage ? ' active' : '');
    el.appendChild(d);
  }
  $('d-strikes').textContent = '✕'.repeat(dial.strikes);
}

function dialStart(msg) {
  dialBuildDisc();
  dial.active = true;
  dial.pos = 0;
  dial.lastInt = -1;
  dial.stages = msg.cfg.numbers || 3;
  dial.stage = msg.cfg.stage || 1;
  dial.maxStrikes = msg.cfg.strikes || 3;
  dial.strikes = msg.cfg.used || 0;
  dial.locked = false;
  dial.lastTs = 0;
  dial.speedMul = msg.cfg.speed || 1;
  dial.keys = { left: null, right: null };
  $('d-msg').textContent = '';
  $('d-msg').className = 'd-msg';
  dialRenderStages();
  $('dial').classList.add('show');
  requestAnimationFrame(dialTick);
}

function dialCurrent() {
  return ((Math.round(dial.pos) % 100) + 100) % 100;
}

function dialTick(ts) {
  if (!dial.active) return;
  const dt = dial.lastTs ? Math.min(0.05, (ts - dial.lastTs) / 1000) : 0;
  dial.lastTs = ts;

  // Tippen = 1 Schritt (in dialNudge), Halten ab 300 ms = gemuetliches Weiterdrehen
  if (!dial.locked) {
    const now = performance.now();
    const spd = 8 * dial.speedMul;
    if (dial.keys.left && now - dial.keys.left > 300) dial.pos -= spd * dt;
    if (dial.keys.right && now - dial.keys.right > 300) dial.pos += spd * dt;
  }

  const num = dialCurrent();
  $('d-num').textContent = num;
  $('d-disc').style.transform = `rotate(${-dial.pos * 3.6}deg)`;

  // Feedback gibt es nur, wenn das Rad kurz auf einer Zahl ruht
  if (num !== dial.lastInt) {
    dial.lastInt = num;
    clearTimeout(dial.restTimer);
    dial.restTimer = setTimeout(() => {
      if (dial.active && !dial.locked) post('dialPos', { pos: num });
    }, 160);
  }

  requestAnimationFrame(dialTick);
}

function dialFeedback(level) {
  if (!dial.active) return;
  const ring = $('d-ring');
  const wrap = document.querySelector('.dial-wrap');
  if (level >= 2) {
    snd.click();
    ring.classList.remove('hit');
    void ring.offsetWidth;
    ring.classList.add('hit');
    wrap.classList.remove('bump');
    void wrap.offsetWidth;
    wrap.classList.add('bump');
    setTimeout(() => ring.classList.remove('hit'), 350);
  } else if (level === 1) {
    snd.tick();
    ring.classList.remove('warm');
    void ring.offsetWidth;
    ring.classList.add('warm');
    setTimeout(() => ring.classList.remove('warm'), 250);
  }
}

async function dialLock() {
  if (!dial.active || dial.locked) return;
  dial.locked = true;
  const res = await post('dialLock', { pos: dialCurrent() });
  if (!res) { dial.locked = false; return; }

  const msg = $('d-msg');
  if (res.result === 'ok') {
    snd.good();
    dial.stage = res.stage;
    dialRenderStages();
    // Rad springt zurueck auf 0, die naechste Zahl wird von vorne abgehoert
    dial.pos = 0;
    dial.lastInt = -1;
    msg.textContent = T('ui_dial_ok', 'Zahl sitzt, weiter drehen');
    msg.className = 'd-msg good';
    setTimeout(() => { msg.textContent = ''; dial.locked = false; }, 700);
  } else if (res.result === 'done') {
    snd.win();
    dial.stage = dial.stages + 1;
    dialRenderStages();
    msg.textContent = fmt(T('ui_dial_open', 'Tresor offen! +%s'), fmtMoney(res.paid));
    msg.className = 'd-msg good';
    dial.active = false;
  } else if (res.result === 'strike') {
    snd.bad();
    dial.strikes = res.used;
    dialRenderStages();
    msg.textContent = T('ui_dial_wrong', 'Falsche Zahl!');
    msg.className = 'd-msg bad';
    setTimeout(() => { msg.textContent = ''; dial.locked = false; }, 700);
  } else if (res.result === 'fail') {
    snd.bad();
    msg.textContent = T('ui_dial_blocked', 'Der Mechanismus blockiert!');
    msg.className = 'd-msg bad';
    dial.active = false;
  } else {
    dial.locked = false;
  }
}

/* ---------------- Suchbalken ---------------- */

function searchShow(msg) {
  $('sr-label').textContent = msg.label || '';
  const fill = $('sr-fill');
  fill.style.transition = 'none';
  fill.style.width = '0%';
  void fill.offsetWidth;
  fill.style.transition = `width ${msg.time || 4}s linear`;
  fill.style.width = '100%';
  $('search').classList.add('show');
}

function searchHide() {
  $('search').classList.remove('show');
}

/* ---------------- Regal durchwuehlen ---------------- */

const RUMMAGE_KEYS = ['W', 'A', 'S', 'D'];

const rummage = {
  active: false,
  ctx: null,
  total: 6,
  index: 0,
  hits: 0,
  window: 0.9,
  speedup: 0.92,
  curWindow: 0.9,
  deadline: 0,
  currentKey: '',
  locked: false,
};

function rummageRenderPips(resultForCurrent) {
  const el = $('r-pips');
  if (el.children.length !== rummage.total) {
    el.innerHTML = '';
    for (let i = 0; i < rummage.total; i++) {
      const p = document.createElement('div');
      p.className = 'r-pip';
      el.appendChild(p);
    }
  }
  if (resultForCurrent) {
    el.children[rummage.index].classList.add(resultForCurrent);
  }
}

function rummageNextKey() {
  rummage.currentKey = RUMMAGE_KEYS[Math.floor(Math.random() * RUMMAGE_KEYS.length)];
  $('r-key').textContent = rummage.currentKey;
  $('r-key').className = 'r-key';
  rummage.deadline = performance.now() + rummage.curWindow * 1000;
  rummage.locked = false;
}

function rummageStart(msg) {
  rummage.active = true;
  rummage.ctx = { shopId: msg.shopId, idx: msg.idx };
  rummage.total = msg.cfg.keys || 6;
  rummage.index = 0;
  rummage.hits = 0;
  rummage.window = msg.cfg.window || 0.9;
  rummage.speedup = msg.cfg.speedup || 0.92;
  rummage.curWindow = rummage.window;
  $('r-pips').innerHTML = '';
  rummageRenderPips();
  $('rummage').classList.add('show');
  rummageNextKey();
  requestAnimationFrame(rummageTick);
}

function rummageFinish(aborted) {
  rummage.active = false;
  const ctx = rummage.ctx;
  const hits = rummage.hits;
  if (aborted) {
    hideAll();
    post('shelfDone', { shopId: ctx.shopId, idx: ctx.idx, hits: hits, aborted: true });
    return;
  }
  setTimeout(() => {
    hideAll();
    post('shelfDone', { shopId: ctx.shopId, idx: ctx.idx, hits: hits });
  }, 500);
}

function rummageAdvance(result) {
  rummageRenderPips(result);
  $('r-key').classList.add(result);
  if (result === 'hit') {
    rummage.hits++;
    rummage.curWindow *= rummage.speedup;
    beep(700 + rummage.hits * 60, 0.05, 'square', 0.04);
  } else {
    snd.bad();
  }
  rummage.index++;
  rummage.locked = true;
  if (rummage.index >= rummage.total) {
    rummageFinish();
  } else {
    setTimeout(() => { if (rummage.active) rummageNextKey(); }, 260);
  }
}

function rummageTick() {
  if (!rummage.active) return;
  if (!rummage.locked) {
    const left = rummage.deadline - performance.now();
    $('r-timer').style.width = Math.max(0, (left / (rummage.curWindow * 1000)) * 100) + '%';
    if (left <= 0) rummageAdvance('miss');
  }
  requestAnimationFrame(rummageTick);
}

function rummagePress(letter) {
  if (!rummage.active || rummage.locked) return;
  rummageAdvance(letter === rummage.currentKey ? 'hit' : 'miss');
}

/* ---------------- Rubbellos ---------------- */

const scratch = { active: false, amount: 0, cleared: false, claimed: false, drawing: false, strokes: 0 };

function scratchClaimNow() {
  if (scratch.claimed) return;
  scratch.claimed = true;
  const amount = scratch.amount;
  hideAll();
  post('scratchClaim', { amount });
}

function scratchStart(msg) {
  scratch.active = true;
  scratch.amount = msg.amount || 0;
  scratch.cleared = false;
  scratch.claimed = false;
  scratch.drawing = false;
  scratch.strokes = 0;
  scratch.winText = msg.win || 'Gewonnen: %s!';
  scratch.loseText = msg.lose || 'Niete';

  const prize = $('sc-prize');
  prize.textContent = scratch.amount > 0 ? fmtMoney(scratch.amount) : T('ui_scratch_blank', 'NIETE');
  prize.className = 'sc-prize ' + (scratch.amount > 0 ? 'good' : 'bad');

  const cv = $('sc-canvas');
  const ctx = cv.getContext('2d');
  ctx.globalCompositeOperation = 'source-over';
  const grad = ctx.createLinearGradient(0, 0, 260, 110);
  grad.addColorStop(0, '#9aa2a9');
  grad.addColorStop(1, '#5f686f');
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, 260, 110);
  ctx.fillStyle = 'rgba(0, 0, 0, 0.25)';
  ctx.font = 'bold 16px sans-serif';
  ctx.textAlign = 'center';
  ctx.fillText(T('ui_scratch_foil', 'HIER RUBBELN'), 130, 62);
  ctx.globalCompositeOperation = 'destination-out';

  $('scratch').classList.add('show');
}

function scratchReveal() {
  if (scratch.cleared) return;
  scratch.cleared = true;
  const cv = $('sc-canvas');
  cv.getContext('2d').clearRect(0, 0, 260, 110);
  if (scratch.amount > 0) snd.win(); else snd.bad();
  setTimeout(scratchClaimNow, 1100);
}

function scratchCheck() {
  try {
    const ctx = $('sc-canvas').getContext('2d');
    const img = ctx.getImageData(0, 0, 260, 110).data;
    let clear = 0, total = 0;
    for (let i = 3; i < img.length; i += 4 * 10) {
      total++;
      if (img[i] === 0) clear++;
    }
    if (clear / total > 0.4) scratchReveal();
  } catch (e) {
    // falls das Auslesen klemmt, greift der Zaehler-Fallback
  }
}

(function bindScratch() {
  const cv = $('sc-canvas');
  cv.addEventListener('mousedown', () => { scratch.drawing = true; });
  window.addEventListener('mouseup', () => { scratch.drawing = false; });
  cv.addEventListener('mousemove', (e) => {
    if (!scratch.active || !scratch.drawing || scratch.cleared) return;
    const r = cv.getBoundingClientRect();
    const ctx = cv.getContext('2d');
    ctx.beginPath();
    ctx.arc(e.clientX - r.left, e.clientY - r.top, 14, 0, Math.PI * 2);
    ctx.fill();
    scratch.strokes++;
    if (scratch.strokes % 3 === 0) {
      beep(400 + Math.random() * 200, 0.03, 'square', 0.012);
      scratchCheck();
    }
    if (scratch.strokes > 70) scratchReveal();
  });
})();

/* ---------------- Stromkasten ---------------- */

const WIRE_COLORS = ['#d84b4b', '#4b7bd8', '#d8c04b', '#4bd87e', '#b04bd8', '#d8874b', '#4bcdd8', '#8a8f93'];

const wires = {
  active: false,
  ctx: null,
  busy: false,
  done: false,
};

function wiresStart(msg) {
  wires.active = true;
  wires.ctx = { shopId: msg.shopId };
  wires.busy = false;
  wires.done = false;
  $('wi-msg').textContent = '';
  $('wi-msg').className = 'd-msg';
  const list = $('wire-list');
  list.innerHTML = '';
  (msg.cfg.values || []).forEach((val, i) => {
    const row = document.createElement('div');
    row.className = 'wire-row';
    const band = document.createElement('div');
    band.className = 'wire-band';
    band.style.background = WIRE_COLORS[i % WIRE_COLORS.length];
    const v = document.createElement('div');
    v.className = 'wire-val';
    v.textContent = val + ' V';
    row.appendChild(v);
    row.appendChild(band);
    row.addEventListener('click', () => wireCut(i + 1, row));
    list.appendChild(row);
  });
  $('wires').classList.add('show');
}

async function wireCut(idx, row) {
  if (!wires.active || wires.busy || wires.done) return;
  wires.busy = true;
  const res = await post('wireCut', { shopId: wires.ctx.shopId, idx });
  wires.busy = false;
  if (!res) return;

  const msg = $('wi-msg');
  if (res.ok) {
    snd.click();
    row.classList.add('cut');
    if (res.done) {
      snd.win();
      wires.done = true;
      msg.textContent = T('ui_wires_done', 'Der Kasten ist tot. Kameras und Alarm sind lahmgelegt');
      msg.className = 'd-msg good';
    }
  } else {
    snd.bad();
    wires.done = true;
    const panel = document.querySelector('.wires-panel');
    panel.classList.remove('flash-bad');
    void panel.offsetWidth;
    panel.classList.add('flash-bad');
    msg.textContent = T('ui_wires_fail', 'Falsche Leitung! Funken schlagen aus dem Kasten');
    msg.className = 'd-msg bad';
  }
}

/* ---------------- Automat ruetteln ---------------- */

const shake = {
  active: false,
  ctx: null,
  phase: 0,
  speed: 1,
  pushes: 0,
  needed: 6,
  tilt: 0,
  tiltLimit: 3,
  lastTs: 0,
  ending: false,
};

function shakeRender() {
  const el = $('s-pushes');
  el.innerHTML = '';
  for (let i = 0; i < shake.needed; i++) {
    const d = document.createElement('div');
    d.className = 's-push' + (i < shake.pushes ? ' set' : '');
    el.appendChild(d);
  }
  $('s-tilt').textContent = '✕'.repeat(shake.tilt);
}

function shakeStart(msg) {
  shake.active = true;
  shake.ctx = { shopId: msg.shopId, key: msg.key };
  shake.phase = 0;
  shake.speed = msg.cfg.speed || 1;
  shake.pushes = 0;
  shake.needed = msg.cfg.pushes || 6;
  shake.tilt = 0;
  shake.tiltLimit = msg.cfg.tiltLimit || 3;
  shake.lastTs = 0;
  shake.ending = false;
  $('s-msg').textContent = '';
  $('s-msg').className = 'd-msg';
  shakeRender();
  $('shake').classList.add('show');
  requestAnimationFrame(shakeTick);
}

function shakePos() {
  return Math.sin(shake.phase); // -1 links, +1 rechts
}

function shakeTick(ts) {
  if (!shake.active) return;
  const dt = shake.lastTs ? Math.min(0.05, (ts - shake.lastTs) / 1000) : 0;
  shake.lastTs = ts;
  shake.phase += dt * 2.4 * shake.speed * (1 + shake.pushes * 0.08);

  const track = $('s-weight').parentElement.clientWidth;
  const x = (shakePos() + 1) / 2; // 0..1
  $('s-weight').style.left = `calc(${(x * 100).toFixed(1)}% - ${(x * 26).toFixed(0)}px)`;

  requestAnimationFrame(shakeTick);
}

function shakeEnd(success) {
  if (shake.ending) return;
  shake.ending = true;
  shake.active = false;
  setTimeout(() => post('shakeDone', { success, shopId: shake.ctx.shopId, key: shake.ctx.key }), 900);
}

function shakePush(side) {
  if (!shake.active || shake.ending) return;
  const pos = shakePos();
  const good = side === 'left' ? pos < -0.7 : pos > 0.7;
  const panel = document.querySelector('.shake-panel');
  panel.classList.remove('wobble');
  void panel.offsetWidth;
  panel.classList.add('wobble');

  if (good) {
    snd.click();
    shake.pushes++;
    shakeRender();
    if (shake.pushes >= shake.needed) {
      snd.win();
      $('s-msg').textContent = T('ui_shake_win', 'Der Automat gibt nach!');
      $('s-msg').className = 'd-msg good';
      shakeEnd(true);
    }
  } else {
    snd.bad();
    shake.tilt++;
    shakeRender();
    if (shake.tilt >= shake.tiltLimit) {
      $('s-msg').textContent = T('ui_shake_fall', 'Er kippt!');
      $('s-msg').className = 'd-msg bad';
      shakeEnd(false);
    }
  }
}

/* ---------------- Keypad ---------------- */

const keypad = {
  active: false,
  ctx: null,
  worn: [],
  entry: [],
  busy: false,
  attempts: 4,
  used: 0,
};

function keypadRenderDisplay() {
  const el = $('k-display');
  el.innerHTML = '';
  for (let i = 0; i < 4; i++) {
    const s = document.createElement('div');
    s.className = 'k-slot';
    s.textContent = keypad.entry[i] !== undefined ? keypad.entry[i] : '';
    el.appendChild(s);
  }
  $('k-tries').textContent = '✕'.repeat(keypad.used);
}

function keypadBuildGrid() {
  const el = $('k-grid');
  el.innerHTML = '';
  const order = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  for (const n of order) {
    const b = document.createElement('button');
    b.className = 'k-btn' + (keypad.worn.includes(n) ? ' worn' : '') + (n === 0 ? ' zero' : '');
    b.textContent = n;
    b.addEventListener('click', () => keypadPress(n));
    el.appendChild(b);
  }
}

function keypadStart(msg) {
  keypad.active = true;
  keypad.ctx = { shopId: msg.shopId };
  keypad.worn = msg.cfg.worn || [];
  keypad.entry = [];
  keypad.busy = false;
  keypad.attempts = msg.cfg.attempts || 4;
  keypad.used = msg.cfg.used || 0;
  $('k-msg').textContent = '';
  $('k-msg').className = 'd-msg';
  keypadBuildGrid();
  keypadRenderDisplay();
  $('keypad').classList.add('show');
}

function keypadPress(n) {
  if (!keypad.active || keypad.busy) return;
  if (keypad.entry.length >= 4) return;
  keypad.entry.push(n);
  beep(900 + n * 40, 0.05, 'square', 0.03);
  keypadRenderDisplay();
}

async function keypadSubmit() {
  if (!keypad.active || keypad.busy || keypad.entry.length !== 4) return;
  keypad.busy = true;
  const res = await post('keypadTry', { digits: keypad.entry });
  if (!res) { keypad.busy = false; return; }

  const msg = $('k-msg');
  if (res.result === 'open') {
    snd.win();
    msg.textContent = T('ui_keypad_open', 'Sperre offen!');
    msg.className = 'd-msg good';
    keypad.active = false;
  } else if (res.result === 'lockout') {
    snd.bad();
    msg.textContent = T('ui_keypad_locked', 'Gesperrt! Zu viele Fehlversuche');
    msg.className = 'd-msg bad';
    keypad.active = false;
  } else if (res.result === 'wrong') {
    snd.bad();
    keypad.used = res.used;
    msg.textContent = fmt(T('ui_keypad_wrong', '%d von 4 richtig platziert'), res.correct);
    msg.className = 'd-msg bad';
    keypad.entry = [];
    keypadRenderDisplay();
    keypad.busy = false;
  } else {
    keypad.busy = false;
  }
}

function keypadBack() {
  if (!keypad.active || keypad.busy) return;
  keypad.entry.pop();
  keypadRenderDisplay();
}

/* ---------------- Events ---------------- */

window.addEventListener('message', (e) => {
  const msg = e.data || {};
  applyColors(msg.colors);
  if (msg.texts) applyTexts(msg.texts);
  if (msg.action === 'lockpick') { hideAll(); lpStart(msg); }
  else if (msg.action === 'grab') { hideAll(); grabStart(msg); }
  else if (msg.action === 'dial') { hideAll(); dialStart(msg); }
  else if (msg.action === 'shake') { hideAll(); shakeStart(msg); }
  else if (msg.action === 'keypad') { hideAll(); keypadStart(msg); }
  else if (msg.action === 'wires') { hideAll(); wiresStart(msg); }
  else if (msg.action === 'scratch') { hideAll(); scratchStart(msg); }
  else if (msg.action === 'rummage') { hideAll(); rummageStart(msg); }
  else if (msg.action === 'search') searchShow(msg);
  else if (msg.action === 'searchStop') searchHide();
  else if (msg.action === 'dialFeedback') dialFeedback(msg.level);
  else if (msg.action === 'hide') hideAll();
  else if (msg.action === 'widget') widgetShow(msg);
  else if (msg.action === 'widgetUpdate') widgetUpdate(msg);
  else if (msg.action === 'widgetEnd') widgetEnd(msg);
});

window.addEventListener('keydown', (e) => {
  if (rummage.active) {
    const map = { KeyW: 'W', KeyA: 'A', KeyS: 'S', KeyD: 'D' };
    if (map[e.code]) { rummagePress(map[e.code]); return; }
    if (e.code === 'Escape') { rummageFinish(true); return; }
    return;
  }

  if (e.code === 'KeyA' || e.code === 'ArrowLeft') {
    if (!e.repeat) {
      if (shake.active) shakePush('left');
      else { dialNudge(-1); dial.keys.left = performance.now(); }
    }
  }
  if (e.code === 'KeyD' || e.code === 'ArrowRight') {
    if (!e.repeat) {
      if (shake.active) shakePush('right');
      else { dialNudge(1); dial.keys.right = performance.now(); }
    }
  }

  if (keypad.active) {
    const m = /^(?:Digit|Numpad)(\d)$/.exec(e.code);
    if (m) { keypadPress(parseInt(m[1], 10)); return; }
    if (e.code === 'Backspace') { e.preventDefault(); keypadBack(); return; }
    if (e.code === 'Enter' || e.code === 'NumpadEnter') { keypadSubmit(); return; }
    if (e.code === 'Escape') { hideAll(); post('keypadClose'); return; }
  }

  if (e.code === 'Space') {
    e.preventDefault();
    lpPress();
  } else if (e.code === 'Enter' || e.code === 'NumpadEnter') {
    if (dial.active) dialLock();
    else if (grab.active) grabBag();
  } else if (e.code === 'Escape' || e.code === 'Backspace') {
    if (lp.running) {
      lpFinish(false);
    } else if (dial.active) {
      hideAll();
      post('dialClose');
    } else if (shake.active && !shake.ending) {
      const ctx = shake.ctx;
      hideAll();
      post('shakeCancel', ctx);
    } else if (wires.active && !wires.done) {
      const ctx = wires.ctx;
      hideAll();
      post('wiresClose', ctx);
    } else if (scratch.active) {
      if (scratch.strokes === 0 && !scratch.cleared) {
        scratch.claimed = true;
        hideAll();
        post('scratchCancel');
      } else {
        scratchClaimNow();
      }
    } else if (grab.active && !grab.done) {
      grabBag();
    } else {
      hideAll();
      post('close');
    }
  }
});

window.addEventListener('keyup', (e) => {
  if (e.code === 'KeyA' || e.code === 'ArrowLeft') dial.keys.left = null;
  if (e.code === 'KeyD' || e.code === 'ArrowRight') dial.keys.right = null;
});

window.addEventListener('wheel', (e) => {
  if (dial.active && !dial.locked) {
    dial.pos += e.deltaY > 0 ? 1 : -1;
  }
});
