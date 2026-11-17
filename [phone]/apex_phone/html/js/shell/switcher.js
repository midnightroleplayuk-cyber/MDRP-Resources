/* ============================================================
   APP SWITCHER (PearOS 17/26 + pedidos do utilizador) - cartões das apps
   recentes a 62 % do ecrã, a app atual centrada e as anteriores à esquerda
   (scroll horizontal com snap), ícone + nome por cima de cada cartão e um
   "×" para fechar essa app, botão "Fechar tudo" em baixo, swipe para cima
   fecha a app, toque no cartão reabre-a (a janela cresce a partir do cartão),
   toque fora → ecrã principal. Entrada a partir do gesto do indicador:
   o cartão nasce exatamente onde a app estava a ser arrastada.

   NOVA UI (Android, 2026-10-01): o mesmo motor com o aspeto dos Recentes da
   Nova UI 8.5. Cartões grandes (70 % da largura, raio 28) num carrossel, o
   ícone e o nome da app ao centro por cima do cartão (tocar abre um menu com
   "Informações da app" e "Manter aberta"), sem "×" (fecha-se a deslizar o
   cartão para cima), "Fechar tudo" em baixo ao centro e o fundo desfocado pela
   cópia pré-desfocada do wallpaper (no CEF não há backdrop-filter). As apps
   mantidas abertas ficam de fora do "Fechar tudo" (só durante a sessão).
   ============================================================ */
window.Switcher = (() => {
  const g = UI.g; const CARD_W = 273, CARD_H = 593, K = CARD_W / 440;           /* 440×956 × .62 */
  /* Nova UI: o cartão tem 70 % da largura do ecrã (308 px) e a janela entra lá com zoom (nítido no CEF) */
  const A_K = .7, A_W = 440 * A_K;
  const isA = () => !!(window.System && System.os === 'android');
  /* escala do cartão: telemóveis .62 (PearOS) / .7 (Nova UI); dobráveis .6 fechado e .5 aberto (o cartão tem a forma do ecrã,
     670×956 ou 1340×956, e a janela entra com zoom: liquid27.css / oneui-extras.css, --sw-k) */
  const cardK = () => (window.System && System.form === 'fold') ? (System.foldOpen ? .5 : .6) : (isA() ? A_K : K);
  /* o id vem também de apps registadas por OUTROS resources: entra num atributo e depois num seletor.
     Com aspas ou "]" partia o cartão e o querySelector atirava SyntaxError (mesmo critério do notify.js:351). */
  const cssEsc = v => (window.CSS && CSS.escape) ? CSS.escape(String(v)) : String(v).replace(/[^\w-]/g, '\\$&');
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, v) => (window.L && L.tf ? L.tf(s, v) : s.replace('%s', v));
  let el, track, allBtn, hideT = null;
  /* Nova UI: menu do ícone (um de cada vez) e apps mantidas abertas (memória da sessão, nunca gravado) */
  let menu = null; const keep = new Set();
  const LOCK_SVG = '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="11" width="14" height="10" rx="2.5"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/></svg>';
  function init() {
    /* SEM botão "Fechar tudo": o PearPhone não tem nenhum - fecha-se cada app arrastando o cartão para cima.
       (Foi pedido numa ronda anterior por causa de um telemóvel de referência; sai agora por fidelidade ao PearOS.
       A função closeAll continua exportada para quem a queira chamar.) */
    el = UI.el(`<div id="switcher"><div class="sw-track"></div><div class="sw-all lg hidden">Fechar tudo</div></div>`); track = el.querySelector('.sw-track'); allBtn = el.querySelector('.sw-all'); UI.screen().appendChild(el);
    /* Nova UI: com o menu do ícone aberto, o primeiro toque fora só fecha o menu */
    el.onclick = e => { if (menu) { if (!e.target.closest('.ars-menu')) closeMenu(); return; } if (e.target === el || e.target === track) close(); };
    allBtn.onclick = e => { e.stopPropagation(); closeAll(); };
    /* roda do rato: percorre os cartões para a esquerda e para a direita (pedido do utilizador) */
    el.addEventListener('wheel', e => { e.preventDefault(); closeMenu(); const d = Math.abs(e.deltaX) > Math.abs(e.deltaY) ? e.deltaX : e.deltaY; track.scrollLeft += d * 1.4; }, { passive: false });
    /* uma app morta noutro sítio (LRU, Definições, troca de sistema) deixa de estar "mantida aberta" */
    Bridge.on('app:kill', id => keep.delete(id));
    Bridge.on('os:changed', () => { closeMenu(); keep.clear(); });
  }
  const isOpen = () => el && el.classList.contains('in');
  const zoom = () => UI.zoom();   /* em cache (ui.js): sem layout forçado em cada pointermove */
  /* Janela VIVA no cartão (spec 11): a própria .app-window é movida para dentro do .sw-card (mesmo elemento, sem clone) e volta ao #apps ao fechar.
     Apps externas (iframe) ficam com um cartão-símbolo: mover um iframe no DOM recarregava-o. */
  const appsEl = () => document.getElementById('apps');
  const restore = id => { const win = System.windows[id]; if (win && win.classList.contains('in-card')) { win.classList.remove('in-card'); win.style.transform = ''; win.style.transformOrigin = ''; win.style.backgroundColor = ''; appsEl().appendChild(win); } };
  const restoreAll = () => Object.keys(System.windows).forEach(restore);
  /* fecha uma app a partir do seu cartão: o cartão sobe e desvanece, a app é morta */
  function killItem(item, id) { if (!item || item.classList.contains('up')) return; closeMenu(); keep.delete(id); item.classList.add('up'); Sound.play('click'); System.killApp(id); setTimeout(() => { item.remove(); if (!track.querySelector('.sw-item')) { if (isA()) empty(); else close(); } else syncAll(); }, 300); }
  /* "Fechar tudo": no PearOS fecha todas; na Nova UI as mantidas abertas ficam (e o ecrã fica nelas) */
  function closeAll() {
    closeMenu();
    const all = [...track.querySelectorAll('.sw-item')]; const items = isA() ? all.filter(it => !keep.has(it.dataset.id)) : all;
    if (!items.length) { close(); return; } Sound.play('click'); allBtn.classList.add('hidden');
    items.forEach((it, i) => { it.style.transitionDelay = `${i * .04}s`; it.classList.add('up'); System.killApp(it.dataset.id); });
    setTimeout(() => { if (items.length === all.length) { track.innerHTML = ''; close(); } else { items.forEach(it => it.remove()); close(); } }, 320 + items.length * 40);
  }
  /* o botão "Fechar tudo" só aparece com apps que ele possa fechar */
  function syncAll() { const its = [...track.querySelectorAll('.sw-item')]; allBtn.classList.toggle('hidden', !(isA() ? its.some(it => !keep.has(it.dataset.id)) : its.length)); }
  /* Nova UI: sem apps, o ecrã de recentes fica aberto com "Sem apps recentes" (toque fora ou Voltar fecha) */
  function empty() { track.innerHTML = `<div class="sw-empty">${UI.esc(T('Sem apps recentes'))}</div>`; allBtn.classList.add('hidden'); }

  /* ---------- Nova UI: menu do ícone ---------- */
  function closeMenu() { if (!menu) return; const m = menu; menu = null; m.classList.remove('in'); setTimeout(() => m.remove(), 180); }
  function openMenu(item, id) {
    if (menu && menu.dataset.id === id) { closeMenu(); return; } closeMenu(); Sound.play('click');
    const kept = keep.has(id);
    const m = UI.el(`<div class="ars-menu" data-id="${UI.esc(id)}"><div class="ars-mi" data-a="info">${UI.esc(T('Informações da app'))}</div><div class="ars-mi" data-a="keep">${UI.esc(T(kept ? 'Deixar de manter aberta' : 'Manter aberta'))}</div></div>`);
    m.onclick = e => { e.stopPropagation(); const a = e.target.closest('.ars-mi'); if (!a) return; Sound.play('click');
      if (a.dataset.a === 'info') { closeMenu(); appInfo(id); return; }
      if (keep.has(id)) keep.delete(id); else keep.add(id);
      item.classList.toggle('kept', keep.has(id)); syncAll(); closeMenu();
      UI.toast(TF(keep.has(id) ? '%s fica aberta (o Fechar tudo não a fecha)' : '%s já não fica aberta', App.name(id))); };
    item.appendChild(m); menu = m;
    requestAnimationFrame(() => { if (menu === m) m.classList.add('in'); });
  }
  /* Informações da app = Definições › Apps › <app> (o mesmo ecrã das Definições, aberto já na app certa) */
  function appInfo(id) {
    close();
    setTimeout(() => {
      System.openApp('settings');
      setTimeout(() => {
        Bridge.emit('settings:goto', 'apps');
        setTimeout(() => { try { const w = System.windows.settings; if (!w) return; const vs = w.querySelectorAll('.view'), top = vs[vs.length - 1]; const name = App.name(id);
          const li = top && [...top.querySelectorAll('.li')].find(x => { const l = x.querySelector('.li-label'); return l && l.textContent.trim() === name; }); if (li) li.click(); } catch (e) {} }, 520);
      }, 380);
    }, 420);
  }

  function open(opts = {}) {
    if (!el) return; clearTimeout(hideT); closeMenu(); restoreAll(); track.innerHTML = ''; el.classList.toggle('hand', !!opts.geo);
    const A = isA(); el.classList.toggle('ars', A);
    if (System.landscape && System.rotate) System.rotate(false);   /* os cartões são sempre ao alto */
    /* Nova UI: a altura da janela das apps depende da barra de navegação (908 com botões, 956 com gestos) e o cartão segue-a */
    const wh = A ? ((appsEl() && appsEl().offsetHeight) || 956) : 956;
    if (A) el.style.setProperty('--ars-wh', wh + 'px'); else el.style.removeProperty('--ars-wh');
    const ids = System.recents.filter(id => System.windows[id]).slice().reverse();     /* mais antiga → atual (a atual fica à direita, centrada) */
    if (!ids.length) track.innerHTML = `<div class="sw-empty">${A ? UI.esc(T('Sem apps recentes')) : 'Sem apps recentes'}</div>`;
    allBtn.classList.toggle('hidden', !ids.length);
    if (A) allBtn.textContent = T('Fechar tudo'); else allBtn.textContent = 'Fechar tudo';
    /* entrar no switcher suspende a app atual (como no PearOS) ANTES de a mover para o cartão: sem app "aberta", toque fora = ecrã principal */
    if (System.currentApp()) System.closeApp(true);
    ids.forEach((id, i) => {
      const win = System.windows[id]; const def = App.get(id) || {};
      const item = A
        ? UI.el(`<div class="sw-item ars-item${keep.has(id) ? ' kept' : ''}" data-id="${UI.esc(id)}"><div class="sw-lbl ars-lbl"><div class="tile">${Icons.tile(id)}</div><span>${UI.esc(App.name(id))}</span><i class="ars-lock">${LOCK_SVG}</i></div><div class="sw-card"></div></div>`)
        : UI.el(`<div class="sw-item" data-id="${UI.esc(id)}"><div class="sw-lbl"><div class="tile">${Icons.tile(id)}</div><span>${UI.esc(App.name(id))}</span><div class="sw-x" title="Fechar">${g('x')}</div></div><div class="sw-card"></div></div>`);
      const card = item.querySelector('.sw-card');
      if (def.external || win.querySelector('iframe')) card.appendChild(UI.el(`<div class="sw-ph"><div class="tile">${Icons.tile(id)}</div></div>`));
      else {
        /* apps escuras (FaceCall, Onion, Dark Chat…): o cartão e a janela usam o --bg claro do tema e os cantos arredondados
           deixavam uma linha branca à volta - pinta-se ambos com a cor da vista de topo da app. Lê-se ANTES de mover a
           janela: o cartão ainda não está no documento e aí o getComputedStyle devolve vazio. */
        const vw = win.querySelectorAll('.view'), top = vw[vw.length - 1];
        const bc = top && getComputedStyle(top).backgroundColor;
        if (bc && bc !== 'transparent' && !/rgba\(0, 0, 0, 0\)/.test(bc)) { card.style.background = bc; win.style.backgroundColor = bc; }
        win.classList.remove('open', 'closing', 'dragging', 'settle'); win.style.transform = ''; win.style.transformOrigin = ''; win.classList.add('in-card'); card.appendChild(win); }
      if (A) item.querySelector('.ars-lbl').onclick = e => { e.stopPropagation(); openMenu(item, id); };
      else item.querySelector('.sw-x').onclick = e => { e.stopPropagation(); killItem(item, id); };
      /* swipe para cima = fechar a app (segue o dedo, velocidade decide); toque = reabrir */
      let s = null;
      /* eixo travado no 1.º movimento: vertical = fechar a app (segue o dedo), horizontal = percorrer os cartões arrastando (no jogo o rato não faz scroll nativo) */
      card.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; if (menu) { closeMenu(); return; } s = { y: e.clientY, x: e.clientX, ly: e.clientY, lt: Date.now(), v: 0, moved: false, axis: null, sl: track.scrollLeft }; item.classList.add('drag'); try { card.setPointerCapture(e.pointerId); } catch (x) {} });
      card.addEventListener('pointermove', e => { if (!s) return; const z = zoom(); const dy = (e.clientY - s.y) / z, dx = (e.clientX - s.x) / z; const now = Date.now(); s.v = (e.clientY - s.ly) / z / Math.max(1, now - s.lt); s.ly = e.clientY; s.lt = now;
        if (!s.axis && (Math.abs(dy) > 8 || Math.abs(dx) > 8)) { s.axis = Math.abs(dy) > Math.abs(dx) ? 'y' : 'x'; if (s.axis === 'x') { track.style.scrollSnapType = 'none'; track.style.scrollBehavior = 'auto'; } else s.moved = true; }
        if (s.axis === 'x') { track.scrollLeft = s.sl - dx; return; }
        if (s.moved) { const y = dy < 0 ? dy : (1 - 1 / (dy * .55 / 40 + 1)) * 40; item.style.transform = `translateY(${y}px)`; item.style.opacity = String(Math.max(.15, 1 + Math.min(0, dy) / 520)); } });
      const up = e => { if (!s) return; const z = zoom(); const dy = (e.clientY - s.y) / z, v = s.v; const st = s; s = null; item.classList.remove('drag');
        if (st.axis === 'x') { track.style.scrollSnapType = ''; track.style.scrollBehavior = ''; return; }
        if (st.moved && (dy < -160 || v < -.9)) { item.style.transform = ''; item.style.opacity = ''; killItem(item, id); }
        else if (!st.moved) { restore(id); close(); System.openApp(id, card); }   /* a janela volta ao #apps e cresce a partir do cartão (mesma geometria) */
        else { item.style.transform = ''; item.style.opacity = ''; } };
      card.addEventListener('pointerup', up); card.addEventListener('pointercancel', up);
      track.appendChild(item);
      /* entrada: os cartões anteriores deslizam da esquerda com um pequeno desfasamento */
      if (opts.geo && i < ids.length - 1) { item.classList.add('slide'); item.style.transitionDelay = `${.04 * (ids.length - 1 - i)}s`; }
    });
    if (A) syncAll();
    el.classList.add('in'); el.style.visibility = 'visible'; UI.screen().classList.add('sw-on');   /* 1.5.0: a barra de estado fica branca por cima (glass27.css, tom automático) */
    /* a app atual (último cartão) fica centrada */
    track.scrollLeft = track.scrollWidth;
    if (opts.geo && opts.from) {
      const item = track.querySelector(`.sw-item[data-id="${cssEsc(opts.from)}"]`); const card = item && item.querySelector('.sw-card');
      if (card) {
        /* cartão nasce onde a app estava (translate/scale do gesto, origem no centro da janela) e assenta com mola */
        const cr = card.getBoundingClientRect(), sr = UI.screen().getBoundingClientRect(), z = zoom(); const ccx = (cr.left + cr.width / 2 - sr.left) / z, ccy = (cr.top + cr.height / 2 - sr.top) / z;
        /* SW = largura do ecrã (670 / 1340 nos dobráveis); o cartão é o ecrã à escala do cartão */
        const SW = System.SW || 440, cw = SW * cardK();
        const wx = SW / 2 + opts.geo.tx, wy = (A ? wh / 2 : 478) + opts.geo.ty; const sc = (SW * opts.geo.s) / cw;
        card.classList.add('hand'); card.style.transform = `translate(${(wx - ccx).toFixed(1)}px,${(wy - ccy).toFixed(1)}px) scale(${sc.toFixed(4)})`;
        item.querySelector('.sw-lbl').style.opacity = '0';
        requestAnimationFrame(() => requestAnimationFrame(() => { card.classList.remove('hand'); card.style.transform = ''; item.querySelector('.sw-lbl').style.opacity = ''; track.querySelectorAll('.sw-item.slide').forEach(x => x.classList.remove('slide')); }));
      }
    } else track.querySelectorAll('.sw-item.slide').forEach(x => x.classList.remove('slide'));
    Bridge.emit('overlay', 'switcher');
  }
  /* fechar: as janelas ficam nos cartões durante o fade (.4 s) e só depois voltam ao #apps (escondidas, .bg) */
  function close() { if (!el) return; closeMenu(); el.classList.remove('in'); { const s = UI.screen(); if (s) s.classList.remove('sw-on'); } clearTimeout(hideT); hideT = setTimeout(() => { if (!isOpen()) { restoreAll(); track.innerHTML = ''; el.classList.remove('hand'); } }, 400); }
  return { init, open, close, closeAll, toggle: () => isOpen() ? close() : open(), isOpen, isKept: id => keep.has(id) };
})();
