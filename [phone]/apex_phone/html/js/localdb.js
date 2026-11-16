/* ============================================================
   LOCALDB + MOCK - fallback para o browser (sem FiveM).
   Implementa os mesmos RPCs do servidor sobre localStorage, para a
   UI e o harness de testes funcionarem fora do jogo.
   ============================================================ */
window.LocalDB = (() => {
  /* A "base de dados" do mock vive na RAIZ do Store (Store.global), não no espaço da personagem:
     no jogo o servidor é um só para todas as personagens. As tabelas continuam a ter owner
     'DEV0000' (o mock não separa linhas por personagem); a CONTA é que é por citizenid. */
  const G = Store.global || Store;
  const T = name => ({
    all: () => G.get('db:' + name, []),
    set: rows => G.set('db:' + name, rows),
    insert(row) { const rows = this.all(); row.id = row.id || uid(); rows.push(row); this.set(rows); return row; },
    update(id, patch) { const rows = this.all(); const r = rows.find(x => x.id === id); if (r) Object.assign(r, patch); this.set(rows); return r; },
    remove(pred) { const rows = this.all().filter(r => typeof pred === 'function' ? !pred(r) : r.id !== pred); this.set(rows); }
  });
  let seq = 0;
  const uid = () => Date.now() * 100 + (seq = (seq + 1) % 100);
  const now = () => Date.now();
  /* personagem "com sessão" no browser: DEV0000 por omissão; LocalDB.switchCharacter(cid) simula o
     multicharacter (troca e envia o push `session`, como o client.lua faz no jogo) */
  const cid = () => String(G.get('mock:cid', 'DEV0000') || 'DEV0000');
  const accKey = () => cid() === 'DEV0000' ? 'account' : 'account:' + cid();   /* 'account' = a chave que os harness semeiam */
  const acc = () => G.get(accKey(), null);
  const saveAcc = a => G.set(accKey(), a);
  const me = () => ({ citizenid: cid(), number: (acc() || {}).phone || player().phone || '555-0142', username: (acc() || {}).username || 'eu' });
  const numFor = c => '555-' + String(1000 + [...String(c)].reduce((h, ch) => (h * 31 + ch.charCodeAt(0)) % 9000, 7));
  const player = () => { const p = Store.get('player', null); if (p && (!p.citizenid || p.citizenid === cid())) return p;
    return cid() === 'DEV0000' ? { firstname: 'Jogador', lastname: 'Teste', phone: '555-0142', money: { cash: 350, bank: 12840 }, job: { name: 'unemployed', label: 'Desempregado' }, citizenid: 'DEV0000' }
      : { firstname: 'Personagem', lastname: cid(), phone: numFor(cid()), money: { cash: 100, bank: 2500 }, job: { name: 'unemployed', label: 'Desempregado' }, citizenid: cid() }; };
  /* conta como o servidor a devolve desde a Fase 1: SEM o pin, com hasPin e pinLen (0/4/6) */
  const pubAcc = a => { if (!a) return null; const o = Object.assign({ avatarPhoto: null }, a); const pin = String(a.pin == null ? '' : a.pin); delete o.pin; o.hasPin = pin.length > 0; o.pinLen = !pin.length ? 0 : pin.length === 6 ? 6 : 4; return o; };
  /* Config.PinLock do mock: 5 tentativas; bloqueios escalados 30 s → 60 s → 5 min → 15 min (só em memória, como no servidor) */
  const PIN_LOCK = { attempts: 5, seconds: [30, 60, 300, 900] };
  const pinTry = {};   /* cid → { fails, until } */
  /* A MESMA conta do pinFail do server/main.lua: os erros acumulam até acertar; ao 5.º bloqueia 30 s e,
     passado o bloqueio, CADA erro seguinte volta a bloquear logo com o degrau seguinte (60 s, 5 min, 15 min).
     Devolve { attempts (que restam), lockedUntil (ms), wait (s) } - o `wait` é o que o servidor também manda. */
  const pinFail = k => { const st = pinTry[k] = pinTry[k] || { fails: 0, until: 0 }; st.fails++;
    if (st.fails < PIN_LOCK.attempts) return { attempts: PIN_LOCK.attempts - st.fails };
    const wait = PIN_LOCK.seconds[Math.min(st.fails - PIN_LOCK.attempts, PIN_LOCK.seconds.length - 1)];
    st.until = now() + wait * 1000; return { attempts: 0, lockedUntil: st.until, wait }; };
  const pinLocked = k => { const st = pinTry[k]; const t = now(); return st && st.until > t ? { attempts: 0, lockedUntil: st.until, wait: Math.ceil((st.until - t) / 1000) } : null; };
  const savePlayer = p => Store.set('player', p);
  const rnd = n => Math.floor(Math.random() * n);
  const genNumber = () => '555-' + String(1000 + rnd(9000));

  /* ---------- Seeds ---------- */
  const FAKE = [
    { username: 'vinewood_star', bio: 'Atriz · Vinewood ✨', avatar: 3 }, { username: 'lspd_official', bio: 'Los Santos Police Department', avatar: 7 },
    { username: 'benny_garage', bio: 'Tuning & motores 🔧', avatar: 11 }, { username: 'weazel_news', bio: 'Notícias 24/7', avatar: 5 }, { username: 'maria_ls', bio: 'Fotografia · Del Perro', avatar: 9 }
  ];
  function seedOnce() {
    if (G.get('db:seeded', false)) return;
    const t = now();
    T('contacts').set([['Mãe', '555-0101', true], ['Garagem Central', '555-0177', true], ['Fleeca Bank', '555-0200', false], ['Hospital Pillbox', '555-0911', false], ['LSPD', '555-0100', false], ['Rui Taxista', '555-0303', true], ['Ana Advogada', '555-0420', false], ['Oficina Benny', '555-0666', false]]
      .map(([name, number, fav], i) => ({ id: i + 1, owner: 'DEV0000', name, number, favorite: fav, avatar: null })));
    const my = '555-0142';
    T('messages').set([
      { id: 1, app: 'sms', sender: '555-0101', receiver: my, type: 'text', content: 'Já jantaste? Liga-me quando puderes ❤️', payload: null, read: false, created: t - 36e5 },
      { id: 2, app: 'sms', sender: my, receiver: '555-0177', type: 'text', content: 'O carro já está pronto?', payload: null, read: true, created: t - 5 * 36e5 },
      { id: 3, app: 'sms', sender: '555-0177', receiver: my, type: 'text', content: 'Fica pronto amanhã às 10h. Fica em 1.250 €.', payload: null, read: true, created: t - 4.5 * 36e5 },
      { id: 4, app: 'sms', sender: '555-0199', receiver: my, type: 'text', content: 'Tenho o teu telemóvel. Encontramo-nos no cais às 22h.', payload: null, read: false, created: t - 864e5 }
    ]);
    T('calls').set([{ id: 1, owner: 'DEV0000', number: '555-0101', name: 'Mãe', outgoing: false, answered: true, duration: 184, created: t - 2 * 36e5 }, { id: 2, owner: 'DEV0000', number: '555-0177', name: 'Garagem Central', outgoing: true, answered: true, duration: 45, created: t - 864e5 }, { id: 3, owner: 'DEV0000', number: '555-0199', name: null, outgoing: false, answered: false, duration: 0, created: t - 2 * 864e5 }]);
    T('photos').set(Array.from({ length: 12 }, (_, i) => ({ id: i + 1, owner: 'DEV0000', url: null, seed: i * 7 + 3, favorite: i % 5 === 0, created: t - i * 5 * 36e5 })));
    T('mail').set([
      { id: 1, owner: 'DEV0000', sender: 'Fleeca Bank', email: 'noreply@fleeca.ls', subject: 'Extrato mensal disponível', body: 'Olá,\n\nO extrato da sua conta já está disponível na app Wallet.\n\nFleeca Bank', read: false, folder: 'inbox', created: t - 2 * 36e5 },
      { id: 2, owner: 'DEV0000', sender: 'Garagem Central', email: 'geral@garagemcentral.ls', subject: 'Fatura #4471: Revisão', body: 'Bom dia,\n\nSegue a fatura da revisão do veículo. Total: 1.250 €.\n\nGaragem Central', read: false, folder: 'inbox', created: t - 6 * 36e5 },
      { id: 3, owner: 'DEV0000', sender: 'Câmara de Los Santos', email: 'servicos@cidade.ls', subject: 'Renovação da carta de condução', body: 'A sua carta expira em 30 dias. Dirija-se ao DMV.', read: true, folder: 'inbox', created: t - 864e5 },
      { id: 4, owner: 'DEV0000', sender: 'LSPD', email: 'contact@lspd.ls', subject: 'Notificação de multa', body: 'Infração de velocidade na Route 68.\n\nValor: 350 €\nPrazo: 7 dias.', read: true, folder: 'inbox', created: t - 3 * 864e5 }
    ]);
    T('bills').set([{ id: 1, owner: 'DEV0000', sender: 'garage', sender_name: 'Garagem Central', amount: 1250, reason: 'Revisão + pneus', status: 'pending', created: t - 6 * 36e5 }, { id: 2, owner: 'DEV0000', sender: 'lspd', sender_name: 'LSPD', amount: 350, reason: 'Excesso de velocidade', status: 'pending', created: t - 3 * 864e5 }, { id: 3, owner: 'DEV0000', sender: 'city', sender_name: 'Câmara Municipal', amount: 90, reason: 'Taxa de estacionamento', status: 'paid', created: t - 9 * 864e5 }]);
    T('transactions').set([{ id: 1, owner: 'DEV0000', description: 'Salário', amount: 2400, created: t - 3 * 864e5 }, { id: 2, owner: 'DEV0000', description: 'Cluckin\' Bell', amount: -18.5, created: t - 4 * 864e5 }, { id: 3, owner: 'DEV0000', description: 'Transferência de Mãe', amount: 200, created: t - 6 * 864e5 }, { id: 4, owner: 'DEV0000', description: 'Taxa de estacionamento', amount: -90, created: t - 9 * 864e5 }]);
    T('social_accounts').set(FAKE.flatMap(u => ['instashot', 'twix', 'reels'].map(app => ({ id: uid(), app, owner: 'npc:' + u.username, username: u.username, bio: u.bio, avatar: u.avatar, created: t - 30 * 864e5 }))));
    const P = [];
    const cap = ['Noite em Vinewood 🌆', 'Novo motor pronto 🔧 #tuning', 'Pôr do sol em Del Perro', 'Patrulha noturna. Fiquem seguros. #LSPD', 'Assalto no Fleeca, mais em breve #weazel', 'Café da manhã ☕', 'Route 68 ao entardecer', 'Estreia hoje! 🎬 #vinewood'];
    for (let i = 0; i < 16; i++) { const u = FAKE[i % FAKE.length]; P.push({ id: uid() + i, app: i % 3 === 0 ? 'twix' : i % 3 === 1 ? 'instashot' : 'reels', author: u.username, content: cap[i % cap.length], image: (i % 3 === 0 && i % 2) ? null : 40 + i * 13, reply_to: null, repost_of: null, created: t - i * 3 * 36e5 }); }
    T('posts').set(P);
    T('likes').set(P.slice(0, 8).map(p => ({ id: uid(), post_id: p.id, username: FAKE[rnd(5)].username })));
    T('comments').set([{ id: uid(), post_id: P[1].id, username: 'maria_ls', content: 'Que foto! 😍', created: t - 3e5 }, { id: uid(), post_id: P[1].id, username: 'benny_garage', content: 'Passa na oficina 👊', created: t - 2e5 }]);
    T('follows').set([{ id: uid(), app: 'instashot', follower: 'eu', followed: 'vinewood_star' }, { id: uid(), app: 'twix', follower: 'eu', followed: 'weazel_news' }]);
    T('darkchat').set([{ id: 1, room: 'geral', username: 'sombra_42', content: 'Alguém tem contacto no cais?', image: null, created: t - 36e5 }, { id: 2, room: 'geral', username: 'corvo', content: 'Fala com o Rui. Discreto.', image: null, created: t - 35e5 }, { id: 3, room: 'trocas', username: 'anon_991', content: 'Vendo peças. Sem perguntas.', image: null, created: t - 8e5 }]);
    T('services').set([]);
    G.set('db:seeded', true);
  }

  /* ---------- helpers sociais ---------- */
  const soc = {
    myName: app => { const a = T('social_accounts').all().find(x => x.app === app && x.owner === 'DEV0000'); return a ? a.username : null; },
    user: (app, username) => T('social_accounts').all().find(x => x.app === app && x.username === username),
    enrich(app, posts) {
      const likes = T('likes').all(), cm = T('comments').all(), my = soc.myName(app), all = T('posts').all(), sv = T('saves').all().filter(x => x.app === app && x.username === my);
      /* como o servidor (postMedia em social.lua): uma fotografia a sério não vem na lista - só o
         tamanho - e desce pelo social.post.media. Assim o browser exercita o mesmo caminho do jogo. */
      const slim = p => { if (typeof p.image === 'string' && p.image.length > 4096) { p.imageLen = p.image.length; p.chunk = 48000; p.image = null; } return p; };
      /* como o enrich do servidor: as respostas contam como comentários, os originais dos reposts levam os mesmos contadores, e `myRepost` é a minha linha de repost simples */
      const meta = p => { const u = soc.user(app, p.author) || {}, mine = my ? all.find(x => x.repost_of === p.id && x.author === my && !(x.content || '').trim()) : null;
        return { avatar: u.avatar, avatarUrl: u.avatar_url || null, name: u.name || null, likes: likes.filter(l => l.post_id === p.id).length, liked: !!likes.find(l => l.post_id === p.id && l.username === my), comments: cm.filter(c => c.post_id === p.id).length + all.filter(x => x.reply_to === p.id).length,
          reposts: all.filter(x => x.repost_of === p.id).length, saved: !!sv.find(s => s.post_id === p.id), reposted: !!mine, myRepost: mine ? mine.id : null }; };
      return posts.map(p => { const orig = p.repost_of ? all.find(x => x.id === p.repost_of) : null;
        return slim(Object.assign({}, p, meta(p), { original: orig ? slim(Object.assign({}, orig, meta(orig))) : null })); });
    }
  };
  let gps = null;

  /* ---------- RPCs ---------- */
  const R = {
    'account.get': () => pubAcc(acc()),
    /* pin '' = "Sem código" (o servidor faz tostring(d.pin or Config.DefaultPin): só o nil cai no código por omissão)
       Como o servidor: uma conta desta personagem que já exista NUNCA é reescrita → { error: 'exists' } (o assistente recarrega-a).
       No mock o código fica em texto (só o servidor guarda o hash; a forma pública da conta é a mesma). */
    'account.create': d => { const cur = acc(); if (cur && cur.username) return { error: 'exists' };
      const p = player(); const pin = d.pin == null ? '1225' : String(d.pin); if (pin && !/^(\d{4}|\d{6})$/.test(pin)) return { error: 'badpin' };
      const a = { citizenid: cid(), account_id: 'RK-' + String(100000 + rnd(900000)), username: d.username || 'user', phone: p.phone || genNumber(), pin, avatar: d.avatar || 1,
        device_id: 'IP18PM-' + String(rnd(1e6)).padStart(6, '0'), sim_id: 'SIM-' + String(rnd(1e8)).padStart(8, '0'), created: now(), settings: d.settings || null, layout: null, face: d.face || null };
      saveAcc(a); delete pinTry[cid()]; T('mail').insert({ owner: 'DEV0000', sender: 'Apex Mobile', email: 'hello@apex.ls', subject: 'Bem-vindo ao Apex Mobile', body: 'Olá ' + a.username + '!\n\nA tua conta está ativa. O teu número é ' + a.phone + '.\n\nApex Mobile', read: false, folder: 'inbox', created: now() }); return pubAcc(a); },
    'account.update': d => { const a = acc(); if (!a) return { error: 'noacc' }; ['username', 'avatar', 'settings', 'layout'].forEach(k => { if (d[k] !== undefined) a[k] = d[k]; }); saveAcc(a); return { ok: true }; },
    /* { old, new } → { ok, error? }. new '' DESATIVA o código; sem código atual o `old` é ignorado.
       Um `old` errado conta como tentativa falhada (senão o setPin era um verifyPin sem limite). */
    'account.setPin': d => { const a = acc(); if (!a) return { ok: false, error: 'noacc' };
      const k = cid(), curPin = String(a.pin == null ? '' : a.pin);
      /* pela ordem do servidor: bloqueado → nem compara; old errado → conta no mesmo contador do verifyPin */
      if (curPin) { const lk = pinLocked(k); if (lk) return Object.assign({ ok: false, error: 'locked' }, lk);
        if (String(d.old == null ? '' : d.old).slice(0, 10) !== curPin) { const f = pinFail(k); return Object.assign({ ok: false, error: f.lockedUntil ? 'locked' : 'badpin' }, f); }
        delete pinTry[k]; }
      /* sem `new` é inválido (como no servidor) - não pode ser lido como '' e desativar o código por engano */
      if (d.new == null) return { ok: false, error: 'invalid' };
      const nw = String(d.new).slice(0, 10); if (nw && !/^(\d{4}|\d{6})$/.test(nw)) return { ok: false, error: 'invalid' };
      a.pin = nw; saveAcc(a); return { ok: true, hasPin: !!nw, pinLen: !nw ? 0 : nw.length === 6 ? 6 : 4 }; },
    /* Face Key: fotografia de referência da cara (coluna própria, fora das definições) */
    'account.setFace': d => { const a = acc(); if (!a) return { ok: false }; const f = typeof d.face === 'string' && d.face ? d.face : null; if (f && (f.length > 120000 || !/^data:image\//.test(f))) return { ok: false, error: 'badimage' }; a.face = f; saveAcc(a); return { ok: true, has: !!f }; },
    /* Foto da conta (§10.3): { photo } data URL ≤ 120 000 ou '' para apagar - os mesmos limites do servidor; o account.get devolve-a em avatarPhoto */
    'account.setAvatarPhoto': d => { const a = acc(); if (!a) return { ok: false }; const ph = typeof d.photo === 'string' && d.photo ? d.photo : null; if (ph && (ph.length > 120000 || !/^data:image\//.test(ph))) return { ok: false, error: 'badimage' }; a.avatarPhoto = ph; saveAcc(a); return { ok: true, has: !!ph }; },
    /* { pin } → { ok, attempts?, lockedUntil? } - `attempts` = tentativas QUE AINDA RESTAM antes do
       bloqueio; `lockedUntil` = epoch em ms (Date.now()) até quando nem se compara o código */
    'account.verifyPin': d => { const a = acc(); if (!a) return { ok: false, error: 'noacc' };
      const k = cid(), pin = String(a.pin == null ? '' : a.pin);
      if (!pin) return { ok: true };                                   /* sem código não há nada a verificar (nem bloqueio) */
      const lk = pinLocked(k); if (lk) return Object.assign({ ok: false }, lk);
      if (String(d.pin == null ? '' : d.pin).slice(0, 10) === pin) { delete pinTry[k]; return { ok: true }; }
      return Object.assign({ ok: false }, pinFail(k)); },
    /* como o ResetAccount do servidor: a conta desta personagem e as linhas dela (no mock, todas as tabelas) */
    'account.reset': () => { G.remove(accKey()); delete pinTry[cid()]; Object.keys(localStorage).filter(k => k.startsWith('apexphone:db:')).forEach(k => { G.remove(k.slice('apexphone:'.length)); }); return { ok: true }; },
    'account.swapSim': () => { const a = acc(); a.phone = genNumber(); a.sim_id = 'SIM-' + String(rnd(1e8)).padStart(8, '0'); saveAcc(a); const p = player(); p.phone = a.phone; savePlayer(p); return { phone: a.phone, sim_id: a.sim_id }; },
    'account.usernameFree': d => ({ ok: !['admin', 'root'].includes((d.username || '').toLowerCase()) }),

    /* Fase 2: contacts.list/add/update são do phone.js (M5), messages.threads/get/send/read/delete do messages.js (M3)
       e mail.* do mail.js (M6) - um só mock por RPC, com a forma do servidor. Os que estavam aqui eram as versões
       antigas e eram substituídos ao carregar essas apps (quem lia este ficheiro via um contrato que já não existe). */
    'contacts.remove': d => { T('contacts').remove(d.id); return { ok: true }; },

    /* { q } → [{ id, app, number, content, created }] - só SMS 1:1 do próprio (enviadas ou recebidas), máx. 20, mais recentes primeiro.
       `number` é o OUTRO lado da conversa (é o que a pesquisa global precisa para abrir a conversa). Como o servidor (Fase 2):
       sem mensagens de grupo, sem as apagadas para todos e sem as escondidas para mim. */
    'messages.search': d => { const q = String(d.q == null ? '' : d.q).trim().toLowerCase().slice(0, 64); if (q.length < 2) return []; const my = me().number;
      return T('messages').all().filter(m => m.app === 'sms' && !m.conversation_id && !m.deleted_all && (m.sender === my || m.receiver === my) && !(m.sender === my && m.deleted_sender) && !(m.receiver === my && m.sender !== my && m.deleted_receiver)
          && (m.type || 'text') === 'text' && String(m.content || '').toLowerCase().includes(q))
        .sort((a, b) => b.created - a.created).slice(0, 20).map(m => ({ id: m.id, app: m.app, number: m.sender === my ? m.receiver : m.sender, content: m.content, created: m.created })); },

    'calls.history': () => T('calls').all().sort((a, b) => b.created - a.created),
    'calls.clear': () => { T('calls').set([]); return { ok: true }; },
    'calls.start': d => { const id = uid(); const name = (T('contacts').all().find(c => c.number === d.number) || {}).name || null;
      setTimeout(() => Bridge.emit('callState', { callId: id, state: d.number.endsWith('0') ? 'declined' : 'active' }), 2500 + rnd(1500)); return { callId: id, status: 'ringing', name }; },
    'calls.accept': d => ({ ok: true }), 'calls.decline': d => ({ ok: true }),
    /* { callId, on } → { ok }. No servidor o outro participante recebe o push `callMute { src, on }`;
       no browser não há outro lado, fica só o estado para quem o quiser consultar. */
    'calls.mute': d => { const id = +d.callId; if (!id) return { ok: false, error: 'badcall' }; G.update('mock:muted', {}, m => { if (d.on) m[id] = true; else delete m[id]; }); return { ok: true }; },

    /* ---------- NOTIFICAÇÕES PERSISTENTES (tabela apex_phone_notifications) ----------
       Formato de cada item igual ao do servidor: { id, app, title, msg, data, icon, image, read, created, actions?, type?, duration? }.
       As linhas entram por LocalDB.notify(...), que faz o papel do NotifyPlayer do servidor (grava e envia o push). */
    /* igual ao servidor: limite por omissão 30 (máx. 100), msg '' quando não há corpo, e `before` é um id -
       ou uma data em ms quando passa de 1e11 (um id nunca lá chega) */
    'notifs.list': d => { const lim = Math.max(1, Math.min(100, Math.floor(+d.limit || 30))); const before = +d.before || 0;
      const rows = T('notifications').all().filter(n => n.owner === cid() && (!before || (before >= 1e11 ? n.created < before : n.id < before))).sort((a, b) => b.id - a.id);
      return { items: rows.slice(0, lim).map(n => { const it = { id: n.id, app: n.app, title: n.title, msg: n.msg == null ? '' : n.msg, data: n.data == null ? null : n.data, icon: n.icon || null, image: n.image || null, read: !!n.read, created: n.created };
        /* como o servidor: botões, tipo e duração gravados só aparecem quando existem */
        if (Array.isArray(n.actions) && n.actions.length) it.actions = n.actions; if (n.type) it.type = n.type; if (n.duration > 0) it.duration = n.duration; return it; }), more: rows.length > lim }; },
    'notifs.read': d => { const ids = Array.isArray(d.ids) ? d.ids.map(Number).filter(Boolean).slice(0, 200) : null;
      if (!d.all && !(ids && ids.length)) return { ok: false, error: 'invalid' };
      const rows = T('notifications').all(); rows.forEach(n => { if (n.owner !== cid()) return; if (d.all ? (!d.app || n.app === String(d.app)) : ids.includes(n.id)) n.read = true; }); T('notifications').set(rows); return { ok: true }; },
    'notifs.remove': d => { const ids = Array.isArray(d.ids) ? d.ids.map(Number).filter(Boolean).slice(0, 200) : []; if (!ids.length) return { ok: false, error: 'invalid' }; T('notifications').remove(n => n.owner === cid() && ids.includes(n.id)); return { ok: true }; },
    'notifs.clear': d => { T('notifications').remove(n => n.owner === cid() && (!d.app || n.app === String(d.app))); return { ok: true }; },
    /* no servidor disparam apex_phone:notificationOpened / apex_phone:notificationAction; aqui ficam registados para o harness os poder ver.
       Como no servidor: o open NÃO marca como lida (o Notify manda o notifs.read à parte) e a ação tem de ser uma das
       gravadas com a notificação - texto vazio → 'invalid', id que não existe → 'notfound', ação que não está lá → 'invalid'. */
    'notifs.open': d => { const n = T('notifications').all().find(x => x.id === +d.id && x.owner === cid()); if (!n) return { ok: false, error: 'notfound' }; G.update('mock:notifEvents', [], l => { l.push({ type: 'opened', id: n.id, app: n.app, data: n.data, t: now() }); if (l.length > 50) l.shift(); }); return { ok: true }; },
    'notifs.action': d => { const act = typeof d.action === 'string' || typeof d.action === 'number' ? String(d.action).slice(0, 32) : ''; if (!act) return { ok: false, error: 'invalid' };
      const n = T('notifications').all().find(x => x.id === +d.id && x.owner === cid()); if (!n) return { ok: false, error: 'notfound' };
      if (!(Array.isArray(n.actions) && n.actions.some(a => a && String(a.id) === act))) return { ok: false, error: 'invalid' };
      G.update('mock:notifEvents', [], l => { l.push({ type: 'action', id: n.id, action: act, data: n.data, t: now() }); if (l.length > 50) l.shift(); }); return { ok: true }; },
    'calls.end': d => { T('calls').insert({ owner: 'DEV0000', number: d.number, name: (T('contacts').all().find(c => c.number === d.number) || {}).name || null, outgoing: d.outgoing !== false, answered: !!d.answered, duration: d.duration || 0, created: now(),
      /* coluna status do servidor (answered | missed | declined | busy | cancelled | offline): a lista de Recentes usa-a */
      status: d.answered ? 'answered' : d.outgoing !== false ? 'cancelled' : 'missed' }); return { ok: true }; },

    /* Espelha o servidor: a lista NÃO leva os base64 (só a ficha + o tamanho), senão eram
       megabytes num único evento. Sem isto o harness nunca exercitava o download aos bocados -
       e era exatamente aí que as miniaturas ficavam cinzentas. */
    'photos.list': () => T('photos').all().sort((a, b) => b.created - a.created).map(p => {
      const isData = typeof p.url === 'string' && p.url.slice(0, 5) === 'data:';
      /* como o servidor: a capa de um vídeo NÃO vem na lista (photos.poster), só se diz se existe */
      return Object.assign({}, p, { url: isData ? null : (p.url || null), len: typeof p.url === 'string' ? p.url.length : 0, poster: undefined, hasPoster: !!p.poster });
    }),
    'photos.poster': d => { const row = T('photos').all().find(p => p.id === +d.id); return row ? { id: row.id, poster: row.poster || null } : { error: 'notfound' }; },
    /* Um pedaço do base64 de UMA foto (i começa em 1) - igual ao RPC photos.data do servidor */
    'photos.data': d => {
      const id = +d.id, i = +d.i || 1;
      if (!id || i < 1 || i > 64) return { error: 'badchunk' };
      const row = T('photos').all().find(p => p.id === id);
      if (!row) return { error: 'notfound' };
      const url = typeof row.url === 'string' ? row.url : '';
      if (!url.length) return { i, total: 0, len: 0, data: '' };
      const CH = 48000;
      return { i, total: Math.ceil(url.length / CH), len: url.length, data: url.slice((i - 1) * CH, i * CH) };
    },
    'photos.add': d => T('photos').insert({ owner: 'DEV0000', url: d.url || null, seed: d.seed || rnd(900), favorite: false, video: !!d.video, duration: d.duration || null, poster: (d.video && typeof d.poster === 'string') ? d.poster : null, created: now() }),
    /* envio aos bocados (o mesmo protocolo do servidor: server/photos.lua) - no browser serve para
       o harness poder exercitar exatamente o caminho que o jogo usa para as fotos grandes */
    'photos.upload': (d => { const buf = {}; return d => {
      const i = +d.i || 0, total = +d.total || 0;
      if (total < 1 || total > 64 || i < 1 || i > total) return { error: 'badchunk' };
      if ((d.data || '').length > 64000) return { error: 'toolarge' };
      if (i === 1 || !buf.parts || buf.total !== total) { buf.parts = []; buf.total = total; buf.len = 0; buf.video = !!d.video; }
      buf.parts[i] = d.data || ''; buf.len += (d.data || '').length;
      if (buf.len > (buf.video ? 1600000 : 260000)) { buf.parts = null; return { error: 'toolarge' }; }
      if (i < total) return { ok: true, part: i };
      for (let k = 1; k <= total; k++) if (buf.parts[k] === undefined) { buf.parts = null; return { error: 'missing:' + k }; }
      const url = buf.parts.slice(1, total + 1).join(''); const video = buf.video; buf.parts = null;
      /* como o servidor (server/photos.lua): imagens sempre; video/webm|mp4 só num envio marcado como vídeo */
      if (!/^data:image\//.test(url) && !(video && /^data:video\/(webm|mp4);base64,/.test(url))) return { error: 'badimage' };
      const poster = (video && typeof d.poster === 'string' && d.poster.length <= 16000 && /^data:image\/(jpeg|jpg|png|webp);base64,/.test(d.poster)) ? d.poster : null;
      const row = T('photos').insert({ owner: 'DEV0000', url, seed: d.seed || rnd(900), favorite: false, video, duration: d.duration || null, poster, created: now() });
      /* a resposta do servidor vem sem o base64 do url mas com a capa */
      return Object.assign({}, row, { url: null, len: url.length, hasPoster: !!poster });
    }; })(),
    'photos.remove': d => { T('photos').remove(d.id); return { ok: true }; },
    'photos.fav': d => T('photos').update(d.id, { favorite: !!d.favorite }),

    'mail.list': () => T('mail').all().sort((a, b) => b.created - a.created),
    /* { id, ok, delivered } como o servidor; no browser não há outro jogador, por isso nunca é entregue */
    'mail.send': d => { if (!String(d.to || '').trim()) return { ok: false, error: 'target' }; const r = T('mail').insert({ owner: 'DEV0000', sender: 'Eu', email: d.to, subject: d.subject || '(sem assunto)', body: d.body || '', read: true, folder: 'sent', created: now() }); return { id: r.id, ok: true, delivered: false }; },
    'mail.delete': d => { const m = T('mail').all().find(x => x.id === d.id); if (m && m.folder !== 'trash') T('mail').update(d.id, { folder: 'trash' }); else T('mail').remove(d.id); return { ok: true }; },
    'mail.read': d => T('mail').update(d.id, { read: true }),

    'bills.list': () => T('bills').all().sort((a, b) => b.created - a.created),
    'bills.pay': d => { const b = T('bills').all().find(x => x.id === d.id); if (!b || b.status !== 'pending') return { ok: false, error: 'invalid' }; const p = player(); if (p.money.bank < b.amount) return { ok: false, error: 'funds' };
      p.money.bank -= b.amount; savePlayer(p); T('bills').update(d.id, { status: 'paid', paid_at: now() }); T('transactions').insert({ owner: 'DEV0000', description: 'Fatura: ' + b.sender_name, amount: -b.amount, created: now() }); return { ok: true, bank: p.money.bank }; },
    'bills.refuse': d => { T('bills').update(d.id, { status: 'refused' }); return { ok: true }; },
    /* criar/enviadas/anular como o server/billing.lua: no browser o "devedor" é um NPC (a fatura fica só em `sent`) */
    'bills.create': d => { const amt = +d.amount; if (!amt || amt <= 0 || amt !== Math.floor(amt)) return { error: 'amount' }; if (amt > 1000000) return { error: 'amount', max: 1000000 }; if (!String(d.to || '').trim()) return { error: 'target' }; if (d.to === me().number) return { error: 'self' };
      const p = player(); const name = `${p.firstname} ${p.lastname}`.trim(); const soc = d.society ? String(d.society) : null; if (soc && soc !== (p.job || {}).name) return { error: 'society' };
      const b = T('sent_bills').insert({ to: d.to, to_name: (T('contacts').all().find(c => c.number === d.to) || {}).name || null, sender_name: soc ? ((p.job || {}).label || soc) + ' · ' + name : name, society: soc, amount: amt, reason: d.reason || null, status: 'pending', created: now() }); return b; },
    'bills.sent': () => T('sent_bills').all().sort((a, b) => b.created - a.created),
    'bills.cancel': d => { const b = T('sent_bills').all().find(x => x.id === d.id); if (!b || b.status !== 'pending') return { ok: false, error: 'invalid' }; T('sent_bills').update(d.id, { status: 'cancelled' }); return { ok: true }; },

    /* dados por personagem que o servidor guarda (server/userdata.lua): no browser ficam na raiz do Store, como o resto do mock */
    'userdata.get': () => ({ items: Store.global.get('db:userdata', {}) || {}, max: 300000 }),
    'userdata.set': d => { if (typeof d.k !== 'string' || !Store.SYNC.has(d.k)) return { error: 'key' }; if (d.v != null && typeof d.v !== 'string') return { error: 'invalid' }; if (d.v && d.v.length > 300000) return { error: 'toolarge', max: 300000 };
      Store.global.update('db:userdata', {}, m => { if (d.v == null) delete m[d.k]; else m[d.k] = d.v; }); return { ok: true }; },

    /* Casa (server/house.lua + qb-houses): duas casas de exemplo, uma minha e uma com chave emprestada */
    'house.list': () => ({ houses: Store.global.get('db:houses', null) || [{ name: 'house1', label: 'Grove Street 12', owner: true, coords: { x: 115.2, y: -1920.6, z: 21.3 }, garage: { x: 118.4, y: -1925.1 }, tier: 2, price: 250000, keyholders: [{ cid: 'NPC001', name: 'Maria Silva', number: '555-0199', online: false }], locked: true }, { name: 'house2', label: 'Vinewood Hills 4', owner: false, ownerName: 'Zé do Táxi', coords: { x: -1002.3, y: 640.1, z: 155.0 }, tier: 4, price: 900000, keyholders: [], locked: false }] }),
    'house.lock': d => { const hs = Store.global.get('db:houses', null); if (hs) { const h = hs.find(x => x.name === d.house); if (h) { h.locked = d.locked !== false; Store.global.set('db:houses', hs); } } return { ok: true, locked: d.locked !== false }; },
    'house.resolve': d => { const c = T('contacts').all().find(x => x.number === d.number); if (!c) return { error: 'target' }; return { src: 2, cid: 'NPC' + String(c.id), name: c.name }; },

    /* Encontrar (server/findmy.lua): no browser os "amigos" são os primeiros contactos, a andar perto de ti */
    'findmy.list': () => { const st = Store.global.get('db:findmy', { sharing: [], requests: [{ number: '555-0189' }], requested: [], paused: false }) || {}; const cs = T('contacts').all(); const nm = n => (cs.find(c => c.number === n) || {}).name || n;
      const me0 = (window.Maps && Maps.me) || { x: 215.8, y: -810.1 };   /* a posição "eu" do módulo dos Mapas (o `pos` do GPS fictício vive noutro scope) */
      const people = cs.slice(0, 3).map((c, i) => ({ number: c.number, name: c.name, x: me0.x + [180, -420, 950][i], y: me0.y + [-260, 310, 120][i], online: i !== 2, updated: Date.now(), sharing: (st.sharing || []).includes(c.number), mutual: (st.sharing || []).includes(c.number) }));
      if (people[2]) { delete people[2].x; delete people[2].y; }
      return { me: { x: me0.x, y: me0.y }, paused: !!st.paused, people, sharing: (st.sharing || []).map(n => ({ number: n, name: nm(n), mutual: people.some(p => p.number === n) })), requests: (st.requests || []).map(r => ({ number: r.number, name: nm(r.number), created: Date.now() - 6e4 })), requested: (st.requested || []).map(n => ({ number: n, name: nm(n) })) }; },
    'findmy.share': d => { if (d.number === me().number) return { ok: false, error: 'self' }; if (!T('contacts').all().some(c => c.number === d.number)) return { ok: false, error: 'target' }; Store.global.update('db:findmy', { sharing: [], requests: [], requested: [], paused: false }, s => { s.sharing = (s.sharing || []).filter(n => n !== d.number); if (d.on !== false) s.sharing.push(d.number); s.requests = (s.requests || []).filter(r => r.number !== d.number); }); return { ok: true }; },
    'findmy.request': d => { if (!T('contacts').all().some(c => c.number === d.number)) return { ok: false, error: 'target' }; Store.global.update('db:findmy', { sharing: [], requests: [], requested: [], paused: false }, s => { s.requested = (s.requested || []).filter(n => n !== d.number); s.requested.push(d.number); }); return { ok: true }; },
    'findmy.respond': d => { const st = Store.global.get('db:findmy', {}) || {}; if (!(st.requests || []).some(r => r.number === d.number)) return { ok: false, error: 'invalid' }; Store.global.update('db:findmy', { sharing: [], requests: [], requested: [], paused: false }, s => { s.requests = (s.requests || []).filter(r => r.number !== d.number); if (d.accept && !(s.sharing || []).includes(d.number)) s.sharing.push(d.number); }); return { ok: true }; },
    'findmy.pause': d => { Store.global.update('db:findmy', { sharing: [], requests: [], requested: [], paused: false }, s => { s.paused = d.on === true; }); return { ok: true, paused: d.on === true }; },

    /* AppShop (server/appstore.lua): classificações dos jogadores - no browser só as tuas */
    'apps.ratings': d => { const all = Store.global.get('db:ratings', {}) || {}; const mine = all[d.app] || null; const dist = [0, 0, 0, 0, 0]; if (mine) dist[mine.stars - 1] = 1; return { avg: mine ? mine.stars : 0, count: mine ? 1 : 0, dist, mine, reviews: mine && (mine.text || mine.title) ? [Object.assign({ username: me().username || 'eu' }, mine)] : [] }; },
    'apps.ratingsAll': () => { const all = Store.global.get('db:ratings', {}) || {}; const out = {}; Object.keys(all).forEach(k => out[k] = { avg: all[k].stars, count: 1 }); return out; },
    'apps.rate': d => { const s = Math.floor(+d.stars); if (!(s >= 1 && s <= 5)) return { ok: false, error: 'stars' }; Store.global.update('db:ratings', {}, m => { m[d.app] = { stars: s, title: String(d.title || '').slice(0, 60) || null, text: String(d.text || '').slice(0, 300) || null, created: now() }; }); return { ok: true, avg: s, count: 1 }; },
    'apps.unrate': d => { Store.global.update('db:ratings', {}, m => { delete m[d.app]; }); return { ok: true }; },

    'bank.info': () => { const p = player(); return { bank: p.money.bank, cash: p.money.cash, transactions: T('transactions').all().sort((a, b) => b.created - a.created) }; },
    'bank.transfer': d => { const p = player(); const amt = Math.floor(+d.amount); if (!amt || amt <= 0) return { ok: false, error: 'amount' }; if (amt > p.money.bank) return { ok: false, error: 'funds' }; if (d.to === me().number) return { ok: false, error: 'self' };
      p.money.bank -= amt; savePlayer(p); const name = (T('contacts').all().find(c => c.number === d.to) || {}).name || d.to; T('transactions').insert({ owner: 'DEV0000', description: 'Transferência para ' + name + (d.note ? ' · ' + d.note : ''), amount: -amt, created: now() }); return { ok: true, bank: p.money.bank }; },

    'social.profile': d => T('social_accounts').all().find(x => x.app === d.app && x.owner === 'DEV0000') || null,
    'social.createProfile': d => { if (T('social_accounts').all().find(x => x.app === d.app && x.username === d.username)) return { error: 'taken' }; const row = T('social_accounts').insert({ app: d.app, owner: 'DEV0000', username: d.username, bio: d.bio || '', avatar: d.avatar || 1, created: now() });
      /* O seed corre ANTES de haver conta, por isso não podia ligar ninguém a ti: dois dos NPCs
         passam a seguir-te e a ser seguidos (mútuos) e um fica nos amigos próximos. Sem isto, no
         browser, "Mútuos" e "Amigos próximos" eram sempre listas vazias - e os Instants, que
         dependem exatamente dessas duas relações, não davam para exercitar. */
      const fol = T('follows'), cf = T('close_friends');
      [['vinewood_star', true], ['maria_ls', false]].forEach(([u, close]) => {
        if (!fol.all().some(x => x.app === d.app && x.follower === d.username && x.followed === u)) fol.insert({ app: d.app, follower: d.username, followed: u });
        if (!fol.all().some(x => x.app === d.app && x.follower === u && x.followed === d.username)) fol.insert({ app: d.app, follower: u, followed: d.username });
        if (close && !cf.all().some(x => x.app === d.app && x.owner === u && x.friend === d.username)) cf.insert({ app: d.app, owner: u, friend: d.username });
      });
      return row; },
    'social.updateProfile': d => { const a = T('social_accounts').all().find(x => x.app === d.app && x.owner === 'DEV0000'); if (!a) return { error: 'noprofile' }; return T('social_accounts').update(a.id, { bio: d.bio !== undefined ? d.bio : a.bio, avatar: d.avatar || a.avatar, name: d.name !== undefined ? d.name : a.name, website: d.website !== undefined ? d.website : a.website, avatar_url: d.avatarUrl !== undefined ? (d.avatarUrl || null) : a.avatar_url }); },
    'social.feed': d => { const app = d.app, my = soc.myName(app); let posts = T('posts').all().filter(p => p.app === app && !p.reply_to);
      if (d.mode === 'home' && my) { const f = T('follows').all().filter(x => x.app === app && x.follower === my).map(x => x.followed); posts = posts.filter(p => f.includes(p.author) || p.author === my || f.length === 0); }
      if (d.mode === 'user') posts = posts.filter(p => p.author === d.ref); if (d.mode === 'hashtag') posts = posts.filter(p => (p.content || '').toLowerCase().includes('#' + d.ref.toLowerCase()));
      return soc.enrich(app, posts.sort((a, b) => b.created - a.created).slice(0, 60)); },
    /* a fotografia de uma publicação aos bocados de 48 KB (social.post.media do servidor) */
    'social.post.media': d => { const p = T('posts').all().find(x => x.id === d.id); if (!p) return { error: 'notfound' }; const s = typeof p.image === 'string' ? p.image : '', C = 48000, i = Math.max(1, d.i | 0); return { i, total: Math.ceil(s.length / C), len: s.length, data: s.slice((i - 1) * C, i * C) }; },
    /* como o servidor (social.post em server/social.lua): a fotografia vem por REFERÊNCIA (`photoId` de uma foto da galeria,
       cujo url se copia para a publicação); inline só o seed, um endereço http ou um data URL até 48 000 ('toolarge' acima , 
       no jogo um evento desse tamanho nem chegava). A resposta nunca traz a fotografia: vai como uma linha do feed (imageLen + chunk). */
    'social.post': d => { const my = soc.myName(d.app); if (!my) return { error: 'noprofile' };
      let image = null;
      if (+d.photoId > 0) { const ph = T('photos').all().find(x => x.id === +d.photoId); if (!ph) return { error: 'photo' }; if (ph.video) return { error: 'video' }; image = ph.url || (ph.seed ? String(ph.seed) : null); }
      else if (d.image != null && d.image !== false && d.image !== '') { const s = String(d.image);
        if (/^\d{1,12}$/.test(s)) image = +s;
        else if (s.length > 48000) return { error: 'toolarge' };
        else if (/^data:image\/(jpeg|jpg|png|webp|gif);base64,/.test(s) || (s.length <= 512 && /^https?:\/\//.test(s) && !/[\s"'<>\\]/.test(s))) image = s;
        else return { error: 'badimage' }; }
      /* como o servidor: um repost simples por pessoa */
      if (d.repostOf && !(d.content || '') && image == null) { const dup = T('posts').all().find(x => x.app === d.app && x.author === my && x.repost_of === d.repostOf && !(x.content || '')); if (dup) return { error: 'reposted', id: dup.id }; }
      const row = T('posts').insert({ app: d.app, author: my, content: d.content || '', image, reply_to: d.replyTo || null, repost_of: d.repostOf || null, created: now() });
      const out = Object.assign({}, row); if (typeof out.image === 'string' && out.image.length > 4096) { out.imageLen = out.image.length; out.chunk = 48000; out.image = null; } else if (typeof out.image === 'string' && /^\d+$/.test(out.image)) out.image = +out.image;
      return out; },
    'social.like': d => { const my = soc.myName(d.app); const l = T('likes').all().find(x => x.post_id === d.postId && x.username === my); if (l) T('likes').remove(l.id); else T('likes').insert({ post_id: d.postId, username: my }); return { liked: !l }; },
    'social.comment': d => { const my = soc.myName(d.app); return T('comments').insert({ post_id: d.postId, username: my, content: d.content, created: now() }); },
    'social.comments': d => { const app = d.app, my = soc.myName(app); const post = T('posts').all().find(p => p.id === d.postId); return T('comments').all().filter(c => c.post_id === d.postId).map(c => Object.assign({}, c, { avatar: (soc.user(app, c.username) || {}).avatar, likes: T('cmt_likes').all().filter(x => x.comment_id === c.id).length, liked: !!T('cmt_likes').all().find(x => x.comment_id === c.id && x.username === my), canDelete: c.username === my || (post && post.author === my) })); },
    'social.comment.like': d => { const my = soc.myName(d.app); const l = T('cmt_likes').all().find(x => x.comment_id === d.id && x.username === my); if (l) { T('cmt_likes').remove(l.id); return { liked: false }; } T('cmt_likes').insert({ comment_id: d.id, username: my }); return { liked: true }; },
    'social.comment.delete': d => { T('comments').all().filter(c => c.id === d.id || c.parent === d.id).forEach(c => T('comments').remove(c.id)); return { ok: true }; },
    /* ---- listas de pessoas ---- */
    'social.likers': d => { const app = d.app, my = soc.myName(app); const fl = T('follows').all().filter(x => x.app === app); return T('likes').all().filter(l => l.post_id === d.postId).map(l => { const u = soc.user(app, l.username) || {}; return { username: l.username, name: u.name, bio: u.bio, avatar: u.avatar || 1, isFollowing: !!fl.find(x => x.follower === my && x.followed === l.username), me: l.username === my }; }); },
    'social.followers': d => { const app = d.app, my = soc.myName(app); const fl = T('follows').all().filter(x => x.app === app); const names = d.mode === 'following' ? fl.filter(x => x.follower === d.username).map(x => x.followed) : fl.filter(x => x.followed === d.username).map(x => x.follower); return names.map(n => { const u = soc.user(app, n) || {}; return { username: n, name: u.name, bio: u.bio, avatar: u.avatar || 1, isFollowing: !!fl.find(x => x.follower === my && x.followed === n), me: n === my }; }); },
    /* ---- guardados ---- */
    'social.save': d => { const my = soc.myName(d.app); const s = T('saves').all().find(x => x.app === d.app && x.username === my && x.post_id === d.postId); if (s) { T('saves').remove(s.id); return { saved: false }; } T('saves').insert({ app: d.app, username: my, post_id: d.postId, created: Date.now() }); return { saved: true }; },
    'social.saves': d => { const my = soc.myName(d.app); const ids = T('saves').all().filter(x => x.app === d.app && x.username === my).map(x => x.post_id); return soc.enrich(d.app, T('posts').all().filter(p => ids.includes(p.id)), my); },
    /* ---- stories ---- */
    'social.stories': d => { const app = d.app, my = soc.myName(app), now = Date.now();
      const live = T('stories').all().filter(s => s.app === app && s.expires > now).sort((a, b) => a.created - b.created);
      const seen = T('story_views').all().filter(v => v.username === my).map(v => v.story_id);
      const byA = {}, out = [];
      /* sem `image`/`draw`, como o servidor: a media vem pelo social.story.get */
      live.forEach(s => { const it = { id: s.id, author: s.author, created: s.created, expires: s.expires, layers: s.layers, bg: s.bg, duration: s.duration || 5, text: s.text, tx: s.tx, ty: s.ty, tsize: s.tsize, tcolor: s.tcolor, loc: s.loc, hasMedia: !!s.image, closeFriends: s.close_friends === 1, seen: seen.includes(s.id) }; let gr = byA[s.author];
        if (!gr) { const u = soc.user(app, s.author) || {}; gr = { author: s.author, name: u.name, avatar: u.avatar || 1, items: [], allSeen: true, mine: s.author === my }; byA[s.author] = gr; out.push(gr); }
        gr.items.push(it); if (!it.seen) gr.allSeen = false; });
      out.sort((a, b) => (b.mine - a.mine) || (a.allSeen - b.allSeen)); return out; },
    'social.story.add': d => { const my = soc.myName(d.app); const now = Date.now(); return { ok: true, id: T('stories').insert({ app: d.app, author: my, image: d.image, bg: d.bg, draw: d.draw, layers: d.layers || [], duration: d.duration || 5, close_friends: d.closeFriends ? 1 : 0, text: d.text, tx: d.tx, ty: d.ty, tsize: d.tsize, tcolor: d.tcolor, loc: d.loc, created: now, expires: now + 864e5 }) }; },
    /* media de uma story à peça (a lista não a traz, tal como no servidor) */
    'social.story.get': d => {
      const s = T('stories').all().find(x => x.id === d.id);
      if (!s) return null;
      const me = soc.myName(d.app);
      const polls = {}, myAnswers = {};
      T('story_answers').all().filter(x => x.story_id === s.id).forEach(r => {
        const p = polls[r.layer] || (polls[r.layer] = { a: 0, b: 0, n: 0 });
        p.n++; if (r.choice === 0) p.a++; else if (r.choice === 1) p.b++;
        if (r.username === me) myAnswers[r.layer] = { choice: r.choice, answer: r.answer };
      });
      return { id: s.id, author: s.author, image: s.image, draw: s.draw, layers: s.layers, bg: s.bg, duration: s.duration || 5, text: s.text, tx: s.tx, ty: s.ty, tsize: s.tsize, tcolor: s.tcolor, loc: s.loc, created: s.created, polls, myAnswers };
    },
    'social.stories.config': () => ({
      duration: 5, maxLayers: 24, closeFriends: true,
      backgrounds: [
        { id: 'ig', type: 'grad', a: '#833AB4', b: '#FD1D1D' }, { id: 'sunset', type: 'grad', a: '#FF9F0A', b: '#FF375F' },
        { id: 'ocean', type: 'grad', a: '#0A84FF', b: '#00C7BE' }, { id: 'forest', type: 'grad', a: '#30D158', b: '#0B6E4F' },
        { id: 'grape', type: 'grad', a: '#BF5AF2', b: '#5E5CE6' }, { id: 'night', type: 'grad', a: '#2C2C2E', b: '#0A0A0B' },
        { id: 'black', type: 'solid', a: '#000000' }, { id: 'white', type: 'solid', a: '#FFFFFF' },
      ],
      locations: ['Legion Square', 'Hospital Pillbox', 'LSPD Mission Row', 'Vespucci Beach', 'Diamond Casino', 'Mirror Park'],
      /* como no servidor: cada sugestão traz o `vid`, senão não há pré-escuta nenhuma */
      music: [
        { id: 'yt:dQw4w9WgXcQ', vid: 'dQw4w9WgXcQ', title: 'Never Gonna Give You Up', artist: 'Rick Astley', dur: 213, art: ['#833AB4', '#FD1D1D'] },
        { id: 'yt:kJQP7kiw5Fk', vid: 'kJQP7kiw5Fk', title: 'Despacito', artist: 'Luis Fonsi', dur: 282, art: ['#FF9F0A', '#FF375F'] },
        { id: 'yt:RgKAFK5djSk', vid: 'RgKAFK5djSk', title: 'See You Again', artist: 'Wiz Khalifa', dur: 230, art: ['#0A84FF', '#00C7BE'] },
      ],
    }),
    'social.closefriends': d => T('close_friends').all().filter(x => x.app === d.app && x.owner === soc.myName(d.app)).map(x => x.friend),
    'social.closefriends.toggle': d => {
      const me = soc.myName(d.app);
      const ex = T('close_friends').all().find(x => x.app === d.app && x.owner === me && x.friend === d.target);
      if (ex) { T('close_friends').remove(ex.id); return { on: false }; }
      T('close_friends').insert({ app: d.app, owner: me, friend: d.target });
      return { on: true };
    },
    /* respostas às sondagens/perguntas das stories */
    'social.story.answer': d => {
      const me = soc.myName(d.app);
      const ex = T('story_answers').all().find(x => x.story_id === d.id && x.layer === d.layer && x.username === me);
      const row = { story_id: d.id, layer: d.layer, username: me, choice: d.choice == null ? null : d.choice, answer: d.answer || null, created: Date.now() };
      if (ex) T('story_answers').update(ex.id, row); else T('story_answers').insert(row);
      return { ok: true };
    },
    'social.story.answers': d => T('story_answers').all().filter(x => x.story_id === d.id),
    'social.story.view': d => { const my = soc.myName(d.app); const v = T('story_views').all().find(x => x.story_id === d.id && x.username === my); if (!v) T('story_views').insert({ story_id: d.id, username: my, liked: !!d.liked, created: Date.now() }); else if (d.liked !== undefined) T('story_views').update(v.id, { liked: !!d.liked }); return { ok: true }; },
    'social.story.delete': d => { T('story_views').all().filter(v => v.story_id === d.id).forEach(v => T('story_views').remove(v.id)); T('stories').remove(d.id); return { ok: true }; },
    'social.story.viewers': d => { const app = d.app; return T('story_views').all().filter(v => v.story_id === d.id).map(v => { const u = soc.user(app, v.username) || {}; return { username: v.username, name: u.name, avatar: u.avatar || 1, liked: !!v.liked, isFollowing: false, me: false }; }); },
    'social.follow': d => { const my = soc.myName(d.app); const f = T('follows').all().find(x => x.app === d.app && x.follower === my && x.followed === d.target); if (f) T('follows').remove(f.id); else T('follows').insert({ app: d.app, follower: my, followed: d.target }); return { following: !f }; },

    /* ---------- INSTANTS (a fotografia do momento, vista uma só vez) ----------
       O mock faz as MESMAS contas do servidor (server/social.lua, secção INSTANTS): quem pode ver
       (amigos próximos do autor OU seguirem-se os dois), a visualização que se queima e a validade.
       Sem isto o browser devolvia "unknown rpc" e o harness não exercitava nada.
       `__as` existe só aqui, para o harness poder fingir que outra pessoa enviou um Instant - no
       servidor o autor é SEMPRE quem faz a chamada e não há nada parecido. */
    'social.instant.list': d => {
      const app = d.app, my = soc.myName(app), t = Date.now();
      if (!my) return { inbox: [], mine: [], chunk: 48000 };
      const seen = T('instant_views').all();
      const live = T('instants').all().filter(x => x.app === app && x.expires > t && x.ready);
      const canSee = x => {
        if (x.audience === 'mutuals') {
          const f = T('follows').all();
          return f.some(r => r.app === app && r.follower === my && r.followed === x.author)
              && f.some(r => r.app === app && r.follower === x.author && r.followed === my);
        }
        return T('close_friends').all().some(c => c.app === app && c.owner === x.author && c.friend === my);
      };
      const row = (x, own) => ({ id: x.id, author: x.author, created: x.created, expires: x.expires, audience: x.audience,
        text: x.text || null, ty: x.ty == null ? 0.8 : x.ty, tsize: x.tsize || 30,
        imageLen: (x.image || '').length, chunk: 48000, avatar: (soc.user(app, x.author) || {}).avatar || 1,
        views: own ? seen.filter(v => v.instant_id === x.id).length : undefined, mine: own || undefined });
      const inbox = live.filter(x => x.author !== my && !seen.some(v => v.instant_id === x.id && v.username === my) && canSee(x))
        .sort((a, b) => a.created - b.created).slice(0, 30).map(x => row(x, false));
      const mine = live.filter(x => x.author === my).sort((a, b) => b.created - a.created).slice(0, 10).map(x => row(x, true));
      return { inbox, mine, chunk: 48000 };
    },
    'social.instant.add': d => {
      const my = d.__as || soc.myName(d.app);
      if (!my) return { error: 'noprofile' };
      const t = Date.now();
      if (T('instants').all().filter(x => x.app === d.app && x.author === my && x.expires > t).length >= 10) return { error: 'toomany' };
      const r = T('instants').insert({ app: d.app, author: my, image: null, text: (d.text || null), ty: d.ty == null ? 0.8 : d.ty,
        tsize: d.tsize || 30, audience: d.audience === 'mutuals' ? 'mutuals' : 'close', ready: 0, created: t, expires: t + 864e5 });
      return { ok: true, id: r.id, chunk: 48000 };
    },
    'social.instant.upload': d => {
      const r = T('instants').all().find(x => x.id === d.id); if (!r) return { error: 'forbidden' };
      if (r.ready) return { error: 'sent' };
      const part = String(d.data || '');
      T('instants').update(r.id, { image: (+d.i === 1 ? '' : (r.image || '')) + part });
      const len = ((T('instants').all().find(x => x.id === d.id) || {}).image || '').length;
      if (len > 300000) { T('instants').remove(d.id); return { error: 'toolarge' }; }
      return { ok: true, len };
    },
    'social.instant.ready': d => {
      const r = T('instants').all().find(x => x.id === d.id); if (!r) return { error: 'forbidden' };
      if ((r.image || '').length < 100) { T('instants').remove(d.id); return { error: 'empty' }; }
      T('instants').update(r.id, { ready: 1 });
      return { ok: true };
    },
    'social.instant.media': d => {
      const CH = 48000;
      const r = T('instants').all().find(x => x.id === d.id);
      if (!r || !r.ready || r.expires < Date.now()) return { error: 'notfound' };
      const my = soc.myName(d.app);
      /* A VISUALIZAÇÃO QUEIMA-SE AQUI, como no servidor: quem entrega a imagem é quem cobra.
         (O `social.instant.view` continua a valer como aviso antecipado.) Sem isto o mock era mais
         permissivo do que o servidor e o harness testava a cortesia do cliente, não a regra. */
      if (my && r.author !== my) {
        const v = T('instant_views').all().find(x => x.instant_id === r.id && x.username === my);
        if (!v) T('instant_views').insert({ instant_id: r.id, username: my, created: Date.now() });
        else if (Date.now() - (v.created || 0) > 90000) return { error: 'burned' };
      }
      const i = Math.max(1, Math.floor(+d.i || 1));
      const img = r.image || '';
      if (!img.length) return { i, total: 0, len: 0, data: '' };
      return { i, total: Math.ceil(img.length / CH), len: img.length, data: img.slice((i - 1) * CH, i * CH) };
    },
    'social.instant.view': d => {
      const my = soc.myName(d.app); if (!my) return { error: 'noprofile' };
      const r = T('instants').all().find(x => x.id === d.id); if (!r) return { error: 'gone' };
      if (r.author === my) return { ok: true, own: true };
      if (!T('instant_views').all().some(v => v.instant_id === d.id && v.username === my)) T('instant_views').insert({ instant_id: d.id, username: my, created: Date.now() });
      return { ok: true };
    },
    'social.instant.react': d => {
      const my = soc.myName(d.app); if (!my) return { error: 'noprofile' };
      const r = T('instants').all().find(x => x.id === d.id); if (!r) return { error: 'gone' };
      if (r.author === my) return { error: 'own' };
      const ok = ['😂', '❤️', '😮', '👏', '🔥', '😍', '😢', '👍'];
      if (ok.indexOf(String(d.emoji || '')) < 0) return { error: 'badreaction' };
      const v = T('instant_views').all().find(x => x.instant_id === d.id && x.username === my);
      if (!v) return { error: 'notseen' };   /* só se reage ao que já se viu */
      T('instant_views').update(v.id, { reaction: d.emoji });
      return { ok: true, emoji: d.emoji };
    },
    'social.instant.delete': d => { T('instant_views').all().filter(v => v.instant_id === d.id).forEach(v => T('instant_views').remove(v.id)); T('instants').remove(d.id); return { ok: true }; },
    'social.instant.viewers': d => { const app = d.app; return T('instant_views').all().filter(v => v.instant_id === d.id).map(v => { const u = soc.user(app, v.username) || {}; return { username: v.username, name: u.name, avatar: u.avatar || 1, reaction: v.reaction || null }; }); },
    'social.user': d => { const u = soc.user(d.app, d.username); if (!u) return null; const fl = T('follows').all().filter(x => x.app === d.app); const my = soc.myName(d.app);
      return Object.assign({}, u, { followers: fl.filter(x => x.followed === u.username).length, following: fl.filter(x => x.follower === u.username).length, posts: T('posts').all().filter(p => p.app === d.app && p.author === u.username).length, isFollowing: !!fl.find(x => x.follower === my && x.followed === u.username), me: my === u.username }); },
    'social.search': d => { const my = soc.myName(d.app), fl = T('follows').all().filter(x => x.app === d.app && x.follower === my); return T('social_accounts').all().filter(x => x.app === d.app && x.username.includes((d.q || '').toLowerCase())).slice(0, 20).map(x => Object.assign({}, x, { isFollowing: !!fl.find(f => f.followed === x.username), me: x.username === my })); },
    'social.deletePost': d => { const my = soc.myName(d.app); const p = T('posts').all().find(x => x.id === d.postId); if (!p || p.author !== my) return { error: 'forbidden' }; T('posts').remove(d.postId); return { ok: true }; },
    'social.replies': d => soc.enrich(d.app, T('posts').all().filter(p => p.reply_to === d.postId).sort((a, b) => a.created - b.created)),
    'social.notifications': d => { const my = soc.myName(d.app); const mine = T('posts').all().filter(p => p.app === d.app && p.author === my).map(p => p.id);
      /* como o servidor: no Tweeter as respostas, citações e reposts são publicações */
      const refs = d.app !== 'twix' ? [] : T('posts').all().filter(p => p.app === d.app && p.author !== my && (mine.includes(p.reply_to) || mine.includes(p.repost_of))).map(p => ({ type: mine.includes(p.reply_to) ? 'reply' : (p.content || '').trim() ? 'quote' : 'repost', username: p.author, content: (p.content || '').trim() ? p.content : undefined, created: p.created }));
      return [...T('likes').all().filter(l => mine.includes(l.post_id) && l.username !== my).map(l => ({ type: 'like', username: l.username, created: now() - 6e5 })), ...T('comments').all().filter(c => mine.includes(c.post_id)).map(c => ({ type: 'comment', username: c.username, content: c.content, created: c.created })), ...refs, ...T('follows').all().filter(f => f.app === d.app && f.followed === my).map(f => ({ type: 'follow', username: f.follower, created: now() - 36e5 }))].sort((a, b) => b.created - a.created); },

    'darkchat.identity': () => { let n = Store.get('dcname', null); if (!n) { n = ['sombra', 'corvo', 'anon', 'fantasma', 'lobo', 'raven'][rnd(6)] + rnd(999); Store.set('dcname', n); } return { username: n }; },
    'darkchat.rooms': () => { const joined = Store.get('dcrooms', ['geral']); const all = T('darkchat').all(); return joined.map(r => { const ms = all.filter(m => m.room === r); return { room: r, count: ms.length, last: ms.at(-1) || null }; }); },
    /* regras do server/social.lua: nome da sala saneado (a-z 0-9 _ -, até 40), só membros leem e escrevem,
       TTL só da lista e imagem com limite; a sala devolve as 200 mais recentes sem as temporárias já expiradas */
    'darkchat.join': d => { const room = String(d.room || '').toLowerCase().replace(/[^a-z0-9_-]/g, '').slice(0, 40); if (!room) return { ok: false, error: 'invalid' }; Store.update('dcrooms', ['geral'], l => { if (!l.includes(room)) l.push(room); }); return { ok: true, room }; },
    'darkchat.leave': d => { Store.update('dcrooms', ['geral'], l => { const i = l.indexOf(d.room); if (i > -1) l.splice(i, 1); }); return { ok: true }; },
    'darkchat.messages': d => { if (!Store.get('dcrooms', ['geral']).includes(d.room)) return { error: 'forbidden' }; const t = now();
      return T('darkchat').all().filter(m => m.room === d.room && !(m.ttl && m.created + m.ttl * 60000 <= t)).sort((a, b) => a.created - b.created).slice(-200); },
    'darkchat.send': d => { if (!Store.get('dcrooms', ['geral']).includes(d.room)) return { error: 'forbidden' };
      const ttl = d.ttl == null ? 0 : +d.ttl; if (![0, 1, 5, 15, 30, 60, 360, 1440].includes(ttl)) return { error: 'ttl' };
      if (typeof d.image === 'string' && d.image.length > 260000) return { error: 'toolarge' };
      const m = T('darkchat').insert({ room: d.room, username: R['darkchat.identity']().username, content: String(d.content || '').slice(0, 300), image: d.image || null, created: now(), ttl });
      setTimeout(() => { const r = T('darkchat').insert({ room: d.room, username: 'corvo', content: ['Recebido.', 'Não aqui.', 'Encontro no cais. 23h.', '👁'][rnd(4)], image: null, created: now() }); Bridge.emit('darkchat', r); }, 2000 + rnd(2000)); return m; },

    'services.list': () => [{ id: 'police', label: 'Polícia', job: 'police', icon: 'lock', color: '#5E5CE6' }, { id: 'ems', label: 'EMS', job: 'ambulance', icon: 'heart', color: '#FF453A' }, { id: 'mechanic', label: 'Mecânico', job: 'mechanic', icon: 'gear', color: '#FF9F0A' }, { id: 'taxi', label: 'Táxi', job: 'taxi', icon: 'car', color: '#FFD60A' }, { id: 'realestate', label: 'Imobiliária', job: 'realestate', icon: 'home', color: '#30D158' }, { id: 'burgershot', label: 'Burger Shot', job: 'burgershot', icon: 'bag2', color: '#FF375F', business: true }],
    'services.request': d => { const r = T('services').insert({ requester: 'DEV0000', requester_name: player().firstname + ' ' + player().lastname, requester_phone: me().number, service: d.service, description: d.description || '', coords: d.coords || null, status: 'pending', accepted_by: null, created: now() });
      setTimeout(() => { T('services').update(r.id, { status: 'accepted', accepted_by: 'Unidade 12' }); Bridge.emit('serviceUpdate', Object.assign({}, r, { status: 'accepted', accepted_by: 'Unidade 12' })); }, 4000 + rnd(4000)); return r; },
    'services.cancel': d => { T('services').update(d.id, { status: 'cancelled' }); return { ok: true }; },
    'services.mine': () => T('services').all().filter(r => r.requester === 'DEV0000').sort((a, b) => b.created - a.created),
    'services.pending': () => T('services').all().filter(r => r.status === 'pending' && r.requester !== 'DEV0000'),
    /* como o servidor: { ok, request } ou { ok:false, error: 'gone' | 'self' } (no browser não há job para recusar) */
    'services.accept': d => { const r = T('services').all().find(x => x.id === d.id); if (!r || r.status !== 'pending') return { ok: false, error: 'gone' }; if (r.requester === 'DEV0000') return { ok: false, error: 'self' };
      return { ok: true, request: T('services').update(d.id, { status: 'accepted', accepted_by: 'eu', accepted_cid: 'DEV0000' }) }; },
    'services.complete': d => { T('services').update(d.id, { status: 'done' }); return { ok: true }; },

    'garage.vehicles': () => [{ plate: 'RK 4471', model: 'sultan', label: 'Sultan RS', garage: 'pillboxgarage', state: 1, fuel: 82 }, { plate: 'LS 2023', model: 'faggio', label: 'Faggio', garage: 'motelgarage', state: 0, fuel: 40 }],
    'apps.installed': () => Store.get('installed', null),
    'apps.install': d => { Store.update('installed', [], l => { if (!l.includes(d.id)) l.push(d.id); }); return { ok: true }; },
    'apps.uninstall': d => { Store.update('installed', [], l => { const i = l.indexOf(d.id); if (i > -1) l.splice(i, 1); }); return { ok: true }; },
    'apps.registry': () => [],
    /* dois pares, como o servidor: AirBuds (item 'airpods') e NOVA Buds 4 Pro (item 'slate_buds'); usar o outro troca de par */
    'earbuds.state': () => { const k = Store.get('budsKind', 'airbuds'); return { connected: Store.get('earbuds', false), worn: Store.get('airpodsWorn', true), kind: k, name: k === 'slate' ? 'NOVA Buds 4 Pro' : 'AirPods Pro 3', battery: { l: 84, r: 79, c: 62 } }; },
    'earbuds.toggle': () => { const k = Store.get('budsKind', 'airbuds'), name = k === 'slate' ? 'NOVA Buds 4 Pro' : 'AirPods Pro 3'; if (!Store.get('airpodsWorn', true)) return { error: 'notworn', connected: false, worn: false, kind: k, name }; const v = !Store.get('earbuds', false); Store.set('earbuds', v); return { connected: v, worn: true, kind: k, name, battery: { l: 84, r: 79, c: 62 } }; },
    'airpods.wear': d => { const k = d && d.item === 'slate_buds' ? 'slate' : 'airbuds', was = Store.get('budsKind', 'airbuds'), on = Store.get('airpodsWorn', true);
      const v = on && was !== k ? true : !on; if (was !== k) Store.set('earbuds', false); Store.set('budsKind', k); Store.set('airpodsWorn', v); if (!v) Store.set('earbuds', false);
      return { worn: v, connected: v && Store.get('earbuds', false), kind: k, name: k === 'slate' ? 'NOVA Buds 4 Pro' : 'AirPods Pro 3', battery: { l: 84, r: 79, c: 62 } }; },
    'player.get': () => player(),

    /* ---------- AirShare (pacote AD) - o "outro jogador" vive em LocalDB.airdrop (ver AD mais abaixo) ----------
       Espelha o server/airdrop.lua: as ofertas que EU envio ficam em AD.out (o outro lado responde com AD.answer /
       AD.expire); as que me CHEGAM entram por AD.offer(...) para AD.inbox e respondem-se pelo airdrop.answer. */
    'airdrop.set': d => { const m = ['off', 'contacts', 'everyone'].includes(d.mode) ? d.mode : 'off'; AD.mode = m; return { ok: true, mode: m }; },
    'airdrop.nearby': () => Array.isArray(AD.nearby) ? AD.nearby.map(p => Object.assign({}, p)) : AD.nearby,   /* o harness põe { error } para testar o radar sob ratelimit */
    'airdrop.send': d => {
      const to = +d.to; const p = AD.nearby.find(x => x.src === to); if (!p) return { error: 'notnear' };
      const photo = T('photos').all().find(x => x.id === +d.photoId); if (!photo) return { error: 'notfound' };
      if (AD.out.find(o => o.to === to)) return { error: 'busy' };
      /* como no servidor: cancelar/recusar/expirar deixa o par em pausa (AD.cooldownMs; o harness põe 0 para encadear envios) */
      if (AD.cool[to] && now() - AD.cool[to] < AD.cooldownMs) return { error: 'cooldown' };
      const thumb = typeof d.thumb === 'string' && d.thumb.length <= 12000 && /^data:image\/(jpeg|jpg);base64,/.test(d.thumb) ? d.thumb : null;
      const id = ++AD.seq; const o = { id, to, photoId: photo.id, thumb, thumbLen: typeof d.thumb === 'string' ? d.thumb.length : 0, expires: now() + 60000 };
      AD.out.push(o); AD.sent.push(Object.assign({}, o));
      /* resposta automática do outro lado, quando o harness a pedir (AD.auto = 'accept' | 'decline' | 'expire') */
      if (AD.auto) setTimeout(() => { if (AD.auto === 'expire') AD.expire(id); else AD.answer(id, AD.auto === 'accept'); }, AD.autoMs);
      return { ok: true, id };
    },
    'airdrop.answer': d => {
      const o = AD.inbox.find(x => x.id === +d.id); if (!o) return { error: 'notfound' };
      AD.inbox = AD.inbox.filter(x => x !== o); AD.answered.push({ id: o.id, accept: !!d.accept });
      if (!d.accept) return { ok: true };
      if (o.notnear) return { error: 'notnear' };
      const row = T('photos').insert({ owner: 'DEV0000', url: o.url || null, seed: o.seed || rnd(900), favorite: false, created: now() });
      setTimeout(() => Bridge.emit('photos:changed', {}), 0);
      return { ok: true, photoId: row.id };
    },
    'airdrop.cancel': d => { const o = AD.out.find(x => x.id === +d.id); if (!o) return { error: 'notfound' }; AD.out = AD.out.filter(x => x !== o); AD.cancelled.push(o.id); AD.cool[o.to] = now(); return { ok: true }; },
  };
  /* O outro lado do AirShare, para o browser e o harness: quem está "por perto", e as mãos que respondem às
     minhas ofertas (answer/expire → push airdrop:result) ou me mandam uma foto (offer → push airdrop:offer). */
  const AD = {
    mode: 'off', seq: 0, auto: null, autoMs: 400, cooldownMs: 5000, cool: {},   /* cool[to] = quando a última oferta a esse src acabou sem aceite */
    nearby: [{ src: 2, name: 'PearPhone de Ana', avatar: 5 }, { src: 3, name: 'PearPhone de Rui', avatar: 8 }],   /* como o servidor: sem números (a NUI não os usa) */
    out: [], inbox: [], sent: [], answered: [], cancelled: [],
    answer(id, accept) { const o = AD.out.find(x => x.id === +id); if (!o) return false; AD.out = AD.out.filter(x => x !== o); if (!accept) AD.cool[o.to] = now(); setTimeout(() => Bridge.emit('airdrop:result', { id: o.id, accepted: !!accept }), 0); return true; },
    expire(id) { const o = AD.out.find(x => x.id === +id); if (!o) return false; AD.out = AD.out.filter(x => x !== o); AD.cool[o.to] = now(); setTimeout(() => Bridge.emit('airdrop:result', { id: o.id, accepted: false, expired: true }), 0); return true; },
    fail(id, error) { const o = AD.out.find(x => x.id === +id); if (!o) return false; AD.out = AD.out.filter(x => x !== o); setTimeout(() => Bridge.emit('airdrop:result', { id: o.id, accepted: false, error: error || 'notnear' }), 0); return true; },
    offer(o) { o = o || {}; const id = ++AD.seq; const row = { id, from: o.from || 'PearPhone de Ana', avatar: o.avatar || 5, url: o.url || null, seed: o.seed || 321, thumb: o.thumb || null, notnear: !!o.notnear };
      AD.inbox.push(row); setTimeout(() => Bridge.emit('airdrop:offer', { id, from: row.from, avatar: row.avatar, thumb: row.thumb, seed: row.seed, seconds: 60 }), 0); return id; },
    gone(id, expired) { const o = AD.inbox.find(x => x.id === +id); if (!o) return false; AD.inbox = AD.inbox.filter(x => x !== o); setTimeout(() => Bridge.emit('airdrop:gone', { id: o.id, expired: !!expired }), 0); return true; },
    reset() { AD.out = []; AD.inbox = []; AD.sent = []; AD.answered = []; AD.cancelled = []; AD.cool = {}; AD.auto = null; },
  };

  /* Entrada e saída passam por JSON, como no jogo (NUI → Lua → servidor é sempre serializado). Sem isto o mock
     guardava REFERÊNCIAS: o account.update gravava o próprio System.state como `settings` da conta e a troca de
     personagem (que repõe o state no mesmo objeto) reescrevia em memória a conta da personagem anterior.
     Promessas (handlers registados pelas apps) passam tal e qual. */
  const copy = v => { if (!v || typeof v !== 'object' || typeof v.then === 'function') return v; try { return JSON.parse(JSON.stringify(v)); } catch (e) { return v; } };
  function rpc(name, data) { seedOnce(); const fn = R[name]; if (!fn) return { error: 'unknown rpc ' + name }; try { return copy(fn(copy(data) || {})); } catch (e) { console.error('[localdb]', name, e); return { error: e.message }; } }
  /* apps registam aqui o fallback de browser dos seus RPCs: LocalDB.register('x.y', d => ...) */
  function register(name, fn) { R[name] = fn; }
  /* O NotifyPlayer/NotifyCitizen do servidor, para o browser: grava na tabela e envia o push
     `notification` com o `id` da linha (é assim que o Notify liga o cartão ao histórico do servidor).
     opts = { icon, image, duration, actions = [{ id, label }], type, persist } - persist:false não grava.
     Como o servidor, as ações (id ≤ 32, label ≤ 40, máx. 3), o tipo e a duração ficam gravados com a linha. */
  function notify(app, title, msg, data, opts = {}) {
    seedOnce();
    const acts = Array.isArray(opts.actions) ? opts.actions.filter(a => a && a.id != null && a.id !== '' && a.label != null && a.label !== '').slice(0, 3).map(a => ({ id: String(a.id).slice(0, 32), label: String(a.label).slice(0, 40) })) : [];
    const dur = Number(opts.duration);
    const row = { owner: cid(), app: String(app || 'system').slice(0, 32), title: String(title == null ? '' : title).slice(0, 80), msg: msg == null ? null : String(msg).slice(0, 255), data: data == null ? null : copy(data),
      icon: opts.icon || null, image: opts.image || null, actions: acts.length ? acts : null, type: ['banner', 'silent', 'island', 'lock'].includes(opts.type) ? opts.type : null,
      duration: dur > 0 ? Math.floor(Math.min(dur, 120000)) : null, read: false, delivered: true, created: now() };
    /* id pequeno e sempre a subir, como o AUTO_INCREMENT da tabela: o uid() do mock (≈1,7e14) passava do 1e11 e o
       notifs.list lia o `before` como uma data em vez de um id */
    if (opts.persist !== false) { const nx = Math.max(+G.get('mock:notifSeq', 0) || 0, T('notifications').all().reduce((m, n) => Math.max(m, +n.id < 1e11 ? +n.id : 0), 0)) + 1; G.set('mock:notifSeq', nx); row.id = nx; T('notifications').insert(row); } else row.id = null;
    const push = { id: row.id || undefined, app: row.app, title: row.title, msg: row.msg || '', icon: row.icon || undefined, image: row.image || undefined, duration: row.duration || undefined, actions: row.actions || undefined, type: row.type || undefined, data: row.data || undefined };
    Object.keys(push).forEach(k => push[k] === undefined && delete push[k]);
    setTimeout(() => Bridge.emit('notification', push), 0);
    return row;
  }
  /* multicharacter no browser: muda a personagem do "servidor" e manda o push `session` */
  function switchCharacter(c) { const id = String(c || '').replace(/[^A-Za-z0-9_-]/g, '').slice(0, 64); if (!id) return false; G.set('mock:cid', id); setTimeout(() => Bridge.emit('session', { citizenid: id }), 0); return true; }
  /* só para o harness: esquece as tentativas falhadas e o bloqueio do código (senão um teste de bloqueio deixava os seguintes 30 s sem desbloquear) */
  function resetPinLock(c) { if (c) delete pinTry[c]; else Object.keys(pinTry).forEach(k => delete pinTry[k]); }
  return { rpc, T, player, savePlayer, register, me, uid, now, notify, switchCharacter, resetPinLock, PIN_LOCK, airdrop: AD, get cid() { return cid(); } };
})();

/* ---------- Mock dos callbacks do client.lua (browser) ---------- */
window.Mock = (() => {
  let gpsTimer = null, pos = { x: 215.8, y: -810.1, heading: 90 };
  /* Android no browser/harness: index.html#android ou _shot.html#android&frame=s26-violet (o jogo manda os mesmos campos
     a partir do item usado: Config.Devices[item].os / .frame) */
  /* dobraveis (2026-10-01): &frame=fold-night|fold-star (PearPhone Fold, iOS) e &frame=flip-lavender|grey|cream|pistachio
     (NOVA Fold8, Android); a moldura flip-* liga o Android sozinha, como o item faz no jogo */
  const mockOS = () => /(^|[#&])(android|os=android|frame=flip-[\w]+)(&|$)/.test(location.hash || '') ? 'android' : 'ios';
  const mockFrame = () => { const m = /(^|[#&])frame=([\w-]+)/.exec(location.hash || ''); return m ? m[2] : (mockOS() === 'android' ? 's26-black' : 'orange'); };
  const MOCK_MODEL = { 'fold-night': 'PearPhone Fold', 'fold-star': 'PearPhone Fold', 'flip-lavender': 'NOVA Fold8', 'flip-grey': 'NOVA Fold8', 'flip-cream': 'NOVA Fold8', 'flip-pistachio': 'NOVA Fold8' };
  /* idioma no harness: &lang=en|de|ja… vira o idioma por omissão do `ready` (o Config.DefaultLanguage do jogo) e fica
     preso quando a conta arranca. Sem a flag o mock continua em português (os testes contam com isso). */
  const mockLang = () => { const m = /(^|[#&])lang=([\w-]+)/.exec(location.hash || ''); return m ? m[2] : null; };
  if (window.Bridge && Bridge.on) Bridge.on('ready', () => { const c = mockLang(); if (c && window.System && System.state && System.state.lang !== c) System.setState({ lang: c }, { noSave: true }); });
  const M = {
    /* os campos novos do `ready` (Fase 1) com os valores por omissão do config.lua */
    ready: () => ({ inFiveM: false, defaultPin: '1225', frame: mockFrame(), os: mockOS(), model: MOCK_MODEL[mockFrame()] || null, android: { brand: 'NOVA', model: 'NOVA S26 Ultra', osName: 'Nova UI', osVersion: '9', store: 'NOVA Store' }, scale: 1, player: LocalDB.player(), defaultLang: mockLang() || 'pt', defaultTheme: 'light', veraKey: '', debug: false, safeZone: null, pinLock: { attempts: LocalDB.PIN_LOCK.attempts }, allowWalking: false, showCursor: true,
      /* Fase 2: Config.Messages / Config.Media / Config.Mail com os valores do config.lua (o client/main.lua manda os do servidor) */
      messages: { pageSize: 30, editWindowMin: 15, deleteForAllMin: 60, typingMs: 3000, reactions: ['❤️', '👍', '😂', '😮', '😢', '🙏'], maxGroupMembers: 32 },
      media: { maxImageBytes: 260000, maxAudioSec: 60, maxAudioBytes: 700000, chunkBytes: 48000 },
      mail: { maxAttachments: 4, draftsMax: 50 },
      /* 1.3.1: Config.VideoCall com os valores do config.lua (o vídeo da videochamada, apps/facecall.js) */
      videoCall: { fps: 8, width: 144, height: 192, quality: 0.5, minQuality: 0.25, maxQuality: 0.65, maxKB: 8, pipQuality: 0.5, pipFps: 30 } }),
    close: () => ({ ok: true }),
    /* Devolve uma imagem CRUA como o jogo devolve (data: URL grande), para o caminho real da câmara - recortar, reduzir e guardar
       em base64 - ser exercitado também no browser e no harness, e não só dentro do FiveM. */
    takePhoto: () => { try {
      const c = document.createElement('canvas'); c.width = 1280; c.height = 720; const x = c.getContext('2d');
      const gr = x.createLinearGradient(0, 0, 1280, 720); const h = Math.floor(Math.random() * 360);
      gr.addColorStop(0, `hsl(${h},70%,58%)`); gr.addColorStop(1, `hsl(${(h + 120) % 360},60%,28%)`); x.fillStyle = gr; x.fillRect(0, 0, 1280, 720);
      x.fillStyle = 'rgba(255,255,255,.28)'; for (let i = 0; i < 26; i++) { x.beginPath(); x.arc(Math.random() * 1280, Math.random() * 720, 10 + Math.random() * 90, 0, 6.283); x.fill(); }
      return { raw: c.toDataURL('image/jpeg', .85) };
    } catch (e) { return { seed: 200 + Math.floor(Math.random() * 700) }; } },
    cameraMode: () => ({ ok: true }), flashlight: () => ({ ok: true }), notify: () => ({ ok: true }), setWaypoint: () => ({ ok: true }), removeWaypoint: () => ({ ok: true }),
    getCoords: () => pos,
    startGPS: () => { clearInterval(gpsTimer); gpsTimer = setInterval(() => { pos.x += (Math.random() - .5) * 6; pos.y += (Math.random() - .5) * 6; pos.heading = (pos.heading + 3) % 360; Bridge.emit('coords', pos); }, 500); return { ok: true }; },
    stopGPS: () => { clearInterval(gpsTimer); return { ok: true }; },
    callAction: () => ({ ok: true }), playAnim: () => ({ ok: true }), earbuds: () => ({ ok: true }), openApp: () => ({ ok: true }),
    lang: d => { Mock.lastLang = d && d.code; return { ok: true }; },   /* o NUI diz ao cliente o idioma (avisos do jogo, chat) */
  };
  return { call: (n, d) => M[n] ? M[n](d) : null };
})();
