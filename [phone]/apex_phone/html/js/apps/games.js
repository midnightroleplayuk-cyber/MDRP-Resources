/* ===================== JOGOS - Arcade do telemóvel (1.5.0) =====================
   Motor comum (window.Arcade), seis jogos de base (Snake, 2048, Blocos, Minas, Break, Memória) e o hub
   "Arcade" (Jogos, Classificações, Perfil). Os jogos de tabuleiro vivem em games-board.js e os de ação em
   games-action.js: ambos registam-se aqui com Arcade.game() e usam a mesma casca.

   Regras de desempenho (CEF), cumpridas em todos:
     · UM requestAnimationFrame por jogo, que MORRE em pause()/onClose: uma app em segundo plano não gasta
       um único frame (é isso que estraga o FPS no jogo).
     · Canvas em tamanho lógico fixo: sem redimensionamentos nem devicePixelRatio.
     · Zero filter / backdrop-filter / color-mix; só transform e opacity animam (abanões, pontos a flutuar).
     · NADA de emojis: o CEF do GTA não garante a fonte de cor. Faces, botões e conquistas são SVG.
     · Nenhum jogo arranca sozinho: a casca mostra "Toca para começar" (A.ready) e o jogo só mexe depois.

   API da casca (SPEC 3.4, "Extensões 1.5.0"):
     const A = Arcade.shell(win, { id, name, color, pausable, lowerIsBetter, scoreLabel, bestLabel, onRestart, onPause, onResume })
     A.el.stage / A.el.ctl / A.el.fx · A.setScore(n) · A.setMid(html) · A.setId(recId) · A.hearts(n, total)
     A.ready(title, sub) → Promise (resolve ao toque / Enter / Espaço; imediato num "Jogar outra vez")
     A.options([{ key, label, values: [{ v, label }], cur, onChange }]) → { set(key, v), el }
     A.flash(msg, cls) · A.flashAt(canvas, x, y, msg, cls) · A.haptic('light'|'medium'|'heavy') · A.sfx(nome)
     A.submit(score, board, meta) → Promise { best, rank, improved, top } · A.end({ title, sub, score, win, board, submit })
     A.gameOver(title, sub, score) = A.end · A.pause() · A.resume() · A.restart() · A.fit()
     getters: A.paused · A.ended · A.waiting (ecrã "Toca para começar" à vista) · A.win · A.score
   O objeto devolvido por build(win) deve ter pause(), resume() e, de preferência, key(e) (teclado físico:
   há UM ouvinte global neste ficheiro que entrega ao jogo em primeiro plano).
   Multijogador: Arcade.match.{invite, accept, decline, move, state, leave, nearby, pending}, Arcade.pendingMatch,
   Arcade.matchUI(A, match, { onMove, auto }) e os pushes arcade:invite / arcade:match (server/arcade.lua).
   ============================================================================== */

window.Arcade = (() => {
  const g = UI.g;
  const T = s => (window.L && L.t ? L.t(s) : s);

  /* ---------- recordes e opções: na gaveta DESTA personagem ----------
     Dois mapas no Store ('arcade' = recordes, 'arcadeOpt' = opções), que vivem em apexphone:<citizenid>: e vão
     para a base de dados pelo userdata (chaves SYNC). As chaves antigas 'arcade:<jogo>' do localStorage mudam-se
     UMA vez por PC. Os recordes do SERVIDOR (tabela apex_phone_arcade_scores) chegam por RPC (arcade.submit /
     arcade.board / arcade.me): o local é a cópia rápida para o HUD. */
  const REC = 'arcade', OPT = 'arcadeOpt', MOVED = 'arcadeMoved', STATS = 'arcadeStats';
  const OPTK = /:(walls|lv|pairs|fast|start)$/;
  const map = key => { const m = Store.get(key, null); return m && typeof m === 'object' && !Array.isArray(m) ? m : {}; };
  const put = (key, k, v) => { const m = Object.assign({}, map(key)); m[k] = v; Store.set(key, m); };
  let moved = false;
  function ensure() {
    if (moved) return; moved = true;
    try { if (Store.global.get(MOVED, 0)) return; } catch (e) {}
    const rec = {}, opt = {}, velhas = [];
    try { Object.keys(localStorage).forEach(k => {
      if (k.indexOf('arcade:') !== 0) return;
      const rest = k.slice(7), v = localStorage.getItem(k); velhas.push(k);
      if (OPTK.test(rest)) opt[rest] = v; else { const n = parseInt(v, 10); if (n > 0) rec[rest] = n; }
    }); } catch (e) {}
    if (velhas.length) {
      Store.set(REC, Object.assign({}, rec, map(REC)));
      Store.set(OPT, Object.assign({}, opt, map(OPT)));
      try { velhas.forEach(k => localStorage.removeItem(k)); } catch (e) {}
    }
    try { Store.global.set(MOVED, 1); } catch (e) {}
  }
  const best = id => { ensure(); const n = parseInt(map(REC)[id], 10); return n > 0 ? n : 0; };
  const setBest = (id, n) => { ensure(); n = Math.floor(+n) || 0; if (!(n > best(id))) return false; put(REC, id, n); return true; };
  /* alguns jogos ganham com MENOS (jogadas, segundos): guardamos o melhor "ao contrário" */
  const bestLow = id => best(id);
  const setBestLow = (id, n) => { ensure(); n = Math.floor(+n) || 0; const cur = bestLow(id); if (!(n > 0 && (!cur || n < cur))) return false; put(REC, id, n); return true; };
  const clearBest = () => { ensure(); const m = map(REC); Object.keys(m).forEach(k => { if (!OPTK.test(k)) delete m[k]; }); Store.set(REC, m); };
  const allBest = () => { ensure(); const m = map(REC), out = {}; Object.keys(m).forEach(k => { const n = parseInt(m[k], 10); if (n > 0 && !OPTK.test(k)) out[k] = n; }); return out; };
  const opt = (k, def) => { ensure(); const v = map(OPT)[k]; return v === undefined || v === null ? def : v; };
  const setOpt = (k, v) => { ensure(); put(OPT, k, String(v)); return v; };

  /* ---------- estatísticas locais (perfil) ----------
     { played, time (s), wins, mpPlayed, mpWins, mpLosses, games: { id: { played, time, wins } }, flags: {}, max: {} }
     O servidor conta as suas (apex_phone_arcade_stats) e ganha no perfil quando responde; isto é a cópia local
     e a única fonte das "bandeiras" (2048 atingido, Tetris feito...) que só o jogo conhece. */
  const emptyStats = () => ({ played: 0, time: 0, wins: 0, mpPlayed: 0, mpWins: 0, mpLosses: 0, games: {}, flags: {}, max: {}, days: [] });
  const stats = () => { const s = Store.get(STATS, null); return s && typeof s === 'object' ? Object.assign(emptyStats(), s) : emptyStats(); };
  function addStat(id, o) {
    const s = stats(); o = o || {};
    const t = Math.max(0, Math.min(7200, Math.round(+o.time || 0)));
    s.played++; s.time += t; if (o.win) s.wins++; s.last = id;
    const gs = s.games[id] = s.games[id] || { played: 0, time: 0, wins: 0 }; gs.played++; gs.time += t; if (o.win) gs.wins++; gs.last = Date.now();
    if (o.mp) { s.mpPlayed++; if (o.win) s.mpWins++; else if (o.win === false) s.mpLosses++; }
    const h = new Date().getHours(); if (h < 5) s.flags.night = 1;
    const day = new Date().toISOString().slice(0, 10); if (s.days[s.days.length - 1] !== day) { s.days.push(day); if (s.days.length > 60) s.days.shift(); }
    /* desafio do dia: a primeira partida do jogo do dia conta, as seguintes só se melhorarem */
    try { const d = daily(); if (d && d.id === id) { const sc = Math.round(+o.score || 0); const cur = s.daily && s.daily.day === d.day ? s.daily : null; if (!cur) s.daily = { day: d.day, id, score: sc, n: 1 }; else { cur.n++; if (sc > cur.score) cur.score = sc; } s.dailyDone = (s.dailyDone || 0) + (cur ? 0 : 1); } } catch (e) {}
    Store.set(STATS, s); return s;
  }
  /* desafio do dia: um jogo por dia, determinista pela data (a lista ordenada por id para não depender da ordem de carga) */
  const dayIndex = () => Math.floor(Date.now() / 864e5);
  function daily() {
    const ids = GAMES.map(d => d.id).sort(); if (!ids.length) return null;
    const day = dayIndex(); let h = (day * 2654435761) % 4294967296; h = (h ^ (h >>> 13)) * 1274126177 % 4294967296; h = (h ^ (h >>> 16)) >>> 0;
    return { id: ids[h % ids.length], seed: h, day };
  }
  const flag = (k, v) => { const s = stats(); if (s.flags[k]) return false; s.flags[k] = v === undefined ? 1 : v; Store.set(STATS, s); return true; };
  const maxStat = (k, n) => { const s = stats(); n = +n || 0; if (!(n > (s.max[k] || 0))) return false; s.max[k] = n; Store.set(STATS, s); return true; };

  const GAMES = [];     /* definições, pela ordem de registo (hub) */
  const DEFS = {};      /* id → definição */

  /* ---------- ciclo de animação pausável ----------
     Arcade.loop(fn) ou Arcade.loop(fn, { scale: () => A.timeScale }): o dt chega multiplicado pela escala (câmara lenta).
     `L.timeScale = .3` também funciona (a casca escreve A.timeScale, o jogo é que decide usá-lo). */
  function loop(fn, o) {
    let raf = 0, last = 0, running = false;
    const getScale = o && typeof o.scale === 'function' ? o.scale : null;
    const L = {
      timeScale: 1,
      start() { if (running) return; running = true; last = 0; raf = requestAnimationFrame(step); },
      stop() { running = false; cancelAnimationFrame(raf); },
      get running() { return running; },
    };
    const step = t => { if (!running) return; let dt = Math.min(0.05, ((t - (last || t)) / 1000)); last = t; const k = getScale ? +getScale() : L.timeScale; if (k > 0 && k !== 1) dt *= k; fn(dt); raf = requestAnimationFrame(step); };
    return L;
  }

  /* ---------- gestos de direção (pointer: serve rato e toque) ---------- */
  function dirs(el, onDir) {
    let sx = 0, sy = 0, on = false;
    el.addEventListener('pointerdown', e => { sx = e.clientX; sy = e.clientY; on = true; });
    el.addEventListener('pointerup', e => {
      if (!on) return; on = false;
      const dx = e.clientX - sx, dy = e.clientY - sy;
      if (Math.abs(dx) < 16 && Math.abs(dy) < 16) return;
      onDir(Math.abs(dx) > Math.abs(dy) ? (dx > 0 ? 'r' : 'l') : (dy > 0 ? 'd' : 'u'));
    });
    el.addEventListener('pointercancel', () => { on = false; });
  }

  /* botão de controlo com glifo do sistema (nunca texto/emoji) */
  const btn = (cls, glyph, size) => `<div class="gb ${cls}">${g(glyph, size || 22)}</div>`;

  /* sprites simples para a Memória: formas geométricas, sempre renderizáveis */
  const SPR = {
    circle: c => `<circle cx="24" cy="24" r="15" fill="${c}"/>`,
    square: c => `<rect x="10" y="10" width="28" height="28" rx="6" fill="${c}"/>`,
    tri: c => `<path d="M24 8 41 39H7z" fill="${c}"/>`,
    diamond: c => `<path d="M24 7 41 24 24 41 7 24z" fill="${c}"/>`,
    star: c => `<path d="M24 7l5 11 12 1.5-9 8 2.5 12L24 34l-10.5 5.5L16 27.5l-9-8L19 18z" fill="${c}"/>`,
    heart: c => `<path d="M24 40S8 30 8 20a8.5 8.5 0 0 1 16-3 8.5 8.5 0 0 1 16 3c0 10-16 20-16 20z" fill="${c}"/>`,
    ring: c => `<circle cx="24" cy="24" r="13" fill="none" stroke="${c}" stroke-width="7"/>`,
    bolt: c => `<path d="M27 6 12 27h9l-3 15 16-22h-10z" fill="${c}"/>`,
    moon: c => `<path d="M30 8a16 16 0 1 0 10 28A13 13 0 0 1 30 8z" fill="${c}"/>`,
    hex: c => `<path d="M24 6l15 9v18l-15 9-15-9V15z" fill="${c}"/>`,
    cross: c => `<path d="M19 8h10v11h11v10H29v11H19V29H8V19h11z" fill="${c}"/>`,
    drop: c => `<path d="M24 6c8 10 13 17 13 24a13 13 0 0 1-26 0c0-7 5-14 13-24z" fill="${c}"/>`,
  };
  const sprite = (name, color) => `<svg viewBox="0 0 48 48" class="spr" aria-hidden="true">${(SPR[name] || SPR.circle)(color)}</svg>`;

  /* ---------- definições do Arcade (folha "Definições" do hub e do menu de pausa) ----------
     Guardadas no mapa de opções ('arcadeOpt', chaves cfg:*): volume dos jogos (0 a 100), vibração (abanões e toque),
     controlos para canhotos (.gm-lefty na casca) e reduzir efeitos (sem confetti, abanões e câmara lenta). */
  const CFG = { volume: 80, haptic: true, lefty: false, reduceFx: false };
  const settings = () => ({
    volume: Math.max(0, Math.min(100, parseInt(opt('cfg:volume', CFG.volume), 10) || 0)),
    haptic: String(opt('cfg:haptic', '1')) !== '0',
    lefty: String(opt('cfg:lefty', '0')) === '1',
    reduceFx: String(opt('cfg:reduceFx', '0')) === '1' || !!(window.System && System.state && System.state.reduceMotion),
  });
  const setSetting = (k, v) => { setOpt('cfg:' + k, typeof v === 'boolean' ? (v ? '1' : '0') : v); applySettings(); };
  function applySettings() {
    const s = settings();
    document.querySelectorAll('.gm-wrap').forEach(w => { w.classList.toggle('gm-lefty', s.lefty); w.classList.toggle('gm-lowfx', s.reduceFx); });
  }

  /* ---------- sons dos jogos: mini sintetizador próprio (Web Audio) ----------
     Curtos, sem ficheiros, com o volume do sistema vezes o volume dos jogos. O Sound do sistema fica para os toques de UI.
     Paleta (SPEC-GAMES-2 3.2): hit, score, win, lose, tick, move, capture, level, pop, bonus, coin, jump, land, explode,
     whoosh, powerup, combo, chime, fail, count, flip, slide, place, swish, bounce, crash, drum, laser, splash, cut.
     Um nome desconhecido não faz nada. */
  let actx = null;
  const ac = () => {
    if (!actx) { try { actx = new (window.AudioContext || window.webkitAudioContext)(); } catch (e) { actx = null; } }
    if (actx && actx.state === 'suspended') { try { actx.resume(); } catch (e) {} }
    return actx;
  };
  const vol = () => { try { const s = (window.System && System.state) || {}; if (s.sounds === false) return 0; const v = s.volume == null ? 60 : +s.volume; return Math.max(0, Math.min(1, v / 100)) * .45 * (settings().volume / 100); } catch (e) { return .2; } };
  function tone(f, t, dur, o) {
    o = o || {}; const c = ac(); if (!c) return; const v = vol() * (o.gain || .2); if (v <= 0) return;
    const t0 = c.currentTime + (t || 0), osc = c.createOscillator(), gn = c.createGain();
    osc.type = o.type || 'sine'; osc.frequency.setValueAtTime(f, t0); if (o.to) osc.frequency.exponentialRampToValueAtTime(o.to, t0 + dur);
    gn.gain.setValueAtTime(0.0001, t0); gn.gain.linearRampToValueAtTime(v, t0 + (o.attack || .005)); gn.gain.exponentialRampToValueAtTime(0.0001, t0 + dur);
    osc.connect(gn); gn.connect(c.destination); osc.start(t0); osc.stop(t0 + dur + .03);
  }
  function noise(t, dur, o) {
    o = o || {}; const c = ac(); if (!c) return; const v = vol() * (o.gain || .2); if (v <= 0) return;
    const t0 = c.currentTime + (t || 0), n = Math.max(1, Math.floor(c.sampleRate * dur)), buf = c.createBuffer(1, n, c.sampleRate), d = buf.getChannelData(0);
    for (let i = 0; i < n; i++) d[i] = (Math.random() * 2 - 1) * (1 - i / n);
    const src = c.createBufferSource(); src.buffer = buf;
    const f = c.createBiquadFilter(); f.type = o.type || 'bandpass'; f.frequency.setValueAtTime(o.freq || 1800, t0); if (o.to) f.frequency.exponentialRampToValueAtTime(o.to, t0 + dur); f.Q.value = o.q || .8;
    const gn = c.createGain(); gn.gain.setValueAtTime(v, t0); gn.gain.exponentialRampToValueAtTime(0.0001, t0 + dur);
    src.connect(f); f.connect(gn); gn.connect(c.destination); src.start(t0);
  }
  const SFX = {
    hit: () => { noise(0, .06, { freq: 900, gain: .4 }); tone(170, 0, .09, { gain: .24, type: 'triangle', to: 80 }); },
    score: () => { tone(880, 0, .07, { gain: .16 }); tone(1320, .06, .11, { gain: .16 }); },
    win: () => { [523, 659, 784, 1047].forEach((f, i) => tone(f, i * .09, i === 3 ? .5 : .16, { gain: .18 })); },
    lose: () => { [392, 311, 233].forEach((f, i) => tone(f, i * .14, .24, { gain: .18, type: 'triangle' })); },
    tick: () => noise(0, .018, { freq: 4200, q: 1.4, gain: .2 }),
    move: () => { noise(0, .02, { freq: 1400, gain: .16 }); tone(420, 0, .05, { gain: .08, type: 'triangle' }); },
    capture: () => { noise(0, .05, { freq: 700, gain: .32 }); tone(300, 0, .12, { gain: .14, type: 'triangle', to: 150 }); },
    level: () => { [660, 880, 1100].forEach((f, i) => tone(f, i * .07, .12, { gain: .16 })); },
    pop: () => tone(600, 0, .05, { gain: .12, to: 900 }),
    bonus: () => { tone(740, 0, .08, { gain: .14 }); tone(988, .07, .08, { gain: .14 }); tone(1480, .14, .16, { gain: .14 }); },
    /* paleta da ronda 2 */
    coin: () => { tone(1568, 0, .05, { gain: .14, type: 'triangle' }); tone(2093, .05, .14, { gain: .14, type: 'triangle' }); },
    jump: () => tone(260, 0, .13, { gain: .14, type: 'triangle', to: 760 }),
    land: () => { noise(0, .05, { freq: 320, q: .6, gain: .3 }); tone(130, 0, .07, { gain: .18, type: 'triangle', to: 60 }); },
    explode: () => { noise(0, .34, { freq: 420, q: .5, gain: .5, to: 90 }); tone(95, 0, .3, { gain: .3, to: 32 }); },
    whoosh: () => noise(0, .2, { freq: 600, q: .7, gain: .22, to: 2600 }),
    powerup: () => { [523, 659, 784, 1047, 1319].forEach((f, i) => tone(f, i * .05, .09, { gain: .13, type: 'triangle' })); },
    combo: () => { [880, 1109, 1319].forEach((f, i) => tone(f, i * .06, .08, { gain: .15 })); tone(1760, .18, .16, { gain: .12 }); },
    chime: () => { tone(1568, 0, .5, { gain: .1, attack: .01 }); tone(2093, .02, .6, { gain: .07, attack: .01 }); tone(3136, .04, .4, { gain: .04, attack: .01 }); },
    fail: () => { tone(220, 0, .22, { gain: .16, type: 'sawtooth', to: 110 }); noise(0, .1, { freq: 300, q: .6, gain: .18 }); },
    bad: () => { tone(220, 0, .22, { gain: .16, type: 'sawtooth', to: 110 }); noise(0, .1, { freq: 300, q: .6, gain: .18 }); },
    count: () => tone(660, 0, .09, { gain: .16, type: 'square' }),
    go: () => { tone(990, 0, .22, { gain: .16, type: 'square' }); tone(1320, .02, .3, { gain: .1 }); },
    flip: () => { noise(0, .03, { freq: 2600, q: 1, gain: .2 }); tone(900, 0, .06, { gain: .08, to: 1400 }); },
    slide: () => noise(0, .09, { freq: 500, q: .8, gain: .16, to: 1600 }),
    place: () => { tone(190, 0, .07, { gain: .2, type: 'triangle', to: 95 }); noise(0, .025, { freq: 1100, q: .9, gain: .22 }); },
    swish: () => noise(0, .12, { freq: 3200, q: .6, gain: .2, to: 1200 }),
    bounce: () => tone(520, 0, .08, { gain: .14, to: 240 }),
    crash: () => { noise(0, .3, { freq: 2400, q: .3, gain: .45, to: 600 }); tone(150, 0, .2, { gain: .22, type: 'triangle', to: 40 }); },
    drum: () => { tone(160, 0, .26, { gain: .5, to: 42 }); noise(0, .05, { freq: 900, q: .5, gain: .25 }); },
    laser: () => tone(1900, 0, .15, { gain: .13, type: 'sawtooth', to: 180 }),
    splash: () => { noise(0, .26, { freq: 1100, q: .7, gain: .3, to: 300 }); tone(420, 0, .12, { gain: .1, to: 180 }); },
    cut: () => { noise(0, .06, { freq: 4200, q: .9, gain: .3, to: 1500 }); tone(1300, 0, .05, { gain: .1, to: 420 }); },
  };
  const sfx = name => { const f = SFX[name]; if (!f) return; try { f(); } catch (e) {} };

  /* ---------- partículas em canvas (sumo visual sem DOM) ----------
     const P = Arcade.particles(); P.burst(x, y, cor|[cores], n, vel); no ciclo: P.step(dt); P.draw(ctx); P.count */
  function particles(max) {
    const P = [], MAX = max || 160;
    return {
      get count() { return P.length; },
      burst(x, y, color, n, speed) {
        for (let i = 0; i < (n || 10); i++) {
          if (P.length >= MAX) P.shift();
          const a = Math.random() * 6.2832, s = (speed || 120) * (.4 + Math.random() * .8);
          P.push({ x, y, vx: Math.cos(a) * s, vy: Math.sin(a) * s - 40, life: .45 + Math.random() * .4, t: 0, r: 2 + Math.random() * 2.5, c: Array.isArray(color) ? color[(Math.random() * color.length) | 0] : color });
        }
      },
      step(dt) { for (let i = P.length - 1; i >= 0; i--) { const p = P[i]; p.t += dt; if (p.t >= p.life) { P.splice(i, 1); continue; } p.vy += 260 * dt; p.x += p.vx * dt; p.y += p.vy * dt; } },
      draw(ctx) { for (const p of P) { const k = 1 - p.t / p.life; ctx.globalAlpha = k; ctx.fillStyle = p.c; ctx.fillRect(p.x - p.r, p.y - p.r, p.r * 2, p.r * 2); } ctx.globalAlpha = 1; },
      clear() { P.length = 0; },
    };
  }

  /* número com separador de milhares (pontuações grandes dos jogos de ação) */
  const fmt = n => { n = Math.round(+n || 0); return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ' '); };
  const fmtScore = (n, unit) => unit === 'segundos' ? (n + ' s') : fmt(n);

  /* ---------- casca comum: vista raiz + HUD + pronto + pausa + resultado ---------- */
  let phoneOpen = true;
  function shell(win, o) {
    const baseId = String(o.id).split(':')[0];
    /* o id da casca pode ser a TABELA e não a app (Break: app `brick`, tabela `breakout`): o ícone e as estatísticas são da app */
    const def = DEFS[baseId] || GAMES.find(d => d.board === baseId) || {};
    const appId = def.id || baseId;
    const unit = o.unit || def.unit || 'pontos';
    const v = UI.view({ title: o.name, full: true, cls: 'gm gm-' + baseId });
    const cfg0 = settings();
    /* cor do jogo clara (2048, Torre, Luzes): o texto dos botões com a cor do jogo passa a escuro */
    const wrap = UI.el(`<div class="gm-wrap ${cfg0.lefty ? 'gm-lefty' : ''} ${cfg0.reduceFx ? 'gm-lowfx' : ''} ${isLight(o.color || def.color) ? 'gm-light' : ''}" style="--gm:${o.color || def.color || '#0A84FF'}">
      <div class="gm-hud"><div class="s"><span>${UI.esc(o.scoreLabel || 'Pontos')}</span><b class="sc">0</b></div>
        <div class="mid"></div>
        <div class="s r"><span>${UI.esc(o.bestLabel || 'Recorde')}</span><b class="bs">0</b></div></div>
      <div class="gm-stage"><div class="gm-fx"></div></div>
      <div class="gm-ctl"></div>
      <div class="gm-count"><b class="cn"></b></div>
      <div class="gm-toast"><span></span></div>
      <div class="gm-ready"><div class="rbox"><div class="rcov">${coverHTML(def.id ? def : { id: appId, color: o.color, kind: 'action' })}</div>
        <div class="rbd"><b class="rt"></b><span class="rs"></span>
          <div class="tap">${g('hand', 20)}<span>Toca para começar</span></div>
          <div class="rlinks"><span class="rhow">${g('book', 15)}<span>Como jogar</span></span><span class="rk">Enter ou Espaço no teclado</span></div></div></div></div>
      <div class="gm-over"><div class="box">
        <div class="rib nb">${g('sparkles', 15)}<span>Novo recorde</span></div>
        <b class="t">Fim de jogo</b><div class="sub"></div>
        <div class="res-score"><span class="lbl">${UI.esc(o.scoreLabel || 'Pontos')}</span><b class="val">0</b></div>
        <div class="res-row"><div class="res-cell"><span>Recorde</span><b class="pb">--</b></div><div class="res-cell"><span>Posição</span><b class="rk">--</b></div><div class="res-cell xpc"><span>XP ganho</span><b class="xp">+0</b></div></div>
        <div class="res-stats"></div>
        <div class="res-top"><div class="hd">Top 3 do servidor</div><div class="res-pod"></div><div class="msg"></div></div>
        <div class="btn-p again">${g('play', 16)}<span>Jogar outra vez</span></div>
        <div class="res-btns"><div class="btn-p btn-s board">${g('chart', 18)}<span>Classificações</span></div><div class="btn-p btn-s out">Sair</div></div></div></div>
      <div class="gm-paused"><div class="pbox"><div class="pic">${g('pause', 30)}</div><b>Em pausa</b><span class="pname">${UI.esc(o.name || '')}</span>
        <div class="btn-p resume">${g('play', 16)}<span>Continuar</span></div>
        <div class="prow"><div class="btn-p btn-s how">${g('book', 18)}<span>Como jogar</span></div><div class="btn-p btn-s cfg">${g('gear', 18)}<span>Definições</span></div></div>
        <div class="prow"><div class="btn-p btn-s restart">${g('update', 18)}<span>Recomeçar</span></div><div class="btn-p btn-s quit">${g('logout', 18)}<span>Sair</span></div></div></div></div>
      <div class="gm-howto"><div class="hbox"></div></div></div>`);
    v.content.appendChild(wrap);

    const el = {
      stage: wrap.querySelector('.gm-stage'), ctl: wrap.querySelector('.gm-ctl'), fx: wrap.querySelector('.gm-fx'),
      score: wrap.querySelector('.sc'), best: wrap.querySelector('.bs'),
      mid: wrap.querySelector('.mid'), over: wrap.querySelector('.gm-over'), paused: wrap.querySelector('.gm-paused'), ready: wrap.querySelector('.gm-ready'),
      count: wrap.querySelector('.gm-count'), toast: wrap.querySelector('.gm-toast'), howto: wrap.querySelector('.gm-howto'), wrap,
    };
    const low = !!o.lowerIsBetter;
    /* a chave do recorde pode MUDAR em jogo (dificuldade das Minas, tamanho da Memória): fica numa variável */
    let recId = o.id;
    const readBest = () => (low ? bestLow(recId) : best(recId));
    const writeBest = n => (low ? setBestLow(recId, n) : setBest(recId, n));
    el.best.textContent = readBest() || '--';

    let paused = false, ended = false, pbtn = null, waiting = false, readyRes = null, quick = false, shakeT = null, t0 = 0, subSeq = 0;
    let howtoOpen = false, howtoRes = null, howtoBuilt = false, toastT = null, cele = null, xp0 = null, ach0 = null;
    /* fotografia do XP e das conquistas no ARRANQUE da partida: o painel de resultado mostra o que esta partida deu */
    const snapshot = () => { try { xp0 = xp(null).xp; ach0 = {}; achievements(null).forEach(a => { if (a.done) ach0[a.id] = 1; }); } catch (e) { xp0 = null; ach0 = null; } };
    const howtoSeenKey = 'howto:' + appId;
    const api = {
      view: v, el, win, score: 0, pausable: o.pausable !== false, id: appId,
      /* câmara lenta: lugar comum que o jogo PODE ler (Arcade.loop(fn, { scale: () => A.timeScale })); a casca não o altera */
      timeScale: 1,
      get paused() { return paused; },
      get ended() { return ended; },
      get waiting() { return waiting; },
      get board() { return recId; },
      get howtoOpen() { return howtoOpen; },
      setScore(n) { api.score = n; el.score.textContent = fmt(n); },
      setMid(html) { el.mid.innerHTML = html; },
      setId(id) { recId = id; el.best.textContent = readBest() || '--'; },
      /* barra de vidas / nível, sempre em SVG */
      hearts(n, total) { let s = ''; for (let i = 0; i < (total || n); i++) s += `<i class="${i < n ? 'on' : ''}">${g('heartFill', 18)}</i>`; return `<span class="gm-hearts">${s}</span>`; },
      elapsed() { return t0 ? (Date.now() - t0) / 1000 : 0; },
      /* "Toca para começar" com a capa do jogo; na PRIMEIRA vez por jogo abre antes o cartão "Como jogar" (se o jogo o registou).
         O jogo só mexe depois do toque. Num "Jogar outra vez" (quick) resolve logo. */
      ready(title, sub) {
        if (quick) { t0 = Date.now(); snapshot(); return Promise.resolve(); }
        el.ready.querySelector('.rt').textContent = title || o.name;
        el.ready.querySelector('.rs').textContent = sub || '';
        el.ready.classList.add('in'); waiting = true; snapshot();
        if (def.howto && !opt(howtoSeenKey, 0)) { setOpt(howtoSeenKey, '1'); api.howto(); }
        return new Promise(res => { readyRes = () => { if (!waiting) return; waiting = false; readyRes = null; el.ready.classList.remove('in'); closeHowto(); t0 = Date.now(); sfx('pop'); res(); }; });
      },
      _go() { if (readyRes) readyRes(); },
      /* contagem 3, 2, 1, "Já!" sobre o palco (transform/opacity, som 'count'); resolve quando o "Já!" aparece. Em pausa espera. */
      countdown(n) {
        n = Math.max(1, Math.min(9, (n | 0) || 3));
        const layer = el.count, b = layer.querySelector('.cn');
        /* por cima do PALCO (medidas de layout, nunca getBoundingClientRect: o aparelho tem zoom) */
        const st = el.stage; layer.style.left = st.offsetLeft + 'px'; layer.style.top = st.offsetTop + 'px'; layer.style.width = st.offsetWidth + 'px'; layer.style.height = st.offsetHeight + 'px';
        layer.classList.add('in');
        return new Promise(res => {
          let k = n, done = false;
          const finish = () => { if (done) return; done = true; res(); };
          const tick = () => {
            if (ended || !wrap.isConnected) { layer.classList.remove('in'); finish(); return; }
            if (paused) { const t = setTimeout(tick, 120); win.timers.push(t); return; }
            b.textContent = k > 0 ? String(k) : 'Já!'; b.classList.remove('pop', 'go'); void b.offsetWidth; b.classList.add(k > 0 ? 'pop' : 'go');
            sfx(k > 0 ? 'count' : 'go');
            if (k > 0) { k--; const t = setTimeout(tick, 720); win.timers.push(t); }
            else { finish(); const t = setTimeout(() => layer.classList.remove('in'), 600); win.timers.push(t); }
          };
          tick();
        });
      },
      /* celebração: 'win' confetti a cair (1,6 s), 'record' fita "Novo recorde" com faíscas, 'level' explosão de estrelas ao centro */
      celebrate(kind) { celebrate(kind || 'win'); },
      /* aviso curto no palco (não é o UI.toast do sistema), 1,2 s */
      toast(msg) {
        el.toast.querySelector('span').textContent = String(msg == null ? '' : msg);
        el.toast.classList.remove('in'); void el.toast.offsetWidth; el.toast.classList.add('in');
        clearTimeout(toastT); toastT = setTimeout(() => el.toast.classList.remove('in'), 1200); win.timers.push(toastT);
      },
      /* cartão "Como jogar" do jogo (o mesmo do primeiro arranque); resolve quando fecha */
      howto() {
        if (!howtoBuilt) buildHowto();
        howtoOpen = true; el.howto.classList.add('in');
        return new Promise(res => { howtoRes = res; });
      },
      /* barra de opções (dificuldade, tamanho, paredes) no .gm-ctl: segmentos escuros, texto PT */
      options(list) {
        let bar = el.ctl.querySelector('.gm-opts');
        if (!bar) { bar = UI.el('<div class="gm-opts"></div>'); el.ctl.appendChild(bar); }
        bar.innerHTML = '';
        const setters = {};
        (list || []).forEach(op => {
          const row = UI.el(`<div class="gm-opt-row"><span class="ol">${UI.esc(op.label)}</span><div class="gm-seg"></div></div>`);
          const seg = row.querySelector('.gm-seg');
          (op.values || []).forEach(val => {
            const d = UI.el(`<div class="${String(val.v) === String(op.cur) ? 'on' : ''}">${UI.esc(val.label)}</div>`);
            d.onclick = () => { if (d.classList.contains('on')) return; [...seg.children].forEach(c => c.classList.remove('on')); d.classList.add('on'); sfx('tick'); Sound.play('click'); op.onChange && op.onChange(val.v); };
            seg.appendChild(d);
          });
          setters[op.key] = val => { [...seg.children].forEach((c, i) => c.classList.toggle('on', String((op.values[i] || {}).v) === String(val))); };
          bar.appendChild(row);
        });
        return { set: (k, val) => setters[k] && setters[k](val), el: bar };
      },
      /* texto breve a flutuar no palco (combo, nível, golo): só transform/opacity; posição opcional em px do palco */
      flash(msg, cls, x, y) {
        const f = UI.el(`<div class="gm-flash ${cls || ''}"><span>${UI.esc(String(msg))}</span></div>`);
        if (x != null && y != null) { f.style.left = Math.round(x) + 'px'; f.style.top = Math.round(y) + 'px'; f.classList.add('at'); }
        el.fx.appendChild(f);
        const t = setTimeout(() => f.remove(), 950); win.timers.push(t);
      },
      /* o mesmo, a partir de coordenadas LÓGICAS de uma tela (o canvas pode estar encolhido por zoom) */
      flashAt(cv, x, y, msg, cls) {
        const sx = (cv.clientWidth || cv.width) / cv.width, sy = (cv.clientHeight || cv.height) / cv.height;
        api.flash(msg, cls, cv.offsetLeft + x * sx, cv.offsetTop + y * sy);
      },
      /* vibração: som de toque + abanão curto do palco (transform) */
      haptic(kind) {
        const s = settings(); if (!s.haptic) return;
        Sound.play('tap');
        if (s.reduceFx) return;
        const c = kind === 'heavy' ? 'gm-shake-h' : kind === 'medium' ? 'gm-shake-m' : 'gm-shake';
        el.stage.classList.remove('gm-shake', 'gm-shake-m', 'gm-shake-h'); void el.stage.offsetWidth; el.stage.classList.add(c);
        clearTimeout(shakeT); shakeT = setTimeout(() => el.stage.classList.remove(c), 320); win.timers.push(shakeT);
      },
      sfx(name) { sfx(name); },
      /* pontuação para o servidor: { best, rank, improved, top } ou null */
      submit(score, board, meta) {
        const b = board || recId;
        const m = Object.assign({ time: Math.round(api.elapsed()) }, meta || {});
        return Promise.resolve(Bridge.rpc('arcade.submit', { game: appId, board: b, score: Math.round(+score || 0), meta: m })).then(r => r || null).catch(() => null);
      },
      pause(byUser) {
        if (paused || ended || waiting) return;
        paused = true; el.paused.classList.add('in');
        if (pbtn) pbtn.innerHTML = g('play');
        o.onPause && o.onPause();
        if (byUser) Sound.play('click');
      },
      resume() {
        if (!paused || ended) return;
        paused = false; el.paused.classList.remove('in');
        if (pbtn) pbtn.innerHTML = g('pause');
        o.onResume && o.onResume();
      },
      /* painel de resultado: celebração, fita "Novo recorde", recorde pessoal, posição, XP ganho, linhas `stats`, pódio do top 3;
         submete sozinho (salvo submit:false). r = { title, sub, score, win, board, submit, mp, stats: [{ label, value }] } */
      end(r) {
        if (ended) return;
        r = r || {};
        ended = true; paused = false; waiting = false; el.paused.classList.remove('in'); el.ready.classList.remove('in'); el.count.classList.remove('in'); closeHowto(); if (pbtn) pbtn.innerHTML = g('pause');
        const hasScore = r.score !== null && !(r.score === undefined && api.score === undefined);
        const n = r.score == null ? api.score : r.score;
        const canSubmit = r.submit !== false && hasScore && n > 0;   /* zero pontos não vai à tabela (o servidor recusava com "score") */
        const isBest = hasScore && (!low || n > 0) ? writeBest(n) : false;
        el.best.textContent = readBest() || '--';
        const box = el.over;
        box.querySelector('.t').textContent = r.title || 'Fim de jogo';
        box.querySelector('.sub').textContent = r.sub || '';
        box.querySelector('.res-score').classList.toggle('hidden', !hasScore);
        box.querySelector('.res-score .val').textContent = hasScore ? fmtScore(n, unit) : '';
        box.querySelector('.rib.nb').classList.toggle('on', isBest);
        box.querySelector('.pb').textContent = readBest() ? fmtScore(readBest(), unit) : '--';
        box.querySelector('.rk').textContent = '...';
        box.querySelector('.res-pod').innerHTML = '';
        box.querySelector('.res-top .msg').textContent = 'A ligar ao servidor';
        /* linhas de estatísticas do jogo (2 a 4) */
        const st = box.querySelector('.res-stats'); st.innerHTML = '';
        const lines = Array.isArray(r.stats) ? r.stats.filter(x => x && x.label != null).slice(0, 6) : [];
        lines.forEach(x => st.appendChild(UI.el(`<div class="rs-row"><span>${UI.esc(String(x.label))}</span><b data-noi18n>${UI.esc(String(x.value == null ? '' : x.value))}</b></div>`)));
        st.classList.toggle('hidden', !lines.length);
        box.classList.toggle('win', !!r.win); box.classList.add('in'); wrap.classList.add('gm-ended');
        if (r.win) sfx('win'); else if (isBest) sfx('score'); else sfx('lose');
        if (isBest) Sound.play('success');
        const mp = !!r.mp;
        addStat(appId, { time: api.elapsed(), win: r.win === true ? true : (mp ? r.win : undefined), mp, score: hasScore ? n : 0 });
        /* XP desta partida e conquistas desbloqueadas (fotografia tirada no arranque) */
        let gained = 0, news = [];
        /* uma partida vale sempre pelo menos 10 XP (o total pode descer se os recordes locais forem apagados a meio) */
        try { const after = xp(null); gained = xp0 != null ? Math.max(10, after.xp - xp0) : 10; if (ach0) news = achievements(null).filter(a => a.done && !ach0[a.id]); } catch (e) {}
        box.querySelector('.xp').textContent = '+' + fmt(gained);
        box.querySelector('.res-cell.xpc').classList.toggle('hidden', !gained);
        if (news.length) { news.slice(0, 3).forEach((a, i) => { const t = setTimeout(() => { api.toast('Conquista: ' + T(a.name)); sfx('chime'); }, 900 + i * 1500); win.timers.push(t); }); }
        if (r.win) celebrate('win'); else if (isBest) celebrate('record');
        const board = r.board || recId, my = ++subSeq;
        const paintTop = res => {
          if (my !== subSeq || !box.classList.contains('in')) return;
          const pod = box.querySelector('.res-pod'), msg = box.querySelector('.res-top .msg');
          if (!res || res.error) {
            box.querySelector('.rk').textContent = '--';
            msg.textContent = !res ? 'Sem ligação ao servidor' : res.error === 'game' ? 'Este jogo não tem tabela no servidor' : res.error === 'rate' ? 'Espera uns segundos entre partidas' : res.error === 'score' ? 'Pontuação fora dos limites' : 'A classificação não está disponível';
            return;
          }
          const rank = res.rank || (res.me && res.me.rank);
          box.querySelector('.rk').textContent = rank ? '#' + rank : '--';
          const top = (res.top || []).slice(0, 3);
          if (!top.length) { msg.textContent = 'Ainda sem pontuações. Sê o primeiro.'; return; }
          msg.textContent = '';
          pod.appendChild(podium(top, e => fmtScore(e.score, unit)));
        };
        if (canSubmit) api.submit(n, board, { win: !!r.win }).then(paintTop);
        else Promise.resolve(Bridge.rpc('arcade.board', { board, scope: 'all' })).then(res => paintTop(res && !res.error ? { rank: res.me && res.me.rank, top: res.top } : res)).catch(() => paintTop(null));
        api.lastBoard = board;
      },
      gameOver(title, sub, finalScore) { api.end({ title, sub, score: finalScore == null ? api.score : finalScore, win: /limpo|ganhaste|pares|resolvido/i.test(String(title || '')) }); },
      restart() {
        ended = false; paused = false; waiting = false; readyRes = null; t0 = 0; wrap.classList.remove('gm-ended');
        el.over.classList.remove('in'); el.paused.classList.remove('in'); el.ready.classList.remove('in'); el.count.classList.remove('in'); closeHowto(); if (pbtn) pbtn.innerHTML = g('pause');
        snapshot();
        quick = true; try { o.onRestart && o.onRestart(); } finally { quick = false; }
      },
    };

    /* ----- cartão "Como jogar" (construído uma vez, da definição do jogo) ----- */
    function buildHowto() {
      howtoBuilt = true;
      const h = def.howto || {}, steps = Array.isArray(h.steps) ? h.steps : [], ctl = Array.isArray(h.controls) ? h.controls : [];
      const tags = Array.isArray(def.tags) ? def.tags : [];
      const box = el.howto.querySelector('.hbox');
      box.innerHTML = `<div class="hh"><div class="hic">${window.Icons && Icons.tile ? Icons.tile(appId) : ''}</div><div class="hht"><span class="eyebrow">Como jogar</span><b>${UI.esc(o.name || def.name || '')}</b>${tags.length ? `<div class="htags">${tags.map(t => `<i>${UI.esc(String(t))}</i>`).join('')}</div>` : ''}</div></div>
        <p class="hgoal">${UI.esc(h.goal || def.desc || '')}</p>
        ${steps.length ? `<div class="hsteps">${steps.map(s => `<div class="hs"><i>${g('checkCircle', 16)}</i><span>${UI.esc(String(s))}</span></div>`).join('')}</div>` : ''}
        ${ctl.length ? `<div class="hctl">${ctl.map(c => `<div class="hc"><i>${g(c.icon || 'hand', 18)}</i><span>${UI.esc(String(c.label || ''))}</span></div>`).join('')}</div>` : ''}
        <div class="btn-p hok">Entendi</div>`;
      box.querySelector('.hok').onclick = () => { Sound.play('click'); closeHowto(); };
      el.howto.addEventListener('pointerdown', e => { if (e.target === el.howto) closeHowto(); });
    }
    function closeHowto() { if (!howtoOpen) return; howtoOpen = false; el.howto.classList.remove('in'); const r = howtoRes; howtoRes = null; if (r) r(); }
    api._closeHowto = closeHowto;

    /* ----- celebração em canvas (uma camada por cima de tudo, só enquanto dura) ----- */
    function celebrate(kind) {
      const s = settings();
      if (s.reduceFx) { if (kind === 'record') ribbon(); return; }
      const W = wrap.offsetWidth || 440, H = wrap.offsetHeight || 820;
      if (!cele) { const cv = document.createElement('canvas'); cv.className = 'gm-cele'; wrap.appendChild(cv); cele = { cv, ctx: cv.getContext('2d'), P: [], raf: 0, on: false }; }
      if (cele.cv.width !== W || cele.cv.height !== H) { cele.cv.width = W; cele.cv.height = H; }
      const P = cele.P, col = [o.color || def.color || '#0A84FF', '#FFD60A', '#FF375F', '#30D158', '#0A84FF', '#BF5AF2', '#FFFFFF'];
      const rnd = (a, b) => a + Math.random() * (b - a);
      if (kind === 'win') {
        for (let i = 0; i < 110; i++) P.push({ k: 'c', x: rnd(0, W), y: rnd(-H * .45, -10), vx: rnd(-30, 30), vy: rnd(150, 300), w: rnd(6, 11), h: rnd(4, 7), r: rnd(0, 6.28), vr: rnd(-6, 6), c: col[(Math.random() * col.length) | 0], life: 1.9, t: 0 });
      } else if (kind === 'record') {
        ribbon();
        for (let i = 0; i < 46; i++) { const a = rnd(0, 6.28), sp = rnd(120, 340); P.push({ k: 's', x: W / 2, y: H * .3, vx: Math.cos(a) * sp, vy: Math.sin(a) * sp - 80, r: rnd(2, 4), c: i % 3 ? '#FFD60A' : '#FFFFFF', life: rnd(.6, 1.1), t: 0 }); }
      } else {
        for (let i = 0; i < 30; i++) { const a = rnd(0, 6.28), sp = rnd(90, 300); P.push({ k: 'st', x: W / 2, y: H * .42, vx: Math.cos(a) * sp, vy: Math.sin(a) * sp - 60, r: rnd(6, 13), rot: rnd(0, 6.28), vr: rnd(-4, 4), c: col[(Math.random() * col.length) | 0], life: rnd(.7, 1.1), t: 0 }); }
      }
      if (cele.on) return;
      cele.on = true; let last = 0;
      const ctx = cele.ctx;
      const star = (x, y, r, rot) => { ctx.beginPath(); for (let i = 0; i < 10; i++) { const rr = i % 2 ? r * .45 : r, a = rot + i * Math.PI / 5; ctx.lineTo(x + Math.cos(a) * rr, y + Math.sin(a) * rr); } ctx.closePath(); ctx.fill(); };
      const step = t => {
        if (!cele || !cele.on) return;
        const dt = Math.min(.05, last ? (t - last) / 1000 : .016); last = t;
        ctx.clearRect(0, 0, W, H);
        for (let i = P.length - 1; i >= 0; i--) {
          const p = P[i]; p.t += dt; if (p.t >= p.life || p.y > H + 20) { P.splice(i, 1); continue; }
          const k = 1 - p.t / p.life;
          if (p.k === 'c') { p.vy += 60 * dt; p.x += p.vx * dt + Math.sin(p.t * 6 + p.y * .02) * 40 * dt; p.y += p.vy * dt; p.r += p.vr * dt; ctx.globalAlpha = Math.min(1, k * 3); ctx.fillStyle = p.c; const cs = Math.cos(p.r), sn = Math.sin(p.r), sy = Math.max(.2, Math.abs(Math.cos(p.t * 7 + p.r))); ctx.setTransform(cs, sn, -sn * sy, cs * sy, p.x, p.y); ctx.fillRect(-p.w / 2, -p.h / 2, p.w, p.h); ctx.setTransform(1, 0, 0, 1, 0, 0); }
          else if (p.k === 's') { p.vy += 420 * dt; p.x += p.vx * dt; p.y += p.vy * dt; ctx.globalAlpha = k; ctx.fillStyle = p.c; ctx.fillRect(p.x - p.r / 2, p.y - p.r / 2, p.r, p.r); }
          else { p.vy += 260 * dt; p.x += p.vx * dt; p.y += p.vy * dt; p.rot += p.vr * dt; ctx.globalAlpha = k; ctx.fillStyle = p.c; star(p.x, p.y, p.r * (.5 + k * .5), p.rot); }
        }
        ctx.globalAlpha = 1;
        if (!P.length || !wrap.isConnected) { cele.on = false; ctx.clearRect(0, 0, W, H); return; }
        cele.raf = requestAnimationFrame(step);
      };
      cele.raf = requestAnimationFrame(step);
    }
    /* fita "Novo recorde" que desce no topo do palco (transform/opacity) e se vai embora */
    function ribbon() {
      const rb = UI.el(`<div class="gm-ribbon">${g('sparkles', 18)}<span>Novo recorde</span></div>`);
      wrap.appendChild(rb);
      const t = setTimeout(() => rb.remove(), 2300); win.timers.push(t);
    }
    const stopCele = () => { if (cele && cele.on) { cele.on = false; cancelAnimationFrame(cele.raf); cele.P.length = 0; try { cele.ctx.clearRect(0, 0, cele.cv.width, cele.cv.height); } catch (e) {} } };

    el.ready.addEventListener('pointerdown', e => { e.preventDefault(); api._go(); });
    el.ready.querySelector('.rhow').addEventListener('pointerdown', e => { e.stopPropagation(); e.preventDefault(); Sound.play('click'); api.howto(); });
    wrap.querySelector('.again').onclick = () => api.restart();
    wrap.querySelector('.out').onclick = () => { el.over.classList.remove('in'); System.closeApp(); };
    wrap.querySelector('.board').onclick = () => { el.over.classList.remove('in'); openBoard(api.lastBoard || recId); };
    wrap.querySelector('.resume').onclick = () => api.resume();
    wrap.querySelector('.restart').onclick = () => api.restart();
    wrap.querySelector('.pbox .how').onclick = () => { Sound.play('click'); api.howto(); };
    wrap.querySelector('.pbox .cfg').onclick = () => { Sound.play('click'); openSettings(); };
    wrap.querySelector('.pbox .quit').onclick = () => { Sound.play('click'); System.closeApp(); };
    const prevClose = win.onClose;
    win.onClose = () => { stopCele(); try { prevClose && prevClose(); } catch (e) {} };

    /* botões da barra de navegação: pausa (só nos jogos em tempo real) e recomeçar */
    const right = v.querySelector('.nb-right');
    if (o.pausable !== false) {
      const p = UI.el(`<div class="nb-btn">${g('pause')}</div>`);
      p.onclick = () => (paused ? api.resume() : api.pause(true));
      right.appendChild(p); pbtn = p;
    }
    const r = UI.el(`<div class="nb-btn">${g('update')}</div>`);
    r.onclick = async () => {
      if (api.ended) { api.restart(); return; }
      if (o.pausable !== false) api.pause();
      if (await UI.confirm('Recomeçar', 'Perdes o jogo atual.', 'Recomeçar', true)) api.restart();
    };
    /* deitar o telemóvel (System.rotate): a janela passa a 956×440 e a tela tem de caber no palco: `zoom` encolhe-a. */
    const rot = UI.el(`<div class="nb-btn g-rot">${g('rotate', 20)}</div>`);
    rot.onclick = () => { if (window.System && System.rotate) System.rotate(!System.landscape); };
    right.appendChild(rot);
    const fit = () => { const kid = [...el.stage.children].find(k => !k.classList.contains('gm-fx')); if (!kid) return;
      if (!win.classList.contains('ls')) { kid.style.zoom = ''; return; }
      /* medidas de LAYOUT (clientWidth/offsetWidth), nunca getBoundingClientRect: o aparelho está a rodar durante .5 s */
      kid.style.zoom = ''; const sw = el.stage.clientWidth || 1, sh = el.stage.clientHeight || 1, kw = kid.offsetWidth || 1, kh = kid.offsetHeight || 1;
      const f = Math.min(1, (sh - 8) / kh, (sw - 8) / kw); kid.style.zoom = f < 1 ? f.toFixed(3) : ''; };
    /* NADA de `Bridge.on('rotate')` aqui (cada jogo faz win.onClose por cima): há UMA subscrição global no fim do ficheiro */
    setTimeout(fit, 60);
    api.fit = fit;
    right.appendChild(r);

    UI.setRoot(win, v);
    win._gs = api;   /* a casca fica acessível à janela: guardar o telemóvel, teclado global e o harness passam por aqui */
    return api;
  }

  /* ---------- capas ----------
     cover: () => '<svg viewBox="0 0 400 200">...</svg>' no registo do jogo (arte própria, 2:1). Sem cover, a casca desenha uma
     capa automática a partir do ícone (Icons.tile) e da cor do jogo: gradiente profundo, formas suaves e um padrão por tipo
     (riscas de velocidade na ação, grelha nos puzzles, xadrez nos tabuleiros). coverHTML(def) devolve o bloco pronto a inserir. */
  const coverCache = new Map();
  const hex = c => { const m = /^#?([0-9a-f]{6})$/i.exec(String(c || '').trim()); if (!m) return [10, 132, 255]; const n = parseInt(m[1], 16); return [n >> 16 & 255, n >> 8 & 255, n & 255]; };
  const mix = (c, k, to) => { const a = hex(c), b = to === 'w' ? [255, 255, 255] : [6, 7, 12]; return 'rgb(' + a.map((x, i) => Math.round(x + (b[i] - x) * k)).join(',') + ')'; };
  const rgba = (c, a) => 'rgba(' + hex(c).join(',') + ',' + a + ')';
  /* luminância relativa acima de .7 = cor clara (texto escuro por cima) */
  const isLight = c => { if (!c) return false; const [r, gg, b] = hex(c); return (.2126 * r + .7152 * gg + .0722 * b) / 255 > .7; };
  function autoCover(d) {
    const c = d.color || '#0A84FF', k = d.kind || 'action', u = 'cv' + String(d.id).replace(/[^a-z0-9]/gi, '');
    let pat = '';
    if (k === 'action') { for (let i = 0; i < 7; i++) pat += `<path d="M${-40 + i * 70} 230 L${80 + i * 70} -30" stroke="${rgba('#FFFFFF', .06 + (i % 2) * .04)}" stroke-width="${18 + (i % 3) * 8}"/>`; }
    else if (k === 'puzzle') { for (let y = 0; y < 5; y++) for (let x = 0; x < 9; x++) pat += `<rect x="${12 + x * 46}" y="${12 + y * 46}" width="36" height="36" rx="8" fill="${rgba('#FFFFFF', ((x + y) % 3) * .025 + .02)}"/>`; }
    else { for (let y = 0; y < 4; y++) for (let x = 0; x < 8; x++) if ((x + y) % 2 === 0) pat += `<rect x="${x * 50}" y="${y * 50}" width="50" height="50" fill="${rgba('#FFFFFF', .05)}"/>`; }
    return `<svg viewBox="0 0 400 200" preserveAspectRatio="xMidYMid slice" aria-hidden="true"><defs>
      <linearGradient id="${u}a" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${mix(c, .55, 'd')}"/><stop offset=".55" stop-color="${mix(c, .2, 'd')}"/><stop offset="1" stop-color="${mix(c, .1, 'w')}"/></linearGradient>
      <radialGradient id="${u}b" cx=".8" cy=".15" r=".7"><stop offset="0" stop-color="${rgba('#FFFFFF', .32)}"/><stop offset="1" stop-color="${rgba('#FFFFFF', 0)}"/></radialGradient>
      <radialGradient id="${u}c" cx=".2" cy="1" r=".7"><stop offset="0" stop-color="${rgba('#000000', .4)}"/><stop offset="1" stop-color="${rgba('#000000', 0)}"/></radialGradient></defs>
      <rect width="400" height="200" fill="url(#${u}a)"/>${pat}<rect width="400" height="200" fill="url(#${u}b)"/><rect width="400" height="200" fill="url(#${u}c)"/>
      <circle cx="330" cy="40" r="120" fill="${rgba('#FFFFFF', .07)}"/><circle cx="40" cy="190" r="90" fill="${rgba('#000000', .14)}"/>
      <path d="M0 150 C 90 120, 160 190, 400 130 L400 200 L0 200 Z" fill="${rgba('#000000', .18)}"/></svg>`;
  }
  const fixSvg = s => (/preserveAspectRatio=/.test(s) ? s : String(s).replace(/<svg\b/, '<svg preserveAspectRatio="xMidYMid slice"'));
  function coverHTML(d) {
    if (!d) return '';
    const key = d.id + (d.cover ? ':art' : ':auto');
    let s = coverCache.get(key);
    if (s === undefined) {
      let art = null;
      if (typeof d.cover === 'function') { try { art = d.cover(); } catch (e) { art = null; } }
      if (art && /<svg/i.test(art)) s = `<div class="cov cov-art">${fixSvg(art)}</div>`;
      else s = `<div class="cov cov-auto" style="--c:${d.color || '#0A84FF'}">${autoCover(d)}<div class="cov-ic">${window.Icons && Icons.tile ? Icons.tile(d.id) : ''}</div></div>`;
      coverCache.set(key, s);
    }
    return s;
  }
  const cover = id => coverHTML(DEFS[id] || null);

  /* ---------- registo de um jogo ---------- */
  function game(id, o) {
    const def = {
      id, name: o.name, color: o.color || '#0A84FF', lower: !!o.lowerIsBetter, unit: o.unit || 'pontos', kind: o.kind || 'action',
      desc: o.desc || '', variants: Array.isArray(o.variants) ? o.variants.slice() : null, mp: !!o.mp, players: o.players || (o.mp ? 2 : 1),
      board: o.board || id, scoreLabel: o.scoreLabel || 'Pontos', bestLabel: o.bestLabel || 'Recorde',
      /* ronda 2 (SPEC-GAMES-2 3.1): capa, "Como jogar", etiquetas e modos (só informativos) */
      cover: typeof o.cover === 'function' ? o.cover : null,
      howto: o.howto && typeof o.howto === 'object' ? o.howto : null,
      tags: Array.isArray(o.tags) ? o.tags.slice(0, 3).map(String) : [],
      modes: Array.isArray(o.modes) ? o.modes.slice() : null,
    };
    /* chaves das tabelas deste jogo (uma por variante) */
    /* uma variante pode trazer a sua tabela, sentido e unidade: { key, label, board, lower, unit }
       (2048 4×4 = 'g2048' e 5×5 = 'g2048:5'; Blocos Sprint em segundos, quanto menos melhor; Memória contra o relógio em pares) */
    const varOf = key => (def.variants || []).find(v => String(v.key) === String(key)) || null;
    def.boardOf = key => { const x = varOf(key); return x ? (x.board || def.board + ':' + x.key) : (def.variants ? def.board + ':' + key : def.board); };
    def.boards = () => def.variants ? def.variants.map(x => def.boardOf(x.key)) : [def.board];
    const varByBoard = b => (def.variants || []).find(v => def.boardOf(v.key) === b) || null;
    def.variantOf = b => { const x = varByBoard(b); return x ? x.key : null; };
    def.lowerOf = b => { const x = varByBoard(b); return x && x.lower != null ? !!x.lower : def.lower; };
    def.unitOf = b => { const x = varByBoard(b); return (x && x.unit) || def.unit; };
    if (!DEFS[id]) GAMES.push(def); else GAMES.splice(GAMES.findIndex(x => x.id === id), 1, def);
    DEFS[id] = def; coverCache.delete(id + ':art'); coverCache.delete(id + ':auto');
    App.define(id, {
      /* statusBar:'dark' = app de fundo escuro (a hora ficava preta sobre o palco preto) */
      name: o.name, category: 'Jogos', description: o.desc, statusBar: 'dark', landscape: o.landscape !== false,
      open(win) { win._g = o.build(win) || null; },
      pause(win) { try { win._g && win._g.pause && win._g.pause(); } catch (e) {} },
      resume(win) { try { win._g && win._g.resume && win._g.resume(); } catch (e) {} },
    });
    Bridge.emit('arcade:games', id);
  }
  const list = () => GAMES.map(d => Object.assign({}, d));
  const def = id => DEFS[id] || null;

  /* ---------- hub: abrir numa tabela (botão "Classificação" do resultado) ---------- */
  let hubIntent = null;
  function openBoard(board) {
    hubIntent = { tab: 1, board };
    if (System.currentApp() === 'arcade') { const w = System.windows.arcade; if (w && w._intent) w._intent(hubIntent); return; }
    System.openApp('arcade');
  }
  const takeIntent = () => { const i = hubIntent; hubIntent = null; return i; };

  /* ---------- multijogador por turnos (cliente) ----------
     RPCs arcade.match.* no server/arcade.lua. Pushes: arcade:invite { id, game, from, seconds },
     arcade:match { id, game, you, turn, players {a,b}, state, moves, left, ended, winner, reason, last }. */
  const matches = {};
  let pendingMatch = null;
  const rpc = (n, d) => Promise.resolve(Bridge.rpc(n, d || {})).then(r => r || { error: 'offline' }).catch(() => ({ error: 'offline' }));
  const match = {
    invite(o) { return rpc('arcade.match.invite', o); },
    accept(o) { return rpc('arcade.match.accept', o).then(r => { if (r && r.id && !r.error) matches[r.id] = r; return r; }); },
    decline(o) { return rpc('arcade.match.decline', o); },
    move(o) { return rpc('arcade.match.move', o).then(r => { if (r && r.id && !r.error) matches[r.id] = r; return r; }); },
    state(o) { return rpc('arcade.match.state', o).then(r => { if (r && r.id && !r.error) matches[r.id] = r; return r; }); },
    leave(o) { if (o && o.id) delete matches[o.id]; return rpc('arcade.match.leave', o); },
    nearby() { return rpc('arcade.match.nearby', {}).then(r => Array.isArray(r) ? r : (r && Array.isArray(r.list) ? r.list : [])); },
    /* partida ativa deste jogo (quando a app abre por uma mensagem ou pelo ícone, sem convite à vista) */
    pending(gameId) { return rpc('arcade.match.state', { game: gameId }).then(r => (r && r.id && !r.error && !r.ended) ? r : null); },
    mine() { return rpc('arcade.match.state', {}).then(r => (r && Array.isArray(r.matches)) ? r.matches : []); },
    on(fn) { return Bridge.on('arcade:match', fn); },
    get all() { return matches; },
  };
  function openGame(gameId, m) {
    pendingMatch = m || null;
    if (!App.get(gameId)) { UI.toast('Esse jogo não está instalado'); return; }
    if (System.windows[gameId]) System.killApp(gameId);   /* nasce de novo com a partida pendente */
    System.openApp(gameId);
  }

  /* faixa de convite (uma de cada vez), com Aceitar/Recusar e a barra do tempo */
  let inviteEl = null, inviteT = null, inviteId = null;
  function hideInvite() { if (inviteEl) { inviteEl.classList.remove('in'); const e = inviteEl; setTimeout(() => e.remove(), 300); inviteEl = null; } clearTimeout(inviteT); inviteId = null; }
  function showInvite(d) {
    if (!d || !d.id) return;
    hideInvite();
    const gd = DEFS[d.game], name = gd ? gd.name : String(d.game || 'Arcade');
    const box = UI.el(`<div class="gm-invite"><div class="ic">${gd && window.Icons ? Icons.tile(d.game) : g('gamepad', 28)}</div>
      <div class="bd"><b data-noi18n>${UI.esc(d.from || 'Alguém')}</b><span><em>convida-te para jogar</em> <i data-noi18n>${UI.esc(name)}</i></span></div>
      <div class="acts"><div class="no">${g('x', 20)}</div><div class="yes">${g('check', 20)}</div></div><div class="bar"><i></i></div></div>`);
    const screen = document.getElementById('screen') || document.body;
    screen.appendChild(box); inviteEl = box; inviteId = d.id;
    const secs = Math.max(5, +d.seconds || 60);
    requestAnimationFrame(() => { box.classList.add('in'); const bar = box.querySelector('.bar i'); bar.style.transitionDuration = secs + 's'; requestAnimationFrame(() => bar.classList.add('run')); });
    Sound.play('notify');
    box.querySelector('.no').onclick = () => { const id = inviteId; hideInvite(); match.decline({ id }); };
    box.querySelector('.yes').onclick = async () => {
      const id = inviteId; hideInvite();
      const r = await match.accept({ id });
      if (!r || r.error) { UI.toast(r && r.error === 'busy' ? 'Já tens uma partida desse jogo a decorrer' : 'O convite já não é válido'); return; }
      openGame(r.game, r);
    };
    inviteT = setTimeout(hideInvite, secs * 1000);
  }
  let lastTurnToast = 0;
  if (window.Bridge && Bridge.on) {
    Bridge.on('arcade:invite', showInvite);
    Bridge.on('arcade:match', m => {
      if (!m || !m.id) return;
      if (m.invite) {   /* resposta a um convite meu */
        if (inviteId === m.id) hideInvite();
        if (m.reason === 'declined') UI.toast((m.from || 'O outro jogador') + ' recusou o convite');
        else if (m.reason === 'expired') UI.toast('O convite expirou');
        return;
      }
      if (m.ended) delete matches[m.id]; else matches[m.id] = m;
      /* é a minha vez e o jogo não está à frente: um aviso do sistema leva lá */
      if (!m.ended && m.turn === m.you && System.currentApp() !== m.game && Date.now() - lastTurnToast > 4000) {
        lastTurnToast = Date.now();
        const gd = DEFS[m.game];
        try { System.notify({ app: App.get(m.game) ? m.game : 'arcade', title: gd ? gd.name : 'Arcade', msg: 'É a tua vez', onTap: () => openGame(m.game, m) }); } catch (e) {}
      }
    });
    Bridge.on('phone:close', () => { phoneOpen = false; });
    Bridge.on('phone:open', () => { phoneOpen = true; });
  }

  /* faixa "É a tua vez / Vez de X" + relógio de 45 s no HUD; segue os pushes da partida.
     h.onMove(m) corre em cada estado novo (incluindo o eco da própria jogada: comparar m.moves).
     h.auto !== false: no fim mostra o resultado (A.end) sozinho. */
  function matchUI(A, m, h) {
    h = h || {};
    const strip = UI.el(`<div class="gm-match"><div class="who"><i class="dot"></i><b class="turn"></b><span class="nm" data-noi18n></span></div>
      <div class="tm"><svg viewBox="0 0 36 36"><circle class="bg" cx="18" cy="18" r="15"/><circle class="fg" cx="18" cy="18" r="15"/></svg><span class="secs">45</span></div></div>`);
    A.setMid(''); A.el.mid.appendChild(strip);
    let cur = Object.assign({}, m), deadline = Date.now() + (cur.left != null ? +cur.left : 45000), iv = null, off = null, lastTick = -1, done = false;
    const names = () => cur.players || {};
    const paint = () => {
      const mine = cur.turn === cur.you;
      strip.classList.toggle('mine', mine); strip.classList.toggle('over', !!cur.ended);
      strip.querySelector('.turn').textContent = cur.ended ? 'Partida terminada' : (mine ? 'É a tua vez' : 'Vez de');
      strip.querySelector('.nm').textContent = (!cur.ended && !mine) ? (names()[cur.turn] || '...') : '';
    };
    const tick = () => {
      const left = cur.ended ? 0 : Math.max(0, deadline - Date.now()), s = Math.ceil(left / 1000), fr = Math.max(0, Math.min(1, left / 45000));
      strip.querySelector('.secs').textContent = s;
      strip.querySelector('.fg').style.strokeDashoffset = (94.2 * (1 - fr)).toFixed(1);
      const mine = cur.turn === cur.you;
      strip.classList.toggle('low', !cur.ended && mine && s <= 10);
      if (!cur.ended && mine && s <= 10 && s > 0 && s !== lastTick) { lastTick = s; sfx('tick'); }
    };
    const finish = () => { if (done) return; done = true; clearInterval(iv); if (off) { off(); off = null; } };
    const apply = d => {
      cur = Object.assign({}, cur, d); deadline = Date.now() + (cur.left != null ? +cur.left : 45000); paint(); tick();
      if (h.onMove) { try { h.onMove(cur); } catch (e) { console.error('[arcade] onMove', e); } }
      if (cur.ended) {
        finish();
        if (h.auto !== false && !A.ended) {
          const meWon = cur.winner === cur.you, draw = cur.winner === 'draw' || !cur.winner;
          const other = names()[cur.you === 'a' ? 'b' : 'a'] || 'O adversário';
          const why = cur.reason === 'timeout' ? (meWon ? other + ' ficou sem tempo' : 'Ficaste sem tempo') : cur.reason === 'left' ? (meWon ? other + ' saiu da partida' : 'Saíste da partida') : draw ? 'Ninguém ganhou' : (meWon ? 'Venceste ' + other : other + ' venceu');
          A.end({ title: draw ? 'Empate' : meWon ? 'Ganhaste' : 'Perdeste', sub: why, score: null, win: draw ? undefined : meWon, mp: true, board: cur.game, submit: false });
        }
      }
    };
    iv = setInterval(tick, 250); A.win.timers.push(iv);
    off = Bridge.on('arcade:match', d => { if (d && d.id === cur.id && !d.invite) apply(d); });
    paint(); tick();
    return { update: apply, destroy: finish, el: strip, get match() { return cur; }, get mine() { return cur.turn === cur.you; } };
  }

  /* ---------- teclado físico: UM ouvinte global, entregue ao jogo em primeiro plano ---------- */
  const fg = () => { try { const id = System.currentApp(); const w = id && System.windows[id]; return w && (w._g || w._gs) ? w : null; } catch (e) { return null; } };
  const typing = () => { const a = document.activeElement; return !!(a && a.matches && a.matches('input, textarea, [contenteditable]:not([contenteditable="false"])')); };
  document.addEventListener('keydown', e => {
    if (!phoneOpen || typing()) return;
    const w = fg(); if (!w) return;
    const sh = w._gs;
    /* cartão "Como jogar" aberto: Enter, Espaço ou Escape fecham-no (nada chega ao jogo) */
    if (sh && sh.howtoOpen) { if (e.key === 'Enter' || e.key === ' ' || e.key === 'Escape') { e.preventDefault(); sh._closeHowto && sh._closeHowto(); } return; }
    if (sh && sh.waiting) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); sh._go(); } return; }
    if (sh && sh.ended) { if (e.key === 'Enter') { e.preventDefault(); sh.restart(); } return; }
    /* P pausa e retoma (Escape é do aparelho: o hardware.js fecha o telemóvel com ele) */
    if (sh && sh.paused) { if (e.key === 'p' || e.key === 'P') { e.preventDefault(); sh.resume(); } return; }
    if (sh && sh.pausable && (e.key === 'p' || e.key === 'P')) { e.preventDefault(); sh.pause(true); return; }
    try { w._g && w._g.key && w._g.key(e); } catch (x) { console.error('[arcade] key', x); }
  });
  /* mapa comum de teclas → direção (setas e WASD) */
  const keyDir = e => ({ ArrowUp: 'u', ArrowDown: 'd', ArrowLeft: 'l', ArrowRight: 'r', w: 'u', W: 'u', s: 'd', S: 'd', a: 'l', A: 'l', d: 'r', D: 'r' })[e.key] || null;

  /* Guardar o telemóvel NÃO passa pelo hideCurrent() do System: o jogo em primeiro plano continuava a correr às
     escuras. Pausa ao guardar; nos jogos em tempo real fica a camada "Em pausa", os outros retomam ao voltar. */
  if (window.Bridge && Bridge.on) {
    Bridge.on('phone:close', () => { const w = fg(); if (!w) return; try { if (w._gs && w._gs.pausable) w._gs.pause(); else if (w._g && w._g.pause) w._g.pause(); } catch (e) {} });
    Bridge.on('phone:open', () => { const w = fg(); if (!w) return; try { if (!(w._gs && w._gs.pausable) && w._g && w._g.resume) w._g.resume(); } catch (e) {} });
    Bridge.on('rotate', () => { const run = () => { const w = fg(); try { w && w._gs && w._gs.fit && w._gs.fit(); } catch (e) {} }; setTimeout(run, 60); setTimeout(run, 600); });
  }

  /* ---------- conquistas (48): 24 antigas + 24 da tabela da SPEC-GAMES-2 (secção 5), com as chaves EXATAS que os jogos marcam
     (Arcade.flag / Arcade.maxStat). Contadas localmente; as da tabela validadas pelo servidor (arcade.me). Ícones SVG próprios
     (traço + preenchimento em currentColor, nunca cores fixas: a cor vem do estado feito / por fazer). ---------- */
  const AI = {
    play: '<circle cx="12" cy="12" r="9.5"/><path d="M10 8.3v7.4l5.8-3.7z" fill="currentColor" stroke="none"/>',
    ten: '<circle cx="12" cy="13" r="8"/><path d="M10 2.5h4M12 2.5v2.5"/><path d="M12.8 8.5 10 13.5h4l-2.8 5"/>',
    hundred: '<circle cx="12" cy="9.5" r="6"/><path d="M12 6.4l.95 1.95 2.15.3-1.55 1.5.35 2.15L12 11.3l-1.9 1 .35-2.15-1.55-1.5 2.15-.3z" fill="currentColor" stroke="none"/><path d="M9 15 7.5 21l4.5-2.4 4.5 2.4L15 15"/>',
    clock: '<path d="M7 3h10M7 21h10M8 3v3.5c0 2 1.5 3.5 3 4.5l1 1-1 1c-1.5 1-3 2.5-3 4.5V21M16 3v3.5c0 2-1.5 3.5-3 4.5l-1 1 1 1c1.5 1 3 2.5 3 4.5V21"/><path d="M9.5 19.5h5L12 16.5z" fill="currentColor" stroke="none"/>',
    marathon: '<circle cx="15" cy="4.5" r="2" fill="currentColor" stroke="none"/><path d="M9 21l2.5-6.5M13.5 21l-1.5-5-3-3 2.5-5 4 2.5 3 1M8 10l3-2M3 21h3M18 21h3"/>',
    snake: '<path d="M5 18c0-3 2.5-4.5 5-4.5h4c2.5 0 4.5-2 4.5-4.5S16.5 4.5 14 4.5"/><circle cx="5" cy="18" r="2.4" fill="currentColor" stroke="none"/><circle cx="14" cy="4.5" r="1.4" fill="currentColor" stroke="none"/>',
    snake2: '<path d="M4 17c0-2.5 2-4 4.5-4h7c2 0 3.5-1.5 3.5-3.5S17.5 6 15.5 6H9"/><path d="M9 6a2 2 0 1 0 0-4"/><circle cx="4" cy="17" r="2.4" fill="currentColor" stroke="none"/>',
    python: '<path d="M3 8c0 2 1.5 3 3.5 3h11c2 0 3.5 1.2 3.5 3.2s-1.5 3.3-3.5 3.3H6"/><path d="M3 8c0-2 1.5-3 3.5-3h8"/><circle cx="6" cy="17.5" r="2.3" fill="currentColor" stroke="none"/><circle cx="14.5" cy="5" r="1.3" fill="currentColor" stroke="none"/>',
    gold: '<path d="M12 7.6c-1.5-1.6-4-1.6-5.5.4S5 13.6 7 17.6c1 2 2.5 3 3.5 2.5.5-.2 1-.2 1.5 0 1 .5 2.5-.5 3.5-2.5 2-4 2-7.6.5-9.6s-4-2-5.5-.4z" fill="currentColor" stroke="none"/><path d="M12 7.5V5M12 5c1-1.6 2.4-2.2 4-2.2-.4 1.6-1.5 2.6-4 2.2z"/>',
    tiles: '<rect x="3.5" y="3.5" width="7.5" height="7.5" rx="1.8"/><rect x="13" y="3.5" width="7.5" height="7.5" rx="1.8"/><rect x="3.5" y="13" width="7.5" height="7.5" rx="1.8"/><rect x="13" y="13" width="7.5" height="7.5" rx="1.8" fill="currentColor"/>',
    tiles2: '<rect x="3.5" y="3.5" width="7.5" height="7.5" rx="1.8" fill="currentColor"/><rect x="13" y="3.5" width="7.5" height="7.5" rx="1.8"/><rect x="3.5" y="13" width="7.5" height="7.5" rx="1.8"/><rect x="13" y="13" width="7.5" height="7.5" rx="1.8" fill="currentColor"/>',
    lines: '<rect x="3" y="4" width="18" height="3.6" rx="1"/><rect x="3" y="10.2" width="18" height="3.6" rx="1" fill="currentColor"/><rect x="3" y="16.4" width="12" height="3.6" rx="1"/>',
    tetris: '<rect x="9.4" y="2.4" width="5.2" height="4" rx=".8" fill="currentColor" stroke="none"/><rect x="9.4" y="7.1" width="5.2" height="4" rx=".8" fill="currentColor" stroke="none"/><rect x="9.4" y="11.8" width="5.2" height="4" rx=".8" fill="currentColor" stroke="none"/><rect x="9.4" y="16.5" width="5.2" height="4" rx=".8" fill="currentColor" stroke="none"/><path d="M3 21.5h18"/>',
    tspin: '<path d="M8 3.5h8v4.2h-2v4.3h-4V7.7H8z" fill="currentColor" stroke="none"/><path d="M4.5 15.5a7.5 7.5 0 0 0 13.2 3.3M19.5 14.5a7.5 7.5 0 0 0-1.3-2.3"/><path d="M19.8 10.5v4.2h-4.2"/>',
    sprint: '<path d="M13 2 5 13.5h6L10 22l9-12h-6z" fill="currentColor" stroke="none"/>',
    mine: '<circle cx="12" cy="13" r="5.5" fill="currentColor" stroke="none"/><path d="M12 4.5v3M4.5 13h3M16.5 13h3M12 18.5v3M6.7 7.7l2.1 2.1M17.3 7.7l-2.1 2.1M6.7 18.3l2.1-2.1M17.3 18.3l-2.1-2.1"/>',
    skull: '<path d="M12 3a7.5 7.5 0 0 0-7.5 7.5c0 2.6 1.4 4.6 3 5.8V19a1 1 0 0 0 1 1h7a1 1 0 0 0 1-1v-2.7c1.6-1.2 3-3.2 3-5.8A7.5 7.5 0 0 0 12 3z"/><circle cx="9.3" cy="11" r="1.6" fill="currentColor" stroke="none"/><circle cx="14.7" cy="11" r="1.6" fill="currentColor" stroke="none"/><path d="M10.5 16.5h3"/>',
    noflag: '<path d="M5 21V4h10l-2 3.5 2 3.5H5"/><path d="M4 20 20 4"/>',
    brain: '<path d="M9.5 4a3 3 0 0 0-3 3v1a3 3 0 0 0 0 6v1a3 3 0 0 0 3 3h1.5V4zM14.5 4a3 3 0 0 1 3 3v1a3 3 0 0 1 0 6v1a3 3 0 0 1-3 3H13V4z"/><path d="M8.5 9h2M13.5 9h2M8.5 14h2M13.5 14h2"/>',
    perfect: '<rect x="3" y="6" width="9" height="12" rx="2"/><rect x="12" y="6" width="9" height="12" rx="2"/><path d="M12 9.2l1 2.1 2.3.3-1.7 1.6.4 2.3-2-1.1-2 1.1.4-2.3-1.7-1.6 2.3-.3z" fill="currentColor" stroke="none"/>',
    ball: '<rect x="3" y="4" width="5.5" height="3" rx=".8" fill="currentColor" stroke="none"/><rect x="9.25" y="4" width="5.5" height="3" rx=".8" fill="currentColor" stroke="none"/><rect x="15.5" y="4" width="5.5" height="3" rx=".8" fill="currentColor" stroke="none"/><circle cx="12" cy="13.5" r="2.2" fill="currentColor" stroke="none"/><rect x="8" y="19" width="8" height="2.5" rx="1.2"/>',
    shield: '<path d="M12 3l7.5 3v6c0 4.5-3.2 7.8-7.5 9-4.3-1.2-7.5-4.5-7.5-9V6z"/><path d="m9 12 2 2 4-4"/>',
    multi: '<circle cx="7" cy="8" r="3" fill="currentColor" stroke="none"/><circle cx="17" cy="8" r="3" fill="currentColor" stroke="none"/><circle cx="12" cy="16" r="3" fill="currentColor" stroke="none"/>',
    grid: '<rect x="3" y="3" width="18" height="18" rx="3"/><path d="M3 9h18M3 15h18M9 3v18M15 3v18"/><rect x="9" y="9" width="6" height="6" fill="currentColor" stroke="none"/>',
    list: '<path d="M8 6h13M8 12h13M8 18h13"/><circle cx="4" cy="6" r="1.4" fill="currentColor" stroke="none"/><circle cx="4" cy="12" r="1.4" fill="currentColor" stroke="none"/><circle cx="4" cy="18" r="1.4" fill="currentColor" stroke="none"/>',
    medal: '<path d="m8 3 2.5 6M16 3l-2.5 6"/><circle cx="12" cy="14" r="6"/><path d="M12 10.8l1 2 2.2.3-1.6 1.5.4 2.2-2-1.1-2 1.1.4-2.2-1.6-1.5 2.2-.3z" fill="currentColor" stroke="none"/>',
    crown: '<path d="M4 18h16l1.2-10.5-5.2 4.3L12 5l-4 6.8-5.2-4.3z" fill="currentColor" stroke="none"/><path d="M5 21h14"/>',
    stars: '<path d="M12 2.5l1.5 3.2 3.5.5-2.5 2.4.6 3.4-3.1-1.7-3.1 1.7.6-3.4L7 6.2l3.5-.5z" fill="currentColor" stroke="none"/><path d="M5 13l.9 1.9 2.1.3-1.5 1.5.4 2.1L5 17.8l-1.9 1 .4-2.1L2 15.2l2.1-.3zM19 13l.9 1.9 2.1.3-1.5 1.5.4 2.1-1.9-1-1.9 1 .4-2.1-1.5-1.5 2.1-.3z"/>',
    swords: '<path d="M4 4l10 10M20 4 10 14M14 14l4 4M10 14l-4 4M3 21l4-4M21 21l-4-4"/><path d="M4 4h3.5v3.5zM20 4h-3.5v3.5z" fill="currentColor" stroke="none"/>',
    trophy: '<path d="M8 4h8v5a4 4 0 0 1-8 0z" fill="currentColor" stroke="none"/><path d="M8 5.5H5v1.5a3 3 0 0 0 3 3M16 5.5h3v1.5a3 3 0 0 1-3 3M12 13v4M8.5 20.5h7M10 17h4v3.5h-4z"/>',
    flame: '<path d="M12 2.5c1.2 3.8 5 5.5 5 11a5 5 0 0 1-10 0c0-2.4 1-4 2.2-5.2.4 2 1.4 3 2.4 3.6C11.8 9 11 6 12 2.5z" fill="currentColor" stroke="none"/>',
    moon: '<path d="M13 3a7.5 7.5 0 1 0 8 8 6 6 0 0 1-8-8z" fill="currentColor" stroke="none"/><path d="M5 4l.7 1.4L7 6l-1.3.6L5 8l-.7-1.4L3 6l1.3-.6z" fill="currentColor" stroke="none"/>',
    king: '<path d="M12 2v4M10 4h4"/><path d="M9 20h6l1.5-7.5a3.5 3.5 0 0 0-4.5-3.3A3.5 3.5 0 0 0 7.5 12.5z" fill="currentColor" stroke="none"/><path d="M7 21h10"/>',
    mate: '<circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="3" fill="currentColor" stroke="none"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3"/>',
    triple: '<circle cx="7" cy="17" r="3.4" fill="currentColor" stroke="none"/><circle cx="12" cy="12" r="3.4" fill="currentColor" stroke="none"/><circle cx="17" cy="7" r="3.4" fill="currentColor" stroke="none"/>',
    four: '<rect x="1.5" y="6" width="21" height="12" rx="3"/><circle cx="5.3" cy="12" r="2.2" fill="currentColor" stroke="none"/><circle cx="9.8" cy="12" r="2.2" fill="currentColor" stroke="none"/><circle cx="14.3" cy="12" r="2.2" fill="currentColor" stroke="none"/><circle cx="18.8" cy="12" r="2.2" fill="currentColor" stroke="none"/>',
    ultimate: '<rect x="3" y="3" width="18" height="18" rx="2.5"/><path d="M9 3v18M15 3v18M3 9h18M3 15h18"/><path d="M5 5l2 2M7 5l-2 2M17 17l2 2M19 17l-2 2"/><circle cx="12" cy="12" r="1.8" fill="currentColor" stroke="none"/>',
    noerr: '<path d="M4 20l3.5-.8L18 8.7a1.8 1.8 0 0 0-2.6-2.6L4.8 16.5z"/><path d="m14 7 3 3"/><path d="m13.5 19.5 2 2 4-4"/>',
    expert: '<path d="M2 9l10-4 10 4-10 4z" fill="currentColor" stroke="none"/><path d="M6 11v4.5c0 1.5 3 3 6 3s6-1.5 6-3V11M21 9v6"/>',
    first: '<circle cx="13" cy="11" r="7"/><circle cx="13" cy="11" r="2.5" fill="currentColor" stroke="none"/><path d="M3 21l10-10M3 21v-4M3 21h4"/>',
    cards: '<rect x="4" y="6" width="9" height="13" rx="1.8" transform="rotate(-12 8.5 12.5)"/><rect x="11" y="5" width="9" height="13" rx="1.8" transform="rotate(10 15.5 11.5)" fill="currentColor" stroke="none"/>',
    bulb: '<path d="M9 18h6M10 21h4"/><path d="M12 3a6 6 0 0 0-3.6 10.8c.6.5 1.1 1.3 1.1 2.2h5c0-.9.5-1.7 1.1-2.2A6 6 0 0 0 12 3z" fill="currentColor" stroke="none"/>',
    puzzle: '<rect x="3" y="3" width="18" height="18" rx="2.5"/><path d="M3 9h18M3 15h18M9 3v18M15 3v18"/><rect x="15.5" y="15.5" width="5" height="5" fill="currentColor" stroke="none"/>',
    night: '<path d="M16 3a5 5 0 1 0 5 5 4 4 0 0 1-5-5z" fill="currentColor" stroke="none"/><path d="M2 15c3-3 6-3 8 0 2-3 5-3 8 0M4 20c2-2 4-2 6 0"/>',
    wave: '<path d="M2 14c3-4 6-4 10 0s7 4 10 0"/><path d="M2 19c3-4 6-4 10 0s7 4 10 0"/><circle cx="12" cy="6" r="2.5" fill="currentColor" stroke="none"/>',
    run: '<circle cx="14" cy="4" r="2" fill="currentColor" stroke="none"/><path d="M9 21l2.5-6M13.5 21l-1.5-5-3-3 2.5-5 4 2.5 3 1"/><path d="M2 21h4M18 21h4"/>',
    chick: '<circle cx="12" cy="13" r="7"/><path d="M12 6V3M9 4l3-1 3 1"/><circle cx="9.5" cy="12" r="1.1" fill="currentColor" stroke="none"/><circle cx="14.5" cy="12" r="1.1" fill="currentColor" stroke="none"/><path d="M11 15.5h2l-1 1.6z" fill="currentColor" stroke="none"/>',
    shutout: '<circle cx="12" cy="11" r="7"/><path d="m7 6 10 10"/><path d="M4 22l4-5M20 22l-4-5"/>',
    combo: '<path d="M3 20 20 3"/><circle cx="7" cy="8" r="2.6" fill="currentColor" stroke="none"/><circle cx="16" cy="16" r="2.6" fill="currentColor" stroke="none"/><circle cx="14" cy="6" r="1.8" fill="currentColor" stroke="none"/><circle cx="8" cy="16.5" r="1.8" fill="currentColor" stroke="none"/>',
    stack: '<rect x="5" y="15" width="14" height="4.5" rx="1"/><rect x="5" y="9.75" width="14" height="4.5" rx="1"/><rect x="5" y="4.5" width="14" height="4.5" rx="1" fill="currentColor" stroke="none"/>',
  };
  const ACH = [
    { id: 'first', name: 'Primeira partida', desc: 'Joga uma partida em qualquer jogo.', icon: 'play', check: c => c.stats.played >= 1 },
    { id: 'ten', name: 'Aquecimento', desc: 'Joga 10 partidas.', icon: 'ten', check: c => c.stats.played >= 10 },
    { id: 'hundred', name: 'Centenário', desc: 'Joga 100 partidas.', icon: 'hundred', check: c => c.stats.played >= 100 },
    { id: 'hour', name: 'Uma hora bem passada', desc: 'Acumula uma hora de jogo.', icon: 'clock', check: c => c.stats.time >= 3600 },
    { id: 'marathon', name: 'Maratonista', desc: 'Acumula dez horas de jogo.', icon: 'marathon', check: c => c.stats.time >= 36000 },
    { id: 'snake100', name: 'Cobra crescida', desc: 'Faz 100 pontos no Snake.', icon: 'snake', game: 'snake', check: c => (c.bests.snake || 0) >= 100 },
    { id: 'snake500', name: 'Anaconda', desc: 'Faz 500 pontos no Snake.', icon: 'snake2', game: 'snake', check: c => (c.bests.snake || 0) >= 500 },
    { id: 'snakeLen', name: 'Píton', desc: 'Chega a um comprimento de 40 no Snake.', icon: 'python', game: 'snake', check: c => (c.stats.max.snakeLen || 0) >= 40 },
    { id: 'snakeGold', name: 'Fruto dourado', desc: 'Come um fruto dourado no Snake.', icon: 'gold', game: 'snake', check: c => !!c.stats.flags.snakeGold },
    { id: 'tile2048', name: '2048', desc: 'Chega à peça 2048.', icon: 'tiles', game: 'g2048', check: c => !!c.stats.flags.tile2048 },
    { id: 'tile4096', name: '4096', desc: 'Chega à peça 4096.', icon: 'tiles2', game: 'g2048', check: c => !!c.stats.flags.tile4096 },
    { id: 'lines40', name: 'Quarenta linhas', desc: 'Fecha 40 linhas numa partida de Blocos.', icon: 'lines', game: 'blocks', check: c => (c.stats.max.blocksLines || 0) >= 40 },
    { id: 'tetris', name: 'Quatro de uma vez', desc: 'Fecha quatro linhas com uma só peça.', icon: 'tetris', game: 'blocks', check: c => !!c.stats.flags.tetris },
    { id: 'tspin', name: 'Giro em T', desc: 'Faz um T-spin nos Blocos.', icon: 'tspin', game: 'blocks', check: c => !!c.stats.flags.tspin },
    { id: 'sprint40', name: 'Sprint', desc: 'Acaba as 40 linhas do modo Sprint.', icon: 'sprint', game: 'blocks', check: c => !!c.stats.flags.sprint40 },
    { id: 'minesEasy', name: 'Sapador', desc: 'Limpa o campo fácil das Minas.', icon: 'mine', game: 'mines', check: c => (c.bests['mines:facil'] || 0) > 0 },
    { id: 'minesHard', name: 'Nervos de aço', desc: 'Limpa o campo difícil das Minas.', icon: 'skull', game: 'mines', check: c => (c.bests['mines:dificil'] || 0) > 0 },
    { id: 'minesNoFlag', name: 'Sem rede de segurança', desc: 'Limpa um campo das Minas sem usar bandeiras.', icon: 'noflag', game: 'mines', check: c => !!c.stats.flags.minesNoFlag },
    { id: 'memory12', name: 'Memória de elefante', desc: 'Acaba a Memória de 8 pares em 12 jogadas ou menos.', icon: 'brain', game: 'memory', check: c => { const b = c.bests['memory:8']; return b > 0 && b <= 12; } },
    { id: 'memoryPerfect', name: 'Memória perfeita', desc: 'Acaba a Memória sem um único erro.', icon: 'perfect', game: 'memory', check: c => !!c.stats.flags.memoryPerfect },
    { id: 'break5', name: 'Demolidor', desc: 'Chega ao nível 5 do Break.', icon: 'ball', game: 'brick', check: c => (c.stats.max.breakLevel || 0) >= 5 },
    { id: 'breakClean', name: 'Sem uma mossa', desc: 'Passa três níveis do Break sem perder uma vida.', icon: 'shield', game: 'brick', check: c => !!c.stats.flags.breakClean },
    { id: 'breakMulti', name: 'Três bolas', desc: 'Tem três bolas em jogo ao mesmo tempo no Break.', icon: 'multi', game: 'brick', check: c => !!c.stats.flags.breakMulti },
    { id: 'chessWinHard', name: 'Grande mestre', desc: 'Vence o nível mais alto do Xadrez.', icon: 'king', game: 'chess', check: c => !!c.stats.flags.chessWinHard },
    { id: 'chessPuzzle', name: 'Mate em 1', desc: 'Resolve um puzzle do dia do Xadrez.', icon: 'mate', game: 'chess', check: c => !!c.stats.flags.chessPuzzle },
    { id: 'checkersTriple', name: 'Tripla', desc: 'Captura três peças numa só jogada das Damas.', icon: 'triple', game: 'checkers', check: c => !!c.stats.flags.checkersTriple },
    { id: 'c4WinHard', name: 'Quatro certeiros', desc: 'Vence o nível mais alto do Quatro em Linha.', icon: 'four', game: 'c4', check: c => !!c.stats.flags.c4WinHard },
    { id: 'tttUltimate', name: 'Ultimate', desc: 'Vence uma partida Ultimate do Jogo do Galo.', icon: 'ultimate', game: 'ttt', check: c => !!c.stats.flags.tttUltimate },
    { id: 'sudokuNoErr', name: 'Sem erros', desc: 'Acaba um Sudoku sem erros.', icon: 'noerr', game: 'sudoku', check: c => !!c.stats.flags.sudokuNoErr },
    { id: 'sudokuExpert', name: 'Perito', desc: 'Acaba um Sudoku de nível Perito.', icon: 'expert', game: 'sudoku', check: c => !!c.stats.flags.sudokuExpert },
    { id: 'wordsFirstTry', name: 'À primeira', desc: 'Acerta a palavra à primeira tentativa.', icon: 'first', game: 'words', check: c => !!c.stats.flags.wordsFirstTry },
    { id: 'solitaireWin', name: 'Mesa limpa', desc: 'Ganha uma partida de Solitário.', icon: 'cards', game: 'solitaire', check: c => !!c.stats.flags.solitaireWin },
    { id: 'lightsPerfect', name: 'Luzes ao mínimo', desc: 'Resolve cinco níveis das Luzes Apagadas com o mínimo de toques.', icon: 'bulb', game: 'lights', check: c => !!c.stats.flags.lightsPerfect },
    { id: 'sliding5', name: 'Grande puzzle', desc: 'Resolve um Deslizante 5×5.', icon: 'puzzle', game: 'sliding', check: c => !!c.stats.flags.sliding5 },
    { id: 'glideNight', name: 'Voo noturno', desc: 'Faz 20 pontos no modo Noite do Planar.', icon: 'night', game: 'glide', check: c => !!c.stats.flags.glideNight },
    { id: 'rocksWave', name: 'Vaga 10', desc: 'Chega à vaga 10 das Rochas.', icon: 'wave', game: 'rocks', check: c => (c.stats.max.rocksWave || 0) >= 10 },
    { id: 'runnerDist', name: 'Maratona urbana', desc: 'Corre 2000 m numa corrida do Corredor.', icon: 'run', game: 'runner', check: c => (c.stats.max.runnerDist || 0) >= 2000 },
    { id: 'hopChar', name: 'Nova personagem', desc: 'Desbloqueia uma personagem no Salto.', icon: 'chick', game: 'hop', check: c => !!c.stats.flags.hopChar },
    { id: 'duelShutout', name: 'Sete a zero', desc: 'Ganha 7 a 0 contra o telemóvel no Pong ou no Hóquei de mesa.', icon: 'shutout', game: ['pong', 'airhockey'], check: c => !!c.stats.flags.duelShutout },
    { id: 'sliceCombo', name: 'Combo x6', desc: 'Corta seis frutos num só traço.', icon: 'combo', game: 'slice', check: c => (c.stats.max.sliceCombo || 0) >= 6 },
    { id: 'stackPerfect', name: 'Dez perfeitos', desc: 'Encaixa dez blocos perfeitos seguidos na Torre.', icon: 'stack', game: 'stack', check: c => (c.stats.max.stackPerfect || 0) >= 10 },
    { id: 'eight', name: 'Curioso', desc: 'Joga oito jogos diferentes.', icon: 'grid', check: c => Object.keys(c.stats.games || {}).length >= 8 },
    { id: 'board', name: 'Na tabela', desc: 'Entra numa classificação do servidor.', icon: 'list', check: c => (c.me.boards || 0) >= 1 },
    { id: 'top10', name: 'Top 10', desc: 'Fica entre os dez primeiros de uma tabela.', icon: 'medal', check: c => (c.me.top10 || 0) >= 1 },
    { id: 'top1', name: 'Campeão', desc: 'Fica em primeiro lugar numa tabela.', icon: 'crown', check: c => (c.me.top1 || 0) >= 1 },
    { id: 'top10x3', name: 'Polivalente', desc: 'Fica no top 10 de três tabelas.', icon: 'stars', check: c => (c.me.top10 || 0) >= 3 },
    { id: 'duel', name: 'Primeiro duelo', desc: 'Joga uma partida online contra outro jogador.', icon: 'swords', check: c => c.stats.mpPlayed >= 1 },
    { id: 'mpWin', name: 'Vitória online', desc: 'Ganha uma partida online.', icon: 'trophy', check: c => c.stats.mpWins >= 1 },
    { id: 'mpWin5', name: 'Imparável', desc: 'Ganha cinco partidas online.', icon: 'flame', check: c => c.stats.mpWins >= 5 },
    { id: 'night', name: 'Noctívago', desc: 'Joga uma partida entre a meia-noite e as cinco da manhã.', icon: 'moon', check: c => !!c.stats.flags.night },
  ];
  const achIcon = (id, size) => `<svg viewBox="0 0 24 24" width="${size || 26}" height="${size || 26}" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">${AI[id] || AI.play}</svg>`;
  function achievements(me) {
    const c = { stats: stats(), bests: Object.assign({}, allBest(), (me && me.bests) || {}), me: me || {} };
    if (me && me.stats) { const s = me.stats; c.stats = Object.assign({}, c.stats, { played: Math.max(c.stats.played, +s.played || 0), time: Math.max(c.stats.time, +s.time || 0), wins: Math.max(c.stats.wins, +s.wins || 0), mpPlayed: Math.max(c.stats.mpPlayed, +s.mpPlayed || 0), mpWins: Math.max(c.stats.mpWins, +s.mpWins || 0), mpLosses: Math.max(c.stats.mpLosses, +s.mpLosses || 0) }); }
    return ACH.map(a => { let done = false; try { done = !!a.check(c); } catch (e) {} return { id: a.id, name: a.name, desc: a.desc, icon: achIcon(a.icon), done, game: a.game || null }; });
  }

  /* ---------- nível e XP (calculados localmente das estatísticas; o servidor só acrescenta o que tiver mais) ----------
     XP = 10 por partida + 2 por minuto + 20 por vitória + 50 por vitória online + 30 por recorde + 60 por conquista.
     Nível L precisa de 60·L·(L-1) XP (120, 360, 720, 1200...). */
  const lvlTitle = l => (l >= 15 ? 'Lenda' : l >= 10 ? 'Mestre' : l >= 6 ? 'Veterano' : l >= 3 ? 'Jogador' : 'Novato');
  function xp(me) {
    const s = stats(), srv = (me && me.stats) || {};
    const played = Math.max(s.played, +srv.played || 0), time = Math.max(s.time, +srv.time || 0), wins = Math.max(s.wins, +srv.wins || 0), mpW = Math.max(s.mpWins, +srv.mpWins || 0);
    const records = Object.keys(Object.assign({}, allBest(), (me && me.bests) || {})).length;
    const ach = achievements(me).filter(a => a.done).length;
    const total = Math.round(played * 10 + Math.min(time, 36000) / 60 * 2 + wins * 20 + mpW * 50 + records * 30 + ach * 60);
    const level = Math.max(1, Math.floor((1 + Math.sqrt(1 + total / 15)) / 2));
    const base = 60 * level * (level - 1), next = 60 * (level + 1) * level;
    return { xp: total, level, into: total - base, need: next - base, next, title: lvlTitle(level), played, time, wins, mpWins: mpW, records, ach };
  }
  const fmtTime = t => (t >= 3600 ? Math.floor(t / 3600) + ' h ' + Math.round((t % 3600) / 60) + ' min' : Math.round(t / 60) + ' min');

  /* ---------- pódio dos 3 primeiros (resultado e classificações): 2.º, 1.º, 3.º com avatar, nome e pontuação ---------- */
  function podium(top, fmtFn) {
    const pod = UI.el('<div class="gm-podium"></div>');
    [1, 0, 2].forEach(i => {
      const e = top[i];
      const col = UI.el(`<div class="pc p${i + 1} ${e ? '' : 'none'} ${e && e.me ? 'me' : ''}"><div class="av">${e ? UI.avatar({ name: e.name || '?' }, 'sm') : ''}</div><b class="nm" data-noi18n>${e ? UI.esc(e.name || '?') : ''}</b><span class="sc" data-noi18n>${e ? UI.esc(String(fmtFn ? fmtFn(e) : e.score)) : ''}</span><div class="ped"><i>${i + 1}</i></div></div>`);
      pod.appendChild(col);
    });
    return pod;
  }

  /* ---------- folha "Definições" do Arcade (hub e menu de pausa) ---------- */
  let cfgSheet = null;
  function openSettings() {
    if (cfgSheet) return cfgSheet;
    const s = settings();
    const body = UI.el(`<div class="gm-cfg">
      <div class="group-header">Som</div>
      <div class="group"><div class="gm-vol"><div class="vh">${g('speaker', 20)}<b>Volume dos jogos</b><span class="vv" data-noi18n>${s.volume}%</span></div><div class="vt"><div class="vf"></div><div class="vk"></div></div></div></div>
      <div class="group-footer">Multiplica o volume do sistema. Os toques da interface não mudam.</div></div>`);
    const lst = UI.list([{ header: 'Jogo', items: [
      { icon: 'activity', iconBg: '#FF9F0A', label: 'Vibração', sub: 'Abanões e toque nos impactos', toggle: s.haptic, onToggle: v => setSetting('haptic', !!v) },
      { icon: 'hand', iconBg: '#30D158', label: 'Controlos para canhotos', sub: 'Troca os comandos de lado', toggle: s.lefty, onToggle: v => setSetting('lefty', !!v) },
      { icon: 'sparkles', iconBg: '#BF5AF2', label: 'Reduzir efeitos', sub: 'Sem confetti nem abanões', toggle: s.reduceFx, onToggle: v => setSetting('reduceFx', !!v) },
    ], footer: 'As definições ficam guardadas nesta personagem e valem para todos os jogos.' }]);
    body.appendChild(lst);
    /* cursor do volume: por ponteiro, com UI.vrect (nunca getBoundingClientRect cru por causa do zoom) */
    const vt = body.querySelector('.vt'), vf = body.querySelector('.vf'), vk = body.querySelector('.vk'), vv = body.querySelector('.vv');
    let cur = s.volume, drag = false;
    const paint = () => { const k = cur / 100, w = vt.offsetWidth || 200; vf.style.transform = 'scaleX(' + k.toFixed(3) + ')'; vk.style.transform = 'translateX(' + Math.round(k * (w - 28)) + 'px)'; vv.textContent = cur + '%'; };
    const at = e => { const r = UI.vrect(vt); const k = Math.max(0, Math.min(1, (e.clientX - r.left) / Math.max(1, r.width))); cur = Math.round(k * 20) * 5; paint(); };
    vt.addEventListener('pointerdown', e => { drag = true; try { vt.setPointerCapture(e.pointerId); } catch (x) {} at(e); });
    vt.addEventListener('pointermove', e => { if (drag) at(e); });
    const up = () => { if (!drag) return; drag = false; setSetting('volume', cur); sfx('coin'); };
    vt.addEventListener('pointerup', up); vt.addEventListener('pointercancel', up);
    cfgSheet = UI.sheet({ title: 'Definições do Arcade', left: '', right: 'Concluído', body, cls: 'gm-cfg-sheet', onClose: () => { cfgSheet = null; applySettings(); } });
    setTimeout(paint, 30);
    return cfgSheet;
  }

  return {
    best, setBest, bestLow, setBestLow, clearBest, allBest, opt, setOpt, stats, addStat, flag, maxStat,
    loop, dirs, shell, game, btn, sprite, particles, sfx, fmt, fmtScore, keyDir, list, def, achievements, achIcon, ACH,
    match, matchUI, openGame, openBoard, takeIntent, showInvite, hideInvite,
    /* ronda 2 */
    settings, setSetting, openSettings, applySettings, cover, coverHTML, daily, xp, lvlTitle, podium, fmtTime, isLight,
    get pendingMatch() { return pendingMatch; }, set pendingMatch(v) { pendingMatch = v; },
  };
})();

/* =====================================================================
   MOCK do servidor (browser e harness): tabelas em memória, jogadores fictícios, convites e partidas com um
   adversário automático (joga ao acaso no 4 em linha e no jogo do galo; nos outros deixa passar a vez).
   LocalDB.arcade.invite({ game, from }) simula um convite recebido; LocalDB.arcade.endMatch(id, winner) acaba uma partida.
   ===================================================================== */
if (window.LocalDB) (() => {
  /* tabelas em que ganha o MENOR valor (segundos, jogadas, toques); a Memória contra o relógio conta pares e o Sprint dos Blocos conta segundos */
  const LOW = /^(mines|memory:(?!clock)|solitaire|sliding|lights|sudoku|blocks:sprint)/;
  const NAMES = ['Ana Martins', 'Rui Tavares', 'Marta Silva', 'Tiago Costa', 'Inês Rocha', 'Pedro Alves', 'Sofia Nunes', 'Bruno Lopes', 'Carla Mendes', 'Hugo Pinto', 'Joana Faria', 'Nuno Reis', 'Rita Gomes', 'Vasco Dias', 'Lara Sousa', 'Diogo Melo', 'Beatriz Cruz', 'Miguel Ramos'];
  const DB = { scores: {}, stats: {}, matches: {}, invites: {}, seq: 0 };
  const me = () => LocalDB.me();
  const myName = () => { const p = LocalDB.player(); return ((p.firstname || '') + ' ' + (p.lastname || '')).trim() || 'Jogador'; };
  const low = b => LOW.test(b);
  const board = b => {
    if (DB.scores[b]) return DB.scores[b];
    /* 14 a 30 entradas determinísticas por tabela */
    let h = 7; for (const ch of b) h = (h * 31 + ch.charCodeAt(0)) % 100003;
    const n = 14 + (h % 17), rows = [];
    for (let i = 0; i < n; i++) { const k = (h + i * 7919) % 100003; const sc = low(b) ? 15 + (k % 240) : 40 + (k % 3200) * (b === 'g2048' || b === 'blocks' ? 7 : 1); rows.push({ owner: 'npc' + i, name: NAMES[(h + i) % NAMES.length], score: sc, updated: Date.now() - (k % 20) * 864e5, number: '555-0' + String(100 + ((h + i * 3) % 900)) }); }
    DB.scores[b] = rows; return rows;
  };
  const sorted = (b, rows) => rows.slice().sort((x, y) => (low(b) ? x.score - y.score : y.score - x.score) || x.updated - y.updated);
  const pub = (b, rows, cid) => sorted(b, rows).slice(0, 100).map((r, i) => ({ rank: i + 1, name: r.name, score: r.score, me: r.owner === cid, updated: r.updated }));
  const rankOf = (b, rows, cid) => { const i = sorted(b, rows).findIndex(r => r.owner === cid); return i < 0 ? null : i + 1; };
  const st = cid => (DB.stats[cid] = DB.stats[cid] || { played: 0, time: 0, wins: 0, mpPlayed: 0, mpWins: 0, mpLosses: 0 });
  const lastSub = {};
  LocalDB.register('arcade.submit', d => {
    const cid = me().citizenid, b = String(d.board || d.game || ''); if (!b) return { error: 'game' };
    const sc = Math.round(+d.score || 0); if (!(sc >= 1)) return { error: 'score' };
    const k = cid + '|' + b; if (lastSub[k] && Date.now() - lastSub[k] < 3000) return { error: 'rate' }; lastSub[k] = Date.now();
    const rows = board(b); let mine = rows.find(r => r.owner === cid);
    const better = !mine || (low(b) ? sc < mine.score : sc > mine.score);
    if (!mine) { mine = { owner: cid, name: myName(), score: sc, updated: Date.now() }; rows.push(mine); }
    else if (better) { mine.score = sc; mine.updated = Date.now(); }
    const s = st(cid); s.played++; s.time += Math.max(0, Math.min(7200, +(d.meta && d.meta.time) || 0)); if (d.meta && d.meta.win) s.wins++;
    return { best: mine.score, rank: rankOf(b, rows, cid), improved: better, top: pub(b, rows, cid).slice(0, 3), count: rows.length };
  });
  LocalDB.register('arcade.board', d => {
    const cid = me().citizenid, b = String(d.board || ''); if (!b) return { error: 'game' };
    let rows = board(b);
    if (d.scope === 'week') rows = rows.filter(r => Date.now() - r.updated < 7 * 864e5);
    else if (d.scope === 'friends') { const nums = new Set(LocalDB.T('contacts').all().map(c => c.number)); rows = rows.filter(r => r.owner === cid || nums.has(r.number)); }
    const top = pub(b, rows, cid), rk = rankOf(b, rows, cid), mine = rows.find(r => r.owner === cid);
    return { top, me: mine ? { rank: rk, score: mine.score } : null, count: rows.length };
  });
  LocalDB.register('arcade.me', () => {
    const cid = me().citizenid, bests = {}, ranks = {}; let top1 = 0, top10 = 0, n = 0;
    Object.keys(DB.scores).forEach(b => { const mine = DB.scores[b].find(r => r.owner === cid); if (!mine) return; bests[b] = mine.score; const rk = rankOf(b, DB.scores[b], cid); ranks[b] = rk; n++; if (rk === 1) top1++; if (rk <= 10) top10++; });
    return { bests, ranks, boards: n, top1, top10, stats: Object.assign({}, st(cid)) };
  });
  LocalDB.register('arcade.friends', () => {
    const list = LocalDB.T('contacts').all().map(c => { const bests = {}; Object.keys(DB.scores).forEach(b => { const r = DB.scores[b].find(x => x.number === c.number); if (r) bests[b] = r.score; }); return { name: c.name, number: c.number, bests }; }).filter(f => Object.keys(f.bests).length);
    return { friends: list };
  });
  /* ---- partidas ---- */
  const MP = { c4: 'server', ttt: 'server', chess: 'client', checkers: 'client' };
  const zeros = n => { const a = []; for (let i = 0; i < n; i++) a.push(0); return a; };
  const initState = game => game === 'c4' ? { board: zeros(42) } : game === 'ttt' ? { board: zeros(9) } : {};
  const payload = (m, who) => ({ id: m.id, game: m.game, you: who, turn: m.turn, players: { a: m.players.a.name, b: m.players.b.name }, opponent: { name: m.players[who === 'a' ? 'b' : 'a'].name }, state: m.state, moves: m.moves, left: m.ended ? 0 : Math.max(0, m.deadline - Date.now()), ended: !!m.ended, winner: m.winner || null, reason: m.reason || null, last: m.last == null ? null : m.last });
  const pushMe = m => setTimeout(() => Bridge.emit('arcade:match', payload(m, m.me)), 0);
  const winC4 = (b, idx, p) => { const r = (idx / 7) | 0, c = idx % 7; for (const [dr, dc] of [[0, 1], [1, 0], [1, 1], [1, -1]]) { let n = 1; for (const s of [1, -1]) for (let k = 1; k < 4; k++) { const rr = r + dr * k * s, cc = c + dc * k * s; if (rr < 0 || rr > 5 || cc < 0 || cc > 6 || b[rr * 7 + cc] !== p) break; n++; } if (n >= 4) return true; } return false; };
  const winTTT = (b, p) => [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]].some(l => l.every(i => b[i] === p));
  const finish = (m, winner, reason) => { if (m.ended) return; m.ended = true; m.winner = winner; m.reason = reason; clearTimeout(m.botT); const s = st(me().citizenid); s.mpPlayed++; if (winner === m.me) s.mpWins++; else if (winner && winner !== 'draw') s.mpLosses++; if (winner === m.me && MP[m.game]) { const rows = board(m.game); let mine = rows.find(r => r.owner === me().citizenid); if (!mine) rows.push({ owner: me().citizenid, name: myName(), score: 1, updated: Date.now() }); else { mine.score++; mine.updated = Date.now(); } } pushMe(m); setTimeout(() => { delete DB.matches[m.id]; }, 2000); };
  const applyMove = (m, who, mv) => {
    const p = who === 'a' ? 1 : 2, b = m.state.board;
    if (m.game === 'c4') { const col = +mv.col; if (!(col >= 0 && col <= 6)) return 'move'; let idx = -1; for (let r = 5; r >= 0; r--) if (b[r * 7 + col] === 0) { idx = r * 7 + col; break; } if (idx < 0) return 'full'; b[idx] = p; m.last = idx; if (winC4(b, idx, p)) return 'win'; if (b.every(x => x)) return 'draw'; return null; }
    if (m.game === 'ttt') { const cell = +mv.cell; if (!(cell >= 0 && cell <= 8) || b[cell]) return 'move'; b[cell] = p; m.last = cell; if (winTTT(b, p)) return 'win'; if (b.every(x => x)) return 'draw'; return null; }
    return null;
  };
  const after = (m, who, res) => { m.moves++; if (res === 'win') { finish(m, who, 'win'); return; } if (res === 'draw') { finish(m, 'draw', 'draw'); return; } m.turn = who === 'a' ? 'b' : 'a'; m.deadline = Date.now() + 45000; pushMe(m); if (m.turn !== m.me) botMove(m); };
  const botMove = m => { clearTimeout(m.botT); m.botT = setTimeout(() => { if (m.ended || m.turn === m.me) return; const who = m.turn, b = m.state.board; let res = null;
    if (m.game === 'c4') { const cols = []; for (let c = 0; c < 7; c++) if (b[c] === 0) cols.push(c); if (!cols.length) { finish(m, 'draw', 'draw'); return; } res = applyMove(m, who, { col: cols[(Math.random() * cols.length) | 0] }); }
    else if (m.game === 'ttt') { const free = []; b.forEach((x, i) => { if (!x) free.push(i); }); if (!free.length) { finish(m, 'draw', 'draw'); return; } res = applyMove(m, who, { cell: free[(Math.random() * free.length) | 0] }); }
    else { /* xadrez/damas: o adversário fictício não sabe jogar; o tempo acaba e a vitória é tua */ m.botT = setTimeout(() => { if (!m.ended && m.turn !== m.me) finish(m, m.me, 'timeout'); }, 45000); return; }
    after(m, who, res); }, 1200); };
  const newMatch = (game, mine, otherName) => { const id = 'm' + (++DB.seq); const m = { id, game, players: { a: { name: mine === 'a' ? myName() : otherName }, b: { name: mine === 'b' ? myName() : otherName } }, me: mine, turn: Math.random() < .5 ? 'a' : 'b', state: initState(game), moves: 0, deadline: Date.now() + 45000, started: Date.now(), ended: false }; DB.matches[id] = m; return m; };
  const activeFor = game => Object.values(DB.matches).find(m => m.game === game && !m.ended);
  LocalDB.register('arcade.match.invite', d => {
    const game = String(d.game || ''); if (!MP[game]) return { error: 'game' };
    if (activeFor(game)) return { error: 'busy' };
    const c = LocalDB.T('contacts').all().find(x => x.number === d.number);
    const to = (c && c.name) || (d.number ? String(d.number) : d.src ? ('Jogador ' + d.src) : 'Ana Martins');
    const id = 'i' + (++DB.seq); DB.invites[id] = { id, game, to, at: Date.now() };
    /* o outro lado aceita passado 1,5 s (no servidor real: push arcade:match quando aceitar) */
    setTimeout(() => { if (!DB.invites[id]) return; delete DB.invites[id]; if (activeFor(game)) return; const m = newMatch(game, 'a', to); pushMe(m); if (m.turn !== 'a') botMove(m); }, 1500);
    return { id, game, to, seconds: 60 };
  });
  LocalDB.register('arcade.match.accept', d => {
    const ex = DB.matches[String(d.id)]; if (ex) { pushMe(ex); return payload(ex, ex.me); }   /* partida já aceite: devolve e volta a empurrar (como o servidor) */
    const inv = DB.invites[String(d.id)]; if (!inv || !inv.incoming) return { error: 'gone' }; delete DB.invites[inv.id]; if (activeFor(inv.game)) return { error: 'busy' }; const m = newMatch(inv.game, 'b', inv.from); if (m.turn !== 'b') botMove(m); pushMe(m); return payload(m, 'b'); });
  LocalDB.register('arcade.match.decline', d => { delete DB.invites[String(d.id)]; return { ok: true }; });
  LocalDB.register('arcade.match.move', d => {
    const m = DB.matches[String(d.id)]; if (!m || m.ended) return { error: 'gone' }; if (m.turn !== m.me) return { error: 'turn' };
    let res = null;
    if (MP[m.game] === 'server') { res = applyMove(m, m.me, d.move || {}); if (res === 'move' || res === 'full') return { error: res }; }
    else {
      if (d.state !== undefined) { const s = typeof d.state === 'string' ? d.state : JSON.stringify(d.state); if (s.length > 16000) return { error: 'toolarge' }; m.state = d.state; }
      m.last = d.move == null ? null : d.move;
      if (d.result === 'win') res = 'win'; else if (d.result === 'draw') res = 'draw';
      else { let st = m.state; if (typeof st === 'string') { try { st = JSON.parse(st); } catch (e) { st = null; } } if (st && st.end && typeof st.end === 'object') { const w = st.end.winner; res = (w === 1 || w === 'a') ? (m.me === 'a' ? 'win' : 'lose') : (w === 2 || w === 'b') ? (m.me === 'b' ? 'win' : 'lose') : 'draw'; } }
    }
    if (res === 'lose') { m.moves++; finish(m, m.me === 'a' ? 'b' : 'a', 'win'); return payload(m, m.me); }
    after(m, m.me, res); return payload(m, m.me);
  });
  LocalDB.register('arcade.match.state', d => {
    if (d && d.id) { const m = DB.matches[String(d.id)]; return m ? payload(m, m.me) : { error: 'gone' }; }
    if (d && d.game) { const m = activeFor(String(d.game)); return m ? payload(m, m.me) : { none: true }; }
    return { matches: Object.values(DB.matches).filter(m => !m.ended).map(m => payload(m, m.me)) };
  });
  LocalDB.register('arcade.match.leave', d => { const m = DB.matches[String(d.id)]; if (m && !m.ended) finish(m, m.me === 'a' ? 'b' : 'a', 'left'); return { ok: true }; });
  LocalDB.register('arcade.match.nearby', () => ({ list: [{ src: 2, name: 'Ana Martins', number: '555-0801', dist: 4 }, { src: 3, name: 'Rui Tavares', number: '555-0802', dist: 12 }, { src: 5, name: 'Marta Silva', number: '555-0803', dist: 27 }] }));
  LocalDB.arcade = {
    invite(o) { o = o || {}; const id = 'i' + (++DB.seq); const game = o.game || 'c4'; DB.invites[id] = { id, game, from: o.from || 'Ana Martins', incoming: true, at: Date.now() }; setTimeout(() => Bridge.emit('arcade:invite', { id, game, from: o.from || 'Ana Martins', seconds: o.seconds || 60 }), 0); return id; },
    endMatch(id, winner) { const m = DB.matches[String(id)]; if (m) finish(m, winner || m.me, 'win'); return !!m; },
    matches: () => Object.values(DB.matches),
    reset() { DB.scores = {}; DB.stats = {}; DB.matches = {}; DB.invites = {}; },
  };
})();


/* =====================================================================
   HUB "Arcade": Jogos (destaque, filtros, grelha), Classificações (top 100 do servidor, por jogo e variante,
   sempre / semana / amigos) e Perfil (estatísticas, partidas em curso, desafios, conquistas).
   Construído UMA vez por separador; tudo o que muda é atualizado in place.
   ===================================================================== */
Icons.app.arcade = () => Icons.SVG(Icons.G('gAr', '#FF9F6C', '#FF375F', '#C41E4A') + Icons.GL(
  `<rect x="16" y="34" width="68" height="40" rx="12" fill="#fff"/><circle cx="34" cy="54" r="4.5" fill="#FF375F"/>` +
  `<path d="M30 54h8M34 50v8" stroke="#FF375F" stroke-width="4" stroke-linecap="round"/>` +
  `<circle cx="64" cy="50" r="5" fill="#FF375F"/><circle cx="72" cy="60" r="5" fill="#FF375F"/>`));

App.define('arcade', {
  /* `hub: true`: esta app é a ESTANTE, não um jogo (quem conta jogos pela categoria exclui-a) */
  name: 'Arcade', category: 'Jogos', statusBar: 'dark', hub: true,
  description: 'Todos os jogos num sítio só: destaque, desafio do dia, classificações do servidor, perfil com nível e conquistas, e desafios aos teus contactos.',
  open(win) {
    const g = UI.g;
    const KIND = { action: 'Ação', puzzle: 'Puzzle', board: 'Tabuleiro' };
    /* filas do separador Jogos: Continuar (jogados há pouco) e uma por tipo, mais "A dois" */
    const ROWS = [{ k: 'recent', label: 'Continuar', sub: 'Jogados há pouco' }, { k: 'action', label: 'Ação', sub: 'Reflexos e pontuação' }, { k: 'puzzle', label: 'Puzzle', sub: 'Com calma e cabeça' }, { k: 'board', label: 'Tabuleiro', sub: 'Contra o telemóvel ou online' }, { k: 'mp', label: 'A dois', sub: 'Desafia um contacto' }];
    const ERR = { busy: 'Esse jogador já tem uma partida desse jogo', offline: 'Esse jogador não está ligado', far: 'Esse jogador está demasiado longe', self: 'Não te podes desafiar a ti próprio', game: 'Esse jogo não tem modo a dois', nophone: 'Esse jogador não tem telemóvel', pending: 'Já há um convite à espera de resposta', rate: 'Espera um momento antes de convidar outra vez' };
    const fmtS = (d, n, b) => Arcade.fmtScore(n, b && d.unitOf ? d.unitOf(b) : d.unit);
    /* o melhor recorde LOCAL de um jogo (o menor nas variantes dos jogos "quanto menos melhor") */
    const recOf = d => d.boards().filter(b => !d.lowerOf || d.lowerOf(b) === d.lower).reduce((r, b) => { const v = d.lower ? Arcade.bestLow(b) : Arcade.best(b); if (!v) return r; return !r ? v : (d.lower ? Math.min(r, v) : Math.max(r, v)); }, 0);
    const myName = () => { try { const p = System.player || {}; const n = ((p.firstname || '') + ' ' + (p.lastname || '')).trim(); return n || (System.account && System.account.username) || 'Jogador'; } catch (e) { return 'Jogador'; } };
    const dayIndex = () => Math.floor(Date.now() / 864e5);
    const gameOf = id => Arcade.def(id);
    const achOf = (id, me) => Arcade.achievements(me).filter(a => a.game === id || (Array.isArray(a.game) && a.game.indexOf(id) >= 0));
    /* frases que se juntam (descrição + "Ainda por conquistar.") traduzem-se antes de se juntar */
    const Tr = s => (window.L && L.t ? L.t(s) : s);
    let meData = null;

    /* ================= separador JOGOS ================= */
    let vGames = null; const cards = {};
    function featuredPick() {
      const games = Arcade.list(); if (!games.length) return null;
      const last = Arcade.stats().last, d = last && games.find(x => x.id === last);
      if (d) return { d, why: 'Último jogado' };
      const dl = Arcade.daily(), pool = games.filter(x => !dl || x.id !== dl.id);
      const pick = pool.length ? pool[(dayIndex() * 7) % pool.length] : games[0];
      return { d: pick, why: 'Em destaque' };
    }
    function cardFor(d, big) {
      const c = UI.el(`<div class="hub-cv ${big ? 'big' : ''}" style="--c:${d.color}">${Arcade.coverHTML(d)}${d.mp ? `<i class="hc-mp">${g('users', 12)}</i>` : ''}<div class="hc-bd"><b class="hc-name">${UI.esc(d.name)}</b><span class="hc-sub"></span></div></div>`);
      c.onclick = () => { Sound.play('click'); openGamePage(d); };
      return c;
    }
    const subOf = d => { const rec = recOf(d); return rec ? { t: fmtS(d, rec), rec: true } : { t: KIND[d.kind] || KIND.action, rec: false }; };
    /* garante um cartão por jogo em cada fila (chave fila|id), pela ordem pedida; os que não entram ficam escondidos */
    function placeRow(row, ids) {
      const sc = row.querySelector('.hub-scroll'), k = row.dataset.row;
      ids.forEach(id => { const key = k + '|' + id; const d = gameOf(id); if (!d) return; if (!cards[key]) cards[key] = cardFor(d, false); const c = cards[key]; if (c.parentNode !== sc || c !== sc.lastElementChild) sc.appendChild(c); c.classList.remove('hidden'); const s = subOf(d); c.querySelector('.hc-sub').textContent = s.t; c.classList.toggle('has-rec', s.rec); });
      [...sc.children].forEach(c => { if (!ids.some(id => cards[k + '|' + id] === c)) c.classList.add('hidden'); });
      row.querySelector('.hub-sec span').textContent = ids.length ? String(ids.length) : '';
      row.classList.toggle('hidden', !ids.length);
    }
    function refreshGames() {
      if (!vGames) return;
      const root = vGames.content.querySelector('.hub'), games = Arcade.list(), st = Arcade.stats();
      /* destaque */
      const f = featuredPick(), hero = root.querySelector('.hub-hero');
      hero.classList.toggle('hidden', !f);
      if (f) {
        hero.style.setProperty('--c', f.d.color);
        if (hero.dataset.id !== f.d.id) { hero.dataset.id = f.d.id; hero.querySelector('.hh-cov').innerHTML = Arcade.coverHTML(f.d); hero.querySelector('.hh-tags').innerHTML = (f.d.tags || []).concat(KIND[f.d.kind] ? [KIND[f.d.kind]] : []).slice(0, 3).map(t => `<i>${UI.esc(t)}</i>`).join(''); }
        hero.querySelector('.eyebrow').textContent = f.why;
        hero.querySelector('.hh-name').textContent = f.d.name;
        const rec = recOf(f.d);
        hero.querySelector('.hh-rec').textContent = rec ? fmtS(f.d, rec) : '';
        hero.querySelector('.hh-recrow').classList.toggle('hidden', !rec);
        hero.querySelector('.hh-play').onclick = e => { e.stopPropagation(); Sound.play('click'); System.openApp(f.d.id); };
        hero.onclick = () => { Sound.play('click'); openGamePage(f.d); };
      }
      /* desafio do dia */
      const dl = Arcade.daily(), dd = dl && gameOf(dl.id), daily = root.querySelector('.hub-daily');
      daily.classList.toggle('hidden', !dd);
      if (dd) {
        daily.style.setProperty('--c', dd.color); daily.classList.toggle('lt', Arcade.isLight(dd.color));
        if (daily.dataset.id !== dd.id) { daily.dataset.id = dd.id; daily.querySelector('.hd-cov').innerHTML = Arcade.coverHTML(dd); }
        daily.querySelector('.hd-name').textContent = dd.name;
        const done = st.daily && st.daily.day === dl.day && st.daily.id === dd.id ? st.daily : null;
        daily.classList.toggle('done', !!done);
        daily.querySelector('.hd-st').textContent = done ? (done.score > 0 ? 'Feito: ' + fmtS(dd, done.score) : 'Feito') : 'Por jogar';
        daily.querySelector('.hd-go').onclick = e => { e.stopPropagation(); Sound.play('click'); System.openApp(dd.id); };
        daily.onclick = () => { Sound.play('click'); openGamePage(dd); };
      }
      /* filas */
      const recent = Object.keys(st.games || {}).filter(id => gameOf(id)).sort((a, b) => ((st.games[b].last || 0) - (st.games[a].last || 0))).slice(0, 8);
      root.querySelectorAll('.hub-row').forEach(row => {
        const k = row.dataset.row;
        const ids = k === 'recent' ? recent : games.filter(d => k === 'mp' ? d.mp : d.kind === k).map(d => d.id);
        placeRow(row, ids);
      });
      root.querySelector('.hub-empty').classList.toggle('hidden', games.length > 0);
      root.querySelector('.hub-count').textContent = games.length ? games.length + ' jogos' : '';
    }
    function tabGames() {
      if (vGames) { refreshGames(); return vGames; }
      vGames = UI.view({ title: 'Arcade', large: true, cls: 'gm gm-hub', right: [{ icon: 'gear', label: 'Definições', onTap: () => { Sound.play('click'); Arcade.openSettings(); } }] });
      const root = UI.el(`<div class="hub">
        <div class="hub-hero"><div class="hh-cov"></div><div class="hh-scrim"></div>
          <div class="hh-txt"><span class="eyebrow"></span><b class="hh-name"></b><div class="hh-tags"></div><span class="hh-recrow">${g('starFill', 12)}<span>Recorde</span> <b class="hh-rec" data-noi18n></b></span></div>
          <div class="btn-p hh-play">${g('play', 16)}<span>Jogar</span></div></div>
        <div class="hub-daily"><div class="hd-cov"></div><div class="hd-bd"><span class="eyebrow">Desafio do dia</span><b class="hd-name"></b><span class="hd-st"></span></div><div class="hd-go">${g('play', 18)}</div></div>
        <div class="hub-rows"></div>
        <div class="hub-count"></div>
        <div class="hub-empty hidden"></div></div>`);
      root.querySelector('.hub-empty').appendChild(UI.empty('gamepad', 'Nada por aqui', 'Ainda não há jogos instalados'));
      const rows = root.querySelector('.hub-rows');
      ROWS.forEach(r => {
        const row = UI.el(`<div class="hub-row hidden" data-row="${r.k}"><div class="hub-sec"><div><b>${UI.esc(r.label)}</b><small>${UI.esc(r.sub)}</small></div><span></span></div><div class="hub-scroll"></div></div>`);
        row.querySelector('.hub-sec').onclick = () => { Sound.play('click'); openRowPage(r); };
        rows.appendChild(row);
      });
      vGames.content.appendChild(root);
      refreshGames();
      return vGames;
    }
    /* grelha de uma fila inteira (Ver todos) */
    function openRowPage(r) {
      const v = UI.view({ title: r.label, back: true, cls: 'gm gm-hub' });
      const grid = UI.el('<div class="hub hub-gridpg"><div class="hub-grid"></div></div>');
      const st = Arcade.stats();
      const ids = r.k === 'recent' ? Object.keys(st.games || {}).filter(id => gameOf(id)).sort((a, b) => ((st.games[b].last || 0) - (st.games[a].last || 0))) : Arcade.list().filter(d => r.k === 'mp' ? d.mp : d.kind === r.k).map(d => d.id);
      ids.forEach(id => { const d = gameOf(id); const c = cardFor(d, true); const s = subOf(d); c.querySelector('.hc-sub').textContent = s.t; c.classList.toggle('has-rec', s.rec); grid.querySelector('.hub-grid').appendChild(c); });
      if (!ids.length) grid.appendChild(UI.empty('gamepad', 'Nada por aqui', 'Ainda não há jogos nesta fila'));
      v.content.appendChild(grid);
      UI.push(win, v);
    }

    /* ================= página do jogo ================= */
    function openGamePage(d) {
      const v = UI.view({ title: d.name, back: true, cls: 'gm gm-hub gm-page', transparent: true });
      /* a barra só ganha fundo e título depois de a capa passar (como a página de um jogo na loja); a classe só muda ao cruzar */
      let pgScr = false;
      v.content.addEventListener('scroll', () => { const s = v.content.scrollTop > 200; if (s !== pgScr) { pgScr = s; v.classList.toggle('pg-scr', s); } }, { passive: true });
      const st = Arcade.stats(), gs = (st.games || {})[d.id] || { played: 0, time: 0, wins: 0 }, rec = recOf(d);
      const h = d.howto || null, tags = (d.tags || []).slice(0, 3), modes = Array.isArray(d.modes) ? d.modes : null;
      const root = UI.el(`<div class="hub hub-pg ${Arcade.isLight(d.color) ? 'lt' : ''}" style="--c:${d.color}">
        <div class="pg-hero">${Arcade.coverHTML(d)}<div class="pg-scrim"></div>
          <div class="pg-tt"><span class="pg-kind">${UI.esc(KIND[d.kind] || KIND.action)}${d.mp ? ' · <em>Online</em>' : ''}</span><b>${UI.esc(d.name)}</b>${tags.length ? `<div class="pg-tags">${tags.map(t => `<i>${UI.esc(t)}</i>`).join('')}</div>` : ''}</div></div>
        <div class="pg-acts"><div class="btn-p pg-play">${g('play', 16)}<span>Jogar</span></div>${d.mp ? `<div class="btn-p btn-s pg-chal">${g('users', 18)}<span>Desafiar</span></div>` : ''}</div>
        ${modes && modes.length ? `<div class="pg-modes"><span class="pm-l">Modos</span>${modes.map(m => `<i>${UI.esc(String(m && m.label || m))}</i>`).join('')}</div>` : ''}
        <p class="pg-desc">${UI.esc(d.desc || '')}</p>
        <div class="hub-sec"><div><b>Como jogar</b></div></div>
        <div class="pg-how">${h && h.goal ? `<p class="hgoal">${UI.esc(h.goal)}</p>` : ''}
          ${h && Array.isArray(h.steps) && h.steps.length ? `<div class="hsteps">${h.steps.map(s => `<div class="hs"><i>${g('checkCircle', 16)}</i><span>${UI.esc(String(s))}</span></div>`).join('')}</div>` : ''}
          ${h && Array.isArray(h.controls) && h.controls.length ? `<div class="hctl">${h.controls.map(c => `<div class="hc"><i>${g(c.icon || 'hand', 18)}</i><span>${UI.esc(String(c.label || ''))}</span></div>`).join('')}</div>` : ''}
          ${!h ? `<p class="hgoal">${UI.esc(d.kind === 'board' ? 'Vence o telemóvel ou um amigo, no mesmo telemóvel ou online.' : d.kind === 'puzzle' ? 'Resolve o puzzle no menor tempo ou com o menor número de jogadas.' : 'Faz o máximo de pontos antes de perderes.')}</p><div class="hctl"><div class="hc"><i>${g('hand', 18)}</i><span>Toque e swipe no palco</span></div><div class="hc"><i>${g('grid', 18)}</i><span>Setas, WASD e Espaço no teclado</span></div></div>` : ''}</div>
        <div class="hub-sec"><div><b>As tuas estatísticas</b></div></div>
        <div class="hub-tiles pg-tiles"><div class="hub-tile"><b data-noi18n>${Arcade.fmt(gs.played)}</b><span>Partidas</span></div><div class="hub-tile"><b data-noi18n>${UI.esc(Arcade.fmtTime(gs.time || 0))}</b><span>Tempo de jogo</span></div><div class="hub-tile"><b data-noi18n>${rec ? UI.esc(fmtS(d, rec)) : '--'}</b><span>${UI.esc(d.bestLabel || 'Recorde')}</span></div><div class="hub-tile"><b data-noi18n>${Arcade.fmt(gs.wins)}</b><span>Vitórias</span></div></div>
        <div class="hub-sec"><div><b>Tabela do servidor</b></div><span class="pg-more">Ver tudo</span></div>
        <div class="pg-board"><div class="pg-vars gm-seg hidden"></div><div class="pg-pod"><div class="lb-spin">${g('update', 22)}</div></div><div class="pg-me"></div></div>
        <div class="hub-sec"><div><b>Conquistas</b></div><span class="pg-achn"></span></div>
        <div class="hub-ach pg-ach"></div></div>`);
      root.querySelector('.pg-play').onclick = () => { Sound.play('click'); System.openApp(d.id); };
      const chal = root.querySelector('.pg-chal'); if (chal) chal.onclick = () => { Sound.play('click'); challenge(d.id); };
      /* tabela: primeira variante por omissão, segmentos para as outras */
      let board = d.boards()[0];
      const vars = root.querySelector('.pg-vars');
      if (d.variants) { d.variants.forEach((x, i) => { const b = UI.el(`<div class="${i === 0 ? 'on' : ''}">${UI.esc(x.label)}</div>`); b.onclick = () => { if (b.classList.contains('on')) return; [...vars.children].forEach(c => c.classList.toggle('on', c === b)); board = d.boardOf(x.key); Sound.play('tick'); loadPreview(); }; vars.appendChild(b); }); vars.classList.remove('hidden'); }
      root.querySelector('.pg-more').onclick = () => { Sound.play('click'); Arcade.openBoard(board); };
      let seq = 0;
      async function loadPreview() {
        const my = ++seq, pod = root.querySelector('.pg-pod'), me = root.querySelector('.pg-me');
        pod.classList.add('loading');
        const r = await Promise.resolve(Bridge.rpc('arcade.board', { board, scope: 'all' })).catch(() => null);
        if (my !== seq) return;
        pod.classList.remove('loading');
        [...pod.children].forEach(c => { if (!c.classList.contains('lb-spin')) c.remove(); });
        const top = (r && !r.error && Array.isArray(r.top)) ? r.top.slice(0, 3) : [];
        if (!top.length) { pod.appendChild(UI.el(`<div class="pg-none">${UI.esc(r && r.error === 'game' ? 'Este jogo não tem tabela no servidor' : !r ? 'Sem ligação ao servidor' : 'Ainda sem pontuações. Sê o primeiro.')}</div>`)); me.textContent = ''; return; }
        pod.appendChild(Arcade.podium(top, e => fmtS(d, e.score, board)));
        const mine = r.me;
        me.innerHTML = mine && mine.rank ? `<span>A tua posição</span><b data-noi18n>#${mine.rank}</b><i data-noi18n>${UI.esc(fmtS(d, mine.score, board))}</i>` : `<span>Ainda fora da tabela</span>`;
      }
      loadPreview();
      /* conquistas deste jogo */
      const achBox = root.querySelector('.pg-ach'), list = achOf(d.id, meData);
      list.forEach(a => { const el = UI.el(`<div class="ach ${a.done ? 'done' : ''}"><div class="ic">${a.icon}</div><span>${UI.esc(a.name)}</span></div>`); el.onclick = () => UI.alert({ title: a.name, msg: Tr(a.desc) + (a.done ? '' : ' ' + Tr('Ainda por conquistar.')) }); achBox.appendChild(el); });
      root.querySelector('.pg-achn').textContent = list.length ? list.filter(a => a.done).length + ' / ' + list.length : '';
      if (!list.length) { achBox.classList.add('none'); achBox.appendChild(UI.el('<div class="pg-none">Este jogo conta para as conquistas gerais</div>')); }
      v.content.appendChild(root);
      UI.push(win, v);
    }

    /* ================= separador CLASSIFICAÇÕES ================= */
    let vBoards = null, curGame = null, curVar = null, curScope = 'all', lbSeq = 0; const rows = [], gsel = {};
    const curBoard = () => { const d = Arcade.def(curGame); if (!d) return null; return d.variants ? d.boardOf(curVar || d.variants[0].key) : d.board; };
    function rowAt(i, lb) { if (!rows[i]) { rows[i] = UI.el(`<div class="lb-row"><i class="pos"></i><div class="av"></div><b class="nm" data-noi18n></b><span class="sc" data-noi18n></span></div>`); lb.appendChild(rows[i]); } return rows[i]; }
    async function loadBoard() {
      if (!vBoards) return;
      const root = vBoards.content.querySelector('.hub'), lb = root.querySelector('.hub-lb'), me = root.querySelector('.hub-me'), emp = root.querySelector('.hub-lbempty'), pod = root.querySelector('.hub-pod');
      const d = Arcade.def(curGame), board = curBoard(); if (!d || !board) return;
      const my = ++lbSeq;
      lb.classList.add('loading'); emp.classList.add('hidden');
      const r = await Promise.resolve(Bridge.rpc('arcade.board', { board, scope: curScope })).catch(() => null);
      if (my !== lbSeq || !vBoards.isConnected && !lb.isConnected) return;
      lb.classList.remove('loading');
      const top = (r && !r.error && Array.isArray(r.top)) ? r.top : [];
      /* pódio dos três primeiros, lista a partir do quarto */
      pod.innerHTML = ''; pod.classList.toggle('hidden', !top.length);
      if (top.length) pod.appendChild(Arcade.podium(top.slice(0, 3), e => fmtS(d, e.score, board)));
      const rest = top.slice(3);
      rest.forEach((e, i) => {
        const row = rowAt(i, lb);
        row.classList.remove('hidden'); row.classList.toggle('me', !!e.me);
        row.querySelector('.pos').textContent = e.rank || i + 4;
        const k = String(e.name || '?'); if (row.dataset.k !== k) { row.dataset.k = k; row.querySelector('.av').innerHTML = UI.avatar({ name: k }, 'sm'); }
        row.querySelector('.nm').textContent = k;
        row.querySelector('.sc').textContent = fmtS(d, e.score, board);
      });
      for (let i = rest.length; i < rows.length; i++) rows[i].classList.add('hidden');
      lb.classList.toggle('hidden', !rest.length);
      emp.innerHTML = '';
      if (!top.length) emp.appendChild(UI.empty('chart', r && r.error === 'game' ? 'Este jogo não tem tabela' : !r ? 'Sem ligação ao servidor' : curScope === 'friends' ? 'Nenhum contacto na tabela' : 'Ainda sem pontuações', !r ? 'Tenta outra vez daqui a pouco' : curScope === 'friends' ? 'Os teus contactos ainda não jogaram este jogo' : 'Joga uma partida para entrares na tabela'));
      emp.classList.toggle('hidden', !!top.length);
      const mine = r && !r.error && r.me;
      me.querySelector('.rk').textContent = mine && mine.rank ? '#' + mine.rank : '--';
      me.querySelector('.st').textContent = mine ? fmtS(d, mine.score, board) : '';
      me.querySelector('.st').classList.toggle('hidden', !mine);
      me.querySelector('.sub').textContent = mine ? '' : 'Ainda fora da tabela';
      me.querySelector('.sub').classList.toggle('hidden', !!mine);
      const n = r && !r.error ? (+r.count || top.length) : 0;
      root.querySelector('.hub-lbn').textContent = n ? n + ' jogadores' : '';
    }
    function paintVars() {
      const root = vBoards.content.querySelector('.hub'), vars = root.querySelector('.hub-vars'), d = Arcade.def(curGame);
      vars.innerHTML = '';
      if (!d || !d.variants) { vars.classList.add('hidden'); curVar = null; return; }
      if (!curVar || !d.variants.some(x => x.key === curVar)) curVar = d.variants[0].key;
      d.variants.forEach(x => { const b = UI.el(`<div class="${x.key === curVar ? 'on' : ''}">${UI.esc(x.label)}</div>`); b.onclick = () => { if (curVar === x.key) return; curVar = x.key; [...vars.children].forEach(c => c.classList.toggle('on', c === b)); Sound.play('tick'); loadBoard(); }; vars.appendChild(b); });
      vars.classList.remove('hidden');
    }
    function selectGame(id, variant) {
      if (!vBoards) { curGame = id; curVar = variant || null; return; }
      curGame = id; if (variant) curVar = variant;
      Object.keys(gsel).forEach(k => gsel[k].classList.toggle('on', k === id));
      const sel = gsel[id]; if (sel && sel.scrollIntoView) { try { sel.scrollIntoView({ block: 'nearest', inline: 'center', behavior: 'smooth' }); } catch (e) {} }
      const d = Arcade.def(id); const hd = vBoards.content.querySelector('.hub-bhead'); if (d && hd) { hd.style.setProperty('--c', d.color); hd.querySelector('.bh-name').textContent = d.name; hd.querySelector('.bh-kind').textContent = KIND[d.kind] || KIND.action; if (hd.dataset.id !== id) { hd.dataset.id = id; hd.querySelector('.bh-cov').innerHTML = Arcade.coverHTML(d); } }
      paintVars(); loadBoard();
    }
    function refreshBoards() {
      if (!vBoards) return;
      const root = vBoards.content.querySelector('.hub'), bar = root.querySelector('.hub-gsel');
      Arcade.list().forEach(d => { if (gsel[d.id]) return; const c = UI.el(`<div class="gs ${d.id === curGame ? 'on' : ''}"><div class="ic">${Icons.tile(d.id)}</div><span>${UI.esc(d.name)}</span></div>`); c.onclick = () => { if (curGame === d.id) return; Sound.play('click'); selectGame(d.id); }; gsel[d.id] = c; bar.appendChild(c); });
      if (!curGame) { const first = Arcade.list()[0]; if (first) curGame = first.id; }
      selectGame(curGame, curVar);
    }
    function tabBoards() {
      if (vBoards) { refreshBoards(); return vBoards; }
      vBoards = UI.view({ title: 'Classificações', large: true, cls: 'gm gm-hub' });
      const root = UI.el(`<div class="hub">
        <div class="hub-gsel"></div>
        <div class="hub-bhead"><div class="bh-cov"></div><div class="bh-scrim"></div><div class="bh-txt"><span class="bh-kind"></span><b class="bh-name"></b></div></div>
        <div class="hub-vars gm-seg hidden"></div>
        <div class="hub-scope gm-seg"><div data-s="all" class="on">Sempre</div><div data-s="week">Esta semana</div><div data-s="friends">Amigos</div></div>
        <div class="hub-pod hidden"></div>
        <div class="hub-me"><div class="av">${UI.avatar({ name: myName() }, 'sm')}</div><div class="bd"><b>A tua posição</b><span class="st" data-noi18n></span><span class="sub"></span></div><div class="rk">--</div></div>
        <div class="hub-sec"><div><b>Top 100 do servidor</b></div><span class="hub-lbn" data-noi18n></span></div>
        <div class="hub-lb"><div class="lb-spin">${g('update', 22)}</div></div>
        <div class="hub-lbempty hidden"></div>
        <div class="group-footer">Esta semana: quem melhorou o recorde nos últimos sete dias. Amigos: os teus contactos que estão na tabela.</div></div>`);
      root.querySelectorAll('.hub-scope > div').forEach(b => { b.onclick = () => { const s = b.dataset.s; if (s === curScope) return; curScope = s; root.querySelectorAll('.hub-scope > div').forEach(x => x.classList.toggle('on', x === b)); Sound.play('tick'); loadBoard(); }; });
      vBoards.content.appendChild(root);
      refreshBoards();
      return vBoards;
    }

    /* ================= separador PERFIL ================= */
    let vProfile = null, achEls = {};
    async function refreshProfile() {
      if (!vProfile) return;
      const root = vProfile.content.querySelector('.hub');
      root.querySelector('.hub-prof .nm').textContent = myName();
      root.querySelector('.hub-prof .av').innerHTML = UI.avatar({ name: myName() }, 'sm');
      const paintStats = () => {
        const x = Arcade.xp(meData);
        root.querySelector('[data-k="played"] b').textContent = Arcade.fmt(x.played);
        root.querySelector('[data-k="time"] b').textContent = Arcade.fmtTime(x.time);
        root.querySelector('[data-k="mp"] b').textContent = Arcade.fmt(x.mpWins);
        root.querySelector('[data-k="rec"] b').textContent = Arcade.fmt(x.records);
        root.querySelector('.hub-prof .ln').textContent = x.level;
        root.querySelector('.hub-prof .ttl').textContent = x.title;
        const ring = root.querySelector('.hub-prof .ring .fg'); if (ring) ring.style.strokeDashoffset = (138.2 * (1 - Math.max(0, Math.min(1, x.into / Math.max(1, x.need))))).toFixed(1);
        root.querySelector('.hub-xp .xb i').style.transform = 'scaleX(' + Math.max(0.02, Math.min(1, x.into / Math.max(1, x.need))).toFixed(3) + ')';
        root.querySelector('.hub-xp .xcur').textContent = Arcade.fmt(x.xp) + ' XP';
        root.querySelector('.hub-xp .xnext').textContent = 'Faltam ' + Arcade.fmt(Math.max(0, x.need - x.into)) + ' XP para o nível ' + (x.level + 1);
        const list = Arcade.achievements(meData);
        let n = 0;
        list.forEach(a => { const el = achEls[a.id]; if (!el) return; el.classList.toggle('done', a.done); if (a.done) n++; });
        root.querySelector('.ach-n').textContent = n + ' / ' + list.length;
        root.querySelector('.hub-achbar i').style.transform = 'scaleX(' + (list.length ? Math.max(0.02, n / list.length) : 0).toFixed(3) + ')';
        const dl = Arcade.daily(), st = Arcade.stats(), dd = dl && gameOf(dl.id);
        root.querySelector('[data-k="daily"] b').textContent = Arcade.fmt(st.dailyDone || 0);
        root.querySelector('[data-k="daily"] span').textContent = dd && st.daily && st.daily.day === dl.day ? 'Desafios do dia feitos, incluindo o de hoje' : 'Desafios do dia feitos';
      };
      paintStats();
      const r = await Promise.resolve(Bridge.rpc('arcade.me', {})).catch(() => null);
      if (r && !r.error) { meData = r; if (vProfile.isConnected || root.isConnected) paintStats(); }
      refreshMatches();
    }
    async function refreshMatches() {
      if (!vProfile) return;
      const root = vProfile.content.querySelector('.hub'), box = root.querySelector('.hub-matches');
      const list = await Arcade.match.mine();
      if (!root.isConnected && !vProfile.isConnected) return;
      box.innerHTML = '';
      if (!list.length) { box.appendChild(UI.el('<div class="hub-none">Sem partidas em curso</div>')); return; }
      list.forEach(m => {
        const d = Arcade.def(m.game), other = (m.players || {})[m.you === 'a' ? 'b' : 'a'] || '?', mine = m.turn === m.you;
        const row = UI.el(`<div class="hub-mrow ${mine ? 'mine' : ''}"><div class="ic">${d ? Icons.tile(m.game) : g('gamepad', 26)}</div><div class="bd"><b>${UI.esc(d ? d.name : m.game)}</b><span><span>contra</span> <i data-noi18n>${UI.esc(other)}</i> · <em>${mine ? 'É a tua vez' : 'À espera do adversário'}</em></span></div><div class="go">${g('play', 20)}</div></div>`);
        row.onclick = () => Arcade.openGame(m.game, m);
        box.appendChild(row);
      });
    }
    async function challenge(preGame) {
      const mp = Arcade.list().filter(d => d.mp);
      if (!mp.length) { UI.toast('Ainda não há jogos a dois instalados'); return; }
      const game = preGame || await UI.actionSheet({ title: 'Desafiar para', buttons: mp.map(d => ({ label: d.name, value: d.id })) }); if (!game) return;
      const who = await UI.actionSheet({ title: 'Quem', buttons: [{ label: 'Um contacto', value: 'contact', icon: 'person' }, { label: 'Alguém perto de mim', value: 'nearby', icon: 'location' }] }); if (!who) return;
      let target = null;
      if (who === 'contact') {
        if (!window.Contacts || !Contacts.pick) { UI.toast('Contactos indisponíveis'); return; }
        const c = await Contacts.pick('Desafiar'); if (!c || !c.number) return;
        target = { number: c.number, name: c.name };
      } else {
        const list = await Arcade.match.nearby();
        if (!list.length) { UI.toast('Ninguém com telemóvel a menos de 30 metros'); return; }
        const pick = await UI.actionSheet({ title: 'Jogadores perto de ti', buttons: list.map(p => ({ label: `${p.name} · ${Math.round(p.dist || 0)} m`, value: p.src })) }); if (pick == null) return;
        const p = list.find(x => x.src === pick); target = { src: pick, name: p && p.name };
      }
      const r = await Arcade.match.invite({ game, number: target.number, src: target.src });
      if (!r || r.error) { Sound.play('error'); UI.toast(ERR[r && r.error] || 'Não foi possível enviar o convite'); return; }
      if (target.number) {
        const d = Arcade.def(game);
        try { await Bridge.rpc('messages.send', { to: target.number, type: 'app', content: 'Desafio no Arcade: ' + (d ? d.name : game), payload: { app: game, url: `phone://arcade/${game}?match=${r.id}` } }); } catch (e) {}
      }
      Sound.play('send'); UI.toast('Convite enviado a ' + (target.name || 'jogador'));
      refreshMatches();
    }
    function tabProfile() {
      if (vProfile) { refreshProfile(); return vProfile; }
      vProfile = UI.view({ title: 'Perfil', large: true, cls: 'gm gm-hub', right: [{ icon: 'gear', label: 'Definições', onTap: () => { Sound.play('click'); Arcade.openSettings(); } }] });
      const root = UI.el(`<div class="hub">
        <div class="hub-prof"><div class="av"></div><div class="bd"><b class="nm" data-noi18n></b><span class="ttl"></span></div>
          <div class="lvl"><svg class="ring" viewBox="0 0 48 48"><circle class="bg" cx="24" cy="24" r="22"/><circle class="fg" cx="24" cy="24" r="22"/></svg><span class="lv"><small>Nível\u200b</small><b class="ln" data-noi18n>1</b></span></div></div>
        <div class="hub-xp"><div class="xb"><i></i></div><div class="xt"><span class="xcur" data-noi18n></span><span class="xnext"></span></div></div>
        <div class="hub-tiles"><div class="hub-tile" data-k="played"><b>0</b><span>Partidas</span></div><div class="hub-tile" data-k="time"><b>0</b><span>Tempo de jogo</span></div><div class="hub-tile" data-k="mp"><b>0</b><span>Vitórias online</span></div><div class="hub-tile" data-k="rec"><b>0</b><span>Recordes</span></div><div class="hub-tile wide" data-k="daily"><b>0</b><span>Desafios do dia feitos</span></div></div>
        <div class="hub-sec"><div><b>Partidas em curso</b></div></div><div class="hub-matches"></div>
        <div class="btn-p hub-chal">${g('users', 18)}<span>Desafiar um contacto</span></div>
        <div class="hub-sec"><div><b>Conquistas</b></div><span class="ach-n" data-noi18n></span></div>
        <div class="hub-achbar"><i></i></div>
        <div class="hub-ach"></div>
        <div class="btn-p btn-s hub-cfgbtn">${g('gear', 18)}<span>Definições do Arcade</span></div>
        <div class="btn-p btn-s danger-t clear">Apagar recordes locais</div>
        <div class="group-footer">As pontuações ficam no servidor, por personagem. As conquistas e o nível contam-se neste telemóvel; as da tabela confirmam-se no servidor.</div></div>`);
      const ach = root.querySelector('.hub-ach'); achEls = {};
      Arcade.achievements(null).forEach(a => { const el = UI.el(`<div class="ach"><div class="ic">${a.icon}</div><span>${UI.esc(a.name)}</span></div>`); el.onclick = () => UI.alert({ title: a.name, msg: Tr(a.desc) + (el.classList.contains('done') ? '' : ' ' + Tr('Ainda por conquistar.')) }); achEls[a.id] = el; ach.appendChild(el); });
      root.querySelector('.hub-chal').onclick = () => challenge();
      root.querySelector('.hub-cfgbtn').onclick = () => { Sound.play('click'); Arcade.openSettings(); };
      root.querySelector('.clear').onclick = async () => {
        if (!await UI.confirm('Apagar recordes locais', 'Perdes os recordes guardados neste telemóvel. As pontuações do servidor ficam.', 'Apagar', true)) return;
        Arcade.clearBest(); refreshProfile(); refreshGames(); UI.toast('Recordes apagados');
      };
      vProfile.content.appendChild(root);
      refreshProfile();
      return vProfile;
    }

    const tabs = UI.tabbar(win, [
      { icon: 'gamepad', label: 'Jogos', view: tabGames },
      { icon: 'chart', label: 'Classificações', view: tabBoards },
      { icon: 'person', label: 'Perfil', view: tabProfile },
    ], 0);
    win._tabs = tabs;
    win._openGame = id => { const d = gameOf(id); if (d) openGamePage(d); };
    win._intent = i => { if (!i) return; if (i.tab === 1) { const b = String(i.board || ''); const id = Arcade.list().find(d => d.boards().includes(b)); if (id) { const v = id.variants ? (id.variantOf ? id.variantOf(b) : b.slice(id.board.length + 1)) : null; if (v) curVar = v; curGame = id.id; } tabs.go(1); if (id) selectGame(id.id, id.variants ? curVar : null); } else tabs.go(i.tab || 0); };
    win._refresh = () => { if (tabs.cur === 0) refreshGames(); else if (tabs.cur === 1) loadBoard(); else refreshProfile(); };
    const offs = [
      Bridge.on('arcade:games', () => { refreshGames(); if (vBoards) refreshBoards(); }),
      Bridge.on('arcade:match', () => { if (vProfile && tabs.cur === 2) refreshMatches(); }),
    ];
    win.onClose = () => offs.forEach(f => { try { f(); } catch (e) {} });
    const intent = Arcade.takeIntent(); if (intent) setTimeout(() => win._intent(intent), 30);
  },
  resume(win) { try { const i = Arcade.takeIntent(); if (i) win._intent(i); else win._refresh && win._refresh(); } catch (e) {} },
});

/* ligação profunda phone://arcade/<jogo>?match=<id> (mensagem "Desafio no Arcade", notificações, Lua) */
if (window.System && typeof System.route === 'function') System.route('arcade', async d => {
  const game = d && d.parts && d.parts[0]; if (!game) return;
  const id = d.query && d.query.match;
  if (id) { const m = await Arcade.match.state({ id }); if (m && m.id && !m.error && !m.ended) { Arcade.openGame(game, m); return; } UI.toast('Essa partida já terminou'); }
  if (App.get(game)) System.openApp(game);
});
