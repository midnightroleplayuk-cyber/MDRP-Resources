/* ============================================================
   INSTASHOT · DIRECT (mensagens privadas) - 2026-09-17
   Antes era um esboço: bolhas de texto, sem avatar, sem nome, sem fotos nem voz, e "Nova mensagem" pedia
   para ESCREVER o nome de utilizador. Agora é um chat a sério, no molde do Zapp mas com a cara do Instagram:
   · lista com avatar, nome real, última mensagem e hora; pesquisa; "Nova mensagem" mostra QUEM EU SIGO;
   · conversa com cabeçalho (avatar + nome + @user), fotos (câmara ou galeria), mensagens de voz e texto;
   · corre sobre o motor de mensagens que já existia (messages.* com app='instashot'): as fotos sobem pelo
     media.* aos bocados (Msgs.sendPhoto) e a voz pelo VoiceMsg - nada de base64 dentro de messages.send.
   window.SocialDM = { list(ctx), thread(ctx, username[, opts]), label(m), picker(ctx), camera(win, title) }
   ctx = { app, me, win, rpc, onUser, resetProfile } - vem do social.js (é ele que tem a sessão da rede).

   (4 nov 2026) "Não deixa carregar na caixa de texto" + "tem de parecer o Instagram":
   · A CAIXA ESTAVA DEBAIXO DA BARRA DE SEPARADORES. A conversa era uma vista SEM `full`, por isso o ui.js
     (updateTabbar) deixava à vista a barra do Instashot (.tabbar.plain: absoluta, bottom 0, 58 px + margem de
     baixo, z-index 20, opaca e com pointer-events). O compositor tem 54 px + a mesma margem: ficava TODO por
     baixo dela e cada toque no campo caía num separador (Início, Reels, outra lista de mensagens...) e atirava
     o jogador para fora da conversa. Em todos os telemóveis e no NOVA Fold8 fechado; só o PearPhone Fold e o
     NOVA Fold8 aberto escapavam (lá a barra é uma coluna). As duas vistas (lista e conversa) levam agora
     `full: true`, como as conversas das Mensagens, do Match e do Zapp: a barra esconde-se e volta ao sair.
   · O cabeçalho (avatar + nome) vivia dentro do .nb-title, que tem pointer-events:none (ui.css): o toque
     para abrir o perfil nunca chegava. O CSS da conversa devolve-lhe os toques.
   · Desenho do Instagram, nos dois temas e nos dois sistemas (é uma app de terceiros: igual no PearOS e no
     Android): fundo branco/preto, bolhas #EFEFEF/#262626 e azuis do Instagram, bolhas seguidas agrupadas com
     os cantos de dentro apertados, o avatar só na última de cada grupo, a hora entre blocos afastados, cartão
     do perfil no início da conversa, "Visto"/"Enviado" debaixo da última mensagem minha (lido do status das
     mensagens e do push messageStatus, que o messages.js deixa passar sem tratar nas DMs sociais), pílula de
     escrever com a câmara num círculo azul, microfone/galeria/emojis e "Enviar" azul quando há texto.
     Na lista: o @ do jogador como título, pesquisa, "Mensagens", linhas com "Tu:", hora, ponto azul de por
     ler, ponto verde de ativo e a câmara à direita (envia uma fotografia sem abrir a conversa).
   · Textos: os nomes e as mensagens vão em data-noi18n; "Tu:", as legendas das fotos/voz e as horas ficam em
     nós próprios para o i18n.js as traduzir (nunca colados a um nome).
   · (4 nov 2026, revisão) "Visto" FALSO: a conversa marcava lida cada DM que chegasse enquanto a vista existisse (Instashot em
     segundo plano, telemóvel guardado/bloqueado, um perfil por cima) e o "Visto" novo mostrava isso a quem a enviou. Agora só lê
     com a conversa mesmo à frente (a regra das Mensagens) e o resto lê-se ao voltar. A foto em ecrã inteiro e a câmara fecham com o
     Voltar do Android (UI.track) e a foto também quando a conversa sai; a lista volta a pintar depois de uma "Nova mensagem"; o
     onPop da lista já não apaga o dos Instants; a pesquisa aceita o @; Enter = "Enviar" no teclado do telemóvel.
   ============================================================ */
window.SocialDM = (() => {
  const g = UI.g, esc = UI.esc;
  const int = v => Math.floor(+v) || 0;
  const payloadOf = m => { const p = m && m.payload; if (!p) return {}; if (typeof p === 'string') { try { return JSON.parse(p) || {}; } catch (e) { return {}; } } return typeof p === 'object' ? p : {}; };
  const midOf = m => int(payloadOf(m).mediaId);
  /* resumo de uma conversa na lista (o Msgs.label é das SMS e não conhece as fotos das DMs) */
  const label = m => { if (!m) return ''; const t = m.type;
    if (t === 'image') return '📷 Fotografia'; if (t === 'audio') return '🎤 Mensagem de voz';
    return String(m.content || '').replace(/\s+/g, ' ').slice(0, 60); };
  /* razão do servidor (server/messages.lua RPC['messages.send'] + dispatcher do server/main.lua) em texto:
     antes o envio ia pelo rpc() normal, que transforma { error } em null, e tudo dava o mesmo
     «Não foi possível enviar» sem dizer porquê (as mesmas frases do ERR do messages.js) */
  const ERR = { ratelimit: 'Demasiados pedidos, espera um instante', toolarge: 'O anexo é demasiado grande', badmedia: 'O anexo já não está disponível',
    media: 'O anexo já não está disponível', badwave: 'A mensagem de voz chegou estragada', target: 'Destinatário inválido', badtype: 'Tipo de mensagem inválido',
    badreply: 'A mensagem a que respondes já não existe', internal: 'Erro no servidor', rpc: 'Sem resposta do servidor', db: 'Sem resposta do servidor',
    off: 'Esta rede está desligada neste servidor.', noidentity: 'Não tens conta nesta rede. Fecha e volta a abrir a app.' };
  const errOf = (r, fb) => { const e = r && typeof r === 'object' ? r.error : (r === false || r == null ? 'rpc' : null); return (e && ERR[e]) || fb; };
  /* um envio recusado com 'noidentity' quer dizer que a conta desta rede já não é desta personagem (troca de
     personagem, conta reposta): esquece o perfil guardado para a app voltar a pedir/criar a conta ao reabrir */
  const failed = (ctx, r, fb) => { if (r && r.error === 'noidentity' && ctx.resetProfile) ctx.resetProfile(); Sound.play('error'); UI.toast(errOf(r, fb), 2600); };
  const arr = v => Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []);   /* o Lua devolve {} para listas vazias */
  /* nó de texto do JOGADOR (nome, mensagem, @): o i18n.js nunca lhe mexe */
  const noI = (tag, txt, cls) => { const e = document.createElement(tag || 'span'); e.setAttribute('data-noi18n', ''); if (cls) e.className = cls; e.textContent = txt == null ? '' : String(txt); return e; };
  /* nó de texto da INTERFACE (português de origem, traduzido pelo i18n.js pela chave exata) */
  const uiT = (tag, txt, cls) => { const e = document.createElement(tag || 'span'); if (cls) e.className = cls; e.textContent = txt; return e; };
  const GROUP_MS = 5 * 60000;    /* bolhas do mesmo autor a menos de 5 min juntam-se num grupo (como nas Mensagens) */
  const SEP_MS = 60 * 60000;     /* mais de uma hora de intervalo: a hora volta a aparecer ao centro, como no Instagram */
  const EMOJIS = ['❤️', '😂', '🔥', '👍', '😍', '😮', '😢', '👏'];   /* o teclado do jogo não escreve emojis */
  /* só emojis (1 a 3, sem letras nem números): o Instagram mostra-os grandes e sem bolha */
  const PICT = /\p{Extended_Pictographic}/gu;
  const bigEmoji = t => { if (!t || t.length > 24 || /[\p{L}\p{N}]/u.test(t)) return false; const n = (t.match(PICT) || []).length;
    return n > 0 && n <= 3 && /^[\p{Extended_Pictographic}\p{Emoji_Modifier}‍️\s]+$/u.test(t); };
  const appName = app => { try { return (window.App && App.name && App.name(app)) || 'Instashot'; } catch (e) { return 'Instashot'; } };

  /* perfis (nome + avatar) com cache curta: a lista e o cabeçalho pedem os mesmos utilizadores */
  const uCache = new Map();
  function user(ctx, username) {
    const k = ctx.app + '|' + username;
    if (uCache.has(k)) return uCache.get(k);
    const p = ctx.rpc('social.user', { app: ctx.app, username }).then(r => r || { username }).catch(() => ({ username }));
    uCache.set(k, p); return p;
  }
  /* avatar de um utilizador da rede: gradiente + iniciais e, se tiver foto, a foto por CSSOM */
  function avatarEl(ctx, username, cls) {
    const el = UI.el(UI.avatar({ name: username, avatar: (username || '').length }, cls || ''));
    user(ctx, username).then(u => {
      if (!u || !el.isConnected) return;
      if (u.name) el.title = u.name;
      const url = u.avatarUrl || u.avatar_url;
      if (typeof u.avatar === 'number') el.setAttribute('style', UI.avatarStyle(u.avatar));
      if (url) { el.style.backgroundImage = UI.img(url); el.style.backgroundSize = 'cover'; el.style.backgroundPosition = 'center'; el.textContent = ''; }
    });
    return el;
  }

  /* ---------- CÂMARA (o mesmo visor da app Câmara, como no Zapp e nas Mensagens) ---------- */
  function camera(win, title) {
    return new Promise(async res => {
      if (!window.CamView || typeof CamView.mount !== 'function') { UI.toast('Câmara indisponível'); res(null); return; }
      /* as mensagens do Tweeter usam este mesmo ecrã: o pedido de permissão e o fecho seguem a app da janela, não 'instashot' fixo */
      const owner = win.appId || 'instashot';
      if (window.Perm && !(await Perm.request(owner, 'camera'))) { res(null); return; }
      if (!win.isConnected) { res(null); return; }
      /* ⚠️ a camada leva `igdm-cam` e NÃO a classe do botão da barra: uma classe de botão (40×40) encolhia
         o visor de ecrã inteiro para um círculo no canto (foi o que aconteceu no Zapp). */
      const lay = UI.el(`<div class="msg-cam igdm-cam"><div class="mc-view"></div><div class="mc-still"></div><div class="mc-top"><div class="b x">${g('x', 22)}</div><div class="mc-ttl"></div><div class="b fl off">${g('bolt', 22)}</div></div><div class="mc-bot"><div class="mc-retake">Repetir</div><div class="mc-shut"><div></div></div><div class="mc-send">${g('check')}</div><div class="mc-flip">${g('repeat', 22)}</div></div></div>`);
      lay.querySelector('.mc-ttl').textContent = title || '';
      const view = lay.querySelector('.mc-view'), still = lay.querySelector('.mc-still');
      let cam = null, dead = false, raw = null, busy = false, untrack = null;
      const onKey = e => { if (dead || e.key !== 'Escape') return; e.preventDefault(); e.stopPropagation(); close(null); };
      const offApp = Bridge.on('app:close', id => { if (id === owner) close(null); });
      const offKill = Bridge.on('app:kill', id => { if (id === owner) close(null); });
      function close(v) { if (dead) return; dead = true; document.removeEventListener('keydown', onKey, true); offApp(); offKill(); if (untrack) untrack(); try { if (cam) cam.destroy(); } catch (e) {} lay.remove(); res(v); }
      document.addEventListener('keydown', onKey, true);
      win.appendChild(lay);
      /* (4 nov 2026) o Voltar do Android (UI.dismissTop, antes de tirar uma vista) fecha a câmara: antes tirava a conversa de baixo e
         o visor ficava por cima da lista. Guardar o telemóvel (UI.dismissAll) também a fecha, como às folhas */
      untrack = UI.track ? UI.track(() => close(null)) : null;
      try { cam = CamView.mount(view, { chrome: 'bare', aspect: (view.clientWidth || 440) / (view.clientHeight || 956), autoActivate: false, aimInside: true }); cam.setActive(true); }
      catch (e) { console.error('[apex_phone] CamView', e); close(null); UI.toast('Não foi possível abrir a câmara'); return; }
      requestAnimationFrame(() => { if (!dead) lay.classList.add('in'); });
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

  /* fotografia para alguém (câmara/galeria da conversa e a câmara de cada linha da lista): sobe aos bocados pelo
     Msgs.sendPhoto (media.* + mediaId). → a mensagem enviada, ou null (o porquê já foi dito num aviso) */
  async function sendPhotoTo(ctx, username, src) {
    if (!src) return null;
    if (!window.Msgs || !Msgs.sendPhoto) { UI.toast('Não foi possível enviar a foto'); return null; }
    UI.toast('A enviar a foto…');
    let r = null; try { r = await Msgs.sendPhoto(username, src, { app: ctx.app }); } catch (e) { r = null; }
    if (r && !r.error) { Sound.play('send'); return r; }
    failed(ctx, r, 'A foto não foi enviada'); return null;
  }
  /* fotografia em ecrã inteiro (antes um toque abria um alerta vazio "Fotografia": UI.viewer não existe). O mesmo
     visualizador das Mensagens (.viewer, apps.css): fechar e guardar na Galeria.
     (4 nov 2026) Devolve a função que o fecha (a conversa chama-a ao sair) e regista-se no UI.track: o Voltar do Android fecha a foto
     primeiro. Antes o Voltar tirava a conversa e o visor ficava por cima da lista, com o ouvinte de teclas preso. */
  function viewer(win, url) {
    if (!url || !win || !win.isConnected) return null;
    const vw = UI.el(`<div class="viewer igdm-viewer"><div class="vimg"><div></div></div><div class="vbar"><div class="cl">${g('x')}</div><div class="sv">${g('download')}</div></div></div>`);
    vw.querySelector('.vimg > div').style.backgroundImage = UI.img(url);
    let dead = false, untrack = null;
    const onKey = e => { if (dead || e.key !== 'Escape') return; e.preventDefault(); e.stopPropagation(); close(); };
    const offKill = Bridge.on('app:kill', id => { if (id === (win.appId || 'instashot')) close(); });
    function close() { if (dead) return; dead = true; document.removeEventListener('keydown', onKey, true); offKill(); if (untrack) untrack(); vw.remove(); }
    document.addEventListener('keydown', onKey, true);
    vw.querySelector('.cl').onclick = close;
    vw.querySelector('.sv').onclick = async () => {
      if (!window.Photos || typeof Photos.save !== 'function') { UI.toast('Não foi possível guardar a foto'); return; }
      let r = null; try { r = await Photos.save(url); } catch (e) { r = null; }
      if (r && !r.error) { try { await Photos.load(); Bridge.emit('photos'); } catch (e) {} UI.toast(window.System && System.os === 'android' ? 'Foto guardada na Galeria' : 'Fotografia guardada nas Fotos'); close(); }   /* frases inteiras que já estão nos dicionários: 'Guardada na ' + nome não se traduzia */
      else UI.toast('Não foi possível guardar a foto');
    };
    win.appendChild(vw);
    untrack = UI.track ? UI.track(close) : null;
    return close;
  }
  /* separador de hora entre blocos: hoje = só a hora; ontem = "Ontem" (nó traduzível) + hora; esta semana = dia curto + hora;
     antes = data curta (+ ano, se for outro) + hora. O dia e a data já vêm no idioma do telemóvel (UI.wdShort / UI.fmtDate) */
  function sepEl(ts) {
    const d = new Date(+ts), n = new Date(), y = new Date(n); y.setDate(n.getDate() - 1);
    const el = UI.el('<div class="igdm-sep"></div>'), t = UI.fmtTime(d);
    if (d.toDateString() === n.toDateString()) el.appendChild(noI('span', t));
    else if (d.toDateString() === y.toDateString()) el.append(uiT('span', 'Ontem'), noI('span', t));
    else if (n - d < 6 * 864e5 && n - d > 0) el.appendChild(noI('span', UI.wdShort(d) + ' ' + t));
    else el.appendChild(noI('span', UI.fmtDate(d, true) + (d.getFullYear() !== n.getFullYear() ? ' ' + d.getFullYear() : '') + ', ' + t));
    return el;
  }

  /* ---------- Nova mensagem: QUEM EU SIGO (e pesquisa em toda a rede) ---------- */
  async function picker(ctx) {
    return new Promise(async res => {
      let done = false; const pick = v => { if (done) return; done = true; res(v); };
      const body = UI.el(`<div class="igdm-pick">${UI.search ? '' : ''}<div class="igdm-pick-list"></div></div>`);
      const holder = body.querySelector('.igdm-pick-list');
      const search = UI.search('Pesquisar', q => paint(q));
      body.insertBefore(search, holder);
      let following = [];
      holder.appendChild(UI.skeleton ? UI.skeleton('list', 5) : UI.el('<div></div>'));
      const rows = list => UI.list([{ header: list.header, items: list.items }]);
      const paint = async q => {
        q = String(q || '').trim().toLowerCase();
        let people = following;
        if (q) {
          const found = (await ctx.rpc('social.search', { app: ctx.app, q })) || [];
          people = (Array.isArray(found) ? found : Object.values(found)).filter(u => u && u.username && u.username !== ctx.me.username);
        }
        holder.innerHTML = '';
        if (!people.length) { holder.appendChild(UI.empty('personCircle', q ? 'Ninguém encontrado' : 'Ainda não segues ninguém', q ? 'Tenta outro nome.' : 'Segue pessoas para lhes enviares mensagens.')); return; }
        holder.appendChild(rows({ header: q ? 'Resultados' : 'A seguir', items: people.map(u => ({
          avatar: { name: u.username, avatar: (u.username || '').length, url: u.avatarUrl || u.avatar_url || null },
          /* pick() ANTES do close(): o close() chama o onClose de forma sincrona (ui.js), que fazia pick(null) primeiro
             e a escolha era ignorada - tocar numa pessoa fechava a folha e nao abria conversa nenhuma */
          label: '@' + u.username, sub: u.name || '', chevron: false, onTap: () => { pick(u.username); sh.close(); },
        })) }));
      };
      const sh = UI.sheet({ title: 'Nova mensagem', right: 'Cancelar', body, cls: 'igdm-pick-sheet', onClose: () => pick(null) });
      const fl = (await ctx.rpc('social.followers', { app: ctx.app, username: ctx.me.username, mode: 'following' })) || [];
      following = (Array.isArray(fl) ? fl : Object.values(fl)).filter(u => u && u.username && u.username !== ctx.me.username);
      paint('');
    });
  }

  /* ---------- LISTA DE CONVERSAS ----------
     (4 nov 2026) `full: true`: a barra de separadores esconde-se (o ui.js volta a mostrá-la ao sair) e a pilha dos Instants
     desce para o canto (app-social-dm.css). A vista entra logo, com o esqueleto, e a lista pinta quando o servidor responder:
     antes esperava pelo messages.threads e um segundo toque no avião, entretanto, empilhava outra lista. */
  async function list(ctx) {
    const meName = String((ctx.me && ctx.me.username) || '');
    /* onClose também aqui (lápis e "Enviar mensagem" do vazio): o servidor não devolve a quem envia a própria mensagem, por isso
       sem repintar a primeira conversa de sempre só aparecia na lista ao reabrir a app */
    const compose = async () => { const u = await picker(ctx); if (u) thread(ctx, u, { onClose: () => paint() }); };
    const v = UI.view({ title: meName || 'Mensagens', back: 'Instashot', cls: 'igdm', full: true, solid: true, right: [{ icon: 'compose', label: 'Nova mensagem', onTap: compose }] });
    if (meName) v.navbar.querySelector('.nb-title').setAttribute('data-noi18n', '');
    let curQ = '';
    const search = UI.search('Pesquisar', q => filter(q));
    const sec = UI.el('<div class="igdm-sec"><b>Mensagens</b></div>');
    const holder = UI.el('<div class="igdm-list"></div>');
    const none = UI.empty('search', 'Ninguém encontrado', 'Tenta outro nome.'); none.classList.add('compact', 'igdm-none'); none.style.display = 'none';
    v.content.append(search, sec, holder);
    holder.appendChild(UI.skeleton ? UI.skeleton('list', 6) : UI.spinner());
    /* pesquisa local: nome e @ de quem já tem conversa (a pesquisa na rede inteira é a do "Nova mensagem"). O @ à frente sai: é
       assim que o Instashot mostra os utilizadores em todo o lado e "@vinewood" não dava ninguém */
    const filter = q => { curQ = String(q || '').trim().toLowerCase().replace(/^@+/, ''); let n = 0, all = 0;
      holder.querySelectorAll('.igdm-row').forEach(r => { all++; const on = !curQ || (r.dataset.q || '').indexOf(curQ) > -1; r.style.display = on ? '' : 'none'; if (on) n++; });
      none.style.display = all && !n ? '' : 'none'; };
    const rowOf = t => {
      const last = t.last || null, mine = !!(last && last.sender === meName);
      /* `.igdm-new` e não `.unread`: o apps.css tem um `.unread` global (o ponto de 10 px das listas) que encolhia a linha inteira */
      const row = UI.el(`<div class="igdm-row${t.unread ? ' igdm-new' : ''}"><div class="igdm-av${t.online ? ' on' : ''}"></div><div class="igdm-rb"><b class="igdm-nm" data-noi18n></b><div class="igdm-sub"></div></div><div class="igdm-r"><u></u><div class="igdm-camic">${g('camera', 24)}</div></div></div>`);
      row.querySelector('.igdm-av').appendChild(avatarEl(ctx, t.number, 'md'));
      const nm = row.querySelector('.igdm-nm'); nm.textContent = t.number; row.dataset.q = String(t.number).toLowerCase();
      user(ctx, t.number).then(u => { if (u && u.name) { nm.textContent = u.name; row.dataset.q = (t.number + ' ' + u.name).toLowerCase(); if (curQ) filter(curQ); } });
      const sub = row.querySelector('.igdm-sub');
      if (!last) sub.appendChild(uiT('span', 'Sem mensagens', 'igdm-prev'));
      else {
        if (mine) sub.appendChild(uiT('span', 'Tu:', 'igdm-you'));
        if (last.deleted) sub.appendChild(uiT('span', 'Mensagem apagada', 'igdm-prev'));
        else if (last.type === 'image' || last.type === 'audio') sub.appendChild(uiT('span', label(last), 'igdm-prev'));
        else sub.appendChild(noI('span', label(last), 'igdm-prev'));
        if (last.created) sub.appendChild(uiT('span', UI.timeAgo(new Date(+last.created)), 'igdm-when'));
      }
      row.onclick = () => thread(ctx, t.number, { online: !!t.online, onClose: () => paint() });
      /* a câmara da linha: tira e envia sem abrir a conversa (como no Instagram) */
      row.querySelector('.igdm-camic').onclick = async e => { e.stopPropagation(); const raw = await camera(ctx.win, '@' + t.number); if (!raw) return; const r = await sendPhotoTo(ctx, t.number, raw); if (r) { UI.toast('Enviado'); paint(); } };
      return row;
    };
    /* pedidos sobrepostos (vários pushes social:dm seguidos) juntam-se num só repintar no fim */
    let busy = null, again = false;
    const paint = async () => {
      if (busy) { again = true; return busy; }
      busy = (async () => {
        let ts = null; try { ts = await ctx.rpc('messages.threads', { app: ctx.app }); } catch (e) { ts = null; }
        const rows = arr(ts).filter(t => t && t.number && !t.group && !t.conversation);
        const frag = document.createDocumentFragment();
        if (!rows.length) {
          const em = UI.el('<div class="ig-dm-empty"><b>As tuas mensagens</b><span>Envia fotografias e mensagens privadas a quem segues.</span><div class="go">Enviar mensagem</div></div>');
          em.querySelector('.go').onclick = compose;
          frag.appendChild(em);
        } else rows.forEach(t => frag.appendChild(rowOf(t)));
        frag.appendChild(none);
        holder.innerHTML = ''; holder.appendChild(frag);
        sec.style.display = rows.length ? '' : 'none';
        filter(curQ);
      })();
      try { await busy; } finally { busy = null; }
      if (again) { again = false; return paint(); }
    };
    v.dataset.dm = '1'; v.paint = paint;
    /* o ouvinte larga-se sozinho se a vista morrer sem onPop (setRoot, app morta), como o dos Instants */
    const off = Bridge.on('social:dm', () => { if (!v.isConnected) { off(); return; } paint(); });
    /* (4 nov 2026) o onPop ANTES do Instants.attach: ele embrulha o que encontrar (instants.js, prevPop). Pela ordem antiga o `= off`
       apagava o dele e sair da lista nunca parava a pilha dos Instants nem largava o ouvinte 'notification' */
    v.opts.onPop = off;
    if (window.Instants && ctx.app === 'instashot') { Instants.attach(ctx.app, ctx.me, ctx.win, v); v.classList.add('has-pile'); }
    UI.push(ctx.win, v);
    await paint();
    return v;
  }

  /* ---------- CONVERSA ----------
     opts (opcional): { online: bool - "Ativo agora" que a linha da lista já sabe; onClose() - ao sair (a lista repinta: o
     ponto de por ler some) }. Sem opts (Reels, perfil, Nova mensagem) a presença vem do messages.threads. */
  async function thread(ctx, username, opts) {
    opts = opts || {};
    const app = ctx.app, me = ctx.me.username;
    username = String(username == null ? '' : username);
    /* as DMs do Instashot não têm chamadas (o servidor liga por número de telefone, a rede só conhece o @) */
    const noCall = () => UI.toast('As chamadas do Instashot não estão disponíveis');
    /* full: a barra de separadores do Instashot esconde-se (era ela que tapava o compositor, ver o topo) */
    const v = UI.view({ title: '', back: 'Mensagens', cls: 'igdm-th', full: true, solid: true, right: [{ icon: 'phone', label: 'Ligar', onTap: noCall }, { icon: 'video', label: 'Videochamada', onTap: noCall }] });

    /* cabeçalho: avatar (ponto verde se ativo) + nome + "Ativo agora" ou o @ (toque abre o perfil) */
    const head = UI.el('<div class="igdm-head"><div class="igdm-head-av"></div><div class="igdm-head-t"><b></b><span class="igdm-head-s"></span></div></div>');
    const hav = head.querySelector('.igdm-head-av'), hName = head.querySelector('.igdm-head-t b'), hSub = head.querySelector('.igdm-head-s');
    hav.appendChild(avatarEl(ctx, username, 'sm'));
    hName.textContent = username;
    let fullName = '', online = false;
    const paintSub = () => { hSub.textContent = ''; hav.classList.toggle('on', online);
      if (online) hSub.appendChild(uiT('span', 'Ativo agora')); else if (fullName) hSub.appendChild(noI('span', username));
      hSub.style.display = hSub.firstChild ? '' : 'none'; };
    paintSub();
    const openProfile = () => { if (ctx.onUser) ctx.onUser(username); };
    head.onclick = openProfile;
    const nbt = v.navbar.querySelector('.nb-title'); nbt.textContent = ''; nbt.appendChild(head);

    /* cartão do perfil no início da conversa (sobe com o histórico, como no Instagram) */
    const th = UI.el('<div class="igdm-thread"></div>');
    const pc = UI.el('<div class="igdm-pc"><div class="igdm-pc-av"></div><b data-noi18n></b><div class="igdm-pc-sub" data-noi18n></div><div class="igdm-pc-btn">Ver perfil</div></div>');
    pc.querySelector('.igdm-pc-av').appendChild(avatarEl(ctx, username, 'lg'));
    const pcName = pc.querySelector('b'); pcName.textContent = username;
    pc.querySelector('.igdm-pc-sub').textContent = username + ' · ' + appName(app);
    pc.querySelector('.igdm-pc-btn').onclick = openProfile;
    pc.querySelector('.igdm-pc-av').onclick = openProfile;
    th.appendChild(pc);
    user(ctx, username).then(u => { if (u && u.name) { fullName = String(u.name); hName.textContent = fullName; pcName.textContent = fullName; paintSub(); } });

    /* compositor: pílula com a câmara num círculo azul, o campo, microfone/galeria/emojis; "Enviar" no lugar deles quando
       há texto. A RAIZ (.igdm-comp) continua a ser o anfitrião do gravador (VoiceMsg.recorder): o .vmsg-rec ocupa a linha
       inteira e o .vmsg-host esconde o resto (app-groups.css) */
    const bar = UI.el(`<div class="igdm-comp"><div class="igdm-emo"></div><div class="igdm-pill"><div class="igdm-cam-btn">${g('camera', 20)}</div><input type="text" maxlength="900" enterkeyhint="send" placeholder="Mensagem…"><div class="igdm-tools"><div class="igdm-mic">${g('mic', 24)}</div><div class="igdm-ph">${g('photo', 24)}</div><div class="igdm-stk">${g('smile', 24)}</div></div><div class="igdm-send">Enviar</div></div></div>`);
    v.content.appendChild(th); v.content.style.paddingBottom = '0'; v.appendChild(bar);
    const inp = bar.querySelector('input'), emo = bar.querySelector('.igdm-emo'), stk = bar.querySelector('.igdm-stk');
    const syncText = () => bar.classList.toggle('has-text', !!inp.value.trim());
    /* premir Enviar / um emoji NÃO tira o foco ao campo (preventDefault no pointerdown, como o Enviar dos comentários): sem
       isto o teclado virtual descia a meio do clique, a janela descia com ele e o clique caía noutro sítio */
    const keep = el => el.addEventListener('pointerdown', e => e.preventDefault());
    EMOJIS.forEach(e => { const b = noI('div', e, 'igdm-emo-b'); keep(b); b.onclick = () => { inp.value = (inp.value + e).slice(0, 900); syncText(); inp.focus(); }; emo.appendChild(b); });
    keep(stk); keep(bar.querySelector('.igdm-send'));
    /* a fila de emojis cresce a caixa para cima: quem estava no fim da conversa continua a ver a última bolha */
    stk.onclick = () => { const c = v.content, atEnd = c.scrollHeight - c.scrollTop - c.clientHeight < 80; const on = bar.classList.toggle('emo'); stk.classList.toggle('on', on); if (atEnd) c.scrollTop = 1e6; };

    /* ---- mensagens: modelo (rows) + desenho ---- */
    const seen = new Set(), rows = [];
    let lastTs = 0, stEl = null, closeViewer = null;   /* closeViewer: a foto aberta em ecrã inteiro (fecha quando a conversa sai) */
    const same = (a, b) => !!a && !!b && !b.sep && a.m.sender === b.m.sender && Math.abs((+b.m.created || 0) - (+a.m.created || 0)) <= GROUP_MS;
    /* grupo de bolhas seguidas: first / mid / last / single (o CSS aperta os cantos de dentro e mostra o avatar só na última) */
    const groupAt = i => { const r = rows[i]; if (!r) return; const p = same(rows[i - 1], r), n = same(r, rows[i + 1]);
      const k = p && n ? 'grp-mid' : p ? 'grp-last' : n ? 'grp-first' : 'grp-single';
      if (r.k !== k) { if (r.k) r.el.classList.remove(r.k); r.el.classList.add(k); r.k = k; } };
    /* "Visto" / "Enviado" debaixo da ÚLTIMA mensagem, só se for minha (com uma resposta dele por baixo não se mostra nada, como no
       Instagram). O status vem do messages.get / messages.send e o "lida" ao vivo do push messageStatus (mais abaixo). Só aparece
       "Visto" quando os dois lados têm os recibos de leitura ligados (o servidor rebaixa para 'delivered' quando não) */
    const refreshStatus = () => {
      if (stEl) { stEl.remove(); stEl = null; }
      const last = rows[rows.length - 1];
      if (!last || last.m.sender !== me || last.m.deleted) return;
      stEl = uiT('div', last.m.status === 'read' ? 'Visto' : 'Enviado', 'igdm-status');
      th.appendChild(stEl);
    };
    const bodyOf = m => {
      if (m.deleted) return uiT('div', 'Mensagem apagada', 'igdm-bub igdm-del');   /* apagada para todos: chega com o texto vazio */
      if (m.type === 'image') {
        const box = UI.el('<div class="igdm-bub igdm-img"></div>');
        const mid = midOf(m), p = payloadOf(m);
        if (mid && window.Msgs && Msgs.media) Msgs.media(mid).then(r => { if (r && r.url && box.isConnected) { box.style.backgroundImage = UI.img(r.url); box._url = r.url; } });
        else if (p.url) { box.style.backgroundImage = UI.img(p.url); box._url = p.url; }
        else if (p.seed != null && window.photoBg) box.style.background = photoBg(+p.seed || 1);
        box.onclick = () => { if (!box._url) return; if (closeViewer) closeViewer(); closeViewer = viewer(ctx.win, box._url); };
        return box;
      }
      if (m.type === 'audio') {
        const p = payloadOf(m), wrap = UI.el('<div class="igdm-bub igdm-voice"></div>');
        let pl = null; try { pl = window.VoiceMsg && VoiceMsg.player({ mediaId: midOf(m), duration: p.duration, waveform: Array.isArray(p.waveform) ? p.waveform : [] }); } catch (e) { pl = null; }
        if (pl && pl.nodeType === 1) wrap.appendChild(pl); else wrap.appendChild(uiT('span', '🎤 Mensagem de voz'));
        return wrap;
      }
      const t = String(m.content || ''), b = UI.el('<div class="igdm-bub igdm-b-txt"></div>');
      b.textContent = t; if (bigEmoji(t.trim())) b.classList.add('igdm-big');
      return b;
    };
    /* quiet = carga inicial (o agrupamento, o estado e o scroll fazem-se uma vez no fim) */
    const add = (m, quiet) => {
      if (!m || m.id == null || seen.has(m.id)) return false; seen.add(m.id);
      const mine = m.sender === me, ts = +m.created || Date.now();
      let sep = false;
      if (!rows.length || ts - lastTs > SEP_MS) { th.appendChild(sepEl(ts)); sep = true; }
      lastTs = Math.max(lastTs, ts);
      const el = UI.el(`<div class="igdm-msg ${mine ? 'me' : 'them'}"></div>`);
      if (!mine) { const a = UI.el('<div class="igdm-msg-av"></div>'); a.appendChild(avatarEl(ctx, username, 'xs')); a.onclick = openProfile; el.appendChild(a); }
      el.appendChild(bodyOf(m));
      th.appendChild(el);
      rows.push({ m, el, sep, k: '' });
      if (!quiet) { groupAt(rows.length - 2); groupAt(rows.length - 1); refreshStatus(); v.content.scrollTop = 1e6; }
      return true;
    };

    /* rpcRaw: o motivo da recusa chega até aqui (ver ERR). O texto só sai da caixa quando o servidor aceita:
       antes apagava-se logo e uma recusa perdia a mensagem escrita. `sending` trava o Enter repetido. */
    let sending = false;
    const send = async () => {
      const t = inp.value.trim(); if (!t || sending) return;
      sending = true; bar.classList.add('sending');
      let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: username, type: 'text', content: t, app }); } catch (e) { r = null; }
      sending = false; bar.classList.remove('sending');
      if (r && !r.error) {
        if (inp.value.trim() === t) inp.value = '';
        syncText();
        add(r); Sound.play('send');
      } else failed(ctx, r, 'Não foi possível enviar');
    };
    const sendPhoto = async src => { const r = await sendPhotoTo(ctx, username, src); if (r) add(r); };
    bar.querySelector('.igdm-send').onclick = send;
    inp.onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); send(); } };
    inp.oninput = syncText;
    bar.querySelector('.igdm-cam-btn').onclick = async () => { const raw = await camera(ctx.win, '@' + username); if (raw) sendPhoto(raw); };
    bar.querySelector('.igdm-ph').onclick = async () => { if (!window.Photos || !Photos.pick) { UI.toast('A galeria não está disponível'); return; } const p = await Photos.pick('Enviar fotografia'); if (!p) return; const url = await Photos.data(p, true); sendPhoto(url || p.seed); };
    /* voz: o gravador do telemóvel (VoiceMsg) - sobe pelo media.* e a mensagem leva só o id */
    bar.querySelector('.igdm-mic').onclick = () => {
      if (!window.VoiceMsg || !VoiceMsg.supported || !VoiceMsg.supported()) { UI.toast('Sem microfone disponível'); return; }
      bar.classList.add('rec');
      const end = () => { bar.classList.remove('rec'); const old = bar.querySelector('.vmsg-rec'); if (old) old.remove(); };
      try {
        VoiceMsg.recorder(bar, { app, onCancel: end, onSend: async (blob, ms, wave) => {
          end();
          const up = await VoiceMsg.upload(blob, ms, wave);
          if (!up || !up.mediaId) { UI.toast('A mensagem de voz não foi enviada'); return; }
          let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: username, type: 'audio', content: 'Mensagem de voz', app, mediaId: up.mediaId, payload: { mediaId: up.mediaId, duration: Math.round(ms / 1000), waveform: wave } }); } catch (e) { r = null; }
          if (r && !r.error) { add(r); Sound.play('send'); } else failed(ctx, r, 'A mensagem de voz não foi enviada');
        } });
      } catch (e) { end(); UI.toast('Não foi possível gravar'); }
    };

    /* ouvintes: registados depois da carga (a ordem das bolhas é a do servidor); se a vista sair antes, `dead` impede-os.
       release() larga tudo (ouvintes, observador da pilha, foto aberta): no onPop e, se a vista morrer sem onPop (app morta), no
       primeiro push que a encontre fora do documento */
    let dead = false, off = null, offSt = null, offs = [], mo = null;
    const release = () => { dead = true; [off, offSt].concat(offs).forEach(f => { try { if (f) f(); } catch (e) {} }); off = offSt = null; offs = [];
      if (mo) { try { mo.disconnect(); } catch (e) {} mo = null; } if (closeViewer) { closeViewer(); closeViewer = null; } };
    v.opts.onPop = () => { release(); if (opts.onClose) { try { opts.onClose(); } catch (e) {} } };
    UI.push(ctx.win, v);
    if (typeof opts.online === 'boolean') { online = opts.online; paintSub(); }
    else ctx.rpc('messages.threads', { app }).then(ts => { const t = arr(ts).find(x => x && x.number === username); if (t && t.online && !dead) { online = true; paintSub(); } }).catch(() => {});
    let msgs = null; try { msgs = await ctx.rpc('messages.get', { number: username, app }); } catch (e) { msgs = null; }
    if (dead) return v;
    arr(msgs).forEach(m => add(m, true));
    for (let i = 0; i < rows.length; i++) groupAt(i);
    refreshStatus(); v.content.scrollTop = 1e6;
    /* (4 nov 2026) LIDA só com a conversa MESMO à frente do jogador - a regra das Mensagens (messages.js visible()/seeAgain): o
       Instashot é a app à vista, o telemóvel está desbloqueado e na mão, e esta conversa é a vista de cima da pilha (não está a sair
       nem tapada por um perfil). Antes cada DM que chegasse com a vista viva era marcada lida - Instashot em segundo plano (o
       closeApp guarda a janela), telemóvel guardado ou bloqueado, perfil por cima - e o servidor mandava 'read' a quem a enviou: com
       o "Visto" novo isso via-se como um recibo de leitura falso, e o avião de quem recebeu nunca acendia o ponto de por ler.
       O que chega sem ser visto fica `unseen` e lê-se ao voltar (abrir o telemóvel, desbloquear, voltar à app, sair do perfil). */
    const onScreen = () => System.currentApp() === app && !System.locked && !(Bridge.inFiveM && document.body.classList.contains('hidden'))
      && !!v.parentNode && !v.classList.contains('leave') && v === v.parentNode.lastElementChild;
    let unseen = false;
    const markRead = () => { unseen = false; ctx.rpc('messages.read', { number: username, app }); };
    const seeAgain = () => { if (unseen && !dead && onScreen()) markRead(); };
    if (onScreen()) markRead(); else unseen = true;
    off = Bridge.on('social:dm', m => { if (!v.isConnected) { release(); return; }
      if (m && m.app === app && !m.conversation && (m.sender === username || m.receiver === username)) { if (add(m) && m.sender === username) { if (onScreen()) markRead(); else unseen = true; } } });
    offs.push(Bridge.on('phone:open', () => setTimeout(seeAgain, 0)), Bridge.on('unlock', () => setTimeout(seeAgain, 250)),
      Bridge.on('app:open', id => { if (id === app) setTimeout(seeAgain, 0); }));
    /* sair de um perfil aberto por cima: o UI.pop tira a vista de cima 420 ms depois e a pilha muda - aí a conversa volta a ser a de cima */
    try { if (window.MutationObserver && v.parentNode) { mo = new MutationObserver(() => { if (unseen) seeAgain(); }); mo.observe(v.parentNode, { childList: true }); } } catch (e) { mo = null; }
    /* recibo de leitura ao vivo: o servidor manda messageStatus { ids, status:'read', at, number: <quem leu>, app } a quem enviou
       (server/messages.lua); o messages.js ignora-o fora das SMS (de propósito) e não o reemite, por isso é ouvido aqui.
       Ler a conversa lê tudo até ao maior id: as minhas até lá passam a "Visto" */
    offSt = Bridge.on('messageStatus', d => {
      if (!v.isConnected) { release(); return; }
      if (!d || d.app !== app || d.conversation || d.status !== 'read' || String(d.number) !== username) return;
      const max = arr(d.ids).reduce((a, x) => Math.max(a, int(x)), 0); if (!max) return;
      let ch = false;
      rows.forEach(r => { if (r.m.sender === me && int(r.m.id) <= max && r.m.status !== 'read') { r.m.status = 'read'; r.m.readAt = d.at; ch = true; } });
      if (ch) refreshStatus();
    });
    return v;
  }

  return { list, thread, label, picker, camera };
})();
