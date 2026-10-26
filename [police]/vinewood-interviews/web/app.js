(() => {
  'use strict';

  const RES = typeof window.GetParentResourceName === 'function' ? window.GetParentResourceName() : 'vinewood-interviews';
  async function post(name, data = {}) {
    try {
      const r = await fetch(`https://${RES}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data),
      });
      return await r.json();
    } catch { return null; }
  }

  const $ = (s) => document.querySelector(s);
  const pad = (n) => String(n).padStart(2, '0');
  const tc = (ms) => {
    const s = Math.max(0, Math.floor(ms / 1000));
    return `${pad(Math.floor(s / 3600))}:${pad(Math.floor(s / 60) % 60)}:${pad(s % 60)}`;
  };
  const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const clockFmt = new Intl.DateTimeFormat('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false });
  const listFmt = new Intl.DateTimeFormat('en-GB', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false });
  const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

  /* ════════════════════════════════════════════════════════════
     Microphone recorder
     One cloned mic track per segment. Gating flips track.enabled,
     which records silence instead of pausing, so every speaker's
     track stays aligned with the session timeline.
     ════════════════════════════════════════════════════════════ */
  const Rec = { stream: null, segs: new Map(), cancelled: new Set(), gate: false, closeTimer: 0, releaseTimer: 0 };

  /* Level meter on the live mic: measures what each track really captured, and drives the
     'level' gate mode. Connected through a muted gain so Chrome keeps processing it. */
  const Meter = { ctx: null, stream: null, src: null, an: null, sink: null, buf: null, timer: 0, levelOpen: false, lastLoud: 0 };

  function meterFor(stream) {
    try {
      if (!Meter.ctx || Meter.ctx.state === 'closed') Meter.ctx = new AudioContext();
      if (Meter.ctx.state === 'suspended') Meter.ctx.resume().catch(() => {});
      if (Meter.stream !== stream) {
        try { Meter.src?.disconnect(); } catch {}
        Meter.src = Meter.ctx.createMediaStreamSource(stream);
        Meter.an = Meter.ctx.createAnalyser();
        Meter.an.fftSize = 1024;
        Meter.buf = new Float32Array(Meter.an.fftSize);
        Meter.sink = Meter.ctx.createGain();
        Meter.sink.gain.value = 0;
        Meter.src.connect(Meter.an);
        Meter.an.connect(Meter.sink);
        Meter.sink.connect(Meter.ctx.destination);
        Meter.stream = stream;
      }
    } catch { Meter.an = null; }
  }

  function levelDb() {
    if (!Meter.an || Meter.ctx.state !== 'running') return null;
    Meter.an.getFloatTimeDomainData(Meter.buf);
    let sum = 0;
    for (let i = 0; i < Meter.buf.length; i++) sum += Meter.buf[i] * Meter.buf[i];
    const rms = Math.sqrt(sum / Meter.buf.length);
    return rms > 0 ? 20 * Math.log10(rms) : -120;
  }

  function meterTick() {
    const db = levelDb();
    const now = performance.now();
    Rec.segs.forEach((seg) => {
      if (seg.gate === 'level') {
        if (db === null) {
          seg.track.enabled = true; // can't measure, so record rather than lose speech
        } else {
          if (db > seg.thresholdDb) Meter.lastLoud = now;
          seg.track.enabled = now - Meter.lastLoud < 700;
        }
      }
      if (seg.track.enabled) {
        seg.openMs += 50;
        if (db !== null) seg.peakDb = Math.max(seg.peakDb, db);
      }
    });
  }

  function ensureMeterLoop() {
    if (Meter.timer) return;
    Meter.timer = setInterval(() => {
      if (!Rec.segs.size) { clearInterval(Meter.timer); Meter.timer = 0; return; }
      meterTick();
    }, 50);
  }

  function pickMime() {
    if (!window.MediaRecorder) return '';
    return ['audio/webm;codecs=opus', 'audio/webm', 'audio/ogg;codecs=opus'].find((t) => MediaRecorder.isTypeSupported(t)) || '';
  }

  async function ensureMic() {
    clearTimeout(Rec.releaseTimer);
    if (Rec.stream && Rec.stream.getAudioTracks().some((t) => t.readyState === 'live')) return;
    Rec.stream = await navigator.mediaDevices.getUserMedia({
      audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true },
      video: false,
    });
  }

  function scheduleRelease() {
    clearTimeout(Rec.releaseTimer);
    Rec.releaseTimer = setTimeout(() => {
      if (Rec.segs.size) return;
      Rec.stream?.getTracks().forEach((t) => t.stop());
      Rec.stream = null;
    }, 5000);
  }

  async function recStart({ segmentId, bitrate, gate, thresholdDb }) {
    gate = gate || 'voice';
    try {
      await ensureMic();
    } catch (e) {
      post('recFailed', { segmentId, reason: e?.name || String(e) });
      return;
    }
    if (Rec.cancelled.delete(segmentId)) {
      post('recFailed', { segmentId, reason: 'cancelled' });
      scheduleRelease();
      return;
    }
    const mime = pickMime();
    if (!mime) {
      post('recFailed', { segmentId, reason: 'no supported audio codec' });
      return;
    }
    meterFor(Rec.stream);
    const track = Rec.stream.getAudioTracks()[0].clone();
    track.enabled = gate === 'off' || (gate === 'voice' && Rec.gate);
    const mr = new MediaRecorder(new MediaStream([track]), { mimeType: mime, audioBitsPerSecond: bitrate || 48000 });
    const seg = { segmentId, track, mr, chunks: [], mime, gate, thresholdDb: Number(thresholdDb) || -45, t0: 0, openMs: 0, peakDb: -120 };
    mr.ondataavailable = (e) => { if (e.data && e.data.size) seg.chunks.push(e.data); };
    Rec.segs.set(segmentId, seg);
    mr.start(1000);
    seg.t0 = performance.now();
    ensureMeterLoop();
    post('recStarted', { segmentId });
  }

  function recGate(open) {
    Rec.gate = open;
    clearTimeout(Rec.closeTimer);
    const apply = (v) => Rec.segs.forEach((s) => { if (s.gate === 'voice') s.track.enabled = v; });
    if (open) apply(true);
    else Rec.closeTimer = setTimeout(() => apply(false), 350); // hangover so word endings are not clipped
  }

  async function uploadBlob(url, blob, filename) {
    let lastErr;
    for (let attempt = 0; attempt < 2; attempt++) {
      try {
        const fd = new FormData();
        fd.append('file', blob, filename);
        let res = await fetch(url, { method: 'POST', body: fd });
        if (!res.ok && (res.status === 405 || res.status === 415)) {
          res = await fetch(url, { method: 'PUT', body: blob, headers: { 'Content-Type': blob.type } });
        }
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const j = await res.json().catch(() => null);
        const out = j?.data?.url || j?.url || j?.data?.originalUrl;
        if (!out) throw new Error('no URL in upload response');
        return out;
      } catch (e) {
        lastErr = e;
        await sleep(1500);
      }
    }
    throw lastErr;
  }

  async function recStop({ segmentId, uploadUrl, filename }) {
    const seg = Rec.segs.get(segmentId);
    if (!seg) { Rec.cancelled.add(segmentId); return; }
    await new Promise((res) => {
      seg.mr.onstop = res;
      try { seg.mr.stop(); } catch { res(); }
    });
    const durationMs = Math.round(performance.now() - seg.t0);
    seg.track.stop();
    Rec.segs.delete(segmentId);
    scheduleRelease();

    if (!uploadUrl) { post('recUploadFailed', { segmentId, reason: 'no upload URL (check the API key convar)' }); return; }
    const type = seg.mime.split(';')[0];
    const blob = new Blob(seg.chunks, { type });
    const ext = type.includes('ogg') ? 'ogg' : 'webm';
    try {
      const url = await uploadBlob(uploadUrl, blob, `${filename || segmentId}.${ext}`);
      const measured = Meter.an && Meter.ctx?.state === 'running';
      post('recUploaded', { segmentId, url, durationMs, openMs: seg.openMs, peakDb: measured ? Math.round(seg.peakDb) : null });
    } catch (e) {
      post('recUploadFailed', { segmentId, reason: String(e?.message || e) });
    }
  }

  async function micTest() {
    let stream;
    try {
      stream = await navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true } });
      const device = stream.getAudioTracks()[0]?.label || '';
      meterFor(stream);
      const mime = pickMime();
      const mr = new MediaRecorder(stream, mime ? { mimeType: mime } : undefined);
      const chunks = [];
      mr.ondataavailable = (e) => e.data.size && chunks.push(e.data);
      mr.start();
      let peak = -120;
      let measured = false;
      const end = performance.now() + 4000;
      while (performance.now() < end) {
        const db = levelDb();
        if (db !== null) { measured = true; peak = Math.max(peak, db); }
        await sleep(50);
      }
      await new Promise((r) => { mr.onstop = r; mr.stop(); });
      stream.getTracks().forEach((t) => t.stop());
      Meter.stream = null;
      const audio = new Audio(URL.createObjectURL(new Blob(chunks, { type: mr.mimeType })));
      audio.play().catch(() => {});
      post('micTestResult', { ok: true, device, peakDb: measured ? Math.round(peak) : null });
    } catch (e) {
      stream?.getTracks().forEach((t) => t.stop());
      post('micTestResult', { ok: false, reason: e?.name || String(e) });
    }
  }

  /* ════════════════════════════════════════════════════════════
     HUD
     ════════════════════════════════════════════════════════════ */
  const hud = { base: 0, timer: 0 };
  const MIC_TEXT = {
    live: 'Your voice is recorded while you speak',
    starting: 'Connecting your microphone',
    failed: 'Your microphone is not being recorded',
    outside: 'You are outside the recording area',
    off: 'Audio recording is off',
  };
  function showHud(d) {
    const el = $('#hud');
    clearInterval(hud.timer);
    if (!d.show) { el.hidden = true; return; }
    $('#hud-room').textContent = d.room || '';
    $('#hud-mode').textContent = d.mode || '';
    const mic = $('#hud-mic');
    mic.textContent = MIC_TEXT[d.mic] || '';
    mic.classList.toggle('bad', d.mic === 'failed');
    hud.base = Date.now() - (d.elapsed || 0);
    const tick = () => { $('#hud-time').textContent = tc(Date.now() - hud.base); };
    tick();
    hud.timer = setInterval(tick, 1000);
    el.hidden = false;
  }

  /* ════════════════════════════════════════════════════════════
     Synced playback
     A master clock drives every media element. Each file sits on
     the timeline at its offset; elements play only while the
     clock is inside their range and are re-synced if they drift.
     ════════════════════════════════════════════════════════════ */
  const P = { lanes: [], items: [], t: 0, dur: 0, playing: false, buffering: false, rate: 1, last: 0, raf: 0, session: null, replay: false, lastClock: 0 };

  /* Audio: recorded WebM has no duration or seek index, so <audio> can't jump into it.
     Each file is downloaded and decoded with Web Audio instead, which can start at any
     point. If the download is blocked, fall back to <audio> with the duration fix. */
  const AE = { ctx: null, buffers: new Map(), maxCached: 8 };

  function actx() {
    if (!AE.ctx || AE.ctx.state === 'closed') {
      try { AE.ctx = new AudioContext({ sampleRate: 24000 }); } catch { AE.ctx = new AudioContext(); }
    }
    if (AE.ctx.state === 'suspended') AE.ctx.resume().catch(() => {});
    return AE.ctx;
  }

  function laneGain(lane) {
    const ctx = actx();
    if (!lane.gain || lane.gain.context !== ctx) {
      lane.gain = ctx.createGain();
      lane.gain.connect(ctx.destination);
    }
    lane.gain.gain.value = lane.muted ? 0 : 1;
    return lane.gain;
  }

  function evictBuffers(keep) {
    const ready = [...AE.buffers.entries()].filter(([u, e]) => e.state === 'ready' && !keep.has(u));
    if (AE.buffers.size <= AE.maxCached) return;
    ready.sort((x, y) => x[1].used - y[1].used);
    while (AE.buffers.size > AE.maxCached && ready.length) AE.buffers.delete(ready.shift()[0]);
  }

  function getBuffer(item) {
    const url = item.m.url;
    let e = AE.buffers.get(url);
    if (!e) {
      e = { state: 'loading', buf: null, used: performance.now() };
      AE.buffers.set(url, e);
      fetch(url)
        .then((r) => { if (!r.ok) throw new Error(`HTTP ${r.status}`); return r.arrayBuffer(); })
        .then((ab) => actx().decodeAudioData(ab))
        .then((buf) => { e.state = 'ready'; e.buf = buf; if (P.playing) sync(true); })
        .catch(() => { e.state = 'failed'; makeFallback(item); if (P.playing) sync(true); });
    }
    e.used = performance.now();
    return e;
  }

  function stopSrc(item) {
    if (!item.src) return;
    const src = item.src;
    item.src = null;
    try { src.stop(); } catch {}
    try { src.disconnect(); } catch {}
  }

  function startSrc(item, buf, local) {
    if (local < 0 || local >= buf.duration) return;
    const ctx = actx();
    const src = ctx.createBufferSource();
    src.buffer = buf;
    src.playbackRate.value = P.rate;
    src.connect(laneGain(item.lane));
    src.onended = () => { if (item.src === src) item.src = null; };
    src.start(0, local);
    item.src = src;
    item.srcCtx = ctx.currentTime;
    item.srcLocal = local;
  }

  // <audio> fallback. Seeking to the far end makes Chrome scan the file and work out its
  // real duration; after that it can seek normally.
  function makeFallback(item) {
    if (item.el) return;
    const el = new Audio();
    el.preload = 'auto';
    el.muted = item.lane.muted;
    prepSeekable(el, item);
    el.src = item.m.url;
  }

  // Recorded WebM often reports an endless duration and can't seek. Seeking to the far end
  // makes Chrome scan the file for its real length; after that it seeks normally.
  function prepSeekable(el, item) {
    item.el = el;
    item.elReady = false;
    el.addEventListener('loadedmetadata', () => {
      if (el.duration === Infinity || Number.isNaN(el.duration)) {
        const done = () => {
          if (el.duration === Infinity || Number.isNaN(el.duration)) return;
          el.removeEventListener('durationchange', done);
          el.currentTime = 0;
          item.elReady = true;
        };
        el.addEventListener('durationchange', done);
        el.currentTime = 1e101;
      } else {
        item.elReady = true;
      }
    }, { once: true });
    el.addEventListener('error', () => { item.elFailed = true; }, { once: true });
  }

  function setLaneMuted(lane, muted) {
    lane.muted = muted;
    if (lane.gain) lane.gain.gain.value = muted ? 0 : 1;
    lane.items.forEach((it) => { if (it.el) it.el.muted = muted || it.m.kind === 'video'; });
  }

  function teardown() {
    cancelAnimationFrame(P.raf);
    P.items.forEach((it) => {
      stopSrc(it);
      if (!it.el) return;
      it.el.pause();
      it.el.removeAttribute('src');
      it.el.load();
      it.el.remove();
    });
    P.lanes.forEach((l) => { try { l.gain?.disconnect(); } catch {} l.gain = null; });
    AE.buffers.clear();
    P.items = []; P.lanes = []; P.t = 0; P.playing = false; P.buffering = false;
  }

  function loadPlayer(session, media) {
    teardown();
    P.session = session;
    const screen = $('#screen');

    const lanes = new Map();
    for (const m of media) {
      const key = m.kind === 'video' ? '__video' : (m.speaker_id || m.speaker_name || 'unknown');
      if (!lanes.has(key)) {
        lanes.set(key, {
          key, kind: m.kind, muted: false, items: [], gain: null,
          label: m.kind === 'video' ? 'CCTV footage' : (m.speaker_name || 'Unknown speaker'),
        });
      }
      const lane = lanes.get(key);
      const item = { m, lane, offset: Number(m.offset_ms) || 0, dur: Number(m.duration_ms) || 0, ok: m.status === 'ok' && !!m.url, el: null, src: null };
      if (item.ok && m.kind === 'video') {
        const el = document.createElement('video');
        el.preload = 'auto';
        el.muted = true;
        el.playsInline = true;
        prepSeekable(el, item);
        el.src = m.url;
        screen.insertBefore(el, screen.firstChild);
      }
      lane.items.push(item);
      P.items.push(item);
    }
    P.lanes = [...lanes.values()].sort((a, b) => (a.kind === 'video' ? -1 : b.kind === 'video' ? 1 : a.label.localeCompare(b.label)));
    const mediaEnd = P.items.reduce((mx, it) => Math.max(mx, it.offset + it.dur), 0);
    P.dur = Math.max(Number(session.duration_ms) || 0, mediaEnd, 1000);

    renderLanes();
    P.last = performance.now();
    P.raf = requestAnimationFrame(tick);
    setPlaying(false);
    sync(true);
  }

  function renderLanes() {
    const wrap = $('#lanes');
    wrap.innerHTML = '';
    if (!P.lanes.length) {
      wrap.innerHTML = '<div class="lane"><div class="lane-label"><span>No files yet</span></div><div class="track"></div></div>';
      return;
    }
    for (const lane of P.lanes) {
      const row = document.createElement('div');
      row.className = `lane ${lane.kind}`;
      const segs = lane.items.map((it) => {
        const left = (it.offset / P.dur) * 100;
        const width = Math.max(0.3, ((it.ok ? it.dur : Math.max(it.dur, P.dur * 0.01)) / P.dur) * 100);
        const silent = it.ok && (it.m.note || '').startsWith('silent');
        const title = it.ok ? `${tc(it.offset)} to ${tc(it.offset + it.dur)}${it.m.note ? `, ${it.m.note}` : ''}` : `Missing: ${it.m.note || 'upload failed'}`;
        return `<div class="seg${it.ok ? '' : ' failed'}${silent ? ' silent' : ''}" style="left:${left}%;width:${width}%" title="${esc(title)}"></div>`;
      }).join('');
      const mute = lane.kind === 'audio' ? `<button type="button" class="mute" aria-pressed="false">Mute</button>` : '';
      row.innerHTML = `<div class="lane-label">${mute}<span title="${esc(lane.label)}">${esc(lane.label)}</span></div><div class="track">${segs}</div>`;
      const btn = row.querySelector('.mute');
      if (btn) {
        btn.addEventListener('click', () => {
          setLaneMuted(lane, !lane.muted);
          btn.setAttribute('aria-pressed', String(lane.muted));
          row.classList.toggle('muted', lane.muted);
        });
      }
      row.querySelector('.track').addEventListener('pointerdown', (e) => seekFromPointer(e));
      wrap.appendChild(row);
    }
  }

  function seekFromPointer(e) {
    const r = e.currentTarget.getBoundingClientRect();
    seek(((e.clientX - r.left) / r.width) * P.dur);
  }

  function seek(ms) {
    P.t = Math.min(Math.max(0, ms), P.dur);
    sync(true);
  }

  function setPlaying(on) {
    if (on && P.t >= P.dur) P.t = 0;
    P.playing = on;
    if (on) actx(); // unlock audio on the click that pressed play
    $('#play').textContent = on ? 'Pause' : 'Play';
    $('#r-play').textContent = on ? 'Pause' : 'Play';
    sync(true);
  }

  function syncElement(it, inRange, local, force) {
    if (!it.elReady) return !it.elFailed && inRange;
    it.el.playbackRate = P.rate;
    if (inRange && P.playing && !P.buffering) {
      if (it.el.paused) {
        it.el.currentTime = local;
        it.el.play().catch(() => {});
      } else if (force || Math.abs(it.el.currentTime - local) > 0.4) {
        it.el.currentTime = local;
      }
    } else {
      if (!it.el.paused) it.el.pause();
      if (inRange && force && it.m.kind === 'video') it.el.currentTime = local;
    }
    return false;
  }

  function sync(force) {
    let videoShown = false;
    let waiting = false;
    const keep = new Set();

    for (const it of P.items) {
      if (!it.ok) continue;
      const inRange = P.t >= it.offset && P.t < it.offset + it.dur;
      const local = (P.t - it.offset) / 1000;

      if (it.m.kind === 'video') {
        if (P.replay) { if (!it.el.paused) it.el.pause(); continue; }
        it.el.classList.toggle('on', inRange && !videoShown);
        if (inRange) videoShown = true;
        syncElement(it, inRange, local, force);
        continue;
      }

      // Audio: preload anything playing now or starting in the next 20 seconds.
      const soon = it.offset + it.dur > P.t && it.offset - P.t < 20000;
      if (it.el) {
        if (syncElement(it, inRange, local, force)) waiting = true;
        continue;
      }
      if (!soon && !inRange) { stopSrc(it); continue; }
      const e = getBuffer(it);
      keep.add(it.m.url);
      if (e.state === 'failed') { stopSrc(it); continue; }
      if (e.state !== 'ready') { if (inRange) waiting = true; stopSrc(it); continue; }

      if (inRange && P.playing && !P.buffering) {
        if (it.src) {
          const actual = it.srcLocal + (actx().currentTime - it.srcCtx) * P.rate;
          if (force || Math.abs(actual - local) > 0.25) stopSrc(it);
        }
        if (!it.src) startSrc(it, e.buf, local);
      } else {
        stopSrc(it);
      }
    }
    evictBuffers(keep);

    // Hold the clock while audio that should be playing is still downloading.
    const wasBuffering = P.buffering;
    P.buffering = P.playing && waiting;
    const status = P.buffering ? 'Loading audio' : '';
    $('#a-status').textContent = status;
    $('#r-status').textContent = status;
    if (P.buffering !== wasBuffering) {
      if (!P.buffering) sync(true);
      if (P.replay) sendClock();
    }

    $('#novideo').hidden = videoShown;
    if (P.replay && force) sendClock();
  }

  function sendClock() {
    P.lastClock = performance.now();
    post('replay:clock', { t: P.t, playing: P.playing && !P.buffering, rate: P.rate });
  }

  function tick(now) {
    const dt = now - P.last;
    P.last = now;
    if (P.playing) {
      if (!P.buffering) {
        P.t += dt * P.rate;
        if (P.t >= P.dur) { P.t = P.dur; setPlaying(false); }
      }
      sync(false);
    }
    $('#tc').textContent = `${tc(P.t)} / ${tc(P.dur)}`;
    if (P.session) $('#burn-clock').textContent = clockFmt.format(new Date(P.session.started_at * 1000 + P.t));
    if (P.replay) {
      $('#r-tc').textContent = `${tc(P.t)} / ${tc(P.dur)}`;
      if (P.session) $('#r-clock').textContent = clockFmt.format(new Date(P.session.started_at * 1000 + P.t));
      if (!R.dragging) $('#r-seek').value = String(Math.round((P.t / P.dur) * 1000));
      if (now - P.lastClock > 250) sendClock();
    }
    const track = document.querySelector('.track');
    if (track) {
      const tl = $('#timeline').getBoundingClientRect();
      const tr = track.getBoundingClientRect();
      $('#playhead').style.left = `${tr.left - tl.left + (P.t / P.dur) * tr.width}px`;
    }
    P.raf = requestAnimationFrame(tick);
  }

  /* ════════════════════════════════════════════════════════════
     CCTV replay mode
     The viewer hides, the game shows the reconstruction from the
     ceiling camera, and this bar drives the shared clock.
     ════════════════════════════════════════════════════════════ */
  const R = { dragging: false, busy: false };

  async function enterReplay() {
    if (R.busy || !V.current) return;
    R.busy = true;
    const btns = [$('#replay-open'), $('#replay-open-2')];
    btns.forEach((b) => { b.dataset.label = b.textContent; b.textContent = 'Loading replay'; b.disabled = true; });
    const wasPlaying = P.playing;
    setPlaying(false);
    const res = await post('replay:start', { sessionId: V.current.id });
    btns.forEach((b) => { b.textContent = b.dataset.label; b.disabled = false; });
    R.busy = false;
    if (!res || !res.ok) {
      $('#novideo-text').textContent = res && res.err === 'no_replay'
        ? 'There is no CCTV replay for this recording.'
        : 'The CCTV replay could not be loaded. Check the server console.';
      return;
    }
    P.replay = true;
    P.dur = Math.max(P.dur, Number(res.duration) || 0);
    $('#viewer').hidden = true;
    $('#replaybar').hidden = false;
    sync(true);
    if (wasPlaying) setPlaying(true);
  }

  function exitReplay() {
    if (!P.replay) return;
    P.replay = false;
    setPlaying(false);
    post('replay:stop');
    $('#replaybar').hidden = true;
    $('#viewer').hidden = false;
    sync(true);
  }

  $('#replay-open').addEventListener('click', enterReplay);
  $('#replay-open-2').addEventListener('click', enterReplay);
  $('#r-exit').addEventListener('click', exitReplay);
  $('#r-play').addEventListener('click', () => setPlaying(!P.playing));
  $('#r-seek').addEventListener('input', (e) => { R.dragging = true; seek((Number(e.target.value) / 1000) * P.dur); });
  $('#r-seek').addEventListener('change', () => { R.dragging = false; });

  /* ════════════════════════════════════════════════════════════
     Viewer UI
     ════════════════════════════════════════════════════════════ */
  const V = { page: 0, search: '', roomId: null, current: null, admin: false, searchTimer: 0, hasReplay: false };

  const STATUS = { recording: 'Recording now', complete: 'Complete', interrupted: 'Interrupted by a restart' };

  function openViewer(d) {
    V.roomId = d.roomId || null;
    $('#filter').hidden = !V.roomId;
    $('#filter-label').textContent = d.roomLabel ? `Showing ${d.roomLabel} only` : '';
    $('#viewer').hidden = false;
    $('#search').value = '';
    V.search = '';
    loadList(true);
    $('#search').focus();
  }

  function closeViewer() {
    if (P.replay) { P.replay = false; post('replay:stop'); $('#replaybar').hidden = true; }
    teardown();
    V.current = null;
    $('#detail').hidden = true;
    $('#empty').hidden = false;
    $('#viewer').hidden = true;
    post('viewer:close');
  }

  async function loadList(reset) {
    if (reset) { V.page = 0; $('#sessions').innerHTML = ''; }
    const res = await post('viewer:list', { page: V.page, search: V.search, roomId: V.roomId });
    if (!res || res.err) { $('#list-empty').textContent = 'You cannot view interview recordings.'; $('#list-empty').hidden = false; return; }
    V.admin = !!res.admin;
    const ul = $('#sessions');
    for (const row of res.rows || []) {
      const li = document.createElement('li');
      const ref = row.case_ref ? `<span class="ref">${esc(row.case_ref)}</span>` : '<span class="ref none">No case reference</span>';
      const status = row.status === 'recording' ? `<span class="live">${STATUS.recording}</span>`
        : row.status === 'interrupted' ? `<span class="warn">${STATUS.interrupted}</span>` : '';
      li.innerHTML = `<button type="button" class="tag" data-id="${row.id}">
        ${ref}
        <span class="who">${esc(row.interviewee || 'Interviewee not recorded')}</span>
        <span class="meta"><time>${listFmt.format(new Date(row.started_at * 1000))}</time><span>${esc(row.room_label || '')}</span><span class="num">${tc(row.duration_ms)}</span><span>${Number(row.has_replay) ? 'Audio and CCTV' : 'Audio only'}</span>${status}</span>
      </button>`;
      li.firstElementChild.addEventListener('click', () => openSession(row.id));
      ul.appendChild(li);
    }
    $('#list-empty').textContent = 'No recordings match.';
    $('#list-empty').hidden = ul.children.length > 0;
    $('#more').hidden = !res.more;
  }

  async function openSession(id) {
    document.querySelectorAll('.tag').forEach((b) => b.setAttribute('aria-current', String(Number(b.dataset.id) === id)));
    const res = await post('viewer:get', { id });
    if (!res || res.err) return;
    V.current = res.session;
    $('#empty').hidden = true;
    $('#detail').hidden = false;
    $('#burn-room').textContent = res.session.room_label || '';

    const s = res.session;
    const facts = [
      ['Case reference', s.case_ref || 'None given'],
      ['Interviewee', (s.interviewee || 'Not recorded') + (s.interviewee_cid ? ` (MDT ${s.interviewee_cid})` : '')],
      ['Officers present', s.officers || s.officer_name || 'Not recorded'],
      ['Solicitor', s.solicitor || 'None present'],
      ['Started by', s.officer_name || 'Unknown'],
      ['Room', s.room_label || ''],
      ['Started', clockFmt.format(new Date(s.started_at * 1000))],
      ['Length', tc(s.duration_ms)],
      ['Recorded', res.replay ? 'Audio and CCTV' : 'Audio only'],
      ['Status', STATUS[s.status] || s.status],
    ];
    if (s.notes) facts.push(['Notes', s.notes]);
    $('#facts').innerHTML = facts.map(([k, v]) => `<dt>${esc(k)}</dt><dd>${esc(v)}</dd>`).join('');

    const files = $('#files');
    files.innerHTML = '';
    if (!res.media.length) files.innerHTML = '<li>No files uploaded yet.</li>';
    for (const m of res.media) {
      const li = document.createElement('li');
      const who = m.kind === 'video' ? 'CCTV footage' : (m.speaker_name || 'Unknown');
      if (m.status === 'ok' && m.url) {
        const silent = (m.note || '').startsWith('silent');
        const note = m.note ? `<span class="${silent ? 'warn-note' : 'ok-note'}">${esc(m.note)}</span>` : '';
        li.innerHTML = `<span>${esc(who)} <span class="num">${tc(m.offset_ms)}</span>${note}</span><button type="button">Copy link</button>`;
        li.querySelector('button').addEventListener('click', (e) => copy(m.url, e.currentTarget));
      } else {
        li.innerHTML = `<span>${esc(who)} <span class="bad">missing: ${esc(m.note || 'upload failed')}</span></span>`;
      }
      files.appendChild(li);
    }

    const dc = $('#discord');
    dc.hidden = !res.discord;
    dc.disabled = false;
    dc.textContent = 'Send to Discord';
    $('#discord-msg').hidden = true;

    const del = $('#delete');
    del.hidden = !res.admin;
    del.classList.remove('armed');
    del.textContent = 'Delete recording';

    V.hasReplay = !!res.replay;
    $('#replay-open').hidden = !V.hasReplay;
    $('#replay-open-2').hidden = !V.hasReplay;
    $('#novideo-text').textContent = V.hasReplay
      ? 'No real footage at this point (no officer in the officer seat). The CCTV replay covers the whole interview.'
      : 'Audio only interview. No CCTV was recorded.';

    loadPlayer(res.session, res.media);
  }

  function copy(text, btn) {
    const ta = $('#clip');
    ta.value = text;
    ta.select();
    document.execCommand('copy');
    const old = btn.textContent;
    btn.textContent = 'Copied';
    setTimeout(() => { btn.textContent = old; }, 1200);
  }

  $('#discord').addEventListener('click', async (e) => {
    const btn = e.currentTarget;
    if (btn.disabled || !V.current) return;
    btn.disabled = true;
    btn.textContent = 'Sending';
    const res = await post('viewer:discord', { id: V.current.id });
    const msg = $('#discord-msg');
    btn.disabled = false;
    btn.textContent = 'Send to Discord';
    msg.hidden = false;
    msg.classList.toggle('bad', !(res && res.ok));
    msg.textContent = res && res.ok ? 'Posted to the evidence channel.' : (res?.err || 'Could not send it.');
  });

  $('#delete').addEventListener('click', async (e) => {
    const btn = e.currentTarget;
    if (!btn.classList.contains('armed')) {
      btn.classList.add('armed');
      btn.textContent = 'Click again to delete for good';
      setTimeout(() => { btn.classList.remove('armed'); btn.textContent = 'Delete recording'; }, 4000);
      return;
    }
    const res = await post('viewer:delete', { id: V.current?.id });
    if (res && res.ok) {
      teardown();
      $('#detail').hidden = true;
      $('#empty').hidden = false;
      loadList(true);
    } else {
      btn.textContent = 'Could not delete. It may still be recording.';
    }
  });

  $('#play').addEventListener('click', () => setPlaying(!P.playing));
  $('#back').addEventListener('click', () => seek(P.t - 10000));
  $('#fwd').addEventListener('click', () => seek(P.t + 10000));
  $('#rate').addEventListener('change', (e) => { P.rate = Number(e.target.value) || 1; sync(true); });
  $('#close').addEventListener('click', closeViewer);
  $('#more').addEventListener('click', () => { V.page += 1; loadList(false); });
  $('#filter-clear').addEventListener('click', () => { V.roomId = null; $('#filter').hidden = true; loadList(true); });
  $('#search').addEventListener('input', (e) => {
    clearTimeout(V.searchTimer);
    V.searchTimer = setTimeout(() => { V.search = e.target.value.trim(); loadList(true); }, 300);
  });

  document.addEventListener('keydown', (e) => {
    if (D.open) {
      if (e.key === 'Escape') {
        if (!$('#who-results').hidden) hideResults();
        else closeDialog(true);
      }
      return;
    }
    if (P.replay) {
      if (e.key === 'Escape' || e.key === 'Backspace') return exitReplay();
      if (e.key === ' ') { e.preventDefault(); setPlaying(!P.playing); }
      if (e.key === 'ArrowLeft') seek(P.t - 5000);
      if (e.key === 'ArrowRight') seek(P.t + 5000);
      return;
    }
    if ($('#viewer').hidden) return;
    if (e.key === 'Escape') return closeViewer();
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT' || !V.current) return;
    if (e.key === ' ') { e.preventDefault(); setPlaying(!P.playing); }
    if (e.key === 'ArrowLeft') seek(P.t - 5000);
    if (e.key === 'ArrowRight') seek(P.t + 5000);
  });

  /* ════════════════════════════════════════════════════════════
     Start / end recording dialogs
     ════════════════════════════════════════════════════════════ */
  const D = { roomId: null, open: null, timer: 0, base: 0, officers: [], text: {}, mdt: false, person: null, results: [], active: -1, searchTimer: 0, searchSeq: 0 };

  /* ── MDT person search ── */
  const dobFmt = (v) => {
    if (!v) return '';
    const m = String(v).match(/^(\d{4})-(\d{2})-(\d{2})/);
    return m ? `${m[3]}/${m[2]}/${m[1]}` : String(v);
  };

  function hideResults() {
    $('#who-results').hidden = true;
    $('#f-who').setAttribute('aria-expanded', 'false');
    D.active = -1;
  }

  function renderResults(list) {
    const ul = $('#who-results');
    D.results = list;
    D.active = -1;
    if (!list.length) {
      ul.innerHTML = `<li class="empty">${esc(D.text.mdtNoMatch || 'No match')}</li>`;
    } else {
      ul.innerHTML = list.map((p, i) => {
        const meta = [p.dob ? `DOB ${dobFmt(p.dob)}` : '', p.online ? `<span class="p-online">${esc(D.text.mdtInCity || 'In the city')}</span>` : '']
          .filter(Boolean).join(' &middot; ');
        return `<li role="option"><button type="button" data-i="${i}"><span class="p-name">${esc(p.name)}</span><span class="p-meta">${meta}</span></button></li>`;
      }).join('');
      ul.querySelectorAll('button').forEach((b) => b.addEventListener('mousedown', (e) => {
        e.preventDefault(); // keep focus in the input so blur doesn't close the list first
        pickPerson(D.results[Number(b.dataset.i)]);
      }));
    }
    ul.hidden = false;
    $('#f-who').setAttribute('aria-expanded', 'true');
  }

  async function searchPeople(q) {
    const seq = ++D.searchSeq;
    const res = await post('mdt:people', { q });
    if (seq !== D.searchSeq || D.person) return;
    renderResults(Array.isArray(res) ? res : []);
  }

  function unlinkPerson() {
    D.person = null;
    $('#who-linked').hidden = true;
    $('#case-picker').hidden = true;
    $('#case-list').innerHTML = '';
  }

  async function pickPerson(p) {
    if (!p) return;
    D.person = p;
    $('#f-who').value = p.name;
    hideResults();
    $('#who-linked-meta').textContent = [p.dob ? `DOB ${dobFmt(p.dob)}` : '', p.cid].filter(Boolean).join(', ');
    $('#who-linked').hidden = false;

    const picker = $('#case-picker');
    const list = $('#case-list');
    list.innerHTML = '';
    $('#cases-head').textContent = '';
    picker.hidden = false;
    const cases = await post('mdt:cases', { cid: p.cid });
    if (D.person !== p) return;
    if (!Array.isArray(cases) || !cases.length) {
      $('#cases-head').textContent = D.text.mdtNoCases || '';
      return;
    }
    $('#cases-head').textContent = D.text.mdtCases || '';
    list.innerHTML = cases.map((c, i) => {
      const when = c.createdAt ? listFmt.format(new Date(c.createdAt * 1000)) : '';
      const kind = c.kind === 'incident' ? 'Incident' : 'Custody';
      const meta = [kind, c.status, when].filter(Boolean).map(esc).join(' &middot; ');
      return `<li><button type="button" class="case-card" aria-pressed="false" data-i="${i}">
        <span class="c-ref">${esc(c.ref)}</span><span class="c-title">${esc(c.title || '')}</span><span class="c-meta">${meta}</span></button></li>`;
    }).join('');
    list.querySelectorAll('.case-card').forEach((b) => b.addEventListener('click', () => {
      const c = cases[Number(b.dataset.i)];
      $('#f-case').value = c.ref;
      list.querySelectorAll('.case-card').forEach((x) => x.setAttribute('aria-pressed', String(x === b)));
    }));
  }

  $('#f-who').addEventListener('input', () => {
    if (D.person) unlinkPerson(); // typed over a linked name: it's no longer that person
    if (!D.mdt) return;
    clearTimeout(D.searchTimer);
    const q = $('#f-who').value.trim();
    if (q.length < 2) { D.searchSeq++; hideResults(); return; }
    D.searchTimer = setTimeout(() => searchPeople(q), 250);
  });
  $('#f-who').addEventListener('keydown', (e) => {
    const ul = $('#who-results');
    if (ul.hidden || !D.results.length) return;
    const buttons = [...ul.querySelectorAll('button')];
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      D.active = (D.active + (e.key === 'ArrowDown' ? 1 : -1) + buttons.length) % buttons.length;
      buttons.forEach((b, i) => b.classList.toggle('active', i === D.active));
    } else if (e.key === 'Enter') {
      e.preventDefault();
      pickPerson(D.results[Math.max(0, D.active)]);
    }
  });
  $('#f-who').addEventListener('blur', () => setTimeout(hideResults, 120));
  $('#who-unlink').addEventListener('click', () => { unlinkPerson(); $('#f-who').focus(); });
  $('#f-case').addEventListener('input', () => {
    document.querySelectorAll('#case-list .case-card').forEach((x) => x.setAttribute('aria-pressed', String(x.querySelector('.c-ref').textContent === $('#f-case').value.trim())));
  });

  function renderOfficers() {
    const ul = $('#officer-list');
    ul.innerHTML = '';
    D.officers.forEach((name, i) => {
      const li = document.createElement('li');
      li.innerHTML = `<span>${esc(name)}</span><button type="button" aria-label="${esc(`${D.text.remove || 'Remove'} ${name}`)}">&times;</button>`;
      li.querySelector('button').addEventListener('click', () => { D.officers.splice(i, 1); renderOfficers(); });
      ul.appendChild(li);
    });
    $('#officer-add').disabled = D.officers.length >= 8;
  }

  function addOfficer() {
    const input = $('#f-officer');
    const name = input.value.trim().slice(0, 64);
    if (!name || D.officers.length >= 8) return;
    if (!D.officers.some((o) => o.toLowerCase() === name.toLowerCase())) D.officers.push(name);
    input.value = '';
    renderOfficers();
    input.focus();
  }

  function applyText(root, text) {
    root.querySelectorAll('[data-text]').forEach((el) => { const v = text?.[el.dataset.text]; if (v != null) el.textContent = v; });
    root.querySelectorAll('[data-ph]').forEach((el) => { const v = text?.[el.dataset.ph]; if (v != null) el.placeholder = v; });
  }

  function setErr(id, msg) {
    const el = $(id);
    el.textContent = msg || '';
    el.hidden = !msg;
  }

  function openStart(d) {
    const root = $('#start');
    applyText(root, d.text);
    D.roomId = d.roomId;
    D.open = 'start';
    $('#start-room').textContent = d.room || '';
    const replay = root.querySelector('input[value="replay"]');
    replay.disabled = !d.canReplay;
    $('#choice-replay').classList.toggle('off', !d.canReplay);
    $('#no-camera').hidden = !!d.canReplay;
    root.querySelector(`input[value="${d.canReplay ? 'replay' : 'audio'}"]`).checked = true;
    syncChoices();
    D.text = d.text || {};
    D.mdt = !!d.mdt;
    unlinkPerson();
    hideResults();
    $('#f-who').placeholder = D.mdt ? (D.text.mdtSearchHint || '') : (D.text.intervieweeHint || '');
    D.officers = Array.isArray(d.officers) ? d.officers.slice(0, 8) : [];
    renderOfficers();
    $('#f-officer').value = '';
    $('#f-solicitor').value = '';
    $('#f-case').value = '';
    $('#f-who').value = '';
    $('#f-notes').value = '';
    setErr('#start-err', '');
    $('#start-go').disabled = false;
    root.hidden = false;
    $('#f-who').focus();
  }

  function openStop(d) {
    const root = $('#stop');
    applyText(root, d.text);
    D.roomId = d.roomId;
    D.open = 'stop';
    $('#stop-room').textContent = d.room || '';
    setErr('#stop-err', '');
    $('#stop-go').disabled = false;
    D.base = Date.now() - (d.elapsed || 0);
    const tick = () => { $('#stop-time').textContent = tc(Date.now() - D.base); };
    tick();
    clearInterval(D.timer);
    D.timer = setInterval(tick, 1000);
    root.hidden = false;
    $('#stop-cancel').focus();
  }

  function closeDialog(notify) {
    clearInterval(D.timer);
    $('#start').hidden = true;
    $('#stop').hidden = true;
    D.open = null;
    if (notify) post('dialog:close');
  }

  $('#start-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const btn = $('#start-go');
    if (btn.disabled) return;
    btn.disabled = true;
    setErr('#start-err', '');
    const mode = $('#start-form').querySelector('input[name="mode"]:checked')?.value || 'audio';
    if ($('#f-officer').value.trim()) addOfficer();
    const res = await post('start:submit', {
      roomId: D.roomId,
      mode,
      caseRef: $('#f-case').value.trim(),
      interviewee: $('#f-who').value.trim(),
      notes: $('#f-notes').value.trim(),
      officers: D.officers,
      solicitor: $('#f-solicitor').value.trim(),
      intervieweeCid: D.person ? D.person.cid : null,
    });
    if (res && res.ok) return closeDialog(false);
    btn.disabled = false;
    setErr('#start-err', res?.err || 'The recording could not be started.');
  });

  $('#stop-go').addEventListener('click', async (e) => {
    const btn = e.currentTarget;
    if (btn.disabled) return;
    btn.disabled = true;
    setErr('#stop-err', '');
    const res = await post('stop:submit', { roomId: D.roomId });
    if (res && res.ok) return closeDialog(false);
    btn.disabled = false;
    setErr('#stop-err', res?.err || 'The recording could not be ended.');
  });

  function syncChoices() {
    document.querySelectorAll('#start .choice').forEach((c) => c.classList.toggle('on', c.querySelector('input').checked));
  }
  document.querySelectorAll('#start input[name="mode"]').forEach((i) => i.addEventListener('change', syncChoices));

  $('#officer-add').addEventListener('click', addOfficer);
  $('#f-officer').addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); addOfficer(); } });

  $('#start-cancel').addEventListener('click', () => closeDialog(true));
  $('#stop-cancel').addEventListener('click', () => closeDialog(true));
  ['#start', '#stop'].forEach((id) => {
    $(id).addEventListener('mousedown', (e) => { if (e.target === e.currentTarget) closeDialog(true); });
  });

  /* ════════════════════════════════════════════════════════════
     Key help
     ════════════════════════════════════════════════════════════ */
  function showHelp(d) {
    const el = $('#help');
    if (!d.show) { el.hidden = true; return; }
    $('#help-title').textContent = d.title || '';
    el.classList.toggle('compact', !d.title);
    $('#help-keys').innerHTML = (d.keys || []).map(([k, label]) => `<li><kbd>${esc(k)}</kbd><span>${esc(label)}</span></li>`).join('');
    helpStatus(d.status);
    el.hidden = false;
  }
  function helpStatus(text) {
    const p = $('#help-status');
    p.textContent = text || '';
    p.hidden = !text;
  }

  /* ════════════════════════════════════════════════════════════
     Message router
     ════════════════════════════════════════════════════════════ */
  window.addEventListener('message', (e) => {
    const d = e.data || {};
    switch (d.action) {
      case 'rec:start': recStart(d); break;
      case 'rec:stop': recStop(d); break;
      case 'rec:gate': recGate(!!d.open); break;
      case 'mictest': micTest(); break;
      case 'hud': showHud(d); break;
      case 'help': showHelp(d); break;
      case 'help:status': helpStatus(d.status); break;
      case 'viewer:open': openViewer(d); break;
      case 'start:open': openStart(d); break;
      case 'stop:open': openStop(d); break;
    }
  });
})();
