/* ===================== MENSAGENS (SMS/iMessage entre jogadores) =====================
   Fase 2 (pacote M3) - contrato em docs/ARQUITETURA.md §8.3/§8.4.

   O que vive onde:
     · window.Msgs (este IIFE) sobrevive ao killApp: pushes globais (message, messageStatus,
       messageReaction, messageUpdate, typing, groupUpdate), badge, cache das conversas
       (fixada/silenciada/mensagem fixada), cache da media descarregada e a área de
       transferência interna (Msgs.clipboard).
     · App.define('messages') é a janela: lista de conversas e a conversa aberta.
     · No fim do ficheiro ficam os mocks do browser (LocalDB.register) dos RPCs novos do M1.

   Compatibilidade: a tabela e os RPCs messages.* são partilhados com as DMs do Instashot/Tweeter,
   Match, Marketplace, Wallet, Maps, Vera… Tudo o que é novo é ADITIVO: respostas antigas
   continuam a funcionar (sem status, sem reactions, sem replyTo) e os parâmetros novos só vão
   quando esta app os usa (limit, before, conversation, scope, mediaId, replyTo). */
window.Msgs = (() => {
  let openThread = null; /* a conversa aberta: { number, conversation, app, append, remove, status, … } */
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  /* id de app partilhada (Partilhar app na Home): só letras, números, _ e -, e só se existir neste telemóvel */
  const sharedApp = p => { const id = p && typeof p.app === 'string' ? p.app : ''; return /^[A-Za-z0-9_-]{1,40}$/.test(id) && window.App && App.get(id) ? id : null; };

  /* ---------- Config.Messages / Config.Media ----------
     Chegam no `ready` (client/main.lua) e ficam em System.config.messages/media; sem eles (NUI mais
     nova do que o client.lua) usam-se os valores por omissão do config.lua. O servidor é que
     decide sempre (janelas de editar/apagar, lista de reações, tamanhos) - aqui só se escondem
     opções que ele recusaria. */
  const DEF_REACTIONS = ['❤️', '👍', '😂', '😮', '😢', '🙏'];
  const posInt = (v, d, lo, hi) => { const n = Math.floor(+v); return isFinite(n) && n >= lo ? Math.min(hi, n) : d; };
  function cfg() {
    const sc = (window.System && System.config) || {}; const c = sc.messages || {}, m = sc.media || {};
    const re = Array.isArray(c.reactions) ? c.reactions.filter(x => typeof x === 'string' && x && x.length <= 16).slice(0, 8) : [];
    return {
      pageSize: posInt(c.pageSize, 30, 1, 50), editWindowMin: posInt(c.editWindowMin, 15, 0, 1e6), deleteForAllMin: posInt(c.deleteForAllMin, 60, 0, 1e6),
      typingMs: posInt(c.typingMs, 3000, 500, 60000), reactions: re.length ? re : DEF_REACTIONS.slice(),
      maxImageBytes: posInt(m.maxImageBytes, 260000, 4096, 5e6), maxAudioSec: posInt(m.maxAudioSec, 60, 1, 600), chunkBytes: posInt(m.chunkBytes, 48000, 1024, 200000)
    };
  }

  /* o json.encode do FiveM manda uma tabela Lua vazia como {} (e uma esparsa como objeto): tudo o que
     é "lista" passa por aqui antes de ser percorrido. Um { error } nunca é lista. */
  const arr = r => Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error ? (Array.isArray(r.items) ? r.items : Object.values(r).filter(x => x && typeof x === 'object')) : []);
  const myNumber = () => (window.System && System.player && System.player.phone) || '';
  /* ---------- modo de voo (CC.requireNet, shell/control.js) ----------
     Só antes do que AGE (enviar, reencaminhar): ler a lista e abrir a conversa continuam a funcionar - bloquear a
     leitura enquanto a app abre e mostra o histórico seria uma incoerência maior. Sem o Centro de controlo carregado
     (harness antigo, ecrã de arranque) não trava nada: quem avisa é o próprio CC.requireNet. */
  /* eSIM (js/apps/esim.js): sem linha (SIM obrigatório) também não se envia - o ESim.require avisa com "Adicionar eSIM" */
  const netOk = what => (!(window.CC && CC.requireNet) || CC.requireNet(what || 'enviar a mensagem')) && (!(window.ESim && ESim.require) || ESim.require('enviar mensagens'));
  /* push de uma SMS que chegou a OUTRA linha (não a ativa): não entra na conversa aberta, que é da identidade ativa */
  const offLine = m => !!(m && m.line && window.ESim && ESim.isInactive && ESim.isInactive(m.line));
  const convOf = m => { const c = m && (m.conversation != null ? m.conversation : m.conversation_id); const n = Math.floor(+c); return n > 0 ? n : 0; };
  const keyOf = t => { const gid = t && (t.conversation || (t.group && t.group.id)); return gid ? 'g:' + Math.floor(+gid) : 'n:' + (t && t.number); };

  /* ---------- estado das conversas (vem do messages.threads) ----------
     Serve para (1) não notificar conversas silenciadas, (2) abrir uma conversa já com a faixa da
     mensagem fixada e (3) dar título aos grupos nas notificações. */
  const meta = new Map();     /* 'n:<número>' | 'g:<id>' → { pinned, mutedUntil, pinnedMsg } */
  const groups = new Map();   /* id → { id, title, avatar, members } */
  function remember(ts) {
    arr(ts).forEach(t => {
      if (!t) return;
      meta.set(keyOf(t), { pinned: !!t.pinned, mutedUntil: +t.mutedUntil || 0, pinnedMsg: +t.pinnedMsg || 0 });
      if (t.group && t.group.id) { const id = Math.floor(+t.group.id); groups.set(id, Object.assign({}, groups.get(id) || {}, t.group)); }
    });
  }
  const isMuted = k => { const x = meta.get(k); return !!(x && x.mutedUntil && x.mutedUntil > Date.now()); };
  const groupTitle = id => { const x = groups.get(Math.floor(+id)); return (x && (x.title || x.name)) || 'Grupo'; };

  /* duração de um áudio: o gravador (M4) dá milissegundos; payloads antigos/externos podem vir em segundos.
     Nenhuma mensagem de voz passa de 10 min, por isso > 600 só pode ser ms. */
  const durTxt = d => { d = +d || 0; if (d <= 0) return ''; return UI.fmtDur(d > 600 ? d / 1000 : d); };
  /* ---------- mensagens de sistema dos grupos ----------
     O server/groups.lua escreve-as com NÚMEROS ("555-0142 adicionou 555-0101") e manda no payload
     { action, by, targets, title, role, admin, avatar } precisamente para a NUI dizer nomes. Quando fui eu,
     fica na 2.ª pessoa ("Adicionaste a Mãe"); uma ação desconhecida troca só os números pelos nomes. */
  function sysText(m, nameFn) {
    const raw = String((m && m.content) || ''), p = m && m.payload && typeof m.payload === 'object' ? m.payload : {};
    const me = myNumber(), nm = x => (nameFn ? nameFn(x) : null) || Contacts.name(x);
    /* 1.1.8: "tu" e a ligação " e " da lista ("Ana, Rui e tu") ficavam em português em todos os idiomas: o tradutor do DOM
       só traduz a frase à volta ("Adicionaste %s"), não o que está dentro do %s. Traduzem-se aqui, pela chave exata. */
    const tt = s => (window.L && L.t ? L.t(s) : s);
    const tf = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? String(a.shift()) : '')));
    const who = x => x === me ? tt('tu') : nm(x);
    const targets = (Array.isArray(p.targets) ? p.targets : arr(p.targets)).filter(x => typeof x === 'string' && x);
    const join = xs => { const n = xs.map(who); return n.length > 1 ? tf('%s e %s', n.slice(0, -1).join(', '), n[n.length - 1]) : (n[0] || ''); };
    const others = targets.filter(x => x !== me), title = typeof p.title === 'string' ? p.title.slice(0, 40) : '';
    if (p.by && p.by === me) {
      switch (p.action) {
        case 'create': if (title) return `Criaste o grupo «${title}»`; break;
        case 'rename': if (title) return `Mudaste o nome do grupo para «${title}»`; break;
        case 'avatar': return p.avatar ? 'Mudaste a imagem do grupo' : 'Removeste a imagem do grupo';
        case 'add': if (others.length) return 'Adicionaste ' + join(others); break;
        case 'remove': if (others.length) return 'Removeste ' + join(others); break;
        case 'leave': return 'Saíste do grupo';
        case 'admin': return 'Passaste a ser administrador';
        case 'role': if (targets.length) return p.role === 'admin' ? (targets[0] === me ? 'Passaste a ser administrador' : `Nomeaste ${join(targets)} administrador`) : (targets[0] === me ? 'Deixaste de ser administrador' : `Retiraste a administração a ${join(targets)}`); break;
      }
    } else if (p.by && targets.includes(me)) {
      const by = nm(p.by);
      if (p.action === 'add') return `${by} adicionou-te` + (others.length ? ' e ' + join(others) : '');
      if (p.action === 'remove') return `${by} removeu-te do grupo`;
      if (p.action === 'role') return p.role === 'admin' ? `${by} nomeou-te administrador` : `${by} retirou-te a administração`;
      if (p.action === 'admin') return 'Passaste a ser administrador';
    }
    let t = raw;
    [...new Set([p.by, p.admin].concat(targets).filter(x => typeof x === 'string' && x.length >= 3 && raw.includes(x)))]
      .sort((a, b) => b.length - a.length).forEach(n => { t = t.split(n).join(n === me ? 'tu' : nm(n)); });
    return t;
  }
  const label = m => {
    if (!m) return '';
    const p = m.payload || {};
    if (m.deleted) return 'Mensagem apagada';
    if (m.type === 'system') return sysText(m);
    if (m.type === 'image') return '📷 Foto';
    if (m.type === 'audio') { const t = durTxt(p.duration); return '🎤 Mensagem de voz' + (t ? ' (' + t + ')' : ''); }
    if (m.type === 'location') return '📍 Localização';
    if (m.type === 'contact') return '👤 ' + (p.name || 'Contacto');
    if (m.type === 'app' && sharedApp(p)) return '📱 ' + App.name(sharedApp(p));
    return m.content;
  };

  /* ---------- área de transferência ----------
     No CEF do FiveM o navigator.clipboard costuma falhar (sem permissão nem foco) e o teclado virtual
     não tem "colar": por isso há uma área INTERNA, que funciona sempre dentro do telemóvel. A cópia para
     o sistema é só uma tentativa (a promessa rejeitada é apanhada - antes ficava a rebentar em silêncio). */
  let clip = '';
  function execCopy(text) {
    const prev = document.activeElement;
    try {
      const ta = document.createElement('textarea');
      ta.value = text; ta.setAttribute('readonly', ''); ta.className = 'no-kb';   /* no-kb: o teclado virtual ignora-a */
      ta.style.cssText = 'position:fixed;left:-9999px;top:0;opacity:0';
      document.body.appendChild(ta); ta.select();
      const ok = document.execCommand && document.execCommand('copy');
      ta.remove();
      return !!ok;
    } catch (e) { return false; }
    finally { try { if (prev && prev.focus && prev !== document.body) prev.focus(); } catch (e) {} }
  }
  function copy(text, silent) {
    text = String(text == null ? '' : text); if (!text) return false;
    clip = text.slice(0, 4000);
    try {
      if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(clip).catch(() => execCopy(clip));
      else execCopy(clip);
    } catch (e) { execCopy(clip); }
    if (!silent) UI.toast('Copiado');
    return true;
  }
  function paste(input) {
    if (!clip || !input) return false;
    const s = input.selectionStart ?? input.value.length, e = input.selectionEnd ?? s;
    let ins = clip;
    if (input.maxLength > 0) { const room = input.maxLength - (input.value.length - (e - s)); if (room <= 0) return false; ins = ins.slice(0, room); }
    input.value = input.value.slice(0, s) + ins + input.value.slice(e);
    const p = s + ins.length; try { input.setSelectionRange(p, p); } catch (x) {}
    input.dispatchEvent(new Event('input', { bubbles: true }));
    return true;
  }

  /* ---------- MEDIA (media.begin / upload / finish / get) ----------
     Uma foto em base64 (até ~260 KB) num único evento de rede é descartada pelo FiveM: sobe e desce aos
     bocados de Config.Media.chunkBytes, como as Fotos. O que já desceu fica em memória (LRU com teto de
     entradas e de caracteres) - voltar a uma conversa não volta a pedir as mesmas imagens. */
  const media = new Map(); let mediaChars = 0;
  const MEDIA_MAX = 40, MEDIA_CHARS = 8e6;
  /* o MAX_PARTS do server/media.lua. Era 64 (o das Fotos): com Config.Media.chunkBytes no mínimo (4000) uma foto de
     260 KB são 66 bocados - o envio era recusado aqui e, na leitura, a imagem vinha CORTADA sem erro nenhum */
  const MAX_PARTS = 512;
  const mediaPending = new Map();
  function mediaPut(id, v) {
    id = Math.floor(+id); if (!(id > 0) || !v || typeof v.url !== 'string') return;
    if (media.has(id)) { mediaChars -= media.get(id).url.length; media.delete(id); }
    media.set(id, Object.assign({ id }, v)); mediaChars += v.url.length;
    while ((media.size > MEDIA_MAX || mediaChars > MEDIA_CHARS) && media.size > 1) { const first = media.entries().next().value; media.delete(first[0]); mediaChars -= first[1].url.length; }
  }
  const mediaCached = id => { id = Math.floor(+id); const v = media.get(id); if (v) { media.delete(id); media.set(id, v); } return v || null; };
  /* duas descargas em paralelo: cada bocado é uma ida e volta NUI→cliente→servidor; um pedido explícito
     (abrir a imagem) passa à frente das miniaturas */
  let running = 0; const waiting = [];
  const slot = (run, first) => new Promise(done => {
    const go = async () => { running++; let v = null; try { v = await run(); } catch (e) { v = null; } running--; done(v); const nx = waiting.shift(); if (nx) nx(); };
    if (running < 2) go(); else if (first) waiting.unshift(go); else waiting.push(go);
  });
  function mediaGet(id, first) {
    id = Math.floor(+id); if (!(id > 0)) return Promise.resolve(null);
    const hit = mediaCached(id); if (hit) return Promise.resolve(hit);
    if (mediaPending.has(id)) return mediaPending.get(id);
    const p = slot(async () => {
      let out = '', total = 1, head = null;
      for (let i = 1; i <= total; i++) {
        let r = await Bridge.rpcRaw('media.get', { id, i });
        if (r && r.error === 'ratelimit') { await sleep(700); r = await Bridge.rpcRaw('media.get', { id, i }); }
        if (!r || r.error || typeof r.data !== 'string') return null;
        if (!head) head = r;
        total = Math.max(1, Math.floor(+r.total) || 1);
        if (total > MAX_PARTS) return null;   /* limite duro: nunca um ciclo infinito, e nunca uma imagem cortada */
        out += r.data;
        if (!r.data.length) break;
      }
      /* um bocado perdido pelo caminho dava um data: URL que ainda "valida" mas não descodifica */
      if (head && +head.size > 0 && out.length !== +head.size) return null;
      const mime = head && typeof head.mime === 'string' ? head.mime.slice(0, 40) : '';
      let url = out;
      /* o servidor pode guardar o data: URL inteiro ou só o base64: aceita-se os dois */
      if (!/^data:/.test(url)) { if (!/^[A-Za-z0-9+/=]*$/.test(url.slice(0, 256)) || !/^[a-z]+\/[A-Za-z0-9.+-]+$/.test(mime)) return null; url = 'data:' + mime + ';base64,' + url; }
      if (!/^data:(image|audio)\/[A-Za-z0-9.+-]+[;,]/.test(url)) return null;
      return { id, url, kind: head.kind || null, mime, duration: head.duration != null ? +head.duration : null, meta: head.meta || null };
    }, first).then(v => { mediaPending.delete(id); if (v) mediaPut(id, v); return v; });
    mediaPending.set(id, p);
    return p;
  }
  /* → { mediaId } ou { error }. `data` é o data: URL (os bocados concatenados voltam a dar o mesmo texto);
     `size` é o comprimento desse texto, que é o que o servidor recebe e guarda. */
  async function upload(data, info, onProgress) {
    if (typeof data !== 'string' || !data) return { error: 'empty' };
    info = info || {};
    const size = data.length;
    const b = await Bridge.rpcRaw('media.begin', { kind: info.kind, mime: info.mime, size, duration: info.duration, meta: info.meta });
    const id = b && Math.floor(+b.id);
    if (!b || b.error || !(id > 0)) return { error: (b && b.error) || 'rpc' };
    const chunk = posInt(b.chunk, cfg().chunkBytes, 1024, 200000);
    const total = Math.ceil(size / chunk);
    if (total > MAX_PARTS) return { error: 'toolarge' };
    for (let i = 1; i <= total; i++) {
      const d = { id, i, total, data: data.slice((i - 1) * chunk, i * chunk) };
      let r = await Bridge.rpcRaw('media.upload', d);
      if (r && r.error === 'ratelimit') { await sleep(800); r = await Bridge.rpcRaw('media.upload', d); }
      if (!r || r.error || r.ok === false) return { error: (r && r.error) || 'rpc' };
      if (onProgress) { try { onProgress(i / total); } catch (e) {} }
    }
    const f = await Bridge.rpcRaw('media.finish', { id });
    if (!f || f.error || f.ok === false) return { error: (f && f.error) || 'rpc' };
    return { mediaId: id };
  }

  /* Enviar uma foto a partir de OUTRA app (Fotos › Partilhar, Instashot/Tweeter › Enviar por mensagem). A imagem sobe aos
     bocados (media.*) e a mensagem leva só o mediaId: um data: URL inteiro (até ~260 KB) num único messages.send é
     cortado pelo FiveM num evento de rede e o pedido nunca voltava. Links https e gradientes (seed) cabem no payload,
     como antes. → a mensagem enviada ou { error } (os mesmos códigos do servidor, ou empty/baddata/rpc). */
  async function sendPhoto(to, src, extra) {
    extra = extra || {};
    const d = { to: String(to == null ? '' : to).slice(0, 40), type: 'image', content: 'Foto', app: typeof extra.app === 'string' ? extra.app.slice(0, 20) : 'sms' };
    if (!d.to) return { error: 'target' };
    if (!netOk('enviar a foto')) return { error: 'nonet' };   /* quem chama já diz "A foto não foi enviada"; o porquê é do CC */
    if (typeof src === 'string' && /^data:image\//i.test(src)) {
      const C = cfg(); let img = src;
      /* a lista branca do server/media.lua é jpeg/png/webp e o limite é Config.Media.maxImageBytes */
      if (img.length > C.maxImageBytes || !/^data:image\/(jpeg|png|webp);base64,/i.test(img)) {
        if (!window.Photos || typeof Photos.shrink !== 'function') return { error: 'toolarge' };
        try { img = await Photos.shrink(img, 1100, 0, Math.max(20000, C.maxImageBytes - 2048)); } catch (e) { img = null; }
        if (!img || img === Photos.BLACK) return { error: 'baddata' };
      }
      const mime = ((/^data:(image\/[A-Za-z0-9.+-]+);/.exec(img) || [])[1] || 'image/jpeg').toLowerCase();
      const up = await upload(img, { kind: 'image', mime });
      if (!up || up.error || !up.mediaId) return { error: (up && up.error) || 'rpc' };
      mediaPut(up.mediaId, { url: img, kind: 'image', mime });   /* quem envia já tem a imagem: a conversa não a volta a descer */
      d.mediaId = up.mediaId; d.payload = { mediaId: up.mediaId };
    } else if (typeof src === 'string' && /^https?:\/\//i.test(src) && src.length <= 2048) d.payload = { url: src };
    else if (src != null && src !== '' && isFinite(+src)) d.payload = { seed: Math.floor(+src) };
    else return { error: 'empty' };
    if (extra.seed != null && isFinite(+extra.seed) && !d.mediaId) d.payload.seed = Math.floor(+extra.seed);
    let r = null; try { r = await Bridge.rpcRaw('messages.send', d); } catch (e) { r = null; }
    if (r && !r.error && r.id != null) { Bridge.emit('messages:changed'); return r; }
    return { error: (r && r.error) || 'rpc' };
  }

  async function badge() {
    let r = null; try { r = await Bridge.rpc('messages.threads', { app: 'sms' }); } catch (e) { r = null; }
    const ts = arr(r); if (r && !r.error) remember(ts);
    System.badge('messages', ts.reduce((a, x) => a + ((x && x.unread) || 0), 0));
    return ts;
  }

  /* Abrir uma conversa a partir de outra app (Contactos, Vera, notificação, pesquisa, Marketplace…).
     `number` pode ser o número, 'g:<id>' ou { number | conversation, name }. Antes era um setTimeout de
     80 ms às cegas: com o telemóvel bloqueado a app só abre depois do desbloqueio e a conversa perdia-se. */
  function open(number, name) {
    const go = () => { if (Msgs._open) Msgs._open(number, name); };
    if (System.currentApp() === 'messages' && Msgs._open) { go(); return; }
    let t = null;
    const off = Bridge.on('app:open', id => { if (id !== 'messages') return; off(); clearTimeout(t); setTimeout(go, 80); });
    t = setTimeout(off, 20000);
    System.openApp('messages');
  }
  const openGroup = (id, title) => open({ conversation: Math.floor(+id), name: title });

  /* a conversa está mesmo à frente do jogador (app visível, desbloqueado e telemóvel na mão) */
  const visible = () => System.currentApp() === 'messages' && !System.locked && !(Bridge.inFiveM && document.body.classList.contains('hidden'));
  const matches = (cur, m) => { const c = convOf(m); return c ? cur.conversation === c : (!cur.conversation && cur.number === m.sender); };

  Bridge.on('message', m => {
    if (!m) return; const app = m.app || 'sms';
    if (app !== 'sms') { Bridge.emit('social:dm', m); return; }
    const conv = convOf(m), me = myNumber(), cur = openThread;
    /* o push do grupo traz { id, title, avatar } atuais: a cache (título das notificações, cabeçalho) fica em dia sem pedir nada */
    if (conv && m.group && typeof m.group === 'object' && m.group.title) groups.set(conv, Object.assign({}, groups.get(conv) || {}, { id: conv, title: String(m.group.title).slice(0, 40) }, m.group.avatar !== undefined ? { avatar: m.group.avatar } : {}));
    if (cur && cur.append && matches(cur, m) && !offLine(m)) {
      const seen = visible();
      cur.append(m, true, seen);
      /* a conversa aberta mas escondida (outra app, bloqueado, no bolso) já não marca como lida às
         escondidas: fica por ler e notifica; marca quando voltar a estar à vista */
      if (seen) { if (m.sender !== me) Bridge.rpc('messages.read', conv ? { conversation: conv, app } : { number: m.sender, app }).then(() => badge()); return; }
    }
    if (m.sender === me) return;
    if (!offLine(m)) badge();   /* outra linha: o emblema é o da identidade ativa; a contagem dela vai para o seletor de linha (ESim) */
    /* mensagens de sistema dos grupos nunca avisam. As outras (1:1 e grupo) são avisadas AQUI: é a NUI que sabe se a
       conversa está à vista (lá em cima já saiu sem avisar). O GroupSend (server/groups.lua) deixou de chamar
       NotifyPlayer por mensagem - com a conversa aberta tocava a cada mensagem. Um push com `notified` VERDADEIRO quer
       dizer que quem o mandou já tratou da notificação: não se repete.
       ⚠️ Só o verdadeiro trava. Era `typeof m.notified === 'boolean'`, e assim um `notified: false` - o servidor a dizer
       que NÃO avisou (sem NotifyCitizen, ou com o aviso deitado fora pelo travão do server/main.lua) - calava também a
       NUI e a mensagem ficava sem sinal dos dois lados. O push 'mail' (apps/mail.js, `if (!m.notified)`) sempre leu assim. */
    if (m.type === 'system' || m.notified) return;
    /* silenciada (o servidor marca o push com muted, e a cache da lista também sabe): conta no emblema, sem aviso */
    if (m.muted || isMuted(conv ? 'g:' + conv : 'n:' + m.sender)) return;
    const who = Contacts.name(m.sender);
    const title = conv ? groupTitle(conv) : who;
    Notify.push({ app: 'messages', title, msg: conv ? who + ': ' + label(m) : label(m),
      data: Object.assign(conv ? { conversation: conv } : { number: m.sender }, m.type === 'location' && m.payload ? { coords: { x: m.payload.x, y: m.payload.y } } : {}, m.line && typeof m.line === 'object' ? { line: m.line } : {}),
      /* SMS de outra linha: tocar troca primeiro para essa linha (sim.switch) e só depois abre a conversa */
      onTap: () => { const go = () => (conv ? openGroup(conv, title) : open(m.sender, who)); if (offLine(m) && window.ESim && ESim.switchTo) ESim.switchTo(m.line.number).then(go, go); else go(); } });
  });
  Bridge.on('ready', () => setTimeout(badge, 500));
  /* push antigo: o remetente apagou uma mensagem ({ id, app, number }) - sai da conversa aberta */
  Bridge.on('messageDeleted', d => {
    if (!d || (d.app || 'sms') !== 'sms') return;
    const c = convOf(d);
    if (openThread && openThread.remove && (c ? openThread.conversation === c : (!openThread.conversation && openThread.number === d.number))) openThread.remove(d.id);
    Bridge.emit('messages:changed'); badge();
  });
  /* pushes da Fase 2: aplicados à conversa aberta sem a recarregar; a lista fica marcada como velha.
     O servidor manda os mesmos pushes às DMs do Instashot/Tweeter e ao Match (app ≠ 'sms'): esses não são
     desta app - antes cada estado "entregue/lida" de uma DM social repintava a lista das Mensagens. */
  const isSms = d => (d.app || 'sms') === 'sms';
  Bridge.on('messageStatus', d => { if (!d || !isSms(d)) return; if (openThread && openThread.status) openThread.status(d); Bridge.emit('messages:changed'); });
  Bridge.on('messageReaction', d => { if (d && isSms(d) && openThread && openThread.react) openThread.react(d); });
  Bridge.on('messageUpdate', d => { if (!d || !isSms(d)) return; if (openThread && openThread.update) openThread.update(d); Bridge.emit('messages:changed'); });
  Bridge.on('typing', d => { if (d && isSms(d) && openThread && openThread.typing) openThread.typing(d); });
  /* notificações criadas pelo SERVIDOR (mensagem de grupo, "adicionou-te ao grupo", resumo das SMS por ler ao
     entrar) não têm onTap: o Notify emite notif:open e abre a app. Antes só a janela ouvia isto, e só com as
     Mensagens já à frente - tocada a partir de outra app abria a lista e a conversa perdia-se. O open() espera
     pela app (também atrás do desbloqueio); o openApp que o Notify faz a seguir já não faz nada. */
  Bridge.on('notif:open', n => {
    if (!n || n.app !== 'messages' || !n.data || typeof n.data !== 'object') return;
    const c = Math.floor(+(n.data.conversation || n.data.group)) || 0;
    if (c > 0) openGroup(c);
    else if ((typeof n.data.number === 'string' || typeof n.data.number === 'number') && String(n.data.number) !== '') open(String(n.data.number).slice(0, 40));
  });
  const onGroup = d => {
    if (!d) return;
    const id = Math.floor(+d.id);
    /* cada campo por si: o push de "mudou a imagem" traz avatar sem title, o de "adicionou" não traz nenhum dos dois */
    if (id > 0 && (d.title || d.avatar !== undefined || Array.isArray(d.members))) groups.set(id, Object.assign({}, groups.get(id) || {}, { id }, d.title ? { title: d.title } : {}, d.avatar !== undefined ? { avatar: d.avatar } : {}, Array.isArray(d.members) ? { members: d.members } : {}));
    /* os ecrãs do grupo (M4) silenciam pelo thread.set e avisam com mutedUntil: as notificações seguem logo a escolha */
    if (id > 0 && d.mutedUntil !== undefined) meta.set('g:' + id, Object.assign({ pinned: false, pinnedMsg: 0 }, meta.get('g:' + id) || {}, { mutedUntil: +d.mutedUntil || 0 }));
    if (openThread && openThread.group) openThread.group(d);
    Bridge.emit('messages:changed'); badge();
  };
  Bridge.on('groupUpdate', onGroup);
  Bridge.on('groups:changed', onGroup);   /* evento local (ecrãs de grupo do M4) */
  /* troca de personagem: nada do que estava em memória é desta personagem */
  Bridge.on('session:changed', () => { meta.clear(); groups.clear(); media.clear(); mediaChars = 0; clip = ''; });

  return {
    open, openGroup, badge, label, sysText, sharedApp, cfg, arr, keyOf, convOf, remember, isMuted, groupTitle, meta, groups, netOk,
    copy, paste, media: mediaGet, mediaCached, mediaPut, upload, sendPhoto, durTxt,
    get clipboard() { return clip; }, set clipboard(v) { clip = v == null ? '' : String(v).slice(0, 4000); },
    set current(t) { openThread = t; }, get current() { return openThread; }
  };
})();

App.define('messages', {
  name: 'Mensagens', core: true, category: 'Comunicação',
  actions: [{ label: 'Nova mensagem', icon: 'compose', onTap: () => { System.openApp('messages'); setTimeout(() => Msgs._compose && Msgs._compose(), 300); } }],
  /* botão Voltar da Nova UI: a câmara e o visualizador de fotos vivem na janela, fora da pilha; fecham-se antes da conversa */
  back(win) { try { return !!(win && win._msgsBack && win._msgsBack()); } catch (e) { return false; } },
  open(win) {
    const g = UI.g;
    /* Nova UI (Android): a mesma app, os mesmos RPC e pushes; só a apresentação muda (separadores Conversas e
       Contactos, botão flutuante de escrever, bolhas e barra de escrita à Android). O setOS mata a janela, por isso
       o sistema lido aqui é o certo durante toda a vida dela. Classes novas com o prefixo amsg-. */
    const AND = !!(window.System && typeof System.isAndroid === 'function' && System.isAndroid() && window.PhoneDroid);
    const T = s => (window.L && L.t ? L.t(s) : s);
    let curQ = '', winDead = false;
    const layers = new Set();   /* camadas por cima da janela (câmara): fecham-se com a app */
    win._msgsBack = () => { if (!AND) return false;
      if (layers.size) { const f = [...layers].pop(); try { f(); } catch (e) {} return true; }
      const vw = win.querySelector(':scope > .viewer'); if (vw) { vw.remove(); return true; }
      return false; };
    const FOREVER = 4102444800000;   /* "silenciar sempre" = 1 jan 2100 (o contrato só tem mutedUntil) */
    /* códigos de erro do server/messages.lua e do server/media.lua, ditos por extenso */
    const ERR = { ratelimit: 'Demasiados pedidos, espera um instante', toolarge: 'O anexo é demasiado grande', window: 'Já passou o tempo para fazer isso', notsender: 'Só podes fazer isso com mensagens que enviaste',
      notmember: 'Já não és membro deste grupo', forbidden: 'Sem permissão', notfound: 'A mensagem já não existe', media: 'O anexo já não está disponível', badmedia: 'O anexo já não está disponível',
      blocked: 'Bloqueaste este número: desbloqueia-o para lhe enviar mensagens', nomatch: 'Só podes escrever a quem deu match contigo', target: 'Destinatário inválido', noidentity: 'Este telemóvel não tem número',
      badreaction: 'Reação inválida', badreply: 'A mensagem a que respondes já não existe', badtype: 'Tipo de mensagem inválido', badwave: 'A mensagem de voz chegou estragada', nottext: 'Só se editam mensagens de texto',
      unsupported: 'Esta mensagem não pode ser apagada assim (nos grupos só apagas as que enviaste)',invalid: 'Pedido inválido', badscope: 'Pedido inválido', deleted: 'A mensagem foi apagada', empty: 'A mensagem está vazia',
      busy: 'Já há outro envio a decorrer, espera um instante', baddata: 'O ficheiro chegou estragado', badmime: 'Formato de ficheiro não suportado', badsize: 'O envio ficou incompleto', missing: 'O envio ficou incompleto',
      order: 'O envio foi interrompido', badchunk: 'O envio foi interrompido', toolong: 'A gravação é demasiado longa', nogroups: 'Os grupos não estão disponíveis neste servidor', internal: 'Erro no servidor',
      noplayer: 'Sessão do jogador não encontrada', rpc: 'Sem resposta do servidor' };
    const errText = (r, fb) => { const e = r && typeof r === 'object' ? r.error : null; const s = (e && ERR[e]) || fb; return AND && typeof s === 'string' ? s.replace(/\s+[\u2013\u2014]\s+/g, ', ') : s; };   /* Nova UI: sem travessões */
    const TICK = s => s === 'read' || s === 'delivered'
      ? `<svg class="msl-tick ${s === 'read' ? 'read' : ''}" viewBox="0 0 17 11"><path d="M1 6l3 3.2L10.5 2"/><path d="M8.2 9.2L15.5 2"/></svg>`
      : s === 'sent' ? '<svg class="msl-tick one" viewBox="0 0 12 11"><path d="M1 6l3 3.2L10.5 2"/></svg>' : '';
    const voiceOk = () => { try { return !!(window.VoiceMsg && typeof VoiceMsg.supported === 'function' && VoiceMsg.supported()); } catch (e) { return false; } };
    function seenText(p) {
      if (!p) return ''; if (p.online) return 'online'; if (!p.lastSeen) return '';
      const d = new Date(+p.lastSeen), n = new Date(), t = UI.fmtTime(d);
      if (d.toDateString() === n.toDateString()) return 'visto por último hoje às ' + t;
      const y = new Date(n); y.setDate(n.getDate() - 1);
      if (d.toDateString() === y.toDateString()) return 'visto por último ontem às ' + t;
      return 'visto por último a ' + UI.fmtDate(d, true) + ' às ' + t;
    }
    function paintMedia(el, mid) {
      const hit = Msgs.mediaCached(mid);
      if (hit) { if (/^data:image\//.test(hit.url)) { el.style.backgroundImage = UI.img(hit.url); el.classList.add('has-img'); } return; }
      Msgs.media(mid).then(r => { if (r && /^data:image\//.test(r.url)) { el.style.backgroundImage = UI.img(r.url); el.classList.add('has-img'); } });
    }
    function groupAvatar(mid, size) { const a = UI.el(`<div class="avatar msg-gav ${size || ''}">${g('users')}</div>`); if (+mid > 0) paintMedia(a, +mid); return a; }
    function groupInfo(id) {
      if (!window.Groups || typeof Groups.info !== 'function') { UI.toast('Informações do grupo indisponíveis'); return; }
      /* o M4 pode empurrar a vista ele próprio, devolvê-la ou devolver uma promessa que resolve ao fechar:
         os três casos servem; ao fechar volta a pedir-se a informação (nome, membros, saída) */
      const handle = x => { if (x && x.nodeType === 1) { if (x.classList.contains('view') && !x.isConnected) UI.push(win, x); } else Bridge.emit('groups:changed', { id }); };
      try { const out = Groups.info(win, id); if (out && typeof out.then === 'function') out.then(handle, () => {}); else handle(out); }
      catch (e) { console.error('[apex_phone] Groups.info', e); }
    }

    /* =====================================================================
       LISTA DE CONVERSAS
       ===================================================================== */
    const root = AND
      ? UI.view({ title: App.name('messages'), large: true, cls: 'amsg-list-view', right: [{ icon: 'moreV', onTap: b => listMenu(b) }] })
      : UI.view({ title: 'Mensagens', large: true, right: [{ icon: 'compose', onTap: () => composeMenu() }], left: [{ label: 'Editar', onTap: () => UI.toast('Desliza uma conversa para a esquerda ou mantém-na premida') }] });
    root.content.appendChild(UI.search(AND ? T('Pesquisar') : 'Pesquisar', q => { curQ = q; render(q); }));
    /* eSIM (js/apps/esim.js): "Sem SIM" com o botão de adicionar, ou o seletor da linha (2+ linhas, ponto azul quando outra tem por ler) */
    if (window.ESim && ESim.mount) ESim.mount(root.content, { app: 'messages', lineBar: true });   /* trocar de linha emite messages:changed: a lista refaz-se pelo `soon` lá em baixo */
    const holder = UI.el('<div></div>'); root.content.appendChild(holder);
    /* Nova UI: botão flutuante de escrever (em baixo à direita) e o menu ⋮ da lista */
    if (AND) {
      const fab = UI.el(`<div class="amsg-fab">${g('compose', 26)}</div>`); fab.onclick = () => composeMenu(); root.appendChild(fab);
    }
    function listMenu(b) {
      const items = [{ label: T('Nova mensagem'), icon: 'compose', onTap: () => compose() }];
      if (window.Groups && typeof Groups.create === 'function') items.push({ label: T('Novo grupo'), icon: 'users', onTap: () => newGroup() });
      items.push({ label: T('Marcar tudo como lido'), icon: 'checkCircle', onTap: () => readAll() });
      if (typeof blockedView === 'function') items.push({ label: T('Contactos bloqueados'), icon: 'ban', onTap: () => blockedView(win, App.name('messages')) });
      UI.ctxMenu(b, items);
    }
    /* o mesmo messages.read que abrir cada conversa faria, só para as que têm mensagens por ler */
    async function readAll() {
      const ts = threads || await fetchThreads();
      const un = (ts || []).filter(t => t && t.unread);
      if (!un.length) { UI.toast(T('Não há mensagens por ler')); return; }
      for (const t of un) { try { await Bridge.rpc('messages.read', targetOf(t)); } catch (e) {} }
      render(curQ, true); Msgs.badge();
    }
    /* ---------- conversas em cache ----------
       O filtro da pesquisa é feito AQUI, em JS - mas cada tecla pedia outra vez ao servidor a lista
       inteira. A lista só se pede quando pode ter mudado: ao abrir, ao voltar de uma conversa, ao
       apagar/fixar/silenciar e depois de chegar um SMS (`invalidate`). `seq` garante que uma resposta
       atrasada nunca pinta por cima de uma pesquisa mais recente. */
    let threads = null, loading = null, fetchId = 0, seq = 0;
    const presence = {};   /* número → { online, lastSeen } (só o que já se pediu; nada de polling) */
    const fetchThreads = () => { if (loading) return loading; const id = ++fetchId;
      return (loading = Bridge.rpc('messages.threads', { app: 'sms' }).catch(() => null).then(r => {
        /* {} do FiveM = "sem conversas"; um null (erro ou timeout) NÃO fica em cache - a tecla seguinte volta a tentar */
        const ts = Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error ? Msgs.arr(r) : null);
        if (ts) {
          Msgs.remember(ts);
          ts.forEach(t => { if (t && t.number && !t.group && (t.online !== undefined || t.lastSeen !== undefined)) presence[t.number] = { online: !!t.online, lastSeen: +t.lastSeen || 0 }; });
        }
        if (id === fetchId) { threads = ts; loading = null; }   /* um pedido invalidado a meio não escreve */
        return ts || [];
      })); };
    const invalidate = () => { threads = null; loading = null; fetchId++; };
    const nameOf = t => t.group ? (t.group.title || t.name || 'Grupo') : (t.name || Contacts.name(t.number));
    const targetOf = t => t.group ? { conversation: Math.floor(+t.group.id), app: 'sms' } : { number: t.number, app: 'sms' };
    const openIt = t => openThread(t.group ? { conversation: Math.floor(+t.group.id), name: nameOf(t) } : { number: t.number, name: nameOf(t) });
    function avatarOf(t, size) {
      if (t.group) return groupAvatar(t.group.avatar, size);
      const c = Contacts.byNumber(t.number);
      /* Nova UI: as mesmas cores do Telefone (e a silhueta para números desconhecidos) */
      if (AND) return PhoneDroid.avatar(c || null, c ? c.name : (t.name || ''), '', false);
      return UI.el(UI.avatar(c || { name: nameOf(t) }, size));
    }

    async function render(q, reload, askPresence) {
      const my = ++seq;
      if (reload) invalidate();
      const ts = threads || await fetchThreads();
      if (my !== seq || winDead) return;
      openRow = null; holder.innerHTML = '';
      const me = System.player.phone;
      const all = ts.filter(Boolean).slice().sort((a, b) => (+b.ts || 0) - (+a.ts || 0));
      const list = all.filter(t => !q || nameOf(t).toLowerCase().includes(q) || String(t.number || '').includes(q));
      System.badge('messages', ts.reduce((a, x) => a + ((x && x.unread) || 0), 0));
      if (AND) {
        /* Nova UI: "N mensagens por ler" por baixo do título; as fixadas no topo da MESMA lista (com o alfinete), num cartão */
        const un = ts.reduce((a, x) => a + ((x && x.unread) || 0), 0);
        PhoneDroid.ltSub(root, un ? PhoneDroid.plural(un, '1 mensagem por ler', 'mensagens por ler') : '');
        if (!list.length) { holder.appendChild(q ? UI.empty('search', T('Sem resultados'), T('Nenhuma conversa corresponde à pesquisa.')) : UI.empty('message', T('Sem mensagens'), T('Toca no botão de escrever para começar uma conversa.'))); return; }
        const box = UI.el('<div class="msl-list amsg-card"></div>');
        (q ? list : list.filter(t => t.pinned).concat(list.filter(t => !t.pinned))).forEach(t => box.appendChild(row(t, me)));
        holder.appendChild(box);
        if (askPresence) askPres(list);
        return;
      }
      if (!list.length) { holder.appendChild(q ? UI.empty('search', 'Sem resultados', 'Nenhuma conversa corresponde à pesquisa.') : UI.empty('message', 'Sem mensagens', 'Toca no ícone para escrever.')); return; }
      /* fixadas em grelha no topo (como no PearOS); a pesquisar mostra-se tudo numa lista só */
      const pinned = q ? [] : list.filter(t => t.pinned), rest = q ? list : list.filter(t => !t.pinned);
      if (pinned.length) { const grid = UI.el('<div class="msl-pins"></div>'); pinned.forEach(t => grid.appendChild(pinTile(t, me))); holder.appendChild(grid); }
      if (rest.length) { const box = UI.el('<div class="msl-list"></div>'); rest.forEach(t => box.appendChild(row(t, me))); holder.appendChild(box); }
      paintSel();
      if (askPresence) askPres(list);
    }
    /* PearPhone Fold (lista | conversa, UI.split): a conversa aberta à direita fica marcada na lista, também depois de repintar */
    function paintSel() {
      holder.querySelectorAll('.split-sel').forEach(x => x.classList.remove('split-sel'));
      if (!win.classList.contains('split-on')) return;
      const cur = Msgs.current, k = cur && cur.win === win && cur.isDead && !cur.isDead() ? cur.key : '';
      if (k) holder.querySelectorAll('[data-k]').forEach(r => { if (r.dataset.k === k) (r.querySelector('.msl-main') || r).classList.add('split-sel'); });
    }
    /* ---------- presença: SÓ dos números que estão na lista, ao abrir e ao voltar ----------
       O servidor não difunde presença a ninguém; é a lista que pergunta, uma vez, por até 40 números. */
    let presSeq = 0;
    async function askPres(list) {
      const nums = [];
      list.forEach(t => { if (t && !t.group && t.number && nums.length < 40 && !nums.includes(String(t.number))) nums.push(String(t.number)); });
      if (!nums.length) return;
      const my = ++presSeq;
      let r = null; try { r = await Bridge.rpcRaw('presence.get', { numbers: nums }); } catch (e) { r = null; }
      if (my !== presSeq || winDead || !r || typeof r !== 'object' || r.error) return;
      nums.forEach(n => { const p = r[n]; if (p && typeof p === 'object') presence[n] = { online: !!p.online, lastSeen: +p.lastSeen || 0 }; });
      holder.querySelectorAll('[data-num]').forEach(e => { const p = presence[e.dataset.num]; e.classList.toggle('online', !!(p && p.online)); });
    }

    function row(t, me) {
      const k = Msgs.keyOf(t), last = t.last, muted = Msgs.isMuted(k);
      const el = UI.el(`<div class="msl-row"><div class="msl-acts"><div class="a pin">${g('pin')}<span>${t.pinned ? 'Desafixar' : 'Fixar'}</span></div><div class="a mute">${g(muted ? 'bell' : 'bellOff')}<span>${muted ? 'Alertas' : 'Silenciar'}</span></div><div class="a del">${g('trash')}<span>Apagar</span></div></div><div class="msl-main"><i class="msl-dot"></i><div class="msl-av"><i class="msl-on"></i></div><div class="msl-body"><div class="msl-top"><b></b><span class="msl-time"></span></div><div class="msl-sub"></div></div></div></div>`);
      const main = el.querySelector('.msl-main');
      el.dataset.k = k;   /* PearPhone Fold: a linha da conversa aberta ao lado fica marcada (paintSel) */
      if (!t.group && t.number) el.dataset.num = t.number;
      main.querySelector('.msl-av').prepend(avatarOf(t, ''));
      main.querySelector('b').textContent = nameOf(t);
      const tm = main.querySelector('.msl-time');
      if (muted) tm.appendChild(UI.el(`<span class="msl-mute">${g('bellOff')}</span>`));
      tm.appendChild(document.createTextNode(last ? UI.rel(last.created) : ''));
      const sub = main.querySelector('.msl-sub');
      if (last) {
        const mine = last.sender === me;
        /* ✓ enviada · ✓✓ entregue · ✓✓ azul lida - só da minha última */
        if (mine && t.lastStatus && !last.deleted) sub.insertAdjacentHTML('afterbegin', TICK(t.lastStatus));
        const who = mine ? 'Tu: ' : (t.group && last.type !== 'system' ? Contacts.name(last.sender) + ': ' : '');
        sub.appendChild(document.createTextNode(who + (Msgs.label(last) || '')));
      } else sub.textContent = t.group ? 'Grupo sem mensagens' : 'Sem mensagens';
      if (t.unread) el.classList.add('is-unread');
      if (!t.group && presence[t.number] && presence[t.number].online) el.classList.add('online');
      /* Nova UI: contador de por ler (em vez do ponto azul) e o alfinete das fixadas ao lado da hora */
      if (AND) {
        if (t.pinned) tm.insertBefore(UI.el(`<span class="amsg-pin">${g('pin')}</span>`), tm.firstChild);
        if (t.unread) { const bd = UI.el('<span class="amsg-badge"></span>'); bd.textContent = t.unread > 99 ? '99+' : String(t.unread); main.appendChild(bd); }
      }
      main.onclick = () => {
        if (Date.now() - (el._swiped || 0) < 350) return;          /* o fim de um deslize não abre a conversa */
        if (el.classList.contains('open')) { shut(el); return; }
        if (openRow && openRow !== el) { shut(openRow); return; }
        openIt(t);
      };
      UI.longPress(main, () => { shut(el); threadMenu(t, main); });
      el.querySelector('.a.pin').onclick = e => { e.stopPropagation(); shut(el); togglePin(t); };
      el.querySelector('.a.mute').onclick = e => { e.stopPropagation(); shut(el); muteMenu(t); };
      el.querySelector('.a.del').onclick = e => { e.stopPropagation(); shut(el); clearThread(t); };
      swipeable(el, main);
      return el;
    }
    function pinTile(t, me) {
      const el = UI.el('<div class="msl-pin"><div class="msl-pav"><i class="msl-on"></i></div><b></b></div>');
      el.dataset.k = Msgs.keyOf(t);
      el.querySelector('.msl-pav').prepend(avatarOf(t, 'lg'));
      el.querySelector('b').textContent = nameOf(t);
      if (t.unread) el.classList.add('is-unread');
      if (Msgs.isMuted(Msgs.keyOf(t))) el.classList.add('is-muted');
      if (!t.group && t.number) { el.dataset.num = t.number; if (presence[t.number] && presence[t.number].online) el.classList.add('online'); }
      el.onclick = () => openIt(t);
      UI.longPress(el, () => threadMenu(t, el));
      return el;
    }
    /* ---------- deslizar para a esquerda: Fixar · Silenciar · Apagar ----------
       Só transform no .msl-main (as ações ficam por baixo). Uma linha aberta de cada vez; o gesto só
       arranca na horizontal, para o scroll vertical da lista continuar a funcionar. */
    let openRow = null;
    const ACTS_W = 222;
    /* as ações só existem à vista com a linha aberta ou a deslizar (.drag): a linha tem fundo sólido, mas o
       :active usa um preenchimento translúcido e um simples toque deixava ver o laranja/roxo/vermelho por baixo.
       Ao fechar, o .drag fica até o deslize de volta acabar (0,3 s), para não abrir um buraco a meio. */
    function shut(el) {
      if (!el) return; el.classList.remove('open'); const m = el.querySelector('.msl-main'); if (m) { m.style.transition = ''; m.style.transform = ''; } if (openRow === el) openRow = null;
      clearTimeout(el._dragT); el._dragT = setTimeout(() => { if (!el.classList.contains('open')) el.classList.remove('drag'); }, 340);
    }
    function swipeable(el, main) {
      let sx = 0, sy = 0, base = 0, dx = 0, pid = null, drag = false;
      main.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; pid = e.pointerId; sx = e.clientX; sy = e.clientY; drag = false; base = el.classList.contains('open') ? -ACTS_W : 0; dx = base; });
      main.addEventListener('pointermove', e => {
        if (pid === null || e.pointerId !== pid) return;
        const z = (UI.vrect ? UI.zoom(main) : UI.zoom()) || 1, mx = (e.clientX - sx) / z, my = (e.clientY - sy) / z;   /* px da própria linha (o zoom do conteúdo no PearPhone Fold, ui.js) */
        if (!drag) {
          if (Math.abs(mx) > 10 && Math.abs(mx) > Math.abs(my) * 1.4) { drag = true; if (openRow && openRow !== el) shut(openRow); clearTimeout(el._dragT); el.classList.add('drag'); main.style.transition = 'none'; try { main.setPointerCapture(pid); } catch (x) {} }
          else { if (Math.abs(my) > 10) pid = null; return; }
        }
        dx = Math.max(-ACTS_W - 36, Math.min(0, base + mx));
        main.style.transform = `translateX(${dx.toFixed(1)}px)`;
      });
      const end = e => {
        if (pid === null || (e && e.pointerId !== pid)) return; pid = null;
        if (!drag) return; drag = false; el._swiped = Date.now(); main.style.transition = '';
        if (dx < -ACTS_W / 2.6) { el.classList.add('open'); main.style.transform = `translateX(${-ACTS_W}px)`; openRow = el; } else shut(el);
      };
      main.addEventListener('pointerup', end); main.addEventListener('pointercancel', end);
    }
    function threadMenu(t, anchor) {
      const muted = Msgs.isMuted(Msgs.keyOf(t)), nm = nameOf(t), items = [];
      if (t.group) items.push({ label: 'Informações do grupo', icon: 'info', onTap: () => groupInfo(Math.floor(+t.group.id)) });
      else items.push({ label: 'Ligar', icon: 'phone', onTap: () => PhoneApp.call(t.number, nm) });
      items.push({ label: t.pinned ? 'Desafixar' : 'Fixar', icon: 'pin', onTap: () => togglePin(t) });
      items.push({ label: muted ? 'Mostrar alertas' : 'Silenciar', icon: muted ? 'bell' : 'bellOff', onTap: () => muteMenu(t) });
      items.push({ label: 'Apagar conversa', icon: 'trash', danger: true, onTap: () => clearThread(t) });
      UI.ctxMenu(anchor, items);
    }
    async function setMeta(t, patch) {
      const r = await Bridge.rpcRaw('thread.set', Object.assign(targetOf(t), patch));
      if (!r || r.error || r.ok === false) { UI.toast(errText(r, 'Não foi possível guardar')); return false; }
      const k = Msgs.keyOf(t), cur = Msgs.meta.get(k) || {};
      Msgs.meta.set(k, { pinned: patch.pinned !== undefined ? !!patch.pinned : !!cur.pinned, mutedUntil: patch.mutedUntil !== undefined ? (+patch.mutedUntil || 0) : (+cur.mutedUntil || 0), pinnedMsg: patch.pinnedMsg !== undefined ? (+patch.pinnedMsg || 0) : (+cur.pinnedMsg || 0) });
      return true;
    }
    async function togglePin(t) {
      if (!t.pinned && (threads || []).filter(x => x && x.pinned).length >= 9) { UI.toast('Só podes fixar 9 conversas'); return; }
      if (await setMeta(t, { pinned: !t.pinned })) render(curQ, true);
    }
    async function muteMenu(t) {
      const k = Msgs.keyOf(t), muted = Msgs.isMuted(k), cur = Msgs.meta.get(k) || {};
      const buttons = muted ? [{ label: 'Mostrar alertas', icon: 'bell', value: 0 }] : [];
      buttons.push({ label: 'Silenciar 1 hora', value: 1 }, { label: 'Silenciar 8 horas', value: 8 }, { label: 'Silenciar sempre', value: -1 });
      /* o UI.rel é para o passado ("Ontem", "Seg"): um silêncio até amanhã às 03:00 aparecia como "até Seg" */
      const untilTxt = x => { const d = new Date(+x); return d.toDateString() === new Date().toDateString() ? UI.fmtTime(d) : UI.fmtDate(d, true) + ', ' + UI.fmtTime(d); };
      const title = muted ? (cur.mutedUntil >= FOREVER - 864e5 ? 'Alertas silenciados para sempre' : 'Alertas silenciados até ' + untilTxt(cur.mutedUntil)) : 'Silenciar alertas de ' + nameOf(t);
      const v = await UI.actionSheet({ title, buttons });
      if (v === null || v === undefined) return;
      /* 0 = reativar (um null em JSON chega ao Lua como nil = "não mexer") */
      const until = v === 0 ? 0 : v === -1 ? FOREVER : Date.now() + v * 3600e3;
      if (await setMeta(t, { mutedUntil: until })) { UI.toast(v === 0 ? 'Alertas ativados' : 'Alertas silenciados'); render(curQ, true); }
    }
    async function clearThread(t) {
      if (!await UI.confirm('Apagar conversa', 'A conversa desaparece só deste telemóvel. ' + (t.group ? 'Os outros membros continuam a vê-la.' : 'A outra pessoa continua a vê-la.'), 'Apagar', true)) return;
      /* um único messages.clear (antes era um messages.delete por mensagem - e só as enviadas, para os dois lados) */
      const r = await Bridge.rpcRaw('messages.clear', targetOf(t));
      if (!r || r.error || r.ok === false) { UI.toast(errText(r, 'Não foi possível apagar a conversa')); return; }
      render(curQ, true); Msgs.badge();
    }
    async function compose() { const c = await Contacts.pick('Nova mensagem'); if (c) openThread({ number: c.number, name: c.name }); }
    Msgs._compose = compose;
    async function composeMenu() {
      if (!window.Groups || typeof Groups.create !== 'function') { compose(); return; }
      const v = await UI.actionSheet({ buttons: [{ label: 'Nova mensagem', icon: 'compose', value: 'one' }, { label: 'Novo grupo', icon: 'users', value: 'group' }] });
      if (v === 'one') compose(); else if (v === 'group') newGroup();
    }
    async function newGroup() {
      let gr = null;
      try { gr = await Groups.create(win); } catch (e) { console.error('[apex_phone] Groups.create', e); gr = null; }
      const id = gr && Math.floor(+gr.id);
      if (!(id > 0) || winDead) return;
      Msgs.groups.set(id, Object.assign({}, Msgs.groups.get(id) || {}, gr));
      invalidate(); render(curQ);
      openThread({ conversation: id, name: gr.title || gr.name });
    }

    /* =====================================================================
       CONVERSA
       ===================================================================== */
    function openThread(target, nameArg) {
      if (typeof target !== 'object' || target === null) { const s = String(target == null ? '' : target); const gm = /^g:(\d+)$/.exec(s); target = gm ? { conversation: +gm[1] } : { number: s }; }
      const gid = Math.floor(+target.conversation) > 0 ? Math.floor(+target.conversation) : 0;
      const number = gid ? null : String(target.number == null ? '' : target.number);
      if (!gid && !number) return;
      const isGroup = !!gid, me = System.player.phone, C = Msgs.cfg();
      const key = isGroup ? 'g:' + gid : 'n:' + number;
      /* a MESMA conversa já está à frente (notificação dela tocada, "Mensagem" nas Informações do grupo, Vera):
         empilhar outra cópia duplicava ouvintes, "a escrever" e marcações de lida - desce-se só ao fim */
      { const cur = Msgs.current, stack = win.querySelector('.nav-stack');
        if (cur && cur.win === win && cur.key === key && cur.isDead && !cur.isDead() && stack && stack.lastElementChild === cur.view) { if (cur.toBottom) cur.toBottom(); return; } }
      const q = isGroup ? { conversation: gid, app: 'sms' } : { number, app: 'sms' };
      let title = target.name || nameArg || (isGroup ? Msgs.groupTitle(gid) : Contacts.name(number));
      const st = { msgs: new Map(), order: [], rows: new Map(), more: false, loaded: false, queue: [], loadP: null, replyTo: null, editing: null, typers: new Map(),
        pinnedMsg: 0, dead: false, unseen: false, recorder: null, members: {}, left: false, pendingStatus: new Map(), readUpTo: {} };
      const offs = [], prevApi = Msgs.current;
      const RANK = { sent: 1, delivered: 2, read: 3 };
      const right = isGroup ? [{ icon: 'info', onTap: () => groupInfo(gid) }] : [{ icon: 'phone', onTap: () => PhoneApp.call(number, title) }, { icon: 'video', onTap: () => PhoneApp.facetime(number, title) }];
      const v = UI.view({ title, back: 'Mensagens', full: true, solid: true, cls: 'msg-view', right, onPop: cleanup });

      /* ---------- cabeçalho: avatar + nome + online / visto por último / membros ---------- */
      const nbt = v.navbar.querySelector('.nb-title'); nbt.textContent = '';
      const head = UI.el('<div class="msg-head"><div class="msg-hav"></div><div class="msg-htx"><b></b><small></small></div></div>'); nbt.appendChild(head);
      const hName = head.querySelector('b'), hSub = head.querySelector('small'), hAv = head.querySelector('.msg-hav');
      const nameFor = s => st.members[s] || Contacts.name(s);
      function paintHead() {
        hName.textContent = title; hAv.innerHTML = '';
        if (isGroup) hAv.appendChild(groupAvatar((Msgs.groups.get(gid) || {}).avatar, 'xs'));
        else { const c = Contacts.byNumber(number); hAv.appendChild(AND ? PhoneDroid.avatar(c || null, c ? c.name : (title !== number ? title : ''), 'xs') : UI.el(UI.avatar(c || { name: title }, 'xs'))); }
      }
      function paintMembers() {
        if (!isGroup) return;
        const gi = Msgs.groups.get(gid) || {}; const ms = Array.isArray(gi.members) ? gi.members : Msgs.arr(gi.members);
        const names = ms.map(x => { const who = x && typeof x === 'object' ? x.member : x; if (!who) return null; return who === me ? 'Tu' : ((x && x.name) || nameFor(who)); }).filter(Boolean);
        hSub.textContent = names.length ? names.slice(0, 3).join(', ') + (names.length > 3 ? ` e mais ${names.length - 3}` : '') : '';
      }
      const setPresence = p => { if (isGroup) return; hSub.textContent = seenText(p); };
      /* "online" deduzido de uma mensagem ou do "a escrever" só se o servidor mostrou a presença desta pessoa: quem
         desligou "Mostrar visto por último" (settings.lastSeen) chega sem online nem lastSeen e assim continua */
      let presOk = false;
      const activeNow = () => { if (!isGroup && presOk) setPresence({ online: true }); };
      head.onclick = () => {
        if (isGroup) { groupInfo(gid); return; }
        const c = Contacts.byNumber(number);
        if (c && typeof contactDetail === 'function') contactDetail(win, c, 'Mensagem'); else if (typeof addContact === 'function') addContact(null, { number });
      };
      paintHead(); paintMembers();

      /* ---------- faixa da mensagem fixada ---------- */
      const pinBar = UI.el(`<div class="msg-pinbar hidden"><div class="pb-ic">${g('pin')}</div><div class="pb-tx"><b>Mensagem fixada</b><span></span></div><div class="pb-x">${g('x')}</div></div>`);
      v.insertBefore(pinBar, v.content);
      const thread = UI.el('<div class="thread msg-thread"></div>');
      const moreEl = UI.el('<div class="msg-more hidden"><span>Mensagens anteriores</span><i class="spinner"></i></div>');
      const sk = UI.el('<div class="msg-sk"><i></i><i class="me"></i><i></i><i class="me w"></i></div>');
      thread.append(moreEl, sk);
      const comp = UI.el(`<div class="composer msg-composer"><div class="replying hidden"><div class="rq"><b></b><span></span></div><span class="cancel">✕</span></div><div class="plus">${g('plus')}</div><input type="text" placeholder="Mensagem" maxlength="1000"><div class="mic">${g('mic')}</div><div class="send">${g('arrowUp')}</div><div class="msg-rec"></div><div class="msg-left hidden">Já não és membro deste grupo.</div></div>`);
      const inp = comp.querySelector('input'), bar = comp.querySelector('.replying'), micBtn = comp.querySelector('.mic');
      if (!voiceOk()) micBtn.classList.add('na');
      /* Nova UI: o campo diz "Mensagem" (como no PearOS, sem marcas); nos grupos as bolhas dos outros levam o avatar de quem escreveu */
      if (AND) { inp.placeholder = T('Mensagem'); comp.classList.add('amsg-comp'); v.classList.add('amsg-conv'); if (isGroup) v.classList.add('amsg-grp'); }
      let typingEl = null, typingT = null;
      /* as imagens das mensagens só descem quando se aproximam do ecrã (uma conversa com 30 fotos seriam
         150 pedidos de uma vez); sem IntersectionObserver descem logo */
      const io = 'IntersectionObserver' in window ? new IntersectionObserver(es => es.forEach(e => { if (e.isIntersecting) { io.unobserve(e.target); loadPic(e.target); } }), { root: v.content, rootMargin: '400px 0px' }) : null;

      const sc = v.content;
      const nearBottom = () => sc.scrollHeight - sc.scrollTop - sc.clientHeight < 160;
      const scrollBottom = () => { sc.scrollTop = 1e7; };
      const dayKey = m => new Date(+m.created).toDateString();
      const within = (m, min) => Date.now() - (+m.created || 0) <= min * 60000 + 60000;   /* +1 min de folga para o relógio do servidor; quem decide é ele */
      const isMineR = r => (r && r.who != null ? r.who === me : !!(r && r.mine));
      const upgrade = (m, s, at) => { if (!RANK[s] || (RANK[m.status] || 0) >= RANK[s]) return false; m.status = s; if (s === 'read' && at) m.readAt = +at; return true; };
      function norm(m) {
        m.id = +m.id;
        if (m.deleted || m.deleted_all) { m.deleted = true; m.content = ''; m.payload = null; }
        if (m.editedAt == null && m.edited_at) m.editedAt = m.edited_at;
        if (m.readAt == null && m.read_at) m.readAt = m.read_at;
        m.reactions = m.deleted ? [] : (Array.isArray(m.reactions) ? m.reactions : Msgs.arr(m.reactions));
        const ps = st.pendingStatus.get(m.id); if (ps) { upgrade(m, ps.status, ps.at); st.pendingStatus.delete(m.id); }
        return m;
      }
      /* Nova UI: o separador diz só o dia (a hora vai ao lado de cada grupo de bolhas) */
      const sepEl = m => { const d = new Date(+m.created); const e = UI.el('<div class="day-sep"></div>'); e.textContent = AND ? UI.fmtDate(d) : `${UI.fmtDate(d, true)} · ${UI.fmtTime(d)}`; return e; };
      /* hora ao lado da ÚLTIMA bolha de cada grupo (mesmo remetente, mesmo minuto) e cantos juntos nas seguidas: só classes, nada se refaz */
      const tKey = m => (m && m.type !== 'system') ? String(m.sender) + '|' + Math.floor((+m.created || 0) / 60000) : null;
      function clusterTimes() {
        if (!AND) return;
        for (let i = 0; i < st.order.length; i++) {
          const m = st.msgs.get(st.order[i]), r = st.rows.get(st.order[i]); if (!m || !r) continue;
          const n = st.msgs.get(st.order[i + 1]), p = st.msgs.get(st.order[i - 1]);
          r.classList.toggle('amsg-notm', !!(n && tKey(n) === tKey(m) && !n.deleted === !m.deleted));
          r.classList.toggle('amsg-cont', !!(p && m.type !== 'system' && p.type !== 'system' && p.sender === m.sender && dayKey(p) === dayKey(m) && (+m.created || 0) - (+p.created || 0) < 300000));
        }
      }
      function buildRows(list, prev) {
        const frag = document.createDocumentFragment();
        list.forEach(m => { if (!m) return; if (!prev || dayKey(prev) !== dayKey(m)) frag.appendChild(sepEl(m)); const r = rowFor(m, prev); st.rows.set(m.id, r); frag.appendChild(r); prev = m; });
        return frag;
      }
      const anchor = () => thread.querySelector(':scope > .pending') || typingEl || null;

      function rowFor(m, prev) {
        if (m.type === 'system') { const r = UI.el('<div class="msg-row sys"><div class="msg-sys"></div></div>'); r.firstElementChild.textContent = Msgs.sysText(m, nameFor); r.dataset.id = m.id; return r; }
        const mine = m.sender === me;
        const r = UI.el(`<div class="msg-row ${mine ? 'me' : 'them'}"></div>`); r.dataset.id = m.id;
        /* grupos: o nome de quem escreveu por cima da primeira bolha de cada sequência */
        if (isGroup && !mine && (!prev || prev.sender !== m.sender || prev.type === 'system' || dayKey(prev) !== dayKey(m))) { const n = UI.el('<div class="msg-from"></div>'); n.textContent = nameFor(m.sender); r.appendChild(n);
          if (AND) { const c = Contacts.byNumber(m.sender), nm = nameFor(m.sender); const a = PhoneDroid.avatar(c || null, c ? c.name : (/^[\d\s+\-()#*]+$/.test(String(nm)) ? '' : nm), 'amsg-gav'); r.appendChild(a); } }
        const rq = !m.deleted && m.replyTo && typeof m.replyTo === 'object' && m.replyTo.id ? m.replyTo : null;
        if (rq) {
          /* a citação fica POR CIMA da bolha (fora dela): numa foto, localização ou contacto não cabe lá dentro */
          const qo = UI.el(`<div class="msg-qo">${g('reply')}<div><b></b><span></span></div></div>`);
          qo.dataset.rid = rq.id;
          const orig = st.msgs.get(+rq.id);
          qo.querySelector('b').textContent = rq.sender ? (rq.sender === me ? 'Tu' : nameFor(rq.sender)) : 'Resposta';
          /* o servidor manda replyTo.deleted quando a original foi apagada para todos (preview vazio) */
          qo.querySelector('span').textContent = rq.deleted || (orig && orig.deleted) ? 'Mensagem apagada' : (rq.preview || (orig ? Msgs.label(orig) : '') || 'Mensagem');
          qo.onclick = e => { e.stopPropagation(); jumpTo(+rq.id); };
          r.appendChild(qo);
        }
        const b = bubble(m, mine); r.appendChild(b);
        if (m.editedAt && !m.deleted) r.appendChild(UI.el('<div class="msg-edited">Editada</div>'));
        const rx = reactsEl(m); if (rx) r.appendChild(rx);
        UI.longPress(b, () => ctx(m, b));
        return r;
      }
      /* Nova UI: a hora fica ao lado da bolha (fora dela, sem receber toques); o clusterTimes esconde-a nas do meio */
      function stampTime(b, m) { if (!AND) return; const t = document.createElement('span'); t.className = 'amsg-tm'; t.textContent = UI.fmtTime(new Date(+m.created || Date.now())); b.appendChild(t); }
      function bubble(m, mine) {
        const p = m.payload || {};
        if (m.deleted) { const d = UI.el(`<div class="bubble ${mine ? 'me' : 'them'} deleted">${g('ban')}<span>${mine ? 'Apagaste esta mensagem' : 'Esta mensagem foi apagada'}</span></div>`); d.dataset.id = m.id; stampTime(d, m); return d; }
        const appId = m.type === 'app' ? Msgs.sharedApp(p) : null;
        let inner = '';
        if (typeof p.replyTo === 'string' && p.replyTo) inner += `<div class="reply">${UI.esc(p.replyTo.slice(0, 80))}</div>`;   /* respostas antigas (texto no payload) */
        if (m.type === 'image') inner += '<div class="pic"></div>';   /* o fundo vai pelo CSSOM, logo abaixo */
        else if (m.type === 'audio') inner += '<div class="msg-audio"></div>';
        else if (m.type === 'location') inner += `<div class="mapmini"><svg viewBox="0 0 26 34"><path d="M13 0C5.8 0 0 5.8 0 13c0 9.6 13 21 13 21s13-11.4 13-21C26 5.8 20.2 0 13 0z" fill="#FF3B30"/><circle cx="13" cy="13" r="5" fill="#fff"/></svg></div><div class="lt">${UI.esc(p.label || 'Localização')}</div>`;
        else if (m.type === 'contact') inner += `${UI.avatar({ name: p.name || '?' }, 'sm')}<div><div style="font-weight:600">${UI.esc(p.name || '')}</div><div style="font-size:var(--t-foot);opacity:.7">${UI.esc(p.number || '')}</div></div>`;
        else if (appId) inner += `<div class="tile">${Icons.tile(appId)}</div><div><div style="font-weight:600">${UI.esc(App.name(appId))}</div><div class="ab">${System.isInstalled(appId) ? 'Abrir' : (AND ? UI.esc('Ver na ' + App.name('appstore')) : 'Ver na AppShop')}</div></div>`;
        else inner += UI.esc(m.content);
        const cls = m.type === 'image' ? 'img' : m.type === 'location' ? 'loc' : m.type === 'contact' ? 'ct' : appId ? 'app' : m.type === 'audio' ? 'audio' : '';
        const b = UI.el(`<div class="bubble ${mine ? 'me' : 'them'} ${cls}">${inner}</div>`);
        b.dataset.id = m.id;   /* o push messageDeleted remove a bolha por id */
        stampTime(b, m);
        if (m.type === 'image') paintPic(b.querySelector('.pic'), m);
        if (m.type === 'audio') mountAudio(b.querySelector('.msg-audio'), m);
        b.onclick = () => {
          if (appId) { if (System.isInstalled(appId)) System.openApp(appId); else { System.openApp('appstore'); UI.toast(AND ? `Procura "${App.name(appId)}" na ${App.name('appstore')}` : `Procura "${App.name(appId)}" na AppShop`); } return; }
          if (m.type === 'location') { System.openApp('maps'); setTimeout(() => window.Maps && Maps.showAt(p), 300); }
          else if (m.type === 'contact') { if (typeof addContact === 'function') addContact(null, { name: p.name, number: p.number }); }
          else if (m.type === 'image') { const pic = b.querySelector('.pic'); if (pic && pic.classList.contains('failed')) loadPic(pic); else viewer(m); }
        };
        return b;
      }
      /* ---------- imagens: mediaId (Fase 2) ou o url/seed antigo ---------- */
      const midOf = m => Math.floor(+((m.payload && m.payload.mediaId) || m.mediaId)) || 0;
      function paintPic(pic, m) {
        const p = m.payload || {}, mid = midOf(m);
        /* a foto é um data: URL de centenas de KB: pelo CSSOM é só uma atribuição (dentro da string de HTML atravessava o parser) */
        if (!mid) { pic.style.backgroundImage = UI.img(p.url || p.seed); return; }
        const hit = Msgs.mediaCached(mid);
        if (hit) { pic.style.backgroundImage = UI.img(hit.url); return; }
        pic._mid = mid; pic.classList.add('loading');
        if (io) io.observe(pic); else loadPic(pic);
      }
      function loadPic(pic) {
        const mid = pic._mid; if (!mid || pic._busy) return;
        pic._busy = true; pic.classList.remove('failed'); pic.classList.add('loading');
        Msgs.media(mid).then(r => { pic._busy = false; pic.classList.remove('loading'); if (r && /^data:image\//.test(r.url)) { pic.style.backgroundImage = UI.img(r.url); pic._mid = 0; } else pic.classList.add('failed'); });
      }
      function mountAudio(host, m) {
        const p = m.payload || {};
        if (window.VoiceMsg && typeof VoiceMsg.player === 'function') {
          try { const el = VoiceMsg.player({ mediaId: midOf(m), duration: p.duration, waveform: Array.isArray(p.waveform) ? p.waveform : [] }); if (el && el.nodeType === 1) { host.appendChild(el); return; } }
          catch (e) { console.error('[apex_phone] VoiceMsg.player', e); }
        }
        /* sem o leitor (M4) diz-se o que é, em vez de uma bolha vazia */
        host.classList.add('na'); host.innerHTML = `${g('mic')}<span></span>`;
        const t = Msgs.durTxt(p.duration); host.querySelector('span').textContent = 'Mensagem de voz' + (t ? ' · ' + t : '');
      }
      function viewer(m) {
        const p = m.payload || {}, mid = midOf(m);
        const vw = UI.el(`<div class="viewer"><div class="vimg"><div></div></div><div class="vbar"><div class="cl">${g('x')}</div><div class="sv">${g('download')}</div></div></div>`);
        const im = vw.querySelector('.vimg > div');
        let url = mid ? null : (p.url || null);
        if (mid) { const hit = Msgs.mediaCached(mid); if (hit) url = hit.url; else { im.classList.add('msg-loading'); Msgs.media(mid, true).then(r => { im.classList.remove('msg-loading'); if (r && /^data:image\//.test(r.url)) { url = r.url; im.style.backgroundImage = UI.img(url); } }); } }
        im.style.backgroundImage = UI.img(url || (mid ? null : p.seed));
        vw.querySelector('.cl').onclick = () => vw.remove();
        vw.querySelector('.sv').onclick = async () => { if (mid && !url) { UI.toast('A imagem ainda está a carregar'); return; } await saveToPhotos(url, p.seed); vw.remove(); };
        win.appendChild(vw);
      }
      /* a foto sobe aos bocados (Photos.save): o photos.add com o base64 inteiro falhava acima de 48 KB */
      async function saveToPhotos(url, seed) {
        let r = null;
        try { r = url ? await Photos.save(url) : await Bridge.rpcRaw('photos.add', { seed }); } catch (e) { r = null; }
        if (r && !r.error) { try { await Photos.load(); Bridge.emit('photos'); } catch (e) {} UI.toast(AND ? 'Guardada na ' + App.name('photos') : 'Guardada em Fotos'); } else UI.toast('Não foi possível guardar a foto');
      }
      async function saveImage(m) {
        const p = m.payload || {}, mid = midOf(m);
        if (!mid) { await saveToPhotos(p.url || null, p.seed); return; }
        const r = await Msgs.media(mid, true);
        if (!r) { UI.toast('A imagem não está disponível'); return; }
        await saveToPhotos(r.url);
      }

      /* ---------- reações ---------- */
      function reactsEl(m) {
        const list = (m.reactions || []).filter(r => r && typeof r.emoji === 'string');
        if (!list.length || m.deleted) return null;
        const by = new Map();
        list.forEach(r => { const o = by.get(r.emoji) || { emoji: r.emoji, n: 0, mine: false }; o.n++; if (isMineR(r)) o.mine = true; by.set(r.emoji, o); });
        const box = UI.el('<div class="msg-reacts"></div>');
        by.forEach(o => { const c = UI.el('<span class="msg-rc"></span>'); c.textContent = o.emoji + (o.n > 1 ? ' ' + o.n : ''); if (o.mine) c.classList.add('mine'); c.onclick = e => { e.stopPropagation(); react(m, o.mine ? null : o.emoji); }; box.appendChild(c); });
        return box;
      }
      function paintReacts(m) {
        const r = st.rows.get(m.id); if (!r) return;
        const old = r.querySelector(':scope > .msg-reacts'); if (old) old.remove();
        const nx = reactsEl(m); if (nx) r.insertBefore(nx, r.querySelector(':scope > .msg-status'));
      }
      async function react(m, emoji) {
        const r = await Bridge.rpcRaw('messages.react', { id: m.id, emoji: emoji || null });
        if (!r || r.error || r.ok === false) { UI.toast(errText(r, 'Não foi possível reagir')); return; }
        if (r.reactions && typeof r.reactions === 'object') m.reactions = Msgs.arr(r.reactions);
        else { m.reactions = (m.reactions || []).filter(x => !isMineR(x)); if (emoji) m.reactions.push({ emoji, who: me, mine: true }); }
        paintReacts(m); if (emoji) Sound.play('pop');
      }
      /* a fila de reações por cima do menu de contexto (dentro da mesma camada, fecha com ele) */
      function reactBar(m, close) {
        const wraps = UI.screen().querySelectorAll('.ctx-wrap.msg-ctx'); const wrap = wraps[wraps.length - 1]; if (!wrap) return;
        const menu = wrap.querySelector('.ctx'); if (!menu) return;
        const cur = (m.reactions || []).find(isMineR);
        const rb = UI.el('<div class="msg-rbar"></div>');
        C.reactions.forEach(e => { const s = document.createElement('span'); s.textContent = e; if (cur && cur.emoji === e) s.classList.add('on'); s.onclick = ev => { ev.stopPropagation(); close(); react(m, cur && cur.emoji === e ? null : e); }; rb.appendChild(s); });
        rb.onclick = ev => ev.stopPropagation();
        wrap.appendChild(rb);
        const top = parseFloat(menu.style.top) || 200, left = parseFloat(menu.style.left) || 20, mh = menu.offsetHeight || 0, bw = rb.offsetWidth || 290;
        let y = top - 62; if (y < 64) y = top + mh + 10;
        rb.style.top = y + 'px'; rb.style.left = Math.max(10, Math.min(left, ((window.System && System.SW) || 440) - 10 - bw)) + 'px';   /* SW: 880 no PearPhone Fold aberto */
      }

      /* ---------- menu da bolha ---------- */
      function textOf(m) {
        if (m.deleted) return ''; const p = m.payload || {};
        if ((m.type || 'text') === 'text') return m.content || '';
        if (m.type === 'contact') return [p.name, p.number].filter(Boolean).join(' ');
        if (m.type === 'location') return (p.label || 'Localização') + (p.x != null && p.y != null ? ` (${Math.round(+p.x)}, ${Math.round(+p.y)})` : '');
        if (m.type === 'app' && Msgs.sharedApp(p)) return App.name(Msgs.sharedApp(p));
        return '';
      }
      function ctx(m, b) {
        if (st.dead) return;
        const mine = m.sender === me, gone = !!m.deleted, txt = textOf(m), items = [];
        if (!gone && !st.left) items.push({ label: 'Responder', icon: 'reply', onTap: () => setReply(m) });
        if (txt) items.push({ label: 'Copiar', icon: 'copy', onTap: () => Msgs.copy(txt) });
        if (!gone && mine && (m.type || 'text') === 'text' && within(m, C.editWindowMin)) items.push({ label: 'Editar', icon: 'pen', onTap: () => setEdit(m) });
        /* quem saiu do grupo já não passa na verificação de membro do servidor (thread.set / messages.delete dão
           notmember/notfound): Fixar e Apagar deixam de aparecer, em vez de falharem */
        if (!gone && !st.left) items.push({ label: st.pinnedMsg === m.id ? 'Desafixar' : 'Fixar', icon: 'pin', onTap: () => pinMsg(st.pinnedMsg === m.id ? 0 : m.id) });
        if (!gone) items.push({ label: 'Reencaminhar', icon: 'forward', onTap: () => forward(m) });
        if (!gone && m.type === 'image') items.push({ label: AND ? 'Guardar na ' + App.name('photos') : 'Guardar em Fotos', icon: 'download', onTap: () => saveImage(m) });
        /* num grupo, a mensagem de outro membro não se apaga "só para mim": a linha é partilhada por todos
           (o servidor responde unsupported) - a opção nem aparece, em vez de falhar */
        if (!(isGroup && !mine) && !st.left) items.push({ label: 'Apagar', icon: 'trash', danger: true, onTap: () => removeMsg(m) });
        const close = UI.ctxMenu(b, items, { cls: 'msg-ctx' });
        if (!gone && !st.left) reactBar(m, close);
      }
      async function forward(m) {
        if (!Msgs.netOk('reencaminhar a mensagem')) return;   /* antes de escolher o contacto: não se pede um destino para depois recusar */
        const c = await Contacts.pick('Reencaminhar para'); if (!c) return;
        const p = m.payload || null, mid = midOf(m);
        const d = { to: c.number, type: m.type || 'text', content: m.content, payload: p, app: 'sms' }; if (mid) d.mediaId = mid;
        const r = await Bridge.rpcRaw('messages.send', d);
        if (r && !r.error && r.id != null) { UI.toast('Reencaminhada'); if (!isGroup && String(c.number) === number && !st.dead) append(r); Bridge.emit('messages:changed'); }
        else UI.toast(errText(r, 'Não foi possível reencaminhar'));
      }
      async function removeMsg(m) {
        const canAll = m.sender === me && !m.deleted && within(m, C.deleteForAllMin);
        const buttons = []; if (canAll) buttons.push({ label: 'Apagar para todos', value: 'all', danger: true });
        buttons.push({ label: 'Apagar para mim', value: 'me', danger: true });
        const scope = await UI.actionSheet({ title: canAll ? '' : 'A mensagem desaparece só deste telemóvel.', buttons });
        if (scope !== 'all' && scope !== 'me') return;
        const r = await Bridge.rpcRaw('messages.delete', { id: m.id, scope });
        if (r && !r.error && r.ok !== false) { if (scope === 'me') removeRow(m.id); else applyUpdate({ id: m.id, deleted: true }); Bridge.emit('messages:changed'); }
        else UI.toast(errText(r, 'Não foi possível apagar'));
      }
      async function pinMsg(id) {
        const r = await Bridge.rpcRaw('thread.set', Object.assign({ pinnedMsg: id || 0 }, q));
        if (!r || r.error || r.ok === false) { UI.toast(errText(r, 'Não foi possível fixar')); return; }
        st.pinnedMsg = +id || 0;
        Msgs.meta.set(key, Object.assign({ pinned: false, mutedUntil: 0 }, Msgs.meta.get(key) || {}, { pinnedMsg: st.pinnedMsg }));
        paintPin(); if (id) UI.toast('Mensagem fixada');
      }
      function paintPin() {
        const id = st.pinnedMsg;
        if (!id) { pinBar.classList.add('hidden'); return; }
        const m = st.msgs.get(id); pinBar.classList.remove('hidden');
        pinBar.querySelector('.pb-tx span').textContent = m ? (m.deleted ? 'Mensagem apagada' : (isGroup && m.sender !== me ? nameFor(m.sender) + ': ' : '') + (Msgs.label(m) || '')) : 'Toca para ver a mensagem';
      }
      pinBar.querySelector('.pb-tx').onclick = () => { if (st.pinnedMsg) jumpTo(st.pinnedMsg); };
      pinBar.querySelector('.pb-ic').onclick = () => { if (st.pinnedMsg) jumpTo(st.pinnedMsg); };
      pinBar.querySelector('.pb-x').onclick = () => pinMsg(0);
      /* salta para uma mensagem (citação, faixa fixada); se for mais antiga do que o que está carregado, pagina para trás */
      async function jumpTo(id) {
        id = +id; let tries = 0;
        while (!st.rows.has(id) && st.more && tries < 10 && !st.dead) { await loadOlder(); tries++; }
        const r = st.rows.get(id);
        if (!r) { UI.toast('A mensagem já não está disponível'); return; }
        /* posição pela diferença dos retângulos (px do ecrã ÷ zoom): o offsetTop contava a partir da vista inteira
           (navbar e faixa fixada incluídas) e a mensagem ficava fora do centro */
        /* (px reais nos dois motores, ui.js UI.vrect, e o zoom da própria conversa: o do conteúdo no PearPhone Fold) */
        const R = UI.vrect || (n => n.getBoundingClientRect()), z = (UI.vrect ? UI.zoom(sc) : UI.zoom()) || 1;
        sc.scrollTop = Math.max(0, sc.scrollTop + (R(r).top - R(sc).top) / z - sc.clientHeight / 2 + r.offsetHeight / 2);
        r.classList.remove('flash'); void r.offsetWidth; r.classList.add('flash'); setTimeout(() => r.classList.remove('flash'), 1000);
      }

      /* ---------- atualizações que chegam por push ---------- */
      /* leitores de áudio (M4) que saem do DOM: sem destroy() o áudio continuava a tocar até o varrimento do
         VoiceMsg dar pela falta (2 × 4 s) - fechar a conversa ou apagar a mensagem não calava a voz */
      const dropPlayers = el => { if (el) el.querySelectorAll('.vmsg-player').forEach(p => { try { if (p.vmsg) p.vmsg.destroy(); } catch (e) {} }); };
      function rerender(id) {
        const old = st.rows.get(id), m = st.msgs.get(id); if (!old || !m) return;
        const i = st.order.indexOf(id), prev = i > 0 ? st.msgs.get(st.order[i - 1]) : null;
        const nr = rowFor(m, prev);
        /* uma mensagem de voz repintada (nome do remetente, reação) fica com o MESMO leitor: não pára a meio nem volta a descer o áudio */
        const oldAudio = !m.deleted && old.querySelector(':scope > .bubble.audio > .msg-audio'), newAudio = oldAudio && nr.querySelector(':scope > .bubble.audio > .msg-audio');
        if (oldAudio && newAudio) { dropPlayers(newAudio); newAudio.replaceWith(oldAudio); } else dropPlayers(old);
        old.replaceWith(nr); st.rows.set(id, nr);
        refreshStatus();
      }
      function rebuild() {
        [...thread.children].forEach(c => { if (c !== moreEl && c !== typingEl && !c.classList.contains('pending')) c.remove(); });
        st.rows.clear();
        thread.insertBefore(buildRows(st.order.map(i => st.msgs.get(i)), null), anchor());
        refreshStatus();
      }
      function append(m, incoming, seen) {
        if (!m || m.id == null || st.dead) return;
        if (!st.loaded) { st.queue.push([m, incoming, seen]); return; }
        const id = +m.id; if (st.msgs.has(id)) return;
        norm(m);
        if (incoming) { st.typers.delete(String(m.sender)); paintTyping(); if (m.sender !== me) activeNow(); if (seen === false) st.unseen = true; }
        const near = nearBottom();
        const lastId = st.order.length ? st.order[st.order.length - 1] : null;
        st.msgs.set(id, m);
        /* a resposta do outro pode chegar por push ANTES da resposta do meu próprio envio (id menor):
           nesse caso a ordem refaz-se, em vez de a minha mensagem ficar depois da dele */
        if (lastId !== null && id < lastId) { st.order.push(id); st.order.sort((a, b) => a - b); rebuild(); }
        else { st.order.push(id); thread.insertBefore(buildRows([m], lastId !== null ? st.msgs.get(lastId) : null), anchor()); refreshStatus(); }
        if (st.pinnedMsg === id) paintPin();
        if (!incoming || near) scrollBottom();
      }
      function removeRow(id) {
        id = +id; const r = st.rows.get(id);
        if (!r) { const b = thread.querySelector(`.bubble[data-id="${CSS.escape(String(id))}"]`); if (b) (b.closest('.msg-row') || b).remove(); return; }
        const before = r.previousElementSibling, after = r.nextElementSibling;
        dropPlayers(r); r.remove(); st.rows.delete(id); st.msgs.delete(id); st.order = st.order.filter(x => x !== id);
        const isSep = e => !!(e && e.classList.contains('day-sep'));
        if (isSep(before) && (!after || isSep(after) || after === typingEl || after.classList.contains('pending'))) before.remove();
        if (isGroup && after && after.dataset && after.dataset.id) rerender(+after.dataset.id);   /* o nome do remetente seguinte pode passar a ser preciso */
        refreshStatus();
        if (st.pinnedMsg === id) { st.pinnedMsg = 0; paintPin(); }
      }
      function applyUpdate(d) {
        const m = st.msgs.get(+d.id); if (!m) return;
        if (d.deleted) {
          m.deleted = true; m.content = ''; m.payload = null; m.reactions = []; m.editedAt = null;
          thread.querySelectorAll('.msg-qo').forEach(x => { if (+x.dataset.rid === m.id) x.querySelector('span').textContent = 'Mensagem apagada'; });
          if ((st.replyTo && st.replyTo.id === m.id) || (st.editing && st.editing.id === m.id)) clearBar();
        } else {
          if (typeof d.content === 'string') { m.content = d.content; m.editedAt = +d.editedAt || m.editedAt || Date.now(); }
          else if (d.editedAt != null) m.editedAt = +d.editedAt;
          if (d.payload && typeof d.payload === 'object') m.payload = d.payload;
        }
        rerender(m.id); if (st.pinnedMsg === m.id) paintPin();
      }
      /* membros ativos do grupo menos eu (a cache aceita { member } do servidor ou só números do groups:changed) */
      const otherMembers = () => { const gi = Msgs.groups.get(gid) || {}; return Msgs.arr(gi.members).map(x => (x && typeof x === 'object' ? x.member : x)).filter(x => typeof x === 'string' && x && x !== me); };
      /* Recibos do grupo que o push sozinho não resolve: o push só diz até onde leu QUEM acabou de ler. Um membro
         que leu antes de eu abrir a conversa nunca mais manda push para essa mensagem, e a minha última ficava em
         "Entregue" para sempre, mesmo depois de o último membro a ler. Nesse caso pergunta-se ao servidor (que conhece
         o last_read_id de todos) o estado da última página - um único messages.get, juntando pushes seguidos. */
      let grpStatusT = null;
      function groupStatusSoon() {
        if (!isGroup || st.dead) return;
        clearTimeout(grpStatusT);
        grpStatusT = setTimeout(() => {
          grpStatusT = null; if (st.dead || !st.loaded) return;
          Promise.resolve(Bridge.rpcRaw('messages.get', Object.assign({ limit: C.pageSize }, q))).then(r => {
            if (st.dead) return; let changed = false;
            Msgs.arr(r).forEach(x => { const m = x && st.msgs.get(+x.id); if (m && m.sender === me && RANK[x.status] && upgrade(m, x.status, x.readAt)) changed = true; });
            if (changed) refreshStatus();
          }).catch(() => {});
        }, 900);
      }
      function applyStatus(d) {
        const s = String(d.status || ''); if (!RANK[s]) return;
        const ids = (Array.isArray(d.ids) ? d.ids : (d.ids && typeof d.ids === 'object' ? Object.values(d.ids) : (d.id != null ? [d.id] : []))).map(Number).filter(Boolean);
        let changed = false;
        const c = Math.floor(+d.conversation) || 0;
        if (c) {
          /* grupo: o push diz que UM membro (`who`) leu até `upTo`. A minha só fica "Lida" quando todos os
             outros membros ativos conhecidos já leram até ela; até lá, fica pelo menos "Entregue". */
          if (!isGroup || c !== gid) return;
          if (s === 'read' && d.who) {
            const upTo = Math.floor(+d.upTo) || (ids.length ? Math.max(...ids) : 0);
            st.readUpTo[String(d.who)] = Math.max(st.readUpTo[String(d.who)] || 0, upTo);
            const others = otherMembers();
            const minRead = others.length && others.every(x => st.readUpTo[x]) ? Math.min(...others.map(x => st.readUpTo[x])) : 0;
            let pending = false;
            st.order.forEach(id => { const m = st.msgs.get(id); if (!m || m.sender !== me || m.deleted) return; if (minRead && id <= minRead) { if (upgrade(m, 'read', d.at)) changed = true; } else { if (id <= upTo && upgrade(m, 'delivered')) changed = true; if (id <= upTo && m.status !== 'read') pending = true; } });
            if (pending) groupStatusSoon();
          } else ids.forEach(id => { const m = st.msgs.get(id); if (m && upgrade(m, s === 'read' ? 'delivered' : s, d.at)) changed = true; });
          if (changed) refreshStatus();
          return;
        }
        ids.forEach(id => { const m = st.msgs.get(id); if (m) { if (upgrade(m, s, d.at)) changed = true; } else if (st.pendingStatus.size < 200) st.pendingStatus.set(id, { status: s, at: d.at }); });
        /* "lida" numa das minhas vale para as minhas anteriores desta conversa (o servidor pode mandar só as novas) */
        if (s === 'read' && ids.some(id => st.msgs.has(id))) { const maxId = Math.max(...ids); st.order.forEach(id => { const m = st.msgs.get(id); if (m && m.sender === me && id <= maxId && upgrade(m, 'read', d.at)) changed = true; }); }
        if (changed) refreshStatus();
      }
      /* "Entregue" / "Lida HH:MM" por baixo da minha última mensagem (como no PearOS) */
      function refreshStatus() {
        clusterTimes();
        thread.querySelectorAll('.msg-status').forEach(e => e.remove());
        let last = null;
        /* a apagada não conta: o estado fica por baixo da última minha que ainda se lê */
        for (let i = st.order.length - 1; i >= 0; i--) { const x = st.msgs.get(st.order[i]); if (x && x.sender === me && x.type !== 'system' && !x.deleted) { last = x; break; } }
        if (!last) return;
        const r = st.rows.get(last.id); if (!r) return;
        const s = last.status;
        const txt = s === 'read' ? 'Lida' + (!isGroup && last.readAt ? ' ' + UI.fmtTime(new Date(+last.readAt)) : '') : s === 'delivered' ? 'Entregue' : s === 'sent' ? 'Enviada' : '';
        if (!txt) return;
        const e = UI.el('<div class="msg-status"></div>'); e.textContent = txt; r.appendChild(e);
      }
      /* ---------- "a escrever…" que chega ---------- */
      function onTyping(d) {
        const from = String(d.from == null ? '' : d.from); if (!from || from === me) return;
        const c = Math.floor(+d.conversation) || 0;
        if (isGroup ? c !== gid : (c || from !== number)) return;
        if (d.on) st.typers.set(from, Date.now()); else st.typers.delete(from);
        if (d.on) activeNow();
        paintTyping();
      }
      function paintTyping() {
        const ttl = Math.max(4000, C.typingMs * 2 + 1500), now = Date.now();
        st.typers.forEach((t, k) => { if (now - t > ttl) st.typers.delete(k); });   /* um "parou" perdido não deixa a bolha para sempre */
        clearTimeout(typingT);
        if (!st.typers.size || st.dead) { if (typingEl) { const e = typingEl; typingEl = null; e.classList.remove('in'); setTimeout(() => e.remove(), 220); } return; }
        const near = nearBottom();
        if (!typingEl) { typingEl = UI.el('<div class="msg-typing"><small></small><div class="msg-dots"><i></i><i></i><i></i></div></div>'); thread.appendChild(typingEl); const e = typingEl; requestAnimationFrame(() => e.classList.add('in')); setTimeout(() => e.classList.add('in'), 60); }
        typingEl.querySelector('small').textContent = isGroup ? [...st.typers.keys()].slice(0, 2).map(nameFor).join(', ') + (st.typers.size > 2 ? ' e mais' : '') + ' a escrever…' : '';
        if (near) scrollBottom();
        typingT = setTimeout(paintTyping, ttl + 50);
      }
      /* ---------- "a escrever…" que se envia: no máximo um por Config.Messages.typingMs; pára ao enviar/limpar ---------- */
      let typingOn = false, typingLast = 0, typingStopT = null;
      function typingPing() {
        if (st.editing || st.left) return;
        const now = Date.now(), gap = Math.max(1000, C.typingMs);
        if (!typingOn || now - typingLast >= gap) { typingOn = true; typingLast = now; Promise.resolve(Bridge.rpcRaw('messages.typing', Object.assign({ on: true }, q))).catch(() => {}); }
        clearTimeout(typingStopT); typingStopT = setTimeout(typingStop, gap + 1500);
      }
      function typingStop() {
        clearTimeout(typingStopT); typingStopT = null;
        if (!typingOn) return; typingOn = false; typingLast = 0;
        Promise.resolve(Bridge.rpcRaw('messages.typing', Object.assign({ on: false }, q))).catch(() => {});
      }

      /* ---------- grupos ---------- */
      function setLeft(on) { st.left = !!on; comp.classList.toggle('left', st.left); comp.querySelector('.msg-left').classList.toggle('hidden', !st.left); if (st.left) { clearBar(); stopRecorder(); typingStop(); } }
      async function loadGroup() {
        if (!isGroup || st.dead) return;
        let r = null; try { r = await Bridge.rpcRaw('groups.info', { id: gid }); } catch (e) { r = null; }
        if (st.dead) return;
        if (r && !r.error && r.id != null) {
          Msgs.groups.set(gid, Object.assign({}, Msgs.groups.get(gid) || {}, r));
          title = r.title || r.name || title;
          Msgs.arr(r.members).forEach(x => { if (x && x.member) st.members[x.member] = x.name || Contacts.name(x.member); });
          setLeft(false);
        } else if (r && r.error && /member|forbidden|notfound/.test(String(r.error))) setLeft(true);
        paintHead(); paintMembers(); paintPin();
      }
      const onGroup = d => { if (isGroup && d && Math.floor(+d.id) === gid) loadGroup(); };

      /* ---------- barra de responder / editar ---------- */
      function setReply(m) {
        if (st.left) return; st.editing = null; st.replyTo = m;
        bar.classList.remove('hidden', 'edit');
        bar.querySelector('b').textContent = m.sender === me ? 'A responder a ti' : 'A responder a ' + nameFor(m.sender);
        bar.querySelector('.rq span').textContent = (Msgs.label(m) || '').slice(0, 80);
        inp.focus();
      }
      function setEdit(m) {
        st.replyTo = null; st.editing = m; typingStop();
        bar.classList.remove('hidden'); bar.classList.add('edit');
        bar.querySelector('b').textContent = 'A editar mensagem';
        bar.querySelector('.rq span').textContent = (m.content || '').slice(0, 80);
        inp.value = m.content || ''; comp.classList.toggle('has-text', !!inp.value.trim()); inp.focus();
      }
      function clearBar() {
        const wasEdit = !!st.editing; st.replyTo = null; st.editing = null;
        bar.classList.add('hidden'); bar.classList.remove('edit');
        if (wasEdit) { inp.value = ''; comp.classList.remove('has-text'); }
      }

      /* ---------- enviar ---------- */
      async function doSend(type, content, payload, extra, opts) {
        opts = opts || {};
        /* modo de voo: o aviso é do CC (nada de um segundo toast por cima) e a barra "a responder" fica como estava */
        if (!Msgs.netOk('enviar a mensagem')) return null;
        const d = Object.assign({ type, content, app: 'sms' }, isGroup ? { conversation: gid } : { to: number }, extra || {});
        if (payload) d.payload = payload;
        const rq = opts.reply !== undefined ? opts.reply : st.replyTo;
        if (rq) { d.replyTo = rq.id; if (rq === st.replyTo) clearBar(); }
        let r = null; try { r = await Bridge.rpcRaw('messages.send', d); } catch (e) { r = null; }
        if (r && !r.error && r.id != null) {
          if (rq && !r.replyTo) r.replyTo = { id: rq.id, sender: rq.sender, preview: (Msgs.label(rq) || '').slice(0, 80) };
          if (!r.status) r.status = 'sent';
          if (!st.dead) append(r);   /* a conversa pode ter sido fechada a meio de um envio demorado: a mensagem vai na mesma */
          Sound.play('send'); Bridge.emit('messages:changed');
          return r;
        }
        /* texto que falhou: a barra "a responder" volta. Foto/voz (quiet) não: a bolha falhada guarda a resposta e
           o "tentar de novo" leva-a - senão ficava presa à próxima mensagem de texto */
        if (rq && !opts.quiet && !st.replyTo && !st.editing && !st.dead) setReply(rq);
        if (!opts.quiet) UI.toast(errText(r, 'Não foi possível enviar'));
        return null;
      }
      async function sendText() {
        if (st.left || st.dead) return;
        const content = inp.value.trim(); if (!content) return;
        /* o campo conta 1000 CARACTERES mas o servidor corta o texto a 1000 BYTES UTF-8 (cut do server/messages.lua): com
           acentos ou emojis uma mensagem longa chegava encurtada sem aviso. Diz-se antes de enviar e o texto fica no campo. */
        let nBytes = content.length; try { nBytes = new TextEncoder().encode(content).length; } catch (e) {}
        if (nBytes > 1000) { UI.toast(AND ? 'A mensagem é demasiado longa, encurta-a um pouco' : 'A mensagem é demasiado longa, encurta-a um pouco'); return; }
        if (st.editing) {
          const m = st.editing; if (content === m.content) { clearBar(); return; }
          const r = await Bridge.rpcRaw('messages.edit', { id: m.id, content });
          if (r && !r.error && r.ok !== false) { applyUpdate({ id: m.id, content: typeof r.content === 'string' ? r.content : content, editedAt: +r.editedAt || Date.now() }); clearBar(); }
          else UI.toast(errText(r, 'Não foi possível editar'));
          return;
        }
        inp.value = ''; comp.classList.remove('has-text'); typingStop();
        const m = await doSend('text', content);
        if (!m && !inp.value) { inp.value = content; comp.classList.add('has-text'); }   /* falhou: o texto não se perde */
      }
      /* uma bolha provisória com a barra de progresso enquanto a media sobe */
      function pendingRow(kind, url) {
        const r = UI.el(`<div class="msg-row me pending"><div class="bubble me ${kind === 'image' ? 'img' : 'audio'}">${kind === 'image' ? '<div class="pic"></div><div class="msg-prog"><i></i></div>' : `<div class="msg-audio na">${g('mic')}<span>A enviar mensagem de voz…</span></div><div class="msg-prog"><i></i></div>`}</div></div>`);
        if (kind === 'image' && url) r.querySelector('.pic').style.backgroundImage = UI.img(url);
        thread.insertBefore(r, typingEl || null); scrollBottom();
        const pb = r.querySelector('.msg-prog i');
        return {
          progress: f => { if (pb) pb.style.transform = `scaleX(${Math.max(0, Math.min(1, +f || 0)).toFixed(3)})`; },
          done: () => r.remove(),
          fail: (msg, retry) => {
            r.classList.add('failed');
            const e = UI.el(`<div class="msg-fail">${g('xCircle')}<span></span></div>`);
            e.querySelector('span').textContent = msg + (retry ? ' · Toca para tentar de novo' : '');
            e.onclick = () => { r.remove(); if (retry) retry(); };
            r.appendChild(e);
            UI.longPress(r, () => UI.ctxMenu(r, [{ label: 'Descartar', icon: 'trash', danger: true, onTap: () => r.remove() }]));
          }
        };
      }
      /* `reply`: undefined = a barra atual; o "tentar de novo" de uma bolha falhada passa a resposta que já levava */
      async function sendImage(url, reply) {
        if (st.left || st.dead || typeof url !== 'string' || !url) return;
        if (!Msgs.netOk('enviar a foto')) return;   /* antes de encolher e de subir os bocados: sem rede não se começa */
        const C2 = Msgs.cfg();
        const rq = reply !== undefined ? reply : st.replyTo; if (rq && rq === st.replyTo) clearBar();   /* a resposta fica presa a ESTA foto, mesmo que a barra mude durante o envio */
        /* a lista branca do server/media.lua é jpeg/png/webp: outro formato (gif, bmp…) ou uma foto acima do limite
           passa primeiro por JPEG - senão o media.begin respondia badmime/toolarge e a foto nunca saía */
        if (url.length > C2.maxImageBytes || !/^data:image\/(jpeg|png|webp);base64,/i.test(url)) {
          let small = null; try { small = await Photos.shrink(url, 1100, 0, Math.max(20000, C2.maxImageBytes - 2048)); } catch (e) { small = null; }
          if (!small || small === Photos.BLACK) { UI.toast('Não foi possível preparar a foto para envio'); return; }
          url = small;
        }
        if (st.dead) return;
        const mime = ((/^data:(image\/[A-Za-z0-9.+-]+);/.exec(url) || [])[1] || 'image/jpeg').toLowerCase();
        const pend = pendingRow('image', url);
        const up = await Msgs.upload(url, { kind: 'image', mime }, f => pend.progress(f));
        if (!up || up.error || !up.mediaId) { pend.fail(errText(up, 'A foto não foi enviada'), () => sendImage(url, rq || null)); return; }
        Msgs.mediaPut(up.mediaId, { url, kind: 'image', mime });   /* quem enviou já tem a imagem: não volta a descê-la */
        const m = await doSend('image', 'Foto', { mediaId: up.mediaId }, { mediaId: up.mediaId }, { quiet: true, reply: rq || null });
        if (m) pend.done(); else pend.fail('A foto não foi enviada', () => sendImage(url, rq || null));
      }
      async function sendVoice(blob, ms, wave, reply) {
        if (st.left || st.dead) return;
        if (!Msgs.netOk('enviar a mensagem de voz')) return;
        const rq = reply !== undefined ? reply : st.replyTo; if (rq && rq === st.replyTo) clearBar();
        const pend = pendingRow('audio');
        /* o 4.º argumento (progresso) é um extra do VoiceMsg.upload do M4; sem ele a barra só fica parada */
        let up = null; try { up = await VoiceMsg.upload(blob, ms, wave, f => pend.progress(f)); } catch (e) { console.error('[apex_phone] VoiceMsg.upload', e); up = null; }
        const mid = up && Math.floor(+up.mediaId);
        if (!(mid > 0)) { pend.fail(errText(up, 'A mensagem de voz não foi enviada'), () => sendVoice(blob, ms, wave, rq || null)); return; }
        /* duração em ms (a do media.begin manda no servidor); forma de onda: até 64 valores 0..1 (o servidor recusa mais) */
        const payload = { mediaId: mid, duration: Math.max(0, Math.round(+ms || 0)), waveform: Array.isArray(wave) ? wave.slice(0, 64).map(x => Math.round(Math.max(0, Math.min(1, +x || 0)) * 100) / 100) : [] };
        const m = await doSend('audio', 'Mensagem de voz', payload, { mediaId: mid }, { quiet: true, reply: rq || null });
        if (m) pend.done(); else pend.fail('A mensagem de voz não foi enviada', () => sendVoice(blob, ms, wave, rq || null));
      }
      /* ---------- mensagem de voz ----------
         O CEF do FiveM pode não dar microfone à NUI: nesse caso diz-se isso mesmo, em vez de um botão que não faz nada. */
      async function startVoice() {
        if (st.left || st.dead || st.recorder) return;
        if (!voiceOk()) { UI.alert({ title: 'Mensagens de voz indisponíveis', msg: 'O browser do jogo não dá acesso ao microfone a este telemóvel (sem getUserMedia/MediaRecorder), por isso não é possível gravar aqui. Podes continuar a enviar texto, fotos e a localização.' }); return; }
        if (window.Perm && !(await Perm.request('messages', 'mic'))) return;
        if (st.dead || st.left) return;
        typingStop();
        const host = comp.querySelector('.msg-rec'); host.innerHTML = ''; comp.classList.add('recording');
        const end = () => { st.recorder = null; comp.classList.remove('recording'); host.innerHTML = ''; };
        const fail = e => { console.error('[apex_phone] VoiceMsg.recorder', e); end(); UI.toast('Não foi possível começar a gravar'); };
        try {
          const rec = VoiceMsg.recorder(host, { maxSec: C.maxAudioSec, onSend: (blob, ms, wave) => { end(); sendVoice(blob, ms, wave); }, onCancel: () => end() });
          st.recorder = rec || {};
          if (rec && typeof rec.then === 'function') rec.then(x => { if (st.recorder === rec) st.recorder = x || {}; }, fail);
        } catch (e) { fail(e); }
      }
      function stopRecorder() {
        const r = st.recorder; st.recorder = null; comp.classList.remove('recording');
        if (r) { for (const k of ['destroy', 'cancel', 'stop']) { if (typeof r[k] === 'function') { try { r[k](); } catch (e) {} break; } } }
        const host = comp.querySelector('.msg-rec'); if (host) host.innerHTML = '';
      }
      /* ---------- Câmara: tira a foto AQUI (CamView, o mesmo visor da app Câmara) e envia ----------
         Antes só abria a app Câmara e a foto nunca chegava à conversa. capture() e não shoot(): a foto
         vai para a conversa, não para a galeria. O visor tem de ser desligado em TODOS os caminhos
         (×, Escape, trocar de app, matar a app) - senão o jogador fica sem HUD e com a câmara presa. */
      async function openCamera() {
        if (st.dead || st.left) return;
        if (!window.CamView || typeof CamView.mount !== 'function') { UI.toast('Câmara indisponível'); return; }
        if (window.Perm && !(await Perm.request('messages', 'camera'))) return;
        if (st.dead) return;
        const lay = UI.el(`<div class="msg-cam"><div class="mc-view"></div><div class="mc-still"></div><div class="mc-top"><div class="b x">${g('x', 22)}</div><div class="mc-ttl"></div><div class="b fl off">${g('bolt', 22)}</div></div><div class="mc-bot"><div class="mc-retake">Repetir</div><div class="mc-shut"><div></div></div><div class="mc-send">${g('arrowUp')}</div><div class="mc-flip">${g('repeat', 22)}</div></div></div>`);
        lay.querySelector('.mc-ttl').textContent = title;
        const view = lay.querySelector('.mc-view'), still = lay.querySelector('.mc-still');
        let cam = null, dead = false, raw = null, busy = false;
        /* ⚠️ sem o stopPropagation o system.js também ouve o Escape e fecha o TELEMÓVEL inteiro */
        const onKey = e => { if (dead || e.key !== 'Escape') return; if (document.activeElement && document.activeElement.matches('input,textarea')) return; e.preventDefault(); e.stopPropagation(); close(); };
        const offApp = Bridge.on('app:close', id => { if (id === 'messages') close(); });   /* trocar de app só esconde a janela */
        function close() { if (dead) return; dead = true; document.removeEventListener('keydown', onKey); offApp(); layers.delete(close); try { if (cam) cam.destroy(); } catch (e) {} lay.remove(); }
        layers.add(close);
        document.addEventListener('keydown', onKey);
        win.appendChild(lay);
        try { cam = CamView.mount(view, { chrome: 'bare', aspect: (view.clientWidth || 440) / (view.clientHeight || 956), autoActivate: false, aimInside: true }); cam.setActive(true); }
        catch (e) { console.error('[apex_phone] CamView', e); close(); UI.toast('Não foi possível abrir a câmara'); return; }
        requestAnimationFrame(() => { if (!dead) lay.classList.add('in'); }); setTimeout(() => { if (!dead) lay.classList.add('in'); }, 120);
        lay.querySelector('.b.x').onclick = close;
        lay.querySelector('.mc-flip').onclick = () => { if (!raw && cam) cam.flip(); };
        lay.querySelector('.b.fl').onclick = e => { if (!cam) return; cam.setFlash(!cam.flash); e.currentTarget.classList.toggle('off', !cam.flash); };
        lay.querySelector('.mc-shut').onclick = async () => {
          if (busy || dead || raw || !cam) return; busy = true;
          let r = null; try { r = await cam.capture(); } catch (e) { r = null; }
          busy = false; if (dead) return;
          if (!r || !r.raw) { UI.toast((r && r.msg) || 'Não foi possível tirar a fotografia', 3000); return; }
          raw = r.raw; still.style.backgroundImage = UI.img(raw); lay.classList.add('shot'); cam.setActive(false);   /* com a foto parada, a câmara do jogo desliga-se */
        };
        lay.querySelector('.mc-retake').onclick = () => { if (dead || !cam) return; raw = null; still.style.backgroundImage = ''; lay.classList.remove('shot'); cam.setActive(true); };
        lay.querySelector('.mc-send').onclick = () => { if (!raw || dead) return; const img = raw; close(); sendImage(img); };
      }
      function attachSheet() {
        if (st.left) return;
        const body = AND
          ? UI.el(`<div class="attach-row msg-attach amsg-attach"><div class="ph"><i>${g('photo')}</i><div>${UI.esc(App.name('photos') || T('Galeria'))}</div></div><div class="cam"><i>${g('camera')}</i><div>${UI.esc(T('Câmara'))}</div></div><div class="loc"><i>${g('location')}</i><div>${UI.esc(T('Localização'))}</div></div><div class="ct"><i>${g('personCircle')}</i><div>${UI.esc(T('Contacto'))}</div></div><div class="ap"><i>${g('grid')}</i><div>${UI.esc(T('App'))}</div></div></div>`)
          : UI.el(`<div class="attach-row msg-attach"><div class="ph">${g('photo')}<div>Foto</div></div><div class="cam">${g('camera')}<div>Câmara</div></div><div class="loc">${g('nav')}<div>Localização</div></div><div class="ct">${g('personCircle')}<div>Contacto</div></div><div class="ap">${g('grid')}<div>App</div></div></div>`);
        const sh = UI.sheet({ title: AND ? T('Anexar') : 'Anexar', right: AND ? T('Cancelar') : 'Cancelar', body, cls: AND ? 'amsg-attach-sheet' : '' });
        body.querySelector('.ph').onclick = async () => {
          sh.close(); const p = await Photos.pick(); if (!p) return;
          /* a ficha da galeria vem sem o base64: desce primeiro (antes ia só o seed e a foto chegava como um gradiente) */
          let url = null; try { url = await Photos.data(p, true); } catch (e) { url = null; }
          if (st.dead) return;
          if (typeof url === 'string' && /^data:image\//i.test(url)) sendImage(url);
          /* foto da galeria guardada como LIGAÇÃO (upload externo): não há bytes para o media.*; vai como antes da
             Fase 2 ({ url }) - pelo media.upload o servidor recusava-a como baddata e a foto nunca chegava */
          else if (typeof url === 'string' && /^https?:\/\//i.test(url) && url.length <= 2048) doSend('image', 'Foto', { url, seed: p.seed });
          else if (p.seed != null) doSend('image', 'Foto', { seed: p.seed }); else UI.toast('Não foi possível ler a foto');
        };
        body.querySelector('.cam').onclick = () => { sh.close(); openCamera(); };
        body.querySelector('.loc').onclick = async () => { sh.close(); const p = await Bridge.call('getCoords'); if (!p) { UI.toast('Sem localização'); return; } doSend('location', 'Localização', { x: p.x, y: p.y, label: 'A minha localização' }); };
        body.querySelector('.ct').onclick = async () => { sh.close(); const c = await Contacts.pick('Enviar contacto'); if (c) doSend('contact', c.name, { name: c.name, number: c.number }); };
        body.querySelector('.ap').onclick = async () => {
          sh.close();
          const opts = System.installed().filter(id => App.get(id)).map(id => ({ value: id, label: App.name(id) })).sort((a, b) => String(a.label).localeCompare(String(b.label)));
          const id = await UI.picker('Partilhar app', opts);
          if (id && Msgs.sharedApp({ app: id })) doSend('app', App.name(id), { app: id });
        };
      }
      /* manter premido o campo: Colar (área interna), Copiar e Limpar */
      function fieldMenu() {
        const items = [];
        if (Msgs.clipboard) items.push({ label: 'Colar', icon: 'clipboard', onTap: () => { Msgs.paste(inp); inp.focus(); } });
        if (inp.value) { items.push({ label: 'Copiar', icon: 'copy', onTap: () => Msgs.copy(inp.value) }); items.push({ label: 'Limpar', icon: 'xCircle', onTap: () => { inp.value = ''; inp.dispatchEvent(new Event('input', { bubbles: true })); } }); }
        if (!items.length) { UI.toast('Nada para colar'); return; }
        UI.ctxMenu(comp, items);
      }

      /* ---------- paginação para trás ---------- */
      function loadOlder() {
        if (st.loadP) return st.loadP;
        if (!st.more || st.dead || !st.loaded || !st.order.length) return Promise.resolve();
        const before = st.order[0];
        moreEl.classList.add('loading');
        st.loadP = Promise.resolve(Bridge.rpcRaw('messages.get', Object.assign({ before, limit: C.pageSize }, q))).then(r => {
          if (st.dead) return;
          const list = Msgs.arr(r).filter(m => m && m.id != null && +m.id < before && !st.msgs.has(+m.id)).sort((a, b) => +a.id - +b.id);
          st.more = r && typeof r.more === 'boolean' ? r.more : Msgs.arr(r).length >= C.pageSize;
          if (!list.length) { st.more = false; return; }
          /* manter o que está à vista no mesmo sítio: o que entra por cima empurra a altura, o scrollTop compensa */
          const h0 = sc.scrollHeight, t0 = sc.scrollTop;
          const oldFirst = st.msgs.get(before);
          list.forEach(m => { norm(m); st.msgs.set(m.id, m); });
          st.order = list.map(m => m.id).concat(st.order);
          const frag = buildRows(list, null);
          /* o separador do dia da primeira antiga sai se a última nova for do mesmo dia (senão ficava repetido) */
          const firstOld = moreEl.nextElementSibling;
          if (firstOld && firstOld.classList.contains('day-sep') && oldFirst && dayKey(list[list.length - 1]) === dayKey(oldFirst)) firstOld.remove();
          thread.insertBefore(frag, moreEl.nextElementSibling);
          if (isGroup && oldFirst) rerender(oldFirst.id);   /* o nome por cima da primeira antiga pode deixar de ser preciso */
          clusterTimes();
          sc.scrollTop = sc.scrollHeight - h0 + t0;
          if (st.pinnedMsg && st.msgs.has(st.pinnedMsg)) paintPin();
        }).catch(e => { console.error('[apex_phone] messages.get (antes)', e); }).then(() => { st.loadP = null; moreEl.classList.remove('loading'); moreEl.classList.toggle('hidden', !st.more); });
        return st.loadP;
      }
      moreEl.onclick = () => loadOlder();
      sc.addEventListener('scroll', () => { if (st.loaded && st.more && !st.loadP && sc.scrollTop < 140) loadOlder(); }, { passive: true });

      /* ---------- ligações ---------- */
      inp.addEventListener('input', () => { const has = !!inp.value.trim(); comp.classList.toggle('has-text', has); if (st.editing) return; if (has) typingPing(); else typingStop(); });
      inp.onkeydown = e => { if (e.key === 'Enter') sendText(); };
      comp.querySelector('.send').onclick = () => sendText();
      comp.querySelector('.cancel').onclick = () => clearBar();
      comp.querySelector('.plus').onclick = () => attachSheet();
      micBtn.onclick = () => startVoice();
      UI.longPress(inp, () => fieldMenu());
      v.content.appendChild(thread); v.content.style.paddingBottom = '0'; v.appendChild(comp); UI.push(win, v);

      const markRead = () => { st.unseen = false; Bridge.rpc('messages.read', q).then(() => Msgs.badge()); };
      const seeAgain = () => { if (st.unseen && !st.dead && Msgs.current === api && System.currentApp() === 'messages' && !System.locked) markRead(); };
      offs.push(Bridge.on('phone:open', () => setTimeout(seeAgain, 0)), Bridge.on('unlock', () => setTimeout(seeAgain, 250)),
        /* trocar de app a meio de uma gravação: o microfone não fica aberto em segundo plano (o gravador do M4 só
           se cala sozinho ao guardar o telemóvel ou ao matar a app) */
        Bridge.on('app:close', id => { if (id === 'messages' && st.recorder) stopRecorder(); }),
        /* o M4 avisa quando saí / fui removido do grupo (Informações): o campo fecha logo, sem esperar pelo groups.info */
        Bridge.on('groups:left', d => { if (isGroup && d && Math.floor(+d.id) === gid) setLeft(true); }));
      const api = { number: isGroup ? null : number, conversation: isGroup ? gid : null, app: 'sms', win, view: v, key, append, remove: removeRow, status: applyStatus, react: d => { const m = st.msgs.get(+d.id); if (!m) return; m.reactions = m.deleted ? [] : Msgs.arr(d.reactions); paintReacts(m); },
        update: applyUpdate, typing: onTyping, group: onGroup, markRead, toBottom: scrollBottom, isUnseen: () => st.unseen, isDead: () => st.dead };
      Msgs.current = api; paintSel();

      function cleanup() {
        if (st.dead) return; st.dead = true;
        typingStop(); stopRecorder(); clearTimeout(typingT); clearTimeout(typingStopT); clearTimeout(grpStatusT);
        if (io) io.disconnect();
        dropPlayers(thread);
        offs.forEach(f => { try { f(); } catch (e) {} });
        /* conversa aberta por cima de outra: ao sair, os pushes voltam para a de baixo */
        if (Msgs.current === api) Msgs.current = prevApi && prevApi.isDead && !prevApi.isDead() && prevApi.view && prevApi.view.isConnected ? prevApi : null;
        if (!winDead) paintSel();
        /* voltar à lista = pedir outra vez as conversas e a presença (killApp: a janela já saiu, não se pede nada) */
        setTimeout(() => { if (!winDead && win.isConnected) render(curQ, true, true); }, 0);
      }

      /* ---------- primeira página ---------- */
      if (!isGroup) Promise.resolve(Bridge.rpcRaw('presence.get', { numbers: [number] })).then(r => { if (st.dead || !r || typeof r !== 'object' || r.error) return; const p = r[number]; if (p && typeof p === 'object') { presOk = !!(p.online || +p.lastSeen > 0); setPresence({ online: !!p.online, lastSeen: +p.lastSeen || 0 }); } }).catch(() => {});
      else loadGroup();
      /* a mensagem fixada vem da lista; aberta sem ela (notificação, Vera, Contactos) pede-se a lista uma vez */
      const initMeta = () => { const mt = Msgs.meta.get(key); if (!mt) return false; if (!st.pinnedMsg) { st.pinnedMsg = +mt.pinnedMsg || 0; paintPin(); } return true; };
      if (!initMeta()) Msgs.badge().then(() => { if (!st.dead) initMeta(); });
      Promise.resolve(Bridge.rpcRaw('messages.get', Object.assign({ limit: C.pageSize }, q))).then(r => {
        if (st.dead) return;
        sk.remove();
        if (r && r.error) { if (/member|forbidden/.test(String(r.error))) setLeft(true); else UI.toast('Não foi possível carregar a conversa'); }
        const list = Msgs.arr(r).filter(m => m && m.id != null).sort((a, b) => +a.id - +b.id);
        st.more = r && typeof r.more === 'boolean' ? r.more : list.length >= C.pageSize;
        list.forEach(m => { norm(m); if (st.msgs.has(m.id)) return; st.msgs.set(m.id, m); st.order.push(m.id); });
        thread.insertBefore(buildRows(st.order.map(i => st.msgs.get(i)), null), anchor());
        st.loaded = true; moreEl.classList.toggle('hidden', !st.more);
        const queued = st.queue; st.queue = []; queued.forEach(a => append(a[0], a[1], a[2]));
        refreshStatus(); paintPin(); scrollBottom(); setTimeout(() => { if (!st.dead) scrollBottom(); }, 50);
        /* as últimas imagens estão à vista: não se espera pelo observador (no harness headless pode nem disparar) */
        [...thread.querySelectorAll('.pic.loading')].slice(-6).forEach(loadPic);
        markRead();
      }).catch(e => { console.error('[apex_phone] messages.get', e); sk.remove(); st.loaded = true; });
      /* sem foco automático: o teclado só abre quando o utilizador toca no campo (PearOS Mensagens) */
    }
    Msgs._open = openThread;
    /* ---------- ouvintes da janela ---------- */
    /* (o notif:open das notificações do servidor é tratado no window.Msgs, que também serve com a app fechada) */
    /* uma mensagem nova pode mudar a lista: com a lista à frente repinta-se (com um atraso curto, para juntar rajadas);
       com uma conversa aberta só se marca como velha e repinta-se ao voltar */
    let rT = null;
    /* com uma linha aberta ou a meio do deslize, repintar tirava-a debaixo do dedo: espera-se que feche */
    /* PearPhone Fold (lista | conversa): a lista está sempre à vista, por isso repinta-se também com uma conversa aberta */
    const listShown = () => UI.depth(win) <= 1 || win.classList.contains('split-on');
    const soon = () => { invalidate(); clearTimeout(rT); rT = setTimeout(function again() {
      if (winDead || !listShown() || System.currentApp() !== 'messages') return;
      if (openRow || holder.querySelector('.msl-row.drag')) { rT = setTimeout(again, 600); return; }
      render(curQ);
    }, 250); };
    const offMsg = Bridge.on('message', m => { if (m && (m.app || 'sms') === 'sms') soon(); });
    const offDel = Bridge.on('messages:changed', soon);
    win._msgsResume = () => {
      if (listShown()) render(curQ, true, true);
      const cur = Msgs.current; if (cur && cur.win === win && cur.isUnseen && cur.isUnseen()) cur.markRead();
    };
    /* ⚠️ o killApp só corre o onClose (e o onPop das vistas): sem largar as referências globais, a janela
       morta ficava em memória - e um SMS numa app reaberta era acrescentado ao DOM invisível. */
    win.onClose = () => {
      winDead = true; offMsg(); offDel(); clearTimeout(rT);
      [...layers].forEach(f => { try { f(); } catch (e) {} });
      if (Msgs.current && Msgs.current.win === win) Msgs.current = null;
      if (Msgs._open === openThread) Msgs._open = null;
      if (Msgs._compose === compose) Msgs._compose = null;
      win._msgsResume = null; win._msgsBack = null;
    };
    render('', false, true);
    /* PearPhone Fold aberto: conversas à esquerda, a conversa escolhida à direita (ui.js UI.split; a marca da linha é a paintSel) */
    if (!AND) { UI.setRoot(win, root); UI.split(win, { icon: 'message', title: 'Nenhuma conversa aberta', sub: 'Escolhe uma conversa na lista ou começa uma nova com o botão de escrever.', row: '.msl-none' }); return; }
    /* Nova UI: separadores Conversas · Contactos (a lista de conversas é a MESMA vista, reutilizada) */
    function contactsTab() {
      const v = UI.view({ title: T('Contactos'), large: true, cls: 'amsg-ct-view', onPop: () => offC() });
      const box = UI.el('<div class="amsg-ct"></div>');
      v.content.append(UI.search(T('Pesquisar'), q => paint(q)), box);
      let lastQ = '';
      function paint(q) {
        lastQ = q || ''; box.innerHTML = '';
        const list = Contacts.cache.filter(c => !lastQ || String(c.name).toLowerCase().includes(lastQ) || String(c.number).includes(lastQ)).sort((a, b) => String(a.name).localeCompare(String(b.name), 'pt'));
        PhoneDroid.ltSub(v, Contacts.cache.length ? PhoneDroid.plural(Contacts.cache.length, '1 contacto', 'contactos') : '');
        if (!list.length) { box.appendChild(UI.empty('personCircle', lastQ ? T('Sem resultados') : T('Sem contactos'), lastQ ? '' : T('Os teus contactos aparecem aqui.'))); return; }
        let key = null, card = null;
        list.forEach(c => {
          const k0 = String(c.name || '#').normalize('NFD').replace(/[̀-ͯ]/g, '').charAt(0).toUpperCase(), k = /[A-Z]/.test(k0) ? k0 : '#';
          if (k !== key) { key = k; box.appendChild(UI.el(`<div class="aph-sec">${UI.esc(k)}</div>`)); card = UI.el('<div class="aph-card"></div>'); box.appendChild(card); }
          const r = UI.el('<div class="aph-row"><div class="aph-row-fg"><div class="aph-rb"><b></b><span></span></div></div></div>');
          const fg = r.firstElementChild; fg.prepend(PhoneDroid.avatar(c, c.name, 's40')); fg.querySelector('b').textContent = c.name; fg.querySelector('span').textContent = UI.phone(c.number);
          fg.onclick = () => openThread({ number: c.number, name: c.name });
          UI.longPress(fg, () => UI.ctxMenu(fg, [{ label: T('Chamar'), icon: 'phone', onTap: () => PhoneApp.call(c.number, c.name) }, { label: App.name('facetime'), icon: 'video', onTap: () => PhoneApp.facetime(c.number, c.name) }]));
          card.appendChild(r);
        });
      }
      let live = false; setTimeout(() => { live = true; }, 0);
      const offC = Bridge.on('contacts', () => { if (!v.isConnected) { if (live) offC(); return; } paint(lastQ); });
      if (!Contacts.cache.length) Contacts.load();
      paint('');
      return v;
    }
    UI.tabbar(win, [{ icon: 'message', label: T('Conversas'), view: () => root }, { icon: 'personCircle', label: T('Contactos'), view: contactsTab }], 0);
    /* NOVA Fold8 aberto: as conversas à esquerda e a conversa aberta à direita, como no PearOS (ui.js UI.split) */
    UI.split(win, { icon: 'message', title: T('Nenhuma conversa aberta'), sub: T('Escolhe uma conversa na lista ou começa uma nova.'), row: '.msl-none' });
  },
  /* voltar à app: a lista pode estar velha (e a presença também); a conversa aberta marca como lidas as que chegaram escondidas */
  resume(win) { if (win && win._msgsResume) win._msgsResume(); }
});

/* =====================================================================
   MOCKS DO BROWSER (LocalDB.register) - os RPCs novos do M1 (§8.3)
   ---------------------------------------------------------------------
   No jogo o localdb.js nem é carregado; aqui imitam o servidor para a UI e o harness exercitarem
   o mesmo caminho: identidade = número (como o mock antigo, também nas DMs sociais), janelas de
   editar/apagar, reações só da lista, apagar para mim/para todos, conversa limpa (cleared_before),
   meta por conversa, presença, bloqueios, media aos bocados e os efeitos dos grupos.
   Tabelas partilhadas com os mocks do M4 (groups.js) e do M5 (phone.js):
     conversations        { id, app, title, avatar, created_by, created, last_id }
     conversation_members { conversation_id, member, role, joined, last_read_id, left_at }
     blocks               { owner (citizenid), number, created }
   Os pedidos antigos (sem limit / sem scope / sem conversation) respondem como antes.
   ===================================================================== */
(() => {
  if (!window.LocalDB || typeof LocalDB.register !== 'function') return;
  const T = LocalDB.T, G = Store.global || Store, now = () => Date.now();
  const me = () => LocalDB.me().number, cid = () => LocalDB.cid;
  const CFG = { editWindowMin: 15, deleteForAllMin: 60, typingMs: 3000, reactions: ['❤️', '👍', '😂', '😮', '😢', '🙏'] };
  const MUTE_FOREVER = 4102444800000;   /* o mesmo "para sempre" do server/messages.lua (1 jan 2100) */
  const MEDIA = { maxImageBytes: 260000, maxAudioSec: 60, maxAudioBytes: 700000, chunkBytes: 48000 };
  const int = v => { const n = Math.floor(+v); return isFinite(n) ? n : 0; };
  const str = (v, max) => (typeof v === 'string' || typeof v === 'number') ? String(v).slice(0, max) : '';
  const rnd = n => Math.floor(Math.random() * n);

  /* grupo pedido por { conversation } ou pelo número 'g:<id>' (como o convOf do servidor) */
  const convArg = d => int(d.conversation) || int((/^g:(\d+)$/.exec(String(d.number == null ? (d.to == null ? '' : d.to) : d.number)) || [])[1]);
  const members = conv => T('conversation_members').all().filter(x => int(x.conversation_id) === conv && !x.left_at);
  const isMember = (conv, who) => conv > 0 && members(conv).some(x => x.member === who);
  /* quando `who` entrou no grupo (o joinedAt do server/messages.lua): o que foi escrito antes não é dele */
  const joinedAt = (conv, who) => { const r = members(conv).find(x => x.member === who); return r ? (+r.joined || 0) : null; };
  const hidden = (m, my) => !!((m.sender === my && m.deleted_sender) || (!m.conversation_id && m.receiver === my && m.sender !== my && m.deleted_receiver));
  const visible = (m, my) => { if (!m.conversation_id) return m.sender === my || m.receiver === my; const j = joinedAt(int(m.conversation_id), my); return j !== null && (+m.created || 0) >= j; };
  const pair = (m, app, my, number) => !m.conversation_id && (m.app || 'sms') === app && ((m.sender === my && m.receiver === number) || (m.sender === number && m.receiver === my));
  const metaOf = (my, app, other) => T('thread_meta').all().find(x => x.owner === my && x.app === app && x.other === other) || null;
  function setMeta(my, app, other, patch) {
    const rows = T('thread_meta').all(); let r = rows.find(x => x.owner === my && x.app === app && x.other === other);
    if (!r) { r = { owner: my, app, other, pinned: 0, muted_until: null, pinned_msg: null, cleared_before: null }; rows.push(r); }
    Object.assign(r, patch); T('thread_meta').set(rows); return r;
  }
  /* as linhas do mock do M5 (phone.js) não têm owner: no browser há uma personagem de cada vez */
  const blockedByMe = number => T('blocks').all().some(b => (!b.owner || b.owner === cid()) && b.number === number);
  /* presença determinística por número: uns online, outros "vistos há X min" */
  function presenceOf(n) {
    if (String(n) === me()) return { online: true, lastSeen: now() };
    const s = [...String(n)].reduce((h, ch) => (h * 31 + ch.charCodeAt(0)) % 9973, 7);
    return s % 3 === 0 ? { online: true, lastSeen: now() } : { online: false, lastSeen: now() - ((s % 47) + 3) * 5 * 60000 };
  }
  function statusOf(m, my) {
    if (m.conversation_id) {
      if (m.sender !== my) return 'read';
      const os = members(int(m.conversation_id)).filter(x => x.member !== my);
      return os.length && os.every(x => int(x.last_read_id) >= m.id) ? 'read' : 'delivered';
    }
    if (m.sender !== my) return m.read ? 'read' : 'delivered';
    return m.read_at ? 'read' : m.delivered_at ? 'delivered' : 'sent';
  }
  const preview = m => m.deleted_all ? '' : String((window.Msgs ? Msgs.label(m) : m.content) || '').slice(0, 80);
  /* a linha como o servidor a devolve: campos antigos + status, readAt, editedAt, replyTo, reactions, deleted, conversation */
  function pub(m, my, rows, reacts) {
    const o = { id: m.id, app: m.app || 'sms', sender: m.sender, receiver: m.receiver, type: m.type || 'text', content: m.content || '', payload: m.payload == null ? null : m.payload, read: !!m.read, created: m.created };
    if (m.conversation_id) o.conversation = int(m.conversation_id);
    o.status = statusOf(m, my); if (m.read_at) o.readAt = m.read_at;
    o.editedAt = m.edited_at || null;
    if (m.deleted_all) { o.deleted = true; o.content = ''; o.payload = null; }
    if (m.reply_to) { const r = (rows || T('messages').all()).find(x => x.id === m.reply_to); o.replyTo = { id: m.reply_to, sender: r ? r.sender : null, preview: r ? preview(r) : '' }; }
    o.reactions = m.deleted_all ? [] : (reacts || T('message_reactions').all()).filter(x => x.message_id === m.id).map(x => ({ emoji: x.emoji, who: x.who, mine: x.who === my }));
    return o;
  }

  LocalDB.register('messages.threads', d => {
    const app = str(d.app, 20) || 'sms', my = me(), cs = T('contacts').all(), rows = T('messages').all(), reacts = T('message_reactions').all();
    const th = {};
    rows.filter(m => (m.app || 'sms') === app && !m.conversation_id && (m.sender === my || m.receiver === my) && !hidden(m, my)).sort((a, b) => a.id - b.id).forEach(m => {
      const o = m.sender === my ? m.receiver : m.sender; const mt = metaOf(my, app, o);
      if (mt && mt.cleared_before && m.id <= mt.cleared_before) return;   /* conversa apagada por mim: só volta com mensagens novas */
      const t = th[o] = th[o] || { number: o, unread: 0 };
      t.last = pub(m, my, rows, reacts); t.ts = m.created; if (m.receiver === my && !m.read) t.unread++;
    });
    /* como o servidor: um silêncio que já passou não vai na resposta */
    const mutedOf = mt => (+mt.muted_until || 0) > now() ? +mt.muted_until : null;
    const out = Object.values(th).map(t => { const mt = metaOf(my, app, t.number) || {}, pr = presenceOf(t.number);
      return Object.assign(t, { name: (cs.find(c => c.number === t.number) || {}).name || null, pinned: !!mt.pinned, mutedUntil: mutedOf(mt), pinnedMsg: mt.pinned_msg || null, online: pr.online, lastSeen: pr.lastSeen, lastStatus: t.last && t.last.sender === my ? t.last.status : null }); });
    T('conversations').all().filter(c => (c.app || 'sms') === app && isMember(int(c.id), my)).forEach(c => {
      const id = int(c.id), mt = metaOf(my, app, 'g:' + id) || {}, mine = members(id).find(x => x.member === my) || {};
      const ms = rows.filter(m => int(m.conversation_id) === id && !hidden(m, my) && !(mt.cleared_before && m.id <= mt.cleared_before)).sort((a, b) => a.id - b.id);
      const last = ms[ms.length - 1];
      if (!last && mt.cleared_before) return;
      /* membros como { member, role } - a forma do GroupListFor (server/groups.lua) e do groups.info */
      const mem = members(id).map(x => ({ member: x.member, role: x.role === 'admin' ? 'admin' : 'member' }));
      out.push({ conversation: id, number: 'g:' + id, group: { id, title: c.title, avatar: int(c.avatar) || null, members: mem, memberCount: mem.length, role: mine.role === 'admin' ? 'admin' : 'member' }, name: c.title,
        unread: ms.filter(m => m.sender !== my && m.type !== 'system' && m.id > int(mine.last_read_id)).length,
        last: last ? pub(last, my, rows, reacts) : null, ts: last ? last.created : (c.created || 0), pinned: !!mt.pinned, mutedUntil: mutedOf(mt), pinnedMsg: mt.pinned_msg || null,
        lastStatus: last && last.sender === my ? statusOf(last, my) : null });
    });
    return out.sort((a, b) => b.ts - a.ts);
  });

  /* { number | conversation, app, before?, limit? } - sem limit continua a dar até 300 (as apps que não paginam ficam iguais) */
  LocalDB.register('messages.get', d => {
    const app = str(d.app, 20) || 'sms', my = me(), rows = T('messages').all(), reacts = T('message_reactions').all();
    const conv = convArg(d), number = str(d.number, 40);
    const lim = d.limit != null ? Math.max(1, Math.min(50, int(d.limit) || 1)) : 300, before = int(d.before);
    let other, pick;
    /* o servidor devolve lista vazia a quem não é membro e, a quem é, só o que foi escrito desde que entrou (getGroup) */
    if (conv > 0) { if (!isMember(conv, my)) return []; other = 'g:' + conv; const j = joinedAt(conv, my) || 0; pick = m => int(m.conversation_id) === conv && (+m.created || 0) >= j; }
    else { other = number; pick = m => pair(m, app, my, number); }
    const mt = metaOf(my, app, other) || {};
    return rows.filter(m => pick(m) && !hidden(m, my) && !(mt.cleared_before && m.id <= mt.cleared_before) && (!before || m.id < before))
      .sort((a, b) => b.id - a.id).slice(0, lim).sort((a, b) => a.id - b.id).map(m => pub(m, my, rows, reacts));
  });

  const canReadMedia = (md, my) => md.owner === cid()
    || T('messages').all().some(m => m.payload && int(m.payload.mediaId) === md.id && visible(m, my) && !m.deleted_all)
    || T('mail').all().some(x => Array.isArray(x.attachments) && x.attachments.some(a => a && int(a.mediaId) === md.id))
    || T('conversations').all().some(c => int(c.avatar) === md.id && isMember(int(c.id), my))
    /* vídeo publicado nas redes (12 nov 2026, social.js): lê quem vê a publicação/story que o usa (SocialVideoCanRead no servidor) */
    || (md.kind === 'video' && !!(window.SocialVideoMock && SocialVideoMock.canRead(md.id)));

  /* limite do texto, como o textCap do server/messages.lua: 1000 nas apps antigas, e no Recado o
     Config.Recado.textMax (4000 por omissão), preso entre 1000 e 60000. Sem isto o mock cortava a
     1000 em todas as apps e divergia do servidor. */
  const textCap = app => {
    if (app !== 'recado') return 1000;
    const rc = (window.System && System.config && System.config.recado) || {};
    const n = Math.floor(Number(rc.textMax));
    return Math.max(1000, Math.min(isFinite(n) && n > 0 ? n : 4000, 60000));
  };
  /* nos grupos o limite é o da app do grupo, como o sendApp do servidor */
  const convApp = conv => { const c = T('conversations').all().find(x => int(x.id) === conv); return c && c.app ? c.app : null; };

  LocalDB.register('messages.send', d => {
    const app = str(d.app, 20) || 'sms', my = me(), conv = convArg(d);
    const to = conv > 0 ? null : str(d.to, 40);
    if (conv > 0 ? !isMember(conv, my) : !to) return { error: conv > 0 ? 'notmember' : 'target' };
    /* como o typeOf do servidor: letras/números/_/-, e 'system' só o servidor escreve */
    const type = d.type == null || d.type === '' ? 'text' : String(d.type).slice(0, 16);
    if (!/^[A-Za-z0-9_-]+$/.test(type) || type === 'system') return { error: 'badtype' };
    if (!conv && blockedByMe(to) && (app === 'sms' || app === 'match' || app === 'marketplace')) return { error: 'blocked' };
    const content = str(d.content, textCap(conv > 0 ? (convApp(conv) || app) : app));
    let payload = d.payload && typeof d.payload === 'object' ? d.payload : null;
    if (payload && JSON.stringify(payload).length > 365536) return { error: 'toolarge' };
    const mediaId = int(d.mediaId || (payload && payload.mediaId));
    if (type === 'audio' && !mediaId) return { error: 'badmedia' };
    if (mediaId) { const md = T('media').all().find(x => x.id === mediaId); if (!md || !md.complete || md.kind !== type || !canReadMedia(md, my)) return { error: 'badmedia' }; payload = Object.assign({}, payload || {}, { mediaId }); }
    const rid = int(d.replyTo);
    if (d.replyTo != null && !rid) return { error: 'badreply' };
    if (rid) { const r = T('messages').all().find(x => x.id === rid); if (!r || !(conv > 0 ? int(r.conversation_id) === conv : pair(r, app, my, to)) || hidden(r, my)) return { error: 'badreply' }; }
    const row = T('messages').insert({ app, sender: my, receiver: conv > 0 ? 'g:' + conv : to, type, content, payload, read: true, created: now(), reply_to: rid || null, conversation_id: conv > 0 ? conv : null,
      delivered_at: null, read_at: null, edited_at: null, deleted_sender: 0, deleted_receiver: 0, deleted_all: null });
    if (conv > 0) T('conversations').update(conv, { last_id: row.id });
    simulate(row, app, my, conv, to, type);
    return pub(row, my);
  });
  /* o "outro lado" do browser: entregue, a escrever…, lida e uma resposta (só a texto, como o mock antigo) */
  function simulate(row, app, my, conv, to, type) {
    if (app === 'sms' && !conv) setTimeout(() => { const r = T('messages').update(row.id, { delivered_at: now() }); if (r) Bridge.emit('messageStatus', { ids: [row.id], status: 'delivered', at: r.delivered_at, number: to, app }); }, 700);
    if (type !== 'text') return;
    if (!conv && blockedByMe(to)) return;   /* bloqueado: nada chega */
    const others = conv ? members(conv).map(x => x.member).filter(x => x !== my) : [];
    const replier = conv ? others[rnd(others.length)] : to; if (!replier) return;
    const REPL = app === 'match' ? ['Olá! 😊', 'Também gostei de ti!', 'Combinamos um café?', 'Haha, adoro isso.', 'Conta-me mais.'] : ['Ok 👍', 'Vou ver e já te digo.', 'Estou a caminho.', 'Combinado.', 'Liga-me depois.', 'Onde estás?', 'Perfeito!'];
    const delay = 1500 + rnd(2500);
    if (app === 'sms') setTimeout(() => Bridge.emit('typing', { from: replier, app, conversation: conv || undefined, on: true }), Math.max(300, delay - 1200));
    setTimeout(() => {
      const at = now();
      if (app === 'sms' && !conv) {
        const rows = T('messages').all(), ids = [];
        rows.forEach(m => { if (pair(m, app, my, to) && m.sender === my && !m.read_at) { m.read_at = at; m.delivered_at = m.delivered_at || at; ids.push(m.id); } });
        T('messages').set(rows); if (ids.length) Bridge.emit('messageStatus', { ids, status: 'read', at, number: to, app });
      }
      /* grupo: como o servidor, "este membro leu até upTo" (a NUI decide quando estão todos) */
      if (conv) { const ms = T('conversation_members').all(); ms.forEach(x => { if (int(x.conversation_id) === conv && x.member === replier) x.last_read_id = Math.max(int(x.last_read_id), row.id); }); T('conversation_members').set(ms); Bridge.emit('messageStatus', { conversation: conv, ids: [row.id], status: 'read', at, who: replier, upTo: row.id }); }
      if (app === 'sms') Bridge.emit('typing', { from: replier, app, conversation: conv || undefined, on: false });
      const r = T('messages').insert({ app, sender: replier, receiver: conv ? 'g:' + conv : my, type: 'text', content: REPL[rnd(REPL.length)], payload: null, read: false, created: now(), reply_to: null, conversation_id: conv || null,
        delivered_at: at, read_at: null, edited_at: null, deleted_sender: 0, deleted_receiver: 0, deleted_all: null });
      if (!conv) { Bridge.emit('message', pub(r, me())); return; }
      if (!isMember(conv, me())) return;   /* saí do grupo entretanto: já não recebo */
      /* grupo, como o GroupSend do servidor: o push leva group e muted = true a quem silenciou o grupo; a notificação
         é da NUI (Bridge.on('message') lá em cima), como nas SMS 1:1 - o servidor já não manda NotifyPlayer */
      const c = T('conversations').all().find(x => int(x.id) === conv) || {}, mt = metaOf(me(), app, 'g:' + conv) || {};
      const quiet = (+mt.muted_until || 0) > now() || blockedByMe(replier);
      Bridge.emit('message', Object.assign(pub(r, me()), { group: { id: conv, title: c.title || 'Grupo', avatar: int(c.avatar) || null } }, quiet ? { muted: true } : {}));
    }, delay);
  }

  LocalDB.register('messages.read', d => {
    const app = str(d.app, 20) || 'sms', my = me(), conv = convArg(d);
    if (conv > 0) {
      if (!isMember(conv, my)) return { ok: false, error: 'notmember' };
      const max = T('messages').all().filter(m => int(m.conversation_id) === conv).reduce((a, m) => Math.max(a, m.id), 0);
      const ms = T('conversation_members').all(); ms.forEach(x => { if (int(x.conversation_id) === conv && x.member === my) x.last_read_id = Math.max(int(x.last_read_id), max); }); T('conversation_members').set(ms);
      return { ok: true };
    }
    const number = str(d.number, 40), at = now(), rows = T('messages').all();
    rows.forEach(m => { if (pair(m, app, my, number) && m.sender === number && !m.read) { m.read = true; m.read_at = at; } });
    T('messages').set(rows); return { ok: true };
  });

  /* { number | conversation, app, on } - no servidor é limitado por typingMs (só o on:true; o on:false passa sempre) */
  const typed = {};
  LocalDB.register('messages.typing', d => {
    const conv = convArg(d), number = str(d.number, 40);
    if (conv > 0 ? !isMember(conv, me()) : !number) return { ok: false, error: conv > 0 ? 'notmember' : 'target' };
    const k = conv > 0 ? 'g:' + conv : number;
    if (d.on) { if (now() - (typed[k] || 0) < CFG.typingMs - 200) return { ok: true, throttled: true }; typed[k] = now(); } else delete typed[k];
    return { ok: true };
  });

  LocalDB.register('messages.react', d => {
    const my = me(), id = int(d.id), m = T('messages').all().find(x => x.id === id);
    if (!m || !visible(m, my) || hidden(m, my)) return { ok: false, error: 'notfound' };
    if (m.deleted_all) return { ok: false, error: 'deleted' };
    const raw = d.emoji == null || d.emoji === '' || d.emoji === false ? null : String(d.emoji);
    /* como o reactionOf do servidor: '❤' sem o seletor de variação (U+FE0F) é o mesmo coração e grava-se '❤️' */
    let emoji = raw && (CFG.reactions.find(e => e === raw || e.replace(/️/g, '') === raw) || null);
    /* Recado: como o recadoReactionOf do servidor, qualquer emoji curto (sem letras/ASCII) além dos rápidos */
    if (raw && !emoji && m.app === 'recado' && raw.length <= 16 && !/[\x00-\x7F]/.test(raw)) emoji = raw;
    if (raw && !emoji) return { ok: false, error: 'badreaction' };
    T('message_reactions').remove(x => x.message_id === id && x.who === my);
    if (emoji) T('message_reactions').insert({ message_id: id, who: my, emoji, created: now() });
    return { ok: true, id, reactions: T('message_reactions').all().filter(x => x.message_id === id).map(x => ({ emoji: x.emoji, who: x.who, mine: x.who === my })) };
  });

  LocalDB.register('messages.edit', d => {
    const my = me(), id = int(d.id), m = T('messages').all().find(x => x.id === id);
    if (!m || !visible(m, my) || hidden(m, my)) return { ok: false, error: 'notfound' };
    if (m.sender !== my) return { ok: false, error: 'notsender' };
    if (m.deleted_all) return { ok: false, error: 'deleted' };
    if ((m.type || 'text') !== 'text') return { ok: false, error: 'nottext' };
    if (now() - m.created > CFG.editWindowMin * 60000) return { ok: false, error: 'window' };
    const content = str(d.content, textCap(m.app || 'sms')).trim(); if (!content) return { ok: false, error: 'empty' };
    if (content === m.content) return { ok: true, id, content };
    const at = now(); T('messages').update(id, { content, edited_at: at });
    return { ok: true, id, content, editedAt: at };
  });

  /* { id, scope = 'me' | 'all' }. SEM scope é o pedido antigo (antes da Fase 2): só o remetente, apaga a linha. */
  LocalDB.register('messages.delete', d => {
    const my = me(), id = int(d.id), rows = T('messages').all(), m = rows.find(x => x.id === id);
    if (d.scope != null && d.scope !== 'me' && d.scope !== 'all') return { ok: false, error: 'badscope' };
    if (!m || !visible(m, my) || hidden(m, my)) return { ok: false, error: 'notfound' };
    /* as mensagens de sistema do grupo são o registo do grupo: quem fez a ação não as tira aos outros (só scope 'me') */
    if (m.type === 'system' && d.scope !== 'me') return { ok: false, error: 'unsupported' };
    if (d.scope == null) { if (m.sender !== my) return { ok: false, error: 'notsender' }; T('messages').remove(m.id); T('message_reactions').remove(x => x.message_id === id); return { ok: true }; }
    if (d.scope === 'me') {
      /* grupo: a linha é uma só para todos os membros - como no servidor, só o remetente a esconde para si */
      if (m.conversation_id) { if (m.sender !== my) return { ok: false, error: 'unsupported' }; m.deleted_sender = 1; }
      else { if (m.sender === my) m.deleted_sender = 1; if (m.receiver === my) m.deleted_receiver = 1; }
      T('messages').set(rows); return { ok: true };
    }
    if (m.sender !== my) return { ok: false, error: 'notsender' };
    if (m.deleted_all) return { ok: true, deleted: true };
    if (now() - m.created > CFG.deleteForAllMin * 60000) return { ok: false, error: 'window' };
    m.deleted_all = now(); m.content = ''; m.payload = null; T('messages').set(rows);
    T('message_reactions').remove(x => x.message_id === id);
    return { ok: true, deleted: true };
  });

  LocalDB.register('messages.clear', d => {
    const app = str(d.app, 20) || 'sms', my = me(), conv = convArg(d), number = str(d.number, 40);
    if (conv > 0 ? !isMember(conv, my) : !number) return { ok: false, error: conv > 0 ? 'notmember' : 'target' };
    const pick = conv > 0 ? (m => int(m.conversation_id) === conv) : (m => pair(m, app, my, number));
    const max = T('messages').all().filter(pick).reduce((a, m) => Math.max(a, m.id), 0);
    if (!max) return { ok: true };
    /* as não lidas até aí deixam de contar (read sem read_at: quem enviou não recebe "Lida" por eu ter limpo) */
    if (conv > 0) { const ms = T('conversation_members').all(); ms.forEach(x => { if (int(x.conversation_id) === conv && x.member === my) x.last_read_id = Math.max(int(x.last_read_id), max); }); T('conversation_members').set(ms); }
    else { const rows = T('messages').all(); rows.forEach(m => { if (pair(m, app, my, number) && m.sender === number && !m.read && m.id <= max) m.read = true; }); T('messages').set(rows); }
    setMeta(my, app, conv > 0 ? 'g:' + conv : number, { cleared_before: max, pinned_msg: null });
    return { ok: true, clearedBefore: max };
  });

  LocalDB.register('thread.set', d => {
    const app = str(d.app, 20) || 'sms', my = me(), conv = convArg(d), number = str(d.number, 40);
    if (conv > 0 ? !isMember(conv, my) : !number) return { ok: false, error: conv > 0 ? 'notmember' : 'target' };
    const patch = {};
    /* um null do JSON chega ao Lua como "não veio": null aqui também não mexe (tirar = false ou 0) */
    if (d.pinned != null) patch.pinned = (d.pinned === true || d.pinned === 1) ? 1 : 0;
    if (d.mutedUntil != null) {
      const v = d.mutedUntil;
      if (v === true || v === -1) patch.muted_until = MUTE_FOREVER;
      else if (v === false || +v === 0) patch.muted_until = null;
      else { const u = +v; if (!isFinite(u)) return { ok: false, error: 'invalid' }; patch.muted_until = u > now() ? Math.floor(Math.min(u, MUTE_FOREVER)) : null; }
    }
    if (d.pinnedMsg != null) {
      const pm = d.pinnedMsg === false ? 0 : int(d.pinnedMsg);
      if (pm > 0) { const m = T('messages').all().find(x => x.id === pm); if (!m || !(conv > 0 ? int(m.conversation_id) === conv : pair(m, app, my, number)) || m.deleted_all || hidden(m, my)) return { ok: false, error: 'notfound' }; patch.pinned_msg = pm; }
      else patch.pinned_msg = null;
    }
    const r = setMeta(my, app, conv > 0 ? 'g:' + conv : number, patch);
    return { ok: true, pinned: !!r.pinned, mutedUntil: r.muted_until || null, pinnedMsg: r.pinned_msg || null };
  });

  LocalDB.register('presence.get', d => {
    const out = {}; (Array.isArray(d.numbers) ? d.numbers : []).slice(0, 50).forEach(n => { const k = str(n, 20); if (k) out[k] = presenceOf(k); });
    return out;
  });

  /* blocks.* não se registam aqui: o dono é o phone.js (M5), na mesma tabela 'blocks' { owner, number, created }.
     (Havia uma cópia condicional que, para saber se o outro existia, chamava o LocalDB.rpc ao carregar o script.) */

  /* ---------- media aos bocados ----------
     Os envios a meio ficam SÓ em memória (cada bocado reescrever a tabela inteira no localStorage era
     centenas de KB por pedido); a tabela guarda no máximo 8 ficheiros completos, por causa da quota. */
  const uploads = new Map();
  /* a lista branca e o formato do server/media.lua: mime base (sem ;codecs), pedaços por ordem a começar em 1,
     `size` = caracteres enviados, o que fica guardado é sempre um data: URL */
  const MIME = { 'image/jpeg': 'image', 'image/png': 'image', 'image/webp': 'image', 'audio/webm': 'audio', 'audio/ogg': 'audio', 'audio/mp4': 'audio' };
  LocalDB.register('media.begin', d => {
    const kind = d.kind === 'image' || d.kind === 'audio' ? d.kind : null; if (!kind) return { error: 'badkind' };
    const mime = String(d.mime == null ? '' : d.mime).slice(0, 80).trim().split(';')[0].toLowerCase(); if (MIME[mime] !== kind) return { error: 'badmime' };
    const size = int(d.size); if (size < 1) return { error: 'badsize' };
    let max = kind === 'image' ? MEDIA.maxImageBytes : MEDIA.maxAudioBytes;
    /* Recado: fotos "HD" até Config.Recado.hdImageBytes (como o media.begin do servidor) */
    if (kind === 'image' && (d.hd === true || (d.meta && d.meta.hd === true))) { const rc = (window.System && System.config && System.config.recado) || {}; const hd = Math.min(4000000, int(rc.hdImageBytes) || 520000); if (hd > max) max = hd; }
    if (size > max) return { error: 'toolarge', max };
    let duration = null;
    if (kind === 'audio' && d.duration != null) { duration = int(d.duration); if (duration < 0) return { error: 'badduration' }; if (duration > MEDIA.maxAudioSec * 1000 + 1500) return { error: 'toolong', maxSec: MEDIA.maxAudioSec }; }
    const meta = d.meta && typeof d.meta === 'object' ? d.meta : null; if (meta && JSON.stringify(meta).length > 2000) return { error: 'toolarge' };
    const id = Math.max(int(G.get('mock:mediaSeq', 0)), T('media').all().reduce((a, x) => Math.max(a, int(x.id)), 0)) + 1; G.set('mock:mediaSeq', id);
    uploads.set(id, { id, owner: cid(), kind, mime, size, duration, meta, parts: [], total: 0, next: 1, len: 0, lastLen: 0, created: now() });
    return { id, chunk: MEDIA.chunkBytes };
  });
  LocalDB.register('media.upload', d => {
    const id = int(d.id), u = uploads.get(id); if (!u || u.owner !== cid()) return { error: 'notfound' };
    const i = int(d.i), total = int(d.total);
    if (typeof d.data !== 'string' || !d.data.length || !i || !total) return { error: 'badchunk' };
    if (total < Math.ceil(u.size / MEDIA.chunkBytes) || total > 512 || i < 1 || i > total || (u.total && u.total !== total)) return { error: 'badchunk' };
    if (d.data.length > MEDIA.chunkBytes) return { error: 'toolarge', chunk: MEDIA.chunkBytes };
    if (i < u.next) return i === u.next - 1 && d.data.length === u.lastLen ? { ok: true, i, dup: true } : { error: 'order', expected: u.next };
    if (i !== u.next) return { error: 'order', expected: u.next };
    if (u.len + d.data.length > u.size) { uploads.delete(id); return { error: 'toolarge' }; }
    u.total = total; u.parts[i - 1] = d.data; u.len += d.data.length; u.lastLen = d.data.length; u.next = i + 1;
    return { ok: true, i };
  });
  LocalDB.register('media.finish', d => {
    const id = int(d.id), u = uploads.get(id); if (!u || u.owner !== cid()) return { error: 'notfound' };
    if (!u.total || u.next - 1 !== u.total) return { error: 'missing', expected: u.next };
    let data = u.parts.join('');
    uploads.delete(id);
    if (data.length !== u.size) return { error: 'badsize', got: data.length, size: u.size };
    const head = /^data:([^,]{1,150}),/.exec(data);
    if (head) { if (head[1].split(';')[0].toLowerCase() !== u.mime || !/;base64$/.test(head[1])) return { error: 'baddata' }; }
    const b64 = head ? data.slice(head[0].length) : data;
    if (b64.length < 8 || b64.length % 4 !== 0 || /[^A-Za-z0-9+/=]/.test(b64)) return { error: 'baddata' };
    if (!head) data = 'data:' + u.mime + ';base64,' + data;
    const rows = T('media').all(); rows.push({ id, owner: u.owner, kind: u.kind, mime: u.mime, data, size: data.length, duration: u.duration, meta: u.meta, complete: 1, created: u.created });
    while (rows.length > 8) rows.shift();
    T('media').set(rows);
    return { ok: true, id, size: data.length };
  });
  LocalDB.register('media.get', d => {
    const id = int(d.id), md = T('media').all().find(x => x.id === id && x.complete);
    /* "não existe" e "não podes" dão a mesma resposta (o servidor não revela ids) */
    if (!md || !canReadMedia(md, me())) return { error: 'notfound' };
    const total = Math.max(1, Math.ceil(md.data.length / MEDIA.chunkBytes)), i = d.i == null ? 1 : int(d.i);
    if (i < 1 || i > total) return { error: 'badchunk', total };
    return { id, kind: md.kind, mime: md.mime, duration: md.duration, meta: md.meta, i, total, size: md.data.length, data: md.data.slice((i - 1) * MEDIA.chunkBytes, i * MEDIA.chunkBytes) };
  });
})();
