/* ============================================================
   AIRDROP - enviar fotos a quem está perto (pacote AD, docs/ARQUITETURA.md §10.1).
   window.AirDrop = { init, share(photo), setMode(m), mode(), toggle(), label(m?), page(win, { onBack? }), openOffer(id), inbox() }
   Estado: System.state.airdrop = 'off' | 'contacts' | 'everyone' - gravado na conta como qualquer definição
   (System.setState); o servidor só guarda o da SESSÃO, por isso airdrop.set corre no ready, na troca de
   personagem e sempre que a definição (ou o nome do dispositivo) muda.
   Envio: folha com radar + quem está perto (airdrop.nearby de 2 em 2 s enquanto aberta); toque = airdrop.send
   com a miniatura (Photos.thumb, ≤ 12 000 caracteres) → "A enviar…" até chegar airdrop:result.
   Receção: airdrop:offer → folha "X quer partilhar uma foto" (Aceitar / Recusar); com o telemóvel fechado ou
   bloqueado fica uma notificação (o toque abre a folha; abrir o telemóvel também) e o System.peek do Notify.
   Android (Nova UI): chama-se "Partilha rápida"; share(photo, { apps }) mostra a folha da Nova UI com os
   dispositivos por perto, a visibilidade e as apps de quem chama; a receção é um pop-up da Nova UI. O RPC,
   a proximidade e o estado são os mesmos: um PearPhone e um NOVA partilham entre si.
   ============================================================ */
window.AirDrop = (() => {
  const g = UI.g;
  const MODES = ['off', 'contacts', 'everyone'];
  const LABEL = { off: 'Desligado', contacts: 'Só contactos', everyone: 'Toda a gente' };   /* 'Todos' traduzia para "All"; aqui e "Everyone" */
  /* textos dos erros do servidor, tal como o remetente os lê por baixo do avatar */
  const ERR = { notnear: 'Fora de alcance', off: 'Não aceita AirShare', busy: 'Já tem um pedido teu', cooldown: 'Espera uns segundos', notfound: 'Foto indisponível', gone: 'Saiu', ratelimit: 'Demasiados pedidos', timeout: 'Sem resposta do servidor', noplayer: 'Sem sessão', invalid: 'Pedido inválido' };
  /* ANDROID (Nova UI): a mesma partilha, o mesmo RPC e a mesma proximidade no servidor (um iPhone e um
     Android partilham entre si). Muda o nome ("Partilha rápida"), os textos dos modos e as folhas. */
  const isA = () => !!(window.System && System.os === 'android');
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
  const LABEL_A = { off: 'Desligado', contacts: 'Só contactos', everyone: 'Toda a gente' };
  const ERR_A = { off: 'Não aceita partilhas', busy: 'Já tem um pedido teu' };
  const qsName = () => { const n = App.name('airdrop'); return n && n !== 'airdrop' ? n : T('Partilha rápida'); };
  const title = () => isA() ? qsName() : 'AirShare';
  const errText = e => isA() ? T(ERR_A[e] || ERR[e] || 'Não foi possível enviar') : (ERR[e] || 'Não foi possível enviar');
  const mode = () => MODES.includes(System.state.airdrop) ? System.state.airdrop : 'off';
  const label = m => isA() ? T(LABEL_A[m || mode()] || LABEL_A.off) : (LABEL[m || mode()] || LABEL.off);
  const closed = () => Bridge.inFiveM && document.body.classList.contains('hidden');   /* telemóvel guardado */
  const myName = () => { try { return System.deviceName(); } catch (e) { return 'PearPhone'; } };
  const myAvatar = () => (System.account && System.account.avatar) || 1;
  /* iniciais do avatar: "PearPhone de Ana" → "Ana" (senão todos os avatares diziam "ID"); o mesmo para os
     aparelhos NOVA ("NOVA S26 Ultra de Rui" → "Rui"), que agora também aparecem por perto */
  const DEV_RX = /^((?:pearphone|iphone|nova)\b[^]*?)\s+(?:de|da|do|of)\s+(.+)$/i;
  const person = n => { const s = String(n || '').trim(); const m = s.match(DEV_RX); return (m ? m[2] : s) || '?'; };
  const deviceOf = n => { const m = String(n || '').trim().match(DEV_RX); return m ? m[1] : ''; };

  /* ---------- Anunciar o modo ao servidor ----------
     Agrupado em 60 ms: o init, o 'ready' e o 'state' do arranque chegam todos seguidos e bastava um pedido. */
  let syncT = null;
  function sync() { clearTimeout(syncT); syncT = setTimeout(async () => { syncT = null; try { await Bridge.rpc('airdrop.set', { mode: mode() }); } catch (e) {} }, 60); }
  function setMode(m) { if (!MODES.includes(m)) m = 'off'; if (System.state.airdrop === m) return; System.setState({ airdrop: m }, { noApply: true }); }   /* o 'state' emitido chama o sync */
  function toggle() { setMode(mode() === 'off' ? 'everyone' : 'off'); UI.toast(title() + ': ' + label()); }

  /* ---------- Enviar ---------- */
  let sh = null;                  /* folha de partilha aberta (só uma) */
  const outgoing = new Map();     /* id da oferta → { S, c } à espera do airdrop:result */
  const setSt = (c, txt, cls) => { c.el.classList.remove('busy', 'sent', 'fail'); if (cls) c.el.classList.add(cls); c.el.querySelector('.ad-st').textContent = isA() ? T(txt) : txt; };

  async function share(photo, o) {
    if (!photo) return;
    if (isA()) return shareNova(photo, o || {});
    if (sh) { try { sh.sheet.close(); } catch (e) {} }
    if (window.CC && CC.requireNet && !CC.requireNet('o AirShare')) return;
    const body = UI.el(`<div class="ad-share"><div class="ad-top"><div class="ad-photo"></div><div class="ad-topt"><b>1 foto</b><span>Toca em alguém para partilhar</span></div></div><div class="ad-radar"><i></i><i></i><i></i><div class="ad-center">${UI.avatar({ name: person(myName()), avatar: myAvatar(), url: (System.account && System.account.avatarPhoto) || null }, 'sm')}</div></div><div class="ad-hint">A procurar pessoas por perto…</div><div class="ad-people"></div></div>`);
    /* a foto por CSSOM, nunca dentro da string de HTML (base64 de 200 KB pelo parser) */
    const ph = body.querySelector('.ad-photo'); ph.style.backgroundImage = Photos.bg(photo);
    Photos.data(photo, true).then(u => { if (u && ph.isConnected) ph.style.backgroundImage = Photos.bg(photo); });
    const S = { photo, body, people: body.querySelector('.ad-people'), hint: body.querySelector('.ad-hint'), cards: new Map(), timer: null, thumb: undefined };
    S.sheet = UI.sheet({ title: 'AirShare', right: 'Cancelar', body, cls: 'ad-sheet', onClose: () => { clearInterval(S.timer); S.timer = null; if (sh === S) sh = null; cancelPending(S); } });
    sh = S;
    /* a miniatura faz-se já, enquanto o radar procura: ao tocar em alguém está normalmente pronta */
    S.thumbP = Photos.thumb(photo).then(t => { S.thumb = t || null; return S.thumb; }).catch(() => { S.thumb = null; return null; });
    /* rpcRaw: um { error } (ratelimit, sem sessão) não pode esvaziar o radar por um ciclo - fica a lista anterior até à próxima volta */
    const poll = async () => { let list = null; try { list = await Bridge.rpcRaw('airdrop.nearby', {}); } catch (e) { list = null; } if (sh !== S || !list || list.error) return; paint(S, Array.isArray(list) ? list : Object.values(list || {})); };
    poll(); S.timer = setInterval(poll, 2000);
    return S;
  }
  function paint(S, list) {
    const seen = new Set();
    list.forEach(p => {
      const src = +(p && p.src); if (!src) return; seen.add(src);
      let c = S.cards.get(src);
      if (!c) {
        c = S.nova ? novaCard(S, p) : { el: UI.el(`<div class="ad-person"><div class="ad-av">${UI.avatar({ name: person(p.name), avatar: p.avatar })}</div><div class="ad-name"></div><div class="ad-st"></div></div>`), st: 'idle', id: null, p };
        if (!S.nova) c.el.querySelector('.ad-name').textContent = p.name || 'PearPhone';
        c.el.onclick = () => tap(S, c); S.cards.set(src, c); S.people.appendChild(c.el);
      } else if (c.p.name !== p.name) { c.p = p; if (S.nova) novaName(c); else c.el.querySelector('.ad-name').textContent = p.name || 'PearPhone'; }
    });
    /* quem se afastou sai do radar - a não ser que tenha um envio a decorrer ou um resultado para ler */
    S.cards.forEach((c, src) => { if (!seen.has(src) && c.st === 'idle') { c.el.remove(); S.cards.delete(src); } });
    if (S.nova) { S.hint.textContent = S.cards.size ? T('Toca num dispositivo para partilhar') : T('A procurar dispositivos por perto…'); S.body.classList.toggle('aqs-found', S.cards.size > 0); return; }
    S.hint.textContent = S.cards.size ? 'Pessoas por perto' : 'A procurar pessoas por perto…';
    S.body.classList.toggle('ad-found', S.cards.size > 0);
  }
  async function tap(S, c) {
    if (c.st === 'sending') {   /* segundo toque = desistir */
      const id = c.id; c.st = 'idle'; c.id = null; setSt(c, 'Cancelado', ''); if (id) { outgoing.delete(id); try { Bridge.rpcRaw('airdrop.cancel', { id }); } catch (e) {} }
      return;
    }
    Sound.play('click');
    c.st = 'sending'; c.id = null; setSt(c, 'A enviar…', 'busy');
    const thumb = await S.thumbP;
    if (sh !== S || c.st !== 'sending') return;
    let r = null; try { r = await Bridge.rpcRaw('airdrop.send', { to: c.p.src, photoId: S.photo.id, thumb: thumb || undefined }); } catch (e) { r = null; }
    if (c.st !== 'sending') { if (r && r.ok && r.id) { try { Bridge.rpcRaw('airdrop.cancel', { id: r.id }); } catch (e) {} } return; }   /* desistiu antes da resposta */
    if (!r || r.error || !r.id) { c.st = 'fail'; setSt(c, errText(r && r.error), 'fail'); return; }
    c.id = +r.id; outgoing.set(c.id, { S, c });
  }
  function cancelPending(S) {
    S.cards.forEach(c => { if (c.st === 'sending' && c.id) { outgoing.delete(c.id); try { Bridge.rpcRaw('airdrop.cancel', { id: c.id }); } catch (e) {} } c.st = 'idle'; c.id = null; });
  }
  function onResult(d) {
    d = d || {}; const o = outgoing.get(+d.id); if (!o) return; outgoing.delete(+d.id);
    const c = o.c; if (c.st !== 'sending') return; c.id = null;
    if (d.accepted) { c.st = 'sent'; setSt(c, 'Enviado', 'sent'); Sound.play('success'); }
    else if (d.expired) { c.st = 'fail'; setSt(c, 'Sem resposta', 'fail'); }
    else if (d.error) { c.st = 'fail'; setSt(c, errText(d.error), 'fail'); }
    else { c.st = 'fail'; setSt(c, 'Recusado', 'fail'); }
  }

  /* ---------- Receber ---------- */
  const inbox = new Map();   /* id → { id, from, avatar, thumb, seed, notified, nid } */
  let recv = null;           /* folha de receção aberta { id, sheet, answered } */
  function onOffer(d) {
    d = d || {}; const id = +d.id; if (!id || inbox.has(id)) return;
    inbox.set(id, { id, from: String(d.from || 'Alguém').slice(0, 40), avatar: d.avatar, thumb: typeof d.thumb === 'string' && /^data:image\//.test(d.thumb) && d.thumb.length <= 12000 ? d.thumb : null, seed: +d.seed || 0, seconds: +d.seconds || 0, notified: false, nid: null });
    if (!closed() && !System.locked && !recv) { Sound.play('airdrop'); openOffer(id); } else notify(id);
  }
  /* a notificação faz o resto com o telemóvel fechado: ecrã bloqueado, banner e System.peek (notify.js) */
  function notify(id) {
    const o = inbox.get(id); if (!o || o.notified || !window.Notify) return; o.notified = true;
    const n = isA()
      ? Notify.push({ app: 'photos', title: qsName(), msg: TF('%s quer partilhar uma imagem', person(o.from)), image: o.thumb || undefined, sound: 'airdrop', onTap: () => openOffer(id) })
      : Notify.push({ app: 'photos', title: 'AirShare', msg: o.from + ' quer partilhar uma foto', image: o.thumb || undefined, sound: 'airdrop', onTap: () => openOffer(id) });
    if (n && n.id != null) o.nid = n.id;
  }
  function forgetNotif(o) { if (o && o.nid != null && window.Notify && Notify.remove) { try { Notify.remove(o.nid); } catch (e) {} o.nid = null; } }
  function openOffer(id) {
    const nova = isA();
    const o = inbox.get(id); if (!o) { UI.toast(nova ? T('Este pedido já não está disponível') : 'Este pedido já não está disponível'); return null; }
    if (closed()) { notify(id); return null; }                      /* abre quando o telemóvel abrir (resume) */
    if (System.locked) { notify(id); return null; }                 /* … ou quando desbloquear */
    if (recv) { if (recv.id === id) return recv; recv.sheet.close(); }
    let body;
    if (nova) body = offerBodyNova(o);
    else {
      body = UI.el(`<div class="ad-recv"><div class="ad-from">${UI.avatar({ name: person(o.from), avatar: o.avatar }, 'sm')}<div class="ad-who"><b></b><span>quer partilhar uma foto</span></div></div><div class="ad-big"></div><div class="ad-note">A foto fica na tua galeria se aceitares.</div><div class="ad-btns"><div class="btn-p gray ad-no">Recusar</div><div class="btn-p ad-yes">Aceitar</div></div></div>`);
      body.querySelector('.ad-who b').textContent = o.from;
      const big = body.querySelector('.ad-big'); big.style.backgroundImage = o.thumb ? UI.img(o.thumb) : photoBg(o.seed || 1);
    }
    const R = { id, answered: false };
    R.sheet = UI.sheet({ title: nova ? qsName() : 'AirShare', right: nova ? T('Fechar') : 'Fechar', body, cls: nova ? 'aqs-wrap aqs-recv' : 'ad-sheet', onClose: () => { if (recv === R) recv = null; if (!R.answered && inbox.has(id)) notify(id); } });   /* fechar sem responder deixa o pedido pendente (reabre pela notificação) */
    recv = R;
    const answer = async accept => {
      if (R.answered) return; R.answered = true; Sound.play('click'); inbox.delete(id); forgetNotif(o); R.sheet.close();
      let r = null; try { r = await Bridge.rpcRaw('airdrop.answer', { id, accept: !!accept }); } catch (e) { r = null; }
      if (!accept) return;
      const e = r && r.error, who = nova ? person(o.from) : o.from;
      if (nova) {
        if (r && r.ok) { Sound.play('airdrop'); UI.toast(TF('Imagem recebida de %s. Já está na Galeria.', who), 2600); refreshPhotos(); return; }
        UI.toast(e === 'notnear' ? TF('%s já não está por perto', who) : e === 'notfound' ? T('A imagem já não está disponível') : e === 'gone' ? TF('%s saiu', who) : e === 'ratelimit' ? T('Demasiados pedidos') : T('Não foi possível receber a imagem'));
        return;
      }
      if (r && r.ok) { Sound.play('airdrop'); UI.toast('Foto recebida de ' + o.from); refreshPhotos(); return; }
      UI.toast(e === 'notnear' ? o.from + ' já não está por perto' : e === 'notfound' ? 'A foto já não está disponível' : e === 'gone' ? o.from + ' saiu' : e === 'ratelimit' ? 'Demasiados pedidos' : 'Não foi possível receber a foto');
    };
    body.querySelector('.ad-yes, .aqs-btn.yes').onclick = () => answer(true); body.querySelector('.ad-no, .aqs-btn.no').onclick = () => answer(false);
    return R;
  }
  function onGone(d) {
    d = d || {}; const id = +d.id; const o = inbox.get(id); if (!o) return; inbox.delete(id); forgetNotif(o);
    if (recv && recv.id === id && !recv.answered) {
      recv.answered = true; recv.sheet.close();
      if (isA()) UI.toast(d.expired ? TF('O pedido de %s expirou', person(o.from)) : TF('%s cancelou a partilha', person(o.from)));
      else UI.toast(d.expired ? 'O pedido de ' + o.from + ' expirou' : o.from + ' cancelou a partilha');
    }
  }

  /* ================= ANDROID: as folhas da Partilha rápida =================
     Enviar: cabeçalho com a miniatura, "Partilha rápida" com os dispositivos por perto em círculos (o
     anel à volta mostra o envio), a visibilidade (Toda a gente / Só contactos / Desligado = state.airdrop)
     e, por baixo, "Partilhar com" as apps que quem chama passar (Mensagens, Mail...).
     Receber: pop-up em baixo com quem envia, a pré-visualização e Recusar / Aceitar. */
  const QS_IC = '<svg class="aqs-gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><circle cx="12" cy="12" r="2"/><path d="M8 16a5.6 5.6 0 0 1 0-8M16 8a5.6 5.6 0 0 1 0 8M5.2 18.8a9.6 9.6 0 0 1 0-13.6M18.8 5.2a9.6 9.6 0 0 1 0 13.6"/></svg>';
  const VIS = ['everyone', 'contacts', 'off'];
  function visSeg() {
    const el = UI.el(`<div class="aqs-seg">${VIS.map(m => `<div data-m="${m}" class="${m === mode() ? 'on' : ''}" role="button">${UI.esc(T(LABEL_A[m]))}</div>`).join('')}</div>`);
    el.onclick = e => { const b = e.target.closest('[data-m]'); if (!b || b.classList.contains('on')) return; Sound.play('click'); setMode(b.dataset.m); el.querySelectorAll('[data-m]').forEach(x => x.classList.toggle('on', x === b)); };
    return el;
  }
  function novaName(c) { c.el.querySelector('.aqs-pn').textContent = person(c.p.name); c.el.querySelector('.aqs-pd').textContent = deviceOf(c.p.name) || T('Telemóvel'); }
  function novaCard(S, p) {
    const c = { el: UI.el(`<div class="aqs-p" role="button"><div class="aqs-av">${UI.avatar({ name: person(p.name), avatar: p.avatar })}<svg class="aqs-ring" viewBox="0 0 72 72"><circle cx="36" cy="36" r="34"/></svg></div><b class="aqs-pn"></b><span class="aqs-pd"></span><span class="ad-st"></span></div>`), st: 'idle', id: null, p };
    novaName(c);
    return c;
  }
  function shareNova(photo, o) {
    if (sh) { try { sh.sheet.close(); } catch (e) {} }
    const apps = Array.isArray(o.apps) ? o.apps.filter(a => a && a.id && typeof a.onTap === 'function') : [];
    const body = UI.el(`<div class="aqs">
      <div class="aqs-head"><div class="aqs-th"></div><div class="aqs-ht"><b>${UI.esc(T(photo.video ? '1 vídeo' : '1 imagem'))}</b><span>${UI.esc(T('Escolhe com quem partilhar'))}</span></div></div>
      <div class="aqs-sec"><div class="aqs-st"><span class="aqs-ic">${QS_IC}</span><b>${UI.esc(qsName())}</b></div><div class="aqs-lbl">${UI.esc(T('Partilhar com'))}</div><div class="aqs-people"></div><div class="aqs-hint"></div></div>
      <div class="aqs-vis"><span>${UI.esc(T('Quem pode partilhar contigo'))}</span></div>
      ${apps.length ? `<div class="aqs-sec aqs-apps-sec"><div class="aqs-st"><b>${UI.esc(T('Partilhar numa app'))}</b></div><div class="aqs-apps"></div></div>` : ''}</div>`);
    body.querySelector('.aqs-vis').appendChild(visSeg());
    const th = body.querySelector('.aqs-th'); th.style.backgroundImage = Photos.bg(photo);
    Photos.data(photo, true).then(u => { if (u && th.isConnected) th.style.backgroundImage = Photos.bg(photo); });
    const S = { nova: true, photo, body, people: body.querySelector('.aqs-people'), hint: body.querySelector('.aqs-hint'), cards: new Map(), timer: null, thumb: undefined };
    S.sheet = UI.sheet({ title: qsName(), right: T('Fechar'), body, cls: 'aqs-wrap', onClose: () => { clearInterval(S.timer); S.timer = null; if (sh === S) sh = null; cancelPending(S); } });
    sh = S;
    const ap = body.querySelector('.aqs-apps');
    apps.forEach(a => {
      const t = UI.el(`<div class="aqs-app" role="button"><div class="aqs-ai">${Icons.tile(a.id)}</div><span></span></div>`);
      t.querySelector('span').textContent = a.label || App.name(a.id);
      t.onclick = () => { Sound.play('click'); S.sheet.close(); setTimeout(() => { try { a.onTap(); } catch (e) { console.error('[apex_phone] partilhar', e); } }, 80); };
      ap.appendChild(t);
    });
    /* sem rede não se procura ninguém (as apps por baixo continuam lá) */
    if (window.CC && CC.online && !CC.online()) { S.hint.textContent = T('Sem rede. Liga o Wi-Fi ou os dados móveis para encontrar dispositivos.'); return S; }
    S.hint.textContent = T('A procurar dispositivos por perto…');
    S.thumbP = Photos.thumb(photo).then(t => { S.thumb = t || null; return S.thumb; }).catch(() => { S.thumb = null; return null; });
    const poll = async () => { let list = null; try { list = await Bridge.rpcRaw('airdrop.nearby', {}); } catch (e) { list = null; } if (sh !== S || !list || list.error) return; paint(S, Array.isArray(list) ? list : Object.values(list || {})); };
    poll(); S.timer = setInterval(poll, 2000);
    return S;
  }
  function offerBodyNova(o) {
    const who = person(o.from), mins = o.seconds ? Math.max(1, Math.round(o.seconds / 60)) : 0;
    const body = UI.el(`<div class="aqs-rc"><div class="aqs-rc-h"><span class="aqs-ic">${QS_IC}</span><b>${UI.esc(qsName())}</b></div>
      <div class="aqs-rc-t"></div><div class="aqs-rc-img"></div>
      <div class="aqs-rc-dev">${UI.avatar({ name: who, avatar: o.avatar }, 'sm')}<span></span></div>
      <div class="aqs-rc-note"></div>
      <div class="aqs-rc-btns"><div class="aqs-btn no" role="button">${UI.esc(T('Recusar'))}</div><div class="aqs-btn yes" role="button">${UI.esc(T('Aceitar'))}</div></div></div>`);
    body.querySelector('.aqs-rc-t').innerHTML = TF('%s quer partilhar 1 imagem contigo', `<b>${UI.esc(who)}</b>`);
    body.querySelector('.aqs-rc-dev span').textContent = o.from;
    body.querySelector('.aqs-rc-img').style.backgroundImage = o.thumb ? UI.img(o.thumb) : photoBg(o.seed || 1);
    body.querySelector('.aqs-rc-note').textContent = mins ? TF(mins === 1 ? 'O pedido expira dentro de %s minuto. Se aceitares, a imagem fica na Galeria.' : 'O pedido expira dentro de %s minutos. Se aceitares, a imagem fica na Galeria.', mins) : T('Se aceitares, a imagem fica na Galeria.');
    return body;
  }
  function pageNova(win, o) {
    const v = UI.view({ title: qsName(), back: true, cls: 'aqs-page', onBack: vv => { UI.pop(vv); if (typeof o.onBack === 'function') { try { o.onBack(mode()); } catch (e) {} } } });
    const SUB = { everyone: 'Qualquer pessoa por perto te encontra', contacts: 'Só quem estiver nos teus contactos te encontra', off: 'Ninguém te encontra' };
    const paintPage = () => {
      v.content.textContent = '';
      v.content.appendChild(UI.el(`<div class="aqs-hero"><div class="aqs-hero-ic">${QS_IC}</div><b>${UI.esc(qsName())}</b><span>${UI.esc(T('Partilha fotos com quem está a poucos metros de ti, seja qual for o telemóvel. Quem recebe vê uma pré-visualização e decide se aceita.'))}</span></div>`));
      /* escolha única: o botão de opção da Nova UI (UI.radio), se o ui.js o tiver */
      v.content.appendChild(UI.list([{ header: T('Quem pode partilhar contigo'), items: VIS.map(m => Object.assign({ label: T(LABEL_A[m]), sub: T(SUB[m]), chevron: false, onTap: () => { Sound.play('click'); setMode(m); paintPage(); } }, UI.radio ? { right: UI.radio(m === mode()) } : { value: m === mode() ? '✓' : '' })),
        footer: T('Enviar funciona sempre, seja qual for a opção.') }]));
      /* CSHARE: quem te pode enviar cartões de contacto (html/js/apps/contactshare.js) */
      if (window.ContactShare && ContactShare.enabled() && ContactShare.settingsList) v.content.appendChild(ContactShare.settingsList(paintPage));
    };
    paintPage(); UI.push(win, v); return v;
  }
  /* a galeria só repinta pelo evento 'photos', e a cache é dela: carrega-se primeiro */
  let refT = null;
  function refreshPhotos() { clearTimeout(refT); refT = setTimeout(() => { refT = null; if (!window.Photos) return; Photos.load().then(() => Bridge.emit('photos')).catch(() => Bridge.emit('photos')); }, 50); }
  /* abrir o telemóvel / desbloquear com um pedido pendente: a folha aparece sozinha */
  function resume() { if (closed() || System.locked || recv || !inbox.size) return; openOffer(inbox.keys().next().value); }
  function reset() { inbox.clear(); outgoing.clear(); if (recv) { try { recv.answered = true; recv.sheet.close(); } catch (e) {} recv = null; } if (sh) { try { sh.sheet.close(); } catch (e) {} sh = null; } }

  /* ---------- Definições › Geral › AirShare (a linha é posta pelo integrador; aqui só a página) ----------
     o.onBack corre DEPOIS do pop: a linha "AirShare · Todos" da lista Geral acerta o valor sem refazer a lista */
  function page(win, o) {
    o = o || {};
    if (isA()) return pageNova(win, o);
    const v = UI.view({ title: 'AirShare', back: 'Geral', cls: 'ad-page', onBack: vv => { UI.pop(vv); if (typeof o.onBack === 'function') { try { o.onBack(mode()); } catch (e) {} } } });
    const paintPage = () => {
      v.content.innerHTML = '';
      v.content.appendChild(UI.el(`<div class="ad-hero"><div class="ad-hero-ic">${g('airdrop')}</div><b>AirShare</b><span>Partilha fotos com quem está a poucos metros de ti. Quem recebe vê uma pré-visualização e decide se aceita.</span></div>`));
      v.content.appendChild(UI.list([{ header: 'Receção', items: MODES.map(m => ({ label: LABEL[m], value: m === mode() ? '✓' : '', chevron: false, onTap: () => { Sound.play('click'); setMode(m); paintPage(); } })),
        footer: 'Só contactos: só quem estiver nos teus contactos te encontra. Todos: qualquer pessoa por perto. Enviar funciona sempre.' }]));
      /* CSHARE: quem te pode enviar cartões de contacto (html/js/apps/contactshare.js) */
      if (window.ContactShare && ContactShare.enabled() && ContactShare.settingsList) v.content.appendChild(ContactShare.settingsList(paintPage));
    };
    paintPage(); UI.push(win, v); return v;
  }

  function init() {
    Bridge.on('airdrop:offer', onOffer); Bridge.on('airdrop:result', onResult); Bridge.on('airdrop:gone', onGone);
    Bridge.on('photos:changed', refreshPhotos);
    Bridge.on('state', p => { if (p && typeof p === 'object' && ('airdrop' in p || 'deviceName' in p)) sync(); });
    Bridge.on('ready', sync);
    Bridge.on('session:changed', () => { reset(); sync(); }); Bridge.on('factory:reset', reset);
    Bridge.on('phone:open', () => setTimeout(resume, 450)); Bridge.on('unlock', () => setTimeout(resume, 300));
    sync();
  }
  return { init, share, setMode, mode, toggle, label, title, page, openOffer, MODES, LABEL, LABEL_A, inbox: () => [...inbox.keys()], get sharing() { return sh; }, get receiving() { return recv; } };
})();
