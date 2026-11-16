/* =====================================================================
   STORIES - editor completo + visualizador (Instashot)

   Uma story é uma lista de CAMADAS sobre um fundo. O servidor guarda
   { image | bg, draw, layers[], duration } e qualquer telemóvel a
   reconstrói tal e qual - nada é "achatado" numa imagem.

   Camada:
     { id, type, x, y, scale, rot, text, font, color, align, bg, bgA, data }
     x/y são FRAÇÕES (0..1) do canvas, para ficar igual em qualquer escala.

   Regras de CEF cumpridas: zero backdrop-filter, zero filter em camadas
   grandes, zero color-mix. Só transform/opacity animam. O rato é cidadão
   de primeira: tudo funciona com pointer events (arrastar, roda, botões).
   ===================================================================== */
window.Stories = (() => {
  const g = UI.g, esc = UI.esc;
  const rpc = Bridge.rpc;

  /* ---------- config do servidor (uma vez por sessão) ---------- */
  let CFG = null;
  async function config() {
    if (CFG) return CFG;
    CFG = (await rpc('social.stories.config')) || {};
    CFG.duration = CFG.duration || 5;
    CFG.backgrounds = CFG.backgrounds || [];
    CFG.locations = CFG.locations || [];
    CFG.music = CFG.music || [];
    CFG.maxLayers = CFG.maxLayers || 24;
    return CFG;
  }

  /* ---------- estilos de letra ---------- */
  const FONTS = [
    { id: 'normal', label: 'Normal' },
    { id: 'bold', label: 'Forte' },
    { id: 'modern', label: 'Moderno' },
    { id: 'classic', label: 'Clássico' },
    { id: 'type', label: 'Máquina' },
    { id: 'neon', label: 'Néon' },
    { id: 'script', label: 'Caligrafia' },
    { id: 'wide', label: 'Largo' },
  ];
  const COLORS = ['#FFFFFF', '#000000', '#FF375F', '#FF9F0A', '#FFD60A', '#30D158', '#00C7BE', '#0A84FF', '#5E5CE6', '#BF5AF2', '#AC8E68', '#8E8E93'];
  /* cada emoji leva as suas palavras: sem isto a pesquisa não tinha por onde filtrar */
  const EMOJIS = [
    ['😀', 'sorriso feliz contente'], ['😂', 'riso chorar rir piada'], ['😍', 'amor apaixonado coracao olhos'],
    ['😎', 'fixe oculos sol cool'], ['🤔', 'pensar duvida hmm'], ['😭', 'chorar triste choro'],
    ['🔥', 'fogo brasa quente lit'], ['💯', 'cem 100 perfeito'], ['❤️', 'coracao amor vermelho'],
    ['💔', 'coracao partido desgosto'], ['👍', 'gosto polegar sim boa'], ['👎', 'nao gosto polegar baixo'],
    ['🙏', 'obrigado rezar maos favor'], ['👏', 'palmas aplauso bravo'], ['🎉', 'festa parabens celebrar'],
    ['💀', 'caveira morte morto'], ['👀', 'olhos ver espiar'], ['💪', 'forca musculo ginasio'],
    ['🚗', 'carro viatura conducao'], ['🏍️', 'mota moto pandem'], ['✈️', 'aviao voar viagem'],
    ['💵', 'dinheiro nota dolar massa'], ['💊', 'comprimido droga farmacia'], ['🍔', 'hamburguer comida burger'],
    ['🍕', 'pizza comida fatia'], ['☕', 'cafe bica bebida'], ['🍺', 'cerveja bebida copo bar'],
    ['🎧', 'auscultadores musica som'], ['📸', 'foto camara fotografia'], ['⭐', 'estrela favorito'],
    ['⚡', 'relampago raio rapido'], ['🌙', 'lua noite'],
  ];
  const bgCss = b => !b ? '' : (b.type === 'grad' ? `linear-gradient(160deg, ${b.a}, ${b.b})` : b.a);
  const imgCss = im => im ? (typeof im === 'number' ? (window.photoBg ? photoBg(im) : '#555') : `url("${String(im).replace(/"/g, '%22')}")`) : '';

  /* =====================================================================
     PRÉ-ESCUTA - usa o motor de música DESTE telemóvel (window.Music, em
     apps/music.js). Não depende de nenhum outro resource: regista a faixa
     no catálogo local e manda tocar o excerto escolhido.
     ===================================================================== */
  let stopPrev = null;
  const previewStop = () => { if (stopPrev) { const f = stopPrev; stopPrev = null; f(); } };
  function previewPlay(t, start, len) {
    previewStop();
    const vid = t && (t.vid || (/^yt:(.+)$/.exec(String(t.id || '')) || [])[1]);
    if (!vid || !window.Music || !Music.put || !Music.playId) { UI.toast('Esta faixa não tem áudio neste servidor'); return false; }
    const id = 'yt:' + vid;
    try {
      Music.put({ id, t: t.title || 'Música', a: t.artist || '', len: t.dur || 180, img: t.img });
      Music.playId(id);
    } catch (e) { UI.toast('Não consegui tocar'); return false; }
    /* o leitor só aceita o salto depois de arrancar */
    const seekT = start ? setTimeout(() => { try { Music.seekTo(start); } catch (e) {} }, 500) : null;
    const endT = setTimeout(() => { stopPrev = null; try { Music.stop(); } catch (e) {} }, ((len || 15) + 1) * 1000);
    stopPrev = () => { clearTimeout(seekT); clearTimeout(endT); try { Music.stop(); } catch (e) {} };
    return true;
  }

  const uid = () => 'l' + Math.random().toString(36).slice(2, 8);
  const clamp = (v, a, b) => v < a ? a : v > b ? b : v;
  /* o CEF não tem color-mix(): a transparência do fundo do texto é calculada aqui,
     em rgba(), senão o bgA viajava até ao render e morria sem ninguém o ler */
  const hexA = (h, a) => {
    if (!h) return 'transparent';
    if (a == null || a >= 1) return h;
    const m = /^#?([0-9a-fA-F]{6})$/.exec(String(h));
    if (!m) return h;
    const n = parseInt(m[1], 16);
    return `rgba(${(n >> 16) & 255}, ${(n >> 8) & 255}, ${n & 255}, ${a})`;
  };

  /* =====================================================================
     RENDER DE UMA CAMADA (usado pelo editor E pelo visualizador)
     ===================================================================== */
  function layerEl(l, opts = {}) {
    const e = UI.el(`<div class="st-layer st-${esc(l.type)}"></div>`);
    e.dataset.id = l.id;
    const inner = UI.el('<div class="st-in"></div>');
    e.appendChild(inner);

    if (l.type === 'text') {
      inner.className = 'st-in st-txt f-' + (l.font || 'normal');
      inner.style.color = l.color || '#fff';
      inner.style.textAlign = l.align || 'center';
      inner.style.fontSize = (l.size || 30) + 'px';
      if (l.bg) { inner.classList.add('has-bg'); inner.style.background = hexA(l.bg, l.bgA); }
      inner.textContent = l.text || '';
    } else if (l.type === 'emoji') {
      inner.className = 'st-in st-emo';
      inner.style.fontSize = (l.size || 56) + 'px';
      inner.textContent = l.text || '⭐';
    } else if (l.type === 'location' || l.type === 'hashtag' || l.type === 'mention') {
      inner.className = 'st-in st-chip k-' + l.type;
      const ic = l.type === 'location' ? g('pin', 19) : '';
      inner.innerHTML = `${ic}<span>${esc(l.text || '')}</span>`;
      if (opts.clickable) inner.style.cursor = 'pointer';
    } else if (l.type === 'time' || l.type === 'date') {
      inner.className = 'st-in st-chip k-time';
      inner.textContent = l.text || '';
    } else if (l.type === 'music') {
      const d = l.data || {};
      const st = l.style || 2;
      inner.className = 'st-in st-music s' + st;
      const art = `<span class="ar" style="background:linear-gradient(160deg, ${esc((d.art || ['#833AB4'])[0])}, ${esc((d.art || ['#833AB4', '#FD1D1D'])[1] || (d.art || ['#833AB4'])[0])})">${g('music', 19)}</span>`;
      if (st === 1) inner.innerHTML = `${g('music', 18)}<b>${esc(d.title || '')}</b>`;
      else if (st === 3) inner.innerHTML = `${art}<div class="tx"><b>${esc(d.title || '')}</b><span>${esc(d.artist || '')}</span></div>`;
      else inner.innerHTML = `${art}<div class="tx"><b>${esc(d.title || '')}</b></div>`;
    } else if (l.type === 'poll' || l.type === 'question') {
      const d = l.data || {};
      inner.className = 'st-in st-card';
      if (l.type === 'poll') inner.innerHTML = `<div class="q">${esc(d.q || 'Pergunta')}</div><div class="opts"><span>${esc(d.a || 'Sim')}</span><span>${esc(d.b || 'Não')}</span></div>`;
      else inner.innerHTML = `<div class="q">${esc(d.q || 'Faz-me uma pergunta')}</div><div class="ans">Escrever resposta…</div>`;
    }

    const place = () => {
      e.style.left = (l.x * 100) + '%';
      e.style.top = (l.y * 100) + '%';
      e.style.transform = `translate(-50%, -50%) rotate(${l.rot || 0}deg) scale(${l.scale || 1})`;
    };
    place();
    e._layer = l;
    e._place = place;
    return e;
  }

  /* =====================================================================
     EDITOR
     ===================================================================== */
  async function editor(app, me, win, src) {
    const cfg = await config();
    /* src = { image } | { bg } | { video } - o fundo da story.
       VÍDEO (12 nov 2026): `video` é a linha da galeria. O fundo do editor é a capa e, por baixo das camadas, o próprio vídeo a tocar
       sem som (o vídeo é do jogador, desce da galeria dele). Ao publicar vai só o id: o servidor copia o vídeo e a capa, e a duração
       da story passa a ser a do vídeo (o seletor de duração esconde-se). */
    const st = {
      image: src.image || null,
      video: src.video || null,
      bg: src.bg || null,
      layers: [],
      draw: null,
      duration: cfg.duration,
      closeFriends: false,
    };
    if (st.video) { st.image = st.video.poster || null; st.duration = clamp(Math.round(+st.video.duration || 0), 3, 60); }
    let sel = null, busy = false;

    const root = UI.el(`<div class="st-ed">
      <div class="st-canvas"><canvas class="st-draw" width="440" height="956"></canvas><div class="st-layers"></div>
        <div class="st-hint">Toca em <b>Aa</b> para escrever</div></div>
      <div class="st-top">
        <div class="b x">${g('x', 24)}</div>
        <div class="sp"></div>
        <div class="b aa"><b>Aa</b></div>
        <div class="b stk">${g('smile', 23)}</div>
        <div class="b mus">${g('music', 23)}</div>
        <div class="b drw">${g('pen', 23)}</div>
        <div class="b more">${g('more', 23)}</div>
      </div>
      <div class="st-sel"><div class="s sm">${g('minus', 21)}</div><div class="s rot">${g('rotate', 21)}</div><div class="s bg">${g('layers', 21)}</div><div class="s big">${g('plus', 21)}</div></div>
      <div class="st-trash">${g('trash', 24)}</div>
      <div class="st-bottom">
        <div class="pub own"><span class="av"></span><b>O teu Story</b></div>
        <div class="pub cf">${g('star', 20)}<b>Amigos próximos</b></div>
      </div>
      <div class="st-busy"><div class="sp"></div><span>A publicar…</span></div>
    </div>`);
    win.appendChild(root);

    const canvas = root.querySelector('.st-canvas');
    const layersBox = root.querySelector('.st-layers');
    const drawCv = root.querySelector('.st-draw');
    const trash = root.querySelector('.st-trash');
    const selBar = root.querySelector('.st-sel');
    root.querySelector('.st-bottom .av').innerHTML = UI.avatar({ name: me.username, avatar: me.avatar, url: me.avatarUrl || me.avatar_url }, 'xs');
    if (cfg.closeFriends === false) root.querySelector('.pub.cf').style.display = 'none';

    /* ⚠️ NUNCA escrever no atalho `background` depois de pôr o `background-image`:
       ler `style.background` devolve vazio quando só o longhand está definido, e voltar a
       atribuí-lo APAGA a imagem - era isto que deixava o editor preto depois de escolher
       a fotografia. Aqui limpa-se o atalho PRIMEIRO e só depois se escrevem os longhands. */
    const paintBg = () => {
      canvas.style.background = '';
      if (st.image) {
        canvas.style.backgroundColor = '#000';
        canvas.style.backgroundImage = imgCss(st.image);
        canvas.style.backgroundSize = 'cover';
        canvas.style.backgroundPosition = 'center';
        canvas.style.backgroundRepeat = 'no-repeat';
      } else {
        canvas.style.backgroundImage = '';
        canvas.style.background = bgCss(st.bg) || '#111';
      }
    };
    paintBg();
    /* a pré-visualização do vídeo: um <video> sem som e em ciclo por baixo do desenho e das camadas; a capa fica até ele arrancar */
    let pvVid = null;
    const dropPreview = () => { if (!pvVid) return; try { pvVid.pause(); } catch (e) {} pvVid.removeAttribute('src'); try { pvVid.load(); } catch (e) {} pvVid.remove(); pvVid = null; };
    if (st.video) {
      const vrow = st.video;
      root.classList.add('st-isvid');
      if (!st.image) Promise.resolve(Photos.poster(vrow, true)).then(u => { if (u && st.video === vrow) { st.image = u; paintBg(); } }).catch(() => {});
      Promise.resolve(Photos.videoUrl(vrow)).then(url => {
        if (!url || st.video !== vrow || !root.isConnected) return;
        pvVid = document.createElement('video'); pvVid.className = 'st-vid'; pvVid.muted = true; pvVid.loop = true; pvVid.playsInline = true; pvVid.setAttribute('playsinline', '');
        canvas.insertBefore(pvVid, canvas.firstChild); pvVid.src = url; const pr = pvVid.play(); if (pr && pr.catch) pr.catch(() => {});
      }).catch(() => {});
    }

    /* ---------- camadas ---------- */
    const hint = root.querySelector('.st-hint');
    const refreshHint = () => { hint.style.display = st.layers.length ? 'none' : ''; };
    const select = l => {
      sel = l;
      layersBox.querySelectorAll('.st-layer').forEach(x => x.classList.toggle('sel', l && x.dataset.id === l.id));
      selBar.classList.toggle('in', !!l);
      if (l) { const bgb = selBar.querySelector('.bg'); bgb.style.display = l.type === 'text' ? '' : 'none'; }
    };
    const addLayer = (l, noSelect) => {
      if (st.layers.length >= cfg.maxLayers) { UI.toast('Demasiados elementos'); return null; }
      l.id = l.id || uid();
      if (l.x == null) l.x = .5;
      if (l.y == null) l.y = l.type === 'text' ? .45 : .5;
      /* nenhum caminho pode pousar uma camada debaixo das barras (elas ficam por cima) */
      const yb = yBounds();
      l.y = clamp(l.y, yb.lo, yb.hi);
      l.x = clamp(l.x, .06, .94);
      if (l.scale == null) l.scale = 1;
      if (l.rot == null) l.rot = 0;
      st.layers.push(l);
      const e = layerEl(l);
      bindDrag(e, l);
      layersBox.appendChild(e);
      refreshHint();
      if (!noSelect) select(l);
      return e;
    };
    const removeLayer = l => {
      const i = st.layers.indexOf(l);
      if (i > -1) st.layers.splice(i, 1);
      const e = layersBox.querySelector(`[data-id="${l.id}"]`);
      if (e) e.remove();
      if (sel === l) select(null);
      refreshHint();
    };
    const redraw = l => {
      const old = layersBox.querySelector(`[data-id="${l.id}"]`);
      if (!old) return;
      const e = layerEl(l);
      bindDrag(e, l);
      old.replaceWith(e);
      if (sel === l) e.classList.add('sel');
    };

    /* ---------- arrastar / rodar / escalar (RATO em primeiro lugar) ----------
       A zona do caixote é calculada a partir do CANVAS, não do próprio caixote: ele
       aparece com uma animação de escala e usar o retângulo dele durante a animação
       fazia falhar quem largasse depressa (apanhado a correr o teste três vezes). */
    const TRASH_CY = 123, TRASH_RX = 78, TRASH_RY = 72;
    const overTrash = (cx, cy) => {
      const r = canvas.getBoundingClientRect();
      return Math.abs(cx - (r.left + r.width / 2)) < TRASH_RX && Math.abs(cy - (r.bottom - TRASH_CY)) < TRASH_RY;
    };
    /* As barras de cima e de baixo estão POR CIMA das camadas (z-index 12 contra 4):
       um sticker largado por baixo da barra "O teu Story" deixava de se poder tocar e o
       toque publicava a story. Limita-se o Y à faixa livre, medida nas barras reais. */
    const topBar = root.querySelector('.st-top'), botBar = root.querySelector('.st-bottom');
    const yBounds = () => {
      const r = canvas.getBoundingClientRect();
      if (!r.height) return { lo: .12, hi: .88 };
      const tb = topBar.getBoundingClientRect(), bb = botBar.getBoundingClientRect();
      const lo = tb.height ? clamp((tb.bottom - r.top) / r.height + .025, .04, .34) : .12;
      const hi = bb.height ? clamp((bb.top - r.top) / r.height - .025, .66, .96) : .88;
      return hi > lo ? { lo, hi } : { lo: .12, hi: .88 };
    };
    function bindDrag(e, l) {
      let drag = null;
      e.addEventListener('pointerdown', ev => {
        if (ev.target.closest('.st-sel')) return;
        select(l);
        const r = canvas.getBoundingClientRect();
        const b = yBounds();
        drag = { px: ev.clientX, py: ev.clientY, x0: l.x, y0: l.y, w: r.width, h: r.height, lo: b.lo, hi: b.hi, moved: false };
        try { e.setPointerCapture(ev.pointerId); } catch (x) {}
        ev.preventDefault();
      });
      e.addEventListener('pointermove', ev => {
        if (!drag) return;
        const dx = (ev.clientX - drag.px) / drag.w, dy = (ev.clientY - drag.py) / drag.h;
        if (!drag.moved && Math.abs(dx) + Math.abs(dy) > .004) { drag.moved = true; trash.classList.add('in'); }
        l.x = clamp(drag.x0 + dx, .06, .94);
        l.y = clamp(drag.y0 + dy, drag.lo, drag.hi);
        e._place();
        if (drag.moved) {
          const over = overTrash(ev.clientX, ev.clientY);
          trash.classList.toggle('hot', over);
          e.classList.toggle('over-trash', over);
        }
      });
      const up = ev => {
        if (!drag) return;
        const wasMoved = drag.moved;
        /* decide pela POSIÇÃO do ponteiro no momento de largar, não pela classe:
           um pointerup sem pointermove anterior nunca teria a classe posta */
        const dropped = wasMoved && (e.classList.contains('over-trash') || (ev && overTrash(ev.clientX, ev.clientY)));
        drag = null;
        trash.classList.remove('in', 'hot');
        if (dropped) { Sound.play('click'); removeLayer(l); return; }
        e.classList.remove('over-trash');
        if (!wasMoved && l.type === 'text') textSheet(l);
      };
      e.addEventListener('pointerup', up);
      e.addEventListener('pointercancel', up);
      /* roda do rato escala o elemento selecionado - no NUI é o gesto natural */
      e.addEventListener('wheel', ev => {
        if (sel !== l) return;
        ev.preventDefault();
        l.scale = clamp((l.scale || 1) * (ev.deltaY < 0 ? 1.08 : 0.93), .3, 4);
        e._place();
      }, { passive: false });
    }

    /* barra do elemento selecionado: −, rodar, fundo, + */
    const bump = k => { if (!sel) return; sel.scale = clamp((sel.scale || 1) * k, .3, 4); const e = layersBox.querySelector(`[data-id="${sel.id}"]`); if (e) e._place(); };
    selBar.querySelector('.sm').onclick = () => bump(.88);
    selBar.querySelector('.big').onclick = () => bump(1.14);
    selBar.querySelector('.rot').onclick = () => { if (!sel) return; sel.rot = ((sel.rot || 0) + 15) % 360; const e = layersBox.querySelector(`[data-id="${sel.id}"]`); if (e) e._place(); };
    selBar.querySelector('.bg').onclick = () => {
      if (!sel || sel.type !== 'text') return;
      /* nenhum → sólido → translúcido → nenhum */
      if (!sel.bg) { sel.bg = sel.color === '#FFFFFF' ? '#000000' : '#FFFFFF'; sel.bgA = 1; }
      else if (sel.bgA === 1) sel.bgA = .45;
      else { sel.bg = null; sel.bgA = 1; }
      redraw(sel);
    };
    canvas.addEventListener('pointerdown', ev => { if (ev.target === canvas || ev.target === layersBox || ev.target === drawCv) select(null); });

    /* =================== TEXTO =================== */
    function textSheet(existing) {
      /* trabalha-se sempre numa CÓPIA: "Cancelar" tem de deixar a camada tal como estava,
         e antes disto o tipo de letra/cor/tamanho eram escritos em direto no original */
      const l = Object.assign({ type: 'text', text: '', font: 'normal', color: '#FFFFFF', align: 'center', size: 30, bg: null, bgA: 1 }, existing || {});
      const ov = UI.el(`<div class="st-text-ov">
        <div class="tt"><div class="cancel">Cancelar</div><div class="done">Concluir</div></div>
        <div class="area"><textarea class="ta f-${esc(l.font)}" rows="3" maxlength="200" placeholder="Escreve algo…"></textarea></div>
        <div class="tools">
          <div class="row fonts"></div>
          <div class="row cols"></div>
          <div class="row ctl"><div class="al">${g('list', 21)}</div><div class="bgb">${g('layers', 21)}</div><input type="range" class="sz" min="14" max="72" value="${l.size || 30}"></div>
        </div></div>`);
      root.appendChild(ov);
      const ta = ov.querySelector('.ta');
      ta.value = l.text || '';
      ta.style.color = l.color;
      ta.style.textAlign = l.align;
      ta.style.fontSize = (l.size || 30) + 'px';
      const applyTa = () => { ta.className = 'ta f-' + l.font; ta.style.color = l.color; ta.style.textAlign = l.align; ta.style.fontSize = l.size + 'px'; ta.style.background = hexA(l.bg, l.bgA); ta.classList.toggle('has-bg', !!l.bg); };
      const fonts = ov.querySelector('.fonts');
      FONTS.forEach(f => { const d = UI.el(`<span class="f f-${f.id} ${f.id === l.font ? 'on' : ''}">Aa</span>`); d.title = f.label; d.onclick = () => { l.font = f.id; fonts.querySelectorAll('.f').forEach(x => x.classList.toggle('on', x === d)); applyTa(); }; fonts.appendChild(d); });
      const cols = ov.querySelector('.cols');
      COLORS.forEach(c => { const d = UI.el(`<span class="c ${c === l.color ? 'on' : ''}" style="background:${c}"></span>`); d.onclick = () => { l.color = c; cols.querySelectorAll('.c').forEach(x => x.classList.toggle('on', x === d)); applyTa(); }; cols.appendChild(d); });
      const custom = UI.el(`<span class="c cust">${g('sliders', 18)}</span>`);
      custom.onclick = async () => { const h = await UI.prompt('Cor', 'Formato #RRGGBB', '#FF00AA', l.color); if (h && /^#[0-9a-f]{6}$/i.test(h)) { l.color = h.toUpperCase(); applyTa(); } };
      cols.appendChild(custom);
      ov.querySelector('.al').onclick = () => { l.align = l.align === 'center' ? 'left' : l.align === 'left' ? 'right' : 'center'; applyTa(); };
      ov.querySelector('.bgb').onclick = () => { if (!l.bg) { l.bg = l.color === '#FFFFFF' ? '#000000' : '#FFFFFF'; l.bgA = 1; } else if (l.bgA === 1) l.bgA = .45; else { l.bg = null; l.bgA = 1; } applyTa(); };
      ov.querySelector('.sz').oninput = e2 => { l.size = +e2.target.value; applyTa(); };
      applyTa();
      setTimeout(() => { try { ta.focus(); } catch (e2) {} if (window.Keyboard) Keyboard.show(ta); }, 60);
      const close = () => { if (window.Keyboard) Keyboard.hide(); ov.remove(); };
      ov.querySelector('.cancel').onclick = close;
      ov.querySelector('.done').onclick = () => {
        l.text = ta.value.trim().slice(0, 200);
        close();
        if (!l.text) { if (existing) removeLayer(existing); return; }
        if (existing) { Object.assign(existing, l); redraw(existing); } else addLayer(l);
      };
    }
    root.querySelector('.b.aa').onclick = () => textSheet(null);

    /* =================== STICKERS =================== */
    function stickerPanel() {
      const ov = UI.el(`<div class="st-panel">
        <div class="ph"><b>Stickers</b><div class="cl">${g('x', 21)}</div></div>
        <div class="sb"></div>
        <div class="body"></div></div>`);
      root.appendChild(ov);
      const body = ov.querySelector('.body');
      const close = () => ov.remove();
      ov.querySelector('.cl').onclick = close;
      ov.onclick = e2 => { if (e2.target === ov) close(); };
      let q = '';
      ov.querySelector('.sb').appendChild(UI.search('Pesquisar stickers', v => { q = v; paint(); }));

      const now = new Date();
      const QUICK = [
        { k: 'location', label: 'Localização', icon: 'pin' },
        { k: 'mention', label: 'Menção', icon: 'at' },
        { k: 'hashtag', label: 'Hashtag', icon: 'hash' },
        { k: 'time', label: UI.fmtTime(now), icon: 'clock' },
        { k: 'date', label: UI.fmtDate(now, true), icon: 'calendar' },
        { k: 'music', label: 'Música', icon: 'music' },
        { k: 'poll', label: 'Sondagem', icon: 'chart' },
        { k: 'question', label: 'Pergunta', icon: 'chat' },
      ];
      const paint = () => {
        body.innerHTML = '';
        const qq = (q || '').toLowerCase();
        const quick = QUICK.filter(x => !qq || x.label.toLowerCase().includes(qq) || x.k.includes(qq));
        if (quick.length) {
          const grid = UI.el('<div class="sgrid"></div>');
          quick.forEach(x => {
            const d = UI.el(`<div class="sg">${g(x.icon, 20)}<span>${esc(x.label)}</span></div>`);
            d.onclick = () => { close(); pickSticker(x.k, x.label); };
            grid.appendChild(d);
          });
          body.appendChild(grid);
        }
        const em = EMOJIS.filter(p => !qq || p[1].includes(qq) || p[0] === q);
        if (em.length) {
          body.appendChild(UI.el('<div class="sh">Emoji</div>'));
          const eg = UI.el('<div class="egrid"></div>');
          em.forEach(p => { const x = p[0]; const d = UI.el(`<span>${x}</span>`); d.title = p[1]; d.onclick = () => { close(); addLayer({ type: 'emoji', text: x, size: 56 }); }; eg.appendChild(d); });
          body.appendChild(eg);
        }
        if (!quick.length && !em.length) { const e2 = UI.empty('search', 'Sem stickers', ''); e2.classList.add('compact'); body.appendChild(e2); }
      };
      paint();
    }
    root.querySelector('.b.stk').onclick = stickerPanel;

    async function pickSticker(kind, label) {
      if (kind === 'time') { addLayer({ type: 'time', text: UI.fmtTime(new Date()) }); return; }
      if (kind === 'date') { addLayer({ type: 'date', text: UI.fmtDate(new Date(), true) }); return; }
      if (kind === 'music') { musicPanel(); return; }
      if (kind === 'location') {
        const list = cfg.locations || [];
        const r = await pickFrom('Localização', list.map(x => ({ label: x, value: x })), true);
        if (r) addLayer({ type: 'location', text: r });
        return;
      }
      if (kind === 'hashtag') {
        const t = await UI.prompt('Hashtag', 'Sem o #', 'losantos');
        if (t) addLayer({ type: 'hashtag', text: '#' + String(t).replace(/^#/, '').replace(/\s+/g, '').slice(0, 24) });
        return;
      }
      if (kind === 'mention') {
        const t = await UI.prompt('Mencionar', 'Nome de utilizador', 'username');
        if (!t) return;
        const u = String(t).replace(/^@/, '').trim().toLowerCase();
        const found = (await rpc('social.search', { app, q: u })) || [];
        const hit = found.find(x => x.username === u) || found[0];
        if (!hit) { UI.toast('Não encontrei essa conta'); return; }
        addLayer({ type: 'mention', text: '@' + hit.username });
        return;
      }
      if (kind === 'poll') {
        const q1 = await UI.prompt('Sondagem', 'A pergunta', 'Vamos ao carmeet?');
        if (!q1) return;
        addLayer({ type: 'poll', data: { q: q1, a: 'Sim', b: 'Não' } });
        return;
      }
      if (kind === 'question') {
        const q1 = await UI.prompt('Pergunta', 'O que queres perguntar', 'Faz-me uma pergunta');
        if (!q1) return;
        addLayer({ type: 'question', data: { q: q1 } });
      }
    }

    /* lista simples com pesquisa, devolve o valor escolhido */
    function pickFrom(title, items, search) {
      return new Promise(res => {
        const body = UI.el('<div></div>');
        const holder = UI.el('<div></div>');
        if (search) body.appendChild(UI.search('Pesquisar', v => paint(v)));
        body.appendChild(holder);
        const paint = v => {
          const l = items.filter(x => !v || x.label.toLowerCase().includes(v));
          holder.innerHTML = '';
          holder.appendChild(UI.list([{ items: l.map(x => ({ label: x.label, chevron: false, onTap: () => { res(x.value); sh.close(); } })) }]));
        };
        paint('');
        const sh = UI.sheet({ title, right: 'Cancelar', body, onClose: () => res(null) });
      });
    }

    /* =================== MÚSICA =================== */
    function musicPanel() {
      const ov = UI.el(`<div class="st-panel tall">
        <div class="ph"><b>Música</b><div class="cl">${g('x', 21)}</div></div>
        <div class="sb"></div>
        <div class="body"></div></div>`);
      root.appendChild(ov);
      const body = ov.querySelector('.body');
      const close = () => { previewStop(); ov.remove(); };
      ov.querySelector('.cl').onclick = close;
      ov.onclick = e2 => { if (e2.target === ov) close(); };
      /* com a pesquisa aberta (Config.Music.Search) cada pesquisa vai ao YouTube: 450 ms depois de parar de escrever (eram 220,
         um pedido por letra); um link colado vai logo. `seq` deita fora respostas atrasadas (uma pesquisa lenta já não pinta por
         cima da seguinte). */
      /* ⚠️ o UI.search entrega o texto em MINÚSCULAS: num link colado o id do vídeo (sensível a maiúsculas) virava outro vídeo.
         Lê-se o campo tal e qual. */
      let sT = null, seq = 0;
      const sbox = UI.search('Pesquisar músicas', () => { clearTimeout(sT); const v = sbox.input.value.trim(); const lk = window.Music && Music.linkVid ? Music.linkVid(v) : null; sT = setTimeout(() => run(v), !v ? 0 : lk ? 150 : 450); });
      ov.querySelector('.sb').appendChild(sbox);

      const rowOf = t => {
        const art = t.art || ['#833AB4', '#FD1D1D'];
        const r = UI.el(`<div class="mrow"><span class="ar" style="background:linear-gradient(160deg, ${esc(art[0])}, ${esc(art[1] || art[0])})">${t.img ? '' : g('music', 21)}</span>
          <div class="tx"><b>${esc(t.title)}</b><span>${esc(t.artist || '')}</span></div>
          <div class="pv">${g('play', 21)}</div></div>`);
        /* a capa da faixa (YouTube) quando a há; posta por JS para o URL nunca passar por HTML */
        if (t.img && /^https:\/\//i.test(t.img)) r.querySelector('.ar').style.background = `url("${String(t.img).replace(/"/g, '%22')}") center/cover no-repeat, linear-gradient(160deg, ${art[0]}, ${art[1] || art[0]})`;
        const pv = r.querySelector('.pv');
        pv.onclick = ev => {
          ev.stopPropagation();
          if (pv.classList.contains('on')) { previewStop(); pv.classList.remove('on'); pv.innerHTML = g('play', 21); return; }
          ov.querySelectorAll('.pv.on').forEach(x => { x.classList.remove('on'); x.innerHTML = g('play', 21); });
          if (!previewPlay(t, 0, 20)) return;
          pv.classList.add('on'); pv.innerHTML = g('pause', 21);
          setTimeout(() => { if (pv.isConnected) { pv.classList.remove('on'); pv.innerHTML = g('play', 21); } }, 21000);
        };
        r.onclick = () => { close(); trimmer(t); };
        return r;
      };
      const run = async v => {
        v = String(v || '').trim();
        const my = ++seq;
        body.innerHTML = '';
        if (!v) {
          body.appendChild(UI.el('<div class="sh">Sugestões do servidor</div>'));
          (cfg.music || []).forEach(t => body.appendChild(rowOf(t)));
          if (!(cfg.music || []).length) { const e2 = UI.empty('music', 'Sem músicas', 'O servidor ainda não configurou nenhuma.'); e2.classList.add('compact'); body.appendChild(e2); }
          return;
        }
        body.appendChild(UI.spinner());
        /* pesquisa do PRÓPRIO telemóvel (RPC music.search do apex_phone): com o fornecedor interno e Config.Music.Search é a
           pesquisa aberta no YouTube (qualquer música, ou um link colado); sem ela o catálogo do config; com o apex_carplay o dele.
           rpcRaw e não rpc: o rpc() troca o { error } por null e a lista dizia "Sem resultados" quando o YouTube nem respondeu. */
        let out = null;
        try { out = await Bridge.rpcRaw('music.search', { q: v }); } catch (e2) {}
        if (my !== seq || !ov.isConnected) return;
        body.innerHTML = '';
        const err = (out && typeof out === 'object') ? out.error : 'rpc';
        const found = [], seen = new Set();
        ((out && out.shelves) || []).forEach(sh => {
          if (sh.kind !== 'track') return;
          /* o `vid` viaja junto: é ele que permite a pré-escuta e tocar a música na story */
          (sh.items || []).forEach(s => {
            const vid = s.vid || null; const id = s.id || (vid ? 'yt:' + vid : null);
            if (!id || seen.has(id)) return; seen.add(id);
            found.push({ id, vid, title: s.t || s.title, artist: s.a || s.artist || '', dur: s.len || s.dur || 180, img: s.img || (vid ? 'https://i.ytimg.com/vi/' + vid + '/mqdefault.jpg' : null), art: s.art || ['#833AB4', '#FD1D1D'] });
          });
        });
        if (found.length) { found.slice(0, 20).forEach(t => body.appendChild(rowOf(t))); return; }
        /* nada no servidor: as sugestões do config ainda podem servir */
        const lv = v.toLowerCase();
        const local = (cfg.music || []).filter(t => (t.title + ' ' + (t.artist || '')).toLowerCase().includes(lv));
        if (!local.length) {
          /* o servidor disse porquê (YouTube sem resposta, a travar, link que não é de um vídeo): a mesma frase da app Música */
          const why = err && window.Music && Music.srvErr ? Music.srvErr(err) : '';
          const e2 = UI.empty('music', why && err !== 'badlink' ? 'Sem resposta' : 'Sem resultados', why || 'Tenta outro nome.'); e2.classList.add('compact'); body.appendChild(e2); return;
        }
        local.forEach(t => body.appendChild(rowOf(t)));
      };
      run('');
    }

    /* escolher o pedaço da música (15 s) numa timeline com waveform */
    function trimmer(t) {
      const LEN = 15;
      const dur = Math.max(LEN + 1, t.dur || 180);
      let start = Math.floor(dur * .25);
      let style = 2;
      /* barras determinísticas a partir do id: a mesma música dá sempre a mesma onda */
      let h = 0; const key = String(t.id || t.title);
      for (const c of key) h = (h * 31 + c.charCodeAt(0)) | 0;
      const bars = Array.from({ length: 64 }, (_, i) => { h = (h * 1103515245 + 12345) & 0x7fffffff; return 20 + (h % 80); });

      const ov = UI.el(`<div class="st-panel tall trim">
        <div class="ph"><div class="cl2">Cancelar</div><b>${esc(t.title)}</b><div class="ok">Concluir</div></div>
        <div class="body">
          <div class="tprev"></div>
          <div class="styles"><span class="s1">Só o nome</span><span class="s2 on">Capa + nome</span><span class="s3">Cartão</span></div>
          <div class="wave"><div class="bars"></div><div class="win"></div></div>
          <div class="tinfo"><span class="from">0:00</span><span class="hear">${g('play', 18)} Ouvir</span><span class="to">0:15</span></div>
        </div></div>`);
      root.appendChild(ov);
      const barsEl = ov.querySelector('.bars'), winEl = ov.querySelector('.win');
      bars.forEach(v => { const b = UI.el('<i></i>'); b.style.height = v + '%'; barsEl.appendChild(b); });

      const fmt = s => Math.floor(s / 60) + ':' + String(Math.floor(s % 60)).padStart(2, '0');
      const prev = ov.querySelector('.tprev');
      const fromEl = ov.querySelector('.from'), toEl = ov.querySelector('.to');
      /* a janela e os tempos mudam a cada pointermove; o sticker de pré-visualização NÃO depende do
         `start` - reconstruí-lo (innerHTML + layerEl + SVG) em cada evento do arrasto era trabalho
         deitado fora. Só se refaz quando muda o estilo. */
      const paintWin = () => {
        winEl.style.width = ((LEN / dur) * 100) + '%';
        winEl.style.left = (start / dur) * 100 + '%';
        fromEl.textContent = fmt(start);
        toEl.textContent = fmt(start + LEN);
      };
      const paintPrev = () => {
        prev.innerHTML = '';
        prev.appendChild(layerEl({ id: 'p', type: 'music', style, x: .5, y: .5, scale: 1, rot: 0, data: t }));
      };
      paintWin(); paintPrev();
      ov.querySelectorAll('.styles span').forEach((s, i) => { s.onclick = () => { style = i + 1; ov.querySelectorAll('.styles span').forEach(x => x.classList.toggle('on', x === s)); paintPrev(); }; });

      let drag = null, wr = null;
      const wave = ov.querySelector('.wave');
      /* o retângulo da onda mede-se no pointerdown: não se mexe durante o arrasto, e lê-lo aqui logo a
         seguir a escrever width/left na janela forçava um layout síncrono por evento */
      const setFromX = cx => { const r = wr || wave.getBoundingClientRect(); const f = clamp((cx - r.left) / r.width, 0, 1); start = clamp(Math.round(f * dur - LEN / 2), 0, Math.max(0, dur - LEN)); paintWin(); };
      wave.addEventListener('pointerdown', ev => { drag = 1; wr = wave.getBoundingClientRect(); try { wave.setPointerCapture(ev.pointerId); } catch (x) {} setFromX(ev.clientX); });
      wave.addEventListener('pointermove', ev => { if (drag) setFromX(ev.clientX); });
      const upW = () => { drag = null; wr = null; };
      wave.addEventListener('pointerup', upW); wave.addEventListener('pointercancel', upW);

      /* ouvir os 15 s escolhidos antes de os colar na story */
      const hear = ov.querySelector('.hear');
      const hearOff = () => { hear.classList.remove('on'); hear.innerHTML = g('play', 18) + ' Ouvir'; };
      hear.onclick = () => {
        if (hear.classList.contains('on')) { previewStop(); hearOff(); return; }
        if (!previewPlay(t, start, LEN)) return;
        hear.classList.add('on'); hear.innerHTML = g('pause', 18) + ' A tocar';
        setTimeout(() => { if (hear.isConnected) hearOff(); }, (LEN + 1) * 1000);
      };
      ov.querySelector('.cl2').onclick = () => { previewStop(); ov.remove(); };
      ov.querySelector('.ok').onclick = () => {
        previewStop();
        ov.remove();
        addLayer({ type: 'music', style, data: { id: t.id, vid: t.vid || null, title: t.title, artist: t.artist, art: t.art, start, len: LEN } });
      };
    }
    root.querySelector('.b.mus').onclick = musicPanel;

    /* =================== DESENHAR =================== */
    const dctx = drawCv.getContext('2d');
    let strokes = [], undone = [];
    /* enquanto se desenha só se acrescenta o ÚLTIMO segmento: repintar todos os traços a
       cada pointermove era trabalho quadrático e o traço ficava a arrastar-se. */
    const drawSeg = s => {
      dctx.globalCompositeOperation = s.erase ? 'destination-out' : 'source-over';
      dctx.strokeStyle = s.color; dctx.lineWidth = s.w; dctx.lineCap = 'round'; dctx.lineJoin = 'round';
      const n = s.pts.length;
      if (n === 1) { dctx.fillStyle = s.color; dctx.beginPath(); dctx.arc(s.pts[0][0], s.pts[0][1], s.w / 2, 0, Math.PI * 2); dctx.fill(); }
      else if (n > 1) { dctx.beginPath(); dctx.moveTo(s.pts[n - 2][0], s.pts[n - 2][1]); dctx.lineTo(s.pts[n - 1][0], s.pts[n - 1][1]); dctx.stroke(); }
      dctx.globalCompositeOperation = 'source-over';
    };
    const repaintDraw = () => {
      dctx.clearRect(0, 0, drawCv.width, drawCv.height);
      strokes.forEach(s => {
        dctx.globalCompositeOperation = s.erase ? 'destination-out' : 'source-over';
        dctx.strokeStyle = s.color; dctx.lineWidth = s.w; dctx.lineCap = 'round'; dctx.lineJoin = 'round';
        dctx.beginPath();
        s.pts.forEach((p, i) => { if (i === 0) dctx.moveTo(p[0], p[1]); else dctx.lineTo(p[0], p[1]); });
        dctx.stroke();
      });
      dctx.globalCompositeOperation = 'source-over';
    };
    function drawMode() {
      let color = '#FFFFFF', width = 6, erase = false, cur = null;
      const ov = UI.el(`<div class="st-draw-ov">
        <div class="dt"><div class="cl2">Concluir</div><div class="tools"><div class="u">${g('arrowL', 21)}</div><div class="r">${g('arrowR', 21)}</div><div class="e">${g('backspace', 21)}</div><div class="cl3">${g('trash', 21)}</div></div></div>
        <div class="db"><div class="cols"></div><input type="range" class="w" min="2" max="28" value="6"></div></div>`);
      root.appendChild(ov);
      root.classList.add('drawing');
      const cols = ov.querySelector('.cols');
      COLORS.forEach(c => { const d = UI.el(`<span class="c ${c === color ? 'on' : ''}" style="background:${c}"></span>`); d.onclick = () => { color = c; erase = false; ov.querySelector('.e').classList.remove('on'); cols.querySelectorAll('.c').forEach(x => x.classList.toggle('on', x === d)); }; cols.appendChild(d); });
      ov.querySelector('.w').oninput = e2 => { width = +e2.target.value; };
      ov.querySelector('.e').onclick = e2 => { erase = !erase; e2.currentTarget.classList.toggle('on', erase); };
      ov.querySelector('.u').onclick = () => { if (strokes.length) { undone.push(strokes.pop()); repaintDraw(); } };
      ov.querySelector('.r').onclick = () => { if (undone.length) { strokes.push(undone.pop()); repaintDraw(); } };
      ov.querySelector('.cl3').onclick = () => { strokes = []; undone = []; repaintDraw(); };
      ov.querySelector('.cl2').onclick = () => { root.classList.remove('drawing'); ov.remove(); };

      const pt = ev => { const r = drawCv.getBoundingClientRect(); return [(ev.clientX - r.left) / r.width * drawCv.width, (ev.clientY - r.top) / r.height * drawCv.height]; };
      const down = ev => { cur = { color, w: width * (drawCv.width / 440), erase, pts: [pt(ev)] }; strokes.push(cur); undone = []; try { drawCv.setPointerCapture(ev.pointerId); } catch (x) {} drawSeg(cur); ev.preventDefault(); };
      const move = ev => { if (!cur) return; cur.pts.push(pt(ev)); drawSeg(cur); };
      const up = () => { cur = null; };
      drawCv.addEventListener('pointerdown', down);
      drawCv.addEventListener('pointermove', move);
      drawCv.addEventListener('pointerup', up);
      drawCv.addEventListener('pointercancel', up);
      ov._off = () => { drawCv.removeEventListener('pointerdown', down); drawCv.removeEventListener('pointermove', move); drawCv.removeEventListener('pointerup', up); drawCv.removeEventListener('pointercancel', up); };
      const oldRemove = ov.remove.bind(ov);
      ov.remove = () => { ov._off(); oldRemove(); };
    }
    root.querySelector('.b.drw').onclick = drawMode;

    /* =================== MAIS =================== */
    root.querySelector('.b.more').onclick = async ev => {
      /* numa story em vídeo a duração é a do vídeo: o seletor não aparece */
      const r = await UI.actionSheet({ title: 'Story', buttons: [
        { label: 'Mudar fundo', icon: 'image', value: 'bg' },
      ].concat(st.video ? [] : [{ label: 'Duração: ' + st.duration + ' s', icon: 'timer', value: 'dur' }]).concat([
        { label: 'Limpar tudo', icon: 'trash', danger: true, value: 'clr' },
      ]) });
      if (r === 'bg') {
        const b = await bgSheet();
        if (b) { st.bg = b; st.image = null; if (st.video) { st.video = null; st.duration = cfg.duration; dropPreview(); root.classList.remove('st-isvid'); } paintBg(); }
      } else if (r === 'dur') {
        const d2 = await UI.picker('Duração', ['3 segundos', '5 segundos', '7 segundos', '10 segundos', '15 segundos'], st.duration + ' segundos');
        if (d2) st.duration = parseInt(d2, 10);
      } else if (r === 'clr') {
        if (await UI.confirm('Limpar', 'Remove todos os elementos e o desenho.', 'Limpar', true)) {
          st.layers = []; layersBox.innerHTML = ''; strokes = []; undone = []; repaintDraw(); select(null); refreshHint();
        }
      }
    };

    function bgSheet() {
      return new Promise(res => {
        const body = UI.el('<div class="st-bgs"></div>');
        (cfg.backgrounds || []).forEach(b => {
          const d = UI.el(`<span style="background:${bgCss(b)}"></span>`);
          d.onclick = () => { res(b); sh.close(); };
          body.appendChild(d);
        });
        const sh = UI.sheet({ title: 'Fundo', right: 'Cancelar', body, onClose: () => res(null) });
      });
    }

    /* =================== PUBLICAR =================== */
    /* A media sobe AOS BOCADOS de 48 KB, como as Fotos já faziam: um base64 inteiro
       (foto até ~260 KB + PNG do desenho) não cabe num evento de rede do FiveM. */
    const CHUNK = 48000;
    const upload = async (id, which, data) => {
      if (!data || typeof data !== 'string') return true;
      const total = Math.ceil(data.length / CHUNK);
      if (total > 64) { UI.toast('Imagem grande demais'); return false; }
      for (let i = 1; i <= total; i++) {
        const r = await Bridge.rpcRaw('social.story.upload', { app, id, which, i, total, data: data.slice((i - 1) * CHUNK, i * CHUNK) });
        if (!r || r.error) return false;
      }
      return true;
    };

    const publish = async closeFriends => {
      if (busy) return;
      busy = true;
      root.classList.add('busy');
      select(null);
      const draw = strokes.length ? drawCv.toDataURL('image/png') : null;
      const payload = {
        app,
        /* só o seed (número) vai por aqui; o base64 sobe depois. Um vídeo vai só pelo id da galeria (o servidor copia-o com a capa) */
        image: !st.video && typeof st.image === 'number' ? st.image : null,
        videoId: st.video ? st.video.id : null,
        bg: st.bg ? st.bg.id : null,
        layers: st.layers.map(l => ({ id: l.id, type: l.type, x: +l.x.toFixed(4), y: +l.y.toFixed(4), scale: +(l.scale || 1).toFixed(3), rot: l.rot || 0, text: l.text || null, font: l.font || null, color: l.color || null, align: l.align || null, size: l.size || null, bg: l.bg || null, bgA: l.bgA == null ? null : l.bgA, style: l.style || null, data: l.data || null })),
        duration: st.duration, closeFriends: !!closeFriends,
        hasMedia: !!st.video || typeof st.image === 'string' || !!draw,
      };
      const r = await Bridge.rpcRaw('social.story.add', payload);
      if (!r || r.error || !r.id) {
        busy = false; root.classList.remove('busy');
        /* as recusas do vídeo têm nome (desligado, longo, grande, já não está na galeria...): window.SocialVideo (social.js) diz qual */
        const vmsg = window.SocialVideo && SocialVideo.errText ? SocialVideo.errText(r) : null;
        UI.alert({ title: 'Não publicado', msg: vmsg || (r && r.error === 'toomany' ? 'Tens stories a mais em curso.' : r && r.error === 'empty' ? 'A story está vazia.' : 'Tenta novamente.'), foot: r && r.error ? String(r.error) : undefined });
        return;
      }
      let ok = true;
      if (typeof st.image === 'string' && !st.video) ok = await upload(r.id, 'image', st.image);
      if (ok && draw) ok = await upload(r.id, 'draw', draw);
      busy = false;
      root.classList.remove('busy');
      if (!ok) {
        await Bridge.rpcRaw('social.story.delete', { app, id: r.id });   /* não deixar meia story */
        UI.alert({ title: 'Não publicado', msg: 'A imagem não subiu por inteiro.' });
        return;
      }
      Sound.play('success');
      UI.toast('Story publicada');
      root.remove();
      Bridge.emit('stories:changed', { app });
    };
    root.querySelector('.pub.own').onclick = () => publish(false);
    root.querySelector('.pub.cf').onclick = () => publish(true);

    root.querySelector('.b.x').onclick = async () => {
      if (st.layers.length || strokes.length) {
        if (!await UI.confirm('Descartar story', 'Perdes tudo o que fizeste.', 'Descartar', true)) return;
      }
      root.remove();
    };

    /* teclado: ESC fecha, Delete apaga o elemento selecionado.
       stopPropagation é obrigatório: o sistema também ouve ESC no window e FECHAVA o
       telemóvel inteiro por baixo do editor (system.js). E o Delete não pode apagar
       camadas enquanto se escreve - nem com um sub-painel aberto. */
    const onKey = e2 => {
      if (!root.isConnected) return;
      if (root.querySelector('.st-text-ov, .st-panel, .st-draw-ov')) return;
      if (e2.key === 'Escape') { e2.preventDefault(); e2.stopPropagation(); root.querySelector('.b.x').click(); }
      else if ((e2.key === 'Delete' || e2.key === 'Backspace') && sel && !/input|textarea/i.test((document.activeElement || {}).tagName || '')) { e2.preventDefault(); e2.stopPropagation(); removeLayer(sel); }
    };
    document.addEventListener('keydown', onKey);
    /* limpeza: o MutationObserver em `win` NÃO via o próprio `win` ser removido pelo
       killApp (childList só observa filhos). Ligamo-nos ao ciclo de vida da janela. */
    const destroy = () => { document.removeEventListener('keydown', onKey); previewStop(); dropPreview(); if (window.Keyboard) Keyboard.hide(); };
    const prevClose = win.onClose;
    win.onClose = () => { destroy(); prevClose && prevClose(); };
    const oldRoot = root.remove.bind(root);
    root.remove = () => { destroy(); oldRoot(); };

    refreshHint();
    return root;
  }

  /* =====================================================================
     ORIGEM DE UMA STORY - galeria, camara e texto
     ===================================================================== */
  /* Da galeria vem um objeto "leve": o conteúdo só é carregado quando alguém o vê.
     Sem isto ficávamos com `undefined` e o editor abria preto. A ordem é: conteúdo
     carregado → url já em memória → seed (gradiente das fotos de demonstração). */
  async function resolvePhoto(p) {
    if (!p) return null;
    let url = null;
    try { url = await Photos.data(p); } catch (e) {}
    if (url) return url;
    if (p.url) return p.url;
    if (typeof p.seed === 'number') return p.seed;
    return null;
  }
  /* um VÍDEO da galeria para o editor (12 nov 2026). Antes um vídeo escolhido aqui abria o editor com o webm como "fotografia" e o
     fundo ficava preto. O que o servidor vai recusar (stories em vídeo desligadas, longo ou grande demais) é dito já, com o motivo. */
  async function openVideo(app, me, win, p) {
    const SVm = window.SocialVideo;
    const bad = SVm ? await SVm.precheck(p, 'stories') : { error: 'videooff' };
    if (bad) { if (SVm) SVm.alert(bad); else UI.toast('Este servidor não permite publicar vídeos aqui.'); return null; }
    return editor(app, me, win, { video: p });
  }
  /* partilha das Fotos ("Publicar na story"): fotografia ou vídeo direto para o editor */
  async function compose(app, me, win, p) {
    if (!p) return create(app, me, win);
    if (p.video) return openVideo(app, me, win, p);
    const image = await resolvePhoto(p);
    if (!image) { UI.toast('Não consegui abrir essa fotografia'); return null; }
    return editor(app, me, win, { image });
  }

  /* =====================================================================
     "ADICIONAR À STORY" - o ecrã do Instagram, dentro da própria app

     Antes isto era uma folha de ações com três linhas ("Câmara · Galeria ·
     Criar texto") e a opção Câmara SAÍA do Instashot para abrir a app Câmara.
     Agora é o que o Instagram faz: tocar no + abre JÁ a galeria em ecrã
     inteiro, e PUXAR PARA BAIXO passa à câmara sem nunca sair da app.

     A câmara aqui É a câmara do telemóvel (js/camview.js, CamView.mount com
     chrome 'bare'): o mesmo canvas WebGL com a vista do jogo, o mesmo
     cameraMode do Lua (frontal/traseira, HUD escondido, arrastar para
     apontar) e o mesmo disparo/gravação nas Fotos da app Câmara. Só os
     botões à volta são os do Instagram. Fora do jogo o GameRender devolve um
     objeto inerte e mostra-se a cena falsa, para o harness exercitar tudo.
     ===================================================================== */
  async function create(app, me, win) {
    const cfg = await config();
    let dead = false, mode = 'gal', picking = false, cam = null;
    const picked = [];

    const root = UI.el(`<div class="ig-add">
      <!-- ---------- CÂMARA (o visor é montado aqui pelo CamView) ---------- -->
      <div class="iga-cam">
        <!-- topo igual ao do Instagram: × à esquerda, flash ao CENTRO, roda dentada à direita -->
        <!-- tamanhos medidos na referência do Instagram (1080 px) e convertidos com k=440/1080:
             × 54->22 · flash 73->30 (ao CENTRO) · roda dentada 80->33 -->
        <div class="igc-top">
          <div class="b x">${g('x', 22)}</div>
          <div class="sp"></div>
          <div class="b fl off">${g('bolt', 30)}</div>
          <div class="sp"></div>
          <div class="b st">${g('gear', 33)}</div>
        </div>
        <div class="igc-rail">
          <div class="r aa"><b>Aa</b><span>Criar</span></div>
          <div class="r fx">${g('sparkles', 24)}<span>Efeitos</span></div>
          <div class="r dn">${g('chevD', 24)}</div>
        </div>
        <div class="igc-bot">
          <div class="igc-strip"></div>
          <div class="igc-row">
            <div class="igc-gal"></div>
            <div class="igc-shut"><div></div></div>
            <div class="igc-flip">${g('repeat', 24)}</div>
          </div>
          <div class="igc-modes"><span data-k="post">PUBLICAÇÃO</span><span data-k="story" class="on">STORY</span><span data-k="reel">REEL</span></div>
        </div>
      </div>

      <!-- ---------- GALERIA ---------- -->
      <div class="iga-gal">
        <div class="igg-top">
          <div class="b x">${g('x', 22)}</div>
          <b class="tt">Adicionar à story</b>
          <div class="b st">${g('gear', 27)}</div>
        </div>
        <div class="igg-body">
          <div class="igg-pull">${g('camera', 23)}<span>Puxa para baixo para a câmara</span></div>
          <div class="igg-cards">
            <div class="c t" data-k="txt"><span class="ic">${g('textsize', 22)}</span><b>Modelos</b></div>
            <div class="c m" data-k="mus"><span class="ic">${g('music', 22)}</span><b>Música</b></div>
            <div class="c g" data-k="col"><span class="ic">${g('grid', 22)}</span><b>Colagem</b></div>
          </div>
          <div class="igg-bar"><div class="rec">Recentes ${g('chevD', 20)}</div><div class="sel">${g('layers', 20)}<span>Selecionar</span></div></div>
          <div class="igg-grid"></div>
        </div>
        <div class="igg-next"><b>Seguinte</b><span class="n">0</span></div>
      </div>
    </div>`);
    win.appendChild(root);

    const camEl = root.querySelector('.iga-cam');
    const galEl = root.querySelector('.iga-gal');
    const body = root.querySelector('.igg-body');
    const grid = root.querySelector('.igg-grid');
    const strip = root.querySelector('.igc-strip');
    const nextBtn = root.querySelector('.igg-next');

    /* ---------- fecho: uma só porta, e ligada à janela ----------
       O destroy() da câmara TEM de correr em todos os caminhos: é ele que desliga o cameraMode
       do Lua (senão o jogador ficava sem HUD e com a câmara scriptada presa a ele). */
    /* trocar de app com a câmara à vista: o System só ESCONDE a janela do Instashot (não corre o
       win.onClose) e o cameraMode ficaria ligado por baixo da app nova - volta-se à galeria, que
       desliga a câmara; quando o jogador regressar encontra a galeria, como no Instagram */
    const offGone = Bridge.on('app:close', id => {
      if (id !== app || dead) return;
      if (mode === 'cam') toGallery();
      /* e desliga JÁ, sem esperar pelo fim da animação: a janela está escondida e a app seguinte
         pode ser a própria Câmara (atalho "Selfie"), que não pode encontrar o cameraMode ligado */
      if (cam) cam.setActive(false);
    });
    const oldRemove = root.remove.bind(root);
    root.remove = () => {
      if (!dead) {
        dead = true;
        offGone();
        try { cam && cam.destroy(); } catch (e) {}
        if (io) { io.disconnect(); io = null; }
        document.removeEventListener('keydown', onKey);
      }
      oldRemove();
    };
    const close = () => { if (!dead) root.remove(); };
    const prevClose = win.onClose;
    win.onClose = () => { close(); prevClose && prevClose(); };
    const onKey = e => {
      if (!root.isConnected || dead) return;
      if (document.activeElement && document.activeElement.matches('input,textarea')) return;
      if (e.key === 'Escape') { e.preventDefault(); e.stopPropagation(); if (mode === 'cam') toGallery(); else close(); }
    };
    document.addEventListener('keydown', onKey);
    root.querySelectorAll('.b.x').forEach(b => { b.onclick = close; });

    /* =========================== VISOR ===========================
       A CÂMARA DO TELEMÓVEL, montada dentro do ecrã do Instagram (pedido do utilizador:
       "o mesmo conteúdo e forma de tirar fotos igual à app Câmara"). Tudo o que é câmara -
       canvas com a vista do jogo, cameraMode do Lua, selfie ao centro, arrastar para apontar,
       clarão, shoot() com os erros nomeados, Photos.save + aviso à galeria - é do CamView;
       os botões do Instagram à volta só chamam a API dele.
       · aspect = o do ecrã inteiro: o buffer tem o rácio da caixa, o `cover` não corta nada e
         o que se vê é exatamente o que sai (a mesma promessa da app Câmara)
       · autoActivate:false - o cameraMode só liga quando o visor fica à vista (puxar para
         baixo); escondido atrás da galeria não pode roubar o HUD ao jogador
       · aimInside:false - dentro do ecrã o arrasto para CIMA volta à galeria; apontar é com os
         outros arrastos (ver onCamMove) e fora do telemóvel, como na app Câmara */
    cam = CamView.mount(camEl, {
      chrome: 'bare',
      aspect: (camEl.clientWidth || 440) / (camEl.clientHeight || 956),
      autoActivate: false,
      aimInside: false,
      process: raw => applyFx(raw),              /* os "Efeitos" entram ANTES de a foto ser guardada */
      onShot: async (p, raw) => {
        if (dead) return;
        /* no browser o disparo pode vir só como linha da galeria (sem base64): resolve-se como
           qualquer outra fotografia da grelha */
        const image = typeof raw === 'string' && raw ? raw : await resolvePhoto(p);
        if (dead) return;
        if (!image) { UI.toast('Não consegui abrir a fotografia'); return; }
        close();
        editor(app, me, win, { image });
      },
    });

    /* =========================== GALERIA ===========================
       As fotografias descem do servidor em bocados de 48 KB e só quando a célula se aproxima do
       ecrã (Photos.lazyGrid): esta grelha mostra até 90 e pedi-las todas ao abrir era vários MB e
       90 bitmaps descodificados na memória do CEF, para se verem nove. */
    let io = null;
    /* VÍDEOS (12 nov 2026): a galeria mostra-os com a duração; tocar abre o editor com o vídeo (openVideo diz já porque não, se não puder) */
    const vBadge = p => p.video ? `<span class="cr-vbadge"><svg viewBox="0 0 24 24" width="11" height="11"><path fill="currentColor" d="M7 5v14l11.5-7z"/></svg>${UI.fmtDur(p.duration || 0)}</span>` : '';
    const pickVideo = async p => {
      const SVm = window.SocialVideo;
      const bad = SVm ? await SVm.precheck(p, 'stories') : { error: 'videooff' };
      if (bad) { if (SVm) SVm.alert(bad); else UI.toast('Este servidor não permite publicar vídeos aqui.'); return; }
      if (dead) return;
      close();
      editor(app, me, win, { video: p });
    };
    const cellOf = p => {
      const d = UI.el(`<div class="gp">${vBadge(p)}</div>`);
      d.style.backgroundImage = Photos.bg(p);
      if (io) io.observe(d, p); else Photos.lazy(d, p);
      d.onclick = async () => {
        if (picking) { if (p.video) { UI.toast('Os vídeos não entram em colagens'); return; } togglePick(p, d); return; }
        if (p.video) { pickVideo(p); return; }
        const image = await resolvePhoto(p);
        if (!image) { UI.toast('Não consegui abrir essa fotografia'); return; }
        close();
        editor(app, me, win, { image });
      };
      return d;
    };
    const togglePick = (p, d) => {
      const i = picked.indexOf(p);
      if (i > -1) { picked.splice(i, 1); d.classList.remove('on'); }
      else { if (picked.length >= 4) { UI.toast('No máximo quatro'); return; } picked.push(p); d.classList.add('on'); }
      nextBtn.classList.toggle('in', picked.length > 0);
      nextBtn.querySelector('.n').textContent = picked.length;
    };

    async function paintGrid() {
      grid.innerHTML = '';
      if (io) { io.disconnect(); io = null; }
      const cam = UI.el(`<div class="gp gcam">${g('camera', 28)}</div>`);
      cam.onclick = () => toCamera();
      grid.appendChild(cam);
      await Photos.load();
      /* os vídeos só aparecem quando o servidor deixa publicá-los em stories (Config.Recording.social.stories) */
      const vidOk = window.SocialVideo ? await SocialVideo.allow('stories') : false;
      if (dead) return;
      const list = (Photos.cache || []).filter(p => p && (vidOk || !p.video)).slice(0, 90);
      if (!list.length) { grid.appendChild(UI.el('<div class="gnone">Ainda não tens fotografias. Toca na câmara.</div>')); return; }
      io = Photos.lazyGrid ? Photos.lazyGrid(body) : null;
      const frag = document.createDocumentFragment();
      list.forEach((p, i) => { const c = cellOf(p); if (!io && i < 12) Photos.lazy(c, p); frag.appendChild(c); });
      grid.appendChild(frag);
      paintStrip(list);
    }
    function paintStrip(list) {
      strip.innerHTML = '';
      (list || []).slice(0, 8).forEach(p => {
        const d = UI.el(`<div class="th">${vBadge(p)}</div>`);
        d.style.backgroundImage = Photos.bg(p);
        Photos.lazy(d, p);
        d.onclick = async () => { if (p.video) { pickVideo(p); return; } const image = await resolvePhoto(p); if (!image) return; close(); editor(app, me, win, { image }); };
        strip.appendChild(d);
      });
      const gal = root.querySelector('.igc-gal');
      const first = (list || [])[0];
      if (first) { gal.style.backgroundImage = Photos.bg(first); Photos.lazy(gal, first); }
      gal.onclick = () => toGallery();
    }

    /* ---------- os três cartões de cima ---------- */
    root.querySelectorAll('.igg-cards .c').forEach(c => {
      c.onclick = async () => {
        const k = c.dataset.k;
        if (k === 'txt') {
          const b = (cfg.backgrounds || [])[0] || { id: 'ig', type: 'grad', a: '#833AB4', b: '#FD1D1D' };
          close();
          const ed = await editor(app, me, win, { bg: b });
          setTimeout(() => { const aa = ed.querySelector('.b.aa'); if (aa) aa.click(); }, 260);
          return;
        }
        if (k === 'mus') {
          const b = (cfg.backgrounds || [])[1] || (cfg.backgrounds || [])[0] || { id: 'ig', type: 'grad', a: '#0A84FF', b: '#00C7BE' };
          close();
          const ed = await editor(app, me, win, { bg: b });
          setTimeout(() => { const mu = ed.querySelector('.b.mus'); if (mu) mu.click(); }, 260);
          return;
        }
        /* colagem: escolhe-se 2 a 4 fotografias e compõem-se numa só imagem */
        picking = true;
        root.classList.add('picking');
        root.querySelector('.igg-bar .sel').classList.add('on');
        UI.toast('Escolhe 2 a 4 fotografias');
      };
    });
    root.querySelector('.igg-bar .sel').onclick = () => {
      picking = !picking;
      root.classList.toggle('picking', picking);
      root.querySelector('.igg-bar .sel').classList.toggle('on', picking);
      if (!picking) { picked.length = 0; nextBtn.classList.remove('in'); grid.querySelectorAll('.gp.on').forEach(x => x.classList.remove('on')); }
    };
    nextBtn.onclick = async () => {
      if (picked.length < 2) { UI.toast('Escolhe pelo menos duas'); return; }
      nextBtn.classList.add('busy');
      const image = await collage(picked);
      nextBtn.classList.remove('busy');
      if (!image) { UI.toast('Não consegui fazer a colagem'); return; }
      close();
      editor(app, me, win, { image });
    };

    /* Colagem: 2 = metades, 3 = uma grande + duas, 4 = quadrantes. Feita em canvas,
       por isso o que sai é UMA fotografia normal e o editor trata-a como qualquer outra. */
    async function collage(list) {
      const W = 720, H = 1280;
      const cv = document.createElement('canvas'); cv.width = W; cv.height = H;
      const cx = cv.getContext('2d');
      cx.fillStyle = '#000'; cx.fillRect(0, 0, W, H);
      const boxes = list.length === 2 ? [[0, 0, W, H / 2], [0, H / 2, W, H / 2]]
        : list.length === 3 ? [[0, 0, W, H / 2], [0, H / 2, W / 2, H / 2], [W / 2, H / 2, W / 2, H / 2]]
        : [[0, 0, W / 2, H / 2], [W / 2, 0, W / 2, H / 2], [0, H / 2, W / 2, H / 2], [W / 2, H / 2, W / 2, H / 2]];
      for (let i = 0; i < list.length && i < boxes.length; i++) {
        const url = await resolvePhoto(list[i]);
        if (typeof url !== 'string') continue;
        const im = await new Promise(res => { const x = new Image(); x.onload = () => res(x); x.onerror = () => res(null); x.src = url; });
        if (!im) continue;
        const [bx, by, bw, bh] = boxes[i];
        /* cover: recorta o excedente em vez de esticar */
        const s = Math.max(bw / im.width, bh / im.height);
        const dw = im.width * s, dh = im.height * s;
        cx.save(); cx.beginPath(); cx.rect(bx, by, bw, bh); cx.clip();
        cx.drawImage(im, bx + (bw - dw) / 2, by + (bh - dh) / 2, dw, dh);
        cx.restore();
      }
      try { return Photos.fromCanvas(cv, .88); } catch (e) { return null; }
    }

    /* ============== PUXAR PARA BAIXO → CÂMARA ==============
       Como no Instagram: a câmara NÃO aparece de repente no fim do gesto - vai sendo
       REVELADA por baixo da galeria à medida que o dedo desce, e o visor já está vivo
       durante o arrasto. Largar continua a animação para o lado mais perto; não salta.

       Tudo o que se move aqui é `transform` e `opacity` (regra de CEF deste projeto).
       Durante o arrasto as transições estão desligadas (.pulling) porque quem manda é o
       dedo; ao largar voltam a ligar e o mesmo setReveal() faz a animação até ao fim. */
    const PULL_GO = 96;                 /* a partir daqui, largar assume a câmara */
    const PULL_FULL = 210;              /* distância a que a câmara fica revelada a 100 % */
    let pull = null, reveal = 0;

    const setReveal = r => {
      reveal = r < 0 ? 0 : r > 1 ? 1 : r;
      const H = galEl.offsetHeight || 956;
      /* a galeria segue o dedo com resistência e, no fim, sai por baixo do ecrã */
      galEl.style.transform = 'translateY(' + (reveal * H).toFixed(1) + 'px)';
      galEl.style.opacity = (1 - reveal * .35).toFixed(3);
      /* a câmara cresce e ganha corpo por trás - é isto que dá a sensação de profundidade */
      camEl.style.opacity = reveal.toFixed(3);
      camEl.style.transform = 'scale(' + (.9 + .1 * reveal).toFixed(4) + ')';
      root.classList.toggle('ready', reveal > PULL_GO / PULL_FULL);
    };
    setReveal(0);

    body.addEventListener('pointerdown', e => {
      if (body.scrollTop > 2 || picking || mode !== 'gal') return;
      pull = { y: e.clientY, on: false, id: e.pointerId };
    });
    body.addEventListener('pointermove', e => {
      if (!pull) return;
      const dy = e.clientY - pull.y;
      if (!pull.on) {
        if (dy <= 6) return;
        pull.on = true;
        root.classList.add('pulling');
        /* ⚠️ A CAPTURA DO PONTEIRO SÓ AQUI, NUNCA NO pointerdown.
           Capturar no pointerdown reencaminha o `click` para o elemento que captura - era
           por isso que TOCAR NUMA FOTOGRAFIA não fazia nada: o clique ia parar à caixa de
           scroll em vez de chegar à célula. (O mesmo bug que o .sheet-head já teve.)
           A capturar só depois de o arrasto começar, o toque simples fica intacto e o
           arrasto continua a receber o pointerup mesmo que o dedo saia da caixa. */
        try { body.setPointerCapture(e.pointerId); } catch (x) {}
        /* o visor acorda AGORA, não no fim: quem puxa já vê o jogo a aparecer (e é aqui que
           o cameraMode do Lua liga - largar antes do limiar volta a desligá-lo em toGallery) */
        cam.setActive(true);
      }
      setReveal(dy / PULL_FULL);
    });
    const endPull = e => {
      if (!pull) return;
      const dy = (e && e.clientY != null ? e.clientY : pull.y) - pull.y;
      const moved = pull.on;
      try { if (e && e.pointerId != null) body.releasePointerCapture(e.pointerId); } catch (x) {}
      pull = null;
      root.classList.remove('pulling');          /* transições outra vez ligadas */
      if (!moved) return;
      if (dy > PULL_GO) toCamera(); else toGallery();
    };
    body.addEventListener('pointerup', endPull);
    body.addEventListener('pointercancel', endPull);
    /* a roda do rato também serve: no NUI é o gesto natural */
    body.addEventListener('wheel', e => { if (body.scrollTop <= 0 && e.deltaY < -40 && mode === 'gal') toCamera(); }, { passive: true });

    /* ============== E O CAMINHO DE VOLTA: ARRASTAR PARA CIMA ==============
       Estando na câmara, puxar para CIMA traz a galeria de volta - o inverso exato do
       gesto de descida, com a mesma revelação progressiva. Nunca sai para o feed da app:
       só troca entre os dois ecrãs de criação. */
    /* E APONTAR, como na app Câmara: arrastar para o LADO ou para BAIXO dentro do visor roda a
       vista do jogo (cameraDrag no Lua, botão esquerdo em baixo); só o arrasto para CIMA é o
       gesto de voltar à galeria. Decide-se aos primeiros 6 px - antes disso um toque simples
       chega aos botões sem interferência. Fora do telemóvel o CamView aponta sozinho. */
    let up = null;
    const onCamDown = e => {
      if (mode !== 'cam' || dead) return;
      /* o dedo em cima de um botão é do botão, não do gesto */
      if (e.target.closest('.igc-top, .igc-rail, .igc-bot')) return;
      up = { x: e.clientX, y: e.clientY, on: false, aim: false };
    };
    const onCamMove = e => {
      if (!up) return;
      if (up.aim) { cam.aimMove(e); return; }
      const dy = up.y - e.clientY;                 /* positivo = a subir */
      const dx = e.clientX - up.x;
      if (!up.on) {
        if (dy > 6) {
          /* captura só depois de arrastar, pela mesma razão de cima: senão o obturador e os
             botões do visor deixavam de receber o clique */
          up.on = true; root.classList.add('pulling'); try { camEl.setPointerCapture(e.pointerId); } catch (x) {}
        } else if (Math.abs(dx) > 6 || dy < -6) {
          /* não é para cima: é apontar - daqui até largar o botão quem manda é a câmara */
          up.aim = true; cam.aimStart(e); cam.aimMove(e); return;
        } else return;
      }
      setReveal(1 - dy / PULL_FULL);
    };
    const onCamUp = e => {
      if (!up) return;
      if (up.aim) { up = null; return; }         /* o CamView larga o arrasto no pointerup do documento */
      const dy = up.y - (e && e.clientY != null ? e.clientY : up.y);
      const moved = up.on;
      try { if (e && e.pointerId != null) camEl.releasePointerCapture(e.pointerId); } catch (x) {}
      up = null;
      root.classList.remove('pulling');
      if (!moved) return;
      if (dy > PULL_GO) toGallery(); else toCamera();
    };
    camEl.addEventListener('pointerdown', onCamDown);
    camEl.addEventListener('pointermove', onCamMove);
    camEl.addEventListener('pointerup', onCamUp);
    camEl.addEventListener('pointercancel', onCamUp);
    camEl.addEventListener('wheel', e => { if (mode === 'cam' && e.deltaY > 40) toGallery(); }, { passive: true });

    function toCamera() {
      if (dead) return;
      mode = 'cam';
      root.classList.add('cam');
      root.classList.remove('pulling');
      cam.setActive(true);                       /* visor a correr + cameraMode do Lua ligado */
      setReveal(1);                              /* a transição do CSS leva-a até ao fim */
      Sound.play('click');
    }
    function toGallery() {
      if (dead) return;
      const wasCam = mode === 'cam';
      mode = 'gal';
      root.classList.remove('cam', 'ready', 'pulling');
      setReveal(0);
      /* o visor só adormece DEPOIS de a animação acabar, senão congelava a meio do caminho;
         é aí que o cameraMode do Lua desliga e o HUD do jogador volta */
      clearTimeout(toGallery._t);
      toGallery._t = setTimeout(() => { if (mode === 'gal' && !dead) cam.setActive(false); }, wasCam ? 420 : 360);
      win.timers && win.timers.push(toGallery._t);
    }
    root.querySelector('.igc-rail .dn').onclick = toGallery;

    /* ---------- barra de modos: PUBLICAÇÃO · STORY · REEL ---------- */
    root.querySelectorAll('.igc-modes span').forEach(s => {
      s.onclick = () => {
        const k = s.dataset.k;
        if (k === 'story') return;
        close();
        Bridge.emit('instashot:compose', { app, kind: k });
      };
    });

    /* ---------- "Aa Criar" e "Efeitos" ---------- */
    root.querySelector('.igc-rail .aa').onclick = async () => {
      const b = (cfg.backgrounds || [])[0] || { id: 'ig', type: 'grad', a: '#833AB4', b: '#FD1D1D' };
      close();
      const ed = await editor(app, me, win, { bg: b });
      setTimeout(() => { const aa = ed.querySelector('.b.aa'); if (aa) aa.click(); }, 260);
    };
    /* Efeitos: filtros de cor aplicados à fotografia DEPOIS de tirada (é o que dá para
       fazer a sério - não há vídeo ao vivo no NUI para efeitos em tempo real). */
    let fx = 0;
    const FX = [
      { id: 0, label: 'Normal' }, { id: 1, label: 'Preto e branco' }, { id: 2, label: 'Quente' },
      { id: 3, label: 'Frio' }, { id: 4, label: 'Vivo' }, { id: 5, label: 'Desvanecido' },
    ];
    root.querySelector('.igc-rail .fx').onclick = async () => {
      const r = await UI.picker('Efeito', FX.map(f => f.label), FX[fx].label);
      if (!r) return;
      const i = FX.findIndex(f => f.label === r);
      if (i > -1) { fx = i; root.querySelector('.igc-rail .fx span').textContent = FX[i].label; }
    };
    const applyFx = raw => {
      if (!fx || typeof raw !== 'string') return Promise.resolve(raw);
      return new Promise(res => {
        const im = new Image();
        im.onload = () => {
          try {
            const cv = document.createElement('canvas'); cv.width = im.width; cv.height = im.height;
            const cx = cv.getContext('2d'); cx.drawImage(im, 0, 0);
            const d = cx.getImageData(0, 0, cv.width, cv.height), a = d.data;
            for (let i = 0; i < a.length; i += 4) {
              let r0 = a[i], g0 = a[i + 1], b0 = a[i + 2];
              if (fx === 1) { const y = (r0 * .299 + g0 * .587 + b0 * .114); r0 = g0 = b0 = y; }
              else if (fx === 2) { r0 = Math.min(255, r0 * 1.12); b0 = b0 * .92; }
              else if (fx === 3) { b0 = Math.min(255, b0 * 1.14); r0 = r0 * .93; }
              else if (fx === 4) { r0 = Math.min(255, (r0 - 128) * 1.22 + 128); g0 = Math.min(255, (g0 - 128) * 1.22 + 128); b0 = Math.min(255, (b0 - 128) * 1.22 + 128); }
              else if (fx === 5) { r0 = r0 * .88 + 26; g0 = g0 * .88 + 24; b0 = b0 * .88 + 20; }
              a[i] = r0; a[i + 1] = g0; a[i + 2] = b0;
            }
            cx.putImageData(d, 0, 0);
            res(Photos.fromCanvas(cv, .9) || raw);
          } catch (e) { res(raw); }
        };
        im.onerror = () => res(raw);
        im.src = raw;
      });
    };

    /* ---------- flash, virar e disparo: são os da app Câmara (CamView) ---------- */
    root.querySelector('.igc-top .fl').onclick = e => { cam.setFlash(!cam.flash); e.currentTarget.classList.toggle('off', !cam.flash); };
    root.querySelector('.igc-flip').onclick = () => { cam.flip(); UI.toast(cam.front ? 'Câmara frontal' : 'Câmara traseira'); };
    /* O OBTURADOR é o mesmo shoot() da app Câmara: shotBegin (esconde o cursor do jogo), frame
       fresco do canvas, erros nomeados, Photos.save aos bocados, aviso à galeria, "Foto guardada".
       Os Efeitos entram pelo `process` e o editor abre no `onShot` (ver o mount, em cima). */
    root.querySelector('.igc-shut').onclick = () => { if (dead || mode !== 'cam') return; cam.shoot(); };

    paintGrid();
    /* rAF + rede de segurança: se o frame não vier (headless, CEF sob carga), o ecrã ficava
       com opacity 0 e o utilizador tocava no + e não acontecia nada. O `in` tem de entrar. */
    let shown = false;
    const show = () => { if (shown || dead) return; shown = true; root.classList.add('in'); };
    requestAnimationFrame(show);
    setTimeout(show, 120);
    return root;
  }

  /* =====================================================================
     VISUALIZADOR
     ===================================================================== */
  function open(app, me, win, groups, startIdx, hooks = {}) {
    groups = (groups || []).filter(gr => gr.items && gr.items.length);
    if (!groups.length) return null;
    config();   /* garante os fundos em cache; o visualizador não espera por eles */
    let gi = clamp(startIdx || 0, 0, groups.length - 1), ii = 0;
    let timer = null, paused = false, liked = false, media = {};
    const mediaSeq = [];   /* ordem de chegada da media em cache (ver paint) */

    const v = UI.el(`<div class="story-view sv2">
      <div class="sv-img"></div><canvas class="sv-draw" width="440" height="956"></canvas><div class="sv-layers"></div>
      <div class="sv-bars"></div>
      <div class="sv-top"><div class="who"></div><div class="mo">${g('more', 23)}</div><div class="cl">${g('x', 23)}</div></div>
      <div class="sv-tap l"></div><div class="sv-tap r"></div>
      <div class="sv-foot"><input type="text" class="rp" placeholder="Enviar mensagem…" maxlength="200"><div class="hb">${g('heart', 24)}</div><div class="sd">${g('send', 24)}</div></div>
      <div class="sv-own"></div></div>`);
    win.appendChild(v);
    const dctx = v.querySelector('.sv-draw').getContext('2d');

    let gen = 0;         /* geração: um paint() que demore não pode ressuscitar um fecho */
    let dead = false;
    /* FORA DE CENA: sair da app (o System só esconde a janela - o win.onClose só corre no killApp),
       guardar o telemóvel ou bloqueá-lo. O temporizador continuava a avançar stories invisíveis:
       ~9 RPC por story (get + bocados da media + view), a marcá-las como vistas e com a música do
       sticker a tocar de telemóvel guardado. Agora pára e retoma onde ficou quando volta à vista. */
    let hidden = false;
    const onStage = () => !win.classList.contains('bg') && !document.body.classList.contains('hidden') && !(window.System && System.locked);
    const goHidden = () => { if (dead || hidden) return; hidden = true; pauseTick(); previewStop(); v.classList.add('paused'); };
    const goShown = () => {
      if (dead || !hidden || !onStage()) return;
      hidden = false;
      if (!paused) v.classList.remove('paused');
      resumeTick();
    };
    const offs = [
      Bridge.on('app:close', id => { if (id === win.appId) goHidden(); }),
      Bridge.on('phone:close', goHidden),
      Bridge.on('lock', goHidden),
      Bridge.on('app:open', id => { if (id === win.appId) goShown(); }),
      Bridge.on('phone:open', goShown),
      Bridge.on('unlock', goShown),
    ];
    const stop = () => { clearTimeout(timer); timer = null; };
    const close = () => {
      if (dead) return;
      dead = true; gen++;
      stop(); clearTimeout(holdT); previewStop(); dropVid();
      offs.forEach(f => f());
      document.removeEventListener('keydown', onKey);
      v.classList.add('out'); setTimeout(() => v.remove(), 200);
      /* ANEL DA BOLHA: ao sair, a barra de stories tem de deixar de mostrar o anel colorido de quem já se viu.
         O `it.seen = true` só mudava a lista em memória DESTE visualizador; a barra (social.js storiesRow) só
         se repinta no evento 'stories:changed'. Marca-se o grupo como visto e pede-se o repintar. */
      try {
        (groups || []).forEach(gr => { if (Array.isArray(gr.items)) gr.allSeen = gr.items.every(x => x.seen); });
        Bridge.emit('stories:changed', { app, seen: true });
      } catch (e) {}
      hooks.onClose && hooks.onClose();
    };
    /* o sistema mata a janela (switcher, "fechar tudo", LRU das 7 apps) sem passar por aqui:
       sem isto o temporizador continuava a avançar stories invisíveis e a marcá-las como vistas */
    const prevClose = win.onClose;
    win.onClose = () => { close(); prevClose && prevClose(); };
    v.querySelector('.cl').onclick = close;

    /* pausar tem de GUARDAR o que falta: antes, largar o dedo recomeçava a story do zero */
    let tStart = 0, tLeft = 0;
    /* STORY EM VÍDEO (12 nov 2026): `svp` = o leitor (window.SocialVideo) da story à vista. A barra fica parada (.sv-wait) enquanto o
       vídeo desce e só arranca quando ele começa a tocar; o fim do vídeo passa à seguinte; manter carregado, sair da app ou guardar
       o telemóvel pausam o vídeo com a barra; mudar de story larga o vídeo. `svWait` = ainda não arrancou (o temporizador espera por ele). */
    let svp = null, svWait = false;
    const dropVid = () => { if (svp) { svp.destroy(); svp = null; } svWait = false; v.classList.remove('sv-wait'); };
    const schedule = secs => { stop(); tLeft = (secs || 5) * 1000; tStart = Date.now(); if (paused || hidden) return; timer = setTimeout(next, tLeft); };
    const pauseTick = () => { if (timer) tLeft = clamp(tLeft - (Date.now() - tStart), 250, 60000); stop(); if (svp) svp.pause(); };
    const resumeTick = () => { stop(); if (dead || paused || hidden) return; if (svp) svp.play(); if (svWait) return; tStart = Date.now(); timer = setTimeout(next, tLeft); };
    const next = () => {
      const gr = groups[gi];
      if (ii < gr.items.length - 1) { ii++; paint(); return; }
      if (gi < groups.length - 1) { gi++; ii = 0; paint(); return; }
      close();
    };
    const prev = () => {
      if (ii > 0) { ii--; paint(); return; }
      if (gi > 0) { gi--; ii = 0; paint(); return; }
      paint();
    };

    /* ---------- sondagem ----------
       Deixaram de ser um desenho: o voto vai para o servidor, um por pessoa, e a
       barra de cada opção mostra a percentagem assim que se vota (ou logo, a quem
       publicou a story). */
    function showPoll(e, l, tally, mine, reveal) {
      const opts = e.querySelectorAll('.st-card .opts span');
      if (opts.length < 2) return;
      const n = (tally && tally.n) || 0;
      const cnt = [(tally && tally.a) || 0, (tally && tally.b) || 0];
      const labels = [(l.data && l.data.a) || 'Sim', (l.data && l.data.b) || 'Não'];
      const voted = mine && mine.choice != null;
      opts.forEach((s, k) => {
        s.classList.toggle('me', !!voted && mine.choice === k);
        if (voted || reveal) {
          const pct = n ? Math.round(cnt[k] / n * 100) : 0;
          s.classList.add('res');
          s.style.setProperty('--p', pct + '%');
          s.innerHTML = `<b>${pct}%</b><span>${esc(labels[k])}</span>`;
        } else {
          s.classList.remove('res');
          s.textContent = labels[k];
        }
      });
    }
    function bindPoll(e, l, it, gr, tally, mine) {
      const state = { tally: tally ? { a: tally.a || 0, b: tally.b || 0, n: tally.n || 0 } : { a: 0, b: 0, n: 0 }, mine: mine || null };
      showPoll(e, l, state.tally, state.mine, !!gr.mine);
      if (gr.mine) return;                                   /* quem publicou não vota */
      const opts = e.querySelectorAll('.st-card .opts span');
      opts.forEach((s, k) => {
        s.onclick = async ev => {
          ev.stopPropagation();
          if (state.mine && state.mine.choice === k) return;
          /* pinta já e corrige depois: no NUI o RPC leva sempre um bocado */
          if (state.mine && state.mine.choice != null) { state.tally[state.mine.choice === 0 ? 'a' : 'b']--; } else state.tally.n++;
          state.tally[k === 0 ? 'a' : 'b']++;
          state.mine = { choice: k };
          showPoll(e, l, state.tally, state.mine, false);
          Sound.play('pop');
          pauseTick();
          const r = await rpc('social.story.answer', { app, id: it.id, layer: l.id, choice: k });
          if (!r || r.error) UI.toast('Não consegui votar');
          if (media[it.id]) { media[it.id].polls = media[it.id].polls || {}; media[it.id].polls[l.id] = state.tally; media[it.id].myAnswers = media[it.id].myAnswers || {}; media[it.id].myAnswers[l.id] = state.mine; }
          resumeTick();
        };
      });
    }

    /* ---------- pergunta ---------- */
    function bindQuestion(e, l, it, gr, mine) {
      const ans = e.querySelector('.st-card .ans');
      if (!ans) return;
      if (gr.mine) {
        ans.textContent = 'Ver respostas';
        e.onclick = async ev => {
          ev.stopPropagation();
          pauseTick();
          const rows = (await rpc('social.story.answers', { app, id: it.id })) || [];
          const mineRows = (Array.isArray(rows) ? rows : []).filter(r => r.layer === l.id && r.answer);
          stop();
          hooks.onAnswers ? hooks.onAnswers(l, mineRows) : UI.alert({
            title: (l.data && l.data.q) || 'Respostas',
            msg: mineRows.length ? mineRows.slice(0, 12).map(r => '@' + r.username + ': ' + r.answer).join('\n') : 'Ainda ninguém respondeu.',
          });
          resumeTick();
        };
        return;
      }
      if (mine && mine.answer) { ans.textContent = mine.answer; ans.classList.add('done'); }
      e.onclick = async ev => {
        ev.stopPropagation();
        pauseTick();
        const t = await UI.prompt((l.data && l.data.q) || 'Responder', '', 'A tua resposta', (mine && mine.answer) || '');
        if (t && t.trim()) {
          const r = await rpc('social.story.answer', { app, id: it.id, layer: l.id, answer: t.trim().slice(0, 200) });
          if (!r || r.error) UI.toast('Não consegui enviar');
          else { ans.textContent = t.trim(); ans.classList.add('done'); UI.toast('Resposta enviada'); Sound.play('pop'); }
        }
        resumeTick();
      };
    }

    /* media aos bocados, como as Fotos: o story.get traz só o tamanho */
    async function fetchMedia(id, which, len, chunk) {
      if (!len) return null;
      const total = Math.ceil(len / (chunk || 48000));
      if (total > 64) return null;
      let out = '';
      for (let i = 1; i <= total; i++) {
        const r = await rpc('social.story.media', { id, which, i });
        if (!r || r.error || typeof r.data !== 'string') return null;
        out += r.data;
      }
      return out;
    }

    async function paint() {
      const myGen = ++gen;
      const gr = groups[gi], it = gr.items[ii];
      stop();                       /* nunca deixar um temporizador antigo a correr */
      dropVid();                    /* o vídeo da story anterior sai (o <video> e a descida) */
      liked = false;
      const bars = v.querySelector('.sv-bars');
      bars.innerHTML = gr.items.map((_, k) => `<div class="b ${k < ii ? 'done' : ''}"><span class="${k === ii ? 'run' : ''}"></span></div>`).join('');
      /* a barra arranca JÁ, com a duração que a lista conhece: à espera da media ela
         corria os 5 s por omissão e depois dava um salto quando a media chegasse */
      const durNow = it.duration || (CFG && CFG.duration) || 5;
      const runBar = bars.querySelector('.run');
      if (runBar) runBar.style.setProperty('--dur', durNow + 's');
      v.querySelector('.who').innerHTML = `${UI.avatar({ name: gr.author, avatar: gr.avatar, url: gr.avatarUrl }, 'xs')}<b>${esc(gr.author)}</b><span class="tm">${UI.timeAgo(it.created)}</span>`;
      v.querySelector('.who b').onclick = () => { close(); hooks.onUser && hooks.onUser(gr.author); };
      v.querySelector('.hb').innerHTML = g('heart', 24);
      v.querySelector('.hb').classList.remove('on');
      v.classList.toggle('is-mine', !!gr.mine);

      /* a media de cada story vem à peça (a lista não a traz) */
      let full = media[it.id];
      if (!full) {
        full = await rpc('social.story.get', { app, id: it.id }) || {};
        if (myGen !== gen || dead) return;                 /* fecharam/navegaram durante o RPC */
        full.image = await fetchMedia(it.id, 'image', full.imageLen, full.chunk);
        if (myGen !== gen || dead) return;
        full.draw = await fetchMedia(it.id, 'draw', full.drawLen, full.chunk);
        if (myGen !== gen || dead) return;
        media[it.id] = full;
        /* só as 4 mais recentes ficam em memória: cada uma guarda a foto em base64 (200-350 KB) e o PNG
           do desenho, e ver 30 stories seguidas retinha tudo até fechar. Voltar uma ou duas atrás
           continua instantâneo; mais do que isso volta a descer do servidor. */
        mediaSeq.push(it.id);
        while (mediaSeq.length > 4) delete media[mediaSeq.shift()];
      }
      const bgDef = ((CFG && CFG.backgrounds) || []).find(b => b.id === (full.bg || it.bg));
      const img = v.querySelector('.sv-img');
      if (full.image) { img.style.background = ''; img.style.backgroundImage = imgCss(full.image); img.style.backgroundSize = 'cover'; img.style.backgroundPosition = 'center'; }
      else { img.style.backgroundImage = ''; img.style.background = bgCss(bgDef) || '#111'; }

      dctx.clearRect(0, 0, 440, 956);
      /* a imagem do desenho carrega em diferido: sem a guarda de geração, o desenho da
         story ANTERIOR pintava-se por cima da nova */
      if (full.draw) { const im = new Image(); im.onload = () => { if (myGen !== gen || dead) return; try { dctx.drawImage(im, 0, 0, 440, 956); } catch (e) {} }; im.src = full.draw; }

      const box = v.querySelector('.sv-layers');
      box.innerHTML = '';
      let layers = Array.isArray(full.layers) ? full.layers : null;
      /* compatibilidade: stories antigas só tinham texto nas colunas soltas */
      if ((!layers || !layers.length) && (full.text || it.text)) layers = [{ id: 'legacy', type: 'text', x: full.tx || .5, y: full.ty || .5, scale: 1, rot: 0, size: full.tsize || 28, color: full.tcolor || '#fff', text: full.text || it.text }];
      /* sondagens e perguntas: contagens do servidor + o que EU já respondi */
      const tallies = (full.polls && typeof full.polls === 'object') ? full.polls : {};
      const myAns = (full.myAnswers && typeof full.myAnswers === 'object') ? full.myAnswers : {};
      (layers || []).forEach(l => {
        const e = layerEl(l, { clickable: true });
        if (l.type === 'mention') e.onclick = () => { close(); hooks.onUser && hooks.onUser(String(l.text || '').replace('@', '')); };
        if (l.type === 'hashtag') e.onclick = () => { close(); hooks.onTag && hooks.onTag(String(l.text || '').replace('#', '')); };
        if (l.type === 'poll') bindPoll(e, l, it, gr, tallies[l.id], myAns[l.id]);
        if (l.type === 'question') bindQuestion(e, l, it, gr, myAns[l.id]);
        box.appendChild(e);
      });

      v.querySelector('.sv-own').innerHTML = '';   /* senão o botão apagar ficava ligado ao item anterior */
      if (gr.mine) {
        rpc('social.story.viewers', { app, id: it.id }).then(vs => {
          if (myGen !== gen || dead) return;
          vs = Array.isArray(vs) ? vs : [];
          const b2 = v.querySelector('.sv-own');
          b2.innerHTML = `<div class="vw">${g('eye', 21)} ${vs.length} ${vs.length === 1 ? 'visualização' : 'visualizações'}</div><div class="dl">${g('trash', 21)}</div>`;
          b2.querySelector('.vw').onclick = () => { stop(); hooks.onViewers && hooks.onViewers(vs); close(); };
          b2.querySelector('.dl').onclick = async () => {
            pauseTick();
            if (!await UI.confirm('Apagar story', 'Deixa de estar visível para toda a gente.', 'Apagar', true)) { resumeTick(); return; }
            await rpc('social.story.delete', { app, id: it.id });
            close(); Bridge.emit('stories:changed', { app });
          };
        });
      }
      /* ver a própria story não conta como visualização - no Instagram também não */
      if (!gr.mine) rpc('social.story.view', { app, id: it.id });
      it.seen = true;
      const dur = it.duration || full.duration || (CFG && CFG.duration) || 5;
      if (runBar && dur !== durNow) runBar.style.setProperty('--dur', dur + 's');
      /* o sticker de música toca de verdade, pelo motor da própria app de Música.
         Se já estiveres a ouvir alguma coisa, a story NÃO te rouba o leitor. */
      previewStop();
      const mus = (layers || []).find(l => l.type === 'music' && l.data);
      const busy = !!(window.Music && Music.MU && Music.MU.playing);
      /* numa story em vídeo o som é o do vídeo: o sticker de música não toca por cima */
      if (mus && !busy && !hidden && !full.video) previewPlay(mus.data, mus.data.start || 0, Math.max(dur, mus.data.len || 15));
      if (full.video && window.SocialVideo) {
        /* a capa já está no fundo; o vídeo desce agora (é a story à vista) e a barra espera por ele */
        svWait = true; v.classList.add('sv-wait');
        const ok = () => myGen === gen && !dead;
        svp = SocialVideo.player(img, full.video, { bare: true, offscreen: false, loop: false,
          onPlaying: () => { if (!ok() || !svWait) return; svWait = false; v.classList.remove('sv-wait'); schedule(dur + .6); },
          onEnded: () => { if (ok() && !paused && !hidden) next(); },
          onError: () => { if (!ok()) return; svWait = false; v.classList.remove('sv-wait'); schedule(dur); } });
        tLeft = (dur + .6) * 1000;
        if (!paused && !hidden && svp) svp.play();
        return;
      }
      schedule(dur);
    }

    /* manter carregado pausa; ao largar NÃO pode avançar. O `click` dispara depois do
       pointerup, por isso guarda-se um sinal que o onclick consome. */
    let holdT = null, held = false, swallow = false;
    v.querySelector('.sv-tap.r').onclick = () => { if (swallow) { swallow = false; return; } next(); };
    v.querySelector('.sv-tap.l').onclick = () => { if (swallow) { swallow = false; return; } prev(); };
    const down = () => { held = false; holdT = setTimeout(() => { held = true; paused = true; pauseTick(); v.classList.add('paused'); }, 240); };
    const up = e2 => {
      clearTimeout(holdT);
      if (!held) return;
      held = false; swallow = true;
      paused = false; if (!hidden) v.classList.remove('paused');
      resumeTick();                                   /* retoma no ponto onde parou */
      e2.preventDefault(); e2.stopPropagation();
    };
    ['.sv-tap.l', '.sv-tap.r'].forEach(s => { const el = v.querySelector(s); el.addEventListener('pointerdown', down); el.addEventListener('pointerup', up); el.addEventListener('pointercancel', () => { clearTimeout(holdT); held = false; }); });
    /* o arrasto termina com um pointerup que ainda gera `click` na zona de toque:
       sem engolir esse clique, deslizar saltava DUAS pessoas de uma vez */
    UI.swipe(v, {
      left: () => { swallow = true; if (gi < groups.length - 1) { gi++; ii = 0; paint(); } else close(); },
      right: () => { swallow = true; if (gi > 0) { gi--; ii = 0; paint(); } },
      down: () => { swallow = true; close(); }, threshold: 45,
    });

    const hb = v.querySelector('.hb');
    hb.onclick = () => {
      liked = !liked;
      hb.innerHTML = g(liked ? 'heartFill' : 'heart', 22);
      hb.classList.toggle('on', liked);
      rpc('social.story.view', { app, id: groups[gi].items[ii].id, liked });
      if (liked) Sound.play('pop');
    };
    v.querySelector('.mo').onclick = async () => {
      pauseTick();
      const gr = groups[gi], it = gr.items[ii];
      const share = { label: 'Enviar a alguém', icon: 'send', value: 'share' };
      const r = await UI.actionSheet({ title: '', buttons: gr.mine
        ? [share, { label: 'Apagar story', icon: 'trash', danger: true, value: 'del' }]
        : [{ label: 'Ver perfil', icon: 'personCircle', value: 'prof' }, share] });   /* "Denunciar" saiu (2026-09-20): a denúncia não ia a lado nenhum */
      if (r === 'del') { await rpc('social.story.delete', { app, id: it.id }); close(); Bridge.emit('stories:changed', { app }); return; }
      if (r === 'prof') { close(); hooks.onUser && hooks.onUser(gr.author); return; }
      if (r === 'share') {
        const t = await UI.prompt('Enviar story', 'Nome de utilizador', 'username');
        if (t) {
          const u = String(t).replace(/^@/, '').trim().toLowerCase();
          const found = (await rpc('social.search', { app, q: u })) || [];
          const hit = found.find(x => x.username === u) || found[0];
          if (!hit) UI.toast('Não encontrei essa conta');
          else { await rpc('messages.send', { to: hit.username, type: 'text', content: 'Vê a story de @' + gr.author, app }); UI.toast('Story enviada'); }
        }
        resumeTick(); return;
      }
      resumeTick();
    };
    const rp = v.querySelector('.rp'), sd = v.querySelector('.sd');
    rp.onfocus = () => { paused = true; pauseTick(); v.classList.add('paused'); };
    rp.onblur = () => { paused = false; if (!hidden) v.classList.remove('paused'); resumeTick(); };   /* guardar o telemóvel também tira o foco: fora de cena a barra fica parada */
    const sendReply = async () => {
      const t = rp.value.trim(); if (!t) return;
      rp.value = ''; rp.blur();
      await rpc('messages.send', { to: groups[gi].author, type: 'text', content: t, app });
      UI.toast('Resposta enviada');
    };
    sd.onclick = sendReply;
    rp.onkeydown = e2 => { if (e2.key === 'Enter') sendReply(); };

    /* teclado, útil no NUI e em desenvolvimento */
    const onKey = e2 => {
      if (!v.isConnected || dead) return;
      /* a escrever a resposta, as setas são do campo e o ESC só o larga */
      const typing = document.activeElement && document.activeElement.matches('input,textarea');
      if (typing) { if (e2.key === 'Escape') { e2.preventDefault(); e2.stopPropagation(); document.activeElement.blur(); } return; }
      /* stopPropagation: sem ele o sistema também apanha o ESC e fecha o telemóvel inteiro */
      if (e2.key === 'ArrowRight') { e2.preventDefault(); e2.stopPropagation(); next(); }
      else if (e2.key === 'ArrowLeft') { e2.preventDefault(); e2.stopPropagation(); prev(); }
      else if (e2.key === 'Escape') { e2.preventDefault(); e2.stopPropagation(); close(); }
    };
    document.addEventListener('keydown', onKey);

    paint();
    return v;
  }

  return { config, create, open, editor, compose, layerEl, FONTS, COLORS };
})();
