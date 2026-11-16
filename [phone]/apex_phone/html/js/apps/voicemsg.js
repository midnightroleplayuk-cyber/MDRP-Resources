/* ============================================================
   MENSAGENS DE VOZ - window.VoiceMsg (Fase 2, pacote M4)
   Contrato: docs/ARQUITETURA.md secção 8.4.
   ------------------------------------------------------------
   VoiceMsg.supported()                         → há getUserMedia + MediaRecorder neste cliente?
   VoiceMsg.recorder(host, { maxSec, onSend, onCancel, app })
                                                → gravador com forma de onda, contador, cancelar e enviar
   VoiceMsg.upload(blob, durationMs, waveform)  → { mediaId } (ou { mediaId:null, error })
   VoiceMsg.player({ mediaId, duration, waveform }) → elemento com play/pausa, arrastar e velocidade
   Extras (aditivos, usados também pelos grupos): uploadData(dataUrl, info), fetchMedia(id), errorText(code)

   ⚠️ HONESTIDADE: não é garantido que o CEF do FiveM dê o microfone à NUI. O supported() só diz se
   a API EXISTE; a gravação real pode ser recusada (NotAllowedError) ou nunca responder (pedido de
   permissão sem ninguém para o mostrar). Nos dois casos o gravador diz-o por extenso e larga tudo.

   Formato no servidor (media.begin/upload/finish/get): o `data` é um data: URL completo
   ("data:audio/webm;base64,…"), como as fotos já fazem; `mime` é o tipo base sem codecs; `size` é o
   comprimento dessa string; `duration` vai em MILISSEGUNDOS; `i` começa em 1. Na leitura aceita-se
   também base64 puro. Os mocks do browser de media.* são os do messages.js (pacote M3).
   ============================================================ */
window.VoiceMsg = (() => {
  const g = (n, s) => Icons.g(n, s);
  const BARS_LIVE = 34;     /* barras visíveis enquanto se grava */
  const BARS_OUT = 48;      /* barras guardadas no payload (o contrato permite até 64) */
  const MIN_MS = 1000;      /* abaixo de 1 s é um toque acidental: não se envia (e permite distinguir s de ms) */
  /* limite duro de bocados (nunca um ciclo sem fim). É o MAX_PARTS do server/media.lua: com 64 (o das fotos) um
     servidor com Config.Media.chunkBytes pequeno (o mínimo é 4000) recusava no cliente áudios que ele aceita, e
     na leitura o áudio vinha CORTADO sem erro nenhum (a bolha tocava só o início). */
  const MAX_PARTS = 512;
  const RATES = [1, 1.5, 2];
  const MIMES = ['audio/webm;codecs=opus', 'audio/webm', 'audio/ogg;codecs=opus', 'audio/ogg', 'audio/mp4'];
  const MIC_UNAVAILABLE = 'O microfone não está disponível neste cliente do FiveM';
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  const inFiveM = () => !!(window.Bridge && Bridge.inFiveM);

  /* ---------- Config.Media ----------
     O `ready` do client.lua ainda não traz o Config.Media (pedido feito ao client/main.lua e ao
     system.js): lê-se System.config.media se existir e, senão, os valores por omissão do config.lua. */
  function cfg() {
    const m = (window.System && System.config && System.config.media) || {};
    const num = (v, d, lo, hi) => { v = +v; return isFinite(v) && v > 0 ? clamp(v, lo, hi) : d; };
    return { maxSec: Math.floor(num(m.maxAudioSec, 60, 1, 600)), maxAudioBytes: num(m.maxAudioBytes, 700000, 10000, 16e6),
      maxImageBytes: num(m.maxImageBytes, 260000, 10000, 16e6), chunk: Math.floor(num(m.chunkBytes, 48000, 1024, 256000)) };
  }

  const supported = () => { try { return !!(navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function' && typeof window.MediaRecorder === 'function'); } catch (e) { return false; } };
  function pickMime() { try { if (typeof MediaRecorder.isTypeSupported !== 'function') return ''; return MIMES.find(t => MediaRecorder.isTypeSupported(t)) || ''; } catch (e) { return ''; } }
  /* mime que vai para o servidor: só o tipo base "audio/xxx" (≤ 40 carateres, coluna VARCHAR(40)). O ";codecs=opus"
     sai: validações do género ^audio/[A-Za-z0-9.+-]+$ recusavam-no, e o Chromium reconhece o Opus dentro do webm sozinho */
  const cleanMime = t => { const b = String(t || '').replace(/\s+/g, '').toLowerCase().split(';')[0]; return /^audio\/[a-z0-9.+-]{1,30}$/.test(b) ? b : 'audio/webm'; };
  const fmtMs = ms => UI.fmtDur(Math.max(0, +ms || 0) / 1000);
  /* duração do payload: os nossos envios vão em ms; um valor < 1000 só pode ser segundos (o gravador não envia menos de 1 s) */
  const normDuration = d => { d = +d; if (!isFinite(d) || d <= 0) return 0; return d < 1000 ? Math.round(d * 1000) : Math.round(d); };
  /* forma de onda recebida: até 64 números 0..1. Se vier noutra escala (0..31, 0..255) normaliza-se pelo pico */
  function cleanWave(w) {
    if (!Array.isArray(w) || !w.length) return null;
    let v = w.slice(0, 64).map(x => { x = +x; return isFinite(x) && x > 0 ? x : 0; });
    const mx = Math.max(...v); if (mx > 1) v = v.map(x => x / mx);
    return v.map(x => Math.round(clamp(x, 0, 1) * 100) / 100);
  }
  /* sem forma de onda no payload: um padrão baixo e DETERMINÍSTICO pelo mediaId (a mesma mensagem desenha-se sempre igual) */
  function placeholderWave(seed) { let s = (Math.floor(+seed) || 7) >>> 0; return Array.from({ length: 40 }, () => { s = (Math.imul(s, 1103515245) + 12345) >>> 0; return Math.round((.16 + ((s >>> 16) % 100) / 100 * .28) * 100) / 100; }); }
  /* reduz as amostras do analisador (~16/s) a n barras: mistura do pico e da média de cada fatia, normalizada pelo pico global */
  function resample(levels, n = BARS_OUT) {
    n = clamp(Math.floor(+n) || BARS_OUT, 1, 64);
    const src = (Array.isArray(levels) ? levels : []).map(v => { v = +v; return isFinite(v) ? clamp(v, 0, 1) : 0; });
    if (!src.length) return Array.from({ length: n }, () => .06);
    const out = [];
    for (let i = 0; i < n; i++) {
      const lo = Math.floor(i * src.length / n), hi = Math.min(src.length, Math.max(lo + 1, Math.ceil((i + 1) * src.length / n)));
      let mx = 0, sum = 0; for (let k = lo; k < hi; k++) { mx = Math.max(mx, src[k]); sum += src[k]; }
      out.push(mx * .6 + (sum / (hi - lo)) * .4);
    }
    const peak = Math.max(...out);
    return out.map(v => Math.round(clamp(peak > .02 ? v / peak : v, .06, 1) * 100) / 100);
  }

  /* ---------- Erros com nome ---------- */
  const ERR = {
    toolarge: 'O áudio é demasiado grande.', toolong: 'A mensagem de voz passa do limite de duração.', empty: 'A gravação ficou vazia.',
    ratelimit: 'Demasiados pedidos seguidos. Tenta daqui a pouco.', rpc: 'O servidor não respondeu.', read: 'Não foi possível ler a gravação.',
    forbidden: 'Sem acesso a este áudio.', notfound: 'Este áudio já não existe.', expired: 'Este áudio já expirou.', incomplete: 'O envio deste áudio não terminou.',
    badmedia: 'Formato de ficheiro inválido.', badmime: 'Formato de áudio não aceite pelo servidor.', format: 'Formato de áudio não suportado neste cliente.',
    /* códigos que o server/media.lua devolve de facto (sem eles o jogador via só "Não foi possível concluir a operação") */
    media: 'Formato de ficheiro inválido.', badkind: 'Formato de ficheiro inválido.', baddata: 'O ficheiro chegou estragado.', badsize: 'O envio ficou incompleto.',
    missing: 'O envio ficou incompleto.', badchunk: 'O envio foi interrompido.', order: 'O envio foi interrompido.', badduration: 'A duração do áudio não é válida.',
    busy: 'Já há outros envios a decorrer. Espera um instante.', noplayer: 'Sessão do jogador não encontrada.', db: 'Erro no servidor.'
  };
  const errorText = (code, fallback) => ERR[code] || fallback || 'Não foi possível concluir a operação.';

  /* ---------- Media aos bocados ---------- */
  /* rate limit: os bocados têm balde próprio, mas um envio longo logo a seguir a outro pode esgotá-lo - espera e repete (3×) */
  async function rpcRetry(name, data) {
    let r = await Bridge.rpcRaw(name, data);
    for (let k = 0; k < 3 && r && r.error === 'ratelimit'; k++) { await sleep(600 * (k + 1)); r = await Bridge.rpcRaw(name, data); }
    return r;
  }
  const parseMeta = m => { if (m && typeof m === 'object') return m; if (typeof m === 'string' && m.length < 20000) { try { const o = JSON.parse(m); return o && typeof o === 'object' ? o : null; } catch (e) {} } return null; };
  function blobToDataURL(blob) { return new Promise((res, rej) => { const fr = new FileReader(); fr.onload = () => res(String(fr.result || '')); fr.onerror = () => rej(fr.error || new Error('read')); fr.readAsDataURL(blob); }); }
  function dataUrlToBlob(u) {
    const i = u.indexOf(','); if (!/^data:/i.test(u) || i < 0) throw new Error('badmedia');
    const head = u.slice(5, i); if (!/;base64$/i.test(head)) throw new Error('badmedia');
    const bin = atob(u.slice(i + 1)); const arr = new Uint8Array(bin.length);
    for (let k = 0; k < bin.length; k++) arr[k] = bin.charCodeAt(k);
    return new Blob([arr], { type: head.replace(/;base64$/i, '') });
  }

  /* cache pequena (LRU de 12) das PROMESSAS: vários leitores do mesmo áudio (a conversa repintada)
     partilham um único download; um erro não fica em cache, a próxima tentativa volta a pedir */
  const mediaCache = new Map();
  const remember = (id, p) => { mediaCache.delete(id); mediaCache.set(id, p); while (mediaCache.size > 12) mediaCache.delete(mediaCache.keys().next().value); return p; };
  function fetchMedia(id) {
    id = Math.floor(+id);
    if (!(id > 0)) return Promise.resolve({ error: 'notfound' });
    if (mediaCache.has(id)) return remember(id, mediaCache.get(id));
    /* o messages.js (M3) tem a sua cache de media (fotos das conversas, avatar dos grupos na lista): o que já
       desceu por lá não se volta a pedir ao servidor bocado a bocado */
    try {
      const hit = window.Msgs && typeof Msgs.mediaCached === 'function' ? Msgs.mediaCached(id) : null;
      if (hit && typeof hit.url === 'string' && /^data:/i.test(hit.url)) return remember(id, Promise.resolve({ id, kind: hit.kind || null, mime: String(hit.mime || '').slice(0, 60), duration: +hit.duration || 0, meta: parseMeta(hit.meta), dataUrl: hit.url }));
    } catch (e) {}
    const p = (async () => {
      let out = '', total = 1, head = null;
      for (let i = 1; i <= total; i++) {
        const r = await rpcRetry('media.get', { id, i });
        if (!r || r.error || typeof r.data !== 'string') return { error: (r && r.error) || 'rpc' };
        if (!head) {
          head = r; total = Math.max(1, Math.floor(+r.total) || 1);
          if (total > MAX_PARTS) return { error: 'toolarge' };   /* cortar em silêncio dava um áudio truncado */
        }
        out += r.data;
        if (!r.data.length) break;
      }
      if (!out) return { error: 'empty' };
      const mime = String(head.mime || '').slice(0, 60);
      const dataUrl = /^data:/i.test(out) ? out : 'data:' + (mime || 'application/octet-stream') + ';base64,' + out.replace(/\s+/g, '');
      return { id, kind: head.kind || null, mime, duration: +head.duration || 0, meta: parseMeta(head.meta), dataUrl };
    })().catch(() => ({ error: 'rpc' }));
    remember(id, p);
    p.then(v => { if ((!v || v.error) && mediaCache.get(id) === p) mediaCache.delete(id); });
    return p;
  }

  /* envia um data: URL já pronto (áudio gravado, foto do grupo). info = { kind:'audio'|'image', mime, duration?, meta? } */
  async function uploadData(dataUrl, info = {}, onProgress) {
    if (typeof dataUrl !== 'string' || !/^data:[a-z]+\/[a-z0-9.+-]+[^,]*;base64,/i.test(dataUrl)) return { mediaId: null, error: 'badmedia' };
    const kind = info.kind === 'image' ? 'image' : 'audio';
    const c = cfg();
    if (dataUrl.length > (kind === 'image' ? c.maxImageBytes : c.maxAudioBytes)) return { mediaId: null, error: 'toolarge' };
    const req = { kind, mime: String(info.mime || dataUrl.slice(5, dataUrl.indexOf(';'))).slice(0, 40), size: dataUrl.length };
    if (info.duration != null) req.duration = Math.max(0, Math.round(+info.duration) || 0);
    if (info.meta && typeof info.meta === 'object') req.meta = info.meta;
    const b = await rpcRetry('media.begin', req);
    const id = b && Math.floor(+b.id);
    if (!b || b.error || !(id > 0)) return { mediaId: null, error: (b && b.error) || 'rpc' };
    const chunk = clamp(Math.floor(+b.chunk) || c.chunk, 1024, 256000);
    const total = Math.ceil(dataUrl.length / chunk);
    if (total > MAX_PARTS) return { mediaId: null, error: 'toolarge' };
    for (let i = 1; i <= total; i++) {
      const part = dataUrl.slice((i - 1) * chunk, i * chunk);
      /* (ronda 2) ao ritmo do limitador do FXServer (RecCore.take, o balde de todos os envios grandes da página): um áudio de
         700 KB são 15 pedaços de 48 KB, e seguidos passavam os 128 KiB/s depois do pico (o FXServer EXPULSA o jogador) */
      if (window.RecCore) await RecCore.take(part.length + 160);
      const r = await rpcRetry('media.upload', { id, i, total, data: part });
      if (!r || r.error || r.ok === false) return { mediaId: null, error: (r && r.error) || 'rpc' };
      if (onProgress) { try { onProgress(i / total); } catch (e) {} }
    }
    const f = await rpcRetry('media.finish', { id });
    if (!f || f.error || f.ok === false) return { mediaId: null, error: (f && f.error) || 'rpc' };
    /* quem enviou já tem os bytes: ouvir a própria mensagem não volta a descer 300 KB do servidor */
    remember(id, Promise.resolve({ id, kind, mime: req.mime, duration: req.duration || 0, meta: req.meta || null, dataUrl }));
    /* o recado.js/recado-chat.js leem pelo Msgs.media: a foto de perfil/grupo acabada de enviar pinta-se já, sem voltar a descer aos bocados */
    try { if (window.Msgs && typeof Msgs.mediaPut === 'function') Msgs.mediaPut(id, { url: dataUrl, kind, mime: req.mime, duration: req.duration || null, meta: req.meta || null }); } catch (e) {}
    return { mediaId: id };
  }

  async function upload(blob, durationMs, waveform, onProgress) {
    if (!blob || !(blob.size > 0)) return { mediaId: null, error: 'empty' };
    const dur = Math.max(0, Math.round(+durationMs) || 0);
    if (dur > cfg().maxSec * 1000 + 1500) return { mediaId: null, error: 'toolong' };
    let raw; try { raw = await blobToDataURL(blob); } catch (e) { return { mediaId: null, error: 'read' }; }
    const comma = raw.indexOf(','); if (comma < 0) return { mediaId: null, error: 'read' };
    /* alguns Chromium devolvem "data:;base64," num blob sem tipo: o cabeçalho é refeito com o mime limpo */
    const mime = cleanMime(blob.type);
    const dataUrl = 'data:' + mime + ';base64,' + raw.slice(comma + 1);
    return uploadData(dataUrl, { kind: 'audio', mime, duration: dur, meta: { waveform: cleanWave(waveform) || [] } }, onProgress);
  }

  /* ============================================================
     GRAVADOR
     ============================================================ */
  let activeRec = null;   /* só um gravador de cada vez (o microfone é um só) */
  function micError(e) {
    const n = e && e.name;
    if (n === 'NotReadableError' || n === 'TrackStartError') return 'O microfone está a ser usado por outra aplicação';
    if (inFiveM()) return MIC_UNAVAILABLE;
    if (n === 'NotFoundError' || n === 'DevicesNotFoundError' || n === 'OverconstrainedError') return 'Não foi encontrado nenhum microfone';
    if (n === 'NotAllowedError' || n === 'PermissionDeniedError' || n === 'SecurityError') return 'O acesso ao microfone foi recusado';
    if (n === 'TimeoutError') return 'O microfone não respondeu';
    return 'O microfone não está disponível';
  }

  function recorder(host, opts = {}) {
    if (activeRec) activeRec.cancel('replaced');
    const c = cfg();
    const maxSec = clamp(Math.floor(+opts.maxSec) || c.maxSec, 1, c.maxSec);
    const appId = opts.app || (window.System && System.currentApp && System.currentApp()) || 'messages';
    const el = UI.el(`<div class="vmsg-rec is-starting" role="group" aria-label="Gravar mensagem de voz">
      <div class="vmsg-rec-x" aria-label="Apagar gravação">${g('trash')}</div>
      <div class="vmsg-rec-mid">
        <div class="vmsg-rec-track"><span class="vmsg-rec-dot"></span><span class="vmsg-rec-time">0:00</span><div class="vmsg-rec-bars">${'<i></i>'.repeat(BARS_LIVE)}</div></div>
        <div class="vmsg-rec-hint">${g('chevL')}<span>Desliza para cancelar</span></div>
        <div class="vmsg-rec-msg">A preparar o microfone…</div>
      </div>
      <div class="vmsg-rec-play" aria-label="Ouvir a gravação">${g('play')}${g('pause')}</div>
      <div class="vmsg-rec-send" aria-label="Enviar">${g('arrowUp')}</div>
    </div>`);
    const q = s => el.querySelector(s);
    const bars = [...el.querySelectorAll('.vmsg-rec-bars i')];
    const timeEl = q('.vmsg-rec-time'), msgEl = q('.vmsg-rec-msg'), track = q('.vmsg-rec-track'), hint = q('.vmsg-rec-hint'), mid = q('.vmsg-rec-mid');
    let state = 'starting', stream = null, mr = null, ctx = null, an = null, buf = null, chunks = [], levels = [], t0 = 0, elapsed = 0;
    let timer = null, failT = null, finished = false, blob = null, mime = '', offs = [], preview = null, previewUrl = null, lastSec = -1, micOn = false, watchT = null;
    const setState = s => { state = s; el.classList.remove('is-starting', 'is-recording', 'is-stopping', 'is-review', 'is-sending', 'is-error'); el.classList.add('is-' + s); };
    host.classList.add('vmsg-host'); host.appendChild(el);

    /* ⚠️ LARGAR O MICROFONE É OBRIGATÓRIO em todos os caminhos (enviar, cancelar, erro, telemóvel
       guardado, app morta, troca de personagem): uma track esquecida deixa o microfone aberto até
       recarregar a NUI. release() é idempotente e corre em todos eles. */
    function release() {
      clearInterval(timer); timer = null;
      if (stream) { try { stream.getTracks().forEach(t => t.stop()); } catch (e) {} stream = null; }
      if (ctx) { try { const p = ctx.close(); if (p && p.catch) p.catch(() => {}); } catch (e) {} ctx = null; an = null; }
      /* só apaga o ponto da ilha que ESTE gravador acendeu: um gravador que falhou antes de abrir o microfone
         não pode apagar o indicador de outra coisa que esteja a gravar (o vídeo da câmara usa o mesmo 'mic') */
      if (micOn) { micOn = false; try { System.indicator('mic', false); } catch (e) {} }
    }
    function stopMr() { if (mr && mr.state !== 'inactive') { try { mr.ondataavailable = null; mr.onstop = null; mr.stop(); } catch (e) {} } }
    function destroy() {
      release(); clearTimeout(failT); clearInterval(watchT); watchT = null;
      offs.forEach(f => { try { f(); } catch (e) {} }); offs = [];
      if (preview) { try { preview.pause(); } catch (e) {} preview = null; }
      if (previewUrl) { URL.revokeObjectURL(previewUrl); previewUrl = null; }
      el.remove(); if (!host.querySelector('.vmsg-rec')) host.classList.remove('vmsg-host');
      if (activeRec === api) activeRec = null;
    }
    function cancel(reason = 'user') {
      if (finished) return; finished = true;
      stopMr(); chunks = []; destroy();
      try { opts.onCancel && opts.onCancel(reason); } catch (e) { console.error('[apex_phone] VoiceMsg onCancel', e); }
    }
    function fail(text, reason) {
      if (finished) return;
      stopMr(); release(); chunks = [];
      setState('error'); msgEl.textContent = text; msgEl.dataset.reason = reason || 'error';
      clearTimeout(failT); failT = setTimeout(() => cancel(reason), 3600);
    }
    function paintLive() {
      const n = bars.length, off = levels.length - n;
      for (let i = 0; i < n; i++) { const v = off + i >= 0 ? levels[off + i] : 0; bars[i].style.transform = 'scaleY(' + Math.max(.08, v).toFixed(3) + ')'; }
    }
    function paintWave(w) { const r = resample(w, bars.length); bars.forEach((b, i) => { b.style.transform = 'scaleY(' + Math.max(.08, r[i]).toFixed(3) + ')'; }); }
    function tick() {
      if (finished || state !== 'recording') return;
      if (!el.isConnected) { cancel('closed'); return; }
      elapsed = Math.min(performance.now() - t0, maxSec * 1000);
      let lvl = 0;
      if (an) {
        an.getByteTimeDomainData(buf);
        let sum = 0; for (let i = 0; i < buf.length; i += 2) { const v = (buf[i] - 128) / 128; sum += v * v; }
        lvl = Math.sqrt(clamp(Math.sqrt(sum / (buf.length / 2)) * 4, 0, 1));   /* RMS com ganho e raiz: a fala normal chega a meio da barra */
      }
      levels.push(lvl);
      paintLive();
      const s = Math.floor(elapsed / 1000); if (s !== lastSec) { lastSec = s; timeEl.textContent = fmtMs(elapsed); }
      if (elapsed >= maxSec * 1000) toReview('limit');
    }
    /* termina o MediaRecorder e devolve o Blob. Prazo de 2,5 s: um onstop que nunca chega não pendura o envio */
    function stopRecorder() {
      return new Promise(res => {
        const make = () => chunks.length ? new Blob(chunks, { type: (mr && mr.mimeType) || mime || 'audio/webm' }) : null;
        if (!mr || mr.state === 'inactive') return res(make());
        let done = false; const fin = () => { if (done) return; done = true; res(make()); };
        mr.onstop = fin; setTimeout(fin, 2500);
        try { mr.stop(); } catch (e) { fin(); }
      });
    }
    async function start() {
      if (!supported()) return fail(inFiveM() ? MIC_UNAVAILABLE : 'Este browser não permite gravar áudio', 'unsupported');
      /* a permissão do TELEMÓVEL (Definições › Privacidade › Microfone) vem antes da do navegador */
      if (window.Perm && Perm.request) { let ok = false; try { ok = await Perm.request(appId, 'mic'); } catch (e) { ok = false; } if (finished) return; if (!ok) return cancel('denied'); }
      let gum, late = false;
      try { gum = navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true }, video: false }); }
      catch (e) { return fail(micError(e), 'error'); }
      /* um pedido que só responde DEPOIS de desistirmos (prazo, cancelar, telemóvel guardado) larga logo o microfone */
      Promise.resolve(gum).then(st => { if (late || finished) { try { st.getTracks().forEach(t => t.stop()); } catch (e) {} } }, () => {});
      let st;
      /* prazo de 9 s: no CEF um pedido de permissão sem ninguém para o mostrar pode nunca responder */
      try { st = await Promise.race([gum, sleep(9000).then(() => { throw Object.assign(new Error('timeout'), { name: 'TimeoutError' }); })]); }
      catch (e) { late = true; return fail(micError(e), e && (e.name === 'NotAllowedError' || e.name === 'SecurityError') ? 'denied' : 'error'); }
      if (finished || !el.isConnected) { late = true; try { st.getTracks().forEach(t => t.stop()); } catch (e) {} if (!finished) cancel('closed'); return; }
      stream = st;
      mime = pickMime();
      /* 32 kbps de Opus chega para voz e mantém 60 s em ~320 KB de base64 (Config.Media.maxAudioBytes = 700 000) */
      try { mr = new MediaRecorder(stream, Object.assign({ audioBitsPerSecond: 32000 }, mime ? { mimeType: mime } : {})); }
      catch (e) { try { mr = new MediaRecorder(stream); } catch (e2) { return fail(inFiveM() ? MIC_UNAVAILABLE : 'Não foi possível iniciar a gravação', 'error'); } }
      mr.ondataavailable = ev => { if (ev.data && ev.data.size) chunks.push(ev.data); };
      mr.onerror = () => fail('A gravação falhou', 'error');
      try {
        const AC = window.AudioContext || window.webkitAudioContext; ctx = new AC();
        an = ctx.createAnalyser(); an.fftSize = 1024; an.smoothingTimeConstant = .2;
        ctx.createMediaStreamSource(stream).connect(an); buf = new Uint8Array(an.fftSize);   /* sem ligar ao destino: nada volta aos altifalantes */
        if (ctx.state === 'suspended') { const p = ctx.resume(); if (p && p.catch) p.catch(() => {}); }
      } catch (e) { an = null; }   /* sem analisador a gravação continua; a forma de onda fica baixa */
      try { mr.start(250); } catch (e) { return fail('Não foi possível iniciar a gravação', 'error'); }
      t0 = performance.now(); levels = []; lastSec = -1; msgEl.textContent = '';
      setState('recording');
      setTimeout(() => el.classList.add('hint-off'), 2600);   /* "Desliza para cancelar" só nos primeiros segundos: depois a faixa é toda da forma de onda */
      micOn = true; try { System.indicator('mic', true); } catch (e) {}
      timer = setInterval(tick, 60);
    }
    async function toReview(why) {
      if (finished || state !== 'recording') return;
      elapsed = Math.min(performance.now() - t0, maxSec * 1000);
      setState('stopping'); clearInterval(timer); timer = null;
      blob = await stopRecorder(); release();
      if (finished || state !== 'stopping') return;   /* um erro do MediaRecorder durante a paragem já mudou o estado */
      if (!blob || !blob.size) return fail('A gravação ficou vazia', 'error');
      paintWave(levels); timeEl.textContent = fmtMs(elapsed); msgEl.textContent = '';
      /* a faixa fica com a forma de onda para rever; o porquê da paragem vai num aviso, não por cima dela */
      if (why === 'limit') UI.toast(`Limite de ${maxSec} s atingido`); else if (why === 'call') UI.toast('Gravação parada pela chamada');
      setState('review');
    }
    async function send() {
      if (finished || state === 'starting' || state === 'error' || state === 'stopping' || state === 'sending') return;
      if (state === 'recording') {
        elapsed = Math.min(performance.now() - t0, maxSec * 1000);
        setState('stopping'); clearInterval(timer); timer = null;
        blob = await stopRecorder(); release();
        if (finished || state !== 'stopping') return;
      }
      if (elapsed < MIN_MS) { UI.toast('Mensagem de voz demasiado curta'); cancel('short'); return; }
      if (!blob || !blob.size) { fail('A gravação ficou vazia', 'error'); return; }
      if (preview) { try { preview.pause(); } catch (e) {} }
      const wf = resample(levels, BARS_OUT), dur = Math.round(elapsed);
      finished = true; setState('sending'); msgEl.textContent = 'A enviar…';
      let ret; try { ret = opts.onSend && opts.onSend(blob, dur, wf); } catch (e) { console.error('[apex_phone] VoiceMsg onSend', e); }
      /* se o onSend devolver uma promessa (upload + messages.send), o gravador fica em "A enviar…" até terminar */
      if (ret && typeof ret.then === 'function') { try { await ret; } catch (e) {} }
      destroy();
    }

    q('.vmsg-rec-x').onclick = e => { e.stopPropagation(); if (state === 'error') { clearTimeout(failT); cancel(msgEl.dataset.reason || 'error'); return; } cancel('user'); };
    q('.vmsg-rec-send').onclick = e => { e.stopPropagation(); send(); };
    q('.vmsg-rec-play').onclick = e => {
      e.stopPropagation(); if (state !== 'review' || !blob) return;
      if (!preview) { previewUrl = URL.createObjectURL(blob); preview = new Audio(previewUrl); preview.onended = () => el.classList.remove('is-previewing'); preview.onpause = () => el.classList.remove('is-previewing'); }
      if (preview.paused) { if (active) active.pause(); preview.volume = vol(); const p = preview.play(); el.classList.add('is-previewing'); if (p && p.catch) p.catch(() => el.classList.remove('is-previewing')); }
      else preview.pause();
    };
    /* deslizar para a esquerda cancela (só transform/opacity; UI.zoom converte px do rato em px do telemóvel) */
    let sw = null;
    /* (o zoom é o da própria pista: o aparelho e, no PearPhone Fold, o do conteúdo da app, ui.js UI.zoom(el)) */
    mid.addEventListener('pointerdown', e => { if (state !== 'recording' || (e.button && e.pointerType === 'mouse')) return; sw = { x: e.clientX, dx: 0, z: UI.vrect ? UI.zoom(track) || 1 : UI.zoom() }; try { mid.setPointerCapture(e.pointerId); } catch (x) {} track.style.transition = 'none'; hint.style.transition = 'none'; });
    mid.addEventListener('pointermove', e => { if (!sw) return; sw.dx = Math.min(0, (e.clientX - sw.x) / sw.z); track.style.transform = `translateX(${sw.dx.toFixed(1)}px)`; hint.style.opacity = Math.max(0, 1 + sw.dx / 90).toFixed(2); });
    const swEnd = () => { if (!sw) return; const dx = sw.dx; sw = null; track.style.transition = ''; hint.style.transition = ''; if (dx < -100 && state === 'recording') { cancel('user'); return; } track.style.transform = ''; hint.style.opacity = ''; };
    mid.addEventListener('pointerup', swEnd); mid.addEventListener('pointercancel', swEnd);

    const api = { el, send, cancel: (reason) => cancel(reason || 'user'), stop: () => toReview('user'), get state() { return state; }, get elapsed() { return elapsed; },
      _pausePreview() { if (preview && !preview.paused) { try { preview.pause(); } catch (e) {} } } };
    activeRec = api;
    offs.push(
      Bridge.on('phone:close', () => cancel('closed')),
      Bridge.on('session:changed', () => cancel('closed')),
      Bridge.on('app:kill', id => { if (id === appId) cancel('closed'); }),
      /* chamada a entrar: o que já foi gravado fica para rever/enviar; se o microfone ainda nem abriu, desiste-se */
      Bridge.on('incomingCall', () => { api._pausePreview(); if (state === 'starting') cancel('call'); else toReview('call'); })
    );
    /* o tick só vigia o DOM enquanto grava. Em revisão/erro/paragem, um host apagado por quem o montou (conversa
       fechada sem chamar cancel) deixava o gravador vivo: 4 ouvintes do Bridge, a pré-visualização e o objectURL
       presos até guardar o telemóvel. Uma verificação por segundo chega (o microfone já está largado nesses estados). */
    watchT = setInterval(() => { if (!finished && state !== 'sending' && !el.isConnected) cancel('closed'); }, 1000);
    start().catch(e => fail(micError(e), 'error'));
    return api;
  }

  /* ============================================================
     LEITOR
     ============================================================ */
  const live = new Set();   /* leitores com áudio carregado (têm um objectURL a libertar) */
  let active = null, sweepT = null, lastRate = 1;
  const rateLabel = r => (r === 1.5 ? '1,5' : String(r)) + '×';
  const vol = () => { const v = +((window.System && System.state) || {}).volume; return clamp(isFinite(v) ? v / 100 : .6, 0, 1); };
  /* leitores que saíram do documento (conversa fechada, lista repintada) largam o objectURL. Dois
     varrimentos seguidos fora do DOM: um nó que só está a ser MOVIDO não perde o áudio. */
  function armSweep() { if (sweepT) return; sweepT = setInterval(() => { live.forEach(p => p._sweep()); if (!live.size) { clearInterval(sweepT); sweepT = null; } }, 4000); }

  function player(payload, opts = {}) {
    const p = payload && typeof payload === 'object' ? payload : {};
    const mediaId = Math.floor(+p.mediaId) || 0;
    let durMs = normDuration(p.duration);
    const wave = cleanWave(p.waveform) || placeholderWave(mediaId);
    /* só números no HTML (toFixed): nada vindo do servidor entra como texto na string */
    const barsHtml = wave.map(v => `<i style="transform:scaleY(${Math.max(.1, v).toFixed(2)})"></i>`).join('');
    const el = UI.el(`<div class="vmsg-player" role="group" aria-label="Mensagem de voz">
      <div class="vmsg-btn" aria-label="Reproduzir">${g('play')}${g('pause')}<span class="vmsg-spin"></span></div>
      <div class="vmsg-body">
        <div class="vmsg-wave"><div class="vmsg-bars">${barsHtml}</div><div class="vmsg-rev"><div class="vmsg-bars">${barsHtml}</div></div></div>
        <div class="vmsg-meta"><span class="vmsg-time"></span></div>
      </div>
      <div class="vmsg-rate" aria-label="Velocidade"></div>
    </div>`);
    if (opts.cls) el.classList.add(...String(opts.cls).split(/\s+/).filter(Boolean));
    const btn = el.querySelector('.vmsg-btn'), waveEl = el.querySelector('.vmsg-wave'), timeEl = el.querySelector('.vmsg-time'), rateEl = el.querySelector('.vmsg-rate');
    const rev = el.querySelector('.vmsg-rev'), revIn = rev.firstElementChild;
    let audio = null, url = null, loading = null, readyP = null, fixing = false, fixT = null, pendingSeek = null, raf = 0, dead = false, err = null, drag = null, miss = 0, lastLabel = '', rate = lastRate, starting = false, offAt = 0;

    /* ---------- progresso SÓ por transform ----------
       A camada `.vmsg-rev` (barras a cheio) desliza para a esquerda e o conteúdo dela desliza o mesmo
       para a direita: a parte visível cobre [0, f] e as barras ficam alinhadas com as de baixo.
       Um scaleX na camada esticava as próprias barras; width/clip-path não animam no CEF. */
    const setProg = f => { const pct = ((1 - clamp(f, 0, 1)) * 100).toFixed(3); rev.style.transform = `translateX(-${pct}%)`; revIn.style.transform = `translateX(${pct}%)`; };
    const durS = () => (audio && isFinite(audio.duration) && audio.duration > 0 && !fixing) ? audio.duration : durMs / 1000;
    const label = ms => { const s = fmtMs(ms); if (s !== lastLabel) { lastLabel = s; timeEl.textContent = s; } };
    const showTotal = () => label(durMs || durS() * 1000);
    function paint() {
      if (!audio || fixing) return;
      const d = durS(), t = audio.currentTime || 0;
      setProg(d > 0 ? t / d : 0);
      if (audio.paused && t < .05) showTotal(); else label(t * 1000);
    }
    const stopLoop = () => { if (raf) cancelAnimationFrame(raf); raf = 0; };
    /* a tocar com o leitor FORA do documento (conversa fechada, bolha repintada por uma reação, app morta): não
       há botão para o parar, por isso pausa ao fim de 400 ms (um nó só MOVIDO volta antes disso). Antes o áudio
       continuava invisível até o varrimento de 4-8 s o cortar a meio. */
    const startLoop = () => { if (raf) return; offAt = 0; const step = () => { raf = 0; if (dead || !audio || audio.paused) return;
      if (!el.isConnected) { const t = performance.now(); if (!offAt) offAt = t; else if (t - offAt > 400) { pause(); return; } } else offAt = 0;
      if (!drag) paint(); raf = requestAnimationFrame(step); }; raf = requestAnimationFrame(step); };
    function showErr(text) { err = text; stopLoop(); el.classList.remove('is-loading', 'is-playing'); el.classList.add('is-error'); lastLabel = ''; timeEl.textContent = text; if (active === api) active = null; }

    /* larga o áudio e o objectURL; o leitor volta ao estado "por carregar" (um toque volta a pedir, da cache) */
    function release() {
      stopLoop(); clearTimeout(fixT); fixing = false;
      if (active === api) active = null;
      if (audio) { try { audio.pause(); audio.removeAttribute('src'); audio.load(); } catch (e) {} audio = null; }
      if (url) { URL.revokeObjectURL(url); url = null; }
      readyP = null; loading = null; live.delete(api);
      el.classList.remove('is-playing', 'is-loading');
    }
    function ensure() {
      if (audio) return Promise.resolve(true);
      if (loading) return loading;
      if (!mediaId) { showErr('Áudio indisponível'); return Promise.resolve(false); }
      el.classList.add('is-loading');
      const myLoad = loading = fetchMedia(mediaId).then(m => {
        if (loading !== myLoad) return false;   /* libertado a meio */
        loading = null; el.classList.remove('is-loading');
        if (dead) return false;
        if (!m || m.error || !m.dataUrl) { showErr(m && m.error === 'forbidden' ? 'Sem acesso' : m && (m.error === 'notfound' || m.error === 'expired') ? 'Já não existe' : 'Indisponível'); return false; }
        let b = null; try { b = dataUrlToBlob(m.dataUrl); } catch (e) { b = null; }
        if (!b || !b.size || !/^audio\//i.test(b.type || m.mime || '')) { showErr('Formato inválido'); return false; }
        if (!durMs && m.duration) { durMs = normDuration(m.duration); showTotal(); }
        url = URL.createObjectURL(b);
        /* `a` local: os eventos de um áudio JÁ LIBERTADO (o pause/error assíncronos do release) chegam depois de
           um novo ensure() ter criado outro, e mexiam no leitor novo (tiravam o is-playing, mostravam erro). */
        const a = audio = new Audio(); a.preload = 'auto';
        const mine = () => audio === a && !dead;
        let readyRes; readyP = new Promise(r => { readyRes = r; });
        const guard = setTimeout(() => readyRes(), 6000);
        const ready = () => { clearTimeout(guard); readyRes(); };
        /* ⚠️ o webm do MediaRecorder não traz a duração no cabeçalho (duration = Infinity) e sem ela o
           arrastar não funciona. Truque conhecido: saltar para o fim obriga o Chromium a ler o ficheiro
           todo, a duração aparece no durationchange e volta-se ao início. */
        const endFix = () => { if (!fixing || !mine()) return; fixing = false; clearTimeout(fixT); try { a.currentTime = 0; } catch (e) {} ready(); };
        a.addEventListener('loadedmetadata', () => {
          if (!mine()) return;
          if (!isFinite(a.duration)) { fixing = true; try { a.currentTime = 1e7; } catch (e) { fixing = false; ready(); return; } fixT = setTimeout(endFix, 2500); }
          else ready();
        });
        a.addEventListener('durationchange', () => { if (fixing && mine() && isFinite(a.duration)) endFix(); });
        a.addEventListener('timeupdate', () => { if (fixing && mine() && isFinite(a.duration)) endFix(); });
        a.addEventListener('playing', () => { if (fixing || !mine()) return; el.classList.add('is-playing'); startLoop(); });
        a.addEventListener('pause', () => { if (fixing || !mine()) return; el.classList.remove('is-playing'); stopLoop(); paint(); });
        /* `!a.paused`: um ended atrasado do salto para o fim (truque da duração) não pode parar um play que já começou */
        a.addEventListener('ended', () => { if (fixing || !mine() || !a.paused) return; stopLoop(); el.classList.remove('is-playing'); try { a.currentTime = 0; } catch (e) {} setProg(0); showTotal(); if (active === api) active = null; });
        a.addEventListener('error', () => { ready(); if (mine()) showErr('Formato não suportado'); });
        a.src = url;
        live.add(api); armSweep();
        return true;
      });
      return loading;
    }
    function seekTo(f) {
      f = clamp(+f || 0, 0, 1);
      setProg(f); label(f * durS() * 1000);
      if (!audio || fixing) { pendingSeek = f; return; }
      const d = durS(); try { audio.currentTime = Math.max(0, Math.min(f * d, d - .05)); } catch (e) { pendingSeek = f; }
    }
    async function play() {
      if (dead || err) return;
      if (active && active !== api) active.pause();   /* só um leitor a tocar de cada vez */
      if (activeRec) activeRec._pausePreview();          /* nem por cima da pré-visualização do gravador */
      active = api; starting = true;
      try {
        const ok = await ensure(); if (!ok || dead || active !== api) return;
        /* o acerto da duração do webm (salto ao fim) pode levar até 2,5 s: o botão mostra que está a preparar */
        if (fixing) el.classList.add('is-loading');
        await readyP; if (!loading) el.classList.remove('is-loading');
        if (dead || err || active !== api || !audio) return;
        if (pendingSeek != null) { const f = pendingSeek; pendingSeek = null; seekTo(f); }
        audio.playbackRate = rate; audio.volume = vol();
        try { await audio.play(); } catch (e) { if (active === api) active = null; if (e && e.name === 'NotAllowedError') UI.toast('Toca outra vez para ouvir'); }
      } finally { starting = false; }
    }
    function pause() { if (audio && !audio.paused) audio.pause(); if (active === api) active = null; }

    btn.onclick = e => {
      e.stopPropagation();
      if (err) { err = null; el.classList.remove('is-error'); release(); showTotal(); play(); return; }   /* tocar no erro tenta outra vez */
      if (audio && !audio.paused) pause();
      /* segundo toque durante o download OU durante o acerto da duração = desistir de tocar (antes só contava o
         download: no acerto o segundo toque chamava outro play() e o áudio arrancava na mesma) */
      else if (starting && active === api) { active = null; if (!loading) el.classList.remove('is-loading'); }
      else play();
    };
    rateEl.onclick = e => { e.stopPropagation(); rate = RATES[(RATES.indexOf(rate) + 1) % RATES.length]; lastRate = rate; rateEl.textContent = rateLabel(rate); if (audio) audio.playbackRate = rate; };
    /* tocar/arrastar na forma de onda muda a posição. Um toque parado > 450 ms é o menu da bolha (long press), não um salto */
    /* (retângulo em px reais, como o clientX: ui.js UI.vrect, para o zoom do aparelho e o do conteúdo no PearPhone Fold) */
    waveEl.addEventListener('pointerdown', e => { if (err || (e.button && e.pointerType === 'mouse')) return; drag = { r: UI.vrect ? UI.vrect(waveEl) : waveEl.getBoundingClientRect(), x: e.clientX, t: performance.now(), moved: false }; try { waveEl.setPointerCapture(e.pointerId); } catch (x) {} });
    waveEl.addEventListener('pointermove', e => { if (!drag) return; if (Math.abs(e.clientX - drag.x) > 4) { drag.moved = true; el.classList.add('is-seeking'); } if (!drag.moved || !drag.r.width) return; const f = clamp((e.clientX - drag.r.left) / drag.r.width, 0, 1); setProg(f); label(f * durS() * 1000); });
    const dragEnd = e => {
      if (!drag) return; const d = drag; drag = null; el.classList.remove('is-seeking');
      if (e.type === 'pointercancel' || !d.r.width || (!d.moved && performance.now() - d.t > 450)) { if (audio) paint(); else if (pendingSeek == null) { setProg(0); showTotal(); } return; }
      seekTo((e.clientX - d.r.left) / d.r.width);
      if (!audio && !loading && mediaId) ensure();   /* pré-carrega: o play a seguir já começa na posição escolhida */
    };
    waveEl.addEventListener('pointerup', dragEnd); waveEl.addEventListener('pointercancel', dragEnd);
    el.addEventListener('click', e => e.stopPropagation());   /* nenhum toque no leitor dispara a ação da bolha à volta */

    const api = {
      el, play, pause, seek: seekTo, release,
      destroy() { if (dead) return; dead = true; release(); },
      get playing() { return !!(audio && !audio.paused); }, get loaded() { return !!audio; }, get duration() { return durMs; }, get rate() { return rate; },
      _sweep() { if (el.isConnected) { miss = 0; return; } if (++miss >= 2) release(); }
    };
    el.vmsg = api;
    rateEl.textContent = rateLabel(rate); setProg(0); showTotal();
    if (!mediaId) showErr('Áudio indisponível');
    return el;
  }

  /* pausas globais: telemóvel guardado, chamada a entrar ou ativa, troca de personagem */
  const pauseActive = () => { if (active) active.pause(); };
  Bridge.on('phone:close', pauseActive);
  Bridge.on('incomingCall', pauseActive);
  Bridge.on('callState', d => { if (d && d.state === 'active') pauseActive(); });
  Bridge.on('session:changed', () => { [...live].forEach(p => p.destroy()); mediaCache.clear(); if (activeRec) activeRec.cancel('closed'); });

  return { supported, recorder, upload, player, uploadData, fetchMedia, errorText, MIC_UNAVAILABLE,
    get recording() { return activeRec ? activeRec.state : null; }, get playing() { return active ? active.el : null; },
    util: { resample, cleanWave, normDuration, cleanMime, fmtMs, pickMime, dataUrlToBlob, cfg } };
})();

/* Mocks do browser de media.begin/upload/finish/get: NÃO estão aqui de propósito. O pacote M3 regista-os
   em messages.js (com a regra de leitura do MediaCanRead: dono, mensagem, mail ou foto de um grupo de
   que se é membro) e dois mocks diferentes do mesmo RPC eram uma fonte de testes enganadores. */
