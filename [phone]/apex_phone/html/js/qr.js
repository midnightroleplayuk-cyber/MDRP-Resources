/* ============================================================
   QR - codificador de códigos QR partilhado (eSIM, 2026-10-04)
   Modo byte (UTF-8), correção de erros M, versões 1..10 (até 213 bytes). Sem dependências.
   - QR.matrix(text, opts?) → { version, size, mask, ecc: 'M', modules } (modules[y][x] = true = módulo escuro).
     opts.minVersion (1..10) força uma versão mínima; opts.mask (0..7) força a máscara (por defeito escolhe a de menor
     penalização, como manda a norma ISO 18004). Texto demasiado longo → RangeError.
   - QR.svg(text, opts?) → string <svg> pronta a meter em innerHTML: um único <path> (um retângulo por corrida de módulos
     escuros), shape-rendering crispEdges. opts: margin (zona de silêncio em módulos, por defeito 4 - não baixar de 2 ou
     os leitores falham), size (px; sem size o svg ocupa 100% do contentor via viewBox), dark ('#000'), light ('#fff';
     null = fundo transparente), cls (classe do <svg>), minVersion, mask.
   - QR.path(m, margin?) → só o atributo d do <path> para quem queira montar o seu próprio svg.
   Validado no scratchpad (esim/qrtest): matriz igual módulo a módulo à biblioteca qrcode (npm) nas 8 máscaras e em
   todas as versões 1..10, e descodificado de volta por um leitor independente (jsQR) a partir do PNG.
   ============================================================ */
(function (root, factory) {
  const api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.QR = api;
})(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  /* tabela ECC M por versão: [codewords de correção por bloco, blocos do grupo 1, dados por bloco g1, blocos g2, dados g2] */
  const ECC_M = [null,
    [10, 1, 16, 0, 0], [16, 1, 28, 0, 0], [26, 1, 44, 0, 0], [18, 2, 32, 0, 0], [24, 2, 43, 0, 0],
    [16, 4, 27, 0, 0], [18, 4, 31, 0, 0], [22, 2, 38, 2, 39], [22, 3, 36, 2, 37], [26, 4, 43, 1, 44]];
  /* centros dos padrões de alinhamento (a versão 1 não tem) */
  const ALIGN = [null, [], [6, 18], [6, 22], [6, 26], [6, 30], [6, 34], [6, 22, 38], [6, 24, 42], [6, 26, 46], [6, 28, 50]];
  const MAX_VERSION = 10;

  /* ---------- GF(256), polinómio 0x11D (o da norma) ---------- */
  const EXP = new Uint8Array(512), LOG = new Uint8Array(256);
  (function () { let x = 1; for (let i = 0; i < 255; i++) { EXP[i] = x; LOG[x] = i; x <<= 1; if (x & 0x100) x ^= 0x11D; } for (let i = 255; i < 512; i++) EXP[i] = EXP[i - 255]; })();
  const gmul = (a, b) => (a === 0 || b === 0) ? 0 : EXP[LOG[a] + LOG[b]];

  /* polinómio gerador de grau n: produto de (x - α^i), i = 0..n-1 (coeficientes do mais alto para o mais baixo, sem o 1 inicial) */
  const genCache = {};
  function generator(n) {
    if (genCache[n]) return genCache[n];
    let g = [1];
    for (let i = 0; i < n; i++) {
      const next = new Array(g.length + 1).fill(0);
      for (let j = 0; j < g.length; j++) { next[j] ^= g[j]; next[j + 1] ^= gmul(g[j], EXP[i]); }
      g = next;
    }
    return (genCache[n] = g.slice(1));
  }
  /* resto da divisão dos dados pelo gerador = codewords de correção (Reed-Solomon) */
  function rsRemainder(data, n) {
    const gen = generator(n), rem = new Array(n).fill(0);
    for (let i = 0; i < data.length; i++) {
      const f = data[i] ^ rem[0];
      rem.shift(); rem.push(0);
      if (f) for (let j = 0; j < n; j++) rem[j] ^= gmul(gen[j], f);
    }
    return rem;
  }

  /* ---------- texto → bytes UTF-8 (sem TextEncoder: o CEF tem, o Node antigo talvez não) ---------- */
  function utf8(text) {
    const s = String(text == null ? '' : text), out = [];
    for (let i = 0; i < s.length; i++) {
      let c = s.charCodeAt(i);
      if (c >= 0xD800 && c <= 0xDBFF && i + 1 < s.length) { const d = s.charCodeAt(i + 1); if (d >= 0xDC00 && d <= 0xDFFF) { c = 0x10000 + ((c - 0xD800) << 10) + (d - 0xDC00); i++; } }
      if (c < 0x80) out.push(c);
      else if (c < 0x800) out.push(0xC0 | (c >> 6), 0x80 | (c & 63));
      else if (c < 0x10000) out.push(0xE0 | (c >> 12), 0x80 | ((c >> 6) & 63), 0x80 | (c & 63));
      else out.push(0xF0 | (c >> 18), 0x80 | ((c >> 12) & 63), 0x80 | ((c >> 6) & 63), 0x80 | (c & 63));
    }
    return out;
  }

  const dataCapacity = v => { const e = ECC_M[v]; return e[1] * e[2] + e[3] * e[4]; };

  /* ---------- fluxo de bits: modo byte (0100), contagem (8 bits até v9, 16 a partir de v10), dados, terminador, enchimento ---------- */
  function encodeData(bytes, v) {
    const cap = dataCapacity(v) * 8, bits = [];
    const put = (val, len) => { for (let i = len - 1; i >= 0; i--) bits.push((val >>> i) & 1); };
    put(4, 4);
    put(bytes.length, v < 10 ? 8 : 16);
    bytes.forEach(b => put(b, 8));
    if (bits.length > cap) return null;
    put(0, Math.min(4, cap - bits.length));
    while (bits.length % 8) bits.push(0);
    const out = [];
    for (let i = 0; i < bits.length; i += 8) { let b = 0; for (let j = 0; j < 8; j++) b = (b << 1) | bits[i + j]; out.push(b); }
    for (let pad = 0xEC; out.length < cap / 8; pad ^= 0xEC ^ 0x11) out.push(pad);
    return out;
  }

  /* divide em blocos, calcula a correção de cada um e entrelaça (dados coluna a coluna, depois correção) */
  function interleave(data, v) {
    const e = ECC_M[v], blocks = [];
    let off = 0;
    for (let g = 0; g < 2; g++) {
      const count = e[1 + g * 2], len = e[2 + g * 2];
      for (let b = 0; b < count; b++) { const d = data.slice(off, off + len); off += len; blocks.push({ d, ec: rsRemainder(d, e[0]) }); }
    }
    const out = [], maxLen = Math.max.apply(null, blocks.map(b => b.d.length));
    for (let i = 0; i < maxLen; i++) blocks.forEach(b => { if (i < b.d.length) out.push(b.d[i]); });
    for (let i = 0; i < e[0]; i++) blocks.forEach(b => out.push(b.ec[i]));
    return out;
  }

  /* ---------- matriz ---------- */
  function Grid(v) {
    const size = v * 4 + 17;
    const mod = [], fn = [];
    for (let y = 0; y < size; y++) { mod.push(new Array(size).fill(false)); fn.push(new Array(size).fill(false)); }
    return { v, size, mod, fn, set(x, y, dark) { mod[y][x] = !!dark; fn[y][x] = true; } };
  }

  function drawFunctionPatterns(G) {
    const n = G.size;
    for (let i = 0; i < n; i++) { G.set(6, i, i % 2 === 0); G.set(i, 6, i % 2 === 0); }      // padrões de temporização
    [[3, 3], [n - 4, 3], [3, n - 4]].forEach(([cx, cy]) => {                                  // localizadores + separadores
      for (let dy = -4; dy <= 4; dy++) for (let dx = -4; dx <= 4; dx++) {
        const x = cx + dx, y = cy + dy, d = Math.max(Math.abs(dx), Math.abs(dy));
        if (x >= 0 && x < n && y >= 0 && y < n) G.set(x, y, d !== 2 && d !== 4);
      }
    });
    const al = ALIGN[G.v], last = al.length - 1;                                               // alinhamento (menos os 3 cantos)
    for (let i = 0; i <= last; i++) for (let j = 0; j <= last; j++) {
      if ((i === 0 && j === 0) || (i === 0 && j === last) || (i === last && j === 0)) continue;
      for (let dy = -2; dy <= 2; dy++) for (let dx = -2; dx <= 2; dx++) G.set(al[i] + dx, al[j] + dy, Math.max(Math.abs(dx), Math.abs(dy)) !== 1);
    }
    drawFormat(G, 0);                                                                          // reserva as áreas de formato
    if (G.v >= 7) {                                                                            // informação de versão (BCH 18,6)
      let rem = G.v;
      for (let i = 0; i < 12; i++) rem = (rem << 1) ^ ((rem >>> 11) * 0x1F25);
      const bits = (G.v << 12) | rem;
      for (let i = 0; i < 18; i++) {
        const bit = (bits >>> i) & 1, a = n - 11 + (i % 3), b = Math.floor(i / 3);
        G.set(a, b, bit); G.set(b, a, bit);
      }
    }
  }

  /* informação de formato: nível M = 00, máscara 3 bits, BCH(15,5) com 0x537, XOR 0x5412 */
  function drawFormat(G, mask) {
    const n = G.size, data = (0 << 3) | mask;
    let rem = data;
    for (let i = 0; i < 10; i++) rem = (rem << 1) ^ ((rem >>> 9) * 0x537);
    const bits = ((data << 10) | rem) ^ 0x5412, bit = i => (bits >>> i) & 1;
    for (let i = 0; i <= 5; i++) G.set(8, i, bit(i));
    G.set(8, 7, bit(6)); G.set(8, 8, bit(7)); G.set(7, 8, bit(8));
    for (let i = 9; i < 15; i++) G.set(14 - i, 8, bit(i));
    for (let i = 0; i < 8; i++) G.set(n - 1 - i, 8, bit(i));
    for (let i = 8; i < 15; i++) G.set(8, n - 15 + i, bit(i));
    G.set(8, n - 8, 1);                                                                        // o módulo escuro fixo
  }

  /* colocação em ziguezague, colunas de 2 da direita para a esquerda, a saltar a coluna 6 */
  function placeData(G, cw) {
    const n = G.size, total = cw.length * 8;
    let i = 0;
    for (let right = n - 1; right >= 1; right -= 2) {
      if (right === 6) right = 5;
      for (let vert = 0; vert < n; vert++) for (let j = 0; j < 2; j++) {
        const x = right - j, up = ((right + 1) & 2) === 0, y = up ? n - 1 - vert : vert;
        if (G.fn[y][x]) continue;
        G.mod[y][x] = i < total ? ((cw[i >>> 3] >>> (7 - (i & 7))) & 1) === 1 : false;        // bits de resto = 0
        i++;
      }
    }
  }

  const MASKS = [
    (x, y) => (x + y) % 2 === 0,
    (x, y) => y % 2 === 0,
    (x, y) => x % 3 === 0,
    (x, y) => (x + y) % 3 === 0,
    (x, y) => (Math.floor(x / 3) + Math.floor(y / 2)) % 2 === 0,
    (x, y) => (x * y) % 2 + (x * y) % 3 === 0,
    (x, y) => ((x * y) % 2 + (x * y) % 3) % 2 === 0,
    (x, y) => ((x + y) % 2 + (x * y) % 3) % 2 === 0,
  ];
  function applyMask(G, m) {
    const f = MASKS[m];
    for (let y = 0; y < G.size; y++) for (let x = 0; x < G.size; x++) if (!G.fn[y][x] && f(x, y)) G.mod[y][x] = !G.mod[y][x];
  }

  /* penalização da norma (N1 corridas, N2 blocos 2x2, N3 padrão tipo localizador, N4 equilíbrio claro/escuro) */
  function penalty(G) {
    const n = G.size, M = G.mod;
    let p = 0;
    for (let pass = 0; pass < 2; pass++) {
      for (let a = 0; a < n; a++) {
        let run = 1;
        for (let b = 1; b < n; b++) {
          const cur = pass ? M[b][a] : M[a][b], prev = pass ? M[b - 1][a] : M[a][b - 1];
          if (cur === prev) { run++; if (run === 5) p += 3; else if (run > 5) p++; } else run = 1;
        }
        for (let b = 0; b + 10 < n; b++) {
          const at = k => pass ? M[b + k][a] : M[a][b + k];
          const core = at(0) && !at(1) && at(2) && at(3) && at(4) && !at(5) && at(6);
          const core2 = at(4) && !at(5) && at(6) && at(7) && at(8) && !at(9) && at(10);
          if (core && !at(7) && !at(8) && !at(9) && !at(10)) p += 40;
          if (core2 && !at(0) && !at(1) && !at(2) && !at(3)) p += 40;
        }
      }
    }
    for (let y = 0; y < n - 1; y++) for (let x = 0; x < n - 1; x++) {
      const c = M[y][x];
      if (c === M[y][x + 1] && c === M[y + 1][x] && c === M[y + 1][x + 1]) p += 3;
    }
    let dark = 0;
    for (let y = 0; y < n; y++) for (let x = 0; x < n; x++) if (M[y][x]) dark++;
    const total = n * n;
    p += Math.floor(Math.abs(dark * 20 - total * 10) / total) * 10;
    return p;
  }

  function build(cw, v, mask) {
    const G = Grid(v);
    drawFunctionPatterns(G);
    placeData(G, cw);
    applyMask(G, mask);
    drawFormat(G, mask);
    return G;
  }

  function matrix(text, opts) {
    opts = opts || {};
    const bytes = utf8(text);
    let v = Math.max(1, Math.min(MAX_VERSION, opts.minVersion | 0 || 1)), data = null;
    for (; v <= MAX_VERSION; v++) { data = encodeData(bytes, v); if (data) break; }
    if (!data) throw new RangeError('QR: texto demasiado longo (' + bytes.length + ' bytes; máximo ' + (dataCapacity(MAX_VERSION) - 3) + ')');
    const cw = interleave(data, v);
    let best = null, bestMask = 0;
    if (opts.mask >= 0 && opts.mask <= 7) { bestMask = opts.mask | 0; best = build(cw, v, bestMask); }
    else for (let m = 0; m < 8; m++) {
      const G = build(cw, v, m), s = penalty(G);
      if (!best || s < best._score) { best = G; best._score = s; bestMask = m; }
    }
    return { version: v, size: best.size, mask: bestMask, ecc: 'M', modules: best.mod };
  }

  /* d do <path>: um retângulo por corrida horizontal de módulos escuros, já deslocado pela margem */
  function path(m, margin) {
    const q = margin == null ? 4 : margin, M = m.modules, n = m.size;
    let d = '';
    for (let y = 0; y < n; y++) {
      for (let x = 0; x < n; x++) {
        if (!M[y][x]) continue;
        let w = 1;
        while (x + w < n && M[y][x + w]) w++;
        d += 'M' + (x + q) + ' ' + (y + q) + 'h' + w + 'v1h-' + w + 'z';
        x += w - 1;
      }
    }
    return d;
  }

  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));

  function svg(text, opts) {
    opts = opts || {};
    const m = matrix(text, opts);
    const q = opts.margin == null ? 4 : Math.max(0, opts.margin | 0), dim = m.size + q * 2;
    const dark = opts.dark || '#000', light = opts.light === undefined ? '#fff' : opts.light;
    const sz = opts.size ? ' width="' + (+opts.size) + '" height="' + (+opts.size) + '"' : ' width="100%" height="100%"';
    return '<svg xmlns="http://www.w3.org/2000/svg"' + (opts.cls ? ' class="' + esc(opts.cls) + '"' : '') + sz +
      ' viewBox="0 0 ' + dim + ' ' + dim + '" shape-rendering="crispEdges" data-qr-version="' + m.version + '">' +
      (light ? '<rect width="' + dim + '" height="' + dim + '" fill="' + esc(light) + '"/>' : '') +
      '<path fill="' + esc(dark) + '" d="' + path(m, q) + '"/></svg>';
  }

  return { matrix, svg, path, utf8, MAX_VERSION, maxBytes: dataCapacity(MAX_VERSION) - 3 };
});
