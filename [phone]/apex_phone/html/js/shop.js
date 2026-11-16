/* ============================================================
   SHOP - loja de telemóveis (ex-apex_phoneshop), 2026-10-03; JANELA de vidro por cima do jogo desde 11 nov 2026
   Linguagem do Apex Inventory (css/ovkit.css, peças .ovk-*): uma janela centrada (desenho a 1920×1080, cerca de
   1480×840, escalada com `zoom` pelo fit()), com o jogo visível à volta. Cores da marca e do fundo vêm do painel
   (OvTheme escreve os --k-* em body .xs-root): nada aqui tem cores da marca escritas à mão.
   Cabeçalho: insígnia, nome da loja, "Loja aberta" + produtos, carteira em células e fechar (ESC).
   Corpo: fichas de categoria; catálogo em mosaicos num tabuleiro (esquerda); palco 3D com cantos grandes, luz da
   marca e anel no chão, cores em mosaicos pequenos e as teclas (centro); ficha do produto com especificações,
   destaques, nota de uso e o pé fixo com o preço, o pagamento e o botão de compra (direita).
   Abre pelo Lua: OverlayOpen('shop', 'shop:open', { shop, catalog, state, admin, centered }) (client/shop.lua).
   Catálogo novo com a loja aberta: push 'shop:catalog' { catalog, shop }.
   Pedidos: Overlay.rpc('shop.buy', { item, account }) e Overlay.rpc('shop.refresh') (o client/shop.lua junta a
   loja aberta e vai ao servidor). Fora do FiveM: Overlay.mock.
   Comprar: manter premido ~0,8 s (o botão enche por transform) ou Enter duas vezes.
   Teclas: ← → produto, ↑ ↓ cor, Enter comprar, ESC fechar (o Overlay avisa o Lua).
   O DOM constrói-se UMA vez (esqueleto) e uma vez por catálogo (fichas, mosaicos, pagamento, carteira); trocar
   de produto, cor ou categoria só muda textos e classes no sítio.
   Textos do config (slogan, destaques, cores, categorias) são nós de texto normais: o tradutor do DOM (i18n.js)
   trata deles. Nomes de produtos, marcas, lojas e valores vão em data-noi18n.
   Sem campo de pesquisa: a loja abre com keep input (voz), e o que se escrevesse chegava ao jogo.
   API: window.Shop = { open(payload), close(), update(catalog, shop), state }
   ============================================================ */
(function () {
  'use strict';

  const HOLD_MS = 800, CONFIRM_MS = 4000, DONE_MS = 2600, MAX_FEATS = 8, MAX_SW = 8, MAX_SPECS = 6;
  const MIN_SLOTS = 8, MAX_DOTS = 4, MANY_SW = 4, ENTER_MS = 420, LEAVE_MS = 170;
  const NNBSP = ' ', NBSP = ' ';
  const SPEC_ORDER = ['screen', 'camera', 'chip', 'battery', 'audio'];
  const SPEC_LABEL = { screen: 'Ecrã', camera: 'Câmara', chip: 'Processador', battery: 'Bateria', audio: 'Áudio', network: 'Rede', lines: 'Números' };
  const ACC_LABEL = { bank: 'Banco', cash: 'Dinheiro' };
  const CAT_ICON = { grid: 'grid', pear: 'pear', nova: 'nova', fold: 'foldOut', buds: 'buds', sim: 'sim' };

  /* ícones (traço, 24×24) */
  const P = {
    x: '<path d="M6.5 6.5l11 11M17.5 6.5l-11 11"/>',
    phone: '<rect x="6.5" y="2.5" width="11" height="19" rx="2.6"/><path d="M10.6 18.2h2.8"/>',
    shield: '<path d="M12 3.5l7 2.6v5.4c0 4.3-2.9 7.6-7 9-4.1-1.4-7-4.7-7-9V6.1z"/>',
    bank: '<path d="M3.5 9.5L12 4.5l8.5 5"/><path d="M5.5 10.5v7M9.8 10.5v7M14.2 10.5v7M18.5 10.5v7"/><path d="M3.5 19.5h17"/>',
    cash: '<rect x="3" y="6.5" width="18" height="11" rx="2.2"/><circle cx="12" cy="12" r="2.5"/><path d="M6.5 9.6v.01M17.5 14.4v.01"/>',
    check: '<path d="M5 12.5l4.3 4.3L19 7.2"/>',
    bag: '<path d="M5.8 8.5h12.4l-.9 11.5H6.7z"/><path d="M9 8.5V7a3 3 0 016 0v1.5"/>',
    foldIn: '<rect x="4" y="5" width="7.5" height="14" rx="1.6"/><path d="M14.5 7.2l5-1.7v13l-5-1.7z"/>',
    foldOut: '<rect x="3" y="5" width="8.2" height="14" rx="1.6"/><rect x="12.8" y="5" width="8.2" height="14" rx="1.6"/>',
    caseOpen: '<path d="M5 11.5h14v4a4.5 4.5 0 01-4.5 4.5h-5A4.5 4.5 0 015 15.5z"/><path d="M5.2 9.2l12.6-4.8"/>',
    caseClose: '<path d="M5 9h14v6.5a4.5 4.5 0 01-4.5 4.5h-5A4.5 4.5 0 015 15.5z"/><path d="M5 12.2h14"/>',
    reset: '<path d="M4.8 12.5a7.3 7.3 0 107.2-8H8.5"/><path d="M10.6 2.2L8 4.5l2.6 2.4"/>',
    info: '<circle cx="12" cy="12" r="8.6"/><path d="M12 11v5.2M12 7.9v.01"/>',
    left: '<path d="M14.5 6l-6 6 6 6"/>',
    right: '<path d="M9.5 6l6 6-6 6"/>',
    grid: '<rect x="4.5" y="4.5" width="6" height="6" rx="1.4"/><rect x="13.5" y="4.5" width="6" height="6" rx="1.4"/><rect x="4.5" y="13.5" width="6" height="6" rx="1.4"/><rect x="13.5" y="13.5" width="6" height="6" rx="1.4"/>',
    pear: '<path d="M12 7.6c-2.2 0-3.1 1.9-3.1 3.6 0 1.8-2.5 2.9-2.5 5.8 0 2.6 2.5 4.3 5.6 4.3s5.6-1.7 5.6-4.3c0-2.9-2.5-4-2.5-5.8 0-1.7-.9-3.6-3.1-3.6z"/><path d="M12 7.6V4.2"/><path d="M12.4 5.2c1.1-1.3 2.7-1.6 4-1.2-.6 1.4-2.2 2.1-3.7 1.8"/>',
    nova: '<rect x="6.5" y="2.5" width="11" height="19" rx="2.6"/><circle cx="12" cy="5.9" r=".7"/>',
    buds: '<circle cx="8" cy="8" r="3.2"/><path d="M9.7 10.7v8.3"/><circle cx="16" cy="8" r="3.2"/><path d="M14.3 10.7v8.3"/>',
    sim: '<path d="M7.5 3h6.6l4.4 4.4v12.1a1.5 1.5 0 01-1.5 1.5h-9.5A1.5 1.5 0 016 19.5v-15A1.5 1.5 0 017.5 3z"/><rect x="9" y="11" width="6" height="6.5" rx="1"/><path d="M12 11v6.5M9 14.2h6"/>',
  };
  const ico = (k, cls) => `<svg class="xs-i${cls ? ' ' + cls : ''}" viewBox="0 0 24 24" aria-hidden="true">${P[k] || P.grid}</svg>`;

  const S = {
    built: false, open: false, closing: false, catalog: null, catKey: '', byId: {}, shop: {}, admin: false,
    state: { wallet: {}, owned: {}, available: {}, framework: true },
    cat: 'all', pid: null, vi: 0, account: null,
    busy: false, holdTimer: 0, confirmUntil: 0, confirmTimer: 0, doneUntil: 0, doneTimer: 0, errTimer: 0,
    noteMsg: null, glOk: null, glWant: false, loadSeq: 0, closeTimer: 0, enterTimer: 0, zoom: 1,
  };
  const R = {};          /* referências do DOM */
  let tiles = {}, chips = {}, fillers = [], swEls = [], featEls = [], specEls = [], payEls = {}, walletEls = {};

  /* ---------------------------------------------------------------- utilitários */
  const hexOk = c => /^#[0-9a-f]{6}$/i.test(String(c || ''));
  const restart = (el, cls) => { el.classList.remove(cls); void el.offsetWidth; el.classList.add(cls); };
  /* abanão do botão de compra: a classe sai sozinha mesmo sem animationend (movimento reduzido) */
  const shake = () => { restart(R.hold, 'err'); clearTimeout(S.errTimer); S.errTimer = setTimeout(() => R.hold.classList.remove('err'), 600); };
  const VW = () => window.ShopViewer;
  const setText = (el, t) => { t = t == null ? '' : String(t); if (el.textContent !== t) el.textContent = t; };

  function money(n) {
    n = Number(n) || 0;
    const neg = n < 0;
    n = Math.abs(n);
    const int = Math.floor(n);
    let s = String(int).replace(/\B(?=(\d{3})+(?!\d))/g, NNBSP);
    const cents = Math.round((n - int) * 100);
    if (cents > 0) s += ',' + String(cents).padStart(2, '0');
    /* números no formato do idioma do telemóvel ("1,499.50" em inglês); sem cêntimos fica inteiro, como antes */
    if (window.UI && UI.fmtNum) s = cents > 0 ? UI.fmtNum(n, 2, 2) : UI.fmtNum(int, 0, 0);
    const c = (S.catalog && S.catalog.currency) || (window.UI && UI.currency ? UI.currency() : {});
    const sym = c.symbol || (window.UI && UI.cur ? UI.cur() : '$');
    s = c.position === 'before' ? sym + s : s + NBSP + sym;
    return (neg ? '-' : '') + s;
  }

  /* silhueta do aparelho quando nem a imagem existe (cores do próprio produto) */
  function glyph(p, v) {
    const c = hexOk(v && v.swatch) ? v.swatch : '#3a3f4f';
    if (p && p.viewer && p.viewer.kind === 'buds') {
      return `<svg class="xs-glyph" viewBox="0 0 100 160"><circle cx="32" cy="58" r="21" fill="${c}" stroke="rgba(255,255,255,.25)"/><rect x="38" y="70" width="11" height="58" rx="5.5" fill="${c}" stroke="rgba(255,255,255,.25)"/><circle cx="68" cy="58" r="21" fill="${c}" stroke="rgba(255,255,255,.25)"/><rect x="51" y="70" width="11" height="58" rx="5.5" fill="${c}" stroke="rgba(255,255,255,.25)"/></svg>`;
    }
    return `<svg class="xs-glyph" viewBox="0 0 60 100"><rect x="4" y="3" width="52" height="94" rx="11" fill="${c}" stroke="rgba(255,255,255,.24)" stroke-width="1.2"/><rect x="10" y="9" width="18" height="18" rx="5.5" fill="rgba(0,0,0,.30)"/><circle cx="16" cy="15" r="3" fill="rgba(0,0,0,.45)"/><circle cx="23" cy="21" r="3" fill="rgba(0,0,0,.45)"/></svg>`;
  }

  /* imagem do produto: nui://apex_phone/inventory_images/x.png; se falhar (browser de testes) tenta o caminho
     relativo ../inventory_images/x.png e por fim a silhueta. holder fica com UM filho (img ou svg). */
  function setImage(holder, p, v) {
    const want = (v && v.image) || '';
    if (holder._src === want && holder._item === (v && v.item)) return;
    holder._src = want; holder._item = v && v.item;
    let img = holder.firstElementChild;
    if (!img || img.tagName !== 'IMG') { holder.textContent = ''; img = new Image(); img.alt = ''; img.decoding = 'async'; img.draggable = false; holder.appendChild(img); }
    const tries = [want];
    if (v && v.item) tries.push('../inventory_images/' + v.item + '.png');
    /* fora do FiveM o esquema nui:// nem existe: vai direto ao caminho relativo */
    if (!(window.Bridge && Bridge.inFiveM) && /^nui:\/\//.test(want)) tries[0] = want.replace(/^nui:\/\/[^/]+\//, '../');
    let k = 0;
    img.onerror = () => {
      k++;
      if (k < tries.length && tries[k] && tries[k] !== tries[k - 1]) { img.src = tries[k]; return; }
      img.onerror = null;
      holder.innerHTML = glyph(p, v);
    };
    img.src = tries[0] || tries[1] || '';
  }

  const owned = item => Math.max(0, Number(S.state.owned && S.state.owned[item]) || 0);
  const available = item => !(S.state.available && S.state.available[item] === false);
  const productOwned = p => p.variants.reduce((a, v) => a + owned(v.item), 0);
  const productAvailable = p => p.variants.some(v => available(v.item));
  const inCat = (p, cat) => cat === 'all' || (p.categories || []).indexOf(cat) >= 0;
  const curProduct = () => (S.pid && S.byId[S.pid]) || null;
  const curVariant = () => { const p = curProduct(); return p ? (p.variants[S.vi] || p.variants[0]) : null; };
  /* preço de uma cor: o dela, senão o do produto (o client/shop.lua manda sempre o da cor; o mock do painel não) */
  const priceOf = (p, v) => Number(v && v.price != null ? v.price : p && p.price) || 0;
  const accLabel = a => ACC_LABEL[a] || a;

  /* ---------------------------------------------------------------- esqueleto (uma vez) */
  function build() {
    if (S.built) return;
    S.built = true;
    const root = document.createElement('div');
    root.id = 'xs-root';
    root.className = 'xs-root ovk';   /* 4 out: era 'xs', o mesmo nome do tamanho de avatar .avatar.xs; .ovk = tokens e peças do ovkit */
    root.hidden = true;
    root.setAttribute('aria-hidden', 'true');
    root.innerHTML =
      '<div class="ovk-layer xs-layer"><div class="ovk-win xs-win">' +
        '<header class="ovk-head xs-head">' +
          `<span class="ovk-badge">${ico('phone')}</span>` +
          '<div class="xs-hd"><div class="ovk-title xs-title"></div>' +
            '<div class="ovk-sub xs-sub"><span class="ovk-live ok">Loja aberta</span><i class="xs-dot"></i><span class="xs-count"></span>' +
              `<span class="ovk-tag warn xs-admin" hidden>${ico('shield')}<span>Modo administrador</span></span></div></div>` +
          '<div class="xs-hr"><div class="xs-wallet"></div>' +
            `<button class="ovk-close xs-close" type="button" aria-label="Fechar" title="Fechar"><span class="ovk-key">ESC</span>${ico('x')}</button></div>` +
        '</header>' +
        '<div class="xs-body">' +
          '<section class="xs-main">' +
            '<nav class="xs-cats"></nav>' +
            '<div class="xs-cols">' +
              '<div class="ovk-tray xs-shelf"><div class="xs-grid"></div></div>' +
              '<div class="xs-show">' +
                '<div class="ovk-tray xs-stage">' +
                  '<i class="xs-glow"></i><i class="xs-ring"></i>' +
                  '<div class="xs-fb"><div class="xs-fb-pic"></div></div>' +
                  '<span class="ovk-corners xs-ck"></span>' +
                  '<div class="xs-st-tags"><span class="ovk-tag mute xs-brand" data-noi18n></span><span class="ovk-tag mute xs-os" data-noi18n></span>' +
                    '<span class="ovk-tag xs-badge" hidden></span><span class="ovk-tag warn xs-soon" hidden>Brevemente</span></div>' +
                  '<div class="xs-st-nav">' +
                    `<button class="ovk-btn icon sm xs-prev" type="button" aria-label="Anterior" title="Anterior">${ico('left')}</button>` +
                    `<button class="ovk-btn icon sm xs-next" type="button" aria-label="Seguinte" title="Seguinte">${ico('right')}</button></div>` +
                  '<div class="ovk-bar xs-load"><i></i></div>' +
                '</div>' +
                '<div class="xs-ctl"><div class="xs-colors"></div><div class="xs-tools">' +
                  `<button class="ovk-btn sm xs-fold" type="button" hidden>${ico('foldIn')}<span class="xs-fold-l"></span></button>` +
                  `<button class="ovk-btn icon sm xs-reset" type="button" title="Repor vista" aria-label="Repor vista">${ico('reset')}</button>` +
                '</div></div>' +
                '<div class="xs-keys">' +
                  '<span class="xs-k xs-k-gl"><span class="ovk-key">Arrastar</span><span>Rodar</span></span>' +
                  '<span class="xs-k xs-k-gl"><span class="ovk-key">Roda do rato</span><span>Aproximar</span></span>' +
                  '<span class="xs-k"><span class="ovk-key">← →</span><span>Produto</span></span>' +
                  '<span class="xs-k"><span class="ovk-key">↑ ↓</span><span>Cor</span></span>' +
                '</div>' +
              '</div>' +
            '</div>' +
            `<div class="ovk-empty ovk-tray xs-empty" hidden><span class="ic">${ico('bag')}</span><b>Sem produtos à venda</b><span>Não há produtos à venda nesta loja.</span></div>` +
          '</section>' +
          '<aside class="xs-detail">' +
            '<div class="xs-d-scroll">' +
              '<h1 class="xs-name" data-noi18n></h1>' +
              '<p class="xs-tagline"></p>' +
              '<div class="xs-specs-w"><div class="ovk-label">Especificações</div><div class="xs-specs"></div></div>' +
              '<div class="xs-feats-w"><div class="ovk-label">Destaques</div><ul class="xs-feats"></ul></div>' +
              `<p class="xs-usage" hidden>${ico('info')}<span class="xs-usage-t"></span></p>` +
            '</div>' +
            '<div class="xs-foot">' +
              '<div class="xs-price-row"><div class="xs-price-b"><span class="xs-price-k">Preço</span><span class="xs-price" data-noi18n></span></div>' +
                `<span class="ovk-tag ok xs-own" hidden>${ico('check')}<span>Já tens</span><span class="xs-own-n" data-noi18n></span></span></div>` +
              '<div class="ovk-seg xs-pay"></div>' +
              '<button class="ovk-btn pri xs-hold" type="button"><span class="xs-hold-fill"></span>' +
                `<span class="ovk-ic xs-hold-ic">${ico('bag', 'a')}${ico('check', 'b')}</span>` +
                '<span class="xs-hold-txt"><span class="xs-hold-label"></span><span class="xs-hold-sub"></span></span>' +
                '<span class="ovk-key xs-hold-key">Enter</span></button>' +
              '<div class="xs-note"></div>' +
            '</div>' +
          '</aside>' +
        '</div>' +
      '</div></div>';
    document.body.appendChild(root);
    const q = s => root.querySelector(s);
    Object.assign(R, {
      root, win: q('.xs-win'), title: q('.xs-title'), count: q('.xs-count'), admin: q('.xs-admin'), wallet: q('.xs-wallet'), close: q('.xs-close'),
      main: q('.xs-main'), cats: q('.xs-cats'), shelf: q('.xs-shelf'), grid: q('.xs-grid'), empty: q('.xs-empty'),
      stage: q('.xs-stage'), fb: q('.xs-fb-pic'), load: q('.xs-load'), loadBar: q('.xs-load i'),
      tags: q('.xs-st-tags'), brand: q('.xs-brand'), os: q('.xs-os'), badge: q('.xs-badge'), soon: q('.xs-soon'),
      nav: q('.xs-st-nav'), prev: q('.xs-prev'), next: q('.xs-next'),
      colors: q('.xs-colors'), tools: q('.xs-tools'), fold: q('.xs-fold'), foldL: q('.xs-fold-l'), reset: q('.xs-reset'), keys: q('.xs-keys'),
      dScroll: q('.xs-d-scroll'), name: q('.xs-name'), tag: q('.xs-tagline'), specsW: q('.xs-specs-w'), specs: q('.xs-specs'),
      featsW: q('.xs-feats-w'), feats: q('.xs-feats'), usage: q('.xs-usage'), usageT: q('.xs-usage-t'),
      price: q('.xs-price'), own: q('.xs-own'), ownN: q('.xs-own-n'), pay: q('.xs-pay'),
      hold: q('.xs-hold'), holdLabel: q('.xs-hold-label'), holdSub: q('.xs-hold-sub'), note: q('.xs-note'),
    });
    /* listas de tamanho fixo: criam-se agora e depois só se escondem/mostram */
    for (let i = 0; i < MAX_FEATS; i++) {
      const li = document.createElement('li');
      li.className = 'xs-feat';
      li.innerHTML = `${ico('check')}<span></span>`;
      li.hidden = true;
      R.feats.appendChild(li);
      featEls.push({ el: li, t: li.lastChild });
    }
    for (let i = 0; i < MAX_SPECS; i++) {
      const c = document.createElement('div');
      c.className = 'ovk-cell xs-spec';
      c.innerHTML = '<span class="k"></span><span class="v" data-noi18n></span>';
      c.hidden = true;
      R.specs.appendChild(c);
      specEls.push({ el: c, k: c.firstChild, v: c.lastChild });
    }
    for (let i = 0; i < MAX_SW; i++) {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'ovk-tile xs-sw';
      b.innerHTML = '<i class="xs-sw-dot"></i><span class="xs-sw-n"></span><i class="xs-sw-own" hidden></i>';
      b.hidden = true;
      b.addEventListener('click', e => { e.currentTarget.blur(); pickVariant(i); });
      R.colors.appendChild(b);
      swEls.push({ el: b, dot: b.children[0], n: b.children[1], own: b.children[2] });
    }
    R.close.addEventListener('click', e => { e.currentTarget.blur(); close(); });
    R.prev.addEventListener('click', e => { e.currentTarget.blur(); step(-1); });
    R.next.addEventListener('click', e => { e.currentTarget.blur(); step(1); });
    R.fold.addEventListener('click', e => { e.currentTarget.blur(); toggleFold(); });
    R.reset.addEventListener('click', e => { e.currentTarget.blur(); const V = VW(); if (S.glOk && V && V.ready) V.reset(); });
    /* manter premido para comprar */
    R.hold.addEventListener('pointerdown', e => { if (e.button === 0) { e.preventDefault(); holdStart(); } });
    ['pointerup', 'pointerleave', 'pointercancel'].forEach(t => R.hold.addEventListener(t, holdCancel));
    R.hold.addEventListener('click', e => e.preventDefault());
    R.hold.addEventListener('animationend', e => { if (e.animationName === 'xs-shake') R.hold.classList.remove('err'); });
    window.addEventListener('resize', fit);
    window.addEventListener('keydown', onKey, true);
  }

  /* desenho a 1920×1080: a janela escala com zoom pelo lado que aperta mais e o .ovk-layer centra-a (flex, sem
     left:50%). O visor mede o palco em px do desenho (clientWidth) e multiplica por este zoom. */
  function fit() {
    if (!R.win) return;
    const w = window.innerWidth, h = window.innerHeight;
    const z = Math.max(0.45, Math.min(2.2, Math.min(w / 1920, h / 1080)));
    S.zoom = z;
    R.win.style.zoom = String(z);
    const V = VW();
    if (V && V.setScale) V.setScale(z);
    if (V && V.ready) V.resize();
  }

  /* ---------------------------------------------------------------- catálogo (uma vez por catálogo) */
  function normCatalog(c) {
    c = c && typeof c === 'object' ? c : {};
    const products = (Array.isArray(c.products) ? c.products : []).filter(p => p && p.id && Array.isArray(p.variants) && p.variants.length);
    const cats = Array.isArray(c.categories) && c.categories.length ? c.categories.filter(x => x && x.id) : [{ id: 'all', label: 'Todos' }];
    if (!cats.some(x => x.id === 'all')) cats.unshift({ id: 'all', label: 'Todos' });
    const pay = c.payment && typeof c.payment === 'object' ? c.payment : {};
    const accounts = (Array.isArray(pay.accounts) ? pay.accounts : ['bank', 'cash']).filter(a => a === 'bank' || a === 'cash');
    if (!accounts.length) accounts.push('bank');
    return {
      products, categories: cats, currency: c.currency || (window.UI && UI.currency ? UI.currency() : { symbol: '$', position: 'before' }),
      payment: { accounts, default: accounts.indexOf(pay.default) >= 0 ? pay.default : accounts[0] },
    };
  }

  function buildCatalog(cat) {
    S.catalog = cat;
    S.byId = {};
    cat.products.forEach(p => { S.byId[p.id] = p; });
    const n = cat.products.length;
    R.root.classList.toggle('is-empty', !n);
    R.empty.hidden = !!n;
    R.count.textContent = n === 1 ? '1 produto' : n + ' produtos';

    /* fichas de categoria (contagem sem zeros à esquerda) */
    R.cats.textContent = '';
    chips = {};
    cat.categories.forEach(c => {
      const cn = cat.products.filter(p => inCat(p, c.id)).length;
      if (c.id !== 'all' && !cn) return;
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'ovk-chip xs-chip';
      b.setAttribute('data-cat', c.id);
      b.innerHTML = `${ico(CAT_ICON[c.icon] || 'grid')}<span></span><span class="n" data-noi18n></span>`;
      b.children[1].textContent = c.label || c.id;
      b.children[2].textContent = String(cn);
      b.addEventListener('click', e => { e.currentTarget.blur(); setCat(c.id); });
      R.cats.appendChild(b);
      chips[c.id] = { el: b };
    });

    /* mosaicos do catálogo + mosaicos vazios que completam a grelha (como as ranhuras do inventário) */
    R.grid.textContent = '';
    tiles = {};
    fillers = [];
    cat.products.forEach(p => {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'ovk-tile xs-tile';
      b.setAttribute('data-pid', p.id);
      b.innerHTML = '<span class="ovk-corners"></span><span class="xs-t-img"></span>' +
        `<span class="xs-t-top"><span class="ovk-tag ok xs-t-own" hidden>${ico('check')}<span>Já tens</span></span><i class="xs-t-gap"></i><span class="ovk-tag xs-t-badge" hidden></span></span>` +
        '<span class="xs-t-name" data-noi18n></span>' +
        '<span class="xs-t-row"><span class="xs-t-price"><span class="xs-t-from" hidden>Desde</span><span class="xs-t-v" data-noi18n></span></span>' +
          '<span class="ovk-tag warn xs-t-soon" hidden>Brevemente</span><span class="xs-t-dots"></span></span>';
      const q = s => b.querySelector(s);
      q('.xs-t-name').textContent = p.name || p.id;
      b.title = p.name || p.id;
      const badge = q('.xs-t-badge');
      badge.textContent = p.badge || '';
      badge.hidden = !p.badge;
      const prices = p.variants.map(v => priceOf(p, v));
      const min = Math.min.apply(null, prices), max = Math.max.apply(null, prices);
      const pv = q('.xs-t-v'), from = q('.xs-t-from');
      pv.textContent = money(min);
      from.hidden = !(max > min);
      /* as cores do produto em pontos pequenos (as cores são do produto, não da marca) */
      const dots = q('.xs-t-dots');
      p.variants.slice(0, MAX_DOTS).forEach(v => { const d = document.createElement('i'); d.style.background = hexOk(v.swatch) ? v.swatch : '#3a3f4f'; dots.appendChild(d); });
      if (p.variants.length > MAX_DOTS) { const m = document.createElement('b'); m.setAttribute('data-noi18n', ''); m.textContent = '+' + (p.variants.length - MAX_DOTS); dots.appendChild(m); }
      const v0 = p.variants.find(v => available(v.item)) || p.variants[0];
      setImage(q('.xs-t-img'), p, v0);
      b.addEventListener('click', e => { e.currentTarget.blur(); selectProduct(p.id); });
      R.grid.appendChild(b);
      tiles[p.id] = { el: b, top: q('.xs-t-top'), price: q('.xs-t-price'), from, soon: q('.xs-t-soon'), own: q('.xs-t-own'), badge: !!p.badge };
    });
    for (let i = 0; i < MIN_SLOTS; i++) {
      const f = document.createElement('div');
      f.className = 'ovk-tile is-empty xs-tile-e';
      f.innerHTML = '<span class="ovk-corners"></span>';
      f.hidden = true;
      R.grid.appendChild(f);
      fillers.push(f);
    }

    /* pagamento (o saldo de cada conta vai no próprio botão) */
    R.pay.textContent = '';
    payEls = {};
    R.pay.classList.toggle('one', cat.payment.accounts.length === 1);
    cat.payment.accounts.forEach(acc => {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'xs-pay-opt';
      b.innerHTML = `${ico(acc === 'bank' ? 'bank' : 'cash')}<span class="xs-pay-l"></span><span class="xs-pay-v" data-noi18n></span>`;
      b.children[1].textContent = accLabel(acc);
      b.addEventListener('click', e => { e.currentTarget.blur(); setAccount(acc); });
      R.pay.appendChild(b);
      payEls[acc] = { el: b, v: b.children[2] };
    });

    /* carteira no cabeçalho */
    R.wallet.textContent = '';
    walletEls = {};
    cat.payment.accounts.forEach(acc => {
      const c = document.createElement('div');
      c.className = 'ovk-cell xs-wc ' + acc;
      c.innerHTML = `<span class="xs-wc-ic">${ico(acc === 'bank' ? 'bank' : 'cash')}</span><span class="xs-wc-b"><span class="k"></span><span class="v mono" data-noi18n></span></span>`;
      c.querySelector('.k').textContent = accLabel(acc);
      R.wallet.appendChild(c);
      walletEls[acc] = c.querySelector('.v');
    });
  }

  /* ---------------------------------------------------------------- estado do servidor */
  function normState(st) {
    st = st && typeof st === 'object' ? st : {};
    return {
      wallet: st.wallet && typeof st.wallet === 'object' ? st.wallet : {},
      owned: st.owned && typeof st.owned === 'object' ? st.owned : {},
      available: st.available && typeof st.available === 'object' ? st.available : {},
      framework: st.framework !== false,
    };
  }

  function applyState(st) {
    S.state = normState(st);
    Object.keys(walletEls).forEach(acc => {
      const n = S.state.wallet[acc];
      setText(walletEls[acc], typeof n === 'number' ? money(n) : '-');
      walletEls[acc].classList.toggle('na', typeof n !== 'number');
      if (payEls[acc]) setText(payEls[acc].v, typeof n === 'number' ? money(n) : '-');
    });
    Object.keys(tiles).forEach(id => {
      const p = S.byId[id], t = tiles[id];
      const av = productAvailable(p);
      t.price.hidden = !av;
      t.soon.hidden = av;
      t.el.classList.toggle('soon', !av);
      t.own.hidden = productOwned(p) <= 0;
      /* "Já tens" e "Novo" no mesmo mosaico: o "Já tens" fica só com o visto (noutros idiomas não cabiam os dois) */
      t.top.classList.toggle('both', !t.own.hidden && t.badge);
    });
    if (curProduct()) { renderSwatches(); renderVariant(false); }
  }

  function refresh() {
    return Overlay.rpc('shop.refresh', {}, 10000).then(r => { if (S.open && r && r.ok && r.state) applyState(r.state); });
  }

  /* ---------------------------------------------------------------- categorias */
  function visibleIds() {
    return S.catalog ? S.catalog.products.filter(p => inCat(p, S.cat)).map(p => p.id) : [];
  }

  function setCat(id, initial) {
    if (!chips[id]) id = 'all';
    S.cat = id;
    Object.keys(chips).forEach(k => chips[k].el.classList.toggle('on', k === id));
    const ids = visibleIds();
    S.catalog.products.forEach(p => { tiles[p.id].el.hidden = ids.indexOf(p.id) < 0; });
    /* a grelha nunca fica a meio: mosaicos vazios até 4 filas e para fechar a última fila */
    const want = ids.length < MIN_SLOTS ? MIN_SLOTS - ids.length : ids.length % 2;
    fillers.forEach((f, i) => { f.hidden = i >= want; });
    R.nav.hidden = ids.length <= 1;
    if (!initial && ids.length && ids.indexOf(S.pid) < 0) selectProduct(ids[0]);
    else if (!initial) scrollTileIntoView();
  }

  function scrollTileIntoView() {
    const t = S.pid && tiles[S.pid];
    if (!t || t.el.hidden) return;
    const d = R.shelf, el = t.el;
    if (el.offsetTop < d.scrollTop + 10) d.scrollTop = el.offsetTop - 10;
    else if (el.offsetTop + el.offsetHeight > d.scrollTop + d.clientHeight - 10) d.scrollTop = el.offsetTop + el.offsetHeight - d.clientHeight + 10;
  }

  function step(dir) {
    const ids = visibleIds();
    if (!ids.length) return;
    const i = ids.indexOf(S.pid);
    selectProduct(ids[(i + dir + ids.length) % ids.length]);
  }

  /* ---------------------------------------------------------------- produto */
  function selectProduct(id, quiet) {
    const p = S.byId[id];
    if (!p) return;
    const changed = S.pid !== id;
    S.pid = id;
    const firstAv = p.variants.findIndex(v => available(v.item));
    S.vi = firstAv >= 0 ? firstAv : 0;
    setConfirm(false);
    S.doneUntil = 0;
    S.noteMsg = null;
    Object.keys(tiles).forEach(k => tiles[k].el.classList.toggle('on', k === id));
    scrollTileIntoView();

    /* etiquetas do palco */
    R.brand.textContent = p.brand || '';
    R.brand.hidden = !p.brand;
    R.os.textContent = p.os || '';
    R.os.hidden = !p.os;
    R.badge.textContent = p.badge || '';
    R.badge.hidden = !p.badge;

    /* ficha */
    R.name.textContent = p.name || p.id;
    R.name.classList.toggle('long', String(p.name || p.id).length > 22);
    R.tag.textContent = p.tagline || '';
    R.tag.hidden = !p.tagline;
    /* especificações: as chaves conhecidas pela ordem, depois as outras */
    const specs = p.specs && typeof p.specs === 'object' ? p.specs : {};
    const keys = SPEC_ORDER.filter(k => specs[k]).concat(Object.keys(specs).filter(k => SPEC_ORDER.indexOf(k) < 0 && specs[k]));
    specEls.forEach((s, i) => {
      const k = keys[i];
      s.el.hidden = !k;
      if (!k) return;
      if (SPEC_LABEL[k]) s.k.removeAttribute('data-noi18n'); else s.k.setAttribute('data-noi18n', '');
      s.k.textContent = SPEC_LABEL[k] || k;
      s.v.textContent = String(specs[k]);
    });
    R.specsW.hidden = !keys.length;
    const feats = Array.isArray(p.features) ? p.features : [];
    featEls.forEach((f, i) => { f.el.hidden = !feats[i]; if (feats[i]) f.t.textContent = feats[i]; });
    R.featsW.hidden = !feats.length;
    R.usage.hidden = !p.usage;
    R.usageT.textContent = p.usage || '';
    R.dScroll.scrollTop = 0;

    buildSwatches(p);
    renderVariant(true);
    if (changed && !quiet) { restart(R.dScroll, 'xs-swap'); restart(R.tags, 'xs-swap'); }
  }

  function buildSwatches(p) {
    swEls.forEach((o, i) => {
      const v = p.variants[i];
      o.el.hidden = !v;
      if (!v) return;
      o.dot.style.background = hexOk(v.swatch) ? v.swatch : '#3a3f4f';
      o.n.textContent = v.color || '';
      o.el.title = v.color || '';
    });
    R.colors.classList.toggle('many', p.variants.length > MANY_SW);
    renderSwatches();
  }

  function renderSwatches() {
    const p = curProduct();
    if (!p) return;
    swEls.forEach((o, i) => {
      const v = p.variants[i];
      if (!v) return;
      o.el.classList.toggle('on', i === S.vi);
      o.el.classList.toggle('soon', !available(v.item));
      o.own.hidden = owned(v.item) <= 0;
    });
  }

  function pickVariant(i) {
    const p = curProduct();
    if (!p || !p.variants[i] || i === S.vi) return;
    S.vi = i;
    setConfirm(false);
    S.doneUntil = 0;
    S.noteMsg = null;
    renderSwatches();
    renderVariant(true);
    restart(R.price, 'xs-tick');
  }

  function renderVariant(reload) {
    const p = curProduct(), v = curVariant();
    if (!p || !v) return;
    R.soon.hidden = available(v.item);
    setText(R.price, money(priceOf(p, v)));
    const n = owned(v.item);
    R.own.hidden = n <= 0;
    setText(R.ownN, n > 1 ? '×' + n : '');
    setImage(R.fb, p, v);
    renderPay();
    renderHold();
    if (reload) loadModel();
  }

  /* ---------------------------------------------------------------- pagamento */
  function setAccount(acc) {
    if (!payEls[acc] || S.account === acc) return;
    S.account = acc;
    setConfirm(false);
    S.noteMsg = null;
    renderPay();
    renderHold();
  }

  function renderPay() {
    const p = curProduct(), v = curVariant();
    Object.keys(payEls).forEach(acc => {
      const bal = S.state.wallet[acc];
      payEls[acc].el.classList.toggle('on', acc === S.account);
      payEls[acc].el.classList.toggle('low', !!v && typeof bal === 'number' && bal < priceOf(p, v));
    });
  }

  /* ---------------------------------------------------------------- comprar */
  function blockReason() {
    const p = curProduct(), v = curVariant();
    if (!v) return { note: '' };
    if (!S.state.framework) return { note: 'A loja não está ligada a nenhum framework.' };
    if (!available(v.item)) return { note: 'Esta cor ainda não chegou à loja.', soon: true };
    const bal = S.state.wallet[S.account], price = priceOf(p, v);
    if (typeof bal === 'number' && bal < price) return { note: L.tf('Saldo insuficiente: faltam %s.', money(price - bal)) };
    return null;
  }

  function setConfirm(on) {
    clearTimeout(S.confirmTimer);
    S.confirmUntil = on ? Date.now() + CONFIRM_MS : 0;
    if (on) S.confirmTimer = setTimeout(() => { S.confirmUntil = 0; renderHold(); }, CONFIRM_MS);
  }

  function setNote(text, kind) {
    setText(R.note, text || '');
    const cls = 'xs-note' + (kind ? ' ' + kind : '');
    if (R.note.className !== cls) R.note.className = cls;
  }

  function renderHold() {
    const h = R.hold;
    if (!h) return;
    const block = blockReason();
    const confirming = S.confirmUntil > Date.now() && !block;
    const done = S.doneUntil > Date.now();
    h.classList.toggle('blocked', !!block && !S.busy && !done);
    h.classList.toggle('soon', !!(block && block.soon) && !S.busy && !done);
    h.classList.toggle('full', S.busy);
    h.classList.toggle('done', done && !S.busy);
    h.classList.toggle('confirm', confirming && !S.busy);
    let label, sub;
    if (S.busy) { label = 'A processar…'; sub = 'A falar com o banco'; }
    else if (done) { label = 'Adquirido'; sub = 'Já está no teu inventário'; }
    else if (block && block.soon) { label = 'Brevemente'; sub = 'Ainda não disponível'; }
    else if (confirming) { label = 'Prime Enter outra vez para confirmar'; sub = accLabel(S.account); }
    else { label = 'Mantém premido para comprar'; sub = accLabel(S.account); }
    if (R.holdLabel.textContent !== label) { R.holdLabel.textContent = label; fitHoldLabel(); }
    setText(R.holdSub, sub);
    /* nota por baixo: mensagem do servidor (até a próxima ação) > bloqueio > estado */
    if (S.noteMsg) setNote(S.noteMsg.text, S.noteMsg.kind);
    else if (S.busy) setNote('A confirmar o pagamento…', '');
    else if (done) setNote('Já está no teu inventário.', 'ok');
    else if (block) setNote(block.note, 'warn');
    else if (confirming) setNote(L.tf('Pagamento: %s.', L.t(accLabel(S.account))), '');
    else setNote('Vai direto para o teu inventário.', '');
  }

  /* o texto do botão que não cabe numa linha (o "Prime Enter outra vez para confirmar", ou outro idioma) passa a duas
     linhas e esconde a linha de baixo. Mede-se no frame seguinte: o tradutor do DOM já trocou o texto (microtarefa) e
     ainda não se pintou nada. */
  let fitRaf = 0;
  function fitHoldLabel() {
    cancelAnimationFrame(fitRaf);
    fitRaf = requestAnimationFrame(() => {
      fitRaf = 0;
      if (!S.open) return;
      const h = R.hold, l = R.holdLabel;
      h.classList.remove('wrap');
      if (l.scrollWidth > l.clientWidth + 1) h.classList.add('wrap');
    });
  }

  function holdStart() {
    if (!S.open || S.busy || S.holdTimer) return;
    if (S.doneUntil > Date.now()) return;
    const block = blockReason();
    if (block) { shake(); return; }
    S.noteMsg = null;
    setConfirm(false);
    renderHold();
    R.hold.classList.add('on');
    S.holdTimer = setTimeout(() => {
      S.holdTimer = 0;
      R.hold.classList.remove('on');
      doBuy();
    }, HOLD_MS);
  }

  function holdCancel() {
    if (!S.holdTimer) return;
    clearTimeout(S.holdTimer);
    S.holdTimer = 0;
    R.hold.classList.remove('on');
  }

  function enterKey() {
    if (S.busy || S.holdTimer) return;
    if (S.doneUntil > Date.now()) return;
    const block = blockReason();
    if (block) { shake(); return; }
    if (S.confirmUntil <= Date.now()) { S.noteMsg = null; setConfirm(true); renderHold(); return; }
    setConfirm(false);
    doBuy();
  }

  function doBuy() {
    const p = curProduct(), v = curVariant();
    if (!p || !v || S.busy) return;
    S.busy = true;
    S.noteMsg = null;
    renderHold();
    const item = v.item, account = S.account;
    Overlay.rpc('shop.buy', { item, account }, 15000).then(res => {
      S.busy = false;
      if (!S.open) return;
      if (res && res.ok) {
        if (res.state) applyState(res.state);
        clearTimeout(S.doneTimer);
        S.doneUntil = Date.now() + DONE_MS;
        S.doneTimer = setTimeout(() => { S.doneUntil = 0; renderHold(); }, DONE_MS);
        renderSwatches();
        renderVariant(false);
      } else {
        S.noteMsg = { text: (res && res.message) || 'A compra falhou. Tenta outra vez.', kind: 'err' };
        shake();
        if (res && res.state) applyState(res.state); else refresh();
        renderHold();
      }
    });
  }

  /* ---------------------------------------------------------------- visor 3D */
  /* a fila das ferramentas só existe se houver ferramentas */
  function syncCtl() { R.tools.hidden = R.fold.hidden && R.reset.hidden; }

  function progress(f, on) {
    R.load.classList.toggle('on', !!on);
    R.loadBar.style.transform = `scaleX(${Math.max(0, Math.min(1, f))})`;
  }

  function glOff() {
    R.stage.classList.remove('gl-on');
    R.fold.hidden = true;
    R.reset.hidden = true;
    R.keys.classList.add('no-gl');
    progress(0, false);
    syncCtl();
  }

  function glReady(V) {
    R.reset.hidden = false;
    R.keys.classList.remove('no-gl');
    syncCtl();
    V.resetHint();
    if (V.setScale) V.setScale(S.zoom);
    V.setActive(true);
    loadModel();
  }

  /* primeira abertura: carrega o three.js (sem bloquear: a imagem do produto aparece logo) */
  function startViewer() {
    const V = VW();
    if (!V) { S.glOk = false; glOff(); return; }
    S.glWant = true;
    if (S.glOk === false) { glOff(); return; }
    if (S.glOk === true) { glReady(V); return; }
    glOff();
    progress(0.04, true);
    V.load().then(ok => {
      if (V.setScale) V.setScale(S.zoom);
      if (!ok || !V.mount(R.stage)) { S.glOk = false; progress(0, false); return; }
      S.glOk = true;
      if (!S.open || !S.glWant) { progress(0, false); return; }
      glReady(V);
    });
  }

  function stopViewer() {
    S.glWant = false;
    S.loadSeq++;
    progress(0, false);
    const V = VW();
    if (V && V.ready) { V.setActive(false); V.unload(); }
    R.stage.classList.remove('gl-on');
  }

  function loadModel() {
    const p = curProduct(), v = curVariant(), V = VW();
    if (!S.glOk || !V || !V.ready || !p || !v || !S.open) return;
    if (!v.model) { R.stage.classList.remove('gl-on'); R.fold.hidden = true; syncCtl(); return; }
    const seq = ++S.loadSeq;
    R.fold.hidden = true;
    syncCtl();
    progress(0.06, true);
    const spec = Object.assign({ key: p.id }, p.viewer || {});
    const url = v.model + (spec.revision ? (v.model.indexOf('?') >= 0 ? '&' : '?') + 'v=' + encodeURIComponent(spec.revision) : '');
    V.show(url, spec, f => { if (seq === S.loadSeq) progress(0.06 + f * 0.9, true); }).then(ok => {
      if (seq !== S.loadSeq) return;
      progress(1, true);
      setTimeout(() => { if (seq === S.loadSeq) progress(1, false); }, 280);
      if (!ok) { R.stage.classList.remove('gl-on'); return; }
      R.stage.classList.add('gl-on');
      const kind = (p.viewer || {}).kind;
      R.fold.hidden = kind === 'buds' ? !V.hasCase() : !((kind === 'fold' || kind === 'flip') && V.hasFold());
      if (kind === 'buds' && V.hasCase()) V.setCaseOpen(true);
      setFoldLabel(kind === 'buds' ? V.isCaseOpen() : V.isFolded());
      syncCtl();
    });
  }

  function setFoldLabel(on) {
    const p = curProduct();
    const isCase = p && (p.viewer || {}).kind === 'buds';
    const label = isCase ? (on ? 'Fechar caixa' : 'Abrir caixa') : (on ? 'Abrir' : 'Dobrar');
    R.foldL.textContent = label;
    R.fold.setAttribute('aria-pressed', String(!!on));
    const k = isCase ? (on ? 'caseClose' : 'caseOpen') : (on ? 'foldOut' : 'foldIn');
    const svg = R.fold.firstElementChild;
    if (svg && svg._k !== k) { svg.innerHTML = P[k]; svg._k = k; }
  }

  function toggleFold() {
    const V = VW(), p = curProduct();
    if (!S.glOk || !V || !V.ready || R.fold.hidden || !p) return;
    if ((p.viewer || {}).kind === 'buds') { if (V.hasCase()) setFoldLabel(V.toggleCase()); }
    else if (V.hasFold()) setFoldLabel(V.toggleFold());
  }

  /* ---------------------------------------------------------------- teclado (só com a loja aberta, e sem deixar
     as teclas chegarem ao telemóvel: o ESC dele chamaria o 'close' do telemóvel)
     1.3.1 (4 nov 2026): o painel admin aberto POR CIMA da loja (/phoneadmin no F8, export OpenAdminPanel) fica com o teclado
     todo - antes o Espaço/Tab morriam nos campos dele, o Enter comprava e o ESC fechava a loja em vez do painel. E um campo
     de texto da loja (hoje não há nenhum) fica com as teclas dele: o Espaço, o Tab, as setas e o Enter não são cortados nem
     mudam de produto; o ESC só tira o foco do campo. O stopImmediatePropagation fica ANTES, para o telemóvel nunca as ver. */
  const NOT_TEXT = /^(checkbox|radio|range|button|submit|reset|color|file)$/;
  const isField = t => !!(t && t.nodeType === 1 && ((t.matches && t.matches('input,textarea,select') && !NOT_TEXT.test(t.type || '')) || t.isContentEditable));
  function onKey(e) {
    if (!S.open || S.closing) return;
    if (window.Overlay && Overlay.isOpen && Overlay.isOpen('admin')) return;
    e.stopImmediatePropagation();
    const t = e.target;
    if (isField(t)) { if (e.key === 'Escape') { e.preventDefault(); if (!e.repeat) t.blur(); } return; }
    const k = e.key;
    if (k === 'Escape') { e.preventDefault(); if (!e.repeat) close(); }
    else if (k === 'ArrowLeft' || k === 'ArrowRight') { e.preventDefault(); if (!S.busy) step(k === 'ArrowLeft' ? -1 : 1); }
    else if (k === 'ArrowUp' || k === 'ArrowDown') {
      e.preventDefault();
      const p = curProduct();
      if (p && p.variants.length > 1 && !S.busy) pickVariant((S.vi + (k === 'ArrowUp' ? -1 : 1) + p.variants.length) % p.variants.length);
    }
    else if (k === 'Enter') { e.preventDefault(); if (!e.repeat) enterKey(); }
    else if (k === ' ' || k === 'Tab') e.preventDefault();
  }

  /* ---------------------------------------------------------------- cabeçalho: nome da loja (o do config) ou o nome genérico */
  function fillVendor() {
    const label = String((S.shop && S.shop.label) || '').trim();
    if (label) { R.title.setAttribute('data-noi18n', ''); setText(R.title, label); }
    else { R.title.removeAttribute('data-noi18n'); setText(R.title, 'Loja de telemóveis'); }
    R.admin.hidden = !S.admin;
  }

  /* ---------------------------------------------------------------- abrir / fechar */
  function open(msg) {
    msg = msg && typeof msg === 'object' ? msg : {};
    build();
    clearTimeout(S.closeTimer);
    clearTimeout(S.enterTimer);
    const cat = normCatalog(msg.catalog || S.catalog);
    const key = JSON.stringify(cat);
    S.state = normState(msg.state);       /* os mosaicos precisam do estado para a imagem inicial */
    if (key !== S.catKey) { S.catKey = key; buildCatalog(cat); }
    S.shop = msg.shop || {};
    S.admin = !!msg.admin;
    S.busy = false; S.doneUntil = 0; S.noteMsg = null;
    setConfirm(false);
    holdCancel();
    fillVendor();
    const accs = cat.payment.accounts;
    if (!S.account || accs.indexOf(S.account) < 0) S.account = cat.payment.default;
    R.root.hidden = false;
    R.root.removeAttribute('aria-hidden');
    R.win.classList.remove('ovk-leave');
    S.open = true;
    S.closing = false;
    if (window.Overlay) Overlay.open('shop');
    fit();
    S.cat = 'all';
    setCat('all', true);
    applyState(msg.state);
    const first = cat.products.find(p => productAvailable(p)) || cat.products[0];
    S.pid = null;
    if (first) selectProduct(first.id, true);
    R.shelf.scrollTop = 0;
    restart(R.win, 'ovk-enter');
    S.enterTimer = setTimeout(() => R.win.classList.remove('ovk-enter'), ENTER_MS);
    startViewer();
  }

  /* com a loja aberta, o painel mudou o catálogo: troca no sítio e mantém o produto se ainda existir */
  function update(catalog, shop) {
    if (!S.open || !catalog) return;
    const cat = normCatalog(catalog);
    const key = JSON.stringify(cat);
    if (shop) { S.shop = shop; fillVendor(); }
    if (key === S.catKey) return;
    const keep = S.pid;
    S.catKey = key;
    buildCatalog(cat);
    if (cat.payment.accounts.indexOf(S.account) < 0) S.account = cat.payment.default;
    if (S.cat && !chips[S.cat]) S.cat = 'all';
    setCat(S.cat, true);
    applyState(S.state);
    const id = S.byId[keep] ? keep : (cat.products[0] && cat.products[0].id);
    S.pid = null;
    if (id) selectProduct(id, true);
  }

  function teardown() {
    S.open = false;
    S.closing = false;
    holdCancel();
    setConfirm(false);
    clearTimeout(S.doneTimer);
    clearTimeout(S.enterTimer);
    stopViewer();
    if (R.root) {
      R.root.hidden = true;
      R.root.setAttribute('aria-hidden', 'true');
      R.win.classList.remove('ovk-enter', 'ovk-leave');
    }
  }

  /* fechar pela interface (botão, ESC): saída curta da janela e depois o Overlay larga o foco no Lua */
  function close() {
    if (!S.open || S.closing) return;
    S.closing = true;
    holdCancel();
    const V = VW();
    if (V && V.ready) V.setActive(false);
    clearTimeout(S.enterTimer);
    R.win.classList.remove('ovk-enter');
    R.win.classList.add('ovk-leave');
    clearTimeout(S.closeTimer);
    S.closeTimer = setTimeout(() => {
      teardown();
      if (window.Overlay) Overlay.close('shop');
    }, LEAVE_MS);
  }

  if (window.Bridge && Bridge.on) {
    Bridge.on('shop:open', d => open(d));
    Bridge.on('shop:catalog', d => { if (d) update(d.catalog, d.shop); });
  }
  /* fechada pelo Lua (afastou-se do vendedor, morreu, loja desligada): sem animação, o body já escondeu */
  if (window.Overlay) Overlay.onClose('shop', () => { clearTimeout(S.closeTimer); teardown(); });

  /* ---------------------------------------------------------------- testes fora do FiveM */
  if (window.Overlay && !(window.Bridge && Bridge.inFiveM)) {
    const M = { wallet: { bank: 898514, cash: 0 }, owned: {}, available: {} };
    const snap = () => ({ wallet: Object.assign({}, M.wallet), owned: Object.assign({}, M.owned), available: Object.assign({}, M.available), framework: true });
    Overlay.mock['shop.state'] = () => ({ ok: true, state: snap() });
    Overlay.mock['shop.refresh'] = Overlay.mock['shop.state'];
    Overlay.mock['shop.buy'] = d => new Promise(res => setTimeout(() => {
      const p = S.catalog && S.catalog.products.find(x => x.variants.some(v => v.item === d.item));
      const v = p && p.variants.find(x => x.item === d.item);
      if (!v) return res({ ok: false, error: 'unknown_item', message: 'Este produto não existe nesta loja.' });
      if (M.available[d.item] === false) return res({ ok: false, error: 'unavailable', message: 'Este produto ainda não está disponível.' });
      const bal = M.wallet[d.account] || 0, price = priceOf(p, v);
      if (bal < price) return res({ ok: false, error: 'no_money', message: d.account === 'bank' ? 'Saldo insuficiente no banco.' : 'Não tens dinheiro suficiente contigo.', state: snap() });
      M.wallet[d.account] = bal - price;
      M.owned[d.item] = (M.owned[d.item] || 0) + 1;
      const label = `${p.name} · ${v.color}`;
      res({ ok: true, item: d.item, label, price, account: d.account, message: `Compraste ${label} por ${money(price)}.`, state: snap() });
    }, 650));
    /* o payload de teste semeia o estado do mock */
    const realOpen = open;
    window.__shopMockSeed = st => { st = normState(st); M.wallet = Object.assign({}, st.wallet); M.owned = Object.assign({}, st.owned); M.available = Object.assign({}, st.available); };
    window.Shop = { open(p) { if (p && p.state) window.__shopMockSeed(p.state); realOpen(p); }, close, update, get state() { return S; } };
  } else {
    window.Shop = { open, close, update, get state() { return S; } };
  }
}());
