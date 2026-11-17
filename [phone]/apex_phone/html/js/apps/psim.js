/* ============================================================
   PSIM - SIM FISICO (Config.PhysicalSim, server/psim.lua, 5 out 2026). DESLIGADO por omissao.
   Com o SIM fisico ligado o sim.lines (js/apps/esim.js) chega com `physical: true`, a ranhura do telemovel na mao
   (`tray`) e os cartoes SIM do inventario (`cards`). Este ficheiro so desenha:
     · Definicoes > Servico movel (PearOS) / Ligacoes > Gestor de SIM (Nova UI): a ranhura com o cartao (ou vazia),
       o numero, o ICCID, "Inserir SIM" (escolhe um cartao do inventario) e "Ejetar SIM" (volta para o inventario)
     · a folha "Inserir SIM" que o aviso "Sem SIM" das apps abre (ESim.openSettings)
   O "Sem SIM" da barra de estado, das Mensagens, do Telefone e do Zapp e o do esim.js (noSim()), sem nada novo.
   Contrato: RPC psim.insert { slot, iccid } / psim.eject {} -> o estado inteiro (como o sim.lines) | { error }
             push sim:changed { state | campos do estado } (o esim.js aplica)
   Constroi UMA vez; acerta no sitio quando o estado muda (esim:state). Prefixo CSS psm- (css/app-psim.css).
   Fora do jogo: mocks com #psim=in | none | cards (o mesmo contrato).
   ============================================================ */
window.PSim = (() => {
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
  const esc = s => (window.UI && UI.esc ? UI.esc(s) : String(s == null ? '' : s));
  const isA = () => !!(window.System && System.os === 'android');
  const ph = n => (window.UI && UI.phone ? UI.phone(n) : String(n || ''));
  const snd = n => { try { if (window.Sound) Sound.play(n); } catch (e) {} };
  const st = () => (window.ESim ? ESim.state : null) || {};
  const tail = s => { const d = String(s || '').replace(/\D/g, ''); return d ? 'ICCID …' + d.slice(-4) : ''; };
  const fmtIccid = s => String(s || '').replace(/\D/g, '').replace(/(\d{4})(?=\d)/g, '$1 ');

  const ERR = { nophone: 'Precisas de um telemóvel para pôr o SIM.', slotfull: 'Este telemóvel já tem um SIM. Tira-o primeiro.', full: 'Não tens espaço para o cartão SIM.',
    dupe: 'Este cartão SIM não funciona.', taken: 'O número deste cartão já está a ser usado.', empty: 'Este telemóvel não tem SIM.', noitem: 'O cartão SIM já não está no inventário.',
    busy: 'Espera um instante e tenta outra vez.', ratelimit: 'Demasiados pedidos, espera um instante.', locked: 'Desbloqueia o telemóvel primeiro.', internal: 'Erro no servidor.', timeout: 'O servidor não respondeu.',
    /* 1.3.0: recuperar um número perdido */
    blocked: 'Este cartão SIM foi cancelado pela operadora.', notmine: 'Esse número não é teu.', notlost: 'Já tens esse número contigo.', funds: 'Não tens saldo para recuperar o número.', disabled: 'A recuperação de números está desligada.', db: 'Erro na base de dados.' };
  const errText = (r, fb) => T((r && ERR[r.error]) || fb || 'Não foi possível concluir.');

  let busy = false;
  async function act(name, data) {
    if (busy) return null;
    busy = true;
    let r = null;
    try { r = await Bridge.rpcRaw(name, data || {}); } catch (e) { r = null; }
    busy = false;
    if (!r || r.error || r.ok === false) return { ok: false, r: r || { error: 'timeout' } };
    if (window.ESim) { if (!ESim._apply(r.state || r)) await ESim.refresh(true); }
    return { ok: true, r };
  }

  /* ---------- tirar o SIM ---------- */
  async function eject() {
    const s = st(), tr = s.tray || {};
    if (!tr.inserted) { UI.toast(T('Este telemóvel não tem SIM.')); return false; }
    const ok = await UI.confirm(T('Ejetar SIM'), TF('O cartão SIM %s volta para o inventário. Este telemóvel fica sem número até meteres outro cartão.', ph(tr.number)), T('Ejetar SIM'), true);
    if (!ok) return false;
    const res = await act('psim.eject', {});
    if (!res) return false;
    if (!res.ok) { snd('error'); UI.toast(errText(res.r, 'Não foi possível tirar o SIM.')); return false; }
    snd('tick'); UI.toast(TF('SIM retirado: %s', ph(res.r.ejected || tr.number)));
    return true;
  }

  /* ---------- meter um cartao do inventario ---------- */
  async function insertSheet() {
    if (window.ESim) await ESim.refresh(true);
    const s = st();
    if (!s.physical) return false;
    if (s.tray && s.tray.inserted) { UI.toast(T('Este telemóvel já tem um SIM. Tira-o primeiro.')); return false; }
    const cards = (s.cards || []).filter(c => c && c.slot != null);
    if (!cards.length) {
      snd('error');
      UI.alert({ title: T('Sem cartões SIM'), msg: T('Não tens nenhum cartão SIM no inventário. Compra um numa loja de telemóveis.') });
      return false;
    }
    const pick = await UI.actionSheet({ title: T('Escolhe o cartão SIM'), buttons: cards.map(c => ({ label: (c.number ? ph(c.number) : T('Cartão SIM novo')) + (c.iccid ? '  ·  ' + tail(c.iccid) : ''), icon: 'sim', value: c })) });
    if (!pick) return false;
    const res = await act('psim.insert', { slot: pick.slot, iccid: pick.iccid || null });
    if (!res) return false;
    if (!res.ok) { snd('error'); UI.toast(errText(res.r, 'Não foi possível pôr o SIM.')); return false; }
    snd('success'); UI.toast(TF('SIM inserido: %s', ph(res.r.inserted || (st().active || ''))));
    return true;
  }

  /* ---------- 1.3.0: recuperar um numero perdido (Config.PhysicalSim.recover) ----------
     O telemovel foi roubado/perdido com o SIM la dentro: a operadora cancela o cartao antigo e da um cartao novo com o MESMO
     numero (mensagens, chamadas e, com contactsOnSim, os contactos ficam). O servidor diz quais os numeros desta personagem
     que nao estao a mao (state.recover.numbers) e o preco; o cartao novo vai logo para a ranhura vazia do telemovel na mao. */
  const money = v => (window.UI && UI.money ? UI.money(v) : String(v));
  async function recoverSheet() {
    if (window.ESim) await ESim.refresh(true);
    const s = st(), rc = s.recover || {};
    const nums = (rc.numbers || []).filter(x => x && x.number);
    if (!rc.enabled) { UI.toast(T('A recuperação de números está desligada.')); return false; }
    if (!nums.length) { UI.alert({ title: T('Nada para recuperar'), msg: T('Todos os teus números estão contigo: no telemóvel que tens na mão ou em cartões no inventário.') }); return false; }
    const pick = nums.length === 1 ? nums[0] : await UI.actionSheet({ title: T('Que número queres recuperar?'), buttons: nums.map(x => ({ label: ph(x.number) + '  ·  ' + T(x.where === 'device' ? 'noutro telemóvel' : 'cartão perdido'), icon: 'sim', value: x })) });
    if (!pick) return false;
    const price = +rc.price || 0;
    const ok = await UI.confirm(T('Recuperar número'), price > 0
      ? TF('A operadora cancela o cartão antigo e dá-te um cartão SIM novo com o número %s por %s. O cartão antigo deixa de funcionar.', ph(pick.number), money(price))
      : TF('A operadora cancela o cartão antigo e dá-te um cartão SIM novo com o número %s. O cartão antigo deixa de funcionar.', ph(pick.number)), T('Recuperar'));
    if (!ok) return false;
    const tr = s.tray || {};
    const res = await act('psim.recover', { number: pick.number, insert: !tr.inserted });
    if (!res) return false;
    if (!res.ok) { snd('error'); UI.toast(errText(res.r, 'Não foi possível recuperar o número.')); return false; }
    snd('success');
    UI.toast(res.r.inserted ? TF('Número recuperado e já no telemóvel: %s', ph(res.r.recovered || pick.number)) : res.r.delivered === false ? TF('Número recuperado: %s · o cartão chega quando tiveres espaço no inventário', ph(pick.number)) : TF('Número recuperado: %s · o cartão está no inventário', ph(res.r.recovered || pick.number)));
    return true;
  }

  /* ============================================================
     DEFINICOES: a ranhura (substitui a pagina do eSIM quando o servidor esta em modo fisico)
     ============================================================ */
  function page(ctx) {
    const { sub } = ctx; const A = isA();
    const S = System.state;
    const netPatch = (k, v) => (window.CC && CC.netPatch) ? CC.netPatch(k, v) : { [k]: v };
    return sub(A ? 'Gestor de SIM' : 'Serviço móvel', (c, v) => {
      c.classList.add('esm-page', 'psm-page');
      const hero = UI.el(`<div class="psm-hero">
        <div class="psm-tray"><i class="psm-pin"></i><div class="psm-bay"><div class="psm-card"><i class="psm-chip"></i></div></div></div>
        <b class="psm-title"></b><span class="psm-sub" data-noi18n></span></div>`);
      c.appendChild(hero);
      const title = hero.querySelector('.psm-title'), subEl = hero.querySelector('.psm-sub');
      /* acoes: so uma a vista de cada vez (com SIM: Ejetar; sem SIM: Inserir) */
      /* (um grupo por acao: uma linha escondida no mesmo grupo deixava o separador da outra a vista na Nova UI) */
      const ins = UI.el('<div class="group psm-act"></div>'), ej = UI.el('<div class="group psm-act"></div>');
      ins.appendChild(UI.item({ label: 'Inserir SIM', cls: 'blue center', chevron: false, onTap: () => { snd('click'); insertSheet(); } }));
      ej.appendChild(UI.item({ label: 'Ejetar SIM', cls: 'danger center', chevron: false, onTap: () => { snd('click'); eject(); } }));
      const actFoot = UI.el('<div class="group-footer psm-foot"></div>');
      c.append(ins, ej, actFoot);
      /* 1.3.0: numeros perdidos desta personagem (so aparece quando ha algum) */
      const rec = UI.el('<div class="group psm-act psm-rec"></div>');
      const recItem = UI.item({ label: 'Recuperar o meu número', sub: ' ', cls: 'blue', chevron: true, onTap: () => { snd('click'); recoverSheet(); } });
      rec.appendChild(recItem);
      const recFoot = UI.el('<div class="group-footer psm-recfoot"></div>');
      c.append(rec, recFoot);
      /* dados do cartao */
      const detHead = UI.el(`<div class="group-header">${esc(A ? 'Cartão SIM' : 'SIM')}</div>`);
      const det = UI.el('<div class="group psm-det"></div>');
      const rNum = UI.item({ label: 'Número de telefone', value: ' ', chevron: false });
      const rIcc = UI.item({ label: 'ICCID', value: ' ', chevron: false, cls: 'esm-iccid' });
      const rCar = UI.item({ label: 'Operadora', value: ' ', chevron: false });
      [rNum, rIcc].forEach(li => { const vv = li.querySelector('.li-value'); if (vv) vv.setAttribute('data-noi18n', ''); });
      det.append(rNum, rIcc, rCar);
      c.append(detHead, det);
      const devGrp = UI.list([{ items: [{ label: 'Dados móveis', sub: A ? 'Rede móvel da Apex Mobile' : '', toggle: !!S.cellular, onToggle: x => System.setState(netPatch('cellular', x)) }] }]);
      c.appendChild(devGrp);
      const devFoot = UI.el('<div class="group-footer psm-devfoot"></div>');
      c.appendChild(devFoot);
      const setVal = (li, t) => { const val = li.querySelector('.li-value'), ou = li.querySelector('.ou-val'); if (val) val.textContent = t; if (ou) ou.textContent = t; };
      let sig = '';
      const paint = () => {
        const s = st(), tr = s.tray || {};
        const on = !!tr.inserted;
        const rc = s.recover || {}, lost = (rc.numbers || []).filter(x => x && x.number);
        const k = JSON.stringify([on, tr.number, tr.iccid, tr.label, tr.foreign, s.carrier, (s.cards || []).length, A ? 1 : 0, s.contactsOnSim ? 1 : 0, rc.enabled ? 1 : 0, +rc.price || 0, lost.map(x => x.number).join(',')]);
        if (k === sig) return; sig = k;
        hero.classList.toggle('psm-on', on);
        title.textContent = on ? T('SIM inserido') : T('Sem SIM');
        subEl.textContent = on ? ph(tr.number) : T('Mete um cartão SIM do teu inventário.');
        ins.classList.toggle('esm-off', on); ej.classList.toggle('esm-off', !on);
        const n = (s.cards || []).length;
        actFoot.textContent = on ? (s.contactsOnSim ? T('O número e os contactos vão com o cartão: noutro telemóvel, as chamadas, as mensagens e os contactos passam para lá. As fotos ficam neste telemóvel.')
            : T('O número vai com o cartão: noutro telemóvel, as chamadas e as mensagens passam para lá. Os contactos e as fotos ficam neste telemóvel.'))
          : n ? TF('Tens %s no inventário.', n === 1 ? T('1 cartão SIM') : TF('%s cartões SIM', String(n))) : T('Não tens nenhum cartão SIM no inventário.');
        /* 1.3.0: recuperar um numero perdido */
        const showRec = !!rc.enabled && lost.length > 0;
        rec.classList.toggle('esm-off', !showRec); recFoot.classList.toggle('esm-off', !showRec);
        if (showRec) {
          const sub = recItem.querySelector('.li-sub') || recItem.querySelector('.ou-sub');
          if (sub) sub.textContent = lost.length === 1 ? ph(lost[0].number) : TF('%s números', String(lost.length));
          recFoot.textContent = (+rc.price > 0 ? TF('Perdeste o telemóvel com o SIM lá dentro? A operadora cancela o cartão antigo e dá-te um novo com o mesmo número por %s.', money(+rc.price)) : T('Perdeste o telemóvel com o SIM lá dentro? A operadora cancela o cartão antigo e dá-te um novo com o mesmo número.'))
            + ' ' + (s.contactsOnSim ? T('As mensagens e os contactos ficam.') : T('As mensagens ficam.'));
        }
        [detHead, det].forEach(x => x.classList.toggle('esm-off', !on));
        if (on) { setVal(rNum, ph(tr.number)); setVal(rIcc, fmtIccid(tr.iccid)); }
        setVal(rCar, s.carrier || 'Apex Mobile');
        devFoot.textContent = tr.label ? (tr.foreign ? TF('Ranhura do %s (telemóvel de outra pessoa).', tr.label) : TF('Ranhura do %s.', tr.label)) : '';
        devFoot.classList.toggle('esm-off', !tr.label);
      };
      paint();
      const off = Bridge.on('esim:state', () => { if (c.isConnected) paint(); });
      const prev = v.opts.onPop; v.opts.onPop = () => { try { off(); } catch (e) {} if (prev) prev(); };
      if (window.ESim) ESim.refresh(true);
    }, ctx.from ? { from: ctx.from } : {});
  }

  /* ============================================================
     MOCKS (browser / harness): #psim=in (com SIM) · none (sem SIM, 2 cartoes no inventario) · cards (sem SIM, 1 cartao)
     ============================================================ */
  const flag = () => { const m = /(^|[#&])psim=([\w-]+)/.exec(location.hash || ''); return m ? m[2] : ''; };
  if (!Bridge.inFiveM && window.LocalDB && LocalDB.register && flag()) {
    const f = flag(), me = (LocalDB.player && LocalDB.player().phone) || '555-0142';
    const MK = { sim: f === 'in' ? { number: me, iccid: '8935100000418820142' } : null,
      cards: f === 'none' ? [{ slot: 4, number: '555-0187', iccid: '8935100000733510187' }, { slot: 9, number: '555-0230', iccid: '8935100000512240230' }]
        : f === 'cards' ? [{ slot: 4, number: '555-0187', iccid: '8935100000733510187' }] : [] };
    /* 1.3.0: um numero perdido (noutro telemovel) para o fluxo "Recuperar o meu numero" */
    MK.lost = [{ number: '555-0909', where: 'device' }];
    const state = reason => ({ ok: true, physical: true, reason, required: true, max: 1, allowRemove: false, canAdd: false,
      recover: { enabled: true, price: 100, numbers: MK.lost.slice() }, contactsOnSim: true,
      active: MK.sim ? MK.sim.number : null, nosim: !MK.sim,
      lines: MK.sim ? [{ number: MK.sim.number, slot: 1, label: 'Principal', iccid: MK.sim.iccid, source: 'sim', color: '#1F5EFF', active: true, unread: 0 }] : [],
      tray: { device: true, item: 'pear18_black', label: 'PearPhone 18 Pro Max', serial: 'APX-1A2B-3C4D-5E6F', foreign: false, inserted: !!MK.sim, number: MK.sim && MK.sim.number, iccid: MK.sim && MK.sim.iccid },
      cards: MK.cards.slice(), esim: 'slot', item: 'sim_card', carrier: 'Apex Mobile', scanSeconds: 1.6 });
    const setPhone = n => { try { const p = LocalDB.player(); p.phone = n || ''; LocalDB.savePlayer(p); } catch (e) {} };
    if (!MK.sim) setPhone('');
    const R = LocalDB.register;
    R('sim.lines', () => state('state'));
    R('psim.state', () => state('state'));
    R('psim.insert', d => { if (MK.sim) return { ok: false, error: 'slotfull' }; const i = MK.cards.findIndex(c => c.slot === d.slot); if (i < 0) return { ok: false, error: 'noitem' };
      MK.sim = MK.cards.splice(i, 1)[0]; setPhone(MK.sim.number); const s = state('insert'); s.inserted = MK.sim.number; return s; });
    R('psim.eject', () => { if (!MK.sim) return { ok: false, error: 'empty' }; const old = MK.sim; MK.cards.push({ slot: 12, number: old.number, iccid: old.iccid }); MK.sim = null; setPhone(''); const s = state('eject'); s.ejected = old.number; return s; });
    R('psim.recoverable', () => ({ ok: true, enabled: true, price: 100, numbers: MK.lost.slice() }));
    R('psim.recover', d => { const i = MK.lost.findIndex(x => x.number === d.number); if (i < 0) return { ok: false, error: 'notmine' }; const n = MK.lost.splice(i, 1)[0].number; const card = { slot: 14, number: n, iccid: '8935100000900000909' };
      let inserted = false; if (d.insert !== false && !MK.sim) { MK.sim = card; setPhone(n); inserted = true; } else MK.cards.push(card);
      const s = state('recover'); s.recovered = n; s.charged = 100; s.inserted = inserted; s.delivered = true; return s; });
  }

  return { page, insertSheet, eject, recoverSheet };
})();
