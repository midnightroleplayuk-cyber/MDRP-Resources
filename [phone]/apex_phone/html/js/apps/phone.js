/* ===================== TELEFONE · CONTACTOS · FACETIME · MOTOR DE CHAMADAS ===================== */
window.Contacts = (() => {
  let cache = [];
  /* ⚠️ o json.encode do FiveM serializa uma tabela Lua VAZIA como {} e não []: um jogador sem contactos
     (ou sem bloqueios) recebia um objeto e o cache.find/filter de todas as apps rebentava */
  const toArr = r => Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error ? Object.values(r) : []);
  /* Fase 2: notas e foto do contacto. O contrato (ARQUITETURA 8.3) devolve `notes` e `avatarPhoto`; um
     servidor que ainda mande a coluna crua (`avatar_photo`) também serve. */
  const photoIdOf = c => { if (!c) return 0; const v = c.avatarPhoto != null ? c.avatarPhoto : c.avatar_photo; const n = Math.floor(+v); return n > 0 ? n : 0; };
  const norm = c => { if (!c || typeof c !== 'object') return null; c.name = String(c.name == null ? '' : c.name); c.number = String(c.number == null ? '' : c.number);
    c.notes = typeof c.notes === 'string' && c.notes ? c.notes : null; c.avatarPhoto = photoIdOf(c) || null; return c; };
  const load = async () => { cache = toArr(await Bridge.rpc('contacts.list')).map(norm).filter(Boolean); Bridge.emit('contacts'); return cache; };
  const byNumber = n => cache.find(c => c.number === n);
  const name = n => (byNumber(n) || {}).name || n;
  /* ⚠️ o contacts.update do servidor grava com MySQL.update SEM await: o contacts.list pedido logo a seguir
     pode ainda vir com a linha antiga (notas/foto/favorito de antes). A resposta do add/update já traz a linha
     final (com o JSON do Lua, `notes`/`avatarPhoto` ausentes = vazios), por isso é ela que manda na cache. */
  const patch = r => {
    /* só uma LINHA de contacto (com número) serve; um { ok } ou outra forma qualquer não mexe na cache */
    if (!r || typeof r !== 'object' || r.error || r.id == null || (typeof r.number !== 'string' && typeof r.number !== 'number')) return null;
    const row = norm(Object.assign({}, r)); if (!row) return null;
    const i = cache.findIndex(c => c.id === row.id);
    if (i > -1) { ['name', 'number', 'favorite', 'avatar', 'notes', 'avatarPhoto'].forEach(k => { if (k === 'notes' || k === 'avatarPhoto' || r[k] !== undefined) cache[i][k] = row[k]; }); }
    else cache.push(row);
    Bridge.emit('contacts'); return i > -1 ? cache[i] : row;
  };
  const add = async d => { const r = await Bridge.rpc('contacts.add', d); await load(); patch(r); return r; };
  const update = async d => { const r = await Bridge.rpc('contacts.update', d); await load(); patch(r); return r; };
  const remove = async id => { await Bridge.rpc('contacts.remove', { id }); await load(); };
  /* como add/update, mas devolve a resposta CRUA do servidor: a folha de edição precisa do { error } para
     dizer porque é que não gravou (o Bridge.rpc normal troca-o por null no jogo) */
  const save = async d => { if (d && d.number) d.number = UI.unphone(d.number); const r = await Bridge.rpcRaw(d && d.id ? 'contacts.update' : 'contacts.add', d); if (r && !r.error) { await load(); patch(r); } return r; };
  async function pick(title = 'Escolher contacto') { if (!cache.length) await load(); return new Promise(res => { const body = UI.el('<div></div>'); const s = UI.search('Pesquisar', q => paint(q)); const holder = UI.el('<div></div>'); body.append(s, holder);
    /* ⚠️ res() ANTES de sh.close(): o close() dispara o onClose de forma síncrona, que
       resolve null, e a promessa fica com a PRIMEIRA resolução. Com a ordem trocada este
       seletor devolvia sempre null (partilhar, enviar localização, escolher contacto). */
    const paint = q => { holder.innerHTML = ''; const l = cache.filter(c => !q || c.name.toLowerCase().includes(q) || c.number.includes(q)); holder.appendChild(UI.list([{ items: l.map(c => ({ avatar: c, label: c.name, sub: UI.phone(c.number), chevron: false, onTap: () => { res(c); sh.close(); } })) }])); if (q && /^[\d\s-]{4,}$/.test(q)) holder.appendChild(UI.list([{ items: [{ icon: 'keypad', iconBg: 'var(--gray)', label: 'Usar número ' + q, chevron: false, onTap: () => { res({ name: q.trim(), number: q.trim() }); sh.close(); } }] }])); };
    const sh = UI.sheet({ title, right: 'Cancelar', body, onClose: () => res(null) }); paint(''); }); }

  /* ---------- Foto do contacto ----------
     avatarPhoto é o id de uma foto da galeria do PRÓPRIO (o servidor confirma o dono). A imagem desce
     pelo caminho normal das Fotos (Photos.data, aos bocados). O que o avatar usa é uma cópia reduzida a
     180 px (Photos.square), guardada aqui por id; o base64 inteiro fica na cache das Fotos, como fica para
     qualquer foto aberta na galeria (não é uma segunda cópia por contacto).
     Pinta-se SEMPRE por CSSOM (el.style.backgroundImage), nunca dentro de uma string de HTML. */
  const thumbs = new Map(), pendingThumb = new Map(); let photosAt = 0, photosLoading = null, gen = 0;
  function photoCss(id, urgent = true) {
    id = Math.floor(+id) || 0; if (id <= 0) return Promise.resolve(null);
    if (thumbs.has(id)) {
      /* foto apagada na galeria depois de já estar em cache aqui: o Photos.remove recarrega a lista, e se ela
         já não a tem o contacto volta às iniciais (senão ficava com a foto apagada até trocar de personagem) */
      const P = window.Photos, list = P && Array.isArray(P.cache) ? P.cache : null;
      if (list && (list.length || photosAt) && !list.some(x => x && Math.floor(+x.id) === id)) { thumbs.delete(id); return Promise.resolve(null); }
      return Promise.resolve(thumbs.get(id));
    }
    if (pendingThumb.has(id)) return pendingThumb.get(id);
    const my = gen;
    const job = (async () => {
      const P = window.Photos; if (!P || !P.data) return null;
      const find = () => (P.cache || []).find(x => x && Math.floor(+x.id) === id);
      let p = find();
      /* a lista de fotos só se pede se ainda não tiver esta, e no máximo de 30 em 30 s: vários contactos
         com uma foto entretanto apagada não podem pedir a biblioteca inteira ao servidor um a um.
         ⚠️ o pedido em curso é PARTILHADO: antes, numa lista com várias fotos, só o primeiro contacto
         esperava pelo P.load(); os outros viam a cache ainda vazia, desistiam e ficavam com as iniciais. */
      if (!p && photosLoading) { try { await photosLoading; } catch (e) {} p = find(); }
      if (!p && Date.now() - photosAt > 30000) {
        photosAt = Date.now();
        const run = photosLoading = Promise.resolve().then(() => P.load()).catch(() => null);
        try { await run; } catch (e) {} if (photosLoading === run) photosLoading = null;
        p = find();
      }
      if (!p) return null;   /* foto apagada: fica com as iniciais */
      /* urgent (detalhe, ecrã da chamada): passa à frente das miniaturas da galeria; as linhas das listas esperam a vez */
      let url = null; try { url = await P.data(p, !!urgent); } catch (e) { url = null; }
      if (!url) return p.seed && window.photoBg ? photoBg(p.seed) : null;   /* fotos só com seed (mock do browser) */
      let small = null; try { small = P.square ? await P.square(url, 180, .72) : null; } catch (e) { small = null; }
      return UI.img(small || url);
    })().catch(() => null).then(css => { if (pendingThumb.get(id) === job) pendingThumb.delete(id); if (css && my === gen) thumbs.set(id, css); return my === gen ? css : null; });
    pendingThumb.set(id, job); return job;
  }
  function paintAvatar(el, c, urgent = true) {
    const id = photoIdOf(c); if (!el || !id) return Promise.resolve(false);
    return photoCss(id, urgent).then(css => { if (!css) return false; el.style.backgroundImage = css; el.style.backgroundSize = 'cover'; el.style.backgroundPosition = 'center'; el.textContent = ''; return true; });
  }

  /* ---------- Bloqueios (RPC blocks.*, servidor: server/messages.lua) ----------
     Bloqueado = as chamadas dessa pessoa dão "indisponível" e as SMS dela ficam guardadas mas não
     chegam nem notificam. Quem bloqueia continua a poder LIGAR a esse número; para lhe ESCREVER tem de
     o desbloquear primeiro (o messages.send do servidor responde { error = 'blocked' }). */
  let blocked = [];
  const cleanNum = v => (typeof v === 'string' || typeof v === 'number') ? String(v).trim().slice(0, 20) : '';
  const keyOf = l => l.map(b => b.number).sort().join('|');
  async function loadBlocks() {
    let r = null; try { r = await Bridge.rpcRaw('blocks.list'); } catch (e) { r = null; }
    if (!r || r.error) return blocked;   /* servidor sem resposta: mantém o que se sabia */
    const before = keyOf(blocked);
    blocked = toArr(r).map(b => (b && typeof b === 'object') ? { number: cleanNum(b.number), created: +b.created || 0 } : { number: cleanNum(b), created: 0 }).filter(b => b.number);
    /* a lista mudou (bloqueado noutro sítio, ou o 'ready' chegou depois de uma vista já desenhada): quem
       mostra o estado (detalhe, linha "Contactos bloqueados") acompanha. Só quando muda: sem ciclos. */
    if (keyOf(blocked) !== before) Bridge.emit('blocks', { reload: true });
    return blocked;
  }
  const isBlocked = n => { const k = cleanNum(n); return !!k && blocked.some(b => b.number === k); };
  async function setBlocked(number, on) {
    const n = cleanNum(number); if (!n) return false;
    let r = null; try { r = await Bridge.rpcRaw(on ? 'blocks.add' : 'blocks.remove', { number: n }); } catch (e) { r = null; }
    if (!r || r.error || r.ok === false) return false;
    const before = blocked; await loadBlocks();
    /* a lista não voltou (rate limit, timeout): reflete a mudança à mão para a UI não mentir */
    if (blocked === before) blocked = on ? (isBlocked(n) ? blocked : blocked.concat([{ number: n, created: Date.now() }])) : blocked.filter(b => b.number !== n);
    Bridge.emit('blocks', { number: n, blocked: !!on }); return true;
  }

  Bridge.on('ready', () => { load(); loadBlocks(); });
  /* troca de personagem: a cache é global (sobrevive ao killApp); o 'ready' do boot da nova personagem volta a carregá-la */
  Bridge.on('session:changed', () => { cache = []; blocked = []; gen++; thumbs.clear(); pendingThumb.clear(); photosAt = 0; photosLoading = null; Bridge.emit('contacts'); });
  return { get cache() { return cache; }, load, byNumber, name, add, update, remove, save, pick, photoId: photoIdOf, photoCss, paintAvatar,
    get blocked() { return blocked.slice(); }, loadBlocks, isBlocked, block: n => setBlocked(n, true), unblock: n => setBlocked(n, false) };
})();

/* ---------- Chamadas perdidas: emblema no ícone do Telefone ----------
   Conta as chamadas recebidas e não atendidas com id acima da última que o jogador viu em Recentes
   (guardada por personagem). A primeira vez que corre (instalação nova ou atualização) marca o que já
   existe como visto: sem isso toda a gente ficava com um emblema de chamadas antigas. Recalcula no
   arranque, a cada notificação da app Telefone e no fim de cada chamada; abrir Recentes limpa. */
window.PhoneMissed = (() => {
  const KEY = 'phone:missedSeen';
  let timer = null, seq = 0, live = null;
  const idOf = r => Math.floor(+(r && r.id)) || 0;
  /* linhas antigas sem status: recebida e não atendida conta como perdida (era o que a lista já mostrava) */
  const isMissed = r => !!r && !r.outgoing && !r.answered && (r.status == null || r.status === 'missed');
  const maxId = rows => rows.reduce((m, r) => Math.max(m, idOf(r)), 0);
  const rowsOf = l => Array.isArray(l) ? l : (l && typeof l === 'object' && !l.error ? Object.values(l).filter(x => x && typeof x === 'object') : []);
  function seen(rows) { const m = maxId(rows || []); const last = +Store.get(KEY, 0) || 0; if (m > last) Store.set(KEY, m); System.badge('phone', 0); }
  async function refresh() {
    const my = ++seq; let l = null; try { l = await Bridge.rpc('calls.history'); } catch (e) { l = null; }
    if (my !== seq || l == null) return;
    const rows = rowsOf(l);
    if (live && live.visible()) { seen(rows); live.update(rows); return; }
    let last = Store.get(KEY, null);
    if (last == null) { last = maxId(rows); Store.set(KEY, last); }
    System.badge('phone', rows.filter(r => isMissed(r) && idOf(r) > (+last || 0)).length);
  }
  const soon = ms => { clearTimeout(timer); timer = setTimeout(() => { timer = null; refresh(); }, ms == null ? 1200 : ms); };
  Bridge.on('ready', () => soon(1000));
  Bridge.on('notification', n => { if (n && n.app === 'phone') soon(1200); });
  /* o histórico grava-se no servidor sem esperar: dá-lhe folga antes de o ler */
  Bridge.on('call:end', () => soon(1500));
  /* Recentes ficou aberto com o telemóvel guardado (ou bloqueado) e entretanto houve uma perdida: ao voltar a
     vê-lo, a lista refaz-se e o emblema limpa. Só com a vista de Recentes viva - não custa nada nos outros casos. */
  const again = () => { if (live && live.alive()) soon(450); };
  Bridge.on('phone:open', again); Bridge.on('unlock', again);
  Bridge.on('session:changed', () => { seq++; clearTimeout(timer); timer = null; live = null; try { System.badge('phone', 0); } catch (e) {} });
  return { refresh, soon, seen, isMissed, rowsOf, get live() { return live; }, set live(v) { live = v; } };
})();

window.PhoneApp = (() => {
  const g = UI.g; let cur = null, ringStop = null, banner = null;
  /* tom escurecido de uma cor do avatar: o CSS dos ecrãs de chamada NÃO pode usar color-mix() (o CEF deixa o fundo
     TRANSPARENTE e via-se a app por trás - queixa in-game 2026-09-17), por isso a mistura com preto é feita aqui */
  const mixBlack = (hex, p) => { const n = parseInt(String(hex || '').replace('#', ''), 16); if (!isFinite(n)) return '#2F333D'; const f = v => Math.round(v * p).toString(16).padStart(2, '0'); return '#' + f((n >> 16) & 255) + f((n >> 8) & 255) + f(n & 255); };
  const av = (name, num) => { const c = Contacts.byNumber(num); return c && c.avatar ? c.avatar : (name || num || '').length; };

  /* ---------- ecrã de chamada ativa/saída ---------- */
  function callScreen(video) {
    /* FaceCall ao estilo do FaceTime (apps/facecall.js): a minha câmara a sério + poster do outro lado + controlos em vidro */
    if (video && window.FaceCallUI) return FaceCallUI.screen({ cur, end: () => end('local'), setMute, setSpeaker, minimize, seed: av(cur && cur.name, cur && cur.number) });
    /* Nova UI (Android): o mesmo motor, outro ecrã (PhoneDroid, mais abaixo neste ficheiro) */
    if (window.PhoneDroid && PhoneDroid.on()) return PhoneDroid.callScreen({ cur, end: () => end('local'), setMute, setSpeaker, minimize, seed: av(cur && cur.name, cur && cur.number), routeAirpods, routeBudsName });
    const cols = cur ? (UI.avatarStyle(av(cur.name, cur.number)).match(/#[0-9A-Fa-f]{6}/g) || []) : [];   /* fundo tingido pelas cores do avatar (PearOS 17) */
    /* .cs-route: saída de áudio (AirBuds / PearPhone), pintada pelo paintRoute - estilos inline porque apps.css não é deste pacote (§10.4) */
    const scr = UI.el(`<div class="${video ? 'ft-screen' : 'call-screen'}" style="--c1:${cols[0] || '#5E6470'};--c2:${cols[1] || '#9AA0AA'};--t1:${mixBlack(cols[0] || '#5E6470', .5)};--t2:${mixBlack(cols[1] || '#9AA0AA', .28)}">${video ? '<div class="ft-remote"></div><div class="ft-self"></div>' : ''}<div class="${video ? 'ft-name' : 'cs-name'}"></div><div class="${video ? 'ft-status' : 'cs-status'}">a chamar…</div><div class="cs-route" style="position:relative;z-index:2;display:inline-flex;align-items:center;gap:6px;margin-top:10px;padding:5px 12px;border-radius:999px;background:rgba(255,255,255,.16);color:rgba(255,255,255,.9);font-size:var(--t-foot);cursor:pointer"><span class="cs-route-ic" style="display:flex"></span><span class="cs-route-t"></span></div><div class="cs-muted">${g('micOff', 13)} Silenciado</div>${video ? '' : '<div class="cs-avwrap"><div class="cs-rings"><i></i><i></i><i></i></div><div class="cs-avatar"></div></div>'}
      ${video ? `<div class="ft-bar"><div class="spk">${g('speaker')}</div><div class="cam">${g('video')}</div><div class="mute">${g('micOff')}</div><div class="flip">${g('repeat')}</div><div class="end">${g('x')}</div></div>` :
      `<div class="cs-actions"><div class="cs-btn"><div class="mute">${g('micOff')}</div>silenciar</div><div class="cs-btn"><div class="kp">${g('keypad')}</div>teclado</div><div class="cs-btn"><div class="spk">${g('speaker')}</div>altifalante</div>
      <div class="cs-btn"><div class="add">${g('personPlus')}</div>adicionar</div><div class="cs-btn"><div class="ft">${g('video')}</div>FaceCall</div><div class="cs-btn"><div class="ct">${g('personCircle')}</div>contactos</div><div class="cs-btn end-wrap"><div class="end">${g('phoneDown')}</div></div></div>`}
      <div class="mini-btn" style="position:absolute;top:calc(var(--statusbar-h) + 4px);left:18px;color:#fff;cursor:pointer;opacity:.8;z-index:3">${g('chevD', 28)}</div></div>`);
    scr.querySelector('.mini-btn').onclick = minimize; UI.swipe(scr, { down: minimize, threshold: 90 });
    scr.querySelector('.end').onclick = () => end('local');
    /* toque na saída de áudio: folha de escolha como no iOS (PearPhone · Altifalante · AirBuds); os AirBuds só aparecem
       postos e ligados, e a linha explica a regra deles (client/main.lua: fechar o telemóvel em chamada com eles = bolso) */
    scr.querySelector('.cs-route').onclick = async () => {
      if (!cur) return; const ap = routeAirpods();
      const v = await UI.actionSheet({ title: 'Saída de áudio', buttons: [{ label: 'PearPhone', icon: 'phone', value: 'phone' }, { label: 'Altifalante', icon: 'speaker', value: 'spk' }].concat(ap ? [{ label: routeBudsName(), icon: 'earbuds', value: 'ap' }] : []) });
      if (v === 'spk') setSpeaker(true); else if (v === 'phone') setSpeaker(false); else if (v === 'ap') { setSpeaker(false); UI.toast('Com os auriculares ligados podes guardar o telemóvel durante a chamada.'); }
    };
    paintRoute(scr); scr.classList.toggle('ringing', !!(cur && cur.outgoing && !cur.t0));
    /* cur && …: o ecrã fica 900 ms visível depois de a chamada acabar (cur já null) */
    scr.querySelector('.mute').onclick = () => cur && setMute(!cur.muted);
    scr.querySelector('.spk').onclick = () => cur && setSpeaker(!cur.speaker);
    /* «adicionar», «FaceCall» e «trocar de câmara» não existem do lado do jogo: dizem-no, em vez de anunciarem
       o que não acontece («A mudar para FaceCall…» e «Câmara trocada» eram avisos de um efeito que nunca havia) */
    if (!video) { scr.querySelector('.kp').onclick = () => keypadOverlay(scr); scr.querySelector('.ct').onclick = () => { minimize(); System.openApp('contacts'); }; scr.querySelector('.add').onclick = () => UI.toast('Conferência não disponível'); scr.querySelector('.ft').onclick = () => UI.toast('Passar esta chamada a FaceCall não está disponível'); }
    else { scr.querySelector('.cam').onclick = e => e.currentTarget.classList.toggle('on'); scr.querySelector('.flip').onclick = () => UI.toast('Trocar de câmara não está disponível'); }
    return scr;
  }
  function keypadOverlay(scr) { const o = UI.el(`<div class="cs-keypad"><div class="dial-num" style="color:#fff"></div><div class="dial-keys"></div><div class="btn-p gray" style="width:200px;margin-top:20px">Ocultar</div></div>`); const num = o.querySelector('.dial-num'); [['1',''],['2','ABC'],['3','DEF'],['4','GHI'],['5','JKL'],['6','MNO'],['7','PQRS'],['8','TUV'],['9','WXYZ'],['*',''],['0','+'],['#','']].forEach(([k, l]) => { const b = UI.el(`<div class="dk"><span class="num">${k}</span><span class="abc">${l || '&nbsp;'}</span></div>`); b.onclick = () => { num.textContent += k; Sound.play('keypad'); }; o.querySelector('.dial-keys').appendChild(b); }); o.querySelector('.btn-p').onclick = () => o.remove(); scr.appendChild(o); }
  /* ---------- saída de áudio (§10.4): "AirBuds" só com eles POSTOS e LIGADOS (o mesmo par que o servidor publica em
     apex_airpods), senão "PearPhone". Só toca no DOM quando muda; o 'state' de qualquer setState({ earbuds | airpodsWorn }) repinta. */
  const routeAirpods = () => !!(System.state.earbuds && System.state.airpodsWorn);
  const routeBudsName = () => (window.Earbuds && Earbuds.NAME) || (System.config && System.config.airpods && System.config.airpods.name) || 'Auriculares';
  function paintRoute(el) {
    el = el || (cur && cur.el); if (el && el._route) { el._route(); return; }   /* ecrã Nova UI: o botão de saída de áudio pinta-se a si próprio */
    const r = el && el.querySelector('.cs-route'); if (!r) return;
    const ap = routeAirpods(), label = ap ? routeBudsName() : 'PearPhone';
    const key = ap ? 'earbuds:' + label : 'phone';
    if (r.dataset.route === key) return;
    r.dataset.route = key;
    r.querySelector('.cs-route-ic').innerHTML = g(ap ? 'earbuds' : 'phone', 14); r.querySelector('.cs-route-t').textContent = label;
  }
  Bridge.on('state', p => { if (p && ('earbuds' in p || 'airpodsWorn' in p)) paintRoute(); });
  /* o avatar só se refaz quando muda o nome/número: antes o cssText era reposto a cada tique de 500 ms,
     o que apagava a foto do contacto pintada por CSSOM (e repintava o círculo sem razão) */
  /* [data-hook] = os mesmos pontos de pintura nos ecrãs da Nova UI (Android) */
  function paint() { if (!cur || !cur.el) return; const n = cur.el.querySelector('.cs-name,.ft-name,[data-hook="name"]'), s = cur.el.querySelector('.cs-status,.ft-status,[data-hook="status"]'), a = cur.el.querySelector('.cs-avatar,[data-hook="avatar"]'); n.textContent = cur.name; s.textContent = cur.t0 ? UI.fmtDur((Date.now() - cur.t0) / 1000) : cur.status;
    cur.el.classList.toggle('ringing', !!(cur.outgoing && !cur.t0)); cur.el.classList.toggle('connected', !!cur.t0);
    if (a) { const key = cur.name + '|' + cur.number; if (a.dataset.k !== key) { a.dataset.k = key; a.textContent = UI.initials(cur.name); a.style.cssText = UI.avatarStyle(av(cur.name, cur.number)); Contacts.paintAvatar(a, Contacts.byNumber(cur.number)); } }
    if (cur.el._onPaint) cur.el._onPaint(cur); }
  function tick() { if (cur && cur.t0) paint(); }
  /* mute REAL: o servidor avisa o outro participante, que deixa de nos ouvir (client/voice.lua).
     Antes ia só para o callAction, que chamava exports do pma-voice que não existem.
     Sem callId (ainda a ligar) fica guardado e é enviado quando o calls.start responder. */
  function setMute(on) { if (!cur) return; cur.muted = !!on; if (cur.id) Bridge.rpc('calls.mute', { callId: cur.id, on: cur.muted }); const b = cur.el && cur.el.querySelector('.mute,[data-act="mute"]'); if (b) b.classList.toggle('on', cur.muted); if (cur.el) cur.el.classList.toggle('muted', cur.muted); }
  /* "a falar" (client/calls.lua → push callTalk): aro verde no avatar do outro / no meu PiP; longe do outro jogador fica falso */
  Bridge.on('callTalk', d => { if (!cur || !cur.el || !d) return; cur.el.classList.toggle('talk-me', !!d.me && !cur.muted); cur.el.classList.toggle('talk-peer', !!d.peer); });
  /* dados da ilha da chamada em curso - um só sítio: antes o push 'active' refazia a ilha sem onMute e o silenciar da ilha deixava de funcionar.
     muted/speaker vão com os dados: a ilha guarda o estado dos botões em d.muted, e sem isto silenciar no ecrã e minimizar
     mostrava "Silenciar" desligado - o toque seguinte na ilha tirava o mute enquanto o botão acendia */
  function setSpeaker(on) { if (!cur) return; cur.speaker = !!on; const b = cur.el && cur.el.querySelector('.spk,[data-act="spk"]'); if (b) b.classList.toggle('on', cur.speaker); Bridge.call('callAction', { action: 'speaker', on: cur.speaker, callId: cur.id }); }
  const islandCall = () => ({ name: cur.name, avatar: av(cur.name, cur.number), t0: cur.t0, status: cur.status, muted: !!cur.muted, speaker: !!cur.speaker, onOpen: restore, onEnd: () => end('local'), onMute: () => cur && setMute(!cur.muted), onSpeaker: () => cur && setSpeaker(!cur.speaker) });   /* cur && …: um toque na ilha já sem chamada (cur null) rebentava em cur.muted */
  function minimize() { if (!cur || !cur.el) return; cur.el.style.display = 'none'; cur.min = true; if (cur.el._fcActive) cur.el._fcActive(false); Island.set('call', islandCall()); }
  function restore() { if (!cur || !cur.el) return; cur.el.style.display = ''; cur.min = false; if (cur.el._fcActive) cur.el._fcActive(true); Island.clear('call'); }

  /* ---------- chamada de saída ---------- */
  async function call(number, name, opts = {}) {
    if (!number) return; if (cur) { UI.toast('Já estás numa chamada'); return; }
    /* modo de voo (CC.requireNet, shell/control.js): antes de desenhar o ecrã de chamada e de tocar o sinal - com o
       avião ligado o calls.start ia na mesma e o jogador via "a chamar…" por cima de um telemóvel sem rede. Vale
       também para o StartCall do client (export): a chamada nasce por este mesmo caminho. */
    if (window.CC && CC.requireNet && !CC.requireNet(opts.video ? (window.PhoneDroid && PhoneDroid.on() ? 'fazer uma videochamada' : 'fazer um FaceCall') : 'fazer uma chamada')) return;
    /* eSIM (js/apps/esim.js): SIM obrigatório e nenhuma linha = o servidor recusaria ('nosim'); avisa já, com "Adicionar eSIM" */
    if (window.ESim && ESim.require && !ESim.require(opts.video ? 'fazer videochamadas' : 'fazer chamadas')) return;
    number = UI.unphone(number);   /* '+351 555-1234' marcado à mão liga para 555-1234 */
    name = name || Contacts.name(number);
    cur = { id: null, number, name, outgoing: true, t0: 0, status: 'a chamar…', video: !!opts.video, muted: false, speaker: false, answered: false };
    cur.el = callScreen(cur.video); UI.screen().appendChild(cur.el); paint();
    cur.timer = setInterval(tick, 500); Sound.play('pop'); ringStop = Sound.ring('Sinal');
    /* telemóvel ao ouvido desde que se marca (client/main.lua 'callPose'); FaceCall não */
    Bridge.call('callPose', { on: true, video: cur.video });
    const mine = cur; const r = await Bridge.rpc('calls.start', { number, video: cur.video });
    /* desligou-se enquanto o servidor respondia: sem callId o end() não avisava o servidor e o outro telemóvel tocava até ao timeout */
    if (cur !== mine) { if (r && r.callId && r.status === 'ringing') Bridge.rpc('calls.end', { callId: r.callId, number, outgoing: true, answered: false, duration: 0 }); return; }
    /* 'offline' e 'unavailable' (quem nos bloqueou) mostram o MESMO texto: o bloqueio não se revela */
    /* eSIM: recusa por não haver linha ('nosim'; no jogo o Bridge.rpc devolve null, por isso também se volta a pedir o estado sem resposta) */
    if (window.ESim && (!r || r.error === 'nosim')) { ESim.refresh(true); if (r && ESim.alertNoSim) ESim.alertNoSim('fazer chamadas'); }
    if (!r || r.error || r.status !== 'ringing') { const st = r && r.status; cur.status = (r && r.error === 'nosim') ? 'sem SIM' : st === 'busy' ? 'ocupado' : st === 'self' ? 'número inválido' : st === 'ended' ? 'chamada terminada' : 'indisponível'; paint(); Sound.stopRing(); Sound.play('error'); setTimeout(() => { if (cur === mine) end('failed'); }, 1400); return; }
    /* o servidor confirmou que o outro telemóvel está a tocar: "a chamar…" (a ligar) passa a "a tocar…" */
    cur.id = r.callId; if (!cur.t0) cur.status = 'a tocar…'; if (r.name && !Contacts.byNumber(number)) cur.name = r.name; paint();
    if (cur.min) Island.set('call', islandCall());
    if (cur.muted) Bridge.rpc('calls.mute', { callId: cur.id, on: true });
    /* push desta chamada que chegou antes da resposta (ver onState) */
    const early = cur.early && cur.early[cur.id]; cur.early = null; if (early) onState({ callId: cur.id, state: early });
  }
  /* ---------- chamada recebida ---------- */
  function incoming(d) {
    if (!d || !d.callId) return; if (cur) { Bridge.rpc('calls.decline', { callId: d.callId, busy: true }); return; }
    const name = d.name || Contacts.name(d.number);
    cur = { id: d.callId, number: d.number, name, outgoing: false, t0: 0, status: 'chamada de telemóvel…', video: !!d.video, muted: false, speaker: false, answered: false, incoming: true };
    ringStop = Sound.ring(System.state.ringtone); Bridge.call('playAnim', { anim: 'ring' });
    const mine = cur; let ui = null;
    const drop = () => { if (ui) { ui.remove(); ui = null; } if (mine.ui) mine.ui = null; };
    const accept = async () => { if (cur !== mine || cur.answered) return; Sound.stopRing(); drop(); cur.answered = true; cur.t0 = Date.now(); cur.status = ''; cur.el = callScreen(cur.video); UI.screen().appendChild(cur.el); paint(); cur.timer = setInterval(tick, 500); Bridge.call('callPose', { on: true, video: cur.video }); await Bridge.rpc('calls.accept', { callId: mine.id }); Bridge.emit('call:active', mine); };
    /* o push 'declined' do servidor pode chegar durante o await e acabar esta chamada - e entretanto pode já tocar OUTRA: só se termina a mesma */
    const decline = async () => { if (cur !== mine || cur.answered) return; Sound.stopRing(); drop(); await Bridge.rpc('calls.decline', { callId: mine.id }); if (cur === mine) finish('declined'); };
    /* ecrã inteiro (telemóvel bloqueado / home, ou tocar na ilha) */
    /* responder com mensagem (respostas rápidas): o mesmo messages.send nos dois sistemas */
    const replyMsg = async text => { if (!window.CC || !CC.requireNet || CC.requireNet('enviar a mensagem')) await Bridge.rpc('messages.send', { to: d.number, type: 'text', content: text }); };
    const full = () => {
      /* Nova UI (Android): ecrã inteiro com os círculos de arrastar (PhoneDroid.incoming); os mesmos accept/decline */
      if (window.PhoneDroid && PhoneDroid.on()) {
        ui = PhoneDroid.incoming({ name, number: d.number, video: mine.video, seed: av(name, d.number), accept, decline, reply: async text => { await replyMsg(text); decline(); } });
        if (window.ESim && ESim.callTag) ESim.callTag(ui, d);   /* eSIM: a linha que está a tocar (d.line), com 2+ linhas */
        UI.screen().appendChild(ui); mine.ui = ui; return;
      }
      /* PearOS 17: fundo escuro tingido pelas cores do avatar, nome grande, "Lembrar"/"Mensagem" em vidro por cima dos dois botões redondos Recusar/Aceitar (classes ic-* próprias - .acc/.rm existem noutras apps) */
      const cols = (UI.avatarStyle(av(name, d.number)).match(/#[0-9A-Fa-f]{6}/g) || ['#5E6470', '#9AA0AA']);
      /* bloqueado: "deslizar para atender" (como no iOS); desbloqueado: os dois botões redondos */
      const locked = !!System.locked;
      ui = UI.el(`<div class="incoming ${locked ? 'locked' : ''}" style="--c1:${cols[0]};--c2:${cols[1]};--t1:${mixBlack(cols[0], .55)};--t2:${mixBlack(cols[1], .3)}"><div class="ic-top"><div class="ic-name">${UI.esc(name)}</div><div class="ic-sub">${cur.video ? `${g('video', 15)} FaceCall Vídeo…` : `${g('phone', 14)} chamada de telemóvel…`}</div></div><div class="cs-avwrap"><div class="cs-rings"><i></i><i></i><i></i></div><div class="cs-avatar" style="${UI.avatarStyle(av(name, d.number))}">${UI.esc(UI.initials(name))}</div></div>
        <div class="ic-mini"><div class="ic-rm"><div>${g('alarm')}</div><span>Lembrar</span></div><div class="ic-msg"><div>${g('message')}</div><span>Mensagem</span></div></div>
        ${locked ? `<div class="ic-slide"><div class="ic-knob">${g('phoneFill', 26)}</div><span>deslizar para atender</span></div><div class="ic-declink">Recusar</div>` :
        `<div class="ic-btns"><div class="ic-btn ic-dec"><div>${g('phoneDown')}</div><span>Recusar</span></div><div class="ic-btn ic-acc"><div>${g('phoneFill')}</div><span>Aceitar</span></div></div>`}</div>`);
      if (locked) {
        /* arrastar o botão até ao fim da calha = atender; largar antes volta ao início */
        const track = ui.querySelector('.ic-slide'), knob = ui.querySelector('.ic-knob'); let sd = null;
        knob.addEventListener('pointerdown', e => { sd = { x0: e.clientX, z: UI.zoom() }; knob.classList.add('drag'); try { knob.setPointerCapture(e.pointerId); } catch (x) {} });
        knob.addEventListener('pointermove', e => { if (!sd) return; const max = track.clientWidth - knob.offsetWidth - 8; const x = Math.max(0, Math.min(max, (e.clientX - sd.x0) / sd.z)); knob.style.transform = `translateX(${x}px)`; track.style.setProperty('--p', String(x / max)); if (x >= max - 2) { sd = null; knob.classList.remove('drag'); accept(); } });
        const rel = () => { if (!sd) return; sd = null; knob.classList.remove('drag'); knob.style.transform = ''; track.style.setProperty('--p', '0'); };
        knob.addEventListener('pointerup', rel); knob.addEventListener('pointercancel', rel);
        ui.querySelector('.ic-declink').onclick = decline;
      } else { ui.querySelector('.ic-acc').onclick = accept; ui.querySelector('.ic-dec').onclick = decline; }
      /* Lembrar: escolhe quando (fica nos Lembretes); Mensagem: respostas rápidas como no iOS - as duas recusam a chamada */
      ui.querySelector('.ic-rm').onclick = async () => { const v = await UI.actionSheet({ title: 'Lembrar-me de ligar a ' + name, buttons: [{ label: 'Daqui a 15 minutos', value: 15 }, { label: 'Daqui a 1 hora', value: 60 }, { label: 'Amanhã', value: 1440 }] }); if (!v) return; const rem = { id: Date.now(), text: 'Ligar a ' + name, done: false, ts: Date.now(), due: Date.now() + v * 60000 };
        if (window.Agenda && Agenda.edit) Agenda.edit('reminders', [], l => l.push(rem)); else Store.update('reminders', [], l => l.push(rem));   /* pelo Agenda, para avisar à hora */
        UI.toast('Lembrete criado'); decline(); };
      ui.querySelector('.ic-msg').onclick = async () => {
        const v = await UI.actionSheet({ title: 'Responder com mensagem', buttons: ['Não posso falar agora.', 'Ligo-te já.', 'Estou a caminho.'].map(t => ({ label: t, value: t })).concat([{ label: 'Personalizar…', value: '_' }]) });
        if (!v) return; let text = v; if (v === '_') { text = await UI.prompt('Mensagem', '', 'Escreve a resposta'); if (!text) return; }
        if (!window.CC || !CC.requireNet || CC.requireNet('enviar a mensagem')) await Bridge.rpc('messages.send', { to: d.number, type: 'text', content: text });   /* sem rede recusa na mesma, mas não finge que respondeu */
        decline();
      };
      if (window.ESim && ESim.callTag) ESim.callTag(ui, d);   /* eSIM: "[T] Para Trabalho" por baixo do estado (d.line) */
      UI.screen().appendChild(ui); mine.ui = ui;
      /* foto do contacto (Fase 2) por cima das iniciais, pelo CSSOM */
      Contacts.paintAvatar(ui.querySelector('.cs-avatar'), Contacts.byNumber(d.number));
    };
    /* trocar de aparelho (os:changed) com a chamada a tocar em ecrã inteiro: o ecrã é refeito no desenho do sistema novo */
    mine.refull = () => { if (cur !== mine || mine.answered || !ui || ui.nodeType !== 1) return; ui.remove(); ui = null; mine.ui = null; full(); };
    if (System.locked || !System.currentApp()) full();
    else {
      /* com uma app aberta a chamada entra na ILHA (expandida com atender/recusar), sem tapar a app.
         onOpen (ecrã inteiro) e onEnd (= recusar) ficam para uma ilha que não desenhe os botões de chamada recebida */
      Island.set('call', { name, avatar: av(name, d.number), status: cur.video ? App.name('facetime') : 'chamada de telemóvel…', video: cur.video, incoming: true, onAccept: accept, onDecline: decline, onEnd: decline, onOpen: () => { if (cur !== mine || cur.answered) return; drop(); full(); } });
      ui = { remove: () => Island.clear('call') }; mine.ui = ui;
    }
    cur.timeout = setTimeout(() => { if (cur === mine && !cur.answered) { Sound.stopRing(); drop(); finish('missed'); } }, 32000);
  }
  /* push com callId só vale para a chamada com ESSE id. Antes, com cur.id ainda null (calls.start pendente), o fim de
     OUTRA chamada (ex.: a recusada por "ocupado") terminava a chamada que estava a ligar. Mas a resposta do RPC vem pela
     resposta do fetch e o push pelo SendNUIMessage, sem ordem garantida entre os dois: um push desta chamada pode chegar
     antes do callId. Fica guardado em cur.early e o call() aplica-o quando o id chegar (senão ficava "a tocar…" para sempre). */
  function onState(d) {
    if (!cur || !d) return;
    if (d.callId != null && cur.id == null && cur.outgoing) { (cur.early = cur.early || {})[d.callId] = d.state; return; }
    if (d.callId != null && d.callId !== cur.id) return;
    if (d.state === 'active') { Sound.stopRing(); if (!cur.t0) { cur.t0 = Date.now(); cur.answered = true; cur.status = ''; paint(); Sound.play('connect'); Bridge.emit('call:active', cur); } if (cur.min) Island.set('call', islandCall()); }
    else if (['ended', 'declined', 'missed', 'busy', 'failed'].includes(d.state)) { if (cur.ui) { Sound.stopRing(); cur.ui.remove(); } finish(d.state); }
  }
  function end(reason) { if (!cur) return; if (cur.id) Bridge.rpc('calls.end', { callId: cur.id, number: cur.number, outgoing: cur.outgoing, answered: cur.answered, duration: cur.t0 ? Math.floor((Date.now() - cur.t0) / 1000) : 0 }); finish(reason); }
  function finish(reason) {
    if (!cur) return; const c = cur; cur = null; Sound.stopRing(); clearInterval(c.timer); clearTimeout(c.timeout); Island.clear('call'); Bridge.call('callAction', { action: 'end', callId: c.id }); Bridge.call('callPose', { on: false });
    if (c.el) {
      const txt = reason === 'declined' ? 'recusada' : reason === 'busy' ? 'ocupado' : (reason === 'missed' && c.outgoing) ? 'sem resposta' : reason === 'failed' ? (c.status || 'indisponível') : 'chamada terminada';
      const s = c.el.querySelector('.cs-status,.ft-status,[data-hook="status"]'); if (s) s.textContent = txt;
      c.el.classList.remove('ringing', 'talk-me', 'talk-peer'); c.el.classList.add('ended');
      const kill = () => { if (c.el._fcDestroy) c.el._fcDestroy(); if (c.el._kpOff) c.el._kpOff(); c.el.remove(); };   /* _kpOff: só o ecrã da Nova UI (teclado fora do registo das camadas) */
      /* não atendeu / ocupado / recusou (e não fui eu a desligar): cartão de fim com "Ligar novamente" e "Mensagem",
         como no iOS; o resto fecha sozinho passado um instante */
      if (c.outgoing && !c.answered && reason !== 'local' && window.PhoneDroid && PhoneDroid.on()) {
        /* Nova UI: as ações de fim ficam no lugar dos botões da chamada (o mesmo "Ligar novamente" / "Mensagem" / "Fechar") */
        c.el.style.display = ''; if (c.el._fcActive) c.el._fcActive(false);
        PhoneDroid.endCard(c.el, { again: () => { kill(); call(c.number, c.name, { video: c.video }); }, msg: () => { kill(); if (window.Msgs && Msgs.open) Msgs.open(c.number, c.name); }, close: kill });
        setTimeout(() => { if (c.el.isConnected) kill(); }, 12000);
      } else if (c.outgoing && !c.answered && reason !== 'local') {
        c.el.style.display = ''; if (c.el._fcActive) c.el._fcActive(false);
        const card = UI.el(`<div class="cs-endcard"><b>${UI.esc(c.name || c.number)}</b><span>${UI.esc(c.video ? 'FaceCall · ' + txt : txt)}</span><div class="cs-endbtns"><div class="again">${g(c.video ? 'video' : 'phone', 20)}<span>Ligar novamente</span></div><div class="msg">${g('message', 20)}<span>Mensagem</span></div><div class="close">${g('x', 20)}<span>Fechar</span></div></div></div>`);
        card.querySelector('.again').onclick = () => { kill(); call(c.number, c.name, { video: c.video }); };
        card.querySelector('.msg').onclick = () => { kill(); if (window.Msgs && Msgs.open) Msgs.open(c.number, c.name); };
        card.querySelector('.close').onclick = kill;
        c.el.classList.add('endcard'); c.el.appendChild(card); requestAnimationFrame(() => card.classList.add('in'));
        setTimeout(() => { if (c.el.isConnected) kill(); }, 12000);
      } else setTimeout(kill, 900);
    }
    if (c.ui) c.ui.remove(); Sound.play('call_end'); Bridge.emit('call:end', c);
    /* a notificação de chamada perdida vem só do servidor (persistente): a que se criava aqui duplicava-a.
       O emblema de chamadas perdidas recalcula-se a partir do 'call:end' (PhoneMissed) */
  }
  Bridge.on('incomingCall', incoming); Bridge.on('callState', onState);
  /* trocar de aparelho (setOS: PearPhone ⇄ NOVA) a meio de uma chamada: a chamada continua e o ecrã dela é refeito no
     desenho do sistema novo (o antigo ficava, com os nomes do outro sistema, e o cartão de fim ia parar ao ecrã errado) */
  Bridge.on('os:changed', () => {
    if (cur && !cur.answered && typeof cur.refull === 'function') { try { cur.refull(); } catch (e) { console.error('[apex_phone] os:changed (a tocar)', e); } }
    if (!cur || !cur.el || !cur.el.isConnected) return;
    const old = cur.el, wasMin = !!cur.min;
    try { if (old._fcDestroy) old._fcDestroy(); if (old._kpOff) old._kpOff(); } catch (e) {}
    const nx = callScreen(cur.video); if (wasMin) nx.style.display = 'none';
    old.replaceWith(nx); cur.el = nx;
    const mb = nx.querySelector('.mute,[data-act="mute"]'); if (mb) mb.classList.toggle('on', !!cur.muted); nx.classList.toggle('muted', !!cur.muted);
    const sb = nx.querySelector('.spk,[data-act="spk"]'); if (sb) sb.classList.toggle('on', !!cur.speaker);
    if (wasMin && nx._fcActive) nx._fcActive(false);
    paint();
  });
  /* export client StartCall(number, video): o client/exports.lua abre o telemóvel e manda este push. A chamada nasce aqui
     (calls.start), como se o jogador a tivesse feito; bloqueado pede primeiro o código. Antes ninguém ouvia o push. */
  Bridge.on('startCall', d => { if (!d || (typeof d.number !== 'string' && typeof d.number !== 'number')) return;
    const n = String(d.number).replace(/[^\d+\-\s#*]/g, '').trim().slice(0, 24); if (!/\d/.test(n)) return;
    const go = () => call(n, null, { video: d.video === true });
    if (System.locked && window.Lock && Lock.requestUnlock) Lock.requestUnlock(go); else go(); });
  const facetime = (n, name) => call(n, name, { video: true });
  return { call, facetime, incoming, end, get current() { return cur; }, minimize, restore };
})();

/* ---------- Peças partilhadas por Contactos, Telefone e Mensagens ---------- */
/* os quatro botões por baixo do nome (mensagem · chamar · vídeo · mail) */
function contactActions(number, name) {
  const acts = UI.el('<div style="display:flex;gap:10px;padding:0 16px 12px"></div>');
  [['message', 'mensagem', () => Msgs.open(number, name)], ['phone', 'chamar', () => PhoneApp.call(number, name)], ['video', 'vídeo', () => PhoneApp.facetime(number, name)], ['mail', 'mail', () => (window.MailApp ? MailApp.compose({ to: number }) : System.openApp('mail'))]].forEach(([i, l, f]) => { const b = UI.el(`<div style="flex:1;background:var(--bg2);border-radius:12px;padding:10px 0;text-align:center;color:var(--blue);cursor:pointer;font-size:var(--t-cap1)">${UI.g(i, 22)}<div>${l}</div></div>`); b.onclick = f; acts.appendChild(b); });
  return acts;
}
/* cabeçalho: avatar grande + nome (texto por textContent; foto por CSSOM) */
function contactHead(c) {
  const head = UI.el(`<div class="profile" style="flex-direction:column;justify-content:center;padding-top:10px">${UI.avatar(c, 'lg')}<div class="name" style="margin-top:10px;font-size:var(--t-title2)"></div></div>`);
  head.querySelector('.name').textContent = c.name;
  Contacts.paintAvatar(head.querySelector('.avatar'), c);
  return head;
}
/* UI.list com UMA secção: os .li saem pela ordem dos contactos, e cada avatar com foto é pintado depois */
function paintRowAvatars(listEl, contacts) {
  const lis = listEl.querySelectorAll('.li');
  contacts.forEach((c, i) => { if (!Contacts.photoId(c)) return; const a = lis[i] && lis[i].querySelector('.avatar'); if (a) Contacts.paintAvatar(a, c, false); });
  return listEl;
}
/* Bloquear/desbloquear com confirmação. Devolve true (bloqueou), false (desbloqueou) ou null (cancelado/falhou). */
async function toggleBlock(number, name) {
  const on = !Contacts.isBlocked(number), who = name || number;
  const ok = on ? await UI.confirm('Bloquear ' + who + '?', 'Deixas de receber chamadas e mensagens deste número.', 'Bloquear', true)
    : await UI.confirm('Desbloquear ' + who + '?', 'Voltas a receber chamadas e mensagens deste número.', 'Desbloquear');
  if (!ok) return null;
  const done = on ? await Contacts.block(number) : await Contacts.unblock(number);
  if (!done) { UI.toast(on ? 'Não foi possível bloquear' : 'Não foi possível desbloquear'); return null; }
  UI.toast(on ? 'Número bloqueado' : 'Número desbloqueado'); return on;
}

/* ---------- Folha de contacto: novo ou editar (nome, número, notas, foto) ----------
   Antes eram dois UI.prompt seguidos (nome e telefone). Devolve o contacto gravado ou null.
   o = { contact } para editar · { preset: { name, number } } para criar · focus: 'notes' */
function contactForm(o = {}) {
  return new Promise(res => {
    const k = o.contact || null, pre = o.preset || {};
    const startPhoto = k ? Contacts.photoId(k) : 0;
    let photoId = startPhoto, busy = false, finished = false;
    const body = UI.el(`<div style="padding-bottom:18px">
      <div style="display:flex;flex-direction:column;align-items:center;gap:8px;padding:4px 0 16px"><div class="cf-av"></div><div style="display:flex;gap:22px"><div class="cf-photo" style="color:var(--blue);cursor:pointer;font-size:var(--t-subhead)"></div><div class="cf-rm" style="color:var(--red);cursor:pointer;font-size:var(--t-subhead)">Remover foto</div></div></div>
      <div class="group"><div class="li static"><input type="text" class="cf-name" maxlength="64" placeholder="Nome"></div><div class="li static"><input type="tel" class="cf-num" maxlength="20" placeholder="Telefone"></div></div>
      <div class="group-header">Notas</div>
      <div class="group" style="padding:10px 16px"><textarea class="ta cf-notes" rows="4" maxlength="500" placeholder="Notas sobre este contacto"></textarea></div>
      <div class="group-footer cf-count"></div></div>`);
    const nameI = body.querySelector('.cf-name'), numI = body.querySelector('.cf-num'), notesI = body.querySelector('.cf-notes'), count = body.querySelector('.cf-count'), avHost = body.querySelector('.cf-av'), photoBtn = body.querySelector('.cf-photo'), rmBtn = body.querySelector('.cf-rm');
    /* valores pelo .value (nunca dentro do HTML): nomes e notas com aspas ou < ficam intactos */
    nameI.value = String((k ? k.name : pre.name) || ''); numI.value = String((k ? k.number : pre.number) || ''); notesI.value = String((k ? k.notes : pre.notes) || '').slice(0, 500);
    /* Nova UI: a silhueta enquanto não há nome, depois as iniciais com a cor das listas */
    const droidAv = () => { const nm = nameI.value.trim(); return nm ? UI.el(UI.avatar({ name: nm, avatar: (k && k.avatar) || nm.length }, 'aph-av s96')) : PhoneDroid.avatar(null, '', 's96'); };
    const nova = !!(window.PhoneDroid && PhoneDroid.sysFront());   /* Nova UI só com uma app do sistema à frente (o Zapp abre esta folha e fica como no PearOS) */
    const paintAv = () => { avHost.innerHTML = ''; const a = nova ? droidAv() : UI.el(UI.avatar({ name: nameI.value.trim() || '?', avatar: k && k.avatar }, 'lg')); avHost.appendChild(a); if (photoId) Contacts.paintAvatar(a, { avatarPhoto: photoId });
      photoBtn.textContent = photoId ? 'Alterar foto' : 'Adicionar foto'; rmBtn.style.display = photoId ? '' : 'none'; };
    const paintCount = () => { count.textContent = notesI.value.length + '/500'; };
    nameI.addEventListener('input', () => { if (!photoId) paintAv(); });
    notesI.addEventListener('input', paintCount);
    photoBtn.onclick = async () => { if (!window.Photos || !Photos.pick) { UI.toast(nova ? App.name('photos') + ' indisponível' : 'Fotos indisponíveis'); return; } const p = await Photos.pick('Foto do contacto'); if (!p || !(Math.floor(+p.id) > 0)) return; photoId = Math.floor(+p.id); paintAv(); };
    rmBtn.onclick = () => { photoId = 0; paintAv(); };
    paintAv(); paintCount();
    const sh = UI.sheet({ title: k ? 'Editar contacto' : 'Novo contacto', left: 'Cancelar', right: k ? 'OK' : 'Guardar', body,
      onClose: () => { if (!finished) { finished = true; res(null); } },
      onDone: () => {
        if (busy) return false;
        const nm = nameI.value.trim(), number = numI.value.trim();
        if (!nm) { UI.toast('Escreve um nome'); return false; }
        if (!number) { UI.toast('Escreve um número'); return false; }
        busy = true;
        (async () => {
          const notes = notesI.value.trim().slice(0, 500);
          const d = { name: nm, number };
          if (k) { d.id = k.id; if (notes !== (k.notes || '')) d.notes = notes; if (photoId !== startPhoto) d.avatarPhoto = photoId || false; }   /* false = tirar a foto (null não atravessa o JSON até ao Lua) */
          else { if (notes) d.notes = notes; if (photoId) d.avatarPhoto = photoId; }
          const r = await Contacts.save(d);
          busy = false;
          if (!r || r.error) { UI.alert({ title: 'Não foi possível guardar', msg: r && r.error === 'photo' ? 'Essa foto já não existe ou não é tua.' : 'Tenta novamente.' }); return; }
          const saved = Contacts.cache.find(x => x.id === (k ? k.id : r.id)) || r;
          /* servidor sem suporte a fotos/notas (ou que as recusou em silêncio): diz a verdade em vez de fingir */
          const got = saved.notes || '';
          /* o servidor corta as notas em 500 BYTES (um "ã" conta 2): notas longas com acentos ficam mais curtas */
          const cutNotes = ('notes' in d) && !!got && got !== notes && notes.startsWith(got);
          const lostPhoto = photoId && Contacts.photoId(saved) !== photoId, lostNotes = ('notes' in d) && got !== notes && !cutNotes;
          if (lostPhoto || lostNotes) UI.toast('Contacto guardado, mas ' + (lostPhoto && lostNotes ? 'a foto e as notas não' : lostPhoto ? 'a foto não' : 'as notas não'));
          else if (cutNotes) UI.toast('Contacto guardado; as notas foram cortadas no limite');
          finished = true; res(saved); sh.close();
        })();
        return false;
      } });
    if (o.focus === 'notes') setTimeout(() => { try { notesI.focus(); } catch (e) {} }, 420);
  });
}

/* ---------- Vista de contacto (partilhada: Contactos, Telefone e Mensagens) ---------- */
function contactDetail(win, c, backLabel, onChange) {
  if (window.PhoneDroid && PhoneDroid.sysWin(win)) return PhoneDroid.detail(win, c, backLabel, onChange);   /* Nova UI: ficha à Android (não no Zapp, que fica como no PearOS) */
  const k =() => Contacts.cache.find(x => x.id === c.id) || c;
  const v = UI.view({ title: '', back: backLabel, right: [{ label: 'Editar', onTap: async () => { const r = await contactForm({ contact: k() }); if (r) { render(); onChange && onChange(); } } }], onPop: () => offBlocks() });
  const render = () => {
    const x = k(); const top = v.content.scrollTop; v.content.innerHTML = '';
    v.content.appendChild(contactHead(x));
    v.content.appendChild(contactActions(x.number, x.name));
    const fav = () => (Contacts.byNumber(x.number) || {}).favorite;
    const bl = Contacts.isBlocked(x.number);
    const l = UI.list([
      { items: [{ label: 'telemóvel', sub: UI.phone(x.number), cls: 'blue', chevron: false, onTap: () => PhoneApp.call(x.number, x.name) }] },
      /* notas (Fase 2): texto inteiro, com mudanças de linha; tocar abre a edição já no campo das notas */
      { items: [{ label: 'notas', sub: x.notes || 'Adicionar notas', chevron: false, onTap: async () => { const r = await contactForm({ contact: k(), focus: 'notes' }); if (r) { render(); onChange && onChange(); } } }] },
      { items: [{ label: fav() ? 'Remover dos favoritos' : 'Adicionar aos favoritos', cls: 'blue', chevron: false, onTap: async li => { await Contacts.update({ id: x.id, favorite: !fav() }); li.querySelector('.li-label').textContent = fav() ? 'Remover dos favoritos' : 'Adicionar aos favoritos'; onChange && onChange(); } },
                 /* estas duas ENVIAM uma mensagem, como o botão de enviar das Mensagens: (1) modo de voo recusado antes de se
                    escolher o destino e (2) o "enviado" só se diz com a resposta na mão - o Bridge.rpc trocava o { error }
                    por null e o aviso de sucesso saía na mesma (bloqueado, sem rede, destino inexistente) */
                 /* CSHARE: com a partilha de contactos, escolhe-se "Com quem está perto" (contactshare.js) ou "Por mensagem" (o caminho de baixo) */
                 { label: 'Partilhar contacto', cls: 'blue', chevron: false, onTap: async () => { if (window.ContactShare && ContactShare.shareMenu) { ContactShare.shareMenu({ kind: 'contact', id: x.id, name: x.name, number: x.number, avatar: x.avatar, avatarPhoto: x.avatarPhoto }); return; } if (window.CC && CC.requireNet && !CC.requireNet('enviar o contacto')) return; const to = await Contacts.pick('Enviar contacto a'); if (!to) return; let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: to.number, type: 'contact', content: x.name, payload: { name: x.name, number: x.number } }); } catch (e) { r = null; } UI.toast(r && !r.error && r.id != null ? 'Contacto enviado' : 'Não foi possível enviar o contacto'); } },
                 { label: 'Localização partilhada', cls: 'blue', chevron: false, onTap: async () => { if (window.CC && CC.requireNet && !CC.requireNet('enviar a localização')) return; const p = await Bridge.call('getCoords'); if (!p) { UI.toast('Sem localização'); return; } let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: x.number, type: 'location', content: 'Localização', payload: { x: p.x, y: p.y, label: 'A minha localização' } }); } catch (e) { r = null; } UI.toast(r && !r.error && r.id != null ? 'Localização enviada' : 'Não foi possível enviar a localização'); } }] },
      { items: [{ label: bl ? 'Desbloquear este contacto' : 'Bloquear este contacto', cls: bl ? 'blue' : 'danger', chevron: false, onTap: async () => { if (await toggleBlock(x.number, x.name) != null) render(); } }] },
      { items: [{ label: 'Apagar contacto', cls: 'danger center', chevron: false, onTap: async () => { if (await UI.confirm('Apagar contacto', x.name, 'Apagar', true)) { await Contacts.remove(x.id); UI.pop(win); onChange && onChange(); } } }] }
    ]);
    /* o .li-sub corta numa linha com reticências (ui.css): nas notas quer-se o texto todo */
    const notesSub = l.querySelectorAll('.group')[1].querySelector('.li-sub');
    if (notesSub) { notesSub.style.whiteSpace = 'pre-wrap'; notesSub.style.overflow = 'visible'; notesSub.style.wordBreak = 'break-word'; notesSub.style.color = x.notes ? 'var(--label)' : 'var(--blue)'; }
    v.content.appendChild(l);
    v.content.scrollTop = top;
  };
  /* bloqueado/desbloqueado noutro sítio (Recentes, lista de bloqueados): a linha acompanha */
  let lastBl = Contacts.isBlocked(c.number);
  const offBlocks = Bridge.on('blocks', () => { if (!v.isConnected) { offBlocks(); return; } const now = Contacts.isBlocked(k().number); if (now !== lastBl) { lastBl = now; render(); } });
  render(); UI.push(win, v);
  Contacts.loadBlocks().then(() => { const now = Contacts.isBlocked(k().number); if (v.isConnected && now !== lastBl) { lastBl = now; render(); } });
  return v;
}

/* ---------- Informação de uma chamada de Recentes (número sem contacto) ---------- */
function recentInfo(win, r) {
  if (window.PhoneDroid && PhoneDroid.sysWin(win)) return PhoneDroid.numberInfo(win, r);
  const ct =Contacts.byNumber(r.number);
  if (ct) return contactDetail(win, ct, 'Recentes');
  const nm = r.name || r.number;
  const v = UI.view({ title: '', back: 'Recentes' });
  let lastBl = null;
  const render = () => {
    const bl = Contacts.isBlocked(r.number); if (bl === lastBl) return; lastBl = bl;
    v.content.innerHTML = '';
    v.content.appendChild(contactHead({ name: nm }));
    v.content.appendChild(contactActions(r.number, nm));
    v.content.appendChild(UI.list([
      { items: [{ label: 'telemóvel', sub: UI.phone(r.number), cls: 'blue', chevron: false, onTap: () => PhoneApp.call(r.number, nm) }] },
      { items: [{ label: 'Criar novo contacto', cls: 'blue', chevron: false, onTap: () => addContact(() => { if (v.isConnected && Contacts.byNumber(r.number)) UI.pop(win); }, { number: r.number, name: r.name }) }] },
      { items: [{ label: bl ? 'Desbloquear este número' : 'Bloquear este número', cls: bl ? 'blue' : 'danger', chevron: false, onTap: async () => { if (await toggleBlock(r.number, nm) != null) { lastBl = null; render(); } } }] }
    ]));
  };
  render(); UI.push(win, v);
  Contacts.loadBlocks().then(() => { if (v.isConnected) render(); });
  return v;
}

/* ---------- Contactos bloqueados ----------
   As Definições ainda não têm esta lista: vive aqui (fundo da lista de Contactos) e é global para as
   Definições a poderem empurrar com blockedView(win, 'Telefone'). */
function blockedView(win, backLabel) {
  const v = UI.view({ title: 'Contactos bloqueados', back: backLabel || true, full: !!(window.PhoneDroid && PhoneDroid.sysWin(win)), right: [{ icon: 'plus', onTap: async () => { const c = await Contacts.pick('Bloquear contacto'); if (!c || !c.number) return; if (Contacts.isBlocked(c.number)) { UI.toast('Já está bloqueado'); return; } if (await toggleBlock(c.number, c.name) != null) render(); } }] });
  const holder = UI.el('<div></div>'); v.content.appendChild(holder);
  let seq = 0;
  const render = async () => {
    const my = ++seq; holder.innerHTML = ''; holder.appendChild(UI.spinner());
    const list = await Contacts.loadBlocks(); if (my !== seq) return;
    holder.innerHTML = '';
    if (!list.length) { holder.appendChild(UI.empty('ban', 'Sem contactos bloqueados', 'Toca em + para bloquear um contacto.')); return; }
    const cs = list.map(b => Contacts.byNumber(b.number) || { name: b.number, number: b.number });
    /* texto fiel ao servidor: as chamadas deles dão "indisponível", as SMS deles ficam guardadas sem chegar;
       ligar-lhes continua possível, mas escrever-lhes exige desbloquear (messages.send → 'blocked') */
    holder.appendChild(paintRowAvatars(UI.list([{ items: list.map((b, i) => ({ avatar: cs[i], label: cs[i].name, sub: cs[i].name !== b.number ? b.number : '', value: 'Desbloquear', chevron: false, onTap: async () => { if (await toggleBlock(b.number, cs[i].name) != null) render(); } })), footer: 'Não recebes chamadas nem mensagens destes números. Podes continuar a ligar-lhes; para lhes escreveres tens de os desbloquear.' }]), cs));
  };
  UI.push(win, v); render();
  return v;
}

function contactsView(win, title) {
  /* "Contactos bloqueados" mais discreto (pedido do dono, 4 out): sai do fim da lista para o botao ... do topo, como na Nova UI */
  /* CSHARE: "Partilhar o meu contacto" no mesmo menu (contactshare.js) */
  const blockedMenu = b => { const n = Contacts.blocked.length; UI.ctxMenu(b, (window.ContactShare && ContactShare.enabled() ? [{ label: 'Partilhar o meu contacto', icon: 'airdrop', onTap: () => ContactShare.shareMine() }] : []).concat([{ label: n ? L.tf('Contactos bloqueados (%s)', n) : 'Contactos bloqueados', icon: 'ban', onTap: () => blockedView(win, title) }])); };
  const v = UI.view({ title, large: true, right: [{ icon: 'more', cls: 'glass', onTap: b => blockedMenu(b) }, { icon: 'plus', cls: 'glass', onTap: () => addContact(() => render('')) }], onPop: () => { offBlocks(); offCs(); } });
  v.content.appendChild(UI.search('Pesquisar', render));
  /* LISTA COMO A DOS CONTACTOS DO iOS (2026-09-19): corrida (sem cartões), letra de secção fixa no topo ao rolar, "O meu cartão"
     grande em cima e o índice A-Z à direita (tocar numa letra salta para ela). Só CSS (.ct-list/.ct-me/.ct-index em apps.css). */
  const holder = UI.el('<div class="ct-list"></div>'); v.content.appendChild(holder);
  const idx = UI.el('<div class="ct-index"></div>'); v.classList.add('ct-view'); v.appendChild(idx);
  let lastQ = '', shownBlocked = -1;
  /* a contagem da linha "Contactos bloqueados" acompanha os bloqueios feitos noutro sítio (menu de pressão
     longa, detalhe, Recentes) e a lista que chega do servidor depois de esta vista estar desenhada.
     O ouvinte sai no onPop (setRoot dos separadores) ou sozinho, se a janela tiver sido morta. */
  const offBlocks = Bridge.on('blocks', () => { if (!v.isConnected) { offBlocks(); return; } if (!lastQ && Contacts.blocked.length !== shownBlocked) { const top = v.content.scrollTop; render(lastQ).then(() => { v.content.scrollTop = top; }); } });
  /* CSHARE: um cartão aceite / trocado / recebido entra na lista aberta (a Nova UI já ouve o 'contacts') */
  const offCs = Bridge.on('cshare:saved', () => { if (!v.isConnected) { offCs(); return; } const top = v.content.scrollTop; render(lastQ).then(() => { v.content.scrollTop = top; }); });
  async function render(q) {
    lastQ = q; holder.innerHTML = ''; if (!Contacts.cache.length) await Contacts.load();
    if (q !== lastQ) return;   /* outra pesquisa começou durante o load */
    const p = System.player;
    idx.innerHTML = '';
    /* CSHARE: com a partilha de contactos, tocar no meu cartão escolhe como o partilhar e o botão redondo à direita abre logo
       a folha de quem está perto (contactshare.js); sem ela, fica o aviso com o nome e o número */
    if (!q) { const CS = window.ContactShare && ContactShare.enabled() ? ContactShare : null;
      const meBtn = CS ? UI.el(`<div class="csh-mebtn nostop" role="button">${UI.g('airdrop')}</div>`) : null; if (meBtn) meBtn.onclick = e => { e.stopPropagation(); CS.shareMine(); };
      const me = UI.list([{ items: [{ avatar: { name: p.firstname + ' ' + p.lastname, avatar: System.account && System.account.avatar, url: (System.account && System.account.avatarPhoto) || null }, label: `${p.firstname} ${p.lastname}`, sub: 'O meu cartão · ' + UI.phone(p.phone), right: meBtn || undefined, onTap: () => CS ? CS.shareMenu() : UI.alert({ title: 'O meu cartão', msg: `${p.firstname} ${p.lastname}\n${UI.phone(p.phone)}` }) }] }]); me.classList.add('ct-me'); holder.appendChild(me); }
    const list = Contacts.cache.filter(c => !q || c.name.toLowerCase().includes(q) || c.number.includes(q)).sort((a, b) => a.name.localeCompare(b.name));
    holder.classList.toggle('ct-isempty', !list.length);   /* vazio: o aviso fica ao centro do espaco livre (apps.css) */
    if (!list.length) holder.appendChild(UI.empty('personCircle', 'Sem contactos', 'Toque em + para adicionar.'));
    else {
      const groups = {}; list.forEach(c => { const k0 = (c.name[0] || '#').normalize('NFD').replace(/[̀-ͯ]/g, '').toUpperCase(); const k = /[A-Z]/.test(k0) ? k0 : '#'; (groups[k] = groups[k] || []).push(c); });
      const keys = Object.keys(groups).sort((a, b) => a === '#' ? 1 : b === '#' ? -1 : a.localeCompare(b));
      /* índice à direita: só as letras que existem; tocar salta para a secção (medido em px do ecrã → px de layout pelo zoom) */
      if (!q && keys.length > 1) keys.forEach(k => { const s = UI.el(`<span>${UI.esc(k)}</span>`); s.onclick = e => { e.stopPropagation(); const h = [...holder.querySelectorAll('.group-header')].find(x => x.textContent.trim() === k); if (!h) return; const R = UI.vrect || (n => n.getBoundingClientRect()), z = (UI.vrect ? UI.zoom(v.content) : UI.zoom()) || 1; v.content.scrollTop += (R(h).top - R(v.content).top) / z - 2; Sound.play('click'); }; idx.appendChild(s); });   /* px reais ÷ o zoom da lista (o do conteúdo no PearPhone Fold, ui.js) */
      keys.forEach(k => holder.appendChild(paintRowAvatars(UI.list([{ header: k, items: groups[k].map(c => ({ avatar: c, label: c.name, sub: UI.phone(c.number), chevron: false, onTap: () => contactDetail(win, c, title, () => render(lastQ)), onLong: li => UI.ctxMenu(li, [{ label: 'Ligar', icon: 'phone', onTap: () => PhoneApp.call(c.number, c.name) }, { label: 'Mensagem', icon: 'message', onTap: () => Msgs.open(c.number, c.name) }, { label: Contacts.isBlocked(c.number) ? 'Desbloquear' : 'Bloquear', icon: 'ban', onTap: () => toggleBlock(c.number, c.name) }, { label: 'Apagar', icon: 'trash', danger: true, onTap: async () => { await Contacts.remove(c.id); render(lastQ); } }]) })) }]), groups[k])));
    }
    /* Contactos bloqueados: no botao ... do topo (e em Definicoes > Privacidade); a contagem do menu le-se ao abrir */
    if (!q) shownBlocked = Contacts.blocked.length;
    if (UI.splitResel) UI.splitResel(win);   /* PearPhone Fold: o contacto aberto à direita continua marcado depois de repintar */
  }
  render(''); return v;
}
async function addContact(done, preset) { const r = await contactForm({ preset }); if (!r) return; UI.toast('Contacto guardado'); done && done(r); }

App.define('contacts', { name: 'Contactos', core: true, category: 'Produtividade', open(win) { if (window.PhoneDroid && PhoneDroid.on()) { UI.setRoot(win, PhoneDroid.contacts(win, { title: App.name('contacts') }));
    /* NOVA Fold8 aberto: a lista à esquerda e a ficha à direita */
    UI.split(win, { icon: 'personCircle', title: 'Nenhum contacto aberto', sub: 'Escolhe um contacto da lista para veres a ficha aqui.', row: '.aph-row' }); return; } UI.setRoot(win, contactsView(win, 'Contactos'));
  /* PearPhone Fold aberto: a lista à esquerda, a ficha do contacto à direita (ui.js UI.split) */
  UI.split(win, { icon: 'personCircle', title: 'Nenhum contacto aberto', sub: 'Escolhe um contacto da lista para veres a ficha aqui.' }); } });

/* Dobrável ABERTO (PearPhone Fold e NOVA Fold8): o separador Teclado fica com as chamadas recentes à esquerda (a largura da lista
   das duas colunas, --split-l) e o teclado à direita, em vez de um teclado sozinho no meio do ecrã largo. A coluna é a vista dos
   Recentes do próprio separador (mk: a mesma lista, filtros e menu), posta dentro da do teclado (.kp-side, oneui-apps1.css); entra e
   sai quando o dobrável abre ou fecha com a app aberta. Fechado e nos telemóveis nada muda */
function phoneKpSide(v, mk) {
  let side = null, live = false;
  const isOpen = () => !!(window.System && System.form === 'fold' && System.foldOpen);
  /* a barra direita do PearPhone Fold volta a ler os botões (os do "Limpar" entram e saem com a coluna) */
  const railNow = () => { const w = v.closest('.app-window'); if (w && UI.railOn && UI.railOn() && UI.railSync) UI.railSync(w); };
  const drop = quiet => { if (!side) return; try { const f = side.opts && side.opts.onPop; if (f) f(); } catch (e) {} side.remove(); side = null; v.classList.remove('kp-duo'); if (!quiet) railNow(); };
  const sync = () => {
    if (isOpen() && !side) {
      try { side = mk(); } catch (e) { console.error('[apex_phone] teclado: recentes ao lado', e); side = null; }
      if (!side) return;
      side.classList.add('kp-side'); if (!(window.PhoneDroid && PhoneDroid.on())) side.classList.add('lg-bare');
      v.appendChild(side); v.classList.add('kp-duo'); railNow();
    } else if (!isOpen()) drop();
  };
  sync();
  /* PearPhone Fold: os botões da barra dos Recentes ("Limpar") vão para a barra direita com os do teclado (ui.js railSync, v.rail);
     cada círculo toca no botão escondido da coluna */
  v.rail = () => { const bs = side ? [...side.querySelectorAll(':scope > .navbar .nb-right > .nb-btn')] : []; if (!bs.length) return null;
    return { primary: [bs.map((b, i) => ({ id: 'kps' + i, icon: b.dataset.ic || 'trash', label: b.dataset.lb || b.textContent.trim() || 'Limpar', onTap: () => b.click() }))] }; };
  const offs = ['fold:state', 'form:changed'].map(ev => Bridge.on(ev, () => { if (live && !v.isConnected) { off(); return; } setTimeout(sync, 0); }));
  const off = () => offs.forEach(f => { try { if (typeof f === 'function') f(); } catch (e) {} });
  setTimeout(() => { live = true; }, 0);
  const prev = v.opts && v.opts.onPop;
  if (v.opts) v.opts.onPop = () => { off(); drop(true); if (prev) prev(); };
}

/* estado de uma linha de Recentes (coluna status do servidor; linhas antigas sem ela: o texto de antes) */
function callLabel(r) {
  const st = r.status;
  if (st === 'declined') return 'Recusada';
  if (st === 'busy') return 'Ocupado';
  if (st === 'cancelled') return 'Cancelada';
  if (st === 'offline' || st === 'unavailable') return 'Indisponível';
  if (r.outgoing) return st === 'missed' ? 'Sem resposta' : 'Efetuada';
  return r.answered ? 'Recebida' : 'Não atendida';
}

/* Atalhos do long press no ícone: os FAVORITOS reais do jogador (antes "Ligar à Mãe" para um número inventado).
   Lista calculada na hora. É uma função (para o home.js que aceite `actions` como função) que também tem forEach,
   porque o home.js atual faz (d.actions || []).forEach(...) - e um getter não servia: o App.define copia as
   propriedades com Object.assign, que o avaliava uma única vez, ainda sem contactos. */
App.define('phone', {
  name: 'Telefone', core: true, category: 'Comunicação',
  /* Voltar da Nova UI: a vista de cima trata primeiro o que tem aberto (sugestões do teclado, pesquisa do registo) */
  back(win) { try { const top = win && win.querySelector(':scope > .nav-stack > .view:last-child'); return !!(top && typeof top._back === 'function' && top._back()); } catch (e) { return false; } },
  actions: (() => { const f = () => [...Contacts.cache.filter(c => c.favorite).slice(0, 3).map(c => ({ label: c.name, icon: 'phone', onTap: () => PhoneApp.call(c.number, c.name) })), { label: 'Teclado', icon: 'keypad', onTap: () => System.openApp('phone') }]; f.forEach = fn => f().forEach(fn); return f; })(),
  open(win) {
    if (window.PhoneDroid && PhoneDroid.on()) { PhoneDroid.app(win); return; }   /* Nova UI: Teclado · Recentes · Contactos */
    const favs = () => { const v = UI.view({ title: 'Favoritos', large: true, right: [{ icon: 'plus', onTap: () => tabs.go(2) }] }); const list = Contacts.cache.filter(c => c.favorite);
      if (!list.length) v.content.appendChild(UI.empty('star', 'Sem favoritos', 'Adiciona contactos aos favoritos.')); else v.content.appendChild(paintRowAvatars(UI.list([{ items: list.map(c => ({ avatar: c, label: c.name, sub: 'telemóvel', right: `<div class="li-chev nostop" style="color:var(--blue)">${UI.g('phone')}</div>`, chevron: false, onTap: () => PhoneApp.call(c.number, c.name) })) }]), list)); return v; };
    /* Recentes: estados do servidor (Não atendida a vermelho, Recusada, Ocupado, Cancelada, Indisponível), filtro
       "Não atendidas" como no PearOS, (i) abre o contacto ou o número, e abrir este separador limpa o emblema */
    const recents = () => {
      let rows = null, filter = 0;
      const v = UI.view({ title: 'Recentes', large: true, right: [{ label: 'Limpar', onTap: async () => { if (await UI.confirm('Limpar recentes', '', 'Limpar', true)) { await Bridge.rpc('calls.clear'); tabs.go(1); } } }],
        onPop: () => { if (PhoneMissed.live === live) PhoneMissed.live = null; } });
      const seg = UI.seg(['Todas', 'Não atendidas'], 0, i => { filter = i; draw(); });
      const holder = UI.el('<div></div>'); holder.appendChild(UI.spinner());
      v.content.append(seg, holder);
      const draw = () => {
        holder.innerHTML = '';
        if (!rows) { holder.appendChild(UI.spinner()); return; }
        const list = filter ? rows.filter(PhoneMissed.isMissed) : rows;
        if (!list.length) { holder.appendChild(UI.empty('clock', filter ? 'Sem chamadas não atendidas' : 'Sem chamadas recentes', '')); return; }
        holder.appendChild(UI.list([{ items: list.map(r => {
          const missed = PhoneMissed.isMissed(r), nm = r.name || Contacts.name(r.number);
          const info = UI.el(`<div class="li-chev nostop" style="color:var(--blue)">${UI.g('info')}</div>`);
          info.onclick = () => recentInfo(win, r);
          const bl = () => Contacts.isBlocked(r.number), known = Contacts.byNumber(r.number);
          return { icon: r.video ? 'video' : (r.outgoing ? 'arrowUp' : 'arrowDown'), iconBg: 'transparent', iconColor: missed ? 'var(--red)' : 'var(--label2)', html: `<span style="color:${missed ? 'var(--red)' : 'var(--label)'}">${UI.esc(nm)}</span>`,
            sub: (r.video ? 'FaceCall · ' : '') + callLabel(r) + (r.duration ? ' · ' + UI.fmtDur(r.duration) : ''), value: UI.rel(r.created), right: info, chevron: false,
            onTap: () => r.video ? PhoneApp.facetime(r.number, r.name) : PhoneApp.call(r.number, r.name),
            onLong: li => UI.ctxMenu(li, [{ label: 'Mensagem', icon: 'message', onTap: () => Msgs.open(r.number, r.name) },
              known ? { label: 'Ver contacto', icon: 'personCircle', onTap: () => contactDetail(win, known, 'Recentes') } : { label: 'Criar contacto', icon: 'personPlus', onTap: () => addContact(null, { number: r.number, name: r.name }) },
              { label: bl() ? 'Desbloquear' : 'Bloquear número', icon: 'ban', danger: !bl(), onTap: () => toggleBlock(r.number, nm) }]) };
        }) }]));
      };
      /* PhoneMissed chama isto quando chega uma chamada nova com este separador à vista */
      const live = { alive: () => v.isConnected, visible: () => v.isConnected && !v.nextElementSibling && System.currentApp() === 'phone' && !System.locked && !document.body.classList.contains('hidden'), update: l => { rows = l; draw(); } };
      PhoneMissed.live = live;
      /* sem resposta (rate limit, timeout) o emblema fica: o jogador não chegou a ver as chamadas perdidas */
      Bridge.rpc('calls.history').then(l => { rows = PhoneMissed.rowsOf(l); if (l != null) PhoneMissed.seen(rows); draw(); });
      return v; };
    const keypad = () => { const v = UI.view({ title: 'Teclado' }); const d = UI.el(`<div class="dial"><div class="dial-num"></div><div class="dial-hint"></div><div class="dial-keys"></div><div class="dial-actions"><div></div><div class="call-btn">${UI.g('phoneFill')}</div><div class="del-btn hidden">${UI.g('backspace')}</div></div></div>`);
      const num = d.querySelector('.dial-num'), hint = d.querySelector('.dial-hint'), keys = d.querySelector('.dial-keys'), del = d.querySelector('.del-btn'); let n = '';
      [['1', ''], ['2', 'ABC'], ['3', 'DEF'], ['4', 'GHI'], ['5', 'JKL'], ['6', 'MNO'], ['7', 'PQRS'], ['8', 'TUV'], ['9', 'WXYZ'], ['*', ''], ['0', '+'], ['#', '']].forEach(([k, l]) => { const b = UI.el(`<div class="dk"><span class="num">${k}</span><span class="abc">${l || '&nbsp;'}</span></div>`); b.onclick = () => { if (n.length < 14) n += k; Sound.play('keypad'); paint(); }; keys.appendChild(b); });
      const paint = () => { num.textContent = n; del.classList.toggle('hidden', !n); const c = Contacts.byNumber(n); hint.textContent = c ? c.name : (n.length >= 4 ? 'Adicionar número' : ''); hint.onclick = () => { if (!c && n.length >= 4) addContact(null, { number: n }); }; };
      del.onclick = () => { n = n.slice(0, -1); paint(); }; UI.longPress(del, () => { n = ''; paint(); });
      d.querySelector('.call-btn').onclick = () => { if (n) { PhoneApp.call(n); n = ''; paint(); } };
      v.content.appendChild(d);
      /* eSIM: no topo do teclado, o seletor da linha com que se liga (2+ linhas, como no PearPhone de dois SIM) ou o aviso "Sem SIM" */
      if (window.ESim && ESim.mount) ESim.mount(v, { app: 'phone', lineBar: true, float: true });
      v.onkey = e => { if (/^[0-9*#]$/.test(e.key)) { n += e.key; paint(); } else if (e.key === 'Backspace') { n = n.slice(0, -1); paint(); } else if (e.key === 'Enter' && n) { PhoneApp.call(n); n = ''; paint(); } };
      phoneKpSide(v, recents);   /* dobrável aberto: os Recentes à esquerda do teclado */
      return v; };
    /* Correio de voz: não existe no servidor (não há gravação de chamadas não atendidas). Antes mostrava
       duas mensagens inventadas ("Mãe", "Fleeca Bank"); agora diz a verdade. */
    const voicemail = () => { const v = UI.view({ title: 'Voicemail', large: true }); v.content.appendChild(UI.empty('voicemail', 'Sem correio de voz', 'Quem não atende fica com a chamada em Recentes.')); return v; };
    const tabs = UI.tabbar(win, [{ icon: 'star', label: 'Favoritos', view: favs }, { icon: 'clock', label: 'Recentes', view: recents }, { icon: 'personCircle', label: 'Contactos', view: () => contactsView(win, 'Contactos') }, { icon: 'keypad', label: 'Teclado', view: keypad }, { icon: 'voicemail', label: 'Voicemail', view: voicemail }], 3);
    win.addEventListener('keydown', e => { const v = win.querySelector('.view:last-child'); if (v && v.onkey && !e.target.matches('input,textarea')) v.onkey(e); });
    /* o off() TEM de ficar preso à janela: sem isto cada reconstrução da app (o sistema só
       guarda 7 janelas em LRU, por isso reconstrói muito) deixava mais uma subscrição viva */
    const offNotif = Bridge.on('notif:open', n => { if (n.app === 'phone' && System.currentApp() === 'phone') tabs.go(1); });
    win.onClose = () => offNotif();
  },
  /* voltar à app já aberta (multitarefa) com Recentes à vista: lista refeita e emblema limpo */
  resume() { if (PhoneMissed.live && PhoneMissed.live.alive()) PhoneMissed.soon(400); }
});

App.define('facetime', {
  name: 'FaceCall', category: 'Comunicação', statusBar: 'dark',   /* fundo escuro → texto da barra de estado BRANCO ('light' pintava-o de preto) */
  open(win) {
    if (window.FaceCallUI) { FaceCallUI.home(win); return; }   /* ecrã ao estilo do FaceTime (apps/facecall.js) */
    const root = UI.view({ title: 'FaceCall', large: true, right: [{ icon: 'video', onTap: async () => { const c = await Contacts.pick('Novo FaceCall'); if (c) PhoneApp.facetime(c.number, c.name); } }] });
    root.content.appendChild(UI.el('<div class="btn-p" style="margin-top:6px">Novo FaceCall</div>')).onclick = () => root.querySelector('.nb-btn').click();
    /* "Criar ligação" (facetime.apex.ls/join#rk) saiu deste ecrã de reserva: a ligação era inventada; as ligações a sério vivem no facecall.js */
    root.content.appendChild(UI.el('<div class="group-header">Recentes</div>')); const holder = UI.el('<div></div>'); root.content.appendChild(holder);
    Bridge.rpc('calls.history').then(l => { const list = PhoneMissed.rowsOf(l).filter(r => r.video); if (!list.length) { holder.appendChild(UI.el('<div class="group-footer">Sem chamadas FaceCall recentes.</div>')); return; } holder.appendChild(UI.list([{ items: list.map(r => ({ icon: 'video', iconBg: 'transparent', iconColor: PhoneMissed.isMissed(r) ? 'var(--red)' : 'var(--label2)', label: r.name || Contacts.name(r.number), sub: UI.rel(r.created) + ' · ' + callLabel(r) + (r.duration ? ' · ' + UI.fmtDur(r.duration) : ''), chevron: false, onTap: () => PhoneApp.facetime(r.number, r.name) })) }])); });
    UI.setRoot(win, root);
  }
});

/* =====================================================================
   NOVA UI 8.5 (Android): Telefone, Contactos e ecrãs de chamada
   ---------------------------------------------------------------------
   O mesmo motor (PhoneApp), as mesmas chamadas Bridge.rpc e os mesmos pushes do PearOS: aqui só muda a
   apresentação. Só corre com System.isAndroid(); o setOS mata as janelas, por isso cada vista nasce já no
   sistema certo. Classes com o prefixo aph- (a página é uma só: nomes genéricos colidem entre folhas).
   Movimento: só ao abrir e fechar e a seguir o dedo (arrastar); nada volta a animar num re-render.
   ===================================================================== */
window.PhoneDroid = (() => {
  const g = UI.g, esc = UI.esc;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const on = () => !!(window.System && typeof System.isAndroid === 'function' && System.isAndroid());
  const appName = id => (window.App && App.name ? App.name(id) : id);
  const dig = s => String(s == null ? '' : s).replace(/[^0-9]/g, '');
  const netOk = what => !(window.CC && CC.requireNet) || CC.requireNet(what);

  /* ---------- tons do fundo dos ecrãs de chamada ----------
     Sem color-mix() (no CEF a propriedade fica transparente e via-se a app por trás): a cor do avatar
     misturada com o branco (tema claro) e com o preto (tema escuro) é calculada aqui e vai em variáveis. */
  const rgb = h => { const n = parseInt(String(h || '').replace('#', ''), 16); return isFinite(n) ? [(n >> 16) & 255, (n >> 8) & 255, n & 255] : [94, 100, 112]; };
  const mix = (h, base, p) => '#' + rgb(h).map((x, i) => Math.round(x * p + base[i] * (1 - p)).toString(16).padStart(2, '0')).join('');
  function tint(seed) {
    const c = UI.avatarStyle(seed).match(/#[0-9A-Fa-f]{6}/g) || ['#5E6470', '#9AA0AA'];
    return `--aph-l1:${mix(c[0], [252, 252, 255], .22)};--aph-l2:${mix(c[1] || c[0], [245, 245, 247], .08)};--aph-d1:${mix(c[0], [14, 14, 16], .46)};--aph-d2:${mix(c[1] || c[0], [2, 2, 3], .14)}`;
  }

  /* ---------- peças pequenas ---------- */
  /* avatar redondo: iniciais com o gradiente da paleta; sem contacto, a silhueta (número desconhecido); a foto do contacto por cima pelo CSSOM */
  function avatar(c, name, cls, urgent) {
    if (!c && (!name || /^[\d\s+\-()#*]+$/.test(String(name)))) return UI.el(`<div class="avatar aph-av aph-anon ${cls || ''}">${g('person')}</div>`);
    /* a mesma cor que o ecrã da chamada usa (avatar escolhido ou o tamanho do nome), em todas as listas */
    const nm = (c && c.name) || name || '?';
    const a = UI.el(UI.avatar({ name: nm, avatar: (c && c.avatar) || String(nm).length }, 'aph-av ' + (cls || '')));
    if (c && Contacts.photoId(c)) Contacts.paintAvatar(a, c, !!urgent);
    return a;
  }
  /* subtítulo do título grande ("3 chamadas perdidas", "8 contactos"): dentro do .large-title, para acompanhar a zona de leitura */
  function ltSub(v, txt) {
    const lt = v.content.querySelector(':scope > .large-title'); if (!lt) return;
    let s = lt.querySelector('.aph-lt-sub'); if (!s) { s = document.createElement('small'); s.className = 'aph-lt-sub'; lt.appendChild(s); lt.classList.add('aph-lt2'); }
    s.textContent = txt || ''; s.classList.toggle('aph-hidden', !txt);
  }
  const dayLabel = ts => { const d = new Date(+ts), n = new Date(); if (d.toDateString() === n.toDateString()) return T('Hoje'); const y = new Date(n); y.setDate(n.getDate() - 1); if (d.toDateString() === y.toDateString()) return T('Ontem'); return UI.fmtDate(d); };
  const plural = (n, one, many) => n === 1 ? T(one) : n + ' ' + T(many);

  /* tipos de chamada como no registo da Nova UI: recebida (azul), efetuada (verde), perdida e recusada (vermelho) */
  const CT = { in: '<path d="M17 7l-9.5 9.5"/><path d="M15.5 16.5h-8v-8"/>', out: '<path d="M7 17l9.5-9.5"/><path d="M8.5 7.5h8v8"/>',
    miss: '<path d="M3.5 8.5l7.5 7.5 9.5-9.5"/><path d="M3.5 13.5v-5h5"/>', rej: '<circle cx="12" cy="12" r="8.5"/><path d="M6 18L18 6"/>' };
  const ctIcon = (k, s) => `<svg class="aph-cti" viewBox="0 0 24 24" width="${s || 16}" height="${s || 16}" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">${CT[k] || CT.in}</svg>`;
  const kindOf = r => { if (PhoneMissed.isMissed(r)) return 'miss'; if (!r.outgoing && r.status === 'declined') return 'rej'; return r.outgoing ? 'out' : 'in'; };

  /* ---------- deslizar uma linha: para a direita LIGA, para a esquerda abre a MENSAGEM ----------
     Só transform na linha; o gesto só arranca na horizontal (o scroll vertical continua a ser do browser). */
  function swipe(row, fg, act) {
    row.insertAdjacentHTML('afterbegin', `<div class="aph-sw aph-sw-r">${g('phoneFill', 22)}<span>${esc(T('Chamar'))}</span></div><div class="aph-sw aph-sw-l"><span>${esc(T('Mensagem'))}</span>${g('message', 22)}</div>`);
    let sx = 0, sy = 0, pid = null, drag = false, dx = 0, W = 1;
    fg.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; pid = e.pointerId; sx = e.clientX; sy = e.clientY; drag = false; dx = 0; });
    fg.addEventListener('pointermove', e => {
      if (pid === null || e.pointerId !== pid) return;
      const z = UI.zoom() || 1, mx = (e.clientX - sx) / z, my = (e.clientY - sy) / z;
      if (!drag) {
        if (Math.abs(mx) > 12 && Math.abs(mx) > Math.abs(my) * 1.5) { drag = true; W = fg.offsetWidth || 360; row.classList.add('aph-swiping'); fg.style.transition = 'none'; try { fg.setPointerCapture(pid); } catch (x) {} }
        else { if (Math.abs(my) > 10) pid = null; return; }
      }
      dx = Math.max(-W * .8, Math.min(W * .8, mx));
      fg.style.transform = `translateX(${dx.toFixed(1)}px)`;
      row.classList.toggle('to-r', dx > 0); row.classList.toggle('to-l', dx < 0); row.classList.toggle('armed', Math.abs(dx) > W * .3);
    });
    const end = e => {
      if (pid === null || (e && e.pointerId !== pid)) return; pid = null;
      if (!drag) return; drag = false; row._swiped = Date.now();
      fg.style.transition = ''; fg.style.transform = '';
      const go = Math.abs(dx) > W * .3 ? (dx > 0 ? act.right : act.left) : null;
      setTimeout(() => row.classList.remove('aph-swiping', 'to-r', 'to-l', 'armed'), 300);
      if (go) setTimeout(go, 140);
    };
    fg.addEventListener('pointerup', end); fg.addEventListener('pointercancel', end);
  }
  const swiped = row => Date.now() - (row._swiped || 0) < 350;

  /* menu de um número (manter premido numa linha) */
  function numberMenu(anchor, win, number, name, back) {
    const c = Contacts.byNumber(number), bl = Contacts.isBlocked(number);
    UI.ctxMenu(anchor, [
      { label: T('Mensagem'), icon: 'message', onTap: () => Msgs.open(number, name) },
      { label: appName('facetime'), icon: 'video', onTap: () => PhoneApp.facetime(number, name) },
      c ? { label: T('Ver contacto'), icon: 'personCircle', onTap: () => detail(win, c, back) } : { label: T('Adicionar aos contactos'), icon: 'personPlus', onTap: () => addContact(null, { number, name: name !== number ? name : '' }) },
      { label: T('Copiar número'), icon: 'copy', onTap: () => { if (window.Msgs && Msgs.copy) Msgs.copy(number); } },
      { label: bl ? T('Desbloquear') : T('Bloquear número'), icon: 'ban', danger: !bl, onTap: () => toggleBlock(number, name) }
    ]);
  }
  /* partilhar contacto e enviar localização: os MESMOS messages.send (tipos contact e location) do PearOS */
  async function shareContact(x) {
    /* CSHARE: "Com quem está perto" (contactshare.js) ou "Por mensagem"; sem id é o meu cartão (o servidor monta-o) */
    if (window.ContactShare && ContactShare.shareMenu) { ContactShare.shareMenu(x && x.id ? { kind: 'contact', id: x.id, name: x.name, number: x.number, avatar: x.avatar, avatarPhoto: x.avatarPhoto } : null); return; }
    if (!netOk('enviar o contacto')) return;
    const to = await Contacts.pick(T('Enviar contacto a')); if (!to) return;
    let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: to.number, type: 'contact', content: x.name, payload: { name: x.name, number: x.number } }); } catch (e) { r = null; }
    UI.toast(r && !r.error && r.id != null ? T('Contacto enviado') : T('Não foi possível enviar o contacto'));
  }
  async function sendLocation(number) {
    if (!netOk('enviar a localização')) return;
    const p = await Bridge.call('getCoords'); if (!p) { UI.toast(T('Sem localização')); return; }
    let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: number, type: 'location', content: 'Localização', payload: { x: p.x, y: p.y, label: 'A minha localização' } }); } catch (e) { r = null; }
    UI.toast(r && !r.error && r.id != null ? T('Localização enviada') : T('Não foi possível enviar a localização'));
  }

  /* ---------- T9: os dígitos escritos encontram contactos pelo NÚMERO e pelas LETRAS do nome ---------- */
  const KEYS = [['1', ''], ['2', 'ABC'], ['3', 'DEF'], ['4', 'GHI'], ['5', 'JKL'], ['6', 'MNO'], ['7', 'PQRS'], ['8', 'TUV'], ['9', 'WXYZ'], ['*', ''], ['0', '+'], ['#', '']];
  const T9 = {}; KEYS.forEach(([k, l]) => [...l].forEach(ch => { T9[ch] = k; }));
  const plain = s => String(s || '').normalize('NFD').replace(/[̀-ͯ]/g, '');
  const wordsOf = s => plain(s).toUpperCase().split(/[^A-Z0-9]+/).filter(Boolean);
  const t9 = w => [...w].map(ch => /[0-9]/.test(ch) ? ch : (T9[ch] || '')).join('');
  function matches(n) {
    const dn = dig(n); if (!dn) return [];
    const out = [];
    Contacts.cache.forEach(c => {
      const num = dig(c.number); let score = 0, hitNum = -1, hitName = -1;
      if (num === dn) score = 100; else if (num.startsWith(dn)) score = 80; else if (num.includes(dn)) score = 40;
      if (score) hitNum = num.indexOf(dn);
      const wi = wordsOf(c.name).findIndex(w => t9(w).startsWith(dn));
      if (wi > -1) { hitName = wi; if (score < 60) score = 60; }
      if (score) out.push({ c, score, hitNum, hitName });
    });
    return out.sort((a, b) => b.score - a.score || String(a.c.name).localeCompare(String(b.c.name), 'pt'));
  }
  /* realce das letras/dígitos que bateram (texto sempre escapado; só o <em> é marcação) */
  function hiName(name, wi, len) {
    if (wi < 0) return esc(name);
    let w = -1, inW = false, k = 0, out = '';
    for (const ch of String(name)) { const isW = /[A-Za-z0-9]/.test(plain(ch)); if (isW && !inW) { w++; k = 0; } inW = isW; const hl = isW && w === wi && k < len; if (isW) k++; out += hl ? `<em>${esc(ch)}</em>` : esc(ch); }
    return out.replace(/<\/em><em>/g, '');
  }
  function hiNum(num, at, len) {
    const full = UI.phone(num), pre = full.slice(0, full.length - String(num).length);
    if (at < 0) return esc(full);
    let d = 0, out = '';
    for (const ch of String(num)) { const isD = /[0-9]/.test(ch); const hl = isD && d >= at && d < at + len; if (isD) d++; out += hl ? `<em>${esc(ch)}</em>` : esc(ch); }
    return esc(pre) + out.replace(/<\/em><em>/g, '');
  }

  /* =====================================================================
     APP TELEFONE: Teclado · Recentes · Contactos
     ===================================================================== */
  function app(win) {
    const tabs = UI.tabbar(win, [
      { icon: 'keypad', label: T('Teclado'), view: () => keypad(win) },
      { icon: 'clock', label: T('Recentes'), view: () => recents(win) },
      { icon: 'personCircle', label: T('Contactos'), view: () => contacts(win, { title: T('Contactos') }) }
    ], 0);
    win.classList.add('aph-win');
    win.addEventListener('keydown', e => { const v = win.querySelector('.view:last-child'); if (v && v.onkey && !e.target.matches('input,textarea')) v.onkey(e); });
    /* chamada perdida tocada nas notificações: abre Recentes (o off fica preso à janela, como no PearOS) */
    const offNotif = Bridge.on('notif:open', n => { if (n && n.app === 'phone' && System.currentApp() === 'phone') tabs.go(1); });
    win.onClose = () => offNotif();
  }

  /* ---------- Teclado ---------- */
  function keypad(win) {
    const MAX = 20;
    const v = UI.view({ title: '', cls: 'aph-view aph-kp-view', right: [{ icon: 'moreV', onTap: b => menu(b) }] });
    const d = UI.el(`<div class="aph-kp"><div class="aph-kp-top"><div class="aph-kp-sug"></div><div class="aph-kp-num"></div><div class="aph-kp-add"></div><div class="aph-kp-more"></div></div>
      <div class="aph-kp-keys"></div>
      <div class="aph-kp-acts"><div class="aph-kp-side aph-kp-vid">${g('video', 26)}</div><div class="aph-kp-call">${g('phoneFill', 30)}</div><div class="aph-kp-side aph-kp-del">${g('backspace', 26)}</div></div></div>`);
    const $ = s => d.querySelector(s);
    const numEl = $('.aph-kp-num'), addEl = $('.aph-kp-add'), sugEl = $('.aph-kp-sug'), moreEl = $('.aph-kp-more'), keys = $('.aph-kp-keys');
    let n = '', ms = [];
    const put = k => { if (n.length >= MAX) return; n += k; Sound.play('keypad'); paint(); };
    KEYS.forEach(([k, l]) => {
      const b = UI.el(`<div class="aph-key"><b>${k}</b><span>${l || '&nbsp;'}</span></div>`);
      b.onclick = () => put(k);
      if (k === '0') UI.longPress(b, () => put('+'));   /* manter o 0 = + (indicativo) */
      keys.appendChild(b);
    });
    const closeMore = () => { moreEl.classList.remove('open'); moreEl.innerHTML = ''; };
    const fill = c => { n = UI.unphone(c.number).slice(0, MAX); closeMore(); paint(); };
    function openMore() {
      moreEl.innerHTML = ''; const dn = dig(n).length;
      ms.slice(0, 6).forEach(m => { const r = UI.el(`<div class="aph-kp-mi"><div class="aph-kp-sgb"><b>${hiName(m.c.name, m.hitName, dn)}</b><span>${hiNum(m.c.number, m.hitNum, dn)}</span></div></div>`); r.prepend(avatar(m.c, null, 's40')); r.onclick = e => { e.stopPropagation(); fill(m.c); }; moreEl.appendChild(r); });
      moreEl.classList.add('open');
    }
    function paint() {
      numEl.textContent = n; numEl.dataset.len = n.length > 15 ? 'xl' : n.length > 11 ? 'l' : '';
      d.classList.toggle('has-num', !!n);
      ms = n ? matches(n) : []; closeMore();
      const dn = dig(n).length, exact = ms.some(m => m.score === 100);
      sugEl.innerHTML = '';
      if (ms.length) {
        const m = ms[0];
        const row = UI.el(`<div class="aph-kp-sg"><div class="aph-kp-sgb"><b>${hiName(m.c.name, m.hitName, dn)}</b><span>${hiNum(m.c.number, m.hitNum, dn)}</span></div>${ms.length > 1 ? `<div class="aph-kp-cnt">+${ms.length - 1}</div>` : ''}</div>`);
        row.prepend(avatar(m.c, null, 's40'));
        row.onclick = e => { if (e.target.closest('.aph-kp-cnt')) { if (moreEl.classList.contains('open')) closeMore(); else openMore(); return; } fill(m.c); };
        sugEl.appendChild(row);
      }
      addEl.textContent = dn >= 3 && !exact ? T('Adicionar aos contactos') : '';
    }
    addEl.onclick = () => { if (n) addContact(() => paint(), { number: n }); };
    d.addEventListener('click', e => { if (moreEl.classList.contains('open') && !e.target.closest('.aph-kp-more,.aph-kp-cnt')) closeMore(); });
    const del = $('.aph-kp-del');
    del.onclick = () => { n = n.slice(0, -1); paint(); };
    UI.longPress(del, () => { n = ''; paint(); });
    /* algarismos iguais aos de um contacto (555-0303 escrito 5550303) ligam para o número tal como está guardado */
    const canon = x => { const dx = dig(x); const m = dx.length >= 3 && Contacts.cache.find(c => dig(c.number) === dx); return m ? m.number : x; };
    /* ligar com o campo vazio repõe o último número marcado (como no Telefone da Nova UI) */
    $('.aph-kp-call').onclick = async () => {
      if (n) { const x = canon(n); n = ''; paint(); PhoneApp.call(x); return; }
      let l = null; try { l = await Bridge.rpc('calls.history'); } catch (e) { l = null; }
      const last = PhoneMissed.rowsOf(l).filter(r => r.outgoing && r.number).sort((a, b) => (+b.created || 0) - (+a.created || 0))[0];
      if (last && v.isConnected) { n = String(last.number).slice(0, MAX); paint(); } else UI.toast(T('Escreve um número'));
    };
    $('.aph-kp-vid').onclick = () => { if (!n) { UI.toast(T('Escreve um número')); return; } const x = canon(n); n = ''; paint(); PhoneApp.facetime(x); };
    /* manter premido o número: colar (área de transferência interna das Mensagens) e copiar */
    UI.longPress(numEl, () => {
      const clip = window.Msgs && Msgs.clipboard ? String(Msgs.clipboard).replace(/[^\d+*#\s-]/g, '').trim() : '';
      const items = [];
      if (clip) items.push({ label: T('Colar'), icon: 'clipboard', onTap: () => { n = clip.slice(0, MAX); paint(); } });
      if (n) items.push({ label: T('Copiar'), icon: 'copy', onTap: () => Msgs.copy(n) });
      if (items.length) UI.ctxMenu(numEl, items); else UI.toast(T('Nada para colar'));
    });
    function menu(b) {
      const items = [];
      if (n && dig(n).length >= 3 && canon(n) === n && !Contacts.byNumber(n)) items.push({ label: T('Adicionar aos contactos'), icon: 'personPlus', onTap: () => addContact(() => paint(), { number: n }) });
      if (n) items.push({ label: T('Enviar mensagem'), icon: 'message', onTap: () => Msgs.open(canon(n)) });
      items.push({ label: T('Contactos bloqueados'), icon: 'ban', onTap: () => blockedView(win, appName('phone')) });
      UI.ctxMenu(b, items);
    }
    v.onkey = e => { if (/^[0-9*#+]$/.test(e.key)) put(e.key); else if (e.key === 'Backspace') { n = n.slice(0, -1); paint(); } else if (e.key === 'Enter' && n) $('.aph-kp-call').click(); };
    v.content.appendChild(d);
    if (window.ESim && ESim.mount) ESim.mount(v, { app: 'phone', lineBar: true, float: true });   /* eSIM: seletor da linha (2+) ou "Sem SIM", no topo do teclado */
    if (!Contacts.cache.length) Contacts.load();
    const offC = Bridge.on('contacts', () => { if (!v.isConnected) { if (v._live) offC(); return; } if (n) paint(); });
    v.opts.onPop = () => offC();   /* trocar de separador (setRoot) larga o ouvinte já, não à espera do próximo 'contacts' */
    v._back = () => { if (moreEl.classList.contains('open')) { closeMore(); return true; } return false; };   /* Voltar: fecha as sugestões abertas */
    setTimeout(() => { v._live = true; }, 0);
    paint();
    phoneKpSide(v, () => recents(win));   /* NOVA Fold8 aberto: o registo de chamadas à esquerda do teclado */
    return v;
  }

  /* ---------- Recentes ---------- */
  function recents(win) {
    let rows = null, filter = 0, query = '', openRow = null, missedNew = 0, maxSeen = null;
    const title = appName('phone');
    const v = UI.view({ title, large: true, cls: 'aph-view aph-rec-view', right: [{ icon: 'search', onTap: () => toggleSearch() }, { icon: 'moreV', onTap: b => menu(b) }],
      onPop: () => { if (PhoneMissed.live === live) PhoneMissed.live = null; } });
    const sbox = UI.search(T('Pesquisar no registo'), q => { query = q; draw(); }); sbox.classList.add('aph-search', 'aph-hidden');
    const chips = UI.chips([T('Todas'), T('Perdidas')], 0, i => { filter = i; draw(); }); chips.classList.add('aph-chips', 'aph-hidden');
    const holder = UI.el('<div class="aph-rec"></div>'); holder.appendChild(UI.skeleton('list', 5));
    v.content.append(sbox, chips, holder);
    function toggleSearch() {
      const hid = sbox.classList.toggle('aph-hidden');
      if (hid) { sbox.input.value = ''; sbox.classList.remove('has'); if (query) { query = ''; draw(); } }
      else setTimeout(() => { try { sbox.input.focus(); } catch (e) {} }, 60);
    }
    function menu(b) {
      UI.ctxMenu(b, [
        { label: T('Contactos bloqueados'), icon: 'ban', onTap: () => blockedView(win, title) },
        { label: T('Limpar registo de chamadas'), icon: 'trash', danger: true, onTap: async () => {
          if (!await UI.confirm(T('Limpar registo de chamadas'), T('As chamadas recentes são apagadas deste telemóvel.'), T('Limpar'), true)) return;
          await Bridge.rpc('calls.clear'); rows = []; missedNew = 0; paintSub(); draw(); } }
      ]);
    }
    const paintSub = () => ltSub(v, missedNew ? plural(missedNew, '1 chamada perdida', 'chamadas perdidas') : '');
    /* "N chamadas perdidas": as que ainda não tinham sido vistas quando esta lista abriu, e as que entram com ela à vista */
    const countNew = l => {
      const last = maxSeen != null ? maxSeen : (+Store.get('phone:missedSeen', 0) || 0);
      missedNew += l.filter(x => PhoneMissed.isMissed(x) && (Math.floor(+x.id) || 0) > last).length;
      maxSeen = l.reduce((m, x) => Math.max(m, Math.floor(+x.id) || 0), last); paintSub();
    };
    /* chamadas seguidas do mesmo número, no mesmo dia e do mesmo tipo juntam-se numa linha com a contagem */
    const runs = list => { const out = []; list.forEach(r => { const p = out[out.length - 1]; if (p && p.r.number === r.number && dayLabel(p.r.created) === dayLabel(r.created) && kindOf(p.r) === kindOf(r) && !!p.r.video === !!r.video) p.n++; else out.push({ r, n: 1 }); }); return out; };
    function draw() {
      openRow = null; holder.innerHTML = '';
      if (!rows) { holder.appendChild(UI.skeleton('list', 5)); return; }
      chips.classList.toggle('aph-hidden', !rows.length);
      let list = filter ? rows.filter(PhoneMissed.isMissed) : rows;
      if (query) list = list.filter(r => String(r.name || Contacts.name(r.number) || '').toLowerCase().includes(query) || String(r.number).includes(query));
      if (!list.length) { holder.appendChild(UI.empty('clock', query ? T('Sem resultados') : filter ? T('Sem chamadas perdidas') : T('Sem chamadas recentes'), query || filter ? '' : T('As chamadas que fazes e recebes aparecem aqui.'))); return; }
      let day = null, card = null;
      runs(list).forEach(gr => {
        const dl = dayLabel(gr.r.created);
        if (dl !== day) { day = dl; holder.appendChild(UI.el(`<div class="aph-sec">${esc(dl)}</div>`)); card = UI.el('<div class="aph-card"></div>'); holder.appendChild(card); }
        card.appendChild(row(gr));
      });
    }
    function row(gr) {
      const r = gr.r, c = Contacts.byNumber(r.number), nm = (c && c.name) || r.name || r.number, k = kindOf(r);
      const el = UI.el(`<div class="aph-row aph-rrow ${k === 'miss' || k === 'rej' ? 'is-miss' : ''}"><div class="aph-row-fg"><div class="aph-rb"><b></b><span class="aph-meta"><i class="aph-ct" data-k="${k}">${ctIcon(k, 15)}</i>${r.video ? `<i class="aph-ct" data-k="vid">${g('video', 14)}</i>` : ''}<em></em></span></div><div class="aph-rt"></div></div><div class="aph-acts"></div></div>`);
      const fg = el.querySelector('.aph-row-fg');
      fg.prepend(avatar(c || null, c ? c.name : (r.name || r.number), 's44'));
      fg.querySelector('b').textContent = (nm === r.number ? UI.phone(nm) : nm) + (gr.n > 1 ? ` (${gr.n})` : '');
      fg.querySelector('em').textContent = callLabel(r) + (r.duration ? ' · ' + UI.fmtDur(r.duration) : '');
      fg.querySelector('.aph-rt').textContent = UI.fmtTime(new Date(+r.created));
      fg.onclick = () => { if (!swiped(el)) expand(el, r, nm); };
      UI.longPress(fg, () => numberMenu(fg, win, r.number, nm, title));
      swipe(el, fg, { right: () => PhoneApp.call(r.number, nm), left: () => Msgs.open(r.number, nm) });
      return el;
    }
    /* tocar numa linha abre as ações por baixo dela (uma de cada vez), como no registo da Nova UI */
    function expand(el, r, nm) {
      if (openRow && openRow !== el) openRow.classList.remove('open');
      const open = !el.classList.contains('open'); el.classList.toggle('open', open); openRow = open ? el : null;
      const acts = el.querySelector('.aph-acts');
      if (open && !acts.firstChild) [['phoneFill', T('Chamar'), () => PhoneApp.call(r.number, nm)], ['message', T('Mensagem'), () => Msgs.open(r.number, nm)], ['video', appName('facetime'), () => PhoneApp.facetime(r.number, nm)], ['info', T('Detalhes'), () => numberInfo(win, r)]]
        .forEach(([ic, lb, fn]) => { const b = UI.el(`<div class="aph-act"><i>${g(ic, 22)}</i><span>${esc(lb)}</span></div>`); b.onclick = e => { e.stopPropagation(); fn(); }; acts.appendChild(b); });
    }
    /* PhoneMissed chama isto quando chega uma chamada nova com este separador à vista */
    const live = { alive: () => v.isConnected, visible: () => v.isConnected && !v.nextElementSibling && System.currentApp() === 'phone' && !System.locked && !document.body.classList.contains('hidden'), update: l => { countNew(l); rows = l; draw(); } };
    v._back = () => { if (!sbox.classList.contains('aph-hidden')) { toggleSearch(); return true; } return false; };   /* Voltar: fecha a pesquisa do registo */
    PhoneMissed.live = live;
    Bridge.rpc('calls.history').then(l => { const list = PhoneMissed.rowsOf(l); countNew(list); rows = list; if (l != null) PhoneMissed.seen(list); draw(); });
    return v;
  }

  /* ---------- Contactos (separador do Telefone e app Contactos) ---------- */
  function contacts(win, o = {}) {
    const title = o.title || T('Contactos');
    let query = '', asked = false, live = false;
    /* CSHARE: "Partilhar o meu contacto" também no menu (contactshare.js) */
    const v = UI.view({ title, large: true, cls: 'aph-view aph-ct-view', right: [{ icon: 'plus', onTap: () => addContact() }, { icon: 'moreV', onTap: b => UI.ctxMenu(b, (window.ContactShare && ContactShare.enabled() ? [{ label: T('Partilhar o meu contacto'), icon: 'airdrop', onTap: () => ContactShare.shareMine() }] : []).concat([{ label: T('Contactos bloqueados'), icon: 'ban', onTap: () => blockedView(win, title) }])) }], onPop: () => off() });
    const sbox = UI.search(T('Pesquisar'), q => { query = q; render(); }); sbox.classList.add('aph-search');
    const holder = UI.el('<div class="aph-clist"></div>'), idx = UI.el('<div class="aph-idx"></div>');
    v.content.append(sbox, holder); v.appendChild(idx);
    /* a lista acompanha os contactos e os bloqueios feitos noutro sítio; o ouvinte sai no onPop ou com a janela morta */
    const refresh = () => { if (!v.isConnected) { if (live) off(); return; } const top = v.content.scrollTop; render(); v.content.scrollTop = top; };
    const offs = [Bridge.on('contacts', refresh), Bridge.on('blocks', refresh)];
    const off = () => offs.splice(0).forEach(f => { try { f(); } catch (e) {} });
    setTimeout(() => { live = true; }, 0);
    function meCard() {
      const p = System.player || {}, acc = System.account || {};
      const nm = ((p.firstname || '') + ' ' + (p.lastname || '')).trim() || acc.username || T('Eu');
      const card = UI.el(`<div class="aph-card aph-me"><div class="aph-row-fg"><div class="aph-rb"><b></b><span></span></div></div></div>`);
      card.firstElementChild.prepend(UI.el(UI.avatar({ name: nm, avatar: acc.avatar, url: acc.avatarPhoto || null }, 'aph-av s56')));
      card.querySelector('b').textContent = nm; card.querySelector('span').textContent = T('O meu perfil') + (p.phone ? ' · ' + UI.phone(p.phone) : '');
      card.onclick = () => myProfile(win, title, nm);
      /* CSHARE: botão redondo para dar o cartão a quem está perto (contactshare.js) */
      if (window.ContactShare && ContactShare.enabled()) { const sb = UI.el(`<div class="csh-mebtn" role="button">${g('airdrop', 21)}</div>`); sb.onclick = e => { e.stopPropagation(); ContactShare.shareMine(); }; card.firstElementChild.appendChild(sb); }
      return card;
    }
    function crow(c) {
      const el = UI.el('<div class="aph-row"><div class="aph-row-fg"><div class="aph-rb"><b></b></div></div></div>');
      const fg = el.firstElementChild; fg.prepend(avatar(c, c.name, 's40')); fg.querySelector('b').textContent = c.name;
      if (Contacts.isBlocked(c.number)) fg.insertAdjacentHTML('beforeend', `<i class="aph-blk">${g('ban', 16)}</i>`);
      fg.onclick = () => { if (!swiped(el)) detail(win, c, title); };
      UI.longPress(fg, () => numberMenu(fg, win, c.number, c.name, title));
      swipe(el, fg, { right: () => PhoneApp.call(c.number, c.name), left: () => Msgs.open(c.number, c.name) });
      return el;
    }
    function render() {
      holder.innerHTML = ''; idx.innerHTML = '';
      const all = Contacts.cache.slice().sort((a, b) => String(a.name).localeCompare(String(b.name), 'pt'));
      ltSub(v, all.length ? plural(all.length, '1 contacto', 'contactos') : '');
      if (!all.length && !asked) { asked = true; holder.appendChild(UI.skeleton('list', 6)); Promise.resolve(Contacts.load()).then(() => { if (!Contacts.cache.length) refresh(); }); return; }
      if (!query) holder.appendChild(meCard());
      const dq = dig(query);
      const list = all.filter(c => !query || String(c.name).toLowerCase().includes(query) || String(c.number).includes(query) || (dq.length >= 2 && dig(c.number).includes(dq)));
      holder.classList.toggle('aph-isempty', !list.length);   /* vazio: o aviso fica ao centro do espaco livre (oneui-apps1.css) */
      if (!list.length) { holder.appendChild(UI.empty('personCircle', query ? T('Sem resultados') : T('Sem contactos'), query ? '' : T('Toca em + para adicionar um contacto.'))); }
      else {
        const favs = query ? [] : list.filter(c => c.favorite);
        if (favs.length) { holder.appendChild(UI.el(`<div class="aph-sec">${esc(T('Favoritos'))}</div>`)); const card = UI.el('<div class="aph-card"></div>'); favs.forEach(c => card.appendChild(crow(c))); holder.appendChild(card); }
        const groups = {}; list.forEach(c => { const k0 = plain(String(c.name || '#')[0] || '#').toUpperCase(); const k = /[A-Z]/.test(k0) ? k0 : '#'; (groups[k] = groups[k] || []).push(c); });
        const keys = Object.keys(groups).sort((a, b) => a === '#' ? 1 : b === '#' ? -1 : a.localeCompare(b));
        keys.forEach(k => { holder.appendChild(UI.el(`<div class="aph-sec" data-k="${esc(k)}">${esc(k)}</div>`)); const card = UI.el('<div class="aph-card"></div>'); groups[k].forEach(c => card.appendChild(crow(c))); holder.appendChild(card); });
        /* índice à direita: só as letras que existem; tocar salta para a secção (px do ecrã convertidos pelo zoom) */
        if (!query && keys.length > 1) keys.forEach(k => { const s = UI.el(`<span>${esc(k)}</span>`); s.onclick = e => { e.stopPropagation(); const h = [...holder.querySelectorAll('.aph-sec[data-k]')].find(x => x.dataset.k === k); if (!h) return; const z = UI.zoom() || 1; v.content.scrollTop += (h.getBoundingClientRect().top - v.content.getBoundingClientRect().top) / z - 6; Sound.play('click'); }; idx.appendChild(s); });
      }
      if (!query) {
        const n = Contacts.blocked.length;
        const bl = UI.el(`<div class="aph-card aph-blkcard"><div class="aph-row-fg"><div class="aph-ic">${g('ban', 20)}</div><div class="aph-rb"><b>${esc(T('Contactos bloqueados'))}</b></div><em>${n ? n : ''}</em></div></div>`);
        bl.onclick = () => blockedView(win, title); holder.appendChild(bl);
      }
    }
    render();
    return v;
  }

  /* ---------- Ficha do contacto (e de um número sem contacto) ---------- */
  const rbtn = (k, ic, lb) => `<div class="aph-rbtn" data-k="${k}"><i>${g(ic, 24)}</i><span>${esc(lb)}</span></div>`;
  const bbtn = (k, ic, lb) => `<div class="aph-bb" data-k="${k}">${g(ic, 22)}<span>${esc(lb)}</span></div>`;
  function card(win, o) {
    /* o = { contact } (conhecido) ou { number, name } (desconhecido); back, onChange */
    const known = !!o.contact;
    const k = () => (known ? (Contacts.cache.find(x => x.id === o.contact.id) || o.contact) : (Contacts.byNumber(o.number) || { name: o.name || o.number, number: o.number }));
    const v = UI.view({ title: '', back: o.back || true, full: true, cls: 'aph-view aph-cd-view', onPop: () => off() });
    const box = UI.el(`<div class="aph-cd">
      <div class="aph-cd-hero"><div class="aph-cd-avw"></div><div class="aph-cd-name"></div><div class="aph-cd-tag"></div></div>
      <div class="aph-cd-acts">${rbtn('call', 'phoneFill', T('Chamar'))}${rbtn('msg', 'message', T('Mensagem'))}${rbtn('vid', 'video', appName('facetime'))}</div>
      <div class="aph-card aph-cd-card"><div class="aph-cd-line" data-k="num"><div class="aph-cd-lt"><span>${esc(T('Telemóvel'))}</span><b></b></div><div class="aph-cd-ib" data-k="msg">${g('message', 20)}</div><div class="aph-cd-ib" data-k="vid">${g('video', 20)}</div></div></div>
      ${known ? `<div class="aph-card aph-cd-card"><div class="aph-cd-line" data-k="notes"><div class="aph-cd-lt"><span>${esc(T('Notas'))}</span><b></b></div></div></div>` : ''}
      <div class="aph-hist"></div></div>`);
    const bar = UI.el(known ? `<div class="aph-bbar">${bbtn('fav', 'star', T('Favorito'))}${bbtn('edit', 'pen', T('Editar'))}${bbtn('share', 'share', T('Partilhar'))}${bbtn('more', 'moreV', T('Mais'))}</div>`
      : `<div class="aph-bbar">${bbtn('add', 'personPlus', T('Criar contacto'))}${bbtn('copy', 'copy', T('Copiar'))}${bbtn('blk', 'ban', T('Bloquear'))}</div>`);
    v.content.appendChild(box); v.appendChild(bar); v.classList.add('aph-has-bbar');
    const $ = s => box.querySelector(s);
    let avKey = null, live = false;
    function paint() {
      const x = k();
      const key = (x.name || '') + '|' + (Contacts.photoId(x) || 0) + '|' + known;
      if (key !== avKey) { avKey = key; const w = $('.aph-cd-avw'); w.innerHTML = ''; w.appendChild(avatar(known ? x : null, known ? x.name : (o.name || o.number), 's120', true)); }
      $('.aph-cd-name').textContent = known ? x.name : (o.name && o.name !== o.number ? o.name : UI.phone(o.number));
      const bl = Contacts.isBlocked(x.number), tag = $('.aph-cd-tag');
      tag.textContent = bl ? T('Número bloqueado') : ''; tag.classList.toggle('aph-hidden', !bl);
      $('[data-k="num"] b').textContent = UI.phone(x.number);
      if (known) {
        const nb = $('[data-k="notes"] b'); nb.textContent = x.notes || T('Adicionar notas'); nb.classList.toggle('ph', !x.notes);
        const fb = bar.querySelector('[data-k="fav"]'); fb.classList.toggle('on', !!x.favorite); fb.innerHTML = g(x.favorite ? 'starFill' : 'star', 22) + `<span>${esc(T('Favorito'))}</span>`;
      } else { const bb = bar.querySelector('[data-k="blk"]'); bb.classList.toggle('on', bl); bb.querySelector('span').textContent = bl ? T('Desbloquear') : T('Bloquear'); }
    }
    const x = () => k();
    const nmOf = () => known ? x().name : (o.name || o.number);
    $('.aph-rbtn[data-k="call"]').onclick = () => PhoneApp.call(x().number, nmOf());
    $('.aph-rbtn[data-k="msg"]').onclick = () => Msgs.open(x().number, nmOf());
    $('.aph-rbtn[data-k="vid"]').onclick = () => PhoneApp.facetime(x().number, nmOf());
    const line = $('[data-k="num"]');
    line.onclick = e => { if (e.target.closest('.aph-cd-ib')) return; PhoneApp.call(x().number, nmOf()); };
    line.querySelector('[data-k="msg"]').onclick = e => { e.stopPropagation(); Msgs.open(x().number, nmOf()); };
    line.querySelector('[data-k="vid"]').onclick = e => { e.stopPropagation(); PhoneApp.facetime(x().number, nmOf()); };
    UI.longPress(line, () => UI.ctxMenu(line, [{ label: T('Copiar número'), icon: 'copy', onTap: () => Msgs.copy(x().number) }]));
    const edit = async focus => { const r = await contactForm({ contact: x(), focus }); if (r) { paint(); o.onChange && o.onChange(); } };
    if (known) {
      $('[data-k="notes"]').onclick = () => edit('notes');
      bar.querySelector('[data-k="fav"]').onclick = async () => { await Contacts.update({ id: x().id, favorite: !x().favorite }); paint(); o.onChange && o.onChange(); };
      bar.querySelector('[data-k="edit"]').onclick = () => edit();
      bar.querySelector('[data-k="share"]').onclick = () => shareContact(x());
      bar.querySelector('[data-k="more"]').onclick = () => UI.ctxMenu(bar.querySelector('[data-k="more"]'), [
        { label: T('Enviar a minha localização'), icon: 'location', onTap: () => sendLocation(x().number) },
        /* o "mail" dos quatro botões da ficha do PearOS: o Mail a compor para o número */
        { label: T('Enviar email'), icon: 'mail', onTap: () => (window.MailApp ? MailApp.compose({ to: x().number }) : System.openApp('mail')) },
        { label: Contacts.isBlocked(x().number) ? T('Desbloquear contacto') : T('Bloquear contacto'), icon: 'ban', onTap: async () => { if (await toggleBlock(x().number, x().name) != null) paint(); } },
        { label: T('Apagar contacto'), icon: 'trash', danger: true, onTap: async () => { if (await UI.confirm(T('Apagar contacto'), x().name, T('Apagar'), true)) { await Contacts.remove(x().id); UI.pop(win); o.onChange && o.onChange(); } } }
      ]);
    } else {
      bar.querySelector('[data-k="add"]').onclick = () => addContact(() => { if (v.isConnected && Contacts.byNumber(o.number)) UI.pop(win); }, { number: o.number, name: o.name && o.name !== o.number ? o.name : '' });
      bar.querySelector('[data-k="copy"]').onclick = () => Msgs.copy(o.number);
      bar.querySelector('[data-k="blk"]').onclick = async () => { if (await toggleBlock(o.number, nmOf()) != null) paint(); };
    }
    /* histórico deste número (o mesmo calls.history do Recentes) */
    Bridge.rpc('calls.history').then(l => {
      if (!v.isConnected && live) return;
      const rows = PhoneMissed.rowsOf(l).filter(r => r.number === x().number).sort((a, b) => (+b.created || 0) - (+a.created || 0)).slice(0, 5);
      if (!rows.length) return;
      const h = $('.aph-hist'); h.appendChild(UI.el(`<div class="aph-sec">${esc(T('Histórico'))}</div>`)); const cd = UI.el('<div class="aph-card"></div>');
      rows.forEach(r => { const kk = kindOf(r); const it = UI.el(`<div class="aph-hrow ${kk === 'miss' || kk === 'rej' ? 'is-miss' : ''}"><i class="aph-ct" data-k="${kk}">${ctIcon(kk, 16)}</i><div class="aph-rb"><b></b><span></span></div><em></em></div>`);
        it.querySelector('b').textContent = (r.video ? appName('facetime') + ' · ' : '') + callLabel(r); it.querySelector('span').textContent = r.duration ? UI.fmtDur(r.duration) : '';
        it.querySelector('em').textContent = dayLabel(r.created) + ', ' + UI.fmtTime(new Date(+r.created)); cd.appendChild(it); });
      h.appendChild(cd);
    });
    const alive =() => { if (v.isConnected) { live = true; return true; } if (live) off(); return false; };
    const offs = [Bridge.on('contacts', () => { if (alive()) paint(); }), Bridge.on('blocks', () => { if (alive()) paint(); })];
    const off = () => offs.splice(0).forEach(f => { try { f(); } catch (e) {} });
    paint(); UI.push(win, v); live = true;
    Contacts.loadBlocks().then(() => { if (alive()) paint(); });
    return v;
  }
  const detail = (win, c, back, onChange) => card(win, { contact: c, back, onChange });
  function numberInfo(win, r, back) { const ct = Contacts.byNumber(r.number); if (ct) return detail(win, ct, back || appName('phone')); return card(win, { number: r.number, name: r.name, back: back || appName('phone') }); }
  /* o meu perfil: nome, número (copiar) e partilhar o meu contacto pelo mesmo messages.send */
  function myProfile(win, back, nm) {
    const p = System.player || {}, acc = System.account || {};
    const v = UI.view({ title: '', back: back || true, full: true, cls: 'aph-view aph-cd-view' });
    const box = UI.el(`<div class="aph-cd"><div class="aph-cd-hero"><div class="aph-cd-avw"></div><div class="aph-cd-name"></div><div class="aph-cd-tag me">${esc(T('O meu perfil'))}</div></div>
      <div class="aph-card aph-cd-card"><div class="aph-cd-line" data-k="num"><div class="aph-cd-lt"><span>${esc(T('O meu número'))}</span><b></b></div><div class="aph-cd-ib" data-k="cp">${g('copy', 20)}</div></div></div>
      <div class="aph-card aph-cd-card"><div class="aph-cd-line" data-k="share"><div class="aph-cd-lt"><b class="lnk">${esc(T('Partilhar o meu contacto'))}</b></div></div></div></div>`);
    box.querySelector('.aph-cd-avw').appendChild(UI.el(UI.avatar({ name: nm, avatar: acc.avatar, url: acc.avatarPhoto || null }, 'aph-av s120')));
    box.querySelector('.aph-cd-name').textContent = nm; box.querySelector('[data-k="num"] b').textContent = UI.phone(p.phone || '');
    box.querySelector('[data-k="num"]').onclick = () => { if (p.phone) Msgs.copy(p.phone); };
    box.querySelector('[data-k="share"]').onclick = () => { if (p.phone) shareContact({ name: nm, number: p.phone }); };
    v.content.appendChild(box); UI.push(win, v); return v;
  }

  /* =====================================================================
     ECRÃS DE CHAMADA (o motor do PhoneApp pinta [data-hook] e liga/desliga [data-act])
     ===================================================================== */
  const cbtn = (a, ic, lb) => `<div class="aph-cb" data-act="${a}"><i>${g(ic, 26)}</i><span>${esc(lb)}</span></div>`;
  /* atendida no ecrã inteiro: o ecrã da chamada entra no lugar dele sem deslizar (senão via-se a app por trás um instante) */
  let acceptedAt = 0;
  const justAccepted = () => Date.now() - acceptedAt < 1500;
  /* ctx = { cur, end, setMute, setSpeaker, minimize, seed, routeAirpods, routeBudsName } */
  function callScreen(ctx) {
    const cur = ctx.cur || {};
    const el = UI.el(`<div class="aph-call" style="${tint(ctx.seed)}">
      <div class="aph-c-top"><div class="aph-c-min">${g('chevD', 26)}</div></div>
      <div class="aph-c-head"><div class="aph-c-name" data-hook="name"></div><div class="aph-c-num"></div><div class="aph-c-stat" data-hook="status"></div><div class="aph-c-muted">${g('micOff', 13)}<span>${esc(T('Microfone desligado'))}</span></div></div>
      <div class="aph-c-mid"><div class="aph-c-avw"><div class="avatar aph-c-av" data-hook="avatar"></div></div>
        <div class="aph-c-kp"><div class="aph-c-kpn"></div><div class="aph-c-keys"></div><div class="aph-c-kph">${esc(T('Ocultar teclado'))}</div></div></div>
      <div class="aph-c-grid">${cbtn('ct', 'personCircle', T('Contactos'))}${cbtn('vid', 'video', appName('facetime'))}${cbtn('route', 'bluetooth', T('Bluetooth'))}${cbtn('spk', 'speaker', T('Altifalante'))}${cbtn('mute', 'micOff', T('Silenciar'))}${cbtn('kp', 'keypad', T('Teclado'))}</div>
      <div class="aph-c-endw"><div class="aph-c-end" data-act="end">${g('phoneDown', 32)}</div></div></div>`);
    if (justAccepted()) el.classList.add('aph-still');
    const $ = s => el.querySelector(s);
    $('.aph-c-min').onclick = () => ctx.minimize();
    UI.swipe($('.aph-c-head'), { down: () => ctx.minimize(), threshold: 70 });
    $('[data-act="end"]').onclick = () => ctx.end();
    $('[data-act="mute"]').onclick = () => ctx.setMute(!cur.muted);
    $('[data-act="spk"]').onclick = () => ctx.setSpeaker(!cur.speaker);
    $('[data-act="ct"]').onclick = () => { ctx.minimize(); System.openApp('contacts'); };
    /* passar uma chamada de voz a vídeo não existe do lado do jogo: diz-se, em vez de fingir */
    $('[data-act="vid"]').onclick = () => UI.toast(T('Passar esta chamada a videochamada não está disponível'));
    /* teclado durante a chamada: ocupa o lugar do avatar e dos botões; o botão vermelho fica */
    const kpn = $('.aph-c-kpn'), keys = $('.aph-c-keys');
    KEYS.forEach(([k, l]) => { const b = UI.el(`<div class="aph-key"><b>${k}</b><span>${l || '&nbsp;'}</span></div>`); b.onclick = () => { kpn.textContent = (kpn.textContent + k).slice(-22); Sound.play('keypad'); }; keys.appendChild(b); });
    /* aberto, o teclado entra no registo das camadas (UI.track): o Voltar do Android fecha-o antes de levar a chamada para o chip.
       Sai do registo ao fechar, ao minimizar (_fcActive) e quando o ecrã acaba (_kpOff, no finish) */
    let kpUntrack = null;
    const kp = open => { el.classList.toggle('kp-open', open); $('[data-act="kp"]').classList.toggle('on', open);
      if (open && !kpUntrack) kpUntrack = UI.track(() => { kpUntrack = null; kp(false); });
      else if (!open && kpUntrack) { const u = kpUntrack; kpUntrack = null; u(); } };
    el._kpOff = () => kp(false);
    el._fcActive = on => { if (!on) kp(false); };
    $('[data-act="kp"]').onclick = () => kp(!el.classList.contains('kp-open'));
    $('.aph-c-kph').onclick = () => kp(false);
    /* saída de áudio: Telemóvel · Altifalante · auriculares (só postos E ligados, como no PearOS) */
    const route = $('[data-act="route"]');
    el._route = () => {
      const ap = !!ctx.routeAirpods(), label = ap ? ctx.routeBudsName() : T('Bluetooth');
      const key = ap ? 'earbuds:' + label : 'phone';
      if (route.dataset.route === key) return;
      route.dataset.route = key;
      route.classList.toggle('on', ap);
      route.querySelector('i').innerHTML = g(ap ? 'earbuds' : 'bluetooth', 26);
      route.querySelector('span').textContent = label;
    };
    route.onclick = async () => {
      const ap = !!ctx.routeAirpods();
      const v = await UI.actionSheet({ title: T('Saída de áudio'), buttons: [{ label: T('Telemóvel'), icon: 'phone', value: 'phone' }, { label: T('Altifalante'), icon: 'speaker', value: 'spk' }].concat(ap ? [{ label: ctx.routeBudsName(), icon: 'earbuds', value: 'ap' }] : []) });
      if (v === 'spk') ctx.setSpeaker(true); else if (v === 'phone') ctx.setSpeaker(false); else if (v === 'ap') { ctx.setSpeaker(false); UI.toast(T('Com os auriculares ligados podes guardar o telemóvel durante a chamada.')); }
    };
    el._route();
    const numEl = $('.aph-c-num');
    const avEl = $('[data-hook="avatar"]');
    el._onPaint = c => {
      const same = !c.name || c.name === c.number || UI.unphone(c.name) === String(c.number);
      const txt = same ? '' : T('Telemóvel') + ' ' + UI.phone(c.number); if (numEl.textContent !== txt) numEl.textContent = txt;
      /* número desconhecido: a silhueta em vez de iniciais feitas de algarismos (só quando muda o nome/número) */
      const anon = same && !Contacts.byNumber(c.number), mark = String(anon) + '|' + (avEl.dataset.k || '');
      if (avEl.dataset.anon !== mark) { avEl.dataset.anon = mark; avEl.classList.toggle('aph-anon', anon); if (anon) avEl.innerHTML = g('person'); }
    };
    return el;
  }

  /* ---------- chamada recebida em ecrã inteiro: arrastar o círculo verde atende, o vermelho recusa ----------
     Um clique simples também serve (no FiveM é rato). Nada pulsa em ciclo: só o círculo segue o dedo. */
  function incoming(o) {
    const c = Contacts.byNumber(o.number);
    const named = o.name && o.name !== o.number && UI.unphone(o.name) !== String(o.number);
    const el = UI.el(`<div class="aph-inc" style="${tint(o.seed)}">
      <div class="aph-i-head"><div class="aph-i-lbl">${g(o.video ? 'video' : 'phone', 15)}<span>${esc(o.video ? T('Videochamada recebida') : T('Chamada recebida'))}</span></div><div class="aph-i-name"></div><div class="aph-i-num"></div></div>
      <div class="aph-i-mid"></div>
      <div class="aph-i-ctl"><div class="aph-i-b" data-k="acc"><div class="aph-i-halo"></div><div class="aph-i-knob">${g(o.video ? 'video' : 'phoneFill', 30)}</div></div><div class="aph-i-hint">${esc(T('Arrasta ou toca'))}</div><div class="aph-i-b" data-k="dec"><div class="aph-i-halo"></div><div class="aph-i-knob">${g('phoneDown', 30)}</div></div></div>
      <div class="aph-i-msg">${g('message', 18)}<span>${esc(T('Enviar mensagem'))}</span></div></div>`);
    el.querySelector('.aph-i-name').textContent = named ? o.name : UI.phone(o.number);
    el.querySelector('.aph-i-num').textContent = named ? T('Telemóvel') + ' ' + UI.phone(o.number) : '';
    const av = c ? avatar(c, c.name, 'aph-i-av', true) : avatar(null, named ? o.name : o.number, 'aph-i-av');
    el.querySelector('.aph-i-mid').appendChild(av);
    let done = false;
    const fire = fn => { if (done) return; done = true; el.classList.add('done'); if (fn === o.accept) acceptedAt = Date.now(); try { fn(); } catch (e) { console.error('[apex_phone] chamada recebida', e); } };
    const R = 110;
    function drag(b, fn) {
      const knob = b.querySelector('.aph-i-knob'), halo = b.querySelector('.aph-i-halo'); let s = null;
      const reset = () => { b.classList.remove('drag'); el.classList.remove('drag-acc', 'drag-dec'); knob.style.transform = ''; halo.style.transform = ''; halo.style.opacity = ''; };
      knob.addEventListener('pointerdown', e => { if (done || (e.button && e.pointerType === 'mouse')) return; s = { x: e.clientX, y: e.clientY, z: UI.zoom() || 1, t: Date.now(), moved: false }; try { knob.setPointerCapture(e.pointerId); } catch (x) {} b.classList.add('drag'); el.classList.add(b.dataset.k === 'acc' ? 'drag-acc' : 'drag-dec'); });
      knob.addEventListener('pointermove', e => {
        if (!s) return; let dx = (e.clientX - s.x) / s.z, dy = (e.clientY - s.y) / s.z; const d = Math.hypot(dx, dy);
        if (d > 6) s.moved = true;
        if (d > R) { dx = dx / d * R; dy = dy / d * R; }
        const p = Math.min(1, d / R);
        knob.style.transform = `translate(${dx.toFixed(1)}px,${dy.toFixed(1)}px)`; halo.style.transform = `scale(${(1 + p * 1.5).toFixed(3)})`; halo.style.opacity = (.35 + p * .45).toFixed(3);
        if (d >= R) { s = null; fire(fn); }
      });
      knob.addEventListener('pointerup', () => { if (!s) return; const st = s; s = null; if (!st.moved && Date.now() - st.t < 700) { fire(fn); return; } reset(); });
      knob.addEventListener('pointercancel', () => { if (!s) return; s = null; reset(); });
    }
    drag(el.querySelector('.aph-i-b[data-k="acc"]'), o.accept); drag(el.querySelector('.aph-i-b[data-k="dec"]'), o.decline);
    /* respostas rápidas: a mensagem sai pelo messages.send de sempre e a chamada é recusada */
    el.querySelector('.aph-i-msg').onclick = async () => {
      if (done) return;
      const v = await UI.actionSheet({ title: T('Responder com mensagem'), buttons: [T('Não posso falar agora.'), T('Ligo-te já.'), T('Estou a caminho.'), T('Estou a conduzir, ligo-te depois.')].map(t => ({ label: t, value: t })).concat([{ label: T('Escrever mensagem…'), value: '_' }]) });
      if (!v || done) return; let text = v;
      if (v === '_') { text = await UI.prompt(T('Mensagem'), '', T('Escreve a resposta')); if (!text || done) return; }
      done = true; el.classList.add('done'); o.reply(text);
    };
    requestAnimationFrame(() => el.classList.add('in'));
    return el;
  }

  /* fim de uma chamada sem resposta: Ligar novamente · Mensagem · Fechar no lugar dos botões */
  function endCard(el, f) {
    const vid = el.classList.contains('afc-call');
    const bar = UI.el(`<div class="aph-c-endbar"><div data-x="again"><i>${g(vid ? 'video' : 'phoneFill', 24)}</i><span>${esc(T('Ligar novamente'))}</span></div><div data-x="msg"><i>${g('message', 24)}</i><span>${esc(T('Mensagem'))}</span></div><div data-x="close"><i>${g('x', 24)}</i><span>${esc(T('Fechar'))}</span></div></div>`);
    bar.querySelector('[data-x="again"]').onclick = f.again; bar.querySelector('[data-x="msg"]').onclick = f.msg; bar.querySelector('[data-x="close"]').onclick = f.close;
    el.classList.remove('kp-open'); el.classList.add('endcard'); el.appendChild(bar);
    requestAnimationFrame(() => bar.classList.add('in'));
  }

  /* as fichas e folhas partilhadas (contactDetail, contactForm, blockedView) também abrem no Zapp, que é de terceiros e fica igual
     nos dois sistemas: a Nova UI só entra numa janela do sistema (sysWin) ou com uma app do sistema à frente (sysFront) */
  const sysWin = w => on() && !(w && w.classList && w.classList.contains('ou-3p'));
  const sysFront = () => { if (!on()) return false; try { const id = System.currentApp && System.currentApp(); const w = id && System.windows && System.windows[id]; return !id || (!(w && w.classList && w.classList.contains('ou-3p')) && !!(UI.OU_APPS && UI.OU_APPS.has(id))); } catch (e) { return true; } };
  return { on, sysWin, sysFront, app, keypad, recents, contacts, detail, numberInfo, myProfile, callScreen, incoming, endCard, avatar, tint, ctIcon, kindOf, dayLabel, swipe, swiped, ltSub, plural, justAccepted };
})();

/* ---------- Mocks do browser (Fase 2): contacts.* com notas/foto e blocks.* ----------
   Só existem fora do FiveM (o localdb.js não é carregado no jogo). Espelham o contrato do servidor
   (ARQUITETURA 8.3): notes ≤ 500, avatarPhoto = id de uma foto do próprio (false/0 tira a foto; null
   não chega ao Lua, por isso aqui também não mexe), blocks.list → [{ number, created }].
   Este pacote é o DONO do mock de blocks.* (as Mensagens não registam outro). */
if (window.LocalDB && LocalDB.register) (() => {
  const T = LocalDB.T, now = LocalDB.now;
  const cut = (s, n) => String(s == null ? '' : s).slice(0, n);
  const num = v => (typeof v === 'string' || typeof v === 'number') ? String(v).trim().slice(0, 20) : '';
  const photoOk = id => T('photos').all().some(p => +p.id === +id);   /* no mock todas as fotos são do DEV0000 */
  const shape = c => Object.assign({}, c, { notes: c.notes == null || c.notes === '' ? null : c.notes, avatarPhoto: +c.avatarPhoto > 0 ? +c.avatarPhoto : null });
  LocalDB.register('contacts.list', () => T('contacts').all().map(shape).sort((a, b) => String(a.name).localeCompare(String(b.name))));
  LocalDB.register('contacts.add', d => {
    const name = cut(d.name, 64), number = cut(d.number, 20); if (!name || !number) return { error: 'invalid' };
    let ap = null; if (d.avatarPhoto) { if (!photoOk(d.avatarPhoto)) return { error: 'photo' }; ap = +d.avatarPhoto; }
    return shape(T('contacts').insert({ owner: 'DEV0000', name, number, avatar: d.avatar == null ? null : d.avatar, favorite: !!d.favorite, notes: d.notes == null ? null : cut(d.notes, 500), avatarPhoto: ap }));
  });
  LocalDB.register('contacts.update', d => {
    const rows = T('contacts').all(); const c = rows.find(x => x.id === d.id || x.id === +d.id); if (!c) return { error: 'notfound' };
    if (d.avatarPhoto !== undefined && d.avatarPhoto !== null) { if (d.avatarPhoto === false || +d.avatarPhoto === 0) c.avatarPhoto = null; else if (photoOk(d.avatarPhoto)) c.avatarPhoto = +d.avatarPhoto; else return { error: 'photo' }; }
    if (d.name != null) { const n = cut(d.name, 64); if (n) c.name = n; }
    if (d.number != null) { const n = cut(d.number, 20); if (n) c.number = n; }
    if (d.favorite != null) c.favorite = !!d.favorite;
    if (d.avatar != null) c.avatar = d.avatar;
    if (d.notes != null) c.notes = cut(d.notes, 500) || null;
    T('contacts').set(rows); return shape(c);
  });
  /* por personagem (LocalDB.switchCharacter), como no servidor (owner = cid). Linhas sem owner (mocks antigos)
     contam para toda a gente - é a mesma regra do messages.send do mock das Mensagens (blockedByMe). */
  const mine = b => !!b && (!b.owner || b.owner === LocalDB.cid);
  /* { number, created, name? }: o servidor junta o nome dos contactos (LEFT JOIN) - campo aditivo, o Contacts.loadBlocks ignora-o */
  LocalDB.register('blocks.list', () => { const cs = T('contacts').all();
    return T('blocks').all().filter(mine).sort((a, b) => (b.created || 0) - (a.created || 0)).map(b => { const o = { number: b.number, created: b.created }; const c = cs.find(x => x.number === b.number); if (c && c.name) o.name = c.name; return o; }); });
  LocalDB.register('blocks.add', d => { const n = num(d.number); if (!n) return { ok: false, error: 'invalid' }; if (n === LocalDB.me().number) return { ok: false, error: 'self' }; if (!T('blocks').all().some(b => mine(b) && b.number === n)) T('blocks').insert({ owner: LocalDB.cid, number: n, created: now() }); return { ok: true, number: n }; });
  LocalDB.register('blocks.remove', d => { const n = num(d.number); if (!n) return { ok: false, error: 'invalid' }; T('blocks').remove(b => mine(b) && b.number === n); return { ok: true, number: n }; });
})();
