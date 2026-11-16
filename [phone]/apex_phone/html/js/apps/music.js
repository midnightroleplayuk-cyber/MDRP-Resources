/* ============================================================
   MÚSICA - TubeMusic no telemóvel, com a MESMA API e a MESMA
   biblioteca do apex_carplay (server/music.lua → exports MusicRPC):
   · pesquisa/sugestões/álbuns/playlists/artistas/rádio/letras via InnerTube
   · gostos, músicas guardadas, playlists, fila e histórico guardados no servidor por personagem
   · reprodução local por um player do YouTube escondido (iframe, som ligado desde o 1.º frame,
     volume relido a cada tick) com fallback para mirrors (Piped/Invidious) quando o vídeo não embebe
   · "Reproduzir no carro": entrega a faixa ao CarLink (evento apex_carplay:mx:play) e o rádio do carro toca-a
   · fornecedor INTERNO com Config.Music.Search (2026-10-26): a pesquisa é aberta a todo o YouTube (feita no servidor, server/music.lua),
     um link colado toca logo, e um vídeo que não embebe (100/101/150) tenta "outra versão" (music.alt) antes de passar à seguinte
   Design PearOS (Apple Music): Início · Pesquisar · Biblioteca, mini-player, ecrã "A tocar".
   window.Player mantém a API antiga (cur/playing/pos/toggle/next/prev) para a ilha, Centro de Controlo, widgets e Vera.
   ============================================================ */
window.Music = (() => {
  const g = UI.g, esc = UI.esc;
  const ARTS = ['linear-gradient(135deg,#ff2d55,#7b1030)', 'linear-gradient(135deg,#0088FF,#00c3d0)', 'linear-gradient(135deg,#ff9230,#ff4245)', 'linear-gradient(135deg,#34c759,#00c0e8)', 'linear-gradient(135deg,#db34f2,#ff375f)', 'linear-gradient(135deg,#64748b,#1e293b)', 'linear-gradient(135deg,#facc15,#a16207)', 'linear-gradient(135deg,#06b6d4,#4338ca)'];
  const NOART = 'linear-gradient(135deg,#2b2b34,#131318)';
  const artOf = i => ARTS[(Number(i) || 0) % ARTS.length];
  const hashArt = key => { let h = 0; const s = String(key || ''); for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) | 0; return artOf(Math.abs(h)); };
  const colorsOf = grad => { const m = String(grad || '').match(/#[0-9a-fA-F]{6}/g) || []; return [m[0] || '#FF2D55', m[1] || '#7B1030']; };
  const artCss = (img, fb) => (typeof img === 'string' && /^(https?:|data:)/i.test(img)) ? `url("${img.replace(/"/g, '%22')}") center/cover no-repeat` : (fb || NOART);
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  const plural = (n, w, ws) => n + ' ' + (n === 1 ? w : (ws || w + 's'));

  /* ---------- estado ---------- */
  const MU = {
    songs: new Map(), likes: [], lib: [], playlists: [], recents: [], queue: [], seeded: false,
    now: null, order: [], idx: -1, ctx: { k: 'lib', label: 'Biblioteca' }, shuffle: false, repeat: 'off',
    playing: false, elapsed: 0, dur: 0, vol: (window.System && System.state && System.state.volume) || 60,
    status: '', home: null, homeState: 'idle', results: null, searching: false, sugg: [], lyrics: null,
    ok: true, carplay: false, car: false, inCar: false, cfg: { mode: 'auto', piped: [], invidious: [], quality: 'small', persist: true },
    loaded: false, saveT: null, failRun: 0, listeners: new Set(),
    retryT: null, autoSeq: 0,   /* salto adiado depois de uma falha e rádio pendente do fim da lista: o stop() cancela os dois */
    likeRev: 0,                 /* sobe a cada mudança nos gostos: os corações das linhas pintam-se no sítio (paintBar) */
    search: false,              /* pesquisa ABERTA no YouTube (Config.Music.Search com o fornecedor interno): links colados, "outra versão" */
  };
  /* vídeos que o YouTube recusou embeber NESTA sessão (100 apagado/privado, 101/150 o dono bloqueia fora do YouTube): voltar a
     escolhê-los salta logo para a "outra versão"/a seguinte, sem esperar 2 s por um iframe que vai dar o mesmo erro, e a linha
     fica esbatida. Só a sessão: um 150 pode ser de uma região ou de uma janela de direitos. */
  const DEAD = new Map();
  const markDead = (vid, text) => { if (!vid) return; DEAD.delete(vid); DEAD.set(vid, text || ''); if (DEAD.size > 400) DEAD.delete(DEAD.keys().next().value); };
  const isVid = v => typeof v === 'string' && /^[\w-]{11}$/.test(v);
  const defImg = vid => `https://i.ytimg.com/vi/${vid}/mqdefault.jpg`;
  const song = id => MU.songs.get(id) || null;
  /* `pv` = o vídeo que toca DE FACTO quando o original não embebe (encontrado pela "outra versão"): o id da faixa nos gostos e
     playlists continua o original, só a reprodução muda; grava-se com a biblioteca para não voltar a procurar */
  const put = raw => {
    if (!raw || !raw.id) return null; const id = String(raw.id); const old = MU.songs.get(id);
    const s = old || { id, kind: id.startsWith('yt:') ? 'yt' : (/^https?:/i.test(id) ? 'url' : 'file'), vid: id.startsWith('yt:') ? id.slice(3) : null, t: 'Desconhecido', a: '', alb: null, len: 0, img: null, grad: hashArt(id) };
    if (raw.t) s.t = String(raw.t); if (raw.a) s.a = String(raw.a); if (raw.alb) s.alb = String(raw.alb); if (raw.len > 0) s.len = Math.round(Number(raw.len)); if (raw.img) s.img = String(raw.img);
    if (isVid(raw.pv) && raw.pv !== s.vid) s.pv = raw.pv;
    if (!s.img && s.vid) s.img = defImg(s.vid);
    MU.songs.set(id, s); return s;
  };
  const songArt = s => s ? artCss(s.img, s.grad) : NOART;
  const setDur = (id, d) => { const s = song(id); if (!s || !(d > 0)) return; const v = Math.round(d); if (s.len !== v) { s.len = v; saveSoon(); } };
  /* funil único de mudança de estado do leitor: é daqui que o relógio de 1 s nasce e morre
     (syncTick está declarada como `function`, por isso já existe quando isto corre) */
  const emit = () => { syncTick(); MU.listeners.forEach(f => { try { f(); } catch (e) {} }); };
  /* catálogo + biblioteca: o protocolo RPC do PRÓPRIO CarLink (apex_carplay:rpc), via client/main.lua ('carplayRpc') - o caminho por exports no
     servidor ficava pendurado. No browser cai nos handlers de demonstração registados em baixo. Devolve o resultado ou { error }. */
  const DEMO_MAP = { mxSearch: a => ['music.search', { q: a[0] }], mxSuggest: a => ['music.suggest', { q: a[0] }], mxBrowse: a => ['music.browse', { id: a[0], kind: a[1] }], mxRadio: a => ['music.radio', { vid: a[0] }], mxLyrics: a => ['music.lyrics', { vid: a[0] }], mxHome: () => ['music.home', {}], mxLoad: () => ['music.load', {}], mxSave: a => ['music.save', a[0]], mxAlt: a => ['music.alt', a[0]] };
  /* Fornecedor: 'internal' (o próprio telemóvel) ou 'apex_carplay'. Vem do music.status
     e fica aqui em cache. Por omissão INTERNO - a app não depende de mais nenhum resource;
     as chaves do DEMO_MAP são exatamente os nomes dos RPC do telemóvel, por isso serve os dois. */
  let PROVIDER = 'internal';
  /* interno: rpcRaw e não rpc - o rpc() troca qualquer { error } por null e a app só sabia dizer "o servidor não respondeu";
     assim chega o motivo real ('timeout', 'ratelimit', 'limited', 'offline', 'badlink') e a nota diz o que se passou */
  const mx = (name, ...args) => {
    const m = DEMO_MAP[name];
    if (!m) return Promise.resolve({ error: 'unknown' });
    const [n, d] = m(args);
    if (!Bridge.inFiveM) return Promise.resolve(LocalDB.rpc(n, d));
    if (PROVIDER !== 'apex_carplay') return Bridge.rpcRaw(n, d).then(r => (r == null ? { error: 'rpc' } : r), () => ({ error: 'rpc' }));
    /* CarLink: fala-se com o protocolo dele diretamente (o caminho por exports no servidor ficava pendurado) */
    return Bridge.call('carplayRpc', { name, args, n: args.length }).then(r => (r == null ? { error: 'rpc' } : r));
  };
  const openSearch = () => MU.search && PROVIDER !== 'apex_carplay';
  Bridge.on('ready', () => { Bridge.rpc('music.status').then(s => { if (s && s.provider) PROVIDER = s.provider; if (s) MU.search = !!s.search; }); });
  /* link do YouTube colado na pesquisa → id do vídeo; '' = é do YouTube mas não é um vídeo (canal, playlist); null = não é link.
     O servidor (server/music.lua linkVid) volta a verificar: isto só serve para a app saber que é um link antes da resposta. */
  const linkVid = q => {
    const s = String(q || '').trim(); if (!s || s.length > 400 || /\s/.test(s) || !/(?:youtube\.com|youtu\.be|youtube-nocookie\.com)\//i.test(s)) return null;
    const m = /[?&]v=([\w-]{11})(?![\w-])/.exec(s) || /youtu\.be\/([\w-]{11})(?![\w-])/.exec(s) || /\/(?:shorts|embed|live|v)\/([\w-]{11})(?![\w-])/.exec(s);
    return m ? m[1] : '';
  };
  const bad = r => !r || (typeof r === 'object' && !Array.isArray(r) && r.error);

  /* ---------- biblioteca (gostos, guardadas, playlists, fila, histórico) ---------- */
  const liked = id => MU.likes.includes(id);
  function toggleLike(id) { if (!id) return; const i = MU.likes.indexOf(id); if (i >= 0) { MU.likes.splice(i, 1); UI.toast('Removido dos gostos'); } else { MU.likes.unshift(id); UI.toast('Adicionado aos gostos'); } MU.likeRev++; saveSoon(); emit(); }
  const inLib = id => MU.lib.includes(id);
  function libAdd(id, quiet) { if (!id || inLib(id)) return; MU.lib.unshift(id); saveSoon(); if (!quiet) UI.toast('Guardada nas tuas músicas'); emit(); }
  function libRemove(id) { const i = MU.lib.indexOf(id); if (i < 0) return; MU.lib.splice(i, 1); saveSoon(); emit(); }
  const pl = id => MU.playlists.find(p => p.id === id) || null;
  function plNew(name, note, art) { const p = { id: 'p' + Date.now().toString(36) + Math.floor(Math.random() * 1e4).toString(36), name: (name || 'Nova playlist').slice(0, 60), note: (note || '').slice(0, 160), art: art != null ? Number(art) : Math.floor(Math.random() * ARTS.length), made: Math.floor(Date.now() / 1000), tracks: [] }; MU.playlists.unshift(p); saveSoon(); emit(); return p; }
  function plAdd(plId, songId, quiet) { const p = pl(plId); if (!p || !songId) return; if (p.tracks.includes(songId)) { if (!quiet) UI.toast('Já está em ' + p.name); return; } p.tracks.push(songId); saveSoon(); if (!quiet) UI.toast('Adicionada a ' + p.name); emit(); }
  function plAddMany(plId, ids) { const p = pl(plId); if (!p) return; let n = 0; ids.forEach(id => { if (!p.tracks.includes(id)) { p.tracks.push(id); n++; } }); saveSoon(); UI.toast(n ? `${plural(n, 'música')} em ${p.name}` : 'Já estavam em ' + p.name); emit(); }
  function plRemoveAt(plId, i) { const p = pl(plId); if (!p || i < 0 || i >= p.tracks.length) return; p.tracks.splice(i, 1); saveSoon(); emit(); }
  function plDelete(plId) { const i = MU.playlists.findIndex(p => p.id === plId); if (i < 0) return; MU.playlists.splice(i, 1); saveSoon(); emit(); }
  const plCover = p => { const first = p.tracks.find(id => { const s = song(id); return s && s.img; }); const s = first ? song(first) : null; return s ? s.img : null; };
  const plArt = p => artCss(plCover(p), artOf(p.art));
  function queueAdd(id, next) { if (!id) return; if (next) MU.queue.unshift(id); else MU.queue.push(id); saveSoon(); UI.toast(next ? 'A seguir' : 'Adicionada à fila'); emit(); }
  function recent(id) { if (!id) return; MU.recents = [id].concat(MU.recents.filter(x => x !== id)).slice(0, 60); saveSoon(); }

  /* persistência: só as músicas referenciadas; servidor (mesma tabela do CarLink) + localStorage como primeira pintura */
  /* cache local POR PERSONAGEM (Store.namespace): com a chave fixa, a biblioteca de uma personagem aparecia na outra no mesmo PC */
  const KEY_ = () => 'apexphone:' + ((window.Store && Store.namespace) ? Store.namespace + ':' : '') + 'music';
  /* Com a pesquisa aberta a biblioteca cresce com qualquer faixa do YouTube, e a gravação vai NUM evento de rede (NUI → cliente →
     servidor): acima de ~384 KB o limitador do FXServer deita-o fora em silêncio. No fornecedor interno cada música grava-se
     COMPACTA: sem o `vid` (sai do id 'yt:<vid>' no put) e sem a miniatura quando é a do i.ytimg.com que o put refaz do vid
     (~120 caracteres por música em vez de ~260). Com o apex_carplay fica o formato completo: a biblioteca é a MESMA do CarLink. */
  function pack() {
    const keep = new Set(); const add = id => { if (id) keep.add(id); };
    MU.likes.forEach(add); MU.lib.forEach(add); MU.recents.forEach(add); MU.queue.forEach(add); MU.playlists.forEach(p => p.tracks.forEach(add)); add(MU.now);
    const full = PROVIDER === 'apex_carplay';
    const songs = {}; keep.forEach(id => { const s = MU.songs.get(id); if (!s) return;
      if (full) { songs[id] = { id: s.id, vid: s.vid, t: s.t, a: s.a, alb: s.alb, len: s.len, img: s.img }; if (s.pv) songs[id].pv = s.pv; return; }
      const o = { id: s.id, t: s.t }; if (s.vid && s.id !== 'yt:' + s.vid) o.vid = s.vid; if (s.a) o.a = s.a; if (s.alb) o.alb = s.alb; if (s.len > 0) o.len = s.len;
      if (s.img && !(s.vid && s.img === defImg(s.vid))) o.img = s.img; if (s.pv) o.pv = s.pv; songs[id] = o; });
    return { v: 4, songs, seeded: true, likes: MU.likes.slice(), lib: MU.lib.slice(), recents: MU.recents.slice(), queue: MU.queue.slice(), playlists: MU.playlists.map(p => ({ id: p.id, name: p.name, note: p.note, art: p.art, made: p.made, tracks: p.tracks.slice() })) };
  }
  const SAVE_MAX = 200000;   /* caracteres: margem para os 384 KB do netEventSize (um título em CJK ocupa 3 bytes por caractere) */
  function unpack(data) {
    if (!data || typeof data !== 'object') return false;
    const songs = data.songs || {}; Object.keys(songs).forEach(id => put(songs[id]));
    const ok = id => typeof id === 'string' && MU.songs.has(id); const arr = v => Array.isArray(v) ? v : Object.values(v || {});
    MU.likes = arr(data.likes).filter(ok); MU.likeRev++; MU.lib = arr(data.lib).filter(ok); MU.recents = arr(data.recents).filter(ok); MU.queue = arr(data.queue).filter(ok);
    MU.playlists = arr(data.playlists).map(p => ({ id: String(p.id || ''), name: String(p.name || 'Playlist'), note: String(p.note || ''), art: Number(p.art) || 0, made: Number(p.made) || 0, tracks: arr(p.tracks).filter(ok) })).filter(p => p.id);
    MU.seeded = true; return true;
  }
  function saveSoon() { clearTimeout(MU.saveT); MU.saveT = setTimeout(saveNow, 1400); }
  /* grande demais: primeiro largam-se as capas e os álbuns (refazem-se do vid / não fazem falta para tocar); se nem assim couber
     num evento, fica só no localStorage deste PC e a app avisa UMA vez (antes o servidor recusava acima de 400 KB sem dizer nada) */
  function saveNow() {
    MU.saveT = null; const packed = pack(); let txt = JSON.stringify(packed);
    if (txt.length > SAVE_MAX && PROVIDER !== 'apex_carplay') { Object.keys(packed.songs).forEach(k => { delete packed.songs[k].img; delete packed.songs[k].alb; }); txt = JSON.stringify(packed); }
    try { localStorage.setItem(KEY_(), txt); } catch (e) {}
    if (MU.cfg.persist === false) return;
    if (txt.length > SAVE_MAX) { if (!MU.bigWarned) { MU.bigWarned = true; UI.toast('A tua biblioteca de música é grande demais para guardar no servidor.'); } return; }
    mx('mxSave', packed);
  }
  async function load() {
    ytWhenReady(() => {});   /* a API do YouTube começa já a descarregar (como no CarLink): no 1.º play chegava DEPOIS do iframe e o handshake ia todo pelo raw - o YT.Player ficava sem getters */
    if (!MU.loaded) { try { const raw = localStorage.getItem(KEY_()); if (raw) unpack(JSON.parse(raw)); } catch (e) {} MU.loaded = true; }
    const st = await Bridge.rpc('music.status'); if (st && typeof st === 'object') { MU.ok = st.ok !== false; MU.carplay = !!st.carplay && st.car !== false; MU.search = !!st.search; if (st.provider) PROVIDER = st.provider; if (st.cfg) MU.cfg = Object.assign(MU.cfg, st.cfg); }
    if (!MU.ok) { emit(); return; }
    const data = await mx('mxLoad'); if (data && typeof data === 'object' && !data.error) { unpack(data); emit(); } else if (data && data.error === 'empty' && (MU.playlists.length || MU.likes.length || MU.lib.length)) saveNow();
  }

  /* ---------- o player do YouTube (iframe escondido) ---------- */
  const YTAPI = { state: 'idle', waiting: [] };
  function ytWhenReady(fn) {
    if (YTAPI.state === 'ready' || YTAPI.state === 'failed') { fn(); return; }
    YTAPI.waiting.push(fn); if (YTAPI.state !== 'idle') return; YTAPI.state = 'loading';
    const flush = () => YTAPI.waiting.splice(0).forEach(f => { try { f(); } catch (e) {} });
    window.onYouTubeIframeAPIReady = () => { YTAPI.state = 'ready'; flush(); };
    const s = document.createElement('script'); s.src = 'https://www.youtube.com/iframe_api'; s.onerror = () => { if (YTAPI.state !== 'ready') { YTAPI.state = 'failed'; flush(); } }; document.head.appendChild(s);
    setTimeout(() => { if (YTAPI.state === 'loading') { YTAPI.state = 'failed'; flush(); } }, 9000);
  }
  /* fora do <body>: guardar o telemóvel põe `hidden` (display:none) no PRÓPRIO body, e um iframe numa subárvore display:none é
     estrangulado pelo Chromium (a música com o telemóvel fechado / AirBuds ficava a arrastar) - o CarLink faz o mesmo ("lives outside #app") */
  const host = () => { let h = document.getElementById('ytHost'); if (!h) { h = document.createElement('div'); h.id = 'ytHost'; document.documentElement.appendChild(h); } return h; };
  const errText = code => code === 101 || code === 150 ? 'O autor deste vídeo bloqueia a reprodução fora do YouTube.' : code === 100 ? 'Este vídeo foi removido ou é privado.' : code === 153 ? 'O YouTube não aceitou esta página (erro 153).' : `O YouTube recusou este vídeo (erro ${code}).`;
  let ytSeq = 0;
  function ytOpen(vid, opts) {
    const p = { key: ++ytSeq, vid, api: null, frame: null, state: -1, muted: false, want: clamp(Math.round(opts.vol != null ? opts.vol : 60), 0, 100), cur: 0, dur: 0, pendingSeek: opts.seek > 1.5 ? opts.seek : null, ready: false, sounded: false, ended: false, paused: false, triedMuted: false, rebuilt: false, volMiss: 0, reported: false, dead: false, err: 0, born: Date.now(), onEnd: opts.onEnd, onFail: opts.onFail };
    const raw = msg => { try { p.frame.contentWindow.postMessage(JSON.stringify(msg), '*'); } catch (e) {} };
    p.cmd = (func, args) => { if (p.api && typeof p.api[func] === 'function') { try { p.api[func].apply(p.api, args || []); return; } catch (e) {} } if (!p.frame) return; raw({ event: 'command', func, args: args || [], id: p.key, channel: 'widget' }); raw({ event: 'command', func, args: args || [], channel: 'widget' }); };
    const build = () => { const f = document.createElement('iframe'); f.setAttribute('allow', 'autoplay; encrypted-media'); f.setAttribute('frameborder', '0'); const q = ['autoplay=1', 'mute=0', 'controls=0', 'disablekb=1', 'playsinline=1', 'rel=0', 'fs=0', 'iv_load_policy=3', 'modestbranding=1', 'enablejsapi=1', 'widgetid=' + p.key]; if (/^https?:/i.test(location.origin || '')) q.push('origin=' + encodeURIComponent(location.origin)); f.src = `https://www.youtube.com/embed/${vid}?${q.join('&')}`; return f; };
    /* qualquer posicao vale (antes so > 1,5 s: arrastar a barra para o inicio, ou o "anterior" que volta a 0, eram ignorados) */
    const applySeek = () => { const at = p.pendingSeek; p.pendingSeek = null; if (at == null) return; const d = p.dur > 0 ? p.dur : 0; const to = d > 0 ? at % d : at; if (to >= 0) p.cmd('seekTo', [to, true]); };
    /* ARRASTAR A BARRA (2026-10-01, "nao funciona arrastar a barra da musica"): o YouTube demora a aplicar o seekTo e, ate la,
       o getCurrentTime/infoDelivery ainda devolve o tempo ANTIGO. O pump lia-o 250 ms depois e a barra voltava para tras, como
       se o arrasto nao tivesse feito nada. Durante 2,5 s depois de um salto mostra-se a posicao pedida; se o leitor ainda nao
       la chegou ao fim de 0,9 s, o seekTo vai outra vez. */
    const SEEK_HOLD = 2500;
    const guardCur = c => {
      if (!p.seekT) return c;
      const age = Date.now() - p.seekT;
      if (age > SEEK_HOLD) { p.seekT = 0; return c; }
      if (Math.abs(c - p.seekAt) <= 2) { p.seekT = 0; return c; }
      if (!p.seekRetry && age > 900) { p.seekRetry = true; p.cmd('seekTo', [p.seekAt, true]); }
      return p.seekAt;
    };
    /* 1.ª vez que o vídeo toca de facto (estado 1, pelo evento OU pelos getters do pump): é aqui que a "outra versão" fica confirmada */
    const firstPlay = () => { if (p.played || p.dead) return; p.played = true; try { opts.onPlay && opts.onPlay(); } catch (e) {} };
    p.onState = s => { if (typeof s !== 'number' || p.dead) return; p.state = s; if (s === 1) { p.sounded = true; p.ended = false; firstPlay(); if (p.want > 0) p.cmd('unMute'); p.cmd('setVolume', [p.want]); if (p.pendingSeek != null) applySeek(); } else if (s === 0) { p.ended = true; p.onEnd && p.onEnd(); } else if ((s === 2 || s === 5) && !p.ended && !p.paused) p.cmd('playVideo'); };
    const attach = () => { if (p.dead || p.api || YTAPI.state !== 'ready' || !window.YT || !window.YT.Player) return; try { p.api = new window.YT.Player(p.frame, { events: { onReady: e => { if (p.dead) return; p.ready = true; try { e.target.unMute(); } catch (x) {} if (MU.cfg.quality) p.cmd('setPlaybackQuality', [MU.cfg.quality]); p.cmd('setVolume', [p.want]); p.cmd('playVideo'); if (p.pendingSeek != null) applySeek(); }, onStateChange: e => { p.ready = true; p.onState(e.data); }, onError: e => { p.err = Number(e.data) || 0; p.reported = true; p.onFail && p.onFail(p.err === 101 || p.err === 150 ? 'no-embed' : 'refused', errText(p.err), p.err); } } }); } catch (e) {} };
    const pump = () => {
      if (p.dead) return;
      if (p.api) { try { if (p.api.getPlayerState) p.state = p.api.getPlayerState(); const c = p.api.getCurrentTime && p.api.getCurrentTime(); if (typeof c === 'number') p.cur = guardCur(c); if (p.api.isMuted) p.muted = !!p.api.isMuted(); const d = p.api.getDuration && p.api.getDuration(); if (d > 0) p.dur = d; if (p.state === 1) { p.sounded = true; firstPlay(); } } catch (e) {} }
      else if (p.frame) raw({ event: 'listening', id: p.key, channel: 'widget' });
      const age = Date.now() - p.born;
      if (!p.ready) { if (age > 15000 && !p.reported) { p.reported = true; p.onFail && p.onFail('no-connection', 'O browser do jogo não chegou ao youtube.com.'); } return; }
      if (p.paused) { if (p.state === 1) p.cmd('pauseVideo'); return; }
      if (p.state === 1) {
        let real = null; try { if (p.api && p.api.getVolume) real = p.api.getVolume(); } catch (e) {}
        const wrong = (p.want > 0 && p.muted) || (real != null && Math.abs(real - p.want) > 2);
        if (wrong) { p.volMiss++; if (p.want > 0) p.cmd('unMute'); p.cmd('setVolume', [p.want]); if (p.volMiss > 12) { if (!p.rebuilt) { p.rebuilt = true; rebuild(); } else if (!p.reported) { p.reported = true; p.onFail && p.onFail('silent', 'O player do YouTube corre mas recusa o volume.'); } } } else p.volMiss = 0;
        if (p.pendingSeek != null) applySeek(); return;
      }
      if (p.ended) return;
      if (p.state === 3) { if (!p.sounded && age > 24000 && !p.reported) { p.reported = true; p.onFail && p.onFail('stalled', 'O vídeo ficou a carregar e nunca tocou.'); } return; }
      p.cmd('playVideo');
      if (!p.triedMuted && !p.sounded && age > 5000) { p.triedMuted = true; p.cmd('mute'); p.cmd('playVideo'); }
      if (!p.sounded && age > 7000 && !p.reported) { p.reported = true; p.onFail && p.onFail('no-start', 'O player embebido nunca arrancou.'); }
    };
    const rebuild = () => { if (p.dead) return; const at = p.cur || 0; try { p.api && p.api.destroy && p.api.destroy(); } catch (e) {} try { p.frame && p.frame.remove(); } catch (e) {} p.api = null; p.ready = false; p.state = -1; p.muted = false; p.volMiss = 0; p.sounded = false; p.born = Date.now(); p.pendingSeek = at > 1.5 ? at : null; p.frame = build(); host().appendChild(p.frame); ytWhenReady(attach); };
    p.setVolume = v => { p.want = clamp(Math.round(v), 0, 100); if (!p.ready) return; if (p.want > 0 && p.muted) p.cmd('unMute'); p.cmd('setVolume', [p.want]); };
    p.pause = on => { p.paused = !!on; p.cmd(on ? 'pauseVideo' : 'playVideo'); };
    p.seek = at => { p.pendingSeek = at; p.cur = at; p.seekAt = at; p.seekT = Date.now(); p.seekRetry = false; if (p.ready) applySeek(); };
    p.close = () => { if (p.dead) return; p.dead = true; clearInterval(p.timer); try { p.api && p.api.destroy && p.api.destroy(); } catch (e) {} try { p.frame && p.frame.remove(); } catch (e) {} p.api = null; p.frame = null; };
    p.frame = build(); host().appendChild(p.frame); ytWhenReady(attach); p.timer = setInterval(pump, 250);
    /* mensagens do protocolo "raw" (quando a API não carrega) */
    p.onMsg = d => { if (d.event === 'onReady' || d.event === 'initialDelivery') { p.ready = true; if (p.want > 0) p.cmd('unMute'); p.cmd('setVolume', [p.want]); p.cmd('playVideo'); if (p.pendingSeek != null) applySeek(); } const info = d.info; if (info && typeof info === 'object') { if (typeof info.currentTime === 'number') p.cur = guardCur(info.currentTime); if (info.duration > 0) p.dur = info.duration; if (typeof info.muted === 'boolean') p.muted = info.muted; if (typeof info.playerState === 'number') p.onState(info.playerState); } if (d.event === 'onStateChange') p.onState(Number(d.info)); if (d.event === 'onError') { p.err = Number(d.info) || 0; p.reported = true; p.onFail && p.onFail(p.err === 101 || p.err === 150 ? 'no-embed' : 'refused', errText(p.err), p.err); } };
    return p;
  }
  window.addEventListener('message', ev => { if (typeof ev.data !== 'string' || ev.data.charAt(0) !== '{') return; let d; try { d = JSON.parse(ev.data); } catch (e) { return; } if (!d || !d.event) return; const st = ST.cur; if (st && st.yt && st.yt.frame && st.yt.frame.contentWindow === ev.source && !st.yt.dead) st.yt.onMsg(d); });

  /* ---------- o motor: uma faixa a tocar de cada vez ---------- */
  const ST = { cur: null };   /* { id, songId, ytId, yt, el, plan, token, dead, paused } */
  function mirrorPlan(vid) {
    const plan = [];
    (MU.cfg.piped || []).forEach(base => plan.push({ label: 'piped', get: () => fetch(base.replace(/\/+$/, '') + '/streams/' + vid, { cache: 'no-store' }).then(r => r.ok ? r.json() : Promise.reject(new Error('http ' + r.status))).then(j => { const list = (j && j.audioStreams) || []; let best = null; list.forEach(s => { if (!s.url) return; const br = Number(s.bitrate) || 0; if (!best || br > best.br) best = { url: s.url, br }; }); if (!best) throw new Error('sem streams'); return best.url; }) }));
    (MU.cfg.invidious || []).forEach(base => plan.push({ label: 'invidious', get: () => Promise.resolve(base.replace(/\/+$/, '') + '/latest_version?id=' + vid + '&itag=140&local=true') }));
    return plan;
  }
  function dropEl(st) { if (!st || !st.el) return; const a = st.el; st.el = null; try { a.pause(); a.removeAttribute('src'); a.load(); } catch (e) {} }
  function openElement(st, url) {
    dropEl(st); const a = new Audio(); a.preload = 'auto'; a.src = url; a.volume = clamp(MU.vol / 100, 0, 1); st.el = a;
    const live = () => !st.dead && st.el === a && ST.cur === st;
    a.addEventListener('loadedmetadata', () => { if (!live()) return; if (isFinite(a.duration) && a.duration > 0) { setDur(st.songId, a.duration); MU.dur = a.duration; } });
    a.addEventListener('ended', () => { if (live()) trackEnded(); });
    a.addEventListener('error', () => { if (!live()) return; if (st.plan) { tryMirror(st); return; } streamFailed(st, 'Não foi possível reproduzir esta faixa.'); });
    if (!st.paused) { const pr = a.play(); if (pr && pr.catch) pr.catch(() => {}); }
  }
  function tryMirror(st) {
    if (st.dead) return; dropEl(st); if (st.yt) { st.yt.close(); st.yt = null; } st.token++;
    const step = (st.plan || []).shift(); if (!step) { streamFailed(st, 'Não há forma de tocar este vídeo daqui: o YouTube recusou embebê-lo e nenhum mirror respondeu.'); return; }
    const guard = st.token; step.get().then(url => { if (st.dead || st.token !== guard) return; openElement(st, url); }).catch(() => { if (st.dead || st.token !== guard) return; tryMirror(st); });
  }
  /* 100 = apagado/privado, 101/150 = o dono não deixa tocar fora do YouTube: são do VÍDEO (repetir não muda nada). 153 e os
     'no-start'/'stalled'/'no-connection' são do browser/da rede e não marcam o vídeo. */
  const PERMA = c => c === 100 || c === 101 || c === 150;
  function embedFailed(st, reason, text, code) {
    if (st.dead) return; if (PERMA(code)) markDead(st.ytId, text);
    const canMirror = MU.cfg.mode !== 'embed' && st.plan == null && mirrorPlan(st.ytId).length > 0;
    if (st.yt) { st.yt.close(); st.yt = null; }
    if (canMirror) { st.token++; st.plan = mirrorPlan(st.ytId); MU.status = 'Este vídeo não embebe. A tentar um mirror de áudio…'; emit(); tryMirror(st); return; }
    if (PERMA(code) && tryAlt(st, text)) return;
    streamFailed(st, text);
  }
  /* "OUTRA VERSÃO" (pesquisa aberta, fornecedor interno): muitas faixas das editoras não tocam embebidas (150). O servidor procura
     a MESMA música noutro vídeo (music.alt: título e duração parecidos, sem slowed/cover/live...) e tentam-se até 3, por ordem.
     A 1.ª que tocar fica como `pv` da faixa (gravado) e o jogador é avisado; nenhuma → streamFailed (aviso + a seguinte).
     Sem pesquisa aberta ou com o apex_carplay devolve false e tudo segue como antes. */
  function tryAlt(st, text) {
    const s = song(st.songId); if (!s || !s.vid || st.altTried || !openSearch()) return false;
    st.altTried = true; st.token++; const guard = st.token;
    MU.status = 'A procurar outra versão…'; emit();
    mx('mxAlt', { vid: s.vid, t: s.t, a: s.a, len: s.len }).then(r => {
      if (st.dead || st.token !== guard || ST.cur !== st) return;
      st.alts = (r && Array.isArray(r.alts) ? r.alts : []).filter(v => isVid(v) && v !== s.vid && v !== st.ytId && !DEAD.has(v)).slice(0, 3);
      nextAlt(st, text);
    });
    return true;
  }
  function nextAlt(st, text) {
    if (st.dead || ST.cur !== st) return;
    const v = (st.alts || []).shift(); if (!v) { streamFailed(st, text); return; }
    st.token++; const guard = st.token; st.ytId = v;
    st.yt = ytOpen(v, { vol: MU.vol, seek: 0,
      onPlay: () => { if (st.dead || st.token !== guard) return; const s = song(st.songId); if (s && s.pv !== v) { s.pv = v; saveSoon(); } MU.status = ''; UI.toast('Este vídeo não toca fora do YouTube: a tocar outra versão.'); emit(); },
      onEnd: () => { if (!st.dead && st.token === guard) trackEnded(); },
      onFail: (reason, t2, code) => { if (st.dead || st.token !== guard) return; if (st.yt) { st.yt.close(); st.yt = null; } if (PERMA(code)) markDead(v, t2);
        if (reason === 'no-connection') { streamFailed(st, t2); return; } nextAlt(st, text); } });
    if (st.paused) st.yt.pause(true);   /* pausado enquanto se procurava: a outra versão nasce pausada */
  }
  function streamFailed(st, text) {
    if (st.dead) return; kill(); MU.status = text; UI.toast(text); MU.failRun++;
    /* faixa SOZINHA (pré-escuta das stories e do Match, um link colado, um cartão): não há "seguinte", pára aqui. Antes caía no
       fim da lista e nascia uma rádio a partir de uma faixa que nem toca - por cima do editor de stories. */
    if (MU.order.length <= 1 && !MU.queue.length) { MU.failRun = 0; MU.playing = false; emit(); return; }
    if (MU.failRun >= 3) { MU.failRun = 0; MU.status = text + (osA() ? ' Três seguidas: a lista parou.' : ' Três seguidas: a lista parou.'); MU.playing = false; emit(); return; }
    /* o salto adiado guarda o handle: fechar a app (app:kill → stop) ou parar a música dentro destes
       550 ms deixava-o vivo, e ele ressuscitava a reprodução - iframe novo e pump de 250 ms - com a app fechada */
    emit(); clearTimeout(MU.retryT); MU.retryT = setTimeout(() => { MU.retryT = null; if (MU.playing) advance(1, true); }, 550);
  }
  /* o motor corre sem a janela (Vera, Match, Stories): o texto segue o sistema de AGORA, nao o da ultima janela aberta (V.android) */
  function osA() { return !!(window.System && System.os === 'android'); }
  function kill() { const st = ST.cur; if (!st) return; st.dead = true; st.token++; if (st.yt) { st.yt.close(); st.yt = null; } dropEl(st); ST.cur = null; }
  function openStream(s, at) {
    /* toca a "outra versão" já encontrada (pv) enquanto ela não falhar; um vídeo que já recusou nesta sessão nem abre o iframe */
    kill(); const vid = s.vid ? ((s.pv && !DEAD.has(s.pv)) ? s.pv : s.vid) : null;
    const st = { songId: s.id, ytId: vid, yt: null, el: null, plan: null, token: 0, dead: false, paused: false }; ST.cur = st;
    if (vid && MU.cfg.mode !== 'mirror') {
      const guard = st.token;
      if (DEAD.has(vid)) { const text = DEAD.get(vid) || errText(150); setTimeout(() => { if (st.dead || st.token !== guard || ST.cur !== st) return; if (!tryAlt(st, text)) streamFailed(st, text); }, 0); return; }
      st.yt = ytOpen(vid, { vol: MU.vol, seek: at || 0, onEnd: () => { if (!st.dead && st.token === guard) trackEnded(); }, onFail: (reason, text, code) => { if (st.dead || st.token !== guard) return; embedFailed(st, reason, text, code); } });
    } else if (vid) { st.plan = mirrorPlan(vid); tryMirror(st); }
    else openElement(st, s.id);
  }

  /* ---------- transporte ---------- */
  const shuffled = (list, first) => { const rest = list.filter(x => x !== first); for (let i = rest.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); const t = rest[i]; rest[i] = rest[j]; rest[j] = t; } return first ? [first].concat(rest) : rest; };
  function start(list, ctx, startId) {
    const ids = (list || []).filter(id => MU.songs.has(id)); if (!ids.length) { UI.toast('Nada para tocar'); return; }
    const first = startId && ids.includes(startId) ? startId : ids[0];
    MU.order = MU.shuffle ? shuffled(ids, first) : ids.slice(); MU.idx = MU.order.indexOf(first); MU.ctx = ctx || { k: 'lib', label: 'Biblioteca' }; MU.failRun = 0; playId(first);
  }
  function playId(id) {
    const s = song(id); if (!s) return;
    MU.now = id; if (!MU.order.includes(id)) { MU.order = [id]; MU.idx = 0; } else MU.idx = MU.order.indexOf(id);
    MU.status = ''; MU.lyrics = null; MU.elapsed = 0; MU.dur = s.len || 0; MU.playing = true; recent(id);
    if (MU.car) { kill(); Bridge.call('musicCar', { src: s.id, title: s.t, artist: s.a, img: s.img, len: s.len, vol: MU.vol }).then(r => { if (r && r.ok === false) { MU.car = false; UI.toast(osA() ? (r.err === 'nocar' ? 'Não estás num veículo: a tocar no telemóvel.' : 'O CarLink não está disponível: a tocar no telemóvel.') : (r.err === 'nocar' ? 'Não estás num veículo: a tocar no telemóvel.' : 'O CarLink não está disponível: a tocar no telemóvel.')); openStream(s, 0); emit(); } }); }
    else openStream(s, 0);
    if (window.Island && System.currentApp() !== 'music') Island.tick(new Date());
    emit();
  }
  function stop() { clearTimeout(MU.retryT); MU.retryT = null; MU.autoSeq++; kill(); if (MU.car) Bridge.call('musicCarStop'); MU.playing = false; emit(); }
  function pauseResume() {
    if (!MU.now) { playHome(); return; }
    const st = ST.cur;
    if (!st && !MU.car) { playId(MU.now); return; }
    MU.playing = !MU.playing;
    if (MU.car) Bridge.call('musicCarSeek', { pos: MU.elapsed, playing: MU.playing });
    else if (st) { st.paused = !MU.playing; if (st.yt) st.yt.pause(!MU.playing); else if (st.el) { if (MU.playing) { const p = st.el.play(); p && p.catch && p.catch(() => {}); } else st.el.pause(); } }
    emit();
  }
  function seekTo(t) {
    const dur = MU.dur || (song(MU.now) || {}).len || 0; const at = clamp(t, 0, dur > 0 ? dur : t); MU.elapsed = at; const st = ST.cur;
    if (MU.car) Bridge.call('musicCarSeek', { pos: at, playing: MU.playing });
    else if (st) { if (st.yt) st.yt.seek(at); else if (st.el) { try { st.el.currentTime = at; } catch (e) {} } }
    emit();
  }
  function advance(dir, auto) {
    if (dir > 0 && MU.queue.length) { const id = MU.queue.shift(); saveSoon(); if (!MU.order.includes(id)) MU.order = MU.order.slice(0, MU.idx + 1).concat([id]); MU.idx = MU.order.indexOf(id); playId(id); return; }
    if (!MU.order.length) { playHome(); return; }
    if (auto && MU.repeat === 'one') { playId(MU.now); return; }
    let i = MU.idx + dir;
    if (i >= MU.order.length) { if (MU.repeat === 'all') i = 0; else if (auto) { autoContinue(); return; } else i = 0; }
    if (i < 0) i = MU.order.length - 1;
    MU.idx = i; playId(MU.order[i]);
  }
  function prev() { if (MU.elapsed > 4) { seekTo(0); return; } advance(-1, false); }
  function autoContinue() {
    const last = MU.now; const s = last ? song(last) : null; if (!s || !s.vid) { MU.playing = false; emit(); return; }
    MU.status = 'Fim da lista. A criar uma rádio a partir de ' + s.t + '…'; emit();
    const my = ++MU.autoSeq;   /* um stop() enquanto a rádio vem a caminho não pode ser desfeito pela resposta */
    mx('mxRadio', s.vid).then(list => { if (my !== MU.autoSeq) return; const ids = (Array.isArray(list) ? list : []).map(t => { const x = put(t); return x && x.id; }).filter(Boolean); MU.status = ''; if (!ids.length) { MU.playing = false; emit(); return; } start([last].concat(ids), { k: 'radio', label: 'Rádio · ' + s.t, id: s.vid }, ids[0]); });
  }
  function trackEnded() { if (MU.elapsed > 2) setDur(MU.now, MU.elapsed); advance(1, true); }
  const homeList = () => MU.lib.length ? MU.lib.slice() : (MU.likes.length ? MU.likes.slice() : MU.recents.slice());
  function playHome() { const list = homeList(); if (!list.length) { UI.toast('Pesquisa algo primeiro'); return; } start(list, { k: 'lib', label: 'Biblioteca' }); }
  function startRadio(id) { const s = song(id); if (!s || !s.vid) { UI.toast('Só a partir de faixas do YouTube'); return; } UI.toast('A criar rádio…'); mx('mxRadio', s.vid).then(list => { const ids = (Array.isArray(list) ? list : []).map(t => { const x = put(t); return x && x.id; }).filter(Boolean); if (!ids.length) { UI.toast('O YouTube não tinha nada para seguir'); return; } start([id].concat(ids), { k: 'radio', label: 'Rádio · ' + s.t, id: s.vid }, id); }); }
  async function toCar(on) {
    if (on) { const st = await Bridge.call('musicCarState'); if (!st || !st.carplay) { UI.toast('O CarLink não está disponível neste servidor.'); return; } if (!st.inCar) { UI.toast('Entra num veículo para tocar no carro.'); return; } MU.car = true; if (MU.now) { const at = MU.elapsed; const s = song(MU.now); kill(); const r = await Bridge.call('musicCar', { src: s.id, title: s.t, artist: s.a, img: s.img, len: s.len, vol: MU.vol }); if (!r || r.ok === false) { MU.car = false; UI.toast('Não foi possível entregar ao carro.'); openStream(s, at); } else { if (at > 2) Bridge.call('musicCarSeek', { pos: at, playing: MU.playing }); UI.toast('A tocar no carro'); } } }
    else { const at = MU.elapsed; MU.car = false; Bridge.call('musicCarStop'); if (MU.now && MU.playing) openStream(song(MU.now), at); UI.toast('A tocar no telemóvel'); }
    emit();
  }
  function applyVol() { const st = ST.cur; if (st && st.yt) st.yt.setVolume(MU.vol); if (st && st.el) st.el.volume = clamp(MU.vol / 100, 0, 1); if (MU.car) Bridge.call('musicCarVol', { vol: MU.vol }); }
  /* relógio: onde a faixa está de facto.
     ⚠️ Antes isto era um setInterval criado no ARRANQUE do telemóvel e a acordar de
     segundo a segundo para SEMPRE, mesmo em quem nunca abriu a app de Música (o corpo
     saía logo no `if (!MU.playing) return`). Agora o relógio só existe enquanto houver
     som: `syncTick()` é chamado pelo `emit()`, que é o funil por onde passa toda a
     mudança de estado do leitor. */
  let tickT = null;
  function musicTick() {
    if (!MU.playing) { syncTick(); return; }
    const st = ST.cur;
    if (MU.car) { MU.elapsed += 1; const len = (song(MU.now) || {}).len || 0; if (len > 0 && MU.elapsed >= len + 1) trackEnded(); }
    else if (st && !st.paused) { if (st.el) { MU.elapsed = st.el.currentTime || 0; if (isFinite(st.el.duration) && st.el.duration > 0) MU.dur = st.el.duration; } else if (st.yt) { MU.elapsed = st.yt.cur || 0; if (st.yt.dur) { MU.dur = st.yt.dur; setDur(MU.now, st.yt.dur); } } if (MU.elapsed > 3) { MU.failRun = 0; if (MU.status) MU.status = ''; } }
    emit();
  }
  function syncTick() {
    const want = !!MU.playing;
    if (want && !tickT) tickT = setInterval(musicTick, 1000);
    else if (!want && tickT) { clearInterval(tickT); tickT = null; }
  }

  /* ---------- catálogo ---------- */
  /* os títulos das prateleiras vêm do CarLink em inglês → português */
  const SHELF = { 'From YouTube': 'Do YouTube', 'Songs': 'Músicas', 'Albums': 'Álbuns', 'Playlists': 'Playlists', 'Artists': 'Artistas', 'Videos': 'Vídeos', 'Top result': 'Melhor resultado', 'Community playlists': 'Playlists da comunidade', 'Featured playlists': 'Playlists em destaque', 'Episodes': 'Episódios', 'Podcasts': 'Podcasts', 'Profiles': 'Perfis', 'Quick picks': 'Escolhas rápidas', 'Listen again': 'Ouvir de novo', 'Mixed for you': 'Misturas para ti', 'Recommended albums': 'Álbuns recomendados', 'New releases': 'Novidades', 'Charts': 'Tops', 'Trending': 'Em tendência', 'Moods & genres': 'Estados de espírito e géneros', 'Recommended': 'Recomendado', 'Popular': 'Popular', 'Top songs': 'Músicas mais ouvidas', 'Results': 'Resultados' };
  const shelfTitle = t => SHELF[t] || t;
  const shelfGroup = sh => { const items = sh.items || []; let t = 0, al = 0, p = 0, ar = 0; items.forEach(it => { if (it.vid) t++; else if (it.kind === 'album') al++; else if (it.kind === 'artist') ar++; else p++; }); const m = Math.max(t, al, p, ar); return !items.length ? 'other' : m === t ? 'songs' : m === al ? 'albums' : m === ar ? 'artists' : 'playlists'; };
  /* live = pesquisa ao vivo (a escrever): os resultados anteriores ficam no ecrã até chegar a resposta e o campo não perde o foco.
     A mesma pergunta não vai duas vezes ao servidor: se já está no ecrã (Enter depois da pesquisa ao vivo) ou a caminho, não faz nada;
     as últimas respostas ficam em cache - apagar uma letra e voltar ao texto anterior é instantâneo. */
  let searchSeq = 0, searchQ = '', searchCache = new Map();
  async function search(q, live) {
    q = String(q || '').trim(); if (!q) { searchSeq++; MU.results = null; MU.searching = false; emit(); return; }
    if (MU.results && MU.results.q === q && !MU.results.error && !MU.searching) { emit(); return; }   /* já está no ecrã; o emit repinta os chips (doSearch pôs o filtro em 'Tudo') */
    if (MU.searching && searchQ === q) return;
    const seq = ++searchSeq; searchQ = q; let res = searchCache.get(q);
    if (!res) { MU.searching = true; if (!live) MU.results = null; emit(); res = await mx('mxSearch', q); if (seq !== searchSeq) return; if (res && !res.error) { searchCache.set(q, res); if (searchCache.size > 24) searchCache.delete(searchCache.keys().next().value); } }
    if (live) { const inp = $v('.vm-search input'); if (inp && inp.value.trim() === q) hideSugg(); }   /* chegaram os resultados: a lista de sugestões saía de cima deles */
    MU.searching = false; const shelves = (res && res.shelves) || []; shelves.forEach(sh => (sh.items || []).forEach(it => { if (it.vid) put(it); })); if (res && res.top && res.top.vid) put(res.top);
    MU.results = { q, top: (res && res.top) || null, link: (res && res.link) || null, shelves: shelves.map(sh => ({ title: shelfTitle(sh.title), items: sh.items || [], group: shelfGroup(sh) })), error: (res && res.error) || (!res ? 'rpc' : null) }; emit();
    /* link do YouTube colado: toca JÁ esse vídeo (os resultados mostram-no para dar gosto/guardar/pôr numa playlist) */
    if (res && res.link && res.top && res.top.vid) { const s = put(res.top); if (s && (MU.now !== s.id || !MU.playing)) start([s.id], { k: 'search', label: 'YouTube', id: null }, s.id); }
  }
  /* motivo de uma falha do servidor → frase para o utilizador (o server/music.lua devolve error = 'nocarplay' | 'noexport' | 'timeout' | 'error';
     com a pesquisa aberta também 'ratelimit' (este jogador), 'limited'/'busy' (o YouTube a travar o servidor), 'offline'/'bad' (sem caminho
     até ao YouTube ou resposta que não se lê) e 'badlink' (link do YouTube que não é de um vídeo) */
  const srvErr = e => e === 'nocarplay' ? (osA() ? 'O apex_carradio não está a correr no servidor e a Música precisa dele.' : 'O apex_carradio não está a correr no servidor: a Música precisa dele.') : e === 'noexport' ? 'O apex_carradio que está a correr é a versão antiga (sem MusicRPC). Na consola do servidor: restart apex_carradio.' : e === 'timeout' ? 'O TubeMusic não respondeu a tempo. Tenta outra vez.' : e === 'rpc' ? 'O servidor não respondeu (vê a consola F8 / do servidor).'
    : e === 'ratelimit' ? 'Demasiados pedidos seguidos. Tenta daqui a pouco.' : (e === 'limited' || e === 'busy') ? 'O YouTube está a recusar pedidos deste servidor. Tenta daqui a pouco.' : (e === 'offline' || e === 'bad') ? 'O servidor não conseguiu chegar ao YouTube. Tenta outra vez.' : e === 'badlink' ? 'Este link não é de um vídeo do YouTube.'
    : e ? 'Erro do servidor: ' + e : '';
  /* Início vazio SEM erro (fornecedor interno com o Config.Music.Library vazio e a pesquisa aberta) é "pronto", não "falhou":
     antes mostrava "Sem sugestões" a quem só usa a pesquisa */
  async function loadHome(force) { if (MU.homeState === 'loading' || (MU.homeState === 'ready' && !force)) return; MU.homeState = 'loading'; emit(); const res = await mx('mxHome'); const shelves = (res && res.shelves) || []; shelves.forEach(sh => (sh.items || []).forEach(it => { if (it.vid) put(it); })); MU.home = shelves.map(sh => ({ title: shelfTitle(sh.title), items: sh.items || [], group: shelfGroup(sh) })); MU.homeErr = (res && res.error) || (!res ? 'rpc' : null); MU.homeState = shelves.length || (openSearch() && !MU.homeErr) ? 'ready' : 'failed'; emit(); }
  async function loadLyrics(vid) { if (!vid || (MU.lyrics && MU.lyrics.vid === vid)) return; MU.lyrics = { vid, loading: true }; emit(); const res = await mx('mxLyrics', vid); if (!MU.lyrics || MU.lyrics.vid !== vid) return; MU.lyrics = (res && res !== false && res.text) ? { vid, text: res.text, source: res.source } : { vid, none: true }; emit(); }
  async function playQuery(q) { const res = await Bridge.rpc('music.search', { q }); const shelves = (res && res.shelves) || []; let first = null; for (const sh of shelves) { first = (sh.items || []).find(it => it.vid); if (first) break; } if (!first && res && res.top && res.top.vid) first = res.top; if (!first) return null; const s = put(first); start([s.id], { k: 'search', label: 'Pesquisa · ' + q }, s.id); return s; }

  /* ---------- compatibilidade: window.Player (ilha, Centro de Controlo, widgets, Vera) ---------- */
  const legacy = () => { const s = MU.now ? song(MU.now) : null; if (!s) return null; const c = colorsOf(s.grad); return { id: s.id, title: s.t, artist: s.a || (window.System && System.os === 'android' ? '' : '--'), album: s.alb || '', c, dur: MU.dur || s.len || 0, img: s.img }; };
  window.Player = { cur: legacy, get playing() { return MU.playing; }, get pos() { return MU.elapsed; }, toggle: pauseResume, next: () => advance(1, false), prev, seek: f => seekTo(f * (MU.dur || (song(MU.now) || {}).len || 0)), get shuffle() { return MU.shuffle; }, set shuffle(v) { MU.shuffle = !!v; }, play: (list, i) => { const ids = (list || []).map(x => typeof x === 'string' ? x : (x && x.id)).filter(id => id && MU.songs.has(id)); if (ids.length) start(ids, MU.ctx, ids[i || 0]); }, set onChange(f) { if (typeof f === 'function') MU.listeners.add(f); } };
  Bridge.on('state', p => { if (p && p.volume != null) { MU.vol = +p.volume || 0; applyVol(); } });
  /* ---------- AirBuds (2026-09-16) ----------
     O áudio é da NUI: toca SEMPRE só para ti. O que os AirBuds decidem é se a música sobrevive ao FECHAR do telemóvel:
     · AirBuds postos (item) E ligados (Bluetooth) → continua a tocar com o telemóvel fechado;
     · sem eles → fechar o telemóvel pausa (e voltar a abrir retoma onde ficou);
     · tirar/desligar os AirBuds com o telemóvel fechado pausa, como no PearPhone quando os tiras dos ouvidos.
     Config.AirPods.pauseWithoutAirpods = false desliga a regra (a música toca sempre). Não se aplica ao CarLink (rádio do carro). */
  const onAirpods = () => !!(System.state.earbuds && System.state.airpodsWorn);
  const phoneClosed = () => Bridge.inFiveM && document.body.classList.contains('hidden');
  const pauseRule = () => { const c = System.config && System.config.airpods; return !c || c.pauseWithoutAirpods !== false; };
  let pausedByClose = false;
  const pauseNow = why => { if (!MU.playing || MU.car || !MU.now) return; pausedByClose = true; MU.status = why || ''; pauseResume(); };
  Bridge.on('close', () => { if (pauseRule() && !onAirpods()) pauseNow(''); });
  Bridge.on('open', () => { if (pausedByClose) { pausedByClose = false; if (MU.now && !MU.playing) pauseResume(); } });
  Bridge.on('state', p => { if (!p || !pauseRule()) return; if ((p.earbuds === false || p.airpodsWorn === false) && phoneClosed()) pauseNow(''); });
  Bridge.on('app:kill', id => { if (id === 'music') stop(); });
  /* troca de personagem: pára, NÃO grava a biblioteca da anterior no espaço da nova e volta a carregar do servidor ao abrir */
  Bridge.on('session:changed', () => { clearTimeout(MU.saveT); MU.saveT = null; try { stop(); } catch (e) {} MU.likes = []; MU.lib = []; MU.recents = []; MU.queue = []; MU.playlists = []; MU.likeRev++; MU.seeded = false; MU.loaded = false; MU.home = null; MU.homeState = 'idle'; MU.results = null; emit(); });

  /* ---------- fallback no browser (sem servidor): dados de demonstração ---------- */
  if (window.LocalDB && LocalDB.register) {
    const DEMO = [['dQw4w9WgXcQ', 'Never Gonna Give You Up', 'Rick Astley', 'Whenever You Need Somebody', 213], ['kJQP7kiw5Fk', 'Despacito', 'Luis Fonsi', 'Vida', 282], ['9bZkp7q19f0', 'Gangnam Style', 'PSY', 'Psy 6 (Six Rules), Part 1', 253], ['JGwWNGJdvx8', 'Shape of You', 'Ed Sheeran', '÷ (Deluxe)', 234], ['RgKAFK5djSk', 'See You Again', 'Wiz Khalifa', 'Furious 7', 230], ['OPf0YbXqDm0', 'Uptown Funk', 'Mark Ronson', 'Uptown Special', 270]];
    const tr = ([vid, t, a, alb, len]) => ({ id: 'yt:' + vid, vid, t, a, alb, len, img: `https://i.ytimg.com/vi/${vid}/mqdefault.jpg` });
    const tracks = DEMO.map(tr);
    LocalDB.register('music.status', () => ({ ok: true, provider: 'demo', search: true, carplay: false, car: false, cfg: { mode: 'auto', piped: [], invidious: [], quality: 'small', persist: false } }));
    LocalDB.register('music.alt', () => ({ alts: [] }));
    LocalDB.register('music.home', () => ({ shelves: [{ title: 'Escolhas rápidas', kind: 'track', items: tracks }, { title: 'Álbuns em destaque', kind: 'card', items: tracks.slice(0, 4).map(x => ({ kind: 'album', id: 'MPRE' + x.vid, t: x.alb, a: x.a, img: x.img })) }] }));
    LocalDB.register('music.search', d => { const lv = linkVid(d.q); if (lv === '') return { q: d.q, shelves: [], error: 'badlink' }; if (lv) { const t = tracks.find(x => x.vid === lv) || tr([lv, 'youtu.be/' + lv, '', '', 0]); return { q: d.q, link: lv, top: t, shelves: [{ title: 'Músicas', kind: 'track', items: [t] }] }; } const q = String(d.q || '').toLowerCase(); const hit = tracks.filter(x => (x.t + ' ' + x.a + ' ' + x.alb).toLowerCase().includes(q)); return { q, top: hit[0] || null, shelves: hit.length ? [{ title: 'Músicas', kind: 'track', items: hit }] : [] }; });
    LocalDB.register('music.suggest', d => tracks.map(x => x.t).filter(t => t.toLowerCase().includes(String(d.q || '').toLowerCase())).slice(0, 5));
    LocalDB.register('music.browse', d => ({ id: d.id, kind: d.kind, t: 'Álbum de demonstração', a: 'Vários artistas', img: tracks[0].img, tracks }));
    LocalDB.register('music.radio', () => tracks.slice().reverse());
    LocalDB.register('music.lyrics', () => ({ text: 'Letra de demonstração\n\nEsta é uma letra de exemplo,\nmostrada apenas no browser.', source: 'Demo' }));
    LocalDB.register('music.load', () => { try { return JSON.parse(localStorage.getItem('apexphone:music:server') || 'null'); } catch (e) { return null; } });
    LocalDB.register('music.save', d => { try { localStorage.setItem('apexphone:music:server', JSON.stringify(d)); } catch (e) {} return { ok: true }; });
  }

  /* ============================================================ UI - o MESMO design da app Música do apex_carplay (".vm"), em retrato ============================================================
     Pedido do utilizador: "a app da música tem de ficar igual à do CarLink". É o skeleton #s-music do CarLink (html/index.html) com o
     CSS .vm-* (html/style.css) adaptado a 440×956: rail horizontal (Início · Pesquisar · As tuas músicas · Gostos · Histórico · Carro
     + playlists), campo de pesquisa ESTÁTICO com sugestões do YouTube, corpo com cabeçalhos/cartões/linhas, barra de reprodução sempre
     visível em baixo e player de ecrã inteiro por cima (Seguintes / Letra). Menus ⋮ e diálogos são os do CarLink (.vm-menu / .vm-dlg).
     Desempenho (CEF): zero backdrop-filter e zero filter em camadas grandes - a capa desfocada que tinge a app é pré-renderizada em
     canvas e cacheada; o corpo só é reconstruído quando muda algo estrutural (assinatura), a barra/progresso pintam-se a cada tick. */
  const NAV = [['home', 'home', 'Início'], ['search', 'search', 'Pesquisar'], ['lib', 'music', 'Músicas'], ['liked', 'heart', 'Gostos'], ['recent', 'clock', 'Histórico'], ['car', 'car', 'Carro']];   /* "As tuas músicas" não cabia com os 6 destinos em 440 px */
  const FILTERS = [['all', 'Tudo'], ['songs', 'Músicas'], ['albums', 'Álbuns'], ['playlists', 'Playlists'], ['artists', 'Artistas']];
  const KIND = { album: 'Álbum', artist: 'Artista', playlist: 'Playlist', song: 'Música' };
  const V = { win: null, root: null, view: 'home', prev: 'home', openPl: null, page: null, filter: 'all', full: false, fullTab: 'next', sugg: [], suggT: null, seeking: false, volDrag: false, lastVol: 60, sig: '', bgKey: '', barH: 0, inCar: false, carT: 0 };
  /* NOVA UI (Android, V.android): o mesmo motor, a mesma biblioteca e as mesmas vistas (Início, Pesquisa, Músicas, Gostos,
     Histórico, playlists, páginas, Carro); o desenho é o de uma app de música da Nova UI (separadores em pílula, linhas em cartão,
     mini-leitor em pílula em baixo, leitor em ecrã inteiro com a capa r26). As peças (head, row, card…) escolhem o desenho; os
     seletores partilhados (pesquisa, corpo, sugestões, fundo, painel do leitor) passam por AL; C() troca vm- por amus- nas classes. */
  const AL = { '.vm-search input': '.amus-search input', '.vm-qx': '.amus-qx', '.vm-body': '.amus-body', '.vm-topback': '.amus-back', '.vm-sugg': '.amus-sugg', '.vm-bg': '.amus-bg', '.vm-fullbg': '.amus-fullbg', '.vm-fullpane': '.amus-pbody', '.vm-fulltabs': '.amus-ptabs', '.vm-full': '.amus-full' };
  const $v = sel => (V.root ? V.root.querySelector(V.android && AL[sel] ? AL[sel] : sel) : null);
  const C = cls => (V.android ? String(cls).replace(/\bvm-/g, 'amus-') : cls);
  /* no Android as classes vm- do elemento e das classes dentro do html passam a amus- (o texto do utilizador vem sempre escapado) */
  const mk = (tag, cls, html) => { const e = document.createElement(tag); if (cls) e.className = C(cls); if (html != null) e.innerHTML = V.android ? String(html).replace(/class="([^"]*)"/g, (m, k) => 'class="' + C(k) + '"') : html; return e; };
  const fmtLen = s => (!s || s <= 0) ? '' : UI.fmtDur(s);
  const total = ids => { let n = 0; ids.forEach(id => { const s = song(id); if (s) n += s.len || 0; }); if (!n) return ''; const h = Math.floor(n / 3600), m = Math.round((n % 3600) / 60); return h ? `${h} h ${m} min` : `${m} min`; };
  const greeting = () => { const h = new Date().getHours(); return h < 5 ? 'Ainda por aí' : h < 12 ? 'Bom dia' : h < 18 ? 'Boa tarde' : 'Boa noite'; };
  function plMove(plId, i, dir) { const p = pl(plId); if (!p) return; const j = i + dir; if (j < 0 || j >= p.tracks.length) return; const t = p.tracks[i]; p.tracks[i] = p.tracks[j]; p.tracks[j] = t; saveSoon(); emit(); }
  function queueClear() { MU.queue = []; saveSoon(); UI.toast('Fila limpa'); emit(); }
  const shuffleStart = (ids, ctx) => { MU.shuffle = true; start(ids, ctx); };

  /* ---------- a capa desfocada que tinge a app (canvas pré-renderizado + cache; NUNCA filter:blur no elemento) ---------- */
  const BG = { cache: {}, pending: {} };
  function blurArt(s, cb) {
    const key = s ? (s.img || s.grad) : ''; if (!key) { cb(''); return; }
    if (BG.cache[key]) { cb(BG.cache[key]); return; }
    const c2 = colorsOf(s.grad); const fb = `linear-gradient(160deg,${c2[0]},${c2[1]})`;
    if (!s.img) { BG.cache[key] = fb; cb(fb); return; }
    cb(fb);                                                            /* enquanto a imagem carrega: gradiente da faixa */
    if (BG.pending[key]) return; BG.pending[key] = true;
    const img = new Image(); img.crossOrigin = 'anonymous';
    img.onload = () => {
      try { const W = 110, H = 240, c = document.createElement('canvas'); c.width = W; c.height = H; const x = c.getContext('2d'); x.fillStyle = '#1c1c1e'; x.fillRect(0, 0, W, H); x.filter = 'blur(14px) saturate(170%)';
        const r = Math.max((W + 40) / img.naturalWidth, (H + 40) / img.naturalHeight), w = img.naturalWidth * r, h = img.naturalHeight * r; x.drawImage(img, (W - w) / 2, (H - h) / 2, w, h);
        BG.cache[key] = `url("${c.toDataURL('image/jpeg', .8)}") center/cover no-repeat`; } catch (e) { BG.cache[key] = fb; }
      delete BG.pending[key]; emit(); };
    img.onerror = () => { BG.cache[key] = fb; delete BG.pending[key]; };
    img.src = s.img;
  }
  function paintBg() {
    const bg = $v('.vm-bg'); if (!bg) return; const fbg = $v('.vm-fullbg'); const s = MU.now ? song(MU.now) : null;
    if (!s) { if (V.bgKey !== '') { V.bgKey = ''; bg.style.background = ''; bg.style.opacity = '0'; if (fbg) fbg.style.background = ''; } return; }
    blurArt(s, css => { const k = (s.img || s.grad) + '|' + css.length; if (V.bgKey === k) return; V.bgKey = k; bg.style.background = css; bg.style.opacity = ''; if (fbg) fbg.style.background = css; });
  }

  /* ---------- peças reutilizáveis (muHead / muCards / muList / muRow / muCard / muEmpty / muLoading / muNote do CarLink) ---------- */
  function head(body, title, sub, extra) { const h = mk('div', 'vm-head'); h.appendChild(mk('span', 'vm-headtitle', esc(title))); if (sub) h.appendChild(mk('span', 'vm-headsub', esc(sub))); h.appendChild(mk('span', 'vm-headspring')); if (extra) h.appendChild(extra); body.appendChild(h); return h; }
  const cards = body => { const w = mk('div', 'vm-cards'); body.appendChild(w); return w; };
  const list = body => { const w = mk('div', 'vm-list'); body.appendChild(w); return w; };
  function row(id, opts = {}) {
    const s = song(id); if (!s) return null; const isNow = MU.now === id;
    const r = mk('button', 'vm-row' + (isNow ? ' on' : '') + (opts.move ? ' movable' : '') + (s.vid && DEAD.has(s.pv || s.vid) ? ' dead' : '')); r.dataset.sid = id;   /* permite marcar a faixa a tocar sem reconstruir a lista (paintBar); dead = o YouTube recusou-a nesta sessão (esbatida) */
    const idx = mk('span', 'vm-rowidx'); idx.dataset.idx = opts.idx != null ? String(opts.idx) : ''; if (isNow) idx.innerHTML = `<span class="${C('vm-eq')}${MU.playing ? '' : ' paused'}"><i></i><i></i><i></i></span>`; else idx.textContent = idx.dataset.idx; r.appendChild(idx);
    const art = mk('span', 'vm-rowart'); art.style.background = songArt(s); r.appendChild(art);
    r.appendChild(mk('span', 'vm-rowmid', `<span class="vm-rowtitle">${esc(s.t)}</span><span class="vm-rowsub">${esc([s.a, s.alb].filter(Boolean).join(' · ') || (V.android ? 'Artista desconhecido' : '--'))}</span>`));
    r.appendChild(mk('span', 'vm-rowlen', fmtLen(s.len)));
    const btns = mk('span', 'vm-rowbtns');
    if (!opts.move) { const like = mk('button', 'vm-rowbtn vm-rowlike' + (liked(id) ? ' lit' : ''), g('heart', 21));   /* vm-rowlike: o paintBar acende/apaga este coração sem reconstruir a lista */ like.onclick = e => { e.stopPropagation(); toggleLike(id); }; btns.appendChild(like); }
    else { const up = mk('button', 'vm-rowbtn', g('chevU', 20)); up.onclick = e => { e.stopPropagation(); opts.move(-1); }; const dn = mk('button', 'vm-rowbtn', g('chevD', 20)); dn.onclick = e => { e.stopPropagation(); opts.move(1); }; btns.appendChild(up); btns.appendChild(dn); }
    const dots = mk('button', 'vm-rowbtn', g('moreV', 21)); dots.onclick = e => { e.stopPropagation(); menu(id, dots, opts); }; btns.appendChild(dots);
    r.appendChild(btns);
    r.onclick = () => { if (opts.onPlay) opts.onPlay(); else start([id], opts.ctx || MU.ctx, id); };
    UI.longPress(r, () => menu(id, dots, opts));
    return r;
  }
  function card(item) {
    const isTrack = !!item.vid; const c = mk('button', 'vm-card' + (item.kind === 'artist' ? ' round' : ''));
    const art = mk('span', 'vm-cardart'); art.style.background = artCss(item.img, hashArt(item.id || item.t));
    const act = () => { if (isTrack) { const s = put(item); if (s) start([s.id], { k: 'yt', label: 'TubeMusic' }, s.id); } else openPage(item.kind, item.id, item.t, item.img); };
    const play = mk('button', 'vm-cardplay', g('play', 20)); play.onclick = e => { e.stopPropagation(); act(); }; art.appendChild(play); c.appendChild(art);
    c.appendChild(mk('span', 'vm-cardtitle', esc(item.t))); c.appendChild(mk('span', 'vm-cardsub', esc(item.a || KIND[item.kind] || '')));
    c.onclick = act; if (isTrack) UI.longPress(c, () => { const s = put(item); if (s) menu(s.id, c, {}); });
    return c;
  }
  function empty(body, icon, title, text, action) { const w = mk('div', 'vm-empty'); w.appendChild(mk('span', 'vm-emptyic', g(icon, 24))); w.appendChild(mk('span', 'vm-emptytitle', esc(title))); if (text) w.appendChild(mk('span', 'vm-emptytext', esc(text))); if (action) w.appendChild(action); body.appendChild(w); }
  function loading(body, text) { body.appendChild(mk('div', 'vm-ld', `<div class="spinner"></div><span>${esc(text || 'A carregar…')}</span>`)); }
  function note(body) { if (!MU.status) return; body.appendChild(mk('div', 'vm-note', g('info', 20) + '<span>' + esc(MU.status) + '</span>')); }
  function btn(label, icon, cls, fn) { const b = mk('button', 'vm-btn' + (cls ? ' ' + cls : ''), (icon ? g(icon, 15) : '') + (label ? '<span>' + esc(label) + '</span>' : '')); b.onclick = fn; return b; }
  const playBtn = (label, fn) => btn(label, 'play', 'play', fn);
  const ghost = (label, icon, fn) => btn(label, icon, 'ghost', fn);
  function pageHead(body, o) {
    const h = mk('div', 'vm-phead'); const art = mk('div', 'vm-pheadart'); art.style.background = o.art; if (o.icon) art.innerHTML = g(o.icon, 44); h.appendChild(art);
    const meta = mk('div', 'vm-pheadmeta'); meta.appendChild(mk('span', 'vm-pkind', esc(o.kind))); meta.appendChild(mk('span', 'vm-ptitle' + (String(o.title).length > 22 ? ' long' : ''), esc(o.title))); if (o.note) meta.appendChild(mk('span', 'vm-pnote', esc(o.note))); if (o.stats) meta.appendChild(mk('span', 'vm-pstats', esc(o.stats))); h.appendChild(meta);
    const btns = mk('div', 'vm-pbtns'); (o.buttons || []).filter(Boolean).forEach(b => btns.appendChild(b)); h.appendChild(btns); body.appendChild(h);
  }

  /* ---------- vistas (muViewHome / Search / Lib / Liked / Recent / Pl / Page do CarLink + "Carro") ---------- */
  function viewHome(body) {
    const quick = MU.recents.slice(0, 8);
    /* "Ouvir agora", como na Música do iOS (a saudação pela hora era do TubeMusic; o `greeting` fica para o rádio do carro) */
    head(body, 'Ouvir agora', quick.length ? 'Continua onde ficaste' : 'Pesquisa uma música, um álbum ou um artista');
    if (quick.length) { const w = cards(body); quick.forEach(id => { const s = song(id); if (s) w.appendChild(card({ id: s.id, t: s.t, a: s.a, img: s.img, vid: s.vid })); }); }
    else { const b = btn('Pesquisar no TubeMusic', 'search', '', () => { go('search'); focusQ(); }); empty(body, 'music', 'Ainda não ouviste nada', V.android ? 'Pesquisa uma música, um álbum ou um artista: toca aqui ou no rádio do carro.' : 'Pesquisa uma música, um álbum ou um artista: toca aqui ou no rádio do carro.', b); }
    if (MU.playlists.length) {
      head(body, 'As tuas playlists', plural(MU.playlists.length, 'playlist')); const w = cards(body);
      MU.playlists.slice(0, 12).forEach(p => { const c = mk('button', 'vm-card'); const art = mk('span', 'vm-cardart'); art.style.background = plArt(p); const play = mk('button', 'vm-cardplay', g('play', 20)); play.onclick = e => { e.stopPropagation(); MU.shuffle = false; start(p.tracks, { k: 'pl', label: p.name, id: p.id }); }; art.appendChild(play); c.appendChild(art); c.appendChild(mk('span', 'vm-cardtitle', esc(p.name))); c.appendChild(mk('span', 'vm-cardsub', plural(p.tracks.length, 'música'))); c.onclick = () => openPl(p.id); UI.longPress(c, () => plMenu(p.id, c)); w.appendChild(c); });
    }
    if (MU.homeState === 'loading' && !MU.home) { head(body, 'Do TubeMusic'); loading(body, 'A ver o que está popular agora…'); }
    else if (MU.home && MU.home.length) MU.home.forEach(sh => { if (!sh.items.length) return; head(body, sh.title); const w = cards(body); sh.items.slice(0, 12).forEach(it => w.appendChild(card(it))); });
    else if (MU.homeState === 'failed') empty(body, 'music', 'Sem sugestões', MU.homeErr ? srvErr(MU.homeErr) : 'O TubeMusic não respondeu. Pesquisa algo em cima.');
  }
  function viewSearch(body) {
    if (MU.searching && !MU.results) { loading(body, 'A pesquisar no TubeMusic…'); return; }
    if (!MU.results) { empty(body, 'search', 'Pesquisar no TubeMusic', openSearch() ? 'Escreve uma música ou um artista, ou cola um link do YouTube.' : 'Músicas e artistas. Tudo toca aqui ou no rádio do carro para quem estiver por perto.'); return; }
    if (MU.searching) body.appendChild(mk('div', 'vm-ld slim', `<div class="spinner"></div><span>A pesquisar “${esc(searchQ)}”…</span>`));   /* ao vivo: os resultados anteriores ficam por baixo até chegar a resposta */
    const R = MU.results; const groups = {}; R.shelves.forEach(sh => { groups[sh.group] = true; });
    /* link de canal/playlist: não há nada a tocar, o estado vazio (ao centro) já diz porquê - sem nota repetida por cima */
    if (R.error === 'badlink' && !R.shelves.length) { empty(body, 'search', 'Nada por aqui', srvErr('badlink')); return; }
    if (R.error) body.appendChild(mk('div', 'vm-note bad', g('info', 20) + '<span>' + esc(srvErr(R.error)) + '</span>'));   /* o servidor disse porquê (CarLink parado / versão antiga / timeout / YouTube a travar); com a pesquisa aberta, por baixo vem o que o catálogo do servidor tiver */
    const chips = mk('div', 'vm-chips'); FILTERS.forEach(([id, label]) => { if (id !== 'all' && !groups[id]) return; const c = mk('button', 'vm-chip' + (V.filter === id ? ' on' : ''), esc(label)); c.onclick = () => { V.filter = id; repaint(true); }; chips.appendChild(c); }); body.appendChild(chips);
    const shown = R.shelves.filter(sh => V.filter === 'all' || sh.group === V.filter);
    if (R.top && V.filter === 'all') { head(body, 'Melhor resultado'); cards(body).appendChild(card(R.top)); }
    if (!shown.length) { if (R.error) empty(body, 'search', 'Sem resposta', V.android ? 'A pesquisa não chegou ao TubeMusic: vê a nota em cima.' : 'A pesquisa não chegou ao TubeMusic: vê a nota em cima.'); else empty(body, 'search', 'Nada por aqui', `O YouTube não encontrou nada para “${R.q}”.`); return; }
    shown.forEach(sh => {
      head(body, sh.title);
      if (sh.group === 'songs') { const l = list(body); const ctx = { k: 'search', label: 'Pesquisa · ' + R.q, id: null }; const ids = sh.items.filter(i => i.vid).map(i => { const s = put(i); return s && s.id; }).filter(Boolean); ids.forEach((id, i) => { const r = row(id, { idx: i + 1, ctx, onPlay: () => start(ids, ctx, id) }); if (r) l.appendChild(r); }); }
      else { const w = cards(body); sh.items.forEach(it => w.appendChild(card(it))); }
    });
  }
  function simpleList(body, ids, ctx, opts = {}) { const l = list(body); ids.forEach((id, i) => { const r = row(id, { idx: i + 1, ctx, onPlay: () => start(ids, ctx, id), remove: opts.remove ? () => opts.remove(id, i) : null, removeLabel: opts.removeLabel }); if (r) l.appendChild(r); }); }
  function viewLib(body) {
    const ids = MU.lib; const ctx = { k: 'lib', label: 'As tuas músicas', id: null };
    pageHead(body, { kind: 'Biblioteca', title: 'As tuas músicas', art: ids.length ? songArt(song(ids[0])) : ARTS[1], icon: ids.length ? null : 'music', stats: ids.length ? plural(ids.length, 'música') + (total(ids) ? ' · ' + total(ids) : '') : 'Vazio', buttons: ids.length ? [playBtn('Reproduzir', () => { MU.shuffle = false; start(ids, ctx); }), ghost('Aleatório', 'shuffle', () => shuffleStart(ids, ctx))] : [] });
    if (!ids.length) { empty(body, 'music', 'Ainda sem músicas guardadas', 'Tudo o que encontrares pode ser guardado aqui pelo menu ⋮ de uma faixa.'); return; }
    simpleList(body, ids, ctx, { remove: id => libRemove(id), removeLabel: 'Remover das tuas músicas' });
  }
  function viewLiked(body) {
    const ids = MU.likes; const ctx = { k: 'liked', label: 'Gostos', id: null };
    pageHead(body, { kind: 'Playlist', title: 'Gostos', art: ids.length ? songArt(song(ids[0])) : ARTS[0], icon: ids.length ? null : 'heart', stats: ids.length ? plural(ids.length, 'música') + (total(ids) ? ' · ' + total(ids) : '') : 'Ainda sem gostos', buttons: ids.length ? [playBtn('Reproduzir', () => { MU.shuffle = false; start(ids, ctx); }), ghost('Aleatório', 'shuffle', () => shuffleStart(ids, ctx))] : [] });
    if (!ids.length) { empty(body, 'heart', 'Ainda sem gostos', 'Toca no coração de qualquer faixa e ela aparece aqui.'); return; }
    simpleList(body, ids, ctx, { remove: id => toggleLike(id), removeLabel: 'Remover dos gostos' });
  }
  function viewRecent(body) {
    const ids = MU.recents; const ctx = { k: 'recent', label: 'Histórico', id: null };
    head(body, 'Histórico', ids.length ? plural(ids.length, 'faixa') : '', ids.length ? btn('Limpar', 'trash', 'ghost sm', () => { MU.recents = []; saveSoon(); emit(); }) : null);
    if (!ids.length) { empty(body, 'clock', 'Ainda não ouviste nada', 'Tudo o que tocares aparece aqui.'); return; }
    simpleList(body, ids, ctx, { remove: (id, i) => { MU.recents.splice(i, 1); saveSoon(); emit(); }, removeLabel: 'Remover do histórico' });
  }
  function viewPl(body) {
    const p = pl(V.openPl); if (!p) { go('home'); return; } const ctx = { k: 'pl', label: p.name, id: p.id };
    pageHead(body, { kind: 'Playlist', title: p.name, note: p.note, art: plArt(p), icon: plCover(p) ? null : 'music', stats: plural(p.tracks.length, 'música') + (total(p.tracks) ? ' · ' + total(p.tracks) : ''),
      buttons: [p.tracks.length ? playBtn('Reproduzir', () => { MU.shuffle = false; start(p.tracks, ctx); }) : null, p.tracks.length ? ghost('Aleatório', 'shuffle', () => shuffleStart(p.tracks, ctx)) : null, ghost('Editar', 'pen', () => plDialog(p.id)), ghost('Apagar', 'trash', () => confirmDlg(`Apagar “${p.name}”?`, 'As músicas ficam na biblioteca. Só a playlist desaparece.', () => { plDelete(p.id); go('home'); }))] });
    if (!p.tracks.length) { const b = btn('Encontrar algo', 'search', '', () => { go('search'); focusQ(); }); empty(body, 'plus', 'Esta playlist está vazia', 'Pesquisa uma faixa e usa o menu ⋮ → Adicionar a playlist.', b); return; }
    const l = list(body); p.tracks.forEach((id, i) => { const r = row(id, { idx: i + 1, ctx, onPlay: () => start(p.tracks, ctx, id), move: dir => plMove(p.id, i, dir), remove: () => plRemoveAt(p.id, i), removeLabel: 'Remover desta playlist' }); if (r) l.appendChild(r); });
  }
  function viewPage(body) {
    const pg = V.page; if (!pg) { go('home'); return; } const ctx = { k: 'page', label: pg.t, id: pg.id };
    pageHead(body, { kind: KIND[pg.kind] || 'Playlist', title: pg.t, note: pg.a, art: artCss(pg.img, hashArt(pg.id)), icon: pg.img ? null : 'music', stats: pg.tracks.length ? plural(pg.tracks.length, 'música') + (total(pg.tracks) ? ' · ' + total(pg.tracks) : '') : (pg.loading ? 'A carregar…' : ''),
      buttons: pg.tracks.length ? [playBtn('Reproduzir', () => { MU.shuffle = false; start(pg.tracks, ctx); }), ghost('Aleatório', 'shuffle', () => shuffleStart(pg.tracks, ctx)), ghost('Guardar como playlist', 'bookmark', () => { const p = plNew(pg.t, pg.kind === 'album' ? 'Álbum · ' + (pg.a || '') : 'Guardado do TubeMusic'); plAddMany(p.id, pg.tracks); })] : [] });
    if (pg.loading) { loading(body, 'A abrir no TubeMusic…'); return; }
    if (!pg.tracks.length) { empty(body, 'music', pg.err ? 'Não foi possível abrir' : 'Nada para tocar aqui', pg.err || 'O YouTube não listou faixas para este item.'); return; }
    const l = list(body); pg.tracks.forEach((id, i) => { const r = row(id, { idx: i + 1, ctx, onPlay: () => start(pg.tracks, ctx, id) }); if (r) l.appendChild(r); });
  }
  /* Listas (só no desenho Nova UI, que não tem a barra lateral do CarLink): as playlists em lista, com Nova playlist */
  function viewPls(body) {
    head(body, 'Listas de reprodução', MU.playlists.length ? plural(MU.playlists.length, 'playlist') : '', btn('Nova', 'plus', 'ghost sm', () => plDialog(null, null)));
    if (!MU.playlists.length) { empty(body, 'music', 'Ainda sem listas', 'Cria uma lista e junta-lhe músicas pelo menu de uma faixa.', btn('Nova playlist', 'plus', 'play', () => plDialog(null, null))); return; }
    const l = list(body);
    MU.playlists.forEach(p => { const r = mk('button', 'vm-plrow'); const art = mk('span', 'vm-plart'); art.style.background = plArt(p); if (!plCover(p)) art.innerHTML = g('music', 20); r.appendChild(art);
      r.appendChild(mk('span', 'vm-plmeta', `<span class="vm-plname">${esc(p.name)}</span><span class="vm-plcount">${plural(p.tracks.length, 'música')}${total(p.tracks) ? ' · ' + total(p.tracks) : ''}</span>`));
      const dots = mk('button', 'vm-rowbtn', g('moreV', 21)); dots.onclick = e => { e.stopPropagation(); plMenu(p.id, dots); }; r.appendChild(dots);
      r.onclick = () => openPl(p.id); UI.longPress(r, () => plMenu(p.id, dots)); l.appendChild(r); });
  }
  function viewCar(body) {
    head(body, 'Carro', 'Onde o som sai');
    if (!MU.carplay) { body.appendChild(mk('div', 'vm-note bad', g('info', 20) + '<span>' + (V.android ? 'O CarLink (apex_carradio) não está disponível neste servidor: a música toca só no telemóvel.' : 'O CarLink (apex_carradio) não está disponível neste servidor: a música toca só no telemóvel.') + '</span>')); return; }
    body.appendChild(mk('div', 'vm-note' + (V.inCar ? ' ok' : ''), g('car', 20) + '<span>' + (V.inCar ? 'Estás num veículo: entrega a faixa ao rádio do carro e todos os ocupantes ouvem-na.' : 'Entra num veículo com CarLink para tocar no rádio do carro. Até lá, toca no telemóvel.') + '</span>'));
    const w = mk('div', 'vm-dest');
    const ph = mk('button', 'vm-destbtn' + (!MU.car ? ' on' : ''), g('phone', 24) + '<b>Telemóvel</b><span>Toca aqui, só para ti.</span>'); ph.onclick = () => { if (MU.car) toCar(false); };
    const car = mk('button', 'vm-destbtn' + (MU.car ? ' on' : ''), g('car', 24) + (V.android ? '<b>Carro</b><span>Rádio partilhado do CarLink: todos no carro ouvem.</span>' : '<b>Carro</b><span>Rádio partilhado do CarLink: todos no carro ouvem.</span>')); if (!V.inCar && !MU.car) car.disabled = true; car.onclick = () => { if (!MU.car) toCar(true); };
    w.appendChild(ph); w.appendChild(car); body.appendChild(w); refreshCar();
  }
  function refreshCar() { if (!MU.carplay || Date.now() - V.carT < 4000) return; V.carT = Date.now(); Promise.resolve(Bridge.call('musicCarState')).then(st => { const inCar = !!(st && st.inCar); if (inCar !== V.inCar) { V.inCar = inCar; emit(); } }).catch(() => {}); }

  /* ---------- corpo / navegação (muRenderBody / muGo / muOpenPl / muOpenPage) ---------- */
  function renderBody() {
    /* PERFUI: ler scrollTop obriga a um layout sincrono; com o corpo ainda vazio (a vista acabada de nascer) o valor e sempre 0 */
    const body = $v('.vm-body'); if (!body) return; const keep = body.firstChild ? body.scrollTop : 0; body.innerHTML = '';
    const back = $v('.vm-topback'); if (back) back.hidden = !(V.view === 'pl' || V.view === 'page');
    const q = $v('.vm-search input'); if (q) $v('.vm-qx').classList.toggle('on', !!q.value);
    if (!MU.ok) { empty(body, 'music', 'Música indisponível', 'Requer o apex_carradio a correr no servidor (Config.Music.Provider).'); return; }
    note(body);
    const VIEWS = { home: viewHome, search: viewSearch, lib: viewLib, liked: viewLiked, recent: viewRecent, car: viewCar, pl: viewPl, page: viewPage, pls: viewPls };
    (VIEWS[V.view] || viewHome)(body); if (keep) body.scrollTop = keep;
  }
  function go(v) { if (V.view !== v && V.view !== 'pl' && V.view !== 'page') V.prev = V.view; V.view = v; if (v !== 'pl') V.openPl = null; if (v !== 'page') V.page = null; hideSugg(); const b = $v('.vm-body'); if (b) b.scrollTop = 0; repaint(true); }
  function openPl(id) { if (V.view !== 'pl' && V.view !== 'page') V.prev = V.view; V.view = 'pl'; V.openPl = id; V.page = null; const b = $v('.vm-body'); if (b) b.scrollTop = 0; repaint(true); }
  function goBack() { go(V.prev && V.prev !== 'pl' && V.prev !== 'page' ? V.prev : 'home'); }
  async function openPage(kind, id, title, img) {
    if (V.view !== 'pl' && V.view !== 'page') V.prev = V.view; V.view = 'page'; V.openPl = null; V.page = { kind, id, t: title || 'A carregar…', a: '', img: img || null, tracks: [], loading: true, err: null }; const b = $v('.vm-body'); if (b) b.scrollTop = 0; repaint(true);
    const res = await mx('mxBrowse', id, kind); if (!V.page || V.page.id !== id) return;
    if (bad(res)) { V.page.loading = false; V.page.t = title || 'Indisponível'; V.page.err = 'O YouTube não abriu este item.'; repaint(true); return; }
    const ids = (res.tracks || []).map(t => { const s = put(t); return s && s.id; }).filter(Boolean);
    V.page = { kind, id, t: res.t || title || 'Playlist', a: res.a || '', img: res.img || img || null, tracks: ids, loading: false, err: null }; repaint(true);
  }

  /* ---------- pesquisa: campo estático + sugestões (muSuggest / muRenderSugg / muSearch) ---------- */
  const focusQ = () => { const q = $v('.vm-search input'); if (q) setTimeout(() => q.focus(), 60); };
  function hideSugg() { const s = $v('.vm-sugg'); if (s) { s.classList.remove('on'); s.innerHTML = ''; } V.sugg = []; }
  function renderSugg() { const s = $v('.vm-sugg'); if (!s) return; s.innerHTML = ''; if (!V.sugg.length) { s.classList.remove('on'); return; } V.sugg.slice(0, 6).forEach(t => { const b = mk('button', 'vm-suggitem', g('search', 19) + '<span>' + esc(t) + '</span>'); b.onclick = () => doSearch(t); s.appendChild(b); }); s.classList.add('on'); }
  function suggest(q) { clearTimeout(V.suggT); if (V.suggMute) return; q = String(q || '').trim(); if (q.length < 2 || (openSearch() && linkVid(q) !== null)) { hideSugg(); return; } V.suggT = setTimeout(async () => { if (V.suggMute) return; const res = await mx('mxSuggest', q); const cur = $v('.vm-search input'); if (V.suggMute || !cur || cur.value.trim() !== q || document.activeElement !== cur || (MU.results && MU.results.q === q && !MU.searching)) return; V.sugg = Array.isArray(res) ? res.map(String) : []; renderSugg(); }, 200); }
  /* pesquisar: fecha as sugestões e impede que uma sugestão atrasada volte a abri-las por cima dos resultados */
  function doSearch(q) { V.suggMute = true; clearTimeout(V.suggT); clearTimeout(V.liveT); hideSugg(); q = String(q || '').trim(); const inp = $v('.vm-search input'); if (inp && inp.value !== q) inp.value = q; if (V.view !== 'search') go('search'); V.filter = 'all'; if (inp) inp.blur(); search(q); }
  /* pesquisa ao vivo (como o boombox): dispara sozinha ~400 ms depois de se parar de escrever (≥ 2 letras), sem tirar o foco do campo.
     As sugestões continuam a aparecer enquanto se escreve e fecham-se quando os resultados chegam (em search). Apagar tudo limpa os resultados. */
  /* com a pesquisa aberta cada pesquisa ao vivo é um pedido ao YouTube: espera-se um pouco mais (550 ms) antes de disparar; um link
     colado dispara logo (250 ms) e começa a tocar */
  function liveSearch(q) { clearTimeout(V.liveT); q = String(q || '').trim(); if (!q) { search(''); return; } if (q.length < 2) return; const wait = !openSearch() ? 400 : linkVid(q) !== null ? 250 : 550; V.liveT = setTimeout(() => { const cur = $v('.vm-search input'); if (!cur || cur.value.trim() !== q) return; if (V.view !== 'search') go('search'); if (!MU.results || MU.results.q !== q) V.filter = 'all'; search(q, true); }, wait); }

  /* ---------- barra de reprodução + progresso (muPaintBar / muPaintProgress) ---------- */
  /* isto corre a cada segundo enquanto toca: escrever o MESMO texto num nó substitui-lhe o filho e suja
     o layout - e o `bar.offsetHeight` do fim deste bloco pagava esse layout inteiro, 1×/s. Só se escreve o que mudou. */
  const setText = (el, t) => { if (el && el.textContent !== String(t)) el.textContent = t; };
  function paintBar() {
    const root = V.root; if (!root) return; const s = MU.now ? song(MU.now) : null;
    setText($v('.vm-btitle'), s ? s.t : 'Nada a tocar'); setText($v('.vm-bsub'), s ? (s.a || '--') : 'Escolhe algo para começar');
    const cover = s ? songArt(s) : NOART; if (V.lastCover !== cover) { V.lastCover = cover; $v('.vm-cover').style.background = cover; }
    /* corações das linhas pintados no sítio: tocar num coração (ou a lista de gostos mudar) já não reconstrói
       a lista inteira de Músicas/Histórico/Pesquisa - só a vista Gostos, que ganha ou perde linhas, se refaz */
    if (V.likeRev !== MU.likeRev) { V.likeRev = MU.likeRev; root.querySelectorAll('.vm-row .vm-rowlike').forEach(b => { const r = b.closest('.vm-row'); const on = !!(r && liked(r.dataset.sid)); if (on !== b.classList.contains('lit')) b.classList.toggle('lit', on); }); }
    /* os SVG só se reescrevem quando o estado muda (isto corre a cada segundo enquanto toca) */
    if (V.lastPlay !== MU.playing) { V.lastPlay = MU.playing; $v('.vm-play').innerHTML = g(MU.playing ? 'pause' : 'play', 20); const fp = $v('.vm-fullplay'); if (fp) fp.innerHTML = g(MU.playing ? 'pause' : 'play', 30); }
    const like = $v('.vm-like'); like.classList.toggle('on', !!(s && liked(s.id))); like.style.visibility = s ? 'visible' : 'hidden';
    /* marcar a linha da faixa a tocar sem reconstruir a lista (era o que a assinatura fazia antes) */
    if (V.lastNow !== MU.now) { V.lastNow = MU.now;
      root.querySelectorAll('.vm-row').forEach(r => { const on = r.dataset.sid === MU.now && !!MU.now; if (on === r.classList.contains('on')) return; r.classList.toggle('on', on);
        const ix = r.querySelector('.vm-rowidx'); if (!ix) return; if (on) ix.innerHTML = '<span class="vm-eq"><i></i><i></i><i></i></span>'; else ix.textContent = ix.dataset.idx || ''; }); }
    root.querySelectorAll('.vm-eq').forEach(e => e.classList.toggle('paused', !MU.playing));
    $v('.vm-shuf').classList.toggle('on', !!MU.shuffle); $v('.vm-rep').classList.toggle('on', MU.repeat !== 'off'); setText($v('.vm-ctx'), MU.ctx.label || 'Biblioteca');
    const vol = $v('.vm-vol input'); if (vol && !V.volDrag && +vol.value !== MU.vol) vol.value = MU.vol; setText($v('.vol-val'), MU.vol);
    const muted = MU.vol <= 0; if (V.lastMute !== muted) { V.lastMute = muted; $v('.vm-volbtn').innerHTML = g(muted ? 'volumeX' : 'speaker', 17); }
    const where = $v('.vm-where'); if (where) { const wc = 'vm-where' + (MU.car ? ' on' : ''); if (where.className !== wc) where.className = wc; setText(where.querySelector('.vm-wheretext'), MU.car ? 'Carro' : 'Telemóvel'); }
    /* PERFUI (2026-10-05): a altura da barra le-se no frame seguinte (antes de pintar), nao aqui: ler offsetHeight a meio do
       repaint obrigava a um layout sincrono de toda a vista acabada de construir (54 ms com o CPU a 1/4 ao abrir a Musica) e,
       a tocar, a um layout extra por segundo. O --vm-barh continua certo no primeiro frame pintado. */
    const bar = $v('.vm-bar'); if (bar && V.barEl !== bar) { cancelAnimationFrame(V.barRaf); V.barRaf = 0; }
    if (bar && !V.barRaf) { V.barEl = bar; V.barRaf = requestAnimationFrame(() => { V.barRaf = 0; if (!bar.isConnected) return; const h = bar.offsetHeight; if (h && h !== V.barH) { V.barH = h; (root.querySelector(':scope > .vm-full') || root).style.setProperty('--vm-barh', h + 'px'); } }); }   /* so o .vm-full le o --vm-barh: posta nele, a variavel nao obriga a refazer o estilo da vista toda */
  }
  function paintProgress() {
    if (!V.root || V.seeking) return; const s = MU.now ? song(MU.now) : null; const d = MU.dur || (s && s.len) || 0; const pct = d > 0 ? clamp(MU.elapsed / d * 100, 0, 100) : 0;
    $v('.vm-seekfill').style.width = pct + '%'; $v('.vm-seekdot').style.left = pct + '%'; setText($v('.vm-el'), UI.fmtDur(MU.elapsed || 0)); setText($v('.vm-len'), d > 0 ? UI.fmtDur(d) : '--:--');
  }

  /* ---------- rail (muRenderRail) ---------- */
  function renderRail() {
    const nav = $v('.vm-nav'); if (!nav) return; nav.innerHTML = '';
    NAV.forEach(([id, icon, label]) => { const b = mk('button', 'vm-navbtn' + (V.view === id ? ' on' : ''), g(icon, 17) + '<span>' + esc(label) + '</span>'); b.onclick = () => { go(id); if (id === 'search') focusQ(); }; nav.appendChild(b); });
    const wrap = $v('.vm-pls'); wrap.innerHTML = '';
    MU.playlists.forEach(p => { const b = mk('button', 'vm-plbtn' + (V.view === 'pl' && V.openPl === p.id ? ' on' : '')); const art = mk('span', 'vm-plart'); art.style.background = plArt(p); if (!plCover(p)) art.innerHTML = g('music', 18); b.appendChild(art); b.appendChild(mk('span', 'vm-plmeta', `<span class="vm-plname">${esc(p.name)}</span><span class="vm-plcount">${plural(p.tracks.length, 'música')}</span>`)); b.onclick = () => openPl(p.id); UI.longPress(b, () => plMenu(p.id, b)); wrap.appendChild(b); });
    const on = nav.querySelector('.on') || wrap.querySelector('.on'); if (on && on.scrollIntoView) sivSoon(on);
  }
  /* PERFUI (2026-10-05): o scrollIntoView logo a seguir a construir a vista obrigava o Chromium a fazer o layout de TUDO o que
     acabou de nascer, no meio do toque (58 ms com o CPU a 1/4 ao abrir a Musica). No frame seguinte, antes de pintar, o
     resultado e o mesmo e o layout e o que o frame ja ia fazer de qualquer maneira. */
  let sivRaf = 0;
  const sivSoon = el => { cancelAnimationFrame(sivRaf); sivRaf = requestAnimationFrame(() => { sivRaf = 0; if (!el.isConnected) return; try { el.scrollIntoView({ block: 'nearest', inline: 'nearest' }); } catch (e) {} }); };

  /* ---------- player de ecrã inteiro (muRenderFull / muRenderFullPane / muToggleFull) ---------- */
  function renderFull() {
    const full = $v('.vm-full'); if (!full) return; full.classList.toggle('on', !!V.full); if (!V.full) return; const s = MU.now ? song(MU.now) : null;
    $v('.vm-fullart').style.background = s ? songArt(s) : NOART; $v('.vm-fulltitle').textContent = s ? s.t : '--'; $v('.vm-fullartist').textContent = s ? (s.a || '--') : '--'; $v('.vm-fullfrom').textContent = MU.ctx.label || 'Biblioteca';
    const tabs = $v('.vm-fulltabs'); tabs.innerHTML = '';
    [['next', 'Seguintes'], ['lyrics', 'Letra']].forEach(([id, label]) => { const b = mk('button', 'vm-fulltab' + (V.fullTab === id ? ' on' : ''), esc(label)); b.onclick = () => { V.fullTab = id; if (id === 'lyrics' && s && s.vid) loadLyrics(s.vid); repaint(true); }; tabs.appendChild(b); });
    renderFullPane();
  }
  function renderFullPane() {
    const pane = $v('.vm-fullpane'); if (!pane || !V.full || (V.android && !V.pane)) return; pane.innerHTML = '';
    if (V.fullTab === 'lyrics') {
      const s = MU.now ? song(MU.now) : null;
      if (!s || !s.vid) { empty(pane, 'music', 'Sem letra', 'Só há letra para faixas do YouTube.'); return; }
      if (!MU.lyrics || MU.lyrics.vid !== s.vid) { setTimeout(() => loadLyrics(s.vid), 0); loading(pane, 'À procura da letra…'); return; }
      if (MU.lyrics.loading) { loading(pane, 'À procura da letra…'); return; }
      if (MU.lyrics.none) { empty(pane, 'music', 'Sem letra para esta', 'O YouTube não tem letra para esta faixa.'); return; }
      pane.appendChild(mk('div', 'vm-lyrics', esc(MU.lyrics.text))); if (MU.lyrics.source) pane.appendChild(mk('div', 'vm-lyricsrc', esc(MU.lyrics.source))); return;
    }
    const rows = []; MU.queue.forEach(id => rows.push({ id, queued: true })); MU.order.slice(MU.idx + 1, MU.idx + 41).forEach(id => rows.push({ id, queued: false }));
    if (!rows.length) { empty(pane, 'list', 'Nada a seguir', 'Quando a lista acabar, continua com uma rádio criada a partir da última faixa.'); return; }
    if (MU.queue.length) { const h = mk('div', 'vm-head'); h.appendChild(mk('span', 'vm-headtitle', 'Na fila')); h.appendChild(mk('span', 'vm-headspring')); h.appendChild(btn('Limpar', null, 'ghost sm', queueClear)); pane.appendChild(h); }
    const l = list(pane);
    rows.forEach((r, i) => { const e = row(r.id, { idx: i + 1, onPlay: () => { if (r.queued) { const at = MU.queue.indexOf(r.id); if (at >= 0) MU.queue.splice(at, 1); saveSoon(); } playId(r.id); }, remove: r.queued ? () => { const at = MU.queue.indexOf(r.id); if (at >= 0) { MU.queue.splice(at, 1); saveSoon(); emit(); } } : null, removeLabel: 'Remover da fila' }); if (e) l.appendChild(e); });
  }
  function toggleFull(on) { V.full = on == null ? !V.full : !!on; if (!V.full) V.pane = null; if (V.full) { const s = MU.now ? song(MU.now) : null; if (V.fullTab === 'lyrics' && s && s.vid) loadLyrics(s.vid); } repaint(true); }

  /* ---------- menu ⋮ e menu de playlist (muMenuAt / muMenu / muPlMenu) - absolutos dentro da app, escalam com o telemóvel ---------- */
  function closeMenu() { const m = V.root && V.root.querySelector(C('.vm-menu')); if (m) m.remove(); }
  function menuAt(anchor, build) {
    closeMenu(); const root = V.root; if (!root) return null; const m = mk('div', 'vm-menu'); build(m); root.appendChild(m);
    const a = anchor.getBoundingClientRect(), u = root.getBoundingClientRect(); const scale = (u.width / root.offsetWidth) || 1; const mw = m.offsetWidth, mh = m.offsetHeight;
    let x = (a.right - u.left) / scale - mw, y = (a.bottom - u.top) / scale + 6; if (y + mh > root.offsetHeight - 8) y = (a.top - u.top) / scale - mh - 6;
    m.style.left = clamp(x, 8, Math.max(8, root.offsetWidth - mw - 8)) + 'px'; m.style.top = clamp(y, 8, Math.max(8, root.offsetHeight - mh - 8)) + 'px';
    setTimeout(() => { const off = ev => { if (m.contains(ev.target)) return; closeMenu(); document.removeEventListener('pointerdown', off, true); }; document.addEventListener('pointerdown', off, true); }, 0);
    return m;
  }
  function menuItem(m, icon, label, fn, danger) { const b = mk('button', danger ? 'danger' : '', g(icon, 15) + '<span>' + esc(label) + '</span>'); b.onclick = () => { closeMenu(); fn(); }; m.appendChild(b); return b; }
  function menuSep(m, label) { m.appendChild(mk('div', 'vm-menusep', label ? esc(label) : '')); }
  function menu(id, anchor, opts = {}) {
    const s = song(id); if (!s) return;
    menuAt(anchor, m => {
      menuItem(m, 'play', 'Reproduzir agora', () => start([id], MU.ctx, id)); menuItem(m, 'list', 'Reproduzir a seguir', () => queueAdd(id, true)); menuItem(m, 'plus', 'Adicionar à fila', () => queueAdd(id, false));
      if (s.vid) menuItem(m, 'sparkles', 'Iniciar uma rádio a partir desta', () => startRadio(id));
      menuSep(m); menuItem(m, 'heart', liked(id) ? 'Remover dos gostos' : 'Adicionar aos gostos', () => toggleLike(id));
      if (!inLib(id)) menuItem(m, 'download', 'Guardar nas tuas músicas', () => libAdd(id)); else menuItem(m, 'trash', 'Remover das tuas músicas', () => libRemove(id));
      menuSep(m, 'Adicionar a playlist'); MU.playlists.slice(0, 8).forEach(p => menuItem(m, 'music', p.name, () => plAdd(p.id, id))); menuItem(m, 'plus', 'Nova playlist…', () => plDialog(null, id));
      if (opts.remove) { menuSep(m); menuItem(m, 'x', opts.removeLabel || 'Remover', opts.remove, true); }
    });
  }
  function plMenu(plId, anchor) {
    const p = pl(plId); if (!p) return;
    menuAt(anchor, m => {
      menuItem(m, 'play', 'Reproduzir', () => { MU.shuffle = false; start(p.tracks, { k: 'pl', label: p.name, id: p.id }); }); menuItem(m, 'shuffle', 'Aleatório', () => shuffleStart(p.tracks, { k: 'pl', label: p.name, id: p.id }));
      menuSep(m); menuItem(m, 'pen', 'Mudar nome e cor…', () => plDialog(p.id));
      menuItem(m, 'trash', 'Apagar playlist', () => confirmDlg(`Apagar “${p.name}”?`, 'As músicas ficam na biblioteca. Só a playlist desaparece.', () => { plDelete(p.id); if (V.view === 'pl' && V.openPl === p.id) go('home'); }), true);
    });
  }

  /* ---------- diálogos (muDialog / muField / muPlDialog / muConfirm) ---------- */
  function closeDialog() { const d = V.root && V.root.querySelector(C('.vm-dlg-ov')); if (d) d.remove(); }
  function dialog(title, text, build, onSave, saveLabel) {
    closeDialog(); const root = V.root; if (!root) return null; const ov = mk('div', 'vm-dlg-ov'); const box = mk('div', 'vm-dlg');
    box.appendChild(mk('div', 'vm-dlgtitle', esc(title))); if (text) box.appendChild(mk('div', 'vm-dlgtext', esc(text)));
    const state = {}; if (build) build(box, state);
    const r = mk('div', 'vm-dlgrow'); const cancel = btn('Cancelar', null, 'ghost', closeDialog); const save = btn(saveLabel || 'Guardar', null, '', () => { if (onSave(state) !== false) closeDialog(); }); r.appendChild(cancel); r.appendChild(save); box.appendChild(r);
    ov.appendChild(box); ov.onclick = e => { if (e.target === ov) closeDialog(); }; root.appendChild(ov);
    const first = box.querySelector('input, textarea'); if (first) { first.focus(); if (first.select) first.select(); }
    box.addEventListener('keydown', e => { if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA') { e.preventDefault(); save.click(); } if (e.key === 'Escape') { e.preventDefault(); closeDialog(); } });
    return box;
  }
  function field(box, state, key, label, value, placeholder, multiline) { const f = mk('div', 'vm-dlgfield'); f.appendChild(mk('span', null, esc(label))); const input = document.createElement(multiline ? 'textarea' : 'input'); input.value = value || ''; input.placeholder = placeholder || ''; if (multiline) input.rows = 2; input.oninput = () => { state[key] = input.value; }; state[key] = value || ''; f.appendChild(input); box.appendChild(f); return input; }
  function plDialog(plId, addSongId) {
    const p = plId ? pl(plId) : null;
    dialog(p ? 'Editar playlist' : 'Nova playlist', null, (box, state) => {
      field(box, state, 'name', 'Nome', p ? p.name : '', 'Viagem noturna'); field(box, state, 'note', 'Descrição', p ? p.note : '', 'Opcional', true);
      const f = mk('div', 'vm-dlgfield'); f.appendChild(mk('span', null, 'Capa')); const sw = mk('div', 'vm-swatches'); state.art = p ? p.art : Math.floor(Math.random() * ARTS.length);
      ARTS.forEach((gr, i) => { const b = mk('button', 'vm-swatch' + (state.art === i ? ' on' : '')); b.style.background = gr; b.onclick = () => { state.art = i; sw.querySelectorAll(C('.vm-swatch')).forEach((x, j) => x.classList.toggle('on', j === i)); }; sw.appendChild(b); });
      f.appendChild(sw); box.appendChild(f);
    }, state => {
      const name = (state.name || '').trim(); if (!name) { UI.toast('Dá-lhe um nome'); return false; }
      if (p) { p.name = name.slice(0, 60); p.note = (state.note || '').slice(0, 160); p.art = state.art; saveSoon(); UI.toast('Playlist atualizada'); emit(); }
      else { const np = plNew(name, state.note, state.art); if (addSongId) plAdd(np.id, addSongId, true); UI.toast('Criada: ' + np.name); openPl(np.id); }
    }, p ? 'Guardar' : 'Criar');
  }
  function confirmDlg(title, text, onYes) { dialog(title, text, null, () => { onYes(); }, 'Apagar'); }

  /* ===================== NOVA UI: esqueleto, mini-leitor, progresso, separadores e leitor em ecrã inteiro =====================
     Construído UMA vez por janela; cada tick só escreve o que mudou (setText, classes, transform do progresso). */
  const NAV_A = [['home', 'Início'], ['lib', 'Músicas'], ['liked', 'Gostos'], ['pls', 'Listas'], ['recent', 'Histórico'], ['car', 'Carro']];
  function openPane(k) { V.pane = k; V.fullTab = k; const s = MU.now ? song(MU.now) : null; if (k === 'lyrics' && s && s.vid) loadLyrics(s.vid); repaint(true); }
  function buildRootA() {
    const root = UI.el(`<div class="view amus"><div class="amus-bg"></div>
      <div class="amus-top"><div class="amus-tbar"><b></b><button class="amus-ib amus-more">${g('moreV', 22)}</button></div>
        <div class="amus-srow"><button class="amus-ib amus-back" hidden>${g('chevL', 22)}</button><div class="amus-searchwrap"><div class="amus-search">${g('search', 20)}<input spellcheck="false" autocomplete="off" placeholder="Músicas e artistas"><button class="amus-qx">${g('x', 16)}</button></div><div class="amus-sugg"></div></div></div>
        <div class="amus-tabs"></div></div>
      <div class="amus-body"></div>
      <div class="amus-mini"><div class="amus-mcov"></div><div class="amus-mtx"><b class="amus-mt">Nada a tocar</b><span class="amus-ma">Escolhe algo para começar</span></div><button class="amus-ib amus-mplay">${g('play', 24)}</button><button class="amus-ib amus-mnext">${g('next', 22)}</button><div class="amus-mprog"><i></i></div></div>
      <div class="amus-full"><div class="amus-fullbg"></div><div class="amus-fveil"></div>
        <div class="amus-fin">
          <div class="amus-ftop"><button class="amus-ib amus-collapse">${g('chevD', 26)}</button><div class="amus-from"></div><button class="amus-ib amus-fmore">${g('moreV', 22)}</button></div>
          <div class="amus-fart"></div>
          <div class="amus-fmeta"><div class="amus-ftx"><b class="amus-ftitle"></b><span class="amus-fartist"></span></div><button class="amus-ib amus-flike">${g('heart', 26)}</button></div>
          <div class="amus-seek"><div class="amus-track"><div class="amus-fill"></div></div><div class="amus-dot"></div></div>
          <div class="amus-times"><span class="amus-el">0:00</span><span class="amus-len">0:00</span></div>
          <div class="amus-ctl"><button class="amus-ib amus-shuf">${g('shuffle', 22)}</button><button class="amus-ib amus-prev">${g('prev', 30)}</button><button class="amus-fplay">${g('play', 32)}</button><button class="amus-ib amus-next">${g('next', 30)}</button><button class="amus-ib amus-rep">${g('repeat', 22)}<i class="amus-r1">1</i></button></div>
          <div class="amus-vol"><button class="amus-ib amus-volbtn">${g('speaker', 20)}</button><input type="range" min="0" max="100" value="${MU.vol}"><span class="amus-volv">${MU.vol}</span></div>
          <div class="amus-fbot"><button class="amus-fb amus-lyr">${g('textsize', 18)}<span>Letra</span></button><button class="amus-fb amus-where">${g('speaker', 18)}<span class="amus-wt">Telemóvel</span></button><button class="amus-fb amus-q">${g('list', 18)}<span>A seguir</span></button></div>
        </div>
        <div class="amus-pane"><div class="amus-phd"><div class="amus-ptabs"></div><button class="amus-ib amus-pclose">${g('x', 18)}</button></div><div class="amus-pbody"></div></div>
      </div></div>`);
    const $ = sel => root.querySelector(sel);
    $('.amus-tbar b').textContent = App.name('music');
    const q = $('.amus-search input');
    q.oninput = () => { V.suggMute = false; $('.amus-qx').classList.toggle('on', !!q.value); suggest(q.value); liveSearch(q.value); };
    q.onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); doSearch(q.value); } else if (e.key === 'Escape') { V.suggMute = true; hideSugg(); } };
    q.onfocus = () => { if (V.view !== 'search') go('search'); V.suggMute = false; if (q.value.trim().length >= 2) suggest(q.value); };
    q.onblur = () => setTimeout(() => { if (document.activeElement !== q) hideSugg(); }, 180);
    $('.amus-qx').onclick = () => { q.value = ''; $('.amus-qx').classList.remove('on'); hideSugg(); clearTimeout(V.liveT); search(''); q.focus(); };
    $('.amus-back').onclick = goBack;
    $('.amus-more').onclick = () => menuAt($('.amus-more'), m => { menuItem(m, 'plus', 'Nova playlist…', () => plDialog(null, null)); menuItem(m, 'music', 'Listas de reprodução', () => go('pls')); menuItem(m, 'car', 'Onde toca a música', () => go('car')); });
    $('.amus-mini').onclick = e => { if (e.target.closest('.amus-mplay, .amus-mnext')) return; if (MU.now) toggleFull(true); else { go('search'); focusQ(); } };
    $('.amus-mplay').onclick = e => { e.stopPropagation(); pauseResume(); };
    $('.amus-mnext').onclick = e => { e.stopPropagation(); if (MU.now) advance(1, false); };
    $('.amus-collapse').onclick = () => toggleFull(false); UI.swipe($('.amus-fin'), { down: () => toggleFull(false), threshold: 80 });
    $('.amus-fmore').onclick = () => { if (MU.now) menu(MU.now, $('.amus-fmore'), {}); };
    $('.amus-flike').onclick = () => { if (MU.now) toggleLike(MU.now); };
    $('.amus-fart').onclick = () => { if (MU.now) pauseResume(); };
    $('.amus-fplay').onclick = pauseResume; $('.amus-prev').onclick = prev; $('.amus-next').onclick = () => advance(1, false);
    $('.amus-shuf').onclick = () => { MU.shuffle = !MU.shuffle; if (MU.shuffle && MU.order.length > 1) { MU.order = shuffled(MU.order, MU.now); MU.idx = 0; } UI.toast(MU.shuffle ? 'Aleatório ligado' : 'Aleatório desligado'); emit(); };
    $('.amus-rep').onclick = () => { MU.repeat = MU.repeat === 'off' ? 'all' : MU.repeat === 'all' ? 'one' : 'off'; UI.toast(MU.repeat === 'off' ? 'Repetição desligada' : MU.repeat === 'all' ? 'Repetir tudo' : 'Repetir uma'); emit(); };
    $('.amus-where').onclick = () => { if (!MU.carplay) { UI.toast('O CarLink não está disponível neste servidor.'); return; } if (!MU.car && !V.inCar) { refreshCar(); UI.toast('Entra num veículo para tocar no carro.'); return; } toCar(!MU.car); };
    $('.amus-lyr').onclick = () => openPane('lyrics'); $('.amus-q').onclick = () => openPane('next'); $('.amus-pclose').onclick = () => { V.pane = null; repaint(true); };
    const vol = $('.amus-vol input'); const volP = () => vol.style.setProperty('--p', vol.value + '%');
    vol.oninput = () => { V.volDrag = true; MU.vol = +vol.value; $('.amus-volv').textContent = MU.vol; volP(); applyVol(); };
    vol.onchange = () => { V.volDrag = false; System.setState({ volume: MU.vol }, { noApply: true }); };
    $('.amus-volbtn').onclick = () => { if (MU.vol > 0) { V.lastVol = MU.vol; MU.vol = 0; } else MU.vol = V.lastVol || 60; applyVol(); System.setState({ volume: MU.vol }, { noApply: true }); emit(); };
    volP();
    /* barra de progresso que segue o dedo: medida UMA vez no pointerdown (sem layout síncrono a cada movimento) */
    let seekRect = null; const seek = $('.amus-seek');
    const posOf = e => { const r = seekRect || seek.getBoundingClientRect(); return clamp((e.clientX - r.left) / (r.width || 1), 0, 1); }; const durNow = () => MU.dur || (song(MU.now) || {}).len || 0;
    const preview = f => { $('.amus-fill').style.transform = `scaleX(${f.toFixed(4)})`; $('.amus-dot').style.left = (f * 100).toFixed(2) + '%'; const d = durNow(); if (d) $('.amus-el').textContent = UI.fmtDur(d * f); };
    seek.addEventListener('pointerdown', e => { if (!MU.now) return; V.seeking = true; seek.classList.add('grabbing'); try { seek.setPointerCapture(e.pointerId); } catch (x) {} seekRect = seek.getBoundingClientRect(); if (!seekRect.width) seekRect = null; preview(posOf(e)); });
    seek.addEventListener('pointermove', e => { if (V.seeking) preview(posOf(e)); });
    const endSeek = e => { if (!V.seeking) return; V.seeking = false; seek.classList.remove('grabbing'); const d = durNow(); if (d) seekTo(d * posOf(e)); seekRect = null; };
    seek.addEventListener('pointerup', endSeek); seek.addEventListener('pointercancel', endSeek);
    return root;
  }
  /* separadores em pílula: construídos uma vez; depois só muda qual está ligado */
  function renderRailA() {
    const tabs = $v('.amus-tabs'); if (!tabs) return;
    if (!tabs.children.length) NAV_A.forEach(([id, label]) => { const b = mk('button', 'amus-tab'); b.dataset.v = id; b.textContent = label; b.onclick = () => { go(id); }; tabs.appendChild(b); });
    let on = null; [...tabs.children].forEach(b => { const k = b.dataset.v === V.view; if (k !== b.classList.contains('on')) b.classList.toggle('on', k); if (k) on = b; });
    if (on && on.scrollIntoView) sivSoon(on);
  }
  function paintBarA() {
    const root = V.root; if (!root) return; const $ = sel => root.querySelector(sel); const s = MU.now ? song(MU.now) : null;
    setText($('.amus-mt'), s ? s.t : 'Nada a tocar'); setText($('.amus-ma'), s ? (s.a || 'Artista desconhecido') : 'Escolhe algo para começar');
    setText($('.amus-ftitle'), s ? s.t : 'Nada a tocar'); setText($('.amus-fartist'), s ? (s.a || 'Artista desconhecido') : '');
    if (root.classList.contains('amus-idle') === !!s) root.classList.toggle('amus-idle', !s);
    const cover = s ? songArt(s) : NOART; if (V.lastCover !== cover) { V.lastCover = cover; $('.amus-mcov').style.background = cover; $('.amus-fart').style.background = cover; }
    if (V.lastPlay !== MU.playing) { V.lastPlay = MU.playing; $('.amus-mplay').innerHTML = g(MU.playing ? 'pause' : 'play', 24); $('.amus-fplay').innerHTML = g(MU.playing ? 'pause' : 'play', 32); }
    $('.amus-flike').classList.toggle('on', !!(s && liked(s.id)));
    if (V.likeRev !== MU.likeRev) { V.likeRev = MU.likeRev; root.querySelectorAll('.amus-row .amus-rowlike').forEach(b => { const r = b.closest('.amus-row'); const on = !!(r && liked(r.dataset.sid)); if (on !== b.classList.contains('lit')) b.classList.toggle('lit', on); }); }
    if (V.lastNow !== MU.now) { V.lastNow = MU.now;
      root.querySelectorAll('.amus-row').forEach(r => { const on = r.dataset.sid === MU.now && !!MU.now; if (on === r.classList.contains('on')) return; r.classList.toggle('on', on);
        const ix = r.querySelector('.amus-rowidx'); if (!ix) return; if (on) ix.innerHTML = '<span class="amus-eq"><i></i><i></i><i></i></span>'; else ix.textContent = ix.dataset.idx || ''; }); }
    root.querySelectorAll('.amus-eq').forEach(e => { if (e.classList.contains('paused') === MU.playing) e.classList.toggle('paused', !MU.playing); });
    $('.amus-shuf').classList.toggle('on', !!MU.shuffle); $('.amus-rep').classList.toggle('on', MU.repeat !== 'off'); $('.amus-rep').classList.toggle('one', MU.repeat === 'one');
    setText($('.amus-from'), 'A tocar de ' + (MU.ctx.label || 'Biblioteca'));
    const vol = $('.amus-vol input'); if (vol && !V.volDrag && +vol.value !== MU.vol) { vol.value = MU.vol; vol.style.setProperty('--p', MU.vol + '%'); } setText($('.amus-volv'), MU.vol);
    const muted = MU.vol <= 0; if (V.lastMute !== muted) { V.lastMute = muted; $('.amus-volbtn').innerHTML = g(muted ? 'volumeX' : 'speaker', 20); }
    const wb = $('.amus-where'); if (wb.classList.contains('on') !== !!MU.car) wb.classList.toggle('on', !!MU.car); setText($('.amus-wt'), MU.car ? 'Carro' : 'Telemóvel');
  }
  function paintProgressA() {
    if (!V.root || V.seeking) return; const root = V.root; const s = MU.now ? song(MU.now) : null; const d = MU.dur || (s && s.len) || 0; const f = d > 0 ? clamp(MU.elapsed / d, 0, 1) : 0;
    const t = `scaleX(${f.toFixed(4)})`; const fill = root.querySelector('.amus-fill'); if (fill.style.transform !== t) { fill.style.transform = t; root.querySelector('.amus-mprog i').style.transform = t; root.querySelector('.amus-dot').style.left = (f * 100).toFixed(2) + '%'; }
    setText(root.querySelector('.amus-el'), UI.fmtDur(MU.elapsed || 0)); setText(root.querySelector('.amus-len'), d > 0 ? UI.fmtDur(d) : '0:00');
  }
  function renderFullA() {
    const full = $v('.vm-full'); if (!full) return; if (!V.full) V.pane = null;
    full.classList.toggle('on', !!V.full); V.root.querySelector('.amus-pane').classList.toggle('on', !!(V.full && V.pane));
    /* o leitor é escuro (capa desfocada): a barra de estado fica clara enquanto está aberto */
    const sb = V.full ? 'dark' : 'auto', d = App.get('music'); if (d && d.statusBar !== sb) { d.statusBar = sb; try { System.updateSbTheme(); } catch (e) {} }
    if (!V.full || !V.pane) return;
    const tabs = $v('.vm-fulltabs'); tabs.innerHTML = '';
    [['next', 'A seguir'], ['lyrics', 'Letra']].forEach(([id, label]) => { const b = mk('button', 'amus-ptab' + (V.pane === id ? ' on' : '')); b.textContent = label; b.onclick = () => openPane(id); tabs.appendChild(b); });
    renderFullPane();
  }

  /* ---------- o skeleton (#s-music do CarLink) + wiring (muWire) ---------- */
  function buildRoot() {
    if (V.android) return buildRootA();
    const root = UI.el(`<div class="view vm">
      <div class="vm-bg"></div><div class="vm-veil"></div>
      <div class="vm-top">
        <button class="vm-topback" hidden>${g('chevL', 20)}</button>
        <div class="vm-searchwrap"><div class="vm-search">${g('search', 21)}<input spellcheck="false" autocomplete="off" placeholder="Músicas e artistas"><button class="vm-qx">${g('x', 18)}</button></div><div class="vm-sugg"></div></div>
        <span class="vm-where">${g('speaker', 18)}<span class="vm-wheretext">Telemóvel</span></span>
      </div>
      <nav class="vm-rail"><div class="vm-brand"><span class="vm-logo">${g('play', 17)}</span><span class="vm-brandtext">Música</span></div><div class="vm-nav"></div><div class="vm-railsep"></div><button class="vm-newpl">${g('plus', 20)}<span>Nova playlist</span></button><div class="vm-pls"></div></nav>
      <div class="vm-body"></div>
      <div class="vm-bar">
        <div class="vm-bl"><button class="vm-cover"><span class="vm-coverup">${g('expand', 20)}</span></button><span class="vm-btext"><button class="vm-btitle">Nada a tocar</button><span class="vm-bsub">Escolhe algo para começar</span></span><button class="vm-like">${g('heart', 20)}</button><button class="vm-tb vm-queuebtn">${g('list', 20)}</button></div>
        <div class="vm-bm"><div class="vm-tbtns"><button class="vm-tb vm-shuf">${g('shuffle', 21)}</button><button class="vm-tb vm-prev">${g('prev', 22)}</button><button class="vm-play">${g('play', 23)}</button><button class="vm-tb vm-next">${g('next', 22)}</button><button class="vm-tb vm-rep">${g('repeat', 21)}</button></div>
          <div class="vm-seekrow"><span class="vm-t vm-el">0:00</span><div class="vm-seek"><div class="vm-seektrack"><div class="vm-seekfill"></div><div class="vm-seekdot"></div></div></div><span class="vm-t vm-len">0:00</span></div></div>
      </div>
      <div class="vm-full"><div class="vm-fullbg"></div><div class="vm-fullveil"></div><button class="vm-collapse">${g('chevD', 21)}</button>
        <div class="vm-fullgrid">
          <div class="vm-fullleft"><div class="vm-fullart"></div><div class="vm-fullmeta"><span class="vm-fulltitle">--</span><span class="vm-fullartist">--</span><span class="vm-fullfrom">--</span></div>
            <div class="vm-fullrow"><span class="vm-ctx">Biblioteca</span><div class="vm-vol"><button class="vm-tb vm-volbtn">${g('speaker', 20)}</button><input type="range" min="0" max="100" value="${MU.vol}"><span class="vol-val">${MU.vol}</span></div></div></div>
          <div class="vm-fullright"><div class="vm-fulltabs"></div><div class="vm-fullpane"></div></div>
        </div>
      </div></div>`);
    const $ = sel => root.querySelector(sel);
    const q = $('.vm-search input');
    q.oninput = () => { V.suggMute = false; $('.vm-qx').classList.toggle('on', !!q.value); suggest(q.value); liveSearch(q.value); };
    q.onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); doSearch(q.value); } else if (e.key === 'Escape') { V.suggMute = true; hideSugg(); } };
    q.onfocus = () => { if (V.view !== 'search') go('search'); V.suggMute = false; if (q.value.trim().length >= 2) suggest(q.value); };
    q.onblur = () => setTimeout(() => { if (document.activeElement !== q) hideSugg(); }, 180);   /* sair do campo fecha a lista (deixa passar o toque numa sugestão) */
    $('.vm-qx').onclick = () => { q.value = ''; $('.vm-qx').classList.remove('on'); hideSugg(); clearTimeout(V.liveT); search(''); q.focus(); };   /* search('') limpa E invalida a pesquisa a caminho */
    $('.vm-topback').onclick = goBack; $('.vm-newpl').onclick = () => plDialog(null, null);
    $('.vm-cover').onclick = () => { if (MU.now) toggleFull(); }; $('.vm-btitle').onclick = () => { if (MU.now) toggleFull(true); else { go('search'); focusQ(); } };
    $('.vm-like').onclick = () => { if (MU.now) toggleLike(MU.now); }; $('.vm-queuebtn').onclick = () => { V.fullTab = 'next'; toggleFull(true); };
    $('.vm-shuf').onclick = () => { MU.shuffle = !MU.shuffle; if (MU.shuffle && MU.order.length > 1) { MU.order = shuffled(MU.order, MU.now); MU.idx = 0; } UI.toast(MU.shuffle ? 'Aleatório ligado' : 'Aleatório desligado'); emit(); };
    $('.vm-prev').onclick = prev; $('.vm-next').onclick = () => advance(1, false); $('.vm-play').onclick = pauseResume;
    $('.vm-rep').onclick = () => { MU.repeat = MU.repeat === 'off' ? 'all' : MU.repeat === 'all' ? 'one' : 'off'; UI.toast(MU.repeat === 'off' ? 'Repetição desligada' : MU.repeat === 'all' ? 'Repetir tudo' : 'Repetir uma'); emit(); };
    $('.vm-collapse').onclick = () => toggleFull(false); UI.swipe($('.vm-full'), { down: () => toggleFull(false), threshold: 80 }); $('.vm-fullart').onclick = pauseResume;
    /* volume (o botão de volume do telemóvel também mexe aqui, via Bridge 'state') */
    const vol = $('.vm-vol input');
    vol.oninput = () => { V.volDrag = true; MU.vol = +vol.value; $('.vol-val').textContent = MU.vol; applyVol(); };
    vol.onchange = () => { V.volDrag = false; System.setState({ volume: MU.vol }, { noApply: true }); };
    $('.vm-volbtn').onclick = () => { if (MU.vol > 0) { V.lastVol = MU.vol; MU.vol = 0; } else MU.vol = V.lastVol || 60; applyVol(); System.setState({ volume: MU.vol }, { noApply: true }); emit(); };
    /* scrubber pintado (a barra de 3 px numa zona de toque de 22 px), segue o dedo */
    /* a barra não se mexe durante o arrasto: mede-se UMA vez no pointerdown. Ler getBoundingClientRect a cada
       pointermove, logo a seguir a escrever o width/left do evento anterior, forçava um layout síncrono por
       evento (60-120/s) - o padrão leitura-depois-de-escrita. */
    let seekRect = null;
    /* retângulo em px reais, como o clientX (ui.js UI.vrect: o zoom do aparelho e, no PearPhone Fold, o do conteúdo da app) */
    const vR = n => UI.vrect ? UI.vrect(n) : n.getBoundingClientRect();
    const seek = $('.vm-seek'); const posOf = e => { const r = seekRect || vR(seek); return clamp((e.clientX - r.left) / (r.width || 1), 0, 1); }; const durNow = () => MU.dur || (song(MU.now) || {}).len || 0;
    const preview = f => { $('.vm-seekfill').style.width = f * 100 + '%'; $('.vm-seekdot').style.left = f * 100 + '%'; const d = durNow(); if (d) $('.vm-el').textContent = UI.fmtDur(d * f); };
    seek.addEventListener('pointerdown', e => { if (!MU.now) return; V.seeking = true; seek.classList.add('grabbing'); try { seek.setPointerCapture(e.pointerId); } catch (x) {} seekRect = vR(seek); if (!seekRect.width) seekRect = null; preview(posOf(e)); });
    seek.addEventListener('pointermove', e => { if (V.seeking) preview(posOf(e)); });
    const endSeek = e => { if (!V.seeking) return; V.seeking = false; seek.classList.remove('grabbing'); const d = durNow(); if (d) seekTo(d * posOf(e)); seekRect = null; };
    seek.addEventListener('pointerup', endSeek); seek.addEventListener('pointercancel', endSeek);
    return root;
  }

  /* ---------- repintar: barra/progresso/fundo a cada tick; rail/corpo/player só quando a assinatura muda ---------- */
  /* MU.playing e MU.now SAÍRAM da assinatura: estavam a fazer com que um simples play/pause reconstruísse o rail, o corpo inteiro
     (até 60 linhas de histórico, cada uma com dois SVG) e o painel do player. A marcação da faixa a tocar é feita em paintBar(),
     que já corre a cada tick; a mudança real de faixa continua coberta por "MU.order.length + ':' + MU.idx". */
  /* DUAS assinaturas: o corpo (e o rail) e o player de ecrã inteiro dependem de coisas diferentes.
     · A troca de faixa (order/idx), a fila, a letra e o aleatório só mexem no painel "Seguintes/Letra": antes
       uma faixa nova reconstruía também o corpo inteiro (200 músicas guardadas = 200 linhas com SVG) a cada ~3 min.
     · Os gostos só entram na assinatura na vista Gostos (é a única que ganha/perde linhas); nas outras o coração
       pinta-se no sítio em paintBar(). O histórico só entra no Início (8 primeiros) e no Histórico (todo - com
       só os 12 primeiros, apagar uma entrada antiga não atualizava a lista).
     · A playlist aberta entra com a ORDEM das faixas: subir/descer uma faixa (plMove) não mudava o comprimento
       e a lista não se reordenava. */
  const sigBody = () => [MU.ok, MU.homeState, MU.home && MU.home.length, MU.results && MU.results.q, MU.searching, MU.searching ? searchQ : '', V.view === 'liked' ? MU.likes.join() : '', MU.lib.length, V.view === 'home' ? MU.recents.slice(0, 8).join() : V.view === 'recent' ? MU.recents.join() : '', MU.playlists.map(p => p.id + p.name + p.art + p.tracks.length).join(), V.view === 'pl' && pl(V.openPl) ? pl(V.openPl).tracks.join() : '', MU.status, V.view, V.openPl, V.page && (V.page.id + ':' + V.page.tracks.length + ':' + V.page.loading), V.filter, MU.car, MU.carplay, V.inCar].join('|');
  const sigFull = () => [V.full, V.full ? [V.fullTab, MU.queue.join(), MU.lyrics && (MU.lyrics.vid + ':' + MU.lyrics.loading + ':' + MU.lyrics.none), MU.shuffle, MU.repeat, MU.order.length + ':' + MU.idx, MU.now, MU.ctx && MU.ctx.label].join('|') : ''].join('|');
  function repaint(force) {
    if (!V.root || !V.root.isConnected) return;
    if (V.android) { const sb = sigBody(); if (force || sb !== V.sig) { V.sig = sb; renderRailA(); renderBody(); } const sf = sigFull() + '|' + (V.pane || ''); if (force || sf !== V.sigFull) { V.sigFull = sf; renderFullA(); } paintBarA(); paintProgressA(); paintBg(); return; }
    const sb = sigBody(); if (force || sb !== V.sig) { V.sig = sb; renderRail(); renderBody(); }
    const sf = sigFull(); if (force || sf !== V.sigFull) { V.sigFull = sf; renderFull(); }
    paintBar(); paintProgress(); paintBg(); railMu();
  }
  /* PearPhone Fold: na barra direita os destinos (Início, Pesquisar, Músicas...) numa pílula vertical, os controlos (anterior,
     reproduzir, seguinte) em baixo e o voltar em cima (das páginas; com o leitor aberto, fecha-o). Na barra de baixo fica a faixa e
     o tempo (app-music.css). Corre a cada repintura mas só refaz a coluna quando muda o que ela mostra */
  function railMu() {
    if (V.android || !V.win || !UI.railFor) return;
    const back = V.full ? { icon: 'chevD', label: 'Fechar o leitor', onTap: () => toggleFull(false) } : (V.view === 'pl' || V.view === 'page') ? { label: 'Voltar', onTap: goBack } : null;
    const sig = [V.full ? 1 : 0, V.view, back ? 1 : 0, MU.playing ? 1 : 0, MU.now ? 1 : 0].join('|'); if (V.railSig === sig) return; V.railSig = sig;
    UI.railFor(V.win, { back,
      tabs: V.full ? [] : NAV.map(([id, icon, label]) => ({ id: 'n' + id, icon, label, active: V.view === id, onTap: () => { go(id); if (id === 'search') focusQ(); } })),
      primary: [[{ id: 'pv', icon: 'prev', label: 'Anterior', disabled: !MU.now, onTap: prev }, { id: 'pp', icon: MU.playing ? 'pause' : 'play', label: MU.playing ? 'Pausa' : 'Reproduzir', onTap: pauseResume },
        { id: 'nx', icon: 'next', label: 'Seguinte', disabled: !MU.now, onTap: () => advance(1, false) }]] }, false);
  }

  App.define('music', {
    name: 'Música', category: 'Entretenimento', core: true, statusBar: 'auto',
    open(win) {
      /* as caches de pintura (último ícone, capa, gostos…) são da raiz ANTERIOR: uma app morta e reaberta
         nasce com o ícone de play e o paintBar julgava-o já certo */
      V.win = win; V.sig = ''; V.sigFull = ''; V.railSig = ''; V.bgKey = ''; V.barH = 0; V.full = false; V.pane = null; V.lastPlay = V.lastNow = V.lastMute = V.lastCover = undefined; V.likeRev = -1;
      V.android = !!(System.isAndroid && System.isAndroid());   /* o desenho é escolhido quando a janela nasce (trocar de sistema mata as janelas) */
      const root = buildRoot(); V.root = root; win.querySelector('.nav-stack').appendChild(root);
      /* ⚠️ o relógio de 1 s emite a cada segundo enquanto há som - e a música toca quase sempre com a app
         FECHADA (outra app à frente, janela escondida). Cada emit fazia a assinatura, ~20 querySelector e
         escritas na barra de uma janela invisível. Com a app fora de cena não se pinta: o resume() já faz
         repaint(true) ao voltar. */
      const listener = () => { if (!root.isConnected) { MU.listeners.delete(listener); return; } if (System.currentApp() !== 'music') return; repaint(false); };
      MU.listeners.add(listener); win.onClose = () => { MU.listeners.delete(listener); if (V.root === root) V.root = null; const d = App.get('music'); if (d && d.statusBar !== 'auto') { d.statusBar = 'auto'; try { System.updateSbTheme(); } catch (e) {} } };
      repaint(true); Promise.resolve(load()).then(() => { repaint(true); if (MU.ok) loadHome(false); if (MU.carplay) refreshCar(); });
    },
    resume(win) { V.win = win; if (V.root) repaint(true); },
    /* botão Voltar do sistema (Nova UI): fecha o painel do leitor, o leitor e as páginas antes de fechar a app; true = consumido */
    back() { if (!V.android || !V.root) return false;
      /* o menu ⋮ e os diálogos vivem dentro da app (fora do registo do UI): o Voltar fecha-os primeiro */
      if (V.root.querySelector(C('.vm-dlg-ov'))) { closeDialog(); return true; }
      if (V.root.querySelector(C('.vm-menu'))) { closeMenu(); return true; }
      if (V.full && V.pane) { V.pane = null; repaint(true); return true; } if (V.full) { toggleFull(false); return true; } if (V.view === 'pl' || V.view === 'page') { goBack(); return true; } return false; },
    actions: [{ label: 'Reproduzir', icon: 'play', onTap: () => { if (MU.now) pauseResume(); else playHome(); } }, { label: 'Pesquisar', icon: 'search', onTap: () => { System.openApp('music'); setTimeout(() => { if (V.root) { go('search'); focusQ(); } }, 300); } }],
  });

  /* srvErr/linkVid/openSearch: a pesquisa do sticker de música das stories usa as mesmas frases de erro e a mesma deteção de links */
  return { MU, load, search, start, playId, playQuery, pauseResume, advance, prev, seekTo, stop, toCar, toggleLike, libAdd, plNew, plAdd, song, put, go, openPl, toggleFull, srvErr, linkVid, openSearch, get now() { return MU.now ? song(MU.now) : null; } };
})();
