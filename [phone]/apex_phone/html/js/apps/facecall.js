/* ============================================================
   FACECALL - ecrã inicial e ecrã da chamada ao estilo do FaceTime (2026-09-18)
   window.FaceCallUI = { home(win), screen(ctx) }
   · A CHAMADA continua a ser a do Telefone (voz real, calls.* / client/voice.lua); isto é só a cara dela.
   · O TEU LADO É A CÂMARA A SÉRIO: a janela pequena é o visor do CamView (a vista do jogo, câmara frontal = a
     tua personagem), arrastável para os quatro cantos, com trocar de câmara e desligar câmara.
   · O LADO DO OUTRO (4 out 2026): a imagem REAL da câmara do outro telemóvel, enviada por ele em frames pequenos
     (videoLink, mais abaixo). Enquanto não chega imagem (a tocar, câmara dele desligada, ecrã dele minimizado) fica o
     POSTER do contacto (foto ou iniciais em grande) - nunca um vídeo a fingir.
   · Controlos em vidro (Altifalante · Câmara · Silenciar · Partilhar · Terminar) que se escondem ao fim de 4 s
     e voltam com um toque; botão de fotografia (Live Photo) guarda a imagem da tua câmara nas Fotos.
   ============================================================ */
window.FaceCallUI = (() => {
  const g = UI.g, esc = UI.esc;

  /* =====================================================================
     VIDEOLINK - a imagem do OUTRO participante (4 out 2026; antes cada um só se via a si próprio)
     ---------------------------------------------------------------------
     Porque é assim: o FiveM não tem vídeo entre jogadores e a vista do jogo (gamerender.js, a textura externa do CEF) é
     SEMPRE o ecrã DESTE cliente. Uma câmara scriptada não desenha para um alvo à parte: só existe a vista do jogo, e essa
     já está na NOSSA cara (o nosso PiP). Logo nenhum cliente consegue desenhar o que a câmara do outro vê, esteja ele perto
     ou do outro lado do mapa. Quem tem a imagem é o próprio outro: cada telemóvel ENVIA a sua.
       · emissor: o canvas do meu PiP (CamView, câmara frontal = a minha cara) é reduzido num canvas 2D (Config.VideoCall
         width x height, 144x192 por omissão) e vai em JPEG (até maxKB x 1000 caracteres de base64), fps vezes por segundo
         (8 por omissão), só com a chamada LIGADA, a câmara ligada, o ecrã da chamada à vista e o visor a correr. Se um frame
         passa do limite a qualidade desce e codifica-se outra vez logo (não se perde a vez). Ao parar manda um "off".
       · caminho: NUI -> client/calls.lua (callback fcFrame) -> servidor (apex_phone:server:fcFrame: só os 2 participantes
         de uma chamada de VÍDEO ATIVA, base64 válido, tamanho e ritmo limitados) -> o outro cliente -> push 'fcFrame'.
       · recetor: um <canvas> por cima do poster, criado UMA vez; cada frame é descodificado fora da thread principal
         (Image.decode) e entra por cima do anterior num cruzamento curto (~100 ms), no MESMO canvas (sem recriar DOM, sem
         piscar; só o mais recente espera pela descodificação). Sem frames há 3 s, ou com o "off", volta o poster com
         "Vídeo em pausa".
     (4 nov 2026, 1.3.1) "o vídeo do FaceTime tem lag / não é fluido": eram 4 frames por segundo de 192x256 - um slideshow
     com saltos de 250 ms, esticado 3,7x para o ecrã inteiro (object-fit: cover). Agora:
       · ritmo e tamanho saem do Config.VideoCall (rvCfg, abaixo) com a MESMA conta do client/calls.lua e do server/calls.lua.
         Na 1.3.0 os portões do Lua (150 ms no cliente, 120 ms no servidor) eram números soltos que cortariam em silêncio
         qualquer ritmo da NUI acima de ~6 fps;
       · os envios já não esperam uns pelos outros (no máximo 2 em curso) e o período conta-se do início de cada tick; o Lua
         responde se cortou o frame ({ dropped }) e a NUI abranda em vez de codificar frames para o lixo;
       · sem renderOnce() antes de cada leitura (o ciclo do visor já está a desenhar e o canvas guarda o último frame) e o
         teste de vermelho/preto (getImageData) só nos primeiros frames e depois uma vez por segundo: o que custa em cada
         envio é a leitura GPU -> CPU, e uma basta (a do toDataURL);
       · o PiP (a minha janela) corre a pipQuality da resolução e no máximo pipFps desenhos por segundo (camview/gamerender).
     Orçamento: fps x maxKB x 1000 = 64 000 caracteres/s no pior caso (8 x 8 000) na subida de cada jogador, metade dos
     128 KB/s do netEventSize do FXServer (que corta, e pode desligar, quem passa): a outra metade fica para uma fotografia
     tirada durante a chamada (até 6 x 48 KB) e o resto. fps x maxKB tem teto de 96 000/s; 8 eventos por segundo contra os
     50/s do netEvent. Os baldes do Lua (cliente 64 000/s, servidor 1,25x) são só a rede de segurança.
     pre = 'fc' (PearOS) | 'afc' (Nova UI): classes <pre>-rv / <pre>-rv-st; o ecrã ganha .rv-on / .rv-paused.
     ===================================================================== */
  /* Config.VideoCall (config.lua, chega no `ready` -> System.config.videoCall). A MESMA conta do client/calls.lua e do
     server/calls.lua (fcLimits): fps 2..12, maxKB 3..14 e fps x maxKB x 1000 <= 96 000 caracteres por segundo. */
  const rvCfg = () => {
    const c = (window.System && System.config && System.config.videoCall) || {};
    const n = (v, lo, hi, d) => { v = Number(v); return v > 0 ? Math.min(hi, Math.max(lo, v)) : d; };   /* NaN/0/negativo = omissão */
    const fps = Math.round(n(c.fps, 2, 12, 8));
    let max = Math.round(n(c.maxKB, 3, 14, 8) * 1000); if (fps * max > 96000) max = Math.floor(96000 / fps);
    let qMin = n(c.minQuality, .2, .8, .25), qMax = n(c.maxQuality, .2, .8, .65); if (qMin > qMax) { const t = qMin; qMin = qMax; qMax = t; }
    return { w: Math.round(n(c.width, 64, 320, 144)), h: Math.round(n(c.height, 64, 320, 192)), fps, period: 1000 / fps,
      q: Math.min(qMax, Math.max(qMin, n(c.quality, .2, .8, .5))), qMin, qMax, max, stale: 3000,
      fade: Math.min(110, Math.round(850 / fps)),   /* cruzamento: quase o período inteiro (106 ms a 8 fps), nunca mais de 110 ms */
      pipQ: n(c.pipQuality, .25, 1, .5), pipFps: Math.round(n(c.pipFps, 10, 60, 30)) };
  };
  function videoLink(el, cur, o) {
    const RV = rvCfg();
    let dead = false, timer = 0, sent = false, seq = 0, q = RV.q, srcOverride = null;
    let inflight = 0, backoff = 0, fails = 0, frames = 0, dropped = 0, skipped = 0, okFrames = 0, checkAt = 0, bigWarned = false;
    /* ---- recetor ---- */
    const host = o.host;
    const cv = document.createElement('canvas'); cv.className = o.pre + '-rv'; cv.width = RV.w; cv.height = RV.h;
    host.insertBefore(cv, o.before || null);
    const st = UI.el(`<div class="${o.pre}-rv-st">${g('video', 15)}<span>${esc(T('Vídeo em pausa'))}</span></div>`);
    host.appendChild(st);
    const x2 = cv.getContext('2d');
    let on = false, had = false, lastSeq = 0, lastAt = 0, decoding = false, next = null, got = 0, gen = 0, fade = null, raf = 0;
    const shown = () => !o.isShown || !!o.isShown();   /* ecrã da chamada à vista (minimizada = não) */
    const show = v => { if (on !== v) { on = v; el.classList.toggle('rv-on', v); if (v) had = true; } el.classList.toggle('rv-paused', !on && had); };
    /* CRUZAMENTO (4 nov 2026): cada frame entra por cima do que está no canvas com opacidade a subir em RV.fade ms, em vez
       de saltar de uma vez. Desenhar só o frame NOVO com a = 1 - (1-k)/(1-k0) deixa no canvas exatamente
       (1-k)·anterior + k·novo sem guardar o anterior; um frame que chega a meio parte da mistura que está no ecrã. O rAF
       só corre durante o cruzamento (~100 ms por frame, 144x192: centésimos de ms) e acaba logo com a chamada minimizada
       ou destruída. */
    const step = () => {
      raf = 0; const f = fade; if (!f || dead) return;
      const k = Math.min(1, (performance.now() - f.t0) / RV.fade);
      if (k < 1 && el.isConnected && shown()) {
        const a = 1 - (1 - k) / (1 - f.k);
        if (a > 0.01) { x2.globalAlpha = a; x2.drawImage(f.im, 0, 0, cv.width, cv.height); x2.globalAlpha = 1; f.k = k; }
        raf = requestAnimationFrame(step);
      } else { x2.globalAlpha = 1; x2.drawImage(f.im, 0, 0, cv.width, cv.height); fade = null; }
    };
    const present = im => {
      const w = im.naturalWidth || RV.w, h = im.naturalHeight || RV.h;
      let now = !on || !shown() || !(RV.fade > 0);   /* o primeiro frame (o vídeo ainda escondido) entra direto: o CSS faz o fade-in */
      /* o outro lado pode ter outro Config.VideoCall (outro tamanho): o canvas segue o frame (mudar o tamanho limpa-o) */
      if (cv.width !== w || cv.height !== h) { cv.width = w; cv.height = h; now = true; }
      if (now) { fade = null; x2.globalAlpha = 1; x2.drawImage(im, 0, 0, w, h); }
      else { fade = { im, t0: performance.now(), k: 0 }; if (!raf) raf = requestAnimationFrame(step); }
      lastAt = Date.now(); got++; show(true);
    };
    const draw = d => {
      decoding = true;
      const g0 = gen, im = new Image(); let done = false;
      const fin = ok => {
        if (done) return; done = true; decoding = false;
        if (ok && !dead && g0 === gen) { try { present(im); } catch (e) {} }   /* um "off" a meio: o frame velho já não entra */
        if (next && !dead) { const n = next; next = null; draw(n); }
      };
      im.onerror = () => fin(false);
      if (!im.decode) im.onload = () => fin(true);
      im.src = 'data:image/jpeg;base64,' + d.img;
      /* Image.decode() descodifica fora da thread principal: o drawImage a seguir já não descodifica a meio de um frame */
      if (im.decode) im.decode().then(() => fin(true), () => fin(!!(im.complete && im.naturalWidth)));
    };
    const offFrame = Bridge.on('fcFrame', d => {
      if (dead || !d || cur.id == null || String(d.callId) !== String(cur.id)) return;
      if (d.off) { lastSeq = 0; next = null; fade = null; gen++; show(false); return; }
      if (typeof d.img !== 'string' || d.img.length < 16) return;
      const s = +d.seq || 0; if (s && s <= lastSeq) return; if (s) lastSeq = s;
      if (decoding) next = d; else draw(d);
    });
    const staleT = setInterval(() => { if (on && Date.now() - lastAt > RV.stale) show(false); }, 1000);
    /* ---- emissor ---- */
    const sc = document.createElement('canvas'); sc.width = RV.w; sc.height = RV.h;
    const sx = sc.getContext('2d');
    const source = () => {
      if (srcOverride) return srcOverride;
      const cam = o.getCam(), r = cam && cam.render;
      return (r && r.live && !r.paused && !r.destroyed && r.canvas) ? r.canvas : null;
    };
    const canSend = () => !dead && el.isConnected && !el.classList.contains('ended') && !!cur.t0 && cur.id != null && o.isOn() && !!source();
    /* 12 pontos: o visor ainda VERMELHO (textura do jogo por trocar, gamerender.js) ou PRETO não se envia */
    const blank = px => { let red = 0, black = 0; const n = 12;
      for (let i = 0; i < n; i++) {
        const xx = Math.floor((i % 4 + .5) / 4 * RV.w), yy = Math.floor((Math.floor(i / 4) + .5) / 3 * RV.h), k = (yy * RV.w + xx) * 4;
        const r = px[k], gg = px[k + 1], b = px[k + 2]; if (r > 235 && gg < 24 && b < 24) red++; if (r < 8 && gg < 8 && b < 8) black++; }
      return red === n || black === n; };
    const encode = qq => {
      let url = null; try { url = sc.toDataURL('image/jpeg', qq); } catch (e) { return null; }
      const k = url ? url.indexOf('base64,') : -1;
      return (k < 0 || url.slice(0, 15) !== 'data:image/jpeg') ? null : url.slice(k + 7);
    };
    const grab = () => {
      const c = source(); if (!c) return null;
      /* (1.3.1) SEM renderOnce(): source() só devolve o canvas com o ciclo do visor a correr e o contexto guarda o último
         frame (preserveDrawingBuffer); desenhar outra vez era trabalho de GPU a dobrar mesmo antes da leitura */
      const cw = c.width, ch = c.height; if (!cw || !ch) return null;
      /* recorte "cover" para o rácio do Config.VideoCall (o PiP é 3:4; outro rácio corta ao centro) */
      const a = RV.w / RV.h; let sw = cw, sh = cw / a; if (sh > ch) { sh = ch; sw = ch * a; }
      try { sx.drawImage(c, (cw - sw) / 2, (ch - sh) / 2, sw, sh, 0, 0, RV.w, RV.h); } catch (e) { return null; }
      /* vermelho/preto: os 3 primeiros frames e depois uma vez por segundo (o getImageData é uma leitura da GPU a mais) */
      const now = Date.now();
      if (okFrames < 3 || now - checkAt >= 1000) {
        checkAt = now;
        try { if (blank(sx.getImageData(0, 0, RV.w, RV.h).data)) { okFrames = 0; return null; } } catch (e) { return null; }
        okFrames++;
      }
      let b = encode(q); if (!b) return null;
      /* grande demais: qualidade abaixo e outra vez JÁ (codificar 144x192 custa décimas de ms; perder a vez era um salto) */
      if (b.length > RV.max && q > RV.qMin) { q = Math.max(RV.qMin, q - 0.1); b = encode(q); if (!b) return null; }
      if (b.length > RV.max) {
        if (!bigWarned) { bigWarned = true; Bridge.dbg('facecall', 'frame above Config.VideoCall.maxKB even at minQuality: lower width/height or raise maxKB', b.length, RV.max); }
        return null;
      }
      if (b.length < RV.max * 0.45 && q < RV.qMax) q = Math.min(RV.qMax, q + 0.03);
      return b;
    };
    const sendOff = () => { if (cur.id != null) Bridge.call('fcFrame', { callId: cur.id, off: true }); };
    /* resposta do client/calls.lua: { ok } enviado | { dropped, why } cortado pelo portão/balde -> abranda meio período por
       corte (até 2,5x) e recupera um passo a cada envio bom. Um client/calls.lua antigo responde 'ok' (texto): conta como enviado. */
    const answer = r => { inflight = Math.max(0, inflight - 1); if (r && r.dropped) { dropped++; backoff = Math.min(3, backoff + 1); } else if (backoff) backoff--; };
    const tick = () => {
      timer = 0; if (dead) return;
      const t0 = Date.now();
      if (canSend()) {
        /* no máximo 2 envios em curso: com o Lua parado (o jogo a engasgar) não se empilham frames velhos na fila */
        if (inflight >= 2) skipped++;
        else {
          const b = grab();
          if (b) {
            fails = 0; seq = Math.max(seq + 1, Date.now()); sent = true; frames++; inflight++;
            /* sem await: o próximo tick não espera pela resposta; o callT liberta a vaga se a resposta se perder (2 s) */
            Bridge.callT('fcFrame', { callId: cur.id, seq, img: b }, 2000).then(answer, () => answer(null));
          } else if (sent && ++fails * RV.period >= 1500) { sent = false; fails = 0; sendOff(); }   /* 1,5 s sem frame que preste: o outro volta já ao poster */
        }
      } else if (sent) { sent = false; fails = 0; sendOff(); }
      /* o período conta-se do INÍCIO deste tick: dois envios saem um período afastados (o portão do cliente só corta abaixo
         de meio período) e um tick lento não atrasa os seguintes */
      if (!dead) timer = setTimeout(tick, Math.max(30, RV.period * (1 + 0.5 * backoff) - (Date.now() - t0)));
    };
    timer = setTimeout(tick, 400);
    return {
      destroy() { if (dead) return; dead = true; clearTimeout(timer); clearInterval(staleT); if (raf) cancelAnimationFrame(raf); raf = 0; fade = null; offFrame(); if (sent) { sent = false; sendOff(); } },
      /* harness: uma fonte de imagem no lugar do canvas do jogo (no browser não há vista do jogo) */
      setSource(c) { srcOverride = c || null; },
      config() { return Object.assign({}, RV); },
      stats() { return { on, paused: !on && had, got, lastSeq, sent, seq, q: Math.round(q * 100) / 100, w: cv.width, h: cv.height, fps: RV.fps, max: RV.max, frames, dropped, skipped, inflight, backoff, fading: !!fade }; }
    };
  }

  /* ---------- ECRÃ DA CHAMADA ----------
     ctx = { cur, end(), setMute(on), setSpeaker(on), minimize(), seed } - tudo vem do motor do phone.js */
  function screen(ctx) {
    if (isAndroid()) return screenA(ctx);   /* Nova UI: outro ecrã, o mesmo motor */
    const cur = ctx.cur || {};
    const el = UI.el(`<div class="ft-screen fc ringing">
      <div class="fc-remote"><div class="fc-poster"></div>
        <div class="fc-center"><div class="fc-bigwrap"><div class="fc-rings"><i></i><i></i><i></i></div><div class="fc-bigav"></div></div><b class="fc-bigname"></b><span class="fc-bigst">a chamar…</span></div>
        <div class="fc-poster-name"></div></div>
      <div class="fc-top"><div class="mini-btn fc-min">${g('chevD', 26)}</div><div class="fc-who"><div class="fc-av"></div><div class="fc-t"><b class="ft-name"></b><span><u class="fc-dot"></u><i>${g('video', 13)}</i><em class="ft-status">a chamar…</em></span></div></div><div class="fc-info">${g('info', 22)}</div></div>
      <div class="fc-ctl">
        <div class="fc-b spk"><div>${g('speaker', 24)}</div><span>Altifalante</span></div>
        <div class="fc-b cam on"><div>${g('video', 24)}</div><span>Câmara</span></div>
        <div class="fc-b mute"><div>${g('micOff', 24)}</div><span>Silenciar</span></div>
        <div class="fc-b share"><div>${g('share', 22)}</div><span>Partilhar</span></div>
        <div class="fc-b end"><div>${g('x', 26)}</div><span>Terminar</span></div>
      </div>
      <div class="fc-self"><div class="fc-self-v"></div><div class="fc-self-off"><div class="fc-me"></div><span>Câmara desligada</span></div><div class="fc-self-mute">${g('micOff', 13)}</div><div class="fc-flip">${g('repeat', 16)}</div></div>
      <div class="fc-shot" title="Live Photo"><div></div></div>
    </div>`);
    const $ = s => el.querySelector(s);
    /* poster do outro lado: gradiente do avatar + foto do contacto (se tiver) + iniciais */
    const poster = $('.fc-poster'), pav = $('.fc-av'), bigav = $('.fc-bigav');
    const ini = UI.initials(cur.name || cur.number || '?'), avSt = UI.avatarStyle(ctx.seed || 1);
    /* sem foto: fundo com as cores do avatar + bolha grande ao centro (como o FaceTime com a câmara do outro desligada) */
    poster.setAttribute('style', avSt); pav.setAttribute('style', avSt); bigav.setAttribute('style', avSt);
    pav.textContent = ini; bigav.textContent = ini;
    $('.fc-bigname').textContent = cur.name || cur.number || ''; $('.fc-poster-name').textContent = cur.name || cur.number || '';
    try { const c = window.Contacts && Contacts.byNumber && Contacts.byNumber(cur.number); if (c && Contacts.paintAvatar) { Contacts.paintAvatar(poster, c).then(ok => { if (ok) el.classList.add('has-photo'); }).catch(() => {}); Contacts.paintAvatar(pav, c).catch(() => {}); Contacts.paintAvatar(bigav, c).catch(() => {}); } } catch (e) {}
    /* a minha bolha (câmara desligada) */
    try { const meN = (System.player && (System.player.name || System.player.phone)) || 'Eu'; const me = $('.fc-me'); me.setAttribute('style', UI.avatarStyle(meN.length)); me.textContent = UI.initials(meN); } catch (e) {}
    /* estado da chamada: o phone.js só pinta .ft-status/.ft-name - daqui copia-se para o centro e ligam-se as classes
       (ringing / connected / muted) que animam os anéis e mostram o ponto verde e o microfone cortado no PiP */
    const sync = () => { if (!el.isConnected) return; const st = $('.ft-status').textContent; $('.fc-bigst').textContent = cur.t0 ? 'FaceCall · ' + st : st; el.classList.toggle('ringing', !cur.t0 && !!cur.outgoing); el.classList.toggle('connected', !!cur.t0); el.classList.toggle('muted', !!cur.muted); };
    const syncT = setInterval(sync, 400); setTimeout(sync, 0);

    /* ---- a MINHA câmara (CamView, frontal) ---- */
    let cam = null, camOn = true, visible = true;
    const selfV = $('.fc-self-v'), vc = rvCfg();
    const mountCam = () => {
      if (cam || !window.CamView || !CamView.mount) return;
      /* 1.3.1: o PiP é uma janela de 124x186 - corre a Config.VideoCall.pipQuality da resolução e no máximo pipFps desenhos/s
         (o frame enviado, 144x192, sai daqui na mesma; o Live Photo sobe à resolução inteira só no disparo) */
      try { cam = CamView.mount(selfV, { chrome: 'bare', aspect: 3 / 4, autoActivate: false, aimInside: false, quality: vc.pipQ, maxFps: vc.pipFps }); if (!cam.front) cam.flip(); cam.setActive(camOn && visible); }
      catch (e) { cam = null; }
    };
    const setCam = on => { camOn = !!on; $('.fc-b.cam').classList.toggle('on', camOn); el.classList.toggle('self-off', !camOn); if (cam) cam.setActive(camOn && visible); else if (camOn && visible) mountCam(); };
    /* a imagem do outro (recebida) e a minha (enviada): ver videoLink no topo */
    const link = videoLink(el, cur, { pre: 'fc', host: $('.fc-remote'), before: $('.fc-center'), getCam: () => cam, isOn: () => camOn && visible, isShown: () => visible });
    el._fcVideo = link;
    el._fcActive = on => { visible = !!on; if (cam) cam.setActive(visible && camOn); };
    el._fcDestroy = () => { link.destroy(); try { if (cam) cam.destroy(); } catch (e) {} cam = null; clearTimeout(hudT); clearInterval(syncT); };
    setTimeout(() => { if (el.isConnected && camOn) mountCam(); }, 250);

    /* ---- janela própria arrastável: larga-se e encaixa no canto mais perto ---- */
    const self = $('.fc-self');
    let drag = null;
    self.addEventListener('pointerdown', e => { if (e.target.closest('.fc-flip')) return; const z = UI.zoom(); const r = self.getBoundingClientRect(), p = el.getBoundingClientRect(); drag = { z, x0: e.clientX, y0: e.clientY, l: (r.left - p.left) / z, t: (r.top - p.top) / z, moved: false }; try { self.setPointerCapture(e.pointerId); } catch (x) {} self.classList.add('drag'); });
    self.addEventListener('pointermove', e => { if (!drag) return; const dx = (e.clientX - drag.x0) / drag.z, dy = (e.clientY - drag.y0) / drag.z; if (Math.abs(dx) + Math.abs(dy) > 4) drag.moved = true; self.style.left = (drag.l + dx) + 'px'; self.style.top = (drag.t + dy) + 'px'; self.style.right = 'auto'; self.style.bottom = 'auto'; });
    const drop = () => { if (!drag) return; const d = drag; drag = null; self.classList.remove('drag'); if (!d.moved) return;
      const W = el.offsetWidth || 440, H = el.offsetHeight || 956, w = self.offsetWidth, h = self.offsetHeight, l = parseFloat(self.style.left), t = parseFloat(self.style.top);   /* 880 no PearPhone Fold aberto */
      const right = l + w / 2 > W / 2, bottom = t + h / 2 > H / 2;
      self.style.left = right ? (W - w - 16) + 'px' : '16px'; self.style.top = bottom ? (H - h - 120) + 'px' : '120px'; };
    self.addEventListener('pointerup', drop); self.addEventListener('pointercancel', drop);
    $('.fc-flip').onclick = e => { e.stopPropagation(); if (cam) cam.flip(); };

    /* ---- controlos que se escondem sozinhos (como no FaceTime); tocar no ecrã traz de volta ---- */
    let hudT = null;
    const showHud = () => { el.classList.remove('hud-off'); clearTimeout(hudT); hudT = setTimeout(() => { if (cur.t0 && el.isConnected) el.classList.add('hud-off'); }, 4000); };
    el.addEventListener('pointerdown', e => { if (!e.target.closest('.fc-b,.fc-self,.fc-shot,.fc-top')) showHud(); else showHud(); });
    showHud();

    $('.fc-min').onclick = () => ctx.minimize && ctx.minimize();
    UI.swipe($('.fc-remote'), { down: () => ctx.minimize && ctx.minimize(), threshold: 90 });
    $('.fc-b.end').onclick = () => ctx.end && ctx.end();
    $('.fc-b.mute').onclick = () => cur && ctx.setMute && ctx.setMute(!cur.muted);
    $('.fc-b.spk').onclick = () => cur && ctx.setSpeaker && ctx.setSpeaker(!cur.speaker);
    $('.fc-b.cam').onclick = () => setCam(!camOn);
    $('.fc-b.share').onclick = () => UI.toast('A partilha de ecrã não está disponível neste servidor');
    $('.fc-info').onclick = () => { const c = window.Contacts && Contacts.byNumber(cur.number); UI.alert({ title: cur.name || cur.number, msg: (UI.phone ? UI.phone(cur.number) : cur.number) + (c ? '\nNos teus contactos' : '') }); };
    /* Live Photo: fotografa a TUA câmara (resolução inteira do visor) e guarda nas Fotos */
    $('.fc-shot').onclick = async () => {
      if (!cam || !camOn) { UI.toast('Liga a câmara para tirar uma fotografia'); return; }
      const f = el.querySelector('.fc-flash'); if (!f) el.insertAdjacentHTML('beforeend', '<div class="fc-flash"></div>');
      const fl = el.querySelector('.fc-flash'); fl.classList.remove('go'); void fl.offsetWidth; fl.classList.add('go'); Sound.play('shutter');
      let r = null; try { r = await cam.capture(); } catch (e) { r = null; }
      if (!r || !r.raw) { UI.toast((r && r.msg) || 'Não foi possível tirar a fotografia'); return; }
      const s = await Photos.save(r.raw, {}); if (s && !s.error) { Photos.load().then(() => Bridge.emit('photos')); UI.toast('Fotografia guardada nas Fotos'); } else UI.toast('A fotografia não foi guardada');
    };
    return el;
  }

  /* ---------- ECRÃ INICIAL (Criar ligação · Novo FaceCall · recentes por dia) ---------- */
  function home(win) {
    if (isAndroid()) return homeA(win);
    const root = UI.view({ title: 'FaceCall', large: true, cls: 'fc-home' });
    const top = UI.el(`<div class="fc-top-btns"><div class="fc-link">${g('link', 22)}<span>Criar ligação</span></div><div class="fc-new">${g('video', 24)}<span>Novo FaceCall</span></div></div>`);
    const holder = UI.el('<div class="fc-recents"></div>');
    root.content.append(top, holder);
    top.querySelector('.fc-new').onclick = () => newCall();
    top.querySelector('.fc-link').onclick = () => createLink();
    const me = () => String((System.player && System.player.phone) || '');
    /* a ligação é o TEU número: colada no "Novo FaceCall" de outra pessoa, liga-te. Vai para a área de transferência do
       telemóvel (dá para colar nas Mensagens) e pode seguir já por mensagem. */
    const linkOf = () => 'facecall.ls/' + me().replace(/[^\d-]/g, '');
    async function createLink() {
      const l = linkOf();
      const v = await UI.actionSheet({ title: 'Ligação FaceCall', msg: l, buttons: [{ label: 'Copiar ligação', value: 'copy' }, { label: 'Enviar por mensagem', value: 'msg' }] });
      if (v === 'copy') { if (window.Msgs && Msgs.copy) Msgs.copy(l, true); UI.toast('Ligação copiada'); }
      else if (v === 'msg') { const c = await Contacts.pick('Enviar ligação a'); if (c) { const r = await Bridge.rpc('messages.send', { to: c.number, type: 'text', content: 'Liga-me no FaceCall: ' + l }); UI.toast(r && !r.error ? 'Ligação enviada' : 'Não foi possível enviar'); } }
    }
    /* Novo FaceCall: pesquisa por nome/número OU cola uma ligação facecall.ls/… */
    function newCall() {
      const body = UI.el('<div class="fc-new-sheet"><div class="fc-new-list"></div></div>');
      const list = body.querySelector('.fc-new-list');
      const search = UI.search('Nome, número ou ligação', q => paint(q)); body.insertBefore(search, list);
      const numFrom = q => { const m = /facecall\.ls\/([\d-]{3,15})/i.exec(q) || /^\+?[\d\s-]{3,20}$/.exec(q.trim()); return m ? (UI.unphone ? UI.unphone(m[1] || m[0]) : (m[1] || m[0])).replace(/\s/g, '') : null; };
      const paint = q => {
        q = String(q || '').trim(); list.innerHTML = '';
        const n = numFrom(q);
        if (n) list.appendChild(UI.list([{ items: [{ icon: 'video', iconBg: 'var(--green)', label: 'Ligar para ' + (UI.phone ? UI.phone(n) : n), chevron: false, onTap: () => { sh.close(); PhoneApp.facetime(n, Contacts.name ? Contacts.name(n) : n); } }] }]));
        const all = (Contacts.cache || []).filter(c => !q || n || (c.name + ' ' + c.number).toLowerCase().includes(q.toLowerCase())).slice(0, 40);
        if (all.length) list.appendChild(UI.list([{ header: q ? 'Contactos' : 'Sugeridos', items: all.map(c => ({ avatar: { name: c.name, avatar: c.avatar }, label: c.name, sub: UI.phone ? UI.phone(c.number) : c.number, chevron: false,
          right: `<div class="fc-row-btns"><span class="a">${g('phone', 18)}</span><span class="v">${g('video', 19)}</span></div>`,
          onTap: () => { sh.close(); PhoneApp.facetime(c.number, c.name); } })) }]));
        else if (!n) list.appendChild(UI.empty('personCircle', 'Sem resultados', 'Escreve um número ou cola uma ligação FaceCall.'));
        list.querySelectorAll('.fc-row-btns .a').forEach((b, i) => { b.onclick = e => { e.stopPropagation(); sh.close(); PhoneApp.call(all[i].number, all[i].name); }; });
      };
      const sh = UI.sheet({ title: 'Novo FaceCall', right: 'Cancelar', body, cls: 'fc-sheet' });
      paint('');
    }
    /* recentes agrupados por dia, com o (i) à direita (abre o contacto) - perdidas a vermelho */
    const dayKey = t => { const d = new Date(t), n = new Date(); const y = new Date(n); y.setDate(n.getDate() - 1); return d.toDateString() === n.toDateString() ? 'Hoje' : d.toDateString() === y.toDateString() ? 'Ontem' : UI.fmtDate(d, true); };
    async function paint() {
      holder.innerHTML = '';
      let l = null; try { l = await Bridge.rpc('calls.history'); } catch (e) { l = null; }
      const rows = (window.PhoneMissed ? PhoneMissed.rowsOf(l) : (Array.isArray(l) ? l : [])).filter(r => r.video);
      holder.classList.toggle('fc-isempty', !rows.length);   /* vazio: o aviso fica ao centro do espaço que sobra (app-facecall.css) */
      if (!rows.length) { holder.appendChild(UI.el('<div class="fc-empty"><b>Sem chamadas FaceCall</b><span>As tuas chamadas de vídeo aparecem aqui.</span></div>')); return; }
      const groups = new Map(); rows.forEach(r => { const k = dayKey(r.created); if (!groups.has(k)) groups.set(k, []); groups.get(k).push(r); });
      groups.forEach((list, k) => {
        holder.appendChild(UI.el(`<div class="fc-day">${esc(k)}</div>`));
        const box = UI.el('<div class="fc-list"></div>');
        list.forEach(r => {
          const name = r.name || (Contacts.name ? Contacts.name(r.number) : r.number);
          const missed = window.PhoneMissed && PhoneMissed.isMissed(r);
          const row = UI.el(`<div class="fc-row ${missed ? 'missed' : ''}"><div class="fc-row-av">${UI.avatar({ name, avatar: (Contacts.byNumber(r.number) || {}).avatar || name.length })}</div><div class="fc-row-b"><b></b><span>${g(r.outgoing ? 'video' : 'video', 13)} FaceCall Vídeo</span></div><div class="fc-row-t">${esc(UI.rel(r.created))}</div><div class="fc-row-i">${g('info', 22)}</div></div>`);
          row.querySelector('b').textContent = name;
          row.onclick = () => PhoneApp.facetime(r.number, name);
          row.querySelector('.fc-row-i').onclick = e => { e.stopPropagation(); const c = Contacts.byNumber(r.number); if (c && window.ContactsApp && ContactsApp.open) ContactsApp.open(c); else UI.alert({ title: name, msg: UI.phone ? UI.phone(r.number) : r.number }); };
          try { const c = Contacts.byNumber(r.number); if (c && Contacts.paintAvatar) Contacts.paintAvatar(row.querySelector('.avatar'), c).catch(() => {}); } catch (e) {}
          box.appendChild(row);
        });
        holder.appendChild(box);
      });
    }
    paint();
    root.paint = paint;
    UI.setRoot(win, root);
    /* dobrável aberto: o ecrã inicial é a coluna da esquerda (a barra lateral do FaceTime num ecrã largo) e a direita fica com o
       aviso; os botões e a lista deixam de esticar a toda a coluna de leitura */
    UI.split(win, { icon: 'video', title: 'FaceCall', sub: 'Liga a alguém da lista ou começa um FaceCall novo.' });
    return root;
  }

  /* =====================================================================
     NOVA UI 8.5 (Android): ecrã da videochamada e ecrã inicial da app "Videochamada"
     ---------------------------------------------------------------------
     A mesma chamada (calls.* do phone.js), a mesma câmara (CamView), o mesmo vídeo do outro lado (videoLink) e a
     mesma regra de honestidade: sem imagem dele fica o poster do contacto, nunca um vídeo a fingir. Só a apresentação muda: o outro em
     ecrã inteiro, a tua imagem num cartão de cantos 20 que se arrasta e encaixa no canto mais perto, e a
     barra de controlos em pílula (câmara, microfone, trocar câmara, altifalante, terminar).
     Classes com o prefixo afc-; o motor pinta [data-hook] e liga/desliga [data-act].
     ===================================================================== */
  const T = s => (window.L && L.t ? L.t(s) : s);
  function isAndroid() { return !!(window.System && typeof System.isAndroid === 'function' && System.isAndroid()); }
  const appName = () => (window.App && App.name ? App.name('facetime') : 'Videochamada');

  function screenA(ctx) {
    const cur = ctx.cur || {};
    const el = UI.el(`<div class="afc-call ringing">
      <div class="afc-remote"><div class="afc-poster"></div><div class="afc-shade"></div>
        <div class="afc-center"><div class="avatar afc-bigav" data-hook="avatar"></div><div class="afc-bigst"></div></div></div>
      <div class="afc-top"><div class="afc-ib afc-min">${g('chevD', 24)}</div><div class="afc-who"><b data-hook="name"></b><span><i class="afc-dot"></i><em data-hook="status">a chamar…</em></span></div><div class="afc-ib afc-shot">${g('camera', 22)}</div></div>
      <div class="afc-self"><div class="afc-self-v"></div><div class="afc-self-off"><div class="avatar afc-me"></div><span>${esc(T('Câmara desligada'))}</span></div><div class="afc-self-mute">${g('micOff', 13)}</div></div>
      <div class="afc-ctl">
        <div class="afc-b on" data-act="cam"><i>${g('video', 24)}</i></div>
        <div class="afc-b" data-act="mute"><i>${g('micOff', 24)}</i></div>
        <div class="afc-b" data-act="flip"><i>${g('repeat', 24)}</i></div>
        <div class="afc-b" data-act="spk"><i>${g('speaker', 24)}</i></div>
        <div class="afc-b afc-end" data-act="end"><i>${g('phoneDown', 28)}</i></div>
      </div>
    </div>`);
    if (window.PhoneDroid && PhoneDroid.justAccepted && PhoneDroid.justAccepted()) el.classList.add('aph-still');
    const $ = s => el.querySelector(s);
    /* poster do outro lado: o gradiente do avatar e, por cima, a foto do contacto (se tiver) */
    const poster = $('.afc-poster'), seed = ctx.seed || 1;
    poster.setAttribute('style', UI.avatarStyle(seed));
    try { const c = window.Contacts && Contacts.byNumber && Contacts.byNumber(cur.number); if (c && Contacts.paintAvatar) Contacts.paintAvatar(poster, c).then(ok => { if (ok) el.classList.add('has-photo'); }).catch(() => {}); } catch (e) {}
    /* a minha bolha (câmara desligada) */
    try { const meN = (System.player && (System.player.name || ((System.player.firstname || '') + ' ' + (System.player.lastname || '')).trim() || System.player.phone)) || T('Eu'); const me = $('.afc-me'); me.setAttribute('style', UI.avatarStyle(String(meN).length)); me.textContent = UI.initials(meN); } catch (e) {}
    /* estado ao centro enquanto toca; com a chamada ligada a hora fica só em cima */
    const st = $('[data-hook="status"]'), bigst = $('.afc-bigst');
    const sync = () => { if (!el.isConnected) return; const t = st.textContent; if (bigst.textContent !== t) bigst.textContent = t; el.classList.toggle('ringing', !cur.t0 && !!cur.outgoing); el.classList.toggle('connected', !!cur.t0); el.classList.toggle('muted', !!cur.muted); };
    const syncT = setInterval(sync, 400); setTimeout(sync, 0);

    /* ---- a MINHA câmara (CamView, frontal), como no PearOS ---- */
    let cam = null, camOn = true, visible = true, hudT = null;
    const selfV = $('.afc-self-v'), vc = rvCfg();
    const mountCam = () => {
      if (cam || !window.CamView || !CamView.mount) return;
      /* minimizada antes de a câmara montar (250 ms): fica desligada até voltar ao ecrã (_fcActive(true)) */
      /* 1.3.1: o cartão (112x152) corre a pipQuality da resolução e no máximo pipFps desenhos/s, como no PearOS */
      try { cam = CamView.mount(selfV, { chrome: 'bare', aspect: 3 / 4, autoActivate: false, aimInside: false, quality: vc.pipQ, maxFps: vc.pipFps }); if (!cam.front) cam.flip(); cam.setActive(camOn && visible); }
      catch (e) { cam = null; }
    };
    const setCam = on => { camOn = !!on; $('[data-act="cam"]').classList.toggle('on', camOn); el.classList.toggle('self-off', !camOn); if (cam) cam.setActive(camOn && visible); else if (camOn && visible) mountCam(); };
    /* a imagem do outro por cima do poster (por baixo da sombra e dos controlos) e a minha a seguir para ele: videoLink */
    const link = videoLink(el, cur, { pre: 'afc', host: $('.afc-remote'), before: $('.afc-shade'), getCam: () => cam, isOn: () => camOn && visible, isShown: () => visible });
    el._fcVideo = link;
    el._fcActive = on => { visible = !!on; if (cam) cam.setActive(visible && camOn); };
    el._fcDestroy = () => { link.destroy(); try { if (cam) cam.destroy(); } catch (e) {} cam = null; clearTimeout(hudT); clearInterval(syncT); };
    setTimeout(() => { if (el.isConnected && camOn) mountCam(); }, 250);

    /* ---- o meu cartão arrasta-se e encaixa no canto mais perto (fora da barra de cima e da de baixo) ---- */
    const self = $('.afc-self'); let drag = null;
    self.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; const z = UI.zoom(); const r = self.getBoundingClientRect(), p = el.getBoundingClientRect(); drag = { z, x0: e.clientX, y0: e.clientY, l: (r.left - p.left) / z, t: (r.top - p.top) / z, moved: false }; try { self.setPointerCapture(e.pointerId); } catch (x) {} self.classList.add('drag'); });
    self.addEventListener('pointermove', e => { if (!drag) return; const dx = (e.clientX - drag.x0) / drag.z, dy = (e.clientY - drag.y0) / drag.z; if (Math.abs(dx) + Math.abs(dy) > 4) drag.moved = true; self.style.left = (drag.l + dx) + 'px'; self.style.top = (drag.t + dy) + 'px'; self.style.right = 'auto'; self.style.bottom = 'auto'; });
    const drop = () => { if (!drag) return; const d = drag; drag = null; self.classList.remove('drag'); if (!d.moved) return;
      const W = el.offsetWidth || 440, H = el.offsetHeight || 956, w = self.offsetWidth, h = self.offsetHeight, l = parseFloat(self.style.left), t = parseFloat(self.style.top);
      const right = l + w / 2 > W / 2, bottom = t + h / 2 > H / 2, ctl = $('.afc-ctl'), low = ctl ? ctl.offsetTop - h - 16 : H - h - 140;
      self.style.left = right ? (W - w - 14) + 'px' : '14px'; self.style.top = bottom ? Math.max(120, low) + 'px' : '108px'; };
    self.addEventListener('pointerup', drop); self.addEventListener('pointercancel', drop);

    /* ---- controlos que se escondem sozinhos com a chamada ligada; tocar no ecrã traz de volta ---- */
    const showHud = () => { el.classList.remove('hud-off'); clearTimeout(hudT); hudT = setTimeout(() => { if (cur.t0 && el.isConnected && !el.classList.contains('ended')) el.classList.add('hud-off'); }, 4500); };
    el.addEventListener('pointerdown', showHud); showHud();

    $('.afc-min').onclick = () => ctx.minimize && ctx.minimize();
    UI.swipe($('.afc-remote'), { down: () => ctx.minimize && ctx.minimize(), threshold: 90 });
    $('[data-act="end"]').onclick = () => ctx.end && ctx.end();
    $('[data-act="mute"]').onclick = () => ctx.setMute && ctx.setMute(!cur.muted);
    $('[data-act="spk"]').onclick = () => ctx.setSpeaker && ctx.setSpeaker(!cur.speaker);
    $('[data-act="cam"]').onclick = () => setCam(!camOn);
    $('[data-act="flip"]').onclick = () => { if (cam && camOn) cam.flip(); else UI.toast(T('Liga a câmara para a trocar')); };
    $('.afc-who').onclick = () => { const c = window.Contacts && Contacts.byNumber(cur.number); UI.alert({ title: cur.name || cur.number, msg: (UI.phone ? UI.phone(cur.number) : cur.number) + (c ? '\n' + T('Nos teus contactos') : '') }); };
    /* fotografia da TUA câmara para a Galeria (resolução inteira do visor) */
    $('.afc-shot').onclick = async () => {
      if (!cam || !camOn) { UI.toast(T('Liga a câmara para tirar uma fotografia')); return; }
      let fl = el.querySelector('.afc-flash'); if (!fl) { fl = UI.el('<div class="afc-flash"></div>'); el.appendChild(fl); }
      fl.classList.remove('go'); void fl.offsetWidth; fl.classList.add('go'); Sound.play('shutter');
      let r = null; try { r = await cam.capture(); } catch (e) { r = null; }
      if (!r || !r.raw) { UI.toast((r && r.msg) || T('Não foi possível tirar a fotografia')); return; }
      const s = await Photos.save(r.raw, {}); if (s && !s.error) { Photos.load().then(() => Bridge.emit('photos')); UI.toast(T('Fotografia guardada na Galeria')); } else UI.toast(T('A fotografia não foi guardada'));
    };
    return el;
  }

  /* ---------- ecrã inicial (Nova videochamada · Criar ligação · recentes por dia) ---------- */
  function homeA(win) {
    const root = UI.view({ title: appName(), large: true, cls: 'afc-home' });
    const top = UI.el(`<div class="afc-hero"><div class="afc-new">${g('video', 22)}<span>${esc(T('Nova videochamada'))}</span></div><div class="afc-link">${g('link', 20)}<span>${esc(T('Criar ligação'))}</span></div></div>`);
    const holder = UI.el('<div class="afc-recents"></div>');
    root.content.append(top, holder);
    top.querySelector('.afc-new').onclick = () => newCall();
    top.querySelector('.afc-link').onclick = () => createLink();
    const me = () => String((System.player && System.player.phone) || '');
    /* a ligação é o TEU número, no MESMO formato do PearOS (facecall.ls/...): colada no outro telemóvel, liga-te */
    const linkOf = () => 'facecall.ls/' + me().replace(/[^\d-]/g, '');
    async function createLink() {
      const l = linkOf();
      const v = await UI.actionSheet({ title: T('Ligação de videochamada') + ': ' + l, buttons: [{ label: T('Copiar ligação'), icon: 'copy', value: 'copy' }, { label: T('Enviar por mensagem'), icon: 'message', value: 'msg' }] });
      if (v === 'copy') { if (window.Msgs && Msgs.copy) Msgs.copy(l, true); UI.toast(T('Ligação copiada')); }
      else if (v === 'msg') { const c = await Contacts.pick(T('Enviar ligação a')); if (c) { const r = await Bridge.rpc('messages.send', { to: c.number, type: 'text', content: T('Liga-me por videochamada:') + ' ' + l }); UI.toast(r && !r.error ? T('Ligação enviada') : T('Não foi possível enviar')); } }
    }
    function newCall() {
      const body = UI.el('<div class="afc-new-sheet"><div class="afc-new-list"></div></div>');
      const list = body.querySelector('.afc-new-list');
      body.insertBefore(UI.search(T('Nome, número ou ligação'), q => paint(q)), list);
      const numFrom = q => { const m = /facecall\.ls\/([\d-]{3,15})/i.exec(q) || /^\+?[\d\s-]{3,20}$/.exec(q.trim()); return m ? (UI.unphone ? UI.unphone(m[1] || m[0]) : (m[1] || m[0])).replace(/\s/g, '') : null; };
      const paint = q => {
        q = String(q || '').trim(); list.innerHTML = '';
        const n = numFrom(q);
        if (n) { const r = UI.el(`<div class="aph-card afc-pick"><div class="aph-row-fg"><div class="aph-ic afc-ic">${g('video', 20)}</div><div class="aph-rb"><b></b></div></div></div>`); r.querySelector('b').textContent = T('Ligar para') + ' ' + (UI.phone ? UI.phone(n) : n); r.onclick = () => { sh.close(); PhoneApp.facetime(n, Contacts.name ? Contacts.name(n) : n); }; list.appendChild(r); }
        const all = (Contacts.cache || []).filter(c => !q || n || (c.name + ' ' + c.number).toLowerCase().includes(q.toLowerCase())).sort((a, b) => String(a.name).localeCompare(String(b.name), 'pt')).slice(0, 40);
        if (all.length) {
          list.appendChild(UI.el(`<div class="aph-sec">${esc(q ? T('Contactos') : T('Sugeridos'))}</div>`)); const card = UI.el('<div class="aph-card"></div>');
          all.forEach(c => { const r = UI.el(`<div class="aph-row"><div class="aph-row-fg"><div class="aph-rb"><b></b><span></span></div><div class="afc-rbtn" data-k="a">${g('phone', 19)}</div><div class="afc-rbtn" data-k="v">${g('video', 20)}</div></div></div>`);
            const fg = r.firstElementChild; fg.prepend(window.PhoneDroid ? PhoneDroid.avatar(c, c.name, 's40') : UI.el(UI.avatar(c, 'sm'))); fg.querySelector('b').textContent = c.name; fg.querySelector('span').textContent = UI.phone ? UI.phone(c.number) : c.number;
            fg.onclick = () => { sh.close(); PhoneApp.facetime(c.number, c.name); };
            fg.querySelector('[data-k="a"]').onclick = e => { e.stopPropagation(); sh.close(); PhoneApp.call(c.number, c.name); };
            card.appendChild(r); });
          list.appendChild(card);
        } else if (!n) list.appendChild(UI.empty('personCircle', T('Sem resultados'), T('Escreve um número ou cola uma ligação de videochamada.')));
      };
      const sh = UI.sheet({ title: T('Nova videochamada'), right: T('Cancelar'), body, cls: 'afc-sheet' });
      paint('');
    }
    /* recentes de vídeo agrupados por dia, perdidas a vermelho; (i) abre a ficha do contacto ou do número */
    const dayKey = t => (window.PhoneDroid ? PhoneDroid.dayLabel(t) : UI.rel(t));
    async function paint() {
      holder.innerHTML = '';
      let l = null; try { l = await Bridge.rpc('calls.history'); } catch (e) { l = null; }
      const rows = (window.PhoneMissed ? PhoneMissed.rowsOf(l) : (Array.isArray(l) ? l : [])).filter(r => r.video).sort((a, b) => (+b.created || 0) - (+a.created || 0));
      holder.classList.toggle('fc-isempty', !rows.length);
      if (!rows.length) { holder.appendChild(UI.el(`<div class="afc-empty"><b>${esc(T('Sem videochamadas'))}</b><span>${esc(T('As tuas videochamadas aparecem aqui.'))}</span></div>`)); return; }
      let day = null, card = null;
      rows.forEach(r => {
        const k = dayKey(r.created);
        if (k !== day) { day = k; holder.appendChild(UI.el(`<div class="aph-sec">${esc(k)}</div>`)); card = UI.el('<div class="aph-card"></div>'); holder.appendChild(card); }
        const c = Contacts.byNumber(r.number), name = (c && c.name) || r.name || r.number;
        const kind = window.PhoneDroid ? PhoneDroid.kindOf(r) : (r.outgoing ? 'out' : 'in');
        const row = UI.el(`<div class="aph-row aph-rrow ${kind === 'miss' || kind === 'rej' ? 'is-miss' : ''}"><div class="aph-row-fg"><div class="aph-rb"><b></b><span class="aph-meta"><i class="aph-ct" data-k="${kind}">${window.PhoneDroid ? PhoneDroid.ctIcon(kind, 15) : ''}</i><em></em></span></div><div class="aph-rt"></div><div class="afc-rbtn" data-k="i">${g('info', 20)}</div></div></div>`);
        const fg = row.firstElementChild;
        fg.prepend(window.PhoneDroid ? PhoneDroid.avatar(c || null, c ? c.name : (r.name || ''), 's44') : UI.el(UI.avatar({ name }, 'sm')));
        fg.querySelector('b').textContent = name === r.number && UI.phone ? UI.phone(name) : name;
        fg.querySelector('em').textContent = (typeof callLabel === 'function' ? callLabel(r) : '') + (r.duration ? ' · ' + UI.fmtDur(r.duration) : '');
        fg.querySelector('.aph-rt').textContent = UI.fmtTime(new Date(+r.created));
        fg.onclick = () => PhoneApp.facetime(r.number, name);
        fg.querySelector('[data-k="i"]').onclick = e => { e.stopPropagation(); if (window.PhoneDroid) PhoneDroid.numberInfo(win, r, appName()); };
        card.appendChild(row);
      });
    }
    paint();
    root.paint = paint;
    UI.setRoot(win, root);
    /* NOVA Fold8 aberto: lista à esquerda (520) e o aviso à direita; o (i) abre a ficha do número na coluna da direita */
    UI.split(win, { icon: 'video', title: appName(), sub: T('Liga a alguém da lista ou começa uma videochamada nova.') });
    return root;
  }
  return { screen, home };
})();
