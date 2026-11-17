/* ===================== MAPAS - mapa real do GTA (tiles gtamap.xyz, mesma projeção do apex_carplay) =====================
   Mundo → pixels do tile: px = (0.02072·X + 117.3)·2^z ; py = (−0.0205·Y + 172.8)·2^z   (tiles 256 px, z 3…5)
   Zoom contínuo em "pixels por metro" (ppm); o nível da pirâmide e a escala CSS derivam dele.
   ================================================================================================================ */
/* ---------- ROTA e POSIÇÃO: vivem FORA da janela ----------
   O sistema mata a janela de uma app ao fim de 7 apps abertas (LRU, system.js) - e o switcher também.
   A rota estava só no closure da janela (`st.wp`): a partir daí nem o banner, nem a linha no mapa, nem
   nada voltavam, com o waypoint ainda marcado no jogo. Agora a rota é do MÓDULO:
     · Maps.setRoute({ x, y, name }) marca · Maps.endRoute() desmarca (e tira o waypoint do jogo);
     · a Dynamic Island acompanha-a no modo de navegação (Island.set('nav') / Island.clear('nav')),
       com "Terminar" e "Mapas" na ilha expandida - o render desse modo já existia e ninguém o usava;
     · a distância só se repinta quando o TEXTO muda, para a pílula não se reconstruir a cada coordenada. */
window.Maps = (() => {
  let pendingShow = null, route = null, lastQ = -1, redraw = null;
  const me = { x: 215.8, y: -810.1, heading: 0 };
  const paint = () => { if (!window.Island) return; if (route) Island.set('nav', { name: route.name, dist: route.dist, onEnd: () => api.endRoute(), onTap: () => System.openApp('maps') }); else Island.clear('nav'); };
  /* degraus IGUAIS aos do texto da ilha (distTxt, island.js): abaixo de 1 km o texto é em metros inteiros
     (Math.round), entre 1 e 10 km em décimas de km (100 m) e acima de 10 km em km inteiros (1000 m).
     Com um degrau de 10 m abaixo do quilómetro o número ficava congelado enquanto o jogador andava e
     depois saltava dez metros de uma vez. */
  function dist(force) {
    if (!route) return;
    const d = Math.hypot(route.x - me.x, route.y - me.y), step = d >= 10000 ? 1000 : d >= 1000 ? 100 : 1, q = Math.round(d / step) * step;
    if (!force && q === lastQ) return;
    lastQ = q; route.dist = d; paint();
  }
  const api = {
    showAt: p => { pendingShow = p; Bridge.emit('maps:show', p); },
    get pending() { const p = pendingShow; pendingShow = null; return p; },
    get me() { return me; },
    setMe(c) { if (c) { if (isFinite(+c.x)) me.x = +c.x; if (isFinite(+c.y)) me.y = +c.y; me.heading = +c.heading || 0; dist(); } return me; },
    get route() { return route; },
    /* a janela aberta (só pode haver uma) diz aqui como se repinta: uma referência direta em vez de mais
       um ouvinte do Bridge por cada abertura da app */
    bind(fn) { redraw = typeof fn === 'function' ? fn : null; const mine = redraw; return () => { if (redraw === mine) redraw = null; }; },
    setRoute(r) {
      route = (r && isFinite(+r.x) && isFinite(+r.y)) ? { x: +r.x, y: +r.y, name: String(r.name == null || r.name === '' ? 'Destino' : r.name).slice(0, 60), dist: null } : null;
      lastQ = -1; if (route) dist(true); else paint();
      if (redraw) { try { redraw(); } catch (e) { console.error('[apex_phone] maps redraw', e); } }
      Bridge.emit('maps:route', route);   /* hook público, como o 'maps:show' */
      return route;
    },
    endRoute() { Bridge.call('removeWaypoint'); return api.setRoute(null); },
    /* ---------- LOCAIS GUARDADOS ----------
       Viviam só na chave 'places' do Store, ou seja no localStorage do CEF: o jogador perdia-os ao mudar
       de computador ou ao repor o telemóvel, e a Fase 4 pede-os na conta. Passam a viajar nas definições
       da conta - o System.setState aceita chaves novas e o account.update grava o `settings` tal como
       vem (server/main.lua), por isso não é preciso mexer no núcleo. A chave local continua a ser
       escrita porque a Vera ainda a lê (shell/vera.js:76) - ver `pedidosCruzados`. */
    get places() { const l = window.System && System.state && System.state.places; return Array.isArray(l) ? l : (Store.get('places', []) || []); },
    setPlaces(list) {
      const l = (Array.isArray(list) ? list : []).filter(p => p && typeof p === 'object' && isFinite(+p.x) && isFinite(+p.y)).slice(0, 60)
        .map(p => ({ name: String(p.name == null || p.name === '' ? 'Local' : p.name).slice(0, 60), x: +p.x, y: +p.y,
          icon: /^[a-zA-Z0-9]{1,24}$/.test(String(p.icon || '')) ? String(p.icon) : 'pin',
          color: /^#[0-9a-f]{3,8}$/i.test(String(p.color || '')) ? String(p.color) : '#BF5AF2', saved: true }));
      System.setState({ places: l }, { noApply: true });
      Store.set('places', l);
      return l;
    },
    cfg: null, poi: null,
    /* ---------- MOTOR DO MAPA PARTILHADO (2026-09-21) ----------
       Tiles, projeção, pan/zoom e o ponto "eu" para qualquer app com mapa - a Encontrar usa-o. (A app Mapas em baixo
       ainda tem a sua cópia com a rota, a pesquisa e os locais; é a candidata a migrar para aqui.)
       Pinos: elementos `.map-pin` dentro de `pins` com data-x/data-y; `data-anchor="c"` centra-os (avatares), senão
       a ponta fica em baixo (alfinetes). Devolve { el, st, update, setPpm, centerOn, follow, pins, destroy }. */
    createView(opts = {}) {
      const cfg = Object.assign({ tileUrl: 'https://www.gtamap.xyz/mapStyles/styleSatelite/{z}/{x}/{y}.jpg', minZoom: 3, maxZoom: 5, tile: 256 }, api.cfg || {});
      const TILE = (z, x, y) => cfg.tileUrl.replace('{z}', z).replace('{x}', x).replace('{y}', y);
      const KX = 0.02072, KY = 0.0205, OX = 117.3, OY = 172.8, T = cfg.tile || 256;
      const proj = (x, y, z) => { const k = Math.pow(2, z); return [(KX * x + OX) * k, (-KY * y + OY) * k]; };
      const MIN_PPM = 0.075, MAX_PPM = 2.2;
      const level = ppm => { let z = cfg.maxZoom; while (z > cfg.minZoom && KX * Math.pow(2, z) > ppm * 1.6) z--; return { z, s: ppm / (KX * Math.pow(2, z)) }; };
      const st = { ppm: +opts.ppm || 0.55, z: -1, s: 1, free: false, cx: 0, cy: 0, me: me, tiles: new Map(), win: null, fails: 0, forceDark: null };
      /* opts.route: desenha a linha até ao destino de Maps.route (a app Mapas da Nova UI usa-a); sem ela é exatamente o mapa de sempre */
      const v = UI.el(`<div class="map tm ${opts.cls || ''}"><div class="tm-world">${opts.route ? '<svg class="tm-route"><path class="rt" fill="none" stroke="#3E7BFA" stroke-linecap="round" stroke-linejoin="round"/></svg>' : ''}<div class="tm-pins"></div><div class="map-me"></div></div><div class="tm-nofetch hidden">Sem ligação aos tiles do mapa</div></div>`);
      const world = v.querySelector('.tm-world'), pinsEl = v.querySelector('.tm-pins'), meEl = v.querySelector('.map-me');
      const rsvg = v.querySelector('.tm-route'), rpath = rsvg ? rsvg.querySelector('.rt') : null;
      const W = () => v.clientWidth || 440, H = () => v.clientHeight || 956;
      /* st.forceDark (setDark): o botão de camadas pode forçar o mapa claro ou escuro; null segue o tema do sistema */
      const applyDark = () => v.classList.toggle('dark', st.forceDark != null ? !!st.forceDark : !!(window.System && System.state.dark)); applyDark();
      function update() {
        const lv = level(st.ppm); const z = lv.z, s = lv.s; st.s = s;
        if (st.z !== z) { st.tiles.forEach(i => i.remove()); st.tiles.clear(); st.win = null; st.z = z; const size = T * Math.pow(2, z); world.style.width = size + 'px'; world.style.height = size + 'px'; if (rsvg) { rsvg.setAttribute('viewBox', `0 0 ${size} ${size}`); rsvg.setAttribute('width', size); rsvg.setAttribute('height', size); } }
        const ccx = st.free ? st.cx : st.me.x, ccy = st.free ? st.cy : st.me.y;
        const [px, py] = proj(ccx, ccy, z); const [mx, my] = proj(st.me.x, st.me.y, z);
        world.style.transform = `translate(${(W() / 2).toFixed(1)}px,${(H() / 2).toFixed(1)}px) scale(${s}) translate(${(-px).toFixed(1)}px,${(-py).toFixed(1)}px)`;
        meEl.style.left = mx + 'px'; meEl.style.top = my + 'px'; meEl.style.transform = `translate(-50%,-50%) scale(${(1 / s).toFixed(3)}) rotate(${-(st.me.heading || 0)}deg)`;
        const hw = W() / (2 * s), hh = H() / (2 * s);
        const x0 = Math.max(0, Math.floor((px - hw) / T) - 1), x1 = Math.floor((px + hw) / T) + 1, y0 = Math.max(0, Math.floor((py - hh) / T) - 1), y1 = Math.floor((py + hh) / T) + 1;
        const key = z + ':' + x0 + ',' + x1 + ',' + y0 + ',' + y1;
        if (st.win !== key) { st.win = key; const need = new Set(); const max = Math.pow(2, z);
          for (let tx = x0; tx <= x1 && tx < max; tx++) for (let ty = y0; ty <= y1 && ty < max; ty++) { const k = tx + '_' + ty; need.add(k); if (!st.tiles.has(k)) { const img = document.createElement('img'); img.decoding = 'async'; img.draggable = false; img.src = TILE(z, tx, ty); img.style.left = (tx * T) + 'px'; img.style.top = (ty * T) + 'px'; img.onerror = () => { img.style.display = 'none'; if (++st.fails > 6 && !st.tiles.size) v.querySelector('.tm-nofetch').classList.remove('hidden'); }; img.onload = () => { st.fails = 0; v.querySelector('.tm-nofetch').classList.add('hidden'); }; world.insertBefore(img, rsvg || pinsEl); st.tiles.set(k, img); } }
          if (st.tiles.size > need.size + 40) st.tiles.forEach((img, k) => { if (!need.has(k)) { img.remove(); st.tiles.delete(k); } }); }
        pinsEl.querySelectorAll('.map-pin').forEach(p => { const [qx, qy] = proj(+p.dataset.x, +p.dataset.y, z); p.style.left = qx + 'px'; p.style.top = qy + 'px'; p.style.transform = `${p.dataset.anchor === 'c' ? 'translate(-50%,-50%)' : 'translate(-50%,-100%)'} scale(${(1 / s).toFixed(3)})`; });
        /* rota: linha reta até ao waypoint (a rota real segue no GPS do jogo), como na app Mapas do PearOS */
        if (rpath) { const wp = route; if (wp) { const [bx, by] = proj(wp.x, wp.y, z); rpath.setAttribute('d', `M${mx.toFixed(1)} ${my.toFixed(1)} L${bx.toFixed(1)} ${by.toFixed(1)}`); rpath.setAttribute('stroke-width', (7 / s).toFixed(2)); rpath.setAttribute('stroke-dasharray', `${(14 / s).toFixed(1)} ${(10 / s).toFixed(1)}`); } else rpath.removeAttribute('d'); }
      }
      const setPpm = p => { st.ppm = Math.max(MIN_PPM, Math.min(MAX_PPM, p)); update(); };
      const centerOn = (x, y) => { st.free = true; st.cx = x; st.cy = y; if (opts.onFree) opts.onFree(true); update(); };
      const follow = () => { st.free = false; if (opts.onFree) opts.onFree(false); update(); };
      /* px do rato → px do próprio mapa (o aparelho e, no PearPhone Fold, o zoom do conteúdo da app: ui.js UI.zoom(el)), lido uma vez por arrasto */
      let drag = null; const scr = () => UI.vrect ? UI.zoom(v) || 1 : UI.zoom();
      v.addEventListener('pointerdown', e => { if (e.target.closest('.map-pin,.nomap')) return; drag = { x: e.clientX, y: e.clientY, cx: st.free ? st.cx : st.me.x, cy: st.free ? st.cy : st.me.y, moved: false, k: scr() }; try { v.setPointerCapture(e.pointerId); } catch (x) {} });
      v.addEventListener('pointermove', e => { if (!drag) return; const k = drag.k; const dx = (e.clientX - drag.x) / k, dy = (e.clientY - drag.y) / k; if (Math.hypot(dx, dy) > 4) drag.moved = true; if (!drag.moved) return; const kz = Math.pow(2, st.z);
        st.free = true; st.cx = drag.cx - dx / (st.s * KX * kz); st.cy = drag.cy + dy / (st.s * KY * kz); if (opts.onFree) opts.onFree(true); update(); });
      v.addEventListener('pointerup', () => { drag = null; }); v.addEventListener('pointercancel', () => { drag = null; });
      v.addEventListener('wheel', e => { e.preventDefault(); setPpm(st.ppm * Math.pow(1.15, -e.deltaY / 100)); }, { passive: false });
      const offTheme = Bridge.on('state', p => { if (p && p.theme !== undefined) applyDark(); });
      const setDark = d => { st.forceDark = d == null ? null : !!d; applyDark(); return v.classList.contains('dark'); };
      return { el: v, st, update, setPpm, centerOn, follow, setDark, isDark: () => v.classList.contains('dark'), pins: pinsEl, proj, moved: () => !!(drag && drag.moved), destroy: () => { offTheme(); st.tiles.forEach(i => i.remove()); st.tiles.clear(); } };
    },
  };
  return api;
})();

/* Ouvintes do MÓDULO (registados uma vez, não no mount de uma janela): é isso que os faz sobreviver ao LRU. */
Bridge.on('coords', c => Maps.setMe(c));
/* Guardar o telemóvel corta a thread do GPS (client/gps.lua: `while gpsActive and PhoneOpen`) e o push
   'close' só esconde o ecrã - a app continuava "aberta" com o mapa parado onde estava. Ao voltar a abrir:
   se os Mapas estão à frente, recomeça o GPS e repinta; se só há uma rota a decorrer, o GPS volta em modo
   lento (1,5 s), o suficiente para a distância na ilha. */
Bridge.on('phone:open', () => {
  const d = App.get('maps'), win = System.windows && System.windows.maps;
  if (win && System.currentApp() === 'maps' && d && typeof d.resume === 'function') { try { d.resume(win); } catch (e) { console.error('[apex_phone] maps resume', e); } return; }
  if (Maps.route) Bridge.call('startGPS', { slow: true });
});
/* troca de personagem: a rota era da anterior (a ilha limpa-se sozinha no session:changed) */
Bridge.on('session:changed', () => { if (Maps.route) Maps.endRoute(); });
/* A cache local ('places' no Store) é o que a Vera lê (shell/vera.js:76) e só era escrita quando o jogador
   guardava ou removia um local NESTA sessão do CEF: num computador novo os locais vinham da conta, apareciam
   nos Mapas e a Vera continuava sem os conhecer. Espelha-se no arranque (e em cada troca de personagem, que
   volta a emitir 'ready'). Ver `pedidosCruzados`: o certo é a Vera ler Maps.places. */
Bridge.on('ready', () => { const l = System.state && System.state.places; if (Array.isArray(l)) { try { Store.set('places', l); } catch (e) { console.error('[apex_phone] cache de places', e); } } });

const DEFAULT_POI = [
  { name: 'Legion Square', x: 195.2, y: -934.0, icon: 'pin', color: '#0A84FF' }, { name: 'Hospital Pillbox', x: 298.6, y: -584.4, icon: 'heart', color: '#FF453A' },
  { name: 'LSPD Mission Row', x: 428.4, y: -981.7, icon: 'lock', color: '#5E5CE6' }, { name: 'Fleeca Bank (Legion)', x: 149.9, y: -1040.4, icon: 'bank', color: '#30D158' },
  { name: 'Los Santos Customs', x: -337.4, y: -136.9, icon: 'car', color: '#FF9F0A' }, { name: "Benny's Garage", x: -205.6, y: -1310.3, icon: 'gear', color: '#FF9F0A' },
  { name: 'Diamond Casino', x: 925.3, y: 46.5, icon: 'sparkles', color: '#BF5AF2' }, { name: 'Del Perro Pier', x: -1850.1, y: -1231.8, icon: 'nav', color: '#00C7BE' },
  { name: 'Vespucci Beach', x: -1238.7, y: -1491.1, icon: 'sun', color: '#FFD60A' }, { name: 'Mirror Park', x: 1046.0, y: -740.5, icon: 'pin', color: '#30D158' },
  { name: 'Câmara Municipal', x: -544.6, y: -204.5, icon: 'home', color: '#0A84FF' }, { name: 'Aeroporto LSIA', x: -1037.7, y: -2737.8, icon: 'airplane', color: '#64D2FF' },
  { name: 'Elysian Docks', x: 129.5, y: -3072.5, icon: 'briefcase', color: '#8E8E93' }, { name: 'Sandy Shores', x: 1961.2, y: 3740.5, icon: 'sun', color: '#FFD60A' },
  { name: 'Paleto Bay', x: -275.5, y: 6228.4, icon: 'pin', color: '#BF5AF2' },
];

App.define('maps', {
  name: 'Mapas', core: true, category: 'Navegação', needs: ['location'],
  actions: [{ label: 'Partilhar localização', icon: 'nav', onTap: async () => { const c = await Contacts.pick('Enviar localização a'); const p = await Bridge.call('getCoords'); if (c && p) { await Bridge.rpc('messages.send', { to: c.number, type: 'location', content: 'Localização', payload: { x: p.x, y: p.y, label: 'A minha localização' } }); UI.toast('Localização enviada'); } } }],
  /* botão Voltar do sistema (Nova UI): fecha o local aberto ou a pesquisa antes de fechar a app; true = consumido */
  back(win) { return !!(win && win._back && win._back()); },
  open(win) {
    const g = UI.g;
    /* ===================== NOVA UI (Android) =====================
       O mesmo motor de mapa (Maps.createView, com a linha da rota), os mesmos locais, a mesma rota do módulo e o mesmo GPS;
       o desenho é o de uns mapas da Nova UI: pesquisa em pílula em cima, botões redondos a flutuar e uma folha em baixo com
       os locais, os resultados, o cartão do local e a navegação. */
    if (System.isAndroid && System.isAndroid()) {
      const places = () => [...(Maps.poi && Maps.poi.length ? Maps.poi : DEFAULT_POI), ...Maps.places];
      const pinSvg = c => `<svg viewBox="0 0 26 34"><path d="M13 0C5.8 0 0 5.8 0 13c0 9.6 13 21 13 21s13-11.4 13-21C26 5.8 20.2 0 13 0z" fill="${c}"/><circle cx="13" cy="13" r="5" fill="#fff"/></svg>`;
      const km = p => Math.hypot(p.x - Maps.me.x, p.y - Maps.me.y) / 1000;
      const distTxt = p => { const d = km(p); return d < 1 ? Math.round(d * 1000) + ' m' : d.toFixed(1).replace('.', ',') + ' km'; };
      const minTxt = p => Math.max(1, Math.round(km(p) * 1.6)) + ' min de carro';
      let mode = 'home', place = null, q = '', min = false;
      const root = UI.el(`<div class="amap"><div class="amap-mapw"></div>
        <div class="amap-top"><div class="amap-sb">${g('search', 20)}<input type="text" spellcheck="false" autocomplete="off" placeholder="Pesquisar aqui"><div class="amap-sx hidden">${g('x', 16)}</div></div></div>
        <div class="amap-side"><div class="amap-fb amap-lay">${g('layers', 22)}</div><div class="amap-fb amap-add">${g('bookmark', 22)}</div></div>
        <div class="amap-sheet"><div class="amap-float"><div class="amap-zoom"><div class="amap-z zi">${g('plus', 22)}</div><i></i><div class="amap-z zo">${g('minus', 22)}</div></div><div class="amap-fb amap-loc on">${g('nav', 22)}</div></div><div class="amap-grab"><i></i></div><div class="amap-sc"></div></div></div>`);
      const $ = s => root.querySelector(s);
      const map = Maps.createView({ ppm: 0.55, route: true, onFree: f => $('.amap-loc').classList.toggle('on', !f) });
      $('.amap-mapw').appendChild(map.el);
      const sc = $('.amap-sc'), sheet = $('.amap-sheet'), inp = $('.amap-sb input');
      const sbTheme = () => { App.get('maps').statusBar = map.isDark() ? 'dark' : 'light'; System.updateSbTheme(); root.classList.toggle('amap-dk', map.isDark()); };
      $('.amap-lay').onclick = () => { map.setDark(!map.isDark()); $('.amap-lay').classList.toggle('on', map.isDark() !== !!System.state.dark); sbTheme(); };
      const offTheme = Bridge.on('state', p => { if (p && p.theme !== undefined) { map.setDark(null); $('.amap-lay').classList.remove('on'); sbTheme(); } });
      $('.zi').onclick = () => map.setPpm(map.st.ppm * 1.4); $('.zo').onclick = () => map.setPpm(map.st.ppm / 1.4);
      $('.amap-loc').onclick = () => map.follow();
      $('.amap-grab').onclick = () => { min = !min; sheet.classList.toggle('min', min); setTimeout(fit, 0); };
      $('.amap-add').onclick = async () => { const n = await UI.prompt('Guardar local', 'Guarda o centro do mapa', 'Nome'); if (!n) return; const c = map.st.free ? { x: map.st.cx, y: map.st.cy } : { x: Maps.me.x, y: Maps.me.y }; Maps.setPlaces(Maps.places.concat([{ name: n, x: c.x, y: c.y, icon: 'pin', color: '#BF5AF2', saved: true }])); renderPins(); paint(); UI.toast('Local guardado'); };
      inp.oninput = () => { q = inp.value.trim().toLowerCase(); $('.amap-sx').classList.toggle('hidden', !q); if (q) { place = null; mode = 'results'; } else mode = 'home'; min = false; sheet.classList.remove('min'); paint(); };
      $('.amap-sx').onclick = () => { inp.value = ''; inp.oninput(); inp.focus(); };
      function renderPins() {
        map.pins.innerHTML = '';
        places().filter(p => p.saved || (Maps.cfg && Maps.cfg.showPOI)).forEach(p => { const pin = UI.el(`<div class="map-pin" data-x="${p.x}" data-y="${p.y}">${pinSvg(p.color || '#F2453D')}</div>`); pin.onclick = e => { e.stopPropagation(); showPlace(p); }; map.pins.appendChild(pin); });
        const wp = Maps.route; if (wp) map.pins.appendChild(UI.el(`<div class="map-pin" data-x="${wp.x}" data-y="${wp.y}">${pinSvg('#3E7BFA')}</div>`));
        map.update();
      }
      const row = p => { const r = UI.el(`<div class="amap-row"><div class="amap-ric"></div><div class="amap-rb"><b></b><span></span></div><em></em></div>`);
        const ic = r.querySelector('.amap-ric'); ic.style.background = p.color || 'var(--red)'; ic.innerHTML = g(p.icon || 'pin', 18);
        r.querySelector('b').textContent = p.name; r.querySelector('span').textContent = p.saved ? 'Local guardado' : 'Los Santos'; r.querySelector('em').textContent = distTxt(p);
        r.onclick = () => showPlace(p); return r; };
      const sec = t => UI.el(`<div class="amap-sec">${UI.esc(t)}</div>`);
      /* o centro do mapa (e o ponto "eu") fica na parte que se vê: o mapa acaba por baixo da folha, menos o raio dos cantos */
      const mapw = $('.amap-mapw');
      /* NOVA Fold8 aberto: a folha é um painel à esquerda (oneui-apps3.css) e o mapa vai até ao fundo, por baixo dele */
      const fit = () => { const b = UI.isSplit && UI.isSplit() ? 0 : Math.max(0, sheet.offsetHeight - 28); if (mapw._b !== b) { mapw._b = b; mapw.style.bottom = b + 'px'; map.update(); } };
      const offFold = Bridge.on('fold:state', () => { if (!win.isConnected) { offFold(); return; } setTimeout(fit, 0); });   /* sai com a janela (win.onClose) */
      function paint() {
        setTimeout(fit, 0);
        sc.innerHTML = ''; root.classList.toggle('placing', mode === 'place');
        if (mode === 'results') {
          const r = places().filter(p => p.name.toLowerCase().includes(q)).sort((a, b) => km(a) - km(b));
          sc.appendChild(sec(r.length ? (r.length === 1 ? '1 resultado' : r.length + ' resultados') : 'Sem resultados'));
          if (!r.length) { sc.appendChild(UI.el('<div class="amap-empty">Nenhum local com esse nome. Experimenta outra palavra.</div>')); return; }
          const card = UI.el('<div class="amap-list"></div>'); r.slice(0, 12).forEach(p => card.appendChild(row(p))); sc.appendChild(card); return;
        }
        if (mode === 'place' && place) {
          const p = place, saved = Maps.places.some(x => x.name === p.name && x.saved), going = !!(Maps.route && Math.abs(Maps.route.x - p.x) < .5 && Math.abs(Maps.route.y - p.y) < .5);
          const c = UI.el(`<div class="amap-place"><div class="amap-ph"><div class="amap-pic"></div><div class="amap-pt"><b></b><span></span></div><div class="amap-close">${g('x', 18)}</div></div><div class="amap-acts"></div></div>`);
          const pic = c.querySelector('.amap-pic'); pic.style.background = p.color || 'var(--red)'; pic.innerHTML = g(p.icon || 'pin', 22);
          c.querySelector('b').textContent = p.name; c.querySelector('.amap-pt span').textContent = `${distTxt(p)} · ${minTxt(p)}`;
          c.querySelector('.amap-close').onclick = () => { place = null; mode = q ? 'results' : 'home'; paint(); };
          const acts = c.querySelector('.amap-acts');
          const btn = (cls, icon, label, fn) => { const b = UI.el(`<div class="amap-btn ${cls}">${g(icon, 18)}<span></span></div>`); b.querySelector('span').textContent = label; b.onclick = fn; acts.appendChild(b); };
          if (going) btn('stop', 'x', 'Terminar', () => { Maps.endRoute(); paint(); });
          else btn('go', 'nav', 'Direções', () => { Maps.setRoute({ x: p.x, y: p.y, name: p.name }); Bridge.call('setWaypoint', { x: p.x, y: p.y, name: p.name }); map.follow(); UI.banner({ app: 'maps', title: 'Direções', msg: `A caminho de ${p.name}` }); place = null; mode = 'home'; paint(); });
          if (saved) btn('', 'trash', 'Remover', () => { Maps.setPlaces(Maps.places.filter(x => x.name !== p.name)); renderPins(); place = null; mode = 'home'; paint(); UI.toast('Local removido'); });
          else btn('', 'bookmark', 'Guardar', () => { Maps.setPlaces(Maps.places.concat([Object.assign({}, p, { saved: true, color: '#BF5AF2' })])); renderPins(); paint(); UI.toast('Guardado'); });
          btn('', 'share', 'Partilhar', async () => { const ct = await Contacts.pick('Enviar localização a'); if (ct) { await Bridge.rpc('messages.send', { to: ct.number, type: 'location', content: 'Localização', payload: { x: p.x, y: p.y, label: p.name } }); UI.toast('Localização enviada'); } });
          sc.appendChild(c); return;
        }
        /* início: navegação a decorrer (se houver), os locais guardados e os sítios da cidade por distância */
        const wp = Maps.route;
        if (wp) {
          const n = UI.el(`<div class="amap-nav"><div class="amap-nb">${g('nav', 26)}</div><div class="amap-nt"><em>A caminho de</em><b></b><span></span></div></div>`);
          n.querySelector('b').textContent = wp.name; n.querySelector('span').textContent = `${distTxt(wp)} · cerca de ${minTxt(wp)}`;
          const acts = UI.el('<div class="amap-acts"></div>');
          const end = UI.el(`<div class="amap-btn stop">${g('x', 18)}<span>Terminar</span></div>`); end.onclick = () => { Maps.endRoute(); paint(); };
          const see = UI.el(`<div class="amap-btn">${g('pin', 18)}<span>Ver destino</span></div>`); see.onclick = () => { map.centerOn(wp.x, wp.y); if (map.st.ppm < .45) map.setPpm(.6); };
          acts.append(end, see); n.appendChild(acts); sc.appendChild(n);
        }
        const mine = Maps.places.filter(p => p.saved);
        sc.appendChild(sec('Os teus locais'));
        if (mine.length) { const ch = UI.el('<div class="amap-chips"></div>'); mine.forEach(p => { const c = UI.el(`<div class="amap-chip">${g(p.icon || 'pin', 16)}<span></span></div>`); c.querySelector('span').textContent = p.name; c.onclick = () => showPlace(p); ch.appendChild(c); }); sc.appendChild(ch); }
        else sc.appendChild(UI.el('<div class="amap-empty sm">Ainda não guardaste locais. Usa o botão de marcador para guardar o centro do mapa.</div>'));
        sc.appendChild(sec('Na cidade'));
        const card = UI.el('<div class="amap-list"></div>'); (Maps.poi && Maps.poi.length ? Maps.poi : DEFAULT_POI).slice().sort((a, b) => km(a) - km(b)).slice(0, 8).forEach(p => card.appendChild(row(p))); sc.appendChild(card);
      }
      function showPlace(p) { place = p; mode = 'place'; min = false; sheet.classList.remove('min'); map.centerOn(p.x, p.y); if (map.st.ppm < 0.45) map.setPpm(0.6); paint(); }
      map.el.addEventListener('click', e => { if (map.moved() || e.target.closest('.map-pin')) return; if (mode === 'place') { place = null; mode = q ? 'results' : 'home'; paint(); } });
      if (!Array.isArray(System.state.places)) { const old = Store.get('places', []) || []; if (old.length) Maps.setPlaces(old); }
      win.querySelector('.nav-stack').appendChild(root);
      sbTheme(); renderPins(); paint();
      Bridge.call('getCoords').then(c => { Maps.setMe(c); map.update(); if (mode !== 'place') paint(); }); Bridge.call('startGPS');
      /* com a navegação a decorrer, a distância do cartão acompanha o GPS (só o texto, e só quando muda) */
      const off = Bridge.on('coords', () => { if (System.currentApp() !== 'maps') return; map.update();
        const wp = Maps.route, s = wp && mode === 'home' ? sc.querySelector('.amap-nt span') : null; if (s) { const t = `${distTxt(wp)} · cerca de ${minTxt(wp)}`; if (s.textContent !== t) s.textContent = t; } });
      const off2 = Bridge.on('maps:show', p => { if (!p) return; showPlace({ name: p.label || 'Localização partilhada', x: +p.x, y: +p.y, icon: 'nav', color: '#3E7BFA' }); });
      const unbind = Maps.bind(() => { renderPins(); if (mode !== 'place') paint(); });
      const pend = Maps.pending; if (pend) setTimeout(() => Bridge.emit('maps:show', pend), 120);
      const gpsIdle = () => { if (Maps.route) Bridge.call('startGPS', { slow: true }); else Bridge.call('stopGPS'); };
      win._back = () => { if (mode === 'place') { place = null; mode = q ? 'results' : 'home'; paint(); return true; } if (q) { inp.value = ''; inp.oninput(); return true; } return false; };
      win.onClose = () => { off(); off2(); offFold(); unbind(); offTheme(); map.destroy(); gpsIdle(); const d = App.get('maps'); if (d) { delete d.pause; delete d.resume; } };
      App.get('maps').pause = () => gpsIdle(); App.get('maps').resume = () => { Bridge.call('startGPS'); map.update(); if (mode !== 'place') paint(); };
      return;
    }
    const cfg = Object.assign({ tileUrl: 'https://www.gtamap.xyz/mapStyles/styleSatelite/{z}/{x}/{y}.jpg', minZoom: 3, maxZoom: 5, tile: 256 }, Maps.cfg || {});
    const TILE = (z, x, y) => cfg.tileUrl.replace('{z}', z).replace('{x}', x).replace('{y}', y);
    const KX = 0.02072, KY = 0.0205, OX = 117.3, OY = 172.8, T = cfg.tile || 256;
    const proj = (x, y, z) => { const k = Math.pow(2, z); return [(KX * x + OX) * k, (-KY * y + OY) * k]; };
    const unproj = (px, py, z) => { const k = Math.pow(2, z); return { x: (px / k - OX) / KX, y: (OY - py / k) / KY }; };
    const MIN_PPM = 0.075, MAX_PPM = 2.2;
    const level = ppm => { let z = cfg.maxZoom; while (z > cfg.minZoom && KX * Math.pow(2, z) > ppm * 1.6) z--; return { z, s: ppm / (KX * Math.pow(2, z)) }; };

    /* `me` é o objeto do módulo (partilhado com o ouvinte global de 'coords') e a rota é Maps.route:
       nenhum dos dois pode viver no closure da janela - o LRU mata-a (ver o cabeçalho do ficheiro) */
    const st = { ppm: 0.55, z: -1, s: 1, free: false, cx: 0, cy: 0, me: Maps.me, tiles: new Map(), win: null, dark: false, last: null, fails: 0 };
    const v = UI.el(`<div class="map tm"><div class="tm-world"><svg class="tm-route"><path class="rt" fill="none" stroke="#0A84FF" stroke-linecap="round" stroke-linejoin="round"/></svg><div class="tm-pins"></div><div class="map-me"></div></div>
      <div class="tm-nofetch hidden">Sem ligação aos tiles do mapa</div>
      <div class="map-top"><div class="loc on">${g('nav')}</div><div class="zi">${g('plus')}</div><div class="zo">${g('minus')}</div><div class="lay">${g('layers')}</div><div class="add">${g('pin')}</div></div><div class="map-search"></div></div>`);
    const world = v.querySelector('.tm-world'), svg = v.querySelector('.tm-route'), route = v.querySelector('.rt'), pinsEl = v.querySelector('.tm-pins'), meEl = v.querySelector('.map-me'), card = v.querySelector('.map-search');
    /* PearPhone Fold: os botões do mapa vão para a barra direita (localizar e camadas numa pílula, aproximar e afastar noutra, guardar
       o local em baixo); os de cima do mapa ficam escondidos (apps.css) e cada círculo toca no seu. Só se refaz quando muda o estado */
    const railM = () => { if (!UI.railFor) return; const sig = (st.free ? 1 : 0) + '|' + (st.dark ? 1 : 0); if (railM.sig === sig) return; railM.sig = sig;
      const tap = s => () => { const b = v.querySelector('.map-top ' + s); if (b) b.click(); };
      UI.railFor(win, { groups: [[{ id: 'loc', icon: 'nav', label: 'A minha localização', active: !st.free, onTap: tap('.loc') }, { id: 'lay', icon: 'layers', label: 'Mapa escuro', active: !!st.dark, onTap: tap('.lay') }],
        [{ id: 'zi', icon: 'plus', label: 'Aproximar', onTap: tap('.zi') }, { id: 'zo', icon: 'minus', label: 'Afastar', onTap: tap('.zo') }]],
        primary: [[{ id: 'add', icon: 'pin', label: 'Guardar local', onTap: tap('.add') }]] }, false); };
    /* o mapa segue o tema do sistema (escuro no modo escuro, como o PearOS); o botão de camadas força o contrário */
    const applyDark = () => { v.classList.toggle('dark', st.dark); v.querySelector('.lay').classList.toggle('on', st.dark); App.get('maps').statusBar = st.dark ? 'dark' : 'light'; System.updateSbTheme(); railM(); };
    st.dark = !!System.state.dark; applyDark();
    const W = () => v.clientWidth || 440, H = () => v.clientHeight || 956;
    /* px do rato → px do próprio mapa (o aparelho e, no PearPhone Fold, o zoom do conteúdo da app), em cache (ui.js UI.zoom(el)) */
    const scr = () => UI.vrect ? UI.zoom(v) || 1 : UI.zoom();

    /* ---------- render ---------- */
    function update() {
      const lv = level(st.ppm); const z = lv.z, s = lv.s; st.s = s;
      if (st.z !== z) { st.tiles.forEach(i => i.remove()); st.tiles.clear(); st.win = null; st.z = z; const size = T * Math.pow(2, z); world.style.width = size + 'px'; world.style.height = size + 'px'; svg.setAttribute('viewBox', `0 0 ${size} ${size}`); svg.setAttribute('width', size); svg.setAttribute('height', size); }
      const ccx = st.free ? st.cx : st.me.x, ccy = st.free ? st.cy : st.me.y;
      const [px, py] = proj(ccx, ccy, z); const [mx, my] = proj(st.me.x, st.me.y, z);
      st.last = { px, py, z, s };
      world.style.transform = `translate(${(W() / 2).toFixed(1)}px,${(H() / 2).toFixed(1)}px) scale(${s}) translate(${(-px).toFixed(1)}px,${(-py).toFixed(1)}px)`;
      meEl.style.left = mx + 'px'; meEl.style.top = my + 'px'; meEl.style.transform = `translate(-50%,-50%) scale(${(1 / s).toFixed(3)}) rotate(${-(st.me.heading || 0)}deg)`;
      /* tiles visíveis (só recalcula quando a janela muda) */
      const hw = W() / (2 * s), hh = H() / (2 * s);
      const x0 = Math.max(0, Math.floor((px - hw) / T) - 1), x1 = Math.floor((px + hw) / T) + 1, y0 = Math.max(0, Math.floor((py - hh) / T) - 1), y1 = Math.floor((py + hh) / T) + 1;
      const key = z + ':' + x0 + ',' + x1 + ',' + y0 + ',' + y1;
      if (st.win !== key) { st.win = key; const need = new Set(); const max = Math.pow(2, z);
        for (let tx = x0; tx <= x1 && tx < max; tx++) for (let ty = y0; ty <= y1 && ty < max; ty++) { const k = tx + '_' + ty; need.add(k); if (!st.tiles.has(k)) { const img = document.createElement('img'); img.decoding = 'async'; img.draggable = false; img.src = TILE(z, tx, ty); img.style.left = (tx * T) + 'px'; img.style.top = (ty * T) + 'px'; img.onerror = () => { img.style.display = 'none'; if (++st.fails > 6 && !st.tiles.size) v.querySelector('.tm-nofetch').classList.remove('hidden'); }; img.onload = () => { st.fails = 0; v.querySelector('.tm-nofetch').classList.add('hidden'); }; world.insertBefore(img, svg); st.tiles.set(k, img); } }
        if (st.tiles.size > need.size + 40) st.tiles.forEach((img, k) => { if (!need.has(k)) { img.remove(); st.tiles.delete(k); } }); }
      /* pins */
      pinsEl.querySelectorAll('.map-pin').forEach(p => { const [qx, qy] = proj(+p.dataset.x, +p.dataset.y, z); p.style.left = qx + 'px'; p.style.top = qy + 'px'; p.style.transform = `translate(-50%,-100%) scale(${(1 / s).toFixed(3)})`; });
      /* rota (linha reta até ao waypoint; a rota real segue na GPS do jogo) */
      const wp = Maps.route;
      if (wp) { const [ax, ay] = [mx, my], [bx, by] = proj(wp.x, wp.y, z); route.setAttribute('d', `M${ax.toFixed(1)} ${ay.toFixed(1)} L${bx.toFixed(1)} ${by.toFixed(1)}`); route.setAttribute('stroke-width', (7 / s).toFixed(2)); route.setAttribute('stroke-dasharray', `${(14 / s).toFixed(1)} ${(10 / s).toFixed(1)}`); } else route.removeAttribute('d');
    }
    const setPpm = p => { st.ppm = Math.max(MIN_PPM, Math.min(MAX_PPM, p)); update(); };
    const centerOn = (x, y) => { st.free = true; st.cx = x; st.cy = y; v.querySelector('.loc').classList.remove('on'); update(); railM(); };
    const follow = () => { st.free = false; v.querySelector('.loc').classList.add('on'); update(); railM(); };

    /* ---------- pan / zoom ---------- */
    let drag = null;
    v.addEventListener('pointerdown', e => { if (e.target.closest('.map-search,.map-top,.map-pin')) return; drag = { x: e.clientX, y: e.clientY, cx: st.free ? st.cx : st.me.x, cy: st.free ? st.cy : st.me.y, moved: false }; v.setPointerCapture(e.pointerId); });
    v.addEventListener('pointermove', e => { if (!drag) return; const k = scr(); const dx = (e.clientX - drag.x) / k, dy = (e.clientY - drag.y) / k; if (Math.hypot(dx, dy) > 4) drag.moved = true; if (!drag.moved) return; const kz = Math.pow(2, st.z);
      st.free = true; st.cx = drag.cx - dx / (st.s * KX * kz); st.cy = drag.cy + dy / (st.s * KY * kz); v.querySelector('.loc').classList.remove('on'); update(); railM(); });
    v.addEventListener('pointerup', () => { drag = null; }); v.addEventListener('pointercancel', () => { drag = null; });
    v.addEventListener('wheel', e => { e.preventDefault(); setPpm(st.ppm * Math.pow(1.15, -e.deltaY / 100)); }, { passive: false });
    v.querySelector('.zi').onclick = () => setPpm(st.ppm * 1.4); v.querySelector('.zo').onclick = () => setPpm(st.ppm / 1.4);
    v.querySelector('.loc').onclick = follow;
    v.querySelector('.lay').onclick = () => { st.dark = !st.dark; applyDark(); };
    const offTheme = Bridge.on('state', p => { if (p && p.theme !== undefined) { st.dark = !!System.state.dark; applyDark(); } });
    v.querySelector('.add').onclick = async () => { const n = await UI.prompt('Guardar local', 'Guarda o centro do mapa', 'Nome'); if (!n) return; const c = st.free ? { x: st.cx, y: st.cy } : { x: st.me.x, y: st.me.y }; Maps.setPlaces(Maps.places.concat([{ name: n, x: c.x, y: c.y, icon: 'pin', color: '#BF5AF2', saved: true }])); renderPins(); UI.toast('Local guardado'); };

    /* ---------- POIs / locais / waypoint ---------- */
    const places = () => [...(Maps.poi && Maps.poi.length ? Maps.poi : DEFAULT_POI), ...Maps.places];
    const pinSvg = c => `<svg viewBox="0 0 26 34"><path d="M13 0C5.8 0 0 5.8 0 13c0 9.6 13 21 13 21s13-11.4 13-21C26 5.8 20.2 0 13 0z" fill="${c}"/><circle cx="13" cy="13" r="5" fill="#fff"/></svg>`;
    /* no mapa só aparecem os locais guardados pelo jogador e o waypoint; os POIs ficam na pesquisa/lista (Config.Map.showPOI = true para os mostrar) */
    function renderPins() { pinsEl.innerHTML = ''; places().filter(p => p.saved || (Maps.cfg && Maps.cfg.showPOI)).forEach(p => { const pin = UI.el(`<div class="map-pin" data-x="${p.x}" data-y="${p.y}">${pinSvg(p.color || '#FF3B30')}</div>`); pin.onclick = e => { e.stopPropagation(); showCard(p); }; pinsEl.appendChild(pin); }); const wp = Maps.route; if (wp) pinsEl.appendChild(UI.el(`<div class="map-pin" data-x="${wp.x}" data-y="${wp.y}">${pinSvg('#0A84FF')}</div>`)); update(); }
    const search = UI.search('Pesquisar em Mapas', q => { card.innerHTML = ''; card.appendChild(search); if (!q) return; const r = places().filter(p => p.name.toLowerCase().includes(q)); if (r.length) card.appendChild(UI.list([{ items: r.slice(0, 5).map(p => ({ icon: p.icon || 'pin', iconBg: p.color || 'var(--red)', label: p.name, sub: `${(Math.hypot(p.x - st.me.x, p.y - st.me.y) / 1000).toFixed(1)} km`, chevron: false, onTap: () => { search.input.value = ''; showCard(p); } })) }])); });
    function showCard(p) {
      card.innerHTML = ''; card.appendChild(search); centerOn(p.x, p.y); if (st.ppm < 0.45) setPpm(0.6);
      const d = Math.hypot(p.x - st.me.x, p.y - st.me.y) / 1000;
      const c = UI.el(`<div class="map-card"><div class="li-icon" style="background:${p.color || 'var(--red)'}">${g(p.icon || 'pin')}</div><div style="min-width:0"><b>${UI.esc(p.name)}</b><div class="muted small">${d.toFixed(1)} km · ${Math.max(1, Math.round(d * 1.6))} min de carro</div></div><div class="pill-btn on go">Direções</div><div class="pill-btn gray more">${g('more')}</div></div>`);
      /* a rota vai para o módulo (Maps.setRoute): marca o waypoint no jogo, liga o modo de navegação da
         Dynamic Island e emite 'maps:route' - é o evento que volta a desenhar os pinos e a linha */
      c.querySelector('.go').onclick = () => { Maps.setRoute({ x: p.x, y: p.y, name: p.name }); Bridge.call('setWaypoint', { x: p.x, y: p.y, name: p.name }); follow(); UI.banner({ app: 'maps', title: 'Direções', msg: `A caminho de ${p.name}` }); };
      c.querySelector('.more').onclick = async () => { const a = await UI.actionSheet({ title: p.name, buttons: [{ label: 'Partilhar localização', icon: 'share', value: 'share' }, p.saved ? { label: 'Remover local guardado', icon: 'trash', danger: true, value: 'del' } : { label: 'Guardar local', icon: 'bookmark', value: 'save' }, { label: 'Remover waypoint', icon: 'x', value: 'wp' }] });
        if (a === 'share') { const ct = await Contacts.pick('Enviar localização a'); if (ct) { await Bridge.rpc('messages.send', { to: ct.number, type: 'location', content: 'Localização', payload: { x: p.x, y: p.y, label: p.name } }); UI.toast('Localização enviada'); } }
        else if (a === 'save') { Maps.setPlaces(Maps.places.concat([Object.assign({}, p, { saved: true, color: '#BF5AF2' })])); renderPins(); UI.toast('Guardado'); }
        else if (a === 'del') { Maps.setPlaces(Maps.places.filter(x => x.name !== p.name)); renderPins(); card.innerHTML = ''; card.appendChild(search); }
        else if (a === 'wp') Maps.endRoute(); };
      card.appendChild(c);
    }
    card.appendChild(search);
    v.addEventListener('click', e => { if (e.target === v || e.target.closest('.tm-world') && !e.target.closest('.map-pin')) { if (drag && drag.moved) return; const extra = card.querySelector('.map-card,.list'); if (extra && !e.target.closest('.map-search')) { card.innerHTML = ''; card.appendChild(search); } } });

    /* locais guardados por uma versão anterior (só no localStorage): sobem para a conta na 1.ª abertura */
    if (!Array.isArray(System.state.places)) { const old = Store.get('places', []) || []; if (old.length) Maps.setPlaces(old); }

    /* ---------- GPS ---------- */
    /* o ouvinte GLOBAL de 'coords' (topo do ficheiro) é que escreve em Maps.me; aqui só se repinta */
    win.querySelector('.nav-stack').appendChild(v);
    renderPins(); Bridge.call('getCoords').then(c => { Maps.setMe(c); update(); }); Bridge.call('startGPS');
    /* ⚠️ o win.onClose só corre quando a janela é MORTA (system.js:378 killApp) - fechar a app apenas a
       esconde e guarda-a no LRU, com este ouvinte vivo. Como agora o GPS NÃO pára quando há uma rota,
       sem esta guarda o mapa escondido refazia tiles, pinos e a linha a cada 1,5 s para ninguém ver.
       Ao reabrir, o resume() chama update() e o mapa apanha o atraso todo de uma vez. */
    const off = Bridge.on('coords', () => { if (System.currentApp() === 'maps') update(); });
    const off2 = Bridge.on('maps:show', p => { if (!p) return; showCard({ name: p.label || 'Localização partilhada', x: +p.x, y: +p.y, icon: 'nav', color: '#0A84FF' }); });
    /* a rota pode ser terminada de FORA da janela (botão "Terminar" da Dynamic Island) */
    const unbind = Maps.bind(() => renderPins());
    const pend = Maps.pending; if (pend) setTimeout(() => Bridge.emit('maps:show', pend), 120);
    /* com uma rota a decorrer o GPS não pára: é dele que vem a distância na ilha. Fica em modo lento
       (1,5 s em vez de 400 ms) - a app fechada não tem mapa para redesenhar. */
    const gpsIdle = () => { if (Maps.route) Bridge.call('startGPS', { slow: true }); else Bridge.call('stopGPS'); };
    /* ⚠️ o `pause`/`resume` ficam pendurados na DEFINIÇÃO da app (que vive para sempre) mas fecham sobre o
       closure DESTA janela - o `st.tiles` é um Map com dezenas de <img>. Quando o LRU das 7 janelas a mata,
       o win.onClose corre e nada os largava: o closure inteiro ficava vivo até alguém reabrir os Mapas (e o
       _perf não o via, porque conta nós do documento, não retidos). Largá-los AQUI é seguro e não parte o
       caminho normal: o onClose só corre no killApp (system.js) e, a partir daí, a próxima abertura já não
       encontra janela - chama o open() outra vez, que volta a pô-los. Quem os usa (system.js 338/361/384 e o
       'phone:open' no topo deste ficheiro) testa sempre se existem. */
    win.onClose = () => { off(); off2(); unbind(); offTheme(); gpsIdle(); const d = App.get('maps'); if (d) { delete d.pause; delete d.resume; } };
    App.get('maps').pause = () => gpsIdle(); App.get('maps').resume = () => { Bridge.call('startGPS'); update(); };
  }
});

/* ===================== ENCONTRAR (Find My) - 2026-09-21, desenho do PearOS 26 =====================
   Como no PearPhone: mapa a toda a altura, folha em baixo com a barra de separadores flutuante (Pessoas · Dispositivos · Eu),
   avatares como pinos com cauda, detalhe da pessoa com os três botões (Mensagem · Ligar · Direções). Partilho a minha
   localização com quem eu escolher, vejo no mapa quem partilha comigo, peço a localização a alguém e respondo a pedidos.
   A posição vem do servidor (server/findmy.lua lê o ped no momento do pedido; nada fica guardado) - quem está offline ou em
   pausa aparece "Localização não encontrada". Repinta de 4 em 4 s à frente e sempre que chega `findmy:changed`. */
/* statusBar 'auto': a barra de estado (e a hora e o anel da barra direita do PearPhone Fold) seguem o mapa, que segue o tema
   (escuro no tema escuro); 'light' deixava-os pretos em cima do mapa escuro */
App.define('findmy', {
  name: 'Encontrar', category: 'Utilitários', needs: ['location', 'contacts'], statusBar: 'auto',
  /* botão Voltar do sistema (Nova UI): sai do detalhe de uma pessoa ou aparelho antes de fechar a app; true = consumido */
  back(win) { return !!(win && win._back && win._back()); },
  description: 'Vê onde estão a família e os amigos que partilham a localização contigo, e partilha a tua.',
  actions: [{ label: 'Partilhar a minha localização', icon: 'nav', onTap: () => { System.openApp('findmy'); setTimeout(() => Bridge.emit('findmy:add', 'share'), 350); } }],
  open(win) {
    const g = UI.g; let data = { people: [], sharing: [], requests: [], requested: [], paused: false }, timer = null, sel = null, tab = 0, err = false, det = null;
    /* NOVA UI (Android): os mesmos dados (findmy.*), as mesmas ações e o mesmo mapa; só o desenho muda (folha com separadores
       segmentados, linhas Nova UI, botões redondos com etiqueta, pinos com anel). A = Android; os seletores vêm de K. */
    const A = !!(System.isAndroid && System.isAndroid());
    const K = A ? { loc: '.afind-loc', zi: '.afind-zi', zo: '.afind-zo', tabs: '.afind-tab', body: '.afind-body', head: '.afind-head', mapw: '.afind-mapw' }
      : { loc: '.fm-top .loc', zi: '.fm-top .zi', zo: '.fm-top .zo', tabs: '.fm-tabs .tab', body: '.fm-body', head: '.fm-head', mapw: '.fm-mapwrap' };
    let mapFree = false;   /* o mapa largou o "eu" (arrastado): o localizar da barra direita apaga-se */
    const map = Maps.createView({ ppm: 0.35, onFree: free => { mapFree = !!free; root.querySelector(K.loc).classList.toggle('on', !free); railF(); } });
    const root = A ? UI.el(`<div class="afind"><div class="afind-mapw"></div><div class="afind-top nomap"><div class="afind-fb afind-add">${g('plus', 22)}</div></div>
      <div class="afind-sheet nomap"><div class="afind-float"><div class="afind-zoom"><div class="afind-z afind-zi">${g('plus', 22)}</div><i></i><div class="afind-z afind-zo">${g('minus', 22)}</div></div><div class="afind-fb afind-loc on">${g('nav', 22)}</div></div>
      <div class="afind-grab"><i></i></div><div class="afind-seg"><div class="afind-tab on" data-i="0">Pessoas</div><div class="afind-tab" data-i="1">Dispositivos</div><div class="afind-tab" data-i="2">Eu</div></div><div class="afind-head"></div><div class="afind-body"></div></div></div>`)
      : UI.el(`<div class="fm"><div class="fm-mapwrap"></div><div class="fm-top nomap"><div class="loc on">${g('nav')}</div><div class="zi">${g('plus')}</div><div class="zo">${g('minus')}</div></div>
      <div class="fm-sheet nomap"><div class="grabber"></div><div class="fm-head"></div><div class="fm-body"></div>
      <div class="tabbar fm-tabs"><div class="tb-pill"><div class="tab on" data-i="0">${g('people')}<span>Pessoas</span></div><div class="tab" data-i="1">${g('phone')}<span>Dispositivos</span></div><div class="tab" data-i="2">${g('personCircle')}<span>Eu</span></div></div></div></div></div>`);
    root.querySelector(K.mapw).appendChild(map.el);
    const body = root.querySelector(K.body), head = root.querySelector(K.head);
    const setTab = i => { tab = i; det = null; sel = null; root.querySelectorAll(K.tabs).forEach((s, k) => s.classList.toggle('on', k === i)); if (i !== 0) map.follow(); paint(); };
    root.querySelectorAll(K.tabs).forEach(s => s.onclick = () => { Sound.play('click'); setTab(+s.dataset.i); });
    root.querySelector(K.loc).onclick = () => { map.follow(); };
    root.querySelector(K.zi).onclick = () => map.setPpm(map.st.ppm * 1.4); root.querySelector(K.zo).onclick = () => map.setPpm(map.st.ppm / 1.4);
    /* Nova UI: o mapa acaba por baixo da folha (menos o raio dos cantos), para o centro e o ponto "eu" ficarem à vista */
    const fitA = () => { if (!A) return; const sh = root.querySelector('.afind-sheet'), mw = root.querySelector('.afind-mapw'); const b = UI.isSplit && UI.isSplit() ? 0 : Math.max(0, sh.offsetHeight - 28); if (mw._b !== b) { mw._b = b; mw.style.bottom = b + 'px'; map.update(); } };
    let offFold = null;
    if (A) offFold = Bridge.on('fold:state', () => { if (!win.isConnected) { offFold(); offFold = null; return; } setTimeout(fitA, 0); });   /* sai com a janela (win.onClose) */
    /* PearPhone Fold: na barra direita o voltar (detalhe), o mapa (localizar; aproximar e afastar), os separadores (Pessoas,
       Dispositivos, Eu) numa pílula vertical e o "Adicionar" em baixo; a pílula da folha, os botões de cima do mapa e os da cabeça
       da folha escondem-se (apps.css). Só se refaz quando muda o que se vê */
    const railF = () => { if (A || !UI.railFor) return; const sig = [tab, det ? det.kind : '', mapFree ? 1 : 0].join('|'); if (railF.sig === sig) return; railF.sig = sig;
      const tap = s => () => { const b = root.querySelector(s); if (b) b.click(); };
      UI.railFor(win, { back: det ? { onTap: () => back(), label: 'Voltar' } : null,
        groups: [[{ id: 'loc', icon: 'nav', label: 'A minha localização', active: !mapFree, onTap: tap('.fm-top .loc') }], [{ id: 'zi', icon: 'plus', label: 'Aproximar', onTap: tap('.fm-top .zi') }, { id: 'zo', icon: 'minus', label: 'Afastar', onTap: tap('.fm-top .zo') }]],
        tabs: det ? [] : [['people', 'Pessoas'], ['phone', 'Dispositivos'], ['personCircle', 'Eu']].map(([ic, lb], i) => ({ id: 't' + i, icon: ic, label: lb, active: tab === i, onTap: () => { Sound.play('click'); setTab(i); } })),
        primary: !det && tab === 0 ? [[{ id: 'add', icon: 'personPlus', label: 'Adicionar', onTap: () => add() }]] : [] }, false); };
    if (A) { root.querySelector('.afind-add').onclick = () => add(); root.querySelector('.afind-grab').onclick = () => { root.querySelector('.afind-sheet').classList.toggle('min'); setTimeout(fitA, 0); }; }

    /* ---------- dados ---------- */
    const contact = n => (window.Contacts && Contacts.byNumber && Contacts.byNumber(n)) || null;
    const nameOf = p => (contact(p.number) || {}).name || p.name || UI.phone(p.number) || p.number || (A ? '?' : '--');
    const avatarOf = (p, cls) => UI.avatar({ name: nameOf(p), avatar: (contact(p.number) || {}).avatar || nameOf(p).length }, cls);
    const paintAv = (el, p) => { try { const c = contact(p.number); if (c && Contacts.paintAvatar) Contacts.paintAvatar(el.querySelector('.avatar'), c).catch(() => {}); } catch (e) {} };
    const has = p => isFinite(+p.x) && isFinite(+p.y);
    const distTxt = p => { const d = Math.hypot(p.x - Maps.me.x, p.y - Maps.me.y); return d < 1000 ? Math.round(d) + ' m' : (d / 1000).toFixed(1).replace('.', ',') + ' km'; };
    const status = p => has(p) ? `Los Santos · ${distTxt(p)}` : p.paused ? 'Não partilha a localização' : 'Localização não encontrada';
    const when = p => has(p) ? 'agora' : '';
    const load = async () => { const r = await Bridge.rpcRaw('findmy.list'); if (!r || r.error) { err = true; return; } err = false; data = r; data.people = data.people || []; data.sharing = data.sharing || []; data.requests = data.requests || []; data.requested = data.requested || []; if (r.me && isFinite(+r.me.x)) Maps.setMe({ x: r.me.x, y: r.me.y, heading: Maps.me.heading }); if (det && det.kind === 'person') { const p = data.people.find(x => x.number === det.number) || data.sharing.find(x => x.number === det.number); if (p) det.p = Object.assign({}, det.p, p); } };
    const refresh = async () => { await load(); paint(); };
    const ERR = { target: 'Esse número não existe.', self: 'És tu.', limit: 'Já partilhas com demasiadas pessoas.', already: 'Essa pessoa já partilha a localização contigo.', invalid: 'Esse pedido já não existe.' };
    const fail = r => { Sound.play('error'); UI.alert({ title: 'Não foi possível', msg: (r && ERR[r.error]) || 'Tenta novamente.' }); };

    /* ---------- ações ---------- */
    async function shareWith(number, on) { const r = await Bridge.rpcRaw('findmy.share', { number, on }); if (!r || !r.ok) { fail(r); return false; } Sound.play(on ? 'success' : 'click'); UI.toast(on ? 'A partilhar a tua localização' : 'Deixaste de partilhar'); await refresh(); return true; }
    async function requestFrom(number) { const r = await Bridge.rpcRaw('findmy.request', { number }); if (!r || !r.ok) { fail(r); return; } Sound.play('success'); UI.toast('Pedido enviado'); refresh(); }
    async function respond(number, accept) { const r = await Bridge.rpcRaw('findmy.respond', { number, accept }); if (!r || !r.ok) { fail(r); refresh(); return; } Sound.play(accept ? 'success' : 'click'); UI.toast(accept ? 'A partilhar a tua localização' : 'Pedido recusado'); refresh(); }
    async function pause(on) { const r = await Bridge.rpcRaw('findmy.pause', { on }); if (!r || !r.ok) { fail(r); refresh(); return; } data.paused = on; UI.toast(on ? 'Partilha em pausa: ninguém te vê' : 'Partilha retomada'); paint(); }
    const route = p => { if (!has(p)) { UI.toast('Sem localização para as direções'); return; } const name = nameOf(p); Maps.setRoute({ x: p.x, y: p.y, name }); Bridge.call('setWaypoint', { x: p.x, y: p.y, name }); UI.banner({ app: 'findmy', title: 'Direções', msg: `A caminho de ${name}` }); };
    async function add(kind) {
      const k = kind || await UI.actionSheet({ title: App.name('findmy'), buttons: [{ label: 'Partilhar a minha localização com…', icon: 'nav', value: 'share' }, { label: 'Pedir a localização a…', icon: 'personPlus', value: 'req' }] });
      if (!k) return; const c = await Contacts.pick(k === 'share' ? 'Partilhar a localização com' : 'Pedir a localização a'); if (!c) return;
      if (k === 'share') { if (!await UI.confirm('Partilhar a localização', `${c.name || c.number} passa a ver onde estás, até deixares de partilhar.`, 'Partilhar')) return; shareWith(c.number, true); } else requestFrom(c.number);
    }
    function openPerson(p) { det = { kind: 'person', number: p.number, p }; sel = p.number; if (has(p)) { map.centerOn(p.x, p.y); if (map.st.ppm < .45) map.setPpm(.6); } tab = 0; root.querySelectorAll(K.tabs).forEach((s, k) => s.classList.toggle('on', k === 0)); paint(); }
    function openDevice(d) { det = { kind: 'device', d }; sel = null; map.follow(); paint(); }
    const back = () => { det = null; sel = null; paint(); };

    /* ---------- pinos: avatar com cauda (a ponta no sítio) ---------- */
    function pins() { map.pins.innerHTML = ''; data.people.filter(has).forEach(p => { const pin = A ? UI.el(`<div class="map-pin afind-pin ${sel === p.number ? 'sel' : ''}" data-x="${p.x}" data-y="${p.y}"><div class="afind-pinav">${avatarOf(p, 'sm')}</div><i class="afind-tail"></i></div>`) : UI.el(`<div class="map-pin fm-pin ${sel === p.number ? 'sel' : ''}" data-x="${p.x}" data-y="${p.y}"><div class="fm-pinav">${avatarOf(p, 'sm')}</div><i class="fm-tail"></i></div>`); pin.onclick = e => { e.stopPropagation(); Sound.play('click'); openPerson(p); }; paintAv(pin, p); map.pins.appendChild(pin); }); map.update(); }

    /* ---------- folha ---------- */
    const row = (p, o = {}) => { if (A) return rowA(p, o); const r = UI.el(`<div class="fm-row"><div class="fm-av">${o.icon ? `<div class="fm-devav">${g(o.icon, 22)}</div>` : avatarOf(p)}</div><div class="fm-rb"><b>${UI.esc(o.name || nameOf(p))}</b><span>${UI.esc(o.sub != null ? o.sub : status(p))}</span></div>${o.right != null ? o.right : `<div class="fm-rt">${UI.esc(o.when != null ? o.when : when(p))}</div>`}</div>`); if (!o.icon) paintAv(r, p); return r; };
    const hdr = t => UI.el(`<div class="${A ? 'afind-hdr' : 'fm-hdr'}">${UI.esc(t)}</div>`);
    const rowA = (p, o = {}) => { const r = UI.el(`<div class="afind-row"><div class="afind-av">${o.icon ? `<div class="afind-dev">${g(o.icon, 22)}</div>` : avatarOf(p)}</div><div class="afind-rb"><b></b><span></span></div>${o.right != null ? o.right : '<em class="afind-rt"></em>'}</div>`);
      r.querySelector('b').textContent = o.name || nameOf(p); r.querySelector('.afind-rb span').textContent = o.sub != null ? o.sub : status(p);
      const rt = r.querySelector('.afind-rt'); if (rt) { const w = o.when != null ? o.when : (has(p) ? distTxt(p) : ''); if (w) rt.textContent = w; else rt.remove(); }
      if (!o.icon) paintAv(r, p); return r; };
    const emptyA = (t, s) => { const e = UI.el('<div class="afind-empty"><b></b><span></span></div>'); e.querySelector('b').textContent = t; if (s) e.querySelector('span').textContent = s; else e.querySelector('span').remove(); return e; };
    const title = (t, o = {}) => { if (A) { head.innerHTML = `<div class="afind-ht">${o.back ? `<div class="afind-back">${g('chevL', 22)}</div>` : ''}<b></b></div>`; head.querySelector('b').textContent = t; head.classList.toggle('det', !!o.back); root.querySelector('.afind-seg').classList.toggle('hidden', !!o.back); const b = head.querySelector('.afind-back'); if (b) b.onclick = back; return; } head.innerHTML = `${o.back ? `<div class="fm-back">${g('chevL', 22)}</div>` : ''}<b class="${o.back ? 'sm' : ''}">${UI.esc(t)}</b>${o.add ? `<div class="fm-add">${g('plus')}</div>` : ''}`; const b = head.querySelector('.fm-back'); if (b) b.onclick = back; const a = head.querySelector('.fm-add'); if (a) a.onclick = () => add(); };
    function paint() {
      if (A) setTimeout(fitA, 0);
      pins(); body.innerHTML = ''; railF();
      const EC = A ? 'afind-isempty' : 'fm-isempty'; body.classList.remove(EC);
      if (det && det.kind === 'person') return paintPerson(det.p);
      if (det && det.kind === 'device') return paintDevice(det.d);
      if (err) body.appendChild(A ? emptyA('Sem resposta do servidor', 'A tentar outra vez.') : UI.el('<div class="fm-empty">Sem resposta do servidor. A tentar outra vez…</div>'));
      if (tab === 0) {
        title('Pessoas', { add: true });
        const ppl = data.people.slice().sort((a, b) => (has(b) - has(a)) || nameOf(a).localeCompare(nameOf(b)));
        if (data.requests.length) { body.appendChild(hdr('Pedidos')); data.requests.forEach(p => { const r = row(p, { sub: 'Quer ver a tua localização', right: A ? '<div class="afind-btns"><div class="afind-pb on ok">Aceitar</div><div class="afind-pb no">Recusar</div></div>' : `<div class="fm-btns"><div class="pill-btn on ok">Aceitar</div><div class="pill-btn gray no">Recusar</div></div>` }); r.querySelector('.ok').onclick = e => { e.stopPropagation(); respond(p.number, true); }; r.querySelector('.no').onclick = e => { e.stopPropagation(); respond(p.number, false); }; body.appendChild(r); }); }
        if (!ppl.length && !data.sharing.length) body.appendChild(A ? emptyA('Ainda ninguém partilha a localização contigo', 'Toca em + para partilhar a tua localização ou pedir a de alguém.') : UI.el(`<div class="fm-empty"><b>Ainda ninguém partilha a localização contigo</b>Toca em + para partilhar a tua localização ou pedir a de alguém.</div>`));
        ppl.forEach(p => { const r = row(p); r.onclick = () => { Sound.play('click'); openPerson(p); }; body.appendChild(r); });
        const onlyMine = data.sharing.filter(s => !data.people.some(p => p.number === s.number));
        if (onlyMine.length) { body.appendChild(hdr('Veem a tua localização')); onlyMine.forEach(p => { const r = row(p, { sub: 'Não partilha a localização contigo', when: '' }); r.onclick = () => openPerson(p); body.appendChild(r); }); }
        /* so o aviso na folha: fica ao centro do espaco livre dela (apps.css / oneui-apps3.css) */
        const fe = body.firstElementChild; if (body.childElementCount === 1 && fe && fe.classList.contains(A ? 'afind-empty' : 'fm-empty')) body.classList.add(EC);
      } else if (tab === 1) {
        title('Dispositivos');
        const me = Maps.me; const devs = [{ id: 'phone', name: System.deviceName ? System.deviceName() : 'PearPhone', icon: 'phone', sub: 'Contigo · ' + (isFinite(+me.x) ? 'agora' : 'à espera do GPS') }];
        /* o par ligado (AirBuds ou Slate Buds): o nome vem do Earbuds, que o recebe do servidor */
        if (System.state.earbuds) devs.push({ id: 'buds', name: (window.Earbuds && Earbuds.NAME) || (System.config && System.config.airpods && System.config.airpods.name) || 'Auriculares', icon: 'earbuds', sub: 'Ligados · contigo' });
        devs.forEach(d => { const r = row({ number: '' }, { icon: d.icon, name: d.name, sub: d.sub, when: 'agora' }); r.onclick = () => { Sound.play('click'); openDevice(d); }; body.appendChild(r); });
      } else {
        title('Eu');
        const me = Maps.me;
        body.appendChild(hdr('A minha localização'));
        const meRow = row({ number: '' }, { icon: 'nav', name: 'Los Santos', sub: isFinite(+me.x) ? `X ${Math.round(me.x)} · Y ${Math.round(me.y)}` : 'À espera do GPS', when: 'agora' }); meRow.onclick = () => map.follow(); body.appendChild(meRow);
        body.appendChild(UI.list([{ items: [{ label: 'Partilhar a minha localização', toggle: !data.paused, onToggle: v => pause(!v) }], footer: data.paused ? 'Em pausa: ninguém vê onde estás, mas a tua lista fica guardada.' : `${data.sharing.length} pessoa${data.sharing.length === 1 ? '' : 's'} pode${data.sharing.length === 1 ? '' : 'm'} ver onde estás.` }]));
        body.appendChild(hdr('A partilhar com'));
        if (!data.sharing.length) body.appendChild(A ? emptyA('Não partilhas a tua localização com ninguém.') : UI.el('<div class="fm-empty">Não partilhas a tua localização com ninguém.</div>'));
        data.sharing.forEach(p => { const r = row(p, { sub: p.mutual ? 'Também partilha contigo' : 'Não partilha contigo', right: A ? '<div class="afind-pb stop">Parar</div>' : `<div class="pill-btn gray stop">Parar</div>` }); r.querySelector('.stop').onclick = async e => { e.stopPropagation(); if (await UI.confirm('Parar de partilhar', `${nameOf(p)} deixa de ver onde estás.`, 'Parar', true)) shareWith(p.number, false); }; r.onclick = () => openPerson(p); body.appendChild(r); });
        if (data.requested.length) { body.appendChild(hdr('Pedidos enviados')); data.requested.forEach(p => body.appendChild(row(p, { sub: 'À espera de resposta', when: '' }))); }
      }
    }
    /* detalhe da pessoa: avatar grande, estado, três botões (Mensagem · Ligar · Direções), partilha com ela, pedir, parar */
    /* Nova UI: cabeçalho com o avatar e o estado, botões redondos com etiqueta e as mesmas opções de partilha */
    function paintPersonA(p) {
      title('Pessoas', { back: true });
      const sharing = data.sharing.some(s => s.number === p.number), sharesMe = data.people.some(x => x.number === p.number);
      const hero = UI.el(`<div class="afind-det"><div class="afind-hero">${avatarOf(p, 'lg')}<div class="afind-htx"><b></b><span></span></div></div><div class="afind-acts"><div class="afind-act msg"><i>${g('message', 22)}</i><span>Mensagem</span></div><div class="afind-act call"><i>${g('phone', 22)}</i><span>Ligar</span></div><div class="afind-act go ${has(p) ? '' : 'dis'}"><i>${g('nav', 22)}</i><span>Direções</span></div></div></div>`);
      hero.querySelector('.afind-htx b').textContent = nameOf(p); hero.querySelector('.afind-htx span').textContent = has(p) ? status(p) + ' · agora' : status(p);
      paintAv(hero, p);
      hero.querySelector('.msg').onclick = () => { if (window.Msgs && Msgs.open) Msgs.open(p.number, nameOf(p)); };
      hero.querySelector('.call').onclick = () => { if (window.PhoneApp && PhoneApp.call) PhoneApp.call(p.number, nameOf(p)); };
      hero.querySelector('.go').onclick = () => route(p);
      body.appendChild(hero);
      const items = [{ label: 'Partilhar a minha localização', toggle: sharing, onToggle: async v => { const ok = await shareWith(p.number, !!v); if (!ok) paint(); } }];
      if (!sharesMe) items.push({ label: 'Pedir para partilhar comigo', cls: 'blue', chevron: false, onTap: () => requestFrom(p.number) });
      body.appendChild(UI.list([{ items, footer: sharing ? `${nameOf(p)} vê a tua localização.` : `${nameOf(p)} não vê a tua localização.` }, ...(sharing ? [{ items: [{ label: 'Parar de partilhar com ' + nameOf(p), cls: 'danger', chevron: false, onTap: async () => { if (await UI.confirm('Parar de partilhar', `${nameOf(p)} deixa de ver onde estás.`, 'Parar', true)) { await shareWith(p.number, false); back(); } } }] }] : [])]));
    }
    function paintDeviceA(d) {
      title('Dispositivos', { back: true });
      const hero = UI.el(`<div class="afind-det"><div class="afind-hero"><div class="afind-dev big">${g(d.icon, 30)}</div><div class="afind-htx"><b></b><span></span></div></div><div class="afind-acts"><div class="afind-act snd"><i>${g('speaker', 22)}</i><span>Reproduzir som</span></div><div class="afind-act go"><i>${g('nav', 22)}</i><span>Ver no mapa</span></div></div></div>`);
      hero.querySelector('.afind-htx b').textContent = d.name; hero.querySelector('.afind-htx span').textContent = d.sub;
      hero.querySelector('.snd').onclick = () => { Sound.play('timer'); UI.toast(d.name + ' a tocar'); };
      hero.querySelector('.go').onclick = () => { map.follow(); if (map.st.ppm < .6) map.setPpm(.8); };
      body.appendChild(hero);
      body.appendChild(UI.el(`<div class="afind-note">${d.id === 'buds' ? 'Os auriculares estão ligados a este telemóvel: estão onde tu estás.' : 'Este é o telemóvel em que estás: a localização é a tua.'}</div>`));
    }
    function paintPerson(p) {
      if (A) return paintPersonA(p);
      title(nameOf(p), { back: true });
      const sharing = data.sharing.some(s => s.number === p.number), sharesMe = data.people.some(x => x.number === p.number);
      const hero = UI.el(`<div class="fm-det"><div class="fm-hero">${avatarOf(p, 'lg')}<b>${UI.esc(nameOf(p))}</b><span>${UI.esc(has(p) ? status(p) + ' · agora' : status(p))}</span></div>
        <div class="fm-dacts"><div class="fm-dact msg">${g('message')}<span>Mensagem</span></div><div class="fm-dact call">${g('phone')}<span>Ligar</span></div><div class="fm-dact go ${has(p) ? '' : 'dis'}">${g('nav')}<span>Direções</span></div></div></div>`);
      paintAv(hero, p);
      hero.querySelector('.msg').onclick = () => { if (window.Msgs && Msgs.open) Msgs.open(p.number, nameOf(p)); };
      hero.querySelector('.call').onclick = () => { if (window.PhoneApp && PhoneApp.call) PhoneApp.call(p.number, nameOf(p)); };
      hero.querySelector('.go').onclick = () => route(p);
      body.appendChild(hero);
      const items = [{ label: 'Partilhar a minha localização', toggle: sharing, onToggle: async v => { const ok = await shareWith(p.number, !!v); if (!ok) paint(); } }];
      if (!sharesMe) items.push({ label: 'Pedir para partilhar comigo', cls: 'blue', chevron: false, onTap: () => requestFrom(p.number) });
      body.appendChild(UI.list([{ items, footer: sharing ? `${nameOf(p)} vê a tua localização.` : `${nameOf(p)} não vê a tua localização.` }, ...(sharing ? [{ items: [{ label: 'Parar de partilhar com ' + nameOf(p), cls: 'danger', chevron: false, onTap: async () => { if (await UI.confirm('Parar de partilhar', `${nameOf(p)} deixa de ver onde estás.`, 'Parar', true)) { await shareWith(p.number, false); back(); } } }] }] : [])]));
    }
    function paintDevice(d) {
      if (A) return paintDeviceA(d);
      title(d.name, { back: true });
      const hero = UI.el(`<div class="fm-det"><div class="fm-hero"><div class="fm-devav big">${g(d.icon, 36)}</div><b>${UI.esc(d.name)}</b><span>${UI.esc(d.sub)}</span></div>
        <div class="fm-dacts"><div class="fm-dact snd">${g('speaker')}<span>Reproduzir som</span></div><div class="fm-dact go">${g('nav')}<span>Ver no mapa</span></div></div></div>`);
      hero.querySelector('.snd').onclick = () => { Sound.play('timer'); UI.toast(d.id === 'buds' ? 'Os ' + d.name + ' estão a tocar' : 'O telemóvel está a tocar'); };
      hero.querySelector('.go').onclick = () => { map.follow(); if (map.st.ppm < .6) map.setPpm(.8); };
      body.appendChild(hero);
      body.appendChild(UI.list([{ footer: d.id === 'buds' ? 'Os ' + d.name + ' estão emparelhados com este telemóvel: estão onde tu estás.' :'Este é o telemóvel em que estás: a localização é a tua.' }]));
    }

    /* ---------- arranque / vida ---------- */
    win.querySelector('.nav-stack').appendChild(root);
    win._back = () => { if (!det) return false; back(); return true; };
    const poll = () => { clearInterval(timer); timer = setInterval(() => { if (System.currentApp() === 'findmy') refresh(); }, 4000); };
    Bridge.call('getCoords').then(c => { if (c) Maps.setMe(c); map.update(); }); Bridge.call('startGPS');
    refresh(); poll();
    const offC = Bridge.on('coords', () => { if (System.currentApp() === 'findmy') map.update(); });
    const offF = Bridge.on('findmy:changed', () => { if (System.currentApp() === 'findmy') refresh(); });
    const offA = Bridge.on('findmy:add', k => add(k));
    const gpsIdle = () => { if (!Maps.route && System.currentApp() !== 'maps') Bridge.call('stopGPS'); };
    const d = App.get('findmy'); d.pause = () => { clearInterval(timer); gpsIdle(); }; d.resume = () => { Bridge.call('startGPS'); refresh(); poll(); };
    win.onClose = () => { clearInterval(timer); offC(); offF(); offA(); if (offFold) { offFold(); offFold = null; } map.destroy(); gpsIdle(); const dd = App.get('findmy'); if (dd) { delete dd.pause; delete dd.resume; } };
  }
});
/* uma notificação da Encontrar (partilha nova, pedido) com a app fechada: o toque abre a app (comportamento por omissão do notify.js) */