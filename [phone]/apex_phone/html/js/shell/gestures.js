/* ============================================================
   GESTURES - tudo interativo, a seguir o dedo (PearOS 17):
   · indicador: arrastar encolhe a app até ao ícone e revela a home;
     largar = home / segurar = App Switcher / voltar atrás com mola
   · borda esquerda: voltar (a vista segue o dedo, a anterior faz paralaxe)
   · topo: Control Center (direita) / Notificações (esquerda) descem com o dedo
   ANDROID (Nova UI 8.5, body.os-android): puxar do topo abre o painel rápido a seguir o dedo
   (metade esquerda = notificações, metade direita = definições rápidas, QuickPanel.pull*); no modo
   gestos a pega de baixo faz o mesmo que o indicador (subir = início, subir e parar = recentes,
   deslizar = app anterior) e o Voltar desliza das DUAS bordas com a seta da Nova UI (SysUI.back).
   Com a barra de 3 botões não há gesto da pega nem das bordas (CSS: body[data-nav="buttons"]).
   ============================================================ */
window.Gestures = (() => {
  const PW = 440, PH = 956;
  const isA = () => !!(window.System && System.os === 'android');
  /* a escala do ecrã vem do UI.zoom(), que a guarda 250 ms em cache: chamar
     getBoundingClientRect() aqui forçava um LAYOUT do documento em cada pointermove dos gestos
     (borda e topo faziam-no 60×/s). O gesto do indicador já lia a escala uma vez por gesto - a
     borda e o topo fazem agora o mesmo, e isto fica só como recuo. */
  const k = () => UI.zoom();
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  const rubber = (d, c = 0.55, dim = 200) => (1 - (1 / ((d * c / dim) + 1))) * dim; /* rubber band PearOS */
  const fivem = () => document.body.classList.contains('fivem');   /* no jogo: sem transform no wallpaper nem filter inline (superfícies com filter fora do ecrã pintam preto no CEF) */
  const inSetup = () => { const s = document.getElementById('setup'); return !!(s && s.classList.contains('in')); };
  function init() {
    const scr = UI.screen();
    const hb = UI.el('<div class="hb-zone"></div>'), edge = UI.el('<div class="edge-zone"></div>'), top = UI.el('<div class="top-zone"><div class="tz-l"></div><div class="tz-r"></div></div>');
    scr.append(hb, edge, top);
    const home = () => document.getElementById('home');

    /* ---- indicador (home) - PearOS 17/26:
       · arrastar: a app vira um cartão que segue o dedo (encolhe até ~38 %, desloca-se com o dedo), a home aparece atrás e o fundo desfoca-se ao contrário
       · largar rápido / alto → a app encolhe até ao seu ícone (System.closeApp)
       · parar a meio e largar → App Switcher: o cartão assenta na posição do switcher e os outros cartões entram pela esquerda
       · deslizar na horizontal → salta para a app anterior
       · largar cedo → volta com mola ---- */
    let st = null;
    hb.addEventListener('pointerdown', e => {
      const id = System.currentApp(); const win = id && System.windows[id];
      st = { id, win, y: e.clientY, x: e.clientX, t: Date.now(), lastY: e.clientY, lastT: Date.now(), lastX: e.clientX, vy: 0, vx: 0, dx: 0, dy: 0, s: 1, z: k(), wb: scr.querySelector('.wallpaper-blur'), wbOn: false };   /* a camada desfocada também se procura UMA vez por gesto */   /* escala lida UMA vez por gesto: ler getBoundingClientRect em cada pointermove forçava um layout por frame (engasgava no CEF) */
      try { hb.setPointerCapture(e.pointerId); } catch (x) {}   /* pode falhar se o ponteiro já não estiver ativo - não pode rebentar o gesto */
      if (win) { win.classList.add('dragging'); win.classList.remove('settle'); win.style.transformOrigin = '50% 50%'; const h = home(); if (h) { h.classList.add('nt'); h.classList.add('in'); } }
    });
    const SCALE_MIN = .38;
    const cardOf = (dx, dy) => { const p = clamp(dy / 460, 0, 1); const s = 1 - p * (1 - SCALE_MIN); return { p, s, tx: dx * .62, ty: -dy * .64 }; };
    hb.addEventListener('pointermove', e => {
      if (!st) return; const z = st.z || 1; const dy = (st.y - e.clientY) / z, dx = (e.clientX - st.x) / z; const now = Date.now();
      st.vy = (st.lastY - e.clientY) / z / Math.max(1, now - st.lastT); st.vx = (e.clientX - st.lastX) / z / Math.max(1, now - st.lastT); st.lastY = e.clientY; st.lastX = e.clientX; st.lastT = now; st.dx = dx; st.dy = dy;
      if (st.win && dy > 0) {
        const c = cardOf(dx, dy); st.s = c.s;
        st.win.style.transform = `translate(${c.tx}px,${c.ty}px) scale(${c.s})`;
        const h = home(); if (h) { h.style.opacity = clamp(c.p * 1.5, 0, 1); h.style.transform = `scale(${1.14 - .14 * clamp(c.p * 1.35, 0, 1)})`; }
        /* o desfoque do fundo desvanece com o dedo (só opacidade: barato); o `transition:none` escreve-se uma vez, não a cada frame */
        const wb = st.wb; if (wb) { if (!st.wbOn) { st.wbOn = true; wb.style.transition = 'none'; } wb.style.opacity = String(1 - c.p); }
      } else if (st.win) { st.s = 1; st.win.style.transform = `translateY(${rubber(-dy, .4, 60)}px)`; }
    });
    const release = () => { const h = home(); if (h) { h.classList.remove('nt'); h.style.opacity = ''; h.style.transform = ''; } const wb = scr.querySelector('.wallpaper-blur'); if (wb) { wb.style.transition = ''; wb.style.opacity = ''; } };
    const up = e => {
      if (!st) return; const z = k(); const dy = (st.y - e.clientY) / z, dx = (e.clientX - st.x) / z, dt = Date.now() - st.t; const s = st; st = null;
      if (inSetup()) { release(); return; }   /* durante o assistente inicial os gestos não fazem nada */
      /* se o dedo parou (sem movimento nos últimos 90 ms) a velocidade é zero - é isso que distingue "parar a meio → switcher" de "atirar → home" */
      const idle = Date.now() - s.lastT; const v = idle > 90 ? 0 : s.vy; if (idle > 90) s.vx = 0;
      if (s.win) { s.win.classList.remove('dragging'); }
      const tap = Math.abs(dy) < 8 && Math.abs(dx) < 8 && dt < 320;   /* o indicador também é CLICÁVEL (pedido do utilizador): toque = home / fechar o que estiver aberto */
      if (window.Hardware && Hardware.screenOff) { release(); Hardware.wake(); return; }
      /* Android: a pega fecha primeiro o painel rápido, o Edge e a gaveta de apps */
      if (isA()) { for (const m of ['QuickPanel', 'EdgePanel', 'Drawer']) { const o = window[m]; try { if (o && o.isOpen && o.isOpen() && o.close) { release(); o.close(); return; } } catch (x) {} } }
      if (window.Home && Home.folderOpen && Home.folderOpen() && !System.locked) { release(); Home.closeFolder(); return; }
      if (window.Notify && Notify.isOpen()) { release(); Notify.close(); return; }
      if (window.CC && CC.isOpen()) { release(); CC.close(); return; }
      if (window.Switcher && Switcher.isOpen()) { release(); if (dy < 20) Switcher.close(); return; }
      if (window.LockGallery && LockGallery.isOpen()) { release(); LockGallery.close(); return; }   /* indicador: sai da galeria de personalização */
      /* BLOQUEADO COM UMA APP ABERTA (Câmara ou Wallet a partir do ecrã bloqueado): o indicador tem de FECHAR a app.
         Antes caía direto no `Lock.showPin()` e, como o modo câmara também esconde o indicador, ficava-se preso lá dentro. */
      if (System.locked && s.win) { release(); Sound.play('click'); System.closeApp(); return; }
      if (System.locked) { release(); if (dy > 30) Lock.showPin(); return; }
      if (window.Home && Home.searchOpen && Home.searchOpen()) { release(); Home.closeSearch(); return; }   /* indicador: sai da pesquisa global (puxar para baixo na home) */
      if (window.Home && Home.spotOpen && Home.spotOpen()) { release(); Home.closeSpot(); if (s.win) { s.win.classList.add('settle'); s.win.style.transform = ''; setTimeout(() => s.win.classList.remove('settle'), 600); } return; }
      if (s.win && tap) { release(); Sound.play('click'); System.closeApp(); return; }
      if (s.win) {
        /* pedido do utilizador: um arrasto LIGEIRO para cima abre o App Switcher; só um arrasto alto (>230 px) ou um atirar forte vai direto para a home */
        const flick = Math.abs(dx) > 90 && dy < 70 && Math.abs(s.vx) > .25;
        const goHome = !flick && (dy > 230 || (v > 1.1 && dy > 90));
        const toSwitcher = !flick && !goHome && dy > 22;
        if (flick) { /* deslizar na barra → app anterior/seguinte (PearOS) */
          const others = System.recents.filter(x => x !== s.id && System.windows[x]); const prev = others[0];
          release(); s.win.classList.add('settle'); s.win.style.transform = ''; setTimeout(() => s.win.classList.remove('settle'), 600);
          if (prev) { System.openApp(prev, null, { slide: dx < 0 ? 'left' : 'right' }); } else { const h = home(); if (h) { h.classList.remove('nt'); h.style.transition = 'opacity .25s ease-out, transform .4s var(--ios)'; h.style.opacity = '0'; h.style.transform = 'scale(1.14)'; setTimeout(() => { h.style.transition = ''; h.style.opacity = ''; h.style.transform = ''; }, 420); } }
          return;
        }
        if (goHome) { release(); System.closeApp(); return; }                              /* closeApp anima do transform atual até ao ícone */
        if (toSwitcher) { const c = cardOf(dx, Math.max(dy, 1)); release(); Switcher.open({ from: s.id, geo: { tx: c.tx, ty: c.ty, s: c.s } }); return; }
        /* volta com mola */
        s.win.classList.add('settle'); s.win.style.transform = ''; setTimeout(() => s.win.classList.remove('settle'), 600);
        const h = home(); if (h) { h.classList.remove('nt'); h.style.transition = 'opacity .25s ease-out, transform .4s var(--ios)'; h.style.opacity = '0'; h.style.transform = 'scale(1.14)'; setTimeout(() => { h.style.transition = ''; h.style.opacity = ''; h.style.transform = ''; if (!System.currentApp()) h.classList.add('in'); }, 420); }
        const wb = scr.querySelector('.wallpaper-blur'); if (wb) { wb.style.transition = ''; wb.style.opacity = ''; }
        return;
      }
      release();
      if (dy > 22) { Switcher.open(); return; }   /* na home: arrasto ligeiro para cima → App Switcher */
      if (Math.abs(dy) < 6 && dt < 300 && window.Home) { if (Home.edit) Home.exitEdit(); else Home.goPage(0); }
    };
    hb.addEventListener('pointerup', up); hb.addEventListener('pointercancel', up);

    /* ---- borda esquerda → voltar ---- */
    let es = null;
    edge.addEventListener('pointerdown', e => {
      if (isA()) return;   /* Android: o Voltar da borda é o de baixo (androidBack) */
      const id = System.currentApp(); if (!id || System.locked) return; const win = System.windows[id]; if (!win) return;
      /* app dividida no PearPhone Fold (UI.split): a lista e o 1.º detalhe estão os dois à vista; voltar só fecha o que
         foi empilhado DENTRO do detalhe (com 2 vistas o gesto fechava o detalhe e deixava a metade direita vazia) */
      const split = win.querySelector(':scope > .nav-stack.split');
      if (UI.depth(win) < (split ? 3 : 2)) return;
      /* a vista segue o dedo nos px DELA (UI.zoom(vista): o aparelho e, no PearPhone Fold, o zoom do conteúdo da app) */
      const stack = win.querySelector('.nav-stack'), vw = stack.lastElementChild; es = { x: e.clientX, t: Date.now(), lastX: e.clientX, lastT: Date.now(), vx: 0, z: (UI.vrect ? UI.zoom(vw) : 0) || k(), view: vw, prev: vw.previousElementSibling };
      edge.setPointerCapture(e.pointerId); es.view.classList.add('swiping'); if (es.prev) es.prev.style.transition = 'none';
    });
    edge.addEventListener('pointermove', e => {
      if (!es) return; const z = es.z; const dx = Math.max(0, (e.clientX - es.x) / z); const now = Date.now(); es.vx = (e.clientX - es.lastX) / z / Math.max(1, now - es.lastT); es.lastX = e.clientX; es.lastT = now;
      /* só transform: a sombra da vista que sai é FIXA e vem do CSS (.view.swiping). Reescrever um
         box-shadow de 30 px numa camada de ecrã inteiro a cada frame obriga o CEF a repintar a
         sombra inteira - e isso era o que se sentia como "agarrado" no gesto de voltar. */
      es.view.style.transform = `translateX(${dx}px)`;
      if (es.prev) { const p = dx / (es.view.offsetWidth || System.SW || PW); es.prev.style.transform = `translateX(${-30 + p * 30}%)`;   /* SW: 670 / 1340 no dobrável (a vista tem a largura do ecrã) */ if (fivem()) es.prev.style.setProperty('--behind', String(1 - p)); else es.prev.style.filter = `brightness(${.86 + .14 * p})`; }
    });
    const eup = e => {
      if (!es) return; const z = es.z; const dx = (e.clientX - es.x) / z; const s = es; es = null;
      s.view.classList.remove('swiping'); s.view.style.transform = ''; s.view.style.boxShadow = '';
      if (s.prev) { s.prev.style.transition = ''; s.prev.style.transform = ''; s.prev.style.filter = ''; s.prev.style.removeProperty('--behind'); }
      if (dx > PW * .35 || s.vx > .5) UI.pop(s.view);
    };
    edge.addEventListener('pointerup', eup); edge.addEventListener('pointercancel', eup);

    /* ---- ANDROID: Voltar a deslizar das DUAS bordas (só no modo gestos; o CSS desliga as zonas com 3 botões) ----
       A app não desliza: entra pela borda uma bolha com a seta que acompanha o dedo e acende quando passa o limite;
       largar aí é o Voltar do sistema (SysUI.back: teclado, folha, painel, vista da app, fechar a app). A borda direita
       salta a pega do painel Edge (y 280 a 440): são duas zonas (.anb-edge.r1 / .r2). */
    const er1 = UI.el('<div class="anb-edge anb-r1"></div>'), er2 = UI.el('<div class="anb-edge anb-r2"></div>');
    const arrow = UI.el(`<div class="anb-arrow">${window.SysUI && SysUI.icon ? SysUI.icon('back', 20) : ''}</div>`);
    scr.append(er1, er2, arrow);
    /* sem pega do Edge (desligada, no bloqueado, na Câmara ou no assistente) a borda direita volta a ser toda do Voltar */
    const syncEdge = () => { const full = !!((System.state && System.state.edgePanel === false) || System.locked || System.currentApp() === 'camera' || inSetup()); er1.classList.toggle('anb-full', full); er2.classList.toggle('anb-full', full); };
    syncEdge(); Bridge.on('state', p => { if (p && 'edgePanel' in p) syncEdge(); });
    ['app:open', 'app:close', 'app:kill', 'lock', 'unlock', 'ready', 'os:changed', 'phone:open'].forEach(ev => Bridge.on(ev, () => setTimeout(syncEdge, 0)));
    if (!arrow.firstChild) Bridge.on('os:changed', () => { if (!arrow.firstChild && window.SysUI && SysUI.icon) arrow.innerHTML = SysUI.icon('back', 20); });
    const BACK_AT = 72;   /* px de arrasto a partir dos quais largar volta atrás */
    let ab = null;
    const abStart = (e, side, zone) => {
      if (!isA() || inSetup() || (window.Hardware && Hardware.screenOff)) return;
      const z = k(), s = scr.getBoundingClientRect();
      ab = { side, x: e.clientX, z, go: false, lastX: e.clientX, lastT: Date.now(), vx: 0 };
      try { zone.setPointerCapture(e.pointerId); } catch (x) {}
      if (!arrow.firstChild && window.SysUI && SysUI.icon) arrow.innerHTML = SysUI.icon('back', 20);
      arrow.classList.remove('anb-l', 'anb-r', 'anb-on', 'anb-go'); arrow.classList.add('anb-' + side);
      arrow.style.top = clamp((e.clientY - s.top) / z, 80, PH - 80).toFixed(1) + 'px'; arrow.style.transform = '';
    };
    const abMove = e => {
      if (!ab) return; const sg = ab.side === 'l' ? 1 : -1, dx = sg * (e.clientX - ab.x) / ab.z, now = Date.now();
      ab.vx = sg * (e.clientX - ab.lastX) / ab.z / Math.max(1, now - ab.lastT); ab.lastX = e.clientX; ab.lastT = now;
      if (dx > 6 && !arrow.classList.contains('anb-on')) arrow.classList.add('anb-on');
      const tx = Math.min(Math.max(0, dx) * .45, 52); arrow.style.transform = `translateX(${(sg * tx).toFixed(1)}px)`;
      const go = dx > BACK_AT; if (go !== ab.go) { ab.go = go; arrow.classList.toggle('anb-go', go); }
    };
    const abEnd = e => {
      if (!ab) return; const s = ab; ab = null; const dx = (s.side === 'l' ? 1 : -1) * (e.clientX - s.x) / s.z;
      arrow.classList.remove('anb-on', 'anb-go'); arrow.style.transform = '';
      if (dx > BACK_AT || (dx > 30 && s.vx > .5)) { if (window.SysUI && SysUI.back) SysUI.back(); }
    };
    [[edge, 'l'], [er1, 'r'], [er2, 'r']].forEach(([zone, side]) => {
      zone.addEventListener('pointerdown', e => { if (isA()) abStart(e, side, zone); });
      zone.addEventListener('pointermove', abMove);
      zone.addEventListener('pointerup', abEnd); zone.addEventListener('pointercancel', abEnd);
    });

    /* ---- topo → CC (direita) / NC (esquerda): descem a seguir o dedo ----
       Zona de conflito com a pesquisa da home: a .top-zone ocupa só a faixa da barra de estado (var(--statusbar-h), 68 px) e
       captura o ponteiro; puxar para baixo a partir daí é sempre CC/NC. Abaixo dela (as páginas começam em 98 px) o home.js
       trata o puxar como pesquisa global - ver PULL_MIN_Y. Com o ecrã BLOQUEADO o puxar da esquerda também abre o NC (PearPhone). */
    let ts = null;
    const pullTarget = right => { if (right) return { el: document.getElementById('cc'), inner: '.cc-panel' }; return { el: document.getElementById('nc'), inner: '.nc-list' }; };
    /* Android: o painel rápido (QuickPanel) desce a seguir o dedo; sem as funções pull* recua para o caminho do PearOS
       (o Notify/CC do Android delegam no QuickPanel). Metades iguais do ecrã, como na Nova UI. */
    const qpPull = () => !!(window.QuickPanel && typeof QuickPanel.pullStart === 'function' && typeof QuickPanel.pullMove === 'function' && typeof QuickPanel.pullEnd === 'function');
    top.addEventListener('pointerdown', e => {
      ts = { y: e.clientY, t: Date.now(), right: e.target.classList.contains('tz-r'), lastY: e.clientY, lastT: Date.now(), vy: 0, pulling: false, z: k(), tg: null, inner: null, qp: false, which: null };
      if (isA()) { const s = scr.getBoundingClientRect(); ts.which = (e.clientX - s.left) / ts.z < (System.SW || PW) / 2 ? 'notif' : 'qs'; ts.right = ts.which === 'qs'; ts.qp = qpPull(); }   /* metade do ecrã: 220, ou 335 / 670 no dobrável */
      try { top.setPointerCapture(e.pointerId); } catch (x) {}   /* ponteiro já inativo: não pode rebentar o gesto (igual ao indicador) */
    });
    top.addEventListener('pointermove', e => {
      if (!ts) return; const z = ts.z; const dy = (e.clientY - ts.y) / z; const now = Date.now(); ts.vy = (e.clientY - ts.lastY) / z / Math.max(1, now - ts.lastT); ts.lastY = e.clientY; ts.lastT = now;
      /* bloqueado com uma app aberta (Câmara a partir do lock): o NC não desce por cima dela; o toque na barra continua a fechá-la */
      if (dy < 8 || (System.locked && !ts.right && (System.currentApp() || (window.LockGallery && LockGallery.isOpen()))) || inSetup()) return;
      if (ts.qp) { try { if (!ts.pulling) { ts.pulling = true; QuickPanel.pullStart(ts.which); } QuickPanel.pullMove(ts.which, clamp(dy / 260, 0, 1)); } catch (x) { console.error('[apex_phone] QuickPanel.pull', x); } return; }
      /* os nós do painel resolvem-se UMA vez por gesto (getElementById + querySelector a cada
         pointermove eram duas travessias do DOM por frame, e o painel é sempre o mesmo) */
      if (!ts.tg) { const t0 = pullTarget(ts.right); if (!t0.el) return; ts.tg = t0; ts.inner = t0.el.querySelector(t0.inner); }
      const tg = ts.tg, inner = ts.inner;
      if (!ts.pulling) { ts.pulling = true; tg.el.classList.add('pulling'); tg.el.style.opacity = '0'; tg.el.style.visibility = 'visible'; tg.el.style.pointerEvents = 'none';
        if (ts.right) { if (window.CC && !CC.isOpen()) CC.open(true); } else if (window.Notify && !Notify.isOpen()) Notify.openNC(); }
      const p = clamp(dy / 260, 0, 1);
      tg.el.style.opacity = String(clamp(p * 1.6, 0, 1));
      if (inner) inner.style.transform = `translateY(${-60 * (1 - p)}px) scale(${.9 + .1 * p})`;
    });
    const tup = e => {
      if (!ts) return; const z = ts.z; const dy = (e.clientY - ts.y) / z; const s = ts; ts = null;
      if (s.qp) {
        if (!s.pulling) {
          if (inSetup()) return;
          /* um toque na barra também abre (rato no jogo): esquerda = notificações, direita = definições rápidas */
          if (Math.abs(dy) < 6 && Date.now() - s.t < 320) { try { if (System.locked && System.currentApp() && s.which === 'notif') System.closeApp(); else if (QuickPanel.toggle) QuickPanel.toggle(s.which); else if (QuickPanel.open) QuickPanel.open(s.which); } catch (x) { console.error('[apex_phone] QuickPanel', x); } }
          return;
        }
        const open = dy > 90 || s.vy > .6;
        try { QuickPanel.pullEnd(s.which, open); } catch (x) { console.error('[apex_phone] QuickPanel.pullEnd', x); }
        if (open) Sound.play('pop');
        return;
      }
      const tg = s.tg || pullTarget(s.right); const inner = s.tg ? s.inner : (tg.el && tg.el.querySelector(tg.inner));
      const clean = () => { if (!tg.el) return; tg.el.classList.remove('pulling'); tg.el.style.opacity = ''; tg.el.style.visibility = ''; tg.el.style.pointerEvents = ''; if (inner) inner.style.transform = ''; };
      if (!s.pulling) {
        clean(); if (inSetup()) return;
        /* a barra de cima também é CLICÁVEL (pedido do utilizador): direita = Centro de Controlo, esquerda = Notificações (no lock: código) */
        if (Math.abs(dy) < 6 && Date.now() - s.t < 320) { if (s.right) { if (window.CC) CC.toggle(); } else if (System.locked && System.currentApp()) System.closeApp(); else if (System.locked) Lock.showPin(); else if (window.Notify) Notify.toggle(); }
        return;
      }
      const open = dy > 90 || s.vy > .6;
      if (s.right) { clean(); if (open) Sound.play('pop'); else CC.close(); return; }
      /* bloqueado: o NC fica aberto como no desbloqueado (antes caía sempre no teclado do código); abrir uma notificação pede o código no notify.js */
      clean(); if (!open) Notify.close();
    };
    top.addEventListener('pointerup', tup); top.addEventListener('pointercancel', tup);
    addEventListener('keydown', e => { if (e.target.matches('input,textarea,select')) return; if (e.key === 'F9') CC.toggle(); if (e.key === 'F8') Notify.toggle(); if (e.key === 'F7') Switcher.toggle(); });
  }
  return { init };
})();
