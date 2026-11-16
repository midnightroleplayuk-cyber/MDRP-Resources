/* ============================================================
   PERSONALIZAR O ECRÃ PRINCIPAL (PearOS 27 · 1.4.0) - window.HomeCustom
   A folha "Personalizar" do iOS 26/27: vidro por cima da home, que continua à vista (e a deslizar) e muda AO VIVO.
     · cabeçalho: sol (troca o tom Claro ⇄ Escuro dos ícones), título, ícones pequenos/grandes;
     · quatro estilos com o ícone do Meteorologia desenhado em cada um (Icons.styledUrl): Predefinido, Escuro, Transparente, Colorido;
     · Colorido: matiz (arco-íris) e saturação (cor → branco, como na fotografia), três cores tiradas do fundo (dominante, mais clara,
       complementar) e o conta-gotas (tocar no fundo da home escolhe a cor desse ponto);
     · Transparente e Colorido: "Claro | Escuro | Auto" (o tom).
   Arrastar um cursor NUNCA grava a cada frame: Icons.setStyle({…}, { live:true }) no máximo uma vez por frame (o icons.js só refaz as
   regras dos ícones à vista) e o System.setState vai ao LARGAR. Tocar num estilo/tom/tamanho grava logo (System.apply → Icons.setStyle).
   Android (Nova UI): nada disto existe - open() sai logo (e o System.apply deixa os ícones Nova UI como estão).
   ============================================================ */
window.HomeCustom = (() => {
  const isA = () => !!(window.System && System.os === 'android');
  const S = () => (window.System && System.state) || {};
  const T = s => (window.L && L.t ? L.t(s) : s), esc = s => UI.esc(s);
  const clamp = (v, a, b) => { a = a == null ? 0 : a; b = b == null ? 1 : b; return v < a ? a : v > b ? b : v; };
  const num = (v, d) => { const n = typeof v === 'number' ? v : parseFloat(v); return isFinite(n) ? n : d; };
  const MODES = [['default', 'Predefinido'], ['dark', 'Escuro'], ['clear', 'Transparente'], ['tinted', 'Colorido']];
  const TONES = [['light', 'Claro'], ['dark', 'Escuro'], ['auto', 'Auto']];
  /* o estado guardado (System.state, chaves novas da 1.4.0), já validado */
  const cur = () => { const s = S(); return { mode: MODES.some(m => m[0] === s.iconStyle) ? s.iconStyle : 'default', hue: ((num(s.iconHue, 210) % 360) + 360) % 360,
    sat: clamp(num(s.iconSat, .7)), tone: ['light', 'dark', 'auto'].includes(s.iconTone) ? s.iconTone : 'auto', size: s.iconSize === 'large' ? 'large' : 'small' }; };
  /* "Auto" segue o tema do telemóvel (o mesmo state.dark que o System.apply calcula, com a hora do jogo) */
  const resTone = t => t === 'auto' ? (S().dark ? 'dark' : 'light') : t;

  /* ---- cores (em JS: o CEF não tem color-mix nem contas dentro de rgba()) ---- */
  const hslRgb = (h, s, l) => { h = (((h % 360) + 360) % 360) / 360; s = clamp(s); l = clamp(l); if (!s) return [l * 255, l * 255, l * 255];
    const q = l < .5 ? l * (1 + s) : l + s - l * s, p = 2 * l - q, f = t => { t = t < 0 ? t + 1 : t > 1 ? t - 1 : t; return t < 1 / 6 ? p + (q - p) * 6 * t : t < .5 ? q : t < 2 / 3 ? p + (q - p) * (2 / 3 - t) * 6 : p; };
    return [f(h + 1 / 3) * 255, f(h) * 255, f(h - 1 / 3) * 255]; };
  const rgbHex = c => '#' + c.slice(0, 3).map(v => Math.round(clamp(v, 0, 255)).toString(16).padStart(2, '0')).join('').toUpperCase();
  const hslHex = (h, s, l) => rgbHex(hslRgb(h, s, l));
  const hexRgb = h => { const n = parseInt(String(h).replace('#', ''), 16); return isNaN(n) ? [128, 128, 128] : [n >> 16, (n >> 8) & 255, n & 255]; };
  const mixHex = (a, b, t) => { const x = hexRgb(a), y = hexRgb(b); return rgbHex(x.map((v, i) => v + (y[i] - v) * t)); };
  const rgbHsl = (r, g, b) => { r /= 255; g /= 255; b /= 255; const mx = Math.max(r, g, b), mn = Math.min(r, g, b), l = (mx + mn) / 2; if (mx === mn) return [0, 0, l];
    const d = mx - mn, s = l > .5 ? d / (2 - mx - mn) : d / (mx + mn); let h = mx === r ? (g - b) / d + (g < b ? 6 : 0) : mx === g ? (b - r) / d + 2 : (r - g) / d + 4; return [h * 60, s, l]; };

  /* ---- glifos da folha (como na fotografia: sol com meia lua cheia, dois quadrados, telemóvel, flor) ---- */
  const SUN = '<svg viewBox="0 0 24 24" width="27" height="27" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><circle cx="12" cy="12" r="4.4"/><path d="M12 7.6a4.4 4.4 0 0 0 0 8.8z" fill="currentColor" stroke="none"/><path d="M12 1.9v2.2M12 19.9v2.2M4.9 4.9l1.55 1.55M17.55 17.55l1.55 1.55M1.9 12h2.2M19.9 12h2.2M4.9 19.1l1.55-1.55M17.55 6.45l1.55-1.55"/></svg>';
  const SIZE = big => `<svg viewBox="0 0 30 24" width="33" height="26" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="2" y="13" width="8" height="8" rx="2.2"${big ? '' : ' fill="currentColor"'}/><rect x="12.5" y="5" width="16" height="16" rx="4.4"${big ? ' fill="currentColor"' : ''}/></svg>`;
  const PH_O = '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"><rect x="7" y="2.8" width="10" height="18.4" rx="2.6"/><path d="M10.6 18.1h2.8"/></svg>';
  const PH_F = '<svg viewBox="0 0 24 24" width="22" height="22"><rect x="7" y="2.8" width="10" height="18.4" rx="2.6" fill="currentColor"/><rect x="10.6" y="5.3" width="2.8" height="1.7" rx=".85" fill="rgba(0,0,0,.3)"/></svg>';
  const FLOWER = '<svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.35">' + [0, 45, 90, 135, 180, 225, 270, 315].map(a => `<ellipse cx="12" cy="7.1" rx="2.5" ry="4.3" transform="rotate(${a} 12 12)"/>`).join('') + '<circle cx="12" cy="12" r="1.9"/></svg>';

  let sh = null, root = null, live = null, raf = 0, rafT = 0, pick = null, sugg = null, sampler = null;

  /* ---------- gravar ----------
     Uma escolha feita (estilo, tom, tamanho, cor sugerida, conta-gotas, largar um cursor) vai SÓ pelo System.setState: o System.apply
     escreve body[data-icons]/[data-icontone] e #home.hm-large e chama o Icons.setStyle quando a assinatura muda. Aqui o Icons.setStyle
     só é chamado ao vivo, a arrastar um cursor (frame() abaixo) - chamá-lo também depois do setState refazia os ícones duas vezes. */
  function commit(patch) { if (!window.System) return; System.setState(patch); paint(); }

  /* ---------- uma vez por frame (rAF) com rede de setTimeout: no headless e com a página sem foco o rAF pode não correr ---------- */
  function frame() {
    if (raf || rafT) return;
    const run = () => { if (raf) { try { cancelAnimationFrame(raf); } catch (e) {} } clearTimeout(rafT); raf = 0; rafT = 0; if (!live) return;
      const c = Object.assign(cur(), live); Icons.setStyle({ mode: c.mode, hue: c.hue, sat: c.sat, tone: resTone(c.tone) }, { live: true }); };
    try { raf = requestAnimationFrame(run); } catch (e) {} rafT = setTimeout(run, 50);
  }

  /* ---------- fundo da home amostrado num canvas (cores sugeridas + conta-gotas) ----------
     Uma só leitura serve as duas coisas. O LockGallery._x.avgColor faria só a média (e passa pelo loadImg duplicado da galeria);
     aqui é preciso o PIXEL de cada ponto. Fontes: url() (fotos, ficheiros, SVG data URI) → imagem em "cover"; gradientes/cores (as
     cores e gradientes da galeria, as fotos de demonstração) → desenhados no canvas. Imagem de outra origem sem CORS suja o canvas:
     tenta-se a cópia desfocada (data URL, mesma origem) e, no fim, uma cor neutra. */
  const wpValue = () => { const scr = document.getElementById('screen'), v = scr ? String(scr.style.getPropertyValue('--wp') || '').trim() : '';
    if (v && v !== 'none') return v; const el = document.querySelector('#screen .wallpaper:not(.wallpaper-lock)'); return el ? (el.style.backgroundImage || el.style.background || getComputedStyle(el).backgroundImage || '') : ''; };
  const blurValue = () => { const scr = document.getElementById('screen'); return scr ? String(scr.style.getPropertyValue('--wp-blur') || '').trim() : ''; };
  /* url de dentro de um url(…): o data URI dos SVG tem parênteses (não se corta no primeiro ")", a mesma leitura do System.makeBlur) */
  const urlOf = v => { const m = /url\("([^"]+)"\)/.exec(v || '') || /url\('([^']+)'\)/.exec(v || '') || /url\(([^)'"]+)\)/.exec(v || ''); return m ? m[1] : null; };
  function cover(x, img, W, H) { let iw = img.naturalWidth || img.width, ih = img.naturalHeight || img.height; if (!iw || !ih || (iw === 300 && ih === 150)) { iw = 440; ih = 956; }
    const r = Math.max(W / iw, H / ih), w = iw * r, h = ih * r; x.drawImage(img, (W - w) / 2, (H - h) / 2, w, h); }
  const splitTop = s => { const out = []; let d = 0, st = 0; for (let i = 0; i < s.length; i++) { const ch = s[i]; if (ch === '(') d++; else if (ch === ')') d--; else if (ch === ',' && !d) { out.push(s.slice(st, i)); st = i + 1; } } out.push(s.slice(st)); return out.map(p => p.trim()).filter(Boolean); };
  const ANG = { 'to top': 0, 'to right': 90, 'to bottom': 180, 'to left': 270, 'to top right': 45, 'to right top': 45, 'to bottom right': 135, 'to right bottom': 135, 'to bottom left': 225, 'to left bottom': 225, 'to top left': 315, 'to left top': 315 };
  function drawCss(x, v, W, H) {
    x.fillStyle = '#3A3A3C'; x.fillRect(0, 0, W, H);
    const s = String(v || ''), i = s.search(/(?:repeating-)?(linear|radial)-gradient\(/i);
    if (i < 0) { const c = /(#[0-9a-f]{3,8}\b|rgba?\([^)]*\)|hsla?\([^)]*\))/i.exec(s); if (c) { try { x.fillStyle = c[1]; x.fillRect(0, 0, W, H); } catch (e) {} } return; }
    const j = s.indexOf('(', i) + 1; let d = 1, k = j; for (; k < s.length && d; k++) { if (s[k] === '(') d++; else if (s[k] === ')') d--; }
    const radial = /^(?:repeating-)?radial/i.test(s.slice(i)), parts = splitTop(s.slice(j, k - 1));
    let ang = 180; const a0 = (parts[0] || '').toLowerCase();
    if (/^-?[\d.]+(deg|turn|rad|grad)$/.test(a0)) { const n = parseFloat(a0); ang = /turn/.test(a0) ? n * 360 : /grad/.test(a0) ? n * .9 : /rad/.test(a0) ? n * 180 / Math.PI : n; parts.shift(); }
    else if (ANG[a0.replace(/\s+/g, ' ')] != null) { ang = ANG[a0.replace(/\s+/g, ' ')]; parts.shift(); }
    else if (radial && !/^(#|rgb|hsl)/.test(a0) && /\b(circle|ellipse|at|closest|farthest)\b/.test(a0)) parts.shift();
    const stops = parts.map(p => { const m = /^(#[0-9a-f]{3,8}|[a-z]+\([^)]*\)|[a-z]+)\s*(-?[\d.]+%)?/i.exec(p); return m ? { c: m[1], p: m[2] ? parseFloat(m[2]) / 100 : null } : null; }).filter(Boolean);
    if (!stops.length) return;
    stops.forEach((st, n) => { if (st.p == null) st.p = stops.length > 1 ? n / (stops.length - 1) : 0; });
    let gr; if (radial) gr = x.createRadialGradient(W / 2, H / 2, 0, W / 2, H / 2, Math.max(W, H) * .6);
    else { const a = ang * Math.PI / 180, dx = Math.sin(a), dy = -Math.cos(a), len = Math.abs(W * dx) + Math.abs(H * dy); gr = x.createLinearGradient(W / 2 - dx * len / 2, H / 2 - dy * len / 2, W / 2 + dx * len / 2, H / 2 + dy * len / 2); }
    stops.forEach(st => { try { gr.addColorStop(clamp(st.p), st.c); } catch (e) {} });
    x.fillStyle = gr; x.fillRect(0, 0, W, H);
  }
  /* cor dominante: média pesada pela saturação (a mesma ideia do avgColor da galeria) */
  function dominant(p) { let r = 0, g = 0, b = 0, n = 0; for (let i = 0; i < p.length; i += 4) { const mx = Math.max(p[i], p[i + 1], p[i + 2]), mn = Math.min(p[i], p[i + 1], p[i + 2]), w = (mx - mn) / 255 + .04; r += p[i] * w; g += p[i + 1] * w; b += p[i + 2] * w; n += w; }
    return n ? rgbHsl(r / n, g / n, b / n) : [210, .2, .4]; }
  function getSampler(cb) {
    const v = wpValue(), SW = (window.System && System.SW) || 440;
    if (sampler && sampler.v === v && sampler.sw === SW) { cb(sampler); return; }
    const H = 239, W = Math.max(40, Math.round(H * SW / 956)), cv = document.createElement('canvas'); cv.width = W; cv.height = H; const x = cv.getContext('2d');
    const fin = () => { let data = null; try { data = x.getImageData(0, 0, W, H).data; } catch (e) { data = null; }
      if (!data) { const bu = urlOf(blurValue()); if (bu && /^data:image\//.test(bu) && !fin.b) { fin.b = true; load(bu); return; } drawCss(x, '#3A3A3C', W, H); try { data = x.getImageData(0, 0, W, H).data; } catch (e) { data = new Uint8ClampedArray(W * H * 4).fill(90); } }
      sampler = { v, sw: SW, W, H, data, dom: dominant(data) }; cb(sampler); };
    const load = u => { const img = new Image(); if (!/^data:/i.test(u)) img.crossOrigin = 'anonymous';
      img.onload = () => { try { x.clearRect(0, 0, W, H); cover(x, img, W, H); } catch (e) {} fin(); }; img.onerror = () => { drawCss(x, v, W, H); fin(); };
      try { img.src = /^[a-z][a-z0-9+.-]*:/i.test(u) ? u : new URL(u, document.baseURI).href; } catch (e) { img.src = u; } };
    const u = urlOf(v); if (u) load(u); else { drawCss(x, v, W, H); fin(); }
  }
  function sampleAt(sm, px, py) { const SW = sm.sw || 440, cx = clamp(Math.floor(px / SW * sm.W), 0, sm.W - 1), cy = clamp(Math.floor(py / 956 * sm.H), 0, sm.H - 1);
    /* média de 3×3 à volta do ponto: um pixel sozinho de uma foto é ruído */
    let r = 0, g = 0, b = 0, n = 0; for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) { const X = clamp(cx + dx, 0, sm.W - 1), Y = clamp(cy + dy, 0, sm.H - 1), i = (Y * sm.W + X) * 4; r += sm.data[i]; g += sm.data[i + 1]; b += sm.data[i + 2]; n++; }
    r /= n; g /= n; b /= n; const [h, s, l] = rgbHsl(r, g, b); return { h, s, l, hex: rgbHex([r, g, b]) }; }
  /* três sugestões tiradas do fundo: a cor dominante, a mesma mais clara (menos saturada no ícone) e a complementar */
  function suggest() {
    getSampler(sm => { if (!root) return; const [h, s, l] = sm.dom, s1 = clamp(s, .22, 1), l1 = clamp(l, .32, .6);
      const dom = { h, s: s1, hex: hslHex(h, s1, l1) };
      sugg = [dom, { h, s: clamp(s1 * .55, .12, 1), hex: mixHex(dom.hex, '#FFFFFF', .35) }, { h: (h + 180) % 360, s: s1, hex: hslHex((h + 180) % 360, s1, l1) }];
      paintSugg(view()); });
  }

  /* ---------- conta-gotas: camada por cima da home (por baixo da folha); o ponto tocado vira a cor dos ícones ---------- */
  function startPick() {
    if (pick || !root) return;
    getSampler(() => {});   /* prepara já a leitura do fundo */
    const lay = UI.el('<div class="hc-pick"><i class="hc-loupe"></i></div>'), loupe = lay.querySelector('.hc-loupe');
    UI.screen().appendChild(lay); root.classList.add('picking');
    let g0 = null;
    const at = e => { const r = g0 || UI.vrect(UI.screen()), k = r.width / ((window.System && System.SW) || 440) || 1; return { x: (e.clientX - r.left) / k, y: (e.clientY - r.top) / k }; };
    const show = p => getSampler(sm => { if (!pick) return; const c = sampleAt(sm, p.x, p.y); loupe.style.background = c.hex; loupe.style.transform = `translate(${p.x.toFixed(1)}px,${(p.y - 62).toFixed(1)}px)`; lay.classList.add('on'); });
    lay.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; e.preventDefault(); e.stopPropagation(); g0 = UI.vrect(UI.screen()); try { lay.setPointerCapture(e.pointerId); } catch (x) {} show(at(e)); });
    lay.addEventListener('pointermove', e => { if (g0) show(at(e)); });
    lay.addEventListener('pointerup', e => { if (!g0) return; const p = at(e); g0 = null;
      getSampler(sm => { const c = sampleAt(sm, p.x, p.y); stopPick(); commit({ iconStyle: 'tinted', iconHue: Math.round(c.h), iconSat: Math.round(clamp(c.s) * 100) / 100 }); }); });
    lay.addEventListener('pointercancel', () => { g0 = null; lay.classList.remove('on'); });
    pick = { lay, untrack: UI.track(stopPick) };
    paintSugg(view());
  }
  function stopPick() { if (!pick) return; const p = pick; pick = null; try { if (p.untrack) p.untrack(); } catch (e) {} p.lay.remove(); if (root) { root.classList.remove('picking'); paintSugg(view()); } }

  /* ---------- a folha ---------- */
  const view = () => live ? Object.assign(cur(), live) : cur();
  function build() {
    const r = UI.el(`<div class="hc-root"><div class="hc-styles">${MODES.map(([v, l]) => `<div class="hc-st" data-v="${v}" role="button"><div class="hc-pv hc-pv-${v}"></div><span>${esc(T(l))}</span></div>`).join('')}</div>`
      + `<div class="hc-tint"><div class="hc-sl hc-hue" data-k="hue" role="slider" aria-label="${esc(T('Matiz'))}"><div class="hc-kr"><i class="hc-kn"></i></div></div><div class="hc-sl hc-sat" data-k="sat" role="slider" aria-label="${esc(T('Saturação'))}"><div class="hc-kr"><i class="hc-kn"></i></div></div></div>`
      + `<div class="hc-sugg">${[PH_O, PH_F, FLOWER].map((s, i) => `<div class="hc-sg" data-i="${i}" role="button">${s}</div>`).join('')}<div class="hc-sg hc-eye" role="button" aria-label="${esc(T('Toca no fundo para escolher a cor'))}">${UI.g('eyedropper', 22)}</div></div>`
      + `<div class="hc-hint">${esc(T('Toca no fundo para escolher a cor'))}</div>`
      + `<div class="hc-tone lg27-group">${TONES.map(([v, l]) => `<div data-t="${v}" role="button">${esc(T(l))}</div>`).join('')}</div></div>`);
    r.querySelectorAll('.hc-st').forEach(b => { b.onclick = () => { if (cur().mode !== b.dataset.v) commit({ iconStyle: b.dataset.v }); }; });
    r.querySelectorAll('.hc-tone > div').forEach(b => { b.onclick = () => { if (cur().tone !== b.dataset.t) commit({ iconTone: b.dataset.t }); }; });
    r.querySelectorAll('.hc-sg[data-i]').forEach(b => { b.onclick = () => { const s = sugg && sugg[+b.dataset.i]; if (s) commit({ iconHue: Math.round(s.h), iconSat: Math.round(s.s * 100) / 100 }); }; });
    r.querySelector('.hc-eye').onclick = () => { if (pick) stopPick(); else startPick(); };
    r.querySelectorAll('.hc-sl').forEach(bindSlider);
    return r;
  }
  /* cursor de cápsula: o ponto anda por TRANSFORM (o carril invisível .hc-kr desliza var(--v) × a sua largura); retângulo lido UMA vez
     por gesto em px reais (UI.vrect: o CEF 103 divide pelo zoom, o Edge não); grava ao largar */
  function bindSlider(el) {
    const k = el.dataset.k; let g0 = null;
    const val = e => clamp((e.clientX - g0.l - g0.kr) / Math.max(1, g0.w - 2 * g0.kr));
    const set = v => { live = live || {}; if (k === 'hue') live.hue = v * 360; else live.sat = 1 - v; const c = view(); paintSliders(c); paintPreviews(c); paintSugg(c); frame(); };
    el.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; e.preventDefault(); e.stopPropagation();
      const r = UI.vrect ? UI.vrect(el) : el.getBoundingClientRect(); g0 = { l: r.left, w: r.width, kr: 16 * (r.width / Math.max(1, el.offsetWidth)) };
      try { el.setPointerCapture(e.pointerId); } catch (x) {} el.classList.add('drag'); set(val(e)); });
    el.addEventListener('pointermove', e => { if (g0) set(val(e)); });
    const end = () => { if (!g0) return; g0 = null; el.classList.remove('drag'); const l = live; live = null;
      if (raf) { try { cancelAnimationFrame(raf); } catch (e) {} } clearTimeout(rafT); raf = 0; rafT = 0;
      if (l) { const c = cur(); commit({ iconHue: Math.round(l.hue != null ? l.hue : c.hue), iconSat: Math.round((l.sat != null ? l.sat : c.sat) * 100) / 100 }); } };
    el.addEventListener('pointerup', end); el.addEventListener('pointercancel', end); el.addEventListener('lostpointercapture', end);
  }
  function paintPreviews(c) {
    if (!root || !window.Icons || !Icons.styledUrl) return; const rt = resTone(c.tone);
    MODES.forEach(([v]) => { const pv = root.querySelector('.hc-pv-' + v); if (!pv) return;
      const key = v === 'tinted' ? `t${Math.round(c.hue)},${c.sat.toFixed(2)},${rt}` : v; if (pv._k === key) return; pv._k = key;
      try { pv.style.backgroundImage = Icons.styledUrl('weather', { mode: v, hue: c.hue, sat: c.sat, tone: rt }); } catch (e) {} });   /* CSSOM: um data URL nunca entra numa string de HTML */
  }
  function paintSliders(c) {
    if (!root) return; const hue = root.querySelector('.hc-hue'), sat = root.querySelector('.hc-sat'); if (!hue || !sat) return;
    hue.style.setProperty('--v', (c.hue / 360).toFixed(4)); hue.querySelector('.hc-kn').style.backgroundColor = hslHex(c.hue, .9, .56);
    const pure = hslHex(c.hue, .85, .6);
    sat.style.setProperty('--v', (1 - c.sat).toFixed(4)); sat.style.backgroundImage = `linear-gradient(90deg,${pure},#FFFFFF)`;
    sat.querySelector('.hc-kn').style.backgroundColor = mixHex(pure, '#FFFFFF', 1 - c.sat);
  }
  function paintSugg(c) {
    if (!root) return;
    root.querySelectorAll('.hc-sg[data-i]').forEach((d, i) => { const s = sugg && sugg[i]; d.style.backgroundColor = s ? s.hex : 'rgba(255,255,255,.16)';
      const dh = s ? Math.abs((((s.h - c.hue) % 360) + 540) % 360 - 180) : 999; d.classList.toggle('on', !!s && !pick && dh < 2.5 && Math.abs(s.s - c.sat) < .025); });
    const eye = root.querySelector('.hc-eye'); if (eye) { eye.style.backgroundColor = hslHex(c.hue, .3 + c.sat * .55, .55); eye.classList.toggle('on', !!pick); }
  }
  function paint() {
    if (!root || !sh) return; const c = view(), rt = resTone(c.tone);
    root.dataset.mode = c.mode; root.dataset.tone = rt;
    root.querySelectorAll('.hc-st').forEach(b => b.classList.toggle('on', b.dataset.v === c.mode));
    root.querySelectorAll('.hc-tone > div').forEach(b => b.classList.toggle('on', b.dataset.t === c.tone));
    paintPreviews(c); paintSliders(c); paintSugg(c);
    const size = sh.el.querySelector('.hc-size'); if (size) { size.innerHTML = SIZE(c.size === 'large'); size.setAttribute('aria-label', T(c.size === 'large' ? 'Ícones grandes' : 'Ícones pequenos')); }
    const sun = sh.el.querySelector('.hc-sun'); if (sun) { sun.classList.toggle('hc-dk', rt === 'dark'); sun.setAttribute('aria-label', T(rt === 'dark' ? 'Escuro' : 'Claro')); }
    glassSoon();   /* a altura muda com o estilo (cursores/tom aparecem e somem): a cópia desfocada do jogo tem de voltar a alinhar */
  }
  /* vidro no jogo: o kit pinta a cópia pré-desfocada do fundo (--wp-blur) alinhada por --gx/--gy (posição da folha no ecrã) */
  function glass() {
    if (!sh) return; const el = sh.el.querySelector('.sheet'); if (!el) return;
    if (window.LockEditor && LockEditor.glassPos) { try { LockEditor.glassPos(el); return; } catch (e) {} }
    let x = 0, y = 0, n = el; const scr = UI.screen(); while (n && n !== scr) { x += n.offsetLeft; y += n.offsetTop; n = n.offsetParent; }
    el.style.setProperty('--gx', x + 'px'); el.style.setProperty('--gy', y + 'px');
  }
  const glassSoon = () => { clearTimeout(glassSoon.t); glassSoon.t = setTimeout(glass, 30); };

  function open() {
    if (isA() || !window.UI || !window.Icons || !Icons.setStyle || !window.System) return false;
    if (sh) return true;
    if (window.Home && Home.enterEdit && !Home.edit) Home.enterEdit();   /* como no PearOS: Personalizar vive por cima da home em edição */
    root = build();
    /* fechada a meio de um arrasto (telemóvel guardado, morte, algemas → UI.dismissAll): o arrasto nunca chega ao end() e os ícones
       ficavam com a cor AO VIVO que não foi gravada (o System.apply não os refaz: a assinatura gravada não mudou). Repõe-se a gravada. */
    sh = UI.sheet({ title: T('Personalizar'), left: '', right: '', body: root, cls: 'hc-sheet', onClose: () => { stopPick(); const was = !!live; live = null; sh = null; root = null;
      if (raf) { try { cancelAnimationFrame(raf); } catch (e) {} } clearTimeout(rafT); raf = 0; rafT = 0;
      if (was && window.Icons && Icons.setStyle) { const c = cur(); try { Icons.setStyle({ mode: c.mode, hue: c.hue, sat: c.sat, tone: resTone(c.tone) }); } catch (e) {} } } });
    /* kit de vidro (liquid27.css): REGULAR com a cópia desfocada no jogo ([data-lgpos]). O tom escuro NÃO vai pela classe .dk do kit:
       o apps.css já tem um .dk (círculo de 80 × 80) e a folha encolhia para uma bola no canto - o tom escuro vem do homecustom.css */
    const sheetEl = sh.el.querySelector('.sheet'); sheetEl.classList.add('lg27', 'regular', 'hc-glass'); sheetEl.setAttribute('data-lgpos', '');
    /* sol à esquerda e tamanho à direita, no cabeçalho (é a pega de arrastar da folha: o pointerdown NÃO sobe, senão a captura do
       ponteiro no cabeçalho engolia o click destes botões no jogo - o mesmo cuidado do UI.sheet com o .sh-l/.sh-r) */
    const head = sh.el.querySelector('.sheet-head');
    const sun = UI.el(`<div class="hc-hb hc-sun" role="button">${SUN}</div>`), size = UI.el('<div class="hc-hb hc-size" role="button"></div>');
    [sun, size].forEach(b => { b.addEventListener('pointerdown', e => e.stopPropagation()); head.appendChild(b); });
    sun.onclick = () => commit({ iconTone: resTone(cur().tone) === 'dark' ? 'light' : 'dark' });
    size.onclick = () => commit({ iconSize: cur().size === 'large' ? 'small' : 'large' });
    paint(); suggest();
    setTimeout(glass, 0); setTimeout(glass, 440);   /* depois de a folha assentar (a transição de entrada não conta para offsetTop, mas o layout sim) */
    return true;
  }
  function close() { stopPick(); if (sh) sh.close(); }

  /* ouvintes - só para REPINTAR a folha aberta (os ícones são do System.apply): chaves mudadas por outro lado (Definições, harness),
     tema (o tom Auto), fundo novo (sugestões), troca de sistema (no Android a folha fecha) e dobrável (vidro) */
  if (window.Bridge && Bridge.on) {
    const KEYS = ['iconStyle', 'iconHue', 'iconSat', 'iconTone', 'iconSize', 'theme'];
    Bridge.on('state', p => { if (sh && p && !live && KEYS.some(k => k in p)) paint(); });
    Bridge.on('gameTime', () => { if (sh && !live) paint(); });
    Bridge.on('os:changed', () => { if (isA()) close(); });
    Bridge.on('wallpaper:changed', () => { sampler = null; if (sh) suggest(); });
    Bridge.on('fold:state', () => glassSoon());
  }
  return { open, close, isOpen: () => !!sh, get picking() { return !!pick; }, _x: { cur, resTone, getSampler, sampleAt, drawCss, startPick, stopPick, get sugg() { return sugg; } } };
})();
