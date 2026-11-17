/* ===================== RECADO - núcleo da app (pacote RA) =====================
   Contrato: docs/ARQUITETURA.md §9 (9.5 APIs entre módulos, 9.6 RPCs).

   O que vive onde:
     · window.Recado (este IIFE) sobrevive ao killApp: registo dos módulos irmãos e dos separadores, a cache das
       conversas (recado.threads), o "a escrever…"/"a gravar áudio…" em tempo real, o emblema do ícone e as
       notificações das mensagens recebidas - é a NUI que avisa (como nas SMS), porque só ela sabe se a conversa
       está à vista; quem estava desligado recebe um resumo do servidor ao entrar.
     · App.define('recado') é a janela: separadores Conversas · Atualizações (RE) · Comunidades (RE) · Chamadas (RF),
       a lista de conversas, as arquivadas, as mensagens com estrela e o centro de definições.
     · No fim do ficheiro ficam os mocks do browser (LocalDB.register) dos RPCs do RA (que o RB também usa).

   Módulos irmãos: este ficheiro carrega DEPOIS de recado-extras/people/updates/calls/chat. Cada um pode chamar
   Recado.register(nome, api) / Recado.registerTab(chave, def) quando existir (evento 'recado:ready'), e mesmo sem
   isso o RA encontra-os pelos globais (RecadoChat, RecadoPeople, RecadoExtras, RecadoUpdates, RecadoCalls).

   Regras do CEF: sem filter/backdrop-filter, só transform/opacity animam, imagens (base64) só por CSSOM.
   Honestidade (§9.2): nada aqui afirma encriptação; o "ver uma vez" não impede capturas de ecrã. */

/* Ícone do Zapp. Antes: balão branco cheio com um raio verde dentro (o "zap").
   2026-10-01 (pedido do dono: icones mais parecidos com as apps reais): balao redondo em CONTORNO branco com o
   telefone dentro, sobre o verde, como o do WhatsApp */
Icons.app.recado = () => Icons.SVG(
  '<defs><linearGradient id="gRcd" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#5DF07E"/><stop offset="1" stop-color="#1FAF4C"/></linearGradient></defs><rect width="100" height="100" fill="url(#gRcd)"/>'
  + Icons.GL('<path d="M50 19.5c-16.9 0-30.5 13.4-30.5 30 0 5.8 1.7 11.3 4.6 15.9L20 80.5l15.6-4c4.3 2.3 9.2 3.5 14.4 3.5 16.9 0 30.5-13.4 30.5-30S66.9 19.5 50 19.5z" fill="none" stroke="#fff" stroke-width="5.5" stroke-linejoin="round"/>'
  + '<path fill="#fff" transform="translate(35.5 34.5) scale(1.22)" d="M6.6 10.8c1.4 2.8 3.8 5.1 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1C10.6 21 3 13.4 3 4c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1L6.6 10.8z"/>'));

window.Recado = (() => {
  const APP = 'recado';
  const g = (n, s) => Icons.g(n, s);
  const esc = s => UI.esc(s);
  const int = v => { const n = Math.floor(+v); return isFinite(n) ? n : 0; };
  /* o json.encode do FiveM manda uma tabela Lua vazia como {} (e uma esparsa como objeto): tudo o que é lista passa por aqui */
  const arr = r => Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error ? Object.values(r).filter(x => x && typeof x === 'object') : []);
  const vals = r => Array.isArray(r) ? r : (r && typeof r === 'object' ? Object.values(r) : []);
  const FOREVER = 4102444800000;   /* "silenciar sempre" = 1 jan 2100, como no server/messages.lua */
  const myNumber = () => String((window.System && System.player && System.player.phone) || (window.System && System.account && System.account.phone) || '');

  /* ---------- Config.Recado ----------
     O `ready` do client.lua ainda não traz o Config.Recado (pedido fora deste pacote): enquanto não chegar ao
     System.config valem os valores do config_recado.lua. O servidor decide sempre; aqui só se escondem opções. */
  function cfg() {
    const r = (window.System && System.config && System.config.recado && typeof System.config.recado === 'object') ? System.config.recado : {};
    const pos = (v, d, lo, hi) => { const n = Math.floor(+v); return isFinite(n) && n >= lo ? Math.min(hi, n) : d; };
    const dis = vals(r.disappearing).map(x => Math.floor(+x)).filter(x => x > 0);
    const calls = r.calls && typeof r.calls === 'object' ? r.calls : {};
    return {
      pinsMax: pos(r.pinsMax, 3, 1, 20), forwardMax: pos(r.forwardMax, 5, 1, 20), multiImageMax: pos(r.multiImageMax, 10, 1, 30),
      captionMax: pos(r.captionMax, 1000, 1, 4000), textMax: pos(r.textMax, 4000, 1, 60000), hdImageBytes: pos(r.hdImageBytes, 520000, 1000, 16e6),
      disappearing: dis.length ? dis : [86400, 604800, 7776000], pinnedChats: 3,
      calls: { maxGroupParticipants: pos(calls.maxGroupParticipants, 8, 2, 64), screenShare: calls.screenShare === true, videoProvider: String(calls.videoProvider || 'simulated') },
      gif: { provider: String((r.gif && r.gif.provider) || 'none') }
    };
  }
  const ttlText = secs => { secs = int(secs); if (secs <= 0) return 'Desligadas'; if (secs % 86400 === 0) { const d = secs / 86400; return d === 1 ? '24 horas' : d + ' dias'; } if (secs % 3600 === 0) return (secs / 3600) + ' horas'; return Math.max(1, Math.round(secs / 60)) + ' minutos'; };

  /* ---------- glifos próprios (os do sistema não têm arquivo, pino cheio, temporizador) ---------- */
  const SVG = (inner, fill) => `<svg class="rc-gl" viewBox="0 0 24 24" ${fill ? 'fill="currentColor" stroke="none"' : 'fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"'}>${inner}</svg>`;
  const SV = {
    archive: SVG('<rect x="3" y="4" width="18" height="5" rx="1.5"/><path d="M5 9v9.5A1.5 1.5 0 0 0 6.5 20h11a1.5 1.5 0 0 0 1.5-1.5V9M10 13h4"/>'),
    pin: SVG('<path d="M15.2 2.8a1.2 1.2 0 0 1 1.7 0l4.3 4.3a1.2 1.2 0 0 1 0 1.7l-1 1a1.2 1.2 0 0 1-1.3.3l-.6-.2-3.6 3.6.4 3a1.2 1.2 0 0 1-.4 1l-.9.9a1.2 1.2 0 0 1-1.7 0l-3.1-3.1-4.6 4.6a1 1 0 0 1-1.4-1.4l4.6-4.6-3.1-3.1a1.2 1.2 0 0 1 0-1.7l.9-.9a1.2 1.2 0 0 1 1-.4l3 .4 3.6-3.6-.2-.6a1.2 1.2 0 0 1 .3-1.3z"/>', true),
    muted: SVG('<path d="M8.7 3A6 6 0 0 1 18 8c0 2 .3 3.7.9 5M17 17H3s3-2 3-9M10.3 21a1.94 1.94 0 0 0 3.4 0M2 2l20 20"/>'),
    lock: SVG('<rect x="4" y="11" width="16" height="10" rx="2.2"/><path d="M8 11V7.5a4 4 0 0 1 8 0V11"/>'),
    timer: SVG('<circle cx="12" cy="13" r="8"/><path d="M12 9v4l2.6 1.6M9.5 2.5h5"/>'),
    unread: SVG('<path d="M20 11.5a8 8 0 0 1-11.6 7.1L4 20l1.3-4.1A8 8 0 1 1 20 11.5z"/><circle cx="18.5" cy="5.5" r="3.2" fill="currentColor" stroke="none"/>'),
    read: SVG('<circle cx="12" cy="12" r="9"/><path d="m8 12.2 2.8 2.8L16.5 9"/>'),
    starFill: SVG('<path d="m12 2.6 2.9 5.9 6.5.9-4.7 4.6 1.1 6.5L12 17.4l-5.8 3.1 1.1-6.5L2.6 9.4l6.5-.9z"/>', true)
  };
  const ART_CHATS = '<svg viewBox="0 0 168 132" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="rcEg1" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#128C7E"/><stop offset="1" stop-color="#25D366"/></linearGradient></defs>'
    + '<circle cx="84" cy="66" r="62" fill="url(#rcEg1)" opacity=".1"/><path d="M38 26h54l16 16v34a10 10 0 0 1-10 10H66L48 100V86H38a10 10 0 0 1-10-10V36a10 10 0 0 1 10-10z" fill="url(#rcEg1)"/>'
    + '<path d="M92 26v12a4 4 0 0 0 4 4h12z" fill="#fff" opacity=".45"/><path d="M44 50h40M44 64h24" stroke="#fff" stroke-width="7" stroke-linecap="round"/>'
    + '<path d="M106 62h24a10 10 0 0 1 10 10v22a10 10 0 0 1-10 10h-1v11l-14-11h-9a10 10 0 0 1-10-10V72a10 10 0 0 1 10-10z" style="fill:var(--rc-list-bg)" stroke="url(#rcEg1)" stroke-width="3.2"/>'
    + '<circle cx="108" cy="83" r="3.6" fill="#128C7E"/><circle cx="118" cy="83" r="3.6" fill="#1FAF7A"/><circle cx="128" cy="83" r="3.6" fill="#25D366"/></svg>';
  /* ✓ enviada · ✓✓ entregue · ✓✓ (ciano) lida */
  const tick = s => s === 'read' || s === 'delivered'
    ? `<svg class="rc-tick${s === 'read' ? ' read' : ''}" viewBox="0 0 18 11"><path d="M1 6l3 3.2L10.5 2"/><path d="M8.4 9.2L15.8 2"/></svg>`
    : s === 'sent' ? '<svg class="rc-tick one" viewBox="0 0 12 11"><path d="M1 6l3 3.2L10.5 2"/></svg>' : '';

  /* =====================================================================
     REGISTO DE MÓDULOS E SEPARADORES
     ===================================================================== */
  const GLOBALS = { chat: 'RecadoChat', people: 'RecadoPeople', extras: 'RecadoExtras', updates: 'RecadoUpdates', calls: 'RecadoCalls' };
  const apis = {}, tabs = {};
  const NAME_OK = /^[a-z][a-z0-9_-]{0,23}$/;
  function register(name, api) {
    if (typeof name !== 'string' || !NAME_OK.test(name) || !api || (typeof api !== 'object' && typeof api !== 'function')) return false;
    apis[name] = api; tabsDirty(); Bridge.emit('recado:registered', name); return true;
  }
  function get(name) {
    if (apis[name]) return apis[name];
    const gl = GLOBALS[name]; const o = gl ? window[gl] : null;
    return o && typeof o === 'object' ? o : null;
  }
  function registerTab(key, def) {
    if (typeof key !== 'string' || !NAME_OK.test(key) || key === 'chats' || !def || typeof def.view !== 'function') return false;
    tabs[key] = { key, icon: typeof def.icon === 'string' ? def.icon : 'grid', label: String(def.label || key).slice(0, 16), order: isFinite(+def.order) ? +def.order : 50, view: def.view };
    tabsDirty(); return true;
  }
  /* os separadores: Conversas sempre; os outros registados ou, sem registo, pelos globais do RE/RF */
  function tabList() {
    const out = [{ key: 'chats', icon: 'chat', label: 'Conversas', order: 0, view: () => chatsView() }];
    Object.keys(tabs).forEach(k => out.push(tabs[k]));
    const auto = (key, icon, label, order, mod, fn) => { if (tabs[key]) return; const m = get(mod); if (m && typeof m[fn] === 'function') out.push({ key, icon, label, order, view: w => m[fn](w) }); };
    auto('updates', 'sparkles', 'Atualizações', 10, 'updates', 'updatesView');
    auto('communities', 'users', 'Comunidades', 20, 'updates', 'communitiesView');
    auto('calls', 'phone', 'Chamadas', 30, 'calls', 'callsView');
    /* empate na ordem (RE e RF pedem ambos 30): vale a ordem do contrato Conversas · Atualizações · Comunidades · Chamadas */
    const CANON = ['chats', 'updates', 'communities', 'calls'], ci = k => { const i = CANON.indexOf(k); return i < 0 ? 99 : i; };
    return out.sort((a, b) => (a.order - b.order) || (ci(a.key) - ci(b.key)));
  }

  /* =====================================================================
     ESTADO E CACHE DAS CONVERSAS
     ===================================================================== */
  let win = null, tabsApi = null, tabKeys = [], tabSig = '';
  let listView = null, archView = null;
  let threads = null, loading = null, fetchSeq = 0, threadsErr = null;
  let filter = 'all', query = '';
  let unlockedUntil = 0;
  const names = new Map();      /* número → nome do perfil do Recado (quem não está nos contactos) */
  const activity = new Map();   /* 'chave|quem' → { key, from, kind: typing|recording, until } */

  const keyOfTarget = t => {
    if (!t || typeof t !== 'object') return '';
    const c = int(t.conversation) || int(t.group && t.group.id) || (typeof t.number === 'string' && /^g:\d+$/.test(t.number) ? int(t.number.slice(2)) : 0);
    if (c > 0) return 'g:' + c;
    return t.number != null && String(t.number) !== '' ? 'n:' + String(t.number).slice(0, 20) : '';
  };
  const targetOf = t => { const k = keyOfTarget(t); return !k ? null : k.charAt(0) === 'g' ? { conversation: int(k.slice(2)) } : { number: k.slice(2) }; };
  const find = key => (threads && key) ? threads.find(t => t.key === key) || null : null;

  function normThread(t) {
    if (!t || typeof t !== 'object') return null;
    const k = keyOfTarget(t); if (!k) return null;
    const o = Object.assign({}, t);
    o.key = k;
    if (k.charAt(0) === 'g') {
      o.conversation = int(k.slice(2)); delete o.number;
      o.group = Object.assign({ id: o.conversation }, t.group && typeof t.group === 'object' ? t.group : {});
      o.name = String(o.name || o.group.title || 'Grupo').slice(0, 60);
    } else {
      o.number = k.slice(2); delete o.conversation;
      o.name = String(o.name || o.profileName || o.number).slice(0, 60);
      if (o.profileName && !o.isContact) names.set(o.number, String(o.profileName).slice(0, 40));
    }
    o.unread = Math.max(0, int(t.unread)); o.pinned = !!t.pinned; o.archived = !!t.archived; o.markedUnread = !!t.markedUnread; o.locked = !!t.locked;
    o.mutedUntil = +t.mutedUntil > Date.now() ? +t.mutedUntil : 0; o.disappearing = Math.max(0, int(t.disappearing));
    o.online = !!t.online; o.lastSeen = +t.lastSeen || 0; o.avatar = int(t.avatar) || 0;
    o.last = t.last && typeof t.last === 'object' ? Object.assign({}, t.last) : null;
    o.ts = +t.ts || (o.last && +o.last.created) || 0;
    return o;
  }
  const isMuted = t => !!t && t.mutedUntil > Date.now();
  const sortThreads = l => l.sort((a, b) => (b.pinned - a.pinned) || ((+b.ts || 0) - (+a.ts || 0)));

  function fetchThreads() {
    if (loading) return loading;
    const id = ++fetchSeq;
    const p = Promise.resolve().then(() => Bridge.rpcRaw('recado.threads', {})).catch(() => null).then(r => {
      if (id !== fetchSeq) return threads;   /* invalidado a meio: quem pediu depois escreve */
      loading = null;
      /* um erro (servidor sem resposta, sem número) NÃO apaga o que já se sabia; sem nada em cache a lista mostra o erro
         (antes ficava o esqueleto a piscar para sempre com o Recado desligado ou a base de dados por preparar) */
      if (r && !r.error && typeof r === 'object') { threads = arr(r).map(normThread).filter(Boolean); threadsErr = null; updateBadge(); }
      else threadsErr = (r && typeof r.error === 'string') ? r.error : 'rpc';
      return threads;
    });
    loading = p;
    return p;
  }
  const invalidate = () => { fetchSeq++; loading = null; };
  let refT = null;
  function refetchSoon(ms) { clearTimeout(refT); refT = setTimeout(() => { refT = null; invalidate(); fetchThreads().then(() => paintSoon()); }, ms == null ? 700 : ms); }

  function unreadTotal() { return (threads || []).reduce((a, t) => a + ((t.archived || isMuted(t)) ? 0 : (t.unread || (t.markedUnread ? 1 : 0))), 0); }
  function updateBadge() {
    if (!threads) return;
    const n = unreadTotal();
    try { System.badge(APP, n); } catch (e) {}
    if (tabsApi) { const i = tabKeys.indexOf('chats'); if (i > -1) tabsApi.badge(i, n); }
  }

  /* =====================================================================
     NOMES, AVATARES, PERFIL, PRÉ-VISUALIZAÇÕES
     ===================================================================== */
  let profile = null, profileAt = 0;
  function me() {
    const p = profile || {}, pl = (window.System && System.player) || {};
    const fallback = [pl.firstname, pl.lastname].filter(Boolean).join(' ') || (window.System && System.account && System.account.username) || 'Eu';
    return { number: myNumber(), name: String(p.name || fallback).slice(0, 40), avatar: int(p.avatarMedia || p.avatar) || null, about: typeof p.about === 'string' ? p.about : '' };
  }
  async function loadProfile(force) {
    if (!force && profile && Date.now() - profileAt < 60000) return profile;
    let r = null; try { r = await Bridge.rpcRaw('recado.profile.me', {}); } catch (e) { r = null; }
    if (r && typeof r === 'object' && !r.error && r.ok !== false) { profile = r.profile && typeof r.profile === 'object' ? r.profile : r; profileAt = Date.now(); }
    return profile;
  }
  function nameOf(number) {
    const n = String(number == null ? '' : number); if (!n) return '';
    if (n === myNumber()) return 'Tu';
    const c = window.Contacts && Contacts.byNumber ? Contacts.byNumber(n) : null;
    if (c && c.name) return c.name;
    return names.get(n) || n;
  }
  const hash = s => { let h = 7; for (const ch of String(s)) h = (h * 31 + ch.charCodeAt(0)) % 9973; return h; };
  const isImg = u => typeof u === 'string' && /^data:image\/(jpeg|jpg|png|webp);base64,/i.test(u);
  function mediaUrl(mid) {
    mid = int(mid); if (!(mid > 0)) return Promise.resolve(null);
    try {
      if (window.Msgs && typeof Msgs.media === 'function') return Msgs.media(mid).then(r => (r && isImg(r.url)) ? r.url : null).catch(() => null);
      if (window.VoiceMsg && typeof VoiceMsg.fetchMedia === 'function') return VoiceMsg.fetchMedia(mid).then(r => (r && isImg(r.dataUrl)) ? r.dataUrl : null).catch(() => null);
    } catch (e) {}
    return Promise.resolve(null);
  }
  /* Recado.avatar(host, { number?, conversation?, mediaId?, name? }) - pinta o avatar no elemento (gradiente + iniciais,
     glifo de grupo, foto do perfil/grupo pelo media.get, ou a foto do contacto). A imagem entra SEMPRE por CSSOM. */
  function avatar(host, o) {
    o = o || {};
    if (!host || host.nodeType !== 1) host = document.createElement('div');
    const conv = int(o.conversation), num = o.number != null ? String(o.number).slice(0, 20) : '';
    const th = conv ? find('g:' + conv) : (num ? find('n:' + num) : null);
    const mid = int(o.mediaId) || (th ? int(th.avatar) : 0);
    let nm = o.name ? String(o.name) : conv ? ((th && th.name) || 'Grupo') : nameOf(num);
    if (nm === 'Tu') nm = me().name;
    host.classList.add('avatar', 'rc-av'); host.classList.remove('has-img');
    host.setAttribute('style', UI.avatarStyle(hash(conv ? 'g' + conv : (num || nm))));
    host.innerHTML = conv ? g('users') : esc(UI.initials(nm));
    const tok = String(Math.random()); host.dataset.rcTok = tok;
    const put = url => { if (!url || host.dataset.rcTok !== tok) return; host.style.backgroundImage = UI.img(url); host.classList.add('has-img'); host.textContent = ''; };
    if (mid) mediaUrl(mid).then(put);
    else if (!conv && num && window.Contacts && typeof Contacts.byNumber === 'function' && typeof Contacts.paintAvatar === 'function') {
      const c = Contacts.byNumber(num);
      if (c && Contacts.photoId && Contacts.photoId(c)) Contacts.paintAvatar(host, c, false).then(ok => { if (ok) host.classList.add('has-img'); });
    }
    return host;
  }

  const plain = s => String(s == null ? '' : s).replace(/```([\s\S]*?)```/g, '$1').replace(/(^|\s)[*_~`]+|[*_~`]+(?=\s|$)/g, '$1').replace(/\s+/g, ' ').trim();
  const durTxt = d => { d = +d || 0; if (d <= 0) return ''; return UI.fmtDur(d > 600 ? d / 1000 : d); };
  function sysText(m) {
    const p = m.payload && typeof m.payload === 'object' ? m.payload : {}, mine = p.by && p.by === myNumber();
    if (p.action === 'disappearing') {
      const secs = int(p.seconds);
      if (p.default && secs > 0) return 'Mensagens temporárias ativadas (' + ttlText(secs) + ') pelo temporizador por omissão';
      if (secs > 0) return (mine ? 'Ativaste' : nameOf(p.by) + ' ativou') + ' as mensagens temporárias (' + ttlText(secs) + ')';
      return (mine ? 'Desativaste' : nameOf(p.by) + ' desativou') + ' as mensagens temporárias';
    }
    if (window.Msgs && typeof Msgs.sysText === 'function') { try { return Msgs.sysText(m, x => names.get(x) || null); } catch (e) {} }
    return plain(m.content);
  }
  /* Recado.label(msg) - texto curto de uma mensagem (lista, notificações, respostas, pesquisa) */
  function label(m) {
    if (!m || typeof m !== 'object') return '';
    if (m.deleted) return m.sender === myNumber() ? 'Apagaste esta mensagem' : 'Esta mensagem foi apagada';
    const p = m.payload && typeof m.payload === 'object' ? m.payload : {}, vo = !!(m.viewOnce || p.viewOnce);
    switch (m.type || 'text') {
      case 'text': return plain(m.content) || m.preview || '';
      case 'image': return vo ? '📷 Foto · ver uma vez' : '📷 ' + (plain(m.content) || 'Foto');
      case 'audio': { const d = durTxt(p.duration); return vo ? '🎤 Mensagem de voz · ver uma vez' : '🎤 Mensagem de voz' + (d ? ' (' + d + ')' : ''); }
      case 'location': return '📍 ' + (p.label || plain(m.content) || 'Localização');
      case 'contact': return '👤 ' + (p.name || plain(m.content) || 'Contacto');
      case 'sticker': return '🏷️ Autocolante';
      case 'gif': return 'GIF';
      case 'document': return '📄 ' + (p.title || plain(m.content) || 'Documento');
      case 'poll': return '📊 ' + (plain(m.content) || 'Sondagem');
      case 'event': return '📅 ' + (plain(m.content) || p.title || 'Evento');
      case 'call': return p.status === 'missed' ? (p.video ? '🎥 Videochamada perdida' : '📞 Chamada perdida') : p.status === 'scheduled' ? '🗓️ Chamada agendada' : (p.video ? '🎥 Videochamada' : '📞 Chamada de voz');
      case 'system': return sysText(m);
    }
    return plain(m.content) || m.preview || '';
  }

  /* ---------- erros por extenso (códigos do server/recado.lua, messages.lua, groups.lua e media.lua) ---------- */
  const ERR = {
    ratelimit: 'Demasiados pedidos seguidos, espera um instante', toolarge: 'O anexo é demasiado grande', window: 'Já passou o tempo para fazer isso',
    notsender: 'Só podes fazer isso com mensagens que enviaste', notmember: 'Já não és membro deste grupo', forbidden: 'Sem permissão', notfound: 'Esta conversa ou mensagem já não existe',
    media: 'O anexo já não está disponível', badmedia: 'O anexo já não está disponível', blocked: 'Bloqueaste este contacto: desbloqueia-o para lhe escreveres',
    target: 'Destinatário inválido', noidentity: 'Este telemóvel não tem número', badreaction: 'Reação inválida', badreply: 'A mensagem a que respondes já não existe',
    badtype: 'Tipo de mensagem inválido', badpayload: 'O conteúdo da mensagem não é válido', nottext: 'Só se editam mensagens de texto',
    unsupported: 'Isto não é possível com esta mensagem', invalid: 'Pedido inválido', deleted: 'A mensagem foi apagada', empty: 'A mensagem está vazia',
    busy: 'Há outro envio a decorrer, espera um instante', baddata: 'O ficheiro chegou estragado', badmime: 'Formato de ficheiro não suportado',
    viewed: 'Já abriste esta mensagem', viewonce: 'Uma mensagem de ver uma vez não se reencaminha', mine: 'Não podes abrir a tua própria mensagem de ver uma vez',
    pinlimit: 'Chegaste ao limite de mensagens fixadas', adminsonly: 'Só os administradores podem fazer isto neste grupo', notadmin: 'Só os administradores podem fazer isto',
    locked: 'Esta conversa está bloqueada', badpin: 'Código errado', pinlocked: 'Demasiadas tentativas, espera um pouco', toomany: 'Demasiados destinos de uma vez',
    nogif: 'Os GIF não estão ativos neste servidor', badsticker: 'Autocolante inválido', badgif: 'GIF inválido', baddoc: 'Documento inválido', limit: 'Chegaste ao limite',
    duplicate: 'Destino repetido', disabled: 'O Zapp está desligado neste servidor', db: 'A base de dados ainda não está pronta', internal: 'Erro no servidor',
    noplayer: 'Sessão do jogador não encontrada', rpc: 'Sem resposta do servidor', nogroups: 'Os grupos não estão disponíveis neste servidor', self: 'Não podes fazer isso contigo'
  };
  function errorText(code, fallback) {
    if (code && typeof code === 'object') code = code.error;
    return (typeof code === 'string' && ERR[code]) || fallback || 'Não foi possível concluir. Tenta outra vez.';
  }

  /* =====================================================================
     ABRIR CONVERSAS, DESBLOQUEAR
     ===================================================================== */
  const visibleApp = () => System.currentApp() === APP && !System.locked && !(Bridge.inFiveM && document.body.classList.contains('hidden'));
  function chatCurrentKey() {
    const chat = get('chat'); if (!chat || typeof chat.current !== 'function') return '';
    try { const c = chat.current(); return c ? (keyOfTarget(c) || keyOfTarget(c.target)) : ''; } catch (e) { return ''; }
  }
  /* abre a app (também atrás do código do ecrã bloqueado) e espera pela janela */
  function whenOpen() {
    return new Promise(res => {
      if (System.currentApp() === APP && win) { res(true); return; }
      let t = null;
      const off = Bridge.on('app:open', id => { if (id !== APP) return; off(); clearTimeout(t); setTimeout(() => res(!!win), 90); });
      t = setTimeout(() => { off(); res(false); }, 20000);
      System.openApp(APP);
    });
  }
  async function pinUnlock() {
    for (let i = 0; i < 5; i++) {
      const pin = await UI.prompt('Conversa bloqueada', i ? 'Código errado. Tenta outra vez.' : 'Introduz o código do telemóvel para abrir.', 'Código', '', 'password');
      if (pin == null) return false;
      let r = null; try { r = await Bridge.rpcRaw('recado.unlock', { pin }); } catch (e) { r = null; }
      if (r && r.ok) { unlockedUntil = Date.now() + 9 * 60000; return true; }
      if (!r || r.lockedUntil || (r.error && r.error !== 'badpin')) { UI.toast(r && r.wait ? `Demasiadas tentativas, espera ${int(r.wait)} s` : errorText(r, 'Sem resposta do servidor')); return false; }
    }
    return false;
  }
  /* Recado.unlock(target, force) - código do telemóvel (RecadoPeople.unlockChat se existir). A autorização vive no
     servidor (10 min ou até guardar o telemóvel); aqui só se evita perguntar outra vez logo a seguir. */
  async function unlock(target, force) {
    if (!force && Date.now() < unlockedUntil) return true;
    const people = get('people');
    if (people && typeof people.unlockChat === 'function') {
      let ok = false; try { ok = !!(await people.unlockChat(targetOf(target))); } catch (e) { ok = false; }
      if (ok) unlockedUntil = Date.now() + 9 * 60000;
      return ok;
    }
    return pinUnlock();
  }
  /* Recado.openChat({ number } | { conversation }, { messageId? }) */
  async function openChat(target, opts) {
    opts = opts || {};
    const tg = targetOf(target); if (!tg) return false;
    if (!(await whenOpen())) return false;
    if (!threads) { try { await fetchThreads(); } catch (e) {} }
    const key = keyOfTarget(tg), th = find(key);
    if (th && th.locked && !(await unlock(tg))) return false;
    const chat = get('chat');
    if (!chat || typeof chat.open !== 'function') { UI.toast('O ecrã da conversa ainda não está disponível'); return false; }
    if (tabsApi && tabKeys[tabsApi.cur] !== 'chats' && chatCurrentKey() !== key) showTab('chats');
    /* o chat mostra a faixa "N mensagens não lidas" e posiciona-se nela: o valor guarda-se ANTES de o pôr a 0 */
    const unreadBefore = th ? th.unread : 0;
    if (th) { th.unread = 0; th.markedUnread = false; paintSoon(); updateBadge(); }
    const tgOpen = th ? Object.assign({}, tg, { unread: unreadBefore, disappearing: th.disappearing, name: th.name }) : tg;
    try { chat.open(win, tgOpen, opts.messageId ? { messageId: int(opts.messageId) } : {}); }
    catch (e) { console.error('[apex_phone] Recado: abrir conversa', e); UI.toast('Não foi possível abrir a conversa'); return false; }
    return true;
  }
  function showTab(key) {
    if (!tabsApi) return false;
    const i = tabKeys.indexOf(key); if (i < 0) return false;
    tabsApi.go(i); return true;
  }
  /* uma função de um módulo irmão que pode devolver uma vista, uma promessa ou nada */
  function callMod(mod, fn, ...args) {
    const m = get(mod);
    if (!m || typeof m[fn] !== 'function') { UI.toast('Ainda não está disponível nesta versão'); return null; }
    let out = null;
    try { out = m[fn](win, ...args); } catch (e) { console.error('[apex_phone] Recado:', mod + '.' + fn, e); UI.toast('Não foi possível abrir'); return null; }
    const push = x => { if (x && x.nodeType === 1 && x.classList.contains('view') && !x.isConnected && win) UI.push(win, x); };
    if (out && typeof out.then === 'function') out.then(x => { push(x); refetchSoon(400); }, () => {}); else push(out);
    return out;
  }

  /* =====================================================================
     AÇÕES SOBRE UMA CONVERSA
     ===================================================================== */
  async function setThread(t, patch) {
    const tg = targetOf(t); if (!tg) return null;
    let r = null; try { r = await Bridge.rpcRaw('recado.thread.set', Object.assign({}, tg, patch)); } catch (e) { r = null; }
    if (!r || r.error || r.ok === false) {
      UI.toast(r && r.error === 'pinlimit' ? `Só podes fixar ${int(r.max) || 3} conversas` : errorText(r, 'Não foi possível guardar'));
      return null;
    }
    const th = find(keyOfTarget(tg)) || t;
    if (r.pinned !== undefined) th.pinned = !!r.pinned;
    if (patch.mutedUntil !== undefined) th.mutedUntil = +r.mutedUntil > Date.now() ? +r.mutedUntil : 0;
    if (r.archived !== undefined) th.archived = !!r.archived;
    if (r.markedUnread !== undefined) th.markedUnread = !!r.markedUnread;
    if (r.locked !== undefined) th.locked = !!r.locked;
    if (r.disappearing !== undefined) th.disappearing = Math.max(0, int(r.disappearing));
    paintSoon(); updateBadge();
    Bridge.emit('recado:thread', { key: keyOfTarget(tg), target: tg, result: r });
    return r;
  }
  async function markRead(t) {
    const tg = targetOf(t); if (!tg) return;
    const th = find(keyOfTarget(tg)) || t;
    if (th.unread > 0) { try { await Bridge.rpcRaw('messages.read', Object.assign({ app: APP }, tg)); } catch (e) {} }
    th.unread = 0;
    if (th.markedUnread) await setThread(th, { markedUnread: false }); else { paintSoon(); updateBadge(); }
  }
  const toggleRead = t => (t.unread > 0 || t.markedUnread) ? markRead(t) : setThread(t, { markedUnread: true });
  function togglePin(t) {
    const max = cfg().pinnedChats;
    if (!t.pinned && (threads || []).filter(x => x.pinned && !x.archived).length >= max) { UI.toast(`Só podes fixar ${max} conversas`); return; }
    setThread(t, t.archived && !t.pinned ? { archived: false, pinned: true } : { pinned: !t.pinned });
  }
  const untilTxt = x => { const d = new Date(+x); return d.toDateString() === new Date().toDateString() ? 'hoje às ' + UI.fmtTime(d) : UI.fmtDate(d, true) + ', ' + UI.fmtTime(d); };
  async function muteMenu(t) {
    const muted = isMuted(t);
    const buttons = muted ? [{ label: 'Reativar alertas', value: 'off' }] : [{ label: '8 horas', value: 8 * 3600e3 }, { label: '1 semana', value: 7 * 864e5 }, { label: 'Sempre', value: 'always' }];
    const title = muted ? (t.mutedUntil >= FOREVER - 864e5 ? 'Alertas silenciados para sempre' : 'Silenciada até ' + untilTxt(t.mutedUntil)) : 'Silenciar «' + t.name + '»';
    const v = await UI.actionSheet({ title, buttons });
    if (v == null) return;
    await setThread(t, { mutedUntil: v === 'off' ? false : v === 'always' ? true : Date.now() + v });
  }
  async function toggleArchive(t) {
    const r = await setThread(t, { archived: !t.archived });
    if (r) UI.toast(r.archived ? 'Conversa arquivada' : 'Conversa desarquivada');
  }
  async function toggleLock(t) {
    if (!t.locked) {
      const noPin = window.System && System.account && System.account.hasPin === false;
      const ok = await UI.confirm('Bloquear esta conversa?', noPin
        ? 'O telemóvel não tem código: define um em Definições › Código para esta proteção servir de alguma coisa. A conversa deixa de mostrar conteúdo na lista, nas notificações e na pesquisa.'
        : 'Para a abrir vais precisar do código do telemóvel. Deixa de mostrar conteúdo na lista, nas notificações e na pesquisa.', 'Bloquear');
      if (ok) { const r = await setThread(t, { locked: true }); if (r) UI.toast('Conversa bloqueada'); }
      return;
    }
    if (!(await unlock(t, true))) return;
    const r = await setThread(t, { locked: false });
    if (r) UI.toast('Conversa desbloqueada');
  }
  async function deleteThread(t) {
    const ok = await UI.confirm(t.conversation ? 'Apagar a conversa do grupo?' : 'Apagar esta conversa?',
      'As mensagens são apagadas só no teu telemóvel. ' + (t.conversation ? 'Continuas a ser membro do grupo.' : 'A outra pessoa continua a ter a conversa.'), 'Apagar', true);
    if (!ok) return;
    let r = null; try { r = await Bridge.rpcRaw('messages.clear', Object.assign({ app: APP }, targetOf(t))); } catch (e) { r = null; }
    if (!r || r.error || r.ok === false) { UI.toast(errorText(r, 'Não foi possível apagar')); return; }
    threads = (threads || []).filter(x => x.key !== t.key); paintSoon(); updateBadge(); UI.toast('Conversa apagada');
  }
  function showInfo(t) {
    if (t.conversation) callMod('people', 'groupInfo', t.conversation);
    else callMod('people', 'openProfile', t.number);
  }
  function threadMenu(t, anchor) {
    const unreadish = t.unread > 0 || t.markedUnread, muted = isMuted(t);
    const items = [
      { label: unreadish ? 'Marcar como lida' : 'Marcar como não lida', icon: unreadish ? 'checkCircle' : 'message', onTap: () => toggleRead(t) },
      { label: t.pinned ? 'Desafixar' : 'Fixar', icon: 'pin', onTap: () => togglePin(t) },
      { label: muted ? 'Reativar alertas' : 'Silenciar', icon: muted ? 'bell' : 'bellOff', onTap: () => muteMenu(t) },
      { label: t.archived ? 'Desarquivar' : 'Arquivar', icon: 'folder', onTap: () => toggleArchive(t) },
      { label: t.locked ? 'Desbloquear conversa' : 'Bloquear conversa', icon: t.locked ? 'unlock' : 'lock', onTap: () => toggleLock(t) },
      { label: t.conversation ? 'Informações do grupo' : 'Ver contacto', icon: 'info', onTap: () => showInfo(t) },
      { label: 'Apagar conversa', icon: 'trash', danger: true, onTap: () => deleteThread(t) }
    ];
    UI.ctxMenu(anchor, items, { cls: 'rc-ctx' });
  }

  /* =====================================================================
     LISTA DE CONVERSAS
     ===================================================================== */
  let paintT = null;
  function paintSoon() { if (paintT) return; paintT = setTimeout(() => { paintT = null; if (listView && listView.isConnected) renderList(); if (archView && archView.isConnected) renderArchived(); }, 30); }

  function chatsView() {
    if (listView) { renderList(); refetchSoon(0); return listView; }
    /* a caixa de pesquisa nasce vazia: a pesquisa antiga (de antes de fechar a app) deixava a lista filtrada com a caixa em branco */
    query = ''; searchRes = null;
    const v = UI.view({ title: 'Conversas', large: true, cls: 'rc-list-view',
      left: [{ cls: 'rc-nb-me', onTap: () => UI.push(win, settingsView()) }],
      right: [{ icon: 'compose', cls: 'rc-nb-new', onTap: () => newChat() }] });
    const top = UI.el('<div class="rc-top pane-wrap"></div>');   /* .pane-wrap: no PearPhone Fold aberto a pesquisa desce para o fundo da lista (ui.css) */
    const search = UI.search('Pesquisar', q => { query = q; if (q.length >= 2) searchSoon(q); renderList(); });
    search.classList.add('rc-search');
    top.appendChild(search);
    const chips = UI.el('<div class="rc-chips"></div>');
    [['all', 'Todas'], ['unread', 'Não lidas'], ['groups', 'Grupos']].forEach(([k, l]) => {
      const c = UI.el(`<div class="rc-chip${filter === k ? ' on' : ''}" data-f="${k}">${l}</div>`);
      c.onclick = () => { filter = k; chips.querySelectorAll('.rc-chip').forEach(x => x.classList.toggle('on', x.dataset.f === k)); renderList(); v.content.scrollTop = 0; };
      chips.appendChild(c);
    });
    top.appendChild(chips);
    /* eSIM (js/apps/esim.js): SIM obrigatório e nenhuma linha = aviso "Sem SIM" com o botão de adicionar (o servidor recusa os envios) */
    if (window.ESim && ESim.mount) ESim.mount(top, { app: 'recado' });
    const body = UI.el('<div class="rc-body"></div>');
    v.content.append(top, body);
    v._rcBody = body; v._rcTop = top;
    listView = v;
    paintMe();
    if (threads) renderList(); else body.appendChild(UI.skeleton('list', 7));
    fetchThreads().then(() => renderList());
    loadProfile().then(() => paintMe());
    /* linhas por blocos: uma lista de 500 conversas não é construída de uma vez (o openApp ficava lento) */
    v.content.addEventListener('scroll', () => { if (v._rcMore && v.content.scrollTop + v.content.clientHeight > v.content.scrollHeight - 500) v._rcMore(); }, { passive: true });
    return v;
  }
  function paintMe() {
    const b = listView && listView.querySelector('.rc-nb-me'); if (!b) return;
    let host = b.querySelector('.rc-me-av'); if (!host) { host = document.createElement('div'); b.appendChild(host); }
    const m = me(); avatar(host, { name: m.name, mediaId: m.avatar }); host.classList.add('rc-me-av');
  }

  function renderRows(v, list, after) {
    const body = v._rcBody; const box = UI.el('<div class="rc-rows"></div>'); body.appendChild(box);
    let i = 0;
    const more = () => {
      const end = Math.min(list.length, i + 40);
      for (; i < end; i++) box.appendChild(row(list[i]));
      v._rcMore = i < list.length ? more : null;
      if (!v._rcMore && after) after();
    };
    more();
  }
  function renderList() {
    const v = listView; if (!v || !v._rcBody) return;
    if (!threads) {
      if (!threadsErr) return;   /* ainda a carregar: fica o esqueleto */
      v._rcBody.innerHTML = ''; v._rcMore = null;
      v._rcBody.appendChild(emptyState('xCircle', 'Não foi possível carregar as conversas', errorText(threadsErr),
        [{ label: 'Tentar outra vez', primary: true, onTap: () => { threadsErr = null; v._rcBody.innerHTML = ''; v._rcBody.appendChild(UI.skeleton('list', 7)); invalidate(); fetchThreads().then(() => renderList()); } }]));
      return;
    }
    const body = v._rcBody; openRow = null; v._rcMore = null; body.innerHTML = '';
    const q = query.trim().toLowerCase();
    if (q) { renderSearch(body, q); updateBadge(); return; }
    const archived = threads.filter(t => t.archived);
    let list = threads.filter(t => !t.archived);
    if (filter === 'unread') list = list.filter(t => t.unread > 0 || t.markedUnread);
    else if (filter === 'groups') list = list.filter(t => t.conversation);
    sortThreads(list);
    if (archived.length && filter === 'all') body.appendChild(archivedEntry(archived));
    if (!list.length) { body.appendChild(emptyFor(filter)); updateBadge(); return; }
    renderRows(v, list, () => body.appendChild(UI.el('<div class="rc-foot">As mensagens do Zapp ficam guardadas no servidor da cidade.</div>')));
    updateBadge();
  }
  function archivedEntry(list) {
    const unread = list.filter(t => t.unread > 0 || t.markedUnread).length;
    const el = UI.el(`<div class="rc-archrow${unread ? ' has-unread' : ''}"><i class="rc-ic">${SV.archive}</i><b>Arquivadas</b><span class="rc-count">${unread || list.length}</span></div>`);
    el.onclick = () => UI.push(win, archivedView());
    return el;
  }
  function archivedView() {
    const v = UI.view({ title: 'Arquivadas', back: 'Voltar', cls: 'rc-list-view rc-arch-view' });
    v.content.appendChild(UI.el('<div class="rc-note top">As conversas arquivadas ficam aqui mesmo quando chegam mensagens novas, e não enviam notificações.</div>'));
    const body = UI.el('<div class="rc-body"></div>'); v.content.appendChild(body); v._rcBody = body;
    v.content.addEventListener('scroll', () => { if (v._rcMore && v.content.scrollTop + v.content.clientHeight > v.content.scrollHeight - 500) v._rcMore(); }, { passive: true });
    archView = v; v.opts.onPop = () => { if (archView === v) archView = null; };
    renderArchived();
    return v;
  }
  function renderArchived() {
    const v = archView; if (!v || !v._rcBody || !threads) return;
    v._rcBody.innerHTML = ''; v._rcMore = null;
    const list = sortThreads(threads.filter(t => t.archived));
    if (!list.length) { v._rcBody.appendChild(emptyState(SV.archive, 'Sem conversas arquivadas', 'Desliza uma conversa para a esquerda e toca em «Arquivar» para a tirares da lista principal.')); return; }
    renderRows(v, list);
  }

  function emptyState(icon, title, sub, btns) {
    const art = icon === 'chats' ? ART_CHATS : `<i class="rc-empty-ic">${icon.charAt(0) === '<' ? icon : g(icon)}</i>`;
    const el = UI.el(`<div class="rc-empty"><div class="rc-empty-art${icon === 'chats' ? ' big' : ''}">${art}</div><b></b><span></span><div class="rc-empty-btns"></div></div>`);
    el.querySelector('b').textContent = title; el.querySelector('span').textContent = sub || '';
    (btns || []).forEach(b => { const x = UI.el(`<div class="rc-btn${b.primary ? ' primary' : ''}"></div>`); x.textContent = b.label; x.onclick = b.onTap; el.querySelector('.rc-empty-btns').appendChild(x); });
    UI.emptyFit(el);   /* sozinho no fim da vista: fica ao centro do espaco livre (ui.css .ui-isempty) */
    return el;
  }
  function emptyFor(f) {
    if (f === 'unread') return emptyState('checkCircle', 'Está tudo lido', 'As conversas com mensagens por ler aparecem aqui.');
    if (f === 'groups') return emptyState('users', 'Ainda sem grupos', 'Cria um grupo para falares com várias pessoas ao mesmo tempo.', [{ label: 'Novo grupo', primary: true, onTap: () => newGroup() }]);
    return emptyState('chats', 'Começa a conversar', 'Escreve a um contacto ou cria um grupo. Tudo o que envias fica guardado no servidor da cidade.',
      [{ label: 'Nova conversa', primary: true, onTap: () => newChat() }, { label: 'Novo grupo', onTap: () => newGroup() }]);
  }

  /* ---------- uma linha ---------- */
  function activityFor(key) {
    const now = Date.now(); let best = null;
    activity.forEach((a, k) => { if (a.until < now) { activity.delete(k); return; } if (a.key === key && (!best || a.kind === 'recording')) best = a; });
    return best;
  }
  function paintPreview(el, t) {
    const pv = el.querySelector('.rc-prev'); if (!pv) return;
    pv.className = 'rc-prev'; pv.textContent = '';
    /* numa conversa bloqueada nem o "a escrever…" aparece (diria a quem pega no telemóvel que alguém está a falar ali) */
    const act = t.locked ? null : activityFor(t.key);
    if (act) {
      pv.classList.add('act');
      const what = act.kind === 'recording' ? 'a gravar áudio…' : 'a escrever…';
      pv.textContent = t.conversation ? String(nameOf(act.from)).split(' ')[0] + ' está ' + what : what;
      return;
    }
    if (t.locked) { pv.classList.add('muted'); pv.innerHTML = SV.lock + '<span>Conversa bloqueada</span>'; return; }
    const m = t.last;
    if (!m) { pv.classList.add('muted'); pv.textContent = t.conversation ? 'Grupo sem mensagens' : 'Sem mensagens'; return; }
    const mine = m.sender === myNumber();
    if (mine && m.type !== 'system' && !m.deleted && m.status) pv.insertAdjacentHTML('beforeend', tick(m.status));
    if (t.conversation && !mine && m.type !== 'system' && m.sender) { const w = document.createElement('span'); w.className = 'rc-who'; w.textContent = nameOf(m.sender) + ': '; pv.appendChild(w); }
    const txt = document.createElement('span'); txt.textContent = label(m); pv.appendChild(txt);
    if (m.deleted || m.type === 'system') pv.classList.add('muted');
  }
  let openRow = null;
  const ACT_W = 150;
  function shut(el) {
    if (!el) return;
    el.classList.remove('open-l', 'open-r');
    const m = el.querySelector('.rc-main'); if (m) { m.style.transition = ''; m.style.transform = ''; }
    if (openRow === el) openRow = null;
    /* as ações só ficam visíveis durante o deslize de volta (0,32 s): o :active translúcido deixava-as ver por baixo */
    clearTimeout(el._dragT); el._dragT = setTimeout(() => { if (!el.classList.contains('open-l') && !el.classList.contains('open-r')) el.classList.remove('drag-l', 'drag-r'); }, 340);
  }
  /* deslizar: para a esquerda Mais · Arquivar; para a direita Lida/Não lida · Fixar. Só transform no .rc-main. */
  function swipeable(el, main) {
    let sx = 0, sy = 0, base = 0, dx = 0, pid = null, drag = false;
    main.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; pid = e.pointerId; sx = e.clientX; sy = e.clientY; drag = false; base = el.classList.contains('open-r') ? -ACT_W : el.classList.contains('open-l') ? ACT_W : 0; dx = base; });
    main.addEventListener('pointermove', e => {
      if (pid === null || e.pointerId !== pid) return;
      const z = UI.zoom() || 1, mx = (e.clientX - sx) / z, my = (e.clientY - sy) / z;
      if (!drag) {
        if (Math.abs(mx) > 10 && Math.abs(mx) > Math.abs(my) * 1.4) { drag = true; if (openRow && openRow !== el) shut(openRow); clearTimeout(el._dragT); main.style.transition = 'none'; try { main.setPointerCapture(pid); } catch (x) {} }
        else { if (Math.abs(my) > 10) pid = null; return; }
      }
      dx = Math.max(-ACT_W - 30, Math.min(ACT_W + 30, base + mx));
      el.classList.toggle('drag-r', dx < 0); el.classList.toggle('drag-l', dx > 0);
      main.style.transform = `translateX(${dx.toFixed(1)}px)`;
    });
    const end = e => {
      if (pid === null || (e && e.pointerId !== pid)) return; pid = null;
      if (!drag) return; drag = false; el._swiped = Date.now(); main.style.transition = '';
      if (dx < -ACT_W / 2.6) { el.classList.remove('open-l'); el.classList.add('open-r', 'drag-r'); main.style.transform = `translateX(${-ACT_W}px)`; openRow = el; }
      else if (dx > ACT_W / 2.6) { el.classList.remove('open-r'); el.classList.add('open-l', 'drag-l'); main.style.transform = `translateX(${ACT_W}px)`; openRow = el; }
      else shut(el);
    };
    main.addEventListener('pointerup', end); main.addEventListener('pointercancel', end);
  }
  function row(t) {
    const el = UI.el(`<div class="rc-row"><div class="rc-acts l"><div class="a read"></div><div class="a pin"></div></div><div class="rc-acts r"><div class="a more"></div><div class="a arch"></div></div><div class="rc-main"><div class="rc-avw"><div></div><i class="rc-on"></i><i class="rc-ttl">${SV.timer}</i></div><div class="rc-mid"><div class="rc-l1"><b class="rc-name"></b><span class="rc-time"></span></div><div class="rc-l2"><div class="rc-prev"></div><div class="rc-flags"></div></div></div></div></div>`);
    el.dataset.key = t.key;
    const main = el.querySelector('.rc-main'), unreadish = t.unread > 0 || t.markedUnread, muted = isMuted(t);
    if (win && win.classList.contains('split-on') && t.key === chatCurrentKey()) main.classList.add('split-sel');   /* PearPhone Fold: a conversa aberta ao lado */
    el.querySelector('.a.read').innerHTML = (unreadish ? SV.read : SV.unread) + `<span>${unreadish ? 'Lida' : 'Não lida'}</span>`;
    el.querySelector('.a.pin').innerHTML = SV.pin + `<span>${t.pinned ? 'Desafixar' : 'Fixar'}</span>`;
    el.querySelector('.a.more').innerHTML = g('more') + '<span>Mais</span>';
    el.querySelector('.a.arch').innerHTML = SV.archive + `<span>${t.archived ? 'Desarquivar' : 'Arquivar'}</span>`;
    const avw = el.querySelector('.rc-avw');
    avatar(avw.firstElementChild, t.conversation ? { conversation: t.conversation, name: t.name, mediaId: t.avatar } : { number: t.number, name: nameOf(t.number) === t.number ? t.name : null, mediaId: t.avatar });
    const c = t.number && window.Contacts && Contacts.byNumber ? Contacts.byNumber(t.number) : null;
    el.querySelector('.rc-name').textContent = t.conversation ? t.name : ((c && c.name) || t.name);
    el.querySelector('.rc-time').textContent = t.last && t.last.created ? UI.rel(t.last.created) : (t.ts ? UI.rel(t.ts) : '');
    paintPreview(el, t);
    const flags = el.querySelector('.rc-flags');
    if (muted) flags.insertAdjacentHTML('beforeend', `<i class="rc-f mute">${SV.muted}</i>`);
    if (t.locked) flags.insertAdjacentHTML('beforeend', `<i class="rc-f lock">${SV.lock}</i>`);
    /* o pino fica sempre à vista: antes só aparecia sem contador, e uma fixada com mensagens por ler parecia uma conversa qualquer no topo */
    if (t.pinned) flags.insertAdjacentHTML('beforeend', `<i class="rc-f pin">${SV.pin}</i>`);
    if (t.unread > 0) flags.insertAdjacentHTML('beforeend', `<b class="rc-badge">${t.unread > 99 ? '99+' : t.unread}</b>`);
    else if (t.markedUnread) flags.insertAdjacentHTML('beforeend', '<b class="rc-badge dot"></b>');
    el.classList.toggle('is-unread', unreadish); el.classList.toggle('is-muted', muted); el.classList.toggle('is-pinned', t.pinned);
    el.classList.toggle('online', !t.conversation && t.online); el.classList.toggle('ttl', t.disappearing > 0);
    main.onclick = () => {
      if (Date.now() - (el._swiped || 0) < 350) return;   /* o fim de um deslize não abre a conversa */
      if (el.classList.contains('open-l') || el.classList.contains('open-r')) { shut(el); return; }
      if (openRow && openRow !== el) { shut(openRow); return; }
      openChat(targetOf(t));
    };
    avw.onclick = e => { if (Date.now() - (el._swiped || 0) < 350 || openRow) return; e.stopPropagation(); showInfo(t); };
    UI.longPress(main, () => { shut(el); threadMenu(t, main); });
    el.querySelector('.a.read').onclick = e => { e.stopPropagation(); shut(el); toggleRead(t); };
    el.querySelector('.a.pin').onclick = e => { e.stopPropagation(); shut(el); togglePin(t); };
    el.querySelector('.a.more').onclick = e => { e.stopPropagation(); shut(el); threadMenu(t, main); };
    el.querySelector('.a.arch').onclick = e => { e.stopPropagation(); shut(el); toggleArchive(t); };
    swipeable(el, main);
    return el;
  }
  /* "a escrever…" muda só a pré-visualização das linhas dessa conversa (nunca a lista inteira) */
  function paintActivity(key) {
    const th = find(key); if (!th || !win) return;
    win.querySelectorAll('.rc-row').forEach(el => { if (el.dataset.key === key) paintPreview(el, th); });
  }
  let actT = null;
  function activitySweep() { clearTimeout(actT); if (!activity.size) return; actT = setTimeout(() => { const keys = new Set(); const now = Date.now(); activity.forEach((a, k) => { if (a.until < now) { activity.delete(k); keys.add(a.key); } }); keys.forEach(paintActivity); activitySweep(); }, 1500); }

  /* ---------- pesquisa: conversas (na cache) + contactos, grupos e mensagens (recado.search) ---------- */
  let searchRes = null, searchT = null, searchSeq = 0;
  function searchSoon(q) {
    clearTimeout(searchT);
    searchT = setTimeout(async () => {
      const my = ++searchSeq;
      let r = null; try { r = await Bridge.rpcRaw('recado.search', { q }); } catch (e) { r = null; }
      if (my !== searchSeq) return;
      searchRes = { q, chats: r && !r.error ? arr(r.chats) : [], messages: r && !r.error ? arr(r.messages) : [], error: !r || !!r.error };
      if (query.trim().toLowerCase() === q) renderList();
    }, 260);
  }
  function highlight(host, text, q) {
    const low = text.toLowerCase(), i = q ? low.indexOf(q) : -1;
    if (i < 0) { host.textContent = text; return; }
    const start = Math.max(0, i - 24), pre = (start > 0 ? '…' : '') + text.slice(start, i);
    host.append(document.createTextNode(pre));
    const mk = document.createElement('mark'); mk.textContent = text.slice(i, i + q.length); host.appendChild(mk);
    host.append(document.createTextNode(text.slice(i + q.length)));
  }
  function renderSearch(body, q) {
    const local = sortThreads(threads.filter(t => !t.locked && ((t.name || '').toLowerCase().includes(q) || String(t.number || '').includes(q) || nameOf(t.number).toLowerCase().includes(q))));
    const sec = title => body.appendChild(UI.el(`<div class="rc-sec">${esc(title)}</div>`));
    if (local.length) { sec('Conversas'); local.slice(0, 30).forEach(t => body.appendChild(row(t))); }
    const res = searchRes && searchRes.q === q ? searchRes : null;
    if (res) {
      const known = new Set(local.map(t => t.key));
      const extra = res.chats.filter(c => { const k = keyOfTarget(c); return k && !known.has(k); });
      if (extra.length) {
        sec('Contactos e grupos');
        extra.forEach(c => {
          const tg = targetOf(c), el = UI.el('<div class="rc-crow"><div></div><div class="rc-cb"><b></b><span></span></div></div>');
          avatar(el.firstElementChild, tg.conversation ? { conversation: tg.conversation, name: c.name, mediaId: c.avatar } : { number: tg.number, name: c.name });
          el.querySelector('b').textContent = c.name || (tg.number ? nameOf(tg.number) : 'Grupo');
          el.querySelector('span').textContent = tg.conversation ? 'Grupo' : tg.number;
          el.onclick = () => openChat(tg);
          body.appendChild(el);
        });
      }
      if (res.messages.length) {
        sec('Mensagens');
        res.messages.forEach(m => {
          const tg = m.conversation ? { conversation: int(m.conversation) } : { number: String(m.number || '') }, th = find(keyOfTarget(tg));
          const el = UI.el('<div class="rc-mres"><div></div><div class="rc-mb"><div class="rc-l1"><b class="rc-name"></b><span class="rc-time"></span></div><div class="rc-snip"></div></div></div>');
          avatar(el.firstElementChild, tg.conversation ? { conversation: tg.conversation, name: th && th.name } : { number: tg.number });
          el.querySelector('.rc-name').textContent = tg.conversation ? ((th && th.name) || 'Grupo') : nameOf(tg.number);
          el.querySelector('.rc-time').textContent = m.created ? UI.rel(m.created) : '';
          const who = m.sender === myNumber() ? 'Tu: ' : (tg.conversation ? nameOf(m.sender) + ': ' : '');
          highlight(el.querySelector('.rc-snip'), who + label(m), q);
          el.onclick = () => openChat(tg, { messageId: int(m.id) });
          body.appendChild(el);
        });
      }
    } else if (q.length >= 2) body.appendChild(UI.el('<div class="rc-note">A procurar nas mensagens…</div>'));
    /* uma falha do servidor não se disfarça de "Sem resultados" */
    if (res && res.error) body.appendChild(UI.el('<div class="rc-note">Não foi possível procurar nas mensagens. Tenta outra vez daqui a pouco.</div>'));
    else if (!local.length && res && !res.chats.length && !res.messages.length) body.appendChild(emptyState('search', 'Sem resultados', 'Nada corresponde a «' + q + '».'));
  }

  /* =====================================================================
     NOVA CONVERSA · NOVO GRUPO · ENTRAR POR CÓDIGO
     ===================================================================== */
  const numOk = s => /^[0-9+\-.() ]{3,20}$/.test(s) && (s.match(/[0-9]/g) || []).length >= 3;
  async function newChat() {
    if (window.Contacts && Contacts.cache && !Contacts.cache.length) { try { await Contacts.load(); } catch (e) {} }
    const body = UI.el('<div class="rc-new"></div>');
    const search = UI.search('Nome ou número', q => paint(q)); body.appendChild(search);
    const acts = UI.el('<div class="rc-new-acts"></div>');
    let sh = null;
    [['group', 'users', 'Novo grupo', () => newGroup()], ['contact', 'personPlus', 'Novo contacto', () => newContact()], ['code', 'link', 'Entrar num grupo por código', () => joinByCode()]].forEach(([k, ic, lb, fn]) => {
      const a = UI.el(`<div class="rc-new-act" data-k="${k}"><i class="rc-ic">${g(ic)}</i><span>${lb}</span></div>`);
      a.onclick = () => { if (sh) sh.close(); setTimeout(fn, 280); };
      acts.appendChild(a);
    });
    body.appendChild(acts);
    const holder = UI.el('<div class="rc-new-list"></div>'); body.appendChild(holder);
    const pick = number => { if (sh) sh.close(); setTimeout(() => openChat({ number }), 260); };
    const paint = q => {
      q = String(q || '').trim().toLowerCase(); holder.innerHTML = '';
      const my = myNumber();
      const cs = ((window.Contacts && Contacts.cache) || []).filter(c => c && c.number && c.number !== my && (!q || String(c.name).toLowerCase().includes(q) || String(c.number).includes(q)))
        .sort((a, b) => String(a.name).localeCompare(String(b.name), 'pt'));
      if (numOk(q) && !cs.some(c => c.number === q)) {
        const w = UI.el(`<div class="rc-crow write"><i class="rc-ic">${g('send')}</i><div class="rc-cb"><b></b><span>Número que não está nos contactos</span></div></div>`);
        w.querySelector('b').textContent = 'Escrever para ' + q; w.onclick = () => pick(q); holder.appendChild(w);
      }
      if (!cs.length && !numOk(q)) { holder.appendChild(UI.el(`<div class="rc-note">${q ? 'Nenhum contacto corresponde. Escreve o número completo para começar.' : 'Ainda não tens contactos. Escreve um número para começar.'}</div>`)); return; }
      let letter = '';
      cs.forEach(c => {
        const L = (String(c.name).trim().charAt(0) || '#').toUpperCase();
        if (L !== letter) { letter = L; holder.appendChild(UI.el(`<div class="rc-sec">${esc(L)}</div>`)); }
        const r = UI.el('<div class="rc-crow"><div></div><div class="rc-cb"><b></b><span></span></div></div>');
        avatar(r.firstElementChild, { number: c.number, name: c.name });
        r.querySelector('b').textContent = c.name; r.querySelector('span').textContent = c.number;
        r.onclick = () => pick(c.number);
        holder.appendChild(r);
      });
    };
    sh = UI.sheet({ title: 'Nova conversa', right: 'Cancelar', body, cls: 'rc-sheet' });
    paint('');
  }
  async function newGroup() {
    const people = get('people');
    if (!people || typeof people.createGroup !== 'function') { UI.toast('Criar grupos ainda não está disponível nesta versão'); return; }
    let r = null; try { r = await people.createGroup(win); } catch (e) { r = null; }
    const id = r && int(r.id || r.conversation || (r.group && r.group.id));
    if (id > 0) { invalidate(); await fetchThreads(); paintSoon(); openChat({ conversation: id }); }
  }
  async function newContact() {
    const people = get('people');
    if (people && typeof people.contactsView === 'function') { callMod('people', 'contactsView'); return; }
    const name = await UI.prompt('Novo contacto', 'Nome do contacto', 'Nome', ''); if (!name) return;
    const number = await UI.prompt('Novo contacto', 'Número de telefone de ' + name, '555-0000', '');
    if (!number || !numOk(number.trim())) { if (number) UI.toast('Número inválido'); return; }
    const r = window.Contacts && Contacts.save ? await Contacts.save({ name: name.slice(0, 64), number: number.trim().slice(0, 20) }) : null;
    if (r && !r.error) { UI.toast('Contacto guardado'); paintSoon(); } else UI.toast('Não foi possível guardar o contacto');
  }
  async function joinByCode(code) {
    const people = get('people');
    if (!people || typeof people.joinByCode !== 'function') { UI.toast('Entrar por código ainda não está disponível nesta versão'); return; }
    /* a folha do RC já tem o campo do código e a pré-visualização: sem código abre-a vazia (antes pedia-se duas vezes) */
    let r = null; try { r = await people.joinByCode(win, String(code || '').trim().slice(0, 60)); } catch (e) { r = null; }
    const id = r && int(r.id || r.conversation || (r.group && r.group.id));
    if (id > 0) { invalidate(); await fetchThreads(); paintSoon(); }
  }

  /* =====================================================================
     DEFINIÇÕES · COM ESTRELA · SOBRE
     ===================================================================== */
  function settingsView() {
    const v = UI.view({ title: 'Definições', back: 'Conversas', cls: 'rc-set-view' });
    const card = UI.el(`<div class="rc-me-card"><div></div><div class="rc-me-b"><b></b><span></span><em></em></div><i class="rc-chev">${g('chevR')}</i></div>`);
    const paintCard = () => { const m = me(); avatar(card.firstElementChild, { name: m.name, mediaId: m.avatar }); card.querySelector('b').textContent = m.name; card.querySelector('span').textContent = m.about || 'Disponível'; card.querySelector('em').textContent = m.number; };
    paintCard(); loadProfile(true).then(paintCard);
    /* foto/nome/sobre guardados em "O meu perfil": o cartão repinta-se já (ficava com a foto antiga até reabrir as Definições) */
    const off = Bridge.on('recado:profile', () => { if (v.isConnected) paintCard(); else off(); }); v.opts.onPop = off;
    card.onclick = () => callMod('people', 'myProfile');
    v.content.appendChild(card);
    const archivedN = (threads || []).filter(t => t.archived).length;
    v.content.appendChild(UI.list([
      { items: [
        { label: 'Mensagens com estrela', icon: SV.starFill, iconBg: '#F59E0B', onTap: () => UI.push(win, starredView()) },
        { label: 'Conversas arquivadas', icon: SV.archive, iconBg: '#128C7E', value: archivedN ? String(archivedN) : '', onTap: () => UI.push(win, archivedView()) }
      ] },
      { items: [
        { label: 'Privacidade', icon: 'shield', iconBg: '#0F9D6B', onTap: () => callMod('people', 'privacy') },
        { label: 'Bloqueados', icon: 'ban', iconBg: '#EF4444', onTap: () => callMod('people', 'blocked') },
        { label: 'Contactos', icon: 'users', iconBg: '#22C55E', onTap: () => callMod('people', 'contactsView') }
      ] },
      { items: [{ label: 'Sobre o Zapp', icon: 'info', iconBg: '#64748B', onTap: () => aboutSheet() }], footer: 'No Zapp a tua identidade é o teu número de telefone.' }
    ]));
    return v;
  }
  function aboutSheet() {
    const body = UI.el(`<div class="rc-about"><div class="rc-about-hero"><div class="tile">${Icons.tile(APP)}</div><b>Zapp</b><span>Conversas, grupos, chamadas e atualizações para a cidade.</span></div><div class="rc-about-list"></div></div>`);
    const items = [
      ['Onde ficam as mensagens', 'No servidor da cidade, associadas ao teu número. As mensagens não são cifradas entre telemóveis.'],
      ['Ver uma vez', 'A foto ou o áudio só abre uma vez, mas nada impede uma captura de ecrã.'],
      ['Mensagens temporárias', 'Desaparecem do servidor quando o tempo acaba, também para quem as recebeu.'],
      ['Vídeo', 'O jogo não permite gravar nem transmitir vídeo: a videochamada é simulada e diz isso durante a chamada.'],
      ['Partilha de ecrã', 'Indisponível neste telemóvel.'],
      ['Mensagens de voz', 'Dependem de o cliente do jogo dar acesso ao microfone.'],
      ['Documentos', 'São notas de texto (título e corpo), não ficheiros.'],
      ['GIF', 'Só aparecem se o servidor tiver um fornecedor configurado. Os autocolantes funcionam sempre.']
    ];
    const list = body.querySelector('.rc-about-list');
    items.forEach(([t, s]) => { const it = UI.el('<div class="rc-about-it"><b></b><span></span></div>'); it.querySelector('b').textContent = t; it.querySelector('span').textContent = s; list.appendChild(it); });
    UI.sheet({ title: 'Sobre', right: 'OK', body, cls: 'rc-sheet' });
  }
  function starredView() {
    const v = UI.view({ title: 'Com estrela', back: 'Voltar', cls: 'rc-star-view' });
    const body = UI.el('<div class="rc-body"></div>'); v.content.appendChild(body);
    let items = [], more = false, busy = false, dead = false;
    v.opts.onPop = () => { dead = true; };
    const paint = () => {
      body.innerHTML = '';
      if (!items.length) { body.appendChild(emptyState(SV.starFill, 'Sem mensagens com estrela', 'Mantém uma mensagem premida numa conversa e escolhe «Estrela» para a guardares aqui.')); return; }
      items.forEach(m => body.appendChild(starRow(m, () => { items = items.filter(x => x !== m); paint(); })));
    };
    const load = async before => {
      busy = true; let r = null; try { r = await Bridge.rpcRaw('recado.starred', before ? { before } : {}); } catch (e) { r = null; } busy = false;
      if (dead) return;
      if (r && r.error) { body.innerHTML = ''; body.appendChild(emptyState('xCircle', 'Não foi possível carregar', errorText(r))); return; }
      const list = arr(r); more = list.length >= 40; items = before ? items.concat(list) : list; paint();
    };
    body.appendChild(UI.skeleton('list', 5)); load();
    v.content.addEventListener('scroll', () => { if (more && !busy && items.length && v.content.scrollTop + v.content.clientHeight > v.content.scrollHeight - 300) load(items[items.length - 1].starredAt); }, { passive: true });
    return v;
  }
  function starRow(m, onRemoved) {
    const tg = m.conversation ? { conversation: int(m.conversation) } : { number: String(m.number || '') };
    const el = UI.el(`<div class="rc-star"><div class="rc-star-h"><div></div><b></b><span class="rc-time"></span></div><div class="rc-bub"><span class="rc-bub-t"></span><i class="rc-bub-s">${SV.starFill}</i></div></div>`);
    avatar(el.querySelector('.rc-star-h').firstElementChild, { number: m.sender });
    const where = m.conversation ? (m.groupTitle || 'Grupo') : (m.mine ? nameOf(m.number) : 'Tu');
    el.querySelector('b').textContent = (m.mine ? 'Tu' : nameOf(m.sender)) + ' › ' + where;
    el.querySelector('.rc-time').textContent = m.created ? UI.rel(m.created) : '';
    el.querySelector('.rc-bub-t').textContent = label(m) || m.preview || '';
    if (m.mine) el.querySelector('.rc-bub').classList.add('mine');
    el.onclick = () => openChat(tg, { messageId: int(m.id) });
    UI.longPress(el, () => UI.ctxMenu(el, [
      { label: 'Ir para a mensagem', icon: 'chat', onTap: () => openChat(tg, { messageId: int(m.id) }) },
      { label: 'Tirar estrela', icon: 'star', danger: true, onTap: async () => { const r = await Bridge.rpcRaw('recado.star', { id: m.id, on: false }); if (r && r.ok) onRemoved(); else UI.toast(errorText(r)); } }
    ], { cls: 'rc-ctx' }));
    return el;
  }

  /* =====================================================================
     JANELA: SEPARADORES
     ===================================================================== */
  function tabView(t) {
    if (t.key === 'chats') return chatsView();
    let v = null;
    try { v = t.view(win); } catch (e) { console.error('[apex_phone] Recado: separador', t.key, e); }
    if (v && v.nodeType === 1 && v.classList.contains('view')) return v;
    const pv = UI.view({ title: t.label, large: true, cls: 'rc-list-view' });
    pv.content.appendChild(emptyState('sparkles', t.label, 'Este separador ainda não está disponível.'));
    return pv;
  }
  function buildTabs(activeKey) {
    if (!win) return;
    const list = tabList();
    tabSig = list.map(t => t.key).join('|'); tabKeys = list.map(t => t.key);
    win.querySelectorAll(':scope > .tabbar').forEach(x => x.remove());
    if (list.length <= 1) { tabsApi = null; win.classList.add('rc-notabs'); UI.setRoot(win, chatsView()); updateBadge(); return; }
    win.classList.remove('rc-notabs');
    const idx = Math.max(0, tabKeys.indexOf(activeKey || 'chats'));
    tabsApi = UI.tabbar(win, list.map(t => ({ icon: Icons.has(t.icon) ? t.icon : 'grid', label: t.label, view: () => { const v = tabView(t); splitPh(t.key); return v; } })), idx);
    updateBadge();
  }
  /* dobrável aberto (lista | detalhe): o aviso da coluna da direita diz o que o separador abre ali. Atualiza o aviso que o ui.js já
     desenhou (só o texto e o glifo, sem o refazer) e as opções do UI.split, para quem o desenhar depois */
  const SPLIT_PH = {
    chats: ['message', 'Nenhuma conversa aberta', 'Escolhe uma conversa da lista para a abrires aqui.'],
    updates: ['sparkles', 'Nenhuma atualização aberta', 'Escolhe um estado ou um canal da lista para o veres aqui.'],
    communities: ['users', 'Nenhuma comunidade aberta', 'Escolhe uma comunidade ou um grupo da lista para o abrires aqui.'],
    calls: ['phone', 'Nenhuma chamada aberta', 'Escolhe uma chamada da lista para veres os detalhes aqui.']
  };
  function splitPh(key) {
    if (!win) return;
    const p = SPLIT_PH[key] || SPLIT_PH.chats, o = win._split;
    if (o) { o.icon = p[0]; o.title = p[1]; o.sub = p[2]; }
    const ph = win._splitPh; if (!ph) return;
    const b = ph.querySelector('b'), s = ph.querySelector('span'), ic = ph.querySelector('.sp-ic');
    if (b && b.textContent !== p[1]) { b.textContent = p[1]; if (s) s.textContent = p[2]; if (ic) ic.innerHTML = UI.g(Icons.has(p[0]) ? p[0] : 'message'); }
  }
  function tabsDirty() {
    if (!win) return;
    const sig = tabList().map(t => t.key).join('|'); if (sig === tabSig) return;
    buildTabs(tabsApi ? tabKeys[tabsApi.cur] : 'chats');
  }
  function mount(w) {
    win = w; w.classList.add('rc-app');
    /* voltar à lista (sair de uma conversa, perfil, grupo): a lista pede-se outra vez, com espera */
    const stack = w.querySelector('.nav-stack');
    let mo = null;
    if (stack && window.MutationObserver) {
      let depth = 0;   /* só ao VOLTAR (havia vistas por cima): trocar de separador ou abrir a app não pede duas vezes */
      mo = new MutationObserver(() => { const live = stack.querySelectorAll(':scope > .view:not(.leave)'); if (live.length === 1 && depth > 1 && live[0] === listView) refetchSoon(250); depth = live.length; markSel(); });
      mo.observe(stack, { childList: true });
    }
    const offs = [
      Bridge.on('contacts', () => paintSoon()),
      Bridge.on('recado:profile', p => { if (p && typeof p === 'object') { profile = p; profileAt = Date.now(); paintMe(); } }),
      Bridge.on('recado:changed', () => refetchSoon(300)),
      Bridge.on('groups:changed', () => refetchSoon(400))
    ];
    w.onClose = () => { if (mo) mo.disconnect(); offs.forEach(f => { try { f(); } catch (e) {} }); if (win === w) { win = null; tabsApi = null; tabKeys = []; tabSig = ''; listView = null; archView = null; openRow = null; } };
    buildTabs('chats');
    /* PearPhone Fold aberto: a lista à esquerda, a conversa à direita (ui.js UI.split; a marca da linha é a markSel) */
    UI.split(w, { icon: 'message', title: 'Nenhuma conversa aberta', sub: 'Escolhe uma conversa da lista para a abrires aqui.', row: '.rc-none' });
    Bridge.emit('recado:open', w);
  }
  /* PearPhone Fold (lista | conversa): a conversa aberta à direita fica marcada na lista */
  function markSel() {
    if (!listView || !win) return;
    const k = win.classList.contains('split-on') ? chatCurrentKey() : '';
    listView.querySelectorAll('.rc-row').forEach(r => { const m = r.querySelector('.rc-main'); if (m) m.classList.toggle('split-sel', !!k && r.dataset.key === k); });
  }
  function resume(w) {
    if (w !== win) { mount(w); return; }
    refetchSoon(0); paintMe();
  }

  /* =====================================================================
     PUSHES (sempre ativos): mensagens, estados, a escrever/a gravar, edições, grupos
     ===================================================================== */
  const convOf = m => { const c = m && (m.conversation != null ? m.conversation : m.conversation_id); return int(c) > 0 ? int(c) : 0; };
  function notifyIncoming(m, th, viewing) {
    if (!m || m.sender === myNumber() || m.type === 'system' || viewing) return;
    if (!System.isInstalled || !System.isInstalled(APP)) return;
    if (m.muted || typeof m.notified === 'boolean' || (th && (isMuted(th) || th.archived))) return;
    const conv = convOf(m), target = conv ? { conversation: conv } : { number: String(m.sender) };
    const locked = !!(th && th.locked), who = nameOf(m.sender);
    const title = locked ? 'Zapp' : conv ? ((th && th.name) || (m.group && m.group.title) || 'Grupo') : who;
    const msg = locked ? 'Nova mensagem' : (conv ? who + ': ' : '') + label(m);
    Notify.push({ app: APP, title, msg, data: target, onTap: () => openChat(target) });
  }
  Bridge.on('message', m => {
    if (!m || m.app !== APP) return;
    const my = myNumber(), conv = convOf(m);
    const key = conv ? 'g:' + conv : 'n:' + String(m.sender === my ? m.receiver : m.sender);
    activity.forEach((a, k) => { if (a.key === key && a.from === m.sender) activity.delete(k); });
    const th = find(key);
    const viewing = chatCurrentKey() === key && visibleApp();
    if (th) {
      th.last = Object.assign({}, m, { status: m.sender === my ? (m.status || 'sent') : undefined });
      th.ts = +m.created || Date.now();
      if (m.sender !== my && m.type !== 'system' && !viewing) th.unread = (th.unread || 0) + 1;
      if (conv && m.group && m.group.title) { th.name = String(m.group.title).slice(0, 60); th.group = Object.assign({}, th.group || {}, { title: th.name }); }
      paintSoon(); updateBadge();
    } else if (threads) refetchSoon(500);
    notifyIncoming(m, th, viewing);
  });
  /* o RB avisa quando envia (o servidor não manda push a quem escreveu) */
  Bridge.on('recado:sent', m => {
    if (!m || typeof m !== 'object') return;
    const key = convOf(m) ? 'g:' + convOf(m) : 'n:' + String(m.receiver || m.number || '');
    const th = find(key);
    if (th) { th.last = Object.assign({}, m, { sender: myNumber(), status: m.status || 'sent' }); th.ts = +m.created || Date.now(); th.unread = 0; th.markedUnread = false; paintSoon(); updateBadge(); }
    else refetchSoon(400);
  });
  Bridge.on('recado:read', t => { const th = find(keyOfTarget(t)); if (th && (th.unread || th.markedUnread)) { th.unread = 0; th.markedUnread = false; paintSoon(); updateBadge(); } });
  const RANK = { sent: 1, delivered: 2, read: 3 };
  Bridge.on('messageStatus', d => {
    if (!d || !threads) return;
    const conv = int(d.conversation);
    const th = conv ? find('g:' + conv) : ((d.app || 'sms') === APP ? find('n:' + d.number) : null);
    if (!th || !th.last || th.last.sender !== myNumber()) return;
    const ids = vals(d.ids).map(x => int(x));
    if (conv && d.status === 'read') { refetchSoon(1200); return; }   /* "lida" num grupo = todos leram: pede-se a lista */
    if (!ids.includes(int(th.last.id))) return;
    if ((RANK[d.status] || 0) > (RANK[th.last.status] || 0)) { th.last.status = d.status; paintSoon(); }
  });
  function onActivity(d, kind) {
    if (!d || (d.app && d.app !== APP) || !d.from) return;
    const conv = int(d.conversation), key = conv ? 'g:' + conv : 'n:' + String(d.from);
    if (!find(key)) return;
    const k = key + '|' + d.from;
    if (d.on === false) activity.delete(k);
    else activity.set(k, { key, from: String(d.from), kind, until: Date.now() + 6000 });
    paintActivity(key); activitySweep();
  }
  Bridge.on('typing', d => onActivity(d, 'typing'));
  Bridge.on('recording', d => onActivity(d, 'recording'));
  Bridge.on('messageUpdate', d => {
    if (!d || !threads) return;
    const conv = int(d.conversation);
    const th = conv ? find('g:' + conv) : ((d.app || 'sms') === APP ? find('n:' + d.number) : null);
    if (!th || !th.last || int(th.last.id) !== int(d.id)) return;
    if (d.deleted) { th.last.deleted = true; th.last.content = ''; th.last.payload = null; }
    if (typeof d.content === 'string') th.last.content = d.content;
    if (d.viewOnce) th.last.viewOnce = true;
    paintSoon();
  });
  Bridge.on('messageDeleted', d => { if (d && (d.app === APP || (int(d.conversation) && find('g:' + int(d.conversation))))) refetchSoon(400); });
  Bridge.on('groupUpdate', d => {
    if (!d || !threads) return;
    const id = int(d.id), th = find('g:' + id); if (!th) { if (d.action === 'add' || d.action === 'create' || d.action === 'join') refetchSoon(600); return; }
    if (d.removed) { threads = threads.filter(t => t !== th); paintSoon(); updateBadge(); return; }
    if (typeof d.title === 'string' && d.title) { th.name = d.title.slice(0, 60); th.group = Object.assign({}, th.group || {}, { title: th.name }); }
    if (d.avatar !== undefined) th.avatar = int(d.avatar);
    paintSoon(); refetchSoon(1500);
  });
  /* notificações do SERVIDOR (resumo ao entrar): sem onTap, o Notify emite notif:open */
  Bridge.on('notif:open', n => {
    if (!n || n.app !== APP || !n.data || typeof n.data !== 'object') return;
    const c = int(n.data.conversation);
    if (c > 0) openChat({ conversation: c });
    else if (n.data.number != null && String(n.data.number) !== '') openChat({ number: String(n.data.number).slice(0, 20) });
  });
  /* link de convite phone://recado/join/CÓDIGO (mostrado e copiável no convite do grupo): o System.openURL emite 'deeplink' */
  Bridge.on('deeplink', d => {
    if (!d || d.app !== APP || !Array.isArray(d.parts) || d.parts[0] !== 'join' || !d.parts[1]) return;
    const code = String(d.parts[1]).slice(0, 40);
    whenOpen().then(ok => { if (ok) joinByCode(code); });
  });
  Bridge.on('ready', () => setTimeout(() => { try { if (System.isInstalled(APP)) fetchThreads(); } catch (e) {} }, 1500));
  Bridge.on('apps:changed', () => { try { if (!System.isInstalled(APP)) System.badge(APP, 0); else if (!threads) fetchThreads(); } catch (e) {} });
  /* guardar o telemóvel volta a trancar as conversas bloqueadas (o servidor também larga a autorização) */
  Bridge.on('phone:close', () => { unlockedUntil = 0; });
  Bridge.on('session:changed', () => { threads = null; threadsErr = null; invalidate(); names.clear(); activity.clear(); profile = null; profileAt = 0; unlockedUntil = 0; searchRes = null; try { System.badge(APP, 0); } catch (e) {} });

  const api = {
    registerTab, register, get,
    get win() { return win; },
    me, nameOf, avatar, openChat, refresh: () => { invalidate(); return fetchThreads().then(() => { paintSoon(); return threads; }); }, errorText,
    /* aditivos (usados pelos pacotes irmãos): */
    label, tick, cfg, keyOf: keyOfTarget, targetOf, unlock, markRead, setThread, showTab, ttlText,
    threads: () => (threads || []).slice(), thread: t => find(keyOfTarget(t)), isLocked: t => { const th = find(keyOfTarget(t)); return !!(th && th.locked); },
    rememberName: (number, name) => { if (number && name) names.set(String(number).slice(0, 20), String(name).slice(0, 40)); },
    newChat: () => { whenOpen().then(ok => { if (ok) newChat(); }); }, newGroup, joinByCode,
    _mount: mount, _resume: resume
  };
  return api;
})();

/* ---------- arte da AppShop (SVG próprio; o store.js pinta-a por CSSOM, nunca dentro do HTML) ---------- */
window.RecadoStoreArt = (() => {
  const url = s => 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(s);
  const F = 'font-family="Inter,Segoe UI,Arial,sans-serif"';
  const W = 428, H = 928;
  const AV = [['#22C55E', '#22D3EE'], ['#F472B6', '#FB923C'], ['#34D399', '#0EA5E9'], ['#A78BFA', '#22C55E'], ['#FBBF24', '#F97316'], ['#60A5FA', '#2563EB']];
  const av = (x, y, r, k) => `<defs><linearGradient id="av${k}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${AV[k % 6][0]}"/><stop offset="1" stop-color="${AV[k % 6][1]}"/></linearGradient></defs><circle cx="${x}" cy="${y}" r="${r}" fill="url(#av${k})"/>`;
  const frame = (k, a, b, cap1, cap2, screen) => url(`<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}"><defs><linearGradient id="bg" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${a}"/><stop offset="1" stop-color="${b}"/></linearGradient><linearGradient id="br" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#128C7E"/><stop offset="1" stop-color="#25D366"/></linearGradient></defs>`
    + `<rect width="${W}" height="${H}" fill="url(#bg)"/><circle cx="380" cy="60" r="120" fill="#fff" opacity=".07"/><circle cx="30" cy="900" r="160" fill="#fff" opacity=".06"/>`
    + `<text x="214" y="84" text-anchor="middle" ${F} font-size="29" font-weight="800" letter-spacing="-.4" fill="#fff">${cap1}</text><text x="214" y="122" text-anchor="middle" ${F} font-size="29" font-weight="800" letter-spacing="-.4" fill="#fff">${cap2}</text>`
    + `<rect x="44" y="166" width="340" height="820" rx="54" fill="#0B0B12"/><rect x="54" y="176" width="320" height="800" rx="46" fill="#F7F7FB"/><rect x="176" y="188" width="76" height="22" rx="11" fill="#0B0B12"/>${screen}</svg>`);
  const row = (y, k, name, prev, time, badge) => av(96, y + 26, 24, k)
    + `<text x="132" y="${y + 20}" ${F} font-size="16" font-weight="700" fill="#111827">${name}</text><text x="132" y="${y + 42}" ${F} font-size="13.5" fill="#6B7280">${prev}</text>`
    + `<text x="358" y="${y + 20}" text-anchor="end" ${F} font-size="12" fill="${badge ? '#128C7E' : '#9CA3AF'}" font-weight="${badge ? 700 : 400}">${time}</text>`
    + (badge ? `<circle cx="347" cy="${y + 38}" r="11" fill="url(#br)"/><text x="347" y="${y + 42.5}" text-anchor="middle" ${F} font-size="12" font-weight="700" fill="#fff">${badge}</text>` : '')
    + `<rect x="132" y="${y + 62}" width="226" height="1" fill="#E5E7EB"/>`;
  const list = `<text x="72" y="262" ${F} font-size="27" font-weight="800" fill="#111827">Conversas</text>`
    + `<rect x="72" y="278" width="286" height="34" rx="17" fill="#EEF0F4"/><text x="96" y="300" ${F} font-size="14" fill="#9CA3AF">Pesquisar</text>`
    + `<rect x="72" y="324" width="64" height="28" rx="14" fill="url(#br)"/><text x="104" y="343" text-anchor="middle" ${F} font-size="13" font-weight="700" fill="#fff">Todas</text>`
    + `<rect x="144" y="324" width="86" height="28" rx="14" fill="#EEF0F4"/><text x="187" y="343" text-anchor="middle" ${F} font-size="13" font-weight="600" fill="#374151">Não lidas</text>`
    + `<rect x="238" y="324" width="70" height="28" rx="14" fill="#EEF0F4"/><text x="273" y="343" text-anchor="middle" ${F} font-size="13" font-weight="600" fill="#374151">Grupos</text>`
    + row(368, 0, 'Amigos de Vinewood', 'Rui: Eu levo as bebidas', '21:48', 3) + row(440, 1, 'Mãe', 'Fiz sopa, vens jantar?', '21:30', 2)
    + row(512, 2, 'Ana', '📷 Foto · ver uma vez', '20:02', 1) + row(584, 3, 'Rui', '✓✓ Combinado, às 22h no cais', '19:15', 0)
    + row(656, 4, 'Oficina Benny', '📄 Orçamento do Sultan', 'Ontem', 0) + row(728, 5, 'Turno da Noite', 'Tu: Estou a caminho', 'Ontem', 0);
  const bub = (x, y, w, h, mine, text, t2) => `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="16" fill="${mine ? 'url(#br)' : '#fff'}"/>`
    + `<text x="${x + 14}" y="${y + 25}" ${F} font-size="14" fill="${mine ? '#fff' : '#111827'}">${text}</text>` + (t2 ? `<text x="${x + 14}" y="${y + 44}" ${F} font-size="14" fill="${mine ? '#fff' : '#111827'}">${t2}</text>` : '');
  const header = (title, sub, k) => `<rect x="54" y="214" width="320" height="64" fill="#FFFFFF"/>` + av(92, 246, 19, k)
    + `<text x="120" y="242" ${F} font-size="16" font-weight="700" fill="#111827">${title}</text><text x="120" y="262" ${F} font-size="12.5" fill="#6B7280">${sub}</text>`;
  const group = `<rect x="54" y="214" width="320" height="762" rx="0" fill="#EEF0F7"/>` + header('Amigos de Vinewood', 'Ana, Rui, Mãe e tu', 0)
    + `<text x="214" y="306" text-anchor="middle" ${F} font-size="12" fill="#6B7280">Criaste o grupo «Amigos de Vinewood»</text>`
    + bub(70, 322, 210, 40, false, 'Jantar sexta no píer?') + bub(160, 374, 198, 40, true, 'Por mim, perfeito!')
    + `<rect x="70" y="428" width="250" height="210" rx="18" fill="#fff"/><text x="88" y="460" ${F} font-size="15" font-weight="700" fill="#111827">Onde jantamos?</text><text x="88" y="480" ${F} font-size="12" fill="#6B7280">Sondagem · escolhe uma</text>`
    + [['Píer de Del Perro', 0.62, 5], ['Cluckin\' Bell', 0.25, 2], ['Em casa da Ana', 0.13, 1]].map(([o, p, n], i) => `<text x="88" y="${516 + i * 42}" ${F} font-size="13.5" fill="#111827">${o}</text><text x="302" y="${516 + i * 42}" text-anchor="end" ${F} font-size="12.5" fill="#128C7E" font-weight="700">${n}</text><rect x="88" y="${524 + i * 42}" width="214" height="7" rx="3.5" fill="#E5E7EB"/><rect x="88" y="${524 + i * 42}" width="${Math.round(214 * p)}" height="7" rx="3.5" fill="url(#br)"/>`).join('')
    + `<rect x="70" y="656" width="250" height="96" rx="18" fill="#fff"/><text x="88" y="688" ${F} font-size="15" font-weight="700" fill="#111827">Jantar de sexta</text><text x="88" y="710" ${F} font-size="12.5" fill="#6B7280">Sex., 21:00 · Píer de Del Perro</text><rect x="88" y="722" width="90" height="22" rx="11" fill="#E9FBEF"/><text x="133" y="737" text-anchor="middle" ${F} font-size="11.5" font-weight="700" fill="#128C7E">Vou · 4</text>`
    + `<rect x="66" y="910" width="296" height="44" rx="22" fill="#fff"/><text x="90" y="937" ${F} font-size="14" fill="#9CA3AF">Mensagem</text>`;
  const wave = (x, y) => Array.from({ length: 26 }, (_, i) => { const h = 6 + Math.round(Math.abs(Math.sin(i * 1.7) * 18)); return `<rect x="${x + i * 6}" y="${y - h / 2}" width="3.2" height="${h}" rx="1.6" fill="#fff" opacity="${i < 11 ? 1 : .55}"/>`; }).join('');
  const voice = `<rect x="54" y="214" width="320" height="762" fill="#EEF0F7"/>` + header('Ana', 'online', 2)
    + bub(70, 300, 190, 40, false, 'Mostra-me o carro novo!')
    + `<rect x="150" y="352" width="208" height="58" rx="18" fill="url(#br)"/><circle cx="178" cy="381" r="15" fill="#fff"/><path d="M174 373l12 8-12 8z" fill="#128C7E"/>${wave(202, 381)}`
    + `<rect x="70" y="424" width="168" height="54" rx="18" fill="#fff"/><circle cx="96" cy="451" r="14" fill="none" stroke="#128C7E" stroke-width="2.5" stroke-dasharray="4 3"/><text x="96" y="456" text-anchor="middle" ${F} font-size="13" font-weight="800" fill="#128C7E">1</text><text x="120" y="447" ${F} font-size="14" font-weight="700" fill="#111827">Foto</text><text x="120" y="465" ${F} font-size="11.5" fill="#6B7280">Ver uma vez</text>`
    + `<rect x="158" y="492" width="200" height="236" rx="18" fill="#fff"/><defs><linearGradient id="ph" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FDBA74"/><stop offset=".55" stop-color="#F472B6"/><stop offset="1" stop-color="#22C55E"/></linearGradient></defs><rect x="164" y="498" width="188" height="190" rx="14" fill="url(#ph)"/><circle cx="300" cy="545" r="22" fill="#FEF3C7" opacity=".9"/><path d="M164 650l52-46 40 34 30-22 66 50v8a14 14 0 0 1-14 14H178a14 14 0 0 1-14-14z" fill="#1E1B4B" opacity=".55"/><text x="176" y="714" ${F} font-size="13.5" fill="#111827">Pôr do sol em Vespucci</text>`
    + bub(70, 742, 214, 40, false, 'Uau! Que fotografia 😍')
    + `<rect x="66" y="910" width="236" height="44" rx="22" fill="#fff"/><circle cx="336" cy="932" r="22" fill="url(#br)"/><rect x="330" y="920" width="12" height="18" rx="6" fill="#fff"/><path d="M326 932a10 10 0 0 0 20 0M336 942v5" stroke="#fff" stroke-width="2.4" fill="none" stroke-linecap="round"/>`;
  const toggle = (y, on) => `<rect x="306" y="${y - 14}" width="46" height="28" rx="14" fill="${on ? 'url(#br)' : '#D1D5DB'}"/><circle cx="${on ? 338 : 320}" cy="${y}" r="11" fill="#fff"/>`;
  const setRow = (y, t, v) => `<text x="78" y="${y + 5}" ${F} font-size="14.5" fill="#111827">${t}</text>` + (typeof v === 'boolean' ? toggle(y, v) : `<text x="350" y="${y + 5}" text-anchor="end" ${F} font-size="13.5" fill="#6B7280">${v}</text>`) + `<rect x="78" y="${y + 24}" width="272" height="1" fill="#EEF0F4"/>`;
  const privacy = `<rect x="54" y="214" width="320" height="762" fill="#F2F2F7"/><text x="72" y="262" ${F} font-size="27" font-weight="800" fill="#111827">Privacidade</text>`
    + `<rect x="66" y="286" width="296" height="248" rx="18" fill="#fff"/>` + setRow(314, 'Visto por último', 'Contactos') + setRow(362, 'Online', 'Todos') + setRow(410, 'Foto de perfil', 'Todos') + setRow(458, 'Sobre', 'Contactos') + `<text x="78" y="511" ${F} font-size="14.5" fill="#111827">Atualizações</text><text x="350" y="511" text-anchor="end" ${F} font-size="13.5" fill="#6B7280">Contactos</text>`
    + `<rect x="66" y="552" width="296" height="152" rx="18" fill="#fff"/>` + setRow(580, 'Confirmações de leitura', true) + setRow(628, 'Silenciar desconhecidos', true) + `<text x="78" y="681" ${F} font-size="14.5" fill="#111827">Quem me adiciona a grupos</text><text x="350" y="681" text-anchor="end" ${F} font-size="13" fill="#6B7280">Contactos</text>`
    + `<rect x="66" y="722" width="296" height="104" rx="18" fill="#fff"/><rect x="80" y="738" width="30" height="30" rx="8" fill="url(#br)"/><rect x="88" y="751" width="14" height="11" rx="2" fill="#fff"/><path d="M91 751v-3a4 4 0 0 1 8 0v3" stroke="#fff" stroke-width="2" fill="none"/><text x="122" y="758" ${F} font-size="14.5" fill="#111827">Conversas bloqueadas</text><text x="350" y="758" text-anchor="end" ${F} font-size="13.5" fill="#6B7280">2</text>`
    + `<rect x="80" y="784" width="30" height="30" rx="8" fill="#EF4444"/><circle cx="95" cy="799" r="7" fill="none" stroke="#fff" stroke-width="2"/><path d="M90 804l10-10" stroke="#fff" stroke-width="2"/><text x="122" y="804" ${F} font-size="14.5" fill="#111827">Bloqueados</text><text x="350" y="804" text-anchor="end" ${F} font-size="13.5" fill="#6B7280">1</text>`;
  const shots = [
    frame(0, '#128C7E', '#25D366', 'As tuas conversas,', 'num só lugar', list),
    frame(1, '#064E3B', '#128C7E', 'Grupos com sondagens', 'e eventos', group),
    frame(2, '#075E54', '#128C7E', 'Voz, fotos e', '«ver uma vez»', voice),
    frame(3, '#052E24', '#0F9D6B', 'A tua privacidade,', 'à tua medida', privacy)
  ];
  const media = url(`<svg xmlns="http://www.w3.org/2000/svg" width="900" height="1100" viewBox="0 0 900 1100"><defs><linearGradient id="h" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#0B7A6B"/><stop offset=".5" stop-color="#128C7E"/><stop offset="1" stop-color="#25D366"/></linearGradient><linearGradient id="h2" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".22"/><stop offset="1" stop-color="#fff" stop-opacity=".04"/></linearGradient></defs>`
    + '<rect width="900" height="1100" fill="url(#h)"/><circle cx="760" cy="180" r="260" fill="#fff" opacity=".06"/><circle cx="120" cy="980" r="300" fill="#fff" opacity=".05"/>'
    + '<g transform="translate(250 300) scale(4)"><path d="M50 19.5c-16.9 0-30.5 13.4-30.5 30 0 5.8 1.7 11.3 4.6 15.9L20 80.5l15.6-4c4.3 2.3 9.2 3.5 14.4 3.5 16.9 0 30.5-13.4 30.5-30S66.9 19.5 50 19.5z" fill="none" stroke="#fff" stroke-width="5.5" stroke-linejoin="round"/><path fill="#fff" transform="translate(35.5 34.5) scale(1.22)" d="M6.6 10.8c1.4 2.8 3.8 5.1 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1C10.6 21 3 13.4 3 4c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1L6.6 10.8z"/></g>'
    + '<rect x="90" y="190" width="230" height="84" rx="42" fill="url(#h2)"/><rect x="600" y="760" width="220" height="80" rx="40" fill="url(#h2)"/><rect x="560" y="300" width="150" height="56" rx="28" fill="url(#h2)"/>'
    + '<circle cx="140" cy="232" r="10" fill="#fff" opacity=".8"/><circle cx="172" cy="232" r="10" fill="#fff" opacity=".6"/><circle cx="204" cy="232" r="10" fill="#fff" opacity=".4"/></svg>');
  return { shots, media };
})();

App.define('recado', {
  name: 'Zapp', category: 'Comunicação', author: 'Zapp',   /* nome visível (inspirado no WhatsApp); o id 'recado' e o Config.Recado não mudam */
  /* só os Contactos à entrada: microfone, fotos e localização pedem-se quando se usam (gravar, anexar, partilhar) -
     com eles aqui, recusar o microfone (ou ter a localização desligada) impedia de abrir o mensageiro */
  needs: ['contacts'],
  description: 'Conversas privadas e de grupo, mensagens de voz, fotos, «ver uma vez», mensagens temporárias, sondagens, eventos, chamadas de grupo, Atualizações, Canais e Comunidades, com controlo total da tua privacidade. As mensagens ficam guardadas no servidor da cidade.',
  media: window.RecadoStoreArt.media, shots: window.RecadoStoreArt.shots,
  actions: [{ label: 'Nova conversa', icon: 'compose', onTap: () => Recado.newChat() }],
  open(win) { Recado._mount(win); },
  resume(win) { Recado._resume(win); }
});
/* os irmãos que já carregaram (ou que esperam por isto) registam-se agora */
try { Bridge.emit('recado:ready', window.Recado); } catch (e) {}

/* =====================================================================
   MOCKS DO BROWSER (LocalDB) - RPCs do RA, com a forma do server/recado.lua
   ---------------------------------------------------------------------
   Por cima dos mocks de messages.* / thread.set / media.* do messages.js (tabelas partilhadas: messages,
   conversations, conversation_members, thread_meta, message_reactions, media). Tabelas do Recado:
     recado_stars { message_id, who, created } · recado_pins { thread, message_id, pinned_by, created }
     recado_views { message_id, who, viewed_at }
   Colunas do Recado nas linhas de messages: expires_at, view_once, viewed_at, forwarded; em thread_meta:
   archived, marked_unread, locked, disappearing; em conversations: disappearing.
   Dados de exemplo (uma vez por browser): 6 conversas com os contactos do mock e 2 grupos.
   ===================================================================== */
(() => {
  if (!window.LocalDB || typeof LocalDB.register !== 'function') return;
  const T = LocalDB.T, G = Store.global || Store, APP = 'recado';
  const me = () => LocalDB.me().number;
  const int = v => { const n = Math.floor(+v); return isFinite(n) ? n : 0; };
  const now = () => Date.now();
  const arr = r => Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error ? Object.values(r).filter(x => x && typeof x === 'object') : []);
  const DIS = [86400, 604800, 7776000], STICKERS = ['basicos', 'cidade', 'reacoes'];
  const rpc = (n, d) => LocalDB.rpc(n, d);
  const pairKey = (a, b) => a < b ? 'n:' + a + '|' + b : 'n:' + b + '|' + a;
  const numOk = s => /^[0-9+\-.() ]{3,20}$/.test(s) && (s.match(/[0-9]/g) || []).length >= 3;
  const convArg = d => int(d.conversation) || int((/^g:(\d+)$/.exec(String(d.number == null ? '' : d.number)) || [])[1]);
  const members = conv => T('conversation_members').all().filter(x => int(x.conversation_id) === conv && !x.left_at);
  const memberOf = (conv, who) => members(conv).find(x => x.member === who) || null;
  const convRow = conv => T('conversations').all().find(x => int(x.id) === conv) || null;
  const metaRow = (owner, other) => T('thread_meta').all().find(x => x.owner === owner && x.app === APP && x.other === other) || null;
  function setMeta(owner, other, patch) {
    const rows = T('thread_meta').all(); let r = rows.find(x => x.owner === owner && x.app === APP && x.other === other);
    if (!r) { r = { owner, app: APP, other, pinned: 0, muted_until: null, pinned_msg: null, cleared_before: null, archived: 0, marked_unread: 0, locked: 0, disappearing: null }; rows.push(r); }
    Object.assign(r, patch); T('thread_meta').set(rows); return r;
  }
  let unlockedUntil = 0;
  if (window.Bridge) Bridge.on('phone:close', () => { unlockedUntil = 0; });
  /* como o servidor: sem código no telemóvel as conversas bloqueadas abrem sem pedir nada (o verifyPin diria ok a tudo) */
  const isOpen = () => now() <= unlockedUntil || !!(window.System && System.account && System.account.hasPin === false);
  /* os mocks do RC (media/pesquisa de um grupo bloqueado) aplicam a mesma autorização, como o RecadoIsUnlocked do servidor */
  LocalDB.recadoIsUnlocked = isOpen;
  const iBlocked = n => T('blocks').all().some(b => (!b.owner || b.owner === LocalDB.cid) && String(b.number) === String(n));
  /* media já usada numa mensagem "ver uma vez" (o servidor recusa reutilizá-la) */
  const onceMedia = mid => !!mid && T('messages').all().some(m => m.view_once && m.payload && int(m.payload.mediaId) === mid);

  function ctxOf(d) {
    const my = me(), conv = convArg(d || {});
    if (conv) {
      const c = convRow(conv); if (!c || c.app !== APP) return { error: 'notfound' };
      const mem = memberOf(conv, my); if (!mem) return { error: 'notmember' };
      return { me: my, conv, other: 'g:' + conv, key: 'g:' + conv, joined: +mem.joined || 0, role: mem.role };
    }
    const n = String(d && d.number != null ? d.number : '').trim().slice(0, 20);
    if (!numOk(n)) return { error: 'target' };
    return { me: my, number: n, other: n, key: pairKey(my, n) };
  }
  function purge() {
    const t = now(), rows = T('messages').all(), gone = rows.filter(m => m.expires_at && m.expires_at <= t).map(m => m.id);
    if (!gone.length) return;
    T('messages').set(rows.filter(m => !gone.includes(m.id)));
    ['message_reactions', 'recado_stars', 'recado_pins', 'recado_views'].forEach(tb => T(tb).remove(x => gone.includes(x.message_id)));
  }
  function visibleRaw(m, my) {
    if (!m || m.app !== APP || m.deleted_all || (m.expires_at && m.expires_at <= now())) return false;
    const conv = int(m.conversation_id);
    if (conv) { const mem = memberOf(conv, my); return !!mem && (+m.created || 0) >= (+mem.joined || 0) && !(m.sender === my && m.deleted_sender); }
    if (m.sender !== my && m.receiver !== my) return false;
    if (m.receiver === my && m.sender !== my && m.deleted_receiver) return false;
    return !(m.sender === my && m.receiver !== my && m.deleted_sender);
  }
  const previewOf = m => window.Recado ? Recado.label(m) : String(m.content || '');

  /* ---------- dados de exemplo ---------- */
  function seed() {
    if (G.get('db:recadoSeed', false)) return;
    G.set('db:recadoSeed', true);
    const my = me(), t = now();
    let id = Math.max(T('messages').all().reduce((a, m) => Math.max(a, int(m.id)), 0), t * 100 - 5e6);
    const M = [];
    const add = o => { const row = Object.assign({ app: APP, type: 'text', content: '', payload: null, read: true, delivered_at: null, read_at: null, edited_at: null, reply_to: null, deleted_sender: 0, deleted_receiver: 0, deleted_all: null, conversation_id: null, expires_at: null, view_once: 0, viewed_at: null, forwarded: 0 }, o, { id: ++id }); M.push(row); return row; };
    const min = n => t - n * 60000;
    /* uma foto a sério para o "ver uma vez" (desenhada num canvas: nada vem da internet) */
    let photoId = 0;
    try {
      const cv = document.createElement('canvas'); cv.width = 360; cv.height = 480; const x = cv.getContext('2d');
      const gr = x.createLinearGradient(0, 0, 360, 480); gr.addColorStop(0, '#FDBA74'); gr.addColorStop(.55, '#F472B6'); gr.addColorStop(1, '#22C55E');
      x.fillStyle = gr; x.fillRect(0, 0, 360, 480);
      x.fillStyle = 'rgba(254,243,199,.9)'; x.beginPath(); x.arc(250, 140, 50, 0, Math.PI * 2); x.fill();
      x.fillStyle = 'rgba(30,27,75,.55)'; x.beginPath(); x.moveTo(0, 400); x.lineTo(110, 290); x.lineTo(200, 360); x.lineTo(260, 320); x.lineTo(360, 400); x.lineTo(360, 480); x.lineTo(0, 480); x.closePath(); x.fill();
      const data = cv.toDataURL('image/jpeg', .8);
      if (/^data:image\/jpeg;base64,/.test(data)) {
        photoId = Math.max(int(G.get('mock:mediaSeq', 0)), T('media').all().reduce((a, r) => Math.max(a, int(r.id)), 0)) + 1; G.set('mock:mediaSeq', photoId);
        T('media').insert({ id: photoId, owner: 'npc:555-0420', kind: 'image', mime: 'image/jpeg', data, size: data.length, duration: null, meta: null, complete: 1, created: t });
      }
    } catch (e) { photoId = 0; }
    /* Mãe: fixada, 2 por ler */
    add({ sender: my, receiver: '555-0101', content: 'Chego a casa por volta das 20h 🙂', created: min(300), delivered_at: min(300), read_at: min(290) });
    add({ sender: '555-0101', receiver: my, content: 'Está bem, filho. Tem cuidado na estrada!', created: min(288), delivered_at: min(288) });
    add({ sender: '555-0101', receiver: my, content: 'Fiz sopa, vens jantar?', created: min(34), read: false, delivered_at: min(34) });
    add({ sender: '555-0101', receiver: my, type: 'location', content: 'Casa', payload: { x: -14.3, y: -1439.1, label: 'Casa' }, created: min(33), read: false, delivered_at: min(33) });
    /* Rui: a minha última, lida */
    add({ sender: '555-0303', receiver: my, content: 'Hoje há serviço no cais? Preciso de boleia.', created: min(160), delivered_at: min(160) });
    const star = add({ sender: my, receiver: '555-0303', content: 'Combinado, às 22h no cais. Traz o casaco.', created: min(152), delivered_at: min(152), read_at: min(150) });
    /* Ana: temporárias de 7 dias, foto "ver uma vez" por abrir */
    add({ sender: my, receiver: '555-0420', content: 'Já tens os papéis do contrato?', created: min(240), delivered_at: min(240), read_at: min(238), expires_at: t + 604800e3 - 240 * 60000, payload: { ttl: 604800 } });
    add({ sender: '555-0420', receiver: my, type: 'image', content: '', payload: Object.assign({ viewOnce: true, ttl: 604800 }, photoId ? { mediaId: photoId } : {}), view_once: 1, created: min(96), read: false, delivered_at: min(96), expires_at: t + 604800e3 - 96 * 60000 });
    /* Oficina Benny: silenciada, documento */
    add({ sender: '555-0666', receiver: my, type: 'document', content: 'Orçamento do Sultan', payload: { title: 'Orçamento do Sultan', body: 'Motor: 1.800 €\nPneus: 420 €\nPintura: 950 €\nTotal: 3.170 €' }, created: min(1500), delivered_at: min(1500) });
    const pin = add({ sender: my, receiver: '555-0666', content: 'Obrigado! Passo aí amanhã de manhã.', created: min(1490), delivered_at: min(1490), read_at: min(1480) });
    /* número desconhecido: conversa bloqueada com código */
    add({ sender: '555-0199', receiver: my, content: 'Tenho o que pediste. Encontramo-nos onde combinámos.', created: min(700), read: false, delivered_at: min(700) });
    /* Garagem Central: arquivada */
    add({ sender: '555-0177', receiver: my, type: 'location', content: 'Garagem Central', payload: { x: 213.5, y: -808.2, label: 'Garagem Central' }, created: min(4000), delivered_at: min(4000) });
    /* grupos */
    const convs = T('conversations').all(), mems = T('conversation_members').all();
    const g1 = t * 100 - 4e6 + 1, g2 = t * 100 - 4e6 + 2;
    convs.push({ id: g1, app: APP, title: 'Amigos de Vinewood', avatar: null, created_by: my, created: min(3000), last_id: null, disappearing: 0 });
    convs.push({ id: g2, app: APP, title: 'Turno da Noite', avatar: null, created_by: '555-0100', created: min(9000), last_id: null, disappearing: 0 });
    [[my, 'admin'], ['555-0303', 'member'], ['555-0420', 'member'], ['555-0101', 'member']].forEach(([m, role]) => mems.push({ conversation_id: g1, member: m, role, joined: min(3000), last_read_id: null, left_at: null }));
    [['555-0100', 'admin'], [my, 'member'], ['555-0911', 'member']].forEach(([m, role]) => mems.push({ conversation_id: g2, member: m, role, joined: min(9000), last_read_id: null, left_at: null }));
    add({ sender: my, receiver: 'g:' + g1, type: 'system', content: my + ' criou o grupo «Amigos de Vinewood»', payload: { action: 'create', by: my, title: 'Amigos de Vinewood', targets: ['555-0303', '555-0420', '555-0101'] }, conversation_id: g1, created: min(3000) });
    add({ sender: '555-0420', receiver: 'g:' + g1, content: 'Jantar sexta no píer de Del Perro?', conversation_id: g1, created: min(62), delivered_at: min(62) });
    const readUpTo = add({ sender: my, receiver: 'g:' + g1, content: 'Por mim, perfeito!', conversation_id: g1, created: min(58), delivered_at: min(58) });
    add({ sender: '555-0101', receiver: 'g:' + g1, content: 'Eu faço a sobremesa 🍰', conversation_id: g1, created: min(20), delivered_at: min(20) });
    add({ sender: '555-0420', receiver: 'g:' + g1, content: 'Reservo para as 21h.', conversation_id: g1, created: min(14), delivered_at: min(14) });
    const g1last = add({ sender: '555-0303', receiver: 'g:' + g1, content: 'Eu levo as bebidas 🍻', conversation_id: g1, created: min(12), delivered_at: min(12) });
    add({ sender: '555-0100', receiver: 'g:' + g2, content: 'Briefing às 23h na esquadra de Mission Row.', conversation_id: g2, created: min(1460), delivered_at: min(1460) });
    const g2last = add({ sender: my, receiver: 'g:' + g2, content: 'Estou a caminho.', conversation_id: g2, created: min(1440), delivered_at: min(1440) });
    T('messages').set(T('messages').all().concat(M));
    convs.forEach(c => { if (c.id === g1) c.last_id = g1last.id; if (c.id === g2) c.last_id = g2last.id; });
    mems.forEach(x => { if (x.conversation_id === g1 && x.member === my) x.last_read_id = readUpTo.id; if (x.conversation_id === g2) x.last_read_id = g2last.id; });
    T('conversations').set(convs); T('conversation_members').set(mems);
    setMeta(my, '555-0101', { pinned: 1 });
    setMeta(my, 'g:' + g1, { pinned: 1 });
    setMeta(my, '555-0666', { muted_until: 4102444800000 });
    setMeta(my, '555-0199', { locked: 1 });
    setMeta(my, '555-0177', { archived: 1 });
    setMeta(my, '555-0420', { disappearing: 604800 }); setMeta('555-0420', my, { disappearing: 604800 });
    T('recado_stars').insert({ message_id: star.id, who: my, created: min(100) });
    T('recado_pins').insert({ thread: pairKey(my, '555-0666'), message_id: pin.id, pinned_by: my, created: min(1470) });
  }

  const small = (p, vo) => {
    if (!p || typeof p !== 'object') return vo ? { viewOnce: true } : null;
    const o = {}; ['duration', 'name', 'title', 'label', 'pack', 'id', 'video', 'status', 'action', 'by', 'seconds', 'targets', 'ttl', 'fwd', 'pollId', 'eventId', 'callId', 'default'].forEach(k => { if (p[k] !== undefined) o[k] = p[k]; });
    if (vo) o.viewOnce = true;
    return Object.keys(o).length ? o : null;
  };

  LocalDB.register('recado.threads', d => {
    seed(); purge();
    const my = me(), cs = T('contacts').all(), rows = T('messages').all();
    const q = typeof d.q === 'string' ? d.q.trim().toLowerCase().slice(0, 64) : '';
    const out = arr(rpc('messages.threads', { app: APP })).map(t => {
      const conv = int(t.conversation), other = conv ? 'g:' + conv : String(t.number), mt = metaRow(my, other) || {};
      const locked = !!mt.locked;
      const item = { unread: int(t.unread), ts: +t.ts || 0, pinned: !!t.pinned, mutedUntil: t.mutedUntil || null, archived: !!mt.archived, markedUnread: !!mt.marked_unread, locked };
      if (t.last) {
        const raw = rows.find(m => m.id === t.last.id) || {}, vo = !!raw.view_once;
        item.last = { id: t.last.id, type: t.last.type, sender: t.last.sender, created: t.last.created, deleted: t.last.deleted || undefined, status: t.last.sender === my && t.last.type !== 'system' ? (t.lastStatus || t.last.status) : undefined, viewOnce: vo || undefined, forwarded: raw.forwarded ? true : undefined };
        if (locked) Object.assign(item.last, { hidden: true, content: '', preview: '' });
        else Object.assign(item.last, { content: vo ? '' : t.last.content, payload: small(t.last.payload, vo), preview: previewOf(Object.assign({}, t.last, { viewOnce: vo })) });
      }
      if (conv) {
        const c = convRow(conv) || {};
        Object.assign(item, { conversation: conv, group: t.group, name: (t.group && t.group.title) || t.name || 'Grupo', avatar: (t.group && t.group.avatar) || null, disappearing: int(c.disappearing) });
      } else {
        const c = cs.find(x => x.number === t.number);
        Object.assign(item, { number: t.number, isContact: !!c, name: c ? c.name : t.number, online: !!t.online, lastSeen: t.lastSeen || null, disappearing: int(mt.disappearing) });
      }
      return item;
    }).filter(it => {
      if (d.archived === true && !it.archived) return false;
      if (d.archived === false && it.archived) return false;
      if (d.filter === 'unread' && !(it.unread > 0 || it.markedUnread)) return false;
      if (d.filter === 'groups' && !it.conversation) return false;
      if (q && !((it.name || '') + ' ' + (it.number || '')).toLowerCase().includes(q)) return false;
      return true;
    });
    return out.sort((a, b) => (b.pinned - a.pinned) || (b.ts - a.ts));
  });

  LocalDB.register('recado.get', d => {
    seed(); purge();
    const c = ctxOf(d); if (c.error) return { error: c.error };
    const mt = metaRow(c.me, c.other) || {};
    if (mt.locked && !isOpen()) return { error: 'locked' };
    const lim = Math.max(1, Math.min(50, int(d.limit) || 30));
    const list = arr(rpc('messages.get', Object.assign({ app: APP, limit: lim }, c.conv ? { conversation: c.conv } : { number: c.number }, int(d.before) ? { before: int(d.before) } : {})));
    if (!int(d.before) && mt.marked_unread) setMeta(c.me, c.other, { marked_unread: 0 });
    const rows = T('messages').all(), stars = T('recado_stars').all(), pins = T('recado_pins').all().filter(p => p.thread === c.key), views = T('recado_views').all();
    return list.map(m => {
      const raw = rows.find(x => x.id === m.id) || {};
      const o = Object.assign({}, m, { expiresAt: raw.expires_at || null, starred: stars.some(s => s.message_id === m.id && s.who === c.me), pinned: pins.some(p => p.message_id === m.id) });
      if (raw.forwarded) o.forwarded = true;
      if (raw.view_once && !m.deleted) {
        o.viewOnce = true; o.content = '';
        o.viewed = m.sender === c.me ? !!raw.viewed_at : views.some(v => v.message_id === m.id && v.who === c.me);
        o.payload = { viewOnce: true, duration: m.type === 'audio' && m.payload ? m.payload.duration : undefined };
      }
      return o;
    });
  });

  function sendMock(d, fwd) {
    seed();
    const c = ctxOf(d); if (c.error) return { error: c.error };
    const type = d.type == null || d.type === '' ? 'text' : String(d.type).slice(0, 16);
    /* poll/event são tipos que só o servidor cria (RecadoSend com opts.trusted). No browser não há servidor: valem
       enquanto o mock do RD tiver o envio pendente, exatamente como o RecadoExtrasPending do server/recado_extras.lua.
       Sem isto o mock do RD caía no messages.send e a mensagem perdia o expires_at das temporárias. */
    const trusted = (type === 'poll' || type === 'event')
      && !!(window.RecadoExtrasMock && typeof RecadoExtrasMock.pending === 'function' && RecadoExtrasMock.pending(type, d.payload));
    if (!trusted && !['text', 'image', 'audio', 'location', 'contact', 'sticker', 'gif', 'document'].includes(type)) return { error: 'badtype' };
    let content = (typeof d.content === 'string' || typeof d.content === 'number') ? String(d.content).trim() : '';
    let p = d.payload && typeof d.payload === 'object' ? Object.assign({}, d.payload) : null;
    if (type === 'text') {
      if (!content) return { error: 'empty' };
      content = content.slice(0, 4000);
      const out = {};
      if (p && Array.isArray(p.mentions)) out.mentions = p.mentions.slice(0, 64);
      /* resposta a um estado (RE): a citação vai no payload, validada campo a campo como o statusQuote
         do server/recado.lua - sem id não há citação, e o que não passar cai fora sem recusar a mensagem */
      if (p && p.status && typeof p.status === 'object') {
        const s = p.status, sid = int(s.id);
        if (sid) {
          const q = { id: sid };
          const own = String(s.owner == null ? '' : s.owner).trim();
          if (numOk(own)) q.owner = own;
          if (['text', 'image', 'audio', 'sticker'].includes(s.kind)) q.kind = s.kind;
          if (typeof s.bg === 'string' && s.bg.length <= 16 && /^[A-Za-z]+$/.test(s.bg)) q.bg = s.bg;
          const pv = String(s.preview == null ? '' : s.preview).trim().slice(0, 90);
          if (pv) q.preview = pv;
          out.status = q;
        }
      }
      p = Object.keys(out).length ? out : null;
    }
    else if (type === 'image') { if (!int(p && p.mediaId) && !int(d.mediaId)) return { error: 'badmedia' }; p = Object.assign({ mediaId: int((p && p.mediaId) || d.mediaId) }, p && p.hd ? { hd: true } : {}, p && p.album ? { album: String(p.album).slice(0, 24), albumIndex: int(p.albumIndex) || 1, albumCount: int(p.albumCount) || 1 } : {}); content = content.slice(0, 1000); }
    else if (type === 'audio') { if (!int(p && p.mediaId) && !int(d.mediaId)) return { error: 'badmedia' }; p = { mediaId: int((p && p.mediaId) || d.mediaId), duration: +(p && p.duration) || 0, waveform: p && Array.isArray(p.waveform) ? p.waveform.slice(0, 64) : undefined }; content = ''; }
    else if (type === 'location') { const x = +(p && p.x), y = +(p && p.y); if (!isFinite(x) || !isFinite(y)) return { error: 'badpayload' }; p = { x, y, label: p.label ? String(p.label).slice(0, 60) : undefined }; content = p.label || ''; }
    else if (type === 'contact') { const n = String((p && p.number) || '').trim(), nm = String((p && p.name) || '').trim().slice(0, 64); if (!numOk(n) || !nm) return { error: 'badpayload' }; p = { name: nm, number: n }; content = nm; }
    else if (type === 'sticker') { if (!p || !STICKERS.includes(p.pack) || !/^[\w-]{1,24}$/.test(String(p.id || ''))) return { error: 'badpayload' }; p = { pack: p.pack, id: p.id }; content = ''; }
    /* sondagem/evento: o payload do RD entra tal e qual (o servidor faz o mesmo com opts.trusted) */
    else if (trusted) { content = content.slice(0, 4000); }
    /* GIF: só com o fornecedor falso ligado (Store.global 'mock:recadoGif'), e só URLs que o RD aceita - a mesma
       lista branca do server/recado.lua (media*.tenor.com; no browser também os SVG data: gerados pelo próprio mock) */
    else if (type === 'gif') {
      if (!G.get('mock:recadoGif', false)) return { error: 'nogif' };
      const url = (window.RecadoExtras && typeof RecadoExtras.safeGif === 'function') ? RecadoExtras.safeGif(p && p.url) : null;
      if (!url) return { error: 'badpayload' };
      p = { url, w: Math.max(0, Math.min(4096, int(p.w))), h: Math.max(0, Math.min(4096, int(p.h))) };
      content = '';
    }
    else if (type === 'document') { const title = String((p && p.title) || '').trim().slice(0, 80); if (!title) return { error: 'badpayload' }; p = { title, body: String((p && p.body) || '').slice(0, 20000) }; content = title; }
    const conv = c.conv ? convRow(c.conv) : null;
    if (conv && conv.send_policy === 'admins' && c.role !== 'admin') return { error: 'adminsonly' };
    if (!c.conv && c.number !== c.me && iBlocked(c.number)) return { error: 'blocked' };
    if (p && onceMedia(int(p.mediaId))) return { error: 'badmedia' };
    const viewOnce = d.viewOnce === true && (type === 'image' || type === 'audio');
    const ttl = conv ? int(conv.disappearing) : int((metaRow(c.me, c.number) || {}).disappearing);
    if (viewOnce || fwd || ttl > 0) { p = p || {}; if (viewOnce) p.viewOnce = true; if (fwd) p.fwd = true; if (ttl > 0) p.ttl = ttl; }
    const res = rpc('messages.send', Object.assign({ app: APP, type, content, payload: p }, d.replyTo != null ? { replyTo: d.replyTo } : {}, c.conv ? { conversation: c.conv } : { to: c.number }, p && p.mediaId ? { mediaId: p.mediaId } : {}));
    if (!res || res.error) return res || { error: 'rpc' };
    const rows = T('messages').all(), r = rows.find(x => x.id === res.id);
    const expiresAt = ttl > 0 ? (+res.created || now()) + ttl * 1000 : null;
    if (r) { r.expires_at = expiresAt; r.view_once = viewOnce ? 1 : 0; r.forwarded = fwd ? 1 : 0; r.viewed_at = null; T('messages').set(rows); }
    /* o "outro lado" do browser nas conversas 1:1 do Recado: entregue, a escrever… e lida (o mock das Mensagens responde) */
    if (!c.conv && c.number !== c.me) {
      const to = c.number;
      setTimeout(() => { const rs = T('messages').all(), x = rs.find(z => z.id === res.id); if (!x) return; x.delivered_at = x.delivered_at || now(); T('messages').set(rs); Bridge.emit('messageStatus', { ids: [res.id], status: 'delivered', at: x.delivered_at, number: to, app: APP }); }, 600);
      if (type === 'text') {
        setTimeout(() => Bridge.emit('typing', { from: to, app: APP, on: true }), 900);
        setTimeout(() => { const rs = T('messages').all(), ids = []; rs.forEach(z => { if (z.app === APP && !z.conversation_id && z.sender === c.me && z.receiver === to && !z.read_at) { z.read_at = now(); z.delivered_at = z.delivered_at || z.read_at; ids.push(z.id); } }); T('messages').set(rs); if (ids.length) Bridge.emit('messageStatus', { ids, status: 'read', at: now(), number: to, app: APP }); }, 1300);
        setTimeout(() => Bridge.emit('typing', { from: to, app: APP, on: false }), 5200);
      }
    }
    const out = Object.assign({}, res, { expiresAt, starred: false, pinned: false });
    if (viewOnce) Object.assign(out, { viewOnce: true, viewed: false, content: '', payload: { viewOnce: true } });
    if (fwd) out.forwarded = true;
    return out;
  }
  LocalDB.register('recado.send', d => sendMock(d, false));

  LocalDB.register('recado.forward', d => {
    seed(); purge();
    const my = me(), m = T('messages').all().find(x => x.id === int(d.id));
    if (!m || !visibleRaw(m, my)) return { error: 'notfound' };
    if (m.view_once) return { error: 'viewonce' };
    if (!['text', 'image', 'audio', 'location', 'contact', 'sticker', 'gif', 'document'].includes(m.type || 'text')) return { error: 'unsupported' };
    const list = Array.isArray(d.targets) ? d.targets : arr(d.targets);
    if (!list.length) return { error: 'target' };
    if (list.length > 5) return { error: 'toomany', max: 5 };
    const seen = new Set(), results = []; let sent = 0;
    list.forEach((t, i) => {
      const k = t && (int(t.conversation) ? 'g:' + int(t.conversation) : 'n:' + t.number);
      if (!t || typeof t !== 'object') { results.push({ i: i + 1, error: 'target' }); return; }
      if (seen.has(k)) { results.push({ i: i + 1, error: 'duplicate' }); return; }
      seen.add(k);
      const p = m.payload && typeof m.payload === 'object' ? Object.assign({}, m.payload) : null;
      if (p) { delete p.ttl; delete p.fwd; delete p.viewOnce; }
      const r = sendMock(Object.assign({}, t, { type: m.type, content: m.content, payload: p }), true);
      results.push({ i: i + 1, id: r && !r.error ? r.id : undefined, error: r && r.error ? r.error : undefined, conversation: int(t.conversation) || undefined, number: t.number });
      if (r && !r.error) sent++;
    });
    return { ok: sent > 0, sent, results };
  });

  LocalDB.register('recado.thread.set', d => {
    seed();
    const c = ctxOf(d); if (c.error) return { ok: false, error: c.error };
    const cur = metaRow(c.me, c.other) || {};
    if (d.locked === false && cur.locked && !isOpen()) return { ok: false, error: 'locked' };
    /* validações antes de gravar (como o servidor): temporárias inválidas ou com alguém que bloqueei não mexem em nada */
    if (d.disappearing !== undefined) {
      const s0 = int(d.disappearing); if (s0 !== 0 && !DIS.includes(s0)) return { ok: false, error: 'invalid' };
      if (!c.conv && c.number !== c.me && iBlocked(c.number)) return { ok: false, error: 'blocked' };
      const cv = c.conv ? convRow(c.conv) : null;
      if (cv && cv.edit_policy === 'admins' && c.role !== 'admin') return { ok: false, error: 'adminsonly' };
    }
    const out = { ok: true };
    if (d.pinned !== undefined || d.mutedUntil !== undefined) {
      if (d.pinned === true && !cur.pinned && T('thread_meta').all().filter(x => x.owner === c.me && x.app === APP && x.pinned && x.other !== c.other).length >= 3) return { ok: false, error: 'pinlimit', max: 3 };
      const r = rpc('thread.set', Object.assign({ app: APP }, c.conv ? { conversation: c.conv } : { number: c.number }, d.pinned !== undefined ? { pinned: d.pinned } : {}, d.mutedUntil !== undefined ? { mutedUntil: d.mutedUntil } : {}));
      if (!r || r.ok === false) return r || { ok: false, error: 'rpc' };
      out.pinned = !!r.pinned; out.mutedUntil = r.mutedUntil || null;
    }
    const patch = {};
    if (d.archived !== undefined) { patch.archived = d.archived ? 1 : 0; if (d.archived && !cur.archived) { patch.pinned = 0; out.pinned = false; } }
    if (d.markedUnread !== undefined) patch.marked_unread = d.markedUnread ? 1 : 0;
    if (d.locked !== undefined) patch.locked = d.locked ? 1 : 0;
    const r2 = setMeta(c.me, c.other, patch);
    Object.assign(out, { archived: !!r2.archived, markedUnread: !!r2.marked_unread, locked: !!r2.locked });
    if (d.disappearing !== undefined) {
      const s = int(d.disappearing); if (s !== 0 && !DIS.includes(s)) return { ok: false, error: 'invalid' };
      const conv = c.conv ? convRow(c.conv) : null, curS = conv ? int(conv.disappearing) : int(cur.disappearing);
      if (curS !== s) {
        if (conv) { const cs = T('conversations').all(); cs.forEach(x => { if (int(x.id) === c.conv) x.disappearing = s; }); T('conversations').set(cs); }
        else { setMeta(c.me, c.number, { disappearing: s }); setMeta(c.number, c.me, { disappearing: s }); }
        const txt = s > 0 ? 'Mensagens temporárias ativadas: ' + (window.Recado ? Recado.ttlText(s) : s + ' s') : 'Mensagens temporárias desativadas';
        const row = T('messages').insert({ app: APP, sender: c.me, receiver: c.conv ? 'g:' + c.conv : c.number, type: 'system', content: txt, payload: { action: 'disappearing', by: c.me, seconds: s }, read: true, created: now(), delivered_at: now(), read_at: null, edited_at: null, reply_to: null, deleted_sender: 0, deleted_receiver: 0, deleted_all: null, conversation_id: c.conv || null, expires_at: null, view_once: 0, viewed_at: null, forwarded: 0 });
        if (c.conv) { const cs = T('conversations').all(); cs.forEach(x => { if (int(x.id) === c.conv) x.last_id = row.id; }); T('conversations').set(cs); const ms = T('conversation_members').all(); ms.forEach(x => { if (int(x.conversation_id) === c.conv && x.member === c.me) x.last_read_id = row.id; }); T('conversation_members').set(ms); }
      }
      out.disappearing = s;
    }
    return out;
  });

  LocalDB.register('recado.star', d => {
    seed();
    const my = me(), m = T('messages').all().find(x => x.id === int(d.id));
    if (!m || !visibleRaw(m, my)) return { ok: false, error: 'notfound' };
    if (m.type === 'system') return { ok: false, error: 'unsupported' };
    const on = d.on !== false;
    T('recado_stars').remove(x => x.message_id === m.id && x.who === my);
    if (on) T('recado_stars').insert({ message_id: m.id, who: my, created: now() });
    return { ok: true, id: m.id, starred: on };
  });
  LocalDB.register('recado.starred', d => {
    seed(); purge();
    const my = me(), rows = T('messages').all(), before = +d.before || 0;
    return T('recado_stars').all().filter(s => s.who === my && (!before || s.created < before)).sort((a, b) => b.created - a.created).slice(0, 40).map(s => {
      const m = rows.find(x => x.id === s.message_id); if (!m || !visibleRaw(m, my)) return null;
      const conv = int(m.conversation_id), c = conv ? convRow(conv) : null, vo = !!m.view_once;
      /* como o servidor: nada de conversas bloqueadas sem o código nem de antes de "apagar conversa" */
      const mt = metaRow(my, conv ? 'g:' + conv : (m.sender === my ? m.receiver : m.sender)) || {};
      if ((mt.locked && !isOpen()) || (mt.cleared_before && m.id <= mt.cleared_before)) return null;
      return Object.assign({ id: m.id, starredAt: s.created, sender: m.sender, type: m.type || 'text', content: vo ? '' : m.content, created: m.created, mine: m.sender === my, payload: small(m.payload, vo), viewOnce: vo || undefined, preview: previewOf(m) },
        conv ? { conversation: conv, groupTitle: c ? c.title : 'Grupo' } : { number: m.sender === my ? m.receiver : m.sender });
    }).filter(Boolean);
  });

  LocalDB.register('recado.pin', d => {
    seed();
    const my = me(), m = T('messages').all().find(x => x.id === int(d.id));
    if (!m || !visibleRaw(m, my)) return { ok: false, error: 'notfound' };
    if (m.type === 'system' || m.deleted_all) return { ok: false, error: 'unsupported' };
    const conv = int(m.conversation_id), key = conv ? 'g:' + conv : pairKey(my, m.sender === my ? m.receiver : m.sender);
    const on = d.on !== false, pins = T('recado_pins').all().filter(p => p.thread === key);
    if (on && !pins.some(p => p.message_id === m.id)) { if (pins.length >= 3) return { ok: false, error: 'pinlimit', max: 3 }; T('recado_pins').insert({ thread: key, message_id: m.id, pinned_by: my, created: now() }); }
    if (!on) T('recado_pins').remove(p => p.thread === key && p.message_id === m.id);
    const ids = T('recado_pins').all().filter(p => p.thread === key).sort((a, b) => b.created - a.created).map(p => p.message_id);
    return { ok: true, id: m.id, pinned: on, pins: ids.length ? ids : undefined };
  });
  LocalDB.register('recado.pins', d => {
    seed(); purge();
    const c = ctxOf(d); if (c.error) return { error: c.error };
    const mt = metaRow(c.me, c.other) || {};
    if (mt.locked && !isOpen()) return { error: 'locked' };
    const rows = T('messages').all();
    return T('recado_pins').all().filter(p => p.thread === c.key).sort((a, b) => b.created - a.created).map(p => {
      const m = rows.find(x => x.id === p.message_id); if (!m || !visibleRaw(m, c.me)) return null;
      return { id: m.id, sender: m.sender, type: m.type || 'text', created: m.created, pinnedBy: p.pinned_by, pinnedAt: p.created, content: m.view_once || m.type !== 'text' ? '' : String(m.content || '').slice(0, 300), preview: previewOf(m) };
    }).filter(Boolean);
  });

  LocalDB.register('recado.viewOnce', d => {
    seed();
    const my = me(), rows = T('messages').all(), m = rows.find(x => x.id === int(d.id));
    if (!m || !visibleRaw(m, my)) return { error: 'notfound' };
    if (!m.view_once || (m.type !== 'image' && m.type !== 'audio')) return { error: 'invalid' };
    if (m.sender === my) return { error: 'mine' };
    if (T('recado_views').all().some(v => v.message_id === m.id && v.who === my)) return { error: 'viewed' };
    const at = now();
    T('recado_views').insert({ message_id: m.id, who: my, viewed_at: at });
    if (!m.conversation_id) { m.viewed_at = at; T('messages').set(rows); }
    const p = m.payload || {};
    return Object.assign({ ok: true, id: m.id, mediaId: int(p.mediaId) || null, type: m.type, viewedAt: at }, m.type === 'audio' ? { duration: p.duration, waveform: p.waveform } : { caption: m.content || '' });
  });

  LocalDB.register('recado.recording', d => { const c = ctxOf(d); return c.error ? { ok: false, error: c.error } : { ok: true }; });

  LocalDB.register('recado.search', d => {
    seed(); purge();
    const q = String(d.q == null ? '' : d.q).trim().toLowerCase().slice(0, 64);
    if (q.length < 2) return { chats: [], messages: [] };
    const my = me(), locked = other => { const mt = metaRow(my, other); return !!(mt && mt.locked); };
    const chats = T('contacts').all().filter(c => c.number !== my && !locked(c.number) && (String(c.name).toLowerCase().includes(q) || String(c.number).includes(q))).slice(0, 15).map(c => ({ number: c.number, name: c.name, isContact: true }));
    T('conversations').all().filter(c => c.app === APP && memberOf(int(c.id), my) && !locked('g:' + int(c.id)) && String(c.title).toLowerCase().includes(q)).slice(0, 10).forEach(c => chats.push({ conversation: int(c.id), name: c.title, avatar: c.avatar || null }));
    const messages = T('messages').all().filter(m => visibleRaw(m, my) && !m.view_once && ['text', 'image', 'document', 'location', 'contact', 'poll', 'event'].includes(m.type || 'text') && String(m.content || '').toLowerCase().includes(q))
      .filter(m => { const conv = int(m.conversation_id), other = conv ? 'g:' + conv : (m.sender === my ? m.receiver : m.sender), mt = metaRow(my, other) || {}; return !mt.locked && !(mt.cleared_before && m.id <= mt.cleared_before); })
      .sort((a, b) => b.id - a.id).slice(0, 30)
      .map(m => Object.assign({ id: m.id, sender: m.sender, type: m.type || 'text', content: String(m.content || '').slice(0, 200), created: m.created }, int(m.conversation_id) ? { conversation: int(m.conversation_id) } : { number: m.sender === my ? m.receiver : m.sender }));
    return { chats, messages };
  });

  LocalDB.register('recado.unlock', d => {
    const r = rpc('account.verifyPin', { pin: d.pin == null ? '' : String(d.pin).slice(0, 10) }) || {};
    if (r.ok) unlockedUntil = now() + 10 * 60000;
    return { ok: !!r.ok, attempts: r.attempts, lockedUntil: r.lockedUntil, wait: r.wait, error: r.ok ? undefined : (r.lockedUntil ? 'pinlocked' : 'badpin') };
  });
})();
