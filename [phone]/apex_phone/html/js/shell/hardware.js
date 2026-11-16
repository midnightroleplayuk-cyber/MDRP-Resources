/* ============================================================
   HARDWARE - botões físicos do PearPhone 18 Pro: Ação (silêncio),
   Volume +/− (passos de 1/16 como o PearOS), Lateral (power: bloquear /
   acordar · duplo clique = Wallet · manter = deslizar para desligar),
   Controlo de câmara. HUD de volume vertical junto aos botões e
   HUD de silêncio (sino) por baixo da ilha. Teclas: F3/F4 volume, F5 lateral.
   ANDROID (NOVA S26 Ultra, Nova UI 9): os mesmos elementos, outro desenho e outro comportamento.
   Volume e tecla lateral do lado DIREITO (o Ação e o Controlo de câmara não existem); painel de volume
   Nova UI (pílula vertical junto às teclas, modo de som em cima, "..." para os outros volumes); duplo
   clique na lateral = Câmara; manter = menu de energia Nova UI (Desligar, Reiniciar, Emergência);
   Always On Display em preto puro com relógio, data, bateria e ícones das notificações.
   ============================================================ */
window.Hardware = (() => {
  const g = UI.g; const STEP = 100 / 16;
  let dev, volHud, hud, off, po, volT, hudT, pressT = null, clickT = null, lastPower = 0, screenOff = false, inited = false;
  const BTNS = ['action left', 'vol-up left', 'vol-down left', 'power right', 'camera-ctl right'];
  const clamp = v => Math.max(0, Math.min(100, v));
  const zoom = () => UI.zoom();   /* em cache (ui.js) */
  const volGlyph = v => v <= 0 ? 'volumeX' : v < 50 ? 'speakerLow' : 'speaker';
  const isA = () => !!(window.System && System.os === 'android');
  const T = s => (window.L && L.t ? L.t(s) : s);
  const si = (n, s, c) => (window.SysUI && SysUI.icon) ? SysUI.icon(n, s, c) : '';

  function init() {
    if (inited) return; dev = document.querySelector('.device'); if (!dev) return; inited = true;
    dev.querySelectorAll('.hw-btn').forEach(b => b.remove());
    BTNS.forEach(c => dev.appendChild(UI.el(`<div class="hw-btn ${c}" title="${c.split(' ')[0]}"></div>`)));
    const scr = UI.screen();
    scr.querySelectorAll('.vol-hud,.hw-hud,.screen-off,.power-off').forEach(n => n.remove());
    volHud = UI.el(`<div class="vol-hud lg"><div class="ic base">${g('speaker')}</div><div class="fill"><div class="ic top">${g('speaker')}</div></div></div>`);
    hud = UI.el('<div class="hw-hud lg"></div>');
    off = UI.el('<div class="screen-off"></div>');
    po = UI.el(`<div class="power-off"><div class="po-slider"><div class="knob">${g('power')}</div><span>deslize para desligar</span></div><div class="po-cancel">${g('x')}</div><div class="po-lbl">Cancelar</div></div>`);
    scr.append(volHud, hud, off, po);
    buildA(scr);   /* painel de volume, menu de energia e Always On do Android: existem sempre, só se desenham com body.os-android */
    /* feedback de pressão + sem interferir com gestos do ecrã */
    dev.querySelectorAll('.hw-btn').forEach(b => { b.addEventListener('pointerdown', e => { e.stopPropagation(); b.classList.add('pressed'); }); const rel = () => b.classList.remove('pressed'); b.addEventListener('pointerup', rel); b.addEventListener('pointercancel', rel); b.addEventListener('pointerleave', rel); b.addEventListener('contextmenu', e => e.preventDefault()); });
    dev.querySelector('.vol-up').onclick = () => volume(+1); dev.querySelector('.vol-down').onclick = () => volume(-1);
    dev.querySelector('.action').onclick = () => silent(!System.state.silent);
    /* Controlo de Câmara: ABRE a app. Não dispara - a fotografia é só no botão redondo do ecrã
       (pedido do utilizador); o `camera:shutter` que aqui estava não tinha ouvinte nenhum. Com a
       Câmara já aberta, o openApp devolve logo (System.openApp sai quando já é a app atual). */
    dev.querySelector('.camera-ctl').onclick = () => { if (screenOff) { wake(); return; }
      /* ⚠️ O botão vive na carcaça, FORA do ecrã: é o único sítio de onde se conseguia abrir a
         Câmara com a inscrição do Face Key a decorrer - e a app Câmara liga a câmara nativa, que
         mata a câmara scriptada presa à cara (o anel ficava a ler o mundo). */
      if (document.querySelector('.fid-modal')) return;
      if (System.locked) System.openApp('camera', null, { allowLocked: true }); else System.openApp('camera'); };
    /* lateral: clique = bloquear/acordar · duplo = Wallet · manter = desligar */
    const pw = dev.querySelector('.power');
    pw.addEventListener('pointerdown', e => { if (e.button != null && e.button !== 0) return; try { pw.setPointerCapture(e.pointerId); } catch (_) {} clearTimeout(pressT); pressT = setTimeout(() => { pressT = null; showPowerOff(); }, 600); });
    const up = () => { if (!pressT) return; clearTimeout(pressT); pressT = null; const now = Date.now();
      if (clickT && now - lastPower < 320) { clearTimeout(clickT); clickT = null; lastPower = 0; doubleClick(); return; }
      lastPower = now; clearTimeout(clickT); clickT = setTimeout(() => { clickT = null; powerClick(); }, 330); };
    pw.addEventListener('pointerup', up); pw.addEventListener('pointercancel', () => { clearTimeout(pressT); pressT = null; });
    off.onclick = () => wake(); po.querySelector('.po-cancel').onclick = hidePowerOff; slider();
    addEventListener('keydown', e => { if (e.target.matches('input,textarea,select')) return; if (e.key === 'F3') { e.preventDefault(); volume(-1); } if (e.key === 'F4') { e.preventDefault(); volume(+1); } if (e.key === 'F5') { e.preventDefault(); powerClick(); } });
    /* troca de sistema a quente: o que estava aberto do outro sistema fecha, e o Always On passa a ser o do sistema novo */
    Bridge.on('os:changed', () => {
      hideVolume(); if (apw) apw.classList.remove('apw-in', 'apw-cf-off', 'apw-cf-rst'); volHud.classList.remove('in'); hud.classList.remove('in');
      if (po.classList.contains('in')) hidePowerOff();
      if (screenOff && off.classList.contains('aod')) { if (isA()) { UI.screen().classList.remove('aod'); startAOD(); } else { stopAOD(); UI.screen().classList.add('aod'); } }
    });
  }

  /* ---------- Volume: passos de 1/16, HUD vertical junto aos botões ---------- */
  function volume(d, opts = {}) {
    const dir = Math.sign(+d || 0); const cur = +System.state.volume || 0;
    const v = Math.round(clamp((Math.round(cur / STEP) + dir) * STEP) * 100) / 100;
    if (v !== cur) System.setState({ volume: v }, { noApply: true });
    showVolume(v, opts.hold); Sound.play('click');
  }
  function showVolume(v, hold) {
    if (isA()) { showVolA(hold); return; }
    if (!volHud) return; v = clamp(+v || 0);
    /* PearPhone Fold: o HUD é a cápsula DEITADA por baixo das teclas de cima (system.css, 210 px): a carga entra da esquerda por
       translateX e o ícone dela anda o mesmo ao contrário, para ficar parado por cima da carga */
    const f = volHud.querySelector('.fill'), ti = f.querySelector('.ic'); f.style.height = v + '%';
    if (System.form === 'fold') { const X = Math.round((1 - v / 100) * 210); f.style.transform = `translateX(${-X}px)`; if (ti) ti.style.transform = `translateX(${X}px)`; }
    else if (f.style.transform) { f.style.transform = ''; if (ti) ti.style.transform = ''; }
    const gl = volGlyph(v);
    if (volHud.dataset.gl !== gl) { volHud.dataset.gl = gl; volHud.querySelectorAll('.ic').forEach(i => i.innerHTML = g(gl)); }
    volHud.classList.add('in'); clearTimeout(volT); if (!hold) volT = setTimeout(() => volHud.classList.remove('in'), 1500);
  }
  /* ---------- Silêncio (botão de Ação): mostrado DENTRO da ilha como no PearOS 17+ - sino riscado num pill vermelho + "Silêncio", ou sino + "Toque"; sem som (o PearPhone só vibra) ---------- */
  function silent(on, opts = {}) {
    on = !!on;
    /* Android: o mesmo `silent` é o modo Vibrar da Nova UI (Som / Vibrar); o aviso é o painel de volume com o modo em cima */
    if (isA()) { System.setState({ silent: on }, { noApply: true }); if (!(window.QuickPanel && QuickPanel.isOpen && QuickPanel.isOpen())) showVolA(opts.hold); else paintVolA(); System.renderStatus(); return; }   /* com o painel rápido aberto o mosaico já mostra o modo: o painel de volume não salta por cima */
    System.setState({ silent: on }, { noApply: true });
    /* sem ilha (PearPhone Fold, contrato v2) o Island.hud devolve false: o aviso é a pílula .hw-hud, por baixo da barra de estado */
    const inIsland = !!(window.Island && Island.hud) && Island.hud({ cls: on ? 'silent' : 'ring', icon: g(on ? 'bellOff' : 'bell'), text: on ? 'Silêncio' : 'Toque', ms: opts.hold ? 60000 : 1700 }) !== false;
    if (!inIsland) showHud(on ? 'silent' : '', g(on ? 'bellOff' : 'bell'), on ? 'Modo de silêncio ativado' : 'Modo de silêncio desativado', opts.hold);
    System.renderStatus();
  }
  function showHud(cls, icon, text, hold) { if (!hud) return; hud.className = 'hw-hud lg ' + cls; hud.innerHTML = icon + '<span>' + UI.esc(text) + '</span>'; void hud.offsetWidth; hud.classList.add('in'); clearTimeout(hudT); if (!hold) hudT = setTimeout(() => hud.classList.remove('in'), 1600); }

  /* ---------- Lateral ---------- */
  function powerClick() { if (powerOpen()) { hidePowerOff(); return; } if (screenOff) { wake(); return; } sleep(); }
  /* Always-On Display (PearPhone Pro, Definições › Ecrã): ao bloquear o ecrã escurece (.35 s), bloqueia, e em vez de ficar preto mostra o relógio e a data
     sobre o fundo escurecido, com widgets/notificações reduzidos e sem atalhos (.screen.aod + .screen-off.aod em system.css). Toque/lateral acorda. */
  const aodOn = () => System.state.alwaysOn === true;   /* opt-in explícito (ver DEFAULTS em system.js) */
  const inSetup = () => { const s = document.getElementById('setup'); return !!(s && s.classList.contains('in')); };
  let sleepT = null;
  /* cliques repetidos no lateral: um único temporizador, cancelado ao acordar (antes cada sleep() deixava o seu, e um deles disparava o Always-On com o ecrã já aceso);
     durante o assistente inicial só apaga/acende o ecrã - sem bloquear nem Always-On (o relógio do lock subia por cima do assistente) */
  function sleep() { screenOff = true; clearTimeout(sleepT); sleepT = null; if (window.Notify) Notify.close(); if (window.CC) CC.close(); if (window.Switcher) Switcher.close(); if (window.LockGallery) LockGallery.close(true);
    /* Android: o painel rápido, a gaveta, o Edge, o painel de volume e o menu de energia também se fecham ao apagar */
    if (isA()) { ['QuickPanel', 'Drawer', 'EdgePanel'].forEach(m => { try { const o = window[m]; if (o && o.close && (!o.isOpen || o.isOpen())) o.close(); } catch (e) {} }); hideVolume(); if (apw) apw.classList.remove('apw-in', 'apw-cf-off', 'apw-cf-rst'); if (window.Island && Island.expanded) Island.collapse(); }
    off.classList.add('in'); Sound.play('lock');
    if (inSetup()) return;
    sleepT = setTimeout(() => { sleepT = null; if (!screenOff) return; if (!System.locked && window.Lock) Lock.lock(true);
      if (aodOn() && !inSetup()) { off.classList.add('aod'); if (isA()) startAOD(); else UI.screen().classList.add('aod'); } }, 380); }
  function wake() { if (!screenOff || booting) return; screenOff = false; clearTimeout(sleepT); sleepT = null; off.classList.remove('in', 'aod'); UI.screen().classList.remove('aod'); stopAOD(); if (System.locked && !inSetup() && window.Lock && Lock.wake) Lock.wake(true); }   /* acordar é silencioso (PearOS); o relógio volta a entrar com mola e o Face Key reconhece sozinho */
  function doubleClick() { if (inSetup()) { wake(); return; }
    /* Android: duplo clique na tecla lateral abre a Câmara (o atalho de origem da Nova UI) */
    if (isA()) { if (screenOff) wake(); if (document.querySelector('.fid-modal')) return; if (System.locked) System.openApp('camera', null, { allowLocked: true }); else System.openApp('camera'); return; }
    if (screenOff) wake(); if (System.locked) { Lock.requestUnlock(() => System.openApp('wallet')); } else System.openApp('wallet'); showHud('', g('card'), 'Wallet'); }
  function showPowerOff() { if (screenOff) wake();
    if (isA()) { if (!apw) return; hideVolume(); apw.classList.remove('apw-cf-off', 'apw-cf-rst'); apw.querySelector('.apw-msg').textContent = ''; apw.classList.add('apw-in'); Sound.play('pop'); return; }
    po.classList.add('in'); Sound.play('pop'); }
  /* o botão desliza por TRANSFORM a partir do `left:4px` fixo do CSS: escrever `left` a cada
     pointermove (e animá-lo 300 ms no regresso) era layout por frame. O rótulo guarda-se uma vez. */
  function hidePowerOff() { if (apw) apw.classList.remove('apw-in', 'apw-cf-off', 'apw-cf-rst'); po.classList.remove('in'); const k = po.querySelector('.knob'); k.style.transition = 'transform .3s var(--spring)'; k.style.transform = ''; po.querySelector('.po-slider span').style.opacity = 1; }
  function slider() { const s = po.querySelector('.po-slider'), k = s.querySelector('.knob'), lbl = s.querySelector('span'); let sx = 0, on = false; const max = 320 - 66 - 8;
    k.addEventListener('pointerdown', e => { sx = e.clientX; on = true; k.style.transition = 'none'; try { k.setPointerCapture(e.pointerId); } catch (_) {} });
    k.addEventListener('pointermove', e => { if (!on) return; const x = Math.max(4, Math.min(max, 4 + (e.clientX - sx) / zoom())); k.style.transform = `translateX(${x - 4}px)`; lbl.style.opacity = 1 - (x / max); });
    const up = e => { if (!on) return; on = false; const x = 4 + (e.clientX - sx) / zoom(); if (x > max * .85) { powerOff(); } else { k.style.transition = 'transform .3s var(--spring)'; k.style.transform = ''; lbl.style.opacity = 1; } };
    k.addEventListener('pointerup', up); k.addEventListener('pointercancel', up); }
  function powerOff() { hidePowerOff(); off.classList.add('in'); screenOff = true; Sound.play('lock'); if (!System.locked && window.Lock) Lock.lock(true); setTimeout(() => { if (Bridge.inFiveM) Bridge.call('close'); }, 600); }
  const powerOpen = () => !!((po && po.classList.contains('in')) || (apw && apw.classList.contains('apw-in')));

  /* ============================================================
     ANDROID (Nova UI 9)
     ============================================================ */
  const VOLS = [{ k: 'volume', ic: 'media', lbl: 'Multimédia' }, { k: 'notifVolume', ic: 'bell', lbl: 'Notificações' }, { k: 'callVolume', ic: 'callVol', lbl: 'Chamadas' }];
  const TRACK_H = 176, KNOB = 44;   /* calha 44x176 (oneui-sysui.css .avol-track); o fundo redondo do ícone fica sempre à vista */
  let avol = null, avT = null, apw = null, aodBox = null, aodBoot = null, aodT = null, aodSig = '', booting = false, bootT = null;
  const trackHtml = (k, icn) => `<div class="avol-track" data-k="${k}"><i class="avol-fill"></i><span class="avol-num"></span><span class="avol-ic">${si(icn, 20)}</span></div>`;
  function buildA(scr) {
    scr.querySelectorAll(':scope > .avol, :scope > .apw').forEach(n => n.remove());
    /* ---- painel de volume: pílula com o modo de som, a calha do volume e "..." para os outros volumes ---- */
    avol = UI.el(`<div class="avol"><div class="avol-mini"><div class="avol-mode" role="button"></div>${trackHtml('volume', 'media')}<div class="avol-more" role="button">${si('more', 22)}</div></div>`
      + `<div class="avol-full"><div class="avol-cols">${VOLS.map(v => `<div class="avol-col">${trackHtml(v.k, v.ic)}<span class="avol-lbl">${UI.esc(T(v.lbl))}</span></div>`).join('')}</div>`
      + `<div class="avol-foot"><div class="avol-mode2" role="button"></div><div class="avol-set" role="button">${UI.esc(T('Definições'))}</div></div></div></div>`);
    avol.addEventListener('pointerdown', e => { e.stopPropagation(); keepVol(); });
    avol.querySelector('.avol-mode').onclick = e => { e.stopPropagation(); silent(!System.state.silent); keepVol(); };
    avol.querySelector('.avol-mode2').onclick = e => { e.stopPropagation(); silent(!System.state.silent); keepVol(); };
    avol.querySelector('.avol-more').onclick = e => { e.stopPropagation(); avol.classList.add('avol-x'); paintVolA(); keepVol(); };
    avol.querySelector('.avol-set').onclick = e => { e.stopPropagation(); hideVolume(); openSettings('sounds'); };
    avol.querySelectorAll('.avol-track').forEach(tr => {
      let dr = false;
      /* arrastar na calha: o topo da parte cheia fica debaixo do dedo; passos de 1/16 como as teclas */
      const setFrom = e => { const r = tr.getBoundingClientRect(); if (!r.height) return; const kk = r.height / TRACK_H;
        const raw = 1 - (e.clientY - r.top - (KNOB / 2) * kk) / ((TRACK_H - KNOB) * kk);
        const k = tr.dataset.k, v = Math.round(clamp(Math.round(raw * 100 / STEP) * STEP) * 100) / 100;
        if (v !== +System.state[k]) System.setState({ [k]: v }, { noApply: true }); paintVolA(); };
      tr.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; e.stopPropagation(); dr = true; tr.classList.add('avol-drag'); try { tr.setPointerCapture(e.pointerId); } catch (x) {} setFrom(e); keepVol(); });
      tr.addEventListener('pointermove', e => { if (!dr) return; setFrom(e); keepVol(); });
      const end = () => { if (!dr) return; dr = false; tr.classList.remove('avol-drag'); Sound.play('click'); keepVol(); };
      tr.addEventListener('pointerup', end); tr.addEventListener('pointercancel', end);
    });
    /* ---- menu de energia: Desligar, Reiniciar (os dois pedem um segundo toque, como na Nova UI), Emergência ---- */
    apw = UI.el(`<div class="apw" role="dialog"><div class="apw-row">`
      + `<div class="apw-b apw-off" role="button"><i>${si('power', 32)}</i><span>${UI.esc(T('Desligar'))}</span></div>`
      + `<div class="apw-b apw-rst" role="button"><i>${si('restart', 32)}</i><span>${UI.esc(T('Reiniciar'))}</span></div>`
      + `<div class="apw-b apw-sos" role="button"><i>${si('sos', 30)}</i><span>${UI.esc(T('Emergência'))}</span></div></div>`
      + `<div class="apw-msg"></div><div class="apw-set"><span role="button">${si('gear', 17)}${UI.esc(T('Definições da tecla lateral'))}</span></div></div>`);
    const msg = apw.querySelector('.apw-msg');
    apw.onclick = e => { if (e.target === apw || e.target.classList.contains('apw-row') || e.target === msg) hidePowerOff(); };
    apw.querySelector('.apw-off').onclick = e => { e.stopPropagation(); if (apw.classList.contains('apw-cf-off')) { powerOff(); return; } apw.classList.remove('apw-cf-rst'); apw.classList.add('apw-cf-off'); msg.textContent = T('Toca outra vez para desligar'); Sound.play('click'); };
    apw.querySelector('.apw-rst').onclick = e => { e.stopPropagation(); if (apw.classList.contains('apw-cf-rst')) { restart(); return; } apw.classList.remove('apw-cf-off'); apw.classList.add('apw-cf-rst'); msg.textContent = T('Toca outra vez para reiniciar'); Sound.play('click'); };
    /* Emergência: o mesmo pedido de ajuda do ecrã bloqueado (Lock.emergency: serviços de emergência do servidor) */
    apw.querySelector('.apw-sos').onclick = e => { e.stopPropagation(); hidePowerOff(); if (window.Lock && Lock.emergency) Lock.emergency(); };
    apw.querySelector('.apw-set span').onclick = e => { e.stopPropagation(); hidePowerOff(); openSettings('sidekey'); };
    scr.append(avol, apw);
    /* ---- Always On Display e arranque: vivem dentro do véu do ecrã apagado ---- */
    aodBox = UI.el('<div class="aod-wrap"><div class="aod-clock"></div><div class="aod-date"></div><div class="aod-batt"></div><div class="aod-notifs"></div></div>');
    aodBoot = UI.el('<div class="aod-boot"><b></b><span></span></div>');
    off.append(aodBox, aodBoot);
  }
  function openSettings(page) {
    const go = () => { System.openApp('settings'); setTimeout(() => Bridge.emit('settings:goto', page), 450); };
    if (System.locked && window.Lock && Lock.requestUnlock) Lock.requestUnlock(go); else go();
  }
  function paintVolA() {
    if (!avol) return; const st = System.state;
    avol.querySelectorAll('.avol-track').forEach(tr => {
      const v = clamp(+st[tr.dataset.k] || 0) / 100, f = tr.querySelector('.avol-fill'), n = tr.querySelector('.avol-num');
      const ty = ((1 - v) * (TRACK_H - KNOB)).toFixed(1) + 'px'; if (f._ty !== ty) { f._ty = ty; f.style.transform = `translateY(${ty})`; }
      const t = String(Math.round(v * 100)); if (n.textContent !== t) n.textContent = t;
      tr.classList.toggle('avol-zero', v <= 0);
    });
    const sil = !!st.silent, m = avol.querySelector('.avol-mode'), m2 = avol.querySelector('.avol-mode2');
    if (m._s !== sil) { m._s = sil; m.innerHTML = si(sil ? 'vibrate' : 'bell', 22); m.classList.toggle('avol-vib', sil); }
    if (m2._s !== sil) { m2._s = sil; m2.innerHTML = si(sil ? 'vibrate' : 'bell', 18) + `<span>${UI.esc(T(sil ? 'Vibrar' : 'Som'))}</span>`; }
  }
  function showVolA(hold) {
    if (!avol || powerOpen()) return;
    paintVolA(); avol.classList.add('avol-in'); clearTimeout(avT);
    if (!hold) avT = setTimeout(hideVolume, avol.classList.contains('avol-x') ? 5000 : 2600);
  }
  /* mexer no painel adia o desaparecer (aberto com "..." dura mais) */
  function keepVol() { if (!avol || !avol.classList.contains('avol-in')) return; clearTimeout(avT); avT = setTimeout(hideVolume, avol.classList.contains('avol-x') ? 5000 : 3000); }
  function hideVolume() { if (!avol) return; clearTimeout(avT); avol.classList.remove('avol-in'); setTimeout(() => { if (avol && !avol.classList.contains('avol-in')) avol.classList.remove('avol-x'); }, 360); }
  const volumeOpen = () => !!(avol && avol.classList.contains('avol-in'));
  /* ---- Always On Display: relógio, data, bateria e ícones das apps com notificações por ler; refaz-se só quando algo muda ---- */
  function paintAOD() {
    if (!aodBox || !isA()) return; const d = new Date(), st = System.state || {};
    const apps = window.SysUI && SysUI.unreadApps ? SysUI.unreadApps().slice(0, 5) : [];
    const lv = Math.round(+st.battery || 0), hm = UI.fmtTime(d);
    const sig = [hm, d.getDate(), lv, st.lowPower ? 1 : 0, apps.join(','), window.L ? L.code : ''].join('|'); if (sig === aodSig) return; aodSig = sig;
    aodBox.querySelector('.aod-clock').textContent = hm;
    aodBox.querySelector('.aod-date').textContent = UI.fmtDate(d);
    aodBox.querySelector('.aod-batt').innerHTML = (window.SysUI && SysUI.battery ? SysUI.battery(lv, false, lv <= 15, !!st.lowPower) : '') + `<span>${lv}%</span>`;
    aodBox.querySelector('.aod-notifs').innerHTML = apps.map(a => `<span class="asb-ni">${SysUI.monoIcon(a, 20)}</span>`).join('');
  }
  function startAOD() { clearInterval(aodT); aodSig = ''; paintAOD(); aodT = setInterval(paintAOD, 1000); }
  function stopAOD() { clearInterval(aodT); aodT = null; }
  /* ---- Reiniciar: apaga, fecha tudo o que estava a correr (como um telemóvel a sério), mostra a marca e volta ao ecrã bloqueado ---- */
  function restart() {
    hidePowerOff(); hideVolume(); screenOff = true; booting = true; Sound.play('lock');
    try { if (window.PhoneApp && PhoneApp.current && PhoneApp.end) PhoneApp.end('local'); } catch (e) {}
    try { if (window.Player && Player.playing && Player.toggle) Player.toggle(); } catch (e) {}
    try { if (window.UI && UI.dismissAll) UI.dismissAll(); } catch (e) {}
    ['QuickPanel', 'Drawer', 'EdgePanel', 'Switcher', 'Vera', 'Notify', 'CC', 'LockGallery'].forEach(m => { try { const o = window[m]; if (o && o.close && (!o.isOpen || o.isOpen())) o.close(); } catch (e) {} });
    off.classList.remove('aod'); off.classList.add('in'); stopAOD();
    if (window.Lock) Lock.lock(true);
    Object.keys(System.windows || {}).forEach(id => { try { System.killApp(id); } catch (e) {} });
    const info = System.osInfo ? System.osInfo() : { brand: 'NOVA', osName: 'Nova UI', osVersion: '9' };
    aodBoot.querySelector('b').textContent = info.brand; aodBoot.querySelector('span').textContent = info.osName + ' ' + info.osVersion;
    clearTimeout(bootT);
    bootT = setTimeout(() => { off.classList.add('aod-booting'); bootT = setTimeout(() => { off.classList.remove('aod-booting'); booting = false; wake(); }, 2200); }, 700);
  }

  Bridge.on('phone:open', () => { if (screenOff) wake(); });
  return { init, volume, showVolume, silent, sleep, wake, showPowerOff, hidePowerOff, powerOpen, volumeOpen, hideVolume, restart, get screenOff() { return screenOff; }, get inited() { return inited; } };
})();
