/* ============================================================
   FACE ID - inscrição A SÉRIO (assistente e Definições)
   ------------------------------------------------------------
   O APARELHO NUNCA SAI DA FRENTE. O anel de 32 traços vive DENTRO do telemóvel e, no círculo do
   meio (.fid-frame), uma <canvas> WebGL mostra a vista do jogo AO VIVO - js/gamerender.js, o mesmo
   motor do visor da Câmara. Como a câmara scriptada do client/camera.lua já está presa à cara do
   personagem, o que se vê nesse círculo é a cara: dentro do telemóvel, no sítio dele.

   PORQUÊ ASSIM (duas tentativas anteriores que morreram, para não se repetirem):
     · "buraco" transparente no visor (System.seeThrough): o buraco só deixa ver o mundo ATRÁS do
       aparelho, e a cara é desenhada pela câmara scriptada no CENTRO do ecrã - nunca aparecia;
     · inscrição a ECRÃ INTEIRO com o telemóvel escondido: mostrava a cara, mas o aparelho saía da
       frente - rejeitado pelo utilizador.
   Com o GameRender o problema deixa de existir: a vista do jogo entra numa textura e essa textura
   desenha-se onde quisermos - neste caso, num círculo de ~150 px dentro do ecrã do telemóvel.

   A cara aponta-se com o RATO (é o rato que roda a câmara do jogo por trás, e é daí que sai a
   cobertura real de ângulos, que chega do Lua no evento `faceCoverage`). Como o aparelho fica
   visível e COM cursor, os botões são clicáveis; as teclas do jogo (Enter / Backspace, enviadas
   por Push('faceKey')) continuam a funcionar em paralelo - os dois caminhos.

   Fora do jogo (browser / _test.html) não há vista do jogo: o canvas não arranca, o anel enche-se
   pelo relógio e a fotografia vem do Mock - os ecrãs continuam a poder ser vistos e fotografados.
   ============================================================ */
window.FaceID = (() => {
  const TICKS = 32;
  const cfg = { Required: 26, Spread: 3, MinAngle: 5, MaxAngle: 46, Timeout: 25, Photo: true };
  const inGame = () => Bridge.inFiveM;
  const T = s => (window.L ? L.t(s) : s);
  /* NOVA S26 (Nova UI): o mesmo registo, com os nomes e o aspeto do sistema dele ("Reconhecimento facial", círculo de
     enquadramento e "Posicione o rosto no círculo"). A câmara, a cobertura e a fotografia são as mesmas */
  const isAnd = () => !!(window.System && System.os === 'android');

  /* Altura de render do visor da cara. O círculo tem ~150 px e a miniatura guardada 180 px: pedir
     mais do que isto seria desenhar (e codificar) pixéis que ninguém chega a ver. */
  const FACE_PX = 360;

  /* O raio do anel vem de --fid-r (CSS), para os traços não dependerem do tamanho do círculo. */
  function buildRing() {
    const g = UI.g;
    const el = UI.el(`<div class="fid-enroll"><div class="fid-ticks"></div>
      <div class="fid-frame"><canvas class="fid-gl"></canvas><div class="fid-ring"></div><div class="fid-glyph">${g('faceid')}</div><div class="fid-check">${g('check')}</div></div></div>`);
    const ticks = el.querySelector('.fid-ticks');
    for (let i = 0; i < TICKS; i++) ticks.appendChild(UI.el(`<i style="transform:rotate(${(i * 360 / TICKS).toFixed(1)}deg) translateY(calc(var(--fid-r, 96px) * -1))"></i>`));
    return el;
  }

  /* ============================================================
     engine(ringEl, opts) - máquina de estados + câmara + cobertura.
     Não é dono de nenhum ecrã: quem chama decide onde o anel vive (o passo do assistente põe-no
     dentro do próprio passo; as Definições põem-no num painel .fid-modal).
     ============================================================ */
  function engine(el, opts = {}) {
    const nodes = [...el.querySelectorAll('.fid-ticks i')];
    let state = 'ready', live = false, offCov = null, offKey = null, offOpen = null, offClose = null;
    let raf = 0, pump = null, t0 = 0, delay = null, grace = null;
    let covered = 0, total = TICKS, dead = false, paused = false;
    const ctl = { el, face: null, get state() { return state; }, get covered() { return covered; }, get total() { return total; } };

    const setState = st => { state = st; el.dataset.state = st; try { opts.onState && opts.onState(st, ctl); } catch (e) {} };
    /* ctl vai SEMPRE como argumento: estes callbacks correm durante o engine() e quem chama ainda
       tem a sua própria `const ctl` por atribuir - ler o closure dava ReferenceError. */
    const progress = () => { try { opts.onProgress && opts.onProgress(covered, total, ctl); } catch (e) {} };
    const paint = (mask, now) => { for (let i = 0; i < nodes.length; i++) { nodes[i].classList.toggle('on', mask.charAt(i) === '1'); nodes[i].classList.toggle('now', i === now); } };
    const paintN = n => { for (let i = 0; i < nodes.length; i++) { nodes[i].classList.toggle('on', i < n); nodes[i].classList.remove('now'); } };

    /* ---------- A cara AO VIVO dentro do círculo ---------- */
    const canvas = el.querySelector('.fid-gl');
    let render = null;
    function viewOn() {
      if (render || !canvas || !window.GameRender) return;   /* o `||` cobre um index.html em cache sem o js/gamerender.js */
      /* aspect 1 = recorte QUADRADO do centro do ecrã, que é exatamente onde a câmara scriptada
         põe a cara; `quality` limita o buffer a FACE_PX sem mexer no enquadramento. */
      const q = Math.min(1, FACE_PX / Math.max(1, window.innerHeight || FACE_PX));
      const r = GameRender.create(canvas, { aspect: 1, quality: q });
      /* fora do jogo (ou sem WebGL) o create() devolve o objeto inerte: não se marca `fid-live`,
         o canvas fica escondido e o círculo continua a mostrar o glifo a respirar. */
      if (!r.live) { try { r.destroy(); } catch (e) {} return; }
      render = r;
      el.classList.add('fid-live');
    }
    function viewOff() {
      el.classList.remove('fid-live');
      if (!render) return;
      try { render.destroy(); } catch (e) {}
      render = null;
    }

    /* ---------- Cobertura real vinda do jogo ---------- */
    function armCoverage(after) {
      covered = 0; progress(); paintN(0);
      clearTimeout(grace);
      /* rede de segurança: passado o prazo deixa continuar mesmo sem fechar o círculo - a
         inscrição nunca pode prender o jogador (dentro de um carro, encostado a uma parede…) */
      grace = setTimeout(() => { if (state === after || dead) return; finish(after); }, Math.max(8, cfg.Timeout) * 1000);
      offCov = Bridge.on('faceCoverage', d => {
        if (dead || !d) return;
        total = d.total || TICKS; covered = d.n || 0;
        paint(String(d.mask || ''), typeof d.now === 'number' ? d.now : -1);
        progress();
        if (covered >= Math.min(total, cfg.Required)) finish(after);
      });
    }
    function finish(after) {
      clearTimeout(grace); grace = null;
      if (offCov) { offCov(); offCov = null; }
      paintN(total);                       /* fecha o círculo: acabar com metade do anel apagado parecia avaria */
      setState(after);
    }

    /* ---------- Sem jogo: progressão pelo relógio (browser / harness) ---------- */
    const SCAN_MS = 2900;
    const stopFake = () => { if (raf) cancelAnimationFrame(raf); raf = 0; clearInterval(pump); pump = null; clearTimeout(delay); delay = null; };
    function fakeScan(after) {
      t0 = Date.now(); paintN(0); let fin = false;
      const frameFn = () => { if (fin) return; const p = Math.min(1, (Date.now() - t0) / SCAN_MS);
        const e = p < .5 ? 2 * p * p : 1 - Math.pow(-2 * p + 2, 2) / 2;
        covered = Math.round(e * TICKS); paintN(covered); progress();
        if (p >= 1) { fin = true; stopFake(); setState(after); } };
      const loop = () => { frameFn(); if (!fin) raf = requestAnimationFrame(loop); };
      raf = requestAnimationFrame(loop); pump = setInterval(frameFn, 120);   /* o rAF pára em segundo plano (e no headless nem arranca) */
    }

    /* ---------- Câmara ---------- */
    async function camOn() {
      if (!inGame() || live || dead) return;
      const r = await Bridge.callT('faceCam', { on: true }, 8000);
      /* a inscrição pode ter sido parada DURANTE a espera (o jogador voltou atrás): sem esta
         guarda ligava-se um visor WebGL que já ninguém desligava */
      if (dead) { Bridge.call('faceCam', { on: false }); return; }
      live = true;
      viewOn();
      try { opts.onLive && opts.onLive(true); } catch (e) {}
      ctl.shot = !!(r && r.shot);
    }
    function camOff() {
      if (!live) return; live = false;
      viewOff();
      try { opts.onLive && opts.onLive(false); } catch (e) {}
      Bridge.call('faceCam', { on: false });
    }
    offKey = Bridge.on('faceKey', d => { if (dead || !live) return; try { opts.onKey && opts.onKey(d && d.key, ctl); } catch (e) {} });
    /* fechar o telemóvel a meio: desliga a câmara e volta a ligá-la quando ele reabrir */
    offClose = Bridge.on('phone:close', () => { if (!live) return; paused = true; camOff(); });
    offOpen = Bridge.on('phone:open', () => { if (!paused || dead) return; paused = false; camOn(); });

    /* ---------- A fotografia da cara É O PRÓPRIO VISOR ----------
       O canvas já tem a cara enquadrada (é o que o jogador está a ver): a foto é esse canvas, não
       um screenshot do ecrã. Com o aparelho visível, um screenshot apanharia o telemóvel - por
       isso, no jogo, sem visor não há foto (a inscrição fica válida na mesma, só sem miniatura). */
    async function capture() {
      if (!cfg.Photo) return null;
      try {
        if (render && render.live) {
          render.renderOnce();                 /* um frame fresco, mesmo se o ciclo estiver em pausa */
          if (render.isPlaceholder()) { console.warn('[apex_phone] Face Key: o visor ainda mostra o pixel de espera (vermelho): sem fotografia'); return null; }
          if (render.isBlack()) { console.warn('[apex_phone] Face Key: o visor veio preto: sem fotografia'); return null; }
          const raw = render.toDataURL('image/jpeg', .92);
          if (!raw) { console.warn('[apex_phone] Face Key: o visor não codificou a imagem'); return null; }
          return await Photos.square(raw, 180, .72);
        }
        if (inGame()) { console.warn('[apex_phone] Face Key sem visor (WebGL indisponível): sem fotografia'); return null; }
        /* BROWSER / harness: não há vista do jogo, a imagem vem do Mock (localdb.js) */
        const r = await Bridge.callT('takePhoto', { raw: true, front: true }, 22000);
        if (!r || !r.raw) { console.warn('[apex_phone] Face Key sem foto:', r && r.error); return null; }
        return await Photos.square(r.raw, 180, .72);
      } catch (e) { console.error('[apex_phone] Face Key captura', e); return null; }
    }

    ctl.start = async () => {
      if (dead) return;
      await camOn();
      if (dead) { camOff(); return; }
      setState('scan1');
      if (inGame()) armCoverage('scan1done'); else { delay = setTimeout(() => fakeScan('scan1done'), 200); }
    };
    ctl.next = () => {                       /* 2.ª leitura (Continuar entre as duas) */
      if (dead || state !== 'scan1done') return;
      el.classList.remove('ok');
      setState('scan2');
      if (inGame()) { Bridge.call('faceReset'); armCoverage('success'); } else fakeScan('success');
    };
    ctl.finishUp = async () => {             /* tira a foto (do visor) e só depois desliga a câmara */
      if (dead) return null;
      const img = await capture();
      ctl.face = img || null;
      camOff();
      return ctl.face;
    };
    ctl.stop = () => {
      if (dead) return; dead = true;
      stopFake(); clearTimeout(grace); grace = null;
      [offCov, offKey, offOpen, offClose].forEach(f => { try { f && f(); } catch (e) {} });
      offCov = offKey = offOpen = offClose = null;
      camOff();
      viewOff();                             /* se a câmara nem chegou a ligar, o visor pode existir na mesma */
    };
    setState('ready');
    return ctl;
  }

  /* ============================================================
     session() - a inscrição completa num painel DENTRO do telemóvel (Definições › Face Key).
     Devolve a fotografia da cara, '' se correu mas não deu foto, ou null se o jogador desistiu.
     ============================================================ */
  let closeCurrent = null;                 /* para o abort(): só há uma inscrição de cada vez */
  function abort() { const f = closeCurrent; if (f) f(null); }
  function session() {
    return new Promise(resolve => {
      abort();
      const and = isAnd();
      const box = UI.el(`<div class="fid-modal${and ? ' afp-modal' : ''}">
        <div class="fid-head"><h2>${UI.esc(T(and ? 'Reconhecimento facial' : 'Configurar o Face Key'))}</h2><div class="sub">${and ? UI.esc(T('Põe o rosto dentro do círculo')) : ''}</div></div>
        <div class="fid-body"></div>
        <div class="fid-foot"><div class="btn-p dim">${UI.esc(btnLabel('Continuar'))}</div><div class="link">${UI.esc(btnLabel('Cancelar'))}</div></div></div>`);
      UI.screen().appendChild(box);
      requestAnimationFrame(() => box.classList.add('in'));

      const ring = buildRing();
      box.querySelector('.fid-body').appendChild(ring);
      const subEl = box.querySelector('.sub'), b = box.querySelector('.btn-p'), cancel = box.querySelector('.link');

      let closed = false;
      const done = v => {
        if (closed) return; closed = true;
        if (closeCurrent === done) closeCurrent = null;
        ctl.stop();
        box.classList.remove('in');
        setTimeout(() => box.remove(), 340);
        resolve(v);
      };
      closeCurrent = done;
      let saving = false;
      const accept = async () => {
        if (closed || saving) return;        /* o clique e a tecla chegam os dois: só o primeiro conta */
        if (ctl.state === 'scan1done') { ctl.next(); return; }
        if (ctl.state !== 'success') return;
        saving = true;
        b.classList.add('dim'); subEl.textContent = T('A guardar…');
        done((await ctl.finishUp()) || '');
      };
      const ctl = engine(ring, {
        onKey: k => { if (k === 'accept') accept(); else if (k === 'later') done(null); },
        onProgress: (n, t, c) => { if (c.state === 'scan1' || c.state === 'scan2') subEl.textContent = hint(n, t); },
        onState: (st, c) => {
          if (st === 'scan1' || st === 'scan2') { subEl.textContent = hint(0, TICKS); b.classList.add('dim'); }
          else if (st === 'scan1done') { subEl.textContent = T(and ? 'Primeira leitura concluída. Toque em Continuar.' : 'Primeira leitura concluída.'); c.el.classList.add('flash'); Sound.play('tap'); b.classList.remove('dim'); setTimeout(() => c.el.classList.remove('flash'), 520); }
          else if (st === 'success') { subEl.textContent = T(and ? 'O reconhecimento facial está configurado.' : 'O Face Key está configurado.'); c.el.classList.add('ok'); Sound.play('success'); b.classList.remove('dim'); }
        }
      });
      b.onclick = accept;
      cancel.onclick = () => done(null);
      ctl.start();
    });
  }

  /* O aparelho está no ecrã e com cursor: os botões são botões a sério. As teclas do jogo continuam
     a funcionar por Push('faceKey'), mas já não precisam de vir escritas no rótulo. */
  const btnLabel = l => T(l);
  const hint = (n, t) => isAnd() ? hintA(n, t) : !Bridge.inFiveM ? T('A ler a sua cara…')
    : n <= 0 ? T('Mexa a cabeça devagar com o rato.')
    : n >= t * .75 ? T('Quase: falta pouco para fechar o círculo.')
    : T('Continue a mexer para completar o círculo.');
  /* Nova UI: as mesmas instruções, na voz do sistema */
  const hintA = (n, t) => !Bridge.inFiveM ? T('Põe o rosto dentro do círculo')
    : n <= 0 ? T('Põe o rosto dentro do círculo e mexe a cabeça devagar com o rato.')
    : n >= t * .75 ? T('Quase pronto. Falta pouco para completar o círculo.')
    : T('Continua a mexer a cabeça devagar para completar o círculo.');

  /* ---------- Guardar / ler a referência ---------- */
  async function save(face) {
    const r = await Bridge.rpcRaw('account.setFace', { face: face || '' });
    if (System.account) System.account.face = face || null;
    Bridge.emit('faceid:changed', face || null);
    return !!(r && r.ok);
  }
  const stored = () => (System.account && System.account.face) || null;
  const enabled = () => System.state.faceIdUnlock === true;

  return { TICKS, cfg, session, run: session, abort, save, stored, enabled, hint, btnLabel, buildRing, engine, set config(c) { Object.assign(cfg, c || {}); } };
})();
