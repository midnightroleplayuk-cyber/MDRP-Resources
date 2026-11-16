/* ============================================================
   HOME - páginas, dock, pastas, widgets, modo de edição com
   drag & drop, long press (menu de contexto), App Library/Spotlight
   ============================================================ */
window.Home = (() => {
  const g = UI.g, COLS = 4, ROWS = 6, PW = 440;
  const DEFAULT_ORDER = ['facetime','calendar','photos','camera','mail','clock','maps','weather','reminders','notes','wallet','billing','garage','marketplace','services','home','instashot','twix','match','darkchat','appstore','calculator','contacts','settings'];
  const DOCK = ['phone','safari','messages','music'];
  let el, pagesEl, dotsEl, dockEl, editBar, folderOv, spot, fsEl = null, layout = null, page = 0, edit = false, ps = null, edgeT = null, folderT = null, openFolderId = null;
  const badges = {};
  /* retângulo do ecrã em cache (250 ms): ler getBoundingClientRect em cada pointermove forçava um layout por frame durante os arrastos (perf CEF) */
  let rc = null, rcT = -1e9; const scr = () => { const now = performance.now(); if (!rc || now - rcT > 250) { rc = UI.screen().getBoundingClientRect(); rcT = now; } return rc; };
  const SWp = () => (window.System && System.SW) || PW;
  const isA = () => !!(window.System && System.os === 'android');
  const isFold = () => !!(window.System && System.form === 'fold');
  const railOn = () => !!(window.Rail && Rail.active);
  /* NOVA UI (Android): a MESMA grelha 4×6 e a MESMA disposição gravada na conta (um jogador que troque de aparelho encontra as
     apps onde as deixou). So muda onde a grelha comeca (barra de estado de 48 px), a dock (por cima da barra de navegacao) e o
     modo de edicao, em que as paginas encolhem (escala estatica A_EDIT_S, descida A_EDIT_DY). Estes numeros TEM de bater com o
     oneui-home.css: a grelha comeca em A_TOP e a zona da dock em A_DOCK_Y. */
  const A_TOP = 80, A_DOCK_Y = 788, A_EDIT_S = .8, A_EDIT_DY = 34, A_PULL_MIN = 48;
  /* ---------- GEOMETRIA (uma fonte só) ----------
     A disposição é SEMPRE 4 × 6 células por página (a da conta, igual em todos os aparelhos). Muda onde e com que tamanho se
     desenha: telemóvel (440, uma página, os números de sempre), dobrável FECHADO (uma página na zona de conteúdo) e ABERTO (DUAS
     páginas lado a lado: a atual à esquerda e a seguinte à direita, cada uma com metade da zona de conteúdo). No PearOS a zona de
     conteúdo acaba na barra direita (--rail-w); no NOVA é o ecrã todo. O JS posiciona os ícones com G e escreve as mesmas medidas
     no #home (--icon, --gap-x, --row-step, --grid-w, --page-w, --hm-*), por isso o CSS nunca tem números seus para a grelha.
     per = páginas à vista; pw = largura de uma página; cwid = largura da zona de conteúdo; cw = célula (ícone); gx = intervalo. */
  const BAR = { per: 1, pw: PW, x0: 33, cw: 70, gx: 31.33, sy: 109.75 };
  let G = null, gOn = null;   /* gOn = a geometria que está escrita no #home */
  function geoNow() {
    const fold = isFold(), a = isA(), open = fold && !!System.foldOpen;
    if (!fold) return Object.assign({ key: a ? 'bar-a' : 'bar-i', fold: false, top: a ? A_TOP : 68 + 30, sw: PW, cwid: PW, rw: 0 }, BAR);
    const sw = SWp();
    /* NOVA: as 4 colunas do telemóvel espalhadas pelos 670 do ecrã de fora; aberto, cada metade dos 1340 é um ecrã de fora */
    if (a) { const cw = 76, gx = 76, pw = 670; return { key: open ? 'ao' : 'ac', fold: true, per: open ? 2 : 1, pw, sw, cwid: sw, rw: 0, cw, gx, x0: (pw - (3 * (cw + gx) + cw)) / 2, sy: 108, top: 78, dgap: open ? 26 : gx }; }
    const rw = railOn() ? (Rail.width || (open ? 108 : 96)) : 0, cwid = sw - rw, pw = open ? cwid / 2 : cwid, cw = 84, gx = 39;
    return { key: (open ? 'io' : 'ic') + rw, fold: true, per: open ? 2 : 1, pw, sw, cwid, rw, cw, gx, x0: (pw - (3 * (cw + gx) + cw)) / 2, sy: 136, top: 72 };
  }
  const geo = () => G || (G = geoNow());
  const cellX = c => { const q = geo(); return q.x0 + c * (q.cw + q.gx); }, cellY = r => r * geo().sy;
  const STEP = () => geo().per;
  const kz = () => scr().width / SWp();   /* px do rato → px do ecrã */
  /* primeira página do ÚLTIMO ecrã: aberto (duas à vista) é a penúltima, para a metade direita nunca ficar vazia sem precisar */
  const lastStart = () => Math.max(0, layout.pages.length - STEP());
  const dockX = () => isFold() ? (SWp() - 403) / 2 : 18.5;   /* = --dock-x (tokens.css): só conta sem a barra direita */
  const toPhone = e => { const s = scr(); const k = s.width / SWp(); return { x: (e.clientX - s.left) / k, y: (e.clientY - s.top) / k }; };
  const pagesTop = () => geo().top;
  /* edicao Nova UI: as paginas estao encolhidas (a volta do centro de cada pagina), por isso o ponto do ecra passa para
     coordenadas da pagina antes de escolher a celula */
  const zoomed = () => edit && isA();
  const toLocal = (x, y) => { const q = geo(), m = q.pw / 2; return zoomed() ? { lx: m + (x - m) / A_EDIT_S, ly: (y - q.top - A_EDIT_DY) / A_EDIT_S } : { lx: x, ly: y - q.top }; };
  const slotXY = (r, c) => { const q = geo(), m = q.pw / 2; return zoomed() ? { x: m + (cellX(c) - m) * A_EDIT_S, y: q.top + A_EDIT_DY + cellY(r) * A_EDIT_S } : { x: cellX(c), y: q.top + cellY(r) }; };
  /* as medidas no #home (só nos dobráveis; no telemóvel ficam as do tokens.css, sem nada inline). Devolve true se mudaram */
  const GV = ['--icon', '--gap-x', '--row-step', '--grid-w', '--page-w', '--hm-top', '--hm-x0', '--hm-cwid', '--hm-sw', '--hm-dots-y', '--hm-dgap'];
  function applyGeo() {
    G = geoNow(); if (!el || G.key === gOn) return false; gOn = G.key;
    el.classList.toggle('hm-fold', G.fold); el.classList.toggle('hm-two', G.per === 2);
    if (!G.fold) { GV.forEach(k => el.style.removeProperty(k)); return true; }
    const sx = G.cw + G.gx, v = { '--icon': G.cw, '--gap-x': G.gx, '--row-step': G.sy, '--grid-w': 3 * sx + G.cw, '--page-w': G.pw, '--hm-top': G.top, '--hm-x0': G.x0, '--hm-cwid': G.cwid, '--hm-sw': G.sw,
      '--hm-dots-y': G.top + 5 * G.sy + G.cw + 34, '--hm-dgap': G.dgap || G.gx };
    Object.keys(v).forEach(k => el.style.setProperty(k, (+v[k].toFixed(2)) + 'px'));
    return true;
  }
  /* páginas à vista (o tileOf do system.js usa isto para o zoom das apps nascer do ícone certo) */
  const viewPages = () => geo().per === 2 ? [page, page + 1] : [page];
  /* a dock da barra direita mudou de tamanho (fica centrada): o vidro dela volta a medir onde está o fundo (Rail.refresh) */
  const railGlass = () => { if (railOn() && Rail.refresh) { try { Rail.refresh(); } catch (e) {} } };
  /* Um id de app REGISTADA POR OUTRO RESOURCE entra nestes atributos e nos seletores logo abaixo.
     Com aspas ou "]" partia o HTML do ícone e fazia o querySelectorAll atirar SyntaxError (a passagem
     dos emblemas abortava a meio). O thirdparty.js já recusa ids fora de /^[\w.:-]{1,64}$/, mas o
     escape fica: é o mesmo critério do notify.js:351 e do `data-wid` da linha ao lado. */
  const cssEsc = v => (window.CSS && CSS.escape) ? CSS.escape(String(v)) : String(v).replace(/[^\w-]/g, '\\$&');

  /* ---------- layout ---------- */
  const emptyPage = () => Array(COLS * ROWS).fill(null);
  /* Primeira disposicao de uma conta criada no telemovel NOVA: dock Telefone, Mensagens, Internet e Camara; 1.a pagina com o
     widget "Tempo e relogio" no topo e as apps do sistema em baixo, junto a dock (o arranjo de origem da Nova UI), com a pasta
     NOVA das ferramentas; o resto segue nas paginas seguintes. `seeded` ja vai a true: os widgets do PearOS nao entram. */
  const A_DOCK = ['phone', 'messages', 'safari', 'camera'];
  const A_ROW4 = ['calendar', 'mail', 'maps', 'weather'], A_ROW5 = ['photos', 'appstore', 'settings'];
  const A_FOLDER = ['clock', 'calculator', 'notes', 'reminders', 'contacts', 'findmy', 'voicememos'];   /* MEDIA (ronda 2): o Gravador de voz vive na pasta do fabricante, como no telemóvel real */
  const A_ORDER = ['music', 'wallet', 'facetime', 'aichat', 'home', 'garage', 'services', 'billing', 'marketplace', 'instashot', 'twix', 'match', 'darkchat'];
  function defaultLayoutAndroid() {
    const hid = System.state.hiddenApps || [];
    const inst = System.installed().filter(id => !(App.get(id) || {}).hidden && !hid.includes(id)); const used = new Set();
    const take = l => l.filter(id => inst.includes(id) && !used.has(id) && (used.add(id), true));
    const dock = take(A_DOCK); const p0 = emptyPage(); const widgets = {}, folders = {};
    seedDefaultWidgets(widgets, p0, true);
    take(A_ROW4).forEach((id, i) => { p0[16 + i] = { t: 'app', id }; });
    const row5 = take(A_ROW5); row5.forEach((id, i) => { p0[20 + i] = { t: 'app', id }; });
    const fApps = take(A_FOLDER);
    if (fApps.length > 1) { folders.fnova = { name: 'NOVA', apps: fApps }; p0[20 + row5.length] = { t: 'folder', id: 'fnova' }; }
    else fApps.forEach(id => used.delete(id));   /* uma pasta com uma app so nao e pasta: a app vai para as paginas seguintes */
    const rest = take(A_ORDER).concat(inst.filter(id => !used.has(id)));
    const pages = [p0]; rest.forEach((id, i) => { const p = 1 + Math.floor(i / 24); (pages[p] = pages[p] || emptyPage())[i % 24] = { t: 'app', id }; });
    return { pages, dock, folders, widgets, seeded: true, wx2: true, wx3: true, packed: true, vmm: true };
  }
  /* widgets de origem NOS DOIS aparelhos (pedido do dono, 2026-10-01): Meteorologia e depois Calendário, no topo da 1.ª
     página. PearOS: os dois 2×2 lado a lado (células 0-7). Nova UI (`wide`): os dois LARGOS 4×2, o tempo em cima (0-7, o
     widget de previsão do S26) e o calendário por baixo (8-15). As células usadas têm de estar livres. */
  const rows23Free = pg => [8, 9, 10, 11, 12, 13, 14, 15].every(i => !pg[i]);
  function seedDefaultWidgets(widgets, pg, wide) {
    if (wide) {
      widgets.wwx = { type: 'weather', size: '4x2' }; widgets.wcal = { type: 'calendar', size: '4x2' };
      pg[0] = { t: 'widget', id: 'wwx' }; [1, 2, 3, 4, 5, 6, 7].forEach(i => { pg[i] = { t: 'cover', of: 'wwx' }; });
      pg[8] = { t: 'widget', id: 'wcal' }; [9, 10, 11, 12, 13, 14, 15].forEach(i => { pg[i] = { t: 'cover', of: 'wcal' }; });
      return;
    }
    widgets.wwx = { type: 'weather', size: '2x2' }; widgets.wcal = { type: 'calendar', size: '2x2' };
    pg[0] = { t: 'widget', id: 'wwx' }; [1, 4, 5].forEach(i => { pg[i] = { t: 'cover', of: 'wwx' }; });
    pg[2] = { t: 'widget', id: 'wcal' }; [3, 6, 7].forEach(i => { pg[i] = { t: 'cover', of: 'wcal' }; });
  }
  /* uma vez por conta, NO NOVA (wx3): o par de origem 2×2 ainda intacto (tempo em 0, calendário em 2) e as linhas 3 e 4
     vazias passa aos dois widgets largos da Nova UI. Mexido pelo jogador, ou com apps por baixo, fica como está. */
  function widenDefaultWidgets() {
    const W = layout.widgets, p0 = layout.pages[0]; if (!p0) return false;
    const at = (i, id) => p0[i] && p0[i].t === 'widget' && p0[i].id === id;
    const pair = Object.keys(W).sort().join(',') === 'wcal,wwx' && W.wwx.type === 'weather' && W.wwx.size === '2x2' && W.wcal.type === 'calendar' && W.wcal.size === '2x2' && at(0, 'wwx') && at(2, 'wcal');
    if (!pair || !rows23Free(p0)) return false;
    for (let i = 0; i < 8; i++) p0[i] = null;
    seedDefaultWidgets(W, p0, true); return true;
  }
  /* uma vez por conta (wx2): quem ainda tem os widgets de origem ANTIGOS tal e qual (Notas + Calendário do PearOS, ou o
     "Tempo e relógio" da Nova UI) passa para os novos. Se o jogador já mexeu neles (outros widgets, outro sítio, outro
     tamanho), fica tudo como está. */
  function migrateDefaultWidgets() {
    const W = layout.widgets, ids = Object.keys(W).sort().join(','), p0 = layout.pages[0]; if (!p0) return false;
    const at = (i, id) => p0[i] && p0[i].t === 'widget' && p0[i].id === id;
    const oldIOS = ids === 'wcal,wnotes' && W.wnotes.type === 'notes' && W.wnotes.size === '2x2' && W.wcal.type === 'calendar' && W.wcal.size === '2x2' && at(0, 'wnotes') && at(2, 'wcal');
    const oldA = ids === 'wclk' && W.wclk.type === 'clockwx' && W.wclk.size === '4x2' && at(0, 'wclk');
    if (!oldIOS && !oldA) return false;
    for (let i = 0; i < 8; i++) p0[i] = null;
    Object.keys(W).forEach(k => delete W[k]); seedDefaultWidgets(W, p0, isA() && rows23Free(p0)); return true;
  }
  function defaultLayoutIOS() {
    const inst = System.installed(); const dock = DOCK.filter(id => inst.includes(id));
    const order = DEFAULT_ORDER.filter(id => inst.includes(id) && !dock.includes(id)).concat(inst.filter(id => !DEFAULT_ORDER.includes(id) && !dock.includes(id) && !(App.get(id) || {}).hidden));
    const pages = []; order.forEach((id, i) => { const p = Math.floor(i / 24); (pages[p] = pages[p] || emptyPage())[i % 24] = { t: 'app', id }; });
    if (!pages.length) pages.push(emptyPage());
    return { pages, dock, folders: {}, widgets: {}, packed: true, vmm: true };
  }
  /* 1.5.0: a disposição de origem leva a marca do sistema para que foi feita (defaultOS). O sistema definitivo vem do `ready` do Lua
     (System.setOS); se a conta carregar antes dele, a disposição nasce para o sistema que estava e o osSync() troca-a quando o
     'os:changed' chegar, desde que o jogador não lhe tenha mexido (touched). Antes disto um jogador NOVA podia ficar para sempre
     com a disposição do PearOS gravada na conta (corrida de arranque vista no harness). */
  const osNow = () => (isA() ? 'android' : 'ios');
  function defaultLayoutFor(o) { const L = o === 'android' ? defaultLayoutAndroid() : defaultLayoutIOS(); L.defaultOS = o === 'android' ? 'android' : 'ios'; L.touched = false; return L; }
  function defaultLayout() { return defaultLayoutFor(osNow()); }
  /* assinatura da ORDEM (dock, apps pela ordem das páginas, apps de cada pasta): as migrações dos widgets (seed, 4×2, arrumar) não
     mudam a ordem das apps, por isso uma disposição de origem nunca tocada tem a assinatura da que se construiria hoje de raiz */
  function orderSig(L) { const apps = []; L.pages.forEach(p => p.forEach(c => { if (c && c.t === 'app') apps.push(c.id); else if (c && c.t === 'folder') apps.push('[' + c.id + ']'); }));
    const f = Object.keys(L.folders || {}).sort().map(k => k + ':' + ((L.folders[k] || {}).apps || []).join(','));
    return JSON.stringify([L.dock || [], apps, f]); }
  /* a disposição guardada é a de origem do OUTRO sistema, nunca tocada? Marca explícita (defaultOS + touched, contas de 1.5.0) ou, nas
     contas antigas sem marca, a ordem e a dock exatamente iguais à de origem do outro sistema (quem mexeu mudou pelo menos uma) */
  function isForeignDefault(L, o) {
    if (!L || L.touched) return false; const other = o === 'android' ? 'ios' : 'android';
    if (L.defaultOS) return L.defaultOS === other;
    try { return orderSig(L) === orderSig(defaultLayoutFor(other)); } catch (e) { return false; }
  }
  /* troca para a disposição de origem do sistema atual (mantém a Vista Hoje, que não é de nenhum sistema), repete as conversões e grava */
  function osSync() {
    if (!layout) return false; const o = osNow(); if (layout.defaultOS === o || !isForeignDefault(layout, o)) return false;
    const keep = { today: layout.today, tdv: layout.tdv, tdv2: layout.tdv2 };
    layout = Object.assign(defaultLayoutFor(o), keep); prep(); reconcile(); page = 0;
    setTimeout(saveSys, 0); Bridge.dbg('home', 'disposição de origem refeita para', o); return true;
  }
  /* O Lua não guarda "buracos" (null) em arrays: uma página com células vazias no meio volta da base de dados como OBJETO {"1":…,"5":…} (índices 1-based)
     ou, quando guardada por nós, com 0 nas células vazias. Sem isto `p.forEach` rebentava no arranque e a home ficava vazia (sem relógio, sem ícones). */
  const isCell = c => !!c && typeof c === 'object' && typeof c.t === 'string';
  function normPage(p) { const out = emptyPage(); if (Array.isArray(p)) p.forEach((c, i) => { if (i < COLS * ROWS && isCell(c)) out[i] = c; });
    else if (p && typeof p === 'object') { const keys = Object.keys(p); const base = keys.includes('0') ? 0 : 1; keys.forEach(k => { const i = +k - base; if (i >= 0 && i < COLS * ROWS && isCell(p[k])) out[i] = p[k]; }); }
    return out; }
  const asArray = v => Array.isArray(v) ? v : (v && typeof v === 'object') ? Object.keys(v).sort((a, b) => +a - +b).map(k => v[k]) : [];
  const asObject = v => (v && typeof v === 'object' && !Array.isArray(v)) ? v : {};
  function normalize(saved) {
    const pages = asArray(saved.pages).map(normPage); const folders = asObject(saved.folders), widgets = asObject(saved.widgets);
    Object.keys(folders).forEach(k => { const f = folders[k]; if (!f || typeof f !== 'object') { delete folders[k]; return; } f.apps = asArray(f.apps).filter(x => typeof x === 'string'); f.name = String(f.name || 'Pasta'); });
    return { pages: pages.length ? pages : [emptyPage()], dock: asArray(saved.dock).filter(x => typeof x === 'string'), folders, widgets, seeded: !!saved.seeded, wx2: !!saved.wx2, wx3: !!saved.wx3, packed: !!saved.packed,
      today: normToday(saved.today), tdv: !!saved.tdv, tdv2: !!saved.tdv2, vmm: !!saved.vmm,
      defaultOS: saved.defaultOS === 'android' || saved.defaultOS === 'ios' ? saved.defaultOS : null, touched: !!saved.touched };
  }
  /* VISTA HOJE: a lista de widgets da página à esquerda da 1.a ({ id, type, size, name?, app? }, pela ordem). Vem do Lua como
     array ou como objeto 1-based (asArray); ids repetidos ou em falta são refeitos; no máximo 24. `tdv` = a lista já foi
     criada nesta conta (uma lista vazia gravada continua vazia; sem a marca entram os widgets de origem) */
  const TDV_MAX = 24;
  const TDV_DEF = [['weather', '2x2'], ['crypto', '2x2'], ['calmonth', '2x2'], ['maps', '2x2'], ['notes', '2x2'], ['photos', '2x2'], ['music', '2x2'], ['battery', '2x2']];
  const tdvDefaults = () => TDV_DEF.map(([type, size], i) => ({ id: 't' + (i + 1), type, size }));
  /* (uma vez, tdv2) a primeira versão tinha 6 widgets de origem: quem ainda os tem tal e qual recebe a Música e a Bateria no fim */
  function tdvMore() {
    const L0 = layout.today, six = TDV_DEF.slice(0, 6); if (!Array.isArray(L0) || L0.length !== 6) return;
    if (!L0.every((x, i) => x.id === 't' + (i + 1) && x.type === six[i][0] && x.size === six[i][1])) return;
    tdvDefaults().slice(6).forEach(x => L0.push(x));
  }
  function normToday(v) {
    const seen = new Set(); let n = 0;
    return asArray(v).filter(x => x && typeof x === 'object' && typeof x.type === 'string' && x.type).slice(0, TDV_MAX).map(x => {
      let id = typeof x.id === 'string' && /^[\w-]{1,40}$/.test(x.id) ? x.id : ''; while (!id || seen.has(id)) id = 'tn' + (++n); seen.add(id);
      const o = { id, type: String(x.type).slice(0, 64), size: WSIZE[x.size] ? x.size : '2x2' };
      if (typeof x.name === 'string' && x.name) o.name = x.name.slice(0, 40); if (typeof x.app === 'string' && x.app) o.app = x.app.slice(0, 64); return o; });
  }
  /* widgets iniciais: Meteorologia e Calendário 2×2 no topo da 1.ª página, nos dois aparelhos - uma só vez por conta (seeded);
     em edição removem-se com o "−". Entram no topo e os ícones seguem pela ordem deles: o que deixar de caber passa para o
     INÍCIO da página seguinte (antes ia para o fim das páginas, fora de ordem) */
  function seedWidgets() {
    layout.seeded = true; layout.wx2 = true; if (isA()) layout.wx3 = true; if (Object.keys(layout.widgets).length) return;
    const top = emptyPage(); seedDefaultWidgets(layout.widgets, top, isA());
    const s = seqOf(layout.pages[0]); s.W = seqOf(top).W.concat(s.W); commitSeq(0, s);
  }
  /* (uma vez, ao arrumar uma disposição antiga) a 1.ª página da disposição de origem da Nova UI tinha as apps do sistema EM
     BAIXO, junto à dock, com um vazio por cima; o que caiu nesse vazio depois (uma app instalada, como o Instashot) passa
     para DEPOIS delas, como se já tivesse sido instalada com a gravidade. Só com essa assinatura: célula 15 vazia e, da 16
     em diante, as apps do sistema da Nova UI (e a pasta NOVA) seguidas e pela ordem de origem */
  function novaTailFirst() {
    const p0 = layout.pages[0]; if (!p0 || p0[15]) return false;
    const tail = []; let i = 16; while (i < COLS * ROWS && p0[i]) tail.push(p0[i++]);
    if (!tail.length || p0.slice(i).some(Boolean)) return false;
    const ord = A_ROW4.concat(A_ROW5); let last = -1;
    if (!tail.every(c => { const k = c.t === 'app' ? ord.indexOf(c.id) : c.t === 'folder' && c.id === 'fnova' ? ord.length : -1; if (k <= last) return false; last = k; return true; })) return false;
    const s = seqOf(p0), rest = s.I.filter(c => !tail.includes(c)); if (!rest.length) return false;
    s.I = tail.concat(rest); commitSeq(0, s); return true;
  }
  /* conversões uma vez por conta (sem desenhar): Vista Hoje, widgets de origem, widgets largos do NOVA, gravidade. Gravam por saveSys:
     não são o jogador a mexer (a marca touched fica como estava) */
  function prep() {
    /* Vista Hoje: disposições sem ela (antigas ou novas) recebem os widgets de origem, uma vez por conta */
    if (!layout.tdv || !Array.isArray(layout.today)) { layout.today = layout.tdv && Array.isArray(layout.today) ? layout.today : tdvDefaults(); layout.tdv = true; }
    if (!layout.tdv2) { layout.tdv2 = true; try { tdvMore(); } catch (e) { console.error('[apex_phone] vista hoje (tdv2)', e); } }
    if (!layout.seeded) { try { seedWidgets(); } catch (e) { console.error('[apex_phone] seedWidgets', e); layout.seeded = true; } }
    /* os itens que estavam nas células 0-7 são sempre widgets e capas: nada fica sem sítio; grava-se já para a troca não se repetir */
    if (!layout.wx2) { layout.wx2 = true; try { if (migrateDefaultWidgets()) setTimeout(saveSys, 0); } catch (e) { console.error('[apex_phone] widgets de origem', e); } }
    /* só no NOVA: a marca wx3 não se grava no PearPhone, para a conversão ainda poder acontecer no primeiro arranque num S26 */
    if (isA() && !layout.wx3) { layout.wx3 = true; try { if (widenDefaultWidgets()) setTimeout(saveSys, 0); } catch (e) { console.error('[apex_phone] widgets largos', e); } }
    /* gravidade, uma vez por conta (packed): a disposição antiga, com buracos, fica arrumada (o reconcile a seguir arruma as
       páginas) e grava-se já. Depois das conversões dos widgets de cima, que ainda contam com o vazio de origem */
    if (!layout.packed) { layout.packed = true; try { novaTailFirst(); } catch (e) { console.error('[apex_phone] arrumar a home', e); } setTimeout(saveSys, 0); }
    /* MEDIA (ronda 2): o Gravador vem em TODOS os telemóveis (core). Uma vez por conta (vmm) ganha lugar sem desarrumar nada: no
       NOVA entra na pasta do fabricante se ela existir; senão o reconcile a seguir põe-no depois do último ícone da primeira página
       com espaço. Escondido pelo jogador fica escondido. Grava-se já (saveSys: não conta como o jogador a mexer). */
    if (!layout.vmm) { layout.vmm = true; try { const f = layout.folders && layout.folders.fnova;
      if (isA() && f && Array.isArray(f.apps) && !(System.state.hiddenApps || []).includes('voicememos') && System.installed().includes('voicememos') && !findApp('voicememos')) f.apps.push('voicememos'); } catch (e) { console.error('[apex_phone] gravador (vmm)', e); }
      setTimeout(saveSys, 0); }
  }
  function load(saved) {
    layout = null;
    try { if (saved && saved.pages && asArray(saved.pages).length) layout = normalize(saved); } catch (e) { console.error('[apex_phone] disposição guardada inválida - a usar a predefinida', e); layout = null; }
    if (!layout) layout = defaultLayout();
    prep();
    /* a disposição guardada é a de origem do outro sistema e nunca foi tocada (o sistema já está certo aqui): refaz-se já para este */
    try { osSync(); } catch (e) { console.error('[apex_phone] osSync', e); }
    reconcile(); page = Math.max(0, Math.min(page, layout.pages.length - 1)); render();
  }
  /* cópia para guardar: células vazias como 0 (não null) para sobreviverem à ida e volta pelo Lua */
  function serialize() { if (!layout) return null; return { pages: layout.pages.map(p => p.map(c => c || 0)), dock: layout.dock.slice(), folders: layout.folders, widgets: layout.widgets, seeded: !!layout.seeded, wx2: !!layout.wx2, wx3: !!layout.wx3, packed: !!layout.packed,
    today: (layout.today || []).map(x => Object.assign({}, x)), tdv: !!layout.tdv, tdv2: !!layout.tdv2, vmm: !!layout.vmm,
    defaultOS: layout.defaultOS || '', touched: !!layout.touched }; }   /* '' e não null: o Lua perde os null */
  function reconcile() {
    const inst = System.installed(); const placed = new Set();
    layout.pages.forEach(p => p.forEach((c, i) => { if (!c) return;
      if (c.t === 'app') { if (!inst.includes(c.id)) p[i] = null; else placed.add(c.id); }
      else if (c.t === 'folder') { const f = layout.folders[c.id]; if (!f) { p[i] = null; return; } f.apps = f.apps.filter(id => inst.includes(id)); f.apps.forEach(id => placed.add(id)); if (!f.apps.length) { p[i] = null; delete layout.folders[c.id]; } }
      else if (c.t === 'widget') { if (!layout.widgets[c.id]) p[i] = null; }
      else if (c.t === 'cover') { if (!layout.widgets[c.of]) p[i] = null; } }));
    layout.dock = layout.dock.filter(id => inst.includes(id)); layout.dock.forEach(id => placed.add(id));
    inst.forEach(id => { if (!placed.has(id) && !(App.get(id) || {}).hidden && !(System.state.hiddenApps || []).includes(id)) place({ t: 'app', id }); });   /* em falta: no fim */
    tidy();
  }
  function fits(pg, r, c, w, h, ignore) { if (r + h > ROWS || c + w > COLS) return false; for (let dr = 0; dr < h; dr++) for (let dc = 0; dc < w; dc++) { const x = pg[(r + dr) * COLS + c + dc]; if (x && !(ignore && ((x.t === 'widget' && x.id === ignore) || (x.t === 'cover' && x.of === ignore)))) return false; } return true; }
  /* tamanhos de widget (colunas × linhas): pequeno 2×2, médio 4×2, grande 4×4; um tamanho desconhecido gravado conta como 2×2 */
  const WSIZE = { '2x2': [2, 2], '4x2': [4, 2], '4x4': [4, 4] };
  function sizeOf(cell) { if (cell && cell.t === 'widget') { const w = layout.widgets[cell.id]; return (w && WSIZE[w.size]) || [2, 2]; } return [1, 1]; }
  function put(pg, r, c, cell) { const [w, h] = sizeOf(cell); pg[r * COLS + c] = cell; if (w > 1 || h > 1) for (let dr = 0; dr < h; dr++) for (let dc = 0; dc < w; dc++) if (dr || dc) pg[(r + dr) * COLS + c + dc] = { t: 'cover', of: cell.id }; }
  /* ---------- GRAVIDADE (como no PearPhone) ----------
     Cada página é uma SEQUÊNCIA: primeiro os widgets, pela ordem deles, no topo (cada um na primeira fila onde cabe, do lado
     onde estava, esquerda ou direita); depois as apps e as pastas, pela ordem de leitura, a encher as células livres à volta
     deles. Nunca fica uma célula vazia antes do último item. O que não cabe passa para o INÍCIO da página seguinte, em cascata
     (como no PearPhone quando se larga numa página cheia). As células são os MESMOS objetos de antes (só as capas são novas):
     os nós da home continuam a reconhecer o seu item. */
  const isW = c => !!c && c.t === 'widget';
  const isBlock = c => !!c && (c.t === 'widget' || c.t === 'cover');
  /* página → { W: [{ cell, col, i }], I: [células] } pela ordem de leitura (col = coluna do widget, i = célula onde está) */
  function seqOf(pg) { const W = [], I = []; (pg || []).forEach((c, i) => { if (!c || c.t === 'cover') return; if (c.t === 'widget') W.push({ cell: c, col: i % COLS, i }); else I.push(c); }); return { W, I }; }
  /* desenha uma sequência numa página nova: { pg, oW, oI } (oW / oI = os widgets e os ícones que não couberam) */
  function flow(W, I) {
    const pg = emptyPage(), oW = [], oI = [];
    W.forEach(w => { const [ww, hh] = sizeOf(w.cell), pref = ww < COLS && w.col >= 2 ? 2 : 0; let ok = false;
      for (let r = 0; r <= ROWS - hh && !ok; r++) { const cs = []; for (let c = 0; c + ww <= COLS; c += 2) if (fits(pg, r, c, ww, hh)) cs.push(c);
        if (cs.length) { put(pg, r, cs.includes(pref) ? pref : cs[0], w.cell); ok = true; } }
      if (!ok) oW.push(w); });
    let k = 0; I.forEach(c => { while (k < pg.length && pg[k]) k++; if (k < pg.length) pg[k++] = c; else oI.push(c); });
    return { pg, oW, oI };
  }
  /* grava a sequência na página p; o que transborda entra à frente da página seguinte (widgets antes dos widgets dela, ícones
     antes dos ícones dela), e assim por diante */
  function commitSeq(p, s) {
    for (let q = p; ; q++) { while (layout.pages.length <= q) layout.pages.push(emptyPage());
      const r = flow(s.W, s.I); layout.pages[q] = r.pg; if (!r.oW.length && !r.oI.length) return;
      const nx = seqOf(layout.pages[q + 1]); s = { W: r.oW.concat(nx.W), I: r.oI.concat(nx.I) }; }
  }
  /* todas as páginas em gravidade; repetidos, pastas vazias e (fora de um arrasto) páginas vazias saem; fica sempre uma */
  function tidy() {
    if (!layout) return; const seen = new Set();
    layout.pages.forEach(pg => pg.forEach((c, i) => { if (!c || c.t === 'cover') return; const key = c.t + ':' + c.id;
      if (seen.has(key) || (c.t === 'folder' && !(layout.folders[c.id] && layout.folders[c.id].apps.length))) { pg[i] = null; if (c.t === 'folder' && !seen.has(key)) delete layout.folders[c.id]; return; }
      seen.add(key); }));
    for (let p = 0; p < layout.pages.length; p++) commitSeq(p, seqOf(layout.pages[p]));
    if (!drag) for (let p = layout.pages.length - 1; p >= 0 && layout.pages.length > 1; p--) if (layout.pages[p].every(c => !c)) { layout.pages.splice(p, 1); if (page > p) page--; }
  }
  /* item novo: uma app (ou pasta) vai para DEPOIS do último item da primeira página com lugar (a partir de `from`), senão para
     uma página nova, nunca para um vazio por cima dos outros; um widget entra como o último widget da página `from` (os ícones
     dela descem e o que deixar de caber passa à seguinte). Devolve onde ficou */
  function place(cell, from = 0) {
    from = Math.max(0, Math.min(from, layout.pages.length));
    if (isW(cell)) { const s = seqOf(layout.pages[from]); s.W.push({ cell, col: 0, i: -1 }); commitSeq(from, s); return where(cell); }
    for (let p = from; p < layout.pages.length; p++) { const s = seqOf(layout.pages[p]); s.I.push(cell); const r = flow(s.W, s.I);
      if (!r.oW.length && !r.oI.length) { layout.pages[p] = r.pg; return where(cell); } }
    const pg = emptyPage(); pg[0] = cell; layout.pages.push(pg); return where(cell);
  }
  /* insere apps / pastas na posição k da sequência de ícones da página p (k além do fim = no fim) */
  function insertAt(p, k, cells) { while (layout.pages.length <= p) layout.pages.push(emptyPage()); const s = seqOf(layout.pages[p]); s.I.splice(Math.max(0, Math.min(k, s.I.length)), 0, ...cells); commitSeq(p, s); }
  /* posição de uma app / pasta na sequência da sua página */
  function seqPos(cell) { for (let p = 0; p < layout.pages.length; p++) { const k = seqOf(layout.pages[p]).I.findIndex(c => c.t === cell.t && c.id === cell.id); if (k > -1) return { p, k }; } return null; }
  function where(cell) { for (let p = 0; p < layout.pages.length; p++) { const i = layout.pages[p].indexOf(cell); if (i > -1) return { p, r: Math.floor(i / COLS), c: i % COLS }; } return null; }
  function removeCell(cell) { layout.pages.forEach(pg => pg.forEach((x, i) => { if (!x) return; if (x.t === cell.t && x.id === cell.id) pg[i] = null; if (cell.t === 'widget' && x.t === 'cover' && x.of === cell.id) pg[i] = null; })); if (cell.t === 'app') { const i = layout.dock.indexOf(cell.id); if (i > -1) layout.dock.splice(i, 1); } }
  function findApp(id) { for (let p = 0; p < layout.pages.length; p++) { const i = layout.pages[p].findIndex(c => c && c.t === 'app' && c.id === id); if (i > -1) return { kind: 'page', page: p, idx: i }; } const d = layout.dock.indexOf(id); if (d > -1) return { kind: 'dock', idx: d }; for (const fid in layout.folders) { const i = layout.folders[fid].apps.indexOf(id); if (i > -1) return { kind: 'folder', fid, idx: i }; } return null; }
  /* save = o JOGADOR mexeu na disposição (arrastar, tirar, pastas, widgets, Vista Hoje): fica marcada como tocada e o osSync já não
     lhe toca. saveSys = gravações do sistema (conversões, instalar/desinstalar, a troca de sistema): a marca fica como estava */
  const saveSys = () => System.save();
  const save = () => { if (layout && !layout.touched) layout.touched = true; System.save(); };

  /* ---------- render ---------- */
  /* flip = true: os itens que ficaram na mesma página DESLIZAM do sítio antigo para o novo (só translate), em vez de saltarem
     (fechar o buraco de uma app removida, os ícones a descer por baixo de um widget novo...) */
  function render(flip) {
    if (!layout) return; if (!drag) tidy(); applyGeo();
    /* o sítio de partida é onde o nó ESTÁ (translate calculado): se um deslize anterior ainda ia a meio, continua dali sem saltar */
    const was = flip === true && pagesEl.children.length ? new Map() : null;
    if (was) [...pagesEl.children].forEach((pe, p) => [...pe.children].forEach(n => { if (!n._cell) return; const t = String(getComputedStyle(n).translate || '').split(' ');
      const live = /px$/.test(t[0]); was.set(n._cell, { p, x: live ? t[0] : n.style.getPropertyValue('--x'), y: live ? (t[1] || '0px') : n.style.getPropertyValue('--y') }); }));
    const safe = (fn, what) => { try { return fn(); } catch (e) { console.error('[apex_phone] home item', what, e); return null; } };   /* um item estragado nunca pode deitar abaixo a home inteira */
    pagesEl.innerHTML = ''; layout.pages.forEach((pg, p) => { const pe = UI.el('<div class="page"></div>'); pg.forEach((cell, i) => { if (!cell || cell.t === 'cover') return; const n = safe(() => itemEl(cell, Math.floor(i / COLS), i % COLS, { kind: 'page', page: p, idx: i }), cell); if (n) pe.appendChild(n); }); pagesEl.appendChild(pe); });
    page = Math.max(0, Math.min(page, lastStart())); renderDots();
    dockEl.innerHTML = ''; layout.dock.forEach((id, i) => { const n = safe(() => itemEl({ t: 'app', id }, 0, 0, { kind: 'dock', idx: i }), id); if (n) dockEl.appendChild(n); });
    railGlass();
    goPage(page, true); Object.keys(badges).forEach(id => System.badge(id, badges[id])); el.classList.toggle('edit', edit); el.classList.toggle('nolabels', System.state.showLabels === false);
    if (sel) paintSel();   /* Nova UI a selecionar: os ícones novos voltam a mostrar o visto */
    if (was && was.size && !noMotion()) { const mv = [];
      [...pagesEl.children].forEach((pe, p) => [...pe.children].forEach(n => { const o = was.get(n._cell); if (!o || o.p !== p) return; const x = n.style.getPropertyValue('--x'), y = n.style.getPropertyValue('--y'); if (o.x === x && o.y === y) return;
        n.style.transition = 'none'; n.style.setProperty('--x', o.x); n.style.setProperty('--y', o.y); mv.push([n, x, y]); }));
      if (mv.length) { void pagesEl.offsetWidth; mv.forEach(([n, x, y]) => { n.style.transition = ''; n.style.setProperty('--x', x); n.style.setProperty('--y', y); }); } }
    if (tdv) { try { tdvSync(); } catch (e) { console.error('[apex_phone] vista hoje', e); } }   /* só acerta os nós que mudaram (outro sistema, widget novo) */
  }
  /* o dobrável abriu ou fechou (outra geometria): os MESMOS nós mudam de sítio de uma vez, sem transições e sem voltar a construir
     nada (nada pisca); só os pontos se refazem se o número de ecrãs mudar */
  function relayout() {
    if (!layout || !pagesEl) return; if (!applyGeo()) return;
    el.classList.add('hm-snap');
    [...pagesEl.children].forEach(pe => [...pe.children].forEach(n => { const l = n._loc; if (l && l.kind === 'page') pos(n, cellX(l.idx % COLS), cellY(Math.floor(l.idx / COLS))); }));
    page = Math.max(0, Math.min(page, lastStart())); renderDots(); goPage(page, true);
    /* o estilo já calculado sem transições (offsetWidth); tirar a classe depois não anima nada (os valores não mudam) */
    void pagesEl.offsetWidth; clearTimeout(relayout.t); relayout.t = setTimeout(() => el.classList.remove('hm-snap'), 90);
  }
  /* pontos: um por ecrã. No telemóvel e fechado, um por página. Aberto, um por PAR: deslizar anda de duas em duas a partir do
     par à vista e encosta à primeira / à última página nas pontas, por isso contam-se os pares a que se chega daqui */
  function views() {
    const n = layout.pages.length, per = STEP(); if (per === 1) return { n, cur: page };
    const L = Math.max(0, n - per), s = Math.min(page, L), list = [];
    for (let x = s % 2; x <= L; x += 2) list.push(x);
    if (s % 2 && list[0] !== 0) list.unshift(0);
    if (list[list.length - 1] !== L) list.push(L);
    return { n: list.length, cur: Math.max(0, list.indexOf(s)) };
  }
  /* último "ponto" = Biblioteca de Apps (PearOS) */
  function renderDots() { const v = views(); dotsEl.innerHTML = Array.from({ length: v.n }, (_, i) => `<span class="${i === v.cur ? 'on' : ''}"></span>`).join('') + `<span class="lib">${g('search', 12)}</span>`; }
  function itemEl(cell, r, c, loc) {
    let it;
    /* Icons.tileBox: o ícone entra como IMAGEM (1 nó) em vez da árvore SVG (20-30 nós). O ecrã principal está SEMPRE no
       documento, por baixo de todas as apps - com 24 ícones eram ~600 nós a pesar em tudo. O Relógio continua em SVG
       (ponteiros vivos), porque o tileBox trata disso sozinho. */
    if (cell.t === 'app') { const d = App.get(cell.id) || {}; it = UI.el(`<div class="hi app ${d.core ? '' : 'removable'} core-${!!d.core}" data-id="${UI.esc(cell.id)}">${Icons.tileBox(cell.id)}<div class="rm">${g('minus')}</div><div class="app-name">${UI.esc(App.name(cell.id))}</div></div>`); if (d.core) it.classList.add('removable'); }
    else if (cell.t === 'folder') { const f = layout.folders[cell.id] || { name: 'Pasta', apps: [] }; it = UI.el(`<div class="hi folder removable" data-fid="${UI.esc(cell.id)}"><div class="tile lg lg-wp lg-tone">${f.apps.slice(0, 9).map(id => `<div class="mini">${Icons.tile(id)}</div>`).join('')}</div><div class="rm">${g('minus')}</div><div class="app-name">${UI.esc(f.name)}</div></div>`); }
    else { const w = layout.widgets[cell.id] || { type: 'clock', size: '2x2' }; const def = Widgets.get(w.type) || {}; const sz = WSIZE[w.size] ? w.size : '2x2';
      /* o registo dos widgets EXTERNOS vive em memória e só dura enquanto a app externa viver: sem ele a
         célula ficava com o nome de reserva "Widget" e a caixa "Widget indisponível". O nome e a app dona
         ficam gravados na disposição (serialize), por isso a célula continua a dizer de quem é. */
      const nm = def.name || w.name || 'Widget';
      it = UI.el(`<div class="hi widget removable w${sz}" data-wid="${UI.esc(cell.id)}">${Widgets.render(w.type, sz, { name: nm })}<div class="rm">${g('minus')}</div><div class="app-name">${UI.esc(nm)}</div></div>`);
      if (Widgets.hydrate) Widgets.hydrate(it); }   /* capas e fotos entram pelo CSSOM, depois de o nó existir */
    if (loc.kind === 'page') pos(it, cellX(c), cellY(r));
    it._cell = cell; it._loc = loc;
    it.querySelector('.rm').onclick = e => { e.stopPropagation(); removeItem(cell); };
    return it;
  }
  const paintDots = () => { const open = spotIn(), v = views(); if (dotsEl.children.length !== v.n + 1) renderDots(); [...dotsEl.children].forEach((d, i) => d.classList.toggle('on', open ? d.classList.contains('lib') : i === v.cur)); };
  /* posição dos ícones por TRANSFORM (spec 59): --x/--y → `translate` em CSS (.hi), em vez de left/top - reordenar/arrastar não faz relayout dos 29 ícones a cada frame */
  const pos = (el, x, y) => { el.style.setProperty('--x', x + 'px'); el.style.setProperty('--y', y + 'px'); };
  /* paralaxe do wallpaper (35): o fundo desloca-se 3 px por página em sentido contrário ao das páginas - profundidade subtil, só transform */
  let wpEl = null; const par = (tx, drag) => { if (!wpEl) wpEl = UI.screen().querySelector('.wallpaper:not(.wallpaper-lock)'); if (!wpEl) return; wpEl.classList.toggle('par', !drag); wpEl.style.transform = `translate3d(${(-tx / geo().pw * 3).toFixed(2)}px,0,0)`; };
  /* aberto, `page` é a página da ESQUERDA (pode ser ímpar: abrir na página k põe k à esquerda); a última posição deixa a
     penúltima à esquerda, para a metade direita ter sempre uma página quando há mais do que uma */
  function goPage(p, instant) { const pw = geo().pw; page = Math.max(0, Math.min(lastStart(), p)); if (instant) pagesEl.classList.add('drag'); pagesEl.style.transform = `translateX(${-page * pw}px)`; par(-page * pw); if (instant) requestAnimationFrame(() => pagesEl.classList.remove('drag')); paintDots(); }

  /* ---------- toques / long press / drag ---------- */
  function bindContainer(cont) {
    cont.addEventListener('pointerdown', e => {
      if (e.button && e.pointerType === 'mouse') return; if (ps) return;
      const it = e.target.closest('.hi'); if (e.target.closest('.rm')) return;
      ps = { x: e.clientX, y: e.clientY, t: Date.now(), it, cont, held: false, drag: false, swipe: false, timer: null, moved: false };
      if (it) { it.classList.add('pressed'); const rel = () => it.classList.remove('pressed'); setTimeout(rel, 600); it.addEventListener('pointerup', rel, { once: true }); }
      try { cont.setPointerCapture(e.pointerId); } catch (err) {}
      /* manter: num ícone → menu de contexto (ou arrastar em edição); no fundo vazio → modo de edição (PearOS)
         Nova UI: o menu abre AINDA com o dedo em baixo (como na One UI) e, se o dedo andar, o menu fecha e o ícone passa a ser
         arrastado SEM entrar no modo de edicao; a selecionar varias apps so ha toques */
      if (sel) { /* Nova UI, selecionar: sem toque longo */ }
      else if (it) ps.timer = setTimeout(() => { if (!ps) return; ps.held = true; Sound.play('pop'); if (edit) beginDrag(e); else if (isA()) { ps.menu = true; ctxMenu(it); } }, edit ? 120 : 450);
      else if (cont === pagesEl && !edit) ps.timer = setTimeout(() => { if (!ps || ps.moved) return; ps.held = true; enterEdit(); }, 520);
    });
    cont.addEventListener('pointermove', e => {
      if (!ps || ps.cont !== cont) return; const dx = e.clientX - ps.x, dy = e.clientY - ps.y; const dist = Math.hypot(dx, dy);
      if (ps.drag) { moveDrag(e); return; }
      if (edit && ps.it && dist > 4) { clearTimeout(ps.timer); beginDrag(e); moveDrag(e); return; }          /* em edição, mover um ícone arrasta-o logo (antes era interpretado como mudança de página) */
      if (ps.held && ps.it && dist > 6) { if (isA()) { closeAhMenu(true); beginDrag(e); moveDrag(e); return; } if (!edit) enterEdit(); beginDrag(e); moveDrag(e); return; }
      if (!ps.held && !ps.swipe && !ps.pull && !ps.adr && !ps.qp && dist > 10) { clearTimeout(ps.timer); ps.moved = true; if (cont === pagesEl && Math.abs(dx) > Math.abs(dy)) { ps.swipe = true; pagesEl.classList.add('drag'); }
        /* Nova UI: deslizar para CIMA (páginas ou dock) abre a gaveta de apps a seguir o dedo; puxar para BAIXO nas páginas abre o
           painel de notificações (QuickPanel). A faixa da barra de estado (48 px) é do SysUI. Sem Biblioteca nem pesquisa do PearOS. */
        else if (isA()) { if ((cont === pagesEl || cont === dockEl) && !edit && !sel && dy < 0 && -dy >= Math.abs(dx) && window.Drawer && Drawer.pullStart) { ps.adr = true; Drawer.pullStart(); }
          else if (cont === pagesEl && !edit && !sel && dy > 0 && toPhone({ clientX: ps.x, clientY: ps.y }).y > A_PULL_MIN) { ps.qp = true; qpStart(); } }
        /* puxar para BAIXO nas páginas → pesquisa global. Só abaixo de PULL_MIN_Y: a faixa da barra de estado é da .top-zone (NC/CC, gestures.js) */
        else if (cont === pagesEl && !edit && dy > 0 && gs && !spotIn() && toPhone({ clientX: ps.x, clientY: ps.y }).y > PULL_MIN_Y) { ps.pull = true; startPull(); } }
      if (ps.adr || ps.qp) { const k = kz(); const now = Date.now(); ps.vy = (e.clientY - (ps.ly == null ? ps.y : ps.ly)) / k / Math.max(1, now - (ps.lt || ps.t)); ps.ly = e.clientY; ps.lt = now;
        if (ps.adr) { try { Drawer.pullMove(Math.max(0, -dy / k)); } catch (err) {} } else qpMove(Math.max(0, dy / k)); return; }
      if (ps.pull) { const k = kz(); const now = Date.now(); ps.vy = (e.clientY - (ps.ly == null ? ps.y : ps.ly)) / k / Math.max(1, now - (ps.lt || ps.t)); ps.ly = e.clientY; ps.lt = now; followPull(Math.max(0, dy / k)); return; }
      if (ps.swipe) { const k = kz(); let off = dx / k; const last = lastStart();
        /* para além da última página a Biblioteca de Apps entra pela direita, como mais uma página (PearOS); no fold, como mais um ecrã inteiro */
        if (page === last && off < 0 && spot && !isA()) { if (!ps.libDrag) { ps.libDrag = true; renderLib(''); spot.classList.add('in', 'drag'); dimSync(); } spot.style.transform = `translateX(${Math.max(0, SWp() + off)}px)`; }
        else if (ps.libDrag) { ps.libDrag = false; spot.classList.remove('drag', 'in'); spot.style.transform = ''; dimSync(); }
        /* VISTA HOJE: para a direita na primeira página, a página dos widgets entra pela esquerda a seguir o dedo (como no
           PearPhone); as páginas acompanham sem resistência. Voltar para trás a meio larga-a */
        if (page === 0 && off > 0 && cont === pagesEl && tdvOk()) { if (!ps.tdvDrag) { ps.tdvDrag = true; tdvDragStart(); } tdvDragTo(off); }
        else if (ps.tdvDrag) { ps.tdvDrag = false; tdvDragCancel(true); }
        /* rubber band na primeira página (PearOS): resistência crescente */
        if (ps.tdvDrag) { /* sem resistência: a Vista Hoje segue o dedo */ }
        else if (page === 0 && off > 0) { const a = Math.abs(off); off = Math.sign(off) * (1 - 1 / (a * .55 / 160 + 1)) * 160; }
        /* Nova UI: não há Biblioteca de Apps; para além da última página o arrasto só resiste e volta */
        else if (isA() && page === last && off < 0) { const a = Math.abs(off); off = -(1 - 1 / (a * .55 / 160 + 1)) * 160; }
        const now = Date.now(); ps.vx = (e.clientX - (ps.lx == null ? ps.x : ps.lx)) / k / Math.max(1, now - (ps.lt || ps.t)); ps.lx = e.clientX; ps.lt = now;
        const pw = geo().pw; pagesEl.style.transform = `translateX(${-page * pw + off}px)`; par(-page * pw + off, true); }
    });
    const up = e => {
      if (!ps || ps.cont !== cont) return; clearTimeout(ps.timer); const dx = e.clientX - ps.x, dy = e.clientY - ps.y; const st = ps; ps = null;
      if (st.drag) { endDrag(e, st); return; }
      /* Nova UI: gaveta (para cima) e painel de notificações (para baixo) abrem com distância OU com um atirar rápido; senão voltam */
      if (st.adr || st.qp) { const k = kz(); const fresh = Date.now() - (st.lt || st.t) < 90; const v = fresh ? (st.vy || 0) : 0;
        if (st.adr) { const d = -dy / k; try { Drawer.pullEnd(d > 110 || (v < -.45 && d > 28)); } catch (err) {} }
        else { const d = dy / k; qpEnd(d > 90 || (v > .45 && d > 24)); } return; }
      /* pesquisa: abre com 70 px de puxão ou um atirar para baixo; menos do que isso volta a esconder-se */
      if (st.pull) { const k = kz(); const d = dy / k; const fresh = Date.now() - (st.lt || st.t) < 90; if (d > 70 || (fresh && (st.vy || 0) > .5 && d > 24)) openSearch(); else cancelPull(); return; }
      if (st.swipe) { pagesEl.classList.remove('drag'); const v = st.vx || 0; /* flick por velocidade ou por distância; para além da última página → Biblioteca de apps (PearOS) */
        if (st.libDrag) { if (dx < -90 || v < -.6) { openSpot(true); return; } cancelLibDrag(); goPage(page); return; }
        if (st.tdvDrag) { if ((dx / kz() > 90 && v > -.2) || v > .6) openTdv(true); else { tdvDragCancel(false); goPage(page); } return; }
        if (dx < -60 || v < -.45) goPage(page + STEP()); else if (dx > 60 || v > .45) goPage(page - STEP()); else goPage(page); return; }
      if (st.held && !st.it) return;
      if (st.moved) return;
      if (st.held && st.it && !edit) { if (!st.menu) ctxMenu(st.it); return; }   /* Nova UI: o menu já abriu com o dedo em baixo */
      if (st.it) { if (!edit) tap(st.it); return; }
      if (sel) { exitSelect(); return; }   /* Nova UI: tocar no vazio sai da seleção */
      if (edit && window.HomeCustom && HomeCustom.isOpen && HomeCustom.isOpen()) { HomeCustom.close(); return; }   /* com Personalizar aberta, tocar no fundo fecha só a folha (a edição continua) */
      if (edit) exitEdit();   /* (o antigo "dy < −40 → openSpot" nunca corria - o movimento já marcava `moved` - e ia no sentido errado; o puxar para baixo está no pointermove) */
    };
    cont.addEventListener('pointerup', up); cont.addEventListener('pointercancel', e => { if (ps && ps.drag) endDrag(null, ps); if (ps && ps.libDrag) cancelLibDrag(); if (ps && ps.tdvDrag) { tdvDragCancel(false); goPage(page); } if (ps && ps.pull) cancelPull(); if (ps && ps.adr) { try { Drawer.pullEnd(false); } catch (err) {} } if (ps && ps.qp) qpEnd(false); clearTimeout(ps && ps.timer); ps = null; pagesEl.classList.remove('drag'); });
  }
  function tap(it) { if (searchOpen()) return; const cell = it._cell;
    if (sel) { if (cell.t === 'app') { if (sel.has(cell.id)) sel.delete(cell.id); else sel.add(cell.id); Sound.play('click'); paintSel(); } return; }   /* Nova UI, selecionar: o toque marca/desmarca */ if (cell.t === 'app') System.openApp(cell.id, it.querySelector('.tile'), { fromHome: true }); else if (cell.t === 'folder') openFolder(cell.id); else if (cell.t === 'widget') { const w = layout.widgets[cell.id] || {}; Widgets.tap(w.type, w.app); } }

  let drag = null;
  /* ---------- pré-visualização (gravidade): enquanto se arrasta, a página por baixo do dedo mostra JÁ o arranjo final - o item
     entra na posição da sequência que está por baixo e os outros abrem espaço (só translate, com a transição do .hi); o que deixa
     de caber sai pela direita (vai para a página seguinte). Fora da página, o buraco de onde saiu fecha ---------- */
  /* posição na sequência de ícones da célula idx de uma página arrumada (contam as células livres e os ícones antes dela);
     null = em cima de um widget */
  function slotK(pg, idx) { if (isBlock(pg[idx])) return null; let k = 0; for (let i = 0; i < idx; i++) if (!isBlock(pg[i])) k++; return Math.min(k, seqOf(pg).I.length); }
  /* a página tp com o item arrastado lá dentro: ícone na posição k da sequência; widget na posição j dos widgets, do lado col */
  function withDrag(tp, at, cell) { const s = seqOf(layout.pages[tp]); if (at.k != null) s.I.splice(at.k, 0, cell); else s.W.splice(at.j, 0, { cell, col: at.col, i: -1 }); return s; }
  /* posiciona os nós de uma página segundo um arranjo { pg, oW, oI }; pi = a página (aberto pode ser a da direita). Com duas
     páginas à vista, o que transborda da esquerda iria parar à direita, por isso também desvanece (.pv-out) */
  function applyPreview(pv, pi) { const pe = pagesEl.children[pi]; if (!pe) return; const q = geo(), fo = q.per === 2, out = new Set(pv.oI.concat(pv.oW.map(w => w.cell)));
    [...pe.children].forEach(n => { const o = out.has(n._cell); if (fo) n.classList.toggle('pv-out', o); if (o) { n.style.setProperty('--x', (q.pw + 12) + 'px'); return; } const i = pv.pg.indexOf(n._cell); if (i < 0) return; pos(n, cellX(i % COLS), cellY(Math.floor(i / COLS))); }); }
  /* a página volta ao arranjo real (sem o item arrastado: o buraco de onde saiu fecha) */
  function clearPreview() { if (!drag) return; unpend(); if (drag.pvPage == null) return; const pi = drag.pvPage; drag.pv = null; drag.pvAt = null; drag.pvKey = null; drag.pvPage = null; applyPreview({ pg: layout.pages[pi] || emptyPage(), oW: [], oI: [] }, pi); }
  function showPreview(tp, at, key) { if (drag.pvPage != null && drag.pvPage !== tp) clearPreview(); const s = withDrag(tp, at, drag.cell); drag.pv = flow(s.W, s.I); drag.pvAt = at; drag.pvKey = key; drag.pvPage = tp; applyPreview(drag.pv, tp); }
  /* os outros só abrem espaço depois de o dedo PARAR um instante (140 ms) numa posição nova: varrer por cima dos ícones não os
     baralha e o ícone de destino de uma pasta não foge antes de o dedo lá chegar (como no PearPhone) */
  const PV_DWELL = 140;
  function unpend() { if (drag && drag.pend) { clearTimeout(drag.pend.t); drag.pend = null; } }
  function pendPreview(tp, at, key) { if (drag.pend && drag.pend.tp === tp && drag.pend.key === key) return; unpend();
    const pd = { tp, at, key }; pd.t = setTimeout(() => { if (drag && drag.pend === pd) { drag.pend = null; showPreview(tp, at, key); } }, PV_DWELL); drag.pend = pd; }
  /* PASTA: o ícone de baixo acende ao fim de FOLDER_MS com o centro do arrastado no centro dele. Conta um relógio e não o
     pointermove: o rato parado (no jogo) não manda movimentos e a pasta tinha de se armar na mesma. Sair do centro desarma */
  const FOLDER_MS = 550;
  function markOver(tl) { if (!drag || drag.overTile === tl) return; if (drag.overTile) drag.overTile.classList.remove('over'); drag.overTile = tl || null; if (tl) tl.classList.add('over'); }
  function armFolder(tp, under) { if (!drag) return; const pgEl = pagesEl.children[tp]; const ue = pgEl && [...pgEl.children].find(n => n._cell === under); markOver(ue && ue.querySelector('.tile')); drag.folderWith = under; }
  function unarm() { if (!drag) return; clearTimeout(drag.armT); drag.armT = null; drag.folderWith = null; markOver(null); }
  /* tira o item do sítio dele no início de um arrasto e guarda a posição na sequência (para voltar, se for largado fora); a página
     de origem fica logo arrumada sem ele (é dela que a pré-visualização parte) */
  function lift(cell, loc) {
    if (loc.kind === 'folder') { const f = layout.folders[loc.fid]; if (f) f.apps = f.apps.filter(id => id !== cell.id); return; }
    if (loc.kind === 'new') return;
    if (loc.kind === 'page' && layout.pages[loc.page]) { const s = seqOf(layout.pages[loc.page]), j = s.W.findIndex(w => w.cell === cell);
      drag.home = j > -1 ? { p: loc.page, j, col: s.W[j].col } : { p: loc.page, k: Math.max(0, s.I.findIndex(c => c.t === cell.t && c.id === cell.id)) }; }
    removeCell(cell);
    /* o que está à vista continua a ser o arranjo com ele no lugar: é essa a pré-visualização de partida (a 1.ª mudança de alvo
       mexe nos outros; sair da página fecha o buraco) */
    if (drag.home) { const h = drag.home; commitSeq(h.p, seqOf(layout.pages[h.p])); const s = withDrag(h.p, h, cell); drag.pv = flow(s.W, s.I); drag.pvAt = h; drag.pvKey = h.k != null ? 'k' + h.k : 'j' + h.j + ':' + h.col; drag.pvPage = h.p; }
  }
  /* dock na BARRA DIREITA (PearPhone Fold): coluna de ícones; mede-se UMA vez por arrasto (o centro de cada ícone, em px do ecrã) */
  function railDock() {
    if (!railOn() || !dockEl.classList.contains('rl-dock')) return null;
    const s = scr(), k = s.width / SWp(), b = dockEl.getBoundingClientRect(); if (!b.height) return null;
    return { y0: (b.top - s.top) / k, y1: (b.bottom - s.top) / k, ys: [...dockEl.children].map(n => { const r = n.getBoundingClientRect(); return (r.top + r.height / 2 - s.top) / k; }) };
  }
  /* NOVA dobrável: a dock larga-se a partir do meio da pílula de pesquisa (fica por cima da dock) */
  /* aberto ou fechado o NOVA Fold8 tem a mesma barra de baixo (4 out): com a pega a dock desce como fechado */
  const aDockY = () => isFold() ? (document.body.dataset.nav === 'gesture' ? 792 : 770) : A_DOCK_Y;
  function beginDrag(e) {
    const it = ps.it; if (!it) return; ps.drag = true; const cell = it._cell, loc = it._loc, q = geo();
    /* Nova UI em edição: o ícone vem de uma página encolhida (A_EDIT_S); sai dela no tamanho real, com o ponto de agarrar à mesma proporção */
    const r = it.getBoundingClientRect(), s = scr(), k = s.width / SWp() * (zoomed() && loc.kind === 'page' ? A_EDIT_S : 1); let w = r.width / k, h = r.height / k;
    /* o ponto de agarrar é o do pointerdown (ps.x/ps.y), não o do movimento que iniciou o arrasto - senão o ícone fica desalinhado com o dedo */
    let ox = ((ps ? ps.x : e.clientX) - r.left) / k, oy = ((ps ? ps.y : e.clientY) - r.top) / k;
    /* da dock da barra direita (ícones de 54): sai já do tamanho dos ícones das páginas, agarrado no mesmo ponto relativo */
    if (loc.kind === 'dock' && q.rw && w && w < q.cw - 2) { const f = q.cw / w; ox *= f; oy *= f; w = q.cw; h = q.cw + 22; }
    drag = { it, cell, loc, w, h, ox, oy, target: null, hoverKey: null, hoverT: 0, pv: null, pvAt: null, pvKey: null, pvPage: null, home: null };
    it.classList.add('dragging'); it.style.width = w + 'px'; el.appendChild(it); it.style.position = 'absolute'; it.style.zIndex = 60;
    lift(cell, loc);
    drag.rd = railDock(); if (loc.kind === 'dock') railGlass();
    if (isA()) showZones(cell);   /* Nova UI: "Remover" / "Desinstalar" no topo enquanto se arrasta */
    closeFolder(); moveDrag(e);
  }
  /* ---------- Nova UI: arrastar uma app vinda de FORA da home (gaveta de apps) ----------
     A gaveta fecha e entrega o ponteiro: a app passa a ser arrastada por cima das páginas como qualquer ícone. Se já estiver na
     home (página, dock ou pasta) é uma MUDANÇA de lugar; se estava escondida (removida da home) só volta se for largada numa
     célula válida (largar fora cancela, como na One UI). A gaveta encaminha os pointermove/pointerup para dragMove/dragEnd. */
  function dragIn(id, e) {
    if (!layout || drag || !App.get(id)) return false;
    closeAhMenu(true); closeFolder(); if (sel) exitSelect(); if (edit) exitEdit();
    const cell = { t: 'app', id }; const loc = findApp(id) || { kind: 'new' };
    const it = itemEl(cell, 0, 0, { kind: 'dock', idx: 0 }); it._loc = loc; const cw = geo().cw;
    drag = { it, cell, loc, w: cw, h: cw + 22, ox: cw / 2, oy: cw / 2, target: null, hoverKey: null, hoverT: 0, pv: null, pvAt: null, pvKey: null, pvPage: null, home: null, ext: true };
    it.classList.add('dragging'); it.style.width = cw + 'px'; it.style.position = 'absolute'; it.style.zIndex = 60; el.appendChild(it);
    lift(cell, loc);
    Sound.play('pop'); moveDrag(e); return true;
  }
  const dragMove = e => { if (drag) moveDrag(e); };
  const dragEnd = e => { if (drag) endDrag(e || null); };
  function moveDrag(e) {
    if (!drag) return; const q = geo(); const p = toPhone(e); const x = p.x - drag.ox, y = p.y - drag.oy; pos(drag.it, x, y);
    const cx = x + drag.w / 2, cy = y + Math.min(drag.h, q.cw) / 2;   /* o CENTRO do ícone arrastado decide o alvo (como no PearOS) */
    /* duas páginas à vista: a metade da zona de conteúdo escolhe a página (esquerda = page, direita = page + 1) e a coluna conta a
       partir dessa página. PearOS dobrável: à direita de --rail-w fica a barra (só a dock larga lá) */
    const half = q.per === 2 && cx >= q.pw ? 1 : 0, inRail = !!q.rw && cx >= q.cwid - 8, rd = drag.rd;
    const lc = toLocal(cx - half * q.pw, cy);   /* PearOS e Nova UI normal: lx = cx, ly = cy − topo da grelha; Nova UI em edição: desfaz a escala das páginas */
    let target = null;
    /* Nova UI: o DEDO na faixa de cima larga em "Remover"/"Desinstalar" (metade esquerda/direita quando há as duas) */
    if (drag.zones && p.y < 134) { const z = drag.zones.length > 1 && p.x >= SWp() / 2 ? drag.zones[1] : drag.zones[0]; target = { kind: 'zone', z }; dockEl.classList.remove('over'); }
    else if (inRail && rd) {
      /* dock vertical da barra direita: o lugar é o número de ícones com o centro acima do ícone arrastado */
      if (drag.cell.t === 'app' && cy > rd.y0 - 90 && cy < rd.y1 + 90) { target = { kind: 'dock', idx: rd.ys.filter(v => v < cy).length }; dockEl.classList.add('over'); } else dockEl.classList.remove('over'); }
    /* PearPhone Fold: a dock é a da barra direita (só a coluna dela larga lá); por baixo da grelha é a última fila da página */
    else if (isA() ? (!zoomed() && cy > aDockY() && drag.cell.t === 'app') : (!q.rw && cy > 830 && drag.cell.t === 'app')) {
      /* Nova UI: a dock não tem fundo e os ícones ficam centrados (com o passo da grelha; no dobrável aberto mais juntos): o lugar é o número de ícones à esquerda do centro */
      let idx; if (isA()) { const n = layout.dock.length, gp = q.fold ? q.dgap : q.gx, x0 = SWp() / 2 - (n * q.cw + Math.max(0, n - 1) * gp) / 2 + q.cw / 2; idx = 0; for (let i = 0; i < n; i++) if (x0 + i * (q.cw + gp) < cx) idx = i + 1; }
      else idx = Math.min(layout.dock.length, Math.max(0, Math.round((cx - dockX() - 21) / 95)));
      target = { kind: 'dock', idx }; dockEl.classList.add('over'); }
    else if (!inRail) { dockEl.classList.remove('over'); const c = Math.max(0, Math.min(COLS - 1, Math.floor((lc.lx - q.x0 + q.gx / 2) / (q.cw + q.gx)))), r = Math.max(0, Math.min(ROWS - 1, Math.floor(lc.ly / q.sy))); if (lc.ly >= -20 && (lc.ly < ROWS * q.sy + 20 || q.rw)) target = { kind: 'page', page: page + half, r, c }; }
    else dockEl.classList.remove('over');
    drag.target = target; if (drag.zones) paintZones(target && target.kind === 'zone' ? target.z : null);
    /* borda → mudar de ecrã (a pré-visualização recomeça na página nova; aberto muda o par inteiro). A borda direita é a da zona
       de conteúdo: com a barra direita, a faixa encostada a ela (a dock fica mais à direita e não conta) */
    const atL = p.x < 18, atR = p.x > q.cwid - 18 && (!q.rw || p.x < q.cwid + 10);
    if (atL || atR) { if (!edgeT) edgeT = setTimeout(() => { clearPreview(); goPage(page + (atL ? -STEP() : STEP())); if (drag) { unarm(); drag.hoverKey = null; drag.dropAt = null; } edgeT = null; }, 550); } else { clearTimeout(edgeT); edgeT = null; }
    /* ⚠️ SEM PESQUISAS NO DOCUMENTO POR FRAME.
       Aqui estava um `document.querySelectorAll('.tile.over')` - uma travessia do documento INTEIRO
       (mais de mil nós com a home, o lock e as janelas em memória) a cada pointermove do arrasto,
       só para apagar uma classe de UM ícone. Guarda-se o ícone realçado no próprio `drag` (markOver). */
    if (target && target.kind === 'page') {
      const tp = target.page;
      /* passou para outra página (a outra metade do par aberto, ou saiu da página de origem): a anterior volta ao arranjo real */
      if (drag.pvPage != null && drag.pvPage !== tp) clearPreview();
      const base = layout.pages[tp] || emptyPage(), idx = target.r * COLS + target.c, ref = drag.pv ? drag.pv.pg : base, under = ref[idx] === drag.cell ? null : ref[idx];
      /* zona central de um ícone: candidato a PASTA ao fim de 550 ms (sem mexer nos outros); bordas ou célula vazia: o ícone entra
         nessa posição da sequência e os outros abrem espaço (célula vazia depois do último = no fim da página) */
      const fx = (lc.lx - cellX(target.c)) / q.cw, fy = (lc.ly - cellY(target.r)) / q.cw;
      const central = drag.cell.t === 'app' && under && (under.t === 'app' || under.t === 'folder') && fx > .22 && fx < .78 && fy > .1 && fy < .9;
      if (central) { unpend(); const key = `${tp}:${idx}`;
        /* largado aqui antes de virar pasta: entra no lugar deste ícone e os outros abrem espaço (como nas bordas) */
        drag.dropAt = { tp, k: slotK(base, idx) };
        if (key !== drag.hoverKey) { unarm(); drag.hoverKey = key; drag.hoverT = Date.now(); drag.armT = setTimeout(() => { if (drag && drag.hoverKey === key) armFolder(tp, under); }, FOLDER_MS); }
        else if (!drag.folderWith && Date.now() - drag.hoverT > FOLDER_MS) armFolder(tp, under); }
      else { unarm(); drag.hoverKey = null; drag.dropAt = null; let at = null;
        /* widget: a ordem entre os widgets da página conta pela fila do canto de cima; o lado (esquerda / direita) pelo centro */
        if (isW(drag.cell)) { const col = sizeOf(drag.cell)[0] < COLS && lc.lx >= q.x0 + 2 * (q.cw + q.gx) - q.gx / 2 ? 2 : 0, top = toLocal(x + q.cw / 2 - half * q.pw, y + q.cw / 2);
          const a = Math.max(0, Math.min(ROWS - 1, Math.floor(top.ly / q.sy))) * COLS + col; at = { j: seqOf(base).W.filter(w => w.i < a).length, col }; }
        else { const k = slotK(base, idx); if (k != null) at = { k }; }   /* em cima de um widget: fica a pré-visualização que já havia */
        const key = at && (at.k != null ? 'k' + at.k : 'j' + at.j + ':' + at.col);
        if (at && (key !== drag.pvKey || drag.pvPage !== tp)) pendPreview(tp, at, key); else unpend(); }
    } else { unarm(); drag.hoverKey = null; drag.dropAt = null; clearPreview(); }
  }
  function endDrag(e, st) {
    /* largado antes de a pré-visualização pendente aparecer: conta onde o dedo está (é aí que se quis largar) */
    if (drag && drag.pend) { const pd = drag.pend; unpend(); if (drag.target && drag.target.kind === 'page' && drag.target.page === pd.tp) { drag.pvAt = pd.at; drag.pvPage = pd.tp; } }
    if (drag) clearTimeout(drag.armT);
    const d = drag; drag = null; clearTimeout(edgeT); edgeT = null; dockEl.classList.remove('over');
    if (d && d.overTile) d.overTile.classList.remove('over');
    /* rede de segurança 1×: um render() a meio do arrasto pode ter trocado o nó que estava marcado */
    document.querySelectorAll('.tile.over').forEach(t => t.classList.remove('over'));
    hideZones();
    if (!d) return;
    const cell = d.cell, t = d.target; let landOn = null;   /* landOn = a célula onde o item arrastado "aterra" com animação */
    /* 'new' = app vinda da gaveta que não estava na home: largar fora não a acrescenta (fica como estava). De uma página volta à
       MESMA posição da sequência (os outros voltam a abrir-lhe espaço) */
    const restore = () => { if (d.loc.kind === 'new') return;
      if (d.loc.kind === 'dock') layout.dock.splice(Math.min(d.loc.idx, layout.dock.length), 0, cell.id);
      else if (d.loc.kind === 'folder' && layout.folders[d.loc.fid]) { const a = layout.folders[d.loc.fid].apps; a.splice(Math.min(d.loc.idx, a.length), 0, cell.id); }
      else if (d.home) commitSeq(d.home.p, withDrag(d.home.p, d.home, cell));
      else place(cell); };
    if (!t) restore();
    else if (t.kind === 'zone') {
      /* Nova UI: largado em "Desinstalar" volta ao lugar e pergunta; em "Remover" sai da home (a app continua na gaveta) */
      if (t.z === 'uninstall') { restore(); const id = cell.id; setTimeout(() => askUninstall(id), 80); }
      else if (cell.t === 'app') hideApp(cell.id);
      else if (cell.t === 'folder') { const f = layout.folders[cell.id]; delete layout.folders[cell.id]; const apps = (f ? f.apps : []).map(id => ({ t: 'app', id }));   /* a pasta desfaz-se no lugar dela */
        if (d.home && d.home.k != null) insertAt(d.home.p, d.home.k, apps); else apps.forEach(c => place(c)); }
      else if (cell.t === 'widget') delete layout.widgets[cell.id]; }
    else if (t.kind === 'dock') { if (layout.dock.length >= 4) restore(); else layout.dock.splice(t.idx, 0, cell.id); }
    else { const base = layout.pages[t.page] || emptyPage(), fw = d.folderWith;
      if (fw && cell.t === 'app' && base.includes(fw)) {
        /* pasta: as duas apps juntam-se no lugar da que estava por baixo; o espaço que se tinha aberto para o ícone fecha */
        if (fw.t === 'folder') { const f = layout.folders[fw.id]; if (f) f.apps.push(cell.id); landOn = fw; }
        else { const fid = 'f' + Date.now(); landOn = { t: 'folder', id: fid }; layout.folders[fid] = { name: folderName(fw.id, cell.id), apps: [fw.id, cell.id] }; base[base.indexOf(fw)] = landOn; }
      } else {
        /* largado no centro de um ícone (sem pasta): o lugar desse ícone. Senão a posição que a pré-visualização mostrou; sem ela
           (largado logo em cima de um widget), no fim dessa página. Uma página cheia passa o último à seguinte (em cascata) */
        const da = d.dropAt && d.dropAt.tp === t.page && d.dropAt.k != null ? { k: d.dropAt.k } : null;
        const at = da || (d.pvAt && d.pvPage === t.page ? d.pvAt : isW(cell) ? { j: seqOf(base).W.length, col: 0 } : { k: seqOf(base).I.length });
        commitSeq(t.page, withDrag(t.page, at, cell)); landOn = cell; } }
    if (d.loc.kind === 'new' && findApp(cell.id)) unhideApp(cell.id);   /* veio da gaveta e ficou na home: deixa de estar escondida */
    tidy(); Sound.play('click'); save();
    /* o elemento arrastado vive em #home durante o arrasto: voa para a célula (transição do .hi) e só depois o DOM é consolidado - nunca fica órfão */
    const it = d.it, lp = landOn && where(landOn);
    /* Nova UI em edição a célula está encolhida: o ícone aterra no lugar encolhido e com a mesma escala (.ah-land) */
    if (lp && it.isConnected) { it.classList.remove('dragging'); if (zoomed()) it.classList.add('ah-land'); const sp = slotXY(lp.r, lp.c); pos(it, sp.x + (lp.p - page) * geo().pw, sp.y); setTimeout(() => { it.remove(); render(true); }, 340); }
    else { it.remove(); render(true); }
  }
  /* ---------- Nova UI: zonas "Remover" / "Desinstalar" no topo durante o arrasto (só para o que vem da home) ---------- */
  let dzEl = null;
  function showZones(cell) {
    if (!drag || drag.ext) return; const d = cell.t === 'app' ? (App.get(cell.id) || {}) : null;
    drag.zones = ['remove']; if (d && !d.core) drag.zones.push('uninstall');
    if (!dzEl) { dzEl = UI.el('<div class="ah-dz"></div>'); el.appendChild(dzEl); }
    dzEl.innerHTML = drag.zones.map(z => `<div class="ah-dzb ah-dz-${z}" data-z="${z}">${g(z === 'remove' ? 'minusCircle' : 'trash', 22)}<span>${UI.esc(L.t(z === 'remove' ? 'Remover' : 'Desinstalar'))}</span></div>`).join('');
    void dzEl.offsetWidth; dzEl.classList.add('on');
  }
  function paintZones(z) { if (!dzEl) return; [...dzEl.children].forEach(n => n.classList.toggle('hot', n.dataset.z === z)); }
  function hideZones() { if (dzEl) { dzEl.classList.remove('on'); paintZones(null); } }
  function hideApp(id) { const hid = (System.state.hiddenApps || []).slice(); if (!hid.includes(id)) hid.push(id); System.setState({ hiddenApps: hid }, { noApply: true }); }
  function unhideApp(id) { const hid = System.state.hiddenApps || []; if (hid.includes(id)) System.setState({ hiddenApps: hid.filter(x => x !== id) }, { noApply: true }); }
  /* desinstalar (Nova UI): diálogo de confirmação; as apps do sistema (core) não se desinstalam, só saem da home */
  async function askUninstall(id) {
    const d = App.get(id); if (!d || d.core) return false;
    const ok = await UI.confirm(L.t('Desinstalar') + ' ' + App.name(id) + '?', L.t('A app sai do telemóvel. Podes voltar a instalá-la na loja.'), L.t('Desinstalar'), true);
    if (!ok) return false; await System.uninstall(id); return true;
  }
  function folderName(a, b) { const ca = (App.get(a) || {}).category, cb = (App.get(b) || {}).category; return ca && ca === cb ? ca : 'Pasta'; }

  /* ---------- edição ---------- */
  function enterEdit() { if (edit) return; edit = true; el.classList.add('edit'); if (isA()) { closeAhMenu(true); if (sel) exitSelect(); ensureEbar(); } Sound.play('pop'); }
  /* sair da edição fecha também a folha Personalizar (vive por cima da home em edição, como no PearOS 27) */
  function exitEdit() { if (!edit) return; edit = false; el.classList.remove('edit'); if (window.HomeCustom && HomeCustom.isOpen && HomeCustom.isOpen()) HomeCustom.close(); save(); }
  /* PearOS 27: a pílula da esquerda do modo de edição é "Editar" e abre um menu (Adicionar widget · Personalizar), como no iOS 26.
     Nova UI (Android) não tem esta barra (tem a de baixo, ensureEbar); um homecustom.js em falta volta ao "+ Widget" de sempre */
  function editMenu(e) { if (e) e.stopPropagation();
    if (isA() || !window.HomeCustom) { addWidget(); return; }
    UI.ctxMenu(editBar.querySelector('.addw'), [{ label: L.t('Adicionar widget'), icon: 'plusCircle', onTap: addWidget }, { label: L.t('Personalizar'), icon: 'sliders', onTap: openCustomize }]); }
  const openCustomize = () => { if (window.HomeCustom && HomeCustom.open) HomeCustom.open(); };
  /* estilo dos ícones mudou (FINAL: largou-se o cursor, escolheu-se outro estilo). As imagens (.tile.img) já trocaram sozinhas
     (a regra .tl-* muda no sítio); aqui refazem-se só os SVG INLINE da home: os mini-ícones das pastas e o Relógio (ponteiros
     vivos). Nunca Home.render(): voltava a tocar a animação de entrada de todos os ícones. */
  function restyleInline() {
    if (!layout || !el) return;
    [el, dockEl].forEach(root => { if (!root) return;
      root.querySelectorAll('.hi.folder').forEach(it => { const f = layout.folders[it.dataset.fid], t = it.querySelector(':scope > .tile'); if (f && t) t.innerHTML = f.apps.slice(0, 9).map(id => `<div class="mini">${Icons.tile(id)}</div>`).join(''); });
      root.querySelectorAll('.hi.app > .tile:not(.img)').forEach(t => { const id = t.parentNode.dataset.id; if (id && App.get(id)) t.innerHTML = Icons.tile(id); }); });
    Icons.tickClocks(el);
  }
  /* Nova UI: barra de baixo do modo de edição (as páginas encolhem e a dock sai). Criada na primeira vez que é precisa: o PearOS nunca a tem. */
  let ebar = null;
  function ensureEbar() {
    if (ebar) return;
    const b = (a, ic, t) => `<div class="ah-eb" data-a="${a}">${g(ic, 26)}<span>${UI.esc(L.t(t))}</span></div>`;
    ebar = UI.el(`<div class="ah-ebar">${b('wp', 'photo', 'Fundos e estilo')}${b('wg', 'grid', 'Widgets')}${b('st', 'gear', 'Definições')}</div>`);
    ebar.addEventListener('click', e => { const x = e.target.closest('.ah-eb'); if (!x || !edit) return; e.stopPropagation(); Sound.play('click');
      if (x.dataset.a === 'wg') addWidget(); else { exitEdit(); openSettings(x.dataset.a === 'wp' ? 'wallpaper' : 'homescreen'); } });
    el.appendChild(ebar);
  }
  /* ---------- Nova UI: SELECIONAR várias apps (menu de um ícone › Selecionar) ----------
     Os ícones mostram um círculo de seleção (pseudo-elemento, sem nós novos); tocar marca/desmarca; em cima o número de
     selecionadas, em baixo "Criar pasta" e "Remover". Tocar no vazio, Voltar ou "Cancelar" saem. Só apps (páginas e dock). */
  let sel = null, selTop = null, selBar = null;
  function enterSelect(id) {
    if (!isA() || !layout) return; closeAhMenu(true); closeFolder(); if (edit) exitEdit();
    sel = new Set(); if (id && findApp(id) && findApp(id).kind !== 'folder') sel.add(id); el.classList.add('ah-sel');
    if (!selTop) { selTop = UI.el(`<div class="ah-stop"><span class="ah-scount"></span><div class="ah-sx">${UI.esc(L.t('Cancelar'))}</div></div>`); selTop.querySelector('.ah-sx').onclick = e => { e.stopPropagation(); exitSelect(); }; el.appendChild(selTop); }
    if (!selBar) { const b = (a, ic, t) => `<div class="ah-eb" data-a="${a}">${g(ic, 24)}<span>${UI.esc(L.t(t))}</span></div>`;
      selBar = UI.el(`<div class="ah-sbar">${b('folder', 'folder', 'Criar pasta')}${b('remove', 'minusCircle', 'Remover')}</div>`);
      selBar.addEventListener('click', e => { const x = e.target.closest('.ah-eb'); if (!x || !sel || x.classList.contains('off')) return; e.stopPropagation(); if (x.dataset.a === 'folder') selFolder(); else selRemove(); });
      el.appendChild(selBar); }
    Sound.play('pop'); paintSel();
  }
  function exitSelect() { if (!sel) return; sel = null; el.classList.remove('ah-sel'); paintSel(); }
  function paintSel() {
    const n = sel ? sel.size : 0;
    [pagesEl, dockEl].forEach(c => c && c.querySelectorAll('.hi.app').forEach(h => h.classList.toggle('ah-on', !!sel && !!h._cell && sel.has(h._cell.id))));
    if (selTop) selTop.querySelector('.ah-scount').textContent = !n ? L.t('Selecionar apps') : n === 1 ? L.t('1 selecionada') : n + ' ' + L.t('selecionadas');
    if (selBar) { selBar.querySelector('[data-a="folder"]').classList.toggle('off', n < 2); selBar.querySelector('[data-a="remove"]').classList.toggle('off', n < 1); }
  }
  /* a pasta nasce no lugar da PRIMEIRA app selecionada que esteja numa página (as que vêm da dock entram nela também); as
     outras saem e os buracos fecham */
  function selFolder() {
    if (!sel || sel.size < 2) return; const ids = [...sel]; let at = null;
    for (let p = 0; p < layout.pages.length && !at; p++) { const k = seqOf(layout.pages[p]).I.findIndex(c => c.t === 'app' && sel.has(c.id)); if (k > -1) at = { p, k }; }
    ids.forEach(id => removeCell({ t: 'app', id }));
    const fid = 'f' + Date.now(), fc = { t: 'folder', id: fid }; layout.folders[fid] = { name: folderName(ids[0], ids[1]), apps: ids };
    if (at) insertAt(at.p, at.k, [fc]); else place(fc, page);
    exitSelect(); render(true); save(); Sound.play('pop');
  }
  function selRemove() { if (!sel || !sel.size) return; const ids = [...sel]; ids.forEach(id => { removeCell({ t: 'app', id }); hideApp(id); }); exitSelect(); render(true); save(); }
  /* ---------- animações de widget (só transform/opacity): .dying encolhe e desvanece antes de sair; .born entra com mola ---------- */
  const widgetNode = id => pagesEl && [...pagesEl.querySelectorAll('.hi.widget')].find(n => n._cell && n._cell.id === id);
  const noMotion = () => !!(System.state && System.state.reduceMotion);
  function dyingFx(id, then) { const n = widgetNode(id); if (!n || noMotion()) { then(); return; } n.classList.add('dying'); setTimeout(then, 220); }
  function bornFx(id) { if (noMotion()) return; const n = widgetNode(id); if (!n) return; n.classList.remove('born'); void n.offsetWidth; n.classList.add('born'); setTimeout(() => n.classList.remove('born'), 560); }
  /* o que um widget EMPURROU para as páginas seguintes ao crescer fica escrito nele (widgets[id].spill = ['app:x', 'folder:y',
     'widget:z'], pela ordem em que saíram): quando ele encolhe ou é removido, isso volta para o fim da página dele, se ainda
     estiver numa página a seguir (o que o jogador levou para a dock, uma pasta ou uma página antes fica onde está) */
  const ckey = c => c.t + ':' + c.id;
  const spillOf = w => asArray(w && w.spill).filter(k => typeof k === 'string');
  const seqKeys = s => s.W.map(x => ckey(x.cell)).concat(s.I.map(ckey));
  const pageOfCell = cell => layout.pages.findIndex(pg => pg.some(c => c && c.t === cell.t && c.id === cell.id));
  /* tira das páginas depois de p o que está em keys e devolve a sequência da página p com isso no fim (widgets no fim dos
     widgets, ícones no fim dos ícones); quem chama grava com commitSeq (o que não couber volta a passar à seguinte) */
  function pullBack(p, keys) {
    const s = seqOf(layout.pages[p]);
    keys.forEach(k => { for (let q = p + 1; q < layout.pages.length; q++) { const pg = layout.pages[q], i = pg.findIndex(c => c && c.t !== 'cover' && ckey(c) === k); if (i < 0) continue;
      const c = pg[i]; pg[i] = null;
      if (c.t === 'widget') { pg.forEach((x, j) => { if (x && x.t === 'cover' && x.of === c.id) pg[j] = null; }); s.W.push({ cell: c, col: i % COLS, i: COLS * ROWS }); }
      else s.I.push(c);
      return; } });
    return s;
  }
  /* redimensionar (menu de contexto): o widget cresce no SÍTIO dele - passa à frente dos widgets da mesma fila ou de baixo, que
     lhe saem da frente - e os ícones voltam a correr à volta; o que deixar de caber passa ao início da página seguinte (e fica
     anotado: encolher outra vez trá-lo de volta) */
  function resizeWidget(cell, size) {
    const w = layout.widgets[cell.id]; if (!w || !WSIZE[size] || (WSIZE[w.size] ? w.size : '2x2') === size) return;
    dyingFx(cell.id, () => {
      if (!layout.widgets[cell.id]) return;   /* removido entretanto */
      let at = null; for (let p = 0; p < layout.pages.length && !at; p++) { const s = seqOf(layout.pages[p]), j = s.W.findIndex(x => x.cell.id === cell.id); if (j > -1) at = { p, s, j }; }
      w.size = size;
      if (at) { const s = pullBack(at.p, spillOf(w)), before = seqKeys(s), j = s.W.findIndex(x => x.cell.id === cell.id);
        const me = s.W.splice(j, 1)[0], row = Math.floor(me.i / COLS); let k = s.W.findIndex(x => Math.floor(x.i / COLS) >= row); if (k < 0) k = s.W.length;
        s.W.splice(k, 0, me); commitSeq(at.p, s);
        const now = new Set(seqKeys(seqOf(layout.pages[at.p]))), out = before.filter(x => !now.has(x) && x !== 'widget:' + cell.id);
        if (out.length) w.spill = out; else delete w.spill; }
      else { delete w.spill; const pos = place({ t: 'widget', id: cell.id }, page); if (pos) page = pos.p; }
      render(true); save(); bornFx(cell.id); Sound.play('pop');
    });
  }
  /* remover: o buraco fecha (os seguintes deslizam para trás); uma pasta removida desfaz-se no lugar dela; um widget devolve à
     página dele o que tinha empurrado para as seguintes */
  async function removeItem(cell) {
    if (cell.t === 'widget') { dyingFx(cell.id, () => { const w = layout.widgets[cell.id], p = pageOfCell(cell); removeCell(cell);
      if (p > -1 && spillOf(w).length) commitSeq(p, pullBack(p, spillOf(w)));
      delete layout.widgets[cell.id]; render(true); save(); }); return; }
    if (cell.t === 'folder') { const f = layout.folders[cell.id], at = seqPos(cell); removeCell(cell); delete layout.folders[cell.id]; const apps = (f ? f.apps : []).map(id => ({ t: 'app', id }));
      if (at) insertAt(at.p, at.k, apps); else apps.forEach(c => place(c)); render(true); save(); return; }
    /* Nova UI: "Remover" tira só da home, sem perguntar (a app continua na gaveta); desinstalar é outro botão, com confirmação.
       Também sai de dentro de uma pasta (o removeCell só vê páginas e dock); uma pasta que fique vazia desaparece no reconcile. */
    if (isA()) { removeCell(cell); for (const fid in layout.folders) layout.folders[fid].apps = layout.folders[fid].apps.filter(x => x !== cell.id); hideApp(cell.id); reconcile();
      const fo = openFolderId; if (fo && !layout.folders[fo]) closeFolder(); else { render(true); if (fo) openFolder(fo); } save(); return; }
    const d = App.get(cell.id) || {}; const btns = [{ label: 'Remover do ecrã principal', value: 'hide' }]; if (!d.core) btns.unshift({ label: 'Apagar app', danger: true, value: 'del' });
    const v = await UI.actionSheet({ title: `Remover "${App.name(cell.id)}"?`, buttons: btns }); if (!v) return;
    if (v === 'del') { await System.uninstall(cell.id); return; }
    removeCell(cell); const hid = (System.state.hiddenApps || []).slice(); if (!hid.includes(cell.id)) hid.push(cell.id); System.setState({ hiddenApps: hid }, { noApply: true }); render(true); save();
  }
  /* ---------- Nova UI: menu de um ícone (pop-up One UI) ----------
     Cartão por cima do ícone (ou por baixo, se não couber): atalhos da app em lista e, em baixo, uma fila de botões com ícone e
     legenda. Montado no #screen (por cima da home e da gaveta); fecha ao tocar fora, ao escolher, com Voltar, ao arrastar o ícone,
     ao guardar o telemóvel e ao trocar de sistema. Também usado pela gaveta (Home.ahMenu). */
  let ahm = null;
  function closeAhMenu(instant) { const m = ahm; if (!m) return; ahm = null; if (m.untrack) { try { m.untrack(); } catch (e) {} } m.wrap.classList.remove('in'); m.wrap.classList.add('out'); if (instant) m.wrap.remove(); else setTimeout(() => m.wrap.remove(), 170); }
  function ahMenu(anchor, rows, acts) {
    closeAhMenu(true); if (!anchor || !anchor.getBoundingClientRect) return null;
    const wrap = UI.el('<div class="ah-mw"><div class="ah-m"></div></div>'); const m = wrap.firstElementChild;
    const run = fn => ev => { ev.stopPropagation(); closeAhMenu(); Sound.play('click'); if (typeof fn === 'function') setTimeout(() => { try { fn(); } catch (e) { console.error('[apex_phone] menu', e); } }, 0); };
    (rows || []).forEach(r => { const d = UI.el(`<div class="ah-mr">${r.iconHtml || g(r.icon || 'chevR', 20)}<span></span></div>`); d.querySelector('span').textContent = r.label; d.onclick = run(r.onTap); m.appendChild(d); });
    if (acts && acts.length) { const row = UI.el(`<div class="ah-ma${rows && rows.length ? '' : ' solo'}"></div>`);
      acts.forEach(a => { const b = UI.el(`<div class="ah-mb${a.danger ? ' danger' : ''}">${g(a.icon, 22)}<span></span></div>`); b.querySelector('span').textContent = a.label; b.onclick = run(a.onTap); row.appendChild(b); }); m.appendChild(row); }
    UI.screen().appendChild(wrap);
    /* posição: medida UMA vez ao abrir (o cartão já está no documento); centrado no ícone e sempre dentro do ecrã */
    const sw = SWp(), s = scr(), k = s.width / sw, r = anchor.getBoundingClientRect();
    const ax = (r.left - s.left) / k, ay = (r.top - s.top) / k, aw = r.width / k, ah = r.height / k; const W = m.offsetWidth || 252, H = m.offsetHeight || 120;
    const x = Math.max(12, Math.min(sw - 12 - W, ax + aw / 2 - W / 2)); let y = ay - H - 12, below = false;
    if (y < 58) { y = ay + ah + 12; below = true; } if (y + H > 900) y = Math.max(58, 900 - H);
    m.style.left = x.toFixed(1) + 'px'; m.style.top = y.toFixed(1) + 'px'; m.style.transformOrigin = `${Math.round(ax + aw / 2 - x)}px ${below ? 0 : Math.round(H)}px`;
    wrap.addEventListener('pointerdown', e => { if (e.target === wrap) { e.stopPropagation(); closeAhMenu(); } });
    const st = { wrap, untrack: null }; ahm = st;
    /* se o ui.js expuser o registo das camadas passageiras (UI.track), o Voltar do Android e o UI.dismissAll também o fecham */
    if (UI.track) { try { st.untrack = UI.track(() => { if (ahm === st) closeAhMenu(true); }); } catch (e) {} }
    requestAnimationFrame(() => { if (ahm === st) wrap.classList.add('in'); });
    return st;
  }
  /* "Informações da app": as Definições abrem na lista de Apps; o evento seguinte pede a página da app (Definições › Apps › app) */
  function appInfo(id) { openSettings('apps'); setTimeout(() => { try { Bridge.emit('settings:appinfo', id); } catch (e) {} }, 700); }
  function ctxMenuA(it) {
    /* âncora = o ícone inteiro (com a legenda): por baixo, o menu não tapa o nome da app */
    const cell = it._cell; const anchor = cell.t === 'widget' ? (it.querySelector('.wg') || it) : it; const rows = [], acts = [];
    if (cell.t === 'app') { const d = App.get(cell.id) || {};
      let a = []; try { a = typeof d.actions === 'function' ? d.actions() : d.actions; } catch (e) { console.error('[apex_phone] actions', cell.id, e); }
      (Array.isArray(a) ? a : []).filter(x => x && x.label && typeof x.onTap === 'function').slice(0, 4).forEach(x => rows.push({ label: x.label, icon: x.icon || 'chevR', onTap: () => x.onTap() }));
      rows.push({ label: L.t('Partilhar'), icon: 'share', onTap: () => shareApp(cell.id) });
      acts.push({ label: L.t('Selecionar'), icon: 'checkCircle', onTap: () => enterSelect(cell.id) });
      acts.push({ label: L.t('Informações'), icon: 'info', onTap: () => appInfo(cell.id) });
      acts.push({ label: L.t('Remover'), icon: 'minusCircle', onTap: () => removeItem(cell) });
      if (!d.core) acts.push({ label: L.t('Desinstalar'), icon: 'trash', danger: true, onTap: () => askUninstall(cell.id) }); }
    else if (cell.t === 'folder') {
      rows.push({ label: L.t('Mudar nome'), icon: 'pen', onTap: async () => { const f = layout.folders[cell.id]; if (!f) return; const n = await UI.prompt(L.t('Nome da pasta'), '', L.t('Nome'), f.name); if (n && layout.folders[cell.id]) { layout.folders[cell.id].name = n.slice(0, 20); render(); save(); } } });
      rows.push({ label: L.t('Adicionar apps'), icon: 'plusCircle', onTap: () => folderAdd(cell.id) });
      acts.push({ label: L.t('Selecionar'), icon: 'checkCircle', onTap: () => enterSelect() });
      acts.push({ label: L.t('Remover'), icon: 'minusCircle', onTap: () => removeItem(cell) }); }
    else { const w = layout.widgets[cell.id] || {}; const def = Widgets.get(w.type); const cur = WSIZE[w.size] ? w.size : '2x2'; const area = s => WSIZE[s][0] * WSIZE[s][1];
      const LBL = { '2x2': 'Pequeno', '4x2': 'Médio', '4x4': 'Grande' };
      (def && Widgets.sizesOf ? Widgets.sizesOf(def) : ['2x2']).filter(s => s !== cur && WSIZE[s]).forEach(s => rows.push({ label: `${L.t(LBL[s])} · ${s.replace('x', ' × ')}`, icon: area(s) > area(cur) ? 'expand' : 'minimize', onTap: () => resizeWidget(cell, s) }));
      rows.push({ label: L.t('Trocar widget'), icon: 'sliders', onTap: () => Widgets.pickerSheet(pw => { const ww = layout.widgets[cell.id]; if (!ww) return; ww.type = pw.id; ww.name = pw.name; ww.app = pw.app || undefined; if (WSIZE[pw.size] && pw.size !== (WSIZE[ww.size] ? ww.size : '2x2')) resizeWidget(cell, pw.size); else { render(); save(); bornFx(cell.id); } }) });
      acts.push({ label: L.t('Editar ecrã'), icon: 'grid', onTap: enterEdit });
      acts.push({ label: L.t('Remover'), icon: 'minusCircle', onTap: () => removeItem(cell) }); }
    ahMenu(anchor, rows, acts);
  }
  /* pasta (Nova UI) › "+": escolher apps da home para meter na pasta */
  function folderAdd(fid) {
    const f = layout.folders[fid]; if (!f) return; const cands = [];
    layout.pages.forEach(pg => pg.forEach(c => { if (c && c.t === 'app' && !cands.includes(c.id)) cands.push(c.id); })); layout.dock.forEach(id => { if (!cands.includes(id)) cands.push(id); });
    if (!cands.length) { UI.toast(L.t('Não há apps para adicionar')); return; }
    const pick = new Set();
    const body = UI.list([{ items: cands.sort((a, b) => App.name(a).localeCompare(App.name(b))).map(id => ({ icon: Icons.tileBox(id), tile: true, iconBg: 'transparent', label: App.name(id), check: false, onCheck: on => { if (on) pick.add(id); else pick.delete(id); }, onTap: li => { const c = li.querySelector('.check'); if (c) c.click(); } })) }]);
    UI.sheet({ title: L.t('Adicionar apps'), left: L.t('Cancelar'), right: L.t('Adicionar'), body, cls: 'ah-fsheet', onDone: () => {
      const ff = layout.folders[fid]; if (!ff || !pick.size) return; pick.forEach(id => { removeCell({ t: 'app', id }); if (!ff.apps.includes(id)) ff.apps.push(id); });
      render(true); save(); if (openFolderId === fid) openFolder(fid); } });
  }
  function ctxMenu(it) {
    if (isA()) { ctxMenuA(it); return; }
    const cell = it._cell; const items = [];
    if (cell.t === 'app') { const d = App.get(cell.id) || {};
      /* quick actions: lista fixa OU função que a devolve na hora (ex.: os favoritos do Telefone); uma função que rebente não tira o resto do menu */
      let acts = []; try { acts = typeof d.actions === 'function' ? d.actions() : d.actions; } catch (e) { console.error('[apex_phone] actions', cell.id, e); }
      (Array.isArray(acts) ? acts : []).filter(a => a && a.label && typeof a.onTap === 'function').forEach(a => items.push({ label: a.label, icon: a.icon, onTap: () => a.onTap() }));
      items.push({ label: 'Partilhar app', icon: 'share', onTap: () => shareApp(cell.id) }); items.push({ label: 'Editar ecrã principal', icon: 'move', onTap: enterEdit });
      items.push({ label: d.core ? 'Remover do ecrã principal' : 'Remover app', icon: d.core ? 'minusCircle' : 'trash', danger: true, onTap: () => removeItem(cell) }); }
    else if (cell.t === 'folder') { items.push({ label: 'Mudar nome', icon: 'pen', onTap: async () => { const n = await UI.prompt('Nome da pasta', '', 'Nome', layout.folders[cell.id].name); if (n) { layout.folders[cell.id].name = n; render(); save(); } } }); items.push({ label: 'Editar ecrã principal', icon: 'move', onTap: enterEdit }); items.push({ label: 'Remover pasta', icon: 'trash', danger: true, onTap: () => removeItem(cell) }); }
    else { const w = layout.widgets[cell.id] || {}; const def = Widgets.get(w.type); const cur = WSIZE[w.size] ? w.size : '2x2'; const area = s => WSIZE[s][0] * WSIZE[s][1];
      const LBL = { '2x2': 'Pequeno', '4x2': 'Médio', '4x4': 'Grande' };
      (def && Widgets.sizesOf ? Widgets.sizesOf(def) : ['2x2']).filter(s => s !== cur && WSIZE[s]).forEach(s => items.push({ label: `${L.t(LBL[s])} · ${s.replace('x', '×')}`, icon: area(s) > area(cur) ? 'expand' : 'minimize', onTap: () => resizeWidget(cell, s) }));
      items.push({ label: 'Editar widget', icon: 'sliders', onTap: () => Widgets.pickerSheet(pw => { const ww = layout.widgets[cell.id]; if (!ww) return; ww.type = pw.id; ww.name = pw.name; ww.app = pw.app || undefined; if (WSIZE[pw.size] && pw.size !== (WSIZE[ww.size] ? ww.size : '2x2')) resizeWidget(cell, pw.size); else { render(); save(); bornFx(cell.id); } }) });   /* trocar para um tipo de outro tamanho redimensiona (antes ficava com o tamanho antigo) */
      items.push({ label: 'Editar ecrã principal', icon: 'move', onTap: enterEdit }); items.push({ label: 'Remover widget', icon: 'trash', danger: true, onTap: () => removeItem(cell) }); }
    UI.ctxMenu(it, items);
  }
  /* "Partilhar app": escolhe um contacto e manda uma mensagem do tipo 'app' (payload { app }); a app Mensagens desenha o cartão */
  async function shareApp(id) {
    if (!window.Contacts || !Contacts.pick) { UI.toast('Contactos indisponíveis'); return; }
    const c = await Contacts.pick(L.t('Partilhar com')); if (!c || !c.number) return;
    let r = null; try { r = await Bridge.rpc('messages.send', { to: String(c.number), type: 'app', content: App.name(id), payload: { app: id } }); } catch (e) { r = null; }
    if (r && !r.error) { Sound.play('send'); UI.toast(L.t('App partilhada com') + ' ' + (c.name || c.number)); } else UI.toast(L.t('Não foi possível partilhar'));
  }
  /* `name` e `app` ficam gravados com a célula: um widget externo desaparece do registo quando a app
     externa morre, e sem eles a célula perdia o nome e deixava de saber o que abrir (SHELL-06/EXT-N1) */
  /* widget novo: entra na página à vista (aberto, na da esquerda) a seguir aos widgets dela; os ícones descem (deslizam) */
  function addWidget() { Widgets.pickerSheet(w => { const id = 'w' + Date.now(); layout.widgets[id] = { type: w.id, size: WSIZE[w.size] ? w.size : '2x2', name: w.name, app: w.app || undefined }; const pos = place({ t: 'widget', id }, page); if (pos) { if (!viewPages().includes(pos.p)) page = pos.p; render(true); save(); bornFx(id); } else { delete layout.widgets[id]; UI.toast('Sem espaço'); } }); }
  /* app instalada (AppShop) ou devolvida ao ecrã principal (gaveta da Nova UI): DEPOIS dos itens que já lá estão, nunca num vazio por cima deles */
  function addApp(id) { if (!layout) return; if (findApp(id)) return; const hid = (System.state.hiddenApps || []).filter(x => x !== id); System.setState({ hiddenApps: hid }, { noApply: true }); place({ t: 'app', id }); render(true); saveSys(); }   /* instalar não é mexer na disposição */
  function removeApp(id) { if (!layout) return; removeCell({ t: 'app', id }); for (const fid in layout.folders) layout.folders[fid].apps = layout.folders[fid].apps.filter(x => x !== id); reconcile(); render(true); saveSys(); }

  /* ---------- pastas ---------- */
  function openFolder(fid) {
    const f = layout.folders[fid]; if (!f) return; openFolderId = fid;
    if (isA()) { openFolderA(fid, f); return; }
    folderOv.classList.remove('ah-fo');
    folderOv.innerHTML = `<input class="folder-name" value="${UI.esc(f.name)}" maxlength="20"><div class="folder-box lg lg-wp"></div>`;
    const box = folderOv.querySelector('.folder-box'); f.apps.forEach((id, i) => box.appendChild(itemEl({ t: 'app', id }, 0, 0, { kind: 'folder', fid, idx: i })));
    folderOv.querySelector('.folder-name').onchange = e => { f.name = e.target.value.trim() || 'Pasta'; save(); };
    /* a pasta cresce a partir do seu ícone (PearOS): origem da transformação = centro do ícone, em coordenadas da caixa */
    const src = pagesEl.querySelector(`.hi.folder[data-fid="${cssEsc(fid)}"] .tile`); if (src) { const s = scr(), k = s.width / SWp(), b = box.getBoundingClientRect(), t = src.getBoundingClientRect(); box.style.transformOrigin = `${(t.left + t.width / 2 - b.left) / k}px ${(t.top + t.height / 2 - b.top) / k}px`; } else box.style.transformOrigin = '';
    folderOv.classList.add('in'); folderOv.onclick = e => { if (e.target === folderOv) closeFolder(); };
    bindContainer(box); dimSync(); if (window.Glass) Glass.sync(box);   /* vidro: a cópia do fundo alinhada com a caixa (glass27.css) */
  }
  /* pasta Nova UI: cartão r26 por cima do fundo desfocado, com o nome editável à esquerda, "+" para juntar apps e grelha de 4 colunas;
     cresce a partir do ícone da pasta, como no PearOS (origem da transformação = centro do ícone) */
  function openFolderA(fid, f) {
    closeAhMenu(true); folderOv.classList.add('ah-fo');
    folderOv.innerHTML = `<div class="ah-fcard"><div class="ah-fhead"><input class="ah-fname" value="${UI.esc(f.name)}" maxlength="20" spellcheck="false"><div class="ah-fadd">${g('plus', 22)}</div></div><div class="ah-fbox"></div></div>`;
    const card = folderOv.querySelector('.ah-fcard'), box = folderOv.querySelector('.ah-fbox');
    f.apps.forEach((id, i) => box.appendChild(itemEl({ t: 'app', id }, 0, 0, { kind: 'folder', fid, idx: i })));
    const inp = folderOv.querySelector('.ah-fname'); inp.onchange = e => { f.name = e.target.value.trim().slice(0, 20) || 'Pasta'; save(); }; inp.onkeydown = e => { if (e.key === 'Enter') inp.blur(); };
    folderOv.querySelector('.ah-fadd').onclick = e => { e.stopPropagation(); folderAdd(fid); };
    const src = pagesEl.querySelector(`.hi.folder[data-fid="${cssEsc(fid)}"] .tile`) || dockEl.querySelector(`.hi.folder[data-fid="${cssEsc(fid)}"] .tile`);
    /* mede-se o cartão SEM a escala de partida (o CSS fechado tem scale .6) e só depois se repõe, para a origem bater certo com o ícone */
    if (src && !folderOv.classList.contains('in')) { card.style.transform = 'none'; const s = scr(), k = s.width / SWp(), b = card.getBoundingClientRect(), t = src.getBoundingClientRect();
      card.style.transformOrigin = `${((t.left + t.width / 2 - b.left) / k).toFixed(0)}px ${((t.top + t.height / 2 - b.top) / k).toFixed(0)}px`; card.style.transform = ''; void card.offsetWidth; }
    folderOv.classList.add('in'); folderOv.onclick = e => { if (e.target === folderOv) closeFolder(); };
    bindContainer(box); dimSync();
  }
  function closeFolder() { if (!folderOv) return; if (openFolderId) render(); openFolderId = null; folderOv.classList.remove('in'); dimSync(); }
  /* o dobrável abriu ou fechou com uma camada da home aberta: ela fica (nada do que está à vista sai). A Biblioteca continua no lugar
     dela, à direita das páginas (o relayout pôs as páginas de volta à vista), e a pasta, já no sítio novo pelo CSS, passa a fechar
     para o ícone no sítio novo. A pesquisa global é só CSS */
  function keepOverlays() {
    if (spotIn()) { const lx = -(page + STEP()) * geo().pw; pagesEl.classList.add('drag'); pagesEl.style.transform = `translateX(${lx}px)`; par(lx, true); requestAnimationFrame(() => pagesEl.classList.remove('drag')); paintDots(); }
    /* Vista Hoje aberta: continua aberta (a grelha passa a 4 colunas aberto, só CSS) e as páginas ficam um ecrã à direita */
    if (tdvIn()) { const lx = tdvLx(); pagesEl.classList.add('drag'); pagesEl.style.transform = `translateX(${lx}px)`; par(lx, true); requestAnimationFrame(() => pagesEl.classList.remove('drag')); }
    if (openFolderId && folderOv && folderOv.classList.contains('in')) {
      const box = folderOv.querySelector(isA() ? '.ah-fcard' : '.folder-box'), fid = cssEsc(openFolderId);
      const src = pagesEl.querySelector(`.hi.folder[data-fid="${fid}"] .tile`) || dockEl.querySelector(`.hi.folder[data-fid="${fid}"] .tile`);
      if (box && src) { const s = scr(), k = s.width / SWp(), b = box.getBoundingClientRect(), t = src.getBoundingClientRect();
        box.style.transformOrigin = `${((t.left + t.width / 2 - b.left) / k).toFixed(0)}px ${((t.top + t.height / 2 - b.top) / k).toFixed(0)}px`; }
    }
    dimSync();
  }

  /* ---------- Biblioteca de Apps (PearOS): MAIS UMA PÁGINA à direita da última - entra a deslizar (não é um pop-up), faz scroll vertical e arrastar para a
     direita volta. Barra "Biblioteca de Apps" no topo (a pesquisa é opcional, sem teclado automático) + quadrados por categoria (3 ícones grandes + mini-grelha) ---------- */
  let spotS = null, spotRes = null;
  const spotIn = () => !!spot && spot.classList.contains('in') && !spot.classList.contains('out');
  const appItem = (id, cls = '') => { const it = UI.el(`<div class="hi app ${cls}" data-id="${UI.esc(id)}"><div class="tile">${Icons.tile(id)}</div></div>`); it.onclick = e => { e.stopPropagation(); closeSpot(); System.openApp(id); };
    UI.longPress(it, () => UI.ctxMenu(it, [{ label: 'Adicionar ao ecrã principal', icon: 'plusCircle', onTap: () => { addApp(id); UI.toast('Adicionada'); } }, { label: 'Abrir', icon: 'expand', onTap: () => { closeSpot(); System.openApp(id); } }])); return it; };
  /* sair da Biblioteca e da pesquisa global antes de abrir o que se tocou (qualquer das duas pode estar aberta) */
  const leave = () => { closeSearch(true); closeSpot(); };
  const listOf = (ids, header, lv = leave) => UI.list([{ header, items: ids.map(id => ({ icon: Icons.tile(id), tile: true, iconBg: 'transparent', label: App.name(id), sub: L.t(LIB_LABEL[libCat(id)]), chevron: false, onTap: () => { lv(); System.openApp(id); } })) }]);
  /* ---------- categorias da Biblioteca (fixas): Social, Utilidades, Finanças, Jogos, Trabalho, Entretenimento, Servidor ----------
     Vêm do `category` livre de cada App.define (há ids com categoria própria); `libCategory` escolhe uma à mão; as apps registadas
     por OUTROS resources (RegisterApp → external) vão sempre para Servidor. */
  const LIB_ORDER = ['social', 'utilities', 'finance', 'games', 'work', 'entertainment', 'server'];
  const LIB_LABEL = { social: 'Social', utilities: 'Utilidades', finance: 'Finanças', games: 'Jogos', work: 'Trabalho', entertainment: 'Entretenimento', server: 'Servidor' };
  const LIB_FROM = { 'Redes sociais': 'social', 'Comunicação': 'social', 'Social': 'social', 'Utilitários': 'utilities', 'Utilidades': 'utilities', 'Produtividade': 'utilities', 'Navegação': 'utilities', 'Finanças': 'finance', 'Compras': 'finance', 'Jogos': 'games', 'Trabalho': 'work', 'Entretenimento': 'entertainment', 'Criatividade': 'entertainment', 'Comida': 'entertainment', 'Estilo de vida': 'entertainment' };
  const LIB_BY_ID = { services: 'work', billing: 'work', darkchat: 'social', onion: 'finance', crypto: 'finance' };
  function libCat(id) { const d = App.get(id) || {}; if (d.external) return 'server'; const lc = String(d.libCategory || '').toLowerCase(); if (LIB_LABEL[lc] && lc !== 'server') return lc; return LIB_BY_ID[id] || LIB_FROM[d.category] || 'utilities'; }
  /* recentes: os da sessão (System.recents) à frente dos gravados na conta (System.state.recentApps) */
  const recentList = () => { const saved = Array.isArray(System.state.recentApps) ? System.state.recentApps : []; return [...System.recents, ...saved].filter((id, i, a) => typeof id === 'string' && a.indexOf(id) === i); };
  /* q = texto da pesquisa (apps, contactos, mensagens, definições - a mesma da pesquisa global); all = campo focado sem texto → lista alfabética de todas as apps (PearOS) */
  function renderLib(q, all) {
    const res = spotRes; if (!res) return;
    if (q) { searchInto(res, q); return; }
    res.innerHTML = ''; res.scrollTop = 0; const inst = System.installed().filter(id => !(App.get(id) || {}).hidden);
    if (all) { const list = inst.slice().sort((a, b) => App.name(a).localeCompare(App.name(b))); res.appendChild(list.length ? listOf(list, 'Apps') : UI.el('<div class="lib-empty">Sem resultados</div>')); return; }
    /* Sugestões (recentes, gravados) · Adições recentes (instaladas pela AppShop) · as 7 categorias fixas, pela ordem acima (só as que têm apps) */
    const cats = []; const rec = recentList().filter(id => inst.includes(id)).slice(0, 4); if (rec.length) cats.push([L.t('Sugestões'), rec]);
    const added = inst.filter(id => !(App.get(id) || {}).core).slice(-4); if (added.length) cats.push([L.t('Adições recentes'), added]);
    const byCat = {}; inst.forEach(id => { const c = libCat(id); (byCat[c] = byCat[c] || []).push(id); });
    LIB_ORDER.forEach(c => { if (byCat[c] && byCat[c].length) cats.push([L.t(LIB_LABEL[c]), byCat[c]]); });
    const lib = UI.el('<div class="lib"></div>');
    cats.forEach(([name, ids]) => {
      const cat = UI.el(`<div class="lib-cat"><div class="lib-tile lg"></div><div class="lib-lb">${UI.esc(name)}</div></div>`); const tile = cat.querySelector('.lib-tile');
      const big = ids.length <= 4 ? ids : ids.slice(0, 3); big.forEach(id => tile.appendChild(appItem(id)));
      if (ids.length > 4) { const mini = UI.el('<div class="lib-mini"></div>'); ids.slice(3, 7).forEach(id => mini.appendChild(UI.el(`<div class="tile">${Icons.tile(id)}</div>`))); mini.onclick = e => { e.stopPropagation(); openCat(name, ids); }; tile.appendChild(mini); }
      tile.onclick = e => { if (e.target === tile) openCat(name, ids); }; lib.appendChild(cat);
    });
    res.appendChild(lib);
  }
  /* abrir uma categoria: lista alfabética com "Biblioteca" para voltar */
  const openCat = (name, ids) => { const res = spotRes; res.innerHTML = ''; res.scrollTop = 0; const back = UI.el(`<div class="lib-back">${g('chevL')}<span>Biblioteca</span></div>`); back.onclick = () => renderLib(''); res.appendChild(back); res.appendChild(listOf(ids.slice().sort((a, b) => App.name(a).localeCompare(App.name(b))), name)); };
  function buildSpot() {
    spot = UI.el(`<div class="spot"><div class="spot-bar"></div><div class="res"></div></div>`); el.appendChild(spot);
    spotRes = spot.querySelector('.res'); spotS = UI.search('Biblioteca de Apps', q => renderLib(q)); spotS.classList.add('lg'); const bar = spot.querySelector('.spot-bar'); bar.appendChild(spotS);
    const cancel = UI.el('<div class="spot-cancel">Cancelar</div>'); bar.appendChild(cancel); cancel.onclick = e => { e.stopPropagation(); spotS.input.value = ''; spotS.input.blur(); spot.classList.remove('searching'); renderLib(''); };
    spotS.input.addEventListener('focus', () => { spot.classList.add('searching'); if (!spotS.input.value) renderLib('', true); });   /* ao focar: todas as apps por ordem alfabética */ spotS.input.addEventListener('blur', () => { if (!spotS.input.value) spot.classList.remove('searching'); });
    /* arrastar para a direita fecha (volta à última página); o scroll vertical é da .res */
    let sp = null;
    spot.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; sp = { x: e.clientX, y: e.clientY, axis: null, lx: e.clientX, lt: Date.now(), vx: 0 }; });
    spot.addEventListener('pointermove', e => { if (!sp) return; const dx = e.clientX - sp.x, dy = e.clientY - sp.y;
      if (!sp.axis) { if (Math.hypot(dx, dy) < 10) return; sp.axis = (Math.abs(dx) > Math.abs(dy) && dx > 0) ? 'x' : 'y'; if (sp.axis === 'x') { spot.classList.add('drag'); pagesEl.classList.add('drag'); try { spot.setPointerCapture(e.pointerId); } catch (err) {} } }
      if (sp.axis !== 'x') return; const k = kz(); const off = Math.max(0, dx / k); const now = Date.now(); sp.vx = (e.clientX - sp.lx) / k / Math.max(1, now - sp.lt); sp.lx = e.clientX; sp.lt = now;
      const lx = -(page + STEP()) * geo().pw; spot.style.transform = `translateX(${off}px)`; pagesEl.style.transform = `translateX(${lx + off}px)`; par(lx + off, true); });
    const spUp = e => { if (!sp) return; const st = sp; sp = null; if (st.axis !== 'x') return; spot.classList.remove('drag'); pagesEl.classList.remove('drag'); const dx = (e.clientX - st.x) / kz(); if (dx > 70 || st.vx > .5) closeSpot(); else { const lx = -(page + STEP()) * geo().pw; spot.style.transform = ''; pagesEl.style.transform = `translateX(${lx}px)`; par(lx); } };
    spot.addEventListener('pointerup', spUp); spot.addEventListener('pointercancel', spUp);
  }
  /* as páginas saem um ECRÃ para a esquerda (uma página; abertas, as duas) e a Biblioteca ocupa o lugar delas */
  function openSpot(fromDrag) { if (!spot) return; if (!fromDrag) renderLib(''); spot.classList.remove('out', 'drag'); spot.classList.add('in'); spot.style.transform = ''; pagesEl.classList.remove('drag'); const lx = -(page + STEP()) * geo().pw; pagesEl.style.transform = `translateX(${lx}px)`; par(lx); paintDots(); dimSync(); }
  function closeSpot() { if (!spotIn()) return; try { spotS.input.blur(); } catch (e) {} spot.classList.remove('drag'); spot.style.transform = ''; spot.classList.add('out'); pagesEl.classList.remove('drag'); goPage(page); setTimeout(() => { if (spot.classList.contains('out')) { spot.classList.remove('in', 'out', 'searching'); spotS.input.value = ''; } }, 420); paintDots(); dimSync(); }
  function cancelLibDrag() { if (!spot) return; spot.classList.remove('drag'); spot.style.transform = ''; spot.classList.remove('in'); dimSync(); }
  /* camadas escuras da home a ecrã inteiro (pasta aberta, Biblioteca, pesquisa): no PearPhone Fold a pilha de estado da barra
     direita fica por cima delas e passa a branco (shell.css, #screen.hm-dim), como com o Centro de controlo */
  function dimSync() { const s = UI.screen && UI.screen(); if (!s) return;
    /* Vista Hoje à vista: a dock e a pesquisa da barra direita (PearPhone Fold, .rl-home dentro do #home) ficam por cima dela */
    const tOn = !!(tdv && (tdv.classList.contains('in') || tdv.classList.contains('drag'))); if (el && el.classList.contains('tdv-on') !== tOn) el.classList.toggle('tdv-on', tOn); const on = !!(openFolderId || (spot && spot.classList.contains('in') && !spot.classList.contains('out')) || (tdv && (tdv.classList.contains('in') || tdv.classList.contains('drag'))) || (gs && (gs.classList.contains('in') || gs.classList.contains('pulling')))); if (s.classList.contains('hm-dim') !== on) s.classList.toggle('hm-dim', on); }
  /* Nova UI: não há Biblioteca de Apps; quem pedir a "pesquisa" do sistema recebe a gaveta de apps com a pesquisa aberta */
  const spotlight = () => { if (isA()) { if (window.Drawer && Drawer.open) Drawer.open({ search: true }); return; } openSpot(false); }; const spotOpen = spotIn;

  /* ---------- VISTA HOJE: uma página SÓ DE WIDGETS à esquerda da 1.a página (os dois sistemas, telemóvel e dobráveis) ----------
     Deslizar para a direita na 1.a página traz-na pela esquerda a seguir o dedo, como no PearPhone; não conta nos pontos. É uma
     camada própria (.tdv) por cima das páginas e da dock (abaixo da Biblioteca e da pesquisa): fundo = cópia PRÉ-DESFOCADA do
     wallpaper (--wp-blur) com tinta escura a aparecer pela opacidade, e o conteúdo a entrar por transform. Em cima a pesquisa,
     depois a grelha de widgets (2 colunas; 4 no dobrável aberto) com scroll vertical. Manter premido entra na edição (tirar,
     juntar pelo seletor de widgets e mudar a ordem a arrastar; "Concluído" ou tocar no vazio sai). Deslizar para a esquerda, a pega / Início e o Voltar do Android levam de
     volta à 1.a página. A lista vive na disposição da conta (layout.today, serialize). Os nós constroem-se na primeira vez que
     é precisa e depois só se refaz um widget que mudou de tipo, tamanho, sistema ou idioma; os dados entram pelo refresh dos
     widgets (Widgets.tick / refreshType, que já procuram dentro do #home). Classes tdv-. */
  let tdv = null, tdvSc = null, tdvGrid = null, tdvBg = null, tdvNone = null, tdvEd = false, tdvPs = null, tdvSeq = 0, tdvSt = null;
  const tdvNodes = new Map();
  const tdvIn = () => !!tdv && tdv.classList.contains('in');
  const tdvOk = () => !!layout && !edit && !sel && !drag && !openFolderId && !spotIn() && !searchOpen() && !(window.System && System.foldAnimating);
  /* com a Vista Hoje aberta as páginas ficam um ECRÃ à direita (uma página; aberto, as duas) */
  const tdvLx = () => (STEP() - page) * geo().pw;
  function tdvBuild() {
    if (tdv) return;
    tdv = UI.el(`<div class="tdv"><div class="tdv-bg"></div><div class="tdv-sc"><div class="tdv-body"><div class="tdv-bar"><div class="tdv-add" role="button">${g('plus', 18)}<span></span></div><div class="tdv-done" role="button"></div></div><div class="tdv-srch" role="button">${g('search', 18)}<span></span><i>${g('mic', 18)}</i></div><div class="tdv-grid"></div><div class="tdv-none" hidden><b></b><span></span></div></div></div></div>`);
    el.appendChild(tdv);
    tdvBg = tdv.querySelector('.tdv-bg'); tdvSc = tdv.querySelector('.tdv-sc'); tdvGrid = tdv.querySelector('.tdv-grid'); tdvNone = tdv.querySelector('.tdv-none');
    tdv.querySelector('.tdv-done').textContent = L.t('Concluído'); tdv.querySelector('.tdv-srch span').textContent = L.t('Pesquisar'); tdv.querySelector('.tdv-add span').textContent = L.t('Adicionar widget');
    /* a edição não tem botão à vista (pedido do dono): entra-se a MANTER premido na página, como no PearPhone; "Adicionar widget"
       e "Concluído" só aparecem em edição */
    tdvNone.querySelector('b').textContent = L.t('Sem widgets'); tdvNone.querySelector('span').textContent = L.t('Mantém premido para adicionar widgets.');
    tdv.querySelector('.tdv-done').onclick = e => { e.stopPropagation(); Sound.play('click'); tdvEdit(false); };
    tdv.querySelector('.tdv-add').onclick = e => { e.stopPropagation(); Sound.play('click'); tdvAdd(); };
    tdv.querySelector('.tdv-srch').onclick = e => { e.stopPropagation(); if (tdvEd) return; Sound.play('click'); openSearch(); };
    tdv.addEventListener('pointerdown', tdvDown); tdv.addEventListener('pointermove', tdvMove); tdv.addEventListener('pointerup', tdvUp); tdv.addEventListener('pointercancel', tdvUp);
  }
  function tdvItem(x) {
    const def = Widgets.get(x.type) || {}, nm = def.name || x.name || 'Widget', app = def.app || x.app, sz = WSIZE[x.size] ? x.size : '2x2', h = Widgets.render(x.type, sz, { name: nm });
    const it = UI.el(`<div class="hi widget w${sz} tdv-w">${h}<div class="tdv-rm" role="button">${g('minus')}</div><div class="app-name tdv-lb"></div></div>`);
    /* legenda = a app dona (como no PearPhone); os widgets do sistema (Bateria, dona = Definições) levam o nome do widget */
    it.querySelector('.tdv-lb').textContent = app && app !== 'settings' && window.App && App.get(app) ? App.name(app) : L.t(nm);
    it.querySelector('.tdv-rm').addEventListener('click', e => { e.stopPropagation(); tdvRemove(it); });
    it._tdv = x; it._html = h; if (Widgets.hydrate) Widgets.hydrate(it); return it;
  }
  /* acerta a grelha com layout.today: os nós que já existem ficam (só mudam de sítio se a ordem mudou) */
  function tdvSync() {
    if (!tdv || !layout) return; const list = layout.today || [], keep = new Set(), ctx = ((window.System && System.os) || '') + '|' + ((window.L && L.code) || '');
    list.forEach((x, i) => { let n = tdvNodes.get(x.id); const sig = x.type + '|' + x.size + '|' + ctx + '|' + (Widgets.get(x.type) ? 1 : 0);
      if (n && n._sig !== sig) { n.remove(); n = null; }
      if (!n) { n = tdvItem(x); n._sig = sig; tdvNodes.set(x.id, n); }
      n._tdv = x; keep.add(x.id); if (tdvGrid.children[i] !== n) tdvGrid.insertBefore(n, tdvGrid.children[i] || null); });
    tdvNodes.forEach((n, id) => { if (!keep.has(id)) { n.remove(); tdvNodes.delete(id); } });
    tdvNone.hidden = list.length > 0;
  }
  /* ao abrir: um widget cujo conteúdo mudou desde o último desenho (uma nota nova, um evento) troca só o seu cartão */
  function tdvFresh() {
    tdvNodes.forEach(n => { const x = n._tdv, def = Widgets.get(x.type) || {}; let h = ''; try { h = Widgets.render(x.type, x.size, { name: def.name || x.name || 'Widget' }); } catch (e) { return; }
      if (h === n._html) return; const old = n.querySelector('.wg'), nw = UI.el(h); if (!old || !nw) return; old.replaceWith(nw); n._html = h; if (Widgets.hydrate) Widgets.hydrate(n); });
  }
  /* ⚠️ garantia do estado final (como a settleGs): sem relógio de transições (headless, CEF sem foco) a camada ficava a meio */
  const tdvSettle = () => { clearTimeout(tdvSt); tdvSt = setTimeout(() => { if (!tdv) return; [tdv, tdvBg, tdvSc].forEach(n => { const t = n.style.transition; n.style.transition = 'none'; void n.offsetWidth; n.style.transition = t; }); }, 520); };
  /* off = quanto da Vista Hoje já está à vista (0 … largura do ecrã); pg = as páginas também seguem (arrasto a partir da Vista Hoje) */
  function tdvDragTo(off, pg) {
    const w = SWp(), p = Math.max(0, Math.min(1, off / w));
    tdvBg.style.opacity = Math.min(1, p * 1.6).toFixed(3); tdvSc.style.transform = `translate3d(${(-(1 - p) * w).toFixed(1)}px,0,0)`;
    if (pg) { const lx = Math.max(0, tdvLx() - (w - off)); pagesEl.style.transform = `translateX(${lx.toFixed(1)}px)`; par(lx, true); }
  }
  function tdvDragStart() { tdvBuild(); tdvSync(); tdv.classList.remove('in'); tdv.classList.add('drag'); dimSync(); }
  /* desistir do arrasto de abrir: instant = o dedo voltou para trás do ponto de partida (some de imediato) */
  function tdvDragCancel(instant) {
    if (!tdv) return; if (instant) tdv.classList.add('tdv-now'); tdv.classList.remove('drag'); tdvBg.style.opacity = ''; tdvSc.style.transform = '';
    if (instant) { void tdv.offsetWidth; tdv.classList.remove('tdv-now'); } else tdvSettle(); dimSync();
  }
  function openTdv() {
    if (!layout) return; tdvBuild(); tdvSync(); tdvFresh(); tdv.classList.remove('drag'); tdvBg.style.opacity = ''; tdvSc.style.transform = ''; tdv.classList.add('in');
    pagesEl.classList.remove('drag'); const lx = tdvLx(); pagesEl.style.transform = `translateX(${lx}px)`; par(lx); paintDots(); tdvSettle(); dimSync();
  }
  function closeTdv(instant) {
    if (!tdv || (!tdvIn() && !tdv.classList.contains('drag'))) return; if (tdvEd) tdvEdit(false); if (tdvPs && tdvPs.re) tdvReEnd(tdvPs); tdvPs = null;
    if (instant) tdv.classList.add('tdv-now'); tdv.classList.remove('in', 'drag'); tdvBg.style.opacity = ''; tdvSc.style.transform = ''; goPage(page, instant);
    if (instant) { void tdv.offsetWidth; tdv.classList.remove('tdv-now'); } else tdvSettle(); dimSync();
  }
  function tdvEdit(on) {
    on = !!on; if (!tdv || tdvEd === on) return; tdvEd = on; tdv.classList.toggle('tdv-ed', on);
    if (on) Sound.play('pop'); else { tdvGrid.querySelectorAll('.tdv-w').forEach(n => { n.style.transition = ''; n.style.transform = ''; }); save(); }
  }
  /* juntar: o mesmo seletor de widgets do ecrã principal; o novo entra no TOPO, como no PearPhone */
  function tdvAdd() {
    if ((layout.today || []).length >= TDV_MAX) { UI.toast(L.t('Sem espaço')); return; }
    Widgets.pickerSheet(w => { if (!layout || !w || !w.id) return; const x = { id: 'tw' + Date.now().toString(36) + (++tdvSeq), type: w.id, size: WSIZE[w.size] ? w.size : '2x2' };
      if (w.name) x.name = String(w.name).slice(0, 40); if (w.app) x.app = w.app;
      layout.today.unshift(x); tdvSync(); save(); tdvSc.scrollTop = 0; tdvBorn(tdvNodes.get(x.id)); });
  }
  function tdvBorn(n) { if (!n || noMotion()) return; n.classList.remove('born'); void n.offsetWidth; n.classList.add('born'); setTimeout(() => n.classList.remove('born'), 560); }
  function tdvRemove(n) {
    const x = n._tdv; if (!x || n.classList.contains('dying')) return; Sound.play('click');
    const go = () => { const i = layout.today.indexOf(x); if (i > -1) layout.today.splice(i, 1); tdvSync(); save(); };
    if (noMotion()) { go(); return; } n.classList.add('dying'); setTimeout(go, 220);
  }
  /* ---- toques na Vista Hoje: toque abre a app do widget; manter entra na edição; em edição arrastar um widget muda a ordem;
     arrastar para a esquerda fecha (as páginas voltam com ele); na vertical é o scroll da .tdv-sc (e o DragScroll com o rato) ---- */
  function tdvDown(e) {
    if (e.button && e.pointerType === 'mouse') return; if (!tdvIn() || tdvPs) return;
    if (e.target.closest('.tdv-rm,.tdv-add,.tdv-done,.tdv-srch')) return;
    const it = e.target.closest('.tdv-w'); const s = tdvPs = { x: e.clientX, y: e.clientY, t: Date.now(), lx: e.clientX, lt: Date.now(), vx: 0, it, axis: null, held: false, re: false, timer: null };
    if (it && !tdvEd) it.classList.add('pressed');
    s.timer = setTimeout(() => { if (tdvPs !== s || s.axis) return; s.held = true; if (s.it) s.it.classList.remove('pressed'); if (!tdvEd) tdvEdit(true); }, tdvEd ? 200 : 480);
  }
  function tdvMove(e) {
    const s = tdvPs; if (!s) return; const dx = e.clientX - s.x, dy = e.clientY - s.y, k = kz();
    if (s.re) { tdvReMove(s, e); return; }
    if (!s.axis) { const dist = Math.hypot(dx, dy);
      if ((tdvEd || s.held) && s.it && dist > 6) { clearTimeout(s.timer); tdvReStart(s, e); return; }
      if (dist < 10) return; clearTimeout(s.timer); if (s.it) s.it.classList.remove('pressed');
      s.axis = (dx < 0 && Math.abs(dx) > Math.abs(dy)) ? 'x' : 'y';
      if (s.axis === 'x') { try { tdv.setPointerCapture(e.pointerId); } catch (err) {} tdv.classList.add('drag'); pagesEl.classList.add('drag'); } }
    if (s.axis !== 'x') return;
    const now = Date.now(); s.vx = (e.clientX - s.lx) / k / Math.max(1, now - s.lt); s.lx = e.clientX; s.lt = now;
    tdvDragTo(Math.max(0, SWp() + Math.min(0, dx / k)), true);
  }
  function tdvUp(e) {
    const s = tdvPs; if (!s) return; tdvPs = null; clearTimeout(s.timer); if (s.it) s.it.classList.remove('pressed');
    if (s.re) { tdvReEnd(s); return; }
    if (s.axis === 'x') { tdv.classList.remove('drag'); pagesEl.classList.remove('drag'); const dx = (e.clientX - s.x) / kz(); const fresh = Date.now() - s.lt < 90;
      if (e.type !== 'pointercancel' && (dx < -80 || (fresh && s.vx < -.5 && dx < -20))) closeTdv(); else { tdvBg.style.opacity = ''; tdvSc.style.transform = ''; const lx = tdvLx(); pagesEl.style.transform = `translateX(${lx}px)`; par(lx); tdvSettle(); } return; }
    if (s.axis || s.held || e.type === 'pointercancel') return;
    if (s.it) { if (!tdvEd) { const x = s.it._tdv; Sound.play('click'); Widgets.tap(x.type, x.app); } return; }
    if (tdvEd) tdvEdit(false);   /* tocar no vazio em edição: Concluído, como no PearPhone */
  }
  /* mudar a ordem: o widget segue o dedo (transform); por cima de outro troca de lugar com ele na lista e na grelha, e os outros
     deslizam do sítio antigo para o novo (FLIP, só transform) */
  function tdvReStart(s, e) {
    const it = s.it; if (!it || s.re) return; s.re = true; s.axis = 're'; s.k = kz(); s.last = null;
    try { tdv.setPointerCapture(e.pointerId); } catch (err) {} it.classList.remove('pressed'); it.classList.add('tdv-dragging');
    if (!tdvEd) tdvEdit(true); const r = it.getBoundingClientRect(); s.ox = s.x - r.left; s.oy = s.y - r.top; s.bx = r.left; s.by = r.top; tdvReMove(s, e);
  }
  const tdvReBase = s => { const it = s.it, tf = it.style.transform; it.style.transform = 'none'; const r = it.getBoundingClientRect(); it.style.transform = tf; s.bx = r.left; s.by = r.top; };
  function tdvReMove(s, e) {
    s.it.style.transform = `translate(${((e.clientX - s.ox - s.bx) / s.k).toFixed(1)}px,${((e.clientY - s.oy - s.by) / s.k).toFixed(1)}px)`;
    const under = [...tdvGrid.children].find(n => { if (n === s.it) return false; const r = n.getBoundingClientRect(); return e.clientX >= r.left && e.clientX <= r.right && e.clientY >= r.top && e.clientY <= r.bottom; });
    if (!under) { s.last = null; return; } if (under === s.last) return; s.last = under;
    const Lt = layout.today, a = Lt.indexOf(s.it._tdv), b = Lt.indexOf(under._tdv); if (a < 0 || b < 0) return;
    const before = new Map(); [...tdvGrid.children].forEach(n => { if (n !== s.it) before.set(n, n.getBoundingClientRect()); });
    Lt.splice(a, 1); Lt.splice(b, 0, s.it._tdv); if (a < b) under.after(s.it); else under.before(s.it);
    tdvReBase(s); s.it.style.transform = `translate(${((e.clientX - s.ox - s.bx) / s.k).toFixed(1)}px,${((e.clientY - s.oy - s.by) / s.k).toFixed(1)}px)`;
    if (noMotion()) return;
    before.forEach((r0, n) => { const r1 = n.getBoundingClientRect(), ddx = (r0.left - r1.left) / s.k, ddy = (r0.top - r1.top) / s.k; if (Math.abs(ddx) + Math.abs(ddy) < 1) return;
      n.style.transition = 'none'; n.style.transform = `translate(${ddx.toFixed(1)}px,${ddy.toFixed(1)}px)`; void n.offsetWidth; n.style.transition = 'transform .32s var(--ease)'; n.style.transform = ''; });
  }
  function tdvReEnd(s) {
    const it = s.it; s.re = false; if (!it) return; it.classList.remove('tdv-dragging');
    if (noMotion()) it.style.transform = ''; else { it.style.transition = 'transform .28s var(--ease)'; it.style.transform = ''; setTimeout(() => { if (!it.classList.contains('tdv-dragging')) it.style.transition = ''; }, 320); }
    save();
  }

  /* ---------- PESQUISA GLOBAL: puxar para baixo nas páginas (PearOS) ----------
     Uma camada própria (.gsearch) por cima das páginas e da dock: segue o dedo só com opacity/transform e abre a partir de 70 px.
     Resultados: apps, contactos (Contacts.cache), mensagens (RPC messages.search, com atraso e número de sequência para uma
     resposta velha nunca pintar por cima de uma pesquisa mais recente) e entradas das Definições. */
  const PULL_MIN_Y = 68;   /* = --statusbar-h (tokens.css): acima fica a .top-zone do gestures.js (NC à esquerda, CC à direita) */
  let gs = null, gsIn = null, gsRes = null, gsS = null, msgSeq = 0, msgT = null;
  /* acentos fora (NFD + marcas combinantes); o intervalo vai em \u - os carateres combinantes literais eram invisíveis e partiam-se com qualquer mudança de codificação */
  const norm = s => String(s == null ? '' : s).normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();
  /* entradas das Definições: [rótulo, chave de Bridge.emit('settings:goto'), ícone, cor, palavras-chave sem acentos].
     A app Definições abre a página da chave que conhecer; as outras abrem a raiz das Definições. */
  const SETTINGS_INDEX = [
    ['Modo de voo', null, 'airplane', 'var(--orange)', 'aviao voo airplane'], ['Wi-Fi', 'wifi', 'wifi', 'var(--blue)', 'wifi rede internet'], ['Bluetooth', 'bt', 'bluetooth', 'var(--blue)', 'bluetooth auriculares earbuds'],
    ['Notificações', 'notifications', 'bell', 'var(--red)', 'notificacoes avisos alertas banners'], ['Sons e háptica', 'sounds', 'speaker', 'var(--pink)', 'sons toque volume vibracao haptica'], ['Foco', 'focus', 'moon', 'var(--indigo)', 'foco nao incomodar dnd trabalho dormir'],
    ['Tempo de ecrã', 'screentime', 'hourglass', 'var(--indigo)', 'tempo ecra uso'], ['Geral', 'general', 'gear', 'var(--gray)', 'geral idioma lingua sobre armazenamento'], ['Centro de controlo', 'cc', 'sliders', 'var(--gray)', 'centro controlo atalhos'],
    ['Ecrã e brilho', 'display', 'sun', 'var(--blue)', 'ecra brilho tema escuro claro texto'], ['Cor de destaque', 'accent', 'sparkles', 'var(--blue)', 'cor destaque'], ['Ecrã bloqueado', 'lockscreen', 'lock', 'var(--gray)', 'bloqueado relogio widgets'],
    ['Ecrã principal', 'homescreen', 'grid', 'var(--indigo)', 'principal etiquetas icones disposicao'], ['Fundo', 'wallpaper', 'photo', 'var(--cyan)', 'fundo wallpaper imagem'], ['Vera', 'vera', 'sparkles', 'var(--pink)', 'vera assistente'],
    ['Face Key e código', 'passcode', 'faceid', 'var(--green)', 'face id codigo pin senha passcode'], ['Privacidade e segurança', 'privacy', 'hand', 'var(--blue)', 'privacidade permissoes localizacao camara'], ['Bateria', 'battery', 'battery', 'var(--green)', 'bateria poupanca'],
    ['Apps', 'apps', 'grid', 'var(--indigo)', 'apps aplicacoes'], ['Conta', 'account', 'personCircle', 'var(--gray)', 'conta numero sim perfil telemovel']];
  /* Nova UI: os nomes, ícones e cores das Definições do NOVA (settings.js, raiz Android e GOTO_A); a pesquisa do PearOS mostrava
     "Face Key e código" ou "Centro de controlo", que as Definições do NOVA nunca mostram */
  const SETTINGS_INDEX_A = [
    ['Ligações', 'connections', 'wifi', '#3E7BFA', 'ligacoes wifi bluetooth rede dados modo voo aviao'], ['Wi-Fi', 'wifi', 'wifi', '#3E7BFA', 'wifi rede internet'],
    ['Bluetooth', 'bt', 'bluetooth', '#3E7BFA', 'bluetooth auriculares earbuds'], ['Dispositivos ligados', 'devices', 'bluetooth', '#2A9FE3', 'dispositivos ligados partilha rapida auriculares'],
    ['Modos e rotinas', 'modes', 'moon', '#2DB36B', 'modos rotinas nao incomodar foco trabalho dormir dnd'], ['Sons e vibração', 'sounds', 'speaker', '#8A63F5', 'sons vibracao toque volume'],
    ['Notificações', 'notifications', 'bell', '#F2753A', 'notificacoes avisos alertas historico'], ['Ecrã', 'display', 'sun', '#34B467', 'ecra brilho tema escuro claro texto barra navegacao gestos'],
    ['Bateria', 'battery', 'battery', '#1FAE8C', 'bateria poupanca energia'], ['Fundo e estilo', 'wallpaper', 'photo', '#EC5A8B', 'fundo wallpaper imagem estilo paleta cores'],
    ['Ecrã principal', 'homescreen', 'grid', '#4C7CF3', 'principal etiquetas icones disposicao gaveta'], ['Ecrã bloqueado e AOD', 'lockscreen', 'lock', '#7E62F2', 'bloqueado aod always on relogio'],
    ['Segurança e privacidade', 'security', 'shield', '#3F7DF6', 'seguranca privacidade codigo pin palavra passe biometria impressao digital rosto permissoes'],
    ['Localização', 'location', 'location', '#2DAE68', 'localizacao gps'], ['Funcionalidades avançadas', 'advanced', 'star', '#F28A1E', 'avancadas tecla lateral paineis edge'],
    ['Bem-estar digital', 'wellbeing', 'hourglass', '#26A97A', 'bem estar tempo ecra uso'], ['Aplicações', 'apps', 'grid', '#4C86F5', 'aplicacoes apps'],
    ['Vera', 'vera', 'sparkles', '#3FB2E6', 'vera assistente'], ['Gestão geral', 'general', 'sliders', '#7D8794', 'gestao geral idioma lingua teclado data hora'],
    ['Acessibilidade', 'accessibility', 'personCircle', '#2B9FBF', 'acessibilidade texto movimento'], ['Atualização de software', 'update', 'update', '#7A5CF0', 'atualizacao software sistema versao'],
    ['Acerca do telefone', 'about', 'info', '#8A9099', 'acerca telefone modelo nome sobre numero serie imei'], ['Painel rápido', 'cc', 'sliders', '#7D8794', 'painel rapido atalhos mosaicos'],
    ['Conta', 'account', 'personCircle', '#8A9099', 'conta numero sim perfil telemovel']];
  function openSettings(key, lv = leave) { lv(); System.openApp('settings'); if (key) setTimeout(() => Bridge.emit('settings:goto', key), 350); }
  /* opts.onLeave: quem usa o motor de fora (gaveta de apps Nova UI) diz o que fechar antes de abrir o resultado; opts.grid: as apps
     saem em grelha de ícones (Nova UI) em vez de lista. Sem estas opções o resultado é o de sempre (pesquisa e Biblioteca do PearOS). */
  const appGrid = (ids, header, lv) => { const box = UI.el(`<div class="ah-sgrp"><div class="ah-sh"></div><div class="ah-sapps"></div></div>`); box.firstElementChild.textContent = header; const grid = box.lastElementChild;
    ids.forEach(id => { const a = UI.el(`<div class="ah-sapp" data-id="${UI.esc(id)}">${Icons.tileBox(id)}<span></span></div>`); a.lastElementChild.textContent = App.name(id); a.onclick = e => { e.stopPropagation(); const t = a.querySelector('.tile'); System.openApp(id, t); lv(); }; grid.appendChild(a); }); return box; };
  function searchInto(res, q, opts = {}) {
    if (!res) return; clearTimeout(msgT); const seq = ++msgSeq; res.innerHTML = ''; res.scrollTop = 0;
    const lv = typeof opts.onLeave === 'function' ? opts.onLeave : leave;
    const nq = norm(q).trim(); const inst = System.installed().filter(id => !(App.get(id) || {}).hidden);
    if (!nq) {
      if (!opts.suggest) return;
      if (opts.grid) { const rec = recentList().filter(id => inst.includes(id)).slice(0, 10); if (rec.length) res.appendChild(appGrid(rec, L.t('Apps recentes'), lv)); res.appendChild(UI.el(`<div class="ah-shint">${UI.esc(L.t('Pesquisa apps, contactos, mensagens e definições'))}</div>`)); return; }
      let rec = recentList().filter(id => inst.includes(id)).slice(0, 8);
      /* PearPhone Fold (Duo, spec_duo 3.6): a lista de apps aparece logo, mesmo sem recentes (sessão nova): as instaladas completam
         as sugestões até 8, e sem a frase de ajuda por baixo (as oito linhas enchem o ecrã e ela ficava cortada no fundo). Os
         telemóveis de barra ficam como estavam */
      const fold = System.form === 'fold';
      if (fold && rec.length < 8) rec = rec.concat(inst.filter(id => !rec.includes(id))).slice(0, 8);
      if (rec.length) { const box = UI.el(`<div class="gs-sect"><div class="group-header">${UI.esc(L.t('Sugestões de apps'))}</div><div class="gs-apps"></div></div>`); const grid = box.querySelector('.gs-apps');
        rec.forEach(id => { const a = UI.el(`<div class="gs-app"><div class="tile">${Icons.tile(id)}</div><span>${UI.esc(App.name(id))}</span></div>`); a.onclick = e => { e.stopPropagation(); leave(); System.openApp(id); }; grid.appendChild(a); }); res.appendChild(box); }
      if (!fold || !rec.length) res.appendChild(UI.el(`<div class="lib-empty gs-hint">${UI.esc(L.t('Pesquisa apps, contactos, mensagens e definições'))}</div>`));
      return; }
    /* PearOS 27 "Pesquisar ou perguntar": a primeira linha manda a frase à Vera (só com a assistente ligada) */
    const askVera = !!(window.Vera && System.state.vera && String(q || '').trim().length >= 2);
    if (askVera) { const ask = UI.el(`<div class="gs-ask lg"><div class="gs-ask-orb"></div><div class="gs-ask-t"><b>${UI.esc(L.t('Perguntar à Vera'))}</b><span>${UI.esc(String(q).trim().slice(0, 80))}</span></div>${Icons.g('chevR', 20)}</div>`);
      ask.onclick = e => { e.stopPropagation(); const text = String(q).trim().slice(0, 140); lv(); setTimeout(() => { try { Vera.open({ ask: text }); } catch (err) {} }, 120); }; res.appendChild(ask); }
    /* apps: primeiro as que COMEÇAM pelo texto, depois as que o contêm */
    const apps = inst.filter(id => norm(App.name(id)).includes(nq)).sort((a, b) => (norm(App.name(b)).startsWith(nq) - norm(App.name(a)).startsWith(nq)) || App.name(a).localeCompare(App.name(b)));
    if (apps.length) res.appendChild(opts.grid ? appGrid(apps.slice(0, 15), L.t('Apps'), lv) : listOf(apps.slice(0, 12), L.t('Apps'), lv));
    const cs = (window.Contacts && Contacts.cache || []).filter(c => c && (norm(c.name).includes(nq) || String(c.number || '').includes(nq))).slice(0, 5);
    if (cs.length) res.appendChild(UI.list([{ header: L.t('Contactos'), items: cs.map(c => ({ avatar: c, label: c.name, sub: c.number, chevron: false, onTap: () => { lv(); if (window.PhoneApp) PhoneApp.call(c.number, c.name); } })) }]));
    const msgBox = UI.el('<div class="gs-msgs"></div>'); res.appendChild(msgBox);
    const IDX = System.os === 'android' ? SETTINGS_INDEX_A : SETTINGS_INDEX;
    const sets = IDX.filter(s => norm(L.t(s[0])).includes(nq) || norm(s[0]).includes(nq) || s[4].includes(nq)).slice(0, 6);
    if (sets.length) res.appendChild(UI.list([{ header: L.t('Definições'), items: sets.map(s => ({ icon: (window.Icons && Icons.has && !Icons.has(s[2])) ? 'gear' : s[2], iconBg: s[3], label: L.t(s[0]), chevron: true, onTap: () => openSettings(s[1], lv) })) }]));
    let empty = null; if (!apps.length && !cs.length && !sets.length && !askVera) { empty = UI.el(`<div class="lib-empty">${UI.esc(L.t('Sem resultados'))}</div>`); res.appendChild(empty); }
    /* mensagens: pedido ao servidor 260 ms depois da última tecla (e só com 2+ letras); a resposta só pinta se ainda for a pesquisa atual */
    if (nq.length >= 2) msgT = setTimeout(async () => {
      let r = null; try { r = await Bridge.rpc('messages.search', { q: String(q).trim().slice(0, 60) }); } catch (e) { r = null; }
      if (seq !== msgSeq || !msgBox.isConnected) return; const rows = Array.isArray(r) ? r.slice(0, 20) : []; if (!rows.length) return;
      if (empty && empty.isConnected) empty.remove();
      msgBox.appendChild(UI.list([{ header: L.t('Mensagens'), items: rows.map(m => { const num = String((m && m.number) || ''); const c = window.Contacts && Contacts.byNumber ? Contacts.byNumber(num) : null; const nm = (c && c.name) || num;
        return { avatar: c || { name: nm }, label: nm, sub: String((m && m.content) || '').slice(0, 90), chevron: false, onTap: () => { lv(); if (window.Msgs && Msgs.open) Msgs.open(num, nm); else System.openApp('messages'); } }; }) }]));
    }, 260);
  }
  const searchOpen = () => !!gs && gs.classList.contains('in');
  function buildSearch() {
    gs = UI.el('<div class="gsearch"><div class="gs-in"><div class="gs-bar"></div><div class="gs-res"></div></div></div>'); el.appendChild(gs);
    gsIn = gs.firstElementChild; gsRes = gs.querySelector('.gs-res');
    /* PearOS 27: a Spotlight passou a "Pesquisar ou perguntar" - a mesma caixa pesquisa e fala com a Vera */
    gsS = UI.search(L.t(System.state.vera && window.Vera ? 'Pesquisar ou perguntar' : 'Pesquisar'), q => searchInto(gsRes, q, { suggest: true })); gsS.classList.add('lg'); const bar = gs.querySelector('.gs-bar'); bar.appendChild(gsS);
    const cancel = UI.el(`<div class="gs-cancel">${UI.esc(L.t('Cancelar'))}</div>`); bar.appendChild(cancel); cancel.onclick = e => { e.stopPropagation(); closeSearch(); };
    /* tocar no vazio (sem texto escrito) fecha, como no PearPhone */
    gs.addEventListener('click', e => { if ((e.target === gs || e.target === gsIn || e.target === gsRes) && !gsS.input.value) closeSearch(); });
  }
  function startPull() { if (!gs) return; gs.classList.add('pulling'); gs.style.opacity = '0'; gsIn.style.transform = 'translateY(-40px)'; if (!gsS.input.value) searchInto(gsRes, '', { suggest: true }); dimSync(); }
  function followPull(d) { if (!gs) return; const p = Math.min(1, d / 140); gs.style.opacity = p.toFixed(3); gsIn.style.transform = `translateY(${(-40 + 40 * p).toFixed(1)}px)`; pagesEl.style.opacity = (1 - p * .7).toFixed(3); }
  function cancelPull() { if (!gs) return; gs.classList.remove('pulling'); gs.style.opacity = ''; gsIn.style.transform = ''; pagesEl.style.opacity = ''; settleGs(); dimSync(); }
  /* ⚠️ garantia do estado FINAL (o mesmo truque da LockGallery.settle): se o relógio das transições não avançar (headless; CEF com a
     página sem foco) a camada ficava presa a meio - invisível depois de abrir ou por cima de tudo depois de fechar. Passada a duração,
     cortar a transição impõe o valor final; numa transição que já acabou não faz nada. */
  const settleGs = () => { clearTimeout(gs._st); gs._st = setTimeout(() => { [gs, gsIn].forEach(n => { const t = n.style.transition; n.style.transition = 'none'; void n.offsetWidth; n.style.transition = t; }); }, 480); };
  function openSearch() { if (isA()) { if (window.Drawer && Drawer.open && !System.locked) Drawer.open({ search: true }); return; }   /* Nova UI: a pesquisa vive na gaveta de apps */
    if (!gs || edit || System.locked) { cancelPull(); return; }   /* bloqueou a meio do puxar (lock() fecha a camada): o soltar já não a reabre por baixo do ecrã bloqueado */ closeFolder(); gs.classList.remove('pulling'); gs.style.opacity = ''; gsIn.style.transform = ''; pagesEl.style.opacity = ''; gs.classList.add('in'); el.classList.add('gs-on');
    if (!gsS.input.value) searchInto(gsRes, '', { suggest: true }); Sound.play('pop'); settleGs(); dimSync();
    setTimeout(() => { if (searchOpen()) { try { gsS.input.focus(); } catch (e) {} } }, 280); }
  function closeSearch(instant) { if (!gs || (!searchOpen() && !gs.classList.contains('pulling'))) return; clearTimeout(msgT); msgSeq++;
    try { gsS.input.blur(); } catch (e) {} try { if (window.Keyboard && Keyboard.hide) Keyboard.hide(); } catch (e) {}
    gs.classList.remove('in', 'pulling'); gs.style.opacity = ''; gsIn.style.transform = ''; pagesEl.style.opacity = ''; el.classList.remove('gs-on');
    if (instant) gs.classList.add('gs-instant'); settleGs(); dimSync();
    setTimeout(() => { gs.classList.remove('gs-instant'); if (!searchOpen()) { gsS.input.value = ''; gsS.classList.remove('has'); gsRes.innerHTML = ''; } }, 320); }

  /* ---------- Nova UI: puxar para BAIXO nas páginas abre o painel de notificações a seguir o dedo ----------
     O painel é do QuickPanel (android-panel.js): recebe o progresso 0..1 e, ao largar, se abre ou não. Sem o QuickPanel (ou sem o
     pull*), o largar com distância abre o centro de notificações de sempre (Notify.openNC, que no Android delega no painel). */
  const QP_D = 320;
  const qpOk = () => !!(window.QuickPanel && QuickPanel.pullStart && QuickPanel.pullMove && QuickPanel.pullEnd);
  function qpStart() { if (qpOk()) { try { QuickPanel.pullStart('notif'); } catch (e) { console.error('[apex_phone] QuickPanel.pullStart', e); } } }
  function qpMove(d) { if (qpOk()) { try { QuickPanel.pullMove('notif', Math.max(0, Math.min(1, d / QP_D))); } catch (e) {} } }
  function qpEnd(open) { if (qpOk()) { try { QuickPanel.pullEnd('notif', !!open); } catch (e) {} return; } if (open && window.Notify && Notify.openNC) { try { Notify.openNC(); } catch (e) {} } }

  /* ---------- Voltar do Android (SysUI.back): fecha a camada de cima da home e diz se gastou o toque ---------- */
  function back() {
    if (drag) { endDrag(null); return true; }
    if (ahm) { closeAhMenu(); return true; }
    if (sel) { exitSelect(); return true; }
    if (openFolderId) { closeFolder(); return true; }
    if (edit) { exitEdit(); return true; }
    if (searchOpen()) { closeSearch(); return true; }
    if (tdvEd) { tdvEdit(false); return true; }   /* Vista Hoje: primeiro sai da edição, depois volta à 1.a página */
    if (tdvIn()) { closeTdv(); return true; }
    return false;
  }
  /* Início do Android (SysUI.home): larga TUDO o que é passageiro na home de uma vez (a Vista Hoje volta à 1.a página) */
  function reset() { if (drag) endDrag(null); closeAhMenu(true); exitSelect(); hideZones(); closeFolder(); if (edit) exitEdit(); if (searchOpen()) closeSearch(true); closeTdv(); }

  /* ---------- init ---------- */
  function init() {
    el = document.getElementById('home');
    /* .pgv = janela das páginas: no telemóvel não muda nada (ocupa o #home); no PearPhone Fold acaba na barra direita e corta o que
       passa por baixo dela (a página seguinte nunca espreita por trás da barra). .ah-fs = pílula de pesquisa do NOVA dobrável */
    el.innerHTML = `<div class="pgv"><div class="pages"></div></div><div class="edit-bar"><div class="addw lg lg-wp lg-tone">${g('plus')} Editar</div><div class="done lg lg-wp">Concluído</div></div><div class="page-dots"></div>
      <div class="search-pill"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4" stroke-linecap="round"/></svg>Pesquisa</div><div class="ah-fs" role="button"><span class="ah-fs-i">${g('search', 21)}</span><span class="ah-fs-t"></span><span class="ah-fs-m">${g('mic', 21)}</span></div><div class="dock lg lg-wp lg-tone"></div><div class="folder-overlay"></div>`;
    pagesEl = el.querySelector('.pages'); dotsEl = el.querySelector('.page-dots'); dockEl = el.querySelector('.dock'); editBar = el.querySelector('.edit-bar'); folderOv = el.querySelector('.folder-overlay');
    fsEl = el.querySelector('.ah-fs'); fsEl.querySelector('.ah-fs-t').textContent = L.t('Pesquisar');
    fsEl.addEventListener('click', e => { e.stopPropagation(); if (!isA() || edit || sel) return; Sound.play('click'); if (window.Drawer && Drawer.open) Drawer.open({ search: true }); });
    buildSpot();   /* a Biblioteca de Apps existe sempre, à direita da última página */
    buildSearch(); /* pesquisa global (puxar para baixo nas páginas) */
    /* PearPhone Fold: a dock da home passa para a BARRA DIREITA (o Rail adota este mesmo elemento e devolve-o quando deixa de haver
       barra) e o botão redondo de pesquisa abre a Spotlight. Nos outros aparelhos o Rail guarda o pedido e não desenha nada */
    if (window.Rail && Rail.setHome) { try { Rail.setHome({ dock: dockEl, onSearch: () => { if (!edit) openSearch(); } }); } catch (e) { console.error('[apex_phone] Rail.setHome', e); } }
    /* dobrável: abrir ou fechar muda a geometria. Abrir na página k põe k à ESQUERDA e k + 1 à direita (se k for a última, a
       penúltima fica à esquerda para não haver uma metade vazia); fechar sem ter mudado de par volta à página k */
    let fm = null;
    Bridge.on('fold:state', d => { if (!layout) return; if (drag) endDrag(null); closeAhMenu(true);
      const open = !!(d && d.open) && isFold(), n = layout.pages.length;
      if (open) { const s = Math.max(0, Math.min(page, n - 2)); fm = { k: page, s }; page = s; }
      else { if (fm && page === fm.s) page = fm.k; fm = null; }
      relayout(); keepOverlays(); });
    Bridge.on('form:changed', () => { fm = null; if (drag) endDrag(null); });
    /* recentes gravados: cada app aberta vai para o topo de System.state.recentApps (máx. 12). O System.openApp já o faz (Fase 1) e aí
       isto sai logo (cur[0] === id); fica como rede para um system.js que não o faça. noSave: não se manda a conta inteira ao servidor
       a cada app aberta - fica no localStorage já, e segue para a conta no próximo gravar normal das definições */
    Bridge.on('app:open', id => { closeSearch(true);   /* uma app aberta por fora (notificação, deep link, Vera) não deixa a pesquisa aberta por baixo, à espera do regresso à home */
      if (typeof id !== 'string' || !App.get(id)) return; const cur = Array.isArray(System.state.recentApps) ? System.state.recentApps : []; if (cur[0] === id) return;
      System.setState({ recentApps: [id, ...cur.filter(x => x !== id && typeof x === 'string')].slice(0, 12) }, { noApply: true, noSave: true }); });
    el.querySelector('.done').onclick = exitEdit; el.querySelector('.addw').onclick = editMenu; el.querySelector('.search-pill').onclick = spotlight;
    Bridge.on('icons:restyled', d => { if (d && d.final) restyleInline(); });
    bindContainer(pagesEl); bindContainer(dockEl);
    /* várias mudanças seguidas (arranque, registos em série) → um só re-render da home, 60 ms depois da última */
    /* a meio de um arrasto espera pelo fim (refazer a home por baixo do dedo perdia a pré-visualização) */
    Bridge.on('apps:changed', (() => { let t = null; const run = () => { if (!layout) return; if (drag) { t = setTimeout(run, 400); return; } reconcile(); render(true); }; return () => { if (!layout) return; clearTimeout(t); t = setTimeout(run, 60); }; })());
    /* Nova UI: as camadas passageiras da home (menu de um ícone, seleção, zonas de arrasto, edição) não sobrevivem a guardar o
       telemóvel, a bloquear nem à troca de sistema (o setOS volta a desenhar a home a seguir a este evento) */
    const tidy = () => { closeAhMenu(true); exitSelect(); hideZones(); };
    Bridge.on('os:changed', () => { tidy(); if (drag) endDrag(null); if (edit) exitEdit(); closeTdv(true);
      /* o sistema definitivo chegou depois da conta (ready do Lua): uma disposição de origem do outro sistema, nunca tocada, refaz-se já */
      try { if (osSync()) render(true); } catch (e) { console.error('[apex_phone] osSync (os)', e); } });
    /* Vista Hoje: trocar de aparelho volta à 1.a página; guardar ou bloquear só sai da edição (a página fica, como no PearPhone) */
    Bridge.on('form:changed', () => closeTdv(true)); Bridge.on('phone:close', () => tdvEdit(false)); Bridge.on('lock', () => tdvEdit(false));
    Bridge.on('phone:close', tidy); Bridge.on('lock', tidy); Bridge.on('app:open', () => { closeAhMenu(true); exitSelect(); });
  }
  return { init, load, render, layout: () => layout, serialize, addApp, removeApp, enterEdit, exitEdit, openCustomize, restyleInline, openFolder, closeFolder, folderOpen: () => !!openFolderId, spotlight, closeSpot, spotOpen, openSearch, closeSearch, searchOpen, resizeWidget, libCategory: libCat, shareApp, badges,
    /* para fora (pega, Início do Android, Vera...): ir para uma página fecha também a Vista Hoje */
    goPage: (p, instant) => { if (tdvIn()) closeTdv(instant); goPage(p, instant); },
    /* Vista Hoje (página só de widgets à esquerda da 1.a): abrir / fechar / aberta / em edição */
    openToday: () => { if (!tdvIn() && tdvOk()) { goPage(0, true); openTdv(); } }, closeToday: closeTdv, todayOpen: tdvIn, get todayEditing() { return tdvEd; }, todayEdit: on => { if (tdvIn()) tdvEdit(on); },
    get page() { return page; }, get edit() { return edit; }, _drag: () => drag /* depuração (harness) */,
    /* dobráveis: páginas à vista (uma, ou a da esquerda e a da direita) e as medidas da grelha (cópia, só leitura) */
    get view() { return viewPages(); }, geo: () => Object.assign({}, geo()), relayout,
    /* Nova UI (Android): gaveta de apps, painel Edge e SysUI usam estes */
    back, reset, searchInto, ahMenu, closeAhMenu, menuOpen: () => !!ahm, appInfo, askUninstall, openSettings: key => openSettings(key, () => {}), dragIn, dragMove, dragEnd, isOnHome: id => !!(layout && findApp(id)),
    enterSelect, exitSelect, get selecting() { return !!sel; } };
})();
