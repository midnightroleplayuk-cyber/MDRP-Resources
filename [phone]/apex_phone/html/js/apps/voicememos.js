/* =====================================================================
   GRAVADOR (voicememos): gravações de voz guardadas no servidor (server/voicememos.lua, config_voicememos.lua).
   Ronda 2 (1.5.0, agente MEDIA):
     · em TODOS os telemóveis: `core: true` (as contas antigas tinham `state.installed` gravado sem ele e nunca o viam);
       a home dá-lhe lugar uma vez por conta (home.js, marca `vmm`).
     · LIMITE DO APARELHO: duração e tamanho máximos são os do telemóvel na mão (voicememos.config → server/recording.lua,
       config_recording.lua). O painel mostra "máx. 5:00" e, nos últimos 10 s, "faltam 0:08"; no limite guarda sozinho.
     · gravar como nas apps reais: onda ao vivo, PAUSA e RETOMAR (o tempo em pausa não conta), Concluído guarda logo,
       Cancelar pergunta; uma chamada a entrar põe em pausa; sair da app continua a gravar (o ponto do microfone fica aceso);
       guardar o telemóvel ou fechar a app guarda o que há.
     · microfone pelo RecCore.getMic: permissão do telemóvel, o pedido do FiveM no canto do ecrã, prazo e uma frase clara
       para cada recusa (e as gravações antigas continuam a ouvir-se).
     · envio ao ritmo do limitador do FXServer (RecCore.upload): uma gravação longa em pedaços seguidos expulsava o jogador.
     · leitor: onda com posição, arrastar, recuar/avançar 15 s, velocidade; mudar o nome, apagar, favorito, partilhar para
       as Mensagens e para o Zapp (mensagem de voz, até Config.Media.maxAudioSec).
   PearOS e Nova UI no mesmo ficheiro (CSS app-voicememos.css; na Nova UI as gravações são cartões e o ecrã de gravação
   ocupa a app inteira com o degradé vermelho da One UI).
   ===================================================================== */
(() => {
  const SQ = 'M50 0C88 0 100 12 100 50S88 100 50 100 0 88 0 50 12 0 50 0Z';
  const BARS = [18, 30, 44, 26, 58, 36, 50, 22, 40, 30, 16];
  const barsSvg = (cx0, step, col, scale) => BARS.map((h, i) => { const hh = h * scale, x = cx0 + i * step; return `<rect x="${x.toFixed(1)}" y="${(50 - hh / 2).toFixed(1)}" width="4.6" height="${hh.toFixed(1)}" rx="2.3" fill="${col}"/>`; }).join('');
  /* ícone PearOS: fundo quase preto, onda branca e a barra central vermelha */
  Icons.app.voicememos = () => Icons.SVG(Icons.G('gVmm', '#3A3A3C', '#131315', '#060607') + Icons.GL(barsSvg(16, 6.6, '#fff', 1) + '<rect x="48.6" y="12" width="2.8" height="76" rx="1.4" fill="#FF453A"/>'));
  /* ícone Nova UI: superelipse coral com o microfone plano e uma onda curta */
  if (Icons.registerOS) Icons.registerOS('android', { voicememos: () => Icons.SVG(
    `<path d="${SQ}" fill="#F0503F"/><ellipse cx="38" cy="8" rx="70" ry="44" fill="#FF9A86" opacity=".5"/><path d="${SQ}" fill="none" stroke="#fff" stroke-opacity=".26" stroke-width="2.2"/>`
    + '<rect x="40" y="16" width="20" height="38" rx="10" fill="#FFE3DD" transform="translate(2.6 .6)"/><rect x="40" y="16" width="20" height="38" rx="10" fill="#fff"/>'
    + '<path d="M30 42a20 20 0 0 0 40 0M50 62v12M39 74h22" fill="none" stroke="#fff" stroke-width="5" stroke-linecap="round"/>'
    + '<g fill="#fff" opacity=".9"><rect x="14" y="36" width="4" height="12" rx="2"/><rect x="22" y="30" width="4" height="24" rx="2"/><rect x="74" y="30" width="4" height="24" rx="2"/><rect x="82" y="36" width="4" height="12" rx="2"/></g>', true) });
  if (window.App && App.alias) App.alias('android', { voicememos: 'Gravador de voz' });
  try { if (UI.OU_APPS && UI.OU_APPS.add) UI.OU_APPS.add('voicememos'); } catch (e) {}

  const isA = () => !!(window.System && System.isAndroid && System.isAndroid());
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf ? L.tf(s, ...v) : v.reduce((a, x) => a.replace('%s', x), s));
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const VM = () => window.VoiceMsg || null;
  const RC = () => window.RecCore || null;
  const fmt = ms => UI.fmtDur(Math.max(0, +ms || 0) / 1000);
  const fmtTenths = ms => { ms = Math.max(0, +ms || 0); const s = Math.floor(ms / 1000), m = Math.floor(s / 60); return m + ':' + String(s % 60).padStart(2, '0') + ',' + Math.floor((ms % 1000) / 100); };
  const dark = () => document.body.classList.contains('dark');
  const RED = () => isA() ? '#F2453D' : (dark() ? '#FF453A' : '#FF383C');
  const RATES = [1, 1.5, 2];
  const rateLabel = r => (r === 1.5 ? '1,5' : String(r)) + '×';
  const MAX_PARTS = 512;
  const ERR = { toolarge: 'A gravação é demasiado grande para o servidor.', toolong: 'A gravação passa do limite de duração.', limit: 'Já tens o máximo de gravações. Apaga uma para gravares outra.', busy: 'Ainda há um envio a decorrer. Espera um instante.', ratelimit: 'Demasiados pedidos seguidos. Tenta daqui a pouco.', disabled: 'O Gravador está desativado neste servidor.', badmime: 'Formato de áudio não aceite pelo servidor.', baddata: 'O ficheiro chegou estragado.', badsize: 'O envio ficou incompleto.', missing: 'O envio ficou incompleto.', order: 'O envio foi interrompido.', notfound: 'Esta gravação já não existe.', db: 'Erro no servidor.', empty: 'A gravação ficou vazia.', read: 'Não foi possível ler a gravação.', rpc: 'O servidor não respondeu.', timeout: 'O servidor não respondeu.' };
  const errText = e => T(ERR[e] || 'Não foi possível concluir a operação.');

  /* ---------- lista com chave: cria/atualiza/remove sem repintar tudo ---------- */
  function keyed(host, items, keyOf, build, update) {
    const have = new Map(); [...host.children].forEach(el => { if (el.dataset.k) have.set(el.dataset.k, el); });
    const seen = new Set(); let prev = null;
    items.forEach(it => { const k = String(keyOf(it)); seen.add(k); let el = have.get(k); if (!el) { el = build(it); el.dataset.k = k; } update(el, it); const ref = prev ? prev.nextSibling : host.firstChild; if (el !== ref) host.insertBefore(el, ref); prev = el; });
    have.forEach((el, k) => { if (!seen.has(k)) el.remove(); });
  }
  const setTxt = (el, s) => { if (el && el.textContent !== s) el.textContent = s; };

  /* ---------- descarga aos bocados (balde próprio no servidor; um ratelimit espera e repete) ---------- */
  async function rpcRetry(name, data) { let r = await Bridge.rpcRaw(name, data); for (let k = 0; k < 3 && r && r.error === 'ratelimit'; k++) { await sleep(600 * (k + 1)); r = await Bridge.rpcRaw(name, data); } return r; }
  /* envio ao ritmo do limitador do FXServer (RecCore.upload); sem o RecCore (index.html antigo) o caminho de antes */
  async function uploadMemo(dataUrl, info, onProgress) {
    if (RC()) {
      const r = await RC().upload({ begin: ['voicememos.begin', { name: info.name, mime: info.mime, size: dataUrl.length, duration: info.duration, waveform: info.waveform }],
        upload: 'voicememos.upload', finish: ['voicememos.finish', {}], dataUrl, onProgress });
      if (!r || r.error) return { error: (r && r.error) || 'rpc' };
      return { id: r.id, item: r.item };
    }
    const b = await rpcRetry('voicememos.begin', { name: info.name, mime: info.mime, size: dataUrl.length, duration: info.duration, waveform: info.waveform });
    const id = b && Math.floor(+b.id); if (!b || b.error || !(id > 0)) return { error: (b && b.error) || 'rpc' };
    const chunk = clamp(Math.floor(+b.chunk) || 48000, 1024, 64000), total = Math.ceil(dataUrl.length / chunk);
    if (total > MAX_PARTS) return { error: 'toolarge' };
    for (let i = 1; i <= total; i++) { const r = await rpcRetry('voicememos.upload', { id, i, total, data: dataUrl.slice((i - 1) * chunk, i * chunk) }); if (!r || r.error) return { error: (r && r.error) || 'rpc' }; onProgress && onProgress(i / total); }
    const f = await rpcRetry('voicememos.finish', { id }); if (!f || f.error) return { error: (f && f.error) || 'rpc' };
    return { id, item: f.item };
  }
  const cache = new Map();
  const remember = (id, p) => { cache.delete(id); cache.set(id, p); while (cache.size > 6) cache.delete(cache.keys().next().value); return p; };
  function fetchMemo(id) {
    id = Math.floor(+id); if (!(id > 0)) return Promise.resolve({ error: 'notfound' });
    if (cache.has(id)) return remember(id, cache.get(id));
    const p = (async () => { const parts = []; let total = 1, head = null;
      for (let i = 1; i <= total; i++) { const r = await rpcRetry('voicememos.get', { id, i }); if (!r || r.error || typeof r.data !== 'string') return { error: (r && r.error) || 'rpc' }; if (!head) { head = r; total = Math.max(1, Math.floor(+r.total) || 1); if (total > MAX_PARTS) return { error: 'toolarge' }; } parts.push(r.data); if (!r.data.length) break; }
      const out = parts.join(''); if (!out) return { error: 'empty' }; const mime = String(head.mime || 'audio/webm');
      return { id, mime, duration: +head.duration || 0, dataUrl: /^data:/i.test(out) ? out : 'data:' + mime + ';base64,' + out.replace(/\s+/g, '') }; })().catch(() => ({ error: 'rpc' }));
    remember(id, p); p.then(v => { if ((!v || v.error) && cache.get(id) === p) cache.delete(id); }); return p;
  }
  const placeholderWave = seed => { let s = (Math.floor(+seed) || 7) >>> 0; return Array.from({ length: 48 }, () => { s = (Math.imul(s, 1103515245) + 12345) >>> 0; return Math.round((.12 + ((s >>> 16) % 100) / 100 * .3) * 100) / 100; }); };
  /* onda estática: n barras centradas, raio nas pontas */
  function drawWave(cv, wave, color) {
    const ctx = cv.getContext('2d'); const W = cv.width, H = cv.height; ctx.clearRect(0, 0, W, H);
    const w = (Array.isArray(wave) && wave.length ? wave : placeholderWave(1)).map(v => clamp(+v || 0, 0, 1)); const n = w.length, gap = 2, bw = Math.max(1.5, (W - gap * (n - 1)) / n);
    ctx.fillStyle = color;
    for (let i = 0; i < n; i++) { const h = Math.max(3, w[i] * (H - 4)), x = i * (bw + gap), y = (H - h) / 2; ctx.beginPath(); if (ctx.roundRect) ctx.roundRect(x, y, bw, h, bw / 2); else ctx.rect(x, y, bw, h); ctx.fill(); }
  }
  const resample = (levels, n) => (VM() && VM().util && VM().util.resample) ? VM().util.resample(levels, n) : (levels.length ? levels.slice(-n) : [.06]);
  const cleanMime = t => { const b = String(t || '').replace(/\s+/g, '').toLowerCase().split(';')[0]; return /^audio\/[a-z0-9.+-]{1,30}$/.test(b) ? b : 'audio/webm'; };

  /* ============================================================
     App
     ============================================================ */
  App.define('voicememos', {
    name: 'Gravador', category: 'Utilitários', core: true, statusBar: 'auto',
    description: 'Grava notas de voz com o microfone, com pausa, ouve-as, dá-lhes nome e partilha-as por mensagem ou pelo Zapp.',
    open(win) {
      const g = UI.g;
      win.classList.add('vmm'); if (isA()) win.classList.add('vmm-a');
      const S = { cfg: { maxSeconds: 120, maxPerPlayer: 30, maxBytes: 1000000, bps: 32000, nameMax: 60, count: 0 }, items: [], filter: '', onlyFav: false, open: null, player: null, rec: null, rate: 1 };
      const about = () => UI.alert({ title: T('Gravador'), msg: TF('Neste telemóvel cada gravação pode ter até %s. Guardas até %s gravações por personagem, no servidor, só para ti.', fmt(S.cfg.maxSeconds * 1000), String(S.cfg.maxPerPlayer)) });
      const v = UI.view({ title: 'Gravador', large: true, right: [{ icon: 'more', onTap: () => UI.actionSheet({ buttons: [{ label: T(S.onlyFav ? 'Mostrar todas' : 'Só favoritas'), icon: 'star', value: 'fav' }, { label: T('Sobre o Gravador'), icon: 'info', value: 'about' }] }).then(a => { if (a === 'fav') { S.onlyFav = !S.onlyFav; chips.set && chips.set(S.onlyFav ? 1 : 0); paint(); } if (a === 'about') about(); }) }] });
      const root = UI.el(`<div class="vmm-main"><div class="vmm-chips"></div><div class="vmm-list"></div><div class="vmm-none"></div><div class="vmm-space"></div></div>`);
      const search = UI.search('Pesquisar gravações', q => { S.filter = String(q || '').toLowerCase(); paint(); });
      v.content.appendChild(search); v.content.appendChild(root);
      const $ = s => root.querySelector(s);
      const chips = UI.chips(['Todas', 'Favoritas'], 0, i => { S.onlyFav = i === 1; paint(); });
      $('.vmm-chips').appendChild(chips);
      const list = $('.vmm-list'), none = $('.vmm-none');

      /* ---------- painel de gravação: fixo ao fundo (PearOS: folha que sobe; Nova UI: ecrã inteiro) ---------- */
      const bar = UI.el(`<div class="vmm-bar"><div class="vmm-recwrap"><div class="vmm-recbtn" role="button" aria-label="${UI.esc(T('Gravar'))}"><i></i></div><span class="vmm-cap"></span></div>
        <div class="vmm-panel"><div class="vmm-grab"></div>
          <div class="vmm-phead"><b class="vmm-pname" data-noi18n>Nova gravação</b><span class="vmm-pdate"></span></div>
          <div class="vmm-ptime">0:00,0</div><div class="vmm-plimit"></div>
          <div class="vmm-livewrap"><canvas class="vmm-live" width="408" height="120"></canvas><i class="vmm-lhead"></i></div>
          <div class="vmm-pmsg"></div>
          <div class="vmm-pbtns"><div class="vmm-pb vmm-pcancel" role="button">${g('x', 22)}<span>Cancelar</span></div>
            <div class="vmm-pmain" role="button" aria-label="${UI.esc(T('Pausa'))}"><i class="vmm-pause"><b></b><b></b></i><i class="vmm-resume"></i></div>
            <div class="vmm-pb vmm-pdone" role="button"><span class="vmm-stopsq"></span><span>Concluído</span></div></div></div></div>`);
      v.appendChild(bar);
      const live = bar.querySelector('.vmm-live'), ptime = bar.querySelector('.vmm-ptime'), pmsg = bar.querySelector('.vmm-pmsg'), pname = bar.querySelector('.vmm-pname'), plimit = bar.querySelector('.vmm-plimit'), pdate = bar.querySelector('.vmm-pdate'), cap = bar.querySelector('.vmm-cap'), pmain = bar.querySelector('.vmm-pmain');
      const paintCap = () => setTxt(cap, TF('Até %s por gravação', fmt(S.cfg.maxSeconds * 1000)));

      /* ---------- estado da gravação (um só gravador; o microfone é largado em TODOS os caminhos) ---------- */
      const ring = new Array(136).fill(0); let ringI = 0;
      function paintLive(active) {
        const ctx = live.getContext('2d'); const W = live.width, H = live.height; ctx.clearRect(0, 0, W, H);
        /* Nova UI: a onda vive no degradé vermelho (branca no escuro, coral no claro); PearOS: vermelha no cartão */
        const bars = isA() ? (dark() ? '#fff' : '#F2453D') : RED();
        ctx.strokeStyle = dark() ? 'rgba(255,255,255,.18)' : 'rgba(0,0,0,.1)'; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(0, H / 2 + .5); ctx.lineTo(W, H / 2 + .5); ctx.stroke();
        ctx.fillStyle = bars; const n = ring.length, bw = 2, gap = 1; const step = bw + gap;
        for (let i = 0; i < n; i++) { const vv = ring[(ringI + i) % n]; const h = Math.max(2, vv * (H - 8)); const x = W - (n - i) * step; if (x < 0) continue; ctx.fillRect(x, (H - h) / 2, bw, h); }
        if (active && !isA()) { const h = clamp(ring[(ringI + n - 1) % n], 0, 1) * (H - 8) + 2; ctx.fillStyle = dark() ? '#fff' : '#000'; ctx.fillRect(W - 1.5, (H - h) / 2, 1.5, h); }
      }
      function release(r) { if (!r) return; if (r.raf) cancelAnimationFrame(r.raf); r.raf = 0; if (r.stream) { RC() ? RC().stopStream(r.stream) : r.stream.getTracks().forEach(t => t.stop()); r.stream = null; } if (r.ctx) { try { const p = r.ctx.close(); if (p && p.catch) p.catch(() => {}); } catch (e) {} r.ctx = null; r.an = null; } if (r.micOn) { r.micOn = false; try { System.indicator('mic', false); } catch (e) {} } }
      const STATES = ['starting', 'recording', 'paused', 'stopping', 'sending', 'error'];
      const setState = s => { STATES.forEach(x => bar.classList.toggle('is-' + x, s === x)); bar.classList.toggle('open', !!s); win.classList.toggle('vmm-rec-open', !!s); if (S.rec) S.rec.state = s; pmain.setAttribute('aria-label', T(s === 'paused' ? 'Retomar' : 'Pausa')); };
      function closePanel() { const r = S.rec; if (r) { release(r); clearTimeout(r.failT); if (r.mr && r.mr.state !== 'inactive') { try { r.mr.ondataavailable = null; r.mr.onstop = null; r.mr.stop(); } catch (e) {} } r.offs.forEach(f => { try { f(); } catch (e) {} }); S.rec = null; } setState(null); }
      function fail(text) { const r = S.rec; if (!r) return; release(r); setState('error'); pmsg.textContent = text; clearTimeout(r.failT); r.failT = setTimeout(() => { if (S.rec === r) closePanel(); }, 6500); }
      function stopRecorder(r) { return new Promise(res => { const make = () => r.chunks.length ? new Blob(r.chunks, { type: (r.mr && r.mr.mimeType) || r.mime || 'audio/webm' }) : null; if (!r.mr || r.mr.state === 'inactive') return res(make()); let done = false; const fin = () => { if (done) return; done = true; res(make()); }; r.mr.onstop = fin; setTimeout(fin, 2500); try { if (r.mr.state === 'paused') r.mr.resume(); r.mr.stop(); } catch (e) { fin(); } }); }
      const nextName = () => { let n = 1; const used = new Set(S.items.map(x => x.name)); const base = T('Nova gravação'); while (used.has(n === 1 ? base : base + ' ' + n)) n++; return n === 1 ? base : base + ' ' + n; };
      const elapsedOf = r => Math.max(0, (r.pausedAt || performance.now()) - r.t0 - r.pausedMs);
      const maxMs = () => (+S.cfg.maxSeconds || 120) * 1000;
      function paintLimit(r) {
        const left = maxMs() - (r ? elapsedOf(r) : 0);
        const end = !!r && left <= 10000;
        bar.classList.toggle('vmm-end', end);
        setTxt(plimit, end ? TF('faltam %s', fmt(Math.ceil(Math.max(0, left) / 1000) * 1000)) : TF('máx. %s', fmt(maxMs())));
      }

      async function startRec() {
        if (S.rec) return;
        if (S.items.length >= (S.cfg.maxPerPlayer || 30)) { UI.alert({ title: T('Sem espaço'), msg: TF('Já tens %s gravações. Apaga uma para gravares outra.', String(S.items.length)) }); return; }
        if (!RC() || !RC().canAudio()) { UI.alert({ title: T('Microfone indisponível'), msg: Bridge.inFiveM ? T('O browser do jogo não dá acesso ao microfone a este telemóvel, por isso não é possível gravar aqui. As gravações que já tens continuam a poder ouvir-se.') : T('Este browser não permite gravar áudio.') }); return; }
        if (S.player) S.player.pause();
        const r = S.rec = { state: 'starting', stream: null, mr: null, ctx: null, an: null, buf: null, chunks: [], levels: [], t0: 0, pausedAt: 0, pausedMs: 0, raf: 0, micOn: false, offs: [], mime: '', lastTxt: '', name: nextName(), created: Date.now() };
        ring.fill(0); ringI = 0; pname.textContent = r.name; setTxt(pdate, UI.fmtTime(new Date())); ptime.textContent = fmtTenths(0); paintLimit(null);
        pmsg.textContent = T('A preparar o microfone…'); setState('starting'); paintLive(false);
        r.offs.push(
          /* guardar o telemóvel ou fechar a app: guarda o que já foi gravado (não se deita fora sem perguntar) */
          Bridge.on('phone:close', () => { if (r.state === 'recording' || r.state === 'paused') finishRec('close'); else if (r.state === 'starting') closePanel(); }),
          Bridge.on('app:kill', id => { if (id !== 'voicememos') return; if (r.state === 'recording' || r.state === 'paused') finishRec('close'); else closePanel(); }),
          Bridge.on('session:changed', () => closePanel()),
          /* chamada a entrar: pausa, como no PearPhone (retoma-se à mão) */
          Bridge.on('incomingCall', () => { if (r.state === 'recording') togglePause(); else if (r.state === 'starting') closePanel(); }));
        const m = await RC().getMic('voicememos', { timeout: 12000 });
        if (S.rec !== r) { if (m.stream) RC().stopStream(m.stream); return; }
        if (!m.stream) { if (m.error === 'phone') { closePanel(); UI.toast(m.text, 3600); return; } fail(m.text); return; }
        r.stream = m.stream; r.mime = RC().audioMime();
        const bps = clamp(+S.cfg.bps || 32000, 12000, 128000);
        try { r.mr = new MediaRecorder(r.stream, Object.assign({ audioBitsPerSecond: bps }, r.mime ? { mimeType: r.mime } : {})); } catch (e) { try { r.mr = new MediaRecorder(r.stream); } catch (e2) { fail(T('Não foi possível iniciar a gravação')); return; } }
        r.mr.ondataavailable = ev => { if (ev.data && ev.data.size) r.chunks.push(ev.data); };
        r.mr.onerror = () => { if (r.state === 'recording' || r.state === 'paused') finishRec('error'); else fail(T('A gravação falhou')); };
        r.stream.getAudioTracks().forEach(t => t.addEventListener('ended', () => { if (S.rec === r && (r.state === 'recording' || r.state === 'paused')) finishRec('error'); }));
        try { const AC = window.AudioContext || window.webkitAudioContext; r.ctx = new AC(); r.an = r.ctx.createAnalyser(); r.an.fftSize = 1024; r.an.smoothingTimeConstant = .25; r.ctx.createMediaStreamSource(r.stream).connect(r.an); r.buf = new Uint8Array(r.an.fftSize); if (r.ctx.state === 'suspended') { const p = r.ctx.resume(); if (p && p.catch) p.catch(() => {}); } } catch (e) { r.an = null; }
        try { r.mr.start(1000); } catch (e) { fail(T('Não foi possível iniciar a gravação')); return; }
        r.t0 = performance.now(); pmsg.textContent = ''; setState('recording'); r.micOn = true; try { System.indicator('mic', true); } catch (e) {}
        let lastLvlT = 0;
        const tick = now => { if (S.rec !== r || (r.state !== 'recording' && r.state !== 'paused')) return; r.raf = requestAnimationFrame(tick);
          if (r.state === 'paused') return;
          const el = Math.min(elapsedOf(r), maxMs());
          let lvl = 0; if (r.an) { r.an.getByteTimeDomainData(r.buf); let sum = 0; for (let i = 0; i < r.buf.length; i += 2) { const x = (r.buf[i] - 128) / 128; sum += x * x; } lvl = Math.sqrt(clamp(Math.sqrt(sum / (r.buf.length / 2)) * 4, 0, 1)); }
          if (now - lastLvlT >= 40) { lastLvlT = now; ring[ringI] = lvl; ringI = (ringI + 1) % ring.length; r.levels.push(lvl); paintLive(true); }
          const txt = fmtTenths(el); if (txt !== r.lastTxt) { r.lastTxt = txt; ptime.textContent = txt; paintLimit(r); }
          if (el >= maxMs()) finishRec('limit'); };
        r.raf = requestAnimationFrame(tick);
      }
      function togglePause() {
        const r = S.rec; if (!r || !r.mr) return;
        try {
          if (r.state === 'recording') { r.mr.pause(); r.pausedAt = performance.now(); setState('paused'); paintLive(false); }
          else if (r.state === 'paused') { r.pausedMs += performance.now() - r.pausedAt; r.pausedAt = 0; r.mr.resume(); setState('recording'); }
        } catch (e) { console.error('[apex_phone] gravador pausa', e); }
        Sound.play('click'); paintLimit(r);
      }
      /* parar e GUARDAR (Concluído, limite, telemóvel guardado, erro do microfone a meio) */
      async function finishRec(why) {
        const r = S.rec; if (!r || (r.state !== 'recording' && r.state !== 'paused')) return;
        const dur = Math.round(Math.min(elapsedOf(r), maxMs()));
        setState('stopping'); if (r.raf) cancelAnimationFrame(r.raf); r.raf = 0;
        const blob = await stopRecorder(r); release(r);
        if (S.rec !== r) return;
        if (!blob || !blob.size) { fail(T('A gravação ficou vazia')); return; }
        if (dur < 1000) { UI.toast('Gravação demasiado curta'); closePanel(); return; }
        if (why === 'limit') UI.toast(TF('Limite deste telemóvel: %s. A gravação foi guardada.', fmt(maxMs())), 3200);
        else if (why === 'error') UI.toast('O microfone desligou-se: guardou-se o que já estava gravado', 3200);
        setState('sending'); ptime.textContent = fmtTenths(dur); pmsg.textContent = T('A guardar…');
        let dataUrl; try { const fixed = RC() ? await RC().fixWebmDuration(blob, dur) : blob; dataUrl = RC() ? await RC().blobToDataURL(fixed, cleanMime(blob.type)) : null; } catch (e) { dataUrl = null; }
        if (!dataUrl) { fail(errText('read')); return; }
        if (dataUrl.length > (+S.cfg.maxBytes || 1000000)) { fail(errText('toolarge')); return; }
        const wave = resample(r.levels, 48), mime = cleanMime(blob.type);
        const up = await uploadMemo(dataUrl, { name: r.name, mime, duration: dur, waveform: wave }, f => { if (S.rec === r) setTxt(pmsg, TF('A guardar… %s', Math.round(f * 100) + ' %')); });
        if (S.rec !== r) return;
        if (!up || up.error) { Sound.play('error'); fail(errText(up && up.error)); return; }
        remember(up.id, Promise.resolve({ id: up.id, mime, duration: dur, dataUrl }));
        const item = up.item || { id: up.id, name: r.name, created: Date.now(), duration: dur, bytes: dataUrl.length, favorite: false, waveform: wave };
        S.items = [item].concat(S.items.filter(x => x.id !== item.id)); S.cfg.count = S.items.length;
        Sound.play('success'); closePanel(); paint(); if (win.isConnected && !win.classList.contains('bg')) openItem(item.id);
      }
      bar.querySelector('.vmm-recbtn').onclick = () => { Sound.play('tap'); startRec(); };
      pmain.onclick = () => { const r = S.rec; if (!r) return; if (r.state === 'recording' || r.state === 'paused') togglePause(); else if (r.state === 'error') { closePanel(); startRec(); } };
      bar.querySelector('.vmm-pdone').onclick = () => finishRec('user');
      bar.querySelector('.vmm-pcancel').onclick = async () => { const r = S.rec; if (!r) return; if (r.state === 'sending' || r.state === 'stopping') return;
        if (r.state === 'recording' || r.state === 'paused') { const was = r.state === 'recording'; if (was) togglePause(); if (!(await UI.confirm(T('Apagar a gravação?'), T('O que gravaste até agora perde-se.'), T('Apagar'), true))) { if (was && S.rec === r && r.state === 'paused') togglePause(); return; } }
        closePanel(); };
      bar.querySelector('.vmm-grab').onclick = () => { if (S.rec && (S.rec.state === 'recording' || S.rec.state === 'paused')) bar.classList.toggle('vmm-mini'); };

      /* ---------- leitor (um só a tocar de cada vez; progresso por transform) ---------- */
      function makePlayer(el, item) {
        const wave = Array.isArray(item.waveform) && item.waveform.length ? item.waveform : placeholderWave(item.id);
        const base = el.querySelector('.vmm-wave-b'), top = el.querySelector('.vmm-wave-t'), rev = el.querySelector('.vmm-rev'), cur = el.querySelector('.vmm-tcur'), rem = el.querySelector('.vmm-trem'), btn = el.querySelector('.vmm-play'), waveEl = el.querySelector('.vmm-wave'), rateEl = el.querySelector('.vmm-rate');
        const baseCol = () => dark() ? 'rgba(255,255,255,.28)' : 'rgba(0,0,0,.18)';
        drawWave(base, wave, baseCol()); drawWave(top, wave, RED());
        const P = { el, item, audio: null, url: null, raf: 0, dead: false, fixing: false, drag: null, durMs: +item.duration || 0, loading: false };
        const setProg = f => { const pct = ((1 - clamp(f, 0, 1)) * 100).toFixed(3); rev.style.transform = `translateX(-${pct}%)`; rev.firstElementChild.style.transform = `translateX(${pct}%)`; };
        const durS = () => (P.audio && isFinite(P.audio.duration) && P.audio.duration > 0 && !P.fixing) ? P.audio.duration : P.durMs / 1000;
        const paint = () => { const d = durS(), t = P.audio ? (P.audio.currentTime || 0) : 0; setProg(d > 0 ? t / d : 0); setTxt(cur, fmt(t * 1000)); setTxt(rem, '-' + fmt(Math.max(0, d * 1000 - t * 1000))); };
        const loop = () => { P.raf = 0; if (P.dead || !P.audio || P.audio.paused) return; if (!P.drag) paint(); P.raf = requestAnimationFrame(loop); };
        const stopLoop = () => { if (P.raf) cancelAnimationFrame(P.raf); P.raf = 0; };
        const paintRate = () => setTxt(rateEl, rateLabel(S.rate));
        async function ensure() {
          if (P.audio) return true; if (P.loading) return false; P.loading = true; el.classList.add('is-loading');
          const m = await fetchMemo(item.id); P.loading = false; el.classList.remove('is-loading'); if (P.dead) return false;
          if (!m || m.error || !m.dataUrl) { UI.toast(errText(m && m.error)); return false; }
          let b = null; try { b = RC() ? RC().dataURLToBlob(m.dataUrl) : (VM() && VM().util ? VM().util.dataUrlToBlob(m.dataUrl) : null); } catch (e) { b = null; }
          if (!b || !b.size) { UI.toast(errText('read')); return false; }
          P.url = URL.createObjectURL(b); const a = P.audio = new Audio(); a.preload = 'auto';
          /* gravações de antes da ronda 2 não trazem a duração no webm: saltar para o fim obriga o Chromium a lê-la */
          a.addEventListener('loadedmetadata', () => { if (!isFinite(a.duration)) { P.fixing = true; try { a.currentTime = 1e7; } catch (e) { P.fixing = false; } setTimeout(() => { if (P.fixing) { P.fixing = false; try { a.currentTime = 0; } catch (e) {} } }, 2500); } });
          a.addEventListener('durationchange', () => { if (P.fixing && isFinite(a.duration)) { P.fixing = false; try { a.currentTime = 0; } catch (e) {} paint(); } });
          a.addEventListener('playing', () => { if (P.fixing) return; el.classList.add('is-playing'); if (!P.raf) P.raf = requestAnimationFrame(loop); });
          a.addEventListener('pause', () => { if (P.fixing) return; el.classList.remove('is-playing'); stopLoop(); paint(); });
          a.addEventListener('ended', () => { if (P.fixing || !a.paused) return; stopLoop(); el.classList.remove('is-playing'); try { a.currentTime = 0; } catch (e) {} paint(); if (S.player === P) S.player = null; });
          a.addEventListener('error', () => { if (!P.fixing) UI.toast('Formato não suportado'); });
          a.src = P.url; return true;
        }
        async function play() { if (P.dead) return; if (S.player && S.player !== P) S.player.pause(); S.player = P; if (!(await ensure()) || P.dead || S.player !== P) return;
          for (let k = 0; k < 25 && P.fixing; k++) await sleep(100);
          const vol = +((window.System && System.state) || {}).volume; P.audio.volume = clamp(isFinite(vol) ? vol / 100 : .6, 0, 1); P.audio.playbackRate = S.rate; try { await P.audio.play(); } catch (e) { if (e && e.name === 'NotAllowedError') UI.toast('Toca outra vez para ouvir'); } }
        const pause = () => { if (P.audio && !P.audio.paused) P.audio.pause(); if (S.player === P) S.player = null; };
        const seekBy = ds => { if (!P.audio) return; const d = durS(); try { P.audio.currentTime = clamp((P.audio.currentTime || 0) + ds, 0, Math.max(0, d - .05)); } catch (e) {} paint(); };
        btn.onclick = e => { e.stopPropagation(); if (P.audio && !P.audio.paused) pause(); else play(); };
        el.querySelector('.vmm-back').onclick = e => { e.stopPropagation(); seekBy(-15); };
        el.querySelector('.vmm-fwd').onclick = e => { e.stopPropagation(); seekBy(15); };
        rateEl.onclick = e => { e.stopPropagation(); S.rate = RATES[(RATES.indexOf(S.rate) + 1) % RATES.length]; paintRate(); if (P.audio) P.audio.playbackRate = S.rate; Sound.play('click'); };
        waveEl.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; e.stopPropagation(); P.drag = { r: UI.vrect ? UI.vrect(waveEl) : waveEl.getBoundingClientRect() }; try { waveEl.setPointerCapture(e.pointerId); } catch (x) {} });
        waveEl.addEventListener('pointermove', e => { if (!P.drag || !P.drag.r.width) return; const f = clamp((e.clientX - P.drag.r.left) / P.drag.r.width, 0, 1); setProg(f); setTxt(cur, fmt(f * durS() * 1000)); });
        const dragEnd = async e => { if (!P.drag) return; const d = P.drag; P.drag = null; if (!d.r.width) return; const f = clamp((e.clientX - d.r.left) / d.r.width, 0, 1); if (!P.audio) { if (!(await ensure())) return; } const dd = durS(); try { P.audio.currentTime = clamp(f * dd, 0, Math.max(0, dd - .05)); } catch (x) {} paint(); };
        waveEl.addEventListener('pointerup', dragEnd); waveEl.addEventListener('pointercancel', dragEnd);
        P.pause = pause; P.destroy = () => { P.dead = true; stopLoop(); if (P.audio) { try { P.audio.pause(); P.audio.removeAttribute('src'); P.audio.load(); } catch (e) {} P.audio = null; } if (P.url) { URL.revokeObjectURL(P.url); P.url = null; } if (S.player === P) S.player = null; };
        P.redraw = () => { drawWave(base, wave, baseCol()); drawWave(top, wave, RED()); };
        setProg(0); setTxt(cur, '0:00'); setTxt(rem, '-' + fmt(P.durMs)); paintRate(); return P;
      }

      /* ---------- lista ---------- */
      const buildItem = it => { const el = UI.el(`<div class="vmm-it"><div class="vmm-ihead"><div class="vmm-ib"><b class="vmm-iname" data-noi18n></b><span class="vmm-idate"></span></div><span class="vmm-idur"></span><span class="vmm-istar">${g('starFill', 14)}</span></div>
        <div class="vmm-body"><div class="vmm-wave"><canvas class="vmm-wave-b" width="376" height="56"></canvas><div class="vmm-rev"><canvas class="vmm-wave-t" width="376" height="56"></canvas></div></div>
          <div class="vmm-times"><span class="vmm-tcur">0:00</span><span class="vmm-trem">-0:00</span></div>
          <div class="vmm-ctl"><div class="vmm-cb vmm-rate" role="button">1×</div><div class="vmm-cb vmm-back" role="button">${g('prev', 22)}</div><div class="vmm-play" role="button">${g('play', 30)}${g('pause', 30)}<span class="vmm-spin"></span></div><div class="vmm-cb vmm-fwd" role="button">${g('next', 22)}</div><div class="vmm-cb vmm-ifav" role="button">${g('star', 22)}</div></div>
          <div class="vmm-acts"><div class="vmm-act vmm-ishare" role="button">${g('share', 18)}<span>Partilhar</span></div><div class="vmm-act vmm-iren" role="button">${g('pen', 18)}<span>Mudar o nome</span></div><div class="vmm-act vmm-idel" role="button">${g('trash', 18)}<span>Apagar</span></div></div></div></div>`);
        el.querySelector('.vmm-ihead').onclick = () => openItem(+el.dataset.k);
        el.querySelector('.vmm-ifav').onclick = e => { e.stopPropagation(); toggleFav(+el.dataset.k); };
        el.querySelector('.vmm-ishare').onclick = e => { e.stopPropagation(); shareItem(+el.dataset.k); };
        el.querySelector('.vmm-iren').onclick = e => { e.stopPropagation(); renameItem(+el.dataset.k); };
        el.querySelector('.vmm-idel').onclick = e => { e.stopPropagation(); deleteItem(+el.dataset.k); };
        UI.longPress && UI.longPress(el.querySelector('.vmm-ihead'), () => { const id = +el.dataset.k; const it2 = S.items.find(x => x.id === id); if (!it2) return;
          UI.actionSheet({ title: it2.name, buttons: [{ label: T('Partilhar'), icon: 'share', value: 'share' }, { label: T('Mudar o nome'), icon: 'pen', value: 'ren' }, { label: T(it2.favorite ? 'Remover dos favoritos' : 'Favorito'), icon: 'star', value: 'fav' }, { label: T('Apagar'), icon: 'trash', danger: true, value: 'del' }] }).then(a => { if (a === 'share') shareItem(id); else if (a === 'ren') renameItem(id); else if (a === 'fav') toggleFav(id); else if (a === 'del') deleteItem(id); }); });
        return el; };
      const yearOf = ts => new Date(+ts || 0).getFullYear();
      const updItem = (el, it) => { setTxt(el.querySelector('.vmm-iname'), it.name); setTxt(el.querySelector('.vmm-idate'), UI.rel(it.created)); setTxt(el.querySelector('.vmm-idur'), fmt(it.duration)); el.classList.toggle('vmm-isfav', !!it.favorite); el.querySelector('.vmm-ifav').classList.toggle('on', !!it.favorite); el.classList.toggle('vmm-open', S.open === it.id); el.dataset.y = String(yearOf(it.created)); };
      function paint() {
        let items = S.items.slice(); if (S.onlyFav) items = items.filter(x => x.favorite); if (S.filter) items = items.filter(x => String(x.name || '').toLowerCase().includes(S.filter));
        keyed(list, items, x => x.id, buildItem, updItem);
        /* Nova UI: as gravações agrupam-se por ano (o cartão do primeiro de cada ano leva o ano por cima) */
        let lastY = null; [...list.children].forEach(el => { const y = el.dataset.y; el.classList.toggle('vmm-ystart', y !== lastY); if (y !== lastY) el.dataset.ylabel = y; lastY = y; });
        none.innerHTML = ''; none.hidden = !!items.length;
        if (!items.length) none.appendChild(S.items.length ? UI.empty('search', S.onlyFav && !S.filter ? 'Sem favoritas' : 'Sem resultados', S.onlyFav && !S.filter ? 'Toca na estrela de uma gravação para a marcares.' : 'Nenhuma gravação com esse nome.') : UI.empty('mic', 'Sem gravações', 'Toca no botão vermelho para gravares a primeira.'));
      }
      function openItem(id) {
        if (S.open === id) { closeItem(); return; }
        closeItem(); S.open = id; const it = S.items.find(x => x.id === id); const el = list.querySelector(`.vmm-it[data-k="${id}"]`); if (!it || !el) { paint(); return; }
        el.classList.add('vmm-open'); el._player = makePlayer(el, it); Sound.play('click');
      }
      function closeItem() { if (S.open == null) return; const el = list.querySelector(`.vmm-it[data-k="${S.open}"]`); if (el) { el.classList.remove('vmm-open'); if (el._player) { el._player.destroy(); el._player = null; } } S.open = null; }
      async function toggleFav(id) { const it = S.items.find(x => x.id === id); if (!it) return; const on = !it.favorite; it.favorite = on; paint(); Sound.play('click'); const r = await Bridge.rpcRaw('voicememos.favorite', { id, on }); if (!r || r.error) { it.favorite = !on; paint(); UI.toast(errText(r && r.error)); } }
      async function renameItem(id) { const it = S.items.find(x => x.id === id); if (!it) return; const name = await UI.prompt(T('Mudar o nome'), '', T('Nome da gravação'), it.name); if (name == null) return; const nm = String(name).trim().slice(0, +S.cfg.nameMax || 60); if (!nm || nm === it.name) return;
        const r = await Bridge.rpcRaw('voicememos.rename', { id, name: nm }); if (!r || r.error) { UI.toast(errText(r && r.error)); return; } it.name = r.name || nm; paint(); }
      async function deleteItem(id) { const it = S.items.find(x => x.id === id); if (!it) return; if (!(await UI.confirm(T('Apagar gravação?'), TF('"%s" vai ser apagada do servidor.', it.name), T('Apagar'), true))) return;
        const r = await Bridge.rpcRaw('voicememos.delete', { id }); if (!r || r.error) { UI.toast(errText(r && r.error)); return; } if (S.open === id) closeItem(); S.items = S.items.filter(x => x.id !== id); cache.delete(id); S.cfg.count = S.items.length; Sound.play('click'); paint(); }
      /* PARTILHAR: Mensagens e Zapp recebem uma MENSAGEM DE VOZ (VoiceMsg.uploadData sobe pelo media.* das mensagens, ao
         ritmo do limitador; a mensagem leva só o mediaId). As mensagens de voz têm o limite Config.Media.maxAudioSec. */
      async function shareItem(id) {
        const it = S.items.find(x => x.id === id); if (!it) return;
        const zapp = !!(App.get('recado') && System.isInstalled && System.isInstalled('recado'));
        const buttons = [{ label: App.name('messages'), icon: 'message', value: 'sms' }].concat(zapp ? [{ label: App.name('recado'), icon: 'message', value: 'zapp' }] : []);
        const to = await UI.actionSheet({ title: TF('Partilhar "%s"', it.name), buttons }); if (!to) return;
        if (!VM() || typeof VM().uploadData !== 'function') { UI.toast('Mensagens de voz indisponíveis'); return; }
        if (!window.Contacts || !Contacts.pick) { UI.toast('Contactos indisponíveis'); return; }
        const mc = VM().util && VM().util.cfg ? VM().util.cfg() : { maxSec: 60, maxAudioBytes: 700000 };
        if ((+it.duration || 0) > mc.maxSec * 1000 + 1500) { UI.alert({ title: T('Demasiado longa'), msg: TF('As mensagens de voz têm um limite de %s s. Esta gravação tem %s.', String(mc.maxSec), fmt(it.duration)) }); return; }
        const c = await Contacts.pick(T('Enviar gravação a')); if (!c || !c.number) return;
        UI.toast('A preparar…'); const m = await fetchMemo(id); if (!m || m.error || !m.dataUrl) { UI.toast(errText(m && m.error)); return; }
        if (m.dataUrl.length > mc.maxAudioBytes) { UI.alert({ title: T('Demasiado grande'), msg: T('Esta gravação passa do tamanho que as mensagens de voz aceitam.') }); return; }
        const wave = Array.isArray(it.waveform) ? it.waveform.slice(0, 64) : [];
        /* o VoiceMsg.uploadData já sobe ao ritmo do balde do RecCore (não se soma a um vídeo que esteja a subir) */
        const up = await VM().uploadData(m.dataUrl, { kind: 'audio', mime: m.mime, duration: +it.duration || 0, meta: { waveform: wave } });
        if (!up || !up.mediaId) { Sound.play('error'); UI.toast(VM().errorText ? VM().errorText(up && up.error, T('A gravação não foi enviada')) : T('A gravação não foi enviada')); return; }
        const payload = { mediaId: up.mediaId, duration: +it.duration || 0, waveform: wave };
        const r = to === 'zapp'
          ? await Bridge.rpcRaw('recado.send', { number: c.number, type: 'audio', content: '', payload, mediaId: up.mediaId })
          : await Bridge.rpcRaw('messages.send', { to: c.number, type: 'audio', content: 'Mensagem de voz', payload, mediaId: up.mediaId, app: 'sms' });
        if (!r || r.error) { Sound.play('error'); UI.toast('A gravação não foi enviada'); return; }
        Sound.play('send'); UI.toast(TF('Enviada a %s', c.name || c.number));
      }

      async function loadCfg() { const c = await Bridge.rpcRaw('voicememos.config'); if (c && !c.error) { S.cfg = Object.assign(S.cfg, c); if (c.upload && RC()) RC().setPace(c.upload); } paintCap(); paintLimit(S.rec); }
      async function load() {
        await loadCfg();
        const r = await Bridge.rpcRaw('voicememos.list');
        if (!r || r.error) { list.innerHTML = ''; none.innerHTML = ''; none.hidden = false; none.appendChild(UI.empty('mic', r && r.error === 'disabled' ? 'Gravador desativado' : 'Sem ligação', r && r.error === 'disabled' ? 'O Gravador está desativado neste servidor.' : 'Não foi possível carregar as gravações.')); if (r && r.error === 'disabled') bar.hidden = true; return; }
        list.querySelectorAll('.spinner').forEach(s => s.remove());
        const items = Array.isArray(r.items) ? r.items : (r.items && typeof r.items === 'object' ? Object.values(r.items) : []);
        S.items = items.slice().sort((a, b) => (+b.created || 0) - (+a.created || 0)); paint();
      }
      list.appendChild(UI.spinner()); paintCap(); load();
      /* troca de aparelho com a app aberta: o limite é outro */
      const offFrame = Bridge.on('frame', () => { if (!S.rec) loadCfg(); });
      /* tema trocado com a app aberta: as ondas voltam a desenhar-se com as cores novas */
      const offState = Bridge.on('state', p => { if (p && ('theme' in p || 'dark' in p)) setTimeout(() => { list.querySelectorAll('.vmm-it').forEach(el => { if (el._player) el._player.redraw(); }); if (S.rec) paintLive(S.rec.state === 'recording'); }, 40); });
      /* sair da app NÃO pára a gravação (como no PearPhone: o ponto do microfone fica aceso); só pára o que estiver a tocar */
      win._vmm = { pause: () => { if (S.player) S.player.pause(); }, get state() { return S.rec ? S.rec.state : null; }, get cfg() { return S.cfg; }, finish: () => finishRec('user'), togglePause, start: () => startRec() };
      const prevClose = win.onClose; win.onClose = () => { offState(); offFrame(); if (S.rec && (S.rec.state === 'recording' || S.rec.state === 'paused')) finishRec('close'); else closePanel(); closeItem(); prevClose && prevClose(); };
      UI.setRoot(win, v);
    },
    pause(win) { if (win._vmm) win._vmm.pause(); },
  });

  /* ================= fallback do browser (LocalDB): gravações fictícias + envio aos bocados ================= */
  if (window.LocalDB && LocalDB.register) (() => {
    const TB = () => LocalDB.T('voicememos'); const CH = 48000, MAXPER = 30;
    /* o limite do aparelho vem do mesmo mock do recording.limits (recorder-core.js) */
    const lim = () => { try { const L = window.RecCoreMock && RecCoreMock.limits(); if (L && L.audio) return L.audio; } catch (e) {} return { seconds: 120, maxChars: 1000000, bps: 32000 }; };
    const wavUrl = (seconds, freq) => { const sr = 8000, n = Math.floor(sr * seconds); const buf = new ArrayBuffer(44 + n * 2); const v = new DataView(buf); const w = (o, s) => { for (let i = 0; i < s.length; i++) v.setUint8(o + i, s.charCodeAt(i)); };
      w(0, 'RIFF'); v.setUint32(4, 36 + n * 2, true); w(8, 'WAVE'); w(12, 'fmt '); v.setUint32(16, 16, true); v.setUint16(20, 1, true); v.setUint16(22, 1, true); v.setUint32(24, sr, true); v.setUint32(28, sr * 2, true); v.setUint16(32, 2, true); v.setUint16(34, 16, true); w(36, 'data'); v.setUint32(40, n * 2, true);
      for (let i = 0; i < n; i++) { const t = i / sr; const env = Math.min(1, t * 8, (seconds - t) * 8); v.setInt16(44 + i * 2, Math.sin(2 * Math.PI * freq * t) * env * 11000 * (.6 + .4 * Math.sin(t * 3)), true); }
      let s = ''; const u8 = new Uint8Array(buf); for (let i = 0; i < u8.length; i += 0x8000) s += String.fromCharCode.apply(null, u8.subarray(i, i + 0x8000)); return 'data:audio/wav;base64,' + btoa(s); };
    const wave = seed => { let s = seed >>> 0; return Array.from({ length: 48 }, () => { s = (Math.imul(s, 1103515245) + 12345) >>> 0; return Math.round((.1 + ((s >>> 16) % 100) / 100 * .8) * 100) / 100; }); };
    /* três gravações de exemplo, UMA vez por browser (apagar todas deixa a lista vazia a sério, para o harness ver o estado vazio) */
    const G = Store.global || Store;
    function seed() { if (G.get('db:voicememos_seeded', false)) return; G.set('db:voicememos_seeded', true); if (TB().all().length) return; const t = Date.now();
      [['Ideia para a loja', 2.2, 440, 3 * 36e5, 1], ['Reunião com o Rui', 2.0, 330, 2 * 864e5, 0], ['Lembrete da oficina', 1.6, 520, 5 * 864e5, 0]].forEach(([name, sec, f, ago, fav], i) => {
        const data = wavUrl(sec, f); TB().insert({ owner: 'DEV0000', name, created: t - ago, duration: Math.round(sec * 1000), bytes: data.length, mime: 'audio/wav', waveform: wave(11 + i * 7), favorite: !!fav, complete: 1, data }); }); }
    const mine = () => TB().all().filter(r => r.complete).sort((a, b) => b.created - a.created);
    const pub = r => ({ id: r.id, name: r.name, created: r.created, duration: r.duration, bytes: r.bytes, favorite: !!r.favorite, waveform: r.waveform, mime: r.mime });
    const up = {};
    LocalDB.register('voicememos.config', () => { seed(); const L = lim(); return { enabled: true, maxSeconds: L.seconds, maxPerPlayer: MAXPER, maxBytes: L.maxChars, bps: L.bps, chunk: CH, nameMax: 60, count: mine().length, upload: { bps: 2000000, peak: 4000000, chunk: CH } }; });
    LocalDB.register('voicememos.list', () => { seed(); return { ok: true, items: mine().map(pub), max: MAXPER }; });
    LocalDB.register('voicememos.begin', d => { seed(); const L = lim(); const mime = String(d.mime || '').split(';')[0].toLowerCase(); if (!/^audio\/(webm|ogg|mp4|wav)$/.test(mime)) return { error: 'badmime' }; const size = Math.floor(+d.size || 0); if (size < 1) return { error: 'badsize' }; if (size > L.maxChars) return { error: 'toolarge', max: L.maxChars }; if (+d.duration > L.seconds * 1000 + 1500) return { error: 'toolong' }; if (mine().length >= MAXPER) return { error: 'limit', max: MAXPER };
      const row = TB().insert({ owner: 'DEV0000', name: String(d.name || 'Nova gravação').slice(0, 60), created: Date.now(), duration: Math.round(+d.duration || 0), bytes: size, mime, waveform: Array.isArray(d.waveform) ? d.waveform.slice(0, 64) : null, favorite: false, complete: 0, data: null }); up[row.id] = { size, parts: [], next: 1, len: 0 }; return { id: row.id, chunk: CH }; });
    LocalDB.register('voicememos.upload', d => { const st = up[+d.id]; if (!st) return { error: 'notfound' }; const i = +d.i, total = +d.total, part = String(d.data || ''); if (!part || i < 1 || i > total || total > 512) return { error: 'badchunk' }; if (i !== st.next) return { error: 'order', expected: st.next }; if (part.length > CH) return { error: 'toolarge' }; st.parts[i] = part; st.len += part.length; st.next = i + 1; st.total = total; if (st.len > st.size) { delete up[+d.id]; return { error: 'toolarge' }; } return { ok: true, i }; });
    LocalDB.register('voicememos.finish', d => { const st = up[+d.id]; if (!st) return { error: 'notfound' }; if (st.next - 1 !== st.total) return { error: 'missing' }; if (st.len !== st.size) return { error: 'badsize' }; const data = st.parts.slice(1).join(''); delete up[+d.id]; if (!/^data:audio\//.test(data)) return { error: 'baddata' }; const row = TB().update(+d.id, { data, bytes: data.length, complete: 1 }); return { ok: true, id: +d.id, item: pub(row) }; });
    LocalDB.register('voicememos.get', d => { const r = TB().all().find(x => x.id === +d.id && x.complete); if (!r) return { error: 'notfound' }; const i = Math.max(1, Math.floor(+d.i || 1)); const s = r.data || ''; const total = Math.max(1, Math.ceil(s.length / CH)); if (i > total) return { error: 'badchunk', total }; return { id: r.id, i, total, size: s.length, mime: r.mime, duration: r.duration, data: s.slice((i - 1) * CH, i * CH) }; });
    LocalDB.register('voicememos.rename', d => { const r = TB().all().find(x => x.id === +d.id); if (!r) return { error: 'notfound' }; const name = String(d.name || '').trim().slice(0, 60); if (!name) return { error: 'invalid' }; TB().update(r.id, { name }); return { ok: true, id: r.id, name }; });
    LocalDB.register('voicememos.delete', d => { const r = TB().all().find(x => x.id === +d.id); if (!r) return { error: 'notfound' }; TB().remove(r.id); return { ok: true, id: r.id }; });
    LocalDB.register('voicememos.favorite', d => { const r = TB().all().find(x => x.id === +d.id); if (!r) return { error: 'notfound' }; TB().update(r.id, { favorite: d.on === true }); return { ok: true, id: r.id, favorite: d.on === true }; });
  })();
})();
