/* ===================== CASA - as casas e chaves do qb-houses =====================
   2026-09-20: a app deixou de ser um brinquedo (acessórios no localStorage, "câmaras" com gradiente, eventos que ninguém
   ouvia). Agora lê as casas a sério pelo server/house.lua: as de que és dono e as de que tens chave, com trancar/destrancar
   (o mesmo que fazer à porta), GPS até à porta e à garagem, e - nas tuas - dar chave a quem está online e tirá-la
   (pelo client/main.lua 'houseKey', que dispara os eventos do próprio qb-houses). Sem qb-houses a app diz isso mesmo. */
App.define('home', {
  name: 'Casa', core: true, category: 'Estilo de vida',
  open(win) {
    const g = UI.g; let houses = [], off = false;
    const load = async () => { const r = await Bridge.rpcRaw('house.list'); off = !!(r && r.off); houses = (r && Array.isArray(r.houses)) ? r.houses : []; return r; };
    const stText = h => (h.locked ? 'Trancada' : 'Destrancada') + (h.owner ? ` · ${h.keyholders.length} chave${h.keyholders.length === 1 ? '' : 's'} dada${h.keyholders.length === 1 ? '' : 's'}` : h.ownerName ? ' · de ' + h.ownerName : '');
    const tierName = t => t >= 5 ? 'Mansão' : t >= 3 ? 'Moradia' : t >= 1 ? 'Apartamento' : 'Casa';

    /* ===== NOVA UI (Android): as mesmas casas e RPCs (house.list / house.lock / houseKey), desenhadas como uma app de casa
       inteligente da Nova UI: cartões em grelha com o botão de trancar no próprio cartão e a página da casa com o estado ao centro ===== */
    const A = !!(System.isAndroid && System.isAndroid());
    /* INTEG: casas de outro sistema (server/house.lua, keyMode 'server') dão e tiram chaves pelo servidor; o qb-houses continua pelo cliente */
    /* INTEG2: keyMode 'none' (sistema só de leitura) já não cai no caminho do qb-houses */
    const keyCall = (h, d) => h.keyMode === 'server' ? Bridge.rpcRaw('house.key', d) : h.keyMode === 'none' ? Promise.resolve({ error: 'unsupported' }) : Bridge.call('houseKey', d);
    const lockErr = r => r && r.error === 'nokey' ? 'Já não tens chave desta casa.' : r && r.error === 'off' ? 'O sistema de casas está desligado.' : r && (r.error === 'nolock' || r.error === 'unsupported') ? 'Esta casa não se tranca pelo telemóvel.' : 'Tenta novamente.';
    const toggleLock = async h => { const r = await Bridge.rpcRaw('house.lock', { house: h.name, locked: !h.locked }); if (!r || !r.ok) { Sound.play('error'); UI.alert({ title: 'Não foi possível', msg: lockErr(r) }); return false; } h.locked = r.locked; Sound.play(h.locked ? 'lock' : 'unlock'); UI.toast(h.locked ? 'Casa trancada' : 'Casa destrancada'); return true; };
    function rootA() {
      const v = UI.view({ title: App.name('home'), large: true, cls: 'ahome-v', right: [{ icon: 'update', onTap: () => { Sound.play('click'); rootA(); } }] });
      const holder = UI.el('<div class="ahome-holder"><div class="ahome-load"></div></div>'); holder.firstChild.appendChild(UI.spinner()); v.content.appendChild(holder);
      load().then(r => { holder.innerHTML = '';
        const msg = (t, s) => { const e = UI.el('<div class="ahome-empty"><b></b><span></span></div>'); e.querySelector('b').textContent = t; e.querySelector('span').textContent = s; holder.appendChild(e); UI.emptyFit(e); };
        if (r && r.error && !r.off) return msg('Sem resposta', 'O servidor não respondeu. Toca no botão de atualizar.');
        if (off) return msg('Sem sistema de casas', 'Este servidor não tem um sistema de casas ligado. Quando existir, as tuas casas e chaves aparecem aqui.');
        if (!houses.length) return msg('Sem casas', 'Quando comprares uma casa, ou alguém te der uma chave, aparece aqui.');
        const mine = houses.filter(h => h.owner), keys = houses.filter(h => !h.owner);
        const sum = UI.el(`<div class="ahome-sum"><div><b></b><span>casas</span></div><div><b></b><span>trancadas</span></div><div><b></b><span>com chave dada</span></div></div>`);
        const paintSum = () => { const b = sum.querySelectorAll('b'); b[0].textContent = houses.length; b[1].textContent = houses.filter(h => h.locked).length; b[2].textContent = mine.filter(h => h.keyholders.length).length; };
        paintSum(); holder.appendChild(sum);
        const card = h => { const c = UI.el(`<div class="ahome-dev"><div class="ahome-dt"><div class="ahome-dic"></div><div class="ahome-pw"></div></div><b></b><span></span></div>`);
          const paint = () => { c.classList.toggle('on', !h.locked); c.querySelector('.ahome-dic').innerHTML = g(h.locked ? 'lock' : 'unlock', 24); c.querySelector('.ahome-pw').innerHTML = g(h.locked ? 'unlock' : 'lock', 18); c.querySelector('b').textContent = h.label; c.querySelector('span').textContent = (h.locked ? 'Trancada' : 'Destrancada') + ' · ' + tierName(h.tier); };
          paint();
          c.querySelector('.ahome-pw').onclick = async e => { e.stopPropagation(); if (await toggleLock(h)) { paint(); paintSum(); } };
          c.onclick = () => detailA(h, () => { paint(); paintSum(); });
          return c; };
        const sec = (t, list) => { if (!list.length) return; holder.appendChild(UI.el(`<div class="ahome-sec">${UI.esc(t)}</div>`)); const gr = UI.el('<div class="ahome-grid"></div>'); list.forEach(h => gr.appendChild(card(h))); holder.appendChild(gr); };
        sec('As minhas casas', mine); sec('Chaves que me deram', keys);
        holder.appendChild(UI.el('<div class="ahome-note">Trancar e destrancar aqui é o mesmo que fazê-lo à porta. O estado mostrado é o que o telemóvel viu desde que ligou.</div>'));
      });
      UI.setRoot(win, v);
    }
    function detailA(h, onChange) {
      const v = UI.view({ title: h.label, back: App.name('home'), cls: 'ahome-v' });
      const hero = UI.el(`<div class="ahome-hero"><div class="ahome-big"></div><b></b><span></span><em></em></div>`);
      const paint = () => { hero.classList.toggle('on', !h.locked); hero.querySelector('.ahome-big').innerHTML = g(h.locked ? 'lock' : 'unlock', 44); hero.querySelector('b').textContent = h.locked ? 'Trancada' : 'Destrancada'; hero.querySelector('span').textContent = h.locked ? 'Toca para destrancar' : 'Toca para trancar'; };
      hero.querySelector('em').textContent = tierName(h.tier) + (h.owner ? ' · A tua casa' : h.ownerName ? ' · Casa de ' + h.ownerName : '');
      paint();
      hero.querySelector('.ahome-big').onclick = async () => { if (await toggleLock(h)) { paint(); onChange && onChange(); } };
      v.content.appendChild(hero);
      const acts = UI.el('<div class="ahome-acts"></div>');
      const act = (icon, t, s, fn) => { const a = UI.el(`<div class="ahome-act"><div class="ahome-aic">${g(icon, 22)}</div><div><b></b><span></span></div></div>`); a.querySelector('b').textContent = t; a.querySelector('span').textContent = s; a.onclick = fn; acts.appendChild(a); };
      act('map', 'Porta', 'Marcar o GPS', () => { if (!h.coords) { UI.toast('Sem coordenadas'); return; } Bridge.call('setWaypoint', { x: h.coords.x, y: h.coords.y, name: h.label }); UI.toast('GPS marcado para a porta'); });
      if (h.garage) act('car', 'Garagem', 'Marcar o GPS', () => { Bridge.call('setWaypoint', { x: h.garage.x, y: h.garage.y, name: h.label + ' · garagem' }); UI.toast('GPS marcado para a garagem'); });
      v.content.appendChild(acts);
      if (h.owner) {
        const holder = UI.el('<div></div>'); v.content.appendChild(holder);
        const paintKeys = () => { holder.innerHTML = '';
          holder.appendChild(UI.el('<div class="ahome-sec">Pessoas com chave</div>'));
          const card = UI.el('<div class="ahome-card"></div>');
          if (!h.keyholders.length) card.appendChild(UI.el('<div class="ahome-row static"><span class="ahome-only">Só tu tens chave.</span></div>'));
          h.keyholders.forEach(k => { const r = UI.el(`<div class="ahome-row">${UI.avatar({ name: k.name }, 'sm')}<div class="ahome-rb"><b></b><span></span></div><div class="ahome-x">${g('trash', 18)}</div></div>`); r.querySelector('b').textContent = k.name; r.querySelector('span').textContent = (k.number ? UI.phone(k.number) : 'Sem telemóvel') + (k.online ? ' · online' : ''); r.querySelector('.ahome-x').onclick = () => removeKey(k); card.appendChild(r); });
          holder.appendChild(card);
          const add = UI.el(`<div class="ahome-btn">${g('personPlus', 20)}<span>Dar chave</span></div>`); add.onclick = giveKey; if (h.keyMode !== 'none') holder.appendChild(add);
          holder.appendChild(UI.el('<div class="ahome-note">Só podes dar chave a quem estiver online na cidade.</div>')); };
        const giveKey = async () => { const c = await Contacts.pick('Dar chave a'); if (!c) return; const r = await Bridge.rpcRaw('house.resolve', { number: c.number });
          if (!r || r.error) { Sound.play('error'); UI.alert({ title: 'Não foi possível', msg: r && r.error === 'offline' ? `${c.name || c.number} não está online: o sistema de casas só dá chaves a quem está na cidade.` : r && r.error === 'self' ? 'És tu.' : 'Esse número não existe.' }); return; }
          if (h.keyholders.find(k => k.cid === r.cid)) { UI.toast('Já tem chave'); return; }
          if (!await UI.confirm('Dar chave', `${r.name || c.name} passa a poder entrar e trancar ${h.label}.`, 'Dar chave')) return;
          const cr = await keyCall(h, { action: 'give', house: h.name, target: r.src });
          if (cr && cr.error) { Sound.play('error'); UI.toast('Não foi possível dar a chave'); return; }
          h.keyholders.push({ cid: r.cid, name: (r.name || c.name || '').trim() || c.number, number: c.number, online: true }); Sound.play('success'); UI.toast('Chave dada'); paintKeys(); onChange && onChange(); };
        const removeKey = async k => { if (!await UI.confirm('Tirar a chave', `${k.name} deixa de poder entrar em ${h.label}.`, 'Tirar', true)) return; const [fn, ...ln] = String(k.name || '').split(' '); const cr = await keyCall(h, { action: 'remove', house: h.name, cid: k.cid, firstname: fn || '', lastname: ln.join(' ') }); if (cr && cr.error) { Sound.play('error'); UI.toast('Não foi possível'); return; } h.keyholders = h.keyholders.filter(x => x.cid !== k.cid); UI.toast('Chave retirada'); paintKeys(); onChange && onChange(); };
        paintKeys();
      } else v.content.appendChild(UI.el(`<div class="ahome-note">Tens chave desta casa: podes entrar, trancar e destrancar. Só ${UI.esc(h.ownerName || 'o dono')} pode dar ou tirar chaves.</div>`));
      UI.push(win, v);
    }
    if (A) { rootA(); return; }

    function root() {
      const v = UI.view({ title: 'Casa', large: true, right: [{ icon: 'rotate', onTap: () => { Sound.play('click'); root(); } }] });
      const holder = UI.el('<div></div>'); holder.appendChild(UI.spinner()); v.content.appendChild(holder);
      load().then(r => { holder.innerHTML = '';
        if (r && r.error && !r.off) { holder.appendChild(UI.empty('home', 'Sem resposta', 'O servidor não respondeu. Toca no botão de atualizar.')); return; }
        if (off) { holder.appendChild(UI.empty('home', 'Sem sistema de casas', 'Este servidor não tem um sistema de casas ligado. Quando existir, as tuas casas e chaves aparecem aqui.')); return; }
        if (!houses.length) { holder.appendChild(UI.empty('home', 'Sem casas', 'Quando comprares uma casa, ou alguém te der uma chave, aparece aqui.')); return; }
        const mine = houses.filter(h => h.owner), keys = houses.filter(h => !h.owner);
        const row = h => ({ icon: h.locked ? 'lock' : 'key', iconBg: h.locked ? 'var(--orange)' : 'var(--green)', label: h.label, sub: stText(h), onTap: () => detail(h) });
        const secs = [];
        if (mine.length) secs.push({ header: 'As minhas casas', items: mine.map(row) });
        if (keys.length) secs.push({ header: 'Chaves que me deram', items: keys.map(row) });
        secs.push({ footer: 'Trancar e destrancar aqui é o mesmo que fazê-lo à porta. O estado mostrado é o que o telemóvel viu desde que ligou.' });
        holder.appendChild(UI.list(secs)); });
      UI.setRoot(win, v);
    }

    /* PearPhone Fold (lista | casa, UI.split): a lista está à vista ao lado, por isso a linha da casa acompanha o trancar */
    const syncRow = h => { if (!win.classList.contains('split-on')) return; const r = win.querySelector('.nav-stack > .view'); if (!r) return;
      const li = [...r.querySelectorAll('.li')].find(x => { const l = x.querySelector('.li-label'); return l && l.textContent === h.label; }); if (!li) return;
      const ic = li.querySelector('.li-icon'); if (ic) { ic.style.background = h.locked ? 'var(--orange)' : 'var(--green)'; ic.innerHTML = g(h.locked ? 'lock' : 'key'); }
      const sb = li.querySelector('.li-sub'); if (sb) sb.textContent = stText(h); };
    function detail(h) {
      const v = UI.view({ title: h.label, back: 'Casa' });
      const hero = UI.el(`<div class="card hs-hero"><div class="hs-ic ${h.locked ? 'locked' : ''}">${g(h.locked ? 'lock' : 'key', 30)}</div><div class="hs-name">${UI.esc(h.label)}</div><div class="hs-sub">${UI.esc(tierName(h.tier))}${h.owner ? ' · A tua casa' : h.ownerName ? ' · Casa de ' + UI.esc(h.ownerName) : ''}</div><div class="hs-st ${h.locked ? 'locked' : 'open'}">${h.locked ? 'Trancada' : 'Destrancada'}</div></div>`);
      const acts = UI.el(`<div class="wl-actions hs-acts"><div class="a lk">${g(h.locked ? 'key' : 'lock')}<span>${h.locked ? 'Destrancar' : 'Trancar'}</span></div><div class="a gp">${g('map')}<span>Porta</span></div>${h.garage ? `<div class="a gg">${g('car')}<span>Garagem</span></div>` : ''}</div>`);
      const paint = () => { hero.querySelector('.hs-ic').className = 'hs-ic ' + (h.locked ? 'locked' : ''); hero.querySelector('.hs-ic').innerHTML = g(h.locked ? 'lock' : 'key', 30); const st = hero.querySelector('.hs-st'); st.className = 'hs-st ' + (h.locked ? 'locked' : 'open'); st.textContent = h.locked ? 'Trancada' : 'Destrancada'; const lk = acts.querySelector('.lk'); lk.innerHTML = `${g(h.locked ? 'key' : 'lock')}<span>${h.locked ? 'Destrancar' : 'Trancar'}</span>`; syncRow(h); };
      acts.querySelector('.lk').onclick = async () => { const r = await Bridge.rpcRaw('house.lock', { house: h.name, locked: !h.locked }); if (!r || !r.ok) { Sound.play('error'); UI.alert({ title: 'Não foi possível', msg: lockErr(r) }); return; } h.locked = r.locked; Sound.play(h.locked ? 'lock' : 'unlock'); UI.toast(h.locked ? 'Casa trancada' : 'Casa destrancada'); paint(); };
      acts.querySelector('.gp').onclick = () => { if (!h.coords) { UI.toast('Sem coordenadas'); return; } Bridge.call('setWaypoint', { x: h.coords.x, y: h.coords.y, name: h.label }); UI.toast('GPS marcado para a porta'); };
      const gg = acts.querySelector('.gg'); if (gg) gg.onclick = () => { Bridge.call('setWaypoint', { x: h.garage.x, y: h.garage.y, name: h.label + ' · garagem' }); UI.toast('GPS marcado para a garagem'); };
      v.content.append(hero, acts);
      if (h.owner) {
        const holder = UI.el('<div></div>'); v.content.appendChild(holder);
        const paintKeys = () => { holder.innerHTML = ''; holder.appendChild(UI.list([{ header: 'Pessoas com chave', items: h.keyholders.length ? h.keyholders.map(k => ({ avatar: { name: k.name }, label: k.name, sub: (k.number ? UI.phone(k.number) : 'Sem telemóvel') + (k.online ? ' · online' : ''), chevron: false, onLong: li => UI.ctxMenu(li, [{ label: 'Tirar a chave', icon: 'trash', danger: true, onTap: () => removeKey(k) }]) })) : [{ label: 'Só tu tens chave.', cls: 'static' }] }, { footer: 'Mantém o dedo numa pessoa para lhe tirar a chave. Só podes dar chave a quem estiver online na cidade.' }]));
          const add = UI.el(`<div class="btn-p btn-s">${g('personPlus', 20)} Dar chave</div>`); add.onclick = giveKey; if (h.keyMode !== 'none') holder.appendChild(add); };
        const giveKey = async () => { const c = await Contacts.pick('Dar chave a'); if (!c) return; const r = await Bridge.rpcRaw('house.resolve', { number: c.number });
          if (!r || r.error) { Sound.play('error'); UI.alert({ title: 'Não foi possível', msg: r && r.error === 'offline' ? `${c.name || c.number} não está online: o sistema de casas só dá chaves a quem está na cidade.` : r && r.error === 'self' ? 'És tu.' : 'Esse número não existe.' }); return; }
          if (h.keyholders.find(k => k.cid === r.cid)) { UI.toast('Já tem chave'); return; }
          if (!await UI.confirm('Dar chave', `${r.name || c.name} passa a poder entrar e trancar ${h.label}.`, 'Dar chave')) return;
          const cr = await keyCall(h, { action: 'give', house: h.name, target: r.src });
          if (cr && cr.error) { Sound.play('error'); UI.toast('Não foi possível dar a chave'); return; }
          h.keyholders.push({ cid: r.cid, name: (r.name || c.name || '').trim() || c.number, number: c.number, online: true }); Sound.play('success'); UI.toast('Chave dada'); paintKeys(); };
        const removeKey = async k => { if (!await UI.confirm('Tirar a chave', `${k.name} deixa de poder entrar em ${h.label}.`, 'Tirar', true)) return; const [fn, ...ln] = String(k.name || '').split(' '); const cr = await keyCall(h, { action: 'remove', house: h.name, cid: k.cid, firstname: fn || '', lastname: ln.join(' ') }); if (cr && cr.error) { Sound.play('error'); UI.toast('Não foi possível'); return; } h.keyholders = h.keyholders.filter(x => x.cid !== k.cid); UI.toast('Chave retirada'); paintKeys(); };
        paintKeys();
      } else v.content.appendChild(UI.list([{ footer: `Tens chave desta casa: podes entrar, trancar e destrancar. Só ${h.ownerName || 'o dono'} pode dar ou tirar chaves.` }]));
      UI.push(win, v);
    }
    root();
    /* PearPhone Fold aberto: as casas à esquerda, a casa escolhida à direita (ui.js UI.split) */
    UI.split(win, { icon: 'home', title: 'Nenhuma casa aberta', sub: 'Escolhe uma casa da lista para a trancares ou marcares no GPS.' });
  }
});
