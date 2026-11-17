/* ===================== EATS - entrega de comida (Glovo / Uber Eats) =====================
   Servidor: server/eats.lua · Catálogo: Config.Eats (config.lua) · Estilos: css/app-eats.css

   Notas de desempenho (CEF): nada de backdrop-filter nem filter aqui; a "fotografia" de cada
   prato é um SVG plano desenhado por Art.get() e guardado em cache por chave, porque a mesma
   arte aparece dezenas de vezes numa lista. As listas longas usam content-visibility (CSS).
   ===================================================================================== */

/* 2026-10-01 (pedido do dono: icones mais parecidos com as apps reais): fundo preto com a palavra "Eats" a verde, como o
   das apps de entrega. Num ícone em imagem (tileUrl) as fontes da página não chegam: fica a Segoe/Arial em negrito. */
Icons.app.eats = () => Icons.SVG(Icons.G('gEa', '#1F1F1F', '#0E0E0E', '#000000') + Icons.GL(
  `<text x="50" y="61" text-anchor="middle" font-family="Inter,Segoe UI,Arial,sans-serif" font-size="30" font-weight="800" letter-spacing="-1" fill="#06C167">Eats</text>`));

/* ---------------------------------------------------------------------------
   Arte da comida - SVG planos, sem imagens externas.
   Cada desenho recebe as duas cores do prato (art:[cima, baixo] no config).
   --------------------------------------------------------------------------- */
window.EatsArt = (() => {
  const cache = new Map();
  const D = {
    burger: '<rect x="14" y="30" width="72" height="18" rx="9" fill="#E8B87A"/><rect x="16" y="46" width="68" height="9" rx="4.5" fill="#7BB661"/><rect x="14" y="53" width="72" height="12" rx="4" fill="#8A4B24"/><rect x="18" y="63" width="64" height="9" rx="4.5" fill="#F2C94C"/><rect x="14" y="70" width="72" height="16" rx="8" fill="#D9A566"/>',
    chicken: '<path d="M50 20c16 0 27 12 27 27 0 15-11 25-27 25S23 62 23 47c0-15 11-27 27-27z" fill="#D9A244"/><path d="M42 68l-6 16M58 68l6 16" stroke="#E8D5B0" stroke-width="7" stroke-linecap="round"/><circle cx="41" cy="42" r="4" fill="#B0762A"/><circle cx="60" cy="46" r="3.4" fill="#B0762A"/>',
    pizza: '<path d="M50 16 84 80H16z" fill="#E8C06B"/><path d="M50 30 74 76H26z" fill="#D9584A"/><circle cx="50" cy="58" r="5" fill="#B03A2E"/><circle cx="38" cy="68" r="4.2" fill="#B03A2E"/><circle cx="62" cy="68" r="4.2" fill="#B03A2E"/>',
    sushi: '<rect x="20" y="38" width="60" height="30" rx="8" fill="#F3EDE0"/><rect x="20" y="38" width="14" height="30" rx="6" fill="#1F2933"/><rect x="66" y="38" width="14" height="30" rx="6" fill="#1F2933"/><ellipse cx="50" cy="46" rx="20" ry="7" fill="#E9784D"/>',
    taco: '<path d="M18 66a32 32 0 0 1 64 0z" fill="#E8C06B"/><path d="M24 62a26 26 0 0 1 52 0z" fill="#7BB661"/><path d="M30 60a20 20 0 0 1 40 0z" fill="#B0502E"/><rect x="18" y="64" width="64" height="10" rx="5" fill="#D9A94E"/>',
    noodles: '<path d="M24 46h52v12a26 26 0 0 1-52 0z" fill="#F0E4CC"/><path d="M30 44c4-10 12-14 20-14s16 4 20 14" fill="none" stroke="#E8C06B" stroke-width="5" stroke-linecap="round"/><path d="M38 40c2-8 8-12 12-12" fill="none" stroke="#D9A244" stroke-width="4" stroke-linecap="round"/>',
    ramen: '<path d="M22 48h56v10a28 28 0 0 1-56 0z" fill="#C7834A"/><ellipse cx="50" cy="48" rx="28" ry="8" fill="#E8C06B"/><circle cx="41" cy="47" r="5" fill="#F7F2E6"/><circle cx="41" cy="47" r="2.4" fill="#E8A33D"/><rect x="56" y="41" width="14" height="9" rx="3" fill="#B4633A"/>',
    pasta: '<ellipse cx="50" cy="60" rx="30" ry="18" fill="#F0E4CC"/><ellipse cx="50" cy="56" rx="24" ry="12" fill="#E8C06B"/><circle cx="44" cy="54" r="5" fill="#C0392B"/><circle cx="58" cy="58" r="4.4" fill="#C0392B"/>',
    coffee: '<path d="M28 34h38v26a19 19 0 0 1-38 0z" fill="#F3EDE0"/><path d="M66 40h8a8 8 0 0 1 0 16h-8z" fill="none" stroke="#F3EDE0" stroke-width="5"/><ellipse cx="47" cy="38" rx="19" ry="6" fill="#6B4423"/><path d="M30 74h40" stroke="#D8D2C4" stroke-width="6" stroke-linecap="round"/>',
    drink: '<path d="M34 30h32l-4 46a8 8 0 0 1-8 7h-8a8 8 0 0 1-8-7z" fill="#EAF4FA" opacity=".92"/><path d="M36 44h28l-3 32a6 6 0 0 1-6 5h-10a6 6 0 0 1-6-5z" fill="#5BA9D8"/><rect x="46" y="16" width="6" height="20" rx="3" fill="#E8657A" transform="rotate(12 49 26)"/>',
    shake: '<path d="M34 38h32l-4 40a8 8 0 0 1-8 7h-8a8 8 0 0 1-8-7z" fill="#F7EEF2"/><path d="M36 50h28l-3 28a6 6 0 0 1-6 5h-10a6 6 0 0 1-6-5z" fill="#E9A8C0"/><circle cx="50" cy="32" r="10" fill="#FFF"/><circle cx="50" cy="26" r="4" fill="#E8657A"/>',
    fries: '<path d="M32 46h36l-4 34a8 8 0 0 1-8 7H44a8 8 0 0 1-8-7z" fill="#D9453C"/><rect x="38" y="24" width="7" height="26" rx="3" fill="#F2C94C"/><rect x="47" y="18" width="7" height="32" rx="3" fill="#F2C94C"/><rect x="56" y="26" width="7" height="24" rx="3" fill="#F2C94C"/>',
    rings: '<circle cx="42" cy="52" r="18" fill="none" stroke="#D8A05E" stroke-width="9"/><circle cx="62" cy="62" r="14" fill="none" stroke="#C08A42" stroke-width="8"/>',
    nuggets: '<path d="M30 44c8-8 18-6 20 2 6-6 16-4 18 4 4 10-6 20-20 20s-24-14-18-26z" fill="#DDB05A"/><circle cx="44" cy="56" r="3" fill="#B98C32"/><circle cx="56" cy="60" r="2.6" fill="#B98C32"/>',
    wrap: '<path d="M26 66 62 22l14 12-34 46z" fill="#E0C89A"/><path d="M36 58 60 30l6 6-24 30z" fill="#7BB661"/><path d="M22 70l10-6 8 10z" fill="#D9BE8A"/>',
    salad: '<path d="M20 54h60a30 30 0 0 1-60 0z" fill="#F3EDE0"/><circle cx="38" cy="48" r="10" fill="#5FA55A"/><circle cx="56" cy="46" r="9" fill="#7BB661"/><circle cx="48" cy="52" r="6" fill="#C0392B"/>',
    bowl: '<path d="M20 50h60a30 30 0 0 1-60 0z" fill="#E8DCC8"/><path d="M26 50h48a24 24 0 0 1-48 0z" fill="#F7F2E6"/><circle cx="40" cy="46" r="7" fill="#E2874F"/><circle cx="58" cy="45" r="6" fill="#5FA55A"/>',
    donut: '<circle cx="50" cy="52" r="28" fill="#D9A05E"/><circle cx="50" cy="52" r="10" fill="#F7F2E6"/><path d="M50 24a28 28 0 0 1 0 56 28 28 0 0 1 0-56z" fill="#E8748F" opacity=".9"/><circle cx="50" cy="52" r="10" fill="#F7F2E6"/><rect x="40" y="34" width="7" height="3" rx="1.5" fill="#FFF"/><rect x="58" y="44" width="7" height="3" rx="1.5" fill="#FFF"/><rect x="36" y="62" width="7" height="3" rx="1.5" fill="#FFF"/>',
    cake: '<path d="M26 52h48v26a6 6 0 0 1-6 6H32a6 6 0 0 1-6-6z" fill="#E8C9A0"/><path d="M26 52h48v10H26z" fill="#B4633A"/><rect x="47" y="30" width="6" height="18" rx="3" fill="#F7F2E6"/><circle cx="50" cy="27" r="4" fill="#F2C94C"/>',
    icecream: '<path d="M38 44h24l-9 40a3 3 0 0 1-6 0z" fill="#E8C06B"/><circle cx="42" cy="38" r="12" fill="#F7EEF2"/><circle cx="58" cy="38" r="12" fill="#E9A8C0"/><circle cx="50" cy="30" r="11" fill="#B4633A"/>',
    bread: '<path d="M22 44c0-8 8-14 28-14s28 6 28 14v22a8 8 0 0 1-8 8H30a8 8 0 0 1-8-8z" fill="#DCAE6B"/><path d="M34 40c4 6 4 22 0 30M50 38c4 6 4 26 0 34M66 40c-4 6-4 22 0 30" stroke="#B4854A" stroke-width="3" fill="none"/>',
    dumpling: '<path d="M24 60c0-14 12-22 26-22s26 8 26 22z" fill="#E8DCC0"/><path d="M24 60h52a8 8 0 0 1-8 8H32a8 8 0 0 1-8-8z" fill="#D8C8A4"/><path d="M34 48c4-4 8-4 12 0M54 48c4-4 8-4 12 0" stroke="#C0AE84" stroke-width="3" fill="none" stroke-linecap="round"/>',
    soup: '<path d="M22 48h56a28 28 0 0 1-56 0z" fill="#C7834A"/><ellipse cx="50" cy="48" rx="28" ry="7" fill="#E8C06B"/><path d="M42 30c0 6-6 6-6 12M58 28c0 6-6 6-6 12" stroke="#D8D2C4" stroke-width="3.4" fill="none" stroke-linecap="round"/>',
    nachos: '<path d="M30 74 44 40l16 6z" fill="#E8C06B"/><path d="M50 74 62 42l16 10z" fill="#D9A94E"/><circle cx="46" cy="58" r="5" fill="#C0392B"/><circle cx="62" cy="62" r="4" fill="#5FA55A"/>',
    wings: '<path d="M28 40c12-8 26-6 32 4 5 9-2 22-14 26-11 4-22-2-24-12-2-8 1-14 6-18z" fill="#C25C1E"/><path d="M62 66l12 10" stroke="#E8D5B0" stroke-width="7" stroke-linecap="round"/>',
    fruit: '<circle cx="44" cy="56" r="20" fill="#C0392B"/><circle cx="62" cy="58" r="15" fill="#E05C3E"/><path d="M48 34c0-8 6-12 10-12" stroke="#5FA55A" stroke-width="5" fill="none" stroke-linecap="round"/>',
    pills: '<rect x="22" y="42" width="34" height="18" rx="9" fill="#5CA9E8" transform="rotate(-20 39 51)"/><circle cx="64" cy="58" r="15" fill="#F3EDE0"/><path d="M64 48v20M54 58h20" stroke="#E05C5C" stroke-width="5" stroke-linecap="round"/>',
    grocery: '<path d="M24 40h52l-6 38a8 8 0 0 1-8 7H38a8 8 0 0 1-8-7z" fill="#E8DCC0"/><path d="M38 40V30a12 12 0 0 1 24 0v10" fill="none" stroke="#C0AE84" stroke-width="5"/><circle cx="42" cy="60" r="6" fill="#C0392B"/><circle cx="58" cy="64" r="5" fill="#5FA55A"/>',
    breakfast: '<ellipse cx="50" cy="60" rx="30" ry="18" fill="#F7F2E6"/><circle cx="40" cy="56" r="11" fill="#FFF"/><circle cx="40" cy="56" r="5" fill="#F2C94C"/><rect x="54" y="50" width="20" height="7" rx="3.5" fill="#B4633A"/><rect x="54" y="60" width="20" height="7" rx="3.5" fill="#C25C1E"/>',
    pancake: '<ellipse cx="50" cy="68" rx="26" ry="8" fill="#C08A5A"/><ellipse cx="50" cy="60" rx="26" ry="8" fill="#D9A06B"/><ellipse cx="50" cy="52" rx="26" ry="8" fill="#E0B47C"/><path d="M32 50c8 6 28 6 36 0" stroke="#B4854A" stroke-width="4" fill="none"/><rect x="45" y="38" width="10" height="7" rx="3" fill="#F2C94C"/>',
    diner: '<rect x="20" y="46" width="60" height="28" rx="6" fill="#F3EDE0"/><rect x="20" y="46" width="60" height="9" rx="4" fill="#E05C5C"/><circle cx="50" cy="34" r="10" fill="#31A9B8"/><path d="M28 62h44" stroke="#D8D2C4" stroke-width="5" stroke-linecap="round"/>',
    bag: '<path d="M26 38h48l-5 42a8 8 0 0 1-8 7H39a8 8 0 0 1-8-7z" fill="#F3EDE0"/><path d="M38 38V30a12 12 0 0 1 24 0v8" fill="none" stroke="#F3EDE0" stroke-width="5"/>',
  };
  /* O FUNDO é um gradiente CSS que preenche a caixa toda (seja ela larga ou quadrada)
     e o DESENHO é um SVG quadrado por cima, com `meet`, sempre inteiro e centrado.
     Com um único <svg> e `slice` o prato ficava gigante nas miniaturas largas. */
  const get = (glyph, colors) => {
    const c = colors || ['#8A8A90', '#4A4A50'];
    const key = glyph + '|' + c[0] + c[1];
    let hit = cache.get(key);
    if (hit !== undefined) return hit;
    const inner = D[glyph] || D.bag;
    hit = `<div class="ea-artwrap" style="background:linear-gradient(160deg,${c[0]},${c[1]})">` +
      `<svg class="ea-art" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid meet" aria-hidden="true">${inner}</svg></div>`;
    cache.set(key, hit);
    return hit;
  };
  return { get, has: g => !!D[g] };
})();

App.define('eats', {
  name: 'Eats', category: 'Comida', needs: ['location'],
  description: 'Restaurantes, mercearia e farmácia entregues onde estiveres. Segue o teu estafeta no mapa em tempo real.',
  actions: [
    { label: 'Os meus pedidos', icon: 'receipt', onTap: () => { System.openApp('eats'); setTimeout(() => Bridge.emit('eats:goto', 2), 350); } },
    { label: 'Modo estafeta', icon: 'car', onTap: () => { System.openApp('eats'); setTimeout(() => Bridge.emit('eats:goto', 3), 350); } },
  ],
  open(win) {
    const g = UI.g, esc = UI.esc, money = UI.money, art = EatsArt.get;
    const hour = () => (typeof System.gameHour === 'number' ? System.gameHour : new Date().getHours());

    /* ---------- estado ---------- */
    const S = {
      home: null,            // resposta de eats.home
      cart: { rest: null, lines: [] },
      tip: 0, promo: '', promoMsg: '',
      addr: null,            // { label, x, y } - null = posição atual
      pay: 'card',
      tabs: null, offers: [], courierOn: false, watch: null,
    };
    const CART_KEY = 'eats:cart';
    try { const raw = localStorage.getItem(CART_KEY); if (raw) { const c = JSON.parse(raw); if (c && c.rest) S.cart = c; } } catch (e) {}
    const saveCart = () => { try { localStorage.setItem(CART_KEY, JSON.stringify(S.cart)); } catch (e) {} };

    /* ---------- POLLING COM TRAVÕES ----------
       O seguimento, a cozinha e o painel do estafeta perguntam ao servidor de poucos em poucos
       segundos. O `v.opts.onPop` só corre quando se sai pelo botão de voltar: tocar num separador
       (UI.setRoot apaga a pilha sem correr onPop), abrir outra app (a janela é só escondida) ou
       guardar o telemóvel deixavam o setInterval a fazer RPC para sempre - e acumulava-se um por
       cada visita ao painel. Cada tick ainda reconstruía a lista dentro de um nó já fora do ecrã.
       Aqui: uma vista já desligada do DOM mata o próprio intervalo (e sai de win.timers), e com o
       telemóvel guardado ou outra app à frente o tick salta - o intervalo fica, mas não fala com o
       servidor nem pinta nada. */
    const poll = (node, fn, ms) => {
      const t = setInterval(() => {
        if (!node.isConnected) { clearInterval(t); const i = win.timers.indexOf(t); if (i > -1) win.timers.splice(i, 1); return; }
        if (document.body.classList.contains('hidden') || (System.currentApp && System.currentApp() !== 'eats')) return;
        fn();
      }, ms);
      win.timers.push(t);
      return t;
    };

    /* cores dos ícones das categorias - os desenhos são claros, por isso o fundo
       tem de ser saturado (num cinzento claro o "saco" branco desaparecia) */
    const CATC = {
      all: ['#8E8E93', '#5A5A5F'], burger: ['#F07A3C', '#B34A12'], pizza: ['#E8574A', '#A21F16'],
      sushi: ['#E8899B', '#A83E56'], chicken: ['#E8A93C', '#A56A0E'], mexican: ['#E9762B', '#A34A08'],
      asian: ['#C9303C', '#7A1219'], italian: ['#4E9C50', '#245223'], coffee: ['#8A6244', '#4A3020'],
      dessert: ['#E8748F', '#A83454'], healthy: ['#5FBF77', '#268044'], grocery: ['#4A90D9', '#1E5089'],
      pharmacy: ['#3FA79A', '#14615A'],
    };
    const catArt = c => art(c.glyph, CATC[c.id] || CATC.all);

    const cartCount = () => S.cart.lines.reduce((n, l) => n + l.qty, 0);
    const restOf = id => (S.home && S.home.restaurants || []).find(r => r.id === id);
    const stars = n => { let s = ''; for (let i = 1; i <= 5; i++) s += `<span class="${i <= Math.round(n) ? 'on' : ''}">★</span>`; return s; };
    const timeTxt = t => Array.isArray(t) ? `${t[0]}-${t[1]} min` : '--';

    /* ---------- barra do carrinho (flutua sobre a vista) ---------- */
    const bar = UI.el(`<div class="ea-cartbar"><div class="n">0</div><div class="t">Ver carrinho</div><div class="p">${UI.money(0)}</div></div>`);
    bar.onclick = () => { if (cartCount()) openCart(); };
    win.appendChild(bar);
    const paintBar = () => {
      const n = cartCount();
      bar.classList.toggle('show', n > 0);
      if (!n) return;
      bar.querySelector('.n').textContent = n;
      const sub = S.cart.lines.reduce((s, l) => s + l.unit * l.qty, 0);
      bar.querySelector('.p').textContent = money(sub);
      const r = restOf(S.cart.rest);
      bar.querySelector('.t').textContent = r ? r.name : 'Ver carrinho';
    };

    /* =========================================================
       INÍCIO
       ========================================================= */
    let curCat = 'all', sortBy = 'rec';

    function restCard(r, compact) {
      const closed = !r.open;
      const c = UI.el(`<div class="ea-card ${closed ? 'closed' : ''} ${compact ? 'sm' : ''}">
        <div class="ea-thumb">${art(r.glyph, r.art)}${r.promo ? `<span class="ea-tag">${esc(r.promo)}</span>` : ''}${closed ? '<span class="ea-closed">Fechado</span>' : ''}
          <div class="ea-fav ${r.fav ? 'on' : ''}">${g('heart', 20)}</div></div>
        <div class="ea-cbody"><div class="ea-crow"><b>${esc(r.name)}</b><span class="ea-rate">${g('star', 17)}${(r.rating || 0).toFixed(1)}</span></div>
          <div class="muted small">${esc(r.tagline || '')}</div>
          <div class="ea-meta"><span>${g('clock', 17)}${timeTxt(r.time)}</span><span>${g('car', 17)}${r.fee > 0 ? money(r.fee) : 'Grátis'}</span></div>
        </div></div>`);
      c.querySelector('.ea-fav').onclick = async e => {
        e.stopPropagation();
        const res = await Bridge.rpc('eats.fav', { id: r.id });
        /* a Pesquisa passa CÓPIAS dos restaurantes: o preferido tem de chegar também ao S.home,
           que o Início reutiliza sem voltar a perguntar ao servidor (ver o load() do homeView) */
        if (res && res.ok) { r.fav = res.fav; const h = restOf(r.id); if (h && h !== r) h.fav = res.fav; c.querySelector('.ea-fav').classList.toggle('on', res.fav); Sound.play('click'); }
      };
      c.onclick = () => openRest(r.id);
      return c;
    }

    function homeView() {
      const v = UI.view({ title: 'Eats', large: true, cls: 'ea', right: [{ icon: 'pin', cls: 'glass', onTap: () => pickAddress() }] });
      const head = UI.el(`<div class="ea-addr">${g('pin', 19)}<span class="l">A carregar…</span>${g('chevD', 17)}</div>`);
      head.onclick = () => pickAddress();
      v.content.appendChild(head);
      const paintAddr = () => { head.querySelector('.l').textContent = S.addr ? S.addr.label : 'Onde estou agora'; };
      paintAddr();

      const cats = UI.el('<div class="ea-cats"></div>');
      v.content.appendChild(cats);
      const list = UI.el('<div class="ea-list"></div>');
      v.content.appendChild(list);
      list.appendChild(UI.spinner());

      const paintCats = () => {
        cats.innerHTML = '';
        (S.home.categories || []).forEach(c => {
          const d = UI.el(`<div class="ea-cat ${c.id === curCat ? 'on' : ''}"><div class="ea-cico">${catArt(c)}</div><span>${esc(c.label)}</span></div>`);
          d.onclick = () => { curCat = c.id; paintCats(); paint(); };
          cats.appendChild(d);
        });
      };

      const paint = () => {
        let rs = (S.home.restaurants || []).slice();
        if (curCat !== 'all') rs = rs.filter(r => (r.cats || []).indexOf(curCat) > -1);
        if (sortBy === 'rating') rs.sort((a, b) => b.rating - a.rating);
        else if (sortBy === 'time') rs.sort((a, b) => (a.time || [99])[0] - (b.time || [99])[0]);
        else if (sortBy === 'fee') rs.sort((a, b) => a.fee - b.fee);
        else rs.sort((a, b) => (b.open - a.open) || (b.fav - a.fav) || (b.rating - a.rating));

        list.innerHTML = '';
        if (!rs.length) { list.appendChild(UI.empty('search', 'Nada por aqui', 'Experimenta outra categoria.')); return; }

        const favs = rs.filter(r => r.fav);
        if (favs.length && curCat === 'all') {
          list.appendChild(UI.el('<div class="ea-h">Os teus preferidos</div>'));
          const row = UI.el('<div class="ea-rail"></div>');
          favs.forEach(r => row.appendChild(restCard(r, true)));
          list.appendChild(row);
        }
        const pro = S.home.pro || {};
        if (!pro.active) {
          const card = UI.el(`<div class="ea-pro"><div><b>Eats Pro</b><span>Entregas grátis durante ${pro.days || 30} dias</span></div><div class="btn-p btn-s">${money(pro.price || 0)}</div></div>`);
          card.onclick = () => buyPro();
          list.appendChild(card);
        }
        list.appendChild(UI.el(`<div class="ea-h">${curCat === 'all' ? 'Tudo à tua volta' : esc((S.home.categories.find(c => c.id === curCat) || {}).label || '')} <span class="ea-sort">${g('sliders', 20)}</span></div>`));
        /* cada cartão traz um SVG; com 12 restaurantes eram 38 SVG de uma vez na
           primeira vista. Só os 4 primeiros se veem sem rolar - o resto entra 2 frames depois. */
        list.querySelector('.ea-sort').onclick = async () => {
          const r = await UI.actionSheet({ title: 'Ordenar por', buttons: [
            { label: 'Recomendado', value: 'rec' }, { label: 'Melhor avaliação', value: 'rating' },
            { label: 'Entrega mais rápida', value: 'time' }, { label: 'Taxa mais baixa', value: 'fee' }] });
          if (r) { sortBy = r; paint(); }
        };
        rs.slice(0, 4).forEach(r => list.appendChild(restCard(r)));
        /* a cauda entra 2 frames depois. setTimeout como rede: no CEF com o telemóvel
           aberto o rAF dispara sempre, mas se por alguma razão não disparar a lista NÃO
           pode ficar a meio - foi o que aconteceu na loja e só se viu ao contar os nós. */
        if (rs.length > 4) {
          let done = false;
          const rest = () => { if (done || !list.isConnected) return; done = true; rs.slice(4).forEach(r => list.appendChild(restCard(r))); };
          requestAnimationFrame(() => requestAnimationFrame(rest));
          setTimeout(rest, 220);
        }
      };

      const load = async () => {
        /* cada toque num separador (e cada S.tabs.refresh) reconstrói esta vista: pedia o eats.home
           ao servidor outra vez, com os dados ainda frescos em S.home. Com menos de 1 min e a mesma
           hora do jogo (é a hora que abre/fecha restaurantes) pinta-se já do que está em memória -
           os preferidos e o Pro são atualizados localmente quando mudam. */
        if (S.home && S.homeHour === hour() && Date.now() - (S.homeAt || 0) < 60000) { paintCats(); paint(); paintBar(); paintAddr(); return; }
        const d = await Bridge.rpc('eats.home', { hour: hour() });
        if (!d) { list.innerHTML = ''; list.appendChild(UI.empty('cloud', 'Sem ligação', 'O serviço não respondeu.')); return; }
        S.home = d; S.homeAt = Date.now(); S.homeHour = hour(); S.courierOn = !!(d.courier && d.courier.on);
        paintCats(); paint(); paintBar(); paintAddr();
      };
      load();
      v.opts.onPop = () => {};
      return v;
    }

    /* =========================================================
       PESQUISA
       ========================================================= */
    function searchView() {
      const v = UI.view({ title: 'Pesquisar', large: true, cls: 'ea' });
      let t = null;
      const s = UI.search('Restaurantes ou pratos', q => { clearTimeout(t); t = setTimeout(() => paint(q), 180); });
      v.content.appendChild(s);
      const holder = UI.el('<div class="ea-list"></div>');
      v.content.appendChild(holder);
      v.opts.onPop = () => clearTimeout(t);

      const paint = async q => {
        holder.innerHTML = '';
        if (!S.home) return;
        if (!q) {
          holder.appendChild(UI.el('<div class="ea-h">Categorias</div>'));
          const grid = UI.el('<div class="ea-grid"></div>');
          (S.home.categories || []).filter(c => c.id !== 'all').forEach(c => {
            const d = UI.el(`<div class="ea-gtile">${catArt(c)}<span>${esc(c.label)}</span></div>`);
            d.onclick = () => { curCat = c.id; S.tabs.go(0); };
            grid.appendChild(d);
          });
          holder.appendChild(grid);
          return;
        }
        /* pesquisa no SERVIDOR: só ele tem as ementas, por isso é aqui que "sushi" ou
           "cheeseburger" encontram o prato e não apenas o nome do restaurante */
        const r = await Bridge.rpc('eats.search', { q, hour: hour() });
        const rs = (r && r.restaurants) || [], ds = (r && r.dishes) || [];
        if (!rs.length && !ds.length) { holder.appendChild(UI.empty('search', 'Sem resultados', 'Tenta outro nome ou prato.')); return; }
        if (rs.length) {
          holder.appendChild(UI.el('<div class="ea-h">Restaurantes</div>'));
          rs.forEach(x => holder.appendChild(restCard(Object.assign({ fav: false, votes: 0, min: 0 }, x))));
        }
        if (ds.length) {
          holder.appendChild(UI.el('<div class="ea-h">Pratos</div>'));
          ds.forEach(it => {
            const row = UI.el(`<div class="ea-dish"><div class="ea-dbody"><b>${esc(it.name)}</b>
              <div class="ea-ddesc">${esc(it.desc || '')}</div>
              <div class="ea-dprice">${money(it.price)} <span class="muted small">· ${esc(it.restName)}</span></div></div>
              <div class="ea-dthumb">${art(it.glyph, it.art)}</div></div>`);
            row.onclick = () => openRest(it.rest);
            holder.appendChild(row);
          });
        }
      };
      paint('');
      return v;
    }

    /* =========================================================
       RESTAURANTE + MENU
       ========================================================= */
    async function openRest(id) {
      const data = await Bridge.rpc('eats.menu', { id, hour: hour() });
      if (!data) { UI.toast('Restaurante indisponível'); return; }
      const v = UI.view({ title: data.name, back: 'Eats', cls: 'ea', transparent: true, right: [{ icon: 'info', cls: 'glass', onTap: () => info(data) }] });

      v.content.appendChild(UI.el(`<div class="ea-hero">${art(data.glyph, data.art)}<div class="ea-hgrad"></div></div>`));
      v.content.appendChild(UI.el(`<div class="ea-rhead"><h2>${esc(data.name)}</h2>
        <div class="ea-rmeta"><span class="ea-rate">${g('star', 18)}${(data.rating || 0).toFixed(1)}</span><span class="muted">(${data.votes || 0})</span>
        <span>·</span><span>${esc((data.cats || [])[0] || '')}</span></div>
        <div class="ea-rbar"><div><b>${timeTxt(data.time)}</b><span>entrega</span></div><div><b>${data.fee > 0 ? money(data.fee) : 'Grátis'}</b><span>taxa</span></div><div><b>${money(data.min || 0)}</b><span>mínimo</span></div></div>
        ${data.promo ? `<div class="ea-promo">${g('sparkles', 19)}${esc(data.promo)}</div>` : ''}
        ${data.open ? '' : '<div class="ea-warn">Fechado neste momento: podes ver a ementa, mas não encomendar.</div>'}</div>`));

      /* navegação por secções, presa no topo */
      const nav = UI.el('<div class="ea-secnav"></div>');
      v.content.appendChild(nav);
      const body = UI.el('<div class="ea-menu"></div>');
      v.content.appendChild(body);

      (data.menu || []).forEach((sec, i) => {
        const b = UI.el(`<span class="${i === 0 ? 'on' : ''}">${esc(sec.name)}</span>`);
        b.onclick = () => { const el = body.querySelector(`[data-sec="${i}"]`); if (el) v.content.scrollTo({ top: el.offsetTop - 52, behavior: 'smooth' }); };
        nav.appendChild(b);

        const block = UI.el(`<div class="ea-sec" data-sec="${i}"><div class="ea-h">${esc(sec.name)}</div></div>`);
        (sec.items || []).forEach(it => {
          const row = UI.el(`<div class="ea-dish"><div class="ea-dbody"><b>${esc(it.name)}${it.tag === 'popular' ? '<span class="ea-pop">Popular</span>' : ''}</b>
            <div class="ea-ddesc">${esc(it.desc || '')}</div>
            <div class="ea-dprice">${money(it.price)}${it.kcal ? `<span class="muted small"> · ${it.kcal} kcal</span>` : ''}</div></div>
            <div class="ea-dthumb">${art(it.glyph, it.art)}<div class="ea-add">${g('plus', 20)}</div></div></div>`);
          row.onclick = () => dishSheet(data, it);
          block.appendChild(row);
        });
        body.appendChild(block);
      });

      /* separador ativo conforme o scroll */
      let tick = 0;
      v.content.addEventListener('scroll', () => {
        const now = performance.now(); if (now - tick < 120) return; tick = now;   /* não fazer isto a cada frame no CEF */
        const y = v.content.scrollTop + 90;
        let cur = 0;
        body.querySelectorAll('.ea-sec').forEach((el, i) => { if (el.offsetTop <= y) cur = i; });
        [...nav.children].forEach((c, i) => c.classList.toggle('on', i === cur));
      }, { passive: true });

      UI.push(win, v);
    }

    function info(data) {
      const body = UI.el('<div></div>');
      body.appendChild(UI.list([{ items: [
        { icon: 'star', label: 'Avaliação', value: `${(data.rating || 0).toFixed(1)} (${data.votes || 0})`, chevron: false },
        { icon: 'clock', label: 'Entrega estimada', value: timeTxt(data.time), chevron: false },
        { icon: 'car', label: 'Taxa de entrega', value: data.fee > 0 ? money(data.fee) : 'Grátis', chevron: false },
        { icon: 'cart', label: 'Pedido mínimo', value: money(data.min || 0), chevron: false },
        { icon: 'timer', label: 'Horário', value: data.hours && !(data.hours[0] === 0 && data.hours[1] === 24) ? `${data.hours[0]}h - ${data.hours[1]}h` : '24 horas', chevron: false },
      ] }]));
      const b = UI.el(`<div class="btn-p btn-s">${g('nav', 20)} Marcar no mapa</div>`);
      b.onclick = () => { if (data.coords) { Bridge.call('setWaypoint', { x: data.coords.x, y: data.coords.y, name: data.name }); UI.toast('Marcado no GPS'); } };
      body.appendChild(b);
      UI.sheet({ title: data.name, right: 'Fechar', body });
    }

    /* ---------- folha de um prato ---------- */
    function dishSheet(rest, it) {
      let qty = 1;
      const chosen = {};
      (it.options || []).forEach(gr => { chosen[gr.id] = []; if ((gr.min || 0) > 0 && (gr.choices || [])[0]) chosen[gr.id] = [gr.choices[0].id]; });

      const body = UI.el(`<div class="ea-sheet">
        <div class="ea-shero">${art(it.glyph, it.art)}</div>
        <div class="ea-sh"><h3>${esc(it.name)}</h3><p>${esc(it.desc || '')}</p>
          <div class="ea-sprice">${money(it.price)}${it.kcal ? `<span class="muted small"> · ${it.kcal} kcal</span>` : ''}</div></div>
        <div class="ea-opts"></div>
        <div class="group ea-note"><div class="li static"><input type="text" class="nt" placeholder="Nota para o restaurante (opcional)" maxlength="80"></div></div>
        <div class="ea-qty"><div class="m">−</div><b class="q">1</b><div class="p">+</div></div>
      </div>`);

      const opts = body.querySelector('.ea-opts');
      (it.options || []).forEach(gr => {
        const single = (gr.max || 1) === 1;
        const blk = UI.el(`<div class="ea-og"><div class="ea-ogh"><b>${esc(gr.name)}</b><span class="muted small">${(gr.min || 0) > 0 ? 'Obrigatório' : single ? 'Escolhe 1' : `Até ${gr.max}`}</span></div></div>`);
        (gr.choices || []).forEach(c => {
          const on = chosen[gr.id].indexOf(c.id) > -1;
          const li = UI.el(`<div class="ea-oc ${on ? 'on' : ''}"><div class="mk ${single ? 'rd' : ''}">${g('check', 17)}</div><span class="nm">${esc(c.name)}</span>${c.price ? `<span class="pr">+${money(c.price)}</span>` : ''}</div>`);
          li.onclick = () => {
            const arr = chosen[gr.id];
            const i = arr.indexOf(c.id);
            if (single) { chosen[gr.id] = i > -1 && !(gr.min > 0) ? [] : [c.id]; }
            else if (i > -1) arr.splice(i, 1);
            else { if (arr.length >= (gr.max || 99)) { UI.toast(`No máximo ${gr.max}`); return; } arr.push(c.id); }
            blk.querySelectorAll('.ea-oc').forEach((el, k) => el.classList.toggle('on', chosen[gr.id].indexOf((gr.choices[k] || {}).id) > -1));
            price();
          };
          blk.appendChild(li);
        });
        opts.appendChild(blk);
      });

      const unit = () => {
        let u = it.price;
        (it.options || []).forEach(gr => chosen[gr.id].forEach(id => { const c = (gr.choices || []).find(x => x.id === id); if (c) u += (c.price || 0); }));
        return Math.round(u * 100) / 100;
      };
      const sh = UI.sheet({
        title: '', left: 'Cancelar', right: 'Adicionar', cls: 'ea-dsheet', body,
        onDone: () => {
          if (!rest.open) { UI.toast('Restaurante fechado'); return false; }
          for (const gr of (it.options || [])) if (chosen[gr.id].length < (gr.min || 0)) { UI.toast(`Escolhe: ${gr.name}`); return false; }
          addToCart(rest, it, qty, chosen, body.querySelector('.nt').value.trim());
        },
      });
      const btn = sh.el.querySelector('.sh-r');
      const price = () => { btn.textContent = `Adicionar · ${money(unit() * qty)}`; };
      body.querySelector('.m').onclick = () => { if (qty > 1) { qty--; body.querySelector('.q').textContent = qty; price(); Sound.play('click'); } };
      body.querySelector('.p').onclick = () => { if (qty < 20) { qty++; body.querySelector('.q').textContent = qty; price(); Sound.play('click'); } };
      price();
    }

    function addToCart(rest, it, qty, chosen, note) {
      const doAdd = () => {
        const opts = {};
        Object.keys(chosen).forEach(k => { if (chosen[k].length) opts[k] = chosen[k].slice(); });
        let u = it.price;
        (it.options || []).forEach(gr => (chosen[gr.id] || []).forEach(id => { const c = (gr.choices || []).find(x => x.id === id); if (c) u += (c.price || 0); }));
        const sig = it.id + JSON.stringify(opts) + note;
        const same = S.cart.lines.find(l => l.sig === sig);
        if (same) same.qty = Math.min(20, same.qty + qty);
        else S.cart.lines.push({ sig, id: it.id, name: it.name, qty, unit: Math.round(u * 100) / 100, opts, note, glyph: it.glyph, art: it.art });
        S.cart.rest = rest.id;
        saveCart(); paintBar(); Sound.play('success');
        UI.toast(`${it.name} no carrinho`);
      };
      if (S.cart.rest && S.cart.rest !== rest.id && S.cart.lines.length) {
        UI.confirm('Começar um carrinho novo?', `O teu carrinho tem itens de ${(restOf(S.cart.rest) || {}).name || 'outro restaurante'}. Só podes pedir de um restaurante de cada vez.`, 'Começar novo', true)
          .then(ok => { if (ok) { S.cart = { rest: rest.id, lines: [] }; doAdd(); } });
        return;
      }
      doAdd();
    }

    /* =========================================================
       CARRINHO + CHECKOUT
       ========================================================= */
    async function openCart() {
      const r = restOf(S.cart.rest);
      if (!r) { UI.toast('Carrinho vazio'); return; }
      const v = UI.view({ title: 'Carrinho', back: r.name, cls: 'ea', right: [{ icon: 'trash', cls: 'glass', onTap: async () => {
        if (await UI.confirm('Esvaziar carrinho', 'Remover tudo?', 'Esvaziar', true)) { S.cart = { rest: null, lines: [] }; saveCart(); paintBar(); UI.pop(win); }
      } }] });

      const lines = UI.el('<div class="ea-cl"></div>');
      v.content.appendChild(lines);
      const extras = UI.el('<div class="ea-extras"></div>');
      v.content.appendChild(extras);
      const sum = UI.el('<div class="ea-sum"></div>');
      v.content.appendChild(sum);
      const go = UI.el('<div class="btn-p ea-go">A calcular…</div>');
      v.content.appendChild(go);

      let q = null, busy = false, qT = null, qSeq = 0;
      v.opts.onPop = () => clearTimeout(qT);   /* o orçamento adiado não sai depois de fechar o carrinho */

      const paintLines = () => {
        lines.innerHTML = '';
        S.cart.lines.forEach((l, i) => {
          const optTxt = Object.keys(l.opts || {}).map(k => (l.opts[k] || []).join(', ')).filter(Boolean).join(' · ');
          const row = UI.el(`<div class="ea-cline"><div class="th">${art(l.glyph, l.art)}</div>
            <div class="bd"><b>${esc(l.name)}</b>${optTxt ? `<div class="muted small">${esc(optTxt)}</div>` : ''}${l.note ? `<div class="muted small">“${esc(l.note)}”</div>` : ''}
              <div class="ea-step"><span class="m">${l.qty > 1 ? '−' : '🗑'}</span><b>${l.qty}</b><span class="p">+</span></div></div>
            <div class="pz">${money(l.unit * l.qty)}</div></div>`);
          row.querySelector('.m').onclick = () => { if (l.qty > 1) { l.qty--; after(row, l); } else { S.cart.lines.splice(i, 1); after(); } };
          row.querySelector('.p').onclick = () => { if (l.qty < 20) l.qty++; after(row, l); };
          lines.appendChild(row);
        });
      };
      /* + / − mexem SÓ na linha tocada (quantidade, preço e o − / 🗑) e o orçamento sai 300 ms depois do
         ÚLTIMO toque. Antes, subir de 1 para 5 eram 5 callbacks eats.quote e 5 reconstruções da lista
         (com o SVG de cada prato) - e só o 5.º orçamento contava. Remover uma linha redesenha tudo,
         porque os índices das outras mudam. Enquanto há orçamento por sair o botão fica "busy" (como
         ficava durante o RPC) e não deixa fazer o pedido com o total antigo. */
      const after = (row, l) => {
        saveCart(); paintBar();
        if (!S.cart.lines.length) { UI.pop(win); return; }
        if (row && l) {
          row.querySelector('.ea-step b').textContent = l.qty;
          row.querySelector('.pz').textContent = money(l.unit * l.qty);
          row.querySelector('.m').textContent = l.qty > 1 ? '−' : '🗑';
        } else paintLines();
        go.classList.add('busy');
        clearTimeout(qT); qT = setTimeout(() => { qT = null; refresh(); }, 300);
      };

      const paintExtras = () => {
        extras.innerHTML = '';
        /* morada */
        const a = UI.el(`<div class="li has-icon"><div class="li-icon" style="background:#0A84FF">${g('pin')}</div><div class="li-body"><div class="li-label">Entregar em</div><div class="li-sub">${esc(S.addr ? S.addr.label : 'Onde estou agora')}</div></div><div class="li-chev">${g('chevR')}</div></div>`);
        a.onclick = () => pickAddress(() => paintExtras());
        /* pagamento */
        const p = UI.el(`<div class="li has-icon"><div class="li-icon" style="background:#30D158">${g('card')}</div><div class="li-body"><div class="li-label">Pagamento</div><div class="li-sub">${S.pay === 'cash' ? 'Dinheiro' : 'Conta bancária'}</div></div><div class="li-chev">${g('chevR')}</div></div>`);
        p.onclick = async () => {
          const r2 = await UI.picker('Pagamento', [{ value: 'card', label: 'Conta bancária' }, { value: 'cash', label: 'Dinheiro' }], S.pay);
          if (r2) { S.pay = r2; paintExtras(); }
        };
        /* promo */
        const pr = UI.el(`<div class="li has-icon"><div class="li-icon" style="background:#FF9F0A">${g('tag')}</div><div class="li-body"><div class="li-label">Código promocional</div><div class="li-sub">${esc(S.promo || S.promoMsg || 'Nenhum')}</div></div><div class="li-chev">${g('chevR')}</div></div>`);
        pr.onclick = async () => {
          const code = await UI.prompt('Código promocional', 'Escreve o código que tens.', 'BEMVINDO', S.promo);
          if (code !== null) { S.promo = String(code).toUpperCase().trim(); refresh(); }
        };
        const grp = UI.el('<div class="group"></div>');
        grp.appendChild(a); grp.appendChild(p); grp.appendChild(pr);
        extras.appendChild(grp);

        /* gorjeta */
        const tips = (S.home.fees && S.home.fees.tips) || [0, 1, 2, 5];
        const tb = UI.el(`<div class="ea-tip"><div class="ea-h">Gorjeta para o estafeta</div><div class="row"></div></div>`);
        const row = tb.querySelector('.row');
        tips.forEach(t => {
          const d = UI.el(`<span class="${S.tip === t ? 'on' : ''}">${t === 0 ? 'Sem gorjeta' : money(t)}</span>`);
          d.onclick = () => { S.tip = t; paintExtras(); refresh(); };
          row.appendChild(d);
        });
        const other = UI.el('<span class="oth">Outro</span>');
        other.onclick = async () => { const n = await UI.prompt('Gorjeta', 'Quanto queres dar?', '3', String(S.tip), 'number'); if (n !== null) { S.tip = Math.max(0, Math.min(500, +n || 0)); paintExtras(); refresh(); } };
        row.appendChild(other);
        extras.appendChild(tb);
      };

      const paintSum = () => {
        if (!q) { sum.innerHTML = ''; return; }
        const rows = [['Subtotal', money(q.subtotal)]];
        if (q.discount > 0) rows.push(['Desconto' + (q.promo ? ` (${q.promo})` : ''), '−' + money(q.discount), 'ok']);
        rows.push(['Entrega', q.fee > 0 ? money(q.fee) : (q.pro ? 'Grátis · Pro' : 'Grátis'), q.fee > 0 ? '' : 'ok']);
        if (q.smallfee > 0) rows.push(['Taxa de pedido pequeno', money(q.smallfee)]);
        if (q.service > 0) rows.push(['Taxa de serviço', money(q.service)]);
        if (q.tip > 0) rows.push(['Gorjeta', money(q.tip)]);
        sum.innerHTML = `<div class="ea-h">Resumo</div><div class="group ea-sumbox">` +
          rows.map(r => `<div class="ea-srow ${r[2] || ''}"><span>${esc(r[0])}</span><b>${esc(r[1])}</b></div>`).join('') +
          `<div class="ea-srow tot"><span>Total</span><b>${money(q.total)}</b></div></div>`;
      };

      const refresh = async () => {
        const my = ++qSeq;   /* dois orçamentos em voo (gorjeta + quantidade) podiam chegar fora de ordem: só o último pinta */
        go.classList.add('busy');
        const cart = S.cart.lines.map(l => ({ id: l.id, qty: l.qty, opts: l.opts, note: l.note }));
        const res = await Bridge.rpc('eats.quote', { id: S.cart.rest, cart, tip: S.tip, promo: S.promo });
        if (my !== qSeq) return;
        if (qT) return;   /* um toque chegou entretanto: o orçamento dele já vem a caminho e o botão fica "busy" até lá */
        go.classList.remove('busy');
        if (!res || res.error) { go.textContent = 'Não foi possível calcular'; return; }
        q = res;
        if (S.promo && !q.promo) { S.promoMsg = q.promoError === 'used' ? 'Já usado' : q.promoError === 'min' ? 'Valor mínimo não atingido' : 'Código inválido'; S.promo = ''; paintExtras(); }
        else if (q.promo) { S.promoMsg = ''; }
        paintSum();
        const min = (restOf(S.cart.rest) || {}).min || 0;
        if (q.subtotal < min) { go.classList.add('off'); go.textContent = `Faltam ${money(min - q.subtotal)} para o mínimo`; }
        else { go.classList.remove('off'); go.textContent = `Fazer pedido · ${money(q.total)}`; }
      };

      go.onclick = async () => {
        if (busy || qT || go.classList.contains('off') || !q) return;
        if (window.CC && CC.requireNet && !CC.requireNet('fazer o pedido')) return;
        busy = true; go.classList.add('busy');
        const cart = S.cart.lines.map(l => ({ id: l.id, qty: l.qty, opts: l.opts, note: l.note }));
        const res = await Bridge.rpcRaw('eats.order', {
          id: S.cart.rest, cart, tip: S.tip, promo: S.promo, pay: S.pay,
          x: S.addr ? S.addr.x : null, y: S.addr ? S.addr.y : null, label: S.addr ? S.addr.label : 'Morada atual', hour: hour(),
        });
        busy = false; go.classList.remove('busy');
        if (!res || res.error) {
          /* 'db' = o INSERT não gravou e o servidor devolveu o dinheiro (eats.lua:1072-1076): dizer só
             'Tenta novamente' deixava o jogador sem saber se tinha pago */
          const m = { funds: 'Saldo insuficiente.', closed: 'O restaurante fechou.', min: 'Não chegas ao pedido mínimo.', toomanyactive: 'Já tens pedidos a chegar.', nocoords: 'Não consegui saber onde estás.', db: 'Não consegui registar o pedido. O dinheiro foi devolvido.' };
          UI.alert({ title: 'Pedido não feito', msg: (res && m[res.error]) || 'Tenta novamente.' });
          Sound.play('error'); return;
        }
        S.cart = { rest: null, lines: [] }; S.tip = 0; S.promo = ''; saveCart(); paintBar();
        Sound.play('success');
        UI.setRoot(win, trackView(res.order));
        S.tabs.el.classList.add('hidden');
      };

      paintLines(); paintExtras(); refresh();
      UI.push(win, v);
    }

    /* =========================================================
       SEGUIMENTO DO PEDIDO (com mapa)
       ========================================================= */
    const STEPS = [
      { k: 'pending', t: 'Pedido enviado', s: 'À espera de um estafeta' },
      { k: 'accepted', t: 'A preparar', s: 'A cozinha está a trabalhar' },
      { k: 'ready', t: 'Pronto', s: 'O estafeta está a levantar' },
      { k: 'picked', t: 'A caminho', s: 'A tua comida vem a caminho' },
      { k: 'delivered', t: 'Entregue', s: 'Bom apetite!' },
    ];

    function trackView(order) {
      const v = UI.view({ title: '', back: 'Eats', cls: 'ea ea-track', onBack: () => { stop(); S.tabs.el.classList.remove('hidden'); S.tabs.go(0); } });
      const map = MiniMap();
      v.content.appendChild(map.el);
      const card = UI.el('<div class="ea-tcard"></div>');
      v.content.appendChild(card);

      let timer = null;
      /* o `indexOf` estava a procurar o timer DEPOIS de o anular (procurava null): o id nunca saía
         de win.timers e a linha era código morto. Guarda-se antes de limpar. */
      const stop = () => { const t = timer; timer = null; if (t == null) return; clearInterval(t); const i = win.timers.indexOf(t); if (i > -1) win.timers.splice(i, 1); };
      v.opts.onPop = stop;

      /* o tick de 4 s traz quase sempre o MESMO pedido: reconstruir o cartão por innerHTML (avatar,
         ícones SVG, uma linha por artigo, botões recriados) 15×/min só para reescrever o mesmo. Pinta-se
         só quando algo do que o cartão mostra mudou; o mapa, idem, só quando as posições mudam. */
      let lastCard = '', lastMap = '';
      const paint = (o, tr) => {
        const idx = Math.max(0, STEPS.findIndex(s => s.k === o.status));
        const step = STEPS[idx] || STEPS[0];
        const eta = tr && tr.eta != null ? Math.max(1, Math.round(tr.eta / 60)) : null;
        const key = JSON.stringify([o.status, eta, o.id, o.restName, o.courier, o.courierNpc, o.courierPhone, o.items, o.total]);
        if (key === lastCard) return;
        lastCard = key;
        card.innerHTML = `<div class="ea-teta"><b>${o.status === 'delivered' ? 'Entregue' : eta ? eta + ' min' : '--'}</b><span>${esc(step.s)}</span></div>
          <div class="ea-steps">${STEPS.slice(0, 4).map((s, i) => `<div class="${i <= idx ? 'on' : ''}"></div>`).join('')}</div>
          <div class="ea-tstat">${g(o.status === 'delivered' ? 'checkCircle' : 'clock', 16)}<b>${esc(step.t)}</b></div>
          ${o.courier ? `<div class="ea-cour">${UI.avatar({ name: o.courier }, 'sm')}<div class="bd"><b>${esc(o.courier)}</b><span class="muted small">${o.courierNpc ? 'Estafeta Eats' : 'Estafeta'}</span></div>
            ${o.courierPhone ? `<div class="ea-cbtns"><div class="cb call">${g('phone', 20)}</div><div class="cb msg">${g('message', 20)}</div></div>` : ''}</div>` : ''}
          <div class="ea-h">Pedido #${o.id} · ${esc(o.restName || '')}</div>
          <div class="group ea-sumbox">${(o.items || []).map(l => `<div class="ea-srow"><span>${l.qty}× ${esc(l.name)}</span><b>${money(l.total || l.unit * l.qty)}</b></div>`).join('')}
            <div class="ea-srow tot"><span>Total</span><b>${money(o.total)}</b></div></div>`;
        if (o.courierPhone) {
          const c = card.querySelector('.call'), m = card.querySelector('.msg');
          if (c) c.onclick = () => window.PhoneApp && PhoneApp.call(o.courierPhone, o.courier);
          if (m) m.onclick = () => window.Msgs && Msgs.open(o.courierPhone, o.courier);
        }
        if (o.status === 'delivered') {
          stop();
          const b = UI.el('<div class="btn-p">Avaliar entrega</div>');
          b.onclick = () => rate(o);
          card.appendChild(b);
        } else if (o.status === 'pending' || o.status === 'accepted') {
          const b = UI.el('<div class="btn-p btn-s danger-t">Cancelar pedido</div>');
          b.onclick = async () => {
            if (window.CC && CC.requireNet && !CC.requireNet('cancelar o pedido')) return;
            if (!await UI.confirm('Cancelar pedido', 'O valor é devolvido por inteiro.', 'Cancelar pedido', true)) return;
            /* rpcRaw: o Bridge.rpc troca { error } por null e o motivo perdia-se. 'refund' = o dinheiro
               não voltou e o pedido CONTINUA de pé de propósito (eats.lua:1180-1185) - dizer «já é tarde»
               era falso duas vezes. */
            const r = await Bridge.rpcRaw('eats.cancel', { id: o.id });
            if (r && r.ok) { UI.toast('Pedido cancelado'); stop(); S.tabs.el.classList.remove('hidden'); S.tabs.go(2); }
            else UI.toast(r && r.error === 'refund' ? 'Não consegui devolver o dinheiro: o pedido continua de pé' : 'Já é tarde para cancelar');
          };
          card.appendChild(b);
        }
      };

      const tick = async () => {
        const [o, tr] = await Promise.all([Bridge.rpc('eats.order.get', { id: order.id }), Bridge.rpc('eats.track', { id: order.id })]);
        const cur = o || order;
        paint(cur, tr);
        if (tr) { const mk = JSON.stringify([tr.rest, tr.dest, tr.courier]); if (mk !== lastMap) { lastMap = mk; map.update(tr); } }
        if (cur.status === 'delivered' || cur.status === 'cancelled') stop();
      };
      paint(order, null); tick();
      timer = poll(card, tick, 4000);
      return v;
    }

    function rate(o) {
      let n = 5;
      const body = UI.el(`<div class="ea-rate-sheet"><div class="ea-stars">${[1, 2, 3, 4, 5].map(i => `<span data-n="${i}" class="on">★</span>`).join('')}</div>
        <div class="group"><div class="li static"><input type="text" class="nt" placeholder="Deixa um comentário (opcional)" maxlength="140"></div></div></div>`);
      body.querySelectorAll('.ea-stars span').forEach(s => s.onclick = () => { n = +s.dataset.n; body.querySelectorAll('.ea-stars span').forEach(x => x.classList.toggle('on', +x.dataset.n <= n)); Sound.play('click'); });
      UI.sheet({ title: 'Como correu?', left: 'Agora não', right: 'Enviar', body, onDone: () => {
        if (window.CC && CC.requireNet && !CC.requireNet('avaliar a entrega')) return false;
        /* rpcRaw e verificação: o servidor recusa avaliações repetidas e fora do prazo
           (Config.Eats.ratingWindow) e o telemóvel agradecia por uma avaliação que não ficou gravada */
        Bridge.rpcRaw('eats.rate', { id: o.id, stars: n, note: body.querySelector('.nt').value.trim() }).then(r => {
          if (!r || !r.ok) { Sound.play('error'); UI.toast(r && r.error === 'late' ? `Já passou o prazo de ${r.days} dias para avaliar` : 'Não consegui registar a avaliação'); return; }
          UI.toast('Obrigado!'); S.tabs.go(2); });
      } });
    }

    /* ---------- mini-mapa (mesma projeção da app Mapas) ---------- */
    function MiniMap() {
      const cfg = Object.assign({ tileUrl: 'https://www.gtamap.xyz/mapStyles/styleSatelite/{z}/{x}/{y}.jpg', tile: 256 }, (window.Maps && Maps.cfg) || {});
      const KX = 0.02072, KY = 0.0205, OX = 117.3, OY = 172.8, T = cfg.tile || 256, Z = 4;
      const k = Math.pow(2, Z);
      const proj = (x, y) => [(KX * x + OX) * k, (-KY * y + OY) * k];
      const el = UI.el(`<div class="ea-map"><div class="w"><svg class="rt" xmlns="http://www.w3.org/2000/svg"><path fill="none" stroke="#0A84FF" stroke-width="4" stroke-linecap="round"/></svg>
        <div class="pin rest">${g('bag2', 18)}</div><div class="pin dest">${g('home', 18)}</div><div class="pin cour">${g('car', 19)}</div></div></div>`);
      const w = el.querySelector('.w'), svg = el.querySelector('.rt'), path = svg.querySelector('path');
      const tiles = new Map();
      const pins = { rest: el.querySelector('.rest'), dest: el.querySelector('.dest'), cour: el.querySelector('.cour') };
      /* o SVG da rota cobre o mapa inteiro a este zoom (T·2^Z = 4096): tamanho constante, escreve-se uma vez
         e não a cada update */
      svg.setAttribute('viewBox', `0 0 ${T * k} ${T * k}`);
      svg.setAttribute('width', T * k); svg.setAttribute('height', T * k);

      const update = tr => {
        const pts = [];
        ['rest', 'dest', 'cour'].forEach(key => {
          const c = tr[key === 'cour' ? 'courier' : key];
          const p = pins[key];
          if (!c) { p.style.display = 'none'; return; }
          p.style.display = '';
          const [px, py] = proj(c.x, c.y);
          p.dataset.px = px; p.dataset.py = py;
          pts.push([px, py]);
        });
        if (!pts.length) return;
        /* enquadrar tudo o que interessa */
        const xs = pts.map(p => p[0]), ys = pts.map(p => p[1]);
        const minX = Math.min(...xs) - 90, maxX = Math.max(...xs) + 90, minY = Math.min(...ys) - 90, maxY = Math.max(...ys) + 90;
        const bw = maxX - minX, bh = maxY - minY;
        const VW = 408, VH = 232;
        const s = Math.min(VW / bw, VH / bh, 1.6);
        const cx = (minX + maxX) / 2, cy = (minY + maxY) / 2;
        w.style.transform = `translate(${VW / 2}px,${VH / 2}px) scale(${s.toFixed(3)}) translate(${(-cx).toFixed(1)}px,${(-cy).toFixed(1)}px)`;
        Object.keys(pins).forEach(key => { const p = pins[key]; if (p.style.display === 'none') return; p.style.left = p.dataset.px + 'px'; p.style.top = p.dataset.py + 'px'; p.style.transform = `translate(-50%,-50%) scale(${(1 / s).toFixed(3)})`; });

        const from = tr.courier || tr.rest, to = tr.dest;
        if (from && to) { const a = proj(from.x, from.y), b = proj(to.x, to.y); path.setAttribute('d', `M${a[0]} ${a[1]} L${b[0]} ${b[1]}`); path.style.strokeWidth = (4 / s).toFixed(2); }

        /* tiles à volta do enquadramento */
        const x0 = Math.max(0, Math.floor(minX / T) - 1), x1 = Math.floor(maxX / T) + 1;
        const y0 = Math.max(0, Math.floor(minY / T) - 1), y1 = Math.floor(maxY / T) + 1;
        const max = Math.pow(2, Z);
        for (let tx = x0; tx <= x1 && tx < max; tx++) for (let ty = y0; ty <= y1 && ty < max; ty++) {
          const key = tx + '_' + ty;
          if (tiles.has(key)) continue;
          const img = document.createElement('img');
          img.decoding = 'async'; img.draggable = false;
          img.src = cfg.tileUrl.replace('{z}', Z).replace('{x}', tx).replace('{y}', ty);
          img.style.left = (tx * T) + 'px'; img.style.top = (ty * T) + 'px';
          img.onerror = () => { img.style.display = 'none'; };
          w.insertBefore(img, svg);
          tiles.set(key, img);
        }
      };
      return { el, update };
    }

    /* =========================================================
       PEDIDOS
       ========================================================= */
    function ordersView() {
      const v = UI.view({ title: 'Pedidos', large: true, cls: 'ea' });
      const holder = UI.el('<div class="ea-list"></div>');
      v.content.appendChild(holder);
      holder.appendChild(UI.spinner());
      Bridge.rpc('eats.orders').then(list => {
        holder.innerHTML = '';
        list = list || [];
        if (!list.length) { holder.appendChild(UI.empty('receipt', 'Ainda sem pedidos', 'O teu primeiro pedido aparece aqui.')); return; }
        const live = list.filter(o => ['pending', 'accepted', 'ready', 'picked'].indexOf(o.status) > -1);
        const done = list.filter(o => live.indexOf(o) < 0);
        if (live.length) {
          holder.appendChild(UI.el('<div class="ea-h">A caminho</div>'));
          live.forEach(o => holder.appendChild(orderRow(o, true)));
        }
        if (done.length) {
          holder.appendChild(UI.el('<div class="ea-h">Anteriores</div>'));
          done.forEach(o => holder.appendChild(orderRow(o, false)));
        }
      });
      return v;
    }

    function orderRow(o, live) {
      const r = restOf(o.restaurant) || {};
      const st = { pending: 'À espera', accepted: 'A preparar', ready: 'Pronto', picked: 'A caminho', delivered: 'Entregue', cancelled: 'Cancelado' }[o.status] || o.status;
      const row = UI.el(`<div class="ea-order ${live ? 'live' : ''}"><div class="th">${art(r.glyph || o.glyph || 'bag2', r.art)}</div>
        <div class="bd"><b>${esc(o.restName || r.name || '')}</b>
          <div class="muted small">${(o.items || []).reduce((n, l) => n + l.qty, 0)} artigos · ${money(o.total)}</div>
          <div class="ea-ost ${o.status}">${esc(st)}${o.rating ? ` · ${'★'.repeat(o.rating)}` : ''}</div></div>
        <div class="ea-oact">${g('chevR', 21)}</div></div>`);
      row.onclick = () => {
        if (live) { UI.setRoot(win, trackView(o)); S.tabs.el.classList.add('hidden'); return; }
        detail(o);
      };
      return row;
    }

    function detail(o) {
      const r = restOf(o.restaurant) || {};
      const v = UI.view({ title: '', back: 'Pedidos', cls: 'ea' });
      v.content.appendChild(UI.el(`<div class="ea-odet"><div class="th">${art(r.glyph || 'bag2', r.art)}</div>
        <h2>${esc(o.restName || r.name || '')}</h2><div class="muted">Pedido #${o.id} · ${UI.rel(o.created)}</div></div>`));
      v.content.appendChild(UI.el(`<div class="group ea-sumbox">${(o.items || []).map(l => {
        const ot = (l.opts || []).map(x => x.name).join(', ');
        return `<div class="ea-srow"><span>${l.qty}× ${esc(l.name)}${ot ? `<br><span class="muted small">${esc(ot)}</span>` : ''}</span><b>${money(l.total || l.unit * l.qty)}</b></div>`;
      }).join('')}
        <div class="ea-srow"><span>Entrega</span><b>${o.fee > 0 ? money(o.fee) : 'Grátis'}</b></div>
        ${o.discount > 0 ? `<div class="ea-srow ok"><span>Desconto</span><b>−${money(o.discount)}</b></div>` : ''}
        ${o.tip > 0 ? `<div class="ea-srow"><span>Gorjeta</span><b>${money(o.tip)}</b></div>` : ''}
        <div class="ea-srow tot"><span>Total</span><b>${money(o.total)}</b></div></div>`));
      const again = UI.el('<div class="btn-p">Pedir outra vez</div>');
      again.onclick = () => {
        S.cart = { rest: o.restaurant, lines: (o.items || []).map(l => ({ sig: l.id + JSON.stringify(l.opts || {}) + (l.note || ''), id: l.id, name: l.name, qty: l.qty, unit: l.unit, opts: (l.opts || []).reduce((a, x) => { (a[x.g] = a[x.g] || []).push(x.id); return a; }, {}), note: l.note || '', glyph: r.glyph, art: r.art })) };
        saveCart(); paintBar(); UI.pop(win); openCart();
      };
      v.content.appendChild(again);
      if (o.status === 'delivered' && !o.rating) {
        const b = UI.el('<div class="btn-p btn-s">Avaliar</div>');
        b.onclick = () => rate(o);
        v.content.appendChild(b);
      }
      UI.push(win, v);
    }

    /* =========================================================
       CONTA + MODO ESTAFETA
       ========================================================= */
    function accountView() {
      const v = UI.view({ title: 'Conta', large: true, cls: 'ea' });
      const p = System.player || {};
      const holder = UI.el('<div></div>');
      v.content.appendChild(holder);

      const paint = async () => {
        const st = await Bridge.rpc('eats.courier.stats') || {};
        const pro = (S.home && S.home.pro) || {};
        holder.innerHTML = '';
        holder.appendChild(UI.el(`<div class="ea-me">${UI.avatar({ name: (p.firstname || '') + ' ' + (p.lastname || '') }, 'lg')}<div><b>${esc((p.firstname || '') + ' ' + (p.lastname || ''))}</b><span class="muted">${esc(UI.phone(p.phone || ''))}</span></div></div>`));

        holder.appendChild(UI.list([{ header: 'Eats Pro', items: [
          pro.active
            ? { icon: 'sparkles', iconBg: '#30D158', label: 'Eats Pro ativo', sub: 'Entregas grátis', value: pro.until_ ? UI.fmtDate(new Date(pro.until_), true) : '', chevron: false }
            : { icon: 'sparkles', iconBg: '#FF9F0A', label: 'Aderir ao Eats Pro', sub: `Entregas grátis · ${money(pro.price || 0)}`, onTap: () => buyPro() },
        ] }]));

        holder.appendChild(UI.list([{ header: 'Entregas', items: [
          { icon: 'pin', iconBg: '#0A84FF', label: 'Moradas guardadas', onTap: () => addressList() },
          { icon: 'heart', iconBg: '#FF375F', label: 'Preferidos', onTap: () => { curCat = 'all'; S.tabs.go(0); } },
          { icon: 'tag', iconBg: '#FF9F0A', label: 'Promoções', onTap: () => promoList() },
        ] }]));

        holder.appendChild(UI.list([{ header: 'Trabalhar', footer: 'Com o modo ligado recebes pedidos perto de ti. Ganhas parte da taxa de entrega mais a gorjeta.', items: [
          { icon: 'car', iconBg: '#5E5CE6', label: 'Modo estafeta', toggle: S.courierOn, onToggle: async on => {
            if (window.CC && CC.requireNet && !CC.requireNet('mudar o modo estafeta')) { paint(); return; }
            const r = await Bridge.rpcRaw('eats.courier.toggle', { on });
            if (r && r.error === 'job') { UI.alert({ title: 'Precisas do emprego', msg: `Só quem tem o emprego "${r.job}" pode entregar.` }); paint(); return; }
            S.courierOn = !!(r && r.on); if (S.courierOn) { Sound.play('success'); courierView(); }
          } },
          { icon: 'briefcase', label: 'Entregas feitas', value: String(st.deliveries || 0), chevron: false },
          { icon: 'dollar', label: 'Ganho total', value: money(st.earnings || 0), chevron: false },
          st.rating ? { icon: 'star', label: 'Avaliação', value: `${st.rating} (${st.ratings})`, chevron: false } : null,
          { icon: 'list', iconBg: '#8E8E93', label: 'Painel do estafeta', onTap: () => courierView() },
        ].filter(Boolean) }]));

        if (p.job && (S.home.restaurants || []).some(r => r.job && r.job === p.job.name)) {
          holder.appendChild(UI.list([{ header: 'Restaurante', items: [{ icon: 'bag2', iconBg: '#FF9F0A', label: 'Pedidos na cozinha', onTap: () => kitchenView() }] }]));
        }
      };
      paint();
      return v;
    }

    async function buyPro() {
      const pro = (S.home && S.home.pro) || {};
      if (window.CC && CC.requireNet && !CC.requireNet('aderir ao Eats Pro')) return;
      if (!await UI.confirm('Eats Pro', `Entregas grátis durante ${pro.days || 30} dias por ${money(pro.price || 0)}. O valor sai da conta bancária.`, 'Aderir')) return;
      const r = await Bridge.rpcRaw('eats.pro');
      if (r && r.ok) { Sound.play('success'); UI.toast('Eats Pro ativo'); S.home.pro.active = true; S.home.pro.until_ = r.until_; S.tabs.refresh(); }
      else UI.alert({ title: 'Não foi possível', msg: r && r.error === 'funds' ? 'Saldo insuficiente.' : 'Tenta mais tarde.' });
    }

    async function pickAddress(after) {
      const list = await Bridge.rpc('eats.addresses') || [];
      const btns = [{ label: 'Onde estou agora', value: '__here' }].concat(list.map(a => ({ label: a.label, value: String(a.id) })), [{ label: 'Guardar esta posição…', value: '__new' }]);
      const r = await UI.actionSheet({ title: 'Entregar em', buttons: btns });
      if (!r) return;
      if (r === '__here') { S.addr = null; }
      else if (r === '__new') {
        const label = await UI.prompt('Nova morada', 'Guarda a posição onde estás agora.', 'Casa');
        if (!label) return;
        const res = await Bridge.rpcRaw('eats.address.add', { label });
        if (res && res.ok) { S.addr = { label, x: res.x, y: res.y }; UI.toast('Morada guardada'); }
        else UI.toast('Não foi possível guardar');
      } else {
        const a = list.find(x => String(x.id) === r);
        if (a) S.addr = { label: a.label, x: a.x, y: a.y };
      }
      if (after) after(); else S.tabs.refresh();
    }

    async function addressList() {
      const v = UI.view({ title: 'Moradas', back: 'Conta', cls: 'ea', right: [{ icon: 'plus', cls: 'glass', onTap: async () => {
        const label = await UI.prompt('Nova morada', 'Guarda a posição onde estás agora.', 'Casa');
        if (!label) return;
        const r = await Bridge.rpcRaw('eats.address.add', { label });
        if (r && r.ok) { UI.toast('Guardada'); load(); } else UI.toast(r && r.error === 'toomany' ? 'Máximo de 12' : 'Falhou');
      } }] });
      const holder = UI.el('<div></div>');
      v.content.appendChild(holder);
      const load = async () => {
        const list = await Bridge.rpc('eats.addresses') || [];
        holder.innerHTML = '';
        if (!list.length) { holder.appendChild(UI.empty('pin', 'Sem moradas', 'Guarda os sítios onde costumas estar.')); return; }
        holder.appendChild(UI.list([{ items: list.map(a => ({
          icon: 'pin', iconBg: '#0A84FF', label: a.label, sub: a.note || `${Math.round(a.x)}, ${Math.round(a.y)}`,
          onTap: () => { S.addr = { label: a.label, x: a.x, y: a.y }; UI.toast('Selecionada'); },
          onLong: async () => { if (await UI.confirm('Apagar morada', a.label, 'Apagar', true)) { await Bridge.rpc('eats.address.del', { id: a.id }); load(); } },
        })) }]));
      };
      load();
      UI.push(win, v);
    }

    function promoList() {
      const v = UI.view({ title: 'Promoções', back: 'Conta', cls: 'ea' });
      const list = ((S.home && S.home.promosList) || []);
      v.content.appendChild(UI.el('<div class="ea-h">Códigos</div>'));
      v.content.appendChild(UI.el(`<div class="group ea-sumbox"><div class="ea-srow"><span>BEMVINDO</span><b>−20%</b></div>
        <div class="ea-srow"><span>EATS5</span><b>−${UI.money(5)}</b></div>
        <div class="ea-srow"><span>SEMTAXA</span><b>Entrega grátis</b></div>
        <div class="ea-srow"><span>LATENIGHT</span><b>−15%</b></div></div>`));
      v.content.appendChild(UI.el('<div class="group-footer">Escreve o código no carrinho, antes de fechar o pedido. Cada código tem um número limitado de utilizações por pessoa.</div>'));
      UI.push(win, v);
    }

    /* ---------- painel do estafeta ---------- */
    function courierView() {
      const v = UI.view({ title: 'Estafeta', back: 'Conta', cls: 'ea' });
      const holder = UI.el('<div></div>');
      v.content.appendChild(holder);
      let timer = null;
      v.opts.onPop = () => clearInterval(timer);

      /* o poll de 8 s reconstruía o painel inteiro mesmo sem nada novo - e trocava os botões debaixo do
         dedo (um toque em "Aceitar" a meio da troca perdia-se). Um tick do poll sem mudanças não pinta;
         quem chama load() depois de uma ação (toggle, aceitar, levantar) pinta sempre. */
      let lastKey = '';
      const load = async fromPoll => {
        const d = await Bridge.rpc('eats.courier.jobs') || { mine: [], offers: [], on: false };
        S.courierOn = !!d.on;
        const key = JSON.stringify(d);
        if (fromPoll === true && key === lastKey) return;
        lastKey = key;
        holder.innerHTML = '';
        holder.appendChild(UI.list([{ items: [{ icon: 'car', iconBg: S.courierOn ? '#30D158' : '#8E8E93', label: 'Estou online', toggle: S.courierOn, onToggle: async on => {
          if (window.CC && CC.requireNet && !CC.requireNet('ficar online')) { load(); return; }
          const r = await Bridge.rpcRaw('eats.courier.toggle', { on });
          if (r && r.error === 'job') { UI.alert({ title: 'Precisas do emprego', msg: `Só quem tem o emprego "${r.job}" pode entregar.` }); }
          load();
        } }] }]));

        (d.mine || []).forEach(o => {
          const next = o.status === 'ready' ? 'Levantei o pedido' : o.status === 'picked' ? 'Entreguei' : null;
          const c = UI.el(`<div class="ea-job"><div class="jh"><b>${esc(o.restName || '')}</b><span class="ea-ost ${o.status}">${o.status === 'accepted' ? 'A preparar' : o.status === 'ready' ? 'Pronto' : 'A caminho'}</span></div>
            <div class="muted small">${(o.items || []).reduce((n, l) => n + l.qty, 0)} artigos · entregar em ${esc(o.addr && o.addr.label || '')}</div>
            <div class="jb"><div class="btn-p btn-s gps">${g('nav', 21)} GPS</div>${next ? `<div class="btn-p btn-s ok">${esc(next)}</div>` : ''}</div></div>`);
          c.querySelector('.gps').onclick = () => {
            const t = o.status === 'picked' ? o.addr : (restOf(o.restaurant) || {}).coords;
            const x = o.status === 'picked' ? o.addr.x : (t || {}).x, y = o.status === 'picked' ? o.addr.y : (t || {}).y;
            if (x != null) { Bridge.call('setWaypoint', { x, y, name: o.status === 'picked' ? 'Entrega' : o.restName }); UI.toast('GPS marcado'); }
          };
          const okb = c.querySelector('.ok');
          if (okb) okb.onclick = async () => {
            if (window.CC && CC.requireNet && !CC.requireNet(o.status === 'ready' ? 'levantar o pedido' : 'entregar o pedido')) return;
            const r = await Bridge.rpcRaw(o.status === 'ready' ? 'eats.courier.pickup' : 'eats.courier.deliver', { id: o.id });
            /* o `earned` é o que o servidor CONSEGUIU pagar e pode ser 0 (pagamento recusado, ou entrega
               grátis sem gorjeta): «Ganhaste 0,00 €» chegava ao mesmo tempo que o aviso do servidor a
               dizer que não deu. O 'Entregue' não promete nada - o porquê vem na notificação. */
            if (r && r.ok) { Sound.play('success'); UI.toast(r.earned == null ? 'Levantado' : r.earned > 0 ? `Ganhaste ${money(r.earned)}` : 'Entregue'); load(); }
            else UI.toast(r && r.error === 'far' ? 'Estás longe demais' : r && r.error === 'notready' ? 'Ainda não está pronto' : 'Não deu');
          };
          holder.appendChild(c);
        });

        if (d.offers && d.offers.length) {
          holder.appendChild(UI.el('<div class="ea-h">Ofertas perto de ti</div>'));
          d.offers.forEach(o => holder.appendChild(offerCard(o, load)));
        } else if (!(d.mine || []).length) {
          holder.appendChild(UI.empty('car', S.courierOn ? 'À espera de pedidos' : 'Estás offline', S.courierOn ? 'Vais ser avisado quando houver um perto.' : 'Liga o modo estafeta para receber ofertas.'));
        }
      };
      load();
      timer = poll(holder, () => load(true), 8000);
      /* o push eats:job (comida pronta, cancelado) pinta já, sem esperar pelos 8 s do poll */
      const offR = Bridge.on('eats:refresh', () => { if (holder.isConnected) load(true); }); const prevPop = v.opts.onPop; v.opts.onPop = () => { offR(); prevPop && prevPop(); };
      UI.push(win, v);
    }

    function offerCard(o, done) {
      const c = UI.el(`<div class="ea-offer"><div class="oh"><b>${esc(o.restName || '')}</b><span class="pay">${money(o.pay)}</span></div>
        <div class="muted small">${o.items} artigos · entregar em ${esc((o.addr && o.addr.label) || '')}</div>
        <div class="btn-p btn-s acc">Aceitar entrega</div></div>`);
      c.querySelector('.acc').onclick = async () => {
        if (window.CC && CC.requireNet && !CC.requireNet('aceitar a entrega')) return;
        const r = await Bridge.rpcRaw('eats.courier.accept', { id: o.id });
        if (r && r.ok) {
          Sound.play('success'); UI.toast('Entrega tua!');
          if (r.rest) Bridge.call('setWaypoint', { x: r.rest.x, y: r.rest.y, name: o.restName });
        } else UI.toast(r && r.error === 'taken' ? 'Outro estafeta foi mais rápido' : r && r.error === 'busy' ? 'Já tens uma entrega' : 'Não deu');
        done && done();
      };
      return c;
    }

    /* ---------- cozinha (restaurante de jogadores) ---------- */
    function kitchenView() {
      const v = UI.view({ title: 'Cozinha', back: 'Conta', cls: 'ea' });
      const holder = UI.el('<div></div>');
      v.content.appendChild(holder);
      let timer = null;
      v.opts.onPop = () => clearInterval(timer);
      let lastKey = '';   /* mesma regra do painel do estafeta: um tick do poll sem pedidos novos não reconstrói nada */
      const load = async fromPoll => {
        const list = await Bridge.rpc('eats.kitchen') || [];
        const key = JSON.stringify(list);
        if (fromPoll === true && key === lastKey) return;
        lastKey = key;
        holder.innerHTML = '';
        if (!list.length) { holder.appendChild(UI.empty('bag2', 'Sem pedidos', 'Os pedidos novos aparecem aqui.')); return; }
        list.forEach(o => {
          const c = UI.el(`<div class="ea-job"><div class="jh"><b>#${o.id}</b><span class="ea-ost ${o.status}">${o.status === 'accepted' ? 'A preparar' : o.status === 'ready' ? 'Pronto' : 'A caminho'}</span></div>
            ${(o.items || []).map(l => `<div class="ea-srow"><span>${l.qty}× ${esc(l.name)}${(l.opts || []).length ? `<br><span class="muted small">${esc((l.opts || []).map(x => x.name).join(', '))}</span>` : ''}</span></div>`).join('')}
            ${o.note ? `<div class="muted small">“${esc(o.note)}”</div>` : ''}
            ${o.status === 'accepted' ? '<div class="btn-p btn-s ok">Marcar como pronto</div>' : ''}</div>`);
          const b = c.querySelector('.ok');
          if (b) b.onclick = async () => { if (window.CC && CC.requireNet && !CC.requireNet('marcar como pronto')) return; const r = await Bridge.rpc('eats.kitchen.ready', { id: o.id }); if (r && r.ok) { Sound.play('success'); load(); } };
          holder.appendChild(c);
        });
      };
      load();
      timer = poll(holder, () => load(true), 6000);
      /* o push eats:kitchen (pedido novo) pinta já */
      const offR = Bridge.on('eats:refresh', () => { if (holder.isConnected) load(true); }); const prevPop = v.opts.onPop; v.opts.onPop = () => { offR(); prevPop && prevPop(); };
      UI.push(win, v);
    }

    /* =========================================================
       arranque
       ========================================================= */
    S.tabs = UI.tabbar(win, [
      { icon: 'bag2', label: 'Início', view: homeView },
      { icon: 'search', label: 'Pesquisar', view: searchView },
      { icon: 'receipt', label: 'Pedidos', view: ordersView },
      { icon: 'person', label: 'Conta', view: accountView },
    ], 0);

    const offGoto = Bridge.on('eats:goto', i => S.tabs.go(i));
    /* A janela da Eats fica guardada (LRU) depois de fechada e estes ouvintes continuavam vivos: com a app fechada
       respondiam JUNTO com os globais do fim do ficheiro - duas notificações e três sons por cada oferta/atualização.
       Aqui só se trata o caso da Eats estar à frente; com ela fechada ficam os globais. O Notify já toca o som. */
    const offOffer = Bridge.on('eats:offer', o => {
      if (!o || System.currentApp() !== 'eats') return;
      Notify.push({ app: 'eats', title: 'Entrega disponível', msg: `${o.restName} · ${money(o.pay)}`, onTap: () => { System.openApp('eats'); setTimeout(() => courierView(), 350); } });
    });
    const offUpd = Bridge.on('eats:update', o => {
      if (!o || System.currentApp() !== 'eats') return;
      const t = { accepted: 'Pedido aceite', ready: 'Comida pronta', picked: 'A caminho', delivered: 'Entregue' }[o.status];
      if (t) Notify.push({ app: 'eats', title: t, msg: o.restName || '', onTap: () => { System.openApp('eats'); setTimeout(() => { UI.setRoot(win, trackView(o)); S.tabs.el.classList.add('hidden'); }, 350); } });
    });
    win.onClose = () => { offGoto(); offOffer(); offUpd(); };
    paintBar();
  },
});

/* notificações com a app fechada */
Bridge.on('eats:offer', d => { if (!d) return; if (System.currentApp && System.currentApp() === 'eats') return; Notify.push({ app: 'eats', title: 'Entrega disponível', msg: (d.restName || '') + ' · ' + UI.money(d.pay || 0), onTap: () => System.openApp('eats') }); });
Bridge.on('eats:update', d => { if (!d) return; if (System.currentApp && System.currentApp() === 'eats') return; const t = { accepted: 'Pedido aceite', ready: 'Comida pronta', picked: 'A tua comida vem a caminho', delivered: 'Pedido entregue' }[d.status]; if (t) Notify.push({ app: 'eats', title: t, msg: d.restName || '', onTap: () => System.openApp('eats') }); });
/* Dois pushes do server/eats.lua que NÃO tinham ouvinte (auditoria 2026-09-17): o estafeta (jogador) não sabia que a comida
   ficou pronta ou que o pedido foi cancelado, e um restaurante de jogadores (Config.Eats restaurants[].job) não sabia que entrou
   um pedido. Ficam como notificações; a app, se estiver aberta, ouve 'eats:refresh' para repintar o que mostra. */
Bridge.on('eats:job', d => { if (!d) return; const t = { ready: 'Pedido pronto para recolha', cancelled: 'Entrega cancelada', delivered: 'Entrega concluída', picked: 'Entrega a caminho' }[d.status]; if (t) Notify.push({ app: 'eats', title: t, msg: (d.restName || '') + (d.addr && d.addr.label ? ' → ' + d.addr.label : ''), onTap: () => System.openApp('eats') }); Bridge.emit('eats:refresh', d); });
Bridge.on('eats:kitchen', d => { if (!d) return; Notify.push({ app: 'eats', title: 'Novo pedido na cozinha', msg: `${d.restName || ''} · ${UI.money(d.total || 0)}${d.items && d.items.length ? ' · ' + d.items.length + ' artigo' + (d.items.length === 1 ? '' : 's') : ''}`, onTap: () => System.openApp('eats') }); Bridge.emit('eats:refresh', d); });

/* ---------- fallback do browser (harness) ---------- */
if (window.LocalDB && LocalDB.register) (() => {
  const REST = [
    { id: 'burgershot', name: 'Burger Shot', tagline: 'Hambúrgueres · Fast food', cats: ['burger'], rating: 4.5, votes: 1284, time: [20, 35], fee: 2.49, min: 8, art: ['#FF375F', '#B3122F'], glyph: 'burger', open: true, fav: false, coords: { x: -1183.9, y: -885.9 }, promo: '2.º hambúrguer a -20%' },
    { id: 'pizzathis', name: 'Pizza This...', tagline: 'Pizza · Italiano', cats: ['pizza', 'italian'], rating: 4.4, votes: 1607, time: [30, 45], fee: 2.2, min: 10, art: ['#E23E3E', '#7A1414'], glyph: 'pizza', open: true, fav: true, coords: { x: 806.6, y: -752.3 } },
    { id: 'sakura', name: 'Sakura Sushi', tagline: 'Sushi · Japonês', cats: ['sushi', 'asian'], rating: 4.8, votes: 655, time: [35, 55], fee: 3.49, min: 15, art: ['#E8899B', '#8A3348'], glyph: 'sushi', open: true, fav: false, coords: { x: -1285, y: -1116 } },
    { id: 'beanmachine', name: 'Bean Machine', tagline: 'Café · Pastelaria', cats: ['coffee', 'dessert'], rating: 4.3, votes: 2043, time: [10, 20], fee: 1.49, min: 4, art: ['#8A6244', '#3E2A1B'], glyph: 'coffee', open: true, fav: false, coords: { x: -629.9, y: 233.2 } },
  ];
  const CATS = [{ id: 'all', label: 'Tudo', glyph: 'bag2' }, { id: 'burger', label: 'Hambúrgueres', glyph: 'burger' }, { id: 'pizza', label: 'Pizza', glyph: 'pizza' }, { id: 'sushi', label: 'Sushi', glyph: 'sushi' }, { id: 'coffee', label: 'Café', glyph: 'coffee' }];
  const MENU = {
    burgershot: [{ name: 'Populares', items: [
      { id: 'bs_bleeder', name: 'Bleeder', desc: 'Carne grelhada, cheddar, alface e molho da casa.', price: 9.9, kcal: 760, art: ['#C9762F', '#7A3E12'], glyph: 'burger', tag: 'popular',
        options: [{ id: 'size', name: 'Tamanho', min: 1, max: 1, choices: [{ id: 'reg', name: 'Normal', price: 0 }, { id: 'menu', name: 'Menu (batatas + bebida)', price: 3.9 }] },
                  { id: 'extra', name: 'Extras', min: 0, max: 4, choices: [{ id: 'bacon', name: 'Bacon', price: 1.2 }, { id: 'cheese', name: 'Queijo extra', price: 0.8 }] }] },
      { id: 'bs_fries', name: 'Batatas fritas', desc: 'Corte grosso, com sal.', price: 3.5, kcal: 380, art: ['#E9B949', '#B07D14'], glyph: 'fries' },
      { id: 'bs_cola', name: 'Cola', desc: 'Lata 33 cl.', price: 2.2, kcal: 140, art: ['#8B2027', '#3A0A0E'], glyph: 'drink' }] }],
    pizzathis: [{ name: 'Pizzas', items: [{ id: 'pz_marg', name: 'Margherita', desc: 'Tomate, mozzarella e manjericão.', price: 9.9, kcal: 980, art: ['#E05C3E', '#8A2417'], glyph: 'pizza', tag: 'popular' }] }],
    sakura: [{ name: 'Combinados', items: [{ id: 'sk_c20', name: 'Combinado 20 peças', desc: 'Nigiri, maki e california.', price: 24.9, kcal: 980, art: ['#E8899B', '#8A3348'], glyph: 'sushi' }] }],
    beanmachine: [{ name: 'Cafés', items: [{ id: 'bm_latte', name: 'Latte', desc: 'Leite vaporizado com arte no topo.', price: 3.4, kcal: 190, art: ['#B08968', '#6B4A2A'], glyph: 'coffee', tag: 'popular' }] }],
  };
  const T = () => LocalDB.T('eats_orders');
  const find = id => REST.find(r => r.id === id);
  const price = (id, cart) => { let s = 0; const lines = []; (cart || []).forEach(c => { let d; (MENU[id] || []).forEach(sec => sec.items.forEach(i => { if (i.id === c.id) d = i; })); if (!d) return; let u = d.price; (d.options || []).forEach(gr => ((c.opts || {})[gr.id] || []).forEach(cid => { const ch = gr.choices.find(x => x.id === cid); if (ch) u += ch.price; })); u = Math.round(u * 100) / 100; s += u * c.qty; lines.push({ id: d.id, name: d.name, qty: c.qty, unit: u, total: Math.round(u * c.qty * 100) / 100, opts: [] }); }); return { lines, subtotal: Math.round(s * 100) / 100 }; };

  LocalDB.register('eats.home', () => ({ restaurants: REST, categories: CATS, fees: { service: 0.99, tips: [0, 1, 2, 5], pay: ['card', 'cash'] }, pro: { active: false, price: 24.99, days: 30 }, courier: { on: false, cut: 70 }, stats: { deliveries: 3, earnings: 41.2 } }));
  LocalDB.register('eats.menu', d => { const r = find(d.id); return r ? Object.assign({}, r, { menu: MENU[d.id] || [], hours: [0, 24] }) : null; });
  LocalDB.register('eats.search', d => { const q = (d.q || '').toLowerCase(); if (!q) return { restaurants: [], dishes: [] };
    const rs = REST.filter(r => (r.name + ' ' + (r.tagline || '')).toLowerCase().includes(q));
    const ds = []; Object.keys(MENU).forEach(rid => (MENU[rid] || []).forEach(sec => sec.items.forEach(it => { if ((it.name + ' ' + (it.desc || '')).toLowerCase().includes(q)) ds.push(Object.assign({}, it, { rest: rid, restName: (find(rid) || {}).name, open: true })); })));
    return { restaurants: rs, dishes: ds }; });
  LocalDB.register('eats.quote', d => { const p = price(d.id, d.cart); const r = find(d.id) || {}; const fee = r.fee || 0, small = p.subtotal < 12 ? 1.99 : 0, service = 0.99, tip = +d.tip || 0; return Object.assign(p, { fee, smallfee: small, service, tip, discount: 0, total: Math.round((p.subtotal + fee + small + service + tip) * 100) / 100, pro: false }); });
  LocalDB.register('eats.order', d => { const q = LocalDB.rpc('eats.quote', d); const id = T().insert({ restaurant: d.id, restName: (find(d.id) || {}).name, items: q.lines, total: q.total, fee: q.fee, tip: q.tip, discount: 0, status: 'pending', created: Date.now(), courier: null }); return { ok: true, order: Object.assign({ id }, T().all().find(o => o.id === id)) }; });
  LocalDB.register('eats.orders', () => T().all().sort((a, b) => b.created - a.created));
  LocalDB.register('eats.order.get', d => { const o = T().all().find(x => x.id === d.id); if (o && o.status !== 'delivered') { const age = (Date.now() - o.created) / 1000; const st = age > 60 ? 'delivered' : age > 40 ? 'picked' : age > 20 ? 'ready' : age > 8 ? 'accepted' : 'pending'; if (st !== o.status) T().update(o.id, { status: st, courier: 'Rui Marques', courierNpc: true }); return T().all().find(x => x.id === d.id); } return o || null; });
  LocalDB.register('eats.track', d => { const o = T().all().find(x => x.id === d.id); if (!o) return null; const r = find(o.restaurant) || {}; return { status: o.status, rest: r.coords, dest: { x: 195, y: -934 }, courier: o.status === 'picked' ? { x: (r.coords.x + 195) / 2, y: (r.coords.y - 934) / 2 } : r.coords, eta: 480, npc: true }; });
  LocalDB.register('eats.cancel', d => { T().update(d.id, { status: 'cancelled' }); return { ok: true, refund: 0 }; });
  LocalDB.register('eats.rate', d => { T().update(d.id, { rating: d.stars }); return { ok: true }; });
  LocalDB.register('eats.fav', d => { const r = find(d.id); if (r) r.fav = !r.fav; return { ok: true, fav: r && r.fav }; });
  LocalDB.register('eats.addresses', () => [{ id: 1, label: 'Casa', x: 195, y: -934 }, { id: 2, label: 'Trabalho', x: 428, y: -981 }]);
  LocalDB.register('eats.address.add', d => ({ ok: true, id: 3, x: 195, y: -934 }));
  LocalDB.register('eats.address.del', () => ({ ok: true }));
  LocalDB.register('eats.pro', () => ({ ok: true, until_: Date.now() + 30 * 864e5 }));
  LocalDB.register('eats.courier.toggle', d => ({ ok: true, on: !!d.on }));
  LocalDB.register('eats.courier.jobs', () => ({ mine: [], offers: [{ id: 99, restName: 'Burger Shot', restCoords: { x: -1183, y: -885 }, addr: { label: 'Legion Square', x: 195, y: -934 }, items: 3, pay: 4.2 }], on: true }));
  LocalDB.register('eats.courier.accept', () => ({ ok: true, rest: { x: -1183, y: -885 } }));
  LocalDB.register('eats.courier.pickup', () => ({ ok: true }));
  LocalDB.register('eats.courier.deliver', () => ({ ok: true, earned: 4.2 }));
  LocalDB.register('eats.courier.stats', () => ({ deliveries: 3, earnings: 41.2, rating: 4.8, ratings: 3 }));
  LocalDB.register('eats.kitchen', () => []);
  LocalDB.register('eats.kitchen.ready', () => ({ ok: true }));
})();
