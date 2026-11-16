/* ===================== JOGOS CLÁSSICOS, apex_phone 1.5.0 (ronda 2) =====================
   Snake, 2048, Blocos (Tetris), Minas, Break (Breakout) e Memória sobre a casca comum do games.js
   (Arcade.shell + extensões 1.5.0: A.ready, A.options, A.flash, A.haptic, A.sfx, A.end; as da ronda 2,
   A.countdown, A.celebrate, A.toast, são chamadas de forma defensiva). Carrega DEPOIS de games.js.
   Este ficheiro é AUTÓNOMO: traz as suas próprias funções de pré-renderização (sprites desenhados UMA
   vez em canvas fora do ecrã), partículas (pool fixo, sem alocações por frame), abanão e cronómetro.
   Nada de backdrop-filter, filter, clip-path, aspect-ratio, color-mix, gradientes por frame, DPR.
   Estilos próprios em css/app-games-classic.css (.sn-, .tw-, .bl-, .mn-, .bk-, .me-).
   ============================================================================================ */
(() => {
if (!window.Arcade || !Arcade.shell) return;
const g = UI.g;
const T = s => (window.L && L.t ? L.t(s) : s);
const TAU = 6.283185307;

/* ---------- canvas: pré-renderização e cores ---------- */
const mk = (w, h) => { const c = document.createElement('canvas'); c.width = Math.max(1, Math.round(w)); c.height = Math.max(1, Math.round(h)); return c; };
const pre = (w, h, fn) => { const c = mk(w, h); fn(c.getContext('2d'), c.width, c.height); return c; };
const rrp = (c, x, y, w, h, r) => { r = Math.min(r, w / 2, h / 2); c.beginPath(); c.moveTo(x + r, y); c.arcTo(x + w, y, x + w, y + h, r); c.arcTo(x + w, y + h, x, y + h, r); c.arcTo(x, y + h, x, y, r); c.arcTo(x, y, x + w, y, r); c.closePath(); };
const hex = h => { h = String(h).replace('#', ''); if (h.length === 3) h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2]; const n = parseInt(h, 16) || 0; return [n >> 16 & 255, n >> 8 & 255, n & 255]; };
const rgba = (h, a) => { const c = hex(h); return 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',' + a + ')'; };
const shade = (h, k) => { const c = hex(h).map(v => Math.round(k < 0 ? v * (1 + k) : v + (255 - v) * k)); return 'rgb(' + c[0] + ',' + c[1] + ',' + c[2] + ')'; };
const mix = (a, b, t) => { const x = hex(a), y = hex(b); return 'rgb(' + Math.round(x[0] + (y[0] - x[0]) * t) + ',' + Math.round(x[1] + (y[1] - x[1]) * t) + ',' + Math.round(x[2] + (y[2] - x[2]) * t) + ')'; };
const pad2 = n => (n < 10 ? '0' : '') + n;
const mmss = s => { s = Math.max(0, Math.round(s)); return ((s / 60) | 0) + ':' + pad2(s % 60); };
const ease = t => (t < 0 ? 0 : t > 1 ? 1 : 1 - (1 - t) * (1 - t) * (1 - t));

/* halo luminoso (círculo com brilho), em cache por cor e raio: só se cria na primeira utilização */
const glowCache = new Map();
const glow = (color, r) => {
  const k = color + '|' + r; let c = glowCache.get(k); if (c) return c;
  const s = r * 4;
  c = pre(s, s, x => { const gr = x.createRadialGradient(s / 2, s / 2, 0, s / 2, s / 2, s / 2); gr.addColorStop(0, '#fff'); gr.addColorStop(.22, color); gr.addColorStop(.5, rgba(color, .4)); gr.addColorStop(1, rgba(color, 0)); x.fillStyle = gr; x.fillRect(0, 0, s, s); });
  glowCache.set(k, c); return c;
};
/* esfera com volume (luz de cima-esquerda), em cache */
const ballCache = new Map();
const ball = (color, r) => {
  const k = color + '|' + r; let c = ballCache.get(k); if (c) return c;
  const s = r * 2 + 2;
  c = pre(s, s, x => { const gr = x.createRadialGradient(s / 2 - r * .35, s / 2 - r * .4, r * .1, s / 2, s / 2, r); gr.addColorStop(0, '#fff'); gr.addColorStop(.3, shade(color, .35)); gr.addColorStop(.8, color); gr.addColorStop(1, shade(color, -.45)); x.fillStyle = gr; x.beginPath(); x.arc(s / 2, s / 2, r, 0, TAU); x.fill(); });
  ballCache.set(k, c); return c;
};

/* ---------- partículas: pool fixo em arrays tipados (zero alocações por frame) ----------
   const fx = Fx(220); fx.burst(x, y, cor | [cores], n, velocidade, { glow, size, life, grav, dir, spread, lift }); fx.step(dt); fx.draw(ctx) */
function Fx(max) {
  const N = max || 220;
  const X = new Float32Array(N), Y = new Float32Array(N), VX = new Float32Array(N), VY = new Float32Array(N), LF = new Float32Array(N), TT = new Float32Array(N), R = new Float32Array(N), GR = new Float32Array(N), DR = new Float32Array(N);
  const S = new Array(N), K = new Uint8Array(N);
  let n = 0;
  const drop = i => { n--; if (i !== n) { X[i] = X[n]; Y[i] = Y[n]; VX[i] = VX[n]; VY[i] = VY[n]; LF[i] = LF[n]; TT[i] = TT[n]; R[i] = R[n]; GR[i] = GR[n]; DR[i] = DR[n]; S[i] = S[n]; K[i] = K[n]; } };
  return {
    get count() { return n; },
    clear() { n = 0; },
    burst(x, y, colors, count, speed, o) {
      o = o || {}; const arr = Array.isArray(colors) ? colors : null;
      for (let i = 0; i < count; i++) {
        if (n >= N) drop(0);
        const j = n++;
        const a = o.dir != null ? o.dir + (Math.random() - .5) * (o.spread == null ? 1.2 : o.spread) : Math.random() * TAU;
        const s = (speed || 120) * (.35 + Math.random() * .85);
        X[j] = x; Y[j] = y; VX[j] = Math.cos(a) * s; VY[j] = Math.sin(a) * s - (o.lift == null ? 40 : o.lift);
        LF[j] = (o.life || .6) * (.6 + Math.random() * .7); TT[j] = 0; R[j] = (o.size || 3) * (.6 + Math.random() * .9);
        GR[j] = o.grav == null ? 300 : o.grav; DR[j] = o.drag == null ? 0 : o.drag;
        const c = arr ? arr[(Math.random() * arr.length) | 0] : colors;
        K[j] = o.glow ? 1 : 0; S[j] = o.glow ? glow(c, 6) : c;
      }
    },
    step(dt) {
      for (let i = n - 1; i >= 0; i--) {
        TT[i] += dt; if (TT[i] >= LF[i]) { drop(i); continue; }
        VY[i] += GR[i] * dt; if (DR[i]) { const f = 1 - DR[i] * dt; VX[i] *= f; VY[i] *= f; }
        X[i] += VX[i] * dt; Y[i] += VY[i] * dt;
      }
    },
    draw(ctx) {
      for (let i = 0; i < n; i++) {
        const k = 1 - TT[i] / LF[i]; ctx.globalAlpha = k; const r = R[i];
        if (K[i]) ctx.drawImage(S[i], X[i] - r * 2, Y[i] - r * 2, r * 4, r * 4);
        else { ctx.fillStyle = S[i]; ctx.fillRect(X[i] - r, Y[i] - r, r * 2, r * 2); }
      }
      ctx.globalAlpha = 1;
    },
  };
}

/* ---------- abanão do ecrã (transform no elemento, decai sozinho) ---------- */
function Shaker(el) {
  let amp = 0, on = false;
  return {
    kick(k) { if (k > amp) amp = k; },
    step(dt) {
      if (amp <= 0) { if (on) { on = false; el.style.transform = ''; } return; }
      amp -= dt * 30; if (amp <= 0) { amp = 0; on = false; el.style.transform = ''; return; }
      on = true; el.style.transform = 'translate(' + ((Math.random() * 2 - 1) * amp).toFixed(1) + 'px,' + ((Math.random() * 2 - 1) * amp).toFixed(1) + 'px)';
    },
    reset() { amp = 0; on = false; el.style.transform = ''; },
  };
}

/* ---------- chamadas defensivas à casca (o HUB implementa-as em paralelo) ---------- */
const countdown = (A, n) => { try { if (A.countdown) return Promise.resolve(A.countdown(n)); } catch (e) {} return Promise.resolve(); };
const celebrate = (A, k) => { try { A.celebrate && A.celebrate(k); } catch (e) {} };
const toast = (A, m) => { try { if (A.toast) { A.toast(m); return; } } catch (e) {} A.flash(m, 'bonus'); };
/* a nova marca pessoal no momento em que acontece (não só no fim) */
function recordWatch(A, key, low) {
  let best = low ? Arcade.bestLow(key) : Arcade.best(key), fired = false;
  return {
    reset() { best = low ? Arcade.bestLow(key) : Arcade.best(key); fired = false; },
    check(v) { if (fired || !best) return; if (low ? v < best : v > best) { fired = true; A.flash('Novo recorde!', 'big'); A.sfx('chime'); celebrate(A, 'record'); } },
  };
}
/* texto fixo pré-desenhado (fillText por frame só para números) */
const textSprite = (txt, font, color, w, h) => pre(w, h, c => { c.font = font; c.fillStyle = color; c.textAlign = 'center'; c.textBaseline = 'middle'; c.fillText(T(txt), w / 2, h / 2); });
/* ponteiro → coordenadas lógicas da tela (a tela pode estar com zoom: UI.vrect corrige a escala do CEF) */
const canvasPoint = (cv, e, out) => {
  const r = (UI.vrect ? UI.vrect(cv) : cv.getBoundingClientRect());
  const sx = r.width ? cv.width / r.width : 1, sy = r.height ? cv.height / r.height : 1;
  out.x = (e.clientX - r.left) * sx; out.y = (e.clientY - r.top) * sy; return out;
};


/* =====================================================================
   1. SNAKE: tabuleiro 17×15 de relva em xadrez, cobra com corpo contínuo e movimento interpolado
   ===================================================================== */
Icons.app.snake = () => Icons.SVG(Icons.G('gSn', '#4FD96F', '#1FA84A', '#0E6B2E') +
  `<defs><linearGradient id="gSnB" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#E4FFEA"/><stop offset="1" stop-color="#8CF0A6"/></linearGradient>` +
  `<radialGradient id="gSnA" cx=".35" cy=".3" r=".8"><stop offset="0" stop-color="#FF8A80"/><stop offset=".6" stop-color="#FF3B30"/><stop offset="1" stop-color="#B3140C"/></radialGradient></defs>` +
  `<g opacity=".12">${[0, 1, 2, 3, 4].map(r => [0, 1, 2, 3, 4].map(c => ((r + c) % 2 ? `<rect x="${c * 20}" y="${r * 20}" width="20" height="20" fill="#000"/>` : '')).join('')).join('')}</g>` +
  `<path d="M24 74c0-14 12-18 24-18s20-5 20-15-8-15-18-15" fill="none" stroke="#063D1A" stroke-width="20" stroke-linecap="round" stroke-linejoin="round" opacity=".38" transform="translate(2 4)"/>` +
  `<path d="M24 74c0-14 12-18 24-18s20-5 20-15-8-15-18-15" fill="none" stroke="#1F9A46" stroke-width="18" stroke-linecap="round" stroke-linejoin="round"/>` +
  `<path d="M24 74c0-14 12-18 24-18s20-5 20-15-8-15-18-15" fill="none" stroke="url(#gSnB)" stroke-width="8" stroke-linecap="round" stroke-linejoin="round" opacity=".55" transform="translate(-1 -3)"/>` +
  `<circle cx="50" cy="26" r="12" fill="#2FBF5A"/><circle cx="50" cy="26" r="12" fill="url(#gSnB)" opacity=".35"/>` +
  `<circle cx="46" cy="22" r="3.4" fill="#fff"/><circle cx="56" cy="22" r="3.4" fill="#fff"/><circle cx="47" cy="22.6" r="1.7" fill="#0B2A14"/><circle cx="57" cy="22.6" r="1.7" fill="#0B2A14"/>` +
  `<path d="M50 38v6l-3 3M50 44l3 3" stroke="#FF3B30" stroke-width="2.4" fill="none" stroke-linecap="round"/>` +
  `<circle cx="76" cy="70" r="9" fill="url(#gSnA)"/><path d="M76 61c2-4 6-4 8-3-3 0-6 2-8 5z" fill="#34C759"/><circle cx="72.5" cy="66" r="2.2" fill="#fff" opacity=".7"/>`);

Arcade.game('snake', {
  name: 'Snake', color: '#30D158', kind: 'action', tags: ['Clássico', 'Reflexos'],
  modes: [{ key: 'classic', label: 'Clássico' }, { key: 'portal', label: 'Portal' }, { key: 'fast', label: 'Rápido\u200b' }],
  desc: 'O clássico com corpo vivo: come, cresce e não te mordas. Fruto dourado a tempo, níveis que aceleram e três modos: Clássico, Portal e Rápido.',
  cover: () => {
    let sq = '';
    for (let r = 0; r < 10; r++) for (let c = 0; c < 20; c++) if ((r + c) % 2) sq += `<rect x="${c * 20}" y="${r * 20}" width="20" height="20" fill="#000" opacity=".16"/>`;
    const P = 'M40 150c0-40 40-50 90-50s70-20 70-50 20-30 60-20 50 50 60 70';
    return `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="cSn" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#16542B"/><stop offset="1" stop-color="#0B2E18"/></linearGradient><radialGradient id="cSnV" cx=".5" cy=".5" r=".7"><stop offset=".5" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".55"/></radialGradient><linearGradient id="cSnB" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#1C8A40"/><stop offset="1" stop-color="#6FE88F"/></linearGradient><radialGradient id="cSnA" cx=".35" cy=".3" r=".8"><stop offset="0" stop-color="#FF8A80"/><stop offset=".6" stop-color="#FF3B30"/><stop offset="1" stop-color="#9E120B"/></radialGradient></defs>` +
      `<rect width="400" height="200" fill="url(#cSn)"/>${sq}<rect width="400" height="200" fill="url(#cSnV)"/>` +
      `<path d="${P}" fill="none" stroke="#000" stroke-width="30" stroke-linecap="round" stroke-linejoin="round" opacity=".35" transform="translate(4 6)"/>` +
      `<path d="${P}" fill="none" stroke="url(#cSnB)" stroke-width="28" stroke-linecap="round" stroke-linejoin="round"/>` +
      `<path d="${P}" fill="none" stroke="#fff" stroke-width="8" stroke-linecap="round" stroke-linejoin="round" opacity=".16" transform="translate(0 -7)"/>` +
      `<circle cx="320" cy="100" r="19" fill="#5BDF7E"/><circle cx="313" cy="93" r="5" fill="#fff"/><circle cx="328" cy="93" r="5" fill="#fff"/><circle cx="314.5" cy="94" r="2.6" fill="#0B2A14"/><circle cx="329.5" cy="94" r="2.6" fill="#0B2A14"/>` +
      `<path d="M339 104h10l4-3M349 104l4 3" stroke="#FF3B30" stroke-width="3" fill="none" stroke-linecap="round"/>` +
      `<circle cx="362" cy="58" r="14" fill="url(#cSnA)"/><path d="M362 44c3-6 9-6 12-4-5 0-9 3-12 7z" fill="#34C759"/><circle cx="356" cy="52" r="3.5" fill="#fff" opacity=".7"/>` +
      `<circle cx="80" cy="60" r="12" fill="#FFD60A" opacity=".9"/><circle cx="76" cy="55" r="3" fill="#fff" opacity=".8"/></svg>`;
  },
  howto: { goal: 'Come as frutas, cresce e não batas em ti nem nas paredes.', steps: ['Cada fruta vale pontos e faz a cobra crescer', 'A cada cinco frutas sobes de nível e ganhas velocidade', 'O fruto dourado vale 50 pontos, mas só por uns segundos'], controls: [{ icon: 'move', label: 'Desliza ou toca nas setas' }, { icon: 'gamepad', label: 'Setas ou WASD no teclado' }] },
  build(win) {
    const COLS = 17, ROWS = 15, CELL = 24, W = COLS * CELL, H = ROWS * CELL, MAXN = COLS * ROWS + 2;
    const A = Arcade.shell(win, {
      id: 'snake', name: 'Snake', color: '#30D158',
      /* a morte também é animada (a cobra desfaz-se): pausar a meio e retomar tem de a deixar acabar */
      onRestart: () => start(), onPause: () => L.stop(), onResume: () => { if (started && !A.ended) L.start(); },
    });
    const cv = UI.el(`<canvas class="gm-cv sn-cv" width="${W}" height="${H}"></canvas>`);
    A.el.stage.appendChild(cv);
    const ctx = cv.getContext('2d');
    const fx = Fx(220), shaker = Shaker(cv), rec = recordWatch(A, 'snake');
    A.el.ctl.innerHTML = `<div class="gm-pad">${Arcade.btn('u', 'chevU')}${Arcade.btn('l', 'chevL')}${Arcade.btn('d', 'chevD')}${Arcade.btn('r', 'chevR')}</div>`;

    let mode = Arcade.opt('snake:mode', 'classic'); if (!/^(classic|portal|fast)$/.test(mode)) mode = 'classic';
    const walls = () => mode !== 'portal', fast = () => mode === 'fast';
    const baseSpeed = () => (fast() ? 10 : 6.5);

    /* ---- sprites (uma vez) ---- */
    const SPR = {};
    const makeBg = () => pre(W, H, c => {
      const gr = c.createLinearGradient(0, 0, 0, H); gr.addColorStop(0, '#1A5A2E'); gr.addColorStop(1, '#0F3F20'); c.fillStyle = gr; c.fillRect(0, 0, W, H);
      c.fillStyle = 'rgba(0,0,0,.14)';
      for (let r = 0; r < ROWS; r++) for (let col = (r % 2); col < COLS; col += 2) c.fillRect(col * CELL, r * CELL, CELL, CELL);
      /* grão leve: pontos aleatórios fixos */
      c.fillStyle = 'rgba(255,255,255,.035)';
      for (let i = 0; i < 520; i++) c.fillRect(Math.random() * W, Math.random() * H, 2, 2);
      const v = c.createRadialGradient(W / 2, H / 2, H * .35, W / 2, H / 2, W * .72); v.addColorStop(0, 'rgba(0,0,0,0)'); v.addColorStop(1, 'rgba(0,0,0,.55)'); c.fillStyle = v; c.fillRect(0, 0, W, H);
      if (walls()) { c.strokeStyle = 'rgba(230,255,235,.5)'; c.lineWidth = 3; rrp(c, 2.5, 2.5, W - 5, H - 5, 8); c.stroke(); c.strokeStyle = 'rgba(0,0,0,.45)'; c.lineWidth = 1; rrp(c, 5.5, 5.5, W - 11, H - 11, 6); c.stroke(); }
      else { c.setLineDash([6, 8]); c.strokeStyle = 'rgba(120,220,255,.55)'; c.lineWidth = 2; rrp(c, 2, 2, W - 4, H - 4, 8); c.stroke(); c.setLineDash([]); }
    });
    SPR.bg = makeBg();
    SPR.apple = pre(36, 36, c => {
      c.fillStyle = 'rgba(0,0,0,.3)'; c.beginPath(); c.ellipse(19, 30, 11, 3.5, 0, 0, TAU); c.fill();
      const gr = c.createRadialGradient(13, 14, 2, 18, 19, 13); gr.addColorStop(0, '#FF8A80'); gr.addColorStop(.55, '#FF3B30'); gr.addColorStop(1, '#A8120B');
      c.fillStyle = gr; c.beginPath(); c.arc(18, 19, 12, 0, TAU); c.fill();
      c.fillStyle = 'rgba(255,255,255,.55)'; c.beginPath(); c.ellipse(13, 13, 3.2, 2, -.7, 0, TAU); c.fill();
      c.strokeStyle = '#5B3A1E'; c.lineWidth = 2.2; c.lineCap = 'round'; c.beginPath(); c.moveTo(18, 8); c.quadraticCurveTo(19, 4, 22, 3); c.stroke();
      c.fillStyle = '#34C759'; c.beginPath(); c.moveTo(19, 7); c.quadraticCurveTo(24, 0, 29, 4); c.quadraticCurveTo(25, 8, 19, 7); c.fill();
    });
    SPR.gold = pre(36, 36, c => {
      c.fillStyle = 'rgba(0,0,0,.3)'; c.beginPath(); c.ellipse(19, 30, 11, 3.5, 0, 0, TAU); c.fill();
      const gr = c.createRadialGradient(13, 14, 2, 18, 19, 13); gr.addColorStop(0, '#FFF3B0'); gr.addColorStop(.5, '#FFD60A'); gr.addColorStop(1, '#B07A00');
      c.fillStyle = gr; c.beginPath(); c.arc(18, 19, 12, 0, TAU); c.fill();
      c.fillStyle = 'rgba(255,255,255,.7)'; c.beginPath(); c.ellipse(13, 13, 3.2, 2, -.7, 0, TAU); c.fill();
      c.strokeStyle = '#7A4E12'; c.lineWidth = 2.2; c.lineCap = 'round'; c.beginPath(); c.moveTo(18, 8); c.quadraticCurveTo(19, 4, 22, 3); c.stroke();
      c.fillStyle = '#fff'; c.beginPath(); c.moveTo(25, 23); c.lineTo(26.5, 26.5); c.lineTo(30, 28); c.lineTo(26.5, 29.5); c.lineTo(25, 33); c.lineTo(23.5, 29.5); c.lineTo(20, 28); c.lineTo(23.5, 26.5); c.closePath(); c.fill();
    });
    SPR.goldGlow = glow('#FFD60A', 16);
    /* cabeça virada para +x; olhos à frente, boca; a língua é um sprite à parte */
    SPR.head = pre(44, 44, c => {
      const gr = c.createRadialGradient(16, 15, 3, 22, 22, 17); gr.addColorStop(0, '#B6FFC8'); gr.addColorStop(.45, '#5FE07E'); gr.addColorStop(1, '#1E9A46');
      c.fillStyle = gr; c.beginPath(); c.ellipse(22, 22, 15, 12.5, 0, 0, TAU); c.fill();
      c.strokeStyle = 'rgba(0,40,15,.35)'; c.lineWidth = 1.5; c.stroke();
      c.fillStyle = '#fff'; c.beginPath(); c.arc(27, 15, 4.2, 0, TAU); c.fill(); c.beginPath(); c.arc(27, 29, 4.2, 0, TAU); c.fill();
      c.fillStyle = '#0B2A14'; c.beginPath(); c.arc(28.5, 15, 2.1, 0, TAU); c.fill(); c.beginPath(); c.arc(28.5, 29, 2.1, 0, TAU); c.fill();
      c.fillStyle = 'rgba(255,255,255,.8)'; c.beginPath(); c.arc(27.6, 14, .9, 0, TAU); c.fill(); c.beginPath(); c.arc(27.6, 28, .9, 0, TAU); c.fill();
      c.fillStyle = 'rgba(0,30,10,.35)'; c.beginPath(); c.arc(33, 20, 1.1, 0, TAU); c.fill(); c.beginPath(); c.arc(33, 24, 1.1, 0, TAU); c.fill();
    });
    /* cabeça na morte: o mesmo volume, olhos em X */
    SPR.headDead = pre(44, 44, c => {
      const gr = c.createRadialGradient(16, 15, 3, 22, 22, 17); gr.addColorStop(0, '#9EE0AE'); gr.addColorStop(.45, '#4FB86A'); gr.addColorStop(1, '#1B7A3A');
      c.fillStyle = gr; c.beginPath(); c.ellipse(22, 22, 15, 12.5, 0, 0, TAU); c.fill();
      c.strokeStyle = 'rgba(0,40,15,.35)'; c.lineWidth = 1.5; c.stroke();
      c.strokeStyle = '#0B2A14'; c.lineWidth = 2.2; c.lineCap = 'round';
      [[27, 15], [27, 29]].forEach(p => { c.beginPath(); c.moveTo(p[0] - 3, p[1] - 3); c.lineTo(p[0] + 3, p[1] + 3); c.moveTo(p[0] + 3, p[1] - 3); c.lineTo(p[0] - 3, p[1] + 3); c.stroke(); });
    });
    SPR.tongue = pre(18, 12, c => { c.strokeStyle = '#FF3B30'; c.lineWidth = 2; c.lineCap = 'round'; c.beginPath(); c.moveTo(1, 6); c.lineTo(10, 6); c.lineTo(16, 2); c.moveTo(10, 6); c.lineTo(16, 10); c.stroke(); });
    SPR.scale = pre(14, 14, c => { c.fillStyle = 'rgba(0,40,10,.22)'; c.beginPath(); c.ellipse(7, 7, 4.2, 3, 0, 0, TAU); c.fill(); c.fillStyle = 'rgba(255,255,255,.12)'; c.beginPath(); c.ellipse(6, 5.5, 2, 1.2, 0, 0, TAU); c.fill(); });
    const BODY = []; for (let i = 0; i < 32; i++) BODY.push(mix('#157A3A', '#7CF09A', i / 31));
    const BW = CELL * .78;

    /* ---- estado ---- */
    const PX = new Float32Array(MAXN), PY = new Float32Array(MAXN), WOX = new Int8Array(MAXN), WOY = new Int8Array(MAXN);
    const BULB = new Float32Array(6); let nBulb = 0;
    let body, dir, queue, food, gold, goldT, acc, speed, dead, why, started = false, grew, lastTail, eaten, lvl, t01 = 0, hAng = 0, tongueT = 0, tongueIn = 2.2, eatK = 0, turned = false, flashA = 0, stopT = 0, deadT = 0, dissolveT = 0, sinceGold = 0, score = 0, t0 = 0;
    const hint = () => A.setMid(`<span class="gm-hint">${g('bolt', 16)}<span>Nível\u200b</span> <b>${lvl}</b></span>`);

    const free = (x, y) => { for (let i = 0; i < body.length; i++) if (body[i].x === x && body[i].y === y) return false; return !(food && food.x === x && food.y === y) && !(gold && gold.x === x && gold.y === y); };
    const spot = () => { let p, n = 0; do { p = { x: (Math.random() * COLS) | 0, y: (Math.random() * ROWS) | 0 }; n++; } while (n < 500 && !free(p.x, p.y)); return p; };
    const reset = () => {
      body = [{ x: 8, y: 7 }, { x: 7, y: 7 }, { x: 6, y: 7 }, { x: 5, y: 7 }];
      lastTail = { x: 4, y: 7 }; grew = false;
      dir = { x: 1, y: 0 }; queue = []; acc = 0; speed = baseSpeed(); dead = false; eaten = 0; lvl = 1; started = false; nBulb = 0; t01 = 0; hAng = 0; tongueT = 0; eatK = 0; turned = false; flashA = 0; stopT = 0; deadT = 0; sinceGold = 0; gold = null; score = 0;
      fx.clear(); shaker.reset(); rec.reset();
      A.setScore(0); hint(); food = spot(); draw();
    };
    const start = async () => {
      L.stop(); reset();
      await A.ready('Snake', walls() ? 'Come a fruta e não batas nas paredes' : 'Come a fruta; as paredes atravessam-se');
      if (A.ended) return;
      await countdown(A, 3);
      if (A.ended || started) return;
      started = true; t0 = Date.now(); L.start();
    };
    const DIRS = { u: { x: 0, y: -1 }, d: { x: 0, y: 1 }, l: { x: -1, y: 0 }, r: { x: 1, y: 0 } };
    const turn = d => {
      const m = DIRS[d];
      if (!m || A.paused || dead || !started) return;
      const last = queue.length ? queue[queue.length - 1] : dir;
      if ((m.x === -last.x && m.y === -last.y) || (m.x === last.x && m.y === last.y)) return;
      if (queue.length < 2) queue.push(m);
    };
    Arcade.dirs(cv, turn);
    ['u', 'd', 'l', 'r'].forEach(k => { A.el.ctl.querySelector('.gb.' + k).onclick = () => turn(k); });
    A.options([{ key: 'mode', label: 'Modo', values: [{ v: 'classic', label: 'Clássico' }, { v: 'portal', label: 'Portal' }, { v: 'fast', label: 'Rápido\u200b' }], cur: mode, onChange: v => { mode = v; Arcade.setOpt('snake:mode', v); SPR.bg = makeBg(); if (!started) { speed = baseSpeed(); draw(); } else { speed = Math.min(20, baseSpeed() + (lvl - 1) * 1.2); } } }]);

    const addScore = n => { score += n; A.setScore(score); rec.check(score); };
    const step = () => {
      if (queue.length) { const d = queue.shift(); if (d.x !== dir.x || d.y !== dir.y) { dir = d; turned = true; } }
      const h = body[0]; let nx = h.x + dir.x, ny = h.y + dir.y;
      if (!walls()) { nx = (nx + COLS) % COLS; ny = (ny + ROWS) % ROWS; }
      else if (nx < 0 || ny < 0 || nx >= COLS || ny >= ROWS) { die('Bateste na parede'); return; }
      const onFood = nx === food.x && ny === food.y, onGold = !!gold && nx === gold.x && ny === gold.y;
      const keep = onFood ? body.length : body.length - 1;
      for (let i = 0; i < keep; i++) if (body[i].x === nx && body[i].y === ny) { die('Mordeste-te'); return; }
      body.unshift({ x: nx, y: ny });
      if (onFood) grew = true; else { lastTail = body.pop(); grew = false; }
      for (let i = 0; i < nBulb; i++) BULB[i] += 1;
      let k = 0; for (let i = 0; i < nBulb; i++) if (BULB[i] < body.length + 2) BULB[k++] = BULB[i]; nBulb = k;
      if (onFood) {
        eaten++; sinceGold++;
        const pts = fast() ? 15 : 10;
        addScore(pts); eatK = 1; if (nBulb < 6) BULB[nBulb++] = 0;
        fx.burst(nx * CELL + CELL / 2, ny * CELL + CELL / 2, ['#FF453A', '#FF9F0A', '#fff'], 16, 160, { glow: true, size: 2.6 });
        A.flashAt(cv, nx * CELL + CELL / 2, ny * CELL, '+' + pts, 'pts');
        A.sfx('coin');
        if (!turned) { addScore(5); A.flashAt(cv, nx * CELL + CELL / 2, ny * CELL - 22, 'Direto +5', 'bonus'); }
        turned = false;
        Arcade.maxStat('snakeLen', body.length);
        if (eaten % 5 === 0) { lvl++; speed = Math.min(20, baseSpeed() + (lvl - 1) * 1.2); hint(); A.flash('Nível ' + lvl, 'big'); A.sfx('level'); celebrate(A, 'level'); }
        food = spot();
        if (!gold && sinceGold >= 6 && Math.random() < .5) { gold = spot(); goldT = 7; sinceGold = 0; A.sfx('chime'); }
      }
      if (onGold) {
        const pts = fast() ? 75 : 50;
        addScore(pts); gold = null; eatK = 1; if (nBulb < 6) BULB[nBulb++] = 0;
        fx.burst(nx * CELL + CELL / 2, ny * CELL + CELL / 2, ['#FFD60A', '#FFF3B0', '#fff'], 26, 190, { glow: true, size: 3 });
        A.flashAt(cv, nx * CELL + CELL / 2, ny * CELL, '+' + pts, 'big');
        A.sfx('bonus'); Arcade.flag('snakeGold'); shaker.kick(3);
      }
    };
    const die = reason => {
      if (dead) return;
      /* grew = true: a cauda fica parada (sem isto o último troço ligava-se à posição antiga e desenhava uma diagonal) */
      dead = true; why = reason; deadT = 0; dissolveT = -.25; flashA = .5; stopT = .08; grew = true;
      A.haptic('heavy'); A.sfx('crash'); shaker.kick(9);
    };
    const finish = () => {
      L.stop();
      const secs = Math.round((Date.now() - t0) / 1000);
      A.end({ title: why, sub: `${score} pontos`, score, stats: [{ label: 'Comprimento', value: String(eaten + 4) }, { label: 'Frutas', value: String(eaten) }, { label: 'Nível\u200b', value: String(lvl) }, { label: 'Tempo', value: mmss(secs) }] });
    };

    /* ---- desenho ---- */
    const calc = () => {
      const n = body.length, t = t01;
      for (let i = 0; i < n; i++) {
        const to = body[i], from = i + 1 < n ? body[i + 1] : (grew ? to : lastTail);
        let fx0 = from.x, fy0 = from.y, wox = 0, woy = 0;
        const dx = fx0 - to.x, dy = fy0 - to.y;
        if (dx > 1) { fx0 -= COLS; wox = 1; } else if (dx < -1) { fx0 += COLS; wox = -1; }
        if (dy > 1) { fy0 -= ROWS; woy = 1; } else if (dy < -1) { fy0 += ROWS; woy = -1; }
        PX[i] = (fx0 + (to.x - fx0) * t) * CELL + CELL / 2; PY[i] = (fy0 + (to.y - fy0) * t) * CELL + CELL / 2;
        WOX[i] = wox; WOY[i] = woy;
      }
    };
    /* caminho inteiro (sombra e brilho): cortado nos portais, com as duas metades de cada ligação que atravessa */
    const tracePath = () => {
      const n = body.length; ctx.beginPath(); ctx.moveTo(PX[n - 1], PY[n - 1]);
      for (let i = n - 2; i >= 0; i--) {
        if (WOX[i] || WOY[i]) { const sx = WOX[i] * W, sy = WOY[i] * H; ctx.lineTo(PX[i] + sx, PY[i] + sy); ctx.moveTo(PX[i + 1] - sx, PY[i + 1] - sy); ctx.lineTo(PX[i], PY[i]); }
        else ctx.lineTo(PX[i], PY[i]);
      }
    };
    const widthAt = i => {
      const n = body.length; let w = BW;
      const fromTail = n - 1 - i; if (fromTail < 6) w *= .45 + .55 * (fromTail / 6);
      for (let b = 0; b < nBulb; b++) { const d = Math.abs(i - BULB[b]); if (d < 1.6) w *= 1 + .42 * (1 - d / 1.6); }
      return w;
    };
    const drawBody = () => {
      const n = body.length;
      ctx.lineCap = 'round'; ctx.lineJoin = 'round';
      /* sombra projetada */
      ctx.save(); ctx.translate(3, 4); ctx.globalAlpha = .32; ctx.strokeStyle = '#000'; ctx.lineWidth = BW * .92; tracePath(); ctx.stroke(); ctx.restore();
      /* corpo: um troço por segmento, cor ao longo do corpo, cauda afunilada, bolha a viajar */
      for (let i = n - 2; i >= 0; i--) {
        ctx.strokeStyle = BODY[Math.min(31, (31 * (1 - i / Math.max(10, n))) | 0)]; ctx.lineWidth = widthAt(i);
        ctx.beginPath();
        if (WOX[i] || WOY[i]) { const sx = WOX[i] * W, sy = WOY[i] * H; ctx.moveTo(PX[i + 1], PY[i + 1]); ctx.lineTo(PX[i] + sx, PY[i] + sy); ctx.moveTo(PX[i + 1] - sx, PY[i + 1] - sy); ctx.lineTo(PX[i], PY[i]); }
        else { ctx.moveTo(PX[i + 1], PY[i + 1]); ctx.lineTo(PX[i], PY[i]); }
        ctx.stroke();
      }
      if (n === 1) { ctx.fillStyle = BODY[31]; ctx.beginPath(); ctx.arc(PX[0], PY[0], BW / 2, 0, TAU); ctx.fill(); }
      /* escamas */
      for (let i = 1; i < n - 4; i++) ctx.drawImage(SPR.scale, PX[i] - 7, PY[i] - 7);   /* a ponta afunilada fica lisa */
      /* brilho de cima */
      ctx.save(); ctx.translate(-1, -4); ctx.globalAlpha = .16; ctx.strokeStyle = '#fff'; ctx.lineWidth = BW * .34; tracePath(); ctx.stroke(); ctx.restore();
      /* cabeça */
      ctx.save(); ctx.translate(PX[0], PY[0]); ctx.rotate(hAng);
      if (eatK > 0) ctx.scale(1 + eatK * .22, 1 - eatK * .1);
      if (tongueT > 0 && !dead) ctx.drawImage(SPR.tongue, 12, -6);
      ctx.drawImage(dead ? SPR.headDead : SPR.head, -22, -22);
      ctx.restore();
    };
    const draw = () => {
      ctx.drawImage(SPR.bg, 0, 0);
      ctx.drawImage(SPR.apple, food.x * CELL - 6, food.y * CELL - 7);
      if (gold) {
        const k = goldT < 2 ? .5 + .5 * Math.sin(goldT * 14) : .75 + .25 * Math.sin(goldT * 5);
        ctx.globalAlpha = k * .7; ctx.drawImage(SPR.goldGlow, gold.x * CELL + CELL / 2 - 32, gold.y * CELL + CELL / 2 - 32);
        ctx.globalAlpha = goldT < 2 ? .45 + .55 * k : 1; ctx.drawImage(SPR.gold, gold.x * CELL - 6, gold.y * CELL - 7); ctx.globalAlpha = 1;
        ctx.strokeStyle = '#FFD60A'; ctx.lineWidth = 2.5; ctx.beginPath(); ctx.arc(gold.x * CELL + CELL / 2, gold.y * CELL + CELL / 2, 15, -1.5708, -1.5708 + TAU * (goldT / 7)); ctx.stroke();
      }
      calc();
      if (body.length) drawBody();
      fx.draw(ctx);
      if (flashA > 0) { ctx.globalAlpha = flashA; ctx.fillStyle = '#FF2D1F'; ctx.fillRect(0, 0, W, H); ctx.globalAlpha = 1; }
    };

    const L = Arcade.loop(dt => {
      shaker.step(dt);
      if (stopT > 0) { stopT -= dt; draw(); return; }
      if (dead) {
        /* câmara lenta 0,3× no primeiro meio segundo da morte, depois a cobra desfaz-se em partículas a partir da cauda */
        const sdt = deadT < .5 ? dt * .3 : dt;
        deadT += dt; flashA = Math.max(0, flashA - dt * 3); dissolveT += sdt; fx.step(sdt);
        while (dissolveT > .028 && body.length) {
          dissolveT -= .028; const s = body.pop();
          fx.burst(s.x * CELL + CELL / 2, s.y * CELL + CELL / 2, ['#8CF0A6', '#30D158', '#1F9A46'], 5, 130, { size: 3.2, life: .7 });
          if (body.length === 0) A.sfx('lose');
        }
        draw();
        if (!body.length && fx.count === 0) finish();
        return;
      }
      acc += dt;
      const iv = 1 / speed;
      while (acc >= iv) { acc -= iv; step(); if (dead) { draw(); return; } }
      t01 = acc / iv;
      if (gold) { goldT -= dt; if (goldT <= 0) { gold = null; sinceGold = 0; } }
      if (eatK > 0) eatK = Math.max(0, eatK - dt * 6);
      if (flashA > 0) flashA = Math.max(0, flashA - dt * 3);
      if (tongueT > 0) tongueT -= dt; else { tongueIn -= dt; if (tongueIn <= 0) { tongueT = .28; tongueIn = 1.8 + Math.random() * 2.2; } }
      const ta = Math.atan2(dir.y, dir.x); let da = ta - hAng; while (da > 3.14159) da -= TAU; while (da < -3.14159) da += TAU; hAng += da * Math.min(1, dt * 18);
      fx.step(dt);
      draw();
    });
    start();
    win.onClose = () => L.stop();
    return {
      pause: () => L.stop(),
      resume: () => { if (started && !A.paused && !A.ended) L.start(); },
      key(e) { const d = Arcade.keyDir(e); if (d) { e.preventDefault(); turn(d); } },
      step: dt => { if (started && !dead) { acc += dt; const iv = 1 / speed; while (acc >= iv) { acc -= iv; step(); if (dead) break; } t01 = acc / iv; } },
      draw, turn,
      dbg: { die: () => { if (started) die('Bateste na parede'); }, feed: () => { if (!started) return; const h = body[0]; food = { x: Math.max(0, Math.min(COLS - 1, h.x + dir.x * 2)), y: Math.max(0, Math.min(ROWS - 1, h.y + dir.y * 2)) }; }, grow: n => { if (!started) return; for (let i = 0; i < (n || 10); i++) { const t = body[body.length - 1]; body.push({ x: t.x, y: t.y }); } eaten += n || 10; score += (n || 10) * 10; A.setScore(score); }, gold: () => { if (started) { gold = spot(); goldT = 7; } }, state: () => ({ started, dead, len: body.length, score, lvl, mode }) },
    };
  },
});


/* =====================================================================
   2. 2048: versão escura premium, peças persistentes a deslizar por transform
   ===================================================================== */
const TW_COL = { 2: ['#4A5366', '#3A4150'], 4: ['#55617A', '#434D62'], 8: ['#E08A4A', '#C46A2E'], 16: ['#EC7A3A', '#CC5A22'], 32: ['#F26A3A', '#D04A20'], 64: ['#FA5230', '#D43A1C'], 128: ['#F2C04A', '#D49A22'], 256: ['#F5C43A', '#D89C18'], 512: ['#F8C82C', '#DCA010'], 1024: ['#FBCB1E', '#E0A408'], 2048: ['#FFD016', '#E6A800'], 4096: ['#8F6BFF', '#6A3FE0'], 8192: ['#5FD3FF', '#2A9FD8'] };
const twTile = (v, x, y, s, r, id) => { const c = TW_COL[v] || TW_COL[8192]; return `<defs><linearGradient id="${id}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${c[0]}"/><stop offset="1" stop-color="${c[1]}"/></linearGradient></defs><rect x="${x + 1.5}" y="${y + 3}" width="${s}" height="${s}" rx="${r}" fill="#000" opacity=".35"/><rect x="${x}" y="${y}" width="${s}" height="${s}" rx="${r}" fill="url(#${id})"/><rect x="${x + 1}" y="${y + 1}" width="${s - 2}" height="${s * .45}" rx="${r - 1}" fill="#fff" opacity=".13"/>${v >= 2048 ? `<rect x="${x + 1.2}" y="${y + 1.2}" width="${s - 2.4}" height="${s - 2.4}" rx="${r - 1}" fill="none" stroke="#FFF2A8" stroke-width="2"/>` : ''}<text x="${x + s / 2}" y="${y + s / 2}" text-anchor="middle" dominant-baseline="central" font-family="Inter, system-ui, sans-serif" font-weight="800" font-size="${s * (v >= 1000 ? .3 : v >= 100 ? .38 : .5)}" fill="${v <= 4 ? '#E9EEF8' : '#fff'}">${v}</text>`; };
Icons.app.g2048 = () => Icons.SVG(Icons.G('g20', '#30343E', '#1E2128', '#121419') +
  `<rect x="12" y="12" width="76" height="76" rx="14" fill="#0D0F13"/><rect x="12" y="12" width="76" height="76" rx="14" fill="none" stroke="#fff" stroke-opacity=".06"/>` +
  twTile(2, 17, 17, 31, 7, 'tA') + twTile(8, 52, 17, 31, 7, 'tB') + twTile(128, 17, 52, 31, 7, 'tC') + twTile(2048, 52, 52, 31, 7, 'tD'));

Arcade.game('g2048', {
  name: '2048', color: '#F2B179', kind: 'puzzle', tags: ['Puzzle', 'Calma'],
  /* cada variante diz a sua tabela: a do 4×4 é "g2048" (sem sufixo, a de sempre) e a do 5×5 é "g2048:5" */
  variants: [{ key: '4', label: '4×4', board: 'g2048' }, { key: '5', label: '5×5', board: 'g2048:5' }],
  modes: [{ key: '4', label: '4×4' }, { key: '5', label: '5×5' }],
  desc: 'Junta números iguais até ao 2048 e mais além. Tabuleiro escuro premium, peças que deslizam, desfazer, 4×4 e 5×5.',
  cover: () => {
    const vals = [[2, 0, 4, 0], [0, 8, 32, 2], [16, 128, 512, 4], [64, 256, 2048, 8]];
    let t = '', k = 0;
    for (let r = 0; r < 4; r++) for (let c = 0; c < 4; c++) { t += `<rect x="${116 + c * 44}" y="${12 + r * 44}" width="40" height="40" rx="7" fill="#fff" opacity=".05"/>`; if (vals[r][c]) t += twTile(vals[r][c], 116 + c * 44, 12 + r * 44, 40, 7, 'cT' + (k++)); }
    return `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="c20" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#2A2E38"/><stop offset="1" stop-color="#121419"/></linearGradient><radialGradient id="c20g" cx=".68" cy=".8" r=".5"><stop offset="0" stop-color="#FFD016" stop-opacity=".35"/><stop offset="1" stop-color="#FFD016" stop-opacity="0"/></radialGradient></defs><rect width="400" height="200" fill="url(#c20)"/><rect width="400" height="200" fill="url(#c20g)"/><rect x="108" y="4" width="184" height="192" rx="16" fill="#0D0F13"/>${t}</svg>`;
  },
  howto: { goal: 'Junta peças iguais até chegares ao 2048.', steps: ['Desliza numa direção: todas as peças correm para esse lado', 'Duas peças iguais que se tocam fundem-se numa só', 'Quando o tabuleiro encher sem jogadas possíveis, acaba'], controls: [{ icon: 'move', label: 'Desliza para mover' }, { icon: 'gamepad', label: 'Setas ou WASD; Z desfaz' }] },
  build(win) {
    const A = Arcade.shell(win, { id: 'g2048', name: '2048', color: '#F2B179', pausable: false, onRestart: () => start() });
    const board = UI.el('<div class="tw-board"></div>');
    const cells = UI.el('<div class="tw-cells"></div>'), tiles = UI.el('<div class="tw-tiles"></div>');
    board.appendChild(cells); board.appendChild(tiles);
    board.style.setProperty('--tw-grain', 'url(' + mnGrain() + ')');   /* grão de ardósia, desenhado uma vez */
    A.el.stage.appendChild(board);
    A.el.ctl.innerHTML = `<div class="gm-row wide"><div class="gb lbl undo">${g('arrowL')}<span>Desfazer</span></div></div>`;
    let N = Arcade.opt('g2048:n', '4') === '5' ? 5 : 4;
    A.options([{ key: 'n', label: 'Tabuleiro', values: [{ v: '4', label: '4×4' }, { v: '5', label: '5×5' }], cur: String(N), onChange: v => { N = v === '5' ? 5 : 4; Arcade.setOpt('g2048:n', v); start(true); } }]);
    const rec = recordWatch(A, 'g2048');

    let C = 88, G = 8, grid, over, won, keepGoing, hist, started = false, bestTile = 0, moves = 0, t0 = 0, pending = [], pendT = null, score = 0;
    const undoBtn = A.el.ctl.querySelector('.undo');
    const layout = () => {
      C = N === 5 ? 70 : 88; G = N === 5 ? 6 : 8;
      const inner = N * C + (N - 1) * G;
      board.style.width = board.style.height = (inner + 16) + 'px';
      board.style.setProperty('--tw-c', C + 'px'); board.classList.toggle('n5', N === 5);
      cells.innerHTML = '';
      for (let i = 0; i < N * N; i++) { const d = UI.el('<div class="tw-cell"></div>'); d.style.left = ((i % N) * (C + G)) + 'px'; d.style.top = (((i / N) | 0) * (C + G)) + 'px'; cells.appendChild(d); }
    };
    /* a peça é um contentor posicionado por transform (desliza) com o visual dentro (nasce e faz pop por scale) */
    const vcls = v => 'v' + (v > 8192 ? 'x' : v);
    const place = t => { t.el.style.transform = 'translate(' + (t.c * (C + G)) + 'px,' + (t.r * (C + G)) + 'px)'; };
    const make = (r, c, v, fresh) => {
      const el = UI.el(`<div class="tw-tile${fresh ? ' new' : ''}"><div class="tw-in ${vcls(v)}">${v}</div></div>`);
      const t = { r, c, v, el }; place(t); tiles.appendChild(el); return t;
    };
    const setVal = (t, v) => { t.v = v; t.el.firstChild.className = 'tw-in ' + vcls(v); t.el.firstChild.textContent = v; t.el.classList.remove('new'); };
    const empties = () => { const o = []; for (let i = 0; i < N * N; i++) if (!grid[i]) o.push(i); return o; };
    const spawn = () => { const e = empties(); if (!e.length) return null; const at = e[(Math.random() * e.length) | 0]; const t = make((at / N) | 0, at % N, Math.random() < .9 ? 2 : 4, true); grid[at] = t; return t; };
    const midHud = () => A.setMid(`<span class="gm-hint"><i class="tw-mini ${vcls(bestTile || 2)}"></i><span>Maior</span> <b>${bestTile || 2}</b></span>`);
    const canMove = () => {
      if (empties().length) return true;
      for (let r = 0; r < N; r++) for (let c = 0; c < N; c++) {
        const v = grid[r * N + c].v;
        if (c < N - 1 && grid[r * N + c + 1].v === v) return true;
        if (r < N - 1 && grid[(r + 1) * N + c].v === v) return true;
      }
      return false;
    };
    /* fusões pendentes: a peça absorvida sai do DOM depois do deslize e a sobrevivente ganha o valor novo com pop */
    const settle = () => {
      clearTimeout(pendT); pendT = null;
      for (const p of pending) { p.gone.el.remove(); setVal(p.keep, p.v); p.keep.el.classList.remove('merge'); void p.keep.el.offsetWidth; p.keep.el.classList.add('merge'); }
      pending = [];
    };
    const snapshot = () => ({ g: grid.map(t => (t ? t.v : 0)), s: score });
    const rebuild = (vals, fresh) => {
      tiles.innerHTML = ''; grid = new Array(N * N).fill(null);
      vals.forEach((v, i) => { if (v) grid[i] = make((i / N) | 0, i % N, v, fresh); });
    };

    const move = d => {
      if (over || !started) return;
      settle();
      const before = snapshot();
      const horiz = d === 'l' || d === 'r', rev = d === 'r' || d === 'd';
      const cellOf = (line, k) => (horiz ? line * N + (rev ? N - 1 - k : k) : (rev ? N - 1 - k : k) * N + line);
      let gained = 0, big = 0, movedAny = false;
      const next = new Array(N * N).fill(null);
      for (let line = 0; line < N; line++) {
        let slot = 0, last = null;
        for (let k = 0; k < N; k++) {
          const t = grid[cellOf(line, k)]; if (!t) continue;
          if (last && last.v === t.v && !last.merging) {
            /* funde: t desliza para o sítio de last e some; last duplica */
            const at = cellOf(line, slot - 1);
            t.r = (at / N) | 0; t.c = at % N; place(t); t.el.classList.add('under');
            /* o valor entra nos DADOS já (canMove, recorde, desfazer); só o desenho espera pelo fim do deslize */
            last.v = t.v * 2; pending.push({ keep: last, gone: t, v: last.v }); last.merging = true;
            gained += t.v * 2; if (t.v * 2 > big) big = t.v * 2; movedAny = true;
          } else {
            const at = cellOf(line, slot++);
            const nr = (at / N) | 0, nc = at % N;
            if (nr !== t.r || nc !== t.c) { t.r = nr; t.c = nc; place(t); movedAny = true; }
            next[at] = t; last = t;
          }
        }
      }
      for (const t of next) if (t) t.merging = false;
      if (!movedAny) { A.haptic('light'); return; }
      grid = next; moves++;
      hist.push(before); if (hist.length > 8) hist.shift();
      undoBtn.classList.remove('off');
      if (pending.length) { pendT = setTimeout(settle, 120); win.timers.push(pendT); }
      if (gained) { score += gained; A.setScore(score); rec.check(score); A.flash('+' + gained, big >= 128 ? 'big' : 'pts'); A.sfx(big >= 256 ? 'chime' : big >= 64 ? 'score' : 'slide'); }
      else A.sfx('slide');
      if (big > bestTile) { bestTile = big; midHud(); }
      if (big >= 4096) Arcade.flag('tile4096');
      spawn();
      if (big >= 2048 && !won) {
        won = true; Arcade.flag('tile2048'); A.sfx('win'); A.flash('2048!', 'big'); celebrate(A, 'win');
        const t = setTimeout(() => { UI.confirm('2048!', 'Chegaste ao 2048. Queres continuar a jogar?', 'Continuar').then(ok => { if (!ok) { over = true; finish('Ganhaste', true); } else keepGoing = true; }); }, 900); win.timers.push(t);
        return;
      }
      if (!canMove()) { over = true; A.haptic('heavy'); finish('Sem jogadas', false); }
    };
    const finish = (title, win2) => {
      settle();
      const secs = Math.round((Date.now() - t0) / 1000);
      A.end({ title, sub: `Maior peça: ${bestTile}`, score, win: win2, stats: [{ label: 'Maior peça', value: String(bestTile) }, { label: 'Jogadas', value: String(moves) }, { label: 'Tempo', value: mmss(secs) }] });
    };
    const undo = () => {
      if (!hist.length || !started) return;
      settle();
      const s = hist.pop(); rebuild(s.g); score = s.s; A.setScore(score); over = false; moves = Math.max(0, moves - 1);
      undoBtn.classList.toggle('off', !hist.length);
      A.el.over.classList.remove('in'); A.sfx('swish');
    };
    undoBtn.onclick = undo;

    const start = async skipReady => {
      layout(); settle();
      A.setId(N === 5 ? 'g2048:5' : 'g2048'); rec.reset();
      over = false; won = false; keepGoing = false; hist = []; started = false; bestTile = 0; moves = 0; score = 0; A.setScore(0);
      undoBtn.classList.add('off');
      rebuild(new Array(N * N).fill(0), true); spawn(); spawn(); midHud();
      if (!skipReady) { await A.ready('2048', 'Desliza para juntar os números iguais'); if (A.ended) return; }
      started = true; t0 = Date.now();
    };
    Arcade.dirs(board, move);
    start();
    return {
      pause() {}, resume() {},
      key(e) { const d = Arcade.keyDir(e); if (d) { e.preventDefault(); move(d); } else if (e.key === 'z' || e.key === 'Z' || e.key === 'Backspace') { e.preventDefault(); undo(); } },
      dbg: { move, grid: () => grid.map(t => (t ? t.v : 0)), fill: (vals, sc, mv) => { rebuild(vals || [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2, 4, 8, 16, 32, 64].slice(0, N * N).concat(new Array(Math.max(0, N * N - 16)).fill(0))); bestTile = Math.max.apply(null, grid.map(t => (t ? t.v : 0))); midHud(); if (sc != null) { score = sc; A.setScore(score); moves = mv || moves; } }, end: () => { if (started) { over = true; finish('Sem jogadas', false); } }, state: () => ({ N, started, over, score, bestTile, moves }) },
    };
  },
});


/* =====================================================================
   3. BLOCOS (Tetris): regras modernas (saco de 7, SRS, reserva, fila de 3, fantasma, lock delay, T-spin,
   combo, back-to-back, limpeza perfeita), minos com bisel, três modos (Maratona, Sprint 40, Ultra 2 min)
   ===================================================================== */
const BL_COL = { I: '#00D1F0', O: '#FFD60A', T: '#C05CFF', S: '#36E07A', Z: '#FF4F5E', J: '#2E8CFF', L: '#FF9F2E' };
const BL_SHAPE = {
  I: [[0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0]], O: [[1, 1], [1, 1]],
  T: [[0, 1, 0], [1, 1, 1], [0, 0, 0]], S: [[0, 1, 1], [1, 1, 0], [0, 0, 0]], Z: [[1, 1, 0], [0, 1, 1], [0, 0, 0]],
  J: [[1, 0, 0], [1, 1, 1], [0, 0, 0]], L: [[0, 0, 1], [1, 1, 1], [0, 0, 0]],
};
/* rotações: 4 estados por peça, cada um como lista de células [x, y] dentro da caixa */
const BL_ROT = {};
Object.keys(BL_SHAPE).forEach(k => {
  let m = BL_SHAPE[k]; const n = m.length, states = [];
  for (let r = 0; r < 4; r++) {
    const cells = []; for (let y = 0; y < n; y++) for (let x = 0; x < n; x++) if (m[y][x]) cells.push([x, y]);
    states.push(cells);
    const o = []; for (let y = 0; y < n; y++) { const row = []; for (let x = 0; x < n; x++) row.push(m[n - 1 - x][y]); o.push(row); } m = o;
  }
  BL_ROT[k] = { n, states };
});
/* wall kicks SRS (x, y com y para CIMA, como nas tabelas: converte-se ao aplicar) */
const BL_KICK = {
  '01': [[0, 0], [-1, 0], [-1, 1], [0, -2], [-1, -2]], '10': [[0, 0], [1, 0], [1, -1], [0, 2], [1, 2]],
  '12': [[0, 0], [1, 0], [1, -1], [0, 2], [1, 2]], '21': [[0, 0], [-1, 0], [-1, 1], [0, -2], [-1, -2]],
  '23': [[0, 0], [1, 0], [1, 1], [0, -2], [1, -2]], '32': [[0, 0], [-1, 0], [-1, -1], [0, 2], [-1, 2]],
  '30': [[0, 0], [-1, 0], [-1, -1], [0, 2], [-1, 2]], '03': [[0, 0], [1, 0], [1, 1], [0, -2], [1, -2]],
};
const BL_KICK_I = {
  '01': [[0, 0], [-2, 0], [1, 0], [-2, -1], [1, 2]], '10': [[0, 0], [2, 0], [-1, 0], [2, 1], [-1, -2]],
  '12': [[0, 0], [-1, 0], [2, 0], [-1, 2], [2, -1]], '21': [[0, 0], [1, 0], [-2, 0], [1, -2], [-2, 1]],
  '23': [[0, 0], [2, 0], [-1, 0], [2, 1], [-1, -2]], '32': [[0, 0], [-2, 0], [1, 0], [-2, -1], [1, 2]],
  '30': [[0, 0], [1, 0], [-2, 0], [1, -2], [-2, 1]], '03': [[0, 0], [-1, 0], [2, 0], [-1, 2], [2, -1]],
};
/* mino com bisel (luz de cima-esquerda, aresta escura em baixo, brilho), em cache por cor e tamanho */
const minoCache = new Map();
const mino = (color, s, kind) => {
  const key = color + '|' + s + '|' + (kind || ''); let c = minoCache.get(key); if (c) return c;
  c = pre(s, s, x => {
    if (kind === 'ghost') { x.strokeStyle = rgba(color, .55); x.lineWidth = 1.5; rrp(x, 1.5, 1.5, s - 3, s - 3, 3); x.stroke(); x.fillStyle = rgba(color, .13); x.fill(); return; }
    const gr = x.createLinearGradient(0, 0, 0, s); gr.addColorStop(0, shade(color, .28)); gr.addColorStop(.5, color); gr.addColorStop(1, shade(color, -.3));
    x.fillStyle = gr; rrp(x, .5, .5, s - 1, s - 1, 3); x.fill();
    const b = Math.max(2, s * .14);
    x.fillStyle = 'rgba(255,255,255,.42)'; x.beginPath(); x.moveTo(1, 1); x.lineTo(s - 1, 1); x.lineTo(s - 1 - b, 1 + b); x.lineTo(1 + b, 1 + b); x.lineTo(1 + b, s - 1 - b); x.lineTo(1, s - 1); x.closePath(); x.fill();
    x.fillStyle = 'rgba(0,0,0,.38)'; x.beginPath(); x.moveTo(s - 1, s - 1); x.lineTo(1, s - 1); x.lineTo(1 + b, s - 1 - b); x.lineTo(s - 1 - b, s - 1 - b); x.lineTo(s - 1 - b, 1 + b); x.lineTo(s - 1, 1); x.closePath(); x.fill();
    x.fillStyle = 'rgba(255,255,255,.22)'; x.fillRect(1 + b, 1 + b, s - 2 - b * 2, Math.max(1, (s - 2 - b * 2) * .3));
    x.strokeStyle = 'rgba(0,0,0,.35)'; x.lineWidth = 1; rrp(x, .5, .5, s - 1, s - 1, 3); x.stroke();
  });
  minoCache.set(key, c); return c;
};
const blPieceSvg = (k, x, y, s, id) => { const col = BL_COL[k], cells = BL_ROT[k].states[0]; return `<defs><linearGradient id="${id}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${shade(col, .3)}"/><stop offset="1" stop-color="${shade(col, -.25)}"/></linearGradient></defs>` + cells.map(c => `<rect x="${x + c[0] * s + 1.5}" y="${y + c[1] * s + 2.5}" width="${s - 2}" height="${s - 2}" rx="2" fill="#000" opacity=".4"/>`).join('') + cells.map(c => `<rect x="${x + c[0] * s}" y="${y + c[1] * s}" width="${s - 2}" height="${s - 2}" rx="2" fill="url(#${id})"/><rect x="${x + c[0] * s + 2}" y="${y + c[1] * s + 2}" width="${s - 6}" height="${(s - 6) * .4}" rx="1" fill="#fff" opacity=".35"/>`).join(''); };
/* ícone: um poço 5×5 com a pilha em baixo (J, T, O) e um S a cair, cada mino com gradiente, brilho e sombra */
Icons.app.blocks = () => {
  const s = 16, ox = 10, oy = 11;
  const map = ['..SS.', '.SS..', '..T..', 'JTTOO', 'JJJOO'];
  let defs = '', body = '';
  Object.keys(BL_COL).forEach(k => { defs += `<linearGradient id="bI${k}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${shade(BL_COL[k], .32)}"/><stop offset="1" stop-color="${shade(BL_COL[k], -.28)}"/></linearGradient>`; });
  map.forEach((row, r) => row.split('').forEach((k, c) => { if (k === '.') return; const x = ox + c * s, y = oy + r * s + (r < 2 ? -3 : 0);
    body += `<rect x="${x + .8}" y="${y + 1.8}" width="${s - 1.5}" height="${s - 1.5}" rx="2.4" fill="#000" opacity=".45"/><rect x="${x}" y="${y}" width="${s - 1.5}" height="${s - 1.5}" rx="2.4" fill="url(#bI${k})"/><rect x="${x + 2}" y="${y + 1.6}" width="${s - 5.5}" height="${(s - 5.5) * .38}" rx="1.2" fill="#fff" opacity=".42"/>`; }));
  return Icons.SVG(Icons.G('gBl', '#2C3252', '#151A33', '#0A0C18') + `<defs>${defs}</defs>` +
    `<g opacity=".1" stroke="#fff" stroke-width=".8">${[1, 2, 3, 4].map(i => `<path d="M${ox + i * s} 6v88"/>`).join('')}</g>` + body);
};

Arcade.game('blocks', {
  name: 'Blocos', color: '#00C7BE', kind: 'puzzle', tags: ['Clássico', 'Puzzle'],
  /* Maratona fica na tabela de sempre ("blocks"); Sprint conta segundos (quanto menos melhor); Ultra conta pontos */
  variants: [{ key: 'marathon', label: 'Maratona', board: 'blocks' }, { key: 'sprint', label: 'Sprint 40', board: 'blocks:sprint', lower: true, unit: 'segundos' }, { key: 'ultra', label: 'Ultra 2 min', board: 'blocks:ultra' }],
  modes: [{ key: 'marathon', label: 'Maratona' }, { key: 'sprint', label: 'Sprint 40' }, { key: 'ultra', label: 'Ultra 2 min' }],
  desc: 'Tetris moderno: saco de sete, rotação com encaixe nas paredes, reserva, fila de três, peça fantasma, T-spins, combos e back-to-back. Maratona, Sprint de 40 linhas e Ultra de 2 minutos.',
  cover: () => {
    const rows = [['', '', '', 'I', 'I', 'I', 'I', '', '', ''], ['J', '', '', '', 'T', 'T', 'T', '', 'L', 'L'], ['J', 'J', 'J', 'S', 'S', 'T', 'O', 'O', 'L', 'Z'], ['Z', 'Z', 'S', 'S', 'J', 'J', 'O', 'O', 'L', 'Z'], ['', 'Z', 'Z', 'I', 'I', 'I', 'I', 'S', 'S', 'Z']];
    let t = '', s = 18;
    rows.forEach((r, y) => r.forEach((k, x) => { if (!k) return; const col = BL_COL[k], X = 110 + x * s, Y = 106 + y * s; t += `<rect x="${X}" y="${Y}" width="${s - 1}" height="${s - 1}" rx="2" fill="${col}"/><rect x="${X}" y="${Y}" width="${s - 1}" height="${(s - 1) * .4}" rx="2" fill="#fff" opacity=".3"/><rect x="${X}" y="${Y + (s - 1) * .7}" width="${s - 1}" height="${(s - 1) * .3}" rx="2" fill="#000" opacity=".3"/>`; }));
    return `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="cBl" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1B2040"/><stop offset="1" stop-color="#0A0C16"/></linearGradient><radialGradient id="cBlg" cx=".5" cy=".9" r=".6"><stop offset="0" stop-color="#C05CFF" stop-opacity=".35"/><stop offset="1" stop-color="#C05CFF" stop-opacity="0"/></radialGradient></defs><rect width="400" height="200" fill="url(#cBl)"/><rect width="400" height="200" fill="url(#cBlg)"/><g opacity=".07" stroke="#fff">${[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map(i => `<path d="M${110 + i * 18} 0v200"/>`).join('')}</g>${t}${blPieceSvg('T', 182, 30, 18, 'cT')}</svg>`;
  },
  howto: { goal: 'Encaixa as peças e fecha linhas sem deixar a pilha chegar ao topo.', steps: ['Roda e move a peça enquanto cai; a sombra mostra onde aterra', 'Guarda uma peça na reserva para a usar mais tarde', 'Quatro linhas de uma vez, T-spins e combos valem muito mais'], controls: [{ icon: 'move', label: 'Desliza para mover, toca para rodar, desliza para baixo para largar' }, { icon: 'gamepad', label: 'Setas, Z e X rodam, Espaço larga, C guarda' }] },
  build(win) {
    const W = 10, H = 20, HID = 2, CELL = 26, CW = W * CELL, CH = H * CELL;
    let G = null;
    const kill = () => { if (G) { G.kill(); G = null; } };
    const boot = mode => { kill(); G = makeGame(mode); };
    const makeGame = mode => {
      const sprint = mode === 'sprint', ultra = mode === 'ultra';
      const board = sprint ? 'blocks:sprint' : ultra ? 'blocks:ultra' : 'blocks';
      const A = Arcade.shell(win, {
        id: board, name: 'Blocos', color: '#00C7BE', lowerIsBetter: sprint, unit: sprint ? 'segundos' : 'pontos', scoreLabel: sprint ? 'Tempo' : 'Pontos', bestLabel: sprint ? 'Melhor' : 'Recorde',
        onRestart: () => start(), onPause: () => L.stop(), onResume: () => { if (started && !dead) L.start(); },
      });
      const stage = UI.el(`<div class="bl-stage"><canvas class="gm-cv" width="${CW}" height="${CH}"></canvas>
        <div class="bl-side"><div class="bl-box"><span>Seguinte</span><canvas class="nx" width="66" height="132"></canvas></div>
          <div class="bl-box"><span>Reserva</span><canvas class="hd" width="66" height="44"></canvas></div>
          <div class="bl-box st"><span class="stl">${sprint ? 'Faltam' : 'Linhas'}</span><b class="ln">0</b></div></div></div>`);
      A.el.stage.appendChild(stage);
      const cv = stage.querySelector('.gm-cv'), ctx = cv.getContext('2d');
      const nxc = stage.querySelector('.nx').getContext('2d'), hdc = stage.querySelector('.hd').getContext('2d');
      const lnEl = stage.querySelector('.ln');
      const fx = Fx(220), shaker = Shaker(stage), rec = recordWatch(A, board, sprint);
      A.el.ctl.innerHTML = `<div class="gm-row">${Arcade.btn('l', 'chevL')}${Arcade.btn('rot', 'rotate', 20)}${Arcade.btn('r', 'chevR')}${Arcade.btn('dn', 'chevD')}${Arcade.btn('hold', 'bookmark', 19)}${Arcade.btn('drop', 'arrowDown')}</div>`;
      let startLv = parseInt(Arcade.opt('blocks:start', '1'), 10) || 1;
      const opts = [{ key: 'mode', label: 'Modo', values: [{ v: 'marathon', label: 'Maratona' }, { v: 'sprint', label: 'Sprint 40' }, { v: 'ultra', label: 'Ultra 2 min' }], cur: mode, onChange: v => { Arcade.setOpt('blocks:mode', v); boot(v); } }];
      if (!sprint) opts.push({ key: 'start', label: 'Nível inicial', values: [{ v: '1', label: '1' }, { v: '5', label: '5' }, { v: '10', label: '10' }], cur: String(startLv), onChange: v => { startLv = +v; Arcade.setOpt('blocks:start', v); if (!started) { level = startLv; hint(); bgSwap(); draw(); } } });
      A.options(opts);

      /* ---- sprites ---- */
      const MINO = {}, GHOST = {}, SMALL = {};
      Object.keys(BL_COL).forEach(k => { MINO[k] = mino(BL_COL[k], CELL); GHOST[k] = mino(BL_COL[k], CELL, 'ghost'); SMALL[k] = mino(BL_COL[k], 13); });
      const WHITE = mino('#FFFFFF', CELL);
      /* rasto da queda dura: faixa vertical que esvai para cima (esticada com drawImage) */
      const TRAIL = pre(CELL, 64, x => { const gr = x.createLinearGradient(0, 0, 0, 64); gr.addColorStop(0, 'rgba(255,255,255,0)'); gr.addColorStop(1, 'rgba(255,255,255,.75)'); x.fillStyle = gr; x.fillRect(2, 0, CELL - 4, 64); });
      const BGS = [['#0C1430', '#070A16'], ['#0B1E36', '#060C18'], ['#06202A', '#040E14'], ['#1A0F33', '#0A0616'], ['#2A0C1E', '#12060E'], ['#2A160A', '#120906'], ['#0F2412', '#060E08'], ['#1E1E24', '#0A0A0E']];
      const bgCache = new Map();
      const bgFor = lv => { const i = ((lv - 1) / 2 | 0) % BGS.length; let c = bgCache.get(i); if (c) return c; const p = BGS[i]; c = pre(CW, CH, x => { const gr = x.createLinearGradient(0, 0, 0, CH); gr.addColorStop(0, p[0]); gr.addColorStop(1, p[1]); x.fillStyle = gr; x.fillRect(0, 0, CW, CH); x.strokeStyle = 'rgba(255,255,255,.05)'; x.lineWidth = 1; for (let i2 = 1; i2 < W; i2++) { x.beginPath(); x.moveTo(i2 * CELL + .5, 0); x.lineTo(i2 * CELL + .5, CH); x.stroke(); } for (let j = 1; j < H; j++) { x.beginPath(); x.moveTo(0, j * CELL + .5); x.lineTo(CW, j * CELL + .5); x.stroke(); } const v = x.createRadialGradient(CW / 2, CH * .55, CH * .2, CW / 2, CH * .55, CH * .75); v.addColorStop(0, 'rgba(0,0,0,0)'); v.addColorStop(1, 'rgba(0,0,0,.45)'); x.fillStyle = v; x.fillRect(0, 0, CW, CH); }); bgCache.set(i, c); return c; };
      const DANGER = pre(CW, CH, x => { const gr = x.createLinearGradient(0, 0, 0, CH * .4); gr.addColorStop(0, 'rgba(255,60,60,.45)'); gr.addColorStop(1, 'rgba(255,60,60,0)'); x.fillStyle = gr; x.fillRect(0, 0, CW, CH); });
      let bgA = null, bgB = null, bgT = 1;
      const bgSwap = () => { const n = bgFor(level); if (n === bgA) return; bgB = bgA; bgA = n; bgT = bgB ? 0 : 1; };

      /* ---- estado ---- */
      let grid, cur, px, py, rot, acc, lines, level, dead, queue, holdP, holdUsed, bag = [], started = false, combo, b2b, lockT, resets, lowest, lastRot, lastKick, clr = null, fallT = 0, trail = null, lockFx = null, tspins = 0, tetrises = 0, pieces = 0, elapsed = 0, lastSec = -1, score = 0, danger = 0, flashA = 0, t0 = 0, maxCombo = 0;
      const FALL = new Float32Array(H + HID);
      const LOCKC = new Int16Array(8);
      const hint = () => { if (ultra) A.setMid(`<span class="gm-hint">${g('clock', 16)} <b>${mmss(Math.max(0, 120 - elapsed))}</b></span>`); else if (sprint) A.setMid(`<span class="gm-hint">${g('bolt', 16)}<span>Sprint</span> <b>40</b></span>`); else A.setMid(`<span class="gm-hint">${g('bolt', 16)}<span>Nível\u200b</span> <b>${level}</b></span>`); };
      const gravity = () => (sprint ? 1 : Math.pow(.8 - (Math.min(20, level) - 1) * .007, Math.min(20, level) - 1));

      const take = () => { if (!bag.length) { bag = Object.keys(BL_COL); for (let i = bag.length - 1; i > 0; i--) { const j = (Math.random() * (i + 1)) | 0; const t = bag[i]; bag[i] = bag[j]; bag[j] = t; } } return bag.pop(); };
      const cellsOf = (k, r) => BL_ROT[k].states[r & 3];
      const hit = (k, r, ox, oy) => { const c = cellsOf(k, r); for (let i = 0; i < c.length; i++) { const gx = ox + c[i][0], gy = oy + c[i][1]; if (gx < 0 || gx >= W || gy >= H + HID) return true; if (gy >= 0 && grid[gy][gx]) return true; } return false; };
      const spawn = k => {
        cur = k || queue.shift(); if (!k) queue.push(take());
        rot = 0; px = cur === 'O' ? 4 : 3; py = cur === 'I' ? 0 : 1; holdUsed = !!k && holdUsed; lockT = 0; resets = 0; lowest = py; lastRot = false; lastKick = 0; pieces++;
        paintSide();
        if (hit(cur, rot, px, py)) { dead = true; cur = null; A.haptic('heavy'); A.sfx('crash'); shaker.kick(6); finish('Sem espaço', false); }
      };
      const ground = () => hit(cur, rot, px, py + 1);
      const touch = () => { if (ground() && resets < 15) { lockT = 0; resets++; } };
      const move = dx => { if (!ok() || hit(cur, rot, px + dx, py)) return false; px += dx; lastRot = false; touch(); A.sfx('tick'); return true; };
      const rotate = dirn => {
        if (!ok() || cur === 'O') { if (ok()) A.sfx('tick'); return; }
        const nr = (rot + (dirn < 0 ? 3 : 1)) & 3, tbl = (cur === 'I' ? BL_KICK_I : BL_KICK)[String(rot) + String(nr)];
        for (let i = 0; i < tbl.length; i++) { const kx = tbl[i][0], ky = -tbl[i][1]; if (!hit(cur, nr, px + kx, py + ky)) { rot = nr; px += kx; py += ky; lastRot = true; lastKick = i; touch(); A.sfx('tick'); return; } }
        A.sfx('move');
      };
      const soft = () => { if (!ok()) return false; if (!ground()) { py++; score += 1; A.setScore(score); lastRot = false; if (py > lowest) { lowest = py; resets = 0; } return true; } return false; };
      const hard = () => {
        if (!ok()) return; let n = 0; const y0 = py; while (!ground()) { py++; n++; }
        score += n * 2; A.setScore(score);
        const c = cellsOf(cur, rot); let minx = 9, maxx = 0; for (let i = 0; i < c.length; i++) { if (c[i][0] < minx) minx = c[i][0]; if (c[i][0] > maxx) maxx = c[i][0]; }
        if (n > 1) trail = { x: px + minx, w: maxx - minx + 1, y0: y0 - HID, y1: py - HID, t: 0 };
        A.sfx('whoosh'); shaker.kick(Math.min(4, 1 + n * .25));
        lock();
      };
      const hold = () => {
        if (!ok() || holdUsed) return;
        const keep = cur; const h = holdP; holdP = keep;
        if (h) spawn(h); else spawn();
        holdUsed = true; paintSide(); A.sfx('swish');
      };
      const tspinKind = () => {
        if (cur !== 'T' || !lastRot) return 0;
        const occ = (x, y) => x < 0 || x >= W || y >= H + HID || (y >= 0 && !!grid[y][x]);
        const a = occ(px, py), b = occ(px + 2, py), c = occ(px, py + 2), d = occ(px + 2, py + 2);
        const n = a + b + c + d; if (n < 3) return 0;
        const front = rot === 0 ? (a && b) : rot === 1 ? (b && d) : rot === 2 ? (c && d) : (a && c);
        return (front || lastKick === 4) ? 2 : 1;
      };
      const lock = () => {
        const ts = tspinKind();
        const c = cellsOf(cur, rot); let nL = 0;
        for (let i = 0; i < c.length; i++) { const gx = px + c[i][0], gy = py + c[i][1]; if (gy >= 0) { grid[gy][gx] = cur; LOCKC[nL++] = gx; LOCKC[nL++] = gy; } }
        lockFx = { n: nL, t: 0 }; A.sfx('place');
        /* linhas completas */
        const rows = []; for (let y = 0; y < H + HID; y++) { let full = true; for (let x = 0; x < W; x++) if (!grid[y][x]) { full = false; break; } if (full) rows.push(y); }
        const n = rows.length;
        let pts = 0, hard2 = false, label = null;
        if (ts === 2) { pts = [400, 800, 1200, 1600][n] || 1600; hard2 = n > 0; label = n ? 'T-Spin!' : 'T-Spin'; tspins++; Arcade.flag('tspin'); }
        else if (ts === 1) { pts = [100, 200, 400, 400][n]; hard2 = n > 0; label = 'T-Spin mini'; tspins++; Arcade.flag('tspin'); }
        else pts = [0, 100, 300, 500, 800][n];
        if (n === 4) { hard2 = true; label = 'Tetris!'; tetrises++; Arcade.flag('tetris'); }
        if (n > 0 && hard2 && b2b) { pts = Math.round(pts * 1.5); A.flashAt(cv, CW / 2, CH * .22, 'Back-to-back', 'bonus'); }
        if (n > 0) b2b = hard2;
        if (n > 0) {
          combo++; if (combo > maxCombo) maxCombo = combo;
          if (combo >= 2) { pts += 50 * (combo - 1); A.flashAt(cv, CW / 2, CH * .32, 'Combo x' + combo, 'pts'); A.sfx('combo'); }
          lines += n; Arcade.maxStat('blocksLines', lines);
          lnEl.textContent = sprint ? String(Math.max(0, 40 - lines)) : String(lines);
          const cy = (rows.reduce((a, b) => a + b, 0) / n - HID) * CELL;
          for (let r = 0; r < n; r++) for (let x = 0; x < W; x++) fx.burst(x * CELL + CELL / 2, (rows[r] - HID) * CELL + CELL / 2, BL_COL[grid[rows[r]][x]] || '#fff', 2, 150, { size: 2.6, life: .55 });
          if (label) { A.flashAt(cv, CW / 2, cy, label, 'big'); A.haptic(n === 4 ? 'medium' : 'light'); A.sfx(n === 4 ? 'drum' : 'score'); shaker.kick(n === 4 ? 6 : 2 + n); if (n === 4) flashA = .5; }
          else { A.sfx('score'); shaker.kick(1 + n); }
          clr = { rows, t: 0 };
          /* limpeza perfeita: nada fica no tabuleiro */
          let any = false; for (let y = 0; y < H + HID && !any; y++) if (rows.indexOf(y) < 0) for (let x = 0; x < W; x++) if (grid[y][x]) { any = true; break; }
          if (!any) { pts += [0, 800, 1200, 1800, 2000][n]; A.flashAt(cv, CW / 2, CH * .5, 'Limpeza perfeita!', 'big'); celebrate(A, 'level'); A.sfx('win'); }
        } else { combo = 0; if (label) { A.flashAt(cv, CW / 2, (py - HID) * CELL, label, 'bonus'); A.sfx('chime'); } }
        pts *= sprint ? 1 : level;
        if (pts) { score += pts; A.setScore(score); if (!sprint) rec.check(score); if (n > 0) A.flashAt(cv, CW / 2, CH * .42, '+' + pts, 'pts'); }
        if (!sprint) { const nl = Math.max(startLv, 1 + ((lines / 10) | 0)); if (nl > level) { level = nl; hint(); bgSwap(); A.flash('Nível ' + level, 'big'); A.sfx('level'); celebrate(A, 'level'); } }
        if (sprint && lines >= 40) { finishSprint(); return; }
        cur = null; holdUsed = false;
        if (!n) spawn();
      };
      const afterClear = () => {
        const rows = clr.rows; clr = null;
        for (let y = 0; y < H + HID; y++) FALL[y] = 0;
        let w2 = H + HID - 1;
        for (let y = H + HID - 1; y >= 0; y--) { if (rows.indexOf(y) >= 0) continue; if (w2 !== y) { grid[w2] = grid[y]; FALL[w2] = w2 - y; } w2--; }
        for (; w2 >= 0; w2--) { grid[w2] = new Array(W).fill(0); FALL[w2] = 0; }
        fallT = .001;
        if (!dead) spawn();
      };
      const ok = () => started && !A.paused && !dead && !!cur && !clr;
      const finish = (title, win2) => {
        L.stop(); const secs = Math.round((Date.now() - t0) / 1000);
        const st = [{ label: 'Linhas', value: String(lines) }];
        if (!sprint) st.push({ label: 'Nível\u200b', value: String(level) });
        st.push({ label: 'Tetris', value: String(tetrises) }, { label: 'T-spins', value: String(tspins) });
        if (!ultra) st.push({ label: 'Tempo', value: mmss(secs) });
        A.end({ title, sub: sprint ? `${lines} de 40 linhas` : `${lines} linhas`, score: sprint ? null : score, submit: !sprint, win: win2, stats: st });
      };
      const finishSprint = () => {
        L.stop(); dead = true; cur = null;
        const secs = Math.max(1, Math.round(elapsed)); A.setScore(secs); Arcade.flag('sprint40'); celebrate(A, 'win');
        A.end({ title: 'Sprint feito!', sub: `${secs} segundos`, score: secs, win: true, stats: [{ label: 'Tempo', value: mmss(secs) }, { label: 'Peças', value: String(pieces) }, { label: 'Peças por segundo', value: (pieces / Math.max(1, elapsed)).toFixed(2) }, { label: 'T-spins', value: String(tspins) }] });
      };

      /* ---- controlos ---- */
      const b = k => A.el.ctl.querySelector('.gb.' + k);
      b('l').onclick = () => move(-1); b('r').onclick = () => move(1); b('rot').onclick = () => rotate(1);
      b('dn').onclick = () => { if (soft()) A.sfx('tick'); }; b('hold').onclick = hold; b('drop').onclick = hard;
      const pt = { x: 0, y: 0 }; let gx0 = 0, gy0 = 0, gt0 = 0, gacc = 0, gmoved = false, gon = false;
      cv.addEventListener('pointerdown', e => { if (!ok()) return; canvasPoint(cv, e, pt); gx0 = pt.x; gy0 = pt.y; gt0 = performance.now(); gacc = 0; gmoved = false; gon = true; try { cv.setPointerCapture(e.pointerId); } catch (x) {} });
      cv.addEventListener('pointermove', e => { if (!gon || !ok()) return; canvasPoint(cv, e, pt); const dx = pt.x - gx0; gacc += dx; gx0 = pt.x; while (gacc > CELL * .9) { gacc -= CELL * .9; move(1); gmoved = true; } while (gacc < -CELL * .9) { gacc += CELL * .9; move(-1); gmoved = true; } });
      const gend = e => { if (!gon) return; gon = false; if (!ok()) return; canvasPoint(cv, e, pt); const dy = pt.y - gy0, dt = performance.now() - gt0;
        /* para baixo: curto (ou lento) = queda suave tantas casas quanto o arrasto; longo e rápido = queda dura */
        if (dy > 110 || (dy > 70 && dt < 220)) { hard(); return; }
        if (dy > 28) { const n = Math.max(1, Math.round(dy / CELL)); for (let i = 0; i < n; i++) soft(); A.sfx('tick'); return; }
        if (!gmoved && dt < 350 && Math.abs(dy) < 20) rotate(1); };
      cv.addEventListener('pointerup', gend); cv.addEventListener('pointercancel', () => { gon = false; });

      /* ---- lado ---- */
      /* miniatura centrada numa caixa de 66×44: a peça I ocupa a linha 1 da caixa 4×4, as outras as linhas 0 e 1 */
      const miniAt = (c2, k, ox, oy) => { if (!k) return; const cells = cellsOf(k, 0), s = 13, w = (k === 'I' ? 4 : k === 'O' ? 2 : 3) * s, h = (k === 'I' ? 1 : 2) * s, dx = ox + (66 - w) / 2, dy = oy + (44 - h) / 2 - (k === 'I' ? s : 0); for (let i = 0; i < cells.length; i++) c2.drawImage(SMALL[k], dx + cells[i][0] * s, dy + cells[i][1] * s); };
      const paintSide = () => { nxc.clearRect(0, 0, 66, 132); for (let i = 0; i < 3; i++) miniAt(nxc, queue[i], 0, i * 44); hdc.clearRect(0, 0, 66, 44); hdc.globalAlpha = holdUsed ? .35 : 1; miniAt(hdc, holdP, 0, 0); hdc.globalAlpha = 1; };

      /* ---- desenho ---- */
      const draw = () => {
        if (bgT < 1 && bgB) { ctx.drawImage(bgB, 0, 0); ctx.globalAlpha = bgT; ctx.drawImage(bgA, 0, 0); ctx.globalAlpha = 1; } else ctx.drawImage(bgA, 0, 0);
        const fe = fallT > 0 ? 1 - ease(fallT / .14) : 0;
        for (let y = 0; y < H + HID; y++) {
          const row = grid[y], off = fe ? FALL[y] * fe : 0, yy = (y - HID - off) * CELL;
          if (yy < -CELL) continue;
          const clearing = clr && clr.rows.indexOf(y) >= 0;
          for (let x = 0; x < W; x++) { const k = row[x]; if (!k) continue; if (clearing) { const a = 1 - clr.t / .2; ctx.globalAlpha = a; ctx.drawImage(WHITE, x * CELL, yy); ctx.globalAlpha = 1; } else ctx.drawImage(MINO[k], x * CELL, yy); }
        }
        if (cur && !dead) {
          const c = cellsOf(cur, rot);
          let gy = py; while (!hit(cur, rot, px, gy + 1)) gy++;
          if (gy !== py) for (let i = 0; i < c.length; i++) { const yy = gy + c[i][1] - HID; if (yy >= 0) ctx.drawImage(GHOST[cur], (px + c[i][0]) * CELL, yy * CELL); }
          for (let i = 0; i < c.length; i++) { const yy = py + c[i][1] - HID; if (yy >= -1) ctx.drawImage(MINO[cur], (px + c[i][0]) * CELL, yy * CELL); }
        }
        if (trail) { ctx.globalAlpha = .55 * (1 - trail.t / .2); const th = (trail.y1 - trail.y0 + 1) * CELL; for (let i = 0; i < trail.w; i++) ctx.drawImage(TRAIL, (trail.x + i) * CELL, trail.y0 * CELL, CELL, th); ctx.globalAlpha = 1; }
        if (lockFx) { ctx.globalAlpha = .75 * (1 - lockFx.t / .1); for (let i = 0; i < lockFx.n; i += 2) ctx.drawImage(WHITE, LOCKC[i] * CELL, (LOCKC[i + 1] - HID) * CELL); ctx.globalAlpha = 1; }
        if (danger > 0) { ctx.globalAlpha = danger; ctx.drawImage(DANGER, 0, 0); ctx.globalAlpha = 1; }
        fx.draw(ctx);
        if (flashA > 0) { ctx.globalAlpha = flashA; ctx.fillStyle = '#fff'; ctx.fillRect(0, 0, CW, CH); ctx.globalAlpha = 1; }
      };
      const L = Arcade.loop(dt => {
        shaker.step(dt);
        if (dead) { if (fx.count) { fx.step(dt); draw(); } else L.stop(); return; }
        elapsed += dt;
        const sec = elapsed | 0;
        if (sec !== lastSec) { lastSec = sec; if (sprint) A.setScore(sec); if (ultra) { hint(); if (sec >= 120) { dead = true; cur = null; A.sfx('drum'); finish('Tempo esgotado', true); return; } } }
        if (bgT < 1) bgT = Math.min(1, bgT + dt * 1.6);
        if (trail) { trail.t += dt; if (trail.t >= .2) trail = null; }
        if (lockFx) { lockFx.t += dt; if (lockFx.t >= .1) lockFx = null; }
        if (flashA > 0) flashA = Math.max(0, flashA - dt * 3);
        if (fallT > 0) { fallT += dt; if (fallT >= .14) fallT = 0; }
        if (clr) { clr.t += dt; if (clr.t >= .2) afterClear(); }
        else if (cur) {
          acc += dt;
          const iv = gravity();
          while (acc >= iv) { acc -= iv; if (!ground()) { py++; lastRot = false; if (py > lowest) { lowest = py; resets = 0; } } else break; }
          if (ground()) { lockT += dt; if (lockT >= .5) lock(); } else lockT = 0;
        }
        let top = H + HID; for (let y = 0; y < H + HID; y++) { let any = false; for (let x = 0; x < W; x++) if (grid[y][x]) { any = true; break; } if (any) { top = y; break; } }
        danger = top < HID + 5 ? Math.min(1, (HID + 5 - top) / 4) * (.55 + .45 * Math.sin(elapsed * 6)) : 0;
        fx.step(dt);
        draw();
      });
      const start = async () => {
        L.stop();
        grid = []; for (let y = 0; y < H + HID; y++) grid.push(new Array(W).fill(0));
        acc = 0; lines = 0; level = sprint ? 1 : startLv; dead = false; queue = []; holdP = null; holdUsed = false; bag = []; started = false; combo = 0; b2b = false; clr = null; fallT = 0; trail = null; lockFx = null; tspins = 0; tetrises = 0; pieces = 0; elapsed = 0; lastSec = -1; score = 0; danger = 0; flashA = 0; maxCombo = 0; cur = null;
        fx.clear(); shaker.reset(); rec.reset(); bgA = null; bgB = null; bgSwap();
        lnEl.textContent = sprint ? '40' : '0';
        A.setScore(0); hint();
        for (let i = 0; i < 3; i++) queue.push(take());
        spawn(); paintSide(); draw();
        await A.ready('Blocos', sprint ? 'Fecha 40 linhas o mais depressa possível' : ultra ? 'Faz o máximo de pontos em dois minutos' : 'Encaixa as peças e fecha linhas');
        if (A.ended) return;
        await countdown(A, 3);
        if (A.ended || started) return;
        started = true; t0 = Date.now(); L.start();
      };
      start();
      return {
        kill: () => L.stop(),
        pause: () => L.stop(),
        resume: () => { if (started && !dead && !A.paused && !A.ended) L.start(); },
        key(e) {
          const k = e.key;
          if (k === 'ArrowLeft' || k === 'a' || k === 'A') move(-1);
          else if (k === 'ArrowRight' || k === 'd' || k === 'D') move(1);
          else if (k === 'ArrowDown' || k === 's' || k === 'S') soft();
          else if (k === 'ArrowUp' || k === 'w' || k === 'W' || k === 'x' || k === 'X') { if (!e.repeat) rotate(1); }
          else if (k === 'z' || k === 'Z') { if (!e.repeat) rotate(-1); }
          else if (k === ' ') { if (!e.repeat) hard(); }
          else if (k === 'c' || k === 'C' || k === 'Shift') { if (!e.repeat) hold(); }
          else return;
          e.preventDefault();
        },
        dbg: {
          state: () => ({ mode, started, dead, lines, level, score, pieces, combo, tspins, tetrises }),
          fill: n => { for (let y = H + HID - 1; y >= H + HID - (n || 6); y--) for (let x = 0; x < W; x++) grid[y][x] = x === 9 && ((y - HID) % 3 === 0) ? 0 : Object.keys(BL_COL)[(x + y) % 7]; },
          /* uma linha quase cheia na base + peça I vertical na coluna livre = Tetris ao largar */
          tetrisSetup: () => { for (let y = H + HID - 4; y < H + HID; y++) for (let x = 0; x < W - 1; x++) grid[y][x] = Object.keys(BL_COL)[(x + y) % 7]; cur = 'I'; rot = 1; px = 7; py = 2; lastRot = false; },
          hard, move, rotate, hold, soft,
          setLines: n => { lines = n; lnEl.textContent = sprint ? String(Math.max(0, 40 - lines)) : String(lines); },
          setScore: n => { score = n; A.setScore(n); },
          freeze: () => L.stop(),
          end: () => { if (started) { dead = true; cur = null; finish('Sem espaço', false); } },
          sprintDone: () => { if (started) { lines = 40; finishSprint(); } },
        },
      };
    };
    let m0 = Arcade.opt('blocks:mode', 'marathon'); if (!/^(marathon|sprint|ultra)$/.test(m0)) m0 = 'marathon';
    boot(m0);
    win.onClose = kill;
    return { pause: () => G && G.pause(), resume: () => G && G.resume(), key: e => G && G.key(e), get dbg() { return G && G.dbg; }, reboot: boot };
  },
});


/* =====================================================================
   4. MINAS: bisel moderno, bandeira e mina em SVG, toque longo, acorde, onda de vitória, rebentar em cadeia
   ===================================================================== */
const MN_DEFS = `<svg width="0" height="0" class="mn-defs" aria-hidden="true"><defs><linearGradient id="mnF" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FF7A6E"/><stop offset="1" stop-color="#E0271B"/></linearGradient><radialGradient id="mnM" cx=".35" cy=".3" r=".8"><stop offset="0" stop-color="#6E717C"/><stop offset=".55" stop-color="#2A2C33"/><stop offset="1" stop-color="#0E0F12"/></radialGradient></defs></svg>`;
const MN_FLAG = '<svg viewBox="0 0 24 24" class="mn-flag"><ellipse cx="8" cy="21.4" rx="5" ry="1.5" fill="#000" opacity=".35"/><path d="M7 21V3" stroke="#E3E5EC" stroke-width="2.4" stroke-linecap="round"/><path d="M7 3.5h11.5l-3.4 4.5 3.4 4.5H7z" fill="url(#mnF)"/><path d="M7 3.5h11.5l-3.4 4.5" fill="none" stroke="#fff" stroke-opacity=".35" stroke-width="1"/></svg>';
const MN_MINE = '<svg viewBox="0 0 24 24" class="mn-mine"><g stroke="#1A1B20" stroke-width="2.4" stroke-linecap="round"><path d="M12 2v4M12 18v4M2 12h4M18 12h4M5 5l2.8 2.8M16.2 16.2 19 19M19 5l-2.8 2.8M7.8 16.2 5 19"/></g><circle cx="12" cy="12" r="6.6" fill="url(#mnM)"/><circle cx="9.6" cy="9.4" r="1.7" fill="#fff" opacity=".8"/></svg>';
const mnGrain = () => pre(56, 56, c => { c.fillStyle = 'rgba(255,255,255,.045)'; for (let i = 0; i < 260; i++) c.fillRect(Math.random() * 56, Math.random() * 56, 1.2, 1.2); c.fillStyle = 'rgba(0,0,0,.08)'; for (let i = 0; i < 180; i++) c.fillRect(Math.random() * 56, Math.random() * 56, 1.2, 1.2); }).toDataURL();
const mnCellSvg = (x, y, s, open, id) => open ? `<rect x="${x}" y="${y}" width="${s}" height="${s}" rx="${s * .18}" fill="#141720"/>` : `<rect x="${x}" y="${y + 1.5}" width="${s}" height="${s}" rx="${s * .18}" fill="#000" opacity=".4"/><rect x="${x}" y="${y}" width="${s}" height="${s}" rx="${s * .18}" fill="url(#${id})"/><rect x="${x + 1}" y="${y + 1}" width="${s - 2}" height="${s * .42}" rx="${s * .15}" fill="#fff" opacity=".12"/>`;
/* ícone: 3×3 casas grandes: fechadas em relevo, abertas com números, uma bandeira e a mina na casa vermelha */
Icons.app.mines = () => {
  const s = 24, g0 = 3, o = 13, at = (c, r) => [o + c * (s + g0), o + r * (s + g0)];
  const plan = [['c', '1', 'f'], ['1', '2', 'c'], ['o', '1', 'm']];
  const NUM = { 1: '#6CB8FF', 2: '#3BE36B' };
  let out = '';
  plan.forEach((row, r) => row.forEach((k, c) => {
    const p = at(c, r);
    if (k === 'm') out += `<rect x="${p[0]}" y="${p[1] + 1.5}" width="${s}" height="${s}" rx="5" fill="#000" opacity=".4"/><rect x="${p[0]}" y="${p[1]}" width="${s}" height="${s}" rx="5" fill="url(#gMiR)"/><g transform="translate(${p[0] + 1} ${p[1] + 1}) scale(.92)">${MN_MINE.replace(/<\/?svg[^>]*>/g, '')}</g>`;
    else out += mnCellSvg(p[0], p[1], s, k !== 'c' && k !== 'f', 'gMiC');
    if (NUM[k]) out += `<text x="${p[0] + s / 2}" y="${p[1] + s / 2 + 1}" text-anchor="middle" dominant-baseline="central" font-family="Inter, system-ui, sans-serif" font-weight="800" font-size="15" fill="${NUM[k]}">${k}</text>`;
    if (k === 'f') out += `<g transform="translate(${p[0] + 1} ${p[1] + 1}) scale(.92)">${MN_FLAG.replace(/<\/?svg[^>]*>/g, '')}</g>`;
  }));
  return Icons.SVG(Icons.G('gMi', '#59607A', '#373C50', '#1F222D') + `<defs><linearGradient id="gMiC" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#A3AABE"/><stop offset="1" stop-color="#626A80"/></linearGradient><linearGradient id="gMiR" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FF7A6E"/><stop offset="1" stop-color="#D4261A"/></linearGradient>${MN_DEFS.replace(/<\/?svg[^>]*>/g, '')}</defs>` + out);
};

Arcade.game('mines', {
  name: 'Minas', color: '#8E8E93', kind: 'puzzle', lowerIsBetter: true, unit: 'segundos', scoreLabel: 'Tempo', bestLabel: 'Melhor', tags: ['Lógica', 'Clássico'],
  variants: [{ key: 'facil', label: 'Fácil' }, { key: 'medio', label: 'Médio' }, { key: 'dificil', label: 'Difícil' }],
  desc: 'Descobre o campo sem tocar numa mina. Bisel moderno, toque longo para a bandeira, acorde nos números, três tamanhos e tempo por nível.',
  cover: () => {
    let cells = ''; const s = 22, open = {};
    [[3, 1], [4, 1], [5, 1], [3, 2], [4, 2], [5, 2], [6, 2], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [3, 4], [4, 4], [5, 4], [6, 4], [4, 5], [5, 5]].forEach(o => { open[o[0] + ',' + o[1]] = 1; });
    for (let r = 0; r < 8; r++) for (let c = 0; c < 17; c++) cells += mnCellSvg(6 + c * (s + 1), 8 + r * (s + 1), s, !!open[c + ',' + r], 'cMiC');
    const num = (c, r, n, col) => `<text x="${6 + c * (s + 1) + s / 2}" y="${8 + r * (s + 1) + s / 2}" text-anchor="middle" dominant-baseline="central" font-family="Inter, system-ui, sans-serif" font-weight="800" font-size="14" fill="${col}">${n}</text>`;
    return `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="cMi" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#2A2E3A"/><stop offset="1" stop-color="#121419"/></linearGradient><linearGradient id="cMiC" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#8E95A8"/><stop offset="1" stop-color="#545B6E"/></linearGradient>${MN_DEFS.replace(/<\/?svg[^>]*>/g, '')}</defs><rect width="400" height="200" fill="url(#cMi)"/>${cells}` +
      num(3, 1, 1, '#6CB8FF') + num(5, 1, 1, '#6CB8FF') + num(3, 2, 2, '#30D158') + num(6, 2, 1, '#6CB8FF') + num(2, 3, 1, '#6CB8FF') + num(7, 3, 3, '#FF9F0A') + num(3, 4, 1, '#6CB8FF') + num(6, 4, 2, '#30D158') + num(4, 5, 1, '#6CB8FF') +
      `<g transform="translate(${6 + 10 * 23 + 2} ${8 + 4 * 23 + 2}) scale(.78)">${MN_FLAG.replace(/<\/?svg[^>]*>/g, '')}</g><g transform="translate(${6 + 13 * 23 + 2} ${8 + 1 * 23 + 2}) scale(.78)">${MN_FLAG.replace(/<\/?svg[^>]*>/g, '')}</g><g transform="translate(${6 + 12 * 23 + 1} ${8 + 6 * 23 + 1}) scale(.85)">${MN_MINE.replace(/<\/?svg[^>]*>/g, '')}</g></svg>`;
  },
  howto: { goal: 'Abre todas as casas sem minas no menor tempo.', steps: ['Cada número diz quantas minas há nas oito casas à volta', 'Marca com bandeira as casas de que tens a certeza', 'Toca num número com as bandeiras certas para abrir o que falta à volta'], controls: [{ icon: 'hand', label: 'Toque abre, toque longo marca a bandeira' }, { icon: 'gamepad', label: 'Setas, Enter abre, F marca' }] },
  build(win) {
    const LV = { facil: { n: 9, m: 10, label: 'Fácil' }, medio: { n: 12, m: 22, label: 'Médio' }, dificil: { n: 14, m: 38, label: 'Difícil' } };
    let lvKey = 'facil';
    { const s = Arcade.opt('mines:lv', ''); if (s && LV[s]) lvKey = s; }
    const A = Arcade.shell(win, {
      id: 'mines:' + lvKey, name: 'Minas', color: '#8E8E93', pausable: false,
      scoreLabel: 'Tempo', bestLabel: 'Melhor', lowerIsBetter: true, unit: 'segundos', onRestart: () => start(true),
    });
    const wrap = UI.el('<div class="mn-wrap"></div>');
    const board = UI.el('<div class="mn-board"></div>');
    wrap.appendChild(UI.el(MN_DEFS)); wrap.appendChild(board);
    A.el.stage.appendChild(wrap);
    board.style.setProperty('--mn-grain', 'url(' + mnGrain() + ')');
    A.el.ctl.innerHTML = `<div class="gm-row wide">${Arcade.btn('flag', 'flag', 19)}<div class="gb lbl mode"><span>Modo bandeira</span></div></div>`;
    A.options([{ key: 'lv', label: 'Dificuldade', values: Object.keys(LV).map(k => ({ v: k, label: LV[k].label })), cur: lvKey, onChange: v => { lvKey = v; Arcade.setOpt('mines:lv', v); start(true); } }]);

    let N, MINES, cells, opened, flags, dead, won, t0, timer = null, started, flagMode = false, cur = -1, ready = false, usedFlag = false, rec = null, gen = 0;
    const around = i => {
      const r = (i / N) | 0, c = i % N, out = [];
      for (let dr = -1; dr <= 1; dr++) for (let dc = -1; dc <= 1; dc++) {
        if (!dr && !dc) continue;
        const nr = r + dr, nc = c + dc;
        if (nr >= 0 && nc >= 0 && nr < N && nc < N) out.push(nr * N + nc);
      }
      return out;
    };
    const build = first => {
      const safe = around(first).concat([first]);
      let placed = 0;
      while (placed < MINES) {
        const i = (Math.random() * N * N) | 0;
        if (cells[i].mine || safe.indexOf(i) > -1) continue;
        cells[i].mine = true; placed++;
      }
      cells.forEach((c, i) => { if (!c.mine) c.n = around(i).filter(j => cells[j].mine).length; });
    };
    let hitMine = -1;
    const dig = i => {
      const c = cells[i];
      if (c.open || c.flag || dead || won) return;
      c.open = true; opened++;
      if (c.mine) { dead = true; hitMine = i; stopT(); return; }
      if (c.n === 0) around(i).forEach(dig);
    };
    const secsNow = () => Math.max(1, ((Date.now() - t0) / 1000) | 0);
    const stats = secs => [{ label: 'Tempo', value: mmss(secs) }, { label: 'Casas abertas', value: String(opened) }, { label: 'Bandeiras', value: String(flags) }, { label: 'Minas', value: String(MINES) }];
    const settle = () => {
      if (dead) { boom(); return; }
      if (opened === N * N - MINES) {
        won = true; stopT();
        const secs = secsNow();
        A.setScore(secs); paint();
        cells.forEach((c, i) => { if (c.mine && !c.flag) { c.flag = true; } });
        paint();
        /* onda: as casas saltam por ordem de distância ao último toque */
        const r0 = cur >= 0 ? (cur / N) | 0 : 0, c0 = cur >= 0 ? cur % N : 0;
        els.forEach((d, i) => { d.style.animationDelay = (Math.abs(((i / N) | 0) - r0) + Math.abs((i % N) - c0)) * 32 + 'ms'; });
        board.classList.add('win');
        if (!usedFlag) Arcade.flag('minesNoFlag');
        A.flash('Campo limpo!', 'big'); A.sfx('win'); celebrate(A, 'win');
        const myGen = gen;
        const t = setTimeout(() => { if (myGen !== gen) return; A.end({ title: 'Campo limpo!', sub: `${mmss(secs)} · ${LV[lvKey].label}`, score: secs, win: true, stats: stats(secs) }); }, 900); win.timers.push(t);
        return;
      }
      A.sfx('tick'); paint();
    };
    /* derrota: as minas rebentam em sequência a partir da que foi pisada, com abanão */
    const boom = () => {
      paint(); A.haptic('heavy'); A.sfx('explode'); board.classList.add('boom');
      const r0 = (hitMine / N) | 0, c0 = hitMine % N;
      const list = []; cells.forEach((c, i) => { if (c.mine && !c.flag) list.push(i); });
      list.sort((a, b) => (Math.abs(((a / N) | 0) - r0) + Math.abs((a % N) - c0)) - (Math.abs(((b / N) | 0) - r0) + Math.abs((b % N) - c0)));
      const myGen = gen, secs = secsNow();
      list.forEach((i, k) => {
        const t = setTimeout(() => { if (myGen !== gen) return; cells[i].open = true; const d = els[i]; d.className = 'mn-c op bomb pop'; d.innerHTML = MN_MINE; if (k % 3 === 2) { A.sfx('explode'); A.haptic(k % 6 === 5 ? 'medium' : 'light'); } }, 70 + k * 55); win.timers.push(t);
      });
      /* bandeiras erradas */
      cells.forEach((c, i) => { if (c.flag && !c.mine) els[i].classList.add('wrong'); });
      const t = setTimeout(() => { if (myGen !== gen) return; board.classList.remove('boom'); A.end({ title: 'Boom', sub: `Abriste ${opened} casas`, score: null, submit: false, stats: stats(secs) }); }, 70 + list.length * 55 + 500); win.timers.push(t);
    };
    const open = i => { if (dead || won || !ready) return; const c = cells[i]; if (!c || c.open || c.flag) return; if (!started) { build(i); started = true; t0 = Date.now(); startT(); A.sfx('pop'); } dig(i); settle(); };
    const chord = i => {
      const c = cells[i];
      if (!c.open || !c.n || dead || won) return;
      const ns = around(i);
      if (ns.filter(j => cells[j].flag).length !== c.n) { A.haptic('light'); return; }
      ns.forEach(j => { if (!cells[j].flag) dig(j); });
      settle();
    };
    const flag = i => {
      const c = cells[i];
      if (c.open || dead || won || !ready || !started) { if (!started && ready && !c.open) { usedFlag = true; c.flag = !c.flag; flags += c.flag ? 1 : -1; mid(); A.sfx('place'); paint(); } return; }
      c.flag = !c.flag; flags += c.flag ? 1 : -1; usedFlag = true;
      mid(); A.sfx(c.flag ? 'place' : 'swish'); paint();
    };
    const mid = () => A.setMid(`<span class="gm-hint">${g('flag', 18)} <b>${MINES - flags}</b></span>`);

    let els = [];
    const cellCls = (c, i) => 'mn-c' + (c.open ? ' op' : '') + (c.flag ? ' fl' : '') + (c.open && c.mine ? ' bomb' : '') + (i === cur ? ' cur' : '');
    const cellHtml = c => (c.open ? (c.mine ? MN_MINE : String(c.n || '')) : (c.flag ? MN_FLAG : ''));
    /* o clique que vem depois de um toque longo NÃO pode abrir a casa (o stopPropagation do UI.longPress não trava o
       onclick do próprio elemento): guarda-se a casa e a hora do toque longo e esse clique ignora-se */
    let lpI = -1, lpT = 0;
    const tap = i => {
      if (dead || won || !ready) return;
      if (i === lpI && performance.now() - lpT < 900) { lpI = -1; return; }
      cur = i;
      if (cells[i].open) { chord(i); return; }
      if (flagMode) flag(i); else open(i);
    };
    const buildBoard = () => {
      const frag = document.createDocumentFragment(); els = [];
      cells.forEach((c, i) => {
        const d = UI.el('<div class="mn-c"></div>');
        d.onclick = () => tap(i);
        UI.longPress(d, () => { if (dead || won || !ready) return; lpI = i; lpT = performance.now(); cur = i; if (cells[i].open) chord(i); else flag(i); });
        els.push(d); frag.appendChild(d);
      });
      board.innerHTML = ''; board.appendChild(frag);
      board.classList.remove('win', 'boom');
    };
    const paint = () => {
      cells.forEach((c, i) => {
        const d = els[i], cls = cellCls(c, i), h = cellHtml(c);
        if (d.className !== cls) d.className = cls;
        if (d.dataset.n !== String(c.n)) d.dataset.n = c.n;
        if (d._h !== h) { d._h = h; d.innerHTML = h; }
      });
    };
    const startT = () => { stopT(); timer = setInterval(() => { if (!dead && !won) A.setScore(((Date.now() - t0) / 1000) | 0); }, 1000); win.timers.push(timer); };
    const stopT = () => { clearInterval(timer); timer = null; };

    const start = async skipReady => {
      gen++;
      const L = LV[lvKey]; N = L.n; MINES = L.m;
      A.setId('mines:' + lvKey);
      const cell = Math.floor((376 - 3 * (N - 1)) / N);
      board.style.setProperty('--mn-n', N); board.style.setProperty('--mn-cell', cell + 'px'); board.dataset.lv = lvKey;
      cells = new Array(N * N).fill(0).map(() => ({ mine: false, n: 0, open: false, flag: false }));
      opened = 0; flags = 0; dead = false; won = false; started = false; t0 = Date.now(); cur = -1; usedFlag = false; hitMine = -1; stopT();
      A.setScore(0); mid(); buildBoard(); paint();
      A.el.ctl.querySelector('.gb.flag').classList.toggle('on', flagMode);
      if (!skipReady) { ready = false; await A.ready('Minas', 'Abre as casas sem tocar numa mina. Toque longo põe bandeira'); if (A.ended) return; }
      ready = true;
    };
    const toggleFlag = () => { flagMode = !flagMode; A.el.ctl.querySelector('.gb.flag').classList.toggle('on', flagMode); A.sfx('tick'); };
    A.el.ctl.querySelector('.gb.flag').onclick = toggleFlag;
    A.el.ctl.querySelector('.mode').onclick = toggleFlag;
    start();
    win.onClose = stopT;
    return {
      pause: stopT, resume: () => { if (started && !dead && !won) startT(); },
      key(e) {
        if (dead || won || !ready) return;
        const d = Arcade.keyDir(e);
        if (d) { e.preventDefault(); const prev = cur; if (cur < 0) cur = 0; else { let r = (cur / N) | 0, c = cur % N; if (d === 'u') r = (r + N - 1) % N; if (d === 'd') r = (r + 1) % N; if (d === 'l') c = (c + N - 1) % N; if (d === 'r') c = (c + 1) % N; cur = r * N + c; } if (prev >= 0 && els[prev]) els[prev].classList.remove('cur'); if (els[cur]) els[cur].classList.add('cur'); return; }
        if (cur < 0) return;
        if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); if (cells[cur].open) chord(cur); else open(cur); }
        else if (e.key === 'f' || e.key === 'F') { e.preventDefault(); flag(cur); }
      },
      dbg: { open, flag, chord, state: () => ({ N, MINES, opened, flags, dead, won, started, lv: lvKey }), boom: () => { if (!ready) return; if (!started) open(0); const m = cells.findIndex(c => c.mine && !c.open && !c.flag); if (m >= 0) { cur = m; dig(m); settle(); } }, win: () => { if (!ready) return; if (!started) open(0); cells.forEach(c => { if (!c.mine && !c.open) { c.open = true; opened++; } }); settle(); } },
    };
  },
});


/* =====================================================================
   5. BREAK (Breakout): néon de arcada, tijolos vidrados com bisel e fissuras, aço, bola com rasto,
   raquete vidrada, oito bónus em cápsulas, doze níveis (alguns a mover), combos, câmara lenta no último tijolo
   ===================================================================== */
const BK_COLS = ['#FF3B6B', '#FF8A2B', '#FFD21F', '#3BE36B', '#2BD4FF', '#7A5CFF', '#FF5CE1', '#2BFFC8'];
const BK_INV = ['..X..X..', '.XXXXXX.', 'XX.XX.XX', 'XXXXXXXX', 'X.XXXX.X', '..X..X..'];
const BK_LEVELS = [
  { rows: 4, hp: () => 1 },
  { rows: 5, hp: (r, c) => ((r + c) % 2 ? 1 : 0) },
  { rows: 5, hp: (r, c) => (Math.abs(c - 3.5) <= r + .5 ? (r === 4 ? 2 : 1) : 0) },
  { rows: 6, hp: (r, c) => (r === 0 ? (c % 2 ? 9 : 1) : (c % 2 === 0 ? (r > 3 ? 2 : 1) : 0)) },
  { rows: 7, hp: (r, c) => { const d = Math.abs(c - 3.5) + Math.abs(r - 3); return d <= 3.5 ? (d < 1.5 ? 3 : d < 2.5 ? 2 : 1) : 0; } },
  { rows: 6, hp: (r, c) => (r % 2 ? (c > 0 ? 1 : 0) : (c < 7 ? 1 : 0)), move: [1, 3, 5] },
  { rows: 6, hp: (r, c) => (r === 0 || (c === 0 && r < 5) || (c === 7 && r < 5) ? 9 : (r >= 2 && r <= 3 && c >= 3 && c <= 4 ? 3 : (r === 5 ? 1 : 2))) },
  { rows: 7, hp: (r, c) => (c % 3 === 1 ? 0 : (r < 2 ? 2 : 1)), move: [0, 2, 4, 6] },
  { rows: 7, hp: (r, c) => { const d = Math.max(Math.abs(c - 3.5) - .5, Math.abs(r - 3)); return d === 3 ? 1 : d === 2 ? 2 : d === 1 ? 3 : 0; } },
  { rows: 6, hp: (r, c) => (BK_INV[r][c] === 'X' ? (r === 3 ? 2 : 1) : 0) },
  { rows: 7, hp: (r, c) => (r % 2 === 0 ? (c % 2 === 0 ? 9 : 1) : 2), move: [1, 5] },
  { rows: 8, hp: (r, c) => (c === 0 || c === 7 ? (r < 6 ? 9 : 1) : r < 2 ? 3 : r < 5 ? 2 : 1), move: [7] },
];
const BK_BONUS = ['wide', 'narrow', 'multi', 'slow', 'laser', 'sticky', 'life', 'fire'];
const BK_BCOL = { wide: '#30D158', narrow: '#FF453A', multi: '#7A5CFF', slow: '#2BD4FF', laser: '#FF5CE1', sticky: '#A6F03A', life: '#FF375F', fire: '#FF8A2B' };
const BK_BNAME = { wide: 'Raquete larga', narrow: 'Raquete estreita', multi: 'Multibola', slow: 'Bola lenta', laser: 'Laser', sticky: 'Pegajosa', life: 'Vida extra', fire: 'Bola de fogo' };
const bkBrickSvg = (x, y, w, h, col, id) => `<defs><linearGradient id="${id}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${shade(col, .35)}"/><stop offset=".5" stop-color="${col}"/><stop offset="1" stop-color="${shade(col, -.35)}"/></linearGradient></defs><rect x="${x - 2}" y="${y - 2}" width="${w + 4}" height="${h + 4}" rx="4" fill="${col}" opacity=".35"/><rect x="${x}" y="${y}" width="${w}" height="${h}" rx="3" fill="url(#${id})"/><rect x="${x + 1.5}" y="${y + 1.5}" width="${w - 3}" height="${h * .35}" rx="2" fill="#fff" opacity=".35"/>`;
Icons.app.brick = () => Icons.SVG(Icons.G('gBr', '#1A2150', '#0C1030', '#06081A') +
  `<defs><radialGradient id="gBrB" cx=".35" cy=".3" r=".8"><stop offset="0" stop-color="#fff"/><stop offset=".5" stop-color="#CFF2FF"/><stop offset="1" stop-color="#3AA8E6"/></radialGradient><linearGradient id="gBrP" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#F4FBFF"/><stop offset="1" stop-color="#8ED4FF"/></linearGradient></defs>` +
  `<circle cx="50" cy="60" r="18" fill="#2BD4FF" opacity=".18"/>` +
  bkBrickSvg(12, 16, 22, 10, '#FF3B6B', 'bA') + bkBrickSvg(39, 16, 22, 10, '#FF8A2B', 'bB') + bkBrickSvg(66, 16, 22, 10, '#FFD21F', 'bC') +
  bkBrickSvg(25, 31, 22, 10, '#3BE36B', 'bD') + bkBrickSvg(52, 31, 22, 10, '#7A5CFF', 'bE') +
  `<circle cx="50" cy="60" r="7" fill="url(#gBrB)"/><rect x="30" y="78" width="40" height="8" rx="4" fill="#2BD4FF" opacity=".4"/><rect x="31" y="77" width="38" height="7" rx="3.5" fill="url(#gBrP)"/>`);

Arcade.game('brick', {
  name: 'Break', color: '#0A84FF', kind: 'action', board: 'breakout', tags: ['Arcada', 'Reflexos'],
  desc: 'Breakout néon de arcada: tijolos vidrados, aço, bola com rasto, oito bónus em cápsulas, doze níveis com padrões próprios, combos e câmara lenta no último tijolo.',
  cover: () => {
    let t = ''; const pat = BK_LEVELS[4]; let k = 0;
    for (let r = 0; r < 7; r++) for (let c = 0; c < 8; c++) { const hp = pat.hp(r, c); if (!hp) continue; t += bkBrickSvg(126 + c * 20, 14 + r * 13, 17, 9, BK_COLS[r % 8], 'cB' + (k++)); }
    return `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="cBr" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0C1238"/><stop offset="1" stop-color="#05071A"/></linearGradient><radialGradient id="cBrB" cx=".35" cy=".3" r=".8"><stop offset="0" stop-color="#fff"/><stop offset=".5" stop-color="#CFF2FF"/><stop offset="1" stop-color="#3AA8E6"/></radialGradient><radialGradient id="cBrG" cx=".5" cy=".5" r=".5"><stop offset="0" stop-color="#2BD4FF" stop-opacity=".6"/><stop offset="1" stop-color="#2BD4FF" stop-opacity="0"/></radialGradient></defs><rect width="400" height="200" fill="url(#cBr)"/><g opacity=".08" stroke="#fff">${[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].map(i => `<path d="M${i * 30} 0v200"/>`).join('')}${[0, 1, 2, 3, 4, 5, 6].map(i => `<path d="M0 ${i * 30}h400"/>`).join('')}</g>` +
      `<circle cx="60" cy="40" r="1.5" fill="#fff" opacity=".6"/><circle cx="340" cy="70" r="1.2" fill="#fff" opacity=".5"/><circle cx="30" cy="150" r="1.6" fill="#fff" opacity=".4"/><circle cx="370" cy="160" r="1.2" fill="#fff" opacity=".6"/><circle cx="90" cy="120" r="1" fill="#fff" opacity=".5"/>${t}` +
      `<path d="M212 140 L228 110 L252 86" stroke="#2BD4FF" stroke-width="3" fill="none" opacity=".35" stroke-linecap="round"/><circle cx="212" cy="140" r="26" fill="url(#cBrG)"/><circle cx="212" cy="140" r="8" fill="url(#cBrB)"/>` +
      `<rect x="172" y="176" width="80" height="12" rx="6" fill="#2BD4FF" opacity=".35"/><rect x="174" y="175" width="76" height="10" rx="5" fill="#E8F7FF"/><circle cx="182" cy="180" r="2" fill="#2BD4FF"/><circle cx="242" cy="180" r="2" fill="#2BD4FF"/></svg>`;
  },
  howto: { goal: 'Parte todos os tijolos sem deixar cair a bola.', steps: ['A bola sai da raquete com o ângulo do sítio onde bate', 'Tijolos com fissuras precisam de mais pancadas; os de aço não partem', 'Apanha as cápsulas que caem: umas ajudam, a vermelha encolhe a raquete'], controls: [{ icon: 'hand', label: 'Arrasta para mover, toca para lançar ou disparar' }, { icon: 'gamepad', label: 'Setas movem, Espaço lança' }] },
  build(win) {
    const W = 390, H = 580, PY = H - 36, COLS = 8, BW = 42, BH = 18, GAP = 4, MX = (W - (COLS * BW + (COLS - 1) * GAP)) / 2, TOP = 54;
    const A = Arcade.shell(win, {
      id: 'breakout', name: 'Break', color: '#0A84FF',
      onRestart: () => start(), onPause: () => L.stop(), onResume: () => { if (started0 && !dead) L.start(); },
    });
    const cv = UI.el(`<canvas class="gm-cv bk-cv" width="${W}" height="${H}"></canvas>`);
    A.el.stage.appendChild(cv);
    const ctx = cv.getContext('2d');
    const fx = Fx(220), shaker = Shaker(cv), rec = recordWatch(A, 'breakout');

    /* ---- sprites ---- */
    const BG = pre(W, H, c => {
      const gr = c.createLinearGradient(0, 0, 0, H); gr.addColorStop(0, '#0A1030'); gr.addColorStop(1, '#05071A'); c.fillStyle = gr; c.fillRect(0, 0, W, H);
      const n1 = c.createRadialGradient(80, 420, 10, 80, 420, 260); n1.addColorStop(0, 'rgba(122,92,255,.22)'); n1.addColorStop(1, 'rgba(122,92,255,0)'); c.fillStyle = n1; c.fillRect(0, 0, W, H);
      const n2 = c.createRadialGradient(330, 160, 10, 330, 160, 220); n2.addColorStop(0, 'rgba(43,212,255,.14)'); n2.addColorStop(1, 'rgba(43,212,255,0)'); c.fillStyle = n2; c.fillRect(0, 0, W, H);
      c.strokeStyle = 'rgba(255,255,255,.045)'; c.lineWidth = 1;
      for (let x = 30; x < W; x += 30) { c.beginPath(); c.moveTo(x + .5, 0); c.lineTo(x + .5, H); c.stroke(); }
      for (let y = 30; y < H; y += 30) { c.beginPath(); c.moveTo(0, y + .5); c.lineTo(W, y + .5); c.stroke(); }
      for (let i = 0; i < 90; i++) { c.fillStyle = 'rgba(255,255,255,' + (.15 + Math.random() * .55).toFixed(2) + ')'; const s = Math.random() < .2 ? 2 : 1.2; c.fillRect(Math.random() * W, Math.random() * H, s, s); }
      const wall = (x0, x1) => { const w = c.createLinearGradient(x0, 0, x1, 0); w.addColorStop(0, 'rgba(43,212,255,.5)'); w.addColorStop(1, 'rgba(43,212,255,0)'); c.fillStyle = w; c.fillRect(Math.min(x0, x1), 0, Math.abs(x1 - x0), H); };
      wall(0, 10); wall(W, W - 10);
      const tw = c.createLinearGradient(0, 0, 0, 10); tw.addColorStop(0, 'rgba(43,212,255,.5)'); tw.addColorStop(1, 'rgba(43,212,255,0)'); c.fillStyle = tw; c.fillRect(0, 0, W, 10);
      c.fillStyle = '#9FEBFF'; c.fillRect(0, 0, W, 1.5); c.fillRect(0, 0, 1.5, H); c.fillRect(W - 1.5, 0, 1.5, H);
    });
    const brickCache = new Map();
    const brick = (col, hp, max) => {
      const key = col + '|' + hp + '|' + max; let c = brickCache.get(key); if (c) return c;
      c = pre(BW + 6, BH + 8, x => {
        const ox = 3, oy = 2;
        if (max === 9) {
          const gr = x.createLinearGradient(0, oy, 0, oy + BH); gr.addColorStop(0, '#C9CDD8'); gr.addColorStop(.45, '#8A8F9E'); gr.addColorStop(.55, '#6E7384'); gr.addColorStop(1, '#4A4E5C');
          x.fillStyle = gr; rrp(x, ox, oy, BW, BH, 3); x.fill();
          x.strokeStyle = 'rgba(255,255,255,.35)'; x.lineWidth = 1; x.beginPath(); x.moveTo(ox + 2, oy + 1.5); x.lineTo(ox + BW - 2, oy + 1.5); x.stroke();
          x.strokeStyle = 'rgba(0,0,0,.5)'; x.beginPath(); x.moveTo(ox + 2, oy + BH - 1); x.lineTo(ox + BW - 2, oy + BH - 1); x.stroke();
          x.fillStyle = '#3A3E4A'; [[6, 5], [BW - 6, 5], [6, BH - 5], [BW - 6, BH - 5]].forEach(p => { x.beginPath(); x.arc(ox + p[0], oy + p[1], 1.6, 0, TAU); x.fill(); });
          x.fillStyle = 'rgba(255,255,255,.5)'; [[6, 5], [BW - 6, 5], [6, BH - 5], [BW - 6, BH - 5]].forEach(p => { x.beginPath(); x.arc(ox + p[0] - .5, oy + p[1] - .5, .7, 0, TAU); x.fill(); });
          x.fillStyle = 'rgba(255,255,255,.12)'; x.beginPath(); x.moveTo(ox + 14, oy); x.lineTo(ox + 24, oy); x.lineTo(ox + 10, oy + BH); x.lineTo(ox, oy + BH); x.closePath(); x.fill();
          x.strokeStyle = 'rgba(0,0,0,.45)'; x.lineWidth = 1; rrp(x, ox + .5, oy + .5, BW - 1, BH - 1, 3); x.stroke();
          return;
        }
        /* halo néon por baixo */
        x.fillStyle = rgba(col, .28); rrp(x, ox - 3, oy - 2, BW + 6, BH + 6, 5); x.fill();
        const gr = x.createLinearGradient(0, oy, 0, oy + BH); gr.addColorStop(0, shade(col, .38)); gr.addColorStop(.48, col); gr.addColorStop(.52, shade(col, -.08)); gr.addColorStop(1, shade(col, -.38));
        x.fillStyle = gr; rrp(x, ox, oy, BW, BH, 3); x.fill();
        x.fillStyle = 'rgba(255,255,255,.4)'; rrp(x, ox + 1.5, oy + 1.5, BW - 3, BH * .36, 2); x.fill();
        x.fillStyle = 'rgba(0,0,0,.28)'; x.fillRect(ox + 1.5, oy + BH - 2.5, BW - 3, 1.5);
        if (max >= 2) { x.strokeStyle = 'rgba(255,255,255,.55)'; x.lineWidth = 1; rrp(x, ox + 3.5, oy + 3.5, BW - 7, BH - 7, 2); x.stroke(); }
        if (max >= 3) { x.strokeStyle = 'rgba(255,255,255,.35)'; rrp(x, ox + 6.5, oy + 6.5, BW - 13, BH - 13, 1.5); x.stroke(); }
        x.strokeStyle = 'rgba(0,0,0,.38)'; x.lineWidth = 1; rrp(x, ox + .5, oy + .5, BW - 1, BH - 1, 3); x.stroke();
        const dmg = max - hp;
        if (dmg >= 1) { x.strokeStyle = 'rgba(0,0,0,.65)'; x.lineWidth = 1.3; x.lineCap = 'round'; x.beginPath(); x.moveTo(ox + BW * .3, oy + 1); x.lineTo(ox + BW * .42, oy + BH * .45); x.lineTo(ox + BW * .36, oy + BH * .7); x.lineTo(ox + BW * .48, oy + BH - 1); x.stroke(); x.beginPath(); x.moveTo(ox + BW * .42, oy + BH * .45); x.lineTo(ox + BW * .56, oy + BH * .5); x.stroke(); }
        if (dmg >= 2) { x.strokeStyle = 'rgba(0,0,0,.65)'; x.beginPath(); x.moveTo(ox + BW * .72, oy + 1); x.lineTo(ox + BW * .64, oy + BH * .4); x.lineTo(ox + BW * .78, oy + BH * .62); x.lineTo(ox + BW * .7, oy + BH - 1); x.stroke(); x.beginPath(); x.moveTo(ox + BW * .64, oy + BH * .4); x.lineTo(ox + BW * .5, oy + BH * .3); x.stroke(); x.beginPath(); x.moveTo(ox + BW * .12, oy + BH * .35); x.lineTo(ox + BW * .24, oy + BH * .55); x.lineTo(ox + BW * .18, oy + BH * .85); x.stroke(); }
      });
      brickCache.set(key, c); return c;
    };
    const BALL = ball('#FFFFFF', 6), BGLOW = glow('#8FD8FF', 10), FBALL = ball('#FFB020', 6), FGLOW = glow('#FF7A00', 13), LGLOW = glow('#FF5CE1', 6);
    const padCache = new Map();
    const paddle = w => {
      let c = padCache.get(w); if (c) return c;
      const h = 12;
      c = pre(w + 12, h + 14, x => {
        const ox = 6, oy = 4;
        x.fillStyle = 'rgba(43,212,255,.35)'; rrp(x, ox - 4, oy - 3, w + 8, h + 6, 9); x.fill();
        const gr = x.createLinearGradient(0, oy, 0, oy + h); gr.addColorStop(0, '#FFFFFF'); gr.addColorStop(.5, '#D9F3FF'); gr.addColorStop(.52, '#A9DFFB'); gr.addColorStop(1, '#5FB6E6');
        x.fillStyle = gr; rrp(x, ox, oy, w, h, 6); x.fill();
        x.fillStyle = 'rgba(255,255,255,.7)'; rrp(x, ox + 3, oy + 1.5, w - 6, 3.5, 2); x.fill();
        x.strokeStyle = 'rgba(0,60,110,.45)'; x.lineWidth = 1; rrp(x, ox + .5, oy + .5, w - 1, h - 1, 6); x.stroke();
        x.fillStyle = '#1E9BE0'; [ox + 7, ox + w - 7, ox + w / 2].forEach(px => { x.beginPath(); x.arc(px, oy + h / 2 + 1, 2, 0, TAU); x.fill(); });
        x.fillStyle = 'rgba(255,255,255,.9)'; [ox + 7, ox + w - 7, ox + w / 2].forEach(px => { x.beginPath(); x.arc(px - .6, oy + h / 2 + .4, .8, 0, TAU); x.fill(); });
      });
      padCache.set(w, c); return c;
    };
    const TURRET = pre(10, 10, c => { c.fillStyle = '#FF5CE1'; rrp(c, 2, 0, 6, 10, 2); c.fill(); c.fillStyle = '#fff'; c.fillRect(4, 0, 2, 4); });
    const CAP = {};
    BK_BONUS.forEach(k => {
      const col = BK_BCOL[k];
      CAP[k] = pre(36, 20, c => {
        c.fillStyle = rgba(col, .35); rrp(c, 1, 1, 34, 18, 9); c.fill();
        const gr = c.createLinearGradient(0, 2, 0, 18); gr.addColorStop(0, shade(col, .4)); gr.addColorStop(.5, col); gr.addColorStop(1, shade(col, -.4));
        c.fillStyle = gr; rrp(c, 3, 3, 30, 14, 7); c.fill();
        c.fillStyle = 'rgba(255,255,255,.45)'; rrp(c, 5, 4, 26, 5, 3); c.fill();
        c.strokeStyle = 'rgba(0,0,0,.35)'; c.lineWidth = 1; rrp(c, 3.5, 3.5, 29, 13, 7); c.stroke();
        c.fillStyle = '#fff'; c.strokeStyle = '#fff'; c.lineWidth = 2; c.lineCap = 'round'; c.lineJoin = 'round';
        const cx = 18, cy = 10;
        if (k === 'wide') { c.beginPath(); c.moveTo(cx - 8, cy); c.lineTo(cx + 8, cy); c.moveTo(cx - 5, cy - 3); c.lineTo(cx - 8, cy); c.lineTo(cx - 5, cy + 3); c.moveTo(cx + 5, cy - 3); c.lineTo(cx + 8, cy); c.lineTo(cx + 5, cy + 3); c.stroke(); }
        else if (k === 'narrow') { c.beginPath(); c.moveTo(cx - 9, cy); c.lineTo(cx - 2, cy); c.moveTo(cx - 5, cy - 3); c.lineTo(cx - 2, cy); c.lineTo(cx - 5, cy + 3); c.moveTo(cx + 9, cy); c.lineTo(cx + 2, cy); c.moveTo(cx + 5, cy - 3); c.lineTo(cx + 2, cy); c.lineTo(cx + 5, cy + 3); c.stroke(); }
        else if (k === 'multi') { [[-6, 1], [0, -2], [6, 1]].forEach(p => { c.beginPath(); c.arc(cx + p[0], cy + p[1], 2.4, 0, TAU); c.fill(); }); }
        else if (k === 'slow') { c.beginPath(); c.arc(cx, cy, 5, 0, TAU); c.stroke(); c.beginPath(); c.moveTo(cx, cy - 3); c.lineTo(cx, cy); c.lineTo(cx + 2.5, cy + 1.5); c.stroke(); }
        else if (k === 'laser') { c.fillRect(cx - 5, cy - 5, 2.4, 10); c.fillRect(cx + 2.6, cy - 5, 2.4, 10); }
        else if (k === 'sticky') { c.beginPath(); c.moveTo(cx, cy - 6); c.quadraticCurveTo(cx + 6, cy + 1, cx, cy + 5); c.quadraticCurveTo(cx - 6, cy + 1, cx, cy - 6); c.fill(); }
        else if (k === 'life') { c.beginPath(); c.moveTo(cx, cy + 5); c.lineTo(cx - 6, cy - 1); c.arc(cx - 3, cy - 2.5, 3.2, 2.5, 6.0); c.arc(cx + 3, cy - 2.5, 3.2, 3.4, 6.9); c.lineTo(cx, cy + 5); c.fill(); }
        else if (k === 'fire') { c.beginPath(); c.moveTo(cx, cy - 7); c.quadraticCurveTo(cx + 7, cy - 1, cx + 3, cy + 5); c.quadraticCurveTo(cx + 1, cy + 7, cx - 3, cy + 5); c.quadraticCurveTo(cx - 7, cy, cx - 2, cy - 3); c.quadraticCurveTo(cx - 1, cy - 1, cx, cy - 7); c.fill(); }
      });
    });
    const TAP = textSprite('toca para lançar', '600 16px Inter, system-ui, sans-serif', 'rgba(255,255,255,.6)', 240, 26);
    const FLASHR = pre(W, H, c => { const gr = c.createRadialGradient(W / 2, H, 40, W / 2, H, H); gr.addColorStop(0, 'rgba(255,60,60,.7)'); gr.addColorStop(1, 'rgba(255,60,60,0)'); c.fillStyle = gr; c.fillRect(0, 0, W, H); });

    /* ---- estado ---- */
    let bricks = [], balls = [], pad, lives, dead, level, launched, drops = [], beams = [], effWide = 0, effNarrow = 0, fireT = 0, laserT = 0, stickyT = 0, laserCd = 0, started0 = false, cleanRun = 0, lostThisLevel = false, time = 0, combo = 0, maxCombo = 0, broken = 0, caught = 0, ts = 1, stopT = 0, flashA = 0, flashR = 0, transT = 0, levelLeft = 0, score = 0, t0 = 0, dirty = true, auto = false;
    const MAX_BALLS = 5;
    const newBall = (x, y, vx, vy) => ({ x, y, vx, vy, r: 6, tx: new Float32Array(10), ty: new Float32Array(10), ti: 0, stuck: false, off: 0 });
    const makeBricks = () => {
      bricks = []; const lv = BK_LEVELS[(level - 1) % BK_LEVELS.length]; let i = 0;
      for (let r = 0; r < lv.rows; r++) for (let c = 0; c < COLS; c++) {
        const hp = lv.hp(r, c); if (!hp) continue;
        const mv = lv.move && lv.move.indexOf(r) >= 0;
        const col = BK_COLS[(r + level - 1) % BK_COLS.length];
        /* spr: o sprite do estado atual vive no próprio tijolo (troca-se só quando leva uma pancada) */
        bricks.push({ x0: MX + c * (BW + GAP), x: MX + c * (BW + GAP), y: TOP + r * (BH + 5), w: BW, h: BH, c: col, hp, max: hp, mv, ph: r * 1.3, sp: .9 + (r % 3) * .35, delay: (i++) * .018, spr: brick(col, hp, hp) });
      }
      levelLeft = bricks.filter(b => b.max !== 9).length;
      if (!levelLeft) { bricks.push({ x0: MX, x: MX, y: TOP, w: BW, h: BH, c: BK_COLS[0], hp: 1, max: 1, mv: false, ph: 0, sp: 1, delay: 0, spr: brick(BK_COLS[0], 1, 1) }); levelLeft = 1; }
      transT = 0;
    };
    const resetBall = () => {
      pad = pad || { x: W / 2 - 38, w: 76 };
      pad.w = effWide > 0 ? 118 : effNarrow > 0 ? 48 : 76; pad.x = Math.max(0, Math.min(W - pad.w, pad.x));
      balls = [newBall(pad.x + pad.w / 2, PY - 8, 0, 0)];
      launched = false; drops = []; beams = []; combo = 0; dirty = true;
      hud();
    };
    const hud = () => A.setMid(`<span class="gm-hint">${A.hearts(lives, Math.max(3, lives))}<span>Nível\u200b</span> <b>${level}</b></span>`);
    const launch = () => {
      if (A.paused || !started0 || dead || transT > 0) return;
      if (!launched) { launched = true; const b = balls[0]; if (b) { b.vx = (Math.random() < .5 ? -1 : 1) * 150; b.vy = -270; } A.sfx('pop'); return; }
      let any = false;
      for (const b of balls) if (b.stuck) { b.stuck = false; b.vx = (b.off / (pad.w / 2)) * 180; b.vy = -280; any = true; }
      if (any) { A.sfx('pop'); return; }
      if (laserT > 0 && laserCd <= 0) { laserCd = .28; beams.push({ x: pad.x + 6, y: PY - 8 }, { x: pad.x + pad.w - 6, y: PY - 8 }); A.sfx('laser'); }
    };
    const start = async () => {
      L.stop(); level = 1; lives = 3; dead = false; started0 = false; cleanRun = 0; lostThisLevel = false; time = 0; combo = 0; maxCombo = 0; broken = 0; caught = 0; ts = 1; stopT = 0; flashA = 0; flashR = 0; score = 0; effWide = 0; effNarrow = 0; fireT = 0; laserT = 0; stickyT = 0; pad = null;
      fx.clear(); shaker.reset(); rec.reset(); A.setScore(0); makeBricks(); resetBall(); transT = 0; draw();
      await A.ready('Break', 'Arrasta para mover a raquete e toca para lançar a bola');
      if (A.ended) return;
      await countdown(A, 3);
      if (A.ended || started0) return;
      started0 = true; t0 = Date.now(); L.start();
    };

    /* ---- controlo: arrastar no palco, botões e teclado ---- */
    const pt = { x: 0, y: 0 }; let drag = false;
    const setPad = x => { pad.x = Math.max(0, Math.min(W - pad.w, x - pad.w / 2)); if (!launched && balls[0]) balls[0].x = pad.x + pad.w / 2; for (const b of balls) if (b.stuck) b.x = pad.x + pad.w / 2 + b.off; dirty = true; };
    const zone = A.el.stage;
    zone.style.touchAction = 'none';
    zone.addEventListener('pointerdown', e => { if (!started0 || A.paused || dead) return; drag = true; try { zone.setPointerCapture(e.pointerId); } catch (x) {} canvasPoint(cv, e, pt); setPad(pt.x); launch(); });
    zone.addEventListener('pointermove', e => { if (!drag || !pad) return; canvasPoint(cv, e, pt); setPad(pt.x); });
    const upPad = () => { drag = false; };
    zone.addEventListener('pointerup', upPad); zone.addEventListener('pointercancel', upPad);
    A.el.ctl.innerHTML = `<div class="gm-row">${Arcade.btn('l', 'chevL')}${Arcade.btn('go', 'play', 20)}${Arcade.btn('r', 'chevR')}</div>`;
    let held = null;
    const nudge = d => { if (A.paused || dead || !started0 || !pad) return; setPad(pad.x + pad.w / 2 + d * 24); };
    ['l', 'r'].forEach(k => {
      const b = A.el.ctl.querySelector('.gb.' + k), d = k === 'l' ? -1 : 1;
      b.addEventListener('pointerdown', () => { clearInterval(held); nudge(d); held = setInterval(() => nudge(d), 50); win.timers.push(held); });
      const stop = () => { clearInterval(held); held = null; };
      b.addEventListener('pointerup', stop); b.addEventListener('pointercancel', stop); b.addEventListener('pointerleave', stop);
    });
    A.el.ctl.querySelector('.gb.go').onclick = () => launch();

    const addScore = n => { score += n; A.setScore(score); rec.check(score); };
    const loseLife = () => {
      lives--; lostThisLevel = true; cleanRun = 0; flashR = .6; shaker.kick(7);
      A.haptic('heavy'); A.sfx('fail');
      if (lives <= 0) { dead = true; finish('Perdeste', false); return; }
      effWide = 0; effNarrow = 0; fireT = 0; laserT = 0; stickyT = 0;
      resetBall();
    };
    const finish = (title, win2) => {
      L.stop(); Arcade.maxStat('breakLevel', level);
      const secs = Math.round((Date.now() - t0) / 1000);
      A.end({ title, sub: `${score} pontos · nível ${level}`, score, win: win2, stats: [{ label: 'Nível\u200b', value: String(level) }, { label: 'Tijolos partidos', value: String(broken) }, { label: 'Combo máximo', value: String(maxCombo) }, { label: 'Bónus apanhados', value: String(caught) }, { label: 'Tempo', value: mmss(secs) }] });
    };
    const applyBonus = k => {
      caught++;
      if (k === 'wide') { effWide = 12; effNarrow = 0; pad.w = 118; pad.x = Math.max(0, Math.min(W - pad.w, pad.x - 21)); }
      else if (k === 'narrow') { effNarrow = 8; effWide = 0; pad.w = 48; pad.x = Math.min(W - pad.w, pad.x + 14); }
      else if (k === 'slow') balls.forEach(b => { const s = Math.hypot(b.vx, b.vy) || 1; const f = Math.max(170, s * .65) / s; b.vx *= f; b.vy *= f; });
      else if (k === 'life') { lives = Math.min(5, lives + 1); }
      else if (k === 'fire') { fireT = 8; }
      else if (k === 'laser') { laserT = 8; }
      else if (k === 'sticky') { stickyT = 10; }
      else if (k === 'multi') {
        const novas = [];
        for (const b of balls) {
          if (balls.length + novas.length >= MAX_BALLS) break;
          if (b.stuck) continue;
          const sp = Math.hypot(b.vx, b.vy) || 260;
          const ang = Math.atan2(b.vx, -b.vy);
          novas.push(newBall(b.x, b.y, Math.sin(ang - .55) * sp, -Math.cos(ang - .55) * sp), newBall(b.x, b.y, Math.sin(ang + .55) * sp, -Math.cos(ang + .55) * sp));
        }
        for (const nb of novas) if (balls.length < MAX_BALLS) balls.push(nb);
        if (balls.length >= 3) Arcade.flag('breakMulti');
      }
      hud(); A.sfx(k === 'narrow' ? 'fail' : 'powerup'); A.flash(BK_BNAME[k], k === 'narrow' ? 'pts' : 'bonus');
    };
    const hitBrick = (b, ball2, fire) => {
      if (b.max === 9) { A.sfx('hit'); fx.burst(ball2 ? ball2.x : b.x + b.w / 2, ball2 ? ball2.y : b.y + b.h / 2, '#C9CDD8', 4, 120, { size: 2 }); return false; }
      if (fire) b.hp = 0; else b.hp--;
      const x = ball2 ? ball2.x : b.x + b.w / 2, y = ball2 ? ball2.y : b.y + b.h;
      if (b.hp > 0) { b.spr = brick(b.c, b.hp, b.max); addScore(5); fx.burst(x, y, [b.c, '#fff'], 6, 130, { size: 2.2 }); A.sfx('hit'); return false; }
      broken++; levelLeft--; combo++; if (combo > maxCombo) maxCombo = combo;
      let pts = 10 * b.max; if (combo >= 3) { pts += 5 * combo; A.flashAt(cv, b.x + b.w / 2, b.y - 6, 'Combo x' + combo, 'bonus'); A.sfx('combo'); }
      addScore(pts);
      fx.burst(b.x + b.w / 2, b.y + b.h / 2, [b.c, shade(b.c, .5), '#fff'], 14, 170, { glow: true, size: 2.6 });
      A.flashAt(cv, b.x + b.w / 2, b.y, '+' + pts, 'pts');
      A.sfx(b.max > 1 ? 'crash' : 'hit'); shaker.kick(b.max > 1 ? 3 : 1.5);
      if (Math.random() < .15 + level * .005) drops.push({ x: b.x + b.w / 2, y: b.y + b.h / 2, k: BK_BONUS[(Math.random() * BK_BONUS.length) | 0], t: 0 });
      if (levelLeft <= 0) { stopT = .09; flashA = .6; ts = 1; levelDone(); }
      return true;
    };
    const levelDone = () => {
      level++; addScore(100 + lives * 50); Arcade.maxStat('breakLevel', level);
      if (!lostThisLevel) { cleanRun++; if (cleanRun >= 3) Arcade.flag('breakClean'); }
      lostThisLevel = false; beams = [];
      if (level > BK_LEVELS.length) { dead = true; level = BK_LEVELS.length; celebrate(A, 'win'); finish('Arcada completa!', true); return; }
      makeBricks(); effWide = 0; effNarrow = 0; fireT = 0; laserT = 0; stickyT = 0; resetBall(); transT = 1.1;
      A.flash('Nível ' + level, 'big'); A.sfx('level'); celebrate(A, 'level');
    };
    /* uma bola: devolve 'perdeu' ou null; as colisões com tijolos tratam-se aqui */
    const stepBall = (b, dt) => {
      if (b.stuck) { b.x = pad.x + pad.w / 2 + b.off; b.y = PY - 8; return null; }
      b.tx[b.ti] = b.x; b.ty[b.ti] = b.y; b.ti = (b.ti + 1) % 10;
      b.x += b.vx * dt; b.y += b.vy * dt;
      if (b.x < b.r + 2) { b.x = b.r + 2; b.vx = Math.abs(b.vx); A.sfx('bounce'); fx.burst(b.x - 4, b.y, '#9FEBFF', 4, 90, { size: 1.8, grav: 0 }); }
      if (b.x > W - b.r - 2) { b.x = W - b.r - 2; b.vx = -Math.abs(b.vx); A.sfx('bounce'); fx.burst(b.x + 4, b.y, '#9FEBFF', 4, 90, { size: 1.8, grav: 0 }); }
      if (b.y < b.r + 2) { b.y = b.r + 2; b.vy = Math.abs(b.vy); A.sfx('bounce'); }
      if (b.vy > 0 && b.y + b.r >= PY - 6 && b.y < PY + 14 && b.x > pad.x - 4 && b.x < pad.x + pad.w + 4) {
        b.y = PY - 6 - b.r;
        const rel = Math.max(-1, Math.min(1, (b.x - (pad.x + pad.w / 2)) / (pad.w / 2)));
        const sp = Math.min(470, Math.hypot(b.vx, b.vy) * 1.02 + 2);
        const ang = rel * 1.1;
        b.vx = Math.sin(ang) * sp; b.vy = -Math.cos(ang) * sp;
        combo = 0; A.sfx('move'); fx.burst(b.x, PY - 6, '#CFF2FF', 5, 100, { size: 1.8, dir: -1.57, spread: 1.4 });
        if (stickyT > 0) { b.stuck = true; b.off = b.x - (pad.x + pad.w / 2); b.vx = 0; b.vy = 0; }
      }
      for (let i = 0; i < bricks.length; i++) {
        const k = bricks[i]; if (!k.hp) continue;
        if (b.x > k.x - b.r && b.x < k.x + k.w + b.r && b.y > k.y - b.r && b.y < k.y + k.h + b.r) {
          const fire = fireT > 0 && k.max !== 9;
          if (!fire) {
            const ox = Math.min(b.x - (k.x - b.r), (k.x + k.w + b.r) - b.x), oy = Math.min(b.y - (k.y - b.r), (k.y + k.h + b.r) - b.y);
            if (ox < oy) { b.vx *= -1; b.x += b.vx > 0 ? ox : -ox; } else { b.vy *= -1; b.y += b.vy > 0 ? oy : -oy; }
          }
          hitBrick(k, b, fire);
          if (levelLeft <= 0 || !fire) break;
        }
      }
      return b.y > H + 24 ? 'perdeu' : null;
    };
    const lastBrick = () => { for (let i = 0; i < bricks.length; i++) if (bricks[i].hp && bricks[i].max !== 9) return bricks[i]; return null; };

    /* ---- ciclo ---- */
    const tick = dt0 => {
      shaker.step(dt0);
      if (stopT > 0) { stopT -= dt0; draw(); return; }
      let dt = dt0 * ts;
      if (dead) { if (fx.count) { fx.step(dt0); draw(); } else L.stop(); return; }
      if (!started0) return;
      time += dt0;
      /* piloto automático (só o harness o liga, dbg.auto): a raquete segue a bola mais baixa que desce */
      if (auto && launched && pad) { let lb = null; for (let i = 0; i < balls.length; i++) { const b = balls[i]; if (b.vy > 0 && (!lb || b.y > lb.y)) lb = b; } if (lb) setPad(lb.x + (lb.x < W / 2 ? 9 : -9)); }
      if (flashA > 0) flashA = Math.max(0, flashA - dt0 * 2.5);
      if (flashR > 0) flashR = Math.max(0, flashR - dt0 * 1.6);
      if (transT > 0) { transT -= dt0; dt = 0; }
      for (const k of bricks) if (k.mv) k.x = k.x0 + Math.sin(time * k.sp + k.ph) * 12;
      if (launched && transT <= 0) {
        if (effWide > 0) { effWide -= dt; if (effWide <= 0) { pad.w = 76; pad.x = Math.min(W - pad.w, pad.x + 21); } }
        if (effNarrow > 0) { effNarrow -= dt; if (effNarrow <= 0) { pad.w = 76; pad.x = Math.max(0, Math.min(W - pad.w, pad.x - 14)); } }
        if (fireT > 0) fireT -= dt; if (laserT > 0) laserT -= dt; if (stickyT > 0) stickyT -= dt; if (laserCd > 0) laserCd -= dt;
        /* câmara lenta no último tijolo */
        ts = 1;
        if (levelLeft === 1) { const lb = lastBrick(); if (lb) for (const b of balls) { const dx = (lb.x + lb.w / 2) - b.x, dy = (lb.y + lb.h / 2) - b.y; if (dx * dx + dy * dy < 90 * 90 && (dx * b.vx + dy * b.vy) > 0) { ts = .35; break; } } }
        let restarted = false;
        for (let i = balls.length - 1; i >= 0 && !restarted; i--) {
          const r = stepBall(balls[i], dt);
          if (transT > 0 || dead) restarted = true;
          else if (r === 'perdeu') { balls.splice(i, 1); if (balls.length) { A.sfx('fail'); shaker.kick(2); } }
        }
        if (!restarted && !balls.length) { loseLife(); restarted = true; }
        if (!restarted) {
          for (let i = drops.length - 1; i >= 0; i--) {
            const d = drops[i]; d.y += 140 * dt; d.t += dt;
            if (d.y > H + 10) { drops.splice(i, 1); continue; }
            if (d.y > PY - 12 && d.y < PY + 16 && d.x > pad.x - 10 && d.x < pad.x + pad.w + 10) { applyBonus(d.k); fx.burst(d.x, PY - 6, [BK_BCOL[d.k], '#fff'], 12, 140, { glow: true, size: 2.4 }); drops.splice(i, 1); }
          }
          for (let i = beams.length - 1; i >= 0; i--) {
            const bm = beams[i]; bm.y -= 560 * dt;
            if (bm.y < 0) { beams.splice(i, 1); continue; }
            for (let j = 0; j < bricks.length; j++) { const k = bricks[j]; if (!k.hp) continue; if (bm.x > k.x && bm.x < k.x + k.w && bm.y > k.y && bm.y < k.y + k.h) { hitBrick(k, null, false); beams.splice(i, 1); break; } }
            if (levelLeft <= 0) break;
          }
        }
      } else {
        for (const b of balls) if (!launched) { b.x = pad.x + pad.w / 2; b.y = PY - 8; }
      }
      fx.step(dt0);
      draw();
    };
    const draw = () => {
      ctx.drawImage(BG, 0, 0);
      const tin = transT > 0 ? 1.1 - transT : 9;
      for (let i = 0; i < bricks.length; i++) {
        const k = bricks[i]; if (!k.hp) continue;
        let yy = k.y;
        if (tin < 1.1) { const e = ease((tin - k.delay) / .35); if (e <= 0) continue; yy = k.y - (1 - e) * 70; ctx.globalAlpha = e; }
        ctx.drawImage(k.spr, k.x - 3, yy - 2);
        if (tin < 1.1) ctx.globalAlpha = 1;
      }
      for (let i = 0; i < drops.length; i++) { const d = drops[i]; ctx.drawImage(CAP[d.k], d.x - 18 + Math.sin(d.t * 5) * 3, d.y - 10); }
      for (let i = 0; i < beams.length; i++) { const bm = beams[i]; ctx.fillStyle = '#FFB3F0'; ctx.fillRect(bm.x - 1.5, bm.y, 3, 14); ctx.drawImage(LGLOW, bm.x - 12, bm.y - 12); }
      if (pad) {
        ctx.drawImage(paddle(pad.w), pad.x - 6, PY - 10);
        if (laserT > 0) { ctx.drawImage(TURRET, pad.x + 1, PY - 14); ctx.drawImage(TURRET, pad.x + pad.w - 11, PY - 14); }
        if (stickyT > 0) { ctx.globalAlpha = .55 + .3 * Math.sin(time * 8); ctx.fillStyle = '#A6F03A'; ctx.fillRect(pad.x + 4, PY - 8, pad.w - 8, 2.5); ctx.globalAlpha = 1; }
      }
      const fire = fireT > 0;
      for (let i = 0; i < balls.length; i++) {
        const b = balls[i];
        if (launched && !b.stuck) {
          for (let j = 1; j <= 9; j++) { const idx = (b.ti - j + 10) % 10; const k = (10 - j) / 10; ctx.globalAlpha = k * (fire ? .5 : .35); const s = (fire ? 34 : 26) * k; ctx.drawImage(fire ? FGLOW : BGLOW, b.tx[idx] - s / 2, b.ty[idx] - s / 2, s, s); }
          ctx.globalAlpha = 1;
        }
        ctx.drawImage(fire ? FGLOW : BGLOW, b.x - (fire ? 26 : 20), b.y - (fire ? 26 : 20), fire ? 52 : 40, fire ? 52 : 40);
        ctx.drawImage(fire ? FBALL : BALL, b.x - 7, b.y - 7);
      }
      fx.draw(ctx);
      if (flashR > 0) { ctx.globalAlpha = flashR; ctx.drawImage(FLASHR, 0, 0); ctx.globalAlpha = 1; }
      if (flashA > 0) { ctx.globalAlpha = flashA; ctx.fillStyle = '#fff'; ctx.fillRect(0, 0, W, H); ctx.globalAlpha = 1; }
      if (!launched && started0 && !dead && transT <= 0) { ctx.globalAlpha = .7 + .3 * Math.sin(time * 4); ctx.drawImage(TAP, W / 2 - 120, H - 100); ctx.globalAlpha = 1; }
    };
    const L = Arcade.loop(tick);
    start();
    win.onClose = () => { L.stop(); clearInterval(held); };
    return {
      pause: () => { L.stop(); },
      resume: () => { if (started0 && !dead && !A.paused && !A.ended) L.start(); },
      key(e) {
        if (e.key === 'ArrowLeft' || e.key === 'a' || e.key === 'A') { e.preventDefault(); nudge(-1); }
        else if (e.key === 'ArrowRight' || e.key === 'd' || e.key === 'D') { e.preventDefault(); nudge(1); }
        else if (e.key === ' ' || e.key === 'Enter' || e.key === 'ArrowUp' || e.key === 'w' || e.key === 'W') { e.preventDefault(); if (!e.repeat) launch(); }
      },
      dbg: () => ({ started: launched, padX: Math.round(pad ? pad.x : 0), padW: pad ? pad.w : 0, ballX: Math.round(balls[0] ? balls[0].x : 0), ballY: Math.round(balls[0] ? balls[0].y : 0), vy: Math.round(balls[0] ? balls[0].vy : 0), balls: balls.length, lives, level, bricks: bricks.filter(b => b.hp && b.max !== 9).length, running: L.running, combo, score }),
      step: dt => tick(dt || 0.05),
      draw,
      launch,
      bonus: k => { if (started0 && pad) applyBonus(k); },
      auto: on => { auto = on !== false; },
      setLevel: n => { if (!started0) return; level = n; makeBricks(); transT = 0; resetBall(); hud(); },
      breakAll: () => { for (const k of bricks) if (k.hp && k.max !== 9 && levelLeft > 1) hitBrick(k, null, true); },
      dropBall: () => { if (balls.length) balls[balls.length - 1].y = H + 999; },
      end: () => { if (started0) { lives = 1; loseLife(); } },
    };
  },
});


/* =====================================================================
   6. MEMÓRIA: três conjuntos de cartas em SVG (néons, animais, frutos), verso com treliça e emblema,
   viragem 3D, brilho no par, abanão no erro, 8/12/18 pares e Contra o relógio
   ===================================================================== */
const neon = (d, col, extra) => `<path d="${d}" fill="none" stroke="${col}" stroke-width="8" stroke-opacity=".16" stroke-linecap="round" stroke-linejoin="round"/><path d="${d}" fill="none" stroke="${col}" stroke-width="4.4" stroke-opacity=".32" stroke-linecap="round" stroke-linejoin="round"/><path d="${d}" fill="none" stroke="${col}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/><path d="${d}" fill="none" stroke="#fff" stroke-width=".9" stroke-opacity=".75" stroke-linecap="round" stroke-linejoin="round"/>${extra || ''}`;
const ndot = (x, y, col, r) => `<circle cx="${x}" cy="${y}" r="${(r || 2) + 3}" fill="${col}" opacity=".25"/><circle cx="${x}" cy="${y}" r="${r || 2}" fill="${col}"/><circle cx="${x}" cy="${y}" r="${(r || 2) * .45}" fill="#fff" opacity=".8"/>`;
const ME_NEON = [
  ['palm', () => neon('M24 43V22M24 22c-8-6-14-4-16 1M24 22c8-6 14-4 16 1M24 22c-4-8-10-10-14-8M24 22c4-8 10-10 14-8M24 22c-1-8-3-12-7-14M24 22c1-8 3-12 7-14', '#3BE36B')],
  ['cocktail', () => neon('M10 9h28L24 26zM24 26v14M16 40h16M31 9l4-5', '#FF5CE1', ndot(19, 15, '#FF3B6B', 2.4))],
  ['star', () => neon('M24 6l5.3 11.2 12.2 1.6-8.9 8.4 2.3 12.1L24 33.4l-10.9 5.9 2.3-12.1-8.9-8.4 12.2-1.6z', '#FFD21F')],
  ['bolt', () => neon('M27 4 11 27h10l-3 17 18-24H26z', '#2BD4FF')],
  ['heart', () => neon('M24 41S7 30 7 18.5A8.5 8.5 0 0 1 24 14a8.5 8.5 0 0 1 17 4.5C41 30 24 41 24 41z', '#FF3B6B')],
  ['diamond', () => neon('M14 8h20l9 10-19 24L5 18zM5 18h38M17 8l7 10 7-10M24 18l-7 24M24 18l7 24', '#B48CFF')],
  ['moon', () => neon('M30 6a16 16 0 1 0 12 26A13 13 0 0 1 30 6z', '#FFD21F', ndot(38, 10, '#fff', 1.6))],
  ['car', () => neon('M7 30l4-10a4 4 0 0 1 4-3h18a4 4 0 0 1 4 3l4 10v8H7zM7 30h34M14 38v4M34 38v4M15 23h18', '#FF8A2B', ndot(13, 33, '#FFD21F', 2) + ndot(35, 33, '#FF3B6B', 2))],
  ['dice', () => neon('M10 10h28v28H10z', '#2BFFC8', ndot(17, 17, '#2BFFC8', 2) + ndot(31, 31, '#2BFFC8', 2) + ndot(24, 24, '#2BFFC8', 2) + ndot(31, 17, '#2BFFC8', 2) + ndot(17, 31, '#2BFFC8', 2))],
  ['crown', () => neon('M8 35h32l3-19-10 8-9-14-9 14-10-8zM8 35v5h32v-5', '#FFD21F', ndot(24, 10, '#FF3B6B', 2))],
  ['note', () => neon('M18 36a5 5 0 1 1-10 0 5 5 0 0 1 10 0zM18 36V10l18-4v24M36 30a5 5 0 1 1-10 0 5 5 0 0 1 10 0zM18 18l18-4', '#FF5CE1')],
  ['rocket', () => neon('M24 4c6 5 8 14 8 22l-8 6-8-6c0-8 2-17 8-22zM16 26l-6 8h8M32 26l6 8h-8M20 36l4 8 4-8', '#2BD4FF', ndot(24, 16, '#FFD21F', 3))],
  ['cactus', () => neon('M20 42V12a4 4 0 0 1 8 0v30M11 20v8a4 4 0 0 0 4 4h5M37 15v11a4 4 0 0 1-4 4h-5M13 42h22', '#3BE36B')],
  ['flamingo', () => neon('M30 14a5 5 0 1 1 10 0c0 4-5 4-5 10M35 24c0 6-5 8-11 8s-10-2-10-6c0-5 5-8 11-8h10M18 32l-3 12M25 32l-2 12M40 12l4 2', '#FF5CE1')],
  ['sun', () => neon('M24 6v6M24 36v6M6 24h6M36 24h6M11 11l4 4M33 33l4 4M37 11l-4 4M15 33l-4 4', '#FF8A2B', `<circle cx="24" cy="24" r="11" fill="#FF8A2B" opacity=".2"/><circle cx="24" cy="24" r="7.5" fill="none" stroke="#FF8A2B" stroke-width="2.2"/><circle cx="24" cy="24" r="7.5" fill="none" stroke="#fff" stroke-width=".9" stroke-opacity=".75"/>`)],
  ['skull', () => neon('M24 6a14 14 0 0 1 14 14c0 5-2 8-4 10v8H14v-8c-2-2-4-5-4-10A14 14 0 0 1 24 6zM20 38v4M24 38v4M28 38v4', '#E8E6F0', ndot(18, 21, '#E8E6F0', 3) + ndot(30, 21, '#E8E6F0', 3))],
  ['cherry', () => neon('M20 31a5 5 0 1 1-10 0 5 5 0 0 1 10 0zM38 33a5 5 0 1 1-10 0 5 5 0 0 1 10 0zM15 26c0-8 6-14 12-17M33 28c-2-8-8-14-14-17M27 9h7', '#FF3B6B')],
  ['gamepad', () => neon('M14 16h20a10 10 0 0 1 10 10v2a6 6 0 0 1-10 4l-2-2H16l-2 2a6 6 0 0 1-10-4v-2a10 10 0 0 1 10-10zM13 24h8M17 20v8', '#B48CFF', ndot(32, 22, '#FF3B6B', 2) + ndot(37, 26, '#2BD4FF', 2))],
];
/* animais: cara redonda com volume (brilho em cima, sombra em baixo), olhos com reflexo, orelhas por espécie */
const vol = (cx, cy, r) => `<ellipse cx="${cx - r * .32}" cy="${cy - r * .38}" rx="${r * .42}" ry="${r * .26}" fill="#fff" opacity=".22"/><path d="M${cx - r * .7} ${cy + r * .55}a${r} ${r} 0 0 0 ${r * 1.4} 0" fill="#000" opacity=".12"/>`;
const eyes = (y, dx, r) => `<circle cx="${24 - dx}" cy="${y}" r="${r}" fill="#fff"/><circle cx="${24 + dx}" cy="${y}" r="${r}" fill="#fff"/><circle cx="${24 - dx + .4}" cy="${y + .3}" r="${r * .52}" fill="#1A1A1E"/><circle cx="${24 + dx + .4}" cy="${y + .3}" r="${r * .52}" fill="#1A1A1E"/><circle cx="${24 - dx - .4}" cy="${y - .6}" r="${r * .22}" fill="#fff"/><circle cx="${24 + dx - .4}" cy="${y - .6}" r="${r * .22}" fill="#fff"/>`;
const head = (col, r, cy) => `<circle cx="24" cy="${cy || 26}" r="${r}" fill="${col}"/>` + vol(24, cy || 26, r);
const nose = (y, col, w) => `<ellipse cx="24" cy="${y}" rx="${w || 2.6}" ry="${(w || 2.6) * .7}" fill="${col || '#2A1A14'}"/>`;
const smile = (y, w, col) => `<path d="M${24 - w} ${y}q${w} ${w * .9} ${w * 2} 0" fill="none" stroke="${col || '#2A1A14'}" stroke-width="1.6" stroke-linecap="round"/>`;
const ME_ANIMALS = [
  ['cat', () => `<path d="M11 21l1-13 10 7zM37 21l-1-13-10 7z" fill="#F2A65A"/><path d="M13.5 18.5l.5-7 6 4.5zM34.5 18.5l-.5-7-6 4.5z" fill="#FFC4B0"/>` + head('#F2A65A', 13) + eyes(24, 5.5, 3) + `<path d="M22 30.5h4l-2 2.4z" fill="#FF8AA0"/>` + smile(33.5, 3, '#8A4A2A') + `<path d="M8 29h9M8 33l9-2M40 29h-9M40 33l-9-2" stroke="#8A4A2A" stroke-width="1" stroke-linecap="round"/>`],
  ['dog', () => `<ellipse cx="11" cy="27" rx="5" ry="10" fill="#7A4A2A"/><ellipse cx="37" cy="27" rx="5" ry="10" fill="#7A4A2A"/>` + head('#C98B5A', 13) + `<ellipse cx="24" cy="31" rx="7" ry="5.5" fill="#E8C49A"/>` + eyes(23, 5.5, 3) + nose(29, '#2A1A14', 3) + `<path d="M24 32v3" stroke="#2A1A14" stroke-width="1.4"/><path d="M21 35h6v2a3 3 0 0 1-6 0z" fill="#FF6E8A"/>`],
  ['fox', () => `<path d="M9 24l2-15 11 7zM39 24l-2-15-11 7z" fill="#FF7A2B"/><path d="M12 21l1-8 6 4zM36 21l-1-8-6 4z" fill="#3A1F12"/>` + head('#FF7A2B', 13) + `<path d="M12 29c3 8 9 10 12 10s9-2 12-10c-3-2-7-3-12-3s-9 1-12 3z" fill="#FFF4EA"/>` + eyes(24, 5.5, 2.8) + nose(33, '#2A1A14', 2.6)],
  ['owl', () => `<path d="M12 18l2-10 7 6zM36 18l-2-10-7 6z" fill="#6B4E36"/><ellipse cx="24" cy="27" rx="14" ry="15" fill="#8B6A4E"/>` + vol(24, 27, 14) + `<ellipse cx="24" cy="32" rx="8" ry="8" fill="#C9A77F"/><circle cx="17.5" cy="22" r="6.5" fill="#F5E6C8"/><circle cx="30.5" cy="22" r="6.5" fill="#F5E6C8"/><circle cx="17.5" cy="22" r="4.6" fill="#FFB020"/><circle cx="30.5" cy="22" r="4.6" fill="#FFB020"/><circle cx="18" cy="22.4" r="2.4" fill="#1A1A1E"/><circle cx="31" cy="22.4" r="2.4" fill="#1A1A1E"/><circle cx="17" cy="21" r=".9" fill="#fff"/><circle cx="30" cy="21" r=".9" fill="#fff"/><path d="M21.5 27h5l-2.5 4z" fill="#FF8A2B"/>`],
  ['frog', () => `<circle cx="15" cy="15" r="6" fill="#5BD85B"/><circle cx="33" cy="15" r="6" fill="#5BD85B"/><ellipse cx="24" cy="28" rx="16" ry="12" fill="#5BD85B"/>` + vol(24, 28, 14) + `<circle cx="15" cy="15" r="3.8" fill="#fff"/><circle cx="33" cy="15" r="3.8" fill="#fff"/><circle cx="15.5" cy="15.4" r="2" fill="#1A1A1E"/><circle cx="33.5" cy="15.4" r="2" fill="#1A1A1E"/><circle cx="14.6" cy="14.4" r=".7" fill="#fff"/><circle cx="32.6" cy="14.4" r=".7" fill="#fff"/><path d="M14 29q10 9 20 0" fill="none" stroke="#1E6E2A" stroke-width="1.8" stroke-linecap="round"/><circle cx="20" cy="24" r="1.2" fill="#1E6E2A"/><circle cx="28" cy="24" r="1.2" fill="#1E6E2A"/>`],
  ['pig', () => `<path d="M10 21l1-10 8 5zM38 21l-1-10-8 5z" fill="#FF8FB0"/>` + head('#FFA6C1', 13) + eyes(23, 6, 2.6) + `<ellipse cx="24" cy="31" rx="6.5" ry="4.5" fill="#FF7FA6"/><circle cx="21.8" cy="31" r="1.3" fill="#B3335A"/><circle cx="26.2" cy="31" r="1.3" fill="#B3335A"/>`],
  ['bear', () => `<circle cx="12" cy="15" r="6" fill="#8E5A3C"/><circle cx="36" cy="15" r="6" fill="#8E5A3C"/><circle cx="12" cy="15" r="3" fill="#C98B5A"/><circle cx="36" cy="15" r="3" fill="#C98B5A"/>` + head('#8E5A3C', 13) + `<ellipse cx="24" cy="31" rx="6.5" ry="5" fill="#C98B5A"/>` + eyes(23, 5.5, 2.6) + nose(29.5, '#2A1A14', 2.6) + `<path d="M24 32v2M22 34.5q2 1.6 4 0" fill="none" stroke="#2A1A14" stroke-width="1.2" stroke-linecap="round"/>`],
  ['rabbit', () => `<ellipse cx="17" cy="12" rx="4.5" ry="11" fill="#E8E6F0"/><ellipse cx="31" cy="12" rx="4.5" ry="11" fill="#E8E6F0"/><ellipse cx="17" cy="12" rx="2.2" ry="8" fill="#FFB3C6"/><ellipse cx="31" cy="12" rx="2.2" ry="8" fill="#FFB3C6"/>` + head('#E8E6F0', 12, 28) + eyes(26, 5, 2.6) + `<path d="M22.5 31.5h3l-1.5 2z" fill="#FF8AA0"/><rect x="22" y="33.5" width="4" height="3.5" rx="1" fill="#fff" stroke="#C9C7D2" stroke-width=".6"/><path d="M24 33.5v3.5" stroke="#C9C7D2" stroke-width=".6"/>`],
  ['panda', () => `<circle cx="12" cy="15" r="6" fill="#1E1E24"/><circle cx="36" cy="15" r="6" fill="#1E1E24"/>` + head('#F4F4F6', 13) + `<ellipse cx="17.5" cy="24" rx="5" ry="6" fill="#1E1E24" transform="rotate(-20 17.5 24)"/><ellipse cx="30.5" cy="24" rx="5" ry="6" fill="#1E1E24" transform="rotate(20 30.5 24)"/><circle cx="18" cy="24.5" r="2.2" fill="#fff"/><circle cx="30" cy="24.5" r="2.2" fill="#fff"/><circle cx="18.4" cy="24.8" r="1.2" fill="#1A1A1E"/><circle cx="30.4" cy="24.8" r="1.2" fill="#1A1A1E"/>` + nose(31, '#1E1E24', 2.4) + smile(33.5, 2.5, '#1E1E24')],
  ['koala', () => `<circle cx="10" cy="22" r="8" fill="#7E838E"/><circle cx="38" cy="22" r="8" fill="#7E838E"/><circle cx="10" cy="22" r="4.5" fill="#C9CCD4"/><circle cx="38" cy="22" r="4.5" fill="#C9CCD4"/>` + head('#9EA3AD', 13) + eyes(23, 6, 2.4) + `<ellipse cx="24" cy="31" rx="4.5" ry="6" fill="#2A2A30"/><ellipse cx="22.8" cy="29" rx="1.2" ry="1.6" fill="#fff" opacity=".4"/>`],
  ['lion', () => `<circle cx="24" cy="26" r="18" fill="#C97A1E"/>${[0, 45, 90, 135, 180, 225, 270, 315].map(a => `<circle cx="${24 + Math.cos(a * Math.PI / 180) * 16}" cy="${26 + Math.sin(a * Math.PI / 180) * 16}" r="5" fill="#C97A1E"/>`).join('')}` + head('#F2B13A', 12.5) + `<circle cx="14" cy="17" r="3.5" fill="#F2B13A"/><circle cx="34" cy="17" r="3.5" fill="#F2B13A"/>` + eyes(23.5, 5.5, 2.6) + `<ellipse cx="24" cy="30.5" rx="5.5" ry="4" fill="#FFE2A8"/>` + nose(29, '#5B3A1E', 2.4) + `<path d="M24 31v1.5M22 33q2 1.5 4 0" fill="none" stroke="#5B3A1E" stroke-width="1.2" stroke-linecap="round"/>`],
  ['monkey', () => `<circle cx="9" cy="25" r="6" fill="#9A6A4A"/><circle cx="39" cy="25" r="6" fill="#9A6A4A"/><circle cx="9" cy="25" r="3" fill="#E8C49A"/><circle cx="39" cy="25" r="3" fill="#E8C49A"/>` + head('#9A6A4A', 13) + `<path d="M13 24a6 6 0 0 1 11-3 6 6 0 0 1 11 3c0 8-5 13-11 13s-11-5-11-13z" fill="#E8C49A"/>` + eyes(23, 5, 2.6) + `<circle cx="21.5" cy="30" r="1.1" fill="#5B3A1E"/><circle cx="26.5" cy="30" r="1.1" fill="#5B3A1E"/>` + smile(32.5, 3.5, '#5B3A1E')],
  ['chick', () => `<circle cx="24" cy="28" r="14" fill="#FFD93B"/>` + vol(24, 28, 14) + `<ellipse cx="13" cy="31" rx="5" ry="3" fill="#F2B800" transform="rotate(-25 13 31)"/><ellipse cx="35" cy="31" rx="5" ry="3" fill="#F2B800" transform="rotate(25 35 31)"/><path d="M20 10l4-6 4 6z" fill="#FFD93B"/>` + eyes(25, 5, 2.4) + `<path d="M20.5 30h7l-3.5 4z" fill="#FF8A2B"/><path d="M18 42l2-4M30 42l-2-4" stroke="#FF8A2B" stroke-width="2" stroke-linecap="round"/>`],
  ['penguin', () => `<ellipse cx="24" cy="27" rx="13" ry="16" fill="#2E3340"/>` + vol(24, 27, 14) + `<ellipse cx="24" cy="31" rx="8.5" ry="10.5" fill="#F4F4F6"/><ellipse cx="18" cy="19" rx="4" ry="4.5" fill="#F4F4F6"/><ellipse cx="30" cy="19" rx="4" ry="4.5" fill="#F4F4F6"/><circle cx="18.5" cy="19.5" r="1.8" fill="#1A1A1E"/><circle cx="30.5" cy="19.5" r="1.8" fill="#1A1A1E"/><circle cx="18" cy="18.8" r=".6" fill="#fff"/><circle cx="30" cy="18.8" r=".6" fill="#fff"/><path d="M20.5 23h7l-3.5 3.5z" fill="#FF9F2E"/><path d="M16 44l2-4h12l2 4z" fill="#FF9F2E"/>`],
  ['mouse', () => `<circle cx="11" cy="16" r="7" fill="#B5B8C4"/><circle cx="37" cy="16" r="7" fill="#B5B8C4"/><circle cx="11" cy="16" r="4" fill="#FFB3C6"/><circle cx="37" cy="16" r="4" fill="#FFB3C6"/>` + head('#B5B8C4', 12, 28) + eyes(26, 5, 2.6) + `<ellipse cx="24" cy="33" rx="2.4" ry="1.8" fill="#FF8AA0"/><path d="M9 32h9M9 36l9-2M39 32h-9M39 36l-9-2" stroke="#6E717C" stroke-width=".9" stroke-linecap="round"/>`],
  ['tiger', () => `<path d="M10 22l1-12 10 6zM38 22l-1-12-10 6z" fill="#FF9F2E"/>` + head('#FF9F2E', 13) + `<path d="M15 15l3 6M33 15l-3 6M11 26h5M37 26h-5M14 33l5-3M34 33l-5-3" stroke="#2A1A14" stroke-width="2" stroke-linecap="round"/><ellipse cx="24" cy="31" rx="6.5" ry="5" fill="#FFF4EA"/>` + eyes(23.5, 5.5, 2.6) + nose(29.5, '#2A1A14', 2.4) + `<path d="M24 32v2M22 34.5q2 1.6 4 0" fill="none" stroke="#2A1A14" stroke-width="1.2" stroke-linecap="round"/>`],
  ['cow', () => `<path d="M10 17l-4-9 9 4zM38 17l4-9-9 4z" fill="#E8E6F0"/><ellipse cx="10" cy="24" rx="5" ry="3" fill="#C9C7D2"/><ellipse cx="38" cy="24" rx="5" ry="3" fill="#C9C7D2"/>` + head('#F4F4F6', 13) + `<path d="M14 18c4-3 8 0 7 4s-6 4-8 1-2-4 1-5z" fill="#2A2A30"/><path d="M30 30c4-2 7 2 5 5s-6 1-6-1 0-3 1-4z" fill="#2A2A30"/>` + eyes(23, 5.5, 2.6) + `<ellipse cx="24" cy="32" rx="7" ry="4.5" fill="#FFB3C6"/><circle cx="21.5" cy="32" r="1.2" fill="#B3335A"/><circle cx="26.5" cy="32" r="1.2" fill="#B3335A"/>`],
  ['sheep', () => `${[[12, 20], [18, 13], [27, 11], [35, 15], [38, 24], [34, 33], [24, 37], [14, 32]].map(p => `<circle cx="${p[0]}" cy="${p[1]}" r="7.5" fill="#F7F4EE"/>`).join('')}<circle cx="24" cy="24" r="12" fill="#F7F4EE"/>` + head('#4A4A52', 8, 28) + `<ellipse cx="14" cy="28" rx="4" ry="2.2" fill="#4A4A52"/><ellipse cx="34" cy="28" rx="4" ry="2.2" fill="#4A4A52"/>` + eyes(27, 3.3, 1.9) + `<path d="M22.5 31.5h3l-1.5 1.8z" fill="#2A2A30"/>`],
];
/* frutos: forma, volume (brilho e sombra), pé e folha */
const leaf = (x, y, col, rot) => `<path d="M${x} ${y}c2-5 7-6 10-4-2 4-6 6-10 4z" fill="${col || '#34C759'}"${rot ? ` transform="rotate(${rot} ${x} ${y})"` : ''}/>`;
const stem = (x, y, h) => `<path d="M${x} ${y}q.5-${h / 2} 2-${h}" fill="none" stroke="#5B3A1E" stroke-width="2" stroke-linecap="round"/>`;
const ME_FRUITS = [
  ['apple', () => `<circle cx="24" cy="27" r="13" fill="#FF3B30"/><circle cx="24" cy="27" r="13" fill="#8A0E0A" opacity=".18"/><path d="M11 27a13 13 0 0 0 26 0z" fill="#000" opacity=".12"/>` + vol(24, 27, 13) + stem(24, 15, 6) + leaf(25, 14)],
  ['pear', () => `<path d="M24 10c3 0 5 3 6 8 2 7 8 10 8 17a14 14 0 0 1-28 0c0-7 6-10 8-17 1-5 3-8 6-8z" fill="#C7E24A"/><path d="M12 36a12 12 0 0 0 24 0z" fill="#000" opacity=".12"/><ellipse cx="18" cy="30" rx="4" ry="6" fill="#fff" opacity=".22"/>` + stem(24, 11, 6) + leaf(25, 9)],
  ['banana', () => `<path d="M10 16c2 12 10 22 24 24 4 0 7-1 8-3-10-1-20-9-24-21-2-4-8-3-8 0z" fill="#FFD93B"/><path d="M10 16c2 12 10 22 24 24-8-4-18-10-22-24-1-2-2-1-2 0z" fill="#fff" opacity=".25"/><path d="M34 40c4 0 7-1 8-3-1 2-4 3-8 3z" fill="#7A4E12"/><circle cx="10" cy="15" r="2" fill="#7A4E12"/>`],
  ['cherry', () => `<path d="M17 28c0-9 6-16 13-20M31 29c-2-9-7-15-14-18M30 9h7" fill="none" stroke="#3A7A2A" stroke-width="2" stroke-linecap="round"/><circle cx="16" cy="31" r="7.5" fill="#E0241B"/><circle cx="32" cy="32" r="7.5" fill="#E0241B"/>` + vol(16, 31, 7.5) + vol(32, 32, 7.5) + leaf(30, 9, '#4CAF50', -10)],
  ['grapes', () => `${[[24, 16], [18, 22], [30, 22], [14, 29], [24, 29], [34, 29], [18, 36], [30, 36], [24, 42]].map(p => `<circle cx="${p[0]}" cy="${p[1]}" r="5.2" fill="#8E5CF0"/><circle cx="${p[0] - 1.5}" cy="${p[1] - 1.8}" r="1.6" fill="#fff" opacity=".35"/>`).join('')}` + stem(24, 11, 6) + leaf(25, 9)],
  ['strawberry', () => `<path d="M24 42c-8-2-14-9-14-18a14 14 0 0 1 28 0c0 9-6 16-14 18z" fill="#FF3B6B"/>` + vol(24, 24, 12) + `${[[18, 22], [24, 20], [30, 22], [20, 30], [28, 30], [24, 36]].map(p => `<ellipse cx="${p[0]}" cy="${p[1]}" rx="1" ry="1.6" fill="#FFE27A"/>`).join('')}<path d="M24 10l-5-5 1 6-6-2 4 4-6 2h24l-6-2 4-4-6 2 1-6z" fill="#34C759"/>`],
  ['orange', () => `<circle cx="24" cy="27" r="13.5" fill="#FF9F2E"/>` + vol(24, 27, 13.5) + `${[[18, 24], [27, 21], [30, 30], [20, 33], [25, 28]].map(p => `<circle cx="${p[0]}" cy="${p[1]}" r=".9" fill="#D97A12" opacity=".6"/>`).join('')}` + stem(24, 14, 4) + leaf(25, 12)],
  ['lemon', () => `<path d="M8 26c0-8 7-12 16-12s16 4 16 12-7 12-16 12S8 34 8 26z" fill="#FFE03B"/><ellipse cx="18" cy="22" rx="5" ry="2.6" fill="#fff" opacity=".3" transform="rotate(-15 18 22)"/><path d="M8 27a16 10 0 0 0 32 0z" fill="#000" opacity=".1"/><ellipse cx="7" cy="26" rx="2" ry="1.4" fill="#D9B800"/><ellipse cx="41" cy="26" rx="2" ry="1.4" fill="#D9B800"/>` + leaf(26, 13, '#4CAF50', 20)],
  ['watermelon', () => `<path d="M6 20a18 18 0 0 0 36 0z" fill="#3A9A3A"/><path d="M9 20a15 15 0 0 0 30 0z" fill="#C8F0A0"/><path d="M11 20a13 13 0 0 0 26 0z" fill="#FF4F6B"/>${[[18, 25], [26, 24], [22, 30], [30, 29], [16, 30]].map(p => `<ellipse cx="${p[0]}" cy="${p[1]}" rx="1.2" ry="1.9" fill="#1E1E24"/>`).join('')}<path d="M12 22a12 12 0 0 0 4 7" fill="none" stroke="#fff" stroke-width="2" stroke-opacity=".3" stroke-linecap="round"/>`],
  ['pineapple', () => `<path d="M24 4l5 8-5 2-5-2zM16 7l6 7-4 3zM32 7l-6 7 4 3zM12 12l8 5-3 4zM36 12l-8 5 3 4z" fill="#34C759"/><ellipse cx="24" cy="31" rx="11" ry="13" fill="#F5C542"/><path d="M15 24l18 14M15 38l18-14M20 19l12 24M28 19l-12 24M13 31h22" stroke="#C98B1E" stroke-width="1" stroke-opacity=".7"/>` + vol(24, 31, 11)],
  ['kiwi', () => `<circle cx="24" cy="26" r="14" fill="#6B4A2E"/><circle cx="24" cy="26" r="12.5" fill="#8BD64A"/><circle cx="24" cy="26" r="5" fill="#E9F7C8"/>${[0, 40, 80, 120, 160, 200, 240, 280, 320].map(a => `<ellipse cx="${24 + Math.cos(a * Math.PI / 180) * 8}" cy="${26 + Math.sin(a * Math.PI / 180) * 8}" rx="1" ry="1.7" fill="#1E1E24" transform="rotate(${a + 90} ${24 + Math.cos(a * Math.PI / 180) * 8} ${26 + Math.sin(a * Math.PI / 180) * 8})"/>`).join('')}`],
  ['peach', () => `<circle cx="24" cy="27" r="13" fill="#FFB07A"/><circle cx="24" cy="27" r="13" fill="#FF6E6E" opacity=".35"/><path d="M24 15q-3 8 0 24" fill="none" stroke="#C9553A" stroke-width="1.5" stroke-opacity=".5"/>` + vol(24, 27, 13) + stem(24, 14, 4) + leaf(25, 12)],
  ['plum', () => `<circle cx="24" cy="27" r="13" fill="#6E3FA0"/><path d="M24 15q-4 8-1 24" fill="none" stroke="#3A1F5E" stroke-width="1.5" stroke-opacity=".6"/>` + vol(24, 27, 13) + stem(24, 14, 5)],
  ['avocado', () => `<path d="M24 6c6 0 9 6 10 12 2 8 6 11 6 17a16 16 0 0 1-32 0c0-6 4-9 6-17 1-6 4-12 10-12z" fill="#3E7A2E"/><path d="M24 10c4 0 6 5 7 11 2 7 5 9 5 14a12 12 0 0 1-24 0c0-5 3-7 5-14 1-6 3-11 7-11z" fill="#C8E66A"/><circle cx="24" cy="34" r="6.5" fill="#8B5A2E"/><circle cx="22" cy="32" r="2" fill="#fff" opacity=".3"/>`],
  ['coconut', () => `<circle cx="24" cy="27" r="14" fill="#6B4A2E"/>` + vol(24, 27, 14) + `<circle cx="20" cy="22" r="2" fill="#3A2614"/><circle cx="28" cy="22" r="2" fill="#3A2614"/><circle cx="24" cy="29" r="2" fill="#3A2614"/><path d="M14 36q10 6 20 0" fill="none" stroke="#8B6A4E" stroke-width="1.2" stroke-opacity=".7"/>`],
  ['blueberry', () => `${[[16, 30], [32, 30], [24, 19]].map(p => `<circle cx="${p[0]}" cy="${p[1]}" r="8" fill="#3D5BD4"/>` + vol(p[0], p[1], 8) + `<path d="M${p[0] - 2.5} ${p[1] - 1}l2.5-2 2.5 2-1 3h-3z" fill="#1E2E7A"/>`).join('')}`],
  ['mango', () => `<path d="M14 14c8-6 20-4 24 6 3 8-2 18-12 20S8 34 8 24c0-4 2-7 6-10z" fill="#FFB020"/><path d="M14 14c8-6 20-4 24 6-6-4-16-4-24 0 0-2 0-4 0-6z" fill="#FF6B3B" opacity=".55"/><ellipse cx="18" cy="24" rx="5" ry="3" fill="#fff" opacity=".25" transform="rotate(-30 18 24)"/>` + stem(13, 14, 5) + leaf(14, 11, '#4CAF50', -20)],
  ['melon', () => `<path d="M6 18a18 18 0 0 0 36 0z" fill="#5BA83A"/><path d="M9 18a15 15 0 0 0 30 0z" fill="#E6F5C2"/><path d="M11 18a13 13 0 0 0 26 0z" fill="#B8E86A"/><path d="M24 18v13" stroke="#8BC34A" stroke-width="1" stroke-opacity=".6"/><path d="M12 20a12 12 0 0 0 4 7" fill="none" stroke="#fff" stroke-width="2" stroke-opacity=".3" stroke-linecap="round"/>`],
];
const ME_SETS = {
  neon: { label: 'Néons', faces: ME_NEON, emblem: '#FF5CE1', em: () => neon('M24 6l5.3 11.2 12.2 1.6-8.9 8.4 2.3 12.1L24 33.4l-10.9 5.9 2.3-12.1-8.9-8.4 12.2-1.6z', '#FF5CE1') },
  animals: { label: 'Animais', faces: ME_ANIMALS, emblem: '#3BE36B', em: () => `<path d="M14 18l1-9 8 5zM34 18l-1-9-8 5z" fill="#fff" opacity=".9"/><circle cx="24" cy="26" r="11" fill="#fff" opacity=".9"/><circle cx="20" cy="25" r="1.6" fill="#1E5A3A"/><circle cx="28" cy="25" r="1.6" fill="#1E5A3A"/><path d="M22.5 30h3l-1.5 2z" fill="#1E5A3A"/>` },
  fruits: { label: 'Frutos', faces: ME_FRUITS, emblem: '#FFB020', em: () => `<circle cx="24" cy="27" r="11" fill="#fff" opacity=".9"/><path d="M24 16q.5-4 3-6" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round"/><path d="M25 14c2-4 6-5 9-3-2 3-5 5-9 3z" fill="#fff" opacity=".9"/>` },
};
const meCard = (x, y, w, h, up, col, inner, id) => up ? `<rect x="${x + 1}" y="${y + 3}" width="${w}" height="${h}" rx="7" fill="#000" opacity=".4"/><rect x="${x}" y="${y}" width="${w}" height="${h}" rx="7" fill="#1A1C24"/><rect x="${x + .5}" y="${y + .5}" width="${w - 1}" height="${h - 1}" rx="6.5" fill="none" stroke="#fff" stroke-opacity=".12"/><g transform="translate(${x + w / 2 - 20} ${y + h / 2 - 20}) scale(.83)">${inner}</g>` : `<defs><linearGradient id="${id}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${shade(col, .2)}"/><stop offset="1" stop-color="${shade(col, -.45)}"/></linearGradient></defs><rect x="${x + 1}" y="${y + 3}" width="${w}" height="${h}" rx="7" fill="#000" opacity=".4"/><rect x="${x}" y="${y}" width="${w}" height="${h}" rx="7" fill="url(#${id})"/><path d="M${x} ${y + h / 2}l${w / 2} ${-h / 2}M${x} ${y + h}l${w} ${-h}M${x + w / 2} ${y + h}l${w / 2} ${-h / 2}" stroke="#fff" stroke-opacity=".14"/><rect x="${x + 4}" y="${y + 4}" width="${w - 8}" height="${h - 8}" rx="5" fill="none" stroke="#fff" stroke-opacity=".35"/>`;
Icons.app.memory = () => Icons.SVG(Icons.G('gMe', '#C27BF5', '#8A3FD1', '#5A1E99') +
  `<g transform="rotate(-12 34 52)">${meCard(16, 26, 36, 50, false, '#7A3FC9', '', 'gMeB')}</g><g transform="rotate(8 62 50)">${meCard(46, 22, 36, 50, true, '', ME_NEON[2][1](), 'gMeF')}</g>`);

Arcade.game('memory', {
  name: 'Memória', color: '#BF5AF2', kind: 'puzzle', lowerIsBetter: true, unit: 'jogadas', scoreLabel: 'Jogadas', bestLabel: 'Melhor', tags: ['Calma', 'Memória'],
  variants: [{ key: '8', label: '8 pares' }, { key: '12', label: '12 pares' }, { key: '18', label: '18 pares' }, { key: 'clock', label: 'Contra o relógio', lower: false, unit: 'pares' }],
  modes: [{ key: '8', label: '8 pares' }, { key: '12', label: '12 pares' }, { key: '18', label: '18 pares' }, { key: 'clock', label: 'Contra o relógio' }],
  desc: 'Encontra os pares com três conjuntos de cartas desenhadas: néons de Los Santos, animais e frutos. 8, 12 ou 18 pares, sequências com bónus, estrelas no resultado e um modo contra o relógio.',
  cover: () => {
    const f = [ME_NEON[0][1](), ME_NEON[4][1](), ME_NEON[11][1](), ME_NEON[2][1]()];
    return `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="cMe" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#3A1B6E"/><stop offset="1" stop-color="#14082E"/></linearGradient><radialGradient id="cMeG" cx=".5" cy=".5" r=".6"><stop offset="0" stop-color="#FF5CE1" stop-opacity=".25"/><stop offset="1" stop-color="#FF5CE1" stop-opacity="0"/></radialGradient></defs><rect width="400" height="200" fill="url(#cMe)"/><rect width="400" height="200" fill="url(#cMeG)"/>` +
      `<g transform="rotate(-10 90 100)">${meCard(60, 50, 64, 86, false, '#7A3FC9', '', 'cM1')}</g><g transform="rotate(-4 160 100)">${meCard(130, 46, 64, 86, true, '', f[1], 'cM2')}</g><g transform="rotate(3 230 100)">${meCard(200, 46, 64, 86, true, '', f[3], 'cM3')}</g><g transform="rotate(9 310 100)">${meCard(276, 52, 64, 86, false, '#7A3FC9', '', 'cM4')}</g></svg>`;
  },
  howto: { goal: 'Encontra todos os pares no menor número de jogadas.', steps: ['Vira duas cartas de cada vez', 'Se forem iguais ficam viradas; se não, voltam ao verso', 'Acertos seguidos dão sequência; contra o relógio, cada par vale e os baralhos não acabam'], controls: [{ icon: 'hand', label: 'Toca numa carta para a virar' }, { icon: 'gamepad', label: 'Setas e Enter no teclado' }] },
  build(win) {
    let G = null;
    const kill = () => { if (G) { G.kill(); G = null; } };
    const boot = mode => { kill(); G = makeGame(mode); };
    const makeGame = mode => {
      const clock = mode === 'clock', pairs = clock ? 12 : +mode;
      const board = 'memory:' + mode;
      const A = Arcade.shell(win, {
        id: board, name: 'Memória', color: '#BF5AF2', pausable: false, lowerIsBetter: !clock, unit: clock ? 'pares' : 'jogadas',
        scoreLabel: clock ? 'Pares' : 'Jogadas', bestLabel: clock ? 'Recorde' : 'Melhor', onRestart: () => start(true),
      });
      const bd = UI.el('<div class="me-board"></div>');
      A.el.stage.appendChild(bd);
      let setKey = Arcade.opt('memory:set', 'neon'); if (!ME_SETS[setKey]) setKey = 'neon';
      A.options([
        { key: 'mode', label: 'Modo', values: [{ v: '8', label: '8 pares' }, { v: '12', label: '12 pares' }, { v: '18', label: '18 pares' }, { v: 'clock', label: 'Relógio' }], cur: mode, onChange: v => { Arcade.setOpt('memory:mode', v); boot(v); } },
        { key: 'set', label: 'Cartas', values: Object.keys(ME_SETS).map(k => ({ v: k, label: ME_SETS[k].label })), cur: setKey, onChange: v => { setKey = v; Arcade.setOpt('memory:set', v); start(true); } },
      ]);
      const rec = recordWatch(A, board, !clock);

      let cards, open, moves, found, lock, t0 = 0, timer = null, cur = -1, ready = false, errors = 0, streak = 0, maxStreak = 0, decks = 0, left = 60, total = 0, cols = 4, gen = 0, ended = false;
      const clockMid = () => A.setMid(`<span class="gm-hint ${left <= 10 ? 'low' : ''}">${g('clock', 16)} <b>${left}s</b></span>`);
      const timeMid = () => A.setMid(`<span class="gm-hint">${g('clock', 16)} <b>${((Date.now() - t0) / 1000) | 0}s</b></span>`);
      const tickT = () => {
        if (clock) { left--; clockMid(); if (left <= 10 && left > 0) A.sfx('tick'); if (left <= 0) { stopT(); finishClock(); } }
        else timeMid();
      };
      const startT = () => { clearInterval(timer); timer = setInterval(tickT, 1000); win.timers.push(timer); };
      const stopT = () => { clearInterval(timer); timer = null; };

      let els = [];
      const buildBoard = fresh => {
        const set = ME_SETS[setKey];
        const frag = document.createDocumentFragment(); els = [];
        cards.forEach((c, i) => {
          const d = UI.el(`<div class="me-c${fresh ? ' in' : ''}"><div class="in"><div class="b"><svg viewBox="0 0 48 48" class="em">${set.em()}</svg></div><div class="f"><svg viewBox="0 0 48 48" class="spr">${c.face[1]()}</svg></div></div></div>`);
          if (fresh) d.style.animationDelay = (i * 22) + 'ms';
          d.onclick = () => { cur = i; flip(i); };
          els.push(d); frag.appendChild(d);
        });
        bd.innerHTML = ''; bd.appendChild(frag);
        bd.className = 'me-board p' + pairs + ' set-' + setKey;
      };
      const paint = () => { cards.forEach((c, i) => { const e = els[i]; e.classList.toggle('up', !!(c.up || c.done)); e.classList.toggle('done', !!c.done); e.classList.toggle('cur', i === cur); }); };
      const deal = () => {
        const set = ME_SETS[setKey].faces.slice();
        for (let i = set.length - 1; i > 0; i--) { const j = (Math.random() * (i + 1)) | 0; const t = set[i]; set[i] = set[j]; set[j] = t; }
        const pick = set.slice(0, pairs);
        const deck = pick.concat(pick).map(f => ({ face: f, up: false, done: false }));
        for (let i = deck.length - 1; i > 0; i--) { const j = (Math.random() * (i + 1)) | 0; const t = deck[i]; deck[i] = deck[j]; deck[j] = t; }
        cards = deck; open = []; found = 0; lock = false; cols = pairs === 18 ? 6 : 4;
      };
      const stars = () => (moves <= Math.ceil(pairs * 1.35) ? 3 : moves <= pairs * 2 ? 2 : 1);
      const flip = i => {
        if (lock || !ready || ended) return;
        const c = cards[i];
        if (c.up || c.done) return;
        if (!t0) { t0 = Date.now(); startT(); if (clock) clockMid(); }
        c.up = true; open.push(i); paint(); A.sfx('flip');
        if (open.length < 2) return;
        moves++; if (!clock) { A.setScore(moves); }
        const [a, b] = open;
        if (cards[a].face[0] === cards[b].face[0]) {
          cards[a].done = cards[b].done = true; open = []; found++; total++; streak++; if (streak > maxStreak) maxStreak = streak;
          if (clock) { A.setScore(total); rec.check(total); }
          els[a].classList.add('hit'); els[b].classList.add('hit');
          A.sfx('score'); paint();
          const el = els[b]; A.flash('Par!', 'pts', bd.offsetLeft + el.offsetLeft + el.offsetWidth / 2, bd.offsetTop + el.offsetTop);
          if (streak >= 2) { A.flash('Sequência x' + streak, 'bonus'); A.sfx('combo'); if (clock) { left += 2; clockMid(); A.flash('+2 s', 'pts', bd.offsetLeft + el.offsetLeft + el.offsetWidth / 2, bd.offsetTop + el.offsetTop + 30); } }
          if (found === pairs) {
            if (clock) { decks++; A.flash('Baralho novo!', 'big'); A.sfx('chime'); const myGen = gen; const t = setTimeout(() => { if (myGen !== gen || ended) return; deal(); buildBoard(true); paint(); }, 700); win.timers.push(t); return; }
            stopT(); ended = true;
            const secs = ((Date.now() - t0) / 1000) | 0, st = stars();
            if (errors === 0) Arcade.flag('memoryPerfect');
            A.flash('Todos os pares!', 'big'); celebrate(A, 'win');
            const myGen = gen;
            const t = setTimeout(() => { if (myGen !== gen) return; A.end({ title: 'Todos os pares!', sub: `${moves} jogadas · ${secs}s`, score: moves, win: true, stats: [{ label: 'Estrelas', value: st + ' de 3' }, { label: 'Erros', value: String(errors) }, { label: 'Sequência máxima', value: String(maxStreak) }, { label: 'Tempo', value: mmss(secs) }] }); }, 700); win.timers.push(t);
          }
          return;
        }
        lock = true; errors++; streak = 0; A.sfx('fail');
        els[a].classList.add('err'); els[b].classList.add('err');
        const t = setTimeout(() => { cards[a].up = cards[b].up = false; open = []; lock = false; els[a].classList.remove('err'); els[b].classList.remove('err'); paint(); }, 650); win.timers.push(t);
      };
      const finishClock = () => {
        ended = true; A.setScore(total);
        A.end({ title: 'Tempo esgotado', sub: `${total} pares em 60 s`, score: total, win: total > 0, stats: [{ label: 'Pares', value: String(total) }, { label: 'Baralhos completos', value: String(decks) }, { label: 'Sequência máxima', value: String(maxStreak) }, { label: 'Erros', value: String(errors) }] });
      };
      const start = async skipReady => {
        gen++; stopT(); t0 = 0; cur = -1; errors = 0; streak = 0; maxStreak = 0; decks = 0; left = 60; total = 0; moves = 0; ended = false;
        A.setId(board); rec.reset();
        deal();
        A.setScore(0); if (clock) clockMid(); else A.setMid(`<span class="gm-hint">${g('clock', 16)} <b>0s</b></span>`);
        buildBoard(true);
        if (!skipReady) { ready = false; await A.ready('Memória', clock ? 'Faz o máximo de pares em 60 segundos' : 'Vira duas cartas de cada vez e encontra os pares'); if (A.ended) return; }
        ready = true;
      };
      start();
      return {
        kill: stopT,
        pause: stopT, resume: () => { if (t0 && !ended) startT(); },
        key(e) {
          if (!ready) return;
          const n = cards.length, d = Arcade.keyDir(e);
          if (d) { e.preventDefault(); if (cur < 0) cur = 0; else { let r = (cur / cols) | 0, c = cur % cols; const rows = n / cols; if (d === 'u') r = (r + rows - 1) % rows; if (d === 'd') r = (r + 1) % rows; if (d === 'l') c = (c + cols - 1) % cols; if (d === 'r') c = (c + 1) % cols; cur = r * cols + c; } paint(); return; }
          if ((e.key === 'Enter' || e.key === ' ') && cur >= 0) { e.preventDefault(); flip(cur); }
        },
        dbg: { flip, state: () => ({ mode, pairs, moves, found, total, left, errors, streak, set: setKey }), pair: () => { if (!ready) return; const a = cards.findIndex(c => !c.done && !c.up); if (a < 0) return; const b = cards.findIndex((c, i) => i !== a && !c.done && !c.up && c.face[0] === cards[a].face[0]); flip(a); flip(b); }, miss: () => { if (!ready) return; const a = cards.findIndex(c => !c.done && !c.up); const b = cards.findIndex((c, i) => i !== a && !c.done && !c.up && c.face[0] !== cards[a].face[0]); flip(a); flip(b); }, solve: () => { if (!ready || ended) return; if (!t0) { t0 = Date.now(); } cards.forEach(c => { c.done = true; }); found = pairs; moves = Math.max(moves, pairs + 3); A.setScore(clock ? total : moves); paint(); stopT(); ended = true; if (clock) finishClock(); else A.end({ title: 'Todos os pares!', sub: `${moves} jogadas · 31s`, score: moves, win: true, stats: [{ label: 'Estrelas', value: stars() + ' de 3' }, { label: 'Erros', value: String(errors) }, { label: 'Sequência máxima', value: String(maxStreak) }, { label: 'Tempo', value: '0:31' }] }); } },
      };
    };
    let m0 = Arcade.opt('memory:mode', '8'); if (!/^(8|12|18|clock)$/.test(m0)) m0 = '8';
    boot(m0);
    win.onClose = kill;
    return { pause: () => G && G.pause(), resume: () => G && G.resume(), key: e => G && G.key(e), get dbg() { return G && G.dbg; }, reboot: boot };
  },
});
})();
