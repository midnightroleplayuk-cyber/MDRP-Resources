/* ============================================================
   NOVA UI (Android): GAVETA DE APPS (window.Drawer) e PAINEL EDGE (window.EdgePanel)
   · So existem no telemovel NOVA: no PearOS os dois ficam por construir (init so ouve eventos) e nada muda.
   · A gaveta vive DENTRO do #home (por cima das paginas e da dock): abrir uma app a partir dela faz o mesmo zoom da
     home, e o ecra principal volta sempre fechado (como na One UI, o Inicio regressa a home e nao a gaveta).
   · Fundo: copia PRE-DESFOCADA do fundo (var(--wp-blur), System.makeBlur) + tinta. Nada de backdrop-filter nem filter
     (no CEF pintam preto) e so transform/opacity a mexer. Os icones entram como imagem (Icons.tileBox).
   · Os dados sao os de sempre: as mesmas apps instaladas, a mesma conta. A ordem e `state.drawerSort`.
   · Disposicao do ecra de apps do design system Nova UI 8.5: grelha de 4 colunas (as colunas da home), pontos das paginas e a
     barra de pesquisa em capsula EM BAIXO; ao pesquisar a barra sobe para o topo (so CSS: .adr.searching).
   ============================================================ */
window.Drawer = (() => {
  const COLS = 4, ROWS = 6, PULL_D = 420;
  /* largura de uma pagina da gaveta = o ecra (440; no NOVA dobravel 670 fechado, 1340 aberto). Aberto (spec_fold 4, 2026-10-03)
     cada pagina e UMA grelha de 8 x 5 a toda a largura (antes eram duas metades de 4 x 6 e com poucas apps a direita ficava
     quase vazia) */
  const two = () => !!(window.System && System.form === 'fold' && System.foldOpen);
  const pw = () => (window.System && System.form === 'fold' && System.SW) || 440;
  const per = () => two() ? 40 : COLS * ROWS;
  const g = (n, s) => Icons.g(n, s);
  const T = s => (window.L && L.t ? L.t(s) : s);
  const isA = () => !!(window.System && System.os === 'android');
  const zk = () => (UI.zoom ? UI.zoom() : 1);
  /* ordem "Personalizada" de origem (Nova UI): as apps do sistema primeiro, as instaladas depois pela ordem da instalacao */
  const ORDER = ['phone', 'messages', 'safari', 'camera', 'photos', 'appstore', 'settings', 'calendar', 'clock', 'calculator', 'notes', 'reminders', 'contacts', 'mail', 'maps', 'weather', 'music', 'wallet', 'aichat', 'facetime', 'findmy', 'home', 'garage', 'services', 'billing'];
  let root = null, bg = null, inner = null, sbar = null, input = null, track = null, dotsEl = null, res = null, moreBtn = null, sortBtn = null;
  let dirty = true, open = false, page = 0, npages = 1, searching = false, closeT = null, qT = null, ps = null, homeEls = null;
  /* a grelha foi feita para que aparelho/estado (telemovel, dobravel fechado ou aberto): outro obriga a refaze-la ao abrir */
  let geoKey = ''; const keyNow = () => !(window.System && System.form === 'fold') ? 'b' : System.foldOpen ? 'o' : 'c';

  function apps() {
    const inst = System.installed().filter(id => !(App.get(id) || {}).hidden);
    if (System.state.drawerSort === 'alpha') return inst.slice().sort((a, b) => App.name(a).localeCompare(App.name(b), 'pt'));
    return ORDER.filter(id => inst.includes(id)).concat(inst.filter(id => !ORDER.includes(id)));
  }

  /* ---------- construcao (uma vez, na primeira abertura) ---------- */
  function build() {
    if (root) return;
    /* Nova UI 9: a pesquisa e uma pilula flutuante EM BAIXO (One UI 7 a 9) e sobe ao topo ao pesquisar (oneui-home.css). A pilula
       da ordem (.adr-tools) continua no DOM mas fica escondida: a ordem escolhe-se nos tres pontos, como no aparelho */
    root = UI.el(`<div class="adr no-dragscroll"><div class="adr-bg"></div><div class="adr-in">
      <div class="adr-top"><div class="adr-sb"><div class="adr-lead">${g('search', 20)}</div><div class="adr-back">${g('arrowL', 20)}</div><input class="adr-q" type="text" spellcheck="false" autocomplete="off" maxlength="40"><div class="adr-x">${g('x', 16)}</div><div class="adr-more">${g('moreV', 22)}</div></div>
        <div class="adr-tools"><div class="adr-sort" role="button"><span></span>${g('chevD', 16)}</div></div></div>
      <div class="adr-pages"><div class="adr-track"></div></div><div class="adr-dots"></div><div class="adr-res"></div></div></div>`);
    bg = root.querySelector('.adr-bg'); inner = root.querySelector('.adr-in'); sbar = root.querySelector('.adr-sb'); input = root.querySelector('.adr-q');
    track = root.querySelector('.adr-track'); dotsEl = root.querySelector('.adr-dots'); res = root.querySelector('.adr-res'); moreBtn = root.querySelector('.adr-more'); sortBtn = root.querySelector('.adr-sort');
    input.placeholder = T('Pesquisar');
    sortBtn.addEventListener('pointerdown', e => e.stopPropagation());
    sortBtn.onclick = e => { e.stopPropagation(); Sound.play('click'); moreMenu(sortBtn); };
    paintSort();
    document.getElementById('home').appendChild(root);
    /* pesquisa: tocar na barra (ou escrever) entra no modo de pesquisa; a seta volta a grelha */
    sbar.addEventListener('click', e => { if (e.target.closest('.adr-more, .adr-x, .adr-back')) return; startSearch(); });
    input.addEventListener('focus', () => { if (!searching) startSearch(); });
    input.addEventListener('input', () => { sbar.classList.toggle('has', !!input.value); clearTimeout(qT); qT = setTimeout(runSearch, input.value ? 110 : 0); });
    root.querySelector('.adr-x').onclick = e => { e.stopPropagation(); input.value = ''; sbar.classList.remove('has'); runSearch(); try { input.focus(); } catch (err) {} };
    root.querySelector('.adr-back').onclick = e => { e.stopPropagation(); stopSearch(); };
    moreBtn.onclick = e => { e.stopPropagation(); moreMenu(); };
    bindGrid();
  }

  /* a pilula da ordem mostra a escolha atual (so o texto muda) */
  function paintSort() { if (!sortBtn) return; const t = T(System.state.drawerSort === 'alpha' ? 'Ordem alfabética' : 'Ordem personalizada'); const s = sortBtn.firstElementChild; if (s.textContent !== t) s.textContent = t; }

  /* ---------- grelha paginada (4 × 6) ---------- */
  function item(id) {
    const it = UI.el(`<div class="hi app adr-it" data-id="${UI.esc(id)}">${Icons.tileBox(id)}<div class="app-name"></div></div>`);
    it.lastElementChild.textContent = App.name(id); it._id = id; return it;
  }
  function renderGrid() {
    if (!root) return; const list = apps(), PER = per(), dual = two(); npages = Math.max(1, Math.ceil(list.length / PER)); page = Math.min(page, npages - 1);
    const frag = document.createDocumentFragment();
    for (let p = 0; p < npages; p++) { const pe = document.createElement('div'); pe.className = 'adr-page' + (dual ? ' two' : ''); list.slice(p * PER, (p + 1) * PER).forEach(id => pe.appendChild(item(id))); frag.appendChild(pe); }
    track.innerHTML = ''; track.appendChild(frag); geoKey = keyNow();
    dotsEl.innerHTML = npages > 1 ? Array.from({ length: npages }, () => '<span></span>').join('') : '';
    goPage(page, true); dirty = false; paintSort();
    /* emblemas: o System.badge pinta todos os .hi[data-id]; os icones da gaveta acabaram de nascer, por isso repete-se o que ja se sabe */
    const b = window.Home && Home.badges; if (b) Object.keys(b).forEach(id => { if (b[id]) { try { System.badge(id, b[id]); } catch (e) {} } });
  }
  function goPage(p, instant) {
    page = Math.max(0, Math.min(npages - 1, p));
    if (instant) track.classList.add('drag'); track.style.transform = `translate3d(${-page * pw()}px,0,0)`; if (instant) setTimeout(() => track.classList.remove('drag'), 30);
    [...dotsEl.children].forEach((d, i) => d.classList.toggle('on', i === page));
  }

  /* ---------- abrir / fechar (a seguir o dedo ou animado) ----------
     p = 0 fechada … 1 aberta: o fundo desfocado acende, o conteudo sobe 140 px e acende; as paginas da home apagam-se */
  function homeParts() { if (!homeEls) { const h = document.getElementById('home'); homeEls = h ? [h.querySelector('.pages'), h.querySelector('.dock'), h.querySelector('.page-dots'), h.querySelector('.ah-fs')].filter(Boolean) : []; } return homeEls; }
  function setP(v) {
    const p = Math.max(0, Math.min(1, v));
    bg.style.opacity = p.toFixed(3); inner.style.opacity = Math.min(1, p * 1.2).toFixed(3); inner.style.transform = `translate3d(0,${((1 - p) * 140).toFixed(1)}px,0)`;
    const o = Math.max(0, 1 - p * 1.5).toFixed(3); homeParts().forEach(n => { n.style.opacity = o; });
  }
  function clearHome() { homeParts().forEach(n => { n.style.opacity = ''; }); }
  function prep() {
    build(); clearTimeout(closeT); closeT = null;
    if (window.Home) { try { Home.closeAhMenu(true); Home.closeFolder(); if (Home.exitSelect) Home.exitSelect(); if (Home.edit) Home.exitEdit(); } catch (e) {} }
    if (dirty || geoKey !== keyNow()) renderGrid();
  }
  function pullStart() {
    if (!isA() || System.locked) return; prep(); if (searching) stopSearch(true);
    root.classList.add('on', 'pull'); root.classList.remove('dragout'); goPage(0, true); setP(0);
  }
  function pullMove(d) { if (!root || !root.classList.contains('pull')) return; setP((+d || 0) / PULL_D); }
  function pullEnd(ok) { if (!root || !root.classList.contains('pull')) return; if (ok) settleOpen(); else close(); }
  /* dobrável: a barra de estado segue o fundo da gaveta (android-sysui.js paintSb); a gaveta vive no #home, que o SysUI não vigia */
  const sbSync = () => { if (document.body.classList.contains('form-fold') && window.SysUI && SysUI.refresh) SysUI.refresh(); };
  function settleOpen() { open = true; root.classList.add('on'); root.classList.remove('pull', 'dragout'); setP(1); Sound.play('pop'); sbSync(); }
  function openD(opts = {}) {
    if (!isA() || System.locked) return; const was = open; prep();
    if (!was) { root.classList.add('on', 'pull'); setP(0); void root.offsetWidth; goPage(0, true); settleOpen(); }
    if (opts.search) setTimeout(() => { if (open) startSearch(); }, was ? 0 : 160);
  }
  function close(instant) {
    if (!root) return; const wasOpen = open || root.classList.contains('on'); open = false; ps = null;
    if (searching) stopSearch(true);
    if (window.Home && Home.menuOpen && Home.menuOpen()) { try { Home.closeAhMenu(true); } catch (e) {} }
    clearTimeout(closeT); closeT = null;
    const fin = () => { closeT = null; if (open) return; root.classList.remove('on', 'pull', 'dragout'); bg.style.opacity = ''; inner.style.opacity = ''; inner.style.transform = ''; clearHome(); goPage(0, true); sbSync(); };
    if (instant || !wasOpen) { fin(); return; }
    root.classList.remove('pull'); setP(0); closeT = setTimeout(fin, 300);
  }

  /* ---------- toques na grelha: abrir, paginar, puxar para baixo (fechar), toque longo (menu) e arrastar para a home ---------- */
  function unpress(it) { if (it) it.classList.remove('pressed'); }
  function bindGrid() {
    inner.addEventListener('pointerdown', e => {
      if (e.button && e.pointerType === 'mouse') return; if (ps || !open || searching) return;
      if (e.target.closest('.adr-top, .adr-res')) return;
      const it = e.target.closest('.adr-it');
      ps = { id: e.pointerId, x: e.clientX, y: e.clientY, t: Date.now(), it, axis: null, held: false, drag: false, timer: null, lx: e.clientX, ly: e.clientY, lt: Date.now(), vx: 0, vy: 0 };
      if (it) { it.classList.add('pressed'); ps.timer = setTimeout(() => { if (!ps || ps.axis) return; ps.held = true; unpress(it); Sound.play('pop'); menuFor(it); }, 450); }
      try { inner.setPointerCapture(e.pointerId); } catch (err) {}
    });
    inner.addEventListener('pointermove', e => {
      if (!ps || ps.drag || e.pointerId !== ps.id) return; const z = zk(); const dx = (e.clientX - ps.x) / z, dy = (e.clientY - ps.y) / z;
      /* toque longo + mexer: o menu fecha e a app passa para a home (a gaveta sai e a home recebe o arrasto) */
      if (ps.held) { if (ps.it && Math.hypot(dx, dy) > 8) startDragOut(e); return; }
      if (!ps.axis) { if (Math.hypot(dx, dy) < 10) return; clearTimeout(ps.timer); unpress(ps.it); ps.axis = Math.abs(dx) > Math.abs(dy) ? 'x' : 'y'; if (ps.axis === 'x') track.classList.add('drag'); else root.classList.add('pull'); }
      const now = Date.now(), dt = Math.max(1, now - ps.lt); ps.vx = (e.clientX - ps.lx) / z / dt; ps.vy = (e.clientY - ps.ly) / z / dt; ps.lx = e.clientX; ps.ly = e.clientY; ps.lt = now;
      if (ps.axis === 'x') { let off = dx; const edge = (page === 0 && off > 0) || (page === npages - 1 && off < 0); if (edge) off = Math.sign(off) * (1 - 1 / (Math.abs(off) * .55 / 160 + 1)) * 160; track.style.transform = `translate3d(${-page * pw() + off}px,0,0)`; }
      else setP(1 - Math.max(0, dy) / PULL_D);   /* para baixo fecha a seguir o dedo; para cima nao faz nada */
    });
    const up = e => {
      if (!ps || ps.drag || (e && e.pointerId !== ps.id)) return; const st = ps; ps = null; clearTimeout(st.timer); unpress(st.it);
      if (st.held) return;   /* o menu ficou aberto */
      const z = zk(); const dx = e ? (e.clientX - st.x) / z : 0, dy = e ? (e.clientY - st.y) / z : 0; const fresh = Date.now() - st.lt < 90;
      if (st.axis === 'x') { track.classList.remove('drag'); const v = fresh ? st.vx : 0; if (dx < -60 || v < -.45) goPage(page + 1); else if (dx > 60 || v > .45) goPage(page - 1); else goPage(page); return; }
      if (st.axis === 'y') { const v = fresh ? st.vy : 0; if (dy > 110 || (v > .45 && dy > 28)) close(); else { root.classList.remove('pull'); setP(1); } return; }
      if (e && e.type === 'pointerup' && st.it && open) launch(st.it._id, st.it.querySelector('.tile'));
    };
    inner.addEventListener('pointerup', up); inner.addEventListener('pointercancel', up);
  }
  function launch(id, tile) { if (!App.get(id)) return; Sound.play('click'); System.openApp(id, tile, { fromHome: true }); }
  /* arrastar para a home: os pointermove/pointerup seguintes chegam por ouvintes no window (em captura), porque a gaveta vai
     desaparecer e um elemento escondido perde a captura do ponteiro */
  function startDragOut(e) {
    const st = ps; if (!st || !window.Home || !Home.dragIn) return; try { Home.closeAhMenu(true); } catch (err) {}
    if (!Home.dragIn(st.it._id, e)) { ps = null; return; }
    st.drag = true; root.classList.add('dragout'); open = false;
    const mv = ev => { if (ev.pointerId !== st.id) return; ev.stopPropagation(); Home.dragMove(ev); };
    const fin = ev => { if (ev.pointerId !== st.id) return; ev.stopPropagation(); removeEventListener('pointermove', mv, true); removeEventListener('pointerup', fin, true); removeEventListener('pointercancel', fin, true);
      if (ps === st) ps = null; Home.dragEnd(ev.type === 'pointerup' ? ev : null); close(true); };
    addEventListener('pointermove', mv, true); addEventListener('pointerup', fin, true); addEventListener('pointercancel', fin, true);
    clearHome(); setP(0); homeParts().forEach(n => { n.style.opacity = ''; });
  }

  /* ---------- menus ---------- */
  function menuFor(it) {
    if (!window.Home || !Home.ahMenu) return; const id = it._id; const d = App.get(id) || {}; const rows = [], acts = [];
    let a = []; try { a = typeof d.actions === 'function' ? d.actions() : d.actions; } catch (e) { console.error('[apex_phone] actions', id, e); }
    (Array.isArray(a) ? a : []).filter(x => x && x.label && typeof x.onTap === 'function').slice(0, 4).forEach(x => rows.push({ label: x.label, icon: x.icon || 'chevR', onTap: () => { close(true); x.onTap(); } }));
    rows.push({ label: T('Adicionar ao ecrã principal'), icon: 'plusCircle', onTap: () => { if (Home.isOnHome(id)) UI.toast(T('Já está no ecrã principal')); else { Home.addApp(id); UI.toast(T('Adicionada ao ecrã principal')); } } });
    acts.push({ label: T('Informações'), icon: 'info', onTap: () => Home.appInfo(id) });
    if (!d.core) acts.push({ label: T('Desinstalar'), icon: 'trash', danger: true, onTap: () => Home.askUninstall(id) });
    Home.ahMenu(it, rows, acts);   /* âncora = ícone + legenda: o menu nunca tapa o nome */
  }
  /* anchor: o botao de onde o menu abre (os tres pontos ou a pilula da ordem) */
  function moreMenu(anchor) {
    if (!window.Home || !Home.ahMenu) return; const cur = System.state.drawerSort === 'alpha' ? 'alpha' : 'custom';
    const setSort = v => { if (v === cur) return; System.setState({ drawerSort: v }, { noApply: true }); dirty = true; page = 0; renderGrid(); };
    Home.ahMenu(anchor || moreBtn, [
      { label: T('Ordem personalizada'), iconHtml: cur === 'custom' ? g('check', 20) : '<i class="adr-noic"></i>', onTap: () => setSort('custom') },
      { label: T('Ordem alfabética'), iconHtml: cur === 'alpha' ? g('check', 20) : '<i class="adr-noic"></i>', onTap: () => setSort('alpha') },
      { label: T('Definições do ecrã principal'), icon: 'gear', onTap: () => { Home.openSettings('homescreen'); } }], []);
  }

  /* ---------- pesquisa (o mesmo motor da pesquisa global: apps, contactos, mensagens, definicoes e a Vera) ---------- */
  const leaveFn = () => { try { input.blur(); } catch (e) {} try { if (window.Keyboard && Keyboard.hide) Keyboard.hide(); } catch (e) {} setTimeout(() => close(true), 460); };
  function runSearch() { if (!searching || !window.Home || !Home.searchInto) return; Home.searchInto(res, input.value, { suggest: true, grid: true, onLeave: leaveFn }); }
  function startSearch() { if (!root || !open) return; if (!searching) { searching = true; root.classList.add('searching'); runSearch(); } try { if (document.activeElement !== input) input.focus(); } catch (e) {} }
  function stopSearch(silent) {
    if (!searching) return; searching = false; clearTimeout(qT); root.classList.remove('searching'); input.value = ''; sbar.classList.remove('has');
    try { input.blur(); } catch (e) {} try { if (window.Keyboard && Keyboard.hide) Keyboard.hide(); } catch (e) {}
    if (silent) res.innerHTML = ''; else setTimeout(() => { if (!searching) res.innerHTML = ''; }, 200);
  }

  /* Voltar do Android: menu > pesquisa > gaveta */
  function back() {
    if (!root || !(open || root.classList.contains('on'))) return false;
    if (window.Home && Home.menuOpen && Home.menuOpen()) { Home.closeAhMenu(); return true; }
    if (searching) { stopSearch(); return true; }
    close(); return true;
  }

  function init() {
    /* o PearOS nunca constroi a gaveta: so se marca o que esta por refazer */
    const stale = () => { dirty = true; if (open && !searching) renderGrid(); };
    Bridge.on('apps:changed', stale);
    Bridge.on('state', p => { if (p && 'drawerSort' in p) stale(); });
    Bridge.on('os:changed', () => { close(true); dirty = true; homeEls = null; if (root) { input.placeholder = T('Pesquisar'); paintSort(); } });
    Bridge.on('app:open', () => { if (root && (open || root.classList.contains('on'))) setTimeout(() => { if (System.currentApp()) close(true); }, 440); });
    Bridge.on('phone:close', () => close(true)); Bridge.on('lock', () => close(true));
  }
  /* apps: a lista pela ordem da gaveta (a barra de tarefas do dobravel aberto usa-a no painel "Todas as apps") */
  return { init, open: openD, close, isOpen: () => open, back, pullStart, pullMove, pullEnd, apps, get searching() { return searching; } };
})();

/* ============================================================
   PAINEL EDGE (Nova UI): pega na borda direita (18 px de largura, y 280 a 440) na home e dentro das apps, nunca no ecra
   bloqueado. Tocar ou puxar para a esquerda abre o painel (cartao r26) com ate 10 apps em 2 colunas; o lapis escolhe as
   apps (state.edgeApps); fecha ao tocar fora, ao puxar para a direita, com Voltar ou ao abrir uma app.
   state.edgePanel (Definicoes) liga/desliga a pega.
   ============================================================ */
window.EdgePanel = (() => {
  const MAX = 10, W = 156;
  const DEF = ['phone', 'messages', 'camera', 'photos', 'safari', 'settings', 'calendar', 'clock', 'notes', 'music'];
  const g = (n, s) => Icons.g(n, s);
  const T = s => (window.L && L.t ? L.t(s) : s);
  const isA = () => !!(window.System && System.os === 'android');
  const zk = () => (UI.zoom ? UI.zoom() : 1);
  let handle = null, wrap = null, panel = null, grid = null, open = false, hs = null, ps = null, closeT = null, sig = null;
  const enabled = () => isA() && System.state.edgePanel !== false;
  function list() {
    const inst = System.installed().filter(id => !(App.get(id) || {}).hidden);
    const raw = Array.isArray(System.state.edgeApps) ? System.state.edgeApps : DEF;
    return raw.filter((id, i, a) => typeof id === 'string' && inst.includes(id) && a.indexOf(id) === i).slice(0, MAX);
  }
  function build() {
    if (handle) return; const scr = UI.screen(); if (!scr) return;
    handle = UI.el('<div class="aedge-h"><i></i></div>'); scr.appendChild(handle);
    wrap = UI.el(`<div class="aedge-w"><div class="aedge-p"><div class="aedge-g"></div><div class="aedge-f"><div class="aedge-ed">${g('pen', 20)}</div></div></div></div>`); scr.appendChild(wrap);
    panel = wrap.querySelector('.aedge-p'); grid = wrap.querySelector('.aedge-g');
    /* pega: tocar abre; puxar para a esquerda abre a seguir o dedo */
    handle.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; if (!enabled() || System.locked) return; e.stopPropagation(); hs = { id: e.pointerId, x: e.clientX, y: e.clientY, moved: false, lx: e.clientX, lt: Date.now(), v: 0 }; try { handle.setPointerCapture(e.pointerId); } catch (err) {} });
    handle.addEventListener('pointermove', e => { if (!hs || e.pointerId !== hs.id) return; const z = zk(); const d = (hs.x - e.clientX) / z; const now = Date.now(); hs.v = (hs.lx - e.clientX) / z / Math.max(1, now - hs.lt); hs.lx = e.clientX; hs.lt = now;
      if (!hs.moved) { if (Math.abs(d) < 6 && Math.abs(e.clientY - hs.y) / z < 6) return; hs.moved = true; paint(); clearTimeout(closeT); wrap.classList.add('on', 'drag'); }
      panel.style.transform = `translate3d(${(W + 18 - Math.max(0, Math.min(W + 18, d))).toFixed(1)}px,0,0)`; });
    const hup = e => { if (!hs || (e && e.pointerId !== hs.id)) return; const st = hs; hs = null; const z = zk(); const d = e ? (st.x - e.clientX) / z : 0;
      if (!st.moved) { if (e && e.type === 'pointerup') openP(); return; }
      wrap.classList.remove('drag'); panel.style.transform = ''; if (d > 50 || (Date.now() - st.lt < 90 && st.v > .4)) openP(); else close(); };
    handle.addEventListener('pointerup', hup); handle.addEventListener('pointercancel', hup);
    /* fora do painel fecha; dentro, puxar para a direita fecha a seguir o dedo e tocar num icone abre a app */
    wrap.addEventListener('pointerdown', e => { if (!open) return; if (e.target === wrap) { e.stopPropagation(); close(); return; }
      /* o alvo fica guardado JÁ: com a captura do ponteiro o pointerup chega com o painel como alvo */
      ps = { id: e.pointerId, x: e.clientX, y: e.clientY, moved: false, it: e.target.closest('.aedge-it'), ed: !!e.target.closest('.aedge-ed') }; try { panel.setPointerCapture(e.pointerId); } catch (err) {} });
    panel.addEventListener('pointermove', e => { if (!ps || e.pointerId !== ps.id) return; const z = zk(); const d = (e.clientX - ps.x) / z;
      if (!ps.moved) { if (Math.hypot(e.clientX - ps.x, e.clientY - ps.y) / z < 8) return; ps.moved = true; if (d > 0) wrap.classList.add('drag'); }
      if (wrap.classList.contains('drag')) panel.style.transform = `translate3d(${Math.max(0, d).toFixed(1)}px,0,0)`; });
    const pup = e => { if (!ps || (e && e.pointerId !== ps.id)) return; const st = ps; ps = null; const z = zk(); const d = e ? (e.clientX - st.x) / z : 0;
      if (wrap.classList.contains('drag')) { wrap.classList.remove('drag'); panel.style.transform = ''; if (d > 50) close(); return; }
      if (!st.moved && e && e.type === 'pointerup') { if (st.it) launch(st.it.dataset.id, st.it.querySelector('.tile')); else if (st.ed) editApps(); } };
    panel.addEventListener('pointerup', pup); panel.addEventListener('pointercancel', pup);
    sync();
  }
  /* os icones so se refazem quando a lista (ou o sistema) muda: abrir o painel nao reconstroi nada */
  function paint() {
    if (!grid) return; const l = list(); const s = l.join(',') + '|' + System.os; if (s === sig) return; sig = s; grid.innerHTML = '';
    l.forEach(id => { const it = UI.el(`<div class="aedge-it" data-id="${UI.esc(id)}">${Icons.tileBox(id)}</div>`); grid.appendChild(it); });
    if (!l.length) { const em = UI.el('<div class="aedge-empty"></div>'); em.textContent = T('Toca no lápis para escolher apps'); grid.appendChild(em); }
  }
  function sync() { if (!handle) return; handle.classList.toggle('on', enabled()); if (!enabled() && open) close(true); }
  function openP() {
    if (!enabled() || System.locked) return; build(); paint(); clearTimeout(closeT); closeT = null;
    if (window.Home && Home.closeAhMenu) { try { Home.closeAhMenu(true); } catch (e) {} }
    if (!wrap.classList.contains('on')) { wrap.classList.add('on'); void wrap.offsetWidth; }
    open = true; wrap.classList.add('in'); Sound.play('pop');
  }
  function close(instant) {
    if (!wrap) return; open = false; ps = null; wrap.classList.remove('in', 'drag'); panel.style.transform = ''; clearTimeout(closeT);
    if (instant) { wrap.classList.remove('on'); closeT = null; return; }
    closeT = setTimeout(() => { closeT = null; if (!open) wrap.classList.remove('on'); }, 280);
  }
  function launch(id, tile) { if (!id || !App.get(id)) return; Sound.play('click'); System.openApp(id, tile); setTimeout(() => close(true), 380); }
  /* lapis: escolher ate 10 apps (a ordem e a da escolha). Lista propria com o limite controlado aqui. */
  function editApps() {
    close(); const inst = System.installed().filter(id => !(App.get(id) || {}).hidden).sort((a, b) => App.name(a).localeCompare(App.name(b), 'pt'));
    const picked = list().slice(); const body = document.createElement('div'); body.className = 'aedge-sl';
    const head = UI.el('<div class="aedge-sh"></div>'); body.appendChild(head);
    const count = () => { head.textContent = T('Escolhe até 10 apps') + ' · ' + picked.length + '/' + MAX; };
    inst.forEach(id => { const row = UI.el(`<div class="aedge-sr" data-id="${UI.esc(id)}">${Icons.tileBox(id)}<span></span><i class="aedge-ck"></i></div>`); row.querySelector('span').textContent = App.name(id); row.classList.toggle('on', picked.includes(id));
      row.onclick = () => { const i = picked.indexOf(id); if (i > -1) picked.splice(i, 1); else if (picked.length >= MAX) { UI.toast(T('Máximo de 10 apps')); return; } else picked.push(id); row.classList.toggle('on', picked.includes(id)); Sound.play('click'); count(); };
      body.appendChild(row); });
    count();
    UI.sheet({ title: T('Apps do painel Edge'), left: T('Cancelar'), right: T('Guardar'), body, cls: 'aedge-sheet', onDone: () => { System.setState({ edgeApps: picked.slice() }, { noApply: true }); sig = null; paint(); } });
  }
  function back() { if (!open) return false; close(); return true; }
  function init() {
    /* a pega so e construida quando ha um telemovel NOVA (no PearOS nao existe) */
    const refresh = () => { if (isA()) build(); sig = null; sync(); };
    Bridge.on('os:changed', () => { close(true); refresh(); });
    Bridge.on('state', p => { if (p && ('edgePanel' in p || 'edgeApps' in p || 'installed' in p)) refresh(); });
    Bridge.on('apps:changed', () => { sig = null; if (open) paint(); });
    Bridge.on('app:open', () => { if (open) setTimeout(() => close(true), 380); });
    Bridge.on('phone:close', () => close(true)); Bridge.on('lock', () => close(true));
    refresh();
  }
  return { init, open: openP, close, isOpen: () => open, back };
})();
