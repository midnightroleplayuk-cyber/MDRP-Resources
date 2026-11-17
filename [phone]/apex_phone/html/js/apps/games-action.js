/* ===================== JOGOS DE AÇÃO A - apex_phone 1.5.0 =====================
   Quatro jogos de ação em canvas 2D sobre a casca comum do games.js (Arcade.shell e as
   extensões 1.5.0: A.ready, A.options, A.flash, A.haptic, A.sfx, A.end, e as da ronda 2,
   chamadas de forma defensiva: A.countdown, A.celebrate, A.toast):
   Planar (glide), Rochas (rocks), Corredor (runner) e Salto (hop). Pong, Hóquei, Corte e Torre
   vivem em games-action2.js com cópia própria dos utilitários.

   Regras cumpridas em todos (SPEC §2, §6; SPEC-GAMES-2 §1):
     · Nenhum jogo arranca sozinho: quadro estático + "Toca para começar" (+ contagem 3-2-1 nos
       jogos de reflexos, se a casca a tiver).
     · UM requestAnimationFrame por jogo (Arcade.loop), que morre em pause()/onClose e retoma sem
       salto de tempo. Nada corre em pausa.
     · Tela em tamanho lógico fixo (sem DPR); em pé 400 de largura, o shell encolhe com zoom quando
       o aparelho está deitado (A.fit).
     · Toda a arte é PRÉ-DESENHADA uma vez em canvas fora do ecrã (gradientes, shadowBlur, traços)
       e por quadro só há drawImage, fillRect, arcos das partículas e fillText de números.
     · Zero alocações por quadro: pools fixos (partículas, textos, rochas, balas, objetos da estrada),
       ciclos indexados, sem closures nem arrays novos no caminho quente, sem save/restore em
       ciclos grandes (setTransform direto).
     · Game feel: hit stop (dt congelado 40 a 90 ms), câmara lenta 0,3× durante 0,5 s na morte, flash
       branco (retângulo com alpha), abanão por transform na tela, partículas com a cor do que foi
       destruído, rastos pré-desenhados, textos a flutuar.
     · Texto visível em PT no DOM (HUD, flashes, fim de jogo); dentro da tela só números e sinais.
   ============================================================================= */
(() => {
  if (!window.Arcade || !Arcade.shell) return;
  const g = UI.g;

  /* ---------- utilitários ---------- */
  const TAU = Math.PI * 2, HPI = Math.PI / 2;
  const clamp = (v, a, b) => (v < a ? a : v > b ? b : v);
  const rnd = (a, b) => a + Math.random() * (b - a);
  const pick = a => a[(Math.random() * a.length) | 0];
  const hyp = Math.hypot;
  const angDiff = (a, b) => { let d = (b - a) % TAU; if (d > Math.PI) d -= TAU; if (d < -Math.PI) d += TAU; return d; };
  const FONT = "Inter, -apple-system, 'Segoe UI', Roboto, sans-serif";
  const rr = (c, x, y, w, h, r) => { r = Math.max(0, Math.min(r, w / 2, h / 2)); c.beginPath(); c.moveTo(x + r, y); c.arcTo(x + w, y, x + w, y + h, r); c.arcTo(x + w, y + h, x, y + h, r); c.arcTo(x, y + h, x, y, r); c.arcTo(x, y, x + w, y, r); c.closePath(); };
  const segDist = (px, py, ax, ay, bx, by) => { const dx = bx - ax, dy = by - ay, l = dx * dx + dy * dy; const u = l ? clamp(((px - ax) * dx + (py - ay) * dy) / l, 0, 1) : 0; return hyp(px - (ax + u * dx), py - (ay + u * dy)); };
  const txt = (c, s, x, y, size, col, weight, align) => { c.font = `${weight || 700} ${size}px ${FONT}`; c.textAlign = align || 'center'; c.textBaseline = 'middle'; c.fillStyle = col || '#fff'; c.fillText(s, x, y); };
  const lgrad = (c, x0, y0, x1, y1, stops) => { const gr = c.createLinearGradient(x0, y0, x1, y1); for (let i = 0; i < stops.length; i++) gr.addColorStop(stops[i][0], stops[i][1]); return gr; };
  const rgrad = (c, x0, y0, r0, x1, y1, r1, stops) => { const gr = c.createRadialGradient(x0, y0, r0, x1, y1, r1); for (let i = 0; i < stops.length; i++) gr.addColorStop(stops[i][0], stops[i][1]); return gr; };
  const hexA = (hex, a) => { const n = parseInt(hex.slice(1), 16); return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${a})`; };
  const hint = s => `<span class="gm-hint">${s}</span>`;
  const safe = fn => { try { return fn(); } catch (e) { return undefined; } };
  const mk = (n, f) => { const a = new Array(n); for (let i = 0; i < n; i++) a[i] = f(i); return a; };

  /* sprite pré-desenhado: um canvas fora do ecrã criado UMA vez; por quadro só drawImage */
  const spr = (w, h, fn) => { const cv = document.createElement('canvas'); cv.width = Math.max(1, Math.round(w)); cv.height = Math.max(1, Math.round(h)); const c = cv.getContext('2d'); fn(c, cv.width, cv.height); return cv; };
  const glow = (c, col, blur) => { c.shadowColor = col; c.shadowBlur = blur; };
  const noGlow = c => { c.shadowBlur = 0; c.shadowColor = 'rgba(0,0,0,0)'; };
  /* ponto luminoso (bala, faísca): centro claro, cor, e esvai até à mesma cor transparente */
  const glowDot = (r, col, core) => spr(r * 2 + 2, r * 2 + 2, (c, w, h) => { c.fillStyle = rgrad(c, w / 2, h / 2, 0, w / 2, h / 2, r, [[0, core || '#fff'], [.3, col], [1, hexA(col, 0)]]); c.fillRect(0, 0, w, h); });
  /* anel néon (explosão, escudo) */
  const ringSpr = (r, col, lw, blur) => { const m = lw + blur + 2, S = (r + m) * 2; return spr(S, S, c => { glow(c, col, blur); c.lineWidth = lw; c.strokeStyle = col; c.beginPath(); c.arc(S / 2, S / 2, r, 0, TAU); c.stroke(); c.stroke(); noGlow(c); }); };
  /* cápsula do HUD (meio): glifo SVG + número; o texto fixo vai em <em> (traduzível) */
  const cap = (cls, icon, label) => `<span class="ga-cap ${cls || ''}">${icon || ''}${label ? `<em>${label}</em>` : ''}<b>0</b></span>`;
  const COIN_SVG = '<i class="ga-coin"></i>';

  /* ---------- física pura (sem DOM) partilhada com o teste test_action.mjs ----------
     pillarHit: planador (círculo) contra as duas colunas de uma abertura. medalFor: medalha por pontos.
     chainMult: multiplicador das Rochas pela cadeia de acertos. hopUnlock: personagens pela pontuação. */
  const pillarHit = (y, R, BX, p, PW) => {
    if (!(BX + R > p.x && BX - R < p.x + PW)) return false;
    const top = p.cy - p.gh / 2, bot = p.cy + p.gh / 2, cx = clamp(BX, p.x, p.x + PW);
    return (y - R < top && hyp(BX - cx, y - Math.min(y, top)) < R) || (y + R > bot && hyp(BX - cx, y - Math.max(y, bot)) < R);
  };
  const MEDAL_AT = [10, 25, 50, 100], MEDAL_NAME = ['Medalha de bronze', 'Medalha de prata', 'Medalha de ouro', 'Medalha de platina'];
  const medalFor = s => { let m = -1; for (let i = 0; i < MEDAL_AT.length; i++) if (s >= MEDAL_AT[i]) m = i; return m; };
  const chainMult = n => 1 + Math.min(4, (n / 4) | 0);
  const HOP_CHARS = [{ v: 'galinha', label: 'Galinha', need: 0 }, { v: 'pato', label: 'Pato', need: 50 }, { v: 'sapo', label: 'Sapo', need: 100 }];
  const hopUnlock = best => HOP_CHARS.filter(ch => best >= ch.need).map(ch => ch.v);

  /* ---------- partículas e textos a flutuar: pool fixo, sem alocações por quadro ----------
     kind 0 = ponto (arco), 1 = traço na direção da velocidade (destroços), 2 = quadrado (faísca) */
  function Fx(max) {
    max = max || 160;
    const P = new Array(max); let n = 0;
    for (let i = 0; i < max; i++) P[i] = { x: 0, y: 0, vx: 0, vy: 0, life: 0, max: 1, col: '#fff', size: 3, g: 0, k: 0 };
    const TN = 8, T = new Array(TN); let tn = 0;
    for (let i = 0; i < TN; i++) T[i] = { x: 0, y: 0, s: '', col: '#fff', size: 22, life: 0, max: 1 };
    const take = () => (n < max ? P[n++] : P[(Math.random() * max) | 0]);
    return {
      get count() { return n; },
      burst(x, y, col, count, spd, life, size, grav, kind) {
        for (let i = 0; i < count; i++) {
          const p = take(), a = rnd(0, TAU), v = spd * rnd(.3, 1), l = life * rnd(.6, 1);
          p.x = x; p.y = y; p.vx = Math.cos(a) * v; p.vy = Math.sin(a) * v; p.life = l; p.max = l; p.col = col; p.size = size * rnd(.6, 1); p.g = grav || 0; p.k = kind || 0;
        }
      },
      /* uma partícula com velocidade dada (chama, rasto, destroço dirigido) */
      one(x, y, vx, vy, col, life, size, grav, kind) { const p = take(); p.x = x; p.y = y; p.vx = vx; p.vy = vy; p.life = life; p.max = life; p.col = col; p.size = size; p.g = grav || 0; p.k = kind || 0; },
      text(x, y, s, col, size, life) { const m = T[tn++ % TN]; m.x = x; m.y = y; m.s = s; m.col = col || '#fff'; m.size = size || 22; m.life = life || 1; m.max = m.life; },
      step(dt) {
        for (let i = n - 1; i >= 0; i--) {
          const p = P[i]; p.life -= dt;
          if (p.life <= 0) { n--; if (i !== n) { P[i] = P[n]; P[n] = p; } continue; }
          p.x += p.vx * dt; p.y += p.vy * dt; p.vy += p.g * dt;
          const k = Math.max(0, 1 - 2.2 * dt); p.vx *= k; if (!p.g) p.vy *= k;
        }
        for (let i = 0; i < TN; i++) { const m = T[i]; if (m.life > 0) { m.life -= dt; m.y -= 34 * dt; } }
      },
      draw(c) {
        for (let i = 0; i < n; i++) {
          const p = P[i], a = p.life / p.max; c.globalAlpha = a;
          if (p.k === 1) { c.strokeStyle = p.col; c.lineWidth = Math.max(1, p.size * .5); c.beginPath(); c.moveTo(p.x, p.y); c.lineTo(p.x - p.vx * .05, p.y - p.vy * .05); c.stroke(); }
          else if (p.k === 2) { const s = p.size * (.4 + .6 * a); c.fillStyle = p.col; c.fillRect(p.x - s / 2, p.y - s / 2, s, s); }
          else { c.fillStyle = p.col; c.beginPath(); c.arc(p.x, p.y, p.size * (.35 + .65 * a), 0, TAU); c.fill(); }
        }
        for (let i = 0; i < TN; i++) {
          const m = T[i]; if (m.life <= 0) continue;
          const age = m.max - m.life, pop = 1 + .25 * Math.max(0, 1 - age / .15);
          c.globalAlpha = Math.min(1, m.life / m.max * 2.2);
          c.font = `800 ${Math.round(m.size * pop)}px ${FONT}`; c.textAlign = 'center'; c.textBaseline = 'middle';
          c.lineWidth = 4; c.strokeStyle = 'rgba(0,0,0,.45)'; c.strokeText(m.s, m.x, m.y);
          c.fillStyle = m.col; c.fillText(m.s, m.x, m.y);
        }
        c.globalAlpha = 1;
      },
      clear() { n = 0; for (let i = 0; i < TN; i++) T[i].life = 0; },
    };
  }

  /* abanão: transform curto na tela, decai sozinho e volta a '' (nada fica a animar) */
  function shaker(cv) {
    let a = 0, t = 0;
    return {
      hit(k) { a = Math.max(a, Math.min(14, k)); },
      step(dt) { if (!a) return; t += dt; a = a > .3 ? a * Math.exp(-dt * 9) : 0; cv.style.transform = a ? `translate(${(Math.sin(t * 91) * a).toFixed(1)}px,${(Math.cos(t * 117) * a).toFixed(1)}px)` : ''; },
      reset() { a = 0; cv.style.transform = ''; },
    };
  }

  /* teclas "seguras": o keydown repete-se enquanto a tecla está em baixo, por isso cada keydown dá uma
     janela curta (maior no primeiro, que antecede a pausa do auto-repeat); um keyup fecha-a logo */
  function keys() {
    const h = {};
    return {
      down(k, rep) { h[k] = rep ? .12 : .22; },
      up(k) { h[k] = 0; },
      step(dt) { for (const k in h) if (h[k] > 0) h[k] -= dt; },
      is(k) { return h[k] > 0; },
      clear() { for (const k in h) h[k] = 0; },
    };
  }
  const ARROWS = { ArrowLeft: 'left', ArrowRight: 'right', ArrowUp: 'up', ArrowDown: 'down', a: 'left', d: 'right', w: 'up', s: 'down', A: 'left', D: 'right', W: 'up', S: 'down', ' ': 'space', Enter: 'space', Spacebar: 'space' };

  /* sons com intervalo mínimo: uma troca rápida não metralha o sintetizador (um nome desconhecido não faz nada) */
  const sfx = A => { const last = {}; return (n, gap) => { const now = performance.now(); if (last[n] && now - last[n] < (gap == null ? 70 : gap)) return; last[n] = now; try { A.sfx(n); } catch (e) {} }; };

  /* ponteiro no PALCO inteiro, convertido para as unidades lógicas da tela. A medida da tela faz-se UMA vez
     por gesto (nunca por quadro); o quociente largura real / largura lógica aguenta o zoom do aparelho e o
     zoom do fit(). O ponto devolvido é um objeto reutilizado (sem alocação por evento). */
  function pointer(X, h) {
    const zone = X.A.el.stage, cv = X.cv, W = X.W, H = X.H;
    let rect = null;
    const active = {}, pt = { x: 0, y: 0, id: 0 };
    const map = e => {
      if (!rect || !rect.width) rect = cv.getBoundingClientRect();
      const kx = rect.width ? W / rect.width : 1, ky = rect.height ? H / rect.height : kx;
      pt.x = (e.clientX - rect.left) * kx; pt.y = (e.clientY - rect.top) * ky; pt.id = e.pointerId; return pt;
    };
    zone.style.touchAction = 'none';
    zone.addEventListener('pointerdown', e => {
      if (e.button && e.button !== 0) return;
      rect = null; active[e.pointerId] = 1;
      try { zone.setPointerCapture(e.pointerId); } catch (x) {}
      if (h.down) h.down(map(e), e);
    });
    zone.addEventListener('pointermove', e => { if (active[e.pointerId] && h.move) h.move(map(e), e); });
    const up = e => { if (!active[e.pointerId]) return; delete active[e.pointerId]; if (h.up) h.up(map(e), e); };
    zone.addEventListener('pointerup', up);
    zone.addEventListener('pointercancel', up);
  }
  /* botão que se "segura" (acelerar, disparar): on no pointerdown, off ao largar */
  const hold = (el, on, off) => {
    if (!el) return;
    el.addEventListener('pointerdown', e => { try { el.setPointerCapture(e.pointerId); } catch (x) {} on(); });
    ['pointerup', 'pointercancel'].forEach(ev => el.addEventListener(ev, off));
  };

  /* ---------- anfitrião comum: casca + tela + ciclo + estados + game feel ----------
     o.restart() recomeça (chamado pelo shell), o.tick(dt) avança e desenha, o.draw() desenha um quadro,
     o.key(e) recebe o teclado, o.onStart() corre quando o jogo começa a mexer, o.onResume(fromPause) ao retomar.
     X.hitStop(s) congela o dt por s segundos (só desenha), X.slow(k, s) multiplica o dt por k durante s segundos,
     X.flashW(a) pinta um retângulo branco com alpha a que esvai (X.post(c) no fim do draw), X.die(res, s) morre
     com estilo (câmara lenta 0,3× e o resultado só passados s segundos). */
  function host(win, o) {
    const X = { W: o.W, H: o.H, running: false, dead: false, dying: null, seq: 0, stopT: 0, slowT: 0, slowK: 1, white: 0, perf: { n: 0, sum: 0, max: 0 } };
    const A = Arcade.shell(win, {
      id: o.id, name: o.name, color: o.color, scoreLabel: o.scoreLabel, bestLabel: o.bestLabel,
      onRestart: () => o.restart(), onPause: () => X.L.stop(), onResume: () => X.go(true),
    });
    X.A = A;
    const cv = UI.el(`<canvas class="gm-cv ga-cv" width="${o.W}" height="${o.H}"></canvas>`);
    A.el.stage.appendChild(cv);
    X.cv = cv; X.ctx = cv.getContext('2d');
    X.fx = Fx(o.particles || 160); X.snd = sfx(A); X.shake = shaker(cv); X.K = keys();
    X.flash = (m, cls) => safe(() => A.flash(m, cls));
    X.haptic = k => safe(() => A.haptic(k));
    X.celebrate = k => safe(() => A.celebrate && A.celebrate(k));
    X.toast = m => safe(() => (A.toast ? A.toast(m) : A.flash(m)));
    X.alive = () => X.running && !X.dead && !X.dying;
    X.hitStop = s => { if (s > X.stopT) X.stopT = s; };
    X.slow = (k, s) => { X.slowK = k; X.slowT = s; };
    X.flashW = a => { if (a > X.white) X.white = a; };
    X.post = c => { if (X.white > 0) { c.globalAlpha = X.white; c.fillStyle = '#fff'; c.fillRect(0, 0, X.W, X.H); c.globalAlpha = 1; } };
    X.L = Arcade.loop(raw => {
      X.shake.step(raw);
      if (X.white > 0) X.white = Math.max(0, X.white - raw * 3.5);
      if (X.stopT > 0) { X.stopT -= raw; o.draw(); return; }
      let dt = raw;
      if (X.slowT > 0) { X.slowT -= raw; dt = raw * X.slowK; if (X.slowT <= 0) X.slowK = 1; }
      X.K.step(raw);
      if (X.dying) { X.dying.t -= raw; if (X.dying.t <= 0) { const r = X.dying.res; X.dying = null; X.over(r); return; } }
      const t0 = performance.now(); o.tick(dt);
      const ms = performance.now() - t0; X.perf.n++; X.perf.sum += ms; if (ms > X.perf.max) X.perf.max = ms;
    });
    /* retomar: só com o jogo a correr e sem a camada "Em pausa" do shell à espera do jogador */
    X.go = fromPause => { if (!X.running || X.dead || A.paused) return; if (o.onResume) o.onResume(fromPause); X.L.start(); };
    /* começar: quadro estático + "Toca para começar" (+ contagem 3-2-1 se a casca a tiver); o ciclo só arranca depois */
    X.begin = (title, sub, count) => {
      const tok = ++X.seq;
      X.running = false; X.dead = false; X.dying = null; X.stopT = 0; X.slowT = 0; X.slowK = 1; X.white = 0;
      X.L.stop(); X.shake.reset(); X.K.clear(); X.fx.clear();
      o.draw();
      const go = () => { if (tok !== X.seq || A.ended) return; X.running = true; if (o.onStart) o.onStart(); if (!A.paused) X.L.start(); };
      return A.ready(title, sub).then(() => {
        if (tok !== X.seq || A.ended) return;
        if (count && typeof A.countdown === 'function' && !window.__gaNoCount) { let p = null; try { p = A.countdown(3); } catch (e) { p = null; } return Promise.resolve(p).catch(() => 0).then(go); }
        go();
      });
    };
    /* morrer com estilo: câmara lenta, o ciclo continua `delay` s reais (partículas, queda) e só depois o resultado */
    X.die = (res, delay) => { if (X.dead || X.dying) return; X.dying = { res, t: delay || 1 }; X.slow(.3, .5); };
    X.over = res => { if (X.dead) return; X.dead = true; X.running = false; X.dying = null; X.L.stop(); X.shake.reset(); try { o.draw(); } catch (e) {} A.end(res); };
    win.onClose = () => { X.L.stop(); };
    X.api = {
      pause() { X.L.stop(); },
      /* ao voltar a tela pode ter sido descartada pelo CEF: redesenha-se um quadro antes de retomar */
      resume() { try { o.draw(); } catch (e) {} X.go(false); },
      key(e) { if (!X.running || X.dead || A.paused) return; return o.key ? o.key(e) : undefined; },
      /* só para o harness e o teste: estado e custo por quadro (nada no telemóvel usa isto) */
      dbg: Object.assign({ running: () => X.running && !X.dead, perf: () => ({ n: X.perf.n, avg: X.perf.n ? X.perf.sum / X.perf.n : 0, max: X.perf.max }), count: () => X.fx.count }, o.dbg || {}),
    };
    return X;
  }
  /* "novo recorde" no momento em que acontece (uma vez por partida) */
  const recordWatch = (X, board) => { const b0 = (safe(() => Arcade.best(board)) || 0); let shown = false; return s => { if (shown || !(b0 > 0) || !(s > b0)) return; shown = true; X.flash('Novo recorde', 'bonus'); X.snd('chime', 0); X.celebrate('record'); }; };

  /* =====================================================================
     1. PLANAR (glide): bater as asas pelas aberturas; pôr do sol de Los Santos com ciclo dia/noite
     ===================================================================== */
  Icons.app.glide = () => Icons.SVG(Icons.G('gGl', '#FFD98A', '#FF8A1F', '#B4360C') + Icons.GL(
    `<circle cx="66" cy="36" r="17" fill="#FFF6CC"/><circle cx="66" cy="36" r="24" fill="#FFF6CC" opacity=".22"/>` +
    `<path d="M0 74c16-12 30-16 46-9s28 10 54-4v39H0z" fill="#6C1D5F" opacity=".85"/>` +
    `<path d="M0 100V88c20-9 34-5 50 0s30 3 50-5v17z" fill="#2E0F3A"/>` +
    `<rect x="80" y="-4" width="14" height="38" rx="5" fill="#17B7B2"/><rect x="80" y="66" width="14" height="40" rx="5" fill="#17B7B2"/>` +
    `<ellipse cx="38" cy="52" rx="15" ry="11" fill="#FFF8E0"/><ellipse cx="40" cy="56" rx="8" ry="4.5" fill="#FFE7A8"/>` +
    `<path d="M31 54c-9-6-17-3-21 1 7 1 13 4 21 6z" fill="#fff"/><circle cx="46" cy="48" r="3.4" fill="#fff"/><circle cx="47" cy="48" r="1.9" fill="#1C1C1E"/><path d="M52 52l9 3-9 3z" fill="#FF6B2C"/>`));

  Arcade.game('glide', {
    name: 'Planar', color: '#FF9F0A', kind: 'action', tags: ['Clássico', 'Reflexos'],
    desc: 'Bate as asas e passa pelas aberturas sem tocar nas colunas. Os anéis dão bónus, o dia vira noite a cada dez pontos sobre Los Santos e há medalhas por pontuação. Três modos: Clássico, Noite e Difícil.',
    modes: [{ key: 'classico', label: 'Clássico', board: 'glide' }, { key: 'noite', label: 'Noite', board: 'glide' }, { key: 'dificil', label: 'Difícil', board: 'glide:dificil' }],
    /* tabelas do hub: Clássico e Noite partilham "glide"; Difícil tem a sua */
    variants: [{ key: 'normal', label: 'Clássico e Noite', board: 'glide' }, { key: 'dificil', label: 'Difícil', board: 'glide:dificil' }],
    howto: { goal: 'Passa pelo máximo de aberturas sem tocar nas colunas nem no chão.', steps: ['Toca para bater as asas; a gravidade faz o resto', 'Os anéis dourados no meio da abertura valem 2 pontos', 'A cada 10 pontos muda a hora do dia e há medalhas aos 10, 25, 50 e 100'], controls: [{ icon: 'hand', label: 'Toca no palco ou em Bater asas' }, { icon: 'gamepad', label: 'Espaço, seta para cima ou W' }] },
    cover: () => `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="cglS" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1B1240"/><stop offset=".45" stop-color="#6E2A5E"/><stop offset=".78" stop-color="#E0602F"/><stop offset="1" stop-color="#FFC98A"/></linearGradient><linearGradient id="cglP" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#0B6B78"/><stop offset=".45" stop-color="#2BD3C8"/><stop offset="1" stop-color="#07525F"/></linearGradient><radialGradient id="cglB" cx=".35" cy=".3" r=".8"><stop offset="0" stop-color="#FFF3B0"/><stop offset=".55" stop-color="#FFD60A"/><stop offset="1" stop-color="#FF9F0A"/></radialGradient></defs>` +
      `<rect width="400" height="200" fill="url(#cglS)"/><circle cx="300" cy="122" r="54" fill="#FFE1A8" opacity=".28"/><circle cx="300" cy="122" r="34" fill="#FFF0C2"/>` +
      `<path d="M0 150c40-30 80-30 120-14s80 24 140 0 90-22 140 4v60H0z" fill="#5A2858" opacity=".8"/>` +
      `<g fill="#20122E"><rect x="0" y="150" width="26" height="50"/><rect x="30" y="132" width="18" height="70"/><rect x="52" y="160" width="30" height="40"/><rect x="86" y="120" width="22" height="80"/><rect x="112" y="146" width="36" height="54"/><rect x="152" y="136" width="20" height="64"/><rect x="250" y="142" width="28" height="58"/><rect x="282" y="156" width="40" height="44"/><rect x="326" y="128" width="20" height="72"/><rect x="350" y="150" width="50" height="50"/></g>` +
      `<rect x="196" y="-10" width="46" height="66" rx="8" fill="url(#cglP)"/><rect x="190" y="46" width="58" height="16" rx="6" fill="#2FD1C2"/><rect x="190" y="132" width="58" height="16" rx="6" fill="#2FD1C2"/><rect x="196" y="140" width="46" height="70" rx="8" fill="url(#cglP)"/>` +
      `<ellipse cx="219" cy="97" rx="7" ry="22" fill="none" stroke="#FFD60A" stroke-width="4"/>` +
      `<g transform="translate(118 96) rotate(-12)"><ellipse rx="22" ry="17" fill="url(#cglB)"/><ellipse cx="2" cy="7" rx="12" ry="7" fill="#FFF1C2" opacity=".9"/><ellipse cx="-8" cy="2" rx="14" ry="6" fill="#fff" transform="rotate(-20)"/><circle cx="10" cy="-7" r="6" fill="#fff"/><circle cx="12" cy="-7" r="3" fill="#1C1C1E"/><path d="M20 -2l13 4-13 7z" fill="#FF6B2C"/></g>` +
      `<rect y="186" width="400" height="14" fill="#17102A"/></svg>`,
    build(win) {
      const W = 400, H = 640, GY = 586, BX = 108, R = 15, PW = 62, PH = 620, NP = 5;
      const MODES = [{ v: 'classico', label: 'Clássico' }, { v: 'noite', label: 'Noite' }, { v: 'dificil', label: 'Difícil' }];
      let mode = String(Arcade.opt('glide:mode', 'classico') || 'classico'); if (!MODES.some(m => m.v === mode)) mode = 'classico';
      const board = () => (mode === 'dificil' ? 'glide:dificil' : 'glide');
      let y, vy, wingT, dist, score, rings, passed, lastGap, hover, hoverY, bob, ph, medal, thud, ang, spin, onRecord, lvl;
      const pillars = mk(NP, () => ({ x: 0, cy: 0, gh: 0, passed: false, ring: 0 }));
      const X = host(win, {
        id: 'glide', name: 'Planar', color: '#FF9F0A', W, H,
        restart: () => start(), tick, draw, key,
        onStart: () => { midPlay(); flap(true); },
        /* ao voltar o planador fica a pairar até ao toque seguinte: ninguém morre por ter atendido uma chamada */
        onResume: () => { if (X.alive()) { hover = true; hoverY = y; bob = 0; vy = 0; X.A.setMid(hint('Toca para continuar')); } },
        dbg: { score: n => { score = n; passed = n; dist = n * gapX(); X.A.setScore(n); }, pass: () => { score++; passed++; X.A.setScore(score); award(); }, crash: () => crash('Bateste numa coluna', true), ground: () => crash('Bateste no chão', false), mode: m => setMode(m), state: () => ({ y, vy, score, mode, ph: ph % 4, medal }) },
      });
      const c = X.ctx;
      X.A.setId(board());

      /* ----- arte pré-desenhada ----- */
      const SKY = [
        spr(W, GY, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, GY, [[0, '#2F7FDF'], [.55, '#79BCF5'], [1, '#DDEFFF']]); c2.fillRect(0, 0, W, GY); }),
        spr(W, GY, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, GY, [[0, '#1B1240'], [.42, '#6E2A5E'], [.74, '#E0602F'], [1, '#FFC98A']]); c2.fillRect(0, 0, W, GY); }),
        spr(W, GY, c2 => {
          c2.fillStyle = lgrad(c2, 0, 0, 0, GY, [[0, '#04051A'], [.55, '#0F1744'], [1, '#2B2E6B']]); c2.fillRect(0, 0, W, GY);
          for (let i = 0; i < 140; i++) { const s = rnd(.6, 1.8); c2.globalAlpha = rnd(.3, .95); c2.fillStyle = Math.random() < .2 ? '#CFE3FF' : '#fff'; c2.fillRect(rnd(0, W), rnd(0, GY * .8), s, s); }
          c2.globalAlpha = 1;
        }),
        spr(W, GY, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, GY, [[0, '#2E2A6B'], [.45, '#B04C86'], [.78, '#FF9A5C'], [1, '#FFE3B0']]); c2.fillRect(0, 0, W, GY); }),
      ];
      const SUN = spr(200, 200, c2 => { c2.fillStyle = rgrad(c2, 100, 100, 30, 100, 100, 100, [[0, 'rgba(255,240,200,.75)'], [.4, 'rgba(255,215,150,.28)'], [1, 'rgba(255,200,130,0)']]); c2.fillRect(0, 0, 200, 200); c2.fillStyle = rgrad(c2, 92, 92, 4, 100, 100, 42, [[0, '#FFFBEA'], [.8, '#FFF0C2'], [1, '#FFE0A0']]); c2.beginPath(); c2.arc(100, 100, 42, 0, TAU); c2.fill(); });
      const MOON = spr(140, 140, c2 => { c2.fillStyle = rgrad(c2, 70, 70, 22, 70, 70, 70, [[0, 'rgba(220,225,255,.5)'], [.5, 'rgba(200,210,255,.14)'], [1, 'rgba(200,210,255,0)']]); c2.fillRect(0, 0, 140, 140); c2.fillStyle = rgrad(c2, 62, 60, 4, 70, 70, 30, [[0, '#FFFFFF'], [.7, '#E9EAFF'], [1, '#C9CBEE']]); c2.beginPath(); c2.arc(70, 70, 30, 0, TAU); c2.fill(); c2.fillStyle = 'rgba(120,125,170,.22)'; c2.beginPath(); c2.arc(60, 64, 6, 0, TAU); c2.fill(); c2.beginPath(); c2.arc(80, 78, 4, 0, TAU); c2.fill(); c2.beginPath(); c2.arc(74, 58, 3, 0, TAU); c2.fill(); });
      const CLOUDS = spr(800, 220, c2 => {
        const cloud = (x, yy, s, a) => { c2.globalAlpha = a; c2.fillStyle = '#FFEFE2'; glow(c2, 'rgba(255,200,170,.6)', 18); for (let i = 0; i < 5; i++) { const px = x + (i - 2) * 26 * s, r = (16 + (i === 2 ? 14 : i === 1 || i === 3 ? 8 : 0)) * s; c2.beginPath(); c2.arc(px, yy - (r - 16 * s) * .6, r, 0, TAU); c2.fill(); } noGlow(c2); c2.fillStyle = 'rgba(200,120,140,.25)'; c2.beginPath(); c2.ellipse(x, yy + 10 * s, 64 * s, 6 * s, 0, 0, TAU); c2.fill(); };
        cloud(90, 70, 1, .9); cloud(300, 130, .72, .75); cloud(520, 50, 1.2, .85); cloud(700, 160, .62, .7);
        c2.globalAlpha = 1;
      });
      const HILLS = spr(800, 160, c2 => {
        const hill = (col, amp1, amp2, phase, base) => { c2.fillStyle = col; c2.beginPath(); c2.moveTo(0, 160); for (let x = 0; x <= 800; x += 10) c2.lineTo(x, base - Math.sin(x / 800 * TAU * 2 + phase) * amp1 - Math.sin(x / 800 * TAU * 5 + phase * 2) * amp2); c2.lineTo(800, 160); c2.closePath(); c2.fill(); };
        hill('rgba(120,60,130,.55)', 26, 10, 1.4, 70); hill('rgba(88,38,96,.9)', 30, 14, 0, 96);
        c2.strokeStyle = 'rgba(255,170,140,.25)'; c2.lineWidth = 2; c2.beginPath(); for (let x = 0; x <= 800; x += 10) { const yy = 96 - Math.sin(x / 800 * TAU * 2) * 30 - Math.sin(x / 800 * TAU * 5) * 14; if (x) c2.lineTo(x, yy); else c2.moveTo(x, yy); } c2.stroke();
      });
      const towers = []; for (let x = 0; x < 800;) { const w = rnd(22, 58), h = rnd(44, 170); if (x + w > 800) break; towers.push([x, w, h]); x += w + rnd(4, 18); }
      const CITY = spr(800, 200, c2 => { for (let i = 0; i < towers.length; i++) { const t = towers[i]; c2.fillStyle = lgrad(c2, t[0], 0, t[0] + t[1], 0, [[0, '#2A1A3E'], [.5, '#1E1230'], [1, '#160C24']]); c2.fillRect(t[0], 200 - t[2], t[1], t[2] + 4); c2.fillStyle = 'rgba(255,255,255,.08)'; c2.fillRect(t[0], 200 - t[2], t[1], 2); if (t[2] > 120 && t[1] > 30) { c2.fillStyle = '#160C24'; c2.fillRect(t[0] + t[1] / 2 - 1, 200 - t[2] - 16, 2, 16); } } });
      const CITYN = spr(800, 200, c2 => { for (let i = 0; i < towers.length; i++) { const t = towers[i]; for (let yy = 200 - t[2] + 8; yy < 196; yy += 11) for (let xx = t[0] + 5; xx < t[0] + t[1] - 5; xx += 9) { if (Math.random() < .55) { c2.fillStyle = Math.random() < .5 ? 'rgba(255,221,150,.85)' : 'rgba(255,190,110,.7)'; c2.fillRect(xx, yy, 4, 5); } } } });
      const HAZE = spr(W, 230, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, 230, [[0, 'rgba(169,205,242,0)'], [.35, 'rgba(169,205,242,.38)'], [1, 'rgba(190,220,248,.55)']]); c2.fillRect(0, 0, W, 230); });
      /* chão: relva com tufos, lancil e a avenida com traços (480 de largura = múltiplo de 60, desliza sem costura) */
      const GROUND = spr(480, H - GY, c2 => {
        const gh = H - GY;
        c2.fillStyle = lgrad(c2, 0, 0, 0, 14, [[0, '#5CC46A'], [1, '#2E7D3C']]); c2.fillRect(0, 0, 480, 14);
        c2.fillStyle = '#7BDB86'; for (let x = 0; x < 480; x += 12) { c2.beginPath(); c2.moveTo(x, 4); c2.lineTo(x + 4, 0); c2.lineTo(x + 8, 4); c2.closePath(); c2.fill(); }
        c2.fillStyle = 'rgba(0,0,0,.18)'; for (let x = 6; x < 480; x += 24) c2.fillRect(x, 8, 3, 4);
        c2.fillStyle = lgrad(c2, 0, 14, 0, 20, [[0, '#B8B2C8'], [1, '#6E6584']]); c2.fillRect(0, 14, 480, 6);
        c2.fillStyle = 'rgba(0,0,0,.25)'; for (let x = 0; x < 480; x += 30) c2.fillRect(x, 14, 2, 6);
        c2.fillStyle = lgrad(c2, 0, 20, 0, gh, [[0, '#2E2540'], [1, '#14101F']]); c2.fillRect(0, 20, 480, gh - 20);
        c2.fillStyle = 'rgba(255,214,10,.55)'; for (let x = 0; x < 480; x += 60) c2.fillRect(x + 8, 36, 30, 3);
        c2.fillStyle = 'rgba(255,255,255,.05)'; for (let i = 0; i < 50; i++) c2.fillRect(rnd(0, 480), rnd(22, gh), 2, 2);
      });
      const PBODY = spr(PW, PH, c2 => {
        c2.fillStyle = lgrad(c2, 0, 0, PW, 0, [[0, '#0A5F6C'], [.18, '#17A8AD'], [.42, '#39DDD0'], [.68, '#17A0A8'], [1, '#064A56']]); c2.fillRect(0, 0, PW, PH);
        c2.fillStyle = 'rgba(255,255,255,.22)'; c2.fillRect(7, 0, 5, PH); c2.fillStyle = 'rgba(0,0,0,.22)'; c2.fillRect(PW - 8, 0, 8, PH);
        c2.fillStyle = 'rgba(0,0,0,.09)'; for (let yy = 30; yy < PH; yy += 46) c2.fillRect(0, yy, PW, 3);
        c2.fillStyle = 'rgba(255,255,255,.07)'; for (let yy = 33; yy < PH; yy += 46) c2.fillRect(0, yy, PW, 2);
      });
      const capSpr = flip => spr(PW + 12, 24, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, 24, flip ? [[0, '#0F8A93'], [.5, '#2BD3C8'], [1, '#5CF2E2']] : [[0, '#5CF2E2'], [.5, '#2BD3C8'], [1, '#0F8A93']]); rr(c2, 0, 0, PW + 12, 24, 7); c2.fill(); c2.fillStyle = 'rgba(255,255,255,.5)'; c2.fillRect(6, flip ? 20 : 2, PW, 2); c2.fillStyle = 'rgba(0,0,0,.25)'; c2.fillRect(2, flip ? 1 : 21, PW + 8, 2); c2.fillStyle = 'rgba(255,255,255,.25)'; c2.fillRect(8, 4, 6, 16); });
      const CAPT = capSpr(false), CAPB = capSpr(true);
      const RING = spr(44, 88, c2 => { glow(c2, '#FFD60A', 12); c2.lineWidth = 5; c2.strokeStyle = lgrad(c2, 0, 0, 0, 88, [[0, '#FFF1A0'], [.5, '#FFD60A'], [1, '#E09A00']]); c2.beginPath(); c2.ellipse(22, 44, 10, 31, 0, 0, TAU); c2.stroke(); c2.stroke(); noGlow(c2); c2.lineWidth = 1.5; c2.strokeStyle = 'rgba(255,255,255,.7)'; c2.beginPath(); c2.ellipse(20, 42, 9, 29, 0, Math.PI * 1.05, Math.PI * 1.6); c2.stroke(); });
      /* o pássaro: 3 quadros de asa (cima, meio, baixo), corpo com volume, barriga, olho com brilho, bico, bochecha */
      const birdSpr = wing => spr(60, 48, c2 => {
        c2.translate(30, 24);
        c2.fillStyle = 'rgba(0,0,0,.18)'; c2.beginPath(); c2.ellipse(2, 15, 14, 4, 0, 0, TAU); c2.fill();
        c2.fillStyle = rgrad(c2, -6, -8, 2, 0, 0, 22, [[0, '#FFF6C8'], [.45, '#FFD60A'], [1, '#F08A00']]); c2.beginPath(); c2.ellipse(0, 0, 19, 15, 0, 0, TAU); c2.fill();
        c2.lineWidth = 1.5; c2.strokeStyle = 'rgba(120,60,0,.35)'; c2.stroke();
        c2.fillStyle = 'rgba(255,255,255,.35)'; c2.beginPath(); c2.ellipse(-4, -9, 9, 3.5, 0, 0, TAU); c2.fill();
        c2.fillStyle = '#FFF1C2'; c2.beginPath(); c2.ellipse(3, 6, 11, 6.5, 0, 0, TAU); c2.fill();
        c2.fillStyle = 'rgba(255,110,80,.35)'; c2.beginPath(); c2.arc(8, 3, 3.2, 0, TAU); c2.fill();
        c2.save(); c2.translate(-6, 2 + wing * 5); c2.rotate(-.25 + wing * .55); c2.fillStyle = lgrad(c2, -14, 0, 8, 0, [[0, '#fff'], [1, '#FFE8A3']]); c2.beginPath(); c2.ellipse(-2, 0, 14, 6, 0, 0, TAU); c2.fill(); c2.strokeStyle = 'rgba(120,60,0,.3)'; c2.lineWidth = 1.2; c2.stroke(); c2.restore();
        c2.fillStyle = '#fff'; c2.beginPath(); c2.arc(9, -6, 5.6, 0, TAU); c2.fill(); c2.fillStyle = '#1C1C1E'; c2.beginPath(); c2.arc(10.6, -6, 2.8, 0, TAU); c2.fill(); c2.fillStyle = '#fff'; c2.beginPath(); c2.arc(11.8, -7.4, 1, 0, TAU); c2.fill();
        c2.fillStyle = '#FF7A33'; c2.beginPath(); c2.moveTo(17, -2); c2.lineTo(29, 2); c2.lineTo(17, 6); c2.closePath(); c2.fill(); c2.fillStyle = '#E05A1A'; c2.beginPath(); c2.moveTo(17, 2.5); c2.lineTo(29, 2); c2.lineTo(17, 6); c2.closePath(); c2.fill();
      });
      const BIRD = [birdSpr(-1), birdSpr(0), birdSpr(1)];
      const MEDAL_COL = [['#E0A878', '#8A5A2B'], ['#F4F4FA', '#9A9AA6'], ['#FFE98A', '#C9930A'], ['#E6FAFF', '#7FB2C8']];
      const MEDALS = MEDAL_COL.map(cols => spr(76, 92, c2 => {
        c2.fillStyle = '#E53935'; c2.beginPath(); c2.moveTo(22, 0); c2.lineTo(38, 0); c2.lineTo(44, 34); c2.lineTo(26, 34); c2.closePath(); c2.fill();
        c2.fillStyle = '#1E62D0'; c2.beginPath(); c2.moveTo(38, 0); c2.lineTo(54, 0); c2.lineTo(50, 34); c2.lineTo(32, 34); c2.closePath(); c2.fill();
        glow(c2, 'rgba(0,0,0,.45)', 8); c2.fillStyle = rgrad(c2, 30, 48, 4, 38, 58, 30, [[0, cols[0]], [.7, cols[1]], [1, cols[1]]]); c2.beginPath(); c2.arc(38, 58, 28, 0, TAU); c2.fill(); noGlow(c2);
        c2.lineWidth = 3; c2.strokeStyle = 'rgba(255,255,255,.55)'; c2.beginPath(); c2.arc(38, 58, 22, 0, TAU); c2.stroke();
        c2.fillStyle = 'rgba(255,255,255,.9)'; c2.beginPath(); for (let i = 0; i < 10; i++) { const a = -HPI + i * Math.PI / 5, r = i % 2 ? 6 : 13; c2.lineTo(38 + Math.cos(a) * r, 58 + Math.sin(a) * r); } c2.closePath(); c2.fill();
        c2.strokeStyle = 'rgba(255,255,255,.75)'; c2.lineWidth = 2.5; c2.beginPath(); c2.arc(38, 58, 25, Math.PI * 1.1, Math.PI * 1.55); c2.stroke();
      }));
      const medalSvg = m => `<svg viewBox="0 0 24 24" aria-hidden="true"><defs><linearGradient id="gglM${m}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${MEDAL_COL[m][0]}"/><stop offset="1" stop-color="${MEDAL_COL[m][1]}"/></linearGradient></defs><path d="M8 2h8l-2 6h-4z" fill="#E53935"/><circle cx="12" cy="14" r="7.5" fill="url(#gglM${m})" stroke="rgba(0,0,0,.3)"/><path d="M12 9.5l1.4 2.9 3.1.4-2.3 2.2.6 3.1L12 16.6 9.2 18.1l.6-3.1-2.3-2.2 3.1-.4z" fill="rgba(255,255,255,.9)"/></svg>`;
      const RING_SVG = '<svg viewBox="0 0 24 24" aria-hidden="true"><ellipse cx="12" cy="12" rx="4" ry="9" fill="none" stroke="#FFD60A" stroke-width="3"/></svg>';

      /* ----- regras por modo ----- */
      const hard = () => mode === 'dificil';
      const speed = () => Math.min(hard() ? 340 : 300, (hard() ? 190 : 168) + score * (hard() ? 3 : 2.6));
      const gapH = () => Math.max(hard() ? 108 : 130, (hard() ? 152 : 182) - score * 1.4);
      const gapX = () => (hard() ? 212 : 232);
      const setPillar = (p, x) => { const gh = gapH(); const cy = clamp(lastGap + rnd(-150, 150), 56 + gh / 2, GY - 46 - gh / 2); lastGap = cy; p.x = x; p.cy = cy; p.gh = gh; p.passed = false; p.ring = Math.random() < .4 ? 1 : 0; };
      let watchRecord = () => {};
      let midRing = null, midMedal = null;
      const midPlay = () => {
        X.A.setMid(`<span class="ga-mid">${cap('ggl-ring', RING_SVG)}<span class="ga-cap ggl-medal off"><i></i><em></em></span></span>`);
        midRing = X.A.el.mid.querySelector('.ggl-ring b'); midMedal = X.A.el.mid.querySelector('.ggl-medal');
        if (midRing) midRing.textContent = String(rings);
        showMedal();
      };
      const showMedal = () => { if (!midMedal) return; if (medal < 0) { midMedal.classList.add('off'); return; } midMedal.classList.remove('off'); midMedal.querySelector('i').innerHTML = medalSvg(medal); midMedal.querySelector('em').textContent = ['Bronze', 'Prata', 'Ouro', 'Platina'][medal]; };
      const reset = () => {
        y = H / 2 - 70; vy = 0; wingT = 9; dist = 0; score = 0; rings = 0; passed = 0; hover = false; bob = 0; lastGap = H / 2 - 40; medal = -1; thud = false; ang = 0; spin = 0; lvl = 0; onRecord = false;
        ph = mode === 'noite' ? 2 : 1;
        for (let i = 0; i < NP; i++) setPillar(pillars[i], W + 140 + i * gapX());
        watchRecord = recordWatch(X, board());
        X.A.setScore(0); X.A.setMid(hint('Toca para bater as asas'));
      };
      const start = () => { reset(); X.begin('Planar', mode === 'noite' ? 'Voo noturno: toca para bater as asas' : 'Toca para bater as asas'); };
      const setMode = m => { if (!MODES.some(x => x.v === m) || m === mode) return; mode = m; Arcade.setOpt('glide:mode', m); X.A.setId(board()); if (X.A.ended) X.A.restart(); else start(); };
      const flap = first => {
        if (!X.alive()) return;
        if (hover) { hover = false; midPlay(); }
        vy = -455; wingT = 0;
        if (!first) { X.snd(Math.random() < .5 ? 'jump' : 'whoosh', 60); X.fx.burst(BX - 14, y + 10, 'rgba(255,255,255,.7)', 3, 80, .3, 3); }
      };
      const stats = () => [{ label: 'Colunas', value: String(passed) }, { label: 'Anéis', value: String(rings) }, { label: 'Distância', value: Math.round(dist / 10) + ' m' }, { label: 'Medalha', value: medal >= 0 ? ['Bronze', 'Prata', 'Ouro', 'Platina'][medal] : 'Nenhuma' }];
      const crash = (why, pillar) => {
        if (!X.alive()) return;
        X.haptic('heavy'); X.snd('crash', 0);
        X.fx.burst(BX, y, '#FFD60A', 18, 260, .9, 5, 600); X.fx.burst(BX, y, '#FFF1C2', 10, 200, .7, 3.5, 600);
        if (pillar) { X.hitStop(.07); X.flashW(.7); X.shake.hit(9); vy = -220; spin = 9; } else { X.flashW(.45); X.shake.hit(7); thud = true; spin = 0; }
        if (medalFor(score) > medal) { medal = medalFor(score); showMedal(); }
        const m = medal >= 0 ? MEDAL_NAME[medal] : '';
        X.die({ title: why, sub: `${score} pontos` + (m ? ' · ' + m : ''), score, win: false, board: board(), stats: stats() }, pillar ? 1.6 : 1.2);
      };
      const award = () => {
        const m = medalFor(score);
        if (m > medal) { medal = m; X.flash(MEDAL_NAME[m], 'big'); X.snd('level', 0); X.celebrate('level'); showMedal(); }
        else if (score % 10 === 0) { lvl = score / 10 + 1; X.flash('Nível ' + lvl, 'big'); X.snd('level', 0); }
        if (mode === 'noite' && score >= 20) safe(() => Arcade.flag && Arcade.flag('glideNight'));
        watchRecord(score);
      };

      function tick(dt) {
        X.fx.step(dt); wingT += dt;
        const tgt = (mode === 'noite' ? 2 : 1) + score / 10; ph += (tgt - ph) * (1 - Math.exp(-1.1 * dt));
        if (X.dying) {
          vy = Math.min(760, vy + 1700 * dt); y += vy * dt;
          if (y + R > GY) { y = GY - R; if (!thud) { thud = true; X.shake.hit(7); X.snd('hit', 0); X.fx.burst(BX, GY - 4, '#5A4A7A', 10, 120, .5, 3, 300, 2); } spin = 0; }
          ang += spin * dt; if (!spin) ang += (HPI - ang) * Math.min(1, 10 * dt);
          draw(); return;
        }
        if (hover) { bob += dt; y = hoverY + Math.sin(bob * 3) * 6; draw(); return; }
        vy = Math.min(760, vy + 1700 * dt); y += vy * dt;
        if (y < R) { y = R; vy = Math.max(0, vy); }
        if (y + R > GY) { y = GY - R; crash('Bateste no chão', false); draw(); return; }
        const v = speed() * dt; dist += v;
        for (let i = 0; i < NP; i++) {
          const p = pillars[i]; p.x -= v;
          if (!p.passed && p.x + PW < BX - R) { p.passed = true; score++; passed++; X.A.setScore(score); X.snd('score', 0); award(); }
          if (p.ring === 1 && Math.abs(p.x + PW / 2 - BX) < 14 && Math.abs(y - p.cy) < 30) {
            p.ring = 2; score += 2; rings++; X.A.setScore(score); X.snd('coin', 0); X.haptic('light'); if (midRing) midRing.textContent = String(rings);
            X.fx.burst(p.x + PW / 2, p.cy, '#FFD60A', 14, 220, .6, 4); X.fx.burst(p.x + PW / 2, p.cy, '#fff', 5, 160, .4, 2.5); X.fx.text(p.x + PW / 2, p.cy - 44, '+2', '#FFD60A', 22, .9);
            watchRecord(score);
          }
          if (pillarHit(y, R, BX, p, PW)) { crash('Bateste numa coluna', true); draw(); return; }
        }
        /* a coluna mais à esquerda que já saiu volta a entrar à direita (pool fixo, sem shift/push) */
        let left = 0, right = 0; for (let i = 1; i < NP; i++) { if (pillars[i].x < pillars[left].x) left = i; if (pillars[i].x > pillars[right].x) right = i; }
        if (pillars[left].x + PW < -20) setPillar(pillars[left], pillars[right].x + gapX());
        draw();
      }
      function draw() {
        const pm = ((ph % 4) + 4) % 4, si = pm | 0, sf = pm - si, nf = Math.max(0, 1 - Math.abs(pm - 2));
        c.drawImage(SKY[si & 3], 0, 0);
        if (sf > .01) { c.globalAlpha = sf; c.drawImage(SKY[(si + 1) & 3], 0, 0); c.globalAlpha = 1; }
        /* sol e lua pela hora do dia */
        let sx = 300, sy = 110, ma = 0;
        if (pm < 1) sy = 110 + 326 * pm;
        else if (pm < 2) { sy = 436 + 220 * (pm - 1); ma = pm - 1; }
        else if (pm < 3) { const k = Math.max(0, pm - 2.5) * 2; sx = 100; sy = 656 - 506 * k; ma = 1 - k; }
        else { const k = pm - 3; sx = 100 + 200 * k; sy = 150 - 40 * k; }
        if (sy < GY + 30) c.drawImage(SUN, sx - 100, sy - 100);
        if (ma > .02) { c.globalAlpha = ma; c.drawImage(MOON, 20, 60); c.globalAlpha = 1; }
        let o = (dist * .08) % 800; c.drawImage(CLOUDS, -o, 20); c.drawImage(CLOUDS, 800 - o, 20);
        o = (dist * .2) % 800; c.drawImage(HILLS, -o, GY - 160); c.drawImage(HILLS, 800 - o, GY - 160);
        o = (dist * .45) % 800; c.drawImage(CITY, -o, GY - 200); c.drawImage(CITY, 800 - o, GY - 200);
        /* de dia, a perspetiva aérea: a cidade ao longe fica azulada */
        const df = Math.max(0, 1 - Math.min(pm, 4 - pm)); if (df > .02) { c.globalAlpha = df; c.drawImage(HAZE, 0, GY - 230); c.globalAlpha = 1; }
        if (nf > .02) { c.globalAlpha = nf; c.drawImage(CITYN, -o, GY - 200); c.drawImage(CITYN, 800 - o, GY - 200); c.globalAlpha = nf * .32; c.fillStyle = '#070A2A'; c.fillRect(0, 0, W, GY); c.globalAlpha = 1; }
        for (let i = 0; i < NP; i++) {
          const p = pillars[i]; if (p.x > W || p.x + PW < -8) continue;
          const top = p.cy - p.gh / 2, bot = p.cy + p.gh / 2;
          c.drawImage(PBODY, p.x, top - PH); c.drawImage(PBODY, p.x, bot);
          c.drawImage(CAPT, p.x - 6, top - 24); c.drawImage(CAPB, p.x - 6, bot);
          if (p.ring === 1) c.drawImage(RING, p.x + PW / 2 - 22, p.cy - 44);
        }
        if (nf > .02) { c.globalAlpha = nf * .3; c.fillStyle = '#070A2A'; c.fillRect(0, 0, W, GY); c.globalAlpha = 1; }
        o = dist % 60; c.drawImage(GROUND, -o, GY); c.drawImage(GROUND, 480 - o, GY);
        /* o pássaro: rotação pela velocidade (ou a cair a rodar), quadro da asa pelo tempo desde a batida */
        const a = X.dying ? ang : hover ? Math.sin(bob * 3) * .08 : clamp(vy / 700, -.45, 1.0) * (X.running ? 1 : .2);
        const fr = X.dying ? 1 : hover ? ((bob * 6) | 0) % 3 : wingT < .09 ? 2 : wingT < .2 ? 0 : 1;
        const cs = Math.cos(a), sn = Math.sin(a);
        c.setTransform(cs, sn, -sn, cs, BX, y); c.drawImage(BIRD[fr], -30, -24); c.setTransform(1, 0, 0, 1, 0, 0);
        X.fx.draw(c);
        if (X.running && !X.dying) { const s = String(score); c.font = `800 52px ${FONT}`; c.textAlign = 'center'; c.textBaseline = 'middle'; c.lineJoin = 'round'; c.lineWidth = 7; c.strokeStyle = 'rgba(30,10,40,.45)'; c.strokeText(s, W / 2, 58); c.fillStyle = '#fff'; c.fillText(s, W / 2, 56); }
        if (X.dying && medal >= 0) { c.drawImage(MEDALS[medal], W / 2 - 38, 120); }
        X.post(c);
      }
      function key(e) {
        if (e.type === 'keyup') return;
        const k = e.key;
        if (k === ' ' || k === 'ArrowUp' || k === 'w' || k === 'W' || k === 'Enter' || k === 'Spacebar') { e.preventDefault(); if (!e.repeat) flap(); }
      }
      pointer(X, { down: () => flap() });
      X.A.el.ctl.innerHTML = `<div class="gm-row"><div class="gb lbl ggl-flap">${g('chevU')}Bater asas</div></div>`;
      X.A.el.ctl.querySelector('.ggl-flap').addEventListener('pointerdown', () => flap());
      safe(() => X.A.options([{ key: 'mode', label: 'Modo', values: MODES, cur: mode, onChange: v => setMode(v) }]));
      start();
      return X.api;
    },
  });

  /* =====================================================================
     2. ROCHAS (rocks): néon de arcada moderna; nave com chama, rochas com crateras, discos voadores,
        cadeia de multiplicador, bónus em cápsula, hiperespaço, estrelas em parallax
     ===================================================================== */
  Icons.app.rocks = () => Icons.SVG(Icons.G('gRk', '#8C6BFF', '#5E5CE6', '#1A1258') + Icons.GL(
    `<circle cx="22" cy="24" r="1.6" fill="#fff" opacity=".7"/><circle cx="80" cy="18" r="1.2" fill="#fff" opacity=".6"/><circle cx="70" cy="84" r="1.4" fill="#fff" opacity=".5"/><circle cx="14" cy="50" r="1" fill="#fff" opacity=".5"/>` +
    `<path d="M58 28l13-5 11 6 3 12-7 10-13 2-8-9z" fill="#2C2550" stroke="#D6D5FF" stroke-width="3" stroke-linejoin="round"/><ellipse cx="66" cy="40" rx="4" ry="3" fill="#0F0C2A" opacity=".8"/><ellipse cx="76" cy="34" rx="2.5" ry="2" fill="#0F0C2A" opacity=".8"/>` +
    `<path d="M14 64l8-6 9 2 2 8-6 6-9-1z" fill="#2C2550" stroke="#D6D5FF" stroke-width="2.6" stroke-linejoin="round"/>` +
    `<path d="M26 52l28-11-11 26-5-10z" fill="#fff"/><path d="M26 52l12 5-4 7z" fill="#FF9F0A"/><circle cx="52" cy="66" r="2.2" fill="#fff"/><circle cx="58" cy="74" r="1.6" fill="#fff" opacity=".7"/>`));

  Arcade.game('rocks', {
    name: 'Rochas', color: '#5E5CE6', kind: 'action', tags: ['Arcada', 'Néon'],
    desc: 'Roda a nave, acelera e desfaz as rochas antes que te apanhem. Vagas sem fim, discos voadores, cadeia de multiplicador, bónus de escudo, tiro triplo e tiro rápido, hiperespaço para fugir e uma nave extra a cada 10 000 pontos.',
    howto: { goal: 'Desfaz todas as rochas de cada vaga sem perderes as três naves.', steps: ['As rochas grandes partem-se em médias e as médias em pequenas', 'Acertos seguidos sobem a cadeia: x2, x3, x4, x5', 'Apanha as cápsulas: escudo, tiro triplo e tiro rápido', 'Em apuros, o hiperespaço salta-te para outro sítio'], controls: [{ icon: 'joystick', label: 'Joystick roda a nave; a fundo acelera' }, { icon: 'bolt', label: 'Botões: disparar, acelerar e hiperespaço' }, { icon: 'gamepad', label: 'Setas, Espaço e S no teclado' }] },
    cover: () => `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="crkS" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#060520"/><stop offset="1" stop-color="#170F40"/></linearGradient><radialGradient id="crkN" cx=".3" cy=".4" r=".5"><stop offset="0" stop-color="#5E5CE6" stop-opacity=".35"/><stop offset="1" stop-color="#5E5CE6" stop-opacity="0"/></radialGradient><radialGradient id="crkN2" cx=".8" cy=".7" r=".4"><stop offset="0" stop-color="#FF375F" stop-opacity=".25"/><stop offset="1" stop-color="#FF375F" stop-opacity="0"/></radialGradient><radialGradient id="crkR" cx=".35" cy=".3" r=".8"><stop offset="0" stop-color="#9C9CC4"/><stop offset=".5" stop-color="#55557A"/><stop offset="1" stop-color="#1C1C32"/></radialGradient><linearGradient id="crkH" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#fff"/><stop offset=".5" stop-color="#A7A6FF"/><stop offset="1" stop-color="#4E4BD6"/></linearGradient></defs>` +
      `<rect width="400" height="200" fill="url(#crkS)"/><rect width="400" height="200" fill="url(#crkN)"/><rect width="400" height="200" fill="url(#crkN2)"/>` +
      `<g fill="#fff"><circle cx="30" cy="30" r="1.4"/><circle cx="90" cy="160" r="1"/><circle cx="150" cy="40" r="1.2"/><circle cx="240" cy="20" r="1"/><circle cx="330" cy="60" r="1.6"/><circle cx="370" cy="150" r="1.1"/><circle cx="200" cy="180" r="1"/><circle cx="60" cy="110" r=".9"/><circle cx="300" cy="110" r="1.3"/></g>` +
      `<path d="M286 44l34-12 30 14 8 32-18 26-36 6-24-22z" fill="url(#crkR)" stroke="#D6D5FF" stroke-width="3" stroke-linejoin="round"/><ellipse cx="312" cy="70" rx="10" ry="7" fill="#0F0C2A" opacity=".55"/><ellipse cx="335" cy="92" rx="6" ry="4.5" fill="#0F0C2A" opacity=".55"/><ellipse cx="300" cy="96" rx="5" ry="4" fill="#0F0C2A" opacity=".5"/>` +
      `<path d="M60 150l18-9 16 3 4 13-9 10-16 1-11-8z" fill="url(#crkR)" stroke="#D6D5FF" stroke-width="2.4" stroke-linejoin="round"/>` +
      `<g transform="translate(150 110) rotate(-20)"><path d="M-36 0l-16 6 0-12z" fill="#FFB020"/><path d="M-36 0l-10 3 0-6z" fill="#FFF3B0"/><path d="M34 0L-22 -22 -12 0 -22 22z" fill="url(#crkH)" stroke="#fff" stroke-width="2" stroke-linejoin="round"/><ellipse cx="8" cy="0" rx="8" ry="4.5" fill="#DFF8FF"/></g>` +
      `<g fill="#fff"><circle cx="215" cy="88" r="4"/><circle cx="240" cy="79" r="4"/><circle cx="265" cy="70" r="4"/></g><g fill="#B8B8FF" opacity=".5"><circle cx="215" cy="88" r="8"/><circle cx="240" cy="79" r="8"/><circle cx="265" cy="70" r="8"/></g></svg>`,
    build(win) {
      const W = 400, H = 560, SIZE = [0, 11, 20, 34], PTS = [0, 100, 50, 20];
      const RMAX = 64, SMAX = 16, UMAX = 12, FMAX = 2, CMAX = 4, XMAX = 8;
      const rocks = mk(RMAX, () => ({ x: 0, y: 0, vx: 0, vy: 0, size: 3, r: 34, rot: 0, spin: 0, v: 0 })); let nr = 0;
      const shots = mk(SMAX, () => ({ x: 0, y: 0, vx: 0, vy: 0, life: 0, px: 0, py: 0, qx: 0, qy: 0 })); let ns = 0;
      const ushots = mk(UMAX, () => ({ x: 0, y: 0, vx: 0, vy: 0, life: 0 })); let nu = 0;
      const ufos = mk(FMAX, () => ({ x: 0, y: 0, y0: 0, vx: 0, t: 0, small: false, r: 14, fire: 0 })); let nf = 0;
      const caps = mk(CMAX, () => ({ x: 0, y: 0, vx: 0, vy: 0, kind: 0, life: 0, t: 0 })); let nc = 0;
      const booms = mk(XMAX, () => ({ x: 0, y: 0, t: 0, max: .45, size: 60 })); let nb = 0;
      const ship = { x: W / 2, y: H / 2, vx: 0, vy: 0, a: -HPI, alive: true, shield: 0, respawn: 0, thrust: false };
      let score, lives, wave, waveT, nextLife, ufoT, fireT, stick = null, fireHeld = false, thrustHeld = false;
      let chain, mult, bestChain, destroyed, ufosDown, miss, hyperCd, hyperT, bonusKind, bonusT, bonusShown, flameT, pox, poy, watchRecord = () => {};
      const X = host(win, {
        id: 'rocks', name: 'Rochas', color: '#5E5CE6', W, H, particles: 220,
        restart: () => start(), tick, draw, key,
        onStart: () => { nr = 0; ship.shield = 1.5; wave = 0; startWave(); },
        onResume: () => { if (ship.alive) ship.shield = Math.max(ship.shield, 1.2); },
        dbg: { wave: n => { wave = n - 1; nr = 0; startWave(); }, bonus: k => { bonusKind = k; bonusT = 10; hudBonus(); }, shield: () => { ship.shield = 8; }, lives: n => { lives = n; hud(); }, kill: () => { ship.shield = 0; kill(); }, hyper: () => hyper(), ahead: () => { addRock(ship.x + Math.cos(ship.a) * 120, ship.y + Math.sin(ship.a) * 120, 3, ship.a + Math.PI); rocks[nr - 1].vx *= .2; rocks[nr - 1].vy *= .2; }, state: () => ({ score, lives, wave, nr, ns, chain, mult, bonusKind, alive: ship.alive }) },
      });
      const c = X.ctx;

      /* ----- arte pré-desenhada ----- */
      const BG = spr(W, H, c2 => {
        c2.fillStyle = lgrad(c2, 0, 0, 0, H, [[0, '#040418'], [.5, '#0B0A2E'], [1, '#150D3A']]); c2.fillRect(0, 0, W, H);
        const neb = (x, y, r, rgb, a) => { c2.fillStyle = rgrad(c2, x, y, 0, x, y, r, [[0, `rgba(${rgb},${a})`], [1, `rgba(${rgb},0)`]]); c2.fillRect(x - r, y - r, r * 2, r * 2); };
        neb(90, 120, 190, '94,92,230', .24); neb(330, 420, 220, '255,55,95', .14); neb(300, 90, 150, '90,200,250', .1); neb(120, 470, 170, '140,80,255', .13);
        c2.fillStyle = rgrad(c2, W / 2, H / 2, H * .35, W / 2, H / 2, H * .8, [[0, 'rgba(0,0,0,0)'], [1, 'rgba(0,0,0,.55)']]); c2.fillRect(0, 0, W, H);
      });
      const starLayer = (n, s0, s1, a0, a1) => spr(W, H, c2 => { for (let i = 0; i < n; i++) { const s = rnd(s0, s1); c2.globalAlpha = rnd(a0, a1); c2.fillStyle = Math.random() < .15 ? '#BFD6FF' : Math.random() < .1 ? '#FFD9C0' : '#fff'; c2.fillRect(rnd(0, W), rnd(0, H), s, s); } c2.globalAlpha = 1; });
      const STARS1 = starLayer(90, .8, 1.6, .2, .6), STARS2 = starLayer(36, 1.4, 2.6, .5, 1);
      const SHIP = spr(60, 60, c2 => {
        c2.translate(30, 30);
        glow(c2, '#8C8BFF', 14); c2.fillStyle = lgrad(c2, -14, -14, 22, 10, [[0, '#FFFFFF'], [.4, '#A7A6FF'], [1, '#4E4BD6']]);
        c2.beginPath(); c2.moveTo(22, 0); c2.lineTo(-14, -14); c2.lineTo(-8, 0); c2.lineTo(-14, 14); c2.closePath(); c2.fill(); c2.fill(); noGlow(c2);
        c2.fillStyle = 'rgba(0,0,0,.28)'; c2.beginPath(); c2.moveTo(22, 0); c2.lineTo(-14, 14); c2.lineTo(-8, 0); c2.closePath(); c2.fill();
        c2.lineJoin = 'round'; c2.lineWidth = 1.6; c2.strokeStyle = 'rgba(255,255,255,.95)'; c2.beginPath(); c2.moveTo(22, 0); c2.lineTo(-14, -14); c2.lineTo(-8, 0); c2.lineTo(-14, 14); c2.closePath(); c2.stroke();
        glow(c2, '#CFF4FF', 8); c2.fillStyle = '#DFF8FF'; c2.beginPath(); c2.ellipse(5, 0, 5.5, 3, 0, 0, TAU); c2.fill(); noGlow(c2);
        c2.fillStyle = '#FF9F0A'; c2.fillRect(-13, -3, 4, 6);
      });
      const FLAME = mk(3, i => spr(32, 20, c2 => { const L = 16 + i * 7; glow(c2, '#FF9F0A', 10); c2.fillStyle = lgrad(c2, 32, 0, 32 - L, 0, [[0, '#FFF3B0'], [.4, '#FFB020'], [1, 'rgba(255,90,20,0)']]); c2.beginPath(); c2.moveTo(32, 4); c2.lineTo(32 - L, 10); c2.lineTo(32, 16); c2.closePath(); c2.fill(); noGlow(c2); c2.fillStyle = '#FFF8D0'; c2.beginPath(); c2.moveTo(32, 7); c2.lineTo(32 - L * .5, 10); c2.lineTo(32, 13); c2.closePath(); c2.fill(); }));
      const SHIELD = ringSpr(33, '#7FE7FF', 2.5, 10), SHW = SHIELD.width / 2, SK = 1.3;
      const BUL = glowDot(6, '#B8B8FF'), UBUL = glowDot(5, '#FF375F', '#FFD0DA'), WARP = glowDot(28, '#5AC8FA');
      const BOOM = ringSpr(28, '#FFFFFF', 3, 8);
      const rockSpr = r => { const m = 12, S = (r + m) * 2, cx = S / 2, cy = S / 2, n = 11, V = []; for (let i = 0; i < n; i++) V.push(rnd(.8, 1.12)); return spr(S, S, c2 => {
        const path = () => { c2.beginPath(); for (let i = 0; i < n; i++) { const a = i / n * TAU, rad = r * V[i]; if (i) c2.lineTo(cx + Math.cos(a) * rad, cy + Math.sin(a) * rad); else c2.moveTo(cx + Math.cos(a) * rad, cy + Math.sin(a) * rad); } c2.closePath(); };
        path(); glow(c2, '#8C8BFF', 12); c2.fillStyle = rgrad(c2, cx - r * .45, cy - r * .5, r * .1, cx, cy, r * 1.15, [[0, '#9C9CC4'], [.45, '#55557A'], [1, '#1C1C32']]); c2.fill(); c2.fill(); noGlow(c2);
        const ncr = 2 + (r > 15 ? 1 : 0) + (r > 25 ? 2 : 0);
        for (let i = 0; i < ncr; i++) { const a = rnd(0, TAU), d = rnd(.1, .55) * r, rx = rnd(.12, .26) * r, ry = rx * rnd(.6, .9), x = cx + Math.cos(a) * d, yy = cy + Math.sin(a) * d; c2.fillStyle = 'rgba(10,10,30,.5)'; c2.beginPath(); c2.ellipse(x, yy, rx, ry, 0, 0, TAU); c2.fill(); c2.strokeStyle = 'rgba(255,255,255,.22)'; c2.lineWidth = 1.2; c2.beginPath(); c2.ellipse(x, yy, rx, ry, 0, Math.PI * .9, Math.PI * 1.7); c2.stroke(); }
        path(); c2.lineJoin = 'round'; c2.lineWidth = r > 15 ? 2.2 : 1.6; c2.strokeStyle = '#D6D5FF'; glow(c2, '#8C8BFF', 8); c2.stroke(); noGlow(c2);
        c2.strokeStyle = 'rgba(255,255,255,.35)'; c2.lineWidth = 2; c2.beginPath(); c2.arc(cx, cy, r * .78, Math.PI * 1.05, Math.PI * 1.55); c2.stroke();
      }); };
      const ROCK = [null, mk(4, () => rockSpr(SIZE[1])), mk(4, () => rockSpr(SIZE[2])), mk(4, () => rockSpr(SIZE[3]))];
      const UFO = mk(2, f => spr(64, 32, c2 => {
        glow(c2, '#FF375F', 10); c2.fillStyle = lgrad(c2, 0, 10, 0, 29, [[0, '#FF7FA3'], [.5, '#E0245E'], [1, '#8A0F38']]); c2.beginPath(); c2.ellipse(32, 20, 30, 9, 0, 0, TAU); c2.fill(); noGlow(c2);
        c2.strokeStyle = 'rgba(255,255,255,.7)'; c2.lineWidth = 1.5; c2.stroke();
        c2.fillStyle = lgrad(c2, 0, 2, 0, 18, [[0, '#FFFFFF'], [1, 'rgba(200,230,255,.55)']]); c2.beginPath(); c2.ellipse(32, 16, 13, 11, 0, Math.PI, TAU); c2.fill();
        for (let i = 0; i < 5; i++) { const on = (i + f) % 2 === 0; c2.fillStyle = on ? '#FFE066' : '#4BE1FF'; glow(c2, on ? '#FFE066' : '#4BE1FF', 6); c2.beginPath(); c2.arc(10 + i * 11, 21, 2.2, 0, TAU); c2.fill(); } noGlow(c2);
      }));
      const CAPCOL = ['#5AC8FA', '#BF5AF2', '#FF9F0A'], CAPNAME = ['Escudo', 'Tiro triplo', 'Tiro rápido'];
      const CAP = mk(3, k => spr(40, 40, c2 => { const col = CAPCOL[k]; glow(c2, col, 12); c2.fillStyle = lgrad(c2, 0, 0, 0, 40, [[0, hexA(col, .95)], [1, hexA(col, .6)]]); rr(c2, 8, 8, 24, 24, 8); c2.fill(); c2.fill(); noGlow(c2); c2.strokeStyle = 'rgba(255,255,255,.85)'; c2.lineWidth = 1.5; c2.stroke(); c2.strokeStyle = '#fff'; c2.lineWidth = 2.2; c2.lineCap = 'round';
        if (k === 0) { c2.beginPath(); c2.arc(20, 20, 5.5, 0, TAU); c2.stroke(); }
        else if (k === 1) { for (let i = -1; i <= 1; i++) { c2.beginPath(); c2.moveTo(20 + i * 5, 25); c2.lineTo(20 + i * 7, 15); c2.stroke(); } }
        else { c2.beginPath(); c2.moveTo(14, 15); c2.lineTo(19, 20); c2.lineTo(14, 25); c2.moveTo(21, 15); c2.lineTo(26, 20); c2.lineTo(21, 25); c2.stroke(); }
      }));

      /* ----- HUD (meio): vidas, vaga, cadeia, bónus com tempo ----- */
      let midHearts = null, midWave = null, midMult = null, midBonus = null, midBonusI = null, midBonusT = null, hyperBtn = null;
      const buildMid = () => {
        X.A.setMid(`<span class="ga-mid"><span class="grk-lives"></span>${cap('grk-wave', g('flag', 16))}<span class="ga-cap grk-mult off"><b>x1</b></span><span class="ga-cap grk-bonus off"><i></i><b>0</b></span></span>`);
        const m = X.A.el.mid; midHearts = m.querySelector('.grk-lives'); midWave = m.querySelector('.grk-wave b'); midMult = m.querySelector('.grk-mult'); midBonus = m.querySelector('.grk-bonus'); midBonusI = midBonus.querySelector('i'); midBonusT = midBonus.querySelector('b');
        hud(); hudBonus();
      };
      const hud = () => { if (!midHearts) return; midHearts.innerHTML = X.A.hearts(lives, Math.max(3, lives)); midWave.textContent = String(Math.max(1, wave)); if (mult > 1) { midMult.classList.remove('off'); midMult.querySelector('b').textContent = 'x' + mult; } else midMult.classList.add('off'); };
      const hudBonus = () => { if (!midBonus) return; if (!bonusKind) { midBonus.classList.add('off'); return; } midBonus.classList.remove('off'); midBonusI.innerHTML = bonusKind === 1 ? g('layers', 16) : g('bolt', 16); midBonusT.textContent = String(Math.max(0, Math.ceil(bonusT))); };
      const setHyperBtn = () => { if (hyperBtn) hyperBtn.classList.toggle('off', hyperCd > 0); };

      /* ----- mundo ----- */
      const wrapD = (d, L) => (d > L / 2 ? d - L : d < -L / 2 ? d + L : d);
      const dist = (ax, ay, bx, by) => hyp(wrapD(bx - ax, W), wrapD(by - ay, H));
      const wrap = o => { if (o.x < 0) o.x += W; else if (o.x >= W) o.x -= W; if (o.y < 0) o.y += H; else if (o.y >= H) o.y -= H; };
      const addRock = (x, y, size, ang) => { if (nr >= RMAX) return; const r = rocks[nr++]; const sp = (size === 3 ? rnd(28, 52) : size === 2 ? rnd(50, 80) : rnd(75, 115)) * (1 + Math.min(10, wave) * .05); const a = ang == null ? rnd(0, TAU) : ang; r.x = x; r.y = y; r.vx = Math.cos(a) * sp; r.vy = Math.sin(a) * sp; r.size = size; r.r = SIZE[size]; r.rot = rnd(0, TAU); r.spin = rnd(-1.2, 1.2); r.v = (Math.random() * 4) | 0; };
      const rmRock = i => { nr--; if (i !== nr) { const t = rocks[i]; rocks[i] = rocks[nr]; rocks[nr] = t; } };
      const rmShot = i => { ns--; if (i !== ns) { const t = shots[i]; shots[i] = shots[ns]; shots[ns] = t; } };
      const rmUshot = i => { nu--; if (i !== nu) { const t = ushots[i]; ushots[i] = ushots[nu]; ushots[nu] = t; } };
      const rmUfo = i => { nf--; if (i !== nf) { const t = ufos[i]; ufos[i] = ufos[nf]; ufos[nf] = t; } };
      const rmCap = i => { nc--; if (i !== nc) { const t = caps[i]; caps[i] = caps[nc]; caps[nc] = t; } };
      const boom = (x, y, size) => { const b = nb < XMAX ? booms[nb++] : booms[0]; b.x = x; b.y = y; b.t = 0; b.max = .3 + size / 400; b.size = size; };
      const startWave = () => {
        wave++;
        const n = Math.min(3 + wave, 9);
        for (let i = 0; i < n; i++) {
          let x = 0, y = 0;
          for (let k = 0; k < 24; k++) { const e = (Math.random() * 4) | 0; x = e < 2 ? rnd(0, W) : (e === 2 ? 0 : W - 1); y = e < 2 ? (e === 0 ? 0 : H - 1) : rnd(0, H); if (dist(x, y, ship.x, ship.y) > 170) break; }
          addRock(x, y, 3);
        }
        hud();
        safe(() => Arcade.maxStat && Arcade.maxStat('rocksWave', wave));
        if (wave > 1) { X.flash('Vaga ' + wave, 'big'); X.snd('level', 0); X.celebrate('level'); }
      };
      const reset = () => {
        score = 0; lives = 3; wave = 0; waveT = 0; nextLife = 10000; ufoT = rnd(14, 22); fireT = 0; nr = 0; ns = 0; nf = 0; nu = 0; nc = 0; nb = 0; fireHeld = false; thrustHeld = false; stick = null;
        chain = 0; mult = 1; bestChain = 0; destroyed = 0; ufosDown = 0; miss = 0; hyperCd = 0; hyperT = 0; bonusKind = 0; bonusT = 0; bonusShown = -1; flameT = 0; pox = 0; poy = 0;
        Object.assign(ship, { x: W / 2, y: H / 2, vx: 0, vy: 0, a: -HPI, alive: true, shield: 0, respawn: 0, thrust: false });
        for (let i = 0; i < 4; i++) addRock(rnd(0, W), i % 2 ? rnd(0, 90) : rnd(H - 90, H), 3 - (i % 2));
        watchRecord = recordWatch(X, 'rocks');
        X.A.setScore(0); buildMid(); setHyperBtn();
      };
      const start = () => { reset(); X.begin('Rochas', 'Joystick para rodar, botões para disparar e acelerar', true); };
      const stats = () => [{ label: 'Vaga', value: String(wave) }, { label: 'Rochas destruídas', value: String(destroyed) }, { label: 'Discos abatidos', value: String(ufosDown) }, { label: 'Maior cadeia', value: String(bestChain) }];
      const addScore = (p, x, y, col) => {
        score += p; X.A.setScore(score);
        X.fx.text(clamp(x, 30, W - 30), clamp(y - 16, 20, H - 20), '+' + p, col || '#fff', p >= 200 ? 22 : 17, .8);
        if (score >= nextLife) { nextLife += 10000; lives = Math.min(6, lives + 1); X.snd('bonus', 0); X.flash('Nave extra', 'bonus'); hud(); }
        watchRecord(score);
      };
      const addShot = (a, spread) => { if (ns >= SMAX) return; const s = shots[ns++]; const ca = Math.cos(a + spread), sa = Math.sin(a + spread); s.x = ship.x + ca * 18; s.y = ship.y + sa * 18; s.vx = ca * 470 + ship.vx * .5; s.vy = sa * 470 + ship.vy * .5; s.life = .8; s.px = s.qx = s.x; s.py = s.qy = s.y; };
      const fire = () => {
        if (!ship.alive || !X.alive()) return;
        if (bonusKind === 1) { addShot(ship.a, -.2); addShot(ship.a, 0); addShot(ship.a, .2); } else addShot(ship.a, 0);
        X.snd('laser', 40); X.fx.one(ship.x + Math.cos(ship.a) * 22, ship.y + Math.sin(ship.a) * 22, 0, 0, '#E6E5FF', .1, 6);
      };
      const tryFire = () => { if (fireT <= 0) { fire(); fireT = bonusKind === 2 ? .09 : .2; } };
      const addCap = (x, y) => { if (nc >= CMAX) return; const cp = caps[nc++]; cp.x = x; cp.y = y; const a = rnd(0, TAU); cp.vx = Math.cos(a) * 26; cp.vy = Math.sin(a) * 26; cp.kind = (Math.random() * 3) | 0; cp.life = 9; cp.t = 0; };
      const grab = i => {
        const k = caps[i].kind; rmCap(i); X.snd('powerup', 0); X.haptic('light'); X.fx.burst(ship.x, ship.y, CAPCOL[k], 14, 160, .6, 3); X.flash(CAPNAME[k], 'bonus');
        if (k === 0) ship.shield = Math.max(ship.shield, 8); else { bonusKind = k; bonusT = 10; bonusShown = -1; }
        hudBonus();
      };
      const split = (i, byShot) => {
        const r = rocks[i], x = r.x, y = r.y, size = r.size, vx = r.vx, vy = r.vy; rmRock(i);
        X.fx.burst(x, y, '#C9C8FF', size * 4, 110 + (3 - size) * 30, .6, 2 + size); X.fx.burst(x, y, '#7A7AA6', size * 3, 170, .7, 3 + size, 0, 1);
        boom(x, y, 30 + size * 26);
        if (size === 3) { X.shake.hit(4); X.hitStop(.04); } else if (size === 2) X.shake.hit(2);
        X.snd(size === 1 ? 'hit' : 'explode', 40); destroyed++;
        if (byShot) { chain++; miss = 0; if (chain > bestChain) bestChain = chain; const m = chainMult(chain); if (m > mult) { mult = m; X.flash('Cadeia x' + m, 'bonus'); X.snd('combo', 0); hud(); } }
        addScore(PTS[size] * mult, x, y, mult > 1 ? '#FFD60A' : '#fff');
        if (size > 1) { const base = Math.atan2(vy, vx); addRock(x, y, size - 1, base - .6 + rnd(-.3, .3)); addRock(x, y, size - 1, base + .6 + rnd(-.3, .3)); }
        if (size >= 2 && Math.random() < .14) addCap(x, y);
      };
      const kill = () => {
        if (!ship.alive || ship.shield > 0 || !X.alive()) return;
        ship.alive = false; ship.thrust = false; lives--; bonusKind = 0; bonusT = 0; hudBonus();
        X.snd('explode', 0); X.snd('crash', 0); X.haptic('heavy'); X.hitStop(.08); X.flashW(.6); X.shake.hit(12);
        X.fx.burst(ship.x, ship.y, '#A7A6FF', 24, 230, 1.1, 4.5); X.fx.burst(ship.x, ship.y, '#fff', 14, 260, .9, 4, 0, 1); X.fx.burst(ship.x, ship.y, '#5E5CE6', 12, 300, 1.2, 5, 0, 1); X.fx.burst(ship.x, ship.y, '#FF9F0A', 10, 140, .7, 3.5, 0, 2);
        boom(ship.x, ship.y, 150); boom(ship.x, ship.y, 260);
        chain = 0; mult = 1; hud();
        if (lives <= 0) { X.die({ title: 'Sem naves', sub: `${score} pontos · vaga ${wave}`, score, win: false, stats: stats() }, 1.6); return; }
        ship.respawn = 1.6;
      };
      const hyper = () => {
        if (!ship.alive || !X.alive() || hyperCd > 0) return;
        X.snd('whoosh', 0); X.fx.burst(ship.x, ship.y, '#5AC8FA', 16, 220, .5, 3, 0, 1);
        let bx = ship.x, by = ship.y;
        for (let k = 0; k < 14; k++) { const tx = rnd(40, W - 40), ty = rnd(40, H - 40); let ok = true; for (let i = 0; i < nr; i++) if (dist(tx, ty, rocks[i].x, rocks[i].y) < rocks[i].r + 70) { ok = false; break; } bx = tx; by = ty; if (ok) break; }
        ship.x = bx; ship.y = by; ship.vx = 0; ship.vy = 0; ship.shield = Math.max(ship.shield, 1); hyperCd = 6; hyperT = .35; X.flashW(.25);
        X.fx.burst(bx, by, '#5AC8FA', 16, 220, .5, 3, 0, 1); setHyperBtn();
      };
      const spawnUfo = () => {
        if (nf >= FMAX) return;
        const u = ufos[nf++], small = wave >= 4 && Math.random() < Math.min(.6, .2 + wave * .04), left = Math.random() < .5;
        u.x = left ? -30 : W + 30; u.y = u.y0 = rnd(70, H - 70); u.vx = (left ? 1 : -1) * (small ? 120 : 90); u.t = 0; u.small = small; u.r = small ? 10 : 15; u.fire = 1.2;
        X.snd('chime', 0); X.flash('Disco voador');
      };
      const ufoDown = (j, scored) => {
        const u = ufos[j], x = u.x, y = u.y, small = u.small; rmUfo(j);
        X.fx.burst(x, y, '#FF5C8A', 18, 190, .7, 3); X.fx.burst(x, y, '#FFE066', 8, 150, .6, 2.5, 0, 2); boom(x, y, 90); X.shake.hit(5); X.snd('explode', 0);
        if (scored) { ufosDown++; chain++; miss = 0; addScore((small ? 1000 : 200) * mult, x, y, '#FF5C8A'); }
      };

      function tick(dt) {
        X.fx.step(dt);
        for (let i = 0; i < nr; i++) { const r = rocks[i]; r.x += r.vx * dt; r.y += r.vy * dt; r.rot += r.spin * dt; wrap(r); }
        for (let i = nb - 1; i >= 0; i--) { const b = booms[i]; b.t += dt; if (b.t >= b.max) { nb--; if (i !== nb) { booms[i] = booms[nb]; booms[nb] = b; } } }
        pox -= ship.vx * dt * .05; poy -= ship.vy * dt * .05; flameT += dt;
        if (X.dying) { draw(); return; }
        if (waveT > 0) { waveT -= dt; if (waveT <= 0) startWave(); }
        fireT -= dt;
        if (hyperCd > 0) { hyperCd -= dt; if (hyperCd <= 0) { hyperCd = 0; setHyperBtn(); X.snd('tick', 0); } }
        if (hyperT > 0) hyperT -= dt;
        if (bonusT > 0) { bonusT -= dt; const s = Math.ceil(bonusT); if (s !== bonusShown) { bonusShown = s; hudBonus(); } if (bonusT <= 0) { bonusKind = 0; bonusT = 0; hudBonus(); } }
        if (ship.alive) {
          if (stick && stick.mag > .2) ship.a += clamp(angDiff(ship.a, stick.ang), -8 * dt, 8 * dt);
          if (X.K.is('left')) ship.a -= 4.2 * dt;
          if (X.K.is('right')) ship.a += 4.2 * dt;
          ship.thrust = thrustHeld || X.K.is('up') || !!(stick && stick.mag > .88);
          if (ship.thrust) {
            ship.vx += Math.cos(ship.a) * 420 * dt; ship.vy += Math.sin(ship.a) * 420 * dt;
            if (Math.random() < .5) X.fx.one(ship.x - Math.cos(ship.a) * 16, ship.y - Math.sin(ship.a) * 16, -Math.cos(ship.a) * 90 + rnd(-30, 30), -Math.sin(ship.a) * 90 + rnd(-30, 30), Math.random() < .5 ? '#FF9F0A' : '#FFD60A', .28, 2.5);
          }
          if (fireHeld || X.K.is('space')) tryFire();
          const k = Math.exp(-.55 * dt); ship.vx *= k; ship.vy *= k;
          const sp = hyp(ship.vx, ship.vy); if (sp > 330) { ship.vx *= 330 / sp; ship.vy *= 330 / sp; }
          ship.x += ship.vx * dt; ship.y += ship.vy * dt; wrap(ship);
          if (ship.shield > 0) ship.shield -= dt;
        } else {
          ship.respawn -= dt;
          if (ship.respawn <= 0) {
            /* espera por um centro livre; ao fim de 3 s renasce na mesma, com escudo maior */
            const forced = ship.respawn < -3; let clear = forced;
            if (!clear) { clear = true; for (let i = 0; i < nr; i++) if (dist(W / 2, H / 2, rocks[i].x, rocks[i].y) < rocks[i].r + 70) { clear = false; break; } }
            if (clear) { ship.alive = true; ship.x = W / 2; ship.y = H / 2; ship.vx = 0; ship.vy = 0; ship.a = -HPI; ship.shield = forced ? 3.5 : 2.5; X.snd('chime', 0); X.fx.burst(W / 2, H / 2, '#7FE7FF', 12, 120, .5, 3); }
          }
        }
        for (let i = ns - 1; i >= 0; i--) {
          const s = shots[i]; s.qx = s.px; s.qy = s.py; s.px = s.x; s.py = s.y; s.x += s.vx * dt; s.y += s.vy * dt; s.life -= dt; wrap(s);
          if (Math.abs(s.px - s.x) > W / 2 || Math.abs(s.py - s.y) > H / 2) { s.px = s.qx = s.x; s.py = s.qy = s.y; }
          if (s.life <= 0) { rmShot(i); if (++miss >= 3 && chain) { chain = 0; if (mult > 1) { mult = 1; hud(); } } continue; }
          let hit = false;
          for (let j = nr - 1; j >= 0; j--) { const r = rocks[j]; if (dist(s.x, s.y, r.x, r.y) < r.r * .92 + 3) { split(j, true); hit = true; break; } }
          if (!hit) for (let j = nf - 1; j >= 0; j--) { if (dist(s.x, s.y, ufos[j].x, ufos[j].y) < ufos[j].r + 4) { ufoDown(j, true); hit = true; break; } }
          if (hit) rmShot(i);
        }
        if (wave >= 2 && !nf && waveT <= 0) { ufoT -= dt; if (ufoT <= 0) { ufoT = rnd(14, 22) - Math.min(6, wave * .5); spawnUfo(); } }
        for (let j = nf - 1; j >= 0; j--) {
          const u = ufos[j]; u.t += dt; u.x += u.vx * dt; u.y = u.y0 + Math.sin(u.t * 2.2) * 34; u.fire -= dt;
          if (u.fire <= 0 && ship.alive && nu < UMAX) {
            u.fire = u.small ? 1.1 : 1.5;
            const a = u.small ? Math.atan2(wrapD(ship.y - u.y, H), wrapD(ship.x - u.x, W)) + rnd(-1, 1) * Math.max(.06, .36 - wave * .03) : rnd(0, TAU);
            const s = ushots[nu++]; s.x = u.x; s.y = u.y; s.vx = Math.cos(a) * 220; s.vy = Math.sin(a) * 220; s.life = 1.6; X.snd('laser', 0);
          }
          if (u.x < -50 || u.x > W + 50) { rmUfo(j); continue; }
          for (let i = nr - 1; i >= 0; i--) { if (dist(u.x, u.y, rocks[i].x, rocks[i].y) < u.r + rocks[i].r * .8) { ufoDown(j, false); break; } }
        }
        for (let i = nu - 1; i >= 0; i--) {
          const s = ushots[i]; s.x += s.vx * dt; s.y += s.vy * dt; s.life -= dt; wrap(s);
          if (s.life <= 0) { rmUshot(i); continue; }
          if (ship.alive && dist(s.x, s.y, ship.x, ship.y) < 12) { rmUshot(i); if (ship.shield > 0) { X.fx.burst(s.x, s.y, '#7FE7FF', 5, 90, .3, 2); X.snd('hit', 0); } else kill(); }
        }
        for (let i = nc - 1; i >= 0; i--) {
          const cp = caps[i]; cp.x += cp.vx * dt; cp.y += cp.vy * dt; cp.life -= dt; cp.t += dt; wrap(cp);
          if (cp.life <= 0) { rmCap(i); continue; }
          if (ship.alive && dist(cp.x, cp.y, ship.x, ship.y) < 26) grab(i);
        }
        if (ship.alive && ship.shield <= 0) {
          for (let j = nr - 1; j >= 0; j--) { const r = rocks[j]; if (dist(ship.x, ship.y, r.x, r.y) < r.r * .85 + 11) { split(j, false); kill(); break; } }
          for (let j = nf - 1; j >= 0 && ship.alive; j--) if (dist(ship.x, ship.y, ufos[j].x, ufos[j].y) < ufos[j].r + 9) { ufoDown(j, true); kill(); }
        } else if (ship.alive) {
          /* com escudo, as rochas pequenas rebentam ao tocar; as grandes empurram */
          for (let j = nr - 1; j >= 0; j--) { const r = rocks[j]; if (dist(ship.x, ship.y, r.x, r.y) < r.r * .85 + 14) { if (r.size === 1) split(j, false); else { const ax = wrapD(ship.x - r.x, W), ay = wrapD(ship.y - r.y, H), d = hyp(ax, ay) || 1; ship.vx += ax / d * 260 * dt * 10; ship.vy += ay / d * 260 * dt * 10; X.snd('hit', 120); } } }
        }
        if (!nr && waveT <= 0 && X.alive()) { waveT = 1.8; X.snd('win', 0); }
        draw();
      }
      /* sprite rodado, com cópias na dobra do ecrã (sem save/restore, sem closures) */
      const drawRot = (img, x, y, a, h, m) => {
        const cs = Math.cos(a), sn = Math.sin(a);
        c.setTransform(cs, sn, -sn, cs, x, y); c.drawImage(img, -h, -h);
        if (x < m) { c.setTransform(cs, sn, -sn, cs, x + W, y); c.drawImage(img, -h, -h); } else if (x > W - m) { c.setTransform(cs, sn, -sn, cs, x - W, y); c.drawImage(img, -h, -h); }
        if (y < m) { c.setTransform(cs, sn, -sn, cs, x, y + H); c.drawImage(img, -h, -h); } else if (y > H - m) { c.setTransform(cs, sn, -sn, cs, x, y - H); c.drawImage(img, -h, -h); }
        c.setTransform(1, 0, 0, 1, 0, 0);
      };
      function draw() {
        c.drawImage(BG, 0, 0);
        let ox = ((pox % W) + W) % W, oy = ((poy % H) + H) % H;
        c.drawImage(STARS1, ox - W, oy - H); c.drawImage(STARS1, ox, oy - H); c.drawImage(STARS1, ox - W, oy); c.drawImage(STARS1, ox, oy);
        ox = (((pox * 2.2) % W) + W) % W; oy = (((poy * 2.2) % H) + H) % H;
        c.drawImage(STARS2, ox - W, oy - H); c.drawImage(STARS2, ox, oy - H); c.drawImage(STARS2, ox - W, oy); c.drawImage(STARS2, ox, oy);
        for (let i = 0; i < nc; i++) { const cp = caps[i]; if (cp.life < 2 && ((cp.life * 8) | 0) % 2) continue; c.drawImage(CAP[cp.kind], cp.x - 20, cp.y - 20 + Math.sin(cp.t * 4) * 3); }
        for (let i = 0; i < nr; i++) { const r = rocks[i], s = ROCK[r.size][r.v]; drawRot(s, r.x, r.y, r.rot, s.width / 2, r.r + 12); }
        for (let j = 0; j < nf; j++) { const u = ufos[j], f = ((u.t * 6) | 0) & 1, k = u.small ? .66 : 1; c.drawImage(UFO[f], u.x - 32 * k, u.y - 16 * k, 64 * k, 32 * k); }
        for (let i = 0; i < nu; i++) { const s = ushots[i]; c.drawImage(UBUL, s.x - 6, s.y - 6); }
        for (let i = 0; i < ns; i++) { const s = shots[i]; c.globalAlpha = .25; c.drawImage(BUL, s.qx - 4, s.qy - 4, 8, 8); c.globalAlpha = .5; c.drawImage(BUL, s.px - 5, s.py - 5, 10, 10); c.globalAlpha = 1; c.drawImage(BUL, s.x - 7, s.y - 7); }
        if (ship.alive) {
          const cs = Math.cos(ship.a) * SK, sn = Math.sin(ship.a) * SK, fr = ((flameT * 24) | 0) % 3;
          c.setTransform(cs, sn, -sn, cs, ship.x, ship.y);
          if (ship.thrust) c.drawImage(FLAME[fr], -46, -10);
          c.drawImage(SHIP, -30, -30);
          c.setTransform(1, 0, 0, 1, 0, 0);
          const blink = ship.shield > 0 && ship.shield < .8 && ((ship.shield * 10) | 0) % 2 === 0;
          if (ship.shield > 0 && !blink) { c.globalAlpha = ship.shield > 2 ? .9 : .6; c.drawImage(SHIELD, ship.x - SHW, ship.y - SHW); c.globalAlpha = 1; }
          if (hyperT > 0) { c.globalAlpha = hyperT / .35; c.drawImage(WARP, ship.x - 29, ship.y - 29); c.globalAlpha = 1; }
        }
        for (let i = 0; i < nb; i++) { const b = booms[i], k = b.t / b.max, s = b.size * (.25 + .75 * k); c.globalAlpha = 1 - k; c.drawImage(BOOM, b.x - s / 2, b.y - s / 2, s, s); }
        c.globalAlpha = 1;
        X.fx.draw(c);
        X.post(c);
      }
      function key(e) {
        const m = ARROWS[e.key]; if (!m) return;
        e.preventDefault();
        if (m === 'down') { if (e.type !== 'keyup' && !e.repeat) hyper(); return; }
        if (e.type === 'keyup') X.K.up(m); else X.K.down(m, e.repeat);
      }
      /* controlos: joystick à esquerda (direção; a fundo também acelera), hiperespaço, acelerar e disparar à direita */
      X.A.el.ctl.innerHTML = `<div class="grk-ctl"><div class="grk-stick"><div class="grk-knob"></div></div>
        <div class="grk-btns">${Arcade.btn('grk-hyper', 'sparkles', 20)}${Arcade.btn('grk-thrust', 'rocket', 22)}${Arcade.btn('grk-fire', 'bolt', 22)}</div></div>`;
      const stickEl = X.A.el.ctl.querySelector('.grk-stick'), knob = X.A.el.ctl.querySelector('.grk-knob');
      hyperBtn = X.A.el.ctl.querySelector('.grk-hyper');
      let sid = null, srect = null;
      const stickMove = e => {
        if (!srect || !srect.width) srect = stickEl.getBoundingClientRect();
        const k = srect.width ? 120 / srect.width : 1;
        let dx = (e.clientX - (srect.left + srect.width / 2)) * k, dy = (e.clientY - (srect.top + srect.height / 2)) * k;
        const d = hyp(dx, dy), m = Math.min(1, d / 44);
        if (d > 44) { dx *= 44 / d; dy *= 44 / d; }
        if (!stick) stick = { ang: 0, mag: 0 };
        stick.ang = Math.atan2(dy, dx); stick.mag = m;
        knob.style.transform = `translate(${dx.toFixed(1)}px,${dy.toFixed(1)}px)`;
      };
      stickEl.addEventListener('pointerdown', e => { sid = e.pointerId; srect = null; try { stickEl.setPointerCapture(e.pointerId); } catch (x) {} stickMove(e); });
      stickEl.addEventListener('pointermove', e => { if (e.pointerId === sid) stickMove(e); });
      const stickUp = e => { if (e.pointerId !== sid) return; sid = null; stick = null; knob.style.transform = ''; };
      stickEl.addEventListener('pointerup', stickUp); stickEl.addEventListener('pointercancel', stickUp);
      hold(X.A.el.ctl.querySelector('.grk-fire'), () => { fireHeld = true; tryFire(); }, () => { fireHeld = false; });
      hold(X.A.el.ctl.querySelector('.grk-thrust'), () => { thrustHeld = true; }, () => { thrustHeld = false; });
      hyperBtn.addEventListener('pointerdown', () => hyper());
      pointer(X, { down: () => tryFire() });
      start();
      return X.api;
    },
  });

  /* =====================================================================
     3. CORREDOR (runner): três faixas em perspetiva, personagem com ciclo de corrida, barreiras às riscas,
        camiões, túneis para baixar, moedas a rodar, bónus (íman, pontos a dobrar, planar), hora do dia
     ===================================================================== */
  Icons.app.runner = () => Icons.SVG(Icons.G('gRn', '#5EE7DF', '#00B8AE', '#0A3E8F') + Icons.GL(
    `<path d="M36 26h28l36 74H0z" fill="#fff" opacity=".16"/><path d="M48 26l-14 74M52 26l14 74" stroke="#fff" stroke-opacity=".45" stroke-width="1.6"/>` +
    `<path d="M50 36v5M50 50v7M50 66v9M50 84v12" stroke="#fff" stroke-opacity=".75" stroke-width="2.6" stroke-linecap="round"/>` +
    `<circle cx="76" cy="36" r="5" fill="#FFD60A"/><circle cx="24" cy="36" r="5" fill="#FFD60A"/>` +
    `<rect x="40" y="48" width="20" height="26" rx="8" fill="#fff"/><circle cx="50" cy="42" r="8" fill="#fff"/><rect x="44" y="40" width="12" height="4" rx="2" fill="#0A3E8F" opacity=".8"/>` +
    `<path d="M44 74l-6 14M56 74l8 12M40 56l-10 6M60 56l10-6" stroke="#fff" stroke-width="5" stroke-linecap="round"/>`));

  Arcade.game('runner', {
    name: 'Corredor', color: '#00C7BE', kind: 'action', tags: ['Sem fim', 'Rápido'],
    desc: 'Corrida sem fim em três faixas pela autoestrada de Los Santos: desliza para mudar de faixa, salta as barreiras, baixa-te nos túneis, desvia-te dos camiões e apanha moedas. Íman, pontos a dobrar e planar para ajudar, e a estrada acelera sem parar.',
    howto: { goal: 'Corre o mais longe possível sem bater em nada.', steps: ['Desliza para o lado para mudar de faixa', 'Salta as barreiras às riscas e baixa-te nos túneis', 'Os camiões não se saltam: muda de faixa', 'Apanha moedas e os bónus: íman, pontos a dobrar e planar'], controls: [{ icon: 'hand', label: 'Toca para saltar; desliza para os lados, cima e baixo' }, { icon: 'gamepad', label: 'Setas ou WASD; Espaço salta' }] },
    cover: () => `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="crnS" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#15123A"/><stop offset=".6" stop-color="#6E2A5E"/><stop offset="1" stop-color="#FF8C3A"/></linearGradient><linearGradient id="crnR" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1A1830"/><stop offset="1" stop-color="#2E2B48"/></linearGradient><linearGradient id="crnB" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#5EE7DF"/><stop offset="1" stop-color="#00A89F"/></linearGradient><linearGradient id="crnC" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFE27A"/><stop offset="1" stop-color="#C98A00"/></linearGradient></defs>` +
      `<rect width="400" height="200" fill="url(#crnS)"/><g fill="#1A1030"><rect x="0" y="66" width="30" height="40"/><rect x="34" y="50" width="22" height="56"/><rect x="60" y="72" width="40" height="34"/><rect x="104" y="40" width="26" height="66"/><rect x="134" y="62" width="30" height="44"/><rect x="236" y="56" width="28" height="50"/><rect x="268" y="74" width="44" height="32"/><rect x="316" y="44" width="22" height="62"/><rect x="342" y="68" width="58" height="38"/></g>` +
      `<rect y="104" width="400" height="96" fill="#120F22"/><path d="M160 104h80l160 96H0z" fill="url(#crnR)"/><path d="M160 104L0 200M240 104l160 96" stroke="#fff" stroke-opacity=".3" stroke-width="2"/>` +
      `<path d="M187 104L80 200M213 104l107 96" stroke="#fff" stroke-opacity=".35" stroke-width="3" stroke-dasharray="10 12"/>` +
      `<g><rect x="262" y="118" width="40" height="12" rx="4" fill="#E53935"/><rect x="266" y="120" width="6" height="8" fill="#fff" opacity=".9"/><rect x="280" y="120" width="6" height="8" fill="#fff" opacity=".9"/><rect x="294" y="120" width="5" height="8" fill="#fff" opacity=".9"/><rect x="265" y="130" width="4" height="22" fill="#9AA0B0"/><rect x="295" y="130" width="4" height="22" fill="#9AA0B0"/></g>` +
      `<g fill="url(#crnC)"><ellipse cx="120" cy="124" rx="7" ry="8"/><ellipse cx="128" cy="138" rx="5" ry="9"/><ellipse cx="138" cy="156" rx="9" ry="10"/></g>` +
      `<g transform="translate(200 186)"><ellipse cy="2" rx="18" ry="5" fill="rgba(0,0,0,.4)"/><path d="M-8 -6l-8 8M8 -6l10 6" stroke="#1F2A44" stroke-width="7" stroke-linecap="round"/><rect x="-13" y="-46" width="26" height="40" rx="12" fill="url(#crnB)"/><path d="M-14 -34l-12 8M14 -34l12-10" stroke="#5EE7DF" stroke-width="7" stroke-linecap="round"/><circle cy="-54" r="12" fill="#fff"/><rect x="-9" y="-57" width="18" height="6" rx="3" fill="#0A3E8F" opacity=".85"/></g></svg>`,
    build(win) {
      const W = 400, H = 600, CX = W / 2, F = 4, HY = 170, K = 616, LW = 150, M = 120, PZ = 3;
      const fz = z => F / (F + (z < -F * .8 ? -F * .8 : z));
      const sy = z => HY + K * fz(z);
      const sx = (lane, z) => CX + lane * LW * fz(z);
      const FP = fz(PZ), GY = sy(PZ), OMAX = 110;
      /* objetos da estrada: pool fixo (k: 1 barreira, 2 camião, 3 túnel, 4 moeda, 5 cápsula); objs em ordem de nascimento (longe no fim) */
      const pool = mk(OMAX, () => ({ k: 0, lane: 0, lx: 0, z: 0, h: 0, spin: 0, sub: 0 })), objs = [], free = pool.slice();
      let T, d, v, coins, score, shown, L, cur, jh, jv, buffer, slide, grace, nextRow, step, faster, vmax, bonus, bonusT, bonusShown, bonusN, ph, dyA, dyY, lastDm = -1, watchRecord = () => {};
      const STREAK = mk(12, i => [rnd(-Math.PI * .95, -Math.PI * .05) + (i % 2 ? Math.PI : 0), rnd(0, 100)]);
      const X = host(win, {
        id: 'runner', name: 'Corredor', color: '#00C7BE', W, H, particles: 200,
        restart: () => start(), tick, draw, key,
        onResume: () => { grace = .9; },
        dbg: { bonus: k => giveBonus(k), time: p => { T = Math.max(T, (p - 1) * 40); faster = 36; }, speed: n => { T = Math.max(T, (n - 12) / .3); }, crash: () => crash('Bateste num camião', 2), dist: m => { d = m; score = Math.max(score, m); shown = Math.floor(score); X.A.setScore(shown); }, state: () => ({ T, d, v, coins, score: shown, L, jh, slide, bonus, bonusT, ph: ph % 4, n: objs.length }) },
      });
      const c = X.ctx;

      /* ----- arte pré-desenhada ----- */
      const SH = HY + 30;
      const SKY = [
        spr(W, SH, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, SH, [[0, '#2F7FDF'], [.6, '#79BCF5'], [1, '#E2F1FF']]); c2.fillRect(0, 0, W, SH); }),
        spr(W, SH, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, SH, [[0, '#15123A'], [.55, '#6E2A5E'], [1, '#FF8C3A']]); c2.fillRect(0, 0, W, SH); }),
        spr(W, SH, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, SH, [[0, '#04051A'], [.6, '#101744'], [1, '#2B2E6B']]); c2.fillRect(0, 0, W, SH); for (let i = 0; i < 90; i++) { const s = rnd(.6, 1.8); c2.globalAlpha = rnd(.3, .9); c2.fillStyle = '#fff'; c2.fillRect(rnd(0, W), rnd(0, SH * .7), s, s); } c2.globalAlpha = 1; }),
        spr(W, SH, c2 => { c2.fillStyle = lgrad(c2, 0, 0, 0, SH, [[0, '#2E2A6B'], [.5, '#B04C86'], [1, '#FFC07A']]); c2.fillRect(0, 0, W, SH); }),
      ];
      const cityStrip = (h, minH, maxH, col0, col1) => spr(800, h, c2 => { for (let x = 0; x < 800;) { const w = rnd(18, 54), hh = rnd(minH, maxH); if (x + w > 800) break; c2.fillStyle = lgrad(c2, x, 0, x + w, 0, [[0, col0], [1, col1]]); c2.fillRect(x, h - hh, w, hh + 6); c2.fillStyle = 'rgba(255,255,255,.08)'; c2.fillRect(x, h - hh, w, 2); if (hh > maxH * .8 && w > 30) { c2.fillStyle = col1; c2.fillRect(x + w / 2 - 1, h - hh - 12, 2, 12); } x += w + rnd(3, 12); } });
      const CITYF = cityStrip(120, 20, 100, '#2A1A48', '#1E1236'), CITYN2 = cityStrip(170, 40, 160, '#1C1030', '#120A22');
      const CITYL = spr(800, 170, c2 => { for (let i = 0; i < 520; i++) { c2.fillStyle = Math.random() < .5 ? 'rgba(255,221,150,.85)' : 'rgba(120,220,255,.6)'; c2.fillRect(rnd(0, 800), rnd(20, 164), 3, 4); } });
      const ROADBG = spr(W, H - HY, c2 => {
        c2.translate(0, -HY);
        c2.fillStyle = lgrad(c2, 0, HY, 0, H, [[0, '#17132A'], [1, '#0E0B1A']]); c2.fillRect(0, HY, W, H - HY);
        c2.fillStyle = 'rgba(255,190,120,.35)'; c2.fillRect(0, HY - 1, W, 2);
        const zf = 400, zn = -1.5;
        c2.beginPath(); c2.moveTo(sx(-1.5, zn), sy(zn)); c2.lineTo(sx(-1.5, zf), sy(zf)); c2.lineTo(sx(1.5, zf), sy(zf)); c2.lineTo(sx(1.5, zn), sy(zn)); c2.closePath();
        c2.fillStyle = lgrad(c2, 0, HY, 0, H, [[0, '#262238'], [.5, '#2B2742'], [1, '#34304E']]); c2.fill();
        c2.lineWidth = 2; c2.strokeStyle = 'rgba(255,255,255,.35)';
        for (let i = 0; i < 2; i++) { const e = i ? 1.5 : -1.5; c2.beginPath(); c2.moveTo(sx(e, zn), sy(zn)); c2.lineTo(sx(e, zf), sy(zf)); c2.stroke(); }
        /* carris laterais: duas linhas por lado, com brilho */
        c2.strokeStyle = 'rgba(180,200,230,.5)'; c2.lineWidth = 2.5;
        for (let i = 0; i < 2; i++) { const e = i ? 1.68 : -1.68; c2.beginPath(); c2.moveTo(sx(e, -1), sy(-1) - .62 * M * fz(-1)); c2.lineTo(sx(e, 80), sy(80) - .62 * M * fz(80)); c2.stroke(); }
        c2.fillStyle = rgrad(c2, CX, HY + 40, 20, CX, HY + 40, 260, [[0, 'rgba(255,180,120,.12)'], [1, 'rgba(255,180,120,0)']]); c2.fillRect(0, HY, W, 300);
      });
      const BAR = spr(136, 124, c2 => {
        c2.fillStyle = 'rgba(0,0,0,.32)'; c2.beginPath(); c2.ellipse(68, 116, 62, 7, 0, 0, TAU); c2.fill();
        for (let i = 0; i < 2; i++) { const x = i ? 114 : 12; c2.fillStyle = lgrad(c2, x, 0, x + 10, 0, [[0, '#C9CCD6'], [.5, '#8E93A3'], [1, '#5C6070']]); rr(c2, x, 30, 10, 84, 4); c2.fill(); c2.fillStyle = '#3A3D48'; rr(c2, x - 3, 108, 16, 8, 3); c2.fill(); }
        c2.save(); rr(c2, 0, 10, 136, 40, 8); c2.clip(); c2.fillStyle = '#E53935'; c2.fillRect(0, 10, 136, 40); c2.fillStyle = '#F7F7FA'; for (let x = -40; x < 180; x += 40) { c2.beginPath(); c2.moveTo(x, 50); c2.lineTo(x + 20, 50); c2.lineTo(x + 40, 10); c2.lineTo(x + 20, 10); c2.closePath(); c2.fill(); } c2.fillStyle = 'rgba(255,255,255,.3)'; c2.fillRect(0, 10, 136, 5); c2.fillStyle = 'rgba(0,0,0,.25)'; c2.fillRect(0, 45, 136, 5); c2.restore();
        c2.lineWidth = 1.5; c2.strokeStyle = 'rgba(0,0,0,.35)'; rr(c2, 0, 10, 136, 40, 8); c2.stroke();
        c2.fillStyle = '#3A3D48'; c2.fillRect(64, 2, 8, 10); glow(c2, '#FFD60A', 10); c2.fillStyle = '#FFE066'; c2.beginPath(); c2.arc(68, 6, 6, 0, TAU); c2.fill(); noGlow(c2);
      });
      const TRUCK = spr(136, 290, c2 => {
        c2.fillStyle = 'rgba(0,0,0,.35)'; c2.beginPath(); c2.ellipse(68, 282, 68, 9, 0, 0, TAU); c2.fill();
        for (let i = 0; i < 2; i++) { const x = i ? 96 : 14; c2.fillStyle = '#17181E'; rr(c2, x, 246, 26, 38, 6); c2.fill(); c2.fillStyle = '#3B3D47'; rr(c2, x + 8, 256, 10, 18, 3); c2.fill(); }
        c2.fillStyle = lgrad(c2, 0, 0, 0, 40, [[0, '#4E5468'], [1, '#2C3040']]); rr(c2, 24, 18, 88, 30, 8); c2.fill(); for (let i = 0; i < 4; i++) { glow(c2, '#FFB020', 6); c2.fillStyle = '#FFC24A'; c2.fillRect(38 + i * 18, 22, 8, 4); } noGlow(c2);
        c2.fillStyle = lgrad(c2, 4, 0, 132, 0, [[0, '#C9CBD6'], [.15, '#F4F4F8'], [.85, '#E1E2EA'], [1, '#9A9CAA']]); rr(c2, 4, 40, 128, 216, 6); c2.fill();
        c2.fillStyle = 'rgba(0,0,0,.18)'; c2.fillRect(67, 48, 2, 200); c2.fillStyle = '#FF9F0A'; c2.fillRect(4, 150, 128, 22); c2.fillStyle = 'rgba(255,255,255,.35)'; c2.fillRect(4, 150, 128, 4);
        c2.fillStyle = '#6E7280'; for (let i = 0; i < 3; i++) { c2.fillRect(12, 70 + i * 60, 6, 14); c2.fillRect(118, 70 + i * 60, 6, 14); }
        c2.fillStyle = 'rgba(255,255,255,.45)'; c2.fillRect(4, 40, 128, 3);
        c2.fillStyle = '#2B2B33'; rr(c2, 0, 254, 136, 16, 4); c2.fill();
        for (let i = 0; i < 2; i++) { const x = i ? 104 : 8; glow(c2, '#FF3B30', 10); c2.fillStyle = '#FF453A'; rr(c2, x, 257, 24, 10, 3); c2.fill(); } noGlow(c2);
        c2.fillStyle = '#FFE066'; c2.fillRect(60, 258, 16, 8);
        c2.lineWidth = 1.5; c2.strokeStyle = 'rgba(0,0,0,.3)'; rr(c2, 4, 40, 128, 216, 6); c2.stroke();
      });
      const TUNNEL = spr(170, 226, c2 => {
        for (let i = 0; i < 2; i++) { const x = i ? 154 : 0; c2.fillStyle = lgrad(c2, x, 0, x + 16, 0, [[0, '#A0A7B8'], [.5, '#6B7184'], [1, '#3E4354']]); rr(c2, x, 28, 16, 190, 4); c2.fill(); c2.fillStyle = '#2E3140'; rr(c2, x - 4, 210, 24, 10, 3); c2.fill(); }
        glow(c2, 'rgba(0,0,0,.5)', 10); c2.fillStyle = lgrad(c2, 0, 0, 0, 44, [[0, '#D27CFF'], [.5, '#A044F0'], [1, '#6C21B8']]); rr(c2, -2, 0, 174, 44, 8); c2.fill(); noGlow(c2);
        c2.fillStyle = 'rgba(255,255,255,.35)'; c2.fillRect(2, 2, 166, 4);
        for (let x = 2; x < 168; x += 16) { c2.fillStyle = x % 32 ? '#FFD60A' : '#1C1C1E'; c2.fillRect(x, 38, 16, 6); }
        c2.fillStyle = '#1C1C26'; rr(c2, 55, 7, 60, 28, 6); c2.fill(); c2.strokeStyle = '#fff'; c2.lineWidth = 3; c2.lineCap = 'round'; c2.lineJoin = 'round'; c2.beginPath(); c2.moveTo(85, 12); c2.lineTo(85, 28); c2.moveTo(77, 21); c2.lineTo(85, 29); c2.lineTo(93, 21); c2.stroke();
      });
      const COIN = mk(4, i => spr(40, 40, c2 => { const k = [1, .7, .25, .7][i], rx = 15 * k; c2.fillStyle = 'rgba(0,0,0,.2)'; c2.beginPath(); c2.ellipse(20, 37, rx * .9, 2.5, 0, 0, TAU); c2.fill(); glow(c2, 'rgba(255,200,40,.6)', 8); c2.fillStyle = lgrad(c2, 20 - rx, 0, 20 + rx, 0, [[0, '#C98A00'], [.5, '#FFB800'], [1, '#C98A00']]); c2.beginPath(); c2.ellipse(20, 19, rx, 15, 0, 0, TAU); c2.fill(); noGlow(c2); c2.fillStyle = lgrad(c2, 0, 4, 0, 34, [[0, '#FFF1A8'], [.5, '#FFD60A'], [1, '#E09A00']]); c2.beginPath(); c2.ellipse(20, 19, Math.max(1, rx * .72), 11, 0, 0, TAU); c2.fill(); c2.fillStyle = 'rgba(255,255,255,.55)'; c2.beginPath(); c2.ellipse(20 - rx * .25, 13, Math.max(.8, rx * .3), 3.5, -.4, 0, TAU); c2.fill(); }));
      const CAPCOL = ['#FF375F', '#30D158', '#5AC8FA'], CAPNAME = ['Íman', 'Pontos a dobrar', 'Planar'];
      const CAP = mk(3, k => spr(48, 48, c2 => { const col = CAPCOL[k]; c2.fillStyle = 'rgba(0,0,0,.2)'; c2.beginPath(); c2.ellipse(24, 45, 16, 3, 0, 0, TAU); c2.fill(); glow(c2, col, 14); c2.fillStyle = lgrad(c2, 0, 4, 0, 40, [[0, hexA(col, 1)], [1, hexA(col, .65)]]); rr(c2, 8, 6, 32, 32, 10); c2.fill(); c2.fill(); noGlow(c2); c2.strokeStyle = 'rgba(255,255,255,.85)'; c2.lineWidth = 1.6; c2.stroke(); c2.strokeStyle = '#fff'; c2.fillStyle = '#fff'; c2.lineWidth = 3.4; c2.lineCap = 'round'; c2.lineJoin = 'round';
        if (k === 0) { c2.beginPath(); c2.arc(24, 21, 7, Math.PI, TAU); c2.moveTo(17, 21); c2.lineTo(17, 29); c2.moveTo(31, 21); c2.lineTo(31, 29); c2.stroke(); }
        else if (k === 1) { c2.font = `800 18px ${FONT}`; c2.textAlign = 'center'; c2.textBaseline = 'middle'; c2.fillText('2×', 24, 23); }
        else { c2.beginPath(); c2.moveTo(24, 30); c2.lineTo(24, 14); c2.moveTo(16, 22); c2.lineTo(24, 14); c2.lineTo(32, 22); c2.moveTo(12, 30); c2.lineTo(18, 24); c2.moveTo(36, 30); c2.lineTo(30, 24); c2.stroke(); }
      }));
      /* a personagem: fato teal com capuz, calças escuras, ténis brancos, capacete branco com viseira; poses pelo ciclo */
      const figure = (c2, lf, rf, la, ra, lean, crouch, cross) => {
        const limb = (x0, y0, x1, y1, col, w) => { c2.strokeStyle = col; c2.lineWidth = w; c2.lineCap = 'round'; c2.beginPath(); c2.moveTo(x0, y0); c2.lineTo(x1, y1); c2.stroke(); };
        c2.rotate(lean);
        const hy = crouch ? -22 : -34, bh = crouch ? 26 : 40, bw = crouch ? 34 : 26;
        limb(6, hy + 10, rf[0], rf[1], '#1F2A44', 8); c2.fillStyle = '#F4F4F8'; c2.beginPath(); c2.ellipse(rf[0] + 2, rf[1], 7, 4, 0, 0, TAU); c2.fill();
        limb(10, hy - 10, ra[0], ra[1], '#2BB8B0', 7);
        c2.fillStyle = lgrad(c2, -bw / 2, hy - bh + 8, bw / 2, hy, [[0, '#7FF0E8'], [.45, '#2ED0C6'], [1, '#00968E']]); rr(c2, -bw / 2, hy - bh + 8, bw, bh, 12); c2.fill();
        c2.fillStyle = 'rgba(255,255,255,.35)'; rr(c2, -bw / 2 + 4, hy - bh + 11, 8, bh - 14, 4); c2.fill();
        c2.fillStyle = 'rgba(0,0,0,.18)'; rr(c2, bw / 2 - 8, hy - bh + 12, 5, bh - 14, 3); c2.fill();
        c2.fillStyle = '#1F2A44'; rr(c2, -bw / 2 + 2, hy - 2, bw - 4, 10, 4); c2.fill();
        if (!cross) { limb(-6, hy + 10, lf[0], lf[1], '#243150', 8); c2.fillStyle = '#FFFFFF'; c2.beginPath(); c2.ellipse(lf[0] + 2, lf[1], 7, 4, 0, 0, TAU); c2.fill(); }
        const hx = crouch ? 10 : 0, hyy = crouch ? hy - bh + 2 : hy - bh - 4;
        c2.fillStyle = rgrad(c2, hx - 4, hyy - 5, 2, hx, hyy, 13, [[0, '#FFFFFF'], [.7, '#E8EAF2'], [1, '#B7BBCB']]); c2.beginPath(); c2.arc(hx, hyy, 12, 0, TAU); c2.fill();
        c2.fillStyle = lgrad(c2, hx - 9, 0, hx + 9, 0, [[0, '#0A3E8F'], [.5, '#1E6BFF'], [1, '#0A3E8F']]); rr(c2, hx - 9, hyy - 4, 18, 7, 3.5); c2.fill(); c2.fillStyle = 'rgba(255,255,255,.5)'; c2.fillRect(hx - 6, hyy - 3, 5, 2);
        limb(-10, hy - 10, la[0], la[1], '#5EE7DF', 7);
        if (cross) { limb(-6, hy + 10, lf[0], lf[1], '#243150', 8); c2.fillStyle = '#FFFFFF'; c2.beginPath(); c2.ellipse(lf[0] + 2, lf[1], 7, 4, 0, 0, TAU); c2.fill(); }
      };
      const RUN = mk(4, i => spr(64, 92, c2 => { c2.translate(32, 86); const t = i / 4, s = Math.sin(TAU * t), cs = Math.cos(TAU * t); figure(c2, [-4 + 14 * s, -2 - Math.max(0, 10 * cs)], [-4 - 14 * s, -2 - Math.max(0, -10 * cs)], [-6 - 12 * s, -40 - 6 * Math.abs(s)], [10 + 12 * s, -40 - 6 * Math.abs(s)], .08, false, s > 0); }));
      const JUMP = spr(64, 92, c2 => { c2.translate(32, 86); figure(c2, [-10, -16], [10, -10], [-20, -56], [18, -58], -.06, false, false); });
      const SLIDE = spr(72, 92, c2 => { c2.translate(36, 86); figure(c2, [-18, -2], [16, -3], [-18, -26], [20, -28], 0, true, false); });
      const GLIDE = spr(72, 92, c2 => { c2.translate(36, 86); figure(c2, [-6, -8], [6, -8], [-30, -46], [30, -46], 0, false, false); });
      /* sombra no chão (fica no chão quando a personagem salta), aura do bónus ativo e asa-delta do Planar */
      const SHADOW = spr(48, 14, c2 => { c2.fillStyle = 'rgba(0,0,0,.38)'; c2.beginPath(); c2.ellipse(24, 7, 22, 6, 0, 0, TAU); c2.fill(); c2.fillStyle = 'rgba(0,0,0,.2)'; c2.beginPath(); c2.ellipse(24, 7, 14, 3.5, 0, 0, TAU); c2.fill(); });
      const AURA = mk(3, k => spr(120, 120, c2 => { c2.fillStyle = rgrad(c2, 60, 60, 8, 60, 60, 60, [[0, hexA(CAPCOL[k], 0)], [.55, hexA(CAPCOL[k], .22)], [.82, hexA(CAPCOL[k], .5)], [1, hexA(CAPCOL[k], 0)]]); c2.fillRect(0, 0, 120, 120); }));
      const WING = spr(160, 56, c2 => {
        c2.fillStyle = 'rgba(0,0,0,.25)'; c2.beginPath(); c2.moveTo(80, 10); c2.lineTo(4, 50); c2.lineTo(156, 50); c2.closePath(); c2.fill();
        c2.save(); c2.beginPath(); c2.moveTo(80, 4); c2.lineTo(2, 44); c2.quadraticCurveTo(80, 34, 158, 44); c2.closePath(); c2.clip();
        for (let i = 0; i < 8; i++) { c2.fillStyle = i % 2 ? '#F4F4F8' : '#00C7BE'; c2.beginPath(); c2.moveTo(80, 4); c2.lineTo(i * 20, 48); c2.lineTo(i * 20 + 20, 48); c2.closePath(); c2.fill(); }
        c2.fillStyle = lgrad(c2, 0, 4, 0, 46, [[0, 'rgba(255,255,255,.35)'], [1, 'rgba(0,0,0,.18)']]); c2.fillRect(0, 0, 160, 56); c2.restore();
        c2.strokeStyle = '#1F2A44'; c2.lineWidth = 2.5; c2.lineJoin = 'round'; c2.beginPath(); c2.moveTo(80, 4); c2.lineTo(2, 44); c2.quadraticCurveTo(80, 34, 158, 44); c2.closePath(); c2.stroke();
        c2.lineWidth = 2; c2.beginPath(); c2.moveTo(80, 6); c2.lineTo(80, 42); c2.moveTo(60, 50); c2.lineTo(100, 50); c2.moveTo(80, 40); c2.lineTo(64, 50); c2.moveTo(80, 40); c2.lineTo(96, 50); c2.stroke();
      });

      /* ----- HUD (meio): moedas, metros, bónus com tempo ----- */
      let midCoins = null, midDist = null, midBonus = null, midBonusI = null, midBonusT = null;
      const buildMid = () => {
        X.A.setMid(`<span class="ga-mid">${cap('grn-dist')}${cap('grn-coins', COIN_SVG)}<span class="ga-cap grn-bonus off"><i></i><b>0</b></span></span>`);
        const m = X.A.el.mid; midCoins = m.querySelector('.grn-coins b'); midDist = m.querySelector('.grn-dist b'); midBonus = m.querySelector('.grn-bonus'); midBonusI = midBonus.querySelector('i'); midBonusT = midBonus.querySelector('b');
        midDist.textContent = '0 m'; midCoins.textContent = String(coins); hudBonus();
      };
      const hudBonus = () => { if (!midBonus) return; if (!bonus) { midBonus.classList.add('off'); return; } midBonus.classList.remove('off'); midBonusI.innerHTML = bonus === 1 ? g('sparkles', 16) : bonus === 2 ? g('bolt', 16) : g('arrowUp', 16); midBonusT.textContent = String(Math.max(0, Math.ceil(bonusT))); };

      /* ----- mundo ----- */
      const rowEvery = () => clamp(1.25 - T * .006, .62, 1.25);
      const add = (k, lane, z, h, spin, sub) => { const o = free.pop(); if (!o) return; o.k = k; o.lane = lane; o.lx = lane; o.z = z; o.h = h || 0; o.spin = spin || 0; o.sub = sub || 0; objs.push(o); };
      /* tirar sem splice (o splice cria um array novo): desliza o resto uma posição, mantém a ordem */
      const rm = i => { const o = objs[i], n = objs.length - 1; for (let j = i; j < n; j++) objs[j] = objs[j + 1]; objs.length = n; o.k = 0; free.push(o); };
      /* uma fila de obstáculos: 1 ou 2 faixas ocupadas (nunca as 3); as moedas vão ANTES do obstáculo (ficam por cima ao desenhar) */
      const LANES = [-1, 0, 1];
      const spawnRow = zw => {
        const two = T > 8 && Math.random() < Math.min(.65, .25 + T * .01);
        const a = (Math.random() * 3) | 0; let b = (Math.random() * 3) | 0; if (b === a) b = (b + 1) % 3;
        /* a faixa livre: com duas ocupadas é a terceira; com uma, qualquer das outras duas */
        const freeLane = LANES[two ? 3 - a - b : (a + 1 + ((Math.random() * 2) | 0)) % 3];
        for (let n = 0; n < (two ? 2 : 1); n++) {
          const l = LANES[n ? b : a], r = Math.random(), k = r < .42 ? 1 : r < .72 ? 3 : 2;
          if (k === 1 && Math.random() < .5) for (let i = -1; i <= 1; i++) add(4, l, zw + i * 1.3, 1.45 - Math.abs(i) * .35, rnd(0, TAU));
          add(k, l, zw);
        }
        if (Math.random() < .6) for (let i = 0; i < 5; i++) add(4, freeLane, zw - 7 + i * 1.6, .45, i * .6);
        if (Math.random() < .09) add(5, freeLane, zw - 9, .55, 0, (Math.random() * 3) | 0);
      };
      const reset = () => {
        T = 0; d = 0; v = 12; coins = 0; score = 0; shown = -1; L = 0; cur = 0; jh = 0; jv = 0; buffer = 0; slide = 0; grace = 0; nextRow = 35; step = 0; faster = 16; vmax = 12; bonus = 0; bonusT = 0; bonusShown = -1; bonusN = 0; ph = 1; dyA = 0; dyY = 0;
        while (objs.length) rm(objs.length - 1);
        while (nextRow < 80) { spawnRow(nextRow); nextRow += 15; }
        watchRecord = recordWatch(X, 'runner');
        X.A.setScore(0); buildMid();
      };
      const start = () => { reset(); X.begin('Corredor', 'Desliza para os lados; para cima salta, para baixo baixa-te', true); };
      const stats = () => [{ label: 'Distância', value: Math.floor(d) + ' m' }, { label: 'Moedas', value: String(coins) }, { label: 'Velocidade máxima', value: Math.round(vmax * 3.6) + ' km/h' }, { label: 'Bónus apanhados', value: String(bonusN) }];
      const crash = (why, k) => {
        if (!X.alive()) return;
        X.snd('crash', 0); X.haptic('heavy'); X.hitStop(.08); X.flashW(.7); X.shake.hit(11);
        const x = sx(cur, PZ), y = GY - jh * M * FP - 30, col = k === 2 ? '#FF9F0A' : k === 3 ? '#BF5AF2' : '#E53935';
        X.fx.burst(x, y, '#5EE7DF', 20, 240, .9, 4, 500); X.fx.burst(x, y, col, 14, 200, .8, 3.5, 500, 1); X.fx.burst(x, y, '#fff', 8, 160, .6, 3, 500, 2);
        dyA = 0; dyY = 0;
        safe(() => Arcade.maxStat && Arcade.maxStat('runnerDist', Math.floor(d)));
        X.die({ title: why, sub: `${Math.floor(d)} m · ${coins} moedas · ${shown} pontos`, score: shown, win: false, stats: stats() }, 1.4);
      };
      const jump = () => { if (!X.alive() || bonus === 3) return; slide = 0; if (jh <= .001) { jv = 9.5; jh = .001; X.snd('jump', 0); X.fx.burst(sx(cur, PZ), GY, 'rgba(255,255,255,.6)', 5, 90, .35, 3); } else buffer = .14; };
      const duck = () => { if (!X.alive() || bonus === 3) return; if (jh > 0) jv = Math.min(jv, -8); slide = .7; X.snd('swish', 0); };
      const lane = dir => { if (!X.alive()) return; const nl = clamp(L + dir, -1, 1); if (nl !== L) { L = nl; X.snd('whoosh', 60); } };
      const giveBonus = k => { bonus = k; bonusT = k === 3 ? 6 : k === 1 ? 9 : 10; bonusShown = -1; bonusN++; X.snd('powerup', 0); X.flash(CAPNAME[k - 1], 'bonus'); X.haptic('light'); if (k === 3) { slide = 0; jv = 0; } hudBonus(); };

      function tick(dt) {
        X.fx.step(dt);
        step += dt * (X.alive() ? v * .9 : 2);
        if (X.dying) { dyA += 6 * dt; dyY += dt; draw(); return; }
        T += dt; ph = 1 + T / 40;
        v = Math.min(32, 12 + T * .3); if (v > vmax) vmax = v;
        if (v >= faster && faster <= 32) { X.flash('Mais rápido', 'big'); faster += 4; X.snd('level', 0); }
        let k = 1; if (grace > 0) { grace -= dt; k = 1 - Math.max(0, grace) / .9 * .8; }
        d += v * k * dt; score += v * k * dt * (bonus === 2 ? 2 : 1);
        cur += (L - cur) * (1 - Math.exp(-14 * dt)); if (Math.abs(L - cur) < .002) cur = L;
        if (bonus === 3) { jh += (2.6 - jh) * Math.min(1, 6 * dt); jv = 0; if (Math.random() < .7) X.fx.one(sx(cur, PZ) + rnd(-6, 6), GY - jh * M * FP - 4, rnd(-20, 20), 120, Math.random() < .5 ? '#FFB020' : '#5AC8FA', .25, 3); }
        else if (jh > 0) { jv -= 26 * dt; jh += jv * dt; if (jh <= 0) { jh = 0; jv = 0; X.snd('land', 0); X.fx.burst(sx(cur, PZ), GY, 'rgba(255,255,255,.5)', 3, 70, .3, 2.5); if (buffer > 0) { buffer = 0; jump(); } } }
        if (buffer > 0) buffer -= dt;
        if (slide > 0) slide -= dt;
        if (bonusT > 0) { bonusT -= dt; const s = Math.ceil(bonusT); if (s !== bonusShown) { bonusShown = s; hudBonus(); } if (bonusT <= 0) { bonus = 0; bonusT = 0; hudBonus(); } }
        while (nextRow < d + 80) { const z = Math.max(nextRow, d + 60); spawnRow(z); nextRow = z + v * rowEvery(); }
        const magnet = bonus === 1, fly = bonus === 3;
        for (let i = objs.length - 1; i >= 0; i--) {
          const o = objs[i], z = o.z - d;
          if (z < PZ - 3) { rm(i); continue; }
          if (o.k === 4 && magnet && z - PZ < 7 && z - PZ > -1) { o.lx += (cur - o.lx) * Math.min(1, 9 * dt); if (z - PZ < 3) o.h += (jh + .3 - o.h) * Math.min(1, 9 * dt); }
          if (Math.abs(z - PZ) > .7) continue;
          const ld = Math.abs(cur - o.lx);
          if (o.k === 4) {
            if ((magnet && Math.abs(z - PZ) < .7) || (ld < .5 && Math.abs(jh - o.h + .3) < .95)) {
              const x = sx(o.lx, PZ), y = GY - o.h * M * FP; const val = bonus === 2 ? 20 : 10; rm(i); coins++; score += val; X.snd('coin', 50);
              X.fx.burst(x, y, '#FFD60A', 6, 140, .4, 3, 0, 2); X.fx.text(x, y - 26, '+' + val, '#FFD60A', 16, .6); if (midCoins) midCoins.textContent = String(coins);
            }
          } else if (o.k === 5) {
            /* a planar (ou num salto alto) a cápsula passa por baixo: trocar o planar por outro bónus deixava cair em cima dos obstáculos */
            if (ld < .5 && Math.abs(z - PZ) < .6 && jh < 1.2) { const x = sx(o.lane, PZ), y = GY - o.h * M * FP; const kind = o.sub + 1; rm(i); X.fx.burst(x, y, CAPCOL[o.sub], 14, 160, .6, 3); giveBonus(kind); }
          } else if (!fly && Math.abs(z - PZ) < .5 && ld < .42) {
            if (o.k === 2) { crash('Bateste num camião', 2); draw(); return; }
            if (o.k === 1 && jh < .8) { crash('Tropeçaste numa barreira', 1); draw(); return; }
            if (o.k === 3 && slide <= 0) { crash('Bateste no túnel', 3); draw(); return; }
          }
        }
        const si = Math.floor(score);
        if (si !== shown) { shown = si; X.A.setScore(si); watchRecord(si); }
        const dm = Math.floor(d); if (midDist && dm !== lastDm) { lastDm = dm; midDist.textContent = dm + ' m'; }
        draw();
      }
      const drawObj = (img, x, y, f) => c.drawImage(img, x - img.width * f / 2, y - img.height * f, img.width * f, img.height * f);
      const runner = () => {
        const x = sx(cur, PZ), lift = jh * M * FP;
        let img = RUN[((step * 1.6 / (Math.PI / 2)) | 0) % 4];
        if (bonus === 3) img = GLIDE; else if (jh > 0) img = JUMP; else if (slide > 0) img = SLIDE;
        const ss = 1 - Math.min(.55, jh * .22); c.drawImage(SHADOW, x - 24 * ss, GY - 7 * ss, 48 * ss, 14 * ss);
        if (X.dying) { const cs = Math.cos(dyA), sn = Math.sin(dyA); c.setTransform(cs, sn, -sn, cs, x, GY - lift - 40 - 60 * Math.sin(Math.min(1, dyY) * Math.PI)); c.drawImage(JUMP, -32, -46); c.setTransform(1, 0, 0, 1, 0, 0); return; }
        if (bonus) { c.globalAlpha = .6 + .25 * Math.sin(step * .5); c.drawImage(AURA[bonus - 1], x - 60, GY - lift - 100); c.globalAlpha = 1; }
        const lean = (L - cur) * -.35;
        if (lean) { const cs = Math.cos(lean), sn = Math.sin(lean); c.setTransform(cs, sn, -sn, cs, x, GY - lift); c.drawImage(img, -img.width / 2, -86); c.setTransform(1, 0, 0, 1, 0, 0); }
        else c.drawImage(img, x - img.width / 2, GY - lift - 86);
        if (bonus === 3) c.drawImage(WING, x - 80, GY - lift - 134 + Math.sin(step * .3) * 2);
      };
      function draw() {
        const pm = ((ph % 4) + 4) % 4, si = pm | 0, sf = pm - si, nf = Math.max(0, 1 - Math.abs(pm - 2));
        c.drawImage(SKY[si & 3], 0, 0);
        if (sf > .01) { c.globalAlpha = sf; c.drawImage(SKY[(si + 1) & 3], 0, 0); c.globalAlpha = 1; }
        let o = ((cur * 14 + d * .12) % 800 + 800) % 800; c.drawImage(CITYF, -o, HY - 118); c.drawImage(CITYF, 800 - o, HY - 118);
        o = ((cur * 26 + d * .3) % 800 + 800) % 800; c.drawImage(CITYN2, -o, HY - 168); c.drawImage(CITYN2, 800 - o, HY - 168);
        if (nf > .02) { c.globalAlpha = nf; c.drawImage(CITYL, -o, HY - 168); c.drawImage(CITYL, 800 - o, HY - 168); c.globalAlpha = 1; }
        c.drawImage(ROADBG, 0, HY);
        if (X.alive()) { const z0 = PZ - 2.5, z1 = PZ + 9; c.beginPath(); c.moveTo(sx(L - .5, z0), sy(z0)); c.lineTo(sx(L - .5, z1), sy(z1)); c.lineTo(sx(L + .5, z1), sy(z1)); c.lineTo(sx(L + .5, z0), sy(z0)); c.closePath(); c.fillStyle = 'rgba(94,231,223,.07)'; c.fill(); }
        c.fillStyle = 'rgba(255,255,255,.34)'; const off = d % 4;
        for (let z = -off; z < 90; z += 4) { const a = Math.max(z, -1), b = z + 2; if (b < -1) continue; for (let e = -.5; e <= .5; e += 1) { const wa = 3 * fz(a), wb = 3 * fz(b); c.beginPath(); c.moveTo(sx(e, a) - wa, sy(a)); c.lineTo(sx(e, b) - wb, sy(b)); c.lineTo(sx(e, b) + wb, sy(b)); c.lineTo(sx(e, a) + wa, sy(a)); c.closePath(); c.fill(); } }
        const poff = d % 6;
        for (let z = 60 - poff; z > -1; z -= 6) { const f = fz(z), hh = .7 * M * f, w = Math.max(1.5, .1 * LW * f); c.globalAlpha = clamp((70 - z) / 15, 0, 1); c.fillStyle = 'rgba(200,210,235,.3)'; for (let e = -1.66; e <= 1.66; e += 3.32) { rr(c, sx(e, z) - w / 2, sy(z) - hh, w, hh, w / 2); c.fill(); } }
        c.globalAlpha = 1;
        if (v > 18 && X.running) { c.globalAlpha = Math.min(.14, (v - 18) / 100); c.strokeStyle = '#fff'; c.lineWidth = 2; for (let i = 0; i < 12; i++) { const a = STREAK[i][0], p = ((d * 3 + STREAK[i][1]) % 100) / 100, r0 = 110 + p * 220; c.beginPath(); c.moveTo(CX + Math.cos(a) * r0, HY + 30 + Math.sin(a) * r0 * .6); c.lineTo(CX + Math.cos(a) * (r0 + 40), HY + 30 + Math.sin(a) * (r0 + 40) * .6); c.stroke(); } c.globalAlpha = 1; }
        /* objetos de longe para perto (os mais recentes estão no fim); a personagem entra quando o primeiro mais perto do que ela aparece */
        let drawn = false;
        for (let i = objs.length - 1; i >= 0; i--) {
          const ob = objs[i], z = ob.z - d;
          if (z > 75 || z < -.5) continue;
          if (!drawn && z < PZ) { runner(); drawn = true; }
          const f = fz(z), y = sy(z);
          c.globalAlpha = clamp((75 - z) / 12, 0, 1);
          if (ob.k === 4) { const fr = (((ob.spin + d * .9) / (Math.PI / 4)) | 0) & 3; const cf = f * 1.1; drawObj(COIN[fr], sx(ob.lx, z), y - ob.h * M * f + 10 * cf, cf); }
          else if (ob.k === 1) drawObj(BAR, sx(ob.lane, z), y + 8 * f, f);
          else if (ob.k === 2) drawObj(TRUCK, sx(ob.lane, z), y + 10 * f, f);
          else if (ob.k === 3) drawObj(TUNNEL, sx(ob.lane, z), y + 6 * f, f);
          else drawObj(CAP[ob.sub], sx(ob.lane, z), y - ob.h * M * f + 20 * f + Math.sin(step * .4) * 3 * f, f * 1.1);
        }
        c.globalAlpha = 1;
        if (!drawn) runner();
        X.fx.draw(c);
        X.post(c);
      }
      function key(e) {
        if (e.type === 'keyup') return;
        const m = ARROWS[e.key]; if (!m) return;
        e.preventDefault();
        if (m === 'left') lane(-1); else if (m === 'right') lane(1); else if (m === 'down') duck(); else if (!e.repeat) jump();
      }
      /* toque = saltar; deslizar = faixa / saltar / baixar; e os quatro botões em baixo */
      let spx = 0, spy = 0, sp = false;
      pointer(X, {
        down: p => { spx = p.x; spy = p.y; sp = true; },
        up: p => { if (!sp) return; const dx = p.x - spx, dy = p.y - spy; sp = false; if (Math.abs(dx) < 14 && Math.abs(dy) < 14) { jump(); return; } if (Math.abs(dx) > Math.abs(dy)) lane(dx > 0 ? 1 : -1); else if (dy < 0) jump(); else duck(); },
      });
      X.A.el.ctl.innerHTML = `<div class="gm-row">${Arcade.btn('grn-l', 'chevL')}${Arcade.btn('grn-u', 'chevU')}${Arcade.btn('grn-d', 'chevD')}${Arcade.btn('grn-r', 'chevR')}</div>`;
      const q = k => X.A.el.ctl.querySelector('.gb.' + k);
      q('grn-l').addEventListener('pointerdown', () => lane(-1)); q('grn-r').addEventListener('pointerdown', () => lane(1));
      q('grn-u').addEventListener('pointerdown', () => jump()); q('grn-d').addEventListener('pointerdown', () => duck());
      start();
      return X.api;
    },
  });

  /* =====================================================================
     4. SALTO (hop): voxel visto de cima; relva, estradas com carros e camiões, rios com troncos, carris com
        comboio, moedas, águia quando se fica parado; personagem com squash and stretch; 3 personagens
     ===================================================================== */
  Icons.app.hop = () => Icons.SVG(Icons.G('gHp', '#8CE99A', '#30D158', '#167A35') + Icons.GL(
    `<rect x="0" y="54" width="100" height="22" fill="#2B2B33"/><rect x="0" y="76" width="100" height="5" fill="#1C1C22"/><path d="M8 65h12M32 65h12M56 65h12M80 65h12" stroke="#fff" stroke-opacity=".6" stroke-width="2.6" stroke-linecap="round"/>` +
    `<rect x="58" y="56" width="28" height="15" rx="4" fill="#FF453A"/><rect x="62" y="58" width="9" height="9" rx="2" fill="#1C1C2E" opacity=".8"/><rect x="84" y="60" width="3" height="5" fill="#FFF4B0"/>` +
    `<path d="M8 36l9-16 9 16z" fill="#167A35"/><rect x="15" y="36" width="4" height="8" fill="#6B4A2B"/>` +
    `<rect x="34" y="20" width="30" height="30" rx="9" fill="#fff"/><rect x="34" y="40" width="30" height="10" rx="5" fill="#E2E4EC"/><path d="M43 15h12v8H43z" fill="#FF453A"/><rect x="58" y="31" width="11" height="7" rx="2.5" fill="#FF9F0A"/><circle cx="54" cy="30" r="2.6" fill="#1C1C1E"/>`));

  Arcade.game('hop', {
    name: 'Salto', color: '#30D158', kind: 'action', tags: ['Voxel', 'Sem fim'],
    desc: 'Atravessa estradas cheias de carros e camiões, rios a saltar de tronco em tronco e carris com comboios. Toca para avançar, desliza para os lados, apanha moedas e não fiques parado: a águia leva-te. Galinha, pato e sapo desbloqueiam-se pela pontuação.',
    howto: { goal: 'Avança o mais longe possível sem seres atropelado nem caíres à água.', steps: ['Toca para dar um salto em frente; desliza para os lados', 'Nos rios só se pisa em cima dos troncos', 'Quando o sinal pisca, vem comboio', 'Se ficares parado, a águia leva-te'], controls: [{ icon: 'hand', label: 'Toca para avançar; desliza para os lados e para trás' }, { icon: 'gamepad', label: 'Setas ou WASD' }] },
    cover: () => `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="chpW" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#2A86E8"/><stop offset="1" stop-color="#1A5FB8"/></linearGradient></defs>` +
      `<rect width="400" height="200" fill="#4CC25E"/><rect y="0" width="400" height="46" fill="#44B556"/><rect y="40" width="400" height="6" fill="#2F8F42"/>` +
      `<rect y="60" width="400" height="44" fill="url(#chpW)"/><rect y="98" width="400" height="6" fill="#174F9A"/><g fill="#8A5A2B"><rect x="30" y="68" width="90" height="26" rx="8"/><rect x="190" y="68" width="120" height="26" rx="8"/></g><g fill="#C48A52"><ellipse cx="34" cy="81" rx="5" ry="11"/><ellipse cx="194" cy="81" rx="5" ry="11"/></g>` +
      `<rect y="116" width="400" height="44" fill="#2B2B33"/><rect y="154" width="400" height="6" fill="#1C1C22"/><path d="M12 150h24M64 150h24M116 150h24M168 150h24M220 150h24M272 150h24M324 150h24M376 150h24" stroke="#fff" stroke-opacity=".4" stroke-width="3"/>` +
      `<g><rect x="250" y="122" width="56" height="30" rx="7" fill="#FF453A"/><rect x="258" y="124" width="40" height="12" rx="5" fill="#FF7A70"/><rect x="266" y="126" width="18" height="10" rx="3" fill="#1C1C2E" opacity=".8"/><rect x="304" y="128" width="4" height="6" fill="#FFF4B0"/></g>` +
      `<g><rect x="70" y="122" width="90" height="30" rx="6" fill="#0A84FF"/><rect x="74" y="124" width="60" height="12" rx="5" fill="#5EB2FF"/><rect x="136" y="126" width="18" height="10" rx="3" fill="#1C1C2E" opacity=".8"/><rect x="68" y="128" width="4" height="6" fill="#FF3B30"/></g>` +
      `<g><path d="M330 30l16-26 16 26z" fill="#1E8E3E"/><path d="M330 30h32v10h-32z" fill="#167A35"/><rect x="342" y="40" width="8" height="10" fill="#6B4A2B"/></g><g><path d="M40 184l12-20 12 20z" fill="#1E8E3E"/><rect x="48" y="184" width="8" height="8" fill="#6B4A2B"/></g>` +
      `<g transform="translate(200 178)"><ellipse cy="6" rx="16" ry="5" fill="rgba(0,0,0,.3)"/><rect x="-14" y="-30" width="28" height="30" rx="9" fill="#fff"/><rect x="-14" y="-12" width="28" height="12" rx="6" fill="#E2E4EC"/><path d="M-6 -36h12v8H-6z" fill="#FF453A"/><rect x="-5" y="-24" width="10" height="6" rx="2" fill="#FF9F0A"/><circle cx="-7" cy="-26" r="2.4" fill="#1C1C1E"/><circle cx="7" cy="-26" r="2.4" fill="#1C1C1E"/></g>` +
      `<circle cx="150" cy="22" r="8" fill="#FFD60A"/><circle cx="150" cy="22" r="4" fill="#FFB800"/></svg>`,
    build(win) {
      const W = 400, H = 560, CELL = 40, COLS = 10, HOPT = .14;
      const CARS = ['#FF453A', '#0A84FF', '#FFD60A', '#BF5AF2', '#FF9F0A', '#64D2FF', '#F2F2F7'];
      const TL = 100 + 4 * 72;
      let rows, px, py, hop, score, cam, camT, scroll, moved, onLog, t, coins, idleT, eagle, face, landT, dead, charKey, unlockedMax, best, optsApi = null, watchRecord = () => {};
      const hopS = { fx: 0, fy: 0, t: 0 }, eagleS = { t: 0, x: 0, y: 0 };
      const X = host(win, {
        id: 'hop', name: 'Salto', color: '#30D158', W, H,
        restart: () => start(), tick, draw, key,
        onResume: () => { scroll = Math.min(scroll, cam); idleT = 0; },
        dbg: { char: k => setChar(k, false), eagle: () => { idleT = 99; }, safe: (dx, dy) => safeAt(dx, dy), score: n => { score = n; X.A.setScore(n); unlocks(); }, train: () => { let r = -1; for (let i = py + 1; i < py + 8; i++) if (rowAt(i).type === 'rail') { r = i; break; } if (r < 0) { r = py + 2; const row = rowAt(r); row.type = 'rail'; row.items = []; row.trees = null; row.coins = null; row.train = { x: 0, dir: 1, speed: 520, state: 0, t: 9 }; } const tr = rows[r].train; tr.state = 2; tr.x = tr.dir > 0 ? -TL + 200 : W - 200; X.snd('drum', 0); return r; }, kill: () => die('Foste atropelado', 'flat'), state: () => ({ px, py, score, coins, cam, charKey, dead, rows: rows.length }) },
      });
      const c = X.ctx;

      /* ----- arte pré-desenhada (voxel: face de cima clara, face da frente escura) ----- */
      const shade = (hex, k) => { const n = parseInt(hex.slice(1), 16); let r = (n >> 16) & 255, g2 = (n >> 8) & 255, b = n & 255; if (k > 0) { r += (255 - r) * k; g2 += (255 - g2) * k; b += (255 - b) * k; } else { r *= 1 + k; g2 *= 1 + k; b *= 1 + k; } return `rgb(${r | 0},${g2 | 0},${b | 0})`; };
      const strip = (top, front, fn) => spr(W, CELL, c2 => { c2.fillStyle = top; c2.fillRect(0, 0, W, CELL); if (fn) fn(c2); c2.fillStyle = front; c2.fillRect(0, CELL - 7, W, 7); c2.fillStyle = 'rgba(255,255,255,.14)'; c2.fillRect(0, 0, W, 2); });
      const GRASS = [strip('#4FC866', '#2F8F42', c2 => { c2.fillStyle = 'rgba(255,255,255,.08)'; for (let i = 0; i < 26; i++) c2.fillRect(rnd(0, W), rnd(4, 30), 3, 2); }), strip('#45B859', '#2A8039', c2 => { c2.fillStyle = 'rgba(0,0,0,.06)'; for (let i = 0; i < 26; i++) c2.fillRect(rnd(0, W), rnd(4, 30), 3, 2); })];
      const ROAD = strip('#33333D', '#1F1F26', c2 => { c2.fillStyle = 'rgba(255,255,255,.22)'; for (let x = 6; x < W; x += 40) c2.fillRect(x, 31, 18, 2); c2.fillStyle = 'rgba(0,0,0,.12)'; for (let i = 0; i < 14; i++) c2.fillRect(rnd(0, W), rnd(2, 28), rnd(4, 14), 2); });
      const RIVER = mk(2, f => strip('#2A86E8', '#174F9A', c2 => { c2.fillStyle = 'rgba(255,255,255,.22)'; for (let i = 0; i < 16; i++) { const x = (i * 53 + f * 21) % W; rr(c2, x, 6 + (i % 3) * 8, 14 + (i % 2) * 8, 3, 1.5); c2.fill(); } c2.fillStyle = 'rgba(0,0,0,.08)'; for (let i = 0; i < 10; i++) { const x = (i * 71 + f * 33) % W; rr(c2, x, 10 + (i % 4) * 6, 18, 3, 1.5); c2.fill(); } }));
      const RAIL = strip('#6B6774', '#45424C', c2 => { c2.fillStyle = '#4E3A2A'; for (let x = 4; x < W; x += 22) c2.fillRect(x, 4, 12, 28); c2.fillStyle = '#B9BCC6'; c2.fillRect(0, 9, W, 3); c2.fillRect(0, 24, W, 3); c2.fillStyle = 'rgba(255,255,255,.35)'; c2.fillRect(0, 9, W, 1); c2.fillRect(0, 24, W, 1); });
      const TREE = mk(2, i => spr(40, 60, c2 => { const h = i ? 22 : 30; c2.fillStyle = 'rgba(0,0,0,.18)'; c2.beginPath(); c2.ellipse(20, 54, 14, 4, 0, 0, TAU); c2.fill(); c2.fillStyle = '#5B3E22'; c2.fillRect(15, 40, 10, 14); c2.fillStyle = '#7A5230'; c2.fillRect(15, 40, 4, 14); c2.fillStyle = '#1E8E3E'; rr(c2, 5, 52 - h - 10, 30, h + 10, 6); c2.fill(); c2.fillStyle = '#36C45F'; rr(c2, 5, 52 - h - 10, 30, h - 6, 6); c2.fill(); c2.fillStyle = '#5BE07E'; rr(c2, 9, 52 - h - 6, 12, 8, 3); c2.fill(); }));
      const carSpr = (col, dir, truck) => { const w = truck ? 80 : 44; return spr(w, 34, c2 => {
        const fw = dir > 0;
        c2.fillStyle = 'rgba(0,0,0,.3)'; rr(c2, 2, 8, w - 2, 24, 6); c2.fill();
        c2.fillStyle = '#17181E'; c2.fillRect(6, 24, 9, 8); c2.fillRect(w - 15, 24, 9, 8);
        c2.fillStyle = shade(col, -.28); rr(c2, 0, 8, w, 22, 6); c2.fill();
        c2.fillStyle = col; rr(c2, 0, 2, w, 20, 6); c2.fill();
        c2.fillStyle = shade(col, .32); rr(c2, 4, 4, w - 8, 7, 3); c2.fill();
        const cab = truck ? (fw ? w - 24 : 4) : (fw ? w * .5 : w * .14), cw = truck ? 20 : w * .36;
        c2.fillStyle = 'rgba(14,20,40,.88)'; rr(c2, cab, 5, cw, 14, 3); c2.fill(); c2.fillStyle = 'rgba(255,255,255,.3)'; c2.fillRect(cab + 2, 6, cw - 4, 3);
        if (truck) { c2.fillStyle = shade(col, -.1); rr(c2, fw ? 2 : 26, 4, w - 28, 18, 3); c2.fill(); c2.fillStyle = 'rgba(255,255,255,.2)'; c2.fillRect(fw ? 4 : 28, 6, w - 32, 3); }
        glow(c2, '#FFF4B0', 6); c2.fillStyle = '#FFF4B0'; const hx = fw ? w - 4 : 0; c2.fillRect(hx, 6, 4, 5); c2.fillRect(hx, 16, 4, 5); noGlow(c2);
        c2.fillStyle = '#FF3B30'; const tx = fw ? 0 : w - 4; c2.fillRect(tx, 6, 4, 5); c2.fillRect(tx, 16, 4, 5);
      }); };
      const CAR = CARS.map(col => [carSpr(col, -1, false), carSpr(col, 1, false)]), TRUCK = CARS.map(col => [carSpr(col, -1, true), carSpr(col, 1, true)]);
      const LOCO = mk(2, i => spr(100, 36, c2 => { const fw = i === 1; c2.fillStyle = 'rgba(0,0,0,.3)'; rr(c2, 2, 10, 98, 24, 5); c2.fill(); c2.fillStyle = '#4A1020'; rr(c2, 0, 8, 100, 24, 5); c2.fill(); c2.fillStyle = '#8E1C3A'; rr(c2, 0, 2, 100, 20, 5); c2.fill(); c2.fillStyle = '#C4365C'; rr(c2, 4, 4, 92, 6, 3); c2.fill(); c2.fillStyle = '#FFD60A'; c2.fillRect(0, 16, 100, 4); c2.fillStyle = 'rgba(14,20,40,.9)'; for (let k = 0; k < 4; k++) rr(c2, (fw ? 10 : 30) + k * 15, 6, 10, 9, 2); c2.fill(); glow(c2, '#FFF4B0', 8); c2.fillStyle = '#FFF4B0'; c2.fillRect(fw ? 96 : 0, 8, 4, 10); noGlow(c2); }));
      const WAGON = spr(72, 36, c2 => { c2.fillStyle = 'rgba(0,0,0,.3)'; rr(c2, 2, 10, 70, 24, 4); c2.fill(); c2.fillStyle = '#2E4A7A'; rr(c2, 0, 8, 72, 24, 4); c2.fill(); c2.fillStyle = '#4A74B8'; rr(c2, 0, 2, 72, 20, 4); c2.fill(); c2.fillStyle = '#6F9BE0'; rr(c2, 4, 4, 64, 6, 3); c2.fill(); c2.fillStyle = 'rgba(0,0,0,.2)'; for (let k = 0; k < 5; k++) c2.fillRect(8 + k * 14, 4, 2, 16); });
      const LOG = [80, 120, 160].map(w => spr(w, 30, c2 => { c2.fillStyle = 'rgba(0,0,0,.25)'; rr(c2, 2, 6, w, 24, 10); c2.fill(); c2.fillStyle = lgrad(c2, 0, 2, 0, 28, [[0, '#A8713A'], [.5, '#8A5A2B'], [1, '#5E3B18']]); rr(c2, 0, 2, w, 26, 10); c2.fill(); c2.fillStyle = 'rgba(255,255,255,.14)'; c2.fillRect(10, 5, w - 20, 3); c2.fillStyle = 'rgba(0,0,0,.14)'; for (let k = 16; k < w - 12; k += 18) c2.fillRect(k, 10, 2, 12); for (let e = 0; e < 2; e++) { const x = e ? w - 9 : 9; c2.fillStyle = '#D9A066'; c2.beginPath(); c2.ellipse(x, 15, 7, 11, 0, 0, TAU); c2.fill(); c2.strokeStyle = 'rgba(90,50,20,.55)'; c2.lineWidth = 1.2; c2.beginPath(); c2.ellipse(x, 15, 4.5, 7, 0, 0, TAU); c2.stroke(); c2.beginPath(); c2.ellipse(x, 15, 2, 3.5, 0, 0, TAU); c2.stroke(); } }));
      const COINS = spr(24, 24, c2 => { glow(c2, 'rgba(255,200,40,.7)', 7); c2.fillStyle = '#C98A00'; c2.beginPath(); c2.arc(12, 12, 9, 0, TAU); c2.fill(); noGlow(c2); c2.fillStyle = lgrad(c2, 0, 3, 0, 21, [[0, '#FFF1A8'], [.5, '#FFD60A'], [1, '#E09A00']]); c2.beginPath(); c2.arc(12, 12, 6.5, 0, TAU); c2.fill(); c2.fillStyle = 'rgba(255,255,255,.6)'; c2.beginPath(); c2.ellipse(9.5, 8.5, 2.5, 1.5, -.6, 0, TAU); c2.fill(); });
      const SIGNAL = mk(2, on => spr(18, 40, c2 => { c2.fillStyle = '#3A3A44'; c2.fillRect(7, 10, 4, 28); c2.fillStyle = '#2A2A33'; rr(c2, 2, 2, 14, 14, 4); c2.fill(); if (on) { glow(c2, '#FF453A', 10); c2.fillStyle = '#FF5A50'; } else c2.fillStyle = '#4A1A1A'; c2.beginPath(); c2.arc(9, 9, 4.5, 0, TAU); c2.fill(); noGlow(c2); }));
      const FLAG = spr(22, 30, c2 => { c2.fillStyle = '#E8E8F0'; c2.fillRect(3, 2, 3, 28); c2.fillStyle = '#FF453A'; c2.beginPath(); c2.moveTo(6, 3); c2.lineTo(21, 9); c2.lineTo(6, 15); c2.closePath(); c2.fill(); });
      /* personagens (vistas de cima e à frente, a olhar para cima): galinha, pato, sapo */
      const charSpr = kind => spr(40, 44, c2 => {
        c2.translate(20, 40);
        c2.fillStyle = 'rgba(0,0,0,.3)'; c2.beginPath(); c2.ellipse(0, 1, 13, 5, 0, 0, TAU); c2.fill();
        if (kind === 'sapo') {
          c2.fillStyle = '#2E8B3E'; rr(c2, -13, -22, 26, 22, 8); c2.fill(); c2.fillStyle = '#4FC25A'; rr(c2, -13, -30, 26, 20, 8); c2.fill(); c2.fillStyle = '#8CE99A'; rr(c2, -9, -28, 18, 6, 3); c2.fill();
          c2.fillStyle = '#2E8B3E'; rr(c2, -16, -8, 8, 9, 3); c2.fill(); rr(c2, 8, -8, 8, 9, 3); c2.fill();
          for (let e = -1; e <= 1; e += 2) { c2.fillStyle = '#4FC25A'; c2.beginPath(); c2.arc(e * 8, -31, 6, 0, TAU); c2.fill(); c2.fillStyle = '#fff'; c2.beginPath(); c2.arc(e * 8, -32, 4.2, 0, TAU); c2.fill(); c2.fillStyle = '#1C1C1E'; c2.beginPath(); c2.arc(e * 8, -33, 2.2, 0, TAU); c2.fill(); }
          c2.fillStyle = '#1C1C1E'; c2.fillRect(-5, -24, 10, 1.5);
        } else {
          const duck = kind === 'pato', body = duck ? '#FFD23F' : '#FFFFFF', front = duck ? '#D9A800' : '#D5D7E0';
          c2.fillStyle = front; rr(c2, -12, -22, 24, 22, 8); c2.fill(); c2.fillStyle = body; rr(c2, -12, -34, 24, 24, 8); c2.fill();
          c2.fillStyle = 'rgba(255,255,255,.5)'; rr(c2, -8, -32, 16, 5, 2.5); c2.fill();
          c2.fillStyle = duck ? '#E8B800' : '#E6E7EE'; rr(c2, -16, -20, 6, 12, 3); c2.fill(); rr(c2, 10, -20, 6, 12, 3); c2.fill();
          if (duck) { c2.fillStyle = '#0A84FF'; rr(c2, -9, -40, 18, 8, 4); c2.fill(); c2.fillStyle = '#5EB2FF'; rr(c2, -9, -40, 18, 3, 1.5); c2.fill(); }
          else { c2.fillStyle = '#FF453A'; rr(c2, -5, -41, 10, 8, 3); c2.fill(); c2.fillStyle = '#FF7A70'; rr(c2, -5, -41, 10, 3, 1.5); c2.fill(); }
          c2.fillStyle = '#FF9F0A'; rr(c2, -5, -29, 10, duck ? 7 : 5, 2.5); c2.fill(); c2.fillStyle = '#E07A00'; c2.fillRect(-5, duck ? -24 : -26, 10, 2);
          c2.fillStyle = '#1C1C1E'; c2.beginPath(); c2.arc(-7, -31, 2.4, 0, TAU); c2.fill(); c2.beginPath(); c2.arc(7, -31, 2.4, 0, TAU); c2.fill(); c2.fillStyle = '#fff'; c2.beginPath(); c2.arc(-6, -32, .9, 0, TAU); c2.fill(); c2.beginPath(); c2.arc(8, -32, .9, 0, TAU); c2.fill();
          if (!duck) { c2.fillStyle = '#FF453A'; rr(c2, -3, -26, 6, 4, 2); c2.fill(); }
        }
      });
      const CHARS = { galinha: charSpr('galinha'), pato: charSpr('pato'), sapo: charSpr('sapo') };
      const EAGLE = mk(2, f => spr(110, 60, c2 => { c2.translate(55, 30); c2.fillStyle = '#5A3A1E'; c2.beginPath(); c2.moveTo(0, -4); c2.lineTo(-52, f ? -22 : 6); c2.lineTo(-44, 8); c2.lineTo(-6, 8); c2.closePath(); c2.fill(); c2.beginPath(); c2.moveTo(0, -4); c2.lineTo(52, f ? -22 : 6); c2.lineTo(44, 8); c2.lineTo(6, 8); c2.closePath(); c2.fill(); c2.fillStyle = '#7A4E28'; c2.beginPath(); c2.ellipse(0, 4, 12, 16, 0, 0, TAU); c2.fill(); c2.fillStyle = '#F4F4F8'; c2.beginPath(); c2.arc(0, -10, 8, 0, TAU); c2.fill(); c2.fillStyle = '#FFB020'; c2.beginPath(); c2.moveTo(-3, -8); c2.lineTo(3, -8); c2.lineTo(0, 0); c2.closePath(); c2.fill(); c2.fillStyle = '#1C1C1E'; c2.beginPath(); c2.arc(-3, -12, 1.6, 0, TAU); c2.fill(); c2.beginPath(); c2.arc(3, -12, 1.6, 0, TAU); c2.fill(); c2.fillStyle = '#FFB020'; c2.fillRect(-6, 18, 3, 7); c2.fillRect(3, 18, 3, 7); }));

      /* ----- HUD (meio): moedas e personagem ----- */
      let midCoins = null;
      const charLabel = k => (HOP_CHARS.find(ch => ch.v === k) || HOP_CHARS[0]).label;
      const buildMid = () => { X.A.setMid(`<span class="ga-mid">${cap('ghp-coins', COIN_SVG)}<span class="ga-cap ghp-char">${charLabel(charKey)}</span></span>`); midCoins = X.A.el.mid.querySelector('.ghp-coins b'); midCoins.textContent = String(coins); };

      /* ----- mundo ----- */
      const rowY = r => H - 100 - (r - cam) * CELL;
      const genRow = r => {
        const prev = rows[r - 1];
        let type;
        if (r < 3) type = 'grass';
        else {
          const run = prev.run || 0;
          if (prev.type !== 'grass' && prev.type !== 'rail' && run < (prev.type === 'road' ? 3 : 2) && Math.random() < .55) type = prev.type;
          else if (prev.type !== 'grass' && Math.random() < .6) type = 'grass';
          else { const q = Math.random(); type = q < .46 ? 'road' : q < .74 ? 'river' : (r >= 8 && q < .86) ? 'rail' : 'grass'; }
        }
        const row = { type, run: prev && prev.type === type ? (prev.run || 0) + 1 : 0, items: [], dir: Math.random() < .5 ? -1 : 1, span: 0, speed: 0, trees: null, coins: null, train: null };
        const diff = Math.min(1, r / 120);
        if (type === 'grass') {
          row.trees = []; row.coins = [];
          if (r >= 1) { const n = (Math.random() * 3) | 0; for (let i = 0; i < n; i++) { const cx = (Math.random() * COLS) | 0; if (r < 3 && cx === 4) continue; row.trees.push(cx); } }
          if (r >= 2 && Math.random() < .22) { const cx = (Math.random() * COLS) | 0; if (row.trees.indexOf(cx) < 0) row.coins.push(cx); }
        } else if (type === 'road') {
          row.speed = rnd(55, 95) + diff * 80; const gap = rnd(140, 260) - diff * 60, truck = Math.random() < .25, carW = truck ? 80 : 44;
          let x = rnd(0, W); for (let i = 0; i < 5; i++) { row.items.push({ x, w: carW, ci: (Math.random() * CARS.length) | 0, truck }); x += carW + gap; } row.span = 5 * (carW + gap);
        } else if (type === 'river') {
          row.speed = rnd(35, 70) + diff * 40; const gap = rnd(70, 130);
          let x = rnd(0, W), span = 0; for (let i = 0; i < 4; i++) { const li = (Math.random() * 3) | 0; const w = [80, 120, 160][li]; row.items.push({ x, w, li }); x += w + gap; span += w + gap; } row.span = span;
        } else {
          row.train = { x: -TL, dir: Math.random() < .5 ? -1 : 1, speed: 460 + diff * 120, state: 0, t: rnd(1.5, 4) };
        }
        rows.push(row);
      };
      const rowAt = r => { while (rows.length <= r) genRow(rows.length); return rows[r]; };
      const unlocked = k => (HOP_CHARS.find(ch => ch.v === k) || HOP_CHARS[0]).need <= unlockedMax;
      const buildOptions = () => {
        optsApi = safe(() => X.A.options([{ key: 'char', label: 'Personagem', values: HOP_CHARS.map(ch => ({ v: ch.v, label: unlocked(ch.v) ? ch.label : `${ch.label} (${ch.need})` })), cur: charKey, onChange: v => setChar(v, false) }])) || null;
      };
      const setChar = (k, force) => {
        if (!CHARS[k]) return;
        if (!unlocked(k) && !force) { const ch = HOP_CHARS.find(x => x.v === k); X.toast(`Chega a ${ch.need} passos para desbloquear`); if (optsApi && optsApi.set) optsApi.set('char', charKey); return; }
        charKey = k; Arcade.setOpt('hop:char', k); const el = X.A.el.mid.querySelector('.ghp-char'); if (el) el.textContent = charLabel(k); if (optsApi && optsApi.set) optsApi.set('char', k);
      };
      const unlocks = () => {
        for (let i = 0; i < HOP_CHARS.length; i++) { const ch = HOP_CHARS[i]; if (ch.need > 0 && score >= ch.need && unlockedMax < ch.need) { unlockedMax = score; Arcade.setOpt('hop:max', score); X.flash(`${ch.label}: nova personagem`, 'bonus'); X.snd('chime', 0); X.celebrate('level'); safe(() => Arcade.flag && Arcade.flag('hopChar')); buildOptions(); } }
        if (score > unlockedMax) { unlockedMax = score; Arcade.setOpt('hop:max', score); }
      };
      const reset = () => {
        rows = []; px = 4; py = 0; hop = false; score = 0; cam = 0; camT = 0; scroll = 0; moved = false; onLog = null; t = 0; coins = 0; idleT = 0; eagle = false; face = 0; landT = 0; dead = '';
        for (let i = 0; i < 18; i++) genRow(i);
        best = safe(() => Arcade.best('hop')) || 0; unlockedMax = Math.max(best, +Arcade.opt('hop:max', 0) || 0);
        charKey = String(Arcade.opt('hop:char', 'galinha') || 'galinha'); if (!CHARS[charKey] || !unlocked(charKey)) charKey = 'galinha';
        watchRecord = recordWatch(X, 'hop');
        X.A.setScore(0); buildMid();
      };
      const start = () => { reset(); X.begin('Salto', 'Toca para avançar, desliza para os lados'); };
      const stats = () => [{ label: 'Passos', value: String(score) }, { label: 'Moedas', value: String(coins) }, { label: 'Personagem', value: charLabel(charKey) }, { label: 'Tempo', value: Math.round(safe(() => X.A.elapsed()) || 0) + ' s' }];
      const die = (why, kind) => {
        if (!X.alive()) return;
        dead = kind || 'flat'; X.haptic('heavy');
        const x = px * CELL + CELL / 2, y = rowY(py) + CELL / 2;
        if (dead === 'flat') { X.snd('crash', 0); X.hitStop(.08); X.flashW(.6); X.shake.hit(10); X.fx.burst(x, y, '#fff', 16, 180, .8, 4); X.fx.burst(x, y, charKey === 'sapo' ? '#4FC25A' : charKey === 'pato' ? '#FFD23F' : '#FF453A', 10, 150, .7, 3, 0, 1); }
        else if (dead === 'water') { X.snd('splash', 0); X.flashW(.2); X.fx.burst(x, y, '#9AD0FF', 18, 160, .7, 3, 300); X.fx.burst(x, y, '#fff', 8, 120, .5, 2.5, 300); }
        else { X.snd('whoosh', 0); X.fx.burst(x, y, '#8A5A2B', 8, 120, .6, 3, 200, 1); }
        X.die({ title: why, sub: `${score} passos · ${coins} moedas`, score, win: false, stats: stats() }, dead === 'eagle' ? 1.4 : 1.2);
      };
      /* aterrar: num rio tem de haver um tronco debaixo do pé; na relva pode haver moeda */
      const land = () => {
        const row = rows[py]; onLog = null; landT = .12; X.snd('land', 40);
        if (row.type === 'river') {
          const cx = px * CELL + CELL / 2;
          for (let i = 0; i < row.items.length; i++) { const it = row.items[i]; if (cx >= it.x - 4 && cx <= it.x + it.w + 4) { onLog = it; break; } }
          if (!onLog) { die('Caíste à água', 'water'); return; }
        } else if (row.type === 'grass' && row.coins) {
          const i = row.coins.indexOf(Math.round(px));
          if (i >= 0) { row.coins.splice(i, 1); coins++; X.snd('coin', 0); if (midCoins) midCoins.textContent = String(coins); X.fx.burst(px * CELL + CELL / 2, rowY(py) + 8, '#FFD60A', 8, 140, .5, 3, 0, 2); X.fx.text(px * CELL + CELL / 2, rowY(py) - 10, '+1', '#FFD60A', 16, .6); }
        }
      };
      /* só para o harness (cenas determinísticas): o salto (dx, dy) aterra num sítio seguro durante o próximo meio segundo? */
      const safeAt = (dx, dy) => {
        if (!rows || hop) return false;
        const nx = Math.round(px) + dx, ny = py + dy;
        if (nx < 0 || nx >= COLS || ny < 0) return false;
        const row = rowAt(ny), cx = nx * CELL + CELL / 2;
        if (row.type === 'grass') return row.trees.indexOf(nx) < 0;
        if (row.type === 'rail') return row.train.state === 0 && row.train.t > 1.2;
        for (let s = HOPT; s <= HOPT + .55; s += .1) {
          let hit = row.type !== 'road';
          for (let i = 0; i < row.items.length; i++) {
            const it = row.items[i], x = it.x + row.dir * row.speed * s;
            if (row.type === 'road' && cx > x - 22 && cx < x + it.w + 22) return false;
            if (row.type === 'river' && cx >= x + 6 && cx <= x + it.w - 6) hit = false;
          }
          if (row.type === 'river' && hit) return false;
        }
        return true;
      };
      const move = (dx, dy) => {
        if (!X.alive() || hop || eagle) return;
        const nx = Math.round(px) + dx, ny = py + dy;
        if (nx < 0 || nx >= COLS || ny < 0 || ny < Math.floor(cam) - 1) return;
        const row = rowAt(ny);
        if (row.type === 'grass' && row.trees.indexOf(nx) >= 0) { X.snd('tick', 0); return; }
        hopS.fx = px; hopS.fy = py; hopS.t = 0; hop = true; px = nx; py = ny; onLog = null; moved = true; idleT = 0;
        face = dx > 0 ? HPI : dx < 0 ? -HPI : dy < 0 ? Math.PI : 0;
        if (py > score) { score = py; X.A.setScore(score); if (score % 25 === 0) { X.flash(`${score} passos`, 'big'); X.snd('level', 0); } unlocks(); watchRecord(score); }
        X.snd('jump', 40);
      };
      function tick(dt) {
        X.fx.step(dt); t += dt;
        const r0 = Math.max(0, Math.floor(cam) - 3), r1 = Math.floor(cam) + 16;
        for (let r = r0; r <= r1; r++) {
          const row = rowAt(r);
          if (row.train) {
            const tr = row.train;
            if (tr.state === 0) { tr.t -= dt; if (tr.t <= 0) { tr.state = 1; tr.t = 1.3; } }
            else if (tr.state === 1) { tr.t -= dt; if (tr.t <= 0) { tr.state = 2; tr.x = tr.dir > 0 ? -TL : W; if (Math.abs(r - py) < 6) X.snd('drum', 0); } }
            else { tr.x += tr.dir * tr.speed * dt; if ((tr.dir > 0 && tr.x > W + 10) || (tr.dir < 0 && tr.x + TL < -10)) { tr.state = 0; tr.t = rnd(3, 6); } }
            continue;
          }
          if (!row.items.length) continue;
          for (let i = 0; i < row.items.length; i++) { const it = row.items[i]; it.x += row.dir * row.speed * dt; if (row.dir > 0 && it.x > W + 60) it.x -= row.span; else if (row.dir < 0 && it.x + it.w < -60) it.x += row.span; }
        }
        if (landT > 0) landT -= dt;
        if (X.dying) {
          if (dead === 'eagle') { eagleS.t += dt; }
          draw(); return;
        }
        if (eagle) {
          eagleS.t += dt;
          if (eagleS.t >= .55) { eagle = false; eagleS.t = 0; die('A águia levou-te', 'eagle'); }
          draw(); return;
        }
        if (hop) { hopS.t += dt; if (hopS.t >= HOPT) { hop = false; land(); if (X.dying) { draw(); return; } } }
        const row = rows[py];
        if (!hop) {
          if (row.type === 'river') { if (onLog) { px += row.dir * row.speed * dt / CELL; if (px < -.3 || px > COLS - .7) { die('A corrente levou-te', 'water'); draw(); return; } } }
          else if (row.type === 'road') { const cx = px * CELL + CELL / 2; for (let i = 0; i < row.items.length; i++) { const it = row.items[i]; if (cx > it.x - 10 && cx < it.x + it.w + 10) { die('Foste atropelado', 'flat'); draw(); return; } } }
          else if (row.train && row.train.state === 2) { const cx = px * CELL + CELL / 2, tr = row.train; if (cx > tr.x - 8 && cx < tr.x + TL + 8) { die('O comboio apanhou-te', 'flat'); draw(); return; } }
        }
        if (moved) { scroll += dt * Math.min(1.2, .25 + score * .004); idleT += dt; }
        camT = Math.max(camT, py - 4, scroll); cam += (camT - cam) * (1 - Math.exp(-6 * dt));
        if ((rowY(py) > H + 10 || idleT > 6) && !eagle) { eagle = true; eagleS.t = 0; eagleS.x = px * CELL + CELL / 2; X.snd('whoosh', 0); }
        draw();
      }
      function draw() {
        const r0 = Math.floor(cam) - 3, r1 = Math.floor(cam) + 16, pr = Math.round(hop ? hopS.fy + (py - hopS.fy) * Math.min(1, hopS.t / HOPT) : py);
        const wf = ((t * 2.5) | 0) & 1;
        for (let r = r1; r >= r0; r--) {
          /* antes da partida: relva lisa (a tela nunca fica por pintar) */
          if (r < 0) { const y = rowY(r); if (y < H + CELL) c.drawImage(GRASS[r & 1], 0, y); continue; }
          const row = rowAt(r), y = rowY(r);
          if (y > H + CELL || y + CELL < -CELL) { if (r === pr) player(); continue; }
          if (row.type === 'grass') {
            c.drawImage(GRASS[r & 1], 0, y);
            if (row.coins) for (let i = 0; i < row.coins.length; i++) c.drawImage(COINS, row.coins[i] * CELL + 8, y + 6 + Math.sin(t * 5 + i) * 2);
            if (r === pr) player();
            for (let i = 0; i < row.trees.length; i++) c.drawImage(TREE[(row.trees[i] + r) & 1], row.trees[i] * CELL, y - 20);
          } else if (row.type === 'road') {
            c.drawImage(ROAD, 0, y);
            if (r === pr) player();
            for (let i = 0; i < row.items.length; i++) { const it = row.items[i]; if (it.x > W + 10 || it.x + it.w < -10) continue; c.drawImage((it.truck ? TRUCK : CAR)[it.ci][row.dir > 0 ? 1 : 0], it.x, y + 2); }
          } else if (row.type === 'river') {
            c.drawImage(RIVER[(wf + r) & 1], 0, y);
            for (let i = 0; i < row.items.length; i++) { const it = row.items[i]; if (it.x > W + 10 || it.x + it.w < -10) continue; c.drawImage(LOG[it.li], it.x, y + 4); }
            if (r === pr) player();
          } else {
            c.drawImage(RAIL, 0, y);
            const tr = row.train, on = tr.state === 2 || (tr.state === 1 && (((tr.t * 8) | 0) & 1) === 0);
            c.drawImage(SIGNAL[on ? 1 : 0], 4, y - 14); c.drawImage(SIGNAL[on ? 1 : 0], W - 22, y - 14);
            if (r === pr) player();
            if (tr.state === 2) { const fw = tr.dir > 0; if (fw) { for (let k = 0; k < 4; k++) c.drawImage(WAGON, tr.x + k * 72, y + 1); c.drawImage(LOCO[1], tr.x + 288, y + 1); } else { c.drawImage(LOCO[0], tr.x, y + 1); for (let k = 0; k < 4; k++) c.drawImage(WAGON, tr.x + 100 + k * 72, y + 1); } }
          }
        }
        /* linha do recorde na relva */
        if (best > 0) { const y = rowY(best) + CELL; if (y > -10 && y < H + 10) { c.strokeStyle = 'rgba(255,255,255,.6)'; c.lineWidth = 2; c.setLineDash(DASH); c.beginPath(); c.moveTo(0, y); c.lineTo(W, y); c.stroke(); c.setLineDash(NODASH); c.drawImage(FLAG, 6, y - 30); txt(c, String(best), W - 14, y - 10, 14, 'rgba(255,255,255,.85)', 800, 'right'); } }
        if (eagle || dead === 'eagle') {
          const k = Math.min(1, eagleS.t / .5), ex = eagleS.x, lift = dead === 'eagle' ? (eagleS.t) * 420 : 0;
          const ey = (X.dying ? rowY(py) + CELL / 2 - 8 : -40 + (rowY(py) + CELL / 2 - 8 + 40) * k) - lift;
          c.drawImage(EAGLE[((t * 10) | 0) & 1], ex - 55, ey - 40);
        }
        X.fx.draw(c);
        c.fillStyle = 'rgba(0,0,0,.25)'; c.fillRect(0, 0, W, 6);
        X.post(c);
      }
      const DASH = [8, 8], NODASH = [];
      const player = () => {
        let vx = px, vy = py, lift = 0, sxk = 1, syk = 1;
        if (hop) { const k = Math.min(1, hopS.t / HOPT), s = Math.sin(k * Math.PI); vx = hopS.fx + (px - hopS.fx) * k; vy = hopS.fy + (py - hopS.fy) * k; lift = s * 16; sxk = 1 - .22 * s; syk = 1 + .32 * s; }
        else if (landT > 0) { const k = landT / .12; sxk = 1 + .28 * k; syk = 1 - .24 * k; }
        if (dead === 'flat') { sxk = 1.7; syk = .22; } else if (dead === 'water') { sxk = syk = .8; c.globalAlpha = .55; lift = -6; }
        else if (dead === 'eagle') lift = eagleS.t * 420 + 14;
        const x = vx * CELL + CELL / 2, y = rowY(vy) + CELL / 2 + 8 - lift;
        if (!dead || dead === 'eagle') { c.fillStyle = 'rgba(0,0,0,.22)'; c.beginPath(); c.ellipse(x, rowY(vy) + CELL / 2 + 10, 12 * sxk, 5, 0, 0, TAU); c.fill(); }
        const cs = Math.cos(face), sn = Math.sin(face);
        c.setTransform(sxk * cs, sxk * sn, -syk * sn, syk * cs, x, y - 16);
        c.drawImage(CHARS[charKey], -20, -24);
        c.setTransform(1, 0, 0, 1, 0, 0); c.globalAlpha = 1;
      };
      function key(e) {
        if (e.type === 'keyup') return;
        const m = ARROWS[e.key]; if (!m) return;
        e.preventDefault(); if (e.repeat) return;
        if (m === 'left') move(-1, 0); else if (m === 'right') move(1, 0); else if (m === 'down') move(0, -1); else move(0, 1);
      }
      let spx = 0, spy = 0, sp = false;
      pointer(X, {
        down: p => { spx = p.x; spy = p.y; sp = true; },
        up: p => { if (!sp) return; const dx = p.x - spx, dy = p.y - spy; sp = false; if (Math.abs(dx) < 14 && Math.abs(dy) < 14) { move(0, 1); return; } if (Math.abs(dx) > Math.abs(dy)) move(dx > 0 ? 1 : -1, 0); else move(0, dy < 0 ? 1 : -1); },
      });
      X.A.el.ctl.innerHTML = `<div class="gm-pad ghp-pad">${Arcade.btn('u ghp-u', 'chevU')}${Arcade.btn('l ghp-l', 'chevL')}${Arcade.btn('d ghp-d', 'chevD')}${Arcade.btn('r ghp-r', 'chevR')}</div>`;
      const q = k => X.A.el.ctl.querySelector('.gb.' + k);
      q('ghp-u').addEventListener('pointerdown', () => move(0, 1)); q('ghp-d').addEventListener('pointerdown', () => move(0, -1));
      q('ghp-l').addEventListener('pointerdown', () => move(-1, 0)); q('ghp-r').addEventListener('pointerdown', () => move(1, 0));
      reset(); buildOptions();
      start();
      return X.api;
    },
  });

  /* lógica pura exposta para o teste em Node (harness/test_action.mjs); nada no telemóvel usa isto */
  Arcade.action = { segDist, pillarHit, Fx, medalFor, chainMult, hopUnlock, MEDAL_AT };
})();
