/* =====================================================================
   CRIPTO - carteira anónima. Saldo em ₿, cotação a variar, comprar/vender com dinheiro sujo,
   transferir para outra alcunha (as do Onion) e histórico. É a moeda do mercado Onion.
   O gráfico é UM caminho SVG desenhado a partir da série de preços (sem biblioteca, sem canvas por frame).
   ===================================================================== */
Icons.app.crypto = () => Icons.SVG(Icons.G('gCy', '#F7B23B', '#E58A12', '#9C5A00') + Icons.GL(
  `<g fill="none" stroke="#fff" stroke-width="6.5" stroke-linecap="round" stroke-linejoin="round"><path d="M38 26v48M50 22v56"/><path d="M38 30h20a11 11 0 0 1 0 22H38"/><path d="M38 52h23a11 11 0 0 1 0 22H38"/></g>`));

App.define('crypto', {
  name: 'Cripto', category: 'Anónimo', statusBar: 'dark',
  open(win) {
    const g = UI.g, esc = UI.esc; win.classList.add('cy');
    /* overlays com o tema da app (sao montados no #screen, fora da janela) */
    const sheet = o => UI.sheet(Object.assign({}, o, { cls: 'cy' }));
    const alert = o => UI.alert(Object.assign({}, o, { cls: 'cy' }));
    const toast = (m, ms) => UI.toast(m, ms, 'cy');
    const btc = n => (Math.round((+n || 0) * 1e4) / 1e4).toFixed(4).replace('.', ',') + ' ₿';
    let st = { bal: 0, price: 0, series: [], history: [] }, tabs;

    /* gráfico: uma polilinha normalizada 0→100 (viewBox), sem eixos - como a app Bolsa do PearOS */
    function chart(series, up) {
      if (!series || series.length < 2) return '';
      const min = Math.min(...series), max = Math.max(...series), span = (max - min) || 1;
      const pts = series.map((v, i) => [(i / (series.length - 1)) * 100, 46 - ((v - min) / span) * 40]);
      const d = pts.map((p, i) => (i ? 'L' : 'M') + p[0].toFixed(2) + ' ' + p[1].toFixed(2)).join(' ');
      const c = up ? '#30D158' : '#FF453A';
      return `<svg class="cy-chart" viewBox="0 0 100 50" preserveAspectRatio="none"><path d="${d} L100 50 L0 50 Z" fill="${c}" opacity=".12"/><path d="${d}" fill="none" stroke="${c}" stroke-width="2.5" vector-effect="non-scaling-stroke" stroke-linejoin="round" stroke-linecap="round"/></svg>`;
    }

    async function load() { const r = await Bridge.rpc('crypto.state'); if (r) st = r; }

    const home = () => {
      const v = UI.view({ title: 'Cripto', large: true, cls: 'cy-home' });
      const holder = UI.el('<div class="cy-hold"></div>'); v.content.appendChild(holder); holder.appendChild(UI.spinner());
      const paint = () => {
        const chg = st.series && st.series.length > 1 ? (st.series[st.series.length - 1] - st.series[0]) / (st.series[0] || 1) * 100 : 0;
        const up = chg >= 0;
        holder.innerHTML = '';
        /* um só elemento de raiz: UI.el devolve apenas o PRIMEIRO filho, por isso vários irmãos no mesmo template perdiam-se (a cotação e o gráfico desapareciam) */
        holder.appendChild(UI.el(`<div><div class="cy-bal"><span class="cy-lb">Saldo</span><div class="cy-big">${btc(st.bal)}</div>
          <div class="cy-fiat">${UI.money((st.bal || 0) * (st.price || 0))}</div></div>
          <div class="cy-quote"><div class="cy-q1"><b>1 ₿</b><span>${UI.money(st.price)}</span></div>
          <div class="cy-chg ${up ? 'up' : 'down'}">${g(up ? 'arrowUp' : 'arrowDown', 19)}${Math.abs(chg).toFixed(2).replace('.', ',')} %</div></div>
          <div class="cy-chartbox">${chart(st.series, up)}</div></div>`));
        const acts = UI.el('<div class="cy-acts"></div>');
        [['Comprar', 'plus', () => trade(true)], ['Vender', 'arrowDown', () => trade(false)], ['Enviar', 'send', () => send()]].forEach(([l, ic, fn]) => {
          const b = UI.el(`<div class="cy-act"><div class="cy-ai">${g(ic, 24)}</div><span>${l}</span></div>`); b.onclick = fn; acts.appendChild(b); });
        holder.appendChild(acts);
        const h = (st.history || []).slice(0, 8);
        holder.appendChild(h.length
          ? UI.list([{ header: 'Movimentos', items: h.map(x => ({ icon: x.amount >= 0 ? 'arrowDown' : 'arrowUp', iconBg: x.amount >= 0 ? 'var(--green)' : 'var(--red)', label: x.label, sub: UI.rel(x.created), value: (x.amount >= 0 ? '+' : '') + btc(x.amount), chevron: false })) }])
          : UI.empty('chart', 'Sem movimentos', 'Compra cripto para começar.'));
      };
      load().then(paint); return v;
    };

    async function trade(buy) {
      if (window.CC && CC.requireNet && !CC.requireNet(buy ? 'comprar cripto' : 'vender cripto')) return;
      /* o servidor cobra a taxa da casa e devolve st.buy/st.sell JÁ com ela dentro (st.price é só a
         cotação do gráfico). Sem isto a folha prometia 1 ₿ = st.price e o jogador levava ~1,5 % menos
         ₿ do que leu. O `|| +st.price` mantém isto a funcionar contra um servidor antigo. */
      const rate = (buy ? +st.buy : +st.sell) || +st.price || 0;
      if (!(rate > 0)) { toast('Cotação indisponível'); return; }
      /* arredondado às centésimas: o servidor faz taxa/100*100 e uma taxa de 1,23 % voltava como
         1,2299999999999998 - o número em bruto ia direito para o ecrã */
      const feePct = buy ? +st.feeBuyPct : +st.feeSellPct;
      const feeTxt = feePct > 0 ? ` · taxa ${String(Math.round(feePct * 100) / 100).replace('.', ',')} %` : '';
      const body = UI.el(`<div class="cy-form"><div class="cy-rate">1 ₿ = ${UI.money(rate)}${feeTxt}</div>
        <div class="group"><div class="li static"><span class="muted" style="width:74px">${buy ? UI.esc('Gastar ' + UI.cur()) : 'Vender ₿'}</span><input type="number" step="${buy ? '1' : '0.0001'}" class="v" placeholder="0"></div></div>
        <div class="cy-conv">≈ --</div></div>`);
      const inp = body.querySelector('.v'), conv = body.querySelector('.cy-conv');
      /* corta como o servidor: a compra só aceita euros INTEIROS (intIn) e trunca aos 8 decimais, a
         venda arredonda o dinheiro para baixo ao euro - a pré-visualização tem de bater certo */
      const val = () => buy ? Math.floor(+inp.value || 0) : (+inp.value || 0);
      inp.oninput = () => { const n = val(); conv.textContent = '≈ ' + (buy ? btc(Math.floor(n / rate * 1e8) / 1e8) : UI.money(Math.floor(n * rate))); };
      sheet({ title: buy ? 'Comprar cripto' : 'Vender cripto', left: 'Cancelar', right: buy ? 'Comprar' : 'Vender', body, onDone: () => {
        const n = val(); if (!(n > 0)) { toast(buy ? 'Indica um valor inteiro' : 'Indica um valor'); return false; }
        /* rpcRaw: o Bridge.rpc troca { ok:false, error } por null e o jogador lia sempre «Tenta novamente» */
        Bridge.rpcRaw(buy ? 'crypto.buy' : 'crypto.sell', { amount: n }).then(r => {
          if (!r || !r.ok) { Sound.play('error'); alert({ title: 'Não foi possível', msg: r && r.error === 'funds' ? (buy ? 'Não tens dinheiro suficiente.' : 'Não tens cripto suficiente.') : r && r.error === 'invalid' ? (buy ? 'Valor fora do que o servidor aceita.' : 'Esse valor não chega a ' + UI.money(1, { int: true }) + '.') : 'Tenta novamente.' }); return; }
          Sound.play('success');
          /* o que se diz é o que o servidor fez: ele devolve o ₿ que entrou (got) e o dinheiro que saiu (cash) */
          toast(buy ? (r.got != null ? 'Compraste ' + btc(r.got) : 'Cripto comprada') : (r.cash != null ? 'Vendeste por ' + UI.money(r.cash) : 'Cripto vendida')); tabs.go(0); });
      } });
    }
    async function send() {
      if (window.CC && CC.requireNet && !CC.requireNet('enviar cripto')) return;
      const body = UI.el(`<div class="cy-form"><div class="group"><div class="li static"><span class="muted" style="width:74px">Para</span><input type="text" class="to" placeholder="alcunha ou número" maxlength="32"></div>
        <div class="li static"><span class="muted" style="width:74px">Valor ₿</span><input type="number" step="0.0001" class="v" placeholder="0,0000"></div></div>
        <div class="group-footer" style="text-align:center">As transferências são anónimas e não podem ser revertidas.</div></div>`);
      sheet({ title: 'Enviar cripto', left: 'Cancelar', right: 'Enviar', body, onDone: () => {
        const to = body.querySelector('.to').value.trim(), amount = +body.querySelector('.v').value;
        if (!to || !(amount > 0)) { toast('Preenche os dois campos'); return false; }
        /* rpcRaw: sem ele o 'nouser' chegava como null e a alcunha errada dizia «Tenta novamente» */
        Bridge.rpcRaw('crypto.send', { to, amount }).then(r => {
          if (!r || !r.ok) { Sound.play('error'); alert({ title: 'Não enviado', msg: r && r.error === 'funds' ? 'Saldo insuficiente.' : r && r.error === 'nouser' ? 'Alcunha ou número desconhecido.' : 'Tenta novamente.' }); return; }
          Sound.play('success'); toast('Enviado'); tabs.go(0); });
      } });
    }
    const hist = () => { const v = UI.view({ title: 'Histórico', large: true }); const holder = UI.el('<div class="cy-hold"></div>'); v.content.appendChild(holder); holder.appendChild(UI.spinner());
      load().then(() => { holder.innerHTML = ''; const h = st.history || [];
        holder.appendChild(h.length ? UI.list([{ items: h.map(x => ({ icon: x.amount >= 0 ? 'arrowDown' : 'arrowUp', iconBg: x.amount >= 0 ? 'var(--green)' : 'var(--red)', label: x.label, sub: UI.rel(x.created), value: (x.amount >= 0 ? '+' : '') + btc(x.amount), chevron: false })) }]) : UI.empty('chart', 'Sem movimentos', 'Ainda não há nada para mostrar.')); });
      return v; };
    tabs = UI.tabbar(win, [{ icon: 'chart', label: 'Carteira', view: home }, { icon: 'clock', label: 'Histórico', view: hist }], 0);
  }
});

/* ---------- fallback do browser ---------- */
if (window.LocalDB && LocalDB.register) (() => {
  const W = () => LocalDB.T('crypto'), H = () => LocalDB.T('crypto_hist');
  /* série de preços estável por sessão (não pode saltar a cada render). Os números são os mesmos do
     server/onion.lua (cryptoCfg): banda 26460-27540, ruído de média ZERO, reversão ao centro e taxa da
     casa de 1,5 % de cada lado. A deriva antiga (média +0,02 por passo) e a falta de tecto faziam o
     browser contradizer o jogo. */
  const MIN = 26460, MAX = 27540, CENTRE = (MIN + MAX) / 2, STEP = 110, REVERT = .01, FEE = .015;
  let series = null, price = 0;
  const eur = n => Math.round(n * 100) / 100;
  const pBuy = () => Math.ceil(price * (1 + FEE) * 100) / 100;    /* como o up2 do servidor */
  const pSell = () => Math.floor(price * (1 - FEE) * 100) / 100;  /* como o down2 do servidor */
  const build = () => { if (series) return; let p = MIN + Math.random() * (MAX - MIN); series = [];
    for (let i = 0; i < 40; i++) { p = eur(p + (CENTRE - p) * REVERT + (Math.random() - .5) * STEP); p = Math.min(MAX, Math.max(MIN, p)); series.push(p); }
    price = series[series.length - 1]; };
  const wallet = () => { let w = W().all()[0]; if (!w) w = W().insert({ owner: 'DEV0000', bal: 0.25 }); return w; };
  const push = (label, amount) => H().insert({ owner: 'DEV0000', label, amount, created: Date.now() });
  LocalDB.crypto = () => { build(); return { bal: wallet().bal, price }; };
  LocalDB.cryptoSet = (bal, mv) => { const w = wallet(); W().update(w.id, { bal: Math.max(0, bal) }); if (mv) push(mv.label, mv.amount); };
  LocalDB.register('crypto.state', () => { build(); const w = wallet(); return { bal: w.bal, price, buy: pBuy(), sell: pSell(), feeBuyPct: FEE * 100, feeSellPct: FEE * 100, series, history: H().all().sort((a, b) => b.created - a.created) }; });
  /* compra e venda ao preço COM taxa e com os mesmos cortes do servidor (8 decimais no ₿, euro inteiro no dinheiro) */
  LocalDB.register('crypto.buy', d => { build(); const cost = Math.floor(+d.amount); if (!(cost >= 1)) return { ok: false, error: 'invalid' };
    const pb = pBuy(); const got = Math.floor(cost / pb * 1e8) / 1e8; if (!(got > 0)) return { ok: false, error: 'invalid' };
    const p = LocalDB.player(); if ((p.money.cash || 0) < cost) return { ok: false, error: 'funds' };
    p.money.cash -= cost; LocalDB.savePlayer(p); const w = wallet(); W().update(w.id, { bal: w.bal + got }); push('Compra de cripto', got); return { ok: true, bal: w.bal + got, price: pb, got }; });
  LocalDB.register('crypto.sell', d => { build(); const w = wallet(); const n = +d.amount; const ps = pSell(); const cash = Math.floor(n * ps);
    if (!(n > 0) || !(cash > 0)) return { ok: false, error: 'invalid' };
    if (w.bal < n) return { ok: false, error: 'funds' };
    W().update(w.id, { bal: w.bal - n }); const p = LocalDB.player(); p.money.cash = (p.money.cash || 0) + cash; LocalDB.savePlayer(p); push('Venda de cripto', -n); return { ok: true, bal: w.bal - n, price: ps, cash }; });
  LocalDB.register('crypto.send', d => { const w = wallet(); const n = +d.amount; if (w.bal < n) return { ok: false, error: 'funds' };
    W().update(w.id, { bal: w.bal - n }); push('Enviado para ' + d.to, -n); return { ok: true }; });
})();
