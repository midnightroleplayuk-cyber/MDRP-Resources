/* ============================================================
   DRAG SCROLL: arrastar COM O RATO, como o dedo num ecra tatil
   No FiveM o telemovel usa-se com o rato, e o browser so faz scroll com a roda: carregar e
   arrastar uma lista nao a mexia (pedido do dono, 2026-10-01: "no scroll quero arrastar com o
   rato"). Um unico ouvinte em captura trata de TODAS as areas com scroll, nos dois eixos:
   · so para o rato (o toque real ja desliza sozinho);
   · o eixo decide-se depois de 6 px: arrastar na vertical mexe a area com scroll vertical mais
     proxima, na horizontal a horizontal (prateleiras, carrosseis, chips); um toque continua a
     ser um toque e um toque longo continua a abrir o menu;
   · durante o arrasto desliga o scroll-snap e a selecao de texto; no fim ha inercia e o snap volta;
   · o click que o browser dispara no fim de um arrasto e engolido (nao abre o que esta por baixo);
   · quem tem o seu proprio arrasto fica de fora: lista SKIP, classe .no-dragscroll, touch-action:none
     no caminho, ou um elemento que ja agarrou o ponteiro (setPointerCapture) no pointerdown dele
     (ecra principal, folhas, sliders, cartoes de deslizar, mapa...).
   ============================================================ */
window.DragScroll = (() => {
  /* #qp: o painel rapido do Android tem o seu proprio arrasto com o rato (scroll + fechar ao passar do fim) */
  const SKIP = '.sw-track, .no-dragscroll, input, textarea, select, [contenteditable], canvas, .cc-slider, .vol-hud, .mt-card, #kb, .gm-stage, .st-layer, .rcu-viewer, .nbanner, #qp';
  /* 12 px: os componentes com arrasto proprio agarram o ponteiro aos 8-10 px; decidindo depois deles, o
     capturedByOther ve-os sempre e este arrasto fica de fora */
  const THRESH = 12;
  let st = null, raf = 0, eatClickUntil = 0, finish = null;
  /* parar a inercia a meio (novo clique, roda) repoe o snap e a selecao, como se tivesse acabado */
  const stopInertia = () => { if (!raf) return; cancelAnimationFrame(raf); raf = 0; if (finish) { const f = finish; finish = null; f(); } };

  const zoom = () => (window.UI && UI.zoom) ? UI.zoom() : 1;
  const scrolls = (el, axis) => {
    if (!el || el.nodeType !== 1) return false;
    if (axis === 'x' ? el.scrollWidth <= el.clientWidth + 2 : el.scrollHeight <= el.clientHeight + 2) return false;
    const o = getComputedStyle(el)[axis === 'x' ? 'overflowX' : 'overflowY']; return o === 'auto' || o === 'scroll';
  };
  /* a area com scroll mais proxima em cada eixo, a subir a partir do alvo; um SKIP ou um touch-action:none no
     caminho (arrasto proprio) desliga tudo */
  function scrollersFrom(t) {
    let x = null, y = null;
    for (let n = t, i = 0; n && n.id !== 'screen' && i < 18; n = n.parentElement, i++) {
      if (n.nodeType !== 1) continue;
      if (n.matches(SKIP)) return null;
      if (!x && !y && getComputedStyle(n).touchAction === 'none') return null;
      if (!x && scrolls(n, 'x')) x = n;
      if (!y && scrolls(n, 'y')) y = n;
      if (x && y) break;
    }
    return (x || y) ? { x, y } : null;
  }
  /* alguem (o proprio elemento ou um antepassado ate a area) ja agarrou o ponteiro no pointerdown dele: o arrasto e dele */
  function capturedByOther(t, sc, id) {
    for (let n = t; n && n.nodeType === 1; n = n.parentElement) {
      try { if (n.hasPointerCapture && n.hasPointerCapture(id)) return true; } catch (e) {}
      if (n === sc) break;
    }
    return false;
  }

  /* dobraveis: a pega da aresta esquerda (.fold-grip, fora do ecra) e o arrasto da folha sao do system.js. Um clique fora do
     ecra para a inercia de uma lista (a folha ia rodar com ela a correr) e, com a folha a abrir/fechar, nada rola */
  const folding = () => !!(window.System && System.foldAnimating);
  function down(e) {
    if (e.pointerType !== 'mouse' || e.button !== 0) return;
    const t = e.target; if (!t || !t.closest) return;
    if (!t.closest('#screen')) { if (t.closest('.fold-grip')) stopInertia(); return; }
    stopInertia();
    if (folding()) return;
    const scs = scrollersFrom(t); if (!scs) return;
    st = { scs, t, id: e.pointerId, x: e.clientX, y: e.clientY, axis: null, sc: null, s0: 0, moved: false, lp: 0, lt: performance.now(), v: 0, snap: '' };
  }
  function move(e) {
    if (!st || e.pointerId !== st.id) return;
    const dx = e.clientX - st.x, dy = e.clientY - st.y;
    if (!st.moved) {
      if (Math.abs(dx) < THRESH && Math.abs(dy) < THRESH) return;
      if (folding()) { st = null; return; }   /* a folha começou a rodar entretanto: o arrasto não é deste */
      const axis = Math.abs(dx) > Math.abs(dy) ? 'x' : 'y';
      const sc = st.scs[axis];
      /* nada para mexer neste eixo, ou o alvo ja tem dono (arrasto proprio): fica tudo como estava */
      if (!sc || capturedByOther(st.t, sc, e.pointerId) || (e.target !== st.t && !sc.contains(e.target))) { st = null; return; }
      st.axis = axis; st.sc = sc; st.s0 = axis === 'x' ? sc.scrollLeft : sc.scrollTop; st.lp = axis === 'x' ? e.clientX : e.clientY;
      /* px do rato → px da PRÓPRIA área (o aparelho e, no PearPhone Fold, o zoom do conteúdo da app: UI.zoom(el)), lido uma vez */
      st.k = (window.UI && UI.vrect) ? UI.zoom(sc) || 1 : zoom();
      st.moved = true; st.snap = sc.style.scrollSnapType; sc.style.scrollSnapType = 'none'; sc.classList.add('ds-drag'); document.body.classList.add('ds-dragging');
      try { const s = window.getSelection && getSelection(); if (s && s.removeAllRanges) s.removeAllRanges(); } catch (x) {}
      try { sc.setPointerCapture(e.pointerId); } catch (x) {}
    }
    const k = st.k || 1, now = performance.now(), dt = Math.max(1, now - st.lt);
    const p = st.axis === 'x' ? e.clientX : e.clientY, d = st.axis === 'x' ? dx : dy;
    if (st.axis === 'x') st.sc.scrollLeft = st.s0 - d / k; else st.sc.scrollTop = st.s0 - d / k;
    st.v = st.v * .5 + (-(p - st.lp) / k / dt) * .5; st.lp = p; st.lt = now;
    e.preventDefault();
  }
  function up(e) {
    if (!st || e.pointerId !== st.id) return; const s = st; st = null;
    if (!s.moved) return;
    eatClickUntil = performance.now() + 80;
    const sc = s.sc, ax = s.axis; let v = performance.now() - s.lt > 90 ? 0 : s.v;   /* o rato parou antes de largar: sem inercia */
    const done = () => { raf = 0; finish = null; sc.style.scrollSnapType = s.snap || ''; sc.classList.remove('ds-drag'); document.body.classList.remove('ds-dragging'); };
    if (Math.abs(v) < .05) { done(); return; }
    finish = done;
    let last = performance.now();
    const get = () => ax === 'x' ? sc.scrollLeft : sc.scrollTop;
    const set = val => { if (ax === 'x') sc.scrollLeft = val; else sc.scrollTop = val; };
    const step = now => { const dt = Math.min(40, now - last); last = now; const before = get(); set(before + v * dt); v *= Math.pow(.994, dt);
      if (Math.abs(v) > .03 && get() !== before && sc.isConnected) raf = requestAnimationFrame(step); else done(); };
    raf = requestAnimationFrame(step);
  }
  function click(e) { if (performance.now() < eatClickUntil) { e.preventDefault(); e.stopPropagation(); eatClickUntil = 0; } }
  /* um clique na roda/outro sitio durante a inercia para-a (como o dedo a travar a lista) */
  function wheel() { stopInertia(); }

  document.addEventListener('pointerdown', down, true);
  document.addEventListener('pointermove', move, { capture: true, passive: false });
  document.addEventListener('pointerup', up, true);
  document.addEventListener('pointercancel', up, true);
  document.addEventListener('click', click, true);
  document.addEventListener('wheel', wheel, { capture: true, passive: true });
  /* a geometria do ecra mudou (abrir/fechar o dobravel, outro aparelho): a lista que estava a rolar ja nao e a mesma */
  const reset = () => { stopInertia(); if (st && st.moved && st.sc) { st.sc.style.scrollSnapType = st.snap || ''; st.sc.classList.remove('ds-drag'); document.body.classList.remove('ds-dragging'); } st = null; };
  if (window.Bridge && Bridge.on) { Bridge.on('fold:state', reset); Bridge.on('form:changed', reset); }
  return { get dragging() { return !!(st && st.moved); } };
})();
