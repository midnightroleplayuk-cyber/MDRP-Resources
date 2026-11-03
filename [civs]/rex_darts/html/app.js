/* Rex Darts NUI - Rex Studio */
(() => {
  'use strict';

  const $ = (id) => document.getElementById(id);
  const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'rex_darts';
  let T = {};
  let cfg = { modes: ['501', '301', 'atc', 'cricket'], maxPlayers: 4, allowSolo: true, legs: [1, 3, 5], doubleOut: true,
    presets: [0, 100, 500, 1000, 5000], betMax: 25000, houseCut: 5, throw: { ideal: 0.72, window: 0.07 }, turnTime: 30 };

  const L = (k, ...a) => { let s = T[k] ?? k; a.forEach((v) => { s = s.replace('%s', v); }); return s.replace(/%%/g, '%'); };
  const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const money = (n) => '$' + Math.floor(n || 0).toLocaleString('en-US');
  const post = (name, data) => fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data || {}) })
    .then((r) => r.json()).catch(() => null);

  const isX01 = (m) => m === '501' || m === '301';
  const modeName = (m) => L('mode_' + m);

  /* ---------------------------------------------------------------- locale */
  function applyLocale() {
    document.querySelectorAll('[data-l]').forEach((el) => { el.textContent = L(el.dataset.l); });
  }

  /* ---------------------------------------------------------------- icons */
  const ICON = {
    clock: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="8.5"/><path d="M12 7v5l3.2 2"/></svg>',
    cricket: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M5 5l14 14M19 5L5 19"/><circle cx="12" cy="12" r="8.5"/></svg>',
    trophy: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M8 4h8v5a4 4 0 01-8 0V4zM8 6H5v1.5A3 3 0 008 10.5M16 6h3v1.5a3 3 0 01-3 3M12 13v4M8.5 20h7M10 17h4"/></svg>',
    mark1: '<svg viewBox="0 0 16 16"><path d="M4 12L12 4" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
    mark2: '<svg viewBox="0 0 16 16"><path d="M4 12L12 4M4 4l8 8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
    mark3: '<svg viewBox="0 0 16 16" fill="none"><path d="M5 11L11 5M5 5l6 6" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/><circle cx="8" cy="8" r="6.3" stroke="currentColor" stroke-width="1.5"/></svg>',
  };
  const glyph = (m) => (m === 'atc' ? ICON.clock : m === 'cricket' ? ICON.cricket : esc(m));

  /* ---------------------------------------------------------------- mini board */
  const ORDER = [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5];
  function arc(r1, r2, a1, a2) {
    const p = (r, a) => [(r * Math.sin(a)).toFixed(2), (-r * Math.cos(a)).toFixed(2)];
    const [x1, y1] = p(r2, a1), [x2, y2] = p(r2, a2), [x3, y3] = p(r1, a2), [x4, y4] = p(r1, a1);
    return `M${x1} ${y1}A${r2} ${r2} 0 0 1 ${x2} ${y2}L${x3} ${y3}A${r1} ${r1} 0 0 0 ${x4} ${y4}Z`;
  }
  function drawBoard(svg) {
    const k = 100 / 170;
    const R = { db: 100, di: 162 * k, to: 107 * k, ti: 99 * k, ob: 15.9 * k, b: 6.35 * k };
    let s = `<circle r="108" fill="#0c0c0c"/>`;
    for (let i = 0; i < 20; i++) {
      const a1 = ((i * 18 - 9) * Math.PI) / 180, a2 = ((i * 18 + 9) * Math.PI) / 180;
      const dark = i % 2 === 0;
      s += `<path d="${arc(R.di, R.db, a1, a2)}" fill="${dark ? 'var(--ring-red)' : 'var(--ring-green)'}"/>`;
      s += `<path d="${arc(R.to, R.di, a1, a2)}" fill="${dark ? 'var(--board-dark)' : 'var(--board-light)'}"/>`;
      s += `<path d="${arc(R.ti, R.to, a1, a2)}" fill="${dark ? 'var(--ring-red)' : 'var(--ring-green)'}"/>`;
      s += `<path d="${arc(R.ob, R.ti, a1, a2)}" fill="${dark ? 'var(--board-dark)' : 'var(--board-light)'}"/>`;
    }
    s += `<circle r="${R.ob}" fill="var(--ring-green)"/><circle r="${R.b}" fill="var(--ring-red)"/>`;
    s += `<circle r="100" fill="none" stroke="rgba(255,255,255,.25)" stroke-width=".8"/>`;
    s += `<g id="miniMarks"></g>`;
    svg.innerHTML = s;
  }
  drawBoard($('miniBoard'));
  let marks = [];
  function renderMarks() {
    const g = $('miniMarks');
    if (!g) return;
    g.innerHTML = marks.map((m, i) => {
      const x = Math.max(-106, Math.min(106, m.nx * 100)), y = Math.max(-106, Math.min(106, -m.ny * 100));
      return `<g transform="translate(${x.toFixed(1)} ${y.toFixed(1)})"><circle r="10" fill="var(--acc)" stroke="#111" stroke-width="2.5"/>` +
        `<text y="4.4" text-anchor="middle" font-size="13" font-weight="700" fill="#111" font-family="Arial">${i + 1}</text></g>`;
    }).join('');
  }

  /* ---------------------------------------------------------------- audio (synthesised) */
  let actx = null;
  function sfx(kind) {
    try {
      actx = actx || new (window.AudioContext || window.webkitAudioContext)();
      const t = actx.currentTime;
      const out = actx.createGain(); out.connect(actx.destination);
      if (kind === 'throw') {
        const len = 0.18, buf = actx.createBuffer(1, actx.sampleRate * len, actx.sampleRate), d = buf.getChannelData(0);
        for (let i = 0; i < d.length; i++) d[i] = (Math.random() * 2 - 1) * (1 - i / d.length);
        const src = actx.createBufferSource(); src.buffer = buf;
        const f = actx.createBiquadFilter(); f.type = 'bandpass'; f.frequency.setValueAtTime(900, t); f.frequency.linearRampToValueAtTime(2400, t + len);
        out.gain.setValueAtTime(0.12, t); src.connect(f); f.connect(out); src.start(t);
      } else {
        const o = actx.createOscillator(); o.type = 'triangle';
        o.frequency.setValueAtTime(kind === 'miss' ? 140 : 210, t); o.frequency.exponentialRampToValueAtTime(70, t + 0.09);
        out.gain.setValueAtTime(kind === 'miss' ? 0.18 : 0.32, t); out.gain.exponentialRampToValueAtTime(0.001, t + 0.14);
        o.connect(out); o.start(t); o.stop(t + 0.15);
      }
    } catch (e) { /* audio is optional */ }
  }

  /* ---------------------------------------------------------------- modal / lobby */
  const ui = { open: false, view: 'play', lobby: null, form: null, me: 0, error: '', busy: false, lb: null, results: null };

  function defaultForm() {
    return { mode: cfg.modes[0] || '501', players: 2, legs: cfg.legs[0] || 1, doubleOut: !!cfg.doubleOut, bet: 0 };
  }

  function openModal() { ui.open = true; $('modal').classList.remove('hidden'); }
  // Every close tells the client, so the mouse focus can never stay on an invisible window.
  let resultsTimer = null;
  function closeModal() {
    ui.open = false; ui.results = null;
    clearTimeout(resultsTimer);
    $('modal').classList.add('hidden');
    $('window').classList.remove('results');
    post('close');
  }
  // Hard reset from the client (left, kicked, match gone, /dartsreset): nothing of ours stays on screen.
  function resetAll() {
    ui.open = false; ui.results = null; ui.busy = false;
    clearTimeout(resultsTimer);
    $('modal').classList.add('hidden');
    $('window').classList.remove('results');
    $('hud').classList.add('hidden');
    $('reticle').classList.add('hidden');
  }
  function safeRender() {
    try { render(); } catch (err) { console.error('[rex_darts] render failed', err); closeModal(); }
  }

  function seg(id, values, current, label, disabled) {
    const i = Math.max(0, values.findIndex((v) => v.value === current));
    return `<div class="seg${disabled ? ' off' : ''}" data-seg="${id}" style="--n:${values.length};--i:${i}">` +
      values.map((v) => `<button data-v="${esc(String(v.value))}" class="${v.value === current ? 'on' : ''}">${esc(v.label)}</button>`).join('') + '</div>';
  }

  function renderCreate() {
    const f = ui.form;
    const bets = ui.lobby && ui.lobby.bets;
    const solo = f.players === 1;
    const playersVals = [];
    for (let n = cfg.allowSolo ? 1 : 2; n <= cfg.maxPlayers; n++) playersVals.push({ value: n, label: String(n) });
    const body = `<div class="create">
      <div class="modes">${cfg.modes.map((m) => `<button class="mode${f.mode === m ? ' on' : ''}" data-mode="${m}">
          <div class="glyph">${glyph(m)}</div><div><h3>${esc(modeName(m))}</h3><p>${esc(L('mode_' + m + '_desc'))}</p></div></button>`).join('')}
        ${'<div></div>'.repeat(Math.max(0, 4 - cfg.modes.length))}</div>
      <div class="settings">
        <div class="field"><label><span class="cap">${esc(L('players'))}</span></label>${seg('players', playersVals, f.players)}</div>
        <div class="field"><label><span class="cap">${esc(L('legs'))}</span></label>${seg('legs', cfg.legs.map((n) => ({ value: n, label: L('legs_n', n) })), f.legs)}</div>
        <div class="field"><label><span class="cap">${esc(L('double_out'))}</span><small>${esc(L('double_out_desc'))}</small></label>
          ${seg('doubleOut', [{ value: true, label: L('on') }, { value: false, label: L('off') }], f.doubleOut, null, !isX01(f.mode))}</div>
        <div class="field"><label><span class="cap">${esc(L('bet'))}</span><small>${bets ? esc(L('bet_desc', cfg.houseCut)) : ''}</small></label>
          <div class="stake${bets && !solo ? '' : ' seg off'}"><button data-step="-1">&minus;</button><input id="betInput" class="num" value="${esc(money(f.bet))}" ${bets && !solo ? '' : 'disabled'}><button data-step="1">+</button></div>
          <div class="presets${bets && !solo ? '' : ' seg off'}" style="border:0;height:auto;background:none">${cfg.presets.slice(0, 5).map((p) => `<button data-preset="${p}" class="${f.bet === p ? 'on' : ''}">${p ? money(p) : '0'}</button>`).join('')}</div>
        </div>
        <div class="note${solo ? ' acc' : ''}">${esc(solo ? L('solo_note') : bets ? L('bet_note') : L('bet_disabled'))}</div>
      </div></div>`;
    const pot = solo ? 0 : f.bet * f.players;
    const foot = `<div class="info ${ui.error ? 'err' : ''}">${ui.error ? esc(ui.error) : `${esc(L('pot'))} <b class="num">${money(pot)}</b>`}</div>
      <button class="btn ghost" data-act="close">${esc(L('cancel'))}</button>
      <button class="btn primary" data-act="create" ${ui.busy ? 'disabled' : ''}>${esc(L('create'))}</button>`;
    return { body, foot };
  }

  function renderLobby(m) {
    const me = ui.me;
    const inIt = m.players.some((p) => p.src === me);
    const host = m.host === me;
    const seats = [];
    for (let i = 0; i < 4; i++) {
      const p = m.players[i];
      if (i >= m.maxPlayers) seats.push(`<div class="seat empty locked"><div class="n">${i + 1}</div><div class="who">&mdash;</div><span></span></div>`);
      else if (p) seats.push(`<div class="seat filled"><div class="n">${i + 1}</div><div class="who">${esc(p.name)}</div>
        <span>${p.src === m.host ? `<span class="tag acc">${esc(L('host'))}</span>` : ''}${p.src === me ? ` <span class="tag">${esc(L('you'))}</span>` : ''}</span></div>`);
      else seats.push(`<div class="seat empty"><div class="n">${i + 1}</div><div class="who">${esc(L('seat_empty'))}</div><span></span></div>`);
    }
    const body = `<div class="lobby">
      <div class="facts">
        <div class="fact"><span class="cap">${esc(L('mode'))}</span><b>${esc(modeName(m.mode))}</b></div>
        <div class="fact"><span class="cap">${esc(L('legs'))}</span><b>${esc(L('legs_n', m.legsToWin))}</b></div>
        <div class="fact"><span class="cap">${esc(L('double_out'))}</span><b>${isX01(m.mode) ? esc(m.doubleOut ? L('on') : L('off')) : '&mdash;'}</b></div>
        <div class="fact"><span class="cap">${esc(L('bet'))}</span><b class="num">${money(m.bet)}</b></div>
        <div class="fact wide"><span class="cap">${esc(L('pot'))}</span><b class="num">${money(m.pot)}</b></div>
      </div>
      <div class="seats">${seats.join('')}</div></div>`;
    let actions = '';
    if (!inIt) actions = `<button class="btn ghost" data-act="close">${esc(L('close'))}</button>
      <button class="btn primary" data-act="join" ${m.players.length >= m.maxPlayers || ui.busy ? 'disabled' : ''}>${esc(m.bet > 0 ? L('join', money(m.bet)) : L('join_free'))}</button>`;
    else if (host) actions = `<button class="btn danger" data-act="leave">${esc(L('cancel'))}</button>
      <button class="btn primary" data-act="start" ${m.players.length < 2 || ui.busy ? 'disabled' : ''}>${esc(L('start'))}</button>`;
    else actions = `<button class="btn danger" data-act="leave">${esc(L('leave'))}</button><button class="btn ghost" data-act="close">${esc(L('close'))}</button>`;
    const info = ui.error ? `<span class="err">${esc(ui.error)}</span>`
      : `${esc(L('waiting_players'))} &middot; <b class="num">${m.players.length} / ${m.maxPlayers}</b>`;
    return { body, foot: `<div class="info">${info}</div>${actions}` };
  }

  function renderLeaderboard() {
    const rows = ui.lb || [];
    let s = `<div class="lb"><div class="lb-row h cap"><span class="rk">${esc(L('lb_rank'))}</span><span>${esc(L('lb_player'))}</span><span>${esc(L('lb_wins'))}</span>
      <span>${esc(L('lb_games'))}</span><span>${esc(L('lb_avg'))}</span><span>${esc(L('lb_180'))}</span><span>${esc(L('lb_checkout'))}</span></div>`;
    if (!rows.length) s += `<div class="lb-empty">${esc(ui.lb ? L('lb_empty') : '')}</div>`;
    for (let i = 0; i < 10; i++) {
      const r = rows[i];
      if (!rows.length) break;
      s += r ? `<div class="lb-row${i < 3 ? ' top' : ''}"><span class="rk">${String(i + 1).padStart(2, '0')}</span><span class="nm">${esc(r.name)}</span>
        <span class="v num">${r.wins}</span><span class="v num">${r.games}</span><span class="v num">${Number(r.avg || 0).toFixed(1)}</span><span class="v num">${r.max}</span><span class="v num">${r.checkout || '&mdash;'}</span></div>`
        : '<div class="lb-row"></div>';
    }
    s += '</div>';
    return { body: s, foot: `<div class="info"></div><button class="btn ghost" data-act="close">${esc(L('close'))}</button>` };
  }

  function renderResults() {
    const r = ui.results;
    const rows = r.players.slice(0, 4).map((p) => `<div class="res-row${p.winner ? ' win' : ''}"><span class="nm">${esc(p.name)}</span>
      <span class="v num">${p.legs}</span><span class="v num">${p.darts}</span><span class="v num">${p.avg != null ? Number(p.avg).toFixed(1) : '&mdash;'}</span>
      <span class="v num">${p.best || 0}</span><span class="v num">${p.max || 0}</span><span class="v num">${p.checkout || '&mdash;'}</span></div>`);
    while (rows.length < 4) rows.push('<div class="res-row"></div>');
    const body = `<div class="res-hero"><div class="medal">${ICON.trophy}</div><div><span class="cap">${esc(L('res_winner'))}</span>
        <h2>${esc(r.winner ? L('res_won', r.winner) : '—')}</h2></div>
        <div class="pay"><span class="cap">${esc(L('res_payout'))}</span><b class="num">${money(r.payout)}</b></div></div>
      <div class="res-table"><div class="res-row cap"><span>${esc(L('lb_player'))}</span><span>${esc(L('legs'))}</span><span>${esc(L('res_darts'))}</span>
        <span>${esc(L('res_avg'))}</span><span>${esc(L('res_best'))}</span><span>${esc(L('res_180'))}</span><span>${esc(L('res_checkout'))}</span></div>${rows.join('')}</div>`;
    return { body, foot: `<div class="info">${esc(modeName(r.mode))}</div><button class="btn primary" data-act="close">${esc(L('close'))}</button>` };
  }

  function render() {
    if (!ui.open) return;
    const win = $('window');
    win.classList.toggle('results', !!ui.results);
    $('tabs').classList.toggle('hidden', !!ui.results);
    document.querySelectorAll('#tabs button').forEach((b) => b.classList.toggle('on', b.dataset.tab === ui.view));
    let out;
    if (ui.results) {
      $('winTitle').textContent = L('lobby_title');
      $('winSub').textContent = modeName(ui.results.mode);
      out = renderResults();
    } else if (ui.view === 'leaderboard') {
      $('winTitle').textContent = L('tab_leaderboard');
      $('winSub').textContent = L('lb_sub');
      out = renderLeaderboard();
    } else {
      const m = ui.lobby && ui.lobby.match;
      $('winTitle').textContent = m ? modeName(m.mode) : L('lobby_title');
      $('winSub').textContent = m ? L('waiting_players') : L('lobby_sub');
      out = m && m.status === 'lobby' ? renderLobby(m) : renderCreate();
    }
    $('winBody').innerHTML = out.body;
    $('winFoot').innerHTML = out.foot;
  }

  function setBet(v) {
    v = Math.max(0, Math.min(cfg.betMax, Math.floor(Number(String(v).replace(/[^0-9]/g, '')) || 0)));
    ui.form.bet = v;
  }

  document.addEventListener('click', async (e) => {
    const t = e.target.closest('button');
    if (!t || !ui.open) return;
    if (t.id === 'closeBtn') return closeModal();
    if (t.dataset.tab) { ui.view = t.dataset.tab; ui.error = ''; if (ui.view === 'leaderboard') { ui.lb = null; render(); ui.lb = await post('leaderboard') || []; } render(); return; }
    if (t.dataset.mode) { ui.form.mode = t.dataset.mode; render(); return; }
    const segEl = t.closest('[data-seg]');
    if (segEl) {
      const id = segEl.dataset.seg, raw = t.dataset.v;
      ui.form[id] = id === 'doubleOut' ? raw === 'true' : Number(raw);
      if (id === 'players' && ui.form.players === 1) ui.form.bet = 0;
      render(); return;
    }
    if (t.dataset.preset !== undefined) { setBet(t.dataset.preset); render(); return; }
    if (t.dataset.step) {
      const step = ui.form.bet >= 1000 ? 500 : 100;
      setBet(ui.form.bet + step * Number(t.dataset.step)); render(); return;
    }
    const act = t.dataset.act;
    if (!act) return;
    if (act === 'close') return closeModal();
    if (act === 'leave') { post('leave'); closeModal(); return; }
    ui.busy = true; ui.error = ''; render();
    let res = null;
    if (act === 'create') res = await post('create', ui.form);
    if (act === 'join') res = await post('join', { key: ui.lobby.key });
    if (act === 'start') res = await post('start', { key: ui.lobby.key });
    ui.busy = false;
    if (!res || !res.ok) { ui.error = (res && res.error) || ''; render(); return; }
    if (act === 'start') { closeModal(); return; }
    if (act === 'create' && ui.form.players === 1) { closeModal(); return; }
    render();
  });

  document.addEventListener('change', (e) => {
    if (e.target.id === 'betInput') { setBet(e.target.value); render(); }
  });

  // ESC always closes; Backspace too unless you are typing in a field. Posts 'close' even if the
  // window is already hidden, so a stuck focus is released by a single key press.
  document.addEventListener('keydown', (e) => {
    const typing = e.target && (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA');
    if (e.key === 'Escape' || (e.key === 'Backspace' && !typing)) {
      e.preventDefault();
      if (ui.open) closeModal(); else post('close');
    }
  });

  /* ---------------------------------------------------------------- scoreboard */
  let sbState = null, sbMine = false, timerLeft = 0, lastTurnKey = '';
  setInterval(() => {
    if (!sbState || sbState.status !== 'playing' || sbState.busy) return;
    timerLeft = Math.max(0, timerLeft - 1);
    const el = $('sbTimer');
    el.textContent = timerLeft;
    el.classList.toggle('low', timerLeft <= 5);
  }, 1000);

  function scoreText(m, p) {
    if (isX01(m.mode)) return p.score;
    if (m.mode === 'atc') return p.target > 20 ? (p.target > 21 ? 'OUT' : 'B') : p.target;
    return p.points || 0;
  }

  function renderBoard(m, me) {
    const box = $('board');
    if (!m || m.status === 'lobby') { box.classList.add('hidden'); return; }
    box.classList.remove('hidden');
    $('sbMode').textContent = modeName(m.mode) + (isX01(m.mode) && m.doubleOut ? ' · D/O' : '');
    $('sbMeta').textContent = `${L('leg', m.leg)} · ${L('round', m.round, m.maxRounds)}${sbMine ? '' : ' · ' + L('spectating')}`;
    const turnKey = `${m.key}:${m.leg}:${m.round}:${m.turn}`;
    if (turnKey !== lastTurnKey) { lastTurnKey = turnKey; marks = []; renderMarks(); timerLeft = m.timeLeft ?? cfg.turnTime; }
    if (m.dart === 0 && !m.busy) { marks = []; renderMarks(); }
    if (m.timeLeft != null) timerLeft = m.timeLeft;
    $('sbTimer').textContent = timerLeft;

    $('sbRows').innerHTML = m.players.map((p, i) => {
      const legs = Array.from({ length: m.legsToWin }, (_, k) => `<i class="${k < p.legs ? 'on' : ''}"></i>`).join('');
      const sub = isX01(m.mode) && p.avg != null ? `${L('res_avg')} ${Number(p.avg).toFixed(1)}` : (m.mode === 'atc' ? L('target') : m.mode === 'cricket' ? L('points') : '');
      return `<div class="sb-row${i + 1 === m.turn ? ' cur' : ''}"><div class="nm">${esc(p.name)}${p.src === me ? ` <span class="tag">${esc(L('you'))}</span>` : ''}<small>${esc(sub)}</small></div>
        <div class="legs">${m.legsToWin > 1 ? legs : ''}</div><div class="sc num">${esc(String(scoreText(m, p)))}</div></div>`;
    }).join('');

    const ck = $('sbCricket');
    if (m.mode === 'cricket') {
      ck.classList.remove('hidden');
      const nums = [20, 19, 18, 17, 16, 15, 25];
      let g = `<div class="ck-grid" style="--p:${m.players.length}"><div class="ckh"></div>${m.players.map((p) => `<div class="ckh">${esc(p.name.split(' ')[0].slice(0, 8))}</div>`).join('')}`;
      nums.forEach((n) => {
        g += `<div class="ckn">${n === 25 ? 'B' : n}</div>`;
        m.players.forEach((p) => {
          const k = (p.marks && (p.marks[n] ?? p.marks[String(n)])) || 0;
          g += `<div class="${k >= 3 ? 'closed' : ''}">${k ? ICON['mark' + Math.min(3, k)] : ''}</div>`;
        });
      });
      ck.innerHTML = g + '</div>';
    } else ck.classList.add('hidden');

    const cur = m.players[m.turn - 1];
    $('sbTurnLabel').textContent = cur ? (cur.src === me ? L('your_turn') : L('waiting_turn', cur.name)) : '';
    const visit = m.visit || [];
    let darts = '';
    for (let i = 0; i < 3; i++) {
      const v = visit[i];
      darts += `<span class="${v ? 'f' : ''}${v && (v[0] === 'T' || v === 'BULL') ? ' t' : ''}">${v ? esc(v) : '&middot;'}</span>`;
    }
    darts += `<span class="sum num">${m.visitScore || 0}</span>`;
    $('sbDarts').innerHTML = darts;
    $('sbHint').innerHTML = m.hint ? `${esc(isX01(m.mode) ? L('checkout') : L('aim_hint'))} &middot; <b>${esc(m.hint)}</b>` : '';
  }

  /* ---------------------------------------------------------------- hud / callout */
  function setupHud() {
    const z = $('powerZone');
    z.style.left = ((cfg.throw.ideal - cfg.throw.window) * 100) + '%';
    z.style.width = (cfg.throw.window * 200) + '%';
  }
  function renderHud(d) {
    const h = $('hud');
    if (!d.show) { h.classList.add('hidden'); return; }
    h.classList.remove('hidden');
    h.classList.toggle('wait', d.phase === 'wait');
    const pct = Math.round((d.power || 0) * 100);
    $('powerFill').style.width = pct + '%';
    $('powerTick').style.left = `calc(${pct}% - 1px)`;
    $('powerVal').textContent = pct;
    $('focusFill').style.width = Math.round((d.focus ?? 1) * 100) + '%';
    const left = d.darts ?? 3;
    $('dartsVal').textContent = left;
    $('dartPips').querySelectorAll('i').forEach((el, i) => el.classList.toggle('on', i < left));
    if (d.view) $('viewName').textContent = L('cam_' + d.view);
  }

  // Reticle: x / y in screen fractions, r in screen heights. Updated every frame while aiming.
  const ret = { el: null, ring: null, dot: null, mode: '' };
  function renderReticle(d) {
    if (!ret.el) { ret.el = $('reticle'); ret.ring = ret.el.querySelector('.rt-ring'); }
    if (!d.show) { ret.el.classList.add('hidden'); return; }
    ret.el.classList.remove('hidden');
    ret.el.style.transform = `translate(${(d.x * window.innerWidth).toFixed(1)}px, ${(d.y * window.innerHeight).toFixed(1)}px)`;
    const size = Math.max(1.4, Math.min(16, (d.r || 0) * 200)); // diameter in vh
    ret.ring.style.width = ret.ring.style.height = size.toFixed(2) + 'vh';
    if (d.mode !== ret.mode) { ret.mode = d.mode; ret.el.className = d.mode || ''; }
  }
  function applyKeys() {
    const k = cfg.keys || {};
    [['kAim', 'aim'], ['kThrow', 'throw'], ['kFocus', 'focus'], ['kCamera', 'camera'], ['kLeave', 'leave']]
      .forEach(([id, name]) => { if (k[name]) $(id).textContent = k[name]; });
  }

  let coTimer = null;
  function callout(kind, value) {
    const el = $('callout');
    const map = {
      '180': [L('call_ton', ''), L('call_180')],
      ton: [L('call_ton', ''), String(value)],
      bust: ['', L('call_bust')],
      leg: [value || '', L('call_leg')],
      match: [value || '', L('call_match')],
    };
    const [over, main] = map[kind] || ['', ''];
    $('coOver').textContent = kind === 'ton' || kind === '180' ? L('title') : over;
    $('coMain').textContent = main;
    el.className = kind === 'bust' ? 'bust' : '';
    clearTimeout(coTimer);
    coTimer = setTimeout(() => el.classList.add('hidden'), kind === 'match' ? 3200 : 2200);
  }

  /* ---------------------------------------------------------------- messages */
  window.addEventListener('message', (ev) => {
    const { action, data } = ev.data || {};
    switch (action) {
      case 'init':
        T = data.locale || {}; Object.assign(cfg, data); applyLocale(); setupHud(); applyKeys(); break;
      case 'lobby':
        ui.lobby = data; ui.me = data.me; ui.view = 'play'; ui.error = ''; ui.busy = false; ui.results = null;
        ui.form = ui.form || defaultForm();
        if (!cfg.modes.includes(ui.form.mode)) ui.form.mode = cfg.modes[0];
        openModal(); safeRender(); break;
      case 'state': {
        const m = data.state;
        if (ui.lobby && ui.lobby.key === m.key) {
          ui.lobby.match = m;
          if (ui.open && !ui.results) { if (m.status === 'playing' && data.mine) closeModal(); else safeRender(); }
        }
        if (data.mine || !sbState || sbState.key === m.key || !sbMine) {
          sbState = m; sbMine = !!data.mine;
          renderBoard(m, data.me);
        }
        break;
      }
      case 'closed':
        if (sbState && sbState.key === data.key) { sbState = null; renderBoard(null); }
        if (ui.lobby && ui.lobby.key === data.key && ui.open && !ui.results) closeModal();
        break;
      case 'hit':
        if (sbState && sbState.key === data.key) { marks.push(data); marks = marks.slice(-3); renderMarks(); }
        break;
      case 'hud': renderHud(data); break;
      case 'reset': resetAll(); break;
      case 'reticle': renderReticle(data); break;
      case 'callout': callout(data.kind, data.value); break;
      case 'results':
        if (data.mine) {
          ui.results = data.results; ui.view = 'play'; openModal(); safeRender();
          clearTimeout(resultsTimer);
          resultsTimer = setTimeout(() => { if (ui.open && ui.results) closeModal(); }, 20000);
        }
        break;
      case 'sfx': sfx(data.kind); break;
      default: break;
    }
  });

  applyLocale();
  setupHud();
  window.__rexDarts = { ui, cfg, render, renderBoard, renderHud, renderReticle, callout, renderMarks, setMarks: (m) => { marks = m; renderMarks(); }, setLocale: (t) => { T = t; applyLocale(); } };
})();
