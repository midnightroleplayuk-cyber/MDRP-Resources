/* ===================== MAIL (servidor: emails de empresas, banco, multas, governo) =====================
   Fase 2 (pacote M6) - contrato em docs/ARQUITETURA.md 8.3 (e o cabeçalho de server/mail.lua):
   · pastas Caixa de entrada / Enviados / Rascunhos / Arquivo / Lixo (+ Assinalados), cada uma PAGINADA
     (mail.list { folder, before, limit }) e a carregar mais ao descer; a pesquisa é feita no servidor (q),
     porque com páginas o filtro local só via os primeiros 30 emails;
   · bandeira, lido e arquivar por SWIPE (para a esquerda: bandeira + arquivar; para a direita: lido) ou long press;
   · compor com anexos (foto da galeria, localização, contacto); cancelar com conteúdo pergunta
     Guardar rascunho / Apagar; tocar num rascunho continua-o e enviar apaga-o (draftId);
   · anexos no email aberto: foto pelo CSSOM (descarregada aos bocados, mail.attachment), localização abre
     os Mapas, contacto adiciona-se aos Contactos;
   · erros com nome (Bridge.rpcRaw): o Bridge.rpc normal troca { error } por null no jogo e o jogador via
     "Mensagem enviada" ou uma lista vazia quando o servidor tinha recusado.
   Tudo dentro de uma função: um `const` solto no topo de um script clássico é partilhado com todos os
   outros ficheiros e um nome repetido (PAGE, FOLDERS…) partia o script inteiro. */
(() => {
  const g = UI.g;
  const PAGE = 30;
  /* Config.Mail.maxAttachments que o `ready` traz (System.config.mail; o servidor aceita 0..10) ou os 4 do config.lua.
     Quem decide é o servidor (erro 'attachments' com max): aqui só se evita oferecer um anexo que ele recusaria. */
  const maxAtt = () => { const v = Math.floor(+(((window.System && System.config && System.config.mail) || {}).maxAttachments)); return v >= 0 && v <= 10 ? v : 4; };
  const FOLDERS = { inbox: 'Caixa de entrada', sent: 'Enviados', drafts: 'Rascunhos', archive: 'Arquivo', trash: 'Lixo' };
  const ORDER = ['inbox', 'sent', 'drafts', 'archive', 'trash'];
  const FICON = { inbox: 'mail', sent: 'send', drafts: 'compose', archive: 'storage', trash: 'trash', flagged: 'flag' };
  const titleOf = f => f === 'flagged' ? 'Assinalados' : (FOLDERS[f] || 'Mail');

  /* ⚠️ o json.encode do FiveM serializa uma tabela Lua VAZIA como {} e não []: uma caixa vazia rebentava o .filter */
  const rows = r => Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error ? Object.values(r).filter(x => x && typeof x === 'object' && x.id != null) : []);
  const attsOf = m => { const a = m && m.attachments; return (Array.isArray(a) ? a : (a && typeof a === 'object' ? Object.values(a) : [])).filter(x => x && typeof x === 'object' && typeof x.type === 'string'); };
  const failed = r => !r || !!r.error || r.ok === false;
  const isImage = a => a.type === 'photo' || (a.type === 'media' && a.kind === 'image');
  const mine = m => !!m && m.sender === 'Eu';
  const kb = n => { const b = Math.round((+n || 0) * 0.75 / 1024); return b > 0 ? b + ' KB' : ''; };   /* tamanho em base64 → bytes aproximados */

  /* mensagem honesta para cada código do servidor (e para a falta de resposta) */
  function errMsg(r) {
    if (r == null || r === false) return 'Sem resposta do servidor. Tenta novamente.';
    const e = r.error;
    if (e === 'ratelimit') return 'Demasiados pedidos seguidos. Espera um momento.';
    if (e === 'noplayer') return 'A personagem ainda não carregou.';
    if (e === 'db') return 'A base de dados ainda está a arrancar. Tenta daqui a pouco.';
    if (e === 'target') return 'Destinatário inválido.';
    if (e === 'invalid') return 'Nome ou número inválido.';   /* contacts.add (cartão de contacto de um email) */
    if (e === 'draftsfull') return `Tens demasiados rascunhos${r.max ? ' (máximo ' + r.max + ')' : ''}. Apaga alguns primeiro.`;
    if (e === 'empty') return 'O rascunho está vazio.';
    if (e === 'notfound') return 'Este email já não existe.';
    if (e === 'folder') return 'Não é possível mover para essa caixa.';
    if (e === 'attachments') {
      const n = r.index ? ` (anexo ${r.index})` : '';
      return ({ toomany: `No máximo ${r.max || maxAtt()} anexos por email.`, photo: 'A foto já não está disponível' + n + '.', video: 'Os vídeos não podem ser anexados' + n + '.',
        toolarge: 'O anexo é demasiado grande' + n + '.', location: 'Localização inválida' + n + '.', contact: 'Contacto inválido' + n + '.', media: 'Anexo indisponível' + n + '.' })[r.reason] || 'Um dos anexos não é válido' + n + '.';
    }
    return 'Tenta novamente.';
  }

  /* ---------- Conteúdo de um anexo (foto copiada / media), aos bocados ----------
     O base64 não pode vir na lista (30 emails × fotos de 200 KB num único evento de rede eram descartados).
     Vem por pedaços de ~48 KB (RPC mail.attachment), autorizado pelo email onde está. Em memória por mediaId
     (o mesmo anexo em Enviados e num reencaminhamento não se descarrega duas vezes), no máximo 16. */
  const attCache = new Map(), attPending = {};
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  /* O mail.attachment ainda conta no balde principal do limite de pedidos (server/main.lua): um email com 4 fotos
     são ~24 pedidos seguidos e, logo a seguir a abrir o telemóvel, alguns voltavam com 'ratelimit' e a foto ficava
     em "Não foi possível carregar". Espera e tenta de novo (até 4 vezes) em vez de desistir ao primeiro. */
  async function attChunk(req) {
    let r = null;
    for (let t = 0; t < 4; t++) {
      try { r = await Bridge.rpcRaw('mail.attachment', req); } catch (e) { r = null; }
      if (!(r && r.error === 'ratelimit')) return r;
      await sleep(700 * (t + 1));
    }
    return r;
  }
  function attData(mailId, index, a) {
    if (!a) return Promise.resolve(null);
    if (a.url) return Promise.resolve(a.url);
    if (!a.mediaId || !mailId) return Promise.resolve(null);
    const key = 'm' + a.mediaId;
    if (attCache.has(key)) return Promise.resolve(attCache.get(key));
    if (attPending[key]) return attPending[key];
    attPending[key] = (async () => {
      let out = '', total = 1, mime = String(a.mime || '');
      for (let i = 1; i <= total; i++) {
        const r = await attChunk({ id: mailId, index, i });
        if (!r || r.error || typeof r.data !== 'string') return null;
        total = Math.min(512, Math.max(1, +r.total || 1));   /* limite duro (o do servidor): nunca um ciclo infinito */
        if (r.mime) mime = String(r.mime);
        out += r.data;
        if (!r.data.length) break;
      }
      if (!out) return null;
      /* as cópias do Mail guardam o data: URL inteiro; um media enviado aos bocados pode guardar só o base64 */
      if (!/^[\w.+-]+\/[\w.+-]+$/.test(mime)) mime = 'application/octet-stream';
      const url = /^data:/.test(out) ? out : `data:${mime};base64,${out}`;
      if (isImage(a) && !/^data:image\//.test(url)) return null;
      attCache.set(key, url);
      if (attCache.size > 16) attCache.delete(attCache.keys().next().value);
      return url;
    })().then(u => { delete attPending[key]; return u; }, () => { delete attPending[key]; return null; });
    return attPending[key];
  }

  /* badge com a app fechada: basta a CONTAGEM (mail.unread = um COUNT no servidor), não 200 emails com o
     corpo inteiro. Sem esse RPC cai no mail.list de sempre. */
  const mailBadge = () => Bridge.rpc('mail.unread').then(r => {
    if (r && typeof r.unread === 'number') { System.badge('mail', r.unread); return; }
    return Bridge.rpc('mail.list').then(l => System.badge('mail', rows(l).filter(x => x.folder === 'inbox' && !x.read).length));
  }).catch(() => {});

  let pendingOpen = null;   /* id de um email a abrir quando a janela estiver pronta (toque numa notificação) */

  App.define('mail', {
    name: 'Mail', core: true, category: 'Comunicação',
    /* botão Voltar do sistema (Nova UI): fecha a gaveta das pastas ou volta à Caixa de entrada antes de fechar a app; true = consumido */
    back(win) { return !!(win && win._mail && win._mail.back && win._mail.back()); },
    open(win) {
      /* NOVA UI (Android): o mesmo correio, os mesmos RPC (mail.*), os mesmos anexos e rascunhos; muda o desenho: gaveta das
         pastas, lista com avatares, botão flutuante para escrever, leitor com barra de ações em baixo e compor em ecrã inteiro.
         A = Android; SW = prefixo das linhas com ações escondidas; ATT = cartões de anexo. */
      const A = !!(System.isAndroid && System.isAndroid());
      const SW = A ? 'amail-sw' : 'mail-sw', ATT = A ? 'amail-att' : 'mail-att';
      const MENU = '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 7h16M4 12h16M4 17h16"/></svg>';
      const PAL = ['#3E7BFA', '#2DBE60', '#FF8A1F', '#9B5CF2', '#F5476E', '#11A9C0', '#5866F2', '#A47A5A'];
      const avCol = s => { let h = 0; for (const ch of String(s || '?')) h = (h * 31 + ch.charCodeAt(0)) | 0; return PAL[Math.abs(h) % PAL.length]; };
      const avA = (name, cls = '') => { const e = document.createElement('div'); e.className = 'amail-av ' + cls; e.style.background = avCol(name); e.textContent = (String(name || '?').replace(/^@/, '').trim()[0] || '?').toUpperCase(); return e; };
      const stackViews = () => [...win.querySelectorAll('.nav-stack > .view:not(.leave)')];
      /* depois de mexer num email: cada vista da pilha atualiza-se a si própria (a lista tira/atualiza a
         linha, as Caixas voltam a contar) - sem recarregar páginas inteiras nem perder o scroll */
      const syncAll = m => { stackViews().forEach(v => { try { if (v._sync) v._sync(m); else if (v._counts) v.render(); } catch (e) { console.error('[apex_phone] mail sync', e); } }); };
      const reloadAll = () => { stackViews().forEach(v => { try { v.render && v.render(); } catch (e) { console.error('[apex_phone] mail reload', e); } }); mailBadge(); };

      /* ---------- Ações sobre um email (lista, menu, email aberto) ---------- */
      async function pickFolder(m) {
        const opts = ORDER.filter(x => x !== m.folder && (m.folder === 'drafts' ? x === 'trash' : ((x !== 'drafts' && x !== 'sent') || mine(m))));
        const v = await UI.actionSheet({ title: 'Mover para', buttons: opts.map(x => ({ label: FOLDERS[x], icon: FICON[x], value: x })) });
        return v || null;
      }
      async function act(m, kind, target) {
        let r = null;
        if (kind === 'move' && !target) { target = await pickFolder(m); if (!target) return null; }
        if (kind === 'archive') { kind = 'move'; target = 'archive'; }
        if (kind === 'read') r = await Bridge.rpcRaw('mail.read', { id: m.id, read: !m.read });
        else if (kind === 'flag') r = await Bridge.rpcRaw('mail.flag', { id: m.id, on: !m.flagged });
        else if (kind === 'move') r = await Bridge.rpcRaw('mail.move', { id: m.id, folder: target });
        else if (kind === 'delete') {
          /* no Lixo é para sempre: pergunta-se (fora do Lixo só muda de caixa e recupera-se) */
          if (m.folder === 'trash' && !(await UI.confirm('Apagar definitivamente?', 'Este email sai do Lixo e não pode ser recuperado.', 'Apagar', true))) return null;
          r = await Bridge.rpcRaw('mail.delete', { id: m.id });
        }
        if (failed(r)) { Sound.play('error'); UI.toast(errMsg(r)); return null; }
        if (kind === 'read') m.read = !m.read;
        else if (kind === 'flag') m.flagged = typeof r.flagged === 'boolean' ? r.flagged : !m.flagged;
        else if (kind === 'move') { m.folder = r.folder || target; UI.toast(target === 'archive' ? 'Arquivado' : 'Movido para ' + FOLDERS[m.folder]); }
        else if (kind === 'delete') { if (m.folder === 'trash' && r.deleted !== false) { m._gone = true; UI.toast('Apagado'); } else { m.folder = 'trash'; UI.toast('Movido para o Lixo'); } }
        mailBadge();
        return r;
      }

      /* ---------- Swipe numa linha (só transform anima) ---------- */
      function swipeRow(w, fg, holder) {
        const LW = 88;
        let sx = 0, sy = 0, base = 0, dx = 0, down = false, drag = false, pid = null;
        const rW = () => w.querySelectorAll(`.${SW}-r .${SW}-a`).length * LW;
        const lW = () => w.querySelector(`.${SW}-l .${SW}-a`) ? LW : 0;
        const set = (x, anim) => {
          fg.classList.toggle('sw-anim', !!anim);
          fg.style.transform = x ? `translate3d(${x.toFixed(1)}px,0,0)` : '';
          clearTimeout(w._swT);
          /* a voltar a zero as cores ficam até a linha chegar ao sítio, senão via-se o fundo do grupo */
          if (anim && !x) { w._swT = setTimeout(() => { if (!base) w.classList.remove('sw-left', 'sw-right', 'sw-full'); }, 320); return; }
          w.classList.toggle('sw-left', x > 0); w.classList.toggle('sw-right', x < 0);
          const R = rW(); w.classList.toggle('sw-full', (R > 0 && x <= -Math.max(R + 70, 230)) || x >= 170);
        };
        fg.addEventListener('pointerdown', e => {
          if (e.button && e.pointerType === 'mouse') return;
          holder.querySelectorAll('.' + SW).forEach(x => { if (x !== w && x._open) x._close(); });
          down = true; drag = false; sx = e.clientX; sy = e.clientY; pid = e.pointerId;
        });
        fg.addEventListener('pointermove', e => {
          if (!down) return;
          /* ⚠️ o cursor do jogo é um RATO: carregar, sair da linha antes dos 12 px e largar lá fora não entrega o
             pointerup a esta linha (ainda sem captura) e o `down` ficava preso - a seguir, só de passar o rato por
             cima, a linha arrastava-se atrás dele. Sem botão premido o gesto acabou. */
          if (e.pointerType === 'mouse' && !(e.buttons & 1)) { if (drag) up(); else down = false; return; }
          const z = UI.vrect ? UI.zoom(fg) || 1 : UI.zoom(), mx = (e.clientX - sx) / z, my = (e.clientY - sy) / z;   /* px da própria linha (o zoom do conteúdo no PearPhone Fold, ui.js) */
          if (!drag) {
            if (Math.abs(my) > 10 && Math.abs(my) > Math.abs(mx)) { down = false; return; }   /* é scroll vertical */
            if (Math.abs(mx) < 12) return;
            drag = true; try { fg.setPointerCapture(pid); } catch (x) {}
          }
          dx = Math.max(rW() ? -440 : 0, Math.min(lW() ? 440 : 0, base + mx));
          set(dx, false);
        });
        const up = () => {
          if (!down) return; down = false;
          if (!drag) return; drag = false; w._swiped = Date.now();
          const R = rW(), L = lW();
          if (R && dx <= -Math.max(R + 70, 230)) { base = 0; set(0, true); w._full && w._full('right'); }
          else if (L && dx >= 170) { base = 0; set(0, true); w._full && w._full('left'); }
          else if (R && dx < -44) { base = -R; set(-R, true); }
          else if (L && dx > 44) { base = L; set(L, true); }
          else { base = 0; set(0, true); }
          dx = base; w._open = base !== 0;
        };
        fg.addEventListener('pointerup', up); fg.addEventListener('pointercancel', up);
        w._close = () => { base = 0; dx = 0; w._open = false; set(0, true); };
      }

      /* ---------- Lista de uma caixa (paginada) ---------- */
      function folderView(f) {
        const v = A ? UI.view({ title: titleOf(f), large: true, cls: 'amail-v', left: [{ icon: 'list', onTap: () => drawer(f), ref: b => { b.innerHTML = MENU; b.classList.add('amail-menu'); } }], right: [{ icon: 'search', onTap: () => { search.classList.toggle('on'); if (search.classList.contains('on')) setTimeout(() => search.input.focus(), 60); else if (search.input.value) { search.input.value = ''; search.input.oninput(); } } }] })
          : UI.view({ title: titleOf(f), large: true, back: f !== 'inbox' ? 'Caixas' : undefined, right: [{ icon: 'compose', onTap: () => compose() }] });
        v._folder = f;
        const st = { items: [], more: false, loading: false, q: '', seq: 0, err: null };
        const belongs = m => !m._gone && (f === 'flagged' ? (m.flagged && m.folder !== 'trash') : m.folder === f);
        let sT = null;
        /* pesquisar não recarrega a cada tecla: 250 ms de folga e o `seq` garante que só a última pinta */
        const onQ = q => { clearTimeout(sT); sT = setTimeout(() => { if (q === st.q) return; st.q = q; load(true); }, 250); };
        const search = A ? (() => { const s = UI.el(`<div class="amail-search">${g('search', 20)}<input type="text" placeholder="Pesquisar no correio"><div class="amail-sx">${g('x', 16)}</div></div>`); const i = s.querySelector('input'); s.input = i;
          i.oninput = () => onQ(i.value.trim().toLowerCase()); s.querySelector('.amail-sx').onclick = () => { i.value = ''; i.oninput(); i.focus(); }; return s; })()
          : UI.search('Pesquisar', onQ);
        const GRP = A ? 'amail-group' : 'mail-group';
        const holder = UI.el(`<div class="${A ? 'amail-list' : 'mail-list'}"></div>`);
        const moreEl = UI.el(`<div class="${A ? 'amail-more' : 'mail-more'}"></div>`);
        moreEl.onclick = () => { if (!st.loading && st.more) load(false); };
        v.content.append(search, holder);
        if (A) { const fab = UI.el(`<div class="amail-fab">${g('pen', 24)}</div>`); fab.onclick = () => { Sound.play('click'); compose(); }; v.appendChild(fab); }
        /* Nova UI: na Caixa de entrada, o número de emails por ler fica por baixo do título grande (mail.unread é uma contagem no servidor) */
        const ltM = A && f === 'inbox' ? v.content.querySelector(':scope > .large-title') : null; const subM = ltM ? document.createElement('small') : null; if (subM) ltM.appendChild(subM);
        const paintSub = () => { if (!subM) return; Bridge.rpc('mail.unread').then(r => { if (r && typeof r.unread === 'number') subM.textContent = r.unread ? (r.unread === 1 ? '1 por ler' : r.unread + ' por ler') : 'Tudo lido'; }).catch(() => {}); };
        v.opts.onPop = () => clearTimeout(sT);

        function fill(w) {
          const m = w._m, draft = m.folder === 'drafts', out = draft || m.folder === 'sent' || mine(m);
          if (A) {
            /* Nova UI: avatar com a inicial, nome e hora em cima, assunto e excerto por baixo; não lido = negrito e ponto azul */
            const nm = out ? (m.recipient || m.email || (draft ? 'Sem destinatário' : '?')) : (m.sender || '?');
            const avw = w.querySelector('.amail-avw'); avw.innerHTML = ''; avw.appendChild(avA(nm));
            w.classList.toggle('amail-unread', !m.read && !draft);
            w.querySelector('.amail-who').textContent = nm;
            const tag = w.querySelector('.amail-tag'); tag.textContent = draft ? 'Rascunho' : ''; tag.classList.toggle('hidden', !draft);
            w.querySelector('.amail-ics').innerHTML = `${m.flagged ? `<i class="fl">${g('flag', 14)}</i>` : ''}${attsOf(m).length ? `<i>${g('paperclip', 14)}</i>` : ''}`;
            w.querySelector('.amail-time').textContent = UI.rel(m.created);
            w.querySelector('.amail-subj').textContent = m.subject || '(sem assunto)';
            w.querySelector('.amail-prev').textContent = String(m.body || '').replace(/\s+/g, ' ').trim().slice(0, 160);
          } else {
          const who = w.querySelector('.mr-who'), meta = w.querySelector('.mr-meta');
          /* avatar com as iniciais (só se vê no PearPhone Fold, referência 16; app-mail.css) */
          const av = w.querySelector('.mr-av'); if (av) { const nm = out ? (m.recipient || m.email || 'Eu') : (m.sender || '?'); if (av._nm !== nm) { av._nm = nm; av.innerHTML = UI.avatar({ name: nm }, 'sm'); } }
          who.innerHTML = '';
          if (!m.read && !draft) who.appendChild(UI.el('<span class="unread"></span>'));
          if (draft) who.appendChild(UI.el('<span class="mr-draft">Rascunho</span>'));
          const name = document.createElement('span'); name.className = 'mr-name';
          name.textContent = out ? (m.recipient || m.email || (draft ? 'Sem destinatário' : '--')) : (m.sender || '--');
          who.appendChild(name);
          meta.innerHTML = `${m.flagged ? `<span class="mr-flag">${g('flag')}</span>` : ''}${attsOf(m).length ? `<span class="mr-clip">${g('paperclip')}</span>` : ''}<span class="mr-time"></span>`;
          meta.querySelector('.mr-time').textContent = UI.rel(m.created);
          w.querySelector('.mr-subj').textContent = m.subject || '(sem assunto)';
          w.querySelector('.prev').textContent = String(m.body || '').replace(/\s+/g, ' ').trim().slice(0, 140);
          }
          /* ações escondidas atrás da linha */
          const L = w.querySelector(`.${SW}-l`), R = w.querySelector(`.${SW}-r`);
          L.innerHTML = ''; R.innerHTML = '';
          const btn = (cls, icon, label, fn) => { const b = UI.el(`<div class="${SW}-a ${cls}">${g(icon)}<span></span></div>`); b.querySelector('span').textContent = label; b.onclick = e => { e.stopPropagation(); w._close(); fn(); }; return b; };
          let lastR = null, lastL = null;
          if (!draft) { lastL = { cls: 'read', fn: () => doAct(m, 'read') }; L.appendChild(btn('read', 'mail', m.read ? 'Por ler' : 'Lida', lastL.fn)); }
          if (!draft && m.folder !== 'trash') R.appendChild(btn('flag', 'flag', m.flagged ? 'Remover' : 'Bandeira', () => doAct(m, 'flag')));
          if (m.folder === 'archive') lastR = { cls: 'inbox', icon: 'mail', label: 'Entrada', fn: () => doAct(m, 'move', 'inbox') };
          else if (m.folder === 'trash' || draft) lastR = { cls: 'trash', icon: 'trash', label: 'Apagar', fn: () => doAct(m, 'delete') };
          else lastR = { cls: 'archive', icon: 'storage', label: 'Arquivar', fn: () => doAct(m, 'archive') };
          R.appendChild(btn(lastR.cls, lastR.icon, lastR.label, lastR.fn));
          R.className = `${SW}-r c-` + lastR.cls; L.className = `${SW}-l` + (lastL ? ' c-read' : '');
          w._full = side => { if (side === 'right') lastR.fn(); else if (lastL) lastL.fn(); };
        }
        function row(m) {
          const w = A ? UI.el('<div class="amail-sw"><div class="amail-sw-l"></div><div class="amail-sw-r"></div><div class="amail-row"><div class="amail-avw"></div><div class="amail-rb"><div class="amail-top"><b class="amail-who"></b><span class="amail-tag hidden"></span><span class="amail-ics"></span><span class="amail-time"></span></div><div class="amail-subj"></div><div class="amail-prev"></div></div></div></div>')
            : UI.el('<div class="mail-sw"><div class="mail-sw-l"></div><div class="mail-sw-r"></div><div class="li mail-row"><div class="mr-av"></div><div class="li-body"><div class="li-label"><span class="mr-top"><span class="mr-who"></span><span class="mr-meta"></span></span></div><div class="mr-subj"></div><div class="prev"></div></div></div></div>');
          w._m = m;
          const fg = w.querySelector(A ? '.amail-row' : '.mail-row');
          fill(w);
          fg.onclick = () => {
            if (Date.now() - (w._swiped || 0) < 400) return;   /* o click que o browser dispara no fim de um arrasto */
            if (w._open) { w._close(); return; }
            if (m.folder === 'drafts') compose({ draft: m }); else openMail(m, { items: () => st.items });   /* a lista vai junto: anterior/seguinte na barra direita do PearPhone Fold */
          };
          UI.longPress(fg, () => { if (w._open) w._close(); rowMenu(m, fg); });
          swipeRow(w, fg, holder);
          return w;
        }
        function rowMenu(m, el) {
          const items = [];
          if (m.folder === 'drafts') items.push({ label: 'Continuar rascunho', icon: 'compose', onTap: () => compose({ draft: m }) });
          else {
            items.push({ label: m.read ? 'Marcar por ler' : 'Marcar como lida', icon: 'mail', onTap: () => doAct(m, 'read') });
            items.push({ label: m.flagged ? 'Remover bandeira' : 'Assinalar com bandeira', icon: 'flag', onTap: () => doAct(m, 'flag') });
            items.push({ label: 'Responder', icon: 'reply', onTap: () => compose({ reply: m }) });
            if (m.folder === 'inbox' || m.folder === 'sent') items.push({ label: 'Arquivar', icon: 'storage', onTap: () => doAct(m, 'archive') });
          }
          items.push({ label: 'Mover para…', icon: 'folder', onTap: () => doAct(m, 'move') });
          items.push({ label: m.folder === 'trash' ? 'Apagar definitivamente' : 'Apagar', icon: 'trash', danger: true, onTap: () => doAct(m, 'delete') });
          UI.ctxMenu(el, items);
        }
        async function doAct(m, kind, target) { const r = await act(m, kind, target); if (r) syncAll(m); }
        const rowOf = id => [...holder.querySelectorAll('.' + SW)].find(x => x._m && x._m.id === id);
        function removeRow(w) {
          st.items = st.items.filter(x => x !== w._m);
          w.classList.add('mail-gone');
          setTimeout(() => { w.remove(); if (!st.items.length) paint(); else paintMore(); }, 220);
        }
        /* outra vista (ou o email aberto) mexeu neste email: atualiza a linha ou tira-a desta caixa */
        v._sync = m => {
          paintSub();
          const w = rowOf(m.id); if (!w) return;
          if (w._m !== m) ['read', 'flagged', 'folder', '_gone'].forEach(k => { w._m[k] = m[k]; });
          if (belongs(w._m)) fill(w); else removeRow(w);
        };
        /* email novo (push): entra no topo sem recarregar a página nem mexer no scroll */
        v._incoming = m => {
          paintSub();
          if (!m || m.id == null || !belongs(m) || st.q || st.loading || rowOf(m.id)) return;
          st.items.unshift(m);
          const grp = holder.querySelector('.' + GRP);
          if (grp) grp.insertBefore(row(m), grp.firstChild); else paint();
          paintMore();
        };

        function paintMore() {
          moreEl.innerHTML = '';
          if (st.loading && st.items.length) { moreEl.appendChild(UI.spinner()); moreEl.appendChild(document.createTextNode('A carregar…')); }
          else if (st.err && st.items.length && st.more) moreEl.textContent = 'Não foi possível carregar mais · tocar para tentar de novo';
          else if (st.more) moreEl.textContent = 'Carregar mais';
          else moreEl.textContent = st.items.length ? `${st.items.length} ${st.items.length === 1 ? 'email' : 'emails'}` : '';
        }
        function paint() {
          holder.innerHTML = '';
          if (!st.items.length) {
            if (st.err !== null) {
              const e = A ? UI.el('<div class="amail-err"><b>Não foi possível carregar o correio</b><span></span><div class="amail-retry">Tentar novamente</div></div>') : UI.el('<div class="mail-err"><b>Não foi possível carregar o correio</b><span></span><div class="pill-btn">Tentar novamente</div></div>');
              e.querySelector('span').textContent = errMsg(st.err);
              e.querySelector(A ? '.amail-retry' : '.pill-btn').onclick = () => load(true);
              holder.appendChild(e); UI.emptyFit(e); return;
            }
            if (A) { const e = UI.el('<div class="amail-empty"><b></b><span></span></div>'); e.querySelector('b').textContent = st.q ? 'Sem resultados' : 'Sem emails'; e.querySelector('span').textContent = st.q ? 'Nenhum email corresponde à pesquisa.' : 'Não há nada em ' + titleOf(f) + '.'; holder.appendChild(e); UI.emptyFit(e); return; }
            holder.appendChild(st.q ? UI.empty('search', 'Sem resultados', 'Nenhum email corresponde à pesquisa.') : UI.empty(FICON[f] || 'mail', 'Sem mensagens', ''));
            return;
          }
          const grp = UI.el(A ? '<div class="amail-group"></div>' : '<div class="group mail-group"></div>');
          st.items.forEach(m => grp.appendChild(row(m)));
          holder.append(grp, moreEl);
          paintMore(); fillCheck();
        }
        /* a primeira página não enche o ecrã (caixa pequena, ecrã alto): sem scroll não haveria "ao descer" */
        const fillCheck = () => requestAnimationFrame(() => { const c = v.content; if (st.more && !st.loading && !st.err && c.clientHeight > 0 && c.scrollHeight <= c.clientHeight + 80) load(false); });

        async function load(reset) {
          if (!reset && (st.loading || !st.more)) return;
          const my = reset ? ++st.seq : st.seq;
          st.loading = true;
          if (reset && !st.items.length) { holder.innerHTML = ''; holder.appendChild(UI.skeleton('list', 6)); }
          if (!reset) paintMore();
          const last = reset ? null : st.items[st.items.length - 1];
          const req = Object.assign(f === 'flagged' ? { flagged: true } : { folder: f }, { limit: PAGE });
          if (last) req.before = last.id;
          if (st.q) req.q = st.q;
          let r = null; try { r = await Bridge.rpcRaw('mail.list', req); } catch (e) { r = null; }
          if (my !== st.seq) return;   /* chegou uma pesquisa/recarga mais nova entretanto */
          st.loading = false;
          if (r == null || r === false || (!Array.isArray(r) && (r.error || r.ok === false))) {
            st.err = r == null ? false : r;
            if (reset) { st.items = []; st.more = false; }
            paint(); return;
          }
          const got = rows(r);
          st.err = null; st.more = got.length >= PAGE; if (reset) paintSub();
          if (reset) { st.items = got; paint(); return; }
          const seen = new Set(st.items.map(x => x.id)), fresh = got.filter(x => !seen.has(x.id));
          st.items = st.items.concat(fresh);
          const grp = holder.querySelector('.' + GRP);
          if (!grp) { paint(); return; }
          fresh.forEach(m => grp.appendChild(row(m)));
          paintMore(); fillCheck();
        }
        v.content.addEventListener('scroll', () => { const c = v.content; if (st.more && !st.loading && !st.err && c.scrollTop + c.clientHeight >= c.scrollHeight - 320) load(false); }, { passive: true });
        v.render = () => load(true);
        load(true);
        return v;
      }

      /* ---------- Anexos no email aberto ---------- */
      function viewer(src) {
        const vw = UI.el(`<div class="viewer"><div class="vimg"><div></div></div><div class="vbar"><div class="cl">${g('x')}</div><div class="sv">${g('download')}</div></div></div>`);
        vw.querySelector('.vimg > div').style.backgroundImage = UI.img(typeof src === 'number' ? (src || 1) : src);
        /* PearPhone Fold: fechar e guardar vivem na barra direita enquanto a foto está aberta (a barra dela esconde-se, app-mail.css) */
        const shut = () => { vw.remove(); if (UI.railFor) UI.railFor(win, null); };
        vw.querySelector('.cl').onclick = shut;
        vw.querySelector('.sv').onclick = async () => {
          let r = null;
          /* data: URL grande vai aos bocados (Photos.save); link ou gradiente cabem num photos.add */
          if (typeof src === 'number') r = await Bridge.rpcRaw('photos.add', { seed: src });
          else if (/^data:image\//.test(src) && window.Photos && Photos.save) r = await Photos.save(src);
          else r = await Bridge.rpcRaw('photos.add', { url: src });
          if (failed(r)) { Sound.play('error'); UI.toast(r && r.error === 'toolarge' ? 'Imagem demasiado grande para a galeria' : 'Não foi possível guardar'); return; }
          UI.toast('Guardada em Fotos');
          if (window.Photos && Photos.load) Promise.resolve(Photos.load()).then(() => Bridge.emit('photos')).catch(() => {});
          shut();
        };
        win.appendChild(vw);
        if (UI.railFor) UI.railFor(win, { back: { onTap: shut, label: 'Fechar' }, primary: [[{ icon: 'download', label: 'Guardar em Fotos', onTap: () => vw.querySelector('.sv').click() }]] });
      }
      function attCard(m, a, index, v) {
        if (isImage(a)) {
          /* ⚠️ classes com prefixo ma-: .photo (grelha das Fotos), .map (Mapas, absolute inset:0) e .rm (ecrã principal)
             são globais e deformavam os cartões */
          const c = UI.el(`<div class="${ATT} ma-photo"><div class="ma-ph"></div><div class="ma-cap"><b>Foto</b><span class="muted small"></span></div></div>`);
          const ph = c.querySelector('.ma-ph'), sub = c.querySelector('.ma-cap span');
          let src = null;
          /* a imagem vai SEMPRE pelo CSSOM: um data: URL de 200 KB dentro de uma string de HTML atravessava o parser */
          if (a.url) { src = a.url; ph.style.backgroundImage = UI.img(a.url); sub.textContent = 'Imagem'; }
          else if (a.mediaId) {
            c.classList.add('ma-loading'); sub.textContent = 'A carregar…';
            attData(m.id, index, a).then(u => {
              c.classList.remove('ma-loading');
              if (!u) { c.classList.add('ma-failed'); sub.textContent = 'Não foi possível carregar a foto'; return; }
              src = u; ph.style.backgroundImage = UI.img(u); sub.textContent = kb(a.size || u.length);
            });
          } else if (a.seed != null) { src = +a.seed || 1; ph.style.backgroundImage = UI.img(src); }
          c.onclick = () => { if (src == null) { UI.toast(c.classList.contains('ma-loading') ? 'Ainda a carregar…' : 'Foto indisponível'); return; } viewer(src); };
          return c;
        }
        if (a.type === 'media' && a.kind === 'audio') {
          const c = UI.el(`<div class="${ATT} ma-au"><div class="ma-pl">${g('play')}</div><div class="ma-cap"><b>Áudio</b><span class="muted small"></span></div></div>`);
          const d = +a.duration || 0;
          c.querySelector('.ma-cap span').textContent = d ? UI.fmtDur(d / 1000) : 'Mensagem de voz';   /* duration em milissegundos (server/media.lua) */
          const pl = c.querySelector('.ma-pl'); let au = null;
          c.onclick = async () => {
            if (au) { if (au.paused) au.play().catch(() => {}); else au.pause(); return; }
            pl.classList.add('ma-busy');
            const u = await attData(m.id, index, a);
            pl.classList.remove('ma-busy');
            if (!u) { UI.toast('Áudio indisponível'); return; }
            au = new Audio(u); (v._audios = v._audios || []).push(au);
            au.onplay = () => { pl.innerHTML = g('pause'); };
            au.onpause = au.onended = () => { pl.innerHTML = g('play'); };
            au.play().catch(() => UI.toast('Não foi possível reproduzir'));
          };
          return c;
        }
        if (a.type === 'location') {
          const c = UI.el(`<div class="${ATT} ma-loc"><div class="ma-map">${g('pin')}</div><div class="ma-cap"><b></b><span class="muted small">Abrir nos Mapas</span></div><div class="ma-go">${g('chevR')}</div></div>`);
          c.querySelector('b').textContent = a.label || 'Localização';
          c.onclick = () => {
            const p = { x: +a.x, y: +a.y, label: a.label || 'Localização', name: a.label || 'Localização' };
            System.openApp('maps'); setTimeout(() => window.Maps && Maps.showAt(p), 300);   /* o mesmo caminho da bolha de localização das Mensagens */
          };
          return c;
        }
        if (a.type === 'contact') {
          const c = UI.el(`<div class="${ATT} ma-ct">${UI.avatar({ name: a.name || '?' }, 'sm')}<div class="ma-cap"><b></b><span class="muted small"></span></div><div class="ma-go">${g('personPlus')}</div></div>`);
          c.querySelector('b').textContent = a.name || 'Contacto'; c.querySelector('.ma-cap span').textContent = a.number || '';
          c.onclick = async () => {
            const ex = window.Contacts && Contacts.byNumber ? Contacts.byNumber(a.number) : null;
            if (ex) { UI.toast(`${ex.name} já está nos contactos`); return; }
            if (!(await UI.confirm('Adicionar aos contactos?', `${a.name} · ${a.number}`, 'Adicionar'))) return;
            /* Contacts.save devolve a resposta crua (com o erro) e já põe a linha na cache dos Contactos */
            let r = null;
            try { r = window.Contacts && Contacts.save ? await Contacts.save({ name: a.name, number: a.number }) : await Bridge.rpcRaw('contacts.add', { name: a.name, number: a.number }); } catch (e) { r = null; }
            if (failed(r)) { Sound.play('error'); UI.alert({ title: 'Não foi possível adicionar', msg: errMsg(r) }); return; }
            if (window.Contacts && !Contacts.save && Contacts.load) Contacts.load();
            Sound.play('success'); UI.toast('Contacto guardado');
          };
          return c;
        }
        return null;   /* tipo que esta versão não conhece: não se inventa um cartão */
      }

      /* ---------- Email aberto ---------- */
      function openMail(m, ctx, swap) {
        if (A) return openMailA(m);
        if (!m.read && m.folder !== 'drafts') {
          m.read = true; syncAll(m);
          Bridge.rpcRaw('mail.read', { id: m.id }).then(r => { if (failed(r)) { m.read = false; syncAll(m); } mailBadge(); });
        }
        const v = UI.view({ title: '', back: FOLDERS[m.folder] || 'Mail', full: true, right: [{ icon: 'trash', onTap: async () => { if (await act(m, 'delete')) { syncAll(m); UI.pop(win); } } }] });
        const out = mine(m);
        const meta = UI.el(`<div class="mail-meta"><div class="subj"></div><div class="from">${UI.avatar({ name: out ? (m.recipient || m.email || 'Eu') : (m.sender || '?') }, 'sm')}<div class="mm-who"><div><b class="mm-name"></b></div><div class="muted small mm-line"></div><div class="muted small mm-to"></div></div><div class="mm-flag">${g('flag')}</div></div></div>`);
        meta.querySelector('.subj').textContent = m.subject || '(sem assunto)';
        meta.querySelector('.mm-name').textContent = mine(m) ? L.t('Eu') : (m.sender || '');   /* 'Eu' e o marcador gravado do correio enviado: mostra-se traduzido */
        meta.querySelector('.mm-line').textContent = `${m.email || ''} · ${UI.fmtDate(new Date(+m.created), true)} ${UI.fmtTime(new Date(+m.created))}`;
        const toEl = meta.querySelector('.mm-to');
        if (m.recipient && m.recipient !== m.email) toEl.textContent = 'Para: ' + m.recipient; else toEl.remove();
        v.content.appendChild(meta);
        const bodyEl = UI.el('<div class="mail-body"></div>'); bodyEl.textContent = m.body || '';
        v.content.appendChild(bodyEl);
        const atts = attsOf(m);
        if (atts.length) {
          const box = UI.el(`<div class="mail-atts"><div class="mail-atts-h">${g('paperclip')}<span></span></div></div>`);
          box.querySelector('span').textContent = atts.length === 1 ? '1 anexo' : atts.length + ' anexos';
          atts.forEach((a, i) => { const c = attCard(m, a, i + 1, v); if (c) box.appendChild(c); });
          v.content.appendChild(box);
        }
        const restore = () => (m.folder === 'archive' || m.folder === 'trash');
        const bar = UI.el(`<div class="mail-actions"><div class="re">${g('reply')}</div><div class="fw">${g('forward')}</div><div class="fl">${g('flag')}</div><div class="ar">${g(restore() ? 'mail' : 'storage')}</div></div>`);
        const paintFlag = () => { bar.querySelector('.fl').classList.toggle('on', !!m.flagged); meta.classList.toggle('flagged', !!m.flagged); };
        const doFlag = async () => { if (await act(m, 'flag')) { paintFlag(); syncAll(m); UI.toast(m.flagged ? 'Marcado com bandeira' : 'Bandeira removida'); if (UI.railSync) UI.railSync(win); } };
        /* arquivar de verdade (antes era só um toast); no Arquivo e no Lixo o mesmo botão devolve à caixa de origem */
        const doArchive = async () => {
          const r = restore() ? await act(m, 'move', mine(m) ? 'sent' : 'inbox') : await act(m, 'archive');
          if (r) { syncAll(m); UI.pop(win); }
        };
        bar.querySelector('.re').onclick = () => compose({ reply: m });
        bar.querySelector('.fw').onclick = () => compose({ forward: m });
        bar.querySelector('.fl').onclick = doFlag;
        bar.querySelector('.ar').onclick = doArchive;
        paintFlag();
        /* PearPhone Fold (referências 15 e 16 do dono): a barra de baixo dá lugar à barra direita. Fechado (15): voltar e
           anterior/seguinte em cima; apagar, mover e responder numa pílula em baixo e o Escrever à parte. O responder abre o menu do
           email (responder, reencaminhar, bandeira, arquivar), como no sistema. Aberto (16, a lista ao lado): o Escrever da lista e
           logo por baixo a pílula do email (responder, reencaminhar, bandeira, apagar, mover). Anterior/seguinte trocam o email no
           sítio (UI.replace). */
        const sib = d => { const L = ctx && ctx.items ? ctx.items() : []; let i = L.findIndex(x => x.id === m.id); if (i < 0) return null; i += d; while (L[i] && L[i].folder === 'drafts') i += d; return L[i] || null; };
        const go = d => { const n = sib(d); if (n) openMail(n, ctx, true); };
        const doDel = async () => { if (await act(m, 'delete')) { syncAll(m); UI.pop(win); } };
        const doMove = async () => { if (await act(m, 'move')) { syncAll(m); UI.pop(win); } };
        const reMenu = () => UI.ctxMenu(null, [{ label: 'Responder', icon: 'reply', onTap: () => compose({ reply: m }) }, { label: 'Reencaminhar', icon: 'forward', onTap: () => compose({ forward: m }) },
          { label: m.flagged ? 'Remover bandeira' : 'Assinalar com bandeira', icon: 'flag', onTap: doFlag }, { label: restore() ? 'Restaurar' : 'Arquivar', icon: restore() ? 'mail' : 'storage', onTap: doArchive }]);
        v.rail = (auto, role) => {
          const it = (icon, label, onTap, x) => Object.assign({ icon, label, onTap }, x || {});
          const re = it('reply', 'Responder', () => compose({ reply: m })), fw = it('forward', 'Reencaminhar', () => compose({ forward: m }));
          const fl = it('flag', m.flagged ? 'Remover bandeira' : 'Assinalar com bandeira', doFlag, { active: !!m.flagged });
          const del = it('trash', m.folder === 'trash' ? 'Apagar definitivamente' : 'Apagar', doDel), mv = it('folder', 'Mover para…', doMove);
          if (role === 'detail') return { back: auto.back, groups: [[re, fw, fl, del, mv]], primary: [] };
          return { back: auto.back, groups: [[it('chevU', 'Email anterior', () => go(-1), { disabled: !sib(-1) }), it('chevD', 'Email seguinte', () => go(1), { disabled: !sib(1) })]],
            primary: [[del, mv, it('reply', 'Responder e mais', reMenu)], [it('compose', 'Novo email', () => compose())]] };
        };
        /* sair do email (voltar, gesto, matar a app): o áudio cala-se e o visualizador de foto aberto sai com ele
           (vive na janela, por cima de tudo, e ficava a tapar a lista) */
        v.opts.onPop = () => { (v._audios || []).forEach(au => { try { au.pause(); au.removeAttribute('src'); } catch (e) {} }); v._audios = []; const vw = win.querySelectorAll(':scope > .viewer'); vw.forEach(x => x.remove()); if (vw.length && UI.railFor) UI.railFor(win, null); };
        v.appendChild(bar); if (swap && UI.replace) UI.replace(win, v); else UI.push(win, v);
        return v;
      }

      /* ---------- Email aberto (Nova UI): assunto grande, remetente em cartão, corpo, anexos e barra de ações em baixo ---------- */
      function openMailA(m) {
        if (!m.read && m.folder !== 'drafts') {
          m.read = true; syncAll(m);
          Bridge.rpcRaw('mail.read', { id: m.id }).then(r => { if (failed(r)) { m.read = false; syncAll(m); } mailBadge(); });
        }
        let flagBtn = null;
        const v = UI.view({ title: '', back: FOLDERS[m.folder] || App.name('mail'), full: true, cls: 'amail-rv', right: [
          { icon: 'flag', ref: b => { flagBtn = b; }, onTap: async () => { if (await act(m, 'flag')) { paintFlag(); syncAll(m); UI.toast(m.flagged ? 'Marcado com bandeira' : 'Bandeira removida'); } } },
          { icon: 'trash', onTap: async () => { if (await act(m, 'delete')) { syncAll(m); UI.pop(win); } } }] });
        const out = mine(m);
        const head = UI.el(`<div class="amail-rh"><div class="amail-rsubj"></div><div class="amail-from"><div class="amail-fav"></div><div class="amail-fw"><b></b><span></span><em></em></div><div class="amail-fd"></div></div></div>`);
        head.querySelector('.amail-rsubj').textContent = m.subject || '(sem assunto)';
        head.querySelector('.amail-fav').appendChild(avA(out ? (m.recipient || m.email || 'Eu') : (m.sender || '?'), 'lg'));
        head.querySelector('.amail-fw b').textContent = mine(m) ? L.t('Eu') : (m.sender || '');
        head.querySelector('.amail-fw span').textContent = m.email || '';
        const toEl = head.querySelector('.amail-fw em'); if (m.recipient && m.recipient !== m.email) toEl.textContent = 'Para: ' + m.recipient; else toEl.remove();
        const d = new Date(+m.created); head.querySelector('.amail-fd').textContent = UI.fmtDate(d, true) + '\n' + UI.fmtTime(d);
        v.content.appendChild(head);
        const bodyEl = UI.el('<div class="amail-body"></div>'); bodyEl.textContent = m.body || ''; v.content.appendChild(bodyEl);
        const atts = attsOf(m);
        if (atts.length) {
          const box = UI.el(`<div class="amail-atts"><div class="amail-atth">${g('paperclip', 16)}<span></span></div></div>`);
          box.querySelector('span').textContent = atts.length === 1 ? '1 anexo' : atts.length + ' anexos';
          atts.forEach((a, i) => { const c = attCard(m, a, i + 1, v); if (c) box.appendChild(c); });
          v.content.appendChild(box);
        }
        const restore = () => (m.folder === 'archive' || m.folder === 'trash');
        const bar = UI.el(`<div class="amail-bar"><div class="amail-ba re">${g('reply', 22)}<span>Responder</span></div><div class="amail-ba fw">${g('forward', 22)}<span>Reencaminhar</span></div><div class="amail-ba ar">${g(restore() ? 'mail' : 'storage', 22)}<span>${restore() ? 'Restaurar' : 'Arquivar'}</span></div><div class="amail-ba del">${g('trash', 22)}<span>Eliminar</span></div></div>`);
        const paintFlag = () => { if (flagBtn) flagBtn.classList.toggle('amail-on', !!m.flagged); head.classList.toggle('flagged', !!m.flagged); };
        bar.querySelector('.re').onclick = () => compose({ reply: m });
        bar.querySelector('.fw').onclick = () => compose({ forward: m });
        bar.querySelector('.ar').onclick = async () => { const r = restore() ? await act(m, 'move', mine(m) ? 'sent' : 'inbox') : await act(m, 'archive'); if (r) { syncAll(m); UI.pop(win); } };
        bar.querySelector('.del').onclick = async () => { if (await act(m, 'delete')) { syncAll(m); UI.pop(win); } };
        paintFlag();
        v.opts.onPop = () => { (v._audios || []).forEach(au => { try { au.pause(); au.removeAttribute('src'); } catch (e) {} }); v._audios = []; win.querySelectorAll(':scope > .viewer').forEach(x => x.remove()); };
        v.appendChild(bar); UI.push(win, v);
        return v;
      }
      /* ---------- Gaveta das pastas (Nova UI): conta, Escrever e as caixas com contagens ---------- */
      function drawer(cur) {
        const acc = System.account || {};
        const body = UI.el(`<div class="amail-dr"><div class="amail-dh"><div class="amail-dav"></div><div class="amail-dtx"><b></b><span></span></div></div><div class="amail-dw">${g('pen', 20)}<span>Escrever</span></div><div class="amail-dl"></div></div>`);
        body.querySelector('.amail-dav').appendChild(avA(acc.username || 'Eu', 'lg'));
        body.querySelector('.amail-dtx b').textContent = acc.username || 'Eu';
        body.querySelector('.amail-dtx span').textContent = acc.phone ? UI.phone(acc.phone) : App.name('mail');
        let sh = null;
        body.querySelector('.amail-dw').onclick = () => { sh.close(); setTimeout(() => compose(), 120); };
        const list = body.querySelector('.amail-dl');
        const paint = c => { list.innerHTML = ''; const tot = (c && c.total) || {}, un = (c && c.unread) || {};
          ORDER.concat(['flagged']).forEach(fd => { const n = fd === 'inbox' ? (un.inbox || '') : fd === 'flagged' ? ((c && c.flagged) || '') : (tot[fd] || '');
            const r = UI.el(`<div class="amail-df${fd === cur ? ' on' : ''}">${g(FICON[fd] || 'mail', 22)}<span></span><em></em></div>`); r.querySelector('span').textContent = titleOf(fd); r.querySelector('em').textContent = n;
            r.onclick = () => { sh.close(); if (fd !== cur || UI.depth(win) > 1) UI.setRoot(win, folderView(fd)); }; list.appendChild(r); }); };
        paint({});
        sh = UI.sheet({ title: '', right: '', cls: 'amail-drawer', body });
        Bridge.rpcRaw('mail.counts').then(r => { if (!failed(r) && list.isConnected) paint(r); }, () => {});
      }

      /* ---------- Compor (novo, responder, reencaminhar, continuar rascunho) ---------- */
      function compose(o = {}) {
        const re = o.reply, fw = o.forward, dr = o.draft;
        let draftId = dr ? dr.id : null;
        let to = '', subj = '', body0 = '';
        if (dr) { to = dr.email || dr.recipient || ''; subj = dr.subject || ''; body0 = dr.body || ''; }
        /* responder a um email RECEBIDO vai para quem o mandou: o `recipient` desse email é o próprio jogador
           (sem número do remetente, "Para:" ficava com o endereço de quem responde); só num enviado é o destino */
        else if (re) { to = mine(re) ? (re.email || re.recipient || '') : (re.email || (/^@[\w.]{3,32}$/.test(re.sender || '') ? re.sender : '')); subj = /^re:/i.test(re.subject || '') ? re.subject : 'Re: ' + (re.subject || ''); }
        else if (fw) { subj = /^fwd?:/i.test(fw.subject || '') ? fw.subject : 'Fwd: ' + (fw.subject || ''); body0 = '\n\n---------- Mensagem reencaminhada ----------\nDe: ' + fw.sender + '\n\n' + (fw.body || ''); }
        if (o.to != null) to = String(o.to);
        if (o.subject != null) subj = String(o.subject);
        if (o.body != null) body0 = String(o.body);
        /* cada anexo: { att (o que vai para o servidor), photo (linha da galeria, para a miniatura), src ({ id, index } do email onde já está) } */
        const items = [];
        const from = dr || fw;
        if (from) attsOf(from).forEach((a, i) => items.push({ att: a, src: { id: from.id, index: i + 1 } }));
        /* um vídeo partilhado a partir das Fotos não entra (o servidor recusa-o no envio): avisa-se já, não ao enviar */
        if (o.photo && o.photo.id != null) { if (o.photo.video) setTimeout(() => UI.toast('Os vídeos não podem ser anexados'), 350); else items.push({ att: { type: 'photo', id: o.photo.id }, photo: o.photo }); }
        (Array.isArray(o.attachments) ? o.attachments : []).forEach(a => { if (a && typeof a === 'object' && typeof a.type === 'string') items.push({ att: a }); });

        /* Nova UI: campos em linha (Para, Assunto), anexos em fichas, corpo livre e "Anexar" em pílula; os mesmos ganchos (.to .sj .bd .mc-atts .mc-n .mc-clip) */
        const body = A ? UI.el(`<div class="amail-cmp"><div class="amail-cf"><span>Para</span><input type="text" class="to" maxlength="96" placeholder="email, número ou @utilizador"></div><div class="amail-cf"><span>Assunto</span><input type="text" class="sj" maxlength="160"></div><div class="mc-atts amail-catts"></div><textarea class="bd amail-cbd" maxlength="4000" placeholder="Escreve a mensagem"></textarea><div class="amail-ctools"><div class="mc-clip amail-clip">${g('paperclip', 18)}<span>Anexar</span></div><span class="mc-n amail-cn"></span></div></div>`)
          : UI.el(`<div class="mail-compose"><div class="group"><div class="li static"><span class="muted mc-k">Para:</span><input type="text" class="to" maxlength="96" placeholder="email, número ou @utilizador"></div><div class="li static"><span class="muted mc-k">Assunto:</span><input type="text" class="sj" maxlength="160"></div></div><div class="mc-atts"></div><div class="group mc-bodyg"><textarea class="ta bd" maxlength="4000" placeholder="Escreve a mensagem…"></textarea><div class="mc-tools"><div class="mc-clip">${g('paperclip')}<span>Anexar</span></div><span class="muted small mc-n"></span></div></div></div>`);
        const toI = body.querySelector('.to'), sjI = body.querySelector('.sj'), bdI = body.querySelector('.bd'), attsEl = body.querySelector('.mc-atts'), nEl = body.querySelector('.mc-n');
        toI.value = to; sjI.value = subj; bdI.value = body0;
        const payload = () => items.map(it => Object.assign({}, it.att));
        const snap = () => JSON.stringify([toI.value.trim(), sjI.value.trim(), bdI.value.trim(), items.map(it => JSON.stringify(it.att))]);
        const hasContent = () => !!(toI.value.trim() || sjI.value.trim() || bdI.value.trim() || items.length);

        function thumb(it, th) {
          const a = it.att;
          if (it.photo && window.Photos && Photos.bg) {
            th.style.backgroundImage = Photos.bg(it.photo);
            if (!it.photo.url && it.photo.len && Photos.data) Photos.data(it.photo, true).then(u => { if (u) th.style.backgroundImage = Photos.bg(it.photo); });
          } else if (a.url) th.style.backgroundImage = UI.img(a.url);
          else if (a.mediaId && it.src) attData(it.src.id, it.src.index, a).then(u => { if (u) th.style.backgroundImage = UI.img(u); });
          else if (a.seed != null) th.style.backgroundImage = UI.img(+a.seed || 1);
        }
        function paintAtts() {
          attsEl.innerHTML = '';
          attsEl.classList.toggle('mc-none', !items.length);
          nEl.textContent = items.length ? `${items.length}/${maxAtt()}` : '';
          items.forEach((it, i) => {
            const a = it.att;
            const chip = UI.el(`<div class="${A ? 'amail-chip' : 'mc-chip'}"><div class="mc-th"></div><div class="mc-tx"><b></b><span></span></div><div class="mc-rm">${g('x')}</div></div>`);
            const th = chip.querySelector('.mc-th'), b = chip.querySelector('b'), sp = chip.querySelector('.mc-tx span');
            if (isImage(a)) { b.textContent = 'Foto'; sp.textContent = a.size ? kb(a.size) : 'Imagem'; thumb(it, th); }
            else if (a.type === 'location') { th.innerHTML = g('pin'); b.textContent = a.label || 'Localização'; sp.textContent = `${Math.round(+a.x)}, ${Math.round(+a.y)}`; }
            else if (a.type === 'contact') { th.innerHTML = g('personCircle'); b.textContent = a.name || 'Contacto'; sp.textContent = a.number || ''; }
            else { th.innerHTML = g(a.kind === 'audio' ? 'mic' : 'paperclip'); b.textContent = a.kind === 'audio' ? 'Áudio' : 'Anexo'; }
            chip.querySelector('.mc-rm').onclick = e => { e.stopPropagation(); items.splice(i, 1); paintAtts(); };
            attsEl.appendChild(chip);
          });
        }
        const add = it => { if (items.length >= maxAtt()) { UI.toast(`No máximo ${maxAtt()} anexos por email`); return; } items.push(it); paintAtts(); };
        body.querySelector('.mc-clip').onclick = async () => {
          if (items.length >= maxAtt()) { UI.toast(`No máximo ${maxAtt()} anexos por email`); return; }
          const k = await UI.actionSheet({ title: 'Anexar', buttons: [{ label: 'Foto da galeria', icon: 'photo', value: 'photo' }, { label: 'Localização atual', icon: 'nav', value: 'loc' }, { label: 'Contacto', icon: 'personCircle', value: 'ct' }] });
          if (k === 'photo') {
            if (!window.Photos || !Photos.pick) { UI.toast('Fotos indisponíveis'); return; }
            const p = await Photos.pick('Anexar foto'); if (!p) return;
            if (p.video) { UI.toast('Os vídeos não podem ser anexados'); return; }
            if (p.id == null) { UI.toast('Esta foto não pode ser anexada'); return; }
            add({ att: { type: 'photo', id: p.id }, photo: p });
          } else if (k === 'loc') {
            /* a posição do jogador é dado pessoal: passa pela mesma autorização das outras apps */
            if (window.Perm && Perm.request && !(await Perm.request('mail', 'location'))) return;
            const c = await Bridge.call('getCoords');
            if (!c || !isFinite(+c.x) || !isFinite(+c.y)) { UI.toast('Sem localização'); return; }
            const label = await UI.prompt('Localização', 'Nome a mostrar no email', 'A minha localização', 'A minha localização');
            if (label === null) return;
            add({ att: { type: 'location', x: +c.x, y: +c.y, label: (label || 'A minha localização').slice(0, 64) } });
          } else if (k === 'ct') {
            if (!window.Contacts || !Contacts.pick) { UI.toast('Contactos indisponíveis'); return; }
            const c = await Contacts.pick('Anexar contacto'); if (!c) return;
            add({ att: { type: 'contact', name: String(c.name || c.number).slice(0, 64), number: String(c.number || '').slice(0, 20) } });
          }
        };
        paintAtts();
        const initial = snap();
        /* um rascunho reaberto ou uma resposta sem nada escrito fecham sem perguntar; o que outra app preencheu
           (MailApp.compose com texto/anexos) conta como escrito - fechar sem perguntar deitava-o fora */
        const external = !dr && (o.to != null || o.subject != null || o.body != null || !!o.photo || (Array.isArray(o.attachments) && o.attachments.length > 0));
        const dirty = () => external || snap() !== initial;

        let sending = false, finished = false, closed = false, savingP = null;
        /* Uma gravação de cada vez: tocar "Guardar rascunho" e guardar o telemóvel antes da resposta chamava isto
           duas vezes sem draftId e ficavam DOIS rascunhos iguais. O segundo pedido espera pelo primeiro. */
        function saveDraft(silent) {
          if (savingP) return savingP;
          savingP = doSaveDraft(silent).finally(() => { savingP = null; });
          return savingP;
        }
        async function doSaveDraft(silent) {
          const asSent = items.slice();   /* os anexos tal como foram no pedido (pode tirar-se/pôr-se um chip durante a espera) */
          let r = null; try { r = await Bridge.rpcRaw('mail.saveDraft', { id: draftId || undefined, to: toI.value.trim(), subject: sjI.value.trim(), body: bdI.value, attachments: payload() }); } catch (e) { r = null; }
          if (failed(r)) {
            Sound.play('error');
            if (silent) UI.toast('Rascunho não guardado: ' + errMsg(r)); else UI.alert({ title: 'Não foi possível guardar o rascunho', msg: errMsg(r) });
            return false;
          }
          draftId = r.id;
          /* o servidor devolve os anexos já limpos (a foto da galeria passa a ser uma cópia com mediaId): a
             próxima gravação reutiliza a cópia em vez de copiar outra vez */
          /* só se a lista não mudou entretanto: com um chip trocado o anexo limpo ia parar ao chip errado */
          const clean = Array.isArray(r.attachments) ? r.attachments : [];
          if (clean.length === asSent.length && items.length === asSent.length && asSent.every((it, i) => items[i] === it)) clean.forEach((a, i) => { asSent[i].att = a; asSent[i].src = { id: r.id, index: i + 1 }; });
          UI.toast('Guardado em Rascunhos');
          reloadAll();
          return true;
        }
        const send = () => {
          if (sending) return false;
          const t = toI.value.trim(), s = sjI.value.trim(), b = bdI.value.trim();
          if (!t) { UI.alert({ title: 'Destinatário em falta' }); return false; }
          /* modo de voo (CC.requireNet, shell/control.js): a folha fica aberta com tudo o que se escreveu e, se o
             telemóvel for guardado, o onClose grava o rascunho como sempre. Ler o correio não passa por aqui. */
          if (window.CC && CC.requireNet && !CC.requireNet('enviar o email')) return false;
          sending = true; rBtn.textContent = 'A enviar…'; sh.el.classList.add('mc-busy');
          /* com um rascunho a gravar, espera-se pelo id dele: enviar sem draftId deixava esse rascunho para trás */
          /* o servidor diz se entregou: `delivered` false = só ficou em Enviados (o destinatário não é número nem @utilizador de ninguém) */
          Promise.resolve(savingP).catch(() => null).then(() => Bridge.rpcRaw('mail.send', { to: t, subject: s || '(sem assunto)', body: b, attachments: payload(), draftId: draftId || undefined })).catch(() => null).then(r => {
            sending = false; rBtn.textContent = 'Enviar'; sh.el.classList.remove('mc-busy');
            if (failed(r)) {
              Sound.play('error');
              /* a folha continua aberta com tudo o que se escreveu; se entretanto fechou (telemóvel guardado), fica em Rascunhos */
              if (closed) saveDraft(true); else UI.alert({ title: 'Não foi possível enviar', msg: errMsg(r) });
              return;
            }
            finished = true; sh.close();
            Sound.play('send');
            UI.banner({ app: 'mail', title: r.delivered === false ? 'Guardado em Enviados' : 'Mensagem enviada', msg: r.delivered === false ? 'O destinatário não é um jogador (número ou @utilizador).' : (s || t) });
            reloadAll();
          });
          return false;   /* a folha só fecha com a resposta: um erro já não deita fora o email */
        };
        const askCancel = async () => {
          if (sending) return;
          if (!hasContent() || !dirty()) { finished = true; sh.close(); return; }
          const k = await UI.actionSheet({ buttons: [{ label: 'Guardar rascunho', bold: true, value: 'save' }, { label: 'Apagar', danger: true, value: 'discard' }] });
          if (k === 'save') { if (await saveDraft(false)) { finished = true; sh.close(); } }
          else if (k === 'discard') {
            finished = true; sh.close();
            /* apagar um rascunho que já existia manda-o para o Lixo (recupera-se de lá), como o PearOS */
            if (draftId) { const r = await Bridge.rpcRaw('mail.delete', { id: draftId }); if (failed(r)) UI.toast(errMsg(r)); reloadAll(); }
          }
        };
        const sh = UI.sheet({
          title: re ? 'Responder' : fw ? 'Reencaminhar' : dr ? 'Rascunho' : 'Nova mensagem', left: 'Cancelar', right: 'Enviar', body, onDone: send, cls: A ? 'amail-cw' : '',
          /* arrastar para baixo, tocar fora ou guardar o telemóvel: o que se escreveu vai para Rascunhos */
          onClose: () => { closed = true; if (!finished && !sending && hasContent() && dirty()) saveDraft(true); },
        });
        const rBtn = sh.el.querySelector('.sh-r');
        /* o Cancelar e o toque fora da folha passam a perguntar (o UI.sheet fechava logo e perdia tudo) */
        sh.el.querySelector('.sh-l').onclick = askCancel;
        sh.el.onclick = e => { if (e.target === sh.el) askCancel(); };
        return sh;
      }

      /* ---------- Caixas de correio ---------- */
      const boxes = () => {
        const v = UI.view({ title: 'Caixas de correio', large: true, right: [{ icon: 'compose', onTap: () => compose() }] });
        v._counts = true;
        const holder = UI.el('<div></div>'); v.content.appendChild(holder);
        const paint = c => {
          holder.innerHTML = '';
          const tot = (c && c.total) || {}, un = (c && c.unread) || {};
          holder.appendChild(UI.list([
            { items: ORDER.map(f => ({ icon: FICON[f], iconBg: 'var(--blue)', label: FOLDERS[f], value: f === 'inbox' ? (un.inbox || '') : (tot[f] || ''), onTap: () => UI.push(win, folderView(f)) })) },
            { items: [{ icon: 'flag', iconBg: 'var(--orange)', label: 'Assinalados', value: (c && c.flagged) || '', onTap: () => UI.push(win, folderView('flagged')) }] },
          ]));
          if (c === null) holder.appendChild(UI.el('<div class="group-footer">Não foi possível obter as contagens.</div>'));
        };
        v.render = () => Bridge.rpcRaw('mail.counts').then(r => paint(failed(r) ? null : r), () => paint(null));
        paint({}); v.render();
        return v;
      };

      /* Nova UI: sem separadores (as pastas estão na gaveta); PearOS: Entrada · Caixas. Nos dois, o dobrável aberto mostra a caixa à
         esquerda e o email escolhido à direita (ui.js UI.split) */
      if (A) { UI.setRoot(win, folderView('inbox')); UI.split(win, { icon: 'mail', title: 'Nenhum email aberto', sub: 'Escolhe um email da lista para o leres aqui.', row: '.amail-row' }); }
      else {
        UI.tabbar(win, [{ icon: 'mail', label: 'Entrada', view: () => folderView('inbox') }, { icon: 'list', label: 'Caixas', view: boxes }], 0);
        /* PearPhone Fold aberto: a caixa à esquerda, o email escolhido à direita (ui.js UI.split). Como no Duo (referência 16), a
           coluna da direita nunca abre vazia: abre logo o primeiro email da caixa (first) */
        UI.split(win, { icon: 'mail', title: 'Nenhum email aberto', sub: 'Escolhe um email da lista para o leres aqui.', first: '.mail-row' });
      }

      /* email novo com a janela aberta: entra no topo da caixa (sem recarregar) e as Caixas voltam a contar */
      const offMail = Bridge.on('mail', m => {
        stackViews().forEach(v => { try { if (v._incoming) v._incoming(m); else if (v._counts) v.render(); } catch (e) { console.error('[apex_phone] mail push', e); } });
        mailBadge();
      });
      win.onClose = () => offMail();

      const openById = id => {
        id = +id; if (!(id > 0)) return;
        Bridge.rpcRaw('mail.get', { id }).then(m => {
          if (failed(m) || m.id == null) { UI.toast(errMsg(m)); return; }
          if (m.folder === 'drafts') compose({ draft: m }); else openMail(m);
        });
      };
      const consume = () => { if (!pendingOpen) return; const id = pendingOpen; pendingOpen = null; openById(id); };
      /* Voltar (Nova UI): numa pasta que não é a Caixa de entrada, regressa a ela antes de fechar a app */
      const backA = () => { if (!A) return false;
        /* o visualizador de um anexo vive na janela (fora da pilha): o Voltar fecha-o primeiro, o email fica aberto */
        const vw = win.querySelector(':scope > .viewer'); if (vw) { vw.remove(); return true; }
        if (UI.depth(win) > 1) return false; const r = win.querySelector('.nav-stack > .view'); if (r && r._folder && r._folder !== 'inbox') { UI.setRoot(win, folderView('inbox')); return true; } return false; };
      win._mail = { compose, openMail, openById, consume, reload: reloadAll, back: backA };
      setTimeout(consume, 0);
    },
    resume(win) { if (win._mail) win._mail.consume(); },
  });

  /* ---------- API para outras apps ----------
     MailApp.compose({ to, subject, body, photo (linha da galeria), attachments }) abre o Mail e a folha de compor;
     MailApp.open(id) abre um email. Ex.: a partilha de uma foto nas Fotos. */
  const withWin = fn => {
    const run = () => { const w = System.windows && System.windows.mail; if (w && w._mail) fn(w._mail); };
    if (System.currentApp() === 'mail' && System.windows && System.windows.mail) { run(); return; }
    let t = null;
    const off = Bridge.on('app:open', id => { if (id !== 'mail') return; off(); clearTimeout(t); setTimeout(run, 60); });
    t = setTimeout(off, 30000);
    System.openApp('mail');
  };
  window.MailApp = { compose: o => withWin(api => api.compose(o || {})), open: id => withWin(api => api.openById(id)) };

  /* Notificação do servidor (NotifyCitizen, data.mailId) tocada: o Notify emite notif:open e abre a app; fica
     pendente e a janela abre esse email quando estiver pronta (open/resume). Com o Mail já à frente o openApp
     não faz nada, por isso abre-se aqui. */
  Bridge.on('notif:open', n => {
    if (!n || n.app !== 'mail' || !n.data) return;
    const id = +n.data.mailId; if (!(id > 0)) return;
    pendingOpen = id;
    const w = System.windows && System.windows.mail;
    if (System.currentApp() === 'mail' && w && w._mail) setTimeout(() => w._mail.consume(), 0);
  });
  /* push 'mail': o servidor novo manda `notified` (a notificação persistente já saiu por NotifyCitizen) e aqui
     não se cria outra; sem o campo (servidor antigo) - ou com ele a FALSE, que é o servidor a dizer que não avisou -
     a notificação continua a ser local, como sempre foi.
     ⚠️ O server/mail.lua escreve `m.notified = NotifyCitizen ~= nil` ANTES de chamar o NotifyCitizen, por isso um aviso
     deitado fora pelo travão das notificações (server/main.lua: 4 por app+título em 60 s, e o título é o remetente)
     chega aqui como `notified = true` e o jogador fica sem banner nenhum - o email está na caixa e conta no emblema,
     mas ninguém o anuncia. Não se inventa aqui um aviso local nesse caso: seria desfazer o anti-spam que o servidor
     acabou de aplicar. Para o banner voltar, é o mail.lua que tem de mandar o `notified` verdadeiro (pedidosCruzados);
     a NUI já está pronta para o ler - `false` volta a avisar. */
  Bridge.on('mail', m => {
    if (!m) return;
    if (!m.notified) Notify.push({ app: 'mail', title: m.sender || 'Mail', msg: m.subject || '', onTap: () => (m.id != null ? MailApp.open(m.id) : System.openApp('mail')) });
    if (!(System.windows && System.windows.mail)) mailBadge();
  });
  Bridge.on('ready', () => setTimeout(mailBadge, 700));
  /* troca de personagem: as imagens dos anexos da anterior não ficam em memória nem um email pendente por abrir */
  Bridge.on('session:changed', () => { attCache.clear(); pendingOpen = null; });

  /* ---------- Mocks do browser (LocalDB) - o mesmo contrato do server/mail.lua ----------
     Diferenças conscientes: não há outro jogador (delivered é sempre false), as cópias das fotos vivem na
     tabela 'mailmedia' do mock (a media das Mensagens, tabela 'media', também se pode anexar), a media não é
     verificada por dono e um link de imagem não passa pela verificação de posse do servidor. */
  if (window.LocalDB && LocalDB.register) (() => {
    const T = () => LocalDB.T('mail'), MT = () => LocalDB.T('mailmedia'), now = () => Date.now();
    const FOLD = ORDER, MAXA = maxAtt(), DRAFTS = 50, CH = 48000;
    const str = (v, n) => (typeof v === 'string' || typeof v === 'number') ? String(v).slice(0, n) : '';
    const one = (v, n) => [...str(v, 400)].map(ch => (ch.charCodeAt(0) < 32 || ch.charCodeAt(0) === 127) ? ' ' : ch).join('').trim().slice(0, n);   // sem caracteres de controlo, como o line() do servidor
    const out = m => Object.assign({}, m, { read: !!m.read, flagged: !!m.flagged, recipient: m.recipient == null ? null : m.recipient,
      attachments: Array.isArray(m.attachments) && m.attachments.length ? m.attachments : null });
    const find = id => T().all().find(x => x.id === +id);
    /* media anexável: as cópias do Mail (mailmedia) ou a media completa das Mensagens (tabela 'media' do mock do
       messages.js, a mesma que o media.get do mock serve) - no servidor as duas são a mesma tabela */
    const mediaRow = mid => MT().all().find(x => x.id === mid) || LocalDB.T('media').all().find(x => x.id === mid && x.complete);
    const mediaIds = l => (Array.isArray(l) ? l : []).map(a => a && +a.mediaId).filter(Boolean);
    const dropOrphans = ids => ids.forEach(mid => { if (!T().all().some(m => mediaIds(m.attachments).includes(mid))) MT().remove(r => r.id === mid && r.src === 'mail'); });
    const clean = (list, made) => {
      if (list == null) return { atts: null };
      if (!Array.isArray(list)) return { error: 'type', index: 0 };
      if (!list.length) return { atts: null };
      if (list.length > MAXA) return { error: 'toomany', index: list.length };
      const res = [];
      for (let i = 0; i < list.length; i++) {
        const a = list[i], k = i + 1;
        if (!a || typeof a !== 'object') return { error: 'type', index: k };
        if (a.type === 'photo') {
          const mid = Math.floor(+a.mediaId) || 0, pid = Math.floor(+(a.id != null ? a.id : a.photoId)) || 0;
          if (mid) { const r = mediaRow(mid); if (!r || r.kind !== 'image') return { error: 'photo', index: k }; res.push({ type: 'photo', mediaId: mid, mime: r.mime, size: r.size }); }
          else if (pid) {
            const p = LocalDB.T('photos').all().find(x => x.id === pid);
            if (!p) return { error: 'photo', index: k };
            if (p.video) return { error: 'video', index: k };
            if (typeof p.url === 'string' && /^https?:\/\//.test(p.url)) res.push({ type: 'photo', url: p.url });
            else if (typeof p.url === 'string' && /^data:image\//.test(p.url)) {
              const mime = (/^data:(image\/(?:jpeg|png|webp));base64,/.exec(p.url) || [])[1];   /* a lista branca do server/media.lua */
              if (!mime) return { error: 'photo', index: k };
              if (p.url.length > 260000) return { error: 'toolarge', index: k };
              /* como o servidor: a mesma foto já copiada reutiliza a cópia (e só uma cópia NOVA sai se o email falhar) */
              const prev = MT().all().find(x => x.src === 'mail' && x.photo === pid);
              if (prev) res.push({ type: 'photo', mediaId: prev.id, mime: prev.mime, size: prev.size });
              else {
                const r = MT().insert({ owner: 'DEV0000', kind: 'image', mime, data: p.url, size: p.url.length, complete: true, src: 'mail', photo: pid, created: now() });
                made.push(r.id); res.push({ type: 'photo', mediaId: r.id, mime, size: p.url.length });
              }
            } else if (p.seed != null) res.push({ type: 'photo', seed: Math.floor(+p.seed) || 1 });
            else return { error: 'photo', index: k };
          } else if (typeof a.url === 'string' && /^https?:\/\//.test(a.url) && a.url.length <= 512) res.push({ type: 'photo', url: a.url });
          else if (a.seed != null && isFinite(+a.seed)) res.push({ type: 'photo', seed: Math.floor(+a.seed) });
          else return { error: 'photo', index: k };
        } else if (a.type === 'location') {
          const x = +a.x, y = +a.y;
          if (!isFinite(x) || !isFinite(y) || Math.abs(x) > 20000 || Math.abs(y) > 20000) return { error: 'location', index: k };
          res.push({ type: 'location', x: Math.round(x * 100) / 100, y: Math.round(y * 100) / 100, label: one(a.label, 64) || 'Localização' });
        } else if (a.type === 'contact') {
          const name = one(a.name, 64), number = one(a.number, 20);
          if (!name || !/^[\d+\-\s()]+$/.test(number) || !/\d/.test(number)) return { error: 'contact', index: k };
          res.push({ type: 'contact', name, number });
        } else if (a.type === 'media') {
          const mid = Math.floor(+a.mediaId) || 0, r = mid && mediaRow(mid);
          if (!r || (r.kind !== 'image' && r.kind !== 'audio')) return { error: 'media', index: k };
          res.push({ type: 'media', mediaId: mid, kind: r.kind, mime: r.mime, size: r.size, duration: r.duration || null });
        } else return { error: 'type', index: k };
      }
      return { atts: res };
    };
    const cleanOrFail = list => { const made = []; const c = clean(list, made); if (c.error) { MT().remove(r => made.includes(r.id)); return { fail: { ok: false, error: 'attachments', reason: c.error, index: c.index, max: MAXA } }; } return c; };
    /* ordem do servidor: created DESC, id DESC; `before` = id do último email mostrado */
    const byDate = (a, b) => (b.created - a.created) || (b.id - a.id);

    LocalDB.register('mail.list', d => {
      const all = T().all();
      if (!d.folder && d.flagged !== true) return all.sort((a, b) => b.created - a.created).slice(0, 200).map(out);
      if (d.folder && !FOLD.includes(d.folder)) return { error: 'folder' };
      const lim = Math.max(1, Math.min(100, Math.floor(+d.limit) || 30)), before = Math.floor(+d.before) || 0;
      const q = one(d.q, 64).toLowerCase(), ref = before ? all.find(x => x.id === before) : null;
      return all.filter(m => (d.folder ? m.folder === d.folder : m.folder !== 'trash') && (d.flagged !== true || m.flagged)
          && (!before || (ref ? (m.created < ref.created || (m.created === ref.created && m.id < ref.id)) : m.id < before))
          && (!q || [m.subject, m.sender, m.email, m.recipient, m.body].some(s => String(s || '').toLowerCase().includes(q))))
        .sort(byDate).slice(0, lim).map(out);
    });
    LocalDB.register('mail.unread', () => ({ unread: T().all().filter(m => m.folder === 'inbox' && !m.read).length }));
    LocalDB.register('mail.counts', () => {
      const total = {}, unread = {}; let flagged = 0;
      FOLD.forEach(f => { total[f] = 0; unread[f] = 0; });
      T().all().forEach(m => { if (!FOLD.includes(m.folder)) return; total[m.folder]++; if (!m.read) unread[m.folder]++; if (m.flagged && m.folder !== 'trash') flagged++; });
      return { total, unread, flagged };
    });
    LocalDB.register('mail.get', d => { const m = find(d.id); return m ? out(m) : { error: 'notfound' }; });
    /* { id, ok, delivered, attachments } como o servidor; no browser não há outro jogador, por isso nunca é entregue */
    LocalDB.register('mail.send', d => {
      const to = str(d.to, 400).trim().slice(0, 96);
      if (!to) return { ok: false, error: 'target' };
      const c = cleanOrFail(d.attachments); if (c.fail) return c.fail;
      const r = T().insert({ owner: 'DEV0000', sender: 'Eu', email: to, recipient: to.slice(0, 64), subject: str(d.subject, 160) || '(sem assunto)', body: str(d.body, 4000), read: true, flagged: false, attachments: c.atts, folder: 'sent', created: now() });
      const dr = +d.draftId && T().all().find(x => x.id === +d.draftId && x.folder === 'drafts');
      if (dr) { T().remove(dr.id); dropOrphans(mediaIds(dr.attachments)); }
      return { id: r.id, ok: true, delivered: false, attachments: c.atts };
    });
    LocalDB.register('mail.saveDraft', d => {
      const ex = +d.id ? T().all().find(x => x.id === +d.id && x.folder === 'drafts') : null;
      if (!ex && T().all().filter(x => x.folder === 'drafts').length >= DRAFTS) return { ok: false, error: 'draftsfull', max: DRAFTS };
      const c = cleanOrFail(d.attachments); if (c.fail) return c.fail;
      const to = str(d.to, 400).trim().slice(0, 96), subject = str(d.subject, 160), body = str(d.body, 4000);
      if (!to && !subject.trim() && !body.trim() && !c.atts) return { ok: false, error: 'empty' };
      const created = now();
      if (ex) {
        const old = mediaIds(ex.attachments);
        T().update(ex.id, { email: to, recipient: to.slice(0, 64), subject, body, attachments: c.atts, created });
        dropOrphans(old);
        return { ok: true, id: ex.id, attachments: c.atts, created };
      }
      const r = T().insert({ owner: 'DEV0000', sender: 'Eu', email: to, recipient: to.slice(0, 64), subject, body, read: true, flagged: false, attachments: c.atts, folder: 'drafts', created });
      return { ok: true, id: r.id, attachments: c.atts, created };
    });
    LocalDB.register('mail.move', d => {
      const m = find(d.id), f = d.folder;
      if (!FOLD.includes(f)) return { ok: false, error: 'folder' };
      if (!m) return { ok: false, error: 'notfound' };
      if (m.folder === f) return { ok: true, folder: f };
      if ((m.folder === 'drafts' && f !== 'trash') || ((f === 'drafts' || f === 'sent') && m.sender !== 'Eu')) return { ok: false, error: 'folder' };
      if (f === 'drafts' && T().all().filter(x => x.folder === 'drafts').length >= DRAFTS) return { ok: false, error: 'draftsfull', max: DRAFTS };
      T().update(m.id, { folder: f });
      return { ok: true, folder: f };
    });
    LocalDB.register('mail.flag', d => { const m = find(d.id); if (!m) return { ok: false, error: 'notfound' }; const on = !(d.on === false || d.on === 0); T().update(m.id, { flagged: on }); return { ok: true, flagged: on }; });
    LocalDB.register('mail.delete', d => {
      const m = find(d.id); if (!m) return { ok: false, error: 'notfound' };
      if (m.folder !== 'trash') { T().update(m.id, { folder: 'trash' }); return { ok: true, deleted: false, folder: 'trash' }; }
      T().remove(m.id); dropOrphans(mediaIds(m.attachments));
      return { ok: true, deleted: true };
    });
    LocalDB.register('mail.read', d => { const m = find(d.id); if (m) T().update(m.id, { read: d.read !== false }); return { ok: true }; });
    LocalDB.register('mail.attachment', d => {
      const m = find(d.id), index = Math.floor(+d.index) || 0, i = Math.floor(+d.i) || 1;
      if (!index || index < 1 || index > 10 || i < 1 || i > 512) return { error: 'badchunk' };
      if (!m) return { error: 'notfound' };
      const a = (Array.isArray(m.attachments) ? m.attachments : [])[index - 1];
      if (!a || !a.mediaId) return { error: 'notfound' };
      const r = mediaRow(+a.mediaId);
      if (!r) return { error: 'gone' };
      const data = String(r.data || '');
      return { i, total: data.length ? Math.ceil(data.length / CH) : 0, len: data.length, kind: r.kind, mime: r.mime, duration: r.duration || null, data: data.slice((i - 1) * CH, i * CH) };
    });
  })();
})();
