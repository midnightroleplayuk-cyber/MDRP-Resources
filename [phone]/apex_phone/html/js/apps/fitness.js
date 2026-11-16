/* ===================== FITNESS (PearOS) / SAÚDE (Nova UI) =====================
   Três anéis por dia: Mover (kcal), Exercício (minutos ativos) e Passos. O que se mostra vem do servidor
   (server/fitness.lua: fitness.today / history / goals / awards) mais os deltas AINDA NÃO GRAVADOS que o
   client/fitness.lua manda à NUI a cada 5 s ('fitness:live'); quando o servidor aceita um delta manda o dia
   inteiro ('fitness:today'). Passos e calorias são ESTIMATIVAS a partir dos metros (0,75 m por passo a andar,
   1,1 m a correr; 0,052 kcal/m a andar, 0,075 kcal/m a correr), as mesmas contas do servidor.
   A estrutura constrói-se UMA vez por separador e cada atualização só troca texto, classes e o stroke-dashoffset
   dos anéis (sem keyframes em loop). O Android usa a MESMA marcação com o desenho da Nova UI (app-fitness.css,
   body.os-android). Mock do browser no fim do ficheiro (LocalDB.register). */
(() => {
  const g = UI.g;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf) ? L.tf(s, ...v) : String(s).replace(/%s/g, () => String(v.shift()));
  const isA = () => !!(System.isAndroid && System.isAndroid());
  const STEP_WALK = 0.75, STEP_RUN = 1.1, KCAL_WALK = 0.052, KCAL_RUN = 0.075;
  /* os três anéis: cor, nome e unidade (a cor do Android é a da Saúde da Nova UI) */
  const RINGS = [
    /* "Mover" com um espaço de largura zero no fim: a chave "Mover" já existe no i18n como a AÇÃO de mover (Déplacer / Sposta) e o anel
       chama-se outra coisa nessas línguas (Bouger / Movimento). A chave do anel é esta, invisível a olho, com entrada própria nos dicionários. */
    { k: 'kcal', label: 'Mover​', unit: 'KCAL', c: '#FA114F', ca: '#F2457A', r: 84 },
    { k: 'minutes', label: 'Exercício', unit: 'MIN', c: '#92E82A', ca: '#3E7BFA', r: 62 },
    { k: 'steps', label: 'Passos', unit: 'PASSOS', c: '#00D2F0', ca: '#2DBE60', r: 40 },
  ];
  const SW = 18;   /* espessura do anel grande */
  const AW = {
    first_steps: { name: 'Primeiros passos', how: 'Anda ou corre o teu primeiro quilómetro.', c: '#FA114F' },
    first_run: { name: 'Primeira corrida', how: 'Corre 500 metros no total.', c: '#92E82A' },
    walk_5k: { name: 'Dia de 5 km', how: 'Faz 5 km a pé num só dia.', c: '#FF9F0A' },
    steps_10k: { name: 'Dez mil passos', how: 'Dá dez mil passos num dia.', c: '#00D2F0' },
    rings_day: { name: 'Dia perfeito', how: 'Fecha os três anéis no mesmo dia.', c: '#BF5AF2' },
    streak_3: { name: 'Três dias seguidos', how: 'Fecha o anel Mover três dias seguidos.', c: '#FF6B2C' },
    streak_7: { name: 'Sete dias seguidos', how: 'Fecha o anel Mover sete dias seguidos.', c: '#FF3B30' },
    runner_10k: { name: 'Corredor de 10 km', how: 'Corre 10 km no total.', c: '#30D158' },
    steps_20k: { name: 'Vinte mil passos', how: 'Dá vinte mil passos num dia.', c: '#0A84FF' },
    marathon: { name: 'Maratona', how: 'Faz 42,2 km a pé no total.', c: '#FFD60A' },
    road_100: { name: 'Estrada 100', how: 'Percorre 100 km em veículo.', c: '#64D2FF' },
    century: { name: 'Cem quilómetros', how: 'Faz 100 km a pé no total.', c: '#5E5CE6' },
  };
  const AW_ORDER = ['first_steps', 'first_run', 'walk_5k', 'steps_10k', 'rings_day', 'streak_3', 'streak_7', 'runner_10k', 'steps_20k', 'marathon', 'road_100', 'century'];
  const MODE = { idle: 'Parado', walk: 'A andar', run: 'A correr', drive: 'Em veículo' };

  const n0 = v => { v = +v; return isFinite(v) && v > 0 ? v : 0; };
  const fmtN = (v, d = 0) => (UI.fmtNum ? UI.fmtNum(v, d, d) : (+v).toFixed(d));
  const fmtDist = m => { m = n0(m); return m < 1000 ? Math.round(m) + ' m' : fmtN(m / 1000, m < 10000 ? 1 : 0) + ' km'; };
  const fmtMin = s => { const m = Math.floor(n0(s) / 60); return m < 60 ? m + ' min' : Math.floor(m / 60) + ' h ' + (m % 60) + ' min'; };
  const clamp01 = v => Math.max(0, Math.min(1, isFinite(v) ? v : 0));
  const parseDay = s => { const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(s || ''); return m ? new Date(+m[1], +m[2] - 1, +m[3], 12) : new Date(); };
  const localDay = (d = new Date()) => `${d.getFullYear()}-${UI.pad(d.getMonth() + 1)}-${UI.pad(d.getDate())}`;
  const dayLong = s => { const d = parseDay(s); return UI.fmtDate(d); };
  const dayNarrow = s => { const d = parseDay(s); return (UI.wdNarrow ? UI.wdNarrow(d.getDay()) : ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][d.getDay()]); };
  const dayRel = (s, today) => { if (s === today) return T('Hoje'); const d = parseDay(s), t = parseDay(today); if (Math.round((t - d) / 864e5) === 1) return T('Ontem'); return UI.wdLong ? UI.wdLong(d) : UI.DIAS[d.getDay()]; };

  /* ---------- estado partilhado (a app, os widgets e o mock leem daqui) ---------- */
  const S = { cfg: null, base: null, live: null, hist: null, awards: null, at: 0 };
  const totals = () => {
    const t = (S.base && S.base.today) || {}, l = S.live || {};
    const walk = n0(t.walk) + n0(l.walk), run = n0(t.run) + n0(l.run), drive = n0(t.drive) + n0(l.drive), active = n0(t.active) + n0(l.active);
    return { walk, run, drive, active, steps: Math.floor(walk / STEP_WALK + run / STEP_RUN), kcal: walk * KCAL_WALK + run * KCAL_RUN };
  };
  const goals = () => Object.assign({ kcal: 400, minutes: 30, steps: 8000 }, (S.base && S.base.goals) || (S.cfg && S.cfg.goals) || {});
  const progress = (k, t, gl) => k === 'kcal' ? t.kcal / gl.kcal : k === 'minutes' ? (t.active / 60) / gl.minutes : t.steps / gl.steps;
  const valueOf = (k, t) => k === 'kcal' ? Math.round(t.kcal) : k === 'minutes' ? Math.floor(t.active / 60) : t.steps;
  let busy = null;
  async function loadBase(force) {
    if (!force && S.base && Date.now() - S.at < 20000) return S.base;
    if (busy) return busy;
    busy = (async () => {
      try {
        if (!S.cfg) S.cfg = (await Bridge.rpc('fitness.config')) || { enabled: true };
        const r = await Bridge.rpcRaw('fitness.today');
        if (r && !r.error && r.today) { S.base = r; S.at = Date.now(); S.err = null; } else S.err = (r && r.error) || 'rpc';
      } catch (e) { S.err = 'rpc'; }
      busy = null; return S.base;
    })();
    return busy;
  }
  const listeners = new Set();
  const notifyAll = () => listeners.forEach(fn => { try { fn(); } catch (e) {} });
  if (window.Bridge && Bridge.on) {
    Bridge.on('fitness:live', d => { if (d && typeof d === 'object') { S.live = d; notifyAll(); } });
    Bridge.on('fitness:today', v => { if (v && v.today) { S.base = v; S.at = Date.now(); notifyAll(); } });
    Bridge.on('session:changed', () => { S.base = null; S.live = null; S.hist = null; S.awards = null; S.at = 0; });
  }

  /* ---------- SVG dos anéis (desenhado uma vez; o paint só mexe no stroke-dashoffset) ---------- */
  function ringsSvg(size, cls) {
    const A = isA();
    const circ = RINGS.map(r => { const C = (2 * Math.PI * r.r).toFixed(2), c = A ? r.ca : r.c; return `<circle class="fit-tr" cx="100" cy="100" r="${r.r}" stroke="${c}"/><circle class="fit-pr" data-k="${r.k}" cx="100" cy="100" r="${r.r}" stroke="${c}" stroke-dasharray="${C}" stroke-dashoffset="${C}" transform="rotate(-90 100 100)"/>`; }).join('');
    return `<svg class="fit-rings ${cls || ''}" viewBox="0 0 200 200" width="${size}" height="${size}" aria-hidden="true">${circ}</svg>`;
  }
  function paintRings(svg, t, gl) {
    svg.querySelectorAll('.fit-pr').forEach(el => { const r = RINGS.find(x => x.k === el.dataset.k); const C = 2 * Math.PI * r.r; const p = clamp01(progress(r.k, t, gl)); const off = (C * (1 - p)).toFixed(2);
      if (el.getAttribute('stroke-dashoffset') !== off) el.setAttribute('stroke-dashoffset', off); el.classList.toggle('full', p >= 1); });
  }
  /* miniatura de três anéis (histórico, widget 2×2 do Android) */
  const miniRings = (t, gl, size) => { const A = isA(); return `<svg class="fit-mini" viewBox="0 0 48 48" width="${size}" height="${size}" aria-hidden="true">${RINGS.map((r, i) => { const rr = 20 - i * 6.5, C = 2 * Math.PI * rr, p = clamp01(progress(r.k, t, gl)), c = A ? r.ca : r.c; return `<circle cx="24" cy="24" r="${rr}" stroke="${c}" stroke-opacity=".25"/><circle cx="24" cy="24" r="${rr}" stroke="${c}" stroke-dasharray="${C.toFixed(2)}" stroke-dashoffset="${(C * (1 - p)).toFixed(2)}" transform="rotate(-90 24 24)"/>`; }).join('')}</svg>`; };

  const AWARD_MEDAL = (id, size) => { const a = AW[id] || { c: '#8E8E93' }; const u = 'fm' + id; return `<svg class="fit-medal" viewBox="0 0 100 100" width="${size}" height="${size}" aria-hidden="true"><defs><linearGradient id="${u}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".55"/><stop offset=".5" stop-color="#fff" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".18"/></linearGradient></defs><path class="fit-rib" d="M34 4h12l-6 28zM54 4h12l-6 28z" fill="${a.c}" opacity=".55"/><circle class="fit-mc" cx="50" cy="58" r="34" fill="${a.c}"/><circle cx="50" cy="58" r="34" fill="url(#${u})"/><circle cx="50" cy="58" r="26" fill="none" stroke="#fff" stroke-opacity=".55" stroke-width="2"/>${medalGlyph(id)}</svg>`; };
  function medalGlyph(id) {
    const P = window.Icons && Icons.P ? Icons.P : {};
    const map = { first_steps: 'walk', first_run: 'bolt', walk_5k: 'pin', steps_10k: 'walk', rings_day: 'star', streak_3: 'flame', streak_7: 'flame', runner_10k: 'bolt', steps_20k: 'walk', marathon: 'flag', road_100: 'car', century: 'nav' };
    return `<svg x="36" y="44" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">${P[map[id] || 'star'] || ''}</svg>`;
  }

  /* ---------- a app ---------- */
  App.define('fitness', {
    name: 'Fitness', category: 'Saúde', core: false, statusBar: 'auto',
    description: 'Três anéis por dia: calorias, minutos ativos e passos, contados enquanto andas, corres e conduzes. Histórico, tendências e prémios.',
    resume(win) { try { win._fitRefresh && win._fitRefresh(); } catch (e) {} },
    open(win) {
      const A = isA();
      let tabs = null, offFns = [];
      const views = {};
      /* ----- Resumo ----- */
      function summaryView() {
        const v = UI.view({ title: 'Resumo', large: true, cls: 'fit-v fit-sum', right: [{ label: 'Objetivos', onTap: () => goalsSheet() }] });
        const date = UI.el('<div class="fit-date"></div>'); v.content.insertBefore(date, v.content.firstChild);
        const rows = RINGS.map(r => `<div class="fit-row" data-k="${r.k}" style="--c:${A ? r.ca : r.c}"><i></i><div class="fit-rl"><span>${r.label}</span><b><em class="fit-val"></em><small class="fit-goal"></small></b></div><div class="fit-chk">${g('check', 16)}</div></div>`).join('');
        const h1 = UI.el('<div class="fit-h"><span>Anéis de atividade</span></div>');
        const c1 = UI.el(`<div class="fit-card fit-rc"><div class="fit-rwrap">${ringsSvg(176, 'big')}</div><div class="fit-rows">${rows}<div class="fit-livel"><i></i><span></span></div></div></div>`);
        v.content.append(h1, c1);
        const TR = [['steps', 'Passos', 'walk'], ['kcal', 'Calorias', 'flame'], ['dist', 'Distância a pé', 'nav'], ['active', 'Minutos ativos', 'clock'], ['drive', 'Em veículo', 'car'], ['run', 'A correr', 'bolt']];
        const trends = UI.el('<div class="fit-h"><span>Tendências</span><small>vs. média de 7 dias</small></div>');
        const grid = UI.el(`<div class="fit-grid">${TR.map(([k, l, ic]) => `<div class="fit-tile" data-k="${k}"><div class="fit-tt">${g(ic, 16)}<span>${l}</span></div><b></b><div class="fit-tsub"><i class="fit-arrow">${g('arrowUp', 14)}</i><span></span></div></div>`).join('')}</div>`);
        v.content.append(trends, grid);
        const streak = UI.el(`<div class="fit-h"><span>Sequência</span></div>`);
        const sc = UI.el(`<div class="fit-card fit-streak"><div class="fit-sico">${g('flame', 26)}</div><div class="fit-stx"><b></b><span>Fecha o anel Mover todos os dias para manter a sequência.</span></div></div>`);
        v.content.append(streak, sc);
        v.content.appendChild(UI.el('<div class="group-footer fit-foot">Os passos e as calorias são estimativas a partir da distância que percorres a pé e a correr; o que fazes em veículo não conta para os anéis. O dia muda à meia-noite do servidor.</div>'));
        const svg = c1.querySelector('svg.fit-rings');
        const err = UI.el('<div class="fit-err"></div>');
        v._paint = () => {
          const t = totals(), gl = goals(), base = S.base;
          const dtx = base && base.day ? UI.fmtDate(parseDay(base.day)) : UI.fmtDate(new Date()); date.textContent = A ? dtx : dtx.toUpperCase();
          paintRings(svg, t, gl);
          RINGS.forEach(r => { const row = c1.querySelector(`.fit-row[data-k="${r.k}"]`); const val = valueOf(r.k, t), gv = gl[r.k]; row.querySelector('.fit-val').textContent = fmtN(val); row.querySelector('.fit-goal').textContent = '/' + fmtN(gv) + ' ' + T(r.unit); row.classList.toggle('done', progress(r.k, t, gl) >= 1); });
          const lv = c1.querySelector('.fit-livel'); if (S.live) { lv.hidden = false; lv.className = 'fit-livel m-' + (S.live.mode || 'idle'); lv.querySelector('span').textContent = T(MODE[S.live.mode] || MODE.idle) + ' · ' + T('ao vivo'); } else lv.hidden = true;
          /* tendências: o valor de hoje contra a média dos 7 dias anteriores (histórico em memória; sem ele só o valor) */
          const H = S.hist && Array.isArray(S.hist.days) ? S.hist.days.slice(0, -1).slice(-7) : null;
          const avg = fn => H && H.length ? H.reduce((s, d) => s + fn(d), 0) / H.length : null;
          const vals = { steps: [t.steps, d => n0(d.steps), v => fmtN(v)], kcal: [t.kcal, d => n0(d.kcal), v => fmtN(v) + ' kcal'], dist: [t.walk + t.run, d => n0(d.walk) + n0(d.run), fmtDist], active: [t.active, d => n0(d.active), fmtMin], drive: [t.drive, d => n0(d.drive), fmtDist], run: [t.run, d => n0(d.run), fmtDist] };
          grid.querySelectorAll('.fit-tile').forEach(tile => { const [cur, pick, fmt] = vals[tile.dataset.k]; const a = avg(pick); tile.querySelector('b').textContent = fmt(cur); const sub = tile.querySelector('.fit-tsub'); const up = a == null ? null : cur >= a * 0.98;
            sub.classList.toggle('up', up === true); sub.classList.toggle('down', up === false); sub.classList.toggle('none', up === null); sub.querySelector('span').textContent = a == null ? T('Sem média ainda') : TF('Média %s', fmt(a)); });
          const st = (base && base.streak) || 0; sc.querySelector('b').textContent = st === 0 ? T('Ainda sem sequência') : st === 1 ? T('1 dia seguido') : TF('%s dias seguidos', st); sc.classList.toggle('on', st > 0);
          if (S.err && !S.base) { err.textContent = S.err === 'disabled' ? T('O servidor desligou o Fitness.') : T('Sem resposta do servidor. Tenta outra vez daqui a pouco.'); if (!err.isConnected) v.content.insertBefore(err, h1); } else if (err.isConnected) err.remove();
        };
        /* os anéis nascem vazios e enchem ao primeiro desenho (uma transição, sem loop) */
        requestAnimationFrame(() => requestAnimationFrame(() => v._paint()));
        if (!S.hist) Bridge.rpc('fitness.history', { days: 14 }).then(r => { if (r && Array.isArray(r.days)) { S.hist = r; if (v.isConnected) v._paint(); } });
        return v;
      }
      /* ----- Histórico ----- */
      function historyView() {
        const v = UI.view({ title: 'Histórico', large: true, cls: 'fit-v fit-hist' });
        let metric = 'kcal', sel = null;
        const seg = UI.seg(RINGS.map(r => r.label), 0, i => { metric = RINGS[i].k; paint(); });
        const chart = UI.el('<div class="fit-card fit-chart"><svg viewBox="0 0 400 190" aria-hidden="true"></svg><div class="fit-days"></div></div>');
        const det = UI.el(`<div class="fit-card fit-det"><div class="fit-dh">${miniRings({ walk: 0, run: 0, drive: 0, active: 0, steps: 0, kcal: 0 }, goals(), 56)}<div><b></b><span></span></div></div><div class="fit-dg"><div><span>${T('Mover​')}</span><b data-k="kcal"></b></div><div><span>${T('Exercício')}</span><b data-k="minutes"></b></div><div><span>${T('Passos')}</span><b data-k="steps"></b></div><div><span>${T('A pé')}</span><b data-k="walk"></b></div><div><span>${T('A correr')}</span><b data-k="run"></b></div><div><span>${T('Em veículo')}</span><b data-k="drive"></b></div></div></div>`);
        const listH = UI.el('<div class="fit-h"><span>Últimos 14 dias</span></div>'), list = UI.el('<div class="fit-card fit-dlist"></div>');
        v.content.append(seg, chart, det, listH, list);
        const svg = chart.querySelector('svg'), daysEl = chart.querySelector('.fit-days');
        let built = false;
        function build() {
          const H = S.hist; if (!H || !Array.isArray(H.days)) return; built = true;
          const n = H.days.length, W = 400, Hh = 190, pad = 10, bw = (W - pad * 2) / n;
          /* cada barra nasce com a altura TODA e escala por transform (scaleY) no paint: nada de animar height/y no CEF */
          svg.innerHTML = `<line class="fit-goalline" x1="${pad}" x2="${W - pad}" y1="40" y2="40"/>` + H.days.map((d, i) => { const x = pad + i * bw + bw * 0.22; return `<rect class="fit-bar" data-i="${i}" x="${x.toFixed(1)}" y="24" width="${(bw * 0.56).toFixed(1)}" height="${Hh - 44}" rx="4"/><rect class="fit-hit" data-i="${i}" x="${(pad + i * bw).toFixed(1)}" y="0" width="${bw.toFixed(1)}" height="${Hh}" fill="transparent"/>`; }).join('');
          daysEl.innerHTML = H.days.map((d, i) => `<span data-i="${i}">${UI.esc(dayNarrow(d.day))}</span>`).join('');
          svg.onclick = e => { const r = e.target.closest('[data-i]'); if (!r) return; sel = +r.dataset.i; Sound.play('tick'); paint(); };
          list.innerHTML = '';
          H.days.slice().reverse().forEach((d, k) => { const i = n - 1 - k; const row = UI.el(`<div class="fit-drow" data-i="${i}">${miniRings(d, goals(), 36)}<div class="fit-drt"><b></b><span></span></div><div class="fit-drv"></div></div>`); row.onclick = () => { sel = i; Sound.play('click'); paint(); v.content.scrollTo({ top: 0, behavior: 'smooth' }); }; list.appendChild(row); });
        }
        function paint() {
          const H = S.hist; if (!H || !Array.isArray(H.days) || !H.days.length) { if (!list.querySelector('.empty')) { list.innerHTML = ''; list.appendChild(UI.empty('walk', 'Ainda sem atividade', 'Anda, corre ou conduz com o telemóvel contigo e os dias aparecem aqui.')); } return; }
          if (!built) build();
          const gl = goals(), days = H.days, n = days.length, today = H.day || localDay();
          /* o dia de hoje junta os deltas ao vivo */
          const rowOf = d => d.day === today ? Object.assign({}, d, totals()) : d;
          const val = d => { const r = rowOf(d); return metric === 'kcal' ? r.kcal : metric === 'minutes' ? r.active / 60 : r.steps; };
          const goal = gl[metric], max = Math.max(goal * 1.15, ...days.map(val)), Hh = 190, top = 24, bottom = 20, scale = (Hh - top - bottom) / max;
          const ring = RINGS.find(r => r.k === metric), color = A ? ring.ca : ring.c;
          svg.style.setProperty('--c', color);
          const gy = (Hh - bottom - goal * scale).toFixed(1); const gl0 = svg.querySelector('.fit-goalline'); gl0.setAttribute('y1', gy); gl0.setAttribute('y2', gy);
          if (sel == null) sel = n - 1;
          const full = Hh - top - bottom;
          svg.querySelectorAll('.fit-bar').forEach(b => { const i = +b.dataset.i, vv = val(days[i]), h = Math.max(vv > 0 ? 3 : 0, vv * scale); const k = (h / full).toFixed(4); if (b.style.transform !== `scaleY(${k})`) b.style.transform = `scaleY(${k})`; b.classList.toggle('on', i === sel); b.classList.toggle('today', days[i].day === today); b.classList.toggle('closed', vv >= goal); });
          daysEl.querySelectorAll('span').forEach(s => s.classList.toggle('on', +s.dataset.i === sel));
          const d = rowOf(days[sel]); det.querySelector('.fit-dh b').textContent = dayRel(d.day, today); det.querySelector('.fit-dh span').textContent = dayLong(d.day);
          det.querySelector('.fit-dh .fit-mini').outerHTML = miniRings(d, gl, 56);
          const dv = { kcal: fmtN(d.kcal) + ' kcal', minutes: fmtMin(d.active), steps: fmtN(d.steps), walk: fmtDist(d.walk), run: fmtDist(d.run), drive: fmtDist(d.drive) };
          det.querySelectorAll('.fit-dg b').forEach(b => { b.textContent = dv[b.dataset.k]; });
          list.querySelectorAll('.fit-drow').forEach(row => { const dd = rowOf(days[+row.dataset.i]); row.classList.toggle('on', +row.dataset.i === sel); row.querySelector('.fit-drt b').textContent = dayRel(dd.day, today); row.querySelector('.fit-drt span').textContent = UI.fmtDate(parseDay(dd.day), true); row.querySelector('.fit-drv').textContent = fmtN(dd.kcal) + ' kcal · ' + fmtN(dd.steps) + ' ' + T('passos'); row.querySelector('.fit-mini').outerHTML = miniRings(dd, gl, 36); });
        }
        v._paint = () => paint();
        Bridge.rpc('fitness.history', { days: 14 }).then(r => { if (r && Array.isArray(r.days)) { S.hist = r; built = false; } if (v.isConnected) paint(); });
        paint();
        return v;
      }
      /* ----- Prémios ----- */
      function awardsView() {
        const v = UI.view({ title: 'Prémios', large: true, cls: 'fit-v fit-awv' });
        const sub = UI.el('<div class="fit-asub"></div>'); const grid = UI.el('<div class="fit-agrid"></div>');
        v.content.append(sub, grid);
        AW_ORDER.forEach(id => { const a = AW[id]; const c = UI.el(`<div class="fit-aw locked" data-id="${id}" style="--c:${a.c}">${AWARD_MEDAL(id, 84)}<b>${UI.esc(a.name)}</b><span></span></div>`); c.onclick = () => awardSheet(id); grid.appendChild(c); });
        const paint = () => {
          const L0 = S.awards && Array.isArray(S.awards.list) ? S.awards.list : null;
          if (!L0) { sub.textContent = T('A carregar prémios'); return; }
          const by = {}; L0.forEach(x => { by[x.id] = x; });
          const n = L0.filter(x => x.unlocked).length;
          sub.textContent = n === 0 ? T('Ainda sem prémios. Começa a mexer-te.') : n === 1 ? T('1 prémio desbloqueado') : TF('%s prémios desbloqueados', n);
          grid.querySelectorAll('.fit-aw').forEach(c => { const x = by[c.dataset.id]; const on = !!(x && x.unlocked); c.classList.toggle('locked', !on); c.classList.toggle('on', on);
            c.querySelector('span').textContent = on ? UI.fmtDate(new Date(+x.unlocked), true) : (x ? progressText(x) : ''); });
        };
        v._paint = paint;
        Bridge.rpc('fitness.awards').then(r => { if (r && Array.isArray(r.list)) S.awards = r; if (v.isConnected) paint(); });
        paint();
        return v;
      }
      const progressText = x => { if (x.kind === 'days') return TF('%s de %s dias', fmtN(x.value), fmtN(x.goal)); if (x.kind === 'rings') return TF('%s de %s anéis', fmtN(x.value), fmtN(x.goal)); const fmt = x.kind === 'dist' ? fmtDist : fmtN; return TF('%s de %s', fmt(x.value), fmt(x.goal)); };
      function awardSheet(id) {
        const a = AW[id]; const x = S.awards && S.awards.list ? S.awards.list.find(y => y.id === id) : null; const on = !!(x && x.unlocked);
        const body = UI.el(`<div class="fit-ash ${on ? 'on' : 'locked'}" style="--c:${a.c}">${AWARD_MEDAL(id, 150)}<b>${UI.esc(a.name)}</b><p>${UI.esc(a.how)}</p><div class="fit-ap"><i style="transform:scaleX(${x ? clamp01(x.value / x.goal).toFixed(3) : 0})"></i></div><span></span></div>`);
        body.querySelector('span').textContent = on ? TF('Desbloqueado a %s', UI.fmtDayMonth ? UI.fmtDayMonth(new Date(+x.unlocked), true) : UI.fmtDate(new Date(+x.unlocked))) : x ? progressText(x) : T('Bloqueado');
        UI.sheet({ title: 'Prémio', right: 'OK', body, cls: 'fit-sheet' });
      }
      /* ----- Objetivos (folha com três passos) ----- */
      function goalsSheet() {
        const gl = goals(), lim = (S.cfg && S.cfg.limits) || { kcal: { min: 100, max: 3000 }, minutes: { min: 5, max: 300 }, steps: { min: 1000, max: 50000 } };
        const STEP = { kcal: 10, minutes: 5, steps: 250 };
        const draft = Object.assign({}, gl);
        const body = UI.el('<div class="fit-gsheet"></div>');
        RINGS.forEach(r => { const row = UI.el(`<div class="fit-grow" style="--c:${A ? r.ca : r.c}"><div class="fit-gl"><i></i><span>${r.label}</span><small>${T(r.unit)}</small></div><div class="fit-gc"><div class="fit-gb minus">${g('minus', 20)}</div><b></b><div class="fit-gb plus">${g('plus', 20)}</div></div></div>`);
          const b = row.querySelector('b'); const show = () => { b.textContent = fmtN(draft[r.k]); };
          const step = dir => { const L1 = lim[r.k] || {}; const nx = draft[r.k] + dir * STEP[r.k]; draft[r.k] = Math.max(+L1.min || 1, Math.min(+L1.max || 1e9, nx)); show(); Sound.play('tick'); };
          row.querySelector('.minus').onclick = () => step(-1); row.querySelector('.plus').onclick = () => step(1); show(); body.appendChild(row); });
        body.appendChild(UI.el('<div class="group-footer">Os anéis fecham quando chegas ao objetivo do dia. Os limites são os do servidor.</div>'));
        UI.sheet({ title: 'Objetivos', left: 'Cancelar', right: 'Guardar', body, cls: 'fit-sheet', onDone: () => {
          Bridge.rpcRaw('fitness.goals.set', draft).then(r => { if (!r || r.error) { Sound.play('error'); UI.toast(r && r.error === 'range' ? T('Valor fora dos limites') : T('Não foi possível guardar')); return; } S.base = r; S.at = Date.now(); if (S.hist) S.hist.goals = r.goals; S.awards = null; UI.toast(T('Objetivos guardados')); repaint(); }); } });
      }
      const repaint = () => { Object.values(views).forEach(v => { if (v && v.isConnected && v._paint) v._paint(); }); };
      win._fitRefresh = () => { loadBase(true).then(repaint); };
      listeners.add(repaint); offFns.push(() => listeners.delete(repaint));
      const prevClose = win.onClose; win.onClose = () => { offFns.forEach(f => { try { f(); } catch (e) {} }); prevClose && prevClose(); };
      tabs = UI.tabbar(win, [
        { icon: 'activity', label: 'Resumo', view: () => (views.sum = summaryView()) },
        { icon: 'calendar', label: 'Histórico', view: () => (views.hist = historyView()) },
        { icon: 'star', label: 'Prémios', view: () => (views.aw = awardsView()) },
      ], 0);
      loadBase(false).then(repaint);
    }
  });
  App.alias('android', { fitness: 'Saúde' });
  /* para o harness e para quem quiser ler o estado (widgets de terceiros): carregar o dia e ver os totais */
  window.Fitness = { loadBase, totals, goals, get state() { return S; } };

  /* ---------- ícones (desenho original) ---------- */
  Icons.app.fitness = () => Icons.SVG(Icons.G('gFit', '#2C2C2E', '#000') + Icons.GL(RINGS.map((r, i) => { const rr = [34, 25, 16][i], C = 2 * Math.PI * rr, p = [.82, .62, .9][i]; return `<circle cx="50" cy="50" r="${rr}" fill="none" stroke="${r.c}" stroke-opacity=".28" stroke-width="8"/><circle cx="50" cy="50" r="${rr}" fill="none" stroke="${r.c}" stroke-width="8" stroke-linecap="round" stroke-dasharray="${(C * p).toFixed(1)} ${C.toFixed(1)}" transform="rotate(-90 50 50)"/>`; }).join('')));
  Icons.registerOS('android', { fitness: () => Icons.SVG(`<defs><linearGradient id="nvFitB" gradientUnits="userSpaceOnUse" x1="38" y1="0" x2="62" y2="100"><stop offset="0" stop-color="#4EE28F"/><stop offset="1" stop-color="#18A862"/></linearGradient><radialGradient id="nvFitL" gradientUnits="userSpaceOnUse" cx="30" cy="0" r="80"><stop offset="0" stop-color="#fff" stop-opacity=".18"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></radialGradient></defs><rect width="100" height="100" fill="url(#nvFitB)"/><rect width="100" height="100" fill="url(#nvFitL)"/><path d="M50 78 23 52a15 15 0 0 1 21-21l6 6 6-6a15 15 0 0 1 21 21z" fill="#fff" fill-opacity=".96"/><path d="M28 55h11l5-10 7 20 6-14 4 4h11" fill="none" stroke="#18A862" stroke-width="4.2" stroke-linecap="round" stroke-linejoin="round"/>`, true) });

  /* ---------- widget da home: Anéis de atividade (2×2 anéis; 4×2 anéis + os três valores, com os passos) ---------- */
  if (window.Widgets && Widgets.register) {
    let pullAt = 0;
    const pull = () => { if (Date.now() - pullAt < 30000) return; pullAt = Date.now(); loadBase(false).then(() => { try { Widgets.refreshType('fitness'); } catch (e) {} }); };
    listeners.add(() => { try { Widgets.refreshType('fitness'); } catch (e) {} });
    Widgets.register({ id: 'fitness', name: 'Anéis de atividade', sizes: ['2x2', '4x2'], app: 'fitness', style: 'padding:0',
      render: size => { if (!S.base) setTimeout(pull, 0); const t = totals(), gl = goals(), A = isA();
        const rings = `<svg class="fit-wr" viewBox="0 0 200 200" aria-hidden="true">${RINGS.map(r => { const C = 2 * Math.PI * r.r, p = clamp01(progress(r.k, t, gl)), c = A ? r.ca : r.c; return `<circle cx="100" cy="100" r="${r.r}" fill="none" stroke="${c}" stroke-opacity=".25" stroke-width="${SW}"/><circle cx="100" cy="100" r="${r.r}" fill="none" stroke="${c}" stroke-width="${SW}" stroke-linecap="round" stroke-dasharray="${C.toFixed(2)}" stroke-dashoffset="${(C * (1 - p)).toFixed(2)}" transform="rotate(-90 100 100)"/>`; }).join('')}</svg>`;
        const vals = RINGS.map(r => `<div class="fit-wv" style="--c:${A ? r.ca : r.c}"><span>${UI.esc(T(r.label))}</span><b>${fmtN(valueOf(r.k, t))}<small>/${fmtN(gl[r.k])}</small></b></div>`).join('');
        if (size === '4x2') return `<div class="fit-w s42"><div class="fit-wl">${rings}</div><div class="fit-wvals"><div class="fit-wt">${UI.esc(T(App.name('fitness')))}</div>${vals}</div></div>`;
        return `<div class="fit-w s2"><div class="fit-wt">${UI.esc(T(App.name('fitness')))}</div>${rings}</div>`; } });
  }

  /* ---------- mock do browser (localdb.js): o servidor de mentira, com 14 dias de dados e três prémios ---------- */
  if (window.LocalDB && LocalDB.register) {
    const G0 = Store.global || Store;
    const KEY = 'db:fitness';
    const dayOf = (off) => { const d = new Date(); d.setHours(12, 0, 0, 0); d.setDate(d.getDate() - off); return localDay(d); };
    const derive = r => { r.steps = Math.floor(r.walk / STEP_WALK + r.run / STEP_RUN); r.kcal = Math.round((r.walk * KCAL_WALK + r.run * KCAL_RUN) * 10) / 10; return r; };
    const seed = () => {
      let db = G0.get(KEY, null);
      if (db && db.days && db.seedDay === dayOf(0)) return db;
      const days = {};
      const pattern = [[6200, 900, 14200, 2900], [4100, 0, 22000, 1800], [8300, 1600, 9000, 3800], [2500, 300, 31000, 1100], [7400, 2200, 4000, 3600], [5600, 400, 18000, 2300], [9100, 3100, 2000, 4300], [3300, 0, 26000, 1500], [6800, 1200, 12000, 3000], [4800, 700, 15000, 2100], [7900, 2600, 6000, 3900], [5200, 900, 20000, 2400], [6100, 1500, 11000, 2800], [3600, 400, 9000, 1700]];
      pattern.forEach((p, i) => { const off = 13 - i; days[dayOf(off)] = derive({ walk: p[0], run: p[1], drive: p[2], active: p[3] }); });
      /* hoje: a meio do dia */
      days[dayOf(0)] = derive({ walk: 3480, run: 920, drive: 7600, active: 1140 });
      db = { seedDay: dayOf(0), days, goals: { kcal: 400, minutes: 30, steps: 8000 }, awards: { first_steps: Date.now() - 9 * 864e5, first_run: Date.now() - 8 * 864e5, steps_10k: Date.now() - 3 * 864e5 } };
      G0.set(KEY, db); return db;
    };
    const save = db => G0.set(KEY, db);
    const life = db => { const l = { walk: 0, run: 0, drive: 0, active: 0 }; Object.values(db.days).forEach(r => { l.walk += r.walk; l.run += r.run; l.drive += r.drive; l.active += r.active; }); l.steps = Math.floor(l.walk / STEP_WALK + l.run / STEP_RUN); l.kcal = Math.round(l.walk * KCAL_WALK + l.run * KCAL_RUN); return l; };
    const closed = (db, r) => ({ kcal: r.kcal >= db.goals.kcal, minutes: r.active / 60 >= db.goals.minutes, steps: r.steps >= db.goals.steps });
    const streak = db => { let n = 0, i = (db.days[dayOf(0)] || { kcal: 0 }).kcal >= db.goals.kcal ? 0 : 1; while (i < 60) { const r = db.days[dayOf(i)]; if (r && r.kcal >= db.goals.kcal) n++; else break; i++; } return n; };
    const view = db => { const t = db.days[dayOf(0)] || derive({ walk: 0, run: 0, drive: 0, active: 0 }); return { day: dayOf(0), today: Object.assign({ day: dayOf(0) }, t), goals: Object.assign({}, db.goals), closed: closed(db, t), streak: streak(db), life: life(db), awards: Object.keys(db.awards).length, total: AW_ORDER.length }; };
    const LIM = { kcal: { min: 100, max: 3000 }, minutes: { min: 5, max: 300 }, steps: { min: 1000, max: 50000 } };
    LocalDB.register('fitness.config', () => ({ enabled: true, goals: { kcal: 400, minutes: 30, steps: 8000 }, limits: LIM, awards: true, liveSeconds: 5, flushSeconds: 60 }));
    LocalDB.register('fitness.today', () => view(seed()));
    LocalDB.register('fitness.history', d => { const db = seed(); const n = Math.max(1, Math.min(60, Math.floor(+d.days || 14))); const out = []; for (let i = n - 1; i >= 0; i--) { const k = dayOf(i); out.push(Object.assign({ day: k }, db.days[k] || derive({ walk: 0, run: 0, drive: 0, active: 0 }))); } return { day: dayOf(0), days: out, goals: Object.assign({}, db.goals) }; });
    LocalDB.register('fitness.goals.get', () => Object.assign({ limits: LIM }, seed().goals));
    LocalDB.register('fitness.goals.set', d => { const db = seed(); for (const k of ['kcal', 'minutes', 'steps']) { if (d[k] == null) continue; const v = Math.round(+d[k]); if (!isFinite(v) || v < LIM[k].min || v > LIM[k].max) return { error: 'range', key: k, min: LIM[k].min, max: LIM[k].max }; db.goals[k] = v; } save(db); return view(db); });
    LocalDB.register('fitness.awards', () => { const db = seed(); const v = view(db), l = v.life, t = v.today; const of = { first_steps: [l.walk + l.run, 1000, 'dist'], first_run: [l.run, 500, 'dist'], walk_5k: [t.walk + t.run, 5000, 'dist'], steps_10k: [t.steps, 10000, 'steps'], rings_day: [Object.values(v.closed).filter(Boolean).length, 3, 'rings'], streak_3: [v.streak, 3, 'days'], streak_7: [v.streak, 7, 'days'], runner_10k: [l.run, 10000, 'dist'], steps_20k: [t.steps, 20000, 'steps'], marathon: [l.walk + l.run, 42195, 'dist'], road_100: [l.drive, 100000, 'dist'], century: [l.walk + l.run, 100000, 'dist'] };
      const list = AW_ORDER.map(id => { const [val, goal, kind] = of[id]; return { id, name: AW[id].name, kind, goal, value: Math.min(goal, Math.round(val * 10) / 10), unlocked: db.awards[id] || false }; }); return { list, count: Object.keys(db.awards).length, total: list.length, enabled: true }; });
  }
})();
