/* ============================================================
   SYSTEM - registo de apps, estado/definições, conta, tema,
   accent, status bar, janelas de app (multitasking), arranque
   ============================================================ */
window.App = (() => {
  const reg = {};
  /* assinatura dos DADOS de uma definição (não das funções open/resume, que são closures novas em cada chamada) */
  const SIG_KEYS = ['name', 'category', 'description', 'url', 'external', 'hidden', 'defaultInstalled', 'author', 'statusBar', 'core', 'needs', 'media', 'shots'];
  const sig = d => { try { return JSON.stringify(SIG_KEYS.map(k => d[k])) + JSON.stringify(d.icon == null ? null : d.icon); } catch (e) { return String(Math.random()); } };
  /* o id de uma app viaja para seletores CSS, para `data-app="…"`, para o layout gravado na conta e para o
     Lua: o thirdparty.js e os dois exports.lua já recusam o que fuja a este crivo (SHELL-07) e o App.define
     era a última porta aberta - um id com aspas ou "]" rebentava os querySelectorAll do tileOf/badge. */
  const ID_OK = /^[\w.:-]{1,64}$/;
  const define = (id, def) => { if (!ID_OK.test(String(id))) { console.warn('[apex_phone] App.define: id inválido "' + String(id).slice(0, 80) + '": ignorado'); return; }
    def.id = id; const prev = reg[id]; const next = Object.assign({ core: false, category: 'Utilitários' }, prev || {}, def);
    /* a mesma definição outra vez (o Lua reenvia todos os registerApp no arranque, o registo também vem por RPC, outros resources podem repetir):
       nada muda → ninguém é avisado (evitava re-render da home e da AppShop por cada repetição) */
    if (prev && sig(prev) === sig(next)) return prev;
    reg[id] = next; if (window.Icons && Icons.clearTiles) Icons.clearTiles(id);   /* o ícone pode ter mudado → invalida o SVG em cache */
    Bridge.emit('app:defined', id); return next; };
  const get = id => reg[id];
  const ids = () => Object.keys(reg).filter(id => !reg[id].hidden);
  /* NOMES POR SISTEMA (Android, 2026-10-01): a mesma app pode ter outro nome no telemovel Android
     ("Safari" e "Internet", "Fotos" e "Galeria"). O id, os dados e o servidor sao os mesmos nos dois
     sistemas: e isso que deixa um iPhone e um Android falarem um com o outro. App.alias('android', { id: 'Nome' }). */
  const ALIAS = { ios: {}, android: {} };
  const alias = (os, map) => { if (!ALIAS[os] || !map || typeof map !== 'object') return; Object.keys(map).forEach(k => { if (typeof map[k] === 'string' && map[k]) ALIAS[os][k] = map[k]; }); Bridge.emit('apps:changed'); };
  const curOS = () => (window.System && System.os) || 'ios';
  const name = id => (ALIAS[curOS()] && ALIAS[curOS()][id]) || (reg[id] && reg[id].name) || id;
  /* nome original (o do App.define), para quem precisa dele independentemente do sistema */
  const baseName = id => (reg[id] && reg[id].name) || id;
  return { define, get, all: () => reg, ids, name, baseName, alias, ALIAS };
})();

window.System = (() => {
  const $ = s => document.querySelector(s);
  const DEFAULTS = {
    theme: 'light', dark: false, accent: '#0088FF', accentToggles: false,
    /* `rotationLock` e `mirroring` saíram: os mosaicos Rotação e Espelhar ecrã deixaram de existir (control.js)
       e nada no recurso lê as chaves - continuavam só a ser gravadas na conta e a viajar para a base de dados */
    wifi: true, bt: true, airplane: false, cellular: true, hotspot: false, vpn: false, dnd: false, lowPower: false,
    battPercent: false, battery: 92, wallpaper: 'auto' /* "Cor do aparelho": segue o item usado (Wallpapers.AUTO) */, wallpaperCustom: null, lockWallpaper: null, phoneScaleV2: null,   /* chave NOVA: as contas existentes tinham phoneScale gravado e ganhavam a Config.Scale, por isso subir a escala no config nao lhes chegava - mesmo truque do battPct->battPercent e do aod->alwaysOn */   /* bateria PearOS (contorno + carga) por defeito - referência do utilizador 2026-09-06; battPercent liga o número */
    textSize: 'normal', name: '', sounds: true, haptics: true, brightness: 100, volume: 60, notifVolume: 70, callVolume: 80, autoLock: '2 minutos', lockOnClose: true,
    ringtone: 'Reflexo', msgTone: 'Nota', notif: {}, notifSound: true, islandNotifs: false, notifDisplay: 'stack', trueTone: true, nightShift: false, raise: true, locationOn: true,
    clockFont: 'default', clockColor: '#FFFFFF', showLabels: true, kb: null, lang: 'pt', vera: true, veraWake: true, auraVoice: 'Vera',
    /* PearOS 27: cursor "Liquid Glass" (Definições › Ecrã e brilho): 0 = ultra-transparente … 100 = totalmente tingido; 50 = como o PearOS
       de fábrica. Relógio compacto do ecrã bloqueado (hora pequena ao lado da data, em vez do relógio grande ao centro). */
    glassTint: 50, clockCompact: false,
    /* Widgets do ecrã bloqueado (a linha por baixo do relógio): DESLIGADOS por omissão - pedido
       do utilizador 2026-09-11. Continuam disponíveis em Definições › Ecrã bloqueado › Widgets
       e na galeria de personalização. Chave NOVA (`lockWidgetsV2`): a antiga `lockWidgets` ficou
       gravada com os três widgets nas contas existentes e um `[]` aqui não as corrigiria - é a
       mesma armadilha do battPct→battPercent e do aod→alwaysOn. */
    lockWidgetsV2: [],
    /* `dnd` e `lowpower` são mosaicos FIXOS (control.js FIXED_TILES: desenhados sempre, fora da lista configurável)
       e `rotation`/`mirror` já não existem - a lista de origem não os traz. As contas antigas ainda os têm em
       `state.cc`; o render filtra por TILES[k], por isso desaparecem sozinhos. */
    cc: ['torch', 'timer', 'calc', 'camera', 'airdrop', 'earbuds', 'vera', 'rotate'], perms: {}, installed: null, torch: false, earbuds: false, airpodsWorn: false /* sessão: o item pôs os AirBuds (Earbuds.sync acerta ao entrar) */,
    showPct: false, setupDone: false,
    /* Always-On Display DESLIGADO por omissão: o utilizador carrega no lateral para APAGAR o ecrã e o véu a 72 % parecia o ecrã meio aceso (queixa in-game 2026-09-08).
       Chave nova `alwaysOn` - a antiga `aod` ficou gravada a true nas contas existentes e um simples `aod:false` aqui não as corrigiria (mesmo truque de battPct → battPercent). */
    alwaysOn: false,
    lockScreens: null, lockCurrent: null, lockControls: ['torch', 'camera'], clockSize: 'normal', clockWeight: 'regular',   /* galeria do ecrã bloqueado (lockgallery.js) */
    clockWght: null,   /* peso exato da hora (barra de "Fonte e cor" nas fontes variáveis); null = o peso da fonte escolhida */
    faceIdUnlock: false,  /* Face Key (Definições › Face Key e código): deslizar para cima desbloqueia sem código - desligado por defeito (o código continua a ser a regra) */
    /* ---------- PearOS 27 (1.4.0): editor do bloqueado e "Personalizar" da home - TODAS chaves NOVAS (nenhum valor de origem mudou) ----------
       clockScale: tamanho CONTÍNUO da hora (a pega no canto do relógio, no editor), .72…1.75, 1 = os 176 px de sempre; null = vem do
       antigo clockSize (small .85 / normal 1 / large 1.14), por isso as contas existentes ficam exatamente com o tamanho que tinham.
       clockNumerals: sistema de numeração da hora (ids de Lock.NUMERALS; 'latn' = 0-9). Ícones da home (icons.js/homecustom.js):
       iconStyle default|dark|clear|tinted, iconHue/iconSat = matiz 0..360 e saturação 0..1 do "Colorido", iconTone = tom do vidro
       auto|light|dark (auto segue o tema), iconSize small|large (grande = sem nomes e mosaicos maiores, a etiqueta do jogador fica). */
    clockScale: null, clockNumerals: 'latn', iconStyle: 'default', iconHue: 210, iconSat: .7, iconTone: 'auto', iconSize: 'small',
    /* ---------- Fase 1 (docs/ARQUITETURA.md §5.4) ----------
       notifApps[app] = { allow, sound, badge, lock, banner, preview } (o antigo notif[app] === false continua a valer como allow:false);
       notifAll = interruptor geral; focus = none/dnd/work/sleep (sincronizado com `dnd` no setState);
       clock24 = true mantém o "09:41" que o telemóvel sempre mostrou; deviceName '' = "PearPhone de <username>". */
    notifApps: {}, notifAll: true, focus: 'none', reduceMotion: false, clock24: true, deviceName: '', recentApps: [],
    /* 1.5.0 Liquid Glass (Definições › Ecrã e brilho › Acessibilidade): vidro fosco opaco sem lente / contorno forte e fills opacos (glass27.css) */
    reduceTransparency: false, increaseContrast: false,
    airdrop: 'off',   /* AirShare (pacote AD): 'off' | 'contacts' | 'everyone' - receção; gravado na conta como as outras definições */
    wifiNet: 'ApexNet 5G',   /* rede Wi-Fi escolhida em Definições › Wi-Fi (só o nome: não há rede a sério) */
    /* ---------- ANDROID (Nova UI, docs/ANDROID.md) ----------
       navMode: barra de navegacao 'buttons' (3 botoes, o de origem) | 'gesture' (gestos)
       navOrder: 'recents-home-back' (de origem) | 'back-home-recents'
       edgePanel / edgeApps: painel Edge ligado e as apps dele (null = as de origem)
       qsTiles: mosaicos das definicoes rapidas (null = os de origem)
       fpEnrolled / fpUnlock: impressoes digitais registadas e desbloquear com elas
       drawerSort: ordem da gaveta de apps 'custom' | 'alpha' */
    navMode: 'gesture', navOrder: 'recents-home-back', edgePanel: true, edgeApps: null, qsTiles: null, fpEnrolled: 0, fpUnlock: false, drawerSort: 'custom'
  };
  /* 2026-10-03 (pedido do dono): a barra de navegação do NOVA é a dos gestos, só a pega (como nos Samsung de agora), fechado E
     aberto (4 out: aberto deixou de forçar os 3 botões, a pega fica ao centro como fechado). Muda UMA vez (navGesture2: também
     desfaz a navButtons1 que esteve no código umas horas a 4 out); quem depois escolher os botões nas Definições fica com eles. */
  function migrateNav() { if (state.navGesture2) return false; state.navGesture2 = true; state.navMode = 'gesture'; return true; }
  const storedAtLoad = Store.get('settings', {}) || {};   /* o que JÁ estava gravado: o defaultLang/defaultTheme do servidor não o pisa */
  const state = Object.assign({}, DEFAULTS, storedAtLoad);
  const DEFAULT_PLAYER = { citizenid: 'DEV0000', firstname: 'Jogador', lastname: 'Teste', phone: '555-0142', birthdate: '1998-04-12', job: { name: 'unemployed', label: 'Desempregado', grade: '' }, money: { cash: 350, bank: 12840 } };
  let account = null, player = Store.get('player', null) || JSON.parse(JSON.stringify(DEFAULT_PLAYER));
  let screen, apps, current = null, locked = true, gameHour = null, saveT = null, ready = false, lastTouch = Date.now();
  const windows = {}, recents = [];
  const ind = { cam: false, mic: false };
  /* tempo de ecrã real (Definições › Tempo de ecrã): segundos por app e por dia, guardados em Store 'usage' (últimos 14 dias) */
  let useCur = null;
  const dayKey = () => new Date().toISOString().slice(0, 10);
  function useStart(id) { useStop(); useCur = { id, t: Date.now() }; }
  function useStop() { if (!useCur) return; const s = Math.round((Date.now() - useCur.t) / 1000); const id = useCur.id; useCur = null; if (s < 1) return; try { const u = Store.get('usage', {}) || {}; const k = dayKey(); u[k] = u[k] || {}; u[k][id] = (u[k][id] || 0) + s; const keys = Object.keys(u).sort(); while (keys.length > 14) delete u[keys.shift()]; Store.set('usage', u); } catch (e) {} }
  const usage = () => Store.get('usage', {}) || {};

  /* ---------- Estado / persistência ---------- */
  /* ⚠️ O localStorage NÃO se escreve em cada setState. O `state` leva os fundos "Das Fotos" em
     base64 (até 200 kB cada, e a galeria do ecrã bloqueado guarda um por ecrã): cada toque numa
     definição fazia JSON.stringify + setItem SÍNCRONOS dessa dimensão, no próprio frame do toque.
     Junta-se tudo numa escrita 250 ms depois da última alteração (o Store já devolve o objeto vivo
     a quem o ler); guardar o telemóvel e sair da página despejam o que estiver pendente. */
  let persistT = null, lazyDirty = false;   /* lazyDirty: mudou algo que pode esperar pela próxima escrita (recentApps) */
  const persist = () => { clearTimeout(persistT); persistT = null; lazyDirty = false; Store.set('settings', state); };
  const persistSoon = () => { clearTimeout(persistT); persistT = setTimeout(persist, 250); };
  const persistNow = () => { if (persistT || lazyDirty) persist(); };
  addEventListener('pagehide', persistNow); addEventListener('beforeunload', persistNow);
  const FOCUS = ['none', 'dnd', 'work', 'sleep'];
  function setState(patch, opts = {}) {
    /* `focus` (Fase 1) e o antigo `dnd` descrevem a mesma coisa: o Centro de controlo, a Vera e o
       notify.js ainda falam em `dnd`. Quem mudar só um recebe o outro coerente, e o patch emitido
       leva os dois - assim ninguém fica com um "Não incomodar" ligado e um foco "none". */
    if (patch && typeof patch === 'object') {
      if ('focus' in patch && !('dnd' in patch)) { const f = FOCUS.includes(patch.focus) ? patch.focus : 'none'; patch = Object.assign({}, patch, { focus: f, dnd: f !== 'none' }); }
      else if ('dnd' in patch && !('focus' in patch)) patch = Object.assign({}, patch, { focus: patch.dnd ? (state.focus && state.focus !== 'none' ? state.focus : 'dnd') : 'none' });
    }
    Object.assign(state, patch); persistSoon(); if (!opts.noApply) apply(); if (!opts.noSave) save(); Bridge.emit('state', patch); }
  /* O mesmo bloco (com os base64) viaja NUI → Lua → servidor → BD a cada save. Se o conteúdo é
     IGUAL ao último que o servidor confirmou (sair do modo de edição sem mexer, repor um valor que
     já lá estava…) não se volta a mandar. Só conta como enviado quando o servidor responde ok e se
     for o pedido mais recente - um pedido antigo que chegue atrasado não marca nada. */
  let savedSig = null, saveSeq = 0, bigT = 0;
  function save() { clearTimeout(saveT); saveT = setTimeout(() => { if (!account) return;
    const payload = { settings: state, layout: window.Home ? Home.serialize() : null };   /* serialize(): vazios como 0 (o Lua perde os null dos arrays) */
    let sig = null; try { sig = JSON.stringify(payload); } catch (e) {}
    if (sig && sig === savedSig) return;
    const seq = ++saveSeq;
    /* rpcRaw e não rpc: o Bridge.rpc troca { error } por null e o `toolarge` do servidor (teto do
       Config.AccountMaxBytes - 64 000 no `layout`, que é alcançável) nunca chegava cá. */
    Promise.resolve(Bridge.rpcRaw('account.update', payload)).then(r => {
      if (seq !== saveSeq) return;                                   /* resposta atrasada de um pedido já ultrapassado: não marca nada */
      if (r && r.ok) { savedSig = sig; return; }
      /* Recusado por tamanho: marcar como enviado CORTA O CICLO - sem isto a NUI voltava a mandar o mesmo
         payload gigante a CADA alteração de definição, para sempre. Como o payload não foi gravado, o jogador
         tem de o saber (regra: nada finge ter sido guardado); o aviso não se repete a cada toque.
         Os outros erros ('noacc', 'invalid', falha de rede) são passageiros: não se marca e tenta-se outra vez. */
      if (r && r.error === 'toolarge') { savedSig = sig; if (Date.now() - bigT > 60000) { bigT = Date.now(); try { UI.toast('Definições grandes demais para gravar'); } catch (e) {} } }
    }, () => {});
  }, 600); }
  const isDark = () => state.theme === 'dark' ? true : state.theme === 'light' ? false : (() => { const h = gameHour != null ? gameHour : new Date().getHours(); return h < 7 || h >= 20; })();
  /* "#FFD60A" → "255,214,10" (para rgba(var(--x), a) - a única forma portável de tingir cores no CEF) */
  function hexRgb(hex) { const h = String(hex || '').replace('#', ''); const s = h.length === 3 ? h.split('').map(c => c + c).join('') : h; const n = parseInt(s, 16); return isNaN(n) ? '255,255,255' : [(n >> 16) & 255, (n >> 8) & 255, n & 255].join(','); }
  function hexLighten(hex, p) { const n = parseInt(hex.replace('#', ''), 16); let r = n >> 16, g = (n >> 8) & 255, b = n & 255; r = Math.round(r + (255 - r) * p); g = Math.round(g + (255 - g) * p); b = Math.round(b + (255 - b) * p); return '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1).toUpperCase(); }
  /* ---------- 1.4.0: tamanho contínuo da hora ----------
     k = escala da hora (1 = 176 px). Até CLOCK_KX a hora cresce em tamanho de letra (--clock-kx); daí para cima a largura já
     não cabe nos 440 px (o "22:18" largo encostava às bordas) e o resto do crescimento vira ESTICÃO VERTICAL (--clock-sy,
     scaleY no lock.css): os dígitos ficam mais ALTOS e estreitos, como no iOS 26 quando se puxa a pega para baixo. */
  const CLOCK_KX = 1.15;
  const kOfSize = s => s === 'small' ? .85 : s === 'large' ? 1.14 : 1;
  /* clockScale quando é um número (preso ao intervalo do editor), senão o antigo clockSize - as contas antigas não mudam */
  function clockK() { const v = state.clockScale == null || state.clockScale === '' ? NaN : +state.clockScale; return isFinite(v) ? Math.max(.72, Math.min(1.75, v)) : kOfSize(state.clockSize); }
  function clockVars(k) { k = +k; if (!isFinite(k) || k <= 0) k = clockK(); return { k, kx: Math.min(k, CLOCK_KX), sy: Math.max(1, k / CLOCK_KX) }; }
  /* ---------- 1.4.0: estilo dos ícones da home (icons.js desenha, homecustom.js escolhe) ----------
     Valores validados aqui (uma conta com lixo numa chave vale o de origem); o tom 'auto' resolve-se pelo tema atual. */
  const ICON_MODES = ['default', 'dark', 'clear', 'tinted'];
  function iconState() {
    const mode = ICON_MODES.includes(state.iconStyle) ? state.iconStyle : 'default';
    let hue = +state.iconHue; hue = isFinite(hue) ? ((Math.round(hue) % 360) + 360) % 360 : 210;
    let sat = +state.iconSat; sat = isFinite(sat) ? Math.max(0, Math.min(1, sat)) : .7;
    const toneSet = state.iconTone === 'light' || state.iconTone === 'dark' ? state.iconTone : 'auto';
    return { mode, hue, sat, toneSet, tone: toneSet === 'auto' ? (isDark() ? 'dark' : 'light') : toneSet, size: state.iconSize === 'large' ? 'large' : 'small' };
  }
  function iconStyleSig() { const i = iconState(); return JSON.stringify([i.mode, i.hue, i.sat.toFixed(2), i.toneSet, i.size]); }
  /* sistema de numeração: só ids que o Lock conhece (Lock.NUMERALS); sem o Lock (ou sem a lista) fica o 0-9 */
  const numeralsOf = id => { const L = window.Lock && Lock.NUMERALS; return Array.isArray(L) && L.some(n => n && n[0] === id) ? id : 'latn'; };
  /* assinatura dos três fundos (só se repintam quando muda - apply() corre em cada setState: volume, brilho, …) */
  const wpSigNow = () => [state.wallpaper, JSON.stringify(state.wallpaperCustom || null), JSON.stringify(state.lockWallpaper || null)].join('|');
  function apply() {
    if (migrateNav()) { persistSoon(); if (account) setTimeout(() => { try { save(); } catch (e) {} }, 0); }
    if (window.L && L.code !== L.norm(state.lang)) L.set(state.lang);   /* idioma guardado na conta (assistente, código, datas) */
    const dark = isDark(); state.dark = dark;
    document.body.classList.toggle('dark', dark);
    document.body.dataset.text = state.textSize; document.body.dataset.clockfont = state.clockFont || 'default'; document.body.dataset.clockweight = state.clockWeight || 'regular';
    /* 1.4.0: o tamanho da hora é CONTÍNUO - três variáveis no <html> (lock.css faz as contas: letra 176 px × --clock-kx, scaleY ×
       --clock-sy, alturas do topo/notificações). O data-clocksize continua escrito, agora DERIVADO de k (os seletores antigos usam-no
       só para especificidade). Android: a Nova UI lê data-clocksize para os SEUS tamanhos e as chaves novas não existem lá - segue o
       clockSize de sempre. O editor pré-visualiza escrevendo as mesmas variáveis (Lock.previewScale) e grava no fim. */
    { const and = os === 'android', k = and ? kOfSize(state.clockSize) : clockK(), cv = clockVars(k), rs = document.documentElement.style;
      rs.setProperty('--clock-k', k.toFixed(3)); rs.setProperty('--clock-kx', cv.kx.toFixed(3)); rs.setProperty('--clock-sy', cv.sy.toFixed(3));
      document.body.dataset.clocksize = k < .93 ? 'small' : k > 1.07 ? 'large' : 'normal';
      document.body.dataset.numerals = and ? 'latn' : numeralsOf(state.clockNumerals); }
    /* peso exato da hora (lock.css lê body[data-clockwght="1"] + --clock-wght); só números de 100 a 900 */
    { const w = Math.round(+state.clockWght); const ok = state.clockWght != null && w >= 100 && w <= 900; document.body.dataset.clockwght = ok ? '1' : ''; if (ok) document.documentElement.style.setProperty('--clock-wght', String(w)); }
    /* Android: o azul da Nova UI substitui o azul de origem do PearOS (quem escolheu outra cor de destaque fica com ela)
       e os interruptores sao sempre azuis, como na Nova UI (no PearOS sao verdes, ou da cor de destaque) */
    const accent = (os === 'android' && (!state.accent || String(state.accent).toUpperCase() === '#0088FF')) ? '#3E7BFA' : (state.accent || '#0088FF');
    document.documentElement.style.setProperty('--accent', accent);
    document.documentElement.style.setProperty('--accent-dark', hexLighten(accent, .06));
    document.documentElement.style.setProperty('--toggle', os === 'android' ? 'var(--blue)' : (state.accentToggles ? 'var(--blue)' : 'var(--green)'));
    document.documentElement.style.setProperty('--clock-color', state.clockColor || '#fff');
    /* PearOS 27 Liquid Glass: um único cursor (0..100) vira três alfas pré-calculados - o CEF do FiveM não faz contas
       dentro de rgba(), e color-mix() não existe (ver fivem-nui-color-mix-transparent). --lg-a: material claro (dock, barras,
       botões de vidro); --lg-ad: material escuro; --lg-tint: tinta de cor por cima do vidro (0 = nada). */
    glassLive(state.glassTint);
    /* 1.5.0 (glass27.css): Reduzir transparência = vidro fosco opaco sem lente; Aumentar contraste = contorno forte e fills opacos */
    document.body.classList.toggle('reduce-transparency', !!state.reduceTransparency);
    document.body.classList.toggle('increase-contrast', !!state.increaseContrast);
    document.body.dataset.clock = state.clockCompact ? 'compact' : 'large';
    document.documentElement.style.setProperty('--clock-rgb', hexRgb(state.clockColor || '#FFFFFF'));   /* "R,G,B" para rgba() nos dígitos em vidro (lock.css) - color-mix() não existe no CEF */
    /* o wallpaper só se volta a aplicar quando muda (apply() corre em cada setState - volume, brilho, …) */
    const wpSig = wpSigNow(); if (wpSig !== apply._wp) { apply._wp = wpSig; applyWallpaper(); }
    renderStatus(); updateSbTheme();
    if (window.CC && CC.applyBrightness) CC.applyBrightness(state.brightness); /* brilho: overlay .bright-ov (shell/control.js) */
    const home = $('#home'); if (home) home.classList.toggle('nolabels', state.showLabels === false);
    /* 1.4.0 ícones: body[data-icons] / [data-icontone] (o material de vidro dos modos Transparente/Colorido vive no CSS, com escopo
       no body para os clones da galeria seguirem), #home.hm-large (ícones grandes: chave à parte para não perder a etiqueta que o
       jogador escolheu) e Icons.setStyle SÓ quando a assinatura muda - refazer as regras dos mosaicos em cada setState (volume,
       brilho…) era trabalho deitado fora. O tom resolvido e o sistema entram na chave: 'auto' muda com o tema, e voltar do Android
       tem de reaplicar. No Android nada disto existe (a Nova UI tem os seus ícones): data-icons fica 'default'. */
    { const ic = iconState(), and = os === 'android';
      document.body.dataset.icons = and ? 'default' : ic.mode; document.body.dataset.icontone = ic.tone;
      if (home) home.classList.toggle('hm-large', !and && ic.size === 'large');
      if (and) apply._ic = null;
      else { const key = iconStyleSig() + '|' + ic.tone; if (key !== apply._ic && window.Icons && Icons.setStyle) { apply._ic = key; try { Icons.setStyle({ mode: ic.mode, hue: ic.hue, sat: ic.sat, tone: ic.tone }); } catch (e) { console.error('[apex_phone] Icons.setStyle', e); } } } }
    /* Reduzir movimento: o CSS (motion.css) lê body[data-motion="reduced"]; as durações ficam curtas mas
       nunca 0, porque há setTimeout (fecho da janela 520 ms, descer o telemóvel 430 ms…) à espera delas */
    if (state.reduceMotion) document.body.dataset.motion = 'reduced'; else delete document.body.dataset.motion;
    /* Night Shift: véu âmbar translúcido por cima do ecrã (sem filter - regra CEF); só opacity anima */
    if (screen) { let ns = screen.querySelector(':scope > .nightshift-ov'); if (state.nightShift && !ns) { ns = document.createElement('div'); ns.className = 'nightshift-ov'; screen.appendChild(ns); void ns.offsetWidth; } if (ns) ns.classList.toggle('on', !!state.nightShift); }
    /* 24 h ⇄ 12 h: a hora da barra e do ecrã bloqueado refazem-se já, não no próximo minuto */
    if (apply._c24 !== undefined && apply._c24 !== (state.clock24 !== false) && ready) { try { tick(true); } catch (e) {} }
    apply._c24 = state.clock24 !== false;
    if (Bridge.inFiveM) applyScale(state.phoneScaleV2 || baseScale || 0.6);
  }
  /* Cursor Liquid Glass (0..100) → alfas pré-calculados nas variáveis --lg-* do <html>. Também chamado pelo cursor das Definições
     a arrastar (sem passar pelo apply, que é pesado). Com Reduzir transparência ou Aumentar contraste o vidro fica opaco (t = 1).
     --lg-al: a tinta branca "densa" das peças sobre zonas claras do fundo (glass27.css .lg-light); nunca calc() dentro de rgba(). */
  function glassLive(v) {
    let gt = Math.max(0, Math.min(100, Number(v == null ? 50 : v) || 0)) / 100;
    const opaque = !!(state.reduceTransparency || state.increaseContrast); if (opaque) gt = 1;
    const st = document.documentElement.style;
    st.setProperty('--lg-t', gt.toFixed(2));
    st.setProperty('--lg-a', (opaque ? .97 : 0.10 + gt * 0.62).toFixed(3));      /* .10 → .72 */
    st.setProperty('--lg-al', (opaque ? .97 : Math.min(.92, 0.28 + gt * 0.62)).toFixed(3));
    st.setProperty('--lg-ad', (opaque ? .97 : 0.16 + gt * 0.66).toFixed(3));     /* .16 → .82 */
    st.setProperty('--lg-tint', (opaque ? .92 : gt * 0.55).toFixed(3));           /* 0 → .55 */
    st.setProperty('--lg-m', (opaque ? .97 : 0.50 + gt * 0.46).toFixed(3));      /* material claro das barras/menus .50 → .96 */
    st.setProperty('--lg-md', (opaque ? .97 : 0.48 + gt * 0.48).toFixed(3));     /* escuro .48 → .96 */
    st.setProperty('--lg-mf', (opaque ? .98 : 0.80 + gt * 0.18).toFixed(3));     /* no jogo (sem desfoque) nunca abaixo de .80 */
    st.setProperty('--lg-mdf', (opaque ? .98 : 0.82 + gt * 0.16).toFixed(3));
  }
  /* O aparelho mede 976 px de altura no espaço de desenho. Com a escala a subir (0.98 no
     tamanho "Grande") isso dá 956 px reais, que NÃO cabem num ecrã de 768 nem de 900 - o
     telemóvel ficaria cortado em cima. Trava-se pela altura da janela, deixando a folga do
     Config.Offset mais 20 px de respiro. Quem tiver ecrã grande recebe a escala pedida. */
  const DEV_H = 976;
  /* DOBRÁVEIS: a escala trava-se TAMBÉM pela largura do aparelho ABERTO (1360 px), esteja ele aberto ou fechado. Assim o
     telemóvel nunca muda de tamanho ao abrir (cresce só para a esquerda, a aresta direita fica no sítio) e aberto nunca passa
     de 60 % da janela nem sai pela esquerda, mesmo com o Config.Offset. Os telemóveis normais nunca chegam a este limite. */
  function applyScale(v) {
    const want = +v || 0.6;
    const cs = getComputedStyle(document.documentElement);
    const room = (window.innerHeight || 1080) - (parseFloat(cs.getPropertyValue('--phone-bottom')) || 16) - 20;
    let max = room > 0 ? room / DEV_H : want;
    if (form === 'fold') { const W = window.innerWidth || 1920; const roomW = Math.min(W * .6, W - (parseFloat(cs.getPropertyValue('--phone-right')) || 24) - 20); if (roomW > 0) max = Math.min(max, roomW / FOLD.dow); }
    document.documentElement.style.setProperty('--scale', Math.min(want, max).toFixed(4));
  }
  const FRAMES = ['black', 'white', 'blue', 'wine', 'orange', 'silver',   /* wine: PearPhone 18 Pro Max bordô */
    's26-black', 's26-white', 's26-violet', 's26-sky',                  /* Android (S26 Ultra): preto, branco, cobalt violet, sky blue */
    'fold-night', 'fold-star',                                          /* PearPhone Fold (iOS, abre como um livro): azul-noite, branco-estrela */
    'flip-lavender', 'flip-grey', 'flip-cream', 'flip-pistachio'];      /* NOVA Fold (Android, abre como um livro): lavanda, cinzento, creme, pistácio */
  let frameNow = null;
  /* ---------- FORMATO DO APARELHO (dobráveis, contrato v2 de 2026-10-01) ----------
     Vem da moldura (o item decide): 'bar' (telemóvel normal, ecrã 440×956) ou 'fold' (os dois dobráveis, que abrem como um
     LIVRO: o PearPhone Fold "fold-*" no PearOS e o NOVA "flip-*" na Nova UI; os nomes dos itens e das molduras ficam). O formato
     'flip' saiu: as molduras flip-* são agora um dobrável de livro como o PearPhone Fold.
     Um dobrável tem DOIS estados: FECHADO (o ecrã de fora, 670×956, quase quadrado em pé) e ABERTO (o ecrã de dentro, 1340×956,
     deitado: a mesma altura e o dobro da largura). Sai sempre do bolso fechado; abre-se arrastando a aresta ESQUERDA do aparelho
     (ou pelo mosaico do Centro de controlo / painel rápido, que chama System.setFoldOpen) e fecha-se arrastando-a para a direita.
     Classes: .device.form-* e body.form-* (+ body[data-form]); com o formato 'fold' também .fold-open ou .fold-closed no <body> e
     no .device (nunca nos telemóveis normais). CSS: --screen-w segue o estado (670 / 1340, tokens.css); --fold-cw 670 e
     --fold-ow 1340; --page-w fica 440. JS: System.form, System.foldOpen, System.setFoldOpen(open, opts), System.SW (largura do
     ecrã em px), System.FOLD (as medidas); Bridge 'form:changed' { from, to } e 'fold:state' { open } (emitido DEPOIS de a
     geometria mudar: é aí que a home e as apps se voltam a dispor). Cada estado novo vai também ao Lua: Bridge.call('foldState',
     { open }), para a peça de duas partes na mão abrir ou fechar com o ecrã. */
  const formOf = f => /^(fold|flip)-/.test(String(f || '')) ? 'fold' : 'bar';
  /* medidas (px do aparelho): ecrã fechado cw × 956 e aberto ow × 956; aparelho com 10 px de moldura de cada lado (dcw, dow);
     a dobradiça fica SEMPRE a `ax` px da aresta direita (fechado: 10 px dentro da aresta esquerda; aberto: ao meio) */
  const FOLD = { cw: 670, ow: 1340, dcw: 690, dow: 1360, ax: 680 };
  let form = 'bar', foldOpen = false;
  const SW = () => form === 'fold' ? (foldOpen ? FOLD.ow : FOLD.cw) : 440;
  /* as classes do estado (só com o formato 'fold'): body e .device levam .fold-open ou .fold-closed */
  function foldCls() { const on = form === 'fold', b = document.body, d = $('.device');
    [b, d].forEach(n => { if (!n) return; n.classList.toggle('fold-open', on && foldOpen); n.classList.toggle('fold-closed', on && !foldOpen); }); }
  /* o que é passageiro fecha quando a geometria muda toda (outro formato, abrir ou fechar o dobrável): as apps ficam abertas.
     fold = abrir ou fechar o dobrável: nada do que estava à vista sai (as folhas, os alertas, as listas de ações, o texto escrito, o
     modo de edição, a pasta aberta, a Biblioteca de Apps e a pesquisa da home FICAM: o CSS e o 'fold:state' da home voltam a
     dispô-los na largura nova). Só fecha o que está preso a um ponto do ecrã antigo (menus de contexto) e os painéis do sistema;
     o teclado desce e volta a subir já na largura nova, com o mesmo campo (keepKb). Outro formato fecha tudo, como antes. */
  function closeTransient(fold) {
    try { if (window.UI) { if (fold && UI.dismissMenus) UI.dismissMenus(); else if (UI.dismissAll) UI.dismissAll(); } } catch (e) {}
    ['Notify', 'CC', 'Switcher', 'Vera', 'LockGallery', 'QuickPanel', 'Drawer', 'EdgePanel'].forEach(m => { try { window[m] && window[m].close && window[m].close(); } catch (e) {} });
    if (fold) keepKb(); else { try { window.Keyboard && Keyboard.hide && Keyboard.hide(); } catch (e) {} }
    try { if (window.Home && !fold) { if (Home.exitEdit) Home.exitEdit(); if (Home.closeFolder) Home.closeFolder(); if (Home.closeSpot) Home.closeSpot(); if (Home.closeSearch) Home.closeSearch(true); } } catch (e) {}
    try { if (window.Island && Island.collapse) Island.collapse(); } catch (e) {}
  }
  /* teclado aberto ao abrir ou fechar o dobrável: fica aberto, com o mesmo campo, e acerta-se na geometria nova (Keyboard.refit:
     o que ele tinha subido volta a medir-se, sem animação). Corre depois de as apps e a home se voltarem a dispor ('fold:state').
     Um campo que ficou tapado (a lista por trás do detalhe, ao fechar) perde o foco e o teclado desce: o próximo toque nele abre-o
     outra vez. Antes o teclado descia sempre e o campo ficava focado sem teclado, e tocar nele já não o abria */
  function keepKb() {
    const K = window.Keyboard; if (!K || !K.visible) return;
    setTimeout(() => {
      if (!K.visible) return;
      const t = document.activeElement, field = !!(t && t.matches && t.matches('input,textarea') && t.isConnected);
      let seen = false;
      if (field) { const r = t.getBoundingClientRect(), hit = r.width > 0 && r.height > 0 ? document.elementFromPoint(r.left + r.width / 2, r.top + r.height / 2) : null;
        seen = !!(hit && (hit === t || t.contains(hit) || hit.closest('#kb'))); }
      try { if (seen && K.refit && K.refit(t) !== false) return; } catch (e) { console.error('[apex_phone] Keyboard.refit', e); }
      try { K.hide(); } catch (e) {}
      if (field && !seen) { try { t.blur(); } catch (e) {} }
    }, 60);
  }
  function setFrame(f) { const d = $('.device'); if (!d || !f || FRAMES.indexOf(f) < 0) return;
    const nf = formOf(f);
    /* a mesma moldura outra vez (o Lua reenvia-a no open/frame): nada muda, e um arrasto ou uma animação a meio não pode ser cortada */
    if (f === frameNow && nf === form && d.classList.contains('frame-' + f)) return;
    frameNow = f;
    if (nf !== form && landscape) { try { rotate(false); } catch (e) {} }   /* o dobrável nunca fica deitado */
    foldStop();   /* outra moldura a meio de abrir/fechar: a animação acaba já no estado para onde ia */
    /* outra moldura = outro aparelho (outro item): um dobrável novo começa sempre FECHADO */
    if (nf !== form) foldOpen = false; else if (form === 'fold' && foldOpen) { tellLua(false); applyFold(false); }
    /* a classe do sistema, a paisagem e o estado do dobrável sobrevivem à troca de moldura (o className é reescrito por inteiro) */
    d.className = 'device frame-' + f + ' form-' + nf + (os === 'android' ? ' os-android' : ' os-ios') + (landscape ? ' landscape' : '');
    ['bar', 'fold'].forEach(k => document.body.classList.toggle('form-' + k, k === nf)); document.body.classList.remove('form-flip'); document.body.dataset.form = nf;
    const from = form, newForm = nf !== form;
    form = nf; foldCls();
    if (newForm) {
      /* outro formato com o telemóvel a correr: o que é passageiro fecha (a geometria muda toda), as apps ficam abertas */
      if (ready) closeTransient();
      frameRing(); foldGrip();
      if (nf === 'fold' && os !== 'android' && ready) { try { sbDate(new Date()); } catch (e) {} }   /* a data da barra de estado aparece já, não no próximo segundo */
      if (Bridge.inFiveM) applyScale(state.phoneScaleV2 || baseScale || 0.6); else if (fitNow) fitNow();
      Bridge.emit('form:changed', { from, to: nf });
      if (nf === 'fold') { Bridge.emit('fold:state', { open: false }); tellLua(false); }   /* um dobrável novo está fechado */
      try { if (window.Home && Home.render && ready) Home.render(); } catch (e) { console.error('[apex_phone] Home.render (form)', e); } }
    /* o fundo "Cor do aparelho" (Wallpapers.AUTO) segue a moldura: usar OUTRO item com o telemóvel aberto troca também o fundo.
       apply._wp a null obriga o próximo apply() a repintar mesmo com o estado igual; com o ecrã já construído repinta já.
       Outro formato também repinta: as cópias pré-desfocadas têm a proporção do ecrã (makeBlur). */
    const newWp = !!(window.Wallpapers && Wallpapers.setFrame && Wallpapers.setFrame(f));
    if (newWp || newForm) { apply._wp = null; if (screen) { try { applyWallpaper(); } catch (e) {} if (newWp && window.Bridge && Bridge.emit) Bridge.emit('wallpaper:changed'); } } }
  let baseScale = null;
  let fitNow = null;   /* encaixe do aparelho na janela fora do jogo (definido no init) */
  /* ---------- DOBRÁVEL: mudar de estado (a GEOMETRIA) ----------
     Troca já, sem animação: classes, --screen-w (tokens.css), o anel da moldura, as cópias desfocadas do fundo (têm a proporção do
     ecrã) e o que é passageiro fecha. Emite 'fold:state' no fim, com tudo já no sítio novo. Quem quer animar usa setFoldOpen. */
  /* mid = troca a meio de um arrasto ou animação que ainda pode voltar para trás: nada passageiro fecha aqui (fecha no fim,
     faEnd, e só se o estado mudou de facto) */
  function applyFold(open, mid) {
    open = !!open && form === 'fold';
    if (open === foldOpen) { foldCls(); return false; }
    foldOpen = open; foldCls();
    if (ready && !mid) closeTransient(true);
    frameRing();
    apply._wp = null; if (screen) { try { applyWallpaper(); } catch (e) {} }
    if (os !== 'android' && ready) { try { sbDate(new Date()); } catch (e) {} }
    try { renderStatus(); } catch (e) {}
    if (!Bridge.inFiveM && fitNow) fitNow();
    Bridge.emit('fold:state', { open });
    return true;
  }
  /* o Lua só ouve o estado PARA ONDE o dobrável vai (no arranque de uma animação, num arrasto que passou o limite, ou já): um
     arrasto desistido não mexe na peça da mão */
  let luaFold = null;
  function tellLua(open) { if (luaFold === open) return; luaFold = open; Bridge.call('foldState', { open }); }
  /* ---------- DOBRÁVEL: ABRIR / FECHAR COM ANIMAÇÃO E ARRASTO ----------
     O movimento é o de um LIVRO: a metade da frente (a do ecrã de fora) roda à volta da dobradiça e vai deitar-se à esquerda,
     mostrando a metade esquerda do ecrã de dentro; a metade de trás nunca mexe (a aresta direita do aparelho fica no sítio).
     p = quanto está aberto (0 fechado ... 1 aberto); a folha está a -180·p graus (rotateY, perspetiva na dobradiça).
     Peças: o PRÓPRIO aparelho, na geometria fechada, é a frente da folha (o ecrã de fora continua vivo enquanto roda) e some de
     costas depois dos 90° (backface hidden); o .frig no .stage, por trás do aparelho, desenha a metade direita do ecrã de dentro
     (por baixo da folha) e a face de dentro da folha (a metade esquerda), com o fundo do ecrã. Fechar a partir de aberto: o
     aparelho aberto desvanece por cima do .frig (igual a ele, só com o fundo) e passa à geometria fechada quando a folha passa os
     90° (está de lado, a troca não se vê). Nada muda de layout a meio: só transform e opacity. Reduzir movimento: só desvanece. */
  const PERSP = 3800;
  const easeOut = t => 1 - Math.pow(1 - t, 3);
  const easeInOut = t => t < .5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
  const clamp01 = v => Math.max(0, Math.min(1, v));
  let fa = null;   /* a animação/arrasto em curso (no máximo uma) */
  function rigBuild(stage, dev) {
    let rig = stage.querySelector(':scope > .frig');
    if (!rig) { rig = document.createElement('div'); rig.setAttribute('aria-hidden', 'true');
      rig.innerHTML = '<div class="frig-p frig-r"><div class="frig-s"><i><u></u></i></div><b class="frig-k"></b></div><div class="frig-p frig-l"><div class="frig-s"><i><u></u></i></div><b class="frig-k"></b></div>';
      stage.insertBefore(rig, dev); }
    rig.className = 'frig ' + (os === 'android' ? 'os-android' : 'os-ios');
    /* as cores da moldura vêm do aparelho (.device.frame-*: --f1..--f4) e o fundo do ecrã de dentro é o que ele vai mostrar */
    const cs = getComputedStyle(dev); ['--f1', '--f2', '--f3', '--f4'].forEach(k => rig.style.setProperty(k, cs.getPropertyValue(k).trim() || '#888'));
    const wp = String((screen && screen.style.getPropertyValue(locked ? '--wp-lock' : '--wp')) || '').trim();
    rig.querySelectorAll('u').forEach(u => { u.style.background = ''; if (wp && wp !== 'none') u.style.background = wp + ' center/cover no-repeat'; });
    return rig;
  }
  /* pinta o estado p (0..1): a folha (face de dentro), as sombras e, na geometria fechada, o próprio aparelho */
  function faSet(p) {
    const a = fa; if (!a) return; a.p = p = clamp01(p);
    if (a.red) return;
    /* fechar a partir de aberto: quando a folha passa os 90° o aparelho passa à geometria fechada e volta a ver-se (de lado) */
    if (p < .5 && !a.geoClosed) { a.geoClosed = true; applyFold(false, true); a.dev.style.transition = 'none'; a.dev.style.opacity = '1'; }
    const th = (-180 * p).toFixed(2), s = Math.sin(Math.PI * p);
    a.leaf.style.transform = `perspective(${PERSP}px) rotateY(${th}deg) translateX(340px) rotateY(180deg) translateX(-340px)`;
    a.leafK.style.opacity = (p > .5 ? .5 * s : 0).toFixed(3);
    a.underK.style.opacity = (.55 * (1 - Math.min(1, p * 1.6))).toFixed(3);   /* o ecrã de dentro "acende" ao abrir */
    if (a.geoClosed) { a.dev.style.transform = `perspective(${PERSP}px) rotateY(${th}deg)`; if (a.shade) a.shade.style.opacity = (p < .5 ? .5 * s : 0).toFixed(3); }
  }
  function foldBegin(fromOpen, why) {
    if (fa) return fa;
    const dev = $('.device'), stage = $('.stage'); if (form !== 'fold' || !dev || !stage) return null;
    let res = null; const promise = new Promise(r => { res = r; });
    const a = fa = { p: fromOpen ? 1 : 0, from: fromOpen, to: null, why, red: !!state.reduceMotion, dev, stage, geoClosed: !fromOpen, raf: 0, t: null, promise, res };
    if (a.red) return a;
    a.rig = rigBuild(stage, dev);
    a.leaf = a.rig.querySelector('.frig-l'); a.leafK = a.leaf.querySelector('.frig-k'); a.underK = a.rig.querySelector('.frig-r .frig-k');
    a.shade = dev.querySelector(':scope > .fold-shade');
    dev.classList.add('fold-anim'); document.body.classList.add('fold-anim');
    dev.style.transformOrigin = (FOLD.dcw - FOLD.ax) + 'px 50%';   /* a dobradiça, na geometria fechada */
    /* aberto: o aparelho desvanece por cima do .frig (que tem a mesma silhueta e o mesmo fundo) */
    if (fromOpen) { dev.style.transition = 'opacity .12s ease-out'; dev.style.opacity = '0'; } else dev.style.transition = 'none';
    faSet(a.p);
    return a;
  }
  function faAnim(to, ms, ease, done) {
    const a = fa; if (!a) return; cancelAnimationFrame(a.raf); clearTimeout(a.t);
    const p0 = a.p, t0 = performance.now();
    const step = () => { if (fa !== a) return; const t = Math.min(1, (performance.now() - t0) / ms); faSet(p0 + (to - p0) * ease(t)); if (t < 1) a.raf = requestAnimationFrame(step); else { clearTimeout(a.t); done(); } };
    a.raf = requestAnimationFrame(step);
    a.t = setTimeout(() => { if (fa !== a) return; cancelAnimationFrame(a.raf); faSet(to); done(); }, ms + 260);   /* sem frames (telemóvel tapado) não fica a meio */
  }
  /* acabar: o estado final fica já (aberto: o aparelho aberto acende por cima do .frig e este sai a seguir) */
  function faEnd(open) {
    const a = fa; if (!a) return; cancelAnimationFrame(a.raf); clearTimeout(a.t);
    const dev = a.dev, done = () => { if (a.rig) a.rig.remove(); dev.style.transition = ''; dev.style.opacity = ''; dev.style.transformOrigin = ''; dev.style.transform = ''; if (a.shade) a.shade.style.opacity = ''; if (fa === a) fa = null; a.res(true); };
    dev.style.transition = 'none'; dev.style.transform = ''; dev.classList.remove('fold-anim'); document.body.classList.remove('fold-anim');
    if (a.shade) a.shade.style.opacity = '';
    if (open) {
      dev.style.opacity = '0'; applyFold(true, true); void dev.offsetWidth;
      dev.style.transition = 'opacity .2s ease-out'; dev.style.opacity = '1';
      a.t = setTimeout(done, 230);
    } else { if (!a.geoClosed || foldOpen) applyFold(false, true); dev.style.opacity = ''; done(); }
    /* só agora, com o estado decidido: um arrasto desistido (voltou ao que era) não fecha nada */
    if (ready && open !== a.from) closeTransient(true);
  }
  /* decidir para onde vai (o Lua é avisado já, para a peça na mão acompanhar) e animar até lá */
  /* abrir acende o ecrã de dentro, como num dobrável a sério (com o ecrã apagado ou no Always-On) */
  const wakeOnOpen = open => { if (!open) return; try { if (window.Hardware && Hardware.inited && Hardware.screenOff) Hardware.wake(); } catch (e) {} };
  function foldFinish(open, why, ms) {
    const a = fa; if (!a) return; a.to = open; if (why !== 'nudge') { tellLua(open); wakeOnOpen(open); }
    if (a.red) { const dev = a.dev; clearTimeout(a.t);
      /* Reduzir movimento: desvanece, troca e volta a aparecer (só opacity) */
      dev.style.transition = 'opacity .14s ease-in'; dev.style.opacity = '0';
      a.t = setTimeout(() => { if (fa !== a) return; applyFold(open); void dev.offsetWidth; dev.style.transition = 'opacity .18s ease-out'; dev.style.opacity = '1';
        a.t = setTimeout(() => { dev.style.transition = ''; dev.style.opacity = ''; if (fa === a) fa = null; a.res(true); }, 200); }, 150);
      return; }
    const dist = Math.abs((open ? 1 : 0) - a.p);
    const dur = ms || (why === 'drag' ? Math.round(Math.min(560, Math.max(200, 180 + 440 * dist))) : (open ? 600 : 500));
    faAnim(open ? 1 : 0, dur, why === 'drag' ? easeOut : easeInOut, () => faEnd(open));
  }
  /* parar já (outra moldura, sair do bolso): fica no estado para onde ia, sem animação */
  function foldStop() {
    const a = fa; if (!a) return; cancelAnimationFrame(a.raf); clearTimeout(a.t);
    const open = a.to != null ? a.to : a.from, dev = a.dev;
    if (a.rig) a.rig.remove();
    dev.classList.remove('fold-anim'); document.body.classList.remove('fold-anim');
    dev.style.transition = ''; dev.style.opacity = ''; dev.style.transform = ''; dev.style.transformOrigin = ''; if (a.shade) a.shade.style.opacity = '';
    fa = null; if (form === 'fold' && open !== foldOpen) applyFold(open, true);
    if (ready && form === 'fold' && open !== a.from) closeTransient(true);
    a.res(false);
  }
  /* API: System.setFoldOpen(open, { instant, ms }) → Promise (true quando acaba). Guardado no bolso é sempre instantâneo. */
  function setFoldOpen(open, opts = {}) {
    open = !!open; if (form !== 'fold') return Promise.resolve(false);
    const bc = document.body.classList;
    if (opts.instant || !screen || (Bridge.inFiveM && bc.contains('hidden') && !bc.contains('pk'))) { foldStop(); tellLua(open); applyFold(open); if (!bc.contains('hidden')) wakeOnOpen(open); return Promise.resolve(true); }
    if (fa) { if (fa.to !== open) foldFinish(open, 'set', opts.ms); return fa.promise; }
    if (open === foldOpen) { tellLua(open); return Promise.resolve(false); }
    const a = foldBegin(foldOpen, 'set'); if (!a) { tellLua(open); applyFold(open); return Promise.resolve(true); }
    foldFinish(open, 'set', opts.ms); return a.promise;
  }
  /* toque na lombada sem arrastar (fechado): a folha abre um bocadinho e volta, a dizer que se arrasta dali */
  function foldNudge() {
    if (fa || foldOpen || state.reduceMotion) return;
    const a = foldBegin(false, 'nudge'); if (!a) return; a.to = false;
    faAnim(.07, 170, easeOut, () => faAnim(0, 280, easeInOut, () => faEnd(false)));
  }
  /* ---------- a PEGA: a aresta esquerda do aparelho (a lombada, fechado; a aresta esquerda, aberto) ----------
     36 px à volta da aresta: 26 por fora do aparelho e os 10 da moldura, nunca dentro do ecrã (a borda do ecrã é do gesto de
     voltar). Arrastar na horizontal: para a esquerda abre, para a direita fecha; a folha segue o rato (680 px = o caminho todo).
     Largar depois de 40 % do caminho, ou com um gesto rápido, acaba; antes disso volta para trás com mola. Um arrasto mais
     vertical do que horizontal não é deste gesto. */
  let grip = null;
  function foldGrip() {
    const d = $('.device'); if (!d) return;
    if (form !== 'fold') { if (grip) { grip.remove(); grip = null; } d.querySelectorAll(':scope > .fold-shade').forEach(n => n.remove()); return; }
    if (!grip || !grip.isConnected) { grip = document.createElement('div'); grip.className = 'fold-grip'; grip.innerHTML = '<i></i>'; d.appendChild(grip); bindGrip(grip); }
    if (!d.querySelector(':scope > .fold-shade')) { const s = document.createElement('div'); s.className = 'fold-shade'; d.appendChild(s); }
  }
  function bindGrip(g) {
    let gs = null;
    g.addEventListener('pointerdown', e => {
      if (form !== 'fold' || fa || gs) return; if (e.button && e.pointerType === 'mouse') return;
      if (Bridge.inFiveM && document.body.classList.contains('hidden')) return;
      e.stopPropagation();
      const now = performance.now(); gs = { id: e.pointerId, x: e.clientX, y: e.clientY, z: (window.UI && UI.zoom && UI.zoom()) || 1, on: false, from: foldOpen, t0: now, lx: e.clientX, lt: now, v: 0 };
      try { g.setPointerCapture(e.pointerId); } catch (x) {}
    });
    g.addEventListener('pointermove', e => {
      if (!gs || e.pointerId !== gs.id) return;
      if (gs.on && (!fa || fa.to != null)) { gs = null; return; }   /* alguém decidiu por cima (guardar o telemóvel, o mosaico): o rato deixa de mandar */
      const dx = (e.clientX - gs.x) / gs.z, dy = (e.clientY - gs.y) / gs.z, now = performance.now();
      gs.v = gs.v * .35 + ((e.clientX - gs.lx) / gs.z) / Math.max(1, now - gs.lt) * .65; gs.lx = e.clientX; gs.lt = now;
      if (!gs.on) {
        if (Math.abs(dx) < 7 && Math.abs(dy) < 7) return;
        if (Math.abs(dy) > Math.abs(dx)) { gs = null; return; }
        if (!foldBegin(gs.from, 'drag')) { gs = null; return; } gs.on = true; lastTouch = Date.now();
      }
      faSet(gs.from ? 1 - clamp01(dx / FOLD.ax) : clamp01(-dx / FOLD.ax));
    });
    const up = e => {
      if (!gs || e.pointerId !== gs.id) return; const s = gs; gs = null;
      if (!s.on) { if (!s.from && e.type === 'pointerup' && performance.now() - s.t0 < 400) foldNudge(); return; }
      const a = fa; if (!a || a.to != null) return;
      const v = performance.now() - s.lt > 90 ? 0 : s.v;   /* parado antes de largar: sem impulso */
      const moved = s.from ? 1 - a.p : a.p, flick = s.from ? v > .45 : v < -.45, back = s.from ? v < -.45 : v > .45;
      foldFinish(!back && (moved >= .4 || flick) ? !s.from : s.from, 'drag');
    };
    g.addEventListener('pointerup', up); g.addEventListener('pointercancel', up);
  }
  let peek = () => {}, peekEnd = () => {};   /* definidos no init (precisam do DOM); ver "ESPREITAR" mais abaixo */
  let peekMs = 3000;                          /* Config.PeekSeconds × 1000, vindo do ready */
  function wpStyle(el, w, custom) { if (!el) return; const isLock = el.classList.contains('wallpaper-lock'); el.className = 'wallpaper custom' + (isLock ? ' wallpaper-lock' : ''); el.style.background = '';
    let v = '';
    /* 1.4.0: fundos "de tipo" (Emoji, Meteorologia, Astronomia, Cor, Fotos aleatórias) e estilos de foto - o estado só tem a
       receita ({ kind, … } / { url, style }); o WallKinds desenha (SVG ou canvas, em cache) e devolve um background-image.
       Vale nos DOIS sistemas (um ecrã do PearOS continua a ver-se no Android). Se o WallKinds falhar ou não existir, a receita
       cai na precedência de sempre (url > css > seed > fundo do aparelho) - nunca um fundo vazio. */
    let kind = false;
    if (custom && window.WallKinds) { try { if (WallKinds.needs(custom)) { v = WallKinds.css(custom) || ''; kind = !!v; } } catch (e) { console.error('[apex_phone] WallKinds.css', e); v = ''; kind = false; } }
    if (kind) el.style.backgroundImage = v;
    else if (custom && custom.url) { v = `url("${custom.url}")`; el.style.backgroundImage = v; } else if (custom && custom.css) { v = custom.css; el.style.background = v; }   /* cor / gradiente (galeria do ecrã bloqueado) */
    else if (custom && custom.seed) { v = photoBg(custom.seed); el.style.background = v; } else { v = window.Wallpapers ? Wallpapers.css(w) : ''; el.style.backgroundImage = v; }
    /* 1.4.1: enquadramento de uma foto (custom.crop, editor do ecrã bloqueado). Zoom e posição só nesta camada; a cópia desfocada (makeBlur)
       ignora-o de propósito: é só cor, e com a mesma imagem fica em cache. O el.style.background = '' do início já limpou um crop anterior. */
    if (custom && custom.crop && window.WallKinds && WallKinds.cropCss) { let cc = null; try { cc = WallKinds.cropCss(custom, SW(), 956); } catch (e) {} if (cc) { el.style.backgroundSize = cc.size; el.style.backgroundPosition = cc.pos; } }
    /* cópia para as camadas com fundo desfocado (.lock-p2, e no jogo CC/NC/switcher…): var(--wp) / var(--wp-lock) no ecrã (ver lock.css / motion.css) */
    const scr = screen || $('#screen'); if (scr) scr.style.setProperty(isLock ? '--wp-lock' : '--wp', v || 'none');
    makeBlur(v, isLock ? '--wp-lock-blur' : '--wp-blur'); }
  /* Wallpaper desfocado PRÉ-RENDERIZADO num canvas (imagem estática em var(--wp-blur)): no CEF do FiveM qualquer filter:blur numa camada grande
     cria uma superfície ~40 px maior que o elemento, composta a preto → retângulo preto atrás do telemóvel. Sem filter, sem superfície. */
  const blurCache = {};
  /* Duas cópias por wallpaper: --wp-blur (9 px, dock/switcher/pastas) e --wp-blur2 (o dobro, "vidro" do Centro de controlo e do
     Centro de notificações - o PearOS 26 desfoca o fundo destes até ficar só cor). No browser (file://) o canvas fica "tainted"
     e cai-se para a imagem nítida: o url() relativo tem de ficar ABSOLUTO, senão, substituído dentro de um var() no motion.css,
     era resolvido em css/img/… e a camada ficava sem fundo nenhum (foi por isso que as capturas do CC mostravam a home por trás). */
  /* o pedido MAIS RECENTE de cada variável (--wp-blur, --wp-lock-blur): uma cópia de um fundo ANTERIOR que acabe de carregar
     depois da do fundo atual não pode pintar por cima dela (no arranque o JPG de origem do S26 acabava depois do fundo do
     NOVA Flip e os vidros, a barra de estado e o bloqueado ficavam com o fundo errado). A cópia vai na mesma para a cache. */
  const blurWant = {};
  /* TOM do fundo para a barra direita do PearPhone Fold (Rail): 'light' ou 'dark', medido na cópia desfocada na faixa da
     DIREITA (onde a barra vive). Fica no #screen como data-wp-tone (fundo da home) e data-wp-lock-tone (bloqueado); o CSS
     escolhe com isso o texto e a tinta do vidro (claro: texto escuro). 0,62 como no ecrã bloqueado do Android. */
  const lumOf = (r, g, b) => (.2126 * r + .7152 * g + .0722 * b) / 255;
  function toneOf(c) {
    try { const t = document.createElement('canvas'); t.width = 12; t.height = 26; const x = t.getContext('2d'); x.drawImage(c, 0, 0, 12, 26);
      const d = x.getImageData(9, 0, 3, 26).data; let s = 0, n = 0; for (let i = 0; i < d.length; i += 4) { s += lumOf(d[i], d[i + 1], d[i + 2]); n++; }
      return n && s / n > .62 ? 'light' : 'dark'; } catch (e) { return null; }
  }
  /* cor ou gradiente: a média das cores que lá estão escritas (#hex ou rgb) */
  function toneCss(v) {
    const m = String(v || '').match(/#[0-9a-f]{6}\b|#[0-9a-f]{3}\b|rgba?\([\d\s.,%]+\)/gi); if (!m) return 'dark';
    let s = 0, n = 0;
    m.forEach(c => { let r, g, b;
      if (c[0] === '#') { const h = c.length === 4 ? c.slice(1).split('').map(x => x + x).join('') : c.slice(1); const k = parseInt(h, 16); r = k >> 16; g = (k >> 8) & 255; b = k & 255; }
      else { const p = c.replace(/[^\d.,]/g, '').split(',').map(Number); r = p[0]; g = p[1]; b = p[2]; }
      if ([r, g, b].every(x => isFinite(x))) { s += lumOf(r, g, b); n++; } });
    return n && s / n > .62 ? 'light' : 'dark';
  }
  function setTone(varName, tone) {
    const scr = screen || $('#screen');
    if (scr && tone) { const k = varName === '--wp-lock-blur' ? 'wpLockTone' : varName === '--wp-blur' ? 'wpTone' : null; if (k && scr.dataset[k] !== tone) scr.dataset[k] = tone; }
    /* 1.5.0: a grelha de tons do vidro (glass.js) lê a cópia acabada de escrever; para cores/gradientes lê o data-wp-tone já atualizado acima */
    if (window.Glass && Glass.wallpaper) { try { Glass.wallpaper(varName); } catch (e) {} }
  }
  function makeBlur(v, varName) {
    /* url("…") - o data URI do SVG contém parênteses (rotate(), url(#…)) por isso NÃO se pode cortar no primeiro ")" */
    const scr = screen || $('#screen'); if (!scr) return; const m = /url\("([^"]+)"\)/.exec(v || '') || /url\('([^']+)'\)/.exec(v || '') || /url\(([^)]+)\)/.exec(v || '');
    const var2 = varName + '2';
    if (!m) { blurWant[varName] = null; const g = v && v !== 'none' ? v : 'none'; scr.style.setProperty(varName, g); scr.style.setProperty(var2, g); setTone(varName, toneCss(g)); return; }   /* gradientes: já são suaves, usam-se tal e qual */
    /* a cópia tem a proporção do ecrã (220×478; no dobrável 335×478 fechado e 670×478 aberto): a cache é por imagem E por largura */
    const src = m[1], CW = Math.round(220 * SW() / 440), key = src + '|' + CW; blurWant[varName] = key;
    const hit = blurCache[key]; if (hit) { delete blurCache[key]; blurCache[key] = hit; scr.style.setProperty(varName, hit[0]); scr.style.setProperty(var2, hit[1]); setTone(varName, hit[2]); return; }
    let abs = src; try { if (!/^(data:|blob:|[a-z]+:\/\/)/i.test(src)) abs = new URL(src, location.href).href; } catch (e) {}
    const sharp = `url("${abs}")`; scr.style.setProperty(varName, sharp); scr.style.setProperty(var2, sharp);                     /* enquanto carrega: imagem nítida */
    const img = new Image(); if (!/^data:/.test(src)) img.crossOrigin = 'anonymous';
    img.onload = () => { try {
      /* cover com margem (sem bordas esbatidas). Os wallpapers SVG (viewBox 440×956, sem width/height) não têm tamanho intrínseco fiável → assume-se a proporção do ecrã */
      const svg = /svg/i.test(src.slice(0, 40)); let iw = img.naturalWidth || img.width, ih = img.naturalHeight || img.height; if (svg || !iw || !ih || iw === 300 && ih === 150) { iw = 440; ih = 956; }
      /* 1.4.0: os fundos do WallKinds desenham-se à LARGURA do ecrã (670/1340 no PearPhone Fold): a proporção lê-se do viewBox do
         próprio data URI (codificado ou não). Os SVG antigos têm viewBox 0 0 440 956 → exatamente o mesmo que antes. */
      if (svg) { const vb = /viewBox(?:%3D|=)(?:%22|"|')0(?:%20|\s)+0(?:%20|\s)+(\d+(?:\.\d+)?)(?:%20|\s)+(\d+(?:\.\d+)?)/i.exec(src.slice(0, 600)); if (vb && +vb[1] > 0 && +vb[2] > 0) { iw = +vb[1]; ih = +vb[2]; } }
      let tone = null;
      const paint = (W, H, filter, q, tn) => { const c = document.createElement('canvas'); c.width = W; c.height = H; const x = c.getContext('2d');
        x.fillStyle = '#1C1C1E'; x.fillRect(0, 0, W, H); x.filter = filter;
        const r = Math.max((W + 48) / iw, (H + 48) / ih), w = iw * r, h = ih * r; x.drawImage(img, (W - w) / 2, (H - h) / 2, w, h);
        if (tn) tone = toneOf(c);
        return `url("${c.toDataURL('image/jpeg', q)}")`; };
      const out = paint(CW, 478, 'blur(9px) saturate(125%)', .82, true);
      const out2 = paint(Math.round(CW / 2), 239, 'blur(11px) saturate(150%)', .8);   /* metade da resolução + 11 px = ~4× o desfoque ao tamanho do ecrã */
      blurCache[key] = [out, out2, tone];
      /* LRU de 12: com os fundos dinâmicos (1.4.0: Fotos aleatórias a cada abertura, emoji, estilos de foto, meteorologia) cada
         variação deixava aqui duas cópias JPEG e uma chave do tamanho da foto, para sempre. A ordem de inserção é a de uso (o acerto
         em cima volta a inserir). */
      { const ks = Object.keys(blurCache); for (let i = 0; i < ks.length - 12; i++) delete blurCache[ks[i]]; }
      /* só pinta se ainda for o pedido atual desta variável (o fundo ou o formato podem ter mudado enquanto a imagem carregava) */
      if (blurWant[varName] === key) { scr.style.setProperty(varName, out); scr.style.setProperty(var2, out2); setTone(varName, tone); }
    } catch (e) { /* imagem externa sem CORS: fica a nítida */ } };
    img.src = src;
  }
  /* anel da moldura por cima do ecrã (ver .frame-ring em system.css): aparelho 460×976; moldura r67→63 (gradiente 160° igual ao
     da moldura) + bezel preto r63→57. O PearPhone Fold tem um anel por estado (ringFold, mais abaixo). */
  function frameRing() {
    const d = $('.device'); if (!d) return;
    /* a moldura e desenhada por sistema, por formato E pelo estado do dobrável: o anel do PearPhone (aqui) ou o do Android
       (SysUI.frameRing, shell/android-sysui.js). Mudar qualquer um apaga a que estava e desenha a outra. Tudo o que uma moldura
       acrescenta ao aparelho fica marcado com data-ring e sai junto: nunca ficam restos de outro aparelho. */
    const st = form === 'fold' ? (foldOpen ? 'open' : 'closed') : '';
    const old = d.querySelector('.frame-ring'); if (old && old.dataset.os === os && old.dataset.form === form && (old.dataset.state || '') === st) return;
    d.querySelectorAll(':scope > [data-ring], :scope > .frame-ring').forEach(n => n.remove());
    const before = new Set(d.children);
    const mark = () => { [...d.children].forEach(n => { if (!before.has(n)) n.dataset.ring = os; }); const n = d.querySelector('.frame-ring'); if (n) { n.dataset.os = os; n.dataset.form = form; if (st) n.dataset.state = st; } };
    if (os === 'android') { if (window.SysUI && SysUI.frameRing) { try { d.insertAdjacentHTML('beforeend', SysUI.frameRing(form, foldOpen)); mark(); } catch (e) { console.error('[apex_phone] SysUI.frameRing', e); } } return; }
    if (form === 'fold') { d.insertAdjacentHTML('beforeend', ringFold(foldOpen)); mark(); return; }
    /* retângulo arredondado (x, y, largura, altura, raio) - todos os anéis são concêntricos: 67 (carcaça) → 63 (bezel) → 57 (ecrã) */
    const rr = (x, y, w, h, r) => `M${x + r} ${y}H${x + w - r}A${r} ${r} 0 0 1 ${x + w} ${y + r}V${y + h - r}A${r} ${r} 0 0 1 ${x + w - r} ${y + h}H${x + r}A${r} ${r} 0 0 1 ${x} ${y + h - r}V${y + r}A${r} ${r} 0 0 1 ${x + r} ${y}Z`;
    const W = SW() + 20, kx = W / 460;
    const R67 = rr(0, 0, W, 976, 67), R63 = rr(4, 4, W - 8, 968, 63), R57 = rr(10, 10, W - 20, 956, 57);
    /* alumínio: gradiente base da cor (frameGrad) + reflexo diagonal claro→escuro (frameSheen) + laterais ligeiramente mais escuras (frameSide);
       junta escura entre alumínio e bezel; sombra exterior em 3 traços vetoriais (sem box-shadow/filter - regra CEF) */
    d.insertAdjacentHTML('beforeend', `<svg class="frame-ring" viewBox="0 0 ${W} 976" aria-hidden="true"><defs>
      <linearGradient id="frameGrad" gradientUnits="userSpaceOnUse" x1="${46 * kx}" y1="-17" x2="${W - 46 * kx}" y2="993"><stop offset="0" class="s1"/><stop offset=".4" class="s2"/><stop offset=".7" class="s3"/><stop offset="1" class="s4"/></linearGradient>
      <linearGradient id="frameSheen" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="${W}" y2="976"><stop offset="0" stop-color="#fff" stop-opacity=".34"/><stop offset=".22" stop-color="#fff" stop-opacity=".08"/><stop offset=".5" stop-color="#000" stop-opacity=".06"/><stop offset=".78" stop-color="#000" stop-opacity=".2"/><stop offset="1" stop-color="#fff" stop-opacity=".14"/></linearGradient>
      <linearGradient id="frameSide" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="${W}" y2="0"><stop offset="0" stop-color="#000" stop-opacity=".24"/><stop offset="${(23 / W).toFixed(4)}" stop-color="#000" stop-opacity="0"/><stop offset="${(1 - 23 / W).toFixed(4)}" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".24"/></linearGradient>
      </defs>
      <path class="shade" d="${rr(-7.5, -6.5, W + 15, 990, 74.5)}" stroke-width="5" stroke-opacity=".05"/><path class="shade" d="${rr(-4, -3.5, W + 8, 983, 71)}" stroke-width="4" stroke-opacity=".09"/><path class="shade" d="${rr(-1.5, -1, W + 3, 978, 68.5)}" stroke-width="3" stroke-opacity=".15"/>
      <path fill="url(#frameGrad)" fill-rule="evenodd" d="${R67}${R63}"/><path fill="url(#frameSheen)" fill-rule="evenodd" d="${R67}${R63}"/><path fill="url(#frameSide)" fill-rule="evenodd" d="${R67}${R63}"/>
      <path class="bz" fill-rule="evenodd" d="${R63}${R57}"/><path class="seam" fill="none" d="${rr(4.3, 4.3, W - 8.6, 967.4, 62.7)}"/><path class="glass" fill="none" d="${R57}"/>
      <path class="rim" fill="none" d="${rr(.5, .5, W - 1, 975, 66.5)}"/></svg>`);
    mark();
  }
  /* ---------- MOLDURA DO PEARPHONE FOLD (as referências do dono: fechado como a imagem 9, aberto como a 10) ----------
     FECHADO (690×976): quase quadrado em pé, cantos pequenos à esquerda (16) e grandes à direita (84), com a LOMBADA metálica da
     dobradiça na aresta esquerda (um cilindro de 12 px que sai 7 px para fora; é por ali que se agarra para abrir). Ecrã 670×956
     com cantos 6 / 74. ABERTO (1360×976): deitado, cantos 64 em toda a volta, ecrã 1340×956 com cantos 54, e as marcas pequenas
     da dobradiça a meio das arestas de cima e de baixo (x = 680). NUNCA há vinco no ecrã. Metal de 4 px + bezel preto de 6 px. */
  const rr4 = (x, y, w, h, r) => { const [a, b, c, e] = r; return `M${x + a} ${y}H${x + w - b}A${b} ${b} 0 0 1 ${x + w} ${y + b}V${y + h - c}A${c} ${c} 0 0 1 ${x + w - c} ${y + h}H${x + e}A${e} ${e} 0 0 1 ${x} ${y + h - e}V${y + a}A${a} ${a} 0 0 1 ${x + a} ${y}Z`; };
  const grow = (r, k) => r.map(v => v + k);
  function ringFold(open) {
    const W = open ? FOLD.dow : FOLD.dcw, kx = W / 460;
    const RO = open ? [64, 64, 64, 64] : [16, 84, 84, 16];                  /* carcaça */
    const R0 = rr4(0, 0, W, 976, RO), R1 = rr4(4, 4, W - 8, 968, grow(RO, -4)), R2 = rr4(10, 10, W - 20, 956, grow(RO, -10));
    const sh = (k, w, o) => `<path class="shade" d="${rr4(-k, -k + 1, W + 2 * k, 976 + 2 * k - 1, grow(RO, k))}" stroke-width="${w}" stroke-opacity="${o}"/>`;
    /* lombada (fechado): cilindro com luz ao meio, a junta escura que a separa do bezel e um fio de brilho */
    const spine = open ? '' : `<rect class="fs-body" x="-7" y="3" width="12.6" height="970" rx="6.3" fill="url(#fsCyl)"/><rect x="-7" y="3" width="12.6" height="970" rx="6.3" fill="url(#fsEnd)"/>
      <path class="fs-gap" fill="none" d="M5.9 14V962"/><rect class="fs-hi" x="-3.6" y="16" width="1.5" height="944" rx=".75"/>`;
    const spineDefs = open ? '' : `<linearGradient id="fsCyl" gradientUnits="userSpaceOnUse" x1="-7" y1="0" x2="5.6" y2="0"><stop offset="0" class="s3"/><stop offset=".3" class="s1"/><stop offset=".62" class="s2"/><stop offset="1" class="s3"/></linearGradient>
      <linearGradient id="fsEnd" gradientUnits="userSpaceOnUse" x1="0" y1="3" x2="0" y2="973"><stop offset="0" stop-color="#000" stop-opacity=".28"/><stop offset=".02" stop-color="#000" stop-opacity="0"/><stop offset=".98" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".3"/></linearGradient>`;
    /* marcas da dobradiça (aberto): tampa escura que sai 1,5 px da aresta, a meio de cima e de baixo */
    const M = FOLD.dow / 2;
    const hinge = open ? `<path class="hg" fill="none" d="M${M} 0V4.4M${M} 971.6V976"/><rect class="hn" x="${M - 6}" y="-1.6" width="12" height="5.4" rx="1.6"/><rect class="hn" x="${M - 6}" y="972.2" width="12" height="5.4" rx="1.6"/>
      <path class="hn-l" fill="none" d="M${M - 4.6} -.9H${M + 4.6}M${M - 4.6} 976.9H${M + 4.6}"/>` : '';
    return `<svg class="frame-ring frf-ring" viewBox="0 0 ${W} 976" aria-hidden="true"><defs>
      <linearGradient id="frameGrad" gradientUnits="userSpaceOnUse" x1="${46 * kx}" y1="-17" x2="${W - 46 * kx}" y2="993"><stop offset="0" class="s1"/><stop offset=".4" class="s2"/><stop offset=".7" class="s3"/><stop offset="1" class="s4"/></linearGradient>
      <linearGradient id="frameSheen" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="${W}" y2="976"><stop offset="0" stop-color="#fff" stop-opacity=".34"/><stop offset=".22" stop-color="#fff" stop-opacity=".08"/><stop offset=".5" stop-color="#000" stop-opacity=".06"/><stop offset=".78" stop-color="#000" stop-opacity=".2"/><stop offset="1" stop-color="#fff" stop-opacity=".14"/></linearGradient>
      <linearGradient id="frameSide" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="${W}" y2="0"><stop offset="0" stop-color="#000" stop-opacity=".24"/><stop offset="${(23 / W).toFixed(4)}" stop-color="#000" stop-opacity="0"/><stop offset="${(1 - 23 / W).toFixed(4)}" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".24"/></linearGradient>
      ${spineDefs}</defs>
      ${sh(7.5, 5, .05)}${sh(4, 4, .09)}${sh(1.5, 3, .15)}
      <path fill="url(#frameGrad)" fill-rule="evenodd" d="${R0}${R1}"/><path fill="url(#frameSheen)" fill-rule="evenodd" d="${R0}${R1}"/><path fill="url(#frameSide)" fill-rule="evenodd" d="${R0}${R1}"/>
      <path class="bz" fill-rule="evenodd" d="${R1}${R2}"/><path class="seam" fill="none" d="${rr4(4.3, 4.3, W - 8.6, 967.4, grow(RO, -4.3))}"/><path class="glass" fill="none" d="${R2}"/>
      <path class="rim" fill="none" d="${rr4(.5, .5, W - 1, 975, grow(RO, -.5))}"/>${hinge}${spine}</svg>`;
  }
  /* ---------- BURACO ATÉ AO JOGO (visor da câmara e Face Key) ----------
     No jogo o visor não é uma imagem: é a AUSÊNCIA de telemóvel. Todas as camadas por trás dele têm de
     sair, e por ESTILO EM LINHA - o CEF serve folhas de estilo em cache e uma regra antiga deixava o
     telemóvel a pintar por cima do mundo (foi o que fez o visor aparecer laranja: era o fundo do
     telemóvel, desfocado, e não a câmara). O estilo em linha ganha sempre; tudo é reposto ao desligar. */
  const HOLE_CLEAR = ['.stage', '.device', '.bezel', '#screen', '#apps', '#setup', '.app-window', '.nav-stack', '.view'];
  const HOLE_HIDE  = ['.wallpaper', '.wallpaper-blur', '.wallpaper-lock', '#home', '#lock', '.torch-glow', '.hello-shape'];
  function seeThrough(on, extra) {
    if (!Bridge.inFiveM) return;
    on = !!on;
    HOLE_CLEAR.forEach(s => document.querySelectorAll(s).forEach(el => { el.style.background = on ? 'transparent' : ''; }));
    HOLE_HIDE.forEach(s => document.querySelectorAll(s).forEach(el => { el.style.visibility = on ? 'hidden' : ''; }));
    (extra || []).forEach(el => { if (el) el.style.background = on ? 'transparent' : ''; });
    const bez = $('.bezel'); if (bez) bez.style.boxShadow = on ? 'none' : '';
    document.body.classList.toggle('see-through', on);
  }
  /* cursor de toque (ver .touch-dot em system.css): ponto translúcido que segue o rato dentro do aparelho e se apaga 450 ms depois de parar */
  function touchCursor() {
    const dev = $('.device'); if (!dev || document.querySelector('.touch-dot')) return;
    const dot = document.createElement('div'); dot.className = 'touch-dot'; document.body.appendChild(dot); let t = null;
    const move = e => { dot.style.setProperty('--x', e.clientX + 'px'); dot.style.setProperty('--y', e.clientY + 'px'); dot.classList.add('on'); clearTimeout(t); t = setTimeout(() => dot.classList.remove('on'), 450); };
    dev.addEventListener('pointermove', move, { passive: true }); dev.addEventListener('pointerdown', e => { move(e); dot.classList.add('down'); }, { passive: true, capture: true });
    addEventListener('pointerup', () => dot.classList.remove('down'), true); addEventListener('pointercancel', () => dot.classList.remove('down'), true);
    dev.addEventListener('pointerleave', () => dot.classList.remove('on', 'down'));
  }
  /* posição no ecrã do jogo (Config.Offset = { right, bottom } em px) + a ZONA SEGURA do GTA
     (Definições do jogo › Ecrã › Zona segura), que o client.lua manda no `ready` como `safeZone`.
     O offset é guardado para se poder refazer quando só a zona segura muda (ou a janela). Os valores
     finais ficam presos a metade da largura / um terço da altura: um Config.Offset exagerado já não
     empurra o aparelho para fora do ecrã. */
  let lastOffset = null, safe = { x: 0, y: 0 };
  function setSafeZone(v) {
    let x = 0, y = 0;
    if (typeof v === 'number' && v >= .5 && v <= 1) { x = y = (1 - v) / 2; }                       /* GetSafeZoneSize(): 0.9 → 5 % de cada lado */
    else if (v && typeof v === 'object') { x = +v.x || 0; y = +v.y || 0; if (x > 1) x = x / (window.innerWidth || 1920); if (y > 1) y = y / (window.innerHeight || 1080); }
    safe = { x: Math.max(0, Math.min(.1, x)), y: Math.max(0, Math.min(.1, y)) };
    if (lastOffset || safe.x || safe.y) applyOffset(lastOffset || { right: 24, bottom: 16 });   /* 24/16 = os recuos do system.css */
  }
  function applyOffset(o) { if (!o) return; lastOffset = Object.assign({}, lastOffset || {}, o); const rs = document.documentElement.style; const W = window.innerWidth || 1920, H = window.innerHeight || 1080;
    if (lastOffset.right != null) rs.setProperty('--phone-right', Math.round(Math.max(0, Math.min(W * .5, (+lastOffset.right || 0) + W * safe.x))) + 'px');
    if (lastOffset.bottom != null) rs.setProperty('--phone-bottom', Math.round(Math.max(0, Math.min(H * .3, (+lastOffset.bottom || 0) + H * safe.y))) + 'px'); }
  function applyWallpaper() { wpStyle($('.wallpaper:not(.wallpaper-lock)'), state.wallpaper, state.wallpaperCustom); const lw = state.lockWallpaper; wpStyle($('.wallpaper-lock'), lw ? lw.wallpaper : state.wallpaper, lw ? lw.custom : state.wallpaperCustom); }
  /* 1.4.0: repintar os dois fundos JÁ, com o estado igual - a Meteorologia mudou de céu, um emoji acabou de ser desenhado no
     canvas, chegou a foto das Fotos aleatórias (WallKinds chama isto agrupado, 50 ms). Passa por cima do apply._wp e no fim deixa-o
     com a assinatura atual: o próximo setState (volume, brilho…) não repinta outra vez. 'wallpaper:changed' para as Definições. */
  function repaintWallpaper() {
    apply._wp = null; if (!(screen || $('#screen'))) return;
    try { applyWallpaper(); } catch (e) { console.error('[apex_phone] repaintWallpaper', e); }
    apply._wp = wpSigNow();
    try { Bridge.emit('wallpaper:changed'); } catch (e) {}
  }

  /* ---------- Status bar ---------- */
  function renderStatus() {
    const r = $('.sb-right'); if (!r) return; const w = 'fill="currentColor"'; let h = '';
    /* Android: os icones da barra (sinal, Wi-Fi, bateria Nova UI) e a zona da esquerda (icones das notificacoes e chips
       das atividades) sao do SysUI (shell/android-sysui.js). Recebe o estado e os indicadores de camara/microfone. */
    if (os === 'android' && window.SysUI && SysUI.renderStatus) { try { SysUI.renderStatus(state, ind); return; } catch (e) { console.error('[apex_phone] SysUI.renderStatus', e); } }
    /* PearPhone Fold: o estado vive no anel da barra direita (Rail.paint só refaz quando algo mudou) */
    if (form === 'fold' && window.Rail && Rail.paint) { try { Rail.paint(state, ind); } catch (e) { console.error('[apex_phone] Rail.paint', e); } }
    if (state.dnd) h += `<svg width="15" height="15" viewBox="0 0 24 24" ${w}><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/></svg>`;
    if (state.silent) h += `<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M8.7 3A6 6 0 0 1 18 8c0 2 .3 3.7.9 5M17 17H3s3-2 3-9M10.3 21a1.94 1.94 0 0 0 3.4 0M2 2l20 20"/></svg>`;
    if (state.airplane) h += `<svg width="17" height="17" viewBox="0 0 24 24" ${w}><path d="M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z"/></svg>`;
    else {
      /* sinal: 4 barras arredondadas (PearOS). eSIM (js/apps/esim.js): SIM obrigatório e nenhuma linha = "Sem SIM" no lugar das barras */
      if (window.ESim && ESim.noSim && ESim.noSim()) h += `<span class="esm-sb-nosim">${UI.esc(window.L && L.t ? L.t('Sem SIM') : 'Sem SIM')}</span>`;
      else if (state.cellular) h += `<svg width="19" height="12" viewBox="0 0 19 12" ${w}><rect x="0" y="7.5" width="3.4" height="4.5" rx="1.2"/><rect x="5.2" y="5" width="3.4" height="7" rx="1.2"/><rect x="10.4" y="2.5" width="3.4" height="9.5" rx="1.2"/><rect x="15.6" y="0" width="3.4" height="12" rx="1.2"/></svg>`;
      if (state.wifi) h += `<svg width="17" height="12" viewBox="0 0 17 12" ${w}><path d="M8.5 11.6 6.2 9.1a3.3 3.3 0 0 1 4.6 0z"/><path d="M8.5 6.4c1.6 0 3 .6 4.1 1.6l1.6-1.7A8.3 8.3 0 0 0 8.5 4a8.3 8.3 0 0 0-5.7 2.3l1.6 1.7a6 6 0 0 1 4.1-1.6z"/><path d="M8.5 1.7c2.4 0 4.6.9 6.3 2.4l1.6-1.7A11.4 11.4 0 0 0 8.5-.5C5.4-.5 2.6.7.6 2.4l1.6 1.7A9.1 9.1 0 0 1 8.5 1.7z"/></svg>`;
      if (state.hotspot) h += `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M8.5 16.4a5 5 0 0 1 7 0M5 12.9a10 10 0 0 1 14 0"/><circle cx="12" cy="20" r="1.5" fill="currentColor" stroke="none"/></svg>`;
      /* VPN: o interruptor das Definições tem de se ver em algum lado - a etiqueta "VPN" do PearOS na barra de estado */
      if (state.vpn) h += `<svg width="26" height="14" viewBox="0 0 26 14"><rect x=".6" y=".6" width="24.8" height="12.8" rx="3.4" fill="none" stroke="currentColor" stroke-width="1.2"/><text x="13" y="10.2" text-anchor="middle" font-family="Inter,-apple-system,sans-serif" font-size="8.6" font-weight="700" fill="currentColor">VPN</text></svg>`;
    }
    /* bateria (referência do utilizador): pílula CHEIA com a percentagem em negrito dentro (vermelha ≤20 %, amarela em poupança) + traço por baixo;
       sem percentagem: contorno translúcido com a carga */
    const pct = state.battPercent === true; const low = state.battery <= 20, save = state.lowPower;
    if (pct) {
      const fill = save ? '#FFD60A' : low ? '#FF453A' : 'currentColor';
      /* dígitos: nas pílulas coloridas pretos; na pílula currentColor (branca ou preta conforme a barra) brancos com mix-blend difference → ficam sempre contrastantes,
         mesmo quando a barra muda de cor sem re-render (abrir uma app clara) */
      const txt = (save || low) ? 'fill="#000"' : 'fill="#fff" style="mix-blend-mode:difference"';
      h += `<svg width="33" height="14" viewBox="0 0 33 14"><rect x=".6" y=".6" width="27.8" height="12.8" rx="4.2" fill="${fill}" stroke="currentColor" stroke-width="1.2" stroke-opacity=".95"/><path d="M29.6 4.6v4.8c1.2-.35 2-1.25 2-2.4s-.8-2.05-2-2.4z" fill="currentColor" fill-opacity=".55"/><text x="14.5" y="10.4" text-anchor="middle" font-family="Inter,-apple-system,sans-serif" font-size="10" font-weight="800" ${txt}>${state.battery}</text></svg>`;
    } else {
      /* bateria PearOS como na referência do utilizador: contorno claro, carga cheia por dentro, terminal à direita - sem número nem traço */
      const lvl = Math.max(2, Math.round(19.5 * state.battery / 100)); const col = save ? '#FFD60A' : low ? '#FF453A' : 'currentColor';
      h += `<svg width="30" height="14" viewBox="0 0 30 14"><rect x=".75" y=".75" width="23.5" height="12.5" rx="4" fill="none" stroke="currentColor" stroke-width="1.3" stroke-opacity=".95"/><rect x="2.75" y="2.75" width="${lvl}" height="8.5" rx="2.2" fill="${col}"/><path d="M26.2 4.6v4.8c1.2-.35 2-1.25 2-2.4s-.8-2.05-2-2.4z" fill="currentColor" fill-opacity=".9"/></svg>`;
    }
    /* o indicador de privacidade vive na ilha (.dot), como no PearOS; o dobrável não tem ilha (só a câmara redonda), por isso o
       ponto verde (câmara) ou laranja (microfone) vai para a barra de estado, antes dos ícones, como num tablet */
    if (form === 'fold' && (ind.cam || ind.mic)) h = `<i class="sb-priv${ind.cam ? '' : ' mic'}"></i>` + h;
    r.innerHTML = h;
  }
  /* PearPhone Fold aberto: a data curta ao lado da hora na barra de estado ("Qui 1 out"), como num tablet. Elemento próprio
     (.sb-date): o #sbTime continua só com a hora (há quem o leia). O CSS só a mostra no dobrável ABERTO e desbloqueado. */
  function sbDate(d) {
    const t = $('#sbTime'); const sb = t && t.parentElement; if (!sb) return;
    let s = sb.querySelector(':scope > .sb-date'); if (!s) { s = document.createElement('span'); s.className = 'sb-date'; t.after(s); }
    let v = ''; try { if (window.L && L.code !== 'pt' && L.intl) v = new Intl.DateTimeFormat(L.intl(), { weekday: 'short', day: 'numeric', month: 'short' }).format(d); } catch (e) {}
    if (!v) v = UI.DIAS_C[d.getDay()] + ' ' + d.getDate() + ' ' + UI.MESES[d.getMonth()].slice(0, 3);
    if (s.textContent !== v) s.textContent = v;
  }
  function updateSbTheme() { let light = false; if (current && !locked) { const def = App.get(current) || {}; light = def.statusBar === 'dark' ? false : def.statusBar === 'light' ? true : !state.dark; }
    /* 1.5.0 (Liquid Glass, tom automático): sem app aberta a barra segue o TOPO do wallpaper medido pelo glass.js (#screen.wp-top-light na
       home, wpl-top-light no bloqueado); por cima das camadas escuras (Centro de controlo, notificações, alternador, pesquisa, código) o
       glass27.css volta a pô-la branca. Só no PearOS (o Android tem o SysUI) e fora do assistente inicial (que põe a classe ele próprio). */
    else if (os !== 'android' && screen && !screen.classList.contains('setup-mode')) light = screen.classList.contains(locked ? 'wpl-top-light' : 'wp-top-light');
    if (screen.classList.contains('light-sb') !== light) { screen.classList.toggle('light-sb', light); renderStatus(); }
    if (form === 'fold' && window.Rail && Rail.sync) { try { Rail.sync(); } catch (e) { console.error('[apex_phone] Rail.sync', e); } } }   /* barra direita: o tom segue o da app (só refaz o que mudou) */
  function indicator(kind, on) { ind[kind] = !!on; renderStatus(); const isl = $('.island'); if (isl) { isl.classList.toggle('rec-cam', ind.cam); isl.classList.toggle('rec-mic', ind.mic && !ind.cam); } }
  /* TELEMÓVEL GUARDADO = SÓ A LÓGICA. Com o aparelho no bolso (body.hidden, sem espreitar) ninguém
     vê a hora, os ponteiros nem os widgets: eram 4 varrimentos do documento por segundo e um
     re-render dos widgets por minuto, para sempre. Continuam a correr o tema automático, o bloqueio
     por inatividade e a ilha (decide se está ocupada - o Notify pergunta-lhe). `wake` = vai ficar
     visível já a seguir (abrir / espreitar): repinta tudo SEM animação, antes de o ecrã aparecer. */
  let tickStale = false;   /* passou um minuto com o telemóvel guardado → os widgets estão por refazer */
  /* BLOQUEIO AUTOMÁTICO TAMBÉM COM UMA APP ABERTA (antes só bloqueava na home, e com qualquer app
     aberta nunca bloqueava). Como no PearOS, há exceções que mantêm o ecrã aceso: uma chamada em curso,
     a câmara / Face Key a usar o visor (buraco até ao jogo) e as apps que declaram `keepAwake`
     (true ou função) no App.define - por exemplo um leitor de vídeo ou a navegação. */
  function keepAwake() {
    try { if (window.PhoneApp && PhoneApp.current) return true; } catch (e) {}
    if (document.body.classList.contains('see-through')) return true;
    if (!current) return false;
    const def = App.get(current) || {};
    if (current === 'camera') return true;
    try { return typeof def.keepAwake === 'function' ? !!def.keepAwake() : !!def.keepAwake; } catch (e) { return false; }
  }
  function tick(wake) {
    const d = new Date();
    if (d.getSeconds() === 0 && state.theme === 'auto') apply();
    if (window.Island) Island.tick(d);
    if (!locked && state.autoLock !== 'Nunca' && ready) { const m = { '30 segundos': .5, '1 minuto': 1, '2 minutos': 2, '5 minutos': 5, '10 minutos': 10 }[state.autoLock] || 2; if (Date.now() - lastTouch > m * 60000 && !keepAwake()) { lastTouch = Date.now();
      /* guardado no bolso (body.hidden) não há ecrã para apagar: bloqueia em silêncio (o Hardware.sleep tocava o clique de bloquear) */
      if (Bridge.inFiveM && document.body.classList.contains('hidden')) Lock.lock(true); else if (window.Hardware && Hardware.inited) Hardware.sleep(); else Lock.lock(); } }   /* inatividade: apaga o ecrã (Always-On) como o PearOS, não só bloqueia */
    const bc = document.body.classList;
    if (!wake && Bridge.inFiveM && bc.contains('hidden') && !bc.contains('pk')) { if (d.getSeconds() === 0) tickStale = true; return; }
    const hm = UI.fmtTime(d); const t = $('#sbTime'); if (t && t.textContent !== hm) t.textContent = hm;
    if (form === 'fold' && os !== 'android' && window.Rail && Rail.tick) Rail.tick(d);   /* a hora da barra direita (só escreve quando muda) */
    /* ao acordar o relógio do lock é redesenhado direto (force): o "rolar" dos dígitos dos minutos que passaram no bolso nunca foi visto */
    if (window.Lock) Lock.tick(d, !!wake); Icons.tickClocks();
    if (window.Widgets) { if (tickStale) { tickStale = false; const h = $('#home'); if (h) Widgets.refresh(h); } Widgets.tick(d); }
  }

  /* ---------- Apps instaladas ---------- */
  /* 1.5.0: Fitness, Diário, Dicas, Bolsa, Tradutor e Gravador vêm instaladas de origem (são apps de sistema, como no PearPhone); as contas
     que já tinham `state.installed` gravado não as recebem sozinhas: aparecem na AppShop / NOVA Store para instalar */
  const OPTIONAL_DEFAULT = ['services', 'billing', 'facetime', 'reminders', 'garage', 'findmy', 'fitness', 'journal', 'tips', 'stocks', 'translate', 'voicememos'] /* redes sociais, Match, Marketplace e Dark Chat instalam-se pela AppShop (como num PearPhone novo); Encontrar vem de origem, como no PearPhone */;
  /* Apps desligadas no painel admin (GlobalState 'apex_phone:settings'.disabledApps, push 'admin:settings' do client/overlay.lua): saem da
     home, da pesquisa e da AppShop para toda a gente e não abrem (nem por uma notificação). Definições, Telefone e AppShop nunca se desligam. */
  const adminOff = new Set(), adminHid = new Set();
  function setAdminDisabled(list) {
    const want = new Set((Array.isArray(list) ? list : []).filter(id => typeof id === 'string' && id !== 'settings' && id !== 'phone' && id !== 'store'));
    let changed = false;
    adminOff.forEach(id => { if (!want.has(id)) { adminOff.delete(id); const d = App.get(id); if (d && adminHid.has(id)) { d.hidden = false; adminHid.delete(id); } changed = true; } });
    want.forEach(id => { if (adminOff.has(id)) return; adminOff.add(id); changed = true; const d = App.get(id); if (d && !d.hidden && !d.external && id.indexOf('capp_') !== 0) { d.hidden = true; adminHid.add(id); } try { killApp(id); } catch (e) {} if (window.Home && Home.removeApp && ready) Home.removeApp(id); });
    if (changed && ready) Bridge.emit('apps:changed');
  }
  const adminDisabled = id => adminOff.has(id);
  /* uma app que se regista DEPOIS da lista chegar (apps de outros ficheiros, carregadas mais tarde) também fica escondida */
  Bridge.on('app:defined', id => { if (!adminOff.has(id)) return; const d = App.get(id); if (d && !d.hidden && !d.external && String(id).indexOf('capp_') !== 0) { d.hidden = true; adminHid.add(id); } });
  function installed() { const all = App.ids(); const list = state.installed || OPTIONAL_DEFAULT; return all.filter(id => { if (adminOff.has(id)) return false; const d = App.get(id); return d.core || list.includes(id) || (d.external && d.defaultInstalled && !(state.uninstalled || []).includes(id)); }); }
  function isInstalled(id) { return installed().includes(id); }
  async function install(id) { const l = (state.installed || OPTIONAL_DEFAULT.slice()); if (!l.includes(id)) l.push(id); const un = (state.uninstalled || []).filter(x => x !== id); setState({ installed: l, uninstalled: un }); await Bridge.rpc('apps.install', { id }); Home.addApp(id); Bridge.emit('apps:changed'); }
  async function uninstall(id) { const d = App.get(id); if (!d || d.core) return false; const l = (state.installed || OPTIONAL_DEFAULT.slice()).filter(x => x !== id); const un = (state.uninstalled || []).slice(); if (d.external && !un.includes(id)) un.push(id); setState({ installed: l, uninstalled: un }); killApp(id); Home.removeApp(id); await Bridge.rpc('apps.uninstall', { id }); Bridge.emit('apps:changed'); return true; }

  /* ---------- Janelas de app (multitasking) ---------- */
  function openApp(id, fromEl, opts = {}) {
    const def = App.get(id);
    if (!def) { UI.alert({ title: id, msg: 'Esta app não está instalada.' }); return; }
    if (adminOff.has(id)) { UI.alert({ title: App.name(id), msg: 'Esta app foi desativada pelo servidor.' }); return; }
    if (locked && !opts.allowLocked) { Lock.requestUnlock(() => openApp(id, null, opts)); return; }
    /* 1.1.7: { soft: true } - uma permissão RECUSADA já não impede a app de abrir (era o "toco no Instashot e não acontece
       nada" depois de um "Não permitir" gravado na conta); só cancelar o diálogo devolve false. Ver shell/permissions.js. */
    if (window.Perm && def.needs && !opts._perm) { Perm.request(id, def.needs, { soft: true }).then(ok => { if (ok) openApp(id, fromEl, Object.assign({}, opts, { _perm: true })); }); return; }
    if (current === id) return;
    if (current) hideCurrent();
    /* nasce do ícone (página atual / dock / cartão do switcher): translate+scale com origem no centro - a mesma geometria que o gesto e o fecho usam.
       PERFUI (2026-10-05): o retângulo do ícone mede-se ANTES de construir a app. Medido depois, o getBoundingClientRect obrigava o
       Chromium a fazer ali, a meio do toque, o layout de toda a vista acabada de construir (20-60 ms com o CPU a 1/4); antes da
       construção a home está limpa e a leitura é quase grátis. O ícone não mexe com a construção da app: o valor é o mesmo. */
    fromEl = fromEl || (!windows[id] || opts.fromHome ? tileOf(id) : null);
    const from = fromEl && fromEl.getBoundingClientRect ? rectOf(fromEl) : null;
    let win = windows[id], created = false;
    if (!win) {
      win = UI.el(`<div class="app-window ${def.external ? 'external' : ''}" data-app="${UI.esc(id)}"><div class="nav-stack"></div></div>`); win.timers = []; win.appId = id;
      apps.appendChild(win); windows[id] = win; created = true;
      const t0 = performance.now(); try { def.open(win); } catch (e) { console.error('[apex_phone] erro ao abrir', id, e); }
      /* diagnóstico de fluidez: uma app que demore >120 ms a construir a primeira vista fica registada na consola F8 (console.error → Bridge jsError) */
      const ms = performance.now() - t0; if (ms > 120) console.error(`[apex_phone] perf: "${id}" demorou ${ms.toFixed(0)} ms a construir a vista (${win.querySelectorAll('*').length} nós)`);
    } else { win.classList.remove('bg'); try { def.resume && def.resume(win); } catch (e) { console.error(e); } }
    const i = recents.indexOf(id); if (i > -1) recents.splice(i, 1); recents.unshift(id);
    if (recents.length > 7) { const lru = recents[recents.length - 1]; if (lru !== id) killApp(lru); }
    /* recentApps (Fase 1): histórico persistente para a Biblioteca de Apps e a pesquisa. Não vale um
       account.update por cada app aberta - vai com o próximo save. Nem um persistSoon: o `state` leva os fundos em
       base64 e a escrita síncrona caía 250 ms depois do toque, a meio da animação de abrir. Fica marcado e sai na
       próxima escrita (outra definição, guardar o telemóvel, sair da página). */
    { const ra = (state.recentApps || []).filter(x => x !== id); ra.unshift(id); state.recentApps = ra.slice(0, 12); lazyDirty = true; }
    lastTouch = Date.now();   /* abrir uma app é atividade (o bloqueio automático agora também conta com apps abertas) */
    win.style.transformOrigin = '50% 50%'; win.style.borderRadius = '';
    /* Reduzir movimento: sem crescer do ícone - a janela aparece no sítio e só a opacidade anima */
    if (state.reduceMotion) win.style.transform = '';
    else if (from) { win.style.transform = toTransform(from); if (fromEl.classList && fromEl.classList.contains('tile')) { fromEl.classList.add('launch'); setTimeout(() => fromEl.classList.remove('launch'), 520); } }
    else win.style.transform = 'scale(.9)';
    /* a classe também no <body>: o `.bezel` (o preto entre a moldura e o ecrã) é ANTEPASSADO do #screen e o CEF não tem :has(),
       por isso só a partir do body se lhe pode tirar o preto - senão a Câmara mostrava um retângulo preto em vez do mundo */
    current = id; screen.classList.add('app-open'); screen.classList.toggle('camera-mode', id === 'camera'); document.body.classList.toggle('camera-mode', id === 'camera'); updateSbTheme();
    win.classList.remove('open', 'closing'); requestAnimationFrame(() => requestAnimationFrame(() => { win.classList.add('open'); if (!win.classList.contains('dragging')) { win.style.transform = ''; win.style.transformOrigin = ''; } }));   /* não pisar um arrasto já em curso */
    if (window.Home) Home.closeFolder(); Sound.play('swoosh'); Bridge.emit('app:open', id); useStart(id); Bridge.dbg('app', 'open', id);
    unrotateIf();
  }
  function hideCurrent() { const id = current; const win = windows[id]; if (!win) { current = null; return; } const def = App.get(id) || {}; try { def.pause && def.pause(win); } catch (e) {} win.classList.remove('open', 'closing'); win.classList.add('bg'); win.style.transform = ''; current = null; useStop(); Bridge.emit('app:close', id); }
  /* ---------- geometria ícone ⇄ janela (px do ecrã SW×956, origem no centro da janela; SW = 440, ou 670 / 1340 no dobrável) ---------- */
  /* o id entra num seletor: com aspas ou "]" o querySelector rebentava (SyntaxError) - mesmo escape do notify.js:353 */
  const cssId = id => (window.CSS && CSS.escape) ? CSS.escape(String(id)) : String(id).replace(/[^\w-]/g, '\\$&');
  /* páginas À VISTA e dock: no telemóvel e no dobrável fechado uma página, no dobrável aberto a da esquerda e a da direita
     (Home.view). A dock pode estar em baixo ou na barra direita do PearPhone Fold (é o mesmo elemento .dock). Nunca um ícone
     escondido (Biblioteca fechada, página por trás da barra), que dava o zoom a nascer do sítio errado */
  const tileOf = id => { const q = cssId(id);
    const pgs = document.querySelectorAll('#home .pages .page'), view = window.Home ? (Home.view || [Home.page]) : [0];
    for (const p of view) { const pg = pgs[p]; const t = pg && pg.querySelector(`.hi[data-id="${q}"] .tile`); if (t) return t; }
    return document.querySelector(`#home .dock .hi[data-id="${q}"] .tile`) || null; };
  /* rect de um elemento em px do ecrã, descontando a escala que o #home tem nesse instante (1.14 com uma app aberta / a seguir o dedo): o alvo é a posição de repouso do ícone.
     Dobrável aberto (janela deitada, 1340×956): a caixa alarga à volta do centro até a janela, à escala dela, ter a ALTURA do
     ícone (só pela largura ficava uma tira mais baixa do que o ícone); no telemóvel e fechado nada muda */
  function rectOf(elm) {
    const W = SW(), CX = W / 2;
    const s = screen.getBoundingClientRect(); if (!s.width) return null; const k = s.width / W; const r = elm.getBoundingClientRect(); if (!r.width) return null;
    let x = (r.left - s.left) / k, y = (r.top - s.top) / k, w = r.width / k, h = r.height / k;
    const home = elm.closest && elm.closest('#home'); if (home) { let sc = 1; try { const m = getComputedStyle(home).transform; if (m && m !== 'none') sc = new DOMMatrix(m).a || 1; } catch (e) {} if (sc && sc !== 1) { const cx = x + w / 2, cy = y + h / 2; w /= sc; h /= sc; x = CX + (cx - CX) / sc - w / 2; y = 478 + (cy - 478) / sc - h / 2; } }
    if (form === 'fold' && h * W / 956 > w) { const cx = x + w / 2; w = h * W / 956; x = cx - w / 2; }
    return { x, y, w, h };
  }
  const toTransform = r => `translate(${(r.x + r.w / 2 - SW() / 2).toFixed(1)}px,${(r.y + r.h / 2 - 478).toFixed(1)}px) scale(${(r.w / SW()).toFixed(4)})`;
  /* transform da janela a caminho do ícone (t=0 janela inteira … t=1 em cima do ícone) - usado pelo harness/debug */
  function shrinkTransform(id, t = 1) { const tile = tileOf(id); const r = tile && rectOf(tile); if (!r) return `translate(0,${120 * t}px) scale(${1 - .8 * t})`; const W = SW(); const tx = (r.x + r.w / 2 - W / 2) * t, ty = (r.y + r.h / 2 - 478) * t, s = 1 - (1 - r.w / W) * t; return `translate(${tx.toFixed(1)}px,${ty.toFixed(1)}px) scale(${s.toFixed(4)})`; }
  /* fecho: a janela encolhe até ao ícone (se estiver visível) e desvanece no fim - o ícone "recebe-a" com um pequeno pop */
  function shrinkTo(win, id) {
    const t = tileOf(id); const r = t && rectOf(t); win.style.transformOrigin = '50% 50%';
    if (r) { win.style.transform = toTransform(r); t.classList.remove('land'); void t.offsetWidth; t.classList.add('land'); setTimeout(() => t.classList.remove('land'), 600); }
    else win.style.transform = 'translate(0,120px) scale(.2)';
  }
  function closeApp(instant) {
    if (!current) return; const id = current, win = windows[id], def = App.get(id) || {};
    current = null; useStop(); unrotateIf(); try { def.pause && def.pause(win); } catch (e) {}
    if (def.killOnClose) { (screen.classList.remove('app-open', 'camera-mode'), document.body.classList.remove('camera-mode')); updateSbTheme(); killApp(id); return; }
    if (instant) { (screen.classList.remove('app-open', 'camera-mode'), document.body.classList.remove('camera-mode')); updateSbTheme(); win.classList.remove('open', 'closing', 'dragging', 'settle'); win.classList.add('bg'); win.style.transform = ''; win.style.transformOrigin = ''; }
    else {
      win.classList.remove('open', 'dragging', 'settle'); win.classList.add('closing'); if (state.reduceMotion) { win.style.transform = ''; } else shrinkTo(win, id);           /* alvo calculado com o #home ainda na escala atual; a reduzir movimento só desvanece */
      (screen.classList.remove('app-open', 'camera-mode'), document.body.classList.remove('camera-mode')); updateSbTheme();
      clearTimeout(win._closeT); win._closeT = setTimeout(() => { if (win.classList.contains('closing')) { win.classList.remove('closing'); win.classList.add('bg'); win.style.transform = ''; win.style.transformOrigin = ''; } }, 520);
    }
    lastTouch = Date.now(); Bridge.emit('app:close', id); Bridge.dbg('app', 'close', id);
  }
  /* ⚠️ matar a app corre também o `onPop` das vistas que ainda estão na pilha (as que já estão a
     sair com `.leave` já o correram no UI.pop). É lá que as apps largam ouvintes GLOBAIS do Bridge
     (Dark Chat, DMs do Instashot), observers e polls: sem isto ficavam vivos para sempre a segurar
     a janela morta - o LRU das 7 apps e o switcher matam janelas a toda a hora. */
  function killApp(id) { const win = windows[id]; if (!win) return;
    win.querySelectorAll('.nav-stack > .view:not(.leave)').forEach(v => { try { v.opts && v.opts.onPop && v.opts.onPop(); } catch (e) { console.error('[apex_phone] onPop', e); } });
    (win.timers || []).forEach(t => { clearInterval(t); clearTimeout(t); }); try { win.onClose && win.onClose(); } catch (e) {} win.remove(); delete windows[id]; const i = recents.indexOf(id); if (i > -1) recents.splice(i, 1); if (current === id) { current = null; (screen.classList.remove('app-open', 'camera-mode'), document.body.classList.remove('camera-mode')); updateSbTheme(); } if (id === rotApp) rotate(false); Bridge.emit('app:kill', id); }
  const currentApp = () => current;

  /* ---------- PAISAGEM: deitar o telemóvel (2026-09-19, pedido do utilizador: fotos ao baixo e jogar de lado) ----------
     O APARELHO INTEIRO roda -90° por CSS (.device.landscape: a ilha fica à esquerda, o obturador à direita - como no iPhone).
     O que cada app faz com isso vem do App.define:
       landscape: true    → a janela roda ao contrário e passa a 956×440 (.app-window.ls): a app fica direita e larga (jogos, Surf, Fotos)
       landscape: 'hold'  → a janela fica como está, deitada com o aparelho (Câmara: o visor é que roda o frame do jogo - camview.js)
       (sem nada)         → não roda ("Esta app não roda"), como um iPhone numa app só de retrato
     Volta sozinho ao retrato ao trocar de app, fechar, bloquear ou abrir o switcher. Evento: Bridge 'rotate' { on, app }. */
  let landscape = false, rotApp = null;
  function rotate(on) {
    on = !!on;
    if (on && !current) { UI.toast('Abre uma app para deitar o telemóvel'); return false; }
    const def = on ? (App.get(current) || {}) : null;
    if (on && !def.landscape) { UI.toast('Esta app não roda'); return false; }
    /* o dobrável não se deita: aberto já tem o ecrã largo; fechado, abre-se para o ter */
    if (on && form === 'fold') { UI.toast(foldOpen ? 'Com o telemóvel aberto o ecrã já é largo' : 'Abre o telemóvel para teres o ecrã largo'); return false; }
    if (on === landscape) return true;
    landscape = on; rotApp = on ? current : null;
    document.body.classList.toggle('landscape', on);
    const d = $('.device'); if (d) d.classList.toggle('landscape', on);
    Object.keys(windows).forEach(k => windows[k].classList.remove('ls'));
    if (on && def.landscape !== 'hold' && windows[current]) windows[current].classList.add('ls');
    Bridge.emit('rotate', { on, app: rotApp });
    return true;
  }
  const unrotateIf = () => { if (landscape && (!current || current !== rotApp)) rotate(false); };

  /* o badge vive FORA do tile (que tem overflow:hidden para a máscara do ícone) - como no PearOS, sobressai do canto */
  /* Definições › Notificações › (app) › Emblemas: desligado (ou a app sem notificações) não mostra o número. O valor
     real continua guardado em Home.badges, para voltar a aparecer logo que se ligue (ver o Bridge.on('state') abaixo). */
  const badgeOn = id => { try { const c = window.Notify && Notify.appSettings ? Notify.appSettings(id) : Object.assign({ allow: !(state.notif && state.notif[id] === false) }, (state.notifApps || {})[id] || {}); return c.badge !== false && c.allow !== false; } catch (e) { return true; } };
  Bridge.on('state', p => { if (p && ('notifApps' in p || 'notif' in p) && window.Home && Home.badges) Object.keys(Home.badges).forEach(id => badge(id, Home.badges[id])); });
  function badge(id, n) { const raw = n; if (n && !badgeOn(id)) n = 0; document.querySelectorAll(`.hi[data-id="${cssId(id)}"]`).forEach(h => { h.querySelectorAll('.tile .badge').forEach(x => x.remove()); let b = h.querySelector(':scope > .badge'); if (!n) { b && b.remove(); return; } if (!b) { b = UI.el('<div class="badge"></div>'); h.appendChild(b); } b.textContent = n > 99 ? '99+' : n; }); if (window.Home) Home.badges[id] = raw || 0; }
  function torch(on) { state.torch = !!on; persistSoon(); const g = $('.torch-glow'); if (g) g.classList.toggle('on', !!on); Bridge.call('flashlight', { on: !!on }); Bridge.emit('torch', !!on); }
  function notify(o) { return window.Notify ? Notify.push(o) : UI.banner(o); }
  function setPlayer(p) { if (!p) return;
    /* STOLEN: telemóvel de outra pessoa (account.foreign): o push `player` traz o número de quem o tem na mão, mas o "eu" das
       Mensagens/Zapp é o número da conta aberta (o do dono) */
    if (account && account.foreign && account.phone && p.phone !== account.phone) p = Object.assign({}, p, { phone: account.phone });
    const j = JSON.stringify(p); if (j === setPlayer._last) return; setPlayer._last = j;   /* igual ao anterior: nada a fazer (o Lua também deduplica) */
    player = Object.assign(player || {}, p); clearTimeout(setPlayer._t);
    /* só se grava na personagem certa: o push `player` da personagem nova pode chegar ANTES do `session`,
       e sem esta guarda os dados dela iam parar ao espaço (Store) da anterior */
    /* Sem espaço ainda (primeiro arranque com namespaces) também não se grava uma personagem com citizenid: a chave
       antiga `player` na raiz é o que o Store.setNamespace usa para saber DE QUEM são as chaves antigas, e escrevê-la
       aqui (400 ms, antes de o account.get responder) dava as notas de outra personagem a quem entrasse. O boot grava-o. */
    setPlayer._t = setTimeout(() => { const ns = Store.namespace; if (ns ? (!player.citizenid || player.citizenid === ns) : !player.citizenid) Store.set('player', player); }, 400);
    Bridge.emit('player:update', player);
    /* arranque sem personagem (multicharacter): o primeiro `player` com citizenid serve de sessão se o `session` não vier */
    if (waitingSession && p.citizenid) switchCharacter(p.citizenid); }

  /* nome do dispositivo (Fase 1): o que o jogador escolheu ou "PearPhone de <username>" */
  /* um nome que comece pelo modelo de fabrica (de qualquer aparelho) foi o nome por omissao: acompanha o aparelho em uso.
     Quem configurou no PearPhone e passa para o S26 ve "NOVA S26 Ultra de X", nao "PearPhone de X"; um nome escolhido fica. */
  function defaultModels() { const l = ['PearPhone 18 Pro Max', 'PearPhone 18 Pro', 'PearPhone 18', 'PearPhone Fold', 'PearPhone', OS_DEFAULT.android.model, 'NOVA Fold8', 'NOVA Flip'];
    const c = config.android && typeof config.android.model === 'string' ? config.android.model.trim() : ''; if (c && !l.includes(c)) l.push(c);
    if (deviceModel && !l.includes(deviceModel)) l.push(deviceModel);
    return l.sort((a, b) => b.length - a.length); }
  /* modelo do APARELHO em uso (Config.Devices[item].model, vem no ready/open/frame): "PearPhone Fold", "NOVA Fold8"...
     null = o modelo de origem do sistema (PearPhone 18 Pro Max / Config.Android.model) */
  let deviceModel = null;
  const setDeviceModel = v => { deviceModel = typeof v === 'string' && v.trim() ? v.trim().slice(0, 40) : null; };
  /* o nome curto do PearOS e "PearPhone" (o 18 Pro Max), ou o modelo do aparelho quando e outro (PearPhone Fold) */
  function deviceName() { const m = os === 'android' ? osInfo().model : (deviceModel || 'PearPhone'); const n = String(state.deviceName || '').trim();
    if (n) { for (const d of defaultModels()) { if (n === d) return m; if (n.startsWith(d + ' de ')) return m + n.slice(d.length); } return n; }
    const u = (account && account.username) || player.firstname || ''; if (!u) return m;
    /* o nome de origem na língua do jogador: "NOVA Fold8 de tester" só em português; em inglês "tester's NOVA Fold8" */
    const lc = window.L && L.code; if (lc && lc !== 'pt') return lc === 'en' ? u + "'s " + m : m + ' (' + u + ')';
    return m + ' de ' + u; }
  /* numero de serie e IMEI como os do aparelho em uso, sempre os mesmos para a mesma conta: o device_id da conta e do
     formato PearPhone (IP18PM-123456); no S26 vira um numero de serie ao estilo do fabricante (R5CY + 7) e um IMEI valido */
  function devHash(salt) { const id = String((account && account.device_id) || (player && player.citizenid) || 'DEV0000') + salt; let h = 2166136261;
    for (let i = 0; i < id.length; i++) { h ^= id.charCodeAt(i); h = Math.imul(h, 16777619) >>> 0; } return h; }
  function serial() { const id = account && account.device_id;
    if (os !== 'android') return id || 'RK' + String((player && player.citizenid) || 'DEV0000').slice(-6).toUpperCase();
    const A = '0123456789ABCDEFGHJKLMNPRSTVWXYZ'; let h = devHash('sn'), h2 = devHash('sn2'), s = 'R5CY';
    for (let i = 0; i < 7; i++) { const src = i < 4 ? h : h2; s += A[(src >>> ((i % 4) * 5)) & 31]; } return s; }
  function imei() { const h = devHash('imei'), h2 = devHash('imei2'); let d = '35' + String(h % 1000000).padStart(6, '0') + String(h2 % 1000000).padStart(6, '0');
    let sum = 0; for (let i = 0; i < 14; i++) { let x = +d[i]; if (i % 2 === 1) { x *= 2; if (x > 9) x -= 9; } sum += x; } return d + ((10 - sum % 10) % 10); }

  /* ---------- SISTEMA OPERATIVO DO APARELHO (2026-10-01) ----------
     O ITEM usado decide o sistema: os PearPhone 18 sao 'ios', os S26 sao 'android' (Config.Devices[item].os, client/main.lua
     manda-o no ready/open/frame). As apps, a conta, o numero e o servidor sao OS MESMOS nos dois: so muda o aspeto e o
     comportamento do sistema (barra de estado, navegacao, ecra bloqueado, painel rapido, gaveta de apps...). E por isso que
     um jogador com iPhone fala com outro com Android sem nada de especial.
     body.os-android / body[data-os] e .device.os-android para o CSS; Bridge 'os:changed' { from, to } para os modulos. */
  const OS_LIST = ['ios', 'android'];
  let os = 'ios';
  const OS_DEFAULT = {
    ios: { os: 'ios', brand: 'Pear', model: 'PearPhone 18 Pro Max', osName: 'PearOS', osVersion: '27.2', store: 'AppShop' },   /* 27.2 = a versão do sistema real em nov 2026 (ronda 2) */
    android: { os: 'android', brand: 'NOVA', model: 'NOVA S26 Ultra', osName: 'Nova UI', osVersion: '9', store: 'NOVA Store' },
  };
  function osInfo() { const base = OS_DEFAULT[os] || OS_DEFAULT.ios; const c = os === 'android' && config.android && typeof config.android === 'object' ? config.android : {};
    const s = (v, d) => (typeof v === 'string' && v.trim()) ? v.trim().slice(0, 40) : d;
    return { os, form, brand: s(c.brand, base.brand), model: s(deviceModel, s(c.model, base.model)), osName: s(c.osName, base.osName), osVersion: s(c.osVersion, base.osVersion), store: s(c.store, base.store) }; }
  const isAndroid = () => os === 'android';
  function setOS(v, opts = {}) {
    const next = OS_LIST.includes(v) ? v : 'ios';
    const first = !document.body.dataset.os;
    document.body.dataset.os = next; document.body.classList.toggle('os-android', next === 'android'); document.body.classList.toggle('os-ios', next !== 'android');
    const d = $('.device'); if (d) { d.classList.toggle('os-android', next === 'android'); d.classList.toggle('os-ios', next !== 'android'); }
    if (next === os && !first) return false;
    foldStop();   /* um dobrável a meio de abrir/fechar acaba já: o desenho da moldura e do ecrã vai mudar todo */
    const from = os; os = next;
    /* trocar de sistema com o telemovel a correr: tudo o que e passageiro fecha, as janelas abertas morrem (os titulos e os
       nomes das apps mudam) e os ecras do sistema voltam a desenhar-se ja no aspeto novo */
    if (!first && !opts.quiet) {
      try { if (window.UI && UI.dismissAll) UI.dismissAll(); } catch (e) {}
      ['Notify', 'CC', 'Switcher', 'Vera', 'Keyboard', 'LockGallery', 'QuickPanel', 'Drawer', 'EdgePanel'].forEach(m => { try { window[m] && window[m].close && window[m].close(); } catch (e) {} });
      try { if (window.Home && Home.closeFolder) Home.closeFolder(); if (window.Home && Home.closeSpot) Home.closeSpot(); if (window.Home && Home.closeSearch) Home.closeSearch(true); } catch (e) {}
      if (landscape) { try { rotate(false); } catch (e) {} }
      Object.keys(windows).forEach(k => { try { killApp(k); } catch (e) {} });
    }
    try { if (window.Icons && Icons.clearTiles) Icons.clearTiles(); } catch (e) {}
    frameRing();
    apply._wp = null;
    if (screen) { try { apply(); } catch (e) { console.error('[apex_phone] apply (os)', e); } }
    Bridge.emit('os:changed', { from, to: next });
    try { if (window.Home && Home.render && ready) Home.render(); } catch (e) { console.error('[apex_phone] Home.render (os)', e); }
    Bridge.emit('apps:changed');
    Bridge.dbg('os', from, '→', next);
    return true;
  }

  /* ---------- ROUTER phone:// (deep links) ----------
     System.openURL('phone://messages/thread/555-0101?x=1') abre a app (pede o código se estiver bloqueado,
     passa pelas permissões da app) e, já com a janela aberta, entrega { app, path, parts, query, url } aos
     handlers de System.route(app, fn) e ao evento Bridge 'deeplink'. Tudo o que vem de fora (Lua,
     notificações, iframes) passa por aqui validado: id de app como no App.define, caminho curto. */
  const routes = {};
  function route(app, fn) { if (typeof fn !== 'function') return () => {}; const id = String(app || ''); (routes[id] = routes[id] || []).push(fn); return () => { const l = routes[id]; const i = l ? l.indexOf(fn) : -1; if (i > -1) l.splice(i, 1); }; }
  function parseURL(url) {
    const s = String(url == null ? '' : url).trim(); if (!s || s.length > 512) return null;
    const m = /^phone:\/\/([A-Za-z0-9_-]{1,40})(\/[^?#]*)?(?:\?([^#]*))?/.exec(s); if (!m) return null;
    const dec = x => { try { return decodeURIComponent(x); } catch (e) { return x; } };
    const parts = (m[2] || '').split('/').filter(Boolean).slice(0, 12).map(p => dec(p).slice(0, 128));
    const query = {}; (m[3] || '').split('&').filter(Boolean).slice(0, 20).forEach(kv => { const i = kv.indexOf('='); const k = dec(i < 0 ? kv : kv.slice(0, i)).slice(0, 40); if (k) query[k] = dec(i < 0 ? '' : kv.slice(i + 1)).slice(0, 256); });
    return { app: m[1], path: parts.join('/'), parts, query, url: s };
  }
  let urlSeq = 0;
  function openURL(url, opts = {}) {
    const u = parseURL(url); if (!u) { Bridge.dbg('router', 'url inválido', url); return false; }
    /* sem telemóvel arrancado (assistente a correr, à espera da personagem, a trocar de personagem) não há onde abrir:
       o Lua pode mandar o link a qualquer momento e sem isto pedia o código por cima do assistente */
    if (!ready || !account) { Bridge.dbg('router', 'ignorado: telemóvel não arrancou', u.url); return false; }
    /* instalada de facto (as apps escondidas, que não entram na lista, podem abrir-se por link) - o Bridge 'openApp' antigo não verificava */
    const def = App.get(u.app);
    if (!def || (!def.hidden && !isInstalled(u.app))) { UI.alert({ title: def ? App.name(u.app) : u.app, msg: 'Esta app não está instalada.' }); return false; }
    const my = ++urlSeq;   /* dois links seguidos: só o último é entregue */
    const deliver = () => { if (my !== urlSeq || current !== u.app) return; const d = { app: u.app, path: u.path, parts: u.parts.slice(), query: Object.assign({}, u.query), url: u.url };
      (routes[u.app] || []).slice().forEach(fn => { try { fn(d); } catch (e) { console.error('[apex_phone] route', u.app, e); } }); Bridge.emit('deeplink', d); Bridge.dbg('router', 'deeplink', d.url); };
    const go = () => {
      if (my !== urlSeq) return;
      /* setTimeout e não requestAnimationFrame: com o telemóvel guardado (o Lua pode mandar o link com ele
         fechado) ou sem frames a pintar, o rAF não corre e o link perdia-se. A janela já está construída. */
      if (current === u.app) { setTimeout(deliver, 0); return; }
      /* o openApp pode ficar à espera da folha de permissões: entrega-se quando a janela abrir de facto (ou nunca, se recusar) */
      let t = null; const off = Bridge.on('app:open', id => { if (id !== u.app) return; off(); clearTimeout(t); setTimeout(deliver, 0); });
      t = setTimeout(off, 30000);
      openApp(u.app, null, Object.assign({}, opts, { fromHome: false }));
    };
    if (locked && !opts.allowLocked) { if (window.Lock && Lock.requestUnlock) Lock.requestUnlock(go); return true; }
    go(); return true;
  }

  /* ---------- PERSONAGEM (multicharacter) ----------
     O push `session { citizenid }` chega quando uma personagem carrega. Se for OUTRA: guarda o que era
     da anterior, cancela os saves pendentes dela (um account.update atrasado ia escrever as definições
     da anterior na conta nova), mata as janelas, muda o Store para o espaço da nova, repõe o estado por
     omissão e volta a pedir a conta → arranque normal ou assistente. É o corpo do factoryReset, SEM
     apagar nada (nem no servidor nem no localStorage). */
  /* retryCid: personagem conhecida cujo account.get não teve resposta - abrir o telemóvel volta a tentar */
  let sessionCid = null, waitingSession = false, initDone = false, pendingSession = null, switching = null, switchSeq = 0, retryCid = null;
  /* ---------- SERVIDOR SEM RESPOSTA (2026-09-20) ----------
     Se o `account.get` falha (BD ainda a subir depois de um `ensure`, erro no servidor, limite de pedidos), o arranque punha
     `waitingSession` e ficava à espera de um push - o ecrã ficava VAZIO (só fundo e barra de estado), sem explicação e sem
     voltar a tentar. Queixa in-game de 2026-09-20: "reiniciei o resource e não aparece nada."
     Agora: volta a tentar sozinho (5 s, 8 s, 12 s… até 30 s) e mostra uma folha a dizer o que se passa, com "Tentar agora".
     ⚠️ Só quando houve ERRO. Sem personagem escolhida (multicharacter) a espera continua silenciosa: é normal. */
  let retryT = null, retryN = 0, waitEl = null;
  function waitScreen(on, err) {
    if (!screen) return;
    if (!on) { if (waitEl) { waitEl.remove(); waitEl = null; } return; }
    if (!waitEl) {
      waitEl = document.createElement('div'); waitEl.className = 'boot-wait';
      waitEl.innerHTML = '<div class="bw-box"><div class="bw-sp"></div><b>Sem ligação ao telemóvel</b>'
        + '<span>O servidor não respondeu. A tentar outra vez…</span><i class="bw-err"></i>'
        + '<div class="bw-btn">Tentar agora</div></div>';
      waitEl.querySelector('.bw-btn').onclick = () => { retryN = 0; retryNow(); };
      screen.appendChild(waitEl);
    }
    const e = waitEl.querySelector('.bw-err'); if (e) e.textContent = err ? ('(' + err + ')') : '';
  }
  function stopRetry() { clearTimeout(retryT); retryT = null; retryN = 0; waitScreen(false); }
  function retryNow() {
    clearTimeout(retryT); retryT = null;
    const id = retryCid || sessionCid; if (!waitingSession || !id) { stopRetry(); return; }
    switchCharacter(id).then(() => { if (waitingSession) scheduleRetry(); }).catch(() => scheduleRetry());
  }
  let lastRetryErr = null;
  function scheduleRetry(err) {
    if (!Bridge.inFiveM) return;                                   /* no browser/harness não há servidor para esperar */
    if (err === undefined) err = lastRetryErr; else lastRetryErr = err;   /* a repetição sem código mantém o último */
    /* 'noplayer' (1.1.5): o servidor ainda não sabe quem é esta personagem (framework a arrancar, personagem a carregar).
       Não é uma avaria: espera-se em silêncio (sem a folha "Sem ligação") e volta a tentar; o push `session` acelera. */
    waitScreen(err !== 'noplayer', err);
    clearTimeout(retryT);
    const wait = Math.min(30000, Math.round(5000 * Math.pow(1.5, retryN++)));
    retryT = setTimeout(retryNow, wait);
    Bridge.dbg('session', 'conta indisponível: nova tentativa em', wait, 'ms');
  }
  function resetMemory() {
    clearTimeout(saveT); saveT = null; saveSeq++; savedSig = null;           /* save pendente/em voo da personagem anterior: morto */
    urlSeq++;                                                                /* um deep link à espera do código da anterior não abre nada na nova */
    Object.keys(windows).forEach(killApp); recents.length = 0; current = null;
    if (screen) { screen.classList.remove('app-open', 'camera-mode'); } document.body.classList.remove('camera-mode');
    try { if (window.UI && UI.dismissAll) UI.dismissAll(); } catch (e) {}
    ['Notify', 'CC', 'Switcher', 'Vera', 'Keyboard', 'LockGallery', 'QuickPanel', 'Drawer', 'EdgePanel'].forEach(m => { try { window[m] && window[m].close && window[m].close(); } catch (e) {} });
    try { window.Keyboard && Keyboard.hide && Keyboard.hide(); } catch (e) {}
    try { window.Setup && Setup.stop && Setup.stop(); } catch (e) {}
    try { seeThrough(false); } catch (e) {}
  }
  /* account.get que distingue "não há conta" (nil → null/false) de "não foi possível perguntar" ({ error }: rate limit,
     servidor ocupado). O Bridge.rpc devolvia null nos dois casos e o arranque abria o assistente - terminá-lo com a
     conta a existir reescrevia-a (o account.create faz ON DUPLICATE KEY UPDATE). No jogo tenta 3 vezes; se continuar
     a falhar devolve { error } e quem chama NÃO abre o assistente. No browser um erro do mock conta como sem conta. */
  /* 1.1.5 - CONTRATO FECHADO: no jogo o assistente só abre com a resposta EXPLÍCITA { none: true } ("sei quem és e não
     há conta"). null/false (RPC sem resposta, servidor que devolveu nil) e { error } ('noplayer' = o servidor ainda não
     resolve a personagem, 'db' = schema a migrar, 'timeout' = 10 s sem resposta, 'ratelimit'...) são "não sei": espera-se e
     volta-se a tentar. Era isto que fazia o telemóvel "repor-se" depois de um restart: um account.get lento (base de
     dados ocupada com as migrações do arranque) chegava como false e o arranque abria o assistente. No browser (mock)
     null continua a ser "sem conta". Devolve a conta, null (sem conta) ou { error } (o último código visto). */
  async function fetchAccount() {
    let last = 'unavailable';
    for (let i = 0; i < 3; i++) {
      let r = null; try { r = await Bridge.rpcRaw('account.get'); } catch (e) { r = { error: 'exception' }; }
      if (!r || typeof r !== 'object') { if (!Bridge.inFiveM) return null; r = { error: 'noreply' }; }
      if (r.none) return null;
      if (!r.error) return r;
      if (!Bridge.inFiveM) return null;
      last = String(r.error);
      Bridge.dbg('session', 'account.get falhou', r.error, 'tentativa', i + 1);
      await new Promise(res => setTimeout(res, 1500 * (i + 1)));
    }
    return { error: last };
  }
  async function switchCharacter(cid) {
    const id = String(cid == null ? '' : cid).trim(); if (!id) return false;
    if (!initDone) { pendingSession = id; return false; }                       /* ainda a arrancar: trata-se no fim do init */
    if (id === sessionCid && !waitingSession) {
      /* a mesma personagem: nada a trocar. Mas se o arranque caiu no assistente por a conta ainda não
         estar pronta, confirma-se agora - terminar o assistente reescreveria a conta que já existe */
      if (!account && !switching) { const acc = await Bridge.rpc('account.get'); if (acc && acc.username && !account && sessionCid === id) { try { Setup.stop && Setup.stop(); } catch (e) {} boot(acc); } }
      return false;
    }
    const my = ++switchSeq; switching = id;
    const from = sessionCid; Bridge.dbg('session', 'troca', from, '→', id);
    /* 1) o que era da anterior fica gravado no espaço DELA */
    useStop(); clearTimeout(persistT); persistT = null; if (from) { try { Store.set('settings', state); } catch (e) {} }
    clearTimeout(setPlayer._t); if (from && player && player.citizenid === from) { try { Store.set('player', player); } catch (e) {} }
    resetMemory();
    /* 2) espaço da nova personagem + estado por omissão (com o idioma/tema por omissão do servidor) */
    Store.setNamespace(id); sessionCid = id; waitingSession = false; stopRetry();
    Object.keys(state).forEach(k => delete state[k]); Object.assign(state, JSON.parse(JSON.stringify(DEFAULTS)), Store.get('settings', {}) || {});
    const stored = Store.get('player', null);
    player = player && player.citizenid === id ? Object.assign({}, player) : Object.assign(JSON.parse(JSON.stringify(DEFAULT_PLAYER)), stored && stored.citizenid === id ? stored : {}, { citizenid: id });
    setPlayer._last = null; account = null; locked = true; apply._wp = null; ready = false;
    try { if (window.L) L.set(state.lang); } catch (e) {}
    apply(); try { updateSbTheme(); } catch (e) {}
    try { window.Home && Home.load(null); } catch (e) {}
    try { window.Lock && Lock.lock(true); } catch (e) {}
    Bridge.emit('session:changed', { from, to: id });
    try { window.Notify && (Notify.refresh && Notify.refresh(), Notify.renderLock && Notify.renderLock()); } catch (e) {}
    /* 3) no browser o "servidor" dá os dados da personagem; no jogo o client.lua manda o push `player` */
    if (!Bridge.inFiveM) { const p = await Bridge.rpc('player.get'); if (my !== switchSeq) return false; if (p) setPlayer(p); }
    const acc = await fetchAccount();
    if (my !== switchSeq) return false;                                            /* entretanto chegou outra troca */
    switching = null;
    if (acc && acc.error) { waitingSession = true; retryCid = id; scheduleRetry(acc.error); return true; }   /* sem resposta do servidor: nem assistente nem conta vazia - avisa e volta a tentar */
    retryCid = null; stopRetry();
    if (acc && acc.username) boot(acc); else { try { Setup.start(); } catch (e) { console.error('[apex_phone] setup', e); } }
    return true;
  }

  /* ---------- AQUECER OS TIPOS DE LETRA ----------
     ⚠️ Era ISTO que fazia a PRIMEIRA abertura parecer avariada. O aparelho fica `display:none` até
     alguém o abrir (body.hidden) e o Chromium NÃO descarrega um webfont que ninguém está a
     desenhar: à primeira vez o telemóvel aparecia todo escrito com a letra do sistema e, um
     instante depois, a Inter chegava e trocava - texto a mudar de largura, linhas a saltar e
     caixas a crescer a meio da animação de subida. Da segunda vez em diante já estava em cache e
     parecia bem, o que dava ao problema o ar de "só a primeira vez".
     Pedi-las aqui, no arranque, resolve-o antes de haver alguém a ver. O texto de exemplo leva
     acentos de propósito: as fontes estão partidas por `unicode-range` (latin, latin-ext, …) e
     sem eles só vinha o subconjunto `latin`, deixando os acentos a saltar na mesma. */
  function warmFonts() {
    if (!document.fonts || !document.fonts.load) return;
    const txt = 'AaÁáÀàÃãÂâÇçÉéÊêÍíÓóÕõÔôÚúÑñ0123456789';
    ['300 16px Inter', '400 16px Inter', '500 16px Inter', '600 16px Inter', '700 16px Inter', '800 16px Inter']
      .forEach(f => { try { document.fonts.load(f, txt); } catch (e) {} });
    try { document.fonts.load('400 16px MonteCarlo', 'olá'); } catch (e) {}   /* o "olá" do assistente */
    /* Outfit: titulos grandes e relogio do Android (css/oneui-fonts.css). Aquece-se SEMPRE: o sistema pode mudar a meio
       (outro item) e a primeira abertura do Android nao pode trocar de letra a meio da animacao. Pesos usados: 300 a 700. */
    ['300 16px Outfit', '400 16px Outfit', '500 16px Outfit', '600 16px Outfit', '700 16px Outfit']
      .forEach(f => { try { document.fonts.load(f, txt); } catch (e) {} });
  }

  /* ---------- Arranque ---------- */
  /* messages/media/mail (Fase 2): Config.Messages, Config.Media e Config.Mail do servidor. Vazios = cada app usa os
     valores por omissão do config.lua (Msgs.cfg, VoiceMsg, Groups, Mail). */
  /* recado: Config.Recado sem chaves (o client/main.lua nunca manda o keyConvar do GIF); vazio = valores do config_recado.lua */
  const config = { veraKey: '', debug: false, pinLock: { attempts: 5 }, allowWalking: false, showCursor: true, safeZone: null, messages: {}, media: {}, mail: {}, recado: {}, safari: {}, ai: { enabled: true, name: 'Vera Chat', wake: true, wakeClosed: false }, numberPrefix: '', airpods: { name: 'AirPods Pro 3', pauseWithoutAirpods: true }, android: {},
    wallpaperLinks: { enabled: true, hosts: [], maxLength: 512, paste: true },   /* Config.WallpaperLinks: fundos por link / colar (lockgallery.js) */
    photoLinks: { enabled: true, hosts: [], maxLength: 512, paste: true },       /* Config.PhotoLinks: Fotos › "Adicionar por link" (apps/photos.js); sem ele no ready vale o wallpaperLinks */
    lookKey: 'LMENU', worldSounds: true,   /* 1.2.0: Config.LookKey ('' = sem tecla) e Config.WorldSounds.enabled */
    /* 1.3.1 (4 nov 2026): Config.VideoCall - o vídeo da videochamada (apps/facecall.js rvCfg limita cada valor; o Lua faz a mesma conta) */
    videoCall: { fps: 8, width: 144, height: 192, quality: 0.5, minQuality: 0.25, maxQuality: 0.65, maxKB: 8, pipQuality: 0.5, pipFps: 30 } };
  /* idioma e tema de uma conta NOVA (Config.DefaultLanguage / DefaultTheme, ou o que o painel admin escolheu):
     no `ready` e, depois, a cada 'admin:settings' do client/overlay.lua. O painel publica a escolha num GlobalState que o
     cliente só copia para o Config 1,5 s depois de arrancar, e o `ready` dispara antes disso: sem esta segunda via o
     idioma escolhido no painel nunca chegava ao assistente inicial. Um assistente a decorrer sem idioma escolhido
     pelo jogador passa para o novo (Setup.defaultsChanged). */
  function setDefaults(r) {
    if (!r || typeof r !== 'object') return false;
    /* 'EN' / 'pt-PT' / 'es_ES' também valem: o L.norm devolve 'pt' para o que não conhece, por isso só se aceita
       quando o código (ou o prefixo de 2 letras) é mesmo um idioma que existe - senão um valor estragado virava 'pt' às escondidas */
    const rawLang = typeof r.defaultLang === 'string' ? r.defaultLang.trim() : '';
    const lang = rawLang && window.L ? [rawLang, rawLang.toLowerCase(), rawLang.slice(0, 2).toLowerCase()].find(c => L.NAMES && L.NAMES[c]) : null;
    let changed = false;
    if (lang && DEFAULTS.lang !== lang) { DEFAULTS.lang = lang; changed = true; if (!account && !('lang' in storedAtLoad)) state.lang = lang; }
    const theme = typeof r.defaultTheme === 'string' ? r.defaultTheme.trim().toLowerCase() : '';
    if (['light', 'dark', 'auto'].includes(theme) && DEFAULTS.theme !== theme) { DEFAULTS.theme = theme; changed = true; if (!account && !('theme' in storedAtLoad)) state.theme = theme; }
    if (changed && !account && window.Setup && Setup.running && Setup.defaultsChanged) { try { Setup.defaultsChanged(); } catch (e) { console.error('[apex_phone] defaults', e); } }
    return changed;
  }
  function applyReadyConfig(r) {
    if (!r || typeof r !== 'object') return;
    /* Config.ExtraLanguages (1.1.8): idiomas que o servidor acrescentou (html/js/i18n-<código>.js + locales/<código>.lua).
       Entram em L.NAMES/L.ORDER ANTES de se ler o defaultLang, senão um Config.DefaultLanguage = 'no' era recusado. */
    if (r.languages && typeof r.languages === 'object' && window.L && L.addLanguage) {
      const list = Array.isArray(r.languages) ? r.languages : Object.keys(r.languages).map(k => typeof r.languages[k] === 'string' ? { code: k, name: r.languages[k] } : r.languages[k]);
      list.forEach(x => { try { if (x && typeof x === 'object') L.addLanguage(x.code, x.name); else if (typeof x === 'string') L.addLanguage(x, x); } catch (e) {} });
    }
    setDefaults(r);
    if (typeof r.veraKey === 'string') config.veraKey = r.veraKey.slice(0, 24);
    if (r.debug !== undefined) { config.debug = !!r.debug; Bridge.setDebug(config.debug); }
    /* attempts 0 = Config.PinLock = false no servidor (sem contagem): tem de chegar como 0, não cair nos 5 por omissão */
    if (r.pinLock && isFinite(+r.pinLock.attempts) && +r.pinLock.attempts >= 0) config.pinLock = { attempts: Math.floor(+r.pinLock.attempts) };
    if (r.allowWalking !== undefined) config.allowWalking = !!r.allowWalking;
    if (r.showCursor !== undefined) config.showCursor = r.showCursor !== false;
    /* 1.2.0: Config.LookKey (a página ouve o Alt ela própria, ver o bloco 'look' abaixo) e Config.WorldSounds.enabled (sound.js) */
    if (typeof r.lookKey === 'string') config.lookKey = r.lookKey.slice(0, 24);
    if (r.worldSounds !== undefined) config.worldSounds = !!r.worldSounds;
    /* Config.WallpaperLinks: um `hosts = {}` do Lua chega como objeto vazio (não é array) - vale "qualquer site" */
    const linksOf = w => ({ enabled: w.enabled !== false, hosts: (Array.isArray(w.hosts) ? w.hosts : (w.hosts && typeof w.hosts === 'object' ? Object.values(w.hosts) : [])).filter(h => typeof h === 'string'), maxLength: isFinite(+w.maxLength) && +w.maxLength > 0 ? Math.floor(+w.maxLength) : 512, paste: w.paste !== false });
    const isCfg = v => !!(v && typeof v === 'object' && !Array.isArray(v));
    if (isCfg(r.wallpaperLinks)) config.wallpaperLinks = linksOf(r.wallpaperLinks);
    /* Config.PhotoLinks (Fotos › Adicionar por link): a mesma forma; um `ready` antigo sem a chave herda o wallpaperLinks, como o servidor faz */
    config.photoLinks = isCfg(r.photoLinks) ? linksOf(r.photoLinks) : Object.assign({}, config.wallpaperLinks, { hosts: config.wallpaperLinks.hosts.slice() });
    if (r.safeZone != null) { config.safeZone = r.safeZone; setSafeZone(r.safeZone); }
    /* Fase 2: só objetos simples (um array vindo do Lua não é configuração). Os consumidores validam cada campo.
       'safari' (NOVO-SAFARI-01): { enabled, allow } - sem esta chave na lista o valor era deitado fora aqui e o
       interruptor do apps/safari.js, escrito e testado, nunca chegava a valer nada. ⚠️ O `ready` do client/main.lua
       manda `safari` a partir do Config.Browser (config.lua); `ai` = { enabled, name } do Config.AI (a chave NUNCA vem para aqui). */
    /* prefixo do país (Config.NumberPrefix, ex. '+351'): só para MOSTRAR - os números guardados e comparados ficam sem ele (UI.phone / UI.unphone) */
    if (typeof r.numberPrefix === 'string') config.numberPrefix = r.numberPrefix.replace(/[^\d+]/g, '').slice(0, 5);
    /* 'android' = Config.Android { brand, model, osName, osVersion }: so os NOMES mostrados (Definicoes > Acerca do telefone, nome do aparelho) */
    /* 'currency' = Config.Currency { symbol, position, space }: UI.money / UI.cur */
    /* 'videoCall' = Config.VideoCall { fps, width, height, quality, minQuality, maxQuality, maxKB, pipQuality, pipFps }: apps/facecall.js */
    ['messages', 'media', 'mail', 'recado', 'safari', 'ai', 'airpods', 'android', 'currency', 'videoCall'].forEach(k => { const v = r[k]; if (v && typeof v === 'object' && !Array.isArray(v)) config[k] = v; });
  }
  async function init() {
    /* ---------- O ESTADO INICIAL É O PRIMEÍRO A SAIR DAQUI ----------
       O index.html abre com `body.boot` (fundo transparente + aparelho invisível) porque a página
       não sabe sozinha se está dentro do jogo: sem isso, o NUI pintava 1920×1080 de #0B0B0F por
       cima do jogo durante todo o arranque. Estas duas linhas correm ANTES de tudo o resto - as
       classes mudam no mesmo ciclo de estilo (não há pintura pelo meio, logo nenhum salto) e nada
       que possa falhar mais abaixo deixa o telemóvel invisível para sempre. */
    if (Bridge.inFiveM) document.body.classList.add('fivem', 'hidden');
    document.body.classList.remove('boot');
    warmFonts();
    screen = $('#screen'); apps = $('#apps'); frameRing();   /* (touchCursor() retirado a pedido do utilizador: sem bolinha a seguir o rato) */
    if (!screen.querySelector('.wallpaper-blur')) { const wl = screen.querySelector('.wallpaper-lock'); const wb = document.createElement('div'); wb.className = 'wallpaper-blur'; if (wl) screen.insertBefore(wb, wl); else screen.prepend(wb); }   /* cópia desfocada do wallpaper (ver .wallpaper-blur) */
    const r = (await Bridge.call('ready')) || {};
    if (r.peekSeconds) peekMs = Math.max(1000, Math.min(15000, Math.round(r.peekSeconds * 1000)));
    /* ---------- campos do `ready` da Fase 1 (client/main.lua) ----------
       defaultLang/defaultTheme entram nos DEFAULTS ANTES do primeiro arranque: valem para contas novas,
       para o assistente e para a troca de personagem, mas nunca pisam o que já estava gravado. */
    applyReadyConfig(r);
    /* a cor da moldura vem do DISPOSITIVO com que o telemóvel foi aberto (item laranja → moldura
       laranja, branco → branca, azul → azul). Muda em pleno uso quando se troca de item. */
    /* o SISTEMA vem com a moldura (o item decide os dois): primeiro o sistema, depois a moldura, que escreve as classes do .device */
    Bridge.on('frame', m => { if (m && m.os) setOS(m.os); if (m && 'model' in m) setDeviceModel(m.model); setFrame(m && m.frame); });
    setDeviceModel(r.model);
    setOS(r.os || 'ios');
    setFrame(r.frame);
    /* barra direita do PearPhone Fold: já no arranque (o assistente inicial também a mostra); nos outros aparelhos não desenha nada */
    try { if (window.Rail && Rail.init) Rail.init(); } catch (e) { console.error('[apex_phone] Rail.init', e); }
    if (Bridge.inFiveM && r.scale) { baseScale = r.scale; applyScale(state.phoneScaleV2 || r.scale); }
    applyOffset(r.offset);
    if (window.Wallpapers && r.wallpapers) Wallpapers.files = r.wallpapers;
    if (r.player) setPlayer(r.player); else if (!Bridge.inFiveM) { const p = await Bridge.rpc('player.get'); if (p) setPlayer(p); }
    if (window.Maps) { Maps.cfg = r.map || null; Maps.poi = r.poi || Maps.poi || []; }
    if (window.FaceID && r.faceid) FaceID.config = r.faceid;                 /* traços exigidos, prazo, foto */
    /* Config.Camera: qualidade e o desvio do visor na SELFIE (a câmara frontal do jogo deixa o
       personagem ao lado - SelfieOffsetX puxa o enquadramento até o centrar). Sem config, zero. */
    System.camera = Object.assign({ SelfieOffsetX: 0, SelfieOffsetY: 0 }, r.camera || {});
    if (r.garages) System.garages = r.garages;
    Bridge.on('player', p => setPlayer(p)); Bridge.on('gameTime', d => { gameHour = d && d.hour; if (state.theme === 'auto') apply(); });
    /* abrir: sobe de baixo (keyframe .enter, reinicia sempre); fechar: desce (.leave) e só depois fica .hidden */
    const stageEl = () => document.querySelector('.stage'); let leaveT = null, closeT = null, closeSeq = 0;   /* closeT/closeSeq: guardar um dobrável aberto espera que ele feche */
    /* ESPREITAR (pedido do utilizador): chega uma notificação com o telemóvel fechado → sobe só até ao banner ficar
       legível e volta a descer sozinho. Não abre o telemóvel: continua sem foco e sem apanhar toques. */
    let pkA = null, pkB = null;
    /* 3 s por omissão (pedido do utilizador): o telemóvel sobe o suficiente para se ler a
       notificação e desce sozinho. Abrir o telemóvel durante esse tempo cancela a descida
       (o Bridge.on('open') chama peekEnd). O servidor pode mudar em Config.PeekSeconds. */
    peek = (ms, px = 0) => { if (!Bridge.inFiveM || !document.body.classList.contains('hidden')) return;
      ms = ms || peekMs;
      if (form === 'fold' && (foldOpen || fa)) setFoldOpen(false, { instant: true });   /* dobrável: espreita-se sempre FECHADO (o ecrã de fora) */
      try { tick(true); } catch (e) {}   /* o tick não repinta com o telemóvel guardado: hora, relógio e widgets em dia antes de subir */
      /* quanto é preciso mostrar: bloqueado, as notificações estão a meio do ecrã (.lock-notifs) → sobe até as apanhar;
         desbloqueado é um banner colado ao topo (.banner) → chegam ~260 px. Medido do ecrã real, com recuo se ainda não existir. */
      clearTimeout(pkA); clearTimeout(pkB);
      /* ⚠️ ORDEM IMPORTANTE, e por duas razões distintas:
         1) Com o telemóvel guardado o <body> tem `hidden` → `display:none`, e nesse estado
            TODOS os getBoundingClientRect vêm a zero. Medir antes disto caía sempre no valor
            de recuo, ou seja, a altura nunca era a da notificação real. Põe-se o `.pk`
            primeiro (que devolve o display), mede-se, e só depois se sobe.
         2) O `.pk` INSTALA a transição e o `.pk-up` MUDA o transform. Se entrarem no mesmo
            recálculo de estilo, o browser nunca pinta o ponto de partida e a transição é
            saltada - o telemóvel aparecia de repente, já em cima. A leitura de layout entre
            os dois obriga-o a pintar. (É a mesma armadilha que este ficheiro já documenta
            para o abrir/fechar.) */
      document.body.classList.add('pk');
      /* bloqueado: enquanto se espreita, o ecrã mostra SÓ a notificação recebida (peek1 no
         lock.css). Com a lista cheia o cartão novo ficava no fundo da caixa e o aparelho
         teria de subir quase todo para lá chegar - assim encosta-se ao topo e basta um
         terço do ecrã. É reposto no peekEnd, e o Bridge.on('open') chama-o. */
      if (locked) screen.classList.add('peek1');
      void document.body.offsetWidth;
      /* Sobe-se SÓ o que a notificação que acabou de chegar precisa - não a lista toda.
         O cartão novo é o que o notify.js marca com `nw-card` (o de maior `bottom`, medido;
         o `.new` sozinho não chegava porque pode estar em vários cartões ao mesmo tempo). */
      if (!px) { const sc = document.getElementById('screen'), z = window.UI && UI.zoom ? UI.zoom() : 1;
        /* `.ncount` = a cápsula "3 notificações" do modo Contagem (Definições › Notificações › Mostrar como): nesse modo não há
           cartão nenhum no ecrã bloqueado e, sem ela no seletor, caía-se no recuo e o telemóvel subia quase todo (2026-09-19) */
        /* Android: a notificacao flutuante e o `.ahn-card` (shell/android-panel.js); o ecra bloqueado usa o mesmo `.lock-notifs` */
        const t = document.querySelector(locked
          ? '#lock .lock-notifs .notif-card.nw-card, #lock .lock-notifs .notif-card.new, #lock .lock-notifs .notif-card, #lock .lock-notifs .ncount'
          : (os === 'android' ? '.ahn-card, .banner' : '.banner'));
        const r = t && t.getBoundingClientRect();
        if (r && r.height > 0 && sc && z > 0) px = Math.ceil((r.bottom - sc.getBoundingClientRect().top) / z + 22);
        /* recuos do CSS, só para o caso de nem assim haver rect: .banner{top:58px} (cartão ~80 px) e, bloqueado, a notificação
           encostada ao TOPO da caixa enquanto se espreita (.screen.peek1 + .lock-notifs{top:270px}, cartão ~90 px) */
        px = Math.min(956, Math.max(190, px || (locked ? 380 : 200))); }
      document.documentElement.style.setProperty('--pk-h', px + 'px');
      void document.body.offsetWidth;
      document.body.classList.add('pk-up');
      pkA = setTimeout(() => { document.body.classList.remove('pk-up'); pkB = setTimeout(() => { document.body.classList.remove('pk'); screen.classList.remove('peek1'); }, 580); }, ms); };
    peekEnd = () => { clearTimeout(pkA); clearTimeout(pkB); document.body.classList.remove('pk', 'pk-up'); screen.classList.remove('peek1'); };
    Bridge.on('lock', () => { if (landscape) rotate(false); });   /* bloquear = volta ao retrato (o ecrã bloqueado não roda) */
    Bridge.on('open', m => { if (Bridge.inFiveM && document.body.classList.contains('hidden') && ready) { try { tick(true); } catch (e) {} }   /* ainda escondido: repinta o que o tick deixou por fazer no bolso, sem se ver */
      peekEnd(); if (m && m.scale) baseScale = m.scale; if (m && m.safeZone != null) setSafeZone(m.safeZone); if (m && m.offset) applyOffset(m.offset); if (m && m.os) setOS(m.os); if (m && 'model' in m) setDeviceModel(m.model); if (m && m.frame) setFrame(m.frame); applyScale(state.phoneScaleV2 || baseScale || 0.6); clearTimeout(leaveT); clearTimeout(closeT); closeSeq++;
      /* dobrável: sai do bolso SEMPRE fechado (o ecrã de fora); quem o abre é o jogador. Um guardar a meio fica fechado já */
      if (form === 'fold' && (foldOpen || fa)) setFoldOpen(false, { instant: true });
      const st = stageEl(); if (st && Bridge.inFiveM) { st.classList.remove('leave', 'enter'); void st.offsetWidth; document.body.classList.remove('hidden', 'vera-only'); st.classList.add('enter'); setTimeout(() => st.classList.remove('enter'), 700); }
      else document.body.classList.remove('hidden', 'vera-only'); lastTouch = Date.now(); Bridge.emit('phone:open');
      /* a conta não respondeu no arranque/troca (rate limit, servidor ocupado): abrir o telemóvel volta a pedi-la */
      if (waitingSession && retryCid && !switching) switchCharacter(retryCid); });
    Bridge.on('close', () => { const st = stageEl(); if (st && Bridge.inFiveM && !document.body.classList.contains('hidden')) { st.classList.remove('enter'); clearTimeout(leaveT); clearTimeout(closeT);
        const down = () => { clearTimeout(closeT); if (!document.body.classList.contains('hidden') && !st.classList.contains('leave')) { st.classList.add('leave'); leaveT = setTimeout(() => { document.body.classList.add('hidden'); st.classList.remove('leave'); }, 430); } };
        /* dobrável aberto: primeiro FECHA-SE (a folha dobra por cima da metade direita) e só então desce, já fechado. Voltar a
           tirá-lo do bolso a meio (Bridge 'open') muda o closeSeq: este guardar já não desce nada */
        if (form === 'fold' && (foldOpen || fa)) { const my = ++closeSeq; let gone = false; const go = () => { if (gone || my !== closeSeq) return; gone = true; down(); };
          setFoldOpen(false, { ms: 440 }).then(go); closeT = setTimeout(go, 1000); }
        else down(); }
      else { document.body.classList.add('hidden'); if (form === 'fold' && (foldOpen || fa)) setFoldOpen(false, { instant: true }); }
      useStop(); persistNow();   /* definições pendentes vão já para o localStorage */
      /* Guardar o telemóvel dispensa as camadas passageiras - folhas, alertas, menus de
         contexto e o teclado. Sem isto, criar um anúncio no Marketplace, fechar e voltar a
         abrir mostrava a folha ainda aberta (e o mesmo em qualquer outra app). O UI.dismissAll
         fecha-as pelo caminho normal, para quem estiver em `await` receber "cancelado". */
      try { if (window.UI && UI.dismissAll) UI.dismissAll(); } catch (e) {}
      if (state.lockOnClose && window.Lock && !locked) Lock.lock(true); Bridge.emit('phone:close'); });
    Bridge.on('phone:open', () => { if (current) useStart(current); });
    Bridge.on('notification', d => { Bridge.dbg('notify', d && d.app, d && d.title); notify(d || {}); });
    apply();
    /* o ecrã e o corpo nunca fazem scroll: um focus() num campo (teclado) faria o CEF deslocar o conteúdo dentro do overflow:hidden */
    const noScroll = el => el && el.addEventListener('scroll', () => { if (el.scrollTop || el.scrollLeft) { el.scrollTop = 0; el.scrollLeft = 0; } }, { passive: true });
    noScroll(screen); noScroll(document.body); noScroll(document.documentElement);
    addEventListener('pointerdown', () => { lastTouch = Date.now(); }, true);
    /* escrever no teclado físico e cliques programáticos também são atividade (o bloqueio automático já conta com apps abertas) */
    addEventListener('keydown', () => { lastTouch = Date.now(); }, true); addEventListener('click', () => { lastTouch = Date.now(); }, true);
    addEventListener('resize', () => { if (Bridge.inFiveM && lastOffset) applyOffset(lastOffset); });   /* a zona segura e os limites são frações da janela */
    addEventListener('keydown', e => { if (e.key === 'Escape') { if (document.activeElement && document.activeElement.matches('input,textarea')) { document.activeElement.blur(); return; } if (Bridge.inFiveM) Bridge.call('close'); else if (current) closeApp(); return; } if (window.Lock) Lock.key(e); });
    /* 'typing' (client/main.lua, 1.1.8): com Config.KeepVoice (ou AllowWalking) o jogo continua a receber o teclado com o
       telemóvel aberto, para o push-to-talk passar. Mas enquanto um campo de texto tem o foco cada letra escrita no telemóvel
       chegava TAMBÉM aos key mappings do jogo (o T abria o chat, o TAB o inventário, as teclas de outros resources
       disparavam) - e o chat, ao fechar, largava o foco da NUI: o telemóvel deixava de responder ao ESC e a voz morria.
       O Lua já esperava este aviso (callback 'typing') mas nenhuma página o enviava. focusin/focusout (atrasados 60 ms,
       porque mudar de campo dá um focusout seguido de um focusin) + um vigia a 400 ms para o campo que é retirado do DOM com
       o foco (o Chromium não dispara focusout nesse caso) e para o fechar do telemóvel.
       26 out ("every time I type in Messages and hit M it closes my phone"): o aviso só saía no focusin, 60 ms depois, e o
       vigia só o DESLIGAVA. Um campo que já tinha o foco quando o telemóvel voltou a abrir (fechado pelo Lua, morte, /phonefix)
       nunca dava focusin e ficava a escrever para o jogo. Agora: o "a escrever" sai logo no focusin e na primeira tecla, o
       vigia acerta os DOIS sentidos, abrir o telemóvel volta a dizer o estado ao Lua e guardá-lo tira o foco do campo. */
    if (Bridge.inFiveM) {
      let typingOn = false, typingT = null;
      const NOT_TEXT = ['checkbox', 'radio', 'range', 'file', 'button', 'submit', 'reset', 'color'];
      /* 1.2.0: um IFRAME de app externa (thirdparty.js) conta como "a escrever" enquanto tiver o foco - o que se passa lá
         dentro (outra origem nui://) não se vê daqui: o focusin/keydown de um campo do iframe nunca chega a este documento,
         e as letras escritas na app do comprador iam para os key mappings do jogo ("locking keys in my text fields in my
         phone app doesn't work"). Uma app que avise { apexphone:'typing', on } passa a mandar só nos campos dela.
         1.3.1 (4 nov 2026, "spacebar not working in creator job apps or shop editor"): o painel admin e a loja abrem SEMPRE com
         o telemóvel guardado (client/overlay.lua chama ClosePhone), por isso o body fica com 'hidden' + 'ov-on' (overlay.js;
         o CSS volta a mostrar o body). O editable() só via o 'hidden' e dizia que nenhum campo do painel era de texto: o
         noSpace comia o Espaço em todos (criador de apps de trabalho, secção Loja, pesquisa, JSON). Com 'ov-on' conta como
         visível tudo o que está FORA do .stage (as camadas são filhas do body); o que está dentro do telemóvel escondido não. */
      const textEl = el => !!(el && el.nodeType === 1 && el.isConnected && (el.tagName === 'IFRAME' ? !!(window.ThirdParty && ThirdParty.wantsTyping && ThirdParty.wantsTyping(el)) : ((el.matches('input,textarea,select') && !NOT_TEXT.includes(el.type)) || el.isContentEditable)));
      const shown = el => { const c = document.body.classList; return !c.contains('hidden') || (c.contains('ov-on') && !(el.closest && el.closest('.stage'))); };
      const editable = el => textEl(el) && shown(el);
      const sendTyping = on => { on = !!on; if (on === typingOn) return; typingOn = on; try { Bridge.call('typing', { on }); } catch (e) {} };
      const checkTyping = () => { clearTimeout(typingT); typingT = setTimeout(() => sendTyping(editable(document.activeElement)), 60); };
      /* entrar num campo avisa JÁ (a primeira letra não pode chegar ao jogo); sair espera os 60 ms (trocar de campo) */
      document.addEventListener('focusin', e => { if (editable(e.target)) { clearTimeout(typingT); sendTyping(true); } else checkTyping(); }, true);
      document.addEventListener('focusout', checkTyping, true);
      addEventListener('keydown', e => { if (!typingOn && editable(e.target)) sendTyping(true); }, true);
      setInterval(() => { const on = editable(document.activeElement); if (on !== typingOn) sendTyping(on); }, 400);
      /* o foco entrou num iframe (a janela perde o foco e o activeElement passa a ser o iframe) ou voltou: decidir já, sem
         esperar pelo vigia dos 400 ms; a app externa que avisa 'typing' também acorda isto (ThirdParty emite 'ext:typing') */
      const now = () => { clearTimeout(typingT); sendTyping(editable(document.activeElement)); };
      addEventListener('blur', () => setTimeout(now, 0)); addEventListener('focus', () => setTimeout(now, 0));
      Bridge.on('ext:typing', now);
      /* OLHAR À VOLTA (1.2.0, Config.LookKey): o key mapping do client/main.lua só dispara quando o JOGO recebe o teclado;
         com o rato em cima do telemóvel (ou AllowWalking e KeepVoice desligados) o teclado é desta página e o Alt não fazia
         nada. A página avisa o Lua ('look' on/off); o Lua liga/desliga o olhar pelo mesmo caminho do key mapping. Só o Alt
         (LMENU / RMENU): outra tecla configurada fica só com o key mapping. Nunca num campo de texto; largar a tecla, perder
         o foco da janela ou fechar o telemóvel desliga. */
      let lookOn = false;
      const lookSend = on => { on = !!on; if (on === lookOn) return; lookOn = on; try { Bridge.call('look', { on }); } catch (e) {} };
      const altKey = () => /^[LR]?MENU$/i.test(String(config.lookKey || '')) || /^ALT$/i.test(String(config.lookKey || ''));
      addEventListener('keydown', e => { if (e.key !== 'Alt' || !altKey() || e.repeat) return; if (editable(document.activeElement)) return; e.preventDefault(); lookSend(true); }, true);
      addEventListener('keyup', e => { if (e.key === 'Alt') { e.preventDefault(); lookSend(false); } }, true);
      addEventListener('blur', () => lookSend(false));
      Bridge.on('close', () => { lookOn = false; });
      /* o Lua põe o "a escrever" a falso ao abrir: diz-se outra vez o que é verdade (typingOn = null obriga o envio) */
      Bridge.on('open', () => { clearTimeout(typingT); typingOn = null; sendTyping(editable(document.activeElement)); });
      Bridge.on('close', () => { clearTimeout(typingT); const a = document.activeElement;
        if (a && a !== document.body && a.matches && (a.matches('input,textarea,select') || a.isContentEditable)) { try { a.blur(); } catch (e) {} }
        typingOn = null; sendTyping(false); });
      /* Config.AllowWalking: o Espaço é o SALTAR do jogo e chega também à página. O Chromium carrega com o Espaço no último
         botão ou interruptor tocado (fica com o foco): saltar voltava a tocar no play da Música, num interruptor das
         Definições... Fora de um campo de texto corta-se só a ação do browser; quem ouve o Espaço (Jogos) recebe-o na mesma.
         1.3.1: com uma camada aberta (body.ov-on: painel admin, loja) o Espaço é da camada - o painel abre sem keep input (o
         jogo não salta) e o Espaço nos botões/interruptores dele é o normal do browser; a loja corta-o ela própria (shop.js
         onKey). Uma camada futura com keepInput e botões tem de o cortar ela própria, como a loja. */
      const noSpace = e => { if (e.key !== ' ' || document.body.classList.contains('ov-on')) return; if (!editable(e.target)) e.preventDefault(); };
      addEventListener('keydown', noSpace, true); addEventListener('keyup', noSpace, true);
    }
    /* fora do jogo o aparelho encaixa na janela (largura do aparelho + 10: 470; o dobrável conta sempre ABERTO, 1370, para não
       mudar de tamanho ao abrir) */
    const fit = () => { if (Bridge.inFiveM) return; const s = Math.min(1, (innerHeight - 120) / 1000, (innerWidth - 40) / (form === 'fold' ? FOLD.dow + 10 : SW() + 30)); document.documentElement.style.setProperty('--scale', s.toFixed(3)); };
    fitNow = fit; fit(); addEventListener('resize', fit);
    /* no jogo, com o dobrável a escala também depende da largura da janela */
    addEventListener('resize', () => { if (Bridge.inFiveM && form === 'fold') applyScale(state.phoneScaleV2 || baseScale || 0.6); });
    const btnL = $('#btnLock'); if (btnL) btnL.onclick = () => Lock.lock(); const btnT = $('#btnTheme'); if (btnT) btnT.onclick = () => setState({ theme: state.dark ? 'light' : 'dark' });
    const accR = await fetchAccount(); account = accR && !accR.error ? accR : null;
    const readyCid = r.player && r.player.citizenid ? String(r.player.citizenid) : null;
    initDone = true;
    if (!account || !account.username) {
      account = null;
      /* NO JOGO SEM PERSONAGEM (o NUI arranca antes da escolha no multicharacter): não se abre o assistente
         - terminá-lo criaria/reescreveria uma conta sem dono. Espera-se pelo push `session` (ou `player`).
         O mesmo quando o servidor não respondeu ao account.get (accR.error): pode haver conta. */
      if (Bridge.inFiveM && (!readyCid || (accR && accR.error))) { waitingSession = true; retryCid = readyCid;
        Bridge.dbg('session', 'à espera da personagem', accR && accR.error);
        /* houve ERRO do servidor (não é só "ainda não escolheu personagem"): avisa e volta a tentar sozinho */
        if (accR && accR.error && readyCid) scheduleRetry(accR.error); }
      else {
        const cid = readyCid || (player && player.citizenid);
        if (cid) persistNow();
        if (cid && Store.setNamespace(cid)) { Object.keys(state).forEach(k => delete state[k]); Object.assign(state, JSON.parse(JSON.stringify(DEFAULTS)), Store.get('settings', {}) || {}); apply(); }
        sessionCid = cid || null; Setup.start();
      }
    } else boot(account);
    if (pendingSession) { const p = pendingSession; pendingSession = null; switchCharacter(p); }
  }
  /* o indicador (.home-bar) sem :has() (o CEF do jogo não o tem e a regra inteira caía): (1) passa para DEPOIS da zona de gesto, para o
     `.hb-zone:active ~ .home-bar` do system.css o apanhar (a zona é posta pelo gestures.js no fim do ecrã; o z-index de cada um não
     muda, por isso nada mexe à vista); (2) o ecrã apagado (.screen-off.in, hardware.js) põe .scr-off no ecrã e o indicador sai */
  function hbWire() {
    if (!screen) return;
    const hb = screen.querySelector(':scope > .home-bar'), z = screen.querySelector(':scope > .hb-zone');
    if (hb && z && (z.compareDocumentPosition(hb) & Node.DOCUMENT_POSITION_PRECEDING)) z.after(hb);
    const off = screen.querySelector(':scope > .screen-off'); if (!off) return;
    const sync = () => { const on = off.classList.contains('in'); if (screen.classList.contains('scr-off') !== on) screen.classList.toggle('scr-off', on); };
    if (!off._scrMo && window.MutationObserver) { off._scrMo = new MutationObserver(sync); off._scrMo.observe(off, { attributes: true, attributeFilter: ['class'] }); }
    sync();
  }
  function boot(acc) {
    /* a conta diz de quem é o telemóvel: o Store passa para o espaço dessa personagem. Se não era o que
       estava ativo (primeira vez com namespace, ou a última sessão foi de outra), o estado em memória é
       dessa outra e volta a ler-se do espaço certo antes de a conta o completar. */
    const cid = acc.citizenid || (player && player.citizenid);
    if (cid) { persistNow(); if (Store.setNamespace(cid)) { Object.keys(state).forEach(k => delete state[k]); Object.assign(state, JSON.parse(JSON.stringify(DEFAULTS)), Store.get('settings', {}) || {}); apply._wp = null; } sessionCid = String(cid); waitingSession = false; retryCid = null; stopRetry(); if (player && (!player.citizenid || player.citizenid === sessionCid)) { clearTimeout(setPlayer._t); Store.set('player', player); } }
    account = acc; if (acc.settings) Object.assign(state, acc.settings, { installed: acc.settings.installed || state.installed });
    /* contas de antes da Fase 1 só têm `dnd` (focus fica no 'none' dos DEFAULTS): o `dnd` manda, como no Centro de
       controlo e no notify.js - dnd ligado sem foco = "Não incomodar"; dnd desligado = sem foco */
    if (!FOCUS.includes(state.focus) || (state.focus === 'none') === !!state.dnd) state.focus = state.dnd ? (FOCUS.includes(state.focus) && state.focus !== 'none' ? state.focus : 'dnd') : 'none';
    Store.set('settings', state);
    setPlayer(Object.assign({}, player, { phone: acc.phone || player.phone }));
    apply();
    /* SysUI, QuickPanel, Drawer e EdgePanel sao os modulos do Android: arrancam SEMPRE (o sistema pode mudar a meio, ao
       trocar de item) e desenham-se so com body.os-android; ouvem o Bridge 'os:changed' */
    ['Notify', 'Island', 'Lock', 'Home', 'Widgets', 'CC', 'Switcher', 'Gestures', 'Keyboard', 'Vera', 'VeraVoice', 'Perm', 'Earbuds', 'AirDrop', 'Hardware', 'SysUI', 'QuickPanel', 'Drawer', 'EdgePanel'].forEach(m => { try { if (window[m] && window[m].init && !window[m]._inited) { window[m].init(); window[m]._inited = true; } } catch (e) { console.error('[apex_phone] init', m, e); } });
    try { hbWire(); } catch (e) { console.error('[apex_phone] indicador', e); }
    /* nada aqui pode impedir o telemóvel de arrancar: uma disposição estragada cai para a predefinida */
    try { if (window.Home) Home.load(acc.layout); } catch (e) { console.error('[apex_phone] Home.load', e); try { Home.load(null); } catch (e2) { console.error('[apex_phone] Home.load(null)', e2); } }
    if (!tickTimer) tickTimer = setInterval(() => { try { tick(); } catch (e) { console.error('[apex_phone] tick', e); } }, 1000);
    try { tick(); } catch (e) { console.error('[apex_phone] tick', e); }
    ready = true; locked = true; try { Lock.lock(true); } catch (e) { console.error('[apex_phone] lock', e); }
    Bridge.emit('ready');
    /* notas, lembretes, eventos, alarmes, relógios, lugares e recordes vêm do servidor (store.js SYNC / server/userdata.lua):
       o que lá estiver substitui o local e quem os mostra repinta - a agenda (avisos), as apps abertas (ouvem 'agenda'),
       os widgets do ecrã bloqueado e do principal */
    Promise.resolve(Store.pull()).then(keys => { if (!keys || !keys.length) return;
      keys.forEach(k => { try { Bridge.emit('agenda', { key: k }); } catch (e) {} });
      try { window.Agenda && Agenda.kick && Agenda.kick(); } catch (e) {}
      try { window.Lock && Lock.renderWidgets && Lock.renderWidgets(); } catch (e) {}
      try { const h = document.getElementById('home'); if (h && window.Widgets && Widgets.refresh) Widgets.refresh(h); } catch (e) {}
    }).catch(e => console.error('[apex_phone] Store.pull', e));
  }
  let tickTimer = null;
  /* Reposição de fábrica em memória: sem recarregar a página, o telemóvel fica onde está e volta ao "Olá" do assistente */
  function factoryReset() {
    clearTimeout(persistT); persistT = null; savedSig = null; clearTimeout(saveT); saveT = null; saveSeq++; urlSeq++;   /* nada pendente pode reescrever as chaves que se vão apagar (nem abrir um deep link antigo) */
    /* só as chaves DESTA personagem (Store.clear): as outras personagens do mesmo PC ficam intactas */
    try { Store.clear(); } catch (e) {}
    Object.keys(windows).forEach(killApp); recents.length = 0; current = null;
    (screen.classList.remove('app-open', 'camera-mode'), document.body.classList.remove('camera-mode'));
    ['Notify', 'CC', 'Switcher', 'Vera', 'Keyboard', 'QuickPanel', 'Drawer', 'EdgePanel'].forEach(m => { try { window[m] && window[m].close && window[m].close(); } catch (e) {} });
    try { window.Keyboard && Keyboard.hide && Keyboard.hide(); } catch (e) {}
    Object.keys(state).forEach(k => delete state[k]); Object.assign(state, JSON.parse(JSON.stringify(DEFAULTS))); Store.set('settings', state);
    account = null; locked = true; updateSbTheme(); apply();
    try { window.Notify && Notify.clear && Notify.clear(); } catch (e) {}
    try { window.Home && Home.load(null); } catch (e) {}
    try { window.Lock && Lock.lock(true); } catch (e) {}
    Bridge.emit('factory:reset'); Setup.start();
  }

  return {
    DEFAULTS, state, setState, save, apply, isDark, glassLive, get account() { return account; }, set account(a) { account = a; }, get player() { return player; }, setPlayer,
    installed, isInstalled, install, uninstall, OPTIONAL_DEFAULT, setAdminDisabled, adminDisabled, setDefaults,
    openApp, closeApp, killApp, currentApp, windows, recents, badge, torch, notify, indicator, renderStatus, updateSbTheme, shrinkTransform, usage, seeThrough,
    rotate, get landscape() { return landscape; },
    peek: (...a) => peek(...a), peekEnd: () => peekEnd(),   /* espreitar uma notificação com o telemóvel fechado */
    get locked() { return locked; }, set locked(v) { locked = v; updateSbTheme(); }, get screen() { return screen; }, get gameHour() { return gameHour; }, get ready() { return ready; },
    init, boot, factoryReset, touch: () => { lastTouch = Date.now(); }, get NAMES() { const o = {}; App.ids().forEach(id => o[id] = App.name(id)); return o; },
    /* Fase 1 */
    openURL, route, parseURL, switchCharacter, deviceName, serial, imei, setSafeZone, config, FOCUS,
    get session() { return sessionCid; }, get waitingSession() { return waitingSession; },
    /* Android (2026-10-01) */
    get os() { return os; }, setOS, osInfo, isAndroid, setFrame, get frame() { return frameNow; }, frameRing,
    get form() { return form; }, get SW() { return SW(); }, get deviceModel() { return deviceModel; },
    /* dobráveis (contrato v2): estado, mudança animada (Promise), se está a animar e as medidas (ecrã fechado/aberto) */
    get foldOpen() { return form === 'fold' && foldOpen; }, setFoldOpen, get foldAnimating() { return !!fa; }, FOLD,
    /* PearOS 27 (1.4.0): tamanho contínuo da hora, repintar os fundos "de tipo", assinatura e estado do estilo dos ícones */
    clockK, clockVars, CLOCK_KX, repaintWallpaper, iconStyleSig, iconState
  };
})();

/* ============================================================
   RAIL: a BARRA DIREITA do PearPhone Fold (PearOS, fechado e aberto; referências 13 a 16 do dono, 2026-10-02)
   Só existe no dobrável do PearOS (System.form 'fold' com System.os 'ios'). No PearPhone 18 e no Android não desenha nada:
   as chamadas guardam o pedido e ficam à espera (trocar de item a meio desenha-as). Três camadas, construídas UMA vez e
   atualizadas no sítio (o relógio de 1 s só troca texto quando muda; nada se refaz por inteiro):
     .rail        (#screen, z 312) a pilha de estado no topo da coluna: o lugar da câmara (só fechado; a câmara é o .island),
                  a hora, o anel de estado (Wi-Fi em arcos, a rede em pontos, a BATERIA é o próprio anel), os indicadores
                  (privacidade, foco, silêncio, VPN) e as atividades em círculos de vidro (island.js usa Rail.actsBox()).
                  Tocar na hora abre as notificações; no anel, o Centro de controlo (com ele aberto a hora dá a bateria).
     .rail-apps   (#screen, z 96: por cima das apps e do bloqueado, por baixo do CC, notificações, folhas, alertas e teclado)
                  um .rl-app por janela com os botões dela: voltar e grupos por baixo da pilha de estado (--rl-top),
                  separadores a meio, ações principais em baixo. Só o da app à vista aparece (entra e sai por opacity/transform).
     .rl-home     (dentro do #home: acompanha a escala e a opacidade da home ao abrir apps, ao bloquear e nos gestos) a dock
                  vertical de vidro e o botão redondo de pesquisa.
   API (window.Rail)
     Rail.active                  true só no PearPhone Fold (PearOS); Rail.width: a largura a deixar livre (px); Rail.top: --rl-top
     Rail.setHome({ dock, onSearch })
         dock: ids de apps (a barra desenha os ícones .hi.app[data-id]; tocar abre a app a partir do ícone; os emblemas do
               System.badge aparecem sozinhos) OU o ELEMENTO da dock da home (a barra adota-o para a coluna, sempre dentro do
               #home, e devolve-o ao sítio de onde veio quando deixa de haver barra). onSearch: botão redondo em baixo.
         Rail.setHome(null) limpa. Chamar outra vez atualiza no sítio (ícones por id).
     Rail.setApp(win, { back, groups, tabs, primary, hidden, tone })
         win: a janela (.app-window) ou o id da app. back: função (ou { onTap, label, icon }), círculo por baixo do estado.
         groups: [[item, ...], ...] pílulas de botões empilhados por baixo do voltar. tabs: [item, ...] pílula vertical a meio
         (item.active = separador atual). primary: [[item, ...], ...] em baixo (uma lista simples [item, ...] é UMA pílula).
         Um grupo de um item é um círculo. hidden: true esconde os botões desta app (a pilha de estado fica).
         tone: 'dark' | 'light' força o tom (texto, vidro) da coluna com esta app à frente; sem ele segue o tema da app.
         item = { id, icon, label, onTap, onHold, active, disabled, badge (número ou true), tint ('blue' | 'red' | 'green' |
         'orange' | '#hex') }; icon = nome de glifo do Icons.g ('chevL', 'trash', 'compose'...) ou um <svg> pronto.
         Voltar a chamar ATUALIZA no sítio, posição a posição (ícone, rótulo, ativo, emblema): só os grupos e botões novos
         entram e os que saem desvanecem; nada pisca. Com a janela morta (System.killApp) os botões saem sozinhos.
     Rail.update(win, parcial) junta ao que lá está · Rail.clear(win) · Rail.get(win) · Rail.refresh() volta a medir
     Rail.metrics { bt: 64, gap: 16, bot: 40, mid: 497 }: círculo dos botões, intervalo entre pílulas, o grupo de baixo a 40 do
         fundo e o centro dos separadores (as medidas do liquid27.css, para arrumar a coluna sem números próprios)
   Eventos Bridge 'rail:state' { state: 'off' | 'lock' | 'home' | 'app', app } e 'rail:top' { top } (a pilha de estado cresceu ou encolheu).
   CSS (tokens.css): --rail-w (122 fechado / 128 aberto, 0 fora do Fold do PearOS), --rail-x (eixo da coluna a partir da aresta
   direita: 70 / 76), --rail-cw (100, a coluna), --rail-r. Vidro .rl-g (liquid27.css): sobre o fundo do ecrã pinta a cópia pré-desfocada
   do fundo no sítio exato (--gx/--gy, medidos aqui); sobre uma app é só a tinta. Para vidro dentro de uma app: .fold-glass.
   ============================================================ */
window.Rail = (() => {
  const isOn = () => !!(window.System && System.form === 'fold' && System.os !== 'android');
  const scrEl = () => document.getElementById('screen');
  const esc = s => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const T = s => (window.L && L.t ? L.t(s) : s);
  const safe = (fn, ...a) => { try { return typeof fn === 'function' ? fn(...a) : undefined; } catch (e) { console.error('[apex_phone] rail', e); } };
  /* glifo: nome do Icons.g ou um <svg> já pronto (as apps são código do próprio recurso); outra coisa vira texto curto */
  const glyph = (ic, sz) => { const s = String(ic || ''); if (!s) return ''; if (s.charAt(0) === '<') return s; if (window.Icons && Icons.has && Icons.has(s)) return Icons.g(s, sz || 24); return `<b class="rl-tx">${esc(s.slice(0, 4))}</b>`; };

  let sys = null, uiL = null, hm = null, timeEl = null, ringEl = null, indEl = null, actsEl = null, netEl = null, netSig = '';
  let stNow = '', appNow = null, syncSig = '', paintSig = '', timeTx = '', homeSpec = null, adopted = null, ov = '', obs = null, gT = 0, inited = false;
  const recs = new Map();   /* id da app → { id, raw, spec, el } */

  /* ---------- a pilha de estado (.rail) e a camada dos botões das apps (.rail-apps): uma vez ---------- */
  function build() {
    const s = scrEl(); if (!s) return false;
    if (!sys || !sys.isConnected) {
      sys = document.createElement('div'); sys.className = 'rail'; sys.dataset.st = 'off';
      /* .rl-net: a rede por baixo do anel, só com o Centro de controlo aberto (Duo: "98%", o glifo e o nome da rede) */
      sys.innerHTML = '<i class="rl-cam"></i><div class="rl-time" role="button"></div><div class="rl-ring" role="button"></div><div class="rl-net" aria-hidden="true"><i class="rl-netg"></i><b class="rl-netn"></b></div><div class="rl-ind"></div><div class="rl-acts"></div>';
      timeEl = sys.querySelector('.rl-time'); ringEl = sys.querySelector('.rl-ring'); indEl = sys.querySelector('.rl-ind'); actsEl = sys.querySelector('.rl-acts'); netEl = sys.querySelector('.rl-net'); netSig = '';
      timeEl.setAttribute('aria-label', T('Notificações')); ringEl.setAttribute('aria-label', T('Centro de controlo'));
      /* os mesmos toques que a barra de cima tinha: hora = notificações, anel = Centro de controlo */
      timeEl.addEventListener('click', e => { e.stopPropagation(); if (window.Notify && Notify.toggle) Notify.toggle(); });
      ringEl.addEventListener('click', e => { e.stopPropagation(); if (window.CC && CC.toggle) CC.toggle(); });
      s.appendChild(sys); paintSig = ''; timeTx = ''; stNow = ''; syncSig = '';
    }
    if (!uiL || !uiL.isConnected) { uiL = document.createElement('div'); uiL.className = 'rail-apps'; s.appendChild(uiL); recs.forEach(r => { r.el = null; }); syncSig = ''; }
    return true;
  }

  /* ---------- anel de estado (o desenho das referências: arco aberto em baixo, Wi-Fi ao meio, a rede em pontos no vão) ----------
     viewBox 44×52. O arco é a BATERIA: trilho a 30 % e a carga por cima (vermelha com pouca, amarela em poupança, verde a carregar). */
  const ARC = 'M9.8 39.6a17 17 0 1 1 24.4 0', ARC_L = 79.6;   /* raio 17, 268° */
  const WIFI = '<path d="M13.4 21.8a13 13 0 0 1 17.2 0"/><path d="M16.9 26.3a8 8 0 0 1 10.2 0"/><path d="M20.4 30.8a3 3 0 0 1 3.2 0"/>';
  const DOTS = '<g fill="currentColor" stroke="none"><circle cx="13.4" cy="46.6" r="2"/><circle cx="19.1" cy="48.4" r="2"/><circle cx="24.9" cy="48.4" r="2"/><circle cx="30.6" cy="46.6" r="2"/></g>';
  const PLANE = '<path fill="currentColor" stroke="none" transform="translate(14.1 19.4) scale(.66)" d="M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z"/>';
  function ringSvg(s) {
    const b = Math.max(0, Math.min(100, Math.round(+s.battery || 0))), col = s.lowPower ? '#FFD60A' : b <= 20 ? '#FF453A' : s.charging ? '#30D158' : 'currentColor';
    const air = !!s.airplane, mid = air ? PLANE : s.wifi ? WIFI : s.cellular ? '<text x="22" y="31.6" text-anchor="middle" font-size="11" font-weight="700" fill="currentColor" stroke="none" font-family="Inter,sans-serif">5G</text>' : '';
    /* auréola (só bloqueado, CSS): os mesmos traços mais largos e escuros por baixo, para o branco se ler num fundo claro */
    const halo = `<g class="rl-halo" stroke="rgba(0,0,0,.16)" stroke-width="5"><path d="${ARC}"/>${s.wifi && !air ? WIFI.replace(/<path /g, '<path stroke-width="4.5" ') : ''}</g>`;
    return `<svg viewBox="0 0 44 52" width="62" height="73" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" aria-hidden="true">` + halo
      + `<path d="${ARC}" stroke-width="3" stroke-opacity=".3"/>` + (b > 0 ? `<path d="${ARC}" stroke-width="3" stroke="${col}" stroke-dasharray="${(ARC_L * b / 100).toFixed(2)} 200"/>` : '')
      + mid + (!air && s.cellular ? DOTS : '') + '</svg>';
  }
  function indHtml(s, ind) {
    let h = '';
    if (ind.cam || ind.mic) h += `<i class="rl-priv${ind.cam ? '' : ' mic'}"></i>`;   /* câmara (verde) ou microfone (laranja) em uso */
    if (s.dnd || (s.focus && s.focus !== 'none')) h += glyph('moon', 15);
    if (s.silent) h += glyph('bellOff', 15);
    if (s.hotspot && !s.airplane) h += glyph('link', 15);
    if (s.vpn) h += '<b class="rl-vpn">VPN</b>';
    return h;
  }
  /* System.renderStatus chama isto a cada mudança de estado: só se refaz o que mudou */
  let lastInd = {};   /* os indicadores de câmara/microfone que o System mandou da última vez (o sync repinta sem eles) */
  function paint(st, ind) {
    if (!isOn() || !build()) return;
    const s0 = st || (window.System && System.state) || {}; ind = ind || lastInd; lastInd = ind;
    /* eSIM sem linha (SIM obrigatório): o anel perde os pontos da rede e por baixo lê-se "Sem SIM" */
    const nos = !!(window.ESim && ESim.noSim && ESim.noSim()), s = nos ? Object.assign({}, s0, { cellular: false, nosim: true }) : s0;
    const sig = [nos ? 1 : 0, s.battery, s.lowPower ? 1 : 0, s.charging ? 1 : 0, s.airplane ? 1 : 0, s.wifi ? 1 : 0, s.cellular ? 1 : 0, s.dnd ? 1 : 0, s.focus || '', s.silent ? 1 : 0, s.hotspot ? 1 : 0, s.vpn ? 1 : 0, ind.cam ? 1 : 0, ind.mic ? 1 : 0, s.wifiNet || ''].join('|');
    if (sig === paintSig && ringEl.firstChild) return;
    const hadInd = indEl.childElementCount > 0;
    paintSig = sig; ringEl.innerHTML = ringSvg(s); indEl.innerHTML = indHtml(s, ind); netPaint(s);
    if ((indEl.childElementCount > 0) !== hadInd) { layout(); glassSoon(); }
    if (ov === 'cc') tick();
  }
  /* a rede por baixo do anel (só se vê com o Centro de controlo aberto, liquid27.css): o Wi-Fi e o nome da rede, senão os dados
     móveis, senão o modo de voo. Só escreve quando muda */
  function netPaint(s) {
    if (!netEl) return;
    const air = !!s.airplane, wifi = !air && !!s.wifi, cell = !air && !wifi && !!s.cellular;
    const gl = air ? 'airplane' : wifi ? 'wifi' : cell ? 'cellular' : '';
    const nm = air ? T('Modo de voo') : wifi ? String(s.wifiNet || 'Wi-Fi') : cell ? '5G' : s.nosim ? T('Sem SIM') : '';
    const sig = gl + '|' + nm; if (sig === netSig) return; netSig = sig;
    netEl.firstChild.innerHTML = gl ? glyph(gl, 20) : ''; netEl.lastChild.textContent = nm;
  }
  /* a hora (System.tick, 1 s). Com o Centro de controlo aberto mostra a bateria, como na referência */
  function tick(d) {
    if (!isOn() || !timeEl) return;
    const tx = ov === 'cc' ? Math.round(+System.state.battery || 0) + '%' : (window.UI && UI.fmtTime ? UI.fmtTime(d || new Date()) : '');
    if (tx !== timeTx) { timeTx = tx; timeEl.textContent = tx; }
  }

  /* ---------- estado: bloqueado, ecrã principal ou uma app; que botões se veem; o tom do texto ---------- */
  const stateOf = () => !isOn() ? 'off' : (System.currentApp() ? 'app' : System.locked ? 'lock' : 'home');
  function sync(force) {
    const on = isOn();
    document.body.classList.toggle('rail-on', on);
    if (!on) {
      if (adopted) restoreDock();
      /* sem barra (outro aparelho): os observadores das camadas escuras param; o watchOv volta a criá-los quando ela voltar */
      if (obs) { obs.disconnect(); obs = null; } watched.clear(); if (ov) { ov = ''; if (sys) sys.classList.remove('rl-ov', 'rl-nc'); }
      if (stNow !== 'off') { stNow = 'off'; appNow = null; syncSig = ''; if (sys) sys.dataset.st = 'off'; Bridge.emit('rail:state', { state: 'off', app: null }); }
      return;
    }
    if (!build()) return;
    watchOv();
    const st = stateOf(), cur = st === 'app' ? System.currentApp() : null, s = scrEl();
    /* o tom: o da camada a ecrã inteiro da app (spec.tone, ui.js), senão o tema da app (.light-sb) */
    const r0 = cur ? recs.get(cur) : null, tn = (r0 && r0.spec && r0.spec.tone) || '';
    const light = tn ? tn === 'light' : !!(s && s.classList.contains('light-sb'));
    const sig = [st, cur, light ? 1 : 0, tn, System.foldOpen ? 1 : 0, ov].join('|');
    if (sig === syncSig && force !== true) return;
    syncSig = sig;
    sys.dataset.st = st; uiL.dataset.st = st;
    if (sys.classList.contains('rl-dk') !== (tn === 'dark')) sys.classList.toggle('rl-dk', tn === 'dark');
    if (sys.classList.contains('rl-lk') !== (tn === 'light')) sys.classList.toggle('rl-lk', tn === 'light');
    /* só os botões da app à vista; o tom (claro/escuro) fica gravado no dela enquanto ela está à frente (ao fechar sai com o seu) */
    recs.forEach(r => {
      if (!r.el || !r.el.isConnected) renderApp(r);
      if (!r.el) return;
      const show = st === 'app' && r.id === cur && !r.spec.hidden;
      if (show) r.el.classList.toggle('rl-lt', light);
      if (r.el.classList.contains('on') !== show) r.el.classList.toggle('on', show);
    });
    if (homeSpec && (!hm || !hm.isConnected || (homeSpec.dock && homeSpec.dock.nodeType === 1 && !adopted))) renderHome();
    paint(); tick(); layout(); glassSoon();
    if (st !== stNow || cur !== appNow) { stNow = st; appNow = cur; Bridge.emit('rail:state', { state: st, app: cur }); }
  }
  /* onde começam os botões da app: por baixo da pilha de estado (que cresce com indicadores e atividades). Medido; com o
     telemóvel guardado (sem medidas) calcula-se com as medidas do CSS */
  function layout() {
    if (!sys || !uiL) return;
    let y = sys.offsetParent ? sys.offsetTop + sys.offsetHeight : 0;
    /* (as medidas do liquid27.css: topo 32 + câmara 44 + 12 fechado, 34 aberto; hora 24; anel 8 + 73; indicadores 8 + 20; atividades 10 + 52 + 8 cada) */
    if (!y) { const n = actsEl.childElementCount; y = (System.foldOpen ? 34 : 88) + 24 + 81 + (indEl.childElementCount ? 28 : 0) + (n ? 10 + n * 60 - 8 : 0); }
    const v = Math.round(y + 16) + 'px';
    /* mudou (uma atividade entrou ou saiu): os botões da app à vista voltam a ser arrumados com o topo novo (ui.js railFit) */
    if (uiL.style.getPropertyValue('--rl-top') !== v) { uiL.style.setProperty('--rl-top', v); Bridge.emit('rail:top', { top: Math.round(y + 16) }); }
  }

  /* ---------- vidro: a cópia desfocada do fundo no sítio exato de cada peça (offsets ignoram os transforms dos gestos) ---------- */
  function glassSoon() { if (gT) return; gT = requestAnimationFrame(() => { gT = 0; glassPos(); }); }
  function glassPos() {
    if (!isOn()) return; const s = scrEl(); if (!s) return;
    const list = [];
    if (sys) sys.querySelectorAll('.rl-g').forEach(n => list.push(n));
    if (hm && hm.isConnected) hm.querySelectorAll('.rl-g').forEach(n => list.push(n));
    const lk = document.getElementById('lock'); if (lk) lk.querySelectorAll('.lock-shortcuts .ls-btn').forEach(n => list.push(n));
    list.forEach(n => {
      let x = 0, y = 0, p = n; while (p && p !== s) { x += p.offsetLeft; y += p.offsetTop; p = p.offsetParent; }
      if (p !== s) return;   /* escondido (telemóvel guardado): mede-se quando voltar a aparecer */
      const gx = x + 'px', gy = y + 'px'; if (n._gx !== gx) { n._gx = gx; n.style.setProperty('--gx', gx); } if (n._gy !== gy) { n._gy = gy; n.style.setProperty('--gy', gy); }
    });
  }

  /* ---------- camadas escuras por cima (Centro de controlo, notificações, alternador, ecrãs de chamada): a pilha de estado fica branca ---------- */
  /* cada camada é observada logo que existe (nascem em alturas diferentes do arranque). Os ecrãs de chamada (phone.js, facecall.js)
     são filhos do #screen: vigia-se a lista de filhos dele e o estilo de cada ecrã (minimizar para a ilha = display:none) */
  const watched = new Set();
  const CALL = '.incoming,.call-screen,.ft-screen';
  function watchOv() {
    if (!window.MutationObserver || watched.size >= 4) return;
    if (!obs) obs = new MutationObserver(ovMut);
    let added = false;
    ['cc', 'nc', 'switcher'].forEach(i => { const el = document.getElementById(i); if (el && !watched.has(el)) { watched.add(el); obs.observe(el, { attributes: true, attributeFilter: ['class'] }); added = true; } });
    const s = scrEl(); if (s && !watched.has(s)) { watched.add(s); obs.observe(s, { childList: true }); s.querySelectorAll(':scope > .incoming,:scope > .call-screen,:scope > .ft-screen').forEach(n => obs.observe(n, { attributes: true, attributeFilter: ['style', 'class'] })); added = true; }
    if (added) ovSync();
  }
  function ovMut(list) {
    if (obs) list.forEach(r => { if (r.type === 'childList') r.addedNodes.forEach(n => { if (n.nodeType === 1 && n.matches(CALL)) obs.observe(n, { attributes: true, attributeFilter: ['style', 'class'] }); }); });
    ovSync();
  }
  function ovSync() {
    const has = id => { const e = document.getElementById(id); return !!(e && e.classList.contains('in')); };
    const s = scrEl(), call = !!s && [...s.children].some(n => n.matches(CALL) && n.style.display !== 'none');
    const v = has('cc') ? 'cc' : has('nc') ? 'nc' : has('switcher') ? 'sw' : call ? 'call' : '';
    if (v === ov) return; ov = v;
    if (sys) { sys.classList.toggle('rl-ov', !!v); sys.classList.toggle('rl-nc', v === 'nc'); }   /* rl-nc: a hora sai (o centro tem o relógio grande) */
    syncSig = ''; tick();
  }

  /* ---------- botões das apps ---------- */
  const idOf = win => !win ? null : typeof win === 'string' ? win : (win.appId || (win.dataset && win.dataset.app) || null);
  const items = g => (Array.isArray(g) ? g : [g]).filter(x => x && typeof x === 'object');
  const groupsOf = v => { if (!Array.isArray(v) || !v.length) return []; return (Array.isArray(v[0]) ? v : [v]).map(items).filter(g => g.length); };
  function norm(sp) {
    sp = sp && typeof sp === 'object' ? sp : {};
    let back = sp.back; back = typeof back === 'function' ? { onTap: back } : back && typeof back === 'object' ? Object.assign({}, back) : null;
    if (back) { back.icon = back.icon || 'chevL'; back.label = back.label || T('Voltar'); }
    /* tone: 'dark' | 'light' força o tom da coluna (camada da app a ecrã inteiro com cor própria); vazio = o tema da app */
    return { back, groups: groupsOf(sp.groups), tabs: items(Array.isArray(sp.tabs) ? sp.tabs : []), primary: groupsOf(sp.primary), hidden: !!sp.hidden, tone: sp.tone === 'dark' || sp.tone === 'light' ? sp.tone : '' };
  }
  function renderApp(r) {
    if (!isOn() || !build()) return;
    let el = r.el;
    if (!el || !el.isConnected) { el = r.el = document.createElement('div'); el.className = 'rl-app'; el.dataset.app = r.id; el.innerHTML = '<div class="rl-top"></div><div class="rl-mid"></div><div class="rl-bot"></div>'; uiL.appendChild(el); }
    const sp = r.spec, quiet = !el._built; el._built = true;   /* a primeira vez entra a camada inteira; depois só o que é novo */
    const top = []; if (sp.back) top.push({ key: 'back', items: [sp.back] }); sp.groups.forEach((g, i) => top.push({ key: 'g' + i, items: g }));
    syncBox(el.children[0], top, quiet);
    syncBox(el.children[1], sp.tabs.length ? [{ key: 'tabs', items: sp.tabs, tabs: true }] : [], quiet);
    syncBox(el.children[2], sp.primary.map((g, i) => ({ key: 'p' + i, items: g })), quiet);
  }
  /* pílulas por chave (back, g0, g1..., tabs, p0...): as que ficam atualizam-se, as novas entram, as que saem desvanecem */
  function syncBox(box, list, quiet) {
    const old = new Map(); [...box.children].forEach(n => { if (!n.classList.contains('rl-out')) old.set(n._key, n); });
    let prev = null;
    list.forEach(g => {
      let p = old.get(g.key);
      if (p) old.delete(g.key);
      else { p = document.createElement('div'); p.className = 'rl-p rl-g' + (g.tabs ? ' rl-tabs' : ''); p._key = g.key; if (!quiet) enter(p); }
      syncItems(p, g.items, quiet || !p._built); p._built = true;
      const want = prev ? prev.nextSibling : box.firstChild;
      if (p !== want) box.insertBefore(p, want);
      prev = p;
    });
    old.forEach(leave);
  }
  /* botões de uma pílula, posição a posição: o mesmo nó recebe o ícone/rótulo/estado novos (sem piscar) */
  function syncItems(p, list, quiet) {
    const kids = [...p.children].filter(n => !n.classList.contains('rl-out'));
    list.forEach((it, j) => {
      let b = kids[j];
      if (!b) { b = document.createElement('div'); b.className = 'rl-pb'; b.setAttribute('role', 'button'); bindBtn(b); p.appendChild(b); if (!quiet) enter(b); }
      updBtn(b, it);
    });
    for (let j = list.length; j < kids.length; j++) leave(kids[j]);
  }
  function updBtn(b, it) {
    b._it = it;
    const ic = typeof it.icon === 'string' ? it.icon : '';
    if (b._ic !== ic) { b._ic = ic; const bd = b.querySelector(':scope > .rl-bd'); b.innerHTML = glyph(ic, 24); if (bd) b.appendChild(bd); }
    const lb = String(it.label || ''); if (b._lb !== lb) { b._lb = lb; if (lb) b.setAttribute('aria-label', lb); else b.removeAttribute('aria-label'); }
    if (b.classList.contains('on') !== !!it.active) b.classList.toggle('on', !!it.active);
    if (b.classList.contains('dis') !== !!it.disabled) b.classList.toggle('dis', !!it.disabled);
    const tn = typeof it.tint === 'string' ? it.tint : '';
    if (b._tn !== tn) { b._tn = tn; if (/^(blue|red|green|orange)$/.test(tn)) { b.dataset.tint = tn; b.style.color = ''; } else { delete b.dataset.tint; b.style.color = /^#[0-9a-f]{3,8}$/i.test(tn) ? tn : ''; } }
    setBadge(b, it.badge);
  }
  function setBadge(b, n) {
    let x = b.querySelector(':scope > .rl-bd');
    const v = n === true ? '' : (+n > 0 ? (+n > 99 ? '99+' : String(Math.floor(+n))) : null);
    if (v == null) { if (x) x.remove(); return; }
    if (!x) { x = document.createElement('i'); x.className = 'rl-bd'; b.appendChild(x); }
    x.classList.toggle('dot', v === ''); if (x.textContent !== v) x.textContent = v;
  }
  /* toque = onTap; manter (480 ms, sem arrastar) = onHold, e o toque que vem a seguir já não conta */
  function bindBtn(b) {
    let t = null, held = false, sx = 0, sy = 0;
    const cancel = () => { clearTimeout(t); t = null; };
    b.addEventListener('pointerdown', e => { held = false; if (e.button && e.pointerType === 'mouse') return; sx = e.clientX; sy = e.clientY; cancel();
      if (b._it && typeof b._it.onHold === 'function') t = setTimeout(() => { t = null; held = true; safe(b._it && b._it.onHold, e); }, 480); });
    b.addEventListener('pointermove', e => { if (t && Math.hypot(e.clientX - sx, e.clientY - sy) > 8) cancel(); });
    b.addEventListener('pointerup', cancel); b.addEventListener('pointercancel', cancel); b.addEventListener('pointerleave', cancel);
    b.addEventListener('click', e => { e.stopPropagation(); if (held) { held = false; return; } const it = b._it; if (!it || it.disabled) return; safe(it.onTap, e); });
  }
  /* entrar e sair: só transform e opacity (motion reduzido: só opacity, liquid27.css). A classe da entrada sai no fim, para não
     voltar a correr quando o telemóvel volta a aparecer (display:none no bolso) */
  function enter(n) {
    n.classList.add('rl-in'); clearTimeout(n._inT);
    n._inT = setTimeout(() => n.classList.remove('rl-in'), 420);
  }
  function leave(n) { if (n.classList.contains('rl-out')) return; clearTimeout(n._inT); n.classList.remove('rl-in'); n.classList.add('rl-out'); setTimeout(() => n.remove(), 220); }

  function setApp(win, spec) {
    const id = idOf(win); if (!id) return null;
    const r = recs.get(id) || { id, raw: null, spec: null, el: null };
    r.raw = spec && typeof spec === 'object' ? spec : {}; r.spec = norm(r.raw); recs.set(id, r);
    if (isOn()) { renderApp(r); syncSig = ''; sync(); }
    return id;
  }
  function update(win, part) { const id = idOf(win); if (!id) return null; const r = recs.get(id); return setApp(id, Object.assign({}, (r && r.raw) || {}, part || {})); }
  function clear(win) {
    const id = idOf(win), r = id ? recs.get(id) : null; if (!r) return;
    recs.delete(id); const el = r.el; r.el = null; if (!el) return;
    if (el.classList.contains('on')) { el.classList.remove('on'); setTimeout(() => el.remove(), 280); } else el.remove();
  }
  const get = win => { const r = recs.get(idOf(win)); return r ? r.raw : null; };

  /* ---------- ecrã principal: dock vertical e pesquisa (dentro do #home) ---------- */
  function setHome(o) {
    homeSpec = o && typeof o === 'object' ? o : null;
    if (!homeSpec) { if (adopted) restoreDock(); if (hm) { hm.remove(); hm = null; } return; }
    if (isOn()) renderHome();
  }
  function renderHome() {
    const o = homeSpec; if (!o || !isOn()) return;
    const home = document.getElementById('home'); if (!home) return;
    if (!hm || !hm.isConnected) {
      hm = document.createElement('div'); hm.className = 'rl-home';
      hm.innerHTML = `<div class="rl-dwrap"></div><div class="rl-search rl-g" role="button" aria-label="${esc(T('Pesquisar'))}">${glyph('search', 24)}</div>`;
      hm.lastElementChild.addEventListener('click', e => { e.stopPropagation(); const f = homeSpec && homeSpec.onSearch; if (typeof f === 'function') safe(f, e); });
      home.appendChild(hm);
    }
    const wrap = hm.firstElementChild;
    if (o.dock && o.dock.nodeType === 1) adopt(o.dock, wrap);
    else { if (adopted) restoreDock(); ownDock(wrap, Array.isArray(o.dock) ? o.dock : []); }
    const sr = hm.lastElementChild, noS = typeof o.onSearch !== 'function'; if (sr.classList.contains('rl-none') !== noS) sr.classList.toggle('rl-none', noS);
    glassSoon();
  }
  /* a dock desenhada pela barra (ids): um .hi.app por app, com o ícone em imagem (Icons.tileBox), por id e no sítio */
  function ownDock(wrap, ids) {
    let d = wrap.querySelector(':scope > .rl-own');
    ids = ids.filter((id, i) => typeof id === 'string' && ids.indexOf(id) === i && window.App && App.get(id)).slice(0, 5);   /* até 5: mais do que isso chega às atividades */
    if (!ids.length) { if (d) d.remove(); return; }
    if (!d) { d = document.createElement('div'); d.className = 'rl-dock rl-own rl-g'; wrap.appendChild(d); }
    const have = new Map(); [...d.children].forEach(n => have.set(n.dataset.id, n));
    let prev = null;
    ids.forEach(id => {
      let n = have.get(id); const tb = Icons.tileBox(id);
      if (n) { have.delete(id); if (n._tb !== tb) { const bd = n.querySelector(':scope > .badge'); n.innerHTML = tb; n._tb = tb; if (bd) n.appendChild(bd); } }
      else {
        n = document.createElement('div'); n.className = 'hi app'; n.dataset.id = id; n.innerHTML = tb; n._tb = tb; n.setAttribute('role', 'button'); n.setAttribute('aria-label', App.name(id));
        n.addEventListener('click', e => { e.stopPropagation(); if (window.Home && Home.edit) return; System.openApp(id, n.querySelector('.tile')); });
        const bn = window.Home && Home.badges && Home.badges[id]; if (bn) setTimeout(() => System.badge(id, bn), 0);   /* o emblema que a app já tinha */
      }
      const want = prev ? prev.nextSibling : d.firstChild; if (n !== want) d.insertBefore(n, want); prev = n;
    });
    have.forEach(n => n.remove());
  }
  /* a dock da própria home (elemento): passa para a coluna e volta ao sítio quando a barra se desliga */
  function adopt(el, wrap) {
    if (adopted && adopted.el !== el) restoreDock();
    if (!adopted) adopted = { el, parent: el.parentNode, next: el.nextSibling };
    const own = wrap.querySelector(':scope > .rl-own'); if (own) own.remove();
    if (el.parentNode !== wrap) wrap.appendChild(el);
    el.classList.add('rl-dock', 'rl-g');
  }
  function restoreDock() {
    const a = adopted; adopted = null; if (!a) return;
    a.el.classList.remove('rl-dock', 'rl-g'); a.el.style.removeProperty('--gx'); a.el.style.removeProperty('--gy'); a.el._gx = a.el._gy = null;
    if (a.parent && a.parent.isConnected) a.parent.insertBefore(a.el, a.next && a.next.parentNode === a.parent ? a.next : null);
  }

  /* ---------- arranque ---------- */
  function init() {
    if (inited) return; inited = true;
    const resync = () => { syncSig = ''; sync(); };
    ['app:open', 'app:close', 'lock', 'unlock', 'form:changed', 'fold:state', 'os:changed', 'ready', 'session:changed'].forEach(ev => Bridge.on(ev, resync));
    Bridge.on('app:kill', id => { clear(id); resync(); });
    /* de volta do bolso: as medidas que ficaram por fazer (display:none) */
    Bridge.on('phone:open', () => { resync(); layout(); glassSoon(); });
    sync(true);
  }
  function refresh() { if (!isOn()) return; layout(); glassSoon(); }
  const actsBox = () => (isOn() && build()) ? actsEl : null;
  const px = v => { const n = parseFloat(v); return isFinite(n) ? n : 0; };

  /* medidas dos botões das apps na coluna (liquid27.css, Duo): círculo bt, intervalo entre pílulas gap, o grupo de baixo a bot do
     fundo, o centro dos separadores em mid. Para o ui.js railFit arrumar sem números próprios */
  const METRICS = Object.freeze({ bt: 64, gap: 16, bot: 40, mid: (956 + 38) / 2 });
  return {
    init, sync: () => sync(), tick, paint, refresh, actsBox, setHome, setApp, update, clear, get, metrics: METRICS,
    get active() { return isOn(); },
    get width() { return isOn() ? px(getComputedStyle(document.body).getPropertyValue('--rail-w')) : 0; },
    get top() { return uiL ? px(uiL.style.getPropertyValue('--rl-top')) : 0; },
    get state() { return stNow || 'off'; }
  };
})();
