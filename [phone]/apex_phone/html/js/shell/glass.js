/* ============================================================
   GLASS - a máquina do Liquid Glass do PearOS 27 (1.5.0). CSS em css/glass27.css. Só atua com body.os-ios.
     · posição: cada peça de vidro SOBRE O FUNDO (.lg-wp: dock, pastas, botões e teclas do bloqueado, notificações do bloqueado,
       barra de edição, pré-visualização das Definições) recebe --gx/--gy/--gw/--gh em px do ecrã lógico (440×956, ou a largura
       do dobrável), somando offsetLeft/offsetTop até ao #screen (NUNCA getBoundingClientRect através do zoom), mais o `translate`
       dos ícones (--x/--y, home.js) e o translateX inline das páginas. É com isso que o CSS alinha a cópia pré-desfocada do
       wallpaper e a lente ampliada. Quem constrói estas peças chama Glass.sync(el); um MutationObserver leve (só #home e #lock,
       childList) e uma vigia ao style das .pages apanham o resto, tudo coalescido num requestAnimationFrame.
     · tom: a cópia desfocada do wallpaper (--wp-blur / --wp-lock-blur, escritas pelo System.makeBlur, que chama Glass.wallpaper)
       é lida UMA vez por fundo para uma grelha 8×16 de luminâncias; as peças pequenas marcadas .lg-tone trocam de polaridade
       (.lg-light sobre zonas claras, .lg-dark sobre zonas escuras, nada no meio). As grandes só seguem o tema.
     · toque: pointerdown numa .lg escreve --px/--py (posição do dedo em relação ao centro da peça) e põe .lg-touch 450 ms (o
       brilho radial do ::after) e .lg-press enquanto premido (a peça cresce a 1.04 nas pequenas). Só transform/opacity.
     · morph: a cápsula do separador ativo da barra de separadores (.tb-ind, UM elemento por pílula) desliza e deforma como gel
       (translateX + scaleX/scaleY em duas fases) - ui.js chama Glass.tabMorph(pill, btn) em cada go(); os menus de contexto
       recebem a origem (--ox/--oy) do ui.js.
   Sem custo de frames: nada aqui corre por frame; nenhuma leitura de layout fora do rAF de sincronização.
   ============================================================ */
window.Glass = (() => {
  const $ = s => document.querySelector(s);
  const scr = () => document.getElementById('screen');
  const ios = () => document.body.classList.contains('os-ios');
  const SW = () => { const s = scr(); return (s && s.offsetWidth) || 440; };
  const SH = 956;
  const NO_TOUCH = '.sheet,.alert,.ctx,.n-x,.folder-box,.ncard,.nbanner,.toast,.hw-hud,.vol-hud,.search,.lib-tile,.dock,.banner';

  /* ---------- posição (offsets até à raiz, mais translate dos ícones e das páginas, menos o scroll dos contentores) ---------- */
  const px = v => { const n = parseFloat(v); return isFinite(n) ? n : 0; };
  const tx = el => { const t = el.style && el.style.transform; if (!t) return [0, 0]; let m = /translateX\((-?[\d.]+)px\)/.exec(t); if (m) return [+m[1], 0]; m = /translate\((-?[\d.]+)px(?:,\s*(-?[\d.]+)px)?\)/.exec(t); if (m) return [+m[1], m[2] ? +m[2] : 0]; m = /translateY\((-?[\d.]+)px\)/.exec(t); if (m) return [0, +m[1]]; return [0, 0]; };
  function measure(el, root) {
    let x = 0, y = 0, p = el;
    while (p && p !== root) {
      x += p.offsetLeft - (p.scrollLeft || 0); y += p.offsetTop - (p.scrollTop || 0);
      if (p.classList.contains('hi')) { x += px(p.style.getPropertyValue('--x')); y += px(p.style.getPropertyValue('--y')); }
      else if (p.classList.contains('pages') || p.classList.contains('pgv')) { const t = tx(p); x += t[0]; y += t[1]; }
      const op = p.offsetParent; if (!op) return null; p = op;
    }
    return p === root ? { x, y, w: el.offsetWidth, h: el.offsetHeight } : null;
  }
  function place(el, root) {
    if (!el || !el.isConnected || !el.offsetWidth) return null;
    const r = measure(el, root || scr()); if (!r) return null;
    const gx = r.x + 'px', gy = r.y + 'px', gw = r.w + 'px', gh = r.h + 'px';
    if (el._gx !== gx) { el._gx = gx; el.style.setProperty('--gx', gx); } if (el._gy !== gy) { el._gy = gy; el.style.setProperty('--gy', gy); }
    if (el._gw !== gw) { el._gw = gw; el.style.setProperty('--gw', gw); } if (el._gh !== gh) { el._gh = gh; el.style.setProperty('--gh', gh); }
    return r;
  }

  /* ---------- tom do fundo: grelha 8×16 de luminâncias por cópia desfocada (uma vez por wallpaper) ----------
     Fotos: a cópia desfocada (--wp-blur / --wp-lock-blur) lida num canvas de 8×16. Cores e gradientes não passam pelo canvas: um
     linear-gradient é lido pelos stops e projetado nas 16 linhas (pela componente vertical do ângulo); uma cor é uma luminância só.
     Além das peças de vidro (.lg-tone), as três ZONAS do ecrã viram classes no #screen: topo (barra de estado e relógio, 0 a 239 px),
     meio (ícones e notificações) e base (dock, etiquetas, atalhos): wp-top-light / wp-mid-light / wp-bottom-light para o fundo da home e
     wpl-* para o do bloqueado (podem ser fundos diferentes). O CSS (glass27.css, "Tom automático") escurece o relógio, a data, o
     cadeado, os widgets, as etiquetas e o indicador; o System.updateSbTheme liga a barra de estado. Limiar .62, o mesmo do System. */
  const COLS = 8, ROWS = 16, grids = {}, want = {}, ZONES = { top: [0, 4], mid: [4, 12], bottom: [12, 16] }, LIGHT = .62, ZPRE = { '--wp-blur': 'wp-', '--wp-lock-blur': 'wpl-' };
  const lum = (r, g, b) => (.2126 * r + .7152 * g + .0722 * b) / 255;
  const hexRgb = h => { let s = h.replace('#', ''); if (s.length === 3 || s.length === 4) s = s.slice(0, 3).split('').map(c => c + c).join(''); const n = parseInt(s.slice(0, 6), 16); return isNaN(n) ? null : [(n >> 16) & 255, (n >> 8) & 255, n & 255]; };
  const cssRgb = c => { c = String(c).trim(); if (c[0] === '#') return hexRgb(c); const m = /^rgba?\(([^)]+)\)/i.exec(c); if (!m) return null; const p = m[1].split(',').map(parseFloat); return p.length >= 3 && p.slice(0, 3).every(isFinite) ? p.slice(0, 3) : null; };
  const splitTop = s => { const out = []; let d = 0, cur = ''; for (const ch of s) { if (ch === '(') d++; else if (ch === ')') d--; if (ch === ',' && d === 0) { out.push(cur); cur = ''; } else cur += ch; } if (cur.trim()) out.push(cur); return out.map(x => x.trim()); };
  /* linear-gradient → luminância por linha do ecrã (16). Ângulo CSS: 0 = para cima, 180 = para baixo; a média de cada linha só
     depende da componente vertical. Sem ângulo = 180. Stops sem percentagem repartem-se. Radial ou sem stops → null. */
  function gradientRows(v) {
    const i = v.indexOf('linear-gradient('); if (i < 0) return null;
    let d = 0, j = i + 'linear-gradient'.length; for (; j < v.length; j++) { if (v[j] === '(') d++; else if (v[j] === ')') { d--; if (!d) break; } }
    const parts = splitTop(v.slice(i + 'linear-gradient('.length, j)); if (!parts.length) return null;
    let ang = 180; const a0 = parts[0];
    if (/deg$/.test(a0)) { ang = parseFloat(a0); parts.shift(); } else if (/^to\s/.test(a0)) { ang = /bottom/.test(a0) ? 180 : /top/.test(a0) ? 0 : 90; parts.shift(); }
    const stops = parts.map(p => { const m = /^(#[0-9a-f]{3,8}|rgba?\([^)]*\))\s*([\d.]+%)?/i.exec(p); if (!m) return null; const c = cssRgb(m[1]); return c ? { l: lum(c[0], c[1], c[2]), t: m[2] ? parseFloat(m[2]) / 100 : null } : null; }).filter(Boolean);
    if (stops.length < 2) return stops.length === 1 ? { flat: stops[0].l } : null;
    if (stops[0].t == null) stops[0].t = 0; if (stops[stops.length - 1].t == null) stops[stops.length - 1].t = 1;
    for (let k = 1; k < stops.length; k++) if (stops[k].t == null) { let e = k; while (stops[e].t == null) e++; const a = stops[k - 1].t, b = stops[e].t; for (let q = k; q < e; q++) stops[q].t = a + (b - a) * (q - k + 1) / (e - k + 1); }
    const at = t => { if (t <= stops[0].t) return stops[0].l; for (let k = 1; k < stops.length; k++) if (t <= stops[k].t) { const a = stops[k - 1], b = stops[k]; const f = b.t === a.t ? 1 : (t - a.t) / (b.t - a.t); return a.l + (b.l - a.l) * f; } return stops[stops.length - 1].l; };
    const rad = ang * Math.PI / 180, dy = -Math.cos(rad), L = SW() * Math.abs(Math.sin(rad)) + SH * Math.abs(Math.cos(rad)) || 1;
    const rows = new Float32Array(ROWS); for (let r = 0; r < ROWS; r++) { const y = (r + .5) / ROWS * SH; rows[r] = at(.5 + (y - SH / 2) * dy / L); }
    return { rows };
  }
  function wallpaper(varName) {
    if (!varName) return; const s = scr(); if (!s) return;
    const v = s.style.getPropertyValue(varName).trim(); if (!v) return;
    want[varName] = v;
    const m = /url\("([^"]+)"\)/.exec(v) || /url\('([^']+)'\)/.exec(v) || /url\(([^)]+)\)/.exec(v);
    if (!m) {
      let g = gradientRows(v);
      if (!g) { const cs = v.match(/#[0-9a-f]{3,8}\b|rgba?\([^)]*\)/gi) || []; let sum = 0, n = 0; cs.forEach(c => { const r = cssRgb(c); if (r) { sum += lum(r[0], r[1], r[2]); n++; } });
        g = { flat: n ? sum / n : (s.dataset[varName === '--wp-lock-blur' ? 'wpLockTone' : 'wpTone'] === 'light' ? .8 : .2) }; }
      grids[varName] = g; retone(); zones(varName); return; }
    /* a cópia do System é um data: URL (sem CORS). No harness/browser por file:// fica a imagem nítida: carrega-se SEM crossOrigin
       (um file:// com crossOrigin era recusado); se o canvas ficar "tainted" o getImageData lança e o tom fica por medir */
    const img = new Image(); if (/^https?:/i.test(m[1])) img.crossOrigin = 'anonymous';
    img.onload = () => { if (want[varName] !== v) return; try {
      const c = document.createElement('canvas'); c.width = COLS; c.height = ROWS; const x = c.getContext('2d'); x.drawImage(img, 0, 0, COLS, ROWS);
      const d = x.getImageData(0, 0, COLS, ROWS).data, out = new Float32Array(COLS * ROWS);
      for (let i = 0; i < COLS * ROWS; i++) out[i] = lum(d[i * 4], d[i * 4 + 1], d[i * 4 + 2]);
      grids[varName] = { lum: out }; retone(); zones(varName);
    } catch (e) { grids[varName] = null; zones(varName); } };
    img.onerror = () => { if (want[varName] === v) { grids[varName] = null; zones(varName); } };
    img.src = m[1];
  }
  /* luminância média de uma zona (0..1) ou null sem medida */
  function zoneLum(g, z) {
    if (!g) return null; if (g.flat != null) return g.flat; const [r0, r1] = ZONES[z] || ZONES.mid; let s = 0, n = 0;
    for (let r = r0; r < r1; r++) { if (g.rows) { s += g.rows[r]; n++; } else for (let c = 0; c < COLS; c++) { s += g.lum[r * COLS + c]; n++; } }
    return n ? s / n : null;
  }
  function zones(varName) {
    const s = scr(), p = ZPRE[varName]; if (!s || !p) return; const g = grids[varName]; let changed = false;
    Object.keys(ZONES).forEach(z => { const l = zoneLum(g, z), on = l != null && l > LIGHT, k = p + z + '-light'; if (s.classList.contains(k) !== on) { s.classList.toggle(k, on); changed = true; } });
    if (changed && window.System && System.updateSbTheme) { try { System.updateSbTheme(); } catch (e) {} }
  }
  function toneAt(g, r) {
    if (!g) return null; if (g.flat != null) return g.flat;
    const W = SW(), cw = W / COLS, ch = SH / ROWS;
    const c0 = Math.max(0, Math.min(COLS - 1, Math.floor(r.x / cw))), c1 = Math.max(0, Math.min(COLS - 1, Math.floor((r.x + r.w - 1) / cw)));
    const r0 = Math.max(0, Math.min(ROWS - 1, Math.floor(r.y / ch))), r1 = Math.max(0, Math.min(ROWS - 1, Math.floor((r.y + r.h - 1) / ch)));
    let s = 0, n = 0; for (let j = r0; j <= r1; j++) { if (g.rows) { s += g.rows[j]; n++; } else for (let i = c0; i <= c1; i++) { s += g.lum[j * COLS + i]; n++; } }
    return n ? s / n : null;
  }
  function tone(el, r) {
    const src = el.dataset.lgSrc || (el.classList.contains('on-lock') ? '--wp-lock-blur' : '--wp-blur');
    const l = toneAt(grids[src], r); if (l == null) return;
    const light = l > .62, dark = l < .34;
    if (el.classList.contains('lg-light') !== light) el.classList.toggle('lg-light', light);
    if (el.classList.contains('lg-dark') !== dark) el.classList.toggle('lg-dark', dark);
  }
  function retone() { const s = scr(); if (!s || !ios()) return; s.querySelectorAll('.lg-wp.lg-tone').forEach(el => { const r = place(el); if (r) tone(el, r); }); }

  /* ---------- sincronização ---------- */
  function sync(el, opts) {
    if (!ios() || !el) return;
    if (el.classList && el.classList.contains('lg-wp')) { const r = place(el, opts && opts.root); if (r && el.classList.contains('lg-tone')) tone(el, r); }
    if (el.querySelectorAll) el.querySelectorAll('.lg-wp').forEach(n => { const r = place(n, opts && opts.root); if (r && n.classList.contains('lg-tone')) tone(n, r); });
  }
  let rafId = 0; const dirty = new Set();
  function soon(el) { if (!ios()) return; dirty.add(el || scr()); if (rafId) return; rafId = requestAnimationFrame(() => { rafId = 0; const list = [...dirty]; dirty.clear(); list.forEach(n => { if (n && n.isConnected) sync(n); }); }); }
  let pagesT = 0;
  function watch() {
    const s = scr(); if (!s || watch.done) return; watch.done = true;
    if (!window.MutationObserver) return;
    /* #home e #lock: só childList (a home refaz-se ao editar, o bloqueado ao bloquear/notificar) */
    ['home', 'lock'].forEach(id => { const n = document.getElementById(id); if (!n) return; new MutationObserver(() => soon(n)).observe(n, { childList: true, subtree: true }); });
    /* as páginas da home deslizam por transform inline: as pastas noutra página mudam de sítio no ecrã (coalescido a 120 ms) */
    const home = document.getElementById('home');
    /* e a classe do PRÓPRIO #home (.edit mostra a barra Editar/Concluído, que estava display:none quando o fundo foi medido) */
    if (home) new MutationObserver(ms => { for (const m of ms) { if (m.target === home) { soon(home); return; } if (m.target.classList && m.target.classList.contains('pages')) { clearTimeout(pagesT); pagesT = setTimeout(() => soon(home), 120); return; } } }).observe(home, { attributes: true, attributeFilter: ['style', 'class'], subtree: true });
  }

  /* ---------- toque: brilho a partir do dedo e crescer enquanto premido ---------- */
  function touch(e) {
    if (!ios()) return; const el = e.target && e.target.closest && e.target.closest('.lg'); if (!el) return;
    if (e.button && e.pointerType === 'mouse') return;
    const lk = el.closest('#lock'); if (lk && lk.classList.contains('lke-on') && el.classList.contains('ls-btn')) return;   /* editor do bloqueado: o "menos" sai pelo canto e o overflow:hidden do brilho cortava-o */
    const w = el.offsetWidth, h = el.offsetHeight; if (!w || !h) return;
    let vr = null, z = 1; try { if (window.UI && UI.vrect) { vr = UI.vrect(el); z = UI.zoom(el) || 1; } } catch (x) {}
    if (!vr) { vr = el.getBoundingClientRect(); z = vr.width / w || 1; }
    const x = (e.clientX - vr.left) / z, y = (e.clientY - vr.top) / z;
    el.style.setProperty('--px', (x - w / 2).toFixed(1) + 'px'); el.style.setProperty('--py', (y - h / 2).toFixed(1) + 'px');
    if (!el.matches(NO_TOUCH)) { el.classList.remove('lg-touch'); void el.offsetWidth; el.classList.add('lg-touch'); clearTimeout(el._lgT); el._lgT = setTimeout(() => el.classList.remove('lg-touch'), 460); }
    el.classList.add('lg-press');
    const up = () => { el.classList.remove('lg-press'); window.removeEventListener('pointerup', up, true); window.removeEventListener('pointercancel', up, true); };
    window.addEventListener('pointerup', up, true); window.addEventListener('pointercancel', up, true);
  }

  /* ---------- morph da barra de separadores: a cápsula desliza e deforma como gel entre separadores ---------- */
  const IND_W = 66;
  function tabMorph(pill, btn, immediate, tries) {
    if (!ios() || !pill) return;
    let ind = pill.querySelector(':scope > .tb-ind');
    if (!ind) { ind = document.createElement('i'); ind.className = 'tb-ind'; pill.insertBefore(ind, pill.firstChild); pill.classList.add('has-ind'); }
    if (!btn) { ind.classList.remove('on'); return; }
    if (!pill.isConnected || !btn.offsetWidth) { if ((tries || 0) < 40) requestAnimationFrame(() => tabMorph(pill, btn, true, (tries || 0) + 1)); return; }   /* ainda sem layout (janela a abrir): tenta nos frames seguintes */
    const x = btn.offsetLeft, w = btn.offsetWidth, set = (tx, sx, sy) => { ind.style.setProperty('--tx', tx.toFixed(1) + 'px'); ind.style.setProperty('--sx', (sx / IND_W).toFixed(4)); ind.style.setProperty('--sy', String(sy)); };
    clearTimeout(ind._gelT);
    const reduced = document.body.dataset.motion === 'reduced';
    if (immediate || ind._x == null || !ind.classList.contains('on') || reduced) { ind.classList.remove('gel'); ind.classList.remove('on'); set(x, w, 1); void ind.offsetWidth; ind.classList.add('on'); }
    else {
      /* fase 1 (140 ms): estica da posição antiga até à nova, ligeiramente mais baixa; fase 2: encolhe para o separador novo com mola */
      const from = ind._x, fw = ind._w || w, lo = Math.min(from, x), hi = Math.max(from + fw, x + w);
      ind.classList.add('gel'); set(lo, hi - lo, .9);
      ind._gelT = setTimeout(() => { ind.classList.remove('gel'); set(x, w, 1); }, 140);
    }
    ind._x = x; ind._w = w;
  }

  /* ---------- arranque: observadores e toque (o #screen existe desde o index.html) ---------- */
  function init() {
    const s = scr(); if (!s) return; watch();
    s.addEventListener('pointerdown', touch, true);
    /* o tom de fundos já medidos antes de o Glass existir */
    ['--wp-blur', '--wp-lock-blur'].forEach(v => { if (s.style.getPropertyValue(v)) wallpaper(v); });
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();

  return { sync, soon, place, measure, wallpaper, retone, tabMorph, zoneLum: (v, z) => zoneLum(grids[v], z), get grids() { return grids; } };
})();
