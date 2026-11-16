/* ===================== RECADO - CHAT (pacote RB) =====================
   Contrato: docs/ARQUITETURA.md §9.5 (RecadoChat) e §9.6 (RPCs do RA, RC, RD e RF).

   window.RecadoChat = { open(win, target, { messageId? }), close(), current(), update(target, patch) }
   e Recado.register('chat', RecadoChat) assim que o recado.js (RA, carregado DEPOIS deste ficheiro) existir.

   O que vive onde:
     · Este IIFE sobrevive ao killApp: a conversa aberta (`cur`), as conversas desbloqueadas nesta
       sessão do telemóvel e o leitor de áudio que continua a tocar depois de sair da conversa.
     · A conversa é uma vista EMPURRADA na janela do Recado (UI.push); cada vista larga os seus
       ouvintes, temporizadores e leitores no onPop (cleanup).
     · Sem servidor próprio: fala com recado.* (RA/RC/RD/RF) e com a base da Fase 2 (messages.*,
       media.*, groups.info, presence.get). Os mocks desses RPCs são dos outros pacotes.
     · Os módulos irmãos (RecadoPeople, RecadoExtras, RecadoCalls) podem ainda não existir: cada uso
       tem um caminho de recurso honesto, para a conversa nunca ficar partida por faltar um pacote.

   Limitações honestas (§9.2): não há envio de vídeo (o CEF do FiveM não dá captura fiável), o "ver uma
   vez" não impede capturas de ecrã, as mensagens de voz dependem do microfone do CEF, e nada aqui afirma
   encriptação. */
window.RecadoChat = (() => {
  const g = (n, s) => UI.g(n, s);
  const APP = 'recado';
  let cur = null;                 /* api interna da conversa à frente (ou null) */
  const unlocked = new Set();     /* 'n:<número>' | 'g:<id>' desbloqueadas até guardar o telemóvel */
  let dock = null;                /* { el, player, key } - leitor que continua a tocar fora da conversa */
  const sleep = ms => new Promise(r => setTimeout(r, ms));

  /* ---------- módulos irmãos (registados no Recado ou globais) ---------- */
  const R = () => window.Recado || null;
  const mod = (name, glob) => { try { const r = R(); const m = r && typeof r.get === 'function' ? r.get(name) : null; if (m) return m; } catch (e) {} return window[glob] || null; };
  const People = () => mod('people', 'RecadoPeople');
  const Extras = () => mod('extras', 'RecadoExtras');
  const Calls = () => mod('calls', 'RecadoCalls');
  const Updates = () => mod('updates', 'RecadoUpdates');
  const fn = (o, k) => !!(o && typeof o[k] === 'function');

  /* o json.encode do FiveM manda uma tabela Lua vazia como {}: tudo o que é "lista" passa por aqui */
  const arr = r => Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error ? (Array.isArray(r.items) ? r.items : (Array.isArray(r.messages) ? r.messages : Object.values(r).filter(x => x && typeof x === 'object'))) : []);
  const int = v => { const n = Math.floor(+v); return isFinite(n) ? n : 0; };
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));

  /* ---------- Config.Recado + Config.Messages/Media ----------
     O `ready` ainda não traz o Config.Recado (pedido fora deste pacote): enquanto não chegar ao
     System.config usam-se os valores do config_recado.lua. O servidor é que decide sempre; aqui só se
     escondem opções que ele recusaria. */
  const DEF_REACTIONS = ['❤️', '👍', '😂', '😮', '😢', '🙏'];
  function cfg() {
    const sc = (window.System && System.config) || {};
    const rc = sc.recado && typeof sc.recado === 'object' && !Array.isArray(sc.recado) ? sc.recado : null;
    const r = rc || {};
    const m = window.Msgs && typeof Msgs.cfg === 'function' ? Msgs.cfg() : {};
    const pos = (v, d, lo, hi) => { const n = Math.floor(+v); return isFinite(n) && n >= lo ? Math.min(hi, n) : d; };
    const dis = (Array.isArray(r.disappearing) ? r.disappearing : [86400, 604800, 7776000]).map(x => Math.floor(+x)).filter(x => x > 0).slice(0, 6);
    const gif = r.gif && typeof r.gif === 'object' ? r.gif : null;
    return {
      known: !!rc,
      pinsMax: pos(r.pinsMax, 3, 1, 10), forwardMax: pos(r.forwardMax, 5, 1, 20), multiImageMax: pos(r.multiImageMax, 10, 1, 30),
      captionMax: pos(r.captionMax, 1000, 1, 4000), textMax: pos(r.textMax, 4000, 1, 8000), hdImageBytes: pos(r.hdImageBytes, 520000, 20000, 5e6),
      disappearing: dis.length ? dis : [86400, 604800, 7776000],
      gifOn: gif ? String(gif.provider || 'none') !== 'none' : null,   /* null = não se sabe (sem config): pergunta-se ao RD */
      pageSize: pos(m.pageSize, 30, 1, 50), editWindowMin: pos(m.editWindowMin, 15, 0, 1e6), deleteForAllMin: pos(m.deleteForAllMin, 60, 0, 1e6),
      typingMs: pos(m.typingMs, 3000, 500, 60000), reactions: Array.isArray(m.reactions) && m.reactions.length ? m.reactions.slice(0, 8) : DEF_REACTIONS.slice(),
      maxImageBytes: pos(m.maxImageBytes, 260000, 4096, 5e6), maxAudioSec: pos(m.maxAudioSec, 60, 1, 600)
    };
  }

  /* ---------- erros por extenso (o RA pode ter os seus; estes são o recurso) ---------- */
  const ERR = {
    ratelimit: 'Demasiados pedidos, espera um instante', toolarge: 'O anexo é demasiado grande', window: 'Já passou o tempo para fazer isso',
    notsender: 'Só podes fazer isso com mensagens que enviaste', notmember: 'Já não és membro deste grupo', forbidden: 'Sem permissão', notfound: 'A mensagem já não existe',
    media: 'O anexo já não está disponível', badmedia: 'O anexo já não está disponível', blocked: 'Bloqueaste este contacto: desbloqueia-o para lhe escreveres',
    target: 'Destinatário inválido', noidentity: 'Este telemóvel não tem número', badreaction: 'Este servidor só aceita as reações rápidas',
    badreply: 'A mensagem a que respondes já não existe', badtype: 'Tipo de mensagem inválido', nottext: 'Só se editam mensagens de texto',
    unsupported: 'Nos grupos só podes apagar as mensagens que enviaste', invalid: 'Pedido inválido', deleted: 'A mensagem foi apagada', empty: 'A mensagem está vazia',
    busy: 'Já há outro envio a decorrer, espera um instante', baddata: 'O ficheiro chegou estragado', badmime: 'Formato de ficheiro não suportado',
    viewed: 'Esta foto já foi aberta', viewonce: 'Não se reencaminha uma foto de ver uma vez', pinsmax: 'Só podes fixar 3 mensagens', maxpins: 'Só podes fixar 3 mensagens',
    policy: 'Só os administradores podem enviar mensagens neste grupo', admins: 'Só os administradores podem enviar mensagens neste grupo', adminsonly: 'Só os administradores podem fazer isso neste grupo',
    pinlimit: 'Já tens o máximo de mensagens fixadas', badpayload: 'O conteúdo da mensagem não é válido', mine: 'Não podes abrir a tua própria mensagem de ver uma vez', duplicate: 'Destino repetido', db: 'Erro no servidor', badpin: 'Código errado', pinlocked: 'Demasiadas tentativas, espera um pouco',
    locked: 'Esta conversa está bloqueada', expired: 'Esta mensagem já expirou', toomany: 'Demasiados destinos', nogif: 'Os GIF não estão ativos neste servidor',
    internal: 'Erro no servidor', noplayer: 'Sessão do jogador não encontrada', rpc: 'Sem resposta do servidor', nogroups: 'Os grupos não estão disponíveis neste servidor'
  };
  function errText(r, fb) {
    const e = r && typeof r === 'object' ? r.error : (typeof r === 'string' ? r : null);
    if (!e) return fb;
    if (e === 'pinsmax' || e === 'maxpins' || e === 'pinlimit') return `Só podes fixar ${int(r && r.max) || cfg().pinsMax} mensagens`;
    /* o errorText do RA devolve um texto genérico ("Não foi possível concluir…") para códigos que não conhece: com uma
       sentinela como recurso sabe-se se ele conhece mesmo o código; senão vale o texto específico daqui (badreaction,
       viewonce, nottext…), que dizia ao jogador o porquê em vez de "tenta outra vez" */
    const SENT = '[rcb:sem-texto]';
    try { const rr = R(); if (rr && typeof rr.errorText === 'function') { const t = rr.errorText(String(e), SENT); if (typeof t === 'string' && t && t !== SENT && t !== e) return t; } } catch (x) {}
    return ERR[e] || fb;
  }
  const failed = r => !r || typeof r !== 'object' || !!r.error || r.ok === false;

  /* ---------- identidade, nomes, cores e avatares ---------- */
  function myNumber() {
    try { const r = R(); const me = r && typeof r.me === 'function' ? r.me() : null; if (me && me.number) return String(me.number); } catch (e) {}
    return String((window.System && System.player && System.player.phone) || '');
  }
  function myName() { try { const r = R(); const me = r && typeof r.me === 'function' ? r.me() : null; if (me && me.name) return String(me.name); } catch (e) {} return ''; }
  function nameOf(n) {
    n = String(n == null ? '' : n); if (!n) return '';
    try { const r = R(); if (r && typeof r.nameOf === 'function') { const x = r.nameOf(n); if (typeof x === 'string' && x) return x; } } catch (e) {}
    return (window.Contacts && Contacts.name(n)) || n;
  }
  /* cor do nome de cada membro no grupo: determinística pelo número, legível em claro e escuro */
  const COLORS = ['#E5484D', '#D6409F', '#8E4EC6', '#5B5BD6', '#0090FF', '#0D9488', '#F76B15', '#B7791F', '#CA244D', '#6E56CF'];
  const hash = s => [...String(s)].reduce((h, c) => (h * 31 + c.charCodeAt(0)) >>> 0, 7);
  /* no tema escuro os mesmos tons mais claros (sem color-mix no CEF: a paleta vem já calculada) */
  const COLORS_DARK = ['#FF8589', '#F57AC0', '#BE93E4', '#9EA5F5', '#70B8FF', '#3CCFC0', '#FFA366', '#E3B34F', '#F2729B', '#A796F0'];
  const colorOf = n => (document.body.classList.contains('dark') ? COLORS_DARK : COLORS)[hash(n) % COLORS.length];
  /* avatar: o do RA (foto de perfil com a privacidade aplicada); sem ele, o contacto ou as iniciais */
  function paintAvatar(host, o) {
    host.innerHTML = '';
    /* o RA transforma o elemento que recebe no próprio avatar (classes e style): dá-se-lhe um filho, para o
       contentor manter o tamanho e o estilo que o CSS do chat lhe dá */
    try { const r = R(); if (r && typeof r.avatar === 'function') { const inner = document.createElement('div'); host.appendChild(inner); const out = r.avatar(inner, o); if (out && out !== inner && out.nodeType === 1 && !out.isConnected) inner.replaceWith(out); if (host.firstElementChild && host.firstElementChild.classList.contains('avatar')) return; host.innerHTML = ''; } } catch (e) { host.innerHTML = ''; }
    if (o.conversation) { const a = UI.el(`<div class="avatar rcb-gav">${g('users')}</div>`); host.appendChild(a); if (int(o.mediaId) > 0 && window.Msgs) Msgs.media(int(o.mediaId)).then(v => { if (v && /^data:image\//.test(v.url)) { a.style.backgroundImage = UI.img(v.url); a.classList.add('has-img'); } }); return; }
    const c = window.Contacts ? Contacts.byNumber(String(o.number)) : null;
    /* só nome e semente: um `url` (data: URL) no objeto fazia o UI.avatar pôr o base64 dentro de uma string de HTML */
    const a = UI.el(UI.avatar({ name: (c && c.name) || o.name || nameOf(o.number), avatar: c && typeof c.avatar === 'number' ? c.avatar : undefined }, ''));
    host.appendChild(a);
    if (c && window.Contacts && Contacts.paintAvatar) Contacts.paintAvatar(a, c, false);
  }

  /* ---------- datas ---------- */
  const fmtTime = ts => UI.fmtTime(new Date(+ts || Date.now()));
  function dayLabel(ts) {
    const d = new Date(+ts), n = new Date();
    if (d.toDateString() === n.toDateString()) return 'Hoje';
    const y = new Date(n); y.setDate(n.getDate() - 1);
    if (d.toDateString() === y.toDateString()) return 'Ontem';
    if (n - d < 6 * 864e5) return UI.DIAS[d.getDay()];
    if (UI.fmtDayMonth) return UI.fmtDayMonth(d, d.getFullYear() !== n.getFullYear());   /* no idioma escolhido (ui.js) */
    return `${d.getDate()} de ${UI.MESES[d.getMonth()]}` + (d.getFullYear() !== n.getFullYear() ? ' de ' + d.getFullYear() : '');
  }
  function seenText(p) {
    if (!p) return ''; if (p.online) return 'online'; if (!(+p.lastSeen > 0)) return '';
    const d = new Date(+p.lastSeen), n = new Date(), t = UI.fmtTime(d);
    if (d.toDateString() === n.toDateString()) return 'visto por último hoje às ' + t;
    const y = new Date(n); y.setDate(n.getDate() - 1);
    if (d.toDateString() === y.toDateString()) return 'visto por último ontem às ' + t;
    return 'visto por último a ' + UI.fmtDate(d, true) + ' às ' + t;
  }
  function durLabel(sec) {
    sec = Math.floor(+sec || 0);
    if (sec >= 86400 * 2) return Math.round(sec / 86400) + ' dias';
    if (sec >= 86400) return '24 horas';
    if (sec >= 3600) return Math.round(sec / 3600) + ' h';
    return Math.max(1, Math.round(sec / 60)) + ' min';
  }
  /* duração de áudio: o gravador manda ms; payloads antigos podem vir em segundos */
  const audioDur = d => { d = +d || 0; if (d <= 0) return ''; return UI.fmtDur(d > 600 ? d / 1000 : d); };

  /* ---------- mensagem normalizada ---------- */
  function payloadOf(m) {
    let p = m && m.payload;
    if (typeof p === 'string') { try { p = JSON.parse(p); } catch (e) { p = null; } }
    return p && typeof p === 'object' ? p : {};
  }
  const midOf = m => int((m && m.payload && m.payload.mediaId) || (m && m.mediaId));
  /* legenda de uma foto: no Recado vai no content (o servidor limita-a a captionMax); payload.caption é o recurso antigo */
  const captionOf = m => { if (!m || m.type !== 'image' || m.viewOnce) return ''; const c = String(m.content == null ? '' : m.content).trim(); const p = m.payload && typeof m.payload.caption === 'string' ? m.payload.caption.trim() : ''; return c && c !== 'Foto' ? c : p; };
  const albumOf = m => { const a = m && m.payload && m.payload.album; return (typeof a === 'string' || typeof a === 'number') && String(a).length <= 40 ? String(a) : ''; };

  /* texto de sistema: o do M3 (nomes nas ações de grupo) + as do Recado (temporárias, fixar, …) */
  function sysText(m) {
    const p = payloadOf(m);
    if (p.action === 'disappearing') { const s = int(p.seconds != null ? p.seconds : p.disappearing); return s > 0 ? 'Mensagens temporárias ativadas: ' + durLabel(s) : 'Mensagens temporárias desativadas'; }
    try { if (window.Msgs && typeof Msgs.sysText === 'function') return Msgs.sysText(m, nameOf); } catch (e) {}
    return String(m.content || '');
  }
  /* pré-visualização curta (citações, faixa das fixadas, notificações) - sem marcas de formatação */
  const plain = s => String(s == null ? '' : s).replace(/```/g, '').replace(/(^|\s)[*_~`]+|[*_~`]+(?=\s|$)/g, '$1').replace(/\s+/g, ' ').trim();
  function label(m) {
    if (!m) return 'Mensagem';
    if (m.deleted) return 'Mensagem apagada';
    const p = payloadOf(m);
    switch (m.type) {
      case 'image': return m.viewOnce ? '📷 Foto · ver uma vez' : ('📷 ' + (captionOf(m) ? plain(captionOf(m)) : 'Foto'));
      case 'audio': { const t = audioDur(p.duration); return (m.viewOnce ? '🎤 Mensagem de voz · ouvir uma vez' : '🎤 Mensagem de voz') + (t ? ' (' + t + ')' : ''); }
      case 'location': return '📍 ' + (p.label || 'Localização');
      case 'contact': return '👤 ' + (p.name || 'Contacto');
      case 'sticker': return '🗒️ Sticker';
      case 'gif': return 'GIF';
      case 'document': return '📄 ' + (p.title || 'Documento');
      case 'poll': return '📊 ' + (p.question || 'Sondagem');
      case 'event': return '📅 ' + (p.title || 'Evento');
      case 'call': return p.video ? '🎥 Videochamada' : '📞 Chamada de voz';
      case 'system': return sysText(m);
      default: return plain(m.content) || 'Mensagem';
    }
  }

  /* ---------- formatação ----------
     O RD (RecadoExtras.formatText) devolve HTML seguro. Sem ele, este recurso faz o mesmo sobre texto
     ESCAPADO: nada do conteúdo entra no DOM sem passar pelo UI.esc. */
  function localFormat(text) {
    const esc = UI.esc(String(text == null ? '' : text));
    const blocks = [];
    let s = esc.replace(/```([\s\S]*?)```/g, (_, c) => { blocks.push(c.replace(/^\n/, '')); return '\u0000' + (blocks.length - 1) + '\u0000'; });
    const inline = t => t.replace(/`([^`\n]+)`/g, '<code>$1</code>')
      .replace(/(^|[\s(])\*([^*\n]+)\*(?=[\s).,!?:;]|$)/g, '$1<b>$2</b>')
      .replace(/(^|[\s(])_([^_\n]+)_(?=[\s).,!?:;]|$)/g, '$1<i>$2</i>')
      .replace(/(^|[\s(])~([^~\n]+)~(?=[\s).,!?:;]|$)/g, '$1<s>$2</s>');
    const out = []; let list = null;
    const flush = () => { if (list) { out.push(`<${list.t}>${list.items.map(x => '<li>' + x + '</li>').join('')}</${list.t}>`); list = null; } };
    s.split('\n').forEach(line => {
      let mm;
      if ((mm = /^\s*[-•]\s+(.*)$/.exec(line))) { if (!list || list.t !== 'ul') { flush(); list = { t: 'ul', items: [] }; } list.items.push(inline(mm[1])); return; }
      if ((mm = /^\s*\d+\.\s+(.*)$/.exec(line))) { if (!list || list.t !== 'ol') { flush(); list = { t: 'ol', items: [] }; } list.items.push(inline(mm[1])); return; }
      flush();
      if ((mm = /^&gt;\s?(.*)$/.exec(line))) { out.push('<blockquote>' + inline(mm[1]) + '</blockquote>'); return; }
      out.push(inline(line) + '\n');
    });
    flush();
    return out.join('').replace(/\n$/, '').replace(/\n/g, '<br>').replace(/\u0000(\d+)\u0000/g, (_, i) => '<pre>' + (blocks[+i] || '') + '</pre>');
  }
  function formatText(text) {
    const X = Extras();
    if (fn(X, 'formatText')) { try { const h = X.formatText(String(text == null ? '' : text)); if (typeof h === 'string') return h; } catch (e) { console.error('[apex_phone] RecadoExtras.formatText', e); } }
    return localFormat(text);
  }
  /* menções @nome: destacadas nos grupos; um @número de membro passa a mostrar o nome */
  function markMentions(root, members) {
    const me = myNumber(), mine = new Set([me.toLowerCase()]);
    const nm = myName(); if (nm) { mine.add(nm.toLowerCase().replace(/\s+/g, '')); mine.add(nm.split(/\s+/)[0].toLowerCase()); }
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, { acceptNode: n => (n.parentElement && n.parentElement.closest('code,pre,.rcb-mention')) ? NodeFilter.FILTER_REJECT : (/@/.test(n.nodeValue) ? NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_SKIP) });
    const nodes = []; while (walker.nextNode()) nodes.push(walker.currentNode);
    const re = /(^|[\s(])@([0-9A-Za-zÀ-ÿ_.\-]{2,30})/g;
    nodes.forEach(node => {
      const txt = node.nodeValue; let last = 0, mm, frag = null;
      re.lastIndex = 0;
      while ((mm = re.exec(txt))) {
        if (!frag) frag = document.createDocumentFragment();
        const start = mm.index + mm[1].length;
        frag.appendChild(document.createTextNode(txt.slice(last, start)));
        const tok = mm[2].replace(/[.\-]+$/, ''), rest = mm[2].slice(tok.length);
        const sp = document.createElement('span'); sp.className = 'rcb-mention';
        const isNum = members && Object.prototype.hasOwnProperty.call(members, tok);
        sp.textContent = '@' + (isNum ? nameOf(tok) : tok);
        if (mine.has(tok.toLowerCase())) sp.classList.add('me');
        if (isNum) sp.dataset.number = tok;
        frag.appendChild(sp); if (rest) frag.appendChild(document.createTextNode(rest));
        last = start + 1 + mm[2].length;
      }
      if (frag) { frag.appendChild(document.createTextNode(txt.slice(last))); node.parentNode.replaceChild(frag, node); }
    });
  }

  /* ---------- media sem cache (ver uma vez) ----------
     O Msgs.media guarda o que desce numa LRU: uma foto de ver uma vez não pode ficar lá depois de fechada.
     Mesmo formato do M3 (bocados de media.get, data: URL ou base64 puro). */
  async function fetchOnce(id) {
    id = int(id); if (!(id > 0)) return null;
    let out = '', total = 1, head = null;
    for (let i = 1; i <= total; i++) {
      let r = await Bridge.rpcRaw('media.get', { id, i });
      if (r && r.error === 'ratelimit') { await sleep(700); r = await Bridge.rpcRaw('media.get', { id, i }); }
      if (!r || r.error || typeof r.data !== 'string') return null;
      if (!head) head = r;
      total = Math.max(1, int(r.total) || 1); if (total > 512) return null;
      out += r.data; if (!r.data.length) break;
    }
    /* um bocado perdido dava um data: URL que "valida" mas não descodifica (a mesma verificação do Msgs.media) */
    if (head && +head.size > 0 && out.length !== +head.size) return null;
    const mime = head && typeof head.mime === 'string' ? head.mime.slice(0, 40) : '';
    let url = out;
    if (!/^data:/.test(url)) { if (!/^[a-z]+\/[A-Za-z0-9.+-]+$/.test(mime)) return null; url = 'data:' + mime + ';base64,' + url; }
    return /^data:image\/[A-Za-z0-9.+-]+[;,]/.test(url) ? url : null;
  }
  const mediaGet = (id, first) => window.Msgs && typeof Msgs.media === 'function' ? Msgs.media(id, first) : Promise.resolve(null);
  const mediaCached = id => window.Msgs && typeof Msgs.mediaCached === 'function' ? Msgs.mediaCached(id) : null;

  /* ---------- área de transferência (a interna do M3 quando existe) ---------- */
  let ownClip = '';
  function copyText(t) {
    t = String(t == null ? '' : t); if (!t) return;
    if (window.Msgs && typeof Msgs.copy === 'function') { Msgs.copy(t); return; }
    ownClip = t.slice(0, 4000); UI.toast('Copiado');
  }
  const clipboard = () => (window.Msgs && typeof Msgs.clipboard === 'string' ? Msgs.clipboard : ownClip);

  /* =====================================================================
     LEITOR QUE CONTINUA A TOCAR
     O VoiceMsg.player pausa-se sozinho quando sai do DOM (400 ms). Ao sair de uma conversa com uma voz a
     tocar, o MESMO elemento muda para uma cápsula na janela do Recado (appendChild move-o sem o desligar)
     e continua na lista, nas Atualizações, noutra conversa… Fecha-se no ✕, quando o áudio acaba ou com a app.
     ===================================================================== */
  function closeDock() {
    const d = dock; dock = null; if (!d) return;
    try { d.obs.disconnect(); } catch (e) {}
    clearTimeout(d.idleT);
    try { if (d.player && d.player.vmsg) d.player.vmsg.destroy(); } catch (e) {}
    d.el.classList.remove('in'); setTimeout(() => d.el.remove(), 220);
  }
  function toDock(win, player, who) {
    if (!win || !win.isConnected || !player) return false;
    closeDock();
    const el = UI.el(`<div class="rcb-dock"><div class="rcb-dock-ic">${g('mic')}</div><div class="rcb-dock-body"><b></b><div class="rcb-dock-host"></div></div><div class="rcb-dock-x">${g('x')}</div></div>`);
    el.querySelector('b').textContent = who || 'Mensagem de voz';
    el.querySelector('.rcb-dock-host').appendChild(player);
    win.appendChild(el);
    requestAnimationFrame(() => el.classList.add('in')); setTimeout(() => el.classList.add('in'), 60);
    const d = { el, player, idleT: null, obs: null };
    el.querySelector('.rcb-dock-x').onclick = e => { e.stopPropagation(); closeDock(); };
    /* acabou (ou foi pausado e ficou parado): a cápsula sai sozinha ao fim de uns segundos */
    const watch = () => { clearTimeout(d.idleT); if (!player.classList.contains('is-playing') && !player.classList.contains('is-loading')) d.idleT = setTimeout(() => { if (dock === d) closeDock(); }, 6000); };
    d.obs = new MutationObserver(watch); d.obs.observe(player, { attributes: true, attributeFilter: ['class'] });
    dock = d; return true;
  }

  /* camadas escuras de ecrã inteiro (visor, pré-visualização, câmara): a barra de estado passa a clara enquanto
     estão abertas - com o tema claro ficava hora e bateria pretas sobre preto */
  let darkLayers = 0, sbWas = false;
  function darkBar(on) {
    const scr = document.getElementById('screen'); if (!scr) return;
    if (on) { if (darkLayers++ === 0) { sbWas = scr.classList.contains('light-sb'); scr.classList.remove('light-sb'); } }
    else if (darkLayers > 0 && --darkLayers === 0 && sbWas && System.currentApp() === APP) scr.classList.add('light-sb');
  }

  /* =====================================================================
     ECRÃ INTEIRO: fotos com zoom, álbum a deslizar, guardar na galeria
     items = [{ mediaId?, url?, caption?, title?, sub? }]
     opts  = { once: bool (sem guardar/reencaminhar), onForward(i), onClose() }
     ===================================================================== */
  function viewer(win, items, index, opts) {
    opts = opts || {};
    items = (items || []).filter(Boolean); if (!items.length) return;
    let i = clamp(int(index), 0, items.length - 1), dead = false;
    const lay = UI.el(`<div class="rcb-viewer ${opts.once ? 'once' : ''}"><div class="rcb-vw-stage"><div class="rcb-vw-img"></div><div class="rcb-vw-spin spinner"></div></div>
      <div class="rcb-vw-top"><div class="rcb-vw-b x">${g('x', 22)}</div><div class="rcb-vw-tt"><b></b><small></small></div><div class="rcb-vw-b fw">${g('forward', 22)}</div><div class="rcb-vw-b sv">${g('download', 22)}</div></div>
      <div class="rcb-vw-bot"><div class="rcb-vw-cap"></div><div class="rcb-vw-dots"></div><div class="rcb-vw-once">${g('eye', 16)}<span>Ver uma vez · fecha para não voltar a abrir. Não impede capturas de ecrã.</span></div></div></div>`);
    const img = lay.querySelector('.rcb-vw-img'), stage = lay.querySelector('.rcb-vw-stage');
    let url = null, z = 1, tx = 0, ty = 0;
    const apply = anim => { img.style.transition = anim ? 'transform .28s cubic-bezier(.2,.8,.2,1)' : 'none'; img.style.transform = `translate(${tx.toFixed(1)}px,${ty.toFixed(1)}px) scale(${z.toFixed(3)})`; };
    const bound = () => { const w = stage.clientWidth || 440, h = stage.clientHeight || 700; const mx = (w * (z - 1)) / 2, my = (h * (z - 1)) / 2; tx = clamp(tx, -mx, mx); ty = clamp(ty, -my, my); };
    function show() {
      const it = items[i]; url = null; z = 1; tx = 0; ty = 0; apply(false);
      img.style.backgroundImage = ''; lay.classList.add('loading');
      lay.querySelector('.rcb-vw-tt b').textContent = it.title || '';
      lay.querySelector('.rcb-vw-tt small').textContent = it.sub || '';
      const cap = lay.querySelector('.rcb-vw-cap'); cap.innerHTML = it.caption ? formatText(it.caption) : '';
      const dots = lay.querySelector('.rcb-vw-dots'); dots.textContent = items.length > 1 ? (window.L && L.tf ? L.tf('%s de %s', i + 1, items.length) : `${i + 1} de ${items.length}`) : '';   /* "1 de 3": curto demais para o tradutor do DOM, vai por L.tf */
      const paint = u => { if (dead || items[i] !== it) return; lay.classList.remove('loading'); if (u) { url = u; img.style.backgroundImage = UI.img(u); } else lay.classList.add('failed'); };
      lay.classList.remove('failed');
      if (it.url) paint(it.url);
      else if (it.mediaId) { const hit = mediaCached(it.mediaId); if (hit) paint(hit.url); else mediaGet(it.mediaId, true).then(r => paint(r && /^data:image\//.test(r.url) ? r.url : null)); }
      else paint(null);
    }
    const onKey = e => { if (dead || e.key !== 'Escape') return; e.preventDefault(); e.stopPropagation(); close(); };
    const offApp = Bridge.on('app:close', id => { if (id === APP) close(); });
    /* matar a app (switcher, LRU) não passa pelo app:close: sem isto os ouvintes e a barra clara ficavam presos */
    const offKill = Bridge.on('app:kill', id => { if (id === APP) close(); });
    const offPhone = Bridge.on('phone:close', () => close());
    function close() {
      if (dead) return; dead = true; document.removeEventListener('keydown', onKey, true); offApp(); offKill(); offPhone(); darkBar(false);
      img.style.backgroundImage = ''; lay.classList.remove('in'); setTimeout(() => lay.remove(), 200);
      try { opts.onClose && opts.onClose(); } catch (e) {}
    }
    document.addEventListener('keydown', onKey, true);
    lay.querySelector('.x').onclick = close;
    lay.querySelector('.sv').onclick = async () => {
      if (opts.once) return;
      if (!url) { UI.toast('A imagem ainda está a carregar'); return; }
      /* a foto sobe aos bocados pelo Photos.save (photos.add / photos.upload), como nas Mensagens */
      let r = null; try { r = window.Photos ? await Photos.save(url) : null; } catch (e) { r = null; }
      if (r && !r.error) { try { await Photos.load(); Bridge.emit('photos'); } catch (e) {} UI.toast('Guardada na galeria'); } else UI.toast('Não foi possível guardar a foto');
    };
    lay.querySelector('.fw').onclick = () => { if (opts.once || !opts.onForward) return; const k = i; close(); opts.onForward(k); };
    if (!opts.onForward) lay.querySelector('.fw').classList.add('hidden');
    /* zoom: duplo toque alterna 1× / 2,5× no ponto tocado; roda do rato aproxima; arrastar move quando ampliada
       e, a 1×, deslizar na horizontal muda de foto no álbum. Tudo só com transform. */
    let lastTap = 0, drag = null;
    stage.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; drag = { x: e.clientX, y: e.clientY, tx, ty, t: Date.now(), moved: false }; try { stage.setPointerCapture(e.pointerId); } catch (x) {} });
    stage.addEventListener('pointermove', e => {
      if (!drag) return; const k = UI.zoom() || 1, dx = (e.clientX - drag.x) / k, dy = (e.clientY - drag.y) / k;
      if (Math.abs(dx) + Math.abs(dy) > 6) drag.moved = true;
      if (z > 1) { tx = drag.tx + dx; ty = drag.ty + dy; bound(); apply(false); }
      else if (items.length > 1) { img.style.transition = 'none'; img.style.transform = `translateX(${dx.toFixed(1)}px)`; }
    });
    const up = e => {
      if (!drag) return; const d = drag; drag = null; const k = UI.zoom() || 1, dx = (e.clientX - d.x) / k;
      if (!d.moved) {
        const now = Date.now();
        if (now - lastTap < 320) { lastTap = 0; if (z > 1) { z = 1; tx = 0; ty = 0; } else { const r = stage.getBoundingClientRect(); z = 2.5; tx = -((e.clientX - r.left) / k - r.width / k / 2) * 1.5; ty = -((e.clientY - r.top) / k - r.height / k / 2) * 1.5; bound(); } apply(true); }
        else { lastTap = now; setTimeout(() => { if (lastTap === now && !dead && z === 1) lay.classList.toggle('chrome-off'); }, 330); }
        return;
      }
      if (z === 1 && items.length > 1) { if (dx < -70 && i < items.length - 1) { i++; show(); return; } if (dx > 70 && i > 0) { i--; show(); return; } apply(true); }
    };
    stage.addEventListener('pointerup', up); stage.addEventListener('pointercancel', up);
    stage.addEventListener('wheel', e => { e.preventDefault(); z = clamp(z * (e.deltaY < 0 ? 1.15 : 1 / 1.15), 1, 4); if (z === 1) { tx = 0; ty = 0; } bound(); apply(false); }, { passive: false });
    win.appendChild(lay); darkBar(true); requestAnimationFrame(() => lay.classList.add('in')); setTimeout(() => { if (!dead) lay.classList.add('in'); }, 80);
    show();
    return { close };
  }

  /* =====================================================================
     ESCOLHER CONVERSAS (reencaminhar): até forwardMax, grupos incluídos
     → Promise<[{ number } | { conversation }] | null>
     ===================================================================== */
  async function pickTargets(max) {
    let r = null; try { r = await Bridge.rpcRaw('recado.threads', { filter: 'all' }); } catch (e) { r = null; }
    const threads = arr(r).filter(t => t && (t.number || t.group || t.conversation)).map(t => {
      const gid = int((t.group && t.group.id) || t.conversation);
      return gid > 0 ? { key: 'g:' + gid, t: { conversation: gid }, name: (t.group && (t.group.title || t.group.name)) || t.name || 'Grupo', av: { conversation: gid, mediaId: t.group && t.group.avatar } }
        : { key: 'n:' + t.number, t: { number: String(t.number) }, name: t.name || nameOf(t.number), av: { number: String(t.number), name: t.name } };
    });
    return new Promise(res => {
      const chosen = new Map(); let done = false;
      const body = UI.el('<div class="rcb-pick"></div>');
      const head = UI.el('<div class="rcb-pick-head"></div>');
      const s = UI.search('Pesquisar conversas', q => paint(q));
      const chips = UI.el('<div class="rcb-pick-chips"></div>');
      const list = UI.el('<div class="rcb-pick-list"></div>');
      const other = UI.el(`<div class="rcb-pick-row other"><div class="rcb-pick-av">${g('personPlus')}</div><b>Outro contacto…</b></div>`);
      head.append(s, chips); body.append(head, other, list);
      const finish = v => { if (done) return; done = true; res(v); };
      const sh = UI.sheet({ title: 'Reencaminhar', left: 'Cancelar', right: 'Enviar', body, cls: 'rcb-sheet', onClose: () => finish(null),
        onDone: () => { if (!chosen.size) { UI.toast('Escolhe pelo menos uma conversa'); return false; } finish([...chosen.values()].map(x => x.t)); } });
      const right = sh.el.querySelector('.sh-r');
      function paintChips() {
        chips.innerHTML = '';
        chosen.forEach(x => { const c = UI.el(`<span class="rcb-chip">${g('x', 12)}</span>`); c.insertBefore(document.createTextNode(x.name), c.firstChild); c.onclick = () => { chosen.delete(x.key); paintChips(); paint(s.input.value.trim().toLowerCase()); }; chips.appendChild(c); });
        right.textContent = chosen.size ? `Enviar (${chosen.size})` : 'Enviar';
        right.classList.toggle('dis', !chosen.size);
      }
      function toggle(x) {
        if (chosen.has(x.key)) chosen.delete(x.key);
        else { if (chosen.size >= max) { UI.toast(`Podes reencaminhar para ${max} conversas de cada vez`); return; } chosen.set(x.key, x); }
        paintChips(); paint(s.input.value.trim().toLowerCase());
      }
      function paint(q) {
        list.innerHTML = '';
        const l = threads.filter(x => !q || x.name.toLowerCase().includes(q) || x.key.toLowerCase().includes(q));
        if (!l.length) { list.appendChild(UI.el('<div class="rcb-pick-empty">Sem conversas</div>')); return; }
        l.forEach(x => {
          const row = UI.el(`<div class="rcb-pick-row"><div class="rcb-pick-av"></div><b></b><i class="rcb-check">${g('check', 14)}</i></div>`);
          paintAvatar(row.querySelector('.rcb-pick-av'), x.av); row.querySelector('b').textContent = x.name;
          row.classList.toggle('on', chosen.has(x.key)); row.onclick = () => toggle(x); list.appendChild(row);
        });
      }
      other.onclick = async () => {
        if (!window.Contacts) return;
        const c = await Contacts.pick('Reencaminhar para'); if (!c || !c.number) return;
        const x = { key: 'n:' + c.number, t: { number: String(c.number) }, name: c.name || String(c.number), av: { number: String(c.number), name: c.name } };
        if (!threads.some(y => y.key === x.key)) threads.unshift(x);
        if (!chosen.has(x.key)) toggle(x); else paint('');
      };
      paintChips(); paint('');
    });
  }

  /* =====================================================================
     GALERIA COM VÁRIAS FOTOS → Promise<[fotos] | null> (fichas do Photos.cache, pela ordem escolhida)
     ===================================================================== */
  async function pickPhotos(max) {
    if (!window.Photos) { UI.toast('Galeria indisponível'); return null; }
    try { await Photos.load(); } catch (e) {}
    return new Promise(res => {
      let done = false; const sel = [];
      const body = UI.el('<div class="rcb-pgrid"></div>');
      const cache = Photos.cache || [];
      const finish = v => { if (done) return; done = true; if (io) io.disconnect(); res(v); };
      let io = null;
      const sh = UI.sheet({ title: 'Galeria', left: 'Cancelar', right: 'Seguinte', body, cls: 'rcb-sheet', onClose: () => finish(null),
        onDone: () => { if (!sel.length) { UI.toast('Escolhe pelo menos uma foto'); return false; } finish(sel.slice()); } });
      const right = sh.el.querySelector('.sh-r');
      const repaint = () => { body.querySelectorAll('.rcb-ph').forEach(e => { const k = sel.indexOf(e._p); e.classList.toggle('on', k > -1); e.querySelector('.rcb-ph-n').textContent = k > -1 ? String(k + 1) : ''; }); right.textContent = sel.length ? `Seguinte (${sel.length})` : 'Seguinte'; };
      if (!cache.length) body.appendChild(UI.el(`<div class="rcb-pick-empty">${Photos.error ? 'Não foi possível carregar as fotos' : 'Sem fotos na galeria'}</div>`));
      const later = [];
      cache.forEach((p, k) => {
        const e = UI.el('<div class="rcb-ph"><i class="rcb-ph-n"></i></div>'); e._p = p;
        e.style.backgroundImage = Photos.bg(p);   /* fundo pelo CSSOM: o data: URL nunca atravessa o parser de HTML */
        if (k < 12) Photos.lazy(e, p, true); else later.push([e, p]);
        e.onclick = () => { const at = sel.indexOf(p); if (at > -1) sel.splice(at, 1); else { if (sel.length >= max) { UI.toast(`Máximo de ${max} fotos por envio`); return; } sel.push(p); } repaint(); };
        body.appendChild(e);
      });
      io = later.length ? Photos.lazyGrid(body.parentElement) : null;
      later.forEach(([e, p]) => { if (io) io.observe(e, p); else Photos.lazy(e, p); });
    });
  }

  /* =====================================================================
     PRÉ-VISUALIZAÇÃO ANTES DE ENVIAR (galeria e câmara)
     → Promise<{ urls, caption, hd, once } | null>
     "Ver uma vez" só com uma foto (um álbum de ver uma vez não faz sentido); HD usa Config.Recado.hdImageBytes.
     ===================================================================== */
  function mediaComposer(win, urls, o) {
    o = o || {};
    return new Promise(res => {
      urls = urls.filter(u => typeof u === 'string' && u);
      if (!urls.length) { res(null); return; }
      let i = 0, dead = false, hd = false, once = false;
      const lay = UI.el(`<div class="rcb-mc"><div class="rcb-mc-top"><div class="rcb-vw-b x">${g('x', 22)}</div><div class="rcb-mc-tt"></div><div class="rcb-mc-opts"><span class="rcb-mc-chip hd">HD</span><span class="rcb-mc-chip once">${g('eye', 15)}<em>1</em></span></div></div>
        <div class="rcb-mc-img"></div><div class="rcb-mc-strip"></div>
        <div class="rcb-mc-bot"><div class="rcb-mc-hint"></div><div class="rcb-mc-row"><textarea rows="1" placeholder="Adicionar legenda…"></textarea><div class="rcb-mc-send">${g('send', 22)}</div></div></div></div>`);
      const big = lay.querySelector('.rcb-mc-img'), strip = lay.querySelector('.rcb-mc-strip'), cap = lay.querySelector('textarea'), hint = lay.querySelector('.rcb-mc-hint');
      cap.maxLength = o.captionMax || 1000;
      lay.querySelector('.rcb-mc-tt').textContent = o.title || '';
      const chipHd = lay.querySelector('.hd'), chipOnce = lay.querySelector('.once');
      function paint() {
        big.style.backgroundImage = UI.img(urls[i]);
        strip.innerHTML = '';
        if (urls.length > 1) urls.forEach((u, k) => { const t = UI.el(`<div class="rcb-mc-th ${k === i ? 'on' : ''}"><i>${g('x', 11)}</i></div>`); t.style.backgroundImage = UI.img(u); t.onclick = () => { i = k; paint(); }; t.querySelector('i').onclick = e => { e.stopPropagation(); urls.splice(k, 1); if (!urls.length) { close(null); return; } i = Math.min(i, urls.length - 1); paint(); }; strip.appendChild(t); });
        const canOnce = urls.length === 1 && o.allowOnce !== false;
        if (!canOnce) once = false;
        chipOnce.classList.toggle('dis', !canOnce); chipOnce.classList.toggle('on', once); chipHd.classList.toggle('on', hd);
        hint.textContent = once ? 'Ver uma vez: abre-se uma única vez e não fica na conversa. Não impede capturas de ecrã.' : (hd ? 'Qualidade HD: a foto demora mais a enviar.' : (urls.length > 1 ? `${urls.length} fotos · a legenda vai com o álbum` : ''));
      }
      chipHd.onclick = () => { hd = !hd; paint(); };
      chipOnce.onclick = () => { if (chipOnce.classList.contains('dis')) { UI.toast('Ver uma vez só com uma foto'); return; } once = !once; paint(); };
      const onKey = e => { if (dead || e.key !== 'Escape' || (document.activeElement === cap)) return; e.preventDefault(); e.stopPropagation(); close(null); };
      const offApp = Bridge.on('app:close', id => { if (id === APP) close(null); });
      const offKill = Bridge.on('app:kill', id => { if (id === APP) close(null); });
      const offPhone = Bridge.on('phone:close', () => close(null));
      function close(v) { if (dead) return; dead = true; document.removeEventListener('keydown', onKey, true); offApp(); offKill(); offPhone(); darkBar(false); lay.classList.remove('in'); setTimeout(() => lay.remove(), 220); res(v); }
      document.addEventListener('keydown', onKey, true);
      lay.querySelector('.x').onclick = () => close(null);
      lay.querySelector('.rcb-mc-send').onclick = () => close({ urls: urls.slice(), caption: cap.value.trim().slice(0, o.captionMax || 1000), hd, once });
      cap.addEventListener('input', () => { cap.style.height = 'auto'; cap.style.height = Math.min(110, cap.scrollHeight) + 'px'; });
      win.appendChild(lay); darkBar(true); requestAnimationFrame(() => lay.classList.add('in')); setTimeout(() => { if (!dead) lay.classList.add('in'); }, 80);
      paint();
    });
  }

  /* =====================================================================
     CÂMARA: tirar a foto AQUI (CamView, o mesmo visor da app Câmara - como as Mensagens)
     → Promise<dataURL | null>. O visor é desligado em TODOS os caminhos (×, Escape, trocar de app).
     ===================================================================== */
  function camera(win, title) {
    return new Promise(async res => {
      if (!window.CamView || typeof CamView.mount !== 'function') { UI.toast('Câmara indisponível'); res(null); return; }
      if (window.Perm && !(await Perm.request(APP, 'camera'))) { res(null); return; }
      if (!win.isConnected) { res(null); return; }
      const lay = UI.el(`<div class="msg-cam rcb-camlay"><div class="mc-view"></div><div class="mc-still"></div><div class="mc-top"><div class="b x">${g('x', 22)}</div><div class="mc-ttl"></div><div class="b fl off">${g('bolt', 22)}</div></div><div class="mc-bot"><div class="mc-retake">Repetir</div><div class="mc-shut"><div></div></div><div class="mc-send">${g('check')}</div><div class="mc-flip">${g('repeat', 22)}</div></div></div>`);
      lay.querySelector('.mc-ttl').textContent = title || '';
      const view = lay.querySelector('.mc-view'), still = lay.querySelector('.mc-still');
      let cam = null, dead = false, raw = null, busy = false;
      /* ⚠️ sem o stopPropagation o system.js também ouve o Escape e fecha o TELEMÓVEL inteiro */
      const onKey = e => { if (dead || e.key !== 'Escape') return; e.preventDefault(); e.stopPropagation(); close(null); };
      const offApp = Bridge.on('app:close', id => { if (id === APP) close(null); });
      /* app morta com a câmara aberta: sem o destroy o visor (e o modo câmara do jogo) ficava ligado sem janela */
      const offKill = Bridge.on('app:kill', id => { if (id === APP) close(null); });
      function close(v) { if (dead) return; dead = true; document.removeEventListener('keydown', onKey, true); offApp(); offKill(); darkBar(false); try { if (cam) cam.destroy(); } catch (e) {} lay.remove(); res(v); }
      document.addEventListener('keydown', onKey, true);
      win.appendChild(lay); darkBar(true);
      try { cam = CamView.mount(view, { chrome: 'bare', aspect: (view.clientWidth || 440) / (view.clientHeight || 956), autoActivate: false, aimInside: true }); cam.setActive(true); }
      catch (e) { console.error('[apex_phone] CamView', e); close(null); UI.toast('Não foi possível abrir a câmara'); return; }
      requestAnimationFrame(() => { if (!dead) lay.classList.add('in'); }); setTimeout(() => { if (!dead) lay.classList.add('in'); }, 120);
      lay.querySelector('.b.x').onclick = () => close(null);
      lay.querySelector('.mc-flip').onclick = () => { if (!raw && cam) cam.flip(); };
      lay.querySelector('.b.fl').onclick = e => { if (!cam) return; cam.setFlash(!cam.flash); e.currentTarget.classList.toggle('off', !cam.flash); };
      lay.querySelector('.mc-shut').onclick = async () => {
        if (busy || dead || raw || !cam) return; busy = true;
        let r = null; try { r = await cam.capture(); } catch (e) { r = null; }
        busy = false; if (dead) return;
        if (!r || !r.raw) { UI.toast((r && r.msg) || 'Não foi possível tirar a fotografia', 3000); return; }
        raw = r.raw; still.style.backgroundImage = UI.img(raw); lay.classList.add('shot'); cam.setActive(false);
      };
      lay.querySelector('.mc-retake').onclick = () => { if (dead || !cam) return; raw = null; still.style.backgroundImage = ''; lay.classList.remove('shot'); cam.setActive(true); };
      lay.querySelector('.mc-send').onclick = () => { if (raw && !dead) close(raw); };
    });
  }

  /* prepara uma foto para o media.*: JPEG/PNG/WebP dentro do limite (normal ou HD) */
  async function prepImage(url, hd) {
    const C = cfg(), cap = hd ? C.hdImageBytes : C.maxImageBytes;
    if (typeof url !== 'string' || !/^data:image\//i.test(url)) return null;
    if (url.length <= cap - 2048 && /^data:image\/(jpeg|png|webp);base64,/i.test(url)) return url;
    let small = null;
    try { small = window.Photos ? await Photos.shrink(url, hd ? 1700 : 1100, 0, Math.max(20000, cap - 2048)) : null; } catch (e) { small = null; }
    return small && small !== (window.Photos && Photos.BLACK) ? small : null;
  }
  /* sobe uma foto: → { mediaId } | { error }. O HD vai marcado no meta; se o servidor recusar o tamanho,
     tenta-se em qualidade normal e diz-se isso (pedido feito ao server/media.lua para aceitar o HD) */
  async function uploadImage(url, hd, onProgress) {
    if (!window.Msgs || typeof Msgs.upload !== 'function') return { error: 'rpc' };
    let data = await prepImage(url, hd);
    if (!data) return { error: 'baddata' };
    const mime = ((/^data:(image\/[A-Za-z0-9.+-]+);/.exec(data) || [])[1] || 'image/jpeg').toLowerCase();
    let up = await Msgs.upload(data, { kind: 'image', mime, meta: hd ? { hd: true } : null }, onProgress);
    let hdOk = hd;
    if (hd && up && up.error === 'toolarge') {
      data = await prepImage(url, false); if (!data) return { error: 'baddata' };
      up = await Msgs.upload(data, { kind: 'image', mime: ((/^data:(image\/[A-Za-z0-9.+-]+);/.exec(data) || [])[1] || 'image/jpeg').toLowerCase() }, onProgress);
      hdOk = false; if (up && up.mediaId) UI.toast('HD indisponível neste servidor: enviada em qualidade normal', 2600);
    }
    if (!up || up.error || !up.mediaId) return { error: (up && up.error) || 'rpc' };
    try { Msgs.mediaPut(up.mediaId, { url: data, kind: 'image', mime }); } catch (e) {}   /* quem enviou já tem a imagem */
    return { mediaId: up.mediaId, hd: hdOk, url: data };
  }

  /* { number } | { conversation } | { group: { id } } | item do recado.threads | '555-0101' | 'g:12' */
  function normTarget(t) {
    if (t == null) return null;
    if (typeof t !== 'object') { const s = String(t); const gm = /^g:(\d+)$/.exec(s); t = gm ? { conversation: +gm[1] } : { number: s }; }
    const gid = int(t.conversation || (t.group && t.group.id) || ((/^g:(\d+)$/.exec(String(t.number == null ? '' : t.number)) || [])[1]));
    const number = gid > 0 ? null : String(t.number == null ? '' : t.number).trim().slice(0, 40);
    if (!(gid > 0) && !number) return null;
    return { gid: gid > 0 ? gid : 0, number, key: gid > 0 ? 'g:' + gid : 'n:' + number, raw: t };
  }
  const TICK = s => s === 'read' || s === 'delivered'
    ? `<svg class="rcb-tick ${s === 'read' ? 'read' : ''}" viewBox="0 0 18 11"><path d="M1 6l3 3.2L10.5 2"/><path d="M8.4 9.2L16.5 2"/></svg>`
    : s === 'sent' ? '<svg class="rcb-tick one" viewBox="0 0 12 11"><path d="M1 6l3 3.2L10.5 2"/></svg>'
    : s === 'pending' ? `<svg class="rcb-tick one" viewBox="0 0 12 12"><circle cx="6" cy="6" r="4.6"/><path d="M6 3.6V6l1.6 1.2"/></svg>` : '';
  const RANK = { sent: 1, delivered: 2, read: 3 };
  /* quanto antes da hora marcada o SERVIDOR deixa entrar numa chamada agendada (JOIN_EARLY_MS do
     server/recado_calls.lua): com 10 min o botão "Entrar" aparecia tarde e o RF já entrava aos 15 */
  const JOIN_EARLY_MS = 15 * 60000;
  /* fundos dos estados (RE): as mesmas chaves do servidor e do recado-updates.js; a cor é o primeiro tom do
     gradiente que o app-recado-updates.css usa em .rcu-bg-* (sem color-mix, o CEF não o tem) */
  const STATUS_BG = { indigo: '#22C55E', aurora: '#128C7E', ciano: '#22D3EE', oceano: '#0EA5E9', menta: '#34D399', ambar: '#FBBF24', coral: '#FB7185', rosa: '#F472B6', ameixa: '#8B5CF6', grafite: '#4B5563' };
  const STATUS_KIND = { text: 'Atualização', image: 'Foto', audio: 'Áudio', sticker: 'Autocolante' };
  /* pionés (o glifo 'pin' do sistema é o marcador de mapa e lia-se como localização) */
  const PIN_GL = '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 3h6l-1 6 3 3v2H7v-2l3-3z"/><path d="M12 14v7"/></svg>';
  /* temas de conversa do grupo (RC grava `theme`): nomes em português e em inglês dão no mesmo */
  const THEMES = { indigo: 'indigo', default: 'indigo', padrao: 'indigo', oceano: 'ocean', ocean: 'ocean', mar: 'ocean', 'por-do-sol': 'sunset', sunset: 'sunset', floresta: 'forest', forest: 'forest', rosa: 'rose', rose: 'rose', grafite: 'graphite', graphite: 'graphite', lavanda: 'lavender', lavender: 'lavender', noite: 'night', night: 'night' };
  /* mapa pequeno DESENHADO (sem imagens nem mosaicos externos): ruas e quarteirões por sementes das coordenadas */
  function mapArt(x, y) {
    let s = (Math.abs(Math.floor(+x || 0)) * 73856093 ^ Math.abs(Math.floor(+y || 0)) * 19349663) >>> 0 || 1234567;
    const rnd = () => { s = (Math.imul(s, 1103515245) + 12345) >>> 0; return ((s >>> 8) % 1000) / 1000; };
    const blocks = [];
    for (let i = 0; i < 9; i++) { const bx = Math.round(rnd() * 250), by = Math.round(rnd() * 120), bw = 26 + Math.round(rnd() * 44), bh = 16 + Math.round(rnd() * 30); blocks.push(`<rect class="bk" x="${bx}" y="${by}" width="${bw}" height="${bh}" rx="3"/>`); }
    const a = Math.round(rnd() * 40 - 20), b = Math.round(rnd() * 140 + 20), c = Math.round(rnd() * 90 + 20);
    const water = rnd() > .5 ? `<path class="wt" d="M0 ${110 + Math.round(rnd() * 20)} C 60 ${96 + Math.round(rnd() * 20)}, 140 ${130}, 280 ${104 + Math.round(rnd() * 16)} L280 140 L0 140Z"/>` : `<circle class="pk" cx="${Math.round(rnd() * 220 + 30)}" cy="${Math.round(rnd() * 60 + 20)}" r="${Math.round(rnd() * 14 + 14)}"/>`;
    return `<svg class="rcb-map-art" viewBox="0 0 280 140" preserveAspectRatio="xMidYMid slice">${water}${blocks.join('')}<path class="rd big" d="M-10 ${c} L290 ${c + a}"/><path class="rd" d="M${b} -10 L${b + a} 150"/><path class="rd sm" d="M${Math.round(b / 2)} -10 L${Math.round(b / 2) + 60} 150"/><path class="rd sm" d="M-10 ${Math.round(c / 2)} L290 ${Math.round(c / 2) - 14}"/></svg>`;
  }

  /* =====================================================================
     A CONVERSA
     ===================================================================== */
  function open(win, target, opts) {
    opts = opts || {};
    if (!win || !win.isConnected) { const r = R(); win = r && r.win; }
    if (!win || !win.isConnected) return null;
    const T0 = normTarget(target); if (!T0) return null;
    const { gid, number, key } = T0, isGroup = gid > 0, raw = T0.raw;
    /* a MESMA conversa já está à frente (notificação dela, "Mensagem" no perfil): empilhar outra cópia
       duplicava ouvintes, "a escrever" e marcações de lida - só se desce ao fim ou à mensagem pedida */
    { const stack = win.querySelector('.nav-stack');
      if (cur && cur.win === win && cur.key === key && !cur.isDead() && stack && cur.view.parentElement === stack) {
        /* a conversa está na pilha mas tapada (perfil → "Mensagem", info do grupo → conversa): volta-se a ela em vez de
           empilhar uma 2.ª cópia. As vistas do meio largam-se pelo onPop delas; a de cima sai com a animação normal. */
        const kids = [...stack.children], above = kids.slice(kids.indexOf(cur.view) + 1).filter(x => !x.classList.contains('leave'));
        if (above.length) {
          above.slice(0, -1).forEach(x => { try { x.opts && x.opts.onPop && x.opts.onPop(); } catch (e) { console.error('[apex_phone] onPop', e); } x.remove(); });
          const top = above[above.length - 1];
          if (stack.lastElementChild === top) UI.pop(stack);
          else { try { top.opts && top.opts.onPop && top.opts.onPop(); } catch (e) {} top.remove(); cur.view.classList.remove('behind'); }
        }
        if (opts.messageId) cur.jumpTo(opts.messageId); else cur.toBottom();
        return cur.pub;
      } }
    const C = cfg(), me = myNumber();
    const q = isGroup ? { conversation: gid } : { number };
    const qa = Object.assign({ app: APP }, q);
    const st = { msgs: new Map(), order: [], rows: new Map(), more: false, loaded: false, queue: [], loadP: null, replyTo: null, dead: false, unseen: false,
      members: {}, left: false, policy: 'all', admin: false, blocked: false, typers: new Map(), recs: new Map(), pins: [], pinIdx: 0,
      disappearing: 0, locked: false, presence: null, pendingStatus: new Map(), readUpTo: {}, newCount: 0, unreadMark: int(raw.unread), recorder: null };
    let title = raw.name || (raw.group && (raw.group.title || raw.group.name)) || (isGroup ? 'Grupo' : nameOf(number));
    /* timers num Set que se esvazia ao disparar: numa conversa aberta horas a fio a lista não cresce sem fim */
    const offs = [], timers = new Set();
    const later = (f, ms) => { const t = setTimeout(() => { timers.delete(t); if (!st.dead) f(); }, ms); timers.add(t); return t; };

    const v = UI.view({ title: '', back: true, full: true, solid: true, cls: 'rcb-view', onPop: cleanup,
      right: [{ icon: 'video', cls: 'rcb-nb-video', onTap: () => callVideo() }, { icon: 'phone', cls: 'rcb-nb-voice', onTap: () => callVoice() }] });
    v.dataset.key = key;
    { const bs = v.querySelector('.nb-back span'); if (bs) bs.textContent = ''; }

    /* ---------- cabeçalho: avatar + nome + online / visto / a escrever / a gravar / membros ---------- */
    const head = UI.el('<div class="rcb-head"><div class="rcb-hav"></div><div class="rcb-htx"><b></b><small></small></div></div>');
    v.querySelector('.nb-left').appendChild(head);
    const hName = head.querySelector('b'), hSub = head.querySelector('small'), hAv = head.querySelector('.rcb-hav');
    const nameFor = s => (s === me ? 'Tu' : (st.members[s] && st.members[s].name) || nameOf(s));
    function paintHead() {
      hName.textContent = title;
      paintAvatar(hAv, isGroup ? { conversation: gid, mediaId: raw.group && raw.group.avatar } : { number, name: title });
    }
    function paintSub() {
      const recs = [...st.recs.keys()], typ = [...st.typers.keys()].filter(x => !st.recs.has(x));
      const who = l => l.slice(0, 2).map(x => nameFor(x).split(/\s+/)[0]).join(' e ') + (l.length > 2 ? ' e mais' : '');
      hSub.classList.remove('live');
      /* conversa bloqueada com código: nem "a escrever…" nem "online" antes de a desbloquearem */
      if (st.locked) { hSub.textContent = 'Conversa bloqueada'; return; }
      if (recs.length) { hSub.textContent = isGroup ? `${who(recs)} ${recs.length > 1 ? 'estão' : 'está'} a gravar áudio…` : 'a gravar áudio…'; hSub.classList.add('live'); return; }
      if (typ.length) { hSub.textContent = isGroup ? `${who(typ)} ${typ.length > 1 ? 'estão' : 'está'} a escrever…` : 'a escrever…'; hSub.classList.add('live'); return; }
      if (isGroup) {
        const ms = Object.keys(st.members);
        if (st.left) { hSub.textContent = 'Já não és membro'; return; }
        const names = ms.sort((a, b) => (a === me) - (b === me)).map(nameFor);
        hSub.textContent = names.length ? names.slice(0, 4).join(', ') + (names.length > 4 ? ` e mais ${names.length - 4}` : '') : 'toca para ver o grupo';
        return;
      }
      hSub.textContent = st.blocked ? 'Contacto bloqueado' : (seenText(st.presence) || 'toca para ver o perfil');
    }
    head.onclick = () => { if (isGroup) groupInfo(); else openProfile(number); };
    function openProfile(n) {
      const P = People();
      if (fn(P, 'openProfile')) { try { P.openProfile(win, String(n)); return; } catch (e) { console.error('[apex_phone] RecadoPeople.openProfile', e); } }
      const c = window.Contacts && Contacts.byNumber(String(n));
      if (c && typeof contactDetail === 'function') contactDetail(win, c, 'Anterior');
      else if (typeof addContact === 'function' && String(n) !== me) addContact(null, { number: String(n) });
    }
    function groupInfo() {
      const P = People();
      if (fn(P, 'groupInfo')) { try { P.groupInfo(win, gid); return; } catch (e) { console.error('[apex_phone] RecadoPeople.groupInfo', e); } }
      if (window.Groups && typeof Groups.info === 'function') { try { Groups.info(win, gid); return; } catch (e) {} }
      UI.toast('Informações do grupo indisponíveis');
    }
    /* chamadas: RF (1:1 pela app Telefone, grupo com Voice); sem RF, a app Telefone faz as 1:1 */
    function callVoice() {
      const K = Calls();
      if (fn(K, 'voice')) { try { K.voice(Object.assign({}, q, { name: title })); return; } catch (e) { console.error('[apex_phone] RecadoCalls.voice', e); } }
      if (!isGroup && window.PhoneApp) PhoneApp.call(number, title); else UI.toast('Chamadas de grupo indisponíveis');
    }
    function callVideo() {
      const K = Calls();
      if (fn(K, 'video')) { try { K.video(Object.assign({}, q, { name: title })); return; } catch (e) { console.error('[apex_phone] RecadoCalls.video', e); } }
      if (!isGroup && window.PhoneApp && PhoneApp.facetime) PhoneApp.facetime(number, title); else UI.toast('Videochamada indisponível');
    }

    /* ---------- faixa das fixadas (até pinsMax; tocar salta e passa à seguinte) ---------- */
    const pinBar = UI.el(`<div class="rcb-pins hidden"><div class="rcb-pins-ind"></div><div class="rcb-pins-tx"><b>Mensagem fixada</b><span></span></div><div class="rcb-pins-ic">${PIN_GL}</div></div>`);
    /* ---------- aviso de mensagens temporárias ---------- */
    const tempBar = UI.el(`<div class="rcb-temp hidden">${g('timer', 15)}<span></span></div>`);
    v.insertBefore(pinBar, v.content); v.insertBefore(tempBar, v.content);

    const sc = v.content; sc.classList.add('rcb-scroll');
    const thread = UI.el('<div class="rcb-thread"></div>');
    const moreEl = UI.el('<div class="rcb-more hidden"><span>Mensagens anteriores</span><i class="spinner"></i></div>');
    const sk = UI.el('<div class="rcb-sk"><i></i><i class="me"></i><i></i><i class="me w"></i><i class="w"></i></div>');
    const typingEl = UI.el('<div class="rcb-typing"><div class="rcb-dots"><i></i><i></i><i></i></div><small></small></div>');
    thread.append(moreEl, sk, typingEl); sc.appendChild(thread);
    const downBtn = UI.el(`<div class="rcb-down">${g('chevD', 22)}<span></span></div>`);
    const lockEl = UI.el(`<div class="rcb-lock hidden"><div class="rcb-lock-ic">${g('lock', 34)}</div><b>Conversa bloqueada</b><span>Esta conversa está protegida com o código do telemóvel.</span><div class="rcb-btn">Desbloquear</div></div>`);
    v.append(lockEl);

    /* as imagens só descem quando se aproximam do ecrã; sem IntersectionObserver descem logo */
    const io = 'IntersectionObserver' in window ? new IntersectionObserver(es => es.forEach(e => { if (e.isIntersecting) { io.unobserve(e.target); loadPic(e.target); } }), { root: sc, rootMargin: '500px 0px' }) : null;
    const nearBottom = () => sc.scrollHeight - sc.scrollTop - sc.clientHeight < 140;
    const scrollBottom = () => { sc.scrollTop = 1e7; st.newCount = 0; paintDown(); };
    const dayKey = m => new Date(+m.created).toDateString();
    const anchor = () => thread.querySelector(':scope > .pending') || typingEl;
    const within = (m, min) => Date.now() - (+m.created || 0) <= min * 60000 + 60000;
    const upgrade = (m, s, at) => { if (!RANK[s] || (RANK[m.status] || 0) >= RANK[s]) return false; m.status = s; if (s === 'read' && at) m.readAt = +at; if (s === 'delivered' && at && !m.deliveredAt) m.deliveredAt = +at; return true; };

    function norm(m) {
      m.id = int(m.id); m.created = +m.created || Date.now();
      m.payload = payloadOf(m);
      if (m.deleted || m.deleted_all) { m.deleted = true; m.content = ''; m.payload = {}; }
      if (m.editedAt == null && m.edited_at) m.editedAt = m.edited_at;
      if (m.readAt == null && m.read_at) m.readAt = m.read_at;
      if (m.deliveredAt == null && m.delivered_at) m.deliveredAt = m.delivered_at;
      if (m.expiresAt == null && m.expires_at) m.expiresAt = m.expires_at;
      if (m.viewOnce == null && m.view_once != null) m.viewOnce = !!+m.view_once;
      if (m.viewed == null && m.viewed_at) m.viewed = m.viewed_at;
      /* o push `message` do messages.send leva as marcas do Recado só no payload (viewOnce, fwd, ttl): a bolha
         de "ver uma vez" nunca mostra a media que por acaso veio no push - abre-se só pelo recado.viewOnce */
      if (!(+m.expiresAt > 0) && int(m.payload.ttl) > 0) m.expiresAt = m.created + int(m.payload.ttl) * 1000;
      m.forwarded = !!(m.forwarded === true || +m.forwarded === 1 || m.payload.fwd === true);
      if (m.payload.viewOnce === true) m.viewOnce = true;
      if (m.viewOnce && !m.deleted) { m.payload = { viewOnce: true, duration: m.type === 'audio' ? m.payload.duration : undefined }; if (m.sender !== me) m.content = ''; }
      m.starred = !!m.starred;
      m.type = typeof m.type === 'string' && m.type ? m.type : 'text';
      m.reactions = m.deleted ? [] : arr(m.reactions);
      const ps = st.pendingStatus.get(m.id); if (ps) { upgrade(m, ps.status, ps.at); st.pendingStatus.delete(m.id); }
      return m;
    }
    const albumKey = m => (m && m.type === 'image' && !m.deleted && !m.viewOnce && albumOf(m)) ? m.sender + '|' + albumOf(m) : '';
    function unitsOf(list) {
      const units = [];
      list.forEach(m => { if (!m) return; const k = albumKey(m), last = units[units.length - 1];
        if (k && last && last.k === k && dayKey(last.ms[0]) === dayKey(m)) last.ms.push(m); else units.push({ k, ms: [m] }); });
      return units;
    }
    function sepEl(m) { const e = UI.el('<div class="rcb-day"><span></span></div>'); e.firstElementChild.textContent = dayLabel(m.created); return e; }
    function buildRows(list, prev) {
      const frag = document.createDocumentFragment();
      unitsOf(list).forEach(u => {
        const first = u.ms[0];
        if (!prev || dayKey(prev) !== dayKey(first)) frag.appendChild(sepEl(first));
        const r = rowFor(u.ms, prev); u.ms.forEach(x => st.rows.set(x.id, r)); frag.appendChild(r);
        prev = u.ms[u.ms.length - 1];
      });
      return frag;
    }

    /* ---------- uma linha = uma mensagem ou um álbum ---------- */
    function rowFor(ms, prev) {
      const m = ms[ms.length - 1], first = ms[0];
      if (m.type === 'system') { const r = UI.el('<div class="rcb-row sys"><div class="rcb-sys"></div></div>'); r.firstElementChild.textContent = sysText(m); r._ids = [m.id]; r.dataset.id = m.id; return r; }
      const mine = m.sender === me;
      const run = !prev || prev.sender !== first.sender || prev.type === 'system' || dayKey(prev) !== dayKey(first) || (+first.created - +prev.created > 10 * 60000);
      const r = UI.el(`<div class="rcb-row ${mine ? 'me' : 'them'}${run ? ' run' : ''}"></div>`);
      r._ids = ms.map(x => x.id); r.dataset.id = first.id;
      const b = UI.el('<div class="rcb-bubble"></div>');
      if (isGroup && !mine && run && !m.deleted) { const n = UI.el('<div class="rcb-from"></div>'); n.textContent = nameFor(m.sender); n.style.color = colorOf(m.sender); n.onclick = e => { e.stopPropagation(); openProfile(m.sender); }; b.appendChild(n); }
      if (m.forwarded && !m.deleted) b.appendChild(UI.el(`<div class="rcb-fwd">${g('forward', 13)}<span>Reencaminhada</span></div>`));
      const rq = !m.deleted && m.replyTo && typeof m.replyTo === 'object' && m.replyTo.id ? m.replyTo : null;
      if (rq) {
        const orig = st.msgs.get(int(rq.id)), who = rq.sender || (orig && orig.sender);
        const qo = UI.el('<div class="rcb-quote"><b></b><span></span></div>');
        qo.querySelector('b').textContent = who ? (who === me ? 'Tu' : nameFor(who)) : 'Resposta';
        if (who) qo.style.setProperty('--qc', who === me ? '#128C7E' : colorOf(who));
        qo.querySelector('span').textContent = rq.deleted || (orig && orig.deleted) ? 'Mensagem apagada' : (orig ? label(orig) : (rq.preview || 'Mensagem'));
        qo.onclick = e => { e.stopPropagation(); jumpTo(int(rq.id)); };
        b.appendChild(qo);
      }
      if (!m.deleted && (m.type || 'text') === 'text') { const sq = statusQuoteEl(m); if (sq) b.appendChild(sq); }
      fill(b, ms, mine);
      r.appendChild(b);
      const rx = reactsEl(m); if (rx) r.appendChild(rx);
      UI.longPress(b, () => menu(ms, b));
      return r;
    }
    /* ---------- citação de um estado (pedido do RE) ----------
       Responder a uma atualização dá uma mensagem de TEXTO normal com payload.status =
       { id, owner, kind, bg, preview } (o statusQuote do server/recado.lua). O campo pode faltar (servidor mais
       antigo ou mensagem de outra origem): nesse caso não se desenha nada e a bolha fica como sempre.
       A citação não traz media: a "miniatura" é a cor do fundo do estado, na mesma barra das citações de resposta. */
    function statusQuoteEl(m) {
      const p = m.payload && typeof m.payload === 'object' ? m.payload : null;
      const s = p && p.status && typeof p.status === 'object' && !Array.isArray(p.status) ? p.status : null;
      if (!s || !int(s.id)) return null;
      const owner = String(s.owner == null ? '' : s.owner).trim().slice(0, 20);
      const kind = STATUS_KIND[s.kind] ? s.kind : 'text';
      const qo = UI.el('<div class="rcb-quote rcb-qstatus"><b></b><span></span></div>');
      qo.style.setProperty('--qc', STATUS_BG[typeof s.bg === 'string' ? s.bg : ''] || '#128C7E');
      qo.querySelector('b').textContent = !owner ? 'Estado' : (owner === me ? 'O teu estado' : 'Estado de ' + nameFor(owner));
      const pv = String(s.preview == null ? '' : s.preview).replace(/\s+/g, ' ').trim().slice(0, 90);
      qo.querySelector('span').textContent = pv || STATUS_KIND[kind];
      /* o estado pode já ter expirado (24 h): abre-se o visor do dono, que é o que o RE sabe abrir */
      qo.onclick = e => {
        e.stopPropagation();
        const U = Updates();
        if (!owner || !fn(U, 'openStatus')) { UI.toast('As Atualizações não estão disponíveis nesta versão'); return; }
        try { U.openStatus(win, owner); } catch (x) { console.error('[apex_phone] RecadoUpdates.openStatus', x); }
      };
      return qo;
    }
    function metaEl(m, mine, over) {
      const e = UI.el(`<span class="rcb-meta${over ? ' over' : ''}"></span>`);
      let h = '';
      if (m.starred) h += `<i class="rcb-star">${g('starFill', 11)}</i>`;
      if (+m.expiresAt > 0) h += `<i class="rcb-exp">${g('timer', 11)}</i>`;
      if (m.editedAt && !m.deleted) h += '<em>editada</em>';
      h += `<time>${fmtTime(m.created)}</time>`;
      if (mine && !m.deleted) h += TICK(m.status || 'sent');
      e.innerHTML = h;   /* só marcas nossas e a hora formatada: nada vindo do servidor entra cru */
      return e;
    }
    /* reserva no fim do texto o lugar da hora/estado (a meta fica por cima, no canto) */
    const spacer = (m, mine) => { const s = document.createElement('span'); s.className = 'rcb-sp'; s.style.width = (44 + (mine ? 20 : 0) + (m.editedAt ? 50 : 0) + (m.starred ? 15 : 0) + (+m.expiresAt > 0 ? 15 : 0)) + 'px'; return s; };
    const JUMBO = (() => { try { return new RegExp('^(?:\\p{Extended_Pictographic}[\\uFE0F\\u200D\\p{Extended_Pictographic}\\u{1F3FB}-\\u{1F3FF}]*\\s*){1,3}$', 'u'); } catch (e) { return null; } })();

    function fill(b, ms, mine) {
      const m = ms[ms.length - 1], p = m.payload || {};
      const add = (...c) => b.classList.add(...c);
      if (m.deleted) { add('deleted'); b.appendChild(UI.el(`<div class="rcb-del">${g('ban', 15)}<span>${mine ? 'Apagaste esta mensagem' : 'Esta mensagem foi apagada'}</span></div>`)); b.appendChild(metaEl(m, false)); return; }
      switch (m.type) {
        case 'text': {
          const t = UI.el('<div class="rcb-text"></div>');
          const content = String(m.content == null ? '' : m.content);
          if (JUMBO && content.length <= 24 && JUMBO.test(content.trim())) { add('jumbo'); t.textContent = content.trim(); b.appendChild(t); b.appendChild(metaEl(m, mine)); return; }
          t.innerHTML = formatText(content);
          if (isGroup) markMentions(t, st.members);
          t.appendChild(spacer(m, mine)); b.appendChild(t); b.appendChild(metaEl(m, mine));
          return;
        }
        case 'image': {
          if (m.viewOnce) { fillOnce(b, m, mine); return; }
          const imgs = ms.filter(x => x.type === 'image');
          const cap = [...imgs].reverse().map(captionOf).find(Boolean);
          add('media');
          if (imgs.length > 1) {
            const n = imgs.length, grid = UI.el(`<div class="rcb-album n${Math.min(n, 4)}"></div>`);
            imgs.slice(0, 4).forEach((x, k) => {
              const cell = UI.el('<div class="rcb-pic"></div>'); paintPic(cell, x);
              if (k === 3 && n > 4) cell.appendChild(UI.el(`<div class="rcb-more-n">+${n - 4}</div>`));
              cell.onclick = e => { e.stopPropagation(); openViewer(imgs, k); };
              grid.appendChild(cell);
            });
            b.appendChild(grid);
          } else {
            const pic = UI.el('<div class="rcb-pic single"></div>');
            const w = +p.w, h = +p.h; if (w > 0 && h > 0) pic.style.setProperty('--ar', clamp(w / h, .56, 1.6).toFixed(3));
            if (p.hd) pic.appendChild(UI.el('<i class="rcb-hd">HD</i>'));
            paintPic(pic, m);
            pic.onclick = e => { e.stopPropagation(); if (pic.classList.contains('failed')) loadPic(pic); else openViewer(imgs, 0); };
            b.appendChild(pic);
          }
          if (cap) { const t = UI.el('<div class="rcb-text cap"></div>'); t.innerHTML = formatText(cap); if (isGroup) markMentions(t, st.members); t.appendChild(spacer(m, mine)); b.appendChild(t); b.appendChild(metaEl(m, mine)); }
          else b.appendChild(metaEl(m, mine, true));
          return;
        }
        case 'audio': {
          if (m.viewOnce) { fillOnce(b, m, mine); return; }
          add('audio');
          const host = UI.el('<div class="rcb-audio"></div>');
          let ok = false;
          if (window.VoiceMsg && typeof VoiceMsg.player === 'function') {
            try { const el = VoiceMsg.player({ mediaId: midOf(m), duration: p.duration, waveform: Array.isArray(p.waveform) ? p.waveform : [] }); if (el && el.nodeType === 1) { el._rcbWho = nameFor(m.sender); el._rcbId = m.id; host.appendChild(el); ok = true; } }
            catch (e) { console.error('[apex_phone] VoiceMsg.player', e); }
          }
          if (!ok) { host.classList.add('na'); host.innerHTML = `${g('mic', 20)}<span></span>`; host.querySelector('span').textContent = 'Mensagem de voz' + (audioDur(p.duration) ? ' · ' + audioDur(p.duration) : ''); }
          b.appendChild(host); b.appendChild(metaEl(m, mine));
          return;
        }
        case 'location': {
          add('media', 'loc');
          const map = UI.el(`<div class="rcb-map">${mapArt(p.x, p.y)}<div class="rcb-map-pin">${g('pin', 30)}</div></div>`);
          const tx = UI.el('<div class="rcb-loc-tx"><b></b><span></span></div>');
          tx.querySelector('b').textContent = String(p.label || 'Localização').slice(0, 80);
          tx.querySelector('span').textContent = (p.street ? String(p.street).slice(0, 60) + ' · ' : '') + (isFinite(+p.x) && isFinite(+p.y) ? `${Math.round(+p.x)}, ${Math.round(+p.y)}` : 'Los Santos');
          const acts = UI.el('<div class="rcb-acts"><div data-a="map">Abrir no Mapas</div><div data-a="gps">Marcar GPS</div></div>');
          const showMap = () => { System.openApp('maps'); setTimeout(() => window.Maps && Maps.showAt({ x: +p.x, y: +p.y, name: p.label || 'Localização' }), 300); };
          map.onclick = e => { e.stopPropagation(); showMap(); };
          acts.querySelector('[data-a="map"]').onclick = e => { e.stopPropagation(); showMap(); };
          acts.querySelector('[data-a="gps"]').onclick = e => { e.stopPropagation(); if (!isFinite(+p.x) || !isFinite(+p.y)) return; Bridge.call('setWaypoint', { x: +p.x, y: +p.y, name: String(p.label || 'Localização').slice(0, 60) }); UI.toast('Destino marcado no GPS'); };
          b.append(map, tx, metaEl(m, mine), acts);
          return;
        }
        case 'contact': {
          add('rcb-card');
          const n = String(p.number == null ? '' : p.number).slice(0, 20);
          const ct = UI.el('<div class="rcb-ct"><div class="rcb-ct-av"></div><div class="rcb-ct-tx"><b></b><span></span></div></div>');
          paintAvatar(ct.querySelector('.rcb-ct-av'), { number: n, name: p.name });
          ct.querySelector('b').textContent = String(p.name || n || 'Contacto').slice(0, 60); ct.querySelector('span').textContent = n;
          b.appendChild(ct);
          if (n && n !== me) {
            const known = window.Contacts && Contacts.byNumber(n);
            const acts = UI.el(`<div class="rcb-acts"><div data-a="chat">Mensagem</div><div data-a="add">${known ? 'Ver contacto' : 'Adicionar'}</div></div>`);
            acts.querySelector('[data-a="chat"]').onclick = e => { e.stopPropagation(); const r = R(); if (r && typeof r.openChat === 'function') r.openChat({ number: n }); else open(win, { number: n, name: p.name }); };
            acts.querySelector('[data-a="add"]').onclick = e => { e.stopPropagation(); const c = window.Contacts && Contacts.byNumber(n); if (c) openProfile(n); else if (typeof addContact === 'function') addContact(() => rerender(m.id), { name: p.name, number: n }); };
            b.appendChild(metaEl(m, mine)); b.appendChild(acts);
          } else b.appendChild(metaEl(m, mine));
          return;
        }
        case 'call': { fillCall(b, m, mine); return; }
        case 'sticker': case 'gif': case 'document': case 'poll': case 'event': {
          add('ext', 'ext-' + m.type);
          if (m.type === 'sticker' || m.type === 'gif') add('bare');
          const host = UI.el(`<div class="rcb-ext t-${m.type}"></div>`);
          b.appendChild(host);
          let done = false; const X = Extras();
          if (fn(X, 'render')) { try { done = X.render(m, host) === true; } catch (e) { console.error('[apex_phone] RecadoExtras.render', e); done = false; } }
          if (!done) { host.innerHTML = ''; fallbackExt(host, m); }
          b.appendChild(metaEl(m, mine, m.type === 'sticker' || m.type === 'gif'));
          return;
        }
        default: {
          const t = UI.el('<div class="rcb-text"></div>');
          t.textContent = m.content ? String(m.content) : 'Mensagem não suportada nesta versão';
          t.appendChild(spacer(m, mine)); b.appendChild(t); b.appendChild(metaEl(m, mine));
        }
      }
    }
    /* tipos do RD sem o RD: diz-se o que é, sem inventar funcionalidade */
    function fallbackExt(host, m) {
      const p = m.payload || {};
      if (m.type === 'sticker') { host.classList.add('fb'); host.textContent = typeof p.emoji === 'string' && p.emoji.length <= 16 ? p.emoji : '🗒️'; return; }
      if (m.type === 'gif') {
        if (typeof p.url === 'string' && /^https:\/\//.test(p.url) && p.url.length < 1024) { const gi = UI.el('<div class="rcb-gif"><i>GIF</i></div>'); gi.style.backgroundImage = UI.img(p.url); const w = +p.w, h = +p.h; if (w > 0 && h > 0) gi.style.setProperty('--ar', clamp(w / h, .5, 2).toFixed(3)); host.appendChild(gi); }
        else host.textContent = 'GIF';
        return;
      }
      const card = UI.el(`<div class="rcb-xcard"><div class="rcb-xcard-ic"></div><div class="rcb-xcard-tx"><b></b><span></span></div></div>`);
      const ic = card.querySelector('.rcb-xcard-ic'), bT = card.querySelector('b'), sT = card.querySelector('span');
      if (m.type === 'document') { ic.innerHTML = g('book', 22); bT.textContent = String(p.title || 'Documento').slice(0, 80); sT.textContent = plain(p.body || '').slice(0, 90) || 'Nota de texto';
        card.onclick = e => { e.stopPropagation(); const body = UI.el('<div class="rcb-doc"></div>'); body.innerHTML = formatText(String(p.body || '')); UI.sheet({ title: String(p.title || 'Documento').slice(0, 40), right: 'OK', body, cls: 'rcb-sheet' }); }; }
      else if (m.type === 'poll') { ic.innerHTML = g('chart', 22); bT.textContent = String(p.question || m.content || 'Sondagem').slice(0, 120); sT.textContent = 'Abre a versão mais recente do Zapp para votar'; }
      else { ic.innerHTML = g('calendar', 22); bT.textContent = String(p.title || m.content || 'Evento').slice(0, 80); sT.textContent = +p.start > 0 ? UI.fmtDate(new Date(+p.start), true) + ' · ' + UI.fmtTime(new Date(+p.start)) : 'Evento'; }
      host.appendChild(card);
    }
    function fillCall(b, m, mine) {
      const p = m.payload || {}; b.classList.add('rcb-card', 'call');
      const s = String(p.status || '');
      /* "live" = a janela em que o servidor deixa mesmo entrar: JOIN_EARLY_MS (15 min) do server/recado_calls.lua */
      const live = s === 'active' || s === 'ongoing' || (s === 'scheduled' && +p.start > 0 && +p.start - Date.now() < JOIN_EARLY_MS);
      const K = Calls();
      /* o RF desenha a sua própria bolha (e põe lá o "Entrar" só na janela em que a chamada se pode usar):
         com ele não se redesenha nada à mão - o cartão abaixo é o recurso para quem não tem o pacote RF */
      let drawn = false;
      if (fn(K, 'renderMessage')) { try { drawn = K.renderMessage(m, b) === true; } catch (x) { console.error('[apex_phone] RecadoCalls.renderMessage', x); drawn = false; } }
      if (!drawn) {
        const dur = +p.duration > 0 ? UI.fmtDur(+p.duration > 36000 ? +p.duration / 1000 : +p.duration) : '';
        const STATUS = { missed: mine ? 'Sem resposta' : 'Chamada perdida', declined: 'Recusada', busy: 'Ocupado', cancelled: 'Cancelada', offline: 'Indisponível', unavailable: 'Indisponível', answered: 'Terminada' + (dur ? ' · ' + dur : ''), ended: 'Terminada' + (dur ? ' · ' + dur : ''), active: 'A decorrer', ongoing: 'A decorrer', scheduled: 'Agendada' };
        const card = UI.el(`<div class="rcb-call ${s === 'missed' && !mine ? 'missed' : ''}"><div class="rcb-call-ic">${g(p.video ? 'video' : 'phone', 20)}</div><div class="rcb-call-tx"><b></b><span></span></div></div>`);
        card.querySelector('b').textContent = s === 'scheduled' ? String(p.title || (p.video ? 'Videochamada agendada' : 'Chamada agendada')).slice(0, 60) : (isGroup ? (p.video ? 'Videochamada de grupo' : 'Chamada de grupo') : (p.video ? 'Videochamada' : 'Chamada de voz'));
        card.querySelector('span').textContent = s === 'scheduled' && +p.start > 0 ? 'Agendada para ' + UI.fmtDate(new Date(+p.start), true) + ' às ' + UI.fmtTime(new Date(+p.start)) : (STATUS[s] || (p.video ? 'Videochamada simulada' : 'Chamada'));
        b.appendChild(card);
      }
      b.appendChild(metaEl(m, mine));
      /* sem botão de entrar (o RF tirou-o, ou não há RF): fica a linha de ações - entrar, se dá, senão ligar de volta */
      if (!b.querySelector('.rcc-msg-go')) {
        const acts = UI.el(`<div class="rcb-acts"><div data-a="go">${live ? 'Entrar' : (p.video ? 'Videochamada' : 'Ligar')}</div></div>`);
        acts.querySelector('[data-a="go"]').onclick = e => {
          e.stopPropagation();
          if (live && (p.code || p.callId) && fn(K, 'joinLink')) { try { K.joinLink(win, p.code || String(p.callId)); return; } catch (x) {} }
          if (p.video) callVideo(); else callVoice();
        };
        b.appendChild(acts);
      }
      b.dataset.call = p.callId != null ? String(p.callId).slice(0, 40) : '';
    }
    /* "ver uma vez": a bolha fechada nunca traz a media; quem recebe pede-a ao recado.viewOnce */
    function fillOnce(b, m, mine) {
      b.classList.add('once');
      const opened = !!m.viewed;
      const el = UI.el(`<div class="rcb-once ${opened ? 'opened' : ''}"><div class="rcb-once-ic">${g(opened ? 'checkCircle' : 'eye', 20)}</div><div class="rcb-once-tx"><b></b><span></span></div></div>`);
      const voice = m.type === 'audio', what = voice ? 'Mensagem de voz' : 'Foto';
      el.querySelector('b').textContent = opened ? (voice ? 'Ouvida' : 'Aberta') : what;
      el.querySelector('span').textContent = mine ? (opened ? what + ' de ver uma vez' : (voice ? 'Ouvir uma vez · por ouvir' : 'Ver uma vez · por abrir')) : (opened ? what + ' de ver uma vez' : (voice ? 'Toca para ouvir uma vez' : 'Toca para ver uma vez'));
      if (!mine && !opened) el.onclick = e => { e.stopPropagation(); openOnce(m); };
      b.appendChild(el); b.appendChild(metaEl(m, mine));
    }
    async function openOnce(m) {
      if (m._opening) return; m._opening = true;
      let r = null; try { r = await Bridge.rpcRaw('recado.viewOnce', { id: m.id }); } catch (e) { r = null; }
      if (st.dead) return;
      if (!r || r.error || !(int(r.mediaId) > 0)) { m._opening = false; if (r && r.error === 'viewed') { m.viewed = Date.now(); rerender(m.id); } UI.toast(errText(r, 'Não foi possível abrir a foto')); return; }
      /* a partir daqui o servidor já a deu como vista: a bolha fecha-se aconteça o que acontecer ao download */
      m.viewed = Date.now();
      if (m.type === 'audio' || r.type === 'audio') {
        /* voz de ouvir uma vez: um leitor numa folha; ao fechar a folha o leitor é destruído e a bolha fica "Ouvida" */
        m._opening = false;
        if (!window.VoiceMsg || typeof VoiceMsg.player !== 'function') { rerender(m.id); UI.toast('Leitor de voz indisponível'); return; }
        const body = UI.el(`<div class="rcb-once-sheet"><div class="rcb-once-warn">${g('eye', 16)}<span>Só podes ouvir esta mensagem agora. Quando fechares, deixa de estar disponível.</span></div><div class="rcb-once-player"></div></div>`);
        let pl = null; try { pl = VoiceMsg.player({ mediaId: int(r.mediaId), duration: r.duration, waveform: Array.isArray(r.waveform) ? r.waveform : [] }); } catch (e) { pl = null; }
        if (pl) body.querySelector('.rcb-once-player').appendChild(pl);
        UI.sheet({ title: 'Ouvir uma vez', right: 'Fechar', body, cls: 'rcb-sheet', onClose: () => { try { if (pl && pl.vmsg) pl.vmsg.destroy(); } catch (e) {} rerender(m.id); } });
        if (pl && pl.vmsg) pl.vmsg.play();
        return;
      }
      const url = await fetchOnce(r.mediaId);
      if (st.dead) return;
      m._opening = false;
      if (!url) { rerender(m.id); UI.toast('A foto já não está disponível'); return; }
      viewer(win, [{ url, title: nameFor(m.sender), sub: 'Ver uma vez', caption: typeof r.caption === 'string' ? r.caption : '' }], 0, { once: true, onClose: () => rerender(m.id) });
    }
    function paintPic(pic, m) {
      const p = m.payload || {}, mid = midOf(m);
      if (!mid) { if (typeof p.url === 'string' && /^(https:|data:image\/)/.test(p.url)) pic.style.backgroundImage = UI.img(p.url); else pic.classList.add('failed'); return; }
      const hit = mediaCached(mid);
      if (hit && /^data:image\//.test(hit.url)) { pic.style.backgroundImage = UI.img(hit.url); return; }
      pic._mid = mid; pic.classList.add('loading');
      if (io) io.observe(pic); else loadPic(pic);
    }
    function loadPic(pic) {
      const mid = pic._mid; if (!mid || pic._busy) return;
      pic._busy = true; pic.classList.remove('failed'); pic.classList.add('loading');
      mediaGet(mid).then(r => { pic._busy = false; pic.classList.remove('loading'); if (r && /^data:image\//.test(r.url)) { pic.style.backgroundImage = UI.img(r.url); pic._mid = 0; } else pic.classList.add('failed'); });
    }
    function openViewer(imgs, k) {
      const items = imgs.map(x => ({ mediaId: midOf(x) || null, url: midOf(x) ? null : (x.payload && typeof x.payload.url === 'string' ? x.payload.url : null), caption: captionOf(x), title: x.sender === me ? 'Tu' : nameFor(x.sender), sub: dayLabel(x.created) + ' · ' + fmtTime(x.created) }));
      viewer(win, items, k, { onForward: i => forward([imgs[i]]) });
    }

    /* ---------- reações ---------- */
    const isMineR = r => (r && r.who != null ? String(r.who) === me : !!(r && r.mine));
    function reactsEl(m) {
      const list = (m.reactions || []).filter(r => r && typeof r.emoji === 'string');
      if (!list.length || m.deleted) return null;
      const by = new Map();
      list.forEach(r => { const o = by.get(r.emoji) || { emoji: r.emoji, n: 0, mine: false }; o.n++; if (isMineR(r)) o.mine = true; by.set(r.emoji, o); });
      const box = UI.el('<div class="rcb-reacts"></div>');
      by.forEach(o => { const c = UI.el('<span class="rcb-rc"></span>'); c.textContent = o.emoji + (o.n > 1 ? ' ' + o.n : ''); if (o.mine) c.classList.add('mine'); c.onclick = e => { e.stopPropagation(); react(m, o.mine ? null : o.emoji); }; box.appendChild(c); });
      return box;
    }
    function paintReacts(m) {
      const row = st.rows.get(m.id); if (!row || !row._ids) return;
      const anchorId = row._ids[row._ids.length - 1]; if (anchorId !== m.id) return;
      const old = row.querySelector(':scope > .rcb-reacts'); if (old) old.remove();
      const nx = reactsEl(m); if (nx) row.appendChild(nx);
    }
    async function react(m, emoji) {
      if (st.left) return;
      const r = await Bridge.rpcRaw('messages.react', { id: m.id, emoji: emoji || null });
      /* badreaction = emoji fora da lista do servidor (o "+" do menu): diz-se exatamente isso, não "reação inválida" */
      if (failed(r)) { UI.toast(r && r.error === 'badreaction' ? ERR.badreaction : errText(r, 'Não foi possível reagir'), 2600); return; }
      if (r.reactions && typeof r.reactions === 'object') m.reactions = arr(r.reactions);
      else { m.reactions = (m.reactions || []).filter(x => !isMineR(x)); if (emoji) m.reactions.push({ emoji, who: me, mine: true }); }
      if (!emoji) m.reactions = m.reactions.filter(x => !isMineR(x));
      paintReacts(m); if (emoji) Sound.play('pop');
    }
    /* mais emoji: o seletor do RD numa folha (sem ele, uma grelha própria) */
    const MORE_EMOJI = ['😀', '😁', '🤣', '😊', '😍', '🥰', '😘', '😎', '🤩', '🥳', '😏', '😴', '🤔', '🤨', '😐', '🙄', '😬', '😳', '🥺', '😭', '😤', '😡', '🤯', '😱', '🤗', '🤝', '👏', '🙌', '💪', '👌', '✌️', '🤞', '👀', '🔥', '✨', '💯', '🎉', '💔', '💙', '💜', '🖤', '🤍', '⭐', '⚡', '☕', '🍕', '🍻', '🚗', '🏁', '💰', '📍', '✅', '❌', '⚠️'];
    function emojiSheet(title, onPick) {
      const body = UI.el('<div class="rcb-emo-host"></div>');
      let sh = null;
      const pick = e => { if (typeof e !== 'string' || !e || e.length > 16) return; if (sh) sh.close(); onPick(e); };
      const X = Extras();
      let mounted = false;
      if (fn(X, 'emojiPicker')) { try { X.emojiPicker(body, pick); mounted = body.childNodes.length > 0; } catch (e) { console.error('[apex_phone] RecadoExtras.emojiPicker', e); } }
      if (!mounted) { body.innerHTML = ''; const grid = UI.el('<div class="rcb-emo-grid"></div>'); MORE_EMOJI.forEach(x => { const s = document.createElement('span'); s.textContent = x; s.onclick = () => pick(x); grid.appendChild(s); }); body.appendChild(grid); }
      sh = UI.sheet({ title, right: 'Fechar', body, cls: 'rcb-sheet' });
    }
    function reactBar(m, close) {
      const wraps = UI.screen().querySelectorAll('.ctx-wrap.rcb-ctx'); const wrap = wraps[wraps.length - 1]; if (!wrap) return;
      const menuEl = wrap.querySelector('.ctx'); if (!menuEl) return;
      const mineR = (m.reactions || []).find(isMineR);
      const rb = UI.el('<div class="rcb-rbar"></div>');
      C.reactions.forEach(e => { const s = document.createElement('span'); s.textContent = e; if (mineR && mineR.emoji === e) s.classList.add('on'); s.onclick = ev => { ev.stopPropagation(); close(); react(m, mineR && mineR.emoji === e ? null : e); }; rb.appendChild(s); });
      const plus = UI.el(`<span class="plus">${g('plus', 20)}</span>`);
      plus.onclick = ev => { ev.stopPropagation(); close(); emojiSheet('Reagir', e => react(m, e)); };
      rb.appendChild(plus);
      rb.onclick = ev => ev.stopPropagation();
      wrap.appendChild(rb);
      const top = parseFloat(menuEl.style.top) || 200, left = parseFloat(menuEl.style.left) || 20, mh = menuEl.offsetHeight || 0, bw = rb.offsetWidth || 330;
      let y = top - 64; if (y < 70) y = top + mh + 10;
      rb.style.top = y + 'px'; rb.style.left = Math.max(10, Math.min(left, ((window.System && System.SW) || 440) - 10 - bw)) + 'px';   /* SW: 880 no PearPhone Fold aberto */
    }

    /* ---------- menu da mensagem (toque longo) ---------- */
    function textOf(m) {
      if (m.deleted) return ''; const p = m.payload || {};
      switch (m.type) {
        case 'text': return String(m.content || '');
        case 'image': return captionOf(m);
        case 'contact': return [p.name, p.number].filter(Boolean).join(' ');
        case 'location': return (p.label || 'Localização') + (isFinite(+p.x) && isFinite(+p.y) ? ` (${Math.round(+p.x)}, ${Math.round(+p.y)})` : '');
        case 'document': return [p.title, p.body].filter(Boolean).join('\n');
        default: return '';
      }
    }
    function menu(ms, b) {
      if (st.dead) return;
      const m = ms[ms.length - 1], mine = m.sender === me, gone = !!m.deleted, txt = textOf(m), items = [];
      const pinned = st.pins.some(x => x.id === m.id);
      if (!gone && !st.left && canWrite()) items.push({ label: 'Responder', icon: 'reply', onTap: () => setReply(m) });
      if (!gone && !m.viewOnce && m.type !== 'call') items.push({ label: 'Reencaminhar', icon: 'forward', onTap: () => forward(ms) });
      if (txt) items.push({ label: 'Copiar', icon: 'copy', onTap: () => copyText(txt) });
      if (!gone && mine && m.type === 'text' && within(m, C.editWindowMin)) items.push({ label: 'Editar', icon: 'pen', onTap: () => editMsg(m) });
      if (!gone) items.push({ label: m.starred ? 'Remover dos favoritos' : 'Favorito', icon: 'star', onTap: () => star(ms, !m.starred) });
      /* fixar num grupo "só administradores" é recusado pelo servidor (adminsonly): não se oferece o que falha */
      if (!gone && !st.left && !(isGroup && st.policy === 'admins' && !st.admin)) items.push({ label: pinned ? 'Desafixar' : 'Fixar', icon: 'pin', onTap: () => pinMsg(m, !pinned) });
      if (!gone && m.type === 'image' && !m.viewOnce) items.push({ label: 'Guardar na galeria', icon: 'download', onTap: () => saveImages(ms) });
      if (mine && !gone) items.push({ label: 'Info', icon: 'info', onTap: () => info(m) });
      /* num grupo só se apagam (para mim ou para todos) as mensagens que enviei - também as já apagadas por quem as escreveu */
      if (!isGroup || mine) items.push({ label: 'Apagar', icon: 'trash', danger: true, onTap: () => removeFlow(ms) });
      if (!items.length) return;
      const close = UI.ctxMenu(b, items, { cls: 'rcb-ctx' });
      /* o "pin" do sistema é o marcador de mapa: no Fixar/Desafixar vai o pionés */
      { const wraps = UI.screen().querySelectorAll('.ctx-wrap.rcb-ctx'), wrap = wraps[wraps.length - 1];
        if (wrap) wrap.querySelectorAll('.ctx > div').forEach(d => { if (/^(Fixar|Desafixar)$/.test(String(window.I18N && I18N.source ? I18N.source(d) : d.textContent).trim())) {   /* a origem: o texto do menu pode estar traduzido */ const s = d.querySelector('svg'); if (s) s.outerHTML = PIN_GL; } }); }
      if (!gone && !st.left) reactBar(m, close);
    }
    async function saveImages(ms) {
      let ok = 0;
      for (const x of ms.filter(y => y.type === 'image' && !y.viewOnce && !y.deleted)) {
        const mid = midOf(x); let url = null;
        if (mid) { const r = await mediaGet(mid, true); url = r && r.url; } else if (x.payload && typeof x.payload.url === 'string') url = x.payload.url;
        if (!url || !window.Photos) continue;
        let r = null; try { r = await Photos.save(url); } catch (e) { r = null; }
        if (r && !r.error) ok++;
      }
      if (ok) { try { await Photos.load(); Bridge.emit('photos'); } catch (e) {} UI.toast(ok > 1 ? `${ok} fotos guardadas na galeria` : 'Guardada na galeria'); }
      else UI.toast('Não foi possível guardar a foto');
    }
    async function forward(list) {
      list = (list || []).filter(x => x && !x.deleted && x.type !== 'system');
      if (list.some(x => x.viewOnce)) { UI.toast(ERR.viewonce); return; }
      if (!list.length) return;
      const targets = await pickTargets(C.forwardMax);
      if (!targets || !targets.length || st.dead) return;
      let ok = 0, err = null; const back = [];
      for (const x of list) {
        let r = null; try { r = await Bridge.rpcRaw('recado.forward', { id: x.id, targets }); } catch (e) { r = null; }
        /* resposta do RA: { ok, sent, results = [{ i, id?, error? }] } - um destino recusado não estraga os outros.
           O código do destino que falhou vale mais do que o { ok = false } geral (que não traz `error`). */
        const bad = arr(r && r.results).find(y => y && y.error);
        if (bad && !err) err = { error: bad.error };
        if (failed(r)) { if (!err) err = r || { error: 'rpc' }; if (!r || !arr(r.results).length) break; }
        if (r && (r.ok || int(r.sent) > 0)) ok++;
        arr(r && r.messages).forEach(mm => back.push(mm));
      }
      if (!ok) { UI.toast(errText(err, 'Não foi possível reencaminhar')); return; }
      UI.toast(err ? 'Reencaminhada, mas houve um destino que falhou: ' + errText(err, 'erro') : (targets.length > 1 ? `Reencaminhada para ${targets.length} conversas` : 'Reencaminhada'));
      if (st.dead) return;
      const here = targets.some(t => isGroup ? int(t.conversation) === gid : String(t.number) === number);
      if (here) { const mineBack = back.filter(matches); if (mineBack.length) mineBack.forEach(mm => append(mm)); else syncTail(); }
      changed();
    }
    function editMsg(m) {
      const body = UI.el('<div class="rcb-edit"><div class="rcb-edit-prev"></div><textarea rows="4" maxlength="1000"></textarea><small></small></div>');
      body.querySelector('.rcb-edit-prev').innerHTML = formatText(m.content || '');
      const ta = body.querySelector('textarea'); ta.value = m.content || '';
      body.querySelector('small').textContent = `Podes editar durante ${C.editWindowMin} min depois de enviar. Quem já leu vê a mensagem como "editada".`;
      let busy = false;
      const sh = UI.sheet({ title: 'Editar mensagem', left: 'Cancelar', right: 'Guardar', body, cls: 'rcb-sheet', onDone: () => {
        if (busy) return false;
        const content = ta.value.trim();
        if (!content) { UI.toast('A mensagem está vazia'); return false; }
        if (content === m.content) return true;
        busy = true;
        Promise.resolve(Bridge.rpcRaw('messages.edit', { id: m.id, content })).then(r => {
          busy = false;
          if (failed(r)) { UI.toast(errText(r, 'Não foi possível editar')); return; }
          applyUpdate({ id: m.id, content: typeof r.content === 'string' ? r.content : content, editedAt: +r.editedAt || Date.now() });
          sh.close(); changed();
        });
        return false;
      } });
      setTimeout(() => { try { ta.focus(); ta.setSelectionRange(ta.value.length, ta.value.length); } catch (e) {} }, 350);
    }
    async function star(ms, on) {
      let err = null;
      for (const x of ms) { const r = await Bridge.rpcRaw('recado.star', { id: x.id, on: !!on }); if (failed(r)) { err = r; break; } x.starred = !!on; }
      if (err) { UI.toast(errText(err, 'Não foi possível guardar o favorito')); }
      else UI.toast(on ? 'Adicionada aos favoritos' : 'Removida dos favoritos');
      rerender(ms[0].id);
    }
    async function pinMsg(m, on) {
      if (on && st.pins.length >= C.pinsMax && !st.pins.some(x => x.id === m.id)) { UI.toast(`Só podes fixar ${C.pinsMax} mensagens, desafixa uma primeiro`); return; }
      const r = await Bridge.rpcRaw('recado.pin', { id: m.id, on: !!on });
      if (failed(r)) { UI.toast(errText(r, on ? 'Não foi possível fixar' : 'Não foi possível desafixar')); return; }
      m.pinned = !!on;
      if (r.pins) setPins(r.pins); else await loadPins();
      if (on) { st.pinIdx = 0; paintPins(); UI.toast('Mensagem fixada'); }
    }
    function info(m) {
      const rows = [{ label: 'Enviada', value: dayLabel(m.created) + ' · ' + fmtTime(m.created), chevron: false }];
      if (isGroup) {
        rows.push({ label: 'Entregue', value: RANK[m.status] >= 2 ? 'Sim' : 'Ainda não', chevron: false });
        rows.push({ label: 'Lida por todos', value: m.status === 'read' ? 'Sim' : 'Ainda não', chevron: false });
      } else {
        rows.push({ label: 'Entregue', value: +m.deliveredAt > 0 ? dayLabel(m.deliveredAt) + ' · ' + fmtTime(m.deliveredAt) : (RANK[m.status] >= 2 ? 'Sim' : 'Ainda não'), chevron: false });
        rows.push({ label: 'Lida', value: +m.readAt > 0 ? dayLabel(m.readAt) + ' · ' + fmtTime(m.readAt) : (m.status === 'read' ? 'Sim' : 'Ainda não'), chevron: false });
      }
      if (+m.expiresAt > 0) rows.push({ label: 'Desaparece', value: dayLabel(m.expiresAt) + ' · ' + fmtTime(m.expiresAt), chevron: false });
      const body = UI.el('<div class="rcb-info"><div class="rcb-info-prev"></div></div>');
      body.firstElementChild.textContent = label(m);
      body.appendChild(UI.list([{ items: rows, footer: isGroup ? 'Nos grupos, "lida" só aparece quando todos os membros a leram. Quem desligou as confirmações de leitura não as envia.' : 'Se um de vocês desligou as confirmações de leitura, a hora de leitura não aparece.' }]));
      UI.sheet({ title: 'Info da mensagem', right: 'OK', body, cls: 'rcb-sheet' });
    }
    async function removeFlow(ms) {
      const mine = ms.every(x => x.sender === me), gone = ms.every(x => x.deleted);
      const canAll = mine && !gone && ms.every(x => within(x, C.deleteForAllMin) && x.type !== 'system');
      const canMe = !isGroup || mine;
      const buttons = [];
      if (canAll) buttons.push({ label: 'Apagar para todos', value: 'all', danger: true });
      if (canMe) buttons.push({ label: 'Apagar para mim', value: 'me', danger: true });
      if (!buttons.length) { UI.toast('Nos grupos só podes apagar as mensagens que enviaste'); return; }
      const scope = await UI.actionSheet({ title: canAll ? (ms.length > 1 ? `Apagar ${ms.length} fotos?` : 'Apagar mensagem?') : (isGroup ? 'Os outros membros continuam a vê-la.' : 'A mensagem desaparece só deste telemóvel.'), buttons });
      if (scope !== 'all' && scope !== 'me') return;
      let err = null;
      for (const x of ms) {
        const r = await Bridge.rpcRaw('messages.delete', { id: x.id, scope });
        if (failed(r)) { err = r; break; }
        if (scope === 'me') removeMsg(x.id); else applyUpdate({ id: x.id, deleted: true });
      }
      if (err) UI.toast(errText(err, 'Não foi possível apagar'));
      changed();
    }

    /* ---------- fixadas ---------- */
    function setPins(list) {
      /* aceita [id, …] ou [{ messageId | message_id | id, preview?, sender? }, …] (e o {} de uma lista Lua vazia) */
      const seen = new Set();
      const raw2 = Array.isArray(list) ? list : (list && typeof list === 'object' ? Object.values(list) : []);
      st.pins = raw2.map(x => (typeof x === 'number' || typeof x === 'string') ? { id: int(x), preview: '', sender: '' }
        : (x && typeof x === 'object' ? { id: int(x.messageId || x.message_id || x.id), preview: typeof x.preview === 'string' ? x.preview.slice(0, 120) : '', sender: x.sender ? String(x.sender) : '' } : { id: 0 }))
        .filter(x => { if (!(x.id > 0) || seen.has(x.id)) return false; seen.add(x.id); return true; }).slice(0, C.pinsMax);
      st.pinIdx = Math.min(st.pinIdx, Math.max(0, st.pins.length - 1));
      paintPins();
    }
    async function loadPins() {
      let r = null; try { r = await Bridge.rpcRaw('recado.pins', q); } catch (e) { r = null; }
      if (st.dead) return;
      if (r && !r.error) setPins(Array.isArray(r) ? r : (r.pins || r.items || arr(r)));
      else setPins([...st.msgs.values()].filter(x => x.pinned && !x.deleted).map(x => x.id));   /* sem o RPC: as fixadas que vieram nas mensagens */
    }
    function paintPins() {
      const n = st.pins.length;
      if (!n) { pinBar.classList.add('hidden'); return; }
      pinBar.classList.remove('hidden');
      const p = st.pins[st.pinIdx] || st.pins[0], m = st.msgs.get(p.id);
      const ind = pinBar.querySelector('.rcb-pins-ind'); ind.innerHTML = '';
      for (let k = 0; k < n; k++) ind.appendChild(UI.el(`<i class="${k === st.pinIdx ? 'on' : ''}"></i>`));
      pinBar.querySelector('b').textContent = n > 1 ? `Mensagem fixada ${st.pinIdx + 1} de ${n}` : 'Mensagem fixada';
      const who = m ? m.sender : p.sender;
      pinBar.querySelector('.rcb-pins-tx span').textContent = (isGroup && who && who !== me ? nameFor(who) + ': ' : '') + (m ? label(m) : (p.preview || 'Toca para ver a mensagem'));
    }
    pinBar.querySelector('.rcb-pins-tx').onclick = () => { const p = st.pins[st.pinIdx]; if (!p) return; jumpTo(p.id); if (st.pins.length > 1) { st.pinIdx = (st.pinIdx + 1) % st.pins.length; paintPins(); } };
    pinBar.querySelector('.rcb-pins-ind').onclick = pinBar.querySelector('.rcb-pins-tx').onclick;
    pinBar.querySelector('.rcb-pins-ic').onclick = () => {
      if (!st.pins.length) return;
      const body = UI.list([{ items: st.pins.map(p => { const m = st.msgs.get(p.id); return { icon: PIN_GL, iconBg: '#128C7E', iconColor: '#fff', label: m ? label(m) : (p.preview || 'Mensagem fixada'), sub: m ? (m.sender === me ? 'Tu' : nameFor(m.sender)) + ' · ' + dayLabel(m.created) : '', chevron: false,
        right: UI.el('<div class="pill-btn rcb-unpin nostop">Desafixar</div>'), onTap: () => { sh.close(); jumpTo(p.id); } }; }) }]);
      const sh = UI.sheet({ title: 'Mensagens fixadas', right: 'OK', body, cls: 'rcb-sheet' });
      body.querySelectorAll('.rcb-unpin').forEach((btn, k) => { btn.onclick = e => { e.stopPropagation(); const p = st.pins[k]; if (!p) return; sh.close(); pinMsg(st.msgs.get(p.id) || { id: p.id }, false); }; });
    };

    /* ---------- mensagens temporárias ---------- */
    function setDisappearing(sec) {
      st.disappearing = Math.max(0, int(sec));
      tempBar.classList.toggle('hidden', !(st.disappearing > 0));
      tempBar.querySelector('span').textContent = st.disappearing > 0 ? `Mensagens temporárias: ${durLabel(st.disappearing)}` : '';
    }
    tempBar.onclick = async () => {
      if (st.left) return;
      /* grupo com "editar: só administradores" (RC canEdit = false): o servidor recusaria - diz-se já, sem a folha */
      if (isGroup && st.canEdit === false) { UI.toast('Só os administradores podem mudar as mensagens temporárias neste grupo', 2600); return; }
      const buttons = [{ label: 'Desligar', value: 0, bold: !st.disappearing }].concat(C.disappearing.map(s => ({ label: durLabel(s), value: s, bold: s === st.disappearing })));
      const vsel = await UI.actionSheet({ title: 'As mensagens novas desaparecem ao fim do tempo escolhido, para todos. Quem as recebe pode copiá-las ou fazer capturas de ecrã.', buttons });
      if (vsel === null || vsel === undefined || st.dead || vsel === st.disappearing) return;
      const r = await Bridge.rpcRaw('recado.thread.set', Object.assign({ disappearing: vsel }, q));
      if (failed(r)) { UI.toast(errText(r, 'Não foi possível alterar')); return; }
      setDisappearing(vsel); syncTail(); changed();
    };
    /* a mensagem de sistema das temporárias (do servidor) acerta o aviso nos dois lados */
    function checkSystem(m) { const p = m.payload || {}; if (p.action === 'disappearing') setDisappearing(p.seconds != null ? p.seconds : p.disappearing); }

    /* ---------- saltar para uma mensagem (citação, fixada, pesquisa) ---------- */
    async function jumpTo(id) {
      id = int(id); let tries = 0;
      while (!st.rows.has(id) && st.more && tries < 15 && !st.dead) { await loadOlder(); tries++; }
      const r = st.rows.get(id);
      if (!r) { UI.toast('A mensagem já não está disponível'); return; }
      const z = UI.zoom() || 1;
      sc.scrollTop = Math.max(0, sc.scrollTop + (r.getBoundingClientRect().top - sc.getBoundingClientRect().top) / z - sc.clientHeight / 2 + r.offsetHeight / 2);
      r.classList.remove('flash'); void r.offsetWidth; r.classList.add('flash'); later(() => r.classList.remove('flash'), 1400);
      paintDown();
    }

    /* ---------- DOM: acrescentar, repintar, tirar ---------- */
    const dropPlayers = el => { if (el) el.querySelectorAll('.vmsg-player').forEach(p => { try { if (p.vmsg) p.vmsg.destroy(); } catch (e) {} }); };
    /* um leitor de voz a meio NÃO pára por a linha ser repintada (reação, estado, nome): muda para a linha nova */
    function keepPlayers(oldEl, newEl) {
      const old = new Map(); oldEl.querySelectorAll('.vmsg-player').forEach(p => { if (p._rcbId) old.set(p._rcbId, p); });
      newEl.querySelectorAll('.rcb-audio .vmsg-player').forEach(p => { const o = old.get(p._rcbId); if (o && !st.msgs.get(p._rcbId).deleted) { try { p.vmsg.destroy(); } catch (e) {} p.replaceWith(o); old.delete(p._rcbId); } });
      old.forEach(p => { try { p.vmsg.destroy(); } catch (e) {} });
    }
    function rerenderRow(row) {
      if (!row || !row._ids) return null;
      const ids = row._ids.filter(i => st.msgs.has(i));
      if (!ids.length) { dropPlayers(row); row.remove(); return null; }
      const ms = ids.map(i => st.msgs.get(i));
      const idx = st.order.indexOf(ids[0]), prev = idx > 0 ? st.msgs.get(st.order[idx - 1]) : null;
      const nr = rowFor(ms, prev);
      keepPlayers(row, nr);
      if (row.classList.contains('flash')) nr.classList.add('flash');
      row.replaceWith(nr); ids.forEach(i => st.rows.set(i, nr));
      return nr;
    }
    const rerender = id => { const row = st.rows.get(int(id)); if (row) rerenderRow(row); };
    function rebuild() {
      const holder = document.createElement('div');
      [...thread.children].forEach(c => { if (c !== moreEl && c !== typingEl && !c.classList.contains('pending')) holder.appendChild(c); });
      st.rows.clear();
      const frag = buildRows(st.order.map(i => st.msgs.get(i)), null);
      const tmp = document.createElement('div'); tmp.appendChild(frag);
      keepPlayers(holder, tmp);
      const nf = document.createDocumentFragment(); while (tmp.firstChild) nf.appendChild(tmp.firstChild);
      thread.insertBefore(nf, anchor());
      paintPins();
    }
    const matches = m => { const c = int(m && (m.conversation != null ? m.conversation : m.conversation_id)); if (isGroup) return c === gid; return !c && m && (String(m.sender) === number || (String(m.sender) === me && String(m.receiver) === number)); };
    function append(m, incoming) {
      if (!m || m.id == null || st.dead) return;
      if (!st.loaded) { st.queue.push([m, incoming]); return; }
      const id = int(m.id); if (!(id > 0)) return;
      if (st.msgs.has(id)) return;
      norm(m);
      if (+m.expiresAt > 0 && +m.expiresAt <= Date.now()) return;
      if (incoming && m.sender !== me) { st.typers.delete(String(m.sender)); st.recs.delete(String(m.sender)); paintSub(); paintTyping(); }
      if (m.type === 'system') checkSystem(m);
      const near = nearBottom();
      const lastId = st.order.length ? st.order[st.order.length - 1] : null;
      st.msgs.set(id, m);
      if (lastId !== null && id < lastId) { st.order.push(id); st.order.sort((a, b) => a - b); rebuild(); }
      else {
        st.order.push(id);
        const last = lastId !== null ? st.msgs.get(lastId) : null, k = albumKey(m), row = lastId !== null ? st.rows.get(lastId) : null;
        if (k && last && row && albumKey(last) === k && dayKey(last) === dayKey(m)) { row._ids.push(id); st.rows.set(id, row); rerenderRow(row); }
        else thread.insertBefore(buildRows([m], last), anchor());
      }
      if (st.pins.some(p => p.id === id)) paintPins();
      if (!incoming || m.sender === me || near) scrollBottom(); else { st.newCount++; paintDown(); }
    }
    function removeMsg(id) {
      id = int(id); const row = st.rows.get(id);
      st.msgs.delete(id); st.order = st.order.filter(x => x !== id); st.rows.delete(id);
      if (st.replyTo && st.replyTo.id === id) clearReply();
      if (st.pins.some(p => p.id === id)) { st.pins = st.pins.filter(p => p.id !== id); st.pinIdx = 0; paintPins(); }
      if (!row) return;
      if (row._ids.length > 1) { row._ids = row._ids.filter(x => x !== id); rerenderRow(row); return; }
      const before = row.previousElementSibling, after = row.nextElementSibling;
      dropPlayers(row); row.remove();
      const isSep = e => !!(e && e.classList.contains('rcb-day'));
      if (isSep(before) && (!after || isSep(after) || after === typingEl || after.classList.contains('pending'))) before.remove();
      if (after && after._ids) rerenderRow(after);   /* o nome / o início de sequência da seguinte podem mudar */
    }
    function applyUpdate(d) {
      const m = st.msgs.get(int(d && d.id)); if (!m) return;
      if (d.deleted) { m.deleted = true; m.content = ''; m.payload = {}; m.reactions = []; m.editedAt = null; if (st.replyTo && st.replyTo.id === m.id) clearReply(); }
      else {
        if (typeof d.content === 'string') { m.content = d.content; m.editedAt = +d.editedAt || m.editedAt || Date.now(); }
        else if (d.editedAt != null) m.editedAt = +d.editedAt;
        if (d.payload && typeof d.payload === 'object') m.payload = d.payload;
        /* remendo do recado.send (pushPatch): o mediaPayload das mensagens de VOZ perde as marcas do Recado, por isso o
           push `message` chega como voz normal e só este messageUpdate diz que é de ouvir uma vez. A bolha fecha-se já
           e o mediaId sai da memória da conversa (só o recado.viewOnce a abre). */
        if (d.viewOnce === true && !m.viewOnce && (m.type === 'audio' || m.type === 'image')) {
          m.viewOnce = true; m.payload = { viewOnce: true, duration: m.type === 'audio' && m.payload ? m.payload.duration : undefined };
          if (m.sender !== me) m.content = '';
          if (m.viewed == null) m.viewed = false;
        }
        if (d.forwarded === true) m.forwarded = true;
        if (d.starred != null) m.starred = !!d.starred;
        if (d.viewed || d.viewedAt) m.viewed = d.viewed || d.viewedAt;
        if (d.expiresAt !== undefined) m.expiresAt = +d.expiresAt || null;
        if (d.pinned != null) m.pinned = !!d.pinned;
      }
      const row = st.rows.get(m.id);
      if (row && row._ids.length > 1 && d.deleted) rebuild(); else rerender(m.id);
      /* citações desta mensagem noutras linhas */
      st.msgs.forEach(x => { if (x !== m && x.replyTo && int(x.replyTo.id) === m.id) rerender(x.id); });
      paintPins();
    }
    /* ---------- estados ✓ / ✓✓ / lida ---------- */
    const otherMembers = () => Object.keys(st.members).filter(x => x !== me);
    function applyStatus(d) {
      const s = String(d.status || ''); if (!RANK[s]) return;
      const ids = (Array.isArray(d.ids) ? d.ids : (d.ids && typeof d.ids === 'object' ? Object.values(d.ids) : (d.id != null ? [d.id] : []))).map(int).filter(Boolean);
      const touched = new Set();
      const up = (m, s2, at) => { if (upgrade(m, s2, at)) touched.add(m.id); };
      if (isGroup) {
        if (s === 'read' && d.who) {
          const upTo = int(d.upTo) || (ids.length ? Math.max(...ids) : 0);
          st.readUpTo[String(d.who)] = Math.max(st.readUpTo[String(d.who)] || 0, upTo);
          const others = otherMembers();
          const minRead = others.length && others.every(x => st.readUpTo[x]) ? Math.min(...others.map(x => st.readUpTo[x])) : 0;
          st.order.forEach(id => { const m = st.msgs.get(id); if (!m || m.sender !== me || m.deleted) return; if (minRead && id <= minRead) up(m, 'read', d.at); else if (id <= upTo) up(m, 'delivered'); });
        } else ids.forEach(id => { const m = st.msgs.get(id); if (m) up(m, s === 'read' ? 'delivered' : s, d.at); });
      } else {
        ids.forEach(id => { const m = st.msgs.get(id); if (m) up(m, s, d.at); else if (st.pendingStatus.size < 200) st.pendingStatus.set(id, { status: s, at: d.at }); });
        if (s === 'read' && ids.length) { const maxId = Math.max(...ids); st.order.forEach(id => { const m = st.msgs.get(id); if (m && m.sender === me && id <= maxId) up(m, 'read', d.at); }); }
      }
      touched.forEach(id => rerender(id));
    }

    /* ---------- "a escrever…" / "a gravar áudio…" que chegam ---------- */
    let typingT = null;
    function fromThis(d) {
      const from = String(d.from == null ? '' : d.from); if (!from || from === me) return null;
      const c = int(d.conversation);
      if (isGroup ? c !== gid : (c || from !== number)) return null;
      return from;
    }
    function onTyping(d, map) {
      const from = fromThis(d); if (!from) return;
      if (d.on) map.set(from, Date.now()); else map.delete(from);
      paintSub(); paintTyping();
    }
    function paintTyping() {
      const ttl = Math.max(4000, C.typingMs * 2 + 1500), now = Date.now();
      [st.typers, st.recs].forEach(mp => mp.forEach((t, k) => { if (now - t > ttl) mp.delete(k); }));
      clearTimeout(typingT);
      const on = (st.typers.size || st.recs.size) && !st.dead;
      const near = nearBottom();
      typingEl.classList.toggle('in', !!on); typingEl.classList.toggle('rec', !!st.recs.size);
      typingEl.querySelector('small').textContent = on && isGroup ? [...new Set([...st.recs.keys(), ...st.typers.keys()])].slice(0, 2).map(x => nameFor(x).split(/\s+/)[0]).join(', ') : '';
      if (on && near) scrollBottom();
      if (on) typingT = setTimeout(() => { paintSub(); paintTyping(); }, ttl + 60);
      else paintSub();
    }

    /* =====================================================================
       COMPOSITOR
       ===================================================================== */
    const STICKER_GL = '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 12.5V6a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h6.5z"/><path d="M12.5 20c0-4.1 3.4-7.5 7.5-7.5"/><path d="M9 9.5h.01M14 9.5h.01M8.7 13.4c.9.9 2 1.3 3.3 1.3"/></svg>';
    const comp = UI.el(`<div class="rcb-comp"><div class="rcb-reply hidden"><div class="rcb-reply-q"><b></b><span></span></div><div class="rcb-reply-x">${g('x', 16)}</div></div>
      <div class="rcb-bar"><div class="rcb-plus">${g('plus', 24)}</div><div class="rcb-field"><div class="rcb-emo">${g('smile', 22)}</div><textarea rows="1" placeholder="Mensagem"></textarea><div class="rcb-stk">${STICKER_GL}</div></div><div class="rcb-rec"></div><div class="rcb-cam">${g('camera', 24)}</div><div class="rcb-mic">${g('mic', 24)}</div><div class="rcb-send">${g('send', 21)}</div></div>
      <div class="rcb-note hidden"></div></div>`);
    const panel = UI.el(`<div class="rcb-panel hidden"><div class="rcb-panel-host"></div><div class="rcb-panel-tabs"><span class="emo on">${g('smile', 20)}</span><span class="stk">${STICKER_GL}<em>Stickers</em></span><span class="gif"><em>GIF</em></span><span class="bk">${g('backspace', 20)}</span></div></div>`);
    v.append(comp, panel);
    comp.appendChild(downBtn);   /* o botão de descer fica sempre logo acima do compositor, seja qual for a altura dele */
    const ta = comp.querySelector('textarea'), bar = comp.querySelector('.rcb-reply'), note = comp.querySelector('.rcb-note'), micBtn = comp.querySelector('.rcb-mic');
    ta.maxLength = C.textMax;
    const voiceOk = () => { try { return !!(window.VoiceMsg && typeof VoiceMsg.supported === 'function' && VoiceMsg.supported()); } catch (e) { return false; } };
    if (!voiceOk()) micBtn.classList.add('na');
    const canWrite = () => !st.left && !st.blocked && !(st.policy === 'admins' && !st.admin) && !st.locked;
    function paintNote() {
      let t = '', act = false;
      if (st.left) t = isGroup ? 'Já não és membro deste grupo.' : '';
      else if (st.blocked) { t = 'Bloqueaste este contacto. Toca para desbloquear.'; act = true; }
      else if (st.policy === 'admins' && !st.admin) t = 'Só os administradores podem enviar mensagens neste grupo.';
      note.textContent = t; note.classList.toggle('hidden', !t); note.classList.toggle('act', act);
      comp.classList.toggle('closed', !!t);
      if (t) { clearReply(); stopRecorder(); typingStop(); closePanel(); }
    }
    note.onclick = async () => {
      if (!st.blocked || !window.Contacts) return;
      if (!await UI.confirm('Desbloquear ' + title + '?', 'Voltas a receber as mensagens e chamadas deste contacto.', 'Desbloquear')) return;
      if (await Contacts.unblock(number)) { st.blocked = false; paintNote(); paintSub(); } else UI.toast('Não foi possível desbloquear');
    };
    const setLeft = on => { st.left = !!on; paintNote(); paintSub(); };
    /* a classe primeiro: com texto a câmara e o microfone saem e o campo alarga - medido antes, uma linha curta
       parecia partida em duas e o campo ficava com o dobro da altura */
    const autosize = () => { comp.classList.toggle('has-text', !!ta.value.trim()); ta.style.height = 'auto'; ta.style.height = Math.min(126, Math.max(40, ta.scrollHeight)) + 'px'; };

    /* ---------- responder ---------- */
    function setReply(m) {
      if (!canWrite()) return; st.replyTo = m;
      bar.classList.remove('hidden');
      const who = m.sender === me ? 'Tu' : nameFor(m.sender);
      bar.querySelector('b').textContent = who; bar.style.setProperty('--qc', m.sender === me ? '#128C7E' : colorOf(m.sender));
      bar.querySelector('.rcb-reply-q span').textContent = label(m).slice(0, 90);
      closePanel(); try { ta.focus(); } catch (e) {}
    }
    function clearReply() { st.replyTo = null; bar.classList.add('hidden'); }
    bar.querySelector('.rcb-reply-x').onclick = () => clearReply();

    /* ---------- "a escrever" que se envia: no máximo um por typingMs; pára ao enviar/limpar ---------- */
    let typingOn = false, typingLast = 0, typingStopT = null;
    function typingPing() {
      if (!canWrite()) return;
      const now = Date.now(), gap = Math.max(1000, C.typingMs);
      if (!typingOn || now - typingLast >= gap) { typingOn = true; typingLast = now; Promise.resolve(Bridge.rpcRaw('messages.typing', Object.assign({ on: true }, qa))).catch(() => {}); }
      clearTimeout(typingStopT); typingStopT = setTimeout(typingStop, gap + 1500);
    }
    function typingStop() {
      clearTimeout(typingStopT); typingStopT = null;
      if (!typingOn) return; typingOn = false; typingLast = 0;
      Promise.resolve(Bridge.rpcRaw('messages.typing', Object.assign({ on: false }, qa))).catch(() => {});
    }

    /* ---------- enviar ---------- */
    function handleSendError(r) {
      const e = r && r.error;
      if (e === 'nosim' && window.ESim) { ESim.refresh(true); if (ESim.alertNoSim) ESim.alertNoSim('enviar mensagens no Zapp'); }   /* o servidor sabe melhor: o estado volta a pedir-se */
      if (e === 'blocked' && !isGroup) { st.blocked = true; paintNote(); }
      else if (e === 'notmember') setLeft(true);
      /* o RecadoSend do RA responde 'adminsonly' (política "só administradores" mudada enquanto a conversa estava aberta) */
      else if (e === 'policy' || e === 'admins' || (e === 'adminsonly' && isGroup)) { st.policy = 'admins'; st.admin = false; paintNote(); }
    }
    async function doSend(d, o) {
      o = o || {};
      /* eSIM (js/apps/esim.js): sem linha (SIM obrigatório) o servidor recusa com 'nosim'; avisa antes, com "Adicionar eSIM" */
      if (window.ESim && ESim.require && !ESim.require('enviar mensagens no Zapp')) return o.raw ? { error: 'nosim' } : null;
      const req = Object.assign({}, q, d);
      const rq = o.reply !== undefined ? o.reply : st.replyTo;
      if (rq) { req.replyTo = rq.id; if (rq === st.replyTo) clearReply(); }
      let r = null; try { r = await Bridge.rpcRaw('recado.send', req); } catch (e) { r = null; }
      if (r && !r.error && r.id != null) {
        if (rq && !r.replyTo) r.replyTo = { id: rq.id, sender: rq.sender, preview: label(rq).slice(0, 80) };
        if (!r.status) r.status = 'sent';
        dropUnreadMark();
        if (!st.dead) append(r);
        Sound.play('send'); changed();
        Bridge.emit('recado:sent', Object.assign({}, r, isGroup ? { conversation: gid } : { receiver: number }));   /* o RA atualiza a lista (o servidor não manda push a quem escreveu) */
        return r;
      }
      handleSendError(r);
      if (rq && !o.quiet && !st.replyTo && !st.dead) setReply(rq);
      if (!o.quiet) UI.toast(errText(r, 'Não foi possível enviar'));
      return o.raw ? (r || { error: 'rpc' }) : null;
    }
    /* bolha provisória (relógio) enquanto o servidor não responde; a barra mostra o progresso da media */
    function pendingRow(kind, url, text) {
      const r = UI.el(`<div class="rcb-row me run pending"><div class="rcb-bubble ${kind === 'image' ? 'media' : kind === 'audio' ? 'audio' : ''}"></div></div>`);
      const b = r.firstElementChild;
      if (kind === 'image') { const pic = UI.el('<div class="rcb-pic single"><div class="rcb-prog"><i></i></div></div>'); if (url) pic.style.backgroundImage = UI.img(url); b.appendChild(pic); }
      else if (kind === 'audio') { b.appendChild(UI.el(`<div class="rcb-audio na">${g('mic', 20)}<span>A enviar mensagem de voz…</span></div>`)); b.appendChild(UI.el('<div class="rcb-prog"><i></i></div>')); }
      else { const t = UI.el('<div class="rcb-text"></div>'); t.innerHTML = formatText(text || ''); t.appendChild(spacer({}, true)); b.appendChild(t); }
      b.appendChild(UI.el(`<span class="rcb-meta${kind === 'image' ? ' over' : ''}"><time>${UI.esc(fmtTime(Date.now()))}</time>${TICK('pending')}</span>`));
      thread.insertBefore(r, typingEl); scrollBottom();
      const pb = r.querySelector('.rcb-prog i');
      return {
        progress: f => { if (pb) pb.style.transform = `scaleX(${clamp(+f || 0, 0, 1).toFixed(3)})`; },
        done: () => r.remove(),
        fail: (msg, retry) => {
          r.classList.add('failed');
          const e = UI.el(`<div class="rcb-fail">${g('xCircle', 15)}<span></span></div>`);
          e.querySelector('span').textContent = msg + (retry ? ' · Toca para tentar de novo' : '');
          e.onclick = () => { r.remove(); if (retry) retry(); };
          r.appendChild(e);
          UI.longPress(r, () => UI.ctxMenu(r, [{ label: 'Descartar', icon: 'trash', danger: true, onTap: () => r.remove() }]));
        }
      };
    }
    async function sendText() {
      if (!canWrite() || st.dead) return;
      const content = ta.value.replace(/^\s+|\s+$/g, '');
      if (!content) return;
      if (content.length > C.textMax) { UI.toast(`A mensagem passa dos ${C.textMax} caracteres`); return; }
      ta.value = ''; autosize(); typingStop();
      const pend = pendingRow('text', null, content);
      const ments = isGroup ? mentionsIn(content) : [];
      const m = await doSend(Object.assign({ type: 'text', content }, ments.length ? { payload: { mentions: ments } } : {}), { raw: true });
      if (m && m.id != null) { mentionMap.clear(); mentBox.classList.add('hidden'); }
      /* o servidor corta em BYTES (hoje o messages.send fica nos 1000, abaixo do textMax do Recado, e um texto com
         acentos chega lá antes dos 1000 caracteres): em vez de a mensagem perder o fim em silêncio, o que ficou de fora
         volta ao campo e diz-se porquê */
      if (m && m.id != null && typeof m.content === 'string' && m.content.length < content.length && content.startsWith(m.content)) {
        const rest = content.slice(m.content.length).replace(/^\s+/, '');
        if (rest && !ta.value) { ta.value = rest; autosize(); }
        if (rest) UI.toast('A mensagem era longa demais para o servidor: o resto ficou no campo para enviares a seguir', 3200);
      }
      pend.done();
      if (!(m && m.id != null) && !ta.value) { ta.value = content; autosize(); }   /* falhou: o texto não se perde */
    }
    const imgDims = url => new Promise(res => { const im = new Image(); const t = setTimeout(() => res(null), 3000); im.onload = () => { clearTimeout(t); res({ w: im.naturalWidth, h: im.naturalHeight }); }; im.onerror = () => { clearTimeout(t); res(null); }; im.src = url; });
    async function sendImages(urls, caption, hd, once, reply) {
      if (!canWrite() || st.dead) return;
      const album = urls.length > 1 ? (Date.now().toString(36) + Math.random().toString(36).slice(2, 6)) : '';
      const rq = reply !== undefined ? reply : st.replyTo; if (rq && rq === st.replyTo) clearReply();
      dropUnreadMark();
      for (let k = 0; k < urls.length; k++) {
        if (st.dead) return;
        const isLast = k === urls.length - 1, url = urls[k];
        const pend = pendingRow('image', url);
        const retry = () => sendImages([url], isLast ? caption : '', hd, once, null);
        const up = await uploadImage(url, hd, f => pend.progress(f));
        if (st.dead) return;
        if (!up || up.error) { pend.fail(errText(up, 'A foto não foi enviada'), retry); continue; }
        /* contrato do RA: a legenda vai no content (só na última foto do álbum); o álbum é album + albumIndex/albumCount */
        const payload = { mediaId: up.mediaId };
        const dim = await imgDims(up.url); if (dim && dim.w > 0 && dim.h > 0) { payload.w = Math.min(8192, dim.w); payload.h = Math.min(8192, dim.h); }
        if (up.hd) payload.hd = true;
        if (album) { payload.album = album; payload.albumIndex = k + 1; payload.albumCount = urls.length; }
        const d = { type: 'image', content: caption && isLast ? caption : '', payload, mediaId: up.mediaId };
        if (up.hd) d.hd = true;
        if (once && urls.length === 1) d.viewOnce = true;
        const m = await doSend(d, { quiet: true, reply: k === 0 ? (rq || null) : null, raw: true });
        if (m && m.id != null) pend.done(); else pend.fail(errText(m, 'A foto não foi enviada'), retry);
      }
    }
    async function sendVoice(blob, ms, wave, reply) {
      if (!canWrite() || st.dead) return;
      const rq = reply !== undefined ? reply : st.replyTo; if (rq && rq === st.replyTo) clearReply();
      const pend = pendingRow('audio');
      let up = null; try { up = await VoiceMsg.upload(blob, ms, wave, f => pend.progress(f)); } catch (e) { console.error('[apex_phone] VoiceMsg.upload', e); up = null; }
      if (st.dead) return;
      const mid = up && int(up.mediaId);
      const retry = () => sendVoice(blob, ms, wave, rq || null);
      if (!(mid > 0)) { pend.fail((window.VoiceMsg && VoiceMsg.errorText && up && up.error) ? VoiceMsg.errorText(up.error) : 'A mensagem de voz não foi enviada', retry); return; }
      const payload = { mediaId: mid, duration: Math.max(0, Math.round(+ms || 0)), waveform: Array.isArray(wave) ? wave.slice(0, 64).map(x => Math.round(clamp(+x || 0, 0, 1) * 100) / 100) : [] };
      const m = await doSend({ type: 'audio', content: 'Mensagem de voz', payload, mediaId: mid }, { quiet: true, reply: rq || null, raw: true });
      if (m && m.id != null) pend.done(); else pend.fail(errText(m, 'A mensagem de voz não foi enviada'), retry);
    }

    /* ---------- painel de emoji / stickers / GIF ---------- */
    let panelMounted = false;
    const gifOn = () => { const X = Extras(); if (!fn(X, 'gifPicker')) return false; if (C.gifOn !== null) return C.gifOn; const ge = X.gifEnabled; return typeof ge === 'function' ? !!ge() : ge !== false; };
    function insertText(s) {
      const a = ta.selectionStart != null ? ta.selectionStart : ta.value.length, b2 = ta.selectionEnd != null ? ta.selectionEnd : a;
      if (ta.value.length - (b2 - a) + s.length > C.textMax) return;
      ta.value = ta.value.slice(0, a) + s + ta.value.slice(b2);
      try { ta.setSelectionRange(a + s.length, a + s.length); } catch (e) {}
      autosize(); typingPing();
    }
    function mountPanel() {
      if (panelMounted) return; panelMounted = true;
      const host = panel.querySelector('.rcb-panel-host'), X = Extras();
      const pick = e => { if (typeof e === 'string' && e && e.length <= 16) insertText(e); };
      let ok = false;
      if (fn(X, 'emojiPicker')) { try { X.emojiPicker(host, pick); ok = host.childNodes.length > 0; } catch (e) { console.error('[apex_phone] RecadoExtras.emojiPicker', e); } }
      if (!ok) { host.innerHTML = ''; const grid = UI.el('<div class="rcb-emo-grid"></div>'); MORE_EMOJI.forEach(x => { const s = document.createElement('span'); s.textContent = x; s.onclick = () => pick(x); grid.appendChild(s); }); host.appendChild(grid); }
      panel.querySelector('.gif').classList.toggle('hidden', !gifOn());
    }
    function openPanel() {
      if (!canWrite()) return;
      if (!panel.classList.contains('hidden')) { closePanel(); try { ta.focus(); } catch (e) {} return; }
      mountPanel();
      try { ta.blur(); if (window.Keyboard) Keyboard.hide(); } catch (e) {}
      const near = nearBottom();
      panel.classList.remove('hidden'); comp.classList.add('panel-open');
      if (near) later(scrollBottom, 30);
    }
    function closePanel() { panel.classList.add('hidden'); comp.classList.remove('panel-open'); }
    function stickers() {
      const X = Extras();
      if (!fn(X, 'stickerPicker')) { UI.toast('Stickers indisponíveis'); return; }
      try { X.stickerPicker(win, s => { if (s && typeof s === 'object' && s.id != null) doSend({ type: 'sticker', content: 'Sticker', payload: { pack: String(s.pack == null ? '' : s.pack).slice(0, 24), id: String(s.id).slice(0, 40) } }); }); }
      catch (e) { console.error('[apex_phone] RecadoExtras.stickerPicker', e); }
    }
    function gifs() {
      const X = Extras();
      if (!gifOn()) { UI.toast(ERR.nogif); return; }
      /* em jogo só https (o servidor só aceita o anfitrião do fornecedor). No browser o fornecedor falso do RD devolve
         SVG em data: e é o safeGif DELE que diz o que é seguro - e vai inteiro, cortá-lo estragava o data: URL. */
      const okUrl = u => {
        if (typeof u !== 'string' || !u) return null;
        if (/^https:\/\//.test(u)) return u.slice(0, 1024);
        return (!Bridge.inFiveM && fn(X, 'safeGif') && X.safeGif(u)) ? u : null;
      };
      try { X.gifPicker(win, gf => { const u = gf ? okUrl(gf.url) : null; if (u) doSend({ type: 'gif', content: 'GIF', payload: { url: u, w: int(gf.w), h: int(gf.h) } }); }); }
      catch (e) { console.error('[apex_phone] RecadoExtras.gifPicker', e); }
    }
    panel.querySelector('.stk').onclick = () => stickers();
    panel.querySelector('.gif').onclick = () => gifs();
    panel.querySelector('.emo').onclick = () => {};
    panel.querySelector('.bk').onclick = () => { const a = ta.selectionStart, b2 = ta.selectionEnd; if (a == null) return; if (a !== b2) { ta.value = ta.value.slice(0, a) + ta.value.slice(b2); ta.setSelectionRange(a, a); } else if (a > 0) { const cut = Array.from(ta.value.slice(0, a)); cut.pop(); const s = cut.join(''); ta.value = s + ta.value.slice(a); ta.setSelectionRange(s.length, s.length); } autosize(); };

    /* ---------- anexos ---------- */
    const targetQ = () => Object.assign({}, q);
    function attach() {
      if (!canWrite()) return;
      closePanel();
      const OPTS = [['ph', 'photo', 'Galeria', '#128C7E'], ['cam', 'camera', 'Câmara', '#0284C7'], ['doc', 'book', 'Documento', '#7C3AED'], ['loc', 'pin', 'Localização', '#0D9488'], ['ct', 'personCircle', 'Contacto', '#D97706'], ['poll', 'chart', 'Sondagem', '#E11D48'], ['ev', 'calendar', 'Evento', '#2563EB']];
      const body = UI.el('<div class="rcb-attach"><div class="rcb-attach-grid"></div><div class="rcb-attach-note">Envio de vídeo indisponível: o telemóvel não consegue gravar vídeo neste servidor.</div></div>');
      const grid = body.firstElementChild;
      OPTS.forEach(([k, ic, lb, col]) => { const e = UI.el(`<div class="rcb-att" data-k="${k}"><i style="background:${col}">${g(ic, 24)}</i><span>${lb}</span></div>`); grid.appendChild(e); });
      const sh = UI.sheet({ title: 'Partilhar', right: 'Cancelar', body, cls: 'rcb-sheet' });
      grid.onclick = e => { const it = e.target.closest('.rcb-att'); if (!it) return; sh.close(); setTimeout(() => runAttach(it.dataset.k), 120); };
    }
    async function runAttach(k) {
      if (st.dead || !canWrite()) return;
      const X = Extras();
      if (k === 'ph') {
        const ps = await pickPhotos(C.multiImageMax); if (!ps || !ps.length || st.dead) return;
        const urls = [];
        for (const p of ps) { let u = null; try { u = await Photos.data(p, true); } catch (e) { u = null; } if (typeof u === 'string' && /^data:image\//.test(u)) urls.push(u); }
        if (!urls.length) { UI.toast('Não foi possível ler as fotos escolhidas'); return; }
        if (urls.length < ps.length) UI.toast('Algumas fotos não puderam ser lidas');
        const r = await mediaComposer(win, urls, { title, captionMax: C.captionMax });
        if (r && !st.dead) sendImages(r.urls, r.caption, r.hd, r.once);
      } else if (k === 'cam') {
        const raw = await camera(win, title); if (!raw || st.dead) return;
        const r = await mediaComposer(win, [raw], { title, captionMax: C.captionMax });
        if (r && !st.dead) sendImages(r.urls, r.caption, r.hd, r.once);
      } else if (k === 'doc' || k === 'poll' || k === 'ev') {
        const f = { doc: 'documentPicker', poll: 'pollComposer', ev: 'eventComposer' }[k];
        if (!fn(X, f)) { UI.toast({ doc: 'Documentos indisponíveis', poll: 'Sondagens indisponíveis', ev: 'Eventos indisponíveis' }[k]); return; }
        let m = null; try { m = await X[f](win, targetQ()); } catch (e) { console.error('[apex_phone] RecadoExtras.' + f, e); m = null; }
        if (m && typeof m === 'object' && m.id != null && !st.dead) {
          /* só entra aqui se for DESTA conversa; uma resposta sem destinatário nem conversa é a desta (o RD enviou para targetQ) */
          const noDest = m.receiver == null && m.conversation == null && m.conversation_id == null;
          if (matches(m) || noDest) append(m);
          dropUnreadMark(); changed();
          /* o servidor não manda push a quem escreveu: a lista do RA fica a saber pela mesma via do doSend */
          Bridge.emit('recado:sent', Object.assign({}, m, isGroup ? { conversation: gid } : { receiver: number }));
        }
      } else if (k === 'loc') {
        const ok = await UI.actionSheet({ title: 'A tua posição atual fica visível nesta conversa.', buttons: [{ label: 'Enviar a minha localização', icon: 'pin', value: 'now' }] });
        if (ok !== 'now') return;
        if (window.Perm && !(await Perm.request(APP, 'location'))) return;
        const p = await Bridge.call('getCoords');
        if (!p || !isFinite(+p.x) || !isFinite(+p.y)) { UI.toast('Sem localização'); return; }
        doSend({ type: 'location', content: 'Localização', payload: { x: Math.round(+p.x * 10) / 10, y: Math.round(+p.y * 10) / 10, label: 'A minha localização' } });
      } else if (k === 'ct') {
        if (!window.Contacts) return;
        const c = await Contacts.pick('Partilhar contacto'); if (!c || !c.number) return;
        /* o servidor recusa um contacto sem nome (badpayload): sem nome vai o número */
        doSend({ type: 'contact', content: String(c.name || c.number).slice(0, 60), payload: { name: String(c.name || c.number).slice(0, 60), number: String(c.number).slice(0, 20) } });
      }
    }

    /* ---------- mensagem de voz: SEGURAR para gravar, ← cancela, ↑ bloqueia, pré-ouvir antes de enviar ---------- */
    let recPingT = null;
    function recPing(on) {
      clearInterval(recPingT); recPingT = null;
      Promise.resolve(Bridge.rpcRaw('recado.recording', Object.assign({ on: !!on }, q))).catch(() => {});
      /* quem recebe esquece o aviso ao fim de ~2× typingMs: numa gravação longa volta a avisar-se */
      if (on) recPingT = setInterval(() => { if (!st.recorder || st.dead || st.recorder.api.state !== 'recording') { clearInterval(recPingT); recPingT = null; return; } Promise.resolve(Bridge.rpcRaw('recado.recording', Object.assign({ on: true }, q))).catch(() => {}); }, Math.max(2000, C.typingMs + 500));
    }
    function micUnavailable() {
      const msg = (window.VoiceMsg && VoiceMsg.MIC_UNAVAILABLE) || 'O microfone não está disponível neste cliente do FiveM';
      UI.alert({ title: 'Mensagens de voz indisponíveis', msg: msg + '. O browser do jogo não dá acesso ao microfone a este telemóvel, por isso não é possível gravar aqui. Podes continuar a enviar texto, fotos e localização.' });
    }
    function startRecorder() {
      if (st.recorder || !canWrite()) return false;
      typingStop(); closePanel();
      const host = comp.querySelector('.rcb-rec'); host.innerHTML = '';
      comp.classList.add('recording', 'hold');
      const hint = UI.el(`<div class="rcb-lockhint"><i>${g('lock', 16)}</i><i class="up">${g('chevU', 14)}</i></div>`);
      comp.appendChild(hint);
      /* recOn = o outro lado está a ver "a gravar áudio…". Segue o estado REAL do gravador: parar para rever (■), erro
         ou envio apagam o aviso logo - antes continuava a repetir-se enquanto se ouvia a gravação antes de a enviar */
      let recOn = false, ended = false, watchT = null;
      const setRecOn = on => { if (on === recOn) return; recOn = on; recPing(on); };
      const end = () => {
        if (ended) return; ended = true;
        clearInterval(watchT);
        if (st.recorder && st.recorder.end === end) st.recorder = null;
        comp.classList.remove('recording', 'hold', 'locked'); micBtn.style.transform = ''; hint.remove(); host.innerHTML = '';
        setRecOn(false);
      };
      let rec = null;
      try { rec = VoiceMsg.recorder(host, { app: APP, maxSec: C.maxAudioSec, onSend: (blob, ms, wave) => { end(); sendVoice(blob, ms, wave); }, onCancel: () => end() }); }
      catch (e) { console.error('[apex_phone] VoiceMsg.recorder', e); end(); UI.toast('Não foi possível começar a gravar'); return false; }
      if (!rec) { end(); return false; }
      st.recorder = { api: rec, end, hint, locked: false };
      /* botão de parar (modo bloqueado): para e fica a forma de onda para ouvir antes de enviar */
      if (rec.el) { const stop = UI.el(`<div class="rcb-rec-stop" aria-label="Parar e ouvir"><i></i></div>`); stop.onclick = e => { e.stopPropagation(); try { rec.stop(); } catch (x) {} }; const send = rec.el.querySelector('.vmsg-rec-send'); rec.el.insertBefore(stop, send || null); }
      watchT = setInterval(() => {
        if (!st.recorder || st.recorder.api !== rec) { clearInterval(watchT); return; }
        setRecOn(rec.state === 'recording');
        /* erro depois de largar o dedo (microfone recusado, gravação vazia): mostra-se com o caixote à vista, em vez de ficar no modo segurar */
        if (rec.state === 'error' && !hold && !st.recorder.locked) lockRec();
      }, 150);
      return true;
    }
    function lockRec() {
      const r = st.recorder; if (!r || r.locked) return;
      r.locked = true; comp.classList.remove('hold'); comp.classList.add('locked'); micBtn.style.transform = '';
      if (r.hint) r.hint.remove();
      const tr = r.api.el && r.api.el.querySelector('.vmsg-rec-track'); if (tr) tr.style.transform = '';
    }
    function stopRecorder() {
      const r = st.recorder; if (!r) return;
      try { r.api.cancel('closed'); } catch (e) {}
      try { r.end(); } catch (e) {}
    }
    let hold = null;
    micBtn.addEventListener('pointerdown', e => {
      if (e.button && e.pointerType === 'mouse') return;
      e.preventDefault();
      if (!canWrite() || st.recorder || st.dead) return;
      if (!voiceOk()) { micUnavailable(); return; }
      hold = { pid: e.pointerId, x: e.clientX, y: e.clientY, t0: Date.now() };
      try { micBtn.setPointerCapture(e.pointerId); } catch (x) {}
      if (!startRecorder()) hold = null;
    });
    micBtn.addEventListener('pointermove', e => {
      if (!hold || e.pointerId !== hold.pid || !st.recorder || st.recorder.locked) return;
      const z = UI.zoom() || 1, dx = Math.min(0, (e.clientX - hold.x) / z), dy = Math.min(0, (e.clientY - hold.y) / z);
      if (dx < -120) { const h = hold; hold = null; try { micBtn.releasePointerCapture(h.pid); } catch (x) {} stopRecorder(); UI.toast('Gravação cancelada'); return; }
      if (dy < -90) { hold = null; lockRec(); return; }
      micBtn.style.transform = `translate(${Math.max(dx, -60).toFixed(1)}px,${Math.max(dy, -60).toFixed(1)}px) scale(1.35)`;
      const tr = st.recorder.api.el && st.recorder.api.el.querySelector('.vmsg-rec-track'); if (tr) tr.style.transform = `translateX(${(dx * .8).toFixed(1)}px)`;
      if (st.recorder.hint) st.recorder.hint.style.transform = `translateY(${(dy * .5).toFixed(1)}px)`;
    });
    const micUp = e => {
      if (!hold || (e && e.pointerId !== hold.pid)) return;
      const h = hold; hold = null;
      const r = st.recorder; if (!r || r.locked) return;
      const state = r.api.state;
      if (e && e.type === 'pointercancel') { lockRec(); return; }   /* o ponteiro perdeu-se (janela/foco): não se deita a gravação fora */
      if (Date.now() - h.t0 < 350 && state !== 'error') { stopRecorder(); UI.toast('Mantém premido para gravar e larga para enviar'); return; }
      if (state === 'recording') { micBtn.style.transform = ''; try { r.api.send(); } catch (x) {} }
      else lockRec();   /* a pedir permissão / a preparar / com erro: fica à vista, com cancelar e enviar */
    };
    micBtn.addEventListener('pointerup', micUp); micBtn.addEventListener('pointercancel', micUp);
    micBtn.addEventListener('click', e => e.preventDefault());

    /* ---------- ligações do compositor ---------- */
    ta.addEventListener('input', () => { autosize(); if (ta.value.trim()) typingPing(); else typingStop(); });
    ta.addEventListener('keydown', e => { if (e.key === 'Enter' && !e.shiftKey && !e.isComposing) { e.preventDefault(); sendText(); } });
    ta.addEventListener('focus', () => closePanel());
    comp.querySelector('.rcb-send').onclick = () => sendText();
    comp.querySelector('.rcb-plus').onclick = () => attach();
    comp.querySelector('.rcb-emo').onclick = e => { e.stopPropagation(); openPanel(); };
    comp.querySelector('.rcb-stk').onclick = e => { e.stopPropagation(); stickers(); };
    comp.querySelector('.rcb-cam').onclick = () => runAttach('cam');
    UI.longPress(ta, () => {
      const items = []; const clip = clipboard();
      if (clip) items.push({ label: 'Colar', icon: 'clipboard', onTap: () => { insertText(clip); try { ta.focus(); } catch (e) {} } });
      if (ta.value) { items.push({ label: 'Copiar', icon: 'copy', onTap: () => copyText(ta.value) }); items.push({ label: 'Limpar', icon: 'xCircle', onTap: () => { ta.value = ''; autosize(); typingStop(); } }); }
      if (!items.length) { UI.toast('Nada para colar'); return; }
      UI.ctxMenu(comp, items);
    });

    /* ---------- menções no grupo: "@" mostra os membros; o número vai no payload.mentions (o servidor valida) ---------- */
    const mentionMap = new Map();   /* '@Nome' → número */
    const mentBox = UI.el('<div class="rcb-ment hidden"></div>');
    comp.insertBefore(mentBox, comp.querySelector('.rcb-bar'));
    function mentionQuery() {
      if (!isGroup || !canWrite()) return null;
      const a = ta.selectionStart != null ? ta.selectionStart : ta.value.length;
      const mm = /(^|\s)@([^\s@]{0,20})$/.exec(ta.value.slice(0, a));
      return mm ? { q: mm[2].toLowerCase(), start: a - mm[2].length - 1, end: a } : null;
    }
    function paintMentions() {
      const mq = mentionQuery();
      const list = mq ? Object.keys(st.members).filter(n => n !== me).map(n => ({ n, name: nameFor(n) })).filter(x => !mq.q || x.name.toLowerCase().includes(mq.q) || x.n.includes(mq.q)).slice(0, 6) : [];
      mentBox.innerHTML = ''; mentBox.classList.toggle('hidden', !list.length);
      list.forEach(x => {
        const row = UI.el('<div class="rcb-ment-row"><div class="rcb-ment-av"></div><b></b><span></span></div>');
        paintAvatar(row.querySelector('.rcb-ment-av'), { number: x.n, name: x.name });
        row.querySelector('b').textContent = x.name; row.querySelector('span').textContent = x.n;
        row.onpointerdown = e => e.preventDefault();   /* o campo não perde o foco (nem o teclado fecha) */
        row.onclick = () => {
          const cur2 = mentionQuery(); if (!cur2) return;
          const tag = '@' + (x.name.split(/\s+/)[0] || x.n).replace(/[^0-9A-Za-zÀ-ÿ_.\-]/g, '').slice(0, 24);
          ta.value = ta.value.slice(0, cur2.start) + tag + ' ' + ta.value.slice(cur2.end);
          const p = cur2.start + tag.length + 1; try { ta.setSelectionRange(p, p); } catch (e) {}
          mentionMap.set(tag, x.n); autosize(); paintMentions();
        };
        mentBox.appendChild(row);
      });
    }
    const mentionsIn = text => [...new Set([...mentionMap.entries()].filter(([tag]) => new RegExp('(^|\\s)' + tag.replace(/[.*+?^${}()|[\]\\-]/g, '\\$&') + '(?=$|[\\s.,!?:;])').test(text)).map(([, n]) => n))].slice(0, 32);
    ta.addEventListener('input', paintMentions);
    ta.addEventListener('click', paintMentions);
    /* =====================================================================
       CARREGAR, LER, PRESENÇA, GRUPO, PUSHES
       ===================================================================== */
    let changedT = null;
    function changed() {
      Bridge.emit('recado:changed', { key });
      clearTimeout(changedT);
      changedT = setTimeout(() => { try { const r = R(); if (r && typeof r.refresh === 'function') r.refresh(); } catch (e) {} }, 450);
    }
    const visible = () => !st.dead && System.currentApp() === APP && !System.locked && !(Bridge.inFiveM && document.body.classList.contains('hidden'))
      && !!v.parentElement && v.parentElement.lastElementChild === v;
    /* uma rajada de mensagens (ou um grupo animado) com a conversa à vista dava um messages.read por mensagem - e o
       balde do rate limit esvaziava-se. Junta-se tudo num pedido a cada 400 ms. */
    let readT = null;
    function markRead() {
      if (st.locked || st.dead) return;
      st.unseen = false;
      if (readT) return;
      readT = later(() => {
        readT = null;
        Promise.resolve(Bridge.rpcRaw('messages.read', qa)).then(() => { if (st.dead) return; Bridge.emit('recado:read', Object.assign({}, q)); changed(); }).catch(() => {});
      }, 400);
    }
    const seeAgain = () => { if (st.unseen && visible()) markRead(); };
    let unreadEl = null;
    function dropUnreadMark() { if (unreadEl) { unreadEl.remove(); unreadEl = null; } }
    function placeUnreadMark() {
      const n = st.unreadMark; if (!(n > 0)) return null;
      const inc = st.order.map(i => st.msgs.get(i)).filter(m => m && m.sender !== me && m.type !== 'system');
      const firstNew = inc.length >= n ? inc[inc.length - n] : inc[0];
      const row = firstNew && st.rows.get(firstNew.id); if (!row) return null;
      unreadEl = UI.el('<div class="rcb-unread"><span></span></div>');
      unreadEl.firstElementChild.textContent = n === 1 ? '1 mensagem não lida' : `${n} mensagens não lidas`;
      const prevEl = row.previousElementSibling;
      thread.insertBefore(unreadEl, prevEl && prevEl.classList.contains('rcb-day') ? prevEl : row);
      return unreadEl;
    }
    function paintDown() {
      const show = st.loaded && !nearBottom();
      downBtn.classList.toggle('in', show);
      if (!show) st.newCount = 0;
      const s = downBtn.querySelector('span'); s.textContent = st.newCount > 0 ? (st.newCount > 99 ? '99+' : String(st.newCount)) : '';
      downBtn.classList.toggle('has-n', st.newCount > 0);
    }
    downBtn.onclick = () => scrollBottom();

    async function firstLoad() {
      if (st.dead || st.loaded || st.loading) return;
      st.loading = true;
      let r = null; try { r = await Bridge.rpcRaw('recado.get', Object.assign({ limit: C.pageSize }, q)); } catch (e) { r = null; }
      st.loading = false;
      if (st.dead) return;
      if (r && r.error === 'locked') { sk.classList.add('hidden'); setLocked(true); return; }
      sk.remove();
      if (r && r.error) { if (/member/.test(String(r.error))) setLeft(true); else UI.toast(errText(r, 'Não foi possível carregar a conversa')); }
      else if (!r) UI.toast('Sem resposta do servidor');
      const list = arr(r).filter(m => m && m.id != null).sort((a, b) => int(a.id) - int(b.id));
      st.more = r && typeof r.more === 'boolean' ? r.more : list.length >= C.pageSize;
      list.forEach(m => { norm(m); if (!(m.id > 0) || st.msgs.has(m.id) || (+m.expiresAt > 0 && +m.expiresAt <= Date.now())) return; st.msgs.set(m.id, m); st.order.push(m.id); if (m.type === 'system') checkSystem(m); });
      thread.insertBefore(buildRows(st.order.map(i => st.msgs.get(i)), null), anchor());
      st.loaded = true; moreEl.classList.toggle('hidden', !st.more);
      const mark = opts.messageId ? null : placeUnreadMark();
      const queued = st.queue; st.queue = []; queued.forEach(a => append(a[0], a[1]));
      loadPins();
      if (opts.messageId) jumpTo(opts.messageId);
      else if (mark) { const z = UI.zoom() || 1; sc.scrollTop = Math.max(0, sc.scrollTop + (mark.getBoundingClientRect().top - sc.getBoundingClientRect().top) / z - 90); later(paintDown, 60); }
      else { scrollBottom(); later(scrollBottom, 60); }
      /* as últimas imagens estão à vista: não se espera pelo observador (no headless pode nem disparar) */
      [...thread.querySelectorAll('.rcb-pic.loading')].slice(-8).forEach(loadPic);
      if (visible()) markRead(); else st.unseen = true;
    }
    function loadOlder() {
      if (st.loadP) return st.loadP;
      if (!st.more || st.dead || !st.loaded || !st.order.length) return Promise.resolve();
      const before = st.order[0];
      moreEl.classList.add('loading');
      st.loadP = Promise.resolve(Bridge.rpcRaw('recado.get', Object.assign({ before, limit: C.pageSize }, q))).then(r => {
        if (st.dead) return;
        const got = arr(r);
        const list = got.filter(m => m && int(m.id) > 0 && int(m.id) < before && !st.msgs.has(int(m.id))).map(norm).filter(m => !(+m.expiresAt > 0 && +m.expiresAt <= Date.now())).sort((a, b) => a.id - b.id);
        st.more = r && typeof r.more === 'boolean' ? r.more : got.length >= C.pageSize;
        if (!list.length) { if (!got.length) st.more = false; return; }
        /* manter o que está à vista no mesmo sítio: o que entra por cima empurra a altura, o scrollTop compensa */
        const h0 = sc.scrollHeight, t0 = sc.scrollTop;
        const oldFirst = st.msgs.get(before), oldRow = st.rows.get(before);
        list.forEach(m => st.msgs.set(m.id, m));
        st.order = list.map(m => m.id).concat(st.order);
        const lastNew = list[list.length - 1], sameDay = oldFirst && dayKey(lastNew) === dayKey(oldFirst);
        let build = list;
        const firstEl = moreEl.nextElementSibling;
        if (sameDay && firstEl && firstEl.classList.contains('rcb-day')) firstEl.remove();
        /* um álbum partido entre páginas junta-se numa só grelha */
        const merge = oldRow && sameDay && albumKey(lastNew) && albumKey(lastNew) === albumKey(oldFirst);
        const holder = document.createElement('div');
        if (merge) { build = list.concat(oldRow._ids.map(i => st.msgs.get(i)).filter(Boolean)); holder.appendChild(oldRow); }
        const tmp = document.createElement('div'); tmp.appendChild(buildRows(build, null));
        if (merge) keepPlayers(holder, tmp);
        const frag = document.createDocumentFragment(); while (tmp.firstChild) frag.appendChild(tmp.firstChild);
        thread.insertBefore(frag, moreEl.nextElementSibling);
        if (!merge && oldRow) rerenderRow(oldRow);   /* o nome / início de sequência da primeira antiga pode mudar */
        sc.scrollTop = sc.scrollHeight - h0 + t0;
        if (st.pins.length) paintPins();
        [...thread.querySelectorAll('.rcb-pic.loading')].slice(0, 6).forEach(loadPic);
      }).catch(e => { console.error('[apex_phone] recado.get (antes)', e); }).then(() => { st.loadP = null; moreEl.classList.remove('loading'); moreEl.classList.toggle('hidden', !st.more); });
      return st.loadP;
    }
    moreEl.onclick = () => loadOlder();
    /* traz o que falta no fim (reencaminhar para esta conversa, temporárias alteradas, voltar a ver a app) */
    function syncTail() {
      if (st.dead || !st.loaded) return;
      Promise.resolve(Bridge.rpcRaw('recado.get', Object.assign({ limit: C.pageSize }, q))).then(r => {
        if (st.dead) return;
        const last = st.order.length ? st.order[st.order.length - 1] : 0;
        arr(r).filter(m => m && int(m.id) > last).sort((a, b) => int(a.id) - int(b.id)).forEach(m => append(m, true));
      }).catch(() => {});
    }
    let scrollRaf = 0, lastDist = 0;
    const distBottom = () => sc.scrollHeight - sc.scrollTop - sc.clientHeight;
    /* a área da conversa encolhe quando o compositor cresce (barra de responder, texto de várias linhas, sugestões de
       @, gravação) ou abre o painel de emoji: quem estava perto do fim fica à MESMA distância do fim - antes a última
       mensagem ficava escondida por baixo da barra de responder. Só scrollTop, nada anima. */
    /* no frame seguinte e so com altura nova: o paintDown mexe no layout e, dentro da entrega do observador, dava
       "ResizeObserver loop limit exceeded" na consola do jogo (2026-10-01) */
    let roH = -1, roRaf = 0;
    const ro = 'ResizeObserver' in window ? new ResizeObserver(ents => {
      const r = ents && ents[0] && ents[0].contentRect; const h = r ? Math.round(r.height) : -2; if (h === roH) return; roH = h;
      cancelAnimationFrame(roRaf); roRaf = requestAnimationFrame(() => {
        if (st.dead || !st.loaded || lastDist >= 140) return;
        const want = Math.max(0, sc.scrollHeight - sc.clientHeight - lastDist);
        if (Math.abs(sc.scrollTop - want) > 1) sc.scrollTop = want;
        paintDown();
      });
    }) : null;
    if (ro) ro.observe(sc);
    sc.addEventListener('scroll', () => {
      lastDist = Math.max(0, distBottom());
      if (st.loaded && st.more && !st.loadP && sc.scrollTop < 160) loadOlder();
      if (scrollRaf) return; scrollRaf = requestAnimationFrame(() => { scrollRaf = 0; paintDown(); });
    }, { passive: true });

    /* ---------- presença (com a privacidade do RC quando existe) ---------- */
    async function loadPresence() {
      if (isGroup || st.dead) return;
      let p = null;
      let r = null; try { r = await Bridge.rpcRaw('recado.profile.get', { numbers: [number] }); } catch (e) { r = null; }
      /* resposta do RC: { ok, profiles = { [número] = { online?, lastSeen? } } } - os campos que a privacidade do dono
         esconde vêm AUSENTES. ⚠️ Não se recorre ao presence.get quando o RC respondeu: esse só conhece a definição
         antiga da conta e mostrava "online"/"visto por último" a quem o dono escondeu no Recado. */
      if (r && !r.error && r.profiles && typeof r.profiles === 'object') {
        const x = r.profiles[number];
        p = x && typeof x === 'object' ? { online: x.online === true, lastSeen: x.online === true ? 0 : (+x.lastSeen || 0) } : { online: false, lastSeen: 0 };
      } else if (r && /^unknown/.test(String(r.error))) {
        /* servidor sem o server/recado_people.lua: a presença da Fase 2 (que respeita a definição da conta) */
        try { r = await Bridge.rpcRaw('presence.get', { numbers: [number] }); } catch (e) { r = null; }
        if (r && !r.error && r[number] && typeof r[number] === 'object') p = { online: !!r[number].online, lastSeen: +r[number].lastSeen || 0 };
      }
      if (st.dead) return;
      st.presence = p; paintSub();
    }
    /* ---------- grupo: membros (nomes, cores, menções), papel, política de envio, tema ---------- */
    async function loadGroup() {
      if (!isGroup || st.dead) return;
      /* recado.group.get (RC): forma do groups.info + sendPolicy, canSend, theme, disappearing e o nome de perfil de
         cada membro (com a privacidade dele). Sem o RC, o groups.info da Fase 2. */
      let r = null; try { r = await Bridge.rpcRaw('recado.group.get', { id: gid }); } catch (e) { r = null; }
      if (!r || (r.error && !/member|forbidden|notfound/.test(String(r.error)))) { try { r = await Bridge.rpcRaw('groups.info', { id: gid }); } catch (e) { r = null; } }
      if (st.dead) return;
      if (r && !r.error && r.id != null) {
        title = r.title || r.name || title;
        const ms = {}; arr(r.members).forEach(x => { if (x && x.member) ms[String(x.member)] = { name: x.name || x.profileName || nameOf(x.member), role: x.role === 'admin' ? 'admin' : 'member' }; });
        st.members = ms; st.admin = r.myRole ? r.myRole === 'admin' : !!(ms[me] && ms[me].role === 'admin');
        const pol = r.sendPolicy || r.send_policy; if (pol === 'admins' || pol === 'all') st.policy = pol;
        if (r.canSend === true) st.policy = 'all';
        else if (r.canSend === false) { st.policy = 'admins'; st.admin = false; }
        st.canEdit = r.canEdit !== false;
        if (r.theme !== undefined) applyTheme(r.theme);
        if (r.disappearing !== undefined) setDisappearing(r.disappearing);
        st.left = !ms[me] && Object.keys(ms).length > 0;
        raw.group = Object.assign({}, raw.group || {}, { avatar: r.avatar });
      } else if (r && r.error && /member|forbidden|notfound/.test(String(r.error))) st.left = true;
      paintHead(); paintNote(); paintSub();
    }
    function applyTheme(t) { const k = THEMES[String(t == null ? '' : t).toLowerCase().replace(/[^a-z0-9-]/g, '').slice(0, 20)]; if (k && k !== 'indigo') v.dataset.rcTheme = k; else delete v.dataset.rcTheme; }
    /* estado da conversa (bloqueada, temporárias, tema) vindo do item da lista ou de outro módulo */
    function applyMeta(t) {
      if (!t || typeof t !== 'object') return;
      if (t.disappearing !== undefined) setDisappearing(t.disappearing);
      if (t.theme !== undefined) applyTheme(t.theme);
      if (t.group && t.group.theme !== undefined) applyTheme(t.group.theme);
      const nm = isGroup ? (t.group && (t.group.title || t.group.name)) || t.title || t.name : t.name;
      if (typeof nm === 'string' && nm) { title = nm.slice(0, 60); paintHead(); }
      /* `locked` não se aplica daqui: quem decide se a conversa abre é o servidor (recado.get → { error = 'locked' }),
         que conhece a autorização do código. Assim o RA, que já pediu o código antes de abrir, não obriga a pedi-lo 2 vezes. */
    }
    function setLocked(on) {
      st.locked = !!on;
      lockEl.classList.toggle('hidden', !st.locked); v.classList.toggle('rcb-locked', st.locked);
      if (st.locked) { clearReply(); stopRecorder(); closePanel(); }
      paintNote(); paintSub();
      if (!st.locked && !st.loaded) firstLoad();
    }
    lockEl.querySelector('.rcb-btn').onclick = async () => {
      const P = People(), RA = R(); let ok = false;
      if (RA && typeof RA.unlock === 'function') { try { ok = !!(await RA.unlock(Object.assign({}, q), true)); } catch (e) { console.error('[apex_phone] Recado.unlock', e); ok = false; } }
      else if (fn(P, 'unlockChat')) { try { ok = !!(await P.unlockChat(Object.assign({}, q))); } catch (e) { console.error('[apex_phone] RecadoPeople.unlockChat', e); ok = false; } }
      else {
        const pin = await UI.prompt('Conversa bloqueada', 'Escreve o código do telemóvel para abrir.', 'Código', '', 'password');
        if (pin) { const r = await Bridge.rpcRaw('recado.unlock', { pin }); ok = !failed(r); if (!ok) UI.toast(errText(r, 'Código errado')); }
      }
      if (ok && !st.dead) { unlocked.add(key); setLocked(false); }
    };

    /* ---------- pushes (só os desta conversa) ---------- */
    const isRecado = d => d && (d.app == null || d.app === APP);
    offs.push(
      Bridge.on('message', m => {
        if (!m || m.app !== APP || !matches(m)) return;
        append(m, true);
        if (m.sender !== me) { if (visible()) markRead(); else st.unseen = true; }
      }),
      Bridge.on('messageStatus', d => {
        if (!d) return;
        if (isGroup ? int(d.conversation) !== gid : (d.app !== APP || int(d.conversation) || String(d.number) !== number)) return;
        applyStatus(d);
      }),
      Bridge.on('messageReaction', d => { const m = d && st.msgs.get(int(d.id)); if (!m || !isRecado(d)) return; m.reactions = m.deleted ? [] : arr(d.reactions); paintReacts(m); }),
      Bridge.on('messageUpdate', d => { if (d && st.msgs.has(int(d.id)) && isRecado(d)) applyUpdate(d); }),
      Bridge.on('messageDeleted', d => { if (d && st.msgs.has(int(d.id)) && isRecado(d)) removeMsg(d.id); }),
      Bridge.on('typing', d => { if (d && d.app === APP) onTyping(d, st.typers); }),
      Bridge.on('recording', d => { if (isRecado(d)) onTyping(d, st.recs); }),
      Bridge.on('recadoPins', d => {
        if (!d) return;
        const c = int(d.conversation);
        if (isGroup ? c !== gid : (c || (d.number != null && String(d.number) !== number && String(d.number) !== me))) return;
        if (d.pins) setPins(d.pins); else loadPins();
      }),
      Bridge.on('recadoCall', d => {
        if (!d || d.callId == null) return;
        const status = typeof d.status === 'string' ? d.status : ({ ended: 'ended', end: 'ended', started: 'active', start: 'active' })[d.event];
        if (!status) return;
        st.msgs.forEach(m => { if (m.type === 'call' && m.payload && String(m.payload.callId) === String(d.callId) && m.payload.status !== status) { m.payload = Object.assign({}, m.payload, { status }); rerender(m.id); } });
      }),
      Bridge.on('groupUpdate', d => { if (isGroup && d && int(d.id) === gid) loadGroup(); }),
      Bridge.on('groups:changed', d => { if (isGroup && d && int(d.id) === gid) loadGroup(); }),
      Bridge.on('groups:left', d => { if (isGroup && d && int(d.id) === gid) setLeft(true); }),
      /* o RA emite { key, target, result } depois de um recado.thread.set; outros módulos podem mandar o item direto */
      Bridge.on('recado:thread', d => {
        if (!d || typeof d !== 'object') return;
        const t = normTarget(d.target || d); if (!t || (d.key ? d.key !== key : t.key !== key)) return;
        applyMeta(Object.assign({}, d.result && typeof d.result === 'object' ? d.result : {}, d.target ? {} : d));
      }),
      Bridge.on('blocks', d => {
        if (isGroup || !d) return;
        if (String(d.number) === number && d.blocked !== undefined) { st.blocked = !!d.blocked; paintNote(); paintSub(); return; }
        /* { reload: true } (lista recarregada pelo phone.js): volta-se a perguntar ao Contacts */
        if (d.reload && window.Contacts && typeof Contacts.isBlocked === 'function') { const b = !!Contacts.isBlocked(number); if (b !== st.blocked) { st.blocked = b; paintNote(); paintSub(); } }
      }),
      /* a configuração do RD (GIF ligado) chega depois de o painel ter sido montado: o separador GIF aparece sem reabrir */
      Bridge.on('recadoExtras:config', () => { const gb = (panelMounted && !st.dead) ? panel.querySelector('.gif') : null; if (gb) gb.classList.toggle('hidden', !gifOn()); }),
      Bridge.on('phone:open', () => later(() => { seeAgain(); loadPresence(); }, 0)),
      Bridge.on('unlock', () => later(() => { seeAgain(); loadPresence(); }, 250)),
      Bridge.on('app:open', id => { if (id === APP) later(() => { seeAgain(); syncTail(); }, 120); }),
      /* trocar de app a meio de uma gravação: o microfone não fica aberto em segundo plano */
      Bridge.on('app:close', id => { if (id === APP) { stopRecorder(); closePanel(); typingStop(); } })
    );
    /* mensagens temporárias: as que expiram saem da conversa sem esperar pelo servidor */
    const expT = setInterval(() => {
      if (st.dead) return; const now = Date.now();
      [...st.msgs.values()].filter(m => +m.expiresAt > 0 && +m.expiresAt <= now).forEach(m => removeMsg(m.id));
    }, 15000);
    const presT = setInterval(() => { if (!isGroup && visible()) loadPresence(); }, 60000);
    /* um "a escrever" nunca fica aceso por um "parou" perdido: a olhar para a conversa vê-se o estado expirar */
    v.addEventListener('pointerdown', e => { if (!e.target.closest('.rcb-panel,.rcb-comp')) closePanel(); }, true);
    /* voltar à conversa (perfil, info do grupo, fixadas fechados por cima): o que chegou entretanto marca-se como lido.
       Antes só o phone:open/unlock/app:open o faziam e a conversa ficava "por ler" com as mensagens à vista. */
    let stackMo = null;

    function cleanup() {
      if (st.dead) return;
      /* uma voz a tocar continua (cápsula na janela); o resto dos leitores larga-se já */
      const playing = thread.querySelector('.vmsg-player.is-playing');
      if (playing && win.isConnected) toDock(win, playing, playing._rcbWho);
      /* um "lida" ainda à espera (saiu logo a seguir a abrir): envia-se já, senão a conversa voltava a aparecer por ler */
      if (readT) { Promise.resolve(Bridge.rpcRaw('messages.read', qa)).catch(() => {}); Bridge.emit('recado:read', Object.assign({}, q)); readT = null; }
      if (stackMo) stackMo.disconnect();
      st.dead = true;
      typingStop(); stopRecorder(); clearInterval(recPingT); clearTimeout(typingT); clearTimeout(changedT); clearInterval(expT); clearInterval(presT);
      timers.forEach(t => clearTimeout(t)); timers.clear();
      if (io) io.disconnect();
      if (ro) ro.disconnect();
      dropPlayers(thread);
      offs.forEach(f => { try { f(); } catch (e) {} });
      if (cur === api) cur = prevAlive();
      changed();
    }
    const prevCur = cur;
    const prevAlive = () => (prevCur && !prevCur.isDead() && prevCur.view && prevCur.view.isConnected ? prevCur : null);

    const api = { win, view: v, key, isDead: () => st.dead, jumpTo, toBottom: scrollBottom, update: applyMeta, visible,
      pub: Object.freeze({ number: isGroup ? null : number, conversation: isGroup ? gid : null, key, get visible() { return visible(); }, isVisible: visible }) };
    cur = api;

    /* ---------- arranque ---------- */
    comp.classList.add('rcb-ready');
    paintHead(); paintSub(); paintNote();
    if (!isGroup && window.Contacts && Contacts.isBlocked && Contacts.isBlocked(number)) { st.blocked = true; paintNote(); paintSub(); }
    /* a lista de bloqueados pode ainda não ter sido carregada nesta sessão (app Telefone nunca aberta) */
    if (!isGroup && window.Contacts && typeof Contacts.loadBlocks === 'function') {
      Promise.resolve(Contacts.loadBlocks()).then(() => { if (st.dead || typeof Contacts.isBlocked !== 'function') return; const b = !!Contacts.isBlocked(number); if (b !== st.blocked) { st.blocked = b; paintNote(); paintSub(); } }).catch(() => {});
    }
    UI.push(win, v);
    { const stack = v.parentElement;
      if (stack && window.MutationObserver) { stackMo = new MutationObserver(() => { if (!st.dead && st.unseen) later(seeAgain, 60); }); stackMo.observe(stack, { childList: true }); } }
    applyMeta(raw);
    if (isGroup) loadGroup(); else loadPresence();
    /* o estado da conversa (temporárias, nome) vem do item da lista: a cache do RA ou, sem ela, o recado.threads.
       Não atrasa as mensagens - uma conversa bloqueada é o recado.get que a recusa, sem nada à vista antes disso. */
    { const RA = R(); let it = null; try { it = RA && typeof RA.thread === 'function' ? RA.thread(q) : null; } catch (e) { it = null; }
      if (it) applyMeta(it);
      else if (raw.disappearing === undefined) Promise.resolve(Bridge.rpcRaw('recado.threads', { filter: 'all' })).then(r => { if (st.dead) return; const x = arr(r).find(t2 => { const n = normTarget(t2); return n && n.key === key; }); if (x) applyMeta(x); }).catch(() => {}); }
    firstLoad();
    return api.pub;
  }

  /* =====================================================================
     API PÚBLICA
     ===================================================================== */
  function close() {
    if (!cur || cur.isDead()) return false;
    const v = cur.view, stack = v && v.parentElement;
    if (stack && stack.lastElementChild === v && stack.children.length > 1) return UI.pop(v);
    return false;
  }
  function current() { return cur && !cur.isDead() ? cur.pub : null; }
  /* outro módulo mudou o estado de uma conversa (RC: temporárias/bloqueio/tema; RA: nome) */
  function update(target, patch) {
    const t = normTarget(target); if (!t || !cur || cur.isDead() || cur.key !== t.key) return false;
    cur.update(Object.assign({}, patch || {}));
    return true;
  }
  /* guardar o telemóvel volta a pedir o código às conversas bloqueadas; trocar de personagem limpa tudo */
  Bridge.on('phone:close', () => unlocked.clear());
  Bridge.on('session:changed', () => { unlocked.clear(); closeDock(); ownClip = ''; });
  Bridge.on('app:kill', id => { if (id === APP) closeDock(); });

  const pub = { open, close, current, update, label, formatText, unlocked: key => unlocked.has(String(key)), markUnlocked: key => { if (typeof key === 'string' && /^(n|g):/.test(key)) unlocked.add(key); },
    /* ecrãs soltos para o harness e para os outros pacotes (Atualizações/Canais podem reutilizar a pré-visualização e o visor) */
    viewer, mediaComposer, pickTargets, pickPhotos, closeDock, get dock() { return dock ? dock.el : null; } };
  /* o recado.js (RA) carrega DEPOIS deste ficheiro: regista-se quando ele existir */
  const reg = () => { try { if (window.Recado && typeof Recado.register === 'function') { Recado.register('chat', pub); return true; } } catch (e) { console.error('[apex_phone] Recado.register(chat)', e); } return false; };
  if (!reg()) { if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', reg, { once: true }); else setTimeout(reg, 0); }
  return pub;
})();
