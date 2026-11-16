/* ============================================================
   RECORDER CORE (ronda 2 de 1.5.0, agente MEDIA) · window.RecCore
   O que a Câmara (vídeo) e o Gravador (áudio) partilham, para os dois gravarem da mesma maneira dentro do jogo:

   · limits(force)        → os limites do APARELHO na mão (RPC recording.limits, server/recording.lua + config_recording.lua):
                            duração e teto de vídeo e de áudio, débito já calculado a partir do orçamento, ritmo do envio.
                            Sem resposta do servidor: os valores antigos (Config.Camera.Video*, System.camera) com a mesma conta.
   · budget(sec, chars, …)→ a conta do débito (a MESMA do servidor): o vídeo + o som cabem SEMPRE no teto, sem cortar o fim.
   · videoMime(audio, codec) / audioMime() → o primeiro formato que o MediaRecorder DESTE cliente aceita (o CEF do FiveM é um
                            Chromium 103: webm vp8/vp9 + opus; mp4 só existe no MediaRecorder a partir do 126).
   · getMic(app, opts)    → o microfone com a permissão do telemóvel, prazo (o pedido do FiveM aparece no canto do ecrã e
                            pode nunca ser respondido) e um código com texto claro para cada recusa.
   · take(n) / upload(…)  → ENVIO AO RITMO DO LIMITADOR DO FXSERVER. Passar `rateLimiter_netEventSize_rate` (128 KiB/s por
                            omissão, pico 384 KiB) EXPULSA o jogador ("Reliable network event size overflow"). Um balde de
                            fichas único para todos os envios grandes desta página (vídeo, fotos, gravações), com a taxa que o
                            servidor lê das convars; pedaços por ordem, repetição segura do último, prazo e progresso.
   · fixWebmDuration(blob, ms) → escreve a duração no cabeçalho EBML do webm (o MediaRecorder não a escreve: sem ela o
                            leitor mostra "Infinity" e a barra de posição não serve).
   · blobToDataURL / dataURLToBlob (aos bocados, sem passar pelo teto de 2 MiB dos URLs do Chromium).
   · diag(opts)           → a linha do /rectest (client/recording.lua).
   REC3 (12 nov 2026): qualidade por predefinição ('standard' | 'high' | 'ultra', a mesma tabela do server/recording.lua em
   PRESETS), o codec vem nos limites (video.codec: vp8 ou vp9, com recurso ao vp8 se este cliente não gravar vp9), a
   permissão também (allowed / deny) e charsFor(sec, v, a) é a conta inversa do budget (o orçamento para um débito pedido).
   ============================================================ */
window.RecCore = (() => {
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  const num = (v, d, lo, hi) => { v = Number(v); return isFinite(v) && v > 0 ? clamp(v, lo, hi) : d; };
  const inFiveM = () => !!(window.Bridge && Bridge.inFiveM);
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf ? L.tf(s, ...v) : v.reduce((a, x) => a.replace('%s', x), s));

  /* ---------- a conta do débito (igual ao server/recording.lua) ---------- */
  const SAFETY = 0.78, HEADER = 6000, PREFIX = 32;
  function budget(seconds, maxChars, audioBps, minV = 150000, maxV = 2500000) {
    const binary = Math.floor((maxChars - PREFIX) * 3 / 4) - HEADER;
    const total = Math.floor(binary * 8 / seconds * SAFETY);
    let videoBps = total - (audioBps || 0);
    if (videoBps < minV) { videoBps = minV; seconds = Math.max(3, Math.floor(binary * 8 * SAFETY / (minV + (audioBps || 0)))); }
    else if (videoBps > maxV) videoBps = maxV;
    return { seconds, videoBps, audioBps: audioBps || 0 };
  }
  /* o orçamento (caracteres de base64) para N segundos a um débito: a conta inversa do budget (= server/recording.lua charsFor) */
  const charsFor = (seconds, videoBps, audioBps) => Math.ceil(((videoBps + (audioBps || 0)) * seconds / 8 / SAFETY + HEADER) * 4 / 3) + PREFIX + 8;
  /* as predefinições de qualidade (iguais às do server/recording.lua e do config_recording.lua de origem) */
  const PRESETS = {
    standard: { height: 640, fps: 24, videoKbps: 340, audioBps: 32000, codec: 'vp8' },
    high: { height: 720, fps: 30, videoKbps: 1000, audioBps: 48000, codec: 'vp8' },
    ultra: { height: 1080, fps: 30, videoKbps: 2500, audioBps: 64000, codec: 'vp9' },
  };

  /* ---------- limites do aparelho ---------- */
  let lim = null, limAt = 0, limP = null;
  function fallback() {
    const cam = (window.System && System.camera) || {};
    const sec = Math.round(num(cam.VideoMaxSeconds, 15, 3, 60)), chars = Math.round(num(cam.VideoMaxBytes, 1600000, 200000, 12000000));
    const audioOn = cam.VideoAudio === true, b = budget(sec, chars, audioOn ? 32000 : 0);
    return { enabled: true, allowed: true, device: false, local: true, os: (window.System && System.os) || 'ios',
      video: { seconds: b.seconds, maxChars: chars, videoBps: b.videoBps, audioBps: b.audioBps, audio: audioOn, height: Math.round(num(cam.VideoHeight, 640, 240, 1080)), fps: 24, codec: 'vp8', quality: 'legacy' },
      audio: { seconds: 120, maxChars: 1000000, bps: 32000 },
      upload: { bps: 58982, peak: 176947, chunk: 48000 }, storage: {} };
  }
  function sane(r) {
    if (!r || typeof r !== 'object' || r.error || !r.video || !r.audio) return null;
    const v = r.video, a = r.audio;
    v.seconds = Math.round(num(v.seconds, 15, 1, 600)); v.maxChars = Math.round(num(v.maxChars, 1600000, 50000, 2e7));
    v.videoBps = Math.round(num(v.videoBps, 400000, 50000, 8e6)); v.audioBps = Math.round(num(v.audioBps, 32000, 8000, 256000));
    v.height = Math.round(num(v.height, 640, 160, 1440)); v.fps = Math.round(num(v.fps, 24, 5, 60)); v.audio = v.audio !== false;
    v.codec = v.codec === 'vp9' ? 'vp9' : 'vp8'; v.quality = typeof v.quality === 'string' ? v.quality : '';
    /* REC3: permissão (um servidor antigo não manda o campo: pode gravar) */
    r.allowed = r.allowed !== false; r.deny = r.allowed ? null : (typeof r.deny === 'string' ? r.deny : 'ace');
    a.seconds = Math.round(num(a.seconds, 120, 1, 3600)); a.maxChars = Math.round(num(a.maxChars, 1000000, 10000, 3e7)); a.bps = Math.round(num(a.bps, 32000, 8000, 256000));
    r.upload = r.upload || {}; setPace(r.upload);
    r.storage = r.storage || {};
    return r;
  }
  function limits(force) {
    if (!force && lim && Date.now() - limAt < 30000) return Promise.resolve(lim);
    if (limP) return limP;
    limP = Promise.resolve(window.Bridge ? Bridge.rpcRaw('recording.limits', {}) : null).catch(() => null).then(r => {
      limP = null; const s = sane(r);
      lim = s || fallback(); limAt = s ? Date.now() : Date.now() - 25000;   /* sem servidor tenta outra vez daqui a 5 s */
      return lim;
    });
    return limP;
  }
  /* troca de aparelho (item) ou de personagem: os limites são outros */
  try { Bridge.on('frame', () => { limAt = 0; }); Bridge.on('session:changed', () => { lim = null; limAt = 0; }); Bridge.on('os:changed', () => { limAt = 0; }); } catch (e) {}

  /* ---------- formatos ---------- */
  const isType = t => { try { return typeof MediaRecorder === 'function' && typeof MediaRecorder.isTypeSupported === 'function' && MediaRecorder.isTypeSupported(t); } catch (e) { return false; } };
  const AUDIO = ['audio/webm;codecs=opus', 'audio/webm', 'audio/ogg;codecs=opus', 'audio/ogg'];
  /* REC3: o codec pedido primeiro (limites: video.codec), o outro a seguir; 'video/webm' sem codecs no fim (o Chromium escolhe o
     vp8). O CEF do FiveM (Chromium 103) grava vp8 e vp9 com opus; mp4/h264 não (o MediaRecorder só o tem a partir do 126 e o
     CEF não traz os codecs proprietários). */
  const videoMime = (audio, codec) => {
    const order = codec === 'vp9' ? ['vp9', 'vp8'] : ['vp8', 'vp9'];
    return order.map(c => 'video/webm;codecs=' + c + (audio ? ',opus' : '')).concat(['video/webm']).find(isType) || '';
  };
  const audioMime = () => AUDIO.find(isType) || '';
  const canVideo = () => { try { return typeof MediaRecorder === 'function' && typeof HTMLCanvasElement.prototype.captureStream === 'function'; } catch (e) { return false; } };
  const canAudio = () => { try { return !!(navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function' && typeof window.MediaRecorder === 'function'); } catch (e) { return false; } };
  function codecs() {
    const L = ['video/webm;codecs=vp8,opus', 'video/webm;codecs=vp8', 'video/webm;codecs=vp9,opus', 'video/webm;codecs=vp9', 'video/webm;codecs=h264', 'video/mp4', 'audio/webm;codecs=opus', 'audio/ogg;codecs=opus', 'audio/mp4'];
    const short = { 'video/webm;codecs=vp8,opus': 'vp8+opus', 'video/webm;codecs=vp8': 'vp8', 'video/webm;codecs=vp9,opus': 'vp9+opus', 'video/webm;codecs=vp9': 'vp9', 'video/webm;codecs=h264': 'h264', 'video/mp4': 'mp4', 'audio/webm;codecs=opus': 'a-opus', 'audio/ogg;codecs=opus': 'a-ogg', 'audio/mp4': 'a-mp4' };
    return L.map(t => short[t] + '=' + (isType(t) ? 'y' : 'n')).join(',');
  }

  /* ---------- microfone ---------- */
  const MIC_TEXT = {
    unsupported: 'Este cliente do jogo não permite gravar som (sem microfone na página do telemóvel).',
    phone: 'O acesso ao microfone está desligado para esta app em Definições › Privacidade.',
    denied: 'O FiveM não deu o microfone: aceita o pedido que aparece no canto do ecrã do jogo ou ativa o microfone do Windows para aplicações.',
    timeout: 'O pedido de microfone não foi respondido. Procura a caixa do FiveM no canto do ecrã do jogo e aceita.',
    nomic: 'Não foi encontrado nenhum microfone no Windows.',
    busy: 'O microfone está a ser usado por outra aplicação.',
    error: 'O microfone não está disponível.',
  };
  const micText = code => T(MIC_TEXT[code] || MIC_TEXT.error);
  function micCode(e) {
    const n = e && e.name;
    if (n === 'TimeoutError') return 'timeout';
    if (n === 'NotAllowedError' || n === 'PermissionDeniedError' || n === 'SecurityError') return 'denied';
    if (n === 'NotFoundError' || n === 'DevicesNotFoundError' || n === 'OverconstrainedError') return 'nomic';
    if (n === 'NotReadableError' || n === 'TrackStartError' || n === 'AbortError') return 'busy';
    return 'error';
  }
  /* opts: { timeout (ms), perm (false = não perguntar ao telemóvel), raw (sem filtros de voz) } → { stream } | { error, text } */
  async function getMic(app, opts = {}) {
    if (!canAudio()) return { error: 'unsupported', text: micText('unsupported') };
    if (opts.perm !== false && window.Perm && Perm.request) {
      let ok = false; try { ok = await Perm.request(app || 'camera', 'mic'); } catch (e) { ok = false; }
      if (!ok) return { error: 'phone', text: micText('phone') };
    }
    let gum, late = false;
    const c = opts.raw ? { echoCancellation: false, noiseSuppression: false, autoGainControl: false } : { echoCancellation: true, noiseSuppression: true, autoGainControl: true };
    try { gum = navigator.mediaDevices.getUserMedia({ audio: c, video: false }); } catch (e) { return { error: micCode(e), text: micText(micCode(e)) }; }
    /* um pedido que só responde DEPOIS do prazo larga logo o microfone */
    Promise.resolve(gum).then(st => { if (late) { try { st.getTracks().forEach(t => t.stop()); } catch (e) {} } }, () => {});
    try {
      const st = await Promise.race([gum, sleep(opts.timeout || 9000).then(() => { throw Object.assign(new Error('timeout'), { name: 'TimeoutError' }); })]);
      if (!st || !st.getAudioTracks || !st.getAudioTracks().length) { late = true; return { error: 'nomic', text: micText('nomic') }; }
      return { stream: st };
    } catch (e) { late = true; const code = micCode(e); return { error: code, text: micText(code) }; }
  }
  const stopStream = st => { try { st && st.getTracks().forEach(t => { try { t.stop(); } catch (e) {} }); } catch (e) {} };

  /* ---------- ritmo do envio (balde de fichas único) ---------- */
  const pace = { bps: 58982, peak: 176947, tokens: 176947, t: 0 };
  function setPace(u) {
    if (!u) return;
    const bps = num(u.bps, pace.bps, 4000, 5e7), peak = num(u.peak, pace.peak, 8000, 2e8);
    if (bps === pace.bps && peak === pace.peak) return;
    pace.bps = bps; pace.peak = peak; pace.tokens = Math.min(pace.tokens, peak);
  }
  /* espera até poder mandar n bytes: nunca mais do que `bps` por segundo depois do pico (o pico nunca passa `peak`) */
  async function take(n) {
    n = Math.min(n, pace.peak);
    for (let guard = 0; guard < 600; guard++) {
      const now = performance.now();
      if (pace.t) pace.tokens = Math.min(pace.peak, pace.tokens + (now - pace.t) * pace.bps / 1000);
      pace.t = now;
      if (pace.tokens >= n) { pace.tokens -= n; return; }
      await sleep(Math.max(20, Math.ceil((n - pace.tokens) * 1000 / pace.bps)));
    }
  }
  /* RPC com prazo e repetição do mesmo pedaço (o servidor aceita a repetição do último: `dup`) */
  async function rpcTry(name, data, tries = 3) {
    let r = null;
    for (let k = 0; k < tries; k++) {
      r = await Promise.race([Bridge.rpcRaw(name, data), sleep(15000).then(() => ({ error: 'timeout' }))]);
      if (r && (r.error === 'ratelimit' || r.error === 'timeout')) { await sleep(700 * (k + 1)); continue; }
      return r;
    }
    return r;
  }
  /* envio genérico aos bocados: begin → upload (por ordem, ao ritmo) → finish. Devolve a resposta do finish ou { error }
     o = { begin: [nome, dados], upload: nome, finish: [nome, dados extra], dataUrl, onProgress, cancel: () => bool } */
  async function upload(o) {
    const b = await rpcTry(o.begin[0], o.begin[1], 2);
    const id = b && Math.floor(+b.id);
    if (!b || b.error || !(id > 0)) return { error: (b && b.error) || 'rpc', info: b };
    if (b.upload) setPace(b.upload);
    const chunk = clamp(Math.floor(+b.chunk) || 48000, 1024, 64000), s = o.dataUrl, total = Math.ceil(s.length / chunk);
    if (total > 400) return { error: 'toolarge' };
    for (let i = 1; i <= total; i++) {
      if (o.cancel && o.cancel()) { if (o.cancelRpc) Bridge.rpcRaw(o.cancelRpc, { id }); return { error: 'cancelled' }; }
      const part = s.slice((i - 1) * chunk, i * chunk);
      await take(part.length + 160);
      const r = await rpcTry(o.upload, { id, i, total, data: part });
      if (!r || r.error) return { error: (r && r.error) || 'rpc', at: i };
      if (o.onProgress) { try { o.onProgress(i / total); } catch (e) {} }
    }
    const f = await rpcTry(o.finish[0], Object.assign({ id }, o.finish[1] || {}), 2);
    if (!f || f.error) return { error: (f && f.error) || 'rpc' };
    return Object.assign({ id }, f);
  }

  /* ---------- Blob ⇄ data URL ---------- */
  function blobToDataURL(blob, mime) {
    return new Promise((res, rej) => { const fr = new FileReader(); fr.onload = () => { const s = String(fr.result || ''); const i = s.indexOf(','); if (i < 0) { rej(new Error('read')); return; } res('data:' + (mime || (blob.type || '').split(';')[0] || 'application/octet-stream') + ';base64,' + s.slice(i + 1)); }; fr.onerror = () => rej(fr.error || new Error('read')); fr.readAsDataURL(blob); });
  }
  /* aos bocados de 1 M caracteres (múltiplos de 4): um vídeo de 4 MB não passa pelo atob de uma vez */
  function dataURLToBlob(u) {
    const i = u.indexOf(','); if (!/^data:/i.test(u) || i < 0) return null;
    const head = u.slice(5, i), type = head.replace(/;base64$/i, '').split(';')[0];
    if (!/;base64$/i.test(head)) return null;
    const parts = [], STEP = 1 << 20;
    for (let p = i + 1; p < u.length; p += STEP) {
      const bin = atob(u.slice(p, Math.min(u.length, p + STEP)).replace(/\s+/g, ''));
      const arr = new Uint8Array(bin.length); for (let k = 0; k < bin.length; k++) arr[k] = bin.charCodeAt(k);
      parts.push(arr);
    }
    return new Blob(parts, { type });
  }

  /* ---------- duração no webm (EBML) ----------
     O MediaRecorder do Chromium escreve um Segment de tamanho desconhecido, sem SeekHead nem Cues, e um Info SEM Duration.
     Acrescenta-se um elemento Duration (0x4489, float de 8 bytes) ao Info: nada mais refere posições, por isso crescer o
     Info não estraga nada. Qualquer coisa fora deste desenho: devolve o blob como estava (toca na mesma). */
  function vint(b, o, id) {
    if (o >= b.length) return null; const f = b[o]; let len = 1, m = 0x80;
    while (len <= 8 && !(f & m)) { len++; m >>= 1; }
    if (len > 8 || o + len > b.length) return null;
    if (id) { let v = 0; for (let k = 0; k < len; k++) v = v * 256 + b[o + k]; return { v, len }; }
    let v = f & (m - 1), ones = v === m - 1;
    for (let k = 1; k < len; k++) { v = v * 256 + b[o + k]; if (b[o + k] !== 0xff) ones = false; }
    return { v, len, unknown: ones };
  }
  function encSize(v, len) { if (v >= Math.pow(2, 7 * len) - 1) return null; const out = new Uint8Array(len); let x = v; for (let k = len - 1; k >= 0; k--) { out[k] = x % 256; x = Math.floor(x / 256); } out[0] |= (0x80 >> (len - 1)); return out; }
  async function fixWebmDuration(blob, ms) {
    try {
      if (!blob || !(ms > 0)) return blob;
      const headLen = Math.min(blob.size, 65536), h = new Uint8Array(await blob.slice(0, headLen).arrayBuffer());
      const e = vint(h, 0, true); if (!e || e.v !== 0x1A45DFA3) return blob;
      const es = vint(h, e.len); if (!es || es.unknown) return blob;
      let o = e.len + es.len + es.v;
      const s = vint(h, o, true); if (!s || s.v !== 0x18538067) return blob;
      const ss = vint(h, o + s.len); if (!ss) return blob;
      const seg = { at: o + s.len, len: ss.len, v: ss.v, unknown: ss.unknown };
      o = o + s.len + ss.len;
      for (let g = 0; g < 24 && o < h.length; g++) {
        const c = vint(h, o, true); if (!c) return blob;
        const cs = vint(h, o + c.len); if (!cs || cs.unknown) return blob;
        const at = o + c.len + cs.len;
        if (c.v === 0x114D9B74 || c.v === 0x1654AE6B || c.v === 0x1F43B675 || c.v === 0x1C53BB6B) return blob;   /* SeekHead/Tracks/Cluster/Cues antes do Info: desenho que não se conhece */
        if (c.v === 0x1549A966) {
          if (at + cs.v > h.length) return blob;
          let p = at, scale = 1000000, durAt = -1, durLen = 0; const end = at + cs.v;
          while (p < end) { const k = vint(h, p, true); if (!k) break; const ks = vint(h, p + k.len); if (!ks || ks.unknown) break; const kd = p + k.len + ks.len;
            if (k.v === 0x2AD7B1 && ks.v >= 1 && ks.v <= 8) { let v = 0; for (let q = 0; q < ks.v; q++) v = v * 256 + h[kd + q]; if (v > 0) scale = v; }
            if (k.v === 0x4489 && (ks.v === 4 || ks.v === 8)) { durAt = kd; durLen = ks.v; }
            p = kd + ks.v; }
          const value = ms * 1e6 / scale;
          if (durAt >= 0) { const out = h.slice(); const dv = new DataView(out.buffer); if (durLen === 8) dv.setFloat64(durAt, value); else dv.setFloat32(durAt, value); return new Blob([out, blob.slice(headLen)], { type: blob.type }); }
          const dur = new Uint8Array(11); dur[0] = 0x44; dur[1] = 0x89; dur[2] = 0x88; new DataView(dur.buffer).setFloat64(3, value);
          const sz = encSize(cs.v + 11, cs.len) || encSize(cs.v + 11, 8); if (!sz) return blob;
          const before = h.slice(0, o + c.len);
          if (!seg.unknown) { const sb = encSize(seg.v + 11 + (sz.length - cs.len), seg.len); if (!sb) return blob; before.set(sb, seg.at); }
          return new Blob([before, sz, h.slice(at, end), dur, h.slice(end), blob.slice(headLen)], { type: blob.type });
        }
        o = at + cs.v;
      }
      return blob;
    } catch (err) { return blob; }
  }
  /* lê a duração escrita (para os testes e o diagnóstico): ms ou null */
  async function webmDuration(blob) {
    try { const h = new Uint8Array(await blob.slice(0, Math.min(blob.size, 65536)).arrayBuffer());
      for (let i = 0; i < h.length - 11; i++) if (h[i] === 0x44 && h[i + 1] === 0x89 && h[i + 2] === 0x88) { let scale = 1000000; for (let j = 0; j < h.length - 6; j++) if (h[j] === 0x2A && h[j + 1] === 0xD7 && h[j + 2] === 0xB1) { const l = h[j + 3] & 0x7f; let v = 0; for (let q = 0; q < l && q < 8; q++) v = v * 256 + h[j + 4 + q]; if (v > 0) scale = v; break; }
        return new DataView(h.buffer, h.byteOffset).getFloat64(i + 3) * scale / 1e6; }
    } catch (e) {}
    return null;
  }

  /* ---------- diagnóstico (/rectest) ---------- */
  function synthCanvas(w, h) { const c = document.createElement('canvas'); c.width = w; c.height = h; const x = c.getContext('2d'); let t = 0;
    return { canvas: c, draw() { t++; const g = x.createLinearGradient(0, 0, w, h); g.addColorStop(0, `hsl(${(t * 7) % 360},70%,55%)`); g.addColorStop(1, `hsl(${(t * 7 + 140) % 360},65%,30%)`); x.fillStyle = g; x.fillRect(0, 0, w, h);
      x.fillStyle = 'rgba(255,255,255,.6)'; for (let i = 0; i < 40; i++) x.fillRect((i * 37 + t * 9) % w, (i * 53 + t * 5) % h, 18, 18); } }; }
  /* REC3: o teste grava como a Câmara: altura e fps da qualidade em uso, o codec dela e um frame pedido por desenho
     (captureStream(0) + requestFrame; sem requestFrame cai no captureStream(fps) de antes e a linha diz "timed") */
  async function testRecord(src, L, ms) {
    const hgt = Math.min(1080, L.video.height || 640), w = Math.round(hgt * 3 / 4) + (Math.round(hgt * 3 / 4) % 2), rc = document.createElement('canvas'); rc.width = w; rc.height = hgt; const ctx = rc.getContext('2d', { alpha: false });
    try { ctx.imageSmoothingEnabled = true; ctx.imageSmoothingQuality = 'high'; } catch (e) {}
    const out = { ok: false, size: w + 'x' + hgt };
    let stream, manual = false; try { stream = rc.captureStream(0); const tr = stream.getVideoTracks()[0]; manual = !!(tr && typeof tr.requestFrame === 'function'); if (!manual) { stopStream(stream); stream = rc.captureStream(L.video.fps); } } catch (e) { out.err = 'captureStream:' + (e && e.name); return out; }
    out.pump = manual ? 'requestFrame' : 'timed';
    const mime = videoMime(false, L.video.codec); let mr;
    try { mr = new MediaRecorder(stream, Object.assign({ videoBitsPerSecond: L.video.videoBps }, mime ? { mimeType: mime } : {})); } catch (e) { out.err = 'MediaRecorder:' + (e && e.name); stopStream(stream); return out; }
    let bytes = 0, chunks = 0, first = 0, frames = 0; const t0 = performance.now(); const parts = [];
    mr.ondataavailable = ev => { if (ev.data && ev.data.size) { bytes += ev.data.size; chunks++; parts.push(ev.data); if (!first) first = Math.round(performance.now() - t0); } };
    const track = stream.getVideoTracks()[0];
    const draw = () => { try { src(ctx, w, hgt); frames++; if (manual) track.requestFrame(); } catch (e) {} };
    draw(); const iv = setInterval(draw, Math.round(1000 / L.video.fps));
    try { mr.start(500); } catch (e) { clearInterval(iv); stopStream(stream); out.err = 'start:' + (e && e.name); return out; }
    await sleep(ms);
    await new Promise(r => { mr.onstop = r; setTimeout(r, 2500); try { mr.stop(); } catch (e) { r(); } });
    clearInterval(iv); stopStream(stream);
    const sec = (performance.now() - t0) / 1000;
    const blob = new Blob(parts, { type: 'video/webm' }), fixed = await fixWebmDuration(blob, ms);
    Object.assign(out, { ok: bytes > 0, bytes, chunks, first, frames, fps: Math.round(frames / Math.max(.5, sec)), bps: Math.round(bytes / Math.max(.5, sec)), mime: mime || '(default)', durFixed: !!(await webmDuration(fixed)) });
    return out;
  }
  async function diag(d) {
    const parts = ['rectest'];
    try {
      const L = await limits(true);
      parts.push(`device=${L.device || 'none'}(${L.os || '?'}${L.model ? ',' + L.model : ''})${L.local ? ' LOCAL-FALLBACK(no server answer)' : ''}`);
      parts.push(`video=${L.video.seconds}s/${L.video.maxChars}ch v${Math.round(L.video.videoBps / 1000)}k+a${L.video.audio ? Math.round(L.video.audioBps / 1000) + 'k' : 'off'} ${L.video.height}p@${L.video.fps} ${L.video.codec || 'vp8'} quality=${L.video.quality || '?'} perm=${L.enabled === false ? 'disabled' : L.allowed === false ? 'denied(' + (L.deny || '?') + ')' : 'ok'}`);
      parts.push(`audio=${L.audio.seconds}s/${L.audio.maxChars}ch ${Math.round(L.audio.bps / 1000)}k`);
      const u = L.upload || {}; parts.push(`upload=${Math.round(pace.bps)}B/s peak${Math.round(pace.peak)} (server rate ${u.rate || '?'} burst ${u.burst || '?'})`);
      const st = L.storage || {}; if (st.maxVideos != null) parts.push(`store=${st.store || 'db'} videos ${st.videos == null ? '?' : st.videos}/${st.maxVideos || 'inf'}`);
      parts.push('codecs=' + codecs() + ` captureStream=${canVideo() ? 'y' : 'n'}`);
      /* vista do jogo: um visor de teste, como o /camtest, com 12 frames ao longo de ~1 s */
      let src = null, gv = null, cv = null, gvInfo = 'gameview=';
      try {
        if (window.GameRender && GameRender.available()) {
          cv = document.createElement('canvas'); cv.width = 480; cv.height = 640; cv.style.cssText = 'position:absolute;left:-9999px;top:0'; document.body.appendChild(cv);
          gv = GameRender.create(cv, { aspect: 3 / 4, autoResize: false, quality: .6 });
          if (gv.live) {
            let black = 0, ph = 0; for (let i = 0; i < 12; i++) { gv.renderOnce(); if (gv.isPlaceholder && gv.isPlaceholder()) ph++; else if (gv.isBlankRows ? gv.isBlankRows() : gv.isBlack()) black++; await sleep(80); }
            gvInfo += `live ${gv.canvas.width}x${gv.canvas.height} black ${black}/12 waiting ${ph}/12`;
            const c = gv.canvas; src = (ctx, w, h) => { gv.renderOnce(); ctx.drawImage(c, 0, 0, w, h); };
          } else gvInfo += 'NOT-LIVE(webgl)';
        } else gvInfo += inFiveM() ? 'NOT-AVAILABLE(webgl)' : 'browser(synthetic)';
      } catch (e) { gvInfo += 'error:' + (e && e.message); }
      parts.push(gvInfo);
      if (!src) { const s = synthCanvas(480, 640); src = (ctx, w, h) => { s.draw(); ctx.drawImage(s.canvas, 0, 0, w, h); }; }
      if (canVideo()) { const r = await testRecord(src, L, 2000);
        parts.push(r.ok ? `rec2s=${r.size} ${r.bytes}B ${r.bps}B/s (target ${Math.round(L.video.videoBps / 8)}) ${r.fps}fps ${r.pump} chunks ${r.chunks} first ${r.first}ms ${r.mime} durfix=${r.durFixed ? 'y' : 'n'}` : `rec2s=FAIL ${r.err || 'no data (0 bytes)'}`); }
      else parts.push('rec2s=NO-MediaRecorder/captureStream');
      try { gv && gv.destroy(); } catch (e) {} try { cv && cv.remove(); } catch (e) {}
      /* microfone: o estado guardado no telemóvel e, sem "nomic", um teste real de 1 s com o nível */
      const pc = window.Perm && Perm.get ? Perm.get('voicememos', 'mic') : undefined, pv = window.Perm && Perm.get ? Perm.get('camera', 'mic') : undefined;
      let mic = `mic=api ${canAudio() ? 'y' : 'n'} perm(rec ${pc === undefined ? 'unset' : pc ? 'allow' : 'deny'}, cam ${pv === undefined ? 'unset' : pv ? 'allow' : 'deny'})`;
      if (d && d.mic && canAudio()) {
        const m = await getMic('voicememos', { perm: false, timeout: 8000, raw: true });
        if (m.stream) {
          let rms = 0; try { const AC = window.AudioContext || window.webkitAudioContext, ac = new AC(), an = ac.createAnalyser(); an.fftSize = 1024; ac.createMediaStreamSource(m.stream).connect(an); const buf = new Uint8Array(1024);
            for (let i = 0; i < 10; i++) { await sleep(100); an.getByteTimeDomainData(buf); let s = 0; for (let k = 0; k < buf.length; k++) { const x = (buf[k] - 128) / 128; s += x * x; } rms = Math.max(rms, Math.sqrt(s / buf.length)); }
            ac.close(); } catch (e) {}
          const tr = m.stream.getAudioTracks()[0]; const set = tr && tr.getSettings ? tr.getSettings() : {};
          mic += ` gum=ok ${set.sampleRate || '?'}Hz peakRms ${rms.toFixed(3)}`; stopStream(m.stream);
        } else mic += ` gum=${m.error}`;
      } else if (d && !d.mic) mic += ' gum=skipped';
      parts.push(mic);
    } catch (e) { parts.push('error ' + (e && e.message)); }
    return parts.join(' | ');
  }
  try { Bridge.on('rec:diag', d => { diag(d || {}).then(line => Bridge.call('recDiag', { line })); }); } catch (e) {}

  return { budget, charsFor, PRESETS, limits, fallback, setPace, take, upload, rpcTry, getMic, micText, stopStream, videoMime, audioMime, canVideo, canAudio, codecs,
    blobToDataURL, dataURLToBlob, fixWebmDuration, webmDuration, diag, get pace() { return Object.assign({}, pace); }, SAFETY };
})();

/* ================= servidor de mentira do browser (LocalDB): limites por aparelho e envio dos vídeos ================= */
if (window.LocalDB && LocalDB.register) (() => {
  /* o mesmo config_recording.lua de origem (só para o harness): o aparelho vem da moldura do telemóvel */
  const MODELS = { pearfold: [60, 600], pear18: [45, 300], s26: [45, 300], novaflip: [30, 180] };
  const famOf = () => { const f = String((window.System && System.frame) || ''); const forced = (() => { try { return localStorage.getItem('apx:recModel'); } catch (e) { return null; } })();
    if (forced) return forced; if (/^fold-/.test(f)) return 'pearfold'; if (/^flip-/.test(f)) return 'novaflip'; if (/^s26-/.test(f)) return 's26'; if (f) return 'pear18'; return null; };
  /* testes do harness: localStorage 'apx:recOverride' = {"video":4,"audio":5} encurta os limites (gravações completas em segundos);
     REC3: 'apx:recQuality' = 'standard' | 'high' | 'ultra' (por omissão 'high', como o config de origem) e 'apx:recPerm' =
     {"allowed":false,"deny":"job"} (ou {"enabled":false}) para ver o obturador a explicar porque não grava */
  const ovr = () => { try { return JSON.parse(localStorage.getItem('apx:recOverride') || 'null') || {}; } catch (e) { return {}; } };
  const lsGet = k => { try { return localStorage.getItem(k); } catch (e) { return null; } };
  const perm = () => { try { return JSON.parse(lsGet('apx:recPerm') || 'null') || {}; } catch (e) { return {}; } };
  /* a MESMA conta do server/recording.lua (RecordingLimits): débito da predefinição → orçamento por aparelho → teto de 12 MB → budget */
  const limitsMock = () => { const fam = famOf(), m = (MODELS[fam] || [15, 120]).slice(), o = ovr(); if (o.video > 0) m[0] = o.video; if (o.audio > 0) m[1] = o.audio;
    const qn = RecCore.PRESETS[lsGet('apx:recQuality')] ? lsGet('apx:recQuality') : 'high', Q = RecCore.PRESETS[qn];
    const vs = m[0], vc = Math.min(12e6, RecCore.charsFor(vs, Q.videoKbps * 1000, Q.audioBps)), b = RecCore.budget(vs, vc, Q.audioBps, 150000, Math.max(2500000, Q.videoKbps * 1600)), as = m[1];
    const vids = LocalDB.T('photos').all().filter(p => p.video), pm = perm();
    return { enabled: pm.enabled !== false, allowed: pm.allowed !== false, deny: pm.allowed === false ? (pm.deny || 'job') : null,
      device: fam ? fam + '_mock' : false, os: (window.System && System.os) || 'ios', model: fam, source: { video: fam ? 'model' : 'default', audio: fam ? 'model' : 'default' },
      video: { seconds: b.seconds, maxChars: vc, videoBps: b.videoBps, audioBps: Q.audioBps, audio: true, height: Q.height, fps: Q.fps, codec: Q.codec, quality: qn },
      audio: { seconds: as, maxChars: as * 6400, bps: 32000 },
      upload: { bps: 2000000, peak: 4000000, chunk: 48000, rate: 131072, burst: 393216, share: .45 },
      storage: { maxVideos: 20, maxChars: 150e6, keepDays: 0, videos: vids.length, chars: vids.reduce((a, p) => a + (p.url ? p.url.length : 0), 0), store: 'db' } }; };
  LocalDB.register('recording.limits', () => limitsMock());
  window.RecCoreMock = { limits: limitsMock };   /* o mock do Gravador (voicememos.js) lê daqui o limite de áudio do aparelho */
  const ups = {}; let seq = 0;
  LocalDB.register('recording.video.begin', d => { const L = limitsMock(); if (!L.enabled) return { error: 'disabled' }; if (!L.allowed) return { error: 'noperm', deny: L.deny };
    const mime = String(d.mime || '').split(';')[0].toLowerCase(); if (mime !== 'video/webm') return { error: 'badmime' };
    const size = Math.floor(+d.size || 0), ms = +d.duration; if (!(size > 0)) return { error: 'badsize' }; if (size > L.video.maxChars + 32) return { error: 'toolarge', maxChars: L.video.maxChars };
    if (!(ms >= 0)) return { error: 'badduration' }; if (ms > L.video.seconds * 1000 + 1500) return { error: 'toolong', maxSec: L.video.seconds }; if (ms < 500) return { error: 'tooshort' };
    if (L.storage.videos >= L.storage.maxVideos) return { error: 'limit', max: L.storage.maxVideos };
    const id = ++seq; ups[id] = { size, ms, next: 1, len: 0, parts: [], total: 0 }; return { id, chunk: 48000, total: Math.ceil(size / 48000), upload: L.upload }; });
  LocalDB.register('recording.video.upload', d => { const st = ups[+d.id]; if (!st) return { error: 'notfound' }; const i = +d.i, total = +d.total, part = String(d.data || '');
    if (!part || i < 1 || i > total || total > 400) return { error: 'badchunk' }; if (i === st.next - 1 && part.length === st.last) return { ok: true, i, dup: true }; if (i !== st.next) return { error: 'order', expected: st.next };
    if (part.length > 48000) return { error: 'toolarge' }; st.parts[i] = part; st.len += part.length; st.last = part.length; st.next = i + 1; st.total = total; if (st.len > st.size) { delete ups[+d.id]; return { error: 'toolarge' }; } return { ok: true, i }; });
  LocalDB.register('recording.video.finish', d => { const st = ups[+d.id]; if (!st) return { error: 'notfound' }; if (st.next - 1 !== st.total) return { error: 'missing' }; if (st.len !== st.size) return { error: 'badsize' };
    let data = st.parts.slice(1).join(''); delete ups[+d.id]; const c = data.indexOf(','); const b64 = c >= 0 ? data.slice(c + 1) : data; if (b64.slice(0, 4) !== 'GkXf' || b64.length % 4) return { error: 'baddata' };
    data = 'data:video/webm;base64,' + b64; const poster = typeof d.poster === 'string' && d.poster.length <= 16000 && /^data:image\/(jpeg|png|webp);base64,/.test(d.poster) ? d.poster : null;
    const row = LocalDB.T('photos').insert({ owner: 'DEV0000', url: data, seed: 300, favorite: false, video: true, duration: Math.max(1, Math.round(st.ms / 1000)), poster, created: Date.now() });
    return { ok: true, photo: Object.assign({}, row, { url: null, len: data.length, hasPoster: !!poster, durationMs: st.ms }) }; });
  LocalDB.register('recording.video.cancel', d => { delete ups[+d.id]; return { ok: true }; });
})();
