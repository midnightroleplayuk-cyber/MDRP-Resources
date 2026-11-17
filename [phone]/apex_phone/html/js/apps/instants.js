/* ============================================================
   INSTANTS - a fotografia do MOMENTO, vista uma só vez
   (Instashot › Mensagens › a pilha de fotografias no canto inferior direito)

   As regras, tal como o utilizador as pediu:
     · toca-se na PILHA e abre a CÂMARA - a fotografia é tirada ali, na hora;
       NÃO há galeria: não se escolhe nada antigo (por isso este ficheiro nunca
       chama o Photos.pick nem monta grelha nenhuma de fotografias);
     · pode-se acrescentar TEXTO, mas não há filtros nem edição da imagem:
       a foto vai exatamente como saiu do visor (é por isso que se usa o
       `cam.capture()` e não o `cam.shoot()` - este último aplicaria o
       `process` e ainda guardaria a foto nas Fotos do jogador);
     · escolhe-se AMIGOS PRÓXIMOS ou MÚTUOS (quem te segue e tu também segues);
     · cada pessoa vê UMA vez - depois desaparece para ela - e ao fim de 24 h
       desaparece para toda a gente.

   Quem faz cumprir as regras é o SERVIDOR (server/social.lua, secção INSTANTS):
   é lá que a visualização é queimada e que o público é verificado. Aqui é só o
   ecrã. A imagem sobe e desce aos bocados de 48 KB, como tudo o resto que leva
   base64 neste telemóvel.

   ⚠️ O visor é o CamView (a câmara do telemóvel). Tem de ser desligado em TODOS
   os caminhos de saída - × , Escape, trocar de app, guardar o telemóvel - senão
   o jogador fica sem HUD e com a câmara scriptada presa a ele.
   ============================================================ */
window.Instants = (() => {
  const g = UI.g;
  const CHUNK = 48000;

  /* ---------- dados ---------- */
  const list = app => Bridge.rpc('social.instant.list', { app }).then(r => r || { inbox: [], mine: [] });

  /* a media vem aos bocados; o pedido é sequencial de propósito (cada bocado é um RPC e o
     cliente desiste aos 10 s - mandar 60 de uma vez era garantir o tempo esgotado) */
  async function fetchMedia(app, id, len, chunk) {
    if (!len) return null;
    const total = Math.ceil(len / (chunk || CHUNK));
    if (total > 64) return null;
    let out = '';
    for (let i = 1; i <= total; i++) {
      const r = await Bridge.rpcRaw('social.instant.media', { app, id, i });
      if (!r || r.error || typeof r.data !== 'string') return null;
      out += r.data;
      if (!r.data.length) break;
    }
    return /^data:image\//.test(out) ? out : null;
  }

  async function upload(app, id, data) {
    const total = Math.ceil(data.length / CHUNK);
    if (total > 64) return 'toolarge';
    for (let i = 1; i <= total; i++) {
      const r = await Bridge.rpcRaw('social.instant.upload', { app, id, i, total, data: data.slice((i - 1) * CHUNK, i * CHUNK) });
      if (!r || r.error) return (r && r.error) || 'rpc';
    }
    return null;
  }

  /* ---------- camada de ecrã inteiro (base comum aos três ecrãs) ----------
     Uma camada vive DENTRO da janela da app (win), tapa-a toda e fecha-se por uma porta só.
     O `close()` é idempotente: o win.onClose é encadeado e nunca reposto, por isso pode ser
     chamado duas vezes (uma pelo × e outra pelo fecho da app). */
  function layer(win, app, cls, html) {
    const root = UI.el(`<div class="ins-layer ${cls}">${html}</div>`);
    let dead = false;
    const onKey = e => {
      if (!root.isConnected || dead) return;
      if (document.activeElement && document.activeElement.matches('input,textarea')) return;
      /* ⚠️ sem o stopPropagation o system.js também ouve o Escape e fecha o TELEMÓVEL inteiro */
      if (e.key === 'Escape') { e.preventDefault(); e.stopPropagation(); root.close(); }
    };
    const extras = [];
    root.onClose = null;
    root.close = () => {
      if (dead) return;
      dead = true;
      document.removeEventListener('keydown', onKey);
      extras.forEach(f => { try { f(); } catch (e) {} });
      try { root.onClose && root.onClose(); } catch (e) {}
      root.remove();
    };
    root.onExit = f => extras.push(f);
    Object.defineProperty(root, 'dead', { get: () => dead });
    document.addEventListener('keydown', onKey);
    /* trocar de app NÃO corre o win.onClose (a janela é só escondida): sem isto a câmara
       ficava viva por baixo da app seguinte, com o HUD do jogador escondido.
       O id é comparado: o evento é emitido para QUALQUER app que seja escondida. */
    const offApp = Bridge.on('app:close', id => { if (!app || id === app) root.close(); });
    extras.push(offApp);
    const prev = win.onClose;
    win.onClose = () => { root.close(); prev && prev(); };
    win.appendChild(root);
    requestAnimationFrame(() => root.classList.add('in'));
    setTimeout(() => { if (!dead) root.classList.add('in'); }, 120);   /* rede: no headless o frame pode não vir */
    return root;
  }

  /* =====================================================================
     1. CÂMARA - a fotografia é tirada AQUI. Não há galeria nenhuma.
     ===================================================================== */
  function camera(app, me, win, onReady) {
    const root = layer(win, app, 'ins-cam', `
      <div class="ins-view"></div>
      <div class="ins-top">
        <div class="b x">${g('x', 22)}</div>
        <div class="ins-ttl">Instant</div>
        <div class="b fl off">${g('bolt', 22)}</div>
      </div>
      <div class="ins-hint">Só podem ver uma vez · desaparece em 24 h</div>
      <div class="ins-bot">
        <div class="ins-shut"><div></div></div>
        <div class="ins-flip">${g('repeat', 22)}</div>
      </div>`);
    const view = root.querySelector('.ins-view');

    const cam = CamView.mount(view, {
      chrome: 'bare',
      aspect: (view.clientWidth || 440) / (view.clientHeight || 956),
      autoActivate: false,     /* só liga o cameraMode do Lua quando o ecrã está mesmo à frente */
      aimInside: true,
    });
    cam.setActive(true);
    root.onExit(() => { try { cam.destroy(); } catch (e) {} });

    root.querySelector('.b.x').onclick = () => root.close();
    root.querySelector('.ins-flip').onclick = () => { cam.flip(); };
    root.querySelector('.b.fl').onclick = e => { cam.setFlash(!cam.flash); e.currentTarget.classList.toggle('off', !cam.flash); };

    let busy = false;
    root.querySelector('.ins-shut').onclick = async () => {
      if (busy || root.dead) return;
      busy = true;
      const r = await cam.capture();
      busy = false;
      if (root.dead) return;
      if (!r || !r.raw) { UI.toast((r && r.msg) || 'Não consegui tirar a fotografia', 3000); return; }
      /* a câmara sai de cena mal a foto exista: o ecrã seguinte é só a imagem parada */
      root.close();
      compose(app, me, win, r.raw, onReady);
    };
    return root;
  }

  /* =====================================================================
     2. COMPOR - a foto parada, texto por cima e para quem vai.
        Sem filtros e sem edição: a imagem é a que saiu do visor.
     ===================================================================== */
  function compose(app, me, win, image, onReady) {
    const root = layer(win, app, 'ins-compose', `
      <div class="ins-photo"></div>
      <div class="ins-top">
        <div class="b x">${g('x', 22)}</div>
        <div class="ins-ttl">Instant</div>
        <div class="b aa">${g('textsize', 22)}</div>
      </div>
      <div class="ins-txt" style="display:none"><span></span></div>
      <div class="ins-send">
        <div class="ins-who">Para quem vai?</div>
        <div class="ins-opts">
          <div class="o cf">${g('star', 20)}<b>Amigos próximos</b><span>Só a tua lista</span></div>
          <div class="o mu">${g('users', 20)}<b>Mútuos</b><span>Seguem-te e segues</span></div>
        </div>
      </div>
      <div class="ins-busy"><div class="sp"></div><span>A enviar…</span></div>`);

    /* ⚠️ o base64 vai pelo CSSOM e NUNCA dentro de uma string de HTML (o url("…") fecharia o
       atributo na primeira aspa) - e depois de escrever background-image não se volta a tocar
       no atalho `background`, que apagaria a imagem. */
    const ph = root.querySelector('.ins-photo');
    ph.style.backgroundImage = UI.img ? UI.img(image) : `url('${String(image).replace(/'/g, '%27')}')`;

    const txtBox = root.querySelector('.ins-txt'), txtEl = txtBox.querySelector('span');
    /* 0.62 e não 0.8: o painel "Para quem vai?" ocupa o quarto de baixo do ecrã e o texto caía
       mesmo em cima dele. O arrasto também não o deixa entrar aí (ver o limite mais abaixo). */
    let text = '', ty = 0.62;

    const paintText = () => {
      txtBox.style.display = text ? '' : 'none';
      txtEl.textContent = text;
      txtBox.style.top = (ty * 100).toFixed(2) + '%';
    };
    const askText = async () => {
      const t = await UI.prompt('Texto', '', 'Escreve alguma coisa', text);
      if (t === null) return;
      text = String(t).slice(0, 120).replace(/\s+/g, ' ').trim();
      paintText();
    };
    root.querySelector('.b.aa').onclick = askText;
    txtBox.onclick = askText;
    root.querySelector('.b.x').onclick = () => root.close();

    /* arrastar o texto só na VERTICAL: é a única "edição" que existe, e nem sequer toca na
       imagem - é onde o texto fica por cima dela. */
    let drag = null;
    txtBox.addEventListener('pointerdown', e => { if (!text) return; drag = { y: e.clientY, ty, on: false }; document.addEventListener('pointerup', endDrag); });
    txtBox.addEventListener('pointermove', e => {
      if (!drag) return;
      const dy = e.clientY - drag.y;
      if (!drag.on) { if (Math.abs(dy) < 6) return; drag.on = true; try { txtBox.setPointerCapture(e.pointerId); } catch (x) {} }
      const h = root.clientHeight || 956;
      ty = Math.max(0.08, Math.min(0.72, drag.ty + dy / h));   /* nunca por baixo do painel de envio */
      txtBox.style.top = (ty * 100).toFixed(2) + '%';
    });
    /* ⚠️ largar vale em QUALQUER sítio: se a captura do ponteiro falhar e o botão subir fora do
       texto, o `pointerup` nunca chegava ao elemento e o texto ficava a seguir o rato para sempre.
       Daí o ouvinte no documento, posto no pointerdown e retirado aqui. */
    function endDrag(e) {
      document.removeEventListener('pointerup', endDrag);
      if (!drag) return;
      const moved = drag.on;
      try { if (e && e.pointerId != null) txtBox.releasePointerCapture(e.pointerId); } catch (x) {}
      drag = null;
      if (!moved && e && e.target && txtBox.contains(e.target)) askText();   /* toque simples = editar */
    }
    txtBox.addEventListener('pointerup', endDrag);
    txtBox.addEventListener('pointercancel', endDrag);
    root.onExit(() => document.removeEventListener('pointerup', endDrag));

    let busy = false;
    const send = async audience => {
      if (busy || root.dead) return;
      busy = true; root.classList.add('busy');
      const r = await Bridge.rpcRaw('social.instant.add', { app, text: text || null, ty, tsize: 30, audience });
      if (!r || r.error || !r.id) {
        busy = false; root.classList.remove('busy');
        UI.alert({ title: 'Não enviado', msg: r && r.error === 'toomany' ? 'Tens Instants a mais em curso.' : r && r.error === 'off' ? 'Os Instants estão desligados neste servidor.' : 'Tenta outra vez.' });
        return;
      }
      const err = await upload(app, r.id, image);
      if (err) {
        /* meio Instant não serve a ninguém: apaga-se a linha já criada */
        Bridge.rpc('social.instant.delete', { app, id: r.id });
        busy = false; root.classList.remove('busy');
        UI.alert({ title: 'Não enviado', msg: err === 'toolarge' ? 'A fotografia é grande demais.' : 'A fotografia não subiu toda.' });
        return;
      }
      const fin = await Bridge.rpcRaw('social.instant.ready', { app, id: r.id });
      busy = false; root.classList.remove('busy');
      if (!fin || fin.error) {
        Bridge.rpc('social.instant.delete', { app, id: r.id });
        UI.alert({ title: 'Não enviado', msg: 'Tenta outra vez.' });
        return;
      }
      Sound.play('success');
      UI.toast(audience === 'mutuals' ? 'Instant enviado aos mútuos' : 'Instant enviado aos amigos próximos');
      root.close();
      if (onReady) { try { onReady(); } catch (e) {} }
    };
    root.querySelector('.ins-opts .cf').onclick = () => send('close');
    root.querySelector('.ins-opts .mu').onclick = () => send('mutuals');
    paintText();
    return root;
  }

  /* =====================================================================
     3. VER - uma vez e nunca mais.
        O desenho é o do Instagram (referência do utilizador): fundo preto, a
        fotografia num recorte irregular (o "blob" dos Instants), o autor por
        baixo com a hora e o pontinho verde de quem está online, o cacho de
        reações e o campo para responder.
        A visualização é queimada ANTES de a imagem aparecer - e o servidor
        volta a queimá-la ao entregar os bocados, por isso não depende de o
        telemóvel colaborar.
     ===================================================================== */
  const REACOES = ['😂', '❤️', '😮', '👏'];

  /* `opts.hold`: não fecha sozinho - serve ao harness de capturas (_shot.html#instants&view). */
  function viewer(app, me, win, items, idx, onDone, opts = {}) {
    let i = Math.max(0, Math.min(items.length - 1, idx || 0));
    /* o tamanho do bocado vem do servidor (no envelope da lista); a constante é só a rede */
    const chunk = opts.chunk || CHUNK;
    const root = layer(win, app, 'ins-viewer', `
      <div class="ins-vtop">
        <div class="b x">${g('x', 22)}</div>
        <div class="sp"></div>
        <div class="b grid">${g('grid', 21)}</div>
        <div class="b cam">${g('camera', 21)}</div>
      </div>
      <div class="ins-blobwrap"><div class="ins-blob"><div class="ins-photo"></div><div class="ins-txt" style="display:none"><span></span></div><div class="ins-load"><div class="sp"></div></div></div></div>
      <div class="ins-by"><div class="av"></div><b class="who"></b><span class="ago"></span><i class="dot" style="display:none"></i></div>
      <div class="ins-react"></div>
      <div class="ins-reply"><input type="text" maxlength="300" placeholder="Responder…"><div class="go">${g('arrowUp', 20)}</div></div>`);

    const blob = root.querySelector('.ins-blob'), ph = root.querySelector('.ins-photo');
    const who = root.querySelector('.who'), ago = root.querySelector('.ago'), avEl = root.querySelector('.ins-by .av'), dot = root.querySelector('.ins-by .dot');
    const txtBox = root.querySelector('.ins-txt'), txtEl = txtBox.querySelector('span');
    const reactBox = root.querySelector('.ins-react'), inp = root.querySelector('.ins-reply input');
    let loading = false, aberto = null;   /* `aberto` = o Instant que está à vista */

    const sair = () => { root.close(); if (onDone) onDone(); };
    const next = () => {
      /* ⚠️ enquanto a fotografia está a descarregar, tocar NÃO pode avançar: o show() voltava a
         entrar, queimava a visualização do Instant SEGUINTE e mostrava-o por cima - duas
         visualizações gastas numa vista só. */
      if (loading) return;
      i++;
      if (i >= items.length) { sair(); return; }
      show();
    };
    root.querySelector('.b.x').onclick = sair;
    /* a câmara aqui é responder com um Instant teu (é o que o ícone quer dizer) */
    root.querySelector('.b.cam').onclick = () => { const w = win; sair(); camera(app, me, w, null); };
    /* a grelha: quantos faltam ver (e saltar para o próximo sem fechar) */
    root.querySelector('.b.grid').onclick = () => {
      const faltam = items.length - i - 1;
      if (faltam > 0) { UI.toast('Mais ' + faltam + ' por ver'); next(); }
      else UI.toast('Não tens mais Instants por ver');
    };
    /* tocar NA FOTOGRAFIA avança (como no Instagram); o resto do ecrã é para reagir e responder,
       por isso não avança - dava para perder um Instant a tentar escrever */
    blob.addEventListener('click', () => next());

    /* ---------- reações ---------- */
    /* O cacho da referência: duas fileiras desencontradas - em cima 😂 ❤️ + , em baixo 😮 👏. */
    const reagir = async (em, entao) => {
      if (!aberto) return;
      const r = await Bridge.rpcRaw('social.instant.react', { app, id: aberto.id, emoji: em });
      if (r && r.ok) { Sound.play('pop'); entao(em); UI.toast('Reagiste ' + em); }
      else UI.toast(r && r.error === 'notseen' ? 'Abre o Instant primeiro' : 'Não consegui reagir');
    };
    const paintReacoes = minha => {
      reactBox.innerHTML = '';
      const r1 = UI.el('<div class="rr"></div>'), r2 = UI.el('<div class="rr off"></div>');
      const botao = (em, fila) => {
        const b = UI.el(`<div class="r${minha === em ? ' on' : ''}">${em}</div>`);
        b.onclick = ev => { ev.stopPropagation(); reagir(em, paintReacoes); };
        fila.appendChild(b);
      };
      botao(REACOES[0], r1); botao(REACOES[1], r1);
      /* o + abre o resto dos emojis que o servidor aceita */
      const mais = UI.el('<div class="r more">+</div>');
      mais.onclick = async ev => {
        ev.stopPropagation();
        if (!aberto) return;
        const em = await UI.picker('Reagir', ['🔥', '😍', '😢', '👍']);
        if (em) reagir(em, paintReacoes);
      };
      r1.appendChild(mais);
      botao(REACOES[2], r2); botao(REACOES[3], r2);
      reactBox.append(r1, r2);
    };

    /* ---------- responder (mensagem direta ao autor) ---------- */
    const responder = async () => {
      const txt = inp.value.trim();
      if (!txt || !aberto) return;
      inp.value = '';
      const m = await Bridge.rpc('messages.send', { to: aberto.author, type: 'text', content: txt, app });
      if (m && !m.error) { Sound.play('send'); UI.toast('Resposta enviada a @' + aberto.author); }
      else UI.toast('Não consegui responder');
    };
    root.querySelector('.ins-reply .go').onclick = ev => { ev.stopPropagation(); responder(); };
    inp.onkeydown = e => { if (e.key === 'Enter') responder(); };
    root.querySelector('.ins-reply').addEventListener('click', ev => ev.stopPropagation());

    async function show() {
      const it = items[i];
      if (!it) { sair(); return; }
      aberto = null;
      loading = true;
      root.classList.add('loading');
      ph.style.backgroundImage = '';
      txtBox.style.display = 'none';
      who.textContent = it.author || '';
      ago.textContent = it.created ? UI.timeAgo(it.created) : '';
      avEl.innerHTML = UI.avatar({ name: it.author, avatar: it.avatar }, 'xs');
      dot.style.display = it.online ? '' : 'none';
      inp.placeholder = 'Responder a ' + (it.author || '') + '…';
      paintReacoes(null);

      /* QUEIMA PRIMEIRO. Se a ligação cair a meio da imagem, o Instant continua consumido -
         é o que "só podes ver uma vez" quer dizer, e é assim que quem enviou fica protegido. */
      await Bridge.rpc('social.instant.view', { app, id: it.id });
      if (root.dead) { loading = false; return; }
      const img = await fetchMedia(app, it.id, it.imageLen, it.chunk || chunk);
      if (root.dead) { loading = false; return; }
      loading = false;
      root.classList.remove('loading');
      if (!img) { UI.toast('Não consegui abrir este Instant'); next(); return; }
      aberto = it;
      ph.style.backgroundImage = UI.img ? UI.img(img) : `url('${String(img).replace(/'/g, '%27')}')`;
      if (it.text) { txtBox.style.display = ''; txtEl.textContent = it.text; txtBox.style.top = ((it.ty || 0.8) * 100).toFixed(2) + '%'; txtEl.style.fontSize = (it.tsize || 30) + 'px'; }
    }
    show();
    return root;
  }

  /* =====================================================================
     4. A PILHA - no canto inferior direito das Mensagens
        É a porta de entrada, como no Instagram: se houver Instants por ver,
        abre o visualizador; se não houver, abre a câmara.
     ===================================================================== */
  function attach(app, me, win, v) {
    const pile = UI.el(`<div class="ins-pile"><div class="back"></div><div class="card"><div class="word">INSTANTS</div><div class="cam">${g('camera', 22)}</div></div><div class="n"></div></div>`);
    v.appendChild(pile);

    let data = { inbox: [], mine: [] }, dead = false;
    const paint = () => {
      /* servidor com os Instants desligados (Config.Instants.enabled = false): a pilha nem aparece.
         Sem isto continuava lá, abria a câmara - tirando o HUD ao jogador - e só falhava no fim. */
      if (data.off) { pile.style.display = 'none'; return; }
      pile.style.display = '';
      /* ⚠️ A PILHA NÃO MOSTRA FOTOGRAFIA NENHUMA (pedido do utilizador): é só o cartão com a palavra
         e a câmara. Um Instant RECEBIDO nunca poderia lá estar - vê-lo é gastar a única visualização -
         e mostrar o que EU enviei obrigava a descarregar a imagem só para pintar um cartão de 100 px.
         O distintivo azul é que diz quantos há por ver. */
      const inbox = data.inbox || [];
      pile.classList.toggle('has', inbox.length > 0);
      pile.querySelector('.n').textContent = inbox.length ? String(inbox.length) : '';
    };
    const refresh = async () => {
      if (dead) return;
      try { data = await list(app); } catch (e) { data = { inbox: [], mine: [] }; }
      if (dead) return;
      paint();
    };
    /* A PILHA: há por ver → abre o visualizador; não há → abre a câmara. */
    pile.onclick = () => {
      if (data.off) { UI.toast('Os Instants estão desligados neste servidor'); return; }
      const inbox = data.inbox || [];
      if (inbox.length) viewer(app, me, win, inbox, 0, refresh, { chunk: data.chunk });
      else camera(app, me, win, refresh);
    };
    /* Um Instant novo chega como notificação: basta repintar.
       ⚠️ O ouvinte larga-se sozinho quando a vista morre. O `onPop` só corre quando se SAI pelo
       botão de voltar - tocar noutro separador chama o setRoot, que apaga a pilha de vistas SEM
       correr onPop nenhum, e cada visita às mensagens deixava aqui um ouvinte preso à vista morta. */
    const offNotif = Bridge.on('notification', n => {
      if (dead || !pile.isConnected) { dead = true; offNotif(); return; }
      if (n && n.app === app) refresh();
    });
    const prevPop = v.opts.onPop;
    v.opts.onPop = () => { dead = true; offNotif(); prevPop && prevPop(); };
    refresh();
    return { refresh, pile };
  }
  return { attach, camera, compose, viewer, list, fetchMedia };
})();
