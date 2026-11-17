/* ============================================================
   VERA POR VOZ - palavra de ativação "Vera" + comandos falados (2026-09-18)
   · O reconhecimento de voz do Chrome NÃO existe no CEF do FiveM: a frase é gravada aqui (WAV 16 kHz mono,
     só quando há voz) e transcrita no SERVIDOR pelo Gemini (server/ai.lua → RPC ai.stt, resposta por push).
   · Escuta de fundo (modo 'wake'): ligada com System.state.veraWake (Definições › Vera) e Config.AI.voice;
     por omissão só com o telemóvel ABERTO (whenClosed no config para ouvir também guardado).
     "Vera" sozinho abre-a e a frase seguinte (6 s) é o pedido; "Olá Vera, abre os mapas" abre e executa logo.
   · Botão do microfone da Vera (modo 'command'): grava UMA frase e executa-a - antes só mostrava "A ouvir…".
   · Detetor de voz por energia com chão de ruído adaptativo; ≥ 0,4 s de fala; corta aos 3,5 s ou a 0,65 s de
     silêncio; 0,3 s de pré-gravação para não comer a primeira sílaba. Cada frase = 1 pedido à API (há teto
     por minuto no servidor), por isso nada é enviado sem voz.
   window.VeraVoice = { init, listenOnce(), refresh(), get active }
   ============================================================ */
window.VeraVoice = (() => {
  /* MAX_S 4,8 s: 16 kHz × 16 bits × 4,8 s = 154 KB → 205 KB em base64, abaixo do teto do servidor (220 000) e do evento de rede
     (~260 KB). Os 3,5 s antigos cortavam pedidos normais ("Ei Vera, manda uma mensagem ao Rui a dizer que chego às dez"). */
  const RATE = 16000, MAX_S = 4.8, MIN_S = .4, SIL_S = .65, PRE_S = .3;
  /* escuta de fundo: ≥ 0,6 s de frase com ≥ 0,35 s de voz a sério e limiar absoluto 0,02 (era 0,7 / 0,45 / 0,026 - demasiado exigente
     para microfones fracos: "não deteta"). Quem protege contra ruído é o servidor (v) + a regra do nome (heard). */
  const WAKE_MIN_S = .6, WAKE_TALK_S = .35, THR_WAKE = .02, THR_ONCE = .016, FOLLOW_MS = 8000;
  let stream = null, ctx = null, node = null, src = null, on = false, starting = false;
  let mode = 'wake', followUntil = 0, onceCb = null, busy = false;
  let floor = .008, speaking = false, voiced = 0, silent = 0, chunks = [], pre = [], preLen = 0, seq = 0, spokeAt = 0;
  /* FRASE DITA ENQUANTO A ANTERIOR AINDA ESTÁ A SER TRANSCRITA (2026-09-20): antes era deitada fora - "Ei Vera" ia para o
     servidor (1-2 s) e o pedido dito logo a seguir perdia-se; a Vera ficava em "Diz o que queres…" sem nada acontecer.
     Agora fica em espera e segue assim que a resposta chega (se tiver menos de 10 s). */
  let queued = null;
  /* pausas de envio: 'limit' (teto por minuto) 15 s, erro de rede/modelo 8 s, quota diária 20 min (era "até recarregar") */
  let pauseUntil = 0, quotaUntil = 0, quotaT = null;
  /* ALT-TAB (queixa 2026-09-18): ao voltar ao jogo o Windows religa o microfone e chega uma rajada de ruído/estalidos
     (e, às vezes, áudio acumulado) - isso era mandado ao servidor e a Vera ligava-se sozinha. Depois de QUALQUER
     interrupção (foco perdido/recuperado, buraco nos frames de áudio, AudioContext retomado, arranque) o microfone é
     ignorado durante uns segundos enquanto o chão de ruído se volta a calibrar. `talk` = tempo REAL de voz na frase. */
  let muteUntil = 0, lastFrame = 0, talk = 0, epoch = 0;   /* epoch: sobe a cada interrupção - respostas de frases gravadas ANTES dela são ignoradas */
  const resync = ms => { epoch++; speaking = false; voiced = 0; silent = 0; talk = 0; chunks = []; pre = []; preLen = 0; queued = null; muteUntil = Math.max(muteUntil, Date.now() + ms); };
  const pending = new Map(), sentEpoch = new Map(), sentAt = new Map();   /* sentAt: quando a frase COMEÇOU (a janela "diz o que queres" mede-se por aí) */
  /* ESTADO PARA A JANELA DA VERA (2026-09-18): 'off' | 'listen' | 'speech' | 'think' | 'nomic', com o nível do microfone.
     Só se emite com a Vera aberta (Bridge 'vera:voice'), no máximo ~12×/s - é o que mostra se a voz está a ser apanhada. */
  let vst = 'off', lastEmit = 0;
  const quotaOff = () => Date.now() < quotaUntil;
  const veraOpen = () => !!(window.Vera && Vera.isOpen && Vera.isOpen());
  const emit = (st, lvl) => { const now = Date.now(); if (st === vst && now - lastEmit < 85) return; vst = st; lastEmit = now; if (veraOpen()) Bridge.emit('vera:voice', { st, lvl: Math.max(0, Math.min(1, lvl || 0)), once: !!onceCb }); };

  const cfg = () => (window.System && System.config && System.config.ai) || {};
  const phoneOpen = () => !(Bridge.inFiveM && document.body.classList.contains('hidden'));
  const wanted = () => {
    const c = cfg();
    if (c.enabled === false || c.wake === false) return false;
    if (!Bridge.inFiveM || quotaOff()) return false;   /* browser/harness: sem escuta de fundo (o pedido de microfone ficava por cima de tudo); o botão da Vera continua a funcionar */
    if (!window.System || !System.state || System.state.veraWake === false || System.state.vera === false) return false;
    if (System.locked && !phoneOpen()) return !!c.wakeClosed;
    return phoneOpen() || !!c.wakeClosed;
  };
  /* normalizar SEM perder alfabetos não latinos (russo, chinês, japonês, coreano): só se tiram acentos e pontuação */
  const norm = s => String(s || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/[^\p{L}\p{N}\s']/gu, ' ').replace(/\s+/g, ' ').trim();
  /* ---------- SÓ RESPONDE QUANDO A MENCIONAM (2026-09-18) ----------
     "Hey Vera" (en), "Ei Vera / Olá Vera / E aí Vera" (pt), "Oye Vera" (es), "Dis Vera" (fr), "Hallo Vera" (de), "Ehi Vera" (it)…
     Vale a saudação de QUALQUER das 15 línguas (há quem misture) + "Vera", ou "Vera" como PRIMEIRA palavra da frase.
     "Vera" a meio de uma conversa ("a Vera disse…") não a acorda. O servidor escreve sempre o nome como "Vera". */
  const GREET = {
    pt: ['ei', 'eh', 'olá', 'ola', 'oi', 'e aí', 'e ai', 'eai', 'ó', 'oh', 'ouve'], en: ['hey', 'hi', 'hello', 'ok', 'okay', 'yo'],
    es: ['oye', 'hola', 'ey', 'eh'], fr: ['dis', 'salut', 'hé', 'he', 'bonjour', 'allo'], de: ['hallo', 'hey', 'he', 'hi'],
    it: ['ehi', 'ciao', 'ei', 'senti'], nl: ['hé', 'hoi', 'hallo', 'hey'], tr: ['hey', 'selam', 'merhaba'], pl: ['hej', 'cześć', 'halo'],
    sv: ['hej', 'hallå', 'tja'], ru: ['эй', 'привет', 'слушай'], 'zh-Hans': ['嘿', '你好', '喂', '哈喽'], 'zh-Hant': ['嘿', '你好', '喂', '哈囉'],
    ja: ['ねえ', 'ヘイ', 'やあ', 'おい', 'こんにちは'], ko: ['헤이', '안녕', '야', '저기'],
  };
  const esc = s => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const GREETS = [...new Set(Object.values(GREET).flat().map(norm))].sort((a, b) => b.length - a.length).map(esc).join('|');
  const WAKE = new RegExp('^(?:(?:' + GREETS + ')\\s*)?vera(?![\\p{L}\\p{N}])', 'u');
  const wakeOf = s => { const n = norm(s); const m = WAKE.exec(n); return m ? n.slice(m[0].length).replace(/^[\s,]+/, '').trim() : null; };
  const lang = () => (window.L && L.code) || (window.System && System.state && System.state.lang) || 'pt';
  /* CAPTAÇÃO POR AudioWorklet (26 out): o ScriptProcessorNode está obsoleto e o Chromium escrevia "The ScriptProcessorNode
     is deprecated" na F8 a cada arranque da escuta (visto na consola de um cliente). O processador junta os blocos de 128
     amostras em frames de 4096 - o mesmo tamanho de sempre, de que o frame() depende para o tempo de cada pedaço - e manda-os
     por mensagem. Vem de um Blob (sem ficheiro novo no manifest); cada AudioContext carrega o módulo de novo. Sem
     AudioWorklet, ou se o módulo não carregar, fica o ScriptProcessor de antes: nada deixa de funcionar. */
  const TAP = 'class ApxVeraTap extends AudioWorkletProcessor{constructor(){super();this.b=new Float32Array(4096);this.n=0}'
    + 'process(i){const c=i[0]&&i[0][0];if(c){for(let k=0;k<c.length;k++){this.b[this.n++]=c[k];if(this.n===4096){this.port.postMessage(this.b,[this.b.buffer]);this.b=new Float32Array(4096);this.n=0}}}return true}}'
    + "registerProcessor('apx-vera-tap',ApxVeraTap)";
  let tapUrl = null;
  async function tapNode(c) {
    if (c.audioWorklet && window.AudioWorkletNode) {
      try {
        if (!tapUrl) tapUrl = URL.createObjectURL(new Blob([TAP], { type: 'application/javascript' }));
        await c.audioWorklet.addModule(tapUrl);
        const n = new AudioWorkletNode(c, 'apx-vera-tap', { numberOfInputs: 1, numberOfOutputs: 1, channelCount: 1, channelCountMode: 'explicit' });
        n.port.onmessage = e => frame(e.data, c.sampleRate);
        return n;
      } catch (e) {}
    }
    const n = c.createScriptProcessor(4096, 1, 1);
    n.onaudioprocess = e => frame(e.inputBuffer.getChannelData(0), c.sampleRate);
    return n;
  }
  async function start() {
    if (on || starting) return; starting = true;
    try {
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) throw new Error('nomic');
      /* escuta de fundo com o microfone RECUSADO: não volta a perguntar nem a avisar a cada abertura (só o botão da Vera avisa) */
      if (mode === 'wake' && window.Perm && Perm.get && Perm.get('vera', 'mic') === false) throw new Error('quiet');
      if (window.Perm && Perm.request) { const ok = await Perm.request('vera', 'mic'); if (!ok) throw new Error('denied'); }
      stream = await navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true }, video: false });
      const myCtx = ctx = new (window.AudioContext || window.webkitAudioContext)();
      src = ctx.createMediaStreamSource(stream);
      const n = await tapNode(myCtx);
      /* o addModule é assíncrono: se a escuta parou entretanto (stop() fechou este contexto), este nó já não serve */
      if (ctx !== myCtx) { try { n.disconnect(); if (n.port) n.port.onmessage = null; } catch (e) {} throw new Error('quiet'); }
      node = n;
      ctx.onstatechange = () => resync(2500);   /* suspenso/retomado pelo sistema (ex.: dispositivo de áudio religado) */
      src.connect(node); node.connect(ctx.destination);
      on = true; lastFrame = 0; resync(mode === 'wake' ? 1500 : 250); emit('listen', 0);
    } catch (e) { stop(); if (e.message !== 'quiet') emit('nomic', 0); if (mode === 'command' && onceCb) { const cb = onceCb; onceCb = null; cb(null, e.message === 'denied' ? 'denied' : 'nomic'); } }
    starting = false;
  }
  function stop() {
    on = false; speaking = false; chunks = []; pre = []; preLen = 0;
    try { if (node) { node.disconnect(); node.onaudioprocess = null; if (node.port) node.port.onmessage = null; } } catch (e) {}
    try { if (src) src.disconnect(); } catch (e) {}
    try { if (stream) stream.getTracks().forEach(t => t.stop()); } catch (e) {}
    try { if (ctx) ctx.close(); } catch (e) {}
    node = src = stream = ctx = null;
    if (vst !== 'nomic') emit('off', 0);
  }
  /* liga/desliga a escuta de fundo conforme o estado (telemóvel aberto, definição, config) */
  function refresh() { if (onceCb || busy) return; if (wanted()) { mode = 'wake'; start(); } else stop(); }

  function frame(data, sr) {
    let sum = 0; for (let i = 0; i < data.length; i++) sum += data[i] * data[i];
    const rms = Math.sqrt(sum / data.length), dt = data.length / sr, now = Date.now();
    /* buraco entre frames (jogo minimizado/alt-tab, áudio parado): o que vier a seguir é lixo acumulado → recalibrar */
    if (lastFrame && now - lastFrame > dt * 1000 * 3 + 400) resync(2500);
    lastFrame = now;
    if (now < muteUntil) { floor = floor * .8 + Math.min(rms, .05) * .2; if (!busy) emit('listen', 0); return; }   /* a calibrar: aprende o ruído, não grava */
    /* escuta de fundo um pouco mais exigente do que o botão (cada frase gasta quota da API); o chão de ruído sobe o limiar em salas barulhentas */
    const thr = Math.max(onceCb ? THR_ONCE : THR_WAKE, floor * 3.2);
    if (!busy) emit(speaking ? 'speech' : 'listen', Math.min(1, rms / (thr * 2.5)));
    if (!speaking) {
      floor = floor * .96 + Math.min(rms, .05) * .04;     /* chão de ruído só aprende em silêncio */
      pre.push(new Float32Array(data)); preLen += dt; while (preLen > PRE_S && pre.length > 1) { preLen -= pre[0].length / sr; pre.shift(); }
      if (rms > thr) { voiced += dt; if (voiced >= .12) { speaking = true; spokeAt = now - Math.round(voiced * 1000); talk = voiced; chunks = pre.slice(); pre = []; preLen = 0; silent = 0; } } else voiced = 0;
      return;
    }
    chunks.push(new Float32Array(data));
    const len = chunks.reduce((a, c) => a + c.length, 0) / sr;
    if (rms > thr) { silent = 0; talk += dt; } else silent += dt;
    if (silent >= SIL_S || len >= MAX_S) {
      speaking = false; voiced = 0; const got = chunks, spoke = talk, at = spokeAt; chunks = []; talk = 0;
      /* escuta de fundo: além da duração, exige voz a sério (um estalido longo ou uma rajada não chega) */
      const worth = len - silent >= (onceCb ? MIN_S : WAKE_MIN_S) && (onceCb || spoke >= WAKE_TALK_S);
      if (!worth) return;
      if (now < pauseUntil && !onceCb) return;                  /* teto por minuto / API em baixo: não vale a pena insistir já */
      if (busy) { queued = { chunks: got, sr, at }; return; }   /* a anterior ainda no servidor: fica em espera (ver finish) */
      send(got, sr, at);
    }
  }

  /* PCM float → WAV 16 kHz 16 bits mono (reamostragem por média) → base64 */
  function wav(chunks, sr) {
    const n = chunks.reduce((a, c) => a + c.length, 0), all = new Float32Array(n); let o = 0; chunks.forEach(c => { all.set(c, o); o += c.length; });
    const k = sr / RATE, m = Math.floor(n / k), pcm = new Int16Array(m);
    for (let i = 0; i < m; i++) { const a = Math.floor(i * k), b = Math.min(n, Math.floor((i + 1) * k)); let s = 0; for (let j = a; j < b; j++) s += all[j]; const v = Math.max(-1, Math.min(1, s / Math.max(1, b - a))); pcm[i] = v < 0 ? v * 32768 : v * 32767; }
    const buf = new ArrayBuffer(44 + pcm.length * 2), dv = new DataView(buf), w = (p, s) => { for (let i = 0; i < s.length; i++) dv.setUint8(p + i, s.charCodeAt(i)); };
    w(0, 'RIFF'); dv.setUint32(4, 36 + pcm.length * 2, true); w(8, 'WAVE'); w(12, 'fmt '); dv.setUint32(16, 16, true); dv.setUint16(20, 1, true); dv.setUint16(22, 1, true);
    dv.setUint32(24, RATE, true); dv.setUint32(28, RATE * 2, true); dv.setUint16(32, 2, true); dv.setUint16(34, 16, true); w(36, 'data'); dv.setUint32(40, pcm.length * 2, true);
    new Int16Array(buf, 44).set(pcm);
    let bin = ''; const u8 = new Uint8Array(buf); for (let i = 0; i < u8.length; i += 0x8000) bin += String.fromCharCode.apply(null, u8.subarray(i, i + 0x8000));
    return btoa(bin);
  }

  /* erros do servidor que pedem uma pausa nos envios de fundo (o botão da Vera não é travado) */
  const backoff = err => { const now = Date.now(); if (err === 'quota') { quotaUntil = now + 20 * 60000; stop(); emit('quota', 0); clearTimeout(quotaT); quotaT = setTimeout(refresh, 20 * 60000 + 500); } else if (err === 'limit') pauseUntil = now + 15000; else if (err === 'http' || err === 'nomodel' || err === 'rpc' || err === 'timeout' || err === 'key') pauseUntil = now + 8000; };
  async function send(chunks, sr, at) {
    busy = true; const id = ++seq; const asOnce = mode === 'command'; emit('think', 0); sentEpoch.set(id, epoch); sentAt.set(id, at || Date.now());
    if (asOnce && window.Vera && Vera.isOpen && Vera.isOpen()) setStatus('A perceber…');
    let r = null; try { r = await Bridge.rpcRaw('ai.stt', { id, audio: wav(chunks, sr), lang: lang() }); } catch (e) { r = null; }
    if (!r || r.error) { const err = (r && r.error) || 'rpc'; backoff(err); finish(id, null, err); return; }
    pending.set(id, setTimeout(() => { backoff('timeout'); finish(id, null, 'timeout'); }, 12000));
  }
  /* r = { text (na língua falada), pt (em português) } | null */
  function finish(id, r, err) {
    const t = pending.get(id); if (t) { clearTimeout(t); pending.delete(id); } busy = false; emit(on ? 'listen' : 'off', 0);
    const stale = sentEpoch.has(id) && sentEpoch.get(id) !== epoch; sentEpoch.delete(id);
    const at = sentAt.get(id) || 0; sentAt.delete(id);
    /* a frase que ficou à espera segue agora (só se for recente e desta "época") */
    const q = queued; queued = null; const next = () => { if (q && Date.now() - q.at < 10000 && !busy && on && !stale) send(q.chunks, q.sr, q.at); };
    if (onceCb) { const cb = onceCb; onceCb = null; mode = 'wake'; cb(r ? (r.pt || r.text) : null, err); refresh(); next(); return; }
    if (stale || !r || !(r.text || r.pt)) { next(); return; }   /* gravada antes de um alt-tab/interrupção: não acorda a Vera */
    heard(r, at); next();
  }
  /* escuta de fundo: só reage a "Vera"; o que vem depois do nome é o pedido */
  /* `at` = quando a frase começou: a janela "Diz o que queres…" conta a partir daí (uma frase longa começada dentro da
     janela vale, mesmo que a transcrição chegue depois de ela fechar). */
  function heard(r, at) {
    if (typeof r === 'string') r = { text: r, pt: r };
    if ((at || Date.now()) < followUntil) { followUntil = 0; runVera(r.pt || r.text); return; }
    /* acorda pela frase ORIGINAL (a saudação é da língua falada); o pedido executa-se pela tradução em português */
    /* o servidor confirma em  que o nome foi MESMO dito (sem isto, ruído e conversa acordavam a Vera sozinha) */
    if (wakeOf(r.text) === null && wakeOf(r.pt) === null) return;
    const restPt = wakeOf(r.pt), rest = restPt !== null ? restPt : (wakeOf(r.text) || '');
    const words = rest.split(' ').filter(Boolean).length, hasCmd = words >= 2 || (words === 1 && !/^(ola|oi|hey|ei)$/.test(rest));
    /* Um "Vera" SOZINHO só vale confirmado pelo servidor (v); com um pedido a seguir ("Ei Vera, abre os mapas") a frase vale
       por si - ruído não produz um pedido inteiro, e o modelo era demasiado tímido a confirmar nomes com sotaque
       ("não deteta", 2026-09-20). */
    if (r.v === false && !hasCmd) return;
    if (!phoneOpen()) { try { Bridge.call('veraWake', {}); } catch (e) {} }
    setTimeout(() => {
      if (!window.Vera) return;
      if (!Vera.isOpen()) Vera.open({ noFocus: true });   /* acordada por VOZ: sem cursor na caixa, senão o teclado saltava para cima do ecrã */
      if (hasCmd) runVera(rest);
      else { followUntil = Date.now() + FOLLOW_MS; if (window.Sound) Sound.play('siri_on'); setStatus('Diz o que queres…'); }
    }, phoneOpen() ? 0 : 700);
  }
  function runVera(text) { if (!window.Vera) return; if (!Vera.isOpen()) Vera.open({ noFocus: true }); Vera.run(text); }
  function setStatus(t) { try { const s = document.querySelector('#vera .vera-status'); if (s) s.textContent = t; } catch (e) {} }

  /* botão do microfone: grava UMA frase e devolve o texto (cb(text|null, erro)) */
  function listenOnce(cb) {
    if (onceCb) return false;
    onceCb = cb; mode = 'command'; followUntil = 0;
    if (on) { speaking = false; chunks = []; } else start();
    setTimeout(() => { if (onceCb === cb && !busy && !speaking) { onceCb = null; mode = 'wake'; cb(null, 'silence'); refresh(); } }, 7000);
    return true;
  }

  /* segundo toque no microfone enquanto ouve = desistir (a frase que estiver a ser gravada é deitada fora) */
  function cancelOnce() { if (!onceCb) return false; const cb = onceCb; onceCb = null; mode = 'wake'; speaking = false; chunks = []; cb(null, 'cancel'); refresh(); return true; }
  const listening = () => !!onceCb;

  function init() {
    Bridge.on('ai:stt', d => { if (d && pending.has(+d.id)) { if (d.error) backoff(d.error); finish(+d.id, d.error ? null : { text: String(d.text || ''), pt: String(d.pt || d.text || ''), v: d.v === true }, d.error); } });
    ['phone:open', 'phone:close', 'unlock', 'lock'].forEach(ev => Bridge.on(ev, () => setTimeout(refresh, 300)));
    /* sair/voltar ao jogo (alt-tab): recalibra e deita fora o que estava a ser gravado */
    window.addEventListener('blur', () => resync(3000)); window.addEventListener('focus', () => resync(3000));
    document.addEventListener('visibilitychange', () => resync(3000));
    Bridge.on('state', () => refresh());
    setTimeout(refresh, 1500);
  }
  return { init, listenOnce, cancelOnce, listening, refresh, get active() { return on; }, get state() { return vst; }, announce: () => { lastEmit = 0; const s = vst; vst = ''; emit(s || (on ? 'listen' : 'off'), 0); }, _norm: norm, _wake: WAKE, _wakeOf: wakeOf, _wav: wav, _heard: heard, _frame: frame, _resync: resync, _busy: v => { busy = !!v; }, _on: v => { on = !!v; }, _finish: finish, _st: () => ({ speaking, muted: Date.now() < muteUntil, epoch, busy, queued: !!queued, followUntil, paused: Date.now() < pauseUntil }) };
})();
