/* ===================== JOGOS DE AÇÃO 2 - apex_phone 1.5.0 (ronda 2) =====================
   Quatro jogos de ação em canvas 2D sobre a casca comum do games.js (Arcade.shell e as extensões
   1.5.0: A.ready, A.options, A.flash, A.haptic, A.sfx, A.end; ronda 2, chamadas de forma defensiva:
   A.countdown, A.celebrate, A.toast, A.timeScale):
   Pong (pong), Hóquei de mesa (airhockey), Corte (slice) e Torre (stack).
   Ficheiro AUTÓNOMO: tem a sua cópia dos utilitários (Fx, host, pointer, keys, shaker, sprites);
   nada é partilhado com games-action.js além da casca.

   Regras cumpridas em todos (SPEC §2, §6; SPEC-GAMES-2 §1):
     · NENHUM jogo arranca sozinho: o primeiro quadro é estático e o ciclo só começa depois do
       A.ready() resolver (toque no "Toca para começar"); os de reflexos contam 3-2-1 a seguir.
     · UM requestAnimationFrame por jogo (Arcade.loop), que morre em pause()/onClose e retoma sem
       salto de tempo (o loop reinicia o relógio no start()).
     · Canvas em tamanho lógico fixo (sem DPR); em pé 400 de largura, o shell encolhe com zoom quando
       o aparelho está deitado (A.fit).
     · Toda a arte é PRÉ-DESENHADA uma vez em canvas fora do ecrã (gradientes, shadowBlur, veios,
       frutos, batedores, raquetes, fundos); por frame só drawImage, fillRect, poucos arcos e os
       números do placar. Zero filter/shadowBlur/gradientes por frame.
     · Nada de alocações por frame: partículas, textos a flutuar, rastos, metades de fruto, salpicos,
       pedaços da torre e frutos vivem em pools fixos; os rastos são ring buffers tipados.
     · Game feel: hit stop (dt congelado 40 a 90 ms), câmara lenta 0,3× na morte, flash branco no
       palco, abanão por transform curto na própria tela, partículas com a cor do que foi destruído.
     · Texto visível em PT no DOM (HUD, flashes, fim de jogo); dentro da tela só números e sinais.
   ============================================================================= */
(() => {
  if (!window.Arcade || !Arcade.shell) return;
  const g = UI.g;

  /* ---------- utilitários ---------- */
  const TAU = Math.PI * 2;
  const clamp = (v, a, b) => (v < a ? a : v > b ? b : v);
  const rnd = (a, b) => a + Math.random() * (b - a);
  const pick = a => a[(Math.random() * a.length) | 0];
  const hyp = Math.hypot;
  const FONT = "Inter, -apple-system, 'Segoe UI', Roboto, sans-serif";
  const rr = (c, x, y, w, h, r) => { r = Math.max(0, Math.min(r, w / 2, h / 2)); c.beginPath(); c.moveTo(x + r, y); c.arcTo(x + w, y, x + w, y + h, r); c.arcTo(x + w, y + h, x, y + h, r); c.arcTo(x, y + h, x, y, r); c.arcTo(x, y, x + w, y, r); c.closePath(); };
  const segDist = (px, py, ax, ay, bx, by) => { const dx = bx - ax, dy = by - ay, l = dx * dx + dy * dy; const u = l ? clamp(((px - ax) * dx + (py - ay) * dy) / l, 0, 1) : 0; return hyp(px - (ax + u * dx), py - (ay + u * dy)); };
  const txt = (c, s, x, y, size, col, weight, align) => { c.font = `${weight || 700} ${size}px ${FONT}`; c.textAlign = align || 'center'; c.textBaseline = 'middle'; c.fillStyle = col || '#fff'; c.fillText(s, x, y); };
  const lgrad = (c, x0, y0, x1, y1, stops) => { const gr = c.createLinearGradient(x0, y0, x1, y1); stops.forEach(s => gr.addColorStop(s[0], s[1])); return gr; };
  const rgrad = (c, x0, y0, r0, x1, y1, r1, stops) => { const gr = c.createRadialGradient(x0, y0, r0, x1, y1, r1); stops.forEach(s => gr.addColorStop(s[0], s[1])); return gr; };
  const hint = s => `<span class="gm-hint">${s}</span>`;
  const hsl = (h, s, l, a) => (a == null ? `hsl(${Math.round(h) % 360},${s}%,${l}%)` : `hsla(${Math.round(h) % 360},${s}%,${l}%,${a})`);

  /* sprite: canvas fora do ecrã desenhado UMA vez (aqui pode haver gradientes, shadowBlur, tudo) */
  const spr = (w, h, draw) => { const cv = document.createElement('canvas'); cv.width = Math.max(1, Math.ceil(w)); cv.height = Math.max(1, Math.ceil(h)); const c = cv.getContext('2d'); draw(c, cv.width, cv.height); return cv; };
  /* disco macio (partículas, rastos, brilhos): cache por cor e raio */
  const DOTS = {};
  const dot = (col, r) => {
    const k = col + '|' + r; if (DOTS[k]) return DOTS[k];
    return (DOTS[k] = spr(r * 2 + 2, r * 2 + 2, (c, w, h) => { c.fillStyle = rgrad(c, w / 2, h / 2, 0, w / 2, h / 2, r, [[0, col], [.55, col], [1, 'rgba(0,0,0,0)']]); c.fillRect(0, 0, w, h); }));
  };
  /* halo luminoso (néon): disco com glow grande, cache por cor */
  const GLOWS = {};
  const glow = (col, r) => {
    const k = col + '|' + r; if (GLOWS[k]) return GLOWS[k];
    return (GLOWS[k] = spr(r * 4, r * 4, (c, w, h) => { c.shadowColor = col; c.shadowBlur = r; c.fillStyle = col; c.beginPath(); c.arc(w / 2, h / 2, r * .9, 0, TAU); c.fill(); c.fill(); c.shadowBlur = 0; c.fillStyle = '#fff'; c.beginPath(); c.arc(w / 2, h / 2, r * .55, 0, TAU); c.fill(); }));
  };

  /* ---------- física pura (sem DOM), também usada pelo teste test_action2.mjs ----------
     puckHit: disco contra batedor (círculos), com a velocidade relativa; devolve a força do impacto
     (0 = não tocou) e deixa o disco fora do batedor. */
  const puckHit = (puck, m, PR, MR, k) => {
    const dx = puck.x - m.x, dy = puck.y - m.y, d = hyp(dx, dy), min = PR + MR;
    if (d >= min || d < 1e-4) return 0;
    const nx = dx / d, ny = dy / d;
    puck.x = m.x + nx * min; puck.y = m.y + ny * min;
    const rvx = puck.vx - (m.vx || 0), rvy = puck.vy - (m.vy || 0), dotv = rvx * nx + rvy * ny;
    if (dotv >= 0) return 0;
    puck.vx -= (k || 1.9) * dotv * nx; puck.vy -= (k || 1.9) * dotv * ny;
    return -dotv;
  };

  /* ---------- partículas e textos a flutuar: pools fixos, sem alocações por frame ----------
     kind 0 = disco pré-desenhado com a cor; kind 1 = faísca (traço na direção da velocidade) */
  function Fx(max) {
    max = max || 150;
    const P = new Array(max); let n = 0;
    for (let i = 0; i < max; i++) P[i] = { x: 0, y: 0, vx: 0, vy: 0, life: 0, max: 1, col: '#fff', sp: null, size: 3, g: 0, k: 0 };
    const T = new Array(8); let tn = 0;
    for (let i = 0; i < 8; i++) T[i] = { x: 0, y: 0, s: '', col: '#fff', size: 22, life: 0, max: 1 };
    return {
      get count() { return n; },
      burst(x, y, col, count, spd, life, size, grav, kind) {
        const sp = kind ? null : dot(col, 6);
        for (let i = 0; i < count; i++) {
          const p = n < max ? P[n++] : P[(Math.random() * max) | 0];
          const a = rnd(0, TAU), v = spd * rnd(.3, 1), l = life * rnd(.6, 1);
          p.x = x; p.y = y; p.vx = Math.cos(a) * v; p.vy = Math.sin(a) * v; p.life = l; p.max = l; p.col = col; p.sp = sp; p.size = size * rnd(.6, 1); p.g = grav || 0; p.k = kind || 0;
        }
      },
      /* faíscas num cone (paredes do Pong, rastilho da bomba): direção a em radianos, abertura spread */
      cone(x, y, col, count, a, spread, spd, life, size, grav, kind) {
        const sp = kind ? null : dot(col, 6);
        for (let i = 0; i < count; i++) {
          const p = n < max ? P[n++] : P[(Math.random() * max) | 0];
          const an = a + rnd(-spread, spread), v = spd * rnd(.4, 1), l = life * rnd(.6, 1);
          p.x = x; p.y = y; p.vx = Math.cos(an) * v; p.vy = Math.sin(an) * v; p.life = l; p.max = l; p.col = col; p.sp = sp; p.size = size * rnd(.6, 1); p.g = grav || 0; p.k = kind || 0;
        }
      },
      text(x, y, s, col, size, life) {
        let m = null; for (let i = 0; i < 8; i++) if (T[i].life <= 0) { m = T[i]; break; }
        if (!m) { m = T[0]; for (let i = 1; i < 8; i++) if (T[i].life < m.life) m = T[i]; }
        m.x = x; m.y = y; m.s = s; m.col = col || '#fff'; m.size = size || 22; m.life = life || 1; m.max = life || 1; if (tn < 8) tn++;
      },
      step(dt) {
        for (let i = n - 1; i >= 0; i--) {
          const p = P[i]; p.life -= dt;
          if (p.life <= 0) { n--; if (i !== n) { P[i] = P[n]; P[n] = p; } continue; }
          p.x += p.vx * dt; p.y += p.vy * dt; p.vy += p.g * dt;
          const k = Math.max(0, 1 - 2.2 * dt); p.vx *= k; if (!p.g) p.vy *= k;
        }
        for (let i = 0; i < 8; i++) { const m = T[i]; if (m.life > 0) { m.life -= dt; m.y -= 34 * dt; } }
      },
      draw(c) {
        for (let i = 0; i < n; i++) {
          const p = P[i], a = p.life / p.max; c.globalAlpha = a;
          if (p.k === 1) { c.strokeStyle = p.col; c.lineWidth = p.size * (.4 + .6 * a); c.beginPath(); c.moveTo(p.x, p.y); c.lineTo(p.x - p.vx * .035, p.y - p.vy * .035); c.stroke(); }
          else { const s = p.size * (.35 + .65 * a) * 1.6; c.drawImage(p.sp, p.x - s, p.y - s, s * 2, s * 2); }
        }
        for (let i = 0; i < 8; i++) {
          const m = T[i]; if (m.life <= 0) continue;
          const age = m.max - m.life, pop = 1 + .25 * Math.max(0, 1 - age / .15);
          c.globalAlpha = Math.min(1, m.life / m.max * 2.2);
          c.font = `800 ${Math.round(m.size * pop)}px ${FONT}`; c.textAlign = 'center'; c.textBaseline = 'middle';
          c.lineWidth = 4; c.strokeStyle = 'rgba(0,0,0,.45)'; c.strokeText(m.s, m.x, m.y);
          c.fillStyle = m.col; c.fillText(m.s, m.x, m.y);
        }
        c.globalAlpha = 1;
      },
      clear() { n = 0; for (let i = 0; i < 8; i++) T[i].life = 0; },
    };
  }

  /* rasto: ring buffer tipado de posições (sem alocações); i = 0 é a posição mais recente */
  function Trail(n) {
    const xs = new Float32Array(n), ys = new Float32Array(n);
    const t = { len: 0, head: 0, n, xs, ys,
      push(x, y) { t.head = (t.head + 1) % n; xs[t.head] = x; ys[t.head] = y; if (t.len < n) t.len++; },
      ix(i) { return ((t.head - i) % n + n) % n; },
      clear() { t.len = 0; } };
    return t;
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

  /* sons com intervalo mínimo: uma troca rápida não metralha o sintetizador; nomes desconhecidos não rebentam */
  const sfx = A => { const last = {}; return (n, gap) => { const now = performance.now(); if (last[n] && now - last[n] < (gap == null ? 70 : gap)) return; last[n] = now; try { A.sfx(n); } catch (e) {} }; };

  /* ponteiro no PALCO inteiro, convertido para as unidades lógicas da tela. A medida da tela faz-se UMA vez
     por gesto (nunca getBoundingClientRect por frame); o quociente largura real / largura lógica aguenta o
     zoom do aparelho e o zoom do fit(). O ponto devolvido é UM objeto partilhado (sem alocações). */
  function pointer(X, h) {
    const zone = X.A.el.stage, cv = X.cv, W = X.W, H = X.H;
    let rect = null;
    const active = {};
    const pt = { x: 0, y: 0, id: 0 };
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

  /* ---------- anfitrião comum: casca + tela + ciclo + estados + game feel ----------
     o.restart() recomeça (chamado pelo shell), o.tick(dt) avança e desenha, o.draw() desenha um quadro,
     o.key(e) recebe o teclado, o.onStart() corre ao primeiro toque, o.onResume(fromPause) ao retomar.
     X.hitStop(s) congela o dt s segundos (impacto grande); X.slow(k, s) câmara lenta k durante s;
     X.white = 1 pinta um flash branco que esvai (o draw do jogo chama X.drawWhite(c));
     X.countdown(n) → Promise: A.countdown da casca se existir, senão contagem própria na tela (só números);
     X.wait(s) → Promise resolvida pelo ciclo (em pausa espera). */
  function host(win, o) {
    const X = { W: o.W, H: o.H, running: false, dead: false, dying: null, seq: 0, stopT: 0, slowT: 0, slowK: 1, white: 0, count: 0, countTot: 0, countRes: null, countDigit: 0, waits: [] };
    const A = Arcade.shell(win, {
      id: o.id, name: o.name, color: o.color, scoreLabel: o.scoreLabel, bestLabel: o.bestLabel,
      onRestart: () => o.restart(), onPause: () => X.L.stop(), onResume: () => X.go(true),
    });
    X.A = A;
    const cv = UI.el(`<canvas class="gm-cv ga2-cv" width="${o.W}" height="${o.H}"></canvas>`);
    A.el.stage.appendChild(cv);
    X.cv = cv; X.ctx = cv.getContext('2d');
    X.fx = Fx(o.particles || 150); X.snd = sfx(A); X.shake = shaker(cv); X.K = keys();
    X.flash = (m, cls) => { try { A.flash(m, cls); } catch (e) {} };
    X.haptic = k => { try { A.haptic(k); } catch (e) {} };
    X.toast = m => { try { if (A.toast) A.toast(m); else A.flash(m, 'bonus'); } catch (e) {} };
    X.celebrate = k => { try { A.celebrate && A.celebrate(k); } catch (e) {} };
    X.flag = k => { try { Arcade.flag && Arcade.flag(k); } catch (e) {} };
    X.maxStat = (k, n) => { try { Arcade.maxStat && Arcade.maxStat(k, n); } catch (e) {} };
    X.alive = () => X.running && !X.dead && !X.dying;
    X.hitStop = s => { if (s > X.stopT) X.stopT = s; };
    X.slow = (k, s) => { X.slowK = k; X.slowT = s; };
    X.L = Arcade.loop(raw => {
      const ts = (typeof A.timeScale === 'number' && A.timeScale > 0) ? A.timeScale : 1;
      let dt = raw * ts;
      X.K.step(raw); X.shake.step(raw);
      if (X.white > 0) X.white = Math.max(0, X.white - raw * 3.2);
      /* esperas e contagem própria correm no tempo real do ciclo (em pausa param) */
      for (let i = X.waits.length - 1; i >= 0; i--) { const w = X.waits[i]; w.t -= raw; if (w.t <= 0) { X.waits.splice(i, 1); w.fn(); } }
      if (X.count > 0) {
        X.count -= raw; const d = Math.ceil(Math.max(0, X.count));
        if (d !== X.countDigit) { X.countDigit = d; X.snd(d ? 'count' : 'pop', 0); }
        if (X.count <= 0) { X.count = 0; const r = X.countRes; X.countRes = null; if (r) r(); }
      }
      if (X.stopT > 0) { X.stopT -= raw; o.draw(); return; }
      if (X.slowT > 0) { X.slowT -= raw; dt *= X.slowK; }
      if (X.dying) { X.dying.t -= raw; if (X.dying.t <= 0) { const r = X.dying.res; X.dying = null; X.over(r); return; } }
      o.tick(dt);
    });
    X.wait = s => new Promise(res => { X.waits.push({ t: s, fn: res }); });
    X.countdown = n => {
      if (A.countdown) { try { const p = A.countdown(n); if (p && p.then) return p; } catch (e) {} }
      return new Promise(res => { X.count = n; X.countTot = n; X.countDigit = n; X.countRes = res; X.snd('count', 0); });
    };
    /* contagem própria na tela: algarismo grande com pop (só quando a casca não tem A.countdown) */
    X.drawCount = c => {
      if (X.count <= 0) return;
      const frac = X.count - Math.floor(X.count), d = Math.ceil(X.count), pop = 1 + .35 * Math.max(0, frac - .7) / .3;
      c.globalAlpha = .25 + .75 * Math.min(1, frac * 2);
      txt(c, String(d), X.W / 2, X.H / 2, Math.round(120 * pop), '#fff', 800);
      c.globalAlpha = 1;
    };
    X.drawWhite = c => { if (X.white > 0) { c.globalAlpha = X.white * .6; c.fillStyle = '#fff'; c.fillRect(0, 0, X.W, X.H); c.globalAlpha = 1; } };
    /* retomar: só com o jogo a correr e sem a camada "Em pausa" do shell à espera do jogador */
    X.go = fromPause => { if (!X.running || X.dead || A.paused) return; if (o.onResume) o.onResume(fromPause); X.L.start(); };
    /* começar: quadro estático + "Toca para começar"; o ciclo só arranca depois do toque */
    X.begin = (title, sub) => {
      const tok = ++X.seq;
      X.running = false; X.dead = false; X.dying = null; X.stopT = 0; X.slowT = 0; X.white = 0; X.count = 0; X.countRes = null; X.waits.length = 0;
      X.L.stop(); X.shake.reset(); X.K.clear(); X.fx.clear();
      o.draw();
      return A.ready(title, sub).then(() => {
        if (tok !== X.seq || A.ended) return;
        X.running = true; if (o.onStart) o.onStart(); X.L.start();
      });
    };
    /* morrer com estilo: câmara lenta, o ciclo continua `delay` s (partículas, queda) e só depois aparece o resultado */
    X.die = (res, delay) => { if (X.dead || X.dying) return; X.dying = { res, t: delay || 1 }; X.slow(.3, .5); };
    X.over = res => {
      if (X.dead) return; X.dead = true; X.running = false; X.dying = null; X.slowT = 0; X.stopT = 0; X.L.stop(); X.shake.reset();
      try { o.draw(); } catch (e) {}
      /* a casca celebra sozinha no A.end (vitória = confetti, recorde = fita); aqui não se repete */
      A.end(res);
    };
    win.onClose = () => { X.L.stop(); };
    X.api = {
      pause() { X.L.stop(); },
      /* ao voltar a tela pode ter sido descartada pelo CEF: redesenha-se um quadro antes de retomar */
      resume() { try { o.draw(); } catch (e) {} X.go(false); },
      key(e) { if (!X.running || X.dead || A.paused) return; return o.key ? o.key(e) : undefined; },
    };
    return X;
  }

  /* opções partilhadas por Pong e Hóquei */
  const LVL = [{ v: 'facil', label: 'Fácil' }, { v: 'medio', label: 'Médio' }, { v: 'dificil', label: 'Difícil' }];
  const lvlLabel = v => (LVL.find(l => l.v === v) || LVL[1]).label;
  const lvlN = v => (v === 'facil' ? 1 : v === 'dificil' ? 3 : 2);
  const MODE = [{ v: '1', label: 'Contra a IA' }, { v: '2', label: '2 jogadores' }];
  const TO = [{ v: '7', label: '7' }, { v: '11', label: '11' }];
  /* pontuação dos duelos, normalizada para "primeiro a 7": o máximo é o mesmo nas partidas a 7 e a 11
     (1120 × nível): pontos × 100 mais 60 por cada ponto que a IA não fez, se ganhaste */
  const duelScore = (mine, theirs, lv, to) => { to = to || 7; return Math.max(0, Math.round((mine * 100 + (mine >= to ? (to - theirs) * 60 : 0)) * (7 / to)) * lvlN(lv)); };
  const fmtTime = s => { s = Math.max(0, Math.round(s)); return Math.floor(s / 60) + ':' + String(s % 60).padStart(2, '0'); };

  /* capas (SVG 400×200, sem filter) partilham o mesmo esqueleto */
  const COVER = (inner, bg) => `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg">${bg}${inner}</svg>`;

  /* =====================================================================
     PONG: arena néon, contra a IA (3 personalidades) ou dois no mesmo ecrã
     ===================================================================== */
  Icons.app.pong = () => Icons.SVG(Icons.G('gPg', '#2C1250', '#4A1A8C', '#1A0A3A') + Icons.GL(
    `<path d="M14 50h72" stroke="#D7A4FF" stroke-opacity=".35" stroke-width="2.5" stroke-dasharray="4 6" stroke-linecap="round"/>` +
    `<rect x="52" y="17" width="30" height="8" rx="4" fill="#FF4FC3" opacity=".35" transform="translate(0 2)"/><rect x="52" y="17" width="30" height="8" rx="4" fill="#FF4FC3"/><rect x="55" y="18.5" width="24" height="2" rx="1" fill="#fff" opacity=".75"/>` +
    `<rect x="18" y="75" width="30" height="8" rx="4" fill="#4DF0FF" opacity=".35" transform="translate(0 2)"/><rect x="18" y="75" width="30" height="8" rx="4" fill="#4DF0FF"/><rect x="21" y="76.5" width="24" height="2" rx="1" fill="#fff" opacity=".8"/>` +
    `<circle cx="42" cy="56" r="10" fill="#fff" opacity=".18"/><circle cx="42" cy="56" r="6" fill="#fff"/><circle cx="33" cy="63" r="3.5" fill="#fff" opacity=".35"/><circle cx="27" cy="68" r="2.5" fill="#fff" opacity=".2"/>`));

  const PONG_COVER = () => COVER(
    `<rect x="10" y="10" width="380" height="180" rx="16" fill="none" stroke="#9A5CFF" stroke-opacity=".55" stroke-width="2"/>` +
    `<path d="M200 18v164" stroke="#D7A4FF" stroke-opacity=".4" stroke-width="3" stroke-dasharray="6 10" stroke-linecap="round"/>` +
    `<text x="130" y="128" font-family="Inter, sans-serif" font-size="96" font-weight="800" fill="#fff" fill-opacity=".08" text-anchor="middle">3</text>` +
    `<text x="270" y="128" font-family="Inter, sans-serif" font-size="96" font-weight="800" fill="#fff" fill-opacity=".08" text-anchor="middle">2</text>` +
    `<rect x="32" y="62" width="12" height="76" rx="6" fill="#4DF0FF" opacity=".35"/><rect x="34" y="64" width="8" height="72" rx="4" fill="#4DF0FF"/><rect x="36" y="66" width="2" height="68" rx="1" fill="#fff" opacity=".8"/>` +
    `<rect x="356" y="46" width="12" height="76" rx="6" fill="#FF4FC3" opacity=".35"/><rect x="358" y="48" width="8" height="72" rx="4" fill="#FF4FC3"/><rect x="360" y="50" width="2" height="68" rx="1" fill="#fff" opacity=".8"/>` +
    `<circle cx="150" cy="110" r="5" fill="#fff" opacity=".12"/><circle cx="170" cy="100" r="6" fill="#fff" opacity=".22"/><circle cx="192" cy="90" r="7" fill="#fff" opacity=".4"/>` +
    `<circle cx="216" cy="80" r="16" fill="url(#pgGlow)"/><circle cx="216" cy="80" r="8" fill="#fff"/>`,
    `<defs><linearGradient id="pgBg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0B0620"/><stop offset="1" stop-color="#1B0B3C"/></linearGradient><radialGradient id="pgGlow"><stop offset="0" stop-color="#fff" stop-opacity=".9"/><stop offset=".5" stop-color="#D7A4FF" stop-opacity=".5"/><stop offset="1" stop-color="#BF5AF2" stop-opacity="0"/></radialGradient></defs><rect width="400" height="200" fill="url(#pgBg)"/>`);

  Arcade.game('pong', {
    name: 'Pong', color: '#BF5AF2', kind: 'action', variants: LVL.map(l => ({ key: l.v, label: l.label })),
    desc: 'Arena néon: arrasta a raquete e devolve a bola, que acelera a cada toque e sai pelo ângulo em que bates. Três IA com personalidade, partida a 7 ou 11, bónus de raquete grande e modo a dois no mesmo ecrã.',
    tags: ['Néon', 'Duelo', 'A dois'],
    modes: [{ key: 'ia', label: 'Contra a IA' }, { key: '2p', label: '2 jogadores' }],
    cover: PONG_COVER,
    howto: { goal: 'Devolve a bola e faz a IA falhar: o primeiro a 7 (ou 11) ganha.',
      steps: ['Arrasta o dedo em qualquer ponto do palco para mover a raquete de baixo', 'Bate com a ponta da raquete para dar ângulo; a bola acelera a cada toque', 'Com o bónus ligado, apanha a cápsula para ter uma raquete grande durante uns segundos'],
      controls: [{ icon: 'move', label: 'Arrasta para mover a raquete' }, { icon: 'gamepad', label: 'Setas ou A e D no teclado' }] },
    build(win) {
      const W = 400, H = 600, PW = 92, PWB = 140, PH = 14, PY = [H - 40, 40], BR = 8, V0 = 320, VMAX = 780;
      const COL = ['#4DF0FF', '#FF4FC3'];
      /* personalidades: v = velocidade da raquete, err = erro de mira (px), late = só reage quando a bola passa esta fração da altura, edge = procura bater com a ponta */
      const PAI = { facil: { v: 240, err: 70, late: .45, edge: 0 }, medio: { v: 390, err: 30, late: 0, edge: .3 }, dificil: { v: 620, err: 8, late: 0, edge: .8 } };
      let lv = Arcade.opt('pong:lv', 'medio'), mode = Arcade.opt('pong:mode', '1'), to = parseInt(Arcade.opt('pong:to', '7'), 10) || 7, bonusOn = Arcade.opt('pong:bonus', '1') === '1';
      if (!PAI[lv]) lv = 'medio'; if (mode !== '1' && mode !== '2') mode = '1'; if (to !== 7 && to !== 11) to = 7;
      const ball = { x: W / 2, y: H / 2, vx: 0, vy: 0 };
      const px = [W / 2, W / 2], tx = [W / 2, W / 2], big = [0, 0], ptr = {};
      const cap = { on: false, x: 0, y: 0, t: 0, rot: 0 };
      let sc, phase, serveTo, aiErr, rally, maxRally, maxSpd, hits, lastHit, impact, capT, aiSeen, first;
      const trail = Trail(18);
      const boardId = () => (mode === '2' ? 'pong:2p' : 'pong:' + lv);
      const X = host(win, {
        id: boardId(), name: 'Pong', color: '#BF5AF2', W, H,
        restart: () => start(), tick, draw, key,
        onResume: () => {},
      });
      const c = X.ctx;
      /* ---- arte pré-desenhada ---- */
      const BG = spr(W, H, (b, w, h) => {
        b.fillStyle = lgrad(b, 0, 0, 0, h, [[0, '#07061A'], [.5, '#120B2C'], [1, '#0A0720']]); b.fillRect(0, 0, w, h);
        b.strokeStyle = 'rgba(160,120,255,.06)'; b.lineWidth = 1;
        for (let x = 20; x < w; x += 40) { b.beginPath(); b.moveTo(x, 0); b.lineTo(x, h); b.stroke(); }
        for (let y = 20; y < h; y += 40) { b.beginPath(); b.moveTo(0, y); b.lineTo(w, y); b.stroke(); }
        b.fillStyle = rgrad(b, w / 2, h / 2, 80, w / 2, h / 2, h * .75, [[0, 'rgba(0,0,0,0)'], [1, 'rgba(0,0,0,.55)']]); b.fillRect(0, 0, w, h);
        /* moldura néon da arena */
        b.shadowColor = '#9A5CFF'; b.shadowBlur = 18; b.strokeStyle = '#7B4DFF'; b.lineWidth = 3; rr(b, 6, 6, w - 12, h - 12, 16); b.stroke(); b.stroke();
        b.shadowBlur = 0; b.strokeStyle = 'rgba(255,255,255,.75)'; b.lineWidth = 1; rr(b, 6, 6, w - 12, h - 12, 16); b.stroke();
        /* linha central pontilhada com glow */
        b.shadowColor = '#D7A4FF'; b.shadowBlur = 10; b.strokeStyle = '#D7A4FF'; b.lineWidth = 3; b.lineCap = 'round'; b.setLineDash([2, 14]);
        b.beginPath(); b.moveTo(22, h / 2); b.lineTo(w - 22, h / 2); b.stroke(); b.stroke(); b.setLineDash([]); b.shadowBlur = 0;
        b.strokeStyle = 'rgba(255,255,255,.1)'; b.lineWidth = 1; b.beginPath(); b.arc(w / 2, h / 2, 48, 0, TAU); b.stroke();
      });
      const padSpr = (col, w) => spr(w + 48, PH + 48, (b, cw, ch) => {
        const x = 24, y = 24;
        b.shadowColor = col; b.shadowBlur = 16; b.fillStyle = col; rr(b, x, y, w, PH, PH / 2); b.fill(); b.fill(); b.shadowBlur = 0;
        b.fillStyle = lgrad(b, 0, y, 0, y + PH, [[0, '#fff'], [.35, col], [1, col]]); rr(b, x, y, w, PH, PH / 2); b.fill();
        b.fillStyle = 'rgba(255,255,255,.85)'; rr(b, x + 8, y + 2.5, w - 16, 2.5, 1.5); b.fill();
        b.fillStyle = 'rgba(0,0,0,.18)'; rr(b, x + 6, y + PH - 4, w - 12, 2.5, 1.5); b.fill();
      });
      const PAD = [[padSpr(COL[0], PW), padSpr(COL[0], PWB)], [padSpr(COL[1], PW), padSpr(COL[1], PWB)]];
      const BALL = [glow('#FFFFFF', 12), glow('#FFD166', 12), glow('#FF6B6B', 13)];
      const IMPACT = dot('#FFFFFF', 30);
      const CAP = spr(72, 72, (b, w, h) => {
        b.shadowColor = '#30D158'; b.shadowBlur = 14; b.fillStyle = '#30D158'; rr(b, 16, 24, 40, 24, 12); b.fill(); b.fill(); b.shadowBlur = 0;
        b.fillStyle = lgrad(b, 0, 24, 0, 48, [[0, '#B6FFC9'], [.4, '#30D158'], [1, '#1E9B3F']]); rr(b, 16, 24, 40, 24, 12); b.fill();
        b.strokeStyle = '#073B17'; b.lineWidth = 2.5; b.lineCap = 'round'; b.beginPath(); b.moveTo(24, 36); b.lineTo(48, 36); b.moveTo(28, 32); b.lineTo(24, 36); b.lineTo(28, 40); b.moveTo(44, 32); b.lineTo(48, 36); b.lineTo(44, 40); b.stroke();
      });
      const names = () => (mode === '2' ? ['Baixo', 'Cima'] : ['Tu', 'IA']);
      const hud = () => { const n = names(); X.A.setMid(hint(`<em>${n[0]}</em> <b class="p0">${sc[0]}</b><i>:</i><b class="p1">${sc[1]}</b> <em>${n[1]}</em>`)); };
      const serve = () => {
        const a = rnd(-.38, .38), dir = serveTo === 0 ? 1 : -1;
        ball.x = W / 2; ball.y = H / 2; ball.vx = Math.sin(a) * V0; ball.vy = Math.cos(a) * V0 * dir;
        aiErr = rnd(-1, 1); rally = 0; trail.clear(); phase = 'play'; aiSeen = false; X.snd('whoosh', 0);
      };
      /* serviço: contagem 3-2-1 no primeiro da partida; depois de um ponto, uma pausa curta com a bola a pulsar */
      const serveSoon = () => {
        const tok = X.seq; phase = 'wait';
        (first ? X.countdown(3) : X.wait(.9)).then(() => { first = false; if (tok !== X.seq || X.dead || X.dying || phase !== 'wait') return; serve(); });
      };
      const reset = () => {
        sc = [0, 0]; phase = 'wait'; serveTo = Math.random() < .5 ? 0 : 1; aiErr = 0; rally = 0; maxRally = 0; maxSpd = 0; hits = 0; lastHit = -1; impact = 0; capT = 0; aiSeen = false; first = true;
        cap.on = false; big[0] = big[1] = 0;
        for (const k in ptr) delete ptr[k];
        px[0] = px[1] = tx[0] = tx[1] = W / 2; ball.x = W / 2; ball.y = H / 2; ball.vx = ball.vy = 0; trail.clear();
        X.A.setScore(0); hud();
      };
      const subtitle = () => (mode === '2' ? `Cada jogador arrasta a sua raquete. Primeiro a ${to}` : (lv === 'facil' ? `Contra uma IA calma, que deixa espaço. Primeiro a ${to}` : lv === 'dificil' ? `Contra uma IA implacável, que procura os cantos. Primeiro a ${to}` : `Contra uma IA atenta, que segue a bola. Primeiro a ${to}`));
      const start = () => { reset(); X.A.setId(boardId()); X.begin('Pong', subtitle()).then(() => { if (X.running) serveSoon(); }); };
      const finish = scorer => {
        phase = 'over';
        if (mode === '2') { X.die({ title: scorer === 0 ? 'Ganhou o jogador de baixo' : 'Ganhou o jogador de cima', sub: `${sc[0]} : ${sc[1]}`, score: null, win: true, submit: false, stats: stats() }, 1.2); return; }
        const won = scorer === 0;
        if (won && sc[1] === 0) X.flag('duelShutout');
        X.die({ title: won ? 'Ganhaste' : 'A IA ganhou', sub: `${sc[0]} : ${sc[1]} · ${lvlLabel(lv)}`, score: duelScore(sc[0], sc[1], lv, to), win: won, board: 'pong:' + lv, stats: stats() }, 1.2);
      };
      const stats = () => [{ label: 'Troca mais longa', value: String(maxRally) }, { label: 'Velocidade máxima', value: Math.round(maxSpd / 10) + ' km/h' }, { label: 'Toques na raquete', value: String(hits) }];
      const point = scorer => {
        sc[scorer]++; X.snd(scorer === 0 ? 'score' : 'fail', 0); X.haptic('medium'); X.white = .8; X.shake.hit(5);
        X.fx.burst(ball.x, scorer === 0 ? 8 : H - 8, COL[scorer], 26, 300, .8, 4, 0, 1);
        X.fx.burst(ball.x, scorer === 0 ? 8 : H - 8, '#fff', 10, 160, .5, 3);
        X.flash('Ponto!', 'big'); hud();
        if (mode === '1') X.A.setScore(duelScore(sc[0], sc[1], lv, to));
        ball.vx = 0; ball.vy = 0; trail.clear(); cap.on = false;
        if (sc[scorer] >= to) { finish(scorer); return; }
        if (mode === '1' && sc[0] === to - 1 && sc[1] === to - 1) X.flash('Ponto decisivo', 'bonus');
        serveTo = 1 - scorer; serveSoon();
      };
      const movePad = (s, vmax, dt) => { const hw = (big[s] > 0 ? PWB : PW) / 2, want = clamp(tx[s], hw, W - hw), d = want - px[s], lim = vmax * dt; px[s] += Math.abs(d) > lim ? Math.sign(d) * lim : d; };
      /* onde a bola vai cruzar uma linha, dobrando as paredes laterais */
      const crossX = row => {
        if (Math.abs(ball.vy) < 1) return W / 2;
        const tt = (row - ball.y) / ball.vy; if (tt < 0) return W / 2;
        const span = W - 2 * BR; let x = ball.x + ball.vx * tt - BR;
        x = ((x % (2 * span)) + 2 * span) % (2 * span); if (x > span) x = 2 * span - x;
        return x + BR;
      };
      const aiStep = dt => {
        const P = PAI[lv];
        if (phase === 'play' && ball.vy < 0 && ball.y < H * (1 - P.late)) {
          if (!aiSeen) { aiSeen = true; aiErr = rnd(-1, 1); }
          let want = crossX(PY[1] + PH / 2 + BR) + aiErr * P.err;
          /* a Implacável bate com a ponta para mandar a bola para o lado onde o jogador não está */
          if (P.edge) { const side = px[0] < W / 2 ? 1 : -1; want -= side * (big[1] > 0 ? PWB : PW) * .36 * P.edge; }
          tx[1] = want;
        } else { tx[1] = W / 2 + (ball.x - W / 2) * .25; }
        movePad(1, P.v, dt);
      };
      const hitPad = (s, face, dir) => {
        const hw = (big[s] > 0 ? PWB : PW) / 2, off = clamp((ball.x - px[s]) / hw, -1, 1), a = off * 1.05;
        const vel = Math.min(VMAX, Math.max(V0, hyp(ball.vx, ball.vy)) * 1.06);
        ball.vx = Math.sin(a) * vel; ball.vy = -Math.cos(a) * vel * dir; ball.y = face - dir * BR;
        rally++; hits++; lastHit = s; if (rally > maxRally) maxRally = rally; if (vel > maxSpd) maxSpd = vel;
        impact = 1; X.snd('hit', 50); X.fx.cone(ball.x, face, COL[s], 7, -dir * Math.PI / 2, .9, 240, .4, 2.5, 0, 1);
        if (vel > 600) { X.hitStop(.04); X.shake.hit(3); } else if (rally >= 6 && rally % 3 === 0) X.shake.hit(2);
        if (rally === 8) { X.flash('Grande troca', 'bonus'); X.snd('combo', 0); }
        if (rally === 16) { X.flash('Troca épica', 'bonus'); X.snd('bonus', 0); }
      };
      function tick(dt) {
        X.fx.step(dt);
        if (impact > 0) impact = Math.max(0, impact - dt * 5);
        if (X.dying || phase === 'over') { draw(); return; }
        movePad(0, 900, dt);
        if (mode === '2') movePad(1, 900, dt); else aiStep(dt);
        for (let s = 0; s < 2; s++) if (big[s] > 0) { big[s] -= dt; if (big[s] <= 0) { big[s] = 0; X.snd('tick', 0); } }
        if (phase !== 'play') { draw(); return; }
        /* cápsula de bónus: nasce a meio da arena de vez em quando, roda, e quem lhe bateu por último fica com a raquete grande */
        if (bonusOn) {
          if (!cap.on) { capT += dt; if (capT > 7 && rally >= 2) { capT = 0; cap.on = true; cap.x = rnd(70, W - 70); cap.y = rnd(H * .32, H * .68); cap.t = 9; cap.rot = 0; X.snd('chime', 0); } }
          else { cap.t -= dt; cap.rot += dt * 2.2; if (cap.t <= 0) cap.on = false; else if (lastHit >= 0 && hyp(ball.x - cap.x, ball.y - cap.y) < 24) { cap.on = false; big[lastHit] = 8; X.snd('powerup', 0); X.fx.burst(cap.x, cap.y, '#30D158', 18, 220, .6, 3.5); X.flash(lastHit === 0 ? 'Raquete grande' : (mode === '2' ? 'Raquete grande em cima' : 'A IA tem raquete grande'), 'bonus'); } }
        }
        const sp = hyp(ball.vx, ball.vy), n = Math.max(1, Math.ceil(sp * dt / 6)), h = dt / n;
        for (let i = 0; i < n; i++) {
          ball.x += ball.vx * h; ball.y += ball.vy * h;
          if (ball.x < BR) { ball.x = BR; ball.vx = Math.abs(ball.vx); X.snd('bounce', 90); X.fx.cone(BR, ball.y, '#D7A4FF', 6, 0, .7, 220, .35, 2, 0, 1); }
          if (ball.x > W - BR) { ball.x = W - BR; ball.vx = -Math.abs(ball.vx); X.snd('bounce', 90); X.fx.cone(W - BR, ball.y, '#D7A4FF', 6, Math.PI, .7, 220, .35, 2, 0, 1); }
          for (let s = 0; s < 2; s++) {
            const dir = s === 0 ? 1 : -1, face = PY[s] - dir * PH / 2, hw = (big[s] > 0 ? PWB : PW) / 2;
            if (ball.vy * dir > 0 && Math.abs(ball.y - PY[s]) <= PH / 2 + BR && Math.abs(ball.x - px[s]) <= hw + BR) hitPad(s, face, dir);
          }
          if (ball.y > H + 30) { point(1); break; }
          if (ball.y < -30) { point(0); break; }
        }
        if (phase === 'play') trail.push(ball.x, ball.y);
        draw();
      }
      function draw() {
        c.drawImage(BG, 0, 0);
        /* algarismos grandes e ténues em cada metade (a dois, o de cima virado para quem está desse lado) */
        txt(c, String(sc[0]), W / 2, H / 2 + 96, 110, 'rgba(77,240,255,.1)', 800);
        if (mode === '2') { c.setTransform(-1, 0, 0, -1, W / 2, H / 2 - 96); txt(c, String(sc[1]), 0, 0, 110, 'rgba(255,79,195,.1)', 800); c.setTransform(1, 0, 0, 1, 0, 0); }
        else txt(c, String(sc[1]), W / 2, H / 2 - 96, 110, 'rgba(255,79,195,.1)', 800);
        if (cap.on) { const k = cap.t < 1.5 ? (Math.sin(cap.t * 18) > 0 ? 1 : .35) : 1, s = 1 + .08 * Math.sin(cap.rot); c.globalAlpha = k; c.drawImage(CAP, cap.x - 36 * s, cap.y - 36 * s, 72 * s, 72 * s); c.globalAlpha = 1; }
        /* rasto: discos a esvair e a encolher, da cor da velocidade */
        const spd = hyp(ball.vx, ball.vy), bi = spd > 640 ? 2 : spd > 470 ? 1 : 0, BS = BALL[bi];
        for (let i = trail.len - 1; i >= 1; i--) { const k = 1 - i / trail.len, ix = trail.ix(i), r = 14 * (.3 + .7 * k); c.globalAlpha = .28 * k; c.drawImage(BS, trail.xs[ix] - r, trail.ys[ix] - r, r * 2, r * 2); }
        c.globalAlpha = 1;
        for (let s = 0; s < 2; s++) { const S = PAD[s][big[s] > 0 ? 1 : 0], bw = (big[s] > 0 ? PWB : PW) + 48; if (big[s] > 0 && big[s] < 1.5 && Math.sin(big[s] * 20) < 0) c.globalAlpha = .55; c.drawImage(S, px[s] - bw / 2, PY[s] - (PH + 48) / 2); c.globalAlpha = 1; }
        if (phase === 'play' || phase === 'over') { const r = 24 + (bi * 2); c.drawImage(BS, ball.x - r, ball.y - r, r * 2, r * 2); }
        else if (phase === 'wait' && !X.dying) { const p = .6 + .4 * Math.sin(performance.now() / 140); c.globalAlpha = p; c.drawImage(BALL[0], W / 2 - 24, H / 2 - 24, 48, 48); c.globalAlpha = 1; }
        if (impact > 0) { const r = 24 + 30 * (1 - impact); c.globalAlpha = impact * .8; c.drawImage(IMPACT, ball.x - r, ball.y - r, r * 2, r * 2); c.globalAlpha = 1; }
        X.fx.draw(c);
        X.drawCount(c); X.drawWhite(c);
      }
      function key(e) {
        if (e.type === 'keyup') return;
        const k = e.key; let s = 0, d = 0;
        if (k === 'ArrowLeft') d = -1; else if (k === 'ArrowRight') d = 1;
        else if (k === 'a' || k === 'A') { d = -1; s = mode === '2' ? 1 : 0; }
        else if (k === 'd' || k === 'D') { d = 1; s = mode === '2' ? 1 : 0; }
        if (!d) return;
        e.preventDefault(); const hw = (big[s] > 0 ? PWB : PW) / 2; tx[s] = clamp(px[s] + d * 34, hw, W - hw);
      }
      /* a raquete segue o dedo: em solo qualquer ponto do palco; a dois, cada metade manda na sua raquete */
      pointer(X, {
        down: p => { const s = mode === '2' ? (p.y > H / 2 ? 0 : 1) : 0; ptr[p.id] = s; tx[s] = p.x; },
        move: p => { const s = ptr[p.id]; if (s !== undefined) tx[s] = p.x; },
        up: p => { delete ptr[p.id]; },
      });
      const again = () => { X.A.setId(boardId()); hud(); if (X.running || X.dead) start(); };
      X.A.options([
        { key: 'lv', label: 'Dificuldade', values: LVL, cur: lv, onChange: v => { if (!PAI[v]) return; lv = v; Arcade.setOpt('pong:lv', v); again(); } },
        { key: 'mode', label: 'Modo', values: MODE, cur: mode, onChange: v => { mode = v === '2' ? '2' : '1'; Arcade.setOpt('pong:mode', mode); again(); } },
        { key: 'to', label: 'Partida', values: TO, cur: String(to), onChange: v => { to = v === '11' ? 11 : 7; Arcade.setOpt('pong:to', String(to)); again(); } },
        { key: 'bonus', label: 'Bónus', values: [{ v: '1', label: 'Sim' }, { v: '0', label: 'Não' }], cur: bonusOn ? '1' : '0', onChange: v => { bonusOn = v === '1'; Arcade.setOpt('pong:bonus', v); cap.on = false; } },
      ]);
      start();
      /* só para o harness e o teste: estado interno, sem efeitos */
      X.api.dbg = () => ({ ball: { x: ball.x, y: ball.y, vx: ball.vx, vy: ball.vy }, px: px.slice(), sc: sc.slice(), phase, mode, lv, to });
      X.api.serveNow = () => { if (X.running && phase === 'wait') { first = false; serve(); } };
      X.api.setSc = (a, b) => { sc[0] = a; sc[1] = b; hud(); };
      X.api.pointNow = s => { if (X.running && !X.dead && !X.dying && phase !== 'over') point(s ? 1 : 0); };
      return X.api;
    },
  });

  /* =====================================================================
     HÓQUEI DE MESA (airhockey): mesa real ao alto, o jogador defende em baixo
     ===================================================================== */
  Icons.app.airhockey = () => Icons.SVG(Icons.G('gAh', '#F4F6FA', '#DDE3EC', '#C9D1DD') + Icons.GL(
    `<rect x="8" y="8" width="84" height="84" rx="20" fill="none" stroke="#2B2F3A" stroke-width="5"/>` +
    `<path d="M14 50h72" stroke="#E8352B" stroke-width="2.5"/><circle cx="50" cy="50" r="12" fill="none" stroke="#1E6BFF" stroke-width="2.5"/><circle cx="50" cy="50" r="2" fill="#E8352B"/>` +
    `<rect x="36" y="8" width="28" height="6" rx="2" fill="#15171E"/><rect x="36" y="86" width="28" height="6" rx="2" fill="#15171E"/>` +
    `<circle cx="34" cy="71" r="13" fill="#0E3FA8" opacity=".35" transform="translate(1 2)"/><circle cx="34" cy="71" r="13" fill="#1E6BFF"/><circle cx="34" cy="71" r="9" fill="none" stroke="#0E3FA8" stroke-width="1.5" opacity=".7"/><circle cx="34" cy="71" r="4.5" fill="#6CA6FF"/><circle cx="31" cy="67" r="2" fill="#fff" opacity=".8"/>` +
    `<circle cx="64" cy="31" r="10" fill="#8A1F18" opacity=".35" transform="translate(1 2)"/><circle cx="64" cy="31" r="10" fill="#E8352B"/><circle cx="64" cy="31" r="3.5" fill="#FF8A80"/>` +
    `<circle cx="58" cy="50" r="6" fill="#15171E"/><circle cx="56.5" cy="48.5" r="2" fill="#fff" opacity=".5"/>`));

  const AH_COVER = () => COVER(
    `<rect x="14" y="14" width="372" height="172" rx="14" fill="#2B2F3A"/><rect x="22" y="22" width="356" height="156" rx="10" fill="url(#ahSurf)"/>` +
    `<path d="M200 26v148" stroke="#E8352B" stroke-width="3"/><circle cx="200" cy="100" r="34" fill="none" stroke="#1E6BFF" stroke-width="3"/><circle cx="200" cy="100" r="4" fill="#E8352B"/>` +
    `<path d="M22 60a60 60 0 0 1 0 80M378 60a60 60 0 0 0 0 80" fill="none" stroke="#1E6BFF" stroke-width="3"/>` +
    `<rect x="18" y="70" width="8" height="60" rx="2" fill="#15171E"/><rect x="374" y="70" width="8" height="60" rx="2" fill="#15171E"/>` +
    `<circle cx="92" cy="112" r="22" fill="#000" opacity=".2" transform="translate(2 4)"/><circle cx="92" cy="112" r="22" fill="url(#ahBlue)"/><circle cx="92" cy="112" r="14" fill="none" stroke="#0E3FA8" stroke-width="2" opacity=".6"/><circle cx="92" cy="112" r="8" fill="#5A94FF"/><circle cx="87" cy="106" r="3" fill="#fff" opacity=".8"/>` +
    `<circle cx="312" cy="78" r="22" fill="#000" opacity=".2" transform="translate(2 4)"/><circle cx="312" cy="78" r="22" fill="url(#ahRed)"/><circle cx="312" cy="78" r="14" fill="none" stroke="#8A1F18" stroke-width="2" opacity=".6"/><circle cx="312" cy="78" r="8" fill="#FF7A70"/><circle cx="307" cy="72" r="3" fill="#fff" opacity=".8"/>` +
    `<circle cx="160" cy="92" r="11" fill="#1B1C22" opacity=".12"/><circle cx="178" cy="90" r="11" fill="#1B1C22" opacity=".25"/><circle cx="198" cy="88" r="12" fill="#000" opacity=".25" transform="translate(1 3)"/><circle cx="198" cy="88" r="12" fill="url(#ahPuck)"/><circle cx="194" cy="84" r="3" fill="#fff" opacity=".45"/>`,
    `<defs><radialGradient id="ahSurf" cx="50%" cy="50%" r="70%"><stop offset="0" stop-color="#F6F8FB"/><stop offset="1" stop-color="#D9DFE8"/></radialGradient><radialGradient id="ahBlue" cx="35%" cy="30%" r="80%"><stop offset="0" stop-color="#6CA6FF"/><stop offset="1" stop-color="#0E3FA8"/></radialGradient><radialGradient id="ahRed" cx="35%" cy="30%" r="80%"><stop offset="0" stop-color="#FF8A80"/><stop offset="1" stop-color="#9C1E14"/></radialGradient><radialGradient id="ahPuck" cx="35%" cy="30%" r="80%"><stop offset="0" stop-color="#4A4D5A"/><stop offset="1" stop-color="#121318"/></radialGradient></defs><rect width="400" height="200" fill="#1A1D26"/>`);

  Arcade.game('airhockey', {
    name: 'Hóquei de mesa', color: '#1E6BFF', kind: 'action', variants: LVL.map(l => ({ key: l.v, label: l.label })),
    desc: 'Mesa de hóquei a sério: superfície clara com linhas, ranhuras das balizas, batedores com peso e um disco que desliza, ressalta nos postes e entra com buzina. Três IA com personalidade, partida a 7 ou 11 e modo a dois.',
    tags: ['Mesa', 'Duelo', 'A dois'],
    modes: [{ key: 'ia', label: 'Contra a IA' }, { key: '2p', label: '2 jogadores' }],
    cover: AH_COVER,
    howto: { goal: 'Mete o disco na baliza de cima e defende a tua: o primeiro a 7 (ou 11) ganha.',
      steps: ['Arrasta o batedor azul na metade de baixo; o disco sai com a força do teu movimento', 'Usa as tábuas laterais para ressaltos que a IA não espera', 'Depois de um golo o disco volta para quem o sofreu'],
      controls: [{ icon: 'move', label: 'Arrasta o batedor' }, { icon: 'gamepad', label: 'Setas ou WASD no teclado' }] },
    build(win) {
      const W = 400, H = 600, MID = H / 2, GOAL = 64, PR = 13, MR = 24, RAIL = 10;
      const COL = ['#1E6BFF', '#E8352B'];
      const AI = { facil: { v: 320, pre: 0, tol: 36 }, medio: { v: 520, pre: .08, tol: 22 }, dificil: { v: 800, pre: .16, tol: 10 } };
      let lv = Arcade.opt('airhockey:lv', 'medio'), mode = Arcade.opt('airhockey:mode', '1'), to = parseInt(Arcade.opt('airhockey:to', '7'), 10) || 7;
      if (!AI[lv]) lv = 'medio'; if (mode !== '1' && mode !== '2') mode = '1'; if (to !== 7 && to !== 11) to = 7;
      const puck = { x: W / 2, y: MID + 70, vx: 0, vy: 0 };
      const me = { x: W / 2, y: H - 80, vx: 0, vy: 0, tx: W / 2, ty: H - 80 }, ai = { x: W / 2, y: 80, vx: 0, vy: 0, tx: W / 2, ty: 80 };
      const ptr = {};
      let sc, phase, stuck, strike, aim, maxSpd, hits, goalGlow, goalSide, first;
      const trail = Trail(10);
      const boardId = () => (mode === '2' ? 'airhockey:2p' : 'airhockey:' + lv);
      const X = host(win, {
        id: boardId(), name: 'Hóquei de mesa', color: '#1E6BFF', W, H,
        restart: () => start(), tick, draw, key,
        onResume: () => {},
      });
      const c = X.ctx;
      /* ---- mesa pré-desenhada ---- */
      const BG = spr(W, H, (b, w, h) => {
        b.fillStyle = '#12141B'; b.fillRect(0, 0, w, h);
        /* tábuas: moldura escura com bisel */
        b.fillStyle = lgrad(b, 0, 0, w, h, [[0, '#3A3F4D'], [.5, '#262A35'], [1, '#1C1F28']]); rr(b, 0, 0, w, h, 18); b.fill();
        b.strokeStyle = 'rgba(255,255,255,.14)'; b.lineWidth = 1; rr(b, 1, 1, w - 2, h - 2, 17); b.stroke();
        /* superfície clara com luz ao centro e furos de ar */
        b.fillStyle = rgrad(b, w / 2, h / 2, 40, w / 2, h / 2, h * .62, [[0, '#F7F9FC'], [.6, '#E9EDF3'], [1, '#D5DBE5']]); rr(b, RAIL, RAIL, w - 2 * RAIL, h - 2 * RAIL, 10); b.fill();
        b.fillStyle = 'rgba(70,80,100,.14)';
        for (let y = RAIL + 10; y < h - RAIL; y += 20) for (let x = RAIL + 10; x < w - RAIL; x += 20) { b.beginPath(); b.arc(x, y, 1, 0, TAU); b.fill(); }
        /* sombra interior das tábuas */
        b.strokeStyle = 'rgba(0,0,0,.18)'; b.lineWidth = 3; rr(b, RAIL + 1.5, RAIL + 1.5, w - 2 * RAIL - 3, h - 2 * RAIL - 3, 9); b.stroke();
        /* marcações: linha central vermelha, círculo central azul, áreas das balizas, círculos de face-off */
        b.lineCap = 'round';
        b.strokeStyle = '#1E6BFF'; b.lineWidth = 3;
        b.beginPath(); b.arc(w / 2, MID, 56, 0, TAU); b.stroke();
        b.beginPath(); b.arc(w / 2, RAIL, 96, 0, Math.PI); b.stroke();
        b.beginPath(); b.arc(w / 2, h - RAIL, 96, Math.PI, TAU); b.stroke();
        for (const y of [MID - 110, MID + 110]) for (const x of [96, w - 96]) { b.beginPath(); b.arc(x, y, 20, 0, TAU); b.stroke(); b.fillStyle = '#1E6BFF'; b.beginPath(); b.arc(x, y, 3, 0, TAU); b.fill(); }
        b.strokeStyle = '#E8352B'; b.lineWidth = 4; b.beginPath(); b.moveTo(RAIL + 4, MID); b.lineTo(w - RAIL - 4, MID); b.stroke();
        b.fillStyle = '#E8352B'; b.beginPath(); b.arc(w / 2, MID, 4.5, 0, TAU); b.fill();
        /* ranhuras das balizas: fenda escura com sombra interior e postes metálicos */
        for (const top of [true, false]) {
          const y0 = top ? 0 : h - RAIL - 6, gy = top ? RAIL + 6 : h - RAIL - 6;
          b.fillStyle = '#0B0C10'; rr(b, w / 2 - GOAL, y0, GOAL * 2, RAIL + 6, 4); b.fill();
          b.fillStyle = top ? lgrad(b, 0, RAIL - 6, 0, gy, [[0, 'rgba(0,0,0,0)'], [1, 'rgba(0,0,0,.55)']]) : lgrad(b, 0, gy, 0, gy + 12, [[0, 'rgba(0,0,0,.55)'], [1, 'rgba(0,0,0,0)']]);
          b.fillRect(w / 2 - GOAL, top ? gy - 12 : gy, GOAL * 2, 12);
          for (const px of [w / 2 - GOAL, w / 2 + GOAL]) { b.fillStyle = rgrad(b, px - 2, gy - 2, 1, px, gy, 6, [[0, '#F2F4F8'], [.5, '#A9B1C0'], [1, '#5A6273']]); b.beginPath(); b.arc(px, gy, 5.5, 0, TAU); b.fill(); }
        }
      });
      const malletSpr = col => spr(96, 96, (b, w, h) => {
        const cx = 44, cy = 42;
        b.shadowColor = 'rgba(0,0,0,.45)'; b.shadowBlur = 10; b.shadowOffsetX = 3; b.shadowOffsetY = 7; b.fillStyle = 'rgba(0,0,0,.5)'; b.beginPath(); b.arc(cx, cy, MR, 0, TAU); b.fill();
        b.shadowBlur = 0; b.shadowOffsetX = 0; b.shadowOffsetY = 0;
        b.fillStyle = rgrad(b, cx - 9, cy - 10, 2, cx, cy, MR, [[0, '#fff'], [.18, col], [1, '#000']]); b.beginPath(); b.arc(cx, cy, MR, 0, TAU); b.fill();
        b.fillStyle = col; b.globalAlpha = .55; b.beginPath(); b.arc(cx, cy, MR, 0, TAU); b.fill(); b.globalAlpha = 1;
        b.strokeStyle = 'rgba(0,0,0,.35)'; b.lineWidth = 2.5; b.beginPath(); b.arc(cx, cy, MR - 6, 0, TAU); b.stroke();
        b.strokeStyle = 'rgba(255,255,255,.35)'; b.lineWidth = 1.5; b.beginPath(); b.arc(cx, cy, MR - 8.5, 0, TAU); b.stroke();
        b.fillStyle = rgrad(b, cx - 4, cy - 5, 1, cx, cy, 11, [[0, '#fff'], [.3, col], [1, 'rgba(0,0,0,.6)']]); b.beginPath(); b.arc(cx, cy, 11, 0, TAU); b.fill();
        b.fillStyle = 'rgba(255,255,255,.75)'; b.beginPath(); b.ellipse(cx - 4, cy - 5, 4, 2.5, -.7, 0, TAU); b.fill();
      });
      const MAL = [malletSpr(COL[0]), malletSpr(COL[1])];
      const PUCK = spr(56, 56, (b, w, h) => {
        const cx = 26, cy = 25;
        b.shadowColor = 'rgba(0,0,0,.5)'; b.shadowBlur = 7; b.shadowOffsetX = 2; b.shadowOffsetY = 5; b.fillStyle = 'rgba(0,0,0,.6)'; b.beginPath(); b.arc(cx, cy, PR, 0, TAU); b.fill();
        b.shadowBlur = 0; b.shadowOffsetX = 0; b.shadowOffsetY = 0;
        b.fillStyle = rgrad(b, cx - 5, cy - 6, 1, cx, cy, PR, [[0, '#5A5E6E'], [.5, '#23252D'], [1, '#0B0C10']]); b.beginPath(); b.arc(cx, cy, PR, 0, TAU); b.fill();
        b.strokeStyle = 'rgba(255,255,255,.18)'; b.lineWidth = 1.5; b.beginPath(); b.arc(cx, cy, PR - 3.5, 0, TAU); b.stroke();
        b.fillStyle = 'rgba(255,255,255,.55)'; b.beginPath(); b.ellipse(cx - 4, cy - 5, 3.5, 2, -.7, 0, TAU); b.fill();
      });
      const BLUR = dot('#7F95BF', 12);
      /* marcador LED: painel escuro embutido na mesa + dígitos de 7 segmentos (acesos com brilho, apagados ténues), tudo pré-desenhado */
      const SEGS = ['abcdef', 'bc', 'abged', 'abgcd', 'fgbc', 'afgcd', 'afgedc', 'abc', 'abcdefg', 'abcdfg'];
      const seg = (b, s, x, y, w, h, t) => {
        const hb = (x0, x1, yc) => { b.beginPath(); b.moveTo(x0, yc); b.lineTo(x0 + t / 2, yc - t / 2); b.lineTo(x1 - t / 2, yc - t / 2); b.lineTo(x1, yc); b.lineTo(x1 - t / 2, yc + t / 2); b.lineTo(x0 + t / 2, yc + t / 2); b.closePath(); b.fill(); };
        const vb = (xc, y0, y1) => { b.beginPath(); b.moveTo(xc, y0); b.lineTo(xc + t / 2, y0 + t / 2); b.lineTo(xc + t / 2, y1 - t / 2); b.lineTo(xc, y1); b.lineTo(xc - t / 2, y1 - t / 2); b.lineTo(xc - t / 2, y0 + t / 2); b.closePath(); b.fill(); };
        const L = x + t / 2, R = x + w - t / 2, T = y + t / 2, M = y + h / 2, B = y + h - t / 2;
        if (s === 'a') hb(L + 1, R - 1, T); else if (s === 'd') hb(L + 1, R - 1, B); else if (s === 'g') hb(L + 1, R - 1, M);
        else if (s === 'f') vb(L, T + 1, M - 1); else if (s === 'e') vb(L, M + 1, B - 1); else if (s === 'b') vb(R, T + 1, M - 1); else if (s === 'c') vb(R, M + 1, B - 1);
      };
      const ledDigit = (col, n) => spr(36, 54, b => {
        b.fillStyle = 'rgba(255,255,255,.07)'; for (const s of 'abcdefg') seg(b, s, 6, 6, 24, 42, 5);
        b.shadowColor = col; b.shadowBlur = 9; b.fillStyle = col; for (const s of SEGS[n]) seg(b, s, 6, 6, 24, 42, 5);
        b.shadowBlur = 0; b.fillStyle = 'rgba(255,255,255,.55)'; for (const s of SEGS[n]) seg(b, s, 6, 6, 24, 42, 1.6);
      });
      const LED = [[], []]; for (let d = 0; d < 10; d++) { LED[0].push(ledDigit('#4D8DFF', d)); LED[1].push(ledDigit('#FF5A4F', d)); }
      const PANEL = spr(96, 66, b => {
        b.fillStyle = 'rgba(255,255,255,.6)'; rr(b, 2, 3, 92, 62, 12); b.fill();
        b.fillStyle = lgrad(b, 0, 2, 0, 62, [[0, '#05060A'], [1, '#141822']]); rr(b, 2, 2, 92, 60, 12); b.fill();
        b.strokeStyle = 'rgba(0,0,0,.6)'; b.lineWidth = 2; rr(b, 3, 3, 90, 58, 11); b.stroke();
        b.strokeStyle = 'rgba(255,255,255,.08)'; b.lineWidth = 1; rr(b, 6, 6, 84, 52, 9); b.stroke();
        b.fillStyle = 'rgba(255,255,255,.05)'; rr(b, 6, 6, 84, 20, 8); b.fill();
      });
      const led = (n, s, y, flip) => {
        if (flip) c.setTransform(-1, 0, 0, -1, W, 2 * y);
        c.drawImage(PANEL, W / 2 - 48, y - 33);
        const t = n > 99 ? 99 : n, d1 = (t / 10) | 0, d0 = t % 10;
        c.drawImage(LED[s][d1], W / 2 - 37, y - 27); c.drawImage(LED[s][d0], W / 2 + 1, y - 27);
        if (flip) c.setTransform(1, 0, 0, 1, 0, 0);
      };
      const LIGHT = [glow(COL[0], 26), glow(COL[1], 26)];
      const names = () => (mode === '2' ? ['Baixo', 'Cima'] : ['Tu', 'IA']);
      const hud = () => { const n = names(); X.A.setMid(hint(`<em>${n[0]}</em> <b class="p0">${sc[0]}</b><i>:</i><b class="p1">${sc[1]}</b> <em>${n[1]}</em>`)); };
      const faceOff = toTop => { puck.x = W / 2; puck.y = toTop ? MID - 70 : MID + 70; puck.vx = 0; puck.vy = 0; trail.clear(); };
      const reset = () => {
        sc = [0, 0]; phase = 'wait'; stuck = 0; strike = 0; aim = 0; maxSpd = 0; hits = 0; goalGlow = 0; goalSide = 0; first = true;
        for (const k in ptr) delete ptr[k];
        Object.assign(me, { x: W / 2, y: H - 80, vx: 0, vy: 0, tx: W / 2, ty: H - 80 }); Object.assign(ai, { x: W / 2, y: 80, vx: 0, vy: 0, tx: W / 2, ty: 80 });
        faceOff(false); X.A.setScore(0); hud();
      };
      const goSoon = toTop => {
        const tok = X.seq; phase = 'wait';
        (first ? X.countdown(3) : X.wait(1.1)).then(() => { first = false; if (tok !== X.seq || X.dead || X.dying || phase !== 'wait') return; phase = 'play'; });
      };
      const subtitle = () => (mode === '2' ? `Cada jogador arrasta o seu batedor. Primeiro a ${to}` : (lv === 'facil' ? `Contra uma IA calma, que defende devagar. Primeiro a ${to}` : lv === 'dificil' ? `Contra uma IA implacável, que remata de primeira. Primeiro a ${to}` : `Contra uma IA atenta, que defende e ataca. Primeiro a ${to}`));
      const start = () => { reset(); X.A.setId(boardId()); X.begin('Hóquei de mesa', subtitle()).then(() => { if (X.running) goSoon(false); }); };
      const stats = () => [{ label: 'Remate mais forte', value: Math.round(maxSpd / 10) + ' km/h' }, { label: 'Toques no disco', value: String(hits) }, { label: 'Duração', value: fmtTime(X.A.elapsed ? X.A.elapsed() : 0) }];
      const moveMallet = (m, tx, ty, vmax, ymin, ymax, h) => {
        tx = clamp(tx, RAIL + MR, W - RAIL - MR); ty = clamp(ty, ymin, ymax);
        let dx = tx - m.x, dy = ty - m.y; const d = hyp(dx, dy), lim = vmax * h;
        if (d > lim) { dx *= lim / d; dy *= lim / d; }
        m.x += dx; m.y += dy; m.vx = dx / h; m.vy = dy / h;
      };
      const collide = (m, s) => {
        const hit = puckHit(puck, m, PR, MR, 1.9);
        if (hit > 120) {
          hits++; X.snd('hit', 60);
          const sp = hyp(puck.vx, puck.vy); if (sp > maxSpd) maxSpd = sp;
          if (hit > 450) { X.fx.burst(puck.x, puck.y, COL[s], 8, 180, .4, 2.5, 0, 1); X.shake.hit(2.5); X.hitStop(.035); }
        }
      };
      const post = (x, y) => {
        const dx = puck.x - x, dy = puck.y - y, d = hyp(dx, dy);
        if (d >= PR + 5 || d < 1e-4) return;
        const nx = dx / d, ny = dy / d; puck.x = x + nx * (PR + 5); puck.y = y + ny * (PR + 5);
        const dotv = puck.vx * nx + puck.vy * ny; if (dotv < 0) { puck.vx -= 1.8 * dotv * nx; puck.vy -= 1.8 * dotv * ny; X.snd('tick', 80); X.fx.burst(x, y, '#fff', 5, 140, .3, 2, 0, 1); }
      };
      const goal = mine => {
        sc[mine ? 0 : 1]++;
        X.snd('drum', 0); X.snd(mine ? 'score' : 'fail', 0); X.haptic('medium'); X.white = 1; X.shake.hit(7); X.hitStop(.06);
        goalGlow = 1; goalSide = mine ? 1 : 0;
        X.fx.burst(puck.x, mine ? RAIL : H - RAIL, COL[mine ? 0 : 1], 30, 320, .9, 4, 0, 1);
        X.fx.burst(puck.x, mine ? RAIL : H - RAIL, '#fff', 12, 180, .5, 3);
        X.flash('Golo!', 'big'); hud();
        if (mode === '1') X.A.setScore(duelScore(sc[0], sc[1], lv, to));
        puck.vx = 0; puck.vy = 0; trail.clear();
        if (sc[0] >= to || sc[1] >= to) {
          phase = 'over';
          if (mode === '2') X.die({ title: sc[0] >= to ? 'Ganhou o jogador de baixo' : 'Ganhou o jogador de cima', sub: `${sc[0]} : ${sc[1]}`, score: null, win: true, submit: false, stats: stats() }, 1.3);
          else { const won = sc[0] >= to; if (won && sc[1] === 0) X.flag('duelShutout'); X.die({ title: won ? 'Ganhaste' : 'A IA ganhou', sub: `${sc[0]} : ${sc[1]} · ${lvlLabel(lv)}`, score: duelScore(sc[0], sc[1], lv, to), win: won, board: 'airhockey:' + lv, stats: stats() }, 1.3); }
          return;
        }
        if (mode === '1' && sc[0] === to - 1 && sc[1] === to - 1) X.flash('Golo decisivo', 'bonus');
        faceOff(mine); goSoon(mine);   /* o disco volta para quem sofreu o golo */
      };
      /* a IA defende em cima: fica entre o disco e a baliza; com o disco à frente alinha-se por trás dele
         na linha para a nossa baliza e arremete; um disco parado na metade dela volta ao meio em 2,5 s */
      const aiStep = h => {
        const P = AI[lv], fx2 = puck.x + puck.vx * P.pre, fy = puck.y + puck.vy * P.pre;
        const slow = hyp(puck.vx, puck.vy) < 40; stuck = (puck.y < MID && slow) ? stuck + h : 0;
        if (stuck > 2.5) { stuck = 0; faceOff(true); X.fx.burst(puck.x, puck.y, '#fff', 8, 100, .4, 3); X.snd('tick', 0); }
        if (strike > 0) strike -= h;
        const homeY = RAIL + 46, homeX = clamp(W / 2 + (fx2 - W / 2) * .75, W / 2 - GOAL + 8, W / 2 + GOAL - 8);
        const mine = puck.y < MID + 10 && !(puck.vy > 160 && puck.y > ai.y);
        const deep = fy < RAIL + MR * 2 + PR;
        let tx, ty;
        if (!mine || deep) { strike = 0; tx = homeX; ty = homeY; if (!mine) aim = rnd(-60, 60); }
        else if (puck.y > ai.y + 3) {
          let dx = fx2 - (W / 2 + aim), dy = fy - H; const d = hyp(dx, dy) || 1; dx /= d; dy /= d;
          const bx = fx2 + dx * (PR + MR + 4), by = fy + dy * (PR + MR + 4);
          if (strike <= 0 && hyp(ai.x - bx, ai.y - by) < P.tol) strike = .28;
          if (strike > 0) { tx = fx2 - dx * 45; ty = fy - dy * 45; } else { tx = bx; ty = by; }
        } else { strike = 0; ty = fy - PR - MR - 15; tx = fx2 + (ai.x < fx2 ? -1 : 1) * (PR + MR + 13); }
        moveMallet(ai, tx, ty, P.v, RAIL + MR, MID - MR, h);
      };
      function tick(dt) {
        X.fx.step(dt);
        if (goalGlow > 0) goalGlow = Math.max(0, goalGlow - dt * 1.4);
        if (X.dying || phase === 'over') { draw(); return; }
        if (phase !== 'play') {
          const h = dt / 2;
          for (let i = 0; i < 2; i++) { moveMallet(me, me.tx, me.ty, 1500, MID + MR, H - RAIL - MR, h); if (mode === '2') moveMallet(ai, ai.tx, ai.ty, 1500, RAIL + MR, MID - MR, h); else moveMallet(ai, W / 2, 80, 400, RAIL + MR, MID - MR, h); }
          draw(); return;
        }
        const n = 4, h = dt / n;
        for (let i = 0; i < n; i++) {
          moveMallet(me, me.tx, me.ty, 1500, MID + MR, H - RAIL - MR, h);
          if (mode === '2') moveMallet(ai, ai.tx, ai.ty, 1500, RAIL + MR, MID - MR, h); else aiStep(h);
          puck.x += puck.vx * h; puck.y += puck.vy * h;
          const k = Math.exp(-.32 * h); puck.vx *= k; puck.vy *= k;
          const sp = hyp(puck.vx, puck.vy); if (sp > 1100) { puck.vx *= 1100 / sp; puck.vy *= 1100 / sp; }
          collide(me, 0); collide(ai, 1);
          if (puck.x < RAIL + PR) { puck.x = RAIL + PR; puck.vx = Math.abs(puck.vx) * .9; X.snd('bounce', 90); }
          if (puck.x > W - RAIL - PR) { puck.x = W - RAIL - PR; puck.vx = -Math.abs(puck.vx) * .9; X.snd('bounce', 90); }
          const inMouth = Math.abs(puck.x - W / 2) < GOAL - PR * .3;
          if (puck.y < RAIL + PR && !inMouth) { puck.y = RAIL + PR; puck.vy = Math.abs(puck.vy) * .9; X.snd('bounce', 90); }
          if (puck.y > H - RAIL - PR && !inMouth) { puck.y = H - RAIL - PR; puck.vy = -Math.abs(puck.vy) * .9; X.snd('bounce', 90); }
          post(W / 2 - GOAL, RAIL + 6); post(W / 2 + GOAL, RAIL + 6); post(W / 2 - GOAL, H - RAIL - 6); post(W / 2 + GOAL, H - RAIL - 6);
          if (puck.y < -PR) { goal(true); break; }
          if (puck.y > H + PR) { goal(false); break; }
        }
        if (phase === 'play') trail.push(puck.x, puck.y);
        draw();
      }
      const mallet = (m, s) => { c.drawImage(MAL[s], m.x - 44, m.y - 42); };
      function draw() {
        c.drawImage(BG, 0, 0);
        led(sc[0], 0, MID + 124, false); led(sc[1], 1, MID - 124, mode === '2');
        if (goalGlow > 0) { const y = goalSide ? RAIL : H - RAIL, r = 60 + 40 * (1 - goalGlow); c.globalAlpha = goalGlow * .9; c.drawImage(LIGHT[goalSide ? 0 : 1], puck.x - r, y - r, r * 2, r * 2); c.globalAlpha = 1; }
        /* rasto do disco: só a alta velocidade, como um borrão */
        const sp = hyp(puck.vx, puck.vy);
        if (sp > 220) { const a = Math.min(1, (sp - 220) / 500); for (let i = trail.len - 1; i >= 1; i--) { const k = 1 - i / trail.len, ix = trail.ix(i); c.globalAlpha = .22 * k * a; c.drawImage(BLUR, trail.xs[ix] - PR, trail.ys[ix] - PR, PR * 2, PR * 2); } c.globalAlpha = 1; }
        if (phase === 'wait' && !X.dying) { const p = .5 + .5 * Math.sin(performance.now() / 160); c.globalAlpha = .35 * p; c.drawImage(BLUR, puck.x - 22, puck.y - 22, 44, 44); c.globalAlpha = 1; }
        c.drawImage(PUCK, puck.x - 26, puck.y - 25);
        mallet(ai, 1); mallet(me, 0);
        X.fx.draw(c);
        X.drawCount(c); X.drawWhite(c);
      }
      function key(e) {
        if (e.type === 'keyup') return;
        const k = e.key; let m = me, dx = 0, dy = 0;
        if (k === 'ArrowLeft') dx = -1; else if (k === 'ArrowRight') dx = 1; else if (k === 'ArrowUp') dy = -1; else if (k === 'ArrowDown') dy = 1;
        else { const w = { a: [-1, 0], d: [1, 0], w: [0, -1], s: [0, 1], A: [-1, 0], D: [1, 0], W: [0, -1], S: [0, 1] }[k]; if (!w) return; dx = w[0]; dy = w[1]; if (mode === '2') m = ai; }
        e.preventDefault();
        m.tx = clamp(m.x + dx * 34, RAIL + MR, W - RAIL - MR); m.ty = clamp(m.y + dy * 34, m === me ? MID + MR : RAIL + MR, m === me ? H - RAIL - MR : MID - MR);
      }
      /* o batedor segue o dedo dentro da sua metade; a dois, cada metade manda no seu */
      pointer(X, {
        down: p => { const s = mode === '2' ? (p.y > MID ? 0 : 1) : 0; ptr[p.id] = s; const m = s ? ai : me; m.tx = p.x; m.ty = p.y; },
        move: p => { const s = ptr[p.id]; if (s === undefined) return; const m = s ? ai : me; m.tx = p.x; m.ty = p.y; },
        up: p => { delete ptr[p.id]; },
      });
      const again = () => { X.A.setId(boardId()); hud(); if (X.running || X.dead) start(); };
      X.A.options([
        { key: 'lv', label: 'Dificuldade', values: LVL, cur: lv, onChange: v => { if (!AI[v]) return; lv = v; Arcade.setOpt('airhockey:lv', v); again(); } },
        { key: 'mode', label: 'Modo', values: MODE, cur: mode, onChange: v => { mode = v === '2' ? '2' : '1'; Arcade.setOpt('airhockey:mode', mode); again(); } },
        { key: 'to', label: 'Partida', values: TO, cur: String(to), onChange: v => { to = v === '11' ? 11 : 7; Arcade.setOpt('airhockey:to', String(to)); again(); } },
      ]);
      start();
      /* só para o harness e o teste: estado interno, sem efeitos */
      X.api.dbg = () => ({ puck: { x: puck.x, y: puck.y, vx: puck.vx, vy: puck.vy }, me: { x: me.x, y: me.y }, ai: { x: ai.x, y: ai.y }, sc: sc.slice(), phase, mode, lv, to });
      X.api.playNow = () => { if (X.running && phase === 'wait') { first = false; phase = 'play'; } };
      X.api.setSc = (a, b) => { sc[0] = a; sc[1] = b; hud(); };
      X.api.goalNow = mine => { if (X.running && !X.dead && !X.dying && phase !== 'over') { puck.x = W / 2 + rnd(-30, 30); puck.y = mine ? RAIL : H - RAIL; goal(!!mine); } };
      return X.api;
    },
  });

  /* =====================================================================
     CORTE (slice): dojo de madeira, oito frutos desenhados, bombas e especiais
     ===================================================================== */
  Icons.app.slice = () => Icons.SVG(Icons.G('gSl', '#7A4A22', '#5A3316', '#3E2210') + Icons.GL(
    `<path d="M8 30h84M8 52h84M8 74h84" stroke="#2C170A" stroke-opacity=".5" stroke-width="1.5"/>` +
    `<circle cx="40" cy="48" r="20" fill="#0E6B2E" opacity=".35" transform="translate(1 3)"/><circle cx="40" cy="48" r="20" fill="#1E8F3E"/><circle cx="40" cy="48" r="15.5" fill="#FFF8E6"/><circle cx="40" cy="48" r="13" fill="#FF3B4A"/>` +
    `<ellipse cx="35" cy="44" rx="1.6" ry="2.6" fill="#1A1A1A" transform="rotate(-30 35 44)"/><ellipse cx="44" cy="50" rx="1.6" ry="2.6" fill="#1A1A1A" transform="rotate(20 44 50)"/><ellipse cx="37" cy="54" rx="1.6" ry="2.6" fill="#1A1A1A" transform="rotate(60 37 54)"/>` +
    `<circle cx="70" cy="68" r="12" fill="#B35A00" opacity=".35" transform="translate(1 3)"/><circle cx="70" cy="68" r="12" fill="#FF9F0A"/><circle cx="66" cy="64" r="3.5" fill="#fff" opacity=".5"/>` +
    `<path d="M16 86L86 14" stroke="#FFD1DC" stroke-opacity=".5" stroke-width="7" stroke-linecap="round"/><path d="M16 86L86 14" stroke="#fff" stroke-width="3" stroke-linecap="round"/>`));

  const SL_COVER = () => COVER(
    `<rect width="400" height="200" fill="url(#slWood)"/><path d="M0 50h400M0 100h400M0 150h400" stroke="#2C170A" stroke-opacity=".55" stroke-width="2"/><path d="M0 52h400M0 102h400M0 152h400" stroke="#C98B4E" stroke-opacity=".18" stroke-width="1"/>` +
    `<rect width="400" height="200" fill="url(#slVig)"/>` +
    `<circle cx="120" cy="104" r="44" fill="#0E6B2E" opacity=".3" transform="translate(3 6)"/><circle cx="120" cy="104" r="44" fill="#1E8F3E"/><circle cx="120" cy="104" r="36" fill="#FFF8E6"/><circle cx="120" cy="104" r="31" fill="url(#slMelon)"/>` +
    `<ellipse cx="108" cy="94" rx="3" ry="5" fill="#1A1A1A" transform="rotate(-30 108 94)"/><ellipse cx="128" cy="100" rx="3" ry="5" fill="#1A1A1A" transform="rotate(25 128 100)"/><ellipse cx="112" cy="116" rx="3" ry="5" fill="#1A1A1A" transform="rotate(70 112 116)"/><ellipse cx="132" cy="118" rx="3" ry="5" fill="#1A1A1A" transform="rotate(-60 132 118)"/>` +
    `<circle cx="252" cy="70" r="26" fill="#B35A00" opacity=".3" transform="translate(3 6)"/><circle cx="252" cy="70" r="26" fill="url(#slOrange)"/><circle cx="243" cy="60" r="7" fill="#fff" opacity=".35"/>` +
    `<circle cx="318" cy="132" r="24" fill="#5A1C1C" opacity=".3" transform="translate(3 6)"/><circle cx="318" cy="132" r="24" fill="url(#slApple)"/><path d="M318 108c0-6 4-10 4-10" stroke="#5B3A1E" stroke-width="3" stroke-linecap="round" fill="none"/><ellipse cx="327" cy="104" rx="8" ry="4" fill="#30B14A" transform="rotate(-25 327 104)"/>` +
    `<path d="M40 170L360 30" stroke="#FF375F" stroke-opacity=".45" stroke-width="14" stroke-linecap="round"/><path d="M40 170L360 30" stroke="#fff" stroke-width="5" stroke-linecap="round"/>` +
    `<circle cx="200" cy="128" r="5" fill="#FF3B4A" opacity=".8"/><circle cx="214" cy="140" r="3" fill="#FF3B4A" opacity=".7"/><circle cx="188" cy="144" r="2.5" fill="#FF3B4A" opacity=".6"/>`,
    `<defs><linearGradient id="slWood" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#A86F3C"/><stop offset=".5" stop-color="#8B5A2B"/><stop offset="1" stop-color="#6E4320"/></linearGradient><radialGradient id="slVig" cx="50%" cy="50%" r="70%"><stop offset=".4" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".5"/></radialGradient><radialGradient id="slMelon" cx="45%" cy="40%" r="70%"><stop offset="0" stop-color="#FF6B6B"/><stop offset="1" stop-color="#E0202E"/></radialGradient><radialGradient id="slOrange" cx="35%" cy="30%" r="80%"><stop offset="0" stop-color="#FFC14D"/><stop offset="1" stop-color="#E07000"/></radialGradient><radialGradient id="slApple" cx="35%" cy="30%" r="80%"><stop offset="0" stop-color="#FF6B5E"/><stop offset="1" stop-color="#B0121B"/></radialGradient></defs>`);

  const SL_MODES = [{ v: 'classico', label: 'Clássico' }, { v: 'arcada', label: 'Arcada' }, { v: 'zen', label: 'Zen' }];
  Arcade.game('slice', {
    name: 'Corte', color: '#FF375F', kind: 'action',
    /* tabelas: Clássico continua em 'slice' (a de sempre); Arcada e Zen são novas ('slice:arcada', 'slice:zen') */
    variants: SL_MODES.map(m => ({ key: m.v, label: m.label, board: m.v === 'classico' ? 'slice' : 'slice:' + m.v })),
    desc: 'Dojo de madeira e oito frutos desenhados a sério: melancia, laranja, maçã, banana, kiwi, morango, limão e ananás. Corta-os com o dedo, encadeia combos, foge das bombas e apanha os frutos especiais. Três modos: Clássico, Arcada e Zen.',
    tags: ['Dojo', 'Reflexos', 'Combos'],
    modes: SL_MODES.map(m => ({ key: m.v, label: m.label })),
    cover: SL_COVER,
    howto: { goal: 'Corta o máximo de frutos sem deixar cair três nem tocar numa bomba.',
      steps: ['Passa o dedo pelos frutos; vários num só traço dão combo', 'O multiplicador sobe a cada oito cortes seguidos e cai quando falhas', 'Frutos especiais: frenesim (chuva de frutos), gelo (tudo em câmara lenta) e pontos a dobrar', 'Arcada: 60 s e as bombas tiram 10 pontos. Zen: 90 s sem bombas'],
      controls: [{ icon: 'hand', label: 'Arrasta o dedo pelo palco' }] },
    build(win) {
      const W = 400, H = 680, GR = 1150, S = 96, HS = 48, OMAX = 14, HMAX = 14, SMAX = 22, BN = 26;
      const KB = 8, KF = 9, KI = 10, KD = 11;   /* bomba, frenesim, gelo, dobrar */
      let modeKey = Arcade.opt('slice:mode', 'classico'); if (!SL_MODES.some(m => m.v === modeKey)) modeKey = 'classico';
      const boardId = () => (modeKey === 'classico' ? 'slice' : 'slice:' + modeKey);
      let score, lives, T, wave, mult, streak, combo, lastCut, lastX, lastY, maxCombo, maxMult, cuts, thrown, bombs, timeLeft, lastSec, frenzy, ice, dbl, queueN, bladeN, checked, bladeId, go = false, clk = 0;
      const X = host(win, { id: boardId(), name: 'Corte', color: '#FF375F', W, H, particles: 220, restart: () => start(), tick, draw, onResume: () => { bladeId = null; bladeN = 0; } });
      const c = X.ctx;
      /* ---- frutos: desenho de cada um (fora e por dentro), centrado em 0,0 ---- */
      const F = [
        { col: '#FF3B4A', juice: '#E0202E', r: 30,
          out(b, r) { b.fillStyle = rgrad(b, -r * .35, -r * .4, r * .1, 0, 0, r, [[0, '#4FD66B'], [.5, '#1E8F3E'], [1, '#0B4F1F']]); b.beginPath(); b.arc(0, 0, r, 0, TAU); b.fill();
            b.save(); b.beginPath(); b.arc(0, 0, r, 0, TAU); b.clip(); b.strokeStyle = 'rgba(6,60,24,.55)'; b.lineWidth = 5; b.lineCap = 'round';
            for (let i = -2; i <= 2; i++) { b.beginPath(); b.moveTo(i * 12 - 6, -r - 4); b.quadraticCurveTo(i * 12 + 8, 0, i * 12 - 6, r + 4); b.stroke(); } b.restore();
            b.fillStyle = 'rgba(255,255,255,.35)'; b.beginPath(); b.ellipse(-r * .4, -r * .45, r * .28, r * .14, -.7, 0, TAU); b.fill(); },
          in(b, r) { b.fillStyle = '#1E8F3E'; b.beginPath(); b.arc(0, 0, r, 0, TAU); b.fill(); b.fillStyle = '#FFF8E6'; b.beginPath(); b.arc(0, 0, r - 3.5, 0, TAU); b.fill();
            b.fillStyle = rgrad(b, -r * .2, -r * .2, 1, 0, 0, r - 7, [[0, '#FF8A80'], [.6, '#FF3B4A'], [1, '#D8182A']]); b.beginPath(); b.arc(0, 0, r - 7, 0, TAU); b.fill();
            b.fillStyle = '#1A1A1A'; for (let i = 0; i < 7; i++) { const a = i * TAU / 7 + .4, d = r * .5; b.beginPath(); b.ellipse(Math.cos(a) * d, Math.sin(a) * d, 2, 3.4, a, 0, TAU); b.fill(); } } },
        { col: '#FF9F0A', juice: '#F08A00', r: 27,
          out(b, r) { b.fillStyle = rgrad(b, -r * .35, -r * .35, r * .1, 0, 0, r, [[0, '#FFC957'], [.55, '#FF9F0A'], [1, '#C85E00']]); b.beginPath(); b.arc(0, 0, r, 0, TAU); b.fill();
            b.fillStyle = 'rgba(150,70,0,.22)'; for (let i = 0; i < 26; i++) { const a = i * 2.4, d = Math.sqrt(i / 26) * r * .9; b.beginPath(); b.arc(Math.cos(a) * d, Math.sin(a) * d, 1.3, 0, TAU); b.fill(); }
            b.fillStyle = 'rgba(255,255,255,.4)'; b.beginPath(); b.ellipse(-r * .4, -r * .42, r * .26, r * .13, -.7, 0, TAU); b.fill();
            b.fillStyle = '#B35A00'; b.beginPath(); b.arc(r * .3, r * .55, 3, 0, TAU); b.fill(); },
          in(b, r) { b.fillStyle = '#FF9F0A'; b.beginPath(); b.arc(0, 0, r, 0, TAU); b.fill(); b.fillStyle = '#FFF1D6'; b.beginPath(); b.arc(0, 0, r - 3, 0, TAU); b.fill();
            b.fillStyle = rgrad(b, 0, 0, 1, 0, 0, r - 6, [[0, '#FFD27A'], [1, '#FFA526']]); b.beginPath(); b.arc(0, 0, r - 6, 0, TAU); b.fill();
            b.strokeStyle = '#FFF1D6'; b.lineWidth = 2.2; for (let i = 0; i < 9; i++) { const a = i * TAU / 9; b.beginPath(); b.moveTo(0, 0); b.lineTo(Math.cos(a) * (r - 6), Math.sin(a) * (r - 6)); b.stroke(); }
            b.fillStyle = '#FFF1D6'; b.beginPath(); b.arc(0, 0, 3, 0, TAU); b.fill(); } },
        { col: '#FF3B30', juice: '#C8101A', r: 27,
          out(b, r) { b.fillStyle = rgrad(b, -r * .35, -r * .4, r * .1, 0, 0, r, [[0, '#FF7B6E'], [.5, '#E8281F'], [1, '#8E0E14']]); b.beginPath(); b.moveTo(0, -r * .82); b.bezierCurveTo(r * .55, -r * 1.15, r * 1.08, -r * .5, r * .95, r * .15); b.bezierCurveTo(r * .85, r * .75, r * .35, r * 1.02, 0, r * .9); b.bezierCurveTo(-r * .35, r * 1.02, -r * .85, r * .75, -r * .95, r * .15); b.bezierCurveTo(-r * 1.08, -r * .5, -r * .55, -r * 1.15, 0, -r * .82); b.fill();
            b.fillStyle = 'rgba(255,220,120,.28)'; b.beginPath(); b.ellipse(r * .3, r * .2, r * .3, r * .4, .4, 0, TAU); b.fill();
            b.fillStyle = 'rgba(255,255,255,.4)'; b.beginPath(); b.ellipse(-r * .4, -r * .4, r * .22, r * .12, -.7, 0, TAU); b.fill();
            b.strokeStyle = '#5B3A1E'; b.lineWidth = 3; b.lineCap = 'round'; b.beginPath(); b.moveTo(0, -r * .75); b.quadraticCurveTo(r * .1, -r * 1.05, r * .2, -r * 1.2); b.stroke();
            b.fillStyle = '#30B14A'; b.beginPath(); b.ellipse(r * .35, -r * 1.05, r * .3, r * .13, -.5, 0, TAU); b.fill(); },
          in(b, r) { b.fillStyle = '#E8281F'; b.beginPath(); b.arc(0, 0, r, 0, TAU); b.fill(); b.fillStyle = '#FFF3D6'; b.beginPath(); b.arc(0, 0, r - 2.5, 0, TAU); b.fill();
            b.fillStyle = '#FBE7B4'; b.beginPath(); b.ellipse(0, 0, r * .3, r * .42, 0, 0, TAU); b.fill();
            b.fillStyle = '#3B2A1A'; b.beginPath(); b.ellipse(-4, 0, 2, 4, .3, 0, TAU); b.fill(); b.beginPath(); b.ellipse(4, 0, 2, 4, -.3, 0, TAU); b.fill(); } },
        { col: '#FFD60A', juice: '#F2C200', r: 28,
          /* banana: crescente cheio (curva de fora em baixo, de dentro em cima), pé verde-castanho numa ponta, bico escuro na outra */
          out(b, r) {
            const ban = k => { b.beginPath(); b.moveTo(-r * .95 * k, -r * .6 * k); b.quadraticCurveTo(-r * .4 * k, r * 1.2 * k, r * .95 * k, r * .15 * k); b.quadraticCurveTo(-r * .1 * k, r * .35 * k, -r * .95 * k, -r * .6 * k); b.closePath(); };
            b.fillStyle = lgrad(b, 0, -r * .6, 0, r * .9, [[0, '#FFF29A'], [.45, '#FFD60A'], [1, '#C28E00']]); ban(1); b.fill();
            b.strokeStyle = 'rgba(120,80,0,.55)'; b.lineWidth = 1.4; ban(1); b.stroke();
            b.strokeStyle = 'rgba(150,100,0,.35)'; b.lineWidth = 1.5; b.beginPath(); b.moveTo(-r * .86, -r * .48); b.quadraticCurveTo(-r * .3, r * .82, r * .86, r * .17); b.stroke();
            b.strokeStyle = 'rgba(255,255,255,.55)'; b.lineWidth = 2.5; b.lineCap = 'round'; b.beginPath(); b.moveTo(-r * .7, -r * .36); b.quadraticCurveTo(-r * .15, r * .42, r * .55, r * .2); b.stroke();
            b.strokeStyle = '#6E8A2A'; b.lineWidth = 5; b.beginPath(); b.moveTo(-r * .92, -r * .56); b.lineTo(-r * 1.1, -r * .82); b.stroke();
            b.fillStyle = '#4A3A1A'; b.beginPath(); b.arc(-r * 1.1, -r * .82, 2.8, 0, TAU); b.fill();
            b.fillStyle = '#3B2A12'; b.beginPath(); b.arc(r * .93, r * .15, 2.6, 0, TAU); b.fill(); },
          in(b, r) {
            const ban = k => { b.beginPath(); b.moveTo(-r * .95 * k, -r * .6 * k); b.quadraticCurveTo(-r * .4 * k, r * 1.2 * k, r * .95 * k, r * .15 * k); b.quadraticCurveTo(-r * .1 * k, r * .35 * k, -r * .95 * k, -r * .6 * k); b.closePath(); };
            b.fillStyle = '#F2C230'; ban(1); b.fill();
            b.save(); b.translate(-r * .08, r * .14); b.fillStyle = '#FFF4C8'; ban(.84); b.fill(); b.restore();
            b.strokeStyle = 'rgba(200,160,60,.5)'; b.lineWidth = 1.6; b.beginPath(); b.moveTo(-r * .78, -r * .38); b.quadraticCurveTo(-r * .3, r * .78, r * .78, r * .18); b.stroke();
            b.fillStyle = 'rgba(110,70,20,.55)'; for (let i = 0; i < 6; i++) { const t = .15 + i * .14, x = (1 - t) * (1 - t) * -r * .78 + 2 * (1 - t) * t * -r * .3 + t * t * r * .78, y = (1 - t) * (1 - t) * -r * .38 + 2 * (1 - t) * t * r * .78 + t * t * r * .18; b.beginPath(); b.arc(x, y, 1.3, 0, TAU); b.fill(); } } },
        { col: '#8BD34A', juice: '#5FA820', r: 25,
          /* kiwi: oval castanho-azeitona com pelo (traços curtos claros e escuros), pé seco numa ponta e brilho suave */
          out(b, r) { b.rotate(.35); b.fillStyle = rgrad(b, -r * .35, -r * .4, r * .1, 0, 0, r * 1.15, [[0, '#B59562'], [.55, '#86663A'], [1, '#4E3618']]); b.beginPath(); b.ellipse(0, 0, r * .92, r * 1.15, 0, 0, TAU); b.fill();
            b.lineCap = 'round'; b.lineWidth = 1;
            for (let i = 0; i < 90; i++) { const a = i * 2.39996, d = Math.sqrt((i + .5) / 90) * r * .88, x = Math.cos(a) * d * .92, y = Math.sin(a) * d * 1.12, an = a * 3.7; b.strokeStyle = i % 3 ? 'rgba(60,40,15,.32)' : 'rgba(240,220,170,.28)'; b.beginPath(); b.moveTo(x, y); b.lineTo(x + Math.cos(an) * 2.6, y + Math.sin(an) * 2.6); b.stroke(); }
            b.strokeStyle = 'rgba(40,25,8,.5)'; b.lineWidth = 1.2; b.beginPath(); b.ellipse(0, 0, r * .92, r * 1.15, 0, 0, TAU); b.stroke();
            b.fillStyle = '#3C2A12'; b.beginPath(); b.ellipse(0, -r * 1.12, 3.5, 2.4, 0, 0, TAU); b.fill(); b.fillStyle = '#6A5228'; b.beginPath(); b.arc(0, -r * 1.13, 1.4, 0, TAU); b.fill();
            b.fillStyle = 'rgba(255,255,255,.2)'; b.beginPath(); b.ellipse(-r * .38, -r * .5, r * .2, r * .12, -.7, 0, TAU); b.fill(); },
          in(b, r) { b.fillStyle = '#7A5230'; b.beginPath(); b.ellipse(0, 0, r, r * 1.12, 0, 0, TAU); b.fill();
            b.fillStyle = rgrad(b, 0, 0, 2, 0, 0, r, [[0, '#E9F7C8'], [.3, '#B8E66A'], [1, '#6DBE2C']]); b.beginPath(); b.ellipse(0, 0, r - 2.5, r * 1.12 - 2.5, 0, 0, TAU); b.fill();
            b.fillStyle = '#F4F9DD'; b.beginPath(); b.ellipse(0, 0, r * .28, r * .4, 0, 0, TAU); b.fill();
            b.fillStyle = '#1B1B1B'; for (let i = 0; i < 14; i++) { const a = i * TAU / 14, d = r * .5; b.beginPath(); b.ellipse(Math.cos(a) * d, Math.sin(a) * d * 1.15, 1.3, 2.3, a, 0, TAU); b.fill(); } } },
        { col: '#FF2D55', juice: '#D4133A', r: 27,
          out(b, r) { b.fillStyle = rgrad(b, -r * .3, -r * .4, r * .1, 0, 0, r * 1.1, [[0, '#FF6B86'], [.5, '#F0203F'], [1, '#9E0E28']]); b.beginPath(); b.moveTo(0, r * 1.05); b.bezierCurveTo(-r * 1.1, r * .3, -r * .95, -r * .75, 0, -r * .7); b.bezierCurveTo(r * .95, -r * .75, r * 1.1, r * .3, 0, r * 1.05); b.fill();
            b.fillStyle = '#FFE07A'; for (let i = 0; i < 16; i++) { const a = i * 2.4, d = Math.sqrt(i / 16) * r * .7; b.beginPath(); b.ellipse(Math.cos(a) * d, Math.sin(a) * d * 1.05, 1.3, 2, a, 0, TAU); b.fill(); }
            b.fillStyle = 'rgba(255,255,255,.35)'; b.beginPath(); b.ellipse(-r * .35, -r * .3, r * .2, r * .1, -.7, 0, TAU); b.fill();
            b.fillStyle = '#2E9E3F'; for (let i = 0; i < 5; i++) { const a = -Math.PI / 2 + (i - 2) * .55; b.beginPath(); b.ellipse(Math.cos(a) * r * .35, -r * .62 + Math.sin(a) * r * .25, r * .3, r * .11, a, 0, TAU); b.fill(); }
            b.fillStyle = '#5B3A1E'; b.beginPath(); b.arc(0, -r * .72, 2.2, 0, TAU); b.fill(); },
          in(b, r) { b.fillStyle = '#F0203F'; b.beginPath(); b.moveTo(0, r * 1.05); b.bezierCurveTo(-r * 1.1, r * .3, -r * .95, -r * .75, 0, -r * .7); b.bezierCurveTo(r * .95, -r * .75, r * 1.1, r * .3, 0, r * 1.05); b.fill();
            b.fillStyle = rgrad(b, 0, 0, 1, 0, 0, r * .85, [[0, '#FFF4F6'], [.45, '#FFB6C6'], [1, '#FF5C7A']]); b.beginPath(); b.moveTo(0, r * .9); b.bezierCurveTo(-r * .9, r * .25, -r * .78, -r * .58, 0, -r * .55); b.bezierCurveTo(r * .78, -r * .58, r * .9, r * .25, 0, r * .9); b.fill();
            b.fillStyle = '#FFE07A'; for (let i = 0; i < 10; i++) { const a = i * TAU / 10 + .3; b.beginPath(); b.arc(Math.cos(a) * r * .62, Math.sin(a) * r * .66, 1.3, 0, TAU); b.fill(); } } },
        { col: '#FFE033', juice: '#E8C400', r: 25,
          out(b, r) { b.fillStyle = rgrad(b, -r * .3, -r * .35, r * .1, 0, 0, r * 1.2, [[0, '#FFF59A'], [.55, '#FFE033'], [1, '#C9A800']]); b.beginPath(); b.ellipse(0, 0, r * 1.15, r * .9, 0, 0, TAU); b.fill(); b.beginPath(); b.ellipse(-r * 1.08, 0, r * .18, r * .14, 0, 0, TAU); b.fill(); b.beginPath(); b.ellipse(r * 1.08, 0, r * .18, r * .14, 0, 0, TAU); b.fill();
            b.fillStyle = 'rgba(180,140,0,.2)'; for (let i = 0; i < 24; i++) { const a = i * 2.4, d = Math.sqrt(i / 24) * r * .85; b.beginPath(); b.arc(Math.cos(a) * d * 1.1, Math.sin(a) * d * .85, 1.2, 0, TAU); b.fill(); }
            b.fillStyle = 'rgba(255,255,255,.45)'; b.beginPath(); b.ellipse(-r * .45, -r * .4, r * .26, r * .12, -.5, 0, TAU); b.fill(); },
          in(b, r) { b.fillStyle = '#FFE033'; b.beginPath(); b.ellipse(0, 0, r * 1.15, r * .9, 0, 0, TAU); b.fill(); b.fillStyle = '#FFFBE0'; b.beginPath(); b.ellipse(0, 0, r * 1.15 - 3, r * .9 - 3, 0, 0, TAU); b.fill();
            b.fillStyle = rgrad(b, 0, 0, 1, 0, 0, r, [[0, '#FFF9C4'], [1, '#FFE66B']]); b.beginPath(); b.ellipse(0, 0, r * 1.15 - 6, r * .9 - 6, 0, 0, TAU); b.fill();
            b.strokeStyle = '#FFFBE0'; b.lineWidth = 2; for (let i = 0; i < 8; i++) { const a = i * TAU / 8; b.beginPath(); b.moveTo(0, 0); b.lineTo(Math.cos(a) * (r * 1.15 - 6), Math.sin(a) * (r * .9 - 6)); b.stroke(); }
            b.fillStyle = '#FFFBE0'; b.beginPath(); b.arc(0, 0, 2.5, 0, TAU); b.fill(); } },
        { col: '#FFC53D', juice: '#E9A800', r: 30,
          out(b, r) { b.fillStyle = '#2E9E3F'; for (let i = 0; i < 7; i++) { const a = -Math.PI / 2 + (i - 3) * .3; b.beginPath(); b.moveTo(Math.cos(a + 1.5) * 4, -r * .45 + Math.sin(a + 1.5) * 4); b.lineTo(Math.cos(a) * r * 1.35, -r * .45 + Math.sin(a) * r * 1.35 * .9); b.lineTo(Math.cos(a - 1.5) * 4, -r * .45 + Math.sin(a - 1.5) * 4); b.closePath(); b.fill(); }
            b.fillStyle = '#1C7A2E'; for (let i = 0; i < 4; i++) { const a = -Math.PI / 2 + (i - 1.5) * .42; b.beginPath(); b.moveTo(Math.cos(a + 1.5) * 3, -r * .45 + Math.sin(a + 1.5) * 3); b.lineTo(Math.cos(a) * r * 1.0, -r * .45 + Math.sin(a) * r * 1.0 * .9); b.lineTo(Math.cos(a - 1.5) * 3, -r * .45 + Math.sin(a - 1.5) * 3); b.closePath(); b.fill(); }
            b.fillStyle = rgrad(b, -r * .3, -r * .1, r * .1, 0, r * .2, r * 1.1, [[0, '#FFD766'], [.5, '#E9A024'], [1, '#8F5A12']]); b.beginPath(); b.ellipse(0, r * .25, r * .78, r * .95, 0, 0, TAU); b.fill();
            b.save(); b.beginPath(); b.ellipse(0, r * .25, r * .78, r * .95, 0, 0, TAU); b.clip(); b.strokeStyle = 'rgba(90,50,10,.5)'; b.lineWidth = 1.6;
            for (let i = -4; i <= 4; i++) { b.beginPath(); b.moveTo(-r + i * 9, -r); b.lineTo(r + i * 9, r * 1.5); b.stroke(); b.beginPath(); b.moveTo(r - i * 9, -r); b.lineTo(-r - i * 9, r * 1.5); b.stroke(); }
            b.fillStyle = 'rgba(60,30,5,.5)'; for (let y = -r * .5; y < r * 1.1; y += 9) for (let x = -r * .6; x < r * .7; x += 9) { b.beginPath(); b.arc(x + ((y / 9) % 2 ? 4.5 : 0), y, 1.1, 0, TAU); b.fill(); } b.restore();
            b.fillStyle = 'rgba(255,255,255,.28)'; b.beginPath(); b.ellipse(-r * .35, -r * .15, r * .18, r * .3, .2, 0, TAU); b.fill(); },
          in(b, r) { b.fillStyle = '#A8681E'; b.beginPath(); b.ellipse(0, r * .25, r * .78, r * .95, 0, 0, TAU); b.fill();
            b.fillStyle = rgrad(b, 0, r * .25, 1, 0, r * .25, r, [[0, '#FFF2B0'], [.35, '#FFD966'], [1, '#F2B225']]); b.beginPath(); b.ellipse(0, r * .25, r * .78 - 3, r * .95 - 3, 0, 0, TAU); b.fill();
            b.fillStyle = '#FFF5C8'; b.beginPath(); b.ellipse(0, r * .25, r * .14, r * .62, 0, 0, TAU); b.fill();
            b.strokeStyle = 'rgba(200,140,40,.35)'; b.lineWidth = 1.2; for (let i = -3; i <= 3; i++) { b.beginPath(); b.moveTo(-r * .7, r * .25 + i * 8); b.lineTo(r * .7, r * .25 + i * 8); b.stroke(); } } },
      ];
      const WHOLE = [], CUT = [], SPLAT = [];
      F.forEach(f => {
        WHOLE.push(spr(S, S, b => { b.translate(HS, HS); b.shadowColor = 'rgba(0,0,0,.35)'; b.shadowBlur = 6; b.shadowOffsetY = 3; f.out(b, f.r); }));
        CUT.push(spr(S, S, b => { b.translate(HS, HS); f.in(b, f.r); }));
        /* salpico orgânico: mancha central de círculos sobrepostos, escorridos a sair em raio e gotas soltas, com brilho húmido */
        for (let v = 0; v < 2; v++) SPLAT.push(spr(128, 128, b => {
          b.translate(64, 64); b.fillStyle = f.juice; b.globalAlpha = .82;
          b.beginPath(); b.arc(0, 0, 17, 0, TAU); b.fill();
          for (let i = 0; i < 9; i++) { const a = i * TAU / 9 + v * .5 + Math.sin(i * 3.1) * .3, d = 12 + ((i * 7 + v * 3) % 5) * 2.4, r = 7 + ((i * 5 + v) % 4) * 2; b.beginPath(); b.arc(Math.cos(a) * d, Math.sin(a) * d, r, 0, TAU); b.fill(); }
          b.lineCap = 'round'; b.strokeStyle = f.juice;
          for (let i = 0; i < 6; i++) { const a = i * TAU / 6 + v * .9 + .3, l0 = 20, l1 = 34 + ((i * 3 + v) % 4) * 6; b.lineWidth = 4.5 - (i % 3); b.beginPath(); b.moveTo(Math.cos(a) * l0, Math.sin(a) * l0); b.lineTo(Math.cos(a) * l1, Math.sin(a) * l1); b.stroke(); b.beginPath(); b.arc(Math.cos(a) * (l1 + 1), Math.sin(a) * (l1 + 1), b.lineWidth * .75, 0, TAU); b.fill(); }
          for (let i = 0; i < 9; i++) { const a = i * 2.3 + v * 1.7, d = 40 + ((i * 7) % 5) * 4; b.beginPath(); b.arc(Math.cos(a) * d, Math.sin(a) * d, 1.6 + (i % 3) * 1.2, 0, TAU); b.fill(); }
          b.globalAlpha = .4; b.fillStyle = f.col; b.beginPath(); b.arc(-3, -2, 11, 0, TAU); b.fill();
          b.globalAlpha = .3; b.fillStyle = '#fff'; b.beginPath(); b.ellipse(-8, -9, 6, 3, -.7, 0, TAU); b.fill();
        }));
      });
      /* bomba com rastilho, e os três especiais: frenesim (estrela magenta), gelo (cristal azul), dobrar (moeda dourada "2×") */
      const BOMB_R = 24;
      WHOLE[KB] = spr(S, S, b => { b.translate(HS, HS + 4); b.shadowColor = 'rgba(0,0,0,.4)'; b.shadowBlur = 6; b.shadowOffsetY = 3;
        b.fillStyle = rgrad(b, -8, -9, 2, 0, 0, BOMB_R, [[0, '#6A6D7C'], [.4, '#2A2C34'], [1, '#0A0B0E']]); b.beginPath(); b.arc(0, 0, BOMB_R, 0, TAU); b.fill(); b.shadowBlur = 0; b.shadowOffsetY = 0;
        b.fillStyle = '#3A3D48'; b.fillRect(-7, -BOMB_R - 6, 14, 9); b.fillStyle = '#50535F'; b.fillRect(-5, -BOMB_R - 4, 10, 2);
        b.strokeStyle = '#D8C7A0'; b.lineWidth = 3; b.lineCap = 'round'; b.beginPath(); b.moveTo(0, -BOMB_R - 6); b.quadraticCurveTo(6, -BOMB_R - 16, 14, -BOMB_R - 12); b.stroke();
        b.fillStyle = 'rgba(255,255,255,.35)'; b.beginPath(); b.ellipse(-9, -10, 6, 3.5, -.7, 0, TAU); b.fill();
        b.strokeStyle = '#FF453A'; b.lineWidth = 3; b.beginPath(); b.moveTo(-7, -5); b.lineTo(7, 9); b.moveTo(7, -5); b.lineTo(-7, 9); b.stroke(); });
      WHOLE[KF] = spr(S, S, b => { b.translate(HS, HS); b.shadowColor = '#FF2DD1'; b.shadowBlur = 16; b.fillStyle = '#FF2DD1';
        b.beginPath(); for (let i = 0; i < 10; i++) { const a = -Math.PI / 2 + i * Math.PI / 5, d = i % 2 ? 13 : 27; b.lineTo(Math.cos(a) * d, Math.sin(a) * d); } b.closePath(); b.fill(); b.fill(); b.shadowBlur = 0;
        b.fillStyle = rgrad(b, -6, -8, 1, 0, 0, 26, [[0, '#FFD1F5'], [.5, '#FF5BDC'], [1, '#B4129A']]); b.fill();
        b.fillStyle = '#fff'; b.beginPath(); b.moveTo(-9, -5); b.lineTo(2, -18); b.lineTo(-1, -4); b.lineTo(9, -2); b.lineTo(-3, 14); b.lineTo(0, 1); b.closePath(); b.fill(); });
      WHOLE[KI] = spr(S, S, b => { b.translate(HS, HS); b.shadowColor = '#7FD5FF'; b.shadowBlur = 16; b.fillStyle = '#7FD5FF';
        b.beginPath(); for (let i = 0; i < 6; i++) { const a = i * Math.PI / 3; b.lineTo(Math.cos(a) * 27, Math.sin(a) * 27); } b.closePath(); b.fill(); b.fill(); b.shadowBlur = 0;
        b.fillStyle = lgrad(b, -20, -24, 20, 24, [[0, '#EAF9FF'], [.5, '#8BD9FF'], [1, '#2A8FD8']]); b.fill();
        b.strokeStyle = '#fff'; b.lineWidth = 2.5; b.lineCap = 'round'; for (let i = 0; i < 3; i++) { const a = i * Math.PI / 3 + Math.PI / 6; b.beginPath(); b.moveTo(Math.cos(a) * 18, Math.sin(a) * 18); b.lineTo(-Math.cos(a) * 18, -Math.sin(a) * 18); b.stroke(); for (const s of [1, -1]) { b.beginPath(); b.moveTo(Math.cos(a) * 10 * s, Math.sin(a) * 10 * s); b.lineTo(Math.cos(a + .6) * 15 * s, Math.sin(a + .6) * 15 * s); b.moveTo(Math.cos(a) * 10 * s, Math.sin(a) * 10 * s); b.lineTo(Math.cos(a - .6) * 15 * s, Math.sin(a - .6) * 15 * s); b.stroke(); } } });
      WHOLE[KD] = spr(S, S, b => { b.translate(HS, HS); b.shadowColor = '#FFD60A'; b.shadowBlur = 16; b.fillStyle = '#FFD60A'; b.beginPath(); b.arc(0, 0, 26, 0, TAU); b.fill(); b.fill(); b.shadowBlur = 0;
        b.fillStyle = rgrad(b, -8, -10, 1, 0, 0, 26, [[0, '#FFF4B8'], [.5, '#FFD60A'], [1, '#C79A00']]); b.fill();
        b.strokeStyle = '#A87F00'; b.lineWidth = 2.5; b.beginPath(); b.arc(0, 0, 20, 0, TAU); b.stroke();
        txt(b, '2×', 0, 1, 24, '#7A5A00', 800); });
      const BG = spr(W, H, (b, w, h) => {
        /* tábuas de madeira na horizontal, cada uma com o seu tom, veios, nós e junta com sombra e aresta clara */
        const PH = 68; let seed = 7; const rs = () => { seed = (seed * 9301 + 49297) % 233280; return seed / 233280; };
        for (let y = 0; y < h; y += PH) {
          const tone = 24 + rs() * 10, lum = 30 + rs() * 8;
          b.fillStyle = lgrad(b, 0, y, 0, y + PH, [[0, hsl(tone, 48, lum + 4)], [.5, hsl(tone, 46, lum)], [1, hsl(tone, 50, lum - 4)]]); b.fillRect(0, y, w, PH);
          b.strokeStyle = hsl(tone, 45, lum - 12, .55); b.lineWidth = 1.2;
          for (let i = 0; i < 11; i++) { const yy = y + 4 + rs() * (PH - 8), amp = 3 + rs() * 6, ph = rs() * 6; b.beginPath(); b.moveTo(0, yy); for (let x = 0; x <= w; x += 20) b.lineTo(x, yy + Math.sin(x / 55 + ph) * amp * Math.sin(x / 190 + ph)); b.stroke(); }
          /* nó da madeira: alongado no sentido do veio, com os veios a contorná-lo */
          if (rs() < .3) { const kx = rs() * w, ky = y + 14 + rs() * (PH - 28), kr = 9 + rs() * 7; b.fillStyle = hsl(tone, 50, lum - 14, .45); b.beginPath(); b.ellipse(kx, ky, kr, 2.6 + rs() * 1.4, 0, 0, TAU); b.fill(); b.strokeStyle = hsl(tone, 45, lum - 12, .4); b.lineWidth = 1; for (let q = 1; q <= 3; q++) { b.beginPath(); b.ellipse(kx, ky, kr + q * 6, 2.6 + q * 2.4, 0, 0, TAU); b.stroke(); } }
          b.fillStyle = 'rgba(0,0,0,.5)'; b.fillRect(0, y + PH - 2, w, 2); b.fillStyle = 'rgba(255,220,170,.14)'; b.fillRect(0, y, w, 1);
          const jx = (rs() * .8 + .1) * w; b.fillStyle = 'rgba(0,0,0,.35)'; b.fillRect(jx, y, 2, PH); b.fillStyle = 'rgba(255,220,170,.1)'; b.fillRect(jx + 2, y, 1, PH);
        }
        /* emblema do dojo ao centro e vinheta */
        b.strokeStyle = 'rgba(0,0,0,.09)'; b.lineWidth = 10; b.beginPath(); b.arc(w / 2, h / 2, 118, 0, TAU); b.stroke(); b.lineWidth = 3; b.beginPath(); b.arc(w / 2, h / 2, 100, 0, TAU); b.stroke();
        b.fillStyle = rgrad(b, w / 2, h / 2, 120, w / 2, h / 2, h * .72, [[0, 'rgba(0,0,0,0)'], [1, 'rgba(0,0,0,.62)']]); b.fillRect(0, 0, w, h);
      });
      const ICEBG = spr(W, H, (b, w, h) => { b.fillStyle = rgrad(b, w / 2, h / 2, 60, w / 2, h / 2, h * .7, [[0, 'rgba(127,213,255,.12)'], [1, 'rgba(60,140,220,.42)']]); b.fillRect(0, 0, w, h); });
      const TIP = spr(32, 32, b => { b.fillStyle = rgrad(b, 16, 16, 0, 16, 16, 16, [[0, 'rgba(255,255,255,1)'], [.25, 'rgba(255,220,232,.8)'], [1, 'rgba(255,55,95,0)']]); b.fillRect(0, 0, 32, 32); });
      /* ---- pools ---- */
      const orbs = new Array(OMAX); for (let i = 0; i < OMAX; i++) orbs[i] = { on: false, k: 0, x: 0, y: 0, vx: 0, vy: 0, r: 20, rot: 0, spin: 0, fuse: 0 };
      const halves = new Array(HMAX); for (let i = 0; i < HMAX; i++) { const cv = document.createElement('canvas'); cv.width = S; cv.height = S; halves[i] = { on: false, x: 0, y: 0, vx: 0, vy: 0, rot: 0, spin: 0, life: 0, cv, hc: cv.getContext('2d') }; }
      const splats = new Array(SMAX); for (let i = 0; i < SMAX; i++) splats[i] = { on: false, x: 0, y: 0, rot: 0, sp: 0, life: 0, max: 1, sc: 1 };
      const queue = new Array(6); for (let i = 0; i < 6; i++) queue[i] = { on: false, at: 0, k: 0 };
      const bx = new Float32Array(BN), by = new Float32Array(BN), bt = new Float64Array(BN), bl = new Float32Array(BN), bn = new Float32Array(BN);
      const timed = () => modeKey !== 'classico';
      const limit = () => (modeKey === 'arcada' ? 60 : 90);
      const hud = () => {
        if (timed()) X.A.setMid(hint(`${g('timer', 16)}<b class="tm">${fmtTime(timeLeft)}</b><i>·</i><b class="mu">x${mult}</b>`));
        else X.A.setMid(hint(`${X.A.hearts(lives, 3)}<i>·</i><b class="mu">x${mult}</b>`));
      };
      const hudTime = () => { const s = Math.ceil(timeLeft); if (s === lastSec) return; lastSec = s; const e = X.A.el.mid.querySelector('.tm'); if (e) e.textContent = fmtTime(s); };
      const free = (arr, n) => { for (let i = 0; i < n; i++) if (!arr[i].on) return arr[i]; let o = arr[0]; for (let i = 1; i < n; i++) if (arr[i].life < o.life) o = arr[i]; return o; };
      const throwOne = k => {
        let o = null; for (let i = 0; i < OMAX; i++) if (!orbs[i].on) { o = orbs[i]; break; } if (!o) return;
        const x = rnd(60, W - 60), hgt = rnd(H * .5, H * .84);
        o.on = true; o.k = k; o.x = x; o.y = H + 50; o.vx = (W / 2 - x) * rnd(.25, .55) + rnd(-40, 40); o.vy = -Math.sqrt(2 * GR * (hgt + 50));
        o.r = k < 8 ? F[k].r : k === KB ? BOMB_R : 26; o.rot = rnd(0, TAU); o.spin = rnd(-3, 3); o.fuse = 0; thrown += k < 8 ? 1 : 0;
      };
      const pickKind = () => {
        if (frenzy > 0) return (Math.random() * 8) | 0;
        const bombP = modeKey === 'zen' ? 0 : T < 6 ? 0 : Math.min(.24, .07 + T / 400);
        if (Math.random() < bombP) return KB;
        if (modeKey !== 'zen' && T > 10 && Math.random() < .035) return KF + ((Math.random() * 3) | 0);
        return (Math.random() * 8) | 0;
      };
      const reset = () => {
        score = 0; lives = 3; T = 0; wave = .5; mult = 1; streak = 0; combo = 0; lastCut = -1e9; lastX = 0; lastY = 0; maxCombo = 0; maxMult = 1; cuts = 0; thrown = 0; bombs = 0; timeLeft = limit(); lastSec = -1; frenzy = 0; ice = 0; dbl = 0; queueN = 0; bladeN = 0; checked = 0; bladeId = null; go = false;
        for (let i = 0; i < OMAX; i++) orbs[i].on = false; for (let i = 0; i < HMAX; i++) halves[i].on = false; for (let i = 0; i < SMAX; i++) splats[i].on = false; for (let i = 0; i < 6; i++) queue[i].on = false;
        X.A.setScore(0); hud();
      };
      const start = () => { reset(); X.A.setId(boardId()); X.begin('Corte', modeKey === 'zen' ? 'Noventa segundos de frutos, sem bombas' : modeKey === 'arcada' ? 'Sessenta segundos. As bombas tiram pontos' : 'Passa o dedo pelos frutos. Cuidado com as bombas').then(() => { if (X.running) { const tok = X.seq; X.countdown(3).then(() => { if (tok === X.seq && X.running) { go = true; wave = .2; } }); } }); };
      const stats = () => [{ label: 'Frutos cortados', value: String(cuts) }, { label: 'Maior combo', value: String(maxCombo) }, { label: 'Multiplicador máximo', value: 'x' + maxMult }, { label: 'Precisão', value: (thrown ? Math.round(100 * cuts / thrown) : 0) + '%' }];
      const finish = (title, why) => { flushCombo(); X.maxStat('sliceCombo', maxCombo); X.die({ title, sub: `${score} pontos`, score, win: !!why, board: boardId(), stats: stats() }, 1.1); };
      const flushCombo = () => {
        if (combo >= 3) { const bonus = combo * 10 * mult * (dbl > 0 ? 2 : 1); score += bonus; X.A.setScore(score); X.snd('combo', 0); X.flash(`Combo x${combo}`, 'big'); X.fx.text(clamp(lastX, 40, W - 40), lastY - 46, '+' + bonus, '#FFD60A', 26, 1.1); X.hitStop(.05); if (combo > maxCombo) { maxCombo = combo; X.maxStat('sliceCombo', combo); } }
        combo = 0;
      };
      const loseLife = why => {
        streak = 0; if (mult > 1) { mult = 1; X.toast('Multiplicador perdido'); }
        if (!timed()) { lives--; hud(); X.snd('fail', 0); X.haptic('medium'); if (lives <= 0) { finish(why, false); return; } }
        else hud();
      };
      const addSplat = (x, y, k) => { const s = free(splats, SMAX); s.on = true; s.x = x; s.y = y; s.rot = rnd(0, TAU); s.sp = k * 2 + ((Math.random() * 2) | 0); s.max = 6.5; s.life = s.max; s.sc = rnd(.7, 1.1); };
      /* o corte: as duas metades nascem AGORA em canvas próprios (clip ao meio-plano pelo ângulo da lâmina); por frame só drawImage */
      const cut = (o, ax, ay, bx2, by2, now) => {
        o.on = false;
        if (o.k === KB) {
          bombs++; X.white = 1; X.shake.hit(11); X.hitStop(.08); X.snd('explode', 0); X.haptic('heavy');
          X.fx.burst(o.x, o.y, '#FF9F0A', 26, 340, .9, 6, 300); X.fx.burst(o.x, o.y, '#FFD60A', 16, 420, .5, 3, 0, 1); X.fx.burst(o.x, o.y, '#3A3A3E', 14, 220, 1.1, 7, 400);
          X.flash('Bomba!', 'big'); flushCombo();
          if (modeKey === 'arcada') { score = Math.max(0, score - 10); X.A.setScore(score); X.fx.text(clamp(o.x, 40, W - 40), o.y - 30, '-10', '#FF453A', 28, 1); streak = 0; if (mult > 1) { mult = 1; hud(); } }
          else { lives = 1; loseLife('Cortaste uma bomba'); }
          return;
        }
        if (o.k >= KF) {
          X.fx.burst(o.x, o.y, o.k === KF ? '#FF2DD1' : o.k === KI ? '#7FD5FF' : '#FFD60A', 24, 260, .7, 4); X.snd('powerup', 0); X.white = .5;
          if (o.k === KF) { frenzy = 4.5; wave = 0; X.flash('Frenesim!', 'big'); } else if (o.k === KI) { ice = 4.5; X.flash('Gelo', 'big'); } else { dbl = 8; X.flash('Pontos a dobrar', 'big'); }
          return;
        }
        const f = F[o.k], a = Math.atan2(by2 - ay, bx2 - ax), nx = -Math.sin(a), ny = Math.cos(a), la = a - o.rot;
        for (let sd = -1; sd <= 1; sd += 2) {
          const h = free(halves, HMAX), hc = h.hc;
          hc.setTransform(1, 0, 0, 1, 0, 0); hc.clearRect(0, 0, S, S);
          hc.save(); hc.translate(HS, HS); hc.rotate(la); hc.beginPath(); hc.rect(-HS - 10, sd > 0 ? 0 : -HS - 10, S + 20, HS + 10); hc.clip();
          hc.rotate(-la); hc.drawImage(CUT[o.k], -HS, -HS);
          hc.rotate(la); hc.strokeStyle = 'rgba(255,255,255,.45)'; hc.lineWidth = 2.5; hc.lineCap = 'round'; hc.beginPath(); hc.moveTo(-f.r * 1.1, 0); hc.lineTo(f.r * 1.1, 0); hc.stroke();
          hc.restore();
          h.on = true; h.x = o.x + nx * sd * 4; h.y = o.y + ny * sd * 4; h.vx = o.vx + nx * sd * 110 + rnd(-20, 20); h.vy = Math.min(o.vy, 0) * .45 + ny * sd * 110 - 80; h.rot = o.rot; h.spin = o.spin + sd * rnd(1.5, 3.5); h.life = 1.4;
        }
        X.fx.burst(o.x, o.y, f.col, 12, 230, .6, 4, 900); X.fx.cone(o.x, o.y, f.juice, 6, a + Math.PI / 2, .5, 260, .5, 3, 900); X.fx.cone(o.x, o.y, f.juice, 6, a - Math.PI / 2, .5, 260, .5, 3, 900);
        addSplat(o.x, o.y, o.k); X.snd('cut', 30); X.snd('splash', 120);
        const pts = 10 * mult * (dbl > 0 ? 2 : 1); score += pts; cuts++; X.A.setScore(score);
        streak++; if (streak % 8 === 0 && mult < 5) { mult += .5; if (mult > maxMult) maxMult = mult; hud(); X.flash(`Multiplicador x${mult}`, 'bonus'); X.snd('bonus', 0); }
        if (now - lastCut < 260) combo++; else { flushCombo(); combo = 1; }
        lastCut = now; lastX = o.x; lastY = o.y;
      };
      /* cada segmento novo da lâmina contra cada esfera viva (no frame, e também antes de a fila cheia deitar pontos fora:
         um traço muito rápido entre dois frames nunca perde segmentos). Também depois de levantar o dedo. */
      const checkBlade = tn => {
        if (X.dying || bladeN < 2 || !X.alive()) { checked = bladeN; return; }
        for (let i = Math.max(1, checked); i < bladeN && !X.dying; i++) {
          const ax = bx[i - 1], ay = by[i - 1], cx2 = bx[i], cy2 = by[i];
          if (hyp(cx2 - ax, cy2 - ay) < 3) continue;
          for (let j = 0; j < OMAX; j++) { const o = orbs[j]; if (o.on && segDist(o.x, o.y, ax, ay, cx2, cy2) < o.r + 3) { cut(o, ax, ay, cx2, cy2, tn); if (X.dying) break; } }
        }
        checked = bladeN;
      };
      const bladeAdd = (x, y, now) => {
        if (bladeN >= BN) { if (checked < bladeN) checkBlade(now); bx.copyWithin(0, 1); by.copyWithin(0, 1); bt.copyWithin(0, 1); bladeN--; checked = Math.max(0, checked - 1); }
        bx[bladeN] = x; by[bladeN] = y; bt[bladeN] = now; bladeN++;
      };
      function tick(dt) {
        /* relógio do JOGO (não de parede): combos e lâmina contam o tempo jogado, a pausa e o hit stop não os quebram */
        clk += dt; const tn = clk * 1000, pd = ice > 0 ? dt * .42 : dt;
        X.fx.step(dt);
        if (frenzy > 0) frenzy -= dt; if (ice > 0) { ice -= dt; if (ice <= 0) X.snd('tick', 0); } if (dbl > 0) { dbl -= dt; if (dbl <= 0) X.snd('tick', 0); }
        for (let i = 0; i < HMAX; i++) { const h = halves[i]; if (!h.on) continue; h.life -= pd; h.vy += GR * pd; h.x += h.vx * pd; h.y += h.vy * pd; h.rot += h.spin * pd; if (h.life <= 0 || h.y > H + 70) h.on = false; }
        for (let i = 0; i < SMAX; i++) { const s = splats[i]; if (s.on) { s.life -= dt; if (s.life <= 0) s.on = false; } }
        checkBlade(tn);
        /* a cauda da lâmina esvai passados 200 ms */
        let drop = 0; while (drop < bladeN && tn - bt[drop] > 200) drop++;
        if (drop) { bx.copyWithin(0, drop); by.copyWithin(0, drop); bt.copyWithin(0, drop); bladeN -= drop; }
        if (bladeId === null && bladeN && tn - bt[bladeN - 1] > 200) bladeN = 0;
        checked = bladeN;
        if (combo && tn - lastCut > 260) flushCombo();
        for (let i = 0; i < OMAX; i++) { const o = orbs[i]; if (!o.on) continue; o.vy += GR * pd; o.x += o.vx * pd; o.y += o.vy * pd; o.rot += o.spin * pd;
          if (o.k === KB) { o.fuse += dt; if (o.fuse > .05) { o.fuse = 0; const fa = o.rot, fx2 = o.x + Math.cos(fa) * 14 - Math.sin(fa) * (-BOMB_R - 8), fy = o.y + Math.sin(fa) * 14 + Math.cos(fa) * (-BOMB_R - 8); X.fx.cone(fx2, fy, Math.random() < .5 ? '#FFD60A' : '#FF9F0A', 2, -Math.PI / 2, 1.2, 120, .35, 1.8, 300, 1); } } }
        if (X.dying) { for (let i = 0; i < OMAX; i++) if (orbs[i].on && orbs[i].y > H + 80) orbs[i].on = false; draw(); return; }
        /* durante a contagem 3-2-1 o relógio e as vagas ainda não andam */
        if (!go) { draw(); return; }
        T += dt;
        if (timed()) { timeLeft -= dt; hudTime(); if (timeLeft <= 0) { timeLeft = 0; finish('Tempo esgotado', true); draw(); return; } }
        wave -= dt;
        if (wave <= 0) {
          let n;
          if (frenzy > 0) { n = 2 + ((Math.random() * 2) | 0); wave = .32; }
          else { n = 1 + Math.floor(Math.random() * Math.min(4, 1.6 + T / 14)); wave = Math.max(.85, 1.7 - T / 50) + n * .12; }
          for (let i = 0; i < n && i < 6; i++) { const q = queue[i]; if (!q.on) { q.on = true; q.at = i * .14; q.k = pickKind(); } }
        }
        for (let i = 0; i < 6; i++) { const q = queue[i]; if (!q.on) continue; q.at -= dt; if (q.at <= 0) { q.on = false; throwOne(q.k); } }
        for (let i = 0; i < OMAX; i++) {
          const o = orbs[i]; if (!o.on || o.vy <= 0 || o.y < H + o.r + 24) continue;
          o.on = false;
          if (o.k < 8) { if (!timed()) { X.fx.text(clamp(o.x, 30, W - 30), H - 40, 'X', '#FF453A', 28, .8); loseLife('Deixaste cair três frutos'); if (X.dying) break; } else if (streak) { streak = 0; if (mult > 1) { mult = 1; hud(); } } }
        }
        draw();
      }
      function draw() {
        c.drawImage(BG, 0, 0);
        for (let i = 0; i < SMAX; i++) { const s = splats[i]; if (!s.on) continue; const k = s.life / s.max, cs = Math.cos(s.rot) * s.sc, sn = Math.sin(s.rot) * s.sc; c.globalAlpha = Math.min(1, k * 1.6); c.setTransform(cs, sn, -sn, cs, s.x, s.y); c.drawImage(SPLAT[s.sp], -64, -64); }
        c.setTransform(1, 0, 0, 1, 0, 0); c.globalAlpha = 1;
        if (ice > 0) { c.globalAlpha = Math.min(1, ice * 2); c.drawImage(ICEBG, 0, 0); c.globalAlpha = 1; }
        for (let i = 0; i < HMAX; i++) { const h = halves[i]; if (!h.on) continue; const cs = Math.cos(h.rot), sn = Math.sin(h.rot); c.globalAlpha = Math.min(1, h.life * 2.2); c.setTransform(cs, sn, -sn, cs, h.x, h.y); c.drawImage(h.cv, -HS, -HS); }
        c.setTransform(1, 0, 0, 1, 0, 0); c.globalAlpha = 1;
        for (let i = 0; i < OMAX; i++) { const o = orbs[i]; if (!o.on) continue; const cs = Math.cos(o.rot), sn = Math.sin(o.rot); c.setTransform(cs, sn, -sn, cs, o.x, o.y); c.drawImage(WHOLE[o.k], -HS, -HS - (o.k === KB ? 4 : 0)); }
        c.setTransform(1, 0, 0, 1, 0, 0);
        X.fx.draw(c);
        /* lâmina: fita afunilada (fina na cauda, larga no dedo) em três camadas (halo cor de marca, corpo rosado, fio branco),
           desenhada por segmentos com a opacidade a subir da cauda para a ponta: o gradiente sem criar gradientes por frame */
        if (bladeN > 1) {
          for (let i = 0; i < bladeN; i++) { const j = i < bladeN - 1 ? i + 1 : i, k = i > 0 ? i - 1 : i; let dx = bx[j] - bx[k], dy = by[j] - by[k]; const l = hyp(dx, dy) || 1; bn[i] = -dy / l; bl[i] = dx / l; }
          const last = bladeN - 1;
          for (let pass = 0; pass < 3; pass++) {
            const wk = pass === 0 ? 2.3 : pass === 1 ? 1 : .38;
            c.fillStyle = pass === 0 ? '#FF375F' : pass === 1 ? '#FFE3EB' : '#FFFFFF';
            for (let i = 1; i < bladeN; i++) {
              const k0 = (i - 1) / last, k1 = i / last, w0 = (.4 + 4.6 * k0) * wk, w1 = (.4 + 4.6 * k1) * wk;
              c.globalAlpha = (pass === 0 ? .3 : pass === 1 ? .95 : 1) * (.12 + .88 * k1);
              c.beginPath(); c.moveTo(bx[i - 1] + bn[i - 1] * w0, by[i - 1] + bl[i - 1] * w0); c.lineTo(bx[i] + bn[i] * w1, by[i] + bl[i] * w1);
              c.lineTo(bx[i] - bn[i] * w1, by[i] - bl[i] * w1); c.lineTo(bx[i - 1] - bn[i - 1] * w0, by[i - 1] - bl[i - 1] * w0); c.closePath(); c.fill();
            }
          }
          c.globalAlpha = 1;
          /* brilho na ponta da lâmina (sprite pré-desenhado) */
          const tx2 = bx[bladeN - 1], ty2 = by[bladeN - 1]; c.drawImage(TIP, tx2 - 16, ty2 - 16);
        }
        X.drawCount(c); X.drawWhite(c);
      }
      pointer(X, {
        down: p => { if (!X.alive() || bladeId !== null) return; bladeId = p.id; bladeN = 0; bladeAdd(p.x, p.y, clk * 1000); checked = 1; },
        move: p => { if (p.id !== bladeId) return; const l = bladeN - 1; if (l < 0 || hyp(p.x - bx[l], p.y - by[l]) > 2) bladeAdd(p.x, p.y, clk * 1000); },
        up: p => { if (p.id === bladeId) bladeId = null; },
      });
      X.A.options([{ key: 'mode', label: 'Modo', values: SL_MODES, cur: modeKey, onChange: v => { if (!SL_MODES.some(m => m.v === v)) return; modeKey = v; Arcade.setOpt('slice:mode', v); X.A.setId(boardId()); if (X.running || X.dead) start(); else { reset(); X.A.setId(boardId()); draw(); } } }]);
      start();
      X.api.dbg = () => ({ score, lives, mult, combo, maxCombo, timeLeft, mode: modeKey, orbs: orbs.filter(o => o.on).map(o => ({ x: o.x, y: o.y, k: o.k, vy: o.vy })), halves: halves.filter(h => h.on).length, splats: splats.filter(s => s.on).length, blade: bladeN });
      X.api.timeUp = () => { if (timed() && X.alive()) timeLeft = .01; };
      X.api.throwNow = k => { throwOne(k == null ? 0 : k); };
      return X.api;
    },
  });

  /* =====================================================================
     TORRE (stack): blocos isométricos, largar em cima do anterior; o que sobra cai
     ===================================================================== */
  Icons.app.stack = () => Icons.SVG(Icons.G('gSt', '#2A1E6E', '#1B1250', '#0E0A30') + Icons.GL(
    `<path d="M50 84L22 70V54l28 14z" fill="#3A2C9E"/><path d="M50 84l28-14V54L50 68z" fill="#241A6B"/><path d="M22 54l28-14 28 14-28 14z" fill="#6C5CE7"/>` +
    `<path d="M50 66L26 54V42l24 12z" fill="#2E8BC0"/><path d="M50 66l24-12V42L50 54z" fill="#1C5F85"/><path d="M26 42l24-12 24 12-24 12z" fill="#5CC8FF"/>` +
    `<path d="M50 48L30 38V28l20 10z" fill="#1E9E6A"/><path d="M50 48l20-10V28L50 38z" fill="#136B47"/><path d="M30 28l20-10 20 10-20 10z" fill="#4ADE9E"/>` +
    `<path d="M50 30L36 23v-6l14 7z" fill="#C7A300"/><path d="M50 30l14-7v-6l-14 7z" fill="#8F7500"/><path d="M36 17l14-7 14 7-14 7z" fill="#FFE27A"/>` +
    `<path d="M36 17l14-7 14 7-14 7z" fill="#fff" opacity=".35"/>`));

  const ST_COVER = () => COVER(
    `<rect width="400" height="200" fill="url(#stBg)"/>` +
    `<circle cx="60" cy="40" r="1.5" fill="#fff" opacity=".6"/><circle cx="330" cy="28" r="1.2" fill="#fff" opacity=".5"/><circle cx="250" cy="60" r="1" fill="#fff" opacity=".4"/><circle cx="110" cy="90" r="1.3" fill="#fff" opacity=".35"/><circle cx="370" cy="110" r="1" fill="#fff" opacity=".4"/>` +
    `<g transform="translate(200 0)">` +
    `<path d="M0 200L-104 148V110L0 162z" fill="#2A1E6E"/><path d="M0 200l104-52V110L0 162z" fill="#1A1248"/><path d="M-104 110L0 58l104 52L0 162z" fill="#4A3AB8"/>` +
    `<path d="M0 162L-88 118v-22L0 140z" fill="#2E8BC0"/><path d="M0 162l88-44V96L0 140z" fill="#1C5F85"/><path d="M-88 96L0 52l88 44L0 140z" fill="#5CC8FF"/>` +
    `<path d="M0 140L-70 105V83L0 118z" fill="#1E9E6A"/><path d="M0 140l70-35V83L0 118z" fill="#136B47"/><path d="M-70 83L0 48l70 35L0 118z" fill="#4ADE9E"/>` +
    `<path d="M0 118L-56 90V70L0 98z" fill="#C7A300"/><path d="M0 118l56-28V70L0 98z" fill="#8F7500"/><path d="M-56 70L0 42l56 28L0 98z" fill="#FFE27A"/>` +
    `<path d="M20 96L-36 68V48l56 28z" fill="#D14B2E" opacity=".95"/><path d="M20 96l56-28V48L20 76z" fill="#8E2E1A" opacity=".95"/><path d="M-36 48L20 20l56 28-56 28z" fill="#FF8A65"/>` +
    `<path d="M-56 70L0 42l56 28L0 98z" fill="none" stroke="#fff" stroke-opacity=".7" stroke-width="2"/>` +
    `</g>` +
    `<text x="62" y="118" font-family="Inter, sans-serif" font-size="44" font-weight="800" fill="#fff" fill-opacity=".92" text-anchor="middle">42</text><path d="M330 46l3 7 7 1-5 5 1 7-6-3-6 3 1-7-5-5 7-1z" fill="#FFE27A" opacity=".9"/>`,
    `<defs><linearGradient id="stBg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0B0C2A"/><stop offset="1" stop-color="#2B1B5E"/></linearGradient></defs>`);

  /* lógica pura do corte (também usada pelo teste): dado o bloco de cima e o que anda, no eixo do movimento,
     devolve o que fica e o que cai (x = posição no eixo, w = tamanho nesse eixo) */
  const stackCut = (top, cur, tol) => {
    const dx = cur.x - top.x, over = Math.abs(dx);
    if (over <= tol) return { perfect: true, x: top.x, w: cur.w, fall: null };
    if (over >= top.w) return { perfect: false, x: cur.x, w: 0, fall: { x: cur.x, w: cur.w } };
    return { perfect: false, x: Math.max(cur.x, top.x), w: top.w - over, fall: { x: dx > 0 ? top.x + top.w : cur.x, w: over } };
  };
  const ST_MODES = [{ v: 'classico', label: 'Clássico' }, { v: 'rapido', label: 'Rápido\u200b' }];
  Arcade.game('stack', {
    name: 'Torre', color: '#6C5CE7', kind: 'action',
    /* tabelas: Clássico continua em 'stack'; Rápido é nova ('stack:rapido') */
    variants: ST_MODES.map(m => ({ key: m.v, label: m.label, board: m.v === 'classico' ? 'stack' : 'stack:' + m.v })),
    desc: 'Torre isométrica: o bloco desliza ora num eixo ora no outro e tu largas no momento certo. O que sobra cai a rodar, os encaixes perfeitos abrem um anel e, em série, devolvem largura ao bloco. O céu muda com a altura. Modos Clássico e Rápido.',
    tags: ['Isométrico', 'Precisão', 'Zen'],
    modes: ST_MODES.map(m => ({ key: m.v, label: m.label })),
    cover: ST_COVER,
    howto: { goal: 'Empilha o máximo de blocos: a pontuação é a altura da torre.',
      steps: ['Toca quando o bloco estiver alinhado com o de baixo; o que sobra cai', 'Um encaixe perfeito abre um anel; três seguidos fazem o bloco voltar a crescer', 'Quanto mais alta a torre, mais depressa o bloco anda'],
      controls: [{ icon: 'hand', label: 'Toca no palco ou em Largar' }, { icon: 'gamepad', label: 'Espaço, Enter ou seta para baixo' }] },
    build(win) {
      const W = 400, H = 600, BH = 22, BASE = 130, TOL = 7, KX = .866, KY = .5, CX = W / 2, BMAX = 60, PMAX = 10, RMAX = 6, TALL = 1800, SLIDE = 116, BY0 = H * .78;
      let modeKey = Arcade.opt('stack:mode', 'classico'); if (!ST_MODES.some(m => m.v === modeKey)) modeKey = 'classico';
      const boardId = () => (modeKey === 'classico' ? 'stack' : 'stack:' + modeKey);
      let blocks, nb, cur, dir, speed, camY, camT, combo, maxCombo, perfects, score, hue0, armed, zoom, zoomT, flashT;
      const X = host(win, { id: boardId(), name: 'Torre', color: '#6C5CE7', W, H, restart: () => start(), tick, draw, key });
      const c = X.ctx;
      /* ---- arte pré-desenhada: céu alto que muda com a altura (janela deslizante), vinheta, chão ---- */
      const SKY = spr(W, TALL, (b, w, h) => {
        b.fillStyle = lgrad(b, 0, 0, 0, h, [[0, '#02030C'], [.18, '#120A3A'], [.38, '#3A1A6E'], [.55, '#1E3A7A'], [.72, '#174A5C'], [.86, '#2A1B4E'], [1, '#0E0B24']]); b.fillRect(0, 0, w, h);
        let seed = 3; const rs = () => { seed = (seed * 9301 + 49297) % 233280; return seed / 233280; };
        for (let i = 0; i < 260; i++) { const x = rs() * w, y = rs() * h * .9, r = .5 + rs() * 1.3; b.fillStyle = `rgba(255,255,255,${(.25 + rs() * .6).toFixed(2)})`; b.beginPath(); b.arc(x, y, r, 0, TAU); b.fill(); }
        b.fillStyle = rgrad(b, w * .5, h * .95, 20, w * .5, h * .95, 420, [[0, 'rgba(120,90,255,.35)'], [1, 'rgba(0,0,0,0)']]); b.fillRect(0, h - 500, w, 500);
      });
      const VIG = spr(W, H, (b, w, h) => { b.fillStyle = rgrad(b, w / 2, h / 2, 120, w / 2, h / 2, h * .78, [[0, 'rgba(0,0,0,0)'], [1, 'rgba(0,0,0,.5)']]); b.fillRect(0, 0, w, h); });
      const blocks0 = new Array(BMAX); for (let i = 0; i < BMAX; i++) blocks0[i] = { x: 0, z: 0, w: 0, d: 0, i: 0, cT: '', cL: '', cR: '' };
      blocks = blocks0;
      const pieces = new Array(PMAX); for (let i = 0; i < PMAX; i++) pieces[i] = { on: false, x: 0, z: 0, w: 0, d: 0, i: 0, vy: 0, dy: 0, rot: 0, vr: 0, life: 0, cT: '', cL: '', cR: '' };
      const rings = new Array(RMAX); for (let i = 0; i < RMAX; i++) rings[i] = { on: false, x: 0, z: 0, w: 0, d: 0, i: 0, t: 0 };
      const baseC = ['', '', ''];
      const col = (i, o) => { const h = hue0 + i * 5.5; o.cT = hsl(h, 64, 68); o.cL = hsl(h, 60, 50); o.cR = hsl(h, 64, 36); };
      /* projeção isométrica (2:1): x cresce para a direita-baixo, z para a esquerda-baixo, os níveis sobem */
      const px = (x, z) => CX + (x - z) * KX;
      const py = (x, z, lvl) => camY + (x + z) * KY - lvl * BH;
      const topOf = () => blocks[nb - 1];
      const box = (x, z, w, d, lvl, hgt, cT, cL, cR) => {
        const ax = px(x, z), ay = py(x, z, lvl), bx2 = px(x + w, z), by2 = py(x + w, z, lvl), cx2 = px(x + w, z + d), cy2 = py(x + w, z + d, lvl), dx2 = px(x, z + d), dy2 = py(x, z + d, lvl), hh = hgt * BH;
        c.fillStyle = cR; c.beginPath(); c.moveTo(bx2, by2); c.lineTo(cx2, cy2); c.lineTo(cx2, cy2 + hh); c.lineTo(bx2, by2 + hh); c.closePath(); c.fill();
        c.fillStyle = cL; c.beginPath(); c.moveTo(cx2, cy2); c.lineTo(dx2, dy2); c.lineTo(dx2, dy2 + hh); c.lineTo(cx2, cy2 + hh); c.closePath(); c.fill();
        c.fillStyle = cT; c.beginPath(); c.moveTo(ax, ay); c.lineTo(bx2, by2); c.lineTo(cx2, cy2); c.lineTo(dx2, dy2); c.closePath(); c.fill();
        /* arestas: luz nas arestas de cima e na esquina da frente (a luz vem de cima) */
        c.strokeStyle = 'rgba(255,255,255,.42)'; c.lineWidth = 1; c.beginPath(); c.moveTo(dx2, dy2); c.lineTo(cx2, cy2); c.lineTo(bx2, by2); c.stroke();
        c.strokeStyle = 'rgba(255,255,255,.16)'; c.beginPath(); c.moveTo(cx2, cy2); c.lineTo(cx2, cy2 + hh); c.stroke();
      };
      const hudStack = () => { const b = X.A.el.mid.querySelector('.pf'); if (b) { b.textContent = String(combo); return; } X.A.setMid(hint(`${g('starFill', 16)}<em>Perfeitos</em><b class="pf">${combo}</b>`)); };
      const reset = () => {
        hue0 = rnd(0, 360); baseC[0] = hsl(hue0, 30, 34); baseC[1] = hsl(hue0, 32, 22); baseC[2] = hsl(hue0, 36, 14); nb = 1; const b0 = blocks[0]; b0.x = -BASE / 2; b0.z = -BASE / 2; b0.w = BASE; b0.d = BASE; b0.i = 0; col(0, b0);
        score = 0; combo = 0; maxCombo = 0; perfects = 0; camY = H * .78; camT = camY; dir = 1; armed = false; zoom = 1; zoomT = 1; flashT = 0;
        speed = modeKey === 'rapido' ? 270 : 190;
        cur = { x: -BASE / 2 - SLIDE - BASE, z: -BASE / 2, w: BASE, d: BASE, i: 1, axis: 0, cT: '', cL: '', cR: '' }; col(1, cur);
        for (let i = 0; i < PMAX; i++) pieces[i].on = false; for (let i = 0; i < RMAX; i++) rings[i].on = false;
        X.A.setScore(0); X.A.setMid(hint('Toca para largar o bloco'));
      };
      const start = () => { reset(); X.A.setId(boardId()); X.begin('Torre', modeKey === 'rapido' ? 'Modo rápido: o bloco anda mais e acelera mais' : 'Toca para largar o bloco na altura certa').then(() => { if (!X.running) return; const tok = X.seq; X.countdown(3).then(() => { if (tok === X.seq && X.running) armed = true; }); }); };
      const stats = () => [{ label: 'Altura', value: String(score) }, { label: 'Perfeitos', value: String(perfects) }, { label: 'Maior sequência', value: String(maxCombo) }];
      const nextBlock = () => {
        /* o bloco seguinte entra sempre por TRÁS (canto de cima-esquerda ou cima-direita, alternando o eixo) e vai e volta */
        const top = topOf(); dir = 1; const axis = cur.axis ? 0 : 1;
        cur.i = top.i + 1; cur.w = top.w; cur.d = top.d; cur.axis = axis; col(cur.i, cur);
        if (axis === 0) { cur.z = top.z; cur.x = top.x - SLIDE - top.w; } else { cur.x = top.x; cur.z = top.z - SLIDE - top.d; }
        speed = modeKey === 'rapido' ? Math.min(560, 270 + score * 4.5) : Math.min(420, 190 + score * 3);
      };
      const drop = () => {
        if (!X.alive() || !armed) return;
        const top = topOf(), ax = cur.axis;
        const r = ax === 0 ? stackCut({ x: top.x, w: top.w }, { x: cur.x, w: cur.w }, TOL) : stackCut({ x: top.z, w: top.d }, { x: cur.z, w: cur.d }, TOL);
        const scx = px(cur.x + cur.w / 2, cur.z + cur.d / 2), scy = py(cur.x + cur.w / 2, cur.z + cur.d / 2, cur.i);
        if (r.perfect) {
          if (ax === 0) cur.x = r.x; else cur.z = r.x;
          combo++; perfects++; if (combo > maxCombo) { maxCombo = combo; X.maxStat('stackPerfect', combo); } X.snd('chime', 0); X.haptic('light'); flashT = .18; hudStack();
          /* anel de "perfeito": o primeiro livre do pool, ou o mais antigo */
          let rr2 = null; for (let i = 0; i < RMAX; i++) if (!rings[i].on) { rr2 = rings[i]; break; }
          if (!rr2) { rr2 = rings[0]; for (let i = 1; i < RMAX; i++) if (rings[i].t > rr2.t) rr2 = rings[i]; }
          rr2.on = true; rr2.x = cur.x; rr2.z = cur.z; rr2.w = cur.w; rr2.d = cur.d; rr2.i = cur.i + 1; rr2.t = 0;
          X.fx.burst(scx, scy - BH, '#fff', 10, 130, .5, 3);
          if (combo >= 2) { X.flash(`Perfeito x${combo}`, 'bonus'); if (combo >= 3 && (cur.w < BASE || cur.d < BASE)) { if (ax === 0) { cur.w = Math.min(BASE, cur.w + 12); cur.x = top.x + (top.w - cur.w) / 2; } else { cur.d = Math.min(BASE, cur.d + 12); cur.z = top.z + (top.d - cur.d) / 2; } X.snd('powerup', 0); } }
          if (combo === 5) X.celebrate('level');
        } else {
          combo = 0; hudStack();
          let p = null; for (let i = 0; i < PMAX; i++) if (!pieces[i].on) { p = pieces[i]; break; } if (!p) p = pieces[0];
          p.on = true; p.i = cur.i; p.vy = 0; p.dy = 0; p.rot = 0; p.life = 1.5; p.cT = cur.cT; p.cL = cur.cL; p.cR = cur.cR;
          if (ax === 0) { p.x = r.fall.x; p.w = r.fall.w; p.z = cur.z; p.d = cur.d; p.vr = (cur.x > top.x ? 1 : -1) * 2.2; } else { p.z = r.fall.x; p.d = r.fall.w; p.x = cur.x; p.w = cur.w; p.vr = (cur.z > top.z ? -1 : 1) * 2.2; }
          if (r.w <= 0) { X.snd('crash', 0); X.haptic('heavy'); X.shake.hit(8); X.maxStat('stackPerfect', maxCombo); X.die({ title: 'A torre caiu', sub: `${score} blocos de altura`, score, win: false, board: boardId(), stats: stats() }, 1.6); return; }
          if (ax === 0) { cur.x = r.x; cur.w = r.w; } else { cur.z = r.x; cur.d = r.w; }
          X.snd('place', 0); X.shake.hit(1.5);
          X.fx.burst(px(p.x + p.w / 2, p.z + p.d / 2), py(p.x + p.w / 2, p.z + p.d / 2, p.i) - 4, cur.cL, 6, 90, .4, 2.5, 500);
        }
        if (nb >= BMAX) { for (let i = 1; i < nb; i++) { const a = blocks[i - 1], b2 = blocks[i]; a.x = b2.x; a.z = b2.z; a.w = b2.w; a.d = b2.d; a.i = b2.i; a.cT = b2.cT; a.cL = b2.cL; a.cR = b2.cR; } nb--; }
        const nbk = blocks[nb++]; nbk.x = cur.x; nbk.z = cur.z; nbk.w = cur.w; nbk.d = cur.d; nbk.i = cur.i; nbk.cT = cur.cT; nbk.cL = cur.cL; nbk.cR = cur.cR;
        score = cur.i; X.A.setScore(score);
        if (score % 25 === 0) { X.flash(`${score} blocos`, 'big'); X.snd('level', 0); X.celebrate('level'); }
        nextBlock();
      };
      function tick(dt) {
        X.fx.step(dt);
        if (flashT > 0) flashT -= dt;
        for (let i = 0; i < PMAX; i++) { const p = pieces[i]; if (!p.on) continue; p.vy += 1500 * dt; p.dy += p.vy * dt; p.rot += p.vr * dt; p.life -= dt; if (p.life <= 0) p.on = false; }
        for (let i = 0; i < RMAX; i++) { const r = rings[i]; if (r.on) { r.t += dt * 1.6; if (r.t >= 1) r.on = false; } }
        const top = topOf();
        /* a câmara sobe com a torre (o topo fica a ~45 % da altura); na queda volta à base e afasta-se para mostrar a torre inteira */
        camT = X.dying || X.dead ? BY0 : BY0 + Math.max(0, (top.i + 1) * BH - H * .34);
        camY += (camT - camY) * (1 - Math.exp(-6 * dt));
        if (X.dying) { zoomT = Math.min(1, (BY0 - 110) / Math.max(1, (top.i + 1) * BH + 30)); zoom += (zoomT - zoom) * (1 - Math.exp(-4 * dt)); }
        if (X.alive() && armed) {
          if (cur.axis === 0) { cur.x += dir * speed * dt; const lo = top.x - SLIDE - cur.w, hi = top.x + top.w + SLIDE; if (dir > 0 && cur.x > hi) dir = -1; else if (dir < 0 && cur.x < lo) dir = 1; }
          else { cur.z += dir * speed * dt; const lo = top.z - SLIDE - cur.d, hi = top.z + top.d + SLIDE; if (dir > 0 && cur.z > hi) dir = -1; else if (dir < 0 && cur.z < lo) dir = 1; }
        }
        draw();
      }
      function draw() {
        const top = topOf(), off = Math.max(0, Math.min(TALL - H, TALL - H - top.i * 9));
        c.drawImage(SKY, 0, off, W, H, 0, 0, W, H);
        if (zoom < .999) c.setTransform(zoom, 0, 0, zoom, CX - CX * zoom, BY0 - BY0 * zoom);
        /* base alta e escura por baixo da torre */
        const b0 = blocks[0]; box(b0.x, b0.z, b0.w, b0.d, 0, 9, baseC[0], baseC[1], baseC[2]);
        for (let i = 0; i < nb; i++) { const b = blocks[i]; const y = py(b.x, b.z, b.i); if (y > H + 200 || y < -200) continue; box(b.x, b.z, b.w, b.d, b.i, 1, b.cT, b.cL, b.cR); }
        if (flashT > 0) { c.globalAlpha = Math.min(1, flashT * 6); box(top.x, top.z, top.w, top.d, top.i, 1, '#fff', 'rgba(255,255,255,.7)', 'rgba(255,255,255,.5)'); c.globalAlpha = 1; }
        for (let i = 0; i < PMAX; i++) {
          const p = pieces[i]; if (!p.on) continue;
          /* o pedaço roda à volta do próprio centro e cai p.dy: matriz = zoom · translação(centro + queda) · rotação · translação(-centro) */
          const cx0 = px(p.x + p.w / 2, p.z + p.d / 2), cy0 = py(p.x + p.w / 2, p.z + p.d / 2, p.i) + BH / 2, cs = Math.cos(p.rot), sn = Math.sin(p.rot), by0 = BY0;
          c.globalAlpha = Math.min(1, p.life * 1.5);
          c.setTransform(cs * zoom, sn * zoom, -sn * zoom, cs * zoom, zoom * (cx0 - cs * cx0 + sn * cy0) + CX - CX * zoom, zoom * (cy0 + p.dy - sn * cx0 - cs * cy0) + by0 - by0 * zoom);
          box(p.x, p.z, p.w, p.d, p.i, 1, p.cT, p.cL, p.cR);
        }
        c.setTransform(1, 0, 0, 1, 0, 0); c.globalAlpha = 1;
        if (zoom < .999) c.setTransform(zoom, 0, 0, zoom, CX - CX * zoom, BY0 - BY0 * zoom);
        for (let i = 0; i < RMAX; i++) {
          const r = rings[i]; if (!r.on) continue; const e = 14 + 44 * r.t;
          c.globalAlpha = 1 - r.t; c.strokeStyle = '#fff'; c.lineWidth = 3 * (1 - r.t) + 1;
          c.beginPath(); c.moveTo(px(r.x - e, r.z - e), py(r.x - e, r.z - e, r.i)); c.lineTo(px(r.x + r.w + e, r.z - e), py(r.x + r.w + e, r.z - e, r.i)); c.lineTo(px(r.x + r.w + e, r.z + r.d + e), py(r.x + r.w + e, r.z + r.d + e, r.i)); c.lineTo(px(r.x - e, r.z + r.d + e), py(r.x - e, r.z + r.d + e, r.i)); c.closePath(); c.stroke();
        }
        c.globalAlpha = 1;
        if (!X.dead && !X.dying) { box(cur.x, cur.z, cur.w, cur.d, cur.i, 1, cur.cT, cur.cL, cur.cR); }
        c.setTransform(1, 0, 0, 1, 0, 0);
        c.drawImage(VIG, 0, 0);
        X.fx.draw(c);
        c.lineWidth = 5; c.strokeStyle = 'rgba(0,0,0,.35)'; c.font = `800 54px ${FONT}`; c.textAlign = 'center'; c.textBaseline = 'middle'; c.strokeText(String(score), W / 2, 54);
        txt(c, String(score), W / 2, 54, 54, 'rgba(255,255,255,.95)', 800);
        X.drawCount(c); X.drawWhite(c);
      }
      function key(e) { if (e.type === 'keyup' || e.repeat) return; const m = ARROWS[e.key]; if (m === 'space' || m === 'down') { e.preventDefault(); drop(); } }
      pointer(X, { down: () => drop() });
      X.A.el.ctl.innerHTML = `<div class="gm-row"><div class="gb lbl gst-drop">${g('arrowDown')}<span>Largar\u200b</span></div></div>`;
      X.A.el.ctl.querySelector('.gst-drop').addEventListener('pointerdown', e => { e.preventDefault(); drop(); });
      X.A.options([{ key: 'mode', label: 'Modo', values: ST_MODES, cur: modeKey, onChange: v => { if (!ST_MODES.some(m => m.v === v)) return; modeKey = v; Arcade.setOpt('stack:mode', v); X.A.setId(boardId()); if (X.running || X.dead) start(); else { reset(); X.A.setId(boardId()); draw(); } } }]);
      start();
      X.api.dbg = () => ({ score, combo, armed, cur: { x: cur.x, z: cur.z, w: cur.w, d: cur.d, axis: cur.axis }, top: Object.assign({}, topOf()), speed, mode: modeKey });
      X.api.armNow = () => { armed = true; };
      return X.api;
    },
  });

  /* lógica pura exposta para o teste em Node (harness/test_action2.mjs); nada no telemóvel usa isto */
  Arcade.action2 = { stackCut, puckHit, segDist, Fx, Trail, duelScore };
})();
