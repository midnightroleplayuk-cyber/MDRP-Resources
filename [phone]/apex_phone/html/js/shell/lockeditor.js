/* ============================================================
   EDITOR DO ECRÃ BLOQUEADO - PearOS 27 (apex_phone 1.4.0)   window.LockEditor
   O que a galeria (lockgallery.js) delega aqui, igual às capturas do iOS 26/27:
     · a PEGA do relógio (o "⌟" no canto inferior direito da moldura): arrastar para baixo aumenta a hora, ao vivo, e grava ao largar;
     · as molduras finas da data e da hora, o "menos" dos widgets e dos dois controlos e o "+" tracejado de um lado vazio (CSS);
     · a linha de baixo do editor: miniatura do fundo (muda o fundo DESTE ecrã), estilos de fotografia (Natural / Preto e branco /
       Duotom / Lavado, com pontos e deslize no cartão) e "…" (Alinhamento, Posição, Repor relógio);
     · enquadrar a foto (1.4.1): arrastar no fundo do cartão move-a, a roda faz zoom (o "Pinch to Crop" do iOS, com rato), custom.crop;
     · "Fonte e cor" num CARTÃO de vidro a flutuar (o ecrã continua à vista por cima e muda ao vivo);
     · "Adicionar widgets" (pesquisa, sugestões com o ícone da app, uma secção por app, 4 lugares) e a galeria de Controlos;
     · as folhas dos fundos novos (Emoji, Cor, Astronomia, Aleatórias) que o seletor de fundos abre.
   Depende de LockGallery._x (ecrã atual, updateCur, wsheet...), do Lock (previewScale, clockMetrics, NUMERALS, controlOf...),
   do WallKinds e do kit de vidro do liquid27.css (.lg27 ...). Todas as chamadas para fora estão guardadas: um módulo que falte
   nunca rebenta isto (a peça respetiva simplesmente não aparece).
   Regras do CEF 103 (o Chromium do jogo): só transform/opacity animam; nada de filter/backdrop-filter no jogo (o vidro é a
   cópia pré-desfocada do fundo, alinhada por --gx/--gy - glassPos); nada de color-mix nem clip-path; imagens só pelo CSSOM;
   ponteiro: botão esquerdo, captura em try/catch, deltas a dividir pelo zoom, estado gravado só ao largar; as transições podem
   ficar paradas (CEF sem foco, headless), por isso o estado final é sempre imposto com temporizadores.
   ============================================================ */
window.LockEditor = (() => {
  const g = (n, s) => UI.g(n, s);
  const X = () => (window.LockGallery && LockGallery._x) || null;
  const isAnd = () => !!(window.System && System.os === 'android');
  const scr = () => UI.screen();
  const lockEl = () => document.getElementById('lock');
  const T = k => (window.L && L.t ? L.t(k) : k);
  const esc = s => UI.esc(String(s == null ? '' : s));
  const snd = k => { try { if (window.Sound) Sound.play(k); } catch (e) {} };
  const cur = () => { const x = X(); try { return x && x.cur ? x.cur() : null; } catch (e) { return null; } };
  const up = (patch, o) => { const x = X(); if (x && x.updateCur) x.updateCur(patch, o); };
  const isEdit = () => { const x = X(); if (x && x.isEdit) return !!x.isEdit(); const s = scr(); return !!(s && s.classList.contains('lsg-edit')); };
  const zoomNow = () => { try { return (UI.zoom && UI.zoom()) || 1; } catch (e) { return 1; } };
  /* retângulo em px REAIS do ecrã nos dois motores (o CEF 103 divide o getBoundingClientRect pelo zoom; o clientX não) */
  const vr = el => (UI.vrect ? UI.vrect(el) : el.getBoundingClientRect());
  const norm = s => String(s || '').toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');
  /* volta a pôr as variáveis do estado por cima das de pré-visualização (um arrasto cancelado) */
  const reapply = () => { try { if (System.apply) System.apply(); else System.setState({}, { noSave: true }); } catch (e) {} };
  const stopDown = el => el.addEventListener('pointerdown', e => e.stopPropagation());

  /* ---------- cor: a MESMA matemática do lockgallery.js (matiz 0..360 + tom: 0 pastel/branco, .5 cor pura, 1 escura) ---------- */
  const hexOf = (r, gg, b) => '#' + [r, gg, b].map(v => Math.round(Math.max(0, Math.min(255, v))).toString(16).padStart(2, '0')).join('').toUpperCase();
  function pureOf(h) { h = ((h % 360) + 360) % 360; const x = 1 - Math.abs((h / 60) % 2 - 1); const [r, gg, b] = h < 60 ? [1, x, 0] : h < 120 ? [x, 1, 0] : h < 180 ? [0, 1, x] : h < 240 ? [0, x, 1] : h < 300 ? [x, 0, 1] : [1, 0, x]; return [r * 255, gg * 255, b * 255]; }
  function htHex(h, t) { const p = pureOf(h); if (t <= .5) { const k = t * 2; return hexOf(...p.map(c => 255 + (c - 255) * k)); } const k = (t - .5) * 2 * .8; return hexOf(...p.map(c => c * (1 - k))); }
  function hexHT(hex) { const n = parseInt(String(hex || '').replace('#', ''), 16); if (isNaN(n)) return [210, .5]; const r = (n >> 16) & 255, gg = (n >> 8) & 255, b = n & 255, mx = Math.max(r, gg, b), mn = Math.min(r, gg, b), d = mx - mn;
    let h = 0; if (d) { if (mx === r) h = 60 * (((gg - b) / d) % 6); else if (mx === gg) h = 60 * ((b - r) / d + 2); else h = 60 * ((r - gg) / d + 4); }
    const t = mx >= 250 ? (1 - mn / 255) / 2 : .5 + (1 - mx / 255) / 1.6; return [(h + 360) % 360, Math.max(0, Math.min(1, t))]; }
  const rgbOf = hex => { const n = parseInt(String(hex || '').replace('#', ''), 16); return isNaN(n) ? [255, 255, 255] : [(n >> 16) & 255, (n >> 8) & 255, n & 255]; };
  const satOf = hex => { const [r, gg, b] = rgbOf(hex), mx = Math.max(r, gg, b), mn = Math.min(r, gg, b); return mx ? (mx - mn) / mx : 0; };
  /* brancos e cinzentos não têm matiz: o "tom" deles é uma rampa de cinzento (branco → grafite), senão o branco dava rosas */
  const GREY0 = 255, GREY1 = 44;
  const greyHex = t => { const v = GREY0 - (GREY0 - GREY1) * t; return hexOf(v, v, v); };
  const greyT = hex => { const [r, gg, b] = rgbOf(hex); return Math.max(0, Math.min(1, (GREY0 - (r + gg + b) / 3) / (GREY0 - GREY1))); };
  const ACHRO = .07;
  /* hora ao vivo enquanto se arrasta: só as variáveis CSS (o estado grava-se ao largar) */
  const liveColor = hex => { { const lk = document.getElementById('lock'); if (lk) lk.classList.remove('clock-auto'); }   /* a arrastar a cor deixa de ser automática (lock.js volta a decidir ao gravar) */
    const x = X(); if (x && x.liveColor) { x.liveColor(hex); return; } const [r, gg, b] = rgbOf(hex); const de = document.documentElement.style; de.setProperty('--clock-color', hex); de.setProperty('--clock-rgb', r + ',' + gg + ',' + b); };

  /* as cores da hora do PearOS 26/27 (branco, marfim, amarelos, pêssego, menta, verde-água, céu, azul, lavanda, rosas, laranja,
     cinzento) - a última bola é o arco-íris (cor própria: matiz + tom) */
  const SWATCHES = ['#FFFFFF', '#F3E9D8', '#FFD60A', '#F7E27A', '#FFF4B8', '#FFC7A3', '#B6F2D1', '#7FF0D2', '#9BD9FF', '#5DD9FF', '#0A84FF', '#BBA9FF', '#FF7AB6', '#FF9C86', '#FF9F0A', '#C7C7CC'];
  const K_MIN = .72, K_MAX = 1.75;
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  /* estilos de fotografia (só em fundos de imagem): o WallKinds desenha-os; aqui só se escolhe */
  const STYLES = [['natural', 'Natural'], ['mono', 'Preto e branco'], ['duotone', 'Duotom'], ['wash', 'Lavado']];
  /* a app de cada widget quando o Lock ainda não a dá na lista (o emblema e a secção da folha "Adicionar widgets") */
  const WAPP = { battery: 'settings', weather: 'weather', rain: 'weather', forecast: 'weather', alarm: 'clock', timer: 'clock', day: 'calendar', calendar: 'calendar', reminders: 'reminders', music: 'music', mail: 'mail', messages: 'messages', wallet: 'wallet', notes: 'notes' };
  /* ordem das secções por app e das sugestões (retangulares primeiro: a grelha densa de 4 colunas fica sem buracos) */
  const APP_ORDER = ['settings', 'weather', 'calendar', 'reminders', 'clock', 'music', '@news', 'mail', 'messages', 'wallet', 'notes'];
  const SUGG = ['forecast', 'calendar', 'battery', 'mail', 'weather', 'alarm', 'reminders', 'music', 'messages', 'rain', 'day', 'notes', 'news', 'wallet', 'timer'];
  /* glifos de recurso (um controlo novo cujo glifo ainda não exista no Icons) */
  const GLYPH_FB = { wallet: 'card', photos: 'photo', darkmode: 'moon', dnd: 'moon', scan: 'zoom', stopwatch: 'stopwatch' };
  const glyph = (name, size) => { const n = name && (!Icons.has || Icons.has(name)) ? name : (GLYPH_FB[name] || 'circle'); return g(n, size); };

  let root = null, row = null, thumbEl = null, moreEl = null, styleEl = null, hintEl = null, handleEl = null, hd = null, sw = null, swallowUntil = 0, fcRepaint = null, hintT = 0, cropLive = null, wheelT = 0;
  const openSh = { fc: null, aw: null, ct: null };
  const pickRepaint = new Set();   /* pré-visualizações das folhas dos fundos abertas (repintam quando um desenho em canvas fica pronto) */

  /* ---------- vidro: alinhamento da cópia pré-desfocada (adenda 4) ----------
     Para `el` e cada [data-lgpos] lá dentro: soma offsetLeft/offsetTop até ao #screen (ignora transforms: é a posição FINAL, de
     repouso - uma folha a meio da entrada fica certa quando assenta) e escreve --gx/--gy em px do telemóvel. As peças dentro do
     cartão escalado (#lock) não levam data-lgpos: usam só a tinta clara do kit. */
  function glassPos(el) {
    const s = scr(); if (!el || !s) return;
    const list = [el].concat(Array.from(el.querySelectorAll ? el.querySelectorAll('[data-lgpos]') : []));
    list.forEach(n => { let x = 0, y = 0, p = n, guard = 0; while (p && p !== s && guard++ < 40) { x += p.offsetLeft || 0; y += p.offsetTop || 0; p = p.offsetParent; }
      if (p !== s) return; n.style.setProperty('--gx', x + 'px'); n.style.setProperty('--gy', y + 'px'); });
  }
  const glassAll = () => { Object.keys(openSh).forEach(k => { const sh = openSh[k]; if (sh && sh.el && sh.el.isConnected) glassPos(sh.el); }); };

  /* ---------- tom do vidro: claro sobre fundos claros, escuro sobre os escuros (como o PearOS) ---------- */
  function toneNow() { const ls = cur(), c = ls && ls.custom, WK = window.WallKinds;
    try { if (c && WK && WK.isKind && WK.isKind(c) && WK.dark) return WK.dark(c) ? 'dark' : 'light'; } catch (e) {}
    const t = scr() && scr().dataset.wpLockTone; return t === 'light' ? 'light' : 'dark'; }

  /* ---------- folhas do editor: a wsheet da galeria vestida com o kit de vidro ----------
     kinds 'fc' (cartão flutuante), 'aw', 'ct'. O invólucro leva lke-sheet lke-<kind> (o lockeditor.css desenha por aí); a folha leva
     o material REGULAR do kit com a cópia do fundo do bloqueado (on-lock + data-lgpos). Enquanto está aberta, o #screen leva
     lke-sh-<kind> (as molduras que não interessam, a linha de baixo e o Cancelar/Concluído saem, como nas capturas). O fecho
     pode vir de muitos lados (X, arrastar, outra folha, sair do editor, UI.dismissAll): um MutationObserver vê o .closing. */
  function openWs(kind, title, body, tone) {
    const x = X(); let sh = null;
    if (x && x.wsheet) sh = x.wsheet(title, body, kind);
    else { sh = UI.sheet({ title, body, cls: 'lsg-ws lsg-ws-' + kind }); const r = sh.el.querySelector('.sh-r'); if (r) { r.innerHTML = g('x', 15); r.setAttribute('aria-label', T('Fechar')); }
      setTimeout(() => { if (sh.el.isConnected && !sh.el.classList.contains('closing')) sh.el.classList.add('in'); }, 80); }   /* o rAF que mostra a folha nem sempre corre (CEF sem foco / headless) */
    if (!sh || !sh.el) return null;
    const t = tone || toneNow();
    /* ⚠️ o tom ESCURO é .lg27-dk, NUNCA .dk: o apps.css tem um .dk global (tecla do marcador: 80×80, redonda, flex em coluna)
       que encolhia a folha para 80 px. O claro usa .lt (força o claro mesmo com body.dark). O lke-dark do invólucro repete as
       tintas escuras do kit no lockeditor.css (recurso se o liquid27.css em cache ainda não tiver o .lg27-dk). */
    const tk = t === 'light' ? 'lt' : 'lg27-dk';
    sh.el.classList.add('lke-sheet', 'lke-' + kind, t === 'light' ? 'lke-light' : 'lke-dark');
    const sheet = sh.el.querySelector('.sheet');
    if (sheet) { sheet.classList.add('lg27', 'regular', 'on-lock', tk); sheet.setAttribute('data-lgpos', ''); }
    const r = sh.el.querySelector('.sh-r'); if (r) { r.classList.add('lg27', 'clear', 'int', tk); if (!r.querySelector('svg')) r.innerHTML = g('x', 15); }
    const s = scr(); s.classList.add('lke-sh-' + kind); openSh[kind] = sh;
    const done = () => { if (openSh[kind] !== sh) return; openSh[kind] = null; s.classList.remove('lke-sh-' + kind); try { mo.disconnect(); } catch (e) {} if (kind === 'fc') fcRepaint = null; };
    const mo = new MutationObserver(() => { if (!sh.el.isConnected || sh.el.classList.contains('closing')) done(); });
    mo.observe(sh.el, { attributes: true, attributeFilter: ['class'] });
    sh.lkeDone = done;
    /* a folha entra com transform: a posição de repouso mede-se já (offset ignora o transform) e outra vez quando assentar */
    glassPos(sh.el); setTimeout(() => { if (sh.el.isConnected) glassPos(sh.el); }, 420);
    return sh;
  }
  const sweep = () => Object.keys(openSh).forEach(k => { const sh = openSh[k]; if (sh && (!sh.el.isConnected || sh.el.classList.contains('closing')) && sh.lkeDone) sh.lkeDone(); });
  function closeMine() { const x = X(); Object.keys(openSh).forEach(k => { const sh = openSh[k]; if (!sh) return; try { if (x && x.closeWs) x.closeWs(); } catch (e) {} try { if (sh.el.isConnected && !sh.el.classList.contains('closing')) sh.close(); } catch (e) {} if (sh.lkeDone) sh.lkeDone(); }); }

  /* pesquisa com o texto ao CENTRO enquanto vazia (como a "Search Controls" do PearOS): o campo fica com a largura do próprio
     placeholder (atributo size) e o conjunto centra-se; com texto ou foco volta a ocupar a linha toda (CSS) */
  function searchBox(ph, onQ) { const s = UI.search(ph, onQ); s.classList.add('lke-search'); const i = s.querySelector('input'); if (i) { i.setAttribute('size', String(Math.max(6, Array.from(ph).length + 1))); i.setAttribute('spellcheck', 'false'); i.setAttribute('autocomplete', 'off'); }
    stopDown(s); return s; }

  /* ---------- barra de arrastar própria (peso, matiz, tom) ----------
     0..1 pela posição do ponteiro na barra (retângulo REAL lido uma vez por gesto); o polegar (largura kw) fica sempre dentro. */
  function slide(bar, onMove, onEnd) { let on = null;
    const at = e => Math.max(0, Math.min(1, (e.clientX - on.l) / Math.max(1, on.w)));
    bar.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; e.stopPropagation(); e.preventDefault(); const r = vr(bar); on = { l: r.left, w: r.width, id: e.pointerId }; try { bar.setPointerCapture(e.pointerId); } catch (x) {} bar.classList.add('lke-drag'); onMove(at(e)); });
    bar.addEventListener('pointermove', e => { if (on && e.pointerId === on.id) onMove(at(e)); });
    bar.addEventListener('pointerup', e => { if (!on) return; const v = at(e); on = null; bar.classList.remove('lke-drag'); onEnd(v); });
    bar.addEventListener('pointercancel', () => { if (!on) return; on = null; bar.classList.remove('lke-drag'); onEnd(null); }); }
  const knobAt = (bar, v) => { const k = bar.querySelector('i'); if (!k) return; const kw = k.offsetWidth || 26; k.style.left = `calc(${(v * 100).toFixed(2)}% - ${(v * kw).toFixed(1)}px)`; };

  /* ================= PEGA DO RELÓGIO ================= */
  const kOf = ls => { try { if (window.Lock && Lock.clockMetrics && ls) { const m = Lock.clockMetrics(ls); if (m && isFinite(m.k)) return +m.k; } } catch (e) {}
    const v = ls && +ls.clockScale; if (ls && ls.clockScale != null && isFinite(v) && v >= K_MIN && v <= K_MAX) return v; return ({ small: .85, large: 1.14 })[ls && ls.clockSize] || 1; };
  /* pré-visualização ao vivo: o Lock.previewScale (contrato B: escreve --clock-k/-kx/-sy no máximo uma vez por frame). Se ainda
     não existir, a mesma coisa aqui (para a pega nunca ficar morta). null = repor o estado. */
  let pvRaf = 0, pvK = null;
  function preview(k) {
    if (window.Lock && Lock.previewScale) { try { Lock.previewScale(k); return; } catch (e) {} }
    if (k == null) { if (pvRaf) cancelAnimationFrame(pvRaf); pvRaf = 0; pvK = null; reapply(); return; }
    if (document.body.classList.contains('hidden')) return;
    pvK = k; if (pvRaf) return;
    pvRaf = requestAnimationFrame(() => { pvRaf = 0; if (pvK == null) return; const KX = (window.System && System.CLOCK_KX) || 1.15, k2 = pvK; const de = document.documentElement.style;
      de.setProperty('--clock-k', k2.toFixed(3)); de.setProperty('--clock-kx', Math.min(k2, KX).toFixed(3)); de.setProperty('--clock-sy', Math.max(1, k2 / KX).toFixed(3)); });
  }
  /* o "clique" que o browser dispara no fim de um arrasto (pega, deslize do estilo) não pode abrir o "Fonte e cor" nem fechar a folha:
     um ouvinte em CAPTURA na window corre antes de todos (até antes da captura da galeria no #lock) e engole exatamente um */
  const swallow = () => { swallowUntil = performance.now() + 400; };
  function bindHandle(h) {
    h.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; e.stopPropagation(); e.preventDefault(); if (!isEdit() || hd) return;
      hd = { id: e.pointerId, y0: e.clientY, z: zoomNow(), k0: kOf(cur()), k: null, moved: false };
      try { h.setPointerCapture(e.pointerId); } catch (x) {} h.classList.add('pressed'); scr().classList.add('lke-sizing'); });
    h.addEventListener('pointermove', e => { if (!hd || e.pointerId !== hd.id) return; const dy = (e.clientY - hd.y0) / hd.z; if (!hd.moved && Math.abs(dy) < 3) return; hd.moved = true;
      hd.k = clamp(hd.k0 + dy / 220, K_MIN, K_MAX);   /* 220 px de arrasto = +1,0; para BAIXO aumenta (a hora cresce em altura depois da largura máxima) */
      preview(hd.k); });
    const end = cancel => { if (!hd) return; const d = hd; hd = null; h.classList.remove('pressed'); scr().classList.remove('lke-sizing'); swallow();
      if (cancel || !d.moved || d.k == null) { preview(null); return; }
      up({ clockScale: Math.round(d.k * 1000) / 1000 }); preview(null); snd('click'); };
    h.addEventListener('pointerup', () => end(false)); h.addEventListener('pointercancel', () => end(true));
    h.addEventListener('lostpointercapture', () => { if (hd) end(false); });
  }
  function mountHandle() { const lk = lockEl(), wrap = lk && lk.querySelector('.lock-clockwrap'); if (!wrap) return;
    if (!handleEl) {
      /* "⌟" do PearOS 27: um arco grosso, na cor da hora, concêntrico com o canto da moldura (raio 22 + 4 de folga) e com as pontas
         redondas; um traço fino claro por cima faz o brilho do vidro (sem filter). A caixa (44) é maior do que o desenho: alvo de toque. */
      handleEl = UI.el(`<div class="lke-handle" role="slider" aria-label="${esc(T('Tamanho'))}"><svg viewBox="0 0 44 44" aria-hidden="true"><path class="lke-ha" d="M34 3V8A26 26 0 0 1 8 34H3"/><path class="lke-hb" d="M34 3V8A26 26 0 0 1 8 34H3"/></svg></div>`);
      bindHandle(handleEl); }
    if (handleEl.parentNode !== wrap) wrap.appendChild(handleEl); }

  /* ================= LINHA DE BAIXO DO EDITOR ================= */
  /* vive DENTRO do #lock (o cartão): escala e anda com ele, no telemóvel e no Fold, sem contas de posição. Os toques são tratados
     pelo ouvinte em captura da window (a captura da galeria no #lock engole tudo o que está dentro do cartão). */
  function buildRow() {
    /* o sinal de recorte do "Pinch to Crop" (captura 3): o Icons não tem o glifo */
    row = UI.el(`<div class="lke-row"><div class="lke-crophint"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 2v16h16"/><path d="M2 6h16v16"/></svg><span></span></div><div class="lke-thumb" role="button"></div><div class="lke-style"><span class="lke-sl"></span><div class="lke-dots">${STYLES.map((s, i) => `<i data-i="${i}"></i>`).join('')}</div></div><div class="lke-more lg27 clear int" role="button">${g('more', 22)}</div></div>`);
    thumbEl = row.querySelector('.lke-thumb'); styleEl = row.querySelector('.lke-style'); moreEl = row.querySelector('.lke-more'); hintEl = row.querySelector('.lke-crophint');
    relabel();
    [thumbEl, moreEl].forEach(stopDown);   /* a cápsula do estilo não: um deslize a começar nela muda o estilo (swDown) */
  }
  function relabel() { if (!row) return; thumbEl.setAttribute('aria-label', T('Mudar fundo')); moreEl.setAttribute('aria-label', T('Mais opções')); hintEl.lastElementChild.textContent = T('Arrasta para enquadrar'); paintStyle(); }
  const styleIdx = ls => { const c = ls && ls.custom; const i = STYLES.findIndex(s => s[0] === (c && c.style)); return i < 0 ? 0 : i; };
  const styleOn = ls => !!(ls && ls.custom && ls.custom.url && !(window.WallKinds && WallKinds.isKind && WallKinds.isKind(ls.custom)));
  function paintRow() { if (!row) return; const x = X(), ls = cur(); if (!ls) return;
    try { if (x && x.paintBg && x.bgOf && x.lockSrc) { x.paintBg(thumbEl, x.bgOf(x.lockSrc(ls))); if (x.paintCrop) x.paintCrop(thumbEl, ls.custom, 1, 1); } } catch (e) {}
    if (styleOn(ls)) loadAR(ls.custom.url);
    paintStyle(); }
  function paintStyle(dir) { if (!row) return; const ls = cur(), on = styleOn(ls), i = styleIdx(ls);
    styleEl.classList.toggle('on', on); if (!on) return;
    const lbl = styleEl.querySelector('.lke-sl'); lbl.textContent = T(STYLES[i][1]);
    [...styleEl.querySelectorAll('.lke-dots i')].forEach((d, k) => d.classList.toggle('on', k === i));
    if (dir) { lbl.classList.remove('lke-inl', 'lke-inr'); void lbl.offsetWidth; lbl.classList.add(dir > 0 ? 'lke-inr' : 'lke-inl'); clearTimeout(lbl._t); lbl._t = setTimeout(() => lbl.classList.remove('lke-inl', 'lke-inr'), 450); } }
  function setStyle(i, dir) { const ls = cur(); if (!styleOn(ls)) return; i = clamp(i, 0, STYLES.length - 1); if (i === styleIdx(ls)) return;
    const c = Object.assign({}, ls.custom); if (STYLES[i][0] === 'natural') delete c.style; else c.style = STYLES[i][0];   /* natural = sem a chave (o objeto gravado fica igual ao de sempre) */
    snd('click'); up({ custom: c }); paintStyle(dir || (i > styleIdx(ls) ? 1 : -1)); }
  function changeWallpaper() { const x = X(); if (!x || !x.wallpaperGallery) return; snd('click');
    x.wallpaperGallery(patch => { if (!patch || !isEdit()) return; up({ wallpaper: patch.wallpaper != null ? patch.wallpaper : null, custom: patch.custom || null }); paintRow(); cropHint(); }, { title: 'Mudar fundo' }); }
  async function moreMenu() { const ls = cur(); if (!ls) return; snd('click');
    const v = await UI.actionSheet({ title: T('Mais opções'), buttons: [{ label: T('Alinhamento'), value: 'align' }, { label: T('Posição'), value: 'pos' }, { label: T('Repor relógio'), value: 'reset', danger: true }], cancel: T('Cancelar') });
    if (!v || !isEdit()) return;
    if (v === 'align') { const a = await UI.actionSheet({ title: T('Alinhamento'), buttons: [['left', 'Esquerda'], ['center', 'Centro'], ['right', 'Direita']].map(([id, l]) => ({ label: T(l), value: id, bold: (cur().clockAlign || 'center') === id })), cancel: T('Cancelar') }); if (a && isEdit()) up({ clockAlign: a }); return; }
    if (v === 'pos') { const p = await UI.actionSheet({ title: T('Posição'), buttons: [['top', 'Em cima'], ['middle', 'Ao meio']].map(([id, l]) => ({ label: T(l), value: id, bold: (cur().clockPos || 'top') === id })), cancel: T('Cancelar') }); if (p && isEdit()) up({ clockPos: p }); return; }
    if (v === 'reset') up({ clockScale: null, clockSize: 'normal', clockNumerals: 'latn',   /* clockSize também: com clockScale null o tamanho sai do clockSize antigo (um "large" de 1.3 voltava a 1.14) */ clockFont: 'default', clockWght: null, clockWeight: 'regular', clockColor: '#FFFFFF', clockStyle: 'glass', clockAlign: 'center', clockPos: 'top' });
  }

  /* ================= ENQUADRAR A FOTO (o "Pinch to Crop" da captura 3) =================
     No CEF não há beliscar: com o rato arrasta-se no fundo do cartão para mover a foto e a roda faz zoom (1× a 2,5×). Fica em
     custom.crop = { x, y, s, a } (WallKinds.cropOf): nunca se muda o objeto em uso, updateCur grava um custom NOVO - é isso que deixa o
     Cancelar repor tudo (o editSnap guarda a referência do antigo). Enquanto dura o gesto só mudam as variáveis do cartão e a miniatura;
     o estado grava-se ao largar (a roda 280 ms depois do último passo). Fundo em posição de origem = sem a chave crop.
     Arrastar para enquadrar e deslizar para mudar de estilo começam no mesmo sítio: arrastar só move a foto num eixo em que ela tenha
     folga (foto mais comprida do que o ecrã, ou com zoom); sem folga, o deslize horizontal continua a mudar o estilo como sempre. Na
     cápsula "Natural" é sempre o estilo. */
  const AR = new Map();   /* url → largura/altura (a imagem só se pede uma vez) */
  function loadAR(url) { if (!url || AR.has(url)) return; AR.set(url, 0); const i = new Image(); i.onload = () => { if (i.naturalWidth && i.naturalHeight) AR.set(url, i.naturalWidth / i.naturalHeight); }; i.src = url; }
  const boxAR = () => ((window.System && +System.SW) || 440) / 956;
  const cropNow = ls => { const c = ls && ls.custom, v = window.WallKinds && WallKinds.cropOf ? WallKinds.cropOf(c) : null, base = v || { x: .5, y: .5, s: 1, a: 0 }; return { x: base.x, y: base.y, s: base.s, a: base.a || (c && AR.get(c.url)) || 0 }; };
  /* quanto a imagem passa da caixa, em larguras/alturas da caixa, nos dois eixos (o que o background-position em % percorre de 0 a 100) */
  const slackOf = k => { const A = boxAR(), a = k.a || A, wide = a > A; return { x: Math.max(0, (wide ? k.s * a / A : k.s) - 1), y: Math.max(0, (wide ? k.s : k.s * A / a) - 1) }; };
  const SLACK_MIN = .004;
  function liveK(k) { const x = X(), ls = cur(); if (!x || !ls || !ls.custom || !x.cropBox) return; const c = Object.assign({}, ls.custom, { crop: k });
    if (x.liveCrop) x.liveCrop(x.cropBox(c)); if (x.paintCrop) x.paintCrop(thumbEl, c, 1, 1); }
  function commitCrop(k) { const ls = cur(); if (!ls || !ls.custom || !styleOn(ls)) return; const r = v => Math.round(v * 1000) / 1000, c = Object.assign({}, ls.custom);
    if (k.s <= 1.001 && Math.abs(k.x - .5) < .002 && Math.abs(k.y - .5) < .002) delete c.crop;
    else { c.crop = { x: r(k.x), y: r(k.y), s: r(k.s) }; if (k.a) c.crop.a = r(k.a); }
    up({ custom: c }); paintRow(); }
  const flushWheel = () => { if (!wheelT) return; clearTimeout(wheelT); wheelT = 0; const k = cropLive; cropLive = null; if (k && isEdit()) commitCrop(k); };
  function onWheel(e) { if (!isEdit() || hd || sw || openSh.fc || openSh.aw || openSh.ct) return; const ls = cur(); if (!styleOn(ls)) return;
    e.preventDefault(); e.stopPropagation(); const k = cropLive || cropNow(ls), s = clamp(k.s * Math.exp(-e.deltaY * .0016), 1, (window.WallKinds && WallKinds.CROP_S) || 2.5);
    cropLive = Object.assign({}, k, { s }); liveK(cropLive); hideHint(); clearTimeout(wheelT); wheelT = setTimeout(flushWheel, 280); }
  function hideHint() { clearTimeout(hintT); if (hintEl) hintEl.classList.remove('on'); }
  /* a dica ao abrir o editor num fundo de imagem: 2 s ao centro do cartão */
  function cropHint() { hideHint(); if (!hintEl || !styleOn(cur())) return; hintEl.classList.add('on'); hintT = setTimeout(hideHint, 2000); }

  /* ---------- no cartão: arrastar = enquadrar (com folga) ou deslizar = estilo seguinte/anterior (só fundos de imagem) ---------- */
  function swDown(e) { if (!isEdit() || sw || hd || (e.button && e.pointerType === 'mouse')) return;
    if (openSh.fc || openSh.aw || openSh.ct) return;   /* com uma folha aberta o cartão serve para escolher o que editar */
    const t = e.target, on = s => !!(t.closest && t.closest(s)), pager = on('.lke-style');
    if (on('.lke-handle,.ls-btn,.lkw-rm,.ls-rm,.lsg-focus') || (on('.lke-row') && !pager)) return;
    const ls = cur(); if (!styleOn(ls)) return; flushWheel();
    /* a foto só se agarra no fundo: quem começa na moldura da hora, nos widgets ou na cápsula continua a poder deslizar o estilo */
    const k0 = cropNow(ls); sw = { id: e.pointerId, x0: e.clientX, y0: e.clientY, z: zoomNow(), axis: null, dx: 0, pan: false, free: !pager && !on('.lock-clockwrap,.lock-widgets,.lock-shortcuts'), k0, k: null, sl: slackOf(k0), r: vr(lockEl()) };
    window.addEventListener('pointermove', swMove, true); window.addEventListener('pointerup', swUp, true); window.addEventListener('pointercancel', swCancel, true); }
  function swMove(e) { if (!sw || e.pointerId !== sw.id) return; const dx = (e.clientX - sw.x0) / sw.z, dy = (e.clientY - sw.y0) / sw.z; sw.dx = dx;
    if (!sw.axis && (Math.abs(dx) > 10 || Math.abs(dy) > 10)) { sw.axis = Math.abs(dx) > Math.abs(dy) * 1.2 ? 'x' : 'y'; sw.pan = sw.free && sw.sl[sw.axis] > SLACK_MIN; if (sw.pan) hideHint(); }
    if (sw.pan) { /* a foto segue o rato: arrastar para a direita mostra o que está à esquerda. Em frações do cartão (o clientX e o vrect são px reais) */
      const k = Object.assign({}, sw.k0), ax = (e.clientX - sw.x0) / Math.max(1, sw.r.width), ay = (e.clientY - sw.y0) / Math.max(1, sw.r.height);
      if (sw.sl.x > SLACK_MIN) k.x = clamp(sw.k0.x - ax / sw.sl.x, 0, 1); if (sw.sl.y > SLACK_MIN) k.y = clamp(sw.k0.y - ay / sw.sl.y, 0, 1);
      sw.k = k; liveK(k); return; }
    if (sw.axis === 'x' && styleEl) styleEl.style.transform = `translateX(calc(-50% + ${Math.max(-40, Math.min(40, dx * .25)).toFixed(1)}px))`; }
  function swEnd() { window.removeEventListener('pointermove', swMove, true); window.removeEventListener('pointerup', swUp, true); window.removeEventListener('pointercancel', swCancel, true); if (styleEl) styleEl.style.transform = ''; sw = null; }
  /* cancelado a meio (o ponteiro saiu do jogo): o cartão volta ao que está gravado */
  function swCancel() { const d = sw; swEnd(); if (d && d.pan) { const x = X(), ls = cur(); if (x && x.liveCrop && x.cropBox && ls) x.liveCrop(x.cropBox(ls.custom)); paintRow(); } }
  function swUp(e) { if (!sw || e.pointerId !== sw.id) return; const d = sw; swEnd();
    if (d.pan) { swallow(); if (d.k) commitCrop(d.k); return; }
    if (d.axis === 'x') { swallow(); if (Math.abs(d.dx) > 40) setStyle(styleIdx(cur()) + (d.dx < 0 ? 1 : -1), d.dx < 0 ? 1 : -1); } }

  /* ---------- o clique em CAPTURA na window (antes da galeria): engolir depois de um arrasto + os botões da linha de baixo ---------- */
  function onWinClick(e) {
    flushWheel();   /* um Concluído logo a seguir à roda não perde o zoom; num Cancelar o editSnap repõe na mesma */
    if (swallowUntil && performance.now() < swallowUntil) { swallowUntil = 0; e.stopPropagation(); e.preventDefault(); return; }
    swallowUntil = 0;
    const t = e.target; if (!t || !t.closest) return;
    if (t.closest('.lke-handle')) { e.stopPropagation(); e.preventDefault(); return; }
    const r = t.closest('.lke-row'); if (!r) return;
    e.stopPropagation(); e.preventDefault(); if (!isEdit()) return;
    if (t.closest('.lke-thumb')) changeWallpaper();
    else if (t.closest('.lke-more')) moreMenu();
    else if (t.closest('.lke-style')) { const d = t.closest('.lke-dots i'); const i = d ? +d.dataset.i : styleIdx(cur()) + 1; setStyle(i >= STYLES.length ? 0 : i); }
  }

  /* ================= ENTRADA / SAÍDA ================= */
  function init(r) { if (root || isAnd()) return; root = r || document.querySelector('.lsg-root'); if (!row) buildRow();
    window.addEventListener('click', onWinClick, true);
    const lk = lockEl(); if (lk) { lk.addEventListener('pointerdown', swDown); lk.addEventListener('wheel', onWheel, { passive: false }); }
    if (window.L && L.onChange) L.onChange(() => { relabel(); if (handleEl) handleEl.setAttribute('aria-label', T('Tamanho')); });
    if (window.Bridge && Bridge.on) {
      Bridge.on('wallpaper:changed', () => { if (isEdit()) paintRow(); });
      Bridge.on('wallkind:ready', () => { if (isEdit()) paintRow(); pickRepaint.forEach(f => { try { f(); } catch (e) {} }); });
      Bridge.on('fold:state', () => setTimeout(glassAll, 450));
      /* o Lock reconstrói o #lock ao trocar de sistema: a pega e a linha voltam a ser montadas se o editor estiver aberto */
      Bridge.on('os:changed', () => { if (isAnd()) { onExitEdit(); return; } if (isEdit()) setTimeout(onEnterEdit, 60); });
    }
  }
  function onEnterEdit() { if (isAnd()) return; if (!root) init(); const lk = lockEl(); if (!lk) return;
    mountHandle(); if (!row) buildRow(); if (row.parentNode !== lk) lk.appendChild(row);
    lk.classList.add('lke-on'); paintRow(); sweep(); cropHint(); }
  function onExitEdit() { if (hd) { hd = null; preview(null); } if (sw) swEnd(); clearTimeout(wheelT); wheelT = 0; cropLive = null; hideHint(); closeMine();
    if (handleEl && handleEl.parentNode) handleEl.parentNode.removeChild(handleEl);
    if (row && row.parentNode) row.parentNode.removeChild(row);
    const lk = lockEl(); if (lk) lk.classList.remove('lke-on'); const s = scr(); if (s) s.classList.remove('lke-sizing', 'lke-sh-fc', 'lke-sh-aw', 'lke-sh-ct'); }

  /* ================= "FONTE E COR" - cartão de vidro flutuante (captura 4) =================
     Cabeçalho: globo (sistema de numeração) · título · X. Depois, por esta ordem e nada mais: fontes ("12" numa fila que rola, a
     escolhida com o contorno azul), peso (só nas fontes variáveis), cores (fila de bolas, a escolhida com aro; a última é o arco-
     íris), matiz (só com o arco-íris), tom da cor escolhida, e "Vidro | Sólido". Tudo ao vivo no cartão do ecrã por cima: os
     toques gravam logo (updateCur), as barras escrevem só as variáveis CSS e gravam ao largar. */
  const fontsT = () => { const x = X(); return (x && x.FONTS) || (window.LockGallery && LockGallery.FONTS) || []; };
  const fontOf = id => { const x = X(); if (x && x.fontOf) return x.fontOf(id); const F = fontsT(); return F.find(f => f[0] === id) || F[0] || ['default', 'Padrão', '', [300, 700], 600, 1]; };
  const wghtOf = ls => { const x = X(); if (x && x.wghtOf) return x.wghtOf(ls); const w = Math.round(+ls.clockWght); if (ls.clockWght != null && w >= 100 && w <= 900) return w; return fontOf(ls.clockFont)[4] || 600; };
  const NUMS = () => (window.Lock && Array.isArray(Lock.NUMERALS) && Lock.NUMERALS.length) ? Lock.NUMERALS : null;
  /* "12" nos algarismos do sistema escolhido (adenda 8): o 1 e o 2 da tabela do Lock */
  const twelve = id => { try { if (window.Lock && Lock.clockText) return Lock.clockText('12', id); } catch (e) {} const r = (NUMS() || []).find(n => n[0] === id); if (!r) return '12'; const d = Array.from(String(r[2] || '')); return (d[1] || '1') + (d[2] || '2'); };
  /* qual das bolas está escolhida: a cor exata; senão a lembrada para este ecrã se ainda for da mesma família; senão brancos/
     cinzentos → branco; senão a de matiz mais perto (até 12°); senão é cor própria (arco-íris) */
  const swMem = {};
  function swatchOf(ls) { const c = String(ls.clockColor || '#FFFFFF').toUpperCase(); const ex = SWATCHES.indexOf(c); if (ex > -1) return { i: ex };
    const achro = satOf(c) < ACHRO, [h] = hexHT(c), m = swMem[ls.id];
    const fam = i => { const s = SWATCHES[i], a2 = satOf(s) < ACHRO; if (a2 || achro) return a2 && achro; const d = Math.abs(((hexHT(s)[0] - h + 540) % 360) - 180); return d <= 12; };
    if (m && m.i >= 0 && fam(m.i)) return { i: m.i };
    if (m && m.i === -1) return { i: -1, H: m.H };
    if (achro) return { i: greyT(c) > .18 ? SWATCHES.length - 1 : 0 };
    let best = -1, bd = 999; SWATCHES.forEach((s, i) => { if (satOf(s) < ACHRO) return; const d = Math.abs(((hexHT(s)[0] - h + 540) % 360) - 180); if (d < bd) { bd = d; best = i; } });
    return bd <= 12 ? { i: best } : { i: -1, H: h }; }

  function editClock() { if (isAnd() || !isEdit() || !X()) return; const x = X();
    const body = UI.el(`<div class="lsg-panel lke-fcb">
      <div class="lke-fonts"></div>
      <div class="lke-wt"><div class="lke-bar lke-wbar"><b class="lke-tr"></b><i></i></div></div>
      <div class="lke-hr"></div>
      <div class="lke-sw"></div>
      <div class="lke-hue"><div class="lke-bar lke-hbar"><b class="lke-tr"></b><i></i></div></div>
      <div class="lke-tone"><div class="lke-bar lke-tbar"><b class="lke-tr"></b><i></i></div></div>
      <div class="lke-segw"><div class="lke-seg lg27 clear lg27-group"><div data-v="glass"></div><div data-v="solid"></div></div></div>
    </div>`);
    const fRow = body.querySelector('.lke-fonts'), wRow = body.querySelector('.lke-wt'), wBar = body.querySelector('.lke-wbar'), sRow = body.querySelector('.lke-sw'),
      hRow = body.querySelector('.lke-hue'), hBar = body.querySelector('.lke-hbar'), tRow = body.querySelector('.lke-tone'), tBar = body.querySelector('.lke-tbar'), seg = body.querySelector('.lke-seg');
    [fRow, sRow].forEach(stopDown);
    /* (A) fontes: uma célula por fonte; o nome só no aria-label (como na captura); estilos fixos da tabela FONTS (nada vem do jogador) */
    const fcells = fontsT().map(f => { const c = UI.el(`<div class="lke-f" data-f="${esc(f[0])}" role="button" aria-label="${esc(T(f[1]))}"><b data-noi18n>12</b></div>`); c.firstElementChild.style.cssText = `${f[2]};font-weight:${f[4]}`;
      c.onclick = e => { e.stopPropagation(); snd('click'); up({ clockFont: f[0], clockWght: null, clockWeight: 'regular' }); paintFonts(); paintW(); later(); }; fRow.appendChild(c); return c; });
    const paintFonts = () => { const ls = cur(); if (!ls) return; const F = fontOf(ls.clockFont), id = F[0] === 'thin' ? 'default' : F[0], tw = twelve(ls.clockNumerals || 'latn');
      fcells.forEach(c => { c.classList.toggle('on', c.dataset.f === id); c.firstElementChild.textContent = tw; }); };
    /* (B) peso: só nas fontes variáveis (Bahnschrift, Inter, Outfit); senão a linha fecha (altura 0) e o cartão encolhe */
    let wNow = 600; const rng = () => { const ls = cur(); return ls ? fontOf(ls.clockFont)[3] : null; };
    const paintW = () => { const ls = cur(), R = rng(); wRow.classList.toggle('lke-off', !R); if (!R || !ls) return; wNow = clamp(wghtOf(ls), R[0], R[1]); knobAt(wBar, (wNow - R[0]) / (R[1] - R[0])); };
    const liveW = w => { document.body.dataset.clockwght = '1'; document.documentElement.style.setProperty('--clock-wght', String(w)); };
    slide(wBar, v => { const R = rng(); if (!R) return; wNow = Math.round(R[0] + v * (R[1] - R[0])); knobAt(wBar, v); liveW(wNow); },
      v => { const R = rng(); if (!R) return; if (v == null) { reapply(); paintW(); return; } up({ clockWght: wNow, clockWeight: wNow <= 350 ? 'light' : wNow >= 700 ? 'bold' : 'regular' }); });
    /* (C) cores + (D) tom + matiz do arco-íris */
    let sel = { i: 0 }, H = 0, Tn = .5;
    /* 1.5.0: a primeira bola (branco de origem) é "Automático": branco sobre fundos escuros, tinta escura sobre um topo claro (lock.js
       clock-auto + glass27.css). Grava o mesmo #FFFFFF de sempre, por isso as contas existentes já estão em automático. */
    const swEls = SWATCHES.map((h, i) => { const auto = i === 0 && h === '#FFFFFF'; const d = UI.el(`<div class="lke-c${auto ? ' lke-auto' : ''}" data-i="${i}" role="button" aria-label="${esc(auto ? T('Automático') : h)}"><i></i></div>`); d.firstElementChild.style.background = auto ? 'linear-gradient(135deg,#FFFFFF 0%,#FFFFFF 50%,#1E1E22 50%,#1E1E22 100%)' : h; d.style.setProperty('--sw', h);
      d.onclick = e => { e.stopPropagation(); snd('click'); sel = { i }; const ls = cur(); if (ls) swMem[ls.id] = { i }; up({ clockColor: h }); seedTone(h); paintSel(); later(); }; sRow.appendChild(d); return d; });
    const rb = UI.el(`<div class="lke-c lke-rb" role="button" aria-label="${esc(T('Cor'))}"><i></i></div>`); sRow.appendChild(rb);
    const achroSel = () => sel.i >= 0 && satOf(SWATCHES[sel.i]) < ACHRO;
    const colorAt = t => achroSel() ? greyHex(t) : htHex(H, t);
    const seedTone = hex => { if (achroSel()) { Tn = greyT(hex); return; } const ht = hexHT(hex); if (sel.i >= 0) H = hexHT(SWATCHES[sel.i])[0]; else H = ht[0]; Tn = ht[1]; };
    const paintTone = () => { tBar.querySelector('.lke-tr').style.backgroundImage = achroSel() ? `linear-gradient(90deg,#FFFFFF,${greyHex(.5)},${greyHex(1)})` : `linear-gradient(90deg,#FFFFFF,${htHex(H, .5)} 50%,${htHex(H, 1)})`;
      knobAt(tBar, Tn); const kc = colorAt(Tn); tBar.querySelector('i').style.background = kc;
      knobAt(hBar, H / 360); hBar.querySelector('i').style.background = hexOf(...pureOf(H)); rb.style.setProperty('--sw', sel.i < 0 ? kc : 'rgba(128,128,128,.6)'); };
    const paintSel = () => { swEls.forEach((d, i) => d.classList.toggle('on', i === sel.i)); rb.classList.toggle('on', sel.i < 0); hRow.classList.toggle('on', sel.i < 0); paintTone(); };
    rb.onclick = e => { e.stopPropagation(); snd('click'); const ls = cur(); if (sel.i < 0) return; const [h0] = hexHT(ls ? ls.clockColor : '#FFFFFF'); sel = { i: -1 }; H = satOf(ls && ls.clockColor) < ACHRO ? 210 : h0; Tn = .5; if (ls) swMem[ls.id] = { i: -1, H }; paintSel(); later(); };
    const commitC = () => { const c = colorAt(Tn); const ls = cur(); if (ls) swMem[ls.id] = { i: sel.i, H }; up({ clockColor: c }); };
    slide(tBar, v => { Tn = v; paintTone(); liveColor(colorAt(Tn)); }, v => { if (v == null) { reapply(); return; } Tn = v; commitC(); paintTone(); });
    slide(hBar, v => { H = v * 360; paintTone(); liveColor(colorAt(Tn)); }, v => { if (v == null) { reapply(); return; } H = v * 360; commitC(); paintTone(); });
    /* (E) Vidro | Sólido: os dois segmentos fundidos numa pílula (GlassContainer); 'outline' (ecrãs antigos) não acende nenhum */
    const segs = [...seg.children]; segs[0].textContent = T('Vidro'); segs[1].textContent = T('Sólido');
    segs.forEach(s => { s.setAttribute('role', 'button'); s.onclick = e => { e.stopPropagation(); snd('click'); up({ clockStyle: s.dataset.v }); paintSeg(); }; });
    stopDown(seg);
    const paintSeg = () => { const st = (cur() || {}).clockStyle || 'glass'; segs.forEach(s => s.classList.toggle('on', s.dataset.v === st)); };
    const sh = openWs('fc', T('Fonte e cor'), body); if (!sh) return;
    /* globo (à esquerda do título): sistema de numeração da hora. O pointerdown não pode chegar ao cabeçalho (é a pega de arrastar
       da folha, com captura do ponteiro: no CEF o clique nunca chegava ao botão) */
    const head = sh.el.querySelector('.sheet-head'); const tn = sh.el.classList.contains('lke-light') ? 'lt' : 'lg27-dk'; seg.classList.add(tn);
    if (head && NUMS()) { const gb = UI.el(`<div class="lke-globe lg27 clear int ${tn}" role="button" aria-label="${esc(T('Sistema de numeração'))}">${g('globe', 18)}</div>`); stopDown(gb);
      gb.onclick = async e => { e.stopPropagation(); snd('click'); const now = (cur() || {}).clockNumerals || 'latn';
        const v = await UI.actionSheet({ title: T('Sistema de numeração'), buttons: NUMS().map(([id, name, dg]) => ({ label: T(name) + '  ' + Array.from(String(dg || '')).slice(1, 3).join(''), value: id, bold: id === now })), cancel: T('Cancelar') });
        if (v && isEdit()) { up({ clockNumerals: v }); paintFonts(); } };
      head.insertBefore(gb, head.firstChild); }
    /* depois de mudar a altura do cartão (peso que aparece/some, matiz) a cópia do vidro volta a alinhar (o cartão cresce para cima) */
    const later = () => setTimeout(() => { if (sh.el.isConnected) glassPos(sh.el); }, 30);
    const ls0 = cur() || { id: '', clockColor: '#FFFFFF' }; sel = swatchOf(ls0); if (sel.i < 0) { H = sel.H != null ? sel.H : hexHT(ls0.clockColor)[0]; Tn = hexHT(ls0.clockColor)[1]; } else seedTone(ls0.clockColor || SWATCHES[sel.i]);
    paintFonts(); paintW(); paintSel(); paintSeg();
    fcRepaint = () => { paintFonts(); paintW(); paintSeg(); };
    /* a fonte escolhida à vista: a fila rola até ela (sem animação; o browser ignora fora de alcance) */
    /* (e a cor escolhida também: uma bola fora de vista - lavanda, cinzento, o arco-íris - fica visível na fila) */
    const reveal = (row, el) => { if (el && el.offsetLeft + el.offsetWidth > row.scrollLeft + row.clientWidth) row.scrollLeft = el.offsetLeft + el.offsetWidth - row.clientWidth + 18; };
    setTimeout(() => { reveal(fRow, fRow.querySelector('.lke-f.on')); reveal(sRow, sRow.querySelector('.lke-c.on')); knobAt(tBar, Tn); knobAt(hBar, H / 360); paintW(); }, 60);
    return sh; }

  /* ================= "ADICIONAR WIDGETS" (captura 5) ================= */
  function editWidgets() { if (isAnd() || !isEdit()) return; const x = X(), W = window.Lock && Lock.widgets; if (!x || !W) return;
    const all = (W.list() || []).filter(w => w && w.k);
    const newsId = () => { const w = all.find(z => z.k === 'news'); return w && w.app ? w.app : null; };
    const appOf = w => w.app || (w.k === 'news' ? null : WAPP[w.k]) || null;
    const body = UI.el('<div class="lsg-panel lsg-aw lke-awb"></div>');
    let q0 = '';
    body.appendChild(searchBox(T('Pesquisar widgets'), q => { q0 = norm(q); filter(); }));
    const tiles = [];
    const used = l => l.reduce((a, k) => a + W.slot(k), 0);
    const setW = l => { if (x.setWidgets) x.setWidgets(l); else up({ widgets: l.slice() }); paint(); };
    const tileOf = w => { const app = appOf(w), has = app && window.App && App.get(app);
      const t = UI.el(`<div class="lsg-aw-t lke-awt ${w.kind === 'r' ? 'r' : 'c'}" data-k="${esc(w.k)}" role="button" aria-label="${esc(T(w.name))}"><div class="lsg-aw-pv">${W.html(w.k)}</div>${has ? `<div class="lke-abadge">${Icons.tileBox(app, 'lke-abadge-t')}</div>` : ''}<i class="lsg-aw-ck">${g('check', 12)}</i></div>`);
      t._q = norm(T(w.name) + ' ' + w.name + ' ' + (has ? T(App.name(app)) : ''));
      t.onclick = e => { e.stopPropagation(); const now = W.fit((cur() || {}).widgets || []);
        if (now.includes(w.k)) { snd('click'); setW(now.filter(z => z !== w.k)); return; }
        if (used(now) + W.slot(w.k) > W.SLOTS) { tiles.filter(z => z.dataset.k === w.k).forEach(z => { z.classList.remove('shake'); void z.offsetWidth; z.classList.add('shake'); }); snd('error'); if (Date.now() - (editWidgets._t || 0) > 1900) { editWidgets._t = Date.now(); UI.toast(T('Sem espaço: retira um widget primeiro')); } return; }   /* um aviso de cada vez (toques seguidos empilhavam avisos iguais) */
        snd('click'); setW(now.concat(w.k)); };
      tiles.push(t); return t; };
    /* SUGESTÕES: a grelha de 4 colunas de sempre (redondo 1 lugar, retangular 2), com dados verdadeiros */
    const sg = UI.el(`<div class="lke-sec lke-sugg"><div class="lke-sect">${esc(T('Sugestões'))}</div><div class="lsg-aw-grid"></div></div>`); const grid = sg.lastElementChild;
    const order = SUGG.filter(k => all.some(w => w.k === k)).concat(all.map(w => w.k).filter(k => !SUGG.includes(k)));
    order.forEach(k => grid.appendChild(tileOf(all.find(w => w.k === k))));
    body.appendChild(sg);
    /* uma secção por app (o nome da app; a bateria chama-se "Bateria", como no PearOS), com os widgets dela numa fila */
    const groups = new Map(); all.forEach(w => { const a = appOf(w) || (w.k === 'news' ? (newsId() || '@news') : '@other'); if (!groups.has(a)) groups.set(a, []); groups.get(a).push(w); });
    const rank = a => { const i = APP_ORDER.indexOf(a === newsId() ? '@news' : a); return i < 0 ? 99 : i; };
    [...groups.keys()].sort((a, b) => rank(a) - rank(b)).forEach(a => { const ws = groups.get(a);
      const title = a === 'settings' ? T('Bateria') : a.charAt(0) === '@' ? T(ws[0].name) : T(window.App ? App.name(a) : a);
      const sec = UI.el(`<div class="lke-sec lke-asec" data-app="${esc(a)}"><div class="lke-sect">${esc(title)}</div><div class="lke-hrow"></div></div>`);
      ws.forEach(w => sec.lastElementChild.appendChild(tileOf(w))); stopDown(sec.lastElementChild); body.appendChild(sec); });
    body.appendChild(UI.el(`<div class="group-footer lsg-aw-foot">${esc(T('Os widgets ficam por baixo da hora, até 4 lugares. Toca num widget já posto para o retirar.'))}</div>`));
    const filter = () => { body.querySelectorAll('.lke-sec').forEach(sec => { let any = false; sec.querySelectorAll('.lke-awt').forEach(t => { const ok = !q0 || t._q.indexOf(q0) > -1; t.classList.toggle('lke-hide', !ok); if (ok) any = true; }); sec.classList.toggle('lke-hide', !any); }); };
    const paint = () => { const now = W.fit((cur() || {}).widgets || []), u = used(now); tiles.forEach(t => { const k = t.dataset.k, on = now.includes(k); t.classList.toggle('on', on); t.classList.toggle('full', !on && u + W.slot(k) > W.SLOTS); }); };
    const sh = openWs('aw', T('Adicionar widgets'), body); if (!sh) return;
    if (x.setAwPaint) x.setAwPaint(paint);   /* o "menos" no cartão (setWidgets da galeria) repinta estes quadrados */
    paint(); return sh; }

  /* ================= GALERIA DE CONTROLOS (captura 6) ================= */
  const ctlDef = k => { if (!window.Lock) return null; try { if (Lock.controlOf) return Lock.controlOf(k); } catch (e) {} return (Lock.CONTROLS && Lock.CONTROLS[k]) || null; };
  /* o miolo do círculo: o MESMO do botão do ecrã bloqueado (Lock.controlIcon: glifo, ou o ícone da app de um "app:<id>") */
  const ctlIcon = k => { try { if (window.Lock && Lock.controlIcon) return Lock.controlIcon(k, 'lke-cicon'); } catch (e) {} const d = ctlDef(k); if (!d) return ''; return d.appId ? Icons.tileBox(d.appId, 'lke-cicon') : glyph(d.icon, 22); };
  function editControls(side) { if (isAnd() || !isEdit() || !X() || !window.Lock) return; side = +side === 1 ? 1 : 0;
    const usable = k => { const d = ctlDef(k); return !!d && k !== 'none' && (!d.avail || d.avail()); };
    const order = (Array.isArray(Lock.CONTROL_TOP) ? Lock.CONTROL_TOP : Array.isArray(Lock.CONTROL_ORDER) ? Lock.CONTROL_ORDER : ['torch', 'camera', 'phone', 'calc', 'alarm', 'timer', 'notes', 'music']).filter(usable);
    const nowK = () => (((cur() || {}).controls) || ['torch', 'camera'])[side];
    const body = UI.el('<div class="lsg-panel lke-ctb"></div>');
    let q0 = ''; body.appendChild(searchBox(T('Pesquisar controlos'), q => { q0 = norm(q); filter(); }));
    let sh = null; const cells = [];
    const pick = k => { const ctl = (((cur() || {}).controls) || ['torch', 'camera']).slice(0, 2); while (ctl.length < 2) ctl.push('none'); ctl[side] = k; snd('click'); up({ controls: ctl }); paint(); setTimeout(() => { if (sh && sh.el.isConnected) sh.close(); }, 140); };
    const cell = (k, label, ic, sec) => { const c = UI.el(`<div class="lke-ctl" data-k="${esc(k)}" role="button" aria-label="${esc(label)}"><div class="lke-cc${k === 'none' ? ' lke-none' : ''}">${ic}<i class="lke-ck">${g('check', 11)}</i></div><span>${esc(label)}</span></div>`); c._q = norm(label + ' ' + k + ' ' + (sec || '')); c.onclick = e => { e.stopPropagation(); pick(k); }; cells.push(c); return c; };
    /* a lista do telemóvel (sem título, como na captura) + "Nenhum" no fim */
    const gTop = UI.el('<div class="lke-sec lke-csec"><div class="lke-cgrid"></div></div>');
    order.forEach(k => { const d = ctlDef(k); gTop.firstElementChild.appendChild(cell(k, T(d.label), ctlIcon(k))); });
    gTop.firstElementChild.appendChild(cell('none', T('Nenhum'), ''));
    body.appendChild(gTop);
    /* secções da captura 6 (Captura, Conectividade, Ecrã e brilho, Foco, Música ambiente): título pequeno com o selo + os círculos de vidro. O nome da
       secção conta para a pesquisa ("foco" mostra os três). Uma secção sem nada disponível não aparece (sem a app Música, a Música ambiente). */
    (Array.isArray(Lock.CONTROL_SECTIONS) ? Lock.CONTROL_SECTIONS : []).forEach(s => { const keys = s.keys.filter(usable); if (!keys.length) return; const title = T(s.title);
      const sec = UI.el(`<div class="lke-sec lke-csec lke-cs-${esc(s.id)}"><div class="lke-sect2"><span class="lke-sic">${g(s.icon, 14)}</span>${esc(title)}</div><div class="lke-cgrid"></div></div>`);
      keys.forEach(k => sec.lastElementChild.appendChild(cell(k, T(ctlDef(k).label), ctlIcon(k), title + ' ' + s.title))); body.appendChild(sec); });
    /* "Apps": abrir qualquer app instalada (controlo app:<id>; o botão do ecrã bloqueado mostra o ícone dela) */
    const ids = (window.App ? App.ids() : []).filter(id => !System.isInstalled || System.isInstalled(id)).sort((a, b) => T(App.name(a)).localeCompare(T(App.name(b))));
    if (ids.length && Lock.controlOf) { const sa = UI.el(`<div class="lke-sec lke-csec lke-capps"><div class="lke-sect2"><span class="lke-sic">${g('grid', 14)}</span>${esc(T('Apps'))}</div><div class="lke-cgrid"></div></div>`);
      ids.forEach(id => sa.lastElementChild.appendChild(cell('app:' + id, T(App.name(id)), ctlIcon('app:' + id)))); body.appendChild(sa); }
    /* Câmara, Fotos, Modo escuro e Não incomodar estão em cima e na secção deles: a pesquisar, cada chave aparece uma vez só */
    const filter = () => { const seen = new Set(); body.querySelectorAll('.lke-csec').forEach(sec => { let any = false; sec.querySelectorAll('.lke-ctl').forEach(c => { const ok = !q0 || (c._q.indexOf(q0) > -1 && !seen.has(c.dataset.k)); if (q0 && ok) seen.add(c.dataset.k); c.classList.toggle('lke-hide', !ok); if (ok) any = true; }); sec.classList.toggle('lke-hide', !any); }); };
    const paint = () => { const k = nowK(); cells.forEach(c => c.classList.toggle('on', c.dataset.k === k)); };
    sh = openWs('ct', side ? T('Controlo da direita') : T('Controlo da esquerda'), body, 'dark'); if (!sh) return;
    paint(); return sh; }
  /* o "menos" de um controlo: esse lado fica vazio (o "+" tracejado no cartão abre a galeria para ele) */
  function removeControl(side) { if (isAnd() || !isEdit()) return; side = +side === 1 ? 1 : 0; const ls = cur(); if (!ls) return;
    const ctl = (ls.controls || ['torch', 'camera']).slice(0, 2); while (ctl.length < 2) ctl.push('none'); if (ctl[side] === 'none') return; ctl[side] = 'none'; up({ controls: ctl }); }   /* o som do toque já o dá a galeria (quem chama) */

  /* ================= FOLHAS DOS FUNDOS NOVOS (abertas pelo seletor "Adicionar novo fundo") =================
     Folhas claras do sistema (escuras com body.dark), como o seletor. Cada uma recebe choose(patch) do seletor - fecha-se a si
     própria e chama choose, que fecha o seletor e cria/aplica o ecrã. Nada é gravado como data URL: só { kind, ... }. */
  const WK = () => window.WallKinds || null;
  const fmtNow = () => { const d = new Date(); return { hm: UI.fmtTime(d), dt: UI.fmtWdDayMon ? UI.fmtWdDayMon(d) : (UI.DIAS_C && UI.MESES ? `${UI.DIAS_C[d.getDay()]}, ${d.getDate()} ${UI.MESES[d.getMonth()].slice(0, 3)}` : '') }; };
  /* miniatura na proporção do ecrã com a hora por cima (as mesmas classes do seletor) - o fundo pinta-se pelo CSSOM */
  const wpTile = (name, cls) => { const n = fmtNow(); return UI.el(`<div class="lsg-wpi ${cls || ''}"><div class="lsg-wp"><div class="lsg-wp-t"><span>${esc(n.dt)}</span><b>${esc(n.hm)}</b></div></div>${name ? `<span class="lsg-wp-n">${esc(name)}</span>` : ''}</div>`); };
  const paintKind = (el, custom) => { const w = WK(); let v = ''; try { v = w && w.css ? w.css(custom) : ''; } catch (e) { v = ''; } if (el) el.style.backgroundImage = v || 'none'; };
  function pickSheet(title, body, foot) {
    const sh = UI.sheet({ title, right: T('Cancelar'), body, foot, cls: 'lsg-sheet lke-pick' });
    setTimeout(() => { if (sh.el.isConnected && !sh.el.classList.contains('closing')) sh.el.classList.add('in'); }, 80);   /* o rAF que mostra a folha nem sempre corre (CEF sem foco / headless) */
    return sh; }
  const useBtn = () => UI.el(`<div class="btn-p lke-use">${esc(T('Usar'))}</div>`);
  /* o sub-folha morre: as suas repinturas saem do conjunto */
  const onGone = (sh, f) => { pickRepaint.add(f); const mo = new MutationObserver(() => { if (!sh.el.isConnected || sh.el.classList.contains('closing')) { pickRepaint.delete(f); mo.disconnect(); } }); mo.observe(sh.el, { attributes: true, attributeFilter: ['class'] }); };
  const finish = (sh, choose, patch) => { if (sh) sh.close(); setTimeout(() => { try { choose(patch); } catch (e) { console.error('[apex_phone] LockEditor choose', e); } }, 0); };

  function pickEmoji(choose) { if (isAnd() || !WK() || typeof choose !== 'function') return;
    const w = WK(), presets = ((w.presets && w.presets.emoji) || []).map(p => Object.assign({ kind: 'emoji' }, p));
    const cat = (w.emojiCatalog ? w.emojiCatalog() : []) || [];
    const p0 = presets[0] || { kind: 'emoji', set: ['😀'], layout: 'grid', bg: '#FFD60A' };
    let st = { kind: 'emoji', set: (p0.set || ['😀']).slice(0, 6), layout: p0.layout || 'grid', bg: p0.bg || '#FFD60A' };
    const body = UI.el(`<div class="lsg-panel lke-pk lke-pk-emoji"><div class="lke-pk-top"><div class="lke-pk-pv"></div><div class="lke-pk-side"><div class="lke-picked" data-noi18n></div><div class="lke-pk-hint">${esc(T('Escolhe até 6 emojis'))}</div></div></div></div>`);
    const pv = wpTile('', 'lke-big'); body.querySelector('.lke-pk-pv').appendChild(pv); const picked = body.querySelector('.lke-picked');
    /* predefinidos */
    const ps = UI.el(`<div class="lsg-psec"><div class="lsg-prow"></div></div>`); const pTiles = presets.map(p => { const t = wpTile(''); t.onclick = e => { e.stopPropagation(); snd('click'); st = { kind: 'emoji', set: (p.set || []).slice(0, 6), layout: p.layout || 'grid', bg: p.bg || st.bg }; paint(); }; ps.firstElementChild.appendChild(t); return t; });
    if (presets.length) body.appendChild(ps);
    /* disposição + cor de fundo */
    const LAY = [['grid', 'Grelha'], ['rings', 'Anéis'], ['spiral', 'Espiral'], ['large', 'Grande']];
    const lay = UI.seg(LAY.map(l => T(l[1])), Math.max(0, LAY.findIndex(l => l[0] === st.layout)), i => { st.layout = LAY[i][0]; snd('click'); paint(); }); lay.classList.add('lke-pk-seg'); body.appendChild(lay);
    const cols = (((X() && X().COLORS) || [['#0A84FF'], ['#1C1C1E'], ['#30D158'], ['#FF375F'], ['#BF5AF2'], ['#FF9F0A'], ['#FFD60A'], ['#64D2FF'], ['#A2845E'], ['#8E8E93']]).map(c => c[0])).concat(['#FFFFFF', '#F2D7C9']);
    const cr = UI.el(`<div class="lke-pk-sec"><div class="lke-pk-t">${esc(T('Fundo'))}</div><div class="lke-pk-cols"></div></div>`); const cEls = cols.map(c => { const d = UI.el(`<div class="lke-pk-col" role="button" aria-label="${esc(c)}"><i></i></div>`); d.firstElementChild.style.background = c; d.onclick = e => { e.stopPropagation(); snd('click'); st.bg = c; paint(); }; cr.lastElementChild.appendChild(d); return d; });
    body.appendChild(cr);
    /* o catálogo, por grupos (células de 48 px; tocar põe/tira, até 6) */
    const cells = [];
    cat.forEach(gp => { const sec = UI.el(`<div class="lke-pk-sec"><div class="lke-pk-t">${esc(T(gp.name))}</div><div class="lke-emo" data-noi18n></div></div>`);
      (gp.list || []).forEach(em => { const c = UI.el(`<div class="lke-em" role="button"></div>`); c.textContent = em; c.dataset.e = em;
        c.onclick = e => { e.stopPropagation(); const i = st.set.indexOf(em); if (i > -1) { if (st.set.length > 1) st.set.splice(i, 1); } else { if (st.set.length >= 6) { c.classList.remove('shake'); void c.offsetWidth; c.classList.add('shake'); snd('error'); UI.toast(T('Escolhe até 6 emojis')); return; } st.set.push(em); } snd('click'); paint(); };
        sec.lastElementChild.appendChild(c); cells.push(c); });
      body.appendChild(sec); });
    const use = useBtn(); let sh = null;
    use.onclick = e => { e.stopPropagation(); if (!st.set.length) return; snd('click'); finish(sh, choose, { wallpaper: null, custom: { kind: 'emoji', set: st.set.slice(0, 6), layout: st.layout, bg: st.bg } }); };
    function paint() { paintKind(pv.firstElementChild, st); presets.forEach((p, i) => paintKind(pTiles[i].firstElementChild, p));
      picked.innerHTML = ''; st.set.forEach(em => { const b = document.createElement('span'); b.textContent = em; b.setAttribute('role', 'button'); b.onclick = e => { e.stopPropagation(); if (st.set.length > 1) { st.set.splice(st.set.indexOf(em), 1); snd('click'); paint(); } }; picked.appendChild(b); });
      cells.forEach(c => c.classList.toggle('on', st.set.includes(c.dataset.e))); cEls.forEach((d, i) => d.classList.toggle('on', cols[i].toUpperCase() === String(st.bg).toUpperCase()));
      [...lay.children].forEach((d, i) => d.classList.toggle('on', LAY[i][0] === st.layout)); use.classList.toggle('dis', !st.set.length); }
    sh = pickSheet(T('Emoji'), body, use); onGone(sh, paint); paint(); return sh; }

  function pickColor(choose) { if (isAnd() || !WK() || typeof choose !== 'function') return;
    const w = WK(), STY = (w.presets && w.presets.color) || ['vibrant', 'tone', 'deep', 'vapor', 'bright'];
    const NAMES = { vibrant: 'Vibrante', tone: 'Tonal', deep: 'Profunda', vapor: 'Vapor', bright: 'Brilhante' };   /* 'Tonal' e não 'Tom': "Tom" é um nome de contacto e o tradutor do DOM reescrevia-o em todo o lado */
    let hue = 210, style = STY[0];
    const body = UI.el(`<div class="lsg-panel lke-pk lke-pk-color"><div class="lke-pk-top c"><div class="lke-pk-pv"></div></div><div class="lke-pk-sec"><div class="lke-pk-hue lke-bar"><b class="lke-tr"></b><i></i></div></div><div class="lsg-psec"><div class="lsg-prow"></div></div></div>`);
    const pv = wpTile('', 'lke-big'); body.querySelector('.lke-pk-pv').appendChild(pv);
    const bar = body.querySelector('.lke-pk-hue'), prow = body.querySelector('.lsg-prow');
    const tiles = STY.map(s => { const t = wpTile(T(NAMES[s] || s)); t.dataset.s = s; t.onclick = e => { e.stopPropagation(); snd('click'); style = s; paint(); }; prow.appendChild(t); return t; });
    let raf = 0; const paint = () => { paintKind(pv.firstElementChild, { kind: 'color', hue: Math.round(hue), style }); tiles.forEach(t => { paintKind(t.firstElementChild, { kind: 'color', hue: Math.round(hue), style: t.dataset.s }); t.classList.toggle('on', t.dataset.s === style); }); knobAt(bar, hue / 360); bar.querySelector('i').style.background = hexOf(...pureOf(hue)); };
    /* a barra repinta 6 SVG: no máximo uma vez por frame */
    slide(bar, v => { hue = v * 360; if (raf) return; raf = requestAnimationFrame(() => { raf = 0; paint(); }); }, v => { if (v != null) hue = v * 360; paint(); });
    const use = useBtn(); let sh = null;
    use.onclick = e => { e.stopPropagation(); snd('click'); finish(sh, choose, { wallpaper: null, custom: { kind: 'color', hue: Math.round(hue), style } }); };
    sh = pickSheet(T('Cor'), body, use); onGone(sh, paint); paint(); setTimeout(() => knobAt(bar, hue / 360), 60); return sh; }

  function pickAstro(choose) { if (isAnd() || !WK() || typeof choose !== 'function') return;
    const w = WK(), BODIES = (w.presets && w.presets.astro) || ['earth', 'moon', 'mars', 'solar'];
    const NAMES = { earth: 'Terra', moon: 'Lua', mars: 'Marte', solar: 'Sistema solar' };
    const body = UI.el('<div class="lsg-panel lke-pk lke-pk-astro"><div class="lke-astro"></div></div>'); const gr = body.firstElementChild; let sh = null;
    const tiles = BODIES.map(b => { const t = wpTile(T(NAMES[b] || b)); t.onclick = e => { e.stopPropagation(); snd('click'); finish(sh, choose, { wallpaper: null, custom: { kind: 'astro', body: b } }); }; gr.appendChild(t); return t; });
    const paint = () => tiles.forEach((t, i) => paintKind(t.firstElementChild, { kind: 'astro', body: BODIES[i] }));
    sh = pickSheet(T('Astronomia'), body); onGone(sh, paint); paint(); return sh; }

  function pickShuffle(choose) { if (isAnd() || !WK() || typeof choose !== 'function') return;
    const w = WK(); const base = Object.assign({ kind: 'shuffle', from: 'all', every: 'hour', cur: null, at: 0 }, (w.presets && w.presets.shuffle) || {}, { kind: 'shuffle' });
    const FROM = [['all', 'Todas as fotos'], ['favorites', 'Favoritas']], EVERY = [['wake', 'Ao acordar'], ['hour', 'A cada hora'], ['day', 'Todos os dias']];
    let from = FROM.some(f => f[0] === base.from) ? base.from : 'all', every = EVERY.some(f => f[0] === base.every) ? base.every : 'hour', obj = null;
    const body = UI.el(`<div class="lsg-panel lke-pk lke-pk-shuffle"><div class="lke-pk-top c"><div class="lke-pk-pv"></div></div><div class="lke-pk-empty"></div></div>`);
    const pv = wpTile('', 'lke-big'); body.querySelector('.lke-pk-pv').appendChild(pv); const emp = body.querySelector('.lke-pk-empty');
    const s1 = UI.seg(FROM.map(f => T(f[1])), FROM.findIndex(f => f[0] === from), i => { from = FROM[i][0]; snd('click'); paint(); }); s1.classList.add('lke-pk-seg');
    const s2 = UI.seg(EVERY.map(f => T(f[1])), EVERY.findIndex(f => f[0] === every), i => { every = EVERY[i][0]; snd('click'); paint(); }); s2.classList.add('lke-pk-seg');
    body.appendChild(s1); body.appendChild(s2);
    const use = useBtn(); let sh = null;
    /* o objeto já avançado (cur = a primeira foto da escolha): é isso que vai para o ecrã - a pré-visualização mostra essa foto */
    function paint() { let o = Object.assign({}, base, { from, every, cur: null, at: 0 }); try { if (w.advance) o = w.advance(o) || o; } catch (e) {}
      let has = false; try { has = !!(w.resolve && w.resolve(o)); } catch (e) {} obj = has ? o : null;
      pv.style.display = has ? '' : 'none'; if (has) paintKind(pv.firstElementChild, o);
      emp.innerHTML = ''; if (!has) emp.appendChild(UI.empty('photo', T('Sem fotos')));
      use.classList.toggle('dis', !has); }
    use.onclick = e => { e.stopPropagation(); if (!obj) return; snd('click'); finish(sh, choose, { wallpaper: null, custom: obj }); };
    sh = pickSheet(T('Aleatórias'), body, use); onGone(sh, paint); paint();
    if (window.Photos && Photos.load && !(Photos.cache || []).length) Promise.resolve(Photos.load()).then(() => { if (sh.el.isConnected) paint(); }).catch(() => {});
    return sh; }

  /* API (contrato §6 + adenda). Todas as entradas saem cedo no Android (o editor da Nova UI fica como está). */
  return { init, onEnterEdit, onExitEdit, editClock, editWidgets, editControls, removeControl, pickEmoji, pickColor, pickAstro, pickShuffle, glassPos,
    closeSheets: closeMine, get open() { sweep(); return Object.keys(openSh).filter(k => !!openSh[k]); } };
})();
