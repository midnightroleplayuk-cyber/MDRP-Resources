/* ============================================================
   NOTIFY - gestor de notificações (PearOS 17): banners, Notification
   Center, lock screen (stacks), swipe (Opções/Limpar), long press
   (cartão expandido), silenciar por app, histórico, sons,
   definições por app e histórico do servidor
   ============================================================ */
/* API: Notify.push({ app, title, msg | description, data, onTap, actions, icon, image, duration, type, id, silent, critical, quiet, force, sound })
   - description: sinónimo de msg (contrato 5.4); se vierem os dois ganha msg.
   - icon: id de uma app → ícone dessa app; URL (http/nui/data:image ou ficheiro .png/.jpg/…) → imagem, sempre por CSSOM.
   - image: miniatura no cartão e imagem grande no cartão expandido (CSSOM). URLs até 2048 caracteres ficam guardadas;
     data URLs maiores (base64) só vivem em memória - 100 notificações com fotografias rebentavam o localStorage.
   - duration: tempo do banner e da ilha, em ms (1500..15000; por omissão 5000 no banner e 2600 na ilha).
   - Gestos do banner (PearOS): tocar abre a app · puxar para cima dispensa · puxar PARA BAIXO ou manter
     premido abre o cartão expandido (o mesmo do long press no Centro, com as ações e o "Limpar").
   - actions: [{ label, onTap }] (JS, só em runtime) ou [{ id, label }] (servidor, serializáveis e guardadas).
     Tocar numa ação do servidor → Bridge.rpc('notifs.action', { id, action }) e Bridge.emit('notif:action', { id, sid, app, action, data }).
   - type: 'banner' (omissão) · 'silent' (entra só nas listas, sem som, banner, ilha nem espreitar) ·
     'island' (prefere a ilha mesmo com "Mostrar na Dynamic Island" desligado; ocupada → banner) · 'lock' (ecrã bloqueado e centro, nunca banner).
   - id: id do servidor (apex_phone_notifications), guardado como `sid`. Tocar → notifs.open; lida → notifs.read;
     apagar → notifs.remove; limpar pelo utilizador → notifs.clear. O mesmo id nunca dá dois cartões.
   - ações automáticas a partir de data: { number } (phone → "Ligar", messages → "Responder"), { coords:{x,y} } → "Navegar".
   - Definições por app: System.state.notifApps[app] = { allow, sound, badge, lock, banner, preview: 'always'|'unlocked'|'never' }
     (Notify.appSettings / Notify.setAppSettings). O antigo System.state.notif[app] === false continua a valer allow:false.
     System.state.notifAll === false desliga tudo menos as críticas e as do Telefone.
   - Histórico do servidor: ao iniciar e em cada push "session" pede notifs.list e junta ao local sem duplicar.
     As linhas do histórico e as entregues ao entrar trazem actions/type/duration gravados no servidor e passam pelo
     mesmo build() de um push: mostram os mesmos botões (o notifs.action só aceita uma dessas ações).
   - Store: 'notifs' (lista, máx. 100), 'notifMute' ({ app: timestampAté }) - silenciadas ficam guardadas mas sem banner/som. */
window.Notify = (() => {
  const g = UI.g; const handlers = {}, acts = {}, media = {};
  /* um valor estragado no localStorage (não-array) rebentava todos os .find/.filter do centro */
  const all = () => { const l = Store.get('notifs', []); return Array.isArray(l) ? l : []; };
  /* Android (Nova UI, 2026-10-01): a barra de estado desenha os icones das notificacoes e o painel rapido redesenha a
     lista no sitio. Os dois ouvem o Bridge 'notify:changed', emitido sempre que a lista gravada muda (chegou, leu,
     removeu, limpou, juntou o historico do servidor, trocou de personagem). Agrupado num so aviso por volta do ciclo:
     a entrega de 50 pendentes nao dispara 50 repinturas. */
  let chT = 0;
  function emitChanged() {
    if (chT) return;
    chT = setTimeout(() => {
      chT = 0; const l = all(), apps = [], unreadApps = [];
      l.forEach(n => { if (!apps.includes(n.app)) apps.push(n.app); if (!n.read && !unreadApps.includes(n.app)) unreadApps.push(n.app); });
      try { Bridge.emit('notify:changed', { total: l.length, unread: l.filter(n => !n.read).length, apps, unreadApps }); } catch (e) {}
    }, 0);
  }
  const set = l => { Store.set('notifs', l); emitChanged(); };
  const android = () => !!(window.System && System.isAndroid && System.isAndroid());
  const mutes = () => Store.get('notifMute', {}) || {};
  const PW = 440, OPEN = 172, GAP = 8, MAX = 100;
  const k = () => UI.zoom();   /* em cache (ui.js): sem layout forçado em cada pointermove */
  let nc, list, head, openCard = null, armed = null, armT = null, overlay = null, banner = null, toastT = null;
  const expanded = new Set(); /* stacks abertos no lock screen (ids de app) */
  const ncExp = new Set();    /* PearOS 27: pilhas abertas no centro de notificações (fecham ao fechar o centro) */
  /* ECRÃ BLOQUEADO COMO NO iOS 16+ (pedido 2026-09-19, com as capturas do iPhone): as notificações vivem em BAIXO, por cima
     dos atalhos, e "Mostrar como" (Definições › Notificações) escolhe entre:
       count - só uma cápsula "3 notificações"; tocar abre a lista
       stack - UMA pilha: a mais recente por cima, as outras espreitam por trás; tocar abre a lista (por app, cada app
               também em pilha com "Mostrar menos"); tocar no fundo de ecrã ou puxar para baixo volta a fechar
       list  - a lista sempre aberta, agrupada por app (cada app em pilha)
     (a versão de 2026-09-08 tinha as pilhas desligadas - o utilizador mudou de ideias ao ver o iPhone) */
  const MODES = ['count', 'stack', 'list'];
  const mode = () => { const m = window.System && System.state && System.state.notifDisplay; return MODES.includes(m) ? m : 'stack'; };
  let lockOpen = false;   /* pilha/contagem aberta em lista (fecha ao bloquear/desbloquear ou ao tocar fora) */
  const gone = new Set();    /* ids do servidor apagados nesta sessão: um notifs.list que já vinha a caminho não os ressuscita */
  let lastId = 0, lastCid = null, syncSeq = 0, lockT = null, changedAt = 0;

  /* ---------- utilitários ---------- */
  const clip = (v, n) => String(v == null ? '' : v).slice(0, n);
  /* ids locais únicos mesmo com várias notificações no mesmo milissegundo (o harness empurra 103 seguidas) */
  const newId = () => { const t = Date.now() + Math.floor(Math.random() * 1000); lastId = t > lastId ? t : lastId + 1; return lastId; };
  const sidOf = v => { if (typeof v !== 'number' && !(typeof v === 'string' && /^\d{1,15}$/.test(v))) return null; const x = Number(v); return Number.isInteger(x) && x > 0 ? x : null; };
  const isUrl = s => typeof s === 'string' && (/^(https?:\/\/|nui:\/\/|data:image\/)/i.test(s) || /^[\w./-]+\.(png|jpe?g|webp|gif|svg)(\?.*)?$/i.test(s));
  /* iconHtml (API antiga) vai para innerHTML, e os pushes do Lua e o RKPhone.notify chegam a esta mesma função.
     A lista negra por regex que aqui estava deixava passar `<svg><image/onerror=…>` (o "/" não é espaço) e
     `javascript&colon;`. Agora o SVG é interpretado num <template> (documento inerte: nada carrega nem corre) e só
     ficam elementos e atributos de desenho. Em cache: o render volta a filtrar o `ext` das notificações já gravadas. */
  const SVG_OK = new Set(['svg', 'g', 'path', 'circle', 'ellipse', 'rect', 'line', 'polyline', 'polygon', 'defs', 'lineargradient', 'radialgradient', 'stop', 'clippath', 'mask', 'pattern', 'symbol', 'use', 'image', 'text', 'tspan',
    'filter', 'fegaussianblur', 'feoffset', 'feflood', 'fecomposite', 'femerge', 'femergenode', 'fecolormatrix', 'feblend', 'femorphology', 'fedropshadow']);
  const svgCache = new Map();
  function safeSvg(h) {
    if (typeof h !== 'string' || h.length > 60000 || !/^\s*<svg[\s>]/i.test(h)) return null;
    if (svgCache.has(h)) return svgCache.get(h);
    let out = null;
    try {
      const t = document.createElement('template'); t.innerHTML = h;
      const root = t.content.firstElementChild;
      if (root && root.localName === 'svg' && t.content.children.length === 1) {
        root.querySelectorAll('*').forEach(e => { if (!SVG_OK.has(e.localName.toLowerCase())) e.remove(); });
        [root, ...root.querySelectorAll('*')].forEach(e => [...e.attributes].forEach(a => {
          const nm = a.name.toLowerCase(), v = a.value.replace(/[\u0000-\u0020]+/g, '').toLowerCase();
          const link = nm === 'href' || nm === 'xlink:href' || nm === 'src';
          if (nm.startsWith('on') || /javascript:|vbscript:|data:text/.test(v) || (nm === 'style' && /url\(|expression|@import/.test(v))
            || (link && !/^(#|https?:|nui:|data:image\/(png|jpe?g|webp|gif);)/.test(v))) e.removeAttribute(a.name);
        }));
        out = root.outerHTML;
      }
    } catch (e) { out = null; }
    if (svgCache.size > 60) svgCache.clear();
    svgCache.set(h, out); return out;
  }
  const find = id => all().find(x => x.id === id) || null;
  /* RPC ao servidor sem nunca rebentar a UI: no browser o LocalDB responde { error } a RPCs que não conhece */
  const srv = (name, d) => { try { return Promise.resolve(Bridge.rpc(name, d)).catch(() => null); } catch (e) { return Promise.resolve(null); } };

  /* ---------- definições por app ---------- */
  const NDEF = { allow: true, sound: true, badge: true, lock: true, banner: true, preview: 'always' };
  const PREVIEWS = ['always', 'unlocked', 'never'];
  function appSettings(app) {
    const s = (window.System && System.state) || {}, na = s.notifApps && typeof s.notifApps === 'object' ? s.notifApps : null;
    const raw = na && na[app] && typeof na[app] === 'object' ? na[app] : null, o = Object.assign({}, NDEF);
    if (raw) { ['allow', 'sound', 'badge', 'lock', 'banner'].forEach(x => { if (typeof raw[x] === 'boolean') o[x] = raw[x]; }); if (PREVIEWS.includes(raw.preview)) o.preview = raw.preview; }
    /* compatibilidade: o antigo notif[app] === false vale allow:false - a não ser que as definições novas digam allow explicitamente */
    if (!(raw && typeof raw.allow === 'boolean') && s.notif && s.notif[app] === false) o.allow = false;
    return o;
  }
  function setAppSettings(app, patch) {
    if (!app || !patch || typeof patch !== 'object') return appSettings(app);
    const s = System.state, cur = Object.assign({}, (s.notifApps && s.notifApps[app]) || {});
    ['allow', 'sound', 'badge', 'lock', 'banner'].forEach(x => { if (typeof patch[x] === 'boolean') cur[x] = patch[x]; });
    if (PREVIEWS.includes(patch.preview)) cur.preview = patch.preview;
    const up = { notifApps: Object.assign({}, s.notifApps || {}, { [app]: cur }) };
    /* a chave antiga acompanha o allow, para quem ainda a lê (Definições antigas) não mostrar o contrário */
    if (typeof patch.allow === 'boolean') { const old = Object.assign({}, s.notif || {}); if (patch.allow) delete old[app]; else old[app] = false; up.notif = old; }
    System.setState(up);
    return appSettings(app);
  }
  /* entra no telemóvel? allow da app e o interruptor geral (este deixa passar críticas e o Telefone) */
  function allowed(app, o) {
    if (!appSettings(app).allow) return false;
    const s = System.state || {};
    if (s.notifAll === false && !(o && o.critical) && app !== 'phone') return false;
    return true;
  }
  /* pré-visualização: 'never' esconde sempre; 'unlocked' esconde com o telemóvel bloqueado */
  function preview(n) {
    const p = appSettings(n.app).preview;
    if (p === 'never' || (p === 'unlocked' && System.locked)) return { title: 'Notificação', msg: '', image: null, hidden: true };
    return { title: trTitle(n), msg: trMsg(n), image: imageOf(n), hidden: false };
  }
  /* Os avisos do sistema chegam com o texto de ORIGEM (portugues: servidor, assistente, apps) e o cartao nao passa pelo
     tradutor do DOM (tem nomes e mensagens de pessoas). Traduz-se aqui, ao mostrar, com o dicionario (frases fixas e com
     %s): o titulo das apps de conversa e o NOME de quem fala e o texto das mensagens e de quem as escreveu - esses ficam
     iguais. Sem traducao no dicionario o texto volta tal como veio. */
  const NAME_TITLE_APPS = new Set(['messages', 'recado', 'phone', 'facetime', 'match', 'darkchat']);
  const USER_MSG_APPS = new Set(['messages', 'recado', 'match', 'darkchat']);
  const trTxt = s => (s && window.I18N && I18N.t) ? I18N.t(s) : s;
  const trTitle = n => NAME_TITLE_APPS.has(n.app) ? n.title : trTxt(n.title);
  const trMsg = n => USER_MSG_APPS.has(n.app) ? n.msg : trTxt(n.msg);
  const iconOf = n => n.icon || (media[n.id] && media[n.id].icon) || null;
  const imageOf = n => n.image || (media[n.id] && media[n.id].image) || null;

  /* ---------- silenciar ---------- */
  const isMuted = app => { const m = mutes(); return !!(m[app] && m[app] > Date.now()); };
  function mute(app, until) { const m = Object.assign({}, mutes()); if (until) m[app] = until; else delete m[app]; Store.set('notifMute', m); }

  /* ---------- dados ---------- */
  /* ações: as que trazem onTap ficam só em runtime; as { id, label } (servidor) são guardadas com a notificação */
  function splitActions(v) {
    const run = [], ser = []; const arr = Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []);   /* o Lua pode mandar {"1":…} */
    /* máx. 3 e id até 32 caracteres, como no servidor (buildNotification / notifs.action) e no contracts.js:
       um id mais comprido chegava cortado ao apex_phone:notificationAction e não batia com o que o resource declarou */
    arr.slice(0, 3).forEach(a => {
      if (!a || typeof a !== 'object') return; const label = clip(a.label, 40); if (!label) return;
      if (typeof a.onTap === 'function') run.push({ label, onTap: a.onTap });
      else if (a.id != null && a.id !== '') ser.push({ id: clip(a.id, 32), label });
    });
    return { run, ser };
  }
  /* normaliza um push (JS ou servidor) ou uma linha do notifs.list: tipos, tamanhos e campos conhecidos */
  function build(o) {
    if (!o || typeof o !== 'object' || o.title == null || o.title === '') return null;
    const app = clip(o.app || 'settings', 32) || 'settings';
    let data = o.data == null ? null : o.data;
    if (typeof data === 'string') { try { data = /^\s*[[{]/.test(data) ? JSON.parse(data) : null; } catch (e) { data = null; } }   /* a coluna `data` é TEXT com JSON */
    if (data !== null && typeof data !== 'object') data = null;
    /* eSIM: a linha que recebeu (`line = { number, label, color, slot }`) vive em data.line; um push com ela no topo também serve */
    if (o.line && typeof o.line === 'object' && o.line.number && !(data && data.line)) data = Object.assign({}, data || {}, { line: o.line });
    const created = Number(o.created), msg = (o.msg != null && o.msg !== '') ? o.msg : o.description;
    const n = { id: newId(), app, title: clip(o.title, 200), msg: clip(msg, 4000), ts: created > 0 ? (created < 1e12 ? created * 1000 : created) : Date.now(), read: false, data, ext: safeSvg(o.iconHtml) };
    const sid = sidOf(o.id); if (sid != null) n.sid = sid;
    if (['silent', 'island', 'lock'].includes(o.type)) n.type = o.type;
    const du = Number(o.duration); if (du > 0) n.dur = Math.max(1500, Math.min(15000, Math.round(du)));
    const sa = splitActions(o.actions); if (sa.ser.length) n.acts = sa.ser;
    const mem = {};
    const ic = typeof o.icon === 'string' ? o.icon.trim() : '';
    if (ic) { if (isUrl(ic)) { if (ic.length <= 2048) n.icon = ic; else mem.icon = ic; } else if (/^[\w-]{1,32}$/.test(ic)) n.icon = ic; }
    const im = typeof o.image === 'string' ? o.image.trim() : '';
    if (im && isUrl(im)) { if (im.length <= 2048) n.image = im; else mem.image = im; }
    return { n, run: sa.run, mem, onTap: typeof o.onTap === 'function' ? o.onTap : null };
  }
  function remember(b, id) {
    if (b.onTap) handlers[id] = b.onTap;
    if (b.run.length) acts[id] = b.run;
    if (b.mem.icon || b.mem.image) media[id] = Object.assign(media[id] || {}, b.mem);
  }
  /* O corte aos 100 deixava os `onTap` e as ações das notificações caídas para trás em memória
     para sempre - e cada `onTap` é um closure sobre a janela da app que o criou (com o DOM dela
     e as imagens em base64 lá dentro). Poda-se o que já não tem cartão.
     ⚠️ os ids são NÚMEROS e as chaves de um objeto são strings: sem o `+k` isto apagava tudo. */
  function prune(keep) {
    const liveIds = new Set(keep.map(x => x.id));
    [handlers, acts, media].forEach(map => { for (const x in map) if (!liveIds.has(+x)) delete map[x]; });
  }
  function push(o) {
    const b = build(o); if (!b) return null;
    const n = b.n;
    if (!allowed(n.app, o)) return null;
    if (n.sid != null) {
      if (gone.has(n.sid)) return null;
      const l = all(), ex = l.find(x => x.sid === n.sid);
      if (ex) {
        /* já existe (o push e o notifs.list podem trazer a mesma): nunca dois cartões.
           Se só tinha chegado pelo histórico (`pend`), é agora que se anuncia; botões/tipo/duração que o histórico não trouxe completam-se com os do push. */
        if (!ex.pend) return ex;
        delete ex.pend; if (n.acts && !ex.acts) ex.acts = n.acts; if (n.type) ex.type = n.type; if (n.dur) ex.dur = n.dur;
        set(l); remember(b, ex.id); announce(ex, o); refresh(); Bridge.emit('notif', ex); return ex;
      }
    }
    remember(b, n.id);
    const keep = [n, ...all()].slice(0, MAX);
    set(keep); prune(keep);
    announce(n, o);
    refresh(); Bridge.emit('notif', n); return n;
  }
  /* som, ecrã bloqueado, banner/ilha e espreitar - respeitando foco, silêncio, tipo e as definições da app */
  function announce(n, o) {
    const s = System.state, cfg = appSettings(n.app), type = n.type || 'banner';
    const focus = s.dnd || (typeof s.focus === 'string' && s.focus !== 'none');   /* `focus` (N3) além do antigo `dnd` */
    const quiet = (focus && !o.critical) || o.quiet || isMuted(n.app) || type === 'silent';
    /* em silêncio não toca nem aparece, mas continua a entrar nas listas - também na do ecrã bloqueado, que antes só
       se repintava no próximo push com som. Adiado e agrupado: a entrega de 50 pendentes (type 'silent') repinta uma vez */
    if (quiet) { if (System.locked) { clearTimeout(lockT); lockT = setTimeout(() => { if (System.locked) renderLock(); }, 60); } return; }
    if (cfg.sound && s.notifSound && !o.silent) Sound.play(typeof o.sound === 'string' && o.sound ? o.sound.slice(0, 32) : (n.app === 'messages' ? 'message' : 'notify'));
    let visible;
    if (System.locked) { renderLock(); visible = cfg.lock; }
    /* PearOS: banner (nunca com o Centro de Notificações aberto); a ilha só se o utilizador o pedir (ou type 'island') - e se a ilha
       estiver ocupada (chamada, música, instalação) Island.notif devolve false e cai-se no banner */
    else {
      visible = type !== 'lock' && cfg.banner;
      /* Nova UI: a notificacao flutuante do painel rapido (.ahn-card), nunca a ilha (no Android o Island.notif recusa) */
      if (visible && android()) { if (!isOpen() && (System.currentApp() !== n.app || o.force) && window.QuickPanel && QuickPanel.headsUp) QuickPanel.headsUp(n); }
      else if (visible && !isOpen() && (System.currentApp() !== n.app || o.force)) { if (!((s.islandNotifs || type === 'island') && window.Island && Island.notif(islandView(n)))) showBanner(n); }
    }
    /* telemóvel fechado: sobe até ao banner para se poder ler, e desce sozinho (System.peek) - só se houver alguma coisa para ver */
    if (visible && System.peek) System.peek();
  }
  /* cópia para a ilha com a pré-visualização aplicada; o toque volta a procurar a notificação verdadeira pelo id */
  const islandView = n => { const pv = preview(n); return Object.assign({}, n, { title: pv.title, msg: pv.msg, icon: iconOf(n), duration: n.dur, ext: n.ext ? safeSvg(n.ext) : null }); };   /* a ilha põe o ext em innerHTML */
  function open(n) {
    const real = (n && find(n.id)) || n; if (!real) return;
    markRead(real.id); closeCard(); dismissOverlay(); close();
    const go = () => {
      if (real.sid != null) srv('notifs.open', { id: real.sid });   /* o servidor dispara apex_phone:notificationOpened */
      const h = handlers[real.id]; if (h) { try { h(real); } catch (e) {} } else { Bridge.emit('notif:open', real); if (App.get(real.app)) System.openApp(real.app); }
    };
    if (System.locked) Lock.requestUnlock(go); else go();
  }
  function forget(id) { delete handlers[id]; delete acts[id]; delete media[id]; }
  function remove(id) {
    const l = all(), n = l.find(x => x.id === id);
    set(l.filter(x => x.id !== id)); forget(id);
    if (n && n.sid != null) { gone.add(n.sid); srv('notifs.remove', { ids: [n.sid] }); }
    refresh(); if (System.locked) renderLock();
  }
  /* clear(app?) limpa o histórico local; com { sync: true } (gesto do utilizador) limpa também no servidor.
     Sem o sync por omissão: a reposição de fábrica e o harness chamam Notify.clear() e não devem apagar a BD. */
  function clear(app, opts) {
    const l = all(); (app ? l.filter(n => n.app === app) : l).forEach(n => { forget(n.id); if (n.sid != null) gone.add(n.sid); });
    set(app ? l.filter(n => n.app !== app) : []);
    if (opts && opts.sync) srv('notifs.clear', app ? { app } : {});
    if (app) expanded.delete(app); else expanded.clear(); refresh(); renderLock();
  }
  function markRead(id) {
    const l = all(); let sid = null, changed = false;
    l.forEach(n => { if (n.id === id && !n.read) { n.read = true; changed = true; if (n.sid != null) sid = n.sid; } });
    if (changed) set(l);
    if (sid != null) srv('notifs.read', { ids: [sid] });
  }
  /* marcar todas como lidas (de uma app ou todas) - local e servidor */
  function readAll(app) {
    const l = all(); let changed = false;
    l.forEach(n => { if (!n.read && (!app || n.app === app)) { n.read = true; changed = true; } });
    if (changed) { set(l); refresh(); if (System.locked) renderLock(); }
    srv('notifs.read', app ? { all: true, app } : { all: true });
  }
  const unread = () => all().filter(n => !n.read).length;

  /* ---------- histórico do servidor ---------- */
  /* junta as linhas do notifs.list ao histórico local sem duplicar (por id do servidor). Chegam em silêncio (`pend`):
     se o servidor voltar a entregar a mesma por push, é aí que toca e aparece o banner. */
  function merge(items) {
    const l = all().slice(), bySid = new Map(); l.forEach(n => { if (n.sid != null) bySid.set(n.sid, n); });
    let changed = false;
    items.forEach(it => {
      const b = build(it); if (!b || b.n.sid == null || gone.has(b.n.sid)) return;
      const read = it.read === true || Number(it.read) === 1, ex = bySid.get(b.n.sid);
      if (ex) {
        if (read && !ex.read) { ex.read = true; changed = true; }
        /* a cópia local veio de uma versão sem ações guardadas (ou de um push sem elas): os botões/tipo/duração do servidor completam-na */
        if (b.n.acts && !ex.acts) { ex.acts = b.n.acts; changed = true; }
        if (b.n.type && !ex.type) { ex.type = b.n.type; changed = true; }
        if (b.n.dur && !ex.dur) { ex.dur = b.n.dur; changed = true; }
        return;
      }
      if (!allowed(b.n.app, it)) return;
      b.n.read = read; b.n.pend = true; remember(b, b.n.id); l.push(b.n); bySid.set(b.n.sid, b.n); changed = true;
    });
    if (!changed) return false;
    l.sort((a, b) => (b.ts || 0) - (a.ts || 0));
    const keep = l.slice(0, MAX); set(keep); prune(keep);
    refresh(); if (System.locked) renderLock(); Bridge.emit('notifs:sync', keep.length);
    return true;
  }
  function sync() {
    const my = ++syncSeq;
    return srv('notifs.list', { limit: MAX }).then(r => {
      if (my !== syncSeq || !r || typeof r !== 'object') return false;   /* um pedido antigo que chegue atrasado (troca de personagem) não mistura listas */
      const items = Array.isArray(r.items) ? r.items : (r.items && typeof r.items === 'object' ? Object.values(r.items) : null);   /* tabela vazia do Lua = {} */
      return items ? merge(items) : false;
    });
  }
  function onSession(cid) {
    if (cid && lastCid && cid !== lastCid) {
      /* outra personagem: os handlers e as imagens em memória eram da anterior */
      [handlers, acts, media].forEach(map => { for (const x in map) delete map[x]; });
      gone.clear(); expanded.clear(); try { close(); if (banner) banner.hide(true); } catch (e) {}
    }
    if (cid) lastCid = cid;
    const ln = document.querySelector('.lock-notifs'); if (ln) ln._ids = null;
    refresh(); renderLock(); sync();
    emitChanged();   /* a lista passou a ser a do espaco desta personagem sem ninguem a gravar: avisa-se a mao */
  }
  /* push "session" (a personagem carregou). setTimeout 0: o Store.setNamespace(cid) corre no ouvinte do main.js, que foi
     registado depois deste. Duas guardas:
     - antes do Notify.init não se faz nada (o init pede o histórico);
     - se o Store ainda não está no espaço desta personagem (no arranque o System adia a troca para depois do account.get),
       não se lê nem se junta nada agora - a lista ia parar ao espaço da anterior e seria copiada para outras personagens.
       Trata-se no 'session:changed', que o System emite logo a seguir ao Store.setNamespace. */
  Bridge.on('session', d => {
    const cid = d && d.citizenid != null ? String(d.citizenid) : null;
    setTimeout(() => {
      if (!nc) return;
      if (cid && Store.namespace && String(Store.namespace) !== cid) return;
      if (cid && cid === lastCid && Date.now() - changedAt < 1500) return;   /* o session:changed desta mesma troca já pediu a lista */
      onSession(cid);
    }, 0);
  });
  Bridge.on('session:changed', d => { if (!nc) return; changedAt = Date.now(); onSession(d && d.to != null ? String(d.to) : null); });

  /* ---------- render (partilhado NC + lock) ---------- */
  function render(container, opts = {}) {
    const st = container.scrollTop, prev = container._ids || null, ids = new Set(); let idx = 0;
    closeCard(); disarm(); container.innerHTML = '';
    const items = all().filter(n => !opts.filter || opts.filter(n));
    const mark = (c, id) => { ids.add(id); if (!prev || !prev.has(id)) { c.classList.add('new'); if (!prev) c.style.animationDelay = Math.min(idx++, 8) * 40 + 'ms'; } };
    if (!items.length) { container._ids = ids; container.classList.remove('open', 'collapsed', 'xopen'); if (!opts.lock) container.appendChild(UI.el('<div class="nc-empty">Sem notificações</div>')); return; }
    const m = opts.lock ? mode() : 'list', collapsed = opts.lock && !lockOpen && m !== 'list' && items.length > 0;
    if (opts.lock) { container.classList.toggle('open', !collapsed); container.classList.toggle('collapsed', collapsed); container.classList.toggle('xopen', lockOpen && m !== 'list'); }
    /* fechado: contagem (cápsula) ou pilha única com a mais recente por cima e as outras a espreitar por trás */
    if (collapsed) {
      const wrap = UI.el('<div class="ngroup nall nw-group" data-app="*"></div>');
      if (m === 'count') {
        /* Nova UI: "so icones" (os icones das apps com notificacoes por ler, ate cinco, e o total); PearOS: a capsula com o sino */
        const ids = []; items.forEach(n => { if (!ids.includes(n.app)) ids.push(n.app); });
        const p = android()
          ? UI.el(`<div class="ncount aln-count">${ids.slice(0, 5).map(a => `<i class="aln-ic">${Icons.tile(a)}</i>`).join('')}${ids.length > 5 ? `<b class="aln-more">+${ids.length - 5}</b>` : ''}<span class="aln-n">${items.length}</span></div>`)
          : UI.el(`<div class="ncount">${g('bell', 16)}<span>${items.length === 1 ? '1 notificação' : items.length + ' notificações'}</span></div>`);
        p.onclick = () => { Sound.play('click'); lockOpen = true; renderLock(); }; wrap.appendChild(p);
      } else {
        const sw = UI.el(`<div class="nstack ${items.length > 2 ? 'p2' : items.length > 1 ? 'p1' : 'p0'}" data-app="*"></div>`);
        const c = card(items[0], { lock: true, all: items.length > 1, wrap: sw, count: items.length }); mark(c, items[0].id);
        sw.appendChild(c); if (items.length > 1) sw.appendChild(UI.el('<div class="peek peek1"></div>')); if (items.length > 2) sw.appendChild(UI.el('<div class="peek peek2"></div>'));
        wrap.appendChild(sw);
      }
      container.appendChild(wrap); container._ids = ids; container.scrollTop = st; return;
    }
    /* no ecrã bloqueado a caixa é column-reverse (o 1.º filho fica em BAIXO): o cabeçalho "Centro de notificações" entra no fim */
    if (!opts.lock) container.appendChild(header(null, { all: true }));
    const groups = {}, order = []; items.forEach(n => { if (!groups[n.app]) { groups[n.app] = []; order.push(n.app); } groups[n.app].push(n); });
    order.forEach(app => {
      const gl = groups[app]; const wrap = UI.el(`<div class="ngroup" data-app="${UI.esc(app)}"></div>`);
      /* no ecrã bloqueado cada app é uma pilha (a mais recente por cima); tocar abre-a, "Mostrar menos" volta a fechar.
         PearOS 27: no centro de notificações também (o sistema real agrupa cada app numa pilha; ncExp guarda as abertas ali) */
      const ncStack = !opts.lock && !android();
      if ((opts.lock || ncStack) && gl.length > 1 && !(opts.lock ? expanded : ncExp).has(app)) {
        const sw = UI.el(`<div class="nstack ${gl.length > 2 ? 'p2' : 'p1'}" data-app="${UI.esc(app)}"></div>`);
        const c = card(gl[0], { lock: !!opts.lock, stack: true, nc: ncStack, wrap: sw, count: gl.length }); mark(c, gl[0].id);
        sw.appendChild(c); sw.appendChild(UI.el('<div class="peek peek1"></div>')); if (gl.length > 2) sw.appendChild(UI.el('<div class="peek peek2"></div>'));
        wrap.appendChild(sw);
      } else {
        /* cabeçalho da app (nome · Mostrar menos · x) só quando há mais do que uma - uma notificação sozinha é um cartão solto, como no iOS */
        if (gl.length > 1) wrap.appendChild(header(app, { less: opts.lock || ncStack, nc: ncStack }));
        gl.slice(0, opts.lock ? 12 : 40).forEach(n => { const c = card(n, { lock: opts.lock }); mark(c, n.id); wrap.appendChild(c); });
      }
      container.appendChild(wrap);
    });
    /* Nova UI: a lista do bloqueado e em coluna normal (a mais recente em cima, oneui-lock.css), por isso este fica no FIM:
       vira um rodape so com "Limpar tudo", que limpa ao primeiro toque (sem o "x" que se arma do PearOS) */
    if (opts.lock) container.appendChild(android() ? lockFootA(container) : header(null, { all: true }));
    container._ids = ids; container.scrollTop = st;
  }
  function lockFootA(container) {
    const f = UI.el(`<div class="nhead nh-top aln-foot"><span class="aln-clear">${UI.esc(window.L && L.t ? L.t('Limpar tudo') : 'Limpar tudo')}</span></div>`);
    const b = f.firstElementChild;
    b.addEventListener('pointerdown', e => e.stopPropagation());
    b.onclick = e => { e.stopPropagation(); Sound.play('click'); flyOut(container, null, () => clear(null, { sync: true })); };
    return f;
  }
  /* cabeçalho de grupo: "<App>  [Mostrar menos]  (x → Limpar)" · topo: "Centro de notificações  (x → Limpar tudo)" */
  function header(app, o = {}) {
    const h = UI.el(`<div class="nhead ${o.all ? 'nh-top' : ''}"><b class="nh-name">${UI.esc(o.all ? 'Centro de notificações' : App.name(app))}</b>${o.less ? '<div class="nh-less lg">Mostrar menos</div>' : ''}<div class="nh-x lg ${o.all ? 'all' : ''}"><i class="nh-xi">${g('x', 20)}</i><b class="nh-xl">${o.all ? 'Limpar tudo' : 'Limpar'}</b></div></div>`);
    const x = h.querySelector('.nh-x');
    x.onclick = e => { e.stopPropagation(); Sound.play('click'); if (armed === x) { disarm(); flyOut(h.parentElement && h.parentElement.closest('.nc-list,.lock-notifs') || h.parentElement, app, () => clear(app, { sync: true })); } else arm(x); };
    x.addEventListener('pointerdown', e => e.stopPropagation());
    const less = h.querySelector('.nh-less'); if (less) { less.onclick = e => { e.stopPropagation(); Sound.play('click'); if (o.nc) { ncExp.delete(app); refresh(); return; } expanded.delete(app); renderLock(); }; less.addEventListener('pointerdown', e => e.stopPropagation()); }
    return h;
  }
  /* PearOS 17: o "x" vira "Limpar" e assim fica até se tocar noutro sítio */
  function arm(x) { disarm(); armed = x; x.classList.add('arm'); }
  function disarm() { if (armed) armed.classList.remove('arm'); armed = null; }
  /* limpar grupo/tudo: cartões voam para a direita, depois atualiza */
  function flyOut(container, app, done) {
    if (!container) { done(); return; }
    /* o id da app vem de pushes externos: com aspas ou "]" o seletor rebentava (SyntaxError) e o "Limpar" não limpava */
    const qa = app ? (window.CSS && CSS.escape ? CSS.escape(String(app)) : String(app).replace(/[^\w-]/g, '\\$&')) : '';
    const els = [...container.querySelectorAll(app ? `.ngroup[data-app="${qa}"] .nstack, .ngroup[data-app="${qa}"] > .notif-card` : '.nstack, .ngroup > .notif-card')];
    els.forEach((el, i) => { el.style.transitionDelay = Math.min(i, 8) * 35 + 'ms'; el.classList.add('fly'); });
    container.querySelectorAll(app ? `.ngroup[data-app="${qa}"] .nhead` : '.nhead').forEach(h => h.classList.add('fly'));
    setTimeout(done, 320 + Math.min(els.length, 8) * 35);
  }
  /* Apagar um cartão: antes a altura animava até 0 (height/margin a cada frame - contra a regra do CEF).
     Agora é FLIP: guarda-se onde estava cada cartão/cabeçalho, apaga-se e repinta-se de uma vez, e os que
     mudaram de sítio partem da posição antiga com um translateY que volta a 0 por transição de transform. */
  function collapse(el, done) {
    const box = el.closest('.nc-list,.lock-notifs'), before = box ? snapshot(box) : null;
    el.classList.add('gone'); el.remove(); done && done();
    if (box && before && box.isConnected) flip(box, before);
  }
  const snapshot = box => {
    const m = new Map();
    box.querySelectorAll('.notif-card[data-id]').forEach(c => m.set('c' + c.dataset.id, c.getBoundingClientRect().top));
    box.querySelectorAll('.ngroup[data-app] > .nhead').forEach(h => m.set('h' + h.parentElement.dataset.app, h.getBoundingClientRect().top));
    return m;
  };
  function flip(box, before) {
    const z = k() || 1, moved = [];
    const add = (node, key, ref) => { const t = before.get(key); if (node && t != null) { const dy = (t - ref.getBoundingClientRect().top) / z; if (Math.abs(dy) > .5) moved.push([node, dy]); } };
    /* no cartão move-se o .ncard (o .notif-card pode ter a animação de entrada com fill, que ganharia ao transform) */
    box.querySelectorAll('.notif-card[data-id]').forEach(c => add(c.querySelector('.ncard'), 'c' + c.dataset.id, c));
    box.querySelectorAll('.ngroup[data-app] > .nhead').forEach(h => add(h, 'h' + h.parentElement.dataset.app, h));
    if (!moved.length) return;
    moved.forEach(([n, dy]) => { n.style.transition = 'none'; n.style.transform = `translateY(${dy.toFixed(1)}px)`; });
    void box.offsetWidth;   /* uma leitura para o browser pintar o ponto de partida (senão salta a transição) */
    moved.forEach(([n]) => { n.style.transition = 'transform .32s var(--ease)'; n.style.transform = ''; });
    setTimeout(() => moved.forEach(([n]) => { if (!n.style.transform) n.style.transition = ''; }), 380);
  }
  function actionsFor(n) {
    const l = (acts[n.id] || []).map(a => ({ label: a.label, run: a.onTap })); const d = n.data || {};
    (n.acts || []).forEach(a => l.push({ label: a.label, run: () => serverAction(n, a) }));
    if (!l.length) {
      if (n.app === 'phone' && d.number && window.PhoneApp) l.push({ label: 'Ligar', run: () => PhoneApp.call(d.number, n.title) });
      if (n.app === 'messages' && d.number && window.Msgs) l.push({ label: 'Responder', run: () => Msgs.open(d.number, n.title) });
      if (d.coords && d.coords.x !== undefined) l.push({ label: 'Navegar', run: () => { Bridge.call('setWaypoint', { x: d.coords.x, y: d.coords.y, name: n.title }); toast('GPS marcado'); } });
    }
    return l;
  }
  /* ação vinda do servidor: o NUI nunca executa nada - só diz ao servidor qual foi (ele valida e dispara apex_phone:notificationAction) */
  function serverAction(n, a) {
    if (n.sid != null) srv('notifs.action', { id: n.sid, action: a.id });
    Bridge.emit('notif:action', { id: n.id, sid: n.sid == null ? null : n.sid, app: n.app, action: a.id, data: n.data });
  }
  const runAction = (n, a) => { Sound.play('click'); markRead(n.id); const go = () => { try { a.run(n); } catch (x) {} }; if (System.locked) Lock.requestUnlock(go); else go(); };
  /* ícone: HTML antigo filtrado, ícone de outra app, imagem por URL (pintada por CSSOM em paint) ou o da própria app */
  function icHtml(n) {
    /* o `ext` passa outra vez pelo filtro: as notificações gravadas pela versão antiga guardavam o iconHtml tal como vinha */
    const ext = n.ext ? safeSvg(n.ext) : null; if (ext) return ext; const ic = iconOf(n);
    if (ic && isUrl(ic)) return '<span class="n-icimg"></span>';
    if (ic && App.get(ic)) return Icons.tile(ic);
    /* conversa com número (Mensagens, Recado, Telefone): a foto/iniciais do contacto em círculo com o ícone da app em selo,
       como o iPhone mostra as mensagens (a foto entra depois, por CSSOM, em paint) */
    const num = n.data && n.data.number;
    if (num && CONV_APPS.has(n.app) && window.Contacts && UI.avatar) {
      const c = Contacts.byNumber(num); const name = (c && c.name) || n.title || String(num);
      return `<div class="n-avwrap">${UI.avatar({ name, avatar: c && c.avatar })}<span class="n-badge">${Icons.tile(n.app)}</span></div>`;
    }
    return Icons.tile(n.app);
  }
  const CONV_APPS = new Set(['messages', 'recado', 'phone', 'facetime']);
  /* eSIM: "[T] Trabalho" quando a notificação veio de uma linha (data.line) e o telemóvel tem mais do que uma (js/apps/esim.js) */
  const lineTag = n => { try { return (window.ESim && ESim.notifTag) ? ESim.notifTag(n) : ''; } catch (e) { return ''; } };
  const inner = (n, pv) => `<div class="n-ic">${icHtml(n)}</div><div class="n-body"><div class="n-app">${UI.esc(App.name(n.app))}</div><div class="n-title">${pv.hidden ? '' : lineTag(n)}${UI.esc(pv.title)}</div><div class="n-msg">${UI.esc(pv.msg)}</div><div class="n-acts"></div></div><div class="n-time">${UI.esc(UI.timeAgo(n.ts))}</div>${pv.image ? '<div class="n-thumb"></div>' : ''}`;
  /* ---------- Nova UI (Android) ----------
     Cartao em pilula como o da Nova UI 8.5: a esquerda o circulo de 56 com o icone da app (ou a foto do contacto com o
     icone da app em selo); ao meio o titulo com a hora ao lado e o texto por baixo; a miniatura a direita; as acoes numa
     linha propria. O mesmo desenho serve o ecra bloqueado, o painel de notificacoes e a notificacao flutuante (o
     android-panel.js usa-o pelo Notify._ui e poe a seta de expandir no fim da .n-main). count: o numero da pilha. */
  function smallIc(n) {
    const ext = n.ext ? safeSvg(n.ext) : null; if (ext) return ext; const ic = iconOf(n);
    if (ic && isUrl(ic)) return '<span class="n-icimg"></span>';
    return Icons.tile(ic && App.get(ic) ? ic : n.app);
  }
  function leadIc(n, pv) {
    const num = !pv.hidden && n.data && n.data.number;
    if (num && CONV_APPS.has(n.app) && window.Contacts && UI.avatar) { const c = Contacts.byNumber(num); const name = (c && c.name) || n.title || String(num); return `<div class="n-person">${UI.avatar({ name, avatar: c && c.avatar })}</div><span class="n-badge">${Icons.tile(n.app)}</span>`; }
    return `<div class="n-ic">${smallIc(n)}</div>`;
  }
  const innerA = (n, pv, time, count) => `<div class="n-main"><div class="n-lead">${leadIc(n, pv)}</div><div class="n-body"><div class="n-tl">${pv.hidden ? '' : lineTag(n)}<span class="n-title">${UI.esc(pv.title)}</span><span class="n-time">${UI.esc(time == null ? UI.timeAgo(n.ts) : time)}</span></div><div class="n-msg">${UI.esc(pv.msg)}</div></div>${pv.image ? '<div class="n-thumb"></div>' : ''}${count > 1 ? `<b class="n-count">${count}</b>` : ''}</div><div class="n-acts"></div>`;
  function paintA(root, n, pv) {
    const ic = root.querySelector('.n-icimg'); if (ic) ic.style.backgroundImage = UI.img(iconOf(n));
    const pa = root.querySelector('.n-person .avatar'); if (pa && window.Contacts && Contacts.paintAvatar && n.data) { const c = Contacts.byNumber(n.data.number); if (c) { try { Promise.resolve(Contacts.paintAvatar(pa, c, false)).catch(() => {}); } catch (e) {} } }
    const th = root.querySelector('.n-thumb'); if (th && pv.image) { th.style.backgroundImage = UI.img(pv.image); const cd = th.closest('.ncard'); if (cd) cd.classList.add('has-img'); }
  }
  /* imagens SEMPRE por CSSOM (regra do projeto: base64 dentro de strings HTML parte o CEF e é injeção) */
  function paint(root, n, pv) {
    const ic = root.querySelector('.n-icimg'); if (ic) ic.style.backgroundImage = UI.img(iconOf(n));
    const avw = root.querySelector('.n-avwrap'); if (avw) { avw.parentElement.classList.add('av'); const c = window.Contacts && n.data && Contacts.byNumber(n.data.number); const a = avw.querySelector('.avatar'); if (c && a && Contacts.paintAvatar) { try { Contacts.paintAvatar(a, c, false).catch(() => {}); } catch (e) {} } }
    const th = root.querySelector('.n-thumb'); if (th && pv.image) { th.style.backgroundImage = UI.img(pv.image); const cd = th.closest('.ncard'); if (cd) cd.classList.add('has-img'); }
    const xi = root.querySelector('.n-ximg'); if (xi && pv.image) xi.style.backgroundImage = UI.img(pv.image);
  }

  /* ---------- cartão (swipe / tap / long press) ---------- */
  function card(n, ctx = {}) {
    const pv = preview(n), A = android();
    const c = UI.el(`<div class="notif-card ${ctx.stack || ctx.all ? 'stacked' : ''}" data-id="${n.id}"><div class="n-behind"><div class="n-bb n-opt">Opções</div><div class="n-bb n-clr">Limpar</div></div><div class="ncard lg${ctx.lock ? ' lg-wp on-lock' : ''}${A ? ' aln' : ''}">${A ? innerA(n, pv, null, ctx.count) : inner(n, pv)}</div></div>`);
    if (A) paintA(c, n, pv); else paint(c, n, pv);
    const al = actionsFor(n), actsEl = c.querySelector('.n-acts');
    if (al.length && !ctx.stack && !ctx.all) al.forEach(a => { const b = UI.el(`<div class="n-act">${UI.esc(a.label)}</div>`); b.onclick = e => { e.stopPropagation(); runAction(n, a); }; b.addEventListener('pointerdown', e => e.stopPropagation()); actsEl.appendChild(b); }); else actsEl.remove();
    const front = c.querySelector('.ncard'), wrap = ctx.wrap || c;
    let sx = 0, sy = 0, base = 0, axis = null, lpT = null, pid = null, swallow = false, lx = 0, lt = 0, vx = 0;
    const setX = (x, anim) => { front.style.transition = anim ? '' : 'none'; front.style.transform = x ? `translate3d(${x}px,0,0)` : ''; c.style.setProperty('--nx', String(Math.min(1, Math.max(0, -x / OPEN)))); };
    const snap = x => { setX(x, true); if (x) { c.classList.add('open'); openCard = c; } else { c.classList.remove('open'); if (openCard === c) openCard = null; } };
    c._close = () => snap(0);
    const finalize = () => { if (ctx.all) clear(null, { sync: true }); else if (ctx.stack) clear(n.app, { sync: true }); else remove(n.id); };   /* arrastar a pilha inteira = limpar tudo (iOS) */
    /* dir: -1 sai pela esquerda (PearOS), +1 pela direita (a Nova UI dispensa para os dois lados) */
    const fling = (dir = -1) => { const W = (window.System && System.SW) || PW;   /* 880 no fold aberto: o cartão sai do ecrã largo */
      if (openCard === c) openCard = null; c.classList.remove('open'); c.classList.add('fly-x'); setX(dir > 0 ? W + 60 : -W - 60, true); setTimeout(() => collapse(wrap, finalize), 230); };
    c.querySelector('.n-clr').onclick = e => { e.stopPropagation(); Sound.play('click'); fling(); };
    c.querySelector('.n-opt').onclick = e => { e.stopPropagation(); Sound.play('click'); options(n, c); };
    c.querySelectorAll('.n-bb').forEach(b => b.addEventListener('pointerdown', e => e.stopPropagation()));
    front.addEventListener('pointerdown', e => {
      if (e.button !== 0 && e.pointerType === 'mouse') return; if (e.target.closest('.n-act')) return;
      swallow = false; if (openCard && openCard !== c) { openCard._close(); swallow = true; } if (armed) disarm();
      sx = e.clientX; sy = e.clientY; base = 0; axis = null; pid = e.pointerId; lx = e.clientX; lt = Date.now(); vx = 0;
      try { front.setPointerCapture(pid); } catch (x) {}
      c.classList.add('press'); clearTimeout(lpT);
      lpT = setTimeout(() => { if (axis || swallow) return; axis = 'lp'; c.classList.remove('press'); expand(n, c, ctx); }, 480);
    });
    front.addEventListener('pointermove', e => {
      if (pid === null) return; const dx = (e.clientX - sx) / k(), dy = (e.clientY - sy) / k();
      if (!axis) { if (Math.hypot(dx, dy) < 6) return; clearTimeout(lpT); c.classList.remove('press'); axis = Math.abs(dx) > Math.abs(dy) ? 'x' : 'y'; if (axis === 'x') c.classList.add('dragging'); }
      if (axis !== 'x') return;
      const now = Date.now(); vx = (e.clientX - lx) / k() / Math.max(1, now - lt); lx = e.clientX; lt = now;
      let x = base + dx; if (x > 0 && !A) x *= .18;                             /* para a esquerda segue o dedo até sair (sem botões por baixo, pedido do utilizador); na Nova UI segue para os dois lados */
      setX(x, false);
    });
    const up = e => {
      if (pid === null) return; clearTimeout(lpT); c.classList.remove('press', 'dragging'); const a = axis; axis = null; pid = null;
      const dx = (e.clientX - sx) / k();
      if (a === 'lp') return;
      if (a === 'x') { const x = base + dx, w = c.offsetWidth || PW - 28;
        if (A) { const far = Math.abs(x) > w * .3; if (far || Math.abs(vx) > .45) fling(far ? Math.sign(x) : Math.sign(vx)); else snap(0); return; }
        if (-x > w * .3 || vx < -.45) fling(); else snap(0); return; }   /* arrastar para o lado = apagar, sem "Opções/Limpar" */
      if (a === 'y') { snap(0); return; }
      if (swallow) return; if (c.classList.contains('open')) { snap(0); return; }
      Sound.play('click');
      if (ctx.all) { lockOpen = true; renderLock(); return; }          /* pilha única → abre a lista */
      if (ctx.stack && ctx.nc) { ncExp.add(n.app); refresh(); return; }   /* centro de notificações (PearOS 27): a pilha da app abre-se ali */
      if (ctx.stack) { expanded.add(n.app); renderLock(); return; }   /* pilha da app → abre essa app */
      open(n);
    };
    front.addEventListener('pointerup', up); front.addEventListener('pointercancel', up);
    front.addEventListener('contextmenu', e => e.preventDefault());
    return c;
  }
  function closeCard() { if (openCard) { const c = openCard; openCard = null; c._close && c._close(); } }

  /* ---------- Opções (menu ancorado ao cartão) ---------- */
  function options(n, c) {
    closeCard(); const name = App.name(n.app);
    UI.ctxMenu(c, [
      { label: 'Silenciar por 1 hora', icon: 'bellOff', onTap: () => { mute(n.app, Date.now() + 36e5); toast(`${name} silenciada durante 1 hora`); } },
      { label: 'Silenciar hoje', icon: 'moon', onTap: () => { const d = new Date(); d.setHours(23, 59, 59, 999); mute(n.app, d.getTime()); toast(`${name} silenciada até amanhã`); } },
      { label: 'Desativar', icon: 'bellOff', danger: true, onTap: () => UI.confirm(`Desativar notificações de ${name}?`, 'Podes voltar a ativá-las em Definições > Notificações.', 'Desativar', true).then(ok => { if (!ok) return; setAppSettings(n.app, { allow: false }); toast(android() ? `Notificações de ${name} desativadas · Definições > Notificações` : `Notificações de ${name} desativadas: Definições > Notificações`, 2800); }) },
      /* Nova UI: vai direto a pagina das notificacoes (no PearOS fica como estava: a raiz das Definicoes) */
      { label: 'Ver definições', icon: 'gear', onTap: () => { close(); const A = android(); const go = () => { System.openApp('settings'); if (A) setTimeout(() => Bridge.emit('settings:goto', 'notifications'), 340); }; if (System.locked) Lock.requestUnlock(go); else go(); } },
    ]);
  }
  function toast(msg, ms = 1900) {
    document.querySelectorAll('.n-toast').forEach(t => t.remove()); clearTimeout(toastT);
    const t = UI.el(`<div class="n-toast">${UI.esc(msg)}</div>`); UI.screen().appendChild(t); requestAnimationFrame(() => t.classList.add('in'));
    toastT = setTimeout(() => { t.classList.remove('in'); setTimeout(() => t.remove(), 300); }, ms);
  }

  /* ---------- cartão expandido (long press) ---------- */
  /* ctx.top  - quem chama já mediu onde o cartão deve nascer (o banner mede-se antes de sair de cena)
     ctx.noSrc - não esconder o elemento de origem (o banner já se foi; esconder e voltar a mostrar fazia-o reaparecer) */
  function expand(n, c, ctx) {
    ctx = ctx || {};
    dismissOverlay(); closeCard(); Sound.play('pop');
    const s = UI.screen().getBoundingClientRect(), z = k(); const top = ctx.top != null ? ctx.top : Math.max(80, (c.getBoundingClientRect().top - s.top) / z);
    const pv = preview(n);
    const o = UI.el(`<div class="n-xwrap"><div class="n-x lg"><div class="n-xhead"><div class="n-ic">${icHtml(n)}</div><b class="n-xapp">${UI.esc(App.name(n.app))}${pv.hidden ? '' : lineTag(n)}</b><i class="n-xtime">${UI.esc(UI.timeAgo(n.ts))}</i></div><div class="n-xbody"><div class="n-xtitle">${UI.esc(pv.title)}</div><div class="n-xmsg">${UI.esc(pv.msg)}</div>${pv.image ? '<div class="n-ximg"></div>' : ''}</div><div class="n-xacts"></div></div></div>`);
    paint(o, n, pv);
    const x = o.firstElementChild, ax = o.querySelector('.n-xacts'); x.style.top = top + 'px';
    actionsFor(n).forEach(a => { const b = UI.el(`<div class="n-xact">${UI.esc(a.label)}</div>`); b.onclick = e => { e.stopPropagation(); dismissOverlay(); runAction(n, a); }; ax.appendChild(b); });
    const del = UI.el(`<div class="n-xact danger">${g('trash', 21)}<span>${ctx.stack || ctx.all ? 'Limpar tudo' : 'Limpar'}</span></div>`); del.onclick = e => { e.stopPropagation(); dismissOverlay(); Sound.play('click'); if (ctx.all) clear(null, { sync: true }); else if (ctx.stack) clear(n.app, { sync: true }); else remove(n.id); }; ax.appendChild(del);
    o.querySelector('.n-xbody').onclick = e => { e.stopPropagation(); dismissOverlay(); open(n); };
    o.onclick = e => { if (e.target === o) dismissOverlay(); };
    o._src = ctx.noSrc ? null : (ctx.wrap || c); if (o._src) o._src.style.visibility = 'hidden'; overlay = o; UI.screen().appendChild(o);
    requestAnimationFrame(() => { o.classList.add('in'); const h = x.offsetHeight; if (top + h > 900) x.style.top = Math.max(80, 900 - h) + 'px'; });
  }
  function dismissOverlay() { if (!overlay) return; const o = overlay; overlay = null; o.classList.remove('in'); if (o._src) o._src.style.visibility = ''; setTimeout(() => o.remove(), 260); }

  /* ---------- banner (PearOS drop-in, telemóvel desbloqueado) ---------- */
  function showBanner(n) {
    if (banner) banner.hide(true);
    const pv = preview(n);
    const b = UI.el(`<div class="nbanner" data-id="${n.id}"><div class="ncard lg">${inner(n, pv)}</div></div>`);   /* data-id: o tradutor (i18n.js notifItem) encontra a notificação e a sua marca data.sys */
    paint(b, n, pv);
    b.querySelector('.n-time').textContent = 'agora'; const actsEl = b.querySelector('.n-acts'); if (actsEl) actsEl.remove();
    const ms = n.dur > 0 ? n.dur : 5000;   /* duration do contrato 5.4 */
    let sy = 0, pid = null, moved = false, hidden = false, t = null, lpT = null, lp = false;
    const api = { hide: fast => { if (hidden) return; hidden = true; clearTimeout(t); clearTimeout(lpT); b.classList.remove('in'); b.classList.add('out'); if (fast) b.style.transition = 'transform .25s var(--ease), opacity .2s'; setTimeout(() => b.remove(), fast ? 260 : 520); if (banner === api) banner = null; } };
    /* Gesto do PearOS: PUXAR O BANNER PARA BAIXO (ou mantê-lo premido) abre o cartão expandido, com as mesmas
       ações do Centro de Notificações - o expand() e o actionsFor() já existiam e só o Centro os usava.
       O toque simples continua a abrir a app e o puxão para cima continua a dispensar. */
    const big = () => { if (hidden) return; const r = b.getBoundingClientRect(), s = UI.screen().getBoundingClientRect(), z = k() || 1;
      const top = Math.max(58, (r.top - s.top) / z);   /* mede-se ANTES de o banner sair (58 = .nbanner{top}) */
      b.style.transition = ''; b.style.transform = ''; api.hide(true); expand(n, b, { top, noSrc: true }); };
    b.addEventListener('pointerdown', e => { if (e.button !== 0 && e.pointerType === 'mouse') return; sy = e.clientY; pid = e.pointerId; moved = false; lp = false; clearTimeout(t); try { b.setPointerCapture(pid); } catch (x) {} b.style.transition = 'none';
      clearTimeout(lpT); lpT = setTimeout(() => { if (pid !== null && !moved) { lp = true; big(); } }, 480); });
    b.addEventListener('pointermove', e => { if (pid === null) return; const dy = (e.clientY - sy) / k(); if (Math.abs(dy) > 4) { moved = true; clearTimeout(lpT); }
      /* para baixo segue o dedo até 64 px (é o gesto de expandir), para cima é o de dispensar */
      b.style.transform = `translateY(${dy < 0 ? dy : Math.min(64, dy * .6)}px)`; });
    const up = e => { if (pid === null) return; pid = null; clearTimeout(lpT); const dy = (e.clientY - sy) / k(); b.style.transition = ''; b.style.transform = '';
      if (lp) return;                                                         /* já expandiu no manter premido */
      if (dy < -30) { api.hide(); return; }
      if (dy > 44) { big(); return; }
      if (!moved) { api.hide(true); open(n); return; } t = setTimeout(api.hide, 3000); };
    b.addEventListener('pointerup', up); b.addEventListener('pointercancel', up);
    UI.screen().appendChild(b); banner = api; requestAnimationFrame(() => requestAnimationFrame(() => b.classList.add('in'))); t = setTimeout(api.hide, ms);
    return api.hide;
  }

  function renderLock() {
    const ln = document.querySelector('.lock-notifs'); if (!ln) return;
    render(ln, { lock: true, filter: n => !n.read && appSettings(n.app).lock });   /* "Ecrã bloqueado" desligado na app → só no centro */
    fitLock(ln);
    keepNewestVisible(ln);
    if (window.Glass) Glass.soon(ln);   /* vidro sobre o fundo: a cópia desfocada alinhada com cada cartão (glass27.css) */
  }
  /* Lista aberta (pilha/contagem aberta ou um grupo expandido) mais alta do que a caixa: o relógio encolhe para o topo e a caixa
     cresce (#lock.nc-scroll, liquid27.css) - como o PearOS quando se sobe a lista no ecrã bloqueado. Antes os cartões subiam por
     baixo dos dígitos e apareciam cortados pela máscara (queixa in-game 2026-09-20). Uma vez encolhido fica assim enquanto a lista
     estiver aberta (senão oscilava: com a caixa maior o conteúdo "cabia" e o relógio voltava a crescer); fechar repõe. */
  function fitLock(ln) {
    const lock = document.getElementById('lock'); if (!lock) return;
    const open = lockOpen || expanded.size > 0;
    const on = open && (lock.classList.contains('nc-scroll') || ln.scrollHeight > ln.clientHeight + 2);
    lock.classList.toggle('nc-scroll', on);
  }
  /* pilha/contagem: abrir em lista e voltar a fechar (o lock.js chama o collapse no puxão para baixo) */
  function collapseLock() { if (!lockOpen && !expanded.size) return; lockOpen = false; expanded.clear(); closeCard(); disarm(); renderLock(); }
  function expandLock() { if (lockOpen) return; lockOpen = true; renderLock(); }
  /* Com MUITAS notificações a lista transborda e a MAIS RECENTE ficava cortada no fundo.
     A caixa é `column-reverse`, e assumiu-se que nesse modo o scrollTop 0 já era o fundo -
     não é: medido no Chromium, scrollTop 0 mostra o TOPO e o cartão novo ficava 14 px por
     baixo da caixa. Em vez de confiar na convenção, corrige-se pela geometria real: mede-se
     quanto é que o cartão mais recente passa do fundo e rola-se exatamente isso. */
  /* Marca QUAL é o cartão acabado de chegar e o grupo a que pertence. Serve o "espreitar":
     com o telemóvel guardado e a lista cheia, o ecrã bloqueado mostra só esta - como o
     PearPhone - em vez de obrigar o aparelho a subir quase todo para lá chegar. */
  function marcarNovo(box, card) {
    box.querySelectorAll('.nw-card').forEach(e => e.classList.remove('nw-card'));
    box.querySelectorAll('.nw-group').forEach(e => e.classList.remove('nw-group'));
    if (!card) return;
    card.classList.add('nw-card');
    const gr = card.closest('.ngroup'); if (gr) gr.classList.add('nw-group');
  }
  function keepNewestVisible(box) {
    /* Nova UI: a lista do bloqueado e uma coluna normal (oneui-lock.css) e a mais recente e o PRIMEIRO cartao, em cima
       (os grupos vem pela ordem da mais recente). Marca-se esse (o espreitar mostra-o) e a lista volta ao topo. */
    if (android()) {
      const first = box.querySelector('.notif-card');
      marcarNovo(box, first); if (first) box.scrollTop = 0;
      return;
    }
    const go = () => {
      if (!box.isConnected) return;
      const cards = box.querySelectorAll('.notif-card');
      if (!cards.length) return;
      let novo = null, max = -Infinity;
      cards.forEach(c => { const b = c.getBoundingClientRect().bottom; if (b > max) { max = b; novo = c; } });
      if (!novo) return;
      /* a marcação é sempre feita, mesmo com a lista curta: o espreitar depende dela */
      marcarNovo(box, novo);
      if (box.scrollHeight <= box.clientHeight + 2) return;
      const fora = () => novo.getBoundingClientRect().bottom - box.getBoundingClientRect().bottom;
      let over = fora();
      if (over <= 0) return;
      /* em column-reverse o sinal do scrollTop não é o mesmo em todos os motores: tenta-se
         um lado, mede-se outra vez, e se piorou vai-se para o outro. Sem adivinhar. */
      const antes = box.scrollTop;
      box.scrollTop = antes + Math.ceil(over) + 4;
      if (fora() > 0) box.scrollTop = antes - Math.ceil(over) - 4;
      if (fora() > 0) box.scrollTop = antes;   /* nenhum dos lados ajudou: fica como estava */
    };
    go();
    /* os cartões novos entram com uma animação de .5 s: a altura final só se sabe depois */
    clearTimeout(keepNewestVisible._t);
    keepNewestVisible._t = setTimeout(go, 60);
  }

  /* ---------- Notification Center ---------- */
  function init() {
    nc = UI.el('<div id="nc"><div class="nc-head"><div class="d"></div><div class="t"></div></div><div class="nc-list"></div></div>');
    head = nc.querySelector('.nc-head'); list = nc.querySelector('.nc-list');
    UI.screen().appendChild(nc);
    UI.swipe(nc, { up: close, threshold: 60 });
    nc.onclick = e => { if (e.target === nc || e.target === list || e.target === head) close(); };
    /* tocar fora fecha o cartão aberto / desarma o "Limpar" */
    UI.screen().addEventListener('pointerdown', e => { if (openCard && !openCard.contains(e.target)) closeCard(); if (armed && !armed.contains(e.target)) disarm(); }, true);
    const unshrink = () => { const l = document.getElementById('lock'); if (l) l.classList.remove('nc-scroll'); };
    Bridge.on('unlock', () => { const ln = document.querySelector('.lock-notifs'); if (ln) ln._ids = null; expanded.clear(); lockOpen = false; unshrink(); });
    Bridge.on('lock', () => { lockOpen = false; expanded.clear(); unshrink(); });
    /* tocar no fundo de ecrã (fora da lista) fecha a lista para a pilha/contagem, como no iOS */
    UI.screen().addEventListener('pointerdown', e => { if (!System.locked || !lockOpen) return; const ln = document.querySelector('.lock-notifs'); if (ln && !ln.contains(e.target) && !e.target.closest('.lock-shortcuts,.lock-np,.n-xwrap,.ctx,.overlay,.als-fp,.als-mx,#qp,.lke-handle,.lke-card,.lke-more,.lke-row')) collapseLock(); }, true);   /* .als-fp/.als-mx: sensor de impressao digital e Now Bar do Android; #qp: o painel rapido por cima; .lke-*: pega do relogio e pecas do editor do PearOS 27 (lockeditor.js) - mexer nelas nao fecha a lista */
    /* a pré-visualização "Desbloqueado" depende do bloqueio: ao desbloquear, o centro (se aberto) volta a mostrar o texto */
    Bridge.on('unlock', () => refresh()); Bridge.on('lock', () => refresh());
    if (window.System && System.player && System.player.citizenid != null) lastCid = lastCid || String(System.player.citizenid);
    sync();   /* histórico do servidor ao arrancar (o push "session" volta a pedi-lo quando a personagem carrega) */
  }
  function refresh() { if (nc && nc.classList.contains('in')) render(list); }
  /* No Android o centro de notificacoes e o painel de notificacoes da Nova UI (QuickPanel, shell/android-panel.js):
     openNC/close/toggle/isOpen delegam nele (gesto, F8, ecra bloqueado e Definicoes › Historico continuam a funcionar) */
  function openNC() {
    if (android()) { if (window.QuickPanel && QuickPanel.open) QuickPanel.open('notif'); return; }
    if (!nc) return; if (banner) banner.hide(true); /* o banner recolhe ao abrir o centro */ const d = new Date(); head.querySelector('.d').textContent = UI.fmtDate(d, false, true); head.querySelector('.t').textContent = UI.fmtTime(d);   /* "terça-feira, 8 de setembro" (minúsculas, como no ecrã bloqueado) */ list._ids = null; render(list); nc.classList.add('in'); UI.screen().classList.add('nc-on'); /* 1.5.0: a barra de estado fica branca por cima (glass27.css, tom automático) */ Bridge.emit('overlay', 'nc'); }
  function close() { if (android() && window.QuickPanel && QuickPanel.close) QuickPanel.close(); ncExp.clear(); if (nc) { nc.classList.remove('in'); const s = UI.screen(); if (s) s.classList.remove('nc-on'); } closeCard(); disarm(); dismissOverlay(); }
  const isOpen = () => android() ? !!(window.QuickPanel && QuickPanel.isOpen && QuickPanel.isOpen()) : !!(nc && nc.classList.contains('in'));
  const toggle = () => { if (android()) { if (window.QuickPanel && QuickPanel.toggle) QuickPanel.toggle('notif'); return; } if (isOpen()) close(); else openNC(); };
  return { push, open, remove, clear, markRead, readAll, unread, all, render, renderLock, init, refresh, openNC, close, toggle, isOpen,
    mute, isMuted, expandGroup: app => { expanded.add(app); renderLock(); }, collapseGroup: app => { expanded.delete(app); renderLock(); }, banner: showBanner, toast,
    collapseLock, expandLock, get lockOpen() { return lockOpen; }, MODES, mode,
    appSettings, setAppSettings, sync, DEFAULTS: NDEF,
    /* pecas internas para o painel e a notificacao flutuante da Nova UI (android-panel.js): o mesmo cartao, a mesma
       pre-visualizacao, as mesmas acoes e o mesmo menu de opcoes, sem copias */
    _ui: { preview, actionsFor, runAction, inner: innerA, paint: paintA, options: (n, el) => options(n, el), expand: (n, el, ctx) => expand(n, el, ctx), isMuted, emit: emitChanged },
    /* só para o harness (html/_test.html): provar que os `onTap` das notificações caídas do
       limite dos 100 são largados, em vez de ficarem a agarrar a janela da app que os criou */
    debugCounts: () => ({ handlers: Object.keys(handlers).length, acts: Object.keys(acts).length, media: Object.keys(media).length }) };
})();
