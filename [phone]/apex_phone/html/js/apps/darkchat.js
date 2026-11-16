/* ===================== DARK CHAT - salas anónimas, mensagens temporárias, imagens ===================== */
App.define('darkchat', {
  name: 'Dark Chat', category: 'Anónimo', statusBar: 'dark',
  open(win) {
    const g = UI.g; win.classList.add('dc'); let me = { username: '…' }; let ttl = 0;
    const load = async () => { me = (await Bridge.rpc('darkchat.identity')) || me; };
    /* tema escuro nas camadas que o UI monta no #screen, FORA da janela (folha da ampulheta, alertas, menu, toasts):
       sem a classe abriam claras e com o azul do sistema por cima de uma app escura. O UI.prompt não aceita `cls`,
       mas monta o alerta de forma síncrona, por isso logo a seguir à chamada é o último filho do #screen. */
    const OV = 'dc-ov';
    const themed = p => { const s = UI.screen(); const o = s && s.lastElementChild; if (o && o.classList.contains('overlay')) o.classList.add(OV); return p; };
    /* tom da alcunha (6 tons discretos, sempre o mesmo para a mesma alcunha): ajuda a seguir quem fala sem mostrar nada além dela */
    const tone = n => { let h = 0; for (const c of String(n == null ? '' : n)) h = (h * 31 + c.charCodeAt(0)) >>> 0; return 'dc-c' + (h % 6); };
    const rooms = () => { const v = UI.view({ title: 'Dark Chat', large: true, right: [{ icon: 'plus', cls: 'glass dc-add', onTap: async () => { const r = await themed(UI.prompt('Entrar numa sala', 'Nome da sala (quem souber o nome entra)', 'nome_da_sala')); if (!r) return; await Bridge.rpc('darkchat.join', { room: r.trim().toLowerCase().replace(/\s+/g, '-').replace(/_/g, '-') });   /* nomes com hífen, sem underscores */ tabs.refresh(); } }] });
      /* texto honesto: as mensagens ficam guardadas no servidor (não há "sem registos" nem encriptação ponta-a-ponta);
         o que é verdade é que os outros só veem a alcunha */
      v.content.appendChild(UI.el(`<div class="dc-who"><i class="dc-dot"></i><span>alcunha: <b>${UI.esc(me.username)}</b> · os outros só veem a alcunha</span></div>`));
      const holder = UI.el('<div></div>'); v.content.appendChild(holder); holder.appendChild(UI.spinner());
      /* salas públicas sugeridas: com uma só sala a lista ficava com meio ecrã vazio e não havia como descobrir mais nenhuma */
      const PUB = [['geral', 'Conversa aberta'], ['mercado', 'Compra e venda'], ['trocas', 'Trocas diretas'], ['los-santos', 'Assuntos da cidade'], ['boleias', 'Transporte discreto'], ['avisos', 'Alertas e patrulhas']];
      Bridge.rpc('darkchat.rooms').then(rs => { holder.innerHTML = ''; rs = rs || [];
        const mine = rs.map(r => r.room);
        /* linha da sala: hora da última mensagem e contagem à direita (a contagem é o total da sala, por isso fica discreta e não imita um "por ler") */
        if (rs.length) holder.appendChild(UI.list([{ header: 'As tuas salas', items: rs.map(r => ({ cls: 'dc-row', icon: 'hash', iconBg: 'var(--dc-tile)', iconColor: 'var(--dc-acc)', label: r.room,
          sub: r.last ? `<span class="dc-by ${tone(r.last.username)}">${UI.esc(r.last.username)}:</span> ${UI.esc(r.last.content || '📷')}` : 'Sem mensagens', subHtml: !!r.last,
          value: `<span class="dc-when">${r.last && r.last.created ? UI.esc(UI.rel(r.last.created)) : ''}</span><span class="dc-count">${UI.esc(r.count)}</span>`, valueHtml: true, chevron: false,
          onTap: () => room(r.room), onLong: li => UI.ctxMenu(li, [{ label: 'Sair da sala', icon: 'logout', danger: true, onTap: async () => { await Bridge.rpc('darkchat.leave', { room: r.room }); tabs.refresh(); } }], { cls: OV }) })) }]));
        else holder.appendChild(UI.empty('ghost', 'Sem salas', 'Entra numa das salas abaixo, ou toca em + para entrar numa sala pelo nome.'));
        const outras = PUB.filter(([n]) => !mine.includes(n));
        if (outras.length) holder.appendChild(UI.list([{ header: 'Salas públicas', items: outras.map(([n, d]) => ({ cls: 'dc-pub', icon: 'hash', iconBg: 'var(--dc-tile-off)', iconColor: 'var(--dc-ink3)', label: n, sub: d, value: 'Entrar', chevron: false, onTap: async () => { await Bridge.rpc('darkchat.join', { room: n }); Sound.play('click'); tabs.refresh(); } })) },
          { footer: 'Qualquer pessoa que saiba o nome de uma sala pode entrar (não há palavra-passe). Uma sala fora desta lista só é discreta enquanto o nome não se espalhar.' }]));
      });
      return v; };
    const room = async name => {
      const v = UI.view({ title: '#' + name, back: 'Salas', full: true, solid: true, cls: 'dc-room', right: [{ icon: 'hourglass', label: 'Mensagens temporárias', cls: 'glass dc-ttl' + (ttl ? ' on' : ''), onTap: async b => { const t = await UI.picker('Mensagens temporárias', [{ value: 0, label: 'Desligado' }, { value: 1, label: 'Apagar após 1 min' }, { value: 5, label: 'Apagar após 5 min' }, { value: 60, label: 'Apagar após 1 h' }], ttl, OV); if (t !== undefined) { ttl = t; b.classList.toggle('on', !!ttl); UI.toast(t ? `Temporárias: ${t} min` : 'Temporárias desligadas', 1800, OV); } } }] });
      /* título "#sala": o cardinal a verde e o nome a claro (o texto continua a ser "#nome") */
      const nt = v.querySelector('.nb-title'); if (nt) nt.innerHTML = `<span class="dc-hash">#</span>${UI.esc(name)}`;
      const th = UI.el('<div class="thread"></div>'); const comp = UI.el(`<div class="composer"><div class="plus">${g('image')}</div><input type="text" placeholder="mensagem anónima…" maxlength="300"><div class="send">${g('arrowUp')}</div></div>`); const inp = comp.querySelector('input');
      /* ao sair uma temporária, a mensagem seguinte deixa de estar "colada" se passou a abrir o grupo (mesma regra do append: mesma alcunha e até 5 min) */
      const drop = b => { const nx = b.nextElementSibling; b.remove(); if (nx && nx.classList.contains('cont')) { const pv = nx.previousElementSibling; if (!pv || pv.dataset.u !== nx.dataset.u || Math.abs((+nx.dataset.t || 0) - (+pv.dataset.t || 0)) >= 300000) nx.classList.remove('cont'); } };
      const append = m => { const em = v.content.querySelector('.empty'); if (em) em.remove();   /* o vazio agora vive na .content, não na .thread */
        const mine = m.username === me.username;
        /* agrupamento visual: mensagens seguidas da mesma alcunha (até 5 min) colam-se e só a primeira mostra a alcunha */
        const prev = th.lastElementChild; const cont = !!(prev && prev.dataset.u === String(m.username) && Math.abs((+m.created || 0) - (+prev.dataset.t || 0)) < 300000);
        const tm = m.created ? UI.fmtTime(new Date(+m.created)) : '';
        const b = UI.el(`<div class="bubble ${mine ? 'me' : 'them'} ${m.image ? 'img' : ''} ${cont ? 'cont' : ''} ${tone(m.username)}"><div class="anon">${UI.esc(m.username)}</div>${m.image ? '<div class="pic"></div>' : UI.esc(m.content)}<span class="dc-meta">${m.ttl ? `<span class="ttl">${g('hourglass')}${UI.esc(m.ttl)}m</span>` : ''}${tm ? `<span class="dc-tm">${tm}</span>` : ''}</span></div>`);
        b.dataset.u = String(m.username); b.dataset.t = String(+m.created || 0);
        /* a imagem (base64 de até 200 KB) vai pelo CSSOM: dentro da string de HTML atravessava o parser por cada bolha */
        if (m.image) { const pic = b.querySelector('.pic'); if (pic) pic.style.backgroundImage = UI.img(m.image); }
        th.appendChild(b); v.content.scrollTop = 1e6;
        /* o tempo conta a partir de quando a mensagem FOI CRIADA (o servidor apaga-a nessa altura); antes contava a partir de agora,
           por isso o histórico ficava minutos a mais no ecrã. Os temporizadores entram em win.timers para morrerem com a app. */
        if (m.ttl) { const left = m.ttl * 60000 - (Date.now() - (m.created || Date.now())); if (left <= 0) { b.remove(); return; }
          win.timers.push(setTimeout(() => { b.style.opacity = .3; win.timers.push(setTimeout(() => drop(b), 2000)); }, left)); } };
      /* o servidor recusa quem não é membro, TTL fora da lista e imagens acima do limite: antes a falha era muda
         e o texto escrito perdia-se, agora volta ao campo e aparece o motivo */
      const SEND_ERR = { forbidden: 'Já não estás nesta sala.', ttl: 'Tempo de mensagem temporária inválido.', toolarge: 'Imagem demasiado grande.' };
      /* rpcRaw: no jogo o Bridge.rpc troca { error } por null e o SEND_ERR nunca chegava a ser usado */
      const send = async (content, image) => { if (!content && !image) return; inp.value = ''; const m = await Bridge.rpcRaw('darkchat.send', { room: name, content, image, ttl });
        if (m && !m.error) { append(m); Sound.play('send'); return; }
        if (content && !inp.value) inp.value = content; Sound.play('error'); UI.toast((m && SEND_ERR[m.error]) || 'Mensagem não enviada', 1800, OV); };
      comp.querySelector('.send').onclick = () => send(inp.value.trim()); inp.onkeydown = e => { if (e.key === 'Enter') send(inp.value.trim()); };
      comp.querySelector('.plus').onclick = async () => { const p = await Photos.pick('Enviar imagem'); if (p) send('', p.url || p.seed); };
      v.content.appendChild(th); v.content.style.paddingBottom = '0'; v.appendChild(comp); UI.push(win, v);
      const res = await Bridge.rpcRaw('darkchat.messages', { room: name });
      /* { error: 'forbidden' } quando o jogador já não é membro (saiu noutro telemóvel, trocou de identidade).
         rpcRaw pela mesma razão do envio: com o rpc o erro chegava como null e mostrava "Sala vazia" */
      const denied = !!(res && res.error); const ms = Array.isArray(res) ? res : [];
      /* o vazio tem de ser filho DIRETO da .content (a .thread não cresce), senão ficava espremido debaixo da barra */
      if (denied) { const em = UI.empty('ghost', 'Sem acesso', 'Já não estás nesta sala. Volta a entrar pela lista de salas.'); v.content.insertBefore(em, th); }
      else if (!ms.length) { const em = UI.empty('ghost', 'Sala vazia', 'Ninguém falou aqui ainda. Os outros só veem a tua alcunha.'); v.content.insertBefore(em, th); } else ms.forEach(append); setTimeout(() => inp.focus(), 450);
      /* ⚠️ o onPop só corre no UI.pop/UI.setRoot - o killApp (LRU, switcher, "fechar tudo") corre
         SÓ o win.onClose. Sem a lista `offs`, uma sala aberta numa app morta ficava a ouvir para
         sempre: cada mensagem dessa sala construía bolhas num DOM fora do documento e tocava o
         'pop' de uma sala onde o jogador já não estava. */
      const off = Bridge.on('darkchat', m => { if (m && m.room === name && m.username !== me.username) { append(m); Sound.play('pop'); } });
      offs.add(off); v.opts.onPop = () => { off(); offs.delete(off); };
    };
    const offs = new Set();
    win.onClose = () => { offs.forEach(o => o()); offs.clear(); };
    /* ⚠️ nada de "encriptação ponta-a-ponta" nem "sem registos": as mensagens vão em claro para a tabela
       apex_phone_darkchat do servidor. O que a app garante é a alcunha e o apagar das temporárias. */
    /* cartão da identidade: a 1.ª linha (Identidade + alcunha) é desenhada como cartão pelo CSS (.dc-idrow); os textos são os mesmos */
    const about = () => { const v = UI.view({ title: 'Sobre', large: true }); v.content.appendChild(UI.list([{ items: [{ label: 'Identidade', value: me.username, cls: 'dc-idrow', icon: 'ghost', iconBg: 'var(--dc-tile)', iconColor: 'var(--dc-acc)' }, { label: 'Mensagens', value: 'Guardadas no servidor', cls: 'dc-info', icon: 'cloud', iconBg: 'var(--dc-tile-off)', iconColor: 'var(--dc-ink2)' }, { label: 'Temporárias', value: 'Apagam-se no fim', cls: 'dc-info', icon: 'hourglass', iconBg: 'var(--dc-tile-off)', iconColor: 'var(--dc-ink2)' }], footer: 'O Dark Chat não tem encriptação ponta-a-ponta. As mensagens ficam guardadas no servidor; as temporárias apagam-se para todos ao fim do tempo escolhido na ampulheta de cada sala.' }, { items: [{ label: 'Nova identidade', cls: 'center dc-newid', chevron: false, onTap: async () => {
          if (!await UI.confirm('Nova identidade', 'Perdes o acesso às salas com a alcunha atual. As mensagens antigas ficam, mas deixam de ser tuas.', 'Trocar', true, OV)) return;
          const r = await Bridge.rpc('darkchat.newIdentity');   /* a alcunha vive no servidor; limpar só o Store não mudava nada no jogo */
          if (r && r.username) me = r; else { Store.remove('dcname'); await load(); }
          UI.toast('Nova identidade: ' + me.username, 1800, OV); tabs.refresh(); } }], footer: 'Trocar de identidade tira-te de todas as salas. As mensagens antigas continuam guardadas com a alcunha anterior.' }])); return v; };
    let tabs; load().then(() => { tabs = UI.tabbar(win, [{ icon: 'hash', label: 'Salas', view: rooms }, { icon: 'ghost', label: 'Identidade', view: about }], 0); });
    /* PearPhone Fold aberto: as salas à esquerda, a sala aberta à direita (ui.js UI.split) */
    UI.split(win, { icon: 'hash', title: 'Nenhuma sala aberta', sub: 'Escolhe uma sala da lista. Os outros só veem a tua alcunha.' });
  }
});
Bridge.on('darkchat', m => { if (!m || System.currentApp() === 'darkchat') return; Notify.push({ app: 'darkchat', title: '#' + m.room, msg: `${m.username}: ${m.content || '📷'}`, onTap: () => System.openApp('darkchat') }); });
