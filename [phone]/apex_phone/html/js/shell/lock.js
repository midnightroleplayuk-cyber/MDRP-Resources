/* ============================================================
   LOCK SCREEN - relógio animado (dígitos rolantes), data, widgets,
   notificações, atalhos (lanterna/câmara), swipe para o código,
   teclado do código centrado (PearOS 17), animação de desbloqueio

   NOVA S26 (Nova UI 8.5, body.os-android): o MESMO módulo desenha outra marcação (buildAndroid) e muda
   o comportamento onde a Nova UI é diferente: relógio empilhado (horas numa linha, minutos na outra),
   data com o tempo, widgets em cartões de vidro, Now Bar ao centro em baixo, atalhos que se ARRASTAM,
   deslizar em qualquer direção para desbloquear, teclado do PIN sem círculos com OK e apagar, e o
   sensor de impressão digital no ecrã. A lógica (PIN no servidor, tentativas, bloqueio temporário,
   requestUnlock, emergência, Face Key) é a mesma nos dois sistemas: só muda o que se vê.
   ============================================================ */
window.Lock = (() => {
  /* 10 teclas: o "0" vai sozinho para a coluna do meio (CSS grid-column:2) - sem células vazias, que no jogo ficavam visíveis */
  const g = UI.g; const KEYS = [['1',''],['2','ABC'],['3','DEF'],['4','GHI'],['5','JKL'],['6','MNO'],['7','PQRS'],['8','TUV'],['9','WXYZ'],['0','']];
  let el, p1, p2, clockEl, dateEl, topEl, entry = '', busy = false, pending = null, dotsEl, labelEl, kp, lastHM = '', pcClock = null;
  /* Android: as peças que só existem na marcação da Nova UI (subtítulo do PIN, cancelar, dica, impressão digital, tempo, dígitos) */
  let R = {}, builtOS = null;
  const isAnd = () => !!(window.System && System.os === 'android');
  function init() {
    el = document.getElementById('lock');
    build();
    /* mudar de idioma não atualiza nada por si: volta-se a escrever os rótulos (método das traduções) */
    if (window.L) L.onChange(relabel);
    renderWidgets(); renderDots(); applyClock();
    syncClockFallback(); if (wantBank()) bankFetch();   /* 1.4.0: tamanho do relógio sem system.js novo (recurso) e o saldo do widget Carteira (só se estiver posto) */
  }
  function relabel() {
    if (!el) return; const q = (s, t) => { const n = el.querySelector(s); if (n) n.textContent = t; };
    if (builtOS === 'android') { q('.als-hint', L.t('Deslize para desbloquear')); q('.als-pt', L.t('Introduza o PIN')); q('.als-emerg', L.t('Chamada de emergência')); q('.als-cancel', L.t('Cancelar')); tick(new Date(), true); return; }
    q('.lock-hint', L.t('Deslize para cima para desbloquear')); if (!coolLeft()) q('.pc-label', L.t('Introduzir código')); q('.emerg', L.t('Emergência')); q('.cancel', entry ? L.t('Apagar') : L.t('Cancelar')); tick(new Date(), true);
  }
  /* a marcação depende do sistema do aparelho: trocar de item a meio (os:changed) volta a desenhá-la */
  function build() {
    const and = isAnd(); builtOS = and ? 'android' : 'ios'; R = {}; npEl = null; nb = null; mx = null; lastHM = ''; lumaVar = null;
    el.classList.toggle('als', and);
    if (and) buildAndroid(); else buildIOS();
  }
  function buildIOS() {
    el.innerHTML = `<div class="lock-clockwrap"><div class="lock-clock" aria-label="hora"></div><div class="lock-date"></div><div class="lock-face">${g('lock')}</div></div>
      <div class="lock-p1"><div class="lock-top"></div><div class="lock-widgets"></div><div class="lock-notifs"></div><div class="lock-np"></div>
      <div class="lock-shortcuts"></div><div class="lock-ring" role="button" aria-label="${UI.esc(L.t('Bateria'))}"></div><div class="lock-hint">${L.t('Deslize para cima para desbloquear')}</div></div>
      <div class="lock-p2"><div class="pc-clock"></div><div class="pc-head"><div class="pc-label">${L.t('Introduzir código')}</div><div class="dots"></div></div>
      <div class="pc-pad"><div class="keypad"></div></div>
      <div class="lock-bottom"><span class="emerg">${L.t('Emergência')}</span><span class="cancel">${L.t('Cancelar')}</span></div></div>`;
    p1 = el.querySelector('.lock-p1'); p2 = el.querySelector('.lock-p2'); dotsEl = p2.querySelector('.dots'); labelEl = p2.querySelector('.pc-label'); pcClock = p2.querySelector('.pc-clock');
    topEl = el.querySelector('.lock-clockwrap'); clockEl = topEl.querySelector('.lock-clock'); dateEl = topEl.querySelector('.lock-date');
    kp = p2.querySelector('.keypad'); kp.innerHTML = KEYS.map(([n, l]) => `<div class="key lg lg-wp on-lock" data-n="${n}"><span class="num">${n}</span><span class="abc">${l || '&nbsp;'}</span></div>`).join('');   /* etiqueta sempre presente: o "1" e o "0" ficam alinhados com os outros */
    kp.onclick = e => { const k = e.target.closest('.key[data-n]'); if (k) { Sound.play('keypad'); push(k.dataset.n); } };
    p2.querySelector('.cancel').onclick = () => { if (busy) return; Sound.play('click'); if (entry) { entry = entry.slice(0, -1); renderDots(); } else hidePin(); };
    p2.querySelector('.emerg').onclick = () => { pending = null; emergency(); };
    renderShortcuts(); renderDots();   /* os pontos são criados aqui: 4 ou 6, conforme o código da conta */
    const ring = p1.querySelector('.lock-ring'); ringSig = ''; paintRing();
    ring.addEventListener('pointerdown', e => e.stopPropagation());
    ring.onclick = e => { e.stopPropagation(); if (inGallery()) return; Sound.play('click'); requestUnlock(() => System.openApp('settings')); };
    /* swipe up → código (o ecrã acompanha o dedo e volta com mola se largar cedo) + LONG PRESS (550 ms) numa zona vazia → galeria de personalização */
    let sy = 0, sx = 0, on = false, drag = false, lp = null, lpHint = null;
    const follow = dy => { p1.style.transition = 'none'; p1.style.transform = `translateY(${-dy * .45}px)`; p1.style.opacity = String(Math.max(0, 1 - dy / 260)); topEl.style.transition = 'none'; topEl.style.transform = `translateY(${-dy * .2}px)`; };
    const release = () => { p1.style.transition = ''; p1.style.transform = ''; p1.style.opacity = ''; topEl.style.transition = ''; topEl.style.transform = ''; };
    const lpCancel = () => { clearTimeout(lp); lp = null; clearTimeout(lpHint); lpHint = null; el.classList.remove('press-hint'); };
    p1.addEventListener('pointerdown', e => { if (inGallery()) return; if (e.target.closest('.ls-btn,.notif-card,.nhead,.lw,.lkw,.lock-np,.island,.hb-zone,.home-bar,.lke-handle,.ls-rm,.lke-row')) return; if (e.button && e.pointerType === 'mouse') return; sy = e.clientY; sx = e.clientX; on = true; drag = false; try { p1.setPointerCapture(e.pointerId); } catch (x) {}
      /* long press: aos 150 ms um encolher subtil (.995); aos 550 ms sem mexer >10 px → micro "pop" e abre a galeria (com autenticação) */
      lpCancel(); lpHint = setTimeout(() => el.classList.add('press-hint'), 150);
      lp = setTimeout(() => { lp = null; clearTimeout(lpHint); on = false; release(); el.classList.remove('press-hint'); el.classList.add('press-pop'); setTimeout(() => el.classList.remove('press-pop'), 170); if (window.LockGallery) LockGallery.request(); }, 550); });
    p1.addEventListener('pointermove', e => { if (!on) return; if (lp && Math.hypot(e.clientX - sx, e.clientY - sy) > 10) lpCancel(); const dy = sy - e.clientY; if (dy > 8) { drag = true; follow(dy); } else if (drag) follow(0); });
    /* puxar para BAIXO (dy < −40 em px do ecrã) abre o Centro de Notificações, como no PearPhone; tocar numa notificação lá dentro continua a pedir o código (notify.js) */
    p1.addEventListener('pointerup', e => { const had = !!lp; lpCancel(); if (!on) return; on = false; const dy = sy - e.clientY; release();
      if (-dy / (UI.zoom() || 1) > 40 && !inGallery()) { if (window.Notify && Notify.openNC) Notify.openNC(); return; }
      if (had && (dy > 30 || Math.abs(dy) < 6)) faceOrPin(); else if (!had && dy > 30) faceOrPin(); });
    p1.addEventListener('pointercancel', () => { lpCancel(); on = false; release(); });
    /* feedback imediato nas teclas do código (CEF nem sempre aplica :active com pointer events) */
    kp.addEventListener('pointerdown', e => { const k = e.target.closest('.key[data-n]'); if (k) pressKey(k); });
  }

  /* ================= NOVA UI 8.5 (Android) =================
     Medidas do ecrã bloqueado da One UI 8.5 (Figma 451×978) passadas para os 440×956 do ecrã: cadeado a 47, data
     a 130, relógio a 175 (112 px, entrelinha 82, 12 de folga entre as horas e os minutos), widgets 138×62 por baixo,
     "Deslize para desbloquear" centrado a 824, atalhos de 48 px e a Now Bar de 248×64 na linha de 860.
     As classes são todas als-* (a página é uma só) e as que o resto do sistema procura ficam com o nome de sempre:
     .lock-p1/.lock-p2 (gestos e código), .lock-notifs (notify.js e o espreitar do system.js), .lock-np (a Now Bar
     vive no mesmo anfitrião do cartão "A tocar"), .lock-widgets/.lock-shortcuts (editor) e .lock-face (Face Key). */
  const FP_SVG = '<svg class="als-fpg" viewBox="0 0 48 48" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M11.5 12.6a17.6 17.6 0 0 1 25 0"/><path d="M7.6 21.4a16.8 16.8 0 0 1 32.8 0"/><path d="M13.4 37.4a26 26 0 0 1-2.2-10.6v-3.2a12.8 12.8 0 0 1 25.6 0v3.6"/><path d="M18.6 41.4a29 29 0 0 1-2.8-12.6v-5.2a8.2 8.2 0 0 1 16.4 0v5.6c0 2.6 1.9 4.4 4.4 4.4"/><path d="M24 23.6v5.6c0 5.4 1.8 9.8 5.2 13.2"/><path d="M36.2 38.6c-2.9-.2-5.4-2-6.6-4.6"/></svg>';
  /* glifos CHEIOS do ecrã bloqueado da Nova UI (no Figma da One UI 8.5 o cadeado, os atalhos e o tempo da data são formas
     cheias, não traços): cadeado fechado e aberto (corpo com o buraco da chave), câmara com a lente em dois tons e os ícones
     do tempo. Desenhos próprios no quadrado 24×24; o PearOS continua com os glifos de traço (lockG devolve os de sempre) */
  const A_BODY = 'M7.5 10.05h9a2.2 2.2 0 0 1 2.2 2.2v6.7a2.2 2.2 0 0 1-2.2 2.2h-9a2.2 2.2 0 0 1-2.2-2.2v-6.7a2.2 2.2 0 0 1 2.2-2.2zM12 13.15a1.3 1.3 0 0 0-.8 2.32v1.98a.8.8 0 0 0 1.6 0v-1.98A1.3 1.3 0 0 0 12 13.15z';
  const A_LOCK = `<svg class="als-lkg" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-width="1.5" d="M8.35 10.4V7.35a3.65 3.65 0 0 1 7.3 0v3.05"/><path fill="currentColor" fill-rule="evenodd" d="${A_BODY}"/></svg>`;
  const A_UNLOCK = `<svg class="als-lkg" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" d="M15.65 10.4V5.6a3.65 3.65 0 0 0-7.3 0v.9"/><path fill="currentColor" fill-rule="evenodd" d="${A_BODY}"/></svg>`;
  const A_CAM = '<svg viewBox="0 0 24 24"><path fill="currentColor" fill-rule="evenodd" d="M6 5.1h12a3 3 0 0 1 3 3v8.7a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3V8.1a3 3 0 0 1 3-3zM12 7.55a4.9 4.9 0 1 0 0 9.8 4.9 4.9 0 0 0 0-9.8zM5.45 6.75a.82.82 0 1 0 0 1.64.82.82 0 0 0 0-1.64z"/>'
    + '<path fill="currentColor" fill-opacity=".3" fill-rule="evenodd" d="M12 7.55a4.9 4.9 0 1 0 0 9.8 4.9 4.9 0 0 0 0-9.8zm0 1.63a3.27 3.27 0 1 1 0 6.54 3.27 3.27 0 0 1 0-6.54z"/>'
    + '<path fill="currentColor" fill-opacity=".55" fill-rule="evenodd" d="M12 9.18a3.27 3.27 0 1 0 0 6.54 3.27 3.27 0 0 0 0-6.54zm0 1.64a1.63 1.63 0 1 1 0 3.26 1.63 1.63 0 0 1 0-3.26z"/></svg>';
  const lockG = open => builtOS === 'android' ? (open ? A_UNLOCK : A_LOCK) : g(open ? 'unlock' : 'lock');
  /* atalhos com glifo cheio (telefone e câmara, os de origem); os outros ficam com o glifo de sempre */
  const scG = k => k === 'phone' ? g('phoneFill') : k === 'camera' ? A_CAM : g(CONTROLS[k].icon);
  /* tempo da linha da data: nuvem e lua cheias, sol cheio com raios, gotas/raio/neve/neblina por baixo da nuvem */
  const A_CLOUD = 'M17.5 19H9a7 7 0 1 1 6.7-9h1.8a4.5 4.5 0 1 1 0 9Z';
  const wxSvg = s => `<svg viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${s}</svg>`;
  const A_WX = {
    sun: '<circle cx="12" cy="12" r="4.6" stroke="none"/><path fill="none" d="M12 1.8v1.9M12 20.3v1.9M4.8 4.8l1.3 1.3M17.9 17.9l1.3 1.3M1.8 12h1.9M20.3 12h1.9M6.1 17.9l-1.3 1.3M19.2 4.8l-1.3 1.3"/>',
    moon: '<path stroke="none" d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/>',
    cloud: `<path stroke="none" d="${A_CLOUD}"/>`,
    rain: `<path stroke="none" transform="translate(1.2 -2.4) scale(.9)" d="${A_CLOUD}"/><path fill="none" d="M8 18.6l-1 2.6M12.5 18.6l-1 2.6M17 18.6l-1 2.6"/>`,
    storm: `<path stroke="none" transform="translate(1.2 -2.4) scale(.9)" d="${A_CLOUD}"/><path stroke="none" d="M12.6 15.2 9.4 19.6h2.4l-.9 3.4 3.6-4.8h-2.4l1.2-3z"/>`,
    fog: `<path stroke="none" transform="translate(1.2 -3.2) scale(.9)" d="${A_CLOUD}"/><path fill="none" d="M4 18h16M7 21.6h10"/>`,
  };
  const wxG = ic => A_WX[ic] ? wxSvg(A_WX[ic]) : g(ic);
  const slot = () => '<span class="als-d"><span class="n"></span></span>';
  function buildAndroid() {
    el.innerHTML = `<div class="lock-face als-lk">${A_LOCK}</div>
      <div class="als-top"><div class="als-date"><span class="als-dt"></span><span class="als-wx"></span></div>
        <div class="als-clock" aria-label="hora"><div class="als-row">${slot()}${slot()}</div><div class="als-row">${slot()}${slot()}</div></div></div>
      <div class="lock-p1 als-p1"><div class="lock-widgets"></div><div class="als-nbox"><div class="lock-notifs"></div></div>
        <div class="als-hint">${L.t('Deslize para desbloquear')}</div><div class="als-tip"></div>
        <div class="als-mx"></div><div class="lock-np"></div><div class="lock-shortcuts"></div></div>
      <div class="als-fp" role="button" aria-label="${UI.esc(L.t('Impressão digital'))}"><i class="als-fp-ring"></i>${FP_SVG}</div>
      <div class="lock-p2 als-p2">
        <div class="als-ph"><div class="als-ph-lk">${A_LOCK}</div><div class="als-pt">${L.t('Introduza o PIN')}</div><div class="als-ps"></div></div>
        <div class="als-field"><div class="als-dots"></div></div>
        <div class="als-pad"></div>
        <div class="als-pfoot"><span class="als-emerg">${L.t('Chamada de emergência')}</span><span class="als-cancel">${L.t('Cancelar')}</span></div></div>`;
    p1 = el.querySelector('.lock-p1'); p2 = el.querySelector('.lock-p2'); dotsEl = p2.querySelector('.als-dots'); labelEl = p2.querySelector('.als-pt'); pcClock = null;
    topEl = el.querySelector('.als-top'); clockEl = topEl.querySelector('.als-clock'); dateEl = topEl.querySelector('.als-dt');
    R = { sub: p2.querySelector('.als-ps'), cancel: p2.querySelector('.als-cancel'), emerg: p2.querySelector('.als-emerg'), hint: p1.querySelector('.als-hint'), tip: p1.querySelector('.als-tip'),
      fp: el.querySelector('.als-fp'), wx: topEl.querySelector('.als-wx'), mx: p1.querySelector('.als-mx'), digits: [...clockEl.querySelectorAll('.als-d')], wxSig: '' };
    /* teclado 3×4 da Nova UI: 1 a 9, depois apagar · 0 · OK. Dígitos grandes sem círculo, letras pequenas por baixo */
    const key = (n, l) => `<div class="als-key" data-n="${n}"><span class="als-kn">${n}</span><span class="als-kl">${l || ''}</span></div>`;
    kp = p2.querySelector('.als-pad');
    kp.innerHTML = KEYS.slice(0, 9).map(([n, l]) => key(n, l)).join('') + `<div class="als-key als-kdel" data-k="del" aria-label="${UI.esc(L.t('Apagar'))}">${g('backspace')}</div>` + key('0', '') + '<div class="als-key als-kok" data-k="ok">OK</div>';
    kp.onclick = e => { const k = e.target.closest('.als-key'); if (!k) return; Sound.play('keypad');
      if (k.dataset.n) push(k.dataset.n); else if (k.dataset.k === 'del') backKey(); else if (k.dataset.k === 'ok') okKey(); };
    kp.addEventListener('pointerdown', e => { const k = e.target.closest('.als-key'); if (k) pressKey(k); });
    R.cancel.onclick = () => { if (busy) return; Sound.play('click'); hidePin(); };
    R.emerg.onclick = () => { pending = null; emergency(); };
    bindFingerprint(R.fp);
    renderShortcuts(); renderDots(); paintFp();
    /* deslizar em QUALQUER direção desbloqueia (o ecrã acompanha o dedo, só transform/opacity); puxar para baixo a partir da metade
       de cima abre o painel de notificações; manter premido (550 ms) abre o editor; um toque mostra a dica */
    const PANEL_ZONE = 330;
    let s = null, lp = null, lpHint = null;
    const lpCancel = () => { clearTimeout(lp); lp = null; clearTimeout(lpHint); lpHint = null; el.classList.remove('press-hint'); };
    p1.addEventListener('pointerdown', e => { if (inGallery()) return; if (e.target.closest('.als-sc,.notif-card,.nhead,.ncount,.als-w,.lock-np,.als-mx,.island,.hb-zone,.home-bar')) return; if (e.button && e.pointerType === 'mouse') return;
      const z = UI.zoom() || 1, r = UI.screen().getBoundingClientRect(), now = Date.now();
      s = { x: e.clientX, y: e.clientY, z, y0: (e.clientY - r.top) / z, lx: e.clientX, ly: e.clientY, lt: now, v: 0, mode: null };
      try { p1.setPointerCapture(e.pointerId); } catch (x) {}
      if (R.mx && R.mx.classList.contains('on')) closeMx();
      lpCancel(); lpHint = setTimeout(() => el.classList.add('press-hint'), 150);
      lp = setTimeout(() => { lp = null; clearTimeout(lpHint); s = null; followA(0, 0, 0, true); el.classList.remove('press-hint'); el.classList.add('press-pop'); setTimeout(() => el.classList.remove('press-pop'), 170); if (window.LockGallery) LockGallery.request(); }, 550); });
    p1.addEventListener('pointermove', e => { if (!s) return; const dx = (e.clientX - s.x) / s.z, dy = (e.clientY - s.y) / s.z, d = Math.hypot(dx, dy), now = Date.now();
      s.v = Math.hypot(e.clientX - s.lx, e.clientY - s.ly) / s.z / Math.max(1, now - s.lt); s.lx = e.clientX; s.ly = e.clientY; s.lt = now;
      if (lp && d > 10) lpCancel();
      if (!s.mode && d > 8) { s.mode = dy > 0 && dy > Math.abs(dx) && s.y0 < PANEL_ZONE ? 'panel' : 'unlock'; if (s.mode === 'panel') panelPull('start'); }
      if (s.mode === 'unlock') followA(dx, dy, d); else if (s.mode === 'panel') panelPull('move', dy); });
    p1.addEventListener('pointerup', e => { const had = !!lp; lpCancel(); if (!s) return; const st = s; s = null;
      const dx = (e.clientX - st.x) / st.z, dy = (e.clientY - st.y) / st.z, d = Math.hypot(dx, dy), v = Date.now() - st.lt > 90 ? 0 : st.v;
      if (st.mode === 'panel') { panelPull('end', dy, dy > 90 || (v > .5 && dy > 30)); return; }
      if (st.mode === 'unlock') { if (!inGallery() && (d > 110 || (v > .45 && d > 36))) { followA(0, 0, 0, true); faceOrPin(); } else followA(0, 0, 0, true); return; }
      if (had) tapHint(); });
    p1.addEventListener('pointercancel', () => { lpCancel(); if (s && s.mode === 'panel') panelPull('end', 0, false); s = null; followA(0, 0, 0, true); });
  }
  /* o ecrã acompanha o dedo: o conteúdo afasta-se na direção do gesto, encolhe e desvanece (Nova UI). `off` repõe (com a transição do CSS) */
  function followA(dx, dy, d, off) {
    const list = [p1, topEl, R.fp];
    if (off) { list.forEach(n => { if (!n) return; n.style.transition = ''; n.style.transform = ''; n.style.opacity = ''; }); return; }
    const k = Math.min(1, d / 300), o = String((1 - k * .85).toFixed(3));
    const put = (n, f, sc) => { if (!n) return; n.style.transition = 'none'; n.style.opacity = o; if (f != null) n.style.transform = `translate(${(dx * f).toFixed(1)}px,${(dy * f).toFixed(1)}px) scale(${(1 - k * sc).toFixed(4)})`; };
    put(p1, .2, .05); put(topEl, .12, .08); put(R.fp, null);
  }
  /* puxar para baixo na metade de cima: o painel de notificações acompanha o dedo (QuickPanel.pull*, do painel Android); sem ele abre no fim */
  function panelPull(ph, dy, open) {
    const q = window.QuickPanel && typeof QuickPanel.pullStart === 'function' ? QuickPanel : null;
    try {
      if (ph === 'start') { if (q) q.pullStart('notif'); return; }
      if (ph === 'move') { if (q) q.pullMove('notif', Math.max(0, Math.min(1, (dy || 0) / 420))); return; }
      if (q) { q.pullEnd('notif', !!open); return; }
      if (open && window.Notify && Notify.openNC) Notify.openNC();
    } catch (e) { console.error('[apex_phone] lock panel', e); }
  }
  /* um toque no ecrã: com o sensor à vista aparece a dica por cima dele; sem ele, a frase de baixo dá um pequeno salto */
  let tipT = null;
  function tip(t) { if (!R.tip) return; clearTimeout(tipT);
    /* com o teclado do PIN aberto a dica vai para a linha de estado dele (a de baixo do título), sem cor de erro */
    if (el.classList.contains('pin') && R.sub) { if (R.sub.classList.contains('err')) return; R.sub.textContent = t; tipT = setTimeout(() => { if (R.sub && R.sub.textContent === t && !R.sub.classList.contains('err')) R.sub.textContent = ''; }, 1900); return; }
    R.tip.textContent = t; R.tip.classList.add('on'); tipT = setTimeout(() => R.tip && R.tip.classList.remove('on'), 1900); }
  function tapHint() {
    if (!R.hint) return;
    if (fpOn()) { tip(L.t('Use a impressão digital ou deslize para desbloquear')); return; }
    R.hint.classList.remove('nudge'); void R.hint.offsetWidth; R.hint.classList.add('nudge');
  }
  function backKey() { if (busy || coolLeft()) return; entry = entry.slice(0, -1); renderDots(); }
  /* OK com o PIN incompleto: não vai ao servidor (não gasta tentativas), só treme */
  function okKey() {
    if (busy || coolLeft() || !entry) return;
    if (entry.length === pinLen()) { check(); return; }
    busy = true; const seq = ++checkSeq; say(PT().wrong, true); dotsEl.classList.add('shake', 'err'); Sound.play('error');
    setTimeout(() => { if (seq !== checkSeq) return; dotsEl.classList.remove('shake'); entry = ''; busy = false; renderDots(); setTimeout(() => dotsEl.classList.remove('err'), 250); }, 560);
  }

  /* ---------- IMPRESSÃO DIGITAL (sensor no ecrã) ----------
     Com dedos registados (Definições escrevem fpEnrolled) e "Desbloquear com a impressão digital" ligado (fpUnlock), o ícone
     aparece em baixo ao centro, no ecrã bloqueado e no teclado do PIN. Manter o dedo ~450 ms → anel de leitura → entra pelo
     MESMO caminho que o Face Key usa para saltar o código (authed + unlock), ou confirma a verificação da galeria.
     Sem PIN não há impressão digital (como na Nova UI: os dados biométricos exigem um bloqueio de ecrã). */
  /* STOLEN: telemóvel de OUTRA pessoa (Config.StolenPhones; o account.get traz `foreign`): a biometria é do dono, nunca de
     quem o tem na mão - nem impressão digital nem Face Key, só o código (verificado no servidor) */
  const foreignAcct = () => { const a = System.account; return !!(a && a.foreign); };
  const fpOn = () => isAnd() && System.state.fpUnlock === true && (+System.state.fpEnrolled || 0) > 0 && !noPin() && !foreignAcct();
  function paintFp() { if (el) el.classList.toggle('als-fpon', fpOn()); }
  let fpT = null;
  function bindFingerprint(fp) {
    if (!fp) return;
    const stop = () => { clearTimeout(fpT); fpT = null; fp.classList.remove('read'); };
    fp.addEventListener('pointerdown', e => { e.stopPropagation(); if (!System.locked || busy || inGallery() || !fpOn()) return; if (e.button && e.pointerType === 'mouse') return;
      try { fp.setPointerCapture(e.pointerId); } catch (x) {}
      stop(); fp.classList.remove('ok'); void fp.offsetWidth; fp.classList.add('read');
      fpT = setTimeout(() => { fpT = null; fp.classList.remove('read'); fp.classList.add('ok'); Sound.play('tock');
        setTimeout(() => { fp.classList.remove('ok'); bioPass(); }, 200); }, 450); });
    const up = e => { e.stopPropagation(); if (!fpT) return; stop(); tip(L.t('Mantenha o dedo no sensor')); };
    fp.addEventListener('pointerup', up); fp.addEventListener('pointercancel', e => { e.stopPropagation(); stop(); });
    fp.addEventListener('click', e => e.stopPropagation());
  }
  /* biometria aceite: conta como autenticação (o mesmo que o Face Key reconhecido) */
  function bioPass() {
    if (!System.locked) return;
    lastAuth = Date.now();
    /* verificação da galeria/editor: confirma e fica bloqueado (como o PIN nesse modo, não deixa o ecrã "aberto") */
    if (verifyOnly) { const f = verifyOnly; verifyOnly = null; el.classList.add('ok'); setTimeout(() => { hidePin(); busy = false; f(); }, 260); return; }
    authed = true; const face = el.querySelector('.lock-face'); if (face) { face.innerHTML = lockG(true); face.classList.add('ok'); }
    unlock();
  }
  function pressKey(k) { if (!k) return; k.classList.add('pressed'); clearTimeout(k._t); k._t = setTimeout(() => k.classList.remove('pressed'), 150); }
  /* ---------- EMERGÊNCIA (botão do teclado do código) ----------
     Era `PhoneApp.call('112', 'Emergência')`: o 112 não é o número de ninguém neste servidor (não há mapa
     de números de emergência no server/calls.lua), a chamada voltava sempre `offline` e o único resultado
     era uma entrada em Recentes. O sistema de emergência a sério é a app Serviços: aqui pede-se ajuda à
     Polícia ou ao EMS - com as coordenadas reais do jogador, pelo mesmo RPC da app (services.request) -
     sem desbloquear o telemóvel. Quem responde é quem está em serviço; o servidor diz se não há ninguém. */
  /* QUAIS os serviços de emergência é decisão do servidor (Config.Services), não desta lista: um servidor pode
     renomear a polícia para 'lspd' ou ter um terceiro serviço de emergência. Enquanto o `services.list` não trouxer
     a marca `emergency`, vale esta lista de recurso - os ids de origem do config.lua. Assim que UM serviço vier
     marcado, manda o servidor e isto deixa de contar (ver `pedidosCruzados`: o campo no config.lua e no services.lua). */
  const EMERG = ['police', 'ems'];
  const emergOf = l => { const marcados = l.some(s => s && s.emergency !== undefined); return l.filter(s => s && (marcados ? s.emergency === true : EMERG.includes(s.id))); };
  let emergBusy = false;
  async function emergency() {
    if (emergBusy) return; emergBusy = true; Sound.play('click');
    try {
      /* sem rede o pedido não sai: o modo de voo tem efeito mesmo (CC.online) e diz-se porquê */
      if (window.CC && CC.online && !CC.online()) {
        const air = !!System.state.airplane;
        const r = await UI.alert({ title: air ? L.t('Modo de voo ligado') : L.t('Sem rede'), msg: air ? 'Com o modo de voo ligado o pedido não chega aos serviços.' : 'Liga o Wi-Fi ou os dados móveis para pedir ajuda.',
          buttons: air ? [{ label: L.t('Cancelar'), value: false }, { label: 'Desligar modo de voo', bold: true, value: true }] : [{ label: 'OK', bold: true, value: false }] });
        if (!r || r.value !== true) return;
        System.setState({ airplane: false, cellular: true });
      }
      /* rpcRaw e não rpc: o Bridge.rpc troca { error } por null e um limite de ritmo, um erro passageiro ou a base
         de dados ainda a arrancar caíam no MESMO ramo da lista vazia - o jogador lia "este servidor não tem
         serviços de emergência configurados", uma afirmação sobre a configuração do servidor que podia ser falsa. */
      let list = null; try { list = await Bridge.rpcRaw('services.list'); } catch (e) { list = null; }
      /* uma tabela Lua VAZIA (Config.Services sem nada) chega cá como {} e não como []: é uma lista vazia, não
         um erro. Sem esta linha o jogador lia "não consegui falar com o servidor" de uma resposta que chegou
         perfeitamente - a mesma mentira, ao contrário, que este bloco foi corrigir. */
      if (list && typeof list === 'object' && !Array.isArray(list) && list.error == null) list = [];
      if (!Array.isArray(list)) { Sound.play('error');
        await UI.alert({ title: 'Não foi possível pedir ajuda', msg: list && list.error === 'ratelimit' ? 'Estás a pedir depressa demais. Espera uns segundos e tenta outra vez.' : 'Não consegui falar com o servidor. Tenta outra vez.' }); return; }
      const svc = emergOf(list);
      if (!svc.length) { await UI.alert({ title: 'Emergência indisponível', msg: 'Este servidor não tem serviços de emergência configurados.' }); return; }
      const v = await UI.actionSheet({ title: L.t('Emergência'), buttons: svc.map(s => ({ label: s.label, value: s.id, icon: s.icon })) });
      const s = svc.find(x => x.id === v); if (!s) return;
      let coords = null; try { coords = await Bridge.call('getCoords'); } catch (e) {}
      /* rpcRaw: o Bridge.rpc troca { error } por null e perdia-se o 'nobody'/'cooldown' do servidor */
      let r = null; try { r = await Bridge.rpcRaw('services.request', { service: s.id, description: 'Pedido de emergência feito no ecrã bloqueado', coords: coords || null }); } catch (e) {}
      if (r && !r.error) { Sound.play('success'); await UI.alert({ title: s.label + ' · pedido enviado', msg: (coords ? 'Enviei a tua localização. ' : 'Não consegui obter a tua localização. ') + 'Vais ser notificado quando alguém aceitar.' }); }
      else { Sound.play('error'); await UI.alert({ title: 'Não foi possível pedir ajuda', msg: r && r.error === 'nobody' ? `Não há ${s.label} em serviço neste momento.` : r && r.error === 'cooldown' ? `Já pediste há pouco. Espera ${Math.max(1, Math.ceil(Number(r.wait) || 1))} s.` : 'Tenta outra vez.' }); }
    } finally { emergBusy = false; }
  }
  /* als-edit: o editor do ecrã bloqueado da Nova UI (lockgallery.js) */
  const inGallery = () => { const s = UI.screen(); return !!(s && (s.classList.contains('lsg') || s.classList.contains('lsg-closing') || s.classList.contains('als-edit'))); };
  /* ---------- atalhos inferiores configuráveis (galeria › Personalizar › Controlos): lanterna e câmara por defeito ---------- */
  /* 1.4.0 (PearOS 27, galeria de controlos do editor): os rótulos são chaves PT (quem mostra embrulha com L.t). `toggle` = interruptor
     que acende o botão (.on, a partir de on()) e NÃO pede o código (lanterna, Modo escuro, Não incomodar: como no iOS); os que abrem
     uma app passam pelo requestUnlock. `glyph` (opcional) = desenho próprio quando o Icons não tem o glifo certo (o Modo escuro é o
     círculo meio cheio do iOS; a lua fica para o Não incomodar). Modo escuro / Não incomodar fazem exatamente o que o mosaico do
     Centro de controlo faz (CC.tap: tema explícito; foco com o último modo usado); sem CC há o mesmo efeito direto. */
  const G_HALF = '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 3a9 9 0 0 1 0 18z" fill="currentColor" stroke="none"/></svg>';
  const ccTap = k => { try { if (window.CC && typeof CC.tap === 'function' && CC.tap(k) !== false) return; } catch (e) { console.error('[apex_phone] lock control', k, e); }
    const S = System.state; if (k === 'darkmode') System.setState({ theme: S.dark ? 'light' : 'dark' }); else if (k === 'eyecomfort') System.setState({ nightShift: !S.nightShift }); else if (k === 'lowpower') System.setState({ lowPower: !S.lowPower }); };
  /* 1.4.1 (galeria de controlos, captura 6): interruptores de rede. CC.toggleNet é o caminho do Centro de controlo (modo de voo desliga o
     resto, Bluetooth larga os earbuds) e funciona com o ecrã bloqueado, como no iOS: nada aqui pede o código. */
  const netOn = k => { try { if (window.CC && CC.tileOn) return !!CC.tileOn(k); } catch (e) {} return !!System.state[k]; };
  const netTap = k => { if (window.CC && CC.toggleNet) CC.toggleNet(k); else System.setState({ [k]: !System.state[k] }); paintToggles(); };
  /* Foco: cada botão liga o SEU modo (CC.focus.set) e só acende com esse modo ativo; tocar outra vez desliga. Antes o "Não incomodar"
     acendia com qualquer foco (o dnd é o interruptor mestre dos três) e o toque repunha o último modo usado em vez do dele. */
  const focusNow = () => { try { if (window.CC && CC.focus) return CC.focus.of(); } catch (e) {} const S = System.state; return S.dnd ? (S.focus && S.focus !== 'none' ? S.focus : 'dnd') : 'none'; };
  const focusTap = mode => { const m = focusNow() === mode ? 'none' : mode; if (window.CC && CC.focus) CC.focus.set(m); else System.setState(m === 'none' ? { dnd: false, focus: 'none' } : { dnd: true, focus: m, focusLast: m }); paintToggles(); };
  /* "Gravar vídeo": o CamView não recebe opções do openApp nem tem API de modo; o caminho que já existe é o do atalho "Selfie" (photos.js):
     esperar pelo 'app:open' (à primeira vez aparece antes o pedido de permissão) e carregar no modo Vídeo da faixa da câmara. */
  function openVideo() { const go = () => { const s = document.querySelectorAll('.cam-modes span')[1]; if (s) s.click(); };
    if (System.currentApp() === 'camera') { go(); return; }
    const off = Bridge.on('app:open', id => { if (id !== 'camera') return; off(); setTimeout(go, 0); });
    setTimeout(off, 20000); System.openApp('camera', null, { allowLocked: true }); }
  /* Música ambiente (Dormir, Relaxar, Produtividade, Bem-estar): Music.playQuery toca sem abrir a app e sem desbloquear (o que a Vera usa).
     A busca é em inglês de propósito (o catálogo é mundial) e nunca se mostra. Tocar outra vez no botão aceso pausa. */
  const ambCtx = q => { const m = window.Music, mu = m && m.MU; return mu && mu.ctx && mu.ctx.k === 'search' && mu.ctx.label === 'Pesquisa · ' + q ? mu : null; };
  const ambTap = q => { const m = window.Music; if (!m || !m.playQuery) return; const mu = ambCtx(q);
    if (mu && mu.now) { m.pauseResume(); paintToggles(); return; }
    Promise.resolve(m.playQuery(q)).then(s => { if (!s) UI.toast(L.t('Sem resultados')); paintToggles(); }).catch(() => UI.toast(L.t('Sem resultados'))); };
  /* glifos desenhados aqui: a cama (o Icons não tem) e os quatro da música ambiente - a nota + um sinal pequeno por cima, como na captura 6 */
  const G_SVG = inner => `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${inner}</svg>`;
  const G_BED = G_SVG('<path d="M3 5.5V19M3 15.5h18V19M21 15.5v-2.2a3 3 0 0 0-3-3h-7.2v5.2"/><circle cx="7" cy="11.2" r="1.9"/>');
  const G_NOTE = '<path d="M13.6 18.6V9.7l7-1.6v8.6"/><circle cx="11.4" cy="18.6" r="2.2" fill="currentColor" stroke="none"/><circle cx="18.4" cy="16.7" r="2.2" fill="currentColor" stroke="none"/>';
  /* avail: com Config.Music.Search = false o servidor não pesquisa e estes botões nunca tocariam nada: a secção nem aparece na galeria */
  const ambCtl = (label, q, sign) => ({ icon: 'music', glyph: G_SVG(sign + G_NOTE), label, toggle: true, avail: () => !!(window.Music && Music.playQuery && !(Music.MU && Music.MU.search === false)), on: () => { const mu = ambCtx(q); return !!(mu && mu.playing); }, run: () => ambTap(q) });
  const CONTROLS = {
    torch: { icon: 'flashlight', label: 'Lanterna', cls: 'torch', toggle: true, on: () => !!System.state.torch, run: () => { System.torch(!System.state.torch); const b = el.querySelector('.ls-btn.torch,.als-sc.als-c-torch'); if (b) b.classList.toggle('on', !!System.state.torch); } },
    /* Telefone: o atalho de origem da Nova UI (à esquerda). Abre a app depois do desbloqueio, como os outros que não são a câmara */
    phone: { icon: 'phone', label: 'Telefone', run: () => requestUnlock(() => System.openApp('phone')) },
    camera: { icon: 'camera', label: 'Câmara', cls: 'cam', run: () => System.openApp('camera', null, { allowLocked: true }) },
    timer: { icon: 'timer', label: 'Temporizador', run: () => requestUnlock(() => System.openApp('clock')) },
    calc: { icon: 'calc', label: 'Calculadora', run: () => requestUnlock(() => System.openApp('calculator')) },
    notes: { icon: 'pen', label: 'Notas', run: () => requestUnlock(() => System.openApp('notes')) },
    alarm: { icon: 'alarm', label: 'Alarmes', run: () => requestUnlock(() => System.openApp('clock')) },
    music: { icon: 'music', label: 'Música', run: () => requestUnlock(() => System.openApp('music')) },   /* chamava-se "Reconhecer música" e abria a app: não há reconhecimento de música em sítio nenhum */
    /* Carteira: o Icons não tem glifo "wallet" (só o ícone da app); o cartão lê-se como carteira e existe nos dois sistemas */
    wallet: { icon: 'card', label: 'Carteira', run: () => requestUnlock(() => System.openApp('wallet')) },
    photos: { icon: 'photo', label: 'Fotos', run: () => requestUnlock(() => System.openApp('photos')) },
    darkmode: { icon: 'moon', glyph: G_HALF, label: 'Modo escuro', toggle: true, on: () => !!System.state.dark, run: () => ccTap('darkmode') },
    dnd: { icon: 'moon', label: 'Não incomodar', toggle: true, on: () => focusNow() === 'dnd', run: () => focusTap('dnd') },
    /* 1.4.1: as secções da galeria (captura 6). Chaves curtas: vão gravadas em lockControls / lockScreens[].controls */
    video: { icon: 'video', label: 'Gravar vídeo', run: openVideo },
    airplane: { icon: 'airplane', label: 'Modo de voo', toggle: true, on: () => netOn('airplane'), run: () => netTap('airplane') },
    wifi: { icon: 'wifi', label: 'Wi-Fi', toggle: true, on: () => netOn('wifi'), run: () => netTap('wifi') },
    bt: { icon: 'bluetooth', label: 'Bluetooth', toggle: true, on: () => netOn('bt'), run: () => netTap('bt') },
    cellular: { icon: 'cellular', label: 'Dados móveis', toggle: true, on: () => netOn('cellular'), run: () => netTap('cellular') },
    eyecomfort: { icon: 'eye', label: 'Conforto visual', toggle: true, on: () => !!System.state.nightShift, run: () => { ccTap('eyecomfort'); paintToggles(); } },
    lowpower: { icon: 'lowpower', label: 'Modo de poupança', toggle: true, on: () => !!System.state.lowPower, run: () => { ccTap('lowpower'); paintToggles(); } },
    fwork: { icon: 'briefcase', label: 'Trabalho', toggle: true, on: () => focusNow() === 'work', run: () => focusTap('work') },
    fsleep: { icon: 'moon', glyph: G_BED, label: 'Dormir', toggle: true, on: () => focusNow() === 'sleep', run: () => focusTap('sleep') },
    ambsleep: ambCtl('Dormir', 'sleep ambient music', '<path d="M2.6 3.2h5.2L2.6 9.4h5.2"/>'),
    ambchill: ambCtl('Relaxar', 'chill lofi beats', '<circle cx="6.2" cy="6.6" r="2.4"/><path d="M6.2 1.4v.9M1 6.6h.9M2.5 2.9l.7.7M9.9 2.9l-.7.7"/>'),
    ambwork: ambCtl('Produtividade', 'deep focus music', '<path d="M2.2 6.4l2.5 2.7L9.8 3.2"/>'),
    ambwell: ambCtl('Bem-estar', 'meditation calm music', '<path fill="currentColor" stroke="none" d="M6.2 10.8 2.2 6.9a2.4 2.4 0 0 1 3.4-3.4l.6.6.6-.6a2.4 2.4 0 0 1 3.4 3.4z"/>'),
    none: { icon: '', label: 'Nenhum' },
  };
  /* a ordem da galeria de controlos (lockeditor.js): a grelha de cima (sem título, como na captura 6), depois as secções; 'none' fica no fim.
     CONTROL_TOP e CONTROL_SECTIONS dizem onde cada um aparece (Câmara, Fotos, Modo escuro e Não incomodar estão nos dois sítios, como no iOS).
     `title` é chave PT (quem mostra embrulha com L.t); `avail` (opcional) num controlo tira-o da galeria quando a origem não existe. */
  const CONTROL_TOP = ['torch', 'camera', 'phone', 'calc', 'alarm', 'timer', 'notes', 'music', 'wallet', 'photos', 'darkmode', 'dnd'];
  const CONTROL_SECTIONS = [
    { id: 'capture', title: 'Captura', icon: 'camera', keys: ['camera', 'photos', 'video'] },
    { id: 'net', title: 'Conectividade', icon: 'wifi', keys: ['airplane', 'wifi', 'bt', 'cellular'] },
    { id: 'display', title: 'Ecrã e brilho', icon: 'sun', keys: ['darkmode', 'eyecomfort', 'lowpower'] },
    { id: 'focus', title: 'Foco', icon: 'moon', keys: ['dnd', 'fwork', 'fsleep'] },
    { id: 'ambient', title: 'Música ambiente', icon: 'music', keys: ['ambsleep', 'ambchill', 'ambwork', 'ambwell'] },
  ];
  const CONTROL_ORDER = CONTROL_TOP.concat(...CONTROL_SECTIONS.map(s => s.keys)).filter((k, i, a) => a.indexOf(k) === i).concat('none');
  /* a definição de uma chave gravada em lockControls / lockScreens[].controls, incluindo as VIRTUAIS "app:<id>" ("Abrir app": o botão
     mostra o ícone dessa app e abre-a depois do código). Uma app que já não existe (desinstalada do servidor, recurso parado) → null,
     e quem chama trata como 'none' (o botão fica vazio em vez de rebentar). */
  function controlOf(k) {
    if (typeof k !== 'string' || !k) return null;
    if (k.indexOf('app:') === 0) { const id = k.slice(4); if (!id || !window.App || !App.get(id)) return null;
      return { icon: null, appId: id, label: App.name(id), run: () => requestUnlock(() => System.openApp(id)) }; }
    return Object.prototype.hasOwnProperty.call(CONTROLS, k) ? CONTROLS[k] : null;
  }
  /* o miolo de um botão de controlo (glifo, ou o ícone da app para "app:<id>"): o mesmo para o ecrã bloqueado e para a galeria */
  function controlIcon(k, appCls) { const c = controlOf(k); if (!c || k === 'none') return '';
    if (c.appId) return window.Icons && Icons.tileBox ? Icons.tileBox(c.appId, appCls == null ? 'ls-app' : appCls) : '';
    return c.glyph || (c.icon ? g(c.icon) : ''); }
  /* atalho: por pointer events - só MANTER pressionado (280 ms) ativa; um toque curto só dá o feedback de pressão (spec 22); no modo galeria não faz nada */
  function bindShortcut(b, fn) { let t = null, fired = false;
    b.addEventListener('pointerdown', e => { e.stopPropagation(); if (inGallery()) return; if (e.button && e.pointerType === 'mouse') return; fired = false; b.classList.add('press'); try { b.setPointerCapture(e.pointerId); } catch (x) {} clearTimeout(t); t = setTimeout(() => { if (fired) return; fired = true; b.classList.remove('press'); Sound.play('pop'); fn(); }, 280); });
    const up = e => { e.stopPropagation(); clearTimeout(t); b.classList.remove('press'); };
    b.addEventListener('pointerup', up); b.addEventListener('pointercancel', up); b.addEventListener('click', e => { if (!inGallery()) e.stopPropagation(); fired = false; }); }
  /* Nova UI: o atalho ARRASTA-SE para fora (72 px) para abrir, com um círculo que cresce atrás dele; um toque só diz como se usa */
  function bindShortcutA(b, fn) { let st = null;
    const reset = () => { b.classList.remove('press', 'fire'); b.style.transition = ''; b.style.transform = ''; b.style.removeProperty('--sc-k'); };
    b.addEventListener('pointerdown', e => { e.stopPropagation(); if (inGallery()) return; if (e.button && e.pointerType === 'mouse') return;
      st = { x: e.clientX, y: e.clientY, z: UI.zoom() || 1, d: 0, fired: false }; b.classList.add('press'); try { b.setPointerCapture(e.pointerId); } catch (x) {} });
    b.addEventListener('pointermove', e => { if (!st || st.fired) return; const dx = (e.clientX - st.x) / st.z, dy = (e.clientY - st.y) / st.z; st.d = Math.hypot(dx, dy);
      b.style.transition = 'none'; b.style.transform = `translate(${(dx * .3).toFixed(1)}px,${(dy * .3).toFixed(1)}px)`; b.style.setProperty('--sc-k', Math.min(1, st.d / 72).toFixed(3));
      if (st.d >= 72) { st.fired = true; b.classList.add('fire'); Sound.play('pop'); setTimeout(reset, 280); fn(); } });
    const up = e => { e.stopPropagation(); if (!st) return; const s0 = st; st = null; if (s0.fired) return; reset(); if (s0.d < 10 && !inGallery()) tip(L.t('Deslize o ícone para abrir')); };
    b.addEventListener('pointerup', up); b.addEventListener('pointercancel', e => { e.stopPropagation(); st = null; reset(); });
    b.addEventListener('click', e => { if (!inGallery()) e.stopPropagation(); }); }
  /* predefinição da Nova UI: Telefone à esquerda e Câmara à direita. Uma conta que nunca mudou os atalhos traz a do PearOS
     (lanterna + câmara): no Android lê-se como a predefinição dele. Se for o próprio jogador a escolher lanterna + câmara no editor
     do Android, o ecrã bloqueado atual (lockScreens) fica marcado com ctlOS:'android' e a escolha é respeitada */
  const A_CTL = ['phone', 'camera'];
  const lsNow = () => { const l = System.state.lockScreens; return Array.isArray(l) ? (l.find(x => x && x.id === System.state.lockCurrent) || l[0] || null) : null; };
  function renderShortcuts() { const w = el.querySelector('.lock-shortcuts'); if (!w) return; w.innerHTML = ''; const c0 = System.state.lockControls; const and = builtOS === 'android'; let ctl = Array.isArray(c0) && c0.length === 2 ? c0 : (and ? A_CTL : ['torch', 'camera']);
    if (and && ctl[0] === 'torch' && ctl[1] === 'camera' && (lsNow() || {}).ctlOS !== 'android') ctl = A_CTL;
    ctl.forEach(k => {
      if (and) { const c = (typeof k === 'string' && CONTROLS[k]) || CONTROLS.none; const kk = CONTROLS[k] ? k : 'none'; const b = UI.el(`<div class="als-sc als-c-${kk}${kk === 'none' || !c.icon ? ' none' : ''}" data-glass data-side="${w.children.length}"><i class="als-sc-r"></i>${c.icon ? scG(kk) : ''}</div>`); if (c.run) bindShortcutA(b, c.run); w.appendChild(b); return; }
      /* PearOS 27: controlOf (inclui "app:<id>"); cada botão diz o lado (data-side, o editor abre a galeria desse lado) e a chave
         (data-k), e leva o "menos" (.ls-rm) que só o editor mostra. Uma chave desconhecida ou uma app que já não existe = vazio. */
      const side = w.children.length, c = controlOf(k), kk = c ? k : 'none', inner = kk === 'none' ? '' : controlIcon(kk);
      /* classe com prefixo ls-c-: a chave crua colidia com classes GLOBAIS das apps (".calc" da Calculadora em apps.css pôs o glifo
         21 px acima do centro, e em 1.3.1 até o botão absoluto); torch/cam têm cls próprio (o CSS e o Rail leem .ls-btn.torch/.cam) */
      const cls = kk === 'none' || !inner ? 'none' : c.appId ? 'ls-c-app' : (c.cls || 'ls-c-' + kk);
      const b = UI.el(`<div class="ls-btn lg lg-wp on-lock lg-tone ${cls}${cls === 'none' ? ' none' : ''}" data-k="${UI.esc(kk)}" data-side="${side}">${inner}<i class="ls-rm lg27-badge"></i></div>`);
      if (cls !== 'none' && c.toggle && c.on) b.classList.toggle('on', !!c.on());
      if (cls !== 'none' && c.run) bindShortcut(b, c.run); w.appendChild(b); });
    const tb = el.querySelector('.ls-btn.torch,.als-sc.als-c-torch'); if (tb) tb.classList.toggle('on', !!System.state.torch);
    if (!and && window.Glass) Glass.soon(w);   /* vidro: posição e tom dos botões sobre o fundo (glass27.css) */
    if (and) glassPos(); else if (window.Rail && Rail.refresh) Rail.refresh(); }   /* PearPhone Fold: os atalhos são vidro como a barra direita (posição medida) */
  /* interruptores do ecrã bloqueado (lanterna, Modo escuro, Não incomodar): .on segue o estado; só mexe na classe quando muda */
  function paintToggles() {
    if (!el || builtOS === 'android') return;
    el.querySelectorAll('.lock-shortcuts .ls-btn[data-k]').forEach(b => { const c = controlOf(b.dataset.k); if (!c || !c.toggle || !c.on) return; const on = !!c.on(); if (b.classList.contains('on') !== on) b.classList.toggle('on', on); });
  }
  /* "hoje" na data LOCAL: o toISOString() é UTC e perto da meia-noite mostrava os eventos do dia errado (a app Calendário usa a data local) */
  const localDay = (d = new Date()) => `${d.getFullYear()}-${UI.pad(d.getMonth() + 1)}-${UI.pad(d.getDate())}`;
  /* ---------- METEOROLOGIA: UMA fonte, o tempo REAL do jogo ----------
     Até 2026-09-20 a app tinha quatro cidades inventadas (Math.sin) e cada consumidor o seu número. Agora o
     client/main.lua manda `weather { w: 'RAIN', blackout, hour }` - o tipo de tempo que está no céu (do
     qb-weathersync ou da transição de tempo do próprio jogo) - e este módulo é a única fonte: a app, o widget
     do ecrã principal, o do ecrã bloqueado e a Vera leem `WX.now()`. A temperatura é uma ESTIMATIVA a partir
     do tipo de tempo e da hora (o GTA não tem temperatura); fica dito na app. O último estado grava-se em
     `wxLast` para o arranque (o push chega ~1 s depois do `ready`) e o histórico do dia em `wxHist`.
     Vive aqui porque o index.html carrega este ficheiro antes dos consumidores; `window.WX_FALLBACK` fica
     por compatibilidade (o mesmo objeto que `WX.now()` devolve sem medição). */
  window.WX = (() => {
    /* tipo do jogo → [condição, texto, temperatura-base de dia, vento km/h, humidade %] */
    const TYPES = {
      EXTRASUNNY: ['sunny', 'Céu limpo', 30, 8, 35], CLEAR: ['sunny', 'Limpo', 26, 10, 45], NEUTRAL: ['cloudy', 'Pouco nublado', 22, 12, 50], SMOG: ['fog', 'Neblina', 24, 6, 55],
      FOGGY: ['fog', 'Nevoeiro', 16, 4, 92], OVERCAST: ['cloudy', 'Encoberto', 19, 14, 68], CLOUDS: ['cloudy', 'Nublado', 21, 13, 60], CLEARING: ['cloudy', 'A limpar', 20, 15, 70],
      RAIN: ['rain', 'Chuva', 15, 22, 90], THUNDER: ['storm', 'Trovoada', 14, 38, 88], SNOW: ['snow', 'Neve', -2, 18, 80], BLIZZARD: ['snow', 'Nevão', -8, 55, 85],
      SNOWLIGHT: ['snow', 'Neve fraca', 0, 12, 78], XMAS: ['snow', 'Neve', -3, 10, 80], HALLOWEEN: ['fog', 'Nevoeiro', 12, 9, 85],
    };
    const ICON = { sunny: 'sun', cloudy: 'cloud', rain: 'rain', storm: 'storm', snow: 'snow', fog: 'fog', night: 'moon' };
    const LABEL = { sunny: 'Céu limpo', cloudy: 'Nublado', rain: 'Chuva', storm: 'Trovoada', snow: 'Neve', fog: 'Nevoeiro', night: 'Céu limpo' };
    const hour = () => (window.System && System.gameHour != null) ? System.gameHour : new Date().getHours();
    const isNight = h => h < 6 || h >= 20;
    /* estimativa: base do tipo de tempo, −5° de noite, +2° ao início da tarde */
    const tempFor = (w, h) => { const t = TYPES[w] || TYPES.CLEAR; return Math.round(t[2] + (isNight(h) ? -5 : (h >= 13 && h <= 16 ? 2 : 0))); };
    let cur = null;
    const load = () => { if (cur) return cur; const s = Store.get('wxLast', null); cur = (s && typeof s === 'object' && TYPES[s.w]) ? s : null; return cur; };
    function set(d) {
      if (!d || typeof d !== 'object' || !TYPES[d.w]) return;
      const h = d.hour != null ? +d.hour : hour();
      const prev = load();
      cur = { w: d.w, blackout: !!d.blackout, hour: h, at: Date.now() };
      Store.set('wxLast', cur);
      /* histórico do dia (últimas 12 mudanças): é o que se pode mostrar de "previsão" - o que já esteve */
      if (!prev || prev.w !== d.w) Store.update('wxHist', [], l => { l.push({ w: d.w, hour: h, at: Date.now() }); while (l.length > 12) l.shift(); });
      try { window.Bridge && Bridge.emit('wx:changed', cur); } catch (e) {}
    }
    /* { w, c, cond, label, icon, t, hi, lo, wind, hum, night, blackout, measured, city } */
    function now() {
      /* a hora que veio com a medição (o mesmo cliente manda `gameTime` quando a hora muda, ver abaixo); sem medição, a do sistema */
      const s = load(); const h = (s && s.hour != null) ? +s.hour : hour(); const w = s ? s.w : 'CLEAR'; const t = TYPES[w];
      const night = isNight(h); const c = t[0]; const cond = night && c === 'sunny' ? 'night' : c;
      const hist = (Store.get('wxHist', []) || []).filter(x => x && TYPES[x.w]);
      const temps = hist.length ? hist.map(x => tempFor(x.w, x.hour)) : [tempFor(w, h)];
      const tt = tempFor(w, h);
      return { w, c, cond, label: t[1], icon: ICON[cond], t: tt, hi: Math.max(tt, ...temps), lo: Math.min(tt, ...temps), wind: t[3], hum: t[4], night, blackout: !!(s && s.blackout), measured: !!s, city: 'Los Santos', hour: h };
    }
    const icon = c => ICON[c] || 'sun';
    const label = c => LABEL[c] || 'Céu limpo';
    const hist = () => (Store.get('wxHist', []) || []).filter(x => x && TYPES[x.w]).map(x => Object.assign({}, x, { c: TYPES[x.w][0], label: TYPES[x.w][1], t: tempFor(x.w, x.hour) }));
    /* o push do client/main.lua (qb-weathersync ou transição do jogo); a hora do jogo acompanha (dia/noite sem esperar por
       uma mudança de tempo) */
    if (window.Bridge && Bridge.on) { Bridge.on('weather', set); Bridge.on('gameTime', d => { const s = load(); if (s && d && d.hour != null && +d.hour !== +s.hour) { s.hour = +d.hour; Store.set('wxLast', s); try { Bridge.emit('wx:changed', s); } catch (e) {} } }); }
    return { now, set, icon, label, hist, TYPES, tempFor };
  })();
  window.WX_FALLBACK = { t: 26, c: 'sunny', city: 'Los Santos', hi: 26, lo: 21 };
  const wxNow = () => WX.now();
  const WAPP = { weather: 'weather', battery: 'settings', calendar: 'calendar', alarm: 'clock', reminders: 'reminders' };
  /* o PROXIMO alarme a tocar (dias da semana incluidos, ClockNova.nextOf do clock.js) e nao o primeiro ligado da lista:
     com um alarme so de fim de semana a uma terca, o widget mostrava esse em vez do de amanha (2026-10-01) */
  const nextAlarm = () => { const l = (Store.get('alarms', []) || []).filter(x => x && x.on); if (!l.length) return null;
    if (!(window.ClockNova && ClockNova.nextOf)) return l[0];
    const now = new Date(); let best = null, bd = null;
    l.forEach(a => { let d = null; try { d = ClockNova.nextOf(a, now); } catch (e) {} if (d && (!bd || d < bd)) { bd = d; best = a; } });
    return best || l[0]; };
  /* Nova UI: cartões de vidro 138×62 (raio 20) com o glifo à esquerda (sem círculo por trás, como no Figma) e duas linhas
     (valor + legenda). A bateria é o medidor do cartão de bateria do Figma: arco grosso de 270° aberto em baixo (calha
     translúcida, carga a branco) com o aparelho ao centro; a carregar o glifo passa a raio. */
  const GAUGE = { r: 17, T: 80.11, C: 106.81 };   /* 3/4 da circunferência de raio 17 */
  const WA = {
    weather: () => { const wx = wxNow(); return { ic: wxG(wx.icon), v: wx.t + '°', l: L.t(wx.label) }; },
    battery: () => { const p = Math.max(0, Math.min(100, Math.round(+System.state.battery || 0))), ch = !!System.state.charging, G = GAUGE;
      const arc = (cls, len) => `<circle${cls} cx="22" cy="22" r="${G.r}" stroke-dasharray="${len} ${G.C}" transform="rotate(135 22 22)"/>`;
      return { arc: true, ic: `<svg class="als-arc" viewBox="0 0 44 44">${arc('', G.T)}${p > 0 ? arc(' class="v"', (p / 100 * G.T).toFixed(1)) : ''}</svg>${g(ch ? 'bolt' : 'battery')}`, v: p + '%', l: ch ? L.t('A carregar') : L.t('Bateria') }; },
    calendar: () => { const ev = (Store.get('events', []) || []).filter(e => e.date === localDay()).sort((a, b) => String(a.time).localeCompare(String(b.time)))[0];
      return { ic: g('calendar'), v: ev ? UI.esc(String(ev.time || '')) || L.t('Hoje') : L.t('Hoje'), l: ev ? UI.esc(String(ev.title || '').slice(0, 40)) : L.t('Sem eventos') }; },
    alarm: () => { const a = nextAlarm(); return { ic: g('alarm'), v: a ? UI.pad(a.h) + ':' + UI.pad(a.m) : '--:--', l: a ? L.t('Alarme') : L.t('Sem alarme') }; },
    reminders: () => { const n = (Store.get('reminders', []) || []).filter(x => !x.done).length; return { ic: g('checkCircle'), v: String(n), l: n === 1 ? L.t('Lembrete') : L.t('Lembretes') }; },
  };
  function renderWidgetsA(w) {
    const ks = (System.state.lockWidgetsV2 || []).filter(k => WA[k]).slice(0, 3);
    w.dataset.n = ks.length; el.classList.toggle('als-hasw', ks.length > 0);
    ks.forEach(k => { const d = WA[k](); const c = UI.el(`<div class="als-w als-w-${k}" data-glass><div class="als-wi${d.arc ? ' arc' : ''}">${d.ic}</div><div class="als-wt"><b>${d.v}</b><span>${d.l}</span></div></div>`);
      c.onclick = e => { e.stopPropagation(); if (inGallery()) return; requestUnlock(() => System.openApp(WAPP[k])); }; w.appendChild(c); });
    glassPos();
  }
  /* vidro sem backdrop-filter (no jogo pinta preto): cada peça de vidro mostra a cópia PRÉ-DESFOCADA do fundo do ecrã bloqueado,
     deslocada para a sua posição (--gx/--gy). offsetLeft/Top ignoram os transforms dos gestos, por isso a medição é sempre a da
     posição de repouso. Com o telemóvel guardado (display:none) não há medidas: fica marcado e o tick volta a medir. */
  let glassDirty = false;
  function glassPos() {
    if (!el || builtOS !== 'android') return;
    if (!el.offsetWidth) { glassDirty = true; return; } glassDirty = false;
    el.querySelectorAll('[data-glass]').forEach(n => { let x = 0, y = 0, p = n; while (p && p !== el) { x += p.offsetLeft; y += p.offsetTop; p = p.offsetParent; }
      if (p !== el) { glassDirty = true; return; } n.style.setProperty('--gx', x + 'px'); n.style.setProperty('--gy', y + 'px'); });
  }
  /* widget REDONDO antigo do PearPhone Fold (a bateria num anel de 270° com o glifo ao meio). Desde 2026-10-02 o bloqueado do
     Fold usa o ANEL DE ESTADO da barra direita (system.js Rail) e este fica escondido (lock.css); pinta-se só ao desenhar */
  let ringSig = '';
  function paintRing() {
    const r = el && builtOS !== 'android' ? el.querySelector('.lock-ring') : null; if (!r) return;
    const st = System.state || {}, p = Math.max(0, Math.min(100, Math.round(+st.battery || 0))), ch = !!st.charging, low = p <= 20, save = !!st.lowPower;
    const sig = [p, ch ? 1 : 0, low ? 1 : 0, save ? 1 : 0].join('|'); if (sig === ringSig && r.firstChild) return; ringSig = sig;
    const T = 70.69, C = 94.25;   /* 3/4 da circunferência de raio 15 */
    r.innerHTML = `<svg class="lr-arc" viewBox="0 0 36 36"><circle cx="18" cy="18" r="15" stroke-dasharray="${T} ${C}" transform="rotate(135 18 18)"/>`
      + (p > 0 ? `<circle class="v${low ? ' low' : save ? ' save' : ''}" cx="18" cy="18" r="15" stroke-dasharray="${(p / 100 * T).toFixed(2)} ${C}" transform="rotate(135 18 18)"/>` : '') + `</svg>${g(ch ? 'bolt' : 'battery')}`;
  }
  /* ---------- WIDGETS DO ECRÃ BLOQUEADO DO PEAROS (galeria › Personalizar › Adicionar widgets) ----------
     A linha por baixo da hora tem 4 LUGARES: um widget redondo ocupa 1, um retangular ocupa 2. São monocromáticos, na cor da
     hora (--clock-rgb), como no PearPhone. As chaves antigas continuam válidas (lockWidgetsV2 / lockScreens[].widgets): bateria,
     tempo e alarme ficam redondos, calendário e lembretes passam a retangulares. Uma lista gravada que não caiba nos 4 lugares
     mostra só o que cabe, pela ordem gravada. A linha constrói-se UMA vez por lista; o tick (1 s, o que já existe) só
     reescreve o miolo do widget cujo conteúdo mudou (nada pisca). Os dados são os do telemóvel: bateria do System, WX (o
     tempo do jogo), alarmes do Relógio, eventos do Calendário, lembretes, a última notícia da app de notícias (Weazel) que
     chegou às notificações e a música do leitor. */
  const LKW_SLOTS = 4;
  const svgP = p => `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${p}</svg>`;
  const G_DEV = '<rect x="6.5" y="2" width="11" height="20" rx="3"/><path d="M10.5 5h3"/>';
  const G_UMB = '<path d="M12 3a9 9 0 0 1 9 9H3a9 9 0 0 1 9-9Z"/><path d="M12 12v6.5a2 2 0 0 1-4 0"/>';
  /* chuva provável (%) por tipo de tempo do jogo: uma ESTIMATIVA, como a temperatura (o GTA não tem previsão) */
  const RAIN_P = { EXTRASUNNY: 0, CLEAR: 0, NEUTRAL: 10, SMOG: 5, FOGGY: 20, OVERCAST: 40, CLOUDS: 25, CLEARING: 30, RAIN: 90, THUNDER: 100, SNOW: 80, BLIZZARD: 100, SNOWLIGHT: 60, XMAS: 70, HALLOWEEN: 20 };
  const GC = 2 * Math.PI * 27, GT = GC * .75;   /* anel de raio 27 numa caixa de 66; medidor de 270° aberto em baixo */
  const gArc = (p, cls) => `<circle class="${cls}" cx="33" cy="33" r="27" stroke-dasharray="${(GT * p).toFixed(1)} ${GC.toFixed(1)}" transform="rotate(135 33 33)"/>`;
  const gauge = (p, dot) => { let s = gArc(1, 't'); if (dot == null) { if (p > 0) s += gArc(Math.min(1, p), 'v'); } else { const a = (135 + 270 * dot) * Math.PI / 180; s += `<circle class="d" cx="${(33 + 27 * Math.cos(a)).toFixed(1)}" cy="${(33 + 27 * Math.sin(a)).toFixed(1)}" r="4.2"/>`; } return `<svg class="lkw-g" viewBox="0 0 66 66">${s}</svg>`; };
  const appLbl = id => UI.esc(L.t(window.App && App.name ? App.name(id) : id));
  const rectW = (glyph, label, bold, sub) => `<div class="lkw-h">${glyph}<span>${label}</span></div><b>${bold}</b><span class="lkw-s">${sub}</span>`;
  /* a app de notícias: a Weazel News (app de empresa capp_weazel) ou outra app de empresa com "news"/"notícias" no nome */
  const newsApp = () => { const all = (window.App && App.all && App.all()) || {}; if (all.capp_weazel && !all.capp_weazel.hidden) return 'capp_weazel';
    return Object.keys(all).find(id => /^capp_/.test(id) && all[id] && !all[id].hidden && /weazel|news|not[ií]cia/i.test(id + ' ' + (all[id].name || ''))) || null; };
  /* por ler de uma app = o emblema do ícone (System.badge guarda o número em Home.badges, mesmo com o emblema desligado) */
  const badgeN = id => { const b = window.Home && Home.badges; const n = b ? Math.floor(+b[id] || 0) : 0; return n > 0 ? n : 0; };
  const G_WAL = '<path d="M19 7V5.5A1.5 1.5 0 0 0 17.5 4H5a2 2 0 0 0 0 4h14a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6"/><path d="M16.5 14h.01"/>';
  /* saldo para o widget Carteira: bank.info (o mesmo da app) guardado aqui. Pede-se ao iniciar e quando chega 'bank' ou
     'player:update' (com 3 s de intervalo mínimo: o player:update pode vir em rajada); a resposta só refresca o miolo. */
  /* ⚠️ 1.4.0 (revisão): o bank.info faz um SELECT de 60 movimentos + o histórico do banco e devolve até 80 linhas; pedi-lo em cada
     player:update (qualquer compra a dinheiro) para TODOS os jogadores era carga no servidor para um widget que quase ninguém põe.
     Agora só se pede com o widget Carteira na linha do ecrã bloqueado, ou quando a pré-visualização dele é desenhada (folha
     "Adicionar widgets") - e enquanto não há resposta mostra-se o banco que já vem no System.player (client/main.lua: money.bank). */
  let bankLast = null, bankT = null, bankAt = 0;
  const wantBank = () => { const l = System.state && System.state.lockWidgetsV2; return Array.isArray(l) && l.includes('wallet'); };
  function bankFetch() {
    if (!window.Bridge || !Bridge.rpc || isAnd()) return; clearTimeout(bankT); bankT = null;
    const wait = 3000 - (Date.now() - bankAt); if (wait > 0) { bankT = setTimeout(bankFetch, wait); return; }
    bankAt = Date.now();
    let p = null; try { p = Bridge.rpc('bank.info'); } catch (e) { return; }
    Promise.resolve(p).then(r => { if (r && r.bank != null && isFinite(+r.bank)) { const v = +r.bank; if (v !== bankLast) { bankLast = v; lkwRefresh(); } } }).catch(() => {});
  }
  /* sem resposta ainda (ou falhou): no máximo um pedido a cada 30 s a partir do desenho do widget */
  const bankSoon = () => { if (!bankT && Date.now() - bankAt > (bankAt ? 30000 : 0)) bankFetch(); };
  const bankNow = () => { if (bankLast != null) return bankLast; bankSoon(); const m = window.System && System.player && System.player.money; return m && m.bank != null && isFinite(+m.bank) ? +m.bank : null; };
  if (window.Bridge && Bridge.on) { Bridge.on('bank', () => { if (el && wantBank()) bankFetch(); }); Bridge.on('player:update', () => { if (el && wantBank()) bankFetch(); }); }
  const lastNews = id => { if (!id || !window.Notify || !Notify.all) return null; let best = null; Notify.all().forEach(n => { if (n && n.app === id && (!best || +n.ts > +best.ts)) best = n; }); return best; };
  const LKW = {
    battery: { kind: 'c', name: 'Bateria', app: 'settings', body: () => { const st = System.state || {}, p = Math.max(0, Math.min(100, Math.round(+st.battery || 0)));
      return `<svg class="lkw-g" viewBox="0 0 66 66"><circle class="t" cx="33" cy="33" r="27"/>${p > 0 ? `<circle class="v" cx="33" cy="33" r="27" stroke-dasharray="${(GC * p / 100).toFixed(1)} ${GC.toFixed(1)}" transform="rotate(-90 33 33)"/>` : ''}</svg><div class="lkw-m">${st.charging ? g('bolt') : svgP(G_DEV)}<b>${p}%</b></div>`; } },
    weather: { kind: 'c', name: 'Temperatura', app: 'weather', body: () => { const wx = wxNow(), span = wx.hi - wx.lo, p = span > 0 ? (wx.t - wx.lo) / span : .5;
      return `${gauge(0, Math.max(0, Math.min(1, p)))}<div class="lkw-m">${g(wx.icon)}<b>${wx.t}°</b></div><span class="lkw-lo">${wx.lo}</span><span class="lkw-hi">${wx.hi}</span>`; } },
    rain: { kind: 'c', name: 'Chuva', app: 'weather', body: () => { const wx = wxNow(), p = RAIN_P[wx.w] != null ? RAIN_P[wx.w] : 0; return `${gauge(p / 100)}<div class="lkw-m"><b class="big">${p}%</b></div><span class="lkw-b">${svgP(G_UMB)}</span>`; } },
    alarm: { kind: 'c', name: 'Alarme', app: 'clock', body: () => { const a = nextAlarm(); return `<div class="lkw-m">${g('alarm')}<b>${a ? UI.esc(UI.fmtTime(new Date(2026, 0, 1, +a.h || 0, +a.m || 0))) : '--:--'}</b></div>`; } },
    day: { kind: 'c', name: 'Data', app: 'calendar', body: () => { const d = new Date(); return `<div class="lkw-m lkw-day"><span>${UI.esc(UI.wdShort ? UI.wdShort(d) : UI.DIAS_C[d.getDay()])}</span><b>${d.getDate()}</b></div>`; } },
    calendar: { kind: 'r', name: 'Calendário', app: 'calendar', body: () => { const today = localDay(), n = new Date(), hm = UI.pad(n.getHours()) + ':' + UI.pad(n.getMinutes());
      const ev = (Store.get('events', []) || []).filter(e => e && typeof e.date === 'string' && (e.date > today || (e.date === today && (!e.time || String(e.time) >= hm)))).sort((a, b) => (a.date + ' ' + (a.time || '')).localeCompare(b.date + ' ' + (b.time || '')))[0];
      let sub = L.t('Nada agendado'); if (ev) { const t = ev.time ? String(ev.time) : ''; if (ev.date === today) sub = t ? L.tf('Hoje às %s', t) : L.t('Hoje'); else { const p = ev.date.split('-').map(Number); sub = UI.fmtDayMonth(new Date(p[0], (p[1] || 1) - 1, p[2] || 1)) + (t ? ' · ' + t : ''); } }
      return rectW(g('calendar'), appLbl('calendar'), ev ? UI.esc(String(ev.title || L.t('Evento')).slice(0, 60)) : UI.esc(L.t('Sem eventos')), UI.esc(sub)); } },   /* corta ANTES de escapar (cortar o escapado partia entidades) */
    reminders: { kind: 'r', name: 'Lembretes', app: 'reminders', body: () => { const open = (Store.get('reminders', []) || []).filter(x => x && !x.done).sort((a, b) => (+a.due || 9e15) - (+b.due || 9e15));
      const soon = open.filter(x => +x.due > 0 && +x.due - Date.now() < 864e5).length;
      return rectW(g('checkCircle'), appLbl('reminders'), open.length ? UI.esc(String(open[0].text || L.t('Lembrete')).slice(0, 60)) : UI.esc(L.t('Sem lembretes')), UI.esc(!open.length ? L.t('Tudo feito') : soon ? L.tf('%s para breve', soon) : L.tf('%s por fazer', open.length))); } },
    news: { kind: 'r', name: 'Weazel News', app: () => newsApp(), body: () => { const id = newsApp(), n = lastNews(id), lbl = id ? appLbl(id) : 'Weazel News';
      return rectW(g('newspaper'), lbl, UI.esc(n ? String(n.msg || n.title || '').slice(0, 80) : L.t('Sem notícias em destaque')), n ? UI.esc(UI.timeAgo(n.ts)) : lbl); } },
    forecast: { kind: 'r', name: 'Meteorologia', app: 'weather', body: () => { const wx = wxNow(); return rectW(g(wx.icon), appLbl('weather'), UI.esc(wx.city), UI.esc(wx.t + '° · ' + L.t(wx.label))); } },
    music: { kind: 'r', name: 'Música', app: 'music', body: () => { const P = window.Player; let c = null; try { c = P && P.cur ? P.cur() : null; } catch (e) {}
      return rectW(g('music'), appLbl('music'), UI.esc(c ? String(c.title || '').slice(0, 60) : L.t('Nada a tocar')), UI.esc(c ? String(c.artist || '') : L.t('Abre a Música para ouvir'))); } },
    /* ---- 1.4.0 (PearOS 27, folha "Adicionar widgets"): Mail, Mensagens, Notas, Carteira e Temporizador, com dados que o telemóvel já
       tem. Por não lidas: os emblemas da home (Home.badges, o mesmo número do ícone). O HTML só muda quando o dado muda (o tick de
       1 s compara o texto e só reescreve o que mudou) - exceto o temporizador a correr, que conta os segundos. */
    /* Mail como no iOS: o número grande, "novos" pequeno por baixo e o envelope em baixo. '%s novos' é UMA chave (a ordem do número
       muda de língua para língua): parte-se no sítio do %s para o número ir no <b> e o resto em letra pequena. */
    mail: { kind: 'c', name: 'Mail', app: 'mail', body: () => { const n = badgeN('mail'), parts = String(L.tf('%s novos', '\u0001')).split('\u0001'), w = s => s && s.trim() ? `<span class="lkw-u">${UI.esc(s.trim())}</span>` : '';
      return `<div class="lkw-m lkw-cnt">${w(parts[0])}<b>${n > 99 ? '99+' : n}</b>${w(parts.slice(1).join(''))}</div><span class="lkw-b">${g('mail')}</span>`; } },
    messages: { kind: 'c', name: 'Mensagens', app: 'messages', body: () => { const n = badgeN('messages'); return `<div class="lkw-m lkw-cnt">${g('message')}<b>${n > 99 ? '99+' : n}</b></div>`; } },
    notes: { kind: 'c', name: 'Notas', app: 'notes', body: () => { const l = Store.get('notes', []); const n = Array.isArray(l) ? l.length : 0; return `<div class="lkw-m lkw-cnt">${g('pen')}<b>${n}</b></div>`; } },
    /* saldo da conta: cache do bank.info (pedido UMA vez ao iniciar e quando o banco/jogador muda) - NUNCA um RPC dentro do body, que
       corre a cada segundo; '--' até a primeira resposta chegar */
    wallet: { kind: 'r', name: 'Carteira', app: 'wallet', body: () => { const v = bankNow(); return rectW(svgP(G_WAL), appLbl('wallet'), v == null ? '--' : UI.esc(UI.money(v)), UI.esc(L.t('Conta bancária'))); } },
    /* temporizador da app Relógio (window.TimerState, as duas versões da app escrevem-no): a correr → o tempo que falta, senão --:-- */
    timer: { kind: 'c', name: 'Temporizador', app: 'clock', body: () => { const T = window.TimerState, on = !!(T && T.running && +T.end > Date.now());   /* um TimerState que ficou "a correr" depois do fim (app fechada a meio) mostrava 0:00 para sempre */
      return `<div class="lkw-m lkw-cnt">${g('timer')}<b${on ? '' : ' class="off"'}>${on ? mmss(Math.max(0, +T.end - Date.now())) : '--:--'}</b></div>`; } },
  };
  const LKW_ORDER = ['battery', 'weather', 'rain', 'alarm', 'calendar', 'reminders', 'mail', 'messages', 'wallet', 'notes', 'timer', 'news', 'forecast', 'day', 'music'];
  const lkwSlot = k => (LKW[k] && LKW[k].kind === 'r' ? 2 : 1);
  /* as chaves que cabem nos 4 lugares, pela ordem dada (desconhecidas e repetidas saem) */
  const lkwFit = list => { const out = []; let used = 0; (Array.isArray(list) ? list : []).forEach(k => { if (!LKW[k] || out.includes(k)) return; const s = lkwSlot(k); if (used + s > LKW_SLOTS) return; out.push(k); used += s; }); return out; };
  const lkwBody = k => { try { return LKW[k].body(); } catch (e) { return ''; } };
  const lkwApp = k => { const a = LKW[k] && LKW[k].app; return typeof a === 'function' ? a() : a; };
  /* HTML de um widget (pré-visualizações da galeria e cartões laterais): a mesma marcação do ecrã bloqueado */
  const lkwHTML = (k, body) => LKW[k] ? `<div class="lkw lkw-${LKW[k].kind} lkw-k-${k}" data-k="${k}"><div class="lkw-in">${body == null ? lkwBody(k) : body}</div><i class="lkw-rm"></i></div>` : '';
  let lkwSig = null;
  function renderWidgets() {
    const w = el.querySelector('.lock-widgets'); if (!w) return;
    if (builtOS === 'android') { w.innerHTML = ''; w.classList.remove('lkw-row'); lkwSig = null; renderWidgetsA(w); return; }
    paintRing();
    const ks = lkwFit(System.state.lockWidgetsV2), sig = ks.join(',');
    el.classList.toggle('lkw-on', ks.length > 0); w.classList.add('lkw-row');
    /* a mesma lista: só se atualiza o conteúdo (sem refazer a linha) */
    if (sig === lkwSig && w.children.length === ks.length) { lkwRefresh(); return; }
    lkwSig = sig; w.innerHTML = '';
    ks.forEach(k => { const h = lkwBody(k), d = UI.el(lkwHTML(k, h)); d._h = h;
      d.onclick = e => { e.stopPropagation(); if (inGallery()) return; const a = lkwApp(k); requestUnlock(() => { if (a) System.openApp(a); }); }; w.appendChild(d); });
  }
  /* no tick: reescreve só o miolo que mudou (bateria, tempo, música, uma notícia nova...) */
  function lkwRefresh() {
    if (!el || builtOS === 'android' || !lkwSig) return; const w = el.querySelector('.lock-widgets'); if (!w) return;
    [...w.children].forEach(d => { const k = d.dataset.k; if (!LKW[k]) return; const h = lkwBody(k); if (h !== d._h) { d._h = h; d.firstElementChild.innerHTML = h; } });
  }
  /* ---------- "A tocar" no ecrã bloqueado (MEDIA-13) ----------
     O cartão do PearOS, dentro da camada do lock (o Centro de controlo e a Dynamic Island já controlavam a
     música bloqueados; faltava o cartão aqui). Reaproveita o módulo do control.js (CC.music) - HTML,
     ouvintes e pintura são os mesmos, não há duas cópias.
     Sem faixa nenhuma não há cartão. A pintura vai no tick do relógio (uma vez por segundo, já existente):
     nada de setInterval/rAF novo, e com o telemóvel guardado o tick do system.js nem chega aqui. */
  let npEl = null;

  /* ---------- NOW BAR (Nova UI) ----------
     A pílula de vidro 248×64 ao centro da linha de baixo, entre os dois atalhos. Mostra o que está a decorrer, pela ordem
     da Nova UI: chamada > navegação > temporizador > música (a mesma música que alimentava o "A tocar"). Com mais de uma,
     desliza-se para o lado para trocar. É construída UMA vez e o tick (1 s, o que já existe) só troca textos e classes:
     nada pisca. Tocar na música abre o cartão do leitor por cima (anterior / pausa / seguinte e progresso). */
  let nb = null;
  const mmss = ms => { const s = Math.max(0, Math.round(ms / 1000)); return Math.floor(s / 60) + ':' + UI.pad(s % 60); };
  const distTxt = d => { if (d == null || !isFinite(+d)) return ''; d = +d; return d < 1000 ? Math.round(d) + ' m' : d < 10000 ? (d / 1000).toFixed(1).replace('.', ',') + ' km' : Math.round(d / 1000) + ' km'; };
  function nbItems() {
    const out = [];
    const pc = window.PhoneApp && PhoneApp.current;
    if (pc && (pc.answered || pc.outgoing)) out.push({ k: 'call', title: pc.name || pc.number || L.t('Chamada'), sub: pc.t0 ? mmss(Date.now() - pc.t0) : (pc.status || ''), act: 'end', sig: 'call' });
    else { let any = false; try { any = !!(window.Island && Island.list && Island.list().some(a => a && a.mode === 'call')); } catch (e) {} if (any) out.push({ k: 'call', title: L.t('Chamada'), sub: '', act: null, sig: 'call2' }); }
    const r = window.Maps && Maps.route; if (r) out.push({ k: 'nav', title: r.name || L.t('Destino'), sub: distTxt(r.dist), act: 'stop', sig: 'nav' });
    const T = window.TimerState; if (T && T.running && +T.end > Date.now()) out.push({ k: 'timer', title: L.t('Temporizador'), sub: mmss(T.end - Date.now()), act: 'cancel', sig: 'timer' });
    const P = window.Player, cur = P && P.cur ? P.cur() : null;
    if (cur) out.push({ k: 'music', title: cur.title || '', sub: cur.artist || '', act: P.playing ? 'pause' : 'play', cur, sig: 'm|' + [cur.id, cur.title, cur.img, (cur.c || []).join(',')].join('|') });
    /* a carregar (variante de carga da Now Bar): por último, com a percentagem; toca para abrir a bateria nas Definições */
    if (System.state.charging) { const p = Math.max(0, Math.min(100, Math.round(+System.state.battery || 0))); out.push({ k: 'charge', title: p >= 100 ? L.t('Carregado') : L.t('A carregar'), sub: p + '%', act: null, sig: 'charge' }); }
    return out;
  }
  const NB_IC = { call: 'phoneFill', nav: 'nav', timer: 'timer', charge: 'bolt' };
  const NB_ACT = { end: 'phoneDown', stop: 'x', cancel: 'x', pause: 'pause', play: 'play' };
  const paintArt = (n, cur) => { if (!n) return; const c = (cur && cur.c) || []; n.style.backgroundImage = cur && cur.img ? UI.img(cur.img) : `linear-gradient(135deg,${c[0] || '#5E5CE6'},${c[1] || c[0] || '#1C1C1E'})`; };   /* a capa vem por CSSOM (um data: URL nunca entra numa string de HTML) */
  function nbBuild(host) {
    host.innerHTML = '<div class="als-nb" data-glass><div class="als-nb-in"><div class="als-nb-ic"></div><div class="als-nb-tx"><b></b><span></span></div><div class="als-nb-act"></div></div></div><div class="als-nb-dots"></div>';
    const pill = host.firstElementChild;
    nb = { host, pill, inn: pill.firstElementChild, ic: pill.querySelector('.als-nb-ic'), t: pill.querySelector('b'), s: pill.querySelector('.als-nb-tx span'), act: pill.querySelector('.als-nb-act'), dots: host.querySelector('.als-nb-dots'), items: [], idx: 0, want: null, sig: '', actK: '', n: -1, on: false };
    let st = null;
    pill.addEventListener('pointerdown', e => { e.stopPropagation(); if (inGallery()) return; if (e.button && e.pointerType === 'mouse') return; st = { x: e.clientX, y: e.clientY, z: UI.zoom() || 1, onAct: !!e.target.closest('.als-nb-act') }; pill.classList.add('press'); try { pill.setPointerCapture(e.pointerId); } catch (x) {} });
    pill.addEventListener('pointerup', e => { e.stopPropagation(); pill.classList.remove('press'); if (!st) return; const s0 = st; st = null; const dx = (e.clientX - s0.x) / s0.z, dy = (e.clientY - s0.y) / s0.z;
      if (Math.abs(dx) > 40 && Math.abs(dx) > Math.abs(dy) && nb.items.length > 1) { const n = nb.items.length; nb.idx = (nb.idx + (dx < 0 ? 1 : -1) + n) % n; nb.want = nb.items[nb.idx].k; nb.inn.classList.remove('swap'); void nb.inn.offsetWidth; nb.inn.classList.add('swap'); Sound.play('click'); renderNowBar(); return; }
      if (Math.abs(dx) > 10 || Math.abs(dy) > 10) return;
      const it = nb.items[nb.idx]; if (!it) return; Sound.play('click');
      if (s0.onAct && it.act) nbAct(it); else nbOpen(it); });
    pill.addEventListener('pointercancel', () => { st = null; pill.classList.remove('press'); });
    pill.addEventListener('click', e => e.stopPropagation());
  }
  function nbAct(it) {
    try {
      if (it.act === 'end' && window.PhoneApp && PhoneApp.end) PhoneApp.end('local');
      else if (it.act === 'stop' && window.Maps && Maps.endRoute) Maps.endRoute();
      else if (it.act === 'cancel' && window.TimerState && TimerState.cancel) { const c = TimerState.cancel; window.TimerState = { running: false }; c(); }
      else if ((it.act === 'pause' || it.act === 'play') && window.Player && Player.toggle) Player.toggle();
    } catch (e) { console.error('[apex_phone] now bar', e); }
    setTimeout(renderNowBar, 60);
  }
  function nbOpen(it) {
    if (it.k === 'music') { toggleMx(); return; }
    if (it.k === 'call') { if (window.PhoneApp && PhoneApp.current && PhoneApp.restore) PhoneApp.restore(); return; }   /* o ecrã da chamada abre por cima do bloqueio, como o da chamada recebida */
    requestUnlock(() => System.openApp(it.k === 'nav' ? 'maps' : it.k === 'charge' ? 'settings' : 'clock'));
  }
  function renderNowBar() {
    const host = el && el.querySelector('.lock-np'); if (!host) return;
    const items = System.locked && !inGallery() ? nbItems() : [];
    if (!items.length) { if (nb && nb.on) { nb.on = false; host.classList.remove('on'); el.classList.remove('has-np'); } closeMx(); return; }
    if (!nb || nb.host !== host) nbBuild(host);
    nb.items = items; const wi = nb.want ? items.findIndex(x => x.k === nb.want) : -1; nb.idx = wi >= 0 ? wi : Math.min(nb.idx, items.length - 1);
    const it = items[nb.idx];
    if (nb.sig !== it.sig) { nb.sig = it.sig; nb.pill.dataset.k = it.k;
      if (it.k === 'music') { nb.ic.innerHTML = ''; nb.ic.className = 'als-nb-ic als-k-art'; paintArt(nb.ic, it.cur); }
      else { nb.ic.style.backgroundImage = ''; nb.ic.className = 'als-nb-ic als-k-' + it.k; nb.ic.innerHTML = g(NB_IC[it.k] || 'dot'); } }
    if (nb.t.textContent !== it.title) nb.t.textContent = it.title;
    if (nb.s.textContent !== it.sub) nb.s.textContent = it.sub;
    const ak = it.act || ''; if (nb.actK !== ak) { nb.actK = ak; nb.act.className = 'als-nb-act' + (ak ? ' als-a-' + ak : ''); nb.act.innerHTML = ak ? g(NB_ACT[ak]) : ''; }
    if (nb.n !== items.length) { nb.n = items.length; nb.dots.innerHTML = items.length > 1 ? '<i></i>'.repeat(items.length) : ''; }
    [...nb.dots.children].forEach((d, i) => d.classList.toggle('on', i === nb.idx));
    if (!nb.on) { nb.on = true; host.classList.add('on'); el.classList.add('has-np'); glassPos(); }
    if (R.mx && R.mx.classList.contains('on')) paintMx();
  }
  /* cartão do leitor (toque na Now Bar com música): construído uma vez, atualizado no sítio pelo tick */
  let mx = null;
  function toggleMx() { if (R.mx && R.mx.classList.contains('on')) closeMx(); else openMx(); }
  function openMx() {
    if (!R.mx || !window.Player || !Player.cur || !Player.cur()) return;
    if (!mx || mx.host !== R.mx) {
      R.mx.setAttribute('data-glass', '');
      R.mx.innerHTML = `<div class="als-mx-top"><div class="als-mx-art"></div><div class="als-mx-tx"><b></b><span></span></div><div class="als-mx-app">${g('music')}</div></div>
        <div class="als-mx-bar"><i></i></div><div class="als-mx-tm"><span></span><span></span></div>
        <div class="als-mx-ctl"><div data-a="prev">${g('prev')}</div><div data-a="play" class="pp"></div><div data-a="next">${g('next')}</div></div>`;
      mx = { host: R.mx, art: R.mx.querySelector('.als-mx-art'), t: R.mx.querySelector('.als-mx-tx b'), s: R.mx.querySelector('.als-mx-tx span'), bar: R.mx.querySelector('.als-mx-bar i'), a: R.mx.querySelector('.als-mx-tm span:first-child'), b: R.mx.querySelector('.als-mx-tm span:last-child'), pp: R.mx.querySelector('.pp'), sig: '', pk: null };
      R.mx.addEventListener('pointerdown', e => e.stopPropagation());
      /* botões do leitor: tocam sem desbloquear (como no Centro de controlo); a capa/título abre a app depois do desbloqueio */
      R.mx.addEventListener('click', e => { e.stopPropagation(); if (inGallery()) return; const b = e.target.closest('[data-a]');
        if (b && window.Player) { Sound.play('click');
          try { if (b.dataset.a === 'prev' && Player.prev) Player.prev(); else if (b.dataset.a === 'next' && Player.next) Player.next(); else if (b.dataset.a === 'play' && Player.toggle) Player.toggle(); } catch (x) {}
          setTimeout(() => { paintMx(); renderNowBar(); }, 60); return; }
        if (e.target.closest('.als-mx-top')) { closeMx(); requestUnlock(() => System.openApp('music')); } });
    }
    paintMx(); glassPos(); R.mx.classList.add('on');
  }
  function closeMx() { if (R.mx) R.mx.classList.remove('on'); }
  function paintMx() {
    if (!mx || !window.Player || !Player.cur) return; const cur = Player.cur(); if (!cur) { closeMx(); return; }
    const sig = [cur.id, cur.title, cur.img, (cur.c || []).join(',')].join('|'); if (mx.sig !== sig) { mx.sig = sig; paintArt(mx.art, cur);
      /* o vidro do cartão leva a cor da capa (Nova UI): a cor escura da faixa a metade do brilho, véu .5; sem cor fica o véu de sempre */
      const m = /^#?([0-9a-f]{6})$/i.exec(String((cur.c || [])[1] || (cur.c || [])[0] || '')); if (m) { const n = parseInt(m[1], 16), k = .5; mx.host.style.setProperty('--als-tint', `rgba(${Math.round((n >> 16) * k)},${Math.round(((n >> 8) & 255) * k)},${Math.round((n & 255) * k)},.5)`); } else mx.host.style.removeProperty('--als-tint'); }
    if (mx.t.textContent !== (cur.title || '')) mx.t.textContent = cur.title || '';
    if (mx.s.textContent !== (cur.artist || '')) mx.s.textContent = cur.artist || '';
    const pk = !!Player.playing; if (mx.pk !== pk) { mx.pk = pk; mx.pp.innerHTML = g(pk ? 'pause' : 'play'); }
    const dur = +cur.dur || 0, pos = Math.min(dur, +Player.pos || 0);
    mx.bar.style.transform = `scaleX(${dur ? (pos / dur).toFixed(4) : 0})`;
    const ta = mmss(pos * 1000), tb = '-' + mmss(Math.max(0, dur - pos) * 1000); if (mx.a.textContent !== ta) mx.a.textContent = ta; if (mx.b.textContent !== tb) mx.b.textContent = tb;
  }
  function renderNowPlaying() {
    if (builtOS === 'android') { renderNowBar(); return; }
    const host = el && el.querySelector('.lock-np'); if (!host) return;
    const cur = window.Player && Player.cur ? Player.cur() : null;
    /* a classe `.has-np` no #lock diz ao CSS que o cartão está no ar (nome único: `.np` era o antigo ecrã Now Playing
       do apps.css com fundo próprio e tapava o wallpaper): com o relógio AO MEIO as notificações
       descem até 128 px do fundo e passariam por baixo dele - o lock.css sobe-as só neste caso. O CEF não
       tem :has(), por isso a condição tem de vir daqui. */
    if (!cur || !window.CC || !CC.music) { if (npEl) { npEl.remove(); npEl = null; } host.classList.remove('on'); el.classList.remove('has-np'); return; }
    if (!npEl) {
      npEl = UI.el(`<div class="cc-mod music">${CC.music.html(!!Player.playing)}</div>`);
      CC.music.bind(npEl, { empty: () => requestUnlock(() => System.openApp('music')) });
      host.appendChild(npEl); host.classList.add('on'); el.classList.add('has-np');
    }
    CC.music.paint(npEl);
  }
  /* ---------- CÓDIGO: verificado no SERVIDOR ----------
     O PIN já não chega ao NUI (qualquer injeção no NUI lia-o e desbloqueava). account.get traz só `hasPin` e `pinLen` (0/4/6);
     cada tentativa vai a Bridge.rpc('account.verifyPin', { pin }) → { ok, attempts?, lockedUntil? }. As tentativas e o bloqueio
     contam no servidor - aqui só se mostra o que ele responde. Sem código (hasPin === false) desbloqueia-se sem teclado. */
  const acct = () => System.account || null;
  const noPin = () => { const a = acct(); return !!a && (a.hasPin === false || (a.hasPin == null && a.pin == null && +a.pinLen === 0)); };
  /* 4 OU 6 dígitos (o PearOS usa 6 por omissão). Uma conta vinda de um servidor ainda sem `pinLen` usa o comprimento do campo antigo
     - só o COMPRIMENTO, para desenhar os pontos; a comparação é sempre no servidor. */
  const pinLen = () => { const a = acct() || {}; const n = +a.pinLen || (a.pin != null ? String(a.pin).length : 0); return n === 6 ? 6 : 4; };
  let coolUntil = 0, coolT = null, checkSeq = 0;
  const coolLeft = () => Math.max(0, coolUntil - Date.now());
  const fmtWait = ms => { const s = Math.ceil(ms / 1000); return s >= 60 ? `${Math.floor(s / 60)}:${UI.pad(s % 60)}` : `${s} s`; };
  /* textos do teclado: o PearOS fala de "código" (tu), a Nova UI de "PIN" (formal, como o sistema em pt-PT) */
  const PT = () => builtOS === 'android'
    ? { enter: L.t('Introduza o PIN'), wrong: L.t('PIN incorreto'), unv: L.t('Não foi possível verificar o PIN'), wait: L.t('Tente novamente dentro de') }
    : { enter: L.t('Introduzir código'), wrong: L.t('Código incorreto'), unv: L.t('Não foi possível verificar o código'), wait: L.t('Tenta de novo dentro de') };
  /* a linha de estado do teclado. PearOS: é o próprio título ("Introduzir código" / "Código incorreto"), err=true/false acende ou
     apaga o vermelho e err=undefined não lhe mexe (exatamente o que o código fazia antes). Nova UI: o título fica sempre
     "Introduza o PIN" e os avisos vão para a linha de baixo (vazia quando não há erro). */
  function say(t, err) {
    if (!labelEl) return;
    if (builtOS !== 'android' || !R.sub) { labelEl.textContent = t; if (err === true) labelEl.classList.add('err'); else if (err === false) labelEl.classList.remove('err'); return; }
    const v = err ? t : ''; if (R.sub.textContent !== v) R.sub.textContent = v; R.sub.classList.toggle('err', !!err);
  }
  /* contagem decrescente do bloqueio: o teclado fica apagado (#lock.cool) mas Emergência e Cancelar continuam a funcionar */
  function paintCool() {
    if (!el || !labelEl) return; const left = coolLeft();
    if (!left) { clearInterval(coolT); coolT = null; if (el.classList.contains('cool')) { el.classList.remove('cool'); if (!busy) say(PT().enter, false); } return; }
    el.classList.add('cool'); say(PT().wait + ' ' + fmtWait(left), true);
  }
  /* bloqueio vindo do servidor: `wait` (segundos) se vier, senão `lockedUntil` (epoch em segundos - os.time() - ou em ms).
     O relógio do PC e o do servidor podem não bater certo: o prazo fica entre 1 s e 1 h e passa para relógio local. */
  function startCool(r) {
    let ms = 0;
    if (r && +r.wait > 0) ms = +r.wait * 1000;
    else if (r && +r.lockedUntil > 0) { const u = +r.lockedUntil; ms = (u < 1e12 ? u * 1000 : u) - Date.now(); }
    coolUntil = Date.now() + Math.max(1000, Math.min(3600000, ms || 0)); entry = ''; renderDots(); paintCool();
    clearInterval(coolT); coolT = setInterval(paintCool, 1000);
  }
  /* o bloqueio é da PERSONAGEM (o servidor conta por cid): trocar de personagem ou repor o telemóvel não herda a contagem da anterior */
  const clearCool = () => { if (!coolUntil) return; coolUntil = 0; paintCool(); };
  Bridge.on('session:changed', clearCool); Bridge.on('factory:reset', clearCool);
  function renderDots() {
    /* Nova UI: só aparecem os pontos já escritos (o campo cresce a partir do centro); o Cancelar não muda para "Apagar" (há a tecla) */
    if (builtOS === 'android') { const n = pinLen(); if (dotsEl.children.length !== n) { dotsEl.innerHTML = '<i class="als-dot"></i>'.repeat(n); dotsEl.classList.toggle('six', n === 6); }
      [...dotsEl.children].forEach((d, i) => d.classList.toggle('on', i < entry.length)); return; }
    const n = pinLen(); if (dotsEl.children.length !== n) { dotsEl.innerHTML = '<span class="dot"></span>'.repeat(n); dotsEl.classList.toggle('six', n === 6); }
    [...dotsEl.children].forEach((d, i) => d.classList.toggle('on', i < entry.length)); p2.querySelector('.cancel').textContent = entry ? L.t('Apagar') : L.t('Cancelar');
  }
  function push(n) {
    const max = pinLen();
    if (busy || coolLeft() || entry.length >= max) return; entry += n; say(PT().enter, false); dotsEl.classList.remove('err');
    renderDots();
    const d = dotsEl.children[entry.length - 1]; if (d) { d.classList.remove('pop'); void d.offsetWidth; d.classList.add('pop'); }
    if (entry.length === max) setTimeout(check, 180);
  }
  async function check() {
    /* o Cancelar/Backspace nos 180 ms antes do check tira um dígito: um código incompleto não vai ao servidor (contava como tentativa falhada) */
    if (busy || !el.classList.contains('pin') || entry.length !== pinLen()) return; busy = true; const seq = ++checkSeq;
    let r = null; try { r = await Bridge.rpc('account.verifyPin', { pin: entry }); } catch (e) { r = null; }
    /* o teclado fechou, bloqueou ou reabriu enquanto o servidor respondia: esta resposta já não conta */
    if (seq !== checkSeq || !el.classList.contains('pin')) return;
    /* código certo: pontos acendem, o teclado desvanece/encolhe (#lock.ok) e só depois a transição para a home - ou, em modo de verificação (galeria), só confirma e fecha o teclado */
    if (r && r.ok) { coolUntil = 0; clearInterval(coolT); coolT = null; el.classList.remove('cool'); lastAuth = Date.now(); say(L.t('Desbloqueado')); dotsEl.classList.add('ok');
      if (verifyOnly) { const f = verifyOnly; verifyOnly = null; el.classList.add('ok'); setTimeout(() => { hidePin(); busy = false; f(); }, 300); return; }
      el.classList.add('ok'); setTimeout(unlock, 320); return; }
    const blocked = !!r && (+r.lockedUntil > 0 || +r.wait > 0);
    /* sem resposta, ou um erro sem tentativas (rate limit do dispatcher → { error:'ratelimit' }): não é "código incorreto" - diz-se o que aconteceu */
    const unverified = !r || typeof r !== 'object' || (r.error != null && r.attempts == null && !blocked);
    let msg = unverified ? PT().unv : PT().wrong;
    /* `attempts` = tentativas QUE AINDA RESTAM antes do bloqueio (server/main.lua pinFail e o mock do localdb.js), não as falhadas.
       Com Config.PinLock = false o servidor não manda `attempts` e fica só "Código incorreto". */
    if (!unverified && !blocked && r.attempts != null && +r.attempts > 0) { const left = Math.floor(+r.attempts);
      msg += ` · ${left} ${left === 1 ? L.t('tentativa restante') : L.t('tentativas restantes')}`; }
    say(msg, true); dotsEl.classList.add('shake', 'err'); Sound.play('error');
    setTimeout(() => { if (seq !== checkSeq) return; dotsEl.classList.remove('shake'); entry = ''; busy = false; renderDots(); if (blocked) startCool(r); setTimeout(() => dotsEl.classList.remove('err'), 250); }, 560);
  }
  /* conta sem código: o que pedia o teclado passa logo (desbloquear, ou confirmar na galeria de personalização) */
  function passNoPin() { lastAuth = Date.now(); if (verifyOnly) { const f = verifyOnly; verifyOnly = null; f(); return; } unlock(); }
  /* nunca o teclado do código com a galeria/editor aberto: ficava preso dentro do cartão (e o pedido pendente, p.ex. abrir uma
     notificação, disparava no desbloqueio seguinte). A galeria pede o código ANTES de abrir, por isso este caminho não a afeta. */
  /* 1.5.0: #screen.lk-pin enquanto o código está à vista (o fundo escurece: a barra de estado volta a branco mesmo com o topo do
     wallpaper claro, glass27.css "Tom automático") */
  const pinFlag = on => { const s = UI.screen && UI.screen(); if (s && s.classList.contains('lk-pin') !== !!on) s.classList.toggle('lk-pin', !!on); };
  function showPin() { if (!System.locked) return; if (inGallery()) { pending = null; verifyOnly = null; return; } if (noPin()) { passNoPin(); return; }
    /* a animação de acordar (.wake, fill both) prende o transform/opacity do relógio grande durante 700 ms - agora é por aí que ele sai com o teclado aberto */
    if (topEl) { clearTimeout(topEl._t); topEl.classList.remove('wake'); }
    if (!el.classList.contains('pin')) Sound.play('click'); el.classList.add('pin'); pinFlag(true); el.classList.remove('ok'); entry = ''; busy = false; checkSeq++; say(PT().enter, false); dotsEl.classList.remove('err', 'ok'); renderDots();
    if (builtOS === 'android') { closeMx(); paintFp(); }
    if (coolLeft()) { paintCool(); if (!coolT) coolT = setInterval(paintCool, 1000); } }
  function hidePin() { el.classList.remove('pin', 'ok'); pinFlag(false); entry = ''; busy = false; checkSeq++; dotsEl.classList.remove('err', 'ok'); renderDots(); pending = null; verifyOnly = null; }
  function requestUnlock(cb) { pending = cb; showPin(); }
  /* autenticação sem desbloquear (galeria do ecrã bloqueado): código só para confirmar; "autenticado há pouco" = 5 min desde o último desbloqueio/código */
  let verifyOnly = null, lastAuth = 0;
  function verifyPin(cb) { if (!System.locked) { cb && cb(); return; } verifyOnly = cb; showPin(); }
  function faceScan(cb) { if (foreignAcct()) { verifyPin(cb); return; }   /* STOLEN: telemóvel alheio = só o código */
    const face = el.querySelector('.lock-face'); if (face) { face.classList.remove('scan'); void face.offsetWidth; face.classList.add('scan'); } setTimeout(() => { if (face) face.classList.remove('scan'); lastAuth = Date.now(); cb && cb(); }, 550); }
  const authedRecently = () => Date.now() - lastAuth < 5 * 60000;
  /* ---------- Face Key (escolhido no assistente; alternável em Definições › Face Key e código) ----------
     Como no PearPhone: acordar o ecrã dispara o reconhecimento sozinho. O cadeado fecha → "olha" → ABRE e fica aberto (`.lock-face.ok`),
     a ilha faz a micro-animação, e a dica passa a "Deslize para cima para abrir". A partir daí qualquer deslize/toque abre SEM código.
     Se o Face Key estiver desligado, o deslize leva ao teclado do código, como antes. */
  let faceT = null, authed = false;
  const faceOn = () => System.state.faceIdUnlock === true && !foreignAcct();   /* STOLEN: nunca num telemóvel alheio */
  /* cara inscrita → o cadeado dá lugar à FOTOGRAFIA guardada enquanto reconhece */
  /* ⚠️ a fotografia é um data: URL em base64 - nunca dentro de uma string de HTML (as aspas fechavam o atributo style); vai pelo CSSOM */
  /* Nova UI: o reconhecimento facial anima só o cadeado pequeno (sem fotografia nem ilha) */
  const setFaceGlyph = face => { if (!face) return; if (builtOS === 'android') { face.innerHTML = A_LOCK; return; } const f = window.FaceID && FaceID.stored(); if (!f) { face.innerHTML = g('lock'); return; } face.innerHTML = '<span class="lf-shot"></span>'; face.firstElementChild.style.backgroundImage = UI.img(f); };
  function runFaceId() {
    /* `el` só existe depois de Lock.init(), e o init só corre quando há conta: durante o assistente
       o evento phone:open chegava na mesma e rebentava aqui (TypeError em cada abertura). */
    if (!el || !System.locked || authed || faceT || !faceOn() || el.classList.contains('pin')) return;
    const face = el.querySelector('.lock-face'); if (face) { face.classList.remove('ok'); setFaceGlyph(face); face.classList.remove('scan'); void face.offsetWidth; face.classList.add('scan'); }
    if (builtOS !== 'android' && window.Island && Island.faceId) Island.faceId();
    faceT = setTimeout(() => { faceT = null; if (!System.locked) return; authed = true; lastAuth = Date.now();
      if (face) { face.classList.remove('scan'); face.innerHTML = lockG(true); face.classList.add('ok'); }
      el.classList.add('faceok');   /* mostra a dica "Deslize para cima para abrir" (só existe depois do reconhecimento, como no PearPhone) */
      const h = el.querySelector('.lock-hint'); if (h) h.textContent = L.t('Deslize para cima para abrir');
      Sound.play('tock'); }, 650);
  }
  function faceOrPin() {
    if (!el || !System.locked || busy) return;
    if (authed) { unlock(); return; }                       /* já reconhecido ao acordar: abre já */
    if (!faceOn()) { showPin(); return; }
    if (faceT) return;                                       /* a reconhecer: o deslize espera pelo resultado */
    const face = el.querySelector('.lock-face'); if (face) { setFaceGlyph(face); face.classList.add('scan'); } Sound.play('click');
    faceT = setTimeout(() => { faceT = null; if (face) face.classList.remove('scan'); if (System.locked && !el.classList.contains('pin')) unlock(); }, 550);
  }
  function unlock() {
    /* Face Key (69): o cadeado abre e sobe, a ilha faz a micro-animação de reconhecimento */
    const face = el.querySelector('.lock-face'); if (face) { face.innerHTML = lockG(true); face.classList.add('open'); } if (builtOS !== 'android' && window.Island && Island.faceId) Island.faceId();
    if (builtOS === 'android') { closeMx(); clearTimeout(fpT); fpT = null; if (R.fp) R.fp.classList.remove('read', 'ok'); }
    if (window.LockGallery && LockGallery.isOpen()) LockGallery.close(true);
    lastAuth = Date.now(); System.locked = false; el.classList.add('out'); el.classList.remove('pin', 'gone', 'ok'); pinFlag(false); document.getElementById('home').classList.add('in'); UI.screen().classList.remove('locked');
    Sound.play('unlock'); entry = ''; busy = false; dotsEl.classList.remove('err', 'ok'); renderDots(); setTimeout(() => document.getElementById('home').classList.add('settled'), 700);
    /* acabada a animação, o lock fica invisível SEM transform/filter (no CEF uma superfície desfocada maior que o ecrã pintava um retângulo preto atrás do telemóvel) */
    clearTimeout(el._goneT); el._goneT = setTimeout(() => { if (!System.locked) el.classList.add('gone'); }, 650);
    Bridge.emit('unlock'); const cb = pending; pending = null; if (cb) setTimeout(cb, 200);
  }
  function lock(instant) {
    if (System.currentApp()) System.closeApp(true);
    if (window.Notify) Notify.close(); if (window.CC) CC.close(); if (window.Switcher) Switcher.close(); if (window.Home) { Home.closeFolder(); Home.exitEdit(); if (Home.closeSearch) Home.closeSearch(true); }
    System.locked = true; clearTimeout(el._goneT); el.classList.remove('gone'); void el.offsetWidth; el.classList.remove('out', 'pin', 'ok'); pinFlag(false); document.getElementById('home').classList.remove('in', 'settled'); UI.screen().classList.add('locked');
    const face = el.querySelector('.lock-face'); if (face) { face.innerHTML = lockG(false); face.classList.remove('open', 'ok', 'scan'); }
    authed = false; clearTimeout(faceT); faceT = null; el.classList.remove('faceok');   /* bloquear invalida o reconhecimento anterior */
    const h = el.querySelector('.lock-hint'); if (h) h.textContent = L.t('Deslize para cima para desbloquear');
    entry = ''; busy = false; pending = null; dotsEl.classList.remove('err', 'ok'); renderDots(); if (!instant) Sound.play('lock');
    if (builtOS === 'android') { closeMx(); paintFp(); clearTimeout(fpT); fpT = null; if (R.fp) R.fp.classList.remove('read', 'ok'); followA(0, 0, 0, true); }
    Notify.renderLock(); renderWidgets(); renderShortcuts(); applyClock(); wake(); Bridge.emit('lock');
  }
  /* ---------- relógio: alinhamento (center/left/right), posição (top/middle) e estilo (glass/solid/outline) ----------
     Vivem no estado (a galeria grava-os por ecrã bloqueado e aplica-os); aqui só se passam para atributos do #lock, que o lock.css lê.
     Valores fora da lista caem no predefinido - o estado vem da conta e pode trazer lixo. */
  /* ---------- 1.4.0 (PearOS 27): TAMANHO CONTÍNUO do relógio ----------
     state.clockScale (0,72 … 1,75; 1 = os 176 px de sempre) substitui o pequeno/normal/grande (clockSize, que se lê como ,85 / 1 /
     1,14 enquanto não houver clockScale). O CSS (lock.css) só conhece três variáveis no :root: --clock-k, --clock-kx (a parte que
     cresce em largura, até 1,15 - acima disso "22:18" sai dos 440 px) e --clock-sy (o resto, esticão vertical). Quem as escreve é
     o System.apply (System.clockVars/CLOCK_KX); aqui há a mesma conta como recurso, para o ecrã nunca ficar sem tamanho se o
     system.js for de uma versão sem elas. */
  const K_MIN = .72, K_MAX = 1.75;
  const KX = () => (window.System && +System.CLOCK_KX > 0) ? +System.CLOCK_KX : 1.15;
  const clampK = k => Math.max(K_MIN, Math.min(K_MAX, k));
  const clockVars = k => { if (window.System && typeof System.clockVars === 'function') { try { const v = System.clockVars(k); if (v && isFinite(v.kx) && isFinite(v.sy)) return v; } catch (e) {} }
    const kx = KX(); return { kx: Math.min(k, kx), sy: Math.max(1, k / kx) }; };
  /* k de um ecrã bloqueado (lockScreens[i]) ou do estado: clockScale quando é um número dentro dos limites, senão o clockSize antigo */
  function kOf(src) { const s = src || (window.System && System.state) || {}; const v = s.clockScale == null || s.clockScale === '' ? NaN : +s.clockScale;
    if (isFinite(v) && v >= K_MIN - 1e-6 && v <= K_MAX + 1e-6) return clampK(v);
    return ({ small: .85, large: 1.14 })[s.clockSize] || 1; }
  /* medidas do relógio de um ecrã (cartões da galeria: lockgallery.js mock) - os mesmos números que o lock.css calcula */
  function clockMetrics(ls) { const k = kOf(ls), v = clockVars(k), r = n => Math.round(n * 1000) / 1000, nf = NUMERALS.find(n => n[0] === (ls || (window.System && System.state) || {}).clockNumerals);
    return { k: r(k), kx: r(v.kx), sy: r(v.sy), fs: r(176 * v.kx), fsWide: r(160 * v.kx), numFit: nf ? nf[3] : 1 }; }   /* numFit: em dos dígitos e dos dois pontos noutro sistema de numeração */
  const putVars = k => { const v = clockVars(k), st = document.documentElement.style; st.setProperty('--clock-k', k.toFixed(3)); st.setProperty('--clock-kx', v.kx.toFixed(3)); st.setProperty('--clock-sy', v.sy.toFixed(3)); };
  /* PRÉ-VISUALIZAÇÃO ao vivo (pega do editor, lockeditor.js): reescreve as três variáveis no máximo uma vez por frame. Nada de
     System.setState por frame (gravava a conta e refazia o apply a 60 Hz); quem grava é o editor ao largar (updateCur). Com o
     telemóvel guardado (body.hidden) não faz nada. null = cancelar: volta ao que está no estado (o System.apply reescreve-as).
     O rAF pode não correr (CEF sem foco, headless): um setTimeout curto garante a pintura. */
  let pvK = null, pvRaf = 0, pvTo = 0;
  function previewScale(k) {
    if (k == null || !isFinite(+k)) { pvK = null; if (pvRaf) cancelAnimationFrame(pvRaf); clearTimeout(pvTo); pvRaf = 0; pvTo = 0;
      if (window.System && typeof System.clockVars === 'function' && System.apply) System.apply(); else putVars(kOf()); return; }
    if (document.body.classList.contains('hidden')) return;
    pvK = clampK(+k); if (pvRaf || pvTo) return;
    const run = () => { if (pvRaf) cancelAnimationFrame(pvRaf); clearTimeout(pvTo); pvRaf = 0; pvTo = 0; if (pvK != null) putVars(pvK); };
    pvRaf = requestAnimationFrame(run); pvTo = setTimeout(run, 40);
  }
  /* recurso para um system.js sem o 1.4.0: as variáveis e o atributo dos numerais escritos daqui (com o System novo nada disto corre) */
  function syncClockFallback() { if (!window.System || typeof System.clockVars === 'function' || isAnd()) return; putVars(kOf());
    const id = NUM_DIGITS[System.state.clockNumerals] ? System.state.clockNumerals : 'latn'; if (document.body.dataset.numerals !== id) document.body.dataset.numerals = id; }
  /* ---------- SISTEMAS DE NUMERAÇÃO (Fonte e cor › globo) ----------
     Só os dígitos do relógio grande mudam (o relógio pequeno do teclado e a data ficam ocidentais, como no iOS). O nome é a chave
     PT (quem mostra embrulha com L.t). A fonte escolhida para o relógio não tem estes algarismos: o lock.css troca para as fontes do
     sistema do Windows do jogo (Nirmala UI, Leelawadee UI, Myanmar Text, YaHei...) com body[data-numerals] ≠ latn. */
  /* [id, nome PT, algarismos 0-9, fator de tamanho]. O 4.º é o fator em que os algarismos (e os dois pontos) têm de encolher para
     "88:88" caber na largura do ocidental (medido nas fontes do Windows; o lock.css tem os MESMOS números em body[data-numerals] -
     mudar os dois juntos). Os cartões da galeria leem-no via clockMetrics(ls).numFit. */
  const NUMERALS = [
    ['latn', 'Ocidental', '0123456789', 1], ['arab', 'Árabe-índico', '٠١٢٣٤٥٦٧٨٩', .83], ['arabext', 'Persa', '۰۱۲۳۴۵۶۷۸۹', .83], ['deva', 'Devanágari', '०१२३४५६७८९', .72],
    ['beng', 'Bengali', '০১২৩৪৫৬৭৮৯', .58], ['guru', 'Gurmukhi', '੦੧੨੩੪੫੬੭੮੯', .8], ['gujr', 'Guzerate', '૦૧૨૩૪૫૬૭૮૯', .71], ['taml', 'Tâmil', '௦௧௨௩௪௫௬௭௮௯', .48],
    ['telu', 'Telugu', '౦౧౨౩౪౫౬౭౮౯', .59], ['knda', 'Canarês', '೦೧೨೩೪೫೬೭೮೯', .63], ['mlym', 'Malaiala', '൦൧൨൩൪൫൬൭൮൯', .52], ['thai', 'Tailandês', '๐๑๒๓๔๕๖๗๘๙', .56],
    ['laoo', 'Laosiano', '໐໑໒໓໔໕໖໗໘໙', .55], ['khmr', 'Khmer', '០១២៣៤៥៦៧៨៩', .61], ['tibt', 'Tibetano', '༠༡༢༣༤༥༦༧༨༩', .68], ['mymr', 'Birmanês', '၀၁၂၃၄၅၆၇၈၉', .8],
    ['hanidec', 'Chinês', '〇一二三四五六七八九', .49],
  ];
  const NUM_DIGITS = {}; NUMERALS.forEach(n => { NUM_DIGITS[n[0]] = [...n[2]]; });
  /* "12:34" com os algarismos do sistema pedido (':' fica). Aceita uma Date (passa pelo UI.fmtTime, 12/24 h) ou um texto já feito
     (as amostras "12" da folha Fonte e cor). Sem `numerals` (ou desconhecido) → ocidental, e NÃO o do estado: um cartão da galeria
     de um ecrã antigo (sem clockNumerals) não pode herdar os algarismos do ecrã atual. O relógio do #lock passa o do estado. */
  function clockText(d, numerals) {
    const s = typeof d === 'string' ? d : UI.fmtTime(d instanceof Date ? d : new Date());
    const m = NUM_DIGITS[numerals];
    return !m || numerals === 'latn' ? s : s.replace(/[0-9]/g, c => m[+c]);
  }
  const CLOCK_OPTS = { clockAlign: ['center', 'left', 'right'], clockPos: ['top', 'middle'], clockStyle: ['glass', 'solid', 'outline'] };
  const clockVal = (k, s) => { const v = (s || System.state)[k]; return CLOCK_OPTS[k].includes(v) ? v : CLOCK_OPTS[k][0]; };
  function applyClock() { if (!el) return; Object.keys(CLOCK_OPTS).forEach(k => { const v = clockVal(k); const a = 'data-' + k.toLowerCase(); if (el.getAttribute(a) !== v) el.setAttribute(a, v); });
    /* 1.5.0 PearOS, tom automático (glass27.css): com a cor de origem (#FFFFFF, "Automático" na folha Fonte e cor) o relógio, a data, o
       cadeado e os widgets escurecem sozinhos sobre um topo de wallpaper claro (#screen.wpl-top-light, medido pelo glass.js); uma cor
       escolhida fica como está. A chave gravada continua a ser clockColor: #FFFFFF = automático (as contas existentes nunca mexeram nela) */
    { const auto = builtOS !== 'android' && String(System.state.clockColor || '#FFFFFF').toUpperCase() === '#FFFFFF'; if (el.classList.contains('clock-auto') !== auto) el.classList.toggle('clock-auto', auto); }
    if (builtOS === 'android') { el.classList.toggle('als-cw', String(System.state.clockColor || '#FFFFFF').toUpperCase() === '#FFFFFF'); glassPos(); } }   /* Nova UI: relógio na cor de origem → acompanha o fundo claro/escuro; a posição do relógio mexe nos widgets (vidro) */
  Bridge.on('state', p => { if (p && (p.clockAlign !== undefined || p.clockPos !== undefined || p.clockStyle !== undefined || p.clockColor !== undefined)) applyClock();
    /* Definições › Dados biométricos: registar um dedo ou ligar o desbloqueio mostra o sensor já (sem esperar pelo próximo bloqueio) */
    if (p && el && builtOS === 'android' && (p.fpUnlock !== undefined || p.fpEnrolled !== undefined)) paintFp();
    if (p && el && builtOS === 'android' && p.lockControls !== undefined) renderShortcuts();
    /* PearOS 27: outro sistema de numeração → os dígitos refazem-se já; tema / foco / lanterna mudados noutro sítio (Centro de
       controlo, Definições) → os atalhos-interruptor (Modo escuro, Não incomodar, Lanterna) acendem/apagam sem esperar pelo bloqueio.
       O `dark` é derivado no apply (o patch traz `theme`), por isso olha-se para os dois. */
    if (p && el && builtOS !== 'android') {
      if (p.clockScale !== undefined || p.clockSize !== undefined || p.clockNumerals !== undefined) syncClockFallback();
      if (p.clockNumerals !== undefined) tick(new Date(), true);
      if (p.theme !== undefined || p.dark !== undefined || p.dnd !== undefined || p.focus !== undefined || p.torch !== undefined || p.airplane !== undefined || p.wifi !== undefined || p.cellular !== undefined || p.bt !== undefined || p.nightShift !== undefined || p.lowPower !== undefined) paintToggles();
    } });
  /* 1.4.1: texto dos widgets do ecrã principal no estilo Colorido (homecustom.css). O --icon-tint-rgb do icons.js é a cor a meia luz; sobre o
     vidro escuro tingido o texto é a tinta CLARA dos glifos dos ícones (matiz, saturação × ,8, luz 82 %). Sem color-mix no CEF não dá para
     aclarar em CSS: faz-se a conta aqui, a cada restyle (também a meio de um arrasto das barras, é só uma variável). */
  function tintLight() { if (!window.Icons || !Icons.style) return; const s = Icons.style(), h = ((+s.hue % 360) + 360) % 360, sat = Math.max(0, Math.min(1, +s.sat * .8)), l = .82, a = sat * Math.min(l, 1 - l);
    const f = n => { const k = (n + h / 30) % 12; return Math.round((l - a * Math.max(-1, Math.min(k - 3, 9 - k, 1))) * 255); };
    document.documentElement.style.setProperty('--icon-tint-lt', f(0) + ',' + f(8) + ',' + f(4)); }
  Bridge.on('icons:restyled', tintLight);
  /* troca de item com o telemóvel a correr (PearPhone ↔ NOVA): a marcação do sistema novo; o estado (bloqueado, Face Key, contagem) fica */
  Bridge.on('os:changed', () => {
    if (!el || builtOS === (isAnd() ? 'android' : 'ios')) return;
    if (el.classList.contains('pin')) hidePin();
    clearTimeout(fpT); fpT = null; el.classList.remove('has-np', 'als-hasw', 'als-fpon', 'als-lt', 'als-cw', 'press-hint', 'press-pop');
    build(); renderWidgets(); applyClock(); tick(new Date(), true);
    try { if (window.Notify && Notify.renderLock) Notify.renderLock(); } catch (e) {}
    if (coolLeft()) paintCool();
  });
  /* relógio: entra a 1.15 → 1 com fade e mola (ao bloquear / acordar). `fromSleep` = o ecrã acendeu → o Face Key reconhece sozinho, como no PearPhone */
  function wake(fromSleep) { if (!topEl) return; tick(new Date(), true); topEl.classList.remove('wake'); void topEl.offsetWidth; topEl.classList.add('wake'); clearTimeout(topEl._t); topEl._t = setTimeout(() => topEl.classList.remove('wake'), 700);
    if (fromSleep) setTimeout(runFaceId, 420); }
  Bridge.on('phone:open', () => { if (System.locked) setTimeout(runFaceId, 500); });   /* abrir o telemóvel no jogo também dispara o reconhecimento */
  /* relógio: cada carácter é um span; quando muda, o antigo sobe e desvanece e o novo entra por baixo (mola .35s) */
  /* Nova UI: "qui., 1 de outubro" (dia abreviado com ponto, como o sistema em pt-PT) */
  function dateA(d) {
    if (window.L && L.code && L.code !== 'pt') { try { return new Intl.DateTimeFormat(L.intl(), { weekday: 'short', day: 'numeric', month: 'long' }).format(d); } catch (e) {} }
    return `${UI.DIAS_C[d.getDay()].toLowerCase()}., ${d.getDate()} de ${UI.MESES[d.getMonth()]}`;
  }
  /* FUNDO CLARO (Nova UI): como o sistema a sério, o texto do ecrã bloqueado (todo, numa só cor) passa a escuro quando o fundo
     é claro por trás do relógio. Mede-se a cópia pré-desfocada do fundo (--wp-lock-blur, já
     feita pelo System: um data: URL, sem problemas de CORS) num canvas de 12×26, só quando ela muda. O relógio só escurece se
     a cor dele for a de origem (branco): uma cor escolhida no editor é respeitada. */
  let lumaVar = null, lumaSeq = 0;
  const lumOf = (r, g2, b) => (.2126 * r + .7152 * g2 + .0722 * b) / 255;
  function setLuma(top) { if (!el) return; el._luma = +(+top).toFixed(3); el.classList.toggle('als-lt', top > .6); }   /* 0,6: os fundos de cor média (azul-celeste) ficam com o branco, os claros passam a texto escuro (uma só cor para o ecrã inteiro) */
  function lumaCheck(force) {
    if (builtOS !== 'android' || !el) return; const scr = UI.screen(); if (!scr) return;
    const v = scr.style.getPropertyValue('--wp-lock-blur') || ''; if (v === lumaVar && !force) return; lumaVar = v; const seq = ++lumaSeq;
    const m = /url\("([^"]+)"\)/.exec(v) || /url\('([^']+)'\)/.exec(v) || /url\(([^)]+)\)/.exec(v);
    if (!m) { const h = /#([0-9a-f]{6})/i.exec(v); if (!h) { setLuma(0); return; } const n = parseInt(h[1], 16); setLuma(lumOf(n >> 16, (n >> 8) & 255, n & 255)); return; }   /* cor / gradiente: a primeira cor */
    const img = new Image(); if (!/^data:/.test(m[1])) img.crossOrigin = 'anonymous';
    img.onload = () => { if (seq !== lumaSeq) return; try { const W = 12, H = 26, c = document.createElement('canvas'); c.width = W; c.height = H; const x = c.getContext('2d'); x.drawImage(img, 0, 0, W, H);
      const d = x.getImageData(0, 0, W, H).data; const avg = (y0, y1) => { let s = 0, n = 0; for (let y = y0; y < y1; y++) for (let k = 0; k < W; k++) { const i = (y * W + k) * 4; s += lumOf(d[i], d[i + 1], d[i + 2]); n++; } return n ? s / n : 0; };
      setLuma(avg(3, 12)); } catch (e) { setLuma(0); } };
    img.onerror = () => { if (seq === lumaSeq) setLuma(0); };
    img.src = m[1];
  }
  /* relógio empilhado: 4 dígitos fixos (HH por cima, MM por baixo), sempre com dois algarismos. Só o dígito que muda troca
     de texto, com uma subida curta (transform/opacity); a estrutura nunca se refaz */
  function tickA(d, force) {
    const h = d.getHours(), H = System.state.clock24 === false ? ((h % 12) || 12) : h, str = UI.pad(H) + UI.pad(d.getMinutes());
    const ds = dateA(d); if (dateEl && dateEl.textContent !== ds) dateEl.textContent = ds;
    if (R.wx) { const wx = wxNow(), sig = wx.icon + '|' + wx.t; if (R.wxSig !== sig) { R.wxSig = sig; R.wx.innerHTML = `${wxG(wx.icon)}<span>${wx.t}°</span>`; } }
    if (System.locked) renderNowBar(); else if (nb && nb.on) renderNowBar();
    paintFp(); if (glassDirty) glassPos(); lumaCheck();
    if (R.mx && R.mx.classList.contains('on')) paintMx();
    if (str === lastHM && !force) return;
    const anim = !!lastHM && !force;
    R.digits.forEach((slot, i) => { const c = str[i]; const cur = slot.querySelector('.n:not(.out)');
      if (!anim) { slot.querySelectorAll('.n.out').forEach(x => x.remove()); if (cur) { cur.classList.remove('in'); if (cur.textContent !== c) cur.textContent = c; } else slot.innerHTML = `<span class="n">${c}</span>`; return; }
      if (!cur || cur.textContent === c) return;
      cur.classList.add('out'); const nw = document.createElement('span'); nw.className = 'n in'; nw.textContent = c; slot.appendChild(nw);
      requestAnimationFrame(() => requestAnimationFrame(() => nw.classList.remove('in'))); setTimeout(() => cur.remove(), 420);
    });
    lastHM = str;
  }
  function tick(d, force) {
    if (!el) return;
    if (builtOS === 'android') { tickA(d, force); return; }
    const hm = UI.fmtTime(d);
    if (pcClock && pcClock.textContent !== hm) pcClock.textContent = hm;   /* relógio pequeno do teclado do código (elemento próprio: o grande já não encolhe por font-size) */
    if (dateEl) { const ds = UI.fmtDate(d, false, true); if (dateEl.textContent !== ds) dateEl.textContent = ds; }   /* "terça-feira, 8 de setembro"; só escreve quando muda (não invalida o lock a cada segundo) */
    if (System.locked && lkwSig) lkwRefresh();   /* widgets do bloqueado: só o miolo que mudou */
    if (System.locked) renderNowPlaying(); else if (npEl) { npEl.remove(); npEl = null; el.classList.remove('has-np'); const h = el.querySelector('.lock-np'); if (h) h.classList.remove('on'); }   /* cartão "A tocar": o tick é a única batida (sem temporizador próprio) */
    if (System.locked) paintToggles();   /* tema automático (dia/noite) muda sem patch de estado: o interruptor do Modo escuro acompanha */
    /* 1.4.0: o relógio grande com os algarismos do sistema de numeração escolhido (o pequeno e a data ficam ocidentais) */
    const big = clockText(hm, System.state.clockNumerals);
    if (!clockEl || (big === lastHM && !force)) return;
    clockEl.classList.toggle('wide', hm.length > 4);   /* "10:59" → dígitos mais estreitos para caber (PearOS 26); a contagem é a mesma em qualquer numeração */
    const chars = [...big]; let slots = [...clockEl.children];
    /* data-c: o algarismo do slot, para a auréola do relógio do PearPhone Fold (lock.css, uma cópia só com sombra atrás dos dígitos) */
    if (force || slots.length !== chars.length) { clockEl.innerHTML = chars.map(c => `<span class="${c === ':' ? 'c' : 'd'}" data-c="${c}"><span class="n">${c}</span></span>`).join(''); lastHM = big; return; }
    chars.forEach((c, i) => {
      const slot = slots[i]; const cur = slot.querySelector('.n:not(.out)'); if (!cur || cur.textContent === c) return;
      slot.dataset.c = c; cur.classList.add('out'); const nw = document.createElement('span'); nw.className = 'n in'; nw.textContent = c; slot.appendChild(nw);
      requestAnimationFrame(() => requestAnimationFrame(() => nw.classList.remove('in'))); setTimeout(() => cur.remove(), 450);
    });
    lastHM = big;
  }
  function key(e) {
    if (!System.locked || document.activeElement && document.activeElement.matches('input,textarea')) return;
    if (/^[0-9]$/.test(e.key)) { if (!el.classList.contains('pin')) showPin(); pressKey(kp.querySelector(`[data-n="${e.key}"]`)); Sound.play('keypad'); push(e.key); }
    else if (e.key === 'Backspace' && !busy) { entry = entry.slice(0, -1); renderDots(); }
    else if (e.key === 'Enter' && builtOS === 'android' && el.classList.contains('pin') && entry) okKey();   /* Nova UI: Enter é a tecla OK */
    else if (e.key === 'ArrowUp' || e.key === 'Enter') showPin();
  }
  return { init, lock, unlock, showPin, hidePin, requestUnlock, verifyPin, faceScan, runFaceId, authedRecently, tick, key, wake, renderWidgets, renderShortcuts,
    /* widgets do bloqueado do PearOS (lockgallery.js: folha "Adicionar widgets" e cartões laterais) */
    widgets: { list: () => LKW_ORDER.map(k => ({ k, kind: LKW[k].kind, name: LKW[k].name, app: lkwApp(k) || null })), html: k => lkwHTML(k), fit: lkwFit, slot: lkwSlot, SLOTS: LKW_SLOTS }, renderNowPlaying, emergency, applyClock, CONTROLS, renderNotifs: () => Notify.renderLock(),
    /* 1.4.0 (PearOS 27): galeria de controlos (CONTROL_ORDER, controlOf com "app:<id>", controlIcon), tamanho contínuo do relógio
       (previewScale ao vivo, clockMetrics para os cartões da galeria) e sistemas de numeração (NUMERALS, clockText) */
    CONTROL_ORDER, CONTROL_TOP, CONTROL_SECTIONS, controlOf, controlIcon, previewScale, clockMetrics, NUMERALS, clockText, get faceAuthed() { return authed; }, get pinShown() { return el && el.classList.contains('pin'); }, get cooldown() { return coolLeft(); },
    /* Nova UI: o sensor de impressão digital está ativo (Definições e testes) */ get fingerprint() { return fpOn(); }, bioPass, refreshGlass: glassPos };
})();
