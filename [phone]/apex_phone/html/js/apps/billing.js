/* ===================== FATURAS (billing) - receber/pagar/recusar, EMITIR (Nova fatura), enviadas, histórico =====================
   Até 2026-09-20 a app só sabia pagar: o RPC bills.create existia no servidor (server/billing.lua, com tecto, intervalo e
   validação do job para faturar em nome da sociedade) e nenhum ecrã o chamava - um mecânico não tinha como passar uma
   fatura pelo telemóvel. Agora há "Nova fatura" (contacto ou número, valor no teclado, motivo, "em nome de <emprego>"),
   o separador "Enviadas" (bills.sent) com anular (bills.cancel) e o estado 'cancelled' nas recebidas. */
App.define('billing', {
  name: 'Faturas', category: 'Finanças',
  actions: [{ label: 'Nova fatura', icon: 'plus', onTap: () => { System.openApp('billing'); setTimeout(() => Bridge.emit('billing:new'), 300); } }],
  open(win) {
    const g = UI.g; let bills = [], sent = []; let tabs;
    const ST = { pending: 'Pendente', paid: 'Paga', refused: 'Recusada', cancelled: 'Anulada' };
    const COL = { pending: 'var(--orange)', paid: 'var(--green)', refused: 'var(--red)', cancelled: 'var(--gray)' };
    const badge = () => System.badge('billing', bills.filter(b => b.status === 'pending').length);
    const load = async () => { bills = (await Bridge.rpc('bills.list')) || []; badge(); return bills; };
    const loadSent = async () => { sent = (await Bridge.rpc('bills.sent')) || []; return sent; };
    const who = b => b.to_name || (window.Contacts && Contacts.byNumber && (Contacts.byNumber(b.to) || {}).name) || UI.phone(b.to) || '--';
    const stEl = s => `<span class="st ${s}">${ST[s] || s}</span>`;

    /* ---------- cartão de uma fatura (recebida ou enviada) ---------- */
    const card = (b, mine) => { const c = UI.el(`<div class="bill"><div class="bi" style="background:${COL[b.status] || 'var(--gray)'}">${g(mine ? 'send' : 'receipt')}</div><div style="min-width:0;flex:1"><div class="bt">${UI.esc(mine ? who(b) : (b.sender_name || b.sender))}</div><div class="bs">${UI.esc(b.reason || (mine ? 'Sem motivo' : ''))}</div><div class="bs">${UI.rel(b.created)}</div></div><div class="ba">${UI.money(b.amount)}<div>${stEl(b.status)}</div></div></div>`); c.onclick = () => (mine ? sentDetail(b) : detail(b)); return c; };

    /* ---------- fatura RECEBIDA ---------- */
    const detail = b => { const v = UI.view({ title: 'Fatura', back: 'Faturas' });
      v.content.appendChild(UI.el(`<div class="card" style="margin-top:14px;text-align:center"><div class="muted small">${UI.esc(b.sender_name || b.sender)}</div><div style="font-size:var(--t-large);font-weight:600;margin:6px 0">${UI.money(b.amount)}</div><span class="st ${b.status}" style="font-size:var(--t-cap1);font-weight:600;padding:3px 10px;border-radius:8px;background:var(--fill3)">${ST[b.status] || b.status}</span></div>`));
      v.content.appendChild(UI.list([{ items: [{ label: 'Motivo', value: b.reason || '--' }, b.society ? { label: 'Em nome de', value: b.society } : null, { label: 'Emitida', value: UI.fmtDate(new Date(b.created), true) + ' ' + UI.fmtTime(new Date(b.created)) }, { label: 'Referência', value: '#' + String(b.id).slice(-6) }, b.paid_at ? { label: 'Paga em', value: UI.fmtDate(new Date(b.paid_at), true) } : null].filter(Boolean) }]));
      if (b.status === 'pending') { const pay = UI.el(`<div class="btn-p green">${g('check', 21)} Pagar ${UI.money(b.amount)}</div>`); pay.onclick = async () => { if (window.CC && CC.requireNet && !CC.requireNet('pagar a fatura')) return; if (!await UI.confirm('Pagar fatura', `${UI.money(b.amount)} a ${b.sender_name || b.sender} (débito na conta)`, 'Pagar')) return; const r = await Bridge.rpcRaw('bills.pay', { id: b.id }); /* rpcRaw: com o rpc o { ok:false, error:'funds' } chegava como null no jogo e dizia sempre 'Tenta novamente' */
        /* 'target' = o emissor já não existe no framework: o dinheiro foi reposto e a fatura FICA pendente
           (billing.lua). Dizer 'Tenta novamente' mandava o jogador repetir uma coisa que falha sempre. */
        if (!r || !r.ok) { UI.alert({ title: 'Pagamento falhou', msg: r && r.error === 'funds' ? 'Saldo insuficiente no banco.' : r && r.error === 'target' ? 'O emissor desta fatura já não existe; a fatura continua pendente.' : r && r.error === 'invalid' ? 'Esta fatura já não está pendente (foi paga ou anulada).' : 'Tenta novamente.' }); Sound.play('error'); tabs.go(tabs.cur); return; } Sound.play('success'); UI.banner({ app: 'billing', title: 'Fatura paga', msg: UI.money(b.amount) + ' · ' + (b.sender_name || b.sender) }); UI.pop(win); tabs.go(tabs.cur); };
        const ref = UI.el('<div class="btn-p gray">Recusar</div>'); ref.onclick = async () => { if (window.CC && CC.requireNet && !CC.requireNet('recusar a fatura')) return; if (!await UI.confirm('Recusar fatura', 'O emissor será notificado.', 'Recusar', true)) return; const r = await Bridge.rpc('bills.refuse', { id: b.id }); /* o servidor recusa se a fatura entretanto deixou de estar pendente: sem isto saía-se do ecrã como se tivesse corrido */ if (!r || !r.ok) { UI.alert({ title: 'Não foi possível recusar', msg: 'A fatura pode já ter sido paga ou anulada.' }); Sound.play('error'); tabs.go(tabs.cur); return; } UI.pop(win); tabs.go(tabs.cur); }; v.content.append(pay, ref); }
      UI.push(win, v); };

    /* ---------- fatura ENVIADA (anular se ainda estiver pendente) ---------- */
    const sentDetail = b => { const v = UI.view({ title: 'Fatura enviada', back: 'Faturas' });
      v.content.appendChild(UI.el(`<div class="card" style="margin-top:14px;text-align:center"><div class="muted small">Para ${UI.esc(who(b))}</div><div style="font-size:var(--t-large);font-weight:600;margin:6px 0">${UI.money(b.amount)}</div><span class="st ${b.status}" style="font-size:var(--t-cap1);font-weight:600;padding:3px 10px;border-radius:8px;background:var(--fill3)">${ST[b.status] || b.status}</span></div>`));
      v.content.appendChild(UI.list([{ items: [{ label: 'Motivo', value: b.reason || '--' }, { label: 'Número', value: UI.phone(b.to) || '--' }, b.society ? { label: 'Em nome de', value: b.sender_name || b.society } : null, { label: 'Emitida', value: UI.fmtDate(new Date(b.created), true) + ' ' + UI.fmtTime(new Date(b.created)) }, { label: 'Referência', value: '#' + String(b.id).slice(-6) }, b.paid_at ? { label: 'Paga em', value: UI.fmtDate(new Date(b.paid_at), true) } : null].filter(Boolean) }, { footer: b.status === 'pending' ? 'O devedor vê esta fatura na app Faturas dele e recebeu um aviso. Podes anulá-la enquanto estiver pendente.' : b.status === 'paid' ? 'O valor entrou ' + (b.society ? 'na conta da sociedade.' : 'na tua conta.') : b.status === 'refused' ? 'O devedor recusou esta fatura.' : 'Anulaste esta fatura.' }]));
      if (b.status === 'pending') { const c = UI.el('<div class="btn-p red">Anular fatura</div>'); c.onclick = async () => { if (!await UI.confirm('Anular fatura', 'O devedor deixa de a ver e é avisado.', 'Anular', true)) return; const r = await Bridge.rpcRaw('bills.cancel', { id: b.id }); if (!r || !r.ok) { UI.alert({ title: 'Não foi possível anular', msg: 'A fatura pode já ter sido paga ou recusada.' }); Sound.play('error'); tabs.go(tabs.cur); return; } UI.toast('Fatura anulada'); UI.pop(win); tabs.go(tabs.cur); }; v.content.appendChild(c); }
      UI.push(win, v); };

    /* ---------- NOVA FATURA ---------- */
    async function compose(preset) {
      if (window.CC && CC.requireNet && !CC.requireNet('emitir uma fatura')) return;
      let to = preset || null, amount = 0, society = false;
      const job = (System.player && System.player.job) || {}; const canSociety = job.name && job.name !== 'unemployed';
      const v = UI.view({ title: 'Nova fatura', back: 'Faturas' });
      const whoEl = UI.el(`<div class="wl-who"><div class="wl-whoin">${g('personCircle', 24)}<input type="text" placeholder="Nome ou número" value="${to ? UI.esc(to.name || to.number) : ''}"><div class="pick">${g('personPlus')}</div></div></div>`);
      const inp = whoEl.querySelector('input'); whoEl.querySelector('.pick').onclick = async () => { const c = await Contacts.pick('Faturar a'); if (c) { to = c; inp.value = c.name || c.number; } }; inp.oninput = () => { const q = inp.value.trim(); const c = window.Contacts && Contacts.byNumber ? Contacts.byNumber(q) : null; to = q ? { number: q, name: (c || {}).name } : null; };
      const amt = UI.el(`<div class="wl-amt"><div class="wl-amtv"><span class="cur">${UI.esc(UI.cur())}</span><span class="val">0</span></div><div class="wl-chips"><span>50</span><span>100</span><span>250</span><span>500</span></div><div class="wl-pad"></div></div>`);
      const paint = () => { amt.querySelector('.val').textContent = amount ? UI.fmtNum(amount) : '0'; };
      amt.querySelectorAll('.wl-chips span').forEach(s => s.onclick = () => { amount = +s.textContent.replace(/\s/g, ''); paint(); Sound.play('click'); });
      const pad = amt.querySelector('.wl-pad'); ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'].forEach(k => { const b = UI.el(`<div class="k ${k === '' ? 'blank' : ''}">${k}</div>`); b.onclick = () => { if (k === '') return; Sound.play('keypad'); if (k === '⌫') amount = Math.floor(amount / 10); else if (amount < 1e6) amount = amount * 10 + +k; paint(); }; pad.appendChild(b); });
      const reason = UI.el('<div class="group" style="margin:8px 16px"><div class="li static"><input type="text" class="reason" placeholder="Motivo (ex.: reparação do carro)" maxlength="60"></div></div>');
      const soc = canSociety ? UI.list([{ items: [{ label: 'Em nome de ' + (job.label || job.name), toggle: false, onToggle: v => { society = !!v; } }], footer: 'Ligado: a fatura sai com o nome da empresa e o valor entra na conta da sociedade. Desligado: sai em teu nome e o dinheiro é teu.' }]) : UI.list([{ footer: 'A fatura sai em teu nome; o valor entra na tua conta quando for paga.' }]);
      const go = UI.el('<div class="btn-p" style="margin-top:10px">Enviar fatura</div>');
      go.onclick = async () => {
        if (!to || !to.number) { UI.toast('Escolhe a quem faturar'); return; }
        if (!(amount > 0)) { UI.toast('Introduz um valor'); return; }
        const reasonV = reason.querySelector('.reason').value.trim();
        const body = UI.el(`<div class="wl-confirm"><div class="wl-cavatar">${UI.avatar({ name: to.name || to.number }, 'lg')}</div><div class="wl-cname">${UI.esc(to.name || to.number)}</div><div class="wl-cnum">${UI.esc(UI.phone(to.number) || to.number)}</div><div class="wl-camt">${UI.money(amount)}</div>${reasonV ? `<div class="wl-cnote">“${UI.esc(reasonV)}”</div>` : ''}</div>`);
        body.appendChild(UI.list([{ items: [{ label: 'Emissor', value: society ? (job.label || job.name) : 'Eu' }, { label: 'Valor', value: UI.money(amount) }] }]));
        UI.sheet({ title: 'Confirmar fatura', left: 'Cancelar', right: 'Enviar', body, onDone: () => { (async () => {
          go.style.opacity = '.5';
          const r = await Bridge.rpcRaw('bills.create', { to: to.number, amount, reason: reasonV, society: society ? job.name : null });
          go.style.opacity = '';
          if (!r || r.error) {
            const E = { amount: 'Valor inválido' + (r && r.max ? ` (máximo ${UI.money(r.max)})` : '.'), target: 'Esse número não existe.', self: 'Não podes faturar a ti próprio.', society: 'Não podes faturar em nome dessa empresa.', grade: 'O teu cargo não permite faturar em nome da empresa.', cooldown: 'Espera uns segundos entre faturas.', noplayer: 'Sem sessão. Tenta novamente.' };
            UI.alert({ title: 'Fatura não enviada', msg: (r && E[r.error]) || 'Tenta novamente.' }); Sound.play('error'); return; }
          Sound.play('success'); UI.banner({ app: 'billing', title: 'Fatura enviada', msg: UI.money(amount) + ' · ' + (to.name || to.number) });
          UI.pop(win); tabs.go(1);
        })(); } });
      };
      v.content.append(whoEl, amt, reason, soc, go); UI.push(win, v); paint(); if (!to) setTimeout(() => inp.focus(), 400);
    }

    /* ---------- listas ---------- */
    const listView = (title, filter, mine) => { const v = UI.view({ title, large: true, right: [{ icon: 'plus', onTap: () => compose() }] }); const holder = UI.el('<div></div>'); v.content.appendChild(holder); holder.appendChild(UI.spinner());
      (mine ? loadSent() : load()).then(() => { holder.innerHTML = ''; const l = (mine ? sent : bills).filter(filter);
        const tot = l.filter(b => b.status === 'pending').reduce((a, b) => a + b.amount, 0);
        if (tot) holder.appendChild(UI.el(`<div class="card" style="margin-bottom:12px"><div class="card-title">${mine ? 'Por receber' : 'Total pendente'}</div><div style="font-size:var(--t-title1);font-weight:600">${UI.money(tot)}</div></div>`));
        if (!l.length) { holder.appendChild(UI.empty(mine ? 'send' : 'receipt', mine ? 'Sem faturas enviadas' : 'Sem faturas', mine ? 'Toca em + para emitir uma fatura a alguém.' : 'As faturas que receberes aparecem aqui.')); return; }
        l.forEach(b => holder.appendChild(card(b, mine))); }); return v; };
    tabs = UI.tabbar(win, [
      { icon: 'receipt', label: 'Pendentes', view: () => listView('Pendentes', b => b.status === 'pending', false) },
      { icon: 'send', label: 'Enviadas', view: () => listView('Enviadas', () => true, true) },
      { icon: 'list', label: 'Histórico', view: () => listView('Histórico', b => b.status !== 'pending', false) },
    ], 0);
    /* PearPhone Fold aberto: as faturas à esquerda, a escolhida (ou a nova) à direita (ui.js UI.split) */
    UI.split(win, { icon: 'receipt', title: 'Nenhuma fatura aberta', sub: 'Escolhe uma fatura da lista ou toca em + para emitir uma nova.', row: '.bill' });
    const offs = [Bridge.on('bill', () => tabs.refresh()), Bridge.on('billing:new', () => compose())];
    win.onClose = () => offs.forEach(o => o());
  }
});
Bridge.on('bill', b => { if (!b) return;
  if (b.cancelled) { Notify.push({ app: 'billing', title: 'Fatura anulada · ' + (b.sender_name || ''), msg: UI.money(b.amount), onTap: () => System.openApp('billing') }); }
  else Notify.push({ app: 'billing', title: 'Nova fatura · ' + (b.sender_name || b.sender), msg: `${UI.money(b.amount)} · ${b.reason || ''}`, onTap: () => System.openApp('billing') });
  Bridge.rpc('bills.list').then(l => System.badge('billing', (l || []).filter(x => x.status === 'pending').length)); });
Bridge.on('ready', () => setTimeout(() => Bridge.rpc('bills.list').then(l => System.badge('billing', (l || []).filter(x => x.status === 'pending').length)), 900));
