/* ===================== NOTAS + LEMBRETES =====================
   Os dados passam TODOS pelo Agenda (clock.js): é ele que grava a semente (o Store.get não escreve o
   valor por omissão) e é ele que avisa à hora marcada, fora das janelas das apps. Enquanto o servidor
   não tiver tabelas, isto vive no localStorage do CEF, na gaveta desta personagem - está escrito nos
   rodapés das apps, sem prometer nuvem nenhuma.
   ============================================================= */
App.define('notes', {
  name: 'Notas',
  /* a janela fechada continua viva no LRU e a lista muda por fora (o Recado guarda notas, a Vera lê-as):
     ao voltar à app repinta-se, senão via-se o ecrã de há dez minutos */
  resume(win) { try { win._paint && win._paint(); } catch (e) {} },
  open(win) {
    /* semente em função: o Agenda grava-a e as edições mexem no array gravado (com um array constante
       estaríamos a mutar a própria semente). Mesmos textos/ids do recado-extras.js - se mudarem aqui,
       muda-se lá. */
    /* 1.1.8: as notas de exemplo são conteúdo do jogador para o tradutor do DOM (nunca se traduzem depois de gravadas):
       semeiam-se já no idioma do telemóvel (L.t procura a chave exata, com o \n) */
    const seed = () => { const tt = s => (window.L && L.t ? L.t(s) : s); return [{ id: 1, text: tt('Lista de compras\nPão, leite, café, ovos'), ts: Date.now() - 864e5 }, { id: 2, text: tt('Matrícula da carrinha\n48ABC123, garagem central'), ts: Date.now() - 2 * 864e5 }]; };
    const all = () => Agenda.list('notes', seed);
    const save = fn => Agenda.edit('notes', seed, fn);
    /* NOVA UI (Android): mesmas notas, mesmo Agenda; só o desenho muda (grelha de páginas com o título por baixo, botão
       flutuante, editor limpo com título e texto). O texto continua a ser UM campo (1.ª linha = título), como no PearOS. */
    if (System.isAndroid && System.isAndroid()) {
      const g = UI.g;
      let aq = '', grid = true, sortBy = 'date';
      const split = n => { const s = String(n.text || ''); const i = s.indexOf('\n'); return i < 0 ? [s, ''] : [s.slice(0, i), s.slice(i + 1)]; };
      const root = UI.view({ title: 'Todas as notas', large: true, cls: 'anote-v', right: [{ icon: 'search', onTap: () => { sbox.classList.toggle('on'); if (sbox.classList.contains('on')) setTimeout(() => sin.focus(), 60); else { sin.value = ''; aq = ''; paint(); } } }, { icon: 'moreV', onTap: b => menu(b) }] });
      const sbox = UI.el(`<div class="anote-search">${g('search', 20)}<input type="text" placeholder="Pesquisar notas"><div class="anote-sx">${g('x', 16)}</div></div>`);
      const sin = sbox.querySelector('input');
      sin.oninput = () => { aq = sin.value.trim().toLowerCase(); paint(); };
      sbox.querySelector('.anote-sx').onclick = () => { sin.value = ''; aq = ''; paint(); sin.focus(); };
      /* a contagem vai para a zona do título grande (o <small> que o ui.js da Nova UI desenha por baixo do título) */
      const lt = root.content.querySelector(':scope > .large-title'); const cnt = document.createElement('small'); if (lt) lt.appendChild(cnt);
      const holder = UI.el('<div class="anote-holder"></div>');
      root.content.append(sbox, holder);
      const fab = UI.el(`<div class="anote-fab anote-fabn">${g('pen', 26)}</div>`); root.appendChild(fab);
      fab.onclick = () => { Sound.play('click'); edit(); };
      const menu = b => UI.ctxMenu(b, [{ label: grid ? 'Ver em lista' : 'Ver em grelha', icon: grid ? 'list' : 'grid', onTap: () => { grid = !grid; paint(); } },
        { label: sortBy === 'date' ? 'Ordenar por título' : 'Ordenar por data', icon: 'sliders', onTap: () => { sortBy = sortBy === 'date' ? 'title' : 'date'; paint(); } }]);
      const del = n => save(l => { const i = l.findIndex(x => x.id === n.id); if (i > -1) l.splice(i, 1); });
      function paint() {
        const total = all().length; cnt.textContent = total === 1 ? '1 nota' : total + ' notas';
        let notes = all().filter(n => !aq || String(n.text || '').toLowerCase().includes(aq));
        notes = sortBy === 'title' ? notes.sort((a, b) => split(a)[0].localeCompare(split(b)[0])) : notes.sort((a, b) => b.ts - a.ts);
        holder.innerHTML = '';
        if (!notes.length) { const em = UI.el(`<div class="anote-empty">${aq ? 'Sem resultados para esta pesquisa.' : 'Sem notas. Toca no lápis para criar a primeira.'}</div>`); holder.appendChild(em); UI.emptyFit(em); return; }
        const box = UI.el(`<div class="${grid ? 'anote-grid' : 'anote-list'}"></div>`);
        notes.forEach(n => {
          const [t, body] = split(n);
          const it = UI.el(grid ? '<div class="anote-it"><div class="anote-page"><b></b><p></p></div><div class="anote-t"></div><div class="anote-d"></div></div>' : '<div class="anote-row"><div class="anote-rb"><b></b><p></p></div><div class="anote-d"></div></div>');
          it.querySelector('b').textContent = t || 'Nova nota';
          it.querySelector('p').textContent = body.slice(0, 260);
          if (grid) it.querySelector('.anote-t').textContent = t || 'Nova nota';
          it.querySelector('.anote-d').textContent = UI.rel(n.ts);
          it.onclick = () => edit(n);
          UI.longPress(it, () => UI.ctxMenu(it, [{ label: 'Apagar', icon: 'trash', danger: true, onTap: () => { del(n); paint(); } }]));
          box.appendChild(it);
        });
        holder.appendChild(box);
        holder.appendChild(UI.el('<div class="anote-foot">Guardadas neste telemóvel, nesta personagem.</div>'));
      }
      function edit(n) {
        const fresh = !n;
        if (!n) { n = { id: Date.now(), text: '', ts: Date.now() }; save(l => l.push(n)); }
        const [t0, b0] = split(n);
        const v = UI.view({ title: '', back: 'Todas as notas', cls: 'anote-ev', right: [{ icon: 'trash', onTap: async () => { if (await UI.confirm('Apagar nota', 'Esta ação não pode ser anulada.', 'Apagar', true)) { gone = true; del(n); UI.pop(win); paint(); } } }] });
        let gone = false;
        const ed = UI.el(`<div class="anote-ed"><input type="text" class="anote-title" maxlength="120" placeholder="Título"><div class="anote-date"></div><textarea class="anote-body" placeholder="Escreve aqui a tua nota"></textarea></div>`);
        const ti = ed.querySelector('.anote-title'), ta = ed.querySelector('.anote-body');
        ti.value = t0; ta.value = b0;
        ed.querySelector('.anote-date').textContent = UI.fmtDate(new Date(n.ts)) + ' · ' + UI.fmtTime(new Date(n.ts));
        const write = () => { const t = ti.value.replace(/\n/g, ' '), b = ta.value; save(l => { const x = l.find(y => y.id === n.id); if (x) { x.text = b ? t + '\n' + b : t; x.ts = Date.now(); } }); };
        ti.oninput = write; ta.oninput = write;
        ti.onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); ta.focus(); } };
        /* uma nota nova deixada em branco não fica na lista (como na app de notas da Nova UI) */
        v.opts.onPop = () => { if (!gone && fresh && !ti.value.trim() && !ta.value.trim()) del(n); setTimeout(paint, 0); };
        v.content.appendChild(ed); UI.push(win, v); setTimeout(() => (fresh ? ti : ta).focus(), 400);
      }
      win._paint = () => { if (root.isConnected) paint(); };
      paint(); UI.setRoot(win, root);
      /* NOVA Fold8 aberto: as notas à esquerda e a nota aberta à direita (ui.js UI.split) */
      UI.split(win, { icon: 'pen', title: 'Nenhuma nota aberta', sub: 'Escolhe uma nota da lista ou cria uma nova com o lápis.', row: '.anote-it, .anote-row' });
      return;
    }
    let q = '';
    /* como as Notas do iOS: títulos a negrito com "data  excerto" por baixo, e a barra de baixo com a contagem ao centro e o
       botão de nova nota à direita (em cima já não há botão) */
    const root = UI.view({ title: 'Notas', large: true, cls: 'notes-view' });
    root.content.appendChild(UI.search('Pesquisar', s => { q = s; render(); }));
    const holder = UI.el('<div class="notes-list"></div>'); root.content.appendChild(holder);
    const bar = UI.el(`<div class="notes-bar"><span class="cnt"></span><div class="new">${UI.g('compose', 24)}</div></div>`); root.appendChild(bar);
    bar.querySelector('.new').onclick = () => { Sound.play('click'); edit(); };
    /* PearPhone Fold: o lápis vai para a barra direita (em baixo; com a lista ao lado, em cima, como o Escrever do Mail) e a barra de
       baixo fica só com a contagem (apps.css) */
    root.rail = (auto, role) => { const nw = { icon: 'compose', label: 'Nova nota', onTap: () => { Sound.play('click'); edit(); } }; return role === 'list' ? { groups: [[nw]] } : { primary: [[nw]] }; };
    /* PearPhone Fold (lista | nota, UI.split): a nota aberta à direita fica marcada e a lista acompanha o que se escreve */
    let selId = null, liveT = null;
    const splitOn = () => win.classList.contains('split-on');
    const paintSel = () => { holder.querySelectorAll('.split-sel').forEach(x => x.classList.remove('split-sel')); if (!splitOn() || selId == null) return; const li = holder.querySelector('.nid-' + selId); if (li) li.classList.add('split-sel'); };
    const render = () => {
      holder.innerHTML = '';
      const total = all().length; bar.querySelector('.cnt').textContent = total === 1 ? '1 nota' : total + ' notas';
      const notes = all().filter(n => !q || n.text.toLowerCase().includes(q)).sort((a, b) => b.ts - a.ts);
      if (!notes.length) { holder.appendChild(UI.empty('compose', q ? 'Sem resultados' : 'Sem notas', q ? 'Tenta outra palavra.' : 'Toca no lápis, em baixo, para criar uma nota.')); return; }
      /* 1.1.8: o `sub` da linha é conteúdo do jogador para o tradutor do DOM (.li-body): a data relativa ("Ontem") e o
         "Sem texto adicional" traduzem-se aqui, antes de entrar */
      const tt = s => (window.L && L.t ? L.t(s) : s);
      holder.appendChild(UI.list([{ header: 'Notas', items: notes.map(n => { const [t, ...r] = n.text.split('\n'); return { label: t || 'Nova nota', cls: 'nid-' + n.id, sub: `${tt(UI.rel(n.ts))}  ${(r.join(' ') || tt('Sem texto adicional')).slice(0, 40)}`, chevron: false, onTap: () => edit(n), onLong: li => UI.ctxMenu(li, [{ label: 'Apagar', icon: 'trash', danger: true, onTap: () => { save(l => { const i = l.findIndex(x => x.id === n.id); if (i > -1) l.splice(i, 1); }); render(); } }]) }; }),
        footer: 'Guardadas neste telemóvel, nesta personagem.' }]));
      paintSel();
    };
    /* a escrever com a lista ao lado (fold): a linha da nota muda no sítio e sobe para o topo, sem repintar a lista toda */
    const liveRow = id => { const x = all().find(y => y.id === id), li = holder.querySelector('.nid-' + id);
      if (!x || !li) { render(); return; }
      const [t, ...r] = String(x.text || '').split('\n'); const lab = li.querySelector('.li-label'), sb = li.querySelector('.li-sub');
      if (lab) lab.textContent = t || 'Nova nota'; if (sb) { const tt = s => (window.L && L.t ? L.t(s) : s); sb.textContent = `${tt(UI.rel(x.ts))}  ${(r.join(' ') || tt('Sem texto adicional')).slice(0, 40)}`; }
      const grp = li.parentElement; if (!q && grp && grp.firstElementChild !== li) grp.insertBefore(li, grp.firstElementChild); };
    const edit = n => {
      const v = UI.view({ title: '', back: 'Notas', right: [{ icon: 'trash', onTap: async () => { if (await UI.confirm('Apagar nota', 'Esta ação não pode ser anulada.', 'Apagar', true)) { save(l => { const i = l.findIndex(x => x.id === n.id); if (i > -1) l.splice(i, 1); }); UI.pop(win); render(); } } }, { label: 'OK', bold: true, onTap: () => { UI.pop(win); render(); } }] });
      const nova = !n;
      if (n) { const cur = all().find(y => y.id === n.id); if (cur) n = cur; }   /* a versão gravada mais recente (a linha da lista pode ser de antes) */
      if (!n) { n = { id: Date.now(), text: '', ts: Date.now() }; save(l => l.push(n)); }
      const ed = UI.el(`<div class="note-editor"><div class="date">${UI.fmtDate(new Date(n.ts))} · ${UI.fmtTime(new Date(n.ts))}</div><textarea class="ta" placeholder="Escreva algo…"></textarea></div>`);
      const ta = ed.querySelector('textarea'); ta.value = n.text;
      ta.oninput = () => { save(l => { const x = l.find(y => y.id === n.id); if (x) { x.text = ta.value; x.ts = Date.now(); } });
        if (splitOn()) { clearTimeout(liveT); liveT = setTimeout(() => { if (root.isConnected) liveRow(n.id); }, 400); } };
      v.opts.onPop = () => { clearTimeout(liveT); if (selId === n.id) { selId = null; paintSel(); } };
      v.content.appendChild(ed); UI.push(win, v); setTimeout(() => ta.focus(), 400);
      selId = n.id; if (splitOn()) { if (nova) render(); else paintSel(); }   /* a nota nova aparece logo na lista, já marcada */
    };
    win._paint = () => { if (root.isConnected) render(); };
    render(); UI.setRoot(win, root);
    /* PearPhone Fold aberto: lista à esquerda, a nota aberta à direita (ui.js UI.split) */
    UI.split(win, { icon: 'compose', title: 'Nenhuma nota aberta', sub: 'Escolhe uma nota da lista ou cria uma nova com o lápis.', row: '.nid-none' });
  }
});

App.define('reminders', {
  name: 'Lembretes',
  /* mesmo motivo das Notas: o Telefone cria um lembrete de uma chamada perdida e a Vera cria lembretes
     com a app guardada no LRU - ao reabrir tem de estar em dia (o Bridge.on('agenda') só chega quando
     o aviso dispara) */
  resume(win) { try { win._paint && win._paint(); } catch (e) {} },
  open(win) {
    /* `due` = milissegundos do aviso (0 = sem hora). É o mesmo campo que a Vera já escreve
       (shell/vera.js, "lembra-me de … às 18:00"), por isso os lembretes dela também passam a avisar
       por este caminho. O `notified` é do Agenda: marca o que já avisou, para não repetir. */
    const seed = () => { const tt = s => (window.L && L.t ? L.t(s) : s); const d = new Date(); d.setDate(d.getDate() + 1); d.setHours(10, 0, 0, 0); return [   /* 1.1.8: exemplos semeados já traduzidos */
      { id: 1, text: tt('Pagar a renda do apartamento'), done: false, ts: Date.now(), due: d.getTime() },
      { id: 2, text: tt('Levar o carro à oficina'), done: false, ts: Date.now(), due: 0 },
      { id: 3, text: tt('Renovar carta de condução'), done: true, ts: Date.now() - 864e5, due: 0 }]; };
    const all = () => Agenda.list('reminders', seed);
    const save = fn => Agenda.edit('reminders', seed, fn);
    /* o "quando voltares" tem prazo: o Agenda só recupera lembretes atrasados até 12 h (GRACE_REM no
       clock.js). Dizer só "quando voltares" prometia um aviso que, passado esse tempo, não chega. */
    const FOOT = 'Com hora marcada, avisa-te mesmo com a app fechada, se estiveres em jogo; se não estiveres, quando voltares (até 12 h depois). Fica guardado neste telemóvel.';
    let filter = 'all';
    const root = UI.view({ title: 'Lembretes', large: true, right: [{ icon: 'plus', onTap: () => editRem() }] });
    const tiles = UI.el('<div class="rl-grid"></div>');
    const holder = UI.el('<div></div>');
    const composer = UI.el(`<div class="group" style="margin-top:18px"><div class="li has-icon static"><div class="rl-icon" style="background:var(--blue)">${UI.g('plus')}</div><input type="text" placeholder="Novo lembrete (sem hora)" style="flex:1;border:none;background:none;font:inherit;color:var(--label);outline:none"></div></div>`);
    const inp = composer.querySelector('input');
    inp.onkeydown = e => { if (e.key === 'Enter' && inp.value.trim()) { save(l => l.push({ id: Date.now(), text: inp.value.trim(), done: false, ts: Date.now(), due: 0 })); inp.value = ''; render(); } };
    /* fim de hoje: é o limite do separador "Hoje" (antes contava TODOS os pendentes e chamava-lhes "Hoje") */
    const fimDeHoje = () => { const d = new Date(); d.setHours(23, 59, 59, 999); return d.getTime(); };
    const paraHoje = x => !!x && !x.done && +x.due > 0 && +x.due <= fimDeHoje();
    const quando = x => {
      if (!x || !+x.due) return x && x.flag ? '⚑ Sinalizado' : undefined;
      const txt = Agenda.whenText(+x.due) + (x.flag ? ' · ⚑' : '');
      return !x.done && +x.due < Date.now() ? 'Atrasado · ' + txt : txt;
    };

    /* quem repinta depois de gravar: o render() do PearOS ou o paintA() da Nova UI (a folha de edição é a mesma nos dois) */
    let repaint = () => render();
    /* folha de edição: texto, aviso (dia + hora), sinal e apagar */
    const editRem = x => {
      const cur = x || { id: Date.now(), text: '', done: false, ts: Date.now(), due: 0, flag: false };
      let avisa = !!+cur.due, flag = !!cur.flag;
      const body = UI.el('<div></div>');
      body.appendChild(UI.list([{ items: [{ html: `<input type="text" class="rl-t" placeholder="Lembrete" value="${UI.esc(cur.text || '')}">`, cls: 'static' }] }]));
      const pick = Agenda.dtPicker(+cur.due || 0);
      const box = UI.el('<div></div>'); box.appendChild(pick.el); box.classList.toggle('hidden', !avisa);
      body.appendChild(UI.list([{ items: [
        { label: 'Avisar', sub: 'Notificação no telemóvel', toggle: avisa, onToggle: on => { avisa = on; box.classList.toggle('hidden', !on); } },
        { label: 'Sinalizar', toggle: flag, onToggle: on => { flag = on; } }
      ] }]));
      body.appendChild(box);
      if (x) body.appendChild(UI.list([{ items: [{ label: 'Apagar lembrete', cls: 'danger center', chevron: false, onTap: () => { save(l => { const i = l.findIndex(z => z.id === cur.id); if (i > -1) l.splice(i, 1); }); sh.close(); repaint(); } }] }]));
      const sh = UI.sheet({ title: x ? 'Editar lembrete' : 'Novo lembrete', left: 'Cancelar', right: 'Guardar', body, onDone: () => {
        const text = body.querySelector('.rl-t').value.trim();
        if (!text) { UI.toast('Escreve o lembrete'); return false; }   /* devolver false deixa a folha aberta */
        const due = avisa ? pick.value() : 0;
        save(l => {
          const y = l.find(z => z.id === cur.id);
          /* notified a zero: mudar a hora volta a armar o aviso */
          if (y) Object.assign(y, { text, due, flag, notified: 0 });
          else l.push(Object.assign({}, cur, { text, due, flag, notified: 0 }));
        });
        repaint();
      } });
    };

    /* NOVA UI (Android): os mesmos lembretes e a mesma folha de edição; categorias em cartões, lista em cartão com círculos
       para concluir, botão flutuante para criar e um campo rápido no fim da lista */
    if (System.isAndroid && System.isAndroid()) {
      const g = UI.g;
      let aq = '';
      const CATS = [['today', 'Hoje', 'calendar', '#3E7BFA'], ['flag', 'Sinalizados', 'flag', '#FF8A1F'], ['all', 'Todos', 'list', '#6B6F7B'], ['done', 'Concluídos', 'checkCircle', '#2DBE60']];
      const TITLE = { today: 'Hoje', all: 'Todos os lembretes', done: 'Concluídos', flag: 'Sinalizados' };
      const FOOT_A = 'Com hora marcada, avisa-te mesmo com a app fechada se estiveres em jogo; se não estiveres, quando voltares (até 12 h depois). Fica guardado neste telemóvel.';
      const rootA = UI.view({ title: App.name('reminders'), large: true, cls: 'anote-rv', right: [{ icon: 'search', onTap: () => { sbox.classList.toggle('on'); if (sbox.classList.contains('on')) setTimeout(() => sin.focus(), 60); else { sin.value = ''; aq = ''; paintA(); } } }] });
      const sbox = UI.el(`<div class="anote-search">${g('search', 20)}<input type="text" placeholder="Pesquisar lembretes"><div class="anote-sx">${g('x', 16)}</div></div>`);
      const sin = sbox.querySelector('input');
      sin.oninput = () => { aq = sin.value.trim().toLowerCase(); paintA(); };
      sbox.querySelector('.anote-sx').onclick = () => { sin.value = ''; aq = ''; paintA(); sin.focus(); };
      const cats = UI.el('<div class="anote-cats"></div>');
      const catEls = {};
      CATS.forEach(([k, l, ic, c]) => { const e = UI.el(`<div class="anote-cat"><div class="anote-cic" style="background:${c}">${g(ic, 20)}</div><b></b><span></span></div>`); e.querySelector('span').textContent = l; e.onclick = () => { if (filter === k) return; filter = k; Sound.play('click'); paintA(); }; catEls[k] = e; cats.appendChild(e); });
      const listHolder = UI.el('<div></div>');
      const quick = UI.el(`<div class="anote-quick"><div class="anote-qplus">${g('plus', 18)}</div><input type="text" maxlength="200" placeholder="Adicionar lembrete (sem hora)"></div>`);
      const qin = quick.querySelector('input');
      qin.onkeydown = e => { if (e.key === 'Enter' && qin.value.trim()) { save(l => l.push({ id: Date.now(), text: qin.value.trim(), done: false, ts: Date.now(), due: 0 })); qin.value = ''; paintA(); } };
      const foot = UI.el('<div class="anote-foot"></div>');
      rootA.content.append(sbox, cats, listHolder, quick, foot);
      const fabA = UI.el(`<div class="anote-fab anote-fabr">${g('plus', 26)}</div>`); rootA.appendChild(fabA);
      fabA.onclick = () => { Sound.play('click'); editRem(); };
      const ltA = rootA.content.querySelector(':scope > .large-title'); const subA = document.createElement('small'); if (ltA) ltA.appendChild(subA);
      function paintA() {
        const list = all();
        const counts = { today: list.filter(paraHoje).length, all: list.length, done: list.filter(x => x.done).length, flag: list.filter(x => x.flag).length };
        const pend = list.length - counts.done; subA.textContent = pend ? (pend === 1 ? '1 por concluir' : pend + ' por concluir') : 'Tudo concluído';
        CATS.forEach(([k]) => { const e = catEls[k]; e.querySelector('b').textContent = counts[k]; e.classList.toggle('on', filter === k); });
        const items = list.filter(x => (!aq || String(x.text || '').toLowerCase().includes(aq))
          && (filter === 'all' || (filter === 'done' ? x.done : filter === 'flag' ? x.flag : paraHoje(x))))
          .sort((a, b) => (+a.due || 8e15) - (+b.due || 8e15));
        listHolder.innerHTML = '';
        listHolder.appendChild(UI.el(`<div class="anote-sec">${UI.esc(TITLE[filter])}</div>`));
        if (!items.length) { listHolder.appendChild(UI.el('<div class="anote-empty sm">Nada por aqui.</div>')); }
        else {
          const card = UI.el('<div class="anote-rcard"></div>');
          items.forEach(x => {
            const r = UI.el(`<div class="anote-rrow ${x.done ? 'done' : ''}"><div class="anote-chk ${x.done ? 'on' : ''}">${g('check', 14)}</div><div class="anote-rb"><b></b><span></span></div>${x.flag ? `<div class="anote-flag">${g('flag', 16)}</div>` : ''}</div>`);
            r.querySelector('b').textContent = x.text;
            const w = quando(x), sp = r.querySelector('.anote-rb span');
            if (w && +x.due) { sp.textContent = w.replace(/ · ⚑$/, ''); sp.classList.toggle('late', !x.done && +x.due < Date.now()); } else sp.remove();
            const chk = r.querySelector('.anote-chk');
            chk.onclick = e => { e.stopPropagation(); const on = !chk.classList.contains('on'); chk.classList.toggle('on', on); r.classList.toggle('done', on); Sound.play('click');
              save(l => { const y = l.find(z => z.id === x.id); if (y) y.done = on; }); win.timers.push(setTimeout(paintA, 350)); };
            r.onclick = () => editRem(x);
            card.appendChild(r);
          });
          listHolder.appendChild(card);
        }
        foot.textContent = (filter === 'today' ? 'Aqui só entram os lembretes com data até hoje. ' : '') + FOOT_A;
      }
      repaint = paintA;
      win._paint = () => { if (rootA.isConnected) paintA(); };
      paintA(); UI.setRoot(win, rootA);
      const offA = (window.Bridge && Bridge.on) ? Bridge.on('agenda', d => { if (d && d.key === 'reminders' && System.currentApp() === 'reminders') paintA(); }) : null;
      win.onClose = () => { try { offA && offA(); } catch (e) {} };
      return;
    }

    let rq = '';   /* texto da pesquisa dos Lembretes */
    const render = () => {
      const list = all();
      const counts = { today: list.filter(paraHoje).length, all: list.length, done: list.filter(x => x.done).length, flag: list.filter(x => x.flag).length };
      tiles.innerHTML = '';
      [['today', 'Hoje', 'calendar', 'var(--blue)'], ['flag', 'Sinalizados', 'flag', 'var(--orange)'], ['all', 'Todos', 'list', 'var(--gray)'], ['done', 'Concluídos', 'checkCircle', 'var(--green)']].forEach(([k, l, i, c]) => {
        const t = UI.el(`<div class="rl-tile" style="${filter === k ? 'outline:2px solid var(--blue)' : ''}"><div class="rl-icon" style="background:${c}">${UI.g(i)}</div><span class="n">${counts[k]}</span><div class="t">${l}</div></div>`);
        t.onclick = () => { filter = k; render(); }; tiles.appendChild(t);
      });
      holder.innerHTML = '';
      const items = list.filter(x => (!rq || String(x.text || '').toLowerCase().includes(rq))
        && (filter === 'all' || (filter === 'done' ? x.done : filter === 'flag' ? x.flag : paraHoje(x))))
        .sort((a, b) => (+a.due || 8e15) - (+b.due || 8e15));   /* os que têm hora primeiro, por ordem */
      holder.appendChild(UI.el(`<div class="group-header">${{ today: 'Hoje', all: 'Os meus lembretes', done: 'Concluídos', flag: 'Sinalizados' }[filter]}</div>`));
      if (!items.length) holder.appendChild(UI.el('<div class="group-footer">Nada por aqui.</div>'));
      else holder.appendChild(UI.list([{ items: items.map(x => ({
        check: x.done, onCheck: on => { save(l => { const y = l.find(z => z.id === x.id); if (y) y.done = on; }); win.timers.push(setTimeout(render, 350)); },
        label: x.text, sub: quando(x), cls: x.done ? 'done' : '', chevron: false,
        /* sem `nostop`: o ui.js ignora o toque em qualquer filho com essa classe, e o "…" - que é a
           única pista de que a linha se edita - não fazia nada. Agora o toque cai no onTap da linha. */
        right: `<div class="li-chev" style="color:var(--label3)">${UI.g('more')}</div>`,
        onTap: () => editRem(x)
      })) }]));
      holder.appendChild(UI.el(`<div class="group-footer">${(filter === 'today' ? 'Aqui só entram os lembretes com data até hoje. ' : '') + FOOT}</div>`));
      holder.appendChild(composer);
    };
    root.content.append(UI.search('Pesquisar', s => { rq = s; render(); }), tiles, holder);   /* o campo existia mas não filtrava nada */
    win._paint = () => { if (root.isConnected) render(); };
    render(); UI.setRoot(win, root);
    /* o aviso do Agenda marca o lembrete como avisado: com a app à frente vale a pena repintar.
       A guarda do currentApp é obrigatória - uma janela fechada continua viva no LRU e o listener
       continuava a disparar (foi o bug do som triplicado do Eats) - e o listener sai no fecho. */
    const off = (window.Bridge && Bridge.on) ? Bridge.on('agenda', d => { if (d && d.key === 'reminders' && System.currentApp() === 'reminders') render(); }) : null;
    win.onClose = () => { try { off && off(); } catch (e) {} };
  }
});
