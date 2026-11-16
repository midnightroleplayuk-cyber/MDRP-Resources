/* ===================== PUZZLES (apex_phone 1.5.0, ronda 2) =====================
   Sudoku, Palavras, Solitario, Luzes Apagadas e Deslizante sobre a casca comum do games.js (Arcade.shell e as
   extensoes 1.5.0 / ronda 2: ready, options, flash, haptic, sfx, end com stats, celebrate, countdown, toast, howto).
   Carrega DEPOIS de games.js (e de games-board.js: os motores juntam-se em window.__gb.eng para os testes antigos).
   Estilos proprios em css/app-games-puzzle.css (.gpz- partilhado, .gsu- sudoku, .gwd- palavras, .gso- solitario,
   .gli- luzes, .gsl- deslizante). Ficheiro AUTONOMO: tem a sua copia dos utilitarios (X, Chrono, Cursor, rng);
   nada de partilhado com os outros ficheiros de jogos alem da casca.
   Regras do CEF cumpridas: zero requestAnimationFrame nos puzzles (so a animacao de vitoria do Solitario, numa
   camada canvas, que morre sozinha e em pausa/fecho), so transform e opacity animam, grelhas construidas UMA vez
   e atualizadas in place, posições do arrasto só por UI.vrect/UI.zoom (nunca o retângulo do browser), nada de emojis nem naipes
   Unicode (tudo SVG proprio), nada de travessoes.
   ============================================================================== */
(() => {
if (!window.Arcade || !window.App || !window.UI) return;
const g = UI.g, esc = UI.esc, el = UI.el;
const ENG = {};            /* motores de lógica pura (lidos pelos testes em Node: window.__gbp.eng) */
const LIVE = { game: null };

/* ---------- utilitários ---------- */
const SFX = { fail: 'nope', hit: 'pop', score: 'click', win: 'success', lose: 'error', tick: 'tick', move: 'tap', capture: 'pop', bad: 'nope', level: 'success', flip: 'tap', place: 'tap', slide: 'tap', chime: 'success', pop: 'tap', swish: 'tap', fail: 'nope' };
const snd = n => { try { Sound.play(SFX[n] || n); } catch (e) {} };
const sleep = ms => new Promise(r => setTimeout(r, ms));
const fmtT = s => { s = Math.max(0, s | 0); const m = (s / 60) | 0, x = s % 60; return m + ':' + (x < 10 ? '0' : '') + x; };
const rnd = n => (Math.random() * n) | 0;
const shuffle = a => { for (let i = a.length - 1; i > 0; i--) { const j = (Math.random() * (i + 1)) | 0; const t = a[i]; a[i] = a[j]; a[j] = t; } return a; };
/* gerador determinista (puzzles do dia): mulberry32 */
const mulberry = seed => { let s = seed | 0; return () => { s = s + 0x6D2B79F5 | 0; let t = Math.imul(s ^ s >>> 15, 1 | s); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; }; };
const shuffleR = (a, rng) => { for (let i = a.length - 1; i > 0; i--) { const j = (rng() * (i + 1)) | 0; const t = a[i]; a[i] = a[j]; a[j] = t; } return a; };
/* dia local (igual para todos no mesmo fuso) e número do dia desde 1 de janeiro de 2026 */
const dayIndex = () => { const d = new Date(); return Math.floor((d.getTime() - d.getTimezoneOffset() * 60000) / 86400000); };
const DAY0 = 20454;
const dayNo = () => Math.max(1, dayIndex() - DAY0 + 1);
/* SVG como imagem de fundo (ilustrações do Deslizante, capas): um nó por peça em vez de uma árvore por peça */
const svgUrl = s => 'url("data:image/svg+xml;charset=utf8,' + encodeURIComponent(s).replace(/'/g, '%27').replace(/\(/g, '%28').replace(/\)/g, '%29') + '")';
/* entrada em cascata (só na PRIMEIRA montagem): --d por peça, classe .enter que sai sozinha */
const cascade = (box, kids, step) => { kids.forEach((k, i) => k.style.setProperty('--d', (i * (step || 20)) + 'ms')); box.classList.add('enter'); setTimeout(() => box.classList.remove('enter'), kids.length * (step || 20) + 700); };
/* pequeno aviso DOM no palco (persistente uns instantes: aparece nas capturas, ao contrário do flash) */
const note = (host, msg, cls, ms) => { let n = host._gpzNote; if (!n) { n = el('<div class="gpz-note"></div>'); host.appendChild(n); host._gpzNote = n; } n.textContent = msg; n.className = 'gpz-note in ' + (cls || ''); clearTimeout(n._t); n._t = setTimeout(() => n.classList.remove('in'), ms || 1700); };
const plural = (n, um, muitos) => n + ' ' + (n === 1 ? um : muitos);
/* o RECORDE do HUD vem da casca em segundos crus: nos jogos de tempo mostra-se em m:ss (como o TEMPO) */
const bestFmt = A => { const b = A.el.best; const t = (b.textContent || '').trim(); if (/^\d+$/.test(t) && +t > 0) b.textContent = fmtT(+t); };

/* ---------- ponte para as extensões da casca (ronda 1 e ronda 2) ----------
   Tudo defensivo: se uma função faltar (casca antiga ou o HUB ainda a meio), há aqui a versão mínima. */
function X(A) {
  const stage = A.el.stage;
  return {
    ready(title, sub) {
      if (A.ready) return A.ready(title, sub);
      return new Promise(res => { const ov = el(`<div class="gpz-ready"><b>${esc(title || '')}</b><span>${esc(sub || 'Toca para começar')}</span></div>`); stage.appendChild(ov); ov.addEventListener('pointerdown', () => { ov.remove(); res(); }, { once: true }); });
    },
    options(list) {
      if (A.options) return A.options(list);
      let bar = A.el.ctl.querySelector('.gpz-opts'); if (!bar) { bar = el('<div class="gpz-opts"></div>'); A.el.ctl.appendChild(bar); }
      bar.innerHTML = '';
      list.forEach(o => { const b = el(`<div class="gpz-opt"><span>${esc(o.label)}</span><b></b></div>`); const paint = () => { const c = o.values.find(v => String(v.v) === String(o.cur)); b.querySelector('b').textContent = c ? c.label : ''; };
        b.onclick = async () => { const r = await UI.actionSheet({ title: o.label, buttons: o.values.map(v => ({ label: v.label, value: String(v.v) })) }); if (r === null || r === undefined) return; const v = o.values.find(z => String(z.v) === r); if (!v || String(v.v) === String(o.cur)) return; o.cur = v.v; paint(); o.onChange && o.onChange(v.v); };
        paint(); bar.appendChild(b); });
      return { set() {}, el: bar };
    },
    flash(msg, cls) { if (A.flash) return A.flash(msg, cls); const f = el(`<div class="gpz-flash ${cls || ''}">${esc(msg)}</div>`); stage.appendChild(f); setTimeout(() => f.remove(), 950); },
    haptic(k) { if (A.haptic) return A.haptic(k || 'light'); snd('move'); },
    sfx(n) { if (A.sfx) return A.sfx(n); snd(n); },
    end(o) { const r = A.end ? A.end(o) : A.gameOver(o.title, o.sub, o.score == null ? 0 : o.score); if (A._gpzTime) setTimeout(() => bestFmt(A), 40); return r; },
    celebrate(k) { if (A.celebrate) { try { A.celebrate(k); } catch (e) {} } },
    countdown(n) { if (A.countdown) { try { return Promise.resolve(A.countdown(n)); } catch (e) {} } return Promise.resolve(); },
    toast(msg) { if (A.toast) { try { A.toast(msg); return; } catch (e) {} } note(stage, msg, '', 1200); },
    howto() { if (A.howto) { try { A.howto(); } catch (e) {} } },
  };
}

/* ---------- cronómetro pausável (segundos inteiros; cb a cada meio segundo) ---------- */
function Chrono(win, cb) {
  let t0 = 0, acc = 0, iv = null;
  const secs = () => ((acc + (t0 ? Date.now() - t0 : 0)) / 1000) | 0;
  const api = {
    secs, get running() { return !!t0; },
    start() { if (t0) return; t0 = Date.now(); clearInterval(iv); iv = setInterval(() => cb(secs()), 500); win.timers.push(iv); cb(secs()); },
    stop() { if (t0) { acc += Date.now() - t0; t0 = 0; } clearInterval(iv); iv = null; },
    reset() { api.stop(); acc = 0; cb(0); },
    set(s) { api.stop(); acc = Math.max(0, s | 0) * 1000; cb(secs()); },
  };
  return api;
}

/* ---------- cursor de teclado comum (setas e WASD movem, Enter/Espaço escolhe, Escape limpa) ---------- */
function Cursor(cols, rows, onMove, onPick) {
  let r = -1, c = -1;
  return {
    get on() { return r >= 0; }, get idx() { return r < 0 ? -1 : r * cols + c; },
    set(i) { r = (i / cols) | 0; c = i % cols; onMove(r * cols + c); },
    clear() { r = -1; c = -1; onMove(-1); },
    resize(nc, nr) { cols = nc; rows = nr; r = -1; c = -1; onMove(-1); },
    key(e) {
      const k = e.key;
      const d = { ArrowUp: [0, -1], ArrowDown: [0, 1], ArrowLeft: [-1, 0], ArrowRight: [1, 0], w: [0, -1], s: [0, 1], a: [-1, 0], d: [1, 0], W: [0, -1], S: [0, 1], A: [-1, 0], D: [1, 0] }[k];
      if (d) { e.preventDefault(); if (r < 0) { r = (rows / 2) | 0; c = (cols / 2) | 0; } else { c = Math.max(0, Math.min(cols - 1, c + d[0])); r = Math.max(0, Math.min(rows - 1, r + d[1])); } onMove(r * cols + c); return true; }
      if ((k === 'Enter' || k === ' ') && r >= 0) { e.preventDefault(); onPick(r * cols + c); return true; }
      if (k === 'Escape') { r = -1; c = -1; onMove(-1); return true; }
      return false;
    },
  };
}

/* ---------- estatísticas locais por jogo (Store desta personagem) ---------- */
const stGet = (k, def) => { const v = Store.get(k, null); return v && typeof v === 'object' ? Object.assign({}, def, v) : Object.assign({}, def); };
const stSet = (k, v) => { try { Store.set(k, v); } catch (e) {} };
const pct = (a, b) => (b ? Math.round(a * 100 / b) : 0) + '%';

/* ---------- folha de estatísticas comum (números grandes + linhas) ---------- */
function statsSheet(title, tiles, rows) {
  const body = el(`<div class="gpz-stats"><div class="tiles">${tiles.map(t => `<div><b>${esc(String(t.v))}</b><span>${esc(t.l)}</span></div>`).join('')}</div>${rows && rows.length ? `<div class="rows">${rows.map(r => `<div class="r"><span>${esc(r.l)}</span><b>${esc(String(r.v))}</b></div>`).join('')}</div>` : ''}</div>`);
  UI.sheet({ title, body, right: 'OK' });
}

/* ---------- ícones (PearOS 27: camadas, degradê, sombra da silhueta, vidro da casca) ---------- */
const ico = (id, cols, body) => Icons.SVG(Icons.G(id, cols[0], cols[1], cols[2]) + `<radialGradient id="${id}h" cx="30%" cy="18%" r="70%"><stop offset="0" stop-color="#fff" stop-opacity=".28"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></radialGradient><rect width="100" height="100" fill="url(#${id}h)"/>` + body);
const shadowed = (inner, dy) => `<g transform="translate(0 ${dy || 2})" fill="#000" opacity=".22" stroke="#000">${inner}</g><g>${inner}</g>`;

/* =====================================================================
   SUDOKU: gerador com solução ÚNICA (grelha cheia por backtracking aleatório, depois retiram-se células
   verificando a unicidade com um solucionador de máscaras de bits), candidatos, conflitos e DICAS EXPLICADAS
   (único candidato, único lugar na linha/coluna/caixa, ou revelação).
   ===================================================================== */
ENG.sudoku = (() => {
  const RW = new Uint8Array(81), CL = new Uint8Array(81), BX = new Uint8Array(81), PEERS = [], UNITS = [];
  for (let i = 0; i < 81; i++) { RW[i] = (i / 9) | 0; CL[i] = i % 9; BX[i] = ((RW[i] / 3) | 0) * 3 + ((CL[i] / 3) | 0); }
  for (let i = 0; i < 81; i++) { const s = []; for (let j = 0; j < 81; j++) if (j !== i && (RW[i] === RW[j] || CL[i] === CL[j] || BX[i] === BX[j])) s.push(j); PEERS.push(s); }
  for (let u = 0; u < 9; u++) { UNITS.push({ kind: 'row', n: u, cells: Array.from({ length: 9 }, (_, k) => u * 9 + k) }); }
  for (let u = 0; u < 9; u++) { UNITS.push({ kind: 'col', n: u, cells: Array.from({ length: 9 }, (_, k) => k * 9 + u) }); }
  for (let u = 0; u < 9; u++) { const r0 = ((u / 3) | 0) * 3, c0 = (u % 3) * 3; UNITS.push({ kind: 'box', n: u, cells: Array.from({ length: 9 }, (_, k) => (r0 + ((k / 3) | 0)) * 9 + c0 + (k % 3)) }); }
  const ALL = 0x3FE;
  const bits = n => { let c = 0; while (n) { n &= n - 1; c++; } return c; };
  const solve = (grid, limit, rng, out) => {
    const rm = new Uint16Array(9), cm = new Uint16Array(9), bm = new Uint16Array(9), gdd = Uint8Array.from(grid);
    for (let i = 0; i < 81; i++) { const v = gdd[i]; if (!v) continue; const b = 1 << v; if ((rm[RW[i]] | cm[CL[i]] | bm[BX[i]]) & b) return 0; rm[RW[i]] |= b; cm[CL[i]] |= b; bm[BX[i]] |= b; }
    let found = 0;
    const rec = () => {
      let best = -1, bestN = 10, bestMask = 0;
      for (let i = 0; i < 81; i++) { if (gdd[i]) continue; const m = ALL & ~(rm[RW[i]] | cm[CL[i]] | bm[BX[i]]); const n = bits(m); if (n < bestN) { bestN = n; best = i; bestMask = m; if (n <= 1) break; } }
      if (best < 0) { found++; if (out && found === 1) out.set(gdd); return; }
      if (!bestMask) return;
      const digits = []; for (let d = 1; d <= 9; d++) if (bestMask & (1 << d)) digits.push(d);
      if (rng) shuffleR(digits, rng);
      for (const d of digits) {
        const b = 1 << d; gdd[best] = d; rm[RW[best]] |= b; cm[CL[best]] |= b; bm[BX[best]] |= b;
        rec();
        rm[RW[best]] &= ~b; cm[CL[best]] &= ~b; bm[BX[best]] &= ~b; gdd[best] = 0;
        if (found >= limit) return;
      }
    };
    rec(); return found;
  };
  const countSolutions = (grid, limit) => solve(grid, limit || 2, null, null);
  const TARGET = { facil: 40, medio: 32, dificil: 27, perito: 24 };
  const LEVELS = ['facil', 'medio', 'dificil', 'perito'];
  /* rng opcional (puzzle do dia); duas passagens de remoção para os níveis mais vazios */
  const generate = (level, rng) => {
    rng = rng || Math.random;
    const solution = new Uint8Array(81); solve(new Uint8Array(81), 1, rng, solution);
    const puzzle = Uint8Array.from(solution), target = TARGET[level] || TARGET.medio, t0 = performance.now();
    let givens = 81;
    for (let pass = 0; pass < 2 && givens > target; pass++) {
      const order = shuffleR(Array.from({ length: 81 }, (_, i) => i), rng);
      for (const i of order) {
        if (givens <= target || performance.now() - t0 > 900) break;
        if (!puzzle[i]) continue;
        const v = puzzle[i]; puzzle[i] = 0;
        if (countSolutions(puzzle, 2) !== 1) puzzle[i] = v; else givens--;
      }
    }
    return { puzzle, solution, level, givens };
  };
  const valid = grid => { if (grid.length !== 81) return false; for (let i = 0; i < 81; i++) { const v = grid[i]; if (!v || v > 9) return false; for (const j of PEERS[i]) if (grid[j] === v) return false; } return true; };
  /* candidatos de cada casa vazia com os valores atuais */
  const cands = v => { const out = new Uint16Array(81); for (let i = 0; i < 81; i++) { if (v[i]) continue; let m = ALL; for (const j of PEERS[i]) if (v[j]) m &= ~(1 << v[j]); out[i] = m; } return out; };
  /* conflitos: casas com o mesmo valor na mesma linha, coluna ou caixa */
  const conflicts = v => { const out = new Uint8Array(81); for (let i = 0; i < 81; i++) { if (!v[i]) continue; for (const j of PEERS[i]) if (v[j] === v[i]) { out[i] = 1; break; } } return out; };
  const log2 = m => { for (let d = 1; d <= 9; d++) if (m === (1 << d)) return d; return 0; };
  /* dica explicada: { kind, i, d, unit? } */
  const hint = (v, s) => {
    for (let i = 0; i < 81; i++) if (v[i] && v[i] !== s[i]) return { kind: 'wrong', i, d: s[i], cells: [i] };
    const C = cands(v);
    let bestI = -1, bestN = 10;
    for (let i = 0; i < 81; i++) { if (v[i]) continue; const n = bits(C[i]); if (n === 1 && log2(C[i]) === s[i]) return { kind: 'naked', i, d: s[i], cells: PEERS[i] }; if (n < bestN) { bestN = n; bestI = i; } }
    for (const u of UNITS) {
      let has = 0; for (const i of u.cells) if (v[i]) has |= 1 << v[i];
      for (let d = 1; d <= 9; d++) { if (has & (1 << d)) continue; let only = -1, n = 0; for (const i of u.cells) if (!v[i] && (C[i] & (1 << d))) { n++; only = i; } if (n === 1 && s[only] === d) return { kind: u.kind, i: only, d, cells: u.cells, n: u.n }; }
    }
    if (bestI < 0) return null;
    return { kind: 'reveal', i: bestI, d: s[bestI], cells: [bestI] };
  };
  const hintText = h => {
    if (!h) return '';
    const d = h.d;
    if (h.kind === 'wrong') return 'Este número está errado: o certo é o ' + d + '.';
    if (h.kind === 'naked') return 'Único candidato: nesta casa só cabe o ' + d + '. Os outros números já estão na linha, na coluna ou na caixa.';
    if (h.kind === 'row') return 'Único lugar: nesta linha, o ' + d + ' só pode ficar aqui.';
    if (h.kind === 'col') return 'Único lugar: nesta coluna, o ' + d + ' só pode ficar aqui.';
    if (h.kind === 'box') return 'Único lugar: nesta caixa, o ' + d + ' só pode ficar aqui.';
    return 'Sem técnica simples aqui: o ' + d + ' fica revelado.';
  };
  return { generate, countSolutions, valid, cands, conflicts, hint, hintText, RW, CL, BX, PEERS, UNITS, TARGET, LEVELS };
})();

Icons.app.sudoku = () => ico('gSu', ['#6FE8A8', '#1FA86A', '#0B5E3C'], shadowed(
  `<rect x="19" y="19" width="62" height="62" rx="9" fill="none" stroke="#fff" stroke-width="3.4"/><path d="M39.7 19v62M60.3 19v62M19 39.7h62M19 60.3h62" stroke="#fff" stroke-width="2.2" opacity=".8"/>`) +
  `<rect x="41.5" y="41.5" width="17" height="17" rx="3" fill="#FFF8C2" opacity=".95"/>` +
  `<path d="M27 26.5h5.5v11M48 48.5h5l-5 7.5h5M70 26.5l-6 11h8M26.5 69.5a3 3 0 1 1 3 3v2" fill="none" stroke="#fff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/>` +
  `<circle cx="70.5" cy="70.5" r="4.2" fill="#fff"/><circle cx="30" cy="50" r="2.4" fill="#fff" opacity=".7"/><circle cx="70" cy="50" r="2.4" fill="#fff" opacity=".7"/><circle cx="50" cy="29" r="2.4" fill="#fff" opacity=".7"/><circle cx="50" cy="71" r="2.4" fill="#fff" opacity=".7"/>`);

const SUDOKU_COVER = () => `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="gsuCb" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#0E3D2B"/><stop offset="1" stop-color="#061A12"/></linearGradient><radialGradient id="gsuCg" cx="30%" cy="40%" r="70%"><stop offset="0" stop-color="#2BD68A" stop-opacity=".35"/><stop offset="1" stop-color="#2BD68A" stop-opacity="0"/></radialGradient></defs><rect width="400" height="200" fill="url(#gsuCb)"/><rect width="400" height="200" fill="url(#gsuCg)"/>` +
  `<g transform="translate(40 16) skewY(-6)"><rect x="0" y="0" width="168" height="168" rx="10" fill="#0B1F17" stroke="#9EE7C4" stroke-width="2.5"/>${[1, 2, 4, 5, 7, 8].map(k => `<path d="M${k * 56 / 3} 0v168M0 ${k * 56 / 3}h168" stroke="#2E5B48" stroke-width="1"/>`).join('')}<path d="M56 0v168M112 0v168M0 56h168M0 112h168" stroke="#9EE7C4" stroke-width="2"/>` +
  `<rect x="56" y="56" width="18.7" height="18.7" fill="#1FA86A" opacity=".8"/><rect x="0" y="56" width="168" height="18.7" fill="#1FA86A" opacity=".16"/><rect x="56" y="0" width="18.7" height="168" fill="#1FA86A" opacity=".16"/>` +
  `<g font-family="Inter, system-ui, sans-serif" font-weight="700" font-size="14" fill="#fff" text-anchor="middle">${[[0, 0, 5], [2, 0, 3], [4, 0, 7], [7, 0, 1], [1, 1, 6], [5, 1, 9], [8, 1, 5], [0, 2, 9], [3, 2, 8], [6, 2, 6], [2, 3, 1], [6, 3, 3], [0, 4, 4], [4, 4, 5], [8, 4, 1], [3, 5, 2], [7, 5, 6], [1, 6, 7], [5, 6, 4], [8, 6, 8], [2, 7, 3], [4, 7, 1], [7, 7, 9], [0, 8, 2], [6, 8, 5]].map(([c, r, d]) => `<text x="${c * 18.67 + 9.3}" y="${r * 18.67 + 14}">${d}</text>`).join('')}<text x="65.3" y="70" fill="#8CF0A6" font-size="15">7</text></g></g>` +
  `<g transform="translate(250 50)" font-family="Inter, system-ui, sans-serif" font-weight="800" fill="#fff">${[1, 2, 3, 4, 5, 6, 7, 8, 9].map((d, k) => `<rect x="${(k % 3) * 40}" y="${((k / 3) | 0) * 40}" width="34" height="34" rx="8" fill="${d === 7 ? '#1FA86A' : 'rgba(255,255,255,.1)'}"/><text x="${(k % 3) * 40 + 17}" y="${((k / 3) | 0) * 40 + 23}" font-size="17" text-anchor="middle">${d}</text>`).join('')}</g></svg>`;

Arcade.game('sudoku', {
  name: 'Sudoku', color: '#1FA86A', kind: 'puzzle', lowerIsBetter: true, unit: 'segundos', scoreLabel: 'Tempo', bestLabel: 'Melhor',
  variants: [{ key: 'facil', label: 'Fácil' }, { key: 'medio', label: 'Médio' }, { key: 'dificil', label: 'Difícil' }, { key: 'perito', label: 'Perito' }],
  desc: 'Puzzles sempre com solução única em quatro dificuldades. Notas a lápis, realces, conflitos, dicas explicadas, verificação, puzzle do dia e estatísticas por nível.',
  tags: ['Lógica', 'Clássico', 'Diário'], modes: [{ key: 'free', label: 'Novo puzzle' }, { key: 'daily', label: 'Puzzle do dia' }],
  cover: SUDOKU_COVER,
  howto: { goal: 'Preenche a grelha para que cada linha, coluna e caixa 3×3 tenha os números de 1 a 9 sem repetir.', steps: ['Toca numa casa vazia e escolhe o número no teclado.', 'Com Notas ligadas, os números ficam a lápis como candidatos.', 'A Dica explica a técnica e aplica o número; Verificar assinala o que está errado.'], controls: [{ icon: 'hand', label: 'Toca na casa e no número' }, { icon: 'move', label: 'Setas movem, 1 a 9 escrevem, N notas, Z desfaz' }] },
  build(win) {
    const S = ENG.sudoku, LV = { facil: 'Fácil', medio: 'Médio', dificil: 'Difícil', perito: 'Perito' }, SAVE = 'gpzSudoku', DAILY = 'gpzSudokuDaily', STATS = 'gpzSudokuStats';
    let level = Arcade.opt('sudoku:lv', 'medio'); if (!LV[level]) level = 'medio';
    let limit = Arcade.opt('sudoku:err', '3') !== '0';
    let modeDaily = Arcade.opt('sudoku:mode', 'free') === 'daily';
    const A = Arcade.shell(win, { id: 'sudoku:' + level, name: 'Sudoku', color: '#1FA86A', pausable: true, scoreLabel: 'Tempo', bestLabel: 'Melhor', lowerIsBetter: true, onRestart: () => fresh(), onPause: () => { wrap.classList.add('paused'); T.stop(); }, onResume: () => { wrap.classList.remove('paused'); if (Z && !over && started) T.start(); } });
    const x = X(A), stage = A.el.stage; stage.style.position = 'relative';
    const wrap = el(`<div class="gsu-wrap gpz-hide"><div class="gsu-grid">${Array.from({ length: 81 }, (_, i) => `<div class="gsu-c${i % 9 === 2 || i % 9 === 5 ? ' br' : ''}${((i / 9) | 0) === 2 || ((i / 9) | 0) === 5 ? ' bb' : ''}" data-i="${i}"><b></b><span class="n">${'<i></i>'.repeat(9)}</span></div>`).join('')}</div>
      <div class="gsu-pad">${[1, 2, 3, 4, 5, 6, 7, 8, 9].map(d => `<div class="gsu-k" data-d="${d}"><b>${d}</b><small></small></div>`).join('')}</div>
      <div class="gsu-exp"><div class="gsu-exp-ic">${g('bulb', 20)}</div><div class="gsu-exp-t"></div><div class="gsu-exp-ok">Aplicar</div><div class="gsu-exp-x">${g('x', 16)}</div></div></div>`);
    stage.appendChild(wrap);
    const grid = wrap.querySelector('.gsu-grid'), cells = [...wrap.querySelectorAll('.gsu-c')], keys = [...wrap.querySelectorAll('.gsu-k')], exp = wrap.querySelector('.gsu-exp'), expT = wrap.querySelector('.gsu-exp-t');
    cells.forEach(c => { const i = +c.dataset.i; c.style.setProperty('--w', ((S.RW[i] + S.CL[i]) * 28) + 'ms'); });
    A.el.ctl.innerHTML = `<div class="gpz-tools"><div class="gpz-tool" data-k="notes">${g('pen', 20)}<span>Notas\u200b</span></div><div class="gpz-tool" data-k="erase">${g('backspace', 20)}<span>Apagar</span></div><div class="gpz-tool" data-k="undo">${g('arrowL', 20)}<span>Desfazer</span></div><div class="gpz-tool" data-k="hint">${g('bulb', 20)}<span>Dica</span></div><div class="gpz-tool" data-k="check">${g('check', 20)}<span>Verificar</span></div><div class="gpz-tool" data-k="stats">${g('chart', 20)}<span>Resumo</span></div></div>`;
    const tb = k => A.el.ctl.querySelector('.gpz-tool[data-k="' + k + '"]');
    const bNotes = tb('notes'), bErase = tb('erase'), bUndo = tb('undo'), bHint = tb('hint'), bCheck = tb('check'), bStats = tb('stats');

    let Z = null, sel = -1, notes = false, over = true, hist = [], hints = 0, started = false, checked = new Uint8Array(81), conf = new Uint8Array(81), curHint = null, daily = false, firstMount = true;
    A._gpzTime = true;
    const T = Chrono(win, s => { A.setScore(s); A.el.score.textContent = fmtT(s); bestFmt(A); });
    const label = () => LV[Z.level];
    const mid = () => A.setMid(`<span class="gm-hint gpz-pill">${daily ? g('calendar', 15) : ''}${esc(label())}</span><span class="gm-hint gpz-pill ${Z.err ? 'bad' : ''}">Erros <b>${limit ? Z.err + '/3' : Z.err}</b></span>`);
    const save = () => { try { Store.set(SAVE, over ? null : { level: Z.level, daily, day: dayIndex(), p: Array.from(Z.p), s: Array.from(Z.s), v: Array.from(Z.v), n: Array.from(Z.n), err: Z.err, secs: T.secs(), hints }); } catch (e) {} };
    const paintCell = i => {
      const c = cells[i], v = Z.v[i], txt = v ? String(v) : '';
      const b = c.firstChild; if (b.textContent !== txt) b.textContent = txt;
      const m = v ? 0 : Z.n[i]; if (c._m !== m) { c._m = m; const ns = c.lastChild.children; for (let d = 1; d <= 9; d++) ns[d - 1].textContent = (m & (1 << d)) ? d : ''; }
      const wrong = !!v && !Z.p[i] && v !== Z.s[i];
      c.classList.toggle('given', !!Z.p[i]); c.classList.toggle('err', wrong && (limit || !!checked[i])); c.classList.toggle('conf', !!conf[i]);
    };
    const paintSel = () => { const sv = sel >= 0 ? Z.v[sel] : 0; for (let i = 0; i < 81; i++) { const c = cells[i]; c.classList.toggle('sel', i === sel); c.classList.toggle('peer', sel >= 0 && i !== sel && (S.RW[i] === S.RW[sel] || S.CL[i] === S.CL[sel] || S.BX[i] === S.BX[sel])); c.classList.toggle('same', !!sv && i !== sel && Z.v[i] === sv); } };
    const paintKeys = () => { const cnt = new Array(10).fill(0); for (let i = 0; i < 81; i++) if (Z.v[i] && Z.v[i] === Z.s[i]) cnt[Z.v[i]]++; keys.forEach(k => { const d = +k.dataset.d, left = 9 - cnt[d]; k.classList.toggle('done', left <= 0); k.lastChild.textContent = left > 0 ? left : ''; }); bNotes.classList.toggle('on', notes); bUndo.classList.toggle('off', !hist.length || over); bErase.classList.toggle('off', over || sel < 0 || !!Z.p[sel]); bHint.classList.toggle('off', over); bCheck.classList.toggle('off', over); };
    const paintConf = () => { conf = S.conflicts(Z.v); };
    const paintAll = () => { paintConf(); for (let i = 0; i < 81; i++) paintCell(i); paintSel(); paintKeys(); mid(); };
    const push = () => { hist.push({ v: Uint8Array.from(Z.v), n: Uint16Array.from(Z.n), err: Z.err }); if (hist.length > 120) hist.shift(); };
    const stats = () => stGet(STATS, {});
    const lvStats = (lv, st) => Object.assign({ played: 0, won: 0, best: 0, noErr: 0, time: 0 }, (st || stats())[lv] || {});
    const addStat = (lv, won, secs, noErr) => { const st = stats(), s = lvStats(lv, st); s.played++; if (won) { s.won++; s.time += secs; if (!s.best || secs < s.best) s.best = secs; if (noErr) s.noErr++; } st[lv] = s; stSet(STATS, st); return s; };
    const hideExp = () => { exp.classList.remove('in'); if (curHint) { cells.forEach(c => c.classList.remove('tgt', 'unit')); curHint = null; } };
    const finishWin = () => {
      over = true; T.stop(); hideExp(); Store.set(SAVE, null); A.setId('sudoku:' + Z.level);
      const secs = T.secs(), noErr = Z.err === 0;
      const s = addStat(Z.level, true, secs, noErr);
      if (daily) stSet(DAILY, Object.assign({}, stGet(DAILY, {}), { [Z.level]: { day: dayIndex(), secs, err: Z.err } }));
      if (noErr) Arcade.flag('sudokuNoErr'); if (Z.level === 'perito') Arcade.flag('sudokuExpert');
      grid.classList.add('win'); x.sfx('chime'); x.flash('Resolvido!', 'big'); x.celebrate('win'); paintKeys(); mid();
      setTimeout(() => x.end({ title: daily ? 'Puzzle do dia resolvido' : 'Resolvido', sub: `${label()}${hints ? ' · ' + plural(hints, 'dica', 'dicas') : ''}${noErr ? ' · sem erros' : ''}`, score: secs, win: true,
        stats: [{ label: 'Tempo', value: fmtT(secs) }, { label: 'Erros', value: String(Z.err) }, { label: 'Dicas', value: String(hints) }, { label: 'Melhor ' + label(), value: s.best ? fmtT(s.best) : fmtT(secs) }] }), 1100);
    };
    const finishLose = () => { over = true; T.stop(); hideExp(); Store.set(SAVE, null); addStat(Z.level, false, T.secs(), false); x.sfx('lose'); x.haptic('heavy'); paintKeys(); setTimeout(() => x.end({ title: 'Três erros', sub: 'Tenta outra vez', score: 0, win: false, submit: false, stats: [{ label: 'Tempo', value: fmtT(T.secs()) }, { label: 'Dificuldade', value: label() }, { label: 'Dicas', value: String(hints) }] }), 500); };
    const checkWin = () => { if (Z.v.every((v, i) => v === Z.s[i])) { finishWin(); return true; } return false; };
    const put = (d, viaHint) => {
      if (over || sel < 0 || Z.p[sel]) return;
      if (!started) { started = true; T.start(); }
      if (notes && !viaHint) { if (Z.v[sel]) return; push(); Z.n[sel] ^= (1 << d); paintCell(sel); x.sfx('tick'); save(); return; }
      if (Z.v[sel] === d) return;
      push(); Z.v[sel] = d; Z.n[sel] = 0; checked[sel] = 0;
      const c = cells[sel]; c.classList.remove('pop'); void c.offsetWidth; c.classList.add('pop');
      if (d === Z.s[sel]) { for (const j of S.PEERS[sel]) if (Z.n[j] & (1 << d)) { Z.n[j] &= ~(1 << d); paintCell(j); } x.sfx('place'); }
      else { Z.err++; x.sfx('fail'); c.classList.remove('shake'); void c.offsetWidth; c.classList.add('shake'); x.haptic('medium'); if (limit) x.flash(Z.err >= 3 ? 'Terceiro erro' : 'Erro', 'warn'); if (limit && Z.err >= 3) { paintAll(); finishLose(); return; } }
      paintAll(); save();
      checkWin();
    };
    const erase = () => { if (over || sel < 0 || Z.p[sel] || (!Z.v[sel] && !Z.n[sel])) return; push(); Z.v[sel] = 0; Z.n[sel] = 0; checked[sel] = 0; paintAll(); x.haptic('light'); save(); };
    const undo = () => { if (!hist.length || over) return; const h = hist.pop(); Z.v = h.v; Z.n = h.n; Z.err = h.err; hideExp(); paintAll(); x.haptic('light'); save(); };
    const showHint = () => {
      if (over) return;
      const h = S.hint(Z.v, Z.s); if (!h) return;
      hideExp(); curHint = h; sel = h.i; paintSel(); paintKeys();
      (h.cells || []).forEach(i => cells[i].classList.add('unit')); cells[h.i].classList.add('tgt');
      expT.textContent = S.hintText(h); exp.classList.add('in'); x.sfx('tick');
    };
    const applyHint = () => {
      if (!curHint || over) return; const h = curHint; hideExp();
      if (!started) { started = true; T.start(); }
      hints++; T.set(T.secs() + 30); T.start(); x.flash('+30 s', 'warn'); x.sfx('score');
      sel = h.i; notes = false; put(h.d, true);
    };
    const verify = () => {
      if (over) return; let wrong = 0, filled = 0;
      for (let i = 0; i < 81; i++) { if (Z.p[i] || !Z.v[i]) continue; filled++; if (Z.v[i] !== Z.s[i]) { wrong++; checked[i] = 1; cells[i].classList.remove('shake'); void cells[i].offsetWidth; cells[i].classList.add('shake'); } }
      paintAll();
      if (!filled) note(stage, 'Ainda não escreveste nada', '', 1500);
      else if (wrong) { note(stage, wrong === 1 ? 'Um número errado assinalado' : wrong + ' números errados assinalados', 'bad', 1800); x.sfx('fail'); }
      else { note(stage, 'Tudo certo até agora', 'good', 1500); x.sfx('score'); }
    };
    const select = i => { sel = i; paintSel(); paintKeys(); };
    grid.addEventListener('click', e => { const c = e.target.closest('.gsu-c'); if (!c || over) return; if (curHint && +c.dataset.i !== curHint.i) hideExp(); select(+c.dataset.i); x.sfx('tick'); });
    wrap.querySelector('.gsu-pad').addEventListener('click', e => { const k = e.target.closest('.gsu-k'); if (k) put(+k.dataset.d); });
    bNotes.onclick = () => { if (over) return; notes = !notes; paintKeys(); x.haptic('light'); };
    bErase.onclick = erase; bUndo.onclick = undo; bHint.onclick = showHint; bCheck.onclick = verify;
    exp.querySelector('.gsu-exp-ok').onclick = applyHint; exp.querySelector('.gsu-exp-x').onclick = hideExp;
    bStats.onclick = () => {
      const st = stats(); const rows = S.LEVELS.map(lv => { const s = lvStats(lv, st); return { l: LV[lv], v: s.played ? `${s.won}/${s.played} · melhor ${s.best ? fmtT(s.best) : '--'}` : 'Ainda sem partidas' }; });
      const all = S.LEVELS.reduce((a, lv) => { const s = lvStats(lv, st); a.played += s.played; a.won += s.won; a.noErr += s.noErr; return a; }, { played: 0, won: 0, noErr: 0 });
      statsSheet('Sudoku', [{ v: all.played, l: 'Puzzles' }, { v: pct(all.won, all.played), l: 'Resolvidos' }, { v: all.noErr, l: 'Sem erros' }], rows);
    };

    const load = (z, saved) => {
      Z = { level: z.level, p: Uint8Array.from(z.puzzle), s: Uint8Array.from(z.solution), v: Uint8Array.from(saved ? saved.v : z.puzzle), n: saved ? Uint16Array.from(saved.n) : new Uint16Array(81), err: saved ? saved.err | 0 : 0 };
      hist = []; sel = -1; over = false; hints = saved ? saved.hints | 0 : 0; started = !!saved; checked = new Uint8Array(81); hideExp(); grid.classList.remove('win');
      A.setId('sudoku:' + Z.level); T.set(saved ? saved.secs | 0 : 0); if (saved) T.start();
      wrap.classList.remove('gpz-hide'); paintAll();
      if (firstMount) { firstMount = false; cascade(grid, cells, 6); }
    };
    const dailySeed = lv => dayIndex() * 4 + S.LEVELS.indexOf(lv);
    const fresh = () => {
      T.stop(); Store.set(SAVE, null); daily = modeDaily;
      if (daily) {
        const done = stGet(DAILY, {})[level];
        if (done && done.day === dayIndex()) { const z = S.generate(level, mulberry(dailySeed(level))); load(z); Z.v = Uint8Array.from(Z.s); over = true; T.set(done.secs | 0); paintAll(); bHint.classList.add('off'); bCheck.classList.add('off'); UI.toast('Puzzle do dia já resolvido. Volta amanhã'); return; }
        load(S.generate(level, mulberry(dailySeed(level))));
      } else load(S.generate(level));
      started = true; T.set(0); T.start();
    };
    const resume = () => {
      const sv = Store.get(SAVE, null);
      if (sv && LV[sv.level] && Array.isArray(sv.p) && sv.p.length === 81 && Array.isArray(sv.s) && sv.s.length === 81 && Array.isArray(sv.v) && sv.v.length === 81 && (!sv.daily || sv.day === dayIndex())) { level = sv.level; daily = !!sv.daily; load({ level: sv.level, puzzle: sv.p, solution: sv.s }, sv); opts.set('lv', level); UI.toast('Puzzle anterior retomado'); return; }
      fresh();
    };
    const opts = x.options([
      { key: 'lv', label: 'Dificuldade', values: S.LEVELS.map(k => ({ v: k, label: LV[k] })), cur: level, onChange: async v => { if (!over && started && Z && Z.v.some((q, i) => q && !Z.p[i]) && !await UI.confirm('Novo puzzle', 'Perdes o progresso deste.', 'Novo', true)) { opts.set('lv', level); return; } level = v; Arcade.setOpt('sudoku:lv', v); fresh(); } },
      { key: 'mode', label: 'Modo', values: [{ v: 'free', label: 'Novo puzzle' }, { v: 'daily', label: 'Puzzle do dia' }], cur: modeDaily ? 'daily' : 'free', onChange: v => { modeDaily = v === 'daily'; Arcade.setOpt('sudoku:mode', v); fresh(); } },
      { key: 'err', label: 'Erros', values: [{ v: '3', label: 'Máximo 3' }, { v: '0', label: 'Sem limite' }], cur: limit ? '3' : '0', onChange: v => { limit = v !== '0'; Arcade.setOpt('sudoku:err', v); if (Z) { paintAll(); if (limit && !over && Z.err >= 3) finishLose(); } } },
    ]);
    (async () => { await x.ready('Sudoku', 'Toca para começar'); resume(); })();
    win.onClose = () => { T.stop(); if (Z && !over) save(); };
    const api = {
      pause() { T.stop(); if (Z && !over) save(); }, resume() { if (Z && !over && started && !A.paused) T.start(); },
      key(e) {
        if (!Z || over) return;
        if (/^[1-9]$/.test(e.key)) { e.preventDefault(); put(+e.key); return; }
        if (e.key === 'Backspace' || e.key === 'Delete' || e.key === '0') { e.preventDefault(); erase(); return; }
        if (e.key === 'n' || e.key === 'N') { bNotes.click(); return; }
        if (e.key === 'z' || e.key === 'Z') { undo(); return; }
        if (e.key === 'h' || e.key === 'H') { if (curHint) applyHint(); else showHint(); return; }
        if (e.key === 'v' || e.key === 'V') { verify(); return; }
        if (e.key === 'Escape' && curHint) { hideExp(); return; }
        const d = { ArrowUp: -9, ArrowDown: 9, ArrowLeft: -1, ArrowRight: 1 }[e.key];
        if (d != null) { e.preventDefault(); if (sel < 0) select(40); else { const n = sel + d; if (n >= 0 && n < 81 && !((d === 1 && sel % 9 === 8) || (d === -1 && sel % 9 === 0))) select(n); } }
      },
      test: { get Z() { return Z; }, put, select, fresh, setTime(s) { T.set(s); T.start(); started = true; }, setLevel(lv, dly) { level = lv; modeDaily = !!dly; opts.set('lv', lv); opts.set('mode', dly ? 'daily' : 'free'); fresh(); }, erase, undo, hint: showHint, applyHint, verify, get over() { return over; }, get hint_() { return curHint; }, notesOn(v) { notes = !!v; paintKeys(); }, pause: () => A.pause(true),
        solveTo(left) { for (let i = 0; i < 81 && Z.v.filter((v, k) => v === Z.s[k]).length < 81 - left; i++) if (!Z.v[i] || Z.v[i] !== Z.s[i]) { Z.v[i] = Z.s[i]; Z.n[i] = 0; } paintAll(); } },
    };
    LIVE.game = api; return api;
  },
});

/* =====================================================================
   PALAVRAS: dicionários embutidos. ANS = respostas possíveis (palavras comuns); MORE = outras aceites como tentativa.
   Inglês e português sem acentos (a chave de jogo); as formas portuguesas COM acento estão em WD_PT_ACC, mais abaixo.
   ===================================================================== */
const WD_EN_ANS = `
abbey abide about above abuse actor acute adapt admit adopt adore adult after again agent agile aging agree ahead aisle alarm album alert alien align alike alive alley allow alloy alone along aloud alpha altar alter amaze amber amend among ample amuse angel anger angle angry ankle annex annoy apart apple apply apron arena argue arise armor aroma array arrow ashes aside asset atlas attic audio audit avoid await awake award aware awful
bacon badge badly bagel baker balmy banjo barge basic basil basin basis batch beach beard beast began begin begun being belly below bench berry bible birth black blade blame bland blank blast blaze bleak blend bless blind blink bliss block blond blood bloom blown blues blunt blurt blush board boast bonus boost booth bored bound boxer brace braid brain brake brand brass brave bread break breed brick bride brief bring brink brisk broad broke brook broom brown brush buddy budge build built bulky bully bunch bunny burly burnt burst buyer
cabin cable cache cadet camel candy canoe canon cargo carol carry carve catch cater cause cease cedar chain chair chalk champ chant chaos charm chart chase cheap cheat check cheek cheer chess chest chick chief child chill chime china chirp choir choke chord chose chunk churn cider cigar civic civil claim clamp clash clasp class clean clear clerk click cliff climb cling clock clone close cloth cloud clown clubs clung coach coast cobra cocoa colon color comet comic coral couch cough could count court cover crack craft cramp crane crash crate crawl crazy cream creek creep crept crest crime crisp crook cross crowd crown crude cruel crumb crush crust curly curry curse curve cycle
daily dairy daisy dance dated dealt death debut decay decor decoy delay delta demon dense depot depth derby deter devil diary digit diner dirty disco ditch diver dizzy dodge doing donor donut doubt dough dozen draft drain drake drama drank drape drawl drawn dread dream dress dried drift drill drink drive droop drove drown drunk dryer duchy dully dummy dusty dutch dwarf dwell dying
eager eagle early earth easel eaten ebony edict eerie eight eject elbow elder elect elite elope elude email ember empty enact endow enemy enjoy enter entry envoy epoxy equal equip erase erode error erupt essay ethic evade event every evict exact exalt excel exert exile exist extra
fable facet faint fairy faith false fancy fatal fault favor feast fence ferry fetch fever fiber field fiery fifth fifty fight filth final finch first fishy fixed flair flake flame flank flash flask fleet flesh flick fling flint flirt float flock flood floor flora flour flown fluff fluid flung flush flute foamy focal focus foggy folly force forge forgo forth forty forum found foyer frail frame frank fraud freak fresh friar fried frill frost froth frown froze fruit fudge fully fungi funny furry fuzzy
gamma gauge gaunt gavel gecko genre ghost giant giddy given giver glade gland glare glass glaze gleam glide glint gloom glory gloss glove gnome going goose gorge gouge gourd grace grade graft grain grand grant grape graph grasp grass grave gravy graze great greed green greet grief grill grime grind groan groin groom grope gross group grove growl grown gruel grunt guard guess guest guide guild guilt guise gulch gummy guppy gusto gusty gypsy
habit hairy happy hardy harsh haste hasty hatch haunt haven havoc hazel heard heart heavy hedge hefty heist hello hence heron hinge hippo hobby hoist holly honey honor horse hotel hound house hover human humid humor hunch hurry husky hydro hyena
icing ideal idiom idiot igloo image imply inbox index indie inept inert infer inlet inner input irony issue itchy ivory
jaunt jazzy jelly jerky jewel joint joker jolly joust judge juice juicy jumbo jumpy
karma kayak kebab khaki kiosk kitty knack kneel knelt knife knock knoll known koala
label labor laden ladle lager lance lanky lapse large laser latch later latte laugh layer leafy leaky leapt learn lease leash least leave ledge legal lemon leper level lever light liken lilac limbo limit linen liner lingo lipid liver llama lobby local locus lodge lofty logic login loose lorry loser lotus lousy lover lower loyal lucid lucky lumpy lunar lunch lunge lying lyric
macho madam magic magma major maker mambo mango manor maple march marry marsh mason match mayor meaty medal media medic melon mercy merge merit merry messy metal meter midst might mimic mince miner minor minty minus mirth miser mixer model modem moist molar money month moody moose moral morph mossy motel motor motto mound mount mourn mouse mouth mover movie mower muddy mummy munch mural murky mushy music musty
naive nanny nasal nasty naval navel needy nerdy nerve never newer newly nicer niche niece night ninja ninth noble noise noisy nomad noose north notch novel nudge nurse nutty nylon nymph
oasis occur ocean octet oddly offer often olive omega onion onset opera optic orbit order organ other otter ought ounce outer ovary overt owner oxide ozone
paddy pagan paint panel panic pansy paper parka parry party pasta paste pasty patch patio pause payer peace peach pearl pedal penal penny perch peril perky pesto petal petty phase phone photo piano piece piety piggy pilot pinch piney pinky pious pitch pivot pixel pizza place plaid plain plane plank plant plate plaza plead pleat plier pluck plumb plume plump plunk plush poach point poise poker polar polka polyp pooch poppy porch poser posse pouch pound power prank prawn press price pride prime primo print prior prism privy prize probe prone proof prose proud prove prowl proxy prune psalm pudgy pulse punch pupil puppy puree purge purse pushy
quack quail quake qualm quart quash queen queer query quest queue quick quiet quill quilt quirk quite quota quote
rabbi rabid racer radar radio rainy raise rally ranch range rapid raspy ratio raven rayon razor reach react ready realm rebel rebut recap recur refer regal rehab reign relax relay relic remit renal renew repay repel reply rerun reset resin retro retry reuse revel rhino rhyme rider ridge rifle right rigid rigor rinse ripen risen risky rival river roast robin robot rocky rodeo rogue roost rotor rouge rough round rouse route rover rowdy royal ruddy rugby ruler rumor rural rusty
sadly safer saint salad sales salon salsa salty sandy sassy satin sauce saucy sauna savor savvy scald scale scalp scant scare scarf scary scene scent scoff scold scone scoop scope score scorn scout scowl scrap scrub seedy segue seize sense serum serve setup seven sever sewer shack shade shady shaft shake shaky shall shame shape share shark sharp shave shawl shear sheen sheep sheer sheet shelf shell shift shine shiny shirt shock shone shook shoot shore short shout shove shown showy shred shrub shrug shunt shush sight sigma silky silly since sinew siren sixth sixty skate skier skill skimp skirt skull skunk slack slain slant slash slate sleek sleep sleet slept slice slick slide slime slimy sling slope sloth slump slung slurp slush slyly smack small smart smash smear smell smile smirk smith smoke smoky snack snail snake snaky snare sneak sneer snide sniff snore snort snout snowy snuck soapy sober soggy solar solid solve sonar sonic sooth sorry sound south space spade spare spark spasm spawn speak spear speck speed spell spend spent sperm spice spicy spied spiel spike spill spine spiny spire spite splat split spoil spoke spoof spook spool spoon spore sport spout spray spree sprig spunk spurn spurt squad squat squid stack staff stage staid stain stair stake stale stalk stall stamp stand stank stark start stash state stave stead steak steal steam steed steel steep steer stern stick stiff still sting stink stint stock stoic stoke stole stomp stone stony stood stool stoop store stork storm story stout stove strap straw stray strip strut stuck study stuff stump stung stunk stunt style suave sugar suite sulky sunny super surge surly sushi swamp swarm swear sweat sweep sweet swell swept swift swine swing swirl swish swoop sword swore sworn swung syrup
table tacit taffy taken taker tally talon tango tangy taper tardy taste tasty tatty taunt tawny teach tease teddy teeth tempo tenor tense tenth tepid terse thank theft their theme there these thick thief thigh thing think third thong thorn those three threw throb throw thumb thump tiara tidal tiger tight tilde timer timid tipsy titan title toast today toddy token tonal tonic tooth topaz topic torch torso total totem touch tough towel tower toxic toxin trace track tract trade trail train trait tramp trash trawl tread treat trend triad trial tribe trick tried tripe trite troll troop trout truce truck truly trump trunk truss trust truth tryst tulip tummy tumor tunic turbo tutor twang tweak tweed tweet twice twine twirl twist tying
udder ulcer ultra umbra uncle uncut under undue unfed unfit unify union unite unity unlit unmet untie until unwed unzip upper upset urban usage usher using usual utter
vague valet valid valor value valve vapor vault vegan venom venue verge verse verve vicar video vigil vigor villa vinyl viola viper viral virus visit visor vista vital vivid vixen vocal vodka vogue voice voter vouch vowel
wacky wafer wager wagon waist waive waltz warty waste watch water waver waxen weary weave wedge weedy weigh weird welsh whale wharf wheat wheel whelp where which whiff while whine whiny whirl whisk white whole whose widen wider widow width wield wight willy wimpy wince winch windy wiser witch witty woken woman women woody wooly woozy wordy world worry worse worst worth would wound woven wrath wreak wreck wrest wring wrist write wrong wrote wrung
yacht yearn yeast yield young youth yummy
zebra zesty zonal
`;
const WD_EN_MORE = `
aback abase abate abbot abhor abler abode abort abyss ached aches acids acorn acrid acted adage added adder addle adept adieu admin adobe adorn aegis aerie affix afire afoot afoul agate agave agony aider ailed aimed aired alder algae alibi aloft aloof amass amble amity amour anime anise annul antic anvil aorta aphid aping apnea apter arbor ardor areas argon arson artsy ascot ashen askew asses atoll atone attar augur aunts aunty avail avert avian awash awoke axial axiom axion azure
babes backs baggy bails baits baled bales balls balms bands bangs banks barbs bards bared barer barks barns baron barre based baser bases basks baste bated bathe baton batty bawdy bayou beads beady beaks beams beans bears beats beaus beech beefy beeps beers beets befit begat beget begot beige belch belie belle bells belts bends bents beret berth beset bevel bezel bided bides bikes biles bilge bills bimbo binds binge bingo biome biped birch birds bison bites bitsy bitty blabs blare bleat bleed bleep blimp blips blitz bloat blobs blocs blogs bloke blots bluff blurb blurs boars boats bobby bodes bogey boggy bogus boils bolts bombs bonds boned bones bongo bonny books booms boons boors boots booze boozy borax borne bosom bossy botch bough boule bourn bouts bowed bowel bowls boxed boxes brags brats brawl brawn brays bream bribe brims brine briny broil brood brows bruin brunt brute bucks buffs bugle bulbs bulge bulks bulls bumps bungs bunks bunts buoys burgh burps burro buses bushy busts butch butte buxom bylaw bytes
cabal cabby cacao cacti caddy cadre cafes caged cages cairn cakes calfs calls calms calve camps canal caned canes canny canto caped caper capes capon cards cared cares caret carps carts cased cases casks caste casts catty caulk caved caves cavil cedes cello cells cents chafe chaff chaps chars chasm cheep chefs chews chewy chide chili chimp chins chips chits chive chock choky chomp chops chuck chuff chugs chump chute cinch circa cited cites civet clack clads clams clang clank claps claws clays cleat clefs cleft clime cline clips cloak clods clogs clomp clops clots clout clove cluck clued clues clump coals coats cocky codas coded coder codes coils coins colds colic colts comas combo combs comfy comma conch condo coned cones conic cooed cooks cools coops coots coped copes copra copse cords cored cores corks corns corny corps costs coupe coups coven coves covet covey cowed cower coyly crabs crags crank crape craps crass crave craws craze creak credo creed creel crepe cress crews cribs crick cried crier cries crimp croak crock croft crone crony crops crows cruet crypt cubed cubes cubic cubit cuffs culls cumin cupid curbs curds cured curer cures curio curls curvy cushy cusps cuter cutie cycad cynic
dados daffy dales dames damns damps dared dares darns darts dates datum daunt davit dawns deals deans dears deary debit debts decaf decal decks deeds deems deeps deers defer deify deign deism deity dekes delve demur dents desks deuce dials diced dices dicey dided dikes dills dimes dimly dined dines dingo dingy dinky diode dirge discs dishy disks ditto ditty divan dived dives divot docks dodgy doers doffs doges dogma doily doled doles dolls dolly domed domes dooms doped dopes dopey dorks dorky dorms dosed doses doted dotes dotty dowdy dowel downy dowry dowse doyen dozed dozes drabs drags drams drats drays dregs dribs drier dries drips droid droll drone drool drops dross drubs drugs druid drums dryad dryly ducal ducat ducks ducts dudes duels duets duffs dukes dulls dumbo dumps dunce dunes dungs dunks duped dupes dusks dusts duvet dwelt dyers dykes
eared earls earns eased eases eaves ebbed eclat edged edger edges edify eggar egged egret eider eking elate elegy elfin elide elves embed emcee emery emits emoji ended endue enema ennui ensue envoi eosin epees ephor epics epoch equid erect ergot erred ester ether ethos etude evens evoke ewers exams exude exult eying eyrie
faced faces facts faded fades fails fairs fakes fakir falls famed fangs fanny farce fared fares farms fasts fatty fauna fauns fawns fazed fears fecal feces feeds feels feign feint fella fells felon felts femur fends feral ferns fetal fetid fetus feuds fewer fiats fiche fiefs fiend fifes filch filed filer files filet fills films filmy finds fined finer fines finis fiord fired fires firms firth fists fitly fiver fives fizzy fjord flabs flack flags flail flaky flaps flats flaws flays fleas fleck flees flier flies flips flits floes flogs flops floss flows flubs flues fluke fluky flume flunk fluxe flyer foals foams foils foist folds folio folks fonts foods fools foots foray fords forks forms forts fouls fount fours fowls foxes frays freed freer frees frier fries frisk fritz frizz frock frogs fumed fumes funds funks funky furls furor fused fuses fussy fusty futon fuzed fuzes
gabby gable gaffe gaffs gages gaily gains gaits galas gales galls gamed gamer games gamut gangs gaped gapes garbs gases gasps gassy gated gates gator gauze gauzy gawks gawky gayer gazed gazer gazes geeks geeky geese gelds gents germs getup ghoul gifts gilds gills gilts gimpy girls girth gists glads glean glens glibs glitz globs glued gluey gluts gnarl gnash gnats gnaws goads goals goats godly golfs golly gonad goner gongs goods goody gooey goofs goofy gooks goons gored gores gorse gouty gowns grabs grads grams grana grays greys grids grimy grins gripe grips grist grits groat grogs groks grots grout grows grubs gruff gulfs gulls gulps gumbo gunks gunky gurus gushy gusts gutsy guyed gybes
hacks hafts haiku hails hairs hajji hakes hales halls halos halts halve hands handy hangs hanks hards hared harem hares harks harms harps harpy harts hasps hated hater hates hauls hawks hazed hazes heads heals heaps hears heath heats heave heeds heels hefts heirs helix hells helms helps hemps henna herbs herds heros hewed hewer hexed hexes hicks hides highs hikes hilly hilts hinds hints hired hires hives hoard hoary hobos hocks holds holed holes homed homer homes homey hones honks hooch hoods hooey hoofs hooks hooky hoops hoots hoped hopes horde horns horny hosed hoses hosts hotly hours hovel howdy howls hubby huffs huffy hulks hulls humps humus hunks hunts hurls hurts hushy husks hutch hymen hymns
ichor icier icily icons idled idler idles idols idyll imbue impel inane inapt incur indue inked inlay inset inter intro inure iotas irate irked irons islet items
jabot jacks jaded jades jails jambs jammy japan japes jawed jeans jeeps jeers jello jells jemmy jerks jests jetty jibed jibes jiffy jilts jimmy jinks jived jives jocks johns joins joist jokes jolts jotas jowls joyed judos jugum juked jukes julep jumps junks junky junta juror jutes
kales kapok kappa karat karts kayos kazoo keels keens keeps kelps kempt kerbs kerfs ketch keyed khans kicks kicky kiddo kiddy kills kilns kilos kilts kinda kinds kings kinks kinky kirks kiwis klutz knead kneed knees knell knits knobs knots knows koans kooks kooky kraal kraut krill kudos kudzu
laced laces lacks laded lades lairs laity lakes lambs lamed lamer lames lamps lanai lands lanes lapel lards lardy lares larks larva lasso lasts lathe laths latke lauds lawns laxer lazed lazes leach leads leafs leaks leans leaps leeks leers lefts lefty legit lemur lends lento levee lewis lexis liars libel licit licks liege liens lifer lifts liked liker likes limbs limed limes limns limos limps lined lines lints lions lisps lists lithe lived liven lives livid loads loafs loams loamy loans loath lobed lobes locks lodes lofts logos loins lolls loner longs looks looms loons loony loops loopy loots loped lopes lords lores loris lotto louse louts loved loves lowed lowly lucre lulls lumen lumps lupus lurch lured lures lurid lurks lusts lusty lutes lymph lynch
maced macer maces macro madly mafia mages magna magus maids mails maims mains maize males malls malts mamas mamba mamma manes mange mangy mania manic manly manna manse mares marks marls marts masks massy masts mated mates matte mauls mauve maven mavin maxed maxim maxis mazes meads meals means meant meats mecca meets melds melee melts memos mends menus meows mesas meshy metes metro mewed mewls micas micro middy midge miens miffs miked mikes milch miler miles milks milky mills mimed mimes mimsy minds mined mines minim minis minks mints mired mires mirza misdo mists misty miter mites mitts mixed mixes moans moats mocha mocks modal modes modus moggy mogul mohel molds moldy moles molls molts momma mommy monks mooed moons moors moots moped mopes mopey morel mores morns moron motes moths motif motte motts moult mousy moved moves mowed mucks mucky mucus muffs mufti muggy mulch mules mulls mumps muons mured mures murks mused muser muses musks musky mutes mutts muzzy mylar mynah myrrh myths
nabob nacho nadir naiad nails named namer names napes nappy narcs nards nares narks natal natty naves navvy nears neath necks needs neigh neons nerds nests newel newsy newts nexus nicad nicks nifty nines nippy niter nitro nitty nixed nixes nobby nodal nodes noels noggs nohow noire nooks noons norms nosed noses nosey noted noter notes nouns novae novas nubby nuder nudes nuked nukes nulls numbs
oaken oakum oared oases oaten oaths obeah obese obeys obits oboes ocher ochre octal odder odium odors offal offed ogled ogler ogles ogres oiled oiler oinks okapi okays okras olden older oldie oleos ombre omens omits oozed oozes opals opens opine opium opted orals orate orcas oriel ortho osier ouija ousts outdo outed outgo ovals ovate ovens ovoid ovule owing owned oxbow oxeye
paced pacer paces packs pacts padre paean paged pager pages pails pains pairs paled paler pales palls palmy palsy panda panes pangs pants papal papas papaw pappy parch pared parer pares parks parse parts pasha pasts pates paths patsy patty paved paver paves pawed pawls pawns payee peaks peals pears pease peats peaty pecan pecks peeks peels peeps peers peeve pekoe pelts pence pends penne peons peony peppy perks perms pesky pesos pests peter petit pewee phage phial phlox phony phyla picks picky piers piing piked piker pikes pilaf piled piles pills pimps pined pines pings pinks pinto pints pinup piped piper pipes pipit pique pitas piths pithy piton pixie plait plans plash plasm plats platy playa plays pleas plebe plied plies plods plonk plops plots plows ploys plugs plums pocks poems poesy poets poked pokes pokey poled poles polio polls pomps ponds pones poofs pools poops popes poppa pored pores porks porky ports posed poses posit posts potty poufs pours pouts prams prate prays preen preps preys prick pricy pried prier pries prigs primp prink prion prods proem profs promo proms prong props prosy prows prude pshaw psych pubic pucks puffs puffy puked pukes pulls pulps pulpy pumas pumps punks punky punts pupae pupal pupas purer purls purrs putts putty pygmy pylon pyres pyxie
quads quaff quark quasi quays quean quell quids quiff quins quint quips quipu quire quirt quits quoit quoth
raced races racks radii radix radon rafts raged rages raids rails rains rajah raked rakes ralph ramps randy rangy ranks rants raped rapes rared rarer rares rasps rated rater rates ratty raved ravel raver raves rawer razed razes readd reads reams reaps rearm rears rebar rebid rebus recon recta recto recut redid redly redox reeds reedy reefs reeks reels reeve refit reify reins rends rents repot resat rests retch revue rheum ricks rides rifer riffs rifts riled riles rills rimed rimes rinds rings rinks riots riper riser rises risks rites ritzy rived riven rives rivet roach roads roams roans roars robed robes rocks roger roils roles rolls roman romps roods roofs rooks rooms roomy roots roped ropes rosed roses rosin rotas roust routs roved roves rowed rowel rower rubes ruble ruder ruffs ruing ruins ruled rules rumba rummy rumps runes rungs runic runny runts rupee ruses rushy rusks rusts
saber sable sabre sacks safes sagas sager sages saggy sahib sails saith salal sally salts salve salvo samba sands saner sappy sarge saris satay sated sates satyr saute saved saver saves sawed sawer saxes scabs scads scaly scamp scams scans scape scars scats schmo schwa scion scoot scour scram scree screw scrim scrip scrod scrum scuba scuds scuff sculk scull scums scurf seals seams seamy sears seats sects sedan seder sedge seeds seeks seems seeps seers seine selfs sells semen semis sends senna sepal sepia septa serfs serge serif sewed sexed sexes shags shahs shako shale shalt shams shank shard sheaf sheds sheik shied shies shill shims shins ships shire shirk shivs shoal shoed shoes shoos shops shorn shots shows shrew shuck shuns shuts shyer shyly sibyl sicko sided sides sidle siege sieve sifts sighs signs silks sills silos silts silty singe sings sinks sinus sired sires sirup sisal sissy sitar sited sites situp sixes sized sizer sizes skeet skein skews skids skied skies skiff skims skins skint skips skits skulk slabs slags slake slams slang slaps slats slave slaws slays sleds slews slier slims slink slips slits slobs sloes slogs sloop slops slosh slots slows slued slues slugs slums slunk slurs sluts slyer smelt smite smock smogs smote smuts snafu snags snaps snarl snipe snips snits snobs snogs snoop snoot snots snows snubs snuff snugs soaks soaps soars socks sodas sofas softy soils soled soles solos songs soots sooty sophs sored sorer sores sorts souls soups soupy sours souse sowed sower spake spang spank spans spars spate spats spays specs spelt spews spick spies spiky spilt spins spits splay spoor spots sprat spuds spume spurs squab squaw squib stabs stags staph stare stars stats stays stein stems steno steps stews stied sties stile stilt stirs stoat stops stoup stows strep strew strop strum stubs studs stuns styes styli sucks sudsy suede suing suits sulks sully sumac sumps sunup surfs swabs swags swain swami swank swans swaps sward swash swath swats sways swigs swill swims swipe swiss swoon swops sylph synch syncs synod
tabby taboo tabor tacks tacky tacos tails taint takes tales talks talky tamed tamer tames tamps tangs tanks tansy taped tapes tapir tared tares tarns taros tarot tarps tarry tarts taupe taxed taxer taxes taxis teaks teals teams tears teary teats techs teems teens teeny telex tells telly tempi temps tempt tends tenet tenon tents tepee terms terns terra terry tests testy texts thane thaws theta thine thins throe thrum thuds thugs thyme tibia ticks tided tides tiers tiffs tikes tiled tiler tiles tills tilts timed times tined tines tinge tings tinny tints tired tires tiros tithe titty tizzy toads toady toffy togas toils toked tokes tolls tombs tomes toned toner tones tonga tongs tools toots toped toper topes topis toque torte torts torus toted totes tours touts towed towns toyed trams traps trays treed trees treks tress trews trice trier tries trike trill trims trios trips tromp trope troth trots trove trued truer trues tubal tubas tubby tubed tuber tubes tucks tufts tulle tumid tunas tuned tuner tunes tunny turds turfs turfy turns tusks tutus tuxes twain twerp twigs twill twins twits tykes typed types typos tyros
ulnae ulnar ulnas umbel umber umiak umped unapt unarm unary unbar unbox uncap uncos undid unfix ungot unhip units unlet unman unpeg unpin unrig unsay unset unsew unwon upend upped ureas urged urges urine users usurp usury uteri utile uvula
vagus vails vales vamps vanes vapid vases vasts vaunt veals veeps veers veils veins veiny velar velds veldt venal vends vents verbs verso vests vetch vexed vexes vials viand vibes vices views viler vines viols vireo visas vised vises vizor voids voila voile voles volts vomit voted votes vowed vroom vulva vying
wacko waded wader wades wadis wafts waged wages waifs wails waits waked waken wakes waled wales walks walls wands waned wanes wanly wants wards wares warms warns warps warts washy wasps watts waved waves waxed waxes weald weans wears weeds weeks weeny weeps weepy weirs welds wells welts wench wends wetly whack whams whats wheal whelk whets whims whips whirr whist whits whizz whomp whoop whops whore whorl wifey wilds wiles wills wilts wimps winds wined wines wings winks winos wiped wiper wipes wired wires wisps wispy withe withy wives wizen wolfs wombs wonks wonky woods wooed wooer woofs words works worms wormy wowed wrack wraps wrapt wrens wrier writs wryer wryly
xenon xerox xylem
yahoo yanks yards yarns yawed yawls yawns yeahs years yells yelps yenta yerba yeses yetis yikes yodel yogas yogic yogis yoked yokel yokes yolks yoofs yours yowls yucca yucks yucky yukky yuppy
zappy zebus zeros zests zilch zincs zings zingy zippy zloty zombi zoned zones zooms zoril
`;
const WD_PT_ANS = `
abafo abalo abate aboio abono abril abrir acaso aceno aceso achar acido acima acola actor acudo acusa adega adeus adiar adubo aereo afago afeto afiar afins agora aguar agudo aguia ainda ajuda alado aleia alelo aleta algar algum aliar alias altar aluno amado amago ambar ambos ameba ameno amido amigo amora amplo andar andor anexo animo ansia antes anual anzol aonde apego apelo apito apoio aquem arado arame araro arder ardor areal areia arena arido aroma arpao arroz artes asilo aspas assar assim astro atado atear ativo atlas atomo atras atrio atriz atual atuar audio aulas aureo autor avaro avela aviao avido aviso axila azedo
babar bacia bacon bafio bagem bagos baile baixa baixo balao balas balde balsa bambu banal banca banco banda bando banha banho banir barba barco bardo barra barro basta bater batom bazar beber beico beijo beira bemol bento berco berma berro besta betao bicha bicho bidao bilha bingo birra bisca bispo bloco blusa boato bocal boiao boina bolha bolor bolsa bomba bonde bonus borda bordo borra bosta botao braco brado brasa bravo brejo breve briga brisa brita broca brota bruma bruto bruxa bucha bucho bufao bulha bunda burla burro busca busto
cabal cabra cacau cacho cacto caixa calao calar calca calco caldo calha calma calor calvo campa campo canal canil canja canoa canta canto capaz cardo carga caril carma carne carpa carro carta casal casca casco casta catar cauda caule causa cavar cedro cegar ceifa celta censo cento cerca cerco cerne certo cesta cesto cetim chaga chale chama chapa chato chave chefe cheio chico china chore chupa chuto chuva ciclo cifra cinco cinta cinto cinza circo cirio cisne citar claro clero clima clone clube cobra cobre cofre coice coisa colar colmo comer comum conde conta conto coral corda corja corno coroa corpo corte costa couro couve coxia cozer crase cravo credo creme crepe crime crina crise cromo cueca culpa culto cunha curar curso curto curva cuspo custo
dalia danca dardo dedal deixa delta dente desde deusa dever diabo dieta digno dique disco ditar dizer dobra docil dogma doido dolar domar dorso dreno droga dueto duplo duque
edito elite enfim entao entre envio epico epoca errar estar estio etapa etica exame exato exito extra
facho facil facto faina faixa falar falha falso fardo farol farpa farto fatia fauna favor fazer febre fecho feira feito feixe feliz femea fenda ferir ferro festa fiado fibra ficar ficha filao filho filme final firma fisco fixar flora fluir fluxo focar fogao foice folga folha folia fonte forca forja forma forno forro forte fosco fosso fraco frade fraga frase freio frete frota fruta fruto fugaz fugir fumar fundo funil furar furia fusao fuzil
gaita galho gamao ganho ganso garfo garra gasto geada gelar gemeo gemer genio genro gente geral gerar gerir gesso gesto ginja girar globo golfe golpe gordo gorro gosto grade grama grato grave greve grifo grilo gripe grito grupo gruta gueto guiar guizo
habil haste haver heroi hiato hiena hifen homem honra horda horta hoste hotel humor humus
icone idade ideia idolo idoso igual ileso impar indio irado irmao
jacto jarra jarro jaula jeito jejum jogar jovem judeu julho junho junta junto jurar juros justo
labio lacre ladra lagar lagoa lanca lance lapis largo larva lasca latao latir lavar lazer lebre legal leigo leite lenco lenda lenha lente lento leque lesao lesma leste letal letra levar lhama libra licao lider ligar limao limbo limpo linda lindo linha linho lista litro livre livro local lombo longe lotar louco loura lousa lugar lunar lutar
macho macio magia magoa magro maior malha malta mamae mamar manco manga manha manso manta manto marca marco massa matar medir meigo melao melro menor menos mente mesmo metal metro mexer milho mimar minar minha miolo mirar missa misto mocho moeda molde molho monge monte morar morno morsa morte mosca motor mover mudar mudez muito mundo museu musgo
nacao nadar naipe nariz natal navio negar negro nervo nevar ninho nivel nobre nocao nodoa noite noiva noivo norma norte nosso nunca nuvem
obvio ocaso odiar oeste olhar oliva ombro ontem opaco opcao opera optar ordem orgao ostra ousar outro ouvir oxido
padre pagar palco palha palma palmo papel parar parte parto parvo passe passo pasta patio pauta pavao pavio pavor pecar pedal pedir pedra pegar peito peixe penal penso pente perda perna perto pesar pesca peste piada piano picar pilar pilha pinga pinha pinta pires pisar pista placa plano plebe pleno pluma pobre podar poder poema poeta polen polvo pomar pombo ponta ponte ponto porao porca porco porta porte porto posar posse posto pouco praca praga praia prata prato prazo preco prego preso preto prima primo prova prumo pudor pulga pulso punho puxar
quase queda quilo quina quota
racao radar radio raiva ralar ramal rampa rapaz rasgo raspa rasto razao reino relva remar renda resto retro rezar rimar risco ritmo rival rocha rodar rogar rolar rolha rombo ronda rosca rosto roubo roupa rubro ruela rugir ruido ruina rumor rural russo
saber sabio sabor sacar safra saida salao salmo salsa salto salva salvo santo sarar sarda saude sauna seara secar segar seita seiva selar selva senda senha senso serao serio serra sesta setor sexta sexto sigla silva sinal sismo sitio sobra sobre socio sogra sogro solar solda solto somar sonda sonho sopro sorte sotao suave subir sueco sujar sumir surdo surfe surto susto sutil
tabua tacho talao talco talho tampa tango tanto tapar tarde tarte tasca tecer tecla tecto teima telha temer tempo tenaz tenda tenis tenro tenso terco terno terra teste texto tigre tinta tirar toada tocar tocha toldo tomar tombo tonel tonto topar toque torre torta tosse touca touro traco trago traje trama trapo trato trave trena treno trevo tribo trigo tripa troca trono tropa trote trufa tumor tunel turma turno turvo tutor
uivar umido uniao unico unido urina usina usual utero
vadio vagar valer valor valsa vapor varal vasto vazio veado velar velho venda vento verao verba verbo verde verme verso vespa veste vetor vidro viela vigia vinco vinho vinte viola virar virus visao visor visto vital viuva viver vogal volta vosso vulto
xaile xeque xerez xisto
zanga zebra zelar zinco zumbi
`;
const WD_PT_MORE = `
abada abade abafa abala abana abeto abole aboli abona abrem abres abriu absor abuso acaba acabe acata aceda acede acena acham achas achei achou acode acres actas actos acuda adiou adoca adora adore adota afaga afina agita ajude ajuso alama algas algoz alpes altas altos alude aluga alvor amara amaro ambas amiga ampla anais anaos ancas ancho andai andam andas andou aneis anelo angra anima anjos anoes anota antas antro anuir anula apaga apara apice apoia apoie apraz aptos apura arcas arcos ardem ardil arias arrua aspro ataca atada atais ateia atira ativa atola atrai audaz auras autos avala avara avida avisa avoar azuis
babas bacio baeta bagas baila baldo bales balir bares baril batem batia bebem bebes bebeu beica beija belas belos benca benta beque bicas bicos bifes binas bisao bocas bodas bofes bogas boias bolas bolos bombo bones botar botas botes brevi broas bucal bufar bugio bulir burra
cabem caber cabia cacar cacas cacos cagar caiam caiar caida caido calam calas cales calmo calos calou calva camas canas canga canis capar capas capim capta caput carao cares casar casas casos casto catas catre caves cavos ceder cedia cegos celas cepos certa chago chata chefa chega cheia chiar chila chino choco chora choro chulo cicio cites clara coche codea colhe colos comam comem comes comeu comia cones copas copos cores corta cosem coser cotao cotas covas covil coxas coxos crava creio cremo criar crias criou cruas cruza cubos cuida curas curvo cusco custa
dadas dados damas damos dando danos dares dedos deita deixe delas deles demos denso depor derme desce deste deter devem digam digna direi disse ditas ditos dizem dizes dobro doces donos dorme dotar doura drama dromo duelo dunas dupla duras duros
ecoar educa eixos elege elmos emana emito envia erram erros ervas estes estou exige expor
facas faces fados falam falas faleu falou falsa falto faria farta fasto fatal fatos favas fazem fazes fazia fecha feias feios feita feras ferra fetos ficam ficou fieis figos filas finar finca fitar fitas fizer focas focos fofas fofos fogos fomos foram foros fosse fotos frios friso frita fruir fumos funda furas furos furto fusos futil
galas galos gamba ganha ganir garbo garca gases gatas gatos giram giras gnomo golos gomos gorda gosta gotas gozar grana grata graus graxa grega grego greta guias guita
harpa havia hecto hidra hinos horas houve
ideal idosa ilhas impio impor imune inane incas iscas
jante jaspe jazer jogam jogos jogou joias jorro judas juizo julga juras justa
labia lacos lados lagos lajes lamas lambe lapas lapso laque lares latas latim laude lavra leais legar legua leiga leira lemas lemos lendo leoes lepra lerdo leses leves levou licor lidar lidas lidos ligas limar limos liras lisas lisos lixar lixos lobos locar logos loira loiro lojas longa longo lotes lotos louca louro lucro luvas luzes luzir
macas macos madre magos magra maios malas mamao manda mapas mares marra matas mates matiz matos meada medos meias meios melga menus mesas meses mesma metas meter mexeu micas migas mijar mimos minas mirra mitos mitra mocas modas modos moido moita molas moles moral mossa mosto motas motel motos mouro mudas muita multa muros musas
nabos nacos nadas nadir nafta nasal nasce natas negra netos neves ninar ninfa nomes nonas noras nossa notar notas novas novos nozes nubil nudez
oasis obesa obese obras obter ocios ofega ogiva olear oleos olhos ondas opaca orago orfao orgia ossos outra ovais
pacas pacto pagam pagas pages paina panos papas papos parca parco pardo parem pares parta parva pasma pasmo passa patas patos pauto pecas pedem pegas pegou pelos pelve penas peras perca perus pesos petiz picos pifar pingo pinos pipas pirar pneus podem podes podia poios polir polos polpa poros possa posso posta potes potro pouca poupa povos prado prece presa preta proas prosa puder pudim pular pulos punir purga
quais quero quita
rabos racas racha rafia raias raios ralha ramos rapar raras raros rasas rasos ratos reage reais reato recta recto redes redor refem regar regra remos renal repor rezas ricas ricos rijas rijos rimas rinha risos ritos rocas rodas romeu rosas rotas roxas roxos rubim rudes rugas rupia rusga
sabao sabem sabes sabia sacas sacos sadio saiam saiba salas salta salve samba sanar sanha santa sapos saque sarro secas secos seder sedes segue seios selos sendo senil sente serem seres seria servo setas setim silvo simio sinos sobem sofas sofra solas soldo soles solta somas somos sonar sonos sopas suado subiu suino sujas sujos sumos supor surge surra
tacas tacos tacto taipa talha talos tanta tapes tarda taxas teias telas temas temos tendo tenha tenho tenra tensa tenta teres terna tesao tesos testa tetos tiara timao tinha tiras tiros tiver todas todos tolos tomos tordo torno torpe torto torvo tosco total toura trara trata trema troco troia trova truco tubos tufao tumba tunda turba
unhas unica urgir urnas ursos usada usado usava uteis
vacas vagas vagos vaiar valas vales valia vamos varas varia vasos vasta vazar vazia veios velas velha vemos vendo verga vibra vidas vigas vigor vilas vimos vinda vindo vinha viram virem visar vista vivas vivem vives vivos voava vogar volto vossa votar votos vozes
xales
zagal zelos zeros zonas zorro
`;
/* português alargado (ronda 2): palavras SEM acento que faltavam... */
const WD_PT_MORE2 = `
bolso capuz corvo falta cruel farsa barca cisco cuspe filha ganga gosma murro mural rapto sarau sulco temor trela veloz vulgo beato bruxo feudo fiapo galgo golfo moela obeso penca pinto prole pulha ranho rente ruivo ruiva sarna seixo vagem visgo pagao pilao capao cupao furao gabao macao pocao peoes acoes cajus caias saias
`;
/* ...e as formas COM acento (a chave de jogo é sem acentos; o ecrã mostra com). Entram todas como aceites. */
const WD_PT_ACC = `
ábaco ácaro ácido águas águia álbum ágape ágora álibi âmago âmbar ânimo ânsia árabe árduo árido átomo átrio áudio áureo ávido ágeis áreas aéreo aérea ébano édito égide éguas época épico épica ética ético étimo êxito êxodo ébrio ícone ídolo ímpar índex índio ímpio ígneo óbito óbvio ópera órfão órgão ótimo ótica ótico óvulo óxido ósseo ócios ódios óleos ómega única único útero úvula úteis
avião limão balão botão cação fogão irmão melão nação pavão razão salão talão tufão verão visão lição ração opção noção moção bufão lesão tesão serão senão então porão fusão facão galão gibão tição varão vazão mamão piões porém refém harém vocês irmãs manhã maçãs romãs órfãs alemã vilãs pagão pilão bisão capão cupão furão gabão mação poção peões ações calão tacão sabão bidão
louça força praça braço março terço berço calça lenço peças dança lança graça traça caçar açude façam coçar poças moços moças laços taças paços roçar laçar preço troça troço caças
fácil fémur fénix ténis bónus génio gémeo pénis ténue vénus cárie hábil lápis lábio mágoa máfia nácar pátio rádio sábio tábua tédio vácuo vária vário lírio líder lítio míope nível símio sítio vídeo vírus vício túnel múmia herói hífen húmus médio nódoa pólen régua sério sócio sótão chalé ciúme dócil dólar fiéis lúmen pálio páreo pária pónei sépia sócia tília saúde saída caído caída juíza juízo ruído ruína moído suíça suíço miúdo miúda viúva viúvo reúne reúno reúna oásis côdea dúzia gíria tripé cafés légua móvel série táxis júris fórum cólon cânon bebés chulé bidés bonés sofás baías suíno
estás estão serás farão farás dirão dirás virão virás terão terás darão darás porás lerão lerás cairá sairá trará saíam caíam saído doído saías caías
`;

ENG.words = (() => {
  const SRC = { en: { ans: WD_EN_ANS, more: WD_EN_MORE, acc: '' }, pt: { ans: WD_PT_ANS, more: WD_PT_MORE + WD_PT_MORE2, acc: WD_PT_ACC } };
  const cache = {};
  const strip = w => w.normalize('NFD').replace(/[̀-ͯ]/g, '');
  const lists = lang => {
    if (cache[lang]) return cache[lang];
    const src = SRC[lang] || SRC.en, bad = [], ans = [], seenA = new Set(), seenM = new Set(), show = new Map(); let dupes = 0;
    src.ans.split(/\s+/).forEach(w => { if (!w) return; if (!/^[a-z]{5}$/.test(w)) { bad.push(w); return; } if (seenA.has(w)) { dupes++; return; } seenA.add(w); ans.push(w.toUpperCase()); });
    const all = new Set(ans);
    src.more.split(/\s+/).forEach(w => { if (!w) return; if (!/^[a-z]{5}$/.test(w)) { bad.push(w); return; } if (seenM.has(w) || seenA.has(w)) { dupes++; return; } seenM.add(w); all.add(w.toUpperCase()); });
    src.acc.split(/\s+/).forEach(w => { if (!w) return; const k = strip(w); if (!/^[a-z]{5}$/.test(k) || w.length !== 5) { bad.push(w); return; } const K = k.toUpperCase(); if (!show.has(K)) show.set(K, w.toUpperCase()); all.add(K); });
    return (cache[lang] = { ans, all, show, bad, dupes });
  };
  const display = (lang, w) => lists(lang).show.get(w) || w;
  /* cores de uma tentativa: 2 verde, 1 amarelo, 0 cinzento (letras repetidas contam uma vez) */
  const score = (guess, word) => {
    const res = [0, 0, 0, 0, 0], left = {};
    for (let i = 0; i < 5; i++) { if (guess[i] === word[i]) res[i] = 2; else left[word[i]] = (left[word[i]] || 0) + 1; }
    for (let i = 0; i < 5; i++) if (res[i] !== 2 && left[guess[i]]) { res[i] = 1; left[guess[i]]--; }
    return res;
  };
  /* modo difícil: as pistas já reveladas têm de ser usadas (verdes no sítio, amarelas incluídas) */
  const hardCheck = (guess, guesses, word) => {
    for (const prev of guesses) {
      const sc = score(prev, word), need = {};
      for (let i = 0; i < 5; i++) { if (sc[i] === 2 && guess[i] !== prev[i]) return 'A letra ' + prev[i] + ' tem de ficar na casa ' + (i + 1); if (sc[i] > 0) need[prev[i]] = (need[prev[i]] || 0) + 1; }
      for (const L in need) { let n = 0; for (let i = 0; i < 5; i++) if (guess[i] === L) n++; if (n < need[L]) return 'A tentativa tem de incluir o ' + L; }
    }
    return null;
  };
  const daily = (lang, day) => { const L = lists(lang); let x = (day * 2654435761) >>> 0; x ^= x >>> 13; x = Math.imul(x, 1597334677) >>> 0; x = (x ^ (x >>> 16)) >>> 0; return L.ans[x % L.ans.length]; };
  const random = (lang, rng) => { const L = lists(lang); return L.ans[((rng || Math.random)() * L.ans.length) | 0]; };
  const valid = (lang, w) => lists(lang).all.has(w);
  const BLOCK = ['□', '▣', '■'];   /* fora, lugar errado, certo */
  const share = o => { const head = o.mode === 'daily' ? 'Palavras · Dia ' + o.day + ' · ' + (o.won ? o.rows.length : 'X') + '/6' : o.mode === 'rapid' ? 'Palavras · Rápido · ' + plural(o.words, 'palavra', 'palavras') + ' em 90 s' : 'Palavras · ' + (o.won ? o.rows.length : 'X') + '/6'; return head + (o.hard ? ' · difícil' : '') + '\n' + o.rows.map(r => r.map(c => BLOCK[c]).join('')).join('\n'); };
  return { lists, score, hardCheck, daily, random, valid, dayIndex, strip, display, share };
})();

Icons.app.words = () => ico('gWd', ['#9BE59A', '#3BB35E', '#17603A'], shadowed(
  [['#fff', 1], ['#FFD60A', 1], ['rgba(255,255,255,.4)', 1], ['#fff', 1], ['rgba(255,255,255,.4)', 1]].map(([c], i) => `<rect x="${13.5 + i * 15.2}" y="31" width="13" height="13" rx="3.2" fill="${c}"/>`).join('') +
  [0, 1, 2, 3, 4].map(i => `<rect x="${13.5 + i * 15.2}" y="47.5" width="13" height="13" rx="3.2" fill="${i === 1 || i === 4 ? '#FFD60A' : i === 2 ? '#fff' : 'rgba(255,255,255,.4)'}"/>`).join('') +
  [0, 1, 2, 3, 4].map(i => `<rect x="${13.5 + i * 15.2}" y="64" width="13" height="13" rx="3.2" fill="none" stroke="#fff" stroke-opacity=".55" stroke-width="1.8"/>`).join(''), 1.6) +
  `<path d="M17.5 37l2.6 2.6 4.6-4.8M47.6 54l2.6 2.6 4.6-4.8" stroke="#2A8A48" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>`);

const WORDS_COVER = () => { const rows = [['x', 'y', 'x', 'x', 'g'], ['g', 'y', 'x', 'g', 'g'], ['g', 'g', 'g', 'g', 'g']], col = { g: '#3BB35E', y: '#D9A400', x: '#3A3F4A' }, L = [['C', 'A', 'R', 'T', 'A'], ['P', 'O', 'R', 'T', 'A'], ['P', 'R', 'A', 'T', 'O']];
  return `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="gwdCb" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1C2A22"/><stop offset="1" stop-color="#0A110D"/></linearGradient><radialGradient id="gwdCg" cx="70%" cy="20%" r="70%"><stop offset="0" stop-color="#3BB35E" stop-opacity=".4"/><stop offset="1" stop-color="#3BB35E" stop-opacity="0"/></radialGradient><linearGradient id="gwdCt" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".22"/><stop offset="1" stop-color="#000" stop-opacity=".18"/></linearGradient></defs><rect width="400" height="200" fill="url(#gwdCb)"/><rect width="400" height="200" fill="url(#gwdCg)"/>` +
  `<g font-family="Inter, system-ui, sans-serif" font-weight="800" font-size="24" fill="#fff" text-anchor="middle">${rows.map((r, ri) => r.map((c, ci) => `<g transform="translate(${92 + ci * 46} ${30 + ri * 46}) rotate(${ri === 2 ? -4 + ci * 2 : 0})"><rect width="40" height="40" rx="8" fill="${col[c]}"/><rect width="40" height="40" rx="8" fill="url(#gwdCt)"/><text x="20" y="29">${L[ri][ci]}</text></g>`).join('')).join('')}</g>` +
  `<g transform="translate(322 40)">${[0, 1, 2].map(r => [0, 1, 2].map(c => `<rect x="${c * 20}" y="${r * 22}" width="16" height="18" rx="4" fill="rgba(255,255,255,${r === 1 && c === 1 ? '.9' : '.16'})"/>`).join('')).join('')}</g><text x="200" y="180" font-family="Inter, system-ui, sans-serif" font-weight="700" font-size="13" fill="rgba(255,255,255,.55)" text-anchor="middle" letter-spacing="3">DIA · SEM LIMITE · RÁPIDO</text></svg>`; };

Arcade.game('words', {
  name: 'Palavras', color: '#3BB35E', kind: 'puzzle', unit: 'seguidas', scoreLabel: 'Sequência', bestLabel: 'Recorde',
  desc: 'Adivinha a palavra de cinco letras em seis tentativas. Palavra do dia, sem limite ou Rápido de 90 segundos, em português ou inglês, com modo difícil, estatísticas e partilha do resultado.',
  tags: ['Letras', 'Diário', 'Rápido'], modes: [{ key: 'daily', label: 'Palavra do dia' }, { key: 'free', label: 'Sem limite' }, { key: 'rapid', label: 'Rápido\u200b' }],
  /* tabelas do hub: a sequência de sempre ("words") e o Rápido ("words:rapido", palavras em 90 s) */
  variants: [{ key: 'seq', label: 'Sequência', board: 'words' }, { key: 'rapido', label: 'Rápido\u200b', board: 'words:rapido', unit: 'palavras' }],
  cover: WORDS_COVER,
  howto: { goal: 'Descobre a palavra de cinco letras em seis tentativas.', steps: ['Escreve uma palavra válida e carrega em Enter.', 'Verde: letra certa no sítio certo. Amarelo: existe, noutro sítio. Cinzento: não existe.', 'No modo Rápido conta quantas palavras acertas em 90 segundos.'], controls: [{ icon: 'hand', label: 'Teclado no ecrã' }, { icon: 'move', label: 'Letras, Enter e Backspace no teclado físico' }] },
  build(win) {
    const W = ENG.words, ROWS = ['QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'], RAPID = 90;
    let lang = Arcade.opt('words:lang', (window.L && L.code === 'pt') || !(window.L && L.code) ? 'pt' : 'en'); if (lang !== 'pt' && lang !== 'en') lang = 'pt';
    let mode = Arcade.opt('words:mode', 'daily'); if (!/^(daily|free|rapid)$/.test(mode)) mode = 'daily';
    let hard = Arcade.opt('words:hard', '0') === '1';
    const A = Arcade.shell(win, { id: mode === 'rapid' ? 'words:rapido' : 'words', name: 'Palavras', color: '#3BB35E', pausable: false, scoreLabel: mode === 'rapid' ? 'Palavras' : 'Sequência', bestLabel: 'Recorde', onRestart: () => restart() });
    const x = X(A), stage = A.el.stage; stage.style.position = 'relative';
    const wrap = el(`<div class="gwd-wrap gpz-hide"><div class="gwd-grid">${Array.from({ length: 6 }, () => `<div class="gwd-row">${'<div class="gwd-t"><i></i></div>'.repeat(5)}</div>`).join('')}</div>
      <div class="gwd-kb">${ROWS.map((r, ri) => `<div class="gwd-kr">${ri === 2 ? `<div class="gwd-k wide" data-k="ENTER">Enter</div>` : ''}${[...r].map(k => `<div class="gwd-k" data-k="${k}">${k}</div>`).join('')}${ri === 2 ? `<div class="gwd-k wide" data-k="BACK">${g('backspace', 22)}</div>` : ''}</div>`).join('')}</div></div>`);
    stage.appendChild(wrap);
    const rows = [...wrap.querySelectorAll('.gwd-row')], keys = {}; wrap.querySelectorAll('.gwd-k').forEach(k => { keys[k.dataset.k] = k; });
    const tiles = [...wrap.querySelectorAll('.gwd-t')];
    A.el.ctl.innerHTML = `<div class="gpz-tools"><div class="gpz-tool off" data-k="share">${g('share', 20)}<span>Partilhar</span></div><div class="gpz-tool" data-k="stats">${g('chart', 20)}<span>Resumo</span></div><div class="gpz-tool" data-k="how">${g('book', 20)}<span>Como jogar</span></div></div>`;
    const bShare = A.el.ctl.querySelector('.gpz-tool[data-k="share"]'), bStats = A.el.ctl.querySelector('.gpz-tool[data-k="stats"]'), bHow = A.el.ctl.querySelector('.gpz-tool[data-k="how"]');
    bHow.onclick = () => x.howto();

    const SK = () => 'gpzWords:' + lang, DK = () => 'gpzWordsDaily:' + lang;
    const stats = () => stGet(SK(), Object.assign({ played: 0, won: 0, streak: 0, max: 0, dist: [0, 0, 0, 0, 0, 0], rapidBest: 0, rapidPlayed: 0 }, Store.get('gbWords:' + lang, null) || {}));
    let beginSeq = 0, word = '', guesses = [], cur = '', over = true, busy = false, firstMount = true, rapidWords = 0, rapidT = null, rapidEnd = 0, rapidRows = [], lastShare = null, started = false;
    const isDaily = () => mode === 'daily', isRapid = () => mode === 'rapid';
    const modeLabel = () => isDaily() ? 'Dia ' + dayNo() : isRapid() ? 'Rápido\u200b' : 'Sem limite';
    const rapidLeft = () => (started ? Math.max(0, Math.ceil((rapidEnd - Date.now()) / 1000)) : RAPID);
    const mid = () => A.setMid(`<span class="gm-hint gpz-pill">${isDaily() ? g('calendar', 15) : isRapid() ? g('clock', 15) : ''}${isRapid() && !over ? `<b>${fmtT(rapidLeft())}</b>` : esc(modeLabel())}</span><span class="gm-hint gpz-pill">${hard ? g('flame', 14) : ''}${lang.toUpperCase()}${!over && !isRapid() ? ` · <b>${guesses.length + 1}/6</b>` : ''}</span>`);
    const paintRow = (ri, letters, cols, reveal, shown) => {
      const ts = rows[ri].children; rows[ri].classList.remove('win');
      for (let i = 0; i < 5; i++) { const t = ts[i], ch = (shown || letters)[i] || ''; t.firstChild.textContent = ch; t.classList.toggle('fill', !!ch && !cols); t.classList.remove('g', 'y', 'x', 'reveal', 'pop');
        if (cols) { const cls = ['x', 'y', 'g'][cols[i]]; if (reveal) { t.style.setProperty('--d', (i * 110) + 'ms'); t.classList.add('reveal'); const tm = setTimeout(() => t.classList.add(cls), 250 + i * 110); win.timers.push(tm); } else t.classList.add(cls); } }
    };
    const paintKeys = () => {
      const best = {}; guesses.forEach(gs => { const sc = W.score(gs, word); for (let i = 0; i < 5; i++) best[gs[i]] = Math.max(best[gs[i]] || 0, sc[i] + 1); });
      Object.keys(keys).forEach(k => { if (k.length > 1) return; keys[k].classList.remove('g', 'y', 'x'); if (best[k]) keys[k].classList.add(['x', 'y', 'g'][best[k] - 1]); });
    };
    const paintAll = () => { for (let r = 0; r < 6; r++) { if (r < guesses.length) paintRow(r, guesses[r], W.score(guesses[r], word), false, W.display(lang, guesses[r])); else if (r === guesses.length && !over) paintRow(r, cur, null); else paintRow(r, '', null); } paintKeys(); mid(); bShare.classList.toggle('off', !lastShare); };
    const saveDaily = () => { if (isDaily()) stSet(DK(), { day: dayIndex(), guesses: guesses.slice(), over }); };
    const newWord = () => { guesses = []; cur = ''; busy = false; word = isDaily() ? W.daily(lang, dayIndex()) : W.random(lang); };
    const begin = () => {
      beginSeq++; over = false; lastShare = null; started = false; rapidWords = 0; rapidRows = []; clearInterval(rapidT); rapidT = null;
      A.setId(isRapid() ? 'words:rapido' : 'words'); A.el.score.previousElementSibling.textContent = isRapid() ? 'Palavras' : 'Sequência';
      A.setScore(isRapid() ? 0 : stats().streak);
      newWord();
      if (isDaily()) { const sv = Store.get(DK(), null) || Store.get('gbWordsDaily:' + lang, null); if (sv && sv.day === dayIndex() && Array.isArray(sv.guesses)) { guesses = sv.guesses.filter(gw => typeof gw === 'string' && gw.length === 5); over = !!sv.over || guesses.length >= 6; if (over) { lastShare = { mode: 'daily', day: dayNo(), won: guesses.length && guesses[guesses.length - 1] === word, rows: guesses.map(gs => W.score(gs, word)), hard }; UI.toast('Já jogaste a palavra de hoje'); } } }
      wrap.classList.remove('gpz-hide'); paintAll();
      if (firstMount) { firstMount = false; cascade(wrap.querySelector('.gwd-grid'), tiles, 12); }
      if (isRapid()) { const my = ++beginSeq; busy = true; x.countdown(3).then(() => { if (my !== beginSeq || !isRapid() || over) return; busy = false; startRapid(); }); }
    };
    const restart = () => { if (isDaily()) { const sv = Store.get(DK(), null); if (sv && sv.day === dayIndex() && sv.over) { UI.toast('Volta amanhã para a palavra do dia'); mode = 'free'; Arcade.setOpt('words:mode', 'free'); opts.set('mode', 'free'); } } begin(); };
    const shake = () => { const r = rows[guesses.length]; if (!r) return; r.classList.remove('shake'); void r.offsetWidth; r.classList.add('shake'); };
    const startRapid = () => { if (!isRapid() || started) return; started = true; rapidEnd = Date.now() + RAPID * 1000; rapidT = setInterval(() => { mid(); const l = rapidLeft(); if (l <= 5 && l > 0) x.sfx('tick'); if (l <= 0) finishRapid(); }, 250); win.timers.push(rapidT); };
    const type = ch => { if (over || busy || cur.length >= 5) return; startRapid(); cur += ch; const t = rows[guesses.length].children[cur.length - 1]; t.firstChild.textContent = ch; t.classList.add('fill', 'pop'); x.sfx('tick'); };
    const back = () => { if (over || busy || !cur.length) return; cur = cur.slice(0, -1); const t = rows[guesses.length].children[cur.length]; t.firstChild.textContent = ''; t.classList.remove('fill', 'pop'); };
    const finishRapid = () => {
      if (over) return; over = true; clearInterval(rapidT); rapidT = null; busy = false;
      const st = stats(); st.rapidPlayed++; if (rapidWords > st.rapidBest) st.rapidBest = rapidWords; stSet(SK(), st);
      lastShare = { mode: 'rapid', words: rapidWords, rows: rapidRows.slice(-6), hard }; A.setScore(rapidWords); paintAll();
      if (rapidWords >= 5) x.celebrate('win'); x.sfx(rapidWords ? 'chime' : 'lose');
      setTimeout(() => x.end({ title: 'Tempo esgotado', sub: plural(rapidWords, 'palavra acertada', 'palavras acertadas') + ' em 90 s', score: rapidWords, win: rapidWords > 0, board: 'words:rapido', stats: [{ label: 'Palavras', value: String(rapidWords) }, { label: 'Melhor no Rápido', value: String(st.rapidBest) }, { label: 'Idioma', value: lang === 'pt' ? 'Português' : 'English' }] }), 600);
    };
    const submit = () => {
      if (over || busy) return;
      if (cur.length < 5) { shake(); x.sfx('fail'); note(stage, 'Faltam letras', 'bad top', 1300); return; }
      if (!W.valid(lang, cur)) { shake(); x.sfx('fail'); note(stage, 'Não está na lista', 'bad top', 1400); return; }
      if (hard) { const why = W.hardCheck(cur, guesses, word); if (why) { shake(); x.sfx('fail'); note(stage, why, 'bad top', 1800); return; } }
      startRapid();
      busy = true; const gs = cur, sc = W.score(gs, word); guesses.push(gs); cur = '';
      paintRow(guesses.length - 1, gs, sc, true, W.display(lang, gs)); x.sfx('flip');
      const tm = setTimeout(() => {
        busy = false; paintKeys();
        const won = sc.every(v => v === 2), st = stats();
        if (isRapid()) {
          if (won) { rapidWords++; rapidRows.push(sc); A.setScore(rapidWords); rows[guesses.length - 1].classList.add('win'); x.sfx('score'); x.flash('+1', 'pts'); if (guesses.length === 1) Arcade.flag('wordsFirstTry'); setTimeout(() => { if (!over) { newWord(); paintAll(); } }, 700); }
          else if (guesses.length >= 6) { note(stage, 'Era ' + W.display(lang, word), 'bad top', 1600); x.sfx('fail'); setTimeout(() => { if (!over) { newWord(); paintAll(); } }, 900); }
          else mid();
          return;
        }
        if (won || guesses.length >= 6) {
          over = true; st.played++;
          if (won) { st.won++; st.streak++; st.max = Math.max(st.max, st.streak); st.dist[guesses.length - 1]++; if (guesses.length === 1) Arcade.flag('wordsFirstTry'); } else st.streak = 0;
          stSet(SK(), st); saveDaily(); A.setScore(st.streak);
          lastShare = { mode, day: dayNo(), won, rows: guesses.map(gs2 => W.score(gs2, word)), hard }; mid(); bShare.classList.remove('off');
          const titles = ['Génio', 'Magnífico', 'Impressionante', 'Esplêndido', 'Ótimo', 'Ufa'];
          const extra = [{ label: 'Tentativas', value: won ? guesses.length + '/6' : 'X/6' }, { label: 'Vitórias', value: pct(st.won, st.played) }, { label: 'Sequência máxima', value: String(st.max) }];
          if (won) { rows[guesses.length - 1].classList.add('win'); x.sfx('chime'); x.celebrate('win'); x.flash(titles[guesses.length - 1], 'big'); setTimeout(() => x.end({ title: titles[guesses.length - 1], sub: `${W.display(lang, word)} · sequência de ${st.streak}`, score: st.streak, win: true, board: 'words', stats: extra }), 1200); }
          else { x.sfx('lose'); note(stage, 'A palavra era ' + W.display(lang, word), 'bad top', 2600); setTimeout(() => x.end({ title: 'Não foi desta', sub: `A palavra era ${W.display(lang, word)}`, score: 0, win: false, submit: false, board: 'words', stats: extra }), 1400); }
        } else { saveDaily(); mid(); }
      }, 250 + 4 * 110 + 200); win.timers.push(tm);
    };
    const share = async () => {
      if (!lastShare) return;
      const txt = W.share(lastShare);
      const r = await UI.actionSheet({ title: 'Partilhar o resultado', buttons: [{ label: 'Copiar', icon: 'copy', value: 'copy' }, { label: 'Enviar por Mensagens', icon: 'message', value: 'msg' }] });
      if (!r) return;
      if (window.Msgs && typeof Msgs.copy === 'function') Msgs.copy(txt, true); else { try { const p = navigator.clipboard && navigator.clipboard.writeText(txt); if (p && p.catch) p.catch(() => {}); } catch (e) {} }
      if (r === 'msg' && window.App && App.get && App.get('messages')) { UI.toast('Resultado copiado: cola-o na conversa'); System.openApp('messages'); } else UI.toast('Resultado copiado');
    };
    wrap.querySelector('.gwd-kb').addEventListener('click', e => { const k = e.target.closest('.gwd-k'); if (!k) return; const v = k.dataset.k; if (v === 'ENTER') submit(); else if (v === 'BACK') back(); else type(v); });
    bShare.onclick = share;
    bStats.onclick = () => {
      const st = stats(), mx = Math.max(1, ...st.dist);
      const body = el(`<div class="gpz-stats"><div class="tiles"><div><b>${st.played}</b><span>Jogadas</span></div><div><b>${pct(st.won, st.played)}</b><span>Vitórias</span></div><div><b>${st.streak}</b><span>Sequência</span></div><div><b>${st.max}</b><span>Máxima</span></div></div>
        <div class="dist-t">Distribuição de tentativas</div><div class="dist">${st.dist.map((n, i) => `<div class="bar"><span>${i + 1}</span><i style="width:${Math.max(8, Math.round(n * 100 / mx))}%"><b>${n}</b></i></div>`).join('')}</div>
        <div class="rows"><div class="r"><span>Rápido: melhor</span><b>${plural(st.rapidBest, 'palavra', 'palavras')}</b></div><div class="r"><span>Rápido: partidas</span><b>${st.rapidPlayed}</b></div></div></div>`);
      UI.sheet({ title: 'Palavras · ' + (lang === 'pt' ? 'Português' : 'English'), body, right: 'OK' });
    };
    const opts = x.options([
      { key: 'mode', label: 'Modo', values: [{ v: 'daily', label: 'Palavra do dia' }, { v: 'free', label: 'Sem limite' }, { v: 'rapid', label: 'Rápido\u200b' }], cur: mode, onChange: v => { mode = v; Arcade.setOpt('words:mode', v); begin(); } },
      { key: 'lang', label: 'Idioma', values: [{ v: 'pt', label: 'Português' }, { v: 'en', label: 'English' }], cur: lang, onChange: v => { lang = v; Arcade.setOpt('words:lang', v); begin(); } },
      { key: 'hard', label: 'Difícil', values: [{ v: '0', label: 'Não' }, { v: '1', label: 'Sim' }], cur: hard ? '1' : '0', onChange: v => { hard = v === '1'; Arcade.setOpt('words:hard', v); mid(); } },
    ]);
    (async () => { await x.ready('Palavras', 'Toca para começar'); begin(); })();
    win.onClose = () => { clearInterval(rapidT); };
    const api = {
      pause() { if (isRapid() && started && !over) { api._pausedAt = Date.now(); clearInterval(rapidT); rapidT = null; } },
      resume() { if (isRapid() && started && !over && api._pausedAt) { rapidEnd += Date.now() - api._pausedAt; api._pausedAt = 0; rapidT = setInterval(() => { mid(); if (rapidLeft() <= 0) finishRapid(); }, 250); win.timers.push(rapidT); } },
      key(e) { if (e.key === 'Enter') { e.preventDefault(); submit(); } else if (e.key === 'Backspace') { e.preventDefault(); back(); } else if (/^[a-zA-Z]$/.test(e.key)) { e.preventDefault(); type(e.key.toUpperCase()); } },
      test: { get word() { return word; }, type, back, submit, get guesses() { return guesses; }, get over() { return over; }, begin, share, get rapidWords() { return rapidWords; }, endRapid: finishRapid, setMode(m) { mode = m; opts.set('mode', m); begin(); }, setHard(h) { hard = !!h; opts.set('hard', h ? '1' : '0'); mid(); } },
    };
    LIVE.game = api; return api;
  },
});

/* =====================================================================
   SOLITÁRIO (Klondike): mesa de feltro, cartas desenhadas (pintas na disposição certa, figuras em SVG, verso com
   padrão), arrastar com elevação (pointer events convertidos com UI.vrect/UI.zoom) ou tocar para mover para o melhor
   destino, completar automático em cascata, animação de vitória clássica numa camada canvas (único rAF dos puzzles,
   morre sozinho e em pausa/fecho), pontuação Padrão ou Vegas, dicas explicadas, desfazer, estatísticas.
   ===================================================================== */
ENG.solitaire = (() => {
  const SUIT = c => (c / 13) | 0, RANK = c => c % 13, RED = c => { const s = SUIT(c); return s === 1 || s === 2; };
  const RANKN = ['Ás', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Valete', 'Dama', 'Rei'], SUITN = ['espadas', 'copas', 'ouros', 'paus'];
  /* nome da carta na língua do telemóvel: figura e naipe pelo dicionário e a ordem pelo padrão "%s de %s" + U+200B
     (chave própria: o italiano diz "Asso di picche", o alemão "Pik Ass", o japonês "スペードのエース") */
  const name = c => {
    const r = RANKN[RANK(c)], n = SUITN[SUIT(c)];
    if (!(window.L && L.t && L.tf)) return r + ' de ' + n;
    return L.tf('%s de %s​', L.t(r), L.t(n));
  };
  const deal = (draw, rng) => {
    const deck = shuffleR(Array.from({ length: 52 }, (_, i) => i), rng || Math.random), tab = [];
    for (let i = 0; i < 7; i++) { const col = []; for (let j = 0; j <= i; j++) col.push({ c: deck.pop(), up: j === i }); tab.push(col); }
    return { stock: deck.map(c => ({ c, up: false })), waste: [], found: [[], [], [], []], tab, draw: draw === 3 ? 3 : 1, moves: 0, score: 0, passes: 0, vegas: false };
  };
  const canStack = (card, onto) => (!onto ? RANK(card.c) === 12 : (!!onto.up && RED(card.c) !== RED(onto.c) && RANK(card.c) === RANK(onto.c) - 1));
  const canFound = (card, pile) => (pile.length ? (SUIT(pile[pile.length - 1].c) === SUIT(card.c) && RANK(card.c) === RANK(pile[pile.length - 1].c) + 1) : RANK(card.c) === 0);
  /* reciclar o lixo: Vegas limita as passagens (1 carta: uma passagem; 3 cartas: três) */
  const canRecycle = s => !s.stock.length && s.waste.length > 0 && (!s.vegas || s.passes < (s.draw === 3 ? 2 : 0));
  const draw = s => {
    if (!s.stock.length) { if (!canRecycle(s)) return false; s.stock = s.waste.reverse().map(x => ({ c: x.c, up: false })); s.waste = []; s.moves++; s.passes++; if (!s.vegas) s.score = Math.max(0, s.score - (s.draw === 3 ? 20 : 100)); return true; }
    for (let i = 0; i < s.draw && s.stock.length; i++) { const x = s.stock.pop(); x.up = true; s.waste.push(x); }
    s.moves++; return true;
  };
  const cardsAt = (s, src) => (src.k === 'waste' ? s.waste.slice(-1) : src.k === 'found' ? s.found[src.i].slice(-1) : s.tab[src.i].slice(src.j));
  const canMove = (s, src, dst) => {
    const cs = cardsAt(s, src); if (!cs.length || !cs.every(c => c.up)) return false;
    if (dst.k === 'found') return cs.length === 1 && canFound(cs[0], s.found[dst.i]);
    if (src.k === 'tab' && dst.i === src.i) return false;
    const col = s.tab[dst.i]; return canStack(cs[0], col.length ? col[col.length - 1] : null);
  };
  /* devolve { turned } (carta virada na coluna de origem) para a animação e a pontuação */
  const move = (s, src, dst) => {
    if (!canMove(s, src, dst)) return false;
    const cs = cardsAt(s, src); let turned = -1;
    if (src.k === 'waste') s.waste.pop(); else if (src.k === 'found') s.found[src.i].pop(); else { s.tab[src.i].splice(src.j); const col = s.tab[src.i]; if (col.length && !col[col.length - 1].up) { col[col.length - 1].up = true; turned = col[col.length - 1].c; } }
    if (dst.k === 'found') s.found[dst.i].push(cs[0]); else s.tab[dst.i].push(...cs);
    s.moves++;
    if (s.vegas) { if (dst.k === 'found') s.score += 5; if (src.k === 'found') s.score -= 5; }
    else { let d = 0; if (dst.k === 'found') d += 10; else if (src.k === 'waste') d += 5; if (src.k === 'found') d -= 15; if (turned >= 0) d += 5; s.score = Math.max(0, s.score + d); }
    return { turned };
  };
  const won = s => s.found.every(p => p.length === 13);
  const bonus = (s, secs) => (s.vegas || secs < 30 ? 0 : Math.floor(700000 / Math.max(30, secs)));
  /* destino automático de um toque: fundação primeiro, depois uma coluna com cartas, depois um rei para coluna vazia */
  const autoDst = (s, src) => {
    const cs = cardsAt(s, src); if (!cs.length || !cs[0].up) return null;
    if (cs.length === 1) for (let i = 0; i < 4; i++) if (canFound(cs[0], s.found[i])) return { k: 'found', i };
    for (let i = 0; i < 7; i++) { if (src.k === 'tab' && src.i === i) continue; const col = s.tab[i]; if (col.length && canStack(cs[0], col[col.length - 1])) return { k: 'tab', i }; }
    if (RANK(cs[0].c) === 12 && !(src.k === 'tab' && src.j === 0)) for (let i = 0; i < 7; i++) if (!s.tab[i].length) return { k: 'tab', i };
    return null;
  };
  /* uma jogada útil para a dica, ou null */
  const hint = s => {
    for (let i = 0; i < 7; i++) { const col = s.tab[i]; if (col.length) { const src = { k: 'tab', i, j: col.length - 1 }; for (let f = 0; f < 4; f++) if (canMove(s, src, { k: 'found', i: f })) return { src, dst: { k: 'found', i: f } }; } }
    if (s.waste.length) for (let f = 0; f < 4; f++) if (canMove(s, { k: 'waste' }, { k: 'found', i: f })) return { src: { k: 'waste' }, dst: { k: 'found', i: f } };
    for (let i = 0; i < 7; i++) { const col = s.tab[i]; const j = col.findIndex(c => c.up); if (j < 0) continue; const src = { k: 'tab', i, j }; if (j === 0 && RANK(col[0].c) === 12) continue;
      for (let t = 0; t < 7; t++) if (t !== i && s.tab[t].length && canMove(s, src, { k: 'tab', i: t })) return { src, dst: { k: 'tab', i: t } }; }
    if (s.waste.length) for (let t = 0; t < 7; t++) if (canMove(s, { k: 'waste' }, { k: 'tab', i: t })) return { src: { k: 'waste' }, dst: { k: 'tab', i: t } };
    for (let i = 0; i < 7; i++) { const col = s.tab[i]; const j = col.findIndex(c => c.up); if (j > 0 && RANK(col[j].c) === 12) for (let t = 0; t < 7; t++) if (!s.tab[t].length) return { src: { k: 'tab', i, j }, dst: { k: 'tab', i: t } }; }
    return null;
  };
  const hintText = (s, h) => {
    if (!h) return s.stock.length ? 'Sem jogadas úteis à vista: tira do monte' : canRecycle(s) ? 'Sem jogadas úteis: recicla o monte' : 'Sem jogadas possíveis';
    const c = cardsAt(s, h.src)[0];
    if (h.dst.k === 'found') return 'Move o ' + name(c.c) + ' para a fundação';
    const col = s.tab[h.dst.i]; if (!col.length) return 'Põe o ' + name(c.c) + ' na coluna vazia';
    return 'Move o ' + name(c.c) + ' para o ' + name(col[col.length - 1].c);
  };
  const canAuto = s => !s.stock.length && !s.waste.length && s.tab.every(col => col.every(c => c.up)) && !won(s);
  const nextAuto = s => { let best = null; for (let i = 0; i < 7; i++) { const col = s.tab[i]; if (!col.length) continue; const c = col[col.length - 1]; for (let f = 0; f < 4; f++) if (canFound(c, s.found[f])) { if (!best || RANK(c.c) < best.r) best = { src: { k: 'tab', i, j: col.length - 1 }, dst: { k: 'found', i: f }, r: RANK(c.c) }; } } return best; };
  const snapshot = s => ({ stock: s.stock.map(c => ({ c: c.c, up: c.up })), waste: s.waste.map(c => ({ c: c.c, up: c.up })), found: s.found.map(p => p.map(c => ({ c: c.c, up: c.up }))), tab: s.tab.map(p => p.map(c => ({ c: c.c, up: c.up }))), draw: s.draw, moves: s.moves, score: s.score, passes: s.passes, vegas: s.vegas });
  /* pintas por valor: [coluna 0..2, linha 0..6]; as da metade de baixo ficam viradas */
  const PIPS = [[[1, 3]], [[1, 0], [1, 6]], [[1, 0], [1, 3], [1, 6]], [[0, 0], [2, 0], [0, 6], [2, 6]], [[0, 0], [2, 0], [1, 3], [0, 6], [2, 6]], [[0, 0], [2, 0], [0, 3], [2, 3], [0, 6], [2, 6]], [[0, 0], [2, 0], [1, 1.5], [0, 3], [2, 3], [0, 6], [2, 6]], [[0, 0], [2, 0], [1, 1.5], [0, 3], [2, 3], [1, 4.5], [0, 6], [2, 6]], [[0, 0], [2, 0], [0, 2], [2, 2], [1, 3], [0, 4], [2, 4], [0, 6], [2, 6]], [[0, 0], [2, 0], [1, 1], [0, 2], [2, 2], [0, 4], [2, 4], [1, 5], [0, 6], [2, 6]]];
  return { deal, draw, canStack, canFound, canMove, canRecycle, move, won, bonus, autoDst, hint, hintText, canAuto, nextAuto, cardsAt, snapshot, name, SUIT, RANK, RED, PIPS, RANKN, SUITN };
})();

/* naipes em SVG (viewBox 24): espadas, copas, ouros, paus */
const SO_PATH = [
  'M12 2C9 7 4 9.5 4 14a4 4 0 0 0 7 2.6c-.3 2-1.2 3.4-3 4.4h8c-1.8-1-2.7-2.4-3-4.4A4 4 0 0 0 20 14c0-4.5-5-7-8-12z',
  'M12 21C6 16 2.5 12.8 2.5 8.6A4.6 4.6 0 0 1 12 6a4.6 4.6 0 0 1 9.5 2.6C21.5 12.8 18 16 12 21z',
  'M12 2l7 10-7 10-7-10z',
  'M12 2a4 4 0 0 0-3.6 5.7A4 4 0 1 0 11 15c-.3 2.3-1.2 4-3 6h8c-1.8-2-2.7-3.7-3-6a4 4 0 1 0 2.6-7.3A4 4 0 0 0 12 2z',
];
const SO_RANK = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
const SO_COL = ['#1E1E26', '#D63A2E', '#D63A2E', '#1E1E26'];
const soSuitSvg = (s, col) => `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="${col || SO_COL[s]}" d="${SO_PATH[s]}"/></svg>`;
/* figuras J/Q/K: metade de cima desenhada, metade de baixo é a mesma rodada (viewBox 40×56) */
const soFace = (rk, s) => {
  const c = SO_COL[s], gold = '#E3B341', skin = '#F2D2B0', dark = '#2B2B33', alt = s === 1 || s === 2 ? '#2F5FBF' : '#B8352A';
  const head = `<circle cx="20" cy="14" r="5.2" fill="${skin}"/><path d="M15.2 13.5c1-3.6 8.6-3.6 9.6 0" fill="${dark}"/>`;
  const body = `<path d="M9 28c0-6 4-9 11-9s11 3 11 9z" fill="${c}"/><path d="M14 28c1-5 3-7 6-7s5 2 6 7z" fill="${alt}"/><path d="M17 23h6" stroke="${gold}" stroke-width="1.4"/>`;
  let top = '';
  if (rk === 12) top = `<path d="M13 9l2.5-4 2.5 3 2-4 2 4 2.5-3L27 9z" fill="${gold}"/><path d="M13 9h14v1.6H13z" fill="${gold}"/><path d="M16 18c1 3 7 3 8 0v3H16z" fill="${dark}"/>`;
  else if (rk === 11) top = `<path d="M14 9.5c0-4 12-4 12 0z" fill="${gold}"/><circle cx="20" cy="6.2" r="1.6" fill="${c}"/><path d="M14.5 13c-1 4 0 7 2 9M25.5 13c1 4 0 7-2 9" stroke="${dark}" stroke-width="2.2" fill="none" stroke-linecap="round"/><circle cx="20" cy="21" r="1.3" fill="${gold}"/>`;
  else top = `<path d="M14 10c1-4 11-4 12 0l-1.5-5-3 2-1.5-3-1.5 3-3-2z" fill="${c}"/><path d="M25 7l4-2-1 4z" fill="${gold}"/><path d="M26 17l5 9" stroke="${dark}" stroke-width="1.6"/><path d="M29.5 23l3-1 1 3z" fill="${gold}"/>`;
  const half = `<g>${top}${head}${body}</g>`;
  return `<svg viewBox="0 0 40 56"><rect x="1" y="1" width="38" height="54" rx="2" fill="#FBF6EA" stroke="${c}" stroke-width="1.2"/><path d="M1 28h38" stroke="${c}" stroke-width=".6" opacity=".4"/>${half}<g transform="rotate(180 20 28)">${half}</g><path d="M4 4h6M4 4v6M36 52h-6M36 52v-6" fill="none" stroke="${c}" stroke-width="1.2"/></svg>`;
};

Icons.app.solitaire = () => ico('gSo', ['#2FB76B', '#167A45', '#0A4A2A'], shadowed(
  `<rect x="20" y="31" width="34" height="46" rx="5" fill="#F3EEE2" transform="rotate(-14 37 54)"/><rect x="36" y="27" width="36" height="48" rx="5" fill="#fff"/>`, 2.5) +
  `<g transform="translate(23 36) rotate(-14 14 18) scale(.75)"><path fill="#1E1E26" d="${SO_PATH[0]}"/></g>` +
  `<g transform="translate(40 31) scale(.95)" fill="#D63A2E"><path d="${SO_PATH[1]}"/></g><text x="62" y="68" font-size="15" font-weight="800" fill="#D63A2E" font-family="Inter, sans-serif" text-anchor="middle">A</text>` +
  `<g transform="translate(58 55) scale(.5)" fill="#D63A2E"><path d="${SO_PATH[1]}"/></g>`);

const SOL_COVER = () => { const card = (x, y, r, rk, s, up) => `<g transform="translate(${x} ${y}) rotate(${r})">${up ? `<rect width="56" height="78" rx="6" fill="#FBF8F0" stroke="rgba(0,0,0,.25)"/><text x="6" y="18" font-family="Inter, system-ui, sans-serif" font-weight="800" font-size="14" fill="${SO_COL[s]}">${rk}</text><g transform="translate(16 26) scale(1.1)"><path fill="${SO_COL[s]}" d="${SO_PATH[s]}"/></g>` : `<rect width="56" height="78" rx="6" fill="#1F4E9C" stroke="#F3F3F6" stroke-width="2.5"/><rect x="6" y="6" width="44" height="66" rx="3" fill="none" stroke="rgba(255,255,255,.4)"/><path d="M6 6l44 66M50 6L6 72" stroke="rgba(255,255,255,.25)"/>`}</g>`;
  return `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><radialGradient id="gsoCf" cx="50%" cy="40%" r="75%"><stop offset="0" stop-color="#2A8A4F"/><stop offset="1" stop-color="#0B3D21"/></radialGradient></defs><rect width="400" height="200" fill="url(#gsoCf)"/><rect x="6" y="6" width="388" height="188" rx="14" fill="none" stroke="rgba(0,0,0,.35)" stroke-width="6"/><rect x="6" y="6" width="388" height="188" rx="14" fill="none" stroke="#7A4B23" stroke-width="3"/>` +
  card(40, 50, -14, '', 0, false) + card(96, 46, -6, 'K', 0, true) + card(150, 44, 0, 'Q', 1, true) + card(204, 46, 6, 'J', 3, true) + card(258, 50, 12, '10', 2, true) + card(312, 58, 18, 'A', 1, true) + `</svg>`; };

Arcade.game('solitaire', {
  name: 'Solitário', color: '#167A45', kind: 'puzzle', lowerIsBetter: true, unit: 'segundos', scoreLabel: 'Tempo', bestLabel: 'Melhor',
  desc: 'Klondike numa mesa de feltro: arrasta as cartas ou toca para as mover para o melhor sítio. Baralho a uma ou três cartas, pontuação Padrão ou Vegas, dicas, desfazer, fim automático e a vitória clássica.',
  tags: ['Cartas', 'Clássico'], modes: [{ key: '1', label: '1 carta' }, { key: '3', label: '3 cartas' }, { key: 'vegas', label: 'Vegas' }],
  cover: SOL_COVER,
  howto: { goal: 'Leva as 52 cartas para as quatro fundações, do Ás ao Rei, por naipe.', steps: ['Nas colunas as cartas descem por valor e alternam a cor.', 'Toca numa carta para a mover para o melhor sítio, ou arrasta-a.', 'Toca no monte para tirar cartas; só um Rei pode ir para uma coluna vazia.'], controls: [{ icon: 'hand', label: 'Toca ou arrasta as cartas' }, { icon: 'move', label: 'Espaço tira do monte, Z desfaz, H dá uma dica' }] },
  build(win) {
    const S = ENG.solitaire, CW = 56, CH = 78, X0 = 12, GX = 60, Y0 = 10, Y1 = 104, DD = 10, DU = 24, BW = 440, BH = 600;
    let drawN = Arcade.opt('solitaire:draw', '1') === '3' ? 3 : 1, vegas = Arcade.opt('solitaire:score', 'std') === 'vegas';
    const A = Arcade.shell(win, { id: 'solitaire', name: 'Solitário', color: '#167A45', pausable: true, scoreLabel: 'Tempo', bestLabel: 'Melhor', lowerIsBetter: true, onRestart: () => fresh(), onPause: () => { T.stop(); stopWin(); }, onResume: () => { if (s && !over && started) T.start(); } });
    const x = X(A), stage = A.el.stage; stage.style.position = 'relative';
    const board = el(`<div class="gso-board gpz-hide"><div class="gso-slot stock" style="transform:translate(${X0}px,${Y0}px)">${g('update', 24)}</div><div class="gso-slot waste" style="transform:translate(${X0 + GX}px,${Y0}px)"></div>${[0, 1, 2, 3].map(i => `<div class="gso-slot f s${i}" style="transform:translate(${X0 + (3 + i) * GX}px,${Y0}px)"><i class="s"></i></div>`).join('')}${[0, 1, 2, 3, 4, 5, 6].map(i => `<div class="gso-slot t" style="transform:translate(${X0 + i * GX}px,${Y1}px)"></div>`).join('')}<canvas class="gso-fx" width="${BW}" height="${BH}"></canvas></div>`);
    stage.appendChild(board);
    for (let i = 0; i < 4; i++) { board.style.setProperty('--gso-s' + i, svgUrl(soSuitSvg(i))); board.style.setProperty('--gso-w' + i, svgUrl(soSuitSvg(i, 'rgba(255,255,255,.6)'))); }
    const cards = [];
    for (let c = 0; c < 52; c++) {
      const su = S.SUIT(c), rk = S.RANK(c);
      const inner = rk >= 10 ? `<span class="gso-fc">${soFace(rk, su)}</span>` : `<span class="pp">${S.PIPS[rk].map(([col, row]) => `<i class="p${row > 3 ? ' f' : ''}${rk === 0 ? ' big' : ''}" style="left:${[32, 50, 68][col]}%;top:${34 + row * 7.6}%"></i>`).join('')}</span>`;
      const e = el(`<div class="gso-c s${su} ${S.RED(c) ? 'red' : 'blk'}" data-c="${c}"><div class="f"><b class="ix">${SO_RANK[rk]}<i class="s"></i></b><b class="ix r">${SO_RANK[rk]}</b>${inner}</div><div class="b"><i></i></div></div>`);
      board.insertBefore(e, board.lastElementChild); cards.push(e);
    }
    const fx = board.querySelector('.gso-fx');
    A.el.ctl.innerHTML = `<div class="gpz-tools"><div class="gpz-tool" data-k="undo">${g('arrowL', 20)}<span>Desfazer</span></div><div class="gpz-tool" data-k="hint">${g('bulb', 20)}<span>Dica</span></div><div class="gpz-tool" data-k="stats">${g('chart', 20)}<span>Resumo</span></div></div>`;
    const bUndo = A.el.ctl.querySelector('.gpz-tool[data-k="undo"]'), bHint = A.el.ctl.querySelector('.gpz-tool[data-k="hint"]'), bStats = A.el.ctl.querySelector('.gpz-tool[data-k="stats"]');

    let s = null, hist = [], over = true, started = false, where = {}, auto = false, firstMount = true, winRaf = 0, winOn = false, frames = [], lastSecs = 0;
    A._gpzTime = true;
    const T = Chrono(win, sec => { A.setScore(sec); A.el.score.textContent = fmtT(sec); bestFmt(A); });
    const STATS = 'gpzSol';
    const stats = () => stGet(STATS, { played: 0, won: 0, bestTime: 0, bestMoves: 0, bestScore: 0, streak: 0, maxStreak: 0, vegas: 0 });
    const mid = () => A.setMid(s ? `<span class="gm-hint gpz-pill"><b>${s.moves}</b> ${s.moves === 1 ? 'jogada' : 'jogadas'}</span><span class="gm-hint gpz-pill ${s.vegas && s.score < 0 ? 'bad' : ''}">${s.vegas ? 'Vegas' : 'Pontos'} <b>${s.score}</b></span>` : '');
    const put = (c, px, py, z, up, pile) => { const e = cards[c]; e.style.transform = `translate(${px}px,${py}px)`; e.style.zIndex = z; if (up && !e.classList.contains('up')) { if (pile.k === 'tab' && started) { e.classList.remove('turn'); void e.offsetWidth; e.classList.add('turn'); } } e.classList.toggle('up', up); where[c] = pile; };
    const layout = () => {
      let z = 1;
      s.stock.forEach((c, i) => put(c.c, X0, Y0, z++, false, { k: 'stock', i }));
      const wn = s.waste.length, shown = Math.min(wn, s.draw === 3 ? 3 : 1);
      s.waste.forEach((c, i) => { const k = i - (wn - shown); put(c.c, X0 + GX + (k > 0 ? k * 16 : 0), Y0, z++, true, { k: 'waste', i }); });
      s.found.forEach((p, f) => p.forEach((c, i) => put(c.c, X0 + (3 + f) * GX, Y0, z++, true, { k: 'found', i: f, j: i })));
      s.tab.forEach((col, i) => { let y = Y1; col.forEach((c, j) => { put(c.c, X0 + i * GX, y, z++, c.up, { k: 'tab', i, j }); y += c.up ? DU : DD; }); });
      board.querySelector('.gso-slot.stock').classList.toggle('gso-empty', !s.stock.length); board.querySelector('.gso-slot.stock').classList.toggle('dead', !s.stock.length && !S.canRecycle(s));
      bUndo.classList.toggle('off', !hist.length || over || auto); bHint.classList.toggle('off', over || auto);
      mid();
    };
    const push = () => { hist.push(S.snapshot(s)); if (hist.length > 200) hist.shift(); };
    const tick = () => { if (!started) { started = true; T.start(); } };
    /* ---- animação de vitória: cartas a saltar e a cair, com rasto (canvas não se limpa), único rAF dos puzzles ---- */
    const sprites = [];
    const sprite = c => { if (sprites[c]) return sprites[c]; const cv = document.createElement('canvas'); cv.width = CW; cv.height = CH; const k = cv.getContext('2d'), su = S.SUIT(c), rk = S.RANK(c), col = SO_COL[su];
      k.fillStyle = '#FBF8F0'; k.beginPath(); k.moveTo(6, 0); k.arcTo(CW, 0, CW, CH, 6); k.arcTo(CW, CH, 0, CH, 6); k.arcTo(0, CH, 0, 0, 6); k.arcTo(0, 0, CW, 0, 6); k.closePath(); k.fill(); k.strokeStyle = 'rgba(0,0,0,.3)'; k.lineWidth = 1; k.stroke();
      k.fillStyle = col; k.font = '800 13px Inter, system-ui, sans-serif'; k.textBaseline = 'top'; k.fillText(SO_RANK[rk], 5, 4);
      const p = new Path2D(SO_PATH[su]); k.save(); k.translate(4, 18); k.scale(.5, .5); k.fill(p); k.restore(); k.save(); k.translate(14, 24); k.scale(1.2, 1.2); k.fill(p); k.restore();
      if (rk >= 10) { k.font = '800 22px Inter, system-ui, sans-serif'; k.fillText(SO_RANK[rk], 30, 50); }
      sprites[c] = cv; return cv; };
    const stopWin = () => { if (winRaf) cancelAnimationFrame(winRaf); winRaf = 0; if (winOn) { winOn = false; fx.classList.remove('on'); try { fx.getContext('2d').clearRect(0, 0, BW, BH); } catch (e) {} } };
    const playWin = () => {
      stopWin(); winOn = true; fx.classList.add('on'); const k = fx.getContext('2d'); k.clearRect(0, 0, BW, BH);
      const flying = [], queue = []; for (let r = 12; r >= 0; r--) for (let f = 0; f < 4; f++) queue.push({ c: s.found[f][r] ? s.found[f][r].c : f * 13 + r, x: X0 + (3 + f) * GX, y: Y0 });
      let last = 0, nextAt = 0, t0 = 0, n = 0; frames = [];
      const step = t => {
        if (!winOn) return; if (!t0) t0 = t; const dt = Math.min(2.5, last ? (t - last) / 16.667 : 1); last = t; const f0 = performance.now();
        if (t >= nextAt && queue.length) { const q = queue.shift(); const sp = (Math.random() < .5 ? -1 : 1) * (2.2 + Math.random() * 3); flying.push({ c: q.c, x: q.x, y: q.y, vx: sp, vy: -(2 + Math.random() * 6) }); nextAt = t + 120; }
        for (let i = flying.length - 1; i >= 0; i--) { const p = flying[i]; p.vy += .38 * dt; p.x += p.vx * dt; p.y += p.vy * dt; if (p.y + CH > BH) { p.y = BH - CH; p.vy = -p.vy * .78; } k.drawImage(sprite(p.c), p.x | 0, p.y | 0); if (p.x < -CW || p.x > BW) flying.splice(i, 1); }
        if (n++ < 400) frames.push(performance.now() - f0);
        if ((!flying.length && !queue.length) || t - t0 > 14000) { stopWin(); return; }
        winRaf = requestAnimationFrame(step);
      };
      winRaf = requestAnimationFrame(step);
    };
    const finish = () => {
      over = true; T.stop(); const secs = T.secs(), bon = S.bonus(s, secs); s.score += bon; auto = false;
      const st = stats(); st.played++; st.won++; st.streak++; st.maxStreak = Math.max(st.maxStreak, st.streak); if (!st.bestTime || secs < st.bestTime) st.bestTime = secs; if (!st.bestMoves || s.moves < st.bestMoves) st.bestMoves = s.moves; if (s.vegas) st.vegas += s.score; else if (s.score > st.bestScore) st.bestScore = s.score; stSet(STATS, st);
      Arcade.flag('solitaireWin'); layout(); x.sfx('chime'); x.celebrate('win'); x.flash('Ganhaste!', 'big'); x.haptic('medium');
      setTimeout(() => { if (winOn || over) playWin(); }, 350);
      setTimeout(() => x.end({ title: 'Ganhaste', sub: `${fmtT(secs)} · ${plural(s.moves, 'jogada', 'jogadas')}${bon ? ' · bónus de tempo ' + bon : ''}`, score: secs, win: true, stats: [{ label: 'Pontos' + (s.vegas ? ' Vegas' : ''), value: String(s.score) }, { label: 'Jogadas', value: String(s.moves) }, { label: 'Vitórias seguidas', value: String(st.streak) }, { label: 'Melhor tempo', value: fmtT(st.bestTime) }] }), 2600);
    };
    const after = r => { layout(); if (r && r.turned >= 0) x.sfx('flip'); if (S.won(s)) { finish(); return; } if (!auto && S.canAuto(s)) autoFinish(); };
    const autoFinish = async () => {
      auto = true; layout(); note(stage, 'A terminar', 'good', 1400);
      while (!S.won(s) && !over) {
        const m = S.nextAuto(s); if (!m) break;
        S.move(s, m.src, m.dst); x.sfx('swish'); layout(); await sleep(85);
      }
      auto = false; if (S.won(s)) finish(); else layout();
    };
    const doMove = (src, dst) => { if (!S.canMove(s, src, dst)) return false; push(); const r = S.move(s, src, dst); tick(); x.sfx(dst.k === 'found' ? 'score' : 'place'); after(r); return true; };
    const nope = src => { x.sfx('fail'); const cs = S.cardsAt(s, src); cs.forEach(c => { const e = cards[c.c]; e.classList.remove('nope'); void e.offsetWidth; e.classList.add('nope'); }); };
    const tapCard = src => {
      if (over || auto) return;
      if (src.k === 'stock') { if (!s.stock.length && !S.canRecycle(s)) { note(stage, s.waste.length ? 'Sem mais passagens pelo monte' : 'Monte vazio', 'bad', 1300); x.sfx('fail'); return; } push(); S.draw(s); tick(); x.sfx('flip'); after(); return; }
      if (src.k === 'waste' && src.i !== s.waste.length - 1) return;
      if (src.k === 'found') { src = { k: 'found', i: src.i }; }
      const dst = S.autoDst(s, src);
      if (dst) doMove(src, dst); else nope(src);
    };
    board.querySelector('.gso-slot.stock').onclick = () => { if (over || auto || s.stock.length) return; tapCard({ k: 'stock' }); };

    /* arrastar: posição do ponteiro em px do tabuleiro = (clientX - UI.vrect(board).left) / UI.zoom(board) */
    let drag = null;
    const pos = e => { const r = UI.vrect(board), z = UI.zoom(board) || 1; return { x: (e.clientX - r.left) / z, y: (e.clientY - r.top) / z, z }; };
    board.addEventListener('pointerdown', e => {
      if (over || auto || drag) return;
      const ce = e.target.closest('.gso-c'); if (!ce) return;
      const c = +ce.dataset.c, w = where[c]; if (!w) return;
      if (w.k === 'stock') { if (w.i === s.stock.length - 1) tapCard({ k: 'stock' }); return; }
      if (w.k === 'waste' && w.i !== s.waste.length - 1) return;
      if (w.k === 'tab' && !s.tab[w.i][w.j].up) return;
      const src = w.k === 'waste' ? { k: 'waste' } : w.k === 'found' ? { k: 'found', i: w.i } : { k: 'tab', i: w.i, j: w.j };
      const cs = S.cardsAt(s, src).map(q => cards[q.c]);
      const p0 = pos(e);
      drag = { src, els: cs, sx: e.clientX, sy: e.clientY, z: p0.z, moved: false, base: cs.map(el2 => el2.style.transform), z0: cs.map(el2 => el2.style.zIndex) };
      try { board.setPointerCapture(e.pointerId); } catch (err) {}
    });
    board.addEventListener('pointermove', e => {
      if (!drag) return;
      const dx = (e.clientX - drag.sx) / drag.z, dy = (e.clientY - drag.sy) / drag.z;
      if (!drag.moved && Math.hypot(dx, dy) < 6) return;
      if (!drag.moved) { drag.moved = true; drag.els.forEach((el2, i) => { el2.classList.add('drag'); el2.style.zIndex = 500 + i; }); }
      drag.els.forEach((el2, i) => { el2.style.transform = drag.base[i] + ` translate(${dx}px,${dy}px) scale(1.04)`; });
    });
    const endDrag = e => {
      if (!drag) return; const d = drag; drag = null;
      d.els.forEach(el2 => el2.classList.remove('drag'));
      if (!d.moved) { d.els.forEach((el2, i) => { el2.style.zIndex = d.z0[i]; }); tapCard(d.src); return; }
      const p = pos(e); let dst = null;
      const col = Math.floor((p.x - X0 + 2) / GX);
      if (p.y < Y1 - 6) { if (col >= 3 && col <= 6) dst = { k: 'found', i: col - 3 }; }
      else if (col >= 0 && col <= 6) dst = { k: 'tab', i: col };
      if (!dst || !doMove(d.src, dst)) { x.sfx('fail'); layout(); }
    };
    board.addEventListener('pointerup', endDrag); board.addEventListener('pointercancel', endDrag);

    bUndo.onclick = () => { if (!hist.length || over || auto) return; s = hist.pop(); x.haptic('light'); layout(); };
    bHint.onclick = () => {
      if (over || auto) return;
      const h = S.hint(s); note(stage, S.hintText(s, h), h ? 'good' : '', 1800);
      if (!h) { const st = board.querySelector('.gso-slot.stock'); st.classList.remove('hint'); void st.offsetWidth; st.classList.add('hint'); setTimeout(() => st.classList.remove('hint'), 1200); return; }
      const cs = S.cardsAt(s, h.src); cs.forEach(c => { const e = cards[c.c]; e.classList.remove('hint'); void e.offsetWidth; e.classList.add('hint'); setTimeout(() => e.classList.remove('hint'), 1400); });
      if (h.dst.k === 'tab' && s.tab[h.dst.i].length) { const c = s.tab[h.dst.i][s.tab[h.dst.i].length - 1]; const e = cards[c.c]; e.classList.add('hint2'); setTimeout(() => e.classList.remove('hint2'), 1400); }
      x.sfx('tick');
    };
    bStats.onclick = () => { const st = stats(); statsSheet('Solitário', [{ v: st.played, l: 'Partidas' }, { v: pct(st.won, st.played), l: 'Vitórias' }, { v: st.streak, l: 'Seguidas' }], [{ l: 'Melhor tempo', v: st.bestTime ? fmtT(st.bestTime) : '--' }, { l: 'Menos jogadas', v: st.bestMoves || '--' }, { l: 'Melhor pontuação', v: st.bestScore || '--' }, { l: 'Saldo Vegas', v: st.vegas }, { l: 'Maior série', v: st.maxStreak }]); };
    const fresh = () => {
      stopWin(); T.stop(); T.set(0); started = false; over = false; auto = false; hist = []; s = S.deal(drawN); s.vegas = vegas; if (vegas) s.score = -52; board.classList.remove('gpz-hide');
      if (firstMount) { firstMount = false; cards.forEach(e => { e.style.transition = 'none'; e.style.transform = `translate(${X0}px,${Y0}px)`; }); void board.offsetWidth; cards.forEach(e => { e.style.transition = ''; }); let k = 0; s.tab.forEach(col => col.forEach(c => { cards[c.c].style.transitionDelay = (k++ * 22) + 'ms'; })); layout(); setTimeout(() => cards.forEach(e => { e.style.transitionDelay = ''; }), 1200); }
      else layout();
    };
    const opts = x.options([
      { key: 'draw', label: 'Baralho', values: [{ v: '1', label: '1 carta' }, { v: '3', label: '3 cartas' }], cur: String(drawN), onChange: v => { drawN = v === '3' ? 3 : 1; Arcade.setOpt('solitaire:draw', v); fresh(); } },
      { key: 'score', label: 'Pontos', values: [{ v: 'std', label: 'Padrão' }, { v: 'vegas', label: 'Vegas' }], cur: vegas ? 'vegas' : 'std', onChange: v => { vegas = v === 'vegas'; Arcade.setOpt('solitaire:score', v); fresh(); } },
    ]);
    (async () => { await x.ready('Solitário', 'Toca para começar'); fresh(); })();
    win.onClose = () => { T.stop(); stopWin(); };
    const api = { pause() { T.stop(); stopWin(); }, resume() { if (!over && started && !A.paused) T.start(); },
      key(e) { if (e.key === ' ' || e.key === 'Enter') { e.preventDefault(); tapCard({ k: 'stock' }); } else if (e.key === 'z' || e.key === 'Z') bUndo.click(); else if (e.key === 'h' || e.key === 'H') bHint.click(); },
      test: { get s() { return s; }, tap: tapCard, move: doMove, fresh, get over() { return over; }, hint: () => bHint.click(), undo: () => bUndo.click(), layout, cards,
        lift(i) { const col = s.tab[i]; if (!col || !col.length) return; const j = col.findIndex(c => c.up); const cs = col.slice(j).map(q => cards[q.c]); cs.forEach((e, k) => { e.classList.add('drag'); e.style.zIndex = 500 + k; e.style.transform += ' translate(' + (i > 3 ? -34 : 34) + 'px,-26px) scale(1.04)'; }); },
        winNow() { s.stock = []; s.waste = []; s.tab = [[], [], [], [], [], [], []]; s.found = [0, 1, 2, 3].map(su => Array.from({ length: 13 }, (_, r) => ({ c: su * 13 + r, up: true }))); s.moves = 118; if (!s.vegas) s.score = 640; else s.score = 208; started = true; T.set(274); T.start(); finish(); },
        nearWin() { s.stock = []; s.waste = []; s.found = [0, 1, 2, 3].map(su => Array.from({ length: 12 }, (_, r) => ({ c: su * 13 + r, up: true }))); s.tab = [[{ c: 12, up: true }], [], [{ c: 25, up: true }], [], [{ c: 38, up: true }], [], [{ c: 51, up: true }]]; hist = []; layout(); },
        get frames() { return frames; }, get winOn() { return winOn; }, setVegas(v) { vegas = !!v; opts.set('score', v ? 'vegas' : 'std'); fresh(); } } };
    LIVE.game = api; return api;
  },
});

/* =====================================================================
   LUZES APAGADAS: solucionador em GF(2) (eliminação de Gauss sobre bits) que dá o MÍNIMO real de toques e a dica
   certa em qualquer estado; 25 níveis desenhados à mão (5×5, todos verificados resolúveis) e níveis gerados sem fim;
   tamanhos 5×5 e 6×6 (no 6×6 todo o padrão tem solução única).
   ===================================================================== */
ENG.lights = (() => {
  const press = (grid, i, n) => { n = n || 5; const r = (i / n) | 0, c = i % n; grid[i] ^= 1; if (r > 0) grid[i - n] ^= 1; if (r < n - 1) grid[i + n] ^= 1; if (c > 0) grid[i - 1] ^= 1; if (c < n - 1) grid[i + 1] ^= 1; };
  /* casas a premir com o menor número de toques, ou null se o padrão não tiver solução */
  const solve = (grid, n) => {
    const N = n * n, M = [];
    for (let j = 0; j < N; j++) { const row = new Uint8Array(N + 1); const r = (j / n) | 0, c = j % n; row[j] = 1; if (r > 0) row[j - n] = 1; if (r < n - 1) row[j + n] = 1; if (c > 0) row[j - 1] = 1; if (c < n - 1) row[j + 1] = 1; row[N] = grid[j] ? 1 : 0; M.push(row); }
    const piv = []; let rank = 0;
    for (let col = 0; col < N && rank < N; col++) {
      let p = -1; for (let r = rank; r < N; r++) if (M[r][col]) { p = r; break; }
      if (p < 0) continue; const t = M[p]; M[p] = M[rank]; M[rank] = t;
      for (let r = 0; r < N; r++) if (r !== rank && M[r][col]) { const a = M[r], b = M[rank]; for (let k = col; k <= N; k++) a[k] ^= b[k]; }
      piv.push(col); rank++;
    }
    for (let r = rank; r < N; r++) if (M[r][N]) return null;
    const isPiv = new Uint8Array(N); piv.forEach(c => { isPiv[c] = 1; }); const free = []; for (let c = 0; c < N; c++) if (!isPiv[c]) free.push(c);
    let best = null; const combos = 1 << Math.min(free.length, 8);
    for (let m = 0; m < combos; m++) {
      const xv = new Uint8Array(N); free.forEach((f, k) => { xv[f] = (m >> k) & 1; });
      for (let r = 0; r < rank; r++) { const col = piv[r]; let v = M[r][N]; for (const f of free) if (M[r][f] && xv[f]) v ^= 1; xv[col] = v; }
      let w = 0; for (let i = 0; i < N; i++) w += xv[i];
      if (!best || w < best.w) best = { w, x: xv };
    }
    const cells = []; for (let i = 0; i < N; i++) if (best.x[i]) cells.push(i);
    return cells;
  };
  /* 25 níveis à mão (5×5), por ordem de dificuldade (mínimo de toques crescente); todos resolúveis */
  const HAND = [
    '.....' + '..#..' + '.###.' + '..#..' + '.....',   /* 1 cruz (1 toque) */
    '#....' + '##...' + '###..' + '####.' + '####.',   /* 2 escada */
    '#####' + '.....' + '#####' + '.....' + '#####',   /* 3 riscas */
    '#.#.#' + '#.#.#' + '#.#.#' + '#.#.#' + '#.#.#',   /* 4 postes */
    '.#.#.' + '####.' + '#####' + '.###.' + '..#..',   /* 5 coração */
    '.....' + '.#.#.' + '.....' + '....#' + '.###.',   /* 6 sorriso */
    '#.#.#' + '.....' + '#.#.#' + '.....' + '#.#.#',   /* 7 bolinhas */
    '#####' + '#...#' + '#...#' + '#...#' + '#####',   /* 8 moldura */
    '.....' + '.....' + '.....' + '.....' + '##.##',   /* 9 portão */
    '#...#' + '##.##' + '#.#.#' + '#...#' + '#...#',   /* 10 letra M */
    '.###.' + '#...#' + '#...#' + '#...#' + '.###.',   /* 11 letra O */
    '#...#' + '.....' + '..#..' + '.....' + '#...#',   /* 12 vértices */
    '..#..' + '..#..' + '#####' + '..#..' + '..#..',   /* 13 cruz grande */
    '#...#' + '#...#' + '#####' + '#...#' + '#...#',   /* 14 letra H */
    '#####' + '..#..' + '..#..' + '..#..' + '..#..',   /* 15 letra T */
    '#####' + '....#' + '.###.' + '#....' + '#####',   /* 16 serpente */
    '##.##' + '##.##' + '.....' + '##.##' + '##.##',   /* 17 blocos */
    '#.#.#' + '.#.#.' + '#.#.#' + '.#.#.' + '#.#.#',   /* 18 xadrez */
    '##..#' + '##.#.' + '..#..' + '.#.##' + '#..##',   /* 19 laço */
    '.....' + '.###.' + '.#.#.' + '.###.' + '.....',   /* 20 anel */
    '..#..' + '.#.#.' + '#...#' + '.#.#.' + '..#..',   /* 21 diamante */
    '#...#' + '.#.#.' + '..#..' + '..#..' + '..#..',   /* 22 letra Y */
    '#...#' + '.#.#.' + '..#..' + '.#.#.' + '#...#',   /* 23 letra X */
    '..#..' + '.###.' + '#####' + '.###.' + '..#..',   /* 24 losango */
    '#####' + '#####' + '#####' + '#####' + '#####',   /* 25 tudo aceso */
  ];
  const NAMES = ['Cruz', 'Escada', 'Riscas', 'Postes', 'Coração', 'Sorriso', 'Bolinhas', 'Moldura', 'Portão', 'Letra M', 'Letra O', 'Vértices', 'Cruz grande', 'Letra H', 'Letra T', 'Serpente', 'Blocos', 'Xadrez', 'Laço', 'Anel', 'Diamante', 'Letra Y', 'Letra X', 'Losango', 'Tudo aceso'];
  const hand = k => { const p = HAND[k]; if (!p) return null; const grid = Uint8Array.from(p, ch => ch === '#' ? 1 : 0); const sol = solve(grid, 5); return { grid, solution: sol || [], min: sol ? sol.length : 0, name: NAMES[k] || '', n: 5, hand: true }; };
  /* nível gerado: toques aleatórios (k cresce com o nível), nunca já apagado; mínimo pelo solucionador */
  const make = (level, n, rng) => {
    n = n || 5; rng = rng || Math.random; const N = n * n;
    const k = Math.min(N - 2, 3 + ((level - 1) * 2));
    for (let tries = 0; tries < 60; tries++) {
      const grid = new Uint8Array(N), cells = shuffleR(Array.from({ length: N }, (_, i) => i), rng).slice(0, k);
      cells.forEach(i => press(grid, i, n));
      if (grid.some(v => v)) { const sol = solve(grid, n) || cells; return { grid, solution: sol, min: sol.length, name: 'Gerado', n, hand: false }; }
    }
    const grid = new Uint8Array(N); press(grid, (N / 2) | 0, n); return { grid, solution: [(N / 2) | 0], min: 1, name: 'Gerado', n, hand: false };
  };
  return { press, solve, make, hand, HAND, NAMES };
})();

Icons.app.lights = () => ico('gLi', ['#2B2F55', '#14162E', '#090A18'], `<rect x="16" y="16" width="68" height="68" rx="12" fill="#0B0C1C" stroke="rgba(255,255,255,.12)"/>` +
  [0, 1, 2].map(r => [0, 1, 2].map(c => { const on = (r + c) % 2 === 0; return on ? `<rect x="${21.5 + c * 20}" y="${21.5 + r * 20}" width="17" height="17" rx="4" fill="#FFB020" opacity=".35" transform="translate(-2 -2) scale(1.22)" transform-origin="${30 + c * 20} ${30 + r * 20}"/><rect x="${21.5 + c * 20}" y="${21.5 + r * 20}" width="17" height="17" rx="4" fill="#FFD54A"/><rect x="${24 + c * 20}" y="${23.5 + r * 20}" width="12" height="5" rx="2.5" fill="#fff" opacity=".55"/>` : `<rect x="${21.5 + c * 20}" y="${21.5 + r * 20}" width="17" height="17" rx="4" fill="#1C1E3A" stroke="rgba(255,255,255,.08)"/>`; }).join('')).join(''));

const LIGHTS_COVER = () => `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><radialGradient id="gliCb" cx="50%" cy="50%" r="70%"><stop offset="0" stop-color="#1B1E3F"/><stop offset="1" stop-color="#06071A"/></radialGradient><radialGradient id="gliCl" cx="50%" cy="50%" r="50%"><stop offset="0" stop-color="#FFB020" stop-opacity=".55"/><stop offset="1" stop-color="#FFB020" stop-opacity="0"/></radialGradient></defs><rect width="400" height="200" fill="url(#gliCb)"/>` +
  `<g transform="translate(96 22)">${'.#.#.####.#####.###...#..'.split('').map((ch, i) => { const c = i % 5, r = (i / 5) | 0, X = c * 42, Y = r * 32; return ch === '#' ? `<circle cx="${X + 17}" cy="${Y + 14}" r="34" fill="url(#gliCl)"/><rect x="${X}" y="${Y}" width="34" height="28" rx="7" fill="#FFD54A"/><rect x="${X + 5}" y="${Y + 4}" width="24" height="8" rx="4" fill="#fff" opacity=".5"/>` : `<rect x="${X}" y="${Y}" width="34" height="28" rx="7" fill="#15173A" stroke="rgba(255,255,255,.1)"/>`; }).join('')}</g>` +
  `<g transform="translate(330 70)" fill="none" stroke="#FFD54A" stroke-width="3" stroke-linecap="round"><circle cx="20" cy="20" r="12"/><path d="M20 2v6M20 32v6M2 20h6M32 20h6M7.3 7.3l4.2 4.2M28.5 28.5l4.2 4.2M7.3 32.7l4.2-4.2M28.5 11.5l4.2-4.2"/></g></svg>`;

Arcade.game('lights', {
  name: 'Luzes Apagadas', color: '#F5B800', kind: 'puzzle', lowerIsBetter: true, unit: 'toques', scoreLabel: 'Toques', bestLabel: 'Melhor',
  /* tabelas do hub: 5×5 na de sempre ("lights") e 6×6 em "lights:6" */
  variants: [{ key: '5', label: '5×5', board: 'lights' }, { key: '6', label: '6×6', board: 'lights:6' }],
  desc: 'Apaga todas as luzes néon: cada toque inverte a casa e as vizinhas. Vinte e cinco níveis desenhados à mão e outros gerados sem fim, em 5×5 ou 6×6, com o mínimo real e dicas.',
  tags: ['Lógica', 'Néon'], modes: [{ key: 'campaign', label: 'Campanha' }, { key: 'random', label: 'Sem fim' }],
  cover: LIGHTS_COVER,
  howto: { goal: 'Apaga todas as luzes do painel com o menor número de toques.', steps: ['Cada toque inverte a casa tocada e as quatro vizinhas.', 'Uma partida são cinco níveis seguidos; os toques somam-se.', 'Acertar no mínimo de toques dá um nível perfeito.'], controls: [{ icon: 'hand', label: 'Toca nas luzes' }, { icon: 'move', label: 'Setas movem o cursor, Enter toca, H dá uma dica' }] },
  build(win) {
    const L = ENG.lights, PROG = 'gpzLights';
    let n = Arcade.opt('lights:n', '5') === '6' ? 6 : 5, campaign = Arcade.opt('lights:mode', 'campaign') !== 'random';
    const boardId = () => (n === 6 ? 'lights:6' : 'lights');
    const A = Arcade.shell(win, { id: boardId(), name: 'Luzes Apagadas', color: '#F5B800', pausable: false, scoreLabel: 'Toques', bestLabel: 'Melhor', lowerIsBetter: true, onRestart: () => fresh() });
    const x = X(A), stage = A.el.stage; stage.style.position = 'relative';
    const wrap = el(`<div class="gli-wrap gpz-hide"><div class="gli-top"><div class="gli-lv">${[1, 2, 3, 4, 5].map(i => `<i data-l="${i}"></i>`).join('')}</div><div class="gli-name"></div></div><div class="gli-frame"><div class="gli-board"></div></div><div class="gli-badge">Perfeito</div></div>`);
    stage.appendChild(wrap);
    const boardEl = wrap.querySelector('.gli-board'), frame = wrap.querySelector('.gli-frame'), dots = [...wrap.querySelectorAll('.gli-lv i')], nameEl = wrap.querySelector('.gli-name'), badge = wrap.querySelector('.gli-badge');
    let cells = [];
    const buildCells = () => { boardEl.innerHTML = ''; boardEl.className = 'gli-board n' + n; cells = []; for (let i = 0; i < n * n; i++) { const c = el(`<div class="gli-c" data-i="${i}"><i></i></div>`); boardEl.appendChild(c); cells.push(c); } cur.resize(n, n); };
    A.el.ctl.innerHTML = `<div class="gpz-tools"><div class="gpz-tool" data-k="again">${g('update', 20)}<span>Reiniciar</span></div><div class="gpz-tool" data-k="hint">${g('bulb', 20)}<span>Dica</span></div><div class="gpz-tool" data-k="levels">${g('grid', 20)}<span>Níveis</span></div><div class="gpz-tool" data-k="how">${g('book', 20)}<span>Como jogar</span></div></div>`;
    const bAgain = A.el.ctl.querySelector('.gpz-tool[data-k="again"]'), bHint = A.el.ctl.querySelector('.gpz-tool[data-k="hint"]'), bLevels = A.el.ctl.querySelector('.gpz-tool[data-k="levels"]'); A.el.ctl.querySelector('.gpz-tool[data-k="how"]').onclick = () => x.howto();

    let Z = null, grid = null, step = 1, total = 0, over = true, lock = false, presses = 0, perfects = 0, hintsLv = 0, run = [], levelNo = 0, firstMount = true;
    const cur = Cursor(5, 5, i => cells.forEach((c, k) => c.classList.toggle('cur', k === i)), i => tap(i));
    const prog = () => stGet(PROG, { done: {}, perfect: {}, next5: 0, next6: 0, played: 0, won: 0, totalPerfect: 0 });
    const paint = () => { for (let i = 0; i < n * n; i++) cells[i].classList.toggle('on', !!grid[i]); dots.forEach((d, k) => { d.classList.toggle('done', k + 1 < step); d.classList.toggle('cur', k + 1 === step); }); nameEl.textContent = Z.hand ? 'Nível ' + levelNo + ' · ' + Z.name : (campaign ? 'Nível ' + levelNo + ' · gerado' : 'Sem fim'); A.setMid(`<span class="gm-hint gpz-pill">${g('flame', 15)}<b>${presses}</b> este nível</span><span class="gm-hint gpz-pill">mínimo <b>${Z.min}</b></span>`); A.setScore(total); };
    const loadLevel = () => {
      const P = prog(); hintsLv = 0; presses = 0;
      if (campaign) { levelNo = run[step - 1]; Z = (n === 5 && levelNo <= 25) ? L.hand(levelNo - 1) : L.make(levelNo - (n === 5 ? 25 : 0), n, mulberry(levelNo * 97 + n)); }
      else { levelNo = step; Z = L.make(step + 1, n); }
      grid = Uint8Array.from(Z.grid); paint();
      if (firstMount) { firstMount = false; cascade(boardEl, cells, 14); }
    };
    const levelDone = () => {
      lock = true; const perfect = presses <= Z.min && !hintsLv; if (perfect) perfects++;
      const P = prog(); const key = n + ':' + levelNo; if (campaign) { P.done[key] = Math.min(P.done[key] || 99, presses); if (perfect) P.perfect[key] = 1; const nk = 'next' + n; if (levelNo >= (P[nk] || 0)) P[nk] = levelNo; }
      if (perfect) { P.totalPerfect = (P.totalPerfect | 0) + 1; badge.classList.remove('in'); void badge.offsetWidth; badge.classList.add('in'); setTimeout(() => badge.classList.remove('in'), 1500); x.sfx('bonus'); } else x.sfx('level');
      if (step < 5) x.celebrate('level');
      stSet(PROG, P);
      boardEl.classList.remove('clear'); void boardEl.offsetWidth; boardEl.classList.add('clear');
      if (step >= 5) {
        over = true; const P2 = prog(); P2.played++; P2.won++; stSet(PROG, P2);
        if (perfects >= 5) Arcade.flag('lightsPerfect');
        x.flash('Luzes apagadas!', 'big'); x.celebrate('win');
        setTimeout(() => x.end({ title: 'Luzes apagadas', sub: `${total} toques em cinco níveis${perfects ? ' · ' + plural(perfects, 'perfeito', 'perfeitos') : ''}`, score: total, win: true, board: boardId(), stats: [{ label: 'Toques', value: String(total) }, { label: 'Níveis perfeitos', value: perfects + '/5' }, { label: 'Tamanho', value: n + '×' + n }, { label: 'Perfeitos no total', value: String(prog().totalPerfect | 0) }] }), 900);
        return;
      }
      x.flash(perfect ? 'Perfeito' : 'Nível concluído', perfect ? 'bonus' : 'good');
      setTimeout(() => { step++; lock = false; loadLevel(); }, 900);
    };
    const tap = i => {
      if (over || lock) return;
      L.press(grid, i, n); presses++; total++; x.sfx('place'); x.haptic('light');
      const c = cells[i]; c.classList.remove('pop'); void c.offsetWidth; c.classList.add('pop'); paint();
      if (grid.every(v => !v)) levelDone();
    };
    boardEl.addEventListener('click', e => { const c = e.target.closest('.gli-c'); if (c) tap(+c.dataset.i); });
    bAgain.onclick = () => { if (over || lock) return; grid = Uint8Array.from(Z.grid); presses = 0; x.haptic('light'); paint(); };
    bHint.onclick = () => {
      if (over || lock) return;
      const sol = L.solve(grid, n); if (!sol || !sol.length) return;
      const i = sol[rnd(sol.length)]; total += 3; hintsLv++; cells[i].classList.remove('hint'); void cells[i].offsetWidth; cells[i].classList.add('hint'); setTimeout(() => cells[i].classList.remove('hint'), 1500);
      note(stage, 'Toca na casa assinalada. ' + (sol.length === 1 ? 'Falta um toque' : 'Faltam ' + sol.length + ' toques no mínimo'), 'good', 1800); x.flash('+3 toques', 'warn'); x.sfx('tick'); paint();
    };
    bLevels.onclick = () => {
      const P = prog();
      const body = el(`<div class="gli-levels">${L.HAND.map((p, k) => { const key = '5:' + (k + 1), d = P.done[key]; return `<div class="gli-lvc ${d ? 'done' : ''} ${P.perfect[key] ? 'perf' : ''}" data-k="${k + 1}"><div class="gli-mini">${p.split('').map(ch => `<i class="${ch === '#' ? 'on' : ''}"></i>`).join('')}</div><b>${k + 1}</b><span>${esc(L.NAMES[k])}</span>${d ? `<em>${d} ${d === 1 ? 'toque' : 'toques'}</em>` : ''}</div>`; }).join('')}</div>`);
      const sh = UI.sheet({ title: 'Níveis à mão (5×5)', body, right: 'OK' });
      body.addEventListener('click', e => { const c = e.target.closest('.gli-lvc'); if (!c) return; const k = +c.dataset.k; sh.close(); n = 5; campaign = true; Arcade.setOpt('lights:n', '5'); Arcade.setOpt('lights:mode', 'campaign'); opts.set('n', '5'); opts.set('mode', 'campaign'); fresh(k); });
    };
    const fresh = startAt => {
      step = 1; total = 0; perfects = 0; over = false; lock = false; wrap.classList.remove('gpz-hide'); A.setId(boardId()); buildCells(); boardEl.classList.remove('clear');
      const P = prog(); const first = startAt || ((P['next' + n] | 0) + 1); run = Array.from({ length: 5 }, (_, k) => first + k);
      loadLevel();
    };
    const opts = x.options([
      { key: 'n', label: 'Tamanho', values: [{ v: '5', label: '5×5' }, { v: '6', label: '6×6' }], cur: String(n), onChange: v => { n = v === '6' ? 6 : 5; Arcade.setOpt('lights:n', v); fresh(); } },
      { key: 'mode', label: 'Níveis', values: [{ v: 'campaign', label: 'Campanha' }, { v: 'random', label: 'Sem fim' }], cur: campaign ? 'campaign' : 'random', onChange: v => { campaign = v !== 'random'; Arcade.setOpt('lights:mode', v); fresh(); } },
    ]);
    (async () => { await x.ready('Luzes Apagadas', 'Toca para começar'); fresh(); })();
    const api = { pause() {}, resume() {}, key(e) { if (e.key === 'h' || e.key === 'H') { bHint.click(); return; } if (e.key === 'r' || e.key === 'R') { bAgain.click(); return; } cur.key(e); },
      test: { get grid() { return grid; }, get Z() { return Z; }, tap, get level() { return step; }, get levelNo() { return levelNo; }, get total() { return total; }, get over() { return over; }, fresh, hint: () => bHint.click(), solve() { const sol = L.solve(grid, n) || []; sol.forEach(i => tap(i)); }, setSize(v) { n = v === 6 ? 6 : 5; opts.set('n', String(n)); fresh(); }, levels: () => bLevels.click() } };
    LIVE.game = api; return api;
  },
});

/* =====================================================================
   DESLIZANTE 3×3, 4×4 e 5×5: só permutações solúveis (paridade das inversões); modo Números com bisel ou modo
   IMAGEM com quatro ilustrações SVG próprias cortadas em peças (cada peça mostra o seu pedaço por
   background-position FIXO, nunca animado), miniatura, espreitar e revelação da imagem ao resolver.
   ===================================================================== */
ENG.sliding = (() => {
  const solvable = (t, n) => {
    let inv = 0; const a = t.filter(v => v);
    for (let i = 0; i < a.length; i++) for (let j = i + 1; j < a.length; j++) if (a[i] > a[j]) inv++;
    if (n & 1) return inv % 2 === 0;
    const fromBottom = n - (((t.indexOf(0)) / n) | 0);
    return (inv + fromBottom) % 2 === 1;
  };
  const solved = t => t.every((v, i) => (i === t.length - 1 ? v === 0 : v === i + 1));
  const mix = (n, rng) => { rng = rng || Math.random; let t; do { t = shuffleR(Array.from({ length: n * n }, (_, i) => (i + 1) % (n * n)), rng); } while (!solvable(t, n) || solved(t)); return t; };
  /* pedaço da imagem da peça v (casa de origem) numa grelha n×n de `size` px: posição do fundo */
  const piece = (v, n, size) => { const i = v - 1, c = i % n, r = (i / n) | 0, cell = size / n; return { x: -c * cell, y: -r * cell, cell }; };
  return { solvable, solved, shuffle: mix, piece };
})();

/* quatro ilustrações (viewBox 100×100), desenhadas à mão em gradientes: Vinewood ao pôr do sol, praia, montanha, cidade à noite */
const SL_ART = {
  vinewood: () => `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><linearGradient id="s" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#2A1A52"/><stop offset=".45" stop-color="#C9413F"/><stop offset=".72" stop-color="#F28C3A"/><stop offset="1" stop-color="#FFD37A"/></linearGradient><radialGradient id="g" cx="50%" cy="50%" r="50%"><stop offset="0" stop-color="#FFF2B0"/><stop offset="1" stop-color="#FFB347" stop-opacity="0"/></radialGradient><linearGradient id="h" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#6B4B3E"/><stop offset="1" stop-color="#2E1F1C"/></linearGradient></defs><rect width="100" height="100" fill="url(#s)"/><circle cx="56" cy="62" r="30" fill="url(#g)"/><circle cx="56" cy="62" r="13" fill="#FFF0B3"/><path d="M0 70c14-6 22-14 36-13s20 8 34 6 20-10 30-6v43H0z" fill="#5A3466" opacity=".85"/><path d="M0 84c16-10 30-22 50-21s32 10 50 2v35H0z" fill="url(#h)"/><g transform="translate(22 60) rotate(-7)" font-family="Inter, Arial, sans-serif" font-weight="900" font-size="9.5" fill="#F7F4EC" letter-spacing="1"><text x="0" y="0">VINEWOOD</text></g><g stroke="#1E1414" stroke-width="1.6" stroke-linecap="round"><path d="M12 100V78M88 100V82"/></g><g fill="#1E1414"><ellipse cx="12" cy="77" rx="9" ry="3" transform="rotate(-25 12 77)"/><ellipse cx="12" cy="77" rx="9" ry="3" transform="rotate(25 12 77)"/><ellipse cx="12" cy="76" rx="3" ry="8"/><ellipse cx="88" cy="81" rx="8" ry="2.6" transform="rotate(-25 88 81)"/><ellipse cx="88" cy="81" rx="8" ry="2.6" transform="rotate(25 88 81)"/><ellipse cx="88" cy="80" rx="2.6" ry="7"/></g></svg>`,
  beach: () => `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><linearGradient id="s" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#3FA9F5"/><stop offset="1" stop-color="#CFF0FF"/></linearGradient><linearGradient id="w" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1273C4"/><stop offset="1" stop-color="#52C6F0"/></linearGradient><linearGradient id="d" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#F6E3B4"/><stop offset="1" stop-color="#E2C184"/></linearGradient></defs><rect width="100" height="100" fill="url(#s)"/><circle cx="76" cy="20" r="9" fill="#FFF3B0"/><circle cx="76" cy="20" r="14" fill="#FFF3B0" opacity=".3"/><g fill="#fff" opacity=".9"><ellipse cx="24" cy="22" rx="10" ry="4"/><ellipse cx="30" cy="19" rx="6" ry="4"/><ellipse cx="52" cy="30" rx="7" ry="3"/></g><rect y="46" width="100" height="30" fill="url(#w)"/><g fill="none" stroke="#fff" stroke-width="1.2" stroke-linecap="round" opacity=".7"><path d="M6 56q4-2 8 0t8 0M40 62q4-2 8 0t8 0M70 54q4-2 8 0t8 0M20 68q4-2 8 0t8 0"/></g><path d="M0 100V78c20-8 40-10 60-4s30 4 40-2v28z" fill="url(#d)"/><path d="M0 78c20-8 40-10 60-4s30 4 40-2v4c-10 6-24 6-40 2S20 74 0 82z" fill="#fff" opacity=".6"/><path d="M22 96c0-16 3-28 10-38" stroke="#8B5A2B" stroke-width="3" fill="none" stroke-linecap="round"/><g fill="#2F9E44"><ellipse cx="32" cy="56" rx="12" ry="3.5" transform="rotate(-35 32 56)"/><ellipse cx="32" cy="56" rx="12" ry="3.5" transform="rotate(20 32 56)"/><ellipse cx="31" cy="55" rx="3.5" ry="11" transform="rotate(-5 31 55)"/><ellipse cx="33" cy="57" rx="12" ry="3.5" transform="rotate(60 33 57)"/></g><g transform="translate(70 70)"><path d="M-14 6a14 14 0 0 1 28 0z" fill="#E63946"/><path d="M-9 6a9 9 0 0 1 18 0z" fill="#fff"/><path d="M-4 6a4 4 0 0 1 8 0z" fill="#E63946"/><path d="M0 6v22" stroke="#444" stroke-width="1.4"/></g><circle cx="52" cy="90" r="5" fill="#FFD166"/><path d="M52 85a5 5 0 0 1 0 10" fill="#EF476F"/></svg>`,
  mountain: () => `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><linearGradient id="s" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0D1B3E"/><stop offset=".55" stop-color="#4C6BAA"/><stop offset="1" stop-color="#F2B58C"/></linearGradient><linearGradient id="l" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#5C7FB8"/><stop offset="1" stop-color="#1D2F5A"/></linearGradient></defs><rect width="100" height="100" fill="url(#s)"/><g fill="#fff"><circle cx="14" cy="12" r=".9"/><circle cx="30" cy="8" r=".7"/><circle cx="46" cy="16" r=".8"/><circle cx="62" cy="6" r=".7"/><circle cx="88" cy="14" r=".9"/><circle cx="74" cy="24" r=".6"/></g><circle cx="80" cy="22" r="7" fill="#FFF6D8"/><path d="M0 62l18-24 14 18 12-26 16 24 10-14 18 22 12-12v26H0z" fill="#3B4F85"/><path d="M0 70l22-30 16 22 14-34 18 30 12-16 18 26v10H0z" fill="#26355F"/><path d="M52 28l-5 11h3l2-3 3 5 3-6h3z" fill="#F4F6FB"/><path d="M22 40l-3 7h2l1-2 2 3 2-4h2z" fill="#E9EEF8"/><g fill="#132040"><path d="M8 80l4-10 4 10zM18 82l5-13 5 13zM30 80l4-9 4 9zM66 82l5-12 5 12zM80 80l4-9 4 9zM90 82l4-8 4 8z"/></g><rect y="80" width="100" height="20" fill="url(#l)"/><path d="M0 84h100" stroke="#fff" opacity=".3" stroke-width=".8"/><path d="M70 85l10 14-20 0z" fill="#FFF6D8" opacity=".35"/><path d="M48 86l4 12h-8z" fill="#2E4172" opacity=".6"/></svg>`,
  city: () => `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><linearGradient id="s" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#060A22"/><stop offset="1" stop-color="#23306B"/></linearGradient><pattern id="w" width="5" height="7" patternUnits="userSpaceOnUse"><rect x="1" y="1.5" width="2.2" height="3" fill="#FFD36B"/></pattern><linearGradient id="r" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1B2550"/><stop offset="1" stop-color="#0B1030"/></linearGradient></defs><rect width="100" height="100" fill="url(#s)"/><g fill="#fff"><circle cx="10" cy="14" r=".8"/><circle cx="24" cy="6" r=".6"/><circle cx="40" cy="12" r=".7"/><circle cx="58" cy="5" r=".8"/><circle cx="90" cy="18" r=".7"/><circle cx="72" cy="10" r=".5"/></g><circle cx="82" cy="20" r="8" fill="#FFF5CF"/><circle cx="79" cy="18" r="7" fill="#0B1234" opacity=".9"/><g fill="#0E1538"><rect x="4" y="46" width="12" height="34"/><rect x="20" y="30" width="14" height="50"/><rect x="38" y="40" width="10" height="40"/><rect x="52" y="22" width="16" height="58"/><rect x="72" y="36" width="12" height="44"/><rect x="88" y="48" width="10" height="32"/><path d="M27 22l1-8 1 8zM60 14l0-8 1 8z"/></g><g fill="url(#w)" opacity=".9"><rect x="5" y="48" width="10" height="30"/><rect x="21" y="32" width="12" height="46"/><rect x="39" y="42" width="8" height="36"/><rect x="53" y="24" width="14" height="54"/><rect x="73" y="38" width="10" height="40"/><rect x="89" y="50" width="8" height="28"/></g><rect y="80" width="100" height="20" fill="url(#r)"/><path d="M0 90h100" stroke="#FFD36B" stroke-width=".8" stroke-dasharray="4 4" opacity=".7"/><g fill="#FFD36B" opacity=".25"><rect x="21" y="82" width="12" height="10"/><rect x="53" y="82" width="14" height="12"/></g><circle cx="30" cy="95" r="1.5" fill="#FF5A5A"/><circle cx="34" cy="95" r="1.5" fill="#FF5A5A"/><circle cx="64" cy="94" r="1.5" fill="#FFF"/><circle cx="68" cy="94" r="1.5" fill="#FFF"/></svg>`,
};
const SL_NAMES = { vinewood: 'Vinewood', beach: 'Praia', mountain: 'Montanha', city: 'Cidade' };

Icons.app.sliding = () => ico('gSl', ['#C39BFF', '#7A4DE8', '#3F1F9C'], shadowed(
  [[0, 0, '1'], [1, 0, '2'], [2, 0, '3'], [0, 1, '4'], [1, 1, '5'], [2, 1, '6'], [0, 2, '7'], [2, 2, '8']].map(([c, r]) => `<rect x="${18.5 + c * 21.5}" y="${18.5 + r * 21.5}" width="19.5" height="19.5" rx="4.5" fill="#F5F1FF"/>`).join(''), 2) +
  [[0, 0, '1'], [1, 0, '2'], [2, 0, '3'], [0, 1, '4'], [1, 1, '5'], [2, 1, '6'], [0, 2, '7'], [2, 2, '8']].map(([c, r, t]) => `<rect x="${18.5 + c * 21.5}" y="${18.5 + r * 21.5}" width="19.5" height="8" rx="4" fill="#fff" opacity=".6"/><text x="${28.25 + c * 21.5}" y="${33 + r * 21.5}" text-anchor="middle" font-size="11.5" font-weight="800" fill="#5A32C8" font-family="Inter, sans-serif">${t}</text>`).join('') +
  `<rect x="40" y="61.5" width="19.5" height="19.5" rx="4.5" fill="rgba(0,0,0,.22)"/>`);

const SL_COVER = () => `<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="gslCb" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#2A1A52"/><stop offset="1" stop-color="#0E0A24"/></linearGradient><linearGradient id="gslCs" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#2A1A52"/><stop offset=".45" stop-color="#C9413F"/><stop offset=".72" stop-color="#F28C3A"/><stop offset="1" stop-color="#FFD37A"/></linearGradient><linearGradient id="gslCt" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".25"/><stop offset="1" stop-color="#000" stop-opacity=".2"/></linearGradient></defs><rect width="400" height="200" fill="url(#gslCb)"/>` +
  `<g transform="translate(118 16)">${[0, 1, 2, 3, 4, 5, 6, 7].map(i => { const c = i % 3, r = (i / 3) | 0; const X = c * 58, Y = r * 58; return `<g transform="translate(${X} ${Y})${i === 5 ? ' translate(0 0)' : ''}"><rect width="54" height="54" rx="7" fill="url(#gslCs)"/>${r === 1 ? `<circle cx="${30 - X}" cy="${36 - Y + 58}" r="16" fill="#FFF0B3"/>` : ''}<path d="M0 ${44 - r * 58 + 0}c18-8 36-12 54-4v60H0z" fill="#3A2436" opacity="${r === 2 ? 1 : 0}"/><rect width="54" height="54" rx="7" fill="url(#gslCt)"/><text x="6" y="14" font-family="Inter, system-ui, sans-serif" font-weight="800" font-size="10" fill="rgba(255,255,255,.85)">${i + 1}</text></g>`; }).join('')}<rect x="116" y="116" width="54" height="54" rx="7" fill="rgba(0,0,0,.35)" stroke="rgba(255,255,255,.12)"/></g>` +
  `<g transform="translate(310 60)">${['#F28C3A', '#3FA9F5', '#4C6BAA', '#23306B'].map((c, i) => `<rect x="${(i % 2) * 34}" y="${((i / 2) | 0) * 34}" width="28" height="28" rx="6" fill="${c}"/>`).join('')}</g></svg>`;

Arcade.game('sliding', {
  name: 'Deslizante', color: '#7A4DE8', kind: 'puzzle', lowerIsBetter: true, unit: 'segundos', scoreLabel: 'Tempo', bestLabel: 'Melhor', variants: [{ key: '3', label: '3×3' }, { key: '4', label: '4×4' }, { key: '5', label: '5×5' }],
  desc: 'Puzzle de peças deslizantes em 3×3, 4×4 ou 5×5, só com baralhadas resolúveis. Números com bisel ou quatro ilustrações para recompor, com miniatura, espreitar e revelação da imagem no fim.',
  tags: ['Clássico', 'Imagem'], modes: [{ key: 'num', label: 'Números\u200b' }, { key: 'img', label: 'Imagem' }],
  cover: SL_COVER,
  howto: { goal: 'Ordena as peças deslizando-as para o espaço vazio.', steps: ['Toca numa peça da linha ou coluna do vazio para a deslizar (várias de uma vez).', 'No modo Imagem recompõe a ilustração; a miniatura e o Espreitar ajudam.', 'Os números seguem por ordem, com o vazio no canto inferior direito.'], controls: [{ icon: 'hand', label: 'Toca ou desliza o dedo' }, { icon: 'move', label: 'Setas ou WASD empurram uma peça para o vazio' }] },
  build(win) {
    const SL = ENG.sliding, SIZE = 336, STATS = 'gpzSliding';
    let n = +Arcade.opt('sliding:n', '3'); if (![3, 4, 5].includes(n)) n = 3;
    let visual = Arcade.opt('sliding:visual', 'num') === 'img' ? 'img' : 'num', art = Arcade.opt('sliding:art', 'vinewood'); if (!SL_ART[art]) art = 'vinewood';
    const A = Arcade.shell(win, { id: 'sliding:' + n, name: 'Deslizante', color: '#7A4DE8', pausable: true, scoreLabel: 'Tempo', bestLabel: 'Melhor', lowerIsBetter: true, onRestart: () => fresh(), onPause: () => T.stop(), onResume: () => { if (!over && started) T.start(); } });
    const x = X(A), stage = A.el.stage; stage.style.position = 'relative';
    const wrap = el(`<div class="gsl-wrap gpz-hide"><div class="gsl-head"><div class="gsl-thumb"></div><div class="gsl-info"><b></b><span></span></div></div><div class="gsl-frame"><div class="gsl-board"></div><div class="gsl-peek"></div></div></div>`);
    stage.appendChild(wrap);
    const board = wrap.querySelector('.gsl-board'), thumb = wrap.querySelector('.gsl-thumb'), peek = wrap.querySelector('.gsl-peek'), info = wrap.querySelector('.gsl-info'), frame = wrap.querySelector('.gsl-frame');
    A.el.ctl.innerHTML = `<div class="gpz-tools"><div class="gpz-tool" data-k="peek">${g('eye', 20)}<span>Espreitar</span></div><div class="gpz-tool" data-k="stats">${g('chart', 20)}<span>Resumo</span></div><div class="gpz-tool" data-k="how">${g('book', 20)}<span>Como jogar</span></div></div>`;
    const bPeek = A.el.ctl.querySelector('.gpz-tool[data-k="peek"]'), bStats = A.el.ctl.querySelector('.gpz-tool[data-k="stats"]'); A.el.ctl.querySelector('.gpz-tool[data-k="how"]').onclick = () => x.howto();
    let t = null, tiles = [], last = null, moves = 0, over = true, started = false, cell = 108, gap = 6, firstMount = true, peekT = null;
    A._gpzTime = true;
    const T = Chrono(win, s => { A.setScore(s); A.el.score.textContent = fmtT(s); bestFmt(A); });
    const stats = () => stGet(STATS, {});
    const nStats = (st, k) => Object.assign({ played: 0, won: 0, best: 0, bestMoves: 0 }, (st || stats())[k] || {});
    const mid = () => A.setMid(`<span class="gm-hint gpz-pill">${g('move', 15)}<b>${moves}</b> ${moves === 1 ? 'jogada' : 'jogadas'}</span><span class="gm-hint gpz-pill">${n}×${n}</span>`);
    const artUrl = () => svgUrl(SL_ART[art]());
    const geo = () => { gap = n === 3 ? 6 : n === 4 ? 5 : 4; cell = (SIZE - gap * (n - 1)) / n; board.style.setProperty('--gsl-cell', cell + 'px'); board.className = 'gsl-board n' + n + (visual === 'img' ? ' img' : ''); wrap.classList.toggle('img', visual === 'img');
      const u = visual === 'img' ? artUrl() : 'none'; board.style.setProperty('--gsl-art', u); board.style.setProperty('--gsl-size', (n * cell) + 'px'); thumb.style.backgroundImage = u; peek.style.backgroundImage = u;
      info.firstChild.textContent = visual === 'img' ? SL_NAMES[art] : 'Números\u200b'; info.lastChild.textContent = visual === 'img' ? 'Recompõe a ilustração' : 'Vazio no canto inferior direito'; };
    const place = (v, i) => { const e = tiles[v]; if (!e) return; const r = (i / n) | 0, c = i % n; e.style.transform = `translate(${c * (cell + gap)}px, ${r * (cell + gap)}px)`; };
    const build = () => {
      board.innerHTML = ''; tiles = [];
      for (let v = 1; v < n * n; v++) { const p = SL.piece(v, n, n * cell); const e = el(`<div class="gsl-t" style="--h:${Math.round(((v - 1) / (n * n - 1)) * 300)};background-position:${p.x}px ${p.y}px"><b>${v}</b><em>${v}</em></div>`); e.dataset.v = v; tiles[v] = e; board.appendChild(e); }
      const p = SL.piece(n * n, n, n * cell); last = el(`<div class="gsl-t last" style="background-position:${p.x}px ${p.y}px"></div>`); board.appendChild(last); tiles[n * n] = last; place(n * n, n * n - 1);
      for (let i = 0; i < n * n; i++) if (t[i]) place(t[i], i);
      if (firstMount) { firstMount = false; cascade(board, tiles.filter(Boolean), 16); }
    };
    const tick = () => { if (!started) { started = true; T.start(); } };
    const win_ = () => {
      over = true; T.stop(); const secs = T.secs(); A.setId('sliding:' + n);
      const st = stats(), k = String(n), s = nStats(st, k); s.played++; s.won++; if (!s.best || secs < s.best) s.best = secs; if (!s.bestMoves || moves < s.bestMoves) s.bestMoves = moves; st[k] = s; stSet(STATS, st);
      if (n === 5) Arcade.flag('sliding5');
      board.classList.add('done'); frame.classList.add('done');
      if (visual === 'img') { const k = SIZE / (n * cell); for (let v = 1; v <= n * n; v++) { const e = tiles[v]; if (!e) continue; const i = v - 1; e.style.transform = 'translate(' + ((i % n) * cell) + 'px, ' + (((i / n) | 0) * cell) + 'px)'; } board.style.transform = 'scale(' + k.toFixed(4) + ')'; board.classList.add('seam'); } x.sfx('chime'); x.celebrate('win'); x.flash('Resolvido!', 'big');
      setTimeout(() => x.end({ title: 'Resolvido', sub: `${fmtT(secs)} · ${plural(moves, 'jogada', 'jogadas')} · ${n}×${n}${visual === 'img' ? ' · ' + SL_NAMES[art] : ''}`, score: secs, win: true, stats: [{ label: 'Tempo', value: fmtT(secs) }, { label: 'Jogadas', value: String(moves) }, { label: 'Melhor ' + n + '×' + n, value: fmtT(s.best) }, { label: 'Menos jogadas', value: String(s.bestMoves) }] }), 1500);
    };
    /* uma peça na linha ou coluna do vazio desliza (com as que estão pelo meio) */
    const slide = i => {
      if (over) return false;
      const z = t.indexOf(0), zr = (z / n) | 0, zc = z % n, r = (i / n) | 0, c = i % n;
      if (i === z || (r !== zr && c !== zc)) return false;
      const step = r === zr ? (c > zc ? 1 : -1) : (r > zr ? n : -n);
      let k = z; while (k !== i) { const nk = k + step; t[k] = t[nk]; place(t[k], k); k = nk; }
      t[i] = 0; moves++; tick(); x.sfx('slide'); mid();
      if (SL.solved(t)) win_();
      return true;
    };
    const dir = d => { const z = t.indexOf(0), zr = (z / n) | 0, zc = z % n; const from = { u: zr < n - 1 ? z + n : -1, d: zr > 0 ? z - n : -1, l: zc < n - 1 ? z + 1 : -1, r: zc > 0 ? z - 1 : -1 }[d]; if (from >= 0) slide(from); };
    board.addEventListener('click', e => { const tl = e.target.closest('.gsl-t'); if (!tl || tl === last) return; const i = t.indexOf(+tl.dataset.v); if (i >= 0) slide(i); });
    Arcade.dirs(board, dir);
    const doPeek = () => { if (visual !== 'img' || over) return; peek.classList.add('in'); x.sfx('tick'); clearTimeout(peekT); peekT = setTimeout(() => peek.classList.remove('in'), 1500); win.timers.push(peekT); };
    bPeek.onclick = doPeek;
    bStats.onclick = () => { const st = stats(); statsSheet('Deslizante', [3, 4, 5].map(k => ({ v: nStats(st, String(k)).won, l: k + '×' + k })), [3, 4, 5].map(k => { const s = nStats(st, String(k)); return { l: 'Melhor ' + k + '×' + k, v: s.best ? fmtT(s.best) + ' · ' + plural(s.bestMoves, 'jogada', 'jogadas') : '--' }; })); };
    const fresh = () => { T.stop(); T.set(0); started = false; over = false; moves = 0; geo(); t = SL.shuffle(n); wrap.classList.remove('gpz-hide'); board.classList.remove('done', 'seam'); board.style.transform = ''; frame.classList.remove('done'); peek.classList.remove('in'); build(); mid(); A.setId('sliding:' + n); bPeek.classList.toggle('off', visual !== 'img'); };
    const opts = x.options([
      { key: 'n', label: 'Tamanho', values: [{ v: '3', label: '3×3' }, { v: '4', label: '4×4' }, { v: '5', label: '5×5' }], cur: String(n), onChange: v => { n = +v; Arcade.setOpt('sliding:n', v); fresh(); } },
      { key: 'visual', label: 'Visual', values: [{ v: 'num', label: 'Números\u200b' }, { v: 'img', label: 'Imagem' }], cur: visual, onChange: v => { visual = v; Arcade.setOpt('sliding:visual', v); geo(); bPeek.classList.toggle('off', visual !== 'img'); } },
      { key: 'art', label: 'Imagem', values: Object.keys(SL_ART).map(k => ({ v: k, label: SL_NAMES[k] })), cur: art, onChange: v => { art = v; Arcade.setOpt('sliding:art', v); if (visual !== 'img') { visual = 'img'; Arcade.setOpt('sliding:visual', 'img'); opts.set('visual', 'img'); } geo(); bPeek.classList.remove('off'); } },
    ]);
    (async () => { await x.ready('Deslizante', 'Toca para começar'); fresh(); })();
    win.onClose = () => T.stop();
    const api = { pause() { T.stop(); }, resume() { if (!over && started && !A.paused) T.start(); }, key(e) { const m = { ArrowUp: 'u', ArrowDown: 'd', ArrowLeft: 'l', ArrowRight: 'r', w: 'u', s: 'd', a: 'l', d: 'r', W: 'u', S: 'd', A: 'l', D: 'r' }[e.key]; if (m) { e.preventDefault(); dir(m); } else if (e.key === 'p' || e.key === 'P') doPeek(); },
      test: { get t() { return t; }, slide, dir, fresh, setTime(s) { T.set(s); T.start(); started = true; moves = Math.max(moves, (s / 2) | 0); mid(); }, get over() { return over; }, get moves() { return moves; }, peek: doPeek, setVisual(v, a) { visual = v; if (a) art = a; opts.set('visual', v); if (a) opts.set('art', a); geo(); bPeek.classList.toggle('off', visual !== 'img'); }, setSize(k) { n = k; opts.set('n', String(k)); fresh(); },
        nearSolve() { for (let i = 0; i < t.length; i++) t[i] = i + 1; t[t.length - 1] = 0; const a = t.length - 1; t[a] = t[a - 1]; t[a - 1] = 0; for (let i = 0; i < t.length; i++) if (t[i]) place(t[i], i); } } };
    LIVE.game = api; return api;
  },
});

/* ---------- ganchos só para testes (harness e Node): motores puros, o jogo em primeiro plano e o toque no "Toca para começar" ---------- */
window.__gbp = { eng: ENG, get live() { return LIVE.game; },
  tapReady() { const w = window.System && System.currentApp() && System.windows[System.currentApp()]; const sh = w && w._gs; if (sh && sh.waiting && sh._go) { sh._go(); return true; } return false; } };
if (window.__gb && window.__gb.eng) Object.assign(window.__gb.eng, ENG);
})();
