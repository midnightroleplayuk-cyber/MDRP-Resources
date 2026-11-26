const $ = (id) => document.getElementById(id);
const params = new URLSearchParams(location.search);
const mode = params.has('screen') ? 'screen' : params.has('panel') ? 'panel' : 'hud';
if (mode !== 'hud') document.body.classList.add(mode);

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text === undefined || text === null ? '' : String(text);
  return div.innerHTML;
}

const headRow = '<th></th>' + Array.from({ length: 10 }, (_, i) => `<th>${i + 1}</th>`).join('') + '<th>Total</th>';

function cell(frame, last) {
  const slots = last ? 3 : 2;
  const marks = frame.marks || [];
  let html = '';
  for (let i = 0; i < slots; i++) {
    const m = marks[i] || '';
    html += `<span class="${m === 'X' || m === '/' ? 'hot' : ''}">${m}</span>`;
  }
  const sum = frame.score === undefined || frame.score === null ? '' : frame.score;
  return `<td class="frame${last ? ' last' : ''}"><div class="marks">${html}</div><div class="sum">${sum}</div></td>`;
}

function boardHtml(board) {
  const status = board.status === 'lobby' ? 'Waiting to start' : board.status === 'finished' ? 'Final scores' : '';
  const rows = board.rows.map((row) => {
    const frames = [];
    for (let f = 0; f < 10; f++) frames.push(cell((row.frames && row.frames[f]) || {}, f === 9));
    return `<tr class="${row.active ? 'active' : ''}"><td class="name">${escapeHtml(row.name)}</td>${frames.join('')}<td class="total">${row.total}</td></tr>`;
  }).join('');
  return `<header><span class="lane-name">Lane ${board.lane}</span><span>${status}</span></header>` +
    `<table><thead><tr>${headRow}</tr></thead><tbody>${rows}</tbody></table>`;
}

// Scoresheet in the corner of the player's own screen.
function renderHud(board) {
  const el = $('board');
  if (!board) { el.hidden = true; return; }
  el.innerHTML = boardHtml(board);
  el.hidden = false;
}

function openHtml(lane) {
  return `<div class="open"><img src="logo.png" alt="RSVX Developments">` +
    `<div class="lane"><em>Lane</em><strong>${escapeHtml(lane)}</strong></div><span>Open</span></div>`;
}

// Overhead scoreboard: one pane per lane it covers.
function screenPane(p) {
  return p.board ? `<div class="board">${boardHtml(p.board)}</div>` : openHtml(p.lane);
}

// Control panel: who is up, and what they are on.
function panelPane(p) {
  const tag = `<div class="tag">Lane <b>${escapeHtml(p.lane)}</b></div>`;
  if (p.status === 'playing' && p.now) {
    return `<div class="now">${tag}<div class="who">${escapeHtml(p.now.name)}</div>` +
      `<div class="sub">Frame ${p.now.frame} &middot; Ball ${p.now.ball} &middot; Score ${p.now.total}</div></div>`;
  }
  if (p.status === 'lobby') {
    return `<div class="now">${tag}<div class="who">Waiting to start</div>` +
      `<div class="sub">${p.count} ${p.count === 1 ? 'player' : 'players'} &middot; join here</div></div>`;
  }
  if (p.status === 'finished' && p.winner) {
    return `<div class="now">${tag}<div class="who">${escapeHtml(p.winner.name)}</div>` +
      `<div class="sub">Top score &middot; ${p.winner.score}</div></div>`;
  }
  return `<div class="now">${tag}<div class="who quiet">Open</div><div class="sub">${escapeHtml(p.offer || 'Book here')}</div></div>`;
}

function renderPanes(panes) {
  const el = $('panes');
  const make = mode === 'panel' ? panelPane : screenPane;
  el.innerHTML = (panes || []).map((p) => `<div class="pane">${make(p)}</div>`).join('');
  el.hidden = false;
}

const hints = {
  setup: 'start swing',
  power: 'release',
};

function renderAim(d) {
  const el = $('aim');
  if (!d.show) { el.hidden = true; return; }
  el.hidden = false;

  el.querySelectorAll('.row').forEach((row) => row.classList.toggle('on', row.dataset.phase === d.phase));
  $('aim-offset').style.left = 50 + d.offset * 46 + '%';
  $('aim-spin').style.left = 50 + d.spin * 46 + '%';
  $('aim-power').style.width = d.power * 100 + '%';
  $('aim-needle').style.left = 50 + d.aim * 48 + '%';
  $('aim-hint').textContent = hints[d.phase] || '';
}

let bannerTimer;
function showBanner(text, name) {
  $('banner-text').textContent = text;
  $('banner-name').textContent = name || '';
  $('banner').hidden = false;
  clearTimeout(bannerTimer);
  bannerTimer = setTimeout(() => { $('banner').hidden = true; }, 2600);
}

// Synthesised, so the resource ships without audio files.

let audio, rollNode;

function ctx() {
  if (!audio) audio = new (window.AudioContext || window.webkitAudioContext)();
  return audio;
}

function noise(seconds) {
  const a = ctx();
  const buffer = a.createBuffer(1, Math.floor(a.sampleRate * seconds), a.sampleRate);
  const data = buffer.getChannelData(0);
  for (let i = 0; i < data.length; i++) data[i] = Math.random() * 2 - 1;
  return buffer;
}

function startRoll(volume) {
  stopRoll();
  const a = ctx();
  const src = a.createBufferSource();
  src.buffer = noise(2);
  src.loop = true;
  const filter = a.createBiquadFilter();
  filter.type = 'lowpass';
  filter.frequency.value = 170;
  const gain = a.createGain();
  gain.gain.value = 0;
  gain.gain.linearRampToValueAtTime(volume * 0.9, a.currentTime + 0.25);
  src.connect(filter).connect(gain).connect(a.destination);
  src.start();
  rollNode = { src, gain };
}

function stopRoll() {
  if (!rollNode) return;
  const a = ctx();
  const { src, gain } = rollNode;
  rollNode = null;
  gain.gain.cancelScheduledValues(a.currentTime);
  gain.gain.setValueAtTime(gain.gain.value, a.currentTime);
  gain.gain.linearRampToValueAtTime(0, a.currentTime + 0.2);
  src.stop(a.currentTime + 0.25);
}

function hit(volume) {
  const a = ctx();
  const src = a.createBufferSource();
  src.buffer = noise(0.12);
  const filter = a.createBiquadFilter();
  filter.type = 'bandpass';
  filter.frequency.value = 1500 + Math.random() * 900;
  filter.Q.value = 2.2;
  const gain = a.createGain();
  gain.gain.setValueAtTime(Math.min(1, volume * 1.4), a.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.001, a.currentTime + 0.11);
  src.connect(filter).connect(gain).connect(a.destination);
  src.start();
}

window.addEventListener('message', (event) => {
  const d = event.data;
  if (!d || !d.type) return;

  if (mode !== 'hud') {
    if (d.type === 'panes') renderPanes(d.panes);
    return;
  }

  if (d.type === 'board') renderHud(d.board);
  else if (d.type === 'aim') renderAim(d);
  else if (d.type === 'banner') showBanner(d.text, d.name);
  else if (d.type === 'sfx') {
    try {
      if (d.kind === 'roll') startRoll(d.volume || 0.5);
      else if (d.kind === 'rollstop') stopRoll();
      else if (d.kind === 'hit') hit(d.volume || 0.5);
    } catch (e) { /* audio is a nicety, never break the HUD over it */ }
  }
});
