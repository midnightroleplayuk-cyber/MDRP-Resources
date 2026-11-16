/* =====================================================================
   BOLSA (stocks) - mercado de ações SIMULADO no servidor (server/stocks.lua, config_stocks.lua).
   Lista com símbolo, nome, sparkline (canvas pequeno por linha, desenhado uma vez por atualização) e a
   pílula verde/vermelha da variação; detalhe com gráfico em canvas (1D / 1S / 1M) com dedo a percorrer,
   estatísticas, notícias e Comprar / Vender com folha de quantidade e confirmação; separadores Carteira
   e Notícias; pesquisa; lista de favoritos e alertas de preço no servidor; widget 2×2 / 4×2 (índice LSX).
   PearOS e Nova UI no mesmo ficheiro: a estrutura é a mesma, o Android muda classes e CSS (app-stocks.css).
   Regras: estrutura construída UMA vez e atualizada in place (textos/classes/canvas); só transform/opacity animam.
   ===================================================================== */
(() => {
  const SQ = 'M50 0C88 0 100 12 100 50S88 100 50 100 0 88 0 50 12 0 50 0Z';
  /* ícone PearOS: fundo grafite com a linha verde a subir e a área por baixo */
  Icons.app.stocks = () => Icons.SVG(Icons.G('gStk', '#3C3C40', '#161618', '#0B0B0C')
    + '<g stroke="rgba(255,255,255,.1)" stroke-width="1.4"><path d="M14 36h72M14 52h72M14 68h72"/></g>'
    + '<path d="M14 72L30 56L42 63L58 42L70 48L86 28V86H14Z" fill="#30D158" opacity=".16"/>'
    + Icons.GL('<path d="M14 72L30 56L42 63L58 42L70 48L86 28" fill="none" stroke="#30D158" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/><circle cx="86" cy="28" r="6" fill="#fff"/>'));
  /* ícone Nova UI: superelipse azul-noite, linha verde plana com pontos claros */
  if (Icons.registerOS) Icons.registerOS('android', { stocks: () => Icons.SVG(
    `<path d="${SQ}" fill="#1E3A5F"/><ellipse cx="38" cy="8" rx="70" ry="44" fill="#3E7BFA" opacity=".35"/><path d="${SQ}" fill="none" stroke="#fff" stroke-opacity=".26" stroke-width="2.2"/>`
    + '<path d="M16 74L32 56L46 64L62 40L84 26V84H16Z" fill="#2DBE60" opacity=".22"/>'
    + '<path d="M16 74L32 56L46 64L62 40L84 26" fill="none" stroke="#2DBE60" stroke-width="7.5" stroke-linecap="round" stroke-linejoin="round"/>'
    + '<g fill="#fff"><circle cx="32" cy="56" r="4.6"/><circle cx="62" cy="40" r="4.6"/><circle cx="84" cy="26" r="5.4"/></g>', true) });
  if (window.App && App.alias) App.alias('android', { stocks: 'Bolsa' });
  try { if (UI.OU_APPS && UI.OU_APPS.add) UI.OU_APPS.add('stocks'); } catch (e) {}

  const isA = () => !!(window.System && System.isAndroid && System.isAndroid());
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf ? L.tf(s, ...v) : v.reduce((a, x) => a.replace('%s', x), s));
  const nf = (v, d = 2) => { try { return new Intl.NumberFormat((window.L && L.intl) ? L.intl() : 'pt-PT', { minimumFractionDigits: d, maximumFractionDigits: d }).format(+v || 0); } catch (e) { return (+v || 0).toFixed(d); } };
  const money = n => UI.money(n);
  const pct = n => (n > 0 ? '+' : n < 0 ? '-' : '') + nf(Math.abs(+n || 0)) + ' %';
  const signed = n => (n > 0 ? '+' : n < 0 ? '-' : '') + money(Math.abs(+n || 0));
  const volTxt = n => { n = +n || 0; return n >= 1e6 ? nf(n / 1e6, 1) + ' M' : n >= 1e3 ? nf(n / 1e3, 1) + ' K' : String(Math.round(n)); };
  const dark = () => document.body.classList.contains('dark');
  const UP = () => isA() ? (dark() ? '#3DD06F' : '#2DBE60') : (dark() ? '#30D158' : '#34C759');
  const DN = () => isA() ? (dark() ? '#FF5A52' : '#F2453D') : (dark() ? '#FF453A' : '#FF383C');
  const MUTED = () => dark() ? 'rgba(235,235,245,.5)' : 'rgba(60,60,67,.5)';
  const GRID = () => dark() ? 'rgba(255,255,255,.08)' : 'rgba(0,0,0,.07)';
  const headline = n => TF(n.title || '', n.name || n.symbol || '');

  /* lista com chave: cria só as linhas novas, atualiza as que existem in place, remove as que saíram, mantém a ordem */
  function keyed(host, items, keyOf, build, update) {
    const have = new Map(); [...host.children].forEach(el => { if (el.dataset.k) have.set(el.dataset.k, el); });
    const seen = new Set(); let prev = null;
    items.forEach(it => { const k = String(keyOf(it)); seen.add(k); let el = have.get(k); if (!el) { el = build(it); el.dataset.k = k; }
      update(el, it); const ref = prev ? prev.nextSibling : host.firstChild; if (el !== ref) host.insertBefore(el, ref); prev = el; });
    have.forEach((el, k) => { if (!seen.has(k)) el.remove(); });
  }
  const setTxt = (el, s) => { if (el && el.textContent !== s) el.textContent = s; };
  const tone = (el, up) => { if (!el) return; el.classList.toggle('up', up); el.classList.toggle('dn', !up); };

  /* ---------- canvas: sparkline pequena ---------- */
  function spark(cv, series, up) {
    const ctx = cv.getContext('2d'); const W = cv.width, H = cv.height; ctx.clearRect(0, 0, W, H);
    const s = (series || []).map(Number).filter(v => isFinite(v));
    if (s.length < 2) { ctx.strokeStyle = GRID(); ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(2, H / 2); ctx.lineTo(W - 2, H / 2); ctx.stroke(); return; }
    let mn = Infinity, mx = -Infinity; s.forEach(v => { if (v < mn) mn = v; if (v > mx) mx = v; }); const sp = (mx - mn) || 1;
    const X = i => 2 + i / (s.length - 1) * (W - 4), Y = v => H - 3 - (v - mn) / sp * (H - 6);
    const col = up ? UP() : DN();
    ctx.beginPath(); s.forEach((v, i) => i ? ctx.lineTo(X(i), Y(v)) : ctx.moveTo(X(i), Y(v)));
    ctx.lineTo(X(s.length - 1), H); ctx.lineTo(X(0), H); ctx.closePath(); ctx.fillStyle = col; ctx.globalAlpha = .14; ctx.fill(); ctx.globalAlpha = 1;
    ctx.beginPath(); s.forEach((v, i) => i ? ctx.lineTo(X(i), Y(v)) : ctx.moveTo(X(i), Y(v)));
    ctx.strokeStyle = col; ctx.lineWidth = 1.8; ctx.lineJoin = 'round'; ctx.lineCap = 'round'; ctx.stroke();
  }

  /* ---------- canvas: gráfico do detalhe (pontos [t, p]) ---------- */
  const fmtT = (t, range) => { const d = new Date(+t); if (range === '1D') return UI.fmtTime(d); return UI.fmtDate(d, true); };
  function drawChart(cv, pts, o) {
    const ctx = cv.getContext('2d'); const W = cv.width, H = cv.height; ctx.clearRect(0, 0, W, H);
    const list = (pts || []).filter(p => Array.isArray(p) && isFinite(+p[0]) && isFinite(+p[1])).map(p => [+p[0], +p[1]]);
    if (list.length < 2) { ctx.fillStyle = MUTED(); ctx.font = '500 14px Inter, sans-serif'; ctx.textAlign = 'center'; ctx.fillText(T('Sem dados suficientes'), W / 2, H / 2 + 4); return null; }
    const padL = 12, padR = 64, padT = 16, padB = 24, x0 = padL, x1 = W - padR, y0 = padT, y1 = H - padB;
    let mn = Infinity, mx = -Infinity; list.forEach(p => { if (p[1] < mn) mn = p[1]; if (p[1] > mx) mx = p[1]; });
    if (o.base != null && isFinite(o.base)) { mn = Math.min(mn, o.base); mx = Math.max(mx, o.base); }
    let sp = (mx - mn) || Math.max(mx * .02, .01); mn -= sp * .1; mx += sp * .1; sp = mx - mn;
    const t0 = list[0][0], t1 = list[list.length - 1][0]; const tw = (t1 - t0) || 1;
    const X = t => x0 + (t - t0) / tw * (x1 - x0), Y = v => y1 - (v - mn) / sp * (y1 - y0);
    const up = o.up !== false, col = up ? UP() : DN();
    ctx.lineWidth = 1; ctx.strokeStyle = GRID(); ctx.fillStyle = MUTED(); ctx.font = '11px Inter, sans-serif'; ctx.textAlign = 'left'; ctx.setLineDash([]);
    for (let i = 0; i <= 3; i++) { const v = mn + sp * i / 3, y = Math.round(Y(v)) + .5; ctx.beginPath(); ctx.moveTo(x0, y); ctx.lineTo(x1, y); ctx.stroke(); ctx.fillText(money(v), x1 + 8, y + 4); }
    if (o.base != null && isFinite(o.base)) { const y = Math.round(Y(o.base)) + .5; ctx.setLineDash([3, 4]); ctx.strokeStyle = MUTED(); ctx.beginPath(); ctx.moveTo(x0, y); ctx.lineTo(x1, y); ctx.stroke(); ctx.setLineDash([]); }
    const grad = ctx.createLinearGradient(0, y0, 0, y1); grad.addColorStop(0, col); grad.addColorStop(1, col);
    ctx.beginPath(); list.forEach((p, i) => i ? ctx.lineTo(X(p[0]), Y(p[1])) : ctx.moveTo(X(p[0]), Y(p[1])));
    ctx.lineTo(X(t1), y1); ctx.lineTo(X(t0), y1); ctx.closePath(); ctx.fillStyle = grad; ctx.globalAlpha = .13; ctx.fill(); ctx.globalAlpha = 1;
    ctx.beginPath(); list.forEach((p, i) => i ? ctx.lineTo(X(p[0]), Y(p[1])) : ctx.moveTo(X(p[0]), Y(p[1])));
    ctx.strokeStyle = col; ctx.lineWidth = 2.2; ctx.lineJoin = 'round'; ctx.lineCap = 'round'; ctx.stroke();
    ctx.fillStyle = MUTED(); ctx.font = '11px Inter, sans-serif'; ctx.textAlign = 'left'; ctx.fillText(fmtT(t0, o.range), x0, H - 7); ctx.textAlign = 'right'; ctx.fillText(fmtT(t1, o.range), x1, H - 7);
    return { X, Y, list, x0, x1, t0, t1 };
  }

  /* ---------- estado partilhado pela janela ---------- */
  App.define('stocks', {
    name: 'Bolsa', category: 'Finanças', core: false, statusBar: 'auto',
    description: 'Mercado de ações de Los Santos: cotações ao minuto, gráficos, notícias e a tua carteira.',
    open(win) {
      const g = UI.g, esc = UI.esc;
      win.classList.add('stk'); if (isA()) win.classList.add('stk-a');
      const S = { cfg: { fee: .005, maxQty: 10000, tick: 60 }, market: null, watch: [], filter: '', onlyWatch: false, timer: null, detail: null, pf: null, news: null };
      const toast = m => UI.toast(m);
      const nameOf = sym => { const it = S.market && S.market.items.find(x => x.symbol === sym); return it ? it.name : sym; };
      const itemOf = sym => S.market && S.market.items.find(x => x.symbol === sym);

      async function loadCfg() { const c = await Bridge.rpc('stocks.config'); if (c) S.cfg = Object.assign(S.cfg, c); }
      async function pullMarket() {
        const r = await Bridge.rpcRaw('stocks.market');
        if (!r || r.error) { if (r && r.error === 'disabled' && S.mkt) S.mkt.disabled(); return false; }
        S.market = r; if (S.mkt) S.mkt.paint(); if (S.detail) S.detail.tick(); if (S.pf && S.pf.visible()) S.pf.load(); return true;
      }
      async function pullWatch() { const r = await Bridge.rpc('stocks.watchlist.get'); if (r && Array.isArray(r.symbols)) { S.watch = r.symbols; if (S.mkt) S.mkt.paint(); } }
      const inWatch = sym => S.watch.includes(sym);
      async function toggleWatch(sym) {
        const next = inWatch(sym) ? S.watch.filter(x => x !== sym) : S.watch.concat([sym]);
        if (next.length > (S.cfg.watchMax || 20)) { toast('Lista de favoritos cheia'); return false; }
        S.watch = next; Sound.play('click'); const r = await Bridge.rpc('stocks.watchlist.set', { symbols: next }); if (r && Array.isArray(r.symbols)) S.watch = r.symbols;
        if (S.mkt) S.mkt.paint(); return inWatch(sym);
      }
      const start = () => { stop(); S.timer = setInterval(pullMarket, Math.max(10, +S.cfg.tick || 60) * 1000); };
      const stop = () => { if (S.timer) clearInterval(S.timer); S.timer = null; };
      win._stk = { start, stop, pull: pullMarket };
      /* tema trocado com a app aberta: os canvas voltam a desenhar-se com as cores novas (a assinatura das séries inclui o tema) */
      const offState = Bridge.on('state', p => { if (p && ('theme' in p || 'dark' in p)) setTimeout(() => { if (S.mkt) S.mkt.paint(); if (S.detail) S.detail.tick(); }, 40); });
      const prevClose = win.onClose; win.onClose = () => { stop(); offState(); if (S.detail) S.detail.destroy(); prevClose && prevClose(); };

      /* ================= MERCADO ================= */
      const marketView = () => {
        const v = UI.view({ title: 'Bolsa', large: true, right: [{ icon: 'bell', onTap: () => alertsSheet() }] });
        const root = UI.el(`<div class="stk-mkt">
          <div class="stk-idx"><div class="stk-idx-l"><span class="stk-idx-t">LSX</span><b class="stk-idx-v">--</b><em class="stk-pill">--</em><small>Índice Los Santos</small></div><canvas class="stk-idx-g" width="132" height="54"></canvas></div>
          <div class="stk-chips"></div>
          <div class="stk-rows"></div>
          <div class="stk-none"></div>
          <div class="stk-foot">Mercado simulado. As cotações atualizam a cada minuto no servidor e são iguais para todos os jogadores.</div></div>`);
        const search = UI.search('Pesquisar empresas', q => { S.filter = q; paint(); });
        v.content.appendChild(search); v.content.appendChild(root);
        const $ = s => root.querySelector(s);
        const chips = UI.chips(['Todas', 'Favoritas'], S.onlyWatch ? 1 : 0, i => { S.onlyWatch = i === 1; paint(); }); $('.stk-chips').appendChild(chips);
        const rows = $('.stk-rows'), none = $('.stk-none'); none.hidden = true;
        const build = it => { const el = UI.el(`<div class="stk-row"><div class="stk-sym"><b></b><span></span></div><canvas class="stk-sp" width="76" height="30"></canvas><div class="stk-px"><b></b><em class="stk-pill"></em></div></div>`);
          el.onclick = () => openDetail(el.dataset.k); return el; };
        const update = (el, it) => { const up = (+it.change || 0) >= 0; setTxt(el.querySelector('.stk-sym b'), it.symbol); setTxt(el.querySelector('.stk-sym span'), it.name);
          setTxt(el.querySelector('.stk-px b'), money(it.price)); const pill = el.querySelector('.stk-pill'); setTxt(pill, pct(it.pct)); tone(pill, up); tone(el, up);
          el.classList.toggle('stk-fav', inWatch(it.symbol));
          const sig = (it.spark || []).length + '|' + (it.spark || [])[0] + '|' + it.price + '|' + up + '|' + dark(); if (el._sig !== sig) { el._sig = sig; spark(el.querySelector('canvas'), it.spark, up); } };
        function paint() {
          const m = S.market; if (!m) return;
          rows.querySelectorAll('.spinner').forEach(s => s.remove());
          const q = S.filter; let items = m.items.slice();
          if (S.onlyWatch) items = items.filter(x => inWatch(x.symbol));
          if (q) items = items.filter(x => (x.symbol + ' ' + x.name + ' ' + (x.sector || '')).toLowerCase().includes(q));
          keyed(rows, items, x => x.symbol, build, update);
          if (!items.length) { none.innerHTML = ''; none.appendChild(S.onlyWatch && !q ? UI.empty('star', 'Sem favoritos', 'Toca na estrela de uma empresa para a juntares aqui.') : UI.empty('search', 'Sem resultados', 'Nenhuma empresa com esse nome.')); none.hidden = false; } else none.hidden = true;
          const ix = m.index || {}; const up = (+ix.change || 0) >= 0;
          setTxt($('.stk-idx-v'), nf(ix.value)); const pill = $('.stk-idx-l .stk-pill'); setTxt(pill, `${signed(ix.change)} (${pct(ix.pct)})`); tone(pill, up); tone($('.stk-idx'), up);
          const sig = (ix.spark || []).length + '|' + ix.value + '|' + up + '|' + dark(); if (root._isig !== sig) { root._isig = sig; spark($('.stk-idx-g'), ix.spark, up); }
        }
        const disabled = () => { rows.innerHTML = ''; none.innerHTML = ''; none.appendChild(UI.empty('chart', 'Mercado fechado', 'A Bolsa está desativada neste servidor.')); none.hidden = false; };
        S.mkt = { paint, disabled };
        if (S.market) paint(); else { const sp = UI.spinner(); rows.appendChild(sp); }
        return v;
      };

      /* ================= DETALHE ================= */
      function openDetail(sym) {
        if (S.detail) S.detail.destroy();
        const it = itemOf(sym) || { symbol: sym, name: sym };
        let range = Store.get('stk:range', '1D'), q = null, starBtn = null;
        const v = UI.view({ title: sym, back: 'Bolsa', right: [
          { icon: 'star', cls: 'stk-star', onTap: async () => { const on = await toggleWatch(sym); starBtn && starBtn.classList.toggle('on', on); }, ref: b => { starBtn = b; b.classList.toggle('on', inWatch(sym)); } },
          { icon: 'bell', onTap: () => addAlert(sym) }] });
        const root = UI.el(`<div class="stk-det">
          <div class="stk-head"><div class="stk-hname"></div><div class="stk-hprice"><b></b><em class="stk-pill"></em></div><div class="stk-hsub"><span class="stk-hchg"></span><span class="stk-hwhen">Hoje</span></div></div>
          <div class="stk-segw"></div>
          <div class="stk-chart"><canvas width="408" height="230"></canvas><div class="stk-scrub"><div class="stk-scrub-l"></div><div class="stk-scrub-lb"></div></div></div>
          <div class="stk-stats"></div>
          <div class="stk-pos" hidden><div class="stk-pos-t">A tua posição</div><div class="stk-pos-g"></div></div>
          <div class="stk-btns"><div class="btn-p stk-buy">Comprar</div><div class="btn-p btn-s stk-sell">Vender</div></div>
          <div class="stk-alerts" hidden><div class="stk-sec">Alertas</div><div class="stk-alist"></div></div>
          <div class="stk-sec">Notícias</div><div class="stk-nlist"></div><div class="stk-nnone"></div></div>`);
        v.content.appendChild(root);
        const $ = s => root.querySelector(s);
        const seg = UI.seg(['1D', '1S', '1M'], ['1D', '1S', '1M'].indexOf(range), i => { range = ['1D', '1S', '1M'][i]; Store.set('stk:range', range); load(); }); $('.stk-segw').appendChild(seg);
        const cv = $('canvas'), scrub = $('.stk-scrub'), scrubL = $('.stk-scrub-l'), scrubLb = $('.stk-scrub-lb');
        const STATS = [['Abertura', 'open'], ['Máximo', 'high'], ['Mínimo', 'low'], ['Volume', 'volume'], ['Setor', 'sector'], ['Variação', 'change']];
        STATS.forEach(([l, k]) => $('.stk-stats').appendChild(UI.el(`<div class="stk-stat" data-k="${k}"><span>${esc(l)}</span><b>--</b></div>`)));
        let geo = null;
        function paintHead(d) {
          const up = (+d.change || 0) >= 0;
          setTxt($('.stk-hname'), d.name || sym); setTxt($('.stk-hprice b'), money(d.price)); const pill = $('.stk-hprice .stk-pill'); setTxt(pill, pct(d.pct)); tone(pill, up);
          setTxt($('.stk-hchg'), signed(d.change)); tone($('.stk-head'), up);
          STATS.forEach(([, k]) => { const b = root.querySelector(`.stk-stat[data-k="${k}"] b`); const val = k === 'volume' ? volTxt(d.volume) : k === 'sector' ? T(String(d.sector || '--')) : k === 'change' ? signed(d.change) : money(d[k]); setTxt(b, val); });
        }
        function paintPos(d) {
          const p = d.position; const box = $('.stk-pos'); box.hidden = !p; $('.stk-sell').classList.toggle('dis', !p);
          if (!p) return;
          const val = p.qty * d.price, inv = p.qty * p.avg, pnl = val - inv, up = pnl >= 0;
          const gr = $('.stk-pos-g'); if (!gr.children.length) [['qty', 'Ações'], ['avg', 'Preço médio'], ['val', 'Valor'], ['pnl', 'Ganho / perda']].forEach(([k, l]) => gr.appendChild(UI.el(`<div class="stk-stat" data-k="${k}"><span>${esc(l)}</span><b>--</b></div>`)));
          setTxt(gr.querySelector('[data-k="qty"] b'), String(p.qty)); setTxt(gr.querySelector('[data-k="avg"] b'), money(p.avg)); setTxt(gr.querySelector('[data-k="val"] b'), money(val));
          const pb = gr.querySelector('[data-k="pnl"] b'); setTxt(pb, `${signed(pnl)} (${pct(inv > 0 ? pnl / inv * 100 : 0)})`); tone(pb, up);
        }
        function paintNews(d) {
          const list = $('.stk-nlist'), none = $('.stk-nnone'); const news = d.news || [];
          keyed(list, news, n => n.id || n.created, () => UI.el('<div class="stk-nitem"><div class="stk-ntop"><em class="stk-pill"></em><span class="stk-ntime"></span></div><b class="stk-ntitle"></b></div>'),
            (el, n) => { const up = (+n.effect || 0) >= 0; const pill = el.querySelector('.stk-pill'); setTxt(pill, pct((+n.effect || 0) * 100)); tone(pill, up); setTxt(el.querySelector('.stk-ntime'), UI.rel(n.created)); setTxt(el.querySelector('.stk-ntitle'), headline(Object.assign({ name: d.name }, n))); });
          none.innerHTML = ''; if (!news.length) { none.appendChild(UI.el(`<div class="stk-foot">${esc(T('Ainda não há notícias sobre esta empresa.'))}</div>`)); }
        }
        function paintAlerts(d) {
          const al = d.alerts || []; const box = $('.stk-alerts'); box.hidden = !al.length;
          keyed($('.stk-alist'), al, a => a.id, () => { const el = UI.el('<div class="stk-aitem"><span class="stk-abell"></span><b></b><i class="stk-adel"></i></div>'); el.querySelector('.stk-abell').innerHTML = g('bell', 18); el.querySelector('.stk-adel').innerHTML = g('x', 16);
            el.querySelector('.stk-adel').onclick = async e => { e.stopPropagation(); const r = await Bridge.rpcRaw('stocks.alerts.remove', { id: +el.dataset.k }); if (r && r.ok) { toast('Alerta removido'); load(); } }; return el; },
            (el, a) => setTxt(el.querySelector('b'), TF(a.above ? 'Avisar quando subir para %s' : 'Avisar quando descer para %s', money(a.price))));
        }
        function paintChart(d) { geo = drawChart(cv, d.points, { base: range === '1D' ? d.open : (d.points && d.points[0] ? d.points[0][1] : null), up: (range === '1D' ? (+d.change || 0) : ((d.points && d.points.length > 1) ? d.price - d.points[0][1] : 0)) >= 0, range }); setTxt($('.stk-hwhen'), range === '1D' ? 'Hoje' : range === '1S' ? 'Esta semana' : 'Este mês'); }
        async function load() {
          const r = await Bridge.rpcRaw('stocks.quote', { symbol: sym, range });
          if (!r || r.error) { if (!q) { $('.stk-nnone').appendChild(UI.el(`<div class="stk-foot">${esc(T('Não foi possível carregar a cotação.'))}</div>`)); } return; }
          q = r; paintHead(q); paintChart(q); paintPos(q); paintNews(q); paintAlerts(q); if (starBtn) starBtn.classList.toggle('on', !!q.inWatch);
        }
        /* dedo a percorrer o gráfico: linha + etiqueta movem-se só por transform; o cabeçalho mostra o preço nesse ponto */
        let scrubbing = false;
        const scrubTo = clientX => { if (!geo) return; const r = UI.vrect ? UI.vrect(cv) : cv.getBoundingClientRect(); if (!r.width) return; const x = (clientX - r.left) / r.width * cv.width;
          let best = geo.list[0], bd = Infinity; geo.list.forEach(p => { const d = Math.abs(geo.X(p[0]) - x); if (d < bd) { bd = d; best = p; } });
          const px = geo.X(best[0]); scrubL.style.transform = `translateX(${px.toFixed(1)}px)`; const lw = 150; const lx = Math.max(0, Math.min(cv.width - lw, px - lw / 2)); scrubLb.style.transform = `translateX(${lx.toFixed(1)}px)`;
          scrubLb.textContent = money(best[1]) + ' · ' + (range === '1D' ? UI.fmtTime(new Date(best[0])) : UI.fmtDate(new Date(best[0]), true)); setTxt($('.stk-hprice b'), money(best[1])); };
        $('.stk-chart').addEventListener('pointerdown', e => { if (!geo || (e.button && e.pointerType === 'mouse')) return; scrubbing = true; scrub.classList.add('on'); try { e.currentTarget.setPointerCapture(e.pointerId); } catch (x) {} scrubTo(e.clientX); });
        $('.stk-chart').addEventListener('pointermove', e => { if (scrubbing) scrubTo(e.clientX); });
        const scrubEnd = () => { if (!scrubbing) return; scrubbing = false; scrub.classList.remove('on'); if (q) setTxt($('.stk-hprice b'), money(q.price)); };
        $('.stk-chart').addEventListener('pointerup', scrubEnd); $('.stk-chart').addEventListener('pointercancel', scrubEnd);
        $('.stk-buy').onclick = () => q && trade(true, q, load);
        $('.stk-sell').onclick = () => { if (!q) return; if (!q.position) { toast('Não tens ações desta empresa'); return; } trade(false, q, load); };
        paintHead(it); drawChart(cv, null, {}); load();
        S.detail = { tick: () => { const cur = itemOf(sym); if (!cur || !q || scrubbing) return; Object.assign(q, { price: cur.price, change: cur.change, pct: cur.pct, high: cur.high, low: cur.low, volume: cur.volume, open: cur.open }); paintHead(q); paintPos(q); if (q.points && q.points.length) { q.points[q.points.length - 1] = [Date.now(), cur.price]; paintChart(q); } },
          destroy: () => { if (S.detail && S.detail.v === v) S.detail = null; }, reload: load, v };
        const prevPop = v.opts.onPop; v.opts.onPop = () => { if (S.detail && S.detail.v === v) S.detail = null; prevPop && prevPop(); };
        UI.push(win, v);
      }

      /* ================= COMPRAR / VENDER ================= */
      function trade(buy, qd, after) {
        if (window.CC && CC.requireNet && !CC.requireNet(buy ? 'comprar ações' : 'vender ações')) return;
        const fee = +S.cfg.fee || 0, maxQ = +S.cfg.maxQty || 10000, have = qd.position ? qd.position.qty : 0;
        const bank = (window.System && System.player && System.player.money && +System.player.money.bank) || 0;
        const body = UI.el(`<div class="stk-trade"><div class="stk-trow"><span>Preço</span><b class="stk-tp"></b></div>
          <div class="stk-qty"><div class="stk-qb stk-minus">${g('minus', 20)}</div><input type="number" inputmode="numeric" min="1" max="${maxQ}" value="1" class="stk-qin"><div class="stk-qb stk-plus">${g('plus', 20)}</div></div>
          <div class="stk-tmax"></div>
          <div class="stk-trow"><span>Subtotal</span><b class="stk-tsub"></b></div><div class="stk-trow"><span class="stk-tfee-l"></span><b class="stk-tfee"></b></div>
          <div class="stk-trow stk-ttot"><span>Total</span><b class="stk-ttv"></b></div><div class="stk-tbank"></div></div>`);
        const inp = body.querySelector('.stk-qin'); const $ = s => body.querySelector(s);
        setTxt($('.stk-tp'), money(qd.price)); setTxt($('.stk-tfee-l'), TF('Taxa (%s)', nf(fee * 100, 2) + ' %'));
        if (buy) setTxt($('.stk-tbank'), TF('Saldo no banco: %s', money(bank))); else setTxt($('.stk-tbank'), TF('Tens %s ações. O valor entra na conta bancária.', String(have)));
        const maxB = $('.stk-tmax'); if (!buy) { maxB.textContent = T('Vender tudo'); maxB.onclick = () => { inp.value = String(have); calc(); }; } else { maxB.textContent = T('Máximo com o saldo'); maxB.onclick = () => { const n = Math.max(1, Math.min(maxQ, Math.floor(bank / (qd.price * (1 + fee))))); inp.value = String(n); calc(); }; }
        const qty = () => Math.max(0, Math.min(maxQ, Math.floor(+inp.value || 0)));
        const calc = () => { const n = qty(); const gross = n * qd.price; const f = Math.ceil(gross * fee); const tot = buy ? Math.ceil(gross) + f : Math.max(0, Math.floor(gross) - f);
          setTxt($('.stk-tsub'), money(gross)); setTxt($('.stk-tfee'), (buy ? '+' : '-') + money(f)); setTxt($('.stk-ttv'), money(tot)); body.classList.toggle('over', buy ? tot > bank : n > have); };
        inp.oninput = calc; $('.stk-minus').onclick = () => { inp.value = String(Math.max(1, qty() - 1)); calc(); }; $('.stk-plus').onclick = () => { inp.value = String(Math.min(maxQ, qty() + 1)); calc(); }; calc();
        const sh = UI.sheet({ title: TF(buy ? 'Comprar %s' : 'Vender %s', qd.symbol), left: 'Cancelar', right: buy ? 'Comprar' : 'Vender', body, onDone: () => {
          const n = qty(); if (!(n >= 1)) { toast('Indica a quantidade'); return false; }
          if (!buy && n > have) { toast('Não tens ações suficientes'); return false; }
          const gross = n * qd.price, f = Math.ceil(gross * fee), tot = buy ? Math.ceil(gross) + f : Math.max(0, Math.floor(gross) - f);
          UI.confirm(T(buy ? 'Confirmar compra' : 'Confirmar venda'), TF(buy ? 'Comprar %s ações de %s por %s?' : 'Vender %s ações de %s por %s?', String(n), qd.symbol, money(tot)), T(buy ? 'Comprar' : 'Vender')).then(ok => {
            if (!ok) return;
            Bridge.rpcRaw(buy ? 'stocks.buy' : 'stocks.sell', { symbol: qd.symbol, qty: n }).then(r => {
              if (!r || !r.ok) { Sound.play('error'); const e = r && r.error; UI.alert({ title: T('Não foi possível'), msg: e === 'funds' ? T('Não tens dinheiro suficiente no banco.') : e === 'shares' ? T('Não tens ações suficientes.') : e === 'invalid' ? T('Quantidade fora do que o servidor aceita.') : e === 'disabled' ? T('A Bolsa está desativada neste servidor.') : T('Tenta novamente.'), foot: e && e !== 'funds' && e !== 'shares' ? e : undefined }); return; }
              Sound.play('success'); toast(TF(buy ? 'Compraste %s %s por %s' : 'Vendeste %s %s por %s', String(r.qty), r.symbol, money(r.total)));
              after && after(); pullMarket();
            });
          });
        } });
        setTimeout(() => { try { inp.focus(); inp.select(); } catch (e) {} }, 350);
        return sh;
      }

      /* ================= ALERTAS ================= */
      async function addAlert(sym) {
        const cur = itemOf(sym); const s = await UI.prompt(T('Alerta de preço'), TF('Avisar quando %s chegar a', sym) + (cur ? ` (${T('agora')} ${money(cur.price)})` : ''), '0,00', '', 'text');
        if (s == null) return; const price = parseFloat(String(s).replace(/\s/g, '').replace(',', '.'));
        if (!(price > 0)) { toast('Indica um preço válido'); return; }
        const r = await Bridge.rpcRaw('stocks.alerts.set', { symbol: sym, price });
        if (!r || !r.ok) { Sound.play('error'); toast(r && r.error === 'limit' ? 'Já tens alertas a mais' : r && r.error === 'invalid' ? 'Esse preço é o atual' : 'Não foi possível criar o alerta'); return; }
        Sound.play('success'); toast(TF(r.above ? 'Avisamos quando %s subir para %s' : 'Avisamos quando %s descer para %s', sym, money(r.price)));
        if (S.detail && S.detail.reload) S.detail.reload();
      }
      async function alertsSheet() {
        const body = UI.el('<div class="stk-alsheet"></div>'); const holder = UI.el('<div></div>'); body.appendChild(holder); holder.appendChild(UI.spinner());
        const sh = UI.sheet({ title: 'Alertas de preço', right: 'OK', body });
        const paint = async () => { const list = await Bridge.rpc('stocks.alerts.get'); holder.innerHTML = '';
          if (!Array.isArray(list) || !list.length) { holder.appendChild(UI.empty('bell', 'Sem alertas', 'Abre uma empresa e toca no sino para criares um alerta de preço.')); return; }
          holder.appendChild(UI.list([{ items: list.map(a => ({ icon: a.above ? 'arrowUp' : 'arrowDown', iconBg: a.above ? 'var(--green)' : 'var(--red)', label: a.symbol + ' · ' + money(a.price), sub: TF(a.above ? 'Quando subir para %s' : 'Quando descer para %s', money(a.price)) + (a.current != null ? ' · ' + T('agora') + ' ' + money(a.current) : ''), chevron: false,
            right: (() => { const x = UI.el(`<div class="stk-adel nostop">${g('trash', 18)}</div>`); x.onclick = async e => { e.stopPropagation(); const r = await Bridge.rpcRaw('stocks.alerts.remove', { id: a.id }); if (r && r.ok) { Sound.play('click'); paint(); } }; return x; })() })) }])); };
        paint(); return sh;
      }

      /* ================= CARTEIRA ================= */
      const portfolioView = () => {
        const v = UI.view({ title: 'Carteira', large: true });
        const root = UI.el(`<div class="stk-pf">
          <div class="stk-pf-hero"><span>Valor da carteira</span><b class="stk-pf-v">--</b><em class="stk-pill">--</em><div class="stk-pf-rows"><div><span>Investido</span><b class="stk-pf-inv">--</b></div><div><span>Saldo no banco</span><b class="stk-pf-bank">--</b></div></div></div>
          <div class="stk-sec stk-pf-sec1">Posições</div><div class="stk-rows stk-pf-pos"></div><div class="stk-none stk-pf-none"></div>
          <div class="stk-sec stk-pf-sec2">Movimentos</div><div class="stk-trades"></div></div>`);
        v.content.appendChild(root); const $ = s => root.querySelector(s);
        const pos = $('.stk-pf-pos'), none = $('.stk-pf-none'), trades = $('.stk-trades');
        const buildP = it => { const el = UI.el('<div class="stk-row"><div class="stk-sym"><b></b><span></span></div><div class="stk-px"><b></b><em class="stk-pill"></em></div></div>'); el.onclick = () => { tabs.go(0); setTimeout(() => openDetail(el.dataset.k), 60); }; return el; };
        const updP = (el, p) => { const up = (+p.pnl || 0) >= 0; setTxt(el.querySelector('.stk-sym b'), p.symbol); setTxt(el.querySelector('.stk-sym span'), TF('%s ações · média %s', String(p.qty), money(p.avg))); setTxt(el.querySelector('.stk-px b'), money(p.value)); const pill = el.querySelector('.stk-pill'); setTxt(pill, `${signed(p.pnl)} · ${pct(p.pnlPct)}`); tone(pill, up); tone(el, up); };
        const buildT = () => UI.el('<div class="stk-titem"><div class="stk-tic"></div><div class="stk-tb"><b></b><span></span></div><div class="stk-tv"><b></b><span></span></div></div>');
        const updT = (el, t) => { const buy = t.side === 'buy'; el.querySelector('.stk-tic').innerHTML = g(buy ? 'arrowDown' : 'arrowUp', 18); el.classList.toggle('buy', buy); el.classList.toggle('sell', !buy);
          setTxt(el.querySelector('.stk-tb b'), TF(buy ? 'Compra de %s' : 'Venda de %s', t.symbol)); setTxt(el.querySelector('.stk-tb span'), TF('%s ações a %s', String(t.qty), money(t.price)) + ' · ' + UI.rel(t.created)); setTxt(el.querySelector('.stk-tv b'), (buy ? '-' : '+') + money(t.total)); setTxt(el.querySelector('.stk-tv span'), TF('taxa %s', money(t.fee))); };
        let busy = false;
        async function load() {
          if (busy) return; busy = true; const r = await Bridge.rpcRaw('stocks.portfolio'); busy = false; if (!v.isConnected) return;
          if (!r || r.error) { none.innerHTML = ''; none.appendChild(UI.empty('chart', 'Carteira indisponível', r && r.error === 'disabled' ? 'A Bolsa está desativada neste servidor.' : 'Tenta novamente daqui a pouco.')); none.hidden = false; return; }
          S.pfData = r; const up = (+r.pnl || 0) >= 0;
          setTxt($('.stk-pf-v'), money(r.value)); const pill = $('.stk-pf-hero .stk-pill'); setTxt(pill, `${signed(r.pnl)} (${pct(r.pnlPct)})`); tone(pill, up); tone($('.stk-pf-hero'), up);
          setTxt($('.stk-pf-inv'), money(r.invested)); setTxt($('.stk-pf-bank'), r.bank != null ? money(r.bank) : '--');
          keyed(pos, r.positions || [], p => p.symbol, buildP, updP);
          if (!(r.positions || []).length) { none.innerHTML = ''; none.appendChild(UI.empty('chart', 'Sem posições', 'Compra ações no Mercado para começar.')); none.hidden = false; } else none.hidden = true;
          keyed(trades, r.trades || [], t => t.id, buildT, updT);
          $('.stk-pf-sec2').hidden = !(r.trades || []).length;
        }
        S.pf = { load, visible: () => v.isConnected && System.currentApp && System.currentApp() === 'stocks' };
        load(); return v;
      };

      /* ================= NOTÍCIAS ================= */
      const newsView = () => {
        const v = UI.view({ title: 'Notícias', large: true });
        const root = UI.el('<div class="stk-newsv"><div class="stk-nlist"></div><div class="stk-none"></div></div>'); v.content.appendChild(root);
        const list = root.querySelector('.stk-nlist'), none = root.querySelector('.stk-none');
        async function load() { const r = await Bridge.rpc('stocks.news', { limit: 60 }); if (!v.isConnected) return; const news = Array.isArray(r) ? r : [];
          keyed(list, news, n => n.id || n.created, () => { const el = UI.el('<div class="stk-nitem stk-ncard"><div class="stk-ntop"><em class="stk-nsym"></em><em class="stk-pill"></em><span class="stk-ntime"></span></div><b class="stk-ntitle"></b></div>'); el.onclick = () => openDetail(el.dataset.s); return el; },
            (el, n) => { const up = (+n.effect || 0) >= 0; el.dataset.s = n.symbol; setTxt(el.querySelector('.stk-nsym'), n.symbol); const pill = el.querySelector('.stk-pill'); setTxt(pill, pct((+n.effect || 0) * 100)); tone(pill, up); setTxt(el.querySelector('.stk-ntime'), UI.rel(n.created)); setTxt(el.querySelector('.stk-ntitle'), headline(n)); });
          none.innerHTML = ''; if (!news.length) { none.appendChild(UI.empty('list', 'Sem notícias', 'As notícias do mercado aparecem aqui ao longo do dia.')); none.hidden = false; } else none.hidden = true; }
        S.news = { load }; load(); return v;
      };

      const tabs = UI.tabbar(win, [{ icon: 'chart', label: 'Mercado', view: marketView }, { icon: 'bank', label: 'Carteira', view: portfolioView }, { icon: 'newspaper', label: 'Notícias', view: newsView }], 0);
      loadCfg().then(() => { pullMarket(); pullWatch(); start(); });
    },
    resume(win) { if (win._stk) { win._stk.pull(); win._stk.start(); } },
    pause(win) { if (win._stk) win._stk.stop(); },
  });

  /* ---------- widget: índice LSX (2×2) e o índice com as maiores subidas e descidas (4×2) ---------- */
  if (window.Widgets && Widgets.register) {
    let W = null, Wt = 0, Wbusy = false;
    const pull = () => { if (Wbusy || Date.now() - Wt < 90000 || !window.Bridge) return; Wbusy = true;
      Promise.resolve().then(() => Bridge.rpc('stocks.market')).then(r => { Wbusy = false; Wt = Date.now(); if (!r || !r.index) return; const sig = r.index.value + '|' + (r.index.spark || []).length; if (W && W.sig === sig) return; W = { r, sig }; Widgets.refreshType('stocks'); }).catch(() => { Wbusy = false; Wt = Date.now(); }); };
    const sparkSvg = (s, w, h) => { s = (s || []).map(Number).filter(v => isFinite(v)); if (s.length < 2) return `<svg class="stk-wg" viewBox="0 0 ${w} ${h}" preserveAspectRatio="none"><path class="b" d="M0 ${h / 2}H${w}" vector-effect="non-scaling-stroke"/></svg>`;
      const mn = Math.min(...s), mx = Math.max(...s), sp = (mx - mn) || 1, Y = v => (h - 3 - (v - mn) / sp * (h - 6)).toFixed(2); const d = s.map((v, i) => (i ? 'L' : 'M') + (i / (s.length - 1) * w).toFixed(2) + ' ' + Y(v)).join(' ');
      return `<svg class="stk-wg" viewBox="0 0 ${w} ${h}" preserveAspectRatio="none" aria-hidden="true"><path class="a" d="${d} L${w} ${h} L0 ${h}Z"/><path class="l" d="${d}" vector-effect="non-scaling-stroke"/></svg>`; };
    Widgets.register({ id: 'stocks', name: 'Bolsa', sizes: ['2x2', '4x2'], app: 'stocks', style: 'padding:0', render: size => {
      setTimeout(pull, 0); const r = W && W.r; const ix = r ? r.index : null; const up = !ix || (+ix.change || 0) >= 0;
      const head = `<div class="stk-w-h"><b>LSX</b><span>${UI.esc(T('Bolsa'))}</span></div>`;
      const val = ix ? nf(ix.value) : '--', chg = ix ? `${signed(ix.change)} (${pct(ix.pct)})` : '--';
      if (size === '4x2') { const items = r ? r.items.slice().sort((a, b) => Math.abs(+b.pct) - Math.abs(+a.pct)).slice(0, 3) : [];
        return `<div class="stk-w s42 ${up ? 'up' : 'dn'}"><div class="stk-w-l">${head}<em class="stk-w-c">${UI.esc(chg)}</em><b class="stk-w-p">${UI.esc(val)}</b>${sparkSvg(ix && ix.spark, 160, 44)}</div><div class="stk-w-r">${items.map(x => `<div class="stk-w-row ${(+x.pct || 0) >= 0 ? 'up' : 'dn'}"><b>${UI.esc(x.symbol)}</b><span>${UI.esc(money(x.price))}</span><em>${UI.esc(pct(x.pct))}</em></div>`).join('') || `<div class="stk-w-none">${UI.esc(T('Sem dados'))}</div>`}</div></div>`; }
      return `<div class="stk-w s2 ${up ? 'up' : 'dn'}">${head}<em class="stk-w-c">${UI.esc(chg)}</em>${sparkSvg(ix && ix.spark, 100, 40)}<b class="stk-w-p">${UI.esc(val)}</b></div>`; } });
  }

  /* ================= fallback do browser (LocalDB): mercado fictício a andar ================= */
  if (window.LocalDB && LocalDB.register) (() => {
    const CO = [['PEAR', 'Pear Technologies', 'Tecnologia', 182.4, .016], ['VWSG', 'Vinewood Studios Group', 'Media', 64.1, .02], ['DPPH', 'Del Perro Pier Holdings', 'Turismo', 27.35, .018], ['LSEN', 'Los Santos Energy', 'Energia', 48.9, .011],
      ['SAFR', 'San Andreas Freight', 'Transportes', 112.2, .012], ['BCM', 'Blaine County Minerals', 'Industria', 15.7, .026], ['VESP', 'Vespucci Foods', 'Alimentacao', 39.8, .01], ['MAZE', 'Maze Capital', 'Financas', 230, .014],
      ['PLBX', 'Pillbox Health', 'Saude', 88.6, .013], ['RHR', 'Rockford Hills Realty', 'Imobiliario', 141.5, .015], ['GSM', 'Grove Street Motors', 'Automovel', 22.4, .023], ['PBF', 'Paleto Bay Fisheries', 'Alimentacao', 9.85, .021],
      ['ALTA', 'Alta Street Retail', 'Retalho', 56.3, .017], ['ZNCA', 'Zancudo Aerospace', 'Industria', 310, .019]];
    const HL = [['%s apresenta resultados acima do esperado', 1], ['Analistas sobem a recomendação da %s', 1], ['%s anuncia programa de recompra de ações', 1], ['Fundo de investimento reforça posição na %s', 1], ['%s falha as previsões do trimestre', -1], ['Diretor financeiro da %s demite-se sem aviso', -1], ['Investigação das autoridades atinge a %s', -1], ['Greve paralisa a %s durante dois dias', -1]];
    const FEE = .005, TICK = 60, G = Store.global || Store;
    const gauss = () => { const u = Math.max(1e-12, Math.random()); return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * Math.random()); };
    const mul = seed => () => { seed |= 0; seed = seed + 0x6D2B79F5 | 0; let t = Math.imul(seed ^ seed >>> 15, 1 | seed); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; };
    const hash = s => { let h = 2166136261; for (let i = 0; i < s.length; i++) { h ^= s.charCodeAt(i); h = Math.imul(h, 16777619); } return h >>> 0; };
    const r4 = v => Math.round(v * 1e4) / 1e4, r2 = v => Math.round(v * 100) / 100;
    const day = t => new Date(t).toISOString().slice(0, 10);
    /* arranque do mock: a sessão "já vai a meio do dia" (abertura diferente do preço, máximo e mínimo à volta), senão todas as
       variações eram 0,00 % até passar um minuto */
    const st = () => { let s = G.get('db:stocks', null); if (!s) { s = { t: Date.now(), day: day(Date.now()), co: {}, news: [], alerts: [], watch: ['PEAR', 'MAZE'], pf: {}, trades: [], seq: 1 }; CO.forEach(([sym, , , base], i) => { const k = 1 + ((i * 7919) % 13 - 6) / 100 * .6; const open = r4(base / k); s.co[sym] = { price: base, trend: 0, open, high: r4(Math.max(base, open) * 1.004), low: r4(Math.min(base, open) * .996), volume: 12000 + Math.floor(Math.random() * 30000) }; }); G.set('db:stocks', s); } return s; };
    const save = s => G.set('db:stocks', s);
    /* avança o mercado pelos minutos que passaram desde a última chamada (no máximo 240 passos) */
    function advance(s) { const now = Date.now(); let steps = Math.min(240, Math.floor((now - s.t) / (TICK * 1000))); if (steps <= 0) return s; const d = day(now);
      if (s.day !== d) { s.day = d; CO.forEach(([sym]) => { const c = s.co[sym]; c.open = c.price; c.high = c.price; c.low = c.price; c.volume = 0; }); }
      for (let k = 0; k < steps; k++) { CO.forEach(([sym, name, , base, vol]) => { const c = s.co[sym]; const v = vol / Math.sqrt(1440) * 1.4; c.trend = c.trend * .985 + gauss() * v * .08; const r = c.trend + Math.log(base / c.price) * .0006 + gauss() * v; c.price = Math.max(.5, r4(c.price * Math.exp(r))); c.high = Math.max(c.high, c.price); c.low = Math.min(c.low, c.price); c.volume += Math.floor((500000 / base + 300) * (0.6 + Math.random() * .8) * (1 + Math.abs(r) * 600));
        if (Math.random() < 1 / (6 * CO.length)) { const h = HL[Math.floor(Math.random() * HL.length)]; const imp = (0.006 + Math.random() * .029) * h[1]; c.price = r4(c.price * (1 + imp)); s.news.unshift({ id: s.seq++, symbol: sym, name, title: h[0], effect: r4(imp), created: s.t + (k + 1) * TICK * 1000 }); if (s.news.length > 80) s.news.pop(); } }); }
      s.t += steps * TICK * 1000; if (!s.news.length) { const c = CO[0]; s.news.unshift({ id: s.seq++, symbol: c[0], name: c[1], title: HL[0][0], effect: .0142, created: now - 36e5 }); }
      /* alertas */
      s.alerts = s.alerts.filter(a => { const c = s.co[a.symbol]; const hit = c && ((a.above && c.price >= a.price) || (!a.above && c.price <= a.price)); if (hit) LocalDB.notify('stocks', 'Alerta de preço', `${a.symbol} ${a.above ? 'subiu para' : 'desceu para'} ${UI.money(c.price)}`, { symbol: a.symbol }); return !hit; });
      save(s); return s; }
    const pubItem = (s, sym) => { const [, name, sector] = CO.find(x => x[0] === sym); const c = s.co[sym]; const chg = r4(c.price - c.open); return { symbol: sym, name, sector, price: c.price, open: c.open, high: c.high, low: c.low, volume: c.volume, change: chg, pct: c.open > 0 ? r4(chg / c.open * 100) : 0, spark: hist(sym, s).slice(-60).map(p => p[1]) }; };
    /* histórico determinístico (semente = símbolo + dia): 7 dias de pontos de 5 min a acabar no preço atual */
    const histCache = {};
    function hist(sym, s) { const key = sym + '|' + s.day + '|' + s.co[sym].price; if (histCache[key]) return histCache[key]; const rnd = mul(hash(key)); const n = 7 * 288, out = new Array(n); const vol = CO.find(x => x[0] === sym)[4] / Math.sqrt(288) * 1.2; let p = s.co[sym].price; const end = s.t - (s.t % 300000);
      for (let i = n - 1; i >= 0; i--) { out[i] = [end - (n - 1 - i) * 300000, r4(p)]; const u = Math.max(1e-12, rnd()); p = Math.max(.5, p * Math.exp(-(Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * rnd())) * vol)); }
      Object.keys(histCache).forEach(k => { if (k.startsWith(sym + '|')) delete histCache[k]; }); histCache[key] = out; return out; }
    const index = s => { const v = r2(CO.reduce((a, [sym, , , base]) => a + s.co[sym].price / base, 0) / CO.length * 1000), o = r2(CO.reduce((a, [sym, , , base]) => a + s.co[sym].open / base, 0) / CO.length * 1000); const sp = []; for (let i = 0; i < 60; i++) sp.push(r2(CO.reduce((a, [sym, , , base]) => { const h = hist(sym, s); const p = h[h.length - 60 + i]; return a + (p ? p[1] : s.co[sym].price) / base; }, 0) / CO.length * 1000)); return { value: v, open: o, change: r2(v - o), pct: o > 0 ? r4((v - o) / o * 100) : 0, spark: sp }; };
    LocalDB.register('stocks.config', () => ({ enabled: true, ready: true, fee: FEE, maxQty: 10000, maxOrder: 5e6, tick: TICK, alertsMax: 10, watchMax: 20 }));
    LocalDB.register('stocks.market', () => { const s = advance(st()); return { ok: true, t: Date.now(), tick: TICK, fee: FEE, index: index(s), items: CO.map(c => pubItem(s, c[0])) }; });
    LocalDB.register('stocks.quote', d => { const s = advance(st()); const sym = String(d.symbol || '').toUpperCase(); if (!s.co[sym]) return { error: 'symbol' }; const it = pubItem(s, sym); const h = hist(sym, s); const range = d.range === '1S' || d.range === '1M' ? d.range : '1D'; let pts;
      if (range === '1D') pts = h.slice(-288); else if (range === '1S') pts = h.filter((_, i) => i % 6 === 0); else { const rnd = mul(hash(sym + '|m')); let p = it.price; pts = []; for (let i = 0; i < 30; i++) { pts.unshift([Date.now() - i * 864e5, r4(p)]); p = Math.max(.5, p * (1 + (rnd() - .5) * .04)); } }
      pts = pts.concat([[Date.now(), it.price]]); const pos = s.pf[sym]; return Object.assign(it, { ok: true, range, points: pts, position: pos && pos.qty > 0 ? pos : null, news: s.news.filter(n => n.symbol === sym).slice(0, 12), inWatch: s.watch.includes(sym), alerts: s.alerts.filter(a => a.symbol === sym), fee: FEE, maxQty: 10000 }); });
    LocalDB.register('stocks.news', d => { const s = advance(st()); const sym = d.symbol ? String(d.symbol).toUpperCase() : null; return s.news.filter(n => !sym || n.symbol === sym).slice(0, Math.min(80, +d.limit || 40)); });
    LocalDB.register('stocks.buy', d => { const s = advance(st()); const sym = String(d.symbol || '').toUpperCase(); const c = s.co[sym]; if (!c) return { ok: false, error: 'symbol' }; const qty = Math.floor(+d.qty || 0); if (!(qty >= 1 && qty <= 10000)) return { ok: false, error: 'invalid' };
      const gross = qty * c.price, fee = Math.ceil(gross * FEE), total = Math.ceil(gross) + fee; const p = LocalDB.player(); if ((p.money.bank || 0) < total) return { ok: false, error: 'funds' }; p.money.bank -= total; LocalDB.savePlayer(p);
      const pos = s.pf[sym] || { qty: 0, avg: 0 }; pos.avg = r4((pos.avg * pos.qty + c.price * qty) / (pos.qty + qty)); pos.qty += qty; s.pf[sym] = pos; s.trades.unshift({ id: s.seq++, symbol: sym, name: CO.find(x => x[0] === sym)[1], side: 'buy', qty, price: c.price, fee, total, created: Date.now() }); save(s); return { ok: true, symbol: sym, qty, price: c.price, fee, total, position: pos }; });
    LocalDB.register('stocks.sell', d => { const s = advance(st()); const sym = String(d.symbol || '').toUpperCase(); const c = s.co[sym]; if (!c) return { ok: false, error: 'symbol' }; const qty = Math.floor(+d.qty || 0); if (!(qty >= 1)) return { ok: false, error: 'invalid' }; const pos = s.pf[sym]; if (!pos || pos.qty < qty) return { ok: false, error: 'shares' };
      const gross = qty * c.price, fee = Math.ceil(gross * FEE), net = Math.max(0, Math.floor(gross) - fee); pos.qty -= qty; if (pos.qty <= 0) delete s.pf[sym]; const p = LocalDB.player(); p.money.bank = (p.money.bank || 0) + net; LocalDB.savePlayer(p); s.trades.unshift({ id: s.seq++, symbol: sym, name: CO.find(x => x[0] === sym)[1], side: 'sell', qty, price: c.price, fee, total: net, created: Date.now() }); save(s); return { ok: true, symbol: sym, qty, price: c.price, fee, total: net, position: s.pf[sym] || null }; });
    LocalDB.register('stocks.portfolio', () => { const s = advance(st()); let value = 0, invested = 0; const positions = Object.keys(s.pf).map(sym => { const p = s.pf[sym], c = s.co[sym]; const v = r2(p.qty * c.price), inv = r2(p.qty * p.avg); value += v; invested += inv; return { symbol: sym, name: CO.find(x => x[0] === sym)[1], qty: p.qty, avg: p.avg, price: c.price, value: v, invested: inv, pnl: r2(v - inv), pnlPct: inv > 0 ? r4((v - inv) / inv * 100) : 0, dayPct: c.open > 0 ? r4((c.price - c.open) / c.open * 100) : 0 }; }).sort((a, b) => b.value - a.value);
      return { ok: true, value: r2(value), invested: r2(invested), pnl: r2(value - invested), pnlPct: invested > 0 ? r4((value - invested) / invested * 100) : 0, positions, trades: s.trades.slice(0, 40), bank: LocalDB.player().money.bank, fee: FEE }; });
    LocalDB.register('stocks.watchlist.get', () => ({ ok: true, symbols: st().watch }));
    LocalDB.register('stocks.watchlist.set', d => { const s = st(); s.watch = (Array.isArray(d.symbols) ? d.symbols : []).map(x => String(x).toUpperCase()).filter((x, i, a) => s.co[x] && a.indexOf(x) === i).slice(0, 20); save(s); return { ok: true, symbols: s.watch }; });
    LocalDB.register('stocks.alerts.get', () => { const s = st(); return s.alerts.map(a => Object.assign({ name: CO.find(x => x[0] === a.symbol)[1], current: s.co[a.symbol].price }, a)); });
    LocalDB.register('stocks.alerts.set', d => { const s = st(); const sym = String(d.symbol || '').toUpperCase(); const c = s.co[sym]; if (!c) return { ok: false, error: 'symbol' }; const price = r4(+d.price); if (!(price > 0) || Math.abs(price - c.price) < 1e-4) return { ok: false, error: 'invalid' }; if (s.alerts.length >= 10) return { ok: false, error: 'limit' }; const a = { id: s.seq++, symbol: sym, price, above: price > c.price, created: Date.now() }; s.alerts.push(a); save(s); return Object.assign({ ok: true }, a); });
    LocalDB.register('stocks.alerts.remove', d => { const s = st(); const n = s.alerts.length; s.alerts = s.alerts.filter(a => a.id !== +d.id); save(s); return n === s.alerts.length ? { ok: false, error: 'notfound' } : { ok: true }; });
  })();
})();
