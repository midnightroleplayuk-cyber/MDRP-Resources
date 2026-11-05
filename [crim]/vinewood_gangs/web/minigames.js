'use strict';

/* Heist minigames: hack, thermite, drill. Shown over the game (not inside the tablet).
   The client sends { action: 'minigame', game, difficulty (1-3), time (seconds) } and gets back
   a 'minigameResult' callback with { success }. */

(() => {
  const root = document.createElement('div');
  root.id = 'game';
  root.className = 'game';
  root.hidden = true;
  document.body.append(root);

  const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : null;
  let active = null; // { finish, cleanup }

  function el(tag, cls, text) {
    const e = document.createElement(tag);
    if (cls) e.className = cls;
    if (text != null) e.textContent = text;
    return e;
  }

  function report(success) {
    if (!resource) { console.log('minigame result', success); return; }
    fetch(`https://${resource}/minigameResult`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ success }) });
  }

  // Frame shared by every game: title, instructions, a timer bar, and a result line
  function frame(title, help, seconds) {
    root.replaceChildren();
    const card = el('div', 'game-card');
    const head = el('div', 'game-head');
    head.append(el('h2', 'game-title', title), el('span', 'game-esc', 'Esc to give up'));
    const bar = el('div', 'game-timer');
    const fill = el('span');
    bar.append(fill);
    const body = el('div', 'game-body');
    const status = el('p', 'game-status', help);
    card.append(head, bar, body, status);
    root.append(card);
    root.hidden = false;

    const total = seconds * 1000;
    let left = total;
    let last = performance.now();
    let raf;
    const tick = (t) => {
      left -= t - last;
      last = t;
      fill.style.width = `${Math.max(0, (left / total) * 100)}%`;
      fill.classList.toggle('low', left < total * 0.25);
      if (left <= 0) { done(false, 'Out of time.'); return; }
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);

    let finished = false;
    const done = (success, message) => {
      if (finished) return;
      finished = true;
      cancelAnimationFrame(raf);
      status.textContent = message || (success ? 'Done.' : 'Failed.');
      status.className = success ? 'game-status ok' : 'game-status bad';
      if (active && active.cleanup) active.cleanup();
      setTimeout(() => { root.hidden = true; active = null; report(success); }, 900);
    };
    const penalty = (ms) => { left -= ms; };
    active = { finish: done };
    return { body, status, done, penalty };
  }

  /* Hack: find the code shown at the top in a grid of codes. A wrong pick costs time. */
  function hack(difficulty, seconds) {
    const rounds = 2 + difficulty;
    const size = 4 + difficulty; // grid is size x size
    const ui = frame('Bypass the security', `Find the matching code. ${rounds} codes to crack. Wrong picks cost time.`, seconds);
    const target = el('div', 'hack-target');
    const grid = el('div', 'hack-grid');
    grid.style.gridTemplateColumns = `repeat(${size}, 1fr)`;
    const progress = el('div', 'hack-progress');
    ui.body.append(target, grid, progress);

    const hex = () => Math.floor(Math.random() * 256).toString(16).toUpperCase().padStart(2, '0') + Math.floor(Math.random() * 256).toString(16).toUpperCase().padStart(2, '0');
    let round = 0;
    const next = () => {
      if (round >= rounds) { ui.done(true, 'Access granted.'); return; }
      const codes = new Set();
      while (codes.size < size * size) codes.add(hex());
      const list = [...codes];
      const answer = list[Math.floor(Math.random() * list.length)];
      target.textContent = answer;
      progress.textContent = `Code ${round + 1} of ${rounds}`;
      grid.replaceChildren(...list.map((c) => {
        const b = el('button', 'hack-cell', c);
        b.type = 'button';
        b.addEventListener('click', () => {
          if (c === answer) { round += 1; next(); } else { b.classList.add('wrong'); b.disabled = true; ui.penalty(3000); }
        });
        return b;
      }));
    };
    next();
  }

  /* Thermite: tiles flash, then click them back from memory. Three mistakes and it fails. */
  function thermite(difficulty, seconds) {
    const size = 4 + difficulty;           // 5x5, 6x6, 7x7
    const count = 3 + difficulty * 2;      // 5, 7, 9 tiles to remember
    const rounds = difficulty >= 2 ? 2 : 1;
    const ui = frame('Place the thermite', `Watch the tiles light up, then click them all. ${rounds > 1 ? 'Two rounds. ' : ''}Three mistakes and it fizzles.`, seconds);
    const grid = el('div', 'thermite-grid');
    grid.style.gridTemplateColumns = `repeat(${size}, 1fr)`;
    const info = el('div', 'hack-progress');
    ui.body.append(grid, info);

    let round = 0;
    let mistakes = 0;
    const play = () => {
      const picks = new Set();
      while (picks.size < count) picks.add(Math.floor(Math.random() * size * size));
      let found = 0;
      let showing = true;
      info.textContent = `Round ${round + 1} of ${rounds}  ·  Mistakes ${mistakes} of 3`;
      const cells = Array.from({ length: size * size }, (_, i) => {
        const b = el('button', picks.has(i) ? 'thermite-cell lit' : 'thermite-cell');
        b.type = 'button';
        b.addEventListener('click', () => {
          if (showing || b.classList.contains('found') || b.classList.contains('wrong')) return;
          if (picks.has(i)) {
            b.classList.add('found');
            found += 1;
            if (found === count) {
              round += 1;
              if (round >= rounds) ui.done(true, 'Thermite placed. Stand back.');
              else setTimeout(play, 500);
            }
          } else {
            b.classList.add('wrong');
            mistakes += 1;
            info.textContent = `Round ${round + 1} of ${rounds}  ·  Mistakes ${mistakes} of 3`;
            if (mistakes >= 3) ui.done(false, 'It fizzled out.');
          }
        });
        return b;
      });
      grid.replaceChildren(...cells);
      setTimeout(() => { showing = false; cells.forEach((c) => c.classList.remove('lit')); }, 1600 + count * 120);
    };
    play();
  }

  /* Drill: hold to drill deeper, but it heats up. Let go to cool. Overheat and the bit snaps. */
  function drill(difficulty, seconds) {
    const ui = frame('Drill through', 'Hold Space or the mouse button to drill. Let go before it overheats. Each pin you hit spikes the heat.', seconds);
    const wrap = el('div', 'drill');
    const depthBar = el('div', 'drill-bar');
    const depth = el('span', 'drill-depth');
    depthBar.append(depth);
    [25, 50, 75].forEach((p) => { const pin = el('i', 'drill-pin'); pin.style.left = `${p}%`; depthBar.append(pin); });
    const heatBar = el('div', 'drill-bar heat');
    const heat = el('span', 'drill-heat');
    heatBar.append(heat);
    wrap.append(el('label', 'drill-label', 'Depth'), depthBar, el('label', 'drill-label', 'Heat'), heatBar);
    ui.body.append(wrap);

    let d = 0;
    let t = 0;
    let holding = false;
    let pinsHit = 0;
    // Tuned so steady bursts (about a second on, a second off) get through; holding it down never does
    const heatRate = 14 + difficulty * 8;  // heat per second while drilling: 22 / 30 / 38
    const coolRate = 40;                   // heat lost per second while resting
    const speed = 10 - difficulty;         // depth per second while drilling: 9 / 8 / 7
    let last = performance.now();
    let raf;
    const loop = (now) => {
      const dt = Math.min(0.05, (now - last) / 1000);
      last = now;
      if (holding) { d += speed * dt; t += heatRate * dt; } else { t = Math.max(0, t - coolRate * dt); }
      const pin = Math.floor(d / 25);
      if (pin > pinsHit && pin <= 3) { pinsHit = pin; t += 14; }
      depth.style.width = `${Math.min(100, d)}%`;
      heat.style.width = `${Math.min(100, t)}%`;
      heat.classList.toggle('hot', t > 75);
      if (t >= 100) { ui.done(false, 'The bit snapped.'); return; }
      if (d >= 100) { ui.done(true, 'You\'re through.'); return; }
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);
    const down = (e) => { if (e.type === 'mousedown' || e.code === 'Space') { holding = true; e.preventDefault(); } };
    const up = (e) => { if (e.type === 'mouseup' || e.code === 'Space') holding = false; };
    window.addEventListener('keydown', down);
    window.addEventListener('keyup', up);
    root.addEventListener('mousedown', down);
    window.addEventListener('mouseup', up);
    active.cleanup = () => {
      cancelAnimationFrame(raf);
      window.removeEventListener('keydown', down);
      window.removeEventListener('keyup', up);
      root.removeEventListener('mousedown', down);
      window.removeEventListener('mouseup', up);
    };
  }

  const GAMES = { hack, thermite, drill };

  window.addEventListener('message', (event) => {
    const msg = event.data || {};
    if (msg.action !== 'minigame' || !GAMES[msg.game]) return;
    GAMES[msg.game](Math.max(1, Math.min(3, Number(msg.difficulty) || 2)), Math.max(5, Number(msg.time) || 30));
  });

  window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && active) active.finish(false, 'You backed off.');
  });

  // Browser preview: index.html?game=hack (or thermite, drill)
  const preview = new URLSearchParams(location.search).get('game');
  if (!resource && preview && GAMES[preview]) setTimeout(() => window.postMessage({ action: 'minigame', game: preview, difficulty: 2, time: 40 }, '*'), 50);
})();
