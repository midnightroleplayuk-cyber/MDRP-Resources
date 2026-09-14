// Officer Menu Logic

window.currentRadioCodes = [];
window.allAnimations = {};
window.fakePlayers = [];
window.playerName = "Officer";
window.rankLabel = "Officer";
window.myCitizenId = null;
window.officerMenuTabs = {
    interaction: true,
    radio: true,
    frequency: true,
    objects: true,
    vehicles: true,
    poses: true
};

window.currentFrequency = null;
window.frequencySpeaker = false;
window.syncedRadioChannels = {}; // Stores real data from server
window.fakePlayerFreqs = {}; // Local state for fake player overrides { [cid]: freqId }
window.frequencyMiniHudVisible = false;
window.frequencyUnitName = "";
window.frequencyDefinitions = null;
let frequencyUnitNameTimer = null;

// --- Custom Drag System ---
window.isDragging = false;
window.dragGhost = null;
window.draggedCid = null;
window.draggedFromFreq = null;
window.dragOffsetX = 0;
window.dragOffsetY = 0;
window.freqRects = [];

function normalizeOfficerTabs(tabs) {
    const defaults = {
        interaction: true,
        radio: true,
        frequency: true,
        objects: true,
        vehicles: true,
        poses: true
    };

    if (!tabs || typeof tabs !== 'object') return defaults;
    return {
        interaction: tabs.interaction !== false,
        radio: tabs.radio !== false,
        frequency: tabs.frequency !== false,
        objects: tabs.objects !== false,
        vehicles: tabs.vehicles !== false,
        monitoring: tabs.monitoring !== false,
        poses: tabs.poses !== false
    };
}

function applyOfficerTabVisibility() {
    document.querySelectorAll('.officer-menu-tabs .tab').forEach((tab) => {
        const category = tab.getAttribute('data-cat');
        const isEnabled = window.officerMenuTabs[category] !== false;
        tab.style.display = isEnabled ? '' : 'none';
        if (!isEnabled) tab.classList.remove('active');
    });
}

function openFirstEnabledOfficerTab() {
    const tabs = Array.from(document.querySelectorAll('.officer-menu-tabs .tab'));
    const firstEnabled = tabs.find((tab) => {
        const category = tab.getAttribute('data-cat');
        return window.officerMenuTabs[category] !== false;
    });

    if (firstEnabled) {
        firstEnabled.click();
    }
}

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'openOfficerMenu') {
        const container = document.getElementById('officer-menu-container');
        if (container) {
            container.classList.add('visible');
            container.style.setProperty('display', 'flex', 'important');
            
            if (data.radioCodes) window.currentRadioCodes = data.radioCodes;
            if (data.animations) window.allAnimations = data.animations;
            window.fakePlayers = data.fakePlayers || [];
            if (data.playerName) window.playerName = data.playerName;
            if (data.rankLabel) window.rankLabel = data.rankLabel;
            if (data.myCitizenId) window.myCitizenId = data.myCitizenId;
            if (Array.isArray(data.frequencyChannels)) {
                window.frequencyDefinitions = normalizeFrequencyDefinitions(data.frequencyChannels);
            }
            if (!window.frequencyUnitName && data.playerName) {
                window.frequencyUnitName = data.playerName;
                window.syncFrequencyUnitNameInput();
            }
            window.frequencySpeaker = data.frequencySpeaker === true;
            window.officerMenuTabs = normalizeOfficerTabs(data.tabs);
            applyOfficerTabVisibility();

            // Reset to first enabled tab
            openFirstEnabledOfficerTab();
        }
    } else if (data.action === 'closeOfficerMenu') {
        const container = document.getElementById('officer-menu-container');
        if (container) {
            container.classList.remove('visible');
            container.style.setProperty('display', 'none', 'important');
        }
    } else if (data.action === 'syncRadioChannels') {
        window.syncedRadioChannels = data.channels || {};
        window.renderFrequencyMiniHudPreview();
        window.renderFrequencyMiniHud();
        const activeTab = document.querySelector('.officer-menu-tabs .tab.active');
        if (activeTab && activeTab.getAttribute('data-cat') === 'frequency') {
            window.renderFrequencyList();
        }
    } else if (data.action === 'forceFrequency') {
        window.currentFrequency = Number(data.frequency) || null;
        window.renderFrequencyMiniHudPreview();
        window.renderFrequencyMiniHud();
        const activeTab = document.querySelector('.officer-menu-tabs .tab.active');
        if (activeTab && activeTab.getAttribute('data-cat') === 'frequency') {
            window.renderFrequencyList();
        }
    } else if (data.action === 'setFrequencySpeakerState') {
        window.frequencySpeaker = data.enabled === true;
        window.renderFrequencySpeaker();
    } else if (data.action === 'toggleFrequencyMiniHud') {
        window.toggleFrequencyMiniHud(data.show === true, true);
    }
});

window.closeAlprSpeedModal = function() {
    document.getElementById('alpr-speed-modal').classList.add('hidden');
    document.getElementById('alpr-speed-modal').style.display = 'none';
    
    fetch(`https://${GetParentResourceName()}/closeOfficerMenu`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};

function sendAlprSpeedSetting(speed) {
    fetch(`https://${GetParentResourceName()}/officerAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'alpr_set_speed', speed: speed })
    });
}

window.getCurrentAlprSpeedLimit = function() {
    const sources = [
        document.getElementById('alpr-settings-speed-input'),
        document.getElementById('alpr-lock-speed'),
        document.getElementById('alpr-speed-input-field')
    ];

    for (const el of sources) {
        if (!el) continue;
        const value = parseInt(el.value, 10);
        if (!isNaN(value) && value > 0) {
            return value;
        }
    }

    const limitDisplay = document.getElementById('alpr-limit-display');
    if (limitDisplay) {
        const value = parseInt(limitDisplay.innerText, 10);
        if (!isNaN(value) && value > 0) {
            return value;
        }
    }

    return 80;
};

window.syncAlprSettingsSpeedInput = function() {
    const speedInput = document.getElementById('alpr-settings-speed-input');
    if (!speedInput) return;
    speedInput.value = window.getCurrentAlprSpeedLimit();
};

window.applyAlprSettingsSpeed = function() {
    const speedInput = document.getElementById('alpr-settings-speed-input');
    if (!speedInput) return false;

    const speed = parseInt(speedInput.value, 10);
    if (isNaN(speed) || speed <= 0) return false;

    speedInput.value = speed;
    sendAlprSpeedSetting(speed);
    return true;
};

window.confirmAlprSpeed = function() {
    const speed = document.getElementById('alpr-speed-input-field').value;
    if (speed && speed > 0) {
        sendAlprSpeedSetting(speed);
        window.closeAlprSpeedModal();
    }
};

window.closeOfficerMenu = function() {
    const container = document.getElementById('officer-menu-container');
    if (container) {
        container.classList.remove('visible');
        container.style.setProperty('display', 'none', 'important');
        fetch(`https://${GetParentResourceName()}/closeOfficerMenu`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }
};

window.officerAction = function(action) {
    if (action === 'open_alpr') {
        const hexView = document.getElementById('hexagon-view');
        const alprView = document.getElementById('alpr-settings-view');
        if (hexView && alprView) {
            hexView.classList.add('hidden');
            alprView.classList.remove('hidden');
            window.syncAlprSettingsSpeedInput();
            
            const titleEl = document.getElementById('officer-menu-title');
            if (titleEl) titleEl.innerText = window.T('alpr_settings');
        }
        return;
    }
    if (action === 'back_to_vehicles') {
        window.updateHexGrid('vehicles');
        return;
    }
    if (action === 'alpr_set_speed' || action === 'alpr_apply_speed') {
        if (window.applyAlprSettingsSpeed()) {
            return;
        }

        const container = document.getElementById('officer-menu-container');
        if (container) {
            container.classList.remove('visible');
            container.style.setProperty('display', 'none', 'important');
        }
        
        document.getElementById('alpr-speed-modal').classList.remove('hidden');
        document.getElementById('alpr-speed-modal').style.display = 'flex';
        document.getElementById('alpr-speed-input-field').focus();
        return;
    }

    fetch(`https://${GetParentResourceName()}/officerAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: action })
    });
};

// Handle Tab Switching
document.querySelectorAll('.officer-menu-tabs .tab').forEach(tab => {
    tab.addEventListener('click', () => {
        document.querySelectorAll('.officer-menu-tabs .tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        
        const category = tab.getAttribute('data-cat');
        if (window.officerMenuTabs[category] === false) return;
        const titleEl = document.getElementById('officer-menu-title');
        if (titleEl) titleEl.innerText = window.T('tab_' + category);

        const hexView = document.getElementById('hexagon-view');
        const radioView = document.getElementById('radio-view');
        const freqView = document.getElementById('frequency-view');
        const posesView = document.getElementById('poses-view');
        const alprSettingsView = document.getElementById('alpr-settings-view');
        
        if (hexView) hexView.classList.add('hidden');
        if (radioView) radioView.classList.add('hidden');
        if (freqView) freqView.classList.add('hidden');
        if (posesView) posesView.classList.add('hidden');
        if (alprSettingsView) alprSettingsView.classList.add('hidden');

        if (category === 'radio') {
            radioView.classList.remove('hidden');
            window.renderRadioGrid();
        } else if (category === 'frequency') {
            freqView.classList.remove('hidden');
            window.renderFrequencyList();
        } else if (category === 'poses') {
            posesView.classList.remove('hidden');
            window.renderOfficerPosesGrid();
        } else {
            hexView.classList.remove('hidden');
            window.updateHexGrid(category);
        }
    });
});

window.joinFrequency = function(id) {
    if (window.currentFrequency === id) {
        window.currentFrequency = null;
        fetch(`https://${GetParentResourceName()}/leaveFrequency`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ frequency: id })
        });
    } else {
        window.currentFrequency = id;
        fetch(`https://${GetParentResourceName()}/joinFrequency`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ frequency: id })
        });
    }
    window.renderFrequencyList();
    window.renderFrequencyMiniHudPreview();
    window.renderFrequencyMiniHud();
};

window.switchFrequencyByOffset = function(offset) {
    if (!window.currentFrequency) return;

    const frequencyIds = window.getFrequencyDefinitions()
        .flatMap((category) => category.frequencies.map((frequency) => frequency.id));
    if (frequencyIds.length === 0) return;

    const currentIndex = frequencyIds.indexOf(Number(window.currentFrequency));
    let nextIndex = currentIndex >= 0 ? currentIndex + offset : 0;
    if (nextIndex >= frequencyIds.length) nextIndex = 0;
    if (nextIndex < 0) nextIndex = frequencyIds.length - 1;

    const nextFrequency = frequencyIds[nextIndex];
    if (nextFrequency && nextFrequency !== window.currentFrequency) {
        window.joinFrequency(nextFrequency);
    }
};

document.addEventListener('keydown', (event) => {
    if (event.key !== 'ArrowUp' && event.key !== 'ArrowDown') return;

    const activeElement = document.activeElement;
    if (activeElement && ['INPUT', 'TEXTAREA', 'SELECT'].includes(activeElement.tagName)) return;

    const container = document.getElementById('officer-menu-container');
    const activeTab = document.querySelector('.officer-menu-tabs .tab.active');
    const isFrequencyOpen = container
        && container.classList.contains('visible')
        && activeTab
        && activeTab.getAttribute('data-cat') === 'frequency';
    if (!isFrequencyOpen || !window.currentFrequency) return;

    event.preventDefault();
    window.switchFrequencyByOffset(event.key === 'ArrowUp' ? 1 : -1);
});

window.toggleFreqItem = function(id) {
    const item = document.getElementById(`freq-${id}`);
    if (item) item.classList.toggle('expanded');
};

window.renderFrequencySpeaker = function() {
    const button = document.getElementById('frequency-speaker-toggle');
    const status = document.getElementById('frequency-speaker-status');
    if (!button || !status) return;

    button.classList.toggle('active', window.frequencySpeaker === true);
    button.innerHTML = window.frequencySpeaker
        ? '<i class="fas fa-volume-high"></i><span>ON</span>'
        : '<i class="fas fa-volume-xmark"></i><span>OFF</span>';
    status.textContent = window.frequencySpeaker
        ? 'Nearby people can hear radio traffic'
        : 'Private earpiece';
};

window.toggleFrequencySpeaker = function() {
    window.frequencySpeaker = !window.frequencySpeaker;
    window.renderFrequencySpeaker();
    fetch(`https://${GetParentResourceName()}/setFrequencySpeaker`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ enabled: window.frequencySpeaker })
    });
};

function frequencyEscapeHtml(value) {
    return String(value || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

function getDefaultFrequencyDefinitions() {
    const numberedChannels = (prefix, startId) => Array.from({ length: 9 }, (_, index) => {
        const number = String(index + 1).padStart(2, '0');
        return {
            id: startId + index,
            label: `${prefix} ${number}`
        };
    });

    return [
        {
            title: 'COMMAND NET',
            frequencies: [
                { id: 1, label: 'SUPERVISORS' },
                { id: 2, label: 'DISPATCH' }
            ]
        },
        { title: 'ADAM UNITS', frequencies: numberedChannels('ADAM', 3) },
        { title: 'LINCOLN UNITS', frequencies: numberedChannels('LINCOLN', 12) },
        { title: 'X-RAY UNITS', frequencies: numberedChannels('X-RAY', 21) }
    ];
}

function normalizeFrequencyDefinitions(definitions) {
    if (!Array.isArray(definitions)) return getDefaultFrequencyDefinitions();

    const normalized = definitions.map((category) => {
        const frequencies = Array.isArray(category.frequencies)
            ? category.frequencies.map((frequency) => ({
                id: Number(frequency.id),
                label: frequency.label || frequency.name || frequency.labelKey,
                labelKey: frequency.labelKey
            })).filter((frequency) => Number.isFinite(frequency.id) && frequency.id > 0)
            : [];

        return {
            title: category.title || category.name || category.titleKey,
            titleKey: category.titleKey,
            frequencies
        };
    }).filter((category) => category.frequencies.length > 0);

    return normalized.length > 0 ? normalized : getDefaultFrequencyDefinitions();
}

window.getFrequencyDefinitions = function() {
    return Array.isArray(window.frequencyDefinitions) && window.frequencyDefinitions.length > 0
        ? window.frequencyDefinitions
        : getDefaultFrequencyDefinitions();
};

window.getFrequencyText = function(item, fallback) {
    if (!item) return fallback || '';
    if (item.label) return item.label;
    if (item.title) return item.title;
    if (item.labelKey) return window.T(item.labelKey);
    if (item.titleKey) return window.T(item.titleKey);
    return fallback || '';
};

window.getFrequencyLabel = function(id) {
    const numericId = Number(id);
    const definitions = window.getFrequencyDefinitions();
    for (const category of definitions) {
        const found = category.frequencies.find((frequency) => frequency.id === numericId);
        if (found) return window.getFrequencyText(found, `Frequency ${numericId}`);
    }
    return `Frequency ${numericId || '--'}`;
};

window.getFrequencyChannelsForRender = function() {
    const localChannels = JSON.parse(JSON.stringify(window.syncedRadioChannels || {}));
    if (window.fakePlayers && window.fakePlayers.length > 0) {
        window.fakePlayers.forEach((fake, idx) => {
            if (fake.isOnline) {
                let freq = window.fakePlayerFreqs[fake.cid];
                if (freq === undefined) {
                    Object.entries(localChannels).some(([channelFreq, members]) => {
                        if (!Array.isArray(members)) return false;
                        if (members.some(member => member && member.cid === fake.cid)) {
                            freq = Number(channelFreq);
                            return true;
                        }
                        return false;
                    });
                }
                if (freq === undefined) freq = (idx % 3) + 1;

                const freqStr = freq.toString();
                Object.keys(localChannels).forEach((channelFreq) => {
                    if (Array.isArray(localChannels[channelFreq])) {
                        localChannels[channelFreq] = localChannels[channelFreq].filter(member => !member || member.cid !== fake.cid);
                    }
                });
                if (!localChannels[freqStr]) localChannels[freqStr] = [];
                if (!localChannels[freqStr].find(m => m.cid === fake.cid)) {
                    localChannels[freqStr].push({
                        cid: fake.cid,
                        name: fake.name,
                        rank: fake.jobGradeLabel,
                        isFake: true
                    });
                }
            }
        });
    }
    return localChannels;
};

window.getCurrentFrequencyMembers = function() {
    if (!window.currentFrequency) return [];
    const channels = window.getFrequencyChannelsForRender();
    return channels[String(window.currentFrequency)] || [];
};

window.renderFrequencyMiniHudPreview = function() {
    const status = document.getElementById('frequency-minihud-status');
    const preview = document.getElementById('frequency-minihud-preview');
    const button = document.getElementById('frequency-minihud-toggle');
    if (!status || !preview || !button) return;

    const members = window.getCurrentFrequencyMembers();
    const label = window.currentFrequency ? window.getFrequencyLabel(window.currentFrequency) : 'No frequency connected';
    status.textContent = window.currentFrequency
        ? `${label} - ${members.length} unit${members.length === 1 ? '' : 's'} connected`
        : 'No frequency connected';

    button.classList.toggle('active', window.frequencyMiniHudVisible === true);
    button.innerHTML = window.frequencyMiniHudVisible
        ? '<i class="fas fa-display"></i><span>HIDE</span>'
        : '<i class="fas fa-display"></i><span>SHOW</span>';

    if (!window.currentFrequency || members.length === 0) {
        preview.innerHTML = '<div class="frequency-minihud-preview-empty">Join a frequency to show units</div>';
        return;
    }

    preview.innerHTML = members.map((member) => {
        const isMe = member.cid === window.myCitizenId;
        const displayName = isMe && window.frequencyUnitName ? window.frequencyUnitName : (member.name || 'Officer');
        return `
            <div class="frequency-minihud-preview-row ${isMe ? 'is-me' : ''}">
                <span class="mini-rank">${frequencyEscapeHtml(member.rank || 'UNIT')}</span>
                <span class="mini-name">${frequencyEscapeHtml(displayName)}</span>
                ${isMe ? '<span class="mini-self">YOU</span>' : ''}
            </div>
        `;
    }).join('');
};

window.renderFrequencyMiniHud = function() {
    const hud = document.getElementById('frequency-minihud');
    const title = document.getElementById('frequency-minihud-title');
    const count = document.getElementById('frequency-minihud-count');
    const membersEl = document.getElementById('frequency-minihud-members');
    if (!hud || !title || !count || !membersEl) return;

    hud.classList.toggle('hidden', window.frequencyMiniHudVisible !== true);

    const members = window.getCurrentFrequencyMembers();
    title.textContent = window.currentFrequency ? window.getFrequencyLabel(window.currentFrequency) : 'FREQ --';
    count.textContent = String(members.length);

    if (!window.currentFrequency) {
        membersEl.innerHTML = '<div class="frequency-minihud-empty"><i class="fas fa-tower-broadcast"></i><p>NO FREQUENCY</p></div>';
        return;
    }

    if (members.length === 0) {
        membersEl.innerHTML = '<div class="frequency-minihud-empty"><i class="fas fa-user-slash"></i><p>CHANNEL CLEAR</p></div>';
        return;
    }

    membersEl.innerHTML = members.map((member) => {
        const isMe = member.cid === window.myCitizenId;
        const displayName = isMe && window.frequencyUnitName ? window.frequencyUnitName : (member.name || 'Officer');
        const isTalking = member.talking === true || member.isTalking === true;
        return `
            <div class="frequency-minihud-member">
                <span class="frequency-minihud-dot ${isTalking ? 'is-talking' : ''}"></span>
                <span class="frequency-minihud-member-rank">${frequencyEscapeHtml(member.rank || 'UNIT')}</span>
                <span class="frequency-minihud-member-name">${frequencyEscapeHtml(displayName)}</span>
            </div>
        `;
    }).join('');
};

window.toggleFrequencyMiniHud = function(force, fromGameCommand) {
    window.frequencyMiniHudVisible = typeof force === 'boolean' ? force : !window.frequencyMiniHudVisible;

    window.renderFrequencyMiniHudPreview();
    window.renderFrequencyMiniHud();

    if (!fromGameCommand) {
        fetch(`https://${GetParentResourceName()}/toggleFrequencyMiniHud`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ show: window.frequencyMiniHudVisible })
        });
    }
};

window.lockFrequencyMiniHud = function() {
    fetch(`https://${GetParentResourceName()}/lockFrequencyMiniHud`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};

window.syncFrequencyUnitNameInput = function() {
    const input = document.getElementById('frequency-minihud-unit-input');
    if (!input) return;
    if (document.activeElement !== input) {
        input.value = window.frequencyUnitName || window.playerName || '';
    }
};

window.setFrequencyUnitName = function(value, immediate) {
    const cleaned = String(value || '').replace(/\s+/g, ' ').trim().slice(0, 32);
    window.frequencyUnitName = cleaned;
    window.renderFrequencyMiniHudPreview();
    window.renderFrequencyMiniHud();

    if (frequencyUnitNameTimer) {
        clearTimeout(frequencyUnitNameTimer);
        frequencyUnitNameTimer = null;
    }

    const sendUpdate = () => {
        fetch(`https://${GetParentResourceName()}/setFrequencyUnitName`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name: window.frequencyUnitName })
        });
    };

    if (immediate) {
        sendUpdate();
        return;
    }

    frequencyUnitNameTimer = setTimeout(sendUpdate, 450);
};

window.renderFrequencyList = function() {
    const listContent = document.getElementById('frequency-list-content');
    if (!listContent) return;
    window.renderFrequencySpeaker();

    const localChannels = window.getFrequencyChannelsForRender();

    let totalConnected = 0;
    Object.values(localChannels).forEach(members => { totalConnected += members.length; });

    const categories = window.getFrequencyDefinitions();

    const html = categories.map((cat, index) => `
        <div class="freq-category-group">
            <div class="freq-category-header">
                <div class="freq-category-title">${window.getFrequencyText(cat, 'RADIO NET')}</div>
                ${index === 0 ? `<span>${window.T('connected')}: <span class="highlight-blue">${totalConnected}</span></span>` : ''}
            </div>
            ${cat.frequencies.map(f => {
                const members = localChannels[f.id.toString()] || [];
                const isMeInThis = window.currentFrequency === f.id;
                return `
                <div class="frequency-list" data-freq-id="${f.id}">
                    <div class="freq-item ${members.length > 0 ? 'expanded' : ''} ${isMeInThis ? 'active-freq' : ''}" id="freq-${f.id}">
                        <div class="freq-header" onclick="window.joinFrequency(${f.id})">
                            <span>${window.getFrequencyText(f, `Frequency ${f.id}`)}</span>
                            <i class="fas fa-chevron-down" onclick="event.stopPropagation(); window.toggleFreqItem(${f.id})"></i>
                        </div>
                        <div class="freq-content">
                            ${members.map(m => {
                                const displayName = m.cid === window.myCitizenId && window.frequencyUnitName ? window.frequencyUnitName : (m.name || 'Officer');
                                return `
                                <div class="freq-member-row ${m.cid === window.myCitizenId ? 'is-me' : ''}" 
                                     data-cid="${frequencyEscapeHtml(m.cid)}" data-from-freq="${f.id}"
                                     onmousedown="window.startPlayerDrag(event, this.dataset.cid, ${f.id})">
                                    <span class="member-rank-tag">${frequencyEscapeHtml(m.rank || 'UNIT')}</span>
                                    <span class="member-name">${frequencyEscapeHtml(displayName)}</span>
                                    <button class="join-freq-btn ${m.cid === window.myCitizenId ? 'leave' : ''}" onclick="window.joinFrequency(${f.id})">
                                        <div style="width: 6px; height: 6px; background: white; border-radius: 1px;"></div>
                                    </button>
                                </div>
                            `}).join('')}
                        </div>
                    </div>
                </div>`;
            }).join('')}
        </div>
    `).join('');
    listContent.innerHTML = html;
    window.renderFrequencyMiniHudPreview();
    window.renderFrequencyMiniHud();
};

(function initFrequencyMiniHudDrag() {
    const hud = document.getElementById('frequency-minihud');
    const handle = document.getElementById('frequency-minihud-drag-handle');
    if (!hud || !handle) return;

    let isMiniHudDragging = false;
    let currentX = 0;
    let currentY = 0;
    let initialX = 0;
    let initialY = 0;
    let xOffset = 0;
    let yOffset = 0;

    try {
        const saved = JSON.parse(localStorage.getItem('plt_frequency_minihud_position_v2') || '{}');
        if (typeof saved.x === 'number' && typeof saved.y === 'number') {
            xOffset = saved.x;
            yOffset = saved.y;
            currentX = saved.x;
            currentY = saved.y;
            hud.style.transform = `translate3d(${saved.x}px, ${saved.y}px, 0)`;
        }
    } catch (e) {}

    handle.addEventListener('mousedown', (event) => {
        initialX = event.clientX - xOffset;
        initialY = event.clientY - yOffset;
        if (event.target === handle || handle.contains(event.target)) {
            isMiniHudDragging = true;
        }
    });

    document.addEventListener('mousemove', (event) => {
        if (!isMiniHudDragging) return;
        event.preventDefault();
        currentX = event.clientX - initialX;
        currentY = event.clientY - initialY;
        xOffset = currentX;
        yOffset = currentY;
        hud.style.transform = `translate3d(${currentX}px, ${currentY}px, 0)`;
    });

    document.addEventListener('mouseup', () => {
        if (!isMiniHudDragging) return;
        isMiniHudDragging = false;
        try {
            localStorage.setItem('plt_frequency_minihud_position_v2', JSON.stringify({ x: xOffset, y: yOffset }));
        } catch (e) {}
        window.lockFrequencyMiniHud();
    });

    const unitInput = document.getElementById('frequency-minihud-unit-input');
    if (unitInput) {
        unitInput.addEventListener('mousedown', (event) => event.stopPropagation());
        unitInput.addEventListener('input', (event) => window.setFrequencyUnitName(event.target.value, false));
        unitInput.addEventListener('blur', (event) => window.setFrequencyUnitName(event.target.value, true));
        unitInput.addEventListener('keydown', (event) => {
            if (event.key === 'Enter') {
                event.preventDefault();
                window.setFrequencyUnitName(event.target.value, true);
                unitInput.blur();
            }
        });
        window.syncFrequencyUnitNameInput();
    }

    window.renderFrequencyMiniHudPreview();
    window.renderFrequencyMiniHud();
})();

window.startPlayerDrag = function(event, cid, fromFreq) {
    if (event.button !== 0 || event.target.closest('.join-freq-btn')) return;
    event.preventDefault();
    event.stopPropagation();
    
    window.isDragging = true;
    window.draggedCid = cid;
    window.draggedFromFreq = fromFreq;
    
    const target = event.currentTarget;
    const rect = target.getBoundingClientRect();
    window.dragOffsetX = event.clientX - rect.left;
    window.dragOffsetY = event.clientY - rect.top;
    
    window.freqRects = Array.from(document.querySelectorAll('.frequency-list')).map(el => ({
        el: el,
        id: parseInt(el.getAttribute('data-freq-id')),
        rect: el.getBoundingClientRect()
    }));
    
    window.dragGhost = target.cloneNode(true);
    window.dragGhost.classList.add('custom-drag-ghost');
    window.dragGhost.style.width = target.offsetWidth + 'px';
    window.dragGhost.style.pointerEvents = 'none';
    document.body.appendChild(window.dragGhost);
    
    updateGhostPosition(event);
    target.classList.add('dragging-source');
};

function updateGhostPosition(e) {
    if (!window.dragGhost) return;
    window.dragGhost.style.transform = `translate(${e.clientX - window.dragOffsetX}px, ${e.clientY - window.dragOffsetY}px)`;
}

window.handleGlobalMove = function(e) {
    if (!window.isDragging) return;
    updateGhostPosition(e);
    requestAnimationFrame(() => {
        let found = null;
        for (const item of window.freqRects) {
            const r = item.rect;
            if (e.clientX >= r.left && e.clientX <= r.right && e.clientY >= r.top && e.clientY <= r.bottom) {
                found = item;
                break;
            }
        }
        window.freqRects.forEach(item => item.el.classList.toggle('drag-over', item === found));
    });
};

window.handleGlobalUp = function(e) {
    if (!window.isDragging) return;
    let targetFreq = null;
    for (const item of window.freqRects) {
        const r = item.rect;
        if (e.clientX >= r.left && e.clientX <= r.right && e.clientY >= r.top && e.clientY <= r.bottom) {
            targetFreq = item.id;
            break;
        }
    }
    
    if (targetFreq && targetFreq !== window.draggedFromFreq) {
        const isFake = window.fakePlayers.some(p => p.cid === window.draggedCid);
        if (isFake) {
            window.fakePlayerFreqs[window.draggedCid] = targetFreq;
            window.renderFrequencyList();
            fetch(`https://${GetParentResourceName()}/movePlayerFrequency`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ cid: window.draggedCid, toFrequency: targetFreq })
            });
        } else {
            const fromFreqStr = window.draggedFromFreq.toString();
            const toFreqStr = targetFreq.toString();
            if (window.syncedRadioChannels[fromFreqStr]) {
                const playerIdx = window.syncedRadioChannels[fromFreqStr].findIndex(m => m.cid === window.draggedCid);
                if (playerIdx > -1) {
                    const playerData = window.syncedRadioChannels[fromFreqStr].splice(playerIdx, 1)[0];
                    if (!window.syncedRadioChannels[toFreqStr]) window.syncedRadioChannels[toFreqStr] = [];
                    window.syncedRadioChannels[toFreqStr].push(playerData);
                }
            }
            window.renderFrequencyList();
            fetch(`https://${GetParentResourceName()}/movePlayerFrequency`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ cid: window.draggedCid, toFrequency: targetFreq })
            });
        }
    }
    
    window.isDragging = false;
    if (window.dragGhost) window.dragGhost.remove();
    window.dragGhost = null;
    window.draggedCid = null;
    window.draggedFromFreq = null;
    document.querySelectorAll('.dragging-source').forEach(el => el.classList.remove('dragging-source'));
    document.querySelectorAll('.frequency-list').forEach(el => el.classList.remove('drag-over'));
};

window.addEventListener('mousemove', window.handleGlobalMove);
window.addEventListener('mouseup', window.handleGlobalUp);

window.renderRadioGrid = function() {
    const gridContent = document.getElementById('radio-grid-content');
    if (!gridContent) return;
    gridContent.innerHTML = '';
    
    const dispatchBtn = document.createElement('div');
    dispatchBtn.className = 'radio-btn highlight';
    setTranslatedHTML(dispatchBtn, `<i class="fas fa-satellite-dish" style="font-size: 18px; margin-bottom: 4px; color: #fff;"></i><span style="color: #fff; font-weight: 700; font-size: 14px; text-align: center;">${window.T('toggle_dispatch')}</span>`);
    dispatchBtn.style.flexDirection = 'column';
    dispatchBtn.onclick = () => { fetch(`https://${GetParentResourceName()}/toggleDispatch`, { method: 'POST', body: JSON.stringify({}) }); };
    gridContent.appendChild(dispatchBtn);

    window.currentRadioCodes.forEach((item, index) => {
        const btn = document.createElement('div');
        btn.className = 'radio-btn';
        if (item.label === 'QRR' || index === window.currentRadioCodes.length - 1) btn.classList.add('highlight');
        btn.innerHTML = `<span>${item.label}</span>`;
        btn.onclick = () => window.officerAction(item.code);
        gridContent.appendChild(btn);
    });
};

window.renderOfficerPosesGrid = function() {
    const grid = document.getElementById('officer-poses-grid');
    if (!grid) return;
    grid.innerHTML = '';
    const stopBtn = document.createElement('div');
    stopBtn.className = 'pose-grid-item stop';
    setTranslatedHTML(stopBtn, `<i class="fas fa-stop"></i><span>${window.T('stop_all')}</span>`);
    stopBtn.onclick = () => window.officerAction('stop_poses');
    grid.appendChild(stopBtn);

    Object.keys(window.allAnimations).sort().forEach(id => {
        const pose = window.allAnimations[id];
        const btn = document.createElement('div');
        btn.className = 'pose-grid-item';
        btn.innerHTML = `<i class="fas fa-person"></i><span>${pose.label}</span>`;
        btn.onclick = () => window.officerAction('pose_' + id);
        grid.appendChild(btn);
    });
};

window.updateHexGrid = function(category) {
    const grid = document.querySelector('.hex-grid');
    if (!grid) return;
    const titleEl = document.getElementById('officer-menu-title');
    if (titleEl) titleEl.innerText = window.T('tab_' + category);

    const contents = {
        interaction: [{ icon: 'magnifying-glass', labelKey: 'hex_search', action: 'search_person' }, { icon: 'handcuffs', labelKey: 'hex_handcuff', action: 'cuff' }, { icon: 'person-walking-arrow-right', labelKey: 'hex_escort', action: 'escort' }, { icon: 'car-side', labelKey: 'hex_put_in_car', action: 'put_car' }, { icon: 'door-open', labelKey: 'hex_out_of_car', action: 'out_car' }, { icon: 'file-invoice-dollar', labelKey: 'hex_fine', action: 'fine' }, { icon: 'lock', labelKey: 'hex_jail', action: 'jail' }],
        vehicles: [{ icon: 'address-card', labelKey: 'hex_plate', action: 'check_plate' }, { icon: 'lock-open', labelKey: 'hex_unlock', action: 'unlock' }, { icon: 'toolbox', labelKey: 'hex_seize', action: 'seize' }, { icon: 'lock', labelKey: 'hex_wheel_clamp', action: 'toggle_wheel_clamp' }, { icon: 'tower-broadcast', labelKey: 'hex_alpr_system', action: 'open_alpr' }],
        alpr: [{ icon: 'power-off', labelKey: 'hex_toggle', action: 'alpr_toggle' }, { icon: 'gauge-high', labelKey: 'hex_set_speed', action: 'alpr_set_speed' }, { icon: 'arrows-up-down-left-right', labelKey: 'hex_move_resize', action: 'alpr_move' }, { icon: 'arrow-left', labelKey: 'hex_back', action: 'back_to_vehicles' }],
        monitoring: [{ icon: 'desktop', labelKey: 'hex_monitor_center', action: 'ankle_monitor_open' }, { icon: 'location-crosshairs', labelKey: 'hex_monitor_apply', action: 'ankle_monitor_apply' }, { icon: 'link-slash', labelKey: 'hex_monitor_remove', action: 'ankle_monitor_remove_nearby' }],
        objects: [{ icon: 'cone', labelKey: 'hex_cone', action: 'spawn_cone' }, { icon: 'barrier', labelKey: 'hex_barrier', action: 'spawn_barrier' }, { icon: 'sign-hanging', labelKey: 'hex_spikes', action: 'spawn_spikes' }, { icon: 'lightbulb', labelKey: 'hex_light', action: 'spawn_light' }, { icon: 'trash', labelKey: 'hex_remove', action: 'remove_object' }, { icon: 'broom', labelKey: 'hex_clear_all', action: 'clear_objects' }]
    };

    const data = contents[category] || contents.interaction;
    const items = grid.querySelectorAll('.hex-item');
    items.forEach((item, index) => {
        const itemData = data[index];
        if (itemData) {
            item.style.display = 'block';
            item.onclick = () => window.officerAction(itemData.action);
            setTranslatedHTML(item.querySelector('.hex-inner'), `<i class="fas fa-${itemData.icon}"></i><span>${window.T(itemData.labelKey)}</span>`);
        } else {
            item.style.display = 'none';
        }
    });
};

window.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        const speedModal = document.getElementById('alpr-speed-modal');
        const officerMenu = document.getElementById('officer-menu-container');
        
        if (speedModal && !speedModal.classList.contains('hidden')) {
            window.closeAlprSpeedModal();
        } else if (officerMenu && officerMenu.style.display !== 'none') {
            window.closeOfficerMenu();
        }
    }
});

const alprSettingsSpeedInput = document.getElementById('alpr-settings-speed-input');
if (alprSettingsSpeedInput) {
    alprSettingsSpeedInput.addEventListener('keydown', function(event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            window.officerAction('alpr_apply_speed');
        }
    });
}
