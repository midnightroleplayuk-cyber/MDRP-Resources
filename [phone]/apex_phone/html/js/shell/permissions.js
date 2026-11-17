/* ============================================================
   PERMISSÕES - pedido ao utilizador (Não permitir / Permitir uma vez /
   Permitir), por app e por tipo; gerido em Definições > Privacidade
   ============================================================ */
window.Perm = (() => {
  /* sms e bank: pedidos das apps externas (thirdparty.js - messages.send e bank.info). Estando aqui passam pelo mesmo
     diálogo (com "Permitir uma vez") e aparecem em Definições › Privacidade para se poderem revogar */
  const KINDS = { camera: 'Câmara', mic: 'Microfone', photos: 'Fotos', location: 'Localização', contacts: 'Contactos', notifications: 'Notificações', sms: 'Mensagens', bank: 'Banco' };
  const ICON = { camera: 'camera', mic: 'mic', photos: 'photo', location: 'nav', contacts: 'personCircle', notifications: 'bell', sms: 'message', bank: 'card' };
  const perms = () => System.state.perms || {};
  function get(app, kind) { const p = perms()[app]; return p ? p[kind] : undefined; }
  function set(app, kind, v) { const p = Object.assign({}, perms()); p[app] = Object.assign({}, p[app] || {}, { [kind]: v }); System.setState({ perms: p }, { noApply: true }); forget(app, kind); }
  /* "Permitir uma vez": SÓ EM MEMÓRIA (nunca vai para o state nem para o servidor) e só enquanto a app
     estiver viva - matar a app (alternador, LRU das 7 janelas), trocar de personagem ou recarregar a
     página e a próxima utilização volta a perguntar. A escolha persistida continua `undefined`. */
  const once = new Set();
  const onceKey = (app, kind) => app + '\u0001' + kind;   /* separador escrito como escape: nenhum id de app o tem (era um carácter de controlo invisível no código) */
  const isOnce = (app, kind) => once.has(onceKey(app, kind));
  function forget(app, kind) { if (kind) once.delete(onceKey(app, kind)); else [...once].forEach(k => { if (k.split('\u0001')[0] === app) once.delete(k); }); }
  Bridge.on('app:kill', id => forget(id));
  Bridge.on('session:changed', () => once.clear()); Bridge.on('factory:reset', () => once.clear());
  /* Relatório de privacidade REAL: cada pedido/uso que passa por aqui fica registado (últimos 7 dias,
     no máx. 300 entradas, no Store da personagem) - antes o relatório era um texto fixo inventado */
  const LOG_DAYS = 7;
  function log(app, kind, result) { try { const cut = Date.now() - LOG_DAYS * 864e5; const l = (Store.get('permLog', []) || []).filter(x => x && x.t > cut); l.push({ app, kind, result, t: Date.now() }); while (l.length > 300) l.shift(); Store.set('permLog', l); } catch (e) {} }
  const report = () => { const cut = Date.now() - LOG_DAYS * 864e5; return (Store.get('permLog', []) || []).filter(x => x && x.t > cut); };
  /* ---------- Nova UI (Android, 2026-10-01): o pedido com o aspeto da Nova UI ----------
     Câmara, microfone e localização: "Durante a utilização da app" / "Apenas desta vez" / "Não permitir" (como no
     Android). O resto: "Permitir" / "Apenas desta vez" / "Não permitir". Tocar fora do diálogo = cancelar (não grava). */
  const isA = () => !!(window.System && System.os === 'android');
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf ? L.tf(s, ...v) : v.reduce((a, x) => a.replace('%s', x), s));
  const ASK_A = { camera: 'tire fotos e grave vídeos', mic: 'grave áudio', photos: 'aceda a fotos e vídeos neste dispositivo', location: 'aceda à localização deste dispositivo', contacts: 'aceda aos teus contactos', notifications: 'te envie notificações', sms: 'envie e veja mensagens', bank: 'veja o teu saldo e os teus movimentos' };
  const WHILE_USING = ['camera', 'mic', 'location'];
  const GLYPH_A = {
    camera: '<path d="M4 8.6a2 2 0 0 1 2-2h1.8l1.5-2h5.4l1.5 2H18a2 2 0 0 1 2 2v8.8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z"/><circle cx="12" cy="12.8" r="3.4"/>',
    mic: '<rect x="9" y="3.6" width="6" height="10.6" rx="3"/><path d="M5.8 11.4a6.2 6.2 0 0 0 12.4 0M12 17.6v3"/>',
    photos: '<rect x="3.8" y="4.6" width="16.4" height="14.8" rx="3"/><circle cx="9" cy="9.8" r="1.7"/><path d="m4.6 17.4 4.6-4.4 3.2 3 2.6-2.4 4.6 4.2"/>',
    location: '<path d="M12 21s6.4-5.6 6.4-11a6.4 6.4 0 0 0-12.8 0c0 5.4 6.4 11 6.4 11z"/><circle cx="12" cy="10" r="2.3"/>',
    contacts: '<circle cx="12" cy="8.6" r="3.6"/><path d="M5 19.4a7 7 0 0 1 14 0"/>',
    notifications: '<path d="M6.4 16.6V11a5.6 5.6 0 0 1 11.2 0v5.6l1.6 1.8H4.8z"/><path d="M10 20.6a2.2 2.2 0 0 0 4 0"/>',
    sms: '<path d="M4.4 6.6a2 2 0 0 1 2-2h11.2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H10l-4.2 3.4v-3.4h.6a2 2 0 0 1-2-2z"/>',
    bank: '<path d="M4 9.6 12 5l8 4.6M5.6 10.4v6.8M10 10.4v6.8M14 10.4v6.8M18.4 10.4v6.8M4 19.4h16"/>',
  };
  function askA(app, k) {
    const gl = GLYPH_A[k] || '<rect x="5" y="11" width="14" height="10" rx="2.5"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/>';
    const what = ASK_A[k] ? T(ASK_A[k]) : TF('aceda a: %s', KINDS[k] || k);
    /* a pergunta leva o nome da app a negrito: o título vai no `head` (o alert escapa o title) */
    const head = `<div class="aperm-app"><div class="tile">${Icons.tile(app)}</div><span class="aperm-k"><svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">${gl}</svg></span></div>`
      + `<div class="aperm-q">${UI.esc(T('Permitir que'))} <b>${UI.esc(App.name(app))}</b> ${UI.esc(what)}?</div>`;
    const first = WHILE_USING.includes(k) ? T('Durante a utilização da app') : T('Permitir');
    const p = UI.alert({ cls: 'aperm-ov', head, title: '', buttons: [{ label: first, value: true }, { label: T('Apenas desta vez'), value: 'once' }, { label: T('Não permitir'), value: 'deny' }] });
    const ov = [...UI.screen().querySelectorAll('.overlay.aperm-ov')].pop();
    if (ov) { ov.addEventListener('click', e => { if (e.target === ov) UI.dismissTop(); }); ov.classList.toggle('aperm-nonav', !navOn()); }
    return p;
  }
  /* a barra de 3 botões está à vista? (o SysUI esconde-a no ecrã bloqueado): sem ela o diálogo assenta mais em baixo */
  const navOn = () => { if (window.SysUI && typeof SysUI.navVisible === 'function') return !!SysUI.navVisible();
    const nb = UI.screen().querySelector('.anb'); return nb ? (nb.classList.contains('anb-on') || nb.classList.contains('on')) : document.body.dataset.nav !== 'gesture'; };
  /* ---------- 1.1.7: abrir uma app com permissões recusadas ----------
     `needs` de uma app (Instashot: fotos + câmara; Tweeter, Match, Marketplace: fotos; Mapas, Eats, Serviços, Meteorologia:
     localização; Recado: contactos) era pedido ao ABRIR, e uma recusa ("Não permitir") ficava gravada na conta e passava a
     IMPEDIR a app de abrir para sempre: tocar no ícone não fazia nada a não ser um toast de 2 s em baixo. Dois servidores
     relataram "tudo funciona menos as redes sociais / não dá para usar as redes" - era exatamente isto (as redes sociais
     são as apps que pedem duas permissões logo ao abrir). No PearOS a sério recusar o acesso às fotos não impede a app de
     abrir: só o seletor de fotos é que não serve. Agora `request(app, kinds, { soft: true })` (o openApp usa-o): uma
     permissão recusada (gravada ou acabada de recusar) NÃO bloqueia - avisa uma vez por app e sessão e segue; só cancelar o
     diálogo (tocar fora, guardar o telemóvel) é que devolve false. As funcionalidades continuam a pedir em modo normal
     quando são usadas (câmara dos stories/DM, microfone, localização de um pedido). */
  const toasted = new Set();
  Bridge.on('session:changed', () => toasted.clear());
  function deniedToast(app, k, soft) {
    if (soft) { const key = onceKey(app, k); if (toasted.has(key)) return; toasted.add(key); }
    UI.toast(`Sem acesso a ${KINDS[k] || k}. Ativa em Definições > Privacidade.`);
  }
  async function request(app, kinds, opts) {
    kinds = Array.isArray(kinds) ? kinds : [kinds];
    const soft = !!(opts && opts.soft);
    for (const k of kinds) {
      /* Serviços de localização desligados nas Definições → nenhuma app a recebe, nem a que já tinha acesso */
      if (k === 'location' && System.state.locationOn === false) {
        log(app, k, 'off');
        if (isA()) await UI.alert({ cls: 'aperm-ov aperm-info', title: T('Localização desativada'), msg: TF('Para %s usar a tua posição, ativa a Localização nas Definições.', App.name(app)), buttons: [{ label: T('OK'), bold: true, value: true }] });
        else await UI.alert({ title: 'Serviços de localização desativados', msg: `Para "${App.name(app)}" usar a tua posição, ativa-os em Definições › Privacidade e segurança › Localização.`, buttons: [{ label: 'OK', bold: true, value: true }] });
        if (soft) continue;   /* a app abre na mesma (sem posição) */
        return false;
      }
      if (isOnce(app, k)) { log(app, k, 'once'); continue; }
      let v = get(app, k);
      if (v === undefined && isA()) {
        /* Nova UI: diálogo em baixo, ícone da app com o símbolo do que pede, a pergunta com o nome da app a negrito e
           as opções em lista. Mesmas respostas e o mesmo registo do PearOS (true / 'once' / 'deny'). */
        const r = await askA(app, k);
        if (r.value === 'once') { once.add(onceKey(app, k)); log(app, k, 'once'); continue; }
        if (r.value !== true && r.value !== 'deny') return false;   /* Voltar, tocar fora ou guardar o telemóvel: não grava nada */
        v = r.value === true; set(app, k, v);
      }
      if (v === undefined) {
        /* pedido ao estilo iOS 26: ícone da app com o símbolo do que pede, título, porquê e botões em cápsula (Permitir a azul) */
        const GL = { camera: 'camera', mic: 'mic', photos: 'photo', location: 'location', contacts: 'person', notifications: 'bell', sms: 'message', bank: 'bank' };
        const head = `<div class="perm-ic"><div class="tile perm-tile">${Icons.tile(app)}</div><span class="perm-badge k-${UI.esc(k)}">${UI.g(GL[k] || 'lock', 15)}</span></div>`;
        const r = await UI.alert({ cls: 'perm-ov', head, title: `Permitir que "${App.name(app)}" aceda ${({ camera: 'à câmara', mic: 'ao microfone', photos: 'às tuas fotos', location: 'à tua localização', contacts: 'aos teus contactos', notifications: 'às notificações', sms: 'às mensagens', bank: 'ao teu banco' })[k] || 'a: ' + (KINDS[k] || k)}?`, msg: ({ camera: 'Para tirar fotos e vídeos dentro da app.', mic: 'Para chamadas e gravações de áudio.', photos: 'Para escolher e partilhar fotos da tua galeria.', location: 'Para mostrar a tua posição e sítios próximos.', contacts: 'Para encontrar amigos e sugerir contactos.', notifications: 'Para te avisar de novidades.', sms: 'Para enviar mensagens em teu nome.', bank: 'Para ver o teu saldo e movimentos.' })[k] || '',
          buttons: [{ label: 'Permitir', bold: true, value: true }, { label: 'Permitir uma vez', value: 'once' }, { label: 'Não permitir', value: 'deny' }] });
        if (r.value === 'once') { once.add(onceKey(app, k)); log(app, k, 'once'); continue; }
        /* guardar o telemóvel com a pergunta aberta (UI.dismissAll → value false) NÃO é "Não permitir":
           não se grava nada e a app volta a perguntar da próxima vez */
        if (r.value !== true && r.value !== 'deny') return false;
        v = r.value === true; set(app, k, v);
      }
      log(app, k, v ? 'allow' : 'deny');
      if (!v) { deniedToast(app, k, soft); if (soft) continue; return false; }
    }
    return true;
  }
  function apps(kind) { const p = perms(); const out = Object.keys(p).filter(a => p[a][kind] !== undefined).map(a => ({ app: a, allowed: !!p[a][kind], once: false }));
    once.forEach(key => { const [a, k] = key.split('\u0001'); if (k === kind && !out.some(x => x.app === a)) out.push({ app: a, allowed: false, once: true }); });
    return out; }
  return { init() {}, KINDS, ICON, get, set, request, apps, isOnce, forget, report };
})();

/* ============================================================
   EARBUDS - cartão dos auriculares (item usável / CC / Definições)
   ============================================================ */
/* Um cartão só para os dois pares (AirBuds e Slate Buds) e para todos os telemóveis; o aspeto é do css/earbuds.css:
   · PearOS: o cartão dos auriculares do sistema (nome ao centro, X, o par em grande, botão azul). Sólido no PearPhone 18;
     no PearPhone Fold é de vidro e vive na zona de conteúdo, à esquerda da barra.
   · Nova UI: o pop-up dos auriculares (vidro claro com manchas de cor, nome à esquerda, botões de texto "Fechar | Ligar"),
     por cima da barra de navegação.
   Fluxo no MESMO cartão (constrói-se uma vez; só muda data-st e os textos): por ligar ("Ligar") → a ligar → ligados (a
   bateria do esquerdo, do direito e da caixa em anéis, e "Concluído"). Ligar ou desligar pelas Definições ou pelo Centro de
   controlo não abre o cartão: dá só o aviso (o HUD da ilha no PearPhone, a pílula de aviso no resto). */
window.Earbuds = (() => {
  let card = null, hideT = null, busy = false;
  /* O nome vem do servidor (Config.AirPods.name ou Config.SlateBuds.name) no earbuds.state.
     Dois estados: POSTOS (`worn` - o item do inventário põe/tira o par 3D na cabeça; só de sessão, nunca gravado) e
     LIGADOS (`connected` - Bluetooth do telemóvel; só com eles postos). state.airpodsWorn é espelho de sessão. */
  let NAME = 'AirPods Pro 3';
  /* qual par está posto (2026-10-01): 'airbuds' ou 'slate' (os NOVA Buds 4 Pro), vem do servidor com o nome */
  let KIND = 'airbuds';
  /* bateria do par (esquerdo, direito, caixa): vem do servidor com o estado; um valor em falta mantém o anterior */
  let BAT = { l: 84, r: 79, c: 62 };
  const ART = { airbuds: '../inventory_images/airpods_case.png', slate: 'img/slate_buds.png' };
  const worn = () => !!System.state.airpodsWorn;
  const isA = () => !!(window.System && System.os === 'android');
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf ? L.tf(s, ...v) : v.reduce((a, x) => a.replace('%s', x), s));
  const pct = v => Math.max(0, Math.min(100, Math.round(+v || 0)));
  const bv = (v, d) => (v == null || v === '' || !isFinite(+v)) ? d : pct(v);
  function absorb(r) { if (!r || typeof r !== 'object') return; if (r.name) NAME = String(r.name).slice(0, 32); if (r.kind) KIND = r.kind === 'slate' ? 'slate' : 'airbuds';
    if (r.battery && typeof r.battery === 'object') BAT = { l: bv(r.battery.l, BAT.l), r: bv(r.battery.r, BAT.r), c: bv(r.battery.c, BAT.c) };
    const p = {}; if (!!System.state.airpodsWorn !== !!r.worn) p.airpodsWorn = !!r.worn; if (!!System.state.earbuds !== !!r.connected) p.earbuds = !!r.connected; if (Object.keys(p).length) System.setState(p, { noApply: true }); }
  /* ---------- Ressincronizar com o servidor (NOVO-INTEG-A) ----------
     `state.earbuds` é gravado na conta, mas no servidor o estado é só da SESSÃO (Earbuds[src] morre no
     playerDropped). Sem isto, ao voltar a entrar o Centro de controlo e as Definições › Bluetooth diziam
     "Ligado" com o servidor a `false`: o primeiro toque em "Desligar" chamava earbuds.toggle, o servidor
     passava de false para true e os earbuds LIGAVAM-SE - era preciso tocar duas vezes para desligar.
     O RPC 'earbuds.state' já existia no servidor (e no mock do localdb.js) e ninguém o chamava. */
  async function sync() {
    let r = null; try { r = await Bridge.rpc('earbuds.state'); } catch (e) { r = null; }
    if (!r || typeof r !== 'object') return;                        /* sem resposta não se inventa estado */
    absorb(r);   /* o setState emite 'state': o CC aberto repinta-se sozinho */
  }
  /* o push 'earbuds' vem do item (pôr/tirar) - ao TIRAR não há cartão, só o estado (e a Música pausa sozinha) */
  function init() {
    Bridge.on('earbuds', d => { d = d || {}; absorb(d); if (d.worn) show(d); else { hide(); if (d.worn === false) note('off'); } });
    sync(); Bridge.on('session:changed', sync);
    /* abrir ou fechar o dobrável com o cartão à vista: o cartão muda de sítio e o vidro volta a medir onde está */
    Bridge.on('fold:state', () => setTimeout(place, 60)); Bridge.on('form:changed', () => setTimeout(place, 60));
  }
  /* aviso curto do par: no PearPhone com ilha é o HUD da ilha (glifo dos auriculares e o estado); no resto (Nova UI e
     PearPhone Fold, sem ilha) a pílula de aviso do sistema, com o nome do par */
  function note(k) {
    const short = { on: 'Ligados', disc: 'Desligados', off: 'Guardados' }[k], full = { on: '%s ligados', disc: '%s desligados', off: '%s guardados' }[k];
    if (!short) return;
    if (!isA() && window.Island && Island.hud && Island.hud({ icon: UI.g('earbuds', 22), text: T(short), cls: 'eb-hud eb-hud-' + k, ms: 2200 })) return;
    UI.toast(TF(full, NAME));
  }
  const notWornToast = () => UI.toast(TF('Coloca os %s primeiro (usa o item no inventário)', NAME));
  /* LEAD (5 out): "alguns jogadores nao conseguem ligar". O Bridge.rpc troca QUALQUER {error} por null e o cartao dizia
     sempre "Nao foi possivel ligar", mesmo quando o servidor explicava porque (notworn) ou so tinha recusado por limite
     de pedidos (ao abrir, o telemovel faz uma rajada de pedidos e o "Ligar" chegava com o balde vazio). Agora: o pedido
     guarda o erro, o limite de pedidos e repetido sozinho ate 2 vezes, e o codigo vai para a consola F8. */
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  async function budsRpc(name) {
    let r = null;
    for (let i = 0; i < 3; i++) {
      try { r = await Bridge.rpcRaw(name); } catch (e) { r = null; }
      if (!(r && typeof r === 'object' && (r.error === 'ratelimit' || r.error === 'db'))) break;
      await sleep(700 + i * 500);
    }
    if (!r || (typeof r === 'object' && r.error && r.error !== 'notworn')) console.error('[apex_phone] ' + name + ': ' + (r && typeof r === 'object' ? r.error : 'sem resposta'));
    return r && typeof r === 'object' ? r : null;
  }
  const BUDS_ERR = { ratelimit: 'Demasiados pedidos, espera um instante', timeout: 'O servidor não respondeu.', internal: 'Erro no servidor.', foreign: 'Não podes usar este telemóvel.', locked: 'Desbloqueia o telemóvel primeiro.' };
  const budsFail = r => UI.toast(T((r && BUDS_ERR[r.error]) || 'Não foi possível ligar. Tenta outra vez.'));
  async function toggle() {
    if (!worn()) { notWornToast(); return; }
    /* o interruptor do Bluetooth tem de valer alguma coisa: sem Bluetooth não há auriculares */
    if (!System.state.bt) { UI.toast(TF('Liga o Bluetooth para usar os %s', NAME)); return; }
    const r = await budsRpc('earbuds.toggle');
    if (r && r.error === 'notworn') { absorb(r); hide(); notWornToast(); return; }
    if (!r || r.error) { budsFail(r); return; }                     /* sem resposta não se inventa estado */
    absorb(r);
    /* o cartão aberto acompanha (ligados: anéis e "Concluído"; desligados: sai) */
    if (card && card.dataset.st !== 'busy') { if (r.connected) { paint(card, 'on'); armHide(6000); } else hide(); }
    note(r.connected ? 'on' : 'disc'); Sound.play(r.connected ? 'connect' : 'pop');
  }
  /* ---------- desligar o Bluetooth desliga-os no servidor ----------
     O servidor só tem `toggle` (server/main.lua: earbuds.state / earbuds.toggle; não há `set`). Chamá-lo às
     cegas ASSUMIA que ele os ia desligar: com o estado da sessão do servidor (Earbuds[src], que morre no
     playerDropped) dessincronizado do que está gravado na conta, desligar o Bluetooth LIGAVA-OS e a conta
     ficava com `earbuds:true, bt:false`. Pergunta-se primeiro o que o servidor acha e só se alterna o que
     está mesmo ligado. Ver `pedidosCruzados`: com um `earbuds.set` no servidor isto era uma chamada só. */
  async function disconnect() {
    if (!System.state.earbuds) return;
    let s = null; try { s = await Bridge.rpc('earbuds.state'); } catch (e) { s = null; }
    /* já desligados no servidor: não se alterna nada (era isto que os ligava) - só se acerta a conta */
    if (s && typeof s === 'object' && !s.connected) { System.setState({ earbuds: false }, { noApply: true }); hide(); return; }
    let r = null; try { r = await Bridge.rpc('earbuds.toggle'); } catch (e) { r = null; }
    /* ligados DEPOIS do toggle (o `earbuds.state` não respondeu e o servidor estava ao contrário): corrige-se
       UMA vez, nunca em ciclo */
    if (r && r.connected) { let r2 = null; try { r2 = await Bridge.rpc('earbuds.toggle'); } catch (e) { r2 = null; } if (r2 && typeof r2 === 'object') r = r2; }
    /* sem resposta nenhuma não se inventa estado (o `sync()` da próxima abertura acerta os dois lados) */
    if (r && typeof r === 'object') System.setState({ earbuds: !!r.connected }, { noApply: true });
    hide();
  }

  /* ---------- desenho ---------- */
  const SV = p => `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${p}</svg>`;
  const GL = {
    bud: '<circle cx="10.4" cy="8" r="3.7"/><path d="M12.6 11v7.3a1.5 1.5 0 0 1-3 0v-6.6"/>',
    case: '<rect x="4" y="7.2" width="16" height="11" rx="4.2"/><path d="M4 11.4h16"/>',
    x: '<path d="M7 7l10 10M17 7 7 17"/>'
  };
  const art = () => `<div class="eb2-art"><img src="${ART[KIND]}" alt=""></div>`;
  /* bateria em anéis (verde; vermelho com 20 % ou menos): r = 20 numa caixa de 48, o arco é o stroke-dashoffset */
  const RC = 2 * Math.PI * 20;
  const ring = (k, lbl, gl) => `<div class="eb2-bi" data-k="${k}"><span class="eb2-ring"><svg viewBox="0 0 48 48"><circle class="tr" cx="24" cy="24" r="20"/><circle class="fg" cx="24" cy="24" r="20" stroke-dasharray="${RC.toFixed(2)}" stroke-dashoffset="${RC.toFixed(2)}"/></svg>${SV(gl)}</span><b></b><em>${UI.esc(lbl)}</em></div>`;
  const bats = () => `<div class="eb2-bat">${ring('l', T('Esquerdo'), GL.bud)}${ring('r', T('Direito'), GL.bud)}${ring('c', T('Caixa'), GL.case)}</div>`;
  /* só troca os números, os arcos e a cor (o HTML fica) */
  function paintBat(root) {
    if (!root) return;
    root.querySelectorAll('.eb2-bi').forEach(n => { const v = pct(BAT[n.dataset.k]); const fg = n.querySelector('.fg'); if (fg) fg.setAttribute('stroke-dashoffset', (RC * (1 - v / 100)).toFixed(2));
      const b = n.querySelector('b'); if (b) b.textContent = v + '%'; n.classList.toggle('low', v <= 20); });
  }
  /* a barra de 3 botões está à vista? (o SysUI esconde-a no ecrã bloqueado): sem ela o cartão da Nova UI assenta mais em baixo */
  const navOn = () => { if (window.SysUI && typeof SysUI.navVisible === 'function') return !!SysUI.navVisible();
    const nb = UI.screen().querySelector('.anb'); return nb ? (nb.classList.contains('anb-on') || nb.classList.contains('on')) : document.body.dataset.nav !== 'gesture'; };
  function build() {
    const a = isA();
    /* Nova UI: leva também a classe antiga .abud-card, que o Voltar da barra de navegação procura (android-sysui.js) */
    const c = UI.el(`<div class="eb2 ${a ? 'eb2-a abud-card' : 'eb2-i'}" role="dialog"><div class="eb2-c">`
      + `<div class="eb2-hd"><b class="eb2-t"></b>${a ? '' : `<div class="eb2-x" role="button" aria-label="${UI.esc(T('Fechar'))}">${SV(GL.x)}</div>`}</div>`
      + art() + `<div class="eb2-mid"><div class="eb2-msg"></div>${bats()}</div>`
      + `<div class="eb2-act">${a ? '<div class="eb2-b eb2-no" role="button"></div><i class="eb2-sep"></i>' : ''}<div class="eb2-b eb2-go" role="button"></div></div></div></div>`);
    c.querySelector('.eb2-t').textContent = NAME;
    const x = c.querySelector('.eb2-x'); if (x) x.onclick = e => { e.stopPropagation(); Sound.play('click'); hide(); };
    c.querySelector('.eb2-go').onclick = () => { if (c.dataset.st === 'on') { Sound.play('click'); hide(); } else if (c.dataset.st === 'off') connect(c); };
    const no = c.querySelector('.eb2-no'); if (no) no.onclick = () => { Sound.play('click'); const go = c.dataset.st === 'on'; hide(); if (go) openSettings(); };
    if (a) c.classList.toggle('abud-nonav', !navOn());
    return c;
  }
  /* estado do cartão: 'off' por ligar · 'busy' a ligar · 'on' ligados (textos e data-st; o CSS troca a frase pelos anéis) */
  function paint(c, st) {
    c.dataset.st = st;
    c.querySelector('.eb2-msg').textContent = T('Liga por Bluetooth para ouvires a Música só tu, mesmo com o telemóvel fechado.');
    /* 'Ligar' / 'A ligar…' sozinhos sao os das chamadas ("Call" / "Calling…"): aqui e emparelhar os auriculares */
    c.querySelector('.eb2-go').textContent = st === 'on' ? T('Concluído') : st === 'busy' ? T('A emparelhar…') : T('Emparelhar');
    const no = c.querySelector('.eb2-no'); if (no) no.textContent = st === 'on' ? T('Definições') : T('Fechar');
    paintBat(c);
  }
  /* "Ligar": o mesmo RPC do item; o cartão fica e passa a "ligados" com a bateria */
  async function connect(c) {
    if (busy) return; busy = true; clearTimeout(hideT);
    if (!System.state.bt) System.setState({ bt: true }, { noApply: true });   /* como no PearPhone: ligar os auriculares liga o Bluetooth */
    paint(c, 'busy');
    let r = await budsRpc('earbuds.toggle');
    /* o servidor já os tinha ligados (sessão trocada): o toggle desligou-os; volta-se a ligar UMA vez, nunca em ciclo */
    if (r && !r.error && !r.connected) { const r2 = await budsRpc('earbuds.toggle'); if (r2) r = r2; }
    busy = false;
    if (r && !r.error) absorb(r);
    if (r && r.error === 'notworn') { absorb(r); hide(); notWornToast(); return; }
    if (card !== c) { if (r && r.connected) note('on'); return; }   /* fechado enquanto ligava: fica só o aviso */
    if (!r || r.error || !r.connected) { paint(c, 'off'); armHide(10000); budsFail(r); return; }
    paint(c, 'on'); Sound.play('connect'); armHide(6000);
  }
  /* vidro sem backdrop-filter: o cartão pinta dentro dele a cópia desfocada do fundo no sítio onde está (--gx/--gy). A posição
     é a FINAL (offsetLeft/offsetTop não contam o deslize de entrada) */
  function place() { const c = card; if (!c || !c.isConnected) return; c.style.setProperty('--gx', c.offsetLeft + 'px'); c.style.setProperty('--gy', c.offsetTop + 'px'); }
  function armHide(ms) { clearTimeout(hideT); hideT = setTimeout(hide, ms); }
  function show(d) {
    /* o item do inventário liga-os pelo lado do jogo (client/main.lua UseEarbuds → earbuds.toggle → push),
       sem passar por este Earbuds.toggle: o Bluetooth podia estar desligado e ficava um estado a dizer
       "earbuds ligados, Bluetooth desligado". Como no PearPhone, ligá-los liga o Bluetooth - assim o
       interruptor continua a valer (desligá-lo desliga-os) e nada afirma o contrário do que está gravado. */
    d = d || {}; absorb(d); const on = !!d.connected;
    if (on && !System.state.bt) System.setState({ bt: true }, { noApply: true });
    if (card) { const o = card; card = null; o.remove(); }
    busy = false;
    const c = build(); paint(c, on ? 'on' : 'off'); card = c;
    UI.screen().appendChild(c); place(); requestAnimationFrame(() => c.classList.add('in')); Sound.play('connect');
    /* por ligar fica mais tempo (há uma escolha a fazer); ligados some-se como o aviso do sistema */
    armHide(on ? 6000 : 10000);
  }
  function hide() { clearTimeout(hideT); if (!card) return; const c = card; card = null; c.classList.remove('in'); setTimeout(() => c.remove(), 500); }
  /* "Definições" do cartão ligado (Nova UI): a página do par nas Definições */
  function openSettings() { if (System.locked) return; try { System.openApp('settings'); } catch (e) { return; } setTimeout(() => Bridge.emit('settings:goto', 'buds'), 600); }
  /* cabeçalho da página do par nas Definições (os dois sistemas): o desenho, o nome, o estado e a bateria. Constrói-se uma vez;
     h._paint() acerta o estado e os anéis no sítio (a página chama-o quando o estado muda) */
  function hero() {
    const h = UI.el(`<div class="ebh">${art()}<b class="ebh-n"></b><span class="ebh-st"></span>${bats()}</div>`);
    h._paint = () => { const w = worn(), on = w && !!System.state.earbuds && !!System.state.bt;
      h.querySelector('.ebh-n').textContent = NAME;
      h.querySelector('.ebh-st').textContent = on ? T('Ligados') : w ? T('Não ligados') : T('Fora de alcance');
      h.classList.toggle('worn', w); h.classList.toggle('on', on); paintBat(h); };
    h._paint(); return h;
  }
  Bridge.on('os:changed', () => hide());
  return { init, toggle, disconnect, sync, show, hide, hero, worn, get NAME() { return NAME; }, get KIND() { return KIND; }, get BAT() { return Object.assign({}, BAT); } };
})();
