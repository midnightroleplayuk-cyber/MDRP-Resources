/* ============================================================
   CONTROL CENTER - ligações, música, brilho/volume, atalhos
   configuráveis (Definições > Centro de controlo)
   Grelha PearOS 17: 4 colunas dentro de 396 px (margens 22 px),
   sliders verticais com pointer capture, brilho aplicado por
   overlay (.bright-ov) - mecanismo único, ver CC.applyBrightness
   ============================================================ */
window.CC = (() => {
  const g = UI.g; let el, panel, timer = null, brightOv = null, dragging = false, self = false, dirty = false;
  /* ---------- Foco: System.state.focus = 'none' | 'dnd' | 'work' | 'sleep' ----------
     `dnd` continua a ser o interruptor mestre (o notify.js e a barra de estado leem-no): qualquer modo ligado põe dnd=true.
     Contas antigas só com dnd:true contam como "Não incomodar". */
  const FOCUS = { none: 'Sem foco', dnd: 'Não incomodar', work: 'Trabalho', sleep: 'Dormir' };
  const FOCUS_ICON = { none: 'moon', dnd: 'moon', work: 'briefcase', sleep: 'moon' };
  const focusOf = S => { if (!S.dnd) return 'none'; return FOCUS[S.focus] && S.focus !== 'none' ? S.focus : 'dnd'; };
  function setFocus(mode) {
    if (!FOCUS[mode]) mode = 'none'; const on = mode !== 'none';
    const p = { focus: mode, dnd: on }; if (on) p.focusLast = mode;   /* focusLast: o toque simples no mosaico volta a ligar o último modo usado */
    System.setState(p); UI.toast(on ? `${L.t(FOCUS[mode])} · ${L.t('ativado')}` : L.t('Foco desativado'));
  }
  async function pickFocus() {
    const cur = focusOf(System.state);
    const v = await UI.actionSheet({ title: L.t('Foco'), buttons: Object.keys(FOCUS).map(k => ({ label: L.t(FOCUS[k]) + (k === cur ? ' ✓' : ''), value: k, icon: FOCUS_ICON[k] })) });
    if (v != null) { Sound.play('click'); setFocus(v); }
  }
  /* ---------- Mosaicos ----------
     Revisão 2026-09-16 (SHELL-04 / MEDIA-15): SAÍRAM três mosaicos que acendiam e não faziam nada -
       · Rotação (`rotationLock`): o ecrã do telemóvel é fixo (440×956), não há modo horizontal em sítio
         nenhum do recurso; um "bloqueio de rotação" era um interruptor sobre algo que nunca acontece.
       · Espelhar ecrã (`mirroring`): não há segundo ecrã nem nada que leia a chave (mesmo caso do
         AirShare/AirPlay retirados das Definições).
       · "Reconhecer" (Shazam): fazia `UI.toast('A ouvir…')` e mais nada - não existe reconhecimento de
         música em nenhum ficheiro. ("Gravar ecrã" saiu depois, na auditoria de 2026-09-17: honesto mas inútil.)
     Contas antigas têm estas chaves em `state.cc`; o render filtra por `TILES[k]`, por isso desaparecem
     sozinhas (e das Definições › Centro de controlo, que listam o CC.TILES). */
  const TILES = {
    torch: { icon: 'flashlight', label: 'Lanterna', get on() { return !!System.state.torch; }, tap: () => System.torch(!System.state.torch) },
    timer: { icon: 'timer', label: 'Temporizador', app: 'clock' }, calc: { icon: 'calc', label: 'Calculadora', app: 'calculator' }, camera: { icon: 'camera', label: 'Câmara', app: 'camera' },
    /* "Hotspot" e "Gravar ecrã" retirados (auditoria 2026-09-17): um só acendia um ícone na barra, o outro dizia "não disponível";
       contas antigas com estas chaves em state.cc perdem-nas sozinhas (o render filtra por TILES[k]) */
    earbuds: { icon: 'earbuds', label: 'Áudio', wide: true, get on() { return !!System.state.earbuds; }, tap: () => window.Earbuds && Earbuds.toggle() },
    /* AirShare (pacote AD): o toque alterna Desligado ⇄ Todos (o "Só contactos" fica nas Definições › Geral › AirShare);
       o estado é o System.state.airdrop, gravado na conta e anunciado ao servidor pelo AirDrop.js */
    airdrop: { icon: 'airdrop', label: 'AirShare', get on() { return !!(window.AirDrop && AirDrop.mode && AirDrop.mode() !== 'off'); }, tap: () => window.AirDrop && AirDrop.toggle && AirDrop.toggle() },
    vera: { icon: 'sparkles', label: 'Vera', tap: () => { close(); Vera.open(); } }, notes: { icon: 'compose', label: 'Nota rápida', app: 'notes' },
    wallet: { icon: 'card', label: 'Wallet', app: 'wallet' }, alarm: { icon: 'alarm', label: 'Alarme', app: 'clock' },
    /* Rodar (2026-09-19): deita o telemóvel na app aberta (System.rotate - Câmara, jogos, Surf, Fotos). Volta a existir porque agora
       HÁ modo horizontal; aceso enquanto estiver deitado. Sem app (ou app que não roda) o System diz porquê. */
    rotate: { icon: 'rotate', label: 'Rodar', get on() { return !!(window.System && System.landscape); }, tap: () => { const on = !System.landscape; if (System.rotate(on) && on) close(); } },
  };
  /* mosaicos que existem SEMPRE e não entram no CC.TILES exportado: as Definições › Centro de controlo listam o CC.TILES como
     interruptores e um mosaico fixo lá era um interruptor que não fazia nada.
     Silêncio: o mesmo do botão de Ação (Hardware.silent corta toque e sons de notificação e mostra o HUD na ilha)
     Poupança: tem efeito real e verificável (o ícone da bateria fica amarelo - system.js renderStatus) e as
     Definições › Bateria já explicam que é só isso. Ficou no lugar da "Rotação", para a grelha de 4 colunas
     continuar a encaixar (os dois sliders ocupam as colunas 3-4 das linhas 3-4).
     Foco: veio para aqui pela mesma razão do Silêncio e da Poupança - o mosaico é FIXO (o render desenha-o
     sempre, esteja ou não no `state.cc`), mas como estava no CC.TILES as Definições › Centro de controlo
     mostravam-no como um interruptor "Foco" que não fazia absolutamente nada ao ser desligado. */
  const FIXED_TILES = {
    silent: { icon: 'bellOff', label: 'Silêncio', get on() { return !!System.state.silent; }, tap: () => { if (window.Hardware && Hardware.silent) Hardware.silent(!System.state.silent); else { System.setState({ silent: !System.state.silent }, { noApply: true }); System.renderStatus(); } } },
    lowpower: { icon: 'lowpower', label: 'Poupança', key: 'lowPower' },
    /* Foco: toque = liga/desliga (último modo, "Não incomodar" por omissão); manter pressionado = escolher o modo */
    dnd: { icon: 'moon', label: 'Foco', get on() { return focusOf(System.state) !== 'none'; }, tap: () => { const S = System.state; setFocus(focusOf(S) !== 'none' ? 'none' : (FOCUS[S.focusLast] && S.focusLast !== 'none' ? S.focusLast : 'dnd')); }, long: pickFocus },
  };
  const tileOf = k => TILES[k] || FIXED_TILES[k];
  /* Android (Nova UI, 2026-10-01): o painel rapido (shell/android-panel.js) desenha os seus proprios botoes, mas as ACOES
     e o ESTADO sao estes, os mesmos do Centro de controlo: um Wi-Fi ligado num sistema esta ligado no outro, porque e a
     mesma chave da conta. As entradas abaixo so existem para o painel da Nova UI e por isso ficam FORA do CC.TILES
     (as Definicoes do PearOS listam o CC.TILES como interruptores e o Centro de controlo desenha-o). */
  const NET_LABEL = { airplane: 'Modo de voo', cellular: 'Dados móveis', wifi: 'Wi-Fi', bt: 'Bluetooth', hotspot: 'Ponto de acesso' };
  const NET_TILES = {
    wifi: { icon: 'wifi', label: 'Wi-Fi', get on() { const S = System.state; return !!S.wifi && !S.airplane; }, tap: () => toggleNet('wifi') },
    cellular: { icon: 'cellular', label: 'Dados móveis', get on() { const S = System.state; return !!S.cellular && !S.airplane; }, tap: () => toggleNet('cellular') },
    bt: { icon: 'bluetooth', label: 'Bluetooth', get on() { return !!System.state.bt; }, tap: () => toggleNet('bt') },
    airplane: { icon: 'airplane', label: 'Modo de voo', get on() { return !!System.state.airplane; }, tap: () => toggleNet('airplane') },
    /* ponto de acesso: o mesmo `hotspot` que o netPatch ja tratava (o modo de voo e os dados moveis desligam-no) */
    hotspot: { icon: 'hotspot', label: 'Ponto de acesso', get on() { const S = System.state; return !!S.hotspot && !S.airplane; }, tap: () => toggleNet('hotspot') },
  };
  const EXTRA_TILES = {
    /* localizacao: o `locationOn` que o Perm (permissions.js) ja le, e a mesma chave das Definicoes › Privacidade */
    location: { icon: 'location', label: 'Localização', get on() { return System.state.locationOn !== false; }, tap: () => System.setState({ locationOn: System.state.locationOn === false }) },
    /* modo escuro: o tema da conta (o "automatico" passa a escolha explicita, como nas Definicoes) */
    darkmode: { icon: 'moon', label: 'Modo escuro', get on() { return !!System.state.dark; }, tap: () => System.setState({ theme: System.state.dark ? 'light' : 'dark' }) },
    /* conforto visual: o mesmo veu ambar do Night Shift (system.js apply) */
    eyecomfort: { icon: 'eye', label: 'Conforto visual', key: 'nightShift' },
    /* dobraveis: abrir/fechar o ecra (System.setFoldOpen). Fixo nos dobraveis, fora das listas editaveis */
    fold: { icon: 'fold', get label() { return foldLabel(); }, get on() { return isFold() && !!System.foldOpen; }, tap: () => toggleFold() },
  };
  /* ---------- DOBRAVEIS: o mosaico "Abrir ecra" / "Fechar ecra" (iOS e Android) ---------- */
  const isFold = () => !!(window.System && System.form === 'fold');
  const foldLabel = () => (window.System && System.foldOpen) ? 'Fechar ecrã' : 'Abrir ecrã';
  /* glifo do estado PARA ONDE vai: fechado mostra o aparelho aberto (largo, com a dobradica), aberto mostra-o fechado */
  const foldGlyph = open => open
    ? '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="6.5" y="3" width="11" height="18" rx="2.6"/><path d="M10.5 18h3"/></svg>'
    : '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="2.5" y="5" width="19" height="14" rx="2.6"/><path d="M12 5v14" stroke-dasharray="2 2.2"/></svg>';
  /* fecha os paineis e abre/fecha (o system.js fecha o resto que e passageiro quando a geometria muda) */
  function toggleFold() {
    if (!isFold()) return false;
    const to = !System.foldOpen;
    close();
    if (window.QuickPanel && QuickPanel.close) QuickPanel.close();
    try { Promise.resolve(System.setFoldOpen(to)).catch(() => {}); } catch (e) { console.error('[apex_phone] setFoldOpen', e); }
    return true;
  }
  const anyTile = k => tileOf(k) || NET_TILES[k] || EXTRA_TILES[k] || null;
  const android = () => !!(window.System && System.isAndroid && System.isAndroid());
  const clamp = v => Math.max(0, Math.min(100, v));
  const num = v => { const n = +v; return isNaN(n) ? 0 : n; };
  /* escala real do ecrã (zoom CSS no jogo): px do rato → px do ecrã (440) */
  const zoom = () => UI.zoom();   /* em cache (ui.js): os sliders não forçam layout em cada pointermove */

  /* ---------- REDE: uma fonte só, e com efeito ----------
     Antes o modo de voo, os dados e o Wi-Fi só pintavam o botão e a barra de estado: nada no telemóvel
     perguntava se havia rede, mas o aviso dizia "ativado". Agora `CC.online()` é a resposta única -
     quem precisa do servidor pergunta e recusa com a razão certa (ecrã bloqueado › Emergência, Vera,
     Definições › Trocar SIM). O `requireNet` serve para quem só precisa de avisar e desistir. */
  const online = () => { const S = System.state; return !S.airplane && (!!S.wifi || !!S.cellular); };
  function requireNet(what) {
    if (online()) return true;
    UI.toast(System.state.airplane ? 'Modo de voo ligado · ' + (what || 'isto') + ' precisa de rede' : 'Sem rede · liga o Wi-Fi ou os dados móveis');
    return false;
  }
  /* Coerência dos quatro redondos (SHELL-N2): o modo de voo desliga MESMO o Wi-Fi, os dados e o hotspot;
     ligar o Wi-Fi/dados/hotspot com ele ligado desliga o modo de voo, como no PearPhone. Antes o toque
     gravava `wifi:true` com `airplane:true`, o botão continuava apagado (só acende com `!airplane`) e
     o aviso anunciava "Wi-Fi ativado" - estado incoerente gravado na conta e um aviso falso. */
  function netPatch(k, on) {
    const S = System.state; const p = { [k]: on };
    if (k === 'airplane') { if (on) { p.wifi = false; p.cellular = false; p.hotspot = false; } else p.cellular = true; }
    else if (on && S.airplane && (k === 'wifi' || k === 'cellular' || k === 'hotspot')) p.airplane = false;
    else if (k === 'cellular' && !on && S.hotspot) p.hotspot = false;   /* sem dados não há hotspot */
    return p;
  }
  /* Tocar num dos interruptores de rede (os quatro redondos do CC e os mosaicos do painel da Nova UI): uma funcao so,
     para os dois sistemas terem exatamente o mesmo efeito. O aviso do PearOS fica tal e qual; o da Nova UI concorda
     o genero ("Dados móveis ligados"). */
  function toggleNet(k) {
    const S = System.state; const on = !S[k]; const p = k === 'bt' ? { bt: on } : netPatch(k, on);
    /* desligar o Bluetooth desliga os earbuds a sério (o servidor guarda o estado da sessão): antes ficava
       "Bluetooth desligado" com os earbuds a dizerem-se ligados */
    if (k === 'bt' && !on && S.earbuds && window.Earbuds && Earbuds.disconnect) Earbuds.disconnect();
    System.setState(p); Sound.play('click');
    /* o aviso diz só o que ACONTECEU (os interruptores que mudaram). "sem rede" seria prometer de mais:
       quem pergunta pela rede (ecrã bloqueado › Emergência, Vera, Trocar SIM) recusa, mas as apps que ainda
       não perguntam continuam a falar com o servidor; dizer "sem rede" era anunciar um efeito maior do que o real. */
    const extra = k === 'airplane' ? (on ? ' · sem Wi-Fi nem dados' : ' · dados móveis ligados')
      : p.airplane === false ? ' · modo de voo desligado'
      : (k === 'cellular' && p.hotspot === false) ? ' · hotspot desligado' : '';
    if (android()) {
      const T = s => (window.L && L.t ? L.t(s) : s);
      const st = k === 'cellular' ? (on ? 'ligados' : 'desligados') : (on ? 'ligado' : 'desligado');
      const ex = k === 'airplane' ? (on ? ' · ' + T('sem Wi-Fi nem dados') : ' · ' + T('dados móveis ligados'))
        : p.airplane === false ? ' · ' + T('modo de voo desligado')
        : (k === 'cellular' && p.hotspot === false) ? ' · ' + T('ponto de acesso desligado') : '';
      UI.toast(T(NET_LABEL[k]) + ' ' + T(st) + ex);
    } else UI.toast(NET_LABEL[k] + (on ? ' ligado' : ' desligado') + extra);
    return on;
  }
  /* Tocar num mosaico (CC e painel rapido): o mesmo efeito nos dois sistemas. Devolve false se o id nao existir. */
  function tileTap(k) {
    const t = anyTile(k); if (!t) return false; const S = System.state;
    if (t.key) System.setState(t.key === 'hotspot' ? netPatch('hotspot', !S.hotspot) : { [t.key]: !S[t.key] });
    else if (t.app) { close(); System.openApp(t.app); }
    else if (t.tap) t.tap();
    return true;
  }
  const tileOn = k => { const t = anyTile(k); if (!t) return false; return t.key ? !!System.state[t.key] : !!t.on; };

  /* ---------- Brilho: overlay preto sobre o ecrã (único mecanismo) ---------- */
  function applyBrightness(v) {
    const scr = UI.screen(); if (!scr) return;
    if (!brightOv || !brightOv.isConnected) { brightOv = scr.querySelector('.bright-ov') || UI.el('<div class="bright-ov"></div>'); if (!brightOv.isConnected) scr.appendChild(brightOv); }
    const b = clamp(num(v == null ? System.state.brightness : v)) / 100;
    /* acima de 75 % não escurece nada (no jogo o ecrã já é pequeno); abaixo escurece progressivamente até ~80 % */
    brightOv.style.opacity = (Math.max(0, .75 - b) * 1.08).toFixed(3);
  }

  function init() {
    if (el && el.isConnected) return;
    /* .cc-power (PearOS 18+/26): o botão redondo de vidro no canto superior direito abre o "deslize para desligar" (Hardware) */
    /* .cc-plus: o "+" (editar controlos) no canto de cima à esquerda da grelha, só no PearPhone Fold (Duo; liquid27.css): lá
       substitui o texto "Editar controlos" do fim da grelha. Nos outros aparelhos fica escondido */
    el = UI.el(`<div id="cc"><div class="cc-panel"></div><div class="cc-power">${g('power')}</div><div class="cc-plus" role="button">${g('plus')}</div></div>`); panel = el.querySelector('.cc-panel'); UI.screen().appendChild(el);
    el.onclick = e => { if (e.target === el) close(); }; UI.swipe(el, { up: close, threshold: 70 });
    el.querySelector('.cc-power').onclick = e => { e.stopPropagation(); Sound.play('click'); close(); if (window.Hardware && Hardware.showPowerOff) setTimeout(() => Hardware.showPowerOff(), 120); };
    const plus = el.querySelector('.cc-plus'); plus.setAttribute('aria-label', window.L && L.t ? L.t('Editar controlos') : 'Editar controlos');
    plus.onclick = e => { e.stopPropagation(); Sound.play('click'); close(); System.openApp('settings'); setTimeout(() => Bridge.emit('settings:goto', 'cc'), 300); };
    Bridge.on('state', () => { if (self || !ccOpen()) return; if (dragging) dirty = true; else render(); });
    Bridge.on('torch', () => { if (ccOpen() && !dragging) render(); });
    applyBrightness();
  }
  /* ccOpen: o painel do PearOS (#cc). isOpen (exportado): no Android responde o painel rapido da Nova UI, que e quem
     faz de Centro de controlo nesse sistema */
  const ccOpen = () => !!el && el.classList.contains('in');
  const isOpen = () => android() ? !!(window.QuickPanel && QuickPanel.isOpen()) : ccOpen();

  /* ---------- Ícones dos sliders (mudam com o nível) ---------- */
  const volGlyph = v => v <= 0 ? 'volumeX' : v < 50 ? 'speakerLow' : 'speaker';
  const sliderHtml = (key, v) => { const ic = key === 'brightness' ? g('sun') : g(volGlyph(v)); return `<div class="cc-slider ${key === 'brightness' ? 'sl-bright' : 'sl-vol'} ${v < 50 ? 'lo' : ''}" data-key="${key}"><div class="ic base">${ic}</div><div class="fill" style="height:${clamp(num(v))}%"><div class="ic top">${ic}</div></div></div>`; };
  function paintSlider(sl, v) {
    const key = sl.dataset.key; sl.querySelector('.fill').style.height = clamp(v) + '%'; sl.classList.toggle('lo', v < 50);
    if (key === 'volume') { const gl = volGlyph(v); if (sl.dataset.gl !== gl) { sl.dataset.gl = gl; sl.querySelectorAll('.ic').forEach(i => i.innerHTML = g(gl)); } }
  }
  /* nivel de brilho/volume: um so sitio para os sliders verticais do CC e os horizontais do painel da Nova UI.
     final=false: so a memoria e o veu do brilho (durante o arrasto); final=true: grava na conta (o volume sem apply). */
  function level(key, v, final) {
    if (key !== 'brightness' && key !== 'volume') return 0;
    v = Math.round(clamp(num(v)));
    if (!final) System.state[key] = v;
    else { self = true; try { System.setState({ [key]: v }, key === 'volume' ? { noApply: true } : {}); } finally { self = false; } }
    if (key === 'brightness') applyBrightness(v);
    return v;
  }
  function setLive(sl, v) { const key = sl.dataset.key; v = Math.round(clamp(v)); paintSlider(sl, v); level(key, v, false); }
  function commit(sl, v) { const key = sl.dataset.key; v = Math.round(clamp(v)); paintSlider(sl, v); level(key, v, true); }
  /* pointer capture; arrasto relativo (como no PearOS), toque define o valor absoluto; tudo em unidades do ecrã */
  function bindSlider(sl) {
    let st = null;
    sl.addEventListener('pointerdown', e => {
      if (e.button != null && e.button !== 0) return; e.stopPropagation(); e.preventDefault();
      const r = sl.getBoundingClientRect(); if (!r.height) return; const k = zoom();
      st = { id: e.pointerId, y0: e.clientY, v0: num(System.state[sl.dataset.key]), h: r.height / k, abs: (1 - (e.clientY - r.top) / r.height) * 100, moved: false, t: Date.now() };
      try { sl.setPointerCapture(e.pointerId); } catch (_) {}
      dragging = true; sl.classList.add('drag');
    });
    sl.addEventListener('pointermove', e => {
      if (!st) return; e.stopPropagation(); const dy = (st.y0 - e.clientY) / zoom();
      if (!st.moved && Math.abs(dy) > 3) st.moved = true; if (!st.moved) return;
      const nv = st.v0 + (dy / st.h) * 100; setLive(sl, nv);
      /* som de passo, como o háptico do PearPhone: um tique a cada 10 % e nos extremos (0 e 100) */
      const step = Math.round(Math.max(0, Math.min(100, nv)) / 10); if (st.step !== undefined && step !== st.step) Sound.play('tick'); st.step = step;
    });
    const end = (e, cancel) => {
      if (!st) return; e.stopPropagation(); const s = st; st = null; dragging = false; sl.classList.remove('drag');
      try { sl.releasePointerCapture(s.id); } catch (_) {}
      const v = s.moved ? num(System.state[sl.dataset.key]) : (cancel ? s.v0 : s.abs);
      commit(sl, v);
      if (dirty) { dirty = false; render(); }
    };
    sl.addEventListener('pointerup', e => end(e, false)); sl.addEventListener('pointercancel', e => end(e, true));
    sl.addEventListener('lostpointercapture', e => { if (st) end(e, false); });
    sl.addEventListener('click', e => e.stopPropagation());
  }

  /* mosaicos FIXOS (fora da lista configurável): Poupança e Foco ao lado da música, Silêncio na linha de baixo - a grelha de
     4 colunas continua a encaixar (os dois sliders ocupam as colunas 3-4 das linhas 3-4) */
  const FIXED = ['lowpower', 'dnd', 'silent'];
  function render() {
    if (!panel) return;
    const S = System.state; const P = window.Player; const cur = P && P.cur(); const fm = focusOf(S);
    panel.innerHTML = `
      <div class="cc-mod conn"><div class="cc-round orange ${S.airplane ? 'on' : ''}" data-k="airplane">${g('airplane')}</div><div class="cc-round green ${S.cellular && !S.airplane ? 'on' : ''}" data-k="cellular">${g('cellular')}</div><div class="cc-round blue ${S.wifi && !S.airplane ? 'on' : ''}" data-k="wifi">${g('wifi')}</div><div class="cc-round blue ${S.bt ? 'on' : ''}" data-k="bt">${g('bluetooth')}</div></div>
      <div class="cc-mod music">${musicHtml(cur && P.playing)}</div>
      <div class="cc-tile ${S.lowPower ? 'on' : ''}" data-t="lowpower">${g('lowpower')}</div><div class="cc-tile focus f-${fm} ${fm !== 'none' ? 'on' : ''}" data-t="dnd">${g(FOCUS_ICON[fm])}</div>
      ${sliderHtml('brightness', num(S.brightness))}${sliderHtml('volume', num(S.volume))}
      <div class="cc-tile silent ${S.silent ? 'on' : ''}" data-t="silent">${g(S.silent ? 'bellOff' : 'bell')}</div>
      ${(S.cc || []).filter(k => TILES[k] && !FIXED.includes(k) && !TILES[k].wide).map(k => tileHtml(k, S)).join('')}
      ${isFold() ? `<div class="cc-tile wide cc-fold" data-t="fold" role="button">${foldGlyph(!!System.foldOpen)}<span>${UI.esc(L.t(foldLabel()))}</span></div>` : ''}
      ${(S.cc || []).filter(k => TILES[k] && TILES[k].wide).map(k => tileHtml(k, S)).join('')}
      <div class="cc-edit">Editar controlos</div>`;
    /* os quatro redondos: a mesma funcao do painel da Nova UI (toggleNet) */
    panel.querySelectorAll('.cc-round').forEach(b => b.onclick = () => toggleNet(b.dataset.k));
    panel.querySelectorAll('.cc-tile').forEach(b => {
      /* dobraveis: abrir/fechar o ecra (o painel fecha antes de a folha rodar) */
      if (b.dataset.t === 'fold') { b.onclick = () => { Sound.play('click'); toggleFold(); }; return; }
      /* manter pressionado (mosaicos com `long`): o clique que vem a seguir ao long press não pode também alternar */
      const t0 = tileOf(b.dataset.t); if (t0 && t0.long) { UI.longPress(b, () => { b._lp = true; Sound.play('pop'); t0.long(); }); b.addEventListener('pointerdown', () => { b._lp = false; }); }
      b.onclick = () => { if (b._lp) { b._lp = false; return; } const t = tileOf(b.dataset.t); if (!t) return; Sound.play('click'); tileTap(b.dataset.t); if (!t.key && !t.app && t.tap) render(); };
    });
    bindMusic(panel.querySelector('.cc-mod.music'), { empty: () => { close(); System.openApp('music'); } });
    panel.querySelectorAll('.cc-slider').forEach(bindSlider);
    panel.querySelector('.cc-edit').onclick = () => { close(); System.openApp('settings'); setTimeout(() => Bridge.emit('settings:goto', 'cc'), 300); };
    paintMusic();
  }
  function tileHtml(k, S) { const t = TILES[k]; const on = t.key ? !!S[t.key] : !!t.on; return `<div class="cc-tile ${t.wide ? 'wide' : ''} ${on ? 'on' : ''}" data-t="${k}">${g(t.icon)}${t.wide ? `<span>${t.label}</span>` : ''}</div>`; }

  /* ---------- módulo de música: capa REAL por CSSOM (nunca url() dentro de uma string de HTML), título, progresso ----------
     O MESMO módulo serve o Centro de controlo e o cartão "A tocar" do ecrã bloqueado (MEDIA-13): o HTML, os
     ouvintes e a pintura vivem aqui (CC.music), o lock.js só pede um e diz onde o pôr - nada de duas cópias. */
  const musicHtml = playing => `<div class="row"><div class="art"></div><div class="meta"><div class="t"></div><div class="a"></div></div></div><div class="cc-prog"><div class="cc-bar"><i></i></div><div class="cc-times"><span class="el"></span><span class="len"></span></div></div><div class="ctl"><div class="prev">${g('prev')}</div><div class="play">${g(playing ? 'pause' : 'play')}</div><div class="next">${g('next')}</div></div>`;
  const paintBar = (m, f) => { const i = m && m.querySelector('.cc-bar i'); if (i) i.style.transform = `scaleX(${Math.max(0, Math.min(1, f)).toFixed(4)})`; };
  /* opts.empty: o que fazer no play sem faixa nenhuma (no CC abre a app Música; no ecrã bloqueado pede o código) */
  function bindMusic(m, opts = {}) {
    if (!m) return m;
    const P = () => window.Player;
    m.querySelector('.prev').onclick = () => { const p = P(); if (p) { p.prev(); setTimeout(() => paintMusic(m), 120); } };
    m.querySelector('.next').onclick = () => { const p = P(); if (p) { p.next(); setTimeout(() => paintMusic(m), 120); } };
    m.querySelector('.play').onclick = () => { const p = P(); const c = p && p.cur(); if (!c) { if (opts.empty) opts.empty(); return; } p.toggle(); paintMusic(m); };
    /* barra de progresso: tocar/arrastar faz seek (Player.seek recebe a fração 0..1) */
    const bar = m.querySelector('.cc-bar'); let sk = null;
    const frac = e => { const r = bar.getBoundingClientRect(); return r.width ? Math.max(0, Math.min(1, (e.clientX - r.left) / r.width)) : 0; };
    bar.addEventListener('pointerdown', e => { const p = P(); const c = p && p.cur(); if (!c || !(c.dur > 0)) return; e.stopPropagation(); sk = { f: frac(e) }; try { bar.setPointerCapture(e.pointerId); } catch (x) {} paintBar(m, sk.f); });
    bar.addEventListener('pointermove', e => { if (!sk) return; e.stopPropagation(); sk.f = frac(e); paintBar(m, sk.f); });
    bar.addEventListener('pointerup', e => { if (!sk) return; e.stopPropagation(); const f = sk.f; sk = null; const p = P(); if (p && p.seek) p.seek(f); setTimeout(() => paintMusic(m), 250); });
    bar.addEventListener('pointercancel', () => { sk = null; paintMusic(m); });
    bar._seeking = () => !!sk;
    return m;
  }
  function paintMusic(m) {
    m = m || (panel && panel.querySelector('.cc-mod.music')); if (!m) return;
    const P = window.Player; const cur = P && P.cur ? P.cur() : null;
    const set = (sel, txt) => { const n = m.querySelector(sel); if (n && n.textContent !== txt) n.textContent = txt; };
    set('.t', cur ? String(cur.title || '') : 'Nada a tocar'); set('.a', cur ? String(cur.artist || '') : 'Música');
    const art = m.querySelector('.art'); const sig = cur ? (cur.id || '') + '|' + (cur.img || '') : '';
    if (art && art._sig !== sig) { art._sig = sig;
      const hex = v => /^#[0-9a-f]{3,8}$/i.test(String(v || '')) ? v : null;   /* só #hex entra no gradiente */
      const cc = cur && Array.isArray(cur.c) ? cur.c.map(hex) : null; const grad = cc && cc[0] ? `linear-gradient(135deg,${cc[0]},${cc[1] || cc[0]})` : '';
      const img = cur && typeof cur.img === 'string' && cur.img ? UI.img(cur.img) : '';
      art.style.backgroundImage = [img, grad].filter(Boolean).join(',');   /* a imagem por cima; o gradiente fica por baixo enquanto ela carrega ou se falhar */
      if (!art.style.backgroundImage && grad) art.style.backgroundImage = grad;   /* url inválido rejeitava a declaração inteira (sem capa nem gradiente) */
      art.classList.toggle('has', !!cur); }
    const play = m.querySelector('.play'); const want = cur && P.playing ? 'pause' : 'play'; if (play && play.dataset.gl !== want) { play.dataset.gl = want; play.innerHTML = g(want); }
    const bar = m.querySelector('.cc-bar'); const dur = cur ? +cur.dur || 0 : 0; const pos = cur ? Math.max(0, +P.pos || 0) : 0;
    m.classList.toggle('noprog', !(dur > 0));
    if (bar && !(bar._seeking && bar._seeking())) paintBar(m, dur > 0 ? pos / dur : 0);
    set('.el', dur > 0 ? UI.fmtDur(Math.min(pos, dur)) : ''); set('.len', dur > 0 ? '-' + UI.fmtDur(Math.max(0, dur - pos)) : '');
  }

  /* No Android o Centro de controlo e o painel de definicoes rapidas da Nova UI (QuickPanel): open/close/toggle delegam
     nele, para o gesto, as teclas (F9) e quem chama CC.open/close continuarem a funcionar sem saber qual e o sistema */
  /* PearPhone Fold: com o Centro de controlo aberto o anel da barra direita mostra o glifo da carga (liquid27.css, #screen.cc-on) */
  const ccFlag = on => { const s = UI.screen(); if (s && s.classList.contains('cc-on') !== !!on) s.classList.toggle('cc-on', !!on); };
  function open(silent) {
    if (android()) { if (window.QuickPanel && QuickPanel.open) QuickPanel.open('qs', { silent: !!silent }); return; }
    if (!el) return; if (!el.classList.contains('in')) { render(); panel.scrollTop = 0; } el.classList.add('in'); ccFlag(true); if (!silent) Sound.play('pop'); clearInterval(timer); timer = setInterval(() => { try { paintMusic(); } catch (e) {} }, 1000); Bridge.emit('overlay', 'cc'); }
  function close() {
    if (android() && window.QuickPanel && QuickPanel.close) QuickPanel.close();
    if (!el) return; el.classList.remove('in'); ccFlag(false); clearInterval(timer); dragging = false; }
  const toggle = () => { if (android()) { if (window.QuickPanel && QuickPanel.toggle) QuickPanel.toggle('qs'); return; } if (ccOpen()) close(); else open(); };
  return { init, open, close, toggle, isOpen, TILES, applyBrightness,
    /* netPatch exportado: as Definições mexem nos MESMOS quatro interruptores e tinham a regra copiada à mão
       (a linha do modo de voo esquecia-se de devolver os dados ao desligar e o telemóvel ficava offline sem
       o dizer). Uma cópia só: quem mudar a regra muda-a nos dois sítios. */
    online, requireNet, netPatch,
    /* logica partilhada com o painel rapido da Nova UI (shell/android-panel.js): os mosaicos, os interruptores de rede,
       o brilho/volume e o foco tem UM so codigo para os dois sistemas */
    tile: anyTile, tap: tileTap, tileOn, toggleNet, level,
    focus: { of: () => focusOf(System.state), set: setFocus, pick: pickFocus, NAMES: FOCUS, ICON: FOCUS_ICON },
    /* módulo de música reutilizável (ecrã bloqueado e painel rapido da Nova UI); ver lock.js renderNowPlaying */
    music: { html: musicHtml, bind: bindMusic, paint: paintMusic } };
})();
