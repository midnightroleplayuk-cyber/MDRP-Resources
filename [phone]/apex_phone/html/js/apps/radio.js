/* ===================== RÁDIO (walkie-talkie, 5 out 2026) =====================
   Falar com quem está na mesma frequência, como num rádio. O servidor (server/radio.lua) decide quem entra
   (emprego e escalão nas frequências reservadas, item, auriculares, canais privados com código) e põe o jogador
   no canal de rádio do recurso de voz; o cliente (client/radio.lua) trata da voz, da tecla de falar com o
   telemóvel guardado e da vigia (morto, veículo, água, auriculares).
   · PearOS: mostrador escuro de rádio, botão de falar redondo; Nova UI: cartões claros, botão de falar em pílula.
   · Construído UMA vez por janela; os pushes só mudam texto e classes (sem repintar a vista).
   · Pushes: radio:joined / radio:left / radio:members / radio:talk / radio:event (servidor), radio:tx /
     radio:txfail / radio:blocked (cliente). Atividade na ilha enquanto ligado; ponto do microfone a transmitir.
   · Callbacks NUI (client/radio.lua): radioJoin, radioLeave, radioPtt, radioVolume, radioEnv, radioMode.
   · Modos de falar (RADIO2, Config.Radio.talkMode; com allowPlayerMode o jogador escolhe): 'ptt' manter o botão;
     'toggle' tocar liga/desliga; 'open' microfone aberto enquanto ligado (o botão silencia). O cliente manda o modo
     em vigor pelo push radio:mode { mode, muted, latched } e nas respostas do radioPtt / radioEnv / radioMode.
   ============================================================================= */
(() => {
  'use strict';
  if (!window.App || !App.define || !window.UI || !window.Icons) return;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => { if (window.L && L.tf) return L.tf(s, ...a); let i = 0; return String(s).replace(/%s/g, () => (a[i++] == null ? '' : a[i - 1])); };
  const esc = s => UI.esc(s);
  const g = (n, s) => Icons.g(n, s);
  const IN = !!(window.Bridge && Bridge.inFiveM);
  const isA = () => !!(window.System && System.isAndroid && System.isAndroid());

  /* ---------- glifo e ícones ----------
     glifo 24×24 (traço) do walkie-talkie: antena, corpo, visor e grelha do altifalante */
  if (Icons.P && !Icons.P.radio) Icons.P.radio = '<path d="M9 2.5v5"/><rect x="6" y="7.5" width="12" height="14" rx="2.6"/><rect x="9" y="10.3" width="6" height="3.6" rx=".9"/><path d="M9.3 17.2h5.4M9.3 19.3h5.4"/>';
  /* PearOS: fundo âmbar com o rádio branco em relevo (o vidro do Icons.SVG) e as duas ondas a sair da antena */
  Icons.app.radio = () => Icons.SVG(Icons.G('gRdo', '#FFB648', '#FF8A1E', '#EA620A') + Icons.GL(
    '<rect x="33" y="17" width="7.5" height="24" rx="3.75" fill="#fff"/>'
    + '<rect x="27" y="35" width="46" height="55" rx="12" fill="#fff"/>'
    + '<rect x="35" y="43" width="30" height="15" rx="4" fill="#EA620A"/>'
    + '<g fill="#F2A15E"><circle cx="40" cy="68" r="3"/><circle cx="50" cy="68" r="3"/><circle cx="60" cy="68" r="3"/><circle cx="40" cy="79" r="3"/><circle cx="50" cy="79" r="3"/><circle cx="60" cy="79" r="3"/></g>')
    + '<g fill="none" stroke="#fff" stroke-linecap="round" stroke-width="4.4"><path d="M43 12.5A10 10 0 0 1 46.6 24"/><path d="M47.6 5.2A18.5 18.5 0 0 1 54.6 26" opacity=".72"/></g>');
  /* Nova UI: superelipse a toda a área, cor viva com luz em cima, glifo grande e plano com o "lado" em tom claro.
     Sem ids de gradientes/recortes (um SVG inline repetido usa o PRIMEIRO id da página, ver icons-android.js): a forma é
     o próprio caminho e a luz é uma elipse translúcida */
  const SQ = 'M50 0C88 0 100 12 100 50S88 100 50 100 0 88 0 50 12 0 50 0Z';
  if (Icons.registerOS) Icons.registerOS('android', { radio: () => Icons.SVG(
    `<path d="${SQ}" fill="#F57A1F"/><ellipse cx="38" cy="8" rx="70" ry="44" fill="#FFB25A" opacity=".55"/><path d="${SQ}" fill="none" stroke="#fff" stroke-opacity=".28" stroke-width="2.2"/>`
    + '<g transform="translate(50 52) scale(.92) translate(-50 -52)">'
    + '<rect x="38" y="14" width="8" height="26" rx="4" fill="#FFE2C4"/>'
    + '<rect x="30" y="32" width="44" height="54" rx="13" fill="#FFE2C4" transform="translate(3.4 .4)"/>'
    + '<rect x="30" y="32" width="44" height="54" rx="13" fill="#fff"/>'
    + '<rect x="37" y="40" width="30" height="14" rx="4.5" fill="#F57A1F"/>'
    + '<g fill="#F7A766"><circle cx="42" cy="64" r="3.1"/><circle cx="52" cy="64" r="3.1"/><circle cx="62" cy="64" r="3.1"/><circle cx="42" cy="75" r="3.1"/><circle cx="52" cy="75" r="3.1"/><circle cx="62" cy="75" r="3.1"/></g></g>', true) });
  /* Nova UI: app do sistema (vistas e camadas no desenho da plataforma), como o Relógio ou a Calculadora */
  try { if (UI.OU_APPS && UI.OU_APPS.add) UI.OU_APPS.add('radio'); } catch (e) {}

  /* ---------- estado ---------- */
  const S = {
    env: null, loaded: false,
    cfg: { min: 1, max: 999.9, step: .1, dec: 1, mode: 'names', private: true, callsign: true, maxPresets: 12, maxMembers: 32, earbuds: false, item: false, defFreq: 100, defVol: 60, keepOnClose: true, preinstalled: true, sounds: { on: true, vol: .6, tx: true, rx: true },
      talkMode: 'ptt', playerMode: false, modes: ['ptt', 'toggle', 'open'], maxTalk: 60 },
    zones: [], joined: null, members: null, talk: new Map(), openMic: new Set(), tx: false, pending: false, busy: false,
    dial: null, prefs: { presets: [], vol: 60, cs: null, last: null, mode: null }, key: null, worn: false, hasItem: true,
    mode: 'ptt', muted: false, latched: false,
  };
  /* modos de falar: nome mostrado (o mesmo texto do painel admin) e ícone da folha de escolha */
  const MODE_NAME = { ptt: 'Manter para falar', toggle: 'Carregar para ligar/desligar', open: 'Microfone aberto' };
  const MODE_ICON = { ptt: 'mic', toggle: 'power', open: 'speaker' };
  const MODES = ['ptt', 'toggle', 'open'];
  /* modo previsto pela config (antes de o cliente responder): o do jogador se o servidor deixar escolher */
  const cfgMode = () => { const p = S.prefs.mode, ok = Array.isArray(S.cfg.modes) ? S.cfg.modes : MODES; return S.cfg.playerMode && p && ok.includes(p) ? p : (MODES.includes(S.cfg.talkMode) ? S.cfg.talkMode : 'ptt'); };
  function applyMode(r) {
    if (!r || typeof r !== 'object' || !MODES.includes(r.mode)) return false;
    const ch = S.mode !== r.mode || S.muted !== !!r.muted || S.latched !== !!r.latched;
    S.mode = r.mode; S.muted = !!r.muted; S.latched = !!r.latched;
    return ch;
  }
  const views = new Set();
  const repaint = what => views.forEach(v => { try { v.paint(what || 'all'); } catch (e) { console.error('[apex_phone] radio paint', e); } });
  const fmt = f => (Number.isFinite(+f) ? (+f).toFixed(S.cfg.dec) : '---');
  const snap = f => { const st = S.cfg.step || .1; let v = Math.round(+f / st) * st; v = Math.max(S.cfg.min, Math.min(S.cfg.max, v)); return +v.toFixed(S.cfg.dec); };
  const keyOf = f => Math.round(+f * Math.pow(10, S.cfg.dec));
  const zoneOf = f => S.zones.find(z => f >= z.from - 1e-9 && f <= z.to + 1e-9) || null;
  const visible = () => !document.body.classList.contains('hidden');
  const tell = msg => { if (msg && visible()) UI.toast(msg, 2400); };

  /* ---------- callbacks do client/radio.lua (no browser: o "servidor" de mentira lá em baixo) ---------- */
  function call(name, data) {
    if (IN) return Bridge.call(name, data || {}).then(r => r || { error: 'timeout' });
    return Promise.resolve().then(() => MOCK[name] ? MOCK[name](data || {}) : null);
  }

  /* ---------- estado vindo do servidor ---------- */
  function applyMembers(m) {
    S.members = m && typeof m === 'object' ? m : null;
    S.talk.clear(); S.openMic.clear();
    if (S.members && Array.isArray(S.members.list)) S.members.list.forEach(x => { if (x.talk && (!S.joined || x.tag !== S.joined.tag)) { S.talk.set(x.tag, x.label || ''); if (x.open) S.openMic.add(x.tag); } });
    if (S.joined && S.members && S.members.count != null) S.joined.count = S.members.count;
  }
  function applyJoined(j, m) {
    if (!j || typeof j !== 'object') { S.joined = null; S.members = null; S.talk.clear(); S.openMic.clear(); return; }
    S.joined = { key: j.key, freq: +j.freq, label: j.label || fmt(j.freq), tag: j.tag, locked: !!j.locked, zone: j.zone || false, count: j.count };
    S.dial = +j.freq;
    if (m) applyMembers(m);
  }
  function applyState(st) {
    if (!st || typeof st !== 'object' || st.error) { S.env = { enabled: true, supported: false, missing: true }; return; }
    S.env = { enabled: st.enabled !== false, supported: !!st.supported, provider: st.provider || 'none' };
    if (st.cfg) S.cfg = Object.assign({}, S.cfg, st.cfg);
    S.zones = Array.isArray(st.zones) ? st.zones : [];
    if (st.prefs && typeof st.prefs === 'object') S.prefs = { presets: Array.isArray(st.prefs.presets) ? st.prefs.presets : [], vol: st.prefs.vol != null ? +st.prefs.vol : S.cfg.defVol, cs: st.prefs.cs || null, last: st.prefs.last != null ? +st.prefs.last : null, mode: MODES.includes(st.prefs.mode) ? st.prefs.mode : null };
    if (!S.joined) S.mode = cfgMode();
    S.worn = !!st.earbuds; S.hasItem = st.hasItem !== false;
    applyJoined(st.joined || null, st.members || null);
    if (S.joined && Array.isArray(st.talkers)) st.talkers.forEach(t => { if (t !== S.joined.tag && !S.talk.has(t)) S.talk.set(t, labelOfTag(t)); });
    if (S.dial == null) S.dial = snap(S.prefs.last != null ? S.prefs.last : S.cfg.defFreq);
  }
  const labelOfTag = tag => { const l = S.members && Array.isArray(S.members.list) ? S.members.list.find(x => x.tag === tag) : null; return l ? (l.label || '') : ''; };

  let loadP = null;
  function load(force) {
    if (loadP && !force) return loadP;
    /* o radioEnv vai depois do estado: leva a escolha gravada do jogador (modo de falar) e devolve o modo em vigor */
    loadP = Bridge.rpcRaw('radio.state').then(st => { applyState(st); return call('radioEnv', { pmode: S.prefs.mode || false }); }).then(env => {
      if (env && !env.error) { S.key = env.key || null; if (env.worn != null) S.worn = !!env.worn || S.worn; applyMode(env); }
      S.loaded = true; syncApp(); activity(); repaint('all'); return S;
    }).catch(e => { console.error('[apex_phone] radio.state', e); S.loaded = true; repaint('all'); return S; });
    return loadP;
  }

  /* a app esconde-se com Config.Radio.enabled = false (como as apps desligadas no painel admin) */
  function syncApp() {
    const d = App.get('radio'); if (!d) return;
    const want = !!(S.env && S.env.enabled === false) || !!(System.adminDisabled && System.adminDisabled('radio'));
    if (!!d.hidden === want) return;
    d.hidden = want;
    if (want) { try { System.killApp && System.killApp('radio'); } catch (e) {} }
    Bridge.emit('apps:changed');
  }

  /* instalada UMA vez no ecrã principal (Config.Radio.preinstalled); quem a desinstalar fica sem ela */
  function seed() {
    if (!IN || !S.cfg.preinstalled || !S.env || S.env.enabled === false) return;
    if (!System.state || !System.state.setupDone) return;
    let done = false; try { done = !!Store.get('rdoSeed', false); } catch (e) {}
    if (done) return;
    try { Store.set('rdoSeed', true); } catch (e) {}
    try { if (!System.isInstalled('radio')) Promise.resolve(System.install('radio')).catch(() => {}); } catch (e) {}
  }

  /* ---------- preferências por personagem (favoritos, volume, indicativo, última frequência) ---------- */
  let prefT = null, prefPend = {};
  function savePrefs(patch, now) {
    Object.assign(prefPend, patch || {});
    clearTimeout(prefT);
    const go = () => { const d = prefPend; prefPend = {}; Bridge.rpcRaw('radio.prefs', d).then(r => { if (r && r.prefs) { S.prefs = Object.assign({}, S.prefs, r.prefs); repaint('presets'); } }); };
    if (now) go(); else prefT = setTimeout(go, 700);
  }

  /* ---------- sons (sintetizados, sem ficheiros; curtos e nunca em ciclo) ---------- */
  let actx = null;
  function sfx(kind) {
    const so = S.cfg.sounds || {};
    if (so.on === false || (System.state && System.state.sounds === false)) return;
    if (/^tx/.test(kind) && so.tx === false) return;
    if (/^rx/.test(kind) && so.rx === false) return;
    try { actx = actx || new (window.AudioContext || window.webkitAudioContext)(); } catch (e) { return; }
    if (!actx) return; if (actx.state === 'suspended') { try { actx.resume(); } catch (e) {} }
    const V = Math.max(0, Math.min(1, +so.vol || .6)) * .32, t0 = actx.currentTime;
    const tone = (f, at, d, gain, type) => { const o = actx.createOscillator(), a = actx.createGain(); o.type = type || 'sine'; o.frequency.setValueAtTime(f, t0 + at); a.gain.setValueAtTime(0, t0 + at); a.gain.linearRampToValueAtTime(gain, t0 + at + .006); a.gain.exponentialRampToValueAtTime(.0001, t0 + at + d); o.connect(a); a.connect(actx.destination); o.start(t0 + at); o.stop(t0 + at + d + .02); };
    const noise = (at, d, gain, band) => { const n = Math.floor(actx.sampleRate * d), b = actx.createBuffer(1, n, actx.sampleRate), ch = b.getChannelData(0); for (let i = 0; i < n; i++) ch[i] = Math.random() * 2 - 1;
      const s = actx.createBufferSource(); s.buffer = b; const f = actx.createBiquadFilter(); f.type = 'bandpass'; f.frequency.value = band; f.Q.value = .9; const a = actx.createGain(); a.gain.setValueAtTime(gain, t0 + at); a.gain.exponentialRampToValueAtTime(.0001, t0 + at + d); s.connect(f); f.connect(a); a.connect(actx.destination); s.start(t0 + at); };
    if (kind === 'txOn') { tone(1250, 0, .045, V * .55); tone(1650, .05, .05, V * .55); }
    else if (kind === 'txOff') { tone(1650, 0, .045, V * .5); tone(1150, .05, .07, V * .5); }
    else if (kind === 'rxOn') noise(0, .07, V * .9, 2600);
    else if (kind === 'rxOff') { noise(0, .18, V, 1900); tone(950, .01, .04, V * .25); }
    else if (kind === 'join') { tone(880, 0, .07, V * .6); tone(1320, .08, .1, V * .6); }
    else if (kind === 'leave') { tone(1320, 0, .07, V * .6); tone(880, .08, .12, V * .6); }
  }

  /* ---------- atividade na ilha (enquanto ligado) ---------- */
  let actOn = false;
  /* quem tem o microfone aberto (modo open) "transmite" a sessão toda: não conta como "a falar" nas linhas de estado */
  const talkers = () => [...S.talk.entries()].filter(([tag]) => !S.openMic.has(tag));
  const talkerText = () => { const l = talkers(); if (!l.length) return null; if (l.length > 1) return TF('%s pessoas a falar', l.length); const n = l[0][1]; return n ? TF('%s está a falar', S.cfg.mode === 'numbers' ? UI.phone(n) : n) : T('Alguém está a falar'); };
  const isOpen = () => S.mode === 'open';
  const openText = () => S.muted ? T('Microfone silenciado') : T('Microfone aberto');
  const countText = () => { const n = S.joined && S.joined.count; if (n == null) return T('Ligado'); return n === 1 ? T('Só tu nesta frequência') : TF('%s pessoas ligadas', n); };
  function activity() {
    if (!window.Island) return;
    try {
      if (!S.joined) { if (actOn) { actOn = false; Island.stop('radio'); } return; }
      /* microfone aberto: a ilha diz sempre se o microfone está aberto ou silenciado (e quem fala por cima) */
      const rx = talkers().length > 0;
      const d = isOpen()
        ? { app: 'radio', icon: 'radio', title: TF('%s MHz', S.joined.label), subtitle: talkerText() || openText(), state: S.tx ? T('Microfone aberto') : S.muted ? T('Silenciado') : rx ? T('A receber') : T('Ligado'), onTap: () => System.openApp('radio') }
        : { app: 'radio', icon: 'radio', title: TF('%s MHz', S.joined.label), subtitle: S.tx ? T('A transmitir') : (talkerText() || countText()), state: S.tx ? T('A transmitir') : rx ? T('A receber') : T('Ligado'), onTap: () => System.openApp('radio') };
      if (!actOn) { actOn = true; Island.activity('radio', d); } else Island.update('radio', d);
    } catch (e) { console.error('[apex_phone] radio atividade', e); }
  }

  /* ---------- mensagens ---------- */
  const LEFT = {
    dead: 'O rádio desligou-se: estás inconsciente.', vehicle: 'O rádio não funciona dentro de veículos.', water: 'O rádio desligou-se dentro de água.',
    earbuds: 'Tiraste os auriculares: o rádio desligou-se.', item: 'Já não tens o rádio necessário.', nophone: 'Já não tens o telemóvel: o rádio desligou-se.',
    restricted: 'Já não tens acesso a esta frequência.', disabled: 'O rádio foi desativado pelo servidor.', novoice: 'O sistema de voz deixou de estar disponível.',
    closed: 'Guardaste o telemóvel: o rádio desligou-se.', external: 'Foste retirado da frequência.', logout: '',
  };
  const BLOCK = { dead: 'Não podes usar o rádio agora.', vehicle: 'O rádio não funciona dentro de veículos.', water: 'O rádio não funciona dentro de água.', earbuds: 'Põe os auriculares para usar o rádio.' };
  function errText(r) {
    const e = r && r.error;
    switch (e) {
      case 'disabled': return T('O rádio está desativado neste servidor.');
      case 'novoice': return T('Este servidor não tem um sistema de voz com rádio.');
      case 'earbuds': return T('Põe os auriculares para usar o rádio.');
      case 'item': return r.item ? TF('Precisas de %s para usar o rádio.', r.item) : T('Precisas de um rádio para usar esta app.');
      case 'nophone': return T('Precisas do telemóvel para usar o rádio.');
      case 'range': return TF('Escolhe uma frequência entre %s e %s MHz.', fmt(r.min != null ? r.min : S.cfg.min), fmt(r.max != null ? r.max : S.cfg.max));
      case 'restricted': return r.zone ? TF('Frequência reservada: %s.', T(r.zone)) : T('Esta frequência é reservada.');
      case 'full': return T('Esta frequência está cheia.');
      case 'badpass': return T('Código errado.');
      case 'ratelimit': return T('Demasiados pedidos. Espera um pouco.');
      case 'dead': case 'vehicle': case 'water': return T(BLOCK[e]);
      default: return T('Tenta novamente.');
    }
  }

  /* ---------- ações ---------- */
  async function join(f, pass) {
    if (S.busy) return;
    if (S.env && (!S.env.supported || S.env.enabled === false)) { tell(errText({ error: S.env.enabled === false ? 'disabled' : 'novoice' })); return; }
    f = snap(f); S.dial = f; S.busy = true; repaint('dial');
    let r = null; try { r = await call('radioJoin', pass ? { freq: f, pass } : { freq: f }); } catch (e) { r = null; }
    S.busy = false;
    if (r && r.ok) {
      applyJoined(r.joined, r.members); activity();
      if (pass && r.joined && !r.joined.locked) tell(T('A frequência já estava aberta: o código não foi usado.'));
      savePrefs({ last: f });
    } else if (r && r.error === 'locked') {
      repaint('all');
      const code = await UI.prompt(T('Canal privado'), T('Esta frequência tem código. Escreve-o para entrar.'), T('Código'), '', 'password');
      if (code) return join(f, code);
    } else {
      if (r && r.error === 'earbuds') S.worn = false;
      if (r && r.error === 'item') S.hasItem = false;
      UI.alert({ title: T('Não foi possível ligar'), msg: errText(r) });
    }
    repaint('all');
  }
  async function leave() {
    if (!S.joined || S.busy) return;
    S.busy = true; repaint('dial');
    try { await call('radioLeave', {}); } catch (e) {}
    S.busy = false;
    repaint('all');   /* o push 'radio:left' do servidor limpa o estado */
  }
  /* mexer no mostrador com o rádio ligado muda de frequência ao parar (como rodar o botão de um rádio) */
  let tuneT = null;
  function tune(f, now) {
    S.dial = snap(f); repaint('dial');
    clearTimeout(tuneT);
    if (!S.joined || keyOf(S.dial) === S.joined.key) return;
    tuneT = setTimeout(() => join(S.dial), now ? 0 : 650);
  }
  const presetAt = f => (S.prefs.presets || []).findIndex(p => keyOf(p.f) === keyOf(f));
  async function toggleFav() {
    const f = snap(S.dial), i = presetAt(f), list = (S.prefs.presets || []).slice();
    if (i > -1) { list.splice(i, 1); S.prefs.presets = list; repaint('presets'); savePrefs({ presets: list }, true); UI.toast(T('Removido dos favoritos')); return; }
    if (list.length >= S.cfg.maxPresets) { UI.alert({ title: T('Favoritos cheios'), msg: TF('Podes guardar até %s frequências.', S.cfg.maxPresets) }); return; }
    const n = await UI.prompt(T('Guardar frequência'), TF('%s MHz', fmt(f)), T('Nome (opcional)'), '');
    if (n === null) return;
    list.push({ f, n: n.trim().slice(0, 20) || null }); S.prefs.presets = list; repaint('presets'); savePrefs({ presets: list }, true);
  }
  async function presetMenu(p, el) {
    const v = await UI.actionSheet({ title: TF('%s MHz', fmt(p.f)) + (p.n ? ' · ' + p.n : ''), buttons: [{ label: T('Mudar o nome'), icon: 'pen', value: 'ren' }, { label: T('Remover'), icon: 'trash', danger: true, value: 'del' }] });
    const list = (S.prefs.presets || []).slice(), i = list.findIndex(x => keyOf(x.f) === keyOf(p.f)); if (i < 0) return;
    if (v === 'ren') { const n = await UI.prompt(T('Nome'), TF('%s MHz', fmt(p.f)), T('Nome (opcional)'), p.n || ''); if (n === null) return; list[i] = { f: p.f, n: n.trim().slice(0, 20) || null }; }
    else if (v === 'del') list.splice(i, 1);
    else return;
    S.prefs.presets = list; repaint('presets'); savePrefs({ presets: list }, true);
  }
  async function editCallsign() {
    const n = await UI.prompt(T('Indicativo'), T('Aparece aos outros em vez do teu nome. Deixa vazio para usar o nome.'), T('Ex.: Alfa 1'), S.prefs.cs || '');
    if (n === null) return;
    S.prefs.cs = n.trim().slice(0, 16) || null; savePrefs({ cs: S.prefs.cs || '' }, true); repaint('members');
  }
  /* modo de falar escolhido pelo jogador (só com Config.Radio.allowPlayerMode; gravado por personagem) */
  async function chooseMode() {
    const list = (Array.isArray(S.cfg.modes) && S.cfg.modes.length ? S.cfg.modes : MODES).filter(m => MODES.includes(m));
    const v = await UI.actionSheet({ title: T('Modo de falar'), buttons: list.map(m => ({ label: T(MODE_NAME[m]), icon: m === S.mode ? 'check' : MODE_ICON[m], bold: m === S.mode, value: m })) });
    if (!v || !MODES.includes(v)) return;
    S.prefs.mode = v; savePrefs({ mode: v }, true);
    let r = null; try { r = await call('radioMode', { mode: v }); } catch (e) { r = null; }
    if (!applyMode(r) && !(r && r.mode)) S.mode = v;
    activity(); repaint('ptt');
  }
  async function privateJoin() {
    if (S.joined) { tell(S.joined.locked ? T('Canal privado: só entra quem tiver o código.') : T('Canal aberto: qualquer pessoa pode entrar.')); return; }
    const code = await UI.prompt(T('Canal privado'), T('Escolhe um código. Se a frequência estiver livre, só entra quem o souber.'), T('Código'), '', 'password');
    if (code) join(S.dial, code);
  }
  function keypad() {
    let s = '';
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', S.cfg.dec ? '.' : '', '0', 'del'];
    const body = UI.el(`<div class="rdo-kp"><div class="rdo-kp-disp"><span class="rdo-kp-v"></span><span class="rdo-kp-u">MHz</span></div><div class="rdo-kp-hint"></div><div class="rdo-kp-grid">${keys.map(k => `<button type="button" class="rdo-key ${k ? '' : 'ph'}" data-k="${k}">${k === 'del' ? g('backspace', 24) : esc(k)}</button>`).join('')}</div></div>`);
    const vEl = body.querySelector('.rdo-kp-v'), hEl = body.querySelector('.rdo-kp-hint');
    const paint = () => { vEl.textContent = s || fmt(S.dial); vEl.classList.toggle('ph', !s); const f = parseFloat(s); const z = s && Number.isFinite(f) ? zoneOf(f) : null;
      hEl.textContent = z ? (z.label ? TF('Reservada: %s', T(z.label)) : T('Frequência reservada')) + (z.allowed ? '' : ' · ' + T('sem acesso')) : TF('De %s a %s MHz', fmt(S.cfg.min), fmt(S.cfg.max));
      hEl.classList.toggle('warn', !!(z && !z.allowed)); };
    body.querySelectorAll('.rdo-key').forEach(b => b.onclick = () => { const k = b.dataset.k; if (!k) return; Sound.play('keypad');
      if (k === 'del') s = s.slice(0, -1);
      else if (k === '.') { if (!s.includes('.') && S.cfg.dec) s = (s || '0') + '.'; }
      else { const dot = s.indexOf('.'); if (dot > -1 && s.length - dot > S.cfg.dec) return; if (dot < 0 && s.replace(/^0+/, '').length >= String(Math.floor(S.cfg.max)).length) return; s = (s === '0' ? '' : s) + k; }
      paint(); });
    paint();
    UI.sheet({ title: T('Sintonizar'), left: T('Cancelar'), right: S.joined ? T('Mudar') : T('OK'), body, cls: 'rdo-sheet', onDone: () => {
      if (!s) return;
      const f = parseFloat(s);
      if (!Number.isFinite(f) || f < S.cfg.min - 1e-9 || f > S.cfg.max + 1e-9) { UI.toast(errText({ error: 'range' })); return false; }
      tune(f, true); } });
  }

  /* ---------- a vista ---------- */
  function build(win) {
    const A = isA();
    let csBtn = null;   /* indicativo: só com Config.Radio.allowCallsign e a lista por nomes (escondido pelo paintDial) */
    const v = UI.view({ title: App.name('radio'), large: true, cls: 'rdo-view', right: [{ icon: 'personCircle', label: T('Indicativo'), onTap: () => editCallsign(), ref: b => { csBtn = b; } }] });
    const root = UI.el(`<div class="rdo ${A ? 'rdo-a' : 'rdo-i'}">
      <div class="rdo-col rdo-c1">
        <div class="rdo-note" hidden><span class="rdo-note-ic">${g('info', 20)}</span><span class="rdo-note-t"></span></div>
        <div class="rdo-dial">
          <div class="rdo-top"><span class="rdo-st"><i class="rdo-dot"></i><b class="rdo-stt"></b></span><span class="rdo-zone" hidden>${g('shield', 14)}<span></span></span><span class="rdo-om" hidden><i class="rdo-om-ic"></i><span></span></span><span class="rdo-lk" hidden>${g('lock', 15)}</span></div>
          <div class="rdo-freqrow">
            <button type="button" class="rdo-step" data-d="-1" aria-label="-">${g('minus', 26)}</button>
            <div class="rdo-freq"><span class="rdo-fv"></span><span class="rdo-unit">MHz</span></div>
            <button type="button" class="rdo-step" data-d="1" aria-label="+">${g('plus', 26)}</button>
          </div>
          <div class="rdo-sub"></div>
          <div class="rdo-acts">
            <button type="button" class="rdo-act rdo-kpb">${g('keypad', 21)}</button>
            <button type="button" class="rdo-act rdo-fav">${g('star', 21)}</button>
            <button type="button" class="rdo-act rdo-pv" hidden>${g('lock', 20)}</button>
            <button type="button" class="rdo-power"><span class="rdo-pw-ic">${g('power', 19)}</span><span class="rdo-pw-t"></span></button>
          </div>
        </div>
        <div class="rdo-pttwrap">
          <button type="button" class="rdo-ptt"><span class="rdo-ptt-ring"></span><span class="rdo-ptt-ic">${g('mic', A ? 30 : 40)}</span><b class="rdo-ptt-t"></b></button>
          <div class="rdo-line"><i class="rdo-ldot"></i><span class="rdo-line-t"></span></div>
          <div class="rdo-hint" hidden></div>
        </div>
        <button type="button" class="rdo-card rdo-mode" hidden><span class="rdo-mode-ic">${g('mic', 20)}</span><span class="rdo-mode-t"><b></b><small></small></span><span class="rdo-mode-ch">${g('chevR', 16)}</span></button>
        <div class="rdo-card rdo-vol">${g('speakerLow', 20)}<input type="range" min="0" max="100" step="1" class="rdo-range">${g('speaker', 20)}<span class="rdo-vv"></span></div>
      </div>
      <div class="rdo-col rdo-c2">
        <div class="rdo-sec rdo-psec"><span></span></div>
        <div class="rdo-pre"></div>
        <div class="rdo-sec rdo-msec" hidden><span></span><em class="rdo-mcount"></em></div>
        <div class="rdo-card rdo-members" hidden></div>
      </div>
    </div>`);
    v.content.appendChild(root);
    const $ = s => root.querySelector(s);
    const fv = $('.rdo-fv'), stt = $('.rdo-stt'), sub = $('.rdo-sub'), zone = $('.rdo-zone'), lk = $('.rdo-lk'), note = $('.rdo-note'), noteT = $('.rdo-note-t');
    const power = $('.rdo-power'), pwT = $('.rdo-pw-t'), fav = $('.rdo-fav'), pv = $('.rdo-pv'), ptt = $('.rdo-ptt'), pttT = $('.rdo-ptt-t'), lineT = $('.rdo-line-t'), hint = $('.rdo-hint');
    const range = $('.rdo-range'), vv = $('.rdo-vv'), pre = $('.rdo-pre'), psec = $('.rdo-psec span'), msec = $('.rdo-msec'), mcount = $('.rdo-mcount'), mbox = $('.rdo-members');
    const om = $('.rdo-om'), omT = $('.rdo-om span'), omIc = $('.rdo-om-ic'), pttIc = $('.rdo-ptt-ic'), modeBtn = $('.rdo-mode'), modeIc = $('.rdo-mode-ic'), modeB = $('.rdo-mode-t b'), modeS = $('.rdo-mode-t small');
    modeB.textContent = T('Modo de falar');
    modeBtn.onclick = () => { Sound.play('click'); chooseMode(); };
    $('.rdo-msec span').textContent = T('Na frequência');
    psec.textContent = T('Favoritos');
    $('.rdo-kpb').onclick = () => { Sound.play('click'); keypad(); };
    fav.onclick = () => { Sound.play('click'); toggleFav(); };
    pv.onclick = () => { Sound.play('click'); privateJoin(); };
    power.onclick = () => { Sound.play('click'); if (S.joined) leave(); else join(S.dial); };

    /* +/-: toque = um passo; manter = repete (só o mostrador; muda de frequência ao largar) */
    root.querySelectorAll('.rdo-step').forEach(b => {
      let t1 = null, t2 = null;
      const stop = () => { clearTimeout(t1); clearInterval(t2); t1 = t2 = null; };
      const step = () => { const d = +b.dataset.d; let f = (S.dial == null ? S.cfg.defFreq : S.dial) + d * S.cfg.step; if (f > S.cfg.max + 1e-9) f = S.cfg.min; if (f < S.cfg.min - 1e-9) f = S.cfg.max; Sound.play('tick'); tune(f); };
      b.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; step(); t1 = setTimeout(() => { t2 = setInterval(step, 90); }, 420); });
      ['pointerup', 'pointercancel', 'pointerleave'].forEach(ev => b.addEventListener(ev, stop));
    });

    /* falar: premir e manter (o ponteiro fica capturado; largar em qualquer lado acaba).
       Modos toggle e open: um toque (liga/desliga a transmissão; no microfone aberto silencia/abre) */
    let held = false;
    const down = e => {
      if (e.button && e.pointerType === 'mouse') return;
      if (!S.joined) { tell(T('Liga o rádio para falar.')); return; }
      if (S.mode !== 'ptt') {
        e.preventDefault();
        call('radioPtt', { tap: true }).then(r => { if (applyMode(r)) { activity(); repaint('ptt'); } });
        return;
      }
      e.preventDefault(); try { ptt.setPointerCapture(e.pointerId); } catch (x) {}
      if (held) return; held = true; S.pending = true; ptt.classList.add('down'); paintPtt();
      call('radioPtt', { on: true });
    };
    const up = () => { if (!held) return; held = false; S.pending = false; ptt.classList.remove('down'); paintPtt(); call('radioPtt', { on: false }); };
    ptt.addEventListener('pointerdown', down); ptt.addEventListener('pointerup', up); ptt.addEventListener('pointercancel', up); ptt.addEventListener('lostpointercapture', up);
    ptt.addEventListener('contextmenu', e => e.preventDefault());
    v._release = up;

    /* volume: o cliente aplica já (por cima de 120 ms) e grava ao largar */
    let volT = 0;
    range.addEventListener('input', () => { const n = +range.value; S.prefs.vol = n; paintVol(); const now = Date.now(); if (now - volT > 120) { volT = now; call('radioVolume', { v: n }); } });
    range.addEventListener('change', () => { call('radioVolume', { v: +range.value }); savePrefs({ vol: +range.value }); });

    /* ---- pintar (só texto, classes e atributos; a árvore não se refaz) ---- */
    const on = () => !!S.joined;
    function paintRoot() {
      const dis = !S.loaded || !S.env || !S.env.supported || S.env.enabled === false;
      root.classList.toggle('dis', dis);
      root.classList.toggle('on', on());
      root.classList.toggle('tx', on() && S.tx);
      root.classList.toggle('rx', on() && !S.tx && talkers().length > 0);
      root.classList.toggle('busy', S.busy);
      root.classList.toggle('m-open', isOpen()); root.classList.toggle('m-toggle', S.mode === 'toggle');
      root.classList.toggle('muted', on() && isOpen() && S.muted);
      /* aviso no topo: sem voz, desligado, requisitos */
      let n = '';
      if (S.loaded && S.env) {
        if (S.env.missing) n = T('O rádio não está disponível neste servidor.');
        else if (S.env.enabled === false) n = T('O rádio está desativado neste servidor.');
        else if (!S.env.supported) n = T('Este servidor não tem um sistema de voz com rádio. A app fica desligada.');
        else if (!on() && S.cfg.earbuds && !S.worn) n = T('Põe os auriculares para usar o rádio.');
        else if (!on() && S.cfg.item && !S.hasItem) n = TF('Precisas de %s para usar o rádio.', S.cfg.item);
      }
      note.hidden = !n; if (noteT.textContent !== n) noteT.textContent = n;
    }
    function paintDial() {
      const f = S.dial == null ? S.cfg.defFreq : S.dial, txt = fmt(f);
      if (fv.textContent !== txt) fv.textContent = txt;
      const tuning = on() && keyOf(f) !== S.joined.key;
      stt.textContent = S.busy ? T('A sintonizar…') : !on() ? T('Desligado') : (S.tx && !isOpen()) ? T('A transmitir') : talkers().length ? T('A receber') : tuning ? TF('Em %s', S.joined.label) : T('Ligado');
      /* microfone aberto: etiqueta sempre visível no mostrador (aberto a vermelho, silenciado a cinzento) */
      const omOn = on() && isOpen();
      om.hidden = !omOn;
      if (omOn) { const t = openText(); if (omT.textContent !== t) omT.textContent = t; if (om._m !== S.muted) { om._m = S.muted; omIc.innerHTML = g(S.muted ? 'micOff' : 'mic', 14); om.classList.toggle('off', S.muted); } }
      const z = zoneOf(f);
      zone.hidden = !z; if (z) { zone.lastChild.textContent = (z.label ? T(z.label) : T('Reservada')) + (z.allowed ? '' : ' · ' + T('sem acesso')); zone.classList.toggle('no', !z.allowed); }
      lk.hidden = !(on() && S.joined.locked);
      const subT = !on() ? (S.prefs.last != null && keyOf(S.prefs.last) !== keyOf(f) ? TF('Última: %s MHz', fmt(S.prefs.last)) : TF('Banda %s a %s MHz', fmt(S.cfg.min), fmt(S.cfg.max)))
        : tuning ? T('Larga para mudar de frequência') : (S.joined.locked ? T('Canal privado') : countText());
      if (sub.textContent !== subT) sub.textContent = subT;
      pwT.textContent = on() ? T('Desligar') : T('Ligar rádio');   /* 'Ligar' sozinho e o de fazer uma chamada ("Call") */
      const isFav = presetAt(f) > -1;
      if (fav._on !== isFav) { fav._on = isFav; fav.classList.toggle('sel', isFav); fav.innerHTML = g(isFav ? 'starFill' : 'star', 21); }
      if (csBtn) csBtn.hidden = !(S.cfg.callsign && S.cfg.mode === 'names');
      pv.hidden = !S.cfg.private; pv.classList.toggle('sel', !!(on() && S.joined.locked));
    }
    function paintPtt() {
      const down = ptt.classList.contains('down'), m = S.mode;
      let t;
      if (!on()) t = T('Desligado');
      else if (m === 'open') t = S.muted ? T('Silenciado') : S.tx ? T('Microfone aberto') : T('A abrir o microfone…');
      else if (m === 'toggle') t = (S.tx || S.latched) ? T('Toca para parar') : T('Toca para falar');
      else t = (S.tx || down) ? T('A transmitir') : T('Manter para falar');
      if (pttT.textContent !== t) pttT.textContent = t;
      const mic = on() && m === 'open' && S.muted ? 'micOff' : 'mic';
      if (pttIc._g !== mic) { pttIc._g = mic; pttIc.innerHTML = g(mic, isA() ? 30 : 40); }
      ptt.classList.toggle('live', on() && (S.tx || down));
      let l = '';
      if (!on()) l = T('Liga o rádio para falar.');
      else if (m === 'open') l = talkerText() || (S.muted ? T('Toca no botão para voltares a falar.') : T('Todos na frequência te ouvem.'));
      else if (S.tx) l = T('Estás a transmitir');
      else l = talkerText() || T('Em escuta');
      if (lineT.textContent !== l) lineT.textContent = l;
      let k = '';
      if (on() && S.key) k = m === 'open' ? TF('%s silencia o microfone', S.key) : m === 'toggle' ? TF('%s liga e desliga a transmissão', S.key) : TF('Tecla de rádio: %s', S.key);
      hint.hidden = !k; if (hint.textContent !== k) hint.textContent = k;
      /* escolha do modo pelo jogador (Config.Radio.allowPlayerMode) */
      const pm = !!S.cfg.playerMode;
      modeBtn.hidden = !pm;
      if (pm) { const s = T(MODE_NAME[m] || MODE_NAME.ptt); if (modeS.textContent !== s) modeS.textContent = s; if (modeIc._g !== m) { modeIc._g = m; modeIc.innerHTML = g(MODE_ICON[m] || 'mic', 20); } }
    }
    function paintVol() { const n = Math.max(0, Math.min(100, +S.prefs.vol || 0)); if (+range.value !== n) range.value = n; range.style.setProperty('--p', n + '%'); vv.textContent = n + '%'; }
    function paintPresets() {
      const list = S.prefs.presets || [];
      const cur = S.dial == null ? null : keyOf(S.dial);
      /* só refaz quando a lista mudou (a frequência atual só troca a classe) */
      const sig = JSON.stringify(list) + '|' + S.cfg.dec;
      if (pre._sig !== sig) {
        pre._sig = sig; pre.textContent = '';
        list.forEach(p => {
          const c = UI.el(`<button type="button" class="rdo-chip" data-k="${keyOf(p.f)}"><b></b>${p.n ? '<small></small>' : ''}</button>`);
          c.querySelector('b').textContent = fmt(p.f); if (p.n) c.querySelector('small').textContent = p.n;
          c.onclick = () => { if (c._lp) { c._lp = false; return; } Sound.play('click'); tune(p.f, true); };
          UI.longPress(c, () => { c._lp = true; presetMenu(p, c); });
          pre.appendChild(c);
        });
        const add = UI.el(`<button type="button" class="rdo-chip add">${g('plus', 16)}<span></span></button>`);
        add.querySelector('span').textContent = T('Guardar');
        add.onclick = () => { Sound.play('click'); toggleFav(); };
        pre.appendChild(add);
      }
      pre.querySelectorAll('.rdo-chip[data-k]').forEach(c => c.classList.toggle('cur', +c.dataset.k === cur));
      pre.lastElementChild.hidden = presetAt(S.dial) > -1 || list.length >= S.cfg.maxPresets;
    }
    function paintMembers() {
      const m = S.members || { mode: S.cfg.mode };
      const show = on();
      msec.hidden = !show; mbox.hidden = !show;
      if (!show) { if (mbox.childNodes.length) mbox.textContent = ''; return; }
      const cnt = m.mode === 'none' ? '' : String(m.count != null ? m.count : (S.joined.count || 1));
      if (mcount.textContent !== cnt) mcount.textContent = cnt;
      if (m.mode === 'none' || m.mode === 'count') {
        const txt = m.mode === 'none' ? T('A lista de quem está ligado está escondida neste servidor.') : (m.count === 1 ? T('Só tu nesta frequência') : TF('%s pessoas ligadas', m.count || 0));
        let e = mbox.querySelector(':scope > .rdo-mempty');
        if (!e || mbox.children.length !== 1) { mbox.textContent = ''; e = UI.el('<div class="rdo-mempty"></div>'); mbox.appendChild(e); }
        if (e.textContent !== txt) e.textContent = txt;
        return;
      }
      const list = Array.isArray(m.list) ? m.list : [];
      const want = new Set(list.map(x => String(x.tag)));
      mbox.querySelectorAll(':scope > .rdo-mempty').forEach(x => x.remove());
      mbox.querySelectorAll(':scope > .rdo-mrow').forEach(r => { if (!want.has(r.dataset.tag)) r.remove(); });
      list.forEach((x, i) => {
        let r = mbox.querySelector(`:scope > .rdo-mrow[data-tag="${x.tag}"]`);
        if (!r) { r = UI.el(`<div class="rdo-mrow" data-tag="${x.tag}"><div class="rdo-av"></div><div class="rdo-mn"><b></b><span></span></div><div class="rdo-mic">${g('mic', 16)}</div></div>`); }
        if (mbox.children[i] !== r) mbox.insertBefore(r, mbox.children[i] || null);
        const me = S.joined && x.tag === S.joined.tag, num = m.mode === 'numbers';
        const name = x.label ? (num ? UI.phone(x.label) : x.label) : T('Sem nome');
        const nameEl = r.querySelector('b'); if (nameEl.textContent !== name) nameEl.textContent = name;
        const av = r.querySelector('.rdo-av'), ini = num ? '#' : UI.initials(x.label || '?');
        if (av.textContent !== ini) { av.textContent = ini; av.setAttribute('style', UI.avatarStyle(x.tag)); }
        const talking = me ? S.tx : S.talk.has(x.tag), open = me ? isOpen() && S.tx : S.openMic.has(x.tag);
        const st = me ? (S.tx ? (isOpen() ? T('Tu · microfone aberto') : T('Tu · a transmitir')) : T('Tu')) : talking ? (open ? T('Microfone aberto') : T('A falar')) : T('Em escuta');
        const sp = r.querySelector('span'); if (sp.textContent !== st) sp.textContent = st;
        r.classList.toggle('talk', !!talking); r.classList.toggle('me', !!me); r.classList.toggle('open', !!(talking && open));
      });
    }
    /* o estado, o mostrador e a linha de quem fala custam umas comparações de texto: pintam sempre; o resto só quando muda */
    v.paint = what => {
      if (!v.isConnected && what !== 'force') { views.delete(v); return; }
      const all = what === 'all' || what === 'force';
      paintRoot(); paintDial(); paintPtt();
      if (all || what === 'presets' || what === 'dial') paintPresets();
      if (all || what === 'members' || what === 'talk' || what === 'ptt') paintMembers();
      if (all) paintVol();
    };
    views.add(v);
    v.paint('force');
    return v;
  }

  App.define('radio', {
    name: 'Rádio', category: 'Comunicação',
    description: 'Fala com quem está na mesma frequência, como num walkie-talkie. Favoritos, canais privados e tecla para falar com o telemóvel guardado.',
    keepAwake: () => S.tx && S.mode !== 'open',   /* o microfone aberto dura a sessão toda: o ecrã apaga-se como sempre */
    open(win) {
      const v = build(win);
      win._rdo = v;
      UI.setRoot(win, v);
      load(true);
      win.onClose = () => { try { v._release && v._release(); } catch (e) {} views.delete(v); };
    },
    resume(win) { if (win._rdo) { win._rdo.paint('all'); load(true); } },
  });

  /* ---------- pushes ---------- */
  Bridge.on('radio:joined', d => {
    if (!d || typeof d !== 'object') return;
    const was = S.joined && S.joined.key;
    applyJoined(d, d.members || null);
    if (was !== d.key) { sfx('join'); }
    activity(); repaint('all');
  });
  Bridge.on('radio:left', d => {
    if (!S.joined) return;
    applyJoined(null); S.tx = false; S.pending = false; S.latched = false; S.muted = false;
    try { System.indicator('mic', false); } catch (e) {}
    activity(); repaint('all'); sfx('leave');
    const r = d && d.reason; if (r && LEFT[r]) tell(T(LEFT[r]));
  });
  Bridge.on('radio:members', d => { if (!d || !S.joined || d.key !== S.joined.key) return; applyMembers(d); activity(); repaint('members'); });
  Bridge.on('radio:talk', d => {
    if (!d || !S.joined || d.key !== S.joined.key || d.tag === S.joined.tag) return;
    const had = S.talk.has(d.tag), wasOpen = S.openMic.has(d.tag);
    if (d.on) S.talk.set(d.tag, d.label || labelOfTag(d.tag)); else S.talk.delete(d.tag);
    if (d.on && d.open) S.openMic.add(d.tag); else S.openMic.delete(d.tag);
    /* squelch só para quem fala de facto (um microfone aberto a abrir ou fechar não faz barulho) */
    if (!!d.on !== had && !S.tx && !d.open && !wasOpen) sfx(d.on ? 'rxOn' : 'rxOff');
    activity(); repaint('talk');
  });
  Bridge.on('radio:event', d => {
    if (!d || !S.joined || d.key !== S.joined.key || !S.cfg) return;
    if (!views.size || System.currentApp() !== 'radio') return;
    const n = d.label ? (S.cfg.mode === 'numbers' ? UI.phone(d.label) : d.label) : null;
    tell(d.kind === 'join' ? (n ? TF('%s entrou na frequência', n) : T('Alguém entrou na frequência')) : (n ? TF('%s saiu da frequência', n) : T('Alguém saiu da frequência')));
  });
  Bridge.on('radio:tx', d => {
    const on = !!(d && d.on);
    if (on === S.tx) return;
    S.tx = on; S.pending = false;
    try { System.indicator('mic', on); } catch (e) {}
    sfx(on ? 'txOn' : 'txOff'); activity(); repaint('ptt');
  });
  Bridge.on('radio:txfail', () => { S.pending = false; repaint('ptt'); tell(T('O sistema de voz não deixou transmitir.')); });
  /* modo em vigor, microfone silenciado, transmissão presa (client/radio.lua) */
  Bridge.on('radio:mode', d => { if (applyMode(d)) { activity(); repaint('ptt'); } });
  Bridge.on('radio:blocked', d => tell(T(BLOCK[d && d.reason] || 'Não podes usar o rádio agora.')));
  /* largar o botão de falar quando o telemóvel é guardado (o ponteiro nunca chegaria a soltar) */
  Bridge.on('phone:close', () => views.forEach(v => { try { v._release && v._release(); } catch (e) {} }));
  Bridge.on('phone:open', () => { const go = () => { seed(); }; if (S.loaded) go(); else load().then(go); });
  Bridge.on('admin:settings', () => setTimeout(() => load(true), 400));
  Bridge.on('ready', () => setTimeout(() => load(true), 1500));
  Bridge.on('session:changed', () => { applyJoined(null); S.dial = null; S.prefs = { presets: [], vol: S.cfg.defVol, cs: null, last: null, mode: null }; S.muted = false; S.latched = false; activity(); setTimeout(() => load(true), 800); });
  Bridge.on('app:defined', id => { if (id === 'radio') syncApp(); });

  /* =====================================================================
     BROWSER (fora do jogo): servidor e cliente de mentira, para o harness e as capturas.
     ===================================================================== */
  const DEMO = [{ name: 'Rita Fonseca', num: '555-0118' }, { name: 'Tiago Matos', num: '555-0127' }, { name: 'Inês Rocha', num: '555-0163' }];
  const MS = { joined: null, prefs: { presets: [{ f: 104.5, n: 'Equipa' }, { f: 1.0, n: 'Emergência' }, { f: 245.2, n: null }], vol: 70, cs: null, last: 104.5 }, members: [], passes: {} };
  const MCFG = { min: 1, max: 999.9, step: .1, dec: 1, mode: 'names', private: true, callsign: true, maxPresets: 12, maxMembers: 32, earbuds: false, item: false, defFreq: 100, defVol: 60, keepOnClose: true, dead: true, vehicle: true, water: false, preinstalled: true, sounds: { on: true, vol: .6, tx: true, rx: true },
    talkMode: 'ptt', playerMode: false, modes: ['ptt', 'toggle', 'open'], maxTalk: 60 };
  const mMembers = () => ({ key: MS.joined.key, freq: MS.joined.label, mode: MCFG.mode, count: MS.members.length, list: MCFG.mode === 'count' || MCFG.mode === 'none' ? undefined : MS.members.map(x => ({ tag: x.tag, label: MCFG.mode === 'numbers' ? x.num : (x.cs || x.name), talk: x.talk || undefined, open: (x.talk && x.open) || undefined })) });
  /* cliente de mentira: modo de falar, transmissão presa e microfone silenciado (o que o client/radio.lua faz no jogo) */
  const MC = { muted: false, latched: false };
  const mMode = () => (MCFG.playerMode && MODES.includes(MS.prefs.mode) && MCFG.modes.includes(MS.prefs.mode)) ? MS.prefs.mode : (MODES.includes(MCFG.talkMode) ? MCFG.talkMode : 'ptt');
  const mState = () => ({ ok: true, mode: mMode(), muted: MC.muted, latched: MC.latched });
  const mEmit = () => setTimeout(() => Bridge.emit('radio:mode', mState()), 0);
  const mTx = on => setTimeout(() => Bridge.emit('radio:tx', { on: !!on && !!S.joined }), 40);
  const mOpenOnJoin = () => { if (mMode() === 'open' && !MC.muted) { MC.latched = true; setTimeout(() => { mEmit(); mTx(true); }, 60); } else mEmit(); };
  if (window.LocalDB && LocalDB.register) {
    LocalDB.register('radio.state', () => ({ enabled: true, supported: true, provider: 'pma-voice', cfg: MCFG, zones: [{ from: 1, to: 10, label: 'Emergência', allowed: false }],
      joined: MS.joined || false, members: MS.joined ? mMembers() : false, talkers: [], prefs: MS.prefs, earbuds: !!(System.state && System.state.airpodsWorn), hasItem: true }));
    LocalDB.register('radio.join', d => {
      const f = Math.round(+d.freq * 10) / 10;
      if (!(f >= MCFG.min && f <= MCFG.max)) return { error: 'range', min: MCFG.min, max: MCFG.max };
      if (f >= 1 && f <= 10) return { error: 'restricted', zone: 'Emergência' };
      const key = Math.round(f * 10), label = f.toFixed(1);
      const me = { tag: 1, name: ((System.player && ((System.player.firstname || '') + ' ' + (System.player.lastname || '')).trim()) || 'Eu'), num: (System.player && System.player.phone) || '555-0142', cs: MS.prefs.cs };
      MS.members = [me].concat(f === 104.5 ? DEMO.map((x, i) => Object.assign({ tag: i + 2 }, x)) : []);
      MS.members.sort((a, b) => a.tag - b.tag);
      MS.joined = { key, freq: f, label, tag: 1, locked: !!(d.pass && f !== 104.5), zone: false, count: MS.members.length };
      MS.prefs.last = f;
      const jp = Object.assign({}, MS.joined, { members: mMembers(), vol: MS.prefs.vol });
      setTimeout(() => { Bridge.emit('radio:joined', jp); mOpenOnJoin(); }, 0);
      return { ok: true, joined: MS.joined, members: mMembers() };
    });
    LocalDB.register('radio.leave', () => { const was = MS.joined; MS.joined = null; MS.members = []; MC.latched = false; MC.muted = false; if (was) setTimeout(() => Bridge.emit('radio:left', { reason: 'user', freq: was.label }), 0); return { ok: true }; });
    LocalDB.register('radio.prefs', d => { ['presets', 'vol', 'cs', 'last', 'mode'].forEach(k => { if (d[k] !== undefined) MS.prefs[k] = d[k]; }); if (MS.prefs.cs === '') MS.prefs.cs = null; return { ok: true, prefs: MS.prefs }; });
  }
  const MOCK = {
    radioJoin: d => (window.LocalDB ? LocalDB.rpc('radio.join', d) : { error: 'novoice' }),
    radioLeave: () => (window.LocalDB ? LocalDB.rpc('radio.leave', {}) : { ok: true }),
    radioPtt: d => {
      const m = mMode();
      if ((d.tap || d.on) && m !== 'ptt') {
        if (!S.joined) return mState();
        if (m === 'toggle') MC.latched = !MC.latched;
        else if (MC.latched) { MC.latched = false; MC.muted = true; } else { MC.latched = true; MC.muted = false; }
        mTx(MC.latched); mEmit(); return mState();
      }
      mTx(!!d.on); return Object.assign(mState(), { tx: S.tx });
    },
    radioMode: d => {
      if (!MCFG.playerMode || !MODES.includes(d.mode)) return Object.assign(mState(), { ok: false, error: 'invalid' });
      MS.prefs.mode = d.mode; MC.latched = false; MC.muted = false;
      if (S.joined) { if (mMode() === 'open') { MC.latched = true; mTx(true); } else mTx(false); }
      mEmit(); return mState();
    },
    radioVolume: () => ({ ok: true }),
    radioEnv: () => Object.assign({ key: 'Caps Lock', worn: !!(System.state && System.state.airpodsWorn), block: false, tx: S.tx, joined: S.joined ? S.joined.key : false }, mState()),
  };
  /* para o harness: o estado, um atalho para simular quem fala e a config dos modos de falar */
  window.RadioApp = { S, load, MCFG,
    demoTalk: (tag, on, open) => { const m = MS.members.find(x => x.tag === tag); if (m) { m.talk = !!on; m.open = !!open; } Bridge.emit('radio:talk', { key: S.joined && S.joined.key, tag, on, open: !!open || undefined, label: labelOfTag(tag) }); },
    setMode: (mode, player) => { MCFG.talkMode = mode; MCFG.playerMode = !!player; MC.latched = false; MC.muted = false; return load(true); } };
})();
