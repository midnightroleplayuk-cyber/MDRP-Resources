/* ============================================================
   DYNAMIC ISLAND - chamadas, música, temporizador, navegação,
   Live Activities, instalações, notificações e HUD; indicadores de
   câmara/microfone; tap abre app, long press expande
   ============================================================ */
/* API (contrato 5.4)
   - Island.set(mode, data) / Island.clear(mode?) - compatível com a versão de uma só atividade:
     set insere/atualiza a atividade desse modo; clear(mode) remove-a; clear() limpa tudo.
   - Island.activity(id, data) / update(id, data) / stop(id) - Live Activities:
     data = { app, title, subtitle, icon (id de app, nome de glifo ou URL), progress 0..1, eta, state, onTap? }
     eta: número em ms desde a época (> 1e12) ou segundos que faltam; texto é mostrado tal como vem (escapado).
   - Prioridades: call 3 · timer 2 · nav 2 · activity 2 · music 1 · dl 1. A de maior prioridade fica na pílula;
     a segunda aparece numa bolha à esquerda da pílula - à direita tapava os ícones da barra de estado (tap abre-a, long press passa-a para a pílula - nunca por cima de uma chamada).
   - Chamada recebida: set('call', { name, avatar, status, incoming: true, onAccept, onDecline }) → ilha expandida com atender/rejeitar.
   - Música: data.img = capa real (por CSSOM, nunca em HTML), com o gradiente data.c por baixo como recurso.
   - Island.list() devolve a ordem atual (diagnóstico / harness).
   FORMA (regra do CEF: só transform e opacity animam): a silhueta preta são 6 peças (2 retângulos + 4 círculos) que só
   mudam de transform. A caixa .island muda de tamanho SEM transição (serve para o toque e para dispor o conteúdo) e o
   conteúdo novo entra por opacity. Antes animava width/height/border-radius - layout e pintura a cada frame.
   ANDROID (Nova UI 8.5, body.os-android): a mesma API e a mesma lista de prioridades, outro desenho. Não há ilha (a
   .island é só a câmara furada): as duas atividades de cima viram CHIPS na barra de estado, à esquerda, depois da hora
   (chamada verde com a duração, temporizador, música com a capa, navegação, atividade, instalação com anel); tocar
   abre (openAct) e o toque longo mostra o CARTÃO expandido por baixo da barra com os mesmos controlos da ilha
   expandida. A chamada a tocar é um cartão flutuante no topo (Recusar / Atender). notif() devolve false (o Notify
   mostra o cartão dele), hud() e faceId() não desenham nada. Os chips constroem-se uma vez e o tick() só lhes troca
   o texto. Ver renderA() e a secção ANDROID mais abaixo. */
window.Island = (() => {
  const g = UI.g, esc = UI.esc;
  const PRIO = { call: 3, timer: 2, nav: 2, activity: 2, music: 1, dl: 1 };
  /* [largura, altura, raio] de cada estado - TEM de coincidir com a secção "Dynamic Island" do notify.css.
     Vem de uma tabela e não de medir a caixa: com o telemóvel guardado (body.hidden = display:none) as medidas
     vêm a zero e a ilha espreitada ficava sem forma. */
  const GEO = { idle: [125, 37, 18.5], active: [232, 38, 19], two: [190, 38, 19], expanded: [376, 150, 40], inc: [376, 96, 40], faceid: [150, 42, 21], hud: [224, 37, 18.5] };
  const BW = 400, BH = 160, BD = 80;   /* tamanho base das peças (notify.css): as escalas ficam ≤ 1, sem serrilhado ao ampliar */
  const EXPANDABLE = ['call', 'music', 'timer', 'nav', 'activity'];
  const MODES = ['active', 'expanded', 'call', 'music', 'timer', 'notif', 'hud', 'faceid', 'dl', 'nav', 'activity', 'two', 'isl-inc'];
  let el = null, live = null, big = null, bub = null, shape = null; const P6 = {};
  const acts = new Map();   /* chave → { key, mode, prio, seq, data } */
  let seq = 0, expanded = false, expKey = null, pin = null, overlay = null;   /* overlay = { mode: 'notif' | 'hud', data } */
  let lastKey = null, lastExp = false, lastGeo = null, bubT = null;
  let notifT = null, collapseT = null, hudT = null, dlT = null;

  const reduce = () => !!(window.System && System.state && System.state.reduceMotion);
  const safe = fn => { try { fn && fn(); } catch (e) { console.error('[apex_phone] island', e); } };
  /* SEM ILHA: o Android (câmara furada) e os DOBRÁVEIS dos dois sistemas (contrato v2: o PearPhone Fold só tem uma câmara
     redonda, fechado ou aberto). Nesse caso as atividades vão para CHIPS na barra de estado e cartões, como num tablet; o
     desenho dos chips e dos cartões é o mesmo (system.css dá-lhes o aspeto do PearOS no Fold). */
  const isA = () => !!(window.System && (System.os === 'android' || System.form === 'fold'));
  /* PearPhone Fold (PearOS, 2026-10-02): sem barra de estado em cima. As atividades são CÍRCULOS de vidro na barra direita,
     por baixo do anel de estado (Rail.actsBox, system.js): só o ícone (a capa, o telefone, o temporizador...), com um anel
     de progresso quando há; tocar abre, manter abre o cartão ao lado da barra. A lista, as prioridades e o cartão são os mesmos */
  const railOn = () => !!(window.Rail && Rail.active);

  function init() {
    el = document.querySelector('.island'); if (!el) return;
    el.innerHTML = '<div class="isl-shape"><i class="h"></i><i class="v"></i><i class="c tl"></i><i class="c tr"></i><i class="c bl"></i><i class="c br"></i></div><div class="cam"></div><div class="dot"></div><div class="live"></div><div class="big"></div><div class="isl-bub"></div>';
    shape = el.querySelector('.isl-shape'); live = el.querySelector('.live'); big = el.querySelector('.big'); bub = el.querySelector('.isl-bub');
    ['h', 'v', 'tl', 'tr', 'bl', 'br'].forEach(k => { P6[k] = shape.querySelector('.' + k); });
    /* acabada a animação tira-se a classe: com o telemóvel guardado (body.hidden = display:none) uma animação que ficasse
       aplicada voltava a correr a cada abertura - a ilha saltava e o conteúdo desvanecia sem nada ter mudado.
       Só o próprio nó (as barras da música e o glifo do Face Key também disparam animationend e sobem até aqui) e só a classe
       dessa animação: o restart() troca -a por -b e o animationcancel da -a chega depois - não pode levar a -b com ele. */
    const ANIM_CLS = { islBumpA: 'isl-bump-a', islBumpB: 'isl-bump-b', islInA: 'isl-in-a', islInB: 'isl-in-b' };
    [shape, live, big].forEach(n => ['animationend', 'animationcancel'].forEach(t => n.addEventListener(t, e => { if (e.target === n && ANIM_CLS[e.animationName]) n.classList.remove(ANIM_CLS[e.animationName]); })));
    /* o `bump` antigo escalava a .island inteira (e a lente com ela); agora só a forma salta - ver bump() */
    el.classList.remove('bump');
    shapeTo('idle', true);
    el.classList.add('isl-ready');   /* a partir daqui a forma são as peças: a caixa fica transparente (notify.css) */
    /* troca de personagem: as atividades (música, temporizador, Live Activities) eram da anterior */
    if (window.Bridge) Bridge.on('session:changed', () => clear());
    /* troca de sistema a quente (usar outro item com o telemóvel aberto): as atividades ficam, só muda o desenho. O mesmo com
       outro FORMATO (telemóvel normal ⇄ dobrável): a ilha dá lugar aos chips, ou volta */
    if (window.Bridge) { Bridge.on('os:changed', onOS); Bridge.on('form:changed', onOS); }
    el.onclick = e => {
      if (e.target.closest('.isl-bub')) { const s = second(); if (s) openAct(s); return; }
      if (e.target.closest('.ctl,.end,.ans,.big .pill-btn')) return;
      onTap();
    };
    UI.longPress(el, e => {
      /* long press na bolha: a segunda atividade passa para a pílula (fica "fixada" enquanto existir) */
      if (e && e.target && e.target.closest && e.target.closest('.isl-bub')) { const s = second(); if (s) { pin = s.key; expanded = false; render(); Sound.play('pop'); } return; }
      expand();
    });
    render();
  }

  /* ---------- lista de atividades ---------- */
  /* ordem: prioridade (a fixada vale 2,5 - ganha a timer/nav/activity mas nunca a uma chamada) e, no empate,
     a mais antiga primeiro - uma atualização não faz a pílula saltar */
  const order = () => [...acts.values()].sort((a, b) => ((b.key === pin ? 2.5 : b.prio) - (a.key === pin ? 2.5 : a.prio)) || (a.seq - b.seq));
  const main = () => order()[0] || null;
  const second = () => (!overlay && !expanded) ? (order()[1] || null) : null;
  const isIncoming = a => !!(a && a.mode === 'call' && a.data && a.data.incoming);

  function upsert(key, mode, data, replace) {
    const prev = acts.get(key);
    const a = prev || { key, mode, prio: PRIO[mode] || 1, seq: ++seq, data: {} };
    const wasIncoming = isIncoming(prev);
    a.data = replace ? (data || {}) : Object.assign(a.data || {}, data || {});
    acts.set(key, a);
    /* uma chamada tira logo do caminho a notificação que estiver a passar na ilha; a chamada a TOCAR tira também o HUD
       (o do botão de silêncio mantido chega a durar 60 s e escondia atender/rejeitar) */
    if (mode === 'call' && overlay && (overlay.mode === 'notif' || isIncoming(a))) { clearTimeout(notifT); clearTimeout(hudT); overlay = null; }
    if (wasIncoming && !isIncoming(a)) expanded = false;   /* atendida: volta à pílula (a expansão da chamada a tocar é tratada no render) */
    render();
    return a;
  }
  function set(m, d) {
    if (m === 'notif') return notif(d);
    if (m === 'hud') return hud(d);
    if (!m || m === 'idle') return clear();
    upsert(String(m), String(m), d || {}, true);
  }
  function clear(m) {
    if (!m) { acts.clear(); overlay = null; pin = null; expanded = false; clearTimeout(notifT); clearTimeout(hudT); clearTimeout(collapseT); render(); return; }
    if (m === 'notif' || m === 'hud') { if (overlay && overlay.mode === m) { overlay = null; render(); } return; }
    if (!acts.has(m)) return;
    acts.delete(m); if (pin === m) pin = null; render();
  }

  /* ---------- Live Activities ---------- */
  const str = (v, n) => String(v == null ? '' : v).slice(0, n);
  /* só campos conhecidos, com tipo e tamanho: os dados podem vir de outros resources (a Fase 6 liga os
     exports - client/exports.lua StartActivity e o 'activity' do thirdparty.js, que valida o que vem de fora).
     O `icon` NUNCA pode ser HTML: o paintIcon já só o usa como URL (CSSOM), id de app ou glifo, mas uma
     string a começar por '<' é recusada aqui para o contrato ficar escrito (o `ext` das notificações, esse,
     vem do notify.js já filtrado pelo safeSvg). */
  function actData(d, partial) {
    const o = {}; if (!d || typeof d !== 'object') return o;
    const has = k => !partial || Object.prototype.hasOwnProperty.call(d, k);
    if (has('app')) o.app = str(d.app, 32);
    if (has('title')) o.title = str(d.title, 60);
    if (has('subtitle')) o.subtitle = str(d.subtitle, 90);
    if (has('icon')) { const ic = typeof d.icon === 'string' ? d.icon.trim() : ''; o.icon = ic.startsWith('<') ? '' : ic.slice(0, 200000); }
    if (has('progress')) { const p = Number(d.progress); o.progress = (d.progress == null || d.progress === '' || !isFinite(p)) ? null : Math.max(0, Math.min(1, p)); }
    if (has('eta')) { const e = d.eta; o.eta = (typeof e === 'number' && isFinite(e)) ? (e > 1e12 ? e : Date.now() + Math.max(0, e) * 1000) : (e == null || e === '' ? null : str(e, 24)); }
    if (has('state')) o.state = str(d.state, 24);
    if (typeof d.onTap === 'function') o.onTap = d.onTap;
    return o;
  }
  const actKey = id => 'act:' + str(id, 64);
  function activity(id, data) { if (id == null || id === '') return null; upsert(actKey(id), 'activity', actData(data, false), true); return str(id, 64); }
  function update(id, data) { const k = actKey(id); if (!acts.has(k)) return false; upsert(k, 'activity', actData(data, true), false); return true; }
  function stop(id) { const k = actKey(id); if (!acts.has(k)) return false; clear(k); return true; }

  /* ---------- forma (só transform) ---------- */
  const f2 = v => (Math.round(v * 100) / 100);
  function shapeTo(name, instant) {
    if (!shape) return;
    const G = GEO[name] || GEO.idle, w = G[0], h = G[1], r = Math.min(G[2], h / 2, w / 2), k = +(2 * r / BD).toFixed(5);   /* 5 casas: com 2 os cantos ficavam 0,2 px mais pequenos que a pílula */
    const noAnim = instant || reduce();
    el.classList.toggle('noanim', noAnim);
    if (name === lastGeo && !instant) return;
    lastGeo = name;
    /* as 6 peças dependem linearmente de (w, h, r): a meio da transição a união é exatamente a silhueta intermédia */
    P6.h.style.transform = `translate(${f2(-w / 2)}px,${f2(r)}px) scale(${f2(w / BW * 1000) / 1000},${f2((h - 2 * r) / BH * 1000) / 1000})`;
    P6.v.style.transform = `translate(${f2(-w / 2 + r)}px,0px) scale(${f2((w - 2 * r) / BW * 1000) / 1000},${f2(h / BH * 1000) / 1000})`;
    P6.tl.style.transform = `translate(${f2(-w / 2)}px,0px) scale(${k})`;
    P6.tr.style.transform = `translate(${f2(w / 2 - 2 * r)}px,0px) scale(${k})`;
    P6.bl.style.transform = `translate(${f2(-w / 2)}px,${f2(h - 2 * r)}px) scale(${k})`;
    P6.br.style.transform = `translate(${f2(w / 2 - 2 * r)}px,${f2(h - 2 * r)}px) scale(${k})`;
    shape.style.transformOrigin = `0px ${f2(h / 2)}px`;   /* o salto (bump) escala a forma a partir do centro dela */
    if (instant) { void getComputedStyle(P6.h).transform; if (!reduce()) el.classList.remove('noanim'); }   /* sem isto a primeira pintura animava a partir de "none" */
  }
  /* reinicia uma animação CSS sem forçar layout: alterna entre duas classes com keyframes iguais e nomes diferentes
     (mudar o animation-name recomeça-a). Web Animations (el.animate) ficavam presas em "pending" no Chromium sem
     compositor do harness - o conteúdo ficava a opacity 0. */
  /* a letra alterna pela última usada (e não pela classe presente): o animationend pode já ter tirado a classe e, sem um
     recálculo de estilo pelo meio, voltar a pôr a mesma não reiniciava nada */
  function restart(node, base) { if (!node) return; const k = '_' + base, nx = node[k] === 'a' ? 'b' : 'a'; node[k] = nx; node.classList.remove(base + '-a', base + '-b'); node.classList.add(base + '-' + nx); }
  /* salto com mola: só a forma (a lente é hardware e não se mexe) */
  function bump() { if (shape && !reduce()) restart(shape, 'isl-bump'); }
  /* o conteúdo novo entra por opacity, depois de a forma já ir a caminho */
  function fadeIn(node) { if (node && !reduce()) restart(node, 'isl-in'); }

  /* ---------- render ---------- */
  function render() {
    if (!el) return;
    if (isA()) { renderA(); return; }
    const l = order(), m = l[0] || null;
    /* chamada a tocar na pílula principal: fica sempre expandida com atender/rejeitar (e sem recolher sozinha) -
       também quando volta a ser a principal depois de um HUD */
    if (!overlay && isIncoming(m)) { if (!expanded || expKey !== m.key) { expanded = true; expKey = m.key; clearTimeout(collapseT); } }
    else if (expanded && (overlay || !m || m.key !== expKey || !EXPANDABLE.includes(m.mode))) expanded = false;
    const cur = overlay || m, mode = cur ? cur.mode : 'idle', sec = (!overlay && !expanded) ? (l[1] || null) : null;
    el.classList.remove(...MODES);
    const key = overlay ? 'ov:' + overlay.mode : (m ? m.key : null);
    if (mode === 'idle') { live.innerHTML = ''; big.innerHTML = ''; }
    else {
      el.classList.add(mode, expanded ? 'expanded' : 'active');
      if (sec) el.classList.add('two');
      if (!overlay && isIncoming(m)) el.classList.add('isl-inc');   /* não 'incoming': essa classe é o ecrã de chamada do phone.js (shell.css) e punha a ilha em inset:0 */
      if (expanded) { live.innerHTML = ''; renderBig(cur); } else { big.innerHTML = ''; renderLive(cur, !!sec); }
    }
    renderBub(sec);
    if (key !== lastKey || expanded !== lastExp) fadeIn(expanded ? big : live);
    lastKey = key; lastExp = expanded;
    shapeTo(mode === 'idle' ? 'idle' : overlay && overlay.mode === 'hud' ? 'hud' : expanded ? (isIncoming(m) ? 'inc' : 'expanded') : sec ? 'two' : 'active');   /* a chamada a tocar só tem uma linha: ilha mais baixa */
  }

  const dur = t0 => UI.fmtDur((Date.now() - t0) / 1000);
  const left = end => UI.fmtDur(Math.max(0, ((+end || 0) - Date.now()) / 1000));
  const callTxt = d => d.t0 ? dur(d.t0) : (d.status || (d.incoming ? 'chamada recebida' : 'a chamar…'));
  /* cores da capa: só hex/rgb - um valor estranho cai no cinzento em vez de invalidar o gradiente */
  const col = (d, i) => { const c = d && Array.isArray(d.c) ? String(d.c[i] || '') : ''; return /^#[0-9a-f]{3,8}$|^rgba?\([\d\s.,%]+\)$/i.test(c) ? c : (i ? '#3A3A3C' : '#8E8E93'); };
  const isUrl = s => typeof s === 'string' && (/^(https?:\/\/|nui:\/\/|data:image\/)/i.test(s) || /^[\w./-]+\.(png|jpe?g|webp|gif|svg)(\?.*)?$/i.test(s));
  /* capa por CSSOM: imagem por cima e gradiente por baixo (se a imagem falhar vê-se o gradiente) */
  function paintArt(node, d) {
    if (!node) return; const grad = `linear-gradient(135deg,${col(d, 0)},${col(d, 1)})`;
    node.style.backgroundImage = grad;
    if (d && isUrl(d.img)) node.style.backgroundImage = UI.img(d.img) + ', ' + grad;
  }
  /* ícone de uma notificação/atividade: HTML próprio da notificação (já filtrado no notify.js), URL por CSSOM, glifo ou ícone de app */
  function paintIcon(node, d) {
    if (!node) return; const ic = d.icon;
    if (d.ext) { node.innerHTML = d.ext; return; }
    if (isUrl(ic)) { node.innerHTML = '<span class="n-icimg"></span>'; node.firstChild.style.backgroundImage = UI.img(ic); return; }
    if (typeof ic === 'string' && ic && window.App && App.get(ic)) { node.innerHTML = Icons.tile(ic); return; }
    if (typeof ic === 'string' && ic && Icons.has && Icons.has(ic)) { node.innerHTML = `<span class="n-glyph">${g(ic)}</span>`; return; }
    node.innerHTML = Icons.tile(d.app || 'settings');
  }
  const etaTxt = d => {
    if (typeof d.eta === 'number') { const s = Math.max(0, Math.round((d.eta - Date.now()) / 1000)); return s < 60 ? 'agora' : s < 3600 ? Math.round(s / 60) + ' min' : UI.fmtDur(s); }
    if (d.eta) return String(d.eta);
    return d.progress != null ? Math.round(d.progress * 100) + '%' : '';
  };
  const distTxt = d => { const x = Number(d.dist); if (d.dist == null || d.dist === '') return ''; if (!isFinite(x)) return str(d.dist, 16); return x >= 1000 ? (x / 1000).toFixed(x >= 10000 ? 0 : 1).replace('.', ',') + ' km' : Math.round(x) + ' m'; };
  /* anel de progresso: r=8 → perímetro 50,27; o traço vai-se fechando com o dashoffset */
  const ring = (p, cls) => `<div class="dl-ring ${cls || ''}"><svg viewBox="0 0 22 22"><circle class="bg" cx="11" cy="11" r="8"/><circle class="fg" cx="11" cy="11" r="8" style="stroke-dashoffset:${(50.27 * (1 - (p || 0))).toFixed(2)}"/></svg><i></i></div>`;
  const dlRing = d => d.done ? `<div class="dl-ring ok">${g('check', 20)}</div>` : ring(d.p);

  /* `apertada` = a pílula encolheu para dar lugar à bolha da segunda atividade (.island.active.two: 190 px, com
     padding-right 60 → 118 px úteis). Tirando o círculo/ícone e a distância/ETA sobravam ~30 px para o nome:
     'Diamond Casino' aparecia como 'D…' e 'Entrega a caminho' como 'Ent…' - cinco letras a ocupar o lugar sem
     dizerem nada. Aqui a pílula fica como no PearOS (ícone + distância/ETA) e o nome inteiro continua na ilha
     EXPANDIDA (toque longo), que já o mostra. O <span class="grow"> fica como espaçador flexível: é ele que
     encosta a distância à direita, antes da lente.
     ⚠️ O nome só sai QUANDO HÁ OUTRA COISA PARA MOSTRAR. `dist`, `eta` e `progress` são todos opcionais no
     contrato (client/exports.lua: "sem `title` recusa-se - uma pílula sem texto não é uma atividade meio
     ligada, é nada"): uma atividade só com título, ao lado de outra, ficava com a pílula COMPLETAMENTE VAZIA
     - só o ícone. Nesse caso vale mais o título cortado, que é truncagem honesta, do que nada. */
  function renderLive(a, apertada) {
    const d = a.data || {}, m = a.mode;
    if (m === 'call') live.innerHTML = `<div class="av" style="${UI.avatarStyle(d.avatar || 0)}">${esc(UI.initials(d.name))}</div><span class="grow">${esc(d.name)}</span><span class="tm">${esc(callTxt(d))}</span>`;
    else if (m === 'music') {
      /* pedido 2026-09-16: as barras ficam à DIREITA da lente (system.css .island.music .bars) e o título passa em
         carrossel quando não cabe (.mq: só transform anima - regra CEF). A medição faz-se depois de pintar. */
      live.innerHTML = `<div class="art"></div><span class="grow mq"><span class="mq-in">${esc(d.title)}</span></span><div class="bars"><i></i><i></i><i></i><i></i></div>`; paintArt(live.querySelector('.art'), d); live.querySelector('.bars').style.setProperty('--art', col(d, 0));   /* a onda leva a cor da capa */
      const mq = live.querySelector('.mq'), inner = live.querySelector('.mq-in');
      requestAnimationFrame(() => { if (!mq.isConnected) return; const over = inner.scrollWidth - mq.clientWidth; if (over > 2) { mq.style.setProperty('--mq-d', (over + 12) + 'px'); mq.style.setProperty('--mq-t', Math.max(4, Math.round((over + 12) / 22)) + 's'); mq.classList.add('on'); } });
    }
    else if (m === 'timer') live.innerHTML = `${g('timer', 21)}<span class="grow">Temporizador</span><span class="tm">${left(d.end)}</span>`;
    else if (m === 'notif') { live.innerHTML = `<div class="n-ic"></div><div class="grow"><div class="n-t">${esc(App.name(d.app))}</div><div class="n-m">${esc(d.title)}</div></div>`; paintIcon(live.querySelector('.n-ic'), d); }
    else if (m === 'hud') live.innerHTML = `<div class="hud-ic ${esc(d.cls || '')}">${d.icon || ''}</div><span class="hud-tx ${esc(d.cls || '')}">${esc(d.text || '')}</span>`;   /* d.icon é um glifo do próprio telemóvel (hardware.js) */
    else if (m === 'dl') { live.innerHTML = `<div class="n-ic">${Icons.tile(d.id)}</div><div class="grow"><div class="n-t">AppShop</div><div class="n-m">${esc(d.name)}</div></div>${dlRing(d)}`; }
    else if (m === 'nav') { const dt = distTxt(d); live.innerHTML = `<div class="nav-ic">${g('arrowUp')}</div><span class="grow">${apertada && dt ? '' : esc(d.name || d.street || 'Destino')}</span><span class="tm">${esc(dt)}</span>`; }
    else if (m === 'activity') { const anel = d.progress != null && d.eta == null, et = anel ? '' : etaTxt(d);
      live.innerHTML = `<div class="n-ic"></div><span class="grow">${apertada && (anel || et) ? '' : esc(d.title || App.name(d.app))}</span>${anel ? ring(d.progress, 'act') : `<span class="tm act-eta">${esc(et)}</span>`}`; paintIcon(live.querySelector('.n-ic'), d); }
    else live.innerHTML = '';
  }

  function renderBig(a) {
    const d = a.data || {}, m = a.mode;
    const on = (sel, fn) => { const b = big.querySelector(sel); if (b) b.onclick = e => { e.stopPropagation(); fn(e); }; };
    if (m === 'call' && d.incoming) {
      big.innerHTML = `<div class="row"><div class="av isl-av" style="${UI.avatarStyle(d.avatar || 0)}">${esc(UI.initials(d.name))}</div><div class="grow"><div class="isl-name">${esc(d.name)}</div><div class="isl-sub">${esc(d.status || (d.video ? 'FaceCall' : 'chamada de telemóvel…'))}</div></div><div class="end dec">${g('phoneDown')}</div><div class="end ans">${g('phoneFill')}</div></div>`;
      /* rejeitar/atender: quem chama (phone.js) decide o que acontece a seguir (set sem incoming, ou clear);
         a ilha deixa logo de a tratar como "a tocar" para não reabrir os botões num repintar */
      on('.dec', () => { d.incoming = false; expanded = false; safe(d.onDecline); render(); });
      on('.ans', () => { d.incoming = false; expanded = false; safe(d.onAccept); render(); });
    }
    else if (m === 'call') {
      big.innerHTML = `<div class="row"><div class="av isl-av" style="${UI.avatarStyle(d.avatar || 0)}">${esc(UI.initials(d.name))}</div><div class="grow"><div class="isl-name">${esc(d.name)}</div><div class="tm" style="margin:0">${esc(callTxt(d))}</div></div><div class="end">${g('phoneDown')}</div></div><div class="ctl" style="gap:26px"><div class="pill-btn gray mute ${d.muted ? 'on' : ''}">${g('micOff')} Silenciar</div><div class="pill-btn gray spk ${d.speaker ? 'on' : ''}">${g('speaker')} Altifalante</div><div class="pill-btn gray back">${g('expand')} Abrir</div></div>`;
      on('.end', () => safe(d.onEnd));
      on('.back', () => { collapse(); safe(d.onOpen); });
      /* o estado dos botões fica nos dados: um repintar (tick, outra atividade) já não o apaga */
      on('.mute', e => { d.muted = !d.muted; e.currentTarget.classList.toggle('on', d.muted); safe(d.onMute); });
      on('.spk', e => { d.speaker = !d.speaker; e.currentTarget.classList.toggle('on', d.speaker); safe(d.onSpeaker); });
    }
    else if (m === 'music') {
      const Pl = window.Player;
      big.innerHTML = `<div class="row"><div class="art"></div><div class="grow"><div class="isl-name">${esc(d.title)}</div><div class="isl-sub">${esc(d.artist)}</div></div><div class="bars"><i></i><i></i><i></i><i></i></div></div><div class="isl-prog"><i></i></div><div class="ctl"><div class="prev">${g('prev')}</div><div class="play">${g(Pl && Pl.playing ? 'pause' : 'play')}</div><div class="next">${g('next')}</div></div>`;
      paintArt(big.querySelector('.art'), d); big.querySelector('.bars').style.setProperty('--art', col(d, 0)); progress(d);
      on('.prev', () => { if (Pl) Pl.prev(); }); on('.play', () => { if (Pl) { Pl.toggle(); render(); } }); on('.next', () => { if (Pl) Pl.next(); });
    }
    else if (m === 'timer') {
      big.innerHTML = `<div class="row"><div style="font-size:var(--t-foot);opacity:.7">Temporizador</div></div><div style="font-size:44px;font-weight:300;font-variant-numeric:tabular-nums" class="tm-big">${left(d.end)}</div><div class="ctl" style="justify-content:flex-end;gap:12px"><div class="pill-btn gray cancel">Cancelar</div><div class="pill-btn on go">Abrir</div></div>`;
      on('.cancel', () => { safe(d.onCancel); clear('timer'); }); on('.go', () => { collapse(); System.openApp('clock'); });
    }
    else if (m === 'nav') {
      big.innerHTML = `<div class="row"><div class="nav-ic">${g('arrowUp')}</div><div class="grow"><div class="isl-name isl-big">${esc(distTxt(d) || '--')}</div><div class="isl-sub">${esc(d.street || d.name || '')}</div></div></div><div class="ctl" style="justify-content:flex-end;gap:12px">${typeof d.onEnd === 'function' ? '<div class="pill-btn gray stop">Terminar</div>' : ''}<div class="pill-btn on go">Mapas</div></div>`;
      on('.stop', () => { safe(d.onEnd); clear('nav'); }); on('.go', () => { collapse(); openAct(a); });
    }
    else if (m === 'activity') {
      big.innerHTML = `<div class="row"><div class="n-ic"></div><div class="grow"><div class="isl-name">${esc(d.title || App.name(d.app))}</div><div class="isl-sub">${esc(d.subtitle || '')}</div></div><div class="act-eta-big act-eta">${esc(etaTxt(d))}</div></div>${d.progress != null ? '<div class="isl-prog act"><i></i></div>' : ''}<div class="act-foot"><span>${esc(d.state || '')}</span><span class="pill-btn on go">Abrir</span></div>`;
      paintIcon(big.querySelector('.n-ic'), d); progress(d);
      on('.go', () => { collapse(); openAct(a); });
    }
    else big.innerHTML = '';
  }
  /* barra de progresso por transform (scaleX) - a antiga mudava width a cada segundo */
  function progress(d) {
    const i = big.querySelector('.isl-prog i'); if (!i) return;
    let p = d.progress;
    if (p == null) { const Pl = window.Player; p = Pl && d.dur ? Pl.pos / d.dur : 0; }
    i.style.transform = `scaleX(${Math.max(0, Math.min(1, +p || 0)).toFixed(4)})`;
  }

  /* ---------- bolha da segunda atividade ---------- */
  function renderBub(a) {
    clearTimeout(bubT);
    if (!a) { /* o conteúdo fica até a bolha acabar de desvanecer */ bubT = setTimeout(() => { if (!second()) { bub.innerHTML = ''; bub._k = ''; } }, 300); return; }
    const d = a.data || {};
    const k = a.key + '|' + (a.mode === 'music' ? (d.img || '') + (d.title || '') : a.mode === 'dl' ? (d.done ? 'ok' : Math.round((d.p || 0) * 50)) : a.mode === 'activity' ? (d.icon || d.app || '') + (d.progress != null ? Math.round(d.progress * 50) : '') : '');
    if (k === bub._k) return; bub._k = k;
    if (a.mode === 'music') { bub.innerHTML = '<div class="bub-art"></div>'; paintArt(bub.firstChild, d); }
    else if (a.mode === 'dl') bub.innerHTML = dlRing(d);
    else if (a.mode === 'activity') { bub.innerHTML = d.progress != null ? `<div class="n-ic"></div>${ring(d.progress, 'act bub-ring')}` : '<div class="n-ic"></div>'; paintIcon(bub.querySelector('.n-ic'), d); }
    else bub.innerHTML = `<div class="bub-ic ${a.mode}">${g(a.mode === 'call' ? 'phoneFill' : a.mode === 'timer' ? 'timer' : a.mode === 'nav' ? 'arrowUp' : 'dot')}</div>`;
  }

  /* ---------- relógio (System.tick, 1 s) ---------- */
  const musicSig = c => c ? [c.id, c.title, c.artist, c.img, col(c, 0)].join('|') : '';
  function tick() {
    if (!el) return;
    const Pl = window.Player, cur = Pl && Pl.cur && Pl.cur(), app = System.currentApp();
    if (cur && Pl.playing && app !== 'music' && app !== 'podcasts') {
      const a = acts.get('music');
      /* o Player devolve um objeto novo em cada chamada: só se repinta quando a faixa muda (antes repintava todos os segundos e reiniciava as barras) */
      if (!a || musicSig(a.data) !== musicSig(cur)) set('music', cur); else a.data = cur;
    } else if (acts.has('music')) clear('music');
    const T = window.TimerState;
    if (T && T.running && app !== 'clock') {
      const a = acts.get('timer');
      if (!a) set('timer', { end: T.end, onCancel: () => { if (window.TimerState) { TimerState.running = false; TimerState.cancel && TimerState.cancel(); } } });
      else a.data.end = T.end;
    } else if (acts.has('timer')) clear('timer');
    if (isA()) { tickA(); return; }
    if (overlay) return;
    const m = main(); if (!m) return; const d = m.data || {};
    const tm = el.querySelector('.live .tm, .big .tm');
    if (m.mode === 'call' && d.t0 && tm) tm.textContent = dur(d.t0);
    if (m.mode === 'timer') { if (tm) tm.textContent = left(d.end); const tb = el.querySelector('.tm-big'); if (tb) tb.textContent = left(d.end); }
    if (m.mode === 'music' && expanded) progress(d);
    if (m.mode === 'activity' && typeof d.eta === 'number') el.querySelectorAll('.act-eta').forEach(x => { x.textContent = etaTxt(d); });
  }

  /* ---------- notificação e HUD (passageiros, por cima da lista) ---------- */
  /* devolve false se a ilha estiver ocupada (chamada, música, instalação…): quem chama mostra então um banner,
     em vez de a notificação se perder sem nada aparecer */
  function notif(n) {
    if (isA()) return false;   /* Android: sem ilha; o Notify mostra o cartão flutuante dele */
    if (!el || !n || acts.size || overlay) return false;
    overlay = { mode: 'notif', data: n }; expanded = false; render(); bump();
    const ms = Number(n.duration || n.dur); clearTimeout(notifT);
    notifT = setTimeout(() => clear('notif'), ms > 0 ? Math.max(1500, Math.min(15000, ms)) : 2600);
    return true;
  }
  /* HUD do botão de Ação / silêncio (PearOS 17+): a ilha alarga com mola, ícone à esquerda e texto à direita da câmara; depois volta às atividades */
  /* devolve false quando não há ilha (Android: o aviso do modo de som é o painel de volume do Hardware; dobrável: a pílula
     .hw-hud do Hardware, por baixo da barra de estado) */
  function hud(o) {
    if (!el || isA()) return false; o = o || {};
    overlay = { mode: 'hud', data: o }; expanded = false; render(); bump();
    const ms = isIncoming(main()) ? Math.min(+o.ms || 1600, 1600) : (o.ms || 1600);   /* com uma chamada a tocar o HUD é sempre curto: os botões voltam logo */
    clearTimeout(hudT); hudT = setTimeout(() => { if (overlay && overlay.mode === 'hud') { overlay = null; render(); } }, ms);
    return true;
  }

  /* ---------- Instalação da AppShop na ilha (PearOS 17+) ----------
     Ícone + anel de progresso na ilha, em vez de um banner por cima da lente (queixa do utilizador).
     Devolve null se a instalação não chegasse a ver-se (já há duas atividades à frente) - a AppShop volta ao banner. */
  function download(o) {
    if (!el || !o) return null;
    if (order().filter(a => a.key !== 'dl').length >= 2) return null;
    clearTimeout(dlT); upsert('dl', 'dl', { id: o.id, name: o.name, p: 0, done: false }, true); bump();
    const get = () => acts.get('dl');
    return {
      /* a AppShop chama isto a cada frame: só se mexe no anel. Repintar a ilha inteira reconstruía a pílula principal
         60 vezes por segundo - com música à frente as barras reiniciavam sempre e pareciam paradas */
      progress(p) {
        const a = get(); if (!a) return; a.data.p = Math.max(0, Math.min(1, +p || 0));
        if (isA()) { updA(a); return; }   /* Android: só o anel do chip (e o cartão, se aberto) mudam, no sítio */
        if (main() === a) { if (overlay) return; const fg = live.querySelector('.dl-ring .fg'); if (fg) fg.style.strokeDashoffset = (50.27 * (1 - a.data.p)).toFixed(2); else render(); }
        else if (second() === a) renderBub(a);   /* a bolha só se repinta quando o anel muda de degrau (chave em renderBub) */
      },
      done() { const a = get(); if (!a) return; a.data.p = 1; a.data.done = true; render(); Sound.play('pop'); clearTimeout(dlT); dlT = setTimeout(() => clear('dl'), 1900); },
      cancel() { clearTimeout(dlT); clear('dl'); }
    };
  }
  /* Face Key ao desbloquear: só com a ilha livre; alarga, mostra o glifo a reconhecer (~.65 s) e volta ao normal */
  /* com uma cara inscrita mostra-se a FOTOGRAFIA guardada, não o glifo: é a prova visível de que o
     Face Key leu mesmo o personagem. A foto é base64 → vai por CSSOM, nunca dentro do HTML. */
  function faceId() {
    if (!el || isA() || acts.size || overlay) return;   /* Android: a câmara furada não anima */
    const f = window.FaceID && FaceID.stored();
    if (f) { live.innerHTML = '<span class="isl-face"></span>'; live.firstChild.style.backgroundImage = UI.img(f); } else live.innerHTML = g('faceid', 24);
    el.classList.add('faceid'); shapeTo('faceid'); clearTimeout(el._faceT);
    el._faceT = setTimeout(() => { if (!acts.size && !overlay) { el.classList.remove('faceid'); live.innerHTML = ''; shapeTo('idle'); } }, 700);
  }

  /* ---------- expandir / tocar ---------- */
  function expand() {
    if (isA()) { expandA(); return; }
    const m = main(); if (!el || overlay || !m || !EXPANDABLE.includes(m.mode)) return;
    expanded = true; expKey = m.key; render(); clearTimeout(collapseT);
    if (!isIncoming(m)) collapseT = setTimeout(collapse, 7000);
    Sound.play('pop');
  }
  function collapse() { if (!expanded) return; expanded = false; render(); }
  function openAct(a) {
    if (!a) return; const d = a.data || {};
    if (a.mode === 'call') { if (d.incoming) { pin = null; expand(); } else safe(d.onOpen); }
    else if (a.mode === 'music') System.openApp('music');
    else if (a.mode === 'timer') System.openApp('clock');
    else if (a.mode === 'nav') { if (typeof d.onTap === 'function') safe(d.onTap); else System.openApp('maps'); }
    else if (a.mode === 'activity') { if (typeof d.onTap === 'function') safe(d.onTap); else if (d.app && App.get(d.app)) System.openApp(d.app); }
    else if (a.mode === 'dl') { const id = d.id, fin = d.done; clearTimeout(dlT); clear('dl'); System.openApp(fin && App.get(id) && System.isInstalled(id) ? id : 'appstore'); }
    else if (typeof d.onTap === 'function') safe(d.onTap);
  }
  function onTap() {
    if (overlay) { if (overlay.mode === 'notif') { clearTimeout(notifT); const n = overlay.data; overlay = null; render(); Notify.open(n); } return; }
    const m = main(); if (!m) return;
    if (expanded) { if (!isIncoming(m)) collapse(); else safe(m.data.onOpen); return; }
    openAct(m);
  }

  /* ============================================================
     ANDROID (Nova UI 8.5): chips na barra de estado, cartão da atividade e cartão da chamada recebida.
     A lista, as prioridades, a fixação e os dados são os de cima; muda só o desenho. Cada chip é construído UMA vez
     (chave da atividade) e depois só lhe muda o texto/anel: o tick de 1 s nunca refaz nós nem reinicia animações.
     ============================================================ */
  const EXP_A = ['call', 'music', 'timer', 'nav', 'activity', 'dl'];
  const chipEls = new Map();
  let aInc = null, aCard = null, aClean = false, fitDirty = false;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const si = (n, s, c) => (window.SysUI && SysUI.icon) ? SysUI.icon(n, s, c) : g(n === 'phone' ? 'phoneFill' : n, s);
  const storeName = () => { try { return (System.osInfo && System.osInfo().store) || 'NOVA Store'; } catch (e) { return 'NOVA Store'; } };
  /* os chips vivem na barra de estado (.asb-chips, logo a seguir à hora); o SysUI cria-a, aqui só há recurso */
  function chipsBox() {
    if (railOn()) { const b = Rail.actsBox(); if (b) return b; }
    if (window.SysUI && SysUI.ensureBar) { const b = SysUI.ensureBar(); if (b && b.chips) return b.chips; }
    const sb = document.querySelector('#screen .statusbar'); if (!sb) return null;
    let b = sb.querySelector(':scope > .asb-chips');
    if (!b) { b = document.createElement('span'); b.className = 'asb-chips'; const t = sb.querySelector('#sbTime'); sb.insertBefore(b, t ? t.nextSibling : null); }
    return b;
  }
  const RING_C = 34.56;   /* perímetro do anel do chip (r = 5,5) */
  const chipRing = p => `<svg class="alc-ring" viewBox="0 0 14 14"><circle class="alc-rbg" cx="7" cy="7" r="5.5"/><circle class="alc-rfg" cx="7" cy="7" r="5.5" style="stroke-dashoffset:${(RING_C * (1 - (+p || 0))).toFixed(2)}"/></svg>`;
  const kindOf = a => { const d = a.data || {}; return a.mode + (a.mode === 'activity' ? (d.progress != null && d.eta == null ? ':ring' : ':eta') : a.mode === 'dl' ? (d.done ? ':ok' : ':p') : ''); };
  /* texto curto do chip: duração da chamada, tempo que falta, título da música, distância, prazo */
  function chipText(a) {
    const d = a.data || {};
    if (a.mode === 'call') return d.t0 ? dur(d.t0) : String(d.status || T('a ligar…'));
    if (a.mode === 'timer') return left(d.end);
    if (a.mode === 'music') return String(d.title || '');
    if (a.mode === 'nav') return distTxt(d) || String(d.name || d.street || T('Destino'));
    if (a.mode === 'activity') return etaTxt(d) || String(d.title || App.name(d.app) || '');
    return '';
  }
  /* círculo da barra direita: só o ícone; o anel (r 21, perímetro 131,95) mostra o progresso de uma atividade ou instalação */
  const DOT_C = 131.95;
  const dotRing = p => `<svg class="rl-aring" viewBox="0 0 46 46"><circle class="alc-rbg" cx="23" cy="23" r="21"/><circle class="alc-rfg" cx="23" cy="23" r="21" style="stroke-dasharray:${DOT_C};stroke-dashoffset:${(DOT_C * (1 - (+p || 0))).toFixed(2)}"/></svg>`;
  function buildDot(c, a) {
    const d = a.data || {}; c._kind = kindOf(a); c._art = null; c._ic = null;
    if (a.mode === 'call') c.innerHTML = g('phoneFill', 20);
    else if (a.mode === 'timer') c.innerHTML = g('timer', 22);
    else if (a.mode === 'music') c.innerHTML = '<i class="alc-art"></i>';
    else if (a.mode === 'nav') c.innerHTML = g('nav', 20);
    else if (a.mode === 'activity') c.innerHTML = '<i class="alc-ic"></i>' + (c._kind === 'activity:ring' ? dotRing(d.progress) : '');
    else if (a.mode === 'dl') c.innerHTML = `<i class="alc-ic">${Icons.tile(d.id)}</i>` + (d.done ? `<b class="rl-aok">${g('check', 11)}</b>` : dotRing(d.p));
    else c.innerHTML = g('dot', 14);
  }
  function buildChip(c, a) {
    if (c._rail) { buildDot(c, a); return; }
    const d = a.data || {}; c._kind = kindOf(a); c._art = null; c._ic = null;
    if (a.mode === 'call') c.innerHTML = `${si('phone', 12)}<b class="alc-t"></b>`;
    else if (a.mode === 'timer') c.innerHTML = `${si('timer', 12)}<b class="alc-t"></b>`;
    else if (a.mode === 'music') {
      /* titulo em CARROSSEL quando nao cabe (2026-10-01, "nao consigo ver o nome da musica toda"): o texto vai num
         span interior que desliza por transform; mede-se de novo sempre que o chip muda de largura (ResizeObserver) */
      c.innerHTML = '<i class="alc-art"></i><b class="alc-t alc-mq"><span class="alc-mqi"></span></b>';
      /* medir no frame seguinte e so com largura nova: o mqFit muda classes do proprio elemento observado e, dentro da
         entrega do observador, dava "ResizeObserver loop limit exceeded" na consola do jogo */
      if (window.ResizeObserver) { if (c._ro) c._ro.disconnect(); let w0 = -1, rf = 0;
        c._ro = new ResizeObserver(ents => { const r = ents && ents[0] && ents[0].contentRect; const w = r ? Math.round(r.width) : -2; if (w === w0) return; w0 = w; cancelAnimationFrame(rf); rf = requestAnimationFrame(() => mqFit(c)); });
        c._ro.observe(c.querySelector('.alc-mq')); }
    }
    else if (a.mode === 'nav') c.innerHTML = `${si('nav', 12)}<b class="alc-t"></b>`;
    else if (a.mode === 'activity') c.innerHTML = '<i class="alc-ic"></i>' + (c._kind === 'activity:ring' ? chipRing(d.progress) : '<b class="alc-t"></b>');
    else if (a.mode === 'dl') c.innerHTML = `<i class="alc-ic">${Icons.tile(d.id)}</i>` + (d.done ? si('check', 14, 'alc-ok') : chipRing(d.p));
    else c.innerHTML = '<b class="alc-t"></b>';
  }
  function updChip(c, a) {
    const d = a.data || {};
    if (c._kind !== kindOf(a)) buildChip(c, a);
    if (c._rail) {   /* círculo: capa / ícone, anel de progresso e o texto só como rótulo (sem mexer no desenho) */
      if (a.mode === 'music') { const s = musicSig(d); if (c._art !== s) { c._art = s; paintArt(c.querySelector('.alc-art'), d); } }
      if (a.mode === 'activity') { const s = (d.icon || '') + '|' + (d.app || ''); if (c._ic !== s) { c._ic = s; paintIcon(c.querySelector('.alc-ic'), d); } }
      const rf = c.querySelector('.rl-aring .alc-rfg'); if (rf) rf.style.strokeDashoffset = (DOT_C * (1 - (+(a.mode === 'dl' ? d.p : d.progress) || 0))).toFixed(2);
      const lb = chipText(a) || App.name(d.app || '') || ''; if (c._lb !== lb) { c._lb = lb; c.setAttribute('aria-label', lb); }
      return;
    }
    if (a.mode === 'music') { const s = musicSig(d); if (c._art !== s) { c._art = s; paintArt(c.querySelector('.alc-art'), d); } }
    if (a.mode === 'activity') { const s = (d.icon || '') + '|' + (d.app || ''); if (c._ic !== s) { c._ic = s; paintIcon(c.querySelector('.alc-ic'), d); } }
    const t = c.querySelector('.alc-t'); if (t) { const tx = t.querySelector('.alc-mqi') || t; const v = chipText(a); if (tx.textContent !== v) { if (tx.textContent.length !== v.length) fitDirty = true; tx.textContent = v; if (tx !== t) setTimeout(() => mqFit(c), 40); } }
    const fg = c.querySelector('.alc-ring .alc-rfg'); if (fg) fg.style.strokeDashoffset = (RING_C * (1 - (+(a.mode === 'dl' ? d.p : d.progress) || 0))).toFixed(2);
  }
  function newChip(a) {
    const c = document.createElement('span'); c.className = 'alc-chip alc-' + a.mode + ' alc-in'; c.dataset.key = a.key; c.setAttribute('role', 'button');
    c._rail = railOn(); if (c._rail) c.classList.add('rl-g');   /* PearPhone Fold: círculo de vidro da barra direita */
    buildChip(c, a);
    c.addEventListener('animationend', e => { if (e.target === c) c.classList.remove('alc-in'); });
    c.addEventListener('click', e => { e.stopPropagation(); const x = acts.get(c.dataset.key); if (x) { Sound.play('click'); openAct(x); } });
    UI.longPress(c, () => expandA(c.dataset.key));
    return c;
  }
  /* carrossel do titulo: so anda quando o texto e mais largo do que o espaco (distancia e duracao proporcionais) */
  function mqFit(c) {
    const t = c && c.querySelector('.alc-mq'), i = t && t.querySelector('.alc-mqi'); if (!i) return;
    const w = t.clientWidth; if (!w) return;   /* telemovel guardado (display:none): mede-se quando voltar a aparecer */
    const over = i.scrollWidth - w;
    if (over > 2) { t.style.setProperty('--mq-d', (over + 6) + 'px'); t.style.setProperty('--mq-t', Math.max(4, Math.round((over + 6) / 16)) + 's'); t.classList.add('on'); }
    else t.classList.remove('on');
  }
  function dropChip(c) { if (c._ro) { c._ro.disconnect(); c._ro = null; } c.classList.remove('alc-in'); c.classList.add('alc-out'); setTimeout(() => { c.remove(); if (window.SysUI && SysUI.renderNotifs) safe(() => SysUI.renderNotifs()); if (c._rail && window.Rail && Rail.refresh) safe(() => Rail.refresh()); }, 230); }
  function syncChips(list) {
    const box = chipsBox(); if (!box) return;
    const keep = new Set(list.map(a => a.key)); let changed = false;
    /* um chip da barra de estado (Android) não serve de círculo da barra direita (PearPhone Fold) nem o contrário: refaz-se */
    const rl = railOn(); chipEls.forEach((c, k) => { if (!!c._rail !== rl) { if (c._ro) { c._ro.disconnect(); c._ro = null; } c.remove(); chipEls.delete(k); changed = true; } });
    chipEls.forEach((c, k) => { if (!keep.has(k)) { chipEls.delete(k); dropChip(c); } });
    list.forEach((a, i) => {
      let c = chipEls.get(a.key);
      if (!c) { c = newChip(a); chipEls.set(a.key, c); changed = true; }
      updChip(c, a);
      /* só se move quando a ordem mudou de facto: mover um nó reinicia-lhe as animações */
      const live = [...box.children].filter(n => !n.classList.contains('alc-out'));
      if (live[i] !== c) { box.insertBefore(c, live[i] || null); changed = true; }
    });
    /* a barra direita mede de novo: os botões da app começam por baixo dos círculos, e o vidro de cada um pinta o seu sítio */
    if (changed && railOn()) safe(() => Rail.refresh());
  }
  /* ---------- chamada recebida: cartão flutuante no topo ---------- */
  const DEF_SUB = /chamada de telem|^facecall$/i;
  function syncInc(a) {
    if (!a) { if (aInc) { const n = aInc.el; aInc = null; n.classList.remove('alc-in'); n.classList.add('alc-out'); setTimeout(() => n.remove(), 300); } return; }
    if (aInc && aInc.key === a.key && aInc.el.isConnected) { updInc(a); return; }
    if (aInc) { aInc.el.remove(); aInc = null; }
    const scr = UI.screen(); if (!scr) return;
    const n = UI.el(`<div class="alc-inc" role="dialog"><div class="alc-row"><div class="alc-av"></div><div class="alc-tx"><b class="alc-name"></b><span class="alc-sub"></span></div></div>`
      + `<div class="alc-acts"><div class="alc-b alc-dec" role="button">${si('phoneDown', 21)}<span>${esc(T('Recusar'))}</span></div><div class="alc-b alc-ans" role="button">${si('phone', 21)}<span>${esc(T('Atender'))}</span></div></div></div>`);
    const key = a.key, cur = () => { const x = acts.get(key); return x && isIncoming(x) ? x.data : null; };
    /* atender / recusar: quem chama (phone.js, recado-calls.js) decide o que vem a seguir, como na ilha do PearOS */
    n.querySelector('.alc-dec').onclick = e => { e.stopPropagation(); const d = cur(); if (!d) return; d.incoming = false; expanded = false; safe(d.onDecline); render(); };
    n.querySelector('.alc-ans').onclick = e => { e.stopPropagation(); const d = cur(); if (!d) return; d.incoming = false; expanded = false; safe(d.onAccept); render(); };
    n.onclick = () => { const d = cur(); if (d) safe(d.onOpen); };   /* tocar no cartão: ecrã inteiro da chamada */
    scr.appendChild(n); aInc = { key, el: n, sig: '' }; updInc(a);
    void n.offsetWidth; n.classList.add('alc-in');
  }
  function updInc(a) {
    const d = a.data || {}, n = aInc && aInc.el; if (!n) return;
    const sub = d.status && !DEF_SUB.test(String(d.status)) ? String(d.status) : (d.video ? T('Videochamada') : T('Chamada recebida'));
    const sig = [d.name, d.avatar, sub, d.video ? 1 : 0].join('|'); if (sig === aInc.sig) return; aInc.sig = sig;
    n.querySelector('.alc-name').textContent = d.name || T('Desconhecido');
    n.querySelector('.alc-sub').innerHTML = (d.video ? g('video', 14) : si('phone', 14)) + `<span>${esc(sub)}</span>`;
    const av = n.querySelector('.alc-av'); av.style.cssText = UI.avatarStyle(d.avatar || 0); av.textContent = UI.initials(d.name);
  }
  /* ---------- cartão da atividade (toque longo num chip) ---------- */
  const cardSig = a => { const d = a.data || {}; return a.key + '|' + a.mode + '|' + (a.mode === 'activity' ? (d.progress != null ? 'p' : '') : a.mode === 'nav' ? (typeof d.onEnd === 'function' ? 'e' : '') : ''); };
  const progA = (card, p) => { const i = card.querySelector('.alc-prog i'); if (i) i.style.transform = `scaleX(${Math.max(0, Math.min(1, +p || 0)).toFixed(4)})`; };
  function buildCard(card, a) {
    const key = a.key, d0 = a.data || {}, m = a.mode;
    const D = () => { const x = acts.get(key); return x ? (x.data || {}) : null; };
    const on = (sel, fn) => { const b = card.querySelector(sel); if (b) b.onclick = e => { e.stopPropagation(); const d = D(); if (d) fn(d, b); }; };
    const open = `<div class="alc-open" role="button">${si('expand', 18)}</div>`;
    if (m === 'call') {
      card.innerHTML = `<div class="alc-row"><div class="alc-av"></div><div class="alc-tx"><b class="alc-name"></b><span class="alc-sub alc-t"></span></div>${open}</div>`
        + `<div class="alc-acts"><div class="alc-b alc-mute" role="button">${si('micOff', 19)}<span>${esc(T('Silenciar'))}</span></div><div class="alc-b alc-spk" role="button">${si('speaker', 19)}<span>${esc(T('Altifalante'))}</span></div><div class="alc-b alc-end" role="button">${si('phoneDown', 19)}<span>${esc(T('Terminar'))}</span></div></div>`;
      on('.alc-open', d => { collapse(); safe(d.onOpen); });
      on('.alc-end', d => safe(d.onEnd));
      /* o estado dos botões fica nos dados (como na ilha): um repintar não o apaga */
      on('.alc-mute', (d, b) => { d.muted = !d.muted; b.classList.toggle('alc-on', d.muted); safe(d.onMute); });
      on('.alc-spk', (d, b) => { d.speaker = !d.speaker; b.classList.toggle('alc-on', d.speaker); safe(d.onSpeaker); });
    } else if (m === 'music') {
      card.innerHTML = `<div class="alc-row"><div class="alc-art2"></div><div class="alc-tx"><b class="alc-name"></b><span class="alc-sub"></span></div>${open}</div><div class="alc-prog"><i></i></div>`
        + `<div class="alc-media"><div class="alc-prev" role="button">${si('prev', 26)}</div><div class="alc-play" role="button"></div><div class="alc-next" role="button">${si('next', 26)}</div></div>`;
      on('.alc-open', () => { collapse(); System.openApp('music'); });
      on('.alc-prev', () => { const Pl = window.Player; if (Pl && Pl.prev) Pl.prev(); });
      on('.alc-play', () => { const Pl = window.Player; if (Pl && Pl.toggle) { Pl.toggle(); const x = acts.get(key); if (x) updCard(x); } });
      on('.alc-next', () => { const Pl = window.Player; if (Pl && Pl.next) Pl.next(); });
    } else if (m === 'timer') {
      card.innerHTML = `<div class="alc-row"><div class="alc-badge alc-timer">${si('timer', 24)}</div><div class="alc-tx"><b class="alc-name">${esc(T('Temporizador'))}</b><span class="alc-sub">${esc(App.name('clock'))}</span></div><b class="alc-big alc-timer alc-t"></b></div>`
        + `<div class="alc-acts"><div class="alc-b alc-cancel" role="button">${esc(T('Cancelar'))}</div><div class="alc-b alc-pri alc-go" role="button">${esc(T('Abrir'))}</div></div>`;
      on('.alc-cancel', d => { safe(d.onCancel); clear('timer'); });
      on('.alc-go', () => { collapse(); System.openApp('clock'); });
    } else if (m === 'nav') {
      card.innerHTML = `<div class="alc-row"><div class="alc-badge alc-nav">${si('nav', 24)}</div><div class="alc-tx"><b class="alc-name alc-t"></b><span class="alc-sub"></span></div></div>`
        + `<div class="alc-acts">${typeof d0.onEnd === 'function' ? `<div class="alc-b alc-stop" role="button">${esc(T('Terminar'))}</div>` : ''}<div class="alc-b alc-pri alc-go" role="button">${esc(App.name('maps'))}</div></div>`;
      on('.alc-stop', d => { safe(d.onEnd); clear('nav'); });
      on('.alc-go', () => { const x = acts.get(key); collapse(); openAct(x); });
    } else if (m === 'activity') {
      card.innerHTML = `<div class="alc-row"><div class="alc-ic2"></div><div class="alc-tx"><b class="alc-name"></b><span class="alc-sub"></span></div><b class="alc-big alc-eta"></b></div>`
        + `${d0.progress != null ? '<div class="alc-prog"><i></i></div>' : ''}<div class="alc-foot"><span class="alc-state"></span><div class="alc-b alc-pri alc-go" role="button">${esc(T('Abrir'))}</div></div>`;
      paintIcon(card.querySelector('.alc-ic2'), d0);
      on('.alc-go', () => { const x = acts.get(key); collapse(); openAct(x); });
    } else if (m === 'dl') {
      card.innerHTML = `<div class="alc-row"><div class="alc-ic2">${Icons.tile(d0.id)}</div><div class="alc-tx"><b class="alc-name"></b><span class="alc-sub"></span></div></div><div class="alc-prog"><i></i></div>`
        + `<div class="alc-foot"><span>${esc(storeName())}</span><div class="alc-b alc-pri alc-go" role="button">${esc(T('Abrir'))}</div></div>`;
      on('.alc-go', () => { const x = acts.get(key); collapse(); openAct(x); });
    }
  }
  function updCard(a) {
    if (!aCard || !a) return; const card = aCard.el, d = a.data || {}, m = a.mode;
    const put = (sel, v) => { const n = card.querySelector(sel); v = String(v == null ? '' : v); if (n && n.textContent !== v) n.textContent = v; };
    if (m === 'call') {
      put('.alc-name', d.name || T('Chamada')); put('.alc-t', callTxt(d));
      const av = card.querySelector('.alc-av'), s = (d.avatar || 0) + '|' + d.name; if (av && av._s !== s) { av._s = s; av.style.cssText = UI.avatarStyle(d.avatar || 0); av.textContent = UI.initials(d.name); }
      const mu = card.querySelector('.alc-mute'), sp = card.querySelector('.alc-spk'); if (mu) mu.classList.toggle('alc-on', !!d.muted); if (sp) sp.classList.toggle('alc-on', !!d.speaker);
    } else if (m === 'music') {
      put('.alc-name', d.title); put('.alc-sub', d.artist);
      const art = card.querySelector('.alc-art2'), s = musicSig(d); if (art && art._s !== s) { art._s = s; paintArt(art, d); }
      const Pl = window.Player, pl = card.querySelector('.alc-play'), st = Pl && Pl.playing ? 'pause' : 'play'; if (pl && pl._st !== st) { pl._st = st; pl.innerHTML = si(st, 26); }
      progA(card, d.progress != null ? d.progress : (Pl && d.dur ? Pl.pos / d.dur : 0));
    } else if (m === 'timer') put('.alc-t', left(d.end));
    else if (m === 'nav') { put('.alc-t', distTxt(d) || d.name || T('Destino')); put('.alc-sub', d.street || d.name || ''); }
    else if (m === 'activity') { put('.alc-name', d.title || App.name(d.app)); put('.alc-sub', d.subtitle || ''); put('.alc-eta', etaTxt(d)); put('.alc-state', d.state || ''); if (d.progress != null) progA(card, d.progress); }
    else if (m === 'dl') { put('.alc-name', d.done ? T('Instalada') : T('A instalar')); put('.alc-sub', d.name || App.name(d.id)); progA(card, d.done ? 1 : d.p); }
  }
  function syncCard(a) {
    if (!a) { closeCard(); return; }
    const sig = cardSig(a);
    if (aCard && aCard.sig === sig && aCard.el.isConnected) { updCard(a); return; }
    closeCard(true);
    const scr = UI.screen(); if (!scr) return;
    const scrim = UI.el('<div class="alc-scrim"></div>'), card = UI.el('<div class="alc-card" role="dialog"></div>');
    buildCard(card, a);
    scrim.onclick = () => collapse();
    /* mexer no cartão adia o recolher automático (7 s, como a ilha) */
    card.addEventListener('pointerdown', () => { clearTimeout(collapseT); collapseT = setTimeout(collapse, 7000); });
    /* PearPhone Fold: o cartão abre ao lado da barra direita, à altura do círculo que se manteve premido */
    if (railOn()) { const ch = chipEls.get(a.key); let y = 0, p = ch; while (p && p !== scr) { y += p.offsetTop; p = p.offsetParent; } if (p === scr && y) card.style.setProperty('--alc-y', Math.max(16, y - 12) + 'px'); }
    scr.append(scrim, card); aCard = { key: a.key, sig, el: card, scrim };
    updCard(a); void card.offsetWidth; scrim.classList.add('alc-in'); card.classList.add('alc-in');
  }
  function closeCard(instant) {
    const c = aCard; aCard = null; if (!c) return;
    if (instant) { c.el.remove(); c.scrim.remove(); return; }
    c.el.classList.remove('alc-in'); c.scrim.classList.remove('alc-in'); c.el.style.pointerEvents = 'none'; c.scrim.style.pointerEvents = 'none';
    setTimeout(() => { c.el.remove(); c.scrim.remove(); }, 280);
  }
  function expandA(key) {
    const a = key ? acts.get(key) : main(); if (!el || !a || isIncoming(a) || !EXP_A.includes(a.mode)) return;
    expanded = true; expKey = a.key; render(); clearTimeout(collapseT); collapseT = setTimeout(collapse, 7000); Sound.play('pop');
  }
  /* o desenho do PearOS (peças, conteúdo, bolha) sai uma vez ao entrar no Android: a .island fica só a câmara */
  function cleanIOS() { aClean = true; el.classList.remove(...MODES, 'faceid'); live.innerHTML = ''; big.innerHTML = ''; bub.innerHTML = ''; bub._k = ''; overlay = null; clearTimeout(notifT); clearTimeout(hudT); clearTimeout(el._faceT); lastKey = null; lastExp = false; }
  function renderA() {
    if (!aClean) cleanIOS();
    const l = order(), inc = l.find(isIncoming) || null;
    if (expanded) { const a = acts.get(expKey); if (!a || isIncoming(a) || !EXP_A.includes(a.mode)) expanded = false; }
    syncChips(l.filter(a => a !== inc).slice(0, railOn() ? 3 : 2));   /* na barra direita do Fold cabem três círculos */
    syncInc(inc);
    syncCard(expanded ? acts.get(expKey) : null);
    if (window.SysUI && SysUI.renderNotifs) safe(() => SysUI.renderNotifs());   /* os ícones das notificações cedem lugar aos chips */
    /* minimizar/abrir o ecrã da chamada muda só o style.display dele (o observador do SysUI não o vê): a barra de estado e
       a de navegação voltam a medir o que ficou por baixo */
    if (window.SysUI && SysUI.refresh) safe(() => SysUI.refresh());
  }
  /* o texto de um chip mudou de largura (9:59 para 10:00): a barra volta a medir-se para nunca chegar a camara */
  function tickA() { fitDirty = false; chipEls.forEach((c, k) => { const a = acts.get(k); if (a) updChip(c, a); }); if (aCard) { const a = acts.get(aCard.key); if (a) updCard(a); } if (fitDirty && window.SysUI && SysUI.fitLeft) safe(() => SysUI.fitLeft()); }
  function updA(a) { const c = chipEls.get(a.key); if (c) updChip(c, a); if (aCard && aCard.key === a.key) updCard(a); }
  function onOS() {
    if (!el) return;
    if (isA()) { closeCard(true); aClean = false; render(); return; }   /* os chips do outro desenho refazem-se no syncChips */
    /* de volta ao PearOS: chips e cartões saem já e a ilha volta a desenhar-se a partir da forma de repouso */
    chipEls.forEach(c => c.remove()); chipEls.clear();
    if (aInc) { aInc.el.remove(); aInc = null; }
    closeCard(true); expanded = false; aClean = false;
    lastKey = null; lastExp = false; lastGeo = null; shapeTo('idle', true); render();
  }

  return {
    init, set, clear, tick, notif, hud, faceId, download, expand, collapse, activity, update, stop,
    /* `data` vai só com os valores simples (nome, rua, distância, prazo, título, progresso...): sem as funções da atividade */
    list: () => order().map(a => { const data = {}; Object.keys(a.data || {}).forEach(k => { const v = a.data[k]; if (v == null || ['string', 'number', 'boolean'].includes(typeof v)) data[k] = v; }); return { key: a.key, mode: a.mode, prio: a.prio, data }; }),
    /* abrir a atividade como um toque na ilha / no chip (abre a app ou o ecrã da chamada) */
    open: key => { const a = acts.get(String(key)); if (!a) return false; openAct(a); return true; },
    /* uma atividade pela chave ('call', 'music', 'timer', 'nav', 'dl', 'act:<id>'): { key, mode, prio, data } com uma CÓPIA
       rasa dos dados (nome, t0, título...; as funções onOpen/onEnd vêm com ela). A Now Bar do ecrã bloqueado do Android lê-a. */
    get: key => { const a = acts.get(String(key)); return a ? { key: a.key, mode: a.mode, prio: a.prio, data: Object.assign({}, a.data || {}) } : null; },
    get mode() { return overlay ? overlay.mode : (main() ? main().mode : 'idle'); },
    get expanded() { return expanded; }
  };
})();
