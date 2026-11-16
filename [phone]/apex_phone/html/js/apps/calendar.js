/* ===================== CALENDÁRIO =====================
   Os eventos passam pelo Agenda (clock.js): é ele que grava a semente e é ele que avisa à hora
   marcada, com a app fechada. Guardado no telemóvel desta personagem enquanto o servidor não tiver
   tabelas - está dito no rodapé do dia, sem prometer nuvem nenhuma.
   ====================================================== */
App.define('calendar', {
  name: 'Calendário',
  /* a janela fechada fica viva no LRU e os eventos mudam por fora (o Recado mete eventos no
     Calendário): ao voltar à app repinta-se - o Bridge.on('agenda') só chega quando o aviso dispara */
  resume(win) { try { win._paint && win._paint(); } catch (e) {} },
  open(win) {
    const key = d => `${d.getFullYear()}-${UI.pad(d.getMonth() + 1)}-${UI.pad(d.getDate())}`;
    const today = new Date();
    /* semente em função: o Agenda grava-a e as edições mexem no array gravado */
    /* 1.1.8: os títulos de exemplo semeiam-se já traduzidos (conteúdo do jogador para o tradutor do DOM) */
    const seed = () => { const tt = s => (window.L && L.t ? L.t(s) : s); return [{ id: 1, date: key(today), title: tt('Reunião na garagem'), time: '15:00', color: 'var(--blue)' }, { id: 2, date: key(new Date(today.getFullYear(), today.getMonth(), today.getDate() + 2)), title: tt('Pagar seguro'), time: '10:00', color: 'var(--red)' }]; };
    const events = () => Agenda.list('events', seed);
    const save = fn => Agenda.edit('events', seed, fn);
    let cur = new Date(today.getFullYear(), today.getMonth(), 1), sel = key(today);
    const COLORS = ['var(--blue)', 'var(--red)', 'var(--green)', 'var(--orange)', 'var(--purple)'];
    const AVISO = 'Avisamos à hora marcada, com a app fechada, se estiveres em jogo. Os eventos ficam guardados neste telemóvel.';

    /* cal-v / cal-today / cal-daylist: só o dobrável aberto as usa (apps.css: o mês à esquerda e o dia escolhido à direita) */
    const root = UI.view({ title: 'Calendário', cls: 'cal-v', right: [{ icon: 'plus', onTap: () => add() }] });
    /* cabeçalho como o Calendário do iOS: ano a vermelho por cima, mês em título grande à esquerda; mudar de mês nas setas redondas à direita */
    const head = UI.el(`<div class="cal-head"><div class="cal-ttl"><i></i><b></b></div><div class="cal-nav"><span class="prev">${UI.g('chevL', 18)}</span><span class="next">${UI.g('chevR', 18)}</span></div></div>`);
    const DOWL = () => [1, 2, 3, 4, 5, 6, 0].map(i => UI.wdNarrow ? UI.wdNarrow(i) : ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][i]);   /* segunda primeiro, no idioma escolhido */
    const dow = UI.el(`<div class="cal-dow">${DOWL().map(d => `<div>${d}</div>`).join('')}</div>`);
    const grid = UI.el('<div class="cal-grid"></div>');
    const dayList = UI.el('<div class="cal-daylist"></div>');
    const todayBtn = UI.el('<div class="li center cal-today" style="margin:6px 16px 0;border-radius:12px;background:var(--bg2)">Hoje</div>');
    todayBtn.onclick = () => { cur = new Date(today.getFullYear(), today.getMonth(), 1); sel = key(today); render(); };

    /* só a HORA: o dia do evento é o dia escolhido na grelha (que pode ser de qualquer mês), por isso
       não serve aqui o seletor de 90 dias dos Lembretes */
    const timePicker = (h, m) => {
      const opt = (v, txt, on) => `<option value="${v}" ${on ? 'selected' : ''}>${txt}</option>`;
      const el = UI.el(`<div class="picker"><select class="phh">${Array.from({ length: 24 }, (_, i) => opt(i, UI.pad(i), i === h)).join('')}</select><span style="font-size:22px;align-self:center">:</span><select class="pmm">${Array.from({ length: 60 }, (_, i) => opt(i, UI.pad(i), i === m)).join('')}</select></div>`);
      return { el, value: () => UI.pad(+el.querySelector('.phh').value) + ':' + UI.pad(+el.querySelector('.pmm').value) };
    };

    /* NOVA UI (Android): os mesmos eventos do Agenda e os mesmos campos (data, título, hora, cor). Mês com pontos coloridos
       (domingos a vermelho, sábados a azul), lista do dia escolhido em cartão, botão flutuante para criar e página do evento. */
    if (System.isAndroid && System.isAndroid()) {
      const g = UI.g;
      const AVISO_A = 'Avisamos à hora marcada, com a app fechada, se estiveres em jogo. Os eventos ficam guardados neste telemóvel.';
      const MES = m => { const s = UI.monthName ? UI.monthName(m) : UI.MESES[m]; return s.charAt(0).toUpperCase() + s.slice(1); };   /* no idioma escolhido */
      const root = UI.view({ title: '', cls: 'acal-v', right: [{ icon: 'calendar', onTap: () => goToday(), ref: b => { b.classList.add('acal-tb'); b.insertAdjacentHTML('beforeend', `<i class="acal-tbn">${today.getDate()}</i>`); } }] });
      const head = UI.el(`<div class="acal-head"><div class="acal-mt"><b></b><span></span></div><div class="acal-nav"><div class="acal-arw prev">${g('chevL', 20)}</div><div class="acal-arw next">${g('chevR', 20)}</div></div></div>`);
      const dowEl = UI.el(`<div class="acal-dow">${[1, 2, 3, 4, 5, 6, 0].map(i => UI.wdNarrow ? UI.wdNarrow(i) : ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][i]).map((d, i) => `<div class="${i === 5 ? 'sat' : i === 6 ? 'sun' : ''}">${d}</div>`).join('')}</div>`);
      const gridEl = UI.el('<div class="acal-grid"></div>');
      const dayEl = UI.el('<div class="acal-day"></div>');
      root.content.append(head, dowEl, gridEl, dayEl);
      const fab = UI.el(`<div class="acal-fab">${g('plus', 26)}</div>`); root.appendChild(fab);
      fab.onclick = () => { Sound.play('click'); addA(); };
      const goToday = () => { cur = new Date(today.getFullYear(), today.getMonth(), 1); sel = key(today); paintA(); };
      const month = d => { cur = new Date(cur.getFullYear(), cur.getMonth() + d, 1); Sound.play('click'); paintA(); };
      head.querySelector('.prev').onclick = () => month(-1); head.querySelector('.next').onclick = () => month(1);
      UI.swipe(gridEl, { left: () => month(1), right: () => month(-1), threshold: 60 });
      const sorted = l => l.slice().sort((a, b) => String(a.time).localeCompare(String(b.time)));
      function paintA() {
        head.querySelector('b').textContent = MES(cur.getMonth()); head.querySelector('span').textContent = cur.getFullYear();
        const first = (cur.getDay() + 6) % 7, dim = new Date(cur.getFullYear(), cur.getMonth() + 1, 0).getDate();
        const ev = events(); const byDay = {}; ev.forEach(e => { (byDay[e.date] = byDay[e.date] || []).push(e); });
        const rows = Math.ceil((first + dim) / 7);
        gridEl.innerHTML = '';
        for (let i = 0; i < rows * 7; i++) {
          const d = new Date(cur.getFullYear(), cur.getMonth(), i - first + 1); const k = key(d), out = d.getMonth() !== cur.getMonth();
          const c = UI.el(`<div class="acal-c${out ? ' out' : ''}${i % 7 === 5 ? ' sat' : i % 7 === 6 ? ' sun' : ''}${k === key(today) ? ' today' : ''}${k === sel ? ' sel' : ''}"><span class="acal-n">${d.getDate()}</span><span class="acal-dots"></span></div>`);
          const dots = c.querySelector('.acal-dots'); (byDay[k] || []).slice(0, 3).forEach(e => { const s = document.createElement('i'); s.style.background = e.color || 'var(--blue)'; dots.appendChild(s); });
          c.onclick = () => { sel = k; if (out) cur = new Date(d.getFullYear(), d.getMonth(), 1); paintA(); };
          gridEl.appendChild(c);
        }
        const sd = new Date(sel + 'T12:00:00');
        dayEl.innerHTML = '';
        const dh = UI.el('<div class="acal-dh"><b></b><span></span></div>'); dh.querySelector('b').textContent = UI.fmtDate(sd);
        const items = sorted(byDay[sel] || []);
        dh.querySelector('span').textContent = items.length ? (items.length === 1 ? '1 evento' : items.length + ' eventos') : 'Sem eventos';
        dayEl.appendChild(dh);
        if (items.length) {
          const card = UI.el('<div class="acal-list"></div>');
          items.forEach(e => { const r = UI.el(`<div class="acal-ev"><i class="acal-bar"></i><div class="acal-eb"><b></b><span></span></div>${g('chevR', 18)}</div>`);
            r.querySelector('.acal-bar').style.background = e.color || 'var(--blue)'; r.querySelector('b').textContent = e.title; r.querySelector('span').textContent = e.time || '';
            r.onclick = () => openEv(e); card.appendChild(r); });
          dayEl.appendChild(card);
        }
        dayEl.appendChild(UI.el(`<div class="acal-foot">${AVISO_A}</div>`));
      }
      /* criar: título, hora e cor numa só folha (a data é o dia escolhido no mês) */
      function addA() {
        let color = COLORS[events().length % COLORS.length];
        const body = UI.el(`<div class="acal-form"><div class="acal-fdate">${g('calendar', 18)}<span></span></div><input type="text" class="acal-in" maxlength="80" placeholder="Título do evento"><div class="acal-lbl">Hora</div><div class="acal-tp"></div><div class="acal-lbl">Cor</div><div class="acal-cols"></div></div>`);
        body.querySelector('.acal-fdate span').textContent = UI.fmtDate(new Date(sel + 'T12:00:00'));
        const tp = timePicker(9, 0); body.querySelector('.acal-tp').appendChild(tp.el);
        const cols = body.querySelector('.acal-cols');
        COLORS.forEach(c => { const s = UI.el(`<div class="acal-col${c === color ? ' on' : ''}"><i></i></div>`); s.querySelector('i').style.background = c; s.onclick = () => { color = c; cols.querySelectorAll('.acal-col').forEach(x => x.classList.toggle('on', x === s)); }; cols.appendChild(s); });
        const inp = body.querySelector('.acal-in');
        UI.sheet({ title: 'Novo evento', left: 'Cancelar', right: 'Guardar', cls: 'acal-sheet', body, onDone: () => {
          const title = inp.value.trim(); if (!title) { UI.toast('Escreve o título do evento'); return false; }
          save(l => l.push({ id: Date.now(), date: sel, title, time: tp.value(), color }));
          paintA();
        } });
        setTimeout(() => inp.focus(), 380);
      }
      /* página do evento: data, hora, aviso; mudar a hora volta a armar o aviso (como no PearOS) ou apagar */
      function openEv(e0) {
        const v = UI.view({ title: '', back: App.name('calendar'), cls: 'acal-ev-v', right: [{ icon: 'trash', onTap: async () => { if (await UI.confirm('Apagar evento', e0.title, 'Apagar', true)) { save(l => { const i = l.findIndex(x => x.id === e0.id); if (i > -1) l.splice(i, 1); }); UI.pop(win); paintA(); } } }] });
        const box = UI.el(`<div class="acal-det"><div class="acal-dtitle"><i class="acal-dbar"></i><b></b></div><div class="acal-card"><div class="acal-line">${g('calendar', 20)}<span class="d"></span></div><div class="acal-line">${g('clock', 20)}<span class="t"></span></div><div class="acal-line">${g('bell', 20)}<span class="n"></span></div></div><div class="acal-btn">${g('clock', 18)}<span>Mudar a hora</span></div><div class="acal-foot">${AVISO_A}</div></div>`);
        const fill = () => { const e = events().find(x => x.id === e0.id) || e0;
          box.querySelector('.acal-dbar').style.background = e.color || 'var(--blue)'; box.querySelector('b').textContent = e.title;
          box.querySelector('.d').textContent = UI.fmtDate(new Date(e.date + 'T12:00:00')); box.querySelector('.t').textContent = e.time || '';
          box.querySelector('.n').textContent = e.notified ? 'Já foi avisado' : 'Aviso à hora marcada'; return e; };
        fill();
        box.querySelector('.acal-btn').onclick = () => { const e = fill(); const p = String(e.time || '09:00').split(':'); const tp = timePicker(+p[0] || 9, +p[1] || 0);
          const body = UI.el('<div class="acal-form"></div>'); body.appendChild(tp.el);
          UI.sheet({ title: 'Hora do evento', left: 'Cancelar', right: 'Guardar', cls: 'acal-sheet', body, onDone: () => { save(l => { const x = l.find(y => y.id === e.id); if (x) { x.time = tp.value(); x.notified = 0; } }); fill(); paintA(); } }); };
        v.content.appendChild(box); UI.push(win, v);
      }
      win._paint = () => { if (root.isConnected) paintA(); };
      paintA(); UI.setRoot(win, root);
      const offA = (window.Bridge && Bridge.on) ? Bridge.on('agenda', d => { if (d && d.key === 'events' && System.currentApp() === 'calendar') paintA(); }) : null;
      win.onClose = () => { try { offA && offA(); } catch (e) {} };
      return;
    }

    function render() {
      { const mn = UI.monthName ? UI.monthName(cur.getMonth()) : UI.MESES[cur.getMonth()]; head.querySelector('b').textContent = mn.charAt(0).toUpperCase() + mn.slice(1); } head.querySelector('i').textContent = cur.getFullYear();
      grid.innerHTML = '';
      const first = (cur.getDay() + 6) % 7, dim = new Date(cur.getFullYear(), cur.getMonth() + 1, 0).getDate();
      const prevDim = new Date(cur.getFullYear(), cur.getMonth(), 0).getDate();
      const ev = events();
      for (let i = 0; i < 42; i++) {
        let d, dimc = false;
        if (i < first) { d = new Date(cur.getFullYear(), cur.getMonth() - 1, prevDim - first + i + 1); dimc = true; }
        else if (i - first >= dim) { d = new Date(cur.getFullYear(), cur.getMonth() + 1, i - first - dim + 1); dimc = true; }
        else d = new Date(cur.getFullYear(), cur.getMonth(), i - first + 1);
        const k = key(d);
        const c = UI.el(`<div class="cal-day ${dimc ? 'dim' : ''} ${k === key(today) ? 'today' : ''} ${k === sel ? 'sel' : ''} ${ev.some(e => e.date === k) ? 'has-ev' : ''}">${d.getDate()}</div>`);
        c.onclick = () => { sel = k; if (dimc) cur = new Date(d.getFullYear(), d.getMonth(), 1); render(); };
        grid.appendChild(c);
      }
      dayList.innerHTML = '';
      const sd = new Date(sel + 'T12:00:00');
      dayList.appendChild(UI.el(`<div class="group-header">${UI.fmtDate(sd)}</div>`));
      const items = ev.filter(e => e.date === sel).sort((a, b) => String(a.time).localeCompare(String(b.time)));
      if (!items.length) dayList.appendChild(UI.el('<div class="group-footer">Sem eventos.</div>'));
      else dayList.appendChild(UI.list([{ items: items.map(e => ({ html: `<span class="row"><span class="ev-dot" style="background:${e.color}"></span>${UI.esc(e.title)}</span>`, value: e.time, chevron: false,
        onTap: () => editEv(e) })) }]));
      dayList.appendChild(UI.el(`<div class="group-footer">${AVISO}</div>`));
    }
    async function add() {
      const title = await UI.prompt('Novo evento', UI.fmtDate(new Date(sel + 'T12:00:00')), 'Título'); if (!title) return;
      const body = UI.el('<div></div>');
      const tp = timePicker(9, 0);
      body.appendChild(tp.el);
      body.appendChild(UI.list([{ footer: AVISO }]));
      UI.sheet({ title: 'Hora do evento', left: 'Cancelar', right: 'Adicionar', body, onDone: () => {
        save(l => l.push({ id: Date.now(), date: sel, title, time: tp.value(), color: COLORS[l.length % COLORS.length] }));
        render();
      } });
    }
    /* tocar num evento: mudar a hora (o aviso volta a ser armado) ou apagá-lo */
    function editEv(e) {
      const p = String(e.time || '09:00').split(':');
      const body = UI.el('<div></div>');
      const tp = timePicker(+p[0] || 9, +p[1] || 0);
      body.appendChild(UI.el(`<div class="group-header">${UI.esc(e.title)}</div>`));
      body.appendChild(tp.el);
      body.appendChild(UI.list([{ items: [{ label: 'Apagar evento', cls: 'danger center', chevron: false, onTap: () => { save(l => { const i = l.findIndex(x => x.id === e.id); if (i > -1) l.splice(i, 1); }); sh.close(); render(); } }], footer: AVISO }]));
      const sh = UI.sheet({ title: UI.fmtDate(new Date(e.date + 'T12:00:00'), true), left: 'Cancelar', right: 'Guardar', body, onDone: () => {
        save(l => { const x = l.find(y => y.id === e.id); if (x) { x.time = tp.value(); x.notified = 0; } });   /* hora nova = aviso outra vez armado */
        render();
      } });
    }
    head.querySelector('.prev').onclick = () => { cur = new Date(cur.getFullYear(), cur.getMonth() - 1, 1); render(); };
    head.querySelector('.next').onclick = () => { cur = new Date(cur.getFullYear(), cur.getMonth() + 1, 1); render(); };
    root.content.append(head, dow, grid, todayBtn, dayList);
    win._paint = () => { if (root.isConnected) render(); };
    render(); UI.setRoot(win, root);
    /* repinta quando o Agenda avisa um evento (marca-o como avisado). Guarda de app à frente por causa
       do LRU - uma janela fechada continua viva - e o listener sai no fecho da janela. */
    const off = (window.Bridge && Bridge.on) ? Bridge.on('agenda', d => { if (d && d.key === 'events' && System.currentApp() === 'calendar') render(); }) : null;
    win.onClose = () => { try { off && off(); } catch (e) {} };
  }
});
