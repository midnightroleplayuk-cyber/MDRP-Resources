(() => {
  const RESOURCE = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'mm_radio';
  let state = {
    visible: false, channel: 0, primary: 0, talking: false, maxChannel: 1000,
    primaryMembers: {}, secondaryMembers: {}
  };

  const post = (name, data = {}) => fetch(`https://${RESOURCE}/${name}`, {
    method: 'POST', headers: {'Content-Type':'application/json; charset=UTF-8'}, body: JSON.stringify(data)
  }).catch(() => {});

  const hud = document.createElement('div');
  hud.id = 'mm-secondary-hud';
  hud.innerHTML = '<span class="tag">SEC</span><span class="freq">OFF</span>';
  document.body.appendChild(hud);

  const panel = document.createElement('div');
  panel.id = 'mm-secondary-panel';
  panel.innerHTML = `
    <div class="sec-title"><span>SECONDARY</span><span class="sec-current">OFF</span></div>
    <div class="sec-row">
      <input class="sec-input" type="number" min="1" step="0.01" placeholder="Frequency" />
      <button class="sec-join">JOIN</button>
    </div>
    <button class="sec-leave">DISCONNECT SECONDARY</button>`;
  document.body.appendChild(panel);

  // Persistent dual-channel roster. This intentionally does not depend on anyone talking.
  const roster = document.createElement('div');
  roster.id = 'mm-dual-radio-roster';
  roster.innerHTML = `
    <section class="mm-roster-section mm-primary-section">
      <div class="mm-roster-heading"><span>PRIMARY</span><span class="mm-primary-frequency">OFF</span></div>
      <div class="mm-primary-members mm-members"></div>
    </section>
    <section class="mm-roster-section mm-secondary-section">
      <div class="mm-roster-heading"><span>SECONDARY</span><span class="mm-secondary-frequency">OFF</span></div>
      <div class="mm-secondary-members mm-members"></div>
    </section>`;
  document.body.appendChild(roster);

  const freq = hud.querySelector('.freq');
  const current = panel.querySelector('.sec-current');
  const input = panel.querySelector('.sec-input');
  const join = panel.querySelector('.sec-join');
  const leave = panel.querySelector('.sec-leave');
  const primaryFreq = roster.querySelector('.mm-primary-frequency');
  const secondaryFreq = roster.querySelector('.mm-secondary-frequency');
  const primaryMembers = roster.querySelector('.mm-primary-members');
  const secondaryMembers = roster.querySelector('.mm-secondary-members');

  function safeText(value) { return String(value ?? 'Unknown'); }

  function renderMembers(container, members) {
    container.replaceChildren();
    const entries = Object.entries(members || {}).sort((a, b) => safeText(a[1]?.name).localeCompare(safeText(b[1]?.name)));
    if (!entries.length) {
      const empty = document.createElement('div');
      empty.className = 'mm-member mm-empty';
      empty.textContent = 'No members';
      container.appendChild(empty);
      return;
    }
    for (const [, member] of entries) {
      const row = document.createElement('div');
      row.className = 'mm-member' + (member?.isTalking ? ' talking' : '');
      const dot = document.createElement('span');
      dot.className = 'mm-talk-dot';
      const name = document.createElement('span');
      name.className = 'mm-member-name';
      name.textContent = safeText(member?.name);
      row.append(dot, name);
      container.appendChild(row);
    }
  }

  function renderRoster() {
    const hasPrimary = Number(state.primary) > 0;
    const hasSecondary = Number(state.channel) > 0;
    // Stay visible whenever the player is tuned to either channel; never gate it on PTT/talking.
    roster.classList.toggle('show', hasPrimary || hasSecondary);
    primaryFreq.textContent = hasPrimary ? `${state.primary} MHz` : 'OFF';
    secondaryFreq.textContent = hasSecondary ? `${state.channel} MHz` : 'OFF';
    renderMembers(primaryMembers, hasPrimary ? state.primaryMembers : {});
    renderMembers(secondaryMembers, hasSecondary ? state.secondaryMembers : {});
  }

  function render() {
    const on = Number(state.channel) > 0;
    freq.textContent = on ? `${state.channel} MHz` : 'OFF';
    current.textContent = on ? `${state.channel} MHz` : 'OFF';
    hud.classList.toggle('active', on);
    hud.classList.toggle('talking', !!state.talking);
    panel.classList.toggle('show', !!state.visible);
    leave.disabled = !on;
    renderRoster();
  }

  function joinSecondary() {
    const value = Number(input.value);
    if (!Number.isFinite(value) || value < 1 || value > state.maxChannel) return;
    post('joinSecondary', { channel: value });
    input.blur();
  }

  join.addEventListener('click', joinSecondary);
  input.addEventListener('keydown', e => { if (e.key === 'Enter') joinSecondary(); });
  leave.addEventListener('click', () => post('leaveSecondary'));

  function positionPanel() {
    if (!state.visible) return;
    const bg = [...document.querySelectorAll('img')].find(i => i.alt === 'bg');
    const shell = bg && bg.parentElement;
    if (!shell) return;
    const r = shell.getBoundingClientRect();
    const scale = Math.max(0.5, Math.min(2.5, r.width / 326));
    // Keep the secondary controls outside the handheld radio so they never
    // cover the built-in Disconnect / Radio / Members / Settings controls.
    const panelWidth = 176;
    const scaledWidth = panelWidth * scale;
    let left = r.right + (10 * scale);
    // If the radio is already tight against the right edge, dock the panel
    // to the left of the radio instead of covering it.
    if (left + scaledWidth > window.innerWidth - 8) {
      left = r.left - scaledWidth - (10 * scale);
    }
    panel.style.left = `${Math.max(8, left)}px`;
    panel.style.top = `${r.top + 330 * scale}px`;
    panel.style.width = `${panelWidth}px`;
    panel.style.transformOrigin = 'top left';
    panel.style.transform = `scale(${scale})`;
  }
  setInterval(positionPanel, 100);

  window.addEventListener('message', (e) => {
    const msg = e.data || {};
    const action = msg.action;
    const data = msg.data || {};
    if (action === 'setRadioVisible') {
      state.visible = true;
      state.primary = Number(data.channel) || 0;
      state.channel = Number(data.secondaryChannel) || 0;
      state.maxChannel = Number(data.maxChannel) || state.maxChannel;
      render(); setTimeout(positionPanel, 50);
    } else if (action === 'setRadioHide') {
      state.visible = false; render();
    } else if (action === 'updateRadio') {
      state.primary = Number(data.channel) || 0;
      if (data.secondaryChannel !== undefined) state.channel = Number(data.secondaryChannel) || 0;
      render();
    } else if (action === 'secondaryChannelChanged') {
      state.channel = Number(data.channel) || 0;
      state.talking = !!data.talking;
      input.value = state.channel > 0 ? state.channel : '';
      if (!state.channel) state.secondaryMembers = {};
      render();
    } else if (action === 'secondaryTalkingChanged') {
      state.talking = !!data.talking;
      if (data.channel !== undefined) state.channel = Number(data.channel) || state.channel;
      render();
    } else if (action === 'dualRadioListUpdate') {
      state.primary = Number(data.primaryChannel) || 0;
      state.channel = Number(data.secondaryChannel) || 0;
      state.primaryMembers = data.primary || {};
      state.secondaryMembers = data.secondary || {};
      render();
    }
  });

  render();
})();
