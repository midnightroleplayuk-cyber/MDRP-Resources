/* ============================================================
   ESIM - linhas do telemóvel (até 3 números) e ativação por código QR (2026-10-04)

   O modelo (docs: scratchpad admin/SPEC_ESIM.md):
     · a conta tem UMA linha ativa (apex_phone_accounts.phone): é com ela que se liga, se escrevem
       SMS e se usa o Zapp. As outras linhas continuam a RECEBER chamadas e mensagens; o push traz
       `line = { number, label, color, slot }` e o telemóvel mostra a etiqueta ("Trabalho · Mia").
     · Config.Sim.required = true: uma conta sem linha fica "Sem SIM" (barra de estado, avisos no
       Telefone, Mensagens e Zapp) e o servidor recusa chamadas e envios com { error = 'nosim' }.
     · um eSIM (item `esim` do inventário) ACRESCENTA uma linha: lê-se o código QR com a câmara do
       telemóvel. O cliente (client/sim.lua) põe o cartão 3D na mão esquerda e aponta a câmara
       scriptada para ele; a NUI desenha o visor (CamView 'bare', a vista real do jogo), os cantos
       do leitor, o "bloqueio" no código e a folha de ativação.

   Contrato com o servidor/cliente (workstream L):
     RPC  sim.lines                       → { required, max, allowRemove, scanSeconds?, active, lines = [{ number, label, color, slot, iccid, source, active, unread }] }
          sim.switch { number }            sim.rename { number, label, color }     sim.remove { number }
          sim.activate { iccid, slot, label, color } → { ok, line } | { error }
     NUI  simScanStart { from }           → { ok, card = { slot, iccid, number }, scanSeconds? } | { ok = false, error = 'noitem' | 'max' | 'busy' }
          simScanStop { activated }
     Push sim:changed (o estado inteiro como o sim.lines, ou vazio = pedir de novo) · sim:scan { slot, iccid, number, scanSeconds }
   Fora do jogo os mesmos nomes têm mocks no fim deste ficheiro (harness: &esim=none|req|2|3|max1|noitem).

   API (window.ESim): refresh(), noSim(), require(o_que), lines(), active(), isInactive(line), tag(line, opts),
   notifTag(n), page(ctx) (Definições), scan(opts), mount(host, opts) (aviso "Sem SIM" + seletor de linha),
   callTag(ui, d) (chamada recebida). Prefixo CSS: esm- (css/app-esim.css).
   ============================================================ */
window.ESim = (() => {
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
  const esc = s => (window.UI && UI.esc ? UI.esc(s) : String(s == null ? '' : s));
  const isA = () => !!(window.System && System.os === 'android');
  const g = (n, s) => (window.UI && UI.g ? UI.g(n, s) : '');
  const ph = n => (window.UI && UI.phone ? UI.phone(n) : String(n || ''));
  const snd = n => { try { if (window.Sound) Sound.play(n); } catch (e) {} };

  /* etiquetas de origem (as chaves do i18n.js) e as seis cores das linhas, pela ordem em que se oferecem */
  const STD = ['Principal', 'Pessoal', 'Trabalho', 'Viagem'];
  const COLORS = ['#0A84FF', '#FF9F0A', '#30D158', '#BF5AF2', '#FF375F', '#64D2FF'];
  const HEX = /^#[0-9a-fA-F]{6}$/;
  const isStd = l => STD.includes(l);
  /* o texto MOSTRADO de uma etiqueta: as de origem traduzem-se, as escritas pelo jogador ficam como estão */
  const labelText = l => (isStd(l) ? T(l) : String(l || ''));
  const initial = l => (labelText(l).trim().charAt(0) || '?').toUpperCase();
  const fmtIccid = s => String(s || '').replace(/\D/g, '').replace(/(\d{4})(?=\d)/g, '$1 ');

  /* ---------- ESTADO ----------
     loaded: já houve uma resposta do sim.lines; avail: o servidor conhece as linhas (sem RPC = telemóvel antigo,
     nada se bloqueia e a página das Definições mostra só o número). */
  /* PSIM: physical = SIM fisico (server/psim.lua, js/apps/psim.js): tray = a ranhura do telemovel na mao, cards = cartoes SIM no inventario */
  const st = { loaded: false, avail: false, required: false, max: 3, allowRemove: true, scanSeconds: 1.6, active: null, lines: [], physical: false, tray: null, cards: [], esim: 'slot', recover: null, contactsOnSim: false };
  const arr = v => Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v).filter(x => x && typeof x === 'object') : []);
  function normLine(l, i, active) {
    const slot = Math.max(1, Math.min(9, Math.floor(+l.slot) || i + 1));
    const label = String(l.label || '').trim().slice(0, 24) || (slot === 1 ? 'Principal' : STD[Math.min(STD.length - 1, slot)] || 'Pessoal');
    return { number: String(l.number || ''), label, color: HEX.test(l.color || '') ? String(l.color).toUpperCase() : COLORS[(slot - 1) % COLORS.length], slot,
      iccid: l.iccid ? String(l.iccid) : '', source: l.source === 'legacy' ? 'legacy' : 'esim', active: l.active === true || (!!active && String(l.number) === String(active)),
      unread: Math.max(0, Math.floor(+l.unread) || 0), created: +l.created || 0 };
  }
  let lastFetch = 0, inflight = null;
  function apply(r) {
    if (!r || typeof r !== 'object' || r.error) return false;
    const prevActive = st.active, wasLoaded = st.loaded;
    const active = r.active != null && r.active !== '' ? String(r.active) : null;
    const lines = arr(r.lines).map((l, i) => normLine(l, i, active)).filter(l => l.number).sort((a, b) => a.slot - b.slot);
    st.loaded = true; st.avail = true;
    st.required = r.required === true;
    st.max = Math.max(1, Math.min(3, Math.floor(+r.max || +r.maxLines) || 3));
    st.allowRemove = r.allowRemove !== false;
    if (+r.scanSeconds > 0) st.scanSeconds = Math.max(.8, Math.min(5, +r.scanSeconds));
    st.lines = lines;
    /* PSIM: SIM fisico */
    st.physical = r.physical === true;
    st.tray = st.physical && r.tray && typeof r.tray === 'object' ? r.tray : null;
    st.cards = st.physical ? arr(r.cards) : [];
    st.esim = r.esim === 'off' ? 'off' : 'slot';
    /* 1.3.0: recuperar um número perdido (Config.PhysicalSim.recover) e os contactos no cartão (contactsOnSim) - só desenhados pelo psim.js */
    st.recover = st.physical && r.recover && typeof r.recover === 'object' ? { enabled: r.recover.enabled !== false, price: Math.max(0, +r.recover.price || 0), numbers: arr(r.recover.numbers).filter(x => x && x.number) } : null;
    st.contactsOnSim = st.physical && r.contactsOnSim === true;
    st.active = active || ((lines.find(l => l.active) || {}).number) || null;
    lines.forEach(l => { l.active = l.number === st.active; });
    changed(wasLoaded && prevActive !== st.active ? prevActive : undefined);
    return true;
  }
  /* a linha ativa mudou (trocar, remover, ativar a primeira): o número do jogador, a lista das Mensagens e os
     Recentes passam a ser os da identidade nova - o servidor já trocou apex_phone_accounts.phone */
  function activeChanged() {
    const n = st.active || '';
    try { if (window.System && System.setPlayer) System.setPlayer({ phone: n }); if (window.System && System.account) System.account.phone = n; } catch (e) {}
    try { Bridge.emit('messages:changed'); } catch (e) {}
    try { if (window.Msgs && Msgs.badge) Msgs.badge(); } catch (e) {}
    try { if (window.PhoneMissed && PhoneMissed.soon) PhoneMissed.soon(300); } catch (e) {}
    Bridge.emit('sim:switched', { number: n });
  }
  let paintT = null;
  function changed(prevActive) {
    if (prevActive !== undefined) activeChanged();
    try { if (window.System && System.renderStatus) System.renderStatus(); } catch (e) {}
    Bridge.emit('esim:state', st);
  }
  /* pede o estado ao servidor; `force` ignora a cache de 15 s (abrir o telemóvel não pede de cada vez) */
  function refresh(force) {
    if (inflight) return inflight;
    if (!force && st.loaded && Date.now() - lastFetch < 15000) return Promise.resolve(st);
    if (!(window.System && System.account)) return Promise.resolve(st);   /* sem conta (assistente inicial): ainda não há linhas */
    lastFetch = Date.now();
    inflight = Promise.resolve().then(() => Bridge.rpc('sim.lines')).catch(() => null).then(r => {
      inflight = null;
      if (!apply(r) && r && r.error && /^unknown/.test(String(r.error)) && !st.loaded) { st.loaded = true; st.avail = false; changed(); }
      return st;
    });
    return inflight;
  }
  const lines = () => st.lines.slice();
  const activeLine = () => st.lines.find(l => l.active) || null;
  const noSim = () => st.loaded && st.avail && st.required && !st.lines.length;
  /* uma linha que chegou num push é de OUTRA identidade (não a ativa)? */
  const isInactive = l => !!(l && l.number && st.active && String(l.number) !== String(st.active));
  const byNumber = n => st.lines.find(l => l.number === String(n)) || null;

  /* ---------- "SEM SIM": aviso e travão ----------
     require(o_que) é o irmão do CC.requireNet: quem vai ligar ou enviar pergunta antes; sem SIM avisa e devolve false. */
  let alertAt = 0;
  function alertNoSim(what) {
    if (Date.now() - alertAt < 1500) return; alertAt = Date.now();
    snd('error');
    /* PSIM: SIM fisico - mete-se um cartao na ranhura (Definicoes, folha "Inserir SIM") em vez de ler um eSIM */
    if (st.physical) {
      UI.alert({ title: T('Sem SIM'), msg: what ? TF('Para %s precisas de um cartão SIM neste telemóvel.', T(what)) : T('Este telemóvel não tem cartão SIM. Mete um cartão SIM para fazer chamadas e enviar mensagens.'),
        buttons: [{ label: T('Agora não'), value: false }, { label: T('Inserir SIM'), bold: true, value: true }] }).then(r => { if (r && r.value) openSettings(false, true); });
      return;
    }
    UI.alert({ title: T('Sem SIM'), msg: what ? TF('Para %s precisas de um número. Adiciona um eSIM nas Definições.', T(what)) : T('Este telemóvel não tem número. Adiciona um eSIM para fazer chamadas e enviar mensagens.'),
      buttons: [{ label: T('Agora não'), value: false }, { label: T('Adicionar eSIM'), bold: true, value: true }] }).then(r => { if (r && r.value) openSettings(true); });
  }
  function require(what) { if (!noSim()) return true; alertNoSim(what); return false; }
  /* abre Definições › Serviço móvel (Nova UI: Ligações › Gestor de SIM); scan = já com o leitor aberto por cima */
  function openSettings(scanToo, insertToo) {
    const go = () => { try { System.openApp('settings'); } catch (e) {} setTimeout(() => { Bridge.emit('settings:goto', 'sim'); if (scanToo) setTimeout(() => scan({ from: 'settings' }), 520);
      if (insertToo && window.PSim && PSim.insertSheet) setTimeout(() => PSim.insertSheet(), 520); /* PSIM */ }, 380); };
    if (System.locked && window.Lock && Lock.requestUnlock) Lock.requestUnlock(go); else go();
  }

  /* ---------- EMBLEMA DA LINHA ----------
     PearOS: quadrado arredondado com a inicial da etiqueta na cor da linha (como as etiquetas de linha do PearPhone).
     Nova UI: o cartão SIM com o número do slot, na cor da linha (como o Gestor de SIM).
     opts.size: 'xs' (16, notificações e listas), 'sm' (22, barras), 'md' (30, linhas das Definições), 'lg' (56, cabeçalho). */
  const SIMPATH = 'M7 2.5h7.6L19 6.9V20a1.5 1.5 0 0 1-1.5 1.5h-10.5A1.5 1.5 0 0 1 5.5 20V4A1.5 1.5 0 0 1 7 2.5Z';
  function tag(line, opts) {
    opts = opts || {}; if (!line) return '';
    const size = opts.size || 'xs', col = HEX.test(line.color || '') ? line.color : COLORS[0];
    if (isA()) return `<span class="esm-tag esm-tag-a esm-${size}" data-noi18n style="--esm-c:${col}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="${SIMPATH}" fill="currentColor"/></svg><b>${esc(String(line.slot || 1))}</b></span>`;
    return `<span class="esm-tag esm-${size}" data-noi18n style="--esm-c:${col}"><b>${esc(initial(line.label))}</b></span>`;
  }
  /* notificação (notify.js): o emblema e a etiqueta, só quando há mais do que uma linha ou a mensagem veio de outra */
  function notifTag(n) {
    const l = n && n.data && n.data.line; if (!l || typeof l !== 'object' || !l.number) return '';
    const line = normLine(Object.assign({}, byNumber(l.number) || {}, l), 0, null);
    if (st.lines.length <= 1 && !isInactive(line)) return '';
    return `<span class="esm-ntag" data-noi18n>${tag(line, { size: 'xs' })}<span>${esc(labelText(line.label))}</span></span>`;
  }
  /* ecrã da chamada recebida (phone.js): por baixo do "chamada de telemóvel…" fica "[T] Trabalho" (PearOS) ou o SIM (Nova UI) */
  function callTag(ui, d) {
    try {
      const l = d && d.line; if (!ui || !ui.querySelector || !l || !l.number) return;
      const line = normLine(Object.assign({}, byNumber(l.number) || {}, l), 0, null);
      if (st.lines.length <= 1 && !isInactive(line)) return;
      const host = ui.querySelector('.ic-top') || ui.querySelector('.aph-i-head'); if (!host || host.querySelector('.esm-ctag')) return;
      const el = UI.el(`<div class="esm-ctag" data-noi18n>${tag(line, { size: 'sm' })}<span>${esc(TF('Para %s', labelText(line.label)))}</span></div>`);
      host.appendChild(el);
    } catch (e) { console.error('[apex_phone] esim callTag', e); }
  }

  /* ---------- AVISO "SEM SIM" + SELETOR DE LINHA (Mensagens, Telefone, Zapp) ----------
     Constrói-se UMA vez e acerta-se no sítio a cada mudança de estado (nada de refazer a lista da app).
     opts.app: 'messages' | 'phone' | 'recado'; opts.lineBar: mostra o seletor com 2+ linhas; opts.float: por cima
     do conteúdo (teclado do Telefone); opts.onSwitch: chamado depois de trocar de linha. */
  const mounts = new Set();
  function mount(host, opts) {
    opts = opts || {};
    if (!host || !host.appendChild) return null;
    const m = UI.el(`<div class="esm-mount${opts.float ? ' esm-float' : ''} esm-app-${esc(opts.app || 'x')}">
      <div class="esm-nosim esm-off"><div class="esm-ns-ic">${simOffGlyph()}</div><div class="esm-ns-tx"><b>Sem SIM</b><span>${esc(opts.app === 'recado' ? 'O Zapp precisa de um número. Adiciona um eSIM para enviar mensagens.' : opts.app === 'phone' ? 'Adiciona um eSIM para fazer e receber chamadas.' : 'Adiciona um eSIM para enviar e receber mensagens.')}</span></div><div class="esm-ns-btn" role="button">Adicionar</div></div>
      <div class="esm-lbar esm-off"><div class="esm-lb" role="button"><span class="esm-lb-tag"></span><span class="esm-lb-lab" data-noi18n></span><span class="esm-lb-num"></span><span class="esm-lb-chev">${g('chevD', 14)}</span><i class="esm-lb-dot esm-off"></i></div></div></div>`);
    const ns = m.querySelector('.esm-nosim'), bar = m.querySelector('.esm-lbar'), btn = m.querySelector('.esm-lb');
    const tg = m.querySelector('.esm-lb-tag'), lab = m.querySelector('.esm-lb-lab'), num = m.querySelector('.esm-lb-num'), dot = m.querySelector('.esm-lb-dot');
    m.querySelector('.esm-ns-btn').onclick = e => { e.stopPropagation(); snd('click'); if (st.physical) openSettings(false, true); else openSettings(true); };   /* PSIM */
    btn.onclick = e => { e.stopPropagation(); snd('click'); linePicker(btn, opts); };
    /* PSIM: com o SIM fisico o aviso fala do cartao (texto e botao mudam no sitio quando o modo chega do servidor) */
    const nsTx = m.querySelector('.esm-ns-tx span'), nsBtn = m.querySelector('.esm-ns-btn');
    const nsEsim = nsTx.textContent, nsBtnEsim = nsBtn.textContent;
    const nsPhys = opts.app === 'recado' ? 'O Zapp precisa de um número. Mete um cartão SIM neste telemóvel.' : opts.app === 'phone' ? 'Mete um cartão SIM para fazer e receber chamadas.' : 'Mete um cartão SIM para enviar e receber mensagens.';
    let sig = '';
    const paint = () => {
      const a = activeLine(), many = opts.lineBar && st.lines.length > 1 && !!a;
      const others = st.lines.filter(l => !l.active && l.unread > 0).length;
      const s = [noSim() ? 1 : 0, many ? 1 : 0, a ? a.number + a.label + a.color + a.slot : '', others, isA() ? 1 : 0, st.physical ? 1 : 0].join('|');
      if (s === sig) return; sig = s;
      nsTx.textContent = st.physical ? T(nsPhys) : nsEsim; nsBtn.textContent = st.physical ? T('Inserir SIM') : nsBtnEsim;   /* PSIM */
      ns.classList.toggle('esm-off', !noSim());
      bar.classList.toggle('esm-off', !many);
      if (many) { tg.innerHTML = tag(a, { size: 'sm' }); lab.textContent = labelText(a.label); num.textContent = ph(a.number); dot.classList.toggle('esm-off', !others); }
      m.classList.toggle('esm-empty', !noSim() && !many);
    };
    m._paint = paint; paint();
    host.appendChild(m); mounts.add(m);
    if (!st.loaded) refresh();
    return m;
  }
  /* uma vista desligada pode voltar (separadores que guardam a vista): pinta-se na mesma; só quando o registo cresce
     é que as desligadas saem (janelas mortas), para nunca acumular */
  const paintMounts = () => { if (mounts.size > 24) mounts.forEach(m => { if (!m.isConnected) mounts.delete(m); }); mounts.forEach(m => { try { m._paint(); } catch (e) {} }); };
  Bridge.on('esim:state', paintMounts);
  Bridge.on('app:open', () => setTimeout(paintMounts, 0));
  /* escolher a linha (menu ancorado ao seletor): a ativa com o visto, as outras com as mensagens por ler */
  function linePicker(anchor, opts) {
    const items = st.lines.map(l => ({ label: labelText(l.label) + ' · ' + ph(l.number) + (l.unread && !l.active ? ' (' + l.unread + ')' : ''), icon: l.active ? 'check' : 'sim',
      onTap: () => { if (!l.active) switchTo(l.number).then(ok => { if (ok && opts && opts.onSwitch) { try { opts.onSwitch(l); } catch (e) {} } }); } }));
    UI.ctxMenu(anchor, items);
  }

  /* ---------- AÇÕES (o servidor decide; a NUI repinta com a resposta ou volta a pedir) ---------- */
  const ERR = { noitem: 'Não tens nenhum cartão eSIM no inventário.', max: 'Este telemóvel já tem o número máximo de linhas.', taken: 'O número deste eSIM já está a ser usado.',
    busy: 'Espera um instante e tenta outra vez.', ratelimit: 'Demasiados pedidos, espera um instante.', notfound: 'Esta linha já não existe.', last: 'Não podes remover a única linha deste telemóvel.',
    forbidden: 'Remover linhas está desativado neste servidor.', invalid: 'Pedido inválido.', nosim: 'Este telemóvel não tem número.', internal: 'Erro no servidor.', timeout: 'O servidor não respondeu.' };
  /* codigos do servidor (server/sim.lua) com outro nome: mesma mensagem */
  const ERR_ALIAS = { maxlines: 'max', lastline: 'last', disabled: 'forbidden', badcolor: 'invalid', noaccount: 'nosim', incall: 'incall' };
  ERR.incall = 'Não podes mudar de linha durante uma chamada.';
  /* PSIM: SIM fisico (server/psim.lua) */
  ERR.physical = 'Este servidor usa cartões SIM: mete um cartão SIM no telemóvel.'; ERR.slotfull = 'Este telemóvel já tem um SIM. Tira-o primeiro.';
  ERR.nophone = 'Precisas de um telemóvel para pôr o SIM.'; ERR.dupe = 'Este cartão SIM não funciona.'; ERR.full = 'Não tens espaço para o cartão SIM.';
  ERR.empty = 'Este telemóvel não tem SIM.'; ERR.locked = 'Desbloqueia o telemóvel primeiro.';
  const errCode = r => { const e = r && typeof r === 'object' ? r.error : null; return (e && ERR_ALIAS[e]) || e; };
  const errText = (r, fb) => { const e = errCode(r); return T((e && ERR[e]) || fb || 'Não foi possível concluir.'); };
  async function act(name, data) {
    let r = null; try { r = await Bridge.rpcRaw(name, data); } catch (e) { r = null; }
    if (!r || r.error || r.ok === false) return { ok: false, r: r || { error: 'timeout' } };
    if (!apply(r.state || r)) await refresh(true);   /* resposta curta ({ ok }): volta a pedir o estado */
    return { ok: true, r };
  }
  async function switchTo(number) {
    if (window.CC && CC.requireNet && !CC.requireNet(T('trocar de linha'))) return false;
    const res = await act('sim.switch', { number });
    if (!res.ok) { snd('error'); UI.toast(errText(res.r, 'Não foi possível trocar de linha.')); return false; }
    const l = byNumber(number); snd('success');
    UI.toast(TF('A usar a linha %s', l ? labelText(l.label) : ph(number)));
    return true;
  }
  async function rename(line, label, color) {
    const prev = { label: line.label, color: line.color };
    line.label = label; line.color = color; changed();   /* otimista: a etiqueta muda já e volta atrás se o servidor recusar */
    const res = await act('sim.rename', { number: line.number, label, color });
    if (!res.ok) { line.label = prev.label; line.color = prev.color; changed(); snd('error'); UI.toast(errText(res.r)); return false; }
    return true;
  }
  async function remove(line) {
    const legacy = line.source === 'legacy';
    const ok = await UI.confirm(legacy ? T('Remover linha') : T('Remover eSIM'), TF('O número %s fica livre e deixas de receber chamadas e mensagens nele. Esta ação não pode ser anulada.', ph(line.number)), legacy ? T('Remover') : T('Remover eSIM'), true);
    if (!ok) return false;
    if (window.CC && CC.requireNet && !CC.requireNet(T('remover a linha'))) return false;
    const res = await act('sim.remove', { number: line.number });
    if (!res.ok) { snd('error'); UI.toast(errText(res.r)); return false; }
    snd('delete'); UI.toast(TF('Linha %s removida', labelText(line.label)));
    return true;
  }

  /* glifo "sem SIM": o cartão com um traço */
  const simOffGlyph = () => `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="${SIMPATH}"/><path d="M9 11.5h6v5.5H9z"/><path d="M3.5 3.5l17 17"/></svg>`;
  const qrGlyph = () => `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3.5" y="3.5" width="6.5" height="6.5" rx="1.4"/><rect x="14" y="3.5" width="6.5" height="6.5" rx="1.4"/><rect x="3.5" y="14" width="6.5" height="6.5" rx="1.4"/><path d="M14 14h2.5v2.5H14zM18 18h2.5v2.5H18zM18 14h2.5M14 18v2.5"/></svg>`;

  /* ============================================================
     DEFINIÇÕES › SERVIÇO MÓVEL (PearOS) / LIGAÇÕES › GESTOR DE SIM (Nova UI)
     ctx = { win, sub, from } - o `sub` das Definições (título grande e .aset-body na Nova UI). Constrói uma vez;
     as linhas são nós com chave (o número) e acertam-se no sítio quando o estado muda.
     ============================================================ */
  function page(ctx) {
    /* PSIM: SIM fisico - a pagina e a da ranhura (js/apps/psim.js) */
    if (st.physical && window.PSim && PSim.page) return PSim.page(ctx);
    const { win, sub } = ctx; const A = isA();
    const S = System.state;
    const netPatch = (k, v) => (window.CC && CC.netPatch) ? CC.netPatch(k, v) : { [k]: v };
    return sub(A ? 'Gestor de SIM' : 'Serviço móvel', (c, v) => {
      c.classList.add('esm-page');
      /* "Sem SIM" (obrigatório e sem linha): cartão no topo com o botão grande */
      const hero = UI.el(`<div class="esm-hero esm-off"><div class="esm-hero-ic">${simOffGlyph()}</div><b>Sem SIM</b><span>Este telemóvel não tem número. Adiciona um eSIM para fazer chamadas, enviar mensagens e usar o Zapp.</span><div class="esm-hero-btn" role="button">${qrGlyph()}<span>Adicionar eSIM</span></div></div>`);
      hero.querySelector('.esm-hero-btn').onclick = () => { snd('click'); scan({ from: 'settings' }); };
      c.appendChild(hero);
      /* dados móveis (o interruptor que vivia na página antiga) */
      c.appendChild(UI.list([{ items: [{ label: 'Dados móveis', sub: A ? 'Rede móvel da Apex Mobile' : '', toggle: !!S.cellular, onToggle: x => System.setState(netPatch('cellular', x)) }] }]));
      /* as linhas */
      const head = UI.el(`<div class="group-header">${esc(A ? 'Cartões SIM' : 'SIM')}</div>`);
      const grp = UI.el('<div class="group esm-lines"></div>');
      const add = UI.item({ icon: A ? `<span class="esm-add-ic">${g('plus', 20)}</span>` : `<span class="esm-add-ic">${qrGlyph()}</span>`, iconBg: 'transparent', label: 'Adicionar eSIM', cls: 'esm-add', chevron: false, onTap: () => { snd('click'); scan({ from: 'settings' }); } });
      grp.appendChild(add);
      const foot = UI.el('<div class="group-footer esm-foot"></div>');
      c.append(head, grp, foot);
      /* linha predefinida (2+ linhas) */
      const defHead = UI.el(`<div class="group-header esm-off">${esc(A ? 'SIM preferido' : 'Linha predefinida')}</div>`);
      const defGrp = UI.el('<div class="group esm-off"></div>');
      const defRow = UI.item({ label: A ? 'Chamadas, mensagens e Zapp' : 'Chamadas e mensagens', value: ' ', onTap: () => defaultPage(ctx, v) });
      defGrp.appendChild(defRow);
      const defFoot = UI.el('<div class="group-footer esm-off">As chamadas, as mensagens e o Zapp saem da linha predefinida. As outras linhas continuam a receber chamadas e mensagens.</div>');
      c.append(defHead, defGrp, defFoot);
      /* operadora */
      c.appendChild(UI.list([{ items: [{ label: 'Operadora', value: 'Apex Mobile', chevron: false }, { label: 'Rede', value: '5G', chevron: false }] }]));
      const rows = new Map();
      const setVal = (li, t) => { const val = li.querySelector('.li-value'), ou = li.querySelector('.ou-val'); if (val) val.textContent = t; if (ou) ou.textContent = t; };
      const rowFor = l => {
        let li = rows.get(l.number);
        if (!li) {
          li = UI.item({ icon: '<span class="esm-li-tag"></span>', iconBg: 'transparent', label: ' ', sub: ' ', right: '<span class="esm-def"></span>', chevron: true, onTap: () => linePage(ctx, l.number, v) });
          li.classList.add('esm-li'); li.querySelector('.li-label').setAttribute('data-noi18n', ''); rows.set(l.number, li);
        }
        const sig = [l.label, l.color, l.slot, l.active ? 1 : 0, A ? 1 : 0].join('|');
        if (li._sig !== sig) {
          li._sig = sig;
          li.querySelector('.esm-li-tag').innerHTML = tag(l, { size: 'md' });
          li.querySelector('.li-label').textContent = labelText(l.label);
          li.querySelector('.li-sub').textContent = ph(l.number);
          li.querySelector('.esm-def').textContent = l.active ? T('Predefinida') : '';
        }
        return li;
      };
      let sig0 = '';
      const paint = () => {
        const s = JSON.stringify([st.loaded, st.avail, st.required, st.max, st.allowRemove, st.active, st.lines.map(l => [l.number, l.label, l.color, l.slot])]);
        if (s === sig0) return; sig0 = s;
        const empty = noSim();
        hero.classList.toggle('esm-off', !empty);
        /* sem o RPC (servidor antigo): a linha do número da conta, sem adicionar nem remover */
        const list = st.avail ? st.lines : (System.player && System.player.phone ? [normLine({ number: System.player.phone, label: 'Principal', slot: 1, source: 'legacy' }, 0, System.player.phone)] : []);
        const keep = new Set(list.map(l => l.number));
        rows.forEach((li, n) => { if (!keep.has(n)) { li.remove(); rows.delete(n); } });
        list.forEach(l => grp.insertBefore(rowFor(l), add));
        const full = list.length >= st.max;
        add.classList.toggle('esm-off', !st.avail || full);
        /* sem linha nenhuma o cartão "Sem SIM" lá em cima já tem o botão: o grupo das linhas sai todo */
        [head, grp, foot].forEach(x => x.classList.toggle('esm-off', empty));
        grp.classList.toggle('esm-nolines', !list.length);
        foot.textContent = !st.avail ? T('As linhas e os eSIM não estão disponíveis neste servidor.')
          : full ? TF('Chegaste ao limite de %s linhas neste telemóvel.', String(st.max))
          : st.max > 1 ? TF('Este telemóvel aceita até %s linhas. Cada eSIM traz um número novo: lê o código QR do cartão para o ativar.', String(st.max))
          : T('Lê o código QR de um cartão eSIM para ativar um número neste telemóvel.');
        const many = st.avail && list.length > 1, a = activeLine();
        [defHead, defGrp, defFoot].forEach(x => x.classList.toggle('esm-off', !many));
        if (many && a) setVal(defRow, labelText(a.label));
      };
      paint();
      const off = Bridge.on('esim:state', () => { if (!c.isConnected) return; paint(); });
      const prev = v.opts.onPop; v.opts.onPop = () => { try { off(); } catch (e) {} if (prev) prev(); };
      refresh(true);
    }, ctx.from ? { from: ctx.from } : {});
  }

  /* ---------- página de uma linha ---------- */
  function linePage(ctx, number, parentView) {
    const { win, sub } = ctx; const A = isA();
    const l0 = byNumber(number); if (!l0) return null;
    return sub(labelText(l0.label), (c, v) => {
      c.classList.add('esm-page');
      v.querySelector('.nb-title') && v.querySelector('.nb-title').setAttribute('data-noi18n', '');
      const hero = UI.el(`<div class="esm-lhero esm-lhero-line"><div class="esm-lh-tag"></div><b data-noi18n></b><span></span><i class="esm-lh-def esm-off">${esc(A ? 'SIM preferido' : 'Linha predefinida')}</i></div>`);
      c.appendChild(hero);
      const lbl = UI.item({ label: 'Etiqueta', value: ' ', onTap: () => labelPage(ctx, number, v) });
      lbl.querySelector('.li-value') && lbl.querySelector('.li-value').setAttribute('data-noi18n', '');
      const info = UI.el('<div class="group"></div>'); info.appendChild(lbl);
      c.appendChild(info);
      const det = UI.list([{ header: 'Linha', items: [{ label: 'Número de telefone', value: ph(l0.number), chevron: false }, { label: 'Operadora', value: 'Apex Mobile', chevron: false },
        { label: 'Tipo', value: l0.source === 'legacy' ? 'Número original' : 'eSIM', chevron: false }].concat(l0.iccid ? [{ label: 'ICCID', value: fmtIccid(l0.iccid), chevron: false, cls: 'esm-iccid' }] : [])
        .concat(l0.created ? [{ label: 'Ativada em', value: UI.fmtDate(new Date(l0.created), true), chevron: false }] : []) }]);
      c.appendChild(det);
      const mk = UI.list([{ items: [{ label: A ? 'Definir como SIM preferido' : 'Tornar linha predefinida', cls: 'blue center', chevron: false, onTap: async () => { if (await switchTo(number)) paint(); } }],
        footer: 'Passas a ligar, enviar mensagens e usar o Zapp com este número.' }]);
      c.appendChild(mk);
      const rm = UI.list([{ items: [{ label: l0.source === 'legacy' ? 'Remover linha' : 'Remover eSIM', cls: 'danger center', chevron: false, onTap: async () => { const l = byNumber(number); if (l && await remove(l)) UI.pop(win); } }] }]);
      c.appendChild(rm);
      const tagEl = hero.querySelector('.esm-lh-tag'), nm = hero.querySelector('b'), sb = hero.querySelector('span'), dflt = hero.querySelector('.esm-lh-def');
      const navT = v.querySelector('.nb-title');
      let sig = '';
      function paint() {
        const l = byNumber(number);
        if (!l) { if (v.isConnected && !v.classList.contains('leave')) UI.pop(win); return; }
        const s = [l.label, l.color, l.slot, l.active ? 1 : 0, st.allowRemove ? 1 : 0, st.lines.length].join('|'); if (s === sig) return; sig = s;
        tagEl.innerHTML = tag(l, { size: 'lg' }); nm.textContent = labelText(l.label); sb.textContent = ph(l.number);
        dflt.classList.toggle('esm-off', !(l.active && st.lines.length > 1));
        if (navT && !A) navT.textContent = labelText(l.label);
        const lt = v.querySelector('.lt-title, .large-title'); if (lt) lt.textContent = labelText(l.label);
        const val = lbl.querySelector('.li-value'), ou = lbl.querySelector('.ou-val'); if (val) val.textContent = labelText(l.label); if (ou) ou.textContent = labelText(l.label);
        mk.classList.toggle('esm-off', l.active || st.lines.length < 2);
        rm.classList.toggle('esm-off', !st.allowRemove);
      }
      paint();
      const off = Bridge.on('esim:state', () => { if (c.isConnected) paint(); });
      const prev = v.opts.onPop; v.opts.onPop = () => { try { off(); } catch (e) {} if (prev) prev(); };
    }, { back: A ? undefined : 'Serviço móvel', from: parentView });
  }

  /* ---------- etiqueta e cor de uma linha ---------- */
  function labelPage(ctx, number, parentView) {
    const { win, sub } = ctx; const A = isA();
    const l0 = byNumber(number); if (!l0) return null;
    return sub('Etiqueta', (c, v) => {
      c.classList.add('esm-page');
      const pv = UI.el('<div class="esm-lhero esm-lhero-sm"><div class="esm-lh-tag"></div><b data-noi18n></b></div>'); c.appendChild(pv);
      const pvTag = pv.querySelector('.esm-lh-tag'), pvName = pv.querySelector(':scope > b');   /* presos já: depois de pintar o emblema, o primeiro <b> seria o dele */
      const grp = UI.el('<div class="group esm-lbls"></div>'); const rows = [];
      const mark = (li, on) => { if (A) { const r = li.querySelector('.ou-radio'); if (r) r.classList.toggle('on', on); } else { const vv = li.querySelector('.li-value'); if (vv) vv.innerHTML = on ? g('check', 21) : ''; } };
      const pick = async (label) => { const l = byNumber(number); if (!l) return; snd('click'); await rename(l, label, l.color); };
      STD.forEach(s => { const li = UI.item(A ? { label: s, right: UI.radio(false), chevron: false, onTap: () => pick(s) } : { label: s, value: ' ', valueHtml: true, chevron: false, onTap: () => pick(s) }); li._lbl = s; rows.push(li); grp.appendChild(li); });
      const custom = UI.item(A ? { label: 'Personalizada', sub: ' ', right: UI.radio(false), chevron: false, onTap: () => askCustom() } : { label: 'Personalizada', sub: ' ', value: ' ', valueHtml: true, chevron: false, onTap: () => askCustom() });
      custom.querySelector('.li-sub').setAttribute('data-noi18n', ''); grp.appendChild(custom);
      const askCustom = async () => { const l = byNumber(number); if (!l) return; const cur = isStd(l.label) ? '' : l.label;
        const n = await UI.prompt(T('Etiqueta personalizada'), T('Até 16 letras. Aparece nas chamadas, nas mensagens e nas notificações.'), T('Ex.: Loja'), cur); if (n == null) return;
        const s = n.replace(/[<>"]/g, '').trim().slice(0, 16); if (!s) return; await rename(l, s, l.color); };
      c.appendChild(UI.el('<div class="group-header">Nome</div>')); c.appendChild(grp);
      /* cor: seis amostras (sem <input type=color>, que está morto no FiveM) */
      c.appendChild(UI.el('<div class="group-header">Cor</div>'));
      const sw = UI.el(`<div class="group esm-swatches">${COLORS.map(cl => `<div class="esm-sw" data-c="${cl}" role="button" style="--esm-c:${cl}"><i></i></div>`).join('')}</div>`);
      sw.onclick = async e => { const d = e.target.closest('.esm-sw'); if (!d) return; const l = byNumber(number); if (!l || l.color === d.dataset.c) return; snd('tick'); await rename(l, l.label, d.dataset.c); };
      c.appendChild(sw);
      c.appendChild(UI.el('<div class="group-footer">A etiqueta e a cor distinguem esta linha nas chamadas, nas mensagens e nas notificações.</div>'));
      let sig = '';
      const paint = () => { const l = byNumber(number); if (!l) { if (v.isConnected && !v.classList.contains('leave')) UI.pop(win); return; }
        const s = l.label + '|' + l.color + '|' + l.slot; if (s === sig) return; sig = s;
        pvTag.innerHTML = tag(l, { size: 'lg' }); pvName.textContent = labelText(l.label);
        rows.forEach(li => mark(li, li._lbl === l.label));
        mark(custom, !isStd(l.label)); custom.querySelector('.li-sub').textContent = isStd(l.label) ? T('Escreve o teu nome para a linha') : l.label;
        sw.querySelectorAll('.esm-sw').forEach(d => d.classList.toggle('esm-sel', d.dataset.c === l.color)); };
      paint();
      const off = Bridge.on('esim:state', () => { if (c.isConnected) paint(); });
      const prev = v.opts.onPop; v.opts.onPop = () => { try { off(); } catch (e) {} if (prev) prev(); };
    }, { back: A ? undefined : labelText(l0.label), from: parentView });
  }

  /* ---------- linha predefinida (escolha única) ---------- */
  function defaultPage(ctx, parentView) {
    const { win, sub } = ctx; const A = isA();
    return sub(A ? 'SIM preferido' : 'Linha predefinida', (c, v) => {
      c.classList.add('esm-page');
      const grp = UI.el('<div class="group"></div>'); c.appendChild(grp);
      c.appendChild(UI.el('<div class="group-footer">Liga, envia mensagens e usa o Zapp com a linha escolhida. As outras continuam a receber.</div>'));
      const rows = new Map(); let sig = '';
      const paint = () => {
        const s = JSON.stringify(st.lines.map(l => [l.number, l.label, l.color, l.active, l.unread])); if (s === sig) return; sig = s;
        rows.forEach((li, n) => { if (!byNumber(n)) { li.remove(); rows.delete(n); } });
        st.lines.forEach(l => {
          let li = rows.get(l.number);
          if (!li) { li = UI.item({ icon: '<span class="esm-li-tag"></span>', iconBg: 'transparent', label: ' ', sub: ' ', right: A ? UI.radio(false) : '<span class="esm-chk"></span>', chevron: false, onTap: async () => { const x = byNumber(l.number); if (x && !x.active) await switchTo(l.number); } });
            li.querySelector('.li-label').setAttribute('data-noi18n', ''); rows.set(l.number, li); }
          grp.appendChild(li);
          li.querySelector('.esm-li-tag').innerHTML = tag(l, { size: 'md' }); li.querySelector('.li-label').textContent = labelText(l.label);
          li.querySelector('.li-sub').textContent = ph(l.number) + (l.unread && !l.active ? ' · ' + TF('%s por ler', String(l.unread)) : '');
          if (A) { const r = li.querySelector('.ou-radio'); if (r) r.classList.toggle('on', l.active); } else li.querySelector('.esm-chk').innerHTML = l.active ? g('check', 21) : '';
        });
      };
      paint();
      const off = Bridge.on('esim:state', () => { if (c.isConnected) paint(); });
      const prev = v.opts.onPop; v.opts.onPop = () => { try { off(); } catch (e) {} if (prev) prev(); };
    }, { back: A ? undefined : 'Serviço móvel', from: parentView });
  }

  /* ============================================================
     O LEITOR (visor da câmara com o cartão na mão) E A FOLHA DE ATIVAÇÃO
     Camada própria no #screen, por cima das apps (z 180: as folhas, alertas e toasts do sistema continuam por cima).
     No jogo o visor é o CamView 'bare' (vista real do jogo, câmara scriptada do client/sim.lua apontada ao cartão);
     no browser não há jogo: desenha-se um cartão de demonstração com o código QR verdadeiro (window.QR, do K).
     Fecha SEMPRE por close(): simScanStop, CamView destruído, lanterna reposta, camada fora.
     ============================================================ */
  let scanning = null;
  const ncall = (name, data, ms) => Bridge.inFiveM ? Bridge.callT(name, data || {}, ms || 8000) : Promise.resolve().then(() => (MOCKCALL[name] ? MOCKCALL[name](data || {}) : null));
  function cardHtml(iccid, number) {
    const qrTxt = 'LPA:1$rsp.apexmobile.ls$' + String(iccid || '').replace(/\D/g, '');
    let qr = '';
    try { if (window.QR && QR.svg) qr = QR.svg(qrTxt, { margin: 2, cls: 'esm-qrsvg' }); } catch (e) { qr = ''; }
    if (!qr) qr = `<div class="esm-qrph">${Array.from({ length: 49 }, (_, i) => `<i class="${(i * 7 + (i >> 2)) % 3 ? '' : 'esm-on'}"></i>`).join('')}</div>`;   /* sem o qr.js: um padrão de enchimento (só no harness) */
    const num = number ? `<div class="esm-card-num" data-noi18n>${esc(ph(String(number)))}</div>` : '';
    return `<div class="esm-card"><i class="esm-card-sheen"></i><div class="esm-card-l"><div class="esm-card-brand"><i></i><b>Apex Mobile</b></div><div class="esm-card-esim">eSIM</div>${num}<div class="esm-card-iccid">ICCID ${esc(fmtIccid(iccid))}</div></div><div class="esm-card-qr">${qr}</div></div>`;
  }
  function scan(opts) {
    opts = opts || {};
    if (scanning) return scanning.api;
    if (!(window.System && System.account)) { UI.toast(T('Configura o telemóvel primeiro.')); return null; }
    if (st.loaded && st.avail && st.lines.length >= st.max) {
      snd('error'); UI.alert({ title: T('Limite de linhas'), msg: TF('Este telemóvel aceita até %s linhas. Remove uma nas Definições para ativar outro eSIM.', String(st.max)) });
      if (opts.from !== 'settings') Bridge.call('simScanStop', { activated: false });   /* o item abriu o leitor: o cliente já pôs o cartão na mão */
      return null;
    }
    const A = isA();
    const root = UI.el(`<div class="esm-scan${A ? ' esm-a' : ''}">
      <div class="esm-vf"></div>
      <div class="esm-mock esm-off"><div class="esm-desk"></div><div class="esm-hold"></div></div>
      <div class="esm-frame"><i class="esm-c esm-tl"><b></b></i><i class="esm-c esm-tr"><b></b></i><i class="esm-c esm-bl"><b></b></i><i class="esm-c esm-br"><b></b></i></div>
      <div class="esm-pulse"></div>
      <div class="esm-top"><div class="esm-x" role="button" aria-label="${esc(T('Fechar'))}">${A ? g('arrowL', 24) : g('x', 18)}</div><div class="esm-title">Ler código QR</div><div class="esm-torch" role="button" aria-label="${esc(T('Lanterna'))}">${g('flashlight', 20)}</div></div>
      <div class="esm-hint"><b>Aponta para o código QR</b><span>O código está no cartão eSIM da Apex Mobile.</span></div>
      <div class="esm-found"><span class="esm-found-ic">${g('sim', 16)}</span><span>Apex Mobile · eSIM</span></div>
      <div class="esm-act"></div></div>`);
    const $ = s => root.querySelector(s);
    const vf = $('.esm-vf'), mock = $('.esm-mock'), frame = $('.esm-frame'), pulse = $('.esm-pulse'), hint = $('.esm-hint'), found = $('.esm-found'), actEl = $('.esm-act');
    const screen = UI.screen(); screen.appendChild(root); screen.classList.add('esm-on');
    let cam = null, dead = false, timer = null, card = Object.assign({}, opts.card || {}, opts.slot != null || opts.iccid ? { slot: opts.slot, iccid: opts.iccid, number: opts.number } : {}), torchWas = !!(System.state && System.state.torch), locked = false;
    try {
      if (window.CamView && CamView.mount) {
        cam = CamView.mount(vf, { chrome: 'bare', aspect: (screen.clientWidth || 440) / (screen.clientHeight || 956), autoActivate: false, aimInside: false });
        if (cam && cam.render && cam.render.live) { cam.render.resume(); } else mock.classList.remove('esm-off');
      } else mock.classList.remove('esm-off');
    } catch (e) { console.error('[apex_phone] esim CamView', e); cam = null; mock.classList.remove('esm-off'); }
    try { System.indicator('cam', true); } catch (e) {}
    requestAnimationFrame(() => root.classList.add('esm-in'));
    const close = (activated) => {
      if (dead) return; dead = true; clearTimeout(timer);
      Bridge.call('simScanStop', { activated: !!activated });
      try { if (cam) cam.destroy(); } catch (e) {}
      try { System.indicator('cam', false); } catch (e) {}
      try { if (!!(System.state && System.state.torch) !== torchWas && System.torch) System.torch(torchWas); } catch (e) {}
      offs.forEach(f => { try { f(); } catch (e) {} });
      root.classList.remove('esm-in'); root.classList.add('esm-out'); screen.classList.remove('esm-on');
      setTimeout(() => root.remove(), 360);
      scanning = null;
    };
    const offs = [
      Bridge.on('phone:close', () => close(false)),                       /* guardar o telemóvel cancela (o cliente tira o cartão da mão) */
      Bridge.on('os:changed', () => close(false)), Bridge.on('session:changed', () => close(false)),
    ];
    $('.esm-x').onclick = () => { snd('click'); close(false); };
    $('.esm-torch').onclick = () => { snd('click'); const on = !(System.state && System.state.torch); try { System.torch(on); } catch (e) {} $('.esm-torch').classList.toggle('esm-sel', on); };
    $('.esm-torch').classList.toggle('esm-sel', torchWas);
    const api = { close: () => close(false), get root() { return root; }, lock: () => lock(), get card() { return card; } };
    scanning = { api };

    /* o "bloqueio": os quatro cantos saltam para o código (só transform), ficam amarelos (PearOS) ou azuis (Nova UI) por
       opacidade, um anel sai do código uma vez, toque háptico e o som de confirmação; a pílula da operadora aparece e,
       um instante depois, sobe a folha de ativação */
    function targetRect() {
      /* modo 'desk': o CSS põe o código no centro da moldura (128 px × 1,3): sem medir nada no ecrã */
      if (root.classList.contains('esm-deskmode')) { const FW = frame.offsetWidth || 256, FH = frame.offsetHeight || 256, s = 166; return { x: (FW - s) / 2, y: (FH - s) / 2, w: s, h: s, fw: FW, fh: FH }; }
      const fr = frame.getBoundingClientRect(); const z = UI.zoom ? (UI.zoom(frame) || 1) : 1;
      const qr = !mock.classList.contains('esm-off') && mock.querySelector('.esm-card-qr');
      if (qr) { const r = qr.getBoundingClientRect(); if (r.width > 4) return { x: (r.left - fr.left) / z, y: (r.top - fr.top) / z, w: r.width / z, h: r.height / z, fw: fr.width / z, fh: fr.height / z }; }
      /* no jogo: o cliente pode mandar a caixa do código (frações do visor); sem ela, o código está ao centro (a câmara aponta ao cartão) */
      const W = fr.width / z, H = fr.height / z, q = card && card.qr;
      if (q && +q.w > 0 && +q.h > 0) { const sr = screen.getBoundingClientRect(), zs = UI.zoom ? (UI.zoom(screen) || 1) : 1, SW = sr.width / zs, SH = sr.height / zs, ox = (fr.left - sr.left) / z, oy = (fr.top - sr.top) / z;
        return { x: +q.x * SW - ox, y: +q.y * SH - oy, w: +q.w * SW, h: +q.h * SH, fw: W, fh: H }; }
      const s = W * .56; return { x: (W - s) / 2, y: (H - s) / 2, w: s, h: s, fw: W, fh: H };
    }
    function lock() {
      if (dead || locked) return; locked = true;
      frame.classList.remove('esm-reading');
      const t = targetRect(), pad = 10, x0 = t.x - pad, y0 = t.y - pad, x1 = t.x + t.w + pad, y1 = t.y + t.h + pad;
      const set = (sel, dx, dy) => { const e = frame.querySelector(sel); e.style.transform = `translate(${dx.toFixed(1)}px,${dy.toFixed(1)}px)`; };
      set('.esm-tl', x0, y0); set('.esm-tr', x1 - t.fw, y0); set('.esm-bl', x0, y1 - t.fh); set('.esm-br', x1 - t.fw, y1 - t.fh);
      frame.classList.add('esm-lockon');
      const fr = frame.getBoundingClientRect(), sr = root.getBoundingClientRect(), z = UI.zoom ? (UI.zoom(root) || 1) : 1;
      const ox = (fr.left - sr.left) / z, oy = (fr.top - sr.top) / z;
      pulse.style.left = (ox + x0).toFixed(1) + 'px'; pulse.style.top = (oy + y0).toFixed(1) + 'px'; pulse.style.width = (x1 - x0).toFixed(1) + 'px'; pulse.style.height = (y1 - y0).toFixed(1) + 'px';
      found.style.top = (oy + y1 + 14).toFixed(1) + 'px';
      void pulse.offsetWidth; pulse.classList.add('esm-run');
      root.classList.add('esm-locked');
      hint.querySelector('b').textContent = T('Código lido'); hint.querySelector('span').textContent = T('Plano móvel da Apex Mobile');
      snd('haptic'); setTimeout(() => snd('success'), 90);
      timer = setTimeout(() => { if (!dead) showActivate(); }, 720);
    }


    /* ---------- folha de ativação ---------- */
    function showActivate() {
      root.classList.add('esm-sheeton');
      const usedL = new Set(st.lines.map(l => l.label)), usedC = new Set(st.lines.map(l => l.color));
      let label = st.lines.length ? (['Pessoal', 'Trabalho', 'Viagem'].find(s => !usedL.has(s)) || 'Pessoal') : 'Principal';
      let color = COLORS.find(c => !usedC.has(c)) || COLORS[0];
      const slot = Math.min(9, (st.lines.reduce((m, l) => Math.max(m, l.slot), 0) || 0) + 1);
      const preNum = card && card.number ? String(card.number) : '';
      const hasOthers = st.lines.length > 0;
      actEl.innerHTML = `<div class="esm-act-in">
        <div class="esm-grab"></div>
        <div class="esm-act-ic"><span class="esm-ic-a">${g('cellular', 30)}</span><span class="esm-ic-b">${g('check', 34)}</span></div>
        <div class="esm-act-t">Plano móvel detetado</div>
        <div class="esm-act-s">Apex Mobile · eSIM</div>
        <div class="esm-act-card">
          <div class="esm-kv esm-kv-line"><span>Linha</span><b><span class="esm-pv-tag"></span><span class="esm-pv-lab" data-noi18n></span></b></div>
          <div class="esm-kv"><span>Número</span><b class="esm-pv-num" data-noi18n></b></div>
          ${card && card.iccid ? `<div class="esm-kv"><span>ICCID</span><b class="esm-mono" data-noi18n>${esc(fmtIccid(card.iccid))}</b></div>` : ''}
        </div>
        <div class="esm-pick">
          <div class="esm-sec">Etiqueta</div>
          <div class="esm-chips">${STD.filter(s => s !== 'Principal' || !hasOthers).map(s => `<div class="esm-chip" data-l="${esc(s)}" role="button">${esc(s)}</div>`).join('')}<div class="esm-chip esm-chip-c" data-l="" role="button">${g('pen', 13)}<span>Outra</span></div></div>
          <div class="esm-dots">${COLORS.map(cl => `<div class="esm-dot" data-c="${cl}" role="button" style="--esm-c:${cl}"><i></i></div>`).join('')}</div>
          ${hasOthers ? '<div class="esm-defrow"><span>Usar como linha predefinida</span></div>' : ''}
        </div>
        <div class="esm-btns"><div class="esm-btn esm-cancel" role="button">Cancelar</div><div class="esm-btn esm-go" role="button"><i class="esm-spin"></i><span>${esc(A ? 'Adicionar' : 'Ativar eSIM')}</span></div></div>
      </div>`;
      const q = s => actEl.querySelector(s);
      let makeDefault = false;
      if (hasOthers) { const tg = UI.toggle(false, v => { makeDefault = !!v; }); q('.esm-defrow').appendChild(tg); }
      const pv = () => {
        const line = { label, color, slot };
        q('.esm-pv-tag').innerHTML = tag(line, { size: 'sm' }); q('.esm-pv-lab').textContent = labelText(label);
        q('.esm-pv-num').textContent = preNum ? ph(preNum) : T('Número novo');
        actEl.querySelectorAll('.esm-chip').forEach(c => c.classList.toggle('esm-sel', c.dataset.l ? c.dataset.l === label : !isStd(label)));
        const cc = q('.esm-chip-c span'); if (cc) cc.textContent = isStd(label) ? T('Outra') : label;
        actEl.querySelectorAll('.esm-dot').forEach(d => d.classList.toggle('esm-sel', d.dataset.c === color));
      };
      pv();
      q('.esm-chips').onclick = async e => { const c = e.target.closest('.esm-chip'); if (!c || busy) return; snd('click');
        if (c.dataset.l) { label = c.dataset.l; pv(); return; }
        const n = await UI.prompt(T('Etiqueta personalizada'), T('Até 16 letras.'), T('Ex.: Loja'), isStd(label) ? '' : label);
        if (n == null) return; const s = n.replace(/[<>"]/g, '').trim().slice(0, 16); if (s) { label = s; pv(); } };
      q('.esm-dots').onclick = e => { const d = e.target.closest('.esm-dot'); if (!d || busy) return; snd('tick'); color = d.dataset.c; pv(); };
      q('.esm-cancel').onclick = () => { if (busy) return; snd('click'); if (actEl.classList.contains('esm-done')) close(true); else close(false); };
      let busy = false, doneLine = null;
      q('.esm-go').onclick = async () => {
        if (busy) return;
        if (actEl.classList.contains('esm-done')) { snd('click'); close(true); return; }
        if (window.CC && CC.requireNet && !CC.requireNet(T('ativar o eSIM'))) return;
        busy = true; actEl.classList.add('esm-busy'); q('.esm-go span').textContent = T('A ativar…'); snd('click');
        const t0 = Date.now();
        let r = null; try { r = await Bridge.rpcRaw('sim.activate', { iccid: card.iccid || null, slot: card.slot != null ? card.slot : null, label, color }); } catch (e) { r = null; }
        await new Promise(res => setTimeout(res, Math.max(0, 900 - (Date.now() - t0))));   /* a ativação nunca "pisca": pelo menos ~1 s de "A ativar…" */
        if (dead) return;
        if (!r || r.error || r.ok === false) {
          busy = false; actEl.classList.remove('esm-busy'); q('.esm-go span').textContent = A ? T('Adicionar') : T('Ativar eSIM');
          snd('error'); UI.alert({ title: T('Não foi possível ativar'), msg: errText(r || { error: 'timeout' }) });
          return;
        }
        doneLine = r.line ? normLine(r.line, 0, null) : null;
        if (!apply(r.state || r)) await refresh(true);
        const num = (doneLine && doneLine.number) || (st.lines.find(l => l.label === label) || {}).number || '';
        if (makeDefault && num && st.active !== num) await act('sim.switch', { number: num });
        busy = false; actEl.classList.remove('esm-busy'); actEl.classList.add('esm-done');
        q('.esm-act-t').textContent = T('eSIM ativado');
        q('.esm-act-s').textContent = num ? TF('O número %s já funciona neste telemóvel.', ph(num)) : T('A linha nova já funciona neste telemóvel.');
        if (num) q('.esm-pv-num').textContent = ph(num);
        q('.esm-go span').textContent = T('Concluído');
        snd('payment');
        Bridge.call('simScanStop', { activated: true });   /* o cartão sai da mão já aqui; o close() volta a dizer, sem efeito */
      };
      requestAnimationFrame(() => requestAnimationFrame(() => actEl.classList.add('esm-in')));
    }

    /* ---------- arranque: o cliente põe o cartão na mão e aponta a câmara; depois de scanSeconds, bloqueia ---------- */
    /* No jogo: o servidor confirma ANTES que ha cartao e espaco para mais uma linha e reserva o numero (sim.preview, server/sim.lua).
       Vindo das Definicoes nao se sabe que cartao e: o preview escolhe-o e devolve o numero que vai ficar. */
    const preview = (window.Bridge && Bridge.inFiveM) ? Bridge.rpcRaw('sim.preview', { slot: card.slot != null ? card.slot : null, iccid: card.iccid || null }).catch(() => null) : Promise.resolve(null);
    preview.then(p => {
      if (dead) return null;
      if (p && (p.error || p.ok === false)) return { ok: false, error: errCode(p) };
      if (p && p.ok) { card.number = card.number || p.number; card.iccid = card.iccid || p.iccid; if (card.slot == null && p.cardSlot != null) card.slot = p.cardSlot; }
      return ncall('simScanStart', { from: opts.from || 'item', slot: card.slot != null ? card.slot : null, iccid: card.iccid || null }, 8000);
    }).then(r => {
      if (dead || r === null) return;
      if (r && r.prop === false) mock.classList.remove('esm-off');   /* sem o modelo 3D na mao: o cartao desenha-se no visor */
      if (dead) return;
      if (r && (r.ok === false || r.error)) {
        close(false);
        snd('error');
        if (errCode(r) === 'noitem') UI.alert({ title: T('Sem cartão eSIM'), msg: T('Compra um cartão eSIM numa loja de telemóveis e lê o código QR com a câmara para ativar uma linha.') });
        else if (errCode(r) === 'max') UI.alert({ title: T('Limite de linhas'), msg: errText(r) });
        else UI.toast(errText(r, 'A câmara não arrancou.'));
        return;
      }
      /* o cartão que o item usado mandou (sim:scan) ganha; o cliente só completa o que faltar (Definições › Adicionar eSIM: tudo dele) */
      if (r && r.card && typeof r.card === 'object') { const mine = {}; Object.keys(card).forEach(k => { if (card[k] != null && card[k] !== '') mine[k] = card[k]; }); card = Object.assign({}, r.card, mine); }
      if (r && r.qr && typeof r.qr === 'object') card.qr = r.qr;
      const secs = +(r && r.scanSeconds) || +opts.scanSeconds || st.scanSeconds || 1.6;
      root.classList.add('esm-ready');
      /* modo 'desk' (por omissão): o cartão desenha-se DENTRO do visor, por cima da vista do jogo escurecida, com o código
         já na moldura; nada de medidas entre o ecrã do jogo e o telemóvel (o zoom do aparelho mede-se mal no CEF do jogo) */
      if (!(r && r.view === 'camera')) { root.classList.add('esm-deskmode'); mock.classList.remove('esm-off'); }
      if (!mock.classList.contains('esm-off')) mock.querySelector('.esm-hold').innerHTML = cardHtml(card.iccid || '8935100000000000000', card.number);
      timer = setTimeout(lock, Math.max(.8, Math.min(5, secs)) * 1000);
    });
    return api;
  }

  /* ---------- pushes ---------- */
  Bridge.on('sim:changed', d => { if (d && typeof d === 'object' && (d.lines !== undefined)) { lastFetch = Date.now(); apply(d); } else refresh(true); });
  Bridge.on('sim:scan', d => {
    d = d || {};
    const go = () => scan({ from: 'item', slot: d.slot, iccid: d.iccid, number: d.number, scanSeconds: d.scanSeconds });
    if (!(window.System && System.account)) { UI.toast(T('Configura o telemóvel primeiro.')); Bridge.call('simScanStop', { activated: false }); return; }
    const later = () => { if (window.System && System.locked && window.Lock && Lock.requestUnlock) Lock.requestUnlock(go); else go(); };
    /* o estado pode ainda não ter chegado (primeira abertura): pede-se antes, para o limite de linhas valer */
    refresh().then(later, later);
  });
  /* mensagem numa linha que não é a ativa: a contagem por ler dessa linha sobe já (o seletor das Mensagens mostra o ponto) */
  Bridge.on('message', m => { if (!m || !m.line || (m.app && m.app !== 'sms')) return; const l = byNumber(m.line.number); if (l && !l.active && m.sender !== st.active) { l.unread++; changed(); } });
  Bridge.on('ready', () => setTimeout(() => refresh(true), 1200));
  Bridge.on('session:changed', () => { st.loaded = false; st.avail = false; st.lines = []; st.active = null; lastFetch = 0; changed(); setTimeout(() => refresh(true), 1400); });
  Bridge.on('phone:open', () => { refresh(); });

  /* ============================================================
     MOCKS (browser / harness): os mesmos nomes do servidor e do cliente
     #esim=none (obrigatório, sem linha) · req (obrigatório, 1 linha) · 2 · 3 (linhas) · max1 · noitem
     ============================================================ */
  const flag = () => { const m = /(^|[#&])esim=([\w-]+)/.exec(location.hash || ''); return m ? m[2] : ''; };
  const MK = { init: false, required: false, max: 3, allowRemove: true, scanSeconds: 1.6, active: null, lines: [], noitem: false };
  function mkInit() {
    if (MK.init) return; MK.init = true;
    const f = flag(), me = (window.LocalDB && LocalDB.player && LocalDB.player().phone) || '555-0142', now = Date.now();
    MK.required = f === 'none' || f === 'req'; MK.max = f === 'max1' ? 1 : 3; MK.noitem = f === 'noitem';
    const L1 = { number: me, label: 'Principal', color: '#0A84FF', slot: 1, iccid: '8935100000000000142', source: 'legacy', created: now - 40 * 864e5, unread: 0 };
    const L2 = { number: '555-0199', label: 'Trabalho', color: '#FF9F0A', slot: 2, iccid: '8935100000418820199', source: 'esim', created: now - 6 * 864e5, unread: 2 };
    const L3 = { number: '555-0177', label: 'Pessoal', color: '#30D158', slot: 3, iccid: '8935100000733510177', source: 'esim', created: now - 2 * 864e5, unread: 0 };
    MK.lines = f === 'none' ? [] : f === '2' ? [L1, L2] : f === '3' ? [L1, L2, L3] : [L1];
    MK.active = MK.lines.length ? MK.lines[0].number : null;
  }
  const mkState = () => ({ required: MK.required, max: MK.max, allowRemove: MK.allowRemove, scanSeconds: MK.scanSeconds, active: MK.active, lines: MK.lines.map(l => Object.assign({}, l, { active: l.number === MK.active })) });
  const mkPush = () => setTimeout(() => Bridge.emit('sim:changed', mkState()), 0);
  const mkSetPhone = n => { try { const p = LocalDB.player(); p.phone = n || ''; LocalDB.savePlayer(p); } catch (e) {} };
  const MOCKCALL = {
    simScanStart: () => { mkInit(); if (MK.noitem) return { ok: false, error: 'noitem' }; if (MK.lines.length >= MK.max) return { ok: false, error: 'max' };
      return { ok: true, card: { slot: 7, iccid: '89351000' + String(Math.floor(1e10 + Math.random() * 9e10)).slice(0, 11), number: null }, scanSeconds: MK.scanSeconds }; },
    simScanStop: () => ({ ok: true }),
  };
  if (!Bridge.inFiveM && window.LocalDB && LocalDB.register) {
    const R = LocalDB.register;
    R('sim.lines', () => { mkInit(); return mkState(); });
    R('sim.config', () => { mkInit(); return { ok: true, required: MK.required, hasCard: !MK.noitem, carrier: 'Apex Mobile', max: MK.max }; });
    R('sim.switch', d => { mkInit(); const l = MK.lines.find(x => x.number === String(d.number)); if (!l) return { error: 'notfound' }; MK.active = l.number; l.unread = 0; mkSetPhone(l.number); mkPush(); return Object.assign({ ok: true }, mkState()); });
    R('sim.rename', d => { mkInit(); const l = MK.lines.find(x => x.number === String(d.number)); if (!l) return { error: 'notfound' }; const lb = String(d.label || '').trim().slice(0, 24); if (lb) l.label = lb; if (HEX.test(d.color || '')) l.color = d.color; mkPush(); return { ok: true }; });
    R('sim.remove', d => { mkInit(); if (!MK.allowRemove) return { error: 'forbidden' }; const i = MK.lines.findIndex(x => x.number === String(d.number)); if (i < 0) return { error: 'notfound' };
      MK.lines.splice(i, 1); if (MK.active === String(d.number)) { MK.active = MK.lines.length ? MK.lines[0].number : null; mkSetPhone(MK.active); } mkPush(); return Object.assign({ ok: true }, mkState()); });
    R('sim.activate', d => { mkInit(); if (MK.noitem) return { error: 'noitem' }; if (MK.lines.length >= MK.max) return { error: 'max' };
      let n; do { n = '555-0' + String(100 + Math.floor(Math.random() * 900)); } while (MK.lines.some(l => l.number === n));
      const slot = [1, 2, 3, 4].find(s => !MK.lines.some(l => l.slot === s)) || MK.lines.length + 1;
      const line = { number: n, label: String(d.label || 'Pessoal').slice(0, 24), color: HEX.test(d.color || '') ? d.color : COLORS[slot - 1], slot, iccid: String(d.iccid || '8935100000999999999'), source: 'esim', created: Date.now(), unread: 0 };
      MK.lines.push(line); if (!MK.active) { MK.active = n; mkSetPhone(n); } mkPush(); return Object.assign({ ok: true, line: Object.assign({}, line, { active: MK.active === n }) }, mkState()); });
  }

  return { refresh, noSim, require, lines, active: activeLine, isInactive, byNumber, tag, notifTag, callTag, mount, page, scan, openSettings, alertNoSim, labelText, switchTo,
    get state() { return st; }, get scanning() { return scanning ? scanning.api : null }, STD, COLORS, _mock: MK, _apply: apply };
})();
