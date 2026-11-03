/* Rex Pool - synthesised sounds (Web Audio). No sample files: every sound is generated here. */
const RexAudio = (() => {
  let ctx = null;
  let master = null;
  function ac() {
    if (!ctx) {
      ctx = new (window.AudioContext || window.webkitAudioContext)();
      master = ctx.createGain();
      master.gain.value = 0.9;
      const comp = ctx.createDynamicsCompressor();
      master.connect(comp);
      comp.connect(ctx.destination);
    }
    if (ctx.state === 'suspended') ctx.resume();
    return ctx;
  }
  function noiseBuffer(len) {
    const c = ac();
    const buf = c.createBuffer(1, Math.max(1, Math.floor(c.sampleRate * len)), c.sampleRate);
    const d = buf.getChannelData(0);
    for (let i = 0; i < d.length; i++) d[i] = Math.random() * 2 - 1;
    return buf;
  }
  function tone(freq, start, dur, vol, type) {
    const c = ac();
    const o = c.createOscillator();
    const g = c.createGain();
    o.type = type || 'sine';
    o.frequency.setValueAtTime(freq, start);
    g.gain.setValueAtTime(0.0001, start);
    g.gain.exponentialRampToValueAtTime(Math.max(0.0002, vol), start + 0.002);
    g.gain.exponentialRampToValueAtTime(0.0001, start + dur);
    o.connect(g); g.connect(master);
    o.start(start); o.stop(start + dur + 0.02);
  }
  function noise(start, dur, vol, filterType, freq, q) {
    const c = ac();
    const s = c.createBufferSource();
    s.buffer = noiseBuffer(dur + 0.02);
    const f = c.createBiquadFilter();
    f.type = filterType; f.frequency.value = freq; f.Q.value = q || 1;
    const g = c.createGain();
    g.gain.setValueAtTime(vol, start);
    g.gain.exponentialRampToValueAtTime(0.0001, start + dur);
    s.connect(f); f.connect(g); g.connect(master);
    s.start(start); s.stop(start + dur + 0.02);
  }
  const kinds = {
    // ivory-like click: two inharmonic partials + a very short bright transient
    ball(v, t) {
      const p = 1 + (Math.random() - 0.5) * 0.06;
      tone(2750 * p, t, 0.045, 0.55 * v);
      tone(4320 * p, t, 0.03, 0.3 * v);
      noise(t, 0.012, 0.5 * v, 'highpass', 3500, 0.7);
    },
    // rubber cushion: soft low thump
    cushion(v, t) {
      tone(110, t, 0.11, 0.7 * v);
      noise(t, 0.06, 0.35 * v, 'lowpass', 600, 0.8);
    },
    // pocket: short rattle then the drop in the bag
    pot(v, t) {
      for (let i = 0; i < 4; i++) {
        const dt = t + i * 0.028 + Math.random() * 0.01;
        tone(1900 - i * 260, dt, 0.03, (0.35 - i * 0.06) * v);
      }
      tone(85, t + 0.14, 0.16, 0.6 * v);
      noise(t + 0.14, 0.1, 0.3 * v, 'lowpass', 400, 0.7);
    },
    // leather tip on the cue ball: woody tock
    cue(v, t) {
      tone(820, t, 0.035, 0.5 * v, 'triangle');
      noise(t, 0.02, 0.45 * v, 'bandpass', 1600, 1.5);
    },
    rack(v, t) {
      for (let i = 0; i < 7; i++) kinds.ball(v * (0.6 + Math.random() * 0.4), t + i * 0.035 + Math.random() * 0.015);
    },
    turn(v, t) {
      tone(880, t, 0.25, 0.25 * v);
      tone(1320, t + 0.09, 0.3, 0.2 * v);
    },
    win(v, t) {
      [523.25, 659.25, 783.99, 1046.5].forEach((f, i) => tone(f, t + i * 0.11, 0.45, 0.25 * v, 'triangle'));
    },
    lose(v, t) {
      [392, 349.23, 293.66].forEach((f, i) => tone(f, t + i * 0.16, 0.5, 0.22 * v, 'triangle'));
    },
    click(v, t) { tone(1400, t, 0.03, 0.15 * v, 'square'); },
  };
  return {
    play(kind, v) {
      try {
        const c = ac();
        const fn = kinds[kind];
        if (fn && v > 0.003) fn(Math.min(1, v), c.currentTime + 0.005);
      } catch (e) { /* audio not available */ }
    },
  };
})();
