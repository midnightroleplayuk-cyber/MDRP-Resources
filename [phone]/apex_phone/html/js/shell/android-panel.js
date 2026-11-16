/* ============================================================
   PAINEL RAPIDO DA NOVA UI (Android, window.QuickPanel)
   Dois paineis de ecra inteiro, como a Nova UI 8.5 com o painel dividido: puxar do topo a ESQUERDA abre as
   notificacoes, a DIREITA as definicoes rapidas, e desliza-se na horizontal de um para o outro. Tambem vive aqui a
   notificacao flutuante (.ahn-card) que aparece com o telemovel desbloqueado.

   Regras do CEF do FiveM que mandam neste ficheiro:
   - o vidro e a copia PRE-DESFOCADA do fundo (--wp-blur2 no #screen) com um veu por cima; nada de backdrop-filter nem
     filter (o CEF pinta-os a preto);
   - so transform e opacity animam; abrir e fechar seguem o dedo so com essas duas;
   - tudo e construido UMA vez e atualizado no sitio: uma notificacao nova entra sem refazer as outras, o relogio e as
     barras mudam so o texto/transform, nada anima em loop.

   Os dados e as acoes sao os do PearOS (regra de ouro: so muda a apresentacao):
   - a lista, as preferencias por app, a pre-visualizacao e as acoes vem do Notify (Notify.all + Notify._ui);
   - os mosaicos usam o MESMO codigo do Centro de controlo (CC.tile/CC.tap/CC.tileOn/CC.toggleNet/CC.level/CC.focus);
   - a musica e o window.Player (CC.music.bind/paint, o mesmo modulo do CC e do ecra bloqueado).

   API (docs/ANDROID.md): init, open(which 'notif'|'qs'), close(), toggle(which), isOpen(), pullStart(which),
   pullMove(which, p 0..1), pullEnd(which, open), e ainda back() (Voltar: sai da edicao antes de fechar),
   headsUp(n) (o notify.js chama-a) e page (o painel visivel).
   ============================================================ */
window.QuickPanel = (() => {
  const esc = UI.esc;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const isA = () => !!(window.System && System.isAndroid && System.isAndroid());
  /* largura de uma pagina (as duas ficam lado a lado na faixa): o ecra, 440 ou 670 no dobravel fechado. Com o dobravel ABERTO
     (spec_fold 3.1, 2026-10-03) e um CARTAO flutuante de cada vez, a largura de um telemovel (notificacoes 504, definicoes
     rapidas 456), posto onde o dedo comecou (terco esquerdo encostado a esquerda, meio ao centro, direito encostado a direita):
     a faixa nao desliza, a outra pagina fica escondida e deslizar na horizontal dentro do cartao troca de pagina */
  const card = () => !!(window.System && System.form === 'fold' && System.foldOpen);
  const pw = () => card() ? 0 : ((window.System && System.SW) || 440);
  /* onde o dedo tocou por ultimo (x no ecra): o puxar do topo e o da home chamam o pullStart logo a seguir */
  let lastX = null, lastXT = 0, align = 'c', swapT = null;
  function trackX(e) { const s = UI.screen(); if (!s) return; const r = s.getBoundingClientRect(); if (!r.width) return; lastX = (e.clientX - r.left) * ((window.System && System.SW) || 440) / r.width; lastXT = Date.now(); }
  function placeCard(which, fresh) {
    if (!root) return; const on = card(); if (root.classList.contains('qp-card') !== on) root.classList.toggle('qp-card', on); if (!on) return;
    const SW = (window.System && System.SW) || 1340, W = which === 'qs' ? 456 : 504;
    if (fresh) align = (lastX != null && Date.now() - lastXT < 1500) ? (lastX < SW / 3 ? 'l' : lastX > SW * 2 / 3 ? 'r' : 'c') : (which === 'qs' ? 'r' : 'c');
    const left = align === 'l' ? 16 : align === 'r' ? SW - 16 - W : Math.round((SW - W) / 2);
    root.style.setProperty('--qp-cx', left + 'px'); root.style.setProperty('--qp-cw', W + 'px');
  }
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  const num = v => { const n = +v; return isNaN(n) ? 0 : n; };
  const kz = () => (UI.zoom && UI.zoom()) || 1;
  const setText = (el, s) => { if (el && el.textContent !== s) el.textContent = s; };

  /* ---------- icones (desenho Nova UI: cheios e redondos; strings SVG no innerHTML, o parser trata do namespace) ---------- */
  const S2 = 'fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"';
  const svg = inner => `<svg viewBox="0 0 24 24" aria-hidden="true">${inner}</svg>`;
  const FP = d => `<path fill="currentColor" d="${d}"/>`;
  const SP = d => `<path ${S2} d="${d}"/>`;
  const gl = name => svg(`<g ${S2}>${(Icons.P && Icons.P[name]) || ''}</g>`);
  const SPK = 'M3.5 9.6v4.8a1 1 0 0 0 1 1h2.9l4.2 3.7a.8.8 0 0 0 1.4-.6V5.5a.8.8 0 0 0-1.4-.6L7.4 8.6H4.5a1 1 0 0 0-1 1Z';
  const IC = {
    /* Wi-Fi do kit: tres arcos e o ponto (a barra de estado continua com o leque cheio) */
    wifi: svg(SP('M2.6 9.3a13.8 13.8 0 0 1 18.8 0M5.7 12.7a9.3 9.3 0 0 1 12.6 0M8.8 16.1a4.7 4.7 0 0 1 6.4 0') + '<circle cx="12" cy="19.4" r="1.7" fill="currentColor"/>'),
    data: svg(FP('M7.6 2.6 3 8h3.3v8.2h2.6V8h3.3zM16.4 21.4 21 16h-3.3V7.8h-2.6V16h-3.3z')),
    bt: svg(SP('m6.5 7.2 11 9.6-5.5 4.7V2.5l5.5 4.7-11 9.6')),
    dnd: svg('<path fill="currentColor" fill-rule="evenodd" d="M12 2.5a9.5 9.5 0 1 1 0 19 9.5 9.5 0 0 1 0-19Zm-4.6 8.3a1.2 1.2 0 0 0 0 2.4h9.2a1.2 1.2 0 0 0 0-2.4Z"/>'),
    moon: svg(FP('M20.2 14.6A8.5 8.5 0 0 1 9.4 3.8a.6.6 0 0 0-.8-.7A9.3 9.3 0 1 0 20.9 15.4a.6.6 0 0 0-.7-.8Z')),
    work: svg(SP('M3.5 8.5h17v11h-17zM8.5 8.5V6.2A1.7 1.7 0 0 1 10.2 4.5h3.6a1.7 1.7 0 0 1 1.7 1.7v2.3M3.5 13.2h17')),
    torch: svg('<path fill="currentColor" fill-rule="evenodd" d="M7 2.5h10v2.9l-2.3 3.4v11.7a1.5 1.5 0 0 1-1.5 1.5h-2.4a1.5 1.5 0 0 1-1.5-1.5V8.8L7 5.4Zm5 9a1 1 0 0 0-1 1v2.2a1 1 0 0 0 2 0v-2.2a1 1 0 0 0-1-1Z"/>'),
    plane: svg(FP('M21.3 15.6v-1.9l-7.8-4.9V3.9a1.5 1.5 0 0 0-3 0v4.9l-7.8 4.9v1.9l7.8-2.4v5.1l-2 1.5v1.4l3.5-1 3.5 1v-1.4l-2-1.5v-5.1z')),
    sound: svg(FP(SPK) + SP('M16.2 8.8a4.6 4.6 0 0 1 0 6.4M18.9 6.2a8.4 8.4 0 0 1 0 11.6')),
    mute: svg(FP(SPK) + SP('m16.5 9.5 5 5m0-5-5 5')),
    volLow: svg(FP(SPK) + SP('M16.2 9a4.3 4.3 0 0 1 0 6')),
    saver: svg(SP('M9.6 2.8h4.8M8.3 4.8h7.4a1.7 1.7 0 0 1 1.7 1.7v12.8a1.7 1.7 0 0 1-1.7 1.7H8.3a1.7 1.7 0 0 1-1.7-1.7V6.5a1.7 1.7 0 0 1 1.7-1.7Z') + FP('M9.4 14h5.2v4a.7.7 0 0 1-.7.7H10.1a.7.7 0 0 1-.7-.7Z')),
    share: svg('<circle cx="6.5" cy="12" r="2.6" fill="currentColor"/><circle cx="17.5" cy="6" r="2.6" fill="currentColor"/><circle cx="17.5" cy="18" r="2.6" fill="currentColor"/>' + SP('m8.8 10.8 6.4-3.6m-6.4 6 6.4 3.6')),
    loc: svg('<path fill="currentColor" fill-rule="evenodd" d="M12 2a7.6 7.6 0 0 1 7.6 7.6c0 5.3-6.2 11.7-6.9 12.4a1 1 0 0 1-1.4 0c-.7-.7-6.9-7.1-6.9-12.4A7.6 7.6 0 0 1 12 2Zm0 4.7a2.9 2.9 0 1 0 0 5.8 2.9 2.9 0 0 0 0-5.8Z"/>'),
    hotspot: svg('<circle cx="12" cy="12" r="2.3" fill="currentColor"/>' + SP('M8.3 15.7a5.2 5.2 0 0 1 0-7.4m7.4 0a5.2 5.2 0 0 1 0 7.4M5.4 18.6a9.3 9.3 0 0 1 0-13.2m13.2 0a9.3 9.3 0 0 1 0 13.2')),
    dark: svg(SP('M12 3.5a8.5 8.5 0 1 0 0 17 8.5 8.5 0 0 0 0-17Z') + FP('M12 3.5a8.5 8.5 0 0 1 0 17Z')),
    eye: svg(SP('M2.5 12S6 5.5 12 5.5 21.5 12 21.5 12 18 18.5 12 18.5 2.5 12 2.5 12Z') + '<circle cx="12" cy="12" r="3.2" fill="currentColor"/>'),
    rotate: svg(SP('M20 11.5A8 8 0 0 0 6.2 6.4M4 12.5a8 8 0 0 0 13.8 5.1M6.5 2.8v3.8h3.8M17.5 21.2v-3.8h-3.8') + '<rect x="9.3" y="8.6" width="5.4" height="6.8" rx="1.2" fill="currentColor"/>'),
    buds: gl('earbuds'), timer: gl('timer'), calc: gl('calc'), cam: gl('camera'), vera: gl('sparkles'), note: gl('compose'), card: gl('card'), alarm: gl('alarm'),
    edit: svg(SP('M4 20h4.2L19.4 8.8a2.3 2.3 0 0 0-3.2-3.2L5 16.8V20ZM14.6 7.2l3.2 3.2')),
    power: gl('power'), gear: gl('gear'),
    sun: svg('<circle cx="12" cy="12" r="4.3" fill="currentColor"/>' + SP('M12 2.6v1.8M12 19.6v1.8M2.6 12h1.8M19.6 12h1.8M5.4 5.4l1.3 1.3M17.3 17.3l1.3 1.3M5.4 18.6l1.3-1.3M17.3 6.7l1.3-1.3')),
    chev: svg(SP('m6.5 9.5 5.5 5.5 5.5-5.5')),
    shuffle: gl('shuffle'), prev: gl('prev'), next: gl('next'),
    open: svg(SP('M14 4h6v6M20 4l-8.5 8.5M18 14v4.5a1.5 1.5 0 0 1-1.5 1.5h-11A1.5 1.5 0 0 1 4 18.5v-11A1.5 1.5 0 0 1 5.5 6H10')),
    phone: gl('phoneFill'), hang: gl('phoneDown'), x: gl('x'), nav: svg(FP('M12 2.5 19.5 20.5 12 16.6 4.5 20.5Z')), spark: gl('activity'),
    handset: svg('<rect x="7" y="2.5" width="10" height="19" rx="2.6" ' + S2 + '/>' + SP('M10.5 18.5h3')),
    /* dobravel: o aparelho aberto (largo, com a dobradica) e fechado (em pe) */
    unfold: svg('<rect x="2.5" y="5" width="19" height="14" rx="2.6" ' + S2 + '/>' + '<path ' + S2 + ' stroke-dasharray="2 2.2" d="M12 5v14"/>'),
    refold: svg('<rect x="6.5" y="3" width="11" height="18" rx="2.6" ' + S2 + '/>' + SP('M10.5 18h3')),
  };
  IC.vol = IC.sound;

  /* ---------- mosaicos: apresentacao da Nova UI por cima das acoes partilhadas do control.js ----------
     go = pagina das Definicoes aberta pelo toque longo (e pelo texto dos mosaicos grandes); app = atalho (sem estado) */
  const QT = {
    wifi: { label: () => T('Wi-Fi'), icon: () => IC.wifi, sub: S => S.airplane ? T('Modo de voo') : S.wifi ? (S.wifiNet || T('Ligado')) : T('Desligado'), go: 'wifi' },
    cellular: { label: () => T('Dados móveis'), icon: () => IC.data, sub: S => S.airplane ? T('Modo de voo') : S.cellular ? T('Ligados') : T('Desligados') },
    bt: { label: () => T('Bluetooth'), icon: () => IC.bt, sub: S => !S.bt ? T('Desligado') : S.earbuds ? ((window.Earbuds && Earbuds.NAME) || T('Ligado')) : T('Ligado'), go: 'bt' },
    dnd: { label: () => { const f = CC.focus.of(); return f === 'work' || f === 'sleep' ? T(CC.focus.NAMES[f]) : T('Não incomodar'); },
      icon: () => { const f = CC.focus.of(); return f === 'sleep' ? IC.moon : f === 'work' ? IC.work : IC.dnd; },
      sub: () => CC.focus.of() === 'none' ? T('Desligado') : T('Ligado'), long: () => CC.focus.pick(), go: 'focus' },
    torch: { label: () => T('Lanterna'), icon: () => IC.torch },
    airplane: { label: () => T('Modo de voo'), icon: () => IC.plane },
    silent: { label: S => S.silent ? T('Silêncio') : T('Som'), icon: S => S.silent ? IC.mute : IC.sound, sub: S => S.silent ? T('Silêncio') : T('Som'), go: 'sounds' },
    lowpower: { label: () => T('Poupança de energia'), icon: () => IC.saver, go: 'battery' },
    airdrop: { label: () => T('Partilha rápida'), icon: () => IC.share },
    location: { label: () => T('Localização'), icon: () => IC.loc, go: 'location' },   /* as Definições do Android tem a pagina Localizacao propria */
    hotspot: { label: () => T('Ponto de acesso'), icon: () => IC.hotspot },
    darkmode: { label: () => T('Modo escuro'), icon: () => IC.dark, go: 'display' },
    eyecomfort: { label: () => T('Conforto visual'), icon: () => IC.eye, go: 'display' },
    rotate: { label: () => T('Rotação'), icon: () => IC.rotate },
    earbuds: { label: () => T('Auriculares'), icon: () => IC.buds, sub: S => S.earbuds ? T('Ligados') : T('Desligados'), go: 'bt' },
    timer: { label: () => T('Temporizador'), icon: () => IC.timer, app: true },
    calc: { label: () => App.name('calculator'), icon: () => IC.calc, app: true },
    camera: { label: () => App.name('camera'), icon: () => IC.cam, app: true },
    vera: { label: () => 'Vera', icon: () => IC.vera, app: true },
    notes: { label: () => T('Nota rápida'), icon: () => IC.note, app: true },
    wallet: { label: () => App.name('wallet'), icon: () => IC.card, app: true },
    alarm: { label: () => T('Alarme'), icon: () => IC.alarm, app: true },
  };
  /* de origem: Wi-Fi e dados (quadrados), Bluetooth (meio); ao lado dos sliders Lanterna (meio), Nao incomodar e modo de
     voo (quadrados) e Localizacao (meio); os redondos no cartao, quatro por linha. Modo escuro e Silencio ja sao os
     circulos dos sliders (continuam disponiveis na edicao). */
  const DEF = ['wifi', 'cellular', 'bt', 'torch', 'dnd', 'airplane', 'location', 'lowpower', 'airdrop', 'hotspot', 'eyecomfort', 'rotate', 'earbuds', 'timer', 'calc', 'camera', 'vera'];
  const ALL = DEF.concat(['silent', 'darkmode', 'notes', 'wallet', 'alarm']);
  const known = k => !!(QT[k] && window.CC && CC.tile && CC.tile(k));
  /* System.state.qsTiles: null = os de origem; um array estragado (ids que ja nao existem, repetidos) e limpo aqui */
  function order() {
    const v = System.state.qsTiles; if (!Array.isArray(v)) return DEF.filter(known);
    const out = []; v.forEach(k => { if (typeof k === 'string' && known(k) && !out.includes(k)) out.push(k); }); return out;
  }
  /* Nova UI 8.5: cada botao dos lugares grandes e 1x1 (so o circulo) ou 2x1 (circulo + nome + estado), a escolha do jogador na
     edicao (a pega da direita alarga ou estreita). System.state.qsWide: null = os de origem (Bluetooth, Lanterna e Localizacao
     largos, como o kit); so ids conhecidos contam */
  const DEF_WIDE = ['bt', 'torch', 'location'];
  function wideSet() { const v = System.state.qsWide; const src = Array.isArray(v) ? v : DEF_WIDE; const s = new Set(); src.forEach(k => { if (typeof k === 'string' && QT[k]) s.add(k); }); return s; }

  /* ---------- estado ---------- */
  let root = null, bgEl = null, slideEl = null, trackEl = null, built = false;
  const R = {};                                     /* nos que se leem muitas vezes */
  let page = 'notif', opened = false, pulling = null, closeT = null, tickT = null, tickN = 0;
  let editing = false, work = null, workWide = null, td = null, slDrag = null;
  let cardDrag = false, eatClick = 0, gs = null;
  const expanded = new Set();                       /* 'g:<grupo>' grupos abertos, 'n:<id>' notificacoes abertas */
  const tileNodes = new Map(), itemNodes = new Map(), groupNodes = new Map(), liveNodes = new Map();

  /* ---------- data e hora do cabecalho ("Qui, 1 de outubro", como a Nova UI) ---------- */
  function dateTxt(d) {
    if (window.L && L.code !== 'pt') { try { return new Intl.DateTimeFormat(L.intl(), { weekday: 'short', day: 'numeric', month: 'long' }).format(d); } catch (e) {} }
    return `${UI.DIAS_C[d.getDay()]}, ${d.getDate()} de ${UI.MESES[d.getMonth()]}`;
  }
  function paintHeader() { if (!root) return; const d = new Date(), t = UI.fmtTime(d), dt = dateTxt(d); root.querySelectorAll('.qp-time').forEach(e => setText(e, t)); root.querySelectorAll('.qp-date').forEach(e => setText(e, dt)); }

  /* ============================================================
     CONSTRUCAO (uma vez, so no Android)
     ============================================================ */
  const NOTIF_PAGE = () => `<div class="qp-scroll">
      <header class="qp-top"><div class="qp-clock"><b class="qp-time"></b><span class="qp-date"></span></div></header>
      <div class="qp-sec qp-sec-live qp-hide" data-fk="s:live"><div class="qp-label">${esc(T('Notificações em direto'))}</div><div class="qp-live"></div></div>
      <div class="qp-sec qp-sec-main qp-hide" data-fk="s:main"><div class="qp-lrow"><div class="qp-label">${esc(T('Notificações'))}</div><span class="qp-lclear" role="button">${esc(T('Limpar'))}</span></div><div class="qp-groups"></div></div>
      <div class="qp-sec qp-sec-silent qp-hide" data-fk="s:silent"><div class="qp-label">${esc(T('Silenciosas'))}</div><div class="qp-groups"></div></div>
      <div class="qp-empty qp-hide">${esc(T('Sem notificações'))}</div>
      <div class="qp-foot qp-hide" data-fk="foot"><span class="qp-nset">${esc(T('Definições de notificações'))}</span><span class="qp-clear">${esc(T('Limpar tudo'))}</span></div>
      <div class="qp-handle" data-fk="handle"></div>
    </div>`;
  /* definicoes rapidas como o painel da Nova UI 8.5: uma grelha de 4 colunas (88 px, espaco 18). Linha 1: quatro celulas;
     linha 2: o cartao dos redondos (4 por linha, fechado mostra so a primeira, a pega abre o resto); linhas 3 a 5: os dois
     sliders verticais (88 x 300) e, ao lado, tres linhas de duas celulas. Sao 10 celulas: um botao largo (2x1) ocupa duas da
     mesma linha, um quadrado (1x1) uma; cada botao entra na primeira linha onde cabe (como uma grelha densa) e os que ja nao
     cabem vao para o cartao dos redondos. */
  const ROWS = [{ r: 1, c0: 1, n: 4 }, { r: 3, c0: 3, n: 2 }, { r: 4, c0: 3, n: 2 }, { r: 5, c0: 3, n: 2 }];
  function pack(list, wide) {
    const used = ROWS.map(() => 0), big = [], rest = [];
    list.forEach(k => {
      const w = wide && wide.has(k) ? 2 : 1; let i = -1;
      for (let j = 0; j < ROWS.length; j++) { if (ROWS[j].n - used[j] >= w) { i = j; break; } }
      if (i < 0) { rest.push(k); return; }
      big.push({ k, w, r: ROWS[i].r, c: ROWS[i].c0 + used[i] }); used[i] += w;
    });
    return { big, rest };
  }
  const VSL = (key, label, bt, btLabel, btIcon) => `<div class="qp-vs" data-k="${key}" data-fk="q:${key}">
        <div class="qp-sl qp-noswipe" data-key="${key}" role="slider" aria-label="${esc(label)}"><div class="qp-slf"><i class="qp-sli">${key === 'brightness' ? IC.sun : IC.vol}</i></div></div>
        <i class="qp-vsb qp-noswipe" data-t="${bt}" role="button" aria-label="${esc(btLabel)}">${btIcon}</i></div>`;
  const QS_PAGE = () => `<div class="qp-scroll">
      <header class="qp-top qp-qtop"><div class="qp-clock"><b class="qp-time"></b><span class="qp-date"></span></div>
        <div class="qp-acts"><i class="qp-ab qp-a-edit" data-tip="${esc(T('Editar'))}">${IC.edit}</i><i class="qp-ab qp-a-pow">${IC.power}</i><i class="qp-ab qp-a-set">${IC.gear}</i></div>
        <div class="qp-ebar"><span class="qp-e-reset">${esc(T('Repor'))}</span><b class="qp-e-title">${esc(T('Editar botões'))}</b><span class="qp-e-done">${esc(T('Concluído'))}</span></div></header>
      <div class="qp-ehint">${esc(T('Toca num botão para o retirar e arrasta para mudar a ordem. Puxa a pega de um botão grande para o alargar ou estreitar.'))}</div>
      <div class="qp-tbig">
        <div class="qp-rcard qp-short" data-fk="q:rnd"><div class="qp-trnd"></div><i class="qp-more qp-noswipe" role="button" aria-label="${esc(T('Mais botões'))}"></i></div>
        ${VSL('brightness', T('Brilho'), 'darkmode', T('Modo escuro'), IC.moon)}
        ${VSL('volume', T('Volume'), 'silent', T('Silêncio'), IC.mute)}
      </div>
      <div class="qp-foldw" data-fk="q:fold"><div class="qp-fold" role="button"><i class="qp-fold-ic"></i><div class="qp-fold-tx"><b></b><span></span></div></div></div>
      <div class="qp-availw"><div class="qp-label">${esc(T('Botões disponíveis'))}</div><div class="qp-rcard"><div class="qp-avail"></div></div></div>
      <div class="qp-media qp-media-q" data-fk="q:media"></div>
      <div class="qp-cards" data-fk="q:cards">
        <div class="qp-cd qp-cd-out" role="button"><i class="qp-cd-ic"></i><div class="qp-cd-tx"><span>${esc(T('Saída de som'))}</span><b></b></div></div>
        <div class="qp-cd qp-cd-dev" role="button"><i class="qp-cd-ic"></i><div class="qp-cd-tx"><span>${esc(T('Dispositivos'))}</span><b></b></div></div>
      </div>
      <div class="qp-handle" data-fk="q:handle"></div>
    </div>`;

  function build() {
    if (built && root && root.isConnected) return true;
    const scr = UI.screen(); if (!scr || !isA()) return false;
    if (root && !root.isConnected) { tileNodes.clear(); itemNodes.clear(); groupNodes.clear(); liveNodes.clear(); }
    root = UI.el(`<div id="qp" class="qp" aria-hidden="true"><div class="qp-bg"></div><div class="qp-slide"><div class="qp-track"><section class="qp-page qp-pn">${NOTIF_PAGE()}</section><section class="qp-page qp-pq">${QS_PAGE()}</section></div></div></div>`);
    scr.appendChild(root);
    bgEl = root.querySelector('.qp-bg'); slideEl = root.querySelector('.qp-slide'); trackEl = root.querySelector('.qp-track');
    R.pn = root.querySelector('.qp-pn'); R.pq = root.querySelector('.qp-pq');
    R.nScroll = R.pn.querySelector('.qp-scroll'); R.qScroll = R.pq.querySelector('.qp-scroll');
    R.secLive = R.pn.querySelector('.qp-sec-live'); R.live = R.pn.querySelector('.qp-live');
    R.secMain = R.pn.querySelector('.qp-sec-main'); R.gMain = R.secMain.querySelector('.qp-groups'); R.mainLbl = R.secMain.querySelector('.qp-label');
    R.secSilent = R.pn.querySelector('.qp-sec-silent'); R.gSilent = R.secSilent.querySelector('.qp-groups');
    R.empty = R.pn.querySelector('.qp-empty'); R.foot = R.pn.querySelector('.qp-foot');
    R.tbig = R.pq.querySelector('.qp-tbig'); R.trnd = R.pq.querySelector('.qp-trnd'); R.avail = R.pq.querySelector('.qp-avail');
    R.media = R.pq.querySelector('.qp-media-q');
    /* cartoes de baixo (Nova UI 8.5): saida de som (este telemovel ou os auriculares) e dispositivos ligados; os dois abrem as
       Definicoes na pagina certa */
    R.cards = R.pq.querySelector('.qp-cards'); R.cdOut = R.cards.querySelector('.qp-cd-out'); R.cdDev = R.cards.querySelector('.qp-cd-dev');
    R.cdOut.onclick = e => { e.stopPropagation(); if (Date.now() < eatClick || editing) return; Sound.play('click'); goSettings('sounds'); };
    R.cdDev.onclick = e => { e.stopPropagation(); if (Date.now() < eatClick || editing) return; Sound.play('click'); goSettings('bt'); };
    /* "Limpar" no cabecalho das notificacoes: so as desta seccao (as silenciosas ficam); "Limpar tudo" do rodape leva todas */
    R.secMain.querySelector('.qp-lclear').onclick = e => { e.stopPropagation(); clearMain(); };
    /* dobravel: "Abrir ecra" / "Fechar ecra" (fixo, fora da lista editavel; so se ve com body.form-fold, oneui-panel.css) */
    R.fold = R.pq.querySelector('.qp-fold');
    R.fold.onclick = e => { e.stopPropagation(); if (Date.now() < eatClick || editing) return; Sound.play('click'); if (window.CC && CC.tap) CC.tap('fold'); };
    /* rodape do painel de notificacoes */
    R.foot.querySelector('.qp-clear').onclick = e => { e.stopPropagation(); clearAll(); };
    R.foot.querySelector('.qp-nset').onclick = e => { e.stopPropagation(); Sound.play('click'); goSettings('notifications'); };
    /* cabecalho das definicoes rapidas: editar, desligar, Definicoes */
    R.pq.querySelector('.qp-a-edit').onclick = e => { e.stopPropagation(); startEdit(); };
    R.pq.querySelector('.qp-a-pow').onclick = e => { e.stopPropagation(); Sound.play('click'); close(); if (window.Hardware && Hardware.showPowerOff) setTimeout(() => Hardware.showPowerOff(), 160); };
    R.pq.querySelector('.qp-a-set').onclick = e => { e.stopPropagation(); Sound.play('click'); goSettings(null); };
    R.pq.querySelector('.qp-e-done').onclick = e => { e.stopPropagation(); Sound.play('click'); exitEdit(true); };
    R.pq.querySelector('.qp-e-reset').onclick = e => { e.stopPropagation(); Sound.play('click'); if (!editing) return; const before = snapTiles(); work = DEF.filter(known); workWide = new Set(DEF_WIDE); renderEdit(); flipTiles(before, null); };
    root.querySelectorAll('.qp-handle').forEach(h => { h.onclick = e => { e.stopPropagation(); close(); }; });
    R.pq.querySelectorAll('.qp-sl').forEach(bindSlider);
    /* o circulo por baixo de cada slider: modo escuro (brilho) e silencio (volume), as mesmas acoes dos mosaicos */
    R.pq.querySelectorAll('.qp-vsb').forEach(b => { b.addEventListener('pointerdown', e => e.stopPropagation()); b.onclick = e => { e.stopPropagation(); if (Date.now() < eatClick || editing) return; tapTile(b.dataset.t); }; });
    /* pega do cartao dos redondos: mostra so a primeira linha ou todas (os de baixo deslizam por FLIP) */
    R.rcard = R.trnd.parentElement; R.more = R.rcard.querySelector('.qp-more');
    R.more.addEventListener('pointerdown', e => e.stopPropagation());
    R.more.onclick = e => { e.stopPropagation(); if (Date.now() < eatClick || editing) return; Sound.play('click'); const before = snapshot(R.qScroll); R.rcard.classList.toggle('qp-short'); flip(R.qScroll, before); };
    bindPanelGestures();
    bindEditDrag();
    built = true;
    layoutTiles(order());
    return true;
  }

  /* ============================================================
     ABRIR / FECHAR / PUXAR
     ============================================================ */
  function setPage(p, anim) {
    p = p === 'qs' ? 'qs' : 'notif';
    /* cartao (dobravel aberto): a troca de pagina desvanece o cartao, muda-lhe a largura e volta a acender (so opacidade) */
    if (card() && anim && root && root.classList.contains('in') && p !== page) {
      clearTimeout(swapT); slideEl.classList.add('qp-swap');
      swapT = setTimeout(() => { swapT = null; setPage(p, false); slideEl.classList.remove('qp-swap'); }, 130);
      return;
    }
    page = p;
    if (!trackEl) return;
    trackEl.classList.toggle('qp-noanim', !anim);
    trackEl.style.transform = `translateX(${page === 'qs' ? -pw() : 0}px)`;
    if (!anim) { void trackEl.offsetWidth; trackEl.classList.remove('qp-noanim'); }
    root.classList.toggle('qp-on-qs', page === 'qs');
    placeCard(page, false);
    if (page !== 'qs' && editing) exitEdit(true);
  }
  /* o #screen sabe que o painel esta aberto: a barra de estado escurece no tema claro (oneui-panel.css) */
  const screenCls = on => { const s = UI.screen(); if (s) s.classList.toggle('qp-open', !!on); };
  function prepare(which) {
    clearTimeout(closeT); closeT = null; clearTimeout(swapT); swapT = null; if (slideEl) slideEl.classList.remove('qp-swap');
    if (hu) hu.hide(true);                          /* a notificacao flutuante recolhe para dentro do painel */
    placeCard(which, true);
    setPage(which, false);
    renderAll(false);
    R.nScroll.scrollTop = 0; R.qScroll.scrollTop = 0;
    root.classList.add('on'); root.setAttribute('aria-hidden', 'false'); screenCls(true);
  }
  function open(which, opts) {
    if (!isA() || !build()) return;
    which = which === 'qs' ? 'qs' : 'notif'; opts = opts || {};
    if (opened) { if (page !== which) setPage(which, true); return; }
    pulling = null; root.classList.remove('pulling'); clearPullStyle();
    prepare(which); void root.offsetWidth;
    opened = true; root.classList.add('in');
    startTick(); if (!opts.silent) Sound.play('pop');
    Bridge.emit('overlay', 'qp');
  }
  function close() {
    if (!root) return;
    if (pulling) { pulling = null; root.classList.remove('pulling'); clearPullStyle(); }
    if (editing) exitEdit(true);
    if (!opened && !root.classList.contains('on')) return;
    opened = false; gs = null; cardDrag = false;
    root.classList.remove('in', 'qp-dragging'); slideEl.style.transform = ''; bgEl.style.opacity = ''; trackEl.style.transform = `translateX(${page === 'qs' ? -pw() : 0}px)`;
    screenCls(false); stopTick();
    clearTimeout(closeT); closeT = setTimeout(() => { closeT = null; if (!opened && !pulling) { root.classList.remove('on'); root.setAttribute('aria-hidden', 'true'); } }, 360);
  }
  function toggle(which) {
    which = which === 'qs' ? 'qs' : 'notif';
    if (opened) { if (page === which) close(); else setPage(which, true); return; }
    open(which);
  }
  /* Voltar do Android: primeiro sai da edicao dos botoes, depois fecha o painel. true = o Voltar foi gasto aqui */
  function back() { if (editing) { exitEdit(true); return true; } if (opened || pulling) { close(); return true; } return false; }

  /* puxar do topo (gestures.js / home.js): o painel segue o dedo so com transform e opacity */
  function applyPull(p) {
    p = clamp(num(p), 0, 1);
    bgEl.style.opacity = p.toFixed(3);
    slideEl.style.opacity = Math.min(1, p * 1.25).toFixed(3);
    slideEl.style.transform = `translateY(${(-(1 - p) * 64).toFixed(1)}px)`;
  }
  function clearPullStyle() { if (!bgEl) return; bgEl.style.opacity = ''; slideEl.style.opacity = ''; slideEl.style.transform = ''; }
  function pullStart(which) {
    if (!isA() || !build()) return;
    which = which === 'qs' ? 'qs' : 'notif';
    if (opened) { if (page !== which) setPage(which, true); pulling = { which, was: true }; return; }
    pulling = { which, was: false };
    root.classList.add('pulling'); root.classList.remove('in');
    prepare(which); applyPull(0);
  }
  function pullMove(which, p) { if (!pulling || pulling.was || !root) return; applyPull(p); }
  function pullEnd(which, isOpen) {
    if (!pulling || !root) return; const was = pulling.was; pulling = null;
    if (was) return;
    root.classList.remove('pulling');
    clearPullStyle();                               /* a transicao volta e o painel segue do ponto onde o dedo o deixou */
    if (isOpen) { opened = true; root.classList.add('in'); startTick(); Sound.play('pop'); Bridge.emit('overlay', 'qp'); }
    else { root.classList.remove('in'); screenCls(false); clearTimeout(closeT); closeT = setTimeout(() => { closeT = null; if (!opened && !pulling) { root.classList.remove('on'); root.setAttribute('aria-hidden', 'true'); } }, 360); }
  }

  /* ---------- relogio do painel aberto (1 s): so texto e transform, nada se reconstroi ---------- */
  function startTick() { stopTick(); tickN = 0; tickT = setInterval(tick, 1000); }
  function stopTick() { clearInterval(tickT); tickT = null; }
  function tick() {
    if (!opened || !root) { stopTick(); return; }
    tickN++;
    try { paintHeader(); renderLive(true); paintMedia(R.media); if (tickN % 20 === 0) paintTimes(); } catch (e) { console.error('[apex_phone] QuickPanel tick', e); }
  }
  function renderAll(anim) {
    paintHeader();
    renderNotifs(anim); renderLive(anim);
    if (!editing) layoutTiles(order()); paintTiles(); paintSliders(); paintMedia(R.media); paintCards();
  }

  /* ============================================================
     GESTOS DO PAINEL: deslizar na horizontal muda de pagina; na vertical arrasta o conteudo (com o rato nao ha
     scroll por arrasto) e, no fim do conteudo, puxar para cima fecha o painel. Tocar no vazio fecha.
     ============================================================ */
  function bindPanelGestures() {
    root.addEventListener('pointerdown', e => {
      if (!opened || (e.button > 0 && e.pointerType === 'mouse')) return;
      if (e.target.closest('.qp-noswipe, .cc-bar')) return;
      if (editing && e.target.closest('.qp-t')) return;
      const sc = page === 'qs' ? R.qScroll : R.nScroll;
      const W = pw();
      gs = { id: e.pointerId, x0: e.clientX, y0: e.clientY, ax: null, sc, st0: sc.scrollTop, lx: e.clientX, ly: e.clientY, lt: Date.now(), vx: 0, vy: 0, base: page === 'qs' ? -W : 0, w: W, x: null, over: 0, card: card() };
    });
    root.addEventListener('pointermove', e => {
      if (!gs || e.pointerId !== gs.id) return;
      const k = kz(), dx = (e.clientX - gs.x0) / k, dy = (e.clientY - gs.y0) / k, now = Date.now(), dt = Math.max(1, now - gs.lt);
      gs.vx = (e.clientX - gs.lx) / k / dt; gs.vy = (e.clientY - gs.ly) / k / dt; gs.lx = e.clientX; gs.ly = e.clientY; gs.lt = now;
      if (!gs.ax) {
        if (cardDrag || td) { gs = null; return; }   /* um cartao (ou um botao em edicao) ficou com o gesto */
        if (Math.hypot(dx, dy) < 8) return;
        gs.ax = Math.abs(dx) > Math.abs(dy) * 1.15 ? 'x' : 'y';
        if (gs.ax === 'x' && (editing || (!gs.w && !gs.card))) { gs = null; return; }   /* na edicao a pagina fica parada */
        try { root.setPointerCapture(gs.id); } catch (x) {}
        root.classList.add('qp-dragging');
      }
      /* cartao (dobravel aberto): o cartao segue um pouco o dedo; ao largar troca de pagina (setPage desvanece e volta) */
      if (gs.ax === 'x' && gs.card) { gs.x = dx; slideEl.style.transform = `translateX(${(dx * .18).toFixed(1)}px)`; return; }
      if (gs.ax === 'x') {
        const W = gs.w; let x = gs.base + dx; if (x > 0) x *= .22; else if (x < -W) x = -W + (x + W) * .22;
        gs.x = x; trackEl.style.transform = `translateX(${x.toFixed(1)}px)`; return;
      }
      const sc = gs.sc, max = Math.max(0, sc.scrollHeight - sc.clientHeight), want = gs.st0 - dy;
      if (want > max) { sc.scrollTop = max; gs.over = want - max; slideEl.style.transform = `translateY(${(-gs.over).toFixed(1)}px)`; bgEl.style.opacity = clamp(1 - gs.over / 520, .25, 1).toFixed(3); }
      else { sc.scrollTop = Math.max(0, want); if (gs.over) { gs.over = 0; slideEl.style.transform = ''; bgEl.style.opacity = ''; } }
    });
    const up = e => {
      if (!gs || e.pointerId !== gs.id) return; const s = gs; gs = null;
      if (!s.ax) return;
      eatClick = Date.now() + 150;
      try { root.releasePointerCapture(s.id); } catch (x) {}
      root.classList.remove('qp-dragging');
      if (s.ax === 'x' && s.card) {
        slideEl.style.transform = ''; const dx = s.x || 0;
        const to = (dx < -70 || s.vx < -.35) ? 'qs' : (dx > 70 || s.vx > .35) ? 'notif' : page;
        if (to !== page) { Sound.play('tick'); setPage(to, true); }
        return;
      }
      if (s.ax === 'x') {
        const x = s.x == null ? s.base : s.x;
        const to = s.vx < -.35 ? 'qs' : s.vx > .35 ? 'notif' : (x < -s.w / 2 ? 'qs' : 'notif');
        if (to !== page) Sound.play('tick');
        setPage(to, true); return;
      }
      if (s.over > 0) { const shut = s.over > 90 || s.vy < -.55; slideEl.style.transform = ''; bgEl.style.opacity = ''; if (shut) close(); }
    };
    root.addEventListener('pointerup', up); root.addEventListener('pointercancel', up);
    /* o clique que o browser dispara no fim de um arrasto e engolido; tocar no vazio (fora de cartoes e botoes) fecha */
    root.addEventListener('click', e => {
      if (Date.now() < eatClick) { e.stopPropagation(); e.preventDefault(); return; }
      const t = e.target; if (!t || !t.classList) return;
      if (t === root || t.classList.contains('qp-scroll') || t.classList.contains('qp-page') || t.classList.contains('qp-track') || t.classList.contains('qp-slide') || t.classList.contains('qp-bg') || t.classList.contains('qp-empty')) { if (!editing) close(); }
    }, true);
  }

  /* ---------- FLIP: quem muda de sitio parte da posicao antiga e volta a 0 por transform (nunca height/top) ----------
     Os elementos aninhados (seccao > grupo > notificacao) descontam o deslocamento do pai, senao andavam a dobrar. */
  function snapshot(box) { const m = new Map(); if (!box) return m; box.querySelectorAll('[data-fk]').forEach(e => { if (e.offsetParent !== null) m.set(e.dataset.fk, e.getBoundingClientRect().top); }); return m; }
  function flip(box, before) {
    if (!box || !before || !before.size) return;
    const k = kz(), after = new Map(), els = [];
    box.querySelectorAll('[data-fk]').forEach(e => { if (e.offsetParent !== null) { after.set(e.dataset.fk, e.getBoundingClientRect().top); els.push(e); } });
    const delta = e => { const b = before.get(e.dataset.fk), a = after.get(e.dataset.fk); return b == null || a == null ? 0 : (b - a) / k; };
    const moved = [];
    els.forEach(e => {
      if (!before.has(e.dataset.fk)) return; let d = delta(e);
      const p = e.parentElement && e.parentElement.closest('[data-fk]'); if (p && box.contains(p) && before.has(p.dataset.fk)) d -= delta(p);
      if (Math.abs(d) > .5) moved.push([e, d]);
    });
    if (!moved.length) return;
    moved.forEach(([e, d]) => { e.style.transition = 'none'; e.style.transform = `translateY(${d.toFixed(1)}px)`; });
    void box.offsetWidth;
    moved.forEach(([e]) => { e.style.transition = 'transform .34s var(--ou-curve-out, ease-out)'; e.style.transform = ''; });
    setTimeout(() => moved.forEach(([e]) => { if (!e.style.transform) e.style.transition = ''; }), 400);
  }

  /* ============================================================
     PAINEL DE NOTIFICACOES
     ============================================================ */
  const N = () => (window.Notify && Notify._ui) || null;
  function renderNotifs(anim) {
    if (!built || !window.Notify) return;
    const before = anim ? snapshot(R.nScroll) : null;
    const list = Notify.all(); const main = [], silent = [], groups = new Map();
    list.forEach(n => {
      const sil = n.type === 'silent', key = (sil ? 's:' : 'm:') + n.app;
      let gr = groups.get(key); if (!gr) { gr = { key, app: n.app, items: [] }; groups.set(key, gr); (sil ? silent : main).push(gr); }
      if (gr.items.length < 40) gr.items.push(n);
    });
    const live = new Set(list.map(n => n.id)); [...itemNodes.keys()].forEach(id => { if (!live.has(id)) itemNodes.delete(id); });
    [...groupNodes.keys()].forEach(k => { if (!groups.has(k)) groupNodes.delete(k); });
    [...expanded].forEach(k => { if (k.startsWith('n:') ? !live.has(+k.slice(2)) : !groups.has(k.slice(2))) expanded.delete(k); });
    reconcileGroups(R.gMain, main, anim); reconcileGroups(R.gSilent, silent, anim);
    R.secMain.classList.toggle('qp-hide', !main.length); R.secSilent.classList.toggle('qp-hide', !silent.length);
    R.empty.classList.toggle('qp-hide', !!list.length); R.foot.classList.toggle('qp-hide', !list.length);
    if (before) flip(R.nScroll, before);
  }
  function reconcileGroups(box, groups, anim) {
    const want = new Set(groups.map(g => g.key));
    [...box.children].forEach(c => { if (!want.has(c.dataset.g)) c.remove(); });
    groups.forEach((gr, i) => {
      let el = groupNodes.get(gr.key);
      if (!el) { el = groupNode(gr); groupNodes.set(gr.key, el); if (anim) el.classList.add('qp-new'); }
      if (box.children[i] !== el) box.insertBefore(el, box.children[i] || null);
      updateGroup(el, gr, anim);
    });
  }
  function groupNode(gr) {
    const el = UI.el(`<div class="qp-grp" data-fk="g:${esc(gr.key)}"><div class="qp-gh"><i class="qp-gic">${Icons.tile(gr.app)}</i><span class="qp-gname"></span><b class="qp-gcount"></b><span class="qp-gtime"></span><i class="qp-gexp">${IC.chev}</i></div><div class="qp-items"></div></div>`);
    el.dataset.g = gr.key; el._app = gr.app;
    el.addEventListener('animationend', () => el.classList.remove('qp-new'));
    bindSwipe(el.querySelector('.qp-gh'), { target: () => el, dismiss: () => dismissGroup(el), tap: () => toggleGroup(el), long: () => { const n = el._first; if (n && N()) N().options(n, el); } });
    return el;
  }
  function updateGroup(el, gr, anim) {
    const multi = gr.items.length > 1;
    el.classList.toggle('multi', multi); el.classList.toggle('single', !multi);
    el.classList.toggle('open', multi && expanded.has('g:' + gr.key));
    setText(el.querySelector('.qp-gname'), App.name(gr.app)); setText(el.querySelector('.qp-gcount'), String(gr.items.length));
    setText(el.querySelector('.qp-gtime'), UI.timeAgo(gr.items[0].ts));
    el._ids = gr.items.map(n => n.id); el._first = gr.items[0];
    const box = el.querySelector('.qp-items'), want = new Set(gr.items.map(n => String(n.id)));
    [...box.children].forEach(c => { if (!want.has(c.dataset.id)) c.remove(); });
    gr.items.forEach((n, i) => {
      let it = itemNodes.get(n.id);
      if (!it) { it = itemNode(n); itemNodes.set(n.id, it); if (anim && !el.classList.contains('qp-new')) it.classList.add('qp-new'); }
      else fillItem(it, n);
      if (box.children[i] !== it) box.insertBefore(it, box.children[i] || null);
      it.classList.toggle('open', expanded.has('n:' + n.id));
    });
  }
  function itemNode(n) {
    const el = UI.el(`<div class="qp-nc" data-id="${n.id}" data-fk="i:${n.id}"><div class="ncard aln"></div></div>`);
    el.addEventListener('animationend', () => el.classList.remove('qp-new'));
    fillItem(el, n);
    bindSwipe(el, {
      /* grupo fechado com varias: o gesto leva o grupo inteiro (como a pilha do Android) */
      target: () => { const g = el.closest('.qp-grp'); return g && g.classList.contains('multi') && !g.classList.contains('open') ? g : el; },
      dismiss: t => { if (t !== el) dismissGroup(t); else dismissItem(el); },
      tap: () => { const cur = el._n; if (!cur) return; Sound.play('click'); Notify.open(cur); },
      long: () => { const cur = el._n; if (cur && N()) N().options(cur, el); },
    });
    return el;
  }
  /* (re)preenche o conteudo so quando o que se ve mudou (pre-visualizacao escondida no bloqueado, titulo, imagem) */
  function fillItem(el, n) {
    const U = N(); if (!U) return;
    el._n = n;
    const pv = U.preview(n), acts = U.actionsFor(n);
    const sig = [pv.title, pv.msg, pv.hidden ? 1 : 0, pv.image || '', acts.map(a => a.label).join(',')].join('|');
    if (el._sig === sig) return; el._sig = sig;
    const card = el.firstElementChild; card.className = 'ncard aln'; card.innerHTML = U.inner(n, pv); U.paint(card, n, pv);
    card.querySelector('.n-main').insertAdjacentHTML('beforeend', `<i class="qp-exp">${IC.chev}</i>`);
    const ax = card.querySelector('.n-acts');
    if (acts.length) acts.forEach(a => { const b = UI.el(`<span class="n-act">${esc(a.label)}</span>`); b.addEventListener('pointerdown', e => e.stopPropagation()); b.onclick = e => { e.stopPropagation(); const cur = el._n || n; close(); U.runAction(cur, a); }; ax.appendChild(b); });
    else ax.remove();
    /* fechado o texto fica numa linha (pilula de 86): a partir de ~36 caracteres ja nao cabe e a seta aparece */
    el.classList.toggle('can-exp', !!acts.length || !!pv.image || String(pv.msg || '').length > 36);
    card.querySelector('.qp-exp').onclick = e => { e.stopPropagation(); toggleItem(el); };
  }
  function paintTimes() { itemNodes.forEach(el => { const n = el._n, t = el.querySelector('.n-time'); if (n && t) setText(t, UI.timeAgo(n.ts)); }); groupNodes.forEach(el => { const n = el._first; if (n) setText(el.querySelector('.qp-gtime'), UI.timeAgo(n.ts)); }); }
  function toggleItem(el) {
    const n = el._n; if (!n) return; const key = 'n:' + n.id, before = snapshot(R.nScroll);
    if (expanded.has(key)) expanded.delete(key); else expanded.add(key);
    el.classList.toggle('open', expanded.has(key)); Sound.play('click'); flip(R.nScroll, before);
  }
  function toggleGroup(gel) {
    if (!gel.classList.contains('multi')) { const it = gel.querySelector('.qp-nc'); if (it) toggleItem(it); return; }
    const key = 'g:' + gel.dataset.g, before = snapshot(R.nScroll);
    if (expanded.has(key)) expanded.delete(key); else expanded.add(key);
    gel.classList.toggle('open', expanded.has(key)); Sound.play('click'); flip(R.nScroll, before);
  }
  /* apagar: o cartao ja saiu pelo lado; sai do DOM ja, os outros sobem por FLIP, e so depois o Notify grava (o aviso
     notify:changed que vem a seguir ja nao encontra nada para tirar) */
  function dropEl(el) { const before = snapshot(R.nScroll); el.remove(); flip(R.nScroll, before); }
  function dismissItem(el) {
    const n = el._n; if (!n) return; const g = el.closest('.qp-grp');
    if (g && g._ids && g._ids.length <= 1) { dropEl(g); groupNodes.delete(g.dataset.g); } else dropEl(el);
    itemNodes.delete(n.id); Notify.remove(n.id);
  }
  function dismissGroup(gel) {
    const ids = (gel._ids || []).slice(), app = gel._app; dropEl(gel); groupNodes.delete(gel.dataset.g);
    ids.forEach(id => itemNodes.delete(id));
    const rest = Notify.all().filter(n => n.app === app && !ids.includes(n.id));
    if (!rest.length) Notify.clear(app, { sync: true }); else ids.forEach(id => Notify.remove(id));
  }
  function clearAll() {
    Sound.play('click');
    const els = [...R.nScroll.querySelectorAll('.qp-grp')];
    els.forEach((e, i) => { e.style.transitionDelay = Math.min(i, 8) * 30 + 'ms'; e.classList.add('qp-fly'); });
    setTimeout(() => { els.forEach(e => { e.style.transitionDelay = ''; }); Notify.clear(null, { sync: true }); }, 260 + Math.min(els.length, 8) * 30);
  }
  /* so a seccao "Notificacoes" (as silenciosas ficam): os cartoes voam e depois cada uma sai do Notify */
  function clearMain() {
    Sound.play('click');
    const els = [...R.gMain.querySelectorAll('.qp-grp')]; if (!els.length) return;
    els.forEach((e, i) => { e.style.transitionDelay = Math.min(i, 8) * 30 + 'ms'; e.classList.add('qp-fly'); });
    setTimeout(() => {
      els.forEach(e => { e.style.transitionDelay = ''; });
      const ids = Notify.all().filter(n => n.type !== 'silent').map(n => n.id);
      if (ids.length === Notify.all().length) Notify.clear(null, { sync: true }); else ids.forEach(id => Notify.remove(id));
    }, 260 + Math.min(els.length, 8) * 30);
  }

  /* ---------- deslizar um cartao para o lado (os dois lados dispensam, como no Android) ---------- */
  function bindSwipe(node, o) {
    let s = null, lp = null;
    node.addEventListener('pointerdown', e => {
      if (e.button > 0 && e.pointerType === 'mouse') return;
      if (e.target.closest('.n-act, .qp-exp')) return;
      s = { id: e.pointerId, x0: e.clientX, y0: e.clientY, ax: null, lx: e.clientX, lt: Date.now(), vx: 0, dx: 0, long: false };
      clearTimeout(lp); lp = setTimeout(() => { if (s && !s.ax) { s.long = true; node.classList.remove('qp-press'); Sound.play('pop'); if (o.long) o.long(); } }, 520);
      node.classList.add('qp-press');
    });
    node.addEventListener('pointermove', e => {
      if (!s || e.pointerId !== s.id) return;
      const k = kz(), dx = (e.clientX - s.x0) / k, dy = (e.clientY - s.y0) / k, now = Date.now();
      s.vx = (e.clientX - s.lx) / k / Math.max(1, now - s.lt); s.lx = e.clientX; s.lt = now;
      if (!s.ax) {
        if (Math.hypot(dx, dy) < 7) return;
        clearTimeout(lp); node.classList.remove('qp-press');
        if (s.long || Math.abs(dy) >= Math.abs(dx)) { s = null; return; }   /* vertical: e do painel (scroll) */
        s.ax = 'x'; cardDrag = true; s.tgt = (o.target && o.target()) || node;
        try { node.setPointerCapture(s.id); } catch (x) {}
        s.tgt.classList.add('qp-swiping');
      }
      s.dx = dx; s.tgt.style.transform = `translateX(${dx.toFixed(1)}px)`; s.tgt.style.opacity = (1 - Math.min(.7, Math.abs(dx) / 420)).toFixed(3);
    });
    const up = e => {
      if (!s || e.pointerId !== s.id) return; const st = s; s = null; clearTimeout(lp); node.classList.remove('qp-press');
      if (st.ax === 'x') {
        cardDrag = false; eatClick = Date.now() + 150; const t = st.tgt; t.classList.remove('qp-swiping');
        try { node.releasePointerCapture(st.id); } catch (x) {}
        const w = t.offsetWidth || 400, far = Math.abs(st.dx) > w * .32;
        if (far || Math.abs(st.vx) > .5) {
          const dir = far ? Math.sign(st.dx) : Math.sign(st.vx);
          t.style.transition = 'transform .22s var(--ou-curve-out, ease-out), opacity .2s'; t.style.transform = `translateX(${dir * (w + 40)}px)`; t.style.opacity = '0';
          setTimeout(() => { t.style.transition = ''; t.style.transform = ''; t.style.opacity = ''; o.dismiss(t); }, 210);
        } else { t.style.transition = 'transform .3s var(--ou-curve-out, ease-out), opacity .2s'; t.style.transform = ''; t.style.opacity = ''; setTimeout(() => { if (!t.style.transform) t.style.transition = ''; }, 320); }
        return;
      }
      if (!st.ax && !st.long && e.type === 'pointerup' && Date.now() >= eatClick && o.tap) o.tap(e);
    };
    node.addEventListener('pointerup', up); node.addEventListener('pointercancel', up);
    node.addEventListener('contextmenu', e => e.preventDefault());
  }

  /* ---------- notificacoes em direto: musica, chamada, temporizador, navegacao e atividades da ilha ---------- */
  function liveItems() {
    const out = [];
    const P = window.Player, cur = P && P.cur && P.cur(); if (cur) out.push({ k: 'media' });
    const c = window.PhoneApp && PhoneApp.current; if (c && (c.answered || c.outgoing)) out.push({ k: 'call' });
    const tm = window.TimerState; if (tm && tm.running && +tm.end > Date.now()) out.push({ k: 'timer' });
    if (window.Island && Island.list) {
      /* navegacao e Live Activities de outros recursos: vem da ilha (a mesma lista que o SysUI desenha em chips) */
      try { Island.list().forEach(a => { if (a && (a.mode === 'nav' || a.mode === 'activity')) out.push({ k: 'i:' + a.key, key: a.key, mode: a.mode, data: a.data || null }); }); } catch (e) {}
    }
    return out;
  }
  function renderLive(anim) {
    if (!built) return;
    const items = liveItems(), want = new Set(items.map(i => i.k));
    let changed = false; [...R.live.children].forEach(c => { if (!want.has(c.dataset.k)) { c.remove(); liveNodes.delete(c.dataset.k); changed = true; } });
    const before = anim && items.some(i => !liveNodes.has(i.k)) ? snapshot(R.nScroll) : null;
    items.forEach((it, i) => {
      let el = liveNodes.get(it.k);
      if (!el) { el = liveNode(it); liveNodes.set(it.k, el); if (anim) el.classList.add('qp-new'); changed = true; }
      if (R.live.children[i] !== el) R.live.insertBefore(el, R.live.children[i] || null);
      paintLive(el, it);
    });
    R.secLive.classList.toggle('qp-hide', !items.length);
    /* com notificacoes em direto por cima, as restantes sao as "Outras notificacoes" (como a Nova UI 8.5) */
    if (R.mainLbl) setText(R.mainLbl, items.length ? T('Outras notificações') : T('Notificações'));
    if (before && changed) flip(R.nScroll, before);
  }
  function liveNode(it) {
    let el;
    if (it.k === 'media') { el = UI.el('<div class="qp-media qp-livec" data-k="media" data-fk="l:media"></div>'); }
    else {
      el = UI.el(`<div class="qp-lc qp-livec" data-fk="l:${esc(it.k)}"><i class="qp-lc-ic"></i><div class="qp-lc-tx"><b></b><span></span></div><div class="qp-lc-acts"></div><div class="qp-lc-prog"><i></i></div></div>`);
      const acts = el.querySelector('.qp-lc-acts');
      if (it.k === 'call') { el.classList.add('k-call'); el.querySelector('.qp-lc-ic').innerHTML = IC.phone; acts.innerHTML = `<i class="qp-lc-b red" data-a="end">${IC.hang}</i>`; }
      else if (it.k === 'timer') { el.classList.add('k-timer'); el.querySelector('.qp-lc-ic').innerHTML = IC.timer; acts.innerHTML = `<i class="qp-lc-b" data-a="cancel">${IC.x}</i>`; }
      else if (it.mode === 'nav') { el.classList.add('k-nav'); el.querySelector('.qp-lc-ic').innerHTML = IC.nav; }
      else { el.classList.add('k-act'); const d = it.data || {}; const ic = el.querySelector('.qp-lc-ic'); if (d.app && App.get(d.app)) { ic.innerHTML = Icons.tile(d.app); ic.classList.add('qp-lc-app'); } else ic.innerHTML = IC.spark; }
      acts.querySelectorAll('.qp-lc-b').forEach(b => { b.addEventListener('pointerdown', e => e.stopPropagation()); b.onclick = e => { e.stopPropagation(); liveAction(b.dataset.a); }; });
      el.onclick = () => { if (Date.now() < eatClick) return; liveOpen(el._it || it); };
    }
    el.dataset.k = it.k;
    el.addEventListener('animationend', () => el.classList.remove('qp-new'));
    return el;
  }
  function paintLive(el, it) {
    el._it = it;
    if (it.k === 'media') { paintMedia(el); return; }
    const b = el.querySelector('.qp-lc-tx b'), s = el.querySelector('.qp-lc-tx span'), pr = el.querySelector('.qp-lc-prog');
    let p = null;
    if (it.k === 'call') { const c = window.PhoneApp && PhoneApp.current; if (!c) return; setText(b, c.name || c.number || T('Chamada')); setText(s, c.t0 ? UI.fmtDur((Date.now() - c.t0) / 1000) + ' · ' + T('Chamada em curso') : (c.status || T('A ligar…'))); }
    else if (it.k === 'timer') { const tm = window.TimerState; setText(b, T('Temporizador')); setText(s, tm && tm.end ? UI.fmtDur(Math.max(0, (tm.end - Date.now()) / 1000)) + ' ' + T('restantes') : ''); }
    else {
      const d = it.data || {};
      if (it.mode === 'nav') {
        const dist = Number(d.dist), dt = d.dist == null || d.dist === '' ? '' : isFinite(dist) ? (dist >= 1000 ? (dist / 1000).toFixed(dist >= 10000 ? 0 : 1).replace('.', ',') + ' km' : Math.round(dist) + ' m') : String(d.dist).slice(0, 16);
        setText(b, String(d.name || d.street || T('Navegação')).slice(0, 60)); setText(s, dt ? dt + (d.street && d.name ? ' · ' + String(d.street).slice(0, 40) : '') : T('A caminho do destino'));
      } else {
        setText(b, String(d.title || (d.app ? App.name(d.app) : '') || T('Atividade em curso')).slice(0, 60));
        const eta = typeof d.eta === 'number' ? (() => { const x = Math.max(0, Math.round((d.eta - Date.now()) / 1000)); return x < 60 ? T('agora') : x < 3600 ? Math.round(x / 60) + ' min' : UI.fmtDur(x); })() : (d.eta ? String(d.eta) : '');
        setText(s, [d.subtitle, eta, d.state].filter(Boolean).join(' · ').slice(0, 90));
        if (d.progress != null && isFinite(+d.progress)) p = clamp(+d.progress, 0, 1);
      }
    }
    el.classList.toggle('has-prog', p != null);
    if (p != null) { const i = pr.firstElementChild, v = `scaleX(${p.toFixed(4)})`; if (i.style.transform !== v) i.style.transform = v; }
  }
  function liveAction(a) {
    Sound.play('click');
    if (a === 'end') { if (window.PhoneApp && PhoneApp.end) PhoneApp.end('local'); }
    else if (a === 'cancel') { const tm = window.TimerState; if (tm && tm.cancel) tm.cancel(); if (window.Island && Island.clear) Island.clear('timer'); }
    setTimeout(() => renderLive(true), 60);
  }
  function liveOpen(it) {
    Sound.play('click');
    if (it.k === 'call') { close(); const c = window.PhoneApp && PhoneApp.current; if (c && c.min && PhoneApp.restore) PhoneApp.restore(); return; }
    if (it.k === 'timer') { openApp('clock'); return; }
    if (window.Island && Island.open && it.key) { close(); Island.open(it.key); return; }   /* a ilha sabe o onTap de cada atividade */
    const d = it.data || {};
    if (typeof d.onTap === 'function') { close(); try { d.onTap(); } catch (e) {} return; }
    openApp(it.mode === 'nav' ? 'maps' : (d.app && App.get(d.app) ? d.app : 'maps'));
  }

  /* ---------- cartao do leitor de musica (o mesmo modulo do CC: CC.music.bind/paint) ---------- */
  /* desenho do cartao da Nova UI 8.5 (408 x 180, raio 36): a capa ocupa o cartao inteiro (.art, com um veu por cima),
     linha da app e da saida do som, titulo e artista, barra grossa com o botao redondo e os tempos, cinco controlos */
  const MEDIA_HTML = () => `<div class="art"></div><div class="qp-mveil"></div><div class="qp-mh"><i class="qp-mapp">${Icons.tile('music')}</i><span class="qp-mname">${esc(App.name('music'))}</span><span class="qp-mout"><i></i><b></b></span></div>
    <div class="qp-mrow"><div class="meta"><div class="t"></div><div class="a"></div></div></div>
    <div class="cc-prog"><div class="cc-bar qp-noswipe"><i></i><b class="qp-wv"><b></b></b><b class="qp-wr"><b></b></b><b class="qp-mthumb"></b></div><div class="cc-times"><span class="el"></span><span class="len"></span></div></div>
    <div class="ctl"><div class="qp-mshuf">${IC.shuffle}</div><div class="prev">${IC.prev}</div><div class="play"></div><div class="next">${IC.next}</div><div class="qp-mopen">${IC.open}</div></div>`;
  /* o botao redondo da barra segue o preenchimento (o CC.music pinta o scaleX do <i>): o mesmo valor em translateX de
     uma camada da largura da barra, sem medir nada */
  function syncThumb(el) {
    const i = el.querySelector('.cc-bar i'), th = el.querySelector('.qp-mthumb'); if (!i || !th) return;
    const m = /scaleX\(([\d.]+)\)/.exec(i.style.transform || ''), f = m ? clamp(+m[1], 0, 1) : 0, v = `translateX(${(f * 100).toFixed(2)}%)`;
    if (th.style.transform !== v) th.style.transform = v;
    /* Nova UI 9: a onda (parte tocada) e a linha lisa (o resto) cortam-se por translacoes opostas: a caixa anda e o conteudo
       volta o mesmo tanto, por isso a onda fica parada no sitio e so a janela que a mostra cresce (so transform) */
    const wv = el.querySelector('.qp-wv'), wr = el.querySelector('.qp-wr'); if (!wv || !wr) return;
    const a = ((1 - f) * 100).toFixed(2), b = (f * 100).toFixed(2), set = (n, t) => { if (n.style.transform !== t) n.style.transform = t; };
    set(wv, `translateX(-${a}%)`); set(wv.firstElementChild, `translateX(${a}%)`);
    set(wr, `translateX(${b}%)`); set(wr.firstElementChild, `translateX(-${b}%)`);
  }
  /* cor da onda: a primeira cor da capa clareada (o CEF nao faz color-mix), para se ler por cima do cartao escurecido */
  const lift = (hex, k) => { const h = String(hex || '').replace('#', ''); const s = h.length === 3 ? h.split('').map(c => c + c).join('') : h.slice(0, 6); if (!/^[0-9a-f]{6}$/i.test(s)) return null; const n = parseInt(s, 16); return [(n >> 16) & 255, (n >> 8) & 255, n & 255].map(v => Math.round(v + (255 - v) * k)).join(','); };
  /* "#RRGGBB" → "r,g,b" escurecido para o texto branco se ler (o CEF nao faz color-mix) */
  const shade = (hex, f) => { const h = String(hex || '').replace('#', ''); const s = h.length === 3 ? h.split('').map(c => c + c).join('') : h.slice(0, 6); const n = parseInt(s, 16); if (!/^[0-9a-f]{6}$/i.test(s) || isNaN(n)) return null; return [(n >> 16) & 255, (n >> 8) & 255, n & 255].map(v => Math.round(v * f)).join(','); };
  function paintMedia(el) {
    if (!el || !window.CC || !CC.music) return;
    if (!el._made) {
      el.innerHTML = MEDIA_HTML(); el._made = true;
      CC.music.bind(el, { empty: () => openApp('music') });
      const sh = el.querySelector('.qp-mshuf'); sh.onclick = e => { e.stopPropagation(); const P = window.Player; if (!P || !P.cur || !P.cur()) return; Sound.play('click'); P.shuffle = !P.shuffle; sh.classList.toggle('on', !!P.shuffle); };
      el.querySelector('.qp-mopen').onclick = e => { e.stopPropagation(); Sound.play('click'); openApp('music'); };
      el.querySelectorAll('.ctl > div').forEach(b => b.addEventListener('pointerdown', e => e.stopPropagation()));
      /* arrastar na barra (seek): o botao acompanha o dedo */
      const bar = el.querySelector('.cc-bar'); ['pointerdown', 'pointermove', 'pointerup', 'pointercancel'].forEach(t => bar.addEventListener(t, () => syncThumb(el)));
    }
    try { CC.music.paint(el); } catch (e) {}
    syncThumb(el);
    const P = window.Player, cur = P && P.cur ? P.cur() : null, S = System.state;
    el.classList.toggle('qp-mempty', !cur);
    const c = cur && Array.isArray(cur.c) ? cur.c : null, sig = c ? c.join(',') : '';
    if (el._csig !== sig) {
      el._csig = sig; const a = c && shade(c[0], .62), b = c && shade(c[1] || c[0], .4);
      if (a && b) { el.style.setProperty('--qp-m1', `rgb(${a})`); el.style.setProperty('--qp-m2', `rgb(${b})`); el.classList.add('qp-tinted'); }
      else { el.style.removeProperty('--qp-m1'); el.style.removeProperty('--qp-m2'); el.classList.remove('qp-tinted'); }
      const w = c && lift(c[0], .5); if (w) el.style.setProperty('--qp-wv', `rgb(${w})`); else el.style.removeProperty('--qp-wv');
    }
    const sh = el.querySelector('.qp-mshuf'); if (sh) sh.classList.toggle('on', !!(P && P.shuffle));
    /* saida do som: os auriculares ligados por Bluetooth ou o proprio telemovel */
    const ear = !!(S.earbuds && S.bt), out = el.querySelector('.qp-mout'), key = ear ? 'e' : 'p';
    if (out && out.dataset.k !== key) { out.dataset.k = key; out.firstElementChild.innerHTML = ear ? IC.buds : IC.handset; out.lastElementChild.textContent = ear ? ((window.Earbuds && Earbuds.NAME) || T('Auriculares')) : T('Este telemóvel'); }
  }

  /* ============================================================
     DEFINICOES RAPIDAS: mosaicos, sliders, edicao
     ============================================================ */
  function tileNode(k) {
    let n = tileNodes.get(k); if (n) return n;
    n = UI.el(`<div class="qp-t" data-t="${esc(k)}" data-tk="${esc(k)}" data-fk="t:${esc(k)}" role="button"><div class="qp-ti"></div><div class="qp-tx"><b class="qp-tl"></b><span class="qp-ts"></span></div><i class="qp-tb"></i><i class="qp-rz" role="button" aria-label="${esc(T('Redimensionar'))}"></i></div>`);
    bindTile(n, k); bindResize(n, k); tileNodes.set(k, n); return n;
  }
  function paintTile(n, k, S) {
    const q = QT[k]; if (!q || !window.CC) return;
    const on = !q.app && CC.tileOn(k);
    n.classList.toggle('on', on); n.classList.toggle('is-app', !!q.app);
    const ic = q.icon(S); if (n._ic !== ic) { n._ic = ic; n.firstElementChild.innerHTML = ic; }
    const lb = q.label(S); setText(n.querySelector('.qp-tl'), lb);
    if (n.getAttribute('aria-label') !== lb) n.setAttribute('aria-label', lb);   /* quadrados e redondos so mostram o icone */
    setText(n.querySelector('.qp-ts'), q.sub ? q.sub(S) : q.app ? T('Abrir') : on ? T('Ligado') : T('Desligado'));
    n.setAttribute('aria-pressed', on ? 'true' : 'false');
  }
  function paintTiles() {
    if (!built) return; const S = System.state; tileNodes.forEach((n, k) => { if (n.isConnected) paintTile(n, k, S); });
    R.pq.querySelectorAll('.qp-vsb').forEach(b => { const on = !!(window.CC && CC.tileOn(b.dataset.t)); b.classList.toggle('on', on); b.setAttribute('aria-pressed', on ? 'true' : 'false'); });
    paintFold(); paintCards();
  }
  /* cartoes de baixo: so o texto e o glifo que mudaram */
  function paintCards() {
    if (!R.cards) return; const S = System.state, ear = !!(S.earbuds && S.bt), name = (window.Earbuds && Earbuds.NAME) || T('Auriculares');
    const o = R.cdOut, d = R.cdDev;
    const ok = ear ? 'e' : 'p'; if (o.dataset.k !== ok) { o.dataset.k = ok; o.firstElementChild.innerHTML = ear ? IC.buds : IC.handset; }
    setText(o.querySelector('b'), ear ? name : T('Este telemóvel'));
    const dk = ear ? 'e' : S.bt ? 'b' : 'o'; if (d.dataset.k !== dk) { d.dataset.k = dk; d.firstElementChild.innerHTML = ear ? IC.buds : IC.bt; d.classList.toggle('on', ear); }
    setText(d.querySelector('b'), ear ? name : S.bt ? T('Nenhum ligado') : T('Bluetooth desligado'));
  }
  /* o glifo e o texto do estado para onde vai (so o que mudou) */
  function paintFold() {
    if (!R.fold || !(window.System && System.form === 'fold')) return;
    const open = !!System.foldOpen, k = open ? 'c' : 'o';
    if (R.fold.dataset.k === k) return; R.fold.dataset.k = k;
    R.fold.querySelector('.qp-fold-ic').innerHTML = open ? IC.refold : IC.unfold;
    const lb = T(open ? 'Fechar ecrã' : 'Abrir ecrã');
    setText(R.fold.querySelector('.qp-fold-tx b'), lb); setText(R.fold.querySelector('.qp-fold-tx span'), T(open ? 'Voltar ao ecrã exterior' : 'Usar o ecrã interior'));
    R.fold.setAttribute('aria-label', lb);
  }
  /* poe os nos (feitos uma vez) nos lugares da grelha (pack: linha/coluna/largura escritas em grid-area) e o resto no cartao dos
     redondos. wide = os largos (em edicao os de trabalho, senao os gravados) */
  function layoutTiles(list, wide) {
    if (!built) return;
    const ws = wide || (editing && workWide) || wideSet(), { big, rest } = pack(list, ws), S = System.state, bigIds = big.map(b => b.k);
    [...R.tbig.children].forEach(c => { if (c.classList.contains('qp-t') && !bigIds.includes(c.dataset.tk)) c.remove(); });
    big.forEach(b => {
      const n = tileNode(b.k), half = b.w === 2;
      n.classList.add('qp-big'); n.classList.remove('qp-rnd'); n.classList.toggle('qp-half', half); n.classList.toggle('qp-sq', !half);
      const ga = b.r + '/' + b.c + '/' + (b.r + 1) + '/' + (b.c + b.w); if (n.dataset.ga !== ga) { n.dataset.ga = ga; n.style.gridArea = ga; }
      if (n.parentElement !== R.tbig) R.tbig.appendChild(n);
      paintTile(n, b.k, S);
    });
    [...R.trnd.children].forEach(c => { if (!rest.includes(c.dataset.tk)) c.remove(); });
    rest.forEach((k, i) => { const n = tileNode(k); unplace(n); if (R.trnd.children[i] !== n) R.trnd.insertBefore(n, R.trnd.children[i] || null); paintTile(n, k, S); });
    R.rcard.classList.toggle('qp-hide', !rest.length && !editing);
    R.rcard.classList.toggle('qp-one', rest.length <= 4);   /* uma linha so: sem pega */
  }
  /* um botao que sai dos lugares grandes volta a ser um redondo sem lugar na grelha */
  function unplace(n) { n.classList.remove('qp-big', 'qp-half', 'qp-sq'); n.classList.add('qp-rnd'); if (n.dataset.ga) { delete n.dataset.ga; n.style.gridArea = ''; } }
  function bindTile(n, k) {
    let lp = null, fired = false, sx = 0, sy = 0;
    n.addEventListener('pointerdown', e => {
      if (e.button > 0 && e.pointerType === 'mouse') return;
      fired = false; sx = e.clientX; sy = e.clientY;
      if (editing) { if (work && work.includes(k)) td = { n, k, id: e.pointerId, x0: e.clientX, y0: e.clientY, on: false }; return; }
      clearTimeout(lp); lp = setTimeout(() => { fired = true; lp = null; longTile(k); }, 520);
    });
    n.addEventListener('pointermove', e => { if (lp && Math.hypot(e.clientX - sx, e.clientY - sy) > 8) { clearTimeout(lp); lp = null; } });
    ['pointerup', 'pointercancel', 'pointerleave'].forEach(t => n.addEventListener(t, () => { clearTimeout(lp); lp = null; }));
    n.addEventListener('contextmenu', e => e.preventDefault());
    n.addEventListener('click', e => {
      e.stopPropagation();
      if (fired) { fired = false; return; }
      if (Date.now() < eatClick) return;
      if (editing) { toggleWork(k); return; }
      /* mosaico grande: o texto abre a pagina das Definicoes (como a Nova UI); o circulo liga/desliga */
      if (n.classList.contains('qp-big') && e.target.closest('.qp-tx') && QT[k].go) { Sound.play('click'); goSettings(QT[k].go); return; }
      tapTile(k);
    });
  }
  /* pega de redimensionar (so em edicao, so nos lugares grandes): puxar para a direita alarga (2x1), para a esquerda estreita
     (1x1); um toque troca. A captura fica na pega: o botao muda de forma e de lugar no fim, por FLIP */
  function bindResize(n, k) {
    const rz = n.querySelector('.qp-rz'); if (!rz) return; let st = null;
    rz.addEventListener('pointerdown', e => {
      if (e.button > 0 && e.pointerType === 'mouse') return; e.stopPropagation(); e.preventDefault();
      if (!editing || !workWide || !n.classList.contains('qp-big')) return;
      st = { id: e.pointerId, x0: e.clientX, dx: 0 }; n.classList.add('qp-rzing');
      try { rz.setPointerCapture(e.pointerId); } catch (x) {}
    });
    rz.addEventListener('pointermove', e => { if (!st || e.pointerId !== st.id) return; e.stopPropagation(); st.dx = (e.clientX - st.x0) / kz(); });
    const end = e => {
      if (!st || e.pointerId !== st.id) return; e.stopPropagation(); const s = st; st = null; n.classList.remove('qp-rzing');
      try { rz.releasePointerCapture(s.id); } catch (x) {}
      eatClick = Date.now() + 150; if (e.type !== 'pointerup' || !editing || !workWide) return;
      const wide = workWide.has(k), want = Math.abs(s.dx) > 28 ? s.dx > 0 : !wide;
      if (want === wide) return;
      const before = snapTiles(); if (want) workWide.add(k); else workWide.delete(k);
      Sound.play('tick'); renderEdit(); flipTiles(before, null);
    };
    rz.addEventListener('pointerup', end); rz.addEventListener('pointercancel', end);
    rz.addEventListener('click', e => e.stopPropagation());
  }
  function tapTile(k) {
    Sound.play('click');
    /* Partilha rapida: o mesmo estado do AirShare (AirDrop.setMode), com o aviso no nome da Nova UI */
    if (k === 'airdrop' && window.AirDrop && AirDrop.setMode && AirDrop.mode) { const on = AirDrop.mode() === 'off'; AirDrop.setMode(on ? 'everyone' : 'off'); UI.toast(T('Partilha rápida') + ': ' + (on ? T('Todos') : T('Desligado'))); }
    else CC.tap(k);
    paintTiles();
  }
  function longTile(k) {
    const q = QT[k]; if (!q) return;
    if (q.long) { Sound.play('pop'); q.long(); return; }
    if (q.go) { Sound.play('pop'); goSettings(q.go); return; }
    if (q.app) tapTile(k);
  }
  /* ---------- sliders verticais (brilho e volume, 88 x 300): os mesmos valores do CC, gravados pelo CC.level ---------- */
  const CAP = 64;                                    /* o preenchimento nunca fica mais baixo do que o icone (Nova UI 9: calha de 88, icone na ponta de 64) */
  function paintSl(sl, v) {
    /* altura direta (sem transicao) e nao transform: um preenchimento deslocado precisava do recorte arredondado do
       pai, que o CEF nem sempre faz numa camada composta; e o mesmo que os sliders do CC fazem */
    v = clamp(Math.round(num(v)), 0, 100); const h = sl.offsetHeight || 202, f = (CAP + (h - CAP) * v / 100) / h;
    const t = (f * 100).toFixed(2) + '%', fill = sl.firstElementChild; if (fill.style.height !== t) fill.style.height = t;
    if (sl.dataset.key === 'volume') { const gk = v <= 0 ? 'm' : v < 50 ? 'l' : 'h'; if (sl.dataset.gl !== gk) { sl.dataset.gl = gk; sl.querySelector('.qp-sli').innerHTML = gk === 'm' ? IC.mute : gk === 'l' ? IC.volLow : IC.vol; } }
    sl.setAttribute('aria-valuenow', String(v));
  }
  function paintSliders() { if (!built) return; R.pq.querySelectorAll('.qp-sl').forEach(sl => { if (slDrag !== sl) paintSl(sl, System.state[sl.dataset.key]); }); }
  function bindSlider(sl) {
    const key = sl.dataset.key; let st = null;
    sl.addEventListener('pointerdown', e => {
      if (e.button > 0 && e.pointerType === 'mouse') return; e.stopPropagation(); e.preventDefault();
      if (editing) return;
      const r = sl.getBoundingClientRect(), k = kz(); if (!r.height) return; const h = r.height / k, y = (r.bottom - e.clientY) / k;
      st = { id: e.pointerId, y0: e.clientY, v0: num(System.state[key]), h, abs: clamp((y - CAP / 2) / (h - CAP) * 100, 0, 100), moved: false };
      try { sl.setPointerCapture(e.pointerId); } catch (x2) {}
      slDrag = sl; sl.classList.add('drag');
    });
    sl.addEventListener('pointermove', e => {
      if (!st) return; e.stopPropagation(); const dy = (st.y0 - e.clientY) / kz();
      if (!st.moved && Math.abs(dy) > 3) st.moved = true; if (!st.moved) return;
      const v = clamp(st.v0 + dy / (st.h - CAP) * 100, 0, 100); paintSl(sl, v); CC.level(key, v, false);
      const step = Math.round(v / 10); if (st.step !== undefined && step !== st.step) Sound.play('tick'); st.step = step;
    });
    const end = (e, cancel) => {
      if (!st) return; e.stopPropagation(); const s = st; st = null; slDrag = null; sl.classList.remove('drag');
      try { sl.releasePointerCapture(s.id); } catch (x) {}
      const v = s.moved ? num(System.state[key]) : (cancel ? s.v0 : s.abs);
      paintSl(sl, CC.level(key, v, true));
    };
    sl.addEventListener('pointerup', e => end(e, false)); sl.addEventListener('pointercancel', e => end(e, true));
    sl.addEventListener('lostpointercapture', e => { if (st) end(e, false); });
    sl.addEventListener('click', e => e.stopPropagation());
  }

  /* ---------- modo de edicao: escolher e ordenar os botoes (System.state.qsTiles) ---------- */
  function startEdit() {
    Sound.play('click');
    /* com o ecra bloqueado pede-se o codigo primeiro (como na Nova UI); o teclado vive no ecra bloqueado, por baixo
       do painel, por isso o painel fecha e volta a abrir ja em edicao */
    if (System.locked && window.Lock && Lock.requestUnlock) { close(); Lock.requestUnlock(() => { open('qs', { silent: true }); setTimeout(startEdit, 80); }); return; }
    if (editing) return;
    editing = true; work = order(); workWide = wideSet(); root.classList.add('qp-editing'); renderEdit(); R.qScroll.scrollTop = 0;
  }
  function renderEdit() { if (!editing) return; layoutTiles(work, workWide); layoutAvail(ALL.filter(k => known(k) && !work.includes(k))); }
  function layoutAvail(ids) {
    const S = System.state;
    [...R.avail.children].forEach(c => { if (!ids.includes(c.dataset.tk)) c.remove(); });
    ids.forEach((k, i) => { const n = tileNode(k); unplace(n); if (R.avail.children[i] !== n) R.avail.insertBefore(n, R.avail.children[i] || null); paintTile(n, k, S); });
    R.avail.closest('.qp-availw').classList.toggle('qp-none', !ids.length);
  }
  function toggleWork(k) {
    if (!editing) return; Sound.play('click');
    const before = snapTiles(), i = work.indexOf(k);
    if (i >= 0) work.splice(i, 1); else work.push(k);
    renderEdit(); flipTiles(before, null);
  }
  function exitEdit(save) {
    if (!editing) return; editing = false; td = null;
    if (save !== false && work) {
      const def = DEF.filter(known), same = work.length === def.length && work.every((k, i) => k === def[i]);
      const cur = System.state.qsTiles, prev = Array.isArray(cur) ? cur : null, next = same ? null : work.slice();
      /* larguras: so as dos botoes que ficaram; iguais as de origem = null */
      const wl = workWide ? [...workWide].filter(k => work.includes(k)).sort() : [], dw = DEF_WIDE.filter(k => QT[k]).sort();
      const sameW = wl.length === dw.length && wl.every((k, i) => k === dw[i]);
      const curW = System.state.qsWide, prevW = Array.isArray(curW) ? curW.slice().sort() : null, nextW = sameW ? null : wl;
      const patch = {};
      if (JSON.stringify(prev) !== JSON.stringify(next)) patch.qsTiles = next;
      if (JSON.stringify(prevW) !== JSON.stringify(nextW)) patch.qsWide = nextW;
      if (Object.keys(patch).length) System.setState(patch);
    }
    work = null; workWide = null; root.classList.remove('qp-editing');
    [...R.avail.children].forEach(c => c.remove());
    layoutTiles(order());
  }
  /* posicoes dos botoes em coordenadas da pagina (offset* nao conta os transform dos FLIP em curso) */
  function tilePos(n) { let x = 0, y = 0, e = n; while (e && e !== R.qScroll) { x += e.offsetLeft; y += e.offsetTop; e = e.offsetParent; } return { x, y, w: n.offsetWidth, h: n.offsetHeight }; }
  function snapTiles() { const m = new Map(); tileNodes.forEach((n, k) => { if (n.isConnected) m.set(k, tilePos(n)); }); return m; }
  function flipTiles(before, except) {
    const moved = [];
    tileNodes.forEach((n, k) => { if (n === except || !n.isConnected || !before.has(k)) return; const a = tilePos(n), b = before.get(k), dx = b.x - a.x, dy = b.y - a.y; if (Math.abs(dx) > .5 || Math.abs(dy) > .5) moved.push([n, dx, dy]); });
    if (!moved.length) return;
    moved.forEach(([n, dx, dy]) => { n.style.transition = 'none'; n.style.transform = `translate(${dx.toFixed(1)}px,${dy.toFixed(1)}px)`; });
    void R.qScroll.offsetWidth;
    moved.forEach(([n]) => { n.style.transition = 'transform .3s var(--ou-curve-out, ease-out)'; n.style.transform = ''; });
    setTimeout(() => moved.forEach(([n]) => { if (!n.style.transform) n.style.transition = ''; }), 360);
  }
  /* arrastar para ordenar: a captura fica na PAGINA (os botoes mudam de contentor durante o arrasto e um no
     removido do documento perdia a captura do ponteiro) */
  function bindEditDrag() {
    const pg = R.pq;
    pg.addEventListener('pointermove', e => {
      if (!td || e.pointerId !== td.id) return;
      const k = kz(), dx = (e.clientX - td.x0) / k, dy = (e.clientY - td.y0) / k;
      if (!td.on) {
        if (Math.hypot(dx, dy) < 6) return;
        td.on = true; try { pg.setPointerCapture(td.id); } catch (x) {}
        const p0 = tilePos(td.n), sr = R.qScroll.getBoundingClientRect();
        td.gx = (td.x0 - sr.left) / k + R.qScroll.scrollLeft - p0.x; td.gy = (td.y0 - sr.top) / k + R.qScroll.scrollTop - p0.y;
        td.n.classList.add('qp-lift'); root.classList.add('qp-tdrag');
      }
      const sr = R.qScroll.getBoundingClientRect(), px = (e.clientX - sr.left) / k, py = (e.clientY - sr.top) / k + R.qScroll.scrollTop;
      /* alvo: o botao (ativo) por baixo do ponteiro */
      let target = -1;
      work.forEach((kk, i) => { const n = tileNodes.get(kk); if (!n || n === td.n || !n.isConnected) return; const p = tilePos(n); if (px >= p.x && px <= p.x + p.w && py >= p.y && py <= p.y + p.h) target = i; });
      if (target >= 0) { const from = work.indexOf(td.k); if (from >= 0 && target !== from) { const before = snapTiles(); work.splice(from, 1); work.splice(target, 0, td.k); layoutTiles(work); flipTiles(before, td.n); Sound.play('tick'); } }
      const p = tilePos(td.n), gx = Math.min(td.gx, p.w - 8), gy = Math.min(td.gy, p.h - 8);
      td.n.style.transition = 'none'; td.n.style.transform = `translate(${(px - gx - p.x).toFixed(1)}px,${(py - gy - p.y).toFixed(1)}px)`;
    });
    const up = e => {
      if (!td || e.pointerId !== td.id) return; const t = td; td = null;
      if (!t.on) return;
      eatClick = Date.now() + 150; try { pg.releasePointerCapture(t.id); } catch (x) {}
      root.classList.remove('qp-tdrag'); t.n.classList.remove('qp-lift');
      t.n.style.transition = 'transform .3s var(--ou-curve-out, ease-out)'; t.n.style.transform = '';
      setTimeout(() => { if (!t.n.style.transform) t.n.style.transition = ''; }, 340);
    };
    pg.addEventListener('pointerup', up); pg.addEventListener('pointercancel', up);
  }

  /* ---------- abrir apps/Definicoes a partir do painel ---------- */
  function openApp(id) { close(); setTimeout(() => System.openApp(id), 60); }
  function goSettings(key) {
    close();
    const go = () => { System.openApp('settings'); if (key) setTimeout(() => Bridge.emit('settings:goto', key), 340); };
    if (System.locked && window.Lock && Lock.requestUnlock) Lock.requestUnlock(go); else setTimeout(go, 60);
  }

  /* ============================================================
     NOTIFICACAO FLUTUANTE (heads-up) com o telemovel desbloqueado
     Cartao no topo, raio 26, superficie do tema: icone pequeno + app + "agora", titulo, texto, seta para expandir e
     as acoes da notificacao. Puxar para cima esconde-a (fica no painel), para os lados dispensa-a, para baixo
     expande; some sozinha. O elemento raiz e o .ahn-card (o System.peek mede-o para o telemovel fechado subir).
     As preferencias (banner, som, pre-visualizacao, foco) ja foram aplicadas pelo announce() do notify.js.
     ============================================================ */
  let hu = null;
  function headsUp(n) {
    const U = N(); if (!isA() || !n || !U) return null;
    if (opened || pulling) return null;                 /* com o painel aberto a lista atualiza-se la dentro */
    if (hu) hu.hide(true);
    const pv = U.preview(n);
    const el = UI.el(`<div class="ahn-card" data-id="${n.id}" role="status"><div class="ncard aln ahn-in">${U.inner(n, pv, T('agora'))}</div></div>`);
    U.paint(el, n, pv);
    el.querySelector('.n-main').insertAdjacentHTML('beforeend', `<i class="ahn-exp">${IC.chev}</i>`);
    const acts = U.actionsFor(n), ax = el.querySelector('.n-acts');
    let hidden = false, t = null;
    const ms = n.dur > 0 ? n.dur : 5000;
    const arm = (d) => { clearTimeout(t); t = setTimeout(() => api.hide(), d || (el.classList.contains('open') ? Math.max(ms, 9000) : ms)); };
    const api = {
      el, n,
      hide(fast) {
        if (hidden) return; hidden = true; clearTimeout(t);
        el.classList.remove('in'); el.classList.add(fast ? 'out-fast' : 'out');
        setTimeout(() => el.remove(), fast ? 240 : 420); if (hu === api) hu = null;
      },
    };
    if (acts.length) acts.forEach(a => { const b = UI.el(`<span class="n-act">${esc(a.label)}</span>`); b.addEventListener('pointerdown', e => e.stopPropagation()); b.onclick = e => { e.stopPropagation(); api.hide(true); U.runAction(n, a); }; ax.appendChild(b); });
    else ax.remove();
    const expand = () => { el.classList.toggle('open'); Sound.play('click'); arm(); };
    el.querySelector('.ahn-exp').addEventListener('pointerdown', e => e.stopPropagation());
    el.querySelector('.ahn-exp').onclick = e => { e.stopPropagation(); expand(); };
    /* gestos */
    let s = null;
    el.addEventListener('pointerdown', e => {
      if (e.button > 0 && e.pointerType === 'mouse') return;
      s = { id: e.pointerId, x0: e.clientX, y0: e.clientY, ax: null, lx: e.clientX, lt: Date.now(), vx: 0, dx: 0, dy: 0 };
      clearTimeout(t); try { el.setPointerCapture(e.pointerId); } catch (x) {}
      el.classList.add('drag');
    });
    el.addEventListener('pointermove', e => {
      if (!s || e.pointerId !== s.id) return;
      const k = kz(), dx = (e.clientX - s.x0) / k, dy = (e.clientY - s.y0) / k, now = Date.now();
      s.vx = (e.clientX - s.lx) / k / Math.max(1, now - s.lt); s.lx = e.clientX; s.lt = now;
      if (!s.ax) { if (Math.hypot(dx, dy) < 6) return; s.ax = Math.abs(dx) > Math.abs(dy) ? 'x' : 'y'; }
      s.dx = dx; s.dy = dy;
      if (s.ax === 'x') { el.style.transform = `translateX(${dx.toFixed(1)}px)`; el.style.opacity = (1 - Math.min(.8, Math.abs(dx) / 360)).toFixed(3); }
      else el.style.transform = `translateY(${(dy < 0 ? dy : Math.min(44, dy * .5)).toFixed(1)}px)`;
    });
    const up = e => {
      if (!s || e.pointerId !== s.id) return; const st = s; s = null; el.classList.remove('drag');
      try { el.releasePointerCapture(st.id); } catch (x) {}
      if (st.ax === 'x') {
        const far = Math.abs(st.dx) > 120;
        if (far || Math.abs(st.vx) > .55) { const dir = far ? Math.sign(st.dx) : Math.sign(st.vx); hidden = true; clearTimeout(t); if (hu === api) hu = null; el.style.transition = 'transform .22s var(--ou-curve-out, ease-out), opacity .2s'; el.style.transform = `translateX(${dir * 480}px)`; el.style.opacity = '0'; setTimeout(() => el.remove(), 240); Notify.remove(n.id); return; }
        el.style.transform = ''; el.style.opacity = ''; arm(); return;
      }
      if (st.ax === 'y') { el.style.transform = ''; if (st.dy < -28) { api.hide(); return; } if (st.dy > 34) { expand(); return; } arm(); return; }
      if (e.type !== 'pointerup') { arm(); return; }
      api.hide(true); Notify.open(n);                    /* tocar abre (o Notify pede o codigo se for preciso) */
    };
    el.addEventListener('pointerup', up); el.addEventListener('pointercancel', up);
    el.addEventListener('contextmenu', e => e.preventDefault());
    UI.screen().appendChild(el); hu = api;
    const show = () => { if (!hidden) el.classList.add('in'); };
    /* com o telemovel guardado (body.hidden) o cartao nasce ja no sitio: o System.peek mede-o logo a seguir para saber
       quanto subir, e a meio da entrada a medida vinha curta. Aberto, entra com a transicao (o setTimeout cobre o rAF
       que nao corre sem frames). */
    if (document.body.classList.contains('hidden')) show();
    else { requestAnimationFrame(() => requestAnimationFrame(show)); setTimeout(show, 50); }
    arm(ms);
    return api;
  }

  /* ============================================================
     ARRANQUE E OUVINTES
     ============================================================ */
  function resetLists() {
    if (!built) return;
    [R.gMain, R.gSilent, R.live].forEach(b => { while (b.firstChild) b.firstChild.remove(); });
    itemNodes.clear(); groupNodes.clear(); liveNodes.clear(); expanded.clear();
  }
  function init() {
    if (isA()) build();
    Bridge.on('notify:changed', () => { if (!built) return; if (opened) renderNotifs(true); else if (pulling) renderNotifs(false); });   /* fechado: a abertura volta a desenhar tudo */
    Bridge.on('state', p => {
      if (!built) return;
      if (p && ('qsTiles' in p || 'qsWide' in p) && !editing) layoutTiles(order());
      if (!opened && !pulling) return;
      paintTiles(); paintSliders(); paintMedia(R.media); paintCards();
      if (p && ('earbuds' in p || 'bt' in p)) liveNodes.forEach(el => { if (el.dataset.k === 'media') paintMedia(el); });
    });
    Bridge.on('torch', () => { if (built && (opened || pulling)) paintTiles(); });
    /* a pre-visualizacao "Desbloqueado" depende do bloqueio: o texto volta (ou esconde-se) no sitio */
    const relist = () => { if (built && (opened || pulling)) renderNotifs(false); };
    Bridge.on('lock', () => { relist(); if (hu) hu.hide(true); });
    Bridge.on('unlock', relist);
    Bridge.on('phone:close', () => close());
    Bridge.on('session:changed', () => { close(); if (hu) hu.hide(true); resetLists(); });
    Bridge.on('factory:reset', () => { close(); if (hu) hu.hide(true); resetLists(); });
    Bridge.on('os:changed', d => {
      /* de volta ao Android: os cartoes refazem-se na proxima abertura (icones e nomes das apps mudam com o sistema) */
      if (d && d.to === 'android') { build(); if (built) { resetLists(); layoutTiles(order()); } }
      else { close(); if (hu) hu.hide(true); }
    });
    /* musica: o Player avisa as mudancas (faixa, play/pausa); o tique de 1 s trata do progresso */
    const hookPlayer = () => { const P = window.Player; if (!P || P._qpHook) return; try { P.onChange = () => { if (built && opened) { renderLive(true); paintMedia(R.media); } }; P._qpHook = true; } catch (e) {} };
    hookPlayer(); Bridge.on('ready', hookPlayer);
    /* cartao do dobravel aberto: o x do ultimo toque decide o lado; abrir ou fechar o aparelho com o painel aberto troca de forma */
    addEventListener('pointerdown', trackX, true);
    Bridge.on('fold:state', () => { if (!built || !root) return; lastXT = 0; placeCard(page, true); setPage(page, false); });
  }

  return {
    init, open, close, toggle, back, pullStart, pullMove, pullEnd, headsUp,
    /* expand(): a pagina das definicoes rapidas (o harness e o "puxar outra vez" chamam-na) */
    expand: () => open('qs'),
    isOpen: () => opened,
    get page() { return page; }, get editing() { return editing; },
    /* para o harness: os mosaicos de origem e os disponiveis */
    DEFAULT_TILES: DEF.slice(), ALL_TILES: ALL.slice(),
  };
})();
