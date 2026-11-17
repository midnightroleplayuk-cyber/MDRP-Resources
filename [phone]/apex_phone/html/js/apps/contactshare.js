/* ============================================================
   PARTILHA DE CONTACTOS (CSHARE, 5 out 2026): passar o cartão de contacto a quem está perto.
   window.ContactShare = { enabled, mode, setMode, label, share(card), shareMine(), shareMenu(card), sendByMessage(card),
                           openOffer(id), settingsList(repaint), inbox() }
   card = { kind: 'me' } (o meu, montado pelo servidor) ou { kind: 'contact', id, name, number, avatar, avatarPhoto } (um contacto
   MEU: o servidor lê-o pela linha id + owner, o nome e o número daqui são só a pré-visualização).
   Envio: folha com o cartão em cima e quem está perto (cshare.nearby de 2 em 2 s enquanto aberta, calculado no servidor:
   distância, routing bucket, vivo, com telemóvel e a aceitar cartões). Toque = cshare.send; outro toque enquanto espera = cancelar.
   Dois "o meu" cruzados trocam os dois cartões logo (o servidor responde { mutual }).
   Receção: cshare:offer → folha "X quer partilhar um contacto" com o cartão (Aceitar / Recusar); com o telemóvel guardado ou
   bloqueado fica uma notificação que a abre. "Pedir contacto" (ox_target) chega como kind 'ask': aceitar manda o MEU cartão.
   Definição: System.state.cshare = 'everyone' | 'contacts' | 'off' (sem escolha vale o Config.ContactShare.receive do servidor),
   mostrada na página do AirShare / Partilha rápida (settingsList). PearOS e Nova UI: as mesmas folhas, CSS por sistema.
   Regras do CEF: sem animações em ciclo (o "a enviar" é um anel parado), DOM feito uma vez e atualizado no sítio.
   ============================================================ */
window.ContactShare = (() => {
  const g = UI.g, esc = UI.esc;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
  const isA = () => !!(window.System && System.os === 'android');
  const MODES = ['off', 'contacts', 'everyone'], MODES_A = ['everyone', 'contacts', 'off'];
  const LABEL = { off: 'Desligado', contacts: 'Só contactos', everyone: 'Toda a gente' };   /* 'Todos' traduzia para "All"; aqui e "Everyone" */
  const LABEL_A = { off: 'Desligado', contacts: 'Só contactos', everyone: 'Toda a gente' };
  const SUB = { everyone: 'Qualquer pessoa por perto', contacts: 'Só quem já está nos teus contactos', off: 'Ninguém te pode enviar cartões' };
  /* erros do servidor, tal como o remetente os lê por baixo do avatar */
  const ERR = { notnear: 'Fora de alcance', off: 'Não aceita contactos', busy: 'Ocupado, tenta daqui a pouco', cooldown: 'Espera uns segundos', nosim: 'Sem SIM', nophone: 'Sem telemóvel', unavailable: 'Indisponível', ratelimit: 'Demasiados pedidos', disabled: 'Partilha desligada', notfound: 'Contacto indisponível', phoneout: 'Abre o telemóvel', gone: 'Saiu', invalid: 'Pedido inválido', noplayer: 'Sem sessão', timeout: 'Sem resposta do servidor' };
  const errText = e => T(ERR[e] || 'Não foi possível enviar');
  let cfg = null;   /* resposta do cshare.set: { enabled, default, ask, target, distance, seconds } */
  const enabled = () => !cfg || cfg.enabled !== false;
  const stored = () => MODES.includes(System.state.cshare) ? System.state.cshare : null;
  const mode = () => stored() || (cfg && MODES.includes(cfg.default) ? cfg.default : 'everyone');
  const label = m => T((isA() ? LABEL_A : LABEL)[m || mode()] || LABEL.everyone);
  const closed = () => Bridge.inFiveM && document.body.classList.contains('hidden');   /* telemóvel guardado */
  /* "PearPhone de Ana" → "Ana"; "NOVA S26 Ultra de Rui" → "Rui" (o mesmo corte do AirShare) */
  const DEV_RX = /^((?:pearphone|iphone|nova)\b[^]*?)\s+(?:de|da|do|of)\s+(.+)$/i;
  const person = n => { const s = String(n || '').trim(); const m = s.match(DEV_RX); return (m ? m[2] : s) || '?'; };
  const deviceOf = n => { const m = String(n || '').trim().match(DEV_RX); return m ? m[1] : ''; };
  const digits = n => String(n == null ? '' : n).replace(/\D/g, '');
  const fmtDist = () => { const d = cfg && +cfg.distance > 0 ? +cfg.distance : 3; return String(Math.round(d * 10) / 10).replace('.', ','); };

  /* ---------- Anunciar a escolha ao servidor (e ler a configuração) ---------- */
  let syncT = null;
  function sync() {
    clearTimeout(syncT);
    syncT = setTimeout(async () => { syncT = null; let r = null; try { r = await Bridge.rpcRaw('cshare.set', { mode: stored() || undefined }); } catch (e) { r = null; }
      if (r && typeof r === 'object' && !r.error && !Array.isArray(r)) cfg = r; }, 80);
  }
  function setMode(m) { if (!MODES.includes(m) || System.state.cshare === m) return; System.setState({ cshare: m }, { noApply: true }); }   /* o 'state' emitido chama o sync */

  /* ---------- Cartões ---------- */
  function myPreview() {
    const p = System.player || {}, acc = System.account || {};
    const name = ((p.firstname || '') + ' ' + (p.lastname || '')).trim() || acc.username || T('Eu');
    return { kind: 'me', name, number: p.phone || '', avatar: acc.avatar, url: acc.avatarPhoto || null };
  }
  /* cartão visual: avatar, nome, número e uma etiqueta. Os textos entram por textContent (nunca HTML do servidor) */
  function cardEl(c, tag) {
    const el = UI.el('<div class="csh-vc"><div class="csh-vc-av"></div><div class="csh-vc-t"><b></b><span></span><em></em></div></div>');
    const av = el.querySelector('.csh-vc-av');
    const url = c.url || c.photo || (typeof c.avatar === 'string' && /^https?:/.test(c.avatar) ? c.avatar : null);
    av.innerHTML = UI.avatar({ name: c.name || c.number || '?', avatar: typeof c.avatar === 'number' ? c.avatar : 0, url });
    if (c.kind === 'contact' && c.id && window.Contacts && Contacts.paintAvatar) Contacts.paintAvatar(av.firstElementChild, c);   /* a foto do contacto (da MINHA galeria) só aqui, na pré-visualização */
    el.querySelector('b').textContent = c.name || UI.phone(c.number || '');
    el.querySelector('span').textContent = c.number ? UI.phone(c.number) : T('Sem número');
    const em = el.querySelector('em'); em.textContent = tag || ''; em.hidden = !tag;
    return el;
  }

  /* ---------- Enviar por mensagem (o caminho antigo, para quem não está perto) ---------- */
  async function sendByMessage(c) {
    c = c || myPreview();
    if (!c.number) { UI.toast(T('Sem SIM: não tens um número para partilhar.'), 2400); return; }
    if (window.CC && CC.requireNet && !CC.requireNet('enviar o contacto')) return;
    const to = await Contacts.pick(T('Enviar contacto a')); if (!to) return;
    let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: to.number, type: 'contact', content: c.name, payload: { name: c.name, number: c.number } }); } catch (e) { r = null; }
    UI.toast(r && !r.error && r.id != null ? T('Contacto enviado') : T('Não foi possível enviar o contacto'));
  }
  /* escolha entre "quem está perto" e "por mensagem" (ficha de um contacto, o meu cartão) */
  async function shareMenu(c) {
    c = c || myPreview();
    if (!enabled()) return sendByMessage(c);
    const v = await UI.actionSheet({ title: c.kind === 'contact' ? c.name : (c.number ? c.name + ' · ' + UI.phone(c.number) : T('O meu cartão')), buttons: [{ label: T('Com quem está perto'), icon: 'airdrop', value: 'near' }, { label: T('Por mensagem'), icon: 'message', value: 'msg' }] });
    if (v === 'near') share(c); else if (v === 'msg') sendByMessage(c);
  }

  /* ---------- Folha de envio ---------- */
  let sh = null;                  /* folha aberta (só uma) */
  const outgoing = new Map();     /* id da oferta → { S, c } à espera do cshare:result */
  const setSt = (c, txt, cls) => { c.el.classList.remove('busy', 'sent', 'fail'); if (cls) c.el.classList.add(cls); c.el.querySelector('.csh-st').textContent = txt ? T(txt) : ''; };
  function share(card) {
    if (!enabled()) { UI.toast(T('A partilha de contactos está desligada')); return null; }
    card = card && card.kind === 'contact' ? card : myPreview();
    if (window.CC && CC.requireNet && !CC.requireNet('partilhar o contacto')) return null;
    if (sh) { try { sh.sheet.close(); } catch (e) {} }
    const mine = card.kind !== 'contact';
    const body = UI.el(`<div class="csh ${isA() ? 'csh-nova' : ''}"><div class="csh-head"></div>
      <div class="csh-sec"><div class="csh-lbl">${esc(T('Pessoas por perto'))}</div><div class="csh-people"></div><div class="csh-hint"></div></div>
      <div class="csh-foot"></div>
      <div class="csh-alt" role="button">${g('message')}<span>${esc(T('Enviar por mensagem'))}</span></div></div>`);
    body.querySelector('.csh-head').appendChild(cardEl(card, mine ? T('O meu cartão') : T('Contacto')));
    body.querySelector('.csh-foot').textContent = TF('Só aparece quem está a menos de %s m, com telemóvel e a aceitar cartões. Quem recebe decide se guarda.', fmtDist());
    const S = { card, mine, body, people: body.querySelector('.csh-people'), hint: body.querySelector('.csh-hint'), cards: new Map(), timer: null, closed: false };
    S.sheet = UI.sheet({ title: T(mine ? 'Partilhar o meu contacto' : 'Partilhar contacto'), right: T('Fechar'), body, cls: 'csh-wrap',
      onClose: () => { S.closed = true; clearInterval(S.timer); S.timer = null; if (sh === S) sh = null; } });   /* fechar não cancela o que já foi enviado: a resposta chega como aviso */
    sh = S;
    body.querySelector('.csh-alt').onclick = () => { S.sheet.close(); setTimeout(() => sendByMessage(card), 120); };
    if (mine && !card.number) { noSim(S); return S; }
    S.hint.textContent = T('A procurar pessoas por perto…');
    /* rpcRaw: um { error } (ratelimit, sem sessão) não esvazia a lista por uma volta: fica a anterior até à próxima */
    const poll = async () => { let list = null; try { list = await Bridge.rpcRaw('cshare.nearby', {}); } catch (e) { list = null; }
      if (sh !== S || !list) return;
      if (list.error) { if (list.error === 'disabled' || list.error === 'nophone' || list.error === 'phoneout') { S.hint.textContent = T(list.error === 'disabled' ? 'A partilha de contactos está desligada' : list.error === 'phoneout' ? 'Abre o telemóvel para partilhar' : 'Sem telemóvel'); } return; }
      paint(S, Array.isArray(list) ? list : Object.values(list || {})); };
    poll(); S.timer = setInterval(poll, 2000);
    return S;
  }
  const shareMine = () => share(myPreview());
  function noSim(S) {
    clearInterval(S.timer); S.timer = null;
    S.body.classList.add('csh-nosim'); S.body.classList.remove('csh-found');
    S.hint.textContent = T('Sem SIM: não tens um número para partilhar.');
  }
  function nameOf(c) { c.el.querySelector('.csh-pn').textContent = person(c.p.name); c.el.querySelector('.csh-pd').textContent = deviceOf(c.p.name) || T('Telemóvel'); }
  function paint(S, list) {
    const seen = new Set();
    list.forEach(p => {
      const src = +(p && p.src); if (!src) return; seen.add(src);
      let c = S.cards.get(src);
      if (!c) {
        c = { el: UI.el(`<div class="csh-p" role="button"><div class="csh-pav">${UI.avatar({ name: person(p.name), avatar: p.avatar })}<i class="csh-ring"></i></div><b class="csh-pn"></b><span class="csh-pd"></span><span class="csh-st"></span></div>`), st: 'idle', id: null, p };
        nameOf(c); c.el.onclick = () => tap(S, c); S.cards.set(src, c); S.people.appendChild(c.el);
      } else if (c.p.name !== p.name) { c.p = p; nameOf(c); }
    });
    /* quem se afastou sai da lista, a não ser que tenha um envio a decorrer ou um resultado para ler */
    S.cards.forEach((c, src) => { if (!seen.has(src) && c.st === 'idle') { c.el.remove(); S.cards.delete(src); } });
    S.body.classList.toggle('csh-found', S.cards.size > 0);
    S.hint.textContent = S.cards.size ? T('Toca numa pessoa para lhe dares o cartão') : T('A procurar pessoas por perto…');
  }
  async function tap(S, c) {
    if (c.st === 'sending') return;
    if (c.st === 'waiting') {   /* segundo toque = desistir */
      const id = c.id; c.st = 'idle'; c.id = null; setSt(c, 'Cancelado', '');
      if (id) { outgoing.delete(id); try { await Bridge.rpcRaw('cshare.cancel', { id }); } catch (e) {} }
      return;
    }
    Sound.play('click');
    c.st = 'sending'; c.id = null; setSt(c, 'A enviar…', 'busy');
    const d = { to: c.p.src, kind: S.mine ? 'me' : 'contact' }; if (!S.mine) d.contactId = S.card.id;
    let r = null; try { r = await Bridge.rpcRaw('cshare.send', d); } catch (e) { r = null; }
    if (r && r.mutual) { c.st = 'sent'; setSt(c, 'Trocados', 'sent'); Sound.play('success'); return; }   /* o cshare:exchanged trata dos Contactos e do aviso */
    if (!r || r.error || !r.id) { const e = r && r.error; c.st = 'fail'; setSt(c, null, 'fail'); c.el.querySelector('.csh-st').textContent = errText(e || 'timeout'); if (e === 'nosim') noSim(S); return; }
    c.id = +r.id; c.st = 'waiting'; setSt(c, 'À espera…', 'busy'); outgoing.set(c.id, { S, c });
  }
  function onResult(d) {
    d = d || {}; const o = outgoing.get(+d.id); if (!o) return; outgoing.delete(+d.id);
    const c = o.c; if (c.st !== 'waiting') return; c.id = null;
    if (d.accepted) { c.st = 'sent'; setSt(c, d.mutual ? 'Trocados' : 'Guardado', 'sent'); Sound.play('success'); }
    else if (d.expired) { c.st = 'fail'; setSt(c, 'Sem resposta', 'fail'); }
    else if (d.error) { c.st = 'fail'; setSt(c, null, 'fail'); c.el.querySelector('.csh-st').textContent = errText(d.error); }
    else { c.st = 'fail'; setSt(c, 'Recusado', 'fail'); }
    /* a folha já foi fechada: o resultado diz-se num aviso curto (com o telemóvel guardado, o servidor avisa pelo jogo) */
    if (o.S.closed && !closed() && !System.locked) {
      const who = person(c.p.name);
      UI.toast(d.accepted ? (d.mutual ? TF('Contactos trocados com %s', who) : TF('%s guardou o contacto', who)) : d.expired ? TF('%s não respondeu', who) : TF('%s não aceitou o contacto', who), 2400);
    }
  }

  /* ---------- Receber ---------- */
  const inbox = new Map();   /* id → { id, kind, from, avatar, card, seconds, notified, nid } */
  let recv = null;           /* folha de receção aberta { id, sheet, answered } */
  function cleanCard(c) {
    c = c && typeof c === 'object' ? c : {};
    const photo = typeof c.photo === 'string' && /^data:image\//.test(c.photo) && c.photo.length <= 120000 ? c.photo : null;
    const av = typeof c.avatar === 'number' ? c.avatar : (typeof c.avatar === 'string' && /^https?:\/\//.test(c.avatar) ? c.avatar.slice(0, 255) : null);
    return { name: String(c.name == null ? '' : c.name).slice(0, 64), number: c.number == null ? '' : String(c.number).slice(0, 20), avatar: av, photo };
  }
  function onOffer(d) {
    d = d || {}; const id = +d.id; if (!id || inbox.has(id)) return;
    inbox.set(id, { id, kind: d.kind === 'ask' ? 'ask' : d.kind === 'contact' ? 'contact' : 'me', from: String(d.from || T('Alguém')).slice(0, 40), avatar: d.avatar, card: cleanCard(d.card), seconds: +d.seconds || 0, notified: false, nid: null });
    if (!closed() && !System.locked && !recv) { Sound.play('airdrop'); openOffer(id); } else notify(id);
  }
  function notify(id) {
    const o = inbox.get(id); if (!o || o.notified || !window.Notify) return; o.notified = true;
    const who = person(o.from);
    const n = Notify.push({ app: 'contacts', title: T('Contactos'), msg: o.kind === 'ask' ? TF('%s pede o teu contacto', who) : TF('%s quer partilhar um contacto', who), sound: 'airdrop', onTap: () => openOffer(id) });
    if (n && n.id != null) o.nid = n.id;
  }
  function forgetNotif(o) { if (o && o.nid != null && window.Notify && Notify.remove) { try { Notify.remove(o.nid); } catch (e) {} o.nid = null; } }
  /* o número já está nos meus contactos? (mesmos dígitos) */
  const known = n => { const d = digits(n); return d ? (Contacts.cache || []).find(c => digits(c.number) === d) || null : null; };
  function openOffer(id) {
    const o = inbox.get(id); if (!o) { UI.toast(T('Este pedido já não está disponível')); return null; }
    if (closed() || System.locked) { notify(id); return null; }   /* abre quando o telemóvel abrir / desbloquear (resume) */
    if (recv) { if (recv.id === id) return recv; recv.sheet.close(); }
    const ask = o.kind === 'ask', who = person(o.from);
    const body = UI.el(`<div class="csh-rc ${isA() ? 'csh-nova' : ''}"><div class="csh-rc-from"><div class="csh-rc-dav"></div><div class="csh-rc-t"></div></div>
      <div class="csh-rc-card"></div><div class="csh-rc-note"></div>
      <div class="csh-btns"><div class="csh-btn no" role="button">${esc(T('Recusar'))}</div><div class="csh-btn yes" role="button">${esc(T(ask ? 'Partilhar' : 'Aceitar'))}</div></div></div>`);
    body.querySelector('.csh-rc-dav').innerHTML = UI.avatar({ name: who, avatar: o.avatar }, 'sm');
    body.querySelector('.csh-rc-t').innerHTML = TF(ask ? '%s pede o teu contacto' : '%s quer partilhar um contacto', `<b>${esc(who)}</b>`);
    const ex = ask ? null : known(o.card.number);
    body.querySelector('.csh-rc-card').appendChild(cardEl(Object.assign({ kind: 'in', url: o.card.photo }, o.card), ask ? T('Quem pede') : ex ? TF('Já tens como %s', ex.name) : (o.kind === 'me' ? T('Cartão de quem envia') : T('Contacto partilhado'))));
    const secs = o.seconds ? TF('O pedido expira dentro de %s segundos.', o.seconds) : '';
    body.querySelector('.csh-rc-note').textContent = (ask ? T('Se aceitares, o teu nome e o teu número vão para os contactos desta pessoa.') : ex ? T('Se aceitares, junta-se ao contacto que já tens.') : T('Se aceitares, fica nos teus Contactos.')) + (secs ? ' ' + secs : '');
    const R = { id, answered: false };
    R.sheet = UI.sheet({ title: T('Contacto'), right: T('Fechar'), body, cls: 'csh-wrap csh-recv', onClose: () => { if (recv === R) recv = null; if (!R.answered && inbox.has(id)) { const x = inbox.get(id); x.notified = false; notify(id); } } });   /* fechar sem responder deixa o pedido pendente (reabre pela notificação) */
    recv = R;
    const answer = async accept => {
      if (R.answered) return; R.answered = true; Sound.play('click'); inbox.delete(id); forgetNotif(o); R.sheet.close();
      let r = null; try { r = await Bridge.rpcRaw('cshare.answer', { id, accept: !!accept }); } catch (e) { r = null; }
      if (!accept) return;
      const e = r && r.error;
      if (r && r.ok) {
        Sound.play('airdrop');
        if (ask) { UI.toast(TF('Partilhaste o teu contacto com %s', who), 2400); return; }
        try { await Contacts.load(); } catch (x) {}
        const nm = r.name || o.card.name;
        UI.toast(r.merged ? TF('%s atualizado nos Contactos', nm) : TF('%s guardado nos Contactos', nm), 2400);
        Bridge.emit('cshare:saved', r);
        return;
      }
      UI.toast(e === 'notnear' ? TF('%s já não está por perto', who) : e === 'gone' ? TF('%s saiu', who) : e === 'nosim' ? T('Sem SIM: não tens um número para partilhar.') : e === 'full' ? T('A lista de contactos está cheia') : e === 'ratelimit' ? T('Demasiados pedidos') : e === 'notfound' ? T('Este pedido já não está disponível') : T('Não foi possível guardar o contacto'), 2400);
    };
    body.querySelector('.csh-btn.yes').onclick = () => answer(true); body.querySelector('.csh-btn.no').onclick = () => answer(false);
    return R;
  }
  function onGone(d) {
    d = d || {}; const id = +d.id; const o = inbox.get(id); if (!o) return; inbox.delete(id); forgetNotif(o);
    if (recv && recv.id === id && !recv.answered) {
      recv.answered = true; recv.sheet.close();
      if (!d.mutual) UI.toast(d.expired ? TF('O pedido de %s expirou', person(o.from)) : TF('%s cancelou a partilha', person(o.from)));
    }
  }
  /* avisos sem folha: toast com o telemóvel à vista, notificação com ele guardado */
  function tell(msg) {
    if (closed() || System.locked) { if (window.Notify) Notify.push({ app: 'contacts', title: T('Contactos'), msg }); }
    else UI.toast(msg, 2400);
  }
  /* a cache dos Contactos recarrega e quem mostra a lista (PearOS) ouve o 'cshare:saved' */
  const reloadContacts = d => Promise.resolve().then(() => Contacts.load()).catch(() => {}).then(() => Bridge.emit('cshare:saved', d || {}));
  function onExchanged(d) { d = d || {}; reloadContacts(d); Sound.play('success'); tell(TF('Contactos trocados com %s', String(d.name || '').slice(0, 64))); }
  function onReceived(d) { d = d || {}; reloadContacts(d); Sound.play('airdrop'); tell(TF(d.merged ? 'Contacto atualizado: %s' : 'Novo contacto: %s', String(d.name || '').slice(0, 64))); }
  function resume() { if (closed() || System.locked || recv || !inbox.size) return; openOffer(inbox.keys().next().value); }
  function reset() { inbox.clear(); outgoing.clear(); if (recv) { try { recv.answered = true; recv.sheet.close(); } catch (e) {} recv = null; } if (sh) { try { sh.sheet.close(); } catch (e) {} sh = null; } }

  /* ---------- Definições (página do AirShare / Partilha rápida): quem me pode enviar cartões ---------- */
  function settingsList(repaint) {
    const nova = isA(), order = nova ? MODES_A : MODES, LB = nova ? LABEL_A : LABEL;
    const pick = m => { Sound.play('click'); setMode(m); if (typeof repaint === 'function') repaint(); };
    return UI.list([{ header: T('Cartões de contacto'),
      items: order.map(m => Object.assign({ label: T(LB[m]), chevron: false, onTap: () => pick(m) }, nova ? Object.assign({ sub: T(SUB[m]) }, UI.radio ? { right: UI.radio(m === mode()) } : { value: m === mode() ? '✓' : '' }) : { value: m === mode() ? '✓' : '' })),
      footer: T('Quem te pode enviar o cartão de contacto quando está perto de ti. Partilhar o teu funciona sempre; números bloqueados nunca chegam.') }]);
  }

  function init() {
    Bridge.on('cshare:offer', onOffer); Bridge.on('cshare:result', onResult); Bridge.on('cshare:gone', onGone);
    Bridge.on('cshare:exchanged', onExchanged); Bridge.on('cshare:received', onReceived);
    Bridge.on('state', p => { if (p && typeof p === 'object' && 'cshare' in p) sync(); });
    Bridge.on('ready', sync);
    Bridge.on('session:changed', () => { reset(); cfg = null; sync(); }); Bridge.on('factory:reset', reset);
    Bridge.on('phone:open', () => setTimeout(resume, 450)); Bridge.on('unlock', () => setTimeout(resume, 300));
    sync();
  }
  init();
  return { enabled, mode, setMode, label, share, shareMine, shareMenu, sendByMessage, openOffer, settingsList, MODES, inbox: () => [...inbox.keys()], get sharing() { return sh; }, get receiving() { return recv; }, get config() { return cfg; } };
})();

/* ---------- Mocks do browser (o localdb.js não é carregado no jogo) ----------
   LocalDB.cshare = { nearby: [{ src, name, avatar }], mode, out: [], offer(o), expire(id), answer(id, accept, mutual) }
   Espelha o server/contactshare.lua: o send devolve { ok, id } e o "outro lado" responde com answer()/expire(); offer()
   simula alguém a partilhar comigo. Aceitar guarda (ou junta pelo número) na tabela contacts do LocalDB. */
if (window.LocalDB && LocalDB.register) (() => {
  const CS = { nearby: [{ src: 7, name: 'PearPhone de Rita', avatar: 4 }, { src: 9, name: 'NOVA S26 Ultra de Tiago', avatar: 6 }], mode: null, out: [], inbox: [], seq: 100 };
  const T = LocalDB.T, digits = n => String(n == null ? '' : n).replace(/\D/g, '');
  LocalDB.register('cshare.set', d => { CS.mode = ['off', 'contacts', 'everyone'].includes(d.mode) ? d.mode : null; return { ok: true, mode: CS.mode || 'everyone', default: 'everyone', enabled: true, ask: true, target: true, distance: 3, seconds: 30 }; });
  LocalDB.register('cshare.nearby', () => Array.isArray(CS.nearby) ? CS.nearby.map(p => Object.assign({}, p)) : CS.nearby);
  LocalDB.register('cshare.send', d => {
    const p = (CS.nearby || []).find(x => x.src === +d.to); if (!p) return { error: 'notnear' };
    if (CS.out.some(o => o.to === p.src)) return { error: 'busy' };
    const mine = d.kind !== 'contact', me = LocalDB.me ? LocalDB.me() : {};
    if (mine && !(me && me.number)) return { error: 'nosim' };
    /* troca cruzada: tenho um "o meu" desta pessoa por responder */
    const p2 = mine && CS.inbox.find(o => o.fromSrc === p.src && o.kind === 'me');
    if (p2) { CS.inbox = CS.inbox.filter(o => o !== p2); const c = T('contacts').insert({ owner: LocalDB.cid, name: p2.card.name, number: p2.card.number, avatar: p2.card.avatar, favorite: false });
      setTimeout(() => { Bridge.emit('cshare:gone', { id: p2.id, mutual: true }); Bridge.emit('cshare:exchanged', { name: c.name, number: c.number }); }, 0); return { ok: true, mutual: true, name: c.name, number: c.number }; }
    const id = ++CS.seq; CS.out.push({ id, to: p.src, kind: mine ? 'me' : 'contact' }); return { ok: true, id };
  });
  LocalDB.register('cshare.cancel', d => { const o = CS.out.find(x => x.id === +d.id); if (!o) return { error: 'notfound' }; CS.out = CS.out.filter(x => x !== o); return { ok: true }; });
  LocalDB.register('cshare.answer', d => {
    const o = CS.inbox.find(x => x.id === +d.id); if (!o) return { error: 'notfound' }; CS.inbox = CS.inbox.filter(x => x !== o);
    if (!d.accept) return { ok: true };
    if (o.kind === 'ask') return { ok: true, kind: 'ask' };
    const rows = T('contacts').all(); const hit = rows.find(c => digits(c.number) === digits(o.card.number));
    if (hit) { if (!hit.name || digits(hit.name) === digits(hit.number)) hit.name = o.card.name; T('contacts').set(rows); return { ok: true, id: hit.id, name: hit.name, number: hit.number, merged: true }; }
    const c = T('contacts').insert({ owner: LocalDB.cid, name: o.card.name, number: o.card.number, avatar: typeof o.card.avatar === 'number' ? o.card.avatar : null, favorite: false });
    return { ok: true, id: c.id, name: c.name, number: c.number, merged: false };
  });
  Object.assign(CS, {
    offer(o) { o = o || {}; const id = ++CS.seq; const row = { id, fromSrc: o.fromSrc || 7, kind: o.kind || 'me', from: o.from || 'PearPhone de Rita', avatar: o.avatar || 4, card: o.card || { name: 'Rita Moreira', number: '555-0177', avatar: 4 } };
      CS.inbox.push(row); setTimeout(() => Bridge.emit('cshare:offer', { id, kind: row.kind, from: row.from, avatar: row.avatar, card: row.card, seconds: 30 }), 0); return id; },
    answer(id, accept, mutual) { const o = CS.out.find(x => x.id === +id); if (!o) return false; CS.out = CS.out.filter(x => x !== o); setTimeout(() => Bridge.emit('cshare:result', { id: o.id, kind: o.kind, accepted: !!accept, mutual: !!mutual }), 0); return true; },
    expire(id) { const o = CS.out.find(x => x.id === +id); if (o) { CS.out = CS.out.filter(x => x !== o); setTimeout(() => Bridge.emit('cshare:result', { id: o.id, accepted: false, expired: true }), 0); return true; }
      const i = CS.inbox.find(x => x.id === +id); if (i) { CS.inbox = CS.inbox.filter(x => x !== i); setTimeout(() => Bridge.emit('cshare:gone', { id: i.id, expired: true }), 0); return true; } return false; },
  });
  LocalDB.cshare = CS;
})();
