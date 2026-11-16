/* ============================================================
   EDITOR DE FOTOS (básico, como nas Fotos do PearOS): Ajustar · Filtros · Recortar.
   window.PhotoEdit.open(photo, { host, onSaved(newPhoto) }) - abre por cima da janela das Fotos.
   · Tudo em canvas por PÍXEIS (sem ctx.filter nem CSS filter: o CEF do jogo não é de confiança com eles e o
     projeto proíbe filter em camadas grandes). A pré-visualização trabalha numa cópia pequena (≤ 520 px);
     "Concluído" repete as mesmas contas na imagem inteira (≤ 1280 px) e grava pelo Photos.save (aos bocados).
   · Concluído SUBSTITUI a foto (grava a nova, mantém a favorita, e só depois apaga a antiga); se a gravação
     falhar, a original fica intacta.
   ============================================================ */
window.PhotoEdit = (() => {
  const ADJ = [
    { k: 'exposure', label: 'Exposição', icon: 'sun' },
    { k: 'contrast', label: 'Contraste', icon: 'sliders' },
    { k: 'saturation', label: 'Saturação', icon: 'drop' },
    { k: 'warmth', label: 'Calor', icon: 'sun' },
    { k: 'vignette', label: 'Vinheta', icon: 'photo', min: 0 },
  ];
  const FILTERS = [
    { id: 'none', label: 'Original', v: {} },
    { id: 'vivid', label: 'Vivo', v: { contrast: .12, saturation: .35 } },
    { id: 'vwarm', label: 'Vivo quente', v: { contrast: .1, saturation: .3, warmth: .35 } },
    { id: 'vcool', label: 'Vivo frio', v: { contrast: .1, saturation: .3, warmth: -.35 } },
    { id: 'drama', label: 'Dramático', v: { exposure: -.15, contrast: .4, saturation: -.1, vignette: .45 } },
    { id: 'mono', label: 'Mono', v: { saturation: -1 } },
    { id: 'silver', label: 'Prata', v: { saturation: -1, contrast: .25, exposure: .1 } },
    { id: 'noir', label: 'Noir', v: { saturation: -1, contrast: .6, exposure: -.2, vignette: .5 } },
  ];
  const ASPECTS = [['orig', 'Original', 0], ['1:1', 'Quadrado', 1], ['4:3', '4:3', 4 / 3], ['3:4', '3:4', 3 / 4], ['16:9', '16:9', 16 / 9]];
  const blank = () => ({ exposure: 0, contrast: 0, saturation: 0, warmth: 0, vignette: 0, filter: 'none', rot: 0, flip: false, aspect: 'orig', straight: 0 });

  /* foto só com semente (gradiente CSS da galeria de demonstração) → a mesma imagem num canvas */
  function seedCanvas(seed) {
    const c = document.createElement('canvas'); c.width = 900; c.height = 1200; const x = c.getContext('2d');
    const a = ((seed * 37) % 360) * Math.PI / 180, dx = Math.sin(a) * 600, dy = -Math.cos(a) * 750;
    const gr = x.createLinearGradient(450 - dx, 600 - dy, 450 + dx, 600 + dy);
    gr.addColorStop(0, `hsl(${(seed * 53) % 360},70%,58%)`); gr.addColorStop(1, `hsl(${(seed * 53 + 110) % 360},65%,32%)`);
    x.fillStyle = gr; x.fillRect(0, 0, 900, 1200); return c;
  }
  const loadImg = src => new Promise((res, rej) => { const i = new Image(); if (!/^data:/i.test(src)) i.crossOrigin = 'anonymous'; i.onload = () => res(i); i.onerror = rej; i.src = src; });

  /* valores finais = filtro + ajustes do utilizador (somados, limitados). `fint` (intensidade do filtro,
     0..1) só existe no editor do Android; sem ele o filtro entra inteiro, como sempre no PearOS. */
  function values(st) {
    const f = (FILTERS.find(x => x.id === st.filter) || FILTERS[0]).v, o = {}, k0 = st.fint == null ? 1 : Math.max(0, Math.min(1, +st.fint || 0));
    ['exposure', 'contrast', 'saturation', 'warmth', 'vignette'].forEach(k => { o[k] = Math.max(k === 'vignette' ? 0 : -1, Math.min(1, (st[k] || 0) + (f[k] || 0) * k0)); });
    return o;
  }

  /* geometria: rodar 90°/espelhar → recorte central pelo formato → endireitar (com zoom de cobertura) → max px */
  function renderTo(src, st, max) {
    const quarter = ((st.rot % 360) + 360) % 360, swap = quarter === 90 || quarter === 270;
    const sw = src.width, sh = src.height, rw = swap ? sh : sw, rh = swap ? sw : sh;
    const A = (ASPECTS.find(a => a[0] === st.aspect) || ASPECTS[0])[2] || rw / rh;
    let cw = rw, ch = rw / A; if (ch > rh) { ch = rh; cw = rh * A; }
    const k = Math.min(1, max / Math.max(cw, ch));
    const out = document.createElement('canvas'); out.width = Math.max(1, Math.round(cw * k)); out.height = Math.max(1, Math.round(ch * k));
    const x = out.getContext('2d');
    const t = (st.straight || 0) * Math.PI / 180, cover = Math.abs(Math.cos(t)) + Math.abs(Math.sin(t)) * Math.max(out.width / out.height, out.height / out.width);
    x.save(); x.translate(out.width / 2, out.height / 2); x.rotate(t); x.scale(cover * k, cover * k);
    x.rotate(quarter * Math.PI / 180); if (st.flip) x.scale(-1, 1);
    x.drawImage(src, -sw / 2, -sh / 2); x.restore();
    pixels(out, values(st));
    return out;
  }

  function pixels(cv, v) {
    if (!v.exposure && !v.contrast && !v.saturation && !v.warmth && !v.vignette) return;
    const x = cv.getContext('2d'), W = cv.width, H = cv.height, img = x.getImageData(0, 0, W, H), d = img.data;
    const mult = Math.pow(2, v.exposure), con = 1 + v.contrast, sat = 1 + v.saturation, wr = v.warmth * 24, cx = W / 2, cy = H / 2, R2 = cx * cx + cy * cy;
    for (let y = 0, i = 0; y < H; y++) for (let xx = 0; xx < W; xx++, i += 4) {
      let r = d[i] * mult, g = d[i + 1] * mult, b = d[i + 2] * mult;
      r = (r - 128) * con + 128; g = (g - 128) * con + 128; b = (b - 128) * con + 128;
      const l = .299 * r + .587 * g + .114 * b; r = l + (r - l) * sat; g = l + (g - l) * sat; b = l + (b - l) * sat;
      r += wr; b -= wr;
      if (v.vignette) { const dd = ((xx - cx) * (xx - cx) + (y - cy) * (y - cy)) / R2; const f = 1 - v.vignette * Math.max(0, dd - .25) * 1.1; r *= f; g *= f; b *= f; }
      d[i] = r < 0 ? 0 : r > 255 ? 255 : r; d[i + 1] = g < 0 ? 0 : g > 255 ? 255 : g; d[i + 2] = b < 0 ? 0 : b > 255 ? 255 : b;
    }
    x.putImageData(img, 0, 0);
  }

  async function open(photo, opts = {}) {
    /* Android: o mesmo editor (mesmas contas e a mesma gravação) com a barra de ferramentas da Nova UI */
    if (window.System && System.os === 'android') return openNova(photo, opts);
    const g = UI.g, host = opts.host || UI.screen();
    if (!photo || photo.video) { UI.toast('Esta foto não pode ser editada'); return; }
    let src = null;
    try {
      const url = await Photos.data(photo, true);
      if (url) { const im = await loadImg(url); const c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight; c.getContext('2d').drawImage(im, 0, 0); c.getContext('2d').getImageData(0, 0, 1, 1); src = c; }
      else if (photo.seed) src = seedCanvas(+photo.seed || 1);
    } catch (e) { src = null; }
    if (!src) { UI.toast('Esta foto não pode ser editada'); return; }
    /* cópia pequena para a pré-visualização (as contas por píxel correm a cada movimento do slider) */
    const small = (() => { const k = Math.min(1, 520 / Math.max(src.width, src.height)); const c = document.createElement('canvas'); c.width = Math.round(src.width * k); c.height = Math.round(src.height * k); c.getContext('2d').drawImage(src, 0, 0, c.width, c.height); return c; })();

    let st = blank(), tab = 'adjust', adj = 'exposure', raf = 0, saving = false;
    const el = UI.el(`<div class="pe"><div class="pe-top"><div class="pe-btn pe-cancel">Cancelar</div><div class="pe-t">Editar</div><div class="pe-btn pe-done">Concluído</div></div>
      <div class="pe-stage"><canvas class="pe-cv"></canvas><div class="pe-hint">Toca e mantém para ver o original</div></div>
      <div class="pe-tools"></div>
      <div class="pe-tabs"><div data-t="adjust" class="on">${g('sliders', 22)}<span>Ajustar</span></div><div data-t="filters">${g('photo', 22)}<span>Filtros</span></div><div data-t="crop">${g('rotate', 22)}<span>Recortar</span></div></div></div>`);
    const cv = el.querySelector('.pe-cv'), tools = el.querySelector('.pe-tools');
    const draw = orig => { const r = orig ? renderTo(small, Object.assign(blank(), { rot: st.rot, flip: st.flip, aspect: st.aspect, straight: st.straight }), 520) : renderTo(small, st, 520); cv.width = r.width; cv.height = r.height; cv.getContext('2d').drawImage(r, 0, 0); };
    const redraw = () => { if (raf) return; raf = requestAnimationFrame(() => { raf = 0; draw(false); }); };
    const dirty = () => JSON.stringify(st) !== JSON.stringify(blank());

    function paintTools() {
      tools.innerHTML = '';
      if (tab === 'adjust') {
        const row = UI.el('<div class="pe-adj"></div>');
        ADJ.forEach(a => { const b = UI.el(`<div class="pe-dial ${a.k === adj ? 'on' : ''} ${st[a.k] ? 'set' : ''}"><div class="pe-ring">${g(a.icon, 20)}</div><span>${a.label}</span></div>`); b.onclick = () => { adj = a.k; paintTools(); }; row.appendChild(b); });
        const a = ADJ.find(x => x.k === adj);
        const sl = UI.el(`<div class="pe-slider"><input type="range" class="no-kb" min="${a.min === 0 ? 0 : -100}" max="100" value="${Math.round(st[adj] * 100)}"><b>${Math.round(st[adj] * 100)}</b></div>`);
        const r = sl.querySelector('input'); r.oninput = () => { st[adj] = +r.value / 100; sl.querySelector('b').textContent = r.value; redraw(); };
        r.onchange = () => paintTools();
        tools.append(row, sl);
      } else if (tab === 'filters') {
        const row = UI.el('<div class="pe-filters"></div>');
        FILTERS.forEach(f => {
          const b = UI.el(`<div class="pe-fil ${st.filter === f.id ? 'on' : ''}"><canvas></canvas><span>${f.label}</span></div>`);
          const th = renderTo(small, Object.assign(blank(), { filter: f.id, rot: st.rot, flip: st.flip, aspect: '1:1' }), 72); const c = b.querySelector('canvas'); c.width = th.width; c.height = th.height; c.getContext('2d').drawImage(th, 0, 0);
          b.onclick = () => { st.filter = f.id; redraw(); paintTools(); }; row.appendChild(b);
        });
        tools.appendChild(row);
      } else {
        const row = UI.el(`<div class="pe-crop"><div class="pe-cbtn" data-a="rot">${g('rotate', 22)}<span>Rodar</span></div><div class="pe-cbtn" data-a="flip">${g('repeat', 22)}<span>Espelhar</span></div><div class="pe-cbtn" data-a="reset">${g('x', 22)}<span>Repor</span></div></div>`);
        row.onclick = e => { const b = e.target.closest('.pe-cbtn'); if (!b) return; const k = b.dataset.a; if (k === 'rot') st.rot = (st.rot + 270) % 360; else if (k === 'flip') st.flip = !st.flip; else { st.rot = 0; st.flip = false; st.aspect = 'orig'; st.straight = 0; } redraw(); paintTools(); };
        const asp = UI.el('<div class="pe-aspects"></div>');
        ASPECTS.forEach(([id, label]) => { const c = UI.el(`<div class="pe-asp ${st.aspect === id ? 'on' : ''}">${label}</div>`); c.onclick = () => { st.aspect = id; redraw(); paintTools(); }; asp.appendChild(c); });
        const sl = UI.el(`<div class="pe-slider"><input type="range" class="no-kb" min="-15" max="15" step="1" value="${st.straight}"><b>${st.straight}°</b></div>`);
        const r = sl.querySelector('input'); r.oninput = () => { st.straight = +r.value; sl.querySelector('b').textContent = r.value + '°'; redraw(); };
        tools.append(row, asp, sl);
      }
    }
    el.querySelector('.pe-tabs').onclick = e => { const b = e.target.closest('[data-t]'); if (!b) return; tab = b.dataset.t; el.querySelectorAll('.pe-tabs > div').forEach(x => x.classList.toggle('on', x === b)); paintTools(); };
    /* manter premido na imagem = ver o original (como no PearOS) */
    const stage = el.querySelector('.pe-stage');
    stage.addEventListener('pointerdown', () => draw(true)); ['pointerup', 'pointercancel', 'pointerleave'].forEach(ev => stage.addEventListener(ev, () => draw(false)));
    const close = () => { el.classList.remove('in'); setTimeout(() => el.remove(), 260); };
    el.querySelector('.pe-cancel').onclick = async () => { if (dirty() && !await UI.confirm('Descartar alterações?', '', 'Descartar', true)) return; close(); };
    el.querySelector('.pe-done').onclick = async () => {
      if (saving) return; if (!dirty()) { close(); return; }
      saving = true; el.classList.add('busy'); UI.toast('A guardar…');
      try {
        const url = Photos.fromCanvas(renderTo(src, st, 1280), .88);
        if (!url) throw new Error('grande');
        const r = await Photos.save(url, {});
        if (!r || r.error || !r.id) throw new Error((r && r.error) || 'rpc');
        if (photo.favorite) await Photos.fav(r.id, true);
        if (photo.id) await Photos.remove(photo.id);
        await Photos.load(); Bridge.emit('photos');
        Sound.play('success'); UI.toast('Foto editada');
        const np = Photos.cache.find(p => p.id === r.id) || Object.assign({}, r, { url });
        if (!np.url) np.url = url;
        close(); if (opts.onSaved) opts.onSaved(np);
      } catch (e) { UI.toast('Não foi possível guardar a foto'); }
      saving = false; el.classList.remove('busy');
    };
    host.appendChild(el); draw(false); paintTools(); requestAnimationFrame(() => el.classList.add('in'));
    return { el, get state() { return st; }, set: (k, val) => { st[k] = val; draw(false); paintTools(); }, done: () => el.querySelector('.pe-done').click() };
  }

  /* ===================== EDITOR NO ANDROID (Nova UI 8.5) =====================
     As mesmas contas (renderTo/pixels) e a mesma gravação (Photos.save aos bocados; Guardar SUBSTITUI a
     foto, mantém a favorita e só depois apaga a antiga). Muda a cara e ganha o que o editor da Nova UI
     tem e aqui faz sentido: barra de baixo Transformar / Filtros / Tom, anular e refazer, Repor,
     comparar com o original (manter premido), intensidade do filtro e "Guardar como cópia".
     Fundo sempre escuro, como o editor da Nova UI. Nada aqui usa filter/backdrop-filter. */
  const NT = s => (window.L && L.t ? L.t(s) : s);
  const NGL = {
    x: '<path d="M6 6l12 12M18 6 6 18"/>',
    undo: '<path d="M9 14 4 9l5-5"/><path d="M4 9h10.5a5.5 5.5 0 0 1 0 11H11"/>',
    redo: '<path d="m15 14 5-5-5-5"/><path d="M20 9H9.5a5.5 5.5 0 0 0 0 11H13"/>',
    more: '<g fill="currentColor" stroke="none"><circle cx="12" cy="5.5" r="1.6"/><circle cx="12" cy="12" r="1.6"/><circle cx="12" cy="18.5" r="1.6"/></g>',
    cmp: '<rect x="3.5" y="4.5" width="17" height="15" rx="2.5"/><path d="M12 3v18"/><path d="M12 4.5h6a2.5 2.5 0 0 1 2.5 2.5v10a2.5 2.5 0 0 1-2.5 2.5h-6z" fill="currentColor" stroke="none" opacity=".35"/>',
    crop: '<path d="M7 3v13a1 1 0 0 0 1 1h13"/><path d="M3 7h13a1 1 0 0 1 1 1v13"/>',
    filters: '<circle cx="9" cy="9" r="5.5"/><circle cx="15" cy="9" r="5.5"/><circle cx="12" cy="14.5" r="5.5"/>',
    tone: '<circle cx="12" cy="12" r="8.5"/><path d="M12 3.5v17" /><path d="M12 3.5a8.5 8.5 0 0 1 0 17z" fill="currentColor" stroke="none"/>',
    exposure: '<circle cx="12" cy="12" r="4"/><path d="M12 2.5v2M12 19.5v2M4.6 4.6 6 6M18 18l1.4 1.4M2.5 12h2M19.5 12h2M4.6 19.4 6 18M18 6l1.4-1.4"/>',
    contrast: '<circle cx="12" cy="12" r="8.5"/><path d="M12 3.5a8.5 8.5 0 0 1 0 17z" fill="currentColor" stroke="none"/>',
    saturation: '<path d="M12 21a6.5 6.5 0 0 0 6.5-6.5c0-2-1-3.7-2.8-5.3C13.9 7.6 12.6 5.4 12 3c-.6 2.4-1.9 4.6-3.7 6.2C6.5 10.8 5.5 12.5 5.5 14.5A6.5 6.5 0 0 0 12 21z"/>',
    warmth: '<path d="M14 14.8V5a2 2 0 0 0-4 0v9.8a4 4 0 1 0 4 0z"/><path d="M12 11v5"/>',
    vignette: '<rect x="3" y="3" width="18" height="18" rx="4"/><circle cx="12" cy="12" r="5"/>',
    rot: '<path d="M4 12a8 8 0 1 0 2.4-5.7"/><path d="M4 4v5h5"/>',
    flip: '<path d="M12 3v18"/><path d="M8.5 7 3.5 17h5z"/><path d="M15.5 7l5 10h-5z"/>',
    reset: '<path d="M4 12a8 8 0 1 0 2.4-5.7"/><path d="M4 4v5h5"/><circle cx="12" cy="12" r="1.5" fill="currentColor" stroke="none"/>',
  };
  const nic = n => `<svg class="agal-ed-gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">${NGL[n] || ''}</svg>`;
  const NADJ = [{ k: 'exposure', label: 'Exposição' }, { k: 'contrast', label: 'Contraste' }, { k: 'saturation', label: 'Saturação' }, { k: 'warmth', label: 'Temperatura' }, { k: 'vignette', label: 'Vinheta', min: 0 }];
  const NASP = [['orig', 'Original'], ['1:1', '1:1'], ['4:3', '4:3'], ['3:4', '3:4'], ['16:9', '16:9']];
  let novaCur = null;

  async function openNova(photo, opts = {}) {
    const host = opts.host || UI.screen();
    if (!photo || photo.video) { UI.toast(NT('Esta foto não pode ser editada')); return; }
    if (novaCur && novaCur.el.isConnected) return novaCur;
    let src = null;
    try {
      const url = await Photos.data(photo, true);
      if (url) { const im = await loadImg(url); const c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight; c.getContext('2d').drawImage(im, 0, 0); c.getContext('2d').getImageData(0, 0, 1, 1); src = c; }
      else if (photo.seed) src = seedCanvas(+photo.seed || 1);
    } catch (e) { src = null; }
    if (!src) { UI.toast(NT('Esta foto não pode ser editada')); return; }
    const small = (() => { const k = Math.min(1, 520 / Math.max(src.width, src.height)); const c = document.createElement('canvas'); c.width = Math.round(src.width * k); c.height = Math.round(src.height * k); c.getContext('2d').drawImage(src, 0, 0, c.width, c.height); return c; })();

    const nblank = () => Object.assign(blank(), { fint: 1 });
    let st = nblank(), tab = 'crop', adj = 'exposure', raf = 0, saving = false, comparing = false;
    const hist = [JSON.stringify(st)]; let hi = 0;
    const el = UI.el(`<div class="agal-ed">
      <div class="agal-ed-top"><div class="agal-ed-ib" data-a="cancel" role="button" aria-label="${UI.esc(NT('Cancelar'))}">${nic('x')}</div><div class="agal-ed-ib" data-a="undo" role="button" aria-label="${UI.esc(NT('Anular'))}">${nic('undo')}</div><div class="agal-ed-ib" data-a="redo" role="button" aria-label="${UI.esc(NT('Refazer'))}">${nic('redo')}</div><div class="agal-ed-gap"></div><div class="agal-ed-rv" data-a="revert" role="button">${UI.esc(NT('Repor'))}</div><div class="agal-ed-save" data-a="save" role="button">${UI.esc(NT('Guardar'))}</div><div class="agal-ed-ib" data-a="more" role="button" aria-label="${UI.esc(NT('Mais opções'))}">${nic('more')}</div></div>
      <div class="agal-ed-stage"><canvas class="agal-ed-cv"></canvas><div class="agal-ed-cmp" data-a="cmp" role="button" aria-label="${UI.esc(NT('Comparar com o original'))}">${nic('cmp')}</div></div>
      <div class="agal-ed-opts"></div>
      <div class="agal-ed-tools"><div data-t="crop" role="button">${nic('crop')}<span>${UI.esc(NT('Transformar'))}</span></div><div data-t="filters" role="button">${nic('filters')}<span>${UI.esc(NT('Filtros'))}</span></div><div data-t="tone" role="button">${nic('tone')}<span>${UI.esc(NT('Tom'))}</span></div></div></div>`);
    const cv = el.querySelector('.agal-ed-cv'), optsEl = el.querySelector('.agal-ed-opts');
    const draw = orig => { const r = orig ? renderTo(small, Object.assign(blank(), { rot: st.rot, flip: st.flip, aspect: st.aspect, straight: st.straight }), 520) : renderTo(small, st, 520); cv.width = r.width; cv.height = r.height; cv.getContext('2d').drawImage(r, 0, 0); };
    const redraw = () => { if (raf) return; raf = requestAnimationFrame(() => { raf = 0; draw(comparing); }); };
    const dirty = () => JSON.stringify(st) !== JSON.stringify(nblank());
    const paintTop = () => {
      el.querySelector('[data-a="undo"]').classList.toggle('dis', hi <= 0);
      el.querySelector('[data-a="redo"]').classList.toggle('dis', hi >= hist.length - 1);
      el.querySelector('[data-a="revert"]').classList.toggle('dis', !dirty());
      el.querySelector('[data-a="save"]').classList.toggle('dis', !dirty());
    };
    /* anular/refazer: um passo por cada mudança acabada (largar o cursor, tocar num filtro, rodar...) */
    const commit = () => { const s = JSON.stringify(st); if (s === hist[hi]) { paintTop(); return; } hist.length = hi + 1; hist.push(s); if (hist.length > 60) hist.shift(); hi = hist.length - 1; paintTop(); };
    const restore = i => { hi = i; st = JSON.parse(hist[hi]); draw(false); paintOpts(); paintTop(); };
    /* cursor Nova UI: faixa fina com o preenchimento a partir do zero (do meio, nos que vão de -100 a 100) */
    const slider = (min, max, val, fmt, onInput) => {
      const s = UI.el(`<div class="agal-ed-sl"><input type="range" class="no-kb no-dragscroll" min="${min}" max="${max}" step="1" value="${val}"><b></b></div>`);
      const r = s.querySelector('input'), b = s.querySelector('b');
      /* o preenchimento vai por variáveis (--a/--c) que a faixa (::-webkit-slider-runnable-track) lê */
      const fill = () => { const v = +r.value, z = min < 0 ? 50 : 0, p = (v - min) / (max - min) * 100;
        r.style.setProperty('--a', Math.min(z, p).toFixed(2) + '%'); r.style.setProperty('--c', Math.max(z, p).toFixed(2) + '%'); b.textContent = fmt(v); };
      r.oninput = () => { fill(); onInput(+r.value); };
      r.onchange = () => commit();
      fill(); return s;
    };
    function paintOpts() {
      optsEl.textContent = '';
      el.querySelectorAll('.agal-ed-tools > div').forEach(x => x.classList.toggle('on', x.dataset.t === tab));
      if (tab === 'tone') {
        const row = UI.el('<div class="agal-ed-chips"></div>');
        NADJ.forEach(a => {
          const v = Math.round((st[a.k] || 0) * 100);
          const c = UI.el(`<div class="agal-ed-chip ${a.k === adj ? 'on' : ''} ${v ? 'set' : ''}" role="button"><div class="agal-ed-cc">${v ? `<b>${v > 0 && a.min !== 0 ? '+' : ''}${v}</b>` : nic(a.k)}</div><span>${UI.esc(NT(a.label))}</span></div>`);
          c.onclick = () => { adj = a.k; Sound.play('click'); paintOpts(); };
          row.appendChild(c);
        });
        const a = NADJ.find(x => x.k === adj);
        const sl = slider(a.min === 0 ? 0 : -100, 100, Math.round((st[adj] || 0) * 100), v => (v > 0 && a.min !== 0 ? '+' : '') + v, v => {
          st[adj] = v / 100; redraw();
          const cc = row.children[NADJ.indexOf(a)]; cc.classList.toggle('set', !!v); cc.querySelector('.agal-ed-cc').innerHTML = v ? `<b>${v > 0 && a.min !== 0 ? '+' : ''}${v}</b>` : nic(a.k);
        });
        optsEl.append(row, sl);
      } else if (tab === 'filters') {
        const row = UI.el('<div class="agal-ed-fils"></div>');
        FILTERS.forEach(f => {
          const b = UI.el(`<div class="agal-ed-fil ${st.filter === f.id ? 'on' : ''}" role="button"><canvas></canvas><span>${UI.esc(NT(f.label))}</span></div>`);
          const th = renderTo(small, Object.assign(blank(), { filter: f.id, rot: st.rot, flip: st.flip, aspect: '1:1' }), 72); const c = b.querySelector('canvas'); c.width = th.width; c.height = th.height; c.getContext('2d').drawImage(th, 0, 0);
          b.onclick = () => { if (st.filter === f.id) return; st.filter = f.id; st.fint = 1; Sound.play('click'); draw(false); commit(); paintOpts(); };
          row.appendChild(b);
        });
        optsEl.appendChild(row);
        if (st.filter !== 'none') optsEl.appendChild(slider(0, 100, Math.round((st.fint == null ? 1 : st.fint) * 100), v => v, v => { st.fint = v / 100; redraw(); }));
        else optsEl.appendChild(UI.el(`<div class="agal-ed-hint">${UI.esc(NT('Escolhe um filtro para ajustar a intensidade'))}</div>`));
        const on = row.querySelector('.on'); if (on) row.scrollLeft = Math.max(0, on.offsetLeft - 140);
      } else {
        const row = UI.el(`<div class="agal-ed-tr"><div data-a="rot" role="button"><div>${nic('rot')}</div><span>${UI.esc(NT('Rodar'))}</span></div><div data-a="flip" role="button"><div>${nic('flip')}</div><span>${UI.esc(NT('Espelhar'))}</span></div><div data-a="reset" role="button"><div>${nic('reset')}</div><span>${UI.esc(NT('Repor'))}</span></div></div>`);
        row.onclick = e => { const b = e.target.closest('[data-a]'); if (!b) return; const k = b.dataset.a; Sound.play('click');
          if (k === 'rot') st.rot = (st.rot + 270) % 360; else if (k === 'flip') st.flip = !st.flip; else { st.rot = 0; st.flip = false; st.aspect = 'orig'; st.straight = 0; }
          draw(false); commit(); paintOpts(); };
        const asp = UI.el('<div class="agal-ed-asp"></div>');
        NASP.forEach(([id, label]) => { const c = UI.el(`<div class="${st.aspect === id ? 'on' : ''}" role="button">${UI.esc(NT(label))}</div>`); c.onclick = () => { if (st.aspect === id) return; st.aspect = id; Sound.play('click'); draw(false); commit(); paintOpts(); }; asp.appendChild(c); });
        optsEl.append(row, asp, slider(-15, 15, st.straight || 0, v => v + '°', v => { st.straight = v; redraw(); }));
      }
    }
    el.querySelector('.agal-ed-tools').onclick = e => { const b = e.target.closest('[data-t]'); if (!b || b.dataset.t === tab) return; tab = b.dataset.t; Sound.play('click'); paintOpts(); };
    /* comparar: manter premido o botão (ou a própria imagem) mostra o original */
    const cmpOn = () => { comparing = true; draw(true); el.classList.add('cmp'); };
    const cmpOff = () => { if (!comparing) return; comparing = false; draw(false); el.classList.remove('cmp'); };
    [el.querySelector('.agal-ed-cmp'), el.querySelector('.agal-ed-stage')].forEach(t => { t.addEventListener('pointerdown', e => { e.stopPropagation(); cmpOn(); }); ['pointerup', 'pointercancel', 'pointerleave'].forEach(ev => t.addEventListener(ev, cmpOff)); });
    /* a Galeria acerta a barra de estado (texto claro por cima do editor escuro) */
    const tone = () => { try { if (host._novaTone) host._novaTone(); } catch (e) {} };
    const close = () => { if (novaCur && novaCur.el === el) novaCur = null; el.classList.remove('in'); setTimeout(() => { el.remove(); tone(); }, 240); };
    /* gravar: `copy` mantém a original (Guardar como cópia); sem `copy` substitui-a, como no PearOS */
    const save = async copy => {
      if (saving) return; if (!dirty()) { if (!copy) close(); return; }
      saving = true; el.classList.add('busy'); UI.toast(NT('A guardar…'));
      try {
        const url = Photos.fromCanvas(renderTo(src, st, 1280), .88);
        if (!url) throw new Error('grande');
        const r = await Photos.save(url, {});
        if (!r || r.error || !r.id) throw new Error((r && r.error) || 'rpc');
        if (!copy && photo.favorite) await Photos.fav(r.id, true);
        if (!copy && photo.id) await Photos.remove(photo.id);
        await Photos.load(); Bridge.emit('photos');
        Sound.play('success'); UI.toast(copy ? NT('Cópia guardada na Galeria') : NT('Foto editada'));
        const np = Photos.cache.find(p => p.id === r.id) || Object.assign({}, r, { url });
        if (!np.url) np.url = url;
        close();
        if (!copy && opts.onSaved) opts.onSaved(np);
      } catch (e) { UI.toast(NT('Não foi possível guardar a foto')); }
      saving = false; el.classList.remove('busy');
    };
    el.querySelector('.agal-ed-top').onclick = async e => {
      const b = e.target.closest('[data-a]'); if (!b) return; const a = b.dataset.a;
      if (a === 'cancel') { Sound.play('click'); if (dirty() && !await UI.confirm(NT('Descartar alterações?'), NT('As alterações a esta foto não vão ser guardadas.'), NT('Descartar'), true)) return; close(); }
      else if (a === 'undo') { if (hi > 0) { Sound.play('click'); restore(hi - 1); } }
      else if (a === 'redo') { if (hi < hist.length - 1) { Sound.play('click'); restore(hi + 1); } }
      else if (a === 'revert') { if (!dirty()) return; Sound.play('click'); st = nblank(); draw(false); commit(); paintOpts(); }
      else if (a === 'save') save(false);
      else if (a === 'more') UI.ctxMenu(b, [{ label: NT('Guardar como cópia'), icon: 'copy', onTap: () => { if (!dirty()) { UI.toast(NT('Ainda não há alterações')); return; } save(true); } }]);
    };
    host.appendChild(el); draw(false); paintOpts(); paintTop(); tone(); requestAnimationFrame(() => el.classList.add('in'));
    novaCur = { el, close, get state() { return st; }, set: (k, val) => { st[k] = val; draw(false); commit(); paintOpts(); }, done: () => save(false) };
    return novaCur;
  }
  return { open, FILTERS, ADJ, renderTo, get current() { return novaCur; } };
})();
