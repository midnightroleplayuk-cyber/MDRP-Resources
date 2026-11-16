/* ============================================================
   RECADO · Pessoas, perfil, privacidade e grupos (pacote RC)
   Contrato: docs/ARQUITETURA.md secção 9.5 (API NUI) e 9.6 (RPCs recado.profile/privacy/contact/group.*).
   ------------------------------------------------------------
   window.RecadoPeople (e Recado.register('people', …) assim que o recado.js do RA existir):
     contactsView(win, o?)        lista dos contactos do telemóvel com foto/nome/"sobre" do perfil Recado, pesquisa,
                                  novo/editar/apagar pelos contacts.* (o.push === false devolve a vista sem a empurrar,
                                  para servir de separador; o.onPick(number) troca o "abrir conversa")
     openProfile(win, number)     perfil de um contacto: foto, nome, número, sobre, visto por último, Mensagem/Voz/
                                  Vídeo/Partilhar, bloquear, grupos em comum, media, silenciar, temporárias, bloquear conversa
     myProfile(win)               o meu perfil: foto (Fotos → media), nome, sobre, número
     privacy(win)                 visto por último, online, foto, sobre, estado, confirmações de leitura, grupos,
                                  silenciar desconhecidos, conversas bloqueadas, contactos bloqueados, temporárias por omissão
     blocked(win)                 contactos bloqueados (blocks.* da Fase 2)
     createGroup(win, o?)         → Promise<{ id, … } | null>   (o.open === true abre a conversa no fim; sem isso é quem chama)
     groupInfo(win, id)           informação do grupo (imagem, nome, descrição, convite, políticas, tema, membros,
                                  media/links/documentos, pesquisa, silenciar, temporárias, sair)
     joinByCode(win, code?)       → Promise<{ id } | null>
     unlockChat(target)           → Promise<bool>  (código do telemóvel via recado.unlock do RA)
     pickContacts(win, o)         → Promise<number[]>  (o = { multi, max, title, exclude, done })
   Extras (aditivos): media(win, target), searchGroup(win, id), lockedChats(win), profiles(numbers), avatar(o, cls),
     displayName(number, profile?), THEMES, themeOf(id), errorText(code, r)

   Regras do CEF: imagens por CSSOM (el.style.backgroundImage = UI.img(src)), nunca dentro de HTML; só transform/
   opacity animam; camadas de ecrã inteiro com border-radius 57px. Textos vindos do servidor por textContent.
   Identidade = número (o servidor decide quem é "eu"; a NUI só usa o número para mostrar e para saber quem sou).
   ============================================================ */
window.RecadoPeople = (() => {
  const g = (n, s) => Icons.g(n, s);
  const esc = UI.esc;
  /* o gradiente da base do Recado (--rc-grad do app-recado.css) com o mesmo valor por omissão */
  const GRAD = 'var(--rc-grad,linear-gradient(135deg,#128C7E,#25D366))';
  const FOREVER = 4102444800000;   /* "Sempre" nos silêncios: 1/1/2100 em ms (a coluna é BIGINT) */
  const NAME_MAX = 25, ABOUT_MAX = 139, DESC_MAX = 300, TITLE_MAX = 40;
  /* temas próprios da conversa: ids = lista branca do server/recado_people.lua = os que o recado-chat.js (RB) pinta
     (mapa THEMES dele) e as cores das amostras = as das bolhas no app-recado-chat.css. Um tema que o RB não conhece
     aparecia escolhido aqui e a conversa ficava igual. */
  const THEMES = [
    { id: '', label: 'Predefinido', a: '#128C7E', b: '#25D366' },
    { id: 'oceano', label: 'Oceano', a: '#0369A1', b: '#075E54' },
    { id: 'por-do-sol', label: 'Pôr do sol', a: '#C2410C', b: '#BE185D' },
    { id: 'floresta', label: 'Floresta', a: '#3F6212', b: '#4D7C0F' },
    { id: 'rosa', label: 'Rosa', a: '#BE185D', b: '#9D174D' },
    { id: 'grafite', label: 'Grafite', a: '#374151', b: '#1F2937' },
    { id: 'lavanda', label: 'Lavanda', a: '#6D28D9', b: '#9333EA' },
    { id: 'noite', label: 'Noite', a: '#064E3B', b: '#1E3A8A' }
  ];
  const themeOf = id => THEMES.find(t => t.id === (id === 'indigo' ? '' : (id || ''))) || THEMES[0];
  const AUD = [{ value: 'all', label: 'Todos' }, { value: 'contacts', label: 'Os meus contactos' }, { value: 'nobody', label: 'Ninguém' }];
  const audLabel = v => (AUD.find(a => a.value === v) || AUD[0]).label;
  const ABOUT_PRESETS = ['Disponível', 'Ocupado', 'No trabalho', 'A conduzir', 'Em reunião', 'A dormir', 'Só chamadas urgentes', 'Bateria fraca'];

  const arrOf = x => Array.isArray(x) ? x : (x && typeof x === 'object' && !x.error ? Object.values(x) : []);
  const norm = n => String(n == null ? '' : n).trim().slice(0, 20);
  /* a MESMA regra do cleanNumber do servidor: 3..20 de dígitos e + - . ( ) espaço, pelo menos 3 dígitos */
  const numOk = n => { const s = norm(n); return /^[0-9+\-.() ]{3,20}$/.test(s) && (s.match(/[0-9]/g) || []).length >= 3; };
  const cutc = (s, n) => [...String(s == null ? '' : s)].slice(0, n).join('');   /* por pontos de código: emoji inteiro */
  const cleanLine = s => String(s == null ? '' : s).replace(/\p{Cc}/gu, ' ').replace(/\p{Cf}/gu, '').replace(/\s+/g, ' ').trim();
  const firstName = s => String(s || '').trim().split(/\s+/)[0] || String(s || '');
  const R = () => window.Recado || null;
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const isUnknown = r => !!(r && typeof r.error === 'string' && /^unknown/.test(r.error));
  const good = r => !!r && typeof r === 'object' && !r.error && r.ok !== false;

  function myNumber() {
    try { const rc = R(); const m = rc && rc.me && rc.me(); if (m && m.number) return norm(m.number); } catch (e) {}
    const S = window.System || {};
    return norm((S.player && S.player.phone) || (S.account && S.account.phone) || '');
  }
  const winOf = w => w || (R() && R().win) || (window.System && System.windows && System.windows.recado) || null;
  function push(win, v) {
    win = winOf(win);
    if (!win) { UI.toast('Abre o Zapp primeiro'); return v; }
    UI.push(win, v); return v;
  }
  /* ouvintes que saem com a vista: no onPop E quando a vista já esteve no documento e deixou de estar (app morta) */
  function lifecycle(v) {
    const offs = []; let seen = false;
    const stop = () => { offs.splice(0).forEach(f => { try { f(); } catch (e) {} }); };
    const prev = v.opts.onPop;
    v.opts.onPop = () => { stop(); if (prev) { try { prev(); } catch (e) {} } };
    const alive = () => { if (v.isConnected) { seen = true; return true; } if (seen) { stop(); return false; } return true; };
    return { on: (ev, fn) => { offs.push(Bridge.on(ev, d => { if (alive()) fn(d); })); }, alive, stop };
  }

  /* ---------- Textos de erro (códigos do server/recado_people.lua e comuns) ---------- */
  const maxMembersCfg = () => { const m = (window.System && System.config && System.config.messages) || {}; const v = Math.floor(+m.maxGroupMembers); return v >= 2 && v <= 256 ? v : 32; };
  const ERR = {
    invalid: 'Pedido inválido.', noidentity: 'Este telemóvel não tem número.', nophone: 'Precisas de ter o telemóvel contigo.',
    name: 'O nome do grupo tem de ter entre 1 e 40 caracteres.', text: 'O texto tem caracteres que não são aceites.',
    members: r => (r && arrOf(r.privacy).length) ? 'As definições de privacidade destas pessoas não permitem adicioná-las. Envia-lhes o código de convite.' : (r && arrOf(r.skipped).length) ? 'Nenhum dos contactos escolhidos pode ser adicionado neste momento.' : 'Escolhe pelo menos um contacto.',
    toomany: r => `Um grupo pode ter no máximo ${Math.floor(+(r && r.max)) >= 2 ? Math.floor(+r.max) : maxMembersCfg()} membros (contando contigo).`,
    badnumber: r => { const l = r && arrOf(r.numbers); return l && l.length ? `Não há ninguém no Zapp com ${l.length === 1 ? 'o número' : 'os números'} ${l.slice(0, 4).map(x => String(x).slice(0, 20)).join(', ')}.` : 'Um dos números não é válido.'; },
    notfound: 'Já não fazes parte deste grupo.', notadmin: 'Só os administradores podem fazer isto.', noedit: 'Só os administradores podem editar as informações deste grupo.',
    notmember: 'Essa pessoa já não está no grupo.', lastadmin: 'O grupo precisa de um administrador. Torna outro membro administrador primeiro.',
    media: 'A foto não é válida ou ainda não acabou de enviar.', limit: r => `Já estás no número máximo de grupos${Math.floor(+(r && r.max)) > 0 ? ' (' + Math.floor(+r.max) + ')' : ''}.`,
    cooldown: 'Espera uns segundos e tenta outra vez.', busy: 'O grupo está a ser alterado por outra pessoa. Tenta outra vez.',
    db: 'Erro no servidor. Tenta outra vez.', disabled: 'O Zapp está desligado neste servidor.', badcode: 'Este código de convite não existe ou foi reposto.', self: 'Para saíres do grupo usa "Sair do grupo".',
    locked: 'Esta conversa está bloqueada. Introduz o código do telemóvel para ver o conteúdo.',
    community: 'Este é o grupo de anúncios de uma comunidade: os membros, os convites e a saída tratam-se na comunidade (separador Comunidades).',
    ratelimit: 'Demasiados pedidos seguidos. Tenta daqui a pouco.', blocked: 'Desbloqueia este contacto primeiro.', timeout: 'O servidor não respondeu.', rpc: 'O servidor não respondeu.'
  };
  function errorText(code, r) {
    const e = ERR[code]; if (typeof e === 'function') return e(r); if (e) return e;
    try { const rc = R(); if (rc && rc.errorText) { const t = rc.errorText(code); if (t) return t; } } catch (x) {}
    return 'Não foi possível concluir a operação.';
  }

  /* ---------- Datas e rótulos ---------- */
  function lastSeenText(ts) {
    if (!(+ts > 0)) return '';
    const d = new Date(+ts), n = new Date(), t = UI.fmtTime(d);
    if (d.toDateString() === n.toDateString()) return 'visto por último hoje às ' + t;
    const y = new Date(n); y.setDate(n.getDate() - 1);
    if (d.toDateString() === y.toDateString()) return 'visto por último ontem às ' + t;
    return 'visto por último a ' + UI.fmtDate(d, true) + ' às ' + t;
  }
  const disOptions = () => { const c = (window.System && System.config && System.config.recado) || {}; const l = Array.isArray(c.disappearing) && c.disappearing.length ? c.disappearing : [86400, 604800, 7776000]; return [0].concat(l.map(x => Math.floor(+x)).filter(x => x > 0)); };
  function disLabel(s) {
    s = Math.floor(+s) || 0; if (!s) return 'Desligado';
    if (s % 86400 === 0) { const d = s / 86400; return d === 1 ? '24 horas' : d + ' dias'; }
    if (s % 3600 === 0) return (s / 3600) + ' horas';
    return Math.round(s / 60) + ' min';
  }
  const muteText = until => until >= FOREVER - 864e5 ? 'Sempre' : 'Até ' + UI.fmtDate(new Date(until), true) + ', ' + UI.fmtTime(new Date(until));

  /* ---------- Perfis (recado.profile.get) em cache curta ---------- */
  const profCache = new Map();   /* número → { p, t } */
  const PROF_TTL = 60000;
  async function profiles(numbers, force) {
    const want = [...new Set((numbers || []).map(norm).filter(numOk))];
    const need = force ? want : want.filter(n => { const c = profCache.get(n); return !c || Date.now() - c.t > PROF_TTL; });
    for (let i = 0; i < need.length; i += 50) {
      const slice = need.slice(i, i + 50);
      let r = null; try { r = await Bridge.rpcRaw('recado.profile.get', { numbers: slice }); } catch (e) { r = null; }
      const map = r && !r.error && r.profiles && typeof r.profiles === 'object' ? r.profiles : null;
      if (!map) break;   /* servidor sem resposta: fica o que havia (e as linhas mostram o número) */
      slice.forEach(n => profCache.set(n, { p: map[n] || { number: n, exists: false }, t: Date.now() }));
    }
    const out = {}; want.forEach(n => { const c = profCache.get(n); if (c) out[n] = c.p; }); return out;
  }
  const cachedProfile = n => { const c = profCache.get(norm(n)); return c ? c.p : null; };
  const contactOf = n => (window.Contacts && Contacts.byNumber) ? Contacts.byNumber(norm(n)) || null : null;
  /* nome a mostrar: o do MEU contacto; senão "~Nome" do perfil (como os mensageiros fazem com quem não está nos contactos); senão o número */
  function displayName(number, p) {
    const n = norm(number); if (n && n === myNumber()) return 'Tu';
    const c = contactOf(n); if (c && c.name) return c.name;
    p = p || cachedProfile(n);
    if (p && p.name) return '~' + p.name;
    return n || 'Desconhecido';
  }

  /* ---------- Avatares ---------- */
  const isImg = u => typeof u === 'string' && u.length < 900000 && /^data:image\/(jpeg|jpg|png|webp);base64,[A-Za-z0-9+/=]+$/i.test(u);
  const seedOf = s => [...String(s || '')].reduce((h, ch) => (h * 31 + ch.charCodeAt(0)) % 9973, 7);
  /* o = { number?, name?, mediaId?, contact?, group?, id?, urgent? } → .avatar com gradiente/iniciais; a foto entra por CSSOM */
  function avatar(o = {}, cls = '') {
    const nm = o.name || o.number || '?';
    const el = UI.el(`<div class="avatar rcp-av rc-av ${esc(cls)}"></div>`);
    /* grupo → glifo de pessoas; só um número (sem nome) → glifo de pessoa (as "iniciais" de 555-0199 eram um "5") */
    if (o.group) el.innerHTML = g('users');
    else if (!/\p{L}/u.test(String(nm))) el.innerHTML = g('person');
    else el.textContent = UI.initials(String(nm).replace(/^~/, ''));
    el.setAttribute('style', UI.avatarStyle(o.group ? (Math.floor(+o.id) || seedOf(nm)) : seedOf(o.number || nm)));
    const mid = Math.floor(+o.mediaId);
    if (mid > 0 && window.VoiceMsg && VoiceMsg.fetchMedia) {
      /* o gradiente vem no atributo style como `background:` (atalho): o atalho repõe background-size a auto, por isso
         o tamanho e a posição vão também por CSSOM (senão a foto aparecia ampliada e cortada) */
      VoiceMsg.fetchMedia(mid).then(m => { if (m && !m.error && isImg(m.dataUrl)) { el.style.backgroundImage = UI.img(m.dataUrl); el.style.backgroundSize = 'cover'; el.style.backgroundPosition = 'center'; el.classList.add('has-img'); el._img = m.dataUrl; } }).catch(() => {});
    } else if (o.contact && window.Contacts && Contacts.photoId && Contacts.photoId(o.contact)) {
      Contacts.paintAvatar(el, o.contact, !!o.urgent).then(ok => { if (ok) el.classList.add('has-img'); }).catch(() => {});
    }
    return el;
  }

  /* visualizador de foto em ecrã inteiro (camada com o raio do ecrã) */
  function photoViewer(dataUrl, title) {
    if (!isImg(dataUrl)) return;
    const ov = UI.el(`<div class="rcp-viewer"><div class="rcp-viewer-top"><div class="rcp-viewer-x">${g('x')}</div><div class="rcp-viewer-t"></div></div><div class="rcp-viewer-img"></div></div>`);
    ov.querySelector('.rcp-viewer-t').textContent = title || '';
    ov.querySelector('.rcp-viewer-img').style.backgroundImage = UI.img(dataUrl);
    const close = () => { ov.classList.remove('in'); setTimeout(() => ov.remove(), 260); };
    ov.onclick = close;
    UI.screen().appendChild(ov); requestAnimationFrame(() => ov.classList.add('in'));
  }

  /* ---------- Linhas de pessoa (lista com avatar próprio e "sobre" que chega depois) ---------- */
  function personRow(o) {
    const li = UI.item({ label: o.label, sub: o.sub == null ? '' : o.sub, chevron: false, right: o.right, onTap: o.onTap, onLong: o.onLong, cls: 'rcp-row ' + (o.cls || '') });
    li.classList.add('has-icon', 'has-big');
    const av = avatar({ number: o.number, name: o.label, contact: o.contact, mediaId: o.mediaId, group: o.group, id: o.id }, 'sm');
    li.insertBefore(av, li.firstChild);
    li._rcp = { av, number: o.number, label: o.label, contact: o.contact, mediaId: Math.floor(+o.mediaId) || 0 };
    return li;
  }
  /* o perfil chegou: foto do perfil (se o dono deixa ver) por cima da do contacto e "sobre" no subtítulo */
  function patchRow(li, p, o = {}) {
    if (!li || !li._rcp || !p) return;
    const mid = Math.floor(+p.avatar) || 0;
    if (mid && mid !== li._rcp.mediaId && !(li._rcp.contact && window.Contacts && Contacts.photoId && Contacts.photoId(li._rcp.contact))) {
      const nav = avatar({ number: li._rcp.number, name: li._rcp.label, mediaId: mid }, 'sm');
      li._rcp.av.replaceWith(nav); li._rcp.av = nav; li._rcp.mediaId = mid;
    }
    if (o.about !== false && p.about) { const s = li.querySelector('.li-sub'); if (s) s.textContent = p.about; }
  }
  function section(header, rows, footer, cls) {
    const wrap = UI.el(`<div class="list ${esc(cls || '')}"></div>`);
    if (header) { const h = UI.el('<div class="group-header"></div>'); h.textContent = header; wrap.appendChild(h); }
    if (rows.length) { const grp = UI.el('<div class="group"></div>'); rows.forEach(r => r && grp.appendChild(r)); wrap.appendChild(grp); }
    if (footer) { const f = UI.el('<div class="group-footer"></div>'); f.textContent = footer; wrap.appendChild(f); }
    return wrap;
  }
  const tileItem = (icon, label, onTap, extra) => Object.assign({ icon, iconBg: GRAD, iconColor: '#fff', label, onTap }, extra || {});

  /* ---------- Ações partilhadas ---------- */
  function openChat(target, o) {
    const rc = R();
    try {
      /* o Recado.openChat do RA trata das conversas bloqueadas (código) e do separador; o RecadoChat direto é só plano B */
      if (rc && rc.openChat) { rc.openChat(target, o || {}); return true; }
      const ch = window.RecadoChat;
      if (ch && ch.open) { ch.open(winOf(), target, o || {}); return true; }
    } catch (e) { console.error('[apex_phone] recado openChat', e); }
    UI.toast('Abre a conversa a partir do Zapp'); return false;
  }
  const callsApi = () => { const rc = R(); return (rc && rc.get && rc.get('calls')) || window.RecadoCalls || null; };
  function voiceCall(target, name) {
    const c = callsApi(); if (c && c.voice) return c.voice(target);
    if (target.number && window.PhoneApp) return PhoneApp.call(target.number, name);
    UI.toast('As chamadas não estão disponíveis');
  }
  function videoCall(target, name) {
    const c = callsApi(); if (c && c.video) return c.video(target);
    if (target.number && window.PhoneApp) return PhoneApp.call(target.number, name, { video: true });
    UI.toast('As videochamadas não estão disponíveis');
  }
  /* recado.thread.set (RA); só para o silêncio há o thread.set da Fase 2 como plano B com app = 'recado' */
  async function threadSet(target, patch) {
    let r = null; try { r = await Bridge.rpcRaw('recado.thread.set', Object.assign({}, target, patch)); } catch (e) { r = null; }
    if (isUnknown(r) && Object.keys(patch).length === 1 && patch.mutedUntil !== undefined) r = await Bridge.rpcRaw('thread.set', Object.assign({ app: 'recado' }, target, patch));
    return r;
  }
  async function askMute(title) {
    const v = await UI.actionSheet({ title, cls: 'rcp-sheet rc-sheet', buttons: [{ label: 'Durante 8 horas', value: 'h8' }, { label: 'Durante 1 semana', value: 'w1' }, { label: 'Sempre', value: 'ever' }] });
    const ms = { h8: 8 * 36e5, w1: 7 * 864e5 }[v];
    if (!ms && v !== 'ever') return null;
    return v === 'ever' ? FOREVER : Date.now() + ms;
  }
  async function sendContactCard(to, card) {
    const r = await Bridge.rpcRaw('recado.send', { number: to, type: 'contact', content: cutc(card.name || card.number, 60), payload: { name: cutc(card.name || card.number, 60), number: card.number } });
    return good(r) || (r && !r.error && r.id) ? true : (UI.toast(errorText(r && r.error, r)), false);
  }
  async function sendText(to, text) {
    const r = await Bridge.rpcRaw('recado.send', { number: to, type: 'text', content: text });
    return !!r && !r.error && r.ok !== false;
  }
  function copyText(text, msg) {
    try { if (window.Msgs) Msgs.clipboard = text; } catch (e) {}
    try { if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(text).catch(() => {}); } catch (e) {}
    UI.toast(msg || 'Copiado');
  }
  const hasPin = () => { const a = window.System && System.account; return !(a && a.hasPin === false); };

  /* ---------- Foto (Fotos → miniatura quadrada → media) ---------- */
  function seedImage(seed) {
    try {
      seed = Math.floor(+seed) || 1;
      const c = document.createElement('canvas'); c.width = c.height = 320; const x = c.getContext('2d');
      const a = ((seed * 37) % 360) * Math.PI / 180, dx = Math.sin(a) * 160, dy = -Math.cos(a) * 160;
      const gr = x.createLinearGradient(160 - dx, 160 - dy, 160 + dx, 160 + dy);
      gr.addColorStop(0, `hsl(${(seed * 53) % 360},70%,58%)`); gr.addColorStop(1, `hsl(${(seed * 53 + 110) % 360},65%,32%)`);
      x.fillStyle = gr; x.fillRect(0, 0, 320, 320); return c.toDataURL('image/jpeg', .85);
    } catch (e) { return null; }
  }
  async function pickImage(title) {
    if (!window.Photos || !Photos.pick) { UI.toast('A galeria não está disponível'); return null; }
    const p = await Photos.pick(title || 'Escolher foto'); if (!p) return null;
    let src = null; try { src = await Photos.data(p, true); } catch (e) { src = null; }
    if (!src && p.seed != null && !p.len) src = seedImage(p.seed);
    if (!src) { UI.toast('Não foi possível abrir esta foto'); return null; }
    const cap = (window.VoiceMsg && VoiceMsg.util && VoiceMsg.util.cfg().maxImageBytes) || 260000;
    let out = null; try { out = await Photos.square(src, 320, .82); if (out && out.length > cap) out = await Photos.square(src, 200, .72); } catch (e) { out = null; }
    /* uma foto guardada como link externo suja o canvas e o toDataURL falha: diz-se, em vez de enviar nada */
    if (!isImg(out) || out.length > cap) { UI.toast('Esta foto não pode ser usada'); return null; }
    return out;
  }
  async function uploadImage(dataUrl) {
    if (!window.VoiceMsg || !VoiceMsg.uploadData) return { mediaId: null, error: 'rpc' };
    return VoiceMsg.uploadData(dataUrl, { kind: 'image', mime: 'image/jpeg' });
  }

  /* ============================================================
     SELETOR DE CONTACTOS (vários ou um)
     ============================================================ */
  const ensureContacts = async () => { try { if (window.Contacts && !Contacts.cache.length) await Contacts.load(); } catch (e) {} };
  function memberPicker(o = {}) {
    const multi = o.multi !== false;
    const max = multi ? Math.max(1, Math.floor(+o.max) || 256) : 1;
    const exclude = new Set((o.exclude || []).map(norm)); exclude.add(myNumber());
    const sel = new Map();
    const root = UI.el('<div class="rcp-picker"><div class="rcp-chips"></div><div class="rcp-pick-s"></div><div class="group-header rcp-count"></div><div class="rcp-pick-list"></div></div>');
    const chips = root.querySelector('.rcp-chips'), count = root.querySelector('.rcp-count'), holder = root.querySelector('.rcp-pick-list');
    let query = '';
    root.querySelector('.rcp-pick-s').appendChild(UI.search('Pesquisar ou escrever um número', q => { query = q; paint(); }));
    const checks = new Map(), rows = new Map();
    function refresh() {
      count.textContent = multi ? `${sel.size} de ${max} ${max === 1 ? 'pessoa' : 'pessoas'}` : 'Contactos';
      checks.forEach((c, n) => c.classList.toggle('on', sel.has(n)));
      chips.innerHTML = '';
      if (multi) sel.forEach((p, n) => {
        const chip = UI.el(`<span class="rcp-chip"><b></b><i>${g('x')}</i></span>`);
        chip.querySelector('b').textContent = firstName(p.name);
        chip.onclick = () => { sel.delete(n); refresh(); };
        chips.appendChild(chip);
      });
      if (o.onChange) { try { o.onChange(sel.size); } catch (e) {} }
    }
    function toggle(p) {
      const n = norm(p.number); if (!numOk(n) || exclude.has(n)) return;
      if (!multi) { sel.clear(); sel.set(n, { name: p.name || n, number: n }); refresh(); if (o.onSingle) o.onSingle(n); return; }
      if (sel.has(n)) sel.delete(n);
      else if (sel.size >= max) { UI.toast(`Máximo de ${max} ${max === 1 ? 'pessoa' : 'pessoas'}`); return; }
      else sel.set(n, { name: p.name || n, number: n });
      refresh();
    }
    function paint() {
      holder.innerHTML = ''; checks.clear(); rows.clear();
      const seen = new Set();
      const list = ((window.Contacts && Contacts.cache) || []).filter(c => {
        if (!c || !c.number) return false; const n = norm(c.number);
        if (exclude.has(n) || seen.has(n) || !numOk(n)) return false; seen.add(n);
        return !query || String(c.name || '').toLowerCase().includes(query) || n.includes(query);
      }).sort((a, b) => String(a.name).localeCompare(String(b.name), 'pt'));
      const out = [];
      const row = (p, extra = {}) => {
        const n = norm(p.number), chk = UI.el(`<div class="rcp-check ${multi ? '' : 'single'}">${g('check')}</div>`);
        checks.set(n, chk); chk.classList.toggle('on', sel.has(n));
        const li = personRow({ number: n, label: p.name || n, sub: extra.sub != null ? extra.sub : n, contact: p.contact, right: chk, onTap: () => toggle(p) });
        rows.set(n, li); out.push(li);
      };
      const typed = norm(query);
      if (typed && numOk(typed) && !exclude.has(typed) && !seen.has(typed)) row({ name: typed, number: typed }, { sub: 'Usar este número' });
      list.forEach(c => row({ name: c.name, number: c.number, contact: c }));
      sel.forEach((p, n) => { if (!rows.has(n) && !query) row(p); });
      if (!out.length) holder.appendChild(UI.empty('users', query ? 'Sem resultados' : 'Sem contactos', query ? 'Escreve um número completo para o usar.' : 'Adiciona contactos no Telefone ou escreve um número.'));
      else holder.appendChild(section(null, out));
      const nums = [...rows.keys()];
      profiles(nums).then(ps => { nums.forEach(n => { const li = rows.get(n); if (li && li.isConnected) patchRow(li, ps[n]); }); }).catch(() => {});
    }
    paint(); refresh();
    return { el: root, selected: () => [...sel.values()], get size() { return sel.size; }, reload: paint };
  }

  async function pickContacts(win, o = {}) {
    await ensureContacts();
    const multi = !!o.multi;
    return new Promise(res => {
      let settled = false; const done = v => { if (settled) return; settled = true; res(v); };
      let sh = null;
      const picker = memberPicker({ multi, max: o.max, exclude: o.exclude, onSingle: n => { done([n]); if (sh) sh.close(); } });
      /* um só: tocar na pessoa escolhe e fecha (o botão da direita é só Cancelar, como no Contacts.pick) */
      sh = multi
        ? UI.sheet({ title: o.title || 'Escolher contactos', left: 'Cancelar', right: o.done || 'OK', body: picker.el, cls: 'rcp-sheet rc-sheet rcp-pick-sheet',
            onDone: () => { if (!picker.size) { UI.toast('Escolhe pelo menos um contacto'); return false; } done(picker.selected().map(p => p.number)); },
            onClose: () => done([]) })
        : UI.sheet({ title: o.title || 'Escolher contacto', right: 'Cancelar', body: picker.el, cls: 'rcp-sheet rc-sheet rcp-pick-sheet', onClose: () => done([]) });
    });
  }

  /* ============================================================
     CONTACTOS
     ============================================================ */
  async function newContact(preset) {
    if (typeof window.contactForm === 'function') { const r = await window.contactForm({ preset: preset || {} }); if (r) UI.toast('Contacto guardado'); return r; }
    const name = await UI.prompt('Novo contacto', 'Nome', 'Nome', (preset && preset.name) || ''); if (!name) return null;
    const number = await UI.prompt('Novo contacto', 'Número de telefone', '555-0000', (preset && preset.number) || ''); if (!number) return null;
    const r = await Contacts.save({ name: cutc(name, 64), number: cutc(number, 20) });
    if (!r || r.error) { UI.toast('Não foi possível guardar'); return null; }
    UI.toast('Contacto guardado'); return r;
  }
  async function editContact(c) {
    if (typeof window.contactForm === 'function') return window.contactForm({ contact: c });
    const name = await UI.prompt('Editar contacto', 'Nome', 'Nome', c.name); if (!name) return null;
    return Contacts.save({ id: c.id, name: cutc(name, 64) });
  }
  async function toggleBlockNumber(number, name) {
    const on = !(window.Contacts && Contacts.isBlocked(number)), who = name || number;
    const okc = on ? await UI.confirm('Bloquear ' + who + '?', 'Deixas de receber mensagens e chamadas deste número, e deixa de ver o teu visto por último, online, foto e sobre.', 'Bloquear', true, 'rcp-sheet rc-sheet')
      : await UI.confirm('Desbloquear ' + who + '?', 'Voltas a receber mensagens e chamadas deste número.', 'Desbloquear', false, 'rcp-sheet rc-sheet');
    if (!okc) return null;
    const done = on ? await Contacts.block(number) : await Contacts.unblock(number);
    if (!done) { UI.toast(on ? 'Não foi possível bloquear' : 'Não foi possível desbloquear'); return null; }
    profCache.delete(norm(number));
    UI.toast(on ? 'Bloqueado' : 'Desbloqueado'); return on;
  }

  function contactsView(win, o = {}) {
    const v = UI.view({ title: o.title || 'Contactos', back: o.push === false ? undefined : (o.back || true), cls: 'rcp rcp-contacts', right: [{ icon: 'personPlus', onTap: () => newContact().then(() => render()) }] });
    const life = lifecycle(v);
    const top = UI.el('<div class="rcp-top"></div>');
    top.appendChild(UI.search('Pesquisar nome ou número', q => { query = q; render(); }));
    const quick = UI.list([{ items: [
      tileItem('users', 'Novo grupo', () => createGroup(win, { open: true })),
      tileItem('personPlus', 'Novo contacto', () => newContact().then(() => render())),
      tileItem('link', 'Entrar com código de convite', () => joinByCode(win))
    ] }]);
    quick.classList.add('rcp-quick');
    const holder = UI.el('<div class="rcp-holder"></div>');
    v.content.append(top, quick, holder);
    let query = '', seq = 0, loaded = false;
    async function render() {
      const my = ++seq;
      if (!loaded) { loaded = true; if (window.Contacts && !Contacts.cache.length) { holder.innerHTML = ''; holder.appendChild(UI.skeleton('list', 6)); await ensureContacts(); } }
      if (my !== seq) return;
      quick.style.display = query ? 'none' : '';
      holder.innerHTML = '';
      const me = myNumber(), seen = new Set();
      const all = ((window.Contacts && Contacts.cache) || []).filter(c => { const n = norm(c && c.number); if (!n || seen.has(n) || n === me) return false; seen.add(n); return true; });
      const list = all.filter(c => !query || String(c.name || '').toLowerCase().includes(query) || norm(c.number).includes(query)).sort((a, b) => String(a.name).localeCompare(String(b.name), 'pt'));
      const rows = new Map();
      const typed = norm(query);
      if (typed && numOk(typed) && !seen.has(typed) && typed !== me) {
        holder.appendChild(section('Número', [
          personRow({ number: typed, label: typed, sub: 'Conversar com este número', onTap: () => pickOrChat(typed), right: infoBtn(typed) })
        ]));
      }
      if (!list.length) {
        if (!typed || !numOk(typed)) holder.appendChild(UI.empty('personCircle', query ? 'Sem resultados' : 'Sem contactos', query ? 'Procura por outro nome ou escreve um número.' : 'Toca em + para adicionar um contacto.'));
      } else {
        const byLetter = {};
        list.forEach(c => { const k = (String(c.name || '#').normalize('NFD').replace(/\p{M}/gu, '')[0] || '#').toUpperCase(); (byLetter[/[A-Z]/.test(k) ? k : '#'] = byLetter[/[A-Z]/.test(k) ? k : '#'] || []).push(c); });
        Object.keys(byLetter).sort((a, b) => a === '#' ? 1 : b === '#' ? -1 : a.localeCompare(b)).forEach(k => {
          holder.appendChild(section(k, byLetter[k].map(c => {
            const n = norm(c.number), bl = window.Contacts && Contacts.isBlocked(n);
            const li = personRow({ number: n, label: c.name || n, sub: bl ? 'Bloqueado' : n, contact: c, right: infoBtn(n), onTap: () => pickOrChat(n, c.name), onLong: el => rowMenu(el, c) });
            rows.set(n, li); return li;
          })));
        });
      }
      const nums = [...rows.keys()];
      if (nums.length) profiles(nums).then(ps => { if (my !== seq) return; nums.forEach(n => { const li = rows.get(n); if (li && !(window.Contacts && Contacts.isBlocked(n))) patchRow(li, ps[n]); }); }).catch(() => {});
    }
    const pickOrChat = (n, name) => { if (o.onPick) { o.onPick(n, name); return; } openChat({ number: n }); };
    const infoBtn = n => { const b = UI.el(`<div class="rcp-info nostop" aria-label="Perfil">${g('info')}</div>`); b.onclick = e => { e.stopPropagation(); openProfile(win, n); }; return b; };
    function rowMenu(el, c) {
      const n = norm(c.number), bl = window.Contacts && Contacts.isBlocked(n);
      UI.ctxMenu(el, [
        { label: 'Ver perfil', icon: 'personCircle', onTap: () => openProfile(win, n) },
        { label: 'Mensagem', icon: 'message', onTap: () => openChat({ number: n }) },
        { label: 'Chamada de voz', icon: 'phone', onTap: () => voiceCall({ number: n }, c.name) },
        { label: 'Editar contacto', icon: 'pen', onTap: () => editContact(c).then(() => render()) },
        { label: bl ? 'Desbloquear' : 'Bloquear', icon: 'ban', onTap: () => toggleBlockNumber(n, c.name).then(r => { if (r != null) render(); }) },
        { label: 'Apagar contacto', icon: 'trash', danger: true, onTap: async () => { if (await UI.confirm('Apagar contacto', c.name, 'Apagar', true, 'rcp-sheet rc-sheet')) { await Contacts.remove(c.id); render(); } } }
      ], { cls: 'rcp-sheet rc-sheet' });
    }
    life.on('contacts', () => render());
    life.on('blocks', () => render());
    render();
    if (o.push !== false) push(win, v);
    v.reload = render;
    return v;
  }

  /* ============================================================
     PERFIL DE UM CONTACTO
     ============================================================ */
  function heroEl() {
    return UI.el(`<div class="rcp-hero"><div class="rcp-ring"><div class="rcp-hero-av"></div></div><div class="rcp-hero-name"></div><div class="rcp-hero-alt"></div><div class="rcp-hero-status"></div></div>`);
  }
  function actionsRow(items) {
    const row = UI.el('<div class="rcp-actions"></div>');
    items.forEach(it => {
      if (!it) return;
      const b = UI.el(`<div class="rcp-act ${it.off ? 'off' : ''}"><div class="rcp-act-ic">${g(it.icon)}</div><span></span></div>`);
      b.querySelector('span').textContent = it.label;
      b.onclick = () => { if (it.off) { if (it.why) UI.toast(it.why); return; } it.onTap(); };
      row.appendChild(b);
    });
    return row;
  }
  function mediaStrip(onOpen) {
    const row = UI.el(`<div class="group rcp-media-row"><div class="li"><div class="li-icon" style="background:${GRAD};color:#fff">${g('photo')}</div><div class="li-body"><div class="li-label">Media, links e docs</div></div><div class="li-value rcp-media-n"></div><div class="li-chev">${g('chevR')}</div></div><div class="rcp-thumbs"></div></div>`);
    row.querySelector('.li').onclick = onOpen;
    row.querySelector('.rcp-thumbs').onclick = onOpen;
    return row;
  }
  /* estado vazio de uma conversa bloqueada: o conteúdo só vem depois do código (recado.unlock) */
  function lockedEmpty(target, retry) {
    const box = UI.el('<div class="rcp-locked-empty"></div>');
    box.appendChild(UI.empty('lock', 'Conversa bloqueada', ERR.locked));
    const b = UI.el('<div class="rcp-more">Desbloquear</div>');
    b.onclick = async () => { if (await unlockChat(target)) retry(); };
    box.appendChild(b);
    return box;
  }
  /* items = lista do recado.*.media ou 'locked' (conversa bloqueada sem o código: o servidor não dá o conteúdo) */
  function fillThumbs(row, items) {
    const box = row.querySelector('.rcp-thumbs'), n = row.querySelector('.rcp-media-n');
    box.innerHTML = '';
    if (items === 'locked') { n.textContent = 'Bloqueada'; box.classList.add('empty'); return; }
    const imgs = items.filter(i => i && (i.mediaId || i.seed)).slice(0, 4);
    n.textContent = items.length ? (items.length >= 60 ? '60+' : String(items.length)) : 'Nenhum';
    box.classList.toggle('empty', !imgs.length);
    imgs.forEach(i => {
      const t = UI.el('<div class="rcp-thumb"></div>');
      if (i.mediaId && window.VoiceMsg) VoiceMsg.fetchMedia(i.mediaId).then(m => { if (m && !m.error && isImg(m.dataUrl)) { t.style.backgroundImage = UI.img(m.dataUrl); t.classList.add('has-img'); } }).catch(() => {});
      else if (i.seed && window.photoBg) t.style.backgroundImage = photoBg(i.seed);
      box.appendChild(t);
    });
  }

  function openProfile(win, number, o = {}) {
    number = norm(number);
    if (number && number === myNumber()) return myProfile(win);
    const v = UI.view({ title: '', back: o.back || true, cls: 'rcp rcp-profile' });
    const life = lifecycle(v);
    const hero = heroEl(), body = UI.el('<div class="rcp-page"></div>');
    v.content.append(hero, body);
    body.appendChild(UI.skeleton('list', 4));
    let info = null, seq = 0, mediaItems = null;
    const heroAv = hero.querySelector('.rcp-hero-av');

    async function load() {
      const my = ++seq;
      const r = await Bridge.rpcRaw('recado.contact.info', { number });
      if (my !== seq) return;
      if (!r || r.error) {
        hero.querySelector('.rcp-hero-name').textContent = displayName(number);
        body.innerHTML = ''; body.appendChild(UI.empty('personCircle', 'Não foi possível abrir o perfil', errorText(r && r.error, r)));
        return;
      }
      info = r;
      profCache.set(number, { p: { number, exists: r.exists, name: r.name, about: r.about, avatar: r.avatar, online: r.online, lastSeen: r.lastSeen, status: r.status }, t: Date.now() });
      render();
      if (!mediaItems) Bridge.rpcRaw('recado.contact.media', { number, kind: 'media' }).then(m => { mediaItems = good(m) ? arrOf(m.items) : (m && m.error === 'locked' ? 'locked' : []); if (v.isConnected) paintMedia(); }).catch(() => {});
    }
    function paintMedia() { const row = body.querySelector('.rcp-media-row'); if (row && mediaItems) fillThumbs(row, mediaItems); }
    function render() {
      if (!info) return;
      const top = v.content.scrollTop;
      const c = info.contact || contactOf(number);
      const name = (c && c.name) || (info.name ? '~' + info.name : number);
      heroAv.innerHTML = '';
      const av = avatar({ number, name, mediaId: info.avatar, contact: info.avatar ? null : c, urgent: true }, 'xl');
      heroAv.appendChild(av);
      heroAv.onclick = () => { if (av._img) photoViewer(av._img, name); };
      hero.querySelector('.rcp-hero-name').textContent = name;
      const alt = hero.querySelector('.rcp-hero-alt');
      alt.textContent = (c && c.name && info.name && info.name !== c.name) ? `${number} · ~${info.name}` : number;
      const st = hero.querySelector('.rcp-hero-status');
      st.classList.toggle('online', info.online === true);
      st.textContent = info.blocked ? 'Bloqueado' : info.online === true ? 'online' : lastSeenText(info.lastSeen);
      if (!info.exists) st.textContent = 'Este número não usa o Zapp';

      body.innerHTML = '';
      body.appendChild(actionsRow([
        { icon: 'message', label: 'Mensagem', onTap: () => openChat({ number }), off: info.blocked, why: 'Desbloqueia este contacto para lhe escreveres' },
        { icon: 'phone', label: 'Voz', onTap: () => voiceCall({ number }, name) },
        { icon: 'video', label: 'Vídeo', onTap: () => videoCall({ number }, name) },
        { icon: 'share', label: 'Partilhar', onTap: shareThis }
      ]));
      if (info.about) {
        const card = UI.el('<div class="rcp-card"><div class="rcp-card-k">Sobre</div><div class="rcp-card-v"></div></div>');
        card.querySelector('.rcp-card-v').textContent = info.about;
        body.appendChild(card);
      }
      body.appendChild(section(null, [UI.item({ label: 'Telemóvel', value: number, chevron: false, onTap: () => copyText(number, 'Número copiado') })]));
      const mrow = mediaStrip(() => media(win, { number }, name));
      const wrapM = UI.el('<div class="list"></div>'); wrapM.appendChild(mrow); body.appendChild(wrapM);
      paintMedia();

      const mutedOn = +info.mutedUntil > Date.now();
      body.appendChild(UI.list([
        { items: [
          { icon: mutedOn ? 'bellOff' : 'bell', iconBg: GRAD, iconColor: '#fff', label: 'Silenciar notificações', toggle: mutedOn, onToggle: setMute },
          tileItem('timer', 'Mensagens temporárias', setDisappearing, { value: disLabel(info.disappearing) }),
          { icon: 'lock', iconBg: GRAD, iconColor: '#fff', label: 'Bloquear conversa', toggle: !!info.locked, onToggle: setLocked }
        ], footer: mutedOn ? 'Silenciada: ' + muteText(+info.mutedUntil) + '.' : (info.locked ? 'A conversa só abre com o código do telemóvel.' : undefined) }
      ]));
      const common = arrOf(info.groupsInCommon);
      if (common.length) body.appendChild(section(`${common.length} ${common.length === 1 ? 'grupo' : 'grupos'} em comum`, common.map(gr =>
        personRow({ group: true, id: gr.id, label: gr.title || 'Grupo', sub: `${gr.memberCount || 0} membros`, mediaId: gr.avatar, onTap: () => groupInfo(win, gr.id), right: `<div class="li-chev">${g('chevR')}</div>` }))));
      body.appendChild(UI.list([{ items: [c && c.id != null
        ? { label: 'Editar contacto', cls: 'rcp-blue', chevron: false, onTap: () => editContact(c).then(() => load()) }
        : { label: 'Adicionar aos contactos', cls: 'rcp-blue', chevron: false, onTap: () => newContact({ number, name: info.name || '' }).then(() => load()) }] }]));
      body.appendChild(UI.list([{ items: [{ label: info.blocked ? 'Desbloquear ' + firstName(name) : 'Bloquear ' + firstName(name), cls: info.blocked ? 'rcp-blue' : 'danger', chevron: false, onTap: async () => { if (await toggleBlockNumber(number, name) != null) load(); } }] }]));
      v.content.scrollTop = top;
    }
    async function setMute(on) {
      const until = on ? await askMute('Silenciar ' + displayName(number)) : 0;
      if (on && !until) { render(); return; }
      const r = await threadSet({ number }, { mutedUntil: until });
      if (!r || r.error || r.ok === false) { UI.toast('Não foi possível alterar o silêncio'); render(); return; }
      info.mutedUntil = r.mutedUntil != null ? +r.mutedUntil : until; render();
      UI.toast(on ? 'Notificações silenciadas' : 'Notificações ativadas');
    }
    async function setDisappearing() {
      const val = await UI.picker('Mensagens temporárias', disOptions().map(s => ({ value: s, label: disLabel(s) })), Math.floor(+info.disappearing) || 0, 'rcp-sheet rc-sheet');
      if (val === undefined || val === (Math.floor(+info.disappearing) || 0)) return;
      const r = await threadSet({ number }, { disappearing: val });
      if (!r || r.error || r.ok === false) { UI.toast(isUnknown(r) ? 'Indisponível neste servidor' : errorText(r && r.error, r)); return; }
      info.disappearing = val; render();
      UI.toast(val ? 'Mensagens temporárias: ' + disLabel(val) : 'Mensagens temporárias desligadas');
    }
    async function setLocked(on) {
      if (!on && !(await unlockChat({ number }))) { render(); return; }
      if (on && !hasPin()) UI.toast('Define um código do telemóvel para proteger conversas bloqueadas', 2600);
      const r = await threadSet({ number }, { locked: !!on });
      if (!r || r.error || r.ok === false) { UI.toast(isUnknown(r) ? 'Indisponível neste servidor' : errorText(r && r.error, r)); render(); return; }
      /* a media da conversa passa a abrir (ou a fechar): volta a pedir-se */
      info.locked = !!on; mediaItems = null; render(); load();
    }
    async function shareThis() {
      const c = info && (info.contact || contactOf(number));
      const card = { name: (c && c.name) || info.name || number, number };
      const to = await pickContacts(win, { multi: true, max: 5, title: 'Partilhar contacto com', exclude: [number], done: 'Enviar' });
      if (!to.length) return;
      let n = 0; for (const t of to) { if (await sendContactCard(t, card)) n++; }
      if (n) UI.toast(n === 1 ? 'Contacto enviado' : `Contacto enviado a ${n} pessoas`);
    }
    life.on('blocks', () => load());
    life.on('contacts', () => { if (info) render(); });
    push(win, v); load();
    v.reload = load;
    return v;
  }

  /* ============================================================
     O MEU PERFIL
     ============================================================ */
  function myProfile(win) {
    const v = UI.view({ title: 'Perfil', back: true, cls: 'rcp rcp-me' });
    const hero = UI.el(`<div class="rcp-hero me"><div class="rcp-ring big"><div class="rcp-hero-av"></div><div class="rcp-cam">${g('camera')}</div></div><div class="rcp-hero-name"></div><div class="rcp-hero-alt"></div></div>`);
    const body = UI.el('<div class="rcp-page"></div>');
    v.content.append(hero, body);
    body.appendChild(UI.skeleton('list', 3));
    let me = null, busy = false;
    const heroAv = hero.querySelector('.rcp-hero-av');
    async function load() {
      const r = await Bridge.rpcRaw('recado.profile.me', {});
      if (!r || r.error) { body.innerHTML = ''; body.appendChild(UI.empty('personCircle', 'Não foi possível abrir o perfil', errorText(r && r.error, r))); return; }
      me = r; render();
      Bridge.emit('recado:profile', { number: me.number, name: me.name, about: me.about, avatarMedia: me.avatarMedia });
    }
    function render() {
      if (!me) return;
      const nm = me.name || me.suggestedName || me.number;
      heroAv.innerHTML = '';
      const av = avatar({ number: me.number, name: nm, mediaId: me.avatarMedia, urgent: true }, 'xxl');
      heroAv.appendChild(av);
      hero.querySelector('.rcp-ring').classList.toggle('is-busy', busy);
      hero.querySelector('.rcp-ring').onclick = changePhoto;
      hero.querySelector('.rcp-hero-name').textContent = me.name || 'Sem nome';
      hero.querySelector('.rcp-hero-alt').textContent = me.number;
      body.innerHTML = '';
      const l = UI.list([
        { items: [
          tileItem('person', 'Nome', editName, { sub: me.name || 'Toca para escolher o teu nome' }),
          tileItem('chat', 'Sobre', editAbout, { sub: me.about || 'Escreve algo sobre ti' }),
          tileItem('phone', 'Telemóvel', () => copyText(me.number, 'Número copiado'), { sub: me.number, chevron: false })
        ], footer: 'O teu nome aparece a quem recebe mensagens tuas. A foto e o "sobre" seguem as tuas definições de privacidade.' },
        { items: [
          tileItem('share', 'Partilhar o meu contacto', shareMe),
          tileItem('lock', 'Privacidade', () => privacy(win))
        ] }
      ]);
      /* o "sobre" e o nome podem ser longos: o subtítulo mostra-os inteiros */
      l.querySelectorAll('.li-sub').forEach((s, i) => { if (i < 2) s.classList.add('rcp-wrap'); });
      body.appendChild(l);
    }
    async function save(patch, okMsg) {
      const r = await Bridge.rpcRaw('recado.profile.set', patch);
      if (!r || r.error || r.ok === false) { UI.alert({ title: 'Não foi possível guardar', msg: errorText(r && r.error, r), cls: 'rcp-sheet rc-sheet' }); return false; }
      me = r; render(); if (okMsg) UI.toast(okMsg);
      profCache.delete(norm(me.number));
      Bridge.emit('recado:profile', { number: me.number, name: me.name, about: me.about, avatarMedia: me.avatarMedia });
      return true;
    }
    async function editName() {
      if (!me) return;
      const r = await UI.alert({ title: 'O teu nome', msg: 'Até 25 caracteres.', cls: 'rcp-sheet rc-sheet', input: { placeholder: 'Nome', value: me.name || me.suggestedName || '', maxlength: NAME_MAX }, buttons: [{ label: 'Cancelar', value: false }, { label: 'Guardar', bold: true, value: true }] });
      if (!r.value) return;
      const name = cutc(cleanLine(r.text), NAME_MAX);
      if (name === (me.name || '')) return;
      await save({ name }, name ? 'Nome guardado' : 'Nome removido');
    }
    function editAbout() {
      if (!me) return;
      const body2 = UI.el(`<div class="rcp-about-ed"><div class="group"><div class="li static"><input type="text" class="rcp-about-in" placeholder="Sobre"></div></div><div class="group-footer rcp-about-n"></div><div class="group-header">Sugestões</div></div>`);
      const inp = body2.querySelector('input'), cnt = body2.querySelector('.rcp-about-n');
      inp.maxLength = ABOUT_MAX * 2; inp.value = me.about || '';
      const count = () => { const n = [...inp.value].length; cnt.textContent = `${n}/${ABOUT_MAX}`; cnt.classList.toggle('over', n > ABOUT_MAX); };
      inp.addEventListener('input', count); count();
      const presets = UI.list([{ items: ABOUT_PRESETS.map(p => ({ label: p, chevron: false, value: (me.about === p ? '✓' : ''), onTap: () => { inp.value = p; count(); } })) }]);
      body2.appendChild(presets);
      const sh = UI.sheet({ title: 'Sobre', left: 'Cancelar', right: 'Guardar', body: body2, cls: 'rcp-sheet rc-sheet', onDone: () => {
        const val = cleanLine(inp.value);
        if ([...val].length > ABOUT_MAX) { UI.toast(`No máximo ${ABOUT_MAX} caracteres`); return false; }
        save({ about: val }, 'Sobre guardado').then(okS => { if (okS) sh.close(); });
        return false;
      } });
      setTimeout(() => { try { inp.focus(); } catch (e) {} }, 380);
    }
    async function changePhoto() {
      if (!me || busy) return;
      const buttons = [{ label: 'Escolher das Fotos', value: 'pick' }];
      if (me.avatarMedia) buttons.push({ label: 'Ver foto', value: 'view' }, { label: 'Remover foto', value: 'rm', danger: true });
      const val = await UI.actionSheet({ title: 'Foto de perfil', cls: 'rcp-sheet rc-sheet', buttons });
      if (val === 'view') { const a = heroAv.querySelector('.rcp-av'); if (a && a._img) photoViewer(a._img, me.name || me.number); return; }
      if (val === 'rm') { busy = true; render(); await save({ avatarMedia: 0 }, 'Foto removida'); busy = false; render(); return; }
      if (val !== 'pick') return;
      const d = await pickImage('Foto de perfil'); if (!d) return;
      busy = true; render();
      const up = await uploadImage(d);
      if (!up || !up.mediaId) { busy = false; render(); UI.alert({ title: 'Foto de perfil', msg: (window.VoiceMsg ? VoiceMsg.errorText(up && up.error, 'Não foi possível enviar a foto.') : 'Não foi possível enviar a foto.'), cls: 'rcp-sheet rc-sheet' }); return; }
      await save({ avatarMedia: up.mediaId }, 'Foto atualizada');
      busy = false; render();
    }
    async function shareMe() {
      if (!me) return;
      const to = await pickContacts(win, { multi: true, max: 5, title: 'Partilhar o meu contacto', done: 'Enviar' });
      if (!to.length) return;
      let n = 0; for (const t of to) { if (await sendContactCard(t, { name: me.name || me.number, number: me.number })) n++; }
      if (n) UI.toast(n === 1 ? 'Contacto enviado' : `Contacto enviado a ${n} pessoas`);
    }
    push(win, v); load();
    v.reload = load;
    return v;
  }

  /* ============================================================
     PRIVACIDADE
     ============================================================ */
  function privacy(win) {
    const v = UI.view({ title: 'Privacidade', back: true, cls: 'rcp rcp-privacy' });
    const life = lifecycle(v);
    const holder = UI.el('<div class="rcp-holder"></div>');
    v.content.appendChild(holder);
    holder.appendChild(UI.skeleton('list', 6));
    let p = null;
    async function load() {
      const r = await Bridge.rpcRaw('recado.privacy.get', {});
      if (!r || r.error) { holder.innerHTML = ''; holder.appendChild(UI.empty('lock', 'Não foi possível abrir a privacidade', errorText(r && r.error, r))); return; }
      p = r; render();
    }
    async function set(patch) {
      const before = Object.assign({}, p); Object.assign(p, patch); render();
      const r = await Bridge.rpcRaw('recado.privacy.set', patch);
      if (!r || r.error || r.ok === false) { p = before; render(); UI.toast(errorText(r && r.error, r)); return false; }
      p = r; render(); return true;
    }
    const pick = async (title, field) => { const val = await UI.picker(title, AUD, p[field], 'rcp-sheet rc-sheet'); if (val !== undefined && val !== p[field]) set({ [field]: val }); };
    function render() {
      if (!p) return;
      const top = v.content.scrollTop;
      holder.innerHTML = '';
      const nBlocked = (window.Contacts && Contacts.blocked.length) || 0;
      holder.appendChild(UI.list([
        { header: 'Quem pode ver os meus dados', items: [
          tileItem('clock', 'Visto por último', () => pick('Visto por último', 'lastSeen'), { value: audLabel(p.lastSeen) }),
          tileItem('dot', 'Online', () => pick('Online', 'online'), { value: audLabel(p.online) }),
          tileItem('personCircle', 'Foto de perfil', () => pick('Foto de perfil', 'photo'), { value: audLabel(p.photo) }),
          tileItem('chat', 'Sobre', () => pick('Sobre', 'about'), { value: audLabel(p.about) }),
          tileItem('sparkles', 'Atualizações', () => pick('Atualizações', 'status'), { value: audLabel(p.status) })
        ], footer: 'Se não partilhares o teu visto por último ou o online, também não vês os dos outros. Quem bloqueaste nunca vê estes dados.' },
        { items: [{ icon: 'checkCircle', iconBg: GRAD, iconColor: '#fff', label: 'Confirmações de leitura', toggle: p.readReceipts !== false, onToggle: on => set({ readReceipts: !!on }) }],
          footer: 'Com esta opção desligada, quem te escreve não fica a saber quando leste as mensagens.' },
        { header: 'Grupos', items: [tileItem('users', 'Quem me adiciona', async () => { const val = await UI.picker('Quem me pode adicionar a grupos', AUD, p.groupsAdd, 'rcp-sheet rc-sheet'); if (val !== undefined && val !== p.groupsAdd) set({ groupsAdd: val }); }, { value: audLabel(p.groupsAdd) })],
          footer: 'Quem não te puder adicionar pode enviar-te um código de convite.' },
        { header: 'Mensagens temporárias', items: [tileItem('timer', 'Por omissão', async () => { const val = await UI.picker('Mensagens temporárias por omissão', disOptions().map(s => ({ value: s, label: disLabel(s) })), Math.floor(+p.defaultDisappearing) || 0, 'rcp-sheet rc-sheet'); if (val !== undefined && val !== (Math.floor(+p.defaultDisappearing) || 0)) set({ defaultDisappearing: val }); }, { value: disLabel(p.defaultDisappearing) })],
          footer: 'Aplica-se às novas conversas que começares.' },
        { header: 'Chamadas', items: [{ icon: 'phoneDown', iconBg: GRAD, iconColor: '#fff', label: 'Silenciar desconhecidos', toggle: !!p.silenceUnknown, onToggle: on => set({ silenceUnknown: !!on }) }],
          footer: 'Nas chamadas de grupo do Zapp, quem não está nos teus contactos não faz tocar o telemóvel: a chamada fica como perdida. As chamadas da app Telefone não são afetadas.' },
        { header: 'Bloqueios', items: [
          tileItem('lock', 'Conversas bloqueadas', () => lockedChats(win)),
          tileItem('ban', 'Contactos bloqueados', () => blocked(win), { value: nBlocked ? String(nBlocked) : '' })
        ], footer: 'Estas definições valem só para o Zapp. As mensagens ficam guardadas no servidor da cidade.' }
      ]));
      v.content.scrollTop = top;
    }
    life.on('blocks', () => render());
    push(win, v); load();
    if (window.Contacts && Contacts.loadBlocks) Contacts.loadBlocks().then(() => { if (v.isConnected) render(); }).catch(() => {});
    v.reload = load;
    return v;
  }

  /* ============================================================
     CONTACTOS BLOQUEADOS
     ============================================================ */
  function blocked(win) {
    const v = UI.view({ title: 'Bloqueados', back: true, cls: 'rcp rcp-blocked', right: [{ icon: 'plus', onTap: addBlock }] });
    const life = lifecycle(v);
    const holder = UI.el('<div class="rcp-holder"></div>');
    v.content.appendChild(holder);
    let seq = 0;
    async function render() {
      const my = ++seq;
      if (!holder.children.length) holder.appendChild(UI.skeleton('list', 3));
      const list = window.Contacts ? await Contacts.loadBlocks() : [];
      if (my !== seq) return;
      holder.innerHTML = '';
      if (!list.length) { holder.appendChild(UI.empty('ban', 'Ninguém bloqueado', 'Toca em + para bloquear um contacto.')); return; }
      const rows = list.map(b => {
        const c = contactOf(b.number);
        const btn = UI.el('<div class="rcp-pill nostop">Desbloquear</div>');
        btn.onclick = async e => { e.stopPropagation(); if (await toggleBlockNumber(b.number, (c && c.name) || b.number) != null) render(); };
        return personRow({ number: b.number, label: (c && c.name) || b.number, sub: c ? b.number : '', contact: c, right: btn, onTap: () => openProfile(win, b.number) });
      });
      holder.appendChild(section(`${list.length} ${list.length === 1 ? 'contacto' : 'contactos'}`, rows,
        'Quem bloqueaste não te consegue ligar nem enviar mensagens e não vê o teu visto por último, online, foto nem sobre. Não é avisado de que foi bloqueado.'));
    }
    async function addBlock() {
      const to = await pickContacts(win, { multi: false, title: 'Bloquear contacto', exclude: (window.Contacts ? Contacts.blocked.map(b => b.number) : []) });
      if (!to.length) return;
      const c = contactOf(to[0]);
      if (await toggleBlockNumber(to[0], (c && c.name) || to[0]) != null) render();
    }
    life.on('blocks', () => render());
    push(win, v); render();
    return v;
  }

  /* ============================================================
     CONVERSAS BLOQUEADAS (precisam do código do telemóvel)
     ============================================================ */
  async function lockedChats(win) {
    if (!(await unlockChat(null))) return null;
    const v = UI.view({ title: 'Conversas bloqueadas', back: true, cls: 'rcp rcp-locked' });
    const holder = UI.el('<div class="rcp-holder"></div>');
    v.content.appendChild(holder);
    async function render() {
      holder.innerHTML = ''; holder.appendChild(UI.skeleton('list', 3));
      let r = null; try { r = await Bridge.rpcRaw('recado.threads', { filter: 'all' }); } catch (e) { r = null; }
      /* o recado.threads do RA pode vir como lista ou como { items | threads } */
      const list = (r && !r.error) ? arrOf(Array.isArray(r) ? r : (r.items || r.threads || r)).filter(t => t && typeof t === 'object' && t.locked) : [];
      holder.innerHTML = '';
      if (!list.length) { holder.appendChild(UI.empty('lock', 'Sem conversas bloqueadas', 'Numa conversa, abre as informações e liga "Bloquear conversa".')); return; }
      holder.appendChild(section(null, list.map(t => {
        const isG = !!(t.group || t.conversation);
        const gid = isG ? Math.floor(+((t.group && t.group.id) || t.conversation)) : 0;
        const target = isG ? { conversation: gid } : { number: norm(t.number) };
        const label = isG ? ((t.group && t.group.title) || t.name || 'Grupo') : displayName(t.number);
        return personRow({ number: t.number, group: isG, id: gid, label, sub: isG ? 'Grupo' : norm(t.number), mediaId: (t.group && t.group.avatar) || t.avatar, contact: isG ? null : contactOf(t.number),
          onTap: () => openChat(target),
          onLong: el => UI.ctxMenu(el, [{ label: 'Desbloquear conversa', icon: 'unlock', onTap: async () => { const x = await threadSet(target, { locked: false }); if (!x || x.error || x.ok === false) UI.toast('Não foi possível desbloquear'); else { UI.toast('Conversa desbloqueada'); render(); } } }], { cls: 'rcp-sheet rc-sheet' }) });
      }), 'Mantém premida uma conversa para a desbloquear.'));
    }
    push(win, v); render();
    return v;
  }

  /* ============================================================
     DESBLOQUEAR (código do telemóvel)
     ============================================================ */
  function unlockChat(target) {
    return new Promise(res => {
      /* sem código no telemóvel não há nada a verificar: o servidor também responde ok */
      if (!hasPin()) { res(true); return; }
      const len = ((window.System && System.account && System.account.pinLen) === 6) ? 6 : 4;
      const ov = UI.el(`<div class="rcp-lockpad"><div class="rcp-lp-top"><div class="rcp-lp-ic">${g('lock')}</div><div class="rcp-lp-t">Conversa bloqueada</div><div class="rcp-lp-s">Introduz o código do telemóvel</div><div class="rcp-lp-dots"></div></div><div class="rcp-lp-keys"></div><div class="rcp-lp-cancel">Cancelar</div></div>`);
      const dots = ov.querySelector('.rcp-lp-dots'), keys = ov.querySelector('.rcp-lp-keys'), sub = ov.querySelector('.rcp-lp-s');
      for (let i = 0; i < len; i++) dots.appendChild(UI.el('<i></i>'));
      let pin = '', busy = false, done = false, waitT = null;
      const paint = () => [...dots.children].forEach((d, i) => d.classList.toggle('on', i < pin.length));
      /* troca de personagem ou reposição com o teclado aberto: fecha e responde "não" (senão a camada ficava por cima do
         telemóvel da personagem seguinte e a promessa nunca acabava) */
      const offs = [Bridge.on('session:changed', () => finish(false)), Bridge.on('factory:reset', () => finish(false))];
      const finish = okv => { if (done) return; done = true; clearInterval(waitT); offs.forEach(f => { try { f(); } catch (e) {} }); ov.classList.remove('in'); setTimeout(() => ov.remove(), 280); res(okv); };
      const shake = () => { dots.classList.remove('shake'); void dots.offsetWidth; dots.classList.add('shake'); };
      async function check() {
        busy = true;
        let r = null; try { r = await Bridge.rpcRaw('recado.unlock', { pin }); } catch (e) { r = null; }
        if (isUnknown(r)) r = await Bridge.rpcRaw('account.verifyPin', { pin });
        busy = false; pin = ''; paint();
        if (r && r.ok) { try { Sound.play('unlock'); } catch (e) {} finish(true); return; }
        shake();
        const wait = Math.floor(+(r && r.wait)) || (r && +r.lockedUntil > Date.now() ? Math.ceil((+r.lockedUntil - Date.now()) / 1000) : 0);
        if (wait > 0) {
          let left = wait; keys.classList.add('off');
          const tick = () => { sub.textContent = `Demasiadas tentativas. Tenta daqui a ${left} s`; if (--left < 0) { clearInterval(waitT); keys.classList.remove('off'); sub.textContent = 'Introduz o código do telemóvel'; } };
          tick(); clearInterval(waitT); waitT = setInterval(tick, 1000);
        } else sub.textContent = (r && r.attempts != null) ? `Código errado · ${r.attempts} ${+r.attempts === 1 ? 'tentativa' : 'tentativas'}` : 'Código errado';
      }
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'].forEach(k => {
        const b = UI.el(`<div class="rcp-lp-k ${k ? '' : 'blank'} ${k === 'del' ? 'del' : ''}">${k === 'del' ? g('backspace') : esc(k)}</div>`);
        if (k) b.onclick = () => {
          if (busy || keys.classList.contains('off')) return;
          if (k === 'del') { pin = pin.slice(0, -1); paint(); return; }
          if (pin.length >= len) return;
          pin += k; paint(); try { Sound.play('keypad'); } catch (e) {}
          if (pin.length === len) setTimeout(check, 120);
        };
        keys.appendChild(b);
      });
      ov.querySelector('.rcp-lp-cancel').onclick = () => finish(false);
      UI.screen().appendChild(ov); requestAnimationFrame(() => ov.classList.add('in'));
    });
  }

  /* ============================================================
     CRIAR GRUPO
     ============================================================ */
  async function createGroup(win, o = {}) {
    await ensureContacts();
    return new Promise(res => {
      let avatarData = null, busy = false, settled = false;
      const done = val => { if (settled) return; settled = true; res(val); };
      let createBtn = null;   /* declarado ANTES da vista: o ref do botão corre dentro do UI.view */
      /* full: a barra de separadores do Recado sai de cena durante a criação (o seletor de membros vai até ao fundo) */
      const v = UI.view({ title: 'Novo grupo', back: 'Cancelar', full: true, cls: 'rcp rcp-newgroup', right: [{ label: 'Criar', bold: true, cls: 'rcp-create dis', onTap: () => submit(), ref: b => { createBtn = b; } }], onPop: () => { if (!busy) done(null); } });
      const head = UI.el(`<div class="rcp-ng-head"><div class="rcp-ng-av">${g('camera')}<span>Foto</span></div><div class="rcp-ng-fields"><input type="text" class="rcp-ng-name" placeholder="Nome do grupo"><textarea class="rcp-ng-desc" rows="2" placeholder="Descrição (opcional)"></textarea></div></div>`);
      const nameIn = head.querySelector('.rcp-ng-name'), descIn = head.querySelector('.rcp-ng-desc'), avBox = head.querySelector('.rcp-ng-av');
      nameIn.maxLength = TITLE_MAX * 2; descIn.maxLength = DESC_MAX * 2;
      let onlyAdminsSend = false, onlyAdminsEdit = true, theme = '';
      const settings = UI.el('<div></div>');
      const paintSettings = () => {
        settings.innerHTML = '';
        settings.appendChild(UI.list([{ header: 'Definições', items: [
          { icon: 'send', iconBg: GRAD, iconColor: '#fff', label: 'Só administradores enviam', toggle: onlyAdminsSend, onToggle: on => { onlyAdminsSend = !!on; } },
          { icon: 'pen', iconBg: GRAD, iconColor: '#fff', label: 'Só administradores editam', toggle: onlyAdminsEdit, onToggle: on => { onlyAdminsEdit = !!on; } },
          tileItem('sparkles', 'Tema da conversa', async () => { const t = await pickTheme(theme); if (t !== undefined) { theme = t; paintSettings(); } }, { value: themeOf(theme).label })
        ], footer: 'Podes mudar tudo isto mais tarde nas informações do grupo.' }]));
      };
      paintSettings();
      const picker = memberPicker({ multi: true, max: maxMembersCfg() - 1, onChange: n => { if (createBtn) createBtn.classList.toggle('dis', !n); } });
      v.content.append(head, settings, picker.el);
      avBox.onclick = async () => {
        if (busy) return;
        if (avatarData) {
          const val = await UI.actionSheet({ cls: 'rcp-sheet rc-sheet', buttons: [{ label: 'Escolher outra foto', value: 'pick' }, { label: 'Remover foto', value: 'rm', danger: true }] });
          if (val === 'rm') { avatarData = null; avBox.style.backgroundImage = ''; avBox.classList.remove('has-img'); return; }
          if (val !== 'pick') return;
        }
        const d = await pickImage('Foto do grupo');
        if (d) { avatarData = d; avBox.style.backgroundImage = UI.img(d); avBox.classList.add('has-img'); }
      };
      async function submit() {
        if (busy) return;
        const people = picker.selected();
        if (!people.length) { UI.toast('Escolhe pelo menos um contacto'); return; }
        const name = cutc(cleanLine(nameIn.value), TITLE_MAX);
        if (!name) { UI.toast('Dá um nome ao grupo'); nameIn.focus(); return; }
        const description = cutc(String(descIn.value || '').replace(/\r\n?/g, '\n').trim(), DESC_MAX);
        busy = true; v.classList.add('is-busy'); if (createBtn) createBtn.textContent = 'A criar…';
        let avatarId = null;
        if (avatarData) {
          const up = await uploadImage(avatarData);
          if (!up || !up.mediaId) { busy = false; v.classList.remove('is-busy'); if (createBtn) createBtn.textContent = 'Criar'; UI.alert({ title: 'Foto do grupo', msg: (window.VoiceMsg ? VoiceMsg.errorText(up && up.error, 'Não foi possível enviar a foto.') : 'Não foi possível enviar a foto.') + ' Podes remover a foto e criar o grupo sem ela.', cls: 'rcp-sheet rc-sheet' }); return; }
          avatarId = up.mediaId;
        }
        const req = { name, members: people.map(p => p.number), description, sendPolicy: onlyAdminsSend ? 'admins' : 'all', editPolicy: onlyAdminsEdit ? 'admins' : 'all' };
        if (avatarId) req.avatar = avatarId;
        if (theme) req.theme = theme;
        const r = await Bridge.rpcRaw('recado.group.create', req);
        busy = false; v.classList.remove('is-busy'); if (createBtn) createBtn.textContent = 'Criar';
        const id = r && !r.error && Math.floor(+r.id);
        if (!(id > 0)) { UI.alert({ title: 'Não foi possível criar o grupo', msg: errorText(r && r.error, r), cls: 'rcp-sheet rc-sheet' }); return; }
        try { Sound.play('success'); } catch (e) {}
        done(r);
        UI.pop(v);
        UI.toast('Grupo criado');
        Bridge.emit('groups:changed', { id, action: 'create', title: r.title, avatar: r.avatar, app: 'recado' });
        const priv = arrOf(r.privacy), skipped = arrOf(r.skipped);
        if (skipped.length) setTimeout(() => UI.toast('Não foi possível adicionar ' + skipped.map(n => firstName(displayName(n))).join(', '), 2800), 900);
        if (priv.length) setTimeout(() => offerInvite(id, name, priv), 500);
        /* quem chama decide: o RA abre a conversa com o resultado; a vista de Contactos daqui pede { open: true } */
        if (o.open === true) setTimeout(() => openChat({ conversation: id }), 460);
        try { if (R() && R().refresh) R().refresh(); } catch (e) {}
      }
      push(win, v);
      setTimeout(() => { try { nameIn.focus(); } catch (e) {} }, 450);
    });
  }
  async function pickTheme(cur) {
    return new Promise(resolve => {
      let settled = false; const fin = val => { if (settled) return; settled = true; resolve(val); };
      const body = UI.el('<div class="rcp-themes"></div>');
      let sh = null;
      THEMES.forEach(t => {
        const s = UI.el(`<div class="rcp-theme ${t.id === (cur || '') ? 'on' : ''}"><div class="rcp-theme-sw"><i></i></div><span></span></div>`);
        s.querySelector('.rcp-theme-sw').style.background = `linear-gradient(135deg,${t.a},${t.b})`;
        s.querySelector('span').textContent = t.label;
        s.onclick = () => { fin(t.id); if (sh) sh.close(); };
        body.appendChild(s);
      });
      sh = UI.sheet({ title: 'Tema da conversa', right: 'Cancelar', body, cls: 'rcp-sheet rc-sheet', onClose: () => fin(undefined) });
    });
  }
  /* quem a privacidade não deixa adicionar recebe o código de convite por mensagem (só se o criador quiser) */
  async function offerInvite(id, title, numbers) {
    const names = numbers.map(n => firstName(displayName(n))).slice(0, 4).join(', ');
    const one = numbers.length === 1;
    const yes = await UI.confirm('Convidar por código?', `A privacidade de ${names} não ${one ? 'permite' : 'permite'} que ${one ? 'seja adicionado' : 'sejam adicionados'} a grupos. Queres enviar-${one ? 'lhe' : 'lhes'} o código de convite por mensagem?`, 'Enviar convite', false, 'rcp-sheet rc-sheet');
    if (!yes) return;
    const r = await Bridge.rpcRaw('recado.group.invite', { id });
    if (!good(r) || !r.code) { UI.toast(errorText(r && r.error, r)); return; }
    let n = 0; for (const to of numbers) { if (await sendText(to, `Junta-te ao grupo «${title}» no Zapp com o código ${r.code}`)) n++; }
    UI.toast(n ? (n === 1 ? 'Convite enviado' : `${n} convites enviados`) : 'Não foi possível enviar os convites');
  }

  /* ============================================================
     INFORMAÇÕES DO GRUPO
     ============================================================ */
  function groupInfo(win, id, o = {}) {
    id = Math.floor(+id);
    const v = UI.view({ title: 'Informações do grupo', back: o.back || true, cls: 'rcp rcp-group' });
    const life = lifecycle(v);
    const hero = heroEl(), body = UI.el('<div class="rcp-page"></div>');
    v.content.append(hero, body);
    body.appendChild(UI.skeleton('list', 5));
    let data = null, seq = 0, gone = false, pushT = null, mediaItems = null, showAll = false, busyAv = false;
    const heroAv = hero.querySelector('.rcp-hero-av');

    async function load() {
      const my = ++seq;
      const r = await Bridge.rpcRaw('recado.group.get', { id });
      if (my !== seq) return;
      if (!r || r.error) {
        if (r && (r.error === 'notfound' || r.error === 'notmember')) return showGone();
        if (!data) { body.innerHTML = ''; body.appendChild(UI.empty('users', 'Não foi possível abrir o grupo', errorText(r && r.error, r))); }
        else UI.toast(errorText(r && r.error, r));
        return;
      }
      apply(r);
      if (!mediaItems) Bridge.rpcRaw('recado.group.media', { id, kind: 'media' }).then(m => { mediaItems = good(m) ? arrOf(m.items) : (m && m.error === 'locked' ? 'locked' : []); if (v.isConnected) paintMedia(); }).catch(() => {});
    }
    function apply(r) {
      const members = arrOf(r.members).filter(m => m && m.member != null).map(m => Object.assign({}, m, { member: norm(m.member), role: m.role === 'admin' ? 'admin' : 'member' }));
      data = Object.assign({}, r, { members });
      gone = false; render();
    }
    function showGone() {
      const was = !!data && !gone; gone = true;
      body.innerHTML = '';
      body.appendChild(UI.empty('users', 'Já não fazes parte deste grupo', 'Foste removido ou o grupo já não existe.'));
      hero.querySelector('.rcp-hero-status').textContent = '';
      if (!data) hero.querySelector('.rcp-hero-name').textContent = 'Grupo';
      if (was) Bridge.emit('groups:left', { id, removed: true, app: 'recado' });
    }
    const isAdmin = () => !!data && data.myRole === 'admin';
    const memberName = m => m.isMe ? 'Tu' : (m.name || (m.profileName ? '~' + m.profileName : m.member));
    function paintMedia() { const row = body.querySelector('.rcp-media-row'); if (row && mediaItems) fillThumbs(row, mediaItems); }

    function render() {
      if (!data || gone) return;
      const top = v.content.scrollTop;
      const admin = isAdmin(), canEdit = data.canEdit !== false && (admin || data.editPolicy === 'all');
      /* grupo de anúncios de uma comunidade (RE): membros, convites, sair e políticas são da comunidade - o servidor
         recusa-os com 'community', por isso nem se mostram */
      const announce = data.kind === 'announce', manage = admin && !announce;
      const n = data.members.length;
      const avKey = data.id + '|' + (data.avatar || 0);
      if (heroAv.dataset.k !== avKey) {
        heroAv.dataset.k = avKey; heroAv.innerHTML = '';
        const av = avatar({ group: true, id: data.id, name: data.title, mediaId: data.avatar, urgent: true }, 'xl');
        heroAv.appendChild(av);
      }
      hero.querySelector('.rcp-ring').classList.toggle('is-busy', busyAv);
      heroAv.onclick = () => changePhoto(canEdit);
      const nameEl = hero.querySelector('.rcp-hero-name');
      nameEl.textContent = data.title || 'Grupo';
      if (canEdit) nameEl.insertAdjacentHTML('beforeend', g('pen'));
      nameEl.classList.toggle('editable', canEdit);
      nameEl.onclick = canEdit ? rename : null;
      hero.querySelector('.rcp-hero-alt').textContent = `${announce ? 'Anúncios da comunidade' : 'Grupo'} · ${n} ${n === 1 ? 'membro' : 'membros'}`;
      hero.querySelector('.rcp-hero-status').textContent = '';

      body.innerHTML = '';
      body.appendChild(actionsRow([
        { icon: 'phone', label: 'Voz', onTap: () => voiceCall({ conversation: id }, data.title) },
        { icon: 'video', label: 'Vídeo', onTap: () => videoCall({ conversation: id }, data.title) },
        { icon: 'search', label: 'Pesquisar', onTap: () => searchGroup(win, id, data.title) },
        manage ? { icon: 'personPlus', label: 'Adicionar', onTap: addMembers } : { icon: 'message', label: 'Mensagem', onTap: () => openChat({ conversation: id }) }
      ]));
      if (data.description || canEdit) {
        const card = UI.el('<div class="rcp-card rcp-desc"><div class="rcp-card-k">Descrição</div><div class="rcp-card-v"></div></div>');
        const val = card.querySelector('.rcp-card-v');
        val.textContent = data.description || 'Adicionar a descrição do grupo';
        card.classList.toggle('placeholder', !data.description);
        if (canEdit) { card.classList.add('editable'); card.onclick = editDescription; }
        body.appendChild(card);
      }
      const wrapM = UI.el('<div class="list"></div>'); wrapM.appendChild(mediaStrip(() => media(win, { conversation: id }, data.title))); body.appendChild(wrapM);
      paintMedia();

      const mutedOn = +data.mutedUntil > Date.now();
      const th = themeOf(data.theme);
      const swatch = `<span class="rcp-sw" style="background:linear-gradient(135deg,${th.a},${th.b})"></span>${esc(th.label)}`;
      body.appendChild(UI.list([{ items: [
        { icon: mutedOn ? 'bellOff' : 'bell', iconBg: GRAD, iconColor: '#fff', label: 'Silenciar notificações', toggle: mutedOn, onToggle: setMute },
        tileItem('timer', 'Mensagens temporárias', setDisappearing, { value: disLabel(data.disappearing) }),
        Object.assign(tileItem('sparkles', 'Tema da conversa', canEdit ? setTheme : () => UI.toast(ERR.noedit)), { value: swatch, valueHtml: true }),
        { icon: 'lock', iconBg: GRAD, iconColor: '#fff', label: 'Bloquear conversa', toggle: !!data.locked, onToggle: setLocked }
      ], footer: mutedOn ? 'Silenciado: ' + muteText(+data.mutedUntil) + '.' : undefined }]));

      if (manage) body.appendChild(UI.list([{ header: 'Definições do grupo', items: [
        tileItem('send', 'Enviar mensagens', () => setPolicy('sendPolicy'), { value: data.sendPolicy === 'admins' ? 'Só admins' : 'Todos' }),
        tileItem('pen', 'Editar informações', () => setPolicy('editPolicy'), { value: data.editPolicy === 'all' ? 'Todos' : 'Só admins' })
      ], footer: 'Editar informações inclui o nome, a imagem, a descrição e o tema.' }]));

      /* membros: eu primeiro, depois administradores, depois por nome */
      const sorted = data.members.slice().sort((a, b) => { if (!!a.isMe !== !!b.isMe) return a.isMe ? -1 : 1; if (a.role !== b.role) return a.role === 'admin' ? -1 : 1; return String(memberName(a)).localeCompare(String(memberName(b)), 'pt'); });
      const LIMIT = 10, visible = showAll ? sorted : sorted.slice(0, LIMIT);
      const rows = [];
      if (manage) rows.push(UI.item(tileItem('personPlus', 'Adicionar membros', addMembers, { cls: 'rcp-blue', chevron: false })));
      if (manage) rows.push(UI.item(tileItem('link', 'Convidar com código', () => inviteView(win, id, data), { cls: 'rcp-blue', chevron: false })));
      const byNum = new Map();
      visible.forEach(m => {
        const tag = m.role === 'admin' ? '<span class="rcp-tag">Admin</span>' : '';
        const li = personRow({ number: m.member, label: memberName(m), sub: m.member, contact: contactOf(m.member), mediaId: m.avatar, right: tag, onTap: () => memberMenu(m), onLong: el => memberCtx(el, m) });
        rows.push(li); byNum.set(m.member, li);
      });
      if (!showAll && sorted.length > LIMIT) rows.push(UI.item({ label: `Ver todos (${sorted.length})`, cls: 'rcp-blue', chevron: false, onTap: () => { showAll = true; render(); } }));
      body.appendChild(section(`${n} ${n === 1 ? 'membro' : 'membros'}`, rows, announce ? 'Os membros deste grupo são os da comunidade. Só os administradores enviam anúncios.' : ''));
      const nums = [...byNum.keys()].filter(x => !data.members.find(m => m.member === x && m.isMe));
      profiles(nums).then(ps => { if (!v.isConnected) return; nums.forEach(x => { const li = byNum.get(x); if (li) patchRow(li, ps[x]); }); }).catch(() => {});

      if (!announce) body.appendChild(UI.list([{ items: [{ label: 'Sair do grupo', cls: 'danger center', chevron: false, onTap: leave }] }]));
      v.content.scrollTop = top;
    }
    /* todas as alterações: rpcRaw para ler o { error }; a resposta traz o grupo já atualizado */
    async function act(name, payload, okMsg) {
      const r = await Bridge.rpcRaw(name, Object.assign({ id }, payload));
      if (!r || r.error || r.ok === false) {
        const e = r && r.error;
        if (e === 'notfound') { await load(); return false; }
        if (e === 'notmember') { UI.toast('Essa pessoa já não está no grupo'); await load(); return false; }
        UI.alert({ title: 'Não foi possível', msg: errorText(e, r), cls: 'rcp-sheet rc-sheet' }); return false;
      }
      if (okMsg) UI.toast(okMsg);
      if (arrOf(r.members).length && Math.floor(+r.id) === id) apply(r); else await load();
      Bridge.emit('groups:changed', { id, app: 'recado', title: data && data.title, avatar: data && data.avatar });
      return r;
    }
    async function rename() {
      if (!data) return;
      const r = await UI.alert({ title: 'Nome do grupo', msg: 'Todos os membros veem o novo nome.', cls: 'rcp-sheet rc-sheet', input: { placeholder: 'Nome do grupo', value: data.title || '', maxlength: TITLE_MAX }, buttons: [{ label: 'Cancelar', value: false }, { label: 'Guardar', bold: true, value: true }] });
      if (!r.value) return;
      const name = cutc(cleanLine(r.text), TITLE_MAX);
      if (!name) { UI.toast('O nome não pode ficar vazio'); return; }
      if (name !== data.title) await act('recado.group.update', { name }, 'Nome alterado');
    }
    function editDescription() {
      if (!data) return;
      const box = UI.el('<div class="rcp-desc-ed"><div class="group"><textarea class="ta rcp-desc-in" rows="6" placeholder="Descrição do grupo"></textarea></div><div class="group-footer rcp-about-n"></div></div>');
      const ta = box.querySelector('textarea'), cnt = box.querySelector('.rcp-about-n');
      ta.maxLength = DESC_MAX * 2; ta.value = data.description || '';
      const count = () => { const k = [...ta.value].length; cnt.textContent = `${k}/${DESC_MAX}`; cnt.classList.toggle('over', k > DESC_MAX); };
      ta.addEventListener('input', count); count();
      const sh = UI.sheet({ title: 'Descrição', left: 'Cancelar', right: 'Guardar', body: box, cls: 'rcp-sheet rc-sheet', onDone: () => {
        const val = String(ta.value || '').replace(/\r\n?/g, '\n').trim();
        if ([...val].length > DESC_MAX) { UI.toast(`No máximo ${DESC_MAX} caracteres`); return false; }
        if (val === (data.description || '')) return true;
        act('recado.group.update', { description: val }, val ? 'Descrição guardada' : 'Descrição removida').then(okA => { if (okA) sh.close(); });
        return false;
      } });
      setTimeout(() => { try { ta.focus(); } catch (e) {} }, 380);
    }
    async function changePhoto(canEdit) {
      if (!data || busyAv) return;
      const av = heroAv.querySelector('.rcp-av');
      const buttons = [];
      if (av && av._img) buttons.push({ label: 'Ver imagem', value: 'view' });
      if (canEdit) { buttons.push({ label: data.avatar ? 'Escolher outra imagem' : 'Escolher imagem', value: 'pick' }); if (data.avatar) buttons.push({ label: 'Remover imagem', value: 'rm', danger: true }); }
      if (!buttons.length) return;
      const val = await UI.actionSheet({ title: 'Imagem do grupo', cls: 'rcp-sheet rc-sheet', buttons });
      if (val === 'view') { photoViewer(av._img, data.title); return; }
      if (val === 'rm') { busyAv = true; render(); await act('recado.group.update', { avatarMedia: 0 }, 'Imagem removida'); busyAv = false; render(); return; }
      if (val !== 'pick') return;
      const d = await pickImage('Imagem do grupo'); if (!d || !v.isConnected) return;
      busyAv = true; render();
      const up = await uploadImage(d);
      busyAv = false;
      if (!up || !up.mediaId) { render(); UI.alert({ title: 'Imagem do grupo', msg: window.VoiceMsg ? VoiceMsg.errorText(up && up.error, 'Não foi possível enviar a imagem.') : 'Não foi possível enviar a imagem.', cls: 'rcp-sheet rc-sheet' }); return; }
      if (!await act('recado.group.update', { avatarMedia: up.mediaId }, 'Imagem alterada')) render();
    }
    async function setTheme() { const t = await pickTheme(data.theme || ''); if (t === undefined || t === (data.theme || '')) return; await act('recado.group.update', { theme: t || false }, 'Tema alterado'); }
    async function setPolicy(field) {
      const opts = [{ value: 'all', label: 'Todos os membros' }, { value: 'admins', label: 'Só administradores' }];
      const cur = field === 'sendPolicy' ? (data.sendPolicy === 'admins' ? 'admins' : 'all') : (data.editPolicy === 'all' ? 'all' : 'admins');
      const val = await UI.picker(field === 'sendPolicy' ? 'Quem pode enviar mensagens' : 'Quem pode editar as informações', opts, cur, 'rcp-sheet rc-sheet');
      if (val === undefined || val === cur) return;
      await act('recado.group.update', { [field]: val }, 'Definição alterada');
    }
    async function setMute(on) {
      const until = on ? await askMute('Silenciar ' + (data.title || 'grupo')) : 0;
      if (on && !until) { render(); return; }
      const r = await threadSet({ conversation: id }, { mutedUntil: until });
      if (!r || r.error || r.ok === false) { UI.toast('Não foi possível alterar o silêncio'); render(); return; }
      data.mutedUntil = r.mutedUntil != null ? +r.mutedUntil : until; render();
      UI.toast(on ? 'Notificações silenciadas' : 'Notificações ativadas');
    }
    async function setDisappearing() {
      const cur = Math.floor(+data.disappearing) || 0;
      const val = await UI.picker('Mensagens temporárias', disOptions().map(s => ({ value: s, label: disLabel(s) })), cur, 'rcp-sheet rc-sheet');
      if (val === undefined || val === cur) return;
      const r = await threadSet({ conversation: id }, { disappearing: val });
      if (!r || r.error || r.ok === false) { UI.toast(isUnknown(r) ? 'Indisponível neste servidor' : errorText(r && r.error, r)); return; }
      data.disappearing = val; render();
    }
    async function setLocked(on) {
      if (!on && !(await unlockChat({ conversation: id }))) { render(); return; }
      if (on && !hasPin()) UI.toast('Define um código do telemóvel para proteger conversas bloqueadas', 2600);
      const r = await threadSet({ conversation: id }, { locked: !!on });
      if (!r || r.error || r.ok === false) { UI.toast(isUnknown(r) ? 'Indisponível neste servidor' : errorText(r && r.error, r)); render(); return; }
      data.locked = !!on; mediaItems = null; render(); load();
    }
    async function addMembers() {
      if (!data || !isAdmin()) return;
      const room = (Math.floor(+data.max) || maxMembersCfg()) - data.members.length;
      if (room <= 0) { UI.alert({ title: 'Grupo cheio', msg: errorText('toomany', { max: data.max }), cls: 'rcp-sheet rc-sheet' }); return; }
      const picked = await pickContacts(win, { multi: true, max: room, title: 'Adicionar membros', exclude: data.members.map(m => m.member), done: 'Adicionar' });
      if (!picked.length || !v.isConnected) return;
      const r = await act('recado.group.add', { numbers: picked });
      if (!r) return;
      const added = arrOf(r.added), skipped = arrOf(r.skipped), priv = arrOf(r.privacy);
      if (added.length === 1) UI.toast(`${firstName(displayName(added[0]))} foi adicionado`);
      else if (added.length > 1) UI.toast(`${added.length} membros adicionados`);
      if (skipped.length) setTimeout(() => UI.toast('Não foi possível adicionar ' + skipped.map(x => firstName(displayName(x))).join(', '), 2800), 1600);
      if (priv.length) setTimeout(() => offerInvite(id, data.title, priv), 700);
    }
    function memberActions(m) {
      const acts = [];
      if (m.isMe) { acts.push({ label: 'O meu perfil', icon: 'personCircle', onTap: () => myProfile(win) }); return acts; }
      const nm = memberName(m);
      acts.push({ label: 'Ver perfil', icon: 'personCircle', onTap: () => openProfile(win, m.member) });
      acts.push({ label: 'Mensagem', icon: 'message', onTap: () => openChat({ number: m.member }) });
      acts.push({ label: 'Chamada de voz', icon: 'phone', onTap: () => voiceCall({ number: m.member }, nm) });
      if (isAdmin() && data.kind !== 'announce') {
        acts.push(m.role === 'admin' ? { label: 'Retirar administrador', icon: 'shield', onTap: () => act('recado.group.member', { number: m.member, action: 'demote' }, `${firstName(nm)} deixou de ser administrador`) }
          : { label: 'Tornar administrador', icon: 'shield', onTap: () => act('recado.group.member', { number: m.member, action: 'promote' }, `${firstName(nm)} é agora administrador`) });
        acts.push({ label: 'Remover do grupo', icon: 'minusCircle', danger: true, onTap: async () => { if (await UI.confirm('Remover do grupo', `${nm} deixa de receber as mensagens deste grupo.`, 'Remover', true, 'rcp-sheet rc-sheet')) act('recado.group.member', { number: m.member, action: 'remove' }, `${firstName(nm)} foi removido`); } });
      }
      return acts;
    }
    function memberMenu(m) {
      const acts = memberActions(m); if (!acts.length) return;
      if (acts.length === 1) { acts[0].onTap(); return; }
      UI.actionSheet({ title: memberName(m), cls: 'rcp-sheet rc-sheet', buttons: acts.map((a, i) => ({ label: a.label, danger: a.danger, value: 'a' + i })) })
        .then(val => { if (typeof val !== 'string') return; const a = acts[+val.slice(1)]; if (a) a.onTap(); });
    }
    function memberCtx(el, m) { const acts = memberActions(m); if (acts.length) UI.ctxMenu(el, acts, { cls: 'rcp-sheet rc-sheet' }); }
    async function leave() {
      if (gone) { UI.pop(v); return; }
      const others = data ? data.members.filter(m => !m.isMe) : [];
      const soleAdmin = isAdmin() && others.length && !others.some(m => m.role === 'admin');
      if (!await UI.confirm('Sair do grupo', soleAdmin ? 'És o único administrador: ao saíres, o membro mais antigo passa a administrar o grupo.' : 'Deixas de receber as mensagens deste grupo.', 'Sair', true, 'rcp-sheet rc-sheet')) return;
      const r = await Bridge.rpcRaw('recado.group.leave', { id });
      if ((!r || r.error || r.ok === false) && !(r && r.error === 'notfound')) { UI.alert({ title: 'Não foi possível sair', msg: errorText(r && r.error, r), cls: 'rcp-sheet rc-sheet' }); return; }
      gone = true; life.stop();
      UI.toast('Saíste do grupo');
      Bridge.emit('groups:left', { id, app: 'recado' }); Bridge.emit('groups:changed', { id, action: 'leave', app: 'recado' });
      try { if (R() && R().refresh) R().refresh(); } catch (e) {}
      if (v.isConnected) UI.pop(v);
    }
    life.on('groupUpdate', d => {
      if (!d || Math.floor(+d.id) !== id) return;
      if (d.removed) { showGone(); return; }
      /* pushes seguidos (a própria ação, outro admin logo a seguir) juntam-se num único recado.group.get */
      clearTimeout(pushT); pushT = setTimeout(() => { pushT = null; if (v.isConnected) load(); }, 150);
    });
    life.on('contacts', () => { if (data && !gone) render(); });
    push(win, v); load();
    v.reload = load;
    return v;
  }

  /* ---------- Convite por código (admins) ---------- */
  function inviteView(win, id, grp) {
    const v = UI.view({ title: 'Convidar com código', back: true, cls: 'rcp rcp-invite' });
    const body = UI.el('<div class="rcp-page"></div>'); v.content.appendChild(body);
    body.appendChild(UI.skeleton('list', 2));
    let code = null;
    async function load(reset) {
      const r = await Bridge.rpcRaw('recado.group.invite', { id, reset: !!reset });
      if (!good(r) || !r.code) { body.innerHTML = ''; body.appendChild(UI.empty('link', 'Sem código de convite', errorText(r && r.error, r))); return; }
      code = r.code; render(r);
      if (reset) UI.toast('Código reposto: o anterior deixou de funcionar', 2400);
    }
    function render(r) {
      body.innerHTML = '';
      const card = UI.el(`<div class="rcp-code-card"><div class="rcp-code-av"></div><div class="rcp-code-title"></div><div class="rcp-code-k">Código de convite</div><div class="rcp-code"></div><div class="rcp-code-link"></div></div>`);
      card.querySelector('.rcp-code-av').appendChild(avatar({ group: true, id, name: grp && grp.title, mediaId: grp && grp.avatar }, 'lg'));
      card.querySelector('.rcp-code-title').textContent = (grp && grp.title) || 'Grupo';
      card.querySelector('.rcp-code').textContent = code.replace(/^(.{4})(.+)$/, '$1 $2');
      card.querySelector('.rcp-code-link').textContent = r.link || '';
      body.appendChild(card);
      body.appendChild(UI.list([{ items: [
        tileItem('copy', 'Copiar código', () => copyText(code, 'Código copiado'), { chevron: false }),
        /* o link abre a folha de entrar quando o recado.js trata o deeplink phone://recado/join/… (pedido ao integrador) */
        tileItem('link', 'Copiar link', () => copyText(r.link || ('phone://recado/join/' + code), 'Link copiado'), { chevron: false }),
        tileItem('send', 'Enviar no Zapp', shareCode, { chevron: false }),
        tileItem('repeat', 'Repor código', async () => { if (await UI.confirm('Repor código?', 'O código atual deixa de funcionar. Quem já entrou continua no grupo.', 'Repor', true, 'rcp-sheet rc-sheet')) load(true); }, { chevron: false, cls: 'danger' })
      ], footer: 'Quem tiver este código pode entrar no grupo pelo Zapp (Contactos › Entrar com código de convite). Partilha-o só com quem confias.' }]));
    }
    async function shareCode() {
      if (!code) return;
      const to = await pickContacts(win, { multi: true, max: 10, title: 'Enviar convite a', exclude: grp ? grp.members.map(m => m.member) : [], done: 'Enviar' });
      if (!to.length) return;
      let n = 0; for (const t of to) { if (await sendText(t, `Junta-te ao grupo «${(grp && grp.title) || 'Grupo'}» no Zapp com o código ${code}`)) n++; }
      UI.toast(n ? (n === 1 ? 'Convite enviado' : `${n} convites enviados`) : 'Não foi possível enviar');
    }
    push(win, v); load(false);
    return v;
  }

  /* ---------- Entrar com código ---------- */
  function joinByCode(win, code) {
    return new Promise(res => {
      let settled = false; const done = val => { if (settled) return; settled = true; res(val); };
      const body = UI.el(`<div class="rcp-join"><div class="rcp-join-ic">${g('link')}</div><div class="rcp-join-t">Entrar num grupo</div><div class="rcp-join-s">Escreve o código de convite que recebeste.</div><div class="group"><div class="li static"><input type="text" class="rcp-join-in" placeholder="ABCD 2345" autocomplete="off"></div></div><div class="rcp-join-prev"></div></div>`);
      const inp = body.querySelector('input'), prev = body.querySelector('.rcp-join-prev');
      inp.maxLength = 64; inp.value = String(code || '').slice(0, 64);
      let preview = null, busy = false, sh = null;
      const setRight = t => { const b = sh && sh.el.querySelector('.sh-r'); if (b) b.textContent = t; };
      inp.addEventListener('input', () => { if (preview) { preview = null; prev.innerHTML = ''; setRight('Procurar'); } });
      async function lookup() {
        const c = inp.value.trim(); if (c.length < 6) { UI.toast('O código tem pelo menos 6 caracteres'); return; }
        busy = true; setRight('A procurar…');
        const r = await Bridge.rpcRaw('recado.group.join', { code: c, preview: true });
        busy = false;
        if (!good(r)) { setRight('Procurar'); prev.innerHTML = ''; prev.appendChild(UI.el('<div class="rcp-join-err"></div>')).textContent = errorText(r && r.error, r); return; }
        preview = r; setRight(r.already ? 'Abrir' : 'Entrar');
        prev.innerHTML = '';
        const card = UI.el('<div class="rcp-join-card"><div class="rcp-join-av"></div><div class="rcp-join-name"></div><div class="rcp-join-n"></div><div class="rcp-join-d"></div></div>');
        card.querySelector('.rcp-join-av').appendChild(avatar({ group: true, id: r.id, name: r.title }, 'lg'));
        card.querySelector('.rcp-join-name').textContent = r.title || 'Grupo';
        card.querySelector('.rcp-join-n').textContent = `Grupo · ${r.memberCount} ${+r.memberCount === 1 ? 'membro' : 'membros'}${r.already ? ' · já és membro' : ''}`;
        const dd = card.querySelector('.rcp-join-d'); dd.textContent = r.description || ''; if (!r.description) dd.remove();
        prev.appendChild(card);
      }
      async function join() {
        busy = true; setRight('A entrar…');
        const r = await Bridge.rpcRaw('recado.group.join', { code: inp.value.trim() });
        busy = false;
        const id = r && !r.error && Math.floor(+r.id);
        if (!(id > 0)) { setRight('Entrar'); UI.alert({ title: 'Não foi possível entrar', msg: errorText(r && r.error, r), cls: 'rcp-sheet rc-sheet' }); return; }
        done({ id, joined: !!r.joined, already: !!r.already });
        sh.close();
        UI.toast(r.already ? 'Já és membro deste grupo' : 'Entraste no grupo');
        Bridge.emit('groups:changed', { id, action: 'join', app: 'recado' });
        try { if (R() && R().refresh) R().refresh(); } catch (e) {}
        setTimeout(() => openChat({ conversation: id }), 420);
      }
      sh = UI.sheet({ title: 'Código de convite', left: 'Cancelar', right: 'Procurar', body, cls: 'rcp-sheet rc-sheet', onDone: () => { if (busy) return false; if (preview) join(); else lookup(); return false; }, onClose: () => done(null) });
      if (inp.value) setTimeout(lookup, 250); else setTimeout(() => { try { inp.focus(); } catch (e) {} }, 380);
    });
  }

  /* ============================================================
     MEDIA, LINKS E DOCUMENTOS · PESQUISA NO GRUPO
     ============================================================ */
  function media(win, target, title) {
    const isG = !!(target && target.conversation);
    const v = UI.view({ title: title || 'Media', back: true, cls: 'rcp rcp-media' });
    const kinds = [['media', 'Media'], ['links', 'Links'], ['docs', 'Documentos']];
    let kind = 'media', items = [], more = false, loading = false, seq = 0;
    const segEl = UI.seg(kinds.map(k => k[1]), 0, i => { kind = kinds[i][0]; items = []; more = false; load(); });
    const holder = UI.el('<div class="rcp-holder"></div>');
    v.content.append(segEl, holder);
    async function load(before) {
      const my = ++seq; loading = true;
      if (!before) { holder.innerHTML = ''; holder.appendChild(UI.skeleton(kind === 'media' ? 'grid' : 'list', kind === 'media' ? 9 : 4)); }
      const req = Object.assign({ kind }, isG ? { id: target.conversation } : { number: target.number });
      if (before) req.before = before;
      const r = await Bridge.rpcRaw(isG ? 'recado.group.media' : 'recado.contact.media', req);
      if (my !== seq) return;
      loading = false;
      if (!good(r)) {
        if (!before) { holder.innerHTML = ''; holder.appendChild(r && r.error === 'locked' ? lockedEmpty(chatTarget(), () => load()) : UI.empty('photo', 'Não foi possível carregar', errorText(r && r.error, r))); }
        return;
      }
      items = items.concat(arrOf(r.items)); more = !!r.more;
      paint();
    }
    function paint() {
      holder.innerHTML = '';
      if (!items.length) {
        const e = { media: ['photo', 'Sem media', 'As fotos partilhadas nesta conversa aparecem aqui.'], links: ['link', 'Sem links', 'Os links enviados nesta conversa aparecem aqui.'], docs: ['clipboard', 'Sem documentos', 'Os documentos partilhados nesta conversa aparecem aqui.'] }[kind];
        holder.appendChild(UI.empty(e[0], e[1], e[2])); return;
      }
      if (kind === 'media') {
        const grid = UI.el('<div class="rcp-grid"></div>');
        items.forEach(it => {
          const cell = UI.el(`<div class="rcp-cell">${it.type === 'gif' ? '<span class="rcp-cell-tag">GIF</span>' : ''}</div>`);
          if (it.mediaId && window.VoiceMsg) VoiceMsg.fetchMedia(it.mediaId).then(m => { if (m && !m.error && isImg(m.dataUrl)) { cell.style.backgroundImage = UI.img(m.dataUrl); cell._img = m.dataUrl; } }).catch(() => {});
          else if (it.seed && window.photoBg) cell.style.backgroundImage = photoBg(it.seed);
          cell.onclick = () => { if (cell._img) photoViewer(cell._img, displayName(it.sender) + ' · ' + UI.rel(it.created)); else openChat(chatTarget(), { messageId: it.id }); };
          grid.appendChild(cell);
        });
        holder.appendChild(grid);
      } else {
        holder.appendChild(section(null, items.map(it => {
          const isLink = kind === 'links';
          const label = isLink ? ((arrOf(it.links)[0]) || it.text || 'Link') : (it.title || 'Documento');
          const sub = displayName(it.sender) + ' · ' + UI.rel(it.created);
          return UI.item({ icon: isLink ? 'link' : 'clipboard', iconBg: GRAD, iconColor: '#fff', label, sub, chevron: false,
            onTap: () => openChat(chatTarget(), { messageId: it.id }),
            onLong: el => UI.ctxMenu(el, isLink ? [{ label: 'Copiar link', icon: 'copy', onTap: () => copyText(label, 'Link copiado') }, { label: 'Ir para a mensagem', icon: 'message', onTap: () => openChat(chatTarget(), { messageId: it.id }) }] : [{ label: 'Ir para a mensagem', icon: 'message', onTap: () => openChat(chatTarget(), { messageId: it.id }) }], { cls: 'rcp-sheet rc-sheet' }) });
        })));
      }
      if (more) { const b = UI.el('<div class="rcp-more">Carregar mais</div>'); b.onclick = () => { if (!loading) load(items[items.length - 1].id); }; holder.appendChild(b); }
    }
    const chatTarget = () => isG ? { conversation: target.conversation } : { number: target.number };
    push(win, v); load();
    return v;
  }

  function searchGroup(win, id, title) {
    id = Math.floor(+id);
    const v = UI.view({ title: 'Pesquisar', back: true, cls: 'rcp rcp-search' });
    const holder = UI.el('<div class="rcp-holder"></div>');
    let seq = 0;
    const s = UI.search('Pesquisar em ' + (title || 'grupo'), q => run(q));
    v.content.append(s, holder);
    holder.appendChild(UI.empty('search', 'Pesquisar mensagens', 'Escreve pelo menos 2 letras.'));
    async function run(q) {
      const my = ++seq;
      if (!q || q.length < 2) { holder.innerHTML = ''; holder.appendChild(UI.empty('search', 'Pesquisar mensagens', 'Escreve pelo menos 2 letras.')); return; }
      const r = await Bridge.rpcRaw('recado.group.search', { id, q });
      if (my !== seq) return;
      holder.innerHTML = '';
      if (!good(r)) { holder.appendChild(r && r.error === 'locked' ? lockedEmpty({ conversation: id }, () => run(q)) : UI.empty('search', 'Não foi possível pesquisar', errorText(r && r.error, r))); return; }
      const list = arrOf(r.items);
      if (!list.length) { holder.appendChild(UI.empty('search', 'Sem resultados', 'Nenhuma mensagem com "' + q + '".')); return; }
      holder.appendChild(section(`${list.length} ${list.length === 1 ? 'resultado' : 'resultados'}`, list.map(m => {
        const li = UI.item({ label: displayName(m.sender), sub: m.content, value: UI.rel(m.created), chevron: false, onTap: () => openChat({ conversation: id }, { messageId: m.id }) });
        const sub = li.querySelector('.li-sub'); if (sub) sub.classList.add('rcp-wrap');
        return li;
      })));
    }
    push(win, v);
    setTimeout(() => { try { s.input.focus(); } catch (e) {} }, 420);
    return v;
  }

  /* ---------- troca de personagem: nada de perfis da anterior ---------- */
  Bridge.on('session:changed', () => profCache.clear());
  Bridge.on('recado:profile', d => { if (d && d.number) profCache.delete(norm(d.number)); });

  return { contactsView, openProfile, myProfile, privacy, groupInfo, blocked, createGroup, joinByCode, unlockChat, pickContacts,
    media, searchGroup, lockedChats, inviteView, profiles, avatar, displayName, THEMES, themeOf, errorText };
})();

/* registo no Recado (RA): o recado.js carrega DEPOIS deste ficheiro, por isso tenta-se já e outra vez quando
   o documento acabar de carregar os scripts */
(() => {
  let done = false;
  const reg = () => { if (done || !window.Recado || typeof Recado.register !== 'function') return; done = true; try { Recado.register('people', RecadoPeople); } catch (e) { console.error('[apex_phone] Recado.register people', e); } };
  reg();
  if (!done) { if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', reg); else setTimeout(reg, 0); }
})();

/* ============================================================
   MOCKS DO BROWSER - recado.profile/privacy/contact/group.*
   Seguem o server/recado_people.lua: as mesmas formas de resposta e códigos de erro, privacidade aplicada a quem
   pergunta (bloqueio → nada; reciprocidade do visto por último/online), políticas do grupo, convites por código.
   Tabelas partilhadas com os outros mocks: 'contacts', 'blocks' (phone.js), 'messages', 'thread_meta', 'media'
   (messages.js), 'conversations' e 'conversation_members' (groups.js). Própria: 'recado_profiles'.
   No browser as outras pessoas são "npc:<número>" e os contactos delas vêm do campo mock_contacts do perfil.
   ============================================================ */
if (window.LocalDB && LocalDB.register) (() => {
  const T = LocalDB.T, P = () => T('recado_profiles'), C = () => T('conversations'), M = () => T('conversation_members');
  const APP = 'recado', MAX = 32, MAX_GROUPS = 100, FOREVER = 4102444800000;
  const AUDIENCE = ['all', 'contacts', 'nobody'], FIELDS = ['lastSeen', 'online', 'photo', 'about', 'status'];
  const THEMES = ['oceano', 'por-do-sol', 'floresta', 'rosa', 'grafite', 'lavanda', 'noite'], THEME_DEFAULT = ['indigo', 'default', 'padrao'];
  const DIS = [86400, 604800, 7776000];
  const int = v => { const n = Math.floor(+v); return n > 0 ? n : 0; };
  const fail = (error, extra) => Object.assign({ ok: false, error }, extra || {});
  const now = () => Date.now();
  const me = () => String((LocalDB.me() || {}).number || '');
  const cid = () => LocalDB.cid;
  const cleanNumber = v => {
    if (typeof v === 'number') { if (!Number.isInteger(v) || v < 0) return null; v = String(v); } else if (typeof v !== 'string' || v.length > 64) return null;
    const s = v.trim(); if (s.length < 3 || s.length > 20 || !/^[0-9+\-.() ]+$/.test(s) || (s.match(/[0-9]/g) || []).length < 3) return null;
    return s;
  };
  const cleanText = (v, max, multi) => {
    if (typeof v !== 'string' && typeof v !== 'number') return null;
    let s = String(v).slice(0, max * 4 + 64);
    s = multi ? s.replace(/\r\n?/g, '\n').replace(/(?!\n)\p{Cc}/gu, ' ').replace(/\n{3,}/g, '\n\n') : s.replace(/\p{Cc}/gu, ' ');
    s = s.replace(/\p{Cf}/gu, '').replace(/[ 　]/g, ' ');
    s = (multi ? s.replace(/[ \t]+/g, ' ') : s.replace(/\s+/g, ' ')).trim();
    return [...s].slice(0, max).join('').trim();
  };
  const disOk = v => { const n = Math.floor(+v); if (n === 0) return 0; return DIS.includes(n) ? n : null; };

  /* ---------- perfis de exemplo (uma vez) ---------- */
  const seed = () => {
    if (P().all().some(p => p.seeded)) return;
    const t = now();
    const rows = [
      { number: '555-0101', name: 'Maria', about: 'Sempre disponível para a família', privacy: {}, groups_add: 'all', mock_contacts: ['555-0142'] },
      { number: '555-0177', name: 'Garagem Central', about: 'Seg a Sáb · 9h às 19h', privacy: { lastSeen: 'nobody', online: 'nobody' }, groups_add: 'contacts', mock_contacts: [] },
      { number: '555-0303', name: 'Rui', about: 'A conduzir, respondo depois', privacy: { photo: 'contacts' }, groups_add: 'all', mock_contacts: ['555-0142'] },
      { number: '555-0420', name: 'Ana Costa', about: 'Só chamadas urgentes', privacy: { about: 'contacts', lastSeen: 'contacts' }, groups_add: 'contacts', mock_contacts: [] },
      { number: '555-0666', name: 'Benny', about: 'Motores, café e música alta', privacy: {}, groups_add: 'nobody', mock_contacts: ['555-0142'] }
    ];
    const all = P().all();
    rows.forEach(r => { if (!all.some(x => x.number === r.number)) all.push(Object.assign({ owner: 'npc:' + r.number, avatar_media: null, read_receipts: 1, silence_unknown: 0, updated: t, seeded: true }, r)); });
    P().set(all);
  };
  const rowOf = n => { seed(); return P().all().find(p => p.number === n) || null; };
  const ownerOf = n => n === me() ? cid() : 'npc:' + n;
  const profile = n => {
    const owner = ownerOf(n), r = rowOf(n);
    const base = { number: n, owner, exists: false, name: '', about: '', avatarMedia: null, privacy: { lastSeen: 'all', online: 'all', photo: 'all', about: 'all', status: 'contacts' }, readReceipts: true, groupsAdd: 'all', silenceUnknown: false, defaultDisappearing: 0, updated: 0, contacts: [] };
    if (n === me()) base.contacts = T('contacts').all().map(c => String(c.number));
    if (!r || r.owner !== owner) return base;
    const pv = r.privacy && typeof r.privacy === 'object' ? r.privacy : {};
    FIELDS.forEach(f => { if (AUDIENCE.includes(pv[f])) base.privacy[f] = pv[f]; });
    return Object.assign(base, { exists: true, name: r.name || '', about: r.about || '', avatarMedia: int(r.avatar_media) || null, readReceipts: r.read_receipts !== 0, groupsAdd: AUDIENCE.includes(r.groups_add) ? r.groups_add : 'all',
      silenceUnknown: !!r.silence_unknown, defaultDisappearing: disOk(pv.defaultDisappearing) || 0, updated: r.updated || 0, contacts: n === me() ? base.contacts : (r.mock_contacts || []) });
  };
  const save = (n, p) => {
    const rows = P().all().filter(x => x.number !== n);
    const pv = {}; FIELDS.forEach(f => { pv[f] = p.privacy[f]; }); pv.defaultDisappearing = p.defaultDisappearing || 0;
    rows.push({ number: n, owner: cid(), name: p.name || '', about: p.about || '', avatar_media: p.avatarMedia || null, privacy: pv, read_receipts: p.readReceipts === false ? 0 : 1, groups_add: p.groupsAdd, silence_unknown: p.silenceUnknown ? 1 : 0, updated: now() });
    P().set(rows);
  };
  /* "bloqueou" - no browser só eu bloqueio (as linhas de blocks são minhas); os npc nunca me bloqueiam */
  const iBlocked = n => T('blocks').all().some(b => (!b.owner || b.owner === cid()) && b.number === n);
  const blockedByOwner = (owner, viewer) => owner === cid() ? iBlocked(viewer) : false;
  const canSee = (viewer, owner, field) => {
    if (!viewer || !owner || !FIELDS.includes(field)) return false;
    if (viewer === owner) return true;
    const p = profile(owner);
    if (blockedByOwner(p.owner, viewer)) return false;
    const a = p.privacy[field];
    if (a === 'nobody' || (a === 'contacts' && !p.contacts.includes(viewer))) return false;
    if ((field === 'lastSeen' || field === 'online') && profile(viewer).privacy[field] === 'nobody') return false;
    return true;
  };
  const canAdd = (adder, target) => { if (adder === target) return true; const p = profile(target); if (blockedByOwner(p.owner, adder)) return false; return p.groupsAdd === 'all' || (p.groupsAdd === 'contacts' && p.contacts.includes(adder)); };
  const presence = n => { try { const r = LocalDB.rpc('presence.get', { numbers: [n] }); if (r && r[n]) return r[n]; } catch (e) {} return { online: false, lastSeen: now() - 36e5 }; };
  const visible = (viewer, n) => {
    const p = profile(n), out = { number: n, exists: true };
    if (p.name) out.name = p.name;
    if (p.about && canSee(viewer, n, 'about')) out.about = p.about;
    if (p.avatarMedia && canSee(viewer, n, 'photo')) out.avatar = p.avatarMedia;
    const pr = presence(n), seeOnline = canSee(viewer, n, 'online');
    if (seeOnline) out.online = !!pr.online;
    if ((!pr.online || !seeOnline) && pr.lastSeen && canSee(viewer, n, 'lastSeen')) out.lastSeen = pr.lastSeen;
    out.status = canSee(viewer, n, 'status');
    return out;
  };
  const meOut = () => { const n = me(), p = profile(n); const o = { ok: true, number: n, exists: p.exists, name: p.name, about: p.about, avatarMedia: p.avatarMedia, privacy: Object.assign({}, p.privacy), readReceipts: p.readReceipts, groupsAdd: p.groupsAdd, silenceUnknown: p.silenceUnknown, defaultDisappearing: p.defaultDisappearing, updated: p.updated }; if (!p.name) { const pl = LocalDB.player() || {}; o.suggestedName = [pl.firstname, pl.lastname].filter(Boolean).join(' ').slice(0, 25); } return o; };
  const privOut = () => { const p = profile(me()); const o = { ok: true }; FIELDS.forEach(f => { o[f] = p.privacy[f]; }); return Object.assign(o, { readReceipts: p.readReceipts, groupsAdd: p.groupsAdd, silenceUnknown: p.silenceUnknown, defaultDisappearing: p.defaultDisappearing }); };
  const metaOf = (owner, other) => T('thread_meta').all().find(x => x.owner === owner && x.app === APP && x.other === other) || {};
  /* conversa bloqueada sem o código introduzido (RecadoIsUnlocked do server/recado.lua): o mock do RA guarda esse estado;
     só se aplica se ele o expuser em LocalDB.recadoIsUnlocked (pedido ao integrador) */
  const lockedFor = mt => !!mt && +mt.locked === 1 && typeof LocalDB.recadoIsUnlocked === 'function' && !LocalDB.recadoIsUnlocked();

  LocalDB.register('recado.profile.me', () => me() ? meOut() : fail('noidentity'));
  LocalDB.register('recado.profile.set', d => {
    const n = me(); if (!n) return fail('noidentity');
    const p = profile(n);
    if (!p.exists) { p.name = ''; p.about = ''; p.avatarMedia = null; }
    if (d.name != null) { const s = cleanText(d.name, 25, false); if (s == null) return fail('text'); p.name = s; }
    if (d.about != null) { const s = cleanText(d.about, 139, false); if (s == null) return fail('text'); p.about = s; }
    if (d.avatarMedia != null) {
      if (d.avatarMedia === false || d.avatarMedia === 0 || d.avatarMedia === '') p.avatarMedia = null;
      else { const id = int(d.avatarMedia), md = T('media').all().find(x => x.id === id && x.complete); if (!md || md.owner !== cid() || md.kind !== 'image') return fail('media'); p.avatarMedia = id; }
    }
    save(n, p); return meOut();
  });
  LocalDB.register('recado.profile.get', d => {
    const viewer = me(); if (!viewer) return fail('noidentity');
    const out = {}, seen = new Set();
    (Array.isArray(d.numbers) ? d.numbers : []).forEach(v => { const n = cleanNumber(v); if (n && !seen.has(n) && seen.size < 50) { seen.add(n); out[n] = visible(viewer, n); } });
    return { ok: true, profiles: out };
  });
  LocalDB.register('recado.privacy.get', () => me() ? privOut() : fail('noidentity'));
  LocalDB.register('recado.privacy.set', d => {
    const n = me(); if (!n) return fail('noidentity');
    const p = profile(n);
    for (const f of FIELDS) if (d[f] != null && !AUDIENCE.includes(d[f])) return fail('invalid', { field: f });
    if (d.readReceipts != null && typeof d.readReceipts !== 'boolean') return fail('invalid', { field: 'readReceipts' });
    if (d.groupsAdd != null && !AUDIENCE.includes(d.groupsAdd)) return fail('invalid', { field: 'groupsAdd' });
    if (d.silenceUnknown != null && typeof d.silenceUnknown !== 'boolean') return fail('invalid', { field: 'silenceUnknown' });
    if (d.defaultDisappearing != null && disOk(d.defaultDisappearing) == null) return fail('invalid', { field: 'defaultDisappearing' });
    FIELDS.forEach(f => { if (d[f] != null) p.privacy[f] = d[f]; });
    if (d.readReceipts != null) p.readReceipts = d.readReceipts;
    if (d.groupsAdd != null) p.groupsAdd = d.groupsAdd;
    if (d.silenceUnknown != null) p.silenceUnknown = d.silenceUnknown;
    if (d.defaultDisappearing != null) p.defaultDisappearing = disOk(d.defaultDisappearing);
    save(n, p); return privOut();
  });

  /* ---------- grupos ---------- */
  const find = id => { id = int(id); return id ? C().all().find(c => +c.id === id) || null : null; };
  const cmp = (a, b) => ((+a.joined || 0) - (+b.joined || 0)) || (a.member < b.member ? -1 : a.member > b.member ? 1 : 0);
  const rows = id => M().all().filter(x => +x.conversation_id === id && !x.left_at).sort(cmp);
  const memberRow = (id, who) => rows(id).find(x => x.member === who) || null;
  const groupsOf = who => M().all().filter(x => x.member === who && !x.left_at).length;
  const saveConv = c => { const all = C().all().filter(x => +x.id !== +c.id); all.push(c); C().set(all); };
  const nextId = () => [C().all().map(x => +x.id), M().all().map(x => +x.conversation_id), T('messages').all().map(x => +x.conversation_id || 0)].reduce((mx, l) => l.reduce((a, n) => (n > a ? n : a), mx), 0) + 1;
  const ownImage = v => { const id = int(v), md = id && T('media').all().find(x => x.id === id && x.complete); return md && md.owner === cid() && md.kind === 'image' ? id : 0; };
  const system = (c, by, action, text, extra) => {
    const id = +c.id, t = now(), payload = Object.assign({ action, by }, extra || {});
    const row = T('messages').insert({ app: APP, sender: by, receiver: 'g:' + id, type: 'system', content: [...text].slice(0, 255).join(''), payload, read: false, created: t, reply_to: null, conversation_id: id, delivered_at: null, read_at: null, edited_at: null, deleted_sender: 0, deleted_receiver: 0, deleted_all: null });
    c.last_id = row.id;
    if (memberRow(id, me())) setTimeout(() => Bridge.emit('message', { id: row.id, app: APP, sender: by, receiver: 'g:' + id, type: 'system', content: row.content, payload, read: false, created: t, conversation: id, group: { id, title: c.title, avatar: int(c.avatar) || null } }), 0);
  };
  const announce = (id, data) => { if (memberRow(id, me())) setTimeout(() => Bridge.emit('groupUpdate', Object.assign({ id }, data)), 0); };
  const access = (d, needAdmin) => {
    const id = int(d.id), c = id && find(id); if (!c || c.app !== APP) return { err: fail('notfound') };
    const who = me(); if (!who) return { err: fail('noidentity') };
    const mine = memberRow(id, who); if (!mine) return { err: fail('notfound') };
    if (needAdmin && mine.role !== 'admin') return { err: fail('notadmin') };
    return { c, id, who, mine };
  };
  const info = (c, who) => {
    const cs = T('contacts').all(), rs = rows(+c.id), mine = rs.find(x => x.member === who), admin = !!mine && mine.role === 'admin', mt = metaOf(who, 'g:' + c.id);
    const sendPolicy = c.send_policy === 'admins' ? 'admins' : 'all', editPolicy = c.edit_policy === 'all' ? 'all' : 'admins';
    const out = { ok: true, id: +c.id, app: APP, title: c.title, description: c.description || '', sendPolicy, editPolicy, theme: c.theme || null, kind: c.kind || 'group', communityId: int(c.community_id) || null,
      createdBy: c.created_by, created: c.created, lastId: c.last_id || null, myRole: admin ? 'admin' : 'member', me: who, max: MAX, memberCount: rs.length, pinned: !!mt.pinned,
      canEdit: editPolicy !== 'admins' || admin, canSend: sendPolicy !== 'admins' || admin, locked: !!mt.locked, disappearing: int(c.disappearing),
      members: rs.map(x => { const m = { member: x.member, role: x.role === 'admin' ? 'admin' : 'member', joined: x.joined }; const k = cs.find(y => y.number === x.member); if (k && k.name) m.name = k.name; const p = profile(x.member); if (p.exists && p.name) m.profileName = p.name; if (p.avatarMedia && canSee(who, x.member, 'photo')) m.avatar = p.avatarMedia; if (x.member === who) m.isMe = true; return m; }) };
    if (int(c.avatar)) out.avatar = int(c.avatar);
    if ((+mt.muted_until || 0) > now()) out.mutedUntil = +mt.muted_until;
    if (admin && c.invite_code) { out.inviteCode = c.invite_code; out.inviteLink = 'phone://recado/join/' + c.invite_code; }
    return out;
  };
  const cleanList = (raw, self) => {
    if (!Array.isArray(raw)) return { err: fail('members') };
    const out = [], seen = new Set();
    for (let i = 0; i < raw.length; i++) {
      if (i >= MAX * 2) return { err: fail('toomany', { max: MAX }) };
      const n = cleanNumber(raw[i]);
      if (!n) return { err: fail('badnumber', { numbers: [(typeof raw[i] === 'string' || typeof raw[i] === 'number') ? String(raw[i]).slice(0, 20) : '?'] }) };
      if (n !== self && !seen.has(n)) { seen.add(n); out.push(n); }
    }
    return { nums: out };
  };
  const split = (list, who) => { const final = [], skipped = [], privacy = []; list.forEach(n => { if (groupsOf(n) >= MAX_GROUPS) skipped.push(n); else if (!canAdd(who, n)) privacy.push(n); else final.push(n); }); return { final, skipped, privacy }; };
  const addRows = (id, list, role, lastRead) => { const all = M().all(), t = now(); list.forEach(n => { const old = all.find(x => +x.conversation_id === id && x.member === n); const r = { role, joined: t, left_at: null, last_read_id: lastRead || 0 }; if (old) Object.assign(old, r); else all.push(Object.assign({ conversation_id: id, member: n }, r)); }); M().set(all); };
  const setRow = (id, who, patch) => { const all = M().all(), x = all.find(y => +y.conversation_id === id && y.member === who && !y.left_at); if (x) Object.assign(x, patch); M().set(all); return x; };

  LocalDB.register('recado.group.create', d => {
    const who = me(); if (!who) return fail('noidentity');
    const name = cleanText(d.name, 40, false); if (!name) return fail('name');
    const l = cleanList(d.members, who); if (l.err) return l.err;
    if (!l.nums.length) return fail('members');
    if (l.nums.length + 1 > MAX) return fail('toomany', { max: MAX });
    const description = d.description != null ? cleanText(d.description, 300, true) : '';
    if (description == null) return fail('text');
    const sendPolicy = d.sendPolicy == null ? 'all' : d.sendPolicy, editPolicy = d.editPolicy == null ? 'admins' : d.editPolicy;
    if (!['all', 'admins'].includes(sendPolicy) || !['all', 'admins'].includes(editPolicy)) return fail('invalid');
    if (d.theme != null && d.theme !== '' && d.theme !== false && !THEME_DEFAULT.includes(d.theme) && !THEMES.includes(d.theme)) return fail('invalid');
    let avatar = null; if (d.avatar != null && d.avatar !== false && d.avatar !== 0 && d.avatar !== '') { avatar = ownImage(d.avatar); if (!avatar) return fail('media'); }
    if (groupsOf(who) >= MAX_GROUPS) return fail('limit', { max: MAX_GROUPS });
    const s = split(l.nums, who);
    if (!s.final.length && !s.privacy.length) return fail('members', { skipped: s.skipped });
    const id = nextId(), t = now();
    const c = { id, app: APP, title: name, avatar, created_by: who, created: t, last_id: null, description: description || null, send_policy: sendPolicy, edit_policy: editPolicy, theme: THEMES.includes(d.theme) ? d.theme : null, kind: 'group', community_id: null, invite_code: null };
    saveConv(c);
    addRows(id, [who], 'admin', 0); addRows(id, s.final, 'member', 0);
    system(c, who, 'create', `${who} criou o grupo «${name}»`, { title: name, targets: s.final });
    saveConv(c); announce(id, { action: 'create', by: who, title: name });
    const out = info(c, who); out.added = s.final; if (s.skipped.length) out.skipped = s.skipped; if (s.privacy.length) out.privacy = s.privacy; return out;
  });
  LocalDB.register('recado.group.get', d => { if (!int(d.id)) return fail('invalid'); const a = access(d); return a.err || info(a.c, a.who); });
  LocalDB.register('recado.group.update', d => {
    if (!int(d.id)) return fail('invalid');
    const a = access(d); if (a.err) return a.err;
    const c = a.c, admin = a.mine.role === 'admin', who = a.who;
    const want = {};
    if (d.name != null) { want.title = cleanText(d.name, 40, false); if (!want.title) return fail('name'); }
    if (d.description != null) { want.description = cleanText(d.description, 300, true); if (want.description == null) return fail('text'); }
    if (d.theme != null) { if (d.theme === false || d.theme === '' || THEME_DEFAULT.includes(d.theme)) want.theme = ''; else if (THEMES.includes(d.theme)) want.theme = d.theme; else return fail('invalid'); }
    if (d.sendPolicy != null) { if (!['all', 'admins'].includes(d.sendPolicy)) return fail('invalid'); want.send = d.sendPolicy; }
    if (d.editPolicy != null) { if (!['all', 'admins'].includes(d.editPolicy)) return fail('invalid'); want.edit = d.editPolicy; }
    const clearAv = d.avatarMedia != null && (d.avatarMedia === false || d.avatarMedia === 0 || d.avatarMedia === '');
    const infoEdit = want.title != null || want.description != null || want.theme != null || (d.avatarMedia != null);
    if (infoEdit && (c.edit_policy || 'admins') !== 'all' && !admin) return fail('noedit');
    if ((want.send || want.edit) && !admin) return fail('notadmin');
    if (c.kind === 'announce' && (want.send === 'all' || want.edit === 'all')) return fail('community');
    let av = null; if (d.avatarMedia != null && !clearAv) { av = ownImage(d.avatarMedia); if (!av) return fail('media'); }
    if (want.title && want.title !== c.title) { c.title = want.title; system(c, who, 'rename', `${who} mudou o nome do grupo para «${c.title}»`, { title: c.title }); announce(a.id, { action: 'rename', by: who, title: c.title }); }
    if (av && av !== int(c.avatar)) { c.avatar = av; system(c, who, 'avatar', `${who} mudou a imagem do grupo`, { avatar: av }); announce(a.id, { action: 'avatar', by: who, avatar: av }); }
    else if (clearAv && int(c.avatar)) { c.avatar = null; system(c, who, 'avatar', `${who} removeu a imagem do grupo`, { avatar: null }); announce(a.id, { action: 'avatar', by: who, avatar: null }); }
    const changes = [];
    if (want.description != null && want.description !== (c.description || '')) { c.description = want.description || null; changes.push('description'); system(c, who, 'description', c.description ? `${who} mudou a descrição do grupo` : `${who} removeu a descrição do grupo`); }
    if (want.theme != null && want.theme !== (c.theme || '')) { c.theme = want.theme || null; changes.push('theme'); system(c, who, 'theme', `${who} mudou o tema da conversa`, { theme: c.theme }); }
    if (want.send && want.send !== (c.send_policy || 'all')) { c.send_policy = want.send; changes.push('sendPolicy'); system(c, who, 'sendPolicy', want.send === 'admins' ? `${who} alterou as definições: só os administradores podem enviar mensagens` : `${who} alterou as definições: todos os membros podem enviar mensagens`, { sendPolicy: want.send }); }
    if (want.edit && want.edit !== (c.edit_policy || 'admins')) { c.edit_policy = want.edit; changes.push('editPolicy'); system(c, who, 'editPolicy', want.edit === 'admins' ? `${who} alterou as definições: só os administradores podem editar as informações do grupo` : `${who} alterou as definições: todos os membros podem editar as informações do grupo`, { editPolicy: want.edit }); }
    saveConv(c);
    if (changes.length) announce(a.id, { action: 'settings', by: who, changes, theme: c.theme, sendPolicy: c.send_policy, editPolicy: c.edit_policy });
    return info(c, who);
  });
  LocalDB.register('recado.group.add', d => {
    if (!int(d.id)) return fail('invalid');
    const raw = d.numbers == null && d.number != null ? [d.number] : d.numbers;
    const a = access(d, true); if (a.err) return a.err;
    if (a.c.kind === 'announce') return fail('community');
    const l = cleanList(raw, a.who); if (l.err) return l.err;
    if (!l.nums.length) return fail('members');
    const cur = rows(a.id).map(x => x.member), fresh = l.nums.filter(n => !cur.includes(n)), already = l.nums.filter(n => cur.includes(n));
    if (!fresh.length) return Object.assign(info(a.c, a.who), { added: [], already });
    if (cur.length + fresh.length > MAX) return fail('toomany', { max: MAX });
    const s = split(fresh, a.who);
    if (!s.final.length) return fail('members', { skipped: s.skipped, privacy: s.privacy });
    addRows(a.id, s.final, 'member', a.c.last_id || 0);
    system(a.c, a.who, 'add', `${a.who} adicionou ${s.final.join(', ')}`, { targets: s.final });
    saveConv(a.c); announce(a.id, { action: 'add', by: a.who, targets: s.final });
    const out = info(a.c, a.who); out.added = s.final; if (s.skipped.length) out.skipped = s.skipped; if (s.privacy.length) out.privacy = s.privacy; if (already.length) out.already = already; return out;
  });
  LocalDB.register('recado.group.member', d => {
    if (!int(d.id)) return fail('invalid');
    const target = cleanNumber(d.number), action = d.action;
    if (!target || !['promote', 'demote', 'remove'].includes(action)) return fail('invalid');
    const a = access(d, true); if (a.err) return a.err;
    const tr = memberRow(a.id, target); if (!tr) return fail('notmember');
    if (action === 'remove') {
      if (target === a.who) return fail('self');
      if (a.c.kind === 'announce') return fail('community');
      setRow(a.id, target, { left_at: now(), role: 'member' });
      system(a.c, a.who, 'remove', `${a.who} removeu ${target}`, { targets: [target] });
      saveConv(a.c); announce(a.id, { action: 'remove', by: a.who, targets: [target] });
    } else {
      const role = action === 'promote' ? 'admin' : 'member';
      if (tr.role !== role) {
        if (role === 'member' && rows(a.id).filter(x => x.role === 'admin').length <= 1) return fail('lastadmin');
        setRow(a.id, target, { role });
        system(a.c, a.who, 'role', role === 'admin' ? `${a.who} nomeou ${target} administrador` : target === a.who ? `${a.who} deixou de ser administrador` : `${a.who} retirou a administração a ${target}`, { targets: [target], role });
        saveConv(a.c); announce(a.id, { action: 'role', by: a.who, targets: [target], role });
      }
    }
    return info(a.c, a.who);
  });
  LocalDB.register('recado.group.leave', d => {
    if (!int(d.id)) return fail('invalid');
    const a = access(d); if (a.err) return a.err;
    if (a.c.kind === 'announce') return fail('community');
    setRow(a.id, a.who, { left_at: now(), role: 'member' });
    T('thread_meta').remove(m => m.owner === a.who && m.app === APP && m.other === 'g:' + a.id);
    const rest = rows(a.id);
    if (!rest.length) {
      T('messages').remove(m => +m.conversation_id === a.id);
      M().remove(m => +m.conversation_id === a.id); C().remove(c => +c.id === a.id);
      return { ok: true, id: a.id, deleted: true };
    }
    let admin = null;
    if (!rest.some(y => y.role === 'admin')) { admin = rest[0].member; setRow(a.id, admin, { role: 'admin' }); }
    system(a.c, a.who, 'leave', `${a.who} saiu do grupo`, admin ? { admin } : null);
    if (admin) system(a.c, admin, 'admin', `${admin} passou a ser administrador`, { targets: [admin], auto: true });
    saveConv(a.c);
    const out = { ok: true, id: a.id, deleted: false }; if (admin) out.admin = admin; return out;
  });
  const ALPHA = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  const newCode = () => Array.from({ length: 8 }, () => ALPHA[Math.floor(Math.random() * ALPHA.length)]).join('');
  const codeArg = v => { if (typeof v !== 'string' || v.length > 120) return null; const m = /join\/([A-Za-z0-9-]+)\s*$/.exec(v); const s = (m ? m[1] : v).replace(/[\s-]/g, '').toUpperCase(); return /^[A-Z0-9]{6,12}$/.test(s) ? s : null; };
  LocalDB.register('recado.group.invite', d => {
    if (!int(d.id)) return fail('invalid');
    const a = access(d, true); if (a.err) return a.err;
    if (a.c.kind === 'announce') return fail('community');
    if (d.reset === true || !a.c.invite_code) { let c; do { c = newCode(); } while (C().all().some(x => x.invite_code === c)); a.c.invite_code = c; saveConv(a.c); if (d.reset === true) announce(a.id, { action: 'invite', by: a.who, reset: true }); }
    return { ok: true, id: a.id, code: a.c.invite_code, link: 'phone://recado/join/' + a.c.invite_code };
  });
  LocalDB.register('recado.group.join', d => {
    const who = me(); if (!who) return fail('noidentity');
    const code = codeArg(d.code), c = code && C().all().find(x => x.invite_code === code && x.app === APP);
    if (!c) return fail('badcode');
    if (c.kind === 'announce') return fail('community');
    const id = +c.id;
    if (d.preview === true) return { ok: true, preview: true, id, title: c.title, description: c.description || '', memberCount: rows(id).length, already: !!memberRow(id, who), max: MAX };
    if (memberRow(id, who)) return Object.assign(info(c, who), { already: true });
    if (rows(id).length >= MAX) return fail('toomany', { max: MAX });
    if (groupsOf(who) >= MAX_GROUPS) return fail('limit', { max: MAX_GROUPS });
    addRows(id, [who], 'member', c.last_id || 0);
    system(c, who, 'join', `${who} entrou através do código de convite`, { targets: [who] });
    saveConv(c); announce(id, { action: 'join', by: who, targets: [who] });
    return Object.assign(info(c, who), { joined: true });
  });

  /* ---------- media / links / documentos e pesquisa ---------- */
  const linkRe = /(https?:\/\/[^\s]+|www\.[^\s]+)/g;
  const kindOk = { media: m => m.type === 'image' || m.type === 'gif', links: m => m.type === 'text' && /(https?:\/\/|www\.)/.test(m.content || ''), docs: m => m.type === 'document' };
  const alive = m => !m.deleted_all && !m.view_once && !(m.expires_at && m.expires_at <= now());
  const shape = list => list.map(m => {
    const it = { id: m.id, sender: m.sender, type: m.type, created: m.created }, p = m.payload && typeof m.payload === 'object' ? m.payload : {};
    if (m.type === 'image') { it.mediaId = int(p.mediaId) || null; if (p.caption) it.caption = String(p.caption).slice(0, 120); if (!it.mediaId && p.seed) it.seed = p.seed; }
    else if (m.type === 'gif') { if (typeof p.url === 'string' && /^https:\/\//.test(p.url)) it.url = p.url; }
    else if (m.type === 'document') it.title = String(p.title || m.content || 'Documento').slice(0, 80);
    else { it.text = String(m.content || '').slice(0, 200); it.links = (String(m.content || '').match(linkRe) || []).slice(0, 3); }
    return it;
  });
  const page = (list, before) => { const l = list.filter(m => !before || m.id < before).sort((a, b) => b.id - a.id); return { items: shape(l.slice(0, 60)), more: l.length > 60 }; };
  LocalDB.register('recado.group.media', d => {
    if (!int(d.id) || !kindOk[d.kind]) return fail('invalid');
    const a = access(d); if (a.err) return a.err;
    if (lockedFor(metaOf(a.who, 'g:' + a.id))) return fail('locked');
    const cleared = int(metaOf(a.who, 'g:' + a.id).cleared_before);
    const list = T('messages').all().filter(m => +m.conversation_id === a.id && m.created >= (a.mine.joined || 0) && m.id > cleared && alive(m) && !(m.sender === a.who && m.deleted_sender) && kindOk[d.kind](m));
    return Object.assign({ ok: true, id: a.id, kind: d.kind }, page(list, int(d.before)));
  });
  LocalDB.register('recado.contact.media', d => {
    const who = me(); if (!who) return fail('noidentity');
    const n = cleanNumber(d.number); if (!n || !kindOk[d.kind]) return fail('invalid');
    if (lockedFor(metaOf(who, n))) return fail('locked');
    const cleared = int(metaOf(who, n).cleared_before);
    const list = T('messages').all().filter(m => (m.app || 'sms') === APP && !m.conversation_id && m.id > cleared && alive(m) && ((m.sender === who && m.receiver === n && !m.deleted_sender) || (m.sender === n && m.receiver === who && !m.deleted_receiver)) && kindOk[d.kind](m));
    return Object.assign({ ok: true, number: n, kind: d.kind }, page(list, int(d.before)));
  });
  LocalDB.register('recado.group.search', d => {
    if (!int(d.id)) return fail('invalid');
    const q = cleanText(d.q, 64, false) || '';
    if (q.length < 2) return { ok: true, id: int(d.id), items: [] };
    const a = access(d); if (a.err) return a.err;
    if (lockedFor(metaOf(a.who, 'g:' + a.id))) return fail('locked');
    const cleared = int(metaOf(a.who, 'g:' + a.id).cleared_before), ql = q.toLowerCase();
    const items = T('messages').all().filter(m => +m.conversation_id === a.id && m.created >= (a.mine.joined || 0) && m.id > cleared && alive(m) && m.type !== 'system' && String(m.content || '').toLowerCase().includes(ql))
      .sort((x, y) => y.id - x.id).slice(0, 40).map(m => ({ id: m.id, sender: m.sender, type: m.type, content: String(m.content || '').slice(0, 200), created: m.created }));
    return { ok: true, id: a.id, q, items };
  });

  /* ---------- perfil de um contacto ---------- */
  LocalDB.register('recado.contact.info', d => {
    const who = me(); if (!who) return fail('noidentity');
    const n = cleanNumber(d.number); if (!n) return fail('invalid');
    const out = Object.assign(visible(who, n), { ok: true });
    if (n === who) out.self = true;
    const c = T('contacts').all().find(x => x.number === n);
    out.isContact = !!c;
    if (c) out.contact = { id: c.id, name: c.name, avatar: c.avatar, avatarPhoto: int(c.avatarPhoto) || null, favorite: !!c.favorite };
    out.blocked = iBlocked(n);
    if (n !== who) {
      out.groupsInCommon = C().all().filter(x => x.app === APP && memberRow(+x.id, who) && memberRow(+x.id, n)).map(x => ({ id: +x.id, title: x.title, avatar: int(x.avatar) || null, memberCount: rows(+x.id).length }));
      const mt = metaOf(who, n);
      if ((+mt.muted_until || 0) > now()) out.mutedUntil = +mt.muted_until;
      out.disappearing = int(mt.disappearing); out.locked = !!mt.locked; out.pinned = !!mt.pinned;
    }
    return out;
  });
  /* disponível para os outros mocks do Recado (RA/RE/RF): a mesma regra do RecadoCanSee / RecadoGroupCanSend */
  LocalDB.recadoCanSee = canSee;
  LocalDB.recadoGroupCanSend = (conv, who) => { const c = find(conv), m = c && memberRow(+c.id, who); return !!m && (c.send_policy !== 'admins' || m.role === 'admin'); };
  LocalDB.recadoGroupCanEdit = (conv, who) => { const c = find(conv), m = c && memberRow(+c.id, who); return !!m && (c.edit_policy === 'all' || m.role === 'admin'); };
  LocalDB.recadoCanAddToGroup = canAdd;
  void FOREVER;
})();
