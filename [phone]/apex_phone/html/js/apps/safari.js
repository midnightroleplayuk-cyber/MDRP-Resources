/* ===================== SAFARI ===================== */
App.define('safari', {
  name: 'Surf', landscape: true,
  /* ⚠️ SAIR DA APP TEM DE PARAR A PÁGINA. Fechar a app só ESCONDE a janela (`.bg{display:none}`):
     o iframe continuava a correr JS, vídeo, áudio e rede para sempre, dentro do CEF, com o
     telemóvel guardado. O `pause`/`resume` são ganchos que o próprio sistema já chama quando
     esconde e reexpõe a janela; guarda-se o endereço para a página voltar onde estava. */
  pause(win) { const f = win.querySelector('.web-frame, .aweb-frame'); if (f && f.src && f.src !== 'about:blank') { f.dataset.last = f.src; f.src = 'about:blank'; } },
  resume(win) { const f = win.querySelector('.web-frame, .aweb-frame'); if (f && f.dataset.last && (!f.src || f.src === 'about:blank')) f.src = f.dataset.last; },
  /* botão Voltar do sistema (Nova UI): volta à página anterior do separador antes de fechar a app; true = consumido */
  back(win) { return !!(win && win._back && win._back()); },
  open(win) {
    /* só sites que ABREM dentro de um iframe (verificado: sem X-Frame-Options/frame-ancestors). Google, YouTube, redes sociais,
       DuckDuckGo e OpenStreetMap recusam e ficavam em branco - saíram. Os sites do servidor (Config.Browser.sites) vêm primeiro. */
    const BASE_FAVS = [['Wikipédia', 'https://pt.m.wikipedia.org', '#333', 'W'], ['Pesquisa', 'https://www.bing.com', '#0A84FF', ''], ['Meteorologia', 'https://wttr.in/?lang=pt', '#32ADE6', '☀'], ['Calculadora', 'https://www.calculator.net', '#FF9F0A', '±'], ['wikiHow', 'https://www.wikihow.com', '#93B874', 'w']];
    const FAVS = [];

    /* ---- interruptor e lista de sites do servidor ----
       O iframe carrega QUALQUER endereço escrito pelo jogador dentro do CEF do jogo (som, vídeo,
       publicidade) e o dono do servidor não tinha como o desligar. A decisão é dele: isto lê
       System.config.safari - `{ enabled: false }` desliga o navegador e `{ allow: ['pt.wikipedia.org', …] }`
       limita-o a essa lista (os subdomínios contam: 'wikipedia.org' deixa passar 'pt.wikipedia.org').
       O valor vem no `ready` e quem o põe no System.config é o applyReadyConfig (js/system.js).
       ⚠️ SEM CONFIG NÃO HÁ LIMITE NENHUM e é assim que tem de ler-se: o navegador abre tudo, como
       sempre, e nenhum texto desta app fala de bloqueios - o "Site não permitido" e o "Navegador
       desligado" só aparecem quando a lista (ou o interruptor) existe mesmo. Cada campo é validado
       aqui: um `allow` que não seja uma lista com coisas lá dentro é o mesmo que não haver `allow`. */
    const CFG = () => { const c = window.System && System.config && System.config.safari; return c && typeof c === 'object' && !Array.isArray(c) ? c : {}; };
    const desligado = () => CFG().enabled === false;
    const permitidos = () => { const a = CFG().allow; return Array.isArray(a) && a.length ? a.map(x => String(x).toLowerCase().replace(/^\.+/, '')) : null; };
    const hostOf = u => { try { return new URL(u).hostname.toLowerCase(); } catch (e) { return ''; } };
    const cfgSites = () => (Array.isArray(CFG().sites) ? CFG().sites : Object.values(CFG().sites || {})).filter(s => s && typeof s.url === 'string' && /^https?:\/\//i.test(s.url)).slice(0, 12).map(s => [String(s.name || s.url).slice(0, 24), s.url, /^#[0-9a-f]{3,8}$/i.test(s.color || '') ? s.color : '#5E5CE6', String(s.letter || '').slice(0, 2)]);
    FAVS.push(...cfgSites(), ...BASE_FAVS);
    const searchUrl = q => { const s = typeof CFG().search === 'string' && /^https?:\/\//i.test(CFG().search) ? CFG().search : 'https://www.bing.com/search?q='; return s + encodeURIComponent(q); };
    const barrado = u => { const a = permitidos(); if (!a) return false; const h = hostOf(u); return !h || !a.some(d => h === d || h.endsWith('.' + d)); };

    if (desligado()) {
      const off = UI.view({ title: App.name('safari') });
      off.content.appendChild(UI.empty('globe', 'Navegador desligado', System.isAndroid && System.isAndroid() ? 'O dono do servidor desligou o navegador neste telemóvel.' : 'O dono do servidor desligou o ' + App.name('safari') + ' neste telemóvel.'));
      UI.setRoot(win, off);
      return;
    }

    /* ---- separadores a sério ----
       Antes "3 separadores" era um contador gravado no Store e havia UM iframe: trocar de separador
       perdia a página e o número não queria dizer nada. Agora cada separador tem o SEU histórico e o
       iframe mostra o que está à frente; um separador em segundo plano é descarregado e, ao voltar,
       a página recarrega - é assim que não ficam três páginas a consumir som, vídeo e rede dentro do
       jogo (o mesmo motivo do pause/resume acima). Está escrito na folha dos separadores. */
    let tabs = [{ hist: [], pos: -1 }], act = 0;
    const T = () => tabs[act];
    const url = () => { const t = T(); return t.pos >= 0 ? t.hist[t.pos] : null; };
    /* marcadores: mesma camada de dados das outras apps (Agenda grava a semente e é o único sítio a
       trocar quando o servidor tiver a tabela). Vivem no telemóvel desta personagem. */
    const BM = () => [['Wikipédia', 'https://pt.m.wikipedia.org']];
    const bmList = () => Agenda.list('bookmarks', BM);

    /* ---- NOVA UI (Android): "Internet" ----
       Os mesmos separadores, marcadores, sites do servidor e limites do config; só o desenho é outro: barra de endereço em
       cima, barra de ferramentas em baixo (Voltar, Avançar, Início, Marcadores, Separadores, Menu), página inicial com acesso
       rápido em círculos, menu em painel e separadores em cartões. O histórico é o desta sessão (fica só em memória). */
    if (System.isAndroid && System.isAndroid()) {
      const g = UI.g, NAME = App.name('safari');
      const MENU = '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" width="24" height="24"><path d="M4 7h16M4 12h16M4 17h16"/></svg>';
      const PAL = ['#3E7BFA', '#2DBE60', '#FF8A1F', '#9B5CF2', '#F5476E', '#11A9C0', '#5866F2', '#A47A5A'];
      const colOf = s => { let h = 0; for (const ch of String(s)) h = (h * 31 + ch.charCodeAt(0)) | 0; return PAL[Math.abs(h) % PAL.length]; };
      const letterOf = (n, u) => (String(n || hostOf(u) || '?').replace(/^www\./, '').trim()[0] || '?').toUpperCase();
      const nice = u => String(u || '').replace(/^https?:\/\//, '').replace(/\/$/, '');
      const hist = [];   /* histórico desta sessão: { u, t } do mais recente para o mais antigo */
      const root = UI.el(`<div class="aweb"><div class="aweb-top"><div class="aweb-url"><span class="aweb-lk">${g('search', 18)}</span><input type="text" spellcheck="false" autocomplete="off" placeholder="Pesquisar ou escrever endereço"><div class="aweb-rl">${g('update', 20)}</div></div></div>
        <div class="aweb-body"><div class="aweb-start"></div><iframe class="aweb-frame hidden" sandbox="allow-scripts allow-same-origin allow-forms allow-popups"></iframe></div>
        <div class="aweb-bar"><div class="aweb-b back dis">${g('chevL', 26)}</div><div class="aweb-b fwd dis">${g('chevR', 26)}</div><div class="aweb-b home">${g('home', 24)}</div><div class="aweb-b bmk">${g('star', 24)}</div><div class="aweb-b tabs"><span class="aweb-tn">1</span></div><div class="aweb-b menu">${MENU}</div></div></div>`);
      const $ = s => root.querySelector(s);
      const start = $('.aweb-start'), frame = $('.aweb-frame'), inp = $('.aweb-url input');
      const tile = (n, u, c, l) => { const t = UI.el(`<div class="aweb-qa"><div class="aweb-qi"></div><span></span></div>`); const qi = t.querySelector('.aweb-qi'); qi.style.background = c || colOf(u); qi.innerHTML = l ? UI.esc(l) : UI.esc(letterOf(n, u)); t.querySelector('span').textContent = n; t.onclick = () => go(u); return t; };
      function paintStart() {
        start.innerHTML = '';
        const hero = UI.el(`<div class="aweb-hero"><div class="aweb-logo">${g('globe', 34)}</div><b></b></div>`); hero.querySelector('b').textContent = NAME; start.appendChild(hero);
        const favs = FAVS.filter(([, u]) => !barrado(u));
        const same = (a, b) => nice(a).toLowerCase() === nice(b).toLowerCase();
        const bms = bmList().filter(x => Array.isArray(x) && x[1] && !barrado(x[1]) && !favs.some(([, u]) => same(u, x[1])));   /* um marcador igual a um favorito não aparece duas vezes */
        start.appendChild(UI.el('<div class="aweb-sec">Acesso rápido</div>'));
        const grid = UI.el('<div class="aweb-qgrid"></div>');
        favs.forEach(([n, u, c, l]) => grid.appendChild(tile(n, u, c, l)));
        bms.forEach(([n, u]) => { const t = tile(n, u); UI.longPress(t, async () => { if (await UI.confirm('Remover marcador', n, 'Remover', true)) { Agenda.edit('bookmarks', BM, l => { const i = l.findIndex(x => x && x[1] === u && x[0] === n); if (i > -1) l.splice(i, 1); }); paintStart(); } }); grid.appendChild(t); });
        if (grid.children.length) start.appendChild(grid);
        else if (permitidos()) start.appendChild(UI.el('<div class="aweb-note">Nenhum dos favoritos de origem está na lista de sites permitidos deste servidor.</div>'));
        const city = [['Pedir um serviço', 'Polícia, EMS, mecânico, táxi', 'services', 'lifebuoy', '#3E7BFA'], ['Pedir comida', 'Restaurantes com entrega', 'eats', 'cart', '#F5476E'], ['Comprar e vender', 'Anúncios da cidade', 'marketplace', 'tag', '#2DBE60'], ['Mapa da cidade', 'Locais e GPS', 'maps', 'map', '#FF8A1F'], ['Perguntar à Vera', 'Dúvidas sobre o servidor, contas, tempo', 'aichat', 'sparkles', '#9B5CF2']]
          .filter(([, , id]) => window.App && App.get(id) && (!System.installed || System.installed().includes(id)));
        if (city.length) {
          start.appendChild(UI.el('<div class="aweb-sec">Na cidade</div>'));
          const card = UI.el('<div class="aweb-card"></div>');
          city.forEach(([label, sub, id, icon, bg]) => { const r = UI.el(`<div class="aweb-row"><div class="aweb-ric" style="background:${bg}">${g(icon, 20)}</div><div class="aweb-rb"><b></b><span></span></div>${g('chevR', 18)}</div>`); r.querySelector('b').textContent = label; r.querySelector('span').textContent = sub; r.onclick = () => System.openApp(id); card.appendChild(r); });
          start.appendChild(card);
        }
        start.appendChild(UI.el('<div class="aweb-note">Toque longo num site teu para o remover. Alguns sites recusam abrir dentro de outra página e ficam em branco, no jogo também: nesses não há nada a fazer deste lado.</div>'));
      }
      const show = () => { const u = url(); start.classList.toggle('hidden', !!u); frame.classList.toggle('hidden', !u);
        if (document.activeElement !== inp) inp.value = u ? nice(u) : '';
        $('.aweb-lk').innerHTML = g(u ? (/^https:/i.test(u) ? 'lock' : 'globe') : 'search', 18);
        const t = T(); $('.back').classList.toggle('dis', t.pos < 0); $('.fwd').classList.toggle('dis', t.pos >= t.hist.length - 1);
        $('.aweb-tn').textContent = tabs.length > 99 ? ':D' : tabs.length;
        const on = !!u && bmList().some(x => Array.isArray(x) && x[1] === u); $('.bmk').classList.toggle('on', on); $('.bmk').innerHTML = g(on ? 'starFill' : 'star', 24); };
      const load = () => { const u = url();
        if (u) { frame.dataset.last = u; if (frame.getAttribute('src') !== u) frame.src = u; }
        else { frame.removeAttribute('src'); frame.src = 'about:blank'; delete frame.dataset.last; }
        show(); };
      const go = u => {
        if (desligado()) { UI.alert({ title: 'Navegador desligado', msg: 'O dono do servidor desligou o navegador neste telemóvel.' }); return; }
        if (barrado(u)) { UI.alert({ title: 'Site não permitido', msg: 'Este servidor limitou o navegador a uma lista de sites.' }); return; }
        const t = T(); t.hist = t.hist.slice(0, t.pos + 1); t.hist.push(u); t.pos = t.hist.length - 1;
        const i = hist.findIndex(x => x.u === u); if (i > -1) hist.splice(i, 1); hist.unshift({ u, t: Date.now() }); if (hist.length > 60) hist.pop();
        load();
      };
      inp.onkeydown = e => { if (e.key !== 'Enter') return; let q = inp.value.trim(); if (!q) return; if (/^[\w.-]+\.[a-z]{2,}(\/.*)?$/i.test(q)) q = 'https://' + q; if (!/^https?:\/\//i.test(q)) q = searchUrl(q); inp.blur(); go(q); };
      inp.onfocus = () => { const u = url(); if (u) { inp.value = u; inp.select(); } };
      inp.onblur = () => setTimeout(show, 0);
      $('.aweb-rl').onclick = () => { const u = url(); if (u) { frame.removeAttribute('src'); frame.src = u; } };
      const back = () => { const t = T(); if (t.pos < 0) return false; t.pos--; load(); return true; };
      $('.back').onclick = back;
      $('.fwd').onclick = () => { const t = T(); if (t.pos < t.hist.length - 1) { t.pos++; load(); } };
      /* Início: a página inicial entra no histórico do separador como uma entrada vazia (Voltar regressa à página onde estava) */
      $('.home').onclick = () => { if (!url()) return; const t = T(); t.hist = t.hist.slice(0, t.pos + 1); t.hist.push(null); t.pos = t.hist.length - 1; load(); };
      const addBm = async () => {
        const u = url(); if (!u) { UI.alert({ title: 'Marcadores', msg: 'Abre uma página para a adicionar.' }); return; }
        if (bmList().some(x => Array.isArray(x) && x[1] === u)) { UI.toast('Já está nos marcadores'); return; }
        const n = await UI.prompt('Adicionar aos marcadores', nice(u), 'Nome', hostOf(u).replace(/^www\./, '')); if (!n) return;
        Agenda.edit('bookmarks', BM, l => l.push([n, u])); paintStart(); show();
        UI.toast('Adicionado aos marcadores');
      };
      $('.bmk').onclick = () => addBm();
      /* lista de marcadores (com remover) */
      const bookmarks = () => {
        const body = UI.el('<div class="aweb-sh"></div>'); let sh = null;
        const fill = () => { body.innerHTML = ''; const l = bmList().filter(x => Array.isArray(x) && x[1]);
          if (!l.length) { body.appendChild(UI.el('<div class="aweb-empty">Sem marcadores. Abre uma página e toca na estrela.</div>')); return; }
          const card = UI.el('<div class="aweb-card"></div>');
          l.forEach(([n, u]) => { const r = UI.el(`<div class="aweb-row"><div class="aweb-ric"></div><div class="aweb-rb"><b></b><span></span></div><div class="aweb-x">${g('x', 16)}</div></div>`); const ic = r.querySelector('.aweb-ric'); ic.style.background = colOf(u); ic.textContent = letterOf(n, u); r.querySelector('b').textContent = n; r.querySelector('span').textContent = nice(u);
            r.onclick = () => { sh.close(); go(u); };
            r.querySelector('.aweb-x').onclick = async e => { e.stopPropagation(); if (await UI.confirm('Remover marcador', n, 'Remover', true)) { Agenda.edit('bookmarks', BM, x => { const i = x.findIndex(y => y && y[1] === u && y[0] === n); if (i > -1) x.splice(i, 1); }); fill(); paintStart(); show(); } };
            card.appendChild(r); });
          body.appendChild(card); body.appendChild(UI.el('<div class="aweb-note">Os marcadores ficam guardados neste telemóvel e aparecem no acesso rápido.</div>')); };
        fill(); sh = UI.sheet({ title: 'Marcadores', right: 'OK', cls: 'aweb-list', body });
      };
      /* partilhar: a área de transferência do telemóvel (Msgs.copy) e, como recurso, a do sistema; o endereço fica selecionado */
      const copyUrl = u => { if (window.Msgs && typeof Msgs.copy === 'function') { Msgs.copy(u, true); UI.toast('Endereço copiado no telemóvel'); return; }
        let ok = false; try { const ta = document.createElement('textarea'); ta.value = u; root.appendChild(ta); ta.select(); ok = !!(document.execCommand && document.execCommand('copy')); ta.remove(); } catch (e) { ok = false; }
        UI.toast(ok ? 'Endereço copiado' : 'Não deu para copiar: usa Ctrl+C'); };
      const share = () => { const u = url(); if (!u) { UI.alert({ title: 'Partilhar', msg: 'Abre uma página primeiro.' }); return; }
        UI.actionSheet({ title: nice(u), buttons: [{ label: 'Copiar endereço', icon: 'copy', value: 'copy' }, { label: 'Enviar por mensagem', icon: 'message', value: 'msg' }, { label: 'Adicionar aos marcadores', icon: 'star', value: 'bm' }] }).then(async k => {
          if (k === 'copy') copyUrl(u);
          else if (k === 'bm') addBm();
          else if (k === 'msg') { const c = await Contacts.pick('Enviar a'); if (!c) return; const r = await Bridge.rpcRaw('messages.send', { to: c.number, type: 'text', content: u }); if (!r || r.error) { Sound.play('error'); UI.toast('Não consegui enviar'); return; } UI.toast('Enviado a ' + (c.name || c.number)); }
        }); };
      /* separadores em cartões (folha de ecrã inteiro); cada um guarda o seu histórico, só o da frente corre */
      const tabsSheet = () => {
        const body = UI.el('<div class="aweb-tabsv"><div class="aweb-tgrid"></div><div class="aweb-tbar"><div class="aweb-tbtn all">Fechar todos</div><div class="aweb-tbtn new">' + g('plus', 18) + '<span>Novo separador</span></div></div><div class="aweb-note">Só o separador da frente corre: ao voltar a um separador a página recarrega. É isso que evita ter páginas a consumir som, vídeo e rede dentro do jogo.</div></div>');
        let sh = null;
        const fill = () => { const gr = body.querySelector('.aweb-tgrid'); gr.innerHTML = '';
          tabs.forEach((t, i) => { const u = t.pos >= 0 ? t.hist[t.pos] : null;
            const c = UI.el(`<div class="aweb-tab${i === act ? ' on' : ''}"><div class="aweb-th"><i></i><span></span><div class="aweb-x">${g('x', 14)}</div></div><div class="aweb-tpv"><b></b><em></em></div></div>`);
            const dot = c.querySelector('i'); dot.style.background = u ? colOf(u) : 'var(--ou-blue)'; dot.textContent = u ? letterOf('', u) : '';
            c.querySelector('.aweb-th span').textContent = u ? (hostOf(u).replace(/^www\./, '') || nice(u)) : 'Página inicial';
            c.querySelector('.aweb-tpv b').textContent = u ? letterOf('', u) : '';
            c.querySelector('.aweb-tpv em').textContent = u ? nice(u) : NAME;
            if (!u) c.querySelector('.aweb-tpv b').innerHTML = g('globe', 30);
            c.onclick = () => { act = i; load(); sh.close(); };
            c.querySelector('.aweb-x').onclick = e => { e.stopPropagation(); if (tabs.length === 1) { tabs = [{ hist: [], pos: -1 }]; act = 0; } else { tabs.splice(i, 1); if (act >= tabs.length) act = tabs.length - 1; else if (act > i) act--; } load(); fill(); };
            gr.appendChild(c); });
          try { sh.el.querySelector('.sheet-head b').textContent = tabs.length === 1 ? '1 separador' : tabs.length + ' separadores'; } catch (e) {} };
        body.querySelector('.all').onclick = () => { tabs = [{ hist: [], pos: -1 }]; act = 0; load(); sh.close(); };
        body.querySelector('.new').onclick = () => { tabs.push({ hist: [], pos: -1 }); act = tabs.length - 1; load(); sh.close(); };
        sh = UI.sheet({ title: tabs.length === 1 ? '1 separador' : tabs.length + ' separadores', right: 'OK', cls: 'aweb-tabsh', body }); fill();
      };
      $('.tabs').onclick = tabsSheet;
      const histSheet = () => { const body = UI.el('<div class="aweb-sh"></div>'); let sh = null;
        const fill = () => { body.innerHTML = '';
          if (!hist.length) { body.appendChild(UI.el('<div class="aweb-empty">Ainda não visitaste nenhuma página nesta sessão.</div>')); return; }
          const card = UI.el('<div class="aweb-card"></div>');
          hist.forEach(h => { const r = UI.el(`<div class="aweb-row"><div class="aweb-ric"></div><div class="aweb-rb"><b></b><span></span></div><em class="aweb-when"></em></div>`); const ic = r.querySelector('.aweb-ric'); ic.style.background = colOf(h.u); ic.textContent = letterOf('', h.u); r.querySelector('b').textContent = hostOf(h.u).replace(/^www\./, '') || nice(h.u); r.querySelector('span').textContent = nice(h.u); r.querySelector('.aweb-when').textContent = UI.fmtTime(new Date(h.t)); r.onclick = () => { sh.close(); go(h.u); }; card.appendChild(r); });
          body.appendChild(card);
          const clr = UI.el('<div class="aweb-tbtn wide">Limpar histórico</div>'); clr.onclick = () => { hist.length = 0; fill(); UI.toast('Histórico limpo'); }; body.appendChild(clr);
          body.appendChild(UI.el('<div class="aweb-note">O histórico é só desta sessão: fica na memória do telemóvel e apaga-se quando a app é fechada.</div>')); };
        fill(); sh = UI.sheet({ title: 'Histórico', right: 'OK', cls: 'aweb-list', body }); };
      const settingsSheet = () => { const s = typeof CFG().search === 'string' && /^https?:\/\//i.test(CFG().search) ? hostOf(CFG().search) : 'www.bing.com'; const a = permitidos();
        const body = UI.el('<div class="aweb-sh"></div>');
        body.appendChild(UI.list([{ header: 'Pesquisa', items: [{ label: 'Motor de pesquisa', value: s.replace(/^www\./, ''), chevron: false, cls: 'static' }] },
          { header: 'Sites', items: [{ label: 'Sites permitidos', value: a ? a.length + (a.length === 1 ? ' site' : ' sites') : 'Todos', chevron: false, cls: 'static' }, { label: 'Sites do servidor', value: String(cfgSites().length), chevron: false, cls: 'static' }], footer: a ? 'Este servidor limitou o navegador a uma lista de sites (os subdomínios contam).' : 'Este servidor não limita os sites que podes abrir.' },
          { header: 'Privacidade', items: [{ label: 'Limpar histórico desta sessão', cls: 'blue', chevron: false, onTap: () => { hist.length = 0; UI.toast('Histórico limpo'); } }, { label: 'Fechar todos os separadores', cls: 'danger', chevron: false, onTap: () => { tabs = [{ hist: [], pos: -1 }]; act = 0; load(); sh.close(); } }] }]));
        const sh = UI.sheet({ title: 'Definições', right: 'OK', cls: 'aweb-list', body }); };
      const dlSheet = () => { const body = UI.el('<div class="aweb-sh"><div class="aweb-empty">Sem transferências. O navegador deste telemóvel não descarrega ficheiros: abre as páginas, mas não guarda o que elas oferecem para descarregar.</div></div>'); UI.sheet({ title: 'Transferências', right: 'OK', cls: 'aweb-list', body }); };
      const addTo = () => { const u = url(); if (!u) { UI.alert({ title: 'Adicionar página a', msg: 'Abre uma página primeiro.' }); return; }
        UI.actionSheet({ title: 'Adicionar página a', buttons: [{ label: 'Marcadores e acesso rápido', icon: 'star', value: 'bm' }, { label: 'Mensagem para um contacto', icon: 'message', value: 'msg' }] }).then(k => { if (k === 'bm') addBm(); else if (k === 'msg') share(); }); };
      /* menu em painel (o pop-out da Nova UI): cabeçalho da página, 5 atalhos e uma caixa com mais ações */
      const menuSheet = () => {
        const u = url();
        const body = UI.el(`<div class="aweb-pop">${u ? `<div class="aweb-ph"><div class="aweb-pth"></div><div class="aweb-ptx"><b></b><span></span></div><div class="aweb-pch shr">${g('share', 20)}</div></div><i class="aweb-psep"></i>` : ''}<div class="aweb-ptop"></div><div class="aweb-pbox"></div></div>`);
        if (u) { const th = body.querySelector('.aweb-pth'); th.style.background = colOf(u); th.textContent = letterOf('', u); body.querySelector('.aweb-ptx b').textContent = hostOf(u).replace(/^www\./, '') || nice(u); body.querySelector('.aweb-ptx span').textContent = nice(u); body.querySelector('.shr').onclick = () => { sh.close(); share(); }; }
        let sh = null;
        const act1 = (box, icon, label, fn, cls) => { const b = UI.el(`<div class="${cls}"><div class="aweb-pchip">${g(icon, 22)}</div><span></span></div>`); b.querySelector('span').textContent = label; b.onclick = () => { sh.close(); setTimeout(fn, 60); }; box.appendChild(b); };
        const top = body.querySelector('.aweb-ptop'), bx = body.querySelector('.aweb-pbox');
        act1(top, 'clock', 'Histórico', histSheet, 'aweb-pi'); act1(top, 'download', 'Transferências', dlSheet, 'aweb-pi'); act1(top, 'plusCircle', 'Adicionar página a', addTo, 'aweb-pi'); act1(top, 'share', 'Partilhar', share, 'aweb-pi'); act1(top, 'gear', 'Definições', settingsSheet, 'aweb-pi');
        act1(bx, 'bookmark', 'Marcadores', bookmarks, 'aweb-pg'); act1(bx, 'plus', 'Novo separador', () => { tabs.push({ hist: [], pos: -1 }); act = tabs.length - 1; load(); }, 'aweb-pg'); act1(bx, 'tabs', 'Separadores', tabsSheet, 'aweb-pg'); act1(bx, 'home', 'Página inicial', () => $('.home').onclick(), 'aweb-pg');
        act1(bx, 'update', 'Recarregar', () => $('.aweb-rl').onclick(), 'aweb-pg'); act1(bx, 'copy', 'Copiar endereço', () => { const x = url(); if (x) copyUrl(x); else UI.toast('Abre uma página primeiro'); }, 'aweb-pg'); act1(bx, 'x', 'Fechar separador', () => { if (tabs.length === 1) { tabs = [{ hist: [], pos: -1 }]; act = 0; } else { tabs.splice(act, 1); if (act >= tabs.length) act = tabs.length - 1; } load(); }, 'aweb-pg'); act1(bx, 'search', 'Pesquisar', () => inp.focus(), 'aweb-pg');
        sh = UI.sheet({ title: '', right: '', cls: 'aweb-menu', body });
      };
      $('.menu').onclick = menuSheet;
      $('.home').addEventListener('click', () => Sound.play('click'));
      paintStart(); show(); win.querySelector('.nav-stack').appendChild(root);
      win.onClose = () => { frame.removeAttribute('src'); frame.src = 'about:blank'; };
      win._go = go; win._back = back;
      return;
    }

    const v = UI.el(`<div class="web"><div class="start"></div><iframe class="web-frame hidden" sandbox="allow-scripts allow-same-origin allow-forms allow-popups"></iframe>
      <div class="urlbar-wrap"><div class="urlbar">${UI.g('lock')}<input type="text" placeholder="Pesquisar ou introduzir site"><div class="reload">${UI.g('update')}</div></div>
      <div class="web-tools"><div class="back dis">${UI.g('chevL')}</div><div class="fwd dis">${UI.g('chevR')}</div><div class="share">${UI.g('share')}</div><div class="bm">${UI.g('book')}</div><div class="tabs">${UI.g('tabs')}</div></div></div></div>`);
    const start = v.querySelector('.start'), frame = v.querySelector('.web-frame'), inp = v.querySelector('input');

    /* os marcadores (BM / bmList) estão declarados mais acima: servem os dois desenhos */
    const renderStart = () => {
      start.innerHTML = '';
      start.appendChild(UI.el('<div class="section-title">Favoritos</div>'));
      const g = UI.el('<div class="fav-grid"></div>');
      const favs = FAVS.filter(([, u]) => !barrado(u));
      favs.forEach(([n, u, c, l]) => { const f = UI.el(`<div class="fav"><div class="fi" style="background:${c}">${l || UI.g('globe', 28)}</div><span>${n}</span></div>`); f.onclick = () => go(u); g.appendChild(f); });
      start.appendChild(g);
      /* NA CIDADE: atalhos para o que é útil no roleplay - abrem as apps do telemóvel (sem rede externa) */
      const city = [['Pedir um serviço', 'Polícia, EMS, mecânico, táxi…', 'services', 'lifebuoy', '#0A84FF'], ['Pedir comida', 'Restaurantes com entrega', 'eats', 'cart', '#FF375F'], ['Comprar e vender', 'Anúncios da cidade', 'marketplace', 'tag', '#30D158'], ['Mapa da cidade', 'Locais e GPS', 'maps', 'map', '#FF9F0A'], ['Perguntar à Vera', 'Dúvidas sobre o servidor, contas, tempo', 'aichat', 'sparkles', '#8E5CFF']]
        .filter(([, , id]) => window.App && App.get(id) && (!System.installed || System.installed().includes(id)));
      if (city.length) { start.appendChild(UI.el('<div class="section-title">Na cidade</div>'));
        start.appendChild(UI.list([{ items: city.map(([label, sub, id, icon, bg]) => ({ label, sub, icon, iconBg: bg, onTap: () => System.openApp(id) })) }])); }
      /* com uma lista de sites apertada pode não sobrar nenhum favorito: em vez de uma grelha vazia sem
         explicação, diz-se porquê - e só se diz quando o limite existe mesmo (permitidos() != null) */
      if (!favs.length && permitidos()) start.appendChild(UI.el('<div class="group-footer">Nenhum dos favoritos de origem está na lista de sites permitidos deste servidor.</div>'));
      const bms = bmList();
      if (bms.length) { start.appendChild(UI.el('<div class="section-title">Marcadores</div>'));
        start.appendChild(UI.list([{ items: bms.map(([n, u]) => ({ icon: 'book', iconBg: 'var(--blue)', label: n, sub: u, chevron: false, onTap: () => go(u),
          onLong: async () => { if (await UI.confirm('Remover marcador', n, 'Remover', true)) { Agenda.edit('bookmarks', BM, l => { const i = l.findIndex(x => x && x[1] === u && x[0] === n); if (i > -1) l.splice(i, 1); }); renderStart(); } } })),
          footer: 'Toque longo num marcador para o remover. Os marcadores ficam guardados neste telemóvel.' }])); }
      /* o "No FiveM funciona normalmente" que aqui estava prometia o que não acontece: quem manda é o
         site (X-Frame-Options / CSP) e o CEF do jogo respeita-o tal como qualquer navegador - o Google
         e o YouTube, por exemplo, ficam em branco dentro do iframe, no jogo também. */
      start.appendChild(UI.el('<div class="group-footer" style="margin-top:20px">Alguns sites recusam abrir dentro de outra página e ficam em branco, no jogo também. Nesses, não há nada a fazer deste lado.</div>'));
    };
    /* PearPhone Fold: retroceder e avançar numa pílula por baixo do estado; partilhar, marcador e separadores em baixo, na barra
       direita (tocam nos botões de baixo, que ficam escondidos: apps.css); o campo do endereço fica no conteúdo. Só se refaz
       quando muda o que se vê (posição no histórico, número de separadores) */
    const railW = () => { if (!UI.railFor) return; const t = T(), sig = [t.pos, t.hist.length, tabs.length].join('|'); if (railW.sig === sig) return; railW.sig = sig;
      const tap = s => () => { const b = v.querySelector('.web-tools ' + s); if (b) b.click(); };
      UI.railFor(win, { groups: [[{ id: 'bk', icon: 'chevL', label: 'Retroceder', disabled: t.pos < 0, onTap: tap('.back') }, { id: 'fw', icon: 'chevR', label: 'Avançar', disabled: t.pos >= t.hist.length - 1, onTap: tap('.fwd') }]],
        primary: [[{ id: 'sh', icon: 'share', label: 'Partilhar', onTap: tap('.share') }, { id: 'bm', icon: 'book', label: 'Adicionar marcador', onTap: tap('.bm') }, { id: 'tb', icon: 'tabs', label: 'Separadores', badge: tabs.length > 1 ? tabs.length : null, onTap: tap('.tabs') }]] }, false); };
    /* pinta a barra e decide quem está no ecrã (página inicial ou iframe) */
    const show = () => { const u = url(); start.classList.toggle('hidden', !!u); frame.classList.toggle('hidden', !u); inp.value = u ? u.replace(/^https?:\/\//, '').replace(/\/$/, '') : '';
      const t = T(); v.querySelector('.back').classList.toggle('dis', t.pos < 0); v.querySelector('.fwd').classList.toggle('dis', t.pos >= t.hist.length - 1); railW(); };
    /* carrega o que o separador à frente tem (ou descarrega, se estiver na página inicial) */
    const load = () => { const u = url();
      if (u) { frame.dataset.last = u; if (frame.getAttribute('src') !== u) frame.src = u; }
      else { frame.removeAttribute('src'); frame.src = 'about:blank'; delete frame.dataset.last; }
      show(); };
    const go = u => {
      if (desligado()) { UI.alert({ title: 'Navegador desligado', msg: 'O dono do servidor desligou o Surf neste telemóvel.' }); return; }
      if (barrado(u)) { UI.alert({ title: 'Site não permitido', msg: 'Este servidor limitou o navegador a uma lista de sites.' }); return; }
      const t = T(); t.hist = t.hist.slice(0, t.pos + 1); t.hist.push(u); t.pos = t.hist.length - 1; load();
    };
    inp.onkeydown = e => { if (e.key !== 'Enter') return; let q = inp.value.trim(); if (!q) return; if (/^[\w.-]+\.[a-z]{2,}(\/.*)?$/i.test(q)) q = 'https://' + q; if (!/^https?:\/\//i.test(q)) q = searchUrl(q); go(q); inp.blur(); };
    v.querySelector('.reload').onclick = () => { const u = url(); if (u) { frame.removeAttribute('src'); frame.src = u; } };
    v.querySelector('.back').onclick = () => { const t = T(); if (t.pos >= 0) { t.pos--; load(); } };
    v.querySelector('.fwd').onclick = () => { const t = T(); if (t.pos < t.hist.length - 1) { t.pos++; load(); } };

    /* ---- partilhar: mostra o endereço e TENTA copiar, sem mentir sobre o resultado ----
       O botão dizia "Ligação copiada" e não copiava nada. Agora pede a cópia ao CEF e diz o que
       aconteceu; se não der, o endereço fica selecionado para o jogador copiar com Ctrl+C. */
    const addBm = async () => {
      const u = url(); if (!u) { UI.alert({ title: 'Marcadores', msg: 'Abra uma página para a adicionar.' }); return; }
      const n = await UI.prompt('Adicionar marcador', u, 'Nome'); if (!n) return;
      Agenda.edit('bookmarks', BM, l => l.push([n, u])); renderStart();
      UI.banner({ app: 'safari', title: 'Marcador adicionado', msg: n });
    };
    v.querySelector('.share').onclick = () => {
      const u = url(); if (!u) { UI.alert({ title: 'Partilhar', msg: 'Abra uma página primeiro.' }); return; }
      const body = UI.el('<div></div>');
      body.appendChild(UI.el('<div class="group-header">Endereço</div>'));
      const box = UI.el(`<div class="group"><div class="li static"><input type="text" class="sf-u" readonly value="${UI.esc(u)}" style="flex:1;border:none;background:none;font:inherit;color:var(--label);outline:none"></div></div>`);
      body.appendChild(box);
      const field = box.querySelector('.sf-u');
      body.appendChild(UI.list([{ items: [
        { label: 'Copiar endereço', cls: 'blue', chevron: false, onTap: () => {
          /* o telemóvel TEM área de transferência PRÓPRIA (Msgs.copy): essa funciona sempre dentro do
             CEF e é a que o teclado do telemóvel cola. A do sistema é só uma tentativa - por isso o
             endereço fica sempre selecionado e o texto só promete o que de facto acontece. */
          try { field.focus(); field.setSelectionRange(0, field.value.length); } catch (e) {}
          if (window.Msgs && typeof Msgs.copy === 'function') { Msgs.copy(u, true); UI.toast('Endereço copiado no telemóvel'); return; }
          let ok = false;
          try { ok = !!(document.execCommand && document.execCommand('copy')); } catch (e) { ok = false; }
          UI.toast(ok ? 'Endereço copiado' : 'Não deu para copiar: usa Ctrl+C');
        } },
        { label: 'Adicionar aos marcadores', chevron: false, onTap: () => { sh.close(); addBm(); } }
      ], footer: 'Fica na área de transferência do telemóvel: dá para colar nas Mensagens. Para o levar para fora do jogo, o endereço fica selecionado: Ctrl+C.' }]));
      const sh = UI.sheet({ title: 'Partilhar', right: 'Fechar', body });
    };
    v.querySelector('.bm').onclick = () => addBm();

    /* ---- folha dos separadores ---- */
    v.querySelector('.tabs').onclick = () => {
      const holder = UI.el('<div></div>');
      let sh = null;
      const titulo = () => { try { sh.el.querySelector('.sheet-head b').textContent = `${tabs.length} separador${tabs.length > 1 ? 'es' : ''}`; } catch (e) {} };
      const fill = () => {
        holder.innerHTML = '';
        holder.appendChild(UI.list([{ items: tabs.map((t, i) => {
          const u = t.pos >= 0 ? t.hist[t.pos] : null;
          const it = { icon: u ? 'globe' : 'tabs', iconBg: i === act ? 'var(--blue)' : 'var(--gray)',
            label: u ? (hostOf(u) || u) : 'Página inicial', sub: i === act ? 'À frente' : (u || 'Sem página aberta'), chevron: false,
            onTap: () => { act = i; load(); sh.close(); } };
          if (tabs.length > 1) { const x = UI.el(`<div class="nostop" style="padding:6px;color:var(--label3)">${UI.g('x', 12)}</div>`);
            x.onclick = ev => { ev.stopPropagation(); tabs.splice(i, 1); if (act >= tabs.length) act = tabs.length - 1; else if (act > i) act--; load(); fill(); titulo(); };
            it.right = x; }
          return it;
        }) }]));
        holder.appendChild(UI.list([{ items: [
          { label: 'Novo separador', cls: 'blue', chevron: false, onTap: () => { tabs.push({ hist: [], pos: -1 }); act = tabs.length - 1; load(); sh.close(); } },
          { label: 'Fechar todos', cls: 'danger', chevron: false, onTap: () => { tabs = [{ hist: [], pos: -1 }]; act = 0; load(); sh.close(); } }
        ], footer: 'Cada separador guarda o seu histórico, mas só o que está à frente é que corre: ao voltar a um separador a página recarrega. É isso que evita ter páginas a consumir som, vídeo e rede dentro do jogo.' }]));
      };
      fill();
      sh = UI.sheet({ title: `${tabs.length} separador${tabs.length > 1 ? 'es' : ''}`, right: 'OK', body: holder });
    };

    renderStart(); show(); win.querySelector('.nav-stack').appendChild(v);
    /* e no fecho definitivo: a janela é removida, mas um iframe a descarregar vídeo pode
       sobreviver ao nó pai tempo suficiente para se notar - corta-se a ligação aqui. */
    win.onClose = () => { frame.removeAttribute('src'); frame.src = 'about:blank'; };
    win._go = go;   /* deep link (abaixo) */
  }
});
/* phone://safari/open?url=https://… - o site de um perfil do Instashot, links de outros resources (Push('openURL')) */
if (window.System && typeof System.route === 'function') System.route('safari', d => { const w = System.windows && System.windows.safari; let u = d && d.query && d.query.url; if (!w || !w._go || !u) return; if (!/^https?:\/\//i.test(u)) u = 'https://' + u; w._go(u); });
