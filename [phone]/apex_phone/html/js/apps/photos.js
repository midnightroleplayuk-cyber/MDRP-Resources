/* ===================== FOTOS + CÂMARA (GameRender) =====================
   O visor da Câmara é uma <canvas> WebGL com a vista do JOGO lá dentro (js/gamerender.js).
   A foto é EXATAMENTE esse canvas (toDataURL): não há screenshot do ecrã, o telemóvel fica
   VISÍVEL e na mão continua a estar só o prop do dispositivo.
   ======================================================================= */
window.photoBg = seed => `linear-gradient(${(seed * 37) % 360}deg, hsl(${(seed * 53) % 360},70%,58%), hsl(${(seed * 53 + 110) % 360},65%,32%))`;
window.Photos = (() => {
  let cache = [], lastError = null;
  /* 255 000: quase o Config.PhotoMaxBytes (260 000) do servidor - com 200 000 sobrava 23 % do espaço e a foto encolhia sem precisar */
  const CAP = 255000, CHUNK = 48000;
  const BLACK = 'BLACK';   /* sentinela: a imagem veio toda preta (nunca colide com um data: URL) */

  /* ---------- Fundo de uma miniatura ----------
     ⚠️ ASPAS SIMPLES, SEMPRE. Este valor é injetado dentro de style="…" por innerHTML (UI.el):
     com aspas duplas o parser de HTML FECHA o atributo no primeiro `"` do url(…), a regra morre
     e a miniatura cai no fallback `.photo{background:#333}` - era este o quadrado cinzento em vez
     da fotografia. As fotos só com `seed` (gradiente, sem aspas) escapavam, e por isso pareciam
     ser as únicas que funcionavam. */
  /* VÍDEOS (1.1.4): o `url` de um vídeo é um data:video/webm, que nenhum background-image mostra; a miniatura é a
     capa JPEG (`poster`, pedida à parte com Photos.poster) e, sem ela, o gradiente do seed. */
  const cssUrl = u => `url('${String(u).replace(/'/g, '%27')}')`;
  const bg = p => {
    if (p && p.video) return p.poster ? cssUrl(p.poster) : photoBg((p && p.seed) || 1);
    return (p && p.url) ? cssUrl(p.url) : photoBg((p && p.seed) || 1);
  };

  /* ---------- Descarregar o base64 de UMA foto, aos bocados ----------
     A lista (photos.list) vem SEM os base64: 60 fotos × 200 000 caracteres seriam 12 MB num
     único TriggerClientEvent - o evento é descartado, o servidor "não responde", o RPC estoira
     ao fim de 10 s e a galeria ficava eternamente em "Sem fotos". O conteúdo vem depois, por
     pedaços de 48 KB (RPC photos.data), e fica em memória na própria linha da cache (p.url),
     que é o que todas as outras apps leem (fundo do ecrã, partilhar, Marketplace, …). */
  const dl = { jobs: [], busy: false };
  function pump() {
    if (dl.busy) return;
    dl.busy = true;
    (async () => {
      while (dl.jobs.length) { const j = dl.jobs.shift(); let v = null; try { v = await j.run(); } catch (e) { v = null; } j.done(v); }
      dl.busy = false;
    })();
  }
  /* Uma foto de cada vez: cada pedaço é uma ida e volta NUI→cliente→servidor. Os pedidos
     explícitos (abrir uma foto, escolher uma foto) entram à FRENTE - senão ficavam atrás de
     todas as miniaturas da grelha. */
  function queue(run, first) {
    return new Promise(done => { const j = { run, done }; if (first) dl.jobs.unshift(j); else dl.jobs.push(j); pump(); });
  }
  const pending = {};
  /* onProgress(f) (ronda 2): o visualizador de vídeo mostra "A carregar 40 %" (um vídeo de 45 s são ~75 pedaços) */
  const progressOf = {};
  function data(p, first, onProgress) {
    if (!p) return Promise.resolve(null);
    if (p.url) return Promise.resolve(p.url);
    if (!p.len || !p.id) return Promise.resolve(null);   /* foto só com seed (gradiente) ou sem conteúdo */
    const id = p.id;
    if (onProgress) (progressOf[id] = progressOf[id] || new Set()).add(onProgress);
    if (pending[id]) return pending[id];
    pending[id] = queue(async () => {
      const parts = []; let total = 1;
      for (let i = 1; i <= total; i++) {
        const r = await Bridge.rpcRaw('photos.data', { id, i });
        if (!r || r.error || typeof r.data !== 'string') return null;
        /* limite duro (nunca um ciclo infinito): 400 = o teto do servidor (photos.lua DOWN_MAX_PARTS); com os 64 de antes um
           vídeo de mais de 3 M caracteres vinha CORTADO e o <video> não o abria */
        total = Math.min(400, Math.max(1, +r.total || 1));
        parts.push(r.data);
        if (progressOf[id]) progressOf[id].forEach(fn => { try { fn(i / total); } catch (e) {} });
        if (!r.data.length) break;
      }
      const out = parts.join('');
      if (!/^data:(image|video)\//.test(out)) return null;
      return out;
    }, first).then(url => {
      delete progressOf[id];
      delete pending[id];
      if (!url) return null;
      const row = cache.find(x => x && x.id === id); if (row) row.url = url;
      p.url = url;
      /* O widget da home só mostra as 12 mais recentes (e o base64 de 3): gravar a cache no
         localStorage por CADA foto que chega serializava ~600 KB de forma síncrona a cada bocado
         descarregado - abrir a galeria com 40 fotografias eram 40 gravações dessas. Agora só se
         grava quando o que chegou entra no que o widget mostra, e agrupado. */
      const i12 = cache.findIndex(x => x && x.id === id);
      if (i12 > -1 && i12 < 12) saveCacheSoon();
      return url;
    });
    return pending[id];
  }
  /* ---------- A capa de UM vídeo (RPC photos.poster, pequena: vem inteira) ----------
     Fica em p.poster (e na linha da cache); hasPoster = false marca os vídeos sem capa para não voltar a pedir. */
  const pendingPoster = {};
  function poster(p, first) {
    if (!p || !p.video) return Promise.resolve(null);
    if (p.poster) return Promise.resolve(p.poster);
    if (!p.id || p.hasPoster === false) return Promise.resolve(null);
    const id = p.id;
    if (pendingPoster[id]) return pendingPoster[id];
    pendingPoster[id] = queue(async () => {
      const r = await Bridge.rpcRaw('photos.poster', { id });
      return (r && typeof r.poster === 'string' && /^data:image\//.test(r.poster)) ? r.poster : null;
    }, first).then(u => {
      delete pendingPoster[id];
      const row = cache.find(x => x && x.id === id);
      if (row) { row.poster = u || null; if (!u) row.hasPoster = false; }
      p.poster = u || null; if (!u) p.hasPoster = false;
      if (u) { const i12 = cache.findIndex(x => x && x.id === id); if (i12 > -1 && i12 < 12) saveCacheSoon(); }
      return u;
    });
    return pendingPoster[id];
  }
  /* Pinta a miniatura assim que o base64 chegar (o elemento pode já ter saído do ecrã).
     Vídeo: a miniatura é a capa (poster), nunca o webm. */
  function lazy(el, p, first) {
    if (!el || !p) return;
    if (p.video) { if (p.poster || p.hasPoster === false) return; poster(p, first).then(u => { if (u && el.isConnected) el.style.backgroundImage = bg(p); }); return; }
    if (p.url || !p.len) return;
    data(p, first).then(u => { if (u && el.isConnected) el.style.backgroundImage = bg(p); });
  }
  /* ---------- SÓ O QUE ESTÁ NO ECRÃ ----------
     O `lazy()` desce o base64 em bocados, mas era chamado para TODAS as fotografias da grelha de
     uma vez: abrir as Fotos com 60 imagens pedia 60 × (até 200 KB) ao servidor e enchia a memória
     do CEF com 60 bitmaps descodificados, quando só 9 ou 12 se veem. Este observador pede a
     imagem quando a célula se aproxima do ecrã (300 px de antecipação) e nunca mais.
     `lazyGrid` devolve um observador com `.observe(el, p)` e `.disconnect()`; sem
     IntersectionObserver (ou no harness headless, onde pode nunca disparar) quem chama tem de
     carregar as primeiras à mão - ver o `else` na grelha das Fotos. */
  function lazyGrid(root) {
    if (!('IntersectionObserver' in window)) return null;
    const io = new IntersectionObserver(es => es.forEach(e => {
      if (!e.isIntersecting) return;
      io.unobserve(e.target);
      lazy(e.target, e.target._p);
    }), { root: root || null, rootMargin: '300px 0px' });
    return { observe: (el, p) => { el._p = p; io.observe(el); }, disconnect: () => io.disconnect() };
  }

  /* O widget das Fotos (ecrã principal) lê isto do Store. Guarda-se a ficha das 12 mais recentes,
     mas o base64 de NO MÁXIMO 3 já descarregadas: 12 imagens inteiras passam a quota do
     localStorage e a gravação falhava por inteiro (o try/catch escondia-o). */
  let scT = null, savedKey = null;
  function saveCacheSoon() { clearTimeout(scT); scT = setTimeout(() => { scT = null; saveCache(); }, 1500); }
  function saveCache() {
    try {
      let n = 0;
      const rows = cache.slice(0, 12).map(p => {
        let url = null;
        const u = p.video ? p.poster : p.url;   /* o widget mostra a capa do vídeo, nunca o webm */
        if (u && n < 3) { url = u; n++; }
        return { id: p.id, url, seed: p.seed, created: p.created };
      });
      /* só este ficheiro escreve `photosCache`: se a ficha é a mesma da última gravação, o
         JSON.stringify + localStorage.setItem SÍNCRONOS de até ~600 KB não mudavam nada. Cada
         load() (favoritar, apagar, abrir a galeria, cada evento 'photo') regravava tudo. */
      const key = rows.map(r => `${r.id}:${r.created}:${r.seed}:${r.url ? r.url.length : 0}`).join('|');
      if (key === savedKey) return;
      savedKey = key;
      Store.set('photosCache', rows.map(r => ({ url: r.url, seed: r.seed, created: r.created })));
    } catch (e) {}
  }

  /* ---------- Lista ----------
     Tudo o que possa correr mal fica com NOME: o rpc() normal converte {error:…} em null e
     um erro de servidor ficava indistinguível de uma galeria genuinamente vazia. */
  async function load() {
    let r = null;
    try { r = await Bridge.rpcRaw('photos.list'); } catch (e) { r = null; }
    lastError = null;
    if (r === false || r == null) lastError = 'rpc';                      /* sem resposta (timeout do RPC) */
    else if (r && r.error) lastError = String(r.error);
    /* ⚠️ o json.encode do FiveM serializa uma tabela Lua VAZIA como {} (objeto) e não []:
       `cache.slice()` rebentava com TypeError, o load() REJEITAVA e a grelha nunca era pintada. */
    /* a lista chega SEM os base64: sem isto cada load() deitava fora todas as fotografias já
       descarregadas e a grelha voltava a pedi-las ao servidor (5 idas e voltas por foto) - a cada
       favorito, a cada apagar, a cada evento 'photo' e a cada seletor aberto. O conteúdo de uma
       foto nunca muda depois de gravada (não há UPDATE ao url), por isso passa-se para a linha
       nova pelo id, e só se o tamanho bater certo com o que o servidor diz ter. */
    const had = new Map(), hadPoster = new Map();
    cache.forEach(x => { if (x && x.id != null && x.url) had.set(x.id, x.url); if (x && x.id != null && x.poster) hadPoster.set(x.id, x.poster); });
    cache = Array.isArray(r) ? r
          : (r && !r.error && typeof r === 'object' ? Object.values(r).filter(x => x && typeof x === 'object') : []);
    if (had.size) cache.forEach(x => { if (!x || x.url || !x.len) return; const u = had.get(x.id); if (u && u.length === +x.len) x.url = u; });
    /* as capas dos vídeos também sobrevivem ao load() (nunca mudam depois de gravadas) */
    if (hadPoster.size) cache.forEach(x => { if (!x || x.poster || !x.video) return; const u = hadPoster.get(x.id); if (u) x.poster = u; });
    saveCache();
    return cache;
  }
  async function add(d) { const p = await Bridge.rpc('photos.add', d); await load(); Bridge.emit('photos'); return p; }

  /* amostra ~1 em cada 97 pixéis: chega para distinguir "noite" de "buffer partido" */
  function isBlack(ctx, c) {
    try {
      const d = ctx.getImageData(0, 0, c.width, c.height).data;
      let max = 0;
      for (let i = 0; i < d.length; i += 4 * 97) {
        const l = (d[i] + d[i + 1] + d[i + 2]) / 3;
        if (l > max) { max = l; if (max > 12) return false; }
      }
      return true;
    } catch (e) { return false; }   /* canvas "sujo" ou sem contexto: não bloqueia a foto */
  }

  /* ---------- A FOTO É O PRÓPRIO VISOR ----------
     O canvas do GameRender já tem o enquadramento final (é ele que o jogador vê), por isso não
     há nada a recortar: só falta garantir que o base64 CABE no limite (CAP). Tenta-se primeiro a
     qualidade pedida e, se não couber, reduz-se o tamanho - nunca se devolve a imagem crua,
     porque 3 MB numa coluna e num evento de rede era exatamente o que fazia a foto desaparecer. */
  function fromCanvas(cv, q = .9, cap = CAP) {
    try {
      if (!cv || !cv.width || !cv.height) return null;
      let out = cv.toDataURL('image/jpeg', q);
      if (out && out.length <= cap) return out;
      /* QUALIDADE (2026-09-18): primeiro baixa-se a COMPRESSÃO na resolução inteira; só depois se reduz o tamanho.
         Antes reduzia-se logo a resolução (×0,8 por passo) e uma foto 1080×1440 acabava com ~690 px - era a
         'qualidade má' das fotos na galeria e no AirShare. Um JPEG de jogo a .6-.7 em 1080 px cabe quase sempre. */
      for (const qq of [.82, .74, .66, .6]) { if (qq >= q) continue; out = cv.toDataURL('image/jpeg', qq); if (out && out.length <= cap) return out; }
      const c = document.createElement('canvas'), ctx = c.getContext('2d');
      for (let i = 0; i < 6; i++) {
        const k = Math.pow(.85, i + 1);
        c.width = Math.max(1, Math.round(cv.width * k)); c.height = Math.max(1, Math.round(cv.height * k));
        ctx.drawImage(cv, 0, 0, c.width, c.height);
        out = c.toDataURL('image/jpeg', Math.max(.5, .84 - i * .06));
        if (out && out.length <= cap) return out;
      }
      return (out && out.length <= cap) ? out : null;
    } catch (e) { console.error('[apex_phone] fromCanvas', e); return null; }
  }

  /* ---------- Reduzir uma imagem que venha de FORA (browser / Face Key) ----------
     Só o harness e o mock do browser passam por aqui: no jogo a foto nasce já no tamanho certo. */
  function shrink(src, max = 1100, ratio = 3 / 4, cap = CAP) {
    return new Promise(res0 => {
      let done = false; const res = v => { if (done) return; done = true; res0(v); };
      const guard = setTimeout(() => res(null), 6000);   /* descodificação presa: falha limpa, sem obturador pendurado */
      const img = new Image();
      img.onload = () => { clearTimeout(guard); try {
        let sw = img.naturalWidth || img.width, sh = img.naturalHeight || img.height, sx = 0, sy = 0;
        if (!sw || !sh) return res(null);
        /* ratio 0/null = SEM recorte */
        if (ratio) { if (sw / sh > ratio) { sw = sh * ratio; sx = (img.width - sw) / 2; } else { sh = sw / ratio; sy = (img.height - sh) / 2; } }
        const c = document.createElement('canvas'), ctx = c.getContext('2d');
        let out = '';
        for (let i = 0; i < 6; i++) {
          let w = sw, h = sh; const m = Math.max(w, h), lim = max * Math.pow(.8, i);
          if (m > lim) { const k = lim / m; w *= k; h *= k; }
          c.width = Math.max(1, Math.round(w)); c.height = Math.max(1, Math.round(h));
          ctx.drawImage(img, sx, sy, sw, sh, 0, 0, c.width, c.height);
          if (i === 0 && isBlack(ctx, c)) return res(BLACK);
          out = c.toDataURL('image/jpeg', Math.max(.4, .74 - i * .07));
          if (out.length <= cap) break;
        }
        res(out && out.length <= cap ? out : null);
      } catch (e) { res(null); } };
      img.onerror = () => { clearTimeout(guard); res(null); };
      img.src = src;
    });
  }
  /* miniatura QUADRADA a partir do centro (Face Key): 180 px chegam para o cartão e ficam em ~15 KB */
  function square(src, size = 180, q = .72) {
    return new Promise(res0 => {
      let done = false; const res = v => { if (done) return; done = true; res0(v); };
      const guard = setTimeout(() => res(null), 6000);
      const img = new Image();
      img.onload = () => { clearTimeout(guard); try {
        const iw = img.naturalWidth || img.width, ih = img.naturalHeight || img.height; if (!iw || !ih) return res(null);
        const s = Math.min(iw, ih), sx = (iw - s) / 2, sy = (ih - s) / 2;
        const c = document.createElement('canvas'); c.width = c.height = size;
        c.getContext('2d').drawImage(img, sx, sy, s, s, 0, 0, size, size);
        res(c.toDataURL('image/jpeg', q));
      } catch (e) { res(null); } };
      img.onerror = () => { clearTimeout(guard); res(null); };
      img.src = src;
    });
  }
  /* ---------- Miniatura para o AirShare (pacote AD) ----------
     Vai num ÚNICO evento de rede com o airdrop.send, por isso tem um teto duro de 12 000 caracteres (o
     servidor deita fora o que passar disso): ≤ 160 px de lado, JPEG a .6, e se ainda não couber baixa-se
     o tamanho e a qualidade até caber. null = foto só com seed (gradiente) ou imagem que não descodifica. */
  function thumb(p, max = 160, cap = 12000) {
    return new Promise(async res0 => {
      let done = false; const res = v => { if (done) return; done = true; res0(v); };
      /* vídeo: a miniatura sai da capa (o webm não é uma imagem) */
      let src = null; try { src = p && p.video ? await poster(p, true) : await data(p, true); } catch (e) { src = null; }
      if (!src || !/^data:image\//.test(src)) return res(null);
      const guard = setTimeout(() => res(null), 6000);
      const img = new Image();
      img.onload = () => { clearTimeout(guard); try {
        const iw = img.naturalWidth || img.width, ih = img.naturalHeight || img.height; if (!iw || !ih) return res(null);
        const c = document.createElement('canvas'), ctx = c.getContext('2d');
        let out = '';
        for (let i = 0; i < 5; i++) {
          const lim = max * Math.pow(.8, i), k = Math.min(1, lim / Math.max(iw, ih));
          c.width = Math.max(1, Math.round(iw * k)); c.height = Math.max(1, Math.round(ih * k));
          ctx.drawImage(img, 0, 0, c.width, c.height);
          out = c.toDataURL('image/jpeg', Math.max(.35, .6 - i * .06));
          if (out.length <= cap) break;
        }
        res(out && out.length <= cap ? out : null);
      } catch (e) { res(null); } };
      img.onerror = () => { clearTimeout(guard); res(null); };
      img.src = src;
    });
  }
  /* ---------- Guardar a foto (envio AOS BOCADOS) ----------
     Uma imagem em base64 não cabe num evento de rede do FiveM: o evento é descartado, o servidor
     nunca responde e o cliente fica 10 s à espera. Parte-se em pedaços de 48 KB (RPC photos.upload)
     e o servidor só grava quando recebe o último. Devolve a linha da foto ou {error:…}. */
  async function save(url, extra) {
    extra = extra || {};
    if (!url) return { error: 'empty' };
    /* a resposta do servidor vem SEM o base64 (seriam outros 200 KB no evento de volta): quem
       acabou de o enviar é que o tem em mão, e é aqui que ele volta para a linha da foto */
    const keep = r => { if (r && r.id && !r.error && !r.url) r.url = url; return r; };
    if (url.length <= CHUNK) return keep(await Bridge.rpcRaw('photos.add', Object.assign({ url }, extra))) || { error: 'rpc' };
    const total = Math.ceil(url.length / CHUNK);
    /* vídeo: a marca vai em TODOS os bocados (o teto do servidor para um vídeo é outro); o resto (duração, capa) só no último */
    const every = extra.video ? { video: true } : {};
    for (let i = 0; i < total; i++) {
      const last = i === total - 1;
      const d = Object.assign({ i: i + 1, total, data: url.slice(i * CHUNK, (i + 1) * CHUNK) }, every, last ? extra : {});
      /* (ronda 2) ao ritmo do limitador do FXServer, no MESMO balde dos vídeos e das gravações (RecCore.take): uma foto
         tirada durante o envio de um vídeo não pode somar-se a ele e passar os 128 KiB/s (o jogador era expulso) */
      if (window.RecCore) await RecCore.take(d.data.length + 200);
      const r = await Bridge.rpcRaw('photos.upload', d);
      if (!r || r.error) return r || { error: 'rpc' };
      if (last) return keep(r);
    }
    return { error: 'rpc' };
  }
  /* ---------- Guardar um VÍDEO (ronda 2) ----------
     RPCs próprios (server/recording.lua): o servidor valida o limite do APARELHO (duração, tamanho), o dono, a ordem dos
     pedaços, o formato (webm) e o espaço de vídeos da personagem, e só no fim grava a linha na galeria (AddPhoto).
     Os envios ficam numa FILA (um vídeo de cada vez) e cada pedaço espera pelo balde de fichas do RecCore.
     info = { duration (ms), poster, audio, width, height }. Devolve a linha da galeria ou { error }. */
  let videoQ = Promise.resolve();
  function saveVideo(url, info, onProgress) {
    info = info || {};
    const run = async () => {
      if (!window.RecCore) return { error: 'js' };
      const r = await RecCore.upload({
        begin: ['recording.video.begin', { mime: 'video/webm', size: url.length, duration: Math.round(+info.duration || 0), audio: !!info.audio, width: info.width, height: info.height }],
        upload: 'recording.video.upload', finish: ['recording.video.finish', info.poster ? { poster: info.poster } : {}], cancelRpc: 'recording.video.cancel',
        dataUrl: url, onProgress });
      if (!r || r.error) return { error: (r && r.error) || 'rpc' };
      const p = r.photo && typeof r.photo === 'object' ? r.photo : { id: r.id };
      p.url = url; if (info.poster && !p.poster) { p.poster = info.poster; p.hasPoster = true; } p.video = true;
      return p;
    };
    const p = videoQ.then(run, run); videoQ = p.catch(() => {}); return p;
  }
  /* Blob de um vídeo da galeria para o <video> (blob: URL): um data: URL maior do que 2 MiB passa o teto de URLs do
     Chromium e o vídeo nunca toca. Cache pequena por id (o mesmo vídeo aberto outra vez não volta a descodificar). */
  const blobs = new Map();
  function videoUrl(p, onProgress) {
    if (!p || !p.id) return Promise.resolve(null);
    if (blobs.has(p.id)) return Promise.resolve(blobs.get(p.id));
    return data(p, true, onProgress).then(u => {
      if (!u || !/^data:video\//.test(u)) return null;
      let b = null; try { b = window.RecCore ? RecCore.dataURLToBlob(u) : null; } catch (e) { b = null; }
      if (!b || !b.size) return null;
      const url = URL.createObjectURL(b); blobs.set(p.id, url);
      while (blobs.size > 3) { const k = blobs.keys().next().value; try { URL.revokeObjectURL(blobs.get(k)); } catch (e) {} blobs.delete(k); }
      return url;
    });
  }
  /* apagar e favoritar escrevem na base de dados do servidor: sem rede não acontece nada e quem chama
     precisa de o saber (senão a grelha tirava a foto da lista e ela voltava na carga seguinte) */
  /* rpcRaw e DEVOLVER a resposta: quem chama (o visualizador) só tira a foto da lista local quando o
     servidor não recusou - com o rpc() normal um { error } virava null e a guarda nunca disparava */
  async function remove(id) { if (window.CC && CC.requireNet && !CC.requireNet('apagar fotos')) return { error: 'offline' }; const r = await Bridge.rpcRaw('photos.remove', { id }); await load(); return r; }
  /* rpcRaw: o teto Config.MaxFavPhotos responde { error:'toomany', max } e o rpc() normal trocava-o
     por null - a estrela voltava atrás sozinha e o jogador ficava sem perceber porquê. */
  async function fav(id, v) {
    if (window.CC && CC.requireNet && !CC.requireNet('mudar as favoritas')) return { error: 'offline' };
    const r = await Bridge.rpcRaw('photos.fav', { id, favorite: v });
    await load();
    if (r && r.error === 'toomany') UI.toast(+r.max > 0 ? 'Máximo de ' + Math.floor(+r.max) + ' favoritas' : 'Já tens o máximo de favoritas');
    return r;
  }
  /* o = { videos: true } (12 nov 2026): os compositores das redes (Instashot, Reels, Tweeter) também mostram os VÍDEOS da galeria,
     com a duração no canto; quem não passa nada continua a ver só fotografias */
  function pick(title = 'Escolher foto', o) {
    o = o || {};
    return new Promise(async res => {
      await load();
      /* só FOTOGRAFIAS: quem pede uma foto (fundo, publicação, anúncio, avatar) não sabe o que fazer a um webm */
      const list = cache.filter(p => p && (o.videos || !p.video));
      const body = UI.el('<div class="photo-grid" style="padding-top:8px"></div>');
      if (!list.length) body.innerHTML = `<div class="empty" style="grid-column:span 3">${lastError ? 'Não foi possível carregar as fotos' : o.videos ? 'Sem fotos nem vídeos' : 'Sem fotos'}</div>`;
      /* ⚠️ res(p) TEM de vir ANTES de sh.close(): o close() chama o onClose de forma
         SÍNCRONA, que resolve null - e uma promessa só honra a primeira resolução.
         Com a ordem trocada, pick() devolvia SEMPRE null e todos os seletores de foto
         do telemóvel (story, publicação, anúncio, fundo) ficavam mudos. É a mesma
         armadilha já documentada em UI.picker (ui.js). */
      /* o fundo vai pelo CSSOM, nunca dentro da string de HTML: um data: URL de 200 KB por célula
         passava pelo parser de HTML e era reparsado em cada repintura da folha */
      /* as 9 primeiras (o que a folha mostra ao abrir) pedem-se já e à frente da fila; as outras só
         quando chegam perto do fundo visível da folha - antes pedia-se a biblioteca INTEIRA (até 60
         fotos × 5 pedaços RPC) de cada vez que se abria um seletor, mesmo escolhendo a primeira */
      const later = [];
      list.forEach((p, i) => { const e = UI.el(`<div class="photo">${p.video ? `<span class="cr-vbadge"><svg viewBox="0 0 24 24" width="11" height="11"><path fill="currentColor" d="M7 5v14l11.5-7z"/></svg>${UI.fmtDur(p.duration || 0)}</span>` : ''}</div>`); e.style.backgroundImage = bg(p); if (i < 9) lazy(e, p, true); else later.push([e, p]); e.onclick = () => { res(p); sh.close(); }; body.appendChild(e); });
      let io = null;
      /* Android: o mesmo seletor com a grelha de 4 colunas da Galeria da Nova UI (só a classe muda) */
      const sh = UI.sheet({ title, right: 'Cancelar', body, cls: window.System && System.os === 'android' ? 'agal-pick' : '', onClose: () => { if (io) { io.disconnect(); io = null; } res(null); } });
      /* o scroll é a .content da folha (pai do body): só existe depois de UI.sheet */
      io = later.length ? lazyGrid(body.parentElement) : null;
      later.forEach(([e, p]) => { if (io) io.observe(e, p); else lazy(e, p); });
    });
  }
  /* ---------- FOTO POR LINK ("add external photos by link") ----------
     Não há seletor de ficheiros no CEF, por isso a única porta para uma imagem de fora era o fundo (Definições › Fundo ›
     Adicionar imagem por link, 1.1.4): a galeria não a oferecia. A folha é a MESMA do lockgallery.js (linkSheet, com
     cfg 'photoLinks' = Config.PhotoLinks, que recua para o WallpaperLinks): um link https fica como linha `url` da
     galeria (photos.add, carga pequena); uma imagem colada é reduzida e sobe aos bocados (Photos.save), como hoje.
     Os erros do servidor têm nome (cleanUrl: 'host' = site fora da lista branca, 'disabled' = links desligados). */
  const linksCfg = () => (window.LockGallery && LockGallery.linkCfg) ? LockGallery.linkCfg('photoLinks') : Object.assign({ enabled: true }, (window.System && System.config && (System.config.photoLinks || System.config.wallpaperLinks)) || {});
  const linksOn = () => !!(window.LockGallery && LockGallery.linkSheet) && linksCfg().enabled !== false;
  const LINK_ERR = { host: 'Este servidor não permite links deste site', disabled: 'Os links de imagem estão desligados neste servidor', toolarge: 'A imagem colada é demasiado grande', badimage: 'Esse link não parece válido', offline: 'Sem rede' };
  function addFromLink(done) {
    const T = s => (window.L && L.t ? L.t(s) : s);
    if (!linksOn()) { UI.toast(T('Os links de imagem estão desligados neste servidor')); return null; }
    return LockGallery.linkSheet(async (patch, info) => {
      const u = patch && patch.custom && patch.custom.url; if (!u) return;
      let p = info && info.pasted ? info.photo : null;   /* colada: a folha já a guardou (pasteDone) */
      if (!p) { if (window.CC && CC.requireNet && !CC.requireNet('guardar fotos')) return; p = await save(u, {}); }
      if (!p || p.error) { UI.toast(T(LINK_ERR[p && p.error] || 'Não foi possível guardar a imagem')); return; }
      /* a linha nova entra na cache já com o endereço (um link volta do servidor; o base64 colado fica em mão) */
      try { await load(); const row = cache.find(x => x && x.id === p.id); if (row && !row.url) row.url = u; } catch (e) {}
      Bridge.emit('photos'); UI.toast(T('Guardada nas Fotos'));
      if (done) { try { done(p); } catch (e) {} }
    }, { title: 'Adicionar por link', button: 'Guardar nas Fotos', footer: 'Links de anexos do Discord expiram ao fim de 24 h: se a foto desaparecer, cola um link novo.', cfg: 'photoLinks', pasteDone: true });
  }
  Bridge.on('photo', p => { load().then(() => Bridge.emit('photos')); });
  /* troca de personagem: a cache é global (sobrevive ao killApp) e mostrava as fotos da personagem anterior até à próxima carga */
  Bridge.on('session:changed', () => { cache = []; lastError = null; Bridge.emit('photos'); });
  return { get cache() { return cache; }, get error() { return lastError; }, load, add, remove, fav, pick, bg, lazy, lazyGrid, data, poster, fromCanvas, shrink, square, thumb, save, saveVideo, videoUrl, addFromLink, linksOn, isLink: p => !!(p && typeof p.url === 'string' && /^https?:\/\//i.test(p.url)), CAP, CHUNK, BLACK };
})();

/* ===================== LEITOR DE VÍDEO DA GALERIA (ronda 2) =====================
   Controlos próprios em vez dos do CEF (que não seguem o tema nem se traduzem): tocar/pausa, tempo decorrido, barra de
   posição arrastável (preenchimento e bolinha SÓ por transform), duração e som. Descarrega aos bocados com percentagem e
   toca por blob: URL (Photos.videoUrl). Construído UMA vez por visualizador; show(p) troca de vídeo sem refazer o DOM. */
window.VideoPlayer = (() => {
  const T = s => (window.L && L.t ? L.t(s) : s);
  const fmt = s => UI.fmtDur(Math.max(0, Math.floor(+s || 0)));
  const setTx = (el, s) => { if (el && el.textContent !== s) el.textContent = s; };
  const PLAY = '<svg viewBox="0 0 24 24" width="22" height="22"><path fill="currentColor" d="M8 5.5v13l10.5-6.5z"/></svg>';
  const PAUSE = '<svg viewBox="0 0 24 24" width="22" height="22"><rect x="6.5" y="5" width="4" height="14" rx="1.2" fill="currentColor"/><rect x="13.5" y="5" width="4" height="14" rx="1.2" fill="currentColor"/></svg>';
  const SOUND = on => `<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 9.5h3.5L12 5.5v13l-4.5-4H4z" fill="currentColor" stroke="none"/>${on ? '<path d="M15.5 9a4 4 0 0 1 0 6M18 6.5a7.5 7.5 0 0 1 0 11"/>' : '<path d="M16 9.5l5 5M21 9.5l-5 5"/>'}</svg>`;
  const vol = () => { const v = +((window.System && System.state) || {}).volume; return Math.max(0, Math.min(1, isFinite(v) ? v / 100 : .6)); };
  function create(host) {
    const el = UI.el(`<div class="vpl"><video class="vpl-v" playsinline preload="auto"></video><div class="vpl-load"><span class="vpl-spin"></span><b class="vpl-pct"></b></div>
      <div class="vpl-bar"><div class="vpl-pp" role="button" aria-label="${UI.esc(T('Reproduzir'))}">${PLAY}</div><span class="vpl-cur">0:00</span><div class="vpl-track"><div class="vpl-rail"></div><div class="vpl-fill"></div><div class="vpl-knob"></div></div><span class="vpl-dur">0:00</span><div class="vpl-snd" role="button" aria-label="${UI.esc(T('Som'))}">${SOUND(true)}</div></div></div>`);
    host.appendChild(el);
    const q = s => el.querySelector(s);
    const vid = q('video'), pp = q('.vpl-pp'), curEl = q('.vpl-cur'), durEl = q('.vpl-dur'), track = q('.vpl-track'), fill = q('.vpl-fill'), knob = q('.vpl-knob'), load = q('.vpl-load'), pct = q('.vpl-pct'), snd = q('.vpl-snd');
    let seq = 0, raf = 0, drag = null, durS = 0, dead = false, playing = false;
    const dOf = () => (isFinite(vid.duration) && vid.duration > 0 ? vid.duration : durS);
    const paint = () => { const d = dOf(), t = drag ? drag.t : (vid.currentTime || 0), f = d > 0 ? Math.min(1, t / d) : 0;
      fill.style.transform = `scaleX(${f.toFixed(4)})`; knob.style.transform = `translateX(${(f * (track.clientWidth || 0)).toFixed(1)}px)`;
      setTx(curEl, fmt(t)); setTx(durEl, fmt(d)); };
    const loop = () => { raf = 0; if (dead || vid.paused) return; if (!drag) paint(); raf = requestAnimationFrame(loop); };
    const setPlaying = on => { if (playing === on) return; playing = on; pp.innerHTML = on ? PAUSE : PLAY; pp.setAttribute('aria-label', T(on ? 'Pausa' : 'Reproduzir')); el.classList.toggle('playing', on); };
    vid.addEventListener('play', () => { setPlaying(true); if (!raf) raf = requestAnimationFrame(loop); });
    vid.addEventListener('pause', () => { setPlaying(false); paint(); });
    vid.addEventListener('ended', () => { setPlaying(false); try { vid.currentTime = 0; } catch (e) {} paint(); });
    ['loadedmetadata', 'durationchange', 'seeked'].forEach(ev => vid.addEventListener(ev, paint));
    vid.addEventListener('error', () => { if (!vid.getAttribute('src')) return; el.classList.add('vpl-err'); load.classList.remove('hidden'); setTx(pct, T('Não foi possível reproduzir este vídeo')); });
    const play = () => { vid.volume = vol(); const pr = vid.play(); if (pr && pr.catch) pr.catch(() => {}); };
    pp.onclick = e => { e.stopPropagation(); if (!vid.getAttribute('src')) return; Sound.play('click'); if (vid.paused) play(); else vid.pause(); };
    snd.onclick = e => { e.stopPropagation(); vid.muted = !vid.muted; snd.innerHTML = SOUND(!vid.muted); };
    /* arrastar na barra (retângulo em px reais pelo UI.vrect, como o clientX: o aparelho tem zoom) */
    const fAt = e => { const r = drag.r; return r.width ? Math.max(0, Math.min(1, (e.clientX - r.left) / r.width)) : 0; };
    track.addEventListener('pointerdown', e => { e.stopPropagation(); if (!vid.getAttribute('src') || (e.button && e.pointerType === 'mouse')) return;
      drag = { r: UI.vrect ? UI.vrect(track) : track.getBoundingClientRect(), was: !vid.paused, t: 0 }; vid.pause(); drag.t = fAt(e) * dOf(); paint(); el.classList.add('seeking');
      try { track.setPointerCapture(e.pointerId); } catch (x) {} });
    track.addEventListener('pointermove', e => { if (!drag) return; e.stopPropagation(); drag.t = fAt(e) * dOf(); paint(); });
    const end = e => { if (!drag) return; const d = drag; drag = null; el.classList.remove('seeking'); try { vid.currentTime = Math.max(0, Math.min(d.t, dOf() - .05)); } catch (x) {} paint(); if (d.was) play(); };
    track.addEventListener('pointerup', end); track.addEventListener('pointercancel', end);
    q('.vpl-bar').addEventListener('click', e => e.stopPropagation());
    async function show(p) {
      const my = ++seq; cancelAnimationFrame(raf); raf = 0;
      try { vid.pause(); } catch (e) {} vid.removeAttribute('src'); try { vid.load(); } catch (e) {}
      el.classList.remove('vpl-err', 'ready'); load.classList.remove('hidden'); setTx(pct, ''); durS = +p.duration || 0; setPlaying(false); paint();
      const url = await Photos.videoUrl(p, f => { if (my === seq) setTx(pct, Math.round(f * 100) + ' %'); });
      if (dead || my !== seq) return;
      if (!url) { el.classList.add('vpl-err'); setTx(pct, T('Não foi possível carregar o vídeo')); return; }
      load.classList.add('hidden'); el.classList.add('ready'); vid.src = url; play();
    }
    function stop() { seq++; cancelAnimationFrame(raf); raf = 0; try { vid.pause(); } catch (e) {} vid.removeAttribute('src'); try { vid.load(); } catch (e) {} setPlaying(false); }
    /* 12 nov 2026: a app em segundo plano, o telemóvel guardado ou bloqueado pausam o vídeo (partilhar um vídeo para o Instashot
       abria a rede com o vídeo da galeria a tocar por trás) */
    const offs = (window.Bridge && Bridge.on) ? ['app:close', 'phone:close', 'lock'].map(ev => Bridge.on(ev, () => { try { if (!vid.paused) vid.pause(); } catch (e) {} })) : [];
    return { el, show, stop, destroy() { if (dead) return; stop(); dead = true; offs.forEach(f => { try { f(); } catch (e) {} }); el.remove(); }, get video() { return vid; } };
  }
  return { create };
})();

/* motivos com nome para o cabeçalho da galeria: "Sem fotos" a esconder um erro de servidor era
   indistinguível de uma galeria genuinamente vazia (o único rasto ficava na consola do servidor) */
const PHOTOS_ERR = { rpc: 'Sem resposta do servidor', internal: 'Erro no servidor ao ler as fotos', noplayer: 'Sessão do jogador não encontrada' };

App.define('photos', {
  name: 'Fotos', core: true, category: 'Criatividade', landscape: true,
  /* Voltar do Android (SysUI): a Galeria consome-o para sair do editor, do visualizador ou da seleção */
  back(win) { try { return !!(win && win._novaBack && win._novaBack()); } catch (e) { return false; } },
  open(win) {
    /* Android: a mesma galeria (mesmas fotos, mesmos RPC) com a cara da Galeria da Nova UI (GalleryNova, mais abaixo) */
    if (window.System && System.os === 'android' && window.GalleryNova) return GalleryNova.open(win);
    const g = UI.g;
    /* withLink: a Biblioteca leva o botão "Adicionar por link" (cabeçalho e estado vazio); Favoritos/Álbuns não (lá não faria sentido).
       ⚠️ o 'Selecionar' fica em PRIMEIRO: o toggleSelect lê o primeiro .nb-btn da barra */
    const grid = (title, filter, withLink) => {
      const linkBtn = withLink && Photos.linksOn() ? [{ icon: 'link', label: 'Adicionar por link', cls: 'ph-link', onTap: () => Photos.addFromLink() }] : [];
      const v = UI.view({ title, large: true, right: [{ label: 'Selecionar', onTap: () => toggleSelect(v) }].concat(linkBtn) }); const gEl = UI.el('<div class="photo-grid"></div>'); const info = UI.el('<div class="group-footer" style="padding-top:0"></div>'); v.content.append(info, gEl); v.selecting = false; v.selected = new Set();
      let io = null;
      const paint = () => { const list = Photos.cache.filter(filter); const err = Photos.error; gEl.innerHTML = '';
        /* o observador anterior ficava a olhar para células já removidas */
        if (io) { io.disconnect(); io = null; }
        info.textContent = err ? (PHOTOS_ERR[err] || ('Erro: ' + err)) : `${list.length} foto${list.length === 1 ? '' : 's'}`;
        if (!list.length) { const em = UI.el(`<div class="empty" style="grid-column:span 3">${err ? 'Não foi possível carregar as fotos' : 'Sem fotos'}</div>`);
          /* galeria vazia: a porta para uma imagem de fora fica à vista (só na Biblioteca e com os links ligados) */
          if (!err && linkBtn.length) { const b = UI.el(`<div class="btn-p ph-link-empty" style="margin:14px 0 0;padding:0 18px">${g('link', 16)} <span>Adicionar por link</span></div>`); b.onclick = () => Photos.addFromLink(); em.appendChild(b); }
          gEl.appendChild(em); UI.emptyFit(em); return; }
        io = Photos.lazyGrid(v.content);
        list.forEach((p, i) => { const ph = UI.el(`<div class="photo">${p.favorite ? `<span class="fav">${g('heartFill')}</span>` : ''}${p.video ? `<span class="cr-vbadge"><svg viewBox="0 0 24 24" width="11" height="11"><path fill="currentColor" d="M7 5v14l11.5-7z"/></svg>${UI.fmtDur(p.duration || 0)}</span>` : ''}<span class="sel"></span></div>`);
          /* o data: URL vai pelo CSSOM e NUNCA dentro da string de HTML: 200 KB de base64 por
             célula atravessavam o parser de HTML a cada repintura da grelha */
          ph.style.backgroundImage = Photos.bg(p);
          /* e o base64 só é pedido quando a célula chega perto do ecrã - abrir a galeria pedia a
             biblioteca INTEIRA ao servidor (`Photos.lazy` para as 60 de uma vez).
             Sem IntersectionObserver (ou no harness, onde pode nunca disparar) carregam-se as 12
             primeiras à mão: é o que se vê sem rolar. */
          if (io) io.observe(ph, p); else if (i < 12) Photos.lazy(ph, p);
          ph.onclick = () => { if (v.selecting) { ph.classList.toggle('on'); if (ph.classList.contains('on')) v.selected.add(p.id); else v.selected.delete(p.id); return; } viewer(list, i); }; UI.longPress(ph, () => ctx(p, ph)); gEl.appendChild(ph); }); };
      v.paint = paint;
      v.opts.onPop = () => { if (io) { io.disconnect(); io = null; } };
      /* ⚠️ sem .catch uma falha do load() deixava a grelha por pintar e o ecrã em BRANCO */
      Photos.load().then(paint).catch(e => { console.error('[apex_phone] photos.load', e); paint(); });
      return v;
    };
    /* o aviso de rede vem ANTES do ciclo: sem ele eram N pedidos ao vazio e a grelha repunha tudo sem explicação */
    const toggleSelect = async v => { if (v.selecting && v.selected.size) { if (await UI.confirm(`Apagar ${v.selected.size} foto(s)`, '', 'Apagar', true)) { if (window.CC && CC.requireNet && !CC.requireNet('apagar fotos')) return; for (const id of v.selected) await Bridge.rpc('photos.remove', { id }); await Photos.load(); } } v.selecting = !v.selecting; v.selected.clear(); v.querySelector('.nb-btn').textContent = v.selecting ? 'Apagar' : 'Selecionar'; v.content.querySelectorAll('.photo').forEach(p => { p.classList.remove('on'); p.querySelector('.sel').style.display = v.selecting ? 'block' : 'none'; }); if (!v.selecting) v.paint(); };
    const ctx = (p, el) => UI.ctxMenu(el, [{ label: p.favorite ? 'Remover favorito' : 'Favorito', icon: 'heart', onTap: async () => { await Photos.fav(p.id, !p.favorite); refreshAll(); } }, { label: 'Partilhar', icon: 'share', onTap: () => share(p) }, { label: 'Definir como fundo', icon: 'photo', onTap: () => setWallpaper(p) }, { label: 'Apagar', icon: 'trash', danger: true, onTap: async () => { await Photos.remove(p.id); refreshAll(); } }]);
    const refreshAll = () => win.querySelectorAll('.view').forEach(v => v.paint && v.paint());
    async function share(p) {
      /* vídeo: AirShare (copia a linha inteira na base de dados) e, desde 12 nov 2026, as redes (Instashot, story, Reels, Tweeter):
         o servidor copia o vídeo da galeria para a publicação, nada volta a subir. Mensagens e Mail continuam só com imagens. */
      if (p && p.video) {
        const ts = window.SocialShare && SocialShare.videoTargets ? await SocialShare.videoTargets() : [];
        const ad = !!(window.AirDrop && AirDrop.share);
        if (!ts.length) { if (ad) AirDrop.share(p); else UI.toast('Os vídeos só podem ser partilhados por AirShare'); return; }
        const v = await UI.actionSheet({ title: 'Partilhar vídeo', buttons: (ad ? [{ label: 'AirShare', icon: 'airdrop', value: 'ad' }] : []).concat(ts.map((t, k) => ({ label: t.label, icon: t.icon, value: 's' + k }))) });
        if (v === 'ad') AirDrop.share(p);
        else if (typeof v === 'string' && v[0] === 's' && ts[+v.slice(1)]) { const t = ts[+v.slice(1)]; SocialShare.send(t.app, p, t.kind); }
        return;
      }
      await Photos.data(p, true);   /* partilhar precisa do base64, não da ficha */
      /* AirShare primeiro, como no PearOS (pacote AD): a folha do AirDrop.js trata da miniatura e da lista de quem está perto */
      const v = await UI.actionSheet({ title: 'Partilhar foto', buttons: [{ label: 'AirShare', icon: 'airdrop', value: 'ad' }, { label: 'Mensagem', icon: 'message', value: 'msg' }, { label: 'Instashot', icon: 'camera', value: 'ig' }, { label: 'Tweeter', icon: 'hash', value: 'tw' }, { label: 'Mail', icon: 'mail', value: 'mail' }] }); if (!v) return;
      if (v === 'ad') { if (window.AirDrop && AirDrop.share) AirDrop.share(p); else UI.toast('AirShare indisponível'); }
      else if (v === 'msg') { const c = await Contacts.pick('Enviar foto a'); if (c) sendToChat(c, p); }
      else if (v === 'ig' || v === 'tw') SocialShare.send(v === 'ig' ? 'instashot' : 'twix', p);   /* a fotografia fica à espera da app, em vez dos 400 ms à sorte (social.js) */
      /* Fase 2: o botão Mail só mostrava "Anexada a um novo email" sem anexar nada. Abre o Mail com a foto já
         anexada (o servidor copia-a para apex_phone_media ao enviar ou ao guardar o rascunho). */
      else if (window.MailApp) MailApp.compose({ photo: p }); else UI.toast('Mail indisponível'); }
    /* Fase 2: a foto sobe aos bocados (Msgs.sendPhoto: media.begin/upload/finish) e a mensagem leva só o mediaId. Antes ia
       o data: URL inteiro (até ~260 KB) num único messages.send, que o FiveM corta num evento de rede: a foto não
       chegava e o pedido ficava sem resposta. Link externo e gradiente continuam a ir no payload. */
    async function sendToChat(c, p) {
      if (!window.Msgs || typeof Msgs.sendPhoto !== 'function') { UI.toast('Mensagens indisponíveis'); return; }
      const url = typeof p.url === 'string' && p.url ? p.url : null;
      if (url && /^data:/i.test(url)) UI.toast('A enviar a foto…');
      const r = await Msgs.sendPhoto(c.number, url || p.seed, { seed: p.seed });
      UI.toast(r && !r.error ? 'Foto enviada' : 'A foto não foi enviada');
    }
    async function setWallpaper(p) { if (p && p.video) { UI.toast('Os vídeos não podem ser usados como fundo'); return; } await Photos.data(p, true);
      const v = await UI.actionSheet({ title: 'Definir como fundo', buttons: [{ label: 'Ecrã principal', value: 'home' }, { label: 'Ecrã bloqueado', value: 'lock' }, { label: 'Ambos', bold: true, value: 'both' }] }); if (!v) return; const custom = { url: p.url || null, seed: p.url ? null : p.seed };
      if (v === 'home') System.setState({ wallpaperCustom: custom }); else if (v === 'lock') System.setState({ lockWallpaper: { custom } }); else System.setState({ wallpaperCustom: custom, lockWallpaper: null }); UI.toast('Fundo atualizado'); }
    function viewer(list, i) {
      /* VISUALIZADOR COMO O DAS FOTOS DO iOS (2026-09-19): fundo preto, a foto ocupa o ecrã (contain), data em cima com a hora por
         baixo, barra de baixo Partilhar · Favorito · Informações · Apagar; tocar na foto esconde/mostra as barras; deslizar
         (ou as setas do teclado) muda de foto, puxar para baixo fecha. (A barra já não leva `.solid`: o liquid27 punha-lhe
         por baixo uma faixa clara de 22 px - via-se um risco branco no ecrã preto.) */
      const v = UI.el(`<div class="viewer"><div class="navbar pv-top" style="flex:none"><div class="nb-left"><div class="nb-back" style="color:#fff">${g('chevL')}<span>Fotos</span></div></div><div class="nb-title pv-title"><b></b><i></i></div><div class="nb-right"><div class="nb-btn pv-more" style="color:#fff">${g('more')}</div><div class="nb-btn pe-open" style="color:#fff;font-weight:600">Editar</div></div></div><div class="vimg"><div></div></div><div class="vbar"><div class="share">${g('share')}</div><div class="fav">${g('heart')}</div><div class="inf">${g('info')}</div><div class="del">${g('trash')}</div></div></div>`);
      /* o visualizador usa o CSSOM (.style.backgroundImage) e não innerHTML: não passa pelo parser
         de HTML, por isso era o único sítio que já mostrava as fotos a sério */
      /* VÍDEO (1.1.4): a capa fica no fundo e, quando o webm chega aos bocados, entra um <video> por cima (controlos do
         próprio CEF, em ciclo). Mudar de item ou fechar tira o <video> e larga o src, para não ficar a tocar escondido. */
      const vimgEl = v.querySelector('.vimg');
      /* (ronda 2) o leitor de vídeo próprio (window.VideoPlayer): blob: URL, barra de posição, tempo, som */
      let vp = null;
      const dropVideo = () => { if (vp) vp.stop(); };
      const showVideo = p => { if (!vp) vp = VideoPlayer.create(vimgEl); vp.show(p); };
      const paint = () => { const p = list[i]; if (!p) { close(); return; } const img = v.querySelector('.vimg > div'); dropVideo(); img.style.backgroundImage = Photos.bg(p);
        v.classList.toggle('is-video', !!p.video);
        if (p.video) {
          Photos.poster(p, true).then(u => { if (u && list[i] === p && img.isConnected) img.style.backgroundImage = Photos.bg(p); });
          showVideo(p);
        } else Photos.data(p, true).then(u => { if (u && list[i] === p && img.isConnected) img.style.backgroundImage = Photos.bg(p); });
        const d = new Date(p.created); v.querySelector('.pv-title b').textContent = UI.fmtDate(d, true); v.querySelector('.pv-title i').textContent = UI.fmtTime(d);
        const f = v.querySelector('.fav'); f.innerHTML = g(p.favorite ? 'heartFill' : 'heart'); f.classList.toggle('on', !!p.favorite); railV(); };
      /* PearPhone Fold: enquanto o visualizador está aberto os botões dele vivem na barra direita (voltar, mais, anterior/seguinte e
         editar em cima; partilhar, favorito, informações e apagar em baixo); as barras dele escondem-se (apps.css) */
      const railV = () => { if (!UI.railFor || !v.isConnected && !v._rv) return; v._rv = true; const p = list[i] || {}, tap = s => () => { const b = v.querySelector(s); if (b) b.click(); };
        UI.railFor(win, { back: { onTap: () => close(), label: 'Fotos' },
          groups: [[{ icon: 'more', label: 'Mais', onTap: () => ctx(list[i], v.querySelector('.pv-more')) }, { icon: 'pen', label: 'Editar', onTap: tap('.pe-open') }], [{ icon: 'chevU', label: 'Foto anterior', onTap: () => step(-1), disabled: list.length < 2 }, { icon: 'chevD', label: 'Foto seguinte', onTap: () => step(1), disabled: list.length < 2 }]],
          primary: [[{ icon: 'share', label: 'Partilhar', onTap: tap('.share') }, { icon: p.favorite ? 'heartFill' : 'heart', label: p.favorite ? 'Remover favorito' : 'Favorito', active: !!p.favorite, onTap: tap('.fav') }, { icon: 'info', label: 'Informações', onTap: tap('.inf') }, { icon: 'trash', label: 'Apagar', tint: 'red', onTap: tap('.del') }]] }); };
      const step = n => { if (list.length < 2) return; i = (i + n + list.length) % list.length; paint(); };
      const key = e => { if (!v.isConnected) { document.removeEventListener('keydown', key); return; } if (win.classList.contains('bg') || document.querySelector('.sheet-wrap,.overlay,.pe')) return; if (e.key === 'ArrowLeft') step(-1); else if (e.key === 'ArrowRight') step(1); else if (e.key === 'Escape') close(); };
      const close = () => { document.removeEventListener('keydown', key); dropVideo(); if (vp) { vp.destroy(); vp = null; } v.remove(); if (UI.railFor) UI.railFor(win, null); refreshAll(); };
      document.addEventListener('keydown', key);
      v.querySelector('.nb-back').onclick = close; v.querySelector('.pv-more').onclick = e => ctx(list[i], e.currentTarget);
      v.querySelector('.vimg').onclick = () => v.classList.toggle('bare');
      /* "Ligação externa": a foto é um link de fora (Adicionar por link / anexo guardado), não um ficheiro na conta */
      v.querySelector('.inf').onclick = () => { const p = list[i]; if (!p) return; const d = new Date(p.created); const T = s => (window.L && L.t ? L.t(s) : s); UI.alert({ title: UI.fmtDate(d, false, true), msg: UI.fmtTime(d) + ' · ' + T(p.video ? 'Vídeo' : 'Fotografia') + (Photos.isLink(p) ? ' · ' + T('Ligação externa') : '') + (p.favorite ? ' · ' + T('Favorita') : '') + '\n' + (window.L && L.tf ? L.tf('%s de %s', i + 1, list.length) : (i + 1) + ' de ' + list.length) }); };
      UI.swipe(v.querySelector('.vimg'), { left: () => step(1), right: () => step(-1), down: close });
      /* virar a estrela SÓ depois da resposta: a lista do visualizador é local e chegava a mostrar como
         favorita uma foto que o servidor tinha recusado (teto das favoritas) */
      v.querySelector('.fav').onclick = async () => { const r = await Photos.fav(list[i].id, !list[i].favorite); if (r && r.error) return; list[i].favorite = !list[i].favorite; paint(); };
      v.querySelector('.share').onclick = () => share(list[i]);
      /* Editar (apps/photoedit.js): Concluído substitui a foto - a nova entra no lugar da antiga nesta lista */
      v.querySelector('.pe-open').onclick = () => { if (list[i] && list[i].video) { UI.toast('Os vídeos não podem ser editados'); return; } if (!window.PhotoEdit) { UI.toast('Editor indisponível'); return; } const at = i; PhotoEdit.open(list[at], { host: win, onSaved: np => { list[at] = np; if (i === at) paint(); } }); };
      v.querySelector('.del').onclick = async () => { if (await UI.confirm('Apagar foto', '', 'Apagar', true)) { const r = await Photos.remove(list[i].id); if (r && r.error) return;   /* sem rede a foto continua lá: não a tirar da lista local */
        list.splice(i, 1); if (!list.length) { close(); return; } i = i % list.length; paint(); } };
      win.appendChild(v); paint();
    }
    /* ⚠️ os Álbuns liam Photos.cache de forma SÍNCRONA e não definiam v.paint: nunca chamavam
       load() nem eram atualizados pelo refreshAll - ficavam para sempre com o que houvesse ao abrir */
    const albums = () => { const v = UI.view({ title: 'Álbuns', large: true }); const gr = UI.el('<div class="album-grid"></div>'); v.content.appendChild(gr);
      const paint = () => { gr.innerHTML = ''; const all = Photos.cache, favs = all.filter(p => p.favorite), vids = all.filter(p => p.video);
        [['Recentes', all], ['Favoritos', favs], ['Vídeos', vids], ['Câmara', all.filter(p => p.url || p.len || p.seed > 199)]].forEach(([n, l]) => {
          const a = UI.el(`<div class="album"><div class="art" style="background-size:cover;background-position:center"></div><div class="t">${n}</div><div class="a">${l.length}</div></div>`);
          const art = a.querySelector('.art');
          if (l[0]) { art.style.background = Photos.bg(l[0]); art.style.backgroundSize = 'cover'; art.style.backgroundPosition = 'center'; Photos.lazy(art, l[0]); }
          else art.style.background = 'var(--fill3)';
          a.onclick = () => UI.push(win, grid(n, p => l.some(x => x.id === p.id))); gr.appendChild(a); }); };
      v.paint = paint; Photos.load().then(paint).catch(e => { console.error('[apex_phone] photos.load', e); paint(); }); return v; };
    UI.tabbar(win, [{ icon: 'photo', label: 'Biblioteca', view: () => grid('Biblioteca', () => true, true) }, { icon: 'heart', label: 'Favoritos', view: () => grid('Favoritos', p => p.favorite) }, { icon: 'grid', label: 'Álbuns', view: albums }], 0);
    const offPhotos = Bridge.on('photos', refreshAll); win.onClose = () => offPhotos();
  }
});

/* ===================== GALERIA NO ANDROID (Nova UI 8.5) =====================
   As MESMAS fotos e os MESMOS caminhos do PearOS (Photos.load/fav/remove, Msgs.sendPhoto, MailApp,
   AirDrop, PhotoEdit): uma foto tirada num iPhone aparece aqui e vice-versa. Só muda a apresentação:
   · separadores em baixo: Imagens, Álbuns, Histórias (os dias com várias fotos) e Menu;
   · título grande na zona de leitura com a contagem ("12 imagens, 2 vídeos"), que encolhe para a barra;
   · grelha de 4 colunas com cabeçalhos por dia; seleção múltipla (manter premido) com Tudo, por dia,
     e barra de ações em baixo (Partilhar, Favoritos, Eliminar);
   · visualizador que segue o tema (preto quando se esconde a interface), barra de baixo com Favorito,
     Editar, Partilhar e Eliminar, e Detalhes;
   · partilha pela folha da Partilha rápida (airdrop.js) com as apps por baixo.
   Nada se volta a animar quando a grelha se repinta (só a abertura das camadas anima).
   ============================================================================ */
window.GalleryNova = (() => {
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
  const esc = s => UI.esc(s);
  const DN = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
  const DNL = ['Domingo', 'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado'];
  const MS = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
  const MESES = ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'];
  const sameDay = (a, b) => a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
  const dayKey = ts => { const d = new Date(+ts || 0); return d.getFullYear() * 10000 + (d.getMonth() + 1) * 100 + d.getDate(); };
  function dayLabel(ts, long) {
    const d = new Date(+ts || 0), n = new Date(), y = new Date(n.getFullYear(), n.getMonth(), n.getDate() - 1);
    if (sameDay(d, n)) return T('Hoje');
    if (sameDay(d, y)) return T('Ontem');
    /* fora do português: a forma do próprio idioma (Intl), nunca "dia de mês" colado */
    if (window.L && L.code && L.code !== 'pt' && L.intl) { try {
      const o = long ? { weekday: 'long', day: 'numeric', month: 'long' } : { weekday: 'short', day: 'numeric', month: 'short' };
      if (d.getFullYear() !== n.getFullYear()) { o.year = 'numeric'; if (!long) delete o.weekday; }
      const s = new Intl.DateTimeFormat(L.intl(), o).format(d); return s.charAt(0).toUpperCase() + s.slice(1); } catch (e) {} }
    if (long) return `${T(DNL[d.getDay()])}, ${d.getDate()} ${T('de')} ${T(MESES[d.getMonth()])}` + (d.getFullYear() !== n.getFullYear() ? ' ' + d.getFullYear() : '');
    return d.getFullYear() === n.getFullYear() ? `${T(DN[d.getDay()])}, ${d.getDate()} ${T(MS[d.getMonth()])}` : `${d.getDate()} ${T(MS[d.getMonth()])} ${d.getFullYear()}`;
  }
  const plural = (n, one, many) => TF(n === 1 ? one : many, n);
  function countText(list) {
    const v = list.filter(p => p && p.video).length, i = list.length - v, out = [];
    if (i) out.push(plural(i, '%s imagem', '%s imagens'));
    if (v) out.push(plural(v, '%s vídeo', '%s vídeos'));
    return out.length ? out.join(', ') : T('Sem imagens');
  }
  /* nome da Partilha rápida: o alias do sistema se existir, senão o nome por omissão */
  const qsName = () => { const n = App.name('airdrop'); return n && n !== 'airdrop' ? n : T('Partilha rápida'); };
  /* glifos próprios (24×24, traço; a espessura vem do CSS) */
  const GL = {
    menu: '<path d="M4 7h16M4 12h16M4 17h16"/>',
    share: '<circle cx="17.5" cy="5.5" r="2.5"/><circle cx="6.5" cy="12" r="2.5"/><circle cx="17.5" cy="18.5" r="2.5"/><path d="m8.7 10.8 6.6-4M8.7 13.2l6.6 4"/>',
    edit: '<path d="M4 20h4L19 9a2.8 2.8 0 0 0-4-4L4 16z"/><path d="m13.5 6.5 4 4"/>',
    trash: '<path d="M4 6.5h16M9.5 6.5V4.5h5v2M6.5 6.5l.9 13a1.6 1.6 0 0 0 1.6 1.5h6a1.6 1.6 0 0 0 1.6-1.5l.9-13M10 10.5v6.5M14 10.5v6.5"/>',
    heart: '<path d="M12 20.3 4.7 13A4.9 4.9 0 0 1 12 6.4a4.9 4.9 0 0 1 7.3 6.6z"/>',
    heartFill: '<path fill="currentColor" d="M12 20.3 4.7 13A4.9 4.9 0 0 1 12 6.4a4.9 4.9 0 0 1 7.3 6.6z"/>',
    back: '<path d="M15 5l-7 7 7 7"/>',
    more: '<g fill="currentColor" stroke="none"><circle cx="12" cy="5.5" r="1.6"/><circle cx="12" cy="12" r="1.6"/><circle cx="12" cy="18.5" r="1.6"/></g>',
    x: '<path d="M6 6l12 12M18 6 6 18"/>',
    play: '<path fill="currentColor" stroke="none" d="M8 5.5v13l10.5-6.5z"/>',
    info: '<circle cx="12" cy="12" r="9"/><path d="M12 11v5.5M12 7.8v.2"/>',
    wall: '<rect x="5" y="2.5" width="14" height="19" rx="3"/><path d="m5 16 4.5-4.5 3.5 3.5 2-2 4 4"/>',
    video: '<rect x="2.5" y="6" width="13.5" height="12" rx="2.5"/><path d="m16 10.5 5.5-3v9l-5.5-3"/>',
    clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7.5V12l3 2"/>',
    camera: '<path d="M8.5 6 10 4h4l1.5 2H19a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2z"/><circle cx="12" cy="13" r="3.6"/>',
    qs: '<circle cx="12" cy="12" r="2"/><path d="M8 16a5.6 5.6 0 0 1 0-8M16 8a5.6 5.6 0 0 1 0 8M5.2 18.8a9.6 9.6 0 0 1 0-13.6M18.8 5.2a9.6 9.6 0 0 1 0 13.6"/>',
    link: '<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>',   /* "Adicionar por link" (Config.PhotoLinks) */
  };
  const ic = (n, cls) => `<svg class="agal-gl ${cls || ''}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">${GL[n] || ''}</svg>`;
  const iconBtn = (n, label, onTap, cls) => { const b = UI.el(`<div class="agal-ib ${cls || ''}" role="button" aria-label="${esc(label)}">${ic(n)}</div>`); b.onclick = e => { e.stopPropagation(); Sound.play('click'); onTap(b, e); }; return b; };

  /* Vista com título grande (zona de leitura) e barra presa em cima ao fazer scroll; com `back` há uma
     seta à esquerda (vistas empurradas: álbum, história). */
  function heroView(o) {
    const v = UI.el(`<div class="view agal-v ${o.full ? 'full' : ''} ${o.cls || ''}"><div class="agal-sb"></div><div class="content agal-sc"><div class="agal-hero"><b class="agal-ht"></b><span class="agal-hs"></span></div><div class="agal-bar"><div class="agal-bl"></div><div class="agal-bt"></div><div class="agal-ba"></div></div><div class="agal-body"></div></div></div>`);
    v.content = v.querySelector('.agal-sc'); v.body = v.querySelector('.agal-body'); v.opts = {};
    v.bar = v.querySelector('.agal-bar'); v.bl = v.querySelector('.agal-bl'); v.ba = v.querySelector('.agal-ba');
    const hero = v.querySelector('.agal-hero'), ht = v.querySelector('.agal-ht'), hs = v.querySelector('.agal-hs'), bt = v.querySelector('.agal-bt');
    v.setHero = (title, sub, small) => {
      if (ht.textContent !== title) ht.textContent = title;
      if (hs.textContent !== (sub || '')) hs.textContent = sub || '';
      const s = small || title; if (bt.textContent !== s) bt.textContent = s;
    };
    if (o.back) v.bl.appendChild(iconBtn('back', T('Voltar'), () => UI.pop(v), 'agal-back'));
    v.content.addEventListener('scroll', () => v.classList.toggle('agal-col', v.content.scrollTop > hero.offsetHeight - 8), { passive: true });
    return v;
  }
  const emptyEl = (title, sub) => UI.el(`<div class="agal-empty"><b>${esc(title)}</b>${sub ? `<span>${esc(sub)}</span>` : ''}</div>`);

  function open(win) {
    win.classList.add('agal-win');
    const refreshAll = () => win.querySelectorAll('.view').forEach(v => { try { v.paint && v.paint(); } catch (e) { console.error('[apex_phone] galeria', e); } });
    const tabsHidden = on => { const tb = win.querySelector(':scope > .tabbar'); if (tb) tb.classList.toggle('agal-tb-off', !!on); };
    let viewer = null;   /* visualizador aberto { close, el } */

    /* ---------- partilhar (os mesmos caminhos do PearOS) ---------- */
    async function sendToChat(c, p) {
      if (!window.Msgs || typeof Msgs.sendPhoto !== 'function') { UI.toast(T('Mensagens indisponíveis')); return; }
      const url = typeof p.url === 'string' && p.url ? p.url : null;
      if (url && /^data:/i.test(url)) UI.toast(T('A enviar a foto…'));
      const r = await Msgs.sendPhoto(c.number, url || p.seed, { seed: p.seed });
      UI.toast(r && !r.error ? T('Foto enviada') : T('A foto não foi enviada'));
    }
    const social = (id, p) => SocialShare.send(id, p);
    async function share(p) {
      if (!p) return;
      /* vídeo: Partilha rápida (copia a linha inteira na base de dados) e, por baixo, as redes onde o servidor deixa publicar vídeos
         (12 nov 2026: Instashot, Story, Reels, Tweeter). Mensagens e Mail continuam só com imagens. */
      if (p.video) {
        const ts = window.SocialShare && SocialShare.videoTargets ? await SocialShare.videoTargets() : [];
        const apps = ts.map(t => ({ id: t.app, label: T(t.short), onTap: () => SocialShare.send(t.app, p, t.kind) }));
        if (window.AirDrop && AirDrop.share) { AirDrop.share(p, { apps }); return; }
        if (!apps.length) { UI.toast(T('Os vídeos só podem ser partilhados por AirShare')); return; }
        const v = await UI.actionSheet({ title: T('Partilhar vídeo'), buttons: ts.map((t, k) => ({ label: t.label, value: k })) });
        if (v != null && apps[v]) apps[v].onTap();
        return;
      }
      await Photos.data(p, true);   /* partilhar precisa do base64, não da ficha */
      const inst = id => !System.isInstalled || System.isInstalled(id);
      const apps = [
        { id: 'messages', label: App.name('messages'), onTap: async () => { const c = await Contacts.pick(T('Enviar foto a')); if (c) sendToChat(c, p); } },
        { id: 'mail', label: App.name('mail'), onTap: () => { if (window.MailApp) MailApp.compose({ photo: p }); else UI.toast(T('Mail indisponível')); } },
      ];
      if (inst('instashot')) apps.push({ id: 'instashot', label: App.name('instashot'), onTap: () => social('instashot', p) });
      if (inst('twix')) apps.push({ id: 'twix', label: App.name('twix'), onTap: () => social('twix', p) });
      if (window.AirDrop && AirDrop.share) { AirDrop.share(p, { apps }); return; }
      const v = await UI.actionSheet({ title: T('Partilhar'), buttons: apps.map((a, i) => ({ label: a.label, value: i })) });
      if (v != null && apps[v]) apps[v].onTap();
    }
    async function setWallpaper(p) {
      if (p && p.video) { UI.toast(T('Os vídeos não podem ser usados como fundo')); return; }
      await Photos.data(p, true);
      const v = await UI.actionSheet({ title: T('Definir como fundo'), buttons: [{ label: T('Ecrã principal'), value: 'home' }, { label: T('Ecrã de bloqueio'), value: 'lock' }, { label: T('Ecrã principal e de bloqueio'), bold: true, value: 'both' }] });
      if (!v) return;
      const custom = { url: p.url || null, seed: p.url ? null : p.seed };
      if (v === 'home') System.setState({ wallpaperCustom: custom }); else if (v === 'lock') System.setState({ lockWallpaper: { custom } }); else System.setState({ wallpaperCustom: custom, lockWallpaper: null });
      UI.toast(T('Fundo atualizado'));
    }
    const editPhoto = (p, onSaved) => { if (!window.PhotoEdit) { UI.toast(T('Editor indisponível')); return; } PhotoEdit.open(p, { host: win, onSaved }); };

    /* ---------- GRELHA (Imagens, álbum, história) ---------- */
    function gridView(o) {
      const v = heroView({ cls: 'agal-gv ' + (o.cls || ''), back: o.back, full: o.full });
      const selBar = UI.el(`<div class="agal-selbar"><div data-a="share" role="button">${ic('share')}<span>${esc(T('Partilhar'))}</span></div><div data-a="fav" role="button">${ic('heart')}<span>${esc(T('Favoritos'))}</span></div><div data-a="del" role="button">${ic('trash')}<span>${esc(T('Eliminar'))}</span></div></div>`);
      v.appendChild(selBar);
      const all = UI.el(`<div class="agal-all" role="button"><i class="agal-ck"></i><span>${esc(T('Tudo'))}</span></div>`);
      v.bl.appendChild(all);
      const cancel = iconBtn('x', T('Cancelar'), () => endSel(), 'agal-selx');
      /* "Adicionar por link" (Config.PhotoLinks) só na grelha principal (Imagens), como na Biblioteca do PearOS */
      const linkItem = () => (o.withLink && Photos.linksOn() ? [{ label: T('Adicionar por link'), icon: 'link', onTap: () => Photos.addFromLink() }] : []);
      v.ba.append(iconBtn('more', T('Mais opções'), b => UI.ctxMenu(b, [{ label: T('Selecionar'), icon: 'checkCircle', onTap: () => startSel() }].concat(linkItem(), [{ label: T('Abrir a Câmara'), icon: 'camera', onTap: () => System.openApp('camera') }])), 'agal-norm'), cancel);
      let list = [], io = null, sel = null;
      const groups = [];
      const cell = (p, i) => {
        const c = UI.el(`<div class="agal-th"><i class="agal-ck"></i>${p.video ? `<span class="agal-vd">${ic('play')}${esc(UI.fmtDur(p.duration || 0))}</span>` : ''}</div>`);
        c.style.backgroundImage = Photos.bg(p);   /* pelo CSSOM, nunca dentro da string de HTML (base64 de 200 KB) */
        if (io) io.observe(c, p); else if (i < 16) Photos.lazy(c, p);
        if (sel && sel.has(p.id)) c.classList.add('on');
        c.onclick = () => { if (sel) { toggle(p.id, c); return; } openViewer(list, i); };
        UI.longPress(c, () => { if (!sel) startSel(); if (!sel.has(p.id)) toggle(p.id, c); });
        return c;
      };
      const paint = () => {
        list = Photos.cache.filter(o.filter);
        if (sel) { const ids = new Set(list.map(p => p.id)); [...sel].forEach(id => { if (!ids.has(id)) sel.delete(id); }); }
        if (io) { io.disconnect(); io = null; }
        /* repintar (favoritar, apagar, chegou uma foto) não pode atirar a grelha para o topo */
        const keepY = v.content.scrollTop;
        v.body.textContent = ''; groups.length = 0;
        const err = Photos.error;
        v.classList.toggle('agal-isempty', !list.length);   /* vazio: o aviso fica ao centro do espaco livre (oneui-apps2.css) */
        if (!list.length) {
          v.body.appendChild(err ? emptyEl(PHOTOS_ERR[err] || ('Erro: ' + err), T('Não foi possível carregar as fotos')) : emptyEl(T('Sem imagens'), o.emptySub || T('As fotos que tirares com a Câmara aparecem aqui.')));
          /* galeria vazia: a porta para uma imagem de fora fica à vista (Config.PhotoLinks) */
          if (!err && o.withLink && Photos.linksOn()) { const b = UI.el(`<div class="agal-mn-p agal-link-empty" role="button" style="margin:14px auto 0;width:max-content">${ic('link')}<span>${esc(T('Adicionar por link'))}</span></div>`); b.onclick = () => { Sound.play('click'); Photos.addFromLink(); }; v.body.appendChild(b); }
          if (sel) endSel(); else paintSel(); return;
        }
        io = Photos.lazyGrid(v.content);
        let key = null, grid = null;
        list.forEach((p, i) => {
          const k = dayKey(p.created);
          if (k !== key) {
            key = k;
            const sec = UI.el(`<div class="agal-sec"><div class="agal-sh" role="button"><i class="agal-ck"></i><b></b></div><div class="agal-grid"></div></div>`);
            sec.querySelector('b').textContent = dayLabel(p.created);
            const g = { sec, ids: [], head: sec.firstChild }; groups.push(g);
            g.head.onclick = () => { if (!sel) return; const every = g.ids.every(id => sel.has(id)); g.ids.forEach(id => { if (every) sel.delete(id); else sel.add(id); }); syncCells(); };
            grid = sec.lastChild; v.body.appendChild(sec);
          }
          groups[groups.length - 1].ids.push(p.id);
          const c = cell(p, i); c.dataset.id = p.id; grid.appendChild(c);
        });
        if (keepY && v.content.scrollTop !== keepY) v.content.scrollTop = keepY;
        paintSel();
      };
      const syncCells = () => { v.body.querySelectorAll('.agal-th').forEach(c => c.classList.toggle('on', !!sel && sel.has(+c.dataset.id))); paintSel(); };
      const paintSel = () => {
        if (!sel) { v.setHero(o.title, countText(list)); return; }
        const n = sel.size;
        v.setHero(n ? plural(n, '%s selecionado', '%s selecionados') : T('Selecionar itens'), countText(list), n ? plural(n, '%s selecionado', '%s selecionados') : T('Selecionar itens'));
        all.classList.toggle('on', !!list.length && n === list.length);
        groups.forEach(g => g.head.classList.toggle('on', g.ids.length > 0 && g.ids.every(id => sel.has(id))));
        selBar.querySelector('[data-a="share"]').classList.toggle('dis', n !== 1);
        selBar.querySelector('[data-a="fav"]').classList.toggle('dis', !n);
        selBar.querySelector('[data-a="del"]').classList.toggle('dis', !n);
        const favAll = n > 0 && list.filter(p => sel.has(p.id)).every(p => p.favorite);
        selBar.querySelector('[data-a="fav"] span').textContent = favAll ? T('Remover') : T('Favoritos');
        selBar.querySelector('[data-a="fav"]').classList.toggle('on', favAll);
      };
      const toggle = (id, c) => { if (sel.has(id)) sel.delete(id); else sel.add(id); c.classList.toggle('on', sel.has(id)); paintSel(); };
      const startSel = () => { if (sel || !list.length) return; sel = new Set(); v.classList.add('agal-selecting'); if (!o.full) tabsHidden(true); paintSel(); };
      const endSel = () => { if (!sel) return; sel = null; v.classList.remove('agal-selecting'); v.body.querySelectorAll('.agal-th.on,.agal-sh.on').forEach(x => x.classList.remove('on')); if (!o.full) tabsHidden(false); paintSel(); };
      v.endSel = () => { if (!sel) return false; endSel(); return true; };
      all.onclick = () => { if (!sel) return; Sound.play('click'); const every = list.length && sel.size === list.length; sel = new Set(every ? [] : list.map(p => p.id)); syncCells(); };
      selBar.onclick = async e => {
        const b = e.target.closest('[data-a]'); if (!b || !sel) return;
        const picked = list.filter(p => sel.has(p.id)), n = picked.length;
        if (b.dataset.a === 'share') { if (n !== 1) { UI.toast(T('Escolhe uma imagem para partilhar')); return; } share(picked[0]); return; }
        if (!n) return;
        if (b.dataset.a === 'fav') {
          if (window.CC && CC.requireNet && !CC.requireNet('mudar as favoritas')) return;
          const to = !picked.every(p => p.favorite);
          for (const p of picked) { if (!!p.favorite === to) continue; const r = await Bridge.rpcRaw('photos.fav', { id: p.id, favorite: to }); if (r && r.error === 'toomany') { UI.toast(+r.max > 0 ? TF('Máximo de %s favoritas', Math.floor(+r.max)) : T('Já tens o máximo de favoritas')); break; } }
          await Photos.load(); endSel(); refreshAll(); return;
        }
        if (b.dataset.a === 'del') {
          if (!await UI.confirm(plural(n, 'Eliminar %s item?', 'Eliminar %s itens?'), T('Esta ação não pode ser anulada.'), T('Eliminar'), true)) return;
          if (window.CC && CC.requireNet && !CC.requireNet('apagar fotos')) return;
          for (const p of picked) await Bridge.rpc('photos.remove', { id: p.id });
          await Photos.load(); endSel(); refreshAll(); UI.toast(plural(n, '%s item eliminado', '%s itens eliminados'));
        }
      };
      v.paint = paint;
      v.opts.onPop = () => { if (io) { io.disconnect(); io = null; } if (sel && !o.full) tabsHidden(false); };
      v.setHero(o.title, '');
      Photos.load().then(paint).catch(e => { console.error('[apex_phone] photos.load', e); paint(); });
      return v;
    }
    const pushGrid = (title, filter, emptySub) => UI.push(win, gridView({ title, filter, back: true, full: true, emptySub }));

    /* ---------- ÁLBUNS ---------- */
    const ALBUMS = () => [
      { n: T('Câmara'), f: p => !!(p.url || p.len || p.seed > 199) },
      { n: T('Favoritos'), f: p => !!p.favorite, e: T('Toca no coração de uma foto para a pores aqui.') },
      { n: T('Vídeos'), f: p => !!p.video, e: T('Os vídeos que gravares com a Câmara aparecem aqui.') },
      { n: T('Recentes'), f: () => true },
    ];
    const albumsView = () => {
      const v = heroView({ cls: 'agal-av' });
      const grid = UI.el('<div class="agal-alb"></div>'); v.body.appendChild(grid);
      v.paint = () => {
        const all = Photos.cache, al = ALBUMS();
        v.setHero(T('Álbuns'), plural(al.length, '%s álbum', '%s álbuns'));
        grid.textContent = '';
        al.forEach(a => {
          const l = all.filter(a.f);
          const c = UI.el(`<div class="agal-al" role="button"><div class="agal-alc"></div><b></b><span></span></div>`);
          c.querySelector('b').textContent = a.n; c.querySelector('span').textContent = String(l.length);
          const art = c.querySelector('.agal-alc');
          if (l[0]) { art.style.backgroundImage = Photos.bg(l[0]); Photos.lazy(art, l[0]); } else art.classList.add('none');
          c.onclick = () => pushGrid(a.n, a.f, a.e);
          grid.appendChild(c);
        });
      };
      v.paint(); Photos.load().then(v.paint).catch(() => v.paint());
      return v;
    };

    /* ---------- HISTÓRIAS: os dias com mais do que uma foto, como as histórias da Galeria ---------- */
    const storiesView = () => {
      const v = heroView({ cls: 'agal-stv' });
      const box = UI.el('<div class="agal-stl"></div>'); v.body.appendChild(box);
      v.paint = () => {
        const days = new Map();
        Photos.cache.forEach(p => { const k = dayKey(p.created); if (!days.has(k)) days.set(k, []); days.get(k).push(p); });
        const st = [...days.values()].filter(l => l.length > 1);
        v.setHero(T('Histórias'), st.length ? plural(st.length, '%s história', '%s histórias') : '');
        box.textContent = '';
        v.classList.toggle('agal-isempty', !st.length);
        if (!st.length) { box.appendChild(emptyEl(T('Ainda não há histórias'), T('Quando tirares várias fotos no mesmo dia, a Galeria junta-as aqui numa história.'))); return; }
        st.forEach(l => {
          const k = dayKey(l[0].created), title = dayLabel(l[0].created, true);
          const c = UI.el(`<div class="agal-st" role="button"><div class="agal-stc"></div><div class="agal-sto"><b></b><span></span></div></div>`);
          c.querySelector('b').textContent = title; c.querySelector('span').textContent = countText(l);
          const art = c.querySelector('.agal-stc'); art.style.backgroundImage = Photos.bg(l[0]); Photos.lazy(art, l[0]);
          c.onclick = () => pushGrid(title, p => dayKey(p.created) === k);
          box.appendChild(c);
        });
      };
      v.paint(); Photos.load().then(v.paint).catch(() => v.paint());
      return v;
    };

    /* ---------- MENU (o separador ≡): atalhos para os álbuns, a Partilha rápida e a Câmara ---------- */
    const menu = () => {
      const TILES = [['heart', T('Favoritos'), 1], ['video', T('Vídeos'), 2], ['clock', T('Recentes'), 3], ['camera', T('Câmara'), 0]];
      const body = UI.el(`<div class="agal-mn"><div class="agal-mn-row">${TILES.map(([i, n], k) => `<div class="agal-mn-t" data-k="${k}" role="button"><div>${ic(i)}</div><span>${esc(n)}</span></div>`).join('')}</div>
        <div class="agal-mn-pills"><div class="agal-mn-p" data-a="qs" role="button">${ic('qs')}<span>${esc(qsName())}</span></div><div class="agal-mn-p" data-a="cam" role="button">${ic('camera')}<span>${esc(T('Abrir a Câmara'))}</span></div></div></div>`);
      const sh = UI.sheet({ title: T('Menu'), right: T('Fechar'), body, cls: 'agal-mn-wrap' });
      body.onclick = e => {
        const t = e.target.closest('[data-k]'), p = e.target.closest('[data-a]');
        if (t) { const a = ALBUMS()[TILES[+t.dataset.k][2]]; sh.close(); Sound.play('click'); pushGrid(a.n, a.f, a.e); }
        else if (p && p.dataset.a === 'qs') { sh.close(); if (window.AirDrop && AirDrop.page) AirDrop.page(win, {}); }
        else if (p && p.dataset.a === 'cam') { sh.close(); System.openApp('camera'); }
      };
    };

    /* ---------- VISUALIZADOR ---------- */
    function openViewer(list, i) {
      if (viewer) viewer.close(true);
      list = list.slice();
      const v = UI.el(`<div class="agal-pv"><div class="agal-pv-img"><div></div></div>
        <div class="agal-pv-top"><div class="agal-pv-l"></div><div class="agal-pv-t"><b></b><span></span></div><div class="agal-pv-r"></div></div>
        <div class="agal-pv-bar"><div data-a="fav" role="button">${ic('heart')}</div><div data-a="edit" role="button">${ic('edit')}</div><div data-a="share" role="button">${ic('share')}</div><div data-a="del" role="button">${ic('trash')}</div></div></div>`);
      const img = v.querySelector('.agal-pv-img > div'), fav = v.querySelector('[data-a="fav"]');
      /* VÍDEO (1.1.4): capa no fundo + <video> por cima quando o webm chega (o mesmo do visualizador do PearOS) */
      const imgWrap = v.querySelector('.agal-pv-img');
      /* (ronda 2) o mesmo leitor próprio do PearOS (window.VideoPlayer), com a cara da Nova UI pelo CSS */
      let vp = null;
      const dropVideo = () => { if (vp) vp.stop(); };
      const showVideo = p => { if (!vp) vp = VideoPlayer.create(imgWrap); vp.show(p); };
      const paint = () => {
        const p = list[i]; if (!p) { close(); return; }
        dropVideo();
        img.style.backgroundImage = Photos.bg(p);
        v.classList.toggle('is-video', !!p.video);
        if (p.video) {
          Photos.poster(p, true).then(u => { if (u && list[i] === p && img.isConnected) img.style.backgroundImage = Photos.bg(p); });
          showVideo(p);
        } else Photos.data(p, true).then(u => { if (u && list[i] === p && img.isConnected) img.style.backgroundImage = Photos.bg(p); });
        const d = new Date(p.created);
        v.querySelector('.agal-pv-t b').textContent = dayLabel(p.created) === T('Hoje') || dayLabel(p.created) === T('Ontem') ? dayLabel(p.created) : (UI.monthName ? `${d.getDate()} ${UI.monthName(d.getMonth(), true)} ${d.getFullYear()}` : `${d.getDate()} ${T(MS[d.getMonth()])} ${d.getFullYear()}`);
        v.querySelector('.agal-pv-t span').textContent = UI.fmtTime(d);
        fav.innerHTML = ic(p.favorite ? 'heartFill' : 'heart'); fav.classList.toggle('on', !!p.favorite);
      };
      const step = n => { if (list.length < 2) return; i = (i + n + list.length) % list.length; paint(); };
      const key = e => {
        if (!v.isConnected) { document.removeEventListener('keydown', key); return; }
        if (win.classList.contains('bg') || document.querySelector('#screen .sheet-wrap, #screen .overlay, #screen .as-wrap, #screen .ctx-wrap') || win.querySelector('.agal-ed')) return;
        if (e.key === 'ArrowLeft') step(-1); else if (e.key === 'ArrowRight') step(1); else if (e.key === 'Escape') close();
      };
      const tone = () => { if (win._novaTone) win._novaTone(); };
      const close = quick => { document.removeEventListener('keydown', key); dropVideo(); if (vp) { vp.destroy(); vp = null; } if (viewer && viewer.el === v) viewer = null; if (quick) { v.remove(); tone(); return; } v.classList.remove('in', 'bare'); tone(); setTimeout(() => v.remove(), 220); refreshAll(); };
      const details = () => {
        const p = list[i]; if (!p) return;
        const d = new Date(p.created), kb = Math.max(1, Math.round(((p.url ? p.url.length : +p.len) || 0) * 0.75 / 1024));
        const items = [
          { label: T('Data'), value: UI.wdLong && UI.fmtDayMonth ? `${UI.wdLong(d)}, ${UI.fmtDayMonth(d, true)}` : `${T(DNL[d.getDay()])}, ${d.getDate()} ${T('de')} ${T(MESES[d.getMonth()])} ${T('de')} ${d.getFullYear()}` },
          { label: T('Hora'), value: UI.fmtTime(d) },
          { label: T('Tipo'), value: p.video ? T('Vídeo') + (p.duration ? ' · ' + UI.fmtDur(p.duration) : '') : T('Fotografia') },
          { label: T('Tamanho'), value: (p.url || p.len) ? kb + ' KB' : T('Desconhecido') },
          { label: T('Resolução'), value: '…' },
          { label: T('Na galeria'), value: TF('%s de %s', i + 1, list.length) },
          { label: T('Favorita'), value: p.favorite ? T('Sim') : T('Não') },
        ].map(x => Object.assign(x, { chevron: false }));
        const body = UI.list([{ items }]);
        UI.sheet({ title: T('Detalhes'), right: T('OK'), body, cls: 'agal-det' });
        /* na Nova UI o valor mostrado e a copia .ou-val (por baixo do rotulo); o .li-value fica escondido: escrevem-se os dois */
        const resLi = body.querySelectorAll('.li')[4];
        const fill = s => { if (resLi) resLi.querySelectorAll('.li-value, .ou-val').forEach(x => { x.textContent = s; }); };
        Photos.data(p, true).then(u => { if (!u) { fill(T('Não disponível')); return; }
          if (p.video) { const vd = document.createElement('video'); vd.preload = 'metadata'; vd.onloadedmetadata = () => { fill(vd.videoWidth ? vd.videoWidth + ' × ' + vd.videoHeight : T('Não disponível')); vd.removeAttribute('src'); }; vd.onerror = () => fill(T('Não disponível')); vd.src = u; return; }
          const im = new Image(); im.onload = () => fill(im.naturalWidth + ' × ' + im.naturalHeight); im.onerror = () => fill(T('Não disponível')); im.src = u; });
      };
      v.querySelector('.agal-pv-l').appendChild(iconBtn('back', T('Voltar'), () => close()));
      v.querySelector('.agal-pv-r').appendChild(iconBtn('more', T('Mais opções'), b => UI.ctxMenu(b, [{ label: T('Detalhes'), icon: 'info', onTap: details }, { label: T('Definir como fundo'), icon: 'photo', onTap: () => setWallpaper(list[i]) }])));
      v.querySelector('.agal-pv-img').onclick = () => { v.classList.toggle('bare'); tone(); };
      UI.swipe(v.querySelector('.agal-pv-img'), { left: () => step(1), right: () => step(-1), down: () => close(), up: details });
      v.querySelector('.agal-pv-bar').onclick = async e => {
        const b = e.target.closest('[data-a]'); if (!b) return; const p = list[i]; if (!p) return; Sound.play('click');
        if (b.dataset.a === 'fav') { const r = await Photos.fav(p.id, !p.favorite); if (r && r.error) return; p.favorite = !p.favorite; paint(); }
        else if (b.dataset.a === 'edit') { if (p.video) { UI.toast(T('Os vídeos não podem ser editados')); return; } const at = i; editPhoto(p, np => { list[at] = np; if (i === at) paint(); }); }
        else if (b.dataset.a === 'share') share(p);
        else if (b.dataset.a === 'del') {
          if (!await UI.confirm(T('Eliminar esta imagem?'), T('Esta ação não pode ser anulada.'), T('Eliminar'), true)) return;
          const r = await Photos.remove(p.id); if (r && r.error) return;   /* sem rede a foto continua lá */
          list.splice(i, 1); if (!list.length) { close(); return; } i = i % list.length; paint();
        }
      };
      document.addEventListener('keydown', key);
      paint(); win.appendChild(v); requestAnimationFrame(() => v.classList.add('in'));
      viewer = { el: v, close };
      return viewer;
    }

    /* ---------- barras do sistema por cima das camadas escuras ----------
       O editor é sempre escuro e o visualizador fica preto sem barras: aí a barra de estado tem de ser
       clara (texto branco) mesmo no tema claro. A Galeria acerta o seu statusBar e avisa o sistema; a
       classe na janela faz o SysUI voltar a medir a cor da barra de navegação (observa a classe). */
    win._novaTone = () => {
      const dark = !!win.querySelector('.agal-ed') || !!win.querySelector('.agal-pv.bare');
      const def = App.get('photos'); if (!def) return;
      const want = dark ? 'dark' : undefined;
      if (def.statusBar !== want) { def.statusBar = want; try { System.updateSbTheme(); } catch (e) {} }
      win.classList.toggle('agal-tone-dk', dark);
    };

    /* ---------- Voltar do Android: editor > visualizador > seleção ---------- */
    win._novaBack = () => {
      const ed = win.querySelector('.agal-ed');
      if (ed) { const c = ed.querySelector('[data-a="cancel"]'); if (c) c.click(); return true; }
      if (viewer) { viewer.close(); return true; }
      const top = win.querySelector('.nav-stack > .view:last-child');
      return !!(top && top.endSel && top.endSel());
    };

    const tabs = UI.tabbar(win, [
      { icon: 'photo', label: T('Imagens'), view: () => gridView({ title: T('Imagens'), filter: () => true, withLink: true }) },
      { icon: 'grid', label: T('Álbuns'), view: albumsView },
      { icon: 'film', label: T('Histórias'), view: storiesView },
    ], 0);
    /* o Menu vive na mesma barra, mas não é uma vista: abre o menu da Galeria */
    const mt = UI.el(`<div class="tab agal-mtab" role="button">${ic('menu')}<span>${esc(T('Menu'))}</span></div>`);
    mt.onclick = () => { Sound.play('click'); menu(); };
    (tabs.el.querySelector('.tb-pill') || tabs.el).appendChild(mt);
    win._novaTabs = tabs;

    /* a miniatura da Câmara abre a última fotografia, como na Nova UI */
    const offLatest = Bridge.on('gallery:latest', () => { if (!win.isConnected) return; Photos.load().then(() => { const l = Photos.cache.filter(() => true); if (l.length) openViewer(l, 0); }); });
    const offPhotos = Bridge.on('photos', refreshAll);
    win.onClose = () => { offPhotos(); offLatest(); const def = App.get('photos'); if (def && def.statusBar === 'dark') def.statusBar = undefined; };
  }
  return { open };
})();

/* ===================== CÂMARA =====================
   O visor é uma <canvas> WebGL com a vista do JOGO lá dentro (js/gamerender.js): o telemóvel FICA
   no ecrã, inteiro, e o que se vê no visor é EXATAMENTE o que sai na fotografia - a foto é o
   próprio canvas (toDataURL), não um screenshot do ecrã.
   Quem ENQUADRA continua a ser a câmara scriptada do client/camera.lua (frontal/traseira, zoom,
   arrastar): é ela que decide o que a vista do jogo mostra. Na mão fica só o prop do dispositivo
   (a CellCam do GTA punha um segundo telemóvel na mão e devolvia frames pretos).
   ==================================================== */

/* /camtest (client/camera.lua): o visor vive AQUI, na NUI, por isso é aqui que se mede.
   Abre um canvas próprio, desenha um frame e diz se o WebGL existe e se a imagem tem conteúdo. */
Bridge.on('camtest', () => {
  let r = null, cv = null;
  try {
    if (!window.GameRender || !GameRender.available()) { Bridge.call('camtestResult', { available: false }); return; }
    cv = document.createElement('canvas');
    cv.width = 320; cv.height = 240; cv.style.cssText = 'position:absolute;left:-9999px;top:0';
    document.body.appendChild(cv);
    r = GameRender.create(cv, { aspect: 4 / 3, autoResize: false });
    if (!r.live) { Bridge.call('camtestResult', { available: false }); return; }
    r.renderOnce();
    Bridge.call('camtestResult', { available: true, w: r.canvas.width, h: r.canvas.height, black: r.isBlack() });
  } catch (e) {
    console.error('[apex_phone] camtest', e);
    Bridge.call('camtestResult', { available: false });
  } finally {
    try { r && r.destroy(); } catch (e) {}
    try { cv && cv.remove(); } catch (e) {}
  }
});

App.define('camera', {
  name: 'Câmara', core: true, category: 'Criatividade', statusBar: 'dark', killOnClose: true, needs: ['camera'], landscape: 'hold',   /* deita-se com o aparelho (fotos ao baixo); a janela não roda */
  /* Voltar do Android (SysUI): fecha primeiro o "Mais" e a régua de inclinação da câmara */
  back(win) { try { return !!(win && win._cam && win._cam.back && win._cam.back()); } catch (e) { return false; } },
  /* Atalho "Selfie": esperar 500 ms pela app era uma aposta - à primeira utilização aparece
     ANTES o pedido de permissão da Câmara, e o prazo passava com a app ainda por abrir (a selfie
     saía com a câmara traseira). Espera-se pelo evento que o System emite quando a janela já
     existe; o prazo fica só como rede para o caso de o jogador recusar a permissão. */
  actions: [{ label: 'Selfie', icon: 'personCircle', onTap: () => {
    if (System.currentApp() === 'camera') { Bridge.emit('camera:front'); return; }
    const off = Bridge.on('app:open', id => { if (id !== 'camera') return; off(); Bridge.emit('camera:front'); });
    setTimeout(off, 20000);
    System.openApp('camera');
  } }],
  open(win) {
    /* A câmara INTEIRA vive em js/camview.js (CamView.mount) - o mesmo módulo que o Instashot
       usa para os stories, para "tirar fotos igual à app Câmara" ser literalmente verdade.
       Aqui só se liga o que é da APP: para onde vai o ‹, a miniatura e o fecho em todos os caminhos. */
    const cam = CamView.mount(win.querySelector('.nav-stack'), {
      /* FECHAR antes de abrir as Fotos: abrir outra app por cima só ESCONDE esta janela (hideCurrent),
         não corre o win.onClose - ficava um contexto WebGL + rAF vivos e, pior, o `cameraMode` do Lua
         ligado, com o HUD do jogador escondido e a câmara scriptada presa a ele.
         No Android a miniatura abre logo a última fotografia na Galeria, como na Nova UI. */
      onThumb: () => {
        const nova = window.System && System.os === 'android';
        System.closeApp(true);
        setTimeout(() => {
          if (!nova) { System.openApp('photos'); return; }
          let sent = false;
          const go = () => { if (sent) return; sent = true; off(); setTimeout(() => Bridge.emit('gallery:latest'), 120); };
          const off = Bridge.on('app:open', id => { if (id === 'photos') go(); });
          setTimeout(off, 15000);
          System.openApp('photos');
          if (System.currentApp() === 'photos') go();
        }, 60);
      },
      onBack: () => System.closeApp(true),
    });
    win._cam = cam;
    /* ⚠️ ABRIR OUTRA APP POR CIMA NÃO CORRE O win.onClose.
       O System só chama `hideCurrent()` (que faz `def.pause`, e esta app não tem pause): a janela
       fica escondida mas VIVA - e com ela a camada de arrasto a cobrir o ecrã inteiro, os
       listeners no documento e, pior, o `cameraMode` LIGADO no Lua: HUD escondido, câmara ligada
       e o KeepInput a deixar o jogador andar enquanto escrevia na app nova.
       Esta app é `killOnClose: true` - passar para outra app é fechá-la de vez. O `dead` trata do
       caminho normal (aí o killApp já correu e este ouvinte já saiu). */
    const offGone = Bridge.on('app:close', id => { if (!cam.dead && id === 'camera') System.killApp('camera'); });
    win.onClose = () => { offGone(); cam.destroy(); };
  }
});
