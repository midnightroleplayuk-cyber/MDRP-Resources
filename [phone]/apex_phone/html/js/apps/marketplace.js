/* ===================== MARKETPLACE - anúncios entre jogadores (veículos, casas, etc.) ===================== */
/* 2026-10-01 (pedido do dono: icones mais parecidos com as apps reais): azul com a loja de toldo recortado, como o
   Marketplace das redes sociais */
Icons.app.marketplace = () => Icons.SVG(Icons.G('gMk', '#4A9BFF', '#1877F2', '#0B5FD6') + Icons.GL(`<g fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"><path d="M24 40l4-14h44l4 14"/><path d="M22 40c0 5 4.2 9 9.3 9s9.3-4 9.3-9c0 5 4.2 9 9.4 9s9.4-4 9.4-9c0 5 4.1 9 9.3 9S78 45 78 40"/><path d="M28 53v21h44V53"/><path d="M44 74V61h12v13"/></g>`));

App.define('marketplace', {
  name: 'Marketplace', category: 'Compras', needs: ['photos'],
  actions: [{ label: 'Novo anúncio', icon: 'compose', onTap: () => { System.openApp('marketplace'); setTimeout(() => Bridge.emit('market:compose'), 350); } }],
  open(win) {
    const g = UI.g; const CATS = ['Todos', 'Veículos', 'Imóveis', 'Eletrónica', 'Roupa', 'Outros']; let tabs, cat = 'Todos', q = '';
    /* o `mine` é calculado no servidor (server/marketplace.lua:797) e o `owner` - o citizenid do
       vendedor - deixou de sair nas respostas de propósito. O número fica como rede de segurança para
       um servidor antigo; sozinho tirava o menu de gestão a quem trocasse de SIM. */
    const isMine = l => l.mine === true || l.seller_phone === System.player.phone;
    /* cartão da grelha (Facebook Marketplace): foto quadrada, preço, título, meta. A fotografia vai
       pelo CSSOM - pode ser base64 de um veículo e não passa pelo parser de HTML. */
    const card = l => { const c = UI.el(`<div class="mk-card ${l.sold ? 'sold' : ''}"><div class="mk-thumb">${l.sold ? '<span class="mk-sold">VENDIDO</span>' : ''}</div><div class="mk-body"><div class="mk-price">${UI.money(l.price)}</div><div class="mk-title">${UI.esc(l.title)}</div><div class="mk-meta">${UI.esc(window.L && L.t ? L.t(l.category) : l.category)} · ${UI.rel(l.created)}</div></div></div>`);
      c.querySelector('.mk-thumb').style.backgroundImage = UI.img(l.image || 7);
      c.onclick = () => detail(l); UI.longPress(c, () => ctx(l, c)); return c; };
    /* ---------- custódia de itens (server/marketplace.lua, ItemEscrow) ----------
       Um anúncio de ITEM guarda o item fora do inventário do vendedor e a compra entrega-o sozinha.
       Pergunta-se ao servidor se as retenções estão ligadas (Config.Marketplace.transferItems) para
       só prometer "o item sai do teu inventário" quando for verdade; sem resposta assume-se ligada,
       como a omissão do servidor. */
    let escP = null; const escOn = () => escP || (escP = Promise.resolve(Bridge.rpc('escrow.config')).then(r => !(r && r.market === false), () => true));
    /* o que aconteceu ao item, dito ao jogador (resposta { status: given|returned|pending, reason, count }) */
    const itemMsg = it => it.status === 'given' ? 'Já está no teu inventário.'
      : it.status === 'returned' ? (it.count > 1 ? `${it.count} unidades voltaram ao teu inventário.` : 'O item voltou ao teu inventário.')
      : it.reason === 'offline' ? 'Vai para o teu inventário quando entrares.' : 'Vai para o teu inventário quando houver espaço.';
    const ESC_ERR = { noitem: 'Já não tens esse item (ou não chega para a quantidade).', noinv: 'Inventário indisponível.', invfull: 'Inventário cheio.', escrow: 'Não consegui guardar o item em custódia. Tenta outra vez.', busy: 'O anúncio está a ser alterado. Tenta outra vez.' };
    /* passar o elemento: sem alvo, o menu de contexto cai na posição de recurso (20,200) e nascia sempre no canto superior esquerdo */
    const ctx = (l, el) => UI.ctxMenu(el || null, isMine(l) ? [{ label: 'Editar', icon: 'pen', onTap: () => compose(l) }, { label: l.sold ? 'Marcar como disponível' : 'Marcar como vendido', icon: 'check', onTap: async () => { const r = await Bridge.rpcRaw('market.update', { id: l.id, sold: !l.sold });
        /* vendido pela app (já pago) não volta a estar à venda */
        if (r && r.error === 'sold') UI.alert({ title: 'Já foi vendido', msg: 'Este artigo foi comprado pela app e não pode voltar a estar à venda.' });
        /* voltar a pôr à venda um item em custódia tira-o outra vez do inventário, e o vendedor pode já não o ter */
        else if (r && r.error) UI.alert({ title: 'Erro', msg: ESC_ERR[r.error] || 'Não foi possível guardar.' });
        /* vendido fora da app: o item em custódia volta ao vendedor */
        else if (r && r.item) UI.toast(itemMsg(r.item));
        refresh(); } },
      { label: 'Apagar anúncio', icon: 'trash', danger: true, onTap: async () => { if (await UI.confirm('Apagar anúncio', l.title, 'Apagar', true)) { const r = await Bridge.rpcRaw('market.delete', { id: l.id }); if (r && r.item) UI.toast(itemMsg(r.item)); refresh(); } } }] : [{ label: 'Mensagem ao vendedor', icon: 'message', onTap: () => Msgs.open(l.seller_phone, l.seller_name) }, { label: 'Partilhar', icon: 'share', onTap: () => shareListing(l) }]);
    /* partilhar = mandar o anúncio (título, preço, número do vendedor) por mensagem a um contacto; o "Ligação copiada" de antes não copiava nada */
    async function shareListing(l) { const c = await Contacts.pick('Partilhar anúncio com'); if (!c) return; const r = await Bridge.rpcRaw('messages.send', { to: c.number, type: 'text', content: `🛒 Marketplace: ${l.title} · ${UI.money(l.price)}${l.seller_phone ? ' · vendedor ' + UI.phone(l.seller_phone) : ''}` }); if (!r || r.error) { Sound.play('error'); UI.toast('Não consegui enviar'); return; } UI.toast('Enviado a ' + (c.name || c.number)); }
    const refresh = () => tabs && tabs.go(tabs.cur);
    function detail(l) {
      const v = UI.view({ title: '', back: 'Marketplace', cls: 'mk-det', right: isMine(l) ? [{ icon: 'more', onTap: b => ctx(l, b) }] : [{ icon: 'share', onTap: () => shareListing(l) }] });
      const top = UI.el(`<div class="mk-top"><div class="mk-hero">${l.sold ? '<span class="mk-sold big">VENDIDO</span>' : ''}</div><div class="mk-info"><div class="mk-price big">${UI.money(l.price)}</div><h2>${UI.esc(l.title)}</h2><div class="muted">${UI.esc(l.category)} · publicado ${UI.rel(l.created)}</div><p>${UI.esc(l.description || '')}</p></div></div>`);
      top.querySelector('.mk-hero').style.backgroundImage = UI.img(l.image || 7);   /* pelo CSSOM, nunca na string de HTML */
      v.content.appendChild(top);
      v.content.appendChild(UI.list([{ header: 'Vendedor', items: [{ avatar: { name: l.seller_name || l.seller_phone }, label: l.seller_name || l.seller_phone, sub: l.seller_phone, chevron: false }] }]));
      if (!isMine(l) && !l.sold) { const row = UI.el(`<div class="mk-actions"><div class="btn-p btn-s msg">${g('message', 21)} Mensagem</div><div class="btn-p btn-s call">${g('phone', 21)} Ligar</div></div>`); row.querySelector('.msg').onclick = () => Msgs.open(l.seller_phone, l.seller_name); row.querySelector('.call').onclick = () => PhoneApp.call(l.seller_phone, l.seller_name); v.content.appendChild(row);
        const buy = UI.el(`<div class="btn-p green">${g('card', 21)} Comprar por ${UI.money(l.price)}</div>`); buy.onclick = async () => {
          /* sem rede o pagamento nunca sai daqui: mais vale dizê-lo antes de pedir a confirmação da compra */
          if (window.CC && CC.requireNet && !CC.requireNet('comprar')) return;
          /* item em custódia: diz-se já na confirmação que chega sozinho ao inventário (anúncios antigos: entrega combinada, texto de sempre) */
          const esc = l.kind === 'item' && l.escrow, qty = esc && l.item_count > 1 ? l.item_count + '× ' : '';
          if (!await UI.confirm('Comprar', `${l.title} por ${UI.money(l.price)}. O valor é debitado da tua conta bancária.${esc ? ` Recebes ${qty}o item no inventário.` : ''}`, 'Comprar')) return; /* price = o que o comprador viu e aceitou: se o vendedor o mudou entretanto o servidor recusa com 'changed' (rpcRaw para não perder o código) */
          const r = await Bridge.rpcRaw('market.buy', { id: l.id, price: l.price }); if (!r || !r.ok) { const why = { funds: 'Saldo insuficiente.', sold: 'Este artigo já foi vendido.', changed: 'O vendedor alterou o preço, abre o anúncio de novo.', self: 'Não podes comprar o teu próprio anúncio.', escrow: 'O item deste anúncio não está disponível agora. Tenta daqui a pouco.', busy: 'O vendedor está a alterar o anúncio. Tenta outra vez.' }; UI.alert({ title: 'Compra falhou', msg: why[r && r.error] || 'Tenta novamente.' }); Sound.play('error'); if (r && (r.error === 'changed' || r.error === 'sold')) { UI.pop(win); refresh(); } return; } Sound.play('success');
          /* entrega pendente (inventário cheio): um banner passava depressa, por isso vai num alerta */
          if (r.item && r.item.status !== 'given') UI.alert({ title: 'Compra efetuada', msg: `${l.title}. ${itemMsg(r.item)}` });
          else UI.banner({ app: 'marketplace', title: 'Compra efetuada', msg: r.item ? `${l.title} · já está no teu inventário` : l.title });
          await Bridge.rpc('messages.send', { to: l.seller_phone, type: 'text', content: `🛒 Comprei o teu anúncio "${l.title}" por ${UI.money(l.price)}.` }).catch(() => {}); UI.pop(win); refresh(); }; v.content.appendChild(buy); }
      if (isMine(l)) { const e = UI.el('<div class="btn-p btn-s">Editar anúncio</div>'); e.onclick = () => compose(l); v.content.appendChild(e); }
      UI.push(win, v);
    }
    /* ---------- escolher um item do inventário ----------
       O anúncio de um ITEM vai buscar a fotografia ao próprio inventário (nui://ox_inventory/…),
       por isso ninguém tem de fotografar nada. Veículos (e "outro") continuam a pedir foto da galeria. */
    async function pickItem() {
      const list = await Bridge.rpc('inventory.items');
      if (!list || list.error) { UI.alert({ title: 'Inventário indisponível', msg: 'Não consegui ler o teu inventário neste servidor.' }); return null; }
      if (!list.length) { UI.alert({ title: 'Inventário vazio', msg: 'Não tens nada para vender.' }); return null; }
      return new Promise(res => {
        const body = UI.el('<div class="mk-items"></div>');
        list.forEach(it => {
          const row = UI.el(`<div class="mk-item"><div class="im" style="background-image:${UI.img(it.image)}"></div><div class="bd"><b>${UI.esc(it.label)}</b><span class="muted small">${it.count}× · ${UI.esc(it.name)}</span></div></div>`);
          /* res ANTES de close(): o onClose corre de forma síncrona e resolveria undefined */
          row.onclick = () => { res(it); sh.close(); };
          body.appendChild(row);
        });
        const sh = UI.sheet({ title: 'O que estás a vender?', right: 'Cancelar', body, onClose: () => res(null) });
      });
    }

    const KINDS = [['item', 'Item'], ['vehicle', 'Veículo'], ['other', 'Outro']];

    async function compose(l) {
      let image = l ? l.image : null;
      let kind = l ? (l.kind || 'other') : 'item';
      let itemName = l ? (l.item_name || null) : null;
      let category = l ? l.category : 'Outros';
      let picked = null, escOk = false;   /* picked = item escolhido agora (traz quantas unidades o jogador tem) */

      /* .mk-esc e .mk-qty só aparecem quando o item vai mesmo para a custódia (ver custodial) */
      const body = UI.el(`<div><div class="seg mk-kind" style="margin:0 0 12px"></div><div class="mk-photo"></div><div class="muted small mk-esc" style="margin:10px 16px 0;text-align:center;display:none">O item sai do teu inventário enquanto o anúncio estiver ativo.</div><div class="group" style="margin-top:12px"><div class="li static"><input type="text" class="t" placeholder="Título" maxlength="60" value="${UI.esc(l ? l.title : '')}"></div><div class="li static"><span class="muted" style="width:80px">Preço ${UI.esc(UI.cur())}</span><input type="number" class="p" placeholder="0" value="${l ? l.price : ''}"></div><div class="li static mk-qty" style="display:none"><span class="muted" style="width:80px">Quantidade</span><input type="number" class="n" min="1" step="1" placeholder="1" value="${l && l.item_count ? l.item_count : 1}"></div><div class="li cat"><span>Categoria</span><span class="li-value">${category}</span></div></div><div class="group" style="margin-top:12px;padding:12px"><textarea class="ta d" style="min-height:120px" placeholder="Descrição (estado, quilómetros, extras…)">${UI.esc(l ? l.description : '')}</textarea></div></div>`);
      /* o item só sai do inventário se as retenções estiverem ligadas e o anúncio for novo, já estiver em
         custódia, ou mudar de item; um anúncio de item antigo com o mesmo item fica com entrega combinada */
      const custodial = () => kind === 'item' && escOk && (!l || l.escrow || l.custody || l.kind !== 'item' || itemName !== l.item_name);
      const paintEsc = () => { const on = custodial(); body.querySelector('.mk-esc').style.display = on ? '' : 'none'; body.querySelector('.mk-qty').style.display = on ? '' : 'none'; };
      escOn().then(v => { escOk = v; paintEsc(); });

      const photo = body.querySelector('.mk-photo');
      const paintPhoto = () => {
        photo.style.backgroundImage = image ? UI.img(image) : 'none';
        photo.classList.toggle('item', kind === 'item');
        photo.innerHTML = image ? '' : (kind === 'item'
          ? g('cart', 44) + '<span>Escolher do inventário</span>'
          : g('camera', 44) + '<span>Adicionar foto</span>');
      };
      const setKind = k => {
        kind = k;
        if (k === 'vehicle' && (category === 'Outros' || !category)) { category = 'Veículos'; body.querySelector('.cat .li-value').textContent = category; }
        /* trocar de tipo larga a imagem anterior: uma foto de carro não serve para um item e vice-versa */
        if (k !== 'item') itemName = null;
        image = l && (l.kind || 'other') === k ? l.image : null;
        paintPhoto(); paintEsc();
      };
      body.querySelector('.mk-kind').replaceWith(UI.seg(KINDS.map(x => x[1]), Math.max(0, KINDS.findIndex(x => x[0] === kind)), i => setKind(KINDS[i][0])));
      paintPhoto();

      photo.onclick = async () => {
        if (kind === 'item') {
          const it = await pickItem();
          if (!it) return;
          itemName = it.name; image = it.image; picked = it;
          const t = body.querySelector('.t'); if (!t.value.trim()) t.value = it.label;
          paintPhoto(); paintEsc();
          return;
        }
        const p = await Photos.pick('Foto do anúncio');
        if (p) { image = p.url || p.seed; paintPhoto(); }
      };
      body.querySelector('.cat').onclick = async () => { const c = await UI.picker('Categoria', CATS.slice(1), category); if (c) { category = c; body.querySelector('.cat .li-value').textContent = c; } };

      UI.sheet({ title: l ? 'Editar anúncio' : 'Novo anúncio', left: 'Cancelar', right: 'Publicar', body, onDone: () => { const title = body.querySelector('.t').value.trim(), price = Math.floor(+body.querySelector('.p').value), description = body.querySelector('.d').value.trim(); if (!title || !(price > 0)) { UI.toast('Título e preço obrigatórios'); return false; }
        if (kind === 'item' && !itemName) { UI.toast('Escolhe o item do inventário'); return false; }
        if (kind === 'vehicle' && !image) { UI.toast('Um veículo precisa de fotografia'); return false; }
        const payload = { title, price, description, category, image, kind, item_name: itemName };
        if (custodial()) {
          const n = Math.floor(+body.querySelector('.n').value || 1);
          if (!(n >= 1)) { UI.toast('Quantidade inválida'); return false; }
          /* só dá para verificar aqui quando o item foi escolhido agora; o servidor confirma sempre. Num anúncio
             já em custódia com o MESMO item só sai do inventário a diferença (as unidades guardadas já não estão lá) */
          const kept = l && l.escrow && itemName === l.item_name ? (+l.item_count || 0) : 0;
          if (picked && n - kept > picked.count) { UI.toast(`Só tens ${picked.count}× ${picked.label}`); return false; }
          payload.item_count = n;
        }
        /* `return false` mantém a folha aberta: sem rede o anúncio não se perde, é só voltar a tocar em Publicar */
        if (window.CC && CC.requireNet && !CC.requireNet(l ? 'guardar o anúncio' : 'publicar o anúncio')) return false;
        /* rpcRaw: os códigos do servidor (toolarge, noinv, …) dizem ao jogador o que corrigir */
        (l ? Bridge.rpcRaw('market.update', Object.assign({ id: l.id }, payload)) : Bridge.rpcRaw('market.create', payload)).then(r => { if (r && !r.error) { Sound.play('success'); UI.toast((l ? 'Anúncio atualizado' : 'Anúncio publicado') + (r.item ? ' · ' + itemMsg(r.item) : '')); tabs.go(1); } else { const why = Object.assign({}, ESC_ERR, { toolarge: 'Imagem demasiado grande.', invalid: 'Verifica o título, o preço e a quantidade.', sold: 'Este artigo já foi vendido pela app.' }); UI.alert({ title: 'Erro', msg: why[r && r.error] || 'Não foi possível guardar.' }); } }); } });
    }
    const home = () => { const v = UI.view({ title: 'Marketplace', large: true, cls: 'mk-v', right: [{ icon: 'compose', cls: 'glass', onTap: () => compose() }] });
      let sT = null; const s = UI.search('Pesquisar anúncios ou números', x => { q = x; clearTimeout(sT); sT = setTimeout(load, 250); });   /* sem atraso era um RPC por tecla */
      v.content.appendChild(s); v.content.appendChild(UI.chips(CATS, CATS.indexOf(cat), (i, c) => { cat = c; load(); })); const holder = UI.el('<div class="mk-list"></div>'); v.content.appendChild(holder);
      v.opts.onPop = () => clearTimeout(sT);
      const load = async () => { if (!holder.firstElementChild) holder.appendChild(UI.spinner()); const l = (await Bridge.rpc('market.list', { q, category: cat === 'Todos' ? null : cat })) || []; holder.innerHTML = ''; holder.classList.toggle('is-empty', !l.length); if (!l.length) { holder.appendChild(UI.empty('cart', 'Sem anúncios', q ? 'Nada encontrado para a tua pesquisa.' : 'Sê o primeiro a publicar.')); return; } l.forEach(x => holder.appendChild(card(x))); }; load(); return v; };
    const mine = () => { const v = UI.view({ title: 'Os meus anúncios', large: true, cls: 'mk-v', right: [{ icon: 'compose', cls: 'glass', onTap: () => compose() }] }); const holder = UI.el('<div class="mk-list"></div>'); v.content.appendChild(holder); holder.appendChild(UI.spinner());
      Bridge.rpc('market.mine').then(l => { holder.innerHTML = ''; l = l || []; holder.classList.toggle('is-empty', !l.length); if (!l.length) { holder.appendChild(UI.empty('tag', 'Ainda não publicaste nada', 'Cria um anúncio para vender.')); return; } l.forEach(x => holder.appendChild(card(x))); }); return v; };
    tabs = UI.tabbar(win, [{ icon: 'cart', label: 'Início', view: home }, { icon: 'tag', label: 'Anúncios', view: mine }], 0);
    const off = Bridge.on('market:compose', () => compose()); win.onClose = off;
  }
});
Bridge.on('market', d => { if (!d) return; Notify.push({ app: 'marketplace', title: d.title || 'Marketplace', msg: d.msg || '', onTap: () => System.openApp('marketplace') }); });

/* ---------- fallback browser ---------- */
if (window.LocalDB && LocalDB.register) (() => {
  const T = () => LocalDB.T('market'); const me = () => LocalDB.player();
  const seed = () => { if (T().all().length) return; const t = Date.now(); [['X80 Proto', 'X80 Proto, branco com detalhes vermelhos. Conduzido com cuidado, em estado impecável.', 2000000, 'Veículos', 121, 'Rui Taxista', '555-0303'], ['Banshee', 'Vendo o meu Bravado Banshee de 2020, poucos quilómetros e em perfeito estado. Preço negociável.', 74999, 'Veículos', 88, 'Ana Advogada', '555-0420'], ['Sanchez, modelo 2018', 'Sanchez de 2018, poucos quilómetros. Preço negociável.', 1999, 'Veículos', 43, 'Oficina Benny', '555-0666'], ['Dominator', 'Vapid Dominator preto, motor revisto.', 42000, 'Veículos', 200, 'Garagem Central', '555-0177'], ['Apartamento Alta Street', 'T2 com vista para a cidade, garagem incluída.', 320000, 'Imóveis', 301, 'Ana Advogada', '555-0420'], ['iFruit 17', 'Novo, selado.', 1200, 'Eletrónica', 157, 'Mãe', '555-0101']].forEach(([title, description, price, category, image, seller_name, seller_phone], i) => T().insert({ owner: 'npc' + i, seller_name, seller_phone, title, description, price, category, image, sold: false, buyer: null, created: t - i * 7 * 36e5 })); };
  const mine = l => l.owner === 'DEV0000';

  /* ---------- inventário e custódia de mentira ----------
     No browser não há ox_inventory: o inventário do DEV0000 vive numa tabela e a custódia segue o mesmo
     ciclo do server/marketplace.lua (held → given ao comprador / returned ao dono). Fica exposta em
     LocalDB.escrowMock para o onion.js (carregado depois) usar a mesma tabela. */
  const INV0 = [
    { name: 'phone', label: 'Telemóvel', count: 1, image: 'nui://ox_inventory/web/images/phone.png' },
    { name: 'water', label: 'Água', count: 4, image: 'nui://ox_inventory/web/images/water.png' },
    { name: 'lockpick', label: 'Gazua', count: 2, image: 'nui://ox_inventory/web/images/lockpick.png' },
    { name: 'radio', label: 'Rádio', count: 1, image: 'nui://ox_inventory/web/images/radio.png' },
  ];
  const Inv = () => { const t = LocalDB.T('mock_inventory'); if (!t.all().length) INV0.forEach(x => t.insert(Object.assign({}, x))); return t; };
  const invHave = name => { const r = Inv().all().find(x => x.name === name); return r ? r.count : 0; };
  const invAdd = (name, n) => { const t = Inv(), r = t.all().find(x => x.name === name); if (r) t.update(r.id, { count: r.count + n }); else t.insert({ name, label: name, count: n, image: 'nui://ox_inventory/web/images/' + name + '.png' }); };
  const E = () => LocalDB.T('item_escrow');
  const Esc = LocalDB.escrowMock = {
    E, invHave, invAdd,
    hold(source, ref, item, count) { count = Math.floor(+count || 1); if (!(count >= 1)) return { error: 'invalid' }; if (!item || invHave(item) < count) return { error: 'noitem' }; invAdd(item, -count); return E().insert({ source, ref_id: ref, owner: 'DEV0000', item, count, status: 'held', target: null }); },
    held: (source, ref) => E().all().filter(e => e.source === source && e.ref_id === ref && e.status === 'held' && !e.target && e.count > 0),
    managed: (source, ref) => E().all().some(e => e.source === source && e.ref_id === ref && (source === 'market' || !e.target)),
    /* só o DEV0000 tem inventário no browser: o que vai para um NPC fica apenas marcado */
    release(e, who, give) { E().update(e.id, give ? { status: 'given', target: who } : { status: 'returned' }); if (who === 'DEV0000') invAdd(e.item, e.count); return { status: give ? 'given' : 'returned', count: e.count, name: e.item, label: e.item }; },
    returnUnits(rows, units) { let left = units == null ? Infinity : units, n = 0, name = null;
      rows.slice().reverse().forEach(e => { if (left <= 0) return; const take = Math.min(left, e.count); let row = e;
        if (take < e.count) { E().update(e.id, { count: e.count - take }); row = E().insert(Object.assign({}, e, { id: undefined, count: take })); }
        Esc.release(row, row.owner, false); n += take; name = row.item; left -= take; });
      return n ? { status: 'returned', count: n, name, label: name } : null; },
  };
  /* `mine` como no servidor (marketplace.lua:797): o browser tem de exercitar o mesmo contrato, senão
     o menu de gestão dos próprios anúncios só se testava pelo número. O `owner` fica na linha do mock
     porque é ele a identidade interna da tabela de mentira (no jogo nunca sai do servidor). */
  const withEsc = l => { const h = Esc.held('market', l.id)[0]; return Object.assign({}, l, { mine: mine(l), escrow: !!h, item_count: h ? h.count : undefined, custody: Esc.managed('market', l.id) }); };

  LocalDB.register('escrow.config', () => ({ market: true, onion: true }));
  LocalDB.register('market.list', d => { seed(); return T().all().filter(l => (!d.category || l.category === d.category) && (!d.q || (l.title + ' ' + l.description + ' ' + l.seller_phone).toLowerCase().includes(d.q))).sort((a, b) => b.created - a.created).map(withEsc); });
  LocalDB.register('market.mine', () => { seed(); return T().all().filter(mine).sort((a, b) => b.created - a.created).map(withEsc); });
  LocalDB.register('market.get', d => { const l = T().all().find(x => x.id === d.id); return l ? withEsc(l) : null; });
  LocalDB.register('inventory.items', () => Inv().all().filter(x => x.count > 0).map(x => ({ name: x.name, label: x.label, count: x.count, image: x.image })));
  /* como o servidor: um anúncio de item só nasce se o item sair do inventário para a custódia */
  LocalDB.register('market.create', d => { const p = me(); const kind = d.kind === 'item' || d.kind === 'vehicle' ? d.kind : 'other';
    let hold = null; if (kind === 'item') { if (!d.item_name || invHave(d.item_name) <= 0) return { error: 'noitem' }; hold = Esc.hold('market', 0, d.item_name, d.item_count || 1); if (hold.error) return hold; }
    const row = T().insert({ owner: 'DEV0000', seller_name: p.firstname + ' ' + p.lastname, seller_phone: p.phone, title: d.title, description: d.description || '', price: Math.floor(d.price), category: d.category || 'Outros', image: d.image || null, sold: false, buyer: null, created: Date.now(), kind, item_name: kind === 'item' ? d.item_name : null });
    if (hold) E().update(hold.id, { ref_id: row.id });
    return Object.assign({}, row, { ok: true, escrow: !!hold, item_count: hold ? hold.count : undefined }); });
  LocalDB.register('market.update', d => { const l = T().all().find(x => x.id === d.id); if (!l || !mine(l)) return { error: 'forbidden' }; if (l.buyer && l.sold && d.sold === false) return { ok: false, error: 'sold' };
    const kind = d.kind || l.kind || 'other', item = kind === 'item' ? (d.item_name !== undefined ? d.item_name : l.item_name) : null, sold = d.sold !== undefined ? !!d.sold : !!l.sold;
    const held = Esc.held('market', l.id), keep = held[held.length - 1], want = d.item_count != null ? Math.floor(+d.item_count) : null; let back = null, fresh = null;
    if (!(l.buyer && l.sold)) {
      if (kind === 'item' && !sold) {
        if (keep && keep.item === item) { const n = want || keep.count;
          if (n > keep.count) { if (invHave(item) < n - keep.count) return { error: 'noitem' }; invAdd(item, -(n - keep.count)); E().update(keep.id, { count: n }); }
          else if (n < keep.count) back = Esc.returnUnits([keep], keep.count - n); }
        else if (keep || item !== l.item_name || l.kind !== 'item' || (l.sold && Esc.managed('market', l.id))) { fresh = Esc.hold('market', l.id, item, want || 1); if (fresh.error) return fresh; if (keep) back = Esc.returnUnits(held); }
      } else if (keep) back = Esc.returnUnits(held);
    }
    T().update(d.id, Object.fromEntries(Object.entries(d).filter(([k]) => ['title', 'description', 'price', 'category', 'image', 'sold', 'kind', 'item_name'].includes(k))));
    return Object.assign({ ok: true }, back ? { item: back } : {}, fresh ? { escrow: true, item_count: fresh.count } : {}); });
  LocalDB.register('market.delete', d => { const l = T().all().find(x => x.id === d.id); if (!l || !mine(l)) return { error: 'forbidden' }; const back = Esc.returnUnits(Esc.held('market', l.id)); T().remove(d.id); return back ? { ok: true, item: back } : { ok: true }; });
  /* como o server/marketplace.lua: o próprio anúncio dá 'self' e um preço diferente do que se viu dá 'changed'; o item em custódia segue para o comprador */
  LocalDB.register('market.buy', d => { const l = T().all().find(x => x.id === d.id); if (!l || l.sold) return { ok: false, error: 'sold' }; if (l.owner === 'DEV0000') return { ok: false, error: 'self' }; if (d.price != null && Number(d.price) !== Number(l.price)) return { ok: false, error: 'changed' }; const p = me(); if (p.money.bank < l.price) return { ok: false, error: 'funds' }; p.money.bank -= l.price; LocalDB.savePlayer(p); T().update(d.id, { sold: true, buyer: 'DEV0000' }); LocalDB.T('transactions').insert({ owner: 'DEV0000', description: 'Marketplace: ' + l.title, amount: -l.price, created: Date.now() });
    const h = Esc.held('market', l.id)[0]; return h ? { ok: true, bank: p.money.bank, item: Esc.release(h, 'DEV0000', true) } : { ok: true, bank: p.money.bank }; });
})();
