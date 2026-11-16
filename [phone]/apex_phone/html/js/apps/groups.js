/* ============================================================
   GRUPOS - window.Groups (Fase 2, pacote M4)
   Contrato: docs/ARQUITETURA.md secção 8.4 (NUI) e 8.3 (RPCs groups.* do servidor).
   ------------------------------------------------------------
   Groups.create(win)       → Promise do grupo criado (ou null): folha com nome, foto opcional e contactos
   Groups.info(win, id)     → vista empurrada na janela: avatar, nome, membros com papel, adicionar,
                              remover/promover (admin), foto (mudar/remover), silenciar e sair. Atualiza-se
                              com o push groupUpdate.
   Extras (aditivos, para o messages.js): list(), avatar(group, cls), pickMembers(opts), title(group), normalize(r)
   Eventos locais emitidos: 'groups:changed' { id, action, title?, avatar?, members? } e 'groups:left' { id, removed? }
   (quem tem a conversa aberta fecha-a).

   Identidade: nas SMS o membro é o NÚMERO (8.1). O "eu" é o `me`/`isMe` que o groups.info do
   server/groups.lua devolve e, sem eles (groups.list, servidor antigo), System.player.phone.
   A foto do grupo é um media (kind 'image') enviado aos bocados pelo VoiceMsg.uploadData e lido
   pelo VoiceMsg.fetchMedia; o data: URL entra SEMPRE pelo CSSOM, nunca na string de HTML.
   Respostas de erro do servidor: { ok = false, error = código[, max, numbers, skipped] } - ver ERR.
   ============================================================ */
window.Groups = (() => {
  const g = (n, s) => Icons.g(n, s);
  const FOREVER = 4102444800000;   /* "Sempre" em ocultar alertas: 1/1/2100 em ms (o mutedUntil é BIGINT em ms) */
  const norm = n => String(n == null ? '' : n).trim().replace(/\s+/g, ' ').slice(0, 20);
  /* a MESMA regra do cleanNumber do server/groups.lua: 3..20 carateres de dígitos, espaços e + - . ( ), com pelo
     menos 3 dígitos. Antes só aceitava dígitos, espaço e hífen: um contacto "+351 912 345 678" desaparecia da lista
     sem explicação, e o servidor aceitava-o. */
  const numOk = n => { const s = norm(n); return /^[0-9+\-.() ]{3,20}$/.test(s) && (s.match(/[0-9]/g) || []).length >= 3; };
  const myNumber = () => norm((window.System && System.player && System.player.phone) || (window.System && System.account && System.account.phone) || '');
  const selfOf = grp => norm((grp && grp.me) || myNumber());
  const isSelf = (m, grp) => !!m && (m.isMe === true || norm(m.member) === selfOf(grp));
  /* limite de membros: o `max` que o groups.info traz manda; senão Config.Messages.maxGroupMembers (o `ready` ainda
     não o traz - pedido ao client/main.lua e ao system.js) e por fim os 32 do config.lua */
  const maxMembers = grp => {
    const s = grp && Math.floor(+grp.max); if (s >= 2 && s <= 256) return s;
    const m = (window.System && System.config && System.config.messages) || {}; const v = Math.floor(+m.maxGroupMembers); return v >= 2 && v <= 256 ? v : 32;
  };
  const firstName = s => String(s || '').trim().split(/\s+/)[0] || String(s || '');
  /* Nova UI (Android): só muda a apresentação; os RPC groups.* e os dados são os mesmos nos dois sistemas */
  const isAndroid = () => !!(window.System && typeof System.isAndroid === 'function' && System.isAndroid());
  /* o Zapp (app de terceiros) tambem usa as Informacoes e o seletor: la fica tudo como no PearOS, so as Mensagens levam a Nova UI */
  const sysWin = w => !(w && w.classList && w.classList.contains('ou-3p'));
  const sysFront = () => { try { const id = System.currentApp && System.currentApp(); const w = id && System.windows && System.windows[id]; return !id || (sysWin(w) && !!(UI.OU_APPS && UI.OU_APPS.has(id))); } catch (e) { return true; } };
  const cut = (s, n) => [...String(s == null ? '' : s)].slice(0, n).join('');   /* por pontos de código: um emoji não fica partido a meio */
  /* o json.encode do FiveM manda uma tabela Lua vazia como {} (objeto) e uma esparsa como objeto: tudo o que é lista passa por aqui */
  const arrOf = x => Array.isArray(x) ? x : (x && typeof x === 'object' && !x.error ? Object.values(x) : null);

  /* Códigos: os do server/groups.lua (name, members, media, limit, cooldown, busy, db, noidentity, nophone, invalid,
     badnumber, toomany, notfound, notadmin, notmember, lastadmin) e os nomes antigos do mock (badname, nomembers,
     badmedia) para nada ficar sem texto. `r` é a resposta inteira (max, numbers, skipped). */
  const ERR = {
    toomany: r => `Um grupo pode ter no máximo ${Math.floor(+(r && r.max)) >= 2 ? Math.floor(+r.max) : maxMembers()} membros (contando contigo).`,
    notadmin: 'Só os administradores do grupo podem fazer isto.', forbidden: 'Só os administradores do grupo podem fazer isto.',
    notmember: 'Essa pessoa já não está no grupo.', notfound: 'Já não fazes parte deste grupo.',
    name: 'O nome do grupo tem de ter entre 1 e 40 caracteres.', badname: 'O nome do grupo tem de ter entre 1 e 40 caracteres.', noname: 'O nome do grupo tem de ter entre 1 e 40 caracteres.',
    members: r => (r && arrOf(r.skipped) && arrOf(r.skipped).length) ? 'Nenhum dos contactos escolhidos pode ser adicionado a um grupo neste momento.' : 'Escolhe pelo menos um contacto.',
    nomembers: 'Escolhe pelo menos um contacto.',
    badnumber: r => { const l = r && arrOf(r.numbers); return l && l.length ? `Não há ninguém com ${l.length === 1 ? 'o número' : 'os números'} ${l.slice(0, 4).map(x => String(x).slice(0, 20)).join(', ')}.` : 'Um dos números não é válido.'; },
    media: 'A foto não é válida ou ainda não acabou de enviar.', badmedia: 'A foto não é válida ou ainda não acabou de enviar.',
    limit: r => `Já estás no número máximo de grupos${Math.floor(+(r && r.max)) > 0 ? ' (' + Math.floor(+r.max) + ')' : ''}. Sai de um para criares outro.`,
    cooldown: 'Espera uns segundos antes de criares outro grupo.', busy: 'O grupo está a ser alterado por outra pessoa. Tenta outra vez.',
    db: 'Erro no servidor. Tenta outra vez.', noidentity: 'Este telemóvel não tem número.', nophone: 'Precisas de ter o telemóvel contigo.',
    invalid: 'Pedido inválido.', lastadmin: 'O grupo precisa de um administrador. Torna outro membro administrador primeiro.',
    self: 'Para saíres do grupo usa "Sair do grupo".', blocked: 'Um dos números não pode ser adicionado.',
    already: 'Esse contacto já está no grupo.', ratelimit: 'Demasiados pedidos seguidos. Tenta daqui a pouco.', rpc: 'O servidor não respondeu.'
  };
  const errText = (code, fallback, r) => { const e = ERR[code]; return typeof e === 'function' ? e(r) : e || fallback || 'Não foi possível concluir a operação.'; };

  /* ---------- resposta do servidor → grupo ----------
     Aceita { id, title, avatar, members } ou { group = {...} }. Membros como { member, role, name?, isMe?, joined? }
     (groups.info) ou só números (o messages.threads do mock do M3). Os campos extra (me, myRole, max, mutedUntil,
     createdBy, …) passam tal e qual. */
  function normalize(r) {
    const o = r && typeof r === 'object' && !r.error ? (r.group && typeof r.group === 'object' ? r.group : r) : null;
    const id = o && Math.floor(+o.id);
    if (!o || !(id > 0)) return null;
    const members = (arrOf(o.members) || [])
      .map(m => (typeof m === 'string' || typeof m === 'number') ? { member: m } : m)
      .filter(m => m && typeof m === 'object' && (m.member != null || m.number != null))
      .map(m => {
        const x = { member: norm(m.member != null ? m.member : m.number), role: m.role === 'admin' ? 'admin' : 'member', name: m.name ? String(m.name).slice(0, 60) : null };
        if (m.isMe === true) x.isMe = true;
        if (+m.joined > 0) x.joined = +m.joined;
        return x;
      })
      .filter(m => m.member);
    return Object.assign({}, o, { id, title: cut(o.title || o.name || '', 40), avatar: Math.floor(+o.avatar) > 0 ? Math.floor(+o.avatar) : null, members });
  }
  /* 1.1.8: "Tu", " e " e "e mais N" dentro de um título composto não são apanhados pelo tradutor do DOM (não há frase
     à volta que case um padrão): traduzem-se aqui pela chave exata ("%s e %s" → "%s and %s", "%s e mais %s") */
  const tt = s => (window.L && L.t ? L.t(s) : s);
  const tf = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? String(a.shift()) : '')));
  const memberName = (m, grp) => { if (!m) return ''; if (isSelf(m, grp)) return tt('Tu'); const c = window.Contacts && Contacts.byNumber(m.member); return (c && c.name) || m.name || m.member; };
  /* sem nome: "Ana, Rui e Mãe" / "Ana, Rui e mais 3" (a partir dos membros que não sou eu) */
  function autoTitle(people) {
    const ns = people.map(p => firstName(p.name || p.member || p.number)).filter(Boolean);
    if (!ns.length) return 'Grupo';
    if (ns.length === 1) return ns[0];
    if (ns.length <= 3) return tf('%s e %s', ns.slice(0, -1).join(', '), ns[ns.length - 1]);
    return tf('%s e mais %s', ns.slice(0, 2).join(', '), ns.length - 2);
  }
  const title = grp => (grp && grp.title) || autoTitle(((grp && grp.members) || []).filter(m => !isSelf(m, grp)).map(m => ({ name: memberName(m, grp) })));

  /* ---------- avatar do grupo ----------
     Gradiente da paleta dos avatares + glifo de pessoas; com foto, a imagem desce pelo media.get
     (VoiceMsg.fetchMedia, com cache) e pinta-se por CSSOM. Só se aceita um data:image base64 limpo. */
  const isImg = u => typeof u === 'string' && u.length < 400000 && /^data:image\/(jpeg|jpg|png|webp);base64,[A-Za-z0-9+/=]+$/i.test(u);
  function avatar(grp, cls = '') {
    const el = UI.el(`<div class="avatar grp-av ${UI.esc(cls)}">${g('users')}</div>`);
    el.setAttribute('style', UI.avatarStyle((grp && Math.floor(+grp.id)) || String(title(grp)).length));
    const mid = grp && Math.floor(+grp.avatar);
    if (mid > 0 && window.VoiceMsg) paintAvatar(el, mid);
    return el;
  }
  function paintAvatar(el, mid) {
    return VoiceMsg.fetchMedia(mid).then(m => { if (!m || m.error || !isImg(m.dataUrl)) return false; el.style.backgroundImage = UI.img(m.dataUrl); el.classList.add('has-img'); return true; });
  }
  /* foto de contacto (avatarPhoto) numa linha de lista, como a lista dos Contactos faz: por CSSOM e sem pressa */
  const paintContact = (li, c) => { try { if (c && window.Contacts && Contacts.photoId && Contacts.photoId(c)) { const a = li.querySelector('.avatar'); if (a) Contacts.paintAvatar(a, c, false); } } catch (e) {} };
  /* fotos só com `seed` (as de exemplo do browser): desenha-se o mesmo gradiente do photoBg num canvas */
  function seedImage(seed) {
    try {
      seed = Math.floor(+seed) || 1;
      const c = document.createElement('canvas'); c.width = c.height = 256; const x = c.getContext('2d');
      const a = ((seed * 37) % 360) * Math.PI / 180, dx = Math.sin(a) * 128, dy = -Math.cos(a) * 128;
      const gr = x.createLinearGradient(128 - dx, 128 - dy, 128 + dx, 128 + dy);
      gr.addColorStop(0, `hsl(${(seed * 53) % 360},70%,58%)`); gr.addColorStop(1, `hsl(${(seed * 53 + 110) % 360},65%,32%)`);
      x.fillStyle = gr; x.fillRect(0, 0, 256, 256); return c.toDataURL('image/jpeg', .85);
    } catch (e) { return null; }
  }
  /* Fotos → miniatura quadrada 256 px em JPEG (~20 KB): cabe num único bocado e no maxImageBytes */
  async function pickAvatarData() {
    if (!window.Photos || !Photos.pick) { UI.toast('A galeria não está disponível'); return null; }
    const p = await Photos.pick('Foto do grupo'); if (!p) return null;
    let src = null; try { src = await Photos.data(p, true); } catch (e) { src = null; }
    if (!src && p.seed != null && !p.len) src = seedImage(p.seed);
    if (!src) { UI.toast('Não foi possível abrir esta foto'); return null; }
    const cap = (window.VoiceMsg && VoiceMsg.util.cfg().maxImageBytes) || 260000;
    let out = null; try { out = await Photos.square(src, 256, .8); if (out && out.length > cap) out = await Photos.square(src, 160, .7); } catch (e) { out = null; }
    /* uma foto guardada como link externo (upload) suja o canvas e o toDataURL falha: diz-se, em vez de enviar nada */
    if (!isImg(out) || out.length > cap) { UI.toast('Esta foto não pode ser usada como foto do grupo'); return null; }
    return out;
  }
  async function uploadAvatar(dataUrl) {
    if (!window.VoiceMsg) return { mediaId: null, error: 'rpc' };
    return VoiceMsg.uploadData(dataUrl, { kind: 'image', mime: 'image/jpeg' });
  }

  /* ---------- seletor de membros (vários) ----------
     Componente partilhado pela criação e por "Adicionar membros": chips dos escolhidos, pesquisa
     (também aceita um número escrito à mão), contador com limite e lista de contactos com visto.
     A lista não é repintada ao marcar: só o visto e os chips mudam, o scroll fica onde estava. */
  function memberPicker(o = {}) {
    const max = Math.max(0, Math.floor(+o.max) || 0);
    const exclude = new Set((o.exclude || []).map(norm)); exclude.add(norm(o.self) || myNumber());
    const sel = new Map();
    const root = UI.el('<div class="grp-picker"><div class="grp-chips"></div><div class="group-header grp-count"></div><div class="grp-list"></div></div>');
    const chips = root.querySelector('.grp-chips'), count = root.querySelector('.grp-count'), holder = root.querySelector('.grp-list');
    let query = '';
    const search = UI.search('Pesquisar ou escrever um número', q => { query = q; paint(); });
    root.insertBefore(search, count);
    const checks = new Map();
    function refresh() {
      count.textContent = `${sel.size} de ${max} ${max === 1 ? 'pessoa' : 'pessoas'}`;
      checks.forEach((c, n) => c.classList.toggle('on', sel.has(n)));
      chips.innerHTML = '';
      sel.forEach((p, n) => {
        const chip = UI.el(`<span class="grp-chip"><b></b><i>${g('x')}</i></span>`);
        chip.querySelector('b').textContent = firstName(p.name);
        chip.onclick = () => { sel.delete(n); refresh(); };
        chips.appendChild(chip);
      });
      if (o.onChange) { try { o.onChange(sel.size); } catch (e) {} }
    }
    function toggle(p) {
      const n = norm(p.number); if (!numOk(n) || exclude.has(n)) return;
      if (sel.has(n)) sel.delete(n);
      else if (sel.size >= max) { UI.toast(max ? `Máximo de ${max} ${max === 1 ? 'pessoa' : 'pessoas'}` : 'O grupo já está cheio'); return; }
      else sel.set(n, { name: p.name || n, number: n });
      refresh();
    }
    function paint() {
      holder.innerHTML = ''; checks.clear();
      const seen = new Set();
      const list = ((window.Contacts && Contacts.cache) || []).filter(c => {
        if (!c || !c.number) return false; const n = norm(c.number);
        if (exclude.has(n) || seen.has(n) || !numOk(n)) return false; seen.add(n);
        return !query || String(c.name || '').toLowerCase().includes(query) || n.includes(query);
      });
      const grp = UI.el('<div class="list"><div class="group"></div></div>'), box = grp.firstElementChild;
      const row = (p, extra) => {
        const n = norm(p.number), chk = UI.el(`<div class="grp-check">${g('check')}</div>`);
        checks.set(n, chk); chk.classList.toggle('on', sel.has(n));
        const li = UI.item(Object.assign({ label: p.name || n, sub: p.name && p.name !== n ? n : undefined, chevron: false, right: chk, onTap: () => toggle(p) }, extra));
        box.appendChild(li);
        if (extra && extra.avatar) paintContact(li, extra.photo || extra.avatar);
      };
      const typed = norm(query);
      if (typed && numOk(typed) && !exclude.has(typed) && !seen.has(typed)) {
        const c = window.Contacts && Contacts.byNumber(typed);
        row({ name: (c && c.name) || typed, number: typed }, { icon: 'keypad', iconBg: 'var(--gray)', label: 'Usar o número ' + typed, sub: undefined });
      }
      list.forEach(c => row({ name: c.name, number: c.number }, isAndroid() && sysFront() ? { avatar: { name: c.name, avatar: c.avatar || String(c.name || '').length }, photo: c } : { avatar: c }));
      sel.forEach((p, n) => { if (!checks.has(n) && !query) row(p, { icon: 'keypad', iconBg: 'var(--gray)' }); });   /* números escritos à mão continuam visíveis */
      if (!box.children.length) holder.appendChild(UI.empty('users', query ? 'Sem resultados' : 'Sem contactos', query ? 'Escreve um número para o adicionar.' : 'Adiciona contactos no Telefone ou escreve um número.'));
      else holder.appendChild(grp);
    }
    paint(); refresh();
    return { el: root, selected: () => [...sel.values()], get size() { return sel.size; }, reload: paint };
  }
  const ensureContacts = async () => { try { if (window.Contacts && !Contacts.cache.length) await Contacts.load(); } catch (e) {} };

  /* folha só com o seletor (Adicionar membros): Promise de [{ name, number }] ou null */
  async function pickMembers(o = {}) {
    await ensureContacts();
    return new Promise(res => {
      const picker = memberPicker({ max: o.max, exclude: o.exclude, self: o.self });
      UI.sheet({ title: o.title || 'Adicionar membros', left: 'Cancelar', right: o.done || 'Adicionar', body: picker.el, cls: 'grp-sheet',
        /* res ANTES de fechar: o onClose resolve null de forma síncrona e a promessa só honra a primeira */
        onDone: () => { if (!picker.size) { UI.toast('Escolhe pelo menos um contacto'); return false; } res(picker.selected()); },
        onClose: () => res(null) });
    });
  }
  /* "Ana, Rui" a partir dos números devolvidos pelo servidor (skipped/added), com os nomes escolhidos na folha */
  const namesOf = (nums, people) => nums.map(n => { const p = (people || []).find(x => norm(x.number) === norm(n)); const c = !p && window.Contacts && Contacts.byNumber(norm(n)); return firstName((p && p.name) || (c && c.name) || n); }).join(', ');

  /* ============================================================
     CRIAR GRUPO
     ============================================================ */
  async function create(win, o = {}) {
    await ensureContacts();
    return new Promise(res => {
      let avatarData = null, busy = false, closed = false, settled = false;
      const done = v => { if (settled) return; settled = true; res(v); };
      const room = maxMembers() - 1;   /* o criador conta para o limite */
      const body = UI.el(`<div class="grp-new">
        <div class="grp-new-head">
          <div class="grp-av-pick" aria-label="Foto do grupo"><div class="avatar grp-av">${g('camera')}</div><span>Foto</span></div>
          <div class="group"><div class="li static"><input type="text" class="grp-name-in" placeholder="Nome do grupo" maxlength="40"></div></div>
        </div>
        <div class="grp-new-note">Sem nome, o grupo fica com os nomes dos membros.</div>
      </div>`);
      const input = body.querySelector('.grp-name-in'), avPick = body.querySelector('.grp-av-pick'), av = avPick.querySelector('.grp-av'), pickLbl = avPick.querySelector('span');
      const picker = memberPicker({ max: room, exclude: o.exclude || [] });
      body.appendChild(picker.el);
      const paintAv = () => {
        av.style.backgroundImage = avatarData ? UI.img(avatarData) : '';
        av.classList.toggle('has-img', !!avatarData); pickLbl.textContent = avatarData ? 'Alterar' : 'Foto';
      };
      avPick.onclick = async () => {
        if (busy) return;
        if (avatarData) {
          const v = await UI.actionSheet({ buttons: [{ label: 'Escolher outra foto', value: 'pick' }, { label: 'Remover foto', value: 'rm', danger: true }] });
          if (v === 'rm') { avatarData = null; paintAv(); return; }
          if (v !== 'pick') return;
        }
        const d = await pickAvatarData(); if (d && !closed) { avatarData = d; paintAv(); }
      };
      let sh = null;
      const setBusy = on => { busy = on; if (!sh) return; sh.el.classList.toggle('is-busy', on); const r = sh.el.querySelector('.sh-r'); if (r) r.textContent = on ? 'A criar…' : 'Criar'; };
      async function submit() {
        if (busy) return;
        const people = picker.selected();
        if (!people.length) { UI.toast('Escolhe pelo menos um contacto'); return; }
        const name = cut(input.value.replace(/\p{Cc}/gu, '').trim().replace(/\s+/g, ' '), 40) || cut(autoTitle(people), 40);
        setBusy(true);
        let avatarId = null;
        if (avatarData) {
          const up = await uploadAvatar(avatarData);
          if (!up || !up.mediaId) { setBusy(false); if (closed) { done(null); return; } UI.alert({ title: 'Foto do grupo', msg: VoiceMsg.errorText(up && up.error, 'Não foi possível enviar a foto.') + ' Podes remover a foto e criar o grupo sem ela.' }); return; }
          avatarId = up.mediaId;
        }
        /* Cancelar (ou guardar o telemóvel) DURANTE o envio da foto: o groups.create ainda não saiu, por isso
           respeita-se o cancelamento - antes o grupo era criado na mesma, com a folha já fechada. A foto enviada
           fica sem dono e sai na limpeza do server/media.lua. Depois de o pedido sair já não há volta atrás. */
        if (closed) { setBusy(false); done(null); return; }
        const r = await Bridge.rpcRaw('groups.create', Object.assign({ name, members: people.map(p => p.number) }, avatarId ? { avatar: avatarId } : {}));
        setBusy(false);
        const grp = normalize(r);
        if (!grp) { if (closed) done(null); UI.alert({ title: 'Não foi possível criar o grupo', msg: errText(r && r.error, null, r) }); return; }
        if (!grp.members.length) grp.members = [{ member: myNumber(), role: 'admin', name: null, isMe: true }].concat(people.map(p => ({ member: p.number, role: 'member', name: p.name })));
        try { Sound.play('success'); } catch (e) {}
        done(grp);
        if (!closed) sh.close();
        /* quem não pôde entrar (bloqueou-te, ou já está no máximo de grupos): o grupo cria-se sem essa pessoa e diz-se quem */
        const skipped = arrOf(r.skipped) || [];
        if (skipped.length) UI.toast(`Não foi possível adicionar ${namesOf(skipped, people)}`, 2800);
        Bridge.emit('groups:changed', { id: grp.id, action: 'create', title: grp.title, avatar: grp.avatar, members: grp.members.map(m => m.member) });
      }
      /* fechar a folha DEPOIS de o pedido sair não "cancela" o servidor: a promessa espera pela resposta */
      sh = UI.sheet({ title: 'Novo grupo', left: 'Cancelar', right: 'Criar', body, cls: 'grp-sheet', onDone: () => { submit(); return false; }, onClose: () => { closed = true; if (!busy) done(null); } });
    });
  }

  /* ============================================================
     INFORMAÇÃO DO GRUPO
     ============================================================ */
  function info(win, id, o = {}) {
    id = Math.floor(+id);
    /* Nova UI (Android): página inteira por cima dos separadores das Mensagens (como as outras fichas do sistema) */
    const A = isAndroid() && sysWin(win);
    const v = UI.view({ title: 'Informações', back: o.back || true, cls: 'grp-info', full: A });
    const hero = UI.el('<div class="grp-hero"><div class="grp-hero-av"></div><div class="grp-hero-title"></div><div class="grp-hero-sub"></div></div>');
    const holder = UI.el('<div class="grp-holder"></div>');
    v.content.append(hero, holder);
    holder.appendChild(UI.skeleton('list', 4));
    const heroAv = hero.querySelector('.grp-hero-av'), heroTitle = hero.querySelector('.grp-hero-title'), heroSub = hero.querySelector('.grp-hero-sub');
    let data = null, muted = null, seq = 0, gone = false, busyAv = false, seen = false, pushT = null, leftSent = false, offs = [];

    /* ⚠️ OUVINTES: largam-se no onPop (voltar / setRoot) E quando a vista sai do documento sem nenhum dos dois
       (app morta, janela refeita). Antes o de 'contacts' nunca saía e o de 'groupUpdate' só saía se já houvesse
       dados: cada info aberta e fechada com a app morta deixava dois ouvintes vivos até recarregar a NUI. */
    const unlisten = () => { offs.forEach(f => { try { f(); } catch (e) {} }); offs = []; clearTimeout(pushT); pushT = null; };
    /* `seen`: a vista já esteve no documento (empurrada aqui, ou montada depois por quem a pediu sem janela). Só
       a partir daí "fora do documento" quer dizer "morta"; antes disso é uma vista ainda por montar. */
    const alive = () => { if (v.isConnected) { seen = true; return true; } if (seen) { unlisten(); return false; } return true; };
    offs.push(
      Bridge.on('groupUpdate', d => {
        if (!alive() || !d || Math.floor(+d.id) !== id) return;
        /* pushes seguidos (a própria ação, outro admin logo a seguir) juntam-se num único groups.info */
        clearTimeout(pushT); pushT = setTimeout(() => { pushT = null; if (alive()) load(); }, 120);
      }),
      Bridge.on('contacts', () => { if (alive() && data && !gone) render(); })   /* nomes/fotos dos contactos mudaram */
    );
    v.opts.onPop = unlisten;
    if (win) UI.push(win, v);
    seen = v.isConnected;

    async function readMute() {
      const ts = await Bridge.rpc('messages.threads', { app: 'sms' });
      const t = (arrOf(ts) || []).find(x => x && x.group && Math.floor(+x.group.id) === id);
      return t ? (+t.mutedUntil || 0) : 0;
    }
    async function load() {
      const my = ++seq;
      const r = await Bridge.rpcRaw('groups.info', { id });
      if (my !== seq) return;
      if (!r || r.error) {
        const e = r && r.error;
        if (e === 'notmember' || e === 'forbidden' || e === 'notfound') return showGone(e);
        if (!data) { holder.innerHTML = ''; holder.appendChild(UI.empty('users', 'Não foi possível abrir o grupo', errText(e, null, r))); }
        else UI.toast(errText(e, null, r));
        return;
      }
      apply(r, my);
    }
    function apply(r, my) {
      const grp = normalize(r);
      if (!grp) { if (!data) { holder.innerHTML = ''; holder.appendChild(UI.empty('users', 'Resposta inválida', 'O servidor não devolveu o grupo.')); } return false; }
      data = grp; gone = false;
      if (grp.mutedUntil != null) muted = +grp.mutedUntil || 0;
      /* o groups.info do server/groups.lua só manda mutedUntil quando há silêncio gravado (um nil some do JSON), mas
         traz sempre myRole/pinned: aí a falta quer dizer "sem silêncio". O messages.threads inteiro só se pede a um
         servidor que não mande nada disso. */
      else if (grp.myRole != null || grp.pinned != null) muted = 0;
      else if (muted == null) { muted = 0; readMute().then(m => { if (my === seq && v.isConnected && !gone) { muted = m; render(); } }).catch(() => {}); }
      render();
      return true;
    }
    function showGone(e) {
      const wasIn = !!data && !gone;
      gone = true; holder.innerHTML = '';
      /* o servidor responde "notfound" tanto a um grupo apagado como a quem já não é membro (de propósito, para não
         revelar grupos alheios): a mensagem cobre os dois casos, em vez de afirmar que o grupo deixou de existir */
      holder.appendChild(UI.empty('users', 'Já não fazes parte deste grupo', e === 'notfound' ? 'Foste removido ou o grupo já não existe. Deixas de receber as mensagens dele.' : 'Deixas de receber as mensagens deste grupo.'));
      heroSub.textContent = ''; heroTitle.classList.remove('is-editable'); heroAv.classList.remove('is-editable');
      heroTitle.onclick = null; heroAv.onclick = null;   /* renomear/foto já não se aplicam (antes o lápis continuava a abrir o renomear) */
      const pen = heroTitle.querySelector('svg'); if (pen) pen.remove();
      if (!data) { heroTitle.textContent = 'Grupo'; heroAv.innerHTML = ''; heroAv.dataset.k = ''; heroAv.appendChild(avatar({ id }, 'lg')); }
      /* estava a ver o grupo como membro e deixou de o ser (removido por um admin → push groupUpdate): avisa quem tem a conversa aberta */
      if (wasIn && !leftSent) { leftSent = true; Bridge.emit('groups:left', { id, removed: true }); }
    }
    const me = () => data && data.members.find(m => isSelf(m, data));
    const isAdmin = () => { const m = me(); return !!(m && m.role === 'admin'); };

    function render() {
      if (!data || gone) return;
      if (v.isConnected) seen = true;
      const admin = isAdmin(), n = data.members.length, t = title(data);
      /* a foto só se refaz quando muda: refazer o hero em cada render (silenciar, nomes dos contactos) fazia piscar o gradiente antes da foto */
      const avKey = data.id + '|' + (data.avatar || 0);
      if (heroAv.dataset.k !== avKey || !heroAv.firstElementChild) { heroAv.dataset.k = avKey; heroAv.innerHTML = ''; heroAv.appendChild(avatar(data, 'lg')); }
      heroAv.classList.toggle('is-editable', admin); heroAv.classList.toggle('is-busy', busyAv);
      heroTitle.textContent = t; if (admin) heroTitle.insertAdjacentHTML('beforeend', g('pen'));
      heroTitle.classList.toggle('is-editable', admin);
      heroSub.textContent = `Grupo · ${n} ${n === 1 ? 'membro' : 'membros'}`;
      heroAv.onclick = admin ? changePhoto : null; heroTitle.onclick = admin ? rename : null;

      const sorted = data.members.slice().sort((a, b) => {
        const am = isSelf(a, data), bm = isSelf(b, data); if (am !== bm) return am ? -1 : 1;
        if (a.role !== b.role) return a.role === 'admin' ? -1 : 1;
        return String(memberName(a, data)).localeCompare(String(memberName(b, data)), 'pt');
      });
      const items = [], contacts = [];
      if (admin) items.push({ icon: 'personPlus', iconBg: 'var(--blue)', iconColor: '#fff', label: 'Adicionar membros', cls: 'blue', chevron: false, onTap: addMembers });
      sorted.forEach(m => {
        const mine = isSelf(m, data), nm = memberName(m, data), c = window.Contacts && Contacts.byNumber(m.member);
        const acts = memberActions(m, admin, mine);
        /* Nova UI: as mesmas cores dos avatares do Telefone e das Mensagens (a foto do contacto continua a ser pintada por cima) */
        const avName = mine ? ((System.account && System.account.username) || 'Eu') : nm;
        items.push({ avatar: A ? { name: (c && c.name) || avName, avatar: (c && c.avatar) || (mine && System.account && System.account.avatar) || String((c && c.name) || avName).length } : (c || { name: avName }), label: nm, sub: m.member, chevron: false,
          right: `<span class="grp-role ${m.role === 'admin' ? 'admin' : ''}">${m.role === 'admin' ? 'Admin' : ''}</span>`,
          onTap: acts.length ? () => sheetMenu(nm, acts) : undefined,
          onLong: acts.length ? li => UI.ctxMenu(li, acts) : undefined });
        contacts.push(c || null);
      });
      const on = muted > Date.now();
      holder.innerHTML = '';
      const list = UI.list([
        { header: `${n} ${n === 1 ? 'membro' : 'membros'}`, items, footer: admin ? 'Toca ou mantém premido um membro para o tornar administrador ou remover.' : undefined },
        { items: [{ icon: on ? 'bellOff' : 'bell', iconBg: 'var(--indigo)', iconColor: '#fff', label: 'Ocultar alertas', toggle: on, onToggle: setMute }],
          footer: on ? (muted >= FOREVER - 864e5 ? 'Alertas ocultados sempre.' : 'Alertas ocultados até ' + UI.fmtDate(new Date(muted), true) + ', ' + UI.fmtTime(new Date(muted)) + '.') : undefined },
        { items: [{ label: 'Sair do grupo', cls: 'danger center', chevron: false, onTap: leave }] }
      ]);
      holder.appendChild(list);
      /* as linhas com .grp-role são as dos membros, pela mesma ordem: pinta-se a foto de cada contacto */
      [...list.querySelectorAll('.li')].filter(li => li.querySelector('.grp-role')).forEach((li, i) => paintContact(li, contacts[i]));
    }
    function sheetMenu(name, acts) {
      UI.actionSheet({ title: name, buttons: acts.map((a, i) => ({ label: a.label, danger: a.danger, value: 'a' + i })) })
        .then(val => { if (typeof val !== 'string') return; const a = acts[+val.slice(1)]; if (a && a.onTap) a.onTap(); });
    }
    function memberActions(m, admin, mine) {
      const nm = memberName(m, data), acts = [];
      if (!mine) {
        acts.push({ label: 'Enviar mensagem', icon: 'message', onTap: () => { if (window.Msgs && Msgs.open) Msgs.open(m.member, nm); } });
        acts.push({ label: 'Ligar', icon: 'phone', onTap: () => { if (window.PhoneApp) PhoneApp.call(m.member, nm); } });
        if (window.Contacts && !Contacts.byNumber(m.member) && typeof window.addContact === 'function') acts.push({ label: 'Adicionar aos contactos', icon: 'personPlus', onTap: () => window.addContact(null, { number: m.member, name: m.name || '' }) });
      }
      if (admin && !mine) {
        acts.push(m.role === 'admin' ? { label: 'Retirar administrador', icon: 'shield', onTap: () => setRole(m, 'member') } : { label: 'Tornar administrador', icon: 'shield', onTap: () => setRole(m, 'admin') });
        acts.push({ label: 'Remover do grupo', icon: 'minusCircle', danger: true, onTap: () => removeMember(m) });
      }
      return acts;
    }
    /* todas as alterações: rpcRaw (para ler o { error }). Devolve a resposta (verdadeira) ou false. */
    async function act(rpc, payload, okMsg, action) {
      const r = await Bridge.rpcRaw(rpc, Object.assign({ id }, payload));
      if (!r || r.error || r.ok === false) {
        const e = r && r.error;
        /* "notmember" num remove/role é o ALVO que já saiu (outro admin foi mais rápido), não eu: antes esta resposta
           fechava a vista com "Já não fazes parte". Recarrega-se e o groups.info decide se eu ainda cá estou. */
        if (e === 'notmember') { UI.toast('Essa pessoa já não está no grupo'); await load(); return false; }
        if (e === 'notfound') { await load(); return false; }   /* o groups.info a seguir mostra "Já não fazes parte" */
        UI.alert({ title: 'Não foi possível', msg: errText(e, null, r) }); return false;
      }
      if (okMsg) UI.toast(okMsg);
      /* o server/groups.lua devolve o grupo JÁ atualizado (a forma do groups.info): usa-se essa resposta em vez de outra
         ida ao servidor. Uma resposta sem membros ({ ok } de um servidor antigo) volta a pedir o groups.info. */
      const ms = arrOf(r.members);
      if (ms && ms.length && Math.floor(+r.id) === id) apply(r, ++seq); else await load();
      /* com o título/avatar/membros já atualizados: o messages.js guarda-os na cache dos grupos (cabeçalho da conversa) */
      Bridge.emit('groups:changed', Object.assign({ id, action }, data && !gone ? { title: data.title, avatar: data.avatar, members: data.members.map(m => m.member) } : {}));
      return r;
    }
    async function rename() {
      if (!data || !isAdmin() || gone) return;
      const r = await UI.alert({ title: 'Nome do grupo', msg: 'Todos os membros veem o novo nome.', input: { placeholder: 'Nome do grupo', value: data.title || '', maxlength: 40 }, buttons: [{ label: 'Cancelar', value: false }, { label: 'Guardar', bold: true, value: true }] });
      if (!r.value || gone) return;
      const name = cut(String(r.text || '').replace(/\p{Cc}/gu, '').replace(/\s+/g, ' ').trim(), 40);
      if (!name) { UI.toast('O nome não pode ficar vazio'); return; }
      if (name === data.title) return;
      await act('groups.rename', { name }, 'Nome alterado', 'rename');
    }
    async function changePhoto() {
      if (!data || !isAdmin() || busyAv || gone) return;
      /* com foto: escolher outra ou REMOVER. O groups.setAvatar do server/groups.lua tira a imagem com mediaId 0
         (nil/0/false); um null em JSON não chegava a sair do cliente como "tirar". */
      if (data.avatar) {
        const val = await UI.actionSheet({ title: 'Foto do grupo', buttons: [{ label: 'Escolher outra foto', value: 'pick' }, { label: 'Remover foto', value: 'rm', danger: true }] });
        if (!v.isConnected || gone) return;
        if (val === 'rm') { busyAv = true; render(); await act('groups.setAvatar', { mediaId: 0 }, 'Foto removida', 'avatar'); busyAv = false; render(); return; }
        if (val !== 'pick') return;
      }
      const d = await pickAvatarData(); if (!d || !v.isConnected || gone) return;
      busyAv = true; render();
      const up = await uploadAvatar(d);
      busyAv = false;
      if (!up || !up.mediaId) { render(); UI.alert({ title: 'Foto do grupo', msg: VoiceMsg.errorText(up && up.error, 'Não foi possível enviar a foto.') }); return; }
      if (!await act('groups.setAvatar', { mediaId: up.mediaId }, 'Foto alterada', 'avatar')) render();
    }
    async function addMembers() {
      if (!data || !isAdmin() || gone) return;
      const max = maxMembers(data), room = max - data.members.length;
      if (room <= 0) { UI.alert({ title: 'Grupo cheio', msg: errText('toomany', null, { max }) }); return; }
      const picked = await pickMembers({ title: 'Adicionar membros', exclude: data.members.map(m => m.member), self: selfOf(data), max: room, done: 'Adicionar' });
      if (!picked || !picked.length || !v.isConnected || gone) return;
      const r = await act('groups.add', { numbers: picked.map(p => p.number) }, null, 'add');
      if (!r) return;
      /* o servidor diz quem entrou de facto (added), quem já lá estava e quem não pode entrar (skipped: bloqueou-te
         ou já está no máximo de grupos). Um { ok } sem listas conta como "entraram todos". */
      const added = arrOf(r.added), skipped = arrOf(r.skipped) || [];
      const cnt = added ? added.length : picked.length;
      if (cnt === 1) UI.toast(`${namesOf([added ? added[0] : picked[0].number], picked)} foi adicionado`);
      else if (cnt > 1) UI.toast(`${cnt} membros adicionados`);
      else if (!skipped.length) UI.toast('Já estavam todos no grupo');
      if (skipped.length) setTimeout(() => UI.toast(`Não foi possível adicionar ${namesOf(skipped, picked)}`, 2800), cnt ? 1900 : 0);
    }
    async function setRole(m, role) {
      await act('groups.role', { number: m.member, role }, role === 'admin' ? `${firstName(memberName(m, data))} é agora administrador` : `${firstName(memberName(m, data))} deixou de ser administrador`, 'role');
    }
    async function removeMember(m) {
      const nm = memberName(m, data);
      if (!await UI.confirm('Remover do grupo', `${nm} deixa de receber as mensagens deste grupo.`, 'Remover', true)) return;
      await act('groups.remove', { number: m.member }, `${firstName(nm)} foi removido`, 'remove');
    }
    async function setMute(on) {
      let until = 0;
      if (on) {
        const val = await UI.actionSheet({ title: 'Ocultar alertas de "' + title(data) + '"', buttons: [{ label: 'Durante 1 hora', value: 'h1' }, { label: 'Durante 8 horas', value: 'h8' }, { label: 'Durante 1 semana', value: 'w1' }, { label: 'Sempre', value: 'ever' }] });
        const ms = { h1: 36e5, h8: 8 * 36e5, w1: 7 * 864e5 }[val];
        if (!ms && val !== 'ever') { render(); return; }   /* cancelou: o interruptor volta atrás */
        until = val === 'ever' ? FOREVER : Date.now() + ms;
      }
      const r = await Bridge.rpcRaw('thread.set', { conversation: id, app: 'sms', mutedUntil: until });
      if (!r || r.error || r.ok === false) { UI.toast(on ? 'Não foi possível ocultar os alertas' : 'Não foi possível reativar os alertas'); render(); return; }
      /* o que o servidor gravou manda (ele arredonda e corta no FOREVER); sem o campo (nil = sem silêncio) fica o pedido */
      muted = r.mutedUntil != null ? (+r.mutedUntil || 0) : until; render();
      UI.toast(on ? 'Alertas ocultados' : 'Alertas reativados');
      Bridge.emit('groups:changed', { id, action: 'mute', mutedUntil: muted });
    }
    async function leave() {
      if (gone) { UI.pop(v); return; }
      const admin = isAdmin(), others = data ? data.members.filter(m => !isSelf(m, data)) : [];
      const soleAdmin = admin && others.length && !others.some(m => m.role === 'admin');
      if (!await UI.confirm('Sair do grupo', soleAdmin ? 'És o único administrador: ao saíres, outro membro passa a administrar o grupo. Deixas de receber as mensagens.' : 'Deixas de receber as mensagens deste grupo.', 'Sair', true)) return;
      const r = await Bridge.rpcRaw('groups.leave', { id });
      /* "notfound": já tinha sido removido entretanto - o resultado é o mesmo de sair */
      if ((!r || r.error || r.ok === false) && !(r && r.error === 'notfound')) { UI.alert({ title: 'Não foi possível sair', msg: errText(r && r.error, null, r) }); return; }
      gone = true; leftSent = true; unlisten();
      UI.toast('Saíste do grupo');
      Bridge.emit('groups:left', { id }); Bridge.emit('groups:changed', { id, action: 'leave' });
      if (o.onLeave) { try { o.onLeave(id); } catch (e) {} }
      if (v.isConnected) UI.pop(v);
    }

    load();
    v.reload = load;
    return v;
  }

  async function list() {
    const r = await Bridge.rpc('groups.list', {});
    const arr = Array.isArray(r) ? r : (r && Array.isArray(r.groups) ? r.groups : (arrOf(r) || []));
    return arr.map(normalize).filter(Boolean);
  }

  return { create, info, list, avatar, pickMembers, title, normalize, FOREVER, errorText: errText };
})();

/* ============================================================
   MOCKS DO BROWSER - groups.*
   Seguem o server/groups.lua (pacote M2) à letra: os mesmos códigos de erro ({ ok:false, error }), a mesma
   forma de resposta (buildInfo: ok, id, title, avatar?, createdBy, myRole, me, max, memberCount, pinned,
   mutedUntil?, members [{ member, role, joined, name?, isMe? }]), "não és membro" = notfound, remover-se a si
   próprio = sair, adicionar quem já lá está não é erro, mediaId 0 tira a foto, o último a sair apaga o grupo,
   mensagens de sistema ('system') e o push groupUpdate só a quem ainda é membro.
   Nas MESMAS tabelas do servidor (8.1): LocalDB 'conversations' { id, app, title, avatar, created_by, created,
   last_id } e 'conversation_members' { conversation_id, member, role, joined, last_read_id, left_at }, que são
   as que os mocks de messages.threads / get / send / thread.set do messages.js (M3) leem.
   ============================================================ */
if (window.LocalDB && LocalDB.register) (() => {
  const MAX = 32, MAX_GROUPS = 100;   /* maxGroupMembers do config.lua e maxGroupsPerMember por omissão do servidor */
  const T = LocalDB.T, C = () => T('conversations'), M = () => T('conversation_members');
  const myNum = () => String((LocalDB.me() || {}).number || '');
  const int = v => { const n = Math.floor(+v); return n > 0 ? n : 0; };
  const fail = (error, extra) => Object.assign({ ok: false, error }, extra || {});
  /* cleanNumber / looseWho / cleanName do servidor */
  const cleanNumber = v => {
    if (typeof v === 'number') { if (!Number.isInteger(v) || v < 0) return null; v = String(v); } else if (typeof v !== 'string' || v.length > 64) return null;
    const s = v.trim(); if (s.length < 3 || s.length > 20 || !/^[0-9+\-.() ]+$/.test(s) || (s.match(/[0-9]/g) || []).length < 3) return null;
    return s;
  };
  const looseWho = v => { if (typeof v === 'number') return Number.isInteger(v) ? String(v) : null; if (typeof v !== 'string') return null; const s = v.trim(); return s && s.length <= 40 ? s : null; };
  const cleanName = v => {
    if (typeof v !== 'string' && typeof v !== 'number') return null;
    const s = [...String(v).slice(0, 400).replace(/\p{Cc}/gu, ' ').replace(/\p{Cf}/gu, '').replace(/\p{Zs}/gu, ' ').replace(/\s+/g, ' ').trim()].slice(0, 40).join('').trim();
    return s || null;
  };
  const find = id => { id = int(id); return id ? C().all().find(c => +c.id === id) || null : null; };
  const cmp = (a, b) => ((+a.joined || 0) - (+b.joined || 0)) || (a.member < b.member ? -1 : a.member > b.member ? 1 : 0);
  const rows = id => M().all().filter(x => +x.conversation_id === id && !x.left_at).sort(cmp);
  const memberRow = (id, who) => rows(id).find(x => x.member === who) || null;
  const groupsOf = who => M().all().filter(x => x.member === who && !x.left_at).length;
  const saveConv = c => { const all = C().all().filter(x => +x.id !== +c.id); all.push(c); C().set(all); };
  const metaOf = (id, who) => T('thread_meta').all().find(x => x.owner === who && x.app === 'sms' && x.other === 'g:' + id) || null;
  /* AUTO_INCREMENT: nunca reutiliza o id de um grupo apagado (as mensagens antigas desse id não podem aparecer no novo) */
  const nextId = () => [C().all().map(x => +x.id), M().all().map(x => +x.conversation_id), T('messages').all().map(x => +x.conversation_id)]
    .reduce((mx, l) => l.reduce((a, n) => (n > a ? n : a), mx), 0) + 1;
  /* media para foto do grupo: legível por mim (o media.get do mock do M3 aplica o MediaCanRead), completa e imagem */
  const imageOk = v => { const id = int(v); if (!id) return 0; let m = null; try { m = LocalDB.rpc('media.get', { id, i: 1 }); } catch (e) { m = null; } return m && !m.error && (m.kind === 'image' || /^image\//.test(String(m.mime || ''))) ? id : 0; };

  /* o buildInfo do servidor */
  const view = (c, who) => {
    const cs = T('contacts').all(), rs = rows(+c.id), mt = metaOf(+c.id, who), mine = rs.find(x => x.member === who);
    const out = { ok: true, id: +c.id, app: c.app || 'sms', title: c.title, createdBy: c.created_by, created: c.created, lastId: c.last_id || null,
      myRole: mine && mine.role === 'admin' ? 'admin' : 'member', me: who, max: MAX, memberCount: rs.length, pinned: !!(mt && mt.pinned),
      members: rs.map(x => { const m = { member: x.member, role: x.role === 'admin' ? 'admin' : 'member', joined: x.joined }; const k = cs.find(y => y.number === x.member); if (k && k.name) m.name = k.name; if (x.member === who) m.isMe = true; return m; }) };
    if (int(c.avatar)) out.avatar = int(c.avatar);
    if (mt && mt.muted_until) out.mutedUntil = mt.muted_until;
    return out;
  };
  /* systemMessage: grava a linha 'system' e manda o push 'message' (só chega a quem ainda é membro); o chamador grava o c */
  const system = (c, by, action, text, extra) => {
    const id = +c.id, t = Date.now(), payload = Object.assign({ action, by }, extra || {});
    const row = T('messages').insert({ app: 'sms', sender: by, receiver: 'g:' + id, type: 'system', content: [...text].slice(0, 255).join(''), payload, read: false, created: t, reply_to: null, conversation_id: id,
      delivered_at: null, read_at: null, edited_at: null, deleted_sender: 0, deleted_receiver: 0, deleted_all: null });
    c.last_id = row.id;
    if (memberRow(id, myNum())) setTimeout(() => Bridge.emit('message', { id: row.id, app: 'sms', sender: by, receiver: 'g:' + id, type: 'system', content: row.content, payload, read: false, created: t, conversation: id, group: { id, title: c.title, avatar: int(c.avatar) || null } }), 0);
  };
  /* GroupBroadcast('groupUpdate'): no browser o único jogador sou eu, por isso só se eu for membro */
  const announce = (id, data) => { if (memberRow(id, myNum())) setTimeout(() => Bridge.emit('groupUpdate', Object.assign({ id }, data)), 0); };
  /* access(): grupo existe → tenho número → sou membro ativo (senão notfound, como o servidor) → (admin) */
  const access = (d, needAdmin) => {
    const id = int(d.id), c = id && find(id); if (!c || (c.app || 'sms') !== 'sms') return { err: fail('notfound') };
    const who = myNum(); if (!who) return { err: fail('noidentity') };
    const mine = memberRow(id, who); if (!mine) return { err: fail('notfound') };
    if (needAdmin && mine.role !== 'admin') return { err: fail('notadmin') };
    return { c, id, who, mine };
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
  const setRow = (id, who, patch) => { const all = M().all(), x = all.find(y => +y.conversation_id === id && y.member === who && !y.left_at); if (x) Object.assign(x, patch); M().set(all); return x; };

  /* leaveLocked do servidor */
  const leave = a => {
    const id = a.id;
    setRow(id, a.who, { left_at: Date.now(), role: 'member' });
    T('thread_meta').remove(m => m.owner === a.who && m.app === 'sms' && m.other === 'g:' + id);
    const rest = rows(id);
    if (!rest.length) {
      /* grupo sem ninguém: sai com as mensagens (e as reações delas), como o deleteGroup */
      const ids = new Set(T('messages').all().filter(m => +m.conversation_id === id).map(m => m.id));
      T('message_reactions').remove(r => ids.has(r.message_id));
      T('messages').remove(m => +m.conversation_id === id);
      T('thread_meta').remove(m => m.app === 'sms' && m.other === 'g:' + id);
      M().remove(m => +m.conversation_id === id);
      C().remove(c => +c.id === id);
      return { ok: true, id, deleted: true };
    }
    let admin = null;
    if (!rest.some(y => y.role === 'admin')) { admin = rest[0].member; setRow(id, admin, { role: 'admin' }); }
    system(a.c, a.who, 'leave', `${a.who} saiu do grupo`, admin ? { admin } : null);
    if (admin) system(a.c, admin, 'admin', `${admin} passou a ser administrador`, { targets: [admin], auto: true });
    saveConv(a.c);
    announce(id, { action: 'leave', by: a.who, admin });
    const out = { ok: true, id, deleted: false }; if (admin) out.admin = admin; return out;
  };

  LocalDB.register('groups.create', d => {
    const who = myNum(); if (!who) return fail('noidentity');
    const name = cleanName(d.name); if (!name) return fail('name');
    const l = cleanList(d.members, who); if (l.err) return l.err;
    if (!l.nums.length) return fail('members');
    if (l.nums.length + 1 > MAX) return fail('toomany', { max: MAX });
    const clear = d.avatar == null || d.avatar === false || d.avatar === 0 || d.avatar === '';
    let avatar = null; if (!clear) { avatar = imageOk(d.avatar); if (!avatar) return fail('media'); }
    if (groupsOf(who) >= MAX_GROUPS) return fail('limit', { max: MAX_GROUPS });
    const skipped = l.nums.filter(n => groupsOf(n) >= MAX_GROUPS), final = l.nums.filter(n => !skipped.includes(n));
    if (!final.length) return fail('members', { skipped });
    const t = Date.now(), id = nextId();
    const c = { id, app: 'sms', title: name, avatar, created_by: who, created: t, last_id: null };
    saveConv(c);
    M().set(M().all().filter(x => +x.conversation_id !== id).concat([{ conversation_id: id, member: who, role: 'admin', joined: t, last_read_id: null, left_at: null }],
      final.map(n => ({ conversation_id: id, member: n, role: 'member', joined: t, last_read_id: null, left_at: null }))));
    system(c, who, 'create', `${who} criou o grupo «${name}»`, { title: name, targets: final });
    saveConv(c);
    announce(id, { action: 'create', by: who, title: name });
    const out = view(c, who); if (skipped.length) out.skipped = skipped; return out;
  });
  LocalDB.register('groups.info', d => { if (!int(d.id)) return fail('invalid'); const a = access(d); return a.err || view(a.c, a.who); });
  LocalDB.register('groups.list', () => {
    const who = myNum(); if (!who) return [];
    const msgs = T('messages').all();
    return C().all().filter(c => (c.app || 'sms') === 'sms' && memberRow(+c.id, who)).map(c => {
      const id = +c.id, rs = rows(id), mine = rs.find(x => x.member === who), mt = metaOf(id, who), lastRead = int(mine.last_read_id);
      const it = { id, title: c.title, avatar: int(c.avatar) || null, created: c.created, ts: c.created, role: mine.role === 'admin' ? 'admin' : 'member', lastId: c.last_id || null, lastReadId: lastRead,
        members: rs.map(x => ({ member: x.member, role: x.role === 'admin' ? 'admin' : 'member' })), memberCount: rs.length, pinned: !!(mt && mt.pinned),
        unread: msgs.filter(m => +m.conversation_id === id && m.id > lastRead && m.sender !== who && m.type !== 'system' && !m.deleted_all).length };
      if (mt && mt.muted_until) it.mutedUntil = mt.muted_until;
      return it;
    }).sort((a, b) => b.ts - a.ts);
  });
  LocalDB.register('groups.rename', d => {
    if (!int(d.id)) return fail('invalid');
    const name = cleanName(d.name); if (!name) return fail('name');
    const a = access(d, true); if (a.err) return a.err;
    if (a.c.title !== name) { a.c.title = name; system(a.c, a.who, 'rename', `${a.who} mudou o nome do grupo para «${name}»`, { title: name }); saveConv(a.c); announce(a.id, { action: 'rename', by: a.who, title: name }); }
    return view(a.c, a.who);
  });
  LocalDB.register('groups.setAvatar', d => {
    if (!int(d.id)) return fail('invalid');
    const clear = d.mediaId == null || d.mediaId === false || d.mediaId === 0 || d.mediaId === '';
    const wanted = clear ? 0 : int(d.mediaId); if (!clear && !wanted) return fail('media');
    const a = access(d, true); if (a.err) return a.err;
    if (wanted && !imageOk(wanted)) return fail('media');
    if (int(a.c.avatar) !== wanted) {
      a.c.avatar = wanted || null;
      system(a.c, a.who, 'avatar', wanted ? `${a.who} mudou a imagem do grupo` : `${a.who} removeu a imagem do grupo`, { avatar: wanted || null });
      saveConv(a.c); announce(a.id, { action: 'avatar', by: a.who, avatar: wanted || null });
    }
    return view(a.c, a.who);
  });
  LocalDB.register('groups.add', d => {
    if (!int(d.id)) return fail('invalid');
    const raw = d.numbers == null && d.number != null ? [d.number] : d.numbers;   /* { id, number } também serve */
    const a = access(d, true); if (a.err) return a.err;
    const l = cleanList(raw, a.who); if (l.err) return l.err;
    if (!l.nums.length) return fail('members');
    const cur = rows(a.id).map(x => x.member), fresh = l.nums.filter(n => !cur.includes(n)), already = l.nums.filter(n => cur.includes(n));
    if (!fresh.length) return Object.assign(view(a.c, a.who), { added: [], already });   /* idempotente */
    if (cur.length + fresh.length > MAX) return fail('toomany', { max: MAX });
    const skipped = fresh.filter(n => groupsOf(n) >= MAX_GROUPS), final = fresh.filter(n => !skipped.includes(n));
    if (!final.length) return fail('members', { skipped });
    const t = Date.now(), all = M().all();
    final.forEach(n => {
      const old = all.find(x => +x.conversation_id === a.id && x.member === n);   /* quem já saiu volta a entrar na mesma linha (chave primária conversation_id+member) */
      const row = { role: 'member', joined: t, left_at: null, last_read_id: a.c.last_id || 0 };
      if (old) Object.assign(old, row); else all.push(Object.assign({ conversation_id: a.id, member: n }, row));
    });
    M().set(all);
    system(a.c, a.who, 'add', `${a.who} adicionou ${final.join(', ')}`, { targets: final });
    saveConv(a.c); announce(a.id, { action: 'add', by: a.who, targets: final });
    const out = view(a.c, a.who); out.added = final; if (skipped.length) out.skipped = skipped; if (already.length) out.already = already; return out;
  });
  LocalDB.register('groups.remove', d => {
    if (!int(d.id)) return fail('invalid');
    const target = looseWho(d.number); if (!target) return fail('invalid');
    const a = access(d); if (a.err) return a.err;
    if (target === a.who) return leave(a);   /* remover-se a si próprio = sair */
    if (a.mine.role !== 'admin') return fail('notadmin');
    if (!memberRow(a.id, target)) return fail('notmember');
    setRow(a.id, target, { left_at: Date.now(), role: 'member' });
    T('thread_meta').remove(m => m.owner === target && m.app === 'sms' && m.other === 'g:' + a.id);
    system(a.c, a.who, 'remove', `${a.who} removeu ${target}`, { targets: [target] });
    saveConv(a.c); announce(a.id, { action: 'remove', by: a.who, targets: [target] });
    return view(a.c, a.who);
  });
  LocalDB.register('groups.role', d => {
    if (!int(d.id)) return fail('invalid');
    const target = looseWho(d.number), role = d.role;
    if (!target || (role !== 'admin' && role !== 'member')) return fail('invalid');
    const a = access(d, true); if (a.err) return a.err;
    const tr = memberRow(a.id, target); if (!tr) return fail('notmember');
    if (tr.role !== role) {
      if (role === 'member' && rows(a.id).filter(x => x.role === 'admin').length <= 1) return fail('lastadmin');   /* o grupo nunca fica sem administrador */
      setRow(a.id, target, { role });
      const text = role === 'admin' ? `${a.who} nomeou ${target} administrador` : target === a.who ? `${a.who} deixou de ser administrador` : `${a.who} retirou a administração a ${target}`;
      system(a.c, a.who, 'role', text, { targets: [target], role });
      saveConv(a.c); announce(a.id, { action: 'role', by: a.who, targets: [target], role });
    }
    return view(a.c, a.who);
  });
  LocalDB.register('groups.leave', d => { if (!int(d.id)) return fail('invalid'); const a = access(d); return a.err || leave(a); });
})();
