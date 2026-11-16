/* ===================== AGENDA - dados e avisos de alarmes, lembretes e eventos =====================
   Mora aqui porque o clock.js é o primeiro dos três ficheiros da agenda (Relógio, Notas/Lembretes,
   Calendário) a carregar e já era daqui que saía o disparo dos alarmes.

   1) CAMADA DE DADOS. Alarmes, notas, lembretes, eventos e marcadores do Surf vivem no
      localStorage do CEF, na gaveta da personagem (Store). É uma limitação REAL - muda de PC ou
      limpa a cache e perde-se - e está escrita nas apps, sem prometer nuvem nenhuma. As apps só
      falam com Agenda.list / Agenda.edit: quando o servidor ganhar as tabelas e os RPCs troca-se o
      corpo destas duas funções e as apps ficam como estão.
      A SEMENTE tem de ser GRAVADA: o Store.get devolve o valor por omissão sem o escrever
      (store.js), por isso o alarme das 07:30 que a app mostrava de origem não existia em sítio
      nenhum - o widget do ecrã bloqueado dizia "Sem alarme", o disparo nunca o encontrava e
      editá-lo atirava TypeError (o find não devolvia nada, o Object.assign rebentava e a folha
      ficava aberta). Aqui a semente é escrita à primeira leitura, uma vez.

   2) AVISOS. Um intervalo só, no módulo e não numa janela: fechar a app não o mata, e é por isso
      que um lembrete avisa com a app fechada. O aviso sai pelo caminho do sistema (Notify.push):
      toca, fica no Centro de Notificações e, com o telemóvel guardado, o System.peek levanta-o uns
      segundos. NUNCA UI.alert: com o telemóvel no bolso o <body> está em display:none, o modal
      nascia invisível e sem som, e o jogador só o encontrava na abertura seguinte.
      O que se promete é um aviso, uma vez, e só com o jogador em jogo (isto corre no NUI): não há
      som a repetir, logo também não há botão "Parar" a fingir que para alguma coisa.
      ⚠️ ESTE É O ÚNICO DONO DO AVISO. Quem escreve na agenda por fora (a Vera, o Telefone, o Recado)
      GRAVA e chama `Agenda.kick()` - nunca agenda um aviso seu. Um `setTimeout` com `Notify.push` na
      Vera dava DOIS avisos ao mesmo lembrete (dois cartões e dois sons, que o DEDUPE do sound.js não
      junta por terem nomes diferentes) e morria ao fechar; este intervalo sobrevive.
   ================================================================================================= */
window.Agenda = (() => {
  /* um lembrete atrasado ainda avisa até 12 h depois (esteve fora do jogo à hora marcada); um evento
     do Calendário só avisa à hora (10 min) - um aviso de um evento da manhã à noite é lixo */
  const GRACE_REM = 12 * 36e5, GRACE_EV = 10 * 6e4;

  const arr = v => (Array.isArray(v) ? v : null);
  const seedOf = s => arr(typeof s === 'function' ? s() : s) || [];

  /* ---------- camada de dados (a trocar por RPCs sem mexer nas apps) ---------- */
  /* lê a lista; se a chave nunca foi gravada, grava a semente e devolve-a */
  function list(key, seed) {
    const cur = arr(Store.get(key, null));
    if (cur) return cur;
    const out = Store.set(key, seedOf(seed));
    pace();
    return out;
  }
  /* muda a lista e grava - é o único caminho de escrita das apps */
  function edit(key, seed, fn) {
    const l = list(key, seed);
    fn(l);
    Store.set(key, l);
    pace();
    return l;
  }
  /* leitura de fundo, sem semente: o relógio que dispara os avisos não inventa dados a ninguém */
  const raw = key => arr(Store.get(key, null)) || [];

  /* ---------- horas ---------- */
  /* evento do Calendário ('2026-09-16' + '15:00') → milissegundos locais; 0 se estiver estragado */
  function evDue(e) {
    if (!e || typeof e.date !== 'string') return 0;
    const d = e.date.split('-'), t = String(e.time || '').split(':');
    const y = +d[0], mo = +d[1], da = +d[2], h = +t[0], mi = +t[1];
    if (!(y > 1970) || !(mo >= 1 && mo <= 12) || !(da >= 1 && da <= 31) || !(h >= 0 && h <= 23) || !(mi >= 0 && mi <= 59)) return 0;
    return new Date(y, mo - 1, da, h, mi, 0, 0).getTime();
  }
  /* "Hoje, 18:00" · "Amanhã, 09:00" · "18 set, 14:30" (respeita o relógio de 12/24 h das Definições) */
  function whenText(ts) {
    const t = +ts; if (!t) return '';
    const d = new Date(t), n = new Date();
    const dias = Math.round((new Date(d.getFullYear(), d.getMonth(), d.getDate()) - new Date(n.getFullYear(), n.getMonth(), n.getDate())) / 864e5);
    const dia = dias === 0 ? 'Hoje' : dias === 1 ? 'Amanhã' : dias === -1 ? 'Ontem' : UI.fmtDate(d, true);
    return dia + ', ' + UI.fmtTime(d);
  }
  /* Escolher dia e hora só com <select>: no CEF não há o picker nativo do PearOS e o teclado é nosso.
     90 dias a contar de hoje - mais longe do que isso marca-se no Calendário. */
  function dtPicker(ts) {
    const sel = +ts ? new Date(+ts) : null;
    const hoje = new Date(); hoje.setHours(0, 0, 0, 0);
    const dias = [];
    for (let i = 0; i < 90; i++) dias.push(new Date(hoje.getFullYear(), hoje.getMonth(), hoje.getDate() + i));
    let pick = 0;
    if (sel) { const k = sel.toDateString(); const i = dias.findIndex(d => d.toDateString() === k); pick = i > -1 ? i : 0; }
    const h = sel ? sel.getHours() : 9, m = sel ? sel.getMinutes() : 0;
    const opt = (v, txt, on) => `<option value="${v}" ${on ? 'selected' : ''}>${UI.esc(txt)}</option>`;
    const dOpt = dias.map((d, i) => opt(i, i === 0 ? 'Hoje' : i === 1 ? 'Amanhã' : UI.fmtDate(d, true), i === pick)).join('');
    const hOpt = Array.from({ length: 24 }, (_, i) => opt(i, UI.pad(i), i === h)).join('');
    const mOpt = Array.from({ length: 60 }, (_, i) => opt(i, UI.pad(i), i === m)).join('');
    const el = UI.el(`<div class="picker"><select class="pdd">${dOpt}</select><select class="phh">${hOpt}</select><span style="font-size:22px;align-self:center">:</span><select class="pmm">${mOpt}</select></div>`);
    return { el, value() {
      const d = dias[+el.querySelector('.pdd').value] || dias[0];
      return new Date(d.getFullYear(), d.getMonth(), d.getDate(), +el.querySelector('.phh').value, +el.querySelector('.pmm').value, 0, 0).getTime();
    } };
  }

  /* ---------- avisos ---------- */
  const say = o => { try { return window.Notify ? Notify.push(o) : (UI.banner(o), null); } catch (e) { return null; } };
  const ping = key => { try { Bridge.emit('agenda', { key }); } catch (e) {} };
  const remPend = (r, now) => !!r && !r.done && !r.notified && +r.due > 0 && +r.due > now - GRACE_REM;
  const evPend = (e, now) => { if (!e || e.notified) return false; const d = evDue(e); return d > 0 && d > now - GRACE_EV; };
  const watching = () => { const now = Date.now();
    return raw('alarms').some(a => a && a.on) || raw('reminders').some(r => remPend(r, now)) || raw('events').some(e => evPend(e, now)); };

  let timer = null, fast = false, lastMin = '';
  function tick() {
    const d = new Date(), now = d.getTime();
    let tocou = false;
    /* alarmes: uma vez no minuto marcado (com 20 s de passo há sempre uma passagem nos primeiros 20 s
       de cada minuto). `critical` para o alarme passar o Não Perturbar, como no PearOS. */
    const mk = d.getHours() + ':' + d.getMinutes();
    if (mk !== lastMin && d.getSeconds() <= 20) {
      /* TODOS os alarmes marcados para aquele minuto, não só o primeiro: com dois alarmes para as 7:30
         tocava um e o outro ficava calado (o `lastMin` fecha o minuto logo a seguir ao primeiro), o que
         aparece ao jogador como "o meu alarme não tocou". */
      /* `days` (dias da semana, 0 = domingo) só existe nos alarmes criados no relógio do Android: sem ele
         (ou vazio) o alarme toca todos os dias, como sempre tocou no PearOS */
      const l = raw('alarms').filter(x => x && x.on && x.h === d.getHours() && x.m === d.getMinutes() && (!Array.isArray(x.days) || !x.days.length || x.days.includes(d.getDay())));
      if (l.length) { lastMin = mk; tocou = true; l.forEach(a => say({ app: 'clock', title: String(a.label || 'Alarme').slice(0, 80), msg: UI.pad(a.h) + ':' + UI.pad(a.m), sound: 'timer', critical: true, onTap: () => System.openApp('clock') })); }
    }
    /* lembretes com hora marcada */
    let mudou = false;
    const rl = raw('reminders');
    rl.forEach(r => { if (!remPend(r, now) || +r.due > now) return;
      r.notified = 1; mudou = true;
      say({ app: 'reminders', title: String(r.text || 'Lembrete').slice(0, 80), msg: 'Lembrete · ' + UI.fmtTime(new Date(+r.due)), sound: 'timer', onTap: () => System.openApp('reminders') }); });
    if (mudou) { Store.set('reminders', rl); ping('reminders'); tocou = true; }
    /* eventos do Calendário */
    mudou = false;
    const el = raw('events');
    el.forEach(e => { if (!evPend(e, now) || evDue(e) > now) return;
      e.notified = 1; mudou = true;
      say({ app: 'calendar', title: String(e.title || 'Evento').slice(0, 80), msg: 'Agora · ' + String(e.time || ''), sound: 'timer', onTap: () => System.openApp('calendar') }); });
    if (mudou) { Store.set('events', el); ping('events'); tocou = true; }
    /* os widgets do ecrã bloqueado contam alarmes/eventos/lembretes - só se repintam quando algo mudou */
    if (tocou) { try { if (window.Lock && Lock.renderWidgets) Lock.renderWidgets(); } catch (e) {} }
    pace();
  }
  /* Um intervalo só: 20 s enquanto há algo marcado (o alarme precisa de acertar o minuto) e 1 minuto
     quando não há - não zero, porque quem escreve na agenda não é só este ficheiro (a Vera cria
     alarmes e lembretes, o Telefone cria um lembrete de uma chamada perdida, o Recado mete eventos no
     Calendário) e um intervalo morto perdia tudo o que eles escrevessem. Parado custa um new Date()
     e três leituras em cache por minuto.
     Quem escreve por FORA do Agenda.list/edit tem de chamar `Agenda.kick()` (é este pace): sem isso o
     ritmo só acelerava no tick seguinte - até 60 s depois - e um alarme marcado para daí a meio minuto
     podia passar ao lado da janela dos 20 s. */
  function pace() {
    const want = watching();
    if (timer && want === fast) return;
    if (timer) clearInterval(timer);
    fast = want; timer = setInterval(tick, want ? 20000 : 60000);
  }
  pace();
  /* trocar de personagem limpa a cache do Store e muda as chaves: ao abrir o telemóvel confirma-se o passo */
  try { if (window.Bridge && Bridge.on) Bridge.on('phone:open', pace); } catch (e) {}

  return { list, edit, raw, say, kick: pace, whenText, dtPicker, evDue };
})();

/* ===================== RELÓGIO ===================== */
App.define('clock', {
  name: 'Relógio', statusBar: 'auto',
  /* os intervalos do relógio mundial e do cronómetro calam-se com a app em segundo plano: ao voltar,
     acerta-se já o que está no ecrã (e o cronómetro, se estiver a correr, volta aos 30 fps).
     A lista de alarmes também se repinta: a janela fechada fica viva no LRU e a lista muda pelas
     costas da app (a Vera cria e desliga alarmes) - sem isto voltava-se à app e via-se o ecrã antigo,
     com o risco de se tocar numa linha que já não existe. */
  resume(win) { try { win._worldTick && win._worldTick(); win._swKick && win._swKick(); win._alarmsPaint && win._alarmsPaint(); } catch (e) {} },
  open(win) {
    /* Android: o mesmo relógio (mesmos dados) com a cara do relógio da Nova UI (ClockNova, no fim deste ficheiro) */
    if (window.System && System.os === 'android' && window.ClockNova) return ClockNova.open(win);
    const g = UI.g, pad = UI.pad;
    const CITIES = [['Lisboa', 'Europe/Lisbon'], ['Los Santos', 'America/Los_Angeles'], ['Nova Iorque', 'America/New_York'], ['Londres', 'Europe/London'],
      ['Paris', 'Europe/Paris'], ['Tóquio', 'Asia/Tokyo'], ['Sydney', 'Australia/Sydney'], ['São Paulo', 'America/Sao_Paulo'], ['Dubai', 'Asia/Dubai'], ['Luanda', 'Africa/Luanda']];
    /* um Intl.DateTimeFormat por fuso, criado UMA vez: construí-lo é das operações de locale mais caras
       do V8 e o relógio mundial fazia-o para cada cidade a cada volta */
    const FMT = new Map();
    const tz = z => { let f = FMT.get(z); if (!f) { f = new Intl.DateTimeFormat('pt-PT', { hour: '2-digit', minute: '2-digit', timeZone: z }); FMT.set(z, f); } return f.format(new Date()); };
    const offset = z => { const n = new Date(); const loc = new Date(n.toLocaleString('en-US', { timeZone: z })); const h = Math.round((loc - new Date(n.toLocaleString('en-US'))) / 36e5); return h === 0 ? 'Hoje, mesma hora' : `Hoje, ${h > 0 ? '+' : ''}${h} h`; };

    /* ---- Relógio mundial ---- */
    const world = () => {
      const v = UI.view({ title: 'Relógio mundial', large: true, right: [{ icon: 'plus', onTap: () => {
        const body = UI.list([{ items: CITIES.map(([n, z]) => ({ label: n, sub: z, onTap: () => { Store.update('cities', ['Lisboa', 'Los Santos'], a => { if (!a.includes(n)) a.push(n); }); sh.close(); tabs.go(0); } })) }]);
        const sh = UI.sheet({ title: 'Escolher cidade', right: 'Cancelar', body });
      } }] });
      const render = () => {
        const cur = v.content.querySelector('.list,.empty'); cur && cur.remove();   /* sem `.empty` o intervalo de 15 s empilhava um "Sem cidades" novo a cada volta */
        const cities = Store.get('cities', ['Lisboa', 'Los Santos']);
        v.content.appendChild(UI.list([{ items: cities.map(n => { const z = (CITIES.find(c => c[0] === n) || CITIES[0])[1]; return {
          label: n, sub: offset(z), right: `<div class="tz-time">${tz(z)}</div>`, chevron: false,
          onTap: async () => { if (await UI.confirm('Remover', `Remover ${n}?`, 'Remover', true)) { Store.update('cities', [], a => { const i = a.indexOf(n); if (i > -1) a.splice(i, 1); }); render(); } }
        }; }) }]));
        if (!cities.length) v.content.appendChild(UI.empty('globe', 'Sem cidades', 'Toque em + para adicionar.'));
      };
      /* a volta de 15 s só reescreve as HORAS (o "Hoje, +N h" não muda de 15 em 15 s) e só com a app à
         frente: antes destruía e refazia a lista inteira, com 2 toLocaleString por cidade, para sempre -
         também com a janela escondida. Ao voltar à app o resume acerta logo as horas. */
      const tick = () => { const cities = Store.get('cities', ['Lisboa', 'Los Santos']); v.content.querySelectorAll('.tz-time').forEach((el, i) => { const n = cities[i]; if (n == null) return; const z = (CITIES.find(c => c[0] === n) || CITIES[0])[1]; const s = tz(z); if (el.textContent !== s) el.textContent = s; }); };
      win._worldTick = () => { if (v.isConnected) tick(); };
      render(); const t = setInterval(() => { if (!v.isConnected) { clearInterval(t); const i = win.timers.indexOf(t); if (i > -1) win.timers.splice(i, 1); return; } if (System.currentApp() !== 'clock') return; tick(); }, 15000); win.timers.push(t);
      return v;
    };

    /* ---- Alarmes ---- */
    /* a semente é uma FUNÇÃO: o Agenda.list grava-a e as edições mexem no array gravado - com um array
       constante estaríamos a mutar a própria semente */
    /* 1.1.8: o nome do alarme de origem é conteúdo do jogador para o tradutor do DOM (nunca se traduz depois de gravado):
       traduz-se AO SEMEAR, no idioma do telemóvel */
    const SEED = () => [{ id: 1, h: 7, m: 30, label: (window.L && L.t ? L.t('Trabalho') : 'Trabalho'), on: true }];
    const alarms = () => {
      const v = UI.view({ title: 'Alarmes', large: true, right: [{ icon: 'plus', onTap: () => editAlarm() }] });
      const render = () => {
        const cur = v.content.querySelector('.list,.empty'); cur && cur.remove();   /* o rodapé vive dentro do .list */
        const list = Agenda.list('alarms', SEED);
        if (!list.length) { v.content.appendChild(UI.empty('alarm', 'Sem alarmes', 'Toque em + para criar um alarme.')); return; }
        v.content.appendChild(UI.list([{ items: list.map(a => ({
          html: `<span class="alarm-time" style="color:${a.on ? 'var(--label)' : 'var(--label3)'}">${pad(a.h)}:${pad(a.m)}</span>`, sub: a.label || 'Alarme', toggle: a.on,
          onToggle: on => Agenda.edit('alarms', SEED, l => { const x = l.find(y => y.id === a.id); if (x) x.on = on; }),
          onTap: () => editAlarm(a)
        })) }, { footer: 'Toca à hora marcada com o telemóvel guardado, se estiveres em jogo: é um aviso, uma vez.' }]));
        v.content.querySelectorAll('.li').forEach((li, i) => { li.classList.remove('static'); li.onclick = e => { if (e.target.closest('.toggle')) return; editAlarm(list[i]); }; });
      };
      const editAlarm = a => {
        const hs = Array.from({ length: 24 }, (_, i) => `<option ${a && a.h === i ? 'selected' : ''}>${pad(i)}</option>`).join('');
        const ms = Array.from({ length: 60 }, (_, i) => `<option ${a && a.m === i ? 'selected' : ''}>${pad(i)}</option>`).join('');
        const body = UI.el(`<div><div class="picker"><select class="ph">${hs}</select><span style="font-size:28px;align-self:center">:</span><select class="pm">${ms}</select></div></div>`);
        body.appendChild(UI.list([{ items: [{ html: `<input type="text" class="lbl" placeholder="Etiqueta" value="${UI.esc(a ? a.label : '')}">`, cls: 'static' }] }]));
        if (a) body.appendChild(UI.list([{ items: [{ label: 'Apagar alarme', cls: 'danger center', chevron: false, onTap: () => { Agenda.edit('alarms', SEED, l => { const i = l.findIndex(x => x.id === a.id); if (i > -1) l.splice(i, 1); }); sh.close(); render(); } }] }]));
        const sh = UI.sheet({ title: a ? 'Editar alarme' : 'Novo alarme', left: 'Cancelar', right: 'Guardar', body, onDone: () => {
          const h = +body.querySelector('.ph').value, m = +body.querySelector('.pm').value, label = body.querySelector('.lbl').value.trim();
          Agenda.edit('alarms', SEED, l => {
            /* o alarme pode ter desaparecido entretanto (apagado noutro sítio, lista limpa): volta a
               entrar em vez de rebentar num Object.assign(undefined, …) e deixar a folha aberta */
            const x = a && l.find(y => y.id === a.id);
            if (x) Object.assign(x, { h, m, label });
            else l.push({ id: (a && a.id) || Date.now(), h, m, label, on: a ? a.on !== false : true });
          });
          render();
        } });
      };
      win._alarmsPaint = () => { if (v.isConnected) render(); };
      render();
      return v;
    };

    /* ---- Cronómetro ---- */
    let swStart = 0, swAcc = 0, swRun = false, laps = [];
    const stopwatch = () => {
      const v = UI.view({ title: 'Cronómetro' });
      const big = UI.el('<div class="clock-big">00:00,00</div>');
      const ctl = UI.el('<div class="clock-ctl"><div class="cbtn gray">Volta</div><div class="cbtn green">Iniciar</div></div>');
      const [bLap, bStart] = ctl.children;
      const lapsEl = UI.el('<div class="laps"></div>');
      const fmt = ms => { const c = Math.floor(ms / 10) % 100, s = Math.floor(ms / 1000) % 60, m = Math.floor(ms / 60000); return `${pad(m)}:${pad(s)},${pad(c)}`; };
      const now = () => swAcc + (swRun ? Date.now() - swStart : 0);
      const paint = () => { big.textContent = fmt(now()); };
      const renderLaps = () => { lapsEl.innerHTML = ''; if (laps.length) lapsEl.appendChild(UI.list([{ items: laps.map((l, i) => ({ label: `Volta ${laps.length - i}`, value: fmt(l), cls: 'static' })).slice(0) }])); };
      const sync = () => { bStart.textContent = swRun ? 'Parar' : (now() ? 'Iniciar' : 'Iniciar'); bStart.className = 'cbtn ' + (swRun ? 'red' : 'green'); bLap.textContent = swRun ? 'Volta' : (now() ? 'Repor' : 'Volta'); };
      /* 30 fps SÓ enquanto o cronómetro corre, a vista existe e a app está à frente. A guarda estava
         dentro do callback e não na existência do timer: fechar a app só esconde a janela (a vista
         continua ligada), por isso o intervalo de 33 ms acordava 30×/s para sempre depois de uma visita
         ao separador. Agora o intervalo nasce no Iniciar e morre sozinho quando o cronómetro para, a
         vista sai ou a app deixa de estar à frente; o resume da app volta a ligá-lo. O tempo não se
         perde: now() vem do Date.now(), não de contar frames. */
      let t = null;
      const tickOff = () => { if (t == null) return; clearInterval(t); const i = win.timers.indexOf(t); if (i > -1) win.timers.splice(i, 1); t = null; };
      const tickOn = () => { if (t != null || !swRun) return; t = setInterval(() => { if (!v.isConnected || !swRun || System.currentApp() !== 'clock') { tickOff(); return; } if (!document.body.classList.contains('hidden')) paint(); }, 33); win.timers.push(t); };
      win._swKick = () => { if (v.isConnected) { paint(); tickOn(); } };
      bStart.onclick = () => { if (swRun) { swAcc = now(); swRun = false; } else { swStart = Date.now(); swRun = true; tickOn(); } sync(); };
      bLap.onclick = () => { if (swRun) { laps.unshift(now() - laps.reduce((a, b) => a + b, 0)); renderLaps(); } else if (now()) { swAcc = 0; laps = []; paint(); renderLaps(); sync(); } };
      v.content.append(big, ctl, lapsEl); paint(); sync(); renderLaps(); tickOn();
      return v;
    };

    /* ---- Temporizador ---- */
    let tEnd = 0, tLeft = 0, tRun = false, tTotal = 0, tT = null, tPaint = null;
    const tOn = () => { if (tT != null || !tRun) return; tT = setInterval(() => { if (!tRun) { clearInterval(tT); const i = win.timers.indexOf(tT); if (i > -1) win.timers.splice(i, 1); tT = null; return; } if (tPaint) tPaint(); }, 200); win.timers.push(tT); };
    const timer = () => {
      const v = UI.view({ title: 'Temporizador' });
      const sel = (n, cls) => `<select class="${cls}">${Array.from({ length: n }, (_, i) => `<option value="${i}" ${cls === 'tm' && i === 5 ? 'selected' : ''}>${pad(i)}</option>`).join('')}</select>`;
      const picker = UI.el(`<div class="picker">${sel(24, 'th')}<span style="align-self:center">h</span>${sel(60, 'tm')}<span style="align-self:center">min</span>${sel(60, 'ts')}<span style="align-self:center">s</span></div>`);
      const big = UI.el('<div class="clock-big hidden">00:00</div>');
      const ring = UI.el('<div style="text-align:center" class="hidden"><svg class="ring" viewBox="0 0 120 120" style="width:260px;height:260px"><circle cx="60" cy="60" r="54" fill="none" stroke="var(--fill3)" stroke-width="6"/><circle class="arc" cx="60" cy="60" r="54" fill="none" stroke="var(--orange)" stroke-width="6" stroke-linecap="round" stroke-dasharray="339.3" stroke-dashoffset="0" transform="rotate(-90 60 60)"/></svg></div>');
      const ctl = UI.el('<div class="clock-ctl"><div class="cbtn gray">Cancelar</div><div class="cbtn green">Iniciar</div></div>');
      const [bCancel, bStart] = ctl.children;
      const left = () => tRun ? Math.max(0, tEnd - Date.now()) : tLeft;
      const paint = () => {
        const l = left(); const s = Math.ceil(l / 1000);
        big.textContent = (s >= 3600 ? Math.floor(s / 3600) + ':' : '') + pad(Math.floor(s % 3600 / 60)) + ':' + pad(s % 60);
        ring.querySelector('.arc').setAttribute('stroke-dashoffset', 339.3 * (1 - (tTotal ? l / tTotal : 0)));
        if (tRun && l <= 0) { tRun = false; tLeft = 0; tTotal = 0; show(false); window.TimerState = { running: false };
          /* mesmo cuidado do alarme: com o telemóvel guardado o modal nascia invisível e sem som, e só
             se descobria na abertura seguinte - aí o aviso vai pelo Notify (som + espreitar) */
          if (document.body.classList.contains('hidden')) Agenda.say({ app: 'clock', title: 'Temporizador', msg: 'O tempo terminou.', sound: 'timer', critical: true });
          else { Sound.play('timer'); UI.alert({ title: 'Temporizador', msg: 'O tempo terminou.' }); } }
      };
      const show = active => { picker.classList.toggle('hidden', active); big.classList.toggle('hidden', !active); ring.classList.toggle('hidden', !active);
        bStart.textContent = tRun ? 'Pausar' : (active ? 'Retomar' : 'Iniciar'); bStart.className = 'cbtn ' + (tRun ? 'red' : 'green'); };
      const sync = () => { window.TimerState = { running: tRun, end: tEnd, cancel: () => { tRun = false; tLeft = 0; tTotal = 0; show(false); sync(); } }; };
      /* O intervalo de 200 ms só existe enquanto o temporizador CONTA (é ele que dispara o fim, mesmo com
         a vista fora do ecrã). Parado, a vista ligada repintava 5×/s os mesmos números para sempre - a
         janela escondida continua ligada. Há um só intervalo por app (tT) e pinta a vista mais recente
         (tPaint): trocar de separador já não junta um segundo intervalo a contar o mesmo. Na pausa
         pinta-se uma última vez, para os números ficarem exatos no instante em que parou. */
      tPaint = paint;
      bStart.onclick = () => {
        if (tRun) { tLeft = left(); tRun = false; show(true); paint(); sync(); return; }
        if (!tTotal) { const ms = ((+picker.querySelector('.th').value) * 3600 + (+picker.querySelector('.tm').value) * 60 + (+picker.querySelector('.ts').value)) * 1000; if (!ms) return; tTotal = ms; tLeft = ms; }
        tEnd = Date.now() + tLeft; tRun = true; show(true); paint(); sync(); tOn();
      };
      bCancel.onclick = () => { tRun = false; tLeft = 0; tTotal = 0; show(false); sync(); };
      sync();
      v.content.append(picker, ring, big, ctl); show(!!tTotal); paint(); tOn();
      return v;
    };

    const tabs = UI.tabbar(win, [
      { icon: 'globe', label: 'Mundial', view: world }, { icon: 'alarm', label: 'Alarmes', view: alarms },
      { icon: 'stopwatch', label: 'Cronómetro', view: stopwatch }, { icon: 'timer', label: 'Temporizador', view: timer }
    ], 0);
  }
});

/* ===================== RELÓGIO NO ANDROID (Nova UI 8.5) =====================
   O mesmo relógio com a cara do relógio da Nova UI: separadores em baixo (Alarme, Relógio mundial,
   Cronómetro, Temporizador), título grande na zona de leitura que encolhe para a barra ao fazer
   scroll, alarmes em cartões com os dias da semana e o interruptor, rodas para escolher as horas,
   cronómetro com dígitos grandes e temporizador com anel.
   Os DADOS são os mesmos do PearOS (Agenda 'alarms', Store 'cities', window.TimerState): um alarme
   criado num aparelho aparece no outro. O único campo novo é `days` (dias da semana, 0 = domingo);
   sem ele o alarme toca todos os dias, como sempre tocou (ver o tick da Agenda, acima).
   Regras do CEF: nada de filter nem backdrop-filter, só transform/opacity animam, e nada se volta a
   construir a cada volta dos intervalos (só textos e classes mudam).
   ============================================================================ */
window.ClockNova = (() => {
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
  const pad = n => String(n).padStart(2, '0');
  const esc = s => UI.esc(s);
  const range = n => Array.from({ length: n }, (_, i) => i);
  const DL = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];                 /* letras dos dias (domingo primeiro, como o getDay) */
  const DLx = () => DL.map((x, i) => UI.wdNarrow ? UI.wdNarrow(i) : x);   /* as mesmas no idioma escolhido, lidas na hora de desenhar */
  const DN = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
  const MS = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
  const CITIES = [['Lisboa', 'Europe/Lisbon'], ['Los Santos', 'America/Los_Angeles'], ['Nova Iorque', 'America/New_York'], ['Londres', 'Europe/London'],
    ['Paris', 'Europe/Paris'], ['Tóquio', 'Asia/Tokyo'], ['Sydney', 'Australia/Sydney'], ['São Paulo', 'America/Sao_Paulo'], ['Dubai', 'Asia/Dubai'], ['Luanda', 'Africa/Luanda']];
  const CITY0 = ['Lisboa', 'Los Santos'];   /* sempre por copia (CITY0.slice()): o Store.update sem a chave muda o valor de origem que recebe */
  const SEED = () => [{ id: 1, h: 7, m: 30, label: T('Trabalho'), on: true }];   /* 1.1.8: semeado já traduzido (ver o Clock do PearOS) */
  const is24 = () => !(window.System && System.state && System.state.clock24 === false);
  const hm = (h, m) => is24() ? { t: pad(h) + ':' + pad(m), ap: '' } : { t: ((h % 12) || 12) + ':' + pad(m), ap: h < 12 ? 'AM' : 'PM' };
  const hmText = d => { const t = hm(d.getHours(), d.getMinutes()); return t.t + (t.ap ? ' ' + t.ap : ''); };
  const dayShort = d => UI.fmtWdDayMon ? UI.fmtWdDayMon(d) : `${T(DN[d.getDay()])}, ${d.getDate()} ${T(MS[d.getMonth()])}`;   /* no idioma escolhido (ui.js) */
  const sameDay = (a, b) => a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
  const daysOf = a => (a && Array.isArray(a.days) ? a.days.filter(x => x >= 0 && x <= 6) : []);
  const visible = win => !!(win && win.isConnected && System.currentApp() === 'clock' && !document.body.classList.contains('hidden'));

  /* próxima vez que um alarme toca (sem dias = todos os dias) */
  function nextOf(a, now) {
    const ds = daysOf(a);
    for (let i = 0; i < 8; i++) {
      const d = new Date(now.getFullYear(), now.getMonth(), now.getDate() + i, a.h, a.m, 0, 0);
      if (d <= now || (ds.length && !ds.includes(d.getDay()))) continue;
      return d;
    }
    return null;
  }
  /* "Seg, Qua, Sex" · "Dias úteis" · "Fim de semana" · "Todos os dias" */
  function daysText(ds) {
    const s = [...new Set(ds)].sort((a, b) => a - b);
    if (!s.length || s.length === 7) return T('Todos os dias');
    if (s.join() === '1,2,3,4,5') return T('Dias úteis');
    if (s.join() === '0,6') return T('Fim de semana');
    return s.map(i => UI.wdShortI ? UI.wdShortI(i) : T(DN[i])).join(', ');
  }
  /* "7 horas e 30 minutos" · "45 minutos" · "1 dia e 3 horas" */
  function untilParts(ms) {
    const min = Math.max(1, Math.ceil(ms / 60000)), d = Math.floor(min / 1440), h = Math.floor(min % 1440 / 60), m = min % 60;
    const P = (n, one, many) => n + ' ' + T(n === 1 ? one : many);
    const parts = d ? [P(d, 'dia', 'dias')].concat(h ? [P(h, 'hora', 'horas')] : []) : (h ? [P(h, 'hora', 'horas')] : []).concat(m ? [P(m, 'minuto', 'minutos')] : []);
    /* 1.1.8: o "e" ia como palavra solta (T('e')) e ficava em português em todos os idiomas ("13 hours e 4 minutes"): a
       ligação é um padrão exato ("%s e %s" → "%s and %s"), que o L.tf procura pela chave inteira */
    return parts.length > 1 ? TF('%s e %s', parts[0], parts[1]) : (parts[0] || '');
  }
  /* partes da hora noutro fuso, numa só formatação (um Intl.DateTimeFormat por fuso, criado UMA vez) */
  const FMT = new Map();
  function tzNow(z) {
    let f = FMT.get(z);
    if (!f) { try { f = new Intl.DateTimeFormat('en-US', { timeZone: z, hourCycle: 'h23', year: 'numeric', month: 'numeric', day: 'numeric', hour: 'numeric', minute: '2-digit' }); } catch (e) { f = null; } FMT.set(z, f); }
    const n = new Date();
    if (!f) return { h: n.getHours(), m: n.getMinutes(), y: n.getFullYear(), mo: n.getMonth() + 1, d: n.getDate() };
    const p = {}; f.formatToParts(n).forEach(x => { p[x.type] = x.value; });
    return { h: (+p.hour || 0) % 24, m: +p.minute || 0, y: +p.year, mo: +p.month, d: +p.day };
  }
  /* "Hoje · 8 h atrás" · "Amanhã · 1 h à frente" · "Hoje · mesma hora" */
  function offsetText(z) {
    const n = new Date(), p = tzNow(z);
    const there = Date.UTC(p.y, p.mo - 1, p.d, p.h, p.m), here = Date.UTC(n.getFullYear(), n.getMonth(), n.getDate(), n.getHours(), n.getMinutes());
    const diffMin = Math.round((there - here) / 60000), dd = Math.round((Date.UTC(p.y, p.mo - 1, p.d) - Date.UTC(n.getFullYear(), n.getMonth(), n.getDate())) / 864e5);
    const day = dd === 0 ? T('Hoje') : dd > 0 ? T('Amanhã') : T('Ontem');
    if (!diffMin) return day + ' · ' + T('mesma hora');
    const hrs = Math.abs(diffMin) / 60, txt = (Number.isInteger(hrs) ? String(hrs) : hrs.toFixed(1).replace('.', ',')) + ' h';
    return day + ' · ' + TF(diffMin > 0 ? '%s à frente' : '%s atrás', txt);
  }

  /* ---------- peças ---------- */
  function iconBtn(icon, label, onTap) {
    const b = UI.el(`<div class="aclk-ib" role="button" aria-label="${esc(label)}">${UI.g(icon)}</div>`);
    b.onclick = e => { e.stopPropagation(); Sound.play('click'); onTap(b, e); };
    return b;
  }
  /* Vista com título grande: o título vive na zona de leitura (terço de cima) e, ao fazer scroll, passa
     para a barra de 56 px que fica presa em cima (position:sticky). Só muda uma classe no scroll. */
  function heroView(o) {
    const v = UI.el(`<div class="view aclk-v ${o.cls || ''}"><div class="aclk-sb"></div><div class="content aclk-sc"><div class="aclk-hero ${o.big ? 'big' : ''}"><b class="aclk-ht"></b><span class="aclk-hs"></span></div><div class="aclk-bar"><div class="aclk-bt"></div><div class="aclk-ba"></div></div><div class="aclk-body"></div></div></div>`);
    v.content = v.querySelector('.aclk-sc'); v.body = v.querySelector('.aclk-body'); v.opts = { onPop: o.onPop };
    const hero = v.querySelector('.aclk-hero'), ht = v.querySelector('.aclk-ht'), hs = v.querySelector('.aclk-hs'), bt = v.querySelector('.aclk-bt'), ba = v.querySelector('.aclk-ba');
    v.setHero = (title, sub, small) => {
      if (ht.textContent !== title) ht.textContent = title;
      if (hs.textContent !== (sub || '')) hs.textContent = sub || '';
      const s = small || title; if (bt.textContent !== s) bt.textContent = s;
    };
    (o.actions || []).forEach(a => ba.appendChild(iconBtn(a.icon, a.label, a.onTap)));
    v.content.addEventListener('scroll', () => v.classList.toggle('aclk-col', v.content.scrollTop > hero.offsetHeight - 8), { passive: true });
    return v;
  }
  function plainView(cls) {
    const v = UI.el(`<div class="view aclk-v aclk-plain ${cls || ''}"><div class="aclk-sb"></div><div class="content aclk-sc"></div></div>`);
    v.content = v.querySelector('.aclk-sc'); v.body = v.content; v.opts = {};
    return v;
  }
  /* RODA (horas do alarme, tempo do temporizador): coluna com scroll e encaixe. A roda do rato anda um
     valor de cada vez (scroll-snap), arrastar com o botão esquerdo também roda e tocar num valor traz-o
     para o meio. Só a classe .on do valor do meio muda; nada é redesenhado. */
  const WH = 56;
  function wheel(values, cur, onChange, cls) {
    const el = UI.el(`<div class="aclk-wh no-dragscroll ${cls || ''}"><div class="aclk-wh-in"></div></div>`), inner = el.firstChild, items = inner.children;
    let idx = Math.max(0, values.findIndex(x => x.v === cur)), drag = null, moved = false;
    const mark = i => { if (items[idx]) items[idx].classList.remove('on'); idx = i; if (items[idx]) items[idx].classList.add('on'); };
    const pick = i => { i = Math.max(0, Math.min(values.length - 1, i)); if (i !== idx) { mark(i); if (onChange) onChange(values[i].v); } return i; };
    const go = (i, smooth) => { i = pick(i); el.scrollTo({ top: i * WH, behavior: smooth ? 'smooth' : 'auto' }); };
    values.forEach((x, i) => { const it = document.createElement('div'); it.className = 'aclk-wh-it'; it.textContent = x.t; it.onclick = () => { if (!moved) go(i, true); }; inner.appendChild(it); });
    el.addEventListener('scroll', () => pick(Math.round(el.scrollTop / WH)), { passive: true });
    el.addEventListener('pointerdown', e => { if (e.pointerType !== 'mouse' || e.button !== 0) return; drag = { y: e.clientY, st: el.scrollTop, id: e.pointerId }; moved = false; });
    el.addEventListener('pointermove', e => {
      if (!drag || e.pointerId !== drag.id) return;
      const dy = (e.clientY - drag.y) / UI.zoom();
      if (!moved) { if (Math.abs(dy) < 4) return; moved = true; el.style.scrollSnapType = 'none'; try { el.setPointerCapture(e.pointerId); } catch (x) {} }
      el.scrollTop = drag.st - dy;
    });
    const up = () => { if (!drag) return; drag = null; if (!moved) return; el.style.scrollSnapType = ''; go(Math.round(el.scrollTop / WH), true); setTimeout(() => { moved = false; }, 0); };
    el.addEventListener('pointerup', up); el.addEventListener('pointercancel', up);
    mark(idx);
    return { el, get value() { return values[idx].v; }, set(v, smooth) { const i = values.findIndex(x => x.v === v); if (i > -1) go(i, smooth); }, sync() { el.scrollTop = idx * WH; } };
  }

  function open(win) {
    win.classList.add('aclk-win');

    /* ================= ALARME ================= */
    const alarms = () => {
      const v = heroView({ cls: 'aclk-alv', actions: [{ icon: 'plus', label: T('Adicionar alarme'), onTap: () => editor(null) }, { icon: 'moreV', label: T('Mais opções'), onTap: b => more(b) }] });
      const list = UI.el('<div class="aclk-list"></div>');
      const foot = UI.el(`<div class="aclk-foot">${esc(T('O alarme avisa uma vez, à hora marcada, mesmo com o telemóvel guardado, desde que estejas em jogo.'))}</div>`);
      v.body.append(list, foot);
      const hero = () => {
        const l = Agenda.list('alarms', SEED), now = new Date();
        let best = null;
        l.forEach(a => { if (!a || !a.on) return; const d = nextOf(a, now); if (d && (!best || d < best)) best = d; });
        if (best) v.setHero(TF('Alarme dentro de %s', untilParts(best - now)), dayShort(best) + ', ' + hmText(best), T('Alarme'));
        else if (l.length) v.setHero(T('Todos os alarmes estão desligados'), T('Liga um alarme para o ouvires à hora marcada'), T('Alarme'));
        else v.setHero(T('Sem alarmes'), T('Toca em + para criar um alarme'), T('Alarme'));
      };
      const card = a => {
        const t = hm(a.h, a.m), ds = daysOf(a);
        const c = UI.el(`<div class="aclk-card aclk-al ${a.on ? '' : 'off'}"><div class="aclk-al-l"><span class="aclk-al-n"></span><div class="aclk-al-t"><b>${t.t}</b>${t.ap ? `<i>${t.ap}</i>` : ''}</div></div><div class="aclk-al-d">${DLx().map((x, i) => `<span class="${!ds.length || ds.includes(i) ? 'on' : ''}${i === 0 ? ' sun' : ''}">${x}</span>`).join('')}</div></div>`);
        c.querySelector('.aclk-al-n').textContent = a.label || T('Alarme');
        c.appendChild(UI.toggle(!!a.on, on => {
          Agenda.edit('alarms', SEED, l => { const x = l.find(y => y.id === a.id); if (x) x.on = on; });
          a.on = on; c.classList.toggle('off', !on); hero();
          try { if (window.Lock && Lock.renderWidgets) Lock.renderWidgets(); } catch (e) {}
        }));
        c.onclick = e => { if (e.target.closest('.toggle')) return; editor(a); };
        UI.longPress(c, () => UI.ctxMenu(c, [{ label: T('Editar'), icon: 'compose', onTap: () => editor(a) }, { label: T('Eliminar'), icon: 'trash', danger: true, onTap: () => del(a) }]));
        return c;
      };
      const render = () => {
        const l = Agenda.list('alarms', SEED).filter(a => a && a.h != null).slice().sort((a, b) => (a.h * 60 + a.m) - (b.h * 60 + b.m));
        list.textContent = '';
        l.forEach(a => list.appendChild(card(a)));
        foot.classList.toggle('hidden', !l.length);
        hero();
      };
      const del = async a => {
        if (!await UI.confirm(T('Eliminar alarme?'), '', T('Eliminar'), true)) return;
        Agenda.edit('alarms', SEED, l => { const i = l.findIndex(x => x.id === a.id); if (i > -1) l.splice(i, 1); });
        render(); try { if (window.Lock && Lock.renderWidgets) Lock.renderWidgets(); } catch (e) {}
      };
      const more = b => {
        const l = Agenda.list('alarms', SEED);
        const setAll = on => { Agenda.edit('alarms', SEED, x => x.forEach(a => { a.on = on; })); render(); try { if (window.Lock && Lock.renderWidgets) Lock.renderWidgets(); } catch (e) {} };
        const items = [];
        if (l.some(a => !a.on)) items.push({ label: T('Ligar todos'), icon: 'bell', onTap: () => setAll(true) });
        if (l.some(a => a.on)) items.push({ label: T('Desligar todos'), icon: 'bellOff', onTap: () => setAll(false) });
        if (l.length) items.push({ label: T('Eliminar todos'), icon: 'trash', danger: true, onTap: async () => { if (!await UI.confirm(T('Eliminar todos os alarmes?'), '', T('Eliminar'), true)) return; Agenda.edit('alarms', SEED, x => { x.length = 0; }); render(); } });
        if (!items.length) items.push({ label: T('Adicionar alarme'), icon: 'plus', onTap: () => editor(null) });
        UI.ctxMenu(b, items);
      };
      win._alarmsPaint = () => { if (v.isConnected) render(); };
      render();
      /* o "dentro de X" muda com o tempo: só o texto do título, e só com a app à frente */
      const t = setInterval(() => { if (!v.isConnected) { clearInterval(t); const i = win.timers.indexOf(t); if (i > -1) win.timers.splice(i, 1); return; } if (visible(win)) hero(); }, 20000);
      win.timers.push(t);
      return v;
    };

    /* editor de alarme: página inteira, como na Nova UI (rodas em cima, dias, nome, Cancelar/Guardar em baixo) */
    const editor = a => {
      const now = new Date();
      let H = a ? a.h : (now.getHours() + 1) % 24, M = a ? a.m : 0, days = daysOf(a).slice();
      const v = UI.el(`<div class="view full aclk-v aclk-ed"><div class="aclk-sb"></div><div class="content aclk-sc">
        <div class="aclk-ed-time"></div>
        <div class="aclk-card aclk-ed-rep"><div class="aclk-ed-when"><span></span><b></b></div><div class="aclk-dsel">${DLx().map((x, i) => `<div data-d="${i}" class="${days.includes(i) ? 'on' : ''}${i === 0 ? ' sun' : ''}">${x}</div>`).join('')}</div></div>
        <div class="aclk-card aclk-ed-nm"><input type="text" maxlength="40" placeholder="${esc(T('Nome do alarme'))}"></div>
        ${a ? `<div class="aclk-ed-del" role="button">${esc(T('Eliminar alarme'))}</div>` : ''}
        </div><div class="aclk-ed-btns"><div class="aclk-tb aclk-ed-no" role="button">${esc(T('Cancelar'))}</div><div class="aclk-tb aclk-ed-ok" role="button">${esc(T('Guardar'))}</div></div></div>`);
      v.content = v.querySelector('.aclk-sc'); v.opts = {};
      const inp = v.querySelector('input'); inp.value = a ? (a.label || '') : '';
      const when = v.querySelector('.aclk-ed-when');
      const paintWhen = () => {
        const d = nextOf({ h: H, m: M, days }, new Date()), td = new Date(), tm = new Date(td.getFullYear(), td.getMonth(), td.getDate() + 1);
        when.firstChild.textContent = daysText(days);
        when.lastChild.textContent = !d ? '' : sameDay(d, td) ? T('Hoje') : sameDay(d, tm) ? T('Amanhã') + ', ' + dayShort(d) : dayShort(d);
      };
      const tw = v.querySelector('.aclk-ed-time'), wheels = [];
      const colon = () => UI.el('<div class="aclk-wh-sep">:</div>');
      if (is24()) {
        const wh = wheel(range(24).map(i => ({ v: i, t: pad(i) })), H, x => { H = x; paintWhen(); });
        const wm = wheel(range(60).map(i => ({ v: i, t: pad(i) })), M, x => { M = x; paintWhen(); });
        tw.append(wh.el, colon(), wm.el); wheels.push(wh, wm);
      } else {
        let ap = H < 12 ? 0 : 1;
        const wa = wheel([{ v: 0, t: 'AM' }, { v: 1, t: 'PM' }], ap, x => { ap = x; H = (H % 12) + 12 * ap; paintWhen(); }, 'aclk-wh-ap');
        const wh = wheel([12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].map(i => ({ v: i % 12, t: String(i) })), H % 12, x => { H = x + 12 * ap; paintWhen(); });
        const wm = wheel(range(60).map(i => ({ v: i, t: pad(i) })), M, x => { M = x; paintWhen(); });
        tw.append(wa.el, wh.el, colon(), wm.el); wheels.push(wa, wh, wm);
      }
      v.querySelector('.aclk-dsel').onclick = e => {
        const d = e.target.closest('[data-d]'); if (!d) return; const i = +d.dataset.d;
        const k = days.indexOf(i); if (k > -1) days.splice(k, 1); else days.push(i);
        d.classList.toggle('on', k < 0); Sound.play('click'); paintWhen();
      };
      v.querySelector('.aclk-ed-no').onclick = () => UI.pop(v);
      v.querySelector('.aclk-ed-ok').onclick = () => {
        const label = inp.value.trim().slice(0, 40), ds = [...new Set(days)].sort((x, y) => x - y);
        Agenda.edit('alarms', SEED, l => {
          const x = a && l.find(y => y.id === a.id);
          if (x) Object.assign(x, { h: H, m: M, label, days: ds, on: true });
          else l.push({ id: (a && a.id) || Date.now(), h: H, m: M, label, days: ds, on: true });
        });
        UI.pop(v); if (win._alarmsPaint) win._alarmsPaint();
        try { if (window.Lock && Lock.renderWidgets) Lock.renderWidgets(); } catch (e) {}
        const d = nextOf({ h: H, m: M, days: ds }, new Date());
        if (d) UI.toast(TF('Alarme definido para daqui a %s', untilParts(d - new Date())), 2600);
      };
      const delB = v.querySelector('.aclk-ed-del');
      if (delB) delB.onclick = async () => {
        if (!await UI.confirm(T('Eliminar alarme?'), '', T('Eliminar'), true)) return;
        Agenda.edit('alarms', SEED, l => { const i = l.findIndex(x => x.id === a.id); if (i > -1) l.splice(i, 1); });
        UI.pop(v); if (win._alarmsPaint) win._alarmsPaint();
      };
      paintWhen();
      UI.push(win, v);
      wheels.forEach(w => w.sync()); requestAnimationFrame(() => wheels.forEach(w => w.sync()));
    };

    /* ================= RELÓGIO MUNDIAL ================= */
    const world = () => {
      const v = heroView({ cls: 'aclk-wov', big: true, actions: [{ icon: 'plus', label: T('Adicionar cidade'), onTap: () => addCity() }] });
      const list = UI.el('<div class="aclk-list"></div>'); v.body.appendChild(list);
      const cities = () => { const c = Store.get('cities', CITY0.slice()); return Array.isArray(c) ? c : CITY0.slice(); };
      const zone = n => (CITIES.find(c => c[0] === n) || CITIES[0])[1];
      const tick = () => {
        const n = new Date(), t = hm(n.getHours(), n.getMinutes());
        v.setHero(t.t + (t.ap ? ' ' + t.ap : ''), UI.fmtDate(n), T('Relógio mundial'));
        list.querySelectorAll('.aclk-city').forEach(c => {
          const p = tzNow(c.dataset.z), tt = hm(p.h, p.m), b = c.querySelector('.aclk-ct b'), i = c.querySelector('.aclk-ct i'), s = c.querySelector('.aclk-cs');
          if (b.textContent !== tt.t) b.textContent = tt.t;
          if (i.textContent !== tt.ap) i.textContent = tt.ap;
          const o = offsetText(c.dataset.z); if (s.textContent !== o) s.textContent = o;
        });
      };
      const render = () => {
        list.textContent = '';
        const cs = cities();
        v.classList.toggle('aclk-isempty', !cs.length);   /* vazio: o aviso fica ao centro do espaco livre (oneui-apps2.css) */
        if (!cs.length) list.appendChild(UI.el(`<div class="aclk-empty"><b>${esc(T('Sem cidades'))}</b><span>${esc(T('Toca em + para adicionar uma cidade.'))}</span></div>`));
        cs.forEach(n => {
          const c = UI.el(`<div class="aclk-card aclk-city" data-z="${esc(zone(n))}"><div class="aclk-cl"><b></b><span class="aclk-cs"></span></div><div class="aclk-ct"><b></b><i></i></div></div>`);
          c.querySelector('.aclk-cl b').textContent = n;
          UI.longPress(c, () => UI.ctxMenu(c, [{ label: T('Remover'), icon: 'trash', danger: true, onTap: () => { Store.update('cities', CITY0.slice(), a => { const i = a.indexOf(n); if (i > -1) a.splice(i, 1); }); render(); } }]));
          list.appendChild(c);
        });
        tick();
      };
      const addCity = () => {
        const cur = cities(), opts = CITIES.filter(c => !cur.includes(c[0]));
        if (!opts.length) { UI.toast(T('Já tens todas as cidades')); return; }
        const body = UI.list([{ items: opts.map(([n, z]) => ({ label: n, sub: offsetText(z), chevron: false, onTap: () => { Store.update('cities', CITY0.slice(), a => { if (!a.includes(n)) a.push(n); }); sh.close(); render(); } })) }]);
        const sh = UI.sheet({ title: T('Adicionar cidade'), right: T('Cancelar'), body });
      };
      win._worldTick = () => { if (v.isConnected) tick(); };
      render();
      const t = setInterval(() => { if (!v.isConnected) { clearInterval(t); const i = win.timers.indexOf(t); if (i > -1) win.timers.splice(i, 1); return; } if (visible(win)) tick(); }, 15000);
      win.timers.push(t);
      return v;
    };

    /* ================= CRONÓMETRO ================= */
    let swStart = 0, swAcc = 0, swRun = false, laps = [];   /* laps: duração de cada volta, a mais recente primeiro */
    const swNow = () => swAcc + (swRun ? Date.now() - swStart : 0);
    const fmtSW = ms => { const c = Math.floor(ms / 10) % 100, s = Math.floor(ms / 1000) % 60, m = Math.floor(ms / 60000) % 60, h = Math.floor(ms / 3600000); return { main: (h ? h + ':' + pad(m) : pad(m)) + ':' + pad(s), cs: ',' + pad(c) }; };
    const stopwatch = () => {
      const v = plainView('aclk-swv');
      v.body.innerHTML = `<div class="aclk-sw"><div class="aclk-sw-d"><b></b><i></i></div><div class="aclk-laps"><div class="aclk-lap-h"><span>${esc(T('Volta'))}</span><span>${esc(T('Tempo de volta'))}</span><span>${esc(T('Tempo total'))}</span></div><div class="aclk-lap-l"></div></div></div><div class="aclk-btns"><div class="aclk-pb gray" role="button"></div><div class="aclk-pb" role="button"></div></div>`;
      const sw = v.querySelector('.aclk-sw'), dMain = v.querySelector('.aclk-sw-d b'), dCs = v.querySelector('.aclk-sw-d i'), lapsL = v.querySelector('.aclk-lap-l');
      const [bL, bR] = v.querySelectorAll('.aclk-pb');
      const paint = () => { const f = fmtSW(swNow()); if (dMain.textContent !== f.main) dMain.textContent = f.main; dCs.textContent = f.cs; };
      const renderLaps = () => {
        lapsL.textContent = ''; let total = laps.reduce((x, y) => x + y, 0);
        laps.forEach((l, i) => { const row = UI.el(`<div class="aclk-lap"><span>${pad(laps.length - i)}</span><span>${fmtSW(l).main + fmtSW(l).cs}</span><span>${fmtSW(total).main + fmtSW(total).cs}</span></div>`); total -= l; lapsL.appendChild(row); });
        sw.classList.toggle('has-laps', laps.length > 0);
      };
      const sync = () => {
        const t = swNow();
        bL.classList.toggle('hidden', !swRun && !t);
        bL.textContent = swRun ? T('Volta') : T('Repor');
        bR.textContent = swRun ? T('Parar') : t ? T('Retomar') : T('Iniciar');
        bR.className = 'aclk-pb ' + (swRun ? 'red' : 'blue');
        v.querySelector('.aclk-btns').classList.toggle('one', !swRun && !t);
      };
      let t = null;
      const tickOff = () => { if (t == null) return; clearInterval(t); const i = win.timers.indexOf(t); if (i > -1) win.timers.splice(i, 1); t = null; };
      const tickOn = () => { if (t != null || !swRun) return; t = setInterval(() => { if (!v.isConnected || !swRun || System.currentApp() !== 'clock') { tickOff(); return; } if (!document.body.classList.contains('hidden')) paint(); }, 33); win.timers.push(t); };
      win._swKick = () => { if (v.isConnected) { paint(); tickOn(); } };
      bR.onclick = () => { Sound.play('click'); if (swRun) { swAcc = swNow(); swRun = false; tickOff(); paint(); } else { swStart = Date.now(); swRun = true; tickOn(); } sync(); };
      bL.onclick = () => {
        Sound.play('click');
        if (swRun) { const done = laps.reduce((x, y) => x + y, 0); laps.unshift(swNow() - done); renderLaps(); }
        else { swAcc = 0; laps = []; paint(); renderLaps(); sync(); }
      };
      paint(); renderLaps(); sync(); tickOn();
      return v;
    };

    /* ================= TEMPORIZADOR ================= */
    let tEnd = 0, tLeft = 0, tRun = false, tTotal = 0, tT = null, tPaint = null, tShow = null;
    let tPick = { h: 0, m: 5, s: 0 };
    const tRemain = () => tRun ? Math.max(0, tEnd - Date.now()) : tLeft;
    const tSync = () => { window.TimerState = { running: tRun, end: tEnd, cancel: () => { tRun = false; tLeft = 0; tTotal = 0; window.TimerState = { running: false }; if (tShow) tShow(); } }; };
    const tDone = () => {
      tRun = false; tLeft = 0; tTotal = 0; window.TimerState = { running: false };
      if (tShow) tShow();
      /* com o telemóvel guardado o aviso vai pelo Notify (som + espreitar), como no PearOS */
      if (document.body.classList.contains('hidden')) Agenda.say({ app: 'clock', title: T('Temporizador'), msg: T('O tempo terminou.'), sound: 'timer', critical: true });
      else { Sound.play('timer'); UI.alert({ title: T('Temporizador'), msg: T('O tempo terminou.') }); }
    };
    /* um só intervalo por app (é ele que dispara o fim, mesmo com o separador fechado), e só enquanto conta */
    const tOn = () => { if (tT != null || !tRun) return; tT = setInterval(() => { if (!tRun) { clearInterval(tT); const i = win.timers.indexOf(tT); if (i > -1) win.timers.splice(i, 1); tT = null; return; } if (tRemain() <= 0) { tDone(); return; } if (tPaint) tPaint(); }, 200); win.timers.push(tT); };
    const PRESETS = [['Café', 180], ['Ovos', 600], ['Pausa', 900]];
    const timer = () => {
      const v = plainView('aclk-tmv'), C = 2 * Math.PI * 138;
      v.body.innerHTML = `<div class="aclk-tm-pick"><div class="aclk-tm-lbl"><span>${esc(T('Horas'))}</span><span>${esc(T('Minutos'))}</span><span>${esc(T('Segundos'))}</span></div><div class="aclk-tm-wh"></div>
        <div class="aclk-pre-h">${esc(T('Temporizadores predefinidos'))}</div><div class="aclk-pre">${PRESETS.map(([n, s]) => `<div class="aclk-pre-it" data-s="${s}" role="button"><b>${pad(Math.floor(s / 3600))}:${pad(Math.floor(s % 3600 / 60))}:${pad(s % 60)}</b><span>${esc(T(n))}</span></div>`).join('')}</div></div>
        <div class="aclk-tm-run"><div class="aclk-ring"><svg viewBox="0 0 300 300"><circle class="bg" cx="150" cy="150" r="138"/><circle class="arc" cx="150" cy="150" r="138" stroke-dasharray="${C.toFixed(2)}" stroke-dashoffset="0" transform="rotate(-90 150 150)"/></svg><div class="aclk-ring-t"><b></b><span></span></div></div></div>
        <div class="aclk-btns"><div class="aclk-pb gray" role="button">${esc(T('Cancelar'))}</div><div class="aclk-pb blue" role="button"></div></div>`;
      const pickEl = v.querySelector('.aclk-tm-pick'), runEl = v.querySelector('.aclk-tm-run'), arc = v.querySelector('.arc'), rb = v.querySelector('.aclk-ring-t b'), rs = v.querySelector('.aclk-ring-t span');
      const [bC, bS] = v.querySelectorAll('.aclk-pb');
      const wh = wheel(range(24).map(i => ({ v: i, t: pad(i) })), tPick.h, x => { tPick.h = x; syncBtn(); });
      const wm = wheel(range(60).map(i => ({ v: i, t: pad(i) })), tPick.m, x => { tPick.m = x; syncBtn(); });
      const ws = wheel(range(60).map(i => ({ v: i, t: pad(i) })), tPick.s, x => { tPick.s = x; syncBtn(); });
      v.querySelector('.aclk-tm-wh').append(wh.el, UI.el('<div class="aclk-wh-sep">:</div>'), wm.el, UI.el('<div class="aclk-wh-sep">:</div>'), ws.el);
      const pickMs = () => (tPick.h * 3600 + tPick.m * 60 + tPick.s) * 1000;
      const syncBtn = () => { if (!tTotal) bS.classList.toggle('dis', !pickMs()); };
      v.querySelector('.aclk-pre').onclick = e => { const it = e.target.closest('[data-s]'); if (!it) return; const s = +it.dataset.s; Sound.play('click'); wh.set(Math.floor(s / 3600), true); wm.set(Math.floor(s % 3600 / 60), true); ws.set(s % 60, true); };
      const paint = () => {
        const l = tRemain(), s = Math.ceil(l / 1000);
        const txt = (s >= 3600 ? Math.floor(s / 3600) + ':' : '') + pad(Math.floor(s % 3600 / 60)) + ':' + pad(s % 60);
        if (rb.textContent !== txt) rb.textContent = txt;
        arc.setAttribute('stroke-dashoffset', (C * (1 - (tTotal ? l / tTotal : 0))).toFixed(2));
        const st = tRun ? TF('Termina às %s', hmText(new Date(tEnd))) : T('Em pausa');
        if (rs.textContent !== st) rs.textContent = st;
      };
      const show = () => {
        const active = !!tTotal;
        pickEl.classList.toggle('hidden', active); runEl.classList.toggle('hidden', !active);
        bC.classList.toggle('hidden', !active);
        v.querySelector('.aclk-btns').classList.toggle('one', !active);
        bS.textContent = tRun ? T('Pausar') : active ? T('Retomar') : T('Iniciar');
        bS.className = 'aclk-pb blue' + (!active && !pickMs() ? ' dis' : '');
        if (active) paint(); else requestAnimationFrame(() => [wh, wm, ws].forEach(w => w.sync()));
      };
      tPaint = paint; tShow = show;
      bS.onclick = () => {
        if (tRun) { tLeft = tRemain(); tRun = false; Sound.play('click'); show(); tSync(); return; }
        if (!tTotal) { const ms = pickMs(); if (!ms) { UI.toast(T('Escolhe um tempo primeiro')); return; } tTotal = ms; tLeft = ms; }
        Sound.play('click'); tEnd = Date.now() + tLeft; tRun = true; show(); tSync(); tOn();
      };
      bC.onclick = () => { Sound.play('click'); tRun = false; tLeft = 0; tTotal = 0; show(); tSync(); };
      [wh, wm, ws].forEach(w => w.sync());
      show(); tOn();
      return v;
    };

    win._novaTabs = UI.tabbar(win, [
      { icon: 'alarm', label: T('Alarme'), view: alarms }, { icon: 'globe', label: T('Relógio mundial'), view: world },
      { icon: 'stopwatch', label: T('Cronómetro'), view: stopwatch }, { icon: 'timer', label: T('Temporizador'), view: timer }
    ], 0);
  }
  return { open, wheel, nextOf };
})();
