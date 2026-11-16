/* ===================== GARAGEM - os meus veículos (player_vehicles), localizar, GPS, alcunhas ===================== */
Icons.app.garage = () => Icons.SVG(Icons.G('gGr', '#6CB8FF', '#2A8BFF', '#0F63EA') + Icons.GL(`<path d="M16 44 50 20l34 24v34H16z" fill="none" stroke="#fff" stroke-width="6.5" stroke-linejoin="round"/><path d="M30 78V50h40v28" fill="none" stroke="#fff" stroke-width="6" stroke-linejoin="round"/><path d="M30 59h40M30 68h40" stroke="#fff" stroke-width="5" stroke-linecap="round"/>`));

App.define('garage', {
  name: 'Garagem', category: 'Utilitários',
  open(win) {
    const g = UI.g; const NAMES = { blista: 'Blista', blista2: 'Blista Compact', buffalo: 'Buffalo', buffalo2: 'Buffalo S', sultan: 'Sultan', sultanrs: 'Sultan RS', banshee: 'Banshee', banshee2: 'Banshee 900R', dominator: 'Dominator', sanchez: 'Sanchez', faggio: 'Faggio', adder: 'Adder', zentorno: 'Zentorno', buccaneer: 'Buccaneer', elegy: 'Elegy RH8', elegy2: 'Elegy Retro', kuruma: 'Kuruma', futo: 'Futo', jester: 'Jester', comet2: 'Comet', infernus: 'Infernus', t20: 'T20', bati: 'Bati 801', pcj: 'PCJ 600', baller: 'Baller', mesa: 'Mesa', sandking: 'Sandking', rebel: 'Rebel', taxi: 'Taxi', police: 'Police Cruiser', ambulance: 'Ambulância', x80: 'X80 Proto', italigtb: 'Itali GTB', panto: 'Panto', issi2: 'Issi', asea: 'Asea', premier: 'Premier', fugitive: 'Fugitive', washington: 'Washington', felon: 'Felon', schafter2: 'Schafter', ztype: 'Z-Type' };
    const name = v => v.nickname || v.label || NAMES[(v.model || '').toLowerCase()] || String(v.model || 'Veículo').replace(/^\w/, c => c.toUpperCase());
    const ST = { 0: ['Fora', 'out'], 1: ['Na garagem', 'in'], 2: ['Apreendido', 'imp'] };
    let list = [], tabs;
    const load = async () => { list = (await Bridge.rpc('garage.vehicles')) || []; System.badge('garage', list.filter(v => v.state === 2).length); return list; };
    /* 1.1.9 ENTREGA ("Pedir entrega"): a app nunca a teve (o ticket "I can't get my car delivered" era isso). O servidor
       diz se há entrega e o preço (garage.deliveryInfo, uma vez por abertura; um erro NÃO fica guardado, volta a perguntar)
       e decide tudo no pedido; o client/garage.lua procura a estrada e aplica o carro. A resposta é SEMPRE
       { ok } ou { ok:false, error }: cada código tem a sua frase e nada fica a rodar. */
    let dinfo = null, delivering = false;
    const deliveryInfo = async () => { if (dinfo) return dinfo; let r = null; try { r = await Bridge.rpc('garage.deliveryInfo'); } catch (e) {} if (r && typeof r === 'object') dinfo = r; return r || { enabled: false }; };
    const canDeliver = v => !!(dinfo && dinfo.enabled && v && v.state === 1);
    /* 1.2.0: Config.GarageDelivery.mode 'valet' = um manobrista traz o carro (client/garage.lua); 'road' = aparece na estrada ao pé */
    const isValet = info => !!(info && info.mode === 'valet');
    const priceTxt = () => (dinfo && dinfo.price > 0) ? UI.money(dinfo.price) : 'Grátis';
    const DERR = { disabled: 'Indisponível neste servidor', onesync: 'Indisponível neste servidor', framework: 'Indisponível neste servidor', foreign: 'Indisponível neste telemóvel.',
      notfound: 'Este veículo não está na garagem.', state: 'Este veículo não está na garagem.', impound: 'Veículo apreendido: dirige-te ao depósito', busy: 'Já tens uma entrega',
      unsupported: 'Este veículo não pode ser entregue.', type: 'Este veículo não pode ser entregue.', model: 'O modelo deste veículo não existe neste servidor.',
      nospot: 'Não há uma estrada livre perto de ti. Aproxima-te de uma estrada e tenta outra vez.', far: 'Não há uma estrada livre perto de ti. Aproxima-te de uma estrada e tenta outra vez.',
      ratelimit: 'Demasiados pedidos seguidos. Espera um pouco.', timeout: 'O servidor não respondeu. Tenta outra vez.', internal: 'Ocorreu um erro no servidor. Tenta outra vez.',
      db: 'Ocorreu um erro no servidor. Tenta outra vez.', server: 'Ocorreu um erro no servidor. Tenta outra vez.' };
    const deliverErr = r => { const e = r && r.error;
      if (e === 'money') return r.account === 'cash' ? 'Não tens dinheiro suficiente contigo.' : 'Saldo insuficiente no banco.';
      if (e === 'cooldown') return `Espera ${Math.max(1, Math.ceil(+r.wait || 1))} s antes de pedir outra vez.`;
      if (r && r.refunded === false) return 'Não foi possível entregar o veículo nem devolver o dinheiro. Fala com um administrador.';
      if (e === 'spawn' || (e === 'timeout' && r.refunded)) return r.refunded ? 'Não foi possível entregar o veículo. O dinheiro foi devolvido.' : 'Não foi possível concluir. Tenta outra vez.';
      return DERR[e] || 'Não foi possível concluir. Tenta outra vez.'; };
    /* fora do jogo (browser/harness) não há cliente Lua: a entrega responde como no jogo, sem carro */
    const callDeliver = d => Bridge.inFiveM ? Bridge.callT('garageDeliver', d, 40000) : Promise.resolve({ ok: true, dist: 42 });
    async function deliver(v, li, onDone) {
      if (delivering) { UI.toast('Já tens uma entrega'); return; }
      const info = await deliveryInfo(); if (!info || !info.enabled) { UI.toast('Indisponível neste servidor'); return; }
      if (v.state !== 1) { UI.toast('Este veículo não está na garagem.'); return; }
      const valet = isValet(info);
      const msg = valet
        ? (info.price > 0 ? `Um manobrista traz o veículo até ti, com as chaves. Taxa de entrega: ${UI.money(info.price)}.` : 'Um manobrista traz o veículo até ti, com as chaves.')
        : (info.price > 0 ? `O veículo é deixado na estrada mais perto de ti, com as chaves. Taxa de entrega: ${UI.money(info.price)}.` : 'O veículo é deixado na estrada mais perto de ti, com as chaves.');
      if (!(await UI.confirm('Pedir entrega', msg, 'Pedir entrega'))) return;
      delivering = true; if (li) li.classList.add('gr-busy'); UI.toast(valet ? 'O manobrista está a caminho' : 'Entrega a caminho', 2500);
      let r = null; try { r = await callDeliver({ plate: v.plate }); } catch (e) { r = null; }
      delivering = false; if (li) li.classList.remove('gr-busy');
      if (r && r.ok) {
        v.state = 0;
        if (li && li.isConnected) { li.classList.add('gr-done'); li.onclick = null; li.querySelectorAll('.li-value, .ou-val').forEach(x => { x.textContent = 'Fora da garagem'; }); }
        if (onDone) { try { onDone(); } catch (e) {} }
        /* manobrista a conduzir (r.valet): o fim chega pelo push 'garageValet' (chegou / ficou na estrada); sem ele o carro já está na estrada */
        if (r.valet) UI.banner({ app: 'garage', title: 'O manobrista está a caminho', msg: name(v) });
        else UI.banner({ app: 'garage', title: 'Entrega concluída', msg: 'Localização marcada no GPS' });
        refresh(); return; }
      UI.toast(deliverErr(r || { error: 'timeout' }), 3200);
      if (r && (r.error === 'state' || r.error === 'impound' || r.error === 'notfound')) refresh(); }
    async function locate(v) { if (v.state === 1 && v.coords) { await Bridge.call('setWaypoint', { x: v.coords.x, y: v.coords.y, name: v.garage }); UI.toast('GPS marcado para a garagem'); return; } const r = await Bridge.call('locateVehicle', { plate: v.plate }); if (r && r.x !== undefined) { UI.banner({ app: 'garage', title: name(v), msg: 'Localização marcada no GPS' }); return; }
      /* INTEG: longe do jogador o cliente não vê o carro: o servidor pergunta ao provider da garagem / à entidade (garage.track) */
      if (v.state !== 2) { let t = null; try { t = await Bridge.rpc('garage.track', { plate: v.plate }); } catch (e) {} if (t && t.x != null) { await Bridge.call('setWaypoint', { x: t.x, y: t.y, name: name(v) }); UI.banner({ app: 'garage', title: name(v), msg: 'Localização marcada no GPS' }); return; } }
      UI.toast(v.state === 2 ? 'Veículo apreendido: dirige-te ao depósito' : 'Veículo não encontrado perto de ti'); }
    const row = v => ({ icon: 'car', iconBg: v.state === 1 ? 'var(--green)' : v.state === 2 ? 'var(--red)' : 'var(--orange)', big: true, label: name(v), sub: `${v.plate} · ${v.state === 1 ? (v.garage || 'Garagem') : v.state === 2 ? 'Depósito' : 'Fora da garagem'}`, right: v.favorite ? `<span class="nostop" style="color:var(--yellow)">${g('starFill', 21)}</span>` : undefined, onTap: () => detail(v), onLong: li => ctx(v, li) });
    const ctx = (v, el) => UI.ctxMenu(el || null, [...(canDeliver(v) ? [{ label: 'Pedir entrega', icon: 'car', onTap: () => deliver(v) }] : []), { label: 'Localizar', icon: 'nav', onTap: () => locate(v) }, { label: 'Mudar nome', icon: 'pen', onTap: () => rename(v) }, { label: v.favorite ? 'Remover favorito' : 'Favorito', icon: 'star', onTap: async () => { await Bridge.rpc('garage.favorite', { plate: v.plate, favorite: !v.favorite }); refresh(); } }]);
    const rename = async v => { const n = await UI.prompt('Alcunha', v.plate, 'Ex.: O meu Sultan', v.nickname || ''); if (n === null) return; await Bridge.rpc('garage.rename', { plate: v.plate, nickname: n.trim() }); refresh(); };
    const refresh = () => tabs && tabs.go(tabs.cur);
    async function detail(v) {
      const vw = UI.view({ title: name(v), back: 'Garagem', right: [{ icon: 'more', onTap: b => ctx(v, b) }] });
      const [lbl, cls] = ST[v.state] || ST[0];
      const card = vw.content.appendChild(UI.el(`<div class="gr-card"><div class="gr-icon">${g('car', 44)}</div><div class="gr-name">${UI.esc(name(v))}</div><div class="gr-model">${UI.esc(NAMES[(v.model || '').toLowerCase()] || v.model || '')}</div><div class="row" style="gap:8px;margin-top:10px;justify-content:center"><span class="plate">${UI.esc(v.plate)}</span><span class="st ${cls}">${lbl}</span></div>${v.fuel != null ? `<div class="gr-fuel"><div class="row between small"><span>${g('fuel', 19)} Combustível</span><b>${Math.round(v.fuel)}%</b></div><div class="bar"><span style="width:${Math.max(2, Math.min(100, v.fuel))}%"></span></div></div>` : ''}</div>`));
      const sp = UI.spinner(); vw.content.appendChild(sp);
      const [det, info] = await Promise.all([Bridge.rpc('garage.detail', { plate: v.plate }), deliveryInfo()]); sp.remove();
      if (det && (det.engine != null || det.body != null)) vw.content.appendChild(UI.el(`<div class="gr-stats"><div><b>${det.engine != null ? Math.round(det.engine / 10) + '%' : '--'}</b><span>Motor</span></div><div><b>${det.body != null ? Math.round(det.body / 10) + '%' : '--'}</b><span>Carroçaria</span></div><div><b>${det.mileage != null ? Math.round(det.mileage) + ' km' : '--'}</b><span>Km</span></div></div>`));
      /* só para um carro NA garagem (fora já está na rua; apreendido é no depósito); o preço vem do servidor */
      if (info && info.enabled && v.state === 1) vw.content.appendChild(UI.list([{ items: [{ icon: 'car', iconBg: 'var(--green)', label: 'Pedir entrega', value: priceTxt(), chevron: false, cls: 'gr-deliver',
        onTap: li => deliver(v, li, () => { const st = card && card.querySelector && card.querySelector('.st'); if (st) { st.textContent = ST[0][0]; st.className = 'st ' + ST[0][1]; } }) }] }]));
      vw.content.appendChild(UI.list([{ items: [{ icon: 'nav', iconBg: 'var(--blue)', label: v.state === 1 ? 'Marcar garagem no GPS' : 'Localizar veículo', chevron: false, onTap: () => locate(v) }, { icon: 'pen', iconBg: 'var(--gray)', label: 'Alcunha', value: v.nickname || '--', onTap: () => rename(v) }, { icon: 'star', iconBg: 'var(--yellow)', label: 'Favorito', toggle: !!v.favorite, onToggle: async on => { await Bridge.rpc('garage.favorite', { plate: v.plate, favorite: on }); await load(); } }] }, { header: 'Detalhes', items: [{ label: 'Matrícula', value: v.plate }, { label: 'Garagem', value: v.garage || '--' }, { label: 'Estado', value: lbl }] }]));
      if (v.state === 2) vw.content.appendChild(UI.el('<div class="group-footer">Veículo apreendido. Dirige-te ao depósito da polícia para o recuperar.</div>'));
      UI.push(win, vw);
    }
    const home = () => { const v = UI.view({ title: 'Os meus veículos', large: true, right: [{ icon: 'update', onTap: () => refresh() }] }); const holder = UI.el('<div></div>'); v.content.appendChild(holder); holder.appendChild(UI.spinner());
      load().then(() => { holder.innerHTML = ''; if (!list.length) { holder.appendChild(UI.empty('car', 'Sem veículos', 'Os veículos em teu nome aparecem aqui.')); return; }
        holder.appendChild(UI.el(`<div class="gr-summary"><div><b>${list.filter(x => x.state === 1).length}</b><span>na garagem</span></div><div><b>${list.filter(x => x.state === 0).length}</b><span>fora</span></div><div><b>${list.filter(x => x.state === 2).length}</b><span>apreendidos</span></div></div>`));
        const fav = list.filter(x => x.favorite); if (fav.length) holder.appendChild(UI.list([{ header: 'Favoritos', items: fav.map(row) }]));
        [[1, 'Garagem'], [0, 'Fora'], [2, 'Apreendidos']].forEach(([s, h]) => { const l = list.filter(x => x.state === s); if (l.length) holder.appendChild(UI.list([{ header: h, items: l.map(row) }])); }); });
      deliveryInfo();   /* o menu de manter premido mostra "Pedir entrega" sem esperar pelo detalhe */
      return v; };
    const garages = () => { const v = UI.view({ title: 'Garagens', large: true }); const gs = System.garages || {}; const ids = Object.keys(gs); v.content.appendChild(ids.length ? UI.list([{ header: 'Marcar no GPS', items: ids.map(id => ({ icon: 'garage', iconBg: 'var(--blue)', label: id.replace(/garage/i, '').replace(/^\w/, c => c.toUpperCase()) || id, sub: `${list.filter(x => x.garage === id).length} veículo(s)`, chevron: false, onTap: () => { Bridge.call('setWaypoint', { x: gs[id].x, y: gs[id].y, name: id }); UI.toast('GPS marcado'); } })) }]) : UI.empty('garage', 'Sem garagens', 'As garagens do servidor aparecem aqui quando estiverem disponíveis.')); return v; };
    tabs = UI.tabbar(win, [{ icon: 'car', label: 'Veículos', view: home }, { icon: 'garage', label: 'Garagens', view: garages }], 0);
    /* PearPhone Fold aberto: a lista à esquerda, o veículo escolhido à direita (ui.js UI.split) */
    UI.split(win, { icon: 'car', title: 'Nenhum veículo aberto', sub: 'Escolhe um veículo da lista para veres o estado e o GPS aqui.' });
  },
  resume(win) { Bridge.rpc('garage.vehicles').then(l => System.badge('garage', (l || []).filter(v => v.state === 2).length)); }
});

/* 1.2.0 manobrista (client/garage.lua → push 'garageValet' { state: 'driving' | 'arrived' | 'fallback', plate }): o fim da viagem
   chega minutos depois do pedido, com a app fechada ou não - por isso é um banner do sistema, não um estado da janela */
Bridge.on('garageValet', d => {
  if (!d || typeof d !== 'object') return;
  const plate = String(d.plate || '').slice(0, 16);
  if (d.state === 'arrived') UI.banner({ app: 'garage', title: 'O teu veículo chegou', msg: plate ? `${plate} · O manobrista deixou-o junto a ti, com as chaves` : 'O manobrista deixou-o junto a ti, com as chaves' });
  else if (d.state === 'fallback') UI.banner({ app: 'garage', title: 'Entrega concluída', msg: 'O manobrista não conseguiu chegar até ti: o veículo ficou na estrada mais perto, marcada no GPS' });
});

/* ---------- fallback browser ---------- */
if (window.LocalDB && LocalDB.register) (() => {
  const meta = () => LocalDB.T('garage_meta');
  const base = () => [{ plate: 'RK 4471', model: 'sultanrs', garage: 'pillboxgarage', state: 1, fuel: 82, coords: { x: 215.8, y: -810.1 } }, { plate: '49XJL722', model: 'blista2', garage: 'motelgarage', state: 1, fuel: 40, coords: { x: 273.3, y: -343.6 } }, { plate: '49XJL723', model: 'buccaneer', garage: 'motelgarage', state: 0, fuel: 61 }, { plate: '49XJL724', model: 'buffalo', garage: 'pillboxgarage', state: 2, fuel: 15 }];
  LocalDB.register('garage.vehicles', () => base().map(v => { const m = meta().all().find(x => x.plate === v.plate) || {}; return Object.assign({}, v, { nickname: m.nickname || null, favorite: !!m.favorite }); }));
  LocalDB.register('garage.detail', d => ({ plate: d.plate, engine: 880, body: 940, mileage: 12450 }));
  LocalDB.register('garage.deliveryInfo', () => ({ enabled: true, price: 250, account: 'bank' }));
  const upsert = (plate, patch) => { const m = meta().all().find(x => x.plate === plate); if (m) meta().update(m.id, patch); else meta().insert(Object.assign({ plate, owner: 'DEV0000', nickname: null, favorite: false }, patch)); return { ok: true }; };
  LocalDB.register('garage.rename', d => upsert(d.plate, { nickname: d.nickname || null }));
  LocalDB.register('garage.favorite', d => upsert(d.plate, { favorite: !!d.favorite }));
})();
