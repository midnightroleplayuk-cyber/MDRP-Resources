/* =====================================================================
   ONION - mercado anónimo (deep web) para roleplay.
   Identidade anónima gerada pelo servidor (nunca mostra o nome nem o número do jogador),
   preços em cripto (₿), pagamento em DEPÓSITO DE GARANTIA (escrow): o comprador paga,
   o vendedor envia, o comprador confirma e só aí o dinheiro sai do depósito e a reputação sobe.
   Itens: um anúncio de ITEM guarda em custódia uma unidade por cada uma em stock (server/marketplace.lua,
   ItemEscrow); a compra reserva uma, "enviado" entrega-a no inventário do comprador. Anúncios antigos,
   sem custódia, continuam com a entrega feita pelos jogadores no jogo.
   Estética: preto/verde-fósforo, tipo terminal, mas com os componentes do sistema (UI.view/list/sheet).
   ===================================================================== */
Icons.app.onion = () => Icons.SVG(Icons.G('gOn', '#3A2350', '#1E1233', '#0A0612') + Icons.GL(
  `<g fill="none" stroke="#7CFF9B" stroke-width="5" stroke-linecap="round"><circle cx="50" cy="50" r="9"/><path d="M50 24c14.4 0 26 11.6 26 26S64.4 76 50 76 24 64.4 24 50s11.6-26 26-26Z" opacity=".85"/><path d="M50 38c6.6 0 12 5.4 12 12s-5.4 12-12 12-12-5.4-12-12 5.4-12 12-12Z" opacity=".55"/></g>`));

App.define('onion', {
  name: 'Onion', category: 'Anónimo', statusBar: 'dark',
  actions: [{ label: 'Novo anúncio', icon: 'compose', onTap: () => { System.openApp('onion'); setTimeout(() => Bridge.emit('onion:compose'), 350); } }],
  open(win) {
    const g = UI.g, esc = UI.esc; win.classList.add('onion');
    /* Alertas, folhas, menus e toasts sao montados no #screen, FORA da janela, por isso nao apanhavam o tema escuro da app.
       Estes atalhos passam a classe 'onion' ao involucro do overlay (ver o passe-through em ui.js). */
    const sheet = o => UI.sheet(Object.assign({}, o, { cls: 'onion' }));
    const alert = o => UI.alert(Object.assign({}, o, { cls: 'onion' }));
    const actionSheet = o => UI.actionSheet(Object.assign({}, o, { cls: 'onion' }));
    const confirm = (ti, m, ok, dg) => UI.confirm(ti, m, ok, dg, 'onion');
    const picker = (ti, opts, cur) => UI.picker(ti, opts, cur, 'onion');
    const toast = (m, ms) => UI.toast(m, ms, 'onion');
    const ctxMenu = (target, items) => UI.ctxMenu(target, items, { cls: 'onion' });   /* NÃO usar 'on': é a classe de "selecionado" em todo o telemóvel e o tema escuro vazava para outras apps */
    const CATS = ['Tudo', 'Documentos', 'Eletrónica', 'Peças', 'Serviços', 'Diversos'];
    let tabs, cat = 'Tudo', q = '', me = { handle: '…', rep: 0, sales: 0, since: Date.now() };

    /* ---------- formatação ---------- */
    const btc = n => (Math.round((+n || 0) * 1e4) / 1e4).toFixed(4).replace('.', ',') + ' ₿';
    const stars = r => { const n = Math.round((+r || 0) * 2) / 2; let s = ''; for (let i = 1; i <= 5; i++) s += `<i class="${n >= i ? 'on' : n >= i - .5 ? 'half' : ''}">${g(n >= i ? 'starFill' : 'star', 19)}</i>`; return `<span class="on-stars">${s}</span>`; };
    const ST = { pago: ['Pago · à espera de envio', 'wait'], enviado: ['Enviado · a caminho', 'ship'], concluido: ['Concluído', 'done'], cancelado: ['Cancelado', 'bad'] };

    /* ---------- custódia de itens ----------
       O servidor diz se as retenções estão ligadas (Config.Onion.transferItems) para a app só prometer
       "o item sai do teu inventário" quando for verdade; sem resposta assume-se ligada, como o servidor. */
    let escP = null; const escOn = () => escP || (escP = Promise.resolve(Bridge.rpc('escrow.config')).then(r => !(r && r.onion === false), () => true));
    const itemMsg = it => it.status === 'given' ? 'Já está no teu inventário.'
      : it.status === 'returned' ? (it.count > 1 ? `${it.count} unidades voltaram ao teu inventário.` : 'O item voltou ao teu inventário.')
      : it.reason === 'offline' ? 'Vai para o teu inventário quando entrares.' : 'Vai para o teu inventário quando houver espaço.';
    const ESC_ERR = { noitem: 'Já não tens esse item (ou não chega para o stock).', noinv: 'Inventário indisponível.', invfull: 'Inventário cheio.', escrow: 'Não consegui guardar o item em custódia. Tenta outra vez.', busy: 'O anúncio está a ser alterado. Tenta outra vez.' };

    /* ---------- animação de "ligação anónima" (primeira abertura da sessão) ----------
       É só cenário de roleplay: não há circuito nem cifragem nenhuma, os pedidos seguem pelo RPC normal.
       Por isso nenhum passo afirma que cifra (regra de honestidade do projeto). */
    const HOPS = ['a negociar circuito', 'a saltar para o nó de entrada', 'ligação anónima simulada', 'ligado'];
    function connect(done) {
      if (win._linked) { done(); return; }
      const v = UI.view({ title: '', full: true, solid: true, cls: 'on-boot' });
      const box = UI.el(`<div class="on-boot-b"><div class="on-orb">${g('globe', 50)}</div><div class="on-boot-t">A estabelecer ligação anónima</div><div class="on-hops"></div></div>`);
      const hops = box.querySelector('.on-hops'); v.content.appendChild(box); UI.setRoot(win, v);
      let i = 0; const step = () => { if (!v.isConnected) return; if (i >= HOPS.length) { win._linked = true; done(); return; }
        const line = UI.el(`<div class="on-hop"><i></i><span>${esc(HOPS[i])}</span></div>`); hops.appendChild(line); requestAnimationFrame(() => line.classList.add('in'));
        if (i === HOPS.length - 1) line.classList.add('ok'); i++; setTimeout(step, i === HOPS.length ? 420 : 300); };
      setTimeout(step, 260);
    }

    /* ---------- cartão de anúncio ---------- */
    /* a fotografia vai pelo CSSOM (el.style), NUNCA dentro da string de HTML: o onion.list traz até
       200 KB de base64 por anúncio e cada cartão obrigava o parser de HTML a atravessá-los (como no
       Marketplace, que já o faz assim) */
    const card = l => {
      const c = UI.el(`<div class="on-card ${l.stock <= 0 ? 'out' : ''}">
        <div class="on-thumb">${l.image ? '<div class="on-img"></div>' : g('cart', 36)}</div>
        <div class="on-cb"><div class="on-ct">${esc(l.title)}</div>
          <div class="on-cs">${esc(l.seller_handle)} ${stars(l.seller_rep)}</div>
          <div class="on-cm"><b class="on-price">${btc(l.price)}</b><span>${l.stock > 0 ? l.stock + ' em stock' : 'esgotado'}</span></div></div></div>`);
      if (l.image) c.querySelector('.on-img').style.backgroundImage = UI.img(l.image);
      c.onclick = () => detail(l); if (l.mine) UI.longPress(c, () => ctx(l, c)); return c;
    };
    /* passar o elemento: sem alvo o menu nasce na posição de recurso (20,200), desligado do cartão tocado */
    const ctx = (l, el) => ctxMenu(el || null, [
      { label: 'Editar', icon: 'pen', onTap: () => compose(l) },
      /* as unidades ainda em stock na custódia voltam ao inventário do vendedor */
      { label: 'Apagar anúncio', icon: 'trash', danger: true, onTap: async () => { if (await confirm('Apagar anúncio', l.title, 'Apagar', true)) { const r = await Bridge.rpcRaw('onion.delete', { id: l.id }); if (r && r.item) toast(itemMsg(r.item)); reload(); } } }]);
    const reload = () => tabs && tabs.go(tabs.cur);

    /* ---------- detalhe + compra com depósito de garantia ---------- */
    function detail(l) {
      const v = UI.view({ title: '', back: 'Onion', cls: 'on-detail', right: l.mine ? [{ icon: 'more', onTap: b => ctx(l, b) }] : null });
      /* um só elemento de raiz (UI.el devolve apenas o primeiro filho) */
      const top = UI.el(`<div><div class="on-hero">${l.image ? '<div class="on-img"></div>' : g('cart', 64)}</div>
        <div class="on-head"><h2>${esc(l.title)}</h2><div class="on-price big">${btc(l.price)}</div>
        <div class="on-tags"><span>${esc(l.category)}</span><span>${l.stock > 0 ? l.stock + ' em stock' : 'esgotado'}</span></div>
        <p>${esc(l.description || 'Sem descrição.')}</p></div></div>`);
      if (l.image) top.querySelector('.on-img').style.backgroundImage = UI.img(l.image);   /* pelo CSSOM, nunca na string de HTML */
      v.content.appendChild(top);
      v.content.appendChild(UI.list([{ header: 'Vendedor', items: [
        { icon: 'ghost', iconBg: '#12301F', iconColor: '#7CFF9B', label: l.seller_handle, sub: `${l.seller_sales || 0} vendas`, right: UI.el(`<div class="li-value">${stars(l.seller_rep)}</div>`), chevron: false }] },
        { footer: 'O pagamento fica em depósito de garantia. O vendedor só o recebe quando confirmares a entrega.' }]));
      if (!l.mine && l.stock > 0) {
        const b = UI.el(`<div class="btn-p on-buy">${g('lock', 20)} Comprar por ${btc(l.price)}</div>`);
        b.onclick = async () => {
          /* unidades em custódia: a compra reserva uma e o envio põe-na no inventário (anúncios antigos: texto de sempre) */
          if (!await confirm('Confirmar compra', `${l.title}\n${btc(l.price)} ficam em depósito até confirmares a entrega.${l.escrow ? '\nRecebes o item no inventário quando o vendedor o enviar.' : ''}`, 'Pagar')) return;
          /* price = o que o comprador viu: se o vendedor o mudou o servidor recusa com 'changed' (rpcRaw guarda o código) */
          const r = await Bridge.rpcRaw('onion.buy', { id: l.id, price: l.price });
          if (!r || !r.ok) { Sound.play('error'); const why = { funds: 'Saldo de cripto insuficiente. Compra cripto na app Cripto.', stock: 'Este artigo esgotou.', own: 'Não podes comprar o teu próprio anúncio.', changed: 'O vendedor alterou o preço, abre o anúncio de novo.', gone: 'Este anúncio já não existe.', busy: 'O vendedor está a alterar o anúncio. Tenta outra vez.' }; alert({ title: 'Compra falhou', msg: why[r && r.error] || 'Tenta novamente.' }); if (r && (r.error === 'changed' || r.error === 'gone')) { UI.pop(win); reload(); } return; }
          Sound.play('success'); toast(r.item ? 'Pago. O item fica reservado para ti até ao envio.' : 'Pago. Em depósito de garantia.'); UI.pop(win); tabs.go(2);
        };
        v.content.appendChild(b);
      }
      UI.push(win, v);
    }

    /* ---------- publicar / editar ---------- */
    /* escolher um item do inventário: o anúncio de um ITEM usa a imagem do próprio
       inventário; veículo (ou "outro") pede imagem da galeria. Mesmo RPC do Marketplace. */
    async function pickItem() {
      const list = await Bridge.rpc('inventory.items');
      if (!list || list.error) { alert({ title: 'Inventário indisponível', msg: 'Não consegui ler o teu inventário neste servidor.' }); return null; }
      if (!list.length) { alert({ title: 'Inventário vazio', msg: 'Não tens nada para vender.' }); return null; }
      return new Promise(res => {
        const body = UI.el('<div class="mk-items"></div>');
        list.forEach(it => {
          const row = UI.el(`<div class="mk-item"><div class="im" style="background-image:${UI.img(it.image)}"></div><div class="bd"><b>${esc(it.label)}</b><span class="muted small">${it.count}× · ${esc(it.name)}</span></div></div>`);
          row.onclick = () => { res(it); sh.close(); };   /* res ANTES de close() */
          body.appendChild(row);
        });
        const sh = sheet({ title: 'O que estás a vender?', right: 'Cancelar', body, onClose: () => res(null) });
      });
    }
    const KINDS = [['item', 'Item'], ['vehicle', 'Veículo'], ['other', 'Outro']];

    async function compose(l) {
      let image = l ? l.image : null, category = l ? l.category : 'Documentos';
      let kind = l ? (l.kind || 'other') : 'item';
      let itemName = l ? (l.item_name || null) : null;
      let picked = null, escOk = false;   /* picked = item escolhido agora (traz quantas unidades o jogador tem) */
      const body = UI.el(`<div class="on-form">
        <div class="seg on-kind" style="margin:0 0 12px"></div>
        <div class="on-photo"></div>
        <div class="muted small on-esc" style="margin:10px var(--margin) 0;text-align:center;display:none">O item sai do teu inventário enquanto o anúncio estiver ativo: uma unidade por cada uma em stock.</div>
        <div class="group"><div class="li static"><input type="text" class="t" placeholder="Título" maxlength="60" value="${esc(l ? l.title : '')}"></div>
          <div class="li static"><span class="muted" style="width:74px">Preço ₿</span><input type="number" step="0.0001" class="p" placeholder="0,0000" value="${l ? l.price : ''}"></div>
          <div class="li static"><span class="muted" style="width:74px">Stock</span><input type="number" class="s" placeholder="1" value="${l ? l.stock : 1}"></div>
          <div class="li cat"><span>Categoria</span><span class="li-value">${category}</span></div></div>
        <div class="group" style="padding:12px"><textarea class="ta d" style="min-height:110px" placeholder="Descrição. Não escrevas nada que te identifique.">${esc(l ? l.description : '')}</textarea></div></div>`);
      const photo = body.querySelector('.on-photo');
      const paintPhoto = () => {
        photo.style.backgroundImage = image ? UI.img(image) : 'none';
        photo.classList.toggle('item', kind === 'item');
        photo.innerHTML = image ? '' : (kind === 'item' ? g('cart', 42) + '<span>Escolher do inventário</span>' : g('image', 42) + '<span>Imagem (opcional)</span>');
      };
      /* o stock só vai para a custódia com as retenções ligadas e num anúncio novo, já em custódia, ou
         que mude de item; um anúncio de item antigo com o mesmo item fica com entrega combinada */
      const custodial = () => kind === 'item' && escOk && (!l || l.custody || l.escrow || l.kind !== 'item' || itemName !== l.item_name);
      const paintEsc = () => { body.querySelector('.on-esc').style.display = custodial() ? '' : 'none'; };
      escOn().then(v => { escOk = v; paintEsc(); });
      const setKind = k => { kind = k; if (k !== 'item') itemName = null; image = l && (l.kind || 'other') === k ? l.image : null; paintPhoto(); paintEsc(); };
      body.querySelector('.on-kind').replaceWith(UI.seg(KINDS.map(x => x[1]), Math.max(0, KINDS.findIndex(x => x[0] === kind)), i => setKind(KINDS[i][0])));
      paintPhoto();
      photo.onclick = async () => {
        if (kind === 'item') {
          const it = await pickItem(); if (!it) return;
          itemName = it.name; image = it.image; picked = it;
          const t = body.querySelector('.t'); if (!t.value.trim()) t.value = it.label;
          paintPhoto(); paintEsc(); return;
        }
        const p = await Photos.pick('Imagem do anúncio');
        if (p) { image = p.url || p.seed; paintPhoto(); }
      };
      body.querySelector('.cat').onclick = async () => { const c = await picker('Categoria', CATS.slice(1), category); if (c) { category = c; body.querySelector('.cat .li-value').textContent = c; } };
      sheet({ title: l ? 'Editar anúncio' : 'Novo anúncio', left: 'Cancelar', right: 'Publicar', body, onDone: () => {
        const title = body.querySelector('.t').value.trim(), price = +body.querySelector('.p').value, stock = Math.max(1, Math.floor(+body.querySelector('.s').value || 1)), description = body.querySelector('.d').value.trim();
        if (!title || !(price > 0)) { toast('Título e preço são obrigatórios'); return false; }
        if (kind === 'item' && !itemName) { toast('Escolhe o item do inventário'); return false; }
        if (kind === 'vehicle' && !image) { toast('Um veículo precisa de imagem'); return false; }
        /* com custódia o stock sai todo do inventário: só dá para verificar aqui com o item escolhido agora (o servidor confirma sempre) */
        if (custodial() && picked && (!l || itemName !== l.item_name) && stock > picked.count) { toast(`Só tens ${picked.count}× ${picked.label} para o stock`); return false; }
        const payload = { title, price, stock, description, category, image, kind, item_name: itemName };
        /* rpcRaw: os códigos do servidor (toolarge, noinv, …) dizem ao jogador o que corrigir */
        (l ? Bridge.rpcRaw('onion.update', Object.assign({ id: l.id }, payload)) : Bridge.rpcRaw('onion.create', payload))
          .then(r => { if (r && !r.error) { Sound.play('success'); toast((l ? 'Anúncio atualizado' : 'Publicado') + (r.item ? ' · ' + itemMsg(r.item) : '')); tabs.go(1); } else { const why = Object.assign({}, ESC_ERR, { toolarge: 'Imagem demasiado grande.', invalid: 'Verifica o título, o preço e o stock.' }); alert({ title: 'Erro', msg: why[r && r.error] || 'Não foi possível guardar.' }); } });
      } });
    }

    /* ---------- vistas ---------- */
    const market = () => {
      const v = UI.view({ title: 'Onion', large: true, cls: 'on-market', right: [{ icon: 'compose', cls: 'glass', onTap: () => compose() }] });
      v.content.appendChild(UI.el('<div class="on-warn">Ligação encaminhada por três nós. Ninguém vê quem és.</div>'));
      let sT = null; v.content.appendChild(UI.search('Pesquisar no mercado', x => { q = x; clearTimeout(sT); sT = setTimeout(load, 250); }));   /* sem atraso era um RPC (e um spinner) por tecla */
      v.opts.onPop = () => clearTimeout(sT);   /* trocar de separador a meio da escrita não deixa sair um onion.list para uma lista já fora do ecrã */
      v.content.appendChild(UI.chips(CATS, CATS.indexOf(cat), (i, c) => { cat = c; load(); }));
      const holder = UI.el('<div class="on-list"></div>'); v.content.appendChild(holder);
      let seq = 0; const load = async () => { const my = ++seq; holder.innerHTML = ''; holder.appendChild(UI.spinner());   /* duas pesquisas em voo chegavam fora de ordem e a antiga apagava a recente */
        const l = (await Bridge.rpc('onion.list', { q, category: cat === 'Tudo' ? null : cat })) || [];
        if (my !== seq) return; holder.innerHTML = ''; if (!l.length) { holder.appendChild(UI.empty('cart', 'Mercado vazio', q ? 'Nada encontrado.' : 'Ainda não há anúncios. Publica o primeiro.')); return; }
        l.forEach(x => holder.appendChild(card(x))); };
      load(); return v;
    };
    const mine = () => {
      const v = UI.view({ title: 'Os meus anúncios', large: true, right: [{ icon: 'compose', cls: 'glass', onTap: () => compose() }] });
      const holder = UI.el('<div class="on-list"></div>'); v.content.appendChild(holder); holder.appendChild(UI.spinner());
      Bridge.rpc('onion.mine').then(l => { holder.innerHTML = ''; l = l || []; if (!l.length) { holder.appendChild(UI.empty('tag', 'Sem anúncios teus', 'Publica algo para começar a vender.')); return; } l.forEach(x => holder.appendChild(card(Object.assign({ mine: true }, x)))); });
      return v;
    };
    /* encomendas: as que comprei e as que vendi, com o ciclo do depósito de garantia */
    const orders = () => {
      const v = UI.view({ title: 'Encomendas', large: true }); const seg = UI.seg(['Comprei', 'Vendi'], 0, i => paint(i)); v.content.appendChild(seg);
      const holder = UI.el('<div class="on-list"></div>'); v.content.appendChild(holder);
      const row = (o, sold) => {
        const [txt, cls] = ST[o.status] || ST.pago;
        const c = UI.el(`<div class="on-order ${cls}"><div class="on-ob"><div class="on-ct">${esc(o.title)}</div>
          <div class="on-cs">${sold ? 'para ' + esc(o.buyer_handle) : 'de ' + esc(o.seller_handle)} · ${UI.rel(o.created)}</div>
          <div class="on-status">${esc(txt)}</div></div><b class="on-price">${btc(o.price)}</b></div>`);
        const act = UI.el('<div class="on-acts"></div>');
        /* enviar entrega a unidade em custódia ao comprador; ao vendedor só se diz que seguiu (anonimato) */
        if (sold && o.status === 'pago') { const b = UI.el(`<div class="on-act">${g('send', 24)} Marcar como enviado</div>`); b.onclick = async () => { const r = await Bridge.rpcRaw('onion.ship', { id: o.id }); if (!r || r.error) { Sound.play('error'); alert({ title: 'Não foi possível', msg: ESC_ERR[r && r.error] || 'Esta encomenda já não está à espera de envio.' }); } else { Sound.play('click'); if (r.item) toast('Enviado. O item seguiu para o comprador.'); } paint(1); }; act.appendChild(b); }
        if (!sold && o.status === 'enviado') { const b = UI.el(`<div class="on-act ok">${g('check', 24)} Recebi: libertar pagamento</div>`); b.onclick = async () => { const r = await Bridge.rpcRaw('onion.confirm', { id: o.id }); if (!r || r.error) { Sound.play('error'); alert({ title: 'Não foi possível', msg: 'Esta encomenda já foi fechada.' }); paint(0); return; } Sound.play('success');
          /* normalmente o item já chegou no envio; se ainda estava reservado, vai agora */
          if (r.item) toast(r.item.status === 'given' ? 'Pagamento libertado. O item está no teu inventário.' : 'Pagamento libertado. ' + itemMsg(r.item)); rate(o); }; act.appendChild(b); }
        if (!sold && o.status === 'pago') { const b = UI.el(`<div class="on-act bad">${g('x', 24)} Cancelar e reaver</div>`); b.onclick = async () => { if (await confirm('Cancelar encomenda', 'O valor volta à tua carteira.', 'Cancelar encomenda', true)) { await Bridge.rpc('onion.cancel', { id: o.id }); paint(0); } }; act.appendChild(b); }
        if (act.children.length) c.appendChild(act); return c;
      };
      const paint = async i => { holder.innerHTML = ''; holder.appendChild(UI.spinner());
        const l = (await Bridge.rpc('onion.orders', { role: i ? 'seller' : 'buyer' })) || [];
        holder.innerHTML = ''; if (!l.length) { holder.appendChild(UI.empty('hourglass', i ? 'Nada vendido' : 'Nada comprado', i ? 'As vendas aparecem aqui.' : 'As tuas compras aparecem aqui.')); return; }
        l.forEach(o => holder.appendChild(row(o, !!i))); };
      paint(0); return v;
    };
    async function rate(o) {
      const v = await actionSheet({ title: 'Avaliar ' + o.seller_handle, buttons: [5, 4, 3, 2, 1].map(n => ({ label: '★'.repeat(n) + '☆'.repeat(5 - n), value: n })) });
      if (v) await Bridge.rpc('onion.rate', { id: o.id, rating: v });
      tabs.go(2);
    }
    const profile = () => {
      const v = UI.view({ title: 'Identidade', large: true });
      v.content.appendChild(UI.el(`<div class="on-me"><div class="on-orb sm">${g('ghost', 40)}</div><div class="on-handle">${esc(me.handle)}</div><div class="on-rep">${stars(me.rep)}<span>${me.sales || 0} vendas</span></div></div>`));
      v.content.appendChild(UI.list([{ items: [
        { icon: 'key', iconBg: '#2A2036', iconColor: '#C9A6FF', label: 'Chave', value: (me.handle || '').slice(0, 4).toUpperCase() + '·' + String(me.since || 0).slice(-4), chevron: false },
        { icon: 'shield', iconBg: '#12301F', iconColor: '#7CFF9B', label: 'Registos', value: 'nenhum', chevron: false },
        { icon: 'globe', iconBg: '#1B2338', iconColor: '#8FB4FF', label: 'Circuito', value: '3 nós', chevron: false }] },
        { items: [{ label: 'Nova identidade', cls: 'center red', chevron: false, onTap: async () => {
          if (!await confirm('Nova identidade', 'Perdes a reputação e o histórico de vendas deste alcunha. Os anúncios são apagados.', 'Trocar', true)) return;
          me = (await Bridge.rpc('onion.newIdentity')) || me; toast('Agora és ' + me.handle); tabs.go(3); } }] },
        { footer: 'A tua alcunha não está ligada ao teu número nem ao teu nome. Só se te identificares é que alguém sabe quem és.' }]));
      return v;
    };

    connect(() => {
      Bridge.rpc('onion.identity').then(id => { if (id) me = id;
        tabs = UI.tabbar(win, [
          { icon: 'cart', label: 'Mercado', view: market },
          { icon: 'tag', label: 'Vender', view: mine },
          { icon: 'hourglass', label: 'Encomendas', view: orders },
          { icon: 'ghost', label: 'Identidade', view: profile }], 0);
      });
    });
    const off = Bridge.on('onion:compose', () => compose()); win.onClose = off;
  }
});
Bridge.on('onion', d => { if (!d) return; Notify.push({ app: 'onion', title: d.title || 'Onion', msg: d.msg || '', onTap: () => System.openApp('onion') }); });

/* ---------- fallback do browser (harness / demonstração) ---------- */
if (window.LocalDB && LocalDB.register) (() => {
  const L = () => LocalDB.T('onion'), O = () => LocalDB.T('onion_orders'), ID = () => LocalDB.T('onion_id');
  const ADJ = ['silent', 'grey', 'hollow', 'iron', 'pale', 'zero', 'north', 'blind'], NOUN = ['fox', 'wire', 'crow', 'echo', 'vault', 'moth', 'harbor', 'signal'];
  const rnd = n => Math.floor(Math.random() * n);
  const handle = () => ADJ[rnd(ADJ.length)] + NOUN[rnd(NOUN.length)] + rnd(90) + 10;
  const meId = () => { let r = ID().all()[0]; if (!r) r = ID().insert({ owner: 'DEV0000', handle: handle(), rep: 0, votes: 0, sales: 0, since: Date.now() }); return r; };
  const rep = r => (r.votes ? r.rep / r.votes : 0);
  const seed = () => { if (L().all().length) return; const t = Date.now();
    [['Passaporte limpo', 'Documento novo, sem registo associado. Entrega em mão.', .0850, 'Documentos', 3, 'greyvault21', 4.8, 41],
     ['Rádio da polícia (recetor)', 'Recetor sintonizado nas frequências públicas. Só escuta.', .0320, 'Eletrónica', 5, 'silentmoth77', 4.4, 18],
     ['Kit de matrículas', 'Chapas em branco e prensa. Não faço perguntas.', .0410, 'Peças', 2, 'ironcrow34', 4.9, 63],
     ['Motor turbo usado', 'Saído de um Banshee. Funciona, tem uso.', .1200, 'Peças', 1, 'northwire55', 4.1, 9],
     ['Transporte discreto', 'Levo o que for de A a B sem conversa. Preço por viagem.', .0250, 'Serviços', 9, 'paleecho12', 5.0, 120],
     ['Telemóvel descartável', 'Cartão pré-pago incluído, sem registo.', .0180, 'Eletrónica', 8, 'blindfox48', 4.6, 27]]
      .forEach(([title, description, price, category, stock, seller_handle, seller_rep, seller_sales], i) =>
        L().insert({ owner: 'npc' + i, seller_handle, seller_rep, seller_sales, title, description, price, category, stock, image: null, created: t - i * 5 * 36e5 })); };
  /* custódia partilhada com o marketplace.js (LocalDB.escrowMock, carregado antes); sem ele o mock fica como antes, sem itens */
  const Esc = LocalDB.escrowMock || null;
  const unitOf = o => Esc ? Esc.E().all().find(e => e.source === 'onion' && e.ref_id === o.id && e.target === o.buyer && e.status === 'held') : null;
  const pub = l => Object.assign({}, l, { mine: l.owner === 'DEV0000' }, Esc ? { escrow: Esc.held('onion', l.id).length > 0, custody: Esc.managed('onion', l.id) } : {});

  LocalDB.register('onion.identity', () => { const r = meId(); return { handle: r.handle, rep: rep(r), sales: r.sales, since: r.since }; });
  LocalDB.register('onion.newIdentity', () => { const r = meId(); if (Esc) L().all().filter(x => x.owner === 'DEV0000').forEach(x => Esc.returnUnits(Esc.held('onion', x.id))); L().remove(x => x.owner === 'DEV0000'); ID().update(r.id, { handle: handle(), rep: 0, votes: 0, sales: 0, since: Date.now() }); const n = meId(); return { handle: n.handle, rep: 0, sales: 0, since: n.since }; });
  LocalDB.register('onion.list', d => { seed(); return L().all().filter(l => (!d.category || l.category === d.category) && (!d.q || (l.title + ' ' + l.description).toLowerCase().includes(d.q))).sort((a, b) => b.created - a.created).map(pub); });
  LocalDB.register('onion.mine', () => { seed(); return L().all().filter(l => l.owner === 'DEV0000').sort((a, b) => b.created - a.created).map(pub); });
  /* como o servidor: um anúncio de item retém uma unidade por cada uma em stock, ou não nasce */
  LocalDB.register('onion.create', d => { const r = meId(); const kind = d.kind === 'item' || d.kind === 'vehicle' ? d.kind : 'other', stock = Math.max(1, Math.floor(+d.stock || 1));
    let hold = null; if (kind === 'item' && Esc) { hold = Esc.hold('onion', 0, d.item_name, stock); if (hold.error) return hold; }
    const row = L().insert({ owner: 'DEV0000', seller_handle: r.handle, seller_rep: rep(r), seller_sales: r.sales, title: d.title, description: d.description || '', price: +d.price, stock, category: d.category || 'Diversos', image: d.image || null, created: Date.now(), kind, item_name: kind === 'item' ? d.item_name : null });
    if (hold) Esc.E().update(hold.id, { ref_id: row.id });
    return Object.assign({}, row, { ok: true, escrow: !!hold }); });
  LocalDB.register('onion.update', d => { const l = L().all().find(x => x.id === d.id); if (!l || l.owner !== 'DEV0000') return { error: 'forbidden' };
    let back = null, fresh = null;
    if (Esc) { const kind = d.kind || l.kind || 'other', item = kind === 'item' ? (d.item_name !== undefined ? d.item_name : l.item_name) : null, stock = d.stock != null ? Math.max(0, Math.floor(+d.stock)) : l.stock;
      const rows = Esc.held('onion', l.id), custody = rows.reduce((s, e) => s + e.count, 0), changed = kind === 'item' && (item !== l.item_name || l.kind !== 'item');
      if (kind !== 'item' || changed) { if (kind === 'item' && stock > 0) { fresh = Esc.hold('onion', l.id, item, stock); if (fresh.error) return fresh; } if (custody > 0) back = Esc.returnUnits(rows); }
      else if (Esc.managed('onion', l.id)) { if (stock > l.stock) { fresh = Esc.hold('onion', l.id, item, stock - l.stock); if (fresh.error) return fresh; } if (custody > stock) back = Esc.returnUnits(rows, custody - stock); } }
    L().update(d.id, Object.fromEntries(Object.entries(d).filter(([k]) => ['title', 'description', 'price', 'stock', 'category', 'image', 'kind', 'item_name'].includes(k))));
    return Object.assign({ ok: true }, back ? { item: back } : {}, fresh ? { escrow: true } : {}); });
  LocalDB.register('onion.delete', d => { const l = L().all().find(x => x.id === d.id); if (!l || l.owner !== 'DEV0000') return { error: 'forbidden' }; const back = Esc ? Esc.returnUnits(Esc.held('onion', l.id)) : null; L().remove(d.id); return back ? { ok: true, item: back } : { ok: true }; });
  LocalDB.register('onion.buy', d => { seed(); const l = L().all().find(x => x.id === d.id); if (!l) return { ok: false, error: 'gone' }; if (l.owner === 'DEV0000') return { ok: false, error: 'own' }; if (l.stock <= 0) return { ok: false, error: 'stock' };
    const c = LocalDB.crypto ? LocalDB.crypto() : { bal: 1 }; if (c.bal < l.price) return { ok: false, error: 'funds' };
    if (LocalDB.cryptoSet) LocalDB.cryptoSet(c.bal - l.price, { label: 'Onion: ' + l.title, amount: -l.price });
    L().update(l.id, { stock: l.stock - 1 });
    const o = O().insert({ buyer: 'DEV0000', buyer_handle: meId().handle, seller: l.owner, seller_handle: l.seller_handle, listing: l.id, title: l.title, price: l.price, status: 'pago', created: Date.now() });
    /* reserva uma unidade da custódia para a encomenda (ref_id = encomenda, target = comprador) */
    const h = Esc && Esc.held('onion', l.id)[0];
    if (h) { Esc.E().update(h.id, { count: h.count - 1 }); Esc.E().insert({ source: 'onion', ref_id: o.id, owner: h.owner, item: h.item, count: 1, status: 'held', target: 'DEV0000' }); return { ok: true, item: { status: 'reserved', name: h.item, label: h.item, count: 1 } }; }
    return { ok: true }; });
  LocalDB.register('onion.orders', d => O().all().filter(o => d.role === 'seller' ? o.seller === 'DEV0000' : o.buyer === 'DEV0000').sort((a, b) => b.created - a.created));
  LocalDB.register('onion.ship', d => { const o = O().all().find(x => x.id === d.id); if (!o || o.seller !== 'DEV0000' || o.status !== 'pago') return { error: 'forbidden' }; O().update(d.id, { status: 'enviado' }); const u = unitOf(o); if (u) { Esc.release(u, o.buyer, true); return { ok: true, item: { status: 'sent' } }; } return { ok: true }; });
  LocalDB.register('onion.confirm', d => { const o = O().all().find(x => x.id === d.id); if (!o || o.buyer !== 'DEV0000' || (o.status !== 'pago' && o.status !== 'enviado')) return { error: 'forbidden' }; O().update(d.id, { status: 'concluido' }); const u = unitOf(o); return u ? { ok: true, item: Esc.release(u, o.buyer, true) } : { ok: true }; });
  LocalDB.register('onion.cancel', d => { const o = O().all().find(x => x.id === d.id); if (!o || o.buyer !== 'DEV0000' || o.status !== 'pago') return { error: 'forbidden' }; if (LocalDB.cryptoSet && LocalDB.crypto) LocalDB.cryptoSet(LocalDB.crypto().bal + o.price, { label: 'Onion: reembolso', amount: o.price }); O().update(d.id, { status: 'cancelado' });
    /* como o servidor: a unidade reservada volta ao stock (continua em custódia); sem anúncio volta ao vendedor */
    const l = L().all().find(x => x.id === o.listing), u = unitOf(o);
    if (u && l) Esc.E().update(u.id, { ref_id: l.id, target: null }); else if (u) Esc.release(u, u.owner, false);
    if (l) L().update(l.id, { stock: l.stock + 1 });
    return { ok: true }; });
  LocalDB.register('onion.rate', d => { O().update(d.id, { rating: d.rating }); return { ok: true }; });
})();
