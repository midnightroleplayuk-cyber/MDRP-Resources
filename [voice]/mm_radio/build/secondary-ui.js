(() => {
  const RESOURCE = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'mm_radio';
  let state = {
    visible: false,
    overlayEnabled: true,
    channel: 0,
    primary: 0,
    talking: false,
    maxChannel: 1000,
    primaryMembers: {},
    secondaryMembers: {},
    channelNames: {},
    rosterCoords: null,
    rosterScale: 100
  };

  // Client-local fallback for roster position. mm_radio also saves the position in
  // radioSettings2 per character, so the position survives logout/resource/server restarts.
  try {
    const saved = JSON.parse(localStorage.getItem('mm_radio_dual_roster_position') || 'null');
    if (saved && Number.isFinite(Number(saved.x)) && Number.isFinite(Number(saved.y))) {
      state.rosterCoords = { x: Number(saved.x), y: Number(saved.y) };
    }
  } catch (_) {}

  const post = (name, data = {}) => fetch(`https://${RESOURCE}/${name}`, {
    method: 'POST', headers: {'Content-Type':'application/json; charset=UTF-8'}, body: JSON.stringify(data)
  }).catch(() => {});

  // Secondary tuning controls. The duplicate frequency HUD was intentionally removed;
  // pma-voice already shows the active secondary frequency in its bottom-right voice HUD.
  const panel = document.createElement('div');
  panel.id = 'mm-secondary-panel';
  panel.innerHTML = `
    <div class="sec-overlay-row">
      <div><span class="sec-overlay-title">RADIO OVERLAY</span><span class="sec-overlay-sub">Show Primary / Secondary member list</span></div>
      <label class="sec-switch"><input class="sec-overlay-toggle" type="checkbox"><span></span></label>
    </div>
    <div class="sec-title"><span>SECONDARY</span><span class="sec-current">OFF</span></div>
    <div class="sec-row">
      <input class="sec-input" type="number" min="1" step="0.01" placeholder="Frequency" />
      <button class="sec-join">JOIN</button>
    </div>
    <button class="sec-leave">DISCONNECT SECONDARY</button>`;
  document.body.appendChild(panel);

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

  const current = panel.querySelector('.sec-current');
  const overlayToggle = panel.querySelector('.sec-overlay-toggle');
  const input = panel.querySelector('.sec-input');
  const join = panel.querySelector('.sec-join');
  const leave = panel.querySelector('.sec-leave');
  const primaryFreq = roster.querySelector('.mm-primary-frequency');
  const secondaryFreq = roster.querySelector('.mm-secondary-frequency');
  const primaryMembers = roster.querySelector('.mm-primary-members');
  const secondaryMembers = roster.querySelector('.mm-secondary-members');
  const secondarySection = roster.querySelector('.mm-secondary-section');

  function safeText(value) { return String(value ?? 'Unknown'); }

  function formatFrequency(channel) {
    const n = Number(channel);
    if (!Number.isFinite(n) || n <= 0) return 'OFF';
    const text = Number.isInteger(n) ? String(n) : n.toFixed(2).replace(/0+$/, '').replace(/\.$/, '');
    return `${text} MHz`;
  }

  function channelNameFor(channel) {
    const n = Number(channel);
    if (!Number.isFinite(n) || n <= 0) return '';
    const names = state.channelNames || {};
    const raw = Number.isInteger(n) ? String(n) : n.toFixed(2).replace(/0+$/, '').replace(/\.$/, '');

    if (names[raw]) return String(names[raw]);

    for (const [key, value] of Object.entries(names)) {
      if (!key.endsWith('.%')) continue;
      const prefix = key.slice(0, -2);
      if (raw.startsWith(prefix + '.')) return String(value);
    }
    return '';
  }

  function rosterChannelText(channel) {
    const frequency = formatFrequency(channel);
    const name = channelNameFor(channel);
    return name ? `${name} | ${frequency}` : frequency;
  }

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

  function applyRosterPosition() {
    if (state.rosterCoords && Number.isFinite(Number(state.rosterCoords.x)) && Number.isFinite(Number(state.rosterCoords.y))) {
      roster.style.right = `${Math.max(0, Number(state.rosterCoords.x))}px`;
      roster.style.top = `${Math.max(0, Number(state.rosterCoords.y))}px`;
    }
    const scale = Math.max(75, Math.min(150, Number(state.rosterScale) || 100));
    roster.style.transformOrigin = 'top right';
    roster.style.transform = `scale(${scale / 100})`;
  }

  function renderRoster() {
    const hasPrimary = Number(state.primary) > 0;
    const hasSecondary = Number(state.channel) > 0;
    roster.classList.toggle('show', !!state.overlayEnabled && (hasPrimary || hasSecondary));
    roster.classList.toggle('editable', !!state.visible && !!state.overlayEnabled);
    // Do not leave an empty SECONDARY block behind after disconnecting. It comes
    // back automatically as soon as a secondary channel is joined again.
    secondarySection.classList.toggle('mm-channel-hidden', !hasSecondary);
    primaryFreq.textContent = hasPrimary ? rosterChannelText(state.primary) : 'OFF';
    secondaryFreq.textContent = hasSecondary ? rosterChannelText(state.channel) : 'OFF';
    primaryFreq.title = hasPrimary ? primaryFreq.textContent : '';
    secondaryFreq.title = hasSecondary ? secondaryFreq.textContent : '';
    renderMembers(primaryMembers, hasPrimary ? state.primaryMembers : {});
    renderMembers(secondaryMembers, hasSecondary ? state.secondaryMembers : {});
    applyRosterPosition();
  }

  function render() {
    const on = Number(state.channel) > 0;
    current.textContent = on ? `${state.channel} MHz` : 'OFF';
    overlayToggle.checked = !!state.overlayEnabled;
    panel.classList.toggle('show', !!state.visible && panel.dataset.docked === '1');
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
  overlayToggle.addEventListener('change', () => {
    state.overlayEnabled = overlayToggle.checked === true;
    post('showPlayerList', state.overlayEnabled);
    renderRoster();
  });

  // Drag the persistent roster only while the handheld radio UI is open. Position is
  // stored through mm_radio's existing player-list position callback.
  let dragging = false, startX = 0, startY = 0, startRight = 0, startTop = 0;
  roster.addEventListener('mousedown', e => {
    if (!state.visible || !state.overlayEnabled || e.button !== 0) return;
    dragging = true;
    startX = e.clientX;
    startY = e.clientY;
    const r = roster.getBoundingClientRect();
    startRight = window.innerWidth - r.right;
    startTop = r.top;
    e.preventDefault();
  });
  window.addEventListener('mousemove', e => {
    if (!dragging) return;
    const bounds = roster.getBoundingClientRect();
    const nextRight = Math.max(0, Math.min(window.innerWidth - bounds.width, startRight - (e.clientX - startX)));
    const nextTop = Math.max(0, Math.min(window.innerHeight - bounds.height, startTop + (e.clientY - startY)));
    state.rosterCoords = { x: nextRight, y: nextTop };
    applyRosterPosition();
  });
  window.addEventListener('mouseup', () => {
    if (!dragging) return;
    dragging = false;
    if (state.rosterCoords) {
      try { localStorage.setItem('mm_radio_dual_roster_position', JSON.stringify(state.rosterCoords)); } catch (_) {}
      post('updatePlayerListPosition', state.rosterCoords);
    }
  });

  function findSettingsBody() {
    const checkboxes = [...document.querySelectorAll('input[type="checkbox"]')];
    for (const box of checkboxes) {
      let node = box.parentElement;
      for (let depth = 0; node && depth < 8; depth++, node = node.parentElement) {
        const cbCount = node.querySelectorAll('input[type="checkbox"]').length;
        const rangeCount = node.querySelectorAll('input[type="range"]').length;
        if (cbCount >= 3 && rangeCount >= 1) {
          return node.parentElement || node;
        }
      }
    }
    return null;
  }

  function wireOverlayScaleSlider() {
    const slider = document.querySelector('input[type="range"][min="75"][max="150"]');
    if (!slider || slider.dataset.mmRosterScaleWired === '1') return;
    slider.dataset.mmRosterScaleWired = '1';
    slider.addEventListener('input', () => {
      const value = Math.max(75, Math.min(150, Number(slider.value) || 100));
      state.rosterScale = value;
      applyRosterPosition();
    });
  }

  function dockPanelIntoSettings() {
    if (!state.visible) {
      panel.dataset.docked = '0';
      render();
      return;
    }
    const settingsBody = findSettingsBody();
    if (!settingsBody) {
      panel.dataset.docked = '0';
      render();
      return;
    }
    if (panel.parentElement !== settingsBody) settingsBody.appendChild(panel);
    panel.dataset.docked = '1';
    wireOverlayScaleSlider();
    render();
  }

  setInterval(dockPanelIntoSettings, 200);

  // Legacy Show/Hide Overlay footer control is removed directly from the compiled radio UI.

  window.addEventListener('message', (e) => {
    const msg = e.data || {};
    const action = msg.action;
    const data = msg.data || {};
    if (action === 'setRadioVisible') {
      state.visible = true;
      state.primary = Number(data.channel) || 0;
      state.channel = Number(data.secondaryChannel) || 0;
      state.maxChannel = Number(data.maxChannel) || state.maxChannel;
      if (data.channelName && typeof data.channelName === 'object') state.channelNames = data.channelName;
      if (data.userData?.playerlist) {
        state.overlayEnabled = data.userData.playerlist.show === true;
        if (data.userData.playerlist.coords) state.rosterCoords = data.userData.playerlist.coords;
        state.rosterScale = Math.max(75, Math.min(150, Number(data.userData.overlaySizeMultiplier) || 100));
      }
      render(); setTimeout(dockPanelIntoSettings, 50);
    } else if (action === 'setRadioHide') {
      state.visible = false; render();
    } else if (action === 'updateRadio') {
      state.primary = Number(data.channel) || 0;
      if (data.secondaryChannel !== undefined) state.channel = Number(data.secondaryChannel) || 0;
      if (data.channelName && typeof data.channelName === 'object') state.channelNames = data.channelName;
      if (data.userData?.playerlist) {
        state.overlayEnabled = data.userData.playerlist.show === true;
        if (data.userData.playerlist.coords) state.rosterCoords = data.userData.playerlist.coords;
        state.rosterScale = Math.max(75, Math.min(150, Number(data.userData.overlaySizeMultiplier) || 100));
      }
      render();
    } else if (action === 'overlayVisibilityChanged') {
      state.overlayEnabled = data.show === true;
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
