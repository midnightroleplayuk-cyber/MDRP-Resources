/* ===================== REDES SOCIAIS - Instashot · Tweeter · Reels (motor partilhado) ===================== */
(() => {
  const g = UI.g;
  const rpc = Bridge.rpc;
  const profileCache = {};
  /* O PERFIL EM CACHE É DE UMA IDENTIDADE (4 nov 2026). Trocar de personagem (multicharacter), entrar/sair de um telemóvel alheio
     (StolenPhones / SIM física) ou repor o telemóvel (Definições › Repor, /phonereset apaga as contas sociais no servidor) não
     recarrega a página: o Tweeter abria com a conta ANTERIOR, cada publicação/gosto/comentário voltava 'noprofile' e o "Fecha e
     volta a abrir a app" não ajudava, porque o ensureProfile servia a mesma cache. Agora a cache esvazia-se nas duas trocas. */
  const dropProfiles = () => { Object.keys(profileCache).forEach(k => { delete profileCache[k]; }); Object.keys(pendingShare).forEach(k => { delete pendingShare[k]; }); };
  /* PARTILHAR DAS FOTOS (6 nov 2026): o photos.js abria a app e emitia o social:compose 400 ms depois, à sorte. O ouvinte só nasce no fim do
     ensureProfile: com o social.profile lento, ou no primeiro registo (o formulário fica à espera do jogador), o evento caía no vazio e a
     fotografia perdia-se sem aviso. Agora fica guardada aqui e quem a consome é o fim do `then` de cada app; com a app já de pé vai pelo
     mesmo evento de sempre. Cinco minutos de validade: quem desistiu do registo não leva com ela na semana seguinte. */
  /* 12 nov 2026: a partilha leva também o DESTINO (`kind`: 'post' | 'story' | 'reel'): um vídeo das Fotos pode ir para a story ou para os
     Reels do Instashot, e não só para uma publicação. takeShare devolve { photo, kind } ou null. */
  const pendingShare = {};
  const takeShare = app => { const s = pendingShare[app]; delete pendingShare[app]; return s && Date.now() - s.at < 300000 ? { photo: s.photo, kind: s.kind || 'post' } : null; };
  window.SocialShare = {
    /* um vídeo que o servidor vai recusar (rede/sítio desligado, longo ou grande demais) é recusado JÁ, com o motivo, antes de abrir a app */
    async send(app, photo, kind) {
      if (photo && photo.video) { const bad = await SV.precheck(photo, kind === 'story' ? 'stories' : kind === 'reel' ? 'reels' : app); if (bad) { SV.alert(bad); return; } }
      pendingShare[app] = { photo, kind: kind || 'post', at: Date.now() }; System.openApp(app); if (pendingShare[app]) Bridge.emit('social:compose', { app });
    },
    /* os destinos de um vídeo da galeria (folha de partilha das Fotos), só os que o servidor deixa e as apps instaladas */
    async videoTargets() {
      const c = await SV.cfg(), inst = id => !window.System || !System.isInstalled || System.isInstalled(id), out = [];
      if (inst('instashot')) {
        if (SV.okIn(c, 'instashot')) out.push({ app: 'instashot', kind: 'post', label: 'Publicar no Instashot', short: App.name('instashot') || 'Instashot', icon: 'camera' });
        if (SV.okIn(c, 'stories')) out.push({ app: 'instashot', kind: 'story', label: 'Publicar na story', short: 'Story', icon: 'plusCircle' });
        if (SV.okIn(c, 'reels')) out.push({ app: 'instashot', kind: 'reel', label: 'Publicar nos Reels', short: 'Reels', icon: 'reels' });
      }
      if (inst('twix') && SV.okIn(c, 'twix')) out.push({ app: 'twix', kind: 'post', label: 'Publicar no Tweeter', short: App.name('twix') || 'Tweeter', icon: 'hash' });
      return out;
    },
  };
  Bridge.on('session:changed', dropProfiles); Bridge.on('factory:reset', dropProfiles);
  /* Config.Social com a rede desligada: o servidor responde { error:'off' } a TODOS os social.* (server/social.lua:1588-1616).
     Com o rpc() normal isso virava null, a app abria o formulário de criar conta, o createProfile
     respondia 'off' outra vez e o jogador lia «Nome em uso · Escolhe outro nome» - mentira dupla. */
  function lightView(app, win, title) {
    /* a Reels declara `statusBar: 'dark'` (o feed dela é preto de ecrã inteiro) e ESTE ecrã é claro:
       sem isto a hora, os ícones da barra de estado e a barra de baixo ficavam brancos sobre branco.
       Repõe-se no fecho da janela, como o Match faz com o mesmo campo. */
    const d = App.get(app);
    if (d && d.statusBar) { const antes = d.statusBar; d.statusBar = undefined; const prevClose = win.onClose; win.onClose = () => { d.statusBar = antes; prevClose && prevClose(); }; if (System.updateSbTheme) System.updateSbTheme(); }
    return UI.view({ title: title || App.name(app) || '', large: true });
  }
  function offView(app, win) {
    const v = lightView(app, win);
    v.content.appendChild(UI.empty('ban', 'Rede desligada', 'Esta rede está desligada neste servidor.'));
    UI.setRoot(win, v);
  }
  /* 1.1.6: o que dizer de um código de erro do servidor (as frases já existem nos dicionários) */
  /* 1.4.1: os códigos novos do servidor (server/social.lua classifica os erros de SQL). Antes destes, todos diziam "Tenta novamente." e o jogador
     e o dono do servidor ficavam sem saber se era a personagem a carregar, a base de dados antiga ou um emoji que a ligação não aceita. */
  const DB_ERR = 'Erro na base de dados do servidor. Avisa um administrador.', HOST_ERR = 'Esse endereço de imagem não é permitido neste servidor.';
  const ERR_MSG = { db: 'A base de dados ainda está a arrancar. Tenta daqui a pouco.', ratelimit: 'Demasiados pedidos seguidos. Espera um momento.', internal: 'Erro no servidor. Vê a consola do servidor.',
    noplayer: 'A tua personagem ainda está a carregar. Tenta daqui a pouco.', dbschema: DB_ERR, dbcollation: DB_ERR, dbdenied: DB_ERR, dbcharset: 'O servidor não aceitou esse texto. Tenta sem emojis.', dbbusy: 'A base de dados está ocupada. Tenta daqui a pouco.',
    foreign: 'Este telemóvel não é teu: não dá para publicar nesta conta.', locked: 'Desbloqueia o telemóvel primeiro.', host: HOST_ERR, disabled: HOST_ERR };
  const errMsg = code => ERR_MSG[code] || 'Tenta novamente.';
  /* ---------- A FOTOGRAFIA DE UMA PUBLICAÇÃO NUNCA VAI INTEIRA NO social.post (2 nov, "why cant i post in tweeter") ----------
     Os três compositores mandavam o data URL inteiro (100-260 KB) dentro do social.post, num único evento de rede, que o
     FiveM deita fora: o pedido nunca chegava, o cliente esgotava os 10 s e aparecia "Não publicado · Tenta novamente".
     Só os posts de texto saíam. Uma foto escolhida na galeria JÁ está no servidor (subiu aos bocados pelo photos.upload)
     e tem `id`: vai só o `photoId` e é o servidor que copia o url dela para a publicação (server/social.lua, social.post).
     Sem id (foto editada que ainda não está na galeria) guarda-se primeiro com Photos.save, que também vai aos bocados.
     Só o que é pequeno continua inline em `image`: o seed (gradiente) ou um endereço http. Devolve os campos a juntar ao
     social.post, ou { error } com os mesmos códigos do servidor. */
  async function postImage(photo) {
    if (!photo) return {};
    /* VÍDEO da galeria (12 nov 2026): vai só o id; o servidor verifica e copia o vídeo para a publicação (server/social.lua, takeVideo) */
    if (photo.video) return photo.id ? { videoId: photo.id } : { error: 'novideo' };
    if (photo.id) return { photoId: photo.id };
    const u = typeof photo.url === 'string' ? photo.url : '';
    if (u.slice(0, 5) === 'data:') {
      const s = await Photos.save(u, photo.seed ? { seed: photo.seed } : {});
      if (!s || s.error || !s.id) return { error: s && s.error ? String(s.error) : 'photo' };   /* o código verdadeiro (timeout, ratelimit, base de dados...): tudo dizia "já não está na tua galeria" */
      return { photoId: s.id };
    }
    if (u) return { image: u };
    return photo.seed ? { image: photo.seed } : {};
  }
  /* o que dizer de cada recusa do social.post (as três primeiras frases já existiam nos compositores) */
  const POST_ERR = {
    toolarge: 'A fotografia é grande demais.', off: 'Esta rede está desligada neste servidor.', noprofile: 'Não tens conta nesta rede. Fecha e volta a abrir a app.',
    photo: 'Essa fotografia já não está na tua galeria. Escolhe outra.', video: 'Não dá para publicar um vídeo. Escolhe uma fotografia.',
    badimage: 'Essa imagem não pode ser publicada.',
    timeout: 'O servidor não respondeu. Vê se a publicação apareceu antes de tentares outra vez.',
  };
  const postErr = r => { const c = r && r.error; return SV.errText(r) || POST_ERR[c] || errMsg(c); };
  /* PUBLICAÇÃO RECUSADA (4 nov 2026): os três compositores (Tweeter, Instashot, Reels) dizem o mesmo e da mesma maneira.
     · o CÓDIGO vai por baixo da frase (UI.alert `foot`): "Tenta novamente." sozinho escondia se era ratelimit, db, timeout...;
       false = o servidor respondeu nil ('empty'), null = a chamada NUI nem voltou ('noanswer');
     · console.error, não console.warn: só o error é reencaminhado para a consola F8 (bridge.js, jsError);
     · 'noprofile' fecha a app DE FACTO depois do OK (staleProfile), para o "Fecha e volta a abrir a app" do aviso ser verdade.
     O campo da folha (que ainda tem o foco - os botões do cabeçalho já não o tiram) é largado pelo próprio UI.alert, que o faz
     para todas as apps: aqui largava-se QUALQUER campo do documento, também o de outra app onde o jogador já estivesse a escrever.
     `sh` = a folha do compositor (fecha com a app no 'noprofile'); a câmara dos Reels não tem folha. */
  const refused = (app, r, sh) => {
    const code = r && r.error ? String(r.error) : r === false ? 'empty' : r == null ? 'noanswer' : 'unknown';
    if (code === 'noprofile') delete profileCache[app];
    console.error('[apex_phone] social.post refused (' + app + '): ' + code);
    UI.alert({ title: 'Não publicado', msg: postErr(r), foot: code }).then(() => { if (code === 'noprofile') staleProfile(app, sh); });
  };
  /* 'noprofile' COM A JANELA VIVA (4 nov 2026): a conta foi apagada no servidor com a app aberta (wipe/reset pelo admin, base de
     dados restaurada; a troca de personagem e a reposição já matam as janelas). Esquecer a cache não bastava: fechar a app só
     manda a janela para segundo plano (System.closeApp → .bg) e reabri-la RETOMA a mesma janela (resume, que estas apps nem têm),
     sem ensureProfile e com o `me` antigo - cada publicação voltava a dar 'noprofile' com o mesmo conselho, em ciclo, e só matar
     a app no switcher resolvia. Agora a folha fecha e a janela morre; a próxima abertura pergunta outra vez ao servidor (e mostra
     o "Criar conta" se for o caso). As folhas vivem no #screen, fora da janela: por isso fecham à parte. */
  function staleProfile(app, sh) {
    delete profileCache[app];
    try { if (sh && sh.close) sh.close(); } catch (e) {}
    if (!window.System || !System.killApp) return;
    try {
      /* a app à vista: fecha como o botão de casa (pausa, tempo de uso, app:close) e só depois morre; o que ainda estiver aberto
         por cima dela (outra folha, um menu) é dela - noutra app não se mexe em nada */
      if (System.currentApp && System.currentApp() === app) { if (UI.dismissAll) UI.dismissAll(); if (System.closeApp) System.closeApp(true); }
      System.killApp(app);
    } catch (e) { console.error('[apex_phone] social noprofile', e); }
  }
  /* PUBLICAR A PARTIR DE UMA FOLHA (4 nov 2026): a folha FICA ABERTA enquanto o pedido corre (botão "A publicar…") e só fecha
     quando o servidor diz que sim. Antes o onDone devolvia undefined e a folha fechava no próprio clique, ANTES de o social.post
     sair: numa recusa ou num tempo esgotado o texto e a fotografia perdiam-se, e o "A publicar…" do Instashot nunca se via (a
     folha já tinha saído). Na recusa o botão volta ao rótulo dele e o rascunho fica lá para tentar outra vez.
     Devolve false (o onDone mantém a folha aberta); `done(row)` corre depois do sucesso e do fecho. */
  function postFromSheet(sh, label, app, photo, data, done) {
    if (!sh || sh._busy) return false;
    const btn = sh.el.querySelector('.sh-r'); sh._busy = true;
    btn.textContent = 'A publicar…'; btn.style.opacity = '.5'; sh.el.classList.add('posting');
    const back = () => { sh._busy = false; btn.textContent = label; btn.style.opacity = ''; sh.el.classList.remove('posting'); };
    /* prazo só no social.post (a subida de uma fotografia aos bocados pode demorar): um callback que nunca volte deixava a folha presa em
       "A publicar…" para sempre, sem aviso nem código. O cliente já desiste aos 10 s; isto apanha o caso em que nem ele responde. */
    const postOnce = im => Promise.race([Bridge.rpcRaw('social.post', Object.assign({ app }, data, im)), new Promise(res => setTimeout(() => res({ error: 'timeout' }), 20000))]);
    postImage(photo).then(im => im.error ? im : postOnce(im))
      .catch(e => { console.error('[apex_phone] social.post', e); return { error: 'client' }; })
      .then(r => { if (!r || r.error) { back(); refused(app, r, sh); return; }
        Sound.play('success'); UI.toast('Publicado'); sh.close(); if (done) { try { done(r); } catch (e) { console.error('[apex_phone] social.post done', e); } } });
    return false;
  }
  /* o código vai num elemento à parte: os nós de texto ficam iguais às chaves dos dicionários (o tradutor do DOM compara a frase inteira;
     é o data-noi18n que o deixa de fora - o data-raw sozinho o i18n.js não conhece) */
  const errCode = code => UI.el('<div class="group-footer" style="text-align:center" data-raw data-noi18n>' + UI.esc(String(code || '')) + '</div>');
  /* 1.1.6: um ERRO do servidor (base de dados a arrancar depois de um restart, limite de pedidos, erro interno) já não
     abre o formulário "Criar conta" nem deixa o ecrã vazio: mostra o motivo e um botão para tentar outra vez. Era o
     mesmo defeito do arranque do telemóvel (1.1.5): "sem resposta" era lido como "não há conta" e o jogador tentava
     criar uma conta que já tinha ("Nome em uso", sem nada a vermelho em lado nenhum). */
  function errView(app, win, code, retry) {
    const v = lightView(app, win);
    v.content.appendChild(UI.empty('ban', 'Sem resposta do servidor', errMsg(code)));
    v.content.appendChild(errCode(code));
    const b = UI.el('<div class="btn-p">Tentar outra vez</div>'); b.onclick = () => retry(); v.content.appendChild(b);
    UI.setRoot(win, v);
  }
  /* 1.1.6: só 'taken'/'invalid' são "Nome em uso"; sem resposta ou erro do servidor diz-se o que é */
  const createErr = why => UI.alert(why === 'off' ? { title: 'Rede desligada', msg: 'Esta rede está desligada neste servidor.' }
    : why === 'exists' ? { title: 'Já tens conta', msg: 'Já existe uma conta tua nesta rede. Fecha e volta a abrir a app.' }
    : (why === 'taken' || why === 'invalid') ? { title: 'Nome em uso', msg: 'Escolhe outro nome de utilizador.' }
    : { title: 'Sem resposta do servidor', msg: errMsg(why) });
  /* o nome da conta do telemóvel pode ter espaços e acentos ("Ana Silva", "João") e o servidor só aceita [a-z0-9_.]: o campo vinha preenchido
     com um nome que era recusado no primeiro toque ("Nome em uso", sem nada a ver). Sugere-se a versão válida. */
  const safeUser = s => String(s || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_.]/g, '').slice(0, 16);
  async function ensureProfile(app, win, then) {
    let p = profileCache[app];
    if (!p) { const r = await Bridge.rpcRaw('social.profile', { app }); if (r && r.error === 'off') { offView(app, win); return; }
      if (r && r.error) { errView(app, win, r.error, () => ensureProfile(app, win, then)); return; }
      p = r || null; profileCache[app] = p; }
    if (p && p.username) { then(p); return; }
    if (app === 'twix') { xSignup(win, then); return; }   /* o registo com o desenho do X */
    /* formulário curto: fica CENTRADO na vertical em vez de encostado ao topo com meio ecrã vazio por baixo */
    const v = UI.view({ title: 'Criar conta', large: true, cls: 'soc-signup' });
    const acc = System.account || {}; let avatar = acc.avatar || 1;
    let avatarUrl = null;
    v.content.appendChild(UI.el(`<div class="profile" style="flex-direction:column;justify-content:center"><div class="pvwrap"></div><div class="sub">Toca para pôr uma fotografia</div></div>`));
    const wrap0 = v.content.querySelector('.pvwrap');
    const paint0 = () => {
      wrap0.innerHTML = UI.avatar({ name: acc.username || 'eu', avatar, url: avatarUrl }, 'lg');
      wrap0.firstElementChild.onclick = async () => {
        const k = await UI.actionSheet({ title: 'Foto de perfil', buttons: [{ label: 'Escolher das minhas fotos', icon: 'photo', value: 'pick' }, { label: 'Usar uma cor', icon: 'personCircle', value: 'col' }] });
        if (k === 'pick') {
          const p = await Photos.pick('Foto de perfil');
          if (!p) return;
          const src = await Photos.data(p);
          const small = src && await Photos.square(src, 112, .68);
          if (small) { avatarUrl = small; paint0(); } else UI.toast('Não consegui usar essa foto');
        } else if (k === 'col') { avatar = avatar % 12 + 1; avatarUrl = null; paint0(); }
      };
    };
    paint0();
    v.content.appendChild(UI.list([{ items: [{ html: `<input type="text" class="un" placeholder="nome_de_utilizador" maxlength="16" value="${UI.esc(safeUser(acc.username))}" autocapitalize="off">`, cls: 'static' }, { html: `<input type="text" class="bio" placeholder="Bio" maxlength="80">`, cls: 'static' }] }, { footer: 'O nome é público e único nesta rede.' }]));
    const b = UI.el('<div class="btn-p">Criar conta</div>'); b.onclick = async () => { const u = v.content.querySelector('.un').value.trim().toLowerCase(); if (!/^[a-z0-9_.]{3,16}$/.test(u)) { UI.toast('Nome inválido (3-16, letras/números/_/.)'); return; }
      if (window.CC && CC.requireNet && !CC.requireNet('criar a conta')) return;
      /* rpcRaw: o servidor distingue 'off' (rede desligada no Config.Social), 'exists' (já cá tens conta)
         e 'taken' (nome ocupado) - com o rpc() normal os três davam «Nome em uso», e dois deles são falsos */
      const r = await Bridge.rpcRaw('social.createProfile', { app, username: u, bio: v.content.querySelector('.bio').value.trim(), avatar });
      if (!r || r.error) { createErr(r && r.error); return; }
      /* a foto vai num segundo passo: o createProfile não a aceita e não vale a pena
         mudar a assinatura só por isto - se falhar, a conta fica na mesma com a cor */
      if (avatarUrl) { const r2 = await rpc('social.updateProfile', { app, avatarUrl }); if (r2 && !r2.error) Object.assign(r, r2); }
      profileCache[app] = r; Sound.play('success'); then(r); };
    v.content.appendChild(b);
    v.content.appendChild(UI.el(`<div class="group-footer" style="text-align:center;padding-top:14px">Esta conta é só desta rede. O teu número não é mostrado a ninguém.</div>`));
    UI.setRoot(win, v);
  }
  /* o avatar pode ser uma COR (índice) ou uma FOTOGRAFIA tirada com o telemóvel:
     o UI.avatar já sabe mostrar `url`, só faltava passá-lo daqui */
  const av = (u, cls) => UI.avatar({ name: u.username || u.author || '?', avatar: u.avatar, url: u.avatarUrl || u.avatar_url || null }, cls);
  /* reduz uma foto da galeria a um quadrado pequeno: a foto de perfil viaja dentro do
     feed, da pesquisa e das listas, por isso tem de ser leve (≈3-5 KB) */
  async function avatarFromPhotos(title) {
    const p = await Photos.pick(title || 'Foto de perfil');
    if (!p) return null;
    const src = await Photos.data(p);
    if (!src) { UI.toast('Não consegui abrir essa foto'); return null; }
    const small = await Photos.square(src, 112, .68);
    if (!small) { UI.toast('Não consegui reduzir a foto'); return null; }
    return small;
  }
  const timeAgo = ts => UI.timeAgo(ts);
  const VERIFIED = ['lb', 'admin', 'record', 'weazel_news', 'lspd_official'];
  const vb = u => VERIFIED.includes(String(u || '').toLowerCase()) ? '<span class="vbadge">✓</span>' : '';
  const splitLoc = c => { c = c || ''; if (c.startsWith('📍')) { const i = c.indexOf('\n'); return { loc: (i > -1 ? c.slice(2, i) : c.slice(2)).trim(), text: i > -1 ? c.slice(i + 1) : '' }; } return { loc: '', text: c }; };
  /* A LISTA DOS COMENTÁRIOS CRESCE COM O TECLADO EM CIMA (4 nov 2026): o place() do teclado (shell/keyboard.js) mede a folha UMA vez,
     no focusin, e sobe-a uma altura fixa (--kb-shift); só a encolhe (.kb-tall) se ela já for alta demais nesse instante. Com o Enviar
     a deixar o foco no campo e a lista sem o teto de 46vh, cada comentário novo (e o carregamento que chega depois de se tocar no
     campo) esticava a folha para CIMA: ao 3.º envio o cabeçalho e o "Fechar" saíam do ecrã e as linhas passavam por trás da ilha.
     Depois de cada pintura a folha volta a ser medida (Keyboard.refit, sem animação): encolhe até à barra de estado e a lista rola. */
  const kbRefit = inp => { try { if (window.Keyboard && Keyboard.visible && Keyboard.refit && document.activeElement === inp) Keyboard.refit(); } catch (e) {} };
  /* comentar: o campo limpa-se logo (como num chat), mas numa recusa o texto VOLTA e o jogador sabe porquê; antes o rpc() engolia o erro e o comentário perdia-se em silêncio */
  async function sendComment(app, data, inp, text) {
    const r = await Promise.resolve(Bridge.rpcRaw('social.comment', Object.assign({ app }, data))).catch(() => null);
    if (r && !r.error) return true;
    if (inp && !inp.value) inp.value = text;
    console.error('[apex_phone] social.comment refused (' + app + '): ' + (r && r.error || 'empty')); UI.toast(postErr(r)); return false;
  }
  async function commentsSheet(app, post, onCount) {
    /* o compositor vai PRESO ao fundo da folha (UI.sheet `foot`, 4 nov 2026): dentro do corpo ficava no fim de uma lista sem
       teto e, com muitos comentários, era preciso rolar até ao fim para o encontrar. O Enviar não tira o foco ao campo
       (preventDefault no pointerdown): o teclado fica e pode-se escrever o comentário seguinte, como num chat. */
    const body = UI.el('<div></div>'); const list = UI.el('<div></div>'); const comp = UI.el(`<div class="composer" style="border-top:.5px solid var(--sep);background:none"><input type="text" placeholder="Adicionar comentário…" maxlength="200"><div class="send">${g('arrowUp')}</div></div>`); body.append(list);
    comp.querySelector('.send').addEventListener('pointerdown', e => e.preventDefault());
    const paint = async () => { const cs = fillAvatars((await rpc('social.comments', { app, postId: post.id })) || []); list.innerHTML = ''; if (!cs.length) { const em = UI.empty('chat', 'Sem comentários', 'Sê o primeiro a comentar.'); em.classList.add('compact'); list.appendChild(em); } const liked = Store.get('cmtLikes', []); cs.forEach(c => { const r = UI.el(`<div class="ig-cmt-row">${av(c, 'xs')}<div style="flex:1;font-size:var(--t-subhead)"><b>${UI.esc(c.username)}</b>${vb(c.username)} ${UI.linkify(c.content)}<div class="muted small">${timeAgo(c.created)} · <span class="rep" style="cursor:pointer">Responder</span></div></div><div class="lk ${liked.includes(c.id) ? 'on' : ''}">${g(liked.includes(c.id) ? 'heartFill' : 'heart')}</div></div>`); r.querySelector('.rep').onclick = () => { const i = comp.querySelector('input'); i.value = '@' + c.username + ' '; i.focus(); }; r.querySelector('.lk').onclick = ev => { const on = ev.currentTarget.classList.toggle('on'); ev.currentTarget.innerHTML = g(on ? 'heartFill' : 'heart'); Store.update('cmtLikes', [], l => { const i = l.indexOf(c.id); if (on && i < 0) l.push(c.id); if (!on && i > -1) l.splice(i, 1); }); }; list.appendChild(r); }); onCount && onCount(cs.length); kbRefit(comp.querySelector('input')); };
    const send = async () => { const i = comp.querySelector('input'), t = i.value.trim(); if (!t) return; i.value = ''; if (!(await sendComment(app, { postId: post.id, content: t }, i, t))) return; await paint(); };
    comp.querySelector('.send').onclick = send; comp.querySelector('input').onkeydown = e => { if (e.key === 'Enter') send(); };
    UI.sheet({ title: 'Comentários', right: 'Fechar', body, foot: comp }); paint();
  }
  /* gostar escreve no servidor: sem rede o coração ficava virado e o contador subia por nada */
  async function toggleLike(app, post, el, countEl) { if (window.CC && CC.requireNet && !CC.requireNet('gostar')) return; const r = await rpc('social.like', { app, postId: post.id }); if (!r) return; post.liked = r.liked; post.likes += post.liked ? 1 : -1; if (el) { el.classList.toggle('liked', post.liked); el.innerHTML = g(post.liked ? 'heartFill' : 'heart'); } if (countEl) countEl.textContent = post.likes; if (post.liked) Sound.play('pop'); }
  /* "Copiar ligação" saiu (2026-09-20): não copiava nada, só dizia que sim */
  async function share(app, post) { const v = await UI.actionSheet({ title: 'Partilhar', buttons: [{ label: 'Enviar por mensagem', icon: 'message', value: 'msg' }] }); if (v === 'msg') { const c = await Contacts.pick('Enviar a'); if (c) { /* a fotografia pode ainda não ter descido (vem aos bocados): vai-se buscá-la antes de enviar */ const im = hasImg(post) ? await media.get(post) : null; if (hasImg(post) && !im) { UI.toast('Não consegui enviar a fotografia'); return; } /* Fase 2: a foto vai aos bocados pelo Msgs.sendPhoto (media.* + mediaId); o data: URL inteiro num só messages.send era cortado pelo FiveM e o pedido ficava sem resposta */ if (im && window.Msgs && typeof Msgs.sendPhoto === 'function') { const r = await Msgs.sendPhoto(c.number, im); UI.toast(r && !r.error ? 'Enviado' : 'Não consegui enviar a fotografia'); return; } const sm = await rpc('messages.send', { to: c.number, type: im ? 'image' : 'text', content: im ? 'Foto' : `@${post.author}: ${post.content}`, payload: im ? { url: typeof im === 'string' ? im : null, seed: typeof im === 'number' ? im : null } : null });
      /* o "Enviado" era incondicional: o messages.send pode recusar (sem conversa, número inválido, rede) */
      UI.toast(sm && !sm.error ? 'Enviado' : 'Não consegui enviar'); } } }   /* o "Repost" que aqui havia saiu: no X vive só na folha do botão de repost (repostSheet), que sabe desfazê-lo e não duplica */
  const imgCss = im => im ? (typeof im === 'number' ? photoBg(im) : `url("${im}")`) : '';

  /* ---------- FOTOGRAFIAS DAS PUBLICAÇÕES AOS BOCADOS ----------
     As listas do servidor (feed, perfil, hashtag, respostas, guardados) deixaram de trazer o base64:
     uma página de 12 publicações eram 1-3 MB num único evento de rede. Uma fotografia a sério vem só
     com `imageLen` e desce pelo `social.post.media` em bocados de 48 KB, como as stories e as Fotos;
     seeds e endereços curtos continuam a vir na própria publicação (`image`).
     · só se pede quando a peça está perto do ecrã (lazyBg) ou é mostrada sozinha (loadNow);
     · no máximo 2 fotografias a descer ao mesmo tempo: cada bocado é um RPC e 12 em paralelo era
       pedir tempos esgotados;
     · as últimas 24 ficam em cache por id - voltar atrás no scroll ou abrir a publicação não repete. */
  const hasImg = p => !!(p && (p.image || p.imageLen));
  const media = (() => {
    const cache = new Map(), jobs = new Map(), queue = [];
    let running = 0;
    const keep = (id, v) => { cache.delete(id); cache.set(id, v); while (cache.size > 24) cache.delete(cache.keys().next().value); };
    const download = async p => {
      const total = Math.ceil(p.imageLen / (p.chunk || 48000));
      if (!total || total > 64) return null;
      let out = '';
      for (let i = 1; i <= total; i++) {
        const r = await Bridge.rpcRaw('social.post.media', { id: p.id, i });
        if (!r || r.error || typeof r.data !== 'string') return null;
        out += r.data;
        if (!r.data.length) break;
      }
      return out || null;
    };
    const pump = () => {
      while (running < 2 && queue.length) {
        const job = queue.shift();
        /* a peça saiu de perto do ecrã enquanto esperava a vez: não se gasta a rede com ela */
        if (job.want && !job.want()) { jobs.delete(job.id); job.done(null); continue; }
        running++;
        download(job.p).catch(() => null).then(v => { running--; jobs.delete(job.id); if (v) keep(job.id, v); job.done(v); pump(); });
      }
    };
    /* `want` (opcional): ainda interessa quando chegar a vez? Sem ele o pedido é incondicional. */
    const get = (p, want) => {
      if (!p) return Promise.resolve(null);
      if (p.image) return Promise.resolve(p.image);
      if (!p.imageLen) return Promise.resolve(null);
      if (cache.has(p.id)) { const v = cache.get(p.id); keep(p.id, v); return Promise.resolve(v); }
      const j = jobs.get(p.id);
      if (j) { const w0 = j.want; j.want = (w0 && want) ? () => w0() || want() : null; return j.pr; }
      const job = { id: p.id, p, want: want || null };
      job.pr = new Promise(done => { job.done = done; });
      jobs.set(p.id, job); queue.push(job); pump();
      return job.pr;
    };
    return { get };
  })();
  /* fundo de uma peça com fotografia: a inline pinta já; a que vem aos bocados fica marcada em `_post`
     para o lazyBg (ou o loadNow) a ir buscar */
  const postBg = (el, p) => { if (!el || !p) return; if (p.image) { el._bg = imgCss(p.image); el.style.backgroundImage = el._bg; } else if (p.imageLen) el._post = p; };
  const loadNow = el => { const p = el && el._post; if (!p || el._bg) return; media.get(p).then(u => { if (!u) return; el._bg = imgCss(u); el.style.backgroundImage = el._bg; }); };

  /* ---------- FOTOGRAFIAS SÓ QUANDO ESTÃO PERTO DO ECRÃ ----------
     Cada fundo é uma textura decodificada no CEF. Com o scroll infinito o feed juntava DEZENAS ao
     mesmo tempo, todas retidas enquanto a app estivesse aberta. O endereço fica guardado em `_bg` no
     elemento (ou a publicação em `_post`, se a fotografia ainda não desceu) e este observer põe-no
     quando falta menos de um ecrã e tira-o quando se afasta - no máximo ~3 ecrãs de imagens.
     Serve o Instashot e o Tweeter. Morre com a vista. */
  const lazyBg = v => {
    const io = new IntersectionObserver(es => es.forEach(x => {
      const el = x.target; if (!el._bg && !el._post) return;
      el._near = x.isIntersecting;
      if (x.isIntersecting) {
        if (el.style.backgroundImage) return;
        if (el._bg) el.style.backgroundImage = el._bg;
        else media.get(el._post, () => el._near && el.isConnected).then(u => { if (!u) return; el._bg = imgCss(u); if (el._near) el.style.backgroundImage = el._bg; });
      } else el.style.backgroundImage = '';
    }), { root: (v && v.content) || null, rootMargin: '100% 0px' });
    if (v) { const prev = v.opts.onPop; v.opts.onPop = () => { io.disconnect(); prev && prev(); }; }
    return { add: el => { if (el) io.observe(el); }, stop: () => io.disconnect() };
  };
  /* o servidor manda a foto de perfil SÓ no primeiro comentário de cada pessoa (repetida em 200 linhas
     eram MB por abertura); aqui repõe-se nas restantes antes de pintar */
  const fillAvatars = cs => { const m = {}; cs.forEach(c => { if (c.avatarUrl) m[c.username] = c.avatarUrl; }); cs.forEach(c => { if (!c.avatarUrl && m[c.username]) c.avatarUrl = m[c.username]; }); return cs; };

  /* ---------- VÍDEOS NAS REDES (12 nov 2026, "deixa esses vídeos com possibilidade de publicar nas redes sociais") ----------
     Publicar: o compositor manda só o id do vídeo da galeria (postImage → videoId) e o servidor copia-o para a publicação ou story.
     Ver: a publicação traz `video = { id, dur, size }` (id = linha de apex_phone_media) e a capa como fotografia normal. O vídeo
     NUNCA desce sozinho: só quando se carrega no play (feed do Instashot e Tweeter) ou quando o reel/story fica à vista, e:
     · aos bocados pelo media.get, um vídeo de cada vez, ao ritmo PACE (≈ 9 bocados de 48 KB por segundo) e com nova tentativa
       no 'ratelimit'; parar a meio (deslizou para outro reel) guarda o que já desceu e continua dali se voltar;
     · fica em memória como blob: URL (os últimos BLOB_N, até BLOB_MAX bytes): voltar atrás no scroll não descarrega outra vez;
     · um só <video> em todo o telemóvel: começar outro larga o anterior. Pausa quando sai do ecrã (IntersectionObserver), quando
       a vista fica por trás de outra (`.behind`), quando a app vai para segundo plano, quando se guarda ou bloqueia o telemóvel.
     window.SocialVideo é este mesmo objeto (o visualizador e o editor de stories, em stories.js, usam-no). */
  const SV = (() => {
    const T = s => (window.L && L.t ? L.t(s) : s);
    const TF = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
    const sleep = ms => new Promise(r => setTimeout(r, ms));
    /* ---- config do servidor (social.video.config, Config.Recording.social): 30 s em cache; sem resposta = sem vídeos ---- */
    let cfgP = null, cfgAt = 0;
    const cfg = force => {
      if (!cfgP || force || Date.now() - cfgAt > 30000) {
        cfgAt = Date.now();
        cfgP = Promise.resolve(Bridge.rpcRaw('social.video.config', {})).then(r => (r && typeof r === 'object' && !r.error) ? r : { enabled: false, error: (r && r.error) || 'rpc' }).catch(() => ({ enabled: false, error: 'rpc' }));
      }
      return cfgP;
    };
    /* onde se publica → que rede tem de estar ligada (Config.Social); os Reels vivem dentro do Instashot e precisam das duas */
    const NET = { instashot: ['instashot'], stories: ['instashot'], reels: ['instashot', 'reels'], twix: ['twix'], recado: [] };
    const okIn = (c, where) => !!(c && c.enabled && c[where] !== false && (NET[where] || []).every(n => !c.networks || c.networks[n] !== false));
    const allow = async where => okIn(await cfg(), where);
    /* ---- recusas com nome (as do servidor e as que se apanham antes de lá ir) ---- */
    const ERR = {
      videooff: 'Este servidor não permite publicar vídeos aqui.',
      novideo: 'Esse vídeo já não está na tua galeria. Escolhe outro.',
      videolimit: 'Já tens vídeos publicados a mais. Apaga alguns antes de publicar outro.',
      videobusy: 'Espera uns segundos antes de publicar outro vídeo.',
    };
    const errText = r => {
      const c = r && r.error;
      if (c === 'videolong') return TF('O vídeo é demasiado longo para publicar. O máximo é %s.', UI.fmtDur(Math.max(0, Math.floor(+r.maxSec || 0))));
      if (c === 'videobig') return TF('O vídeo é demasiado grande para publicar. O máximo é %s MB.', +r.maxMB > 0 ? +r.maxMB : 8);
      return ERR[c] || null;
    };
    const alert = r => { Sound.play('error'); UI.alert({ title: 'Vídeo não publicado', msg: errText(r) || errMsg(r && r.error), foot: String((r && r.error) || 'empty') }); };
    /* o que o servidor vai recusar, dito já (a galeria sabe a duração em segundos e o tamanho em caracteres) */
    const precheck = async (p, where) => {
      const c = await cfg();
      if (!okIn(c, where)) return { error: 'videooff' };
      if (+c.maxSeconds > 0 && (+p.duration || 0) > +c.maxSeconds + 1) return { error: 'videolong', maxSec: +c.maxSeconds };
      if (+c.maxMB > 0 && +p.len > +c.maxMB * 1e6) return { error: 'videobig', maxMB: +c.maxMB };
      return null;
    };

    /* ---- blobs já descarregados (LRU por bytes) ---- */
    const BLOB_N = 12, BLOB_MAX = 48e6;
    const blobs = new Map(); let blobBytes = 0;
    const inUse = id => !!(cur && cur.mid === id && cur.vid);
    const hit = id => { const b = blobs.get(id); if (!b) return null; blobs.delete(id); blobs.set(id, b); return b.url; };
    const keep = (id, url, bytes) => {
      blobs.set(id, { url, bytes }); blobBytes += bytes;
      for (let n = blobs.size; n > 0 && (blobs.size > BLOB_N || blobBytes > BLOB_MAX) && blobs.size > 1; n--) {
        const [k, b] = blobs.entries().next().value;
        blobs.delete(k);
        if (inUse(k)) { blobs.set(k, b); continue; }   /* o que está a tocar não se revoga: passa para o fim */
        blobBytes -= b.bytes; try { URL.revokeObjectURL(b.url); } catch (e) {}
      }
    };
    const toBlob = s => { const i = s.indexOf(','), mime = (/^data:([^;,]+)/.exec(s) || [])[1] || 'video/webm', bin = atob(s.slice(i + 1)), a = new Uint8Array(bin.length); for (let k = 0; k < bin.length; k++) a[k] = bin.charCodeAt(k); return new Blob([a], { type: mime }); };

    /* ---- descargas: uma de cada vez, aos bocados, ao ritmo PACE ---- */
    /* PACE: ms mínimos entre bocados (150 = ≈ 6,5 bocados de 48 KB por segundo, ≈ 320 KB/s por jogador): um vídeo de 15 s do
       aparelho por omissão desce em ~4 s e vinte pessoas a ver ao mesmo tempo não enchem a ligação do servidor */
    const PACE = 150, MAX_PARTS = 512;
    const partial = new Map();     /* id → { parts, total, size }: no máximo 2 (cada uma pode ter MB) */
    const jobs = new Map(), queue = [];
    let busy = false;
    let stats = { chunks: 0, cacheHits: 0 };   /* para o harness: quantos bocados desceram e quantas vezes a cache poupou a descarga */
    async function run(j) {
      const id = j.id;
      let st = partial.get(id);
      if (!st) { st = { parts: [], total: 1, size: 0 }; partial.set(id, st); while (partial.size > 2) partial.delete(partial.keys().next().value); }
      for (let i = st.parts.length + 1; i <= st.total; i++) {
        if (j.want && !j.want()) return { paused: true };
        const t0 = Date.now();
        let r = await Bridge.rpcRaw('media.get', { id, i });
        for (let k = 0; k < 5 && r && r.error === 'ratelimit'; k++) { await sleep(700 * (k + 1)); if (j.want && !j.want()) return { paused: true }; r = await Bridge.rpcRaw('media.get', { id, i }); }
        if (!r || r.error || typeof r.data !== 'string') { partial.delete(id); return { error: (r && r.error) || 'rpc' }; }
        const total = Math.max(1, Math.floor(+r.total) || 1);
        if (total > MAX_PARTS) { partial.delete(id); return { error: 'toolarge' }; }
        st.total = total; st.size = +r.size || st.size; st.parts.push(r.data); stats.chunks++;
        j.prog.forEach(f => { try { f(st.parts.length / total); } catch (e) {} });
        if (!r.data.length) break;
        const dt = Date.now() - t0;
        if (i < total && dt < PACE) await sleep(PACE - dt);
      }
      partial.delete(id);
      let s = st.parts.join(''); st.parts = [];
      if (st.size && s.length !== st.size) return { error: 'size' };            /* um bocado perdido dava um vídeo que não abre */
      if (!/^data:video\/[A-Za-z0-9.+-]+[;,]/.test(s)) return { error: 'format' };
      let blob = null;
      try { blob = window.RecCore && RecCore.dataURLToBlob ? RecCore.dataURLToBlob(s) : toBlob(s); } catch (e) { blob = null; }
      s = null;
      if (!blob || !blob.size) return { error: 'format' };
      const url = URL.createObjectURL(blob); keep(id, url, blob.size);
      return { url };
    }
    async function pump() {
      if (busy) return; busy = true;
      while (queue.length) {
        const j = queue.shift(); let r;
        try { r = await run(j); } catch (e) { r = { error: 'client' }; }
        jobs.delete(j.id); j.done(r);
      }
      busy = false;
    }
    /* → Promise<{ url } | { paused } | { error }>. o = { want: () => bool (ainda interessa?), onProgress(f), first } */
    function get(v, o = {}) {
      const id = Math.floor(+(v && v.id));
      if (!(id > 0)) return Promise.resolve({ error: 'notfound' });
      const u = hit(id); if (u) { stats.cacheHits++; return Promise.resolve({ url: u, cached: true }); }
      let j = jobs.get(id);
      if (j) { if (o.onProgress) j.prog.add(o.onProgress); const w0 = j.want; j.want = (w0 && o.want) ? () => w0() || o.want() : null; return j.pr; }
      j = { id, want: o.want || null, prog: new Set(o.onProgress ? [o.onProgress] : []) };
      j.pr = new Promise(res => { j.done = res; });
      jobs.set(id, j); if (o.first) queue.unshift(j); else queue.push(j); pump();
      return j.pr;
    }

    /* ---- o leitor ---- */
    let cur = null;                 /* o leitor com o <video> (um só em todo o telemóvel) */
    let muted = false;
    try { muted = !!(window.Store && Store.get('svMuted', false)); } catch (e) {}
    const vol = () => { const v = +((window.System && System.state) || {}).volume; return Math.max(0, Math.min(1, isFinite(v) ? v / 100 : .6)); };
    const io = 'IntersectionObserver' in window ? new IntersectionObserver(es => es.forEach(x => { const P = x.target._svp; if (P && !x.isIntersecting) P.pause(); }), { threshold: .3 }) : null;
    /* o observer segura os elementos que observa: um feed repintado deixava as caixas antigas presas. Cada leitor novo larga as que
       já saíram do DOM. */
    const observed = new Set();
    const observe = host => { if (!io) return; observed.forEach(h => { if (!h.isConnected) { io.unobserve(h); observed.delete(h); } }); io.observe(host); observed.add(host); };
    /* enquanto toca: a cada 700 ms vê se o leitor ainda está à vista (vista por trás de outra, janela em segundo plano, saiu do DOM) */
    let watchT = null;
    const watch = () => {
      if (watchT) return;
      watchT = setInterval(() => {
        const P = cur;
        if (!P || !P.vid) { clearInterval(watchT); watchT = null; return; }
        if (!P.host.isConnected) { P.release(); return; }
        if (P.vid.paused) return;
        const hid = P.host.closest('.view.behind, .app-window.bg, .leave') || document.body.classList.contains('hidden') || (window.System && System.locked);
        if (hid) P.pause();
      }, 700);
    };
    const durTxt = ms => UI.fmtDur(Math.max(0, Math.round((+ms || 0) / 1000)));
    const PLAY = g('play', 26), SPK = on => g(on ? 'volumeX' : 'speaker', 18);
    /* host = a caixa com a capa por fundo. o = { loop, offscreen (pausa fora do ecrã, por omissão sim), bare (story: sem botões),
       reel (botões do Reels), stopTap (o toque no vídeo não sobe: cartões do Tweeter), onPlaying, onEnded, onError, onState } */
    function player(host, v, o = {}) {
      if (!host || !v) return null;
      if (host._svp) host._svp.destroy();
      const mid = Math.floor(+v.id);
      host.classList.add('sv-host'); if (o.bare) host.classList.add('sv-bare'); if (o.reel) host.classList.add('sv-reel');
      const ov = UI.el(`<div class="sv-ov"><div class="sv-pl" role="button" aria-label="Reproduzir">${PLAY}</div><div class="sv-ld"><svg viewBox="0 0 36 36"><circle class="sv-rb" cx="18" cy="18" r="15"/><circle class="sv-rf" cx="18" cy="18" r="15"/></svg><b data-noi18n></b></div><span class="sv-du" data-noi18n>${durTxt(v.dur)}</span><div class="sv-mu" role="button" aria-label="Som">${SPK(muted)}</div><div class="sv-er"></div></div>`);
      host.appendChild(ov);
      const rf = ov.querySelector('.sv-rf'), pct = ov.querySelector('.sv-ld b'), er = ov.querySelector('.sv-er'), mu = ov.querySelector('.sv-mu');
      const RING = 94.25;   /* 2π·15 */
      const P = { mid, host, vid: null, want: false, state: '', dead: false };
      const set = s => { if (P.state === s) return; P.state = s; ['idle', 'loading', 'playing', 'paused', 'error'].forEach(k => host.classList.toggle('sv-' + k, k === s)); if (o.onState) { try { o.onState(s); } catch (e) {} } };
      set('idle');
      const prog = f => { rf.style.strokeDashoffset = (RING * (1 - Math.max(0, Math.min(1, f)))).toFixed(2); const t = Math.round(f * 100) + ' %'; if (pct.textContent !== t) pct.textContent = t; };
      let tapT = null;
      const attach = url => {
        if (cur && cur !== P) cur.release();
        cur = P;
        let vid = P.vid;
        if (!vid) {
          vid = document.createElement('video');
          vid.className = 'sv-v'; vid.playsInline = true; vid.preload = 'auto'; vid.loop = !!o.loop;
          vid.setAttribute('playsinline', '');
          vid.addEventListener('playing', () => { if (P.vid !== vid) return; set('playing'); if (o.onPlaying) { try { o.onPlaying(vid); } catch (e) {} } });
          vid.addEventListener('pause', () => { if (P.vid !== vid || vid.ended) return; if (P.state === 'playing') set('paused'); });
          vid.addEventListener('ended', () => { if (P.vid !== vid) return; set('idle'); if (o.onEnded) { try { o.onEnded(); } catch (e) {} } });
          vid.addEventListener('error', () => { if (P.vid !== vid || !vid.getAttribute('src')) return; set('error'); er.textContent = T('Não foi possível reproduzir este vídeo'); if (o.onError) { try { o.onError('decode'); } catch (e) {} } });
          /* um toque pausa/retoma; dois toques seguidos são do gosto (o duplo toque da caixa), por isso o primeiro espera um pouco */
          vid.addEventListener('click', e => { if (o.stopTap) e.stopPropagation(); if (o.bare) return; if (tapT) { clearTimeout(tapT); tapT = null; return; } tapT = setTimeout(() => { tapT = null; P.toggle(); }, 260); });
          host.insertBefore(vid, ov);
          P.vid = vid;
          vid.src = url;
        }
        vid.volume = vol(); vid.muted = muted && !o.bare;
        /* um vídeo de cada vez: o leitor da galeria (photos.js, .vpl-v) também pára */
        document.querySelectorAll('video.vpl-v').forEach(x => { try { if (!x.paused) x.pause(); } catch (e) {} });
        const pr = vid.play();
        /* um CEF que não deixe tocar com som sem um gesto: toca sem som e o botão do som fica à vista */
        if (pr && pr.catch) pr.catch(e => { if (P.vid !== vid || !P.want) return; if (e && e.name === 'NotAllowedError' && !vid.muted) { vid.muted = true; mu.innerHTML = SPK(true); vid.play().catch(() => {}); } });
        watch();
      };
      P.play = () => {
        if (P.dead) return;
        P.want = true; er.textContent = '';
        if (P.vid && P.vid.getAttribute('src')) { attach(P.vid.src); return; }
        set('loading'); prog(0);
        get(v, { want: () => P.want && !P.dead && host.isConnected, onProgress: prog, first: true }).then(r => {
          if (P.dead) return;
          if (r && r.url) { if (P.want) attach(r.url); else set('idle'); return; }
          if (r && r.paused) { set('idle'); return; }
          set('error'); er.textContent = T('Não foi possível carregar o vídeo');
          if (o.onError) { try { o.onError((r && r.error) || 'rpc'); } catch (e) {} }
        });
      };
      P.pause = () => { P.want = false; if (P.vid && !P.vid.paused) P.vid.pause(); if (P.state === 'loading') set('idle'); };
      P.toggle = () => { if (P.vid && !P.vid.paused) P.pause(); else P.play(); };
      /* larga o <video> (outro leitor começou, ou este saiu do ecrã de vez): o descodificador e a memória dele saem com ele */
      P.release = () => {
        P.want = false; clearTimeout(tapT); tapT = null;
        const vid = P.vid; P.vid = null;
        if (vid) { try { vid.pause(); } catch (e) {} vid.removeAttribute('src'); try { vid.load(); } catch (e) {} vid.remove(); }
        if (cur === P) cur = null;
        if (!P.dead) set('idle');
      };
      P.destroy = () => { if (P.dead) return; P.release(); P.dead = true; if (io) io.unobserve(host); observed.delete(host); ov.remove(); host._svp = null; ['sv-host', 'sv-bare', 'sv-reel', 'sv-idle', 'sv-loading', 'sv-playing', 'sv-paused', 'sv-error'].forEach(k => host.classList.remove(k)); };
      P.setMuted = m => { muted = !!m; try { Store.set('svMuted', muted); } catch (e) {} mu.innerHTML = SPK(muted); if (P.vid) P.vid.muted = muted; };
      ov.querySelector('.sv-pl').addEventListener('click', e => { e.stopPropagation(); Sound.play('click'); P.play(); });
      mu.addEventListener('click', e => { e.stopPropagation(); P.setMuted(!muted); });
      host._svp = P;
      if (o.offscreen !== false) observe(host);
      return P;
    }
    /* uma capa estática com o play e a duração (pré-visualização no compositor, citações do Tweeter) */
    const badge = (secs, big) => UI.el(`<div class="sv-ov sv-static ${big ? '' : 'sv-small'}"><div class="sv-pl">${PLAY}</div><span class="sv-du" data-noi18n>${UI.fmtDur(Math.max(0, Math.floor(+secs || 0)))}</span></div>`);
    /* marca de vídeo nas grelhas (Explorar, perfil, Media do Tweeter) */
    const tile = (el, v) => { if (!el || !v) return; el.classList.add('sv-tile'); el.appendChild(UI.el(`<span class="sv-tb">${g('play', 12)}<b data-noi18n>${durTxt(v.dur)}</b></span>`)); };
    const stopAll = () => { if (cur) cur.release(); };
    const pauseAll = () => { if (cur) cur.pause(); };
    Bridge.on('app:close', pauseAll); Bridge.on('phone:close', pauseAll); Bridge.on('lock', pauseAll);
    /* troca de personagem: nada do que a anterior viu fica em memória */
    Bridge.on('session:changed', () => { stopAll(); blobs.forEach(b => { try { URL.revokeObjectURL(b.url); } catch (e) {} }); blobs.clear(); blobBytes = 0; partial.clear(); cfgP = null; });
    return { cfg, okIn, allow, errText, alert, precheck, get, player, badge, tile, stopAll, pauseAll, get current() { return cur; }, get stats() { return Object.assign({ blobs: blobs.size, blobBytes }, stats); }, resetStats: () => { stats = { chunks: 0, cacheHits: 0 }; } };
  })();
  window.SocialVideo = SV;
  /* uma publicação com fotografia OU vídeo (um vídeo sem capa continua a ser uma publicação com media) */
  const hasMedia = p => hasImg(p) || !!(p && p.video);

  /* ---------------- INSTASHOT ----------------
     Feed, stories com 24 h, explorar, pesquisa, perfil completo, comentários com
     respostas, listas de gostos/seguidores e criação de publicação e de story.
     Tudo assente no servidor (server/social.lua) - nada fica só neste aparelho. */
  App.define('instashot', {
    name: 'Instashot', category: 'Redes sociais', needs: ['photos', 'camera'],   /* a câmara dos stories É a câmara do telemóvel (CamView): pede a mesma permissão que a app Câmara */
    description: 'Fotografias, stories de 24 horas, reels e mensagens. A rede social de Los Santos.',
    open(win) { ensureProfile('instashot', win, me => {
      const app = 'instashot'; let tabs;
      const esc = UI.esc;

      /* (as fotografias perto do ecrã - lazyBg - e aos bocados - media - vivem no topo do módulo,
         partilhadas com o Tweeter) */

      /* ---------- scroll infinito ----------
         Um sentinela no fim da lista; quando entra no ecrã pede a página seguinte.
         O observer morre com a vista (senão fica a disparar com a app fechada). */
      const infinite = (v, holder, load) => {
        const sent = UI.el('<div class="ig-sent"></div>');
        holder.appendChild(sent);
        let busy = false, done = false;
        const io = new IntersectionObserver(async es => {
          if (!es[0].isIntersecting || busy || done) return;
          busy = true;
          sent.classList.add('on');
          done = await load() === false;
          sent.classList.remove('on');
          if (done) sent.remove();
          busy = false;
        }, { root: v.content, rootMargin: '400px' });
        io.observe(sent);
        const prev = v.opts.onPop;
        v.opts.onPop = () => { io.disconnect(); prev && prev(); };
        return { stop: () => io.disconnect(), sent };
      };

      /* ---------- listas de pessoas (gostos, seguidores, a seguir) ---------- */
      const peopleView = (title, back, fetch) => {
        const v = UI.view({ title, back: back || 'Anterior' });
        const holder = UI.el('<div></div>');
        let all = [];
        const paint = q => {
          holder.innerHTML = '';
          const list = q ? all.filter(u => (u.username + ' ' + (u.name || '')).toLowerCase().includes(q)) : all;
          if (!list.length) { const e = UI.empty('users', 'Ninguém aqui', q ? 'Sem resultados.' : ''); e.classList.add('compact'); holder.appendChild(e); return; }
          holder.appendChild(UI.list([{ items: list.map(u => ({
            avatar: u, label: u.username, sub: u.name || u.bio || '', chevron: false,
            right: u.me ? undefined : followBtn(u),
            onTap: () => userView(u.username),
          })) }]));
        };
        v.content.appendChild(UI.search('Pesquisar', q => paint(q)));
        v.content.appendChild(holder);
        holder.appendChild(UI.spinner());
        fetch().then(r => { all = r || []; paint(''); });
        UI.push(win, v);
        return v;
      };
      const followBtn = u => {
        const b = UI.el(`<div class="pill-btn sm ${u.isFollowing ? 'gray' : 'on'} nostop">${u.isFollowing ? 'A seguir' : 'Seguir'}</div>`);
        b.onclick = async ev => {
          ev.stopPropagation();
          const r = await rpc('social.follow', { app, target: u.username });
          u.isFollowing = !!(r && r.following);
          b.className = 'pill-btn sm nostop ' + (u.isFollowing ? 'gray' : 'on');
          b.textContent = u.isFollowing ? 'A seguir' : 'Seguir';
        };
        return b;
      };
      const likersView = post => peopleView('Gostos', 'Anterior', () => rpc('social.likers', { app, postId: post.id }));
      const cmtsTxt = n => !n ? 'Sê o primeiro a comentar…' : n === 1 ? 'Ver 1 comentário' : `Ver os ${n} comentários`;
      const likesTxt = n => n ? `<span class="lc">${n}</span> ${n === 1 ? 'gosto' : 'gostos'}` : 'Sê o primeiro a gostar disto';
      /* ---------- comentários: respostas a um nível, gostos e apagar ---------- */
      async function igComments(post, onCount) {
        const body = UI.el('<div class="ig-cmts-sheet"></div>');
        const list = UI.el('<div class="cl"></div>');
        const comp = UI.el(`<div class="composer ig-cmt-comp"><span class="rt"></span><input type="text" placeholder="Adicionar comentário…" maxlength="200"><div class="send">${g('arrowUp')}</div></div>`);
        /* o compositor fica PRESO ao fundo da folha (UI.sheet `foot`, 4 nov 2026) e a lista rola por cima dele: com a lista num teto
           de 46vh e o compositor dentro do que rola, uma conversa comprida empurrava o campo para o fim do scroll. O Enviar não tira
           o foco ao campo (o teclado fica, a folha não desce debaixo do dedo e dá para escrever o seguinte). */
        body.append(list);
        comp.querySelector('.send').addEventListener('pointerdown', e => e.preventDefault());
        const inp = comp.querySelector('input'), rt = comp.querySelector('.rt');
        let replyTo = null;
        const setReply = c => {
          replyTo = c;
          rt.textContent = c ? 'a responder a @' + c.username : '';
          rt.classList.toggle('on', !!c);
          if (c) inp.focus();
        };

        const row = (c, isReply) => {
          const e = UI.el(`<div class="ig-cmt-row ${isReply ? 'reply' : ''}">${av(c, 'xs')}<div class="bd"><div class="tx"><b>${esc(c.username)}</b>${vb(c.username)} ${UI.linkify(c.content)}</div>
            <div class="mt"><span class="tm">${timeAgo(c.created)}</span>${c.likes ? `<span class="lc">${c.likes} ${c.likes === 1 ? 'gosto' : 'gostos'}</span>` : ''}<span class="rep">Responder</span>${c.canDelete ? '<span class="del">Apagar</span>' : ''}</div></div>
            <div class="lk ${c.liked ? 'on' : ''}">${g(c.liked ? 'heartFill' : 'heart', 20)}</div>`);
          e.querySelector('.rep').onclick = () => setReply(c);
          e.querySelector('.bd b').onclick = () => { sh.close(); userView(c.username); };
          const del = e.querySelector('.del');
          if (del) del.onclick = async () => {
            if (!await UI.confirm('Apagar comentário', 'Isto apaga também as respostas.', 'Apagar', true)) return;
            await rpc('social.comment.delete', { app, id: c.id });
            paint();
          };
          e.querySelector('.lk').onclick = async ev => {
            const r = await rpc('social.comment.like', { app, id: c.id });
            if (!r) return;
            c.liked = !!r.liked; c.likes = (c.likes || 0) + (c.liked ? 1 : -1);
            ev.currentTarget.classList.toggle('on', c.liked);
            ev.currentTarget.innerHTML = g(c.liked ? 'heartFill' : 'heart', 20);
            const lc = e.querySelector('.lc');
            if (c.likes > 0) { if (lc) lc.textContent = `${c.likes} ${c.likes === 1 ? 'gosto' : 'gostos'}`; else e.querySelector('.tm').insertAdjacentHTML('afterend', `<span class="lc">${c.likes} gosto</span>`); }
            else if (lc) lc.remove();
            if (c.liked) Sound.play('pop');
          };
          return e;
        };

        const paint = async () => {
          const cs = fillAvatars((await rpc('social.comments', { app, postId: post.id })) || []);
          list.innerHTML = '';
          if (!cs.length) { const em = UI.empty('chat', 'Sem comentários', 'Sê o primeiro a comentar.'); em.classList.add('compact'); list.appendChild(em); onCount && onCount(0); kbRefit(inp); return; }
          const tops = cs.filter(c => !c.parent);
          const kids = {};
          cs.filter(c => c.parent).forEach(c => { (kids[c.parent] = kids[c.parent] || []).push(c); });
          tops.forEach(c => {
            list.appendChild(row(c, false));
            (kids[c.id] || []).forEach(k => list.appendChild(row(k, true)));
          });
          onCount && onCount(cs.length);
          kbRefit(inp);   /* a folha cresceu com o teclado em cima: volta a ser medida (ver kbRefit) */
        };
        const send = async () => {
          const t = inp.value.trim(); if (!t) return;
          inp.value = '';
          if (!(await sendComment(app, { postId: post.id, content: t, parent: replyTo ? replyTo.id : null }, inp, t))) return;
          setReply(null); await paint();
        };
        comp.querySelector('.send').onclick = send;
        inp.onkeydown = e => { if (e.key === 'Enter') send(); };
        const sh = UI.sheet({ title: 'Comentários', right: 'Fechar', body, foot: comp });
        paint();
      }

      /* `lazy`: quem chama entrega a `.ig-img` a um lazyBg (feed); sem ele a fotografia é pedida já (publicação aberta sozinha) */
      const postEl = (p, lazy) => { const sl = splitLoc(p.content); const e = UI.el(`<div class="ig-post"><div class="ig-head">${av(p, 'xs')}<div><b>${esc(p.author)}${vb(p.author)}</b>${sl.loc ? `<div class="ig-loc">${esc(sl.loc)}</div>` : ''}</div><div class="more">${g('more')}</div></div><div class="ig-img"></div><div class="ig-actions"><div class="lk ${p.liked ? 'liked' : ''}">${g(p.liked ? 'heartFill' : 'heart')}</div><div class="cm">${g('chat')}</div><div class="sh">${g('send')}</div><div class="bm ${p.saved ? 'liked' : ''}">${g('bookmark')}</div></div><div class="ig-likes">${likesTxt(p.likes)}</div>${sl.text ? `<div class="ig-cap"><b>${esc(p.author)}</b>${UI.linkify(sl.text)}</div>` : ''}<div class="ig-cmts">${cmtsTxt(p.comments)}</div><div class="ig-time">${timeAgo(p.created)}</div></div>`);
        /* a linha dos gostos é repintada por inteiro: com 0 gostos deixa de existir o <span class="lc">, por isso não basta escrever nele */
        const paintLikes = () => {
          const box = e.querySelector('.ig-likes');
          box.innerHTML = likesTxt(p.likes);
          const lc = box.querySelector('.lc');
          if (lc) { lc.style.cursor = 'pointer'; lc.onclick = () => likersView(p); }
        };
        const relike = async t => { await toggleLike(app, p, t, null); paintLikes(); };
        /* a fotografia vai pelo CSSOM, nunca dentro da string de HTML: um data: URL de 200 KB passava pelo parser de HTML (e o que photos.js ja faz).
           O `_bg` fica guardado para o lazyBg do feed a poder tirar e repor conforme a distância ao ecrã. */
        const imgEl = e.querySelector('.ig-img');
        postBg(imgEl, p); if (!lazy) loadNow(imgEl);
        /* vídeo: a capa fica por fundo e o vídeo só desce quando se carrega no play (SV) */
        if (p.video) SV.player(imgEl, p.video, { loop: true });
        paintLikes();
        e.querySelector('.lk').onclick = ev => relike(ev.currentTarget); let lastTap = 0; e.querySelector('.ig-img').onclick = () => { const n = Date.now(); if (n - lastTap < 350) { const b = UI.el(`<div class="ig-burst">${g('heartFill')}</div>`); e.querySelector('.ig-img').appendChild(b); setTimeout(() => b.remove(), 900); if (!p.liked) relike(e.querySelector('.lk')); } lastTap = n; };
        e.querySelector('.cm').onclick = () => igComments(p, n => { p.comments = n; e.querySelector('.ig-cmts').textContent = cmtsTxt(n); }); e.querySelector('.ig-cmts').onclick = e.querySelector('.cm').onclick; e.querySelector('.sh').onclick = () => share(app, p);
        e.querySelector('.bm').onclick = async ev => { const r = await rpc('social.save', { app, postId: p.id }); if (!r) return; p.saved = !!r.saved; ev.currentTarget.classList.toggle('liked', p.saved); UI.toast(p.saved ? 'Guardado' : 'Removido dos guardados'); };
        e.querySelector('.ig-head b').onclick = () => userView(p.author); e.querySelector('.ig-head .avatar').onclick = () => userView(p.author);
        e.querySelector('.more').onclick = ev => UI.ctxMenu(ev.currentTarget, p.author === me.username ? [{ label: 'Apagar publicação', icon: 'trash', danger: true, onTap: async () => { await rpc('social.deletePost', { app, postId: p.id }); e.remove(); } }] : [{ label: 'Ver perfil', icon: 'personCircle', onTap: () => userView(p.author) }, { label: 'Enviar por mensagem', icon: 'send', onTap: () => share(app, p) }]);   /* "Denunciar" saiu: a denúncia não ia a lado nenhum */
        e.querySelectorAll('.hashtag').forEach(h => h.onclick = () => h.dataset.tag ? tagView(h.dataset.tag.slice(1)) : userView(h.dataset.user.slice(1))); return e; };

      /* feed com scroll infinito: pede 12 de cada vez a partir da última que já tem */
      const feedInto = async (holder, mode, ref, v) => {
        holder.innerHTML = ''; holder.classList.add('feed');
        holder.appendChild(UI.spinner());
        const PAGE = 12;
        let last = null;
        const lz = lazyBg(v);
        /* o elemento em si - `querySelector('.ig-sent')` a cada publicação era uma travessia da
           lista inteira por cada uma das 12 de cada página */
        let sent = null;
        const add = p => { const el = postEl(p, true); if (sent) holder.insertBefore(el, sent); else holder.appendChild(el); lz.add(el.querySelector('.ig-img')); };
        const page = async () => {
          const ps = (await rpc('social.feed', { app, mode, ref, before: last, limit: PAGE })) || [];
          if (ps.length) { last = ps[ps.length - 1].created; ps.forEach(add); }
          return ps.length >= PAGE;
        };
        /* 1.1.6: rpcRaw - um erro do servidor mostra-se (com o código) e toca-se para tentar outra vez; antes passava por "Nada por aqui" */
        const r0 = await Bridge.rpcRaw('social.feed', { app, mode, ref, limit: PAGE });
        holder.innerHTML = '';
        if (r0 && r0.error) { lz.stop(); const em = UI.empty('ban', 'Não foi possível carregar', errMsg(r0.error)); em.appendChild(errCode(r0.error)); em.style.cursor = 'pointer'; em.onclick = () => feedInto(holder, mode, ref, v); holder.appendChild(em); return; }
        const ps = Array.isArray(r0) ? r0 : [];
        if (!ps.length) { lz.stop(); holder.appendChild(UI.empty('camera', 'Nada por aqui', mode === 'home' ? 'Segue pessoas para ver publicações.' : '')); return; }
        ps.forEach(add);
        last = ps[ps.length - 1].created;
        if (v && ps.length >= PAGE) sent = infinite(v, holder, page).sent;
      };

      /* ---------- STORIES ----------
         O sistema vive em js/apps/stories.js (editor com camadas + visualizador).
         Aqui fica só a barra de bolhas e a ligação a esse módulo. */
      let storyGroups = [];
      const storiesRow = async holder => {
        storyGroups = (await rpc('social.stories', { app })) || [];
        const row = UI.el('<div class="stories"></div>');
        const mine = storyGroups.find(x => x.mine);
        /* a minha bolha: tocar no AVATAR abre as minhas stories (se existirem),
           tocar no "+" cria sempre uma nova - como no Instagram */
        const own = UI.el(`<div class="story own"><div class="ring ${mine && !mine.allSeen ? '' : 'seen'}">${av(me)}<div class="plus">${g('plus', 17)}</div></div><span>O teu Story</span></div>`);
        own.querySelector('.plus').onclick = ev => { ev.stopPropagation(); Stories.create(app, me, win); };
        own.onclick = () => { if (mine) openStories(storyGroups.indexOf(mine)); else Stories.create(app, me, win); };
        row.appendChild(own);
        storyGroups.forEach((gr, i) => {
          if (gr.mine) return;
          const s = UI.el(`<div class="story"><div class="ring ${gr.allSeen ? 'seen' : ''}">${av(gr)}</div><span>${esc(gr.author)}</span></div>`);
          s.onclick = () => openStories(i);
          row.appendChild(s);
        });
        holder.innerHTML = '';
        holder.appendChild(row);
      };
      const openStories = startIdx => Stories.open(app, me, win, storyGroups, startIdx, {
        onUser: u => userView(u),
        onTag: t => tagView(t),
        onViewers: vs => peopleView('Visualizações', 'Anterior', async () => vs),
      });
      const createStory = () => Stories.create(app, me, win);
      /* A barra PUBLICAÇÃO · STORY · REEL do ecrã de criação (Stories.create) vive dentro do
         stories.js, que não conhece o `compose()` desta app - avisa por evento e é aqui que
         se decide o que fazer. O off() morre com a janela. */
      /* 12 nov 2026: o REEL tem o compositor dele (a camada dos Reels: vídeo da galeria, legenda e #reel); antes caía na publicação */
      const openReels = () => reelsLayer(win, app, { dm: u => dmThread(u), profile: u => userView(u) });
      const offCompose = Bridge.on('instashot:compose', d => {
        if (!d || d.app !== app) return;
        if (d.kind === 'reel') { const L = openReels(); if (L && L.compose) L.compose(); return; }
        compose();
      });
      /* "Partilhar → Instashot" nas Fotos (photos.js: Bridge.emit('social:compose', {app, photo}))
         - o Tweeter já ouvia isto e o Instashot tinha deixado de ouvir: abria a app e não acontecia
         nada. Passa a fotografia direta ao compositor (o `preset` do compose).
         12 nov 2026: o destino vem com ela (`kind`): um vídeo pode ir para a publicação, para a story ou para os Reels. */
      const routeShare = s => {
        if (!s || !s.photo) { compose(); return; }
        if (s.kind === 'story') { Stories.compose(app, me, win, s.photo); return; }
        if (s.kind === 'reel') { const L = openReels(); if (L && L.compose) L.compose(s.photo); return; }
        compose(s.photo);
      };
      const offShare = Bridge.on('social:compose', d => { if (d && d.app === app) routeShare(d.photo ? { photo: d.photo, kind: d.kind } : takeShare(app)); });

      /* "Criar": no Instagram é o + do canto SUPERIOR ESQUERDO (antes estava no separador do meio,
         que agora é o avião das mensagens - ver a barra de separadores no fim da app). */
      const criar = async () => {
        const k = await UI.actionSheet({ title: 'Criar', buttons: [{ label: 'Publicação', icon: 'grid', value: 'post' }, { label: 'Story', icon: 'plusCircle', value: 'story' }] });
        if (k === 'post') compose(); else if (k === 'story') createStory();
      };
      const home = () => {
        /* barra de cima igual à do Instagram: + à esquerda, a marca ao centro e SÓ o coração à
           direita. O avião das mensagens desceu para a barra de separadores (ao meio). */
        const v = UI.view({ title: 'Instashot', left: [{ icon: 'plusCircle', cls: 'glass', onTap: criar }], right: [{ icon: 'heart', cls: 'glass', onTap: () => UI.push(win, notifs(true)) }] });
        v.querySelector('.nb-title').innerHTML = `<span class="ig-wordmark">Instashot</span>${vb(me.username)}`;
        const st = UI.el('<div class="ig-stories"></div>'), f = UI.el('<div></div>');
        v.content.append(st, f);
        storiesRow(st); feedInto(f, 'home', null, v);
        return v;
      };

      /* ---------- EXPLORAR: pesquisas recentes, grelha variada e scroll infinito ---------- */
      const RECENT = 'igRecent';
      const explore = () => {
        const v = UI.view({ title: 'Explorar' });
        const res = UI.el('<div></div>');
        let sT = null;
        const s = UI.search('Pesquisar pessoas ou #hashtags', q => { clearTimeout(sT); sT = setTimeout(() => run(q), 180); });
        v.content.append(s, res);
        v.opts.onPop = () => clearTimeout(sT);

        const remember = u => { try { const l = (Store.get(RECENT, []) || []).filter(x => x !== u); l.unshift(u); Store.set(RECENT, l.slice(0, 8)); } catch (e) {} };
        const openUser = u => { remember(u); userView(u); };

        const recents = () => {
          const l = Store.get(RECENT, []) || [];
          if (!l.length) return null;
          const box = UI.el('<div></div>');
          box.appendChild(UI.el(`<div class="ig-recent-h"><b>Recentes</b><span class="clr">Limpar</span></div>`));
          box.querySelector('.clr').onclick = () => { Store.set(RECENT, []); run(''); };
          box.appendChild(UI.list([{ items: l.map(u => ({ avatar: { name: u }, label: u, chevron: false, onTap: () => openUser(u) })) }]));
          return box;
        };

        const run = async q => {
          res.innerHTML = '';
          if (!q) { const r = recents(); if (r) res.appendChild(r); grid(); return; }
          const us = (await rpc('social.search', { app, q })) || [];
          if (us.length) res.appendChild(UI.list([{ header: 'Pessoas', items: us.map(u => ({
            avatar: u, label: u.username, sub: u.name || u.bio || '', chevron: false,
            html: `${esc(u.username)}${vb(u.username)}`,
            onTap: () => openUser(u.username),
          })) }]));
          /* pintar na própria vista (como o Tweeter já faz): com UI.push aqui, escrever "#festa" empilhava SEIS vistas, uma por tecla */
          if (q.startsWith('#')) { const th = UI.el('<div></div>'); res.appendChild(th); feedInto(th, 'hashtag', q.slice(1), v); }
          else if (!us.length) { const e = UI.empty('search', 'Sem resultados', 'Tenta outro nome ou #hashtag.'); e.classList.add('compact'); res.appendChild(e); }
        };

        const grid = async () => {
          const gr = UI.el('<div class="ig-grid varied"></div>');
          res.appendChild(gr);
          const PAGE = 18;
          let last = null, n = 0, sent = null;
          const lz = lazyBg(v);
          const tile = (p, podeGrande) => {
            /* de 9 em 9 uma peça alta, para a grelha não ficar monótona (como no Explorar do Instagram).
               ⚠️ só quando ainda vêm pelo menos mais duas: a peça alta ocupa duas filas e, sem vizinhas
               para o `grid-auto-flow:dense` encaixar ao lado, deixava um buraco branco no fim da grelha. */
            const big = podeGrande && (n % 9) === 4;
            n++;
            const d = UI.el(`<div class="${big ? 'big' : ''}"></div>`);
            postBg(d, p);   /* o lazyBg tira-o quando se afasta (e vai buscar a fotografia quando ela vem aos bocados) */
            if (p.video) SV.tile(d, p.video);
            d.onclick = () => { const vv = UI.view({ title: 'Publicação', back: 'Explorar' }); vv.content.appendChild(postEl(p)); UI.push(win, vv); };
            return d;
          };
          const add = (p, podeGrande) => { const d = tile(p, podeGrande); if (sent) gr.insertBefore(d, sent); else gr.appendChild(d); lz.add(d); };
          const addAll = l => l.forEach((p, i) => add(p, i + 2 < l.length));
          const page = async () => {
            const ps = (await rpc('social.feed', { app, mode: 'explore', before: last, limit: PAGE })) || [];
            addAll(ps.filter(hasMedia));
            if (ps.length) last = ps[ps.length - 1].created;
            return ps.length >= PAGE;
          };
          const ps = (await rpc('social.feed', { app, mode: 'explore', limit: PAGE })) || [];
          const withImg = ps.filter(hasMedia);
          if (!withImg.length) { lz.stop(); res.appendChild(UI.empty('camera', 'Ainda sem fotografias', 'Sê o primeiro a publicar.')); return; }
          addAll(withImg);
          if (ps.length) last = ps[ps.length - 1].created;
          if (ps.length >= PAGE) sent = infinite(v, gr, page).sent;
        };
        run('');
        return v;
      };

      /* ---------- criar publicação: pré-visualizar, legenda, local, marcar pessoas ---------- */
      async function compose(preset) {
        /* a galeria também mostra os VÍDEOS quando o servidor deixa publicá-los aqui (Config.Recording.social) */
        const photo = preset || await Photos.pick('Nova publicação', { videos: await SV.allow('instashot') });
        if (!photo) return;
        if (photo.video) { const bad = await SV.precheck(photo, 'instashot'); if (bad) { SV.alert(bad); return; } }
        /* carregar o conteúdo antes de mostrar: a galeria é lazy e, sem isto, a publicação
           ia com o `seed` (gradiente) em vez da fotografia real. Um vídeo NÃO desce aqui: mostra-se a capa */
        const src = photo.video ? null : await Photos.data(photo);
        let tagged = [];
        const body = UI.el(`<div><div class="ig-img" style="height:280px;aspect-ratio:auto"></div>
          <div class="group" style="margin-top:12px;padding:12px"><textarea class="ta cap" placeholder="Escreve uma legenda… #hashtags" style="min-height:90px"></textarea></div>
          <div class="group" style="margin-top:12px"><div class="li static">${g('pin', 21)}<input type="text" class="loc" placeholder="Adicionar localização" maxlength="40"></div>
            <div class="li tag"><span>Marcar pessoas</span><span class="li-value tv">Ninguém</span><div class="li-chev">${g('chevR')}</div></div></div></div>`);
        const pv = body.querySelector('.ig-img');
        pv.style.backgroundImage = src ? imgCss(src) : Photos.bg(photo);   /* pelo CSSOM, nunca na string de HTML */
        if (photo.video) { pv.classList.add('sv-host'); pv.appendChild(SV.badge(photo.duration, true)); Promise.resolve(Photos.poster(photo, true)).then(u => { if (u && pv.isConnected) pv.style.backgroundImage = Photos.bg(photo); }).catch(() => {}); }
        body.querySelector('.tag').onclick = async () => {
          const q = await UI.prompt('Marcar pessoa', 'Nome de utilizador', 'username');
          if (!q) return;
          const u = q.replace('@', '').trim().toLowerCase();
          if (u && tagged.indexOf(u) < 0) tagged.push(u);
          body.querySelector('.tv').textContent = tagged.length ? tagged.map(x => '@' + x).join(', ') : 'Ninguém';
        };
        const sh = UI.sheet({ title: 'Nova publicação', left: 'Cancelar', right: 'Partilhar', body, onDone: () => {
          /* `return false` mantém a folha aberta: a legenda e as marcações não se perdem */
          if (window.CC && CC.requireNet && !CC.requireNet('publicar')) return false;
          const loc = body.querySelector('.loc').value.trim();
          const cap = body.querySelector('.cap').value.trim();
          const tags = tagged.length ? '\n' + tagged.map(x => '@' + x).join(' ') : '';
          /* rpcRaw: o social.post recusa e o telemóvel dizia "Publicado" à mesma. A fotografia vai por REFERÊNCIA
             (postImage → photoId), nunca o `src` inteiro: era isso que fazia o pedido nunca chegar (ver postImage).
             4 nov 2026: o botão era procurado com document.querySelector('.sheet-wrap .sh-r') (podia ser o de OUTRA folha) e a folha
             fechava no mesmo clique; agora é o desta folha e ela só fecha quando o servidor aceita (postFromSheet). */
          return postFromSheet(sh, 'Partilhar', app, photo, { content: (loc ? '📍 ' + loc + '\n' : '') + cap + tags }, () => tabs.go(0));
        } });
      }
      /* `pushed`: a Atividade deixou de ser um separador (o coração vive no canto superior direito,
         como no Instagram), por isso quando é empilhada precisa do botão de voltar. */
      const notifs = pushed => { const v = UI.view({ title: 'Notificações', large: true, back: pushed ? 'Instashot' : undefined }); rpc('social.notifications', { app }).then(ns => { ns = ns || []; if (!ns.length) { v.content.appendChild(UI.empty('heart', 'Sem atividade', '')); return; } v.content.appendChild(UI.list([{ items: ns.map(n => ({ avatar: n, html: `<b>${UI.esc(n.username)}</b> ${n.type === 'like' ? 'gostou da tua publicação' : n.type === 'comment' ? 'comentou: ' + UI.esc(n.content || '') : 'começou a seguir-te'}`, sub: timeAgo(n.created), chevron: false, onTap: () => userView(n.username) })) }])); }); return v; };
      /* ---------- editar perfil ---------- */
      async function editProfile(u) {
        let avatar = u.avatar || 1;
        let avatarUrl = u.avatarUrl || u.avatar_url || null;
        const body = UI.el(`<div><div class="ig-edit-av"><div class="pvwrap"></div><span>Toca para mudar a fotografia</span></div>
          <div class="group"><div class="li static"><span class="muted" style="width:92px">Nome</span><input type="text" class="nm" maxlength="40" value="${esc(u.name || '')}" placeholder="O teu nome"></div>
            <div class="li static"><span class="muted" style="width:92px">Utilizador</span><input type="text" class="un" maxlength="16" autocapitalize="off" value="${esc(u.username)}"></div>
            <div class="li static"><span class="muted" style="width:92px">Site</span><input type="text" class="ws" maxlength="90" value="${esc(u.website || '')}" placeholder="exemplo.com"></div></div>
          <div class="group" style="margin-top:12px;padding:12px"><textarea class="ta bio" placeholder="Bio" style="min-height:80px">${esc(u.bio || '')}</textarea></div></div>`);
        body.appendChild(UI.list([{ footer: 'Numa conta privada só quem te segue vê as tuas publicações.', items: [{ label: 'Conta privada', toggle: !!u.private, onToggle: v2 => { u.private = v2; } }] }]));
        const wrap = body.querySelector('.pvwrap');
        const paintAv = () => { wrap.innerHTML = UI.avatar({ name: u.username, avatar, url: avatarUrl }, 'lg'); wrap.firstElementChild.onclick = chooseAv; };
        async function chooseAv() {
          const k = await UI.actionSheet({ title: 'Foto de perfil', buttons: [
            { label: 'Escolher das minhas fotos', icon: 'photo', value: 'pick' },
            { label: 'Tirar uma agora', icon: 'camera', value: 'cam' },
            { label: 'Usar uma cor', icon: 'personCircle', value: 'col' },
          ].concat(avatarUrl ? [{ label: 'Remover fotografia', icon: 'trash', danger: true, value: 'del' }] : []) });
          if (k === 'pick') { const s = await avatarFromPhotos('Foto de perfil'); if (s) { avatarUrl = s; paintAv(); } }
          else if (k === 'cam') { UI.toast('Tira a foto e volta aqui'); System.openApp('camera'); }
          else if (k === 'col') { avatar = avatar % 12 + 1; avatarUrl = null; paintAv(); }
          else if (k === 'del') { avatarUrl = null; paintAv(); }
        }
        paintAv();
        UI.sheet({ title: 'Editar perfil', left: 'Cancelar', right: 'Guardar', body, onDone: () => {
          const un = body.querySelector('.un').value.trim().toLowerCase();
          if (!/^[a-z0-9_.]{3,16}$/.test(un)) { UI.toast('Nome de utilizador inválido'); return false; }
          rpc('social.updateProfile', { app, avatar, avatarUrl: avatarUrl || '', name: body.querySelector('.nm').value.trim(), username: un, website: body.querySelector('.ws').value.trim(), bio: body.querySelector('.bio').value.trim(), private: !!u.private })
            .then(r => {
              if (!r || r.error) { UI.alert({ title: 'Não guardado', msg: r && r.error === 'taken' ? 'Esse nome de utilizador já existe.' : r && r.error === 'toolarge' ? 'A fotografia é grande demais.' : 'Nome de utilizador inválido.' }); return; }
              profileCache[app] = r; me.username = r.username; me.avatar = r.avatar; me.avatarUrl = r.avatar_url || null;
              Sound.play('success'); UI.toast('Perfil atualizado'); tabs.go(4);
            });
        } });
      }

      const profileInto = async (v, username, back) => { const u = await rpc('social.user', { app, username }); if (!u) { v.content.appendChild(UI.empty('personCircle', 'Utilizador não encontrado', '')); return; }
        const head = UI.el(`<div class="ig-profile"><div class="top">${av(u, 'lg')}<div class="stats"><div class="st-p"><b>${u.posts}</b><span>publicações</span></div><div class="st-f"><b>${u.followers}</b><span>seguidores</span></div><div class="st-g"><b>${u.following}</b><span>a seguir</span></div></div></div>
          <div class="bio"><b>${esc(u.name || u.username)}</b>${u.private ? `<span class="priv">${g('lock', 17)} Privada</span>` : ''}<br>${UI.linkify(u.bio || '')}${u.website ? `<br><a class="ws">${esc(u.website)}</a>` : ''}</div><div class="btns"></div></div>`);
        const btns = head.querySelector('.btns');
        head.querySelector('.st-f').onclick = () => peopleView('Seguidores', username, () => rpc('social.followers', { app, username, mode: 'followers' }));
        head.querySelector('.st-g').onclick = () => peopleView('A seguir', username, () => rpc('social.followers', { app, username, mode: 'following' }));
        /* o site do perfil abre no Surf (era um "Ligação copiada" que não copiava nada) */
        const ws = head.querySelector('.ws'); if (ws) ws.onclick = () => { if (window.App && App.get('safari') && System.isInstalled('safari')) System.openURL('phone://safari/open?url=' + encodeURIComponent(u.website)); else UI.toast(u.website); };
        if (u.me) {
          const e = UI.el('<div class="pill-btn gray">Editar perfil</div>'); e.onclick = () => editProfile(u);
          /* partilhar = mandar o @ por mensagem a um contacto */
          const s = UI.el('<div class="pill-btn gray">Partilhar perfil</div>'); s.onclick = async () => { const c = await Contacts.pick('Partilhar perfil com'); if (!c) return; const r = await Bridge.rpcRaw('messages.send', { to: c.number, type: 'text', content: `📸 Segue-me no Instashot: @${u.username}` }); if (!r || r.error) { Sound.play('error'); UI.toast('Não consegui enviar'); return; } UI.toast('Enviado a ' + (c.name || c.number)); };
          btns.append(e, s);
        } else {
          const f = UI.el(`<div class="pill-btn ${u.isFollowing ? 'gray' : 'on'}">${u.isFollowing ? 'A seguir' : 'Seguir'}</div>`);
          f.onclick = async () => { const r = await rpc('social.follow', { app, target: u.username }); f.className = 'pill-btn ' + (r.following ? 'gray' : 'on'); f.textContent = r.following ? 'A seguir' : 'Seguir'; const c = head.querySelector('.st-f b'); c.textContent = (+c.textContent) + (r.following ? 1 : -1); };
          const m = UI.el('<div class="pill-btn gray">Mensagem</div>'); m.onclick = () => dmThread(u.username);
          btns.append(f, m);
        }
        v.content.appendChild(head);

        /* separadores: publicações · reels · guardados (só no próprio perfil) */
        const TABS = [['grid', 'posts'], ['play', 'reels']].concat(u.me ? [['bookmark', 'saved']] : []);
        const bar = UI.el('<div class="ig-ptabs"></div>');
        const gridBox = UI.el('<div></div>');
        v.content.append(bar, gridBox);
        let cur = 'posts';
        /* uma grelha por perfil pode trazer dezenas de fotografias: o lazyBg só mantém as que estão
           perto do ecrã (um observer por vista, largado no onPop) */
        const lzp = lazyBg(v);
        const gridOf = ps => {
          const gr = UI.el('<div class="ig-grid"></div>');
          ps.filter(hasMedia).forEach(p => { const d = UI.el('<div></div>'); postBg(d, p); if (p.video) SV.tile(d, p.video); d.onclick = () => { const vv = UI.view({ title: 'Publicação', back: username }); vv.content.appendChild(postEl(p)); UI.push(win, vv); }; gr.appendChild(d); lzp.add(d); });
          return gr;
        };
        const load = async k => {
          cur = k;
          bar.querySelectorAll('.pt').forEach(b => b.classList.toggle('on', b.dataset.k === k));
          gridBox.innerHTML = '';
          gridBox.appendChild(UI.spinner());
          let ps = [];
          if (k === 'saved') ps = (await rpc('social.saves', { app })) || [];
          else ps = (await rpc('social.feed', { app, mode: 'user', ref: username })) || [];
          if (k === 'reels') ps = ps.filter(p => p.video || (p.content || '').toLowerCase().includes('#reel'));   /* os vídeos são reels (12 nov 2026) */
          gridBox.innerHTML = '';
          if (!ps.length) { gridBox.appendChild(UI.empty(k === 'saved' ? 'bookmark' : 'camera', k === 'saved' ? 'Sem guardados' : 'Sem publicações', '')); return; }
          gridBox.appendChild(gridOf(ps));
        };
        TABS.forEach(([icon, k]) => { const b = UI.el(`<div class="pt ${k === 'posts' ? 'on' : ''}" data-k="${k}">${g(icon, 26)}</div>`); b.onclick = () => load(k); bar.appendChild(b); });
        load('posts');
      };
      /* Amigos próximos: a lista existia no servidor desde as stories, mas não havia
         maneira nenhuma de a gerir - o botão verde do editor publicava para ninguém. */
      const closeFriends = async () => {
        const v = UI.view({ title: 'Amigos próximos', back: me.username });
        v.content.appendChild(UI.el('<div class="ig-note">Só estas pessoas veem as stories publicadas para amigos próximos. Ninguém é avisado de que entrou ou saiu da lista.</div>'));
        const sb = UI.el('<div></div>'); v.content.appendChild(sb);
        const box = UI.el('<div></div>'); v.content.appendChild(box);
        UI.push(win, v);
        box.appendChild(UI.spinner());
        const raw = await rpc('social.closefriends', { app });
        /* o Lua devolve {} quando a lista está vazia, e isso chega aqui como objeto */
        const on = new Set(Array.isArray(raw) ? raw : Object.values(raw || {}));
        const fol = (await rpc('social.followers', { app, username: me.username, mode: 'followers' })) || [];
        const people = (Array.isArray(fol) ? fol : []).filter(u => u.username !== me.username);
        let q = '';
        const hdr = () => on.size ? on.size + (on.size === 1 ? ' pessoa' : ' pessoas') : 'Ninguém escolhido';
        const paint = () => {
          box.innerHTML = '';
          const l = people.filter(u => !q || (u.username + ' ' + (u.name || '')).toLowerCase().includes(q));
          if (!l.length) { box.appendChild(UI.empty('star', people.length ? 'Sem resultados' : 'Sem seguidores', people.length ? 'Tenta outro nome.' : 'Quem te seguir aparece aqui.')); return; }
          box.appendChild(UI.list([{ header: hdr(), items: l.map(u => ({
            avatar: { name: u.username, avatar: u.avatar, url: u.avatarUrl || u.avatar_url },
            label: u.username, sub: u.name || '', chevron: false,
            right: `<div class="cf-tick ${on.has(u.username) ? 'on' : ''}">${g('check', 18)}</div>`,
            onTap: async li => {
              const r = await rpc('social.closefriends.toggle', { app, target: u.username });
              if (!r || r.error) { UI.toast('Não consegui alterar'); return; }
              if (r.on) { on.add(u.username); Sound.play('pop'); } else on.delete(u.username);
              /* so muda esta linha e o cabecalho: repintar a lista inteira por innerHTML a cada toque e trabalho a mais no CEF */
              const t = li.querySelector('.cf-tick'); if (t) t.classList.toggle('on', !!r.on);
              const h = box.querySelector('.group-header'); if (h) h.textContent = hdr();
            },
          })) }]));
        };
        sb.appendChild(UI.search('Pesquisar', s => { q = (s || '').toLowerCase(); paint(); }));
        paint();
      };
      const profile = () => { const v = UI.view({ title: me.username, right: [{ icon: 'more', onTap: () => UI.ctxMenu(v.querySelector('.nb-right'), [
          { label: 'Editar perfil', icon: 'pen', onTap: async () => { const u = await rpc('social.user', { app, username: me.username }); if (u) editProfile(u); } },
          { label: 'Amigos próximos', icon: 'star', onTap: () => closeFriends() },
          { label: 'Nova story', icon: 'plusCircle', onTap: () => createStory() },
          { label: 'Guardados', icon: 'bookmark', onTap: () => { const vv = UI.view({ title: 'Guardados', back: me.username }); const box = UI.el('<div></div>'); vv.content.appendChild(box); box.appendChild(UI.spinner()); /* até 100 guardados: as fotografias só perto do ecrã, como nas outras grelhas */ const lzs = lazyBg(vv); rpc('social.saves', { app }).then(ps => { box.innerHTML = ''; ps = ps || []; if (!ps.length) { lzs.stop(); box.appendChild(UI.empty('bookmark', 'Sem guardados', 'Toca no marcador de uma publicação para a guardares.')); return; } const gr = UI.el('<div class="ig-grid"></div>'); ps.forEach(p => { const d = UI.el('<div></div>'); postBg(d, p); if (p.video) SV.tile(d, p.video); lzs.add(d); d.onclick = () => { const v3 = UI.view({ title: 'Publicação', back: 'Guardados' }); v3.content.appendChild(postEl(p)); UI.push(win, v3); }; gr.appendChild(d); }); box.appendChild(gr); }); UI.push(win, vv); } },
        ]) }] }); profileInto(v, me.username); return v; };
      const userView = username => { if (username === me.username) { tabs.go(4); return; } const v = UI.view({ title: username, back: 'Anterior' }); profileInto(v, username); UI.push(win, v); };
      /* com a vista: a hashtag passa a ter scroll infinito e as fotografias entram/saem com o lazyBg */
      const tagView = tag => { const v = UI.view({ title: '#' + tag, back: 'Anterior' }); const f = UI.el('<div></div>'); v.content.appendChild(f); UI.push(win, v); feedInto(f, 'hashtag', tag, v); };
      /* DMs (mensagens diretas via motor de mensagens, app=instashot) */
      /* DMs (mensagens diretas via motor de mensagens, app=instashot).
         A implementação está em js/apps/social-dm.js (chat a sério: avatar, nome, fotos da câmara/galeria,
         mensagens de voz e lista de quem eu sigo em "Nova mensagem"). Aqui fica só a ligação e o contexto.
         ⚠️ O antigo fazia `(await rpc(...) || []).forEach(...)`: quando o servidor respondia um objeto
         ({ error: 'ratelimit' }, por exemplo) o forEach rebentava e a conversa ficava VAZIA sem dizer nada -
         era isto que se via ao abrir uma conversa que a lista mostrava com mensagens. */
      /* resetProfile: o servidor recusou o envio com 'noidentity' (a conta desta rede não é da personagem atual):
         sem esquecer o perfil em cache, reabrir a app mostrava a conta antiga e cada envio voltava a falhar */
      const dmCtx = () => ({ app, me, win, rpc, onUser: u => userView(u), resetProfile: () => { delete profileCache[app]; } });
      const dms = async () => { if (window.SocialDM) return SocialDM.list(dmCtx()); UI.toast('Mensagens indisponíveis'); };
      const dmThread = async username => { if (window.SocialDM) return SocialDM.thread(dmCtx(), username); UI.toast('Mensagens indisponíveis'); };
      /* barra ao estilo do Instagram: encostada as bordas, so icones, sem rotulos (opts.plain) */
      /* ---------- BARRA DE BAIXO, COMO A DO INSTAGRAM ----------
         casa · reels · AVIÃO (mensagens, ao meio) · lupa · o teu avatar.
         O avião estava no canto superior direito e o + ao meio: trocaram de sítio a pedido do
         utilizador (a referência é o Instagram atual). Em cima fica só o coração, à direita. */
      tabs = UI.tabbar(win, [{ icon: 'home', label: 'Início', view: home }, { icon: 'reels', label: 'Reels', view: home }, { icon: 'send', label: 'Mensagens', view: home }, { icon: 'search', label: 'Explorar', view: explore }, { icon: 'personCircle', label: 'Perfil', view: profile }], 0, { plain: true });
      const pt = tabs.el.querySelectorAll('.tab')[4]; if (pt) { const s = pt.querySelector('svg'); if (s) s.outerHTML = av(me, 'xs'); }
      /* Reels e Mensagens NÃO trocam de separador (ficaria o Início por baixo a ser reconstruído):
         o primeiro abre os Reels (camada de ecrã inteiro nesta mesma janela), o segundo empilha as mensagens por cima.
         O `view: home` deles nunca chega a correr, porque o onclick é substituído aqui. */
      const rt = tabs.el.querySelectorAll('.tab')[1];
      if (rt) rt.onclick = () => openReels();
      const mt = tabs.el.querySelectorAll('.tab')[2];
      /* e nunca DUAS vezes: o separador empurra a vista, não troca de separador, por isso tocar-lhe
         outra vez empilharia outra lista de mensagens por cima da que já lá está */
      if (mt) mt.onclick = () => { const st = win.querySelector('.nav-stack'); const top = st && st.lastElementChild; if (top && top.dataset.dm === '1') return; dms(); };
      /* o ponto vermelho do avião: mensagens por ler (o Instagram mostra um ponto, sem número) */
      const dmDot = async () => { try { const ts = (await rpc('messages.threads', { app })) || []; tabs.badge(2, ts.some(t => t.unread) ? true : 0); } catch (e) {} };
      dmDot();
      const offDm = Bridge.on('message', () => dmDot());
      /* publicar/apagar uma story repinta a barra de bolhas sem reabrir a app */
      const offStories = Bridge.on('stories:changed', d => {
        if (!d || d.app !== app) return;
        const holder = win.querySelector('.ig-stories');
        if (holder) storiesRow(holder);
      });
      const prevClose = win.onClose;
      win.onClose = () => { offStories(); offCompose(); offShare(); offDm(); SV.stopAll(); prevClose && prevClose(); };
      const pend = takeShare(app); if (pend) routeShare(pend);   /* a fotografia (ou o vídeo) partilhada das Fotos enquanto esta app ainda não estava de pé */
    }); }
  });

  /* ---------------- TWIX = X (5 nov 2026) ----------------
     "deixa o Twitter X exatamente igual ao original e que seja funcional": a app passou a ter o desenho da app X do iPhone -
     preto/branco puros (segue o tema do telemóvel), barra de cima com o avatar à esquerda e a marca ao centro, separadores
     «Para ti · A seguir» com o sublinhado azul, cartões com o avatar de 40 e as quatro acções em contorno (resposta, repost,
     gosto, visualizações) mais o marcador e a partilha, compositor de ecrã inteiro com o «Publicar» em pílula azul e o
     anel dos 280 caracteres, fio da publicação com a caixa de resposta presa em baixo, perfil com capa e avatar a sobrepô-la,
     pesquisa com tendências, barra de baixo Início · Pesquisar · Vera (o lugar do Grok) · Notificações · Mensagens (as DMs do
     social-dm.js, que o servidor já aceita com app='twix': a identidade é a conta desta rede).
     O MOTOR é o mesmo de antes e do Instashot (ensureProfile, postFromSheet, refused, postImage, media/lazyBg): nada do que
     foi endurecido a 4 nov muda - a folha fica aberta até o servidor aceitar, a recusa mostra o código, os botões do cabeçalho
     não tiram o foco ao campo, o teclado espera pelo largar. Os glifos são os do X em SVG inline (fill), não os do icons.js:
     a forma é parte do desenho. Texto do JOGADOR (nomes, @, publicações) vai em data-noi18n; o que é interface fica em nós
     próprios com a chave exata do dicionário (o tradutor do DOM compara a frase inteira). Classes com prefixo .x-* (novo). */
  const XI = (() => {
    const S = d => `<svg class="gl xi" viewBox="0 0 24 24" fill="currentColor">${d}</svg>`;
    return {
      logo: S('<path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>'),
      reply: S('<path d="M1.751 10c0-4.42 3.584-8 8.005-8h4.366c4.49 0 8.129 3.64 8.129 8.13 0 2.96-1.607 5.68-4.196 7.11l-8.054 4.46v-3.69h-.067c-4.49.1-8.183-3.51-8.183-8.01zm8.005-6c-3.317 0-6.005 2.69-6.005 6 0 3.37 2.77 6.08 6.138 6.01l.351-.01h1.761v2.3l5.087-2.81c1.951-1.08 3.163-3.13 3.163-5.36 0-3.39-2.744-6.13-6.129-6.13H9.756z"/>'),
      repost: S('<path d="M4.5 3.88l4.432 4.14-1.364 1.46L5.5 7.55V16c0 1.1.896 2 2 2H13v2H7.5c-2.209 0-4-1.79-4-4V7.55L1.432 9.48.068 8.02 4.5 3.88zM16.5 6H11V4h5.5c2.209 0 4 1.79 4 4v8.45l2.068-1.93 1.364 1.46-4.432 4.14-4.432-4.14 1.364-1.46 2.068 1.93V8c0-1.1-.896-2-2-2z"/>'),
      heart: S('<path d="M16.697 5.5c-1.222-.06-2.679.51-3.89 2.16l-.805 1.09-.806-1.09C9.984 6.01 8.526 5.44 7.304 5.5c-1.243.07-2.349.78-2.91 1.91-.552 1.12-.633 2.78.479 4.82 1.074 1.97 3.257 4.27 7.129 6.61 3.87-2.34 6.052-4.64 7.126-6.61 1.111-2.04 1.03-3.7.477-4.82-.561-1.13-1.666-1.84-2.908-1.91zm4.187 7.69c-1.351 2.48-4.001 5.12-8.379 7.67l-.503.3-.504-.3c-4.379-2.55-7.029-5.19-8.382-7.67-1.36-2.5-1.41-4.86-.514-6.67.887-1.79 2.647-2.91 4.601-3.01 1.651-.09 3.368.56 4.798 2.01 1.429-1.45 3.146-2.1 4.796-2.01 1.954.1 3.714 1.22 4.601 3.01.896 1.81.846 4.17-.514 6.67z"/>'),
      heartF: S('<path d="M20.884 13.19c-1.351 2.48-4.001 5.12-8.379 7.67l-.503.3-.504-.3c-4.379-2.55-7.029-5.19-8.382-7.67-1.36-2.5-1.41-4.86-.514-6.67.887-1.79 2.647-2.91 4.601-3.01 1.651-.09 3.368.56 4.798 2.01 1.429-1.45 3.146-2.1 4.796-2.01 1.954.1 3.714 1.22 4.601 3.01.896 1.81.846 4.17-.514 6.67z"/>'),
      views: S('<path d="M8.75 21V3h2v18h-2zM18 21V8.5h2V21h-2zM4 21l.004-10h2L6 21H4zm9.248 0v-7h2v7h-2z"/>'),
      bm: S('<path d="M4 4.5C4 3.12 5.119 2 6.5 2h11C18.881 2 20 3.12 20 4.5v18.44l-8-5.71-8 5.71V4.5zM6.5 4c-.276 0-.5.22-.5.5v14.56l6-4.29 6 4.29V4.5c0-.28-.224-.5-.5-.5h-11z"/>'),
      bmF: S('<path d="M4 4.5C4 3.12 5.119 2 6.5 2h11C18.881 2 20 3.12 20 4.5v18.44l-8-5.71-8 5.71V4.5z"/>'),
      share: S('<path d="M12 2.59l5.7 5.7-1.41 1.42L13 6.41V16h-2V6.41l-3.3 3.3-1.41-1.42L12 2.59zM21 15l-.02 3.51c0 1.38-1.12 2.49-2.5 2.49H5.5C4.11 21 3 19.88 3 18.5V15h2v3.5c0 .28.22.5.5.5h12.98c.28 0 .5-.22.5-.5L19 15h2z"/>'),
      more: S('<path d="M3 12c0-1.1.9-2 2-2s2 .9 2 2-.9 2-2 2-2-.9-2-2zm9 2c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm7 0c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2z"/>'),
      home: S('<path d="M21.591 7.146L12.52 1.157c-.316-.21-.724-.21-1.04 0l-9.071 5.99c-.26.173-.409.456-.409.757v13.183c0 .502.418.913.929.913h6.638c.511 0 .929-.41.929-.913v-7.075h3.008v7.075c0 .502.418.913.929.913h6.639c.51 0 .928-.41.928-.913V7.904c0-.301-.158-.584-.408-.758zM20 20l-4.5.01.011-7.097c0-.502-.418-.913-.928-.913H9.44c-.511 0-.929.41-.929.913L8.5 20H4V8.773l8.011-5.342L20 8.764z"/>'),
      homeF: S('<path d="M21.591 7.146L12.52 1.157c-.316-.21-.724-.21-1.04 0l-9.071 5.99c-.26.173-.409.456-.409.757v13.183c0 .502.418.913.929.913H9.14c.51 0 .929-.41.929-.913v-7.075h3.909v7.075c0 .502.417.913.928.913h6.165c.511 0 .929-.41.929-.913V7.904c0-.301-.158-.584-.408-.758z"/>'),
      search: S('<path d="M10.25 3.75c-3.59 0-6.5 2.91-6.5 6.5s2.91 6.5 6.5 6.5c1.795 0 3.419-.726 4.596-1.904 1.178-1.177 1.904-2.801 1.904-4.596 0-3.59-2.91-6.5-6.5-6.5zm-8.5 6.5c0-4.694 3.806-8.5 8.5-8.5s8.5 3.806 8.5 8.5c0 1.986-.682 3.815-1.824 5.262l4.781 4.781-1.414 1.414-4.781-4.781c-1.447 1.142-3.276 1.824-5.262 1.824-4.694 0-8.5-3.806-8.5-8.5z"/>'),
      searchF: S('<path d="M10.25 4.25c-3.314 0-6 2.686-6 6s2.686 6 6 6c1.657 0 3.155-.67 4.243-1.757 1.087-1.088 1.757-2.586 1.757-4.243 0-3.314-2.686-6-6-6zm-9 6c0-4.971 4.029-9 9-9s9 4.029 9 9c0 1.943-.617 3.744-1.664 5.215l4.475 4.474-2.122 2.122-4.474-4.475c-1.471 1.047-3.272 1.664-5.215 1.664-4.971 0-9-4.029-9-9z"/>'),
      grok: S('<path d="M2.205 7.423L11.745 21h4.241L6.446 7.423H2.204zm4.237 7.541L2.2 21h4.243l2.12-3.017-2.121-3.02zM16.957 0L9.624 10.435l2.122 3.02L21.2 0h-4.243zm.767 6.456V21H21.2V1.512l-3.476 4.944z"/>'),
      bell: S('<path d="M19.993 9.042C19.48 5.017 16.054 2 11.996 2s-7.49 3.021-7.999 7.051L2.866 18H7.1c.463 2.282 2.481 4 4.9 4s4.437-1.718 4.9-4h4.236l-1.143-8.958zM12 20c-1.306 0-2.417-.835-2.829-2h5.658c-.412 1.165-1.523 2-2.829 2zm-6.866-4l.847-6.698C6.364 6.272 8.941 4 11.996 4s5.627 2.268 6.013 5.295L18.864 16H5.134z"/>'),
      bellF: S('<path d="M11.996 2c-4.062 0-7.49 3.021-7.999 7.051L2.866 18H7.1c.463 2.282 2.481 4 4.9 4s4.437-1.718 4.9-4h4.236l-1.143-8.958C19.48 5.017 16.054 2 11.996 2zM9.171 18h5.658c-.412 1.165-1.523 2-2.829 2s-2.417-.835-2.829-2z"/>'),
      mail: S('<path d="M1.998 5.5c0-1.381 1.119-2.5 2.5-2.5h15c1.381 0 2.5 1.119 2.5 2.5v13c0 1.381-1.119 2.5-2.5 2.5h-15c-1.381 0-2.5-1.119-2.5-2.5v-13zm2.5-.5c-.276 0-.5.224-.5.5v2.764l8 3.638 8-3.636V5.5c0-.276-.224-.5-.5-.5h-15zm15.5 5.463l-8 3.636-8-3.638V18.5c0 .276.224.5.5.5h15c.276 0 .5-.224.5-.5v-8.037z"/>'),
      mailF: S('<path d="M1.998 4.499c0-.828.671-1.499 1.5-1.499h17c.828 0 1.5.671 1.5 1.499v2.858l-10 4.545-10-4.547V4.499zm0 5.056V19.5c0 .828.671 1.5 1.5 1.5h17c.828 0 1.5-.672 1.5-1.5V9.554l-10 4.545-10-4.544z"/>'),
      image: S('<path d="M3 5.5C3 4.119 4.119 3 5.5 3h13C19.881 3 21 4.119 21 5.5v13c0 1.381-1.119 2.5-2.5 2.5h-13C4.119 21 3 19.881 3 18.5v-13zM5.5 5c-.276 0-.5.224-.5.5v9.086l3-3 3 3 5-5 3 3V5.5c0-.276-.224-.5-.5-.5h-13zM19 15.414l-3-3-5 5-3-3-3 3V18.5c0 .276.224.5.5.5h13c.276 0 .5-.224.5-.5v-3.086zM9.75 7C8.784 7 8 7.784 8 8.75s.784 1.75 1.75 1.75 1.75-.784 1.75-1.75S10.716 7 9.75 7z"/>'),
      gif: S('<path d="M3 5.5C3 4.119 4.12 3 5.5 3h13C19.88 3 21 4.119 21 5.5v13c0 1.381-1.12 2.5-2.5 2.5h-13C4.12 21 3 19.881 3 18.5v-13zM5.5 5c-.28 0-.5.224-.5.5v13c0 .276.22.5.5.5h13c.28 0 .5-.224.5-.5v-13c0-.276-.22-.5-.5-.5h-13zM18 10.5V9h-4.5v6H15v-2h2v-1.5h-2v-1h3zm-6.5-.5H10v5h1.5v-5zM9 12.5H7.5v1h-.75c-.14 0-.25-.11-.25-.25v-2.5c0-.14.11-.25.25-.25H9V9H6.75C5.78 9 5 9.78 5 10.75v2.5C5 14.22 5.78 15 6.75 15H9v-2.5z"/>'),
      poll: S('<path d="M6 5c-.552 0-1 .448-1 1v12c0 .552.448 1 1 1h12c.552 0 1-.448 1-1V6c0-.552-.448-1-1-1H6zM3 6c0-1.657 1.343-3 3-3h12c1.657 0 3 1.343 3 3v12c0 1.657-1.343 3-3 3H6c-1.657 0-3-1.343-3-3V6zm4 4.5c0-.828.672-1.5 1.5-1.5h1c.828 0 1.5.672 1.5 1.5v5c0 .828-.672 1.5-1.5 1.5h-1c-.828 0-1.5-.672-1.5-1.5v-5zm6-3c0-.828.672-1.5 1.5-1.5h1c.828 0 1.5.672 1.5 1.5v8c0 .828-.672 1.5-1.5 1.5h-1c-.828 0-1.5-.672-1.5-1.5v-8z"/>'),
      pin: S('<path d="M12 7c-1.93 0-3.5 1.57-3.5 3.5S10.07 14 12 14s3.5-1.57 3.5-3.5S13.93 7 12 7zm0 5c-.827 0-1.5-.673-1.5-1.5S11.173 9 12 9s1.5.673 1.5 1.5S12.827 12 12 12zm0-10c-4.687 0-8.5 3.813-8.5 8.5 0 5.967 7.621 11.174 7.945 11.392l.555.375.555-.375c.324-.218 7.945-5.425 7.945-11.392C20.5 5.813 16.687 2 12 2zm0 17.849c-1.581-1.223-6.5-5.419-6.5-9.349 0-3.584 2.916-6.5 6.5-6.5s6.5 2.916 6.5 6.5c0 3.934-4.919 8.127-6.5 9.349z"/>'),
      smile: S('<path d="M8 9.5C8 8.119 8.672 7 9.5 7S11 8.119 11 9.5 10.328 12 9.5 12 8 10.881 8 9.5zm6.5 2.5c.828 0 1.5-1.119 1.5-2.5S15.328 7 14.5 7 13 8.119 13 9.5s.672 2.5 1.5 2.5zM12 16c-2.224 0-3.021-2.227-3.051-2.316l-1.897.633c.05.15 1.271 3.684 4.949 3.684s4.898-3.533 4.949-3.684l-1.896-.638c-.033.095-.83 2.322-3.053 2.322zm10.25-4.001c0 5.652-4.598 10.25-10.25 10.25S1.75 17.652 1.75 12 6.348 1.75 12 1.75 22.25 6.348 22.25 12zm-2 0c0-4.549-3.701-8.25-8.25-8.25S3.75 7.451 3.75 12s3.701 8.25 8.25 8.25 8.25-3.701 8.25-8.25z"/>'),
      verified: S('<path d="M22.25 12c0-1.43-.88-2.67-2.19-3.34.46-1.39.2-2.9-.81-3.91s-2.52-1.27-3.91-.81c-.66-1.31-1.91-2.19-3.34-2.19s-2.67.88-3.33 2.19c-1.4-.46-2.91-.2-3.92.81s-1.26 2.52-.8 3.91c-1.31.67-2.2 1.91-2.2 3.34s.89 2.67 2.2 3.34c-.46 1.39-.21 2.9.8 3.91s2.52 1.26 3.91.81c.67 1.31 1.91 2.19 3.34 2.19s2.68-.88 3.34-2.19c1.39.45 2.9.2 3.91-.81s1.27-2.52.81-3.91c1.31-.67 2.19-1.91 2.19-3.34zm-11.71 4.2L6.8 12.46l1.41-1.42 2.26 2.26 4.8-5.23 1.47 1.36-6.2 6.77z"/>'),
      back: S('<path d="M7.414 13l5.043 5.04-1.414 1.42L3.586 12l7.457-7.46 1.414 1.42L7.414 11H21v2H7.414z"/>'),
      compose: S('<path d="M23 3c-6.62-.1-10.38 2.421-13.05 6.03C7.29 12.61 6 17.331 6 22h2c0-1.007.07-2.012.19-3H12c4.1 0 7.48-3.082 7.94-7.054C22.79 10.147 23.17 6.359 23 3zm-7 8h-1.5v2H16c.63-.016 1.2-.08 1.72-.188C16.95 15.24 14.68 17 12 17H8.55c.57-2.512 1.57-4.851 3-6.78 2.16-2.912 5.29-4.911 9.45-5.187C20.95 8.079 19.9 11 16 11zM4 9V6H1V4h3V1h2v3h3v2H6v3H4z"/>'),
      person: S('<path d="M17.863 13.44c1.477 1.58 2.366 3.8 2.632 6.46l.11 1.1H3.395l.11-1.1c.266-2.66 1.155-4.88 2.632-6.46C7.627 11.85 9.648 11 12 11s4.373.85 5.863 2.44zM12 2C9.791 2 8 3.79 8 6s1.791 4 4 4 4-1.79 4-4-1.791-4-4-4z"/>'),
      x: S('<path d="M10.59 12L4.54 5.96l1.42-1.42L12 10.59l6.04-6.05 1.42 1.42L13.41 12l6.05 6.04-1.42 1.42L12 13.41l-6.04 6.05-1.42-1.42L10.59 12z"/>'),
      link: S('<path d="M18.36 5.64c-1.95-1.96-5.11-1.96-7.07 0L9.88 7.05 8.46 5.64l1.42-1.42c2.73-2.73 7.16-2.73 9.9 0 2.73 2.74 2.73 7.17 0 9.9l-1.42 1.42-1.41-1.42 1.41-1.41c1.96-1.96 1.96-5.12 0-7.07zm-2.12 3.53l-7.07 7.07-1.41-1.41 7.07-7.07 1.41 1.41zm-12.02.71l1.42-1.42 1.41 1.42-1.41 1.41c-1.96 1.96-1.96 5.12 0 7.07 1.95 1.96 5.11 1.96 7.07 0l1.41-1.41 1.42 1.41-1.42 1.42c-2.73 2.73-7.16 2.73-9.9 0-2.73-2.74-2.73-7.17 0-9.9z"/>'),
    };
  })();
  const xvb = u => VERIFIED.includes(String(u || '').toLowerCase()) ? `<span class="x-vb">${XI.verified}</span>` : '';
  const xcnt = n => (+n > 0 ? String(n) : '');   /* o X não mostra zeros ao lado das ações */
  const xtime = ts => timeAgo(ts).replace(/^(\d+) (min|h|d)$/, (m, n, u) => n + u[0]);   /* «27 min» → «27m», «3 h» → «3h», «2 d» → «2d», como no X; «agora» e as datas ficam como o UI.timeAgo os escreve */
  const xarr = v => Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []);   /* o Lua devolve {} para listas vazias */
  const XQUICK = ['😂', '❤️', '🔥', '👍', '😍', '😮', '😢', '👏', '🙏', '💀', '🎉', '👀'];   /* emojis rápidos do compositor */
  /* todas as vistas levam .x-v (é ela que tira o vidro do PearOS à barra) e a seta do X no lugar do chevron */
  const xview = o => { const v = UI.view(Object.assign({}, o, { cls: 'x-v ' + (o.cls || '') })); const b = v.querySelector('.nb-back svg'); if (b) b.outerHTML = XI.back; return v; };
  /* CRIAR CONTA, como no registo do X: marca em cima, «Cria a tua conta», nome, @ e fotografia, e o botão em pílula.
     As mesmas regras do formulário do Instashot (ensureProfile, createErr). O nome e a foto vão num segundo passo: o createProfile não
     os aceita e, se esse passo falhar, a conta fica na mesma criada. */
  function xSignup(win, then) {
    const app = 'twix', acc = System.account || {}; let avatar = acc.avatar || 1, avatarUrl = null, busy = false;
    const v = xview({ cls: 'x-signup', title: '' }); v.navbar.querySelector('.nb-title').innerHTML = XI.logo;
    const box = UI.el(`<div class="x-su"><div class="x-su-t">Cria a tua conta</div><div class="x-su-av"><div class="pvwrap"></div><span>Toca para pôr uma fotografia</span></div><div class="x-fld"><label>Nome</label><input type="text" class="nm" maxlength="40" placeholder="O teu nome"></div><div class="x-fld"><label>Nome de utilizador</label><div class="x-su-un"><span data-noi18n>@</span><input type="text" class="un" maxlength="16" autocapitalize="off" placeholder="nome_de_utilizador"></div></div><div class="x-su-go">Criar conta</div><div class="x-su-f">O nome é público e único nesta rede.</div><div class="x-su-f">Esta conta é só desta rede. O teu número não é mostrado a ninguém.</div></div>`);
    /* o botão vai no fluxo, por baixo dos campos, e não preso ao fundo: o campo não está baixo o suficiente para o teclado subir a janela e o botão ficava atrás das teclas */
    const btn = box.querySelector('.x-su-go'), wrap = box.querySelector('.pvwrap'), un = box.querySelector('.un');
    un.value = safeUser(acc.username);
    const paint = () => { wrap.innerHTML = UI.avatar({ name: un.value || acc.username || 'eu', avatar, url: avatarUrl }, 'lg');
      wrap.firstElementChild.onclick = async () => { const k = await UI.actionSheet({ title: 'Foto de perfil', buttons: [{ label: 'Escolher das minhas fotos', icon: 'photo', value: 'pick' }, { label: 'Usar uma cor', icon: 'personCircle', value: 'col' }] });
        if (k === 'pick') { const s = await avatarFromPhotos('Foto de perfil'); if (s) { avatarUrl = s; paint(); } } else if (k === 'col') { avatar = avatar % 12 + 1; avatarUrl = null; paint(); } }; };
    paint();
    const sync = () => btn.classList.toggle('off', !/^[a-z0-9_.]{3,16}$/.test(un.value.trim().toLowerCase())); un.oninput = sync; sync();
    const create = async () => { if (busy) return; const u = un.value.trim().toLowerCase(); if (!/^[a-z0-9_.]{3,16}$/.test(u)) { UI.toast('Nome inválido (3-16, letras/números/_/.)'); return; }
      if (window.CC && CC.requireNet && !CC.requireNet('criar a conta')) return;
      busy = true; btn.classList.add('busy');
      const r = await Bridge.rpcRaw('social.createProfile', { app, username: u, bio: '', avatar });
      /* o `busy` só sai numa recusa: largado aqui, um segundo toque durante o segundo passo ouvia "Nome em uso" por cima da conta acabada de criar */
      if (!r || r.error) { busy = false; btn.classList.remove('busy'); createErr(r && r.error); return; }
      const nm = box.querySelector('.nm').value.trim();
      if (avatarUrl || nm) { const r2 = await rpc('social.updateProfile', Object.assign({ app, name: nm }, avatarUrl ? { avatarUrl } : {})); if (r2 && !r2.error) Object.assign(r, r2); }
      profileCache[app] = r; Sound.play('success'); then(r); };
    btn.onclick = create; un.onkeydown = e => { if (e.key === 'Enter') create(); };
    v.content.appendChild(box); UI.setRoot(win, v);
  }

  App.define('twix', {
    name: 'Tweeter', category: 'Redes sociais', needs: ['photos'],
    open(win) { ensureProfile('twix', win, me => {
      const app = 'twix'; let tabs; const esc = UI.esc;
      /* SILENCIAR a sério (2026-09-20): antes só dizia "Silenciado". A lista fica no telemóvel (Store 'twMuted'): os posts (e reposts)
         dessas contas saem dos feeds Para ti / A seguir / hashtags / pesquisa - no perfil da conta continuam a ver-se. */
      const MUTEK = 'twMuted'; const mutedList = () => (Store.get(MUTEK, []) || []).filter(x => typeof x === 'string');
      const isMuted = u => mutedList().includes(u);
      const setMuted = (u, on) => { const l = mutedList().filter(x => x !== u); if (on) l.push(u); Store.set(MUTEK, l); UI.toast(on ? `@${u} silenciado` : `@${u} reativado`); };
      const mutedSheet = () => { const l = mutedList(); const body = UI.list([{ header: 'Contas silenciadas', items: l.length ? l.map(u => ({ label: '@' + u, chevron: false, value: 'Reativar', onTap: () => { setMuted(u, false); sh.close(); mutedSheet(); } })) : [{ label: 'Não silenciaste ninguém.', cls: 'static' }] }, { footer: 'Mantém o dedo num post para silenciar a conta. Os posts dela deixam de aparecer nos teus feeds.' }]); const sh = UI.sheet({ cls: 'x-sh', title: 'Silenciadas', right: 'OK', body }); };
      /* RASCUNHOS (6 nov 2026): guardar o telemóvel, o Esc, o Voltar do Android, o gesto de casa ou um toque no fundo fecham a folha sem pedir
         licença (UI.dismissAll e companhia não aceitam veto) e o texto ia com ela. O que protege o texto é o Store, escrito em cada alteração:
         uma entrada por modo ('new', 'r<id>' resposta, 'q<id>' citação, 't<id>' caixa do fio) com o texto, o local e a REFERÊNCIA da fotografia
         (id + seed: o base64 nunca entra no localStorage). Sai só depois de o servidor aceitar. No máximo 30, sai a mais antiga. */
      const DRK = 'twDrafts';
      const draftGet = k => { const m = Store.get(DRK, null); return m && typeof m === 'object' ? m[k] || null : null; };
      const draftDrop = k => { const m = Store.get(DRK, null); if (m && m[k]) { delete m[k]; Store.set(DRK, m); } };
      const draftPut = (k, d) => { const m = Store.get(DRK, null) || {}; m[k] = Object.assign(d, { at: Date.now() }); const ks = Object.keys(m); if (ks.length > 30) { ks.sort((a, b) => (m[a].at || 0) - (m[b].at || 0)); delete m[ks[0]]; } Store.set(DRK, m); };
      let cmpOpen = null;   /* o compositor aberto (a sua setPhoto) */
      /* a MESMA publicação pode estar em vários cartões (no feed e num repost dela, por trás do fio): um gosto ou um repost pinta-os a todos */
      const eachCard = (id, fn) => win.querySelectorAll('.x-post').forEach(c => { if (c._act && c._act.id === id) fn(c, c._act); });
      const paintLk = (c, s) => { const a = c.querySelector('.x-a.lk'); if (!a) return; a.classList.toggle('on', !!s.liked); a.firstElementChild.outerHTML = s.liked ? XI.heartF : XI.heart; a.querySelector('.lc').textContent = xcnt(s.likes); };
      const paintRt = (c, s) => { const a = c.querySelector('.x-a.rt'); if (!a) return; a.classList.toggle('on', !!s.reposted); a.querySelector('.rc').textContent = xcnt(s.reposts); };
      const paintRp = (c, s) => { const a = c.querySelector('.x-a.rp span'); if (a) a.textContent = xcnt(s.comments); };
      /* o meu repost desta publicação saiu (desfeito, ou a linha apagada no menu): o verde e o contador acompanham, em todos os cartões */
      const unReposted = id => eachCard(id, (c, s) => { s.reposted = false; s.myRepost = null; s.reposts = Math.max(0, (s.reposts || 0) - 1); paintRt(c, s); });
      /* um lazyBg por contentor (o anterior larga-se ao repintar): o feed traz até 60 posts e, com fotografia, eram 60 texturas vivas de uma vez */
      const lzOf = (holder, v) => { if (holder._lz) holder._lz.stop(); return (holder._lz = v ? lazyBg(v) : null); };
      const threads = new Map();   /* fios abertos (postView) por id da publicação: a resposta publicada entra logo na lista, sem repintar */
      let homeFeed = null;         /* o contentor do feed da raiz: a publicação nova entra no TOPO sem reconstruir a vista (e sem perder o scroll) */
      /* a linha que o servidor devolve ao publicar não vem enriquecida (likes, comments…): completa-se com os meus dados para pintar já */
      const enrichMine = r => Object.assign({ likes: 0, liked: false, comments: 0, reposts: 0, saved: false, avatar: me.avatar, avatarUrl: me.avatarUrl || me.avatar_url || null }, r || {});
      const meAv = cls => av(me, cls || 'xs');
      const refreshMe = () => { win.querySelectorAll('.x-me').forEach(b => { b.innerHTML = meAv('xs'); }); };
      /* a hora/data de uma publicação no fio: o UI.fmt* já vem na língua certa (Intl fora de pt), por isso vai em data-noi18n */
      const whenTxt = ts => { const d = new Date(+ts || Date.now()); return `${UI.fmtTime(d)} · ${UI.fmtDate(d, true)}`; };
      const textOf = c => { const sl = splitLoc(c); return { tx: (sl.text || '').trim() ? `<div class="x-tx" data-noi18n>${UI.linkify(sl.text)}</div>` : '', loc: sl.loc ? `<div class="x-loc" data-noi18n>${XI.pin}${esc(sl.loc)}</div>` : '' }; };
      /* o nome de apresentação (feed desde 1.4.1); a própria publicação acabada de sair ainda não o traz */
      const dn = u => u.name || (u.author === me.username && me.name) || u.author;
      const quoteCard = o => { const q = textOf(o.content); return `<div class="x-qt"><div class="x-qh">${av(o, 'xs')}<b class="x-nm" data-noi18n>${esc(dn(o))}</b>${xvb(o.author)}<span class="x-hn" data-noi18n>@${esc(o.author)}</span><span class="x-dot">·</span><span class="x-tm">${xtime(o.created)}</span></div>${q.tx}${hasMedia(o) ? '<div class="x-md"></div>' : ''}</div>`; };
      const moreItems = (p, src, e) => p.author === me.username
        ? [{ label: 'Apagar post', icon: 'trash', danger: true, onTap: async () => { const dv = e.classList.contains('x-detail') ? e.closest('.view') : null; if (!await rpc('social.deletePost', { app, postId: p.id })) return;
            if (p.repost_of && !splitLoc(p.content).text.trim()) unReposted(p.repost_of);
            /* todos os cartões dela, não só este: apagada dentro do fio, a cópia do feed por baixo ficava lá como um fantasma */
            win.querySelectorAll('.x-post').forEach(c => { if (c._ids && c._ids.includes(p.id)) c.remove(); }); if (dv) UI.pop(dv); } }]
        : [{ label: 'Ver perfil', icon: 'personCircle', onTap: () => userView(src.author) }, isMuted(src.author) ? { label: 'Reativar @' + src.author, icon: 'bell', onTap: () => setMuted(src.author, false) } : { label: 'Silenciar @' + src.author, icon: 'bellOff', onTap: () => { setMuted(src.author, true); const v = e.closest('.view'); (v ? [...v.querySelectorAll('.x-post')] : [e]).forEach(c => { if (c._who && c._who.includes(src.author)) c.remove(); }); } }];   /* todas as desta conta à vista (e os reposts dela ou dela repostada), como os feeds a seguir fazem */
      /* `detail`: a publicação aberta no fio (cabeçalho em cima, texto maior, linha da hora, ações entre dois filetes);
         `lz`: um lazyBg da vista - a fotografia só entra perto do ecrã (e só então desce, se vier aos bocados); sem ele pede-se já.
         Repost simples (sem texto) = o original com a etiqueta «fez repost»; com texto = citação (o original num cartão por dentro).
         Num repost simples as AÇÕES e os contadores são os do ORIGINAL (`act`), como no X: a linha do repost não tem gostos nem respostas
         próprios, e gostar dela ou responder-lhe perdia-se. O servidor enriquece os originais desde 1.4.1 (social.lua, enrich). */
      const postEl = (p, detail, lz) => { const o = p.original, quote = !!(o && splitLoc(p.content).text.trim()), src = quote ? p : (o || p), act = o && !quote ? o : p, t = textOf(src.content);
        const hd = `<b class="x-nm" data-noi18n>${esc(dn(src))}</b>${xvb(src.author)}<span class="x-hn" data-noi18n>@${esc(src.author)}</span>`;
        const acts = `<div class="x-ac"><div class="x-a rp">${XI.reply}<span>${xcnt(act.comments)}</span></div><div class="x-a rt ${act.reposted ? 'on' : ''}">${XI.repost}<span class="rc">${xcnt(act.reposts)}</span></div><div class="x-a lk ${act.liked ? 'on' : ''}">${act.liked ? XI.heartF : XI.heart}<span class="lc">${xcnt(act.likes)}</span></div><div class="x-a vw">${XI.views}<span>${act.views != null ? xcnt(act.views) : ''}</span></div><div class="x-ar"><div class="x-a bm ${act.saved ? 'on' : ''}">${act.saved ? XI.bmF : XI.bm}</div><div class="x-a sh">${XI.share}</div></div></div>`;
        const media = `${hasMedia(src) ? '<div class="x-md"></div>' : ''}${quote ? quoteCard(o) : ''}`;
        const e = UI.el(detail
          ? `<div class="x-post x-detail"><div class="x-dh"><div class="x-av">${av(src, 'sm')}</div><div class="x-who">${hd}</div><div class="x-more">${XI.more}</div></div><div class="x-bd">${t.tx}${media}${t.loc}<div class="x-dt" data-noi18n>${whenTxt(src.created)}</div>${acts}</div></div>`
          : `<div class="x-post">${o && !quote ? `<div class="x-rp">${XI.repost}<span data-noi18n>${esc(L.tf('%s fez repost', dn(p)))}</span></div>` : ''}<div class="x-av">${av(src, 'sm')}</div><div class="x-bd"><div class="x-hd">${hd}<span class="x-dot">·</span><span class="x-tm">${xtime(src.created)}</span><div class="x-more">${XI.more}</div></div>${t.tx}${media}${t.loc}${acts}</div></div>`);
        e._who = [p.author, src.author]; e._ids = [p.id, act.id]; e._act = act;
        /* a fotografia (pode ser base64) nunca vai dentro da string de HTML: pelo CSSOM (postBg), e só perto do ecrã (lz) */
        const md = e.querySelector(':scope > .x-bd > .x-md'); if (md) { postBg(md, src); if (lz) lz.add(md); else loadNow(md); }
        /* vídeo (12 nov 2026): a capa com o play; o toque no vídeo não abre o fio (stopTap) */
        if (md && src.video) { md.classList.add('x-vid'); SV.player(md, src.video, { stopTap: true }); }
        const qmd = e.querySelector('.x-qt > .x-md'); if (qmd && o) { postBg(qmd, o); if (lz) lz.add(qmd); else loadNow(qmd); if (o.video) { qmd.classList.add('sv-host'); qmd.appendChild(SV.badge(Math.round((+o.video.dur || 0) / 1000))); } }
        /* ESPERAR o RPC antes de pintar: toggleLike só escreve p.liked depois do await, por isso o coração ficava um passo atrás
           (tocar num post não gostado repunha o ícone vazio e só o contador subia). currentTarget fica null depois do handler → guardar.
           `_busy`: dois toques seguidos eram dois social.like, que se anulam um ao outro. */
        e.querySelector('.lk').onclick = async ev => { ev.stopPropagation(); const a = ev.currentTarget; if (a._busy) return; a._busy = true; act.likes = act.likes || 0; await toggleLike(app, act, null, a.querySelector('.lc')); a._busy = false; eachCard(act.id, (c, s) => { s.liked = act.liked; s.likes = act.likes; paintLk(c, s); }); };
        e.querySelector('.rp').onclick = ev => { ev.stopPropagation(); const th = threads.get(act.id); if (detail && th) { th.inp.focus(); return; } compose({ replyTo: act, card: e }); };
        e.querySelector('.rt').onclick = ev => { ev.stopPropagation(); repostSheet(act); };
        e.querySelector('.bm').onclick = ev => { ev.stopPropagation(); bookmark(act, ev.currentTarget); };
        e.querySelector('.sh').onclick = ev => { ev.stopPropagation(); share(app, act); };
        e.querySelectorAll('.x-nm, .x-hn, .x-av').forEach(n => { n.onclick = ev => { ev.stopPropagation(); userView(n.closest('.x-qt') ? o.author : src.author); }; });
        e.querySelectorAll('.hashtag').forEach(h => h.onclick = ev => { ev.stopPropagation(); h.dataset.tag ? tagView(h.dataset.tag.slice(1)) : userView(h.dataset.user.slice(1)); });
        const qt = e.querySelector('.x-qt'); if (qt && o) qt.onclick = ev => { ev.stopPropagation(); postView(Object.assign({ likes: 0, comments: 0, reposts: 0 }, o)); };
        e.querySelector('.x-more').onclick = ev => { ev.stopPropagation(); UI.ctxMenu(ev.currentTarget, moreItems(p, src, e)); };
        if (!detail) e.onclick = () => postView(act, e);
        UI.longPress(e, () => UI.ctxMenu(e, moreItems(p, src, e)));
        return e; };
      /* `_seq`: trocar de separador com um pedido a meio não deixa a resposta atrasada pintar por cima; `_loading` diz ao onPosted que a lista
         que aí vem pode já não trazer a publicação acabada de fazer. rpcRaw, como no Instashot: um erro do servidor mostra-se com o código e
         tenta-se outra vez com um toque (antes passava por "Nada por aqui"). */
      const feedInto = async (holder, mode, ref, v) => { holder.innerHTML = ''; holder.classList.add('feed'); holder.appendChild(UI.spinner());   /* .feed cresce, para o estado vazio e o spinner ficarem centrados em vez de colados ao topo */
        const lz = lzOf(holder, v), seq = (holder._seq = (holder._seq || 0) + 1); holder._mode = mode; holder._loading = true;
        const r0 = await Bridge.rpcRaw('social.feed', { app, mode, ref }); if (holder._seq !== seq) return; holder._loading = false; holder.innerHTML = '';
        if (r0 && r0.error) { const em = UI.empty('ban', 'Não foi possível carregar', errMsg(r0.error)); em.appendChild(errCode(r0.error)); em.style.cursor = 'pointer'; em.onclick = () => feedInto(holder, mode, ref, v); holder.appendChild(em); return; }
        let ps = xarr(r0); if (mode !== 'user') ps = ps.filter(p => !isMuted(p.author) && !(p.original && isMuted(p.original.author)));
        if (!ps.length) { holder.appendChild(UI.empty('hash', 'Nada por aqui', mode === 'home' ? 'Segue pessoas para veres os posts delas aqui.' : '')); return; } ps.forEach(p => holder.appendChild(postEl(p, false, lz))); };
      /* PearPhone Fold: o botão de escrever passa para a barra direita (em baixo, a seguir aos da vista) e o redondo esconde-se (apps.css) */
      const fab = v => { const f = UI.el(`<div class="fab x-fab">${XI.compose}</div>`); f.onclick = () => compose(); if (v) v.rail = auto => ({ primary: (auto.primary || []).concat([[{ icon: 'pen', label: 'Novo post', onTap: () => compose() }]]) }); return f; };
      /* o avatar à esquerda da barra (abre o meu perfil, como no X): um botão da barra cujo glifo é trocado pela cara */
      const meBtn = () => ({ icon: 'personCircle', cls: 'x-me', onTap: () => userView(me.username), ref: b => { b.innerHTML = meAv('xs'); } });
      const xTabs = (labels, onPick) => { const bar = UI.el(`<div class="x-tabs">${labels.map((l, i) => `<div class="x-tab ${i ? '' : 'on'}"><span>${l}</span></div>`).join('')}</div>`);
        bar.querySelectorAll('.x-tab').forEach((t, i) => { t.onclick = () => { bar.querySelectorAll('.x-tab').forEach((x, k) => x.classList.toggle('on', k === i)); onPick(i); }; }); return bar; };
      const home = () => { const v = xview({ cls: 'x-home', title: '', left: [meBtn()] });   /* sem nada à direita, como no X: as contas silenciadas vivem no menu do meu perfil */
        v.navbar.querySelector('.nb-title').innerHTML = XI.logo;
        const f = UI.el('<div class="x-feed"></div>'); homeFeed = f;
        v.content.append(xTabs(['Para ti', 'A seguir'], i => feedInto(f, i ? 'home' : 'explore', null, v)), f);
        feedInto(f, 'explore', null, v); v.appendChild(fab(v)); return v; };
      /* debounce de 180 ms (como o Explorar do Instashot) e guarda de sequencia: cada tecla lancava 2 RPC e reconstruia a lista, e uma resposta atrasada pintava por cima da mais recente */
      const search = () => { const v = xview({ cls: 'x-search', title: '', left: [meBtn()] }); const res = UI.el('<div class="x-res"></div>'); let sT = null, seq = 0;
        const run = async q => { const my = ++seq; res._seq = (res._seq || 0) + 1; res.innerHTML = ''; if (!q) { trends(); return; } if (q.startsWith('#')) { feedInto(res, 'hashtag', q.slice(1), v); return; }
          const us = xarr(await rpc('social.search', { app, q })); if (my !== seq) return;
          if (us.length) { res.appendChild(UI.el('<div class="x-sh-h">Pessoas</div>')); us.forEach(u => res.appendChild(userRow(u))); }
          const ps = xarr(await rpc('social.feed', { app, mode: 'explore' })).filter(p => (p.content || '').toLowerCase().includes(q.toLowerCase())); if (my !== seq) return;
          if (ps.length) { const lz = lzOf(res, v); res.appendChild(UI.el('<div class="x-sh-h">Posts</div>')); ps.forEach(p => res.appendChild(postEl(p, false, lz))); }
          if (!us.length && !ps.length) { const e = UI.empty('search', 'Sem resultados', 'Tenta outro nome ou #hashtag.'); e.classList.add('compact'); res.appendChild(e); } };
        /* o campo vive NA BARRA, como no X (avatar à esquerda, pesquisa ao centro) */
        const s = UI.search('Pesquisar no Tweeter', q => { clearTimeout(sT); sT = setTimeout(() => run(q), 180); }); v.navbar.insertBefore(s, v.navbar.querySelector('.nb-right'));
        v.opts.onPop = () => clearTimeout(sT); v.content.appendChild(res); v.appendChild(fab(v));
        /* com a guarda de sequência: escrever antes de o feed responder fazia as tendências aterrarem no meio dos resultados */
        const trends = async () => { const my = seq; const ps = xarr(await rpc('social.feed', { app, mode: 'explore' })); if (my !== seq) return; const tags = {}; ps.forEach(p => ((p.content || '').match(/#[\wÀ-ÿ]+/g) || []).forEach(t => tags[t] = (tags[t] || 0) + 1)); const items = Object.entries(tags).sort((a, b) => b[1] - a[1]).slice(0, 10);
          const box = UI.el('<div class="x-trends"><div class="x-sh-h">Tendências para ti</div></div>');
          if (!items.length) box.appendChild(UI.el('<div class="x-tr-none">Sem tendências ainda</div>'));
          /* número e "Posts" em nós separados: o rótulo é a chave de sempre e o número não entra na frase */
          items.forEach(([t, n], i) => { const r = UI.el(`<div class="x-tr"><div class="x-tr-s" data-noi18n>${i + 1}</div><b data-noi18n>${esc(t)}</b><div class="x-tr-n"><span data-noi18n>${n}</span> <span>Posts</span></div></div>`); r.onclick = () => tagView(t.slice(1)); box.appendChild(r); });
          res.appendChild(box); }; trends(); return v; };
      /* linha de uma pessoa (pesquisa, seguidores): avatar, nome, @, bio e o botão Seguir */
      const userRow = u => { const r = UI.el(`<div class="x-urow">${av(u, 'sm')}<div class="x-ub"><div class="x-un"><b data-noi18n>${esc(u.name || u.username)}</b>${xvb(u.username)}</div><div class="x-hn" data-noi18n>@${esc(u.username)}</div>${(u.bio || '').trim() ? `<div class="x-ubio" data-noi18n>${esc(u.bio)}</div>` : ''}</div></div>`);
        if (!u.me && u.username !== me.username) r.appendChild(followPill(u)); r.onclick = () => userView(u.username); return r; };
      const followPill = u => { const b = UI.el(`<div class="x-pill ${u.isFollowing ? 'ol' : 'sol'} nostop">${u.isFollowing ? 'A seguir' : 'Seguir'}</div>`);
        b.onclick = async ev => { ev.stopPropagation(); if (b._busy) return; b._busy = true; const r = await rpc('social.follow', { app, target: u.username }); b._busy = false; if (!r) return; u.isFollowing = !!r.following; b.className = 'x-pill nostop ' + (u.isFollowing ? 'ol' : 'sol'); b.textContent = u.isFollowing ? 'A seguir' : 'Seguir'; if (b.onFollow) b.onFollow(u.isFollowing); }; return b; };
      const peopleView = (title, username, mode) => { const v = xview({ cls: 'x-people', title, back: true }); const box = UI.el('<div class="x-plist"></div>'); v.content.appendChild(box); box.appendChild(UI.spinner()); UI.push(win, v);
        rpc('social.followers', { app, username, mode }).then(l => { box.innerHTML = ''; l = xarr(l); if (!l.length) { const e = UI.empty('users', 'Ninguém aqui', ''); e.classList.add('compact'); box.appendChild(e); return; } l.forEach(u => box.appendChild(userRow(u))); }); };
      /* ---------- compositor (ecrã inteiro, como no X; nos dobráveis fica a folha centrada) ----------
         o = { replyTo, quote, photo, card }. A folha é o UI.sheet de sempre: é ele que tem as regras dos botões do cabeçalho (não tiram o
         foco, o clique não se perde quando o teclado desce). Sem maxlength de propósito: o limite vê-se no anel e recusa-se ao publicar, em vez
         de o texto colado ser cortado em silêncio. A linha das ferramentas NÃO pode ter a classe `pad` (raiz do painel admin, admin.css, fixed +
         z-index 2200 + opacity 0): ficava uma camada invisível por cima da folha e o Publicar nunca recebia o clique (26 out 2026). */
      async function compose(o = {}) {
        if (cmpOpen) { if (o.photo) cmpOpen(o.photo); return; }   /* dois toques no botão abriam duas folhas sobre o mesmo rascunho */
        const replyTo = o.replyTo || null, quote = o.quote || null, label = replyTo ? 'Responder' : 'Publicar'; let photo = null, loc = '';
        const dk = replyTo ? 'r' + replyTo.id : quote ? 'q' + quote.id : 'new'; let armed = false, offAC = null, offAK = null;
        const rpTxt = replyTo ? esc(L.tf('a responder a @%s', replyTo.author)).replace(esc('@' + replyTo.author), m => `<span class="x-at">${m}</span>`) : '';
        const body = UI.el(`<div class="x-cmp">${replyTo ? `<div class="x-cmp-rp" data-noi18n>${rpTxt}</div>` : ''}<div class="x-cmp-row">${meAv('sm')}<textarea class="ta txt" placeholder="${replyTo ? 'Escreve a tua resposta' : 'O que está a acontecer?'}" rows="1"></textarea></div><div class="x-cmp-ph"><div class="x-cmp-x">${XI.x}</div></div>${quote ? `<div class="x-cmp-qt">${quoteCard(quote)}</div>` : ''}<div class="x-cmp-loc"><span class="t" data-noi18n></span><span class="x-cmp-locx">${XI.x}</span></div></div>`);
        const foot = UI.el(`<div class="x-cmp-foot"><div class="x-cmp-who">${g('globe', 16)}<span>Todos podem responder</span></div><div class="x-emo">${XQUICK.map(x => `<span>${x}</span>`).join('')}</div><div class="x-cmp-bar"><div class="x-t img">${XI.image}</div><div class="x-t gif">${XI.gif}</div><div class="x-t poll off">${XI.poll}</div><div class="x-t loc">${XI.pin}</div><div class="x-t emo">${XI.smile}</div><div class="x-cnt"><svg viewBox="0 0 24 24"><circle class="x-cnt-bg" cx="12" cy="12" r="10"/><circle class="x-cnt-fg" cx="12" cy="12" r="10"/></svg><b class="cnt" data-noi18n></b></div></div></div>`);
        const ta = body.querySelector('.txt'), ph = body.querySelector('.x-cmp-ph'), locEl = body.querySelector('.x-cmp-loc'), fg = foot.querySelector('.x-cnt-fg'), cntEl = foot.querySelector('.x-cnt'), cntB = foot.querySelector('.cnt');
        const MAX = 280, RING = 62.83;   /* 2π·10 */
        const size = () => Array.from(ta.value).length;   /* por pontos de código: um emoji conta 1 */
        let btn = null;
        const saveDraft = () => { if (!armed) return; if (!ta.value.trim() && !photo && !loc) { draftDrop(dk); return; } draftPut(dk, { t: ta.value.slice(0, 4000), loc, photo: photo && photo.id ? { id: photo.id, seed: photo.seed || null, video: !!photo.video, duration: photo.duration || null } : null }); };
        /* o anel dos 280: azul a encher; a 20 do fim fica amarelo e mostra o que falta; passado o limite fica vermelho com o número
           negativo. O Publicar apaga-se (.off) mas continua a responder ao toque: um botão morto foi precisamente a queixa, por isso diz o que falta. */
        const upd = () => { const n = size(), left = MAX - n; fg.style.strokeDasharray = `${(RING * Math.min(1, n / MAX)).toFixed(2)} ${RING}`; cntEl.classList.toggle('warn', left <= 20 && left >= 0); cntEl.classList.toggle('over', left < 0); cntB.textContent = left <= 20 ? String(left) : ''; if (btn) btn.classList.toggle('off', (!ta.value.trim() && !photo) || left < 0); ta.style.height = 'auto'; ta.style.height = Math.max(photo || quote ? 40 : 120, ta.scrollHeight) + 'px'; saveDraft(); };   /* com fotografia ou citação o campo encolhe: elas ficam logo por baixo do texto, como no X */
        /* vídeo (12 nov 2026): a pré-visualização é a CAPA com o play e a duração; o vídeo em si nunca desce aqui (o servidor copia-o da galeria) */
        const setPhoto = p => { photo = p || null; ph.classList.toggle('on', !!photo); ph.style.backgroundImage = photo ? Photos.bg(photo) : ''; const ob = ph.querySelector('.sv-static'); if (ob) ob.remove(); ph.classList.toggle('sv-host', !!(photo && photo.video));
          if (photo && photo.video) { ph.appendChild(SV.badge(photo.duration, true)); Promise.resolve(Photos.poster(photo, true)).then(u => { if (u && photo === p) ph.style.backgroundImage = Photos.bg(photo); }).catch(() => {}); }
          else if (photo) Promise.resolve(Photos.data(photo)).then(u => { if (u && photo === p) ph.style.backgroundImage = imgCss(u); }).catch(() => {}); upd(); };   /* pelo CSSOM, e a galeria é lazy: sem o data a pré-visualização ficava no gradiente */
        const setLoc = l => { loc = (l || '').trim(); locEl.classList.toggle('on', !!loc); locEl.querySelector('.t').textContent = loc; saveDraft(); };
        /* depois de uma camada por cima (galeria, local, o aviso do Cancelar) o campo volta a ter o foco e o teclado regressa */
        const refocus = () => setTimeout(() => { if (sh.el.isConnected && !sh.el.classList.contains('closing') && !document.querySelector('.overlay.in,.as-wrap.in')) ta.focus(); }, 90);
        ta.oninput = upd; body.querySelector('.x-cmp-x').onclick = () => setPhoto(null); locEl.querySelector('.x-cmp-locx').onclick = () => setLoc('');
        const qm = body.querySelector('.x-cmp-qt .x-md'); if (qm) { postBg(qm, quote); loadNow(qm); if (quote.video) { qm.classList.add('sv-host'); qm.appendChild(SV.badge(Math.round((+quote.video.dur || 0) / 1000))); } }
        /* as ferramentas não tiram o foco ao campo (preventDefault no pointerdown, o truque das teclas do teclado virtual): o teclado fica e
           a folha não desce debaixo do dedo. As que abrem OUTRA camada (galeria, local, link) largam o campo de propósito: a camada nova não é
           levantada pelo teclado (o place() só corre no focusin) e ficava escondida atrás das teclas. */
        foot.addEventListener('pointerdown', e => { if (e.target.closest('.x-t, .x-emo span')) e.preventDefault(); });
        /* a galeria mostra também os vídeos quando o servidor deixa publicá-los no Tweeter; um vídeo que vá ser recusado diz porquê já */
        foot.querySelector('.img').onclick = async () => { ta.blur(); const vid = await SV.allow('twix'); const p = await Photos.pick(vid ? 'Fotografia ou vídeo' : 'Escolher foto', { videos: vid }); if (p && p.video) { const bad = await SV.precheck(p, 'twix'); if (bad) { SV.alert(bad); refocus(); return; } } if (p) setPhoto(p); refocus(); };
        /* GIF = uma imagem por link (Config.PhotoLinks, a lista branca do servidor manda); sondagens não existem no servidor: diz-se, em vez de um botão morto */
        const gifOn = !!(Photos.linksOn && Photos.linksOn()); foot.querySelector('.gif').classList.toggle('off', !gifOn);
        foot.querySelector('.gif').onclick = () => { if (!gifOn) { UI.toast('Indisponível'); return; } ta.blur(); Photos.addFromLink(p => { setPhoto(p); refocus(); }); };
        foot.querySelector('.poll').onclick = () => UI.toast('Indisponível');
        foot.querySelector('.loc').onclick = async () => { ta.blur(); const l = await UI.prompt('Localização', '', 'Adicionar localização', loc); if (l !== null) setLoc(l.slice(0, 40)); refocus(); };
        foot.querySelector('.emo').onclick = () => { foot.classList.toggle('emo'); };
        foot.querySelectorAll('.x-emo span').forEach(s => { s.onclick = () => { const a = ta.selectionStart == null ? ta.value.length : ta.selectionStart, b = ta.selectionEnd == null ? a : ta.selectionEnd; ta.value = ta.value.slice(0, a) + s.textContent + ta.value.slice(b); ta.selectionStart = ta.selectionEnd = a + s.textContent.length; upd(); if (document.activeElement !== ta) ta.focus(); }; });
        /* vazio: dizia nada e a folha ficava (parecia um botão morto) - agora diz o que falta. Com texto, a folha FICA aberta até o
           servidor aceitar (postFromSheet, 4 nov 2026): numa recusa ou tempo esgotado o rascunho já não se perde. Um segundo toque
           com o pedido a correr não publica duas vezes (sh._busy, no postFromSheet). */
        const sh = UI.sheet({ cls: 'x-sh x-compose', title: '', left: 'Cancelar', right: label, body, foot, onClose: () => { cmpOpen = null; if (offAC) offAC(); if (offAK) offAK(); }, onDone: () => { const t = ta.value.trim(); if (!t && !photo) { Sound.play('error'); UI.toast('Escreve alguma coisa primeiro.'); return false; }
          if (size() > MAX) { Sound.play('error'); UI.toast('Máximo de 280 caracteres.'); return false; }
          if (window.CC && CC.requireNet && !CC.requireNet('publicar')) return false;
          /* o mesmo que no compositor do Instashot: o social.post pode recusar e o "Publicado" era incondicional. A fotografia vai
             por REFERÊNCIA (postImage → photoId): `photo.url` inteiro num só evento era o que fazia o tweet com foto nunca sair.
             A localização vai no formato de sempre (splitLoc, o mesmo do Instashot). */
          return postFromSheet(sh, label, app, photo, { content: (loc ? '📍 ' + loc + '\n' : '') + t, replyTo: replyTo ? replyTo.id : null, repostOf: quote ? quote.id : null }, r => { armed = false; draftDrop(dk); onPosted(r, o); }); } });
        cmpOpen = setPhoto; btn = sh.el.querySelector('.sh-r');
        /* de ecrã inteiro não há fundo para tocar, só nos 480 ms em que a folha sobe: aí o segundo toque de um duplo toque no botão de escrever caía nele e fechava-a */
        if (!document.body.classList.contains('form-fold')) sh.el.onclick = null;
        /* o gesto de casa e o matar a app: a folha de ecrã inteiro vive no #screen, fora da janela, e ficava por cima de tudo. O rascunho já está no Store */
        offAC = Bridge.on('app:close', id => { if (id === app) sh.close(); }); offAK = Bridge.on('app:kill', id => { if (id === app) sh.close(); });
        /* Cancelar com alguma coisa escrita pergunta, como no X; a pedido a correr não faz nada (fechava a folha e a publicação saía na mesma). O
           UI.actionSheet vive por baixo do teclado (#kb 250 > .as-wrap 195): o campo larga-se primeiro e volta se o jogador desistir de cancelar. */
        const rowOf = id => (Photos.cache || []).find(x => x && x.id === id);
        sh.el.querySelector('.sh-l').onclick = async () => { if (sh._busy) return; if (!ta.value.trim() && !photo && !loc) { draftDrop(dk); sh.close(); return; } ta.blur();
          const k = await UI.actionSheet({ cls: 'x-sh x-as', buttons: [{ label: 'Apagar', icon: 'trash', danger: true, value: 'del' }, { label: 'Guardar rascunho', icon: 'bookmark', value: 'keep' }] });
          if (k === 'del') { armed = false; draftDrop(dk); sh.close(); } else if (k === 'keep') sh.close(); else refocus(); };
        const d0 = draftGet(dk);
        if (d0) { ta.value = d0.t || ''; setLoc(d0.loc || ''); const dp = d0.photo; if (dp && !o.photo) { setPhoto(rowOf(dp.id) || dp); if (!rowOf(dp.id)) Promise.resolve(Photos.load()).then(() => { const r = rowOf(dp.id); if (r && photo === dp) setPhoto(r); }).catch(() => {}); } }
        upd(); armed = true; if (o.photo) setPhoto(o.photo);
        /* Enter (teclado do PC) publica pelo MESMO botão, com as mesmas guardas; Shift+Enter = linha nova, e a tecla "enter" do teclado do
           telemóvel continua a ser linha nova (keyboard.js escreve-a sem keydown nos textarea), como no X */
        ta.onkeydown = e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); btn.click(); } };
        /* 520 ms e não os 400 de antes: a folha sobe com mola em 480 ms (--motion-sheet) e o teclado mede-a no focusin; a meio da mola media-a
           fora do sítio e a barra das ferramentas ficava um pixel debaixo das teclas */
        setTimeout(() => { if (sh.el.isConnected && !sh.el.classList.contains('closing')) ta.focus(); }, 520); }
      /* publicado: a linha nova entra no sítio certo sem reconstruir nada - no topo do feed da raiz, ou no fio se for uma resposta a um fio
         aberto; sem o Início na pilha, abre-se o Início. Com o feed ainda a carregar (FAB tocado antes de ele chegar) a resposta que vem a
         caminho pode já não trazer a publicação e apagava-a da lista: pede-se outra vez. */
      const onPosted = (r, o) => { const p = enrichMine(r); if (o.quote) p.original = o.quote;
        if (o.replyTo) { const th = threads.get(o.replyTo.id); if (th) { addReply(th, p); return; } const n = (o.replyTo.comments || 0) + 1; o.replyTo.comments = n; eachCard(o.replyTo.id, (c, s) => { s.comments = n; paintRp(c, s); }); return; }
        const f = homeFeed, root = win.querySelector(':scope > .nav-stack > .view.x-home');
        if (!f || !f.isConnected || !root) { tabs.go(0); return; }
        if (f._loading) { feedInto(f, f._mode, null, root); return; }
        const em = f.querySelector(':scope > .empty'); if (em) em.remove(); f.insertBefore(postEl(p, false, f._lz || null), f.firstChild); try { root.content.scrollTo({ top: 0, behavior: 'smooth' }); } catch (e) {} };
      /* Repostar · Citar (a folha do X). O repost é o MESMO social.post do botão de partilhar: rpcRaw, senão o "Repost feito" aparecia com o
         servidor a recusar; sem conta (apagada com a app aberta) o aviso com o código e a app fecha de facto (refused → staleProfile).
         `t` é sempre o ORIGINAL (o `act` do cartão). Repostar duas vezes duplicava a linha: a folha passa a dizer «Desfazer repost», que apaga a
         minha linha (`myRepost`, vem do servidor, por isso vale noutro aparelho), e o servidor recusa o duplicado ('reposted') por quem chegar lá de outra maneira. */
      const repostSheet = async t => { const on = !!t.reposted;
        const k = await UI.actionSheet({ cls: 'x-sh x-as', buttons: [{ label: on ? 'Desfazer repost' : 'Repostar', icon: 'repeat', value: 'rp' }, { label: 'Citar', icon: 'pen', value: 'q' }] });
        if (k === 'q') { compose({ quote: t }); return; } if (k !== 'rp') return;
        if (window.CC && CC.requireNet && !CC.requireNet('fazer repost')) return;
        if (on) { const row = t.myRepost; if (!row || !await rpc('social.deletePost', { app, postId: row })) { UI.toast('Não foi possível fazer repost'); return; } unReposted(t.id); win.querySelectorAll('.x-post').forEach(c => { if (c._ids && c._ids[0] === row) c.remove(); }); return; }
        const r = await Bridge.rpcRaw('social.post', { app, content: '', repostOf: t.id });
        if (r && r.error === 'reposted') { eachCard(t.id, (c, s) => { s.reposted = true; s.myRepost = r.id; paintRt(c, s); }); return; }   /* já estava (outro aparelho, feed antigo): só falta pintar */
        if (!r || r.error) { if (r && r.error === 'noprofile') { refused(app, r); return; } console.error('[apex_phone] social.post (repost) refused (' + app + '): ' + (r && r.error || 'empty')); UI.toast(r && (POST_ERR[r.error] || ERR_MSG[r.error]) || 'Não foi possível fazer repost'); return; }
        const n = (t.reposts || 0) + 1; t.reposts = n; t.reposted = true; t.myRepost = r.id; eachCard(t.id, (c, s) => { s.reposts = n; s.reposted = true; s.myRepost = r.id; paintRt(c, s); }); Sound.play('success'); UI.toast('Repost feito'); };
      const bookmark = async (p, el) => { if (el._busy) return; el._busy = true; const r = await rpc('social.save', { app, postId: p.id }); el._busy = false; if (!r) return; p.saved = !!r.saved; eachCard(p.id, (c, s) => { s.saved = p.saved; const b = c.querySelector('.x-a.bm'); if (b) { b.classList.toggle('on', p.saved); b.firstElementChild.outerHTML = p.saved ? XI.bmF : XI.bm; } }); UI.toast(p.saved ? 'Guardado' : 'Removido dos guardados'); };
      /* ---------- o fio de uma publicação: a publicação em grande, as respostas e a caixa de resposta PRESA em baixo ----------
         `full`: a barra de separadores esconde-se (a caixa ficava por baixo dela - o mesmo defeito das DMs do Instashot, 4 nov 2026) */
      const addReply = (th, r) => { if (!th.list.isConnected) return; const em = th.list.querySelector(':scope > .empty'); if (em) em.remove(); th.list.appendChild(postEl(r, false, null)); const n = (th.post.comments || 0) + 1; th.post.comments = n; eachCard(th.post.id, (c, s) => { s.comments = n; paintRp(c, s); }); try { th.v.content.scrollTo({ top: th.v.content.scrollHeight, behavior: 'smooth' }); } catch (e) {} };
      const postView = async (p, card) => { const v = xview({ cls: 'x-thread', title: 'Post', back: true, full: true }); const main = postEl(p, true, null), list = UI.el('<div class="x-replies"></div>'); v.content.append(main, list);
        const bar = UI.el(`<div class="x-rbar">${meAv('xs')}<input type="text" class="x-rin" placeholder="Escreve a tua resposta" maxlength="280" enterkeyhint="send"><div class="x-rsend off">Responder</div></div>`); v.appendChild(bar);
        const inp = bar.querySelector('.x-rin'), send = bar.querySelector('.x-rsend'); const th = { v, list, post: p, main, inp, card }; threads.forEach((x, k) => { if (!x.v.isConnected) threads.delete(k); }); threads.set(p.id, th);
        /* O TECLADO NÃO SOBE A JANELA NO FIO (6 nov 2026): o place() subia-a 246 px, a publicação a que se responde e a seta do Voltar saíam do ecrã e o
           primeiro toque só servia para descer o teclado. A janela anula a subida (.x-nolift, ao nível da variável) e é a vista que encolhe até
           às teclas: a barra fica, o .content acaba por cima da caixa e esta assenta nas teclas. Vigia-se a classe do #kb, que é o que diz que ele está lá. */
        const kbEl = document.getElementById('kb');
        const fit = () => { if (!v.isConnected) { if (mo) mo.disconnect(); return; } const on = !!kbEl && kbEl.classList.contains('in') && (document.activeElement === inp || v.classList.contains('x-kb')); if (on) { const kz = UI.zoom ? UI.zoom(v) / UI.zoom(UI.screen()) : 1; v.style.setProperty('--x-kb-h', (kbEl.offsetHeight + (parseFloat(getComputedStyle(kbEl).bottom) || 0)) / (kz || 1) + 'px'); } v.classList.toggle('x-kb', on); };
        const mo = kbEl && window.MutationObserver ? new MutationObserver(fit) : null; if (mo) mo.observe(kbEl, { attributes: true, attributeFilter: ['class'] });
        win.classList.add('x-nolift');
        const prevPop = v.opts.onPop; v.opts.onPop = () => { if (threads.get(p.id) === th) threads.delete(p.id); if (mo) mo.disconnect(); if (![...threads.values()].some(x => x.v.isConnected && x !== th)) win.classList.remove('x-nolift'); prevPop && prevPop(); };
        UI.push(win, v);
        /* o Responder não tira o foco ao campo (o teclado fica para a resposta seguinte, como nos comentários); Enter = enviar
           (enterkeyhint=send: o teclado do telemóvel rotula a tecla "Enviar") */
        send.addEventListener('pointerdown', e => e.preventDefault());
        /* a caixa guarda o texto por publicação: voltar atrás a meio não o perde */
        const dk = 't' + p.id, d0 = draftGet(dk); if (d0 && d0.t) { inp.value = d0.t; send.classList.remove('off'); }
        inp.oninput = () => { send.classList.toggle('off', !inp.value.trim()); if (inp.value.trim()) draftPut(dk, { t: inp.value }); else draftDrop(dk); };
        let busy = false;
        const reply = async () => { const t = inp.value.trim(); if (!t || busy) return; if (window.CC && CC.requireNet && !CC.requireNet('responder')) return; busy = true; send.classList.add('busy');
          const r = await Bridge.rpcRaw('social.post', { app, content: t, replyTo: p.id }).catch(e => { console.error('[apex_phone] social.post (reply)', e); return { error: 'client' }; });
          busy = false; send.classList.remove('busy'); if (!r || r.error) { refused(app, r); return; }
          inp.value = ''; draftDrop(dk); send.classList.add('off'); Sound.play('success'); addReply(th, enrichMine(r)); };
        send.onclick = reply; inp.onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); reply(); } };
        list.appendChild(UI.spinner()); const rs = xarr(await rpc('social.replies', { app, postId: p.id })); if (!v.isConnected) return; list.innerHTML = '';
        const lz = rs.length ? lazyBg(v) : null; rs.forEach(r => list.appendChild(postEl(r, false, lz))); };
      /* ---------- perfil: capa, avatar de 80 a sobrepô-la, Seguir / Editar perfil, contadores e separadores ----------
         O servidor só devolve publicações sem reply_to e não guarda gostos por pessoa em lista, por isso dois separadores são reconstruídos:
         Respostas = as desta pessoa nas 10 publicações recentes com respostas (10 social.replies, só ao tocar; o balde são 12/s com 40 de folga);
         Gostos só no MEU perfil, como no X, e olha para as 60 publicações recentes (o `liked` do feed). Marcadores é a lista do social.saves. */
      const profileInto = async (v, username) => { const old = v.content.querySelector('.x-pfeed'); if (old && old._lz) old._lz.stop(); v.content.innerHTML = ''; const sp = UI.spinner(); v.content.appendChild(sp);   /* sem isto ficava um ecrã em branco durante o RPC */
        const u = await rpc('social.user', { app, username }); sp.remove(); if (!v.isConnected) return;
        if (!u) { v.navbar.classList.add('x-solid'); v.content.appendChild(UI.empty('personCircle', 'Utilizador não encontrado', 'Este nome não existe nesta rede.')); return; }
        /* UMA raiz só: o UI.el devolve apenas o primeiro filho (a capa e a ficha são irmãos dentro do invólucro) */
        const head = UI.el(`<div class="x-prof"><div class="x-banner" style="${UI.avatarStyle(u.avatar)}"></div><div class="x-ph"><div class="x-pav">${av(u, 'lg')}</div><div class="x-pbtns"></div><div class="x-pnm"><span data-noi18n>${esc(u.name || u.username)}</span>${xvb(u.username)}</div><div class="x-phd" data-noi18n>@${esc(u.username)}</div>${(u.bio || '').trim() ? `<div class="x-pbio" data-noi18n>${UI.linkify(u.bio)}</div>` : ''}${u.website ? `<div class="x-pmeta"><span class="x-ws">${XI.link}<a data-noi18n>${esc(u.website)}</a></span></div>` : ''}<div class="x-pst"><span class="x-pfg"><b data-noi18n>${+u.following || 0}</b> <span>A seguir</span></span><span class="x-pfr"><b data-noi18n>${+u.followers || 0}</b> <span>Seguidores</span></span></div></div></div>`);
        const btns = head.querySelector('.x-pbtns');
        head.querySelector('.x-pfr').onclick = () => peopleView('Seguidores', username, 'followers'); head.querySelector('.x-pfg').onclick = () => peopleView('A seguir', username, 'following');
        head.querySelectorAll('.x-pbio .hashtag').forEach(h => h.onclick = ev => { ev.stopPropagation(); h.dataset.tag ? tagView(h.dataset.tag.slice(1)) : userView(h.dataset.user.slice(1)); });
        const ws = head.querySelector('.x-ws'); if (ws) ws.onclick = () => { if (window.App && App.get('safari') && System.isInstalled('safari')) System.openURL('phone://safari/open?url=' + encodeURIComponent(u.website)); else UI.toast(u.website); };
        if (u.me) { const e = UI.el('<div class="x-pill ol">Editar perfil</div>'), m = UI.el(`<div class="x-pill ol x-pmore">${XI.more}</div>`); e.onclick = () => editProfile(u, v);
          m.onclick = ev => UI.ctxMenu(ev.currentTarget, [{ label: 'Silenciadas', icon: 'bellOff', onTap: mutedSheet }]); btns.append(m, e); }
        else { const f = followPill(u); f.onFollow = on => { const c = head.querySelector('.x-pfr b'); c.textContent = Math.max(0, (+c.textContent || 0) + (on ? 1 : -1)); }; btns.appendChild(f); }
        v.content.appendChild(head);
        /* ao rolar, a capa sai e a barra fica sólida com o nome e o número de publicações, como no X: antes o conteúdo passava por baixo da barra de estado e da seta */
        const nb = v.navbar, nt = nb.querySelector('.nb-title'); nt.innerHTML = `<b data-noi18n>${esc(u.name || u.username)}</b><span><span data-noi18n>${+u.posts || 0}</span> <span>publicações</span></span>`;
        if (!v._xs) { v._xs = true; const onSc = () => { const y = v.content.scrollTop; nb.classList.toggle('x-solid', y > 40); nb.classList.toggle('x-named', y > 190); }; v.content.addEventListener('scroll', onSc, { passive: true }); }
        const holder = UI.el('<div class="x-pfeed"></div>');
        const TABS = [['Publicações', 'posts'], ['Respostas', 'replies'], ['Media', 'media']].concat(u.me ? [['Gostos', 'likes'], ['Marcadores', 'saved']] : []);
        const pane = async k => { if (k === 'posts') { feedInto(holder, 'user', username, v); return; }
          holder.innerHTML = ''; holder.classList.add('feed'); holder.appendChild(UI.spinner()); const lz = lzOf(holder, v), seq = (holder._seq = (holder._seq || 0) + 1); let ps = [];
          if (k === 'media') ps = xarr(await rpc('social.feed', { app, mode: 'user', ref: username })).filter(hasMedia);
          else if (k === 'saved') ps = xarr(await rpc('social.saves', { app }));
          else { const all = xarr(await rpc('social.feed', { app, mode: 'explore' })); if (k === 'likes') ps = all.filter(p => p.liked);
            else for (const p of all.filter(x => x.comments > 0).slice(0, 10)) { if (holder._seq !== seq) return; ps = ps.concat(xarr(await rpc('social.replies', { app, postId: p.id })).filter(r => r.author === username)); } }
          if (holder._seq !== seq) return; holder.innerHTML = '';
          if (!ps.length) { holder.appendChild(k === 'saved' ? UI.empty('bookmark', 'Sem guardados', 'Toca no marcador de uma publicação para a guardares.') : k === 'media' ? UI.empty('photo', 'Sem media', '') : UI.empty(k === 'likes' ? 'heart' : 'chat', 'Nada por aqui', '')); return; }
          if (k !== 'media') { ps.forEach(p => holder.appendChild(postEl(p, false, lz))); return; }
          const gr = UI.el('<div class="x-grid"></div>'); ps.forEach(p => { const d = UI.el('<div class="x-gi"></div>'); postBg(d, p); if (p.video) SV.tile(d, p.video); lz.add(d); d.onclick = () => postView(p); gr.appendChild(d); }); holder.appendChild(gr); };
        const tabsBar = xTabs(TABS.map(t => t[0]), i => pane(TABS[i][1])); tabsBar.classList.add('x-ptabs'); v.content.append(tabsBar, holder); pane('posts'); };
      const userView = username => { const v = xview({ cls: 'x-prof-v', title: '', back: true }); v.appendChild(fab(v)); UI.push(win, v); profileInto(v, username); };
      const tagView = tag => { const v = xview({ cls: 'x-tag', title: '#' + tag, back: true }); const f = UI.el('<div class="x-feed"></div>'); v.content.appendChild(f); v.appendChild(fab(v)); UI.push(win, v); feedInto(f, 'hashtag', tag, v); };
      /* editar perfil (folha do X): foto, nome, bio, site. O social.updateProfile só mexe no que vai (o nome de utilizador não muda aqui).
         Como o compositor: a folha só fecha quando o servidor aceita, e a recusa mostra o código. */
      async function editProfile(u, pv) { let avatar = u.avatar || 1, avatarUrl = u.avatarUrl || u.avatar_url || null;
        const body = UI.el(`<div class="x-edit"><div class="x-eav"><div class="pvwrap"></div><span>Toca para mudar a fotografia</span></div><div class="x-fld"><label>Nome</label><input type="text" class="nm" maxlength="40" placeholder="O teu nome"></div><div class="x-fld"><label>Bio</label><textarea class="ta bio" maxlength="160" placeholder="Bio"></textarea></div><div class="x-fld"><label>Site</label><input type="text" class="ws" maxlength="90" placeholder="exemplo.com"></div></div>`);
        body.querySelector('.nm').value = u.name || ''; body.querySelector('.bio').value = u.bio || ''; body.querySelector('.ws').value = u.website || '';   /* valores pelo DOM, nunca dentro da string (aspas, <, >) */
        const wrap = body.querySelector('.pvwrap');
        const paintAv = () => { wrap.innerHTML = UI.avatar({ name: u.username, avatar, url: avatarUrl }, 'lg'); wrap.firstElementChild.onclick = chooseAv; };
        async function chooseAv() { const k = await UI.actionSheet({ title: 'Foto de perfil', buttons: [{ label: 'Escolher das minhas fotos', icon: 'photo', value: 'pick' }, { label: 'Usar uma cor', icon: 'personCircle', value: 'col' }].concat(avatarUrl ? [{ label: 'Remover fotografia', icon: 'trash', danger: true, value: 'del' }] : []) });
          if (k === 'pick') { const s = await avatarFromPhotos('Foto de perfil'); if (s) { avatarUrl = s; paintAv(); } } else if (k === 'col') { avatar = avatar % 12 + 1; avatarUrl = null; paintAv(); } else if (k === 'del') { avatarUrl = null; paintAv(); } }
        paintAv();
        const sh = UI.sheet({ cls: 'x-sh x-edit-sh', title: 'Editar perfil', left: 'Cancelar', right: 'Guardar', body, onDone: () => { if (sh._busy) return false; sh._busy = true; const btn = sh.el.querySelector('.sh-r'); btn.style.opacity = '.5';
          Bridge.rpcRaw('social.updateProfile', { app, avatar, avatarUrl: avatarUrl || '', name: body.querySelector('.nm').value.trim(), website: body.querySelector('.ws').value.trim(), bio: body.querySelector('.bio').value.trim() }).then(r => { sh._busy = false; btn.style.opacity = '';
            if (!r || r.error) { UI.alert({ title: 'Não guardado', msg: r && r.error === 'toolarge' ? 'A fotografia é grande demais.' : errMsg(r && r.error), foot: r && r.error ? String(r.error) : 'empty' }); return; }
            profileCache[app] = r; me.avatar = r.avatar; me.avatarUrl = r.avatar_url || null; me.name = r.name; Sound.play('success'); UI.toast('Perfil atualizado'); sh.close(); refreshMe(); if (pv && pv.isConnected) profileInto(pv, me.username); });
          return false; } }); }
      const notifs = () => { const v = xview({ cls: 'x-notif', title: 'Notificações', left: [meBtn()] }); const box = UI.el('<div class="x-nlist"></div>'); v.content.appendChild(box); box.appendChild(UI.spinner()); v.appendChild(fab(v));
        rpc('social.notifications', { app }).then(ns => { ns = xarr(ns); box.innerHTML = ''; if (!ns.length) { box.appendChild(UI.empty('bell', 'Sem notificações', '')); return; }
          /* o nome num nó próprio (data-noi18n) e a frase noutro: "gostou do teu post" é a chave de sempre; "respondeu: %s" leva o texto do jogador dentro do padrão */
          ns.forEach(n => { const k = ['like', 'comment', 'reply', 'quote', 'repost'].includes(n.type) ? n.type : 'follow', ans = k === 'comment' || k === 'reply', rt = k === 'quote' || k === 'repost'; const r = UI.el(`<div class="x-nrow"><div class="x-nic ${k}">${k === 'like' ? XI.heartF : ans ? XI.reply : rt ? XI.repost : XI.person}</div><div class="x-nbd">${av(n, 'xs')}<div class="x-ntx"><b data-noi18n>${esc(n.username)}</b> <span>${k === 'like' ? 'gostou do teu post' : ans ? 'respondeu: ' + esc(n.content || '') : k === 'quote' ? 'citou o teu post' : k === 'repost' ? 'repostou o teu post' : 'começou a seguir-te'}</span></div><div class="x-tm">${xtime(n.created)}</div></div></div>`); r.onclick = () => userView(n.username); box.appendChild(r); }); }); return v; };
      /* DMs (mensagens diretas via motor de mensagens, app=twix): a implementação está em js/apps/social-dm.js; aqui fica só o contexto.
         resetProfile: o servidor recusou o envio com 'noidentity' (a conta desta rede não é da personagem atual) */
      const dmCtx = () => ({ app, me, win, rpc, onUser: u => userView(u), resetProfile: () => { delete profileCache[app]; } });
      const dms = () => { if (window.SocialDM) return SocialDM.list(dmCtx()); UI.toast('Mensagens indisponíveis'); };
      /* ---------- BARRA DE BAIXO, COMO A DO X: Início · Pesquisar · Vera (o lugar do Grok) · Notificações · Mensagens ----------
         só glifos (opts.plain), o ativo a cheio. Vera e Mensagens NÃO trocam de separador (ficaria o Início por baixo a ser reconstruído):
         a primeira abre a assistente do telemóvel, a segunda empilha as mensagens por cima - e nunca DUAS vezes. O `view: home` delas
         nunca chega a correr, porque o onclick é substituído aqui. */
      tabs = UI.tabbar(win, [{ icon: 'home', label: 'Início', view: home }, { icon: 'search', label: 'Pesquisar', view: search }, { icon: 'star', label: 'Vera', view: home }, { icon: 'bell', label: 'Notificações', view: notifs }, { icon: 'mail', label: 'Mensagens', view: home }], 0, { plain: true });
      const TBI = [['home', 'homeF'], ['search', 'searchF'], ['grok', 'grok'], ['bell', 'bellF'], ['mail', 'mailF']];
      tabs.el.querySelectorAll('.tab').forEach((t, i) => { const s = t.querySelector('svg'); if (s && TBI[i]) s.outerHTML = `<div class="x-tbi"><i class="x-o">${XI[TBI[i][0]]}</i><i class="x-f">${XI[TBI[i][1]]}</i></div>`; });
      const gt = tabs.el.querySelectorAll('.tab')[2]; if (gt) { if (window.Vera && Vera.open) gt.onclick = () => Vera.open(); else gt.style.display = 'none'; }
      const mt = tabs.el.querySelectorAll('.tab')[4]; if (mt) { if (window.SocialDM) mt.onclick = () => { const st = win.querySelector('.nav-stack'); const top = st && st.lastElementChild; if (top && top.dataset.dm === '1') return; dms(); }; else mt.style.display = 'none'; }
      /* o ponto no envelope: mensagens por ler (o X também só mostra um ponto) */
      const dmDot = async () => { try { const ts = xarr(await rpc('messages.threads', { app })); tabs.badge(4, ts.some(t => t.unread) ? true : 0); } catch (e) {} };
      if (window.SocialDM) dmDot();
      const offDm = Bridge.on('message', () => { if (window.SocialDM) dmDot(); });
      /* "Partilhar → Tweeter" nas Fotos (social:compose): o ouvinte morre com a janela, senão fica a agarrá-la */
      const offCompose = Bridge.on('social:compose', d => { if (d && d.app === app) { const s = d.photo ? { photo: d.photo } : takeShare(app); compose({ photo: s && s.photo }); } });
      const prevClose = win.onClose;
      win.onClose = () => { offCompose(); offDm(); SV.stopAll(); prevClose && prevClose(); };
      const pend = takeShare(app); if (pend) compose({ photo: pend.photo });   /* a fotografia (ou o vídeo) partilhada das Fotos enquanto a app ainda não estava de pé (perfil lento, primeiro registo) */
    }); }
  });

  /* ---------------- REELS (DENTRO do Instashot) ----------------
     A app Reels separada foi retirada (2026-09-18, a pedido do utilizador): duplicava o Instashot. O separador Reels do
     Instashot abre esta camada de ecrã inteiro com as publicações COM FOTO do próprio Instashot, como no Instagram.
     O que se publica aqui leva #reel e aparece também no separador Reels do perfil. `o.dm(username)` abre o Direct.
     12 nov 2026 (VÍDEO): os Reels passam a ser um feed vertical de VÍDEOS a sério. O servidor devolve só as publicações com vídeo ou
     marcadas #reel (social.feed com `reels`); as fotografias continuam a poder ser reels. O reel que fica à vista (60 % do ecrã) começa a
     descer e toca sozinho, em ciclo; o que sai pára (a descida também: só desce o que se está a ver). A câmara em cima à direita
     escolhe da galeria fotografias E vídeos. Devolve { exit, compose(preset) }; com a camada já aberta devolve a mesma. */
  function reelsLayer(win, app, o = {}) {
    const open0 = win.querySelector(':scope > .reels-lay');
    if (open0) return open0._api || null;
    let mode = 'explore';
    const lay = UI.el('<div class="reels-lay"></div>'), root = UI.el('<div class="reels"></div>');
    const top = UI.el('<div class="reels-top"><span class="on" data-m="explore">Para ti</span><span data-m="home">A seguir</span></div>');
    const cam = UI.el(`<div class="reels-cam">${g('camera')}</div>`), back = UI.el(`<div class="reels-back">${g('chevL')}</div>`);
    lay.append(root, top, cam, back); win.appendChild(lay);
    /* fundo preto → barra de estado branca enquanto a camada está aberta (o mesmo mecanismo da Match e dos Mapas) */
    const def = App.get(app) || {}, sbAntes = def.statusBar; def.statusBar = 'dark'; if (System.updateSbTheme) System.updateSbTheme();
    requestAnimationFrame(() => lay.classList.add('in'));
    /* `preset` = o vídeo/fotografia que veio da partilha das Fotos (sem ele abre a galeria) */
    const compose = async preset => { if (window.CC && CC.requireNet && !CC.requireNet('publicar')) return;
        const p = preset || await Photos.pick('Novo reel', { videos: await SV.allow('reels') }); if (!p) return;
        if (p.video) { const bad = await SV.precheck(p, 'reels'); if (bad) { SV.alert(bad); return; } }
        let cap = await UI.prompt('Legenda', '', 'Escreve uma legenda… #tags'); if (cap === null) return;
        if (!/#reel\b/i.test(cap)) cap = (cap ? cap + ' ' : '') + '#reel';   /* aparece no separador Reels do perfil */
        /* rpcRaw: o "Reel publicado" era dito mesmo quando o servidor recusava. A fotografia vai por referência (postImage → photoId),
           o vídeo também (videoId: o servidor copia-o da galeria); `where` diz ao servidor que é um reel (Config.Recording.social.reels) */
        const im = await postImage(p);
        const r = im.error ? im : await Bridge.rpcRaw('social.post', Object.assign({ app, content: cap, where: 'reels' }, im));
        if (!r || r.error) { refused(app, r); return; }   /* com o código por baixo e na F8 (4 nov 2026) */
        Sound.play('success'); UI.toast('Reel publicado'); if (lay.isConnected) load(); };
    cam.onclick = () => compose();
      top.querySelectorAll('span').forEach(s => s.onclick = () => { top.querySelectorAll('span').forEach(x => x.classList.toggle('on', x === s)); mode = s.dataset.m; load(); });
      const reel = p => { const saved = Store.get('reelSaved', []).includes(p.id); const e = UI.el(`<div class="reel"><div class="rv"></div><div class="rside"><div class="pf">${av(p)}<div class="plus">+</div></div><div class="lk ${p.liked ? 'liked' : ''}">${g(p.liked ? 'heartFill' : 'heart')}<span class="lc">${p.likes}</span></div><div class="cm">${g('chat')}<span>${p.comments}</span></div><div class="bm ${saved ? 'on' : ''}">${g('bookmark')}<span>${saved ? 'Guardado' : 'Guardar'}</span></div><div class="sh">${g('send')}<span>Enviar</span></div><div class="mo">${g('more')}</div></div><div class="rbot"><b>@${UI.esc(p.author)}${vb(p.author)} <span style="font-weight:400;opacity:.8">· ${timeAgo(p.created)}</span></b><p>${UI.linkify(p.content)}</p><div class="snd">${g('music')} Som original · ${UI.esc(p.author)}</div></div><div class="disc">${av(p, 'xs')}</div></div>`); if (p.image || !p.imageLen) e._bg = imgCss(p.image || 5); else e._post = p;   /* o fundo so e posto quando o reel se aproxima do ecra (ver lz em load); uma fotografia que vem aos bocados so desce entao */
        /* reel em vídeo: a capa é o fundo; o leitor (SV) toca quando o reel fica à vista (ver o `io` em load) */
        if (p.video) { e.classList.add('is-vid'); e._svp = SV.player(e.querySelector('.rv'), p.video, { loop: true, offscreen: false, reel: true }); }
        /* como no Tweeter: esperar o RPC, senão o coração fica invertido (e o duplo toque no vídeo herda o mesmo defeito) */
        e.querySelector('.lk').onclick = async ev => { const t = ev.currentTarget; await toggleLike(app, p, null, e.querySelector('.lc')); t.classList.toggle('liked', p.liked); t.firstElementChild.outerHTML = g(p.liked ? 'heartFill' : 'heart'); }; let lt = 0; e.querySelector('.rv').onclick = () => { const n = Date.now(); if (n - lt < 350) { const b = UI.el(`<div class="ig-burst">${g('heartFill')}</div>`); e.querySelector('.rv').appendChild(b); setTimeout(() => b.remove(), 900); if (!p.liked) e.querySelector('.lk').click(); } lt = n; };
        e.querySelector('.bm').onclick = ev => { const on = ev.currentTarget.classList.toggle('on'); ev.currentTarget.querySelector('span').textContent = on ? 'Guardado' : 'Guardar'; Store.update('reelSaved', [], l => { const i = l.indexOf(p.id); if (on && i < 0) l.push(p.id); if (!on && i > -1) l.splice(i, 1); }); };
        /* "Não tenho interesse" / "Denunciar" (dois toasts sem efeito) deram lugar ao que existe: enviar o reel por mensagem */
        e.querySelector('.mo').onclick = () => UI.actionSheet({ title: '@' + p.author, buttons: [{ label: 'Enviar por mensagem', icon: 'message', value: 'msg' }, { label: 'Ver perfil', icon: 'personCircle', value: 'prof' }] }).then(v => { if (v === 'msg') share(app, p); else if (v === 'prof') { if (o.profile) { exit(); o.profile(p.author); } else UI.toast('@' + p.author); } });
        e.querySelector('.rbot p').onclick = ev => ev.currentTarget.classList.toggle('long');
        e.querySelector('.plus').onclick = async ev => { ev.stopPropagation(); const r = await rpc('social.follow', { app, target: p.author }); ev.currentTarget.style.display = r && r.following ? 'none' : ''; UI.toast(r && r.following ? 'A seguir @' + p.author : 'Deixaste de seguir'); };
        e.querySelector('.cm').onclick = () => commentsSheet(app, p, n => e.querySelector('.cm span').textContent = n); e.querySelector('.sh').onclick = () => share(app, p);
        e.querySelector('.pf').onclick = async () => { const u = await rpc('social.user', { app, username: p.author }); if (!u) return; const r = await UI.actionSheet({ title: '@' + p.author + (u.me ? ' (tu)' : ''), buttons: u.me ? [{ label: 'Apagar reel', icon: 'trash', danger: true, value: 'del' }] : [{ label: u.isFollowing ? 'Deixar de seguir' : 'Seguir', icon: 'personPlus', value: 'f' }, { label: 'Mensagem', icon: 'message', value: 'm' }] }); if (r === 'f') { await rpc('social.follow', { app, target: p.author }); UI.toast(u.isFollowing ? 'Deixaste de seguir' : 'A seguir @' + p.author); } if (r === 'del') { await rpc('social.deletePost', { app, postId: p.id }); e.remove(); } if (r === 'm') { if (o.dm) { exit(); o.dm(p.author); } else UI.toast('Mensagens indisponíveis'); } };
        return e; };
      /* Só o reel VISÍVEL anima. Antes, os 60 reels devolvidos pelo servidor ficavam todos com duas animações infinitas
         (o Ken Burns num fundo de ecrã inteiro e o disco a rodar) = ~120 animações e ~60 texturas de 440×956 permanentes no CEF. */
      let io = null, lz = null;
      const load = async () => { root.querySelectorAll('.reel').forEach(r => { if (r._svp) r._svp.destroy(); }); root.innerHTML = ''; if (io) { io.disconnect(); io = null; } if (lz) { lz.disconnect(); lz = null; }
        /* só reels: vídeos e publicações marcadas #reel (o servidor já filtra com `reels`; o filtro daqui é a rede de segurança de um
           servidor antigo, que ignora o `reels` e devolvia o feed inteiro). Um post só de texto não faz um reel. */
        const ps = ((await rpc('social.feed', { app, mode, reels: true })) || []).filter(p => p && (p.video || /#reel/i.test(p.content || '')) && (p.video || p.image || p.imageLen));
        if (!lay.isConnected) return;
        if (!ps.length) { const em = UI.el('<div class="reel"></div>'); em.appendChild(UI.empty('reels', 'Sem reels', mode === 'home' ? 'Segue pessoas para veres os reels delas aqui.' : 'Publica o primeiro com a câmara, em cima à direita.')); root.appendChild(em); return; }
        /* o reel à vista toca (e só ele desce); o que sai pára */
        io = new IntersectionObserver(es => es.forEach(x => { x.target.classList.toggle('play', x.isIntersecting); const P = x.target._svp; if (P) { if (x.isIntersecting && !gone) P.play(); else P.pause(); } }), { root, threshold: .6 });
        /* o fundo (pode ser uma fotografia em base64) so entra quando o reel esta a menos de um ecra de distancia e sai quando se afasta:
           em vez de N texturas de 440x956 permanentes no CEF ficam no maximo 3 */
        /* `lazy` (vindo do observer): a descida só avança se o reel ainda estiver perto quando chegar a vez */
        const fill = (t, rv, lazy) => { if (t._bg) { rv.style.backgroundImage = t._bg; return; } if (t._post) media.get(t._post, lazy ? () => t._near && t.isConnected : null).then(u => { if (!u) return; t._bg = imgCss(u); if (t._near !== false) rv.style.backgroundImage = t._bg; }); };
        lz = new IntersectionObserver(es => es.forEach(x => { const rv = x.target.querySelector('.rv'); if (!rv) return; x.target._near = x.isIntersecting; if (x.isIntersecting) { if (!rv.style.backgroundImage) fill(x.target, rv, true); } else rv.style.backgroundImage = ''; }), { root, rootMargin: '100% 0px' });
        const add = (p, eager) => { const e = reel(p); if (eager) fill(e, e.querySelector('.rv'), false); root.appendChild(e); io.observe(e); lz.observe(e); };
        ps.slice(0, 3).forEach((p, i) => add(p, !i));                                            /* o primeiro ecrã entra já */
        if (ps.length > 3) setTimeout(() => { if (root.isConnected) ps.slice(3).forEach(add); }, 240);   /* o resto depois da transição */
      };
      /* UM reel por gesto: cada evento da roda somava 956 px à posição já em movimento, por isso um só gesto saltava 2-4 reels.
         As setas passam a ser ouvidas no documento (a janela da app não tem foco) e o listener morre com a camada. */
      let wl = 0; const step = d => { const n = Date.now(); if (n < wl) return; wl = n + 450; root.scrollBy({ top: d * (root.clientHeight || 956), behavior: 'smooth' }); };
      root.addEventListener('wheel', e => { e.preventDefault(); step(e.deltaY > 0 ? 1 : -1); }, { passive: false });
      const kh = e => { if (!root.isConnected || win.classList.contains('bg')) return; if (e.key === 'ArrowDown') step(1); if (e.key === 'ArrowUp') step(-1); if (e.key === 'Escape') exit(); };
      document.addEventListener('keydown', kh);
      /* sair: seta, Esc, ou a app fechar - larga observadores, teclado e devolve a barra de estado da app */
      let gone = false;
      function exit() { if (gone) return; gone = true; if (io) io.disconnect(); if (lz) lz.disconnect(); root.querySelectorAll('.reel').forEach(r => { if (r._svp) r._svp.destroy(); }); document.removeEventListener('keydown', kh); def.statusBar = sbAntes; if (System.updateSbTheme) System.updateSbTheme(); lay.classList.remove('in'); setTimeout(() => lay.remove(), 260); if (o.onExit) o.onExit(); }
      back.onclick = exit;
      const prevClose = win.onClose; win.onClose = () => { exit(); prevClose && prevClose(); };
      SV.pauseAll();   /* o vídeo do feed por baixo não continua a tocar atrás dos Reels */
      load();
      lay._api = { exit, compose };
      return lay._api;
  }

  /* ---------- MOCKS do browser (sem FiveM) para os VÍDEOS nas redes (12 nov 2026) ----------
     As MESMAS regras do server/social.lua (takeVideo): Config.Recording.social com os valores do contrato (o harness muda-os com
     localStorage 'apx:socialVideo' = JSON), cópia do vídeo da galeria para a tabela 'media' do mock (kind 'video', a mesma que o
     media.get do messages.js serve aos bocados), uma cópia por vídeo da galeria (reutilizada), ligação publicação/story → media e a
     cópia apagada com a última publicação/story que a usa. O social.post, o social.story.add/get/delete e o social.deletePost do
     localdb.js são substituídos aqui pela versão com vídeo (o resto é igual); o social.story.upload e o social.story.media não
     tinham mock (uma story com fotografia nunca chegava a ser publicada no browser). */
  if (window.LocalDB && LocalDB.register) (() => {
    const T = LocalDB.T, G = (window.Store && Store.global) || null, now = () => Date.now();
    const myName = app => { const a = T('social_accounts').all().find(x => x.app === app && x.owner === 'DEV0000'); return a ? a.username : null; };
    const META = '{"src":"social","photo":';
    const vcfg = () => { let o = {}; try { o = JSON.parse(localStorage.getItem('apx:socialVideo') || 'null') || {}; } catch (e) {}
      const c = Object.assign({ enabled: true, instashot: true, stories: true, reels: true, twix: true, recado: true, maxSeconds: 60, maxMB: 8, maxVideosPerPlayer: 30 }, o);
      c.networks = Object.assign({ instashot: true, twix: true, reels: true }, o.networks || {}); return c; };
    LocalDB.register('social.video.config', () => { const c = vcfg();
      return { enabled: c.enabled !== false, instashot: c.instashot !== false, stories: c.stories !== false, reels: c.reels !== false, twix: c.twix !== false, recado: c.recado !== false,
        maxSeconds: Math.max(0, Math.floor(+c.maxSeconds || 0)), maxMB: +c.maxMB > 0 ? +c.maxMB : 8, maxPerPlayer: Math.max(0, Math.floor(+c.maxVideosPerPlayer || 0)), networks: c.networks }; });
    const nextMediaId = () => { const id = Math.max(+(G ? G.get('mock:mediaSeq', 0) : 0) || 0, T('media').all().reduce((a, x) => Math.max(a, +x.id || 0), 0)) + 1; if (G) G.set('mock:mediaSeq', id); return id; };
    const takeVideo = (where, photoId) => {
      const c = vcfg();
      if (c.enabled === false || c[where] === false) return { error: 'videooff', where };
      if ((where === 'reels' && c.networks.reels === false) || c.networks[where === 'twix' ? 'twix' : 'instashot'] === false) return { error: 'videooff', where };
      const ph = T('photos').all().find(x => x.id === +photoId);
      if (!ph || !ph.video || typeof ph.url !== 'string' || !/^data:video\//.test(ph.url)) return { error: 'novideo' };
      const mb = +c.maxMB > 0 ? +c.maxMB : 8;
      if (ph.url.length > Math.min(12e6, Math.floor(mb * 1e6))) return { error: 'videobig', maxMB: mb };
      const secs = Math.floor(+ph.duration || 0);
      if (+c.maxSeconds > 0 && secs > +c.maxSeconds + 1) return { error: 'videolong', maxSec: +c.maxSeconds };
      const ms = Math.max(1, secs) * 1000, key = META + Math.floor(+photoId) + '}';
      const prev = T('media').all().find(m => m.kind === 'video' && m.metaKey === key && m.complete);
      if (prev) return { media: prev.id, dur: ms, size: ph.url.length, poster: ph.poster || null, photo: +photoId, fresh: false };
      const mine = T('media').all().filter(m => m.kind === 'video' && String(m.metaKey || '').indexOf(META) === 0).length;
      if (+c.maxVideosPerPlayer > 0 && mine >= +c.maxVideosPerPlayer) return { error: 'videolimit', max: +c.maxVideosPerPlayer };
      const id = nextMediaId(), rows = T('media').all();
      rows.push({ id, owner: LocalDB.cid, kind: 'video', mime: 'video/webm', data: ph.url, size: ph.url.length, duration: ms, meta: { src: 'social', photo: +photoId }, metaKey: key, complete: 1, created: now() });
      T('media').set(rows);
      return { media: id, dur: ms, size: ph.url.length, poster: ph.poster || null, photo: +photoId, fresh: true };
    };
    const link = (kind, ref, app, v) => T('social_videos').insert({ kind, ref_id: ref, media_id: v.media, app, dur: v.dur, size: v.size, created: now() });
    const vOf = v => v ? { id: v.media, dur: v.dur, size: v.size } : null;
    const dropRef = (kind, ref) => {
      const rows = T('social_videos').all(), out = rows.filter(r => r.kind === kind && r.ref_id === ref);
      if (!out.length) return;
      const left = rows.filter(r => !(r.kind === kind && r.ref_id === ref)); T('social_videos').set(left);
      out.forEach(o => { if (!left.some(r => r.media_id === o.media_id)) T('media').set(T('media').all().filter(m => !(m.id === o.media_id && m.kind === 'video'))); });
    };
    /* o media.get do messages.js pergunta aqui por um vídeo que não é de quem pede: chega uma publicação ou story que ainda exista */
    window.SocialVideoMock = { canRead: mid => T('social_videos').all().some(r => r.media_id === mid && (r.kind === 'post' ? T('posts').all().some(p => p.id === r.ref_id) : r.kind === 'story' ? T('stories').all().some(s => s.id === r.ref_id && s.expires > now()) : false)), cfg: vcfg };
    const slim = o => { if (typeof o.image === 'string' && o.image.length > 4096) { o.imageLen = o.image.length; o.chunk = 48000; o.image = null; } else if (typeof o.image === 'string' && /^\d+$/.test(o.image)) o.image = +o.image; return o; };
    LocalDB.register('social.post', d => { const my = myName(d.app); if (!my) return { error: 'noprofile' };
      let image = null, v = null;
      if (+d.videoId > 0) { v = takeVideo(d.app === 'twix' ? 'twix' : (d.where === 'reels' || d.app === 'reels') ? 'reels' : 'instashot', d.videoId); if (v.error) return v; image = v.poster; }
      else if (+d.photoId > 0) { const ph = T('photos').all().find(x => x.id === +d.photoId); if (!ph) return { error: 'photo' }; if (ph.video) return { error: 'video' }; image = ph.url || (ph.seed ? String(ph.seed) : null); }
      else if (d.image != null && d.image !== false && d.image !== '') { const s = String(d.image);
        if (/^\d{1,12}$/.test(s)) image = +s;
        else if (s.length > 48000) return { error: 'toolarge' };
        else if (/^data:image\/(jpeg|jpg|png|webp|gif);base64,/.test(s) || (s.length <= 512 && /^https?:\/\//.test(s) && !/[\s"'<>\\]/.test(s))) image = s;
        else return { error: 'badimage' }; }
      if (d.repostOf && !(d.content || '') && image == null && !v) { const dup = T('posts').all().find(x => x.app === d.app && x.author === my && x.repost_of === d.repostOf && !(x.content || '')); if (dup) return { error: 'reposted', id: dup.id }; }
      const row = T('posts').insert({ app: d.app, author: my, content: d.content || '', image, reply_to: d.replyTo || null, repost_of: d.repostOf || null, created: now(), video: vOf(v) });
      if (v) link('post', row.id, d.app, v);
      return slim(Object.assign({}, row)); });
    LocalDB.register('social.deletePost', d => { const my = myName(d.app); const p = T('posts').all().find(x => x.id === d.postId); if (!p || p.author !== my) return { error: 'forbidden' }; T('posts').remove(d.postId); dropRef('post', d.postId); return { ok: true }; });
    LocalDB.register('social.story.add', d => { const my = myName(d.app); if (!my) return { error: 'noprofile' };
      let v = null; if (+d.videoId > 0) { v = takeVideo('stories', d.videoId); if (v.error) return v; }
      if (!d.image && !d.bg && !(d.layers || []).length && !d.hasMedia && !v) return { error: 'empty' };
      const c = vcfg(), cap = +c.maxSeconds > 0 ? Math.max(3, Math.min(60, +c.maxSeconds)) : 60, t = now();
      const row = T('stories').insert({ app: d.app, author: my, image: v ? v.poster : (typeof d.image === 'number' ? String(d.image) : null), bg: d.bg, draw: null, layers: d.layers || [], duration: v ? Math.max(3, Math.min(cap, Math.ceil(v.dur / 1000))) : Math.max(3, Math.min(15, d.duration || 5)), close_friends: d.closeFriends ? 1 : 0, text: d.text, tx: d.tx, ty: d.ty, tsize: d.tsize, tcolor: d.tcolor, loc: d.loc, created: t, expires: t + 864e5, video: vOf(v) });
      if (v) link('story', row.id, d.app, v);
      return { ok: true, id: row.id }; });
    /* a media de uma story aos bocados (como o server/social.lua): o add cria a linha e a fotografia/desenho sobem a seguir */
    LocalDB.register('social.story.upload', d => { const my = myName(d.app); const s = T('stories').all().find(x => x.id === +d.id); if (!s || s.author !== my) return { error: 'forbidden' };
      const col = d.which === 'draw' ? 'draw' : 'image', part = String(d.data || ''); if (part.length > 48064) return { error: 'badchunk' };
      const val = +d.i === 1 ? part : String(s[col] || '') + part; if (val.length > 300000) { T('stories').update(s.id, { [col]: null }); return { error: 'toolarge' }; }
      T('stories').update(s.id, { [col]: val }); return { ok: true, len: val.length }; });
    LocalDB.register('social.story.media', d => { const s = T('stories').all().find(x => x.id === +d.id && x.expires > now()); if (!s) return { error: 'notfound' };
      const v = String((d.which === 'draw' ? s.draw : s.image) || ''), C = 48000, i = Math.max(1, +d.i || 1); if (!v.length) return { i, total: 0, len: 0, data: '' };
      return { i, total: Math.ceil(v.length / C), len: v.length, data: v.slice((i - 1) * C, i * C) }; });
    LocalDB.register('social.story.get', d => {
      const s = T('stories').all().find(x => x.id === d.id && x.expires > now()); if (!s) return null;
      const me = myName(d.app), polls = {}, myAnswers = {};
      T('story_answers').all().filter(x => x.story_id === s.id).forEach(r => { const p = polls[r.layer] || (polls[r.layer] = { a: 0, b: 0, n: 0 }); p.n++; if (r.choice === 0) p.a++; else if (r.choice === 1) p.b++; if (r.username === me) myAnswers[r.layer] = { choice: r.choice, answer: r.answer }; });
      const im = s.image == null ? '' : String(s.image), dr = s.draw == null ? '' : String(s.draw);
      return { id: s.id, author: s.author, layers: s.layers, bg: s.bg, duration: s.duration || 5, text: s.text, tx: s.tx, ty: s.ty, tsize: s.tsize, tcolor: s.tcolor, loc: s.loc, created: s.created, polls, myAnswers,
        imageLen: im.length, drawLen: dr.length, chunk: 48000, video: s.video || null }; });
    LocalDB.register('social.story.delete', d => { T('story_views').all().filter(v => v.story_id === d.id).forEach(v => T('story_views').remove(v.id)); T('stories').remove(d.id); dropRef('story', d.id); return { ok: true }; });
  })();
})();
