/* ============================================================
   POSIÇÃO NA MÃO (/phonepos, admin; 2026-10-03)
   Painel à esquerda do ecrã do jogo, com o telemóvel aberto e a animação a correr. Posição (metros) e rotação (graus)
   do telemóvel no osso da mão: campo + barra + botões -/+ e as setas do teclado na linha escolhida (Shift = passo maior,
   Alt = passo fino). Nada se ajusta sozinho. Cada mudança vai já para o Lua (posEdit) e o prop volta a prender-se.
   Dobráveis: Fechado / Aberto. Câmara: Jogo / Frente / Lado / Cima. "Esconder telemóvel" deixa ver a mão.
   Guardar = servidor (todos os jogadores); Repor = volta ao config.lua.
   ============================================================ */
window.PosEdit = (() => {
  let el = null, st = null, sel = null, sendT = null, step = 1;
  const STEPS = [{ id: 0, t: 'Fino', m: 0.0005, d: 0.25 }, { id: 1, t: 'Normal', m: 0.002, d: 1 }, { id: 2, t: 'Grosso', m: 0.01, d: 5 }];
  const ROWS = [['pos', 0, 'X'], ['pos', 1, 'Y'], ['pos', 2, 'Z'], ['rot', 0, 'X'], ['rot', 1, 'Y'], ['rot', 2, 'Z']];
  const LIM = { pos: [-0.5, 0.5], rot: [-360, 360] }, SL = { pos: [-0.3, 0.3], rot: [-180, 180] };
  const T = s => (window.L && L.t ? L.t(s) : s);
  const fmt = (k, v) => (k === 'pos' ? v.toFixed(4) : v.toFixed(2));
  const clamp = (k, v) => Math.max(LIM[k][0], Math.min(LIM[k][1], v));

  function send() { clearTimeout(sendT); sendT = setTimeout(() => { if (st) Bridge.call('posEdit', { pos: st.pos, rot: st.rot }); }, 30); }
  function paint() {
    if (!el || !st) return;
    ROWS.forEach(([k, i]) => {
      const r = el.querySelector(`.hpe-row[data-k="${k}"][data-i="${i}"]`); if (!r) return; const v = st[k][i];
      const inp = r.querySelector('input.hpe-num'); if (document.activeElement !== inp) inp.value = fmt(k, v);
      const sl = r.querySelector('input.hpe-sl'); sl.value = String(Math.max(SL[k][0], Math.min(SL[k][1], v)));
      r.classList.toggle('on', sel === k + i);
    });
    el.querySelectorAll('.hpe-step').forEach(b => b.classList.toggle('on', +b.dataset.s === step));
  }
  function set(k, i, v) { if (!st) return; v = clamp(k, +v || 0); st[k][i] = k === 'pos' ? Math.round(v * 10000) / 10000 : Math.round(v * 100) / 100; paint(); send(); }
  function nudge(k, i, dir, mul) { const s = STEPS[step]; set(k, i, st[k][i] + dir * (k === 'pos' ? s.m : s.d) * (mul || 1)); }

  function build() {
    el = document.createElement('div'); el.className = 'hpe'; el.setAttribute('data-noi18n', '');
    const row = (k, i, a) => `<div class="hpe-row" data-k="${k}" data-i="${i}"><b>${a}</b><button class="hpe-b" data-d="-1">-</button>`
      + `<input class="hpe-sl" type="range" min="${SL[k][0]}" max="${SL[k][1]}" step="${k === 'pos' ? 0.0005 : 0.25}"><button class="hpe-b" data-d="1">+</button>`
      + `<input class="hpe-num" type="text" inputmode="decimal" spellcheck="false"></div>`;
    el.innerHTML = `<div class="hpe-hd"><div><span class="hpe-t"></span><span class="hpe-sub"></span></div><button class="hpe-x" data-a="close">&#x2715;</button></div>`
      + `<div class="hpe-sec"><span class="hpe-st">${T('Posição')} <i>(m)</i></span>${ROWS.slice(0, 3).map(r => row(r[0], r[1], r[2])).join('')}</div>`
      + `<div class="hpe-sec"><span class="hpe-st">${T('Rotação do aparelho')} <i>(°)</i></span>${ROWS.slice(3).map(r => row(r[0], r[1], r[2])).join('')}</div>`
      + `<div class="hpe-sec hpe-line"><span class="hpe-st">${T('Passo')}</span><div class="hpe-seg">${STEPS.map(s => `<button class="hpe-step" data-s="${s.id}">${T(s.t)}</button>`).join('')}</div></div>`
      + `<div class="hpe-sec hpe-line hpe-fold"><span class="hpe-st">${T('Dobrável')}</span><div class="hpe-seg"><button data-a="fold0">${T('Fechado')}</button><button data-a="fold1">${T('Aberto')}</button></div></div>`
      + `<div class="hpe-sec hpe-line"><span class="hpe-st">${T('Câmara')}</span><div class="hpe-seg hpe-cams"><button data-cam="off" class="on">${T('Jogo')}</button><button data-cam="front">${T('Frente')}</button><button data-cam="side">${T('Lado')}</button><button data-cam="top">${T('Cima')}</button></div></div>`
      + `<label class="hpe-chk"><input type="checkbox" data-a="hide"> ${T('Esconder o ecrã do telemóvel')}</label>`
      + `<div class="hpe-hint">${T('Escolhe uma linha e usa as setas: Shift dá um passo maior, Alt um mais fino.')}</div>`
      + `<div class="hpe-ft"><button data-a="reset">${T('Repor config')}</button><button data-a="save" class="hpe-pri">${T('Guardar para todos')}</button></div>`;
    document.body.appendChild(el);
    el.addEventListener('pointerdown', e => e.stopPropagation());
    el.addEventListener('click', e => {
      const r = e.target.closest('.hpe-row'); if (r) { sel = r.dataset.k + r.dataset.i; }
      const b = e.target.closest('.hpe-b'); if (b && r) { nudge(r.dataset.k, +r.dataset.i, +b.dataset.d, e.shiftKey ? 5 : e.altKey ? 0.2 : 1); return; }
      const s = e.target.closest('.hpe-step'); if (s) { step = +s.dataset.s; paint(); return; }
      const c = e.target.closest('[data-cam]'); if (c) { el.querySelectorAll('[data-cam]').forEach(x => x.classList.toggle('on', x === c)); Bridge.call('posCam', c.dataset.cam === 'off' ? { on: false } : { on: true, view: c.dataset.cam }); return; }
      const a = e.target.closest('[data-a]'); if (!a) { paint(); return; }
      const act = a.dataset.a;
      if (act === 'close') close(true);
      else if (act === 'fold0' || act === 'fold1') { el.querySelectorAll('[data-a^="fold"]').forEach(x => x.classList.toggle('on', x === a)); Bridge.call('posFold', { open: act === 'fold1' }); }
      else if (act === 'save') Bridge.call('posSave', {});
      else if (act === 'reset') { if (st && st.cfg) { st.pos = st.cfg.pos.slice(); st.rot = st.cfg.rot.slice(); paint(); send(); } Bridge.call('posReset', {}); }
      else paint();
    });
    el.addEventListener('input', e => {
      const r = e.target.closest('.hpe-row'); if (!r) return;
      if (e.target.classList.contains('hpe-sl')) set(r.dataset.k, +r.dataset.i, e.target.value);
    });
    el.addEventListener('change', e => {
      if (e.target.matches('input[data-a="hide"]')) { document.body.classList.toggle('hpe-hide', e.target.checked); return; }
      const r = e.target.closest('.hpe-row'); if (!r || !e.target.classList.contains('hpe-num')) return;
      const v = parseFloat(String(e.target.value).replace(',', '.')); if (!isNaN(v)) set(r.dataset.k, +r.dataset.i, v); else paint();
    });
    el.addEventListener('keydown', e => { if (e.target.classList.contains('hpe-num') && e.key === 'Enter') e.target.blur(); });
    /* setas na linha escolhida (fora dos campos de texto) */
    document.addEventListener('keydown', e => {
      if (!el || !el.classList.contains('in') || !sel || (e.target && e.target.classList && e.target.classList.contains('hpe-num'))) return;
      const d = e.key === 'ArrowRight' || e.key === 'ArrowUp' ? 1 : e.key === 'ArrowLeft' || e.key === 'ArrowDown' ? -1 : 0; if (!d) return;
      e.preventDefault(); e.stopPropagation(); nudge(sel.slice(0, 3), +sel.slice(3), d, e.shiftKey ? 5 : e.altKey ? 0.2 : 1);
    }, true);
  }
  function open(d) {
    if (!el) build();
    st = { pos: (d.pos || [0, 0, 0]).map(Number), rot: (d.rot || [0, 0, 0]).map(Number), cfg: { pos: (d.cfgPos || [0, 0, 0]).map(Number), rot: (d.cfgRot || [0, 0, 0]).map(Number) } };
    sel = 'pos0';
    el.querySelector('.hpe-t').textContent = T('Posição na mão');
    el.querySelector('.hpe-sub').textContent = d.label || '';
    el.querySelector('.hpe-fold').style.display = d.fold ? '' : 'none';
    el.querySelectorAll('[data-a^="fold"]').forEach(x => x.classList.toggle('on', x.dataset.a === (d.angle < 90 ? 'fold1' : 'fold0')));
    el.querySelectorAll('[data-cam]').forEach(x => x.classList.toggle('on', x.dataset.cam === 'off'));
    const hide = el.querySelector('input[data-a="hide"]'); hide.checked = false; document.body.classList.remove('hpe-hide');
    paint(); el.classList.add('in');
  }
  function close(tell) { if (!el) return; el.classList.remove('in'); document.body.classList.remove('hpe-hide'); st = null; if (tell) Bridge.call('posClose', {}); }
  if (window.Bridge && Bridge.on) Bridge.on('posEditor', d => { if (d && d.open) open(d); else close(false); });
  return { open, close };
})();
