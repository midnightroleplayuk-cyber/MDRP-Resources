/* ============================================================
   RECADO · CHAMADAS (pacote RF) - docs/ARQUITETURA.md §9.5 (API) e §9.6 (RPCs recado.call.*)
   ------------------------------------------------------------
   RecadoCalls = { callsView(win), voice(target), video(target), joinLink(win, code), schedule(win, target), active(),
                   renderMessage(msg, bubbleEl) }   (renderMessage é aditivo: bolha das mensagens `call` para o RB)
   · 1:1 (voz e vídeo) é da app Telefone: PhoneApp.call(número, nome, { video }) - a videochamada simulada que já existe.
   · Grupo: recado.call.start / join; a voz é real (canal partilhado do Voice.*), o vídeo é SIMULADO e a partilha de
     ecrã não existe no FiveM - a app diz isto ao jogador, sem rodeios.
   · Ecrã da chamada por cima de tudo (#screen), como o da app Telefone: minimiza para a Dynamic Island
     (Island.set('call')) ou para uma janela pequena arrastável (picture-in-picture).
   · Push recadoCall { callId, event: ring|joined|state|react|left|ended|cancelled } e recadoCallTalking
     { callId, talking: [src] } (este vem do client/recado_calls.lua, de 250 em 250 ms só quando muda).
   · Regras do CEF: só transform/opacity animam; nada de filter/backdrop-filter; imagens nunca dentro de HTML.
   ============================================================ */
window.RecadoCalls = (() => {
  const g = n => UI.g(n), esc = UI.esc;
  const arr = v => Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []);   /* tabela vazia do Lua chega como {} */
  const R = () => (window.Recado && typeof window.Recado === 'object') ? window.Recado : null;
  const svg = d => `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${d}</svg>`;
  /* glifos que o icons.js não tem (traço igual ao dos glifos do sistema) */
  const GL = {
    videoOff: svg('<path d="m22 8-6 4 6 4V8Z"/><rect x="2" y="6" width="14" height="12" rx="2"/><path d="M2 3l19 18"/>'),
    screen: svg('<rect x="2" y="4" width="20" height="13" rx="2"/><path d="M8 21h8M12 17v4M12 13V8M9.5 10.5 12 8l2.5 2.5"/>'),
    pip: svg('<rect x="2" y="4" width="20" height="16" rx="3"/><rect x="12" y="11" width="7" height="6" rx="1.5" fill="currentColor" stroke="none"/>'),
    group: svg('<circle cx="9" cy="8" r="3.2"/><path d="M3 20a6 6 0 0 1 12 0"/><circle cx="17" cy="9" r="2.6"/><path d="M15.5 14.2A5 5 0 0 1 21 19"/>')
  };
  const REACTS = ['❤️', '👍', '😂', '😮', '😢', '🙏', '👏', '🎉', '🔥', '👋'];
  const SIM_KEY = 'recado:calls:simSeen';

  /* ---------- textos ---------- */
  const ERR = {
    disabled: 'O Zapp está desligado neste servidor.', noidentity: 'O telemóvel ainda não tem número.', nophone: 'Precisas de ter o telemóvel contigo.',
    invalid: 'Pedido inválido.', notfound: 'Chamada não encontrada ou sem acesso.', full: 'A chamada está cheia.', busy: 'Já estás noutra chamada.',
    incall: 'Termina primeiro a chamada da app Telefone.', badcode: 'Código inválido. Tem 8 letras e números, por exemplo ABCD-EF12.',
    expired: 'Esta ligação já expirou.', early: 'Ainda é cedo: a chamada abre 15 minutos antes da hora.',
    notallowed: 'Só quem criou a chamada ou um administrador do grupo a pode terminar para todos.', badstart: 'Escolhe um dia e uma hora no futuro.',
    badtitle: 'Escreve um título válido.', limit: 'Chegaste ao limite. Apaga ou cancela alguma primeiro.', blocked: 'Desbloqueia primeiro este contacto.',
    cooldown: 'Devagar…', badreaction: 'Essa reação não está disponível.', db: 'O servidor ainda está a arrancar. Tenta daqui a pouco.',
    ratelimit: 'Demasiados pedidos. Espera um pouco.', empty: 'Sem resposta do servidor.', timeout: 'Sem resposta do servidor.',
    adminsonly: 'Neste grupo só os administradores podem começar ou agendar chamadas.'
  };
  const errText = code => { const k = String(code || ''); if (ERR[k]) return ERR[k]; try { const r = R(); const t = r && typeof r.errorText === 'function' ? r.errorText(k) : null; if (t) return String(t); } catch (e) {} return 'Não foi possível concluir. Tenta outra vez.'; };
  const STATUS = { missed: 'Perdida', declined: 'Recusada', busy: 'Ocupado', cancelled: 'Cancelada', offline: 'Indisponível', unavailable: 'Indisponível' };

  /* ---------- servidor ---------- */
  /* rpcRaw: precisamos do { error } para dizer ao jogador o que falhou (o Bridge.rpc troca-o por null) */
  async function rpc(name, data) {
    let r = null; try { r = await Bridge.rpcRaw(name, data || {}); } catch (e) { r = null; }
    if (r === null || r === undefined || r === false || typeof r !== 'object') return { ok: false, error: 'empty' };
    if (!Array.isArray(r) && r.error) return Object.assign({}, r, { ok: false });
    return r;
  }

  /* ---------- identidades e formatos ---------- */
  const cleanNum = v => (typeof v === 'string' || typeof v === 'number') ? String(v).trim().slice(0, 20) : '';
  const cleanCode = v => { if (typeof v !== 'string' && typeof v !== 'number') return null; const m = String(v).slice(0, 80).match(/([A-Za-z0-9-]+)\s*$/); if (!m) return null; const s = m[1].replace(/-/g, '').toUpperCase(); return /^[A-Z0-9]{6,12}$/.test(s) ? s : null; };
  const fmtCode = c => { const s = String(c || '').replace(/[^A-Za-z0-9]/g, '').toUpperCase(); return s.length === 8 ? s.slice(0, 4) + '-' + s.slice(4) : s; };
  const seedOf = s => [...String(s || '')].reduce((h, c) => (h * 31 + c.charCodeAt(0)) % 100003, 7);
  const contactName = n => { n = cleanNum(n); if (!n) return 'Desconhecido'; try { const r = R(); if (r && typeof r.nameOf === 'function') { const x = r.nameOf(n); if (x) return String(x); } } catch (e) {} return window.Contacts ? Contacts.name(n) : n; };
  const partsOf = v => arr(v && v.participants).filter(p => p && typeof p === 'object' && Math.floor(+p.src) > 0);
  const meOf = v => partsOf(v).find(p => p.isMe) || null;
  const pName = p => p.isMe ? 'Tu' : (p.number ? contactName(p.number) : (p.name ? String(p.name).slice(0, 60) : (p.label ? String(p.label).slice(0, 30) : 'Participante')));
  const fmtWhen = ts => { const d = new Date(+ts || 0), t = new Date(); const tm = new Date(t); tm.setDate(t.getDate() + 1);
    const day = d.toDateString() === t.toDateString() ? 'Hoje' : d.toDateString() === tm.toDateString() ? 'Amanhã' : (UI.fmtWdDayMon ? UI.fmtWdDayMon(d) : UI.DIAS_C[d.getDay()] + ', ' + d.getDate() + ' ' + UI.MESES[d.getMonth()].slice(0, 3));
    return day + ' · ' + UI.fmtTime(d); };
  /* o meu avatar: o perfil do Recado (RA) se existir; senão o nome da conta do telemóvel */
  const meAvatar = () => { let m = null; try { const r = R(); m = r && typeof r.me === 'function' ? r.me() : null; } catch (e) { m = null; }
    const acc = (window.System && System.account) || {};
    return { number: m && m.number ? cleanNum(m.number) : null, name: (m && m.name) || acc.username || 'Eu', seed: 3 }; };
  const copyText = t => { if (window.Msgs && typeof Msgs.copy === 'function') Msgs.copy(t); else UI.toast(t); };

  /* avatar: iniciais já (nunca fica vazio) e depois a foto/avatar do Recado ou do contacto, se houver */
  function paintAvatar(el, o) {
    if (!el) return; o = o || {};
    el.textContent = UI.initials(o.name || '?');
    el.style.cssText = UI.avatarStyle(o.seed != null ? o.seed : seedOf(o.number || o.conversation || o.name));
    try {
      const r = R();
      if (r && typeof r.avatar === 'function' && (o.number || o.conversation)) r.avatar(el, { number: o.number || undefined, conversation: o.conversation || undefined, name: o.name });
      else if (o.number && window.Contacts) Contacts.paintAvatar(el, Contacts.byNumber(o.number));
    } catch (e) {}
  }

  /* grupos do Recado (títulos para as agendadas e o seletor de grupo): recado.threads do RA; sem ele, groups.list */
  let groupsMem = null, groupsAt = 0;
  async function loadGroups(force) {
    if (!force && groupsMem && Date.now() - groupsAt < 30000) return groupsMem;
    let list = [];
    const r = await rpc('recado.threads', { filter: 'groups' });
    if (r.ok !== false) list = arr(r.items || r.threads || r).filter(t => t && (t.group || t.conversation)).map(t => ({ id: Math.floor(+(t.conversation || (t.group && t.group.id))) || 0, title: String((t.group && t.group.title) || t.name || 'Grupo'), members: arr(t.group && t.group.members).length }));
    if (!list.length) { const r2 = await rpc('groups.list', { app: 'recado' }); if (r2.ok !== false) list = arr(r2.items || r2).filter(x => x && x.id).map(x => ({ id: Math.floor(+x.id) || 0, title: String(x.title || 'Grupo'), members: +x.memberCount || arr(x.members).length })); }
    groupsMem = list.filter(x => x.id > 0); groupsAt = Date.now(); return groupsMem;
  }
  const groupTitle = id => { const x = (groupsMem || []).find(g0 => g0.id === +id); return x ? x.title : null; };

  /* ============================================================
     ESTADO
     ============================================================ */
  let active = null;    /* { callId, view, el, pending, min, pip, t0, tick, talking:Set, localMuted:Set, front, speaker, lastSpeaker, count } */
  let ringing = null;   /* { callId, view, from, ui, timeout } */
  let abandonUntil = 0; /* uma chamada a ligar que foi largada: o 'joined' que chegue depois sai logo */
  const tabs = new Set();
  let refreshT = null;
  const refreshTabs = () => { clearTimeout(refreshT); refreshT = setTimeout(() => tabs.forEach(t => { try { t.refresh(); } catch (e) {} }), 450); };
  const phoneBusy = () => !!(window.PhoneApp && PhoneApp.current);

  /* ============================================================
     ECRÃ DA CHAMADA DE GRUPO
     ============================================================ */
  function buildScreen() {
    const el = UI.el(`<div class="rcc-call">
      <div class="rcc-bg"><i class="rcc-blob b1"></i><i class="rcc-blob b2"></i></div>
      <div class="rcc-top">
        <div class="rcc-ib rcc-min">${g('chevD')}</div>
        <div class="rcc-head"><div class="rcc-title"></div><div class="rcc-status"><i class="rcc-live"></i><span class="rcc-time">a ligar…</span></div></div>
        <div class="rcc-ib rcc-more">${g('more')}</div>
      </div>
      <div class="rcc-chips"></div>
      <div class="rcc-grid" data-n="1"></div>
      <div class="rcc-wait"></div>
      <div class="rcc-fx"></div>
      <div class="rcc-picker"></div>
      <div class="rcc-bar">
        <div class="rcc-row2">
          <div class="rcc-pill rcc-hand">${g('hand')}<span>Mão</span></div>
          <div class="rcc-pill rcc-flip">${g('repeat')}<span>Trocar câmara</span></div>
          <div class="rcc-pill rcc-share">${GL.screen}<span>Ecrã</span></div>
          <div class="rcc-pill rcc-add">${g('personPlus')}<span>Adicionar</span></div>
        </div>
        <div class="rcc-row1">
          <div class="rcc-btn rcc-cam"><div class="rcc-bc"></div><span>Câmara</span></div>
          <div class="rcc-btn rcc-mic"><div class="rcc-bc"></div><span>Microfone</span></div>
          <div class="rcc-btn rcc-react"><div class="rcc-bc">${g('smile')}</div><span>Reagir</span></div>
          <div class="rcc-btn rcc-leave"><div class="rcc-bc">${g('phoneDown')}</div><span>Sair</span></div>
        </div>
      </div>
    </div>`);
    const on = (sel, fn) => { const b = el.querySelector(sel); if (b) b.onclick = e => { e.stopPropagation(); if (active && active.el === el) fn(e); }; };
    on('.rcc-min', () => minimize());
    on('.rcc-more', () => moreMenu());
    on('.rcc-mic', () => toggleMute());
    on('.rcc-cam', () => toggleCam());
    on('.rcc-react', () => togglePicker());
    on('.rcc-leave', () => leave());
    on('.rcc-hand', () => toggleHand());
    on('.rcc-flip', () => flipCam());
    on('.rcc-share', () => screenShareInfo());
    on('.rcc-add', () => addPeople());
    UI.swipe(el.querySelector('.rcc-top'), { down: () => minimize(), threshold: 70 });
    el.querySelector('.rcc-fx').onclick = () => closePicker();
    return el;
  }

  function openPending(o) {
    if (active) return;
    const el = buildScreen(); UI.screen().appendChild(el);
    active = { callId: null, pending: true, view: { title: o.title || 'Chamada', video: !!o.video, conversation: o.conversation || null, participants: [], ringing: [] }, el, min: false, pip: null, t0: 0, talking: new Set(), localMuted: new Set(), front: true, speaker: false, lastSpeaker: null, count: 0 };
    renderAll();
    Sound.play('pop');
  }

  function openCall(view, opts = {}) {
    const id = Math.floor(+(view && view.callId)) || 0; if (!id) return;
    if (active && active.callId === id) { applyView(view); if (!opts.keepMin && active.min) restore(); return; }
    if (active && !active.pending) closeCall('switch', true);
    stopRinging();
    if (!active) { const el = buildScreen(); UI.screen().appendChild(el); active = { el, min: false, pip: null, talking: new Set(), localMuted: new Set(), front: true, speaker: false, lastSpeaker: null, count: 0 }; }
    active.callId = id; active.pending = false; active.t0 = Date.now() - Math.max(0, +view.elapsed || 0);
    clearInterval(active.tick); active.tick = setInterval(tick, 1000);
    applyView(view);
    Sound.play('connect');
    Bridge.emit('recado:call', { event: 'open', callId: id });
    if (opts.min) minimize();
  }

  function applyView(view) {
    const a = active; if (!a || !view || typeof view !== 'object') return;
    const before = a.count;
    a.view = view;
    const el = +view.elapsed; if (isFinite(el) && el >= 0) { const t0 = Date.now() - el; if (!a.t0 || Math.abs(t0 - a.t0) > 2500) a.t0 = t0; }
    const srcs = new Set(partsOf(view).map(p => Math.floor(+p.src)));
    [...a.localMuted].forEach(s => { if (!srcs.has(s)) a.localMuted.delete(s); });
    a.count = srcs.size;
    if (before && a.count > before) Sound.play('pop');
    renderAll();
    if (a.min && !a.pip) setIsland();
  }

  function renderAll() { renderGrid(); renderControls(); paintPip(); }

  function renderGrid() {
    const a = active; if (!a || !a.el) return;
    const grid = a.el.querySelector('.rcc-grid');
    const ps = a.pending ? [{ src: -1, isMe: true, muted: false, video: !!a.view.video, hand: 0 }] : partsOf(a.view);
    grid.dataset.n = String(Math.min(8, Math.max(1, ps.length)));
    const keep = new Set();
    ps.forEach(p => {
      const key = String(Math.floor(+p.src)); keep.add(key);
      let t = [...grid.children].find(x => x.dataset.src === key);
      if (!t) {
        t = UI.el(`<div class="rcc-tile" data-src="${key}"><div class="rcc-sim"><i></i><span class="rcc-sim-tag">vídeo simulado</span></div><div class="rcc-avwrap"><i class="rcc-ring"></i><i class="rcc-ring r2"></i><div class="rcc-av"></div></div><div class="rcc-tname"><span class="rcc-nm"></span><span class="rcc-ic rcc-ic-mute">${g('micOff')}</span><span class="rcc-ic rcc-ic-lm">${g('volumeX')}</span></div><div class="rcc-handb">✋</div></div>`);
        t.onclick = () => { const cur = partsOf(active && active.view).find(x => String(Math.floor(+x.src)) === key); if (cur) tileMenu(cur); };
        t._k = '';
      }
      grid.appendChild(t);   /* reordena sem recriar (appendChild move o nó) */
      const name = a.pending ? 'Tu' : pName(p);
      const k = name + '|' + (p.number || '');
      if (t._k !== k) { t._k = k; t.querySelector('.rcc-nm').textContent = name; paintAvatar(t.querySelector('.rcc-av'), p.isMe ? meAvatar() : { number: p.number, name }); }
      const src = Math.floor(+p.src);
      t.classList.toggle('me', !!p.isMe);
      t.classList.toggle('rcc-muted', !!p.muted);   /* não .muted: o ui.css tem .muted{ color:label2 } global */
      t.classList.toggle('video', !!p.video);
      t.classList.toggle('hand', +p.hand > 0);
      t.classList.toggle('lmuted', a.localMuted.has(src));
      t.classList.toggle('talking', a.talking.has(src));
      t.classList.toggle('back', !!(p.isMe && p.video && !a.front));
      t.querySelector('.rcc-sim-tag').textContent = p.isMe && p.video ? (a.front ? 'frontal · vídeo simulado' : 'traseira · vídeo simulado') : 'vídeo simulado';
    });
    [...grid.children].forEach(x => { if (!keep.has(x.dataset.src)) x.remove(); });
  }

  function renderControls() {
    const a = active; if (!a || !a.el) return;
    const v = a.view || {}, me = meOf(v) || { muted: false, video: false, hand: 0 };
    const q = s => a.el.querySelector(s);
    q('.rcc-title').textContent = v.title || 'Chamada';
    const mic = q('.rcc-mic'); mic.classList.toggle('on', !!me.muted); mic.querySelector('.rcc-bc').innerHTML = g(me.muted ? 'micOff' : 'mic'); mic.querySelector('span').textContent = me.muted ? 'Silenciado' : 'Microfone';
    const cam = q('.rcc-cam'); cam.classList.toggle('on', !!me.video); cam.querySelector('.rcc-bc').innerHTML = me.video ? g('video') : GL.videoOff; cam.querySelector('span').textContent = me.video ? 'Câmara' : 'Câmara off';
    q('.rcc-hand').classList.toggle('on', +me.hand > 0);
    q('.rcc-flip').classList.toggle('dis', !me.video);
    q('.rcc-add').classList.toggle('dis', !!a.pending);
    [...a.el.querySelectorAll('.rcc-btn,.rcc-pill')].forEach(b => b.classList.toggle('wait', !!a.pending && !b.classList.contains('rcc-leave')));
    /* avisos honestos: vídeo simulado sempre que alguém tem a câmara "ligada" */
    const anyVideo = partsOf(v).some(p => p.video) || (a.pending && v.video);
    const chips = q('.rcc-chips');
    const want = (anyVideo ? 'v' : '') + (v.kind === 'link' ? 'l' : '');
    if (chips.dataset.k !== want) {
      chips.dataset.k = want; chips.innerHTML = '';
      if (anyVideo) chips.appendChild(UI.el(`<div class="rcc-chip">${g('video')}<span>Vídeo simulado: o FiveM não transmite imagem</span></div>`));
      if (v.kind === 'link') chips.appendChild(UI.el(`<div class="rcc-chip rcc-chip-l">${g('link')}<span>Ligação ${esc(fmtCode(v.code))}</span></div>`));
    }
    const rg = arr(v.ringing);
    const wait = q('.rcc-wait');
    if (rg.length) { const names = rg.slice(0, 3).map(x => x && x.number ? contactName(x.number) : 'Convidado'); wait.textContent = 'A chamar ' + names.join(', ') + (rg.length > 3 ? ' e mais ' + (rg.length - 3) : '') + '…'; wait.classList.add('on'); }
    else { wait.textContent = ''; wait.classList.remove('on'); }
    tick();
  }

  function tick() {
    const a = active; if (!a || !a.el) return;
    const txt = a.pending ? 'a ligar…' : UI.fmtDur((Date.now() - a.t0) / 1000);
    const t = a.el.querySelector('.rcc-time'); if (t && t.textContent !== txt) t.textContent = txt;
    a.el.classList.toggle('rcc-pending', !!a.pending);
    if (a.pip) { const s = a.pip.el.querySelector('.rcc-pip-s'); if (s) s.textContent = txt; }
    /* cartão "Voltar à chamada" no separador (só existe com a chamada minimizada) */
    if (a.min && !a.pending) document.querySelectorAll('.rcc-livecard .rcc-lc-b span').forEach(s => { s.textContent = partsOf(a.view).length + ' na chamada · ' + txt; });
  }

  function onTalking(d) {
    const a = active; if (!a || !d || a.pending || Math.floor(+d.callId) !== a.callId) return;
    const set = new Set(arr(d.talking).map(x => Math.floor(+x)).filter(x => x > 0));
    a.talking = set;
    const mine = Math.floor(+(a.view && a.view.me)) || 0;
    const other = [...set].find(s => s !== mine); if (other) a.lastSpeaker = other;
    if (a.el) a.el.querySelectorAll('.rcc-grid .rcc-tile').forEach(t => t.classList.toggle('talking', set.has(Math.floor(+t.dataset.src))));
    paintPip();
  }

  /* ---------- controlos ---------- */
  async function toggleMute() {
    const a = active; if (!a || a.pending) return; const me = meOf(a.view); if (!me) return;
    const on = !me.muted; me.muted = on; renderAll(); if (a.min && !a.pip) setIsland(); Sound.play('click');
    const r = await rpc('recado.call.mute', { callId: a.callId, on });
    if (!r.ok && active === a) { const m2 = meOf(a.view); if (m2) m2.muted = !on; renderAll(); UI.toast(errText(r.error)); }
  }
  function simNotice() {
    try { if (Store.get(SIM_KEY, false)) return; Store.set(SIM_KEY, true); } catch (e) {}
    UI.alert({ title: 'Vídeo simulado', msg: 'O FiveM não dá acesso a uma câmara verdadeira. Com a câmara "ligada" os outros veem o teu cartão animado com o aviso de vídeo simulado: nenhuma imagem é transmitida. A voz é real.' });
  }
  async function setCam(on) {
    const a = active; if (!a || a.pending) return; const me = meOf(a.view); if (!me || !!me.video === on) return;
    me.video = on; renderAll(); if (on) simNotice();
    const r = await rpc('recado.call.video', { callId: a.callId, on });
    if (!r.ok && active === a) { const m2 = meOf(a.view); if (m2) m2.video = !on; renderAll(); UI.toast(errText(r.error)); }
  }
  const toggleCam = () => { const me = active && meOf(active.view); if (me) setCam(!me.video); };
  function flipCam() {
    const a = active; if (!a) return; const me = meOf(a.view);
    if (!me || !me.video) { UI.toast('Liga primeiro a câmara (simulada)'); return; }
    a.front = !a.front; renderGrid(); UI.toast(a.front ? 'Câmara frontal · simulada' : 'Câmara traseira · simulada');
  }
  async function toggleHand() {
    const a = active; if (!a || a.pending) return; const me = meOf(a.view); if (!me) return;
    const on = !(+me.hand > 0); me.hand = on ? Date.now() : 0; renderAll();
    if (on) UI.toast('Mão levantada');
    const r = await rpc('recado.call.hand', { callId: a.callId, on });
    if (!r.ok && active === a) { const m2 = meOf(a.view); if (m2) m2.hand = on ? 0 : Date.now(); renderAll(); UI.toast(errText(r.error)); }
  }
  function screenShareInfo() {
    UI.alert({ title: 'Partilha de ecrã indisponível', msg: 'O FiveM não permite capturar nem transmitir o ecrã do telemóvel. Nas chamadas do Zapp a voz é real e o vídeo é simulado.' });
  }

  /* reações: aparecem logo para quem reage e seguem para os outros pelo servidor */
  function togglePicker() {
    const a = active; if (!a || !a.el || a.pending) return;
    const p = a.el.querySelector('.rcc-picker');
    if (p.classList.contains('open')) { closePicker(); return; }
    const list = arr(a.view.reactions).filter(x => typeof x === 'string' && x.length <= 16);
    p.innerHTML = '';
    (list.length ? list : REACTS).slice(0, 10).forEach(e => { const b = UI.el('<div class="rcc-emo"></div>'); b.textContent = e; b.onclick = ev => { ev.stopPropagation(); sendReaction(e); }; p.appendChild(b); });
    p.classList.add('open'); a.el.querySelector('.rcc-react').classList.add('on');
  }
  function closePicker() { const a = active; if (!a || !a.el) return; a.el.querySelector('.rcc-picker').classList.remove('open'); a.el.querySelector('.rcc-react').classList.remove('on'); }
  async function sendReaction(e) {
    const a = active; if (!a || a.pending) return;
    closePicker(); floatReaction(e, Math.floor(+a.view.me) || 0, true);
    const r = await rpc('recado.call.react', { callId: a.callId, emoji: e });
    if (!r.ok && r.error !== 'cooldown' && active === a) UI.toast(errText(r.error));
  }
  let floatN = 0;
  function floatReaction(emoji, fromSrc, mine) {
    const a = active; if (!a || !a.el || a.min || typeof emoji !== 'string' || emoji.length > 16) return;
    const fx = a.el.querySelector('.rcc-fx'); if (fx.children.length > 12) fx.firstElementChild.remove();
    const p = partsOf(a.view).find(x => Math.floor(+x.src) === Math.floor(+fromSrc));
    const s = UI.el(`<div class="rcc-float v${floatN++ % 3}"><span class="rcc-fe"></span><span class="rcc-fw"></span></div>`);
    s.querySelector('.rcc-fe').textContent = emoji;
    s.querySelector('.rcc-fw').textContent = mine ? 'Tu' : (p ? pName(p) : '');
    s.style.left = Math.round(60 + Math.random() * 260) + 'px';
    const done = () => s.remove();
    s.addEventListener('animationend', done); setTimeout(done, 3400);   /* no headless a animação pode nem acabar */
    fx.appendChild(s);
  }

  async function tileMenu(p) {
    const a = active; if (!a || a.pending || !p || p.isMe) return;
    const src = Math.floor(+p.src), lm = a.localMuted.has(src);
    const buttons = [{ label: lm ? 'Voltar a ouvir' : 'Silenciar só para mim', value: 'lmute', icon: lm ? 'speaker' : 'volumeX' }];
    if (p.number && R() && typeof R().openChat === 'function') buttons.push({ label: 'Enviar mensagem', value: 'msg', icon: 'message' });
    if (p.number && window.RecadoPeople && typeof RecadoPeople.openProfile === 'function') buttons.push({ label: 'Ver perfil', value: 'profile', icon: 'person' });
    const v = await UI.actionSheet({ title: pName(p), buttons });
    if (!active || active !== a) return;
    if (v === 'lmute') {
      const on = !lm;
      const r = await Bridge.call('recadoCallLocalMute', { callId: a.callId, src, on });
      if (r && r.ok === false) { UI.toast('Esta pessoa já não está na chamada'); return; }
      if (on) a.localMuted.add(src); else a.localMuted.delete(src);
      renderGrid();
      UI.toast(on ? (r && r.near ? 'Silenciada só para ti (ao teu lado ouve-se ao vivo)' : 'Silenciada só para ti') : 'Voltaste a ouvir');
    } else if (v === 'msg') { minimize(); try { R().openChat({ number: p.number }); } catch (e) {} }
    else if (v === 'profile') {
      /* o perfil é uma vista empurrada na janela do Recado: com a chamada aberta a partir de uma notificação ou de
         outra app a janela ainda não existe (win null rebentava no UI.push) - abre-se a app primeiro */
      minimize();
      const go = () => { try { if (R() && R().win) RecadoPeople.openProfile(R().win, p.number); } catch (e) {} };
      if (R() && R().win) go(); else { try { System.openApp('recado'); } catch (e) {} setTimeout(go, 500); }
    }
  }

  async function addPeople() {
    const a = active; if (!a || a.pending) return;
    const v = a.view; const room = Math.max(0, (+v.max || 8) - partsOf(v).length - arr(v.ringing).length);
    if (!room) { UI.toast(errText('full')); return; }
    let numbers = [];
    try {
      if (window.RecadoPeople && typeof RecadoPeople.pickContacts === 'function') numbers = arr(await RecadoPeople.pickContacts(R() && R().win, { multi: true, max: room }));
      else if (window.Contacts) { const c = await Contacts.pick('Adicionar à chamada'); if (c && c.number) numbers = [c.number]; }
    } catch (e) { numbers = []; }
    const inCall = new Set(partsOf(v).map(p => p.number).filter(Boolean));
    numbers = numbers.map(x => cleanNum(x && typeof x === 'object' ? x.number : x)).filter(n => n && !inCall.has(n)).slice(0, room);
    if (!numbers.length || active !== a) return;
    const r = await rpc('recado.call.invite', { callId: a.callId, numbers });
    if (!r.ok) { UI.toast(errText(r.error)); return; }
    const res = r.results && typeof r.results === 'object' ? r.results : {};
    const n = st => Object.keys(res).filter(k => res[k] === st).length;
    /* as chaves vêm de uma tabela Lua: a ordem não é a do pedido, por isso o nome sai da própria chave */
    const one = Object.keys(res).find(k => res[k] === 'ringing');
    UI.toast(n('ringing') ? `A chamar ${n('ringing') === 1 ? contactName(one) : n('ringing') + ' pessoas'}…` : n('full') ? errText('full') : n('already') ? 'Já está na chamada' : n('offline') ? 'Indisponível agora, fica o convite' : 'Não foi possível adicionar');
  }

  async function moreMenu() {
    const a = active; if (!a || a.pending) return; const v = a.view;
    const buttons = [{ label: 'Janela pequena (picture-in-picture)', value: 'pip', icon: 'minimize' }, { label: 'Copiar código da chamada', value: 'code', icon: 'copy' }];
    if (v.conversation && R() && typeof R().openChat === 'function') buttons.push({ label: 'Abrir a conversa do grupo', value: 'chat', icon: 'message' });
    if (v.canEnd) buttons.push({ label: 'Terminar para todos', value: 'end', icon: 'phoneDown', danger: true });
    const r = await UI.actionSheet({ title: v.title || 'Chamada', buttons });
    if (active !== a) return;
    if (r === 'pip') openPip();
    else if (r === 'code') copyText(fmtCode(v.code));
    else if (r === 'chat') { minimize(); try { R().openChat({ conversation: v.conversation }); } catch (e) {} }
    else if (r === 'end') {
      if (!await UI.confirm('Terminar para todos?', 'A chamada acaba para todos os participantes.', 'Terminar', true)) return;
      const x = await rpc('recado.call.end', { callId: a.callId });
      if (!x.ok) UI.toast(errText(x.error));
    }
  }

  /* ---------- sair / terminar ---------- */
  async function leave() {
    const a = active; if (!a) return;
    if (a.pending) { abandonUntil = Date.now() + 8000; closeCall('left', true); return; }
    closeCall('left');
    await rpc('recado.call.leave', { callId: a.callId });
  }

  function closeCall(reason, silent) {
    const a = active; if (!a) return;
    active = null;
    clearInterval(a.tick);
    if (a.pip && a.pip.el) a.pip.el.remove();
    if (!phoneBusy()) Island.clear('call');
    if (a.el) {
      const t = a.el.querySelector('.rcc-time');
      if (t) t.textContent = reason === 'ended' ? 'chamada terminada' : reason === 'phonecall' ? 'mudaste para a chamada do Telefone' : 'saíste da chamada';
      if (a.min || silent) a.el.remove();
      else { a.el.classList.add('rcc-ending'); setTimeout(() => a.el.remove(), 900); }
    }
    if (!silent) Sound.play('call_end');
    if (reason === 'phonecall') UI.toast('Saíste da chamada de grupo para atender');
    if (a.callId) Bridge.emit('recado:call', { event: 'closed', callId: a.callId, reason });
    refreshTabs();
  }

  /* ---------- minimizar: ilha ou picture-in-picture ---------- */
  function setIsland() {
    const a = active; if (!a || !a.min || a.pip || phoneBusy()) return;
    const me = meOf(a.view) || {};
    Island.set('call', { name: a.view.title || 'Chamada', avatar: seedOf(a.view.title), t0: a.pending ? 0 : a.t0, status: a.pending ? 'a ligar…' : 'Zapp', muted: !!me.muted, speaker: !!a.speaker,
      onOpen: () => restore(), onEnd: () => leave(), onMute: () => toggleMute(), onSpeaker: () => { if (active) active.speaker = !active.speaker; } });
  }
  function minimize() {
    const a = active; if (!a || !a.el) return;
    closePicker(); a.min = true; a.el.classList.add('rcc-hidden');
    setIsland();
    Bridge.emit('recado:call', { event: 'min', callId: a.callId });   /* o separador mostra o cartão "Voltar à chamada" */
  }
  function restore() {
    const a = active; if (!a || !a.el) return;
    if (a.pip) { a.pip.el.remove(); a.pip = null; }
    a.min = false; a.el.classList.remove('rcc-hidden');
    if (!phoneBusy()) Island.clear('call');
    renderAll();
    Bridge.emit('recado:call', { event: 'restore', callId: a.callId });
  }

  function openPip() {
    const a = active; if (!a || !a.el || a.pending) return;
    closePicker();
    if (!phoneBusy()) Island.clear('call');
    a.min = true; a.el.classList.add('rcc-hidden');
    if (a.pip) return;
    Bridge.emit('recado:call', { event: 'min', callId: a.callId });
    const pip = UI.el(`<div class="rcc-pip"><div class="rcc-pip-av"><i class="rcc-ring"></i><div class="rcc-av"></div></div><div class="rcc-pip-t"></div><div class="rcc-pip-s"></div><div class="rcc-pip-bar"><div class="rcc-pip-b rcc-pip-mic"></div><div class="rcc-pip-b rcc-pip-end">${g('phoneDown')}</div></div></div>`);
    const W = 136, H = 186, SW = (window.System && System.SW) || 440;   /* largura do ecrã: 880 no PearPhone Fold aberto */
    const st = { x: SW - 14 - W, y: 118, drag: null };
    const place = () => { pip.style.transform = `translate(${Math.round(st.x)}px,${Math.round(st.y)}px)`; };
    place();
    pip.querySelector('.rcc-pip-mic').onclick = e => { e.stopPropagation(); toggleMute(); };
    pip.querySelector('.rcc-pip-end').onclick = e => { e.stopPropagation(); leave(); };
    /* arrastar dentro do ecrã (px do rato → px do telemóvel pela escala do UI.zoom) e encostar ao lado mais perto */
    pip.addEventListener('pointerdown', e => { if (e.target.closest('.rcc-pip-b')) return; st.drag = { px: e.clientX, py: e.clientY, x: st.x, y: st.y, moved: false }; pip.classList.remove('snap'); try { pip.setPointerCapture(e.pointerId); } catch (x) {} });
    pip.addEventListener('pointermove', e => { const d = st.drag; if (!d) return; const z = UI.zoom(); const dx = (e.clientX - d.px) / z, dy = (e.clientY - d.py) / z; if (Math.abs(dx) + Math.abs(dy) > 6) d.moved = true; st.x = d.x + dx; st.y = d.y + dy; place(); });
    const up = () => { const d = st.drag; if (!d) return; st.drag = null; if (!d.moved) { restore(); return; }
      pip.classList.add('snap'); st.x = (st.x + W / 2) < SW / 2 ? 14 : SW - 14 - W; st.y = Math.max(70, Math.min(956 - H - 40, st.y)); place(); };
    pip.addEventListener('pointerup', up); pip.addEventListener('pointercancel', up);
    UI.screen().appendChild(pip);
    a.pip = { el: pip, st };
    paintPip();
  }
  function paintPip() {
    const a = active; if (!a || !a.pip) return;
    const pip = a.pip.el, ps = partsOf(a.view);
    const focus = ps.find(p => Math.floor(+p.src) === a.lastSpeaker) || ps.find(p => !p.isMe) || ps[0];
    const me = meOf(a.view) || {};
    const key = focus ? String(focus.src) + '|' + (focus.number || '') : '';
    if (pip._k !== key) { pip._k = key; paintAvatar(pip.querySelector('.rcc-av'), focus ? { number: focus.isMe ? null : focus.number, name: pName(focus) } : { name: a.view.title }); pip.querySelector('.rcc-pip-t').textContent = focus ? pName(focus) : (a.view.title || ''); }
    pip.classList.toggle('talking', !!(focus && a.talking.has(Math.floor(+focus.src))));
    pip.classList.toggle('video', !!(focus && focus.video));
    const mic = pip.querySelector('.rcc-pip-mic'); mic.innerHTML = g(me.muted ? 'micOff' : 'mic'); mic.classList.toggle('on', !!me.muted);
    tick();
  }

  /* ============================================================
     CONVITE A TOCAR (ecrã inteiro ou ilha, como a app Telefone)
     ============================================================ */
  function stopRinging(sendDecline) {
    const r = ringing; if (!r) return;
    ringing = null;
    Sound.stopRing(); clearTimeout(r.timeout);
    if (r.ui) { try { r.ui.remove(); } catch (e) {} }
    if (sendDecline) rpc('recado.call.decline', { callId: r.callId });
  }

  function onRing(d) {
    const id = Math.floor(+d.callId) || 0; if (!id) return;
    const view = d.call && typeof d.call === 'object' ? d.call : {};
    if ((active && active.callId === id) || (ringing && ringing.callId === id)) return;
    /* o Recado não está instalado nesta personagem (desinstalou-o mas continua num grupo): não toca uma app que
       não existe no telemóvel - conta como perdida para ele, sem ecrã nem som */
    if (window.System && typeof System.isInstalled === 'function' && !System.isInstalled('recado')) { rpc('recado.call.decline', { callId: id, busy: true }); return; }
    /* ocupado: numa chamada do Telefone, noutra de grupo ou já a tocar outra → recusa como "ocupado" */
    if (phoneBusy() || active || ringing) { rpc('recado.call.decline', { callId: id, busy: true }); UI.toast('Chamada de grupo recusada: estás noutra chamada'); return; }
    const from = cleanNum(d.from);
    const mine = ringing = { callId: id, view, from, ui: null, timeout: null };
    Sound.ring(System.state.ringtone); Bridge.call('playAnim', { anim: 'ring' });
    const title = String(view.title || 'Chamada de grupo').slice(0, 60);
    const kind = view.video ? 'Videochamada de grupo · Zapp' : 'Chamada de voz de grupo · Zapp';
    const accept = async () => {
      if (ringing !== mine) return;
      stopRinging();
      openPending({ title, video: !!view.video, conversation: view.conversation });
      const pend = active;
      const r = await rpc('recado.call.join', { callId: id });
      if (active !== pend) { if (r.ok && r.callId && !(active && active.callId === r.callId)) rpc('recado.call.leave', { callId: r.callId }); return; }
      if (!r.ok) { closeCall('failed', true); UI.toast(errText(r.error)); return; }
      openCall(r.call);
      if (r.call && r.call.video) setCam(true);
    };
    const decline = () => { if (ringing !== mine) return; stopRinging(true); Sound.play('call_end'); };
    const full = () => {
      const ui = UI.el(`<div class="rcc-rs">
        <div class="rcc-bg"><i class="rcc-blob b1"></i><i class="rcc-blob b2"></i></div>
        <div class="rcc-rs-top"><div class="rcc-rs-app"><i class="rcc-rs-logo">${g('chat')}</i><span>Zapp</span></div><div class="rcc-rs-kind"></div></div>
        <div class="rcc-rs-avwrap"><i class="rcc-pulse p1"></i><i class="rcc-pulse p2"></i><div class="rcc-av rcc-rs-av"></div></div>
        <div class="rcc-rs-title"></div><div class="rcc-rs-from"></div><div class="rcc-rs-stack"></div>
        <div class="rcc-rs-note"></div>
        <div class="rcc-rs-btns"><div class="rcc-rs-btn rcc-dec"><div>${g('phoneDown')}</div><span>Recusar</span></div><div class="rcc-rs-btn rcc-acc"><div>${g(view.video ? 'video' : 'phoneFill')}</div><span>Atender</span></div></div>
      </div>`);
      ui.querySelector('.rcc-rs-kind').textContent = kind;
      ui.querySelector('.rcc-rs-title').textContent = title;
      const ps = partsOf(view);
      ui.querySelector('.rcc-rs-from').textContent = from ? contactName(from) + ' está a ligar' : 'Chamada de grupo';
      paintAvatar(ui.querySelector('.rcc-rs-av'), { conversation: view.conversation, name: title });
      const stack = ui.querySelector('.rcc-rs-stack');
      ps.slice(0, 4).forEach(p => { const av = UI.el('<div class="rcc-av"></div>'); paintAvatar(av, { number: p.number, name: pName(p) }); stack.appendChild(av); });
      if (ps.length) stack.appendChild(UI.el(`<span>${ps.length === 1 ? '1 pessoa na chamada' : ps.length + ' pessoas na chamada'}</span>`));
      ui.querySelector('.rcc-rs-note').textContent = view.video ? 'Vídeo simulado: a voz é real, a imagem não é transmitida' : '';
      /* classes rcc-acc/rcc-dec: .acc e .dec já existem no apps.css e no shell.css (cartões e banner de chamada) */
      ui.querySelector('.rcc-acc').onclick = accept; ui.querySelector('.rcc-dec').onclick = decline;
      UI.screen().appendChild(ui); mine.ui = ui;
    };
    if (System.locked || !System.currentApp()) full();
    else {
      Island.set('call', { name: title, avatar: seedOf(title), status: kind, video: !!view.video, incoming: true, onAccept: accept, onDecline: decline, onEnd: decline,
        onOpen: () => { if (ringing !== mine) return; Island.clear('call'); full(); } });
      mine.ui = { remove: () => { if (!phoneBusy()) Island.clear('call'); } };
    }
    mine.timeout = setTimeout(() => { if (ringing === mine) stopRinging(); }, 34000);
  }

  /* ============================================================
     PUSHES
     ============================================================ */
  function onPush(d) {
    if (!d || typeof d !== 'object') return;
    const id = Math.floor(+d.callId) || 0;
    switch (d.event) {
      case 'ring': onRing(d); break;
      case 'joined':
        if (!d.call) break;
        if (active && (active.callId === id || active.pending)) { openCall(d.call, { keepMin: true }); break; }
        /* entrou e já tinha desistido de esperar (fechou o "a ligar…"): sai já */
        if (Date.now() < abandonUntil) { rpc('recado.call.leave', { callId: id }); break; }
        if (!active) openCall(d.call);
        break;
      case 'state': if (active && active.callId === id && d.call) applyView(d.call); break;
      case 'react': if (active && active.callId === id) floatReaction(d.emoji, d.from, false); break;
      case 'left': case 'ended':
        if (active && active.callId === id) closeCall(d.event === 'ended' ? 'ended' : (d.reason || 'left'));
        if (ringing && ringing.callId === id) stopRinging();
        refreshTabs(); break;
      case 'cancelled': if (ringing && ringing.callId === id) stopRinging(); refreshTabs(); break;
    }
  }

  /* ============================================================
     API: voice / video / joinLink / schedule
     ============================================================ */
  function normTarget(t) {
    if (!t) return null;
    if (typeof t === 'string' || typeof t === 'number') { const m = String(t).match(/^g:(\d+)$/); return m ? { conversation: +m[1] } : (cleanNum(t) ? { number: cleanNum(t) } : null); }
    if (typeof t !== 'object') return null;
    const conv = Math.floor(+(t.conversation || (t.group && t.group.id))) || 0;
    /* o RB manda { conversation, name } (nome do grupo no cabeçalho da conversa) */
    if (conv > 0) return { conversation: conv, title: typeof t.title === 'string' ? t.title : typeof t.name === 'string' ? t.name : (t.group && t.group.title) || null };
    const n = cleanNum(t.number); if (n && !/^g:/.test(n)) return { number: n };
    const m = String(t.number || '').match(/^g:(\d+)$/); return m ? { conversation: +m[1] } : null;
  }

  async function voice(target, opts = {}) {
    const t = normTarget(target); if (!t) return false;
    const vid = !!opts.video;
    if (t.number) {
      if (!window.PhoneApp || typeof PhoneApp.call !== 'function') { UI.toast('A app Telefone não está disponível'); return false; }
      if (phoneBusy()) { UI.toast('Já estás numa chamada'); return false; }
      if (active) { if (!await UI.confirm('Sair da chamada de grupo?', 'Para ligar a ' + contactName(t.number) + ' tens de sair da chamada de grupo.', 'Sair e ligar')) return false; await leave(); }
      /* assinatura real do phone.js: call(número, nome, { video }) */
      PhoneApp.call(t.number, contactName(t.number), { video: vid });
      return true;
    }
    if (t.conversation) return startGroup(t.conversation, vid, t.title);
    return false;
  }
  const video = target => voice(target, { video: true });

  async function startGroup(conv, vid, title) {
    if (phoneBusy()) { UI.toast(errText('incall')); return false; }
    if (active && !active.pending && active.view && +active.view.conversation === conv) { restore(); return true; }
    if (active) { if (!await UI.confirm('Sair da chamada atual?', 'Só podes estar numa chamada de cada vez.', 'Sair e ligar')) return false; await leave(); }
    if (ringing) stopRinging(true);
    if (!groupsMem) loadGroups();
    openPending({ title: title || groupTitle(conv) || 'Grupo', video: vid, conversation: conv });
    const pend = active;
    const r = await rpc('recado.call.start', { conversation: conv, video: vid });
    if (active !== pend) { if (r.ok && r.callId && !(active && active.callId === r.callId)) rpc('recado.call.leave', { callId: r.callId }); return false; }
    if (!r.ok) { closeCall('failed', true); UI.toast(errText(r.error)); return false; }
    openCall(r.call);
    if (vid) setCam(true);
    return true;
  }

  async function joinCode(code) {
    const c = cleanCode(code); if (!c) { UI.toast(errText('badcode')); return false; }
    if (phoneBusy()) { UI.toast(errText('incall')); return false; }
    if (active && !active.pending && active.view && cleanCode(active.view.code) === c) { restore(); return true; }
    if (active) { if (!await UI.confirm('Sair da chamada atual?', 'Só podes estar numa chamada de cada vez.', 'Sair e entrar')) return false; await leave(); }
    openPending({ title: 'A entrar…', video: false });
    const pend = active;
    const r = await rpc('recado.call.join', { code: c });
    if (active !== pend) { if (r.ok && r.callId && !(active && active.callId === r.callId)) rpc('recado.call.leave', { callId: r.callId }); return false; }
    if (!r.ok) { closeCall('failed', true); UI.toast(r.error === 'early' && +r.start ? 'A chamada abre às ' + UI.fmtTime(new Date(+r.start - 15 * 60000)) : errText(r.error)); return false; }
    if (r.phone) { closeCall('failed', true); return voice({ number: r.phone }, { video: !!r.video }); }
    openCall(r.call);
    if (r.call && r.call.video) setCam(true);
    return true;
  }
  async function joinById(id) {
    id = Math.floor(+id) || 0; if (!id) return false;
    if (active && active.callId === id) { restore(); return true; }
    if (phoneBusy()) { UI.toast(errText('incall')); return false; }
    if (active) { if (!await UI.confirm('Sair da chamada atual?', 'Só podes estar numa chamada de cada vez.', 'Sair e entrar')) return false; await leave(); }
    openPending({ title: 'A entrar…', video: false });
    const pend = active;
    const r = await rpc('recado.call.join', { callId: id });
    if (active !== pend) { if (r.ok && r.callId && !(active && active.callId === r.callId)) rpc('recado.call.leave', { callId: r.callId }); return false; }
    if (!r.ok) { closeCall('failed', true); UI.toast(errText(r.error)); return false; }
    openCall(r.call); return true;
  }

  function joinLink(win, code) {
    /* o RB passa o código ou, numa mensagem sem código, o callId em texto */
    if (code != null && /^\d{1,9}$/.test(String(code))) return joinById(code);
    if (code != null && code !== '') return joinCode(code);
    joinSheet(win); return Promise.resolve(false);
  }

  /* ---------- folhas: entrar com código, ligação criada, agendar ---------- */
  function joinSheet(win, prefill) {
    const body = UI.el(`<div class="rcc-sheet rcc-join">
      <div class="rcc-sh-ic">${g('keypad')}</div>
      <div class="rcc-sh-t">Entrar com código</div>
      <div class="rcc-sh-sub">Pede o código a quem criou a chamada. Tem 8 letras e números, por exemplo ABCD-EF12.</div>
      <input class="rcc-code-in" maxlength="14" autocomplete="off" spellcheck="false" placeholder="ABCD-EF12">
      <div class="rcc-sh-err"></div>
      <div class="rcc-btnp primary rcc-go">${g('phoneFill')}<span>Entrar na chamada</span></div>
    </div>`);
    const inp = body.querySelector('input'), err = body.querySelector('.rcc-sh-err');
    if (prefill) inp.value = fmtCode(prefill);
    inp.oninput = () => { const raw = inp.value.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 12); const v = raw.length > 4 && raw.length <= 8 ? raw.slice(0, 4) + '-' + raw.slice(4) : raw; if (inp.value !== v) inp.value = v; err.textContent = ''; };
    const sh = UI.sheet({ title: 'Código', right: 'Fechar', body });
    const go = async () => { const c = cleanCode(inp.value); if (!c) { err.textContent = errText('badcode'); return; } sh.close(); await joinCode(c); };
    body.querySelector('.rcc-go').onclick = go;
    inp.onkeydown = e => { if (e.key === 'Enter') go(); };
    setTimeout(() => { try { inp.focus(); } catch (e) {} }, 350);
    return sh;
  }

  async function createLink(win) {
    const r = await rpc('recado.call.link', { video: false });
    if (!r.ok || !r.link) { UI.toast(errText(r.error)); return null; }
    showLink(win, r.link, true); refreshTabs();
    return r.link;
  }
  function showLink(win, link, fresh) {
    const code = fmtCode(link.code);
    const body = UI.el(`<div class="rcc-sheet rcc-linksheet">
      <div class="rcc-sh-ic">${g('link')}</div>
      <div class="rcc-sh-t"></div>
      <div class="rcc-code"></div>
      <div class="rcc-sh-sub"></div>
      <div class="rcc-acts">
        <div class="rcc-btnp primary" data-a="join">${g('phoneFill')}<span>Entrar agora</span></div>
        <div class="rcc-btnp" data-a="copy">${g('copy')}<span>Copiar código</span></div>
        <div class="rcc-btnp" data-a="send">${g('send')}<span>Enviar a um contacto</span></div>
        <div class="rcc-btnp danger" data-a="revoke"><span>Revogar ligação</span></div>
      </div>
    </div>`);
    body.querySelector('.rcc-sh-t').textContent = fresh ? 'Ligação criada' : (link.title || 'Ligação de chamada');
    body.querySelector('.rcc-code').textContent = code;
    body.querySelector('.rcc-sh-sub').textContent = 'Quem tiver este código entra na chamada (menos quem bloqueaste). Válida até ' + fmtWhen(link.expires) + '.';
    const sh = UI.sheet({ title: 'Ligação de chamada', right: 'OK', body });
    body.querySelector('[data-a="join"]').onclick = () => { sh.close(); joinCode(link.code); };
    body.querySelector('[data-a="copy"]').onclick = () => copyText(code);
    body.querySelector('[data-a="send"]').onclick = async () => {
      const n = await pickContact(win, 'Enviar ligação a…'); if (!n) return;
      const r = await rpc('recado.send', { number: n, type: 'text', content: '📞 Entra na minha chamada do Zapp com o código ' + code });
      UI.toast(r.ok !== false ? 'Enviada a ' + contactName(n) : errText(r.error));
    };
    body.querySelector('[data-a="revoke"]').onclick = async () => {
      if (!await UI.confirm('Revogar ligação?', 'O código deixa de funcionar. Uma chamada a decorrer continua.', 'Revogar', true)) return;
      const r = await rpc('recado.call.revokeLink', { code: link.code });
      if (!r.ok) { UI.toast(errText(r.error)); return; }
      sh.close(); UI.toast('Ligação revogada'); refreshTabs();
    };
    return sh;
  }

  async function pickContact(win, title) {
    try {
      if (window.RecadoPeople && typeof RecadoPeople.pickContacts === 'function') { const l = arr(await RecadoPeople.pickContacts(win || (R() && R().win), { multi: false, max: 1 })); const n = cleanNum(l[0] && typeof l[0] === 'object' ? l[0].number : l[0]); return n || null; }
      if (window.Contacts) { const c = await Contacts.pick(title || 'Escolher contacto'); return c && cleanNum(c.number) ? cleanNum(c.number) : null; }
    } catch (e) {}
    return null;
  }
  async function pickGroup(win) {
    const list = await loadGroups(true);
    if (!list.length) { UI.alert({ title: 'Sem grupos', msg: 'Cria um grupo no Zapp para fazeres chamadas de grupo.' }); return null; }
    return new Promise(res => {
      const body = UI.el('<div class="rcc-sheet rcc-pick"></div>');
      const box = UI.el('<div class="rcc-card-list"></div>');
      list.forEach(gr => {
        const row = UI.el(`<div class="rcc-row"><div class="rcc-av rcc-row-av"></div><div class="rcc-row-b"><div class="rcc-row-n"></div><div class="rcc-row-s"></div></div><div class="rcc-row-go">${g('chevR')}</div></div>`);
        paintAvatar(row.querySelector('.rcc-av'), { conversation: gr.id, name: gr.title });
        row.querySelector('.rcc-row-n').textContent = gr.title;
        row.querySelector('.rcc-row-s').textContent = gr.members ? gr.members + ' membros' : 'Grupo';
        row.onclick = () => { res(gr); sh.close(); };
        box.appendChild(row);
      });
      body.appendChild(box);
      const sh = UI.sheet({ title: 'Escolher grupo', right: 'Cancelar', body, onClose: () => res(null) });
    });
  }

  async function schedule(win, target) {
    let t = normTarget(target);
    if (!t) {
      const how = await UI.actionSheet({ title: 'Agendar chamada', buttons: [{ label: 'Com um grupo', value: 'g', icon: 'users' }, { label: 'Com um contacto', value: 'c', icon: 'person' }] });
      if (how === 'g') { const gr = await pickGroup(win); if (!gr) return null; t = { conversation: gr.id, title: gr.title }; }
      else if (how === 'c') { const n = await pickContact(win, 'Agendar com…'); if (!n) return null; t = { number: n }; }
      else return null;
    }
    const targetName = t.conversation ? (t.title || groupTitle(t.conversation) || 'Grupo') : contactName(t.number);
    return new Promise(res => {
      const body = UI.el(`<div class="rcc-sheet rcc-schedform">
        <div class="rcc-sf-target"><div class="rcc-av"></div><div class="rcc-sf-tb"><b></b><span></span></div></div>
        <div class="rcc-lbl">Título</div>
        <input class="rcc-in" maxlength="60" placeholder="Ex.: Reunião da equipa">
        <div class="rcc-lbl">Tipo</div>
        <div class="rcc-segw"></div>
        <div class="rcc-lbl">Dia</div>
        <div class="rcc-days"></div>
        <div class="rcc-lbl">Hora</div>
        <div class="rcc-timepick"><div class="rcc-step" data-d="-15">−</div><div class="rcc-tv"></div><div class="rcc-step" data-d="15">+</div></div>
        <div class="rcc-sum"></div>
        <div class="rcc-sh-sub">Todos recebem um lembrete 10 minutos antes e outro à hora marcada, com o botão Entrar.</div>
      </div>`);
      paintAvatar(body.querySelector('.rcc-av'), t.conversation ? { conversation: t.conversation, name: targetName } : { number: t.number, name: targetName });
      body.querySelector('.rcc-sf-tb b').textContent = targetName;
      body.querySelector('.rcc-sf-tb span').textContent = t.conversation ? 'Chamada de grupo agendada' : 'Chamada agendada a dois (app Telefone)';
      let vid = false, day = 0;
      const nowD = new Date();
      /* hora por omissão: o próximo quarto de hora a pelo menos 30 min */
      let mins = Math.ceil((nowD.getHours() * 60 + nowD.getMinutes() + 30) / 15) * 15;
      if (mins >= 1440) { mins -= 1440; day = 1; }
      body.querySelector('.rcc-segw').appendChild(UI.seg(['Voz', 'Vídeo (simulado)'], 0, i => { vid = i === 1; paintSum(); }));
      const days = body.querySelector('.rcc-days');
      for (let i = 0; i < 14; i++) {
        const d = new Date(nowD); d.setDate(nowD.getDate() + i);
        const chip = UI.el(`<div class="rcc-day" data-i="${i}"><span></span><b></b></div>`);
        chip.querySelector('span').textContent = i === 0 ? 'Hoje' : i === 1 ? 'Amanhã' : UI.DIAS_C[d.getDay()];
        chip.querySelector('b').textContent = String(d.getDate());
        chip.onclick = () => { day = i; paintDays(); paintSum(); };
        days.appendChild(chip);
      }
      const inp = body.querySelector('.rcc-in');
      const startOf = () => { const d = new Date(nowD); d.setDate(nowD.getDate() + day); d.setHours(Math.floor(mins / 60), mins % 60, 0, 0); return d.getTime(); };
      const paintDays = () => [...days.children].forEach(c => c.classList.toggle('on', +c.dataset.i === day));
      const sum = body.querySelector('.rcc-sum');
      function paintSum() {
        body.querySelector('.rcc-tv').textContent = UI.fmtTime(new Date(startOf()));
        const s = startOf(), ok = s > Date.now() + 2 * 60000;
        sum.textContent = ok ? (vid ? 'Videochamada (simulada) · ' : 'Chamada de voz · ') + fmtWhen(s) : 'Escolhe uma hora no futuro';
        sum.classList.toggle('bad', !ok);
      }
      body.querySelectorAll('.rcc-step').forEach(b => { b.onclick = () => { mins = (mins + (+b.dataset.d) + 1440) % 1440; paintSum(); }; });
      paintDays(); paintSum();
      let busy = false, done = false;
      const sh = UI.sheet({ title: 'Agendar chamada', left: 'Cancelar', right: 'Agendar', body, onClose: () => { if (!done) res(null); },
        onDone: () => {
          if (busy) return false;
          const start = startOf(); if (start <= Date.now() + 2 * 60000) { UI.toast(errText('badstart')); return false; }
          busy = true;
          const payload = Object.assign({ start, title: inp.value.trim() || 'Chamada agendada', video: vid }, t.conversation ? { conversation: t.conversation } : { number: t.number });
          rpc('recado.call.schedule', payload).then(r => {
            busy = false;
            if (!r.ok) { UI.toast(errText(r.error)); return; }
            done = true; res(r.scheduled || null); sh.close(); UI.toast('Chamada agendada para ' + fmtWhen(start)); refreshTabs();
          });
          return false;
        } });
    });
  }

  async function scheduledSheet(win, s) {
    const buttons = [];
    const openAt = +s.start - 15 * 60000;
    if (Date.now() >= openAt || s.mine) buttons.push({ label: s.live ? 'Entrar (a decorrer)' : 'Entrar', value: 'join', icon: 'phone' });
    buttons.push({ label: 'Copiar código ' + fmtCode(s.code), value: 'copy', icon: 'copy' });
    if (s.mine) buttons.push({ label: 'Cancelar agendamento', value: 'cancel', icon: 'trash', danger: true });
    const v = await UI.actionSheet({ title: (s.title || 'Chamada agendada') + ' · ' + fmtWhen(s.start), buttons });
    if (v === 'join') joinCode(s.code);
    else if (v === 'copy') copyText(fmtCode(s.code));
    else if (v === 'cancel') {
      if (!await UI.confirm('Cancelar agendamento?', 'O código deixa de funcionar e ninguém recebe lembretes.', 'Cancelar agendamento', true)) return;
      const r = await rpc('recado.call.cancelScheduled', { id: s.id });
      if (!r.ok) { UI.toast(errText(r.error)); return; }
      UI.toast('Agendamento cancelado'); refreshTabs();
    }
  }

  /* ============================================================
     SEPARADOR "CHAMADAS"
     ============================================================ */
  function callsView(win) {
    const offs = [];
    let seen = false, dead = false;
    const cleanup = () => { if (dead) return; dead = true; tabs.delete(self); offs.forEach(f => { try { f(); } catch (e) {} }); };
    /* O onPop só corre ao trocar de separador / voltar. Matar a app com este separador à vista não o chama: sem esta
       verificação a vista ficava no `tabs` e com os ouvintes do Bridge vivos até ao fim da sessão (uma por cada abertura). */
    const gone = () => { if (dead) return true; if (v.isConnected) { seen = true; return false; } if (seen) { cleanup(); return true; } return false; };
    const self = { refresh: () => { if (!gone()) load(); } };
    const v = UI.view({ title: 'Chamadas', large: true, cls: 'rcc-view', right: [{ icon: 'plus', onTap: () => newCall(win) }], onPop: cleanup });
    const root = UI.el('<div class="rcc-tab"></div>'); v.content.appendChild(root);
    const st = { filter: 0, data: null, seq: 0 };
    tabs.add(self);

    async function load() {
      const my = ++st.seq;
      if (!st.data) { root.innerHTML = ''; root.appendChild(UI.skeleton('list', 5)); }
      const [h, s, l] = await Promise.all([rpc('recado.call.history'), rpc('recado.call.scheduled'), rpc('recado.call.links')]);
      if (my !== st.seq || dead) return;
      st.data = { history: h.ok !== false ? arr(h.items) : [], scheduled: s.ok !== false ? arr(s.items) : [], links: l.ok !== false ? arr(l.items) : [], error: h.ok === false ? h.error : null };
      paint();
      if (st.data.scheduled.some(x => x && x.conversation)) loadGroups().then(() => { if (my === st.seq) paint(); });
    }

    function header(text, extra) { const hd = UI.el(`<div class="rcc-h"><span></span></div>`); hd.firstChild.textContent = text; if (extra) hd.appendChild(extra); return hd; }

    function paint() {
      const d = st.data; if (!d) return;
      const top = v.content.scrollTop;
      root.innerHTML = '';
      /* chamada em curso minimizada */
      if (active && !active.pending && active.min) {
        const card = UI.el(`<div class="rcc-livecard"><div class="rcc-lc-ic">${g('phoneFill')}</div><div class="rcc-lc-b"><b></b><span></span></div><div class="rcc-lc-go">Voltar</div></div>`);
        card.querySelector('b').textContent = active.view.title || 'Chamada';
        card.querySelector('span').textContent = partsOf(active.view).length + ' na chamada · ' + UI.fmtDur((Date.now() - active.t0) / 1000);
        card.onclick = () => restore();
        root.appendChild(card);
      }
      const qa = UI.el(`<div class="rcc-quick">
        <div class="rcc-q" data-a="link"><div class="rcc-q-ic">${g('link')}</div><span>Criar ligação</span></div>
        <div class="rcc-q" data-a="code"><div class="rcc-q-ic">${g('keypad')}</div><span>Entrar com código</span></div>
        <div class="rcc-q" data-a="sched"><div class="rcc-q-ic">${g('calendar')}</div><span>Agendar</span></div>
      </div>`);
      qa.querySelector('[data-a="link"]').onclick = () => createLink(win);
      qa.querySelector('[data-a="code"]').onclick = () => joinSheet(win);
      qa.querySelector('[data-a="sched"]').onclick = () => schedule(win);
      root.appendChild(qa);

      if (d.scheduled.length) {
        root.appendChild(header('Agendadas'));
        const box = UI.el('<div class="rcc-card-list"></div>');
        d.scheduled.forEach(s => {
          const dt = new Date(+s.start || 0);
          const openAt = +s.start - 15 * 60000, canJoin = Date.now() >= openAt || s.mine;
          const row = UI.el(`<div class="rcc-sched"><div class="rcc-sd"><b></b><span></span></div><div class="rcc-row-b"><div class="rcc-row-n"></div><div class="rcc-row-s"><span></span></div></div><div class="rcc-sgo"></div></div>`);
          row.querySelector('.rcc-sd b').textContent = String(dt.getDate());
          row.querySelector('.rcc-sd span').textContent = UI.monthName ? UI.monthName(dt.getMonth(), true) : UI.MESES[dt.getMonth()].slice(0, 3);
          row.querySelector('.rcc-row-n').textContent = s.title || 'Chamada agendada';
          const who = s.conversation ? (groupTitle(s.conversation) || 'Grupo') : contactName(s.number);
          row.querySelector('.rcc-row-s span').textContent = UI.DIAS_C[dt.getDay()] + ' · ' + UI.fmtTime(dt) + ' · ' + who + (s.video ? ' · vídeo simulado' : '');
          const go = row.querySelector('.rcc-sgo');
          /* quem agendou pode abrir a chamada quando quiser ("Iniciar"); os convidados só 15 min antes ("Entrar") */
          const inWindow = Date.now() >= openAt;
          go.textContent = s.live ? 'A decorrer' : inWindow ? 'Entrar' : s.mine ? 'Iniciar' : fmtWhen(s.start).split(' · ')[0];
          go.classList.toggle('on', !!(s.live || canJoin));
          go.onclick = e => { e.stopPropagation(); if (s.live || canJoin) joinCode(s.code); else scheduledSheet(win, s); };
          row.onclick = () => scheduledSheet(win, s);
          box.appendChild(row);
        });
        root.appendChild(box);
      }

      if (d.links.length) {
        root.appendChild(header('As tuas ligações'));
        const box = UI.el('<div class="rcc-card-list"></div>');
        d.links.forEach(l => {
          const row = UI.el(`<div class="rcc-row"><div class="rcc-av rcc-row-av rcc-av-link">${g('link')}</div><div class="rcc-row-b"><div class="rcc-row-n rcc-mono"></div><div class="rcc-row-s"></div></div><div class="rcc-row-go">${g('chevR')}</div></div>`);
          row.querySelector('.rcc-row-n').textContent = fmtCode(l.code);
          row.querySelector('.rcc-row-s').textContent = l.live ? (l.count === 1 ? '1 pessoa na chamada agora' : (l.count || 0) + ' pessoas na chamada agora') : 'Válida até ' + fmtWhen(l.expires);
          row.classList.toggle('live', !!l.live);
          row.onclick = () => showLink(win, l, false);
          box.appendChild(row);
        });
        root.appendChild(box);
      }

      const seg = UI.seg(['Todas', 'Perdidas'], st.filter, i => { st.filter = i; paint(); });
      root.appendChild(header('Recentes', seg));
      const list = d.history.filter(h => h && (st.filter === 0 || h.status === 'missed'));
      root.classList.toggle('rcc-isempty', !list.length);   /* vazio: o aviso fica ao centro do espaco livre (app-recado-calls.css) */
      if (!list.length) {
        root.appendChild(UI.el(`<div class="rcc-empty"><div class="rcc-empty-ic">${g(st.filter ? 'phoneDown' : 'phone')}</div><b>${st.filter ? 'Sem chamadas perdidas' : 'Sem chamadas'}</b><span>${d.error ? esc(errText(d.error)) : 'As chamadas de voz, de vídeo e de grupo aparecem aqui.'}</span></div>`));
      } else {
        const box = UI.el('<div class="rcc-card-list"></div>');
        list.slice(0, 80).forEach(h => box.appendChild(historyRow(h)));
        root.appendChild(box);
      }
      root.appendChild(UI.el('<div class="rcc-foot">A voz das chamadas de grupo usa o sistema de voz do servidor. O vídeo é simulado (sem imagem real) e a partilha de ecrã não está disponível no FiveM.</div>'));
      v.content.scrollTop = top;
    }

    function historyRow(h) {
      const group = h.kind !== 'phone';
      const missed = h.status === 'missed';
      const name = group ? (h.title || (h.kind === 'link' ? 'Ligação de chamada' : 'Chamada de grupo')) : (h.number ? contactName(h.number) : (h.name || 'Desconhecido'));
      const row = UI.el(`<div class="rcc-row"><div class="rcc-av rcc-row-av"></div><div class="rcc-row-b"><div class="rcc-row-n"></div><div class="rcc-row-s"><i class="rcc-dir"></i><span></span></div></div><div class="rcc-row-t"></div><div class="rcc-again"></div></div>`);
      const av = row.querySelector('.rcc-av');
      if (h.kind === 'link') { av.classList.add('rcc-av-link'); av.innerHTML = g('link'); }
      else paintAvatar(av, group ? { conversation: h.conversation, name } : { number: h.number, name });
      if (group && h.kind !== 'link') av.appendChild(UI.el(`<i class="rcc-av-badge">${GL.group}</i>`));
      const n = row.querySelector('.rcc-row-n'); n.textContent = name; n.classList.toggle('miss', missed);
      const dir = row.querySelector('.rcc-dir'); dir.innerHTML = g(h.outgoing ? 'arrowUp' : 'arrowDown'); dir.classList.add(h.outgoing ? 'out' : 'in'); dir.classList.toggle('miss', missed);
      const who = group && arr(h.participants).length ? ' · com ' + arr(h.participants).slice(0, 2).map(contactName).join(', ') + (arr(h.participants).length > 2 ? ' +' + (arr(h.participants).length - 2) : '') : '';
      const st2 = STATUS[h.status] || (h.outgoing ? 'Efetuada' : 'Recebida');
      row.querySelector('.rcc-row-s span').textContent = st2 + ' · ' + (h.video ? 'vídeo' : 'voz') + (h.duration ? ' · ' + UI.fmtDur(h.duration) : '') + who;
      row.querySelector('.rcc-row-t').textContent = h.created ? UI.rel(h.created) : '';
      const again = row.querySelector('.rcc-again'); again.innerHTML = g(h.video ? 'video' : 'phone');
      const redo = () => {
        if (!group && h.number) voice({ number: h.number }, { video: !!h.video });
        else if (h.conversation) voice({ conversation: h.conversation, title: h.title }, { video: !!h.video });
        else UI.actionSheet({ title: 'Esta ligação já terminou', buttons: [{ label: 'Criar nova ligação', value: 'n', icon: 'link' }] }).then(x => { if (x === 'n') createLink(win); });
      };
      again.onclick = e => { e.stopPropagation(); redo(); };
      row.onclick = redo;
      if (!group && h.number && R() && typeof R().openChat === 'function') UI.longPress(row, () => UI.ctxMenu(row, [{ label: 'Enviar mensagem', icon: 'message', onTap: () => R().openChat({ number: h.number }) }, { label: 'Videochamada (simulada)', icon: 'video', onTap: () => video({ number: h.number }) }]));
      return row;
    }

    offs.push(Bridge.on('contacts', () => { if (st.data && !gone()) paint(); }));
    offs.push(Bridge.on('recado:call', () => { if (st.data && !gone()) paint(); }));
    load();
    return v;
  }

  async function newCall(win) {
    const v = await UI.actionSheet({ title: 'Nova chamada', buttons: [
      { label: 'Chamada de voz', value: 'voice', icon: 'phone' }, { label: 'Videochamada (simulada)', value: 'video', icon: 'video' },
      { label: 'Chamada de grupo', value: 'group', icon: 'users' }, { label: 'Criar ligação de chamada', value: 'link', icon: 'link' },
      { label: 'Entrar com código', value: 'code', icon: 'keypad' }, { label: 'Agendar chamada', value: 'sched', icon: 'calendar' }] });
    if (v === 'voice' || v === 'video') { const n = await pickContact(win, v === 'video' ? 'Videochamada com…' : 'Ligar a…'); if (n) voice({ number: n }, { video: v === 'video' }); }
    else if (v === 'group') { const gr = await pickGroup(win); if (!gr) return; const how = await UI.actionSheet({ title: gr.title, buttons: [{ label: 'Chamada de voz', value: 'a', icon: 'phone' }, { label: 'Videochamada (simulada)', value: 'v', icon: 'video' }] }); if (how) startGroup(gr.id, how === 'v', gr.title); }
    else if (v === 'link') createLink(win);
    else if (v === 'code') joinSheet(win);
    else if (v === 'sched') schedule(win);
  }

  /* ============================================================
     BOLHA DAS MENSAGENS `call` (para o RB: RecadoCalls.renderMessage(msg, bubbleEl) → true se tratou)
     payload { callId?, code?, video, status: 'active' | 'ended' | 'scheduled', duration? (s), scheduled?, start?, title? } - vem do servidor
     ============================================================ */
  function renderMessage(msg, host) {
    if (!msg || msg.type !== 'call' || !host) return false;
    const p = msg.payload && typeof msg.payload === 'object' ? msg.payload : {};
    const vid = p.video === true, sched = p.scheduled === true || p.status === 'scheduled', ended = p.status === 'ended';
    const code = cleanCode(p.code), callId = Math.floor(+p.callId) || 0, start = +p.start || 0;
    const el = UI.el(`<div class="rcc-msg${sched ? ' sched' : ''}${ended ? ' ended' : ''}"><div class="rcc-msg-ic">${g(sched ? 'calendar' : (vid ? 'video' : 'phoneFill'))}</div><div class="rcc-msg-b"><b></b><span></span></div><div class="rcc-msg-go">Entrar</div></div>`);
    el.querySelector('b').textContent = sched ? String(p.title || msg.content || 'Chamada agendada').slice(0, 60) : (vid ? 'Videochamada de grupo' : 'Chamada de voz de grupo');
    const created = +msg.created || Date.now();
    el.querySelector('span').textContent = sched ? fmtWhen(start) + (vid ? ' · vídeo simulado' : '')
      : ended ? 'Terminada' + (+p.duration > 0 ? ' · ' + UI.fmtDur(+p.duration) : '') : 'A decorrer · desde as ' + UI.fmtTime(new Date(created)) + (vid ? ' · vídeo simulado' : '');
    const go = el.querySelector('.rcc-msg-go');
    /* "Entrar" numa agendada só na janela em que o servidor deixa entrar (15 min antes até 6 h depois - antes disso
       o botão dava sempre "ainda é cedo"; quem agendou inicia-a mais cedo no separador Chamadas), ou numa chamada a
       decorrer começada há menos de 12 h */
    const usable = sched ? (!!code && Date.now() >= start - 15 * 60000 && Date.now() < start + 6 * 3600000) : (!ended && (!!code || callId > 0) && Date.now() - created < 12 * 3600000);
    if (!usable) go.remove();
    else go.onclick = e => { e.stopPropagation(); if (code) joinCode(code); else joinById(callId); };
    host.appendChild(el);
    return true;
  }

  /* ============================================================
     LIGAÇÕES AO RESTO DO TELEMÓVEL
     ============================================================ */
  Bridge.on('recadoCall', onPush);
  Bridge.on('recadoCallTalking', onTalking);
  Bridge.on('recadoCallVoice', d => { if (active && d && Math.floor(+d.callId) === active.callId && d.ok === false) UI.toast('A voz não ligou: já estás noutra chamada'); });
  /* atendeu uma chamada do Telefone: o servidor tira-o do grupo (e o cliente troca a voz); a UI fecha já */
  /* O leave vai também daqui: o servidor só tira o jogador pelo par do apex_phone:callStarted, e se esse evento se
     perdeu (recurso reiniciado a meio) ficava um participante-fantasma no grupo com a voz já na 1:1. Idempotente. */
  Bridge.on('call:active', () => { if (active) { const id = active.callId; closeCall('phonecall', true); if (id) rpc('recado.call.leave', { callId: id }); } if (ringing) stopRinging(true); });
  /* a chamada do Telefone acabou e a de grupo estava na ilha: a ilha volta a ser a do grupo */
  Bridge.on('call:end', () => { setTimeout(() => { if (active && active.min && !active.pip) setIsland(); }, 950); });
  /* troca de personagem: o servidor também a trata (FW.OnPlayerDropped), o leave daqui cobre frameworks sem esse evento */
  Bridge.on('session:changed', () => { if (active) { const id = active.callId; closeCall('switch', true); if (id) rpc('recado.call.leave', { callId: id }); } stopRinging(); groupsMem = null; });
  /* notificações do servidor (convite perdido, lembrete de agendada): o botão "Entrar" e tocar no cartão */
  const fromNotif = rc => { if (!rc || typeof rc !== 'object') return; const code = cleanCode(rc.code), id = Math.floor(+rc.callId) || 0; if (active && id && active.callId === id) { restore(); return; } if (code) joinCode(code); else if (id) joinById(id); };
  Bridge.on('notif:action', d => { if (d && d.action === 'recado_call_join' && d.data && d.data.recadoCall) fromNotif(d.data.recadoCall); });
  Bridge.on('notif:open', n => { if (!n || n.app !== 'recado' || !n.data || !n.data.recadoCall) return; const rc = n.data.recadoCall;
    setTimeout(() => { UI.confirm('Entrar na chamada?', rc.scheduled ? 'Chamada agendada do Zapp.' : 'Chamada de grupo do Zapp.', 'Entrar').then(ok => { if (ok) fromNotif(rc); }); }, 500); });
  /* phone://recado/call/ABCD-EF12 */
  if (window.System && typeof System.route === 'function') System.route('recado', d => { if (d && d.parts && d.parts[0] === 'call') { if (d.parts[1]) joinCode(d.parts[1]); else joinSheet(R() && R().win); } });
  /* NUI recarregada a meio de uma chamada (reposição, restart do telemóvel): o servidor ainda nos tem lá */
  Bridge.on('ready', () => setTimeout(async () => {
    if (active || ringing) return;
    const r = await rpc('recado.call.state', {});
    if (!r.ok || active || ringing) return;
    if (r.call && r.call.callId) openCall(r.call, { min: true });
    else { const first = arr(r.ringing)[0]; if (first && first.callId) onRing({ callId: first.callId, from: first.from, call: first.call, event: 'ring' }); }
  }, 2500));

  const api = {
    callsView, voice, video, joinLink, schedule, renderMessage,
    active: () => active && !active.pending ? { callId: active.callId, title: active.view.title, conversation: active.view.conversation || null, minimized: !!active.min, participants: partsOf(active.view).length } : null,
    /* extras usados pelo separador e por outros módulos (aditivos ao contrato) */
    createLink, restore, leave, joinSheet
  };

  /* O recado.js (RA) carrega DEPOIS deste ficheiro: regista-se assim que window.Recado existir */
  let registered = false;
  function register() {
    if (registered) return true;
    const r = R(); if (!r || typeof r.register !== 'function') return false;
    registered = true;
    try { r.register('calls', api); } catch (e) { console.error('[recado-calls] register', e); }
    try { if (typeof r.registerTab === 'function') r.registerTab('calls', { icon: 'phone', label: 'Chamadas', order: 30, view: win => callsView(win) }); } catch (e) { console.error('[recado-calls] registerTab', e); }
    return true;
  }
  if (!register()) {
    document.addEventListener('DOMContentLoaded', register);
    let n = 0; const t = setInterval(() => { if (register() || ++n > 240) clearInterval(t); }, 50);
  }
  return api;
})();

/* ============================================================
   MOCKS DO BROWSER (LocalDB) - os mesmos RPCs e pushes do server/recado_calls.lua, com participantes
   fictícios a entrar e a "falar" à vez (o push recadoCallTalking que no jogo vem do client/recado_calls.lua).
   Tabelas: recado_call_history, recado_call_scheduled, recado_call_links. Os grupos são os das tabelas
   conversations / conversation_members (as mesmas dos mocks do groups.js e messages.js).
   RecadoCalls._mock.ring({ title, video, conversation? }) simula um convite a tocar (capturas e testes).
   ============================================================ */
if (window.LocalDB && LocalDB.register) (() => {
  const T = LocalDB.T;
  const ME = 1, MAXP = 8;
  const now = () => Date.now();
  const fail = (error, extra) => Object.assign({ ok: false, error }, extra || {});
  const my = () => String((LocalDB.me() || {}).number || '555-0142');
  const cid = () => String(LocalDB.cid || 'DEV0000');
  const emit = (ev, d) => setTimeout(() => Bridge.emit(ev, JSON.parse(JSON.stringify(d))), 0);
  const REACTS = ['❤️', '👍', '😂', '😮', '😢', '🙏', '👏', '🎉', '🔥', '👋'];
  const ALPHA = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  const code8 = () => Array.from({ length: 8 }, () => ALPHA[Math.floor(Math.random() * ALPHA.length)]).join('');
  const FAKES = [['555-0303', 'Rui Taxista'], ['555-0420', 'Ana Advogada'], ['555-0101', 'Mãe'], ['555-0177', 'Garagem Central']];
  const calls = {}; let seq = 0; let reactAt = 0;
  const int = v => { const n = Math.floor(+v); return n > 0 ? n : 0; };
  const memberOf = (conv, who) => T('conversation_members').all().some(m => +m.conversation_id === conv && m.member === who && !m.left_at);
  const membersOf = conv => T('conversation_members').all().filter(m => +m.conversation_id === conv && !m.left_at).map(m => m.member);
  const convOf = conv => T('conversations').all().find(c => +c.id === conv) || null;
  /* como o servidor: só grupos do Recado; "só administradores" (send_policy do RC) também vale para começar/agendar */
  const recadoGroup = conv => { const cv = convOf(conv); return !!cv && (!cv.app || cv.app === 'recado'); };
  const canBroadcast = conv => { const cv = convOf(conv); if (!cv || cv.send_policy !== 'admins') return true; return T('conversation_members').all().some(m => +m.conversation_id === conv && m.member === my() && !m.left_at && m.role === 'admin'); };
  const isContact = n => T('contacts').all().some(c => c.number === n);
  const nameOf = n => (T('contacts').all().find(c => c.number === n) || {}).name || null;
  const cleanCode = v => { if (typeof v !== 'string') return null; const m = v.slice(0, 80).match(/([A-Za-z0-9-]+)\s*$/); if (!m) return null; const s = m[1].replace(/-/g, '').toUpperCase(); return /^[A-Z0-9]{6,12}$/.test(s) ? s : null; };
  const cleanTitle = (v, max) => { if (typeof v !== 'string' && typeof v !== 'number') return null; const s = [...String(v).slice(0, 400).replace(/\p{Cc}/gu, ' ').replace(/\p{Cf}/gu, '').replace(/\s+/g, ' ').trim()].slice(0, max).join('').trim(); return s || null; };
  const cleanNumber = v => { if (typeof v === 'number') v = String(Math.floor(v)); if (typeof v !== 'string') return null; const s = v.trim(); return s && s.length <= 20 && /^[\w+\-\s#*.()]+$/.test(s) ? s : null; };

  /* a vista do servidor: número só de quem já se conhece (membro do mesmo grupo ou contacto) */
  function view(c, forRing) {
    const members = c.conversation ? membersOf(c.conversation) : [];
    const mine = members.includes(my());
    const ps = c.order.map(s => c.parts[s]).filter(Boolean).map(p => {
      const known = p.src === ME || (mine && members.includes(p.number)) || isContact(p.number);
      const o = { src: p.src, muted: p.muted, video: p.video, hand: p.hand, isMe: p.src === ME };
      if (known) o.number = p.number; else { if (p.alias) o.name = p.alias; o.label = 'Participante ' + p.seq; }
      return o;
    });
    const v = { callId: c.id, code: c.code, kind: c.kind, title: c.title, video: c.video, startedAt: c.startedAt, elapsed: now() - c.startedAt, max: MAXP, me: ME,
      canEnd: c.creator === cid(), screenShare: false, videoProvider: 'simulated', reactions: REACTS, participants: ps,
      ringing: Object.keys(c.ringing).map(n => (isContact(n) || (mine && members.includes(n))) ? { number: n } : { label: 'Convidado' }) };
    if (c.conversation && mine) v.conversation = c.conversation;   /* como o servidor: o id do grupo só a membros */
    return v;
  }
  const push = (c, event, extra) => { if (c.parts[ME]) emit('recadoCall', Object.assign({ callId: c.id, event: event || 'state', call: view(c) }, extra || {})); };
  const stopSim = c => { (c.timers || []).forEach(t => { clearTimeout(t); clearInterval(t); }); c.timers = []; };
  const hist = (c, status, dir, dur, at) => T('recado_call_history').insert({ owner: cid(), call_id: c.id, kind: c.kind, conversation: c.conversation || null, title: c.title, video: !!c.video, direction: dir, status,
    participants: c.order.map(s => c.parts[s]).filter(p => p && p.src !== ME && isContact(p.number)).map(p => p.number).slice(0, 8), duration: Math.max(0, Math.floor(dur || 0)), created: at || now() });
  function newCall(o) { const id = ++seq; const c = Object.assign({ id, code: code8(), parts: {}, order: [], ringing: {}, seq: 0, startedAt: now(), timers: [], video: false }, o); calls[id] = c; return c; }
  function finish(c, reason, event) {
    if (c.ended) return; c.ended = true; stopSim(c); delete calls[c.id];
    const me = c.parts[ME];
    if (me) { hist(c, 'answered', me.dir, (now() - me.joinedAt) / 1000, me.joinedAt); emit('recadoCall', { callId: c.id, event: event || 'ended', reason }); }
    if (c.ringing[my()]) emit('recadoCall', { callId: c.id, event: 'cancelled', reason });
    /* como o finishMessage do servidor: a mensagem do chat passa a "Terminada · duração" */
    if (c.msgId) {
      const rows = T('messages').all(), row = rows.find(x => x.id === c.msgId && x.type === 'call');
      if (row) { row.payload = Object.assign({}, row.payload || {}, { status: 'ended', duration: Math.max(0, Math.floor((now() - c.startedAt) / 1000)) }); T('messages').set(rows); }
      emit('recadoCall', { callId: c.id, event: 'ended', status: 'ended', reason });
    }
  }
  function addFake(c, number, alias) {
    if (c.ended || Object.keys(c.parts).length >= MAXP || Object.values(c.parts).some(p => p.number === number)) return;
    const src = 100 + (++c.seq);
    c.parts[src] = { src, number, alias: alias || null, muted: false, video: false, hand: 0, joinedAt: now(), seq: c.seq, dir: 'in' };
    c.order.push(src); delete c.ringing[number]; push(c);
  }
  /* participantes a entrar, a falar à vez, uma reação, uma mão levantada e uma câmara "ligada" */
  function simulate(c, pool) {
    pool.slice(0, 3).forEach(([n, nm], i) => c.timers.push(setTimeout(() => addFake(c, n, nm), 900 + i * 1200)));
    let k = 0;
    c.timers.push(setInterval(() => {
      if (c.ended) return;
      const others = c.order.filter(s => s !== ME && c.parts[s] && !c.parts[s].muted), talk = [];
      if (others.length) talk.push(others[k % others.length]);
      if (k % 5 === 4 && c.parts[ME] && !c.parts[ME].muted) talk.push(ME);
      k++; emit('recadoCallTalking', { callId: c.id, talking: talk });
    }, 1100));
    c.timers.push(setTimeout(() => { const s = c.order.find(x => x !== ME); if (s && c.parts[ME]) emit('recadoCall', { callId: c.id, event: 'react', from: s, emoji: '👋' }); }, 5000));
    c.timers.push(setTimeout(() => { const s = c.order.filter(x => x !== ME)[0]; if (s && c.parts[s]) { c.parts[s].video = true; push(c); } }, 3600));
    c.timers.push(setTimeout(() => { const s = c.order.filter(x => x !== ME)[1]; if (s && c.parts[s]) { c.parts[s].hand = now(); push(c); } }, 6500));
  }
  function joinMe(c, dir) {
    if (c.parts[ME]) return { ok: true, callId: c.id, code: c.code, call: view(c) };
    if (Object.keys(c.parts).length >= MAXP) return fail('full');
    c.seq++; c.parts[ME] = { src: ME, number: my(), muted: false, video: false, hand: 0, joinedAt: now(), seq: c.seq, dir: dir || 'in' };
    c.order.push(ME); delete c.ringing[my()];
    emit('recadoCall', { callId: c.id, event: 'joined', voiceId: 900000 + c.id, channel: 950000 + c.id, call: view(c) });
    return { ok: true, callId: c.id, code: c.code, call: view(c) };
  }
  const inCall = () => Object.values(calls).find(c => c.parts[ME]) || null;
  const byCode = code => Object.values(calls).find(c => c.code === code) || null;
  const own = (d, needParticipant) => { const c = calls[int(d.callId)]; if (!c || (needParticipant && !c.parts[ME])) return null; return c; };
  /* mensagem `call` no chat: recado.send do RA; sem ele, messages.send com app 'recado' */
  function postMsg(target, content, payload) {
    const d = Object.assign({ type: 'call', content, payload }, target.conversation ? { conversation: target.conversation } : { number: target.number, to: target.number });
    let r = null; try { r = LocalDB.rpc('recado.send', d); } catch (e) { r = null; }
    if (!r || r.error || r.ok === false) { try { r = LocalDB.rpc('messages.send', Object.assign({ app: 'recado' }, d)); } catch (e) { r = null; } }
    return r && !r.error ? r : null;
  }

  LocalDB.register('recado.call.start', d => {
    const conv = int(d.conversation); if (!conv) return fail('invalid');
    if (!memberOf(conv, my()) || !recadoGroup(conv)) return fail('notfound');
    const ex = Object.values(calls).find(c => c.conversation === conv && c.kind !== 'link') || null;
    const cur = inCall(); if (cur) return cur === ex ? joinMe(ex) : fail('busy');
    if (ex) return joinMe(ex, 'in');
    if (!canBroadcast(conv)) return fail('adminsonly');
    const cv = convOf(conv);
    const c = newCall({ kind: 'group', conversation: conv, title: (cv && cv.title) || 'Grupo', video: d.video === true, creator: cid() });
    const others = membersOf(conv).filter(n => n !== my());
    others.slice(0, MAXP - 1).forEach(n => { c.ringing[n] = { since: now() }; });
    const r = joinMe(c, 'out');
    const pool = others.map(n => [n, null]);
    simulate(c, pool.length ? pool : FAKES);
    c.timers.push(setTimeout(() => { if (Object.keys(c.ringing).length) { c.ringing = {}; push(c); } }, 6000));
    const m = postMsg({ conversation: conv }, c.video ? 'Videochamada de grupo' : 'Chamada de voz de grupo', { callId: c.id, code: c.code, video: c.video, status: 'active', startedAt: c.startedAt });
    if (m && m.id) c.msgId = m.id;
    return r;
  });

  LocalDB.register('recado.call.join', d => {
    let c = null;
    /* ocupado ANTES de materializar (como o servidor): senão ficava uma chamada vazia com participantes simulados */
    const busyIn = inCall();
    if (busyIn) return (d.callId != null && int(d.callId) === busyIn.id) || (d.code != null && cleanCode(d.code) === busyIn.code) ? joinMe(busyIn) : fail('busy');
    if (d.callId != null) {
      c = calls[int(d.callId)]; if (!c) return fail('notfound');
      /* como o servidor: uma ligação aberta só com o código (o callId é sequencial) */
      if (!c.parts[ME] && !c.ringing[my()] && !(c.conversation && memberOf(c.conversation, my()))) return fail('notfound');
    } else if (d.code != null) {
      const code = cleanCode(d.code); if (!code) return fail('badcode');
      c = byCode(code);
      if (!c) {
        const link = T('recado_call_links').all().find(l => l.code === code);
        if (link) {
          if (link.revoked) return fail('notfound'); if (link.expires < now()) return fail('expired');
          c = newCall({ kind: 'link', code, title: link.title, video: !!link.video, creator: link.owner, open: true });
          simulate(c, FAKES.slice(0, 2));
        } else {
          const s = T('recado_call_scheduled').all().find(x => x.code === code && !x.cancelled);
          if (!s) return fail('notfound');
          const mine = s.owner === cid();
          if (s.conversation) { if (!mine && !memberOf(+s.conversation, my())) return fail('notfound'); }
          else if (!mine && s.number !== my()) return fail('notfound');
          if (now() > s.start + 6 * 3600000) return fail('expired');
          if (now() < s.start - 15 * 60000 && !mine) return fail('early', { start: s.start });
          if (!s.conversation) return { ok: true, phone: mine ? s.number : s.owner_number, video: !!s.video };
          c = newCall({ kind: 'scheduled', conversation: +s.conversation, code, title: s.title, video: !!s.video, creator: s.owner });
          const pool = membersOf(+s.conversation).filter(n => n !== my()).map(n => [n, null]);
          simulate(c, pool.length ? pool : FAKES.slice(0, 2));
        }
      }
    } else return fail('invalid');
    const cur = inCall(); if (cur && cur !== c) return fail('busy');
    return joinMe(c, c.kind !== 'group' && c.creator === cid() ? 'out' : 'in');
  });

  LocalDB.register('recado.call.leave', d => {
    const c = own(d, true); if (!c) return fail('notfound');
    /* no browser não há mais ninguém a sério: sair acaba a chamada (com o histórico e o push 'left', como no servidor) */
    finish(c, 'left', 'left'); return { ok: true };
  });
  LocalDB.register('recado.call.decline', d => {
    const c = own(d); if (!c || !c.ringing[my()]) return fail('notfound');
    delete c.ringing[my()]; hist(c, d.busy ? 'missed' : 'declined', 'in', 0); stopSim(c); c.ended = true; delete calls[c.id];
    emit('recadoCall', { callId: c.id, event: 'cancelled', reason: 'declined' });
    return { ok: true };
  });
  LocalDB.register('recado.call.end', d => {
    const c = own(d); if (!c) return fail('notfound');
    if (!c.parts[ME] && !(c.conversation && memberOf(c.conversation, my()))) return fail('notfound');
    if (c.creator !== cid()) return fail('notallowed');
    finish(c, 'ended'); return { ok: true };
  });
  LocalDB.register('recado.call.state', d => {
    const out = { ok: true, ringing: [] };
    if (d.callId != null) {
      const c = own(d); if (!c) return fail('notfound');
      if (c.parts[ME]) out.call = view(c);
      else if (c.ringing[my()] || (c.conversation && memberOf(c.conversation, my()))) out.call = Object.assign(view(c, true), { joinable: true });
      else return fail('notfound');
    } else { const c = inCall(); if (c) out.call = view(c); }
    Object.values(calls).forEach(c => { if (c.ringing[my()] && !c.parts[ME]) out.ringing.push({ callId: c.id, from: c.ringing[my()].by || null, call: view(c, true) }); });
    return out;
  });
  const setMine = (field, value) => d => { const c = own(d, true); if (!c) return fail('notfound'); const v = value(d); if (c.parts[ME][field] !== v) { c.parts[ME][field] = v; push(c); } return { ok: true }; };
  LocalDB.register('recado.call.mute', setMine('muted', d => d.on === true));
  LocalDB.register('recado.call.video', setMine('video', d => d.on === true));
  LocalDB.register('recado.call.hand', setMine('hand', d => (d.on === true ? now() : 0)));
  LocalDB.register('recado.call.react', d => {
    const c = own(d, true); if (!c) return fail('notfound');
    if (!REACTS.includes(d.emoji)) return fail('badreaction');
    if (now() - reactAt < 600) return fail('cooldown'); reactAt = now();
    /* alguém responde de volta com a mesma reação, às vezes */
    const s = c.order.find(x => x !== ME); if (s && Math.random() < .5) c.timers.push(setTimeout(() => { if (!c.ended) emit('recadoCall', { callId: c.id, event: 'react', from: s, emoji: d.emoji }); }, 900));
    return { ok: true };
  });
  LocalDB.register('recado.call.invite', d => {
    const c = own(d, true); if (!c) return fail('notfound');
    const raw = d.numbers == null && d.number != null ? [d.number] : d.numbers; if (!Array.isArray(raw) || !raw.length) return fail('invalid');
    const results = {};
    for (const x of raw.slice(0, MAXP)) {
      const n = cleanNumber(x); if (!n) return fail('invalid');
      if (n === my() || Object.values(c.parts).some(p => p.number === n) || c.ringing[n]) { results[n] = 'already'; continue; }
      if (Object.keys(c.parts).length + Object.keys(c.ringing).length >= MAXP) { results[n] = 'full'; continue; }
      c.ringing[n] = { since: now(), by: my() }; results[n] = 'ringing';
      c.timers.push(setTimeout(() => addFake(c, n, nameOf(n)), 2600));
    }
    push(c); return { ok: true, results };
  });

  LocalDB.register('recado.call.link', d => {
    const title = d.title != null ? cleanTitle(d.title, 60) : 'Chamada Zapp'; if (!title) return fail('badtitle');
    if (T('recado_call_links').all().filter(l => l.owner === cid() && !l.revoked && l.expires > now()).length >= 10) return fail('limit', { max: 10 });
    const t = now(), code = code8();
    T('recado_call_links').insert({ code, owner: cid(), owner_number: my(), title, video: d.video === true, revoked: 0, created: t, expires: t + 7 * 864e5 });
    return { ok: true, link: { code, title, video: d.video === true, created: t, expires: t + 7 * 864e5 } };
  });
  LocalDB.register('recado.call.links', () => ({ ok: true, items: T('recado_call_links').all().filter(l => l.owner === cid() && !l.revoked && l.expires > now()).sort((a, b) => b.created - a.created).slice(0, 10)
    .map(l => { const c = byCode(l.code); return { code: l.code, title: l.title, video: !!l.video, created: l.created, expires: l.expires, live: !!c, count: c ? Object.keys(c.parts).length : 0 }; }) }));
  LocalDB.register('recado.call.revokeLink', d => {
    const code = cleanCode(d.code); if (!code) return fail('badcode');
    const rows = T('recado_call_links').all(), l = rows.find(x => x.code === code && x.owner === cid()); if (!l) return fail('notfound');
    l.revoked = 1; T('recado_call_links').set(rows); const c = byCode(code); if (c) c.open = false; return { ok: true };
  });

  const schedView = s => ({ id: s.id, code: s.code, title: s.title, video: !!s.video, start: s.start, conversation: s.conversation || undefined,
    number: s.conversation ? undefined : (s.owner_number === my() ? s.number : s.owner_number), mine: s.owner === cid(), live: !!byCode(s.code) });
  LocalDB.register('recado.call.schedule', d => {
    const t = now(), start = Math.floor(+d.start) || 0;
    if (start < t + 60000 || start > t + 30 * 864e5) return fail('badstart', { maxDays: 30 });
    const title = d.title != null && d.title !== '' ? cleanTitle(d.title, 60) : 'Chamada agendada'; if (!title) return fail('badtitle');
    let conv = null, number = null;
    if (d.conversation != null) { conv = int(d.conversation); if (!conv) return fail('invalid'); if (!memberOf(conv, my()) || !recadoGroup(conv)) return fail('notfound'); if (!canBroadcast(conv)) return fail('adminsonly'); }
    else { number = cleanNumber(d.number); if (!number || number === my()) return fail('invalid'); }
    if (T('recado_call_scheduled').all().filter(s => s.owner === cid() && !s.cancelled && s.start > t).length >= 20) return fail('limit', { max: 20 });
    const row = T('recado_call_scheduled').insert({ code: code8(), owner: cid(), owner_number: my(), conversation: conv, number, title, video: d.video === true, start, reminded: 0, cancelled: 0, created: t });
    const msg = postMsg(conv ? { conversation: conv } : { number }, title, { scheduled: true, code: row.code, start, title, video: d.video === true, status: 'scheduled' });
    return { ok: true, scheduled: schedView(row), message: msg || undefined };
  });
  LocalDB.register('recado.call.scheduled', () => ({ ok: true, items: T('recado_call_scheduled').all()
    .filter(s => !s.cancelled && s.start > now() - 6 * 3600000 && (s.owner === cid() || s.number === my() || (s.conversation && memberOf(+s.conversation, my()))))
    .sort((a, b) => a.start - b.start).slice(0, 50).map(schedView) }));
  LocalDB.register('recado.call.cancelScheduled', d => {
    const id = int(d.id); if (!id) return fail('invalid');
    const rows = T('recado_call_scheduled').all(), s = rows.find(x => +x.id === id && x.owner === cid() && !x.cancelled); if (!s) return fail('notfound');
    s.cancelled = 1; T('recado_call_scheduled').set(rows); return { ok: true };
  });
  LocalDB.register('recado.call.history', () => {
    const items = T('recado_call_history').all().filter(h => h.owner === cid()).map(h => ({ id: 'r' + h.id, kind: h.kind, callId: h.call_id, conversation: h.conversation || undefined, title: h.title, video: !!h.video,
      outgoing: h.direction === 'out', status: h.status, duration: h.duration || 0, created: h.created, participants: Array.isArray(h.participants) && h.participants.length ? h.participants : undefined }));
    let phone = []; try { phone = LocalDB.rpc('calls.history', {}); } catch (e) { phone = []; }
    (Array.isArray(phone) ? phone : []).forEach(r => items.push({ id: 'p' + r.id, kind: 'phone', number: r.number, name: r.name, video: !!r.video, outgoing: !!r.outgoing,
      status: r.status || (r.answered ? 'answered' : (r.outgoing ? 'cancelled' : 'missed')), duration: r.duration || 0, created: r.created }));
    return { ok: true, items: items.sort((a, b) => (b.created || 0) - (a.created || 0)).slice(0, 100) };
  });
  LocalDB.register('recado.call.clearHistory', () => { T('recado_call_history').remove(h => h.owner === cid()); return { ok: true }; });

  /* convite a tocar (capturas/testes): uma chamada com gente lá dentro que me chama */
  RecadoCalls._mock = {
    ring(o = {}) {
      const conv = int(o.conversation);
      const c = newCall({ kind: 'group', conversation: conv || null, title: o.title || (conv && convOf(conv) && convOf(conv).title) || 'Equipa do Cais', video: o.video === true, creator: 'NPC' });
      const pool = conv ? membersOf(conv).filter(n => n !== my()).map(n => [n, null]) : FAKES;
      pool.slice(0, 3).forEach(([n, nm]) => { c.seq++; const src = 100 + c.seq; c.parts[src] = { src, number: n, alias: nm, muted: false, video: false, hand: 0, joinedAt: now(), seq: c.seq, dir: 'in' }; c.order.push(src); });
      const from = (pool[0] || [])[0] || '555-0303';
      c.ringing[my()] = { since: now(), by: from };
      simulate(c, []);
      emit('recadoCall', { callId: c.id, event: 'ring', from, call: view(c, true) });
      c.timers.push(setTimeout(() => { if (c.ringing[my()] && !c.parts[ME]) { delete c.ringing[my()]; hist(c, 'missed', 'in', 0); emit('recadoCall', { callId: c.id, event: 'cancelled', reason: 'timeout' }); finish(c, 'timeout'); } }, 30000));
      return c.id;
    },
    calls: () => Object.keys(calls).length
  };
})();
