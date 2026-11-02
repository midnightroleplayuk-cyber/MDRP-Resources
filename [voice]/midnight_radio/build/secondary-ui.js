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
    visiblePresetChannels: [],
    rosterCoords: null,
    rosterScale: 100,
    opacity: 41, volume: 30, displayName: ''
  };

  // Overlay placement is character-specific and restored by Lua KVP. Do not
  // reuse browser localStorage across characters or resource renames.
  let rosterPositionReady = false;
  let characterReady = false;
  let sessionJoinedPrimary = false;
  let sessionJoinedSecondary = false;

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
      const job = safeText(member?.job).toLowerCase();
      if (job === 'police' || job === 'ambulance' || job === 'fire') dot.classList.add(`job-${job}`);
      else dot.classList.add('job-default');
      const name = document.createElement('span');
      name.className = 'mm-member-name';
      name.textContent = safeText(member?.name);
      row.append(dot, name);
      container.appendChild(row);
    }
  }

  function applyRosterPosition() {
    const scale = Math.max(75, Math.min(150, Number(state.rosterScale) || 100));
    const factor = scale / 100;
    // Keep the entire scaled overlay visible at the current resolution.
    const maxRight = Math.max(0, window.innerWidth - roster.offsetWidth * factor);
    const maxTop = Math.max(0, window.innerHeight - roster.offsetHeight * factor);
    const coords = state.rosterCoords || { x: 15, y: 40 };
    const x = Math.max(0, Math.min(maxRight, Number(coords.x) || 0));
    const y = Math.max(0, Math.min(maxTop, Number(coords.y) || 0));
    roster.style.right = `${x}px`;
    roster.style.top = `${y}px`;
    roster.style.transformOrigin = 'top right';
    roster.style.transform = `scale(${factor})`;
    roster.style.setProperty('--mm-roster-style-opacity', String(Math.max(.2, Math.min(1, state.opacity / 100))));
    roster.style.opacity = '1';
  }

  function restoreRosterPreferences(data) {
    if (!data?.userData?.playerlist) return;
    const prefs = data.userData;
    state.overlayEnabled = prefs.playerlist.show === true;
    const c = prefs.playerlist.coords;
    state.rosterCoords = c && Number.isFinite(Number(c.x)) && Number.isFinite(Number(c.y))
      ? {x:Number(c.x), y:Number(c.y)} : {x:15,y:40};
    state.rosterScale = Math.max(75, Math.min(150, Number(prefs.overlaySizeMultiplier) || 100));
    rosterPositionReady = true;
  }

  function renderRoster() {
    const hasPrimary = sessionJoinedPrimary && Number(state.primary) > 0;
    const hasSecondary = sessionJoinedSecondary && Number(state.channel) > 0;
    roster.classList.toggle('show', characterReady && rosterPositionReady && !!state.overlayEnabled && (hasPrimary || hasSecondary));
    roster.classList.toggle('editable', !!state.visible && !!state.overlayEnabled && (hasPrimary || hasSecondary));
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
    panel.classList.remove('show'); // Legacy panel must never appear in the three-tab interface.
    leave.disabled = !on;
    renderRoster();
    renderDashboard();
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

  // Legacy settings docking disabled in favour of the unified three-tab dashboard.



  const dashboard = document.createElement('div');
  dashboard.id = 'mm-radio-dashboard';
  dashboard.innerHTML = `
    <header class="mm-dash-header"><div><strong>MIDNIGHT RADIO</strong><small>SECURE ENCRYPTED RADIO</small></div></header>
    <nav class="mm-dash-tabs"><button data-tab="primary" class="active">PRIMARY</button><button data-tab="secondary">SECONDARY</button><button data-tab="settings" aria-label="Settings" title="Settings"><svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06-1.9 1.9-.06-.06A1.65 1.65 0 0 0 16 18.4a1.65 1.65 0 0 0-1 1.5V20h-6v-.1a1.65 1.65 0 0 0-1-1.5 1.65 1.65 0 0 0-1.82.33l-.06.06-1.9-1.9.06-.06A1.65 1.65 0 0 0 4.6 15a1.65 1.65 0 0 0-1.5-1H3v-4h.1a1.65 1.65 0 0 0 1.5-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06 1.9-1.9.06.06A1.65 1.65 0 0 0 8 5.6a1.65 1.65 0 0 0 1-1.5V4h6v.1a1.65 1.65 0 0 0 1 1.5 1.65 1.65 0 0 0 1.82-.33l.06-.06 1.9 1.9-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.5 1h.1v4h-.1a1.65 1.65 0 0 0-1.5 1z"/></svg></button></nav>
    <section data-page="primary" class="mm-dash-page active"><div class="mm-dash-caption">PRIMARY FREQUENCY <b data-current="primary">OFF</b></div><div class="mm-dash-entry"><input data-frequency="primary" type="number" min="1" step="0.01" placeholder="Enter frequency"><button data-join="primary">JOIN</button></div><button class="mm-dash-disconnect" data-leave="primary">DISCONNECT PRIMARY</button><button class="mm-channel-open" data-open-channels="primary">JOB CHANNELS <span>VIEW LIST ›</span></button><div class="mm-channel-list" data-channel-list="primary" hidden><button class="mm-channel-back" data-back-channels="primary">‹ BACK</button><div class="mm-dash-presets" data-presets="primary"></div></div></section>
    <section data-page="secondary" class="mm-dash-page"><div class="mm-dash-caption">SECONDARY FREQUENCY <b data-current="secondary">OFF</b></div><div class="mm-dash-entry"><input data-frequency="secondary" type="number" min="1" step="0.01" placeholder="Enter frequency"><button data-join="secondary">JOIN</button></div><button class="mm-dash-disconnect" data-leave="secondary">DISCONNECT SECONDARY</button><button class="mm-channel-open" data-open-channels="secondary">JOB CHANNELS <span>VIEW LIST ›</span></button><div class="mm-channel-list" data-channel-list="secondary" hidden><button class="mm-channel-back" data-back-channels="secondary">‹ BACK</button><div class="mm-dash-presets" data-presets="secondary"></div></div></section>
    <section data-page="settings" class="mm-dash-page"><label>RADIO DISPLAY NAME</label><div class="mm-dash-entry"><input data-name maxlength="48" placeholder="Your radio name"><button data-save-name>SAVE</button></div><label>RADIO VOLUME <output data-volume-label>30%</output></label><input data-volume type="range" min="0" max="100"><label class="mm-dash-toggle">SHOW RADIO LIST <input data-overlay type="checkbox"></label><label>RADIO LIST OPACITY <output data-opacity-label>41%</output></label><input data-opacity type="range" min="20" max="100"><label class="mm-dash-toggle">RADIO TALK BEEPS <input data-clicks type="checkbox" checked></label><p class="mm-dash-hint">Drag the radio list while this menu is open to move the overlay. Settings save automatically.</p></section>
    <div class="mm-dash-feedback" aria-live="polite"></div>`;
  document.body.appendChild(dashboard);
  let activeTab = 'primary';
  // Fixed handset: always anchored to the bottom-right. Ignore legacy saved positions.
  for (const key of ['midnight_radio_position', 'midnight_radio_position_v63']) localStorage.removeItem(key);
  dashboard.classList.remove('radio-position-custom', 'radio-movable', 'radio-closing-in-place');
  dashboard.style.removeProperty('--radio-x');
  dashboard.style.removeProperty('--radio-y');
  dashboard.style.removeProperty('left');
  dashboard.style.removeProperty('top');
  dashboard.style.removeProperty('right');
  dashboard.style.removeProperty('bottom');
  const get = selector => dashboard.querySelector(selector);
  const feedback = message => { get('.mm-dash-feedback').textContent = message; };
  function syncPreferences(data) {
    if (!data) return;
    if (data.volume !== undefined) state.volume = Number(data.volume) || 0;
    if (data.userData) {
      state.displayName = data.userData.name || '';
      state.enableClicks = data.userData.enableClicks !== false;
      state.opacity = Number(data.userData.overlayOpacity ?? 41);
      if (data.userData.volume !== undefined) state.volume = Number(data.userData.volume) || 0;
    }
  }
  let customCloseTimer = null;
  function renderDashboard() {
    if (customCloseTimer !== null) {
      clearTimeout(customCloseTimer);
      customCloseTimer = null;
    }
    const customPlacement = dashboard.classList.contains('radio-position-custom');
    if (state.visible) {
      dashboard.classList.remove('radio-closing-in-place');
      dashboard.classList.add('show');
    } else if (customPlacement && dashboard.classList.contains('show')) {
      // At a user-chosen position, fade in place instead of travelling
      // towards the default bottom-right anchor.
      dashboard.classList.add('radio-closing-in-place');
      customCloseTimer = setTimeout(() => {
        dashboard.classList.remove('show', 'radio-closing-in-place');
        customCloseTimer = null;
      }, 190);
    } else {
      // Original close behaviour is unchanged at the default position.
      dashboard.classList.remove('show', 'radio-closing-in-place');
    }
    dashboard.querySelectorAll('[data-page]').forEach(el => el.classList.toggle('active', el.dataset.page === activeTab));
    dashboard.querySelectorAll('[data-tab]').forEach(el => el.classList.toggle('active', el.dataset.tab === activeTab));
    document.body.classList.toggle('mm-dash-open', state.visible);
    get('[data-current="primary"]').textContent = rosterChannelText(state.primary);
    get('[data-current="secondary"]').textContent = rosterChannelText(state.channel);
    get('[data-leave="primary"]').disabled = !state.primary;
    get('[data-leave="secondary"]').disabled = !state.channel;
    get('[data-overlay]').checked = state.overlayEnabled;
    get('[data-clicks]').checked = state.enableClicks !== false;
    get('[data-volume]').value = state.volume;
    get('[data-volume-label]').textContent = state.volume + '%';
    get('[data-opacity]').value = state.opacity;
    get('[data-opacity-label]').textContent = state.opacity + '%';
    if (document.activeElement !== get('[data-name]')) get('[data-name]').value = state.displayName;
    for (const side of ['primary','secondary']) {
      const target = get(`[data-presets="${side}"]`);
      target.replaceChildren();
      const entries = Object.entries(state.channelNames).filter(([key]) => /^\d+(?:\.\d+)?$/.test(key) && state.visiblePresetChannels.includes(Number(key))).sort((a,b) => Number(a[0])-Number(b[0]));
      for (const [channel, label] of entries) {
        const btn = document.createElement('button');
        btn.textContent = `${label} · ${channel}`;
        btn.disabled = Number(channel) === (side === 'primary' ? state.channel : state.primary);
        btn.addEventListener('click', () => {tune(side, Number(channel)); target.closest('[data-channel-list]').hidden = true; get(`[data-open-channels="${side}"]`).hidden = false;});
        target.appendChild(btn);
      }
      if (!entries.length) target.textContent = 'No preset channels configured';
    }
  }
  function tune(side, channel) {
    const other = side === 'primary' ? state.channel : state.primary;
    if (!Number.isFinite(channel) || channel < 1 || channel > state.maxChannel) return feedback('Invalid frequency.');
    if (Math.abs(channel - other) < 0.0001) return feedback('Already connected on the other radio.');
    feedback('');
    post(side === 'primary' ? 'join' : 'joinSecondary', side === 'primary' ? channel : {channel});
  }
  dashboard.addEventListener('click', e => {
    const btn = e.target.closest('button'); if (!btn) return;
    if (btn.dataset.tab) {
      activeTab = btn.dataset.tab; dashboard.querySelectorAll('[data-channel-list]').forEach(el => el.hidden = true); dashboard.querySelectorAll('[data-open-channels]').forEach(el => el.hidden = false);
      dashboard.querySelectorAll('[data-tab]').forEach(el => el.classList.toggle('active', el.dataset.tab === activeTab));
      dashboard.querySelectorAll('[data-page]').forEach(el => el.classList.toggle('active', el.dataset.page === activeTab));
    }
    if (btn.dataset.openChannels) {get(`[data-channel-list="${btn.dataset.openChannels}"]`).hidden = false; btn.hidden = true;}
    if (btn.dataset.backChannels) {get(`[data-channel-list="${btn.dataset.backChannels}"]`).hidden = true; get(`[data-open-channels="${btn.dataset.backChannels}"]`).hidden = false;}
    if (btn.dataset.join) tune(btn.dataset.join, Number(get(`[data-frequency="${btn.dataset.join}"]`).value));
    if (btn.dataset.leave) post(btn.dataset.leave === 'primary' ? 'leave' : 'leaveSecondary');
    if (btn.dataset.action === 'close') post('hideUI');
    if (btn.hasAttribute('data-save-name')) saveDisplayName();
  });
  function saveDisplayName() {
    const name = get('[data-name]').value.trim();
    if (!name) return;
    state.displayName = name;
    post('saveData', {name});
    feedback('Name saved.');
  }
  get('[data-name]').addEventListener('keydown', e => {
    if (e.key !== 'Enter' || e.isComposing || e.repeat) return;
    e.preventDefault();
    saveDisplayName();
  });
  dashboard.querySelectorAll('[data-frequency]').forEach(el => el.addEventListener('keydown', e => {if(e.key === 'Enter') tune(el.dataset.frequency, Number(el.value));}));
  get('[data-clicks]').addEventListener('change', e => {state.enableClicks = e.target.checked; post('enableClicks', e.target.checked);});
  get('[data-overlay]').addEventListener('change', e => {state.overlayEnabled = e.target.checked; post('showPlayerList', state.overlayEnabled); renderRoster();});
  get('[data-volume]').addEventListener('input', e => {state.volume = Number(e.target.value); get('[data-volume-label]').textContent = state.volume + '%'; post('volumeChange', state.volume);});
  get('[data-opacity]').addEventListener('input', e => {state.opacity = Number(e.target.value); get('[data-opacity-label]').textContent = state.opacity + '%'; applyRosterPosition(); post('setOverlayOpacity', state.opacity);});

  // Legacy Show/Hide Overlay footer control is removed directly from the compiled radio UI.

  window.addEventListener('message', (e) => {
    const msg = e.data || {};
    const action = msg.action;
    const data = msg.data || {};
    if (action === 'setRadioVisible') {
      characterReady = true;
      state.visible = true;
      state.primary = Number(data.channel) || 0;
      state.channel = Number(data.secondaryChannel) || 0;
      // Opening the handset never reveals the list by itself. If no channels
      // are actually connected, discard any stale membership from earlier UI updates.
      if (state.primary <= 0) { sessionJoinedPrimary = false; state.primaryMembers = {}; }
      if (state.channel <= 0) { sessionJoinedSecondary = false; state.secondaryMembers = {}; }
      // Session membership is only accepted from live channel updates.
      state.maxChannel = Number(data.maxChannel) || state.maxChannel;
      if (data.channelName && typeof data.channelName === 'object') state.channelNames = data.channelName;
      state.visiblePresetChannels = Array.isArray(data.visiblePresetChannels) ? data.visiblePresetChannels.map(Number) : [];
      syncPreferences(data);
      // Only restore saved coordinates at session initialization, not after name/settings updates.
      if (!rosterPositionReady) restoreRosterPreferences(data);
      panel.dataset.docked = '0';
      render();
    } else if (action === 'setRadioHide') {
      state.visible = false; render();
    } else if (action === 'radioSessionReset') {
      characterReady = false; rosterPositionReady = false;
      state.visible = false; state.primary = 0; state.channel = 0;
      sessionJoinedPrimary = false; sessionJoinedSecondary = false;
      state.primaryMembers = {}; state.secondaryMembers = {};
      state.rosterCoords = null; roster.classList.remove('show', 'editable');
      render();
    } else if (action === 'updateRadio') {
      characterReady = true;
      state.primary = Number(data.channel) || 0;
      if (data.secondaryChannel !== undefined) state.channel = Number(data.secondaryChannel) || 0;
      if (data.channelName && typeof data.channelName === 'object') state.channelNames = data.channelName;
      state.visiblePresetChannels = Array.isArray(data.visiblePresetChannels) ? data.visiblePresetChannels.map(Number) : [];
      syncPreferences(data);
      // Only restore saved coordinates at session initialization, not after name/settings updates.
      if (!rosterPositionReady) restoreRosterPreferences(data);
      render();
    } else if (action === 'overlayVisibilityChanged') {
      state.overlayEnabled = data.show === true;
      render();
    } else if (action === 'secondaryChannelChanged') {
      state.channel = Number(data.channel) || 0;
      sessionJoinedSecondary = state.channel > 0;
      state.talking = !!data.talking;
      input.value = state.channel > 0 ? state.channel : '';
      if (!state.channel) state.secondaryMembers = {};
      render();
    } else if (action === 'secondaryTalkingChanged') {
      state.talking = !!data.talking;
      if (data.channel !== undefined) state.channel = Number(data.channel) || state.channel;
      render();
    } else if (action === 'dualRadioListUpdate') {
      if (!characterReady) return;
      // A roster packet must not resurrect a disconnected radio when the menu
      // has just opened; only the live connected frequencies count.
      state.primary = Number(data.primaryChannel) || 0;
      state.channel = Number(data.secondaryChannel) || 0;
      // Only display sections for live channels, not restored preferences.
      sessionJoinedPrimary = state.primary > 0;
      sessionJoinedSecondary = state.channel > 0;
      state.primaryMembers = data.primary || {};
      state.secondaryMembers = data.secondary || {};
      render();
    }
  });

  window.addEventListener('resize', applyRosterPosition);
  render();
})();
