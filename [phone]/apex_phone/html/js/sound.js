/* ============================================================
   SOUND - os sons do sistema, SINTETIZADOS (Web Audio) para soarem
   com perfis distintos para PearPhone (iOS) e NOVA (Android). Sem ficheiros de áudio: as gravações da
   Apple não podem ser distribuídas, por isso cada som é desenhado aqui.

   A linguagem sonora do PearOS, e é isto que se imita:
   · TOQUES são transientes MUITO curtos e secos (5-25 ms), nunca "bips":
     o PearPhone responde ao dedo com o motor háptico, e aqui - sem motor -
     o som faz esse papel, discreto;
   · o teclado tem TRÊS cliques diferentes: letras, apagar e teclas
     modificadoras (espaço, shift, 123, return);
   · o seletor de rodas (hora, data) faz um "tique" metálico por passo;
   · o cadeado é mecânico, em duas partes; desbloquear é quase mudo;
   · notificações e mensagens são "plucks" de marimba (ataque imediato,
     decaimento natural), não tons de onda quadrada;
   · abrir e fechar apps NÃO faz som (fiel ao PearPhone).

   Tudo passa por um bus mestre com um compressor suave e uma sala muito
   curta: é o que tira o som "de sintetizador" aos plucks. Custo: nós de
   áudio curtos no thread de áudio - nada no thread da página.
   ============================================================ */
window.Sound = (() => {
  let ctx = null, noiseBuf = null, bus = null;
  const android = () => !!(window.System && System.os === 'android');
  const ringVoices = new Set();
  let ringGeneration = 0;

  const ac = () => {
    if (!ctx) { try { ctx = new (window.AudioContext || window.webkitAudioContext)(); } catch (e) { ctx = null; } }
    if (ctx && ctx.state === 'suspended') { try { ctx.resume(); } catch (e) {} }
    return ctx;
  };

  /* SONS DE OUTROS TELEMÓVEIS (1.2.0, Config.WorldSounds): enquanto `remoteScale` não é null está-se a tocar o som de um
     telemóvel VIZINHO (o Lua já pesou a distância): o volume é esse, não as definições deste telemóvel - foi o outro
     que decidiu tocar. Só o "sons desligados" deste jogador o cala. */
  let remoteScale = null;
  /* volume por tipo, a partir das Definições. `tap` são os toques de interface (podem desligar-se
     à parte com state.tapSounds = false, como "Cliques do teclado" / "Som ao bloquear" no PearPhone) */
  const vol = kind => {
    const s = (window.System && System.state) || {};
    if (s.sounds === false) return 0;
    if (remoteScale !== null) return Math.max(0, Math.min(1, remoteScale)) * 0.5;
    if (kind === 'notify' && s.notifSound === false) return 0;
    if (kind === 'tap' && s.tapSounds === false) return 0;
    if (kind === 'key' && s.keyboardClicks === false) return 0;
    if (kind === 'lock' && s.lockSound === false) return 0;
    if (s.silent && (kind === 'ring' || kind === 'notify')) return 0;
    const v = kind === 'ring' ? (s.callVolume ?? 80) : kind === 'notify' ? (s.notifVolume ?? 70) : (s.volume ?? 60);
    return Math.max(0, Math.min(1, v / 100)) * 0.5;
  };

  /* ---------- bus mestre: compressor + sala curta ---------- */
  function out() {
    const c = ac(); if (!c) return null;
    if (bus) return bus;
    const comp = c.createDynamicsCompressor();
    comp.threshold.value = -14; comp.knee.value = 12; comp.ratio.value = 3; comp.attack.value = .002; comp.release.value = .12;
    comp.connect(c.destination);
    const dry = c.createGain(); dry.gain.value = 1; dry.connect(comp);
    /* sala: resposta a impulso de 0,22 s gerada com ruído a decair - dá corpo aos plucks sem eco audível */
    const len = Math.floor(c.sampleRate * .22), ir = c.createBuffer(2, len, c.sampleRate);
    for (let ch = 0; ch < 2; ch++) { const d = ir.getChannelData(ch); for (let i = 0; i < len; i++) d[i] = (Math.random() * 2 - 1) * Math.pow(1 - i / len, 3.2); }
    const conv = c.createConvolver(); conv.buffer = ir;
    const wet = c.createGain(); wet.gain.value = .16;
    conv.connect(wet); wet.connect(comp);
    bus = { dry, room: conv };
    return bus;
  }
  const nbuf = c => { if (noiseBuf) return noiseBuf; noiseBuf = c.createBuffer(1, c.sampleRate, c.sampleRate); const d = noiseBuf.getChannelData(0); for (let i = 0; i < d.length; i++) d[i] = Math.random() * 2 - 1; return noiseBuf; };

  /* ligar um nó ao bus (seco + um pouco de sala, se `room` > 0) */
  function send(node, room) {
    const b = out(); if (!b) return;
    node.connect(b.dry);
    if (room) { const r = ctx.createGain(); r.gain.value = room; node.connect(r); r.connect(b.room); }
  }

  /* ---------- geradores ---------- */
  /* tom com envelope (ataque linear, decaimento exponencial) e glissando opcional */
  function tone(freq, t0, dur, { type = 'sine', gain = .3, kind = 'sys', to = 0, attack = .004, room = 0, detune = 0 } = {}) {
    const c = ac(); if (!c) return; const g = vol(kind); if (!g) return;
    const o = c.createOscillator(), a = c.createGain(); const t = c.currentTime + t0;
    o.type = type; o.frequency.setValueAtTime(freq, t); if (detune) o.detune.value = detune;
    if (to) o.frequency.exponentialRampToValueAtTime(to, t + dur);
    a.gain.setValueAtTime(0, t); a.gain.linearRampToValueAtTime(gain * g, t + attack); a.gain.exponentialRampToValueAtTime(.0001, t + dur);
    o.connect(a); send(a, room);
    if (kind === 'ring') ringVoices.add(o);
    o.onended = () => { ringVoices.delete(o); o.disconnect(); a.disconnect(); };
    o.start(t); o.stop(t + dur + .05);
  }

  /* transiente de ruído filtrado: o "clique" físico (teclado, toques, cadeado, obturador) */
  function click(t0, dur, { gain = .2, band = 3000, q = 1, lp = 0, hp = 0, kind = 'sys', attack = .0008, room = 0, sweep = 0 } = {}) {
    const c = ac(); if (!c) return; const g = vol(kind); if (!g) return;
    const s = c.createBufferSource(); s.buffer = nbuf(c); const t = c.currentTime + t0;
    let head = s;
    if (band) { const b = c.createBiquadFilter(); b.type = 'bandpass'; b.frequency.setValueAtTime(band, t); b.Q.value = q; if (sweep) b.frequency.exponentialRampToValueAtTime(sweep, t + dur); head.connect(b); head = b; }
    if (lp) { const l = c.createBiquadFilter(); l.type = 'lowpass'; l.frequency.value = lp; head.connect(l); head = l; }
    if (hp) { const h = c.createBiquadFilter(); h.type = 'highpass'; h.frequency.value = hp; head.connect(h); head = h; }
    const a = c.createGain(); a.gain.setValueAtTime(0, t); a.gain.linearRampToValueAtTime(gain * g, t + attack); a.gain.exponentialRampToValueAtTime(.0001, t + dur);
    head.connect(a); send(a, room);
    if (kind === 'ring') ringVoices.add(s);
    s.onended = () => { ringVoices.delete(s); s.disconnect(); a.disconnect(); };
    s.start(t, Math.random() * .6, dur + .03);
  }

  /* "whoosh": ruído com passa-banda a varrer (enviar mensagem, apagar, deslizar) */
  function whoosh(t0, dur, f1, f2, { gain = .12, q = 1.2, kind = 'sys', room = .3 } = {}) {
    const c = ac(); if (!c) return; const g = vol(kind); if (!g) return;
    const s = c.createBufferSource(); s.buffer = nbuf(c); const t = c.currentTime + t0;
    const b = c.createBiquadFilter(); b.type = 'bandpass'; b.Q.value = q; b.frequency.setValueAtTime(f1, t); b.frequency.exponentialRampToValueAtTime(f2, t + dur);
    const a = c.createGain(); a.gain.setValueAtTime(0, t); a.gain.linearRampToValueAtTime(gain * g, t + dur * .35); a.gain.exponentialRampToValueAtTime(.0001, t + dur);
    s.connect(b); b.connect(a); send(a, room); s.start(t, Math.random() * .5, dur + .03);
  }

  /* "pluck" de marimba/sino: fundamental + 4.ª harmónica parcial (o "tine") + um toque de ruído no
     ataque. É o timbre das notificações e toques do PearOS - nunca uma onda quadrada. */
  // Partial inharmonics and independently decaying overtones give a struck-glass body.
  function pluck(t0, freq, { dur = .62, gain = .26, kind = 'notify', bright = .35, room = .38 } = {}) {
    if (android()) {
      // Softer bell, beating overtones and a longer tail for the NOVA handset.
      tone(freq, t0, dur * 1.25, { gain: gain * .8, kind, attack: .006, room: .42 });
      tone(freq * 1.004, t0, dur, { gain: gain * .16, kind, attack: .008, room: .35 });
      tone(freq * 2.01, t0, dur * .7, { gain: gain * .25, kind, attack: .004, room: .35 });
      tone(freq * 3, t0, dur * .32, { gain: gain * bright * .2, kind, attack: .003, room: .22 });
      return;
    }
    [[1, 1, 1], [2.003, .19, .64], [2.756, bright * .24, .38],
     [4.012, bright * .32, .23], [5.43, bright * .09, .16]].forEach(([ratio, level, decay]) => {
      tone(freq * ratio, t0, dur * decay, { gain: gain * level, kind, attack: .003, room });
    });
    tone(freq * .5, t0, dur * .48, { gain: gain * .055, kind, attack: .005, room: .12 });
    click(t0, .008, { gain: gain * .075, band: Math.min(8500, freq * 3), q: .8, kind });
  }

  /* ---------- a biblioteca ---------- */
  const S = {
    /* ---- teclado (três cliques, como no PearPhone) ---- */
    tap: () => click(0, .022, { gain: .34, band: 3400, q: 1.1, hp: 900, kind: 'key' }),                     /* letra */
    key_delete: () => click(0, .026, { gain: .32, band: 2200, q: 1.0, hp: 600, kind: 'key' }),              /* apagar: mais grave */
    key_modifier: () => click(0, .03, { gain: .3, band: 1700, q: .9, hp: 400, kind: 'key' }),               /* espaço, shift, 123, return */
    keypad: () => { click(0, .028, { gain: .36, band: 2600, q: 1.0, hp: 500, kind: 'key' }); tone(180, 0, .03, { gain: .05, kind: 'key' }); },  /* código: o mesmo "tock" com um pouco de corpo */

    /* ---- toques de interface: o substituto do motor háptico ---- */
    click: () => click(0, .011, { gain: .16, band: 3800, q: .9, hp: 1500, kind: 'tap' }),                  /* botões, linhas, separadores */
    haptic: () => click(0, .011, { gain: .16, band: 3800, q: .9, hp: 1500, kind: 'tap' }),
    tick: () => click(0, .007, { gain: .2, band: 5200, q: 1.6, hp: 2500, kind: 'tap' }),                   /* roda do seletor / passo de um slider */
    page: () => click(0, .009, { gain: .12, band: 4400, q: 1.2, hp: 2000, kind: 'tap' }),                  /* mudar de página no ecrã principal */
    toggle_on: () => { click(0, .012, { gain: .18, band: 4200, q: 1.1, hp: 1800, kind: 'tap' }); tone(1480, .002, .018, { gain: .025, kind: 'tap' }); },
    toggle_off: () => { click(0, .012, { gain: .16, band: 3000, q: 1.1, hp: 1200, kind: 'tap' }); tone(1040, .002, .018, { gain: .022, kind: 'tap' }); },
    pop: () => { click(0, .02, { gain: .16, band: 900, q: .8, kind: 'tap' }); tone(320, 0, .06, { gain: .09, kind: 'tap', to: 150 }); },   /* toque longo (Haptic Touch), menus */
    swoosh: () => {},                                                                                         /* abrir/fechar apps: o PearPhone não faz som */

    /* ---- cadeado ---- */
    lock: () => {
      click(0, .045, { gain: .5, band: 1300, q: .8, hp: 150, kind: 'lock' });
      tone(210, 0, .07, { gain: .14, kind: 'lock', to: 130 });
      click(.068, .03, { gain: .28, band: 950, q: .9, hp: 140, kind: 'lock' });
    },
    unlock: () => click(0, .02, { gain: .12, band: 2400, q: .9, hp: 800, kind: 'lock' }),                 /* no PearPhone é praticamente mudo */

    /* ---- mensagens e notificações ---- */
    notify: () => { pluck(0, 1174.66, { dur: .48, gain: .23, bright: .22 }); pluck(.135, 1567.98, { dur: .82, gain: .24, bright: .3 }); },                                      /* notificação: duas notas que "saltam" */
    message: () => { [[0, 1318.51], [.105, 1567.98], [.225, 2093]].forEach(([t, f], i) => pluck(t, f, { dur: i === 2 ? .72 : .32, gain: .23, bright: .24, room: .28 })); },   /* mensagem recebida: três notas a subir */
    send: () => { whoosh(0, .26, 450, 3600, { gain: .17, q: 1.1, room: .25 }); tone(1500, .05, .09, { gain: .035, to: 2600 }); },          /* mensagem enviada: whoosh a subir */
    mail_sent: () => whoosh(0, .42, 2600, 500, { gain: .14, q: .9, room: .3 }),
    delete: () => { whoosh(0, .22, 2200, 350, { gain: .15, q: 1.3, room: .15 }); click(.19, .02, { gain: .12, band: 700, q: .8 }); },   /* ir para o lixo */

    /* ---- confirmações ---- */
    /* confirmação DISCRETA: era um dueto de marimba igual a uma notificação - e o success toca no fim de muitas
       operações em segundo plano (envios, instalações, uploads), por isso ouvia-se "uma notificação do nada" */
    success: () => { click(0, .012, { gain: .14, band: 3000, q: 1, hp: 1200, kind: 'tap' }); tone(1760, .008, .07, { gain: .045, kind: 'tap', attack: .003 }); },
    error: () => { click(0, .03, { gain: .26, band: 520, q: .8, hp: 100 }); click(.07, .03, { gain: .22, band: 480, q: .8, hp: 100 }); click(.14, .035, { gain: .2, band: 440, q: .8, hp: 100 }); },   /* três toques graves (o padrão háptico de erro), não um "buzzer" */
    payment: () => { pluck(0, 1760, { dur: .2, gain: .22, kind: 'sys' }); pluck(.07, 2637, { dur: .6, gain: .22, kind: 'sys', bright: .5 }); },   /* pagamento concluído */
    airdrop: () => { tone(520, 0, .09, { gain: .16, to: 880 }); click(.07, .014, { gain: .14, band: 3200, q: 1 }); },

    /* ---- câmara ---- */
    shutter: () => { click(0, .035, { gain: .5, band: 3600, q: .7, hp: 700 }); click(.045, .05, { gain: .34, band: 2100, q: .7, hp: 400 }); whoosh(.01, .08, 5200, 2400, { gain: .05, q: 1.5, room: 0 }); },
    screenshot: () => { click(0, .03, { gain: .36, band: 3600, q: .7, hp: 700 }); click(.04, .04, { gain: .22, band: 2100, q: .7, hp: 400 }); },
    rec_start: () => { tone(880, 0, .12, { gain: .18, room: .3 }); tone(1175, .1, .16, { gain: .18, room: .3 }); },
    rec_stop: () => { tone(1175, 0, .12, { gain: .18, room: .3 }); tone(880, .1, .18, { gain: .18, room: .3 }); },

    /* ---- sistema ---- */
    charge: () => { click(0, .014, { gain: .16, band: 2600, q: 1, hp: 900 }); tone(1397, .01, .12, { gain: .06, attack: .003 }); },
    /* só para chamadas (ligada): é o único som de "chamada" fora do toque */
    connect: () => { pluck(0, 988, { dur: .22, gain: .16, kind: 'sys' }); pluck(.1, 1480, { dur: .35, gain: .16, kind: 'sys' }); },
    call_end: () => { pluck(0, 784, { dur: .18, gain: .15, kind: 'sys', bright: .1 }); pluck(.12, 587, { dur: .3, gain: .15, kind: 'sys', bright: .1 }); },
    siri_on: () => { tone(740, 0, .1, { gain: .14, room: .4 }); tone(988, .08, .18, { gain: .14, room: .4 }); },
    siri_off: () => { tone(988, 0, .1, { gain: .12, room: .4 }); tone(740, .08, .16, { gain: .12, room: .4 }); },
    timer: () => { for (let i = 0; i < 4; i++) { pluck(i * .34, 1047, { dur: .18 }); pluck(i * .34 + .12, 1319, { dur: .22 }); } },

    /* ---- Match (like, nope, super like, match) ---- */
    like: () => { tone(420, 0, .08, { gain: .12, to: 760, kind: 'sys', room: .2 }); click(.05, .012, { gain: .1, band: 3600, q: 1 }); },
    nope: () => whoosh(0, .2, 1800, 420, { gain: .12, q: 1.1, room: .1 }),
    superlike: () => { pluck(0, 1319, { dur: .25, gain: .16, kind: 'sys' }); pluck(.07, 1760, { dur: .25, gain: .16, kind: 'sys' }); pluck(.14, 2637, { dur: .6, gain: .16, kind: 'sys', bright: .6 }); },
    match: () => { [1047, 1319, 1568, 2093].forEach((f, i) => pluck(i * .085, f, { dur: i === 3 ? .8 : .3, gain: .17, kind: 'sys', bright: .45 })); },
  };
  const A = {
    tap: () => click(0, .016, { gain: .27, band: 1900, q: .65, hp: 400, kind: 'key' }),
    key_delete: () => click(0, .024, { gain: .26, band: 1350, q: .7, kind: 'key' }),
    key_modifier: () => click(0, .022, { gain: .24, band: 1100, q: .7, kind: 'key' }),
    keypad: () => { tone(697, 0, .055, { gain: .09, kind: 'key' }); tone(1209, 0, .055, { gain: .07, kind: 'key' }); },
    click: () => click(0, .018, { gain: .13, band: 1800, q: .8, kind: 'tap' }),
    tick: () => click(0, .01, { gain: .15, band: 2800, q: .9, kind: 'tap' }),
    toggle_on: () => tone(820, 0, .055, { gain: .09, kind: 'tap', to: 1230 }),
    toggle_off: () => tone(820, 0, .055, { gain: .08, kind: 'tap', to: 550 }),
    lock: () => { click(0, .032, { gain: .27, band: 750, q: .7, kind: 'lock' }); tone(420, .015, .085, { gain: .09, kind: 'lock', to: 260 }); },
    unlock: () => tone(580, 0, .075, { gain: .065, kind: 'lock', to: 920 }),
    notify: () => { pluck(0, 880, { gain: .24, dur: .6 }); pluck(.18, 1174.66, { gain: .22, dur: .95 }); },
    message: () => { pluck(0, 1567.98, { gain: .22, dur: .48 }); pluck(.16, 1174.66, { gain: .24, dur: .8 }); },
    send: () => { whoosh(0, .17, 600, 2200, { gain: .1, room: .12 }); tone(1047, .06, .13, { gain: .055, to: 1568 }); },
    charge: () => { tone(523.25, 0, .16, { gain: .09 }); tone(783.99, .09, .22, { gain: .08 }); tone(1046.5, .19, .32, { gain: .065 }); },
    connect: () => tone(880, 0, .13, { gain: .11 }),
    call_end: () => { tone(480, 0, .16, { gain: .11 }); tone(380, .18, .18, { gain: .09 }); },
    shutter: () => { click(0, .025, { gain: .38, band: 2400, q: .8 }); click(.07, .035, { gain: .26, band: 1500, q: .7 }); },
    screenshot: () => click(0, .045, { gain: .32, band: 2700, q: .65 }),
  };
  A.haptic = A.click; A.tock = A.click;
  const emit = name => ((android() && A[name]) || S[name] || (() => {}))();
  S.tock = S.click;   /* nome antigo ainda usado num sítio */

  /* ---------- toques (marimba) ---------- */
  const RING = {
    'Reflexo': [[659.25, .18], [987.77, .18], [1318.51, .36], [0, .16], [783.99, .18], [1174.66, .18], [1567.98, .48], [0, .65]],
    'Cristal': [[1046.5, .16], [1318.51, .16], [1567.98, .32], [1318.51, .16], [2093, .48], [0, .8]],
    'Aurora': [[523.25, .24], [783.99, .24], [987.77, .36], [1174.66, .24], [987.77, .24], [783.99, .5], [0, .8]],
    'Abertura': [[523, .18], [659, .18], [784, .18], [1047, .45], [0, .6]],
    'Cume': [[440, .24], [554, .24], [659, .5], [0, .3], [554, .24], [440, .5], [0, .6]],
    'Sinal': [[880, .14], [0, .1], [880, .14], [0, .1], [880, .14], [0, .7]],
    'Radar': [[1319, .1], [0, .08], [1319, .1], [0, .08], [1319, .1], [0, .7]],
    'Circuito': [[392, .15], [494, .15], [587, .15], [784, .36], [0, .2], [587, .15], [494, .15], [392, .36], [0, .6]],
  };
  const ANDROID_RING = {
    'Horizonte': [[587.33,.22],[739.99,.22],[880,.44],[1174.66,.22],[1108.73,.22],[880,.44],[739.99,.22],[587.33,.55],[0,.85]],
    'Órbita': [[783.99,.18],[987.77,.18],[1174.66,.36],[987.77,.18],[783.99,.36],[587.33,.5],[0,.8]],
    'Gotas': [[1396.91,.22],[1046.5,.22],[1567.98,.44],[0,.25],[1174.66,.22],[880,.55],[0,.9]],
    'NOVA': [[440,.18],[659.25,.18],[880,.36],[659.25,.18],[987.77,.5],[0,.9]],
    'Sinal': RING.Sinal,
  };
  let ringTimer = null, ringUntil = 0;
  /* o toque nunca fica preso: uma chamada toca no máximo Config.CallTimeout (30 s); se quem o pediu nunca chamar o
     stopRing (janela morta, push perdido), pára sozinho aos 45 s em vez de tocar para sempre "do nada" */
  const RING_MAX = 45000;
  /* um ciclo do padrão `pat` (um toque), agendado agora; devolve a duração em s. `kind` 'ring' = o nosso toque (as vozes
     ficam em ringVoices para o stopRing as cortar); 'rring' = toque de um telemóvel vizinho (não se corta com o nosso) */
  function ringPass(name, pat, kind) {
    let t = 0;
    pat.forEach(([f, d]) => {
      if (f) {
        if (name === 'Sinal') { // Remote ringback: restrained dual telephone tone.
          tone(440, t, d, { gain: .16, kind, attack: .012 });
          tone(480, t, d, { gain: .12, kind, attack: .012 });
        } else {
          pluck(t, f, { dur: Math.max(.48, d * 2), gain: .28, kind, bright: name === 'Radar' ? .65 : .32, room: .3 });
          if (name === 'Reflexo' || name === 'Aurora')
            pluck(t + .012, f * .5, { dur: .7, gain: .065, kind, bright: .08, room: .22 });
        }
      }
      t += d;
    });
    return t;
  }
  function ring(name) {
    stopRing(); const library = android() ? ANDROID_RING : RING;
    const pat = library[name] || (android() ? ANDROID_RING['Horizonte'] : RING['Reflexo']);
    const generation = ringGeneration;
    ringUntil = performance.now() + RING_MAX;
    note('ring:' + name);
    /* os vizinhos ouvem o toque (Config.WorldSounds): avisa-se uma vez no início e no stopRing; o 'Sinal' (o sinal de
       chamada que QUEM LIGA ouve no ouvido) não sai do telemóvel */
    if (name !== 'Sinal' && vol('ring') > 0) worldTell('ring', name, true, vol('ring') * 2);
    const loop = () => {
      if (generation !== ringGeneration) return;
      if (performance.now() > ringUntil) { stopRing(); return; }
      const t = ringPass(name, pat, 'ring');
      ringTimer = setTimeout(loop, t * 1000 + 600);
    };
    loop();
    // An old settings preview must not stop a newer incoming call.
    return () => { if (generation === ringGeneration) stopRing(); };
  }
  function stopRing() {
    ringGeneration++;
    clearTimeout(ringTimer); ringTimer = null; ringUntil = 0;
    for (const voice of ringVoices) { try { voice.stop(); } catch (e) {} }
    ringVoices.clear();
    if (worldRinging) worldTell('ring', '', false, 0);
  }

  /* ---------- SONS OUVIDOS À VOLTA (1.2.0, Config.WorldSounds) ----------
     Até aqui cada som do telemóvel tocava SÓ para o dono: ninguém à volta ouvia um telemóvel a tocar ("the phone doesn't
     ring in city"). Agora o toque (início/fim) e os avisos (mensagem, notificação, alarme) avisam o client/sounds.lua
     (callback 'worldSound'), que os manda ao servidor; este entrega-os aos jogadores perto, e o client/sounds.lua de cada um
     calcula o volume pela distância e empurra 'remoteSound' para este ficheiro, que toca o MESMO som sintetizado com esse
     volume (remoteScale). O toque de um vizinho repete-se até chegar o 'off' dele (ou 45 s), e o volume segue a distância
     ('remoteSoundGain', a cada 500 ms). `os` = o sistema do telemóvel que toca (os sons do NOVA são outros). */
  let worldRinging = false;
  const worldOn = () => !!(window.Bridge && Bridge.inFiveM && (!window.System || !System.config || System.config.worldSounds !== false));
  function worldTell(kind, name, on, gain) {
    if (!worldOn()) { worldRinging = false; return; }
    if (kind === 'ring') { if (on === worldRinging) return; worldRinging = !!on; }
    try { Bridge.call('worldSound', { kind, name: String(name || '').slice(0, 32), on: !!on, gain: Math.max(0, Math.min(1, +gain || 0)), os: (window.System && System.os) || 'ios' }); } catch (e) {}
  }
  /* o que os vizinhos ouvem (os toques de interface, cliques e teclado nunca saem do telemóvel) */
  const WORLD_KINDS = { notify: 'notify', message: 'notify', timer: 'notify', airdrop: 'notify', payment: 'notify' };
  const remote = {};   /* id do jogador -> { name, os, gain, timer, until } (toques a repetir) */
  function remoteEmit(name, os, gain) {
    remoteScale = gain;
    try { ((os === 'android' && A[name]) || S[name] || (() => {}))(); } catch (e) {} finally { remoteScale = null; }
  }
  function remoteRingLoop(id) {
    const r = remote[id]; if (!r) return;
    if (performance.now() > r.until) { remoteStop(id); return; }
    const pat = RING[r.name] || ANDROID_RING[r.name] || (r.os === 'android' ? ANDROID_RING['Horizonte'] : RING['Reflexo']);
    let t = 0.1;
    if (r.gain > 0.01) { remoteScale = r.gain; try { t = ringPass(r.name, pat, 'rring'); } catch (e) {} finally { remoteScale = null; } }
    else t = pat.reduce((a, [, d]) => a + d, 0);
    r.timer = setTimeout(() => remoteRingLoop(id), t * 1000 + 600);
  }
  function remoteStop(id) { const r = remote[id]; if (!r) return; clearTimeout(r.timer); delete remote[id]; }
  function remotePlay(d) {
    if (!d || typeof d !== 'object' || d.id == null) return;
    const id = String(d.id), gain = Math.max(0, Math.min(1, +d.gain || 0)), os = d.os === 'android' ? 'android' : 'ios';
    if (d.kind === 'ring') {
      if (d.on === false) { remoteStop(id); return; }
      const name = String(d.name || '').slice(0, 32);
      if (remote[id]) { remote[id].gain = gain; remote[id].name = name; remote[id].until = performance.now() + RING_MAX; return; }
      remote[id] = { name, os, gain, timer: null, until: performance.now() + RING_MAX };
      remoteRingLoop(id);
      return;
    }
    const name = WORLD_KINDS[d.name] ? String(d.name) : 'notify';
    if (gain > 0.01) remoteEmit(name, os, gain);
  }
  function remoteGain(d) { const r = d && remote[String(d.id)]; if (r) r.gain = Math.max(0, Math.min(1, +d.gain || 0)); }
  if (window.Bridge) { Bridge.on('remoteSound', remotePlay); Bridge.on('remoteSoundGain', remoteGain); Bridge.on('session:changed', () => Object.keys(remote).forEach(remoteStop)); }

  /* ---------- diagnóstico: os últimos sons e de onde vieram ----------
     Sound.history() na consola do NUI (ou as linhas "[debug] [som]" na F8 com Config.Debug = true) diz qual
     ficheiro pediu cada som - é assim que se descobre um "barulho do nada" sem adivinhar. */
  const hist = [];
  function origin() {
    try { const st = String(new Error().stack || '').split('\n'); for (const l of st) { const m = l.match(/\/js\/((?:apps|shell)\/[\w-]+|[\w-]+)\.js[^:]*:(\d+)/); if (m && m[1] !== 'sound') return m[1] + ':' + m[2]; } } catch (e) {}
    return '?';
  }
  function note(name) {
    const o = origin(); hist.push({ t: new Date().toLocaleTimeString(), name, from: o }); if (hist.length > 40) hist.shift();
    if (name !== 'click' && name !== 'tap' && name !== 'tick' && window.Bridge && Bridge.dbg) { try { Bridge.dbg('[som] ' + name + ' ← ' + o); } catch (e) {} }
  }

  /* ---------- tocar ----------
     O toque genérico ("click") é dado pela delegação abaixo logo no pointerdown, como o háptico.
     Muitas apps também chamam Sound.play('click') no onclick: se o dedo acabou de o dar, esse
     segundo "click" era um som em duplicado e é engolido. O MESMO som pedido duas vezes quase ao mesmo
     tempo (dois ouvintes do mesmo push) toca uma vez; os de notificação no máximo um por 1,5 s. */
  let lastTap = 0; const lastAt = {};
  /* só os sons "de acontecimento" colapsam; teclado e toques repetem-se depressa de propósito (e nem vão ao histórico) */
  const DEDUPE = { notify: 1500, message: 1500, success: 300, connect: 300, call_end: 300, charge: 300, timer: 1000, send: 250, match: 800, payment: 400, error: 250, lock: 250, unlock: 250 };
  function play(name) {
    if ((name === 'click' || name === 'tock' || name === 'haptic') && performance.now() - lastTap < 450) return;
    const f = (android() && A[name]) || S[name]; if (!f) return;
    const gap = DEDUPE[name];
    if (gap) { const now = performance.now(); if (lastAt[name] && now - lastAt[name] < gap) return; lastAt[name] = now; note(name); }
    try { f(); } catch (e) {}
    /* os vizinhos ouvem a mensagem / notificação / alarme (1.2.0); com o som desligado ou em silêncio não há nada a ouvir */
    if (WORLD_KINDS[name]) { const g = vol(WORLD_KINDS[name]); if (g > 0) worldTell('notify', name, true, g * 2); }
  }

  /* ---------- TOQUES EM TODO O TELEMÓVEL, SEM TOCAR EM CADA APP ----------
     Um único ouvinte em captura no documento: no pointerdown sobe da origem do toque até encontrar
     o controlo tocado e dá o som certo - interruptor (liga/desliga), segmento, separador, botão ou
     linha. Quem já tem o seu próprio som fica de fora (teclado, código, obturador, jogos, campos de
     texto). Limitado a um toque a cada 45 ms. */
  const SKIP = '#kb, .kb-wrap, .key, .gm-cv, .gm-stage, canvas, input, textarea, [contenteditable], .shutter, .igc-shut, .ins-shut, .viewfinder, .camshot-layer, .no-sound, .lock-hint';
  const HIT = '.toggle, .check, .seg > div, .chips > span, .tab, .nb-btn, .nb-back, .pill-btn, .btn-p, .as-btn, .ctx > div, .sh-l, .sh-r, .li, .hi, .dock .tile, .cc-btn, .cc-tile, .sw-card, .sw-x, .gb, button, a, [role=button]';
  let lastT = 0;
  function onDown(e) {
    if (e.button && e.pointerType === 'mouse') return;
    const now = performance.now(); if (now - lastT < 45) return;
    const t = e.target; if (!t || !t.closest) return;
    if (!t.closest('#screen')) return;
    if (t.closest(SKIP)) return;
    let el = t.closest(HIT);
    if (!el) { /* sem classe conhecida: conta se algum antepassado próximo tiver onclick (a maioria dos botões das apps) */
      let n = t, k = 0; while (n && k < 4 && n.id !== 'screen') { if (typeof n.onclick === 'function') { el = n; break; } n = n.parentElement; k++; }
    }
    if (!el || el.classList.contains('static')) return;
    lastT = now; lastTap = now;
    if (el.matches('.toggle')) { const i = el.querySelector('input'); emit((i ? i.checked : el.classList.contains('on')) ? 'toggle_off' : 'toggle_on'); return; }
    if (el.matches('.seg > div, .chips > span')) { if (!el.classList.contains('on')) emit('tick'); return; }
    emit('click');
  }
  try { document.addEventListener('pointerdown', onDown, true); } catch (e) {}

  return { play, ring, stopRing, get RING() { return Object.keys(android() ? ANDROID_RING : RING); }, names: () => Object.keys(S), history: () => hist.slice(), get ringing() { return ringTimer !== null; },
    remote: remotePlay, remoteGain, remoteStop, get remoteRinging() { return Object.keys(remote); } };
})();
