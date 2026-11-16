/* ===================== SERVIÇOS - pedir polícia/EMS/mecânico/táxi/imobiliária/negócios ===================== */
App.define('services', {
  name: 'Serviços', category: 'Utilitários', needs: ['location'],
  open(win) {
    const g = UI.g; let list = [], tabs; const ST = { pending: 'Pendente', accepted: 'Aceite', done: 'Concluído', cancelled: 'Cancelado' };
    /* 1.5.2 (cliente: "police dispatch does not say police it says Policia"): o nome do serviço vem do Config.Services em
       português ('Polícia'). Sozinho o tradutor do DOM troca-o, mas DENTRO de uma frase ("Não há %s em serviço") fica como
       veio (o padrão só traduz nomes de apps apanhados): aqui traduz-se o nome e monta-se a frase pela chave exata. */
    const T = s => (window.L && L.t ? L.t(s) : s), TF = (k, ...a) => (window.L && L.tf ? L.tf(k, ...a) : k.replace(/%s/g, () => a.shift()));
    const load = async () => { list = (await Bridge.rpc('services.list')) || []; return list; };
    const job = () => (System.player.job || {}).name;
    async function request(s) {
      const body = UI.el(`<div><div class="group" style="padding:12px"><textarea class="ta desc" style="min-height:110px" placeholder="Descreve o que precisas (ex.: carro avariado na Route 68)"></textarea></div></div>`);
      body.appendChild(UI.list([{ items: [{ label: 'Enviar a minha localização', toggle: true, onToggle: v => body.loc = v }] }, { footer: TF('O pedido é enviado a todos os %s em serviço.', T(s.label)) }])); body.loc = true;
      UI.sheet({ title: s.label, left: 'Cancelar', right: 'Pedir', body, onDone: () => { const d = body.querySelector('.desc').value.trim(); if (!d) { UI.toast('Escreve uma descrição'); return false; }
        /* rpcRaw: no jogo o Bridge.rpc troca { error } por null e perdia-se o 'nobody'/'cooldown' do servidor */
        (async () => { const coords = body.loc ? await Bridge.call('getCoords') : null; const r = await Bridge.rpcRaw('services.request', { service: s.id, description: d, coords }); if (r && !r.error) { Sound.play('success'); UI.banner({ app: 'services', title: s.label, msg: 'Pedido enviado. Vais ser notificado quando for aceite.' }); tabs.go(1); } else UI.alert({ title: 'Não foi possível enviar', msg: r && r.error === 'nobody' ? TF('Não há %s em serviço neste momento.', T(s.label)) : r && r.error === 'cooldown' ? `Espera ${Math.max(1, Math.ceil(Number(r.wait) || 1))} s antes de pedir outra vez.` : 'Tenta novamente.' }); })(); } });
    }
    const home = () => { const v = UI.view({ title: 'Serviços', large: true }); const grid = UI.el('<div class="svc-grid"></div>'); v.content.appendChild(UI.el('<div class="group-footer" style="padding-top:0">Pede ajuda ou serviços aos profissionais em serviço.</div>')); v.content.appendChild(grid);
      load().then(() => { grid.innerHTML = ''; list.filter(s => !s.business).forEach(s => { const e = UI.el(`<div class="svc" style="background:linear-gradient(160deg,${s.color},${s.color}99)">${g(s.icon)}<div><b>${UI.esc(s.label)}</b><div class="n">Pedir serviço</div></div></div>`); e.onclick = () => request(s); grid.appendChild(e); });
        const biz = list.filter(s => s.business); if (biz.length) { v.content.appendChild(UI.el('<div class="section-title">Negócios</div>')); v.content.appendChild(UI.list([{ items: biz.map(s => ({ icon: s.icon, iconBg: s.color, label: s.label, sub: 'Encomendar / pedir', onTap: () => request(s) })) }])); } });
      return v; };
    const reqCard = (r, mine) => { const s = list.find(x => x.id === r.service) || { label: r.service, color: 'var(--gray)', icon: 'lifebuoy' }; const c = UI.el(`<div class="req"><div class="rt"><span><span>${UI.esc(s.label)}</span>${mine ? '' : ' · <span data-noi18n>' + UI.esc(r.requester_name || r.requester_phone || '') + '</span>'}</span><span class="st ${r.status}">${ST[r.status] || r.status}</span></div><div class="rd">${UI.esc(r.description || '')}</div><div class="rd">${UI.rel(r.created)}${r.accepted_by ? ' · aceite por ' + UI.esc(r.accepted_by) : ''}${r.coords ? ' · 📍 com localização' : ''}</div><div class="ra"></div></div>`);
      const ra = c.querySelector('.ra');
      if (mine && r.status === 'pending') { const b = UI.el('<div class="pill-btn red">Cancelar</div>'); b.onclick = async () => { await Bridge.rpc('services.cancel', { id: r.id }); tabs.go(1); }; ra.appendChild(b); }
      /* o servidor só aceita quem tem o job e está em serviço: o waypoint e o "Aceite" só depois do ok (antes marcava-se sempre) */
      if (!mine && r.status === 'pending') { const b = UI.el('<div class="pill-btn on">Aceitar</div>'); b.onclick = async () => { const res = await Bridge.rpcRaw('services.accept', { id: r.id });
        if (!res || !res.ok) { const why = { job: 'Não és desta profissão', offduty: 'Entra em serviço para aceitar', gone: 'Pedido já aceite ou cancelado', self: 'Não podes aceitar o teu próprio pedido' }; UI.toast(why[res && res.error] || 'Não foi possível aceitar'); tabs.go(2); return; }
        const c = (res.request && res.request.coords) || r.coords; if (c) Bridge.call('setWaypoint', { x: c.x, y: c.y, name: 'Pedido' }); UI.toast(c ? 'Aceite · waypoint marcado' : 'Aceite'); tabs.go(2); }; ra.appendChild(b); }
      if (!mine && r.status === 'accepted') { const b = UI.el('<div class="pill-btn green">Concluir</div>'); b.onclick = async () => { await Bridge.rpc('services.complete', { id: r.id }); tabs.go(2); }; ra.appendChild(b); const w = UI.el('<div class="pill-btn gray">Waypoint</div>'); w.onclick = () => r.coords && Bridge.call('setWaypoint', { x: r.coords.x, y: r.coords.y, name: 'Pedido' }); if (r.coords) ra.appendChild(w); const m = UI.el('<div class="pill-btn gray">Mensagem</div>'); m.onclick = () => r.requester_phone && Msgs.open(r.requester_phone); ra.appendChild(m); }
      if (mine && r.status === 'accepted') { const m = UI.el('<div class="pill-btn gray">A caminho ✓</div>'); ra.appendChild(m); }
      return c; };
    const mine = () => { const v = UI.view({ title: 'Os meus pedidos', large: true }); const h = UI.el('<div></div>'); v.content.appendChild(h); h.appendChild(UI.spinner()); Promise.all([load(), Bridge.rpc('services.mine')]).then(([_, rs]) => { h.innerHTML = ''; rs = rs || []; if (!rs.length) { h.appendChild(UI.empty('lifebuoy', 'Sem pedidos', 'Os teus pedidos aparecem aqui.')); return; } rs.forEach(r => h.appendChild(reqCard(r, true))); }); return v; };
    const work = () => { const v = UI.view({ title: 'Pedidos recebidos', large: true }); const h = UI.el('<div></div>'); v.content.appendChild(h); h.appendChild(UI.spinner()); Promise.all([load(), Bridge.rpc('services.pending')]).then(([_, rs]) => { h.innerHTML = ''; rs = rs || []; const jb = job(); const mineJob = list.find(s => s.job === jb); h.appendChild(UI.el(`<div class="group-footer" style="padding-top:0">${mineJob ? UI.esc(TF('Estás em serviço como %s.', T(mineJob.label))) : 'Aqui aparecem os pedidos para a tua profissão.'}</div>`)); if (!rs.length) { h.appendChild(UI.empty('briefcase', 'Sem pedidos pendentes', 'Os pedidos para a tua profissão aparecem aqui.')); return; } rs.forEach(r => h.appendChild(reqCard(r, false))); }); return v; };
    tabs = UI.tabbar(win, [{ icon: 'lifebuoy', label: 'Serviços', view: home }, { icon: 'list', label: 'Os meus', view: mine }, { icon: 'briefcase', label: 'Trabalho', view: work }], 0);
    /* o servidor manda serviceRequest a TODOS os agentes em serviço dessa profissão: cada push refazia a
       vista (2 queries + a lista toda) mesmo com a app escondida ou fechada. À frente refresca como antes;
       em segundo plano só marca e o resume refresca uma vez ao voltar. */
    const maybe = () => { if (System.currentApp() === 'services') tabs.refresh(); else win._stale = true; };
    const offs = [Bridge.on('serviceUpdate', maybe), Bridge.on('serviceRequest', () => { if (tabs.cur === 2) maybe(); })];
    win._tabs = tabs;
    win.onClose = () => offs.forEach(o => o());
  },
  resume(win) { if (!win._stale) return; win._stale = false; try { win._tabs && win._tabs.refresh(); } catch (e) {} },
});
/* 1.5.2: o título é montado e traduzido AQUI (a notificação guarda o texto escrito; o tradutor do DOM só traduziria "Novo
   pedido · %s" e deixava o nome do serviço em português: "New request · Polícia") */
Bridge.on('serviceRequest', r => { if (!r) return; const L_ = window.L && L.t && L.tf ? L : null; const lb = r.serviceLabel || r.service || ''; Notify.push({ app: 'services', title: L_ ? L_.tf('Novo pedido · %s', L_.t(lb)) : 'Novo pedido · ' + lb, msg: r.description || '', onTap: () => System.openApp('services') }); });
Bridge.on('serviceUpdate', r => { if (!r) return; Notify.push({ app: 'services', title: r.status === 'accepted' ? 'Pedido aceite' : r.status === 'done' ? 'Pedido concluído' : 'Pedido atualizado', msg: (r.accepted_by ? r.accepted_by + ' está a caminho. ' : '') + (r.description || ''), onTap: () => System.openApp('services') }); });
