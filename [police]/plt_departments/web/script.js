window.highestZIndex = 50;
let nodes = [];
let connections = [];
let selectedNode = null;
let isDragging = false;
let isPanning = false;
let dragTarget = null;
let offset = { x: 0, y: 0 };

// Global Locale Data
window.localeTable = {};
window.pltSpeedUnit = 'KM/H';

window.frequencyRadioSounds = {
    join: new Audio('audio/join.mp3'),
    talk: new Audio('audio/talk.mp3'),
    leave: new Audio('audio/leave.mp3')
};

Object.values(window.frequencyRadioSounds).forEach((audio) => {
    audio.preload = 'auto';
    audio.volume = 0.55;
});

window.playFrequencyRadioSound = function(sound) {
    const audio = window.frequencyRadioSounds && window.frequencyRadioSounds[sound];
    if (!audio) return;

    try {
        audio.pause();
        audio.currentTime = 0;
        const playPromise = audio.play();
        if (playPromise && typeof playPromise.catch === 'function') {
            playPromise.catch(() => {});
        }
    } catch (e) {}
};

window.T = function(key, vars = {}) {
    let text = window.localeTable[key] || key;
    if (vars) {
        for (let k in vars) {
            text = text.replace(new RegExp('{' + k + '}', 'g'), vars[k]);
        }
    }
    return text;
};

// Helper to set innerHTML and translate
function setTranslatedHTML(el, html) {
    if (typeof el === 'string') el = document.getElementById(el);
    if (!el) return;
    el.innerHTML = html;
    applyTranslations(el);
}

function cloneTemplate(id) {
    const template = document.getElementById(id);
    if (!template) return null;
    const clone = template.content.cloneNode(true);
    applyTranslations(clone);
    return clone;
}

function applyTranslations(root = document.body) {
    if (!root || !window.localeTable) return;
    
    // 1. Elements with data-translate attribute
    root.querySelectorAll('[data-translate]').forEach(el => {
        const key = el.getAttribute('data-translate');
        if (window.localeTable[key]) {
            el.innerText = window.T(key);
        }
    });

    // 2. Placeholders with data-translate-placeholder attribute
    root.querySelectorAll('[data-translate-placeholder]').forEach(el => {
        const key = el.getAttribute('data-translate-placeholder');
        if (window.localeTable[key]) {
            el.setAttribute('placeholder', window.T(key));
        }
    });

    // 3. Fallback: Elements with direct text
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
        acceptNode: function(node) {
            if (node.parentElement && (node.parentElement.tagName === 'SCRIPT' || node.parentElement.tagName === 'STYLE' || node.parentElement.hasAttribute('data-translate'))) {
                return NodeFilter.FILTER_REJECT;
            }
            return NodeFilter.FILTER_ACCEPT;
        }
    }, false);

    let node;
    const nodesToTranslate = [];
    while (node = walker.nextNode()) {
        nodesToTranslate.push(node);
    }

    nodesToTranslate.forEach(node => {
        const text = node.nodeValue.trim();
        if (text && text.length > 2) { // Skip short stuff like "X" or "1"
            if (window.localeTable[text]) {
                node.nodeValue = node.nodeValue.replace(text, window.T(text));
            } else if (window.localeTable[text.toLowerCase()]) {
                node.nodeValue = node.nodeValue.replace(text, window.T(text.toLowerCase()));
            }
        }
    });

    // 4. Placeholders
    root.querySelectorAll('[placeholder]:not([data-translate-placeholder])').forEach(el => {
        const val = el.getAttribute('placeholder').trim();
        if (window.localeTable[val]) {
            el.setAttribute('placeholder', window.T(val));
        } else if (window.localeTable[val.toLowerCase()]) {
            el.setAttribute('placeholder', window.T(val.toLowerCase()));
        }
    });

    // 5. Titles
    root.querySelectorAll('[title]').forEach(el => {
        const val = el.getAttribute('title').trim();
        if (window.localeTable[val]) {
            el.setAttribute('title', window.T(val));
        } else if (window.localeTable[val.toLowerCase()]) {
            el.setAttribute('title', window.T(val.toLowerCase()));
        }
    });
}

function updateSpeedUnitLabels(root = document.body) {
    const unit = window.pltSpeedUnit || 'KM/H';
    root.querySelectorAll('[data-speed-unit-label]').forEach(el => {
        el.innerText = unit;
    });
    root.querySelectorAll('[data-speed-limit-label]').forEach(el => {
        el.innerText = window.T('limit_kmh', { unit });
    });
}

// Listen for locale update from Lua
window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'updateLocale') {
        window.localeTable = data.translations;
        window.pltSpeedUnit = data.speedUnit || window.pltSpeedUnit || 'KM/H';
        applyTranslations();
        updateSpeedUnitLabels();
    }
});

let pan = { x: 0, y: 0 };
let zoom = 1.0;
let lastMousePos = { x: 0, y: 0 };

let activePort = null;
let tempLine = null;

// Members UI Elements
const membersView = document.getElementById('members-view');
const playersList = document.getElementById('players-list');
const playerSearch = document.getElementById('player-search');
const memberEditor = document.getElementById('member-editor');
const selectedPlayerInfo = document.getElementById('selected-player-info');
const hireDeptSelect = document.getElementById('hire-dept-select');
const hireRankSelect = document.getElementById('hire-rank-select');

// Garage UI Elements
const garageView = document.getElementById('garage-view');
const garageVehiclesList = document.getElementById('garage-vehicles');
const garageDeptName = document.getElementById('garage-dept-name');
const garageSearchInput = document.getElementById('garage-search-input');
const vehicleCountStat = document.getElementById('vehicle-count-stat');
let currentGarageData = null;
let garageVehicles = [];

let onlinePlayers = [];
let selectedPlayer = null;
let currentTab = 'departments';
let rankFrameworkSyncJobByNode = {};

const canvas = document.getElementById('canvas');
const canvasContainer = document.querySelector('.canvas-container');
const canvasContent = document.getElementById('canvas-content');
const gridLayer = document.getElementById('grid-layer');
const svg = document.getElementById('connections-svg');
const app = document.getElementById('app');
const inspector = document.querySelector('.inspector');
const inspectorContent = document.getElementById('inspector-content');

window.highestZIndex = 50;

// Resolution Adaptation for UI
window.resolutionScale = 1.0;
function updateAppScaling() {
    const baseHeight = 1080;
    const screenHeight = window.innerHeight;
    window.resolutionScale = screenHeight / baseHeight;
    
    // Set global CSS variable for other stylesheets
    document.documentElement.style.setProperty('--ui-scale', window.resolutionScale);
    
    // Scale /managedepts UI
    const appElement = document.getElementById('app');
    if (appElement) {
        appElement.style.transform = `scale(${window.resolutionScale})`;
        appElement.style.transformOrigin = 'center center';
    }

    // F6/F7 Interaction Menus & Modals now use VH units for perfect scaling
    // but we still scale the smaller modals
    const interactionModals = [
        '.citation-paper', 
        '.fine-input-modal', 
        '.seize-input-modal',
        '.import-modal',
        '.placement-help-card', 
        '.radar-setup-modal',
        '.armory-modal',
        '.win98-window', 
        '.a4-document',
        '.mac-ios-modal',
        '.alpr-modal-card',
        '.swipe-card-wrapper',
        '.officer-menu-wrapper'
    ];
    
    interactionModals.forEach(selector => {
        const elements = document.querySelectorAll(selector);
        elements.forEach(el => {
            el.style.transform = `scale(${window.resolutionScale})`;
            
            // Handle different origins for menus on the edge
            if (selector === '.officer-menu-wrapper') {
                el.style.transformOrigin = 'center right';
            } else if (selector === '.placement-help-card') {
                el.style.transformOrigin = 'top right';
            } else {
                el.style.transformOrigin = 'center center';
            }
        });
    });
    
    // ALPR System (preserving its translateX(-50%) centered positioning)
    const alpr = document.getElementById('alpr-container');
    if (alpr) {
        // For ALPR, we must use scale because of the translateX
        let baseScale = 1.0;
        if (alpr.classList.contains('size-small')) baseScale = 0.8;
        else if (alpr.classList.contains('size-large')) baseScale = 1.2;
        
        alpr.style.transform = `translateX(-50%) scale(${window.resolutionScale * baseScale})`;
        alpr.style.transformOrigin = 'bottom center';
    }

    // Dispatch System now uses VH units for perfect scaling

    // Scale Boss Menu (Modern and Vintage)
    const bossMenu = document.querySelector('.macintosh-chassis');
    const vintageMonitor = document.querySelector('.vintage-monitor');
    if (bossMenu) {
        bossMenu.style.transform = `scale(${window.resolutionScale})`;
        bossMenu.style.transformOrigin = 'center center';
    }
    if (vintageMonitor) {
        vintageMonitor.style.transform = `scale(${window.resolutionScale})`;
        vintageMonitor.style.transformOrigin = 'center center';
    }

    // Scale Garage UI
    const garage = document.querySelector('.garage-minimal-wrapper');
    if (garage) {
        garage.style.transform = `scale(${window.resolutionScale})`;
        garage.style.transformOrigin = 'center center';
    }
}

window.addEventListener('resize', updateAppScaling);
updateAppScaling();

// Run it again after some delay to catch any late-rendered elements
setTimeout(updateAppScaling, 100);
setTimeout(updateAppScaling, 500);

// Redefine ALPR size function to include resolution update
const originalSetAlprSize = window.setAlprSize;
window.setAlprSize = function(size) {
    if (typeof originalSetAlprSize === 'function') originalSetAlprSize(size);
    updateAppScaling();
};

// Message listener from FiveM
window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'open' || data.action === 'openOfficerMenu' || data.action === 'openForensicPC' || data.action === 'openBossMenu' || data.action === 'toggleDispatch' || data.action === 'openGarage' || data.action === 'openAnkleMonitor') {
        setTimeout(updateAppScaling, 50);
    }
    
    if (data.action === 'showCameraOverlay') {
        const overlay = document.getElementById('camera-overlay');
        const label = document.getElementById('cam-label');
        if (overlay && label) {
            overlay.classList.remove('hidden');
            label.innerText = data.label.toUpperCase();
            updateCameraTime();
        }
    } else if (data.action === 'hideCameraOverlay') {
        const overlay = document.getElementById('camera-overlay');
        if (overlay) overlay.classList.add('hidden');
    } else if (data.action === 'updateCameraTime') {
        updateCameraTime();
    } else if (data.action === 'open') {
        app.classList.remove('hidden');
        app.style.setProperty('display', 'flex', 'important');
        if (inspector) inspector.classList.add('hidden');
        loadData(data.data);
        applyTranslations();
    } else if (data.action === 'placementDone') {
        app.classList.remove('hidden');
        app.style.setProperty('display', 'flex', 'important');
        const node = nodes.find(n => n.id === data.nodeId);
        if (node) {
            if (node.type === 'k9') {
                const coords = { ...(data.coords || {}) };
                if (coords.h !== undefined) coords.h = parseFloat(coords.h);
                if (data.locType === 'bed') {
                    node.coords = coords;
                } else if (data.locType === 'spawn') {
                    node.spawnCoords = coords;
                }
            } else if (data.locType === 'spawn') {
                if (!node.spawnPoints) node.spawnPoints = [];
                node.spawnPoints[data.pointIndex] = data.coords;
            } else if (data.locType === 'impound_spawn') {
                if (!node.impoundSpawnPoints) node.impoundSpawnPoints = [];
                node.impoundSpawnPoints[data.pointIndex] = data.coords;
            } else if (data.locType === 'delete') {
                if (!node.deletePoints) node.deletePoints = [];
                node.deletePoints[data.pointIndex] = data.coords;
            } else if (data.locType === 'camera') {
                if (!node.cameras) node.cameras = [];
                if (node.cameras[data.pointIndex]) {
                    node.cameras[data.pointIndex].coords = data.coords;
                }
            } else if (data.locType && node.type === 'location') {
                if (!node.coordsList) node.coordsList = {};
                
                // Ensure heading is a number
                const coords = { ...data.coords };
                if (coords.h !== undefined) coords.h = parseFloat(coords.h);
                
                node.coordsList[data.locType] = coords;

                // Store interaction type (ped or zone)
                if (data.interactionType) {
                    if (!node.interactionTypes) node.interactionTypes = {};
                    node.interactionTypes[data.locType] = data.interactionType;
                } else if (node.interactionTypes && node.interactionTypes[data.locType]) {
                    // If no interaction type provided (standard zone pick), clear the ped type if it existed
                    delete node.interactionTypes[data.locType];
                }
            } else {
                // Single-point nodes (evidence, armory, wardrobe, boss_menu, etc.)
                // store placement directly on node.coords, not coordsList.
                const coords = { ...data.coords };
                if (coords.h !== undefined) coords.h = parseFloat(coords.h);
                node.coords = coords;
                if (data.interactionType !== undefined) {
                    node.interactionType = data.interactionType;
                }
            }
            if (selectedNode && selectedNode.id === node.id) renderInspector();
            renderCanvas();
            saveData(true);
        }
    } else if (data.action === 'doorPlacementDone') {
        app.classList.remove('hidden');
        app.style.setProperty('display', 'flex', 'important');
        const node = nodes.find(n => n.id === data.nodeId);
        if (node && node.doors && node.doors[data.doorIndex]) {
            if (data.doorNum === 2) {
                node.doors[data.doorIndex].coords2 = data.coords;
                node.doors[data.doorIndex].hash2 = data.hash;
            } else {
                node.doors[data.doorIndex].coords = data.coords;
                node.doors[data.doorIndex].hash = data.hash;
            }
            saveData();
            if (selectedNode && selectedNode.id === node.id) renderInspector();
            renderCanvas();
        }
    } else if (data.action === 'openGarage') {
        openGarage(data);
    } else if (data.action === 'syncData') {
        if (data.speedUnit) {
            window.pltSpeedUnit = data.speedUnit;
            updateSpeedUnitLabels();
        }
        if (data.data) {
            if (app.classList.contains('hidden')) {
                loadData(data.data);
            } else {
                // Keep current state but update the base data object
                currentFullData = data.data;
            }
        }
        if (data.members) window.syncedMembers = data.members;
        if (data.finances) window.syncedFinances = data.finances;
        if (data.balances) window.syncedBalances = data.balances;
        if (data.transactions) window.syncedTransactions = data.transactions;
        if (data.radars) window.syncedRadars = data.radars;
        
        // Department roster refresh is handled in boss_menu.js (second listener here caused
        // two simultaneous getPlayers calls; the rate-limited one returned [] and wiped the UI).
    } else if (data.action === 'syncTransactions') {
        window.syncedTransactions = data.transactions || {};
        const safariWin = document.getElementById('mac-window-safari');
        if (safariWin && !safariWin.classList.contains('hidden')) {
            const activeTab = document.querySelector('.safari-tab.active');
            if (activeTab && activeTab.innerText.toLowerCase().includes('fines')) {
                window.renderSafariApp('fines');
            }
        }
    } else if (data.action === 'showCitation') {
        window.showCitation(data.data);
    } else if (data.action === 'closeCitation') {
        window.closeCitationForce();
    } else if (data.action === 'playFrequencyRadioSound') {
        window.playFrequencyRadioSound(data.sound);
    } else if (data.action === 'openFineInput') {
        window.openFineInput(data.targetServerId);
    } else if (data.action === 'togglePlacementHelp') {
        const help = document.getElementById('placement-help-container');
        if (help) {
            if (data.visible) {
                // Update labels if provided
                if (data.header) help.querySelector('.help-header span').textContent = data.header;
                if (data.confirmLabel) help.querySelector('.key-row:nth-child(1) .action').textContent = data.confirmLabel;
                if (data.rotateLabel) help.querySelector('.key-row:nth-child(2) .action').textContent = data.rotateLabel;
                help.style.display = 'block';
            } else {
                help.style.display = 'none';
            }
        }
    } else if (data.action === 'openRadarSetup') {
        if (data.speedUnit) window.pltSpeedUnit = data.speedUnit;
        window.openRadarSetup(data.data);
    } else if (data.action === 'showNotification') {
        window.showNotification(data.title, data.items, data.message);
    } else if (data.action === 'openSeizeInput') {
        window.openSeizeInput(data.vehNetId);
    } else if (data.action === 'openJailInput') {
        window.openJailInput(data.targetServerId, data.maxMinutes || 60);
    } else if (data.action === 'openOutfitSelection') {
        window.openOutfitSelection(data.outfits);
    }
});

function updateCameraTime() {
    const timeEl = document.getElementById('cam-timestamp');
    if (!timeEl) return;
    const now = new Date();
    const dateStr = now.toLocaleDateString();
    const timeStr = now.toLocaleTimeString();
    timeEl.innerText = `${dateStr} ${timeStr}`;
}

// --- NOTIFICATION SYSTEM ---
window.showNotification = function(title, items, message) {
    const container = document.getElementById('notification-container');
    if (!container) return;

    const notification = document.createElement('div');
    notification.className = 'custom-notification';
    
    let itemsHtml = '';
    if (items && Array.isArray(items)) {
        itemsHtml = items.map(item => `
            <div class="notify-item">
                <label>${item.label}</label>
                <span>${item.value}</span>
            </div>
        `).join('');
    } else if (message) {
        itemsHtml = `<div class="notify-body-text">${message}</div>`;
    }

    notification.innerHTML = `
        <div class="notify-header">
            <i class="fas fa-shield-halved"></i>
            <span>SYSTEM DISPATCH</span>
        </div>
        <div class="notify-body">
            <div class="notify-title">${title}</div>
            ${itemsHtml}
        </div>
    `;

    container.appendChild(notification);

    // Auto-remove after 7 seconds
    setTimeout(() => {
        notification.classList.add('fadeOut');
        setTimeout(() => notification.remove(), 400);
    }, 7000);
};

// OUTFIT SELECTION LOGIC
window.openOutfitSelection = function(outfits) {
    const container = document.getElementById('outfit-selection-container');
    const list = document.getElementById('outfit-list');
    if (!container || !list) return;

    list.innerHTML = '';
    outfits.forEach((outfit, index) => {
        const btn = document.createElement('button');
        btn.className = 'outfit-option-btn';
        btn.innerHTML = `
            <span>${outfit.label || 'Outfit ' + (index + 1)}</span>
            <i class="fas fa-chevron-right"></i>
        `;
        btn.onclick = () => {
            fetch(`https://${GetParentResourceName()}/selectOutfit`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ index: index })
            });
            window.closeOutfitSelection();
        };
        list.appendChild(btn);
    });

    container.classList.remove('hidden');
};

window.closeOutfitSelection = function() {
    const container = document.getElementById('outfit-selection-container');
    if (container) container.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeOutfitSelection`, {
        method: 'POST',
        body: JSON.stringify({})
    });
};

// CITATION / FINE SYSTEM LOGIC
let currentCitationData = null;
let currentFineTargetId = null;
let citationUpdateTimer = null;
let citationSignatureDrawing = false;
let citationSignatureDrawn = false;
let citationSignatureCanvasReady = false;

window.openFineInput = function(targetId) {
    console.log("NUI: Executing openFineInput for target:", targetId);
    currentFineTargetId = targetId;
    document.getElementById('fine-reason-input').value = '';
    document.getElementById('fine-amount-input').value = '';
    const container = document.getElementById('fine-input-container');
    if (container) {
        container.classList.add('visible');
        console.log("NUI: fine-input-container set to visible");
    } else {
        console.error("NUI: fine-input-container NOT FOUND");
    }
};

window.closeFineInput = function() {
    const container = document.getElementById('fine-input-container');
    if (container) container.classList.remove('visible');
    fetch(`https://${GetParentResourceName()}/closeFineInput`, {
        method: 'POST',
        body: JSON.stringify({})
    });
};

window.submitFine = function() {
    const reason = document.getElementById('fine-reason-input').value;
    const amount = document.getElementById('fine-amount-input').value;
    
    if (!reason || !amount || isNaN(amount) || amount <= 0) return;
    
    fetch(`https://${GetParentResourceName()}/submitFine`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            targetId: currentFineTargetId,
            reason: reason,
            amount: parseInt(amount)
        })
    });
    
    const container = document.getElementById('fine-input-container');
    if (container) container.classList.remove('visible');
};

function setCitationText(id, value) {
    const el = document.getElementById(id);
    if (el) el.innerText = value || '';
}

function setCitationHidden(id, hidden) {
    const el = document.getElementById(id);
    if (el) el.classList.toggle('hidden', hidden === true);
}

function getCitationMode(data) {
    return (data && data.mode) || 'target_review';
}

function isCitationOfficerMode() {
    const mode = getCitationMode(currentCitationData);
    return mode === 'officer_draft' || mode === 'officer_sent' || mode === 'officer_signed' || mode === 'officer_paid';
}

function isCitationLockedForEditing() {
    const status = currentCitationData && currentCitationData.status;
    return status === 'signed' || status === 'paid' || status === 'declined';
}

function setCitationSignatureImage(signature) {
    const img = document.getElementById('cit-signature-image');
    if (!img) return;
    if (signature) {
        img.src = signature;
        img.classList.remove('hidden');
    } else {
        img.removeAttribute('src');
        img.classList.add('hidden');
    }
}

function resetCitationCanvas() {
    const canvas = document.getElementById('cit-signature-canvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    ctx.lineWidth = 2.4;
    ctx.strokeStyle = '#003366';
    citationSignatureDrawn = false;
}

function initCitationSignatureCanvas() {
    if (citationSignatureCanvasReady) return;
    const canvas = document.getElementById('cit-signature-canvas');
    if (!canvas) return;

    const getPoint = (event) => {
        const rect = canvas.getBoundingClientRect();
        return {
            x: ((event.clientX - rect.left) / rect.width) * canvas.width,
            y: ((event.clientY - rect.top) / rect.height) * canvas.height
        };
    };

    canvas.addEventListener('pointerdown', (event) => {
        event.preventDefault();
        citationSignatureDrawing = true;
        const ctx = canvas.getContext('2d');
        const point = getPoint(event);
        ctx.beginPath();
        ctx.moveTo(point.x, point.y);
        canvas.setPointerCapture(event.pointerId);
    });

    canvas.addEventListener('pointermove', (event) => {
        if (!citationSignatureDrawing) return;
        event.preventDefault();
        const ctx = canvas.getContext('2d');
        const point = getPoint(event);
        ctx.lineTo(point.x, point.y);
        ctx.stroke();
        citationSignatureDrawn = true;
        updateCitationActionState();
    });

    const stopDrawing = (event) => {
        if (!citationSignatureDrawing) return;
        citationSignatureDrawing = false;
        try { canvas.releasePointerCapture(event.pointerId); } catch (e) {}
    };

    canvas.addEventListener('pointerup', stopDrawing);
    canvas.addEventListener('pointercancel', stopDrawing);
    canvas.addEventListener('pointerleave', stopDrawing);
    citationSignatureCanvasReady = true;
}

window.clearCitationSignature = function() {
    resetCitationCanvas();
    updateCitationActionState();
};

function updateCitationActionState() {
    if (!currentCitationData) return;

    const reasonEdit = document.getElementById('cit-reason-edit');
    const amountEdit = document.getElementById('cit-amount-edit');
    const sendBtn = document.getElementById('cit-send-btn');
    const signBtn = document.getElementById('cit-sign-btn');
    const payBtn = document.getElementById('cit-pay-btn');

    const amount = parseInt((amountEdit && amountEdit.value) || currentCitationData.amount || 0, 10);
    const reason = ((reasonEdit && reasonEdit.value) || currentCitationData.reason || '').trim();
    const canSend = isCitationOfficerMode() && !currentCitationData.sent && !isCitationLockedForEditing() && reason !== '' && amount > 0;
    const isSigned = currentCitationData.status === 'signed';
    const isPaid = currentCitationData.status === 'paid';

    if (sendBtn) {
        sendBtn.disabled = !canSend;
        sendBtn.innerText = currentCitationData.sent ? 'LIVE UPDATE ACTIVE' : 'SEND TO VIOLATOR';
    }
    if (signBtn) signBtn.disabled = !citationSignatureDrawn;
    if (payBtn) payBtn.disabled = !isSigned || isPaid;
}

function scheduleCitationDraftUpdate(immediate) {
    if (!currentCitationData || !isCitationOfficerMode() || isCitationLockedForEditing()) return;

    const reasonEdit = document.getElementById('cit-reason-edit');
    const amountEdit = document.getElementById('cit-amount-edit');
    const reason = (reasonEdit && reasonEdit.value) || '';
    const amount = parseInt((amountEdit && amountEdit.value) || '0', 10);

    currentCitationData.reason = reason;
    currentCitationData.amount = Number.isNaN(amount) ? 0 : amount;
    setCitationText('cit-reason', reason || 'GENERAL VIOLATION');
    setCitationText('cit-amount', String(currentCitationData.amount || 0));
    updateCitationActionState();

    if (citationUpdateTimer) {
        clearTimeout(citationUpdateTimer);
        citationUpdateTimer = null;
    }

    const send = () => {
        fetch(`https://${GetParentResourceName()}/updateCitationDraft`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                citationId: currentCitationData.id,
                reason: reason,
                amount: currentCitationData.amount
            })
        });
    };

    if (immediate) {
        send();
    } else {
        citationUpdateTimer = setTimeout(send, 350);
    }
}

function bindCitationEditorInputs() {
    const reasonEdit = document.getElementById('cit-reason-edit');
    const amountEdit = document.getElementById('cit-amount-edit');
    if (reasonEdit && !reasonEdit.dataset.bound) {
        reasonEdit.dataset.bound = '1';
        reasonEdit.addEventListener('input', () => scheduleCitationDraftUpdate(false));
        reasonEdit.addEventListener('blur', () => scheduleCitationDraftUpdate(true));
    }
    if (amountEdit && !amountEdit.dataset.bound) {
        amountEdit.dataset.bound = '1';
        amountEdit.addEventListener('input', () => scheduleCitationDraftUpdate(false));
        amountEdit.addEventListener('blur', () => scheduleCitationDraftUpdate(true));
    }
}

// --- SEIZURE SYSTEM LOGIC ---
let currentSeizeVeh = null;
let currentJailTargetId = null;
let currentJailMaxMinutes = 60;

window.openSeizeInput = function(vehNetId) {
    currentSeizeVeh = vehNetId;
    document.getElementById('seize-reason-input').value = '';
    document.getElementById('seize-price-input').value = '500';
    const container = document.getElementById('seize-input-container');
    if (container) container.classList.add('visible');
};

window.closeSeizeInput = function() {
    const container = document.getElementById('seize-input-container');
    if (container) container.classList.remove('visible');
    fetch(`https://${GetParentResourceName()}/closeSeizeInput`, {
        method: 'POST',
        body: JSON.stringify({})
    });
};

window.submitSeize = function() {
    const reason = document.getElementById('seize-reason-input').value;
    const price = document.getElementById('seize-price-input').value;
    
    if (!reason || !price || isNaN(price) || price < 0) return;
    
    fetch(`https://${GetParentResourceName()}/submitSeize`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            vehNetId: currentSeizeVeh,
            reason: reason,
            price: parseInt(price)
        })
    });
    
    const container = document.getElementById('seize-input-container');
    if (container) container.classList.remove('visible');
};

// --- JAIL INPUT SYSTEM LOGIC ---
window.openJailInput = function(targetId, maxMinutes) {
    currentJailTargetId = targetId;
    currentJailMaxMinutes = Number.isFinite(maxMinutes) ? Math.max(0, parseInt(maxMinutes, 10)) : 60;

    const minutesInput = document.getElementById('jail-minutes-input');
    const reasonInput = document.getElementById('jail-reason-input');
    if (minutesInput) {
        minutesInput.value = '0';
        minutesInput.max = String(currentJailMaxMinutes);
    }
    if (reasonInput) reasonInput.value = '';

    const container = document.getElementById('jail-input-container');
    if (container) container.classList.add('visible');
};

window.closeJailInput = function() {
    const container = document.getElementById('jail-input-container');
    if (container) container.classList.remove('visible');
    fetch(`https://${GetParentResourceName()}/closeJailInput`, {
        method: 'POST',
        body: JSON.stringify({})
    });
};

window.submitJail = function() {
    const minutesInput = document.getElementById('jail-minutes-input');
    const reasonInput = document.getElementById('jail-reason-input');
    if (!minutesInput || !reasonInput) return;

    const reason = reasonInput.value.trim();
    const minutes = parseInt(minutesInput.value, 10);

    if (!reason || Number.isNaN(minutes)) return;

    const boundedMinutes = Math.max(0, Math.min(currentJailMaxMinutes, minutes));

    fetch(`https://${GetParentResourceName()}/submitJail`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            targetId: currentJailTargetId,
            minutes: boundedMinutes,
            reason: reason
        })
    });

    const container = document.getElementById('jail-input-container');
    if (container) container.classList.remove('visible');
};

window.showCitation = function(data) {
    console.log("NUI: Executing showCitation with data:", data);
    currentCitationData = data || {};
    const container = document.getElementById('citation-container');
    
    if (!container) {
        console.error("NUI: citation-container NOT FOUND in DOM");
        return;
    }

    initCitationSignatureCanvas();
    bindCitationEditorInputs();

    const mode = getCitationMode(currentCitationData);
    const officerMode = isCitationOfficerMode();
    const targetMode = !officerMode;
    const locked = isCitationLockedForEditing();
    const signed = currentCitationData.status === 'signed' || currentCitationData.status === 'paid';

    // Header & Base Info
    setCitationText('cit-dept', currentCitationData.deptLabel || 'CITY POLICE DEPARTMENT');
    setCitationText('cit-name', currentCitationData.targetName || 'UNKNOWN');
    setCitationText('cit-dl', currentCitationData.targetCID || 'N/A');
    setCitationText('cit-date', currentCitationData.date || '01/01/2025');
    setCitationText('cit-location', currentCitationData.location || 'LOS SANTOS');
    setCitationText('cit-time', currentCitationData.time || '00:00');
    
    // Vehicle Info
    const veh = currentCitationData.vehicle || {};
    setCitationText('cit-plate', veh.plate || 'NONE');
    setCitationText('cit-model', veh.model || 'PEDESTRIAN');
    setCitationText('cit-color', veh.color || 'N/A');

    // Violation & Officer
    setCitationText('cit-reason', currentCitationData.reason || 'GENERAL VIOLATION');
    setCitationText('cit-officer', currentCitationData.officerName || 'OFFICER');
    setCitationText('cit-amount', String(currentCitationData.amount || 0));
    setCitationText('citation-serial-num', currentCitationData.serial || currentCitationData.id || `LS-${Math.floor(100000 + Math.random() * 900000)}`);

    const reasonEdit = document.getElementById('cit-reason-edit');
    const amountEdit = document.getElementById('cit-amount-edit');
    if (reasonEdit && document.activeElement !== reasonEdit) reasonEdit.value = currentCitationData.reason || '';
    if (amountEdit && document.activeElement !== amountEdit) amountEdit.value = currentCitationData.amount || '';

    setCitationHidden('cit-reason', officerMode && !locked);
    setCitationHidden('cit-reason-edit', !(officerMode && !locked));
    setCitationHidden('cit-amount-edit', !(officerMode && !locked));
    const amountDisplay = document.querySelector('.fine-amount');
    if (amountDisplay) amountDisplay.classList.toggle('hidden', officerMode && !locked);
    
    setCitationText('cit-signature', '');
    setCitationSignatureImage(currentCitationData.signature);
    setCitationHidden('cit-signature-canvas', !(targetMode && !signed));
    setCitationHidden('cit-signature-hint', !(targetMode && !signed));
    setCitationHidden('cit-officer-actions', !officerMode);
    setCitationHidden('cit-target-actions', !targetMode);
    setCitationHidden('cit-clear-signature-btn', !(targetMode && !signed));
    setCitationHidden('cit-sign-btn', !(targetMode && !signed));
    setCitationHidden('cit-pay-btn', !(targetMode && signed && currentCitationData.status !== 'paid'));
    setCitationHidden('cit-decline-btn', !(targetMode && currentCitationData.status !== 'paid'));

    if (targetMode && !signed) {
        resetCitationCanvas();
    }
    updateCitationActionState();
    
    container.classList.add('visible');
    console.log("NUI: Added 'visible' class to citation-container");
};

window.sendCitationToTarget = function() {
    if (!currentCitationData || !currentCitationData.id || isCitationLockedForEditing()) return;
    scheduleCitationDraftUpdate(true);
    fetch(`https://${GetParentResourceName()}/sendCitationToTarget`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ citationId: currentCitationData.id })
    });
};

window.signCitation = function() {
    if (!currentCitationData) return;
    const canvas = document.getElementById('cit-signature-canvas');
    if (!canvas || !citationSignatureDrawn) return;

    const signature = canvas.toDataURL('image/png');
    fetch(`https://${GetParentResourceName()}/signCitation`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            citationId: currentCitationData.id,
            signature: signature
        })
    });
};

window.payCitation = function() {
    if (!currentCitationData) return;
    fetch(`https://${GetParentResourceName()}/payCitation`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            citationId: currentCitationData.id,
            amount: currentCitationData.amount,
            officerSource: currentCitationData.officerSource
        })
    });
};

window.declineCitation = function() {
    if (!currentCitationData) return;
    
    fetch(`https://${GetParentResourceName()}/declineCitation`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            citationId: currentCitationData.id,
            amount: currentCitationData.amount,
            officerSource: currentCitationData.officerSource
        })
    });
};

window.closeCitation = function() {
    const container = document.getElementById('citation-container');
    if (container) container.classList.remove('visible');
    const citationId = currentCitationData && currentCitationData.id;
    currentCitationData = null;
    fetch(`https://${GetParentResourceName()}/closeCitation`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ citationId: citationId })
    });
};

window.closeCitationForce = function() {
    const container = document.getElementById('citation-container');
    if (container) container.classList.remove('visible');
    currentCitationData = null;
};

function openGarage(data) {
    currentGarageData = data;
    garageVehicles = data.vehicles || [];
    garageView.style.display = 'flex';
    garageView.classList.remove('hidden');
    garageDeptName.innerText = data.deptName;
    
    // Automatically use the first spawn point for now, or we could add a logic to find the free one
    currentGarageData.spawnPoint = data.spawnPoints && data.spawnPoints[0];
    
    renderGarageVehicles(garageVehicles);
}

function renderGarageVehicles(vehicles) {
    garageVehiclesList.innerHTML = '';
    if (vehicleCountStat) vehicleCountStat.innerText = `${vehicles.length} UNITS`;

    vehicles.forEach(veh => {
        const card = document.createElement('div');
        card.className = 'minimal-vehicle-card';
        
        const subtext = veh.isImpounded ? `OWNER: ${veh.owner}` : `CHASSIS: ${veh.model.toUpperCase()}`;
        const reasonText = veh.isImpounded ? `<div style="font-size: 10px; color: rgba(255,255,255,0.4); margin-top: 2px;">REASON: ${veh.seizureReason || 'N/A'}</div>` : '';
        const feeText = veh.isImpounded && veh.seizurePrice > 0 ? `<div style="color: #ff9500; font-size: 10px; margin-top: 4px; font-weight: bold;">RETRIEVAL FEE: $${veh.seizurePrice}</div>` : '';
        
        card.innerHTML = `
            <div class="vehicle-main-info">
                <span class="vehicle-label-text">${veh.label}</span>
                <span class="vehicle-model-text">${subtext}</span>
                ${reasonText}
                ${feeText}
            </div>
            <div class="vehicle-action-area">
                <div class="vehicle-status-minimal">${veh.isImpounded ? 'IMPOUNDED' : 'READY'}</div>
                <div class="spawn-icon-btn">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>
        `;
        
        card.onclick = () => {
            spawnVehicle(veh);
        };
        
        garageVehiclesList.appendChild(card);
    });
}

if (garageSearchInput) {
    garageSearchInput.addEventListener('input', (e) => {
        const search = e.target.value.toLowerCase();
        const filtered = garageVehicles.filter(v => 
            v.label.toLowerCase().includes(search) || 
            v.model.toLowerCase().includes(search) ||
            (v.owner && v.owner.toLowerCase().includes(search)) ||
            (v.plate && v.plate.toLowerCase().includes(search))
        );
        renderGarageVehicles(filtered);
    });
}

if (document.getElementById('close-garage-btn-minimal')) {
    document.getElementById('close-garage-btn-minimal').onclick = closeGarage;
}
window.closeGarage = closeGarage;

function spawnVehicle(vehData) {
    // Find a free spawn point from the list
    fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            model: vehData.model,
            plate: vehData.plate,
            props: vehData.props,
            livery: vehData.livery ?? null,
            isImpounded: vehData.isImpounded,
            spawnPoints: currentGarageData.spawnPoints // Pass ALL points to find a free one
        })
    });
    closeGarage();
}

function closeGarage() {
    garageView.style.display = 'none';
    garageView.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST'
    });
}

let saveTimer = null;
function saveData(immediate = false) {
    if (saveTimer) clearTimeout(saveTimer);
    
    const performSave = () => {
        const data = { ...currentFullData, nodes, links: connections, pan };
        fetch(`https://${GetParentResourceName()}/save`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        saveTimer = null;
    };

    if (immediate) {
        performSave();
    } else {
        saveTimer = setTimeout(performSave, 100);
    }
}

let currentFullData = {};

function loadData(data) {
    currentFullData = data || {};
    rankFrameworkSyncJobByNode = {};
    if (!data) {
        nodes = [];
        connections = [];
        pan = { x: 0, y: 0 };
    } else {
        nodes = data.nodes || [];
        connections = data.links || [];
        pan = data.pan || { x: 0, y: 0 };

        // Backward compatibility:
        // older builds stored single-point node coords in coordsList[<type>].
        nodes.forEach(node => {
            if (!node || node.type === 'location' || node.type === 'vehicle' || node.type === 'helipad' || node.type === 'camera' || node.type === 'k9') {
                return;
            }

            const legacyCoords = node.coordsList && node.coordsList[node.type];
            if (!node.coords && legacyCoords) {
                node.coords = legacyCoords;
            }

            if ((node.interactionType === undefined || node.interactionType === null) && node.interactionTypes && node.interactionTypes[node.type]) {
                node.interactionType = node.interactionTypes[node.type];
            }
        });
    }
    
    zoom = 1.0;
    
    // Reset member selection UI on load
    selectedPlayer = null;
    if (selectedPlayerInfo) selectedPlayerInfo.style.display = 'flex';
    if (memberEditor) {
        memberEditor.classList.add('hidden');
        memberEditor.style.display = 'none';
    }
    
    updateCanvasTransform();
    renderCanvas();
}

function updateCanvasTransform() {
    if (canvasContent) {
        canvasContent.style.transform = `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`;
    }
    if (gridLayer) {
        gridLayer.style.transform = `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`;
    }
}

function renderCanvas() {
    canvasContent.querySelectorAll('.node').forEach(n => n.remove());
    nodes.forEach(node => createNodeElement(node));
    drawConnections();
}

function createNodeElement(node) {
    const el = document.createElement('div');
    el.className = 'node';
    el.id = `node-${node.id}`;
    el.style.left = `${node.x}px`;
    el.style.top = `${node.y}px`;
    
    let icon = 'building';
    if (node.type === 'rank') icon = 'id-badge';
    else if (node.type === 'permission') icon = 'key';
    else if (node.type === 'location') icon = 'map-marker-alt';
    else if (node.type === 'wardrobe') icon = 'tshirt';
    else if (node.type === 'boss_menu') icon = 'briefcase';
    else if (node.type === 'vehicle') icon = 'car-side';
    else if (node.type === 'helipad') icon = 'helicopter';
    else if (node.type === 'armory') icon = 'gun';
    else if (node.type === 'door') icon = 'door-open';
    else if (node.type === 'camera') icon = 'video';
    else if (node.type === 'evidence') icon = 'desktop';
    else if (node.type === 'form_computer') icon = 'file-signature';
    else if (node.type === 'mdt_dispatch') icon = 'tower-broadcast';
    else if (node.type === 'ai_police_npc') icon = 'robot';
    
    let extraInfo = '';
    if (node.type === 'rank') {
        if (node.ranks && node.ranks.length > 0) {
            extraInfo = `<div class="node-info">${node.ranks.length} ${window.T('ranks_configured')}</div>`;
        } else {
            extraInfo = `<div class="node-info">LVL ${node.level} | $${node.payment}</div>`;
        }
    } else if (node.type === 'permission') {
        extraInfo = `<div class="node-info">${window.T('perms_configured')}</div>`;
    } else if (node.type === 'boss_menu') {
        const hasCoords = !!node.coords;
        extraInfo = `<div class="node-info">${hasCoords ? window.T('location_set') : window.T('no_location')}</div>`;
    } else if (node.type === 'location') {
        const count = Object.keys(node.coordsList || {}).length;
        extraInfo = `<div class="node-info">${count} ${window.T('locations_set')}</div>`;
    } else if (node.type === 'wardrobe') {
        const hasCoords = !!node.coords;
        const outfitCount = Object.keys(node.outfits || {}).length;
        extraInfo = `<div class="node-info">${hasCoords ? window.T('location_set') : window.T('no_location')} | ${outfitCount} ${window.T('outfits')}</div>`;
    } else if (node.type === 'vehicle' || node.type === 'helipad') {
        const count = Object.keys(node.coordsList || {}).length;
        const vehCount = (node.vehicles || []).length;
        extraInfo = `<div class="node-info">${count} ${window.T('points')} | ${vehCount} ${node.type === 'helipad' ? window.T('aircraft') : window.T('vehicles')}</div>`;
    } else if (node.type === 'armory') {
        const hasCoords = !!node.coords;
        const weaponCount = (node.weapons || []).length;
        extraInfo = `<div class="node-info">${hasCoords ? window.T('location_set') : window.T('no_location')} | ${weaponCount} ${window.T('weapons')}</div>`;
    } else if (node.type === 'door') {
        const count = (node.doors || []).length;
        extraInfo = `<div class="node-info">${count} ${window.T('doors_configured')}</div>`;
    } else if (node.type === 'camera') {
        const count = (node.cameras || []).length;
        extraInfo = `<div class="node-info">${count} ${window.T('cameras_configured')}</div>`;
    } else if (node.type === 'evidence') {
        const hasCoords = !!node.coords;
        extraInfo = `<div class="node-info">${hasCoords ? window.T('location_set') : window.T('no_location')}</div>`;
    } else if (node.type === 'form_computer') {
        const hasCoords = !!node.coords;
        extraInfo = `<div class="node-info">${hasCoords ? window.T('location_set') : window.T('no_location')}</div>`;
    } else if (node.type === 'mdt_dispatch') {
        const hasCoords = !!node.coords;
        extraInfo = `<div class="node-info">${hasCoords ? window.T('location_set') : window.T('no_location')}</div>`;
    } else if (node.type === 'ai_police_npc') {
        const hasCoords = !!node.coords;
        const knowledgeCount = ((node.knowledge || '').trim().split(/\s+/).filter(Boolean)).length;
        extraInfo = `<div class="node-info">${hasCoords ? window.T('location_set') : window.T('no_location')} | ${knowledgeCount} ${window.T('words')}</div>`;
    }

    const headerType = (node.type === 'boss_menu' || node.type === 'form_computer' || node.type === 'mdt_dispatch' || node.type === 'ai_police_npc') ? window.T(node.type) : window.T(node.type).toUpperCase();

    el.innerHTML = `
        <div class="node-header"><i class="fas fa-${icon}"></i> ${headerType}</div>
        <div class="node-content">
            <div class="node-label">${node.label}</div>
            ${extraInfo}
        </div>
        ${(node.type !== 'permission' && node.type !== 'vehicle' && node.type !== 'helipad' && node.type !== 'door' && node.type !== 'armory' && node.type !== 'boss_menu' && node.type !== 'form_computer' && node.type !== 'mdt_dispatch' && node.type !== 'ai_police_npc' && node.type !== 'k9') ? '<div class="port port-out" data-id="'+node.id+'"></div>' : ''}
        ${node.type !== 'department' ? '<div class="port port-in" data-id="'+node.id+'"></div>' : ''}
    `;

    applyTranslations(el);

    // Add right-click to disconnect ports
    el.querySelectorAll('.port').forEach(port => {
        port.addEventListener('contextmenu', (e) => {
            e.preventDefault();
            e.stopPropagation();
            const portId = port.dataset.id;
            const isOut = port.classList.contains('port-out');
            
            if (isOut) {
                connections = connections.filter(c => c.from !== portId);
            } else {
                connections = connections.filter(c => c.to !== portId);
            }
            
            drawConnections();
        });
    });

    el.addEventListener('mousedown', (e) => {
        if (e.target.classList.contains('port')) return;
        e.stopPropagation();
        selectNode(node);
        isDragging = true;
        dragTarget = el;
        
        // Calculate offset in canvas space, accounting for resolution scaling
        const rect = canvas.getBoundingClientRect();
        offset.x = (e.clientX / window.resolutionScale - rect.left / window.resolutionScale - pan.x) / zoom - node.x;
        offset.y = (e.clientY / window.resolutionScale - rect.top / window.resolutionScale - pan.y) / zoom - node.y;
    });

    canvasContent.appendChild(el);
}

function selectNode(node) {
    selectedNode = node;
    document.querySelectorAll('.node').forEach(n => n.classList.remove('selected'));
    const nodeEl = document.getElementById(`node-${node.id}`);
    if (nodeEl) nodeEl.classList.add('selected');
    
    if (inspector) inspector.classList.remove('hidden');
    renderInspector();
    if (node && node.type === 'rank') {
        syncRankNodeFromFramework(node, false);
    }
}

function findLinkedDepartmentNode(nodeId) {
    const node = nodes.find(n => n.id === nodeId);
    if (node && node.type === 'department') return node;

    for (const c of connections) {
        if (c.to === nodeId) {
            const n = nodes.find(n => n.id === c.from && n.type === 'department');
            if (n) return n;
        }
        if (c.from === nodeId) {
            const n = nodes.find(n => n.id === c.to && n.type === 'department');
            if (n) return n;
        }
    }

    return null;
}

function getLinkedRankNodesForDepartment(deptId) {
    const linked = [];
    for (const c of connections) {
        if (c.from === deptId) {
            const n = nodes.find(n => n.id === c.to && n.type === 'rank');
            if (n) linked.push(n);
        } else if (c.to === deptId) {
            const n = nodes.find(n => n.id === c.from && n.type === 'rank');
            if (n) linked.push(n);
        }
    }
    return linked;
}

function getFrameworkJobForRankNode(rankNode) {
    const deptNode = findLinkedDepartmentNode(rankNode.id);
    if (deptNode && deptNode.frameworkJob && String(deptNode.frameworkJob).trim() !== '') {
        return String(deptNode.frameworkJob).trim().toLowerCase();
    }
    return 'police';
}

async function fetchFrameworkRanks(jobName) {
    try {
        const res = await fetch(`https://${GetParentResourceName()}/getFrameworkRanks`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ jobName: jobName || 'police' })
        });
        if (!res || !res.ok) return null;
        return await res.json();
    } catch (_) {
        return null;
    }
}

async function syncRankNodeFromFramework(rankNode, force = false) {
    if (!rankNode || rankNode.type !== 'rank') return;

    const frameworkJob = getFrameworkJobForRankNode(rankNode);
    const lastSyncedJob = rankFrameworkSyncJobByNode[rankNode.id];
    if (!force && lastSyncedJob === frameworkJob && Array.isArray(rankNode.ranks) && rankNode.ranks.length > 0) {
        return;
    }

    const payload = await fetchFrameworkRanks(frameworkJob);
    if (!payload || !Array.isArray(payload.ranks) || payload.ranks.length === 0) return;

    const previousBossByLevel = {};
    if (Array.isArray(rankNode.ranks)) {
        rankNode.ranks.forEach(r => {
            if (r && r.bossMenu) previousBossByLevel[Number(r.level) || 0] = true;
        });
    }

    const newRanks = payload.ranks.map(r => ({
        name: r.name || `Rank ${Number(r.level) || 0}`,
        level: Number(r.level) || 0,
        pay: Number(r.pay) || 0,
        bossMenu: !!previousBossByLevel[Number(r.level) || 0]
    })).sort((a, b) => a.level - b.level);

    if (!newRanks.some(r => r.bossMenu) && newRanks.length > 0) {
        newRanks[newRanks.length - 1].bossMenu = true;
    }

    rankNode.ranks = newRanks;
    rankFrameworkSyncJobByNode[rankNode.id] = frameworkJob;

    renderCanvas();
    refreshLinkedPermissionNodes(rankNode.id);
    if (selectedNode && selectedNode.id === rankNode.id) {
        renderInspector();
    }
    saveData();
}

function renderInspector() {
    if (!selectedNode) return;
    
    inspectorContent.innerHTML = '';
    
    // Default Display Name field
    const fieldClone = cloneTemplate('tpl-field');
    const label = fieldClone.querySelector('label');
    label.setAttribute('data-translate', 'display_name');
    label.innerText = window.T('display_name');
    const input = fieldClone.querySelector('input');
    input.value = selectedNode.label;
    input.onchange = (e) => updateNode('label', e.target.value);
    inspectorContent.appendChild(fieldClone);

    if (selectedNode.type === 'department') {
        const deptClone = cloneTemplate('tpl-dept-node');
        
        // Framework Job Name
        const jobInput = deptClone.querySelector('input[type="text"]');
        jobInput.value = selectedNode.frameworkJob || '';
        jobInput.onchange = (e) => updateNode('frameworkJob', e.target.value);
        
        // Blip Name
        const blipInput = deptClone.querySelectorAll('input[type="text"]')[1];
        blipInput.value = selectedNode.blipName || selectedNode.label;
        blipInput.onchange = (e) => updateNode('blipName', e.target.value);
        
        // Icon Select
        const blipGrid = deptClone.querySelector('.blip-grid');
        [60, 58, 61, 526, 487, 175, 525, 429, 410, 408, 188, 570].forEach(id => {
            const item = document.createElement('div');
            item.className = `blip-item ${selectedNode.blipId === id ? 'active' : ''}`;
            item.onclick = () => updateNode('blipId', id);
            item.innerHTML = `<img src="img/${id}.png" onerror="this.src='img/fallback.webp'">`;
            blipGrid.appendChild(item);
        });
        
        // Color Palette
        const colorGrid = deptClone.querySelector('.color-grid');
        [3, 38, 5, 2, 1, 18, 17, 21, 25, 29, 31, 35].forEach(color => {
            const item = document.createElement('div');
            item.className = `color-item blip-color-${color} ${selectedNode.blipColor === color ? 'active' : ''}`;
            item.style.backgroundColor = getBlipHex(color);
            item.onclick = () => updateNode('blipColor', color);
            colorGrid.appendChild(item);
        });

        // Officer Blip Color
        const officerColorGrid = deptClone.querySelector('.officer-color-grid');
        [3, 38, 5, 2, 1, 18, 17, 21, 25, 29, 31, 35].forEach(color => {
            const item = document.createElement('div');
            item.className = `color-item blip-color-${color} ${selectedNode.officerBlipColor === color ? 'active' : ''}`;
            item.style.backgroundColor = getBlipHex(color);
            item.onclick = () => updateNode('officerBlipColor', color);
            officerColorGrid.appendChild(item);
        });
        
        // Location (Vector3)
        const coordsClone = cloneTemplate('tpl-field-coords');
        const coordsInput = coordsClone.querySelector('input');
        coordsInput.value = selectedNode.coords ? `${selectedNode.coords.x.toFixed(2)}, ${selectedNode.coords.y.toFixed(2)}, ${selectedNode.coords.z.toFixed(2)}${selectedNode.coords.h ? `, H: ${selectedNode.coords.h.toFixed(1)}` : ''}` : '0, 0, 0';
        coordsClone.querySelector('button').onclick = () => pickLocation();
        deptClone.appendChild(coordsClone);
        
        inspectorContent.appendChild(deptClone);
    }

    if (selectedNode.type === 'rank') {
        const rankClone = cloneTemplate('tpl-rank-node');
        const rankRows = rankClone.querySelector('.rank-rows');
        
        if (selectedNode.ranks) {
            selectedNode.ranks.forEach((rank, index) => {
                const row = document.createElement('div');
                row.className = 'rank-row-editable';
                row.innerHTML = `
                    <div class="field field-name">
                        <input type="text" value="${rank.name}" placeholder="Name" onchange="updateRank(${index}, 'name', this.value)">
                    </div>
                    <div class="field field-level">
                        <input type="number" value="${rank.level}" placeholder="LVL" onchange="updateRank(${index}, 'level', parseInt(this.value))">
                    </div>
                    <div class="field field-pay">
                        <input type="number" value="${rank.pay}" placeholder="Pay" onchange="updateRank(${index}, 'pay', parseInt(this.value))">
                    </div>
                    <button class="delete-rank-btn"><i class="fas fa-times"></i></button>
                `;
                row.querySelector('.delete-rank-btn').onclick = () => deleteRank(index);
                rankRows.appendChild(row);
            });
            
            rankClone.querySelector('.add-preset-btn').onclick = () => addRankToList();
            
            // Boss Menu Permissions
            const flagsContainer = rankClone.querySelector('.rank-boss-flags');
            selectedNode.ranks.forEach((rank, index) => {
                const flag = document.createElement('div');
                flag.className = `flag-item ${rank.bossMenu ? 'active' : ''}`;
                flag.style.cssText = "background: rgba(255,255,255,0.02); padding: 10px; border-radius: 6px; justify-content: space-between;";
                flag.onclick = () => toggleRankBossMenu(index);
                flag.innerHTML = `
                    <div class="flag-label" style="font-weight: bold; color: #fff;">${rank.name || 'Rank ' + index}</div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <span style="font-size: 9px; color: var(--text-dim);" data-translate="boss_access">BOSS ACCESS</span>
                        <div class="checkbox-custom">${rank.bossMenu ? 'X' : ''}</div>
                    </div>
                `;
                applyTranslations(flag);
                flagsContainer.appendChild(flag);
            });
        }
        inspectorContent.appendChild(rankClone);
    }

    if (selectedNode.type === 'permission') {
        const linkedRank = findLinkedRankNode(selectedNode.id);
        const permClone = cloneTemplate('tpl-permission-node');
        const itemsContainer = permClone.querySelector('.perm-rank-items');
        
        if (!linkedRank) {
            itemsContainer.innerHTML = `<div class="info-box" data-translate="link_rank_warning">Link a Rank node to this node to manage permissions.</div>`;
            applyTranslations(itemsContainer);
        } else if (linkedRank.ranks && linkedRank.ranks.length > 0) {
            const permsList = ['Duty', 'Garage', 'Armory', 'Vault', 'Stash'];
            if (!selectedNode.rankPerms || Array.isArray(selectedNode.rankPerms)) selectedNode.rankPerms = {};

            linkedRank.ranks.forEach((rank) => {
                const rankKey = `rank_${rank.level}`; 
                if (!selectedNode.rankPerms[rankKey] || Array.isArray(selectedNode.rankPerms[rankKey])) selectedNode.rankPerms[rankKey] = {};
                
                const item = document.createElement('div');
                item.className = 'perm-rank-item';
                item.innerHTML = `
                    <div class="perm-rank-name">${rank.name}</div>
                    <div class="behavior-flags"></div>
                `;
                
                const flags = item.querySelector('.behavior-flags');
                permsList.forEach(perm => {
                    const isActive = selectedNode.rankPerms[rankKey][perm];
                    const flag = document.createElement('div');
                    flag.className = `flag-item ${isActive ? 'active' : ''}`;
                    flag.onclick = () => togglePermission(rankKey, perm);
                    flag.innerHTML = `
                        <div class="checkbox-custom">${isActive ? 'X' : ''}</div>
                        <div class="flag-label">${perm}</div>
                    `;
                    flags.appendChild(flag);
                });
                itemsContainer.appendChild(item);
            });
        } else {
            itemsContainer.innerHTML = `<div class="info-box" data-translate="no_ranks_warning">No ranks found in linked Rank node.</div>`;
            applyTranslations(itemsContainer);
        }
        inspectorContent.appendChild(permClone);
    }

    if (selectedNode.type === 'wardrobe') {
        const wardrobeClone = cloneTemplate('tpl-wardrobe-node');
        const interactionType = selectedNode.interactionType || 'zone';
        const currentPed = selectedNode.pedType || 'police';
        
        const locField = wardrobeClone.querySelector('.loc-field');
        const coordStr = selectedNode.coords ? `${selectedNode.coords.x.toFixed(1)}, ${selectedNode.coords.y.toFixed(1)}, ${selectedNode.coords.z.toFixed(1)}` : window.T('no_location');
        locField.querySelector('input').value = coordStr;
        
        locField.querySelector('.btn-zone').onclick = () => pickLocation();
        const btnPed = locField.querySelector('.btn-ped');
        btnPed.className = `pick-btn-small btn-ped ${interactionType === 'ped' ? 'active' : ''}`;
        btnPed.onclick = () => pickLocation(null, null, 'ped');
        
        const pedSelector = wardrobeClone.querySelector('.ped-type-selector');
        if (interactionType === 'ped') {
            pedSelector.classList.remove('hidden');
            const pedBtns = pedSelector.querySelector('.ped-btns');
            ['police', 'sheriff', 'fib'].forEach(type => {
                const btn = document.createElement('div');
                btn.className = `ped-type-btn ${currentPed === type ? 'active' : ''}`;
                btn.style.cssText = `flex: 1; text-align: center; font-size: 9px; padding: 4px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 4px; cursor: pointer; color: ${currentPed === type ? 'var(--accent)' : 'var(--text-dim)'}; ${currentPed === type ? 'border-color: var(--accent); background: var(--accent-dim);' : ''}`;
                btn.innerText = type.toUpperCase();
                btn.onclick = () => updateNodePedType(type);
                pedBtns.appendChild(btn);
            });
        }

        const linkedRank = findLinkedRankNode(selectedNode.id);
        const outfitEditor = wardrobeClone.querySelector('.rank-outfit-editor');
        const groupsContainer = wardrobeClone.querySelector('.rank-outfit-groups');

        if (!linkedRank) {
            groupsContainer.innerHTML = `<div class="info-box" data-translate="link_rank_wardrobe_warning">Link a Rank node to this node to manage rank-specific outfits.</div>`;
            applyTranslations(groupsContainer);
        } else if (linkedRank.ranks && linkedRank.ranks.length > 0) {
            if (!selectedNode.outfits || Array.isArray(selectedNode.outfits)) selectedNode.outfits = {};
            
            linkedRank.ranks.forEach((rank) => {
                const rankKey = `rank_${rank.level}`;
                if (selectedNode.outfits[rankKey] && !Array.isArray(selectedNode.outfits[rankKey])) {
                    selectedNode.outfits[rankKey] = [selectedNode.outfits[rankKey]];
                }
                const outfits = selectedNode.outfits[rankKey] || [];
                
                const group = document.createElement('div');
                group.className = 'rank-outfit-group';
                group.style.cssText = "margin-bottom: 30px; border-left: 2px solid var(--accent); padding-left: 15px;";
                group.innerHTML = `
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                        <span style="font-weight: bold; color: #fff; font-size: 14px;">${rank.name} (LVL ${rank.level})</span>
                        <button class="pick-btn-small" title="${window.T('add_new_outfit')}">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                    <div class="outfits-container"></div>
                `;
                group.querySelector('button').onclick = () => addOutfitToRank(rankKey);
                
                const container = group.querySelector('.outfits-container');
                outfits.forEach((outfit, oIdx) => {
                    const item = document.createElement('div');
                    item.className = 'door-config-item';
                    item.style.cssText = "margin-bottom: 15px; padding: 15px; background: rgba(0,0,0,0.25); border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);";
                    item.innerHTML = `
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 10px;">
                            <input type="text" value="${outfit.label || 'Outfit ' + (oIdx + 1)}" 
                                   style="background:transparent; border:none; color:#fff; font-weight:bold; font-size:12px; padding:0; width:70%;">
                            <button class="delete-rank-btn"><i class="fas fa-trash"></i></button>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;" class="components-grid"></div>
                    `;
                    item.querySelector('input').onchange = (e) => updateOutfitLabel(rankKey, oIdx, e.target.value);
                    item.querySelector('.delete-rank-btn').onclick = () => deleteOutfitFromRank(rankKey, oIdx);
                    
                    const componentsGrid = item.querySelector('.components-grid');
                    const components = [
                        { id: 'shirt', label: 'shirt', component: 11 },
                        { id: 'pants', label: 'pants', component: 4 },
                        { id: 'shoes', label: 'shoes', component: 6 },
                        { id: 'vest', label: 'vest', component: 9 },
                        { id: 'bags', label: 'bags', component: 5 },
                        { id: 'mask', label: 'mask', component: 1 },
                        { id: 'arms', label: 'arms', component: 3 },
                        { id: 'undershirt', label: 'undershirt', component: 8 },
                        { id: 'decals', label: 'decals', component: 10 },
                        { id: 'accessory', label: 'accessory', component: 7 },
                        { id: 'hair', label: 'hair', component: 2 }
                    ];

                    components.forEach(comp => {
                        const field = document.createElement('div');
                        field.className = 'field';
                        field.style.marginBottom = '0';
                        field.innerHTML = `
                            <label style="font-size: 9px; opacity: 0.7;" data-translate="${comp.label}">${window.T(comp.label)} (${comp.component})</label>
                            <div style="display: flex; gap: 4px;">
                                <input type="number" class="item-id" value="${outfit[comp.id]?.item || 0}" placeholder="ID" style="flex: 1.5; height: 28px; font-size: 11px;">
                                <input type="number" class="texture-id" value="${outfit[comp.id]?.texture || 0}" placeholder="Tex" style="flex: 1; height: 28px; font-size: 11px;">
                            </div>
                        `;
                        field.querySelector('.item-id').onchange = (e) => updateOutfit(rankKey, oIdx, comp.id, 'item', e.target.value);
                        field.querySelector('.texture-id').onchange = (e) => updateOutfit(rankKey, oIdx, comp.id, 'texture', e.target.value);
                        componentsGrid.appendChild(field);
                    });

                    const propsGrid = document.createElement('div');
                    propsGrid.style.cssText = "margin-top: 15px; padding-top: 10px; border-top: 1px solid rgba(255,255,255,0.05); display: grid; grid-template-columns: 1fr 1fr; gap: 15px;";
                    const props = [
                        { id: 'hat', label: 'hat', prop: 0 },
                        { id: 'glasses', label: 'glasses', prop: 1 },
                        { id: 'ears', label: 'ears', prop: 2 },
                        { id: 'watch', label: 'watch', prop: 6 },
                        { id: 'bracelet', label: 'bracelet', prop: 7 }
                    ];

                    props.forEach(prop => {
                        const field = document.createElement('div');
                        field.className = 'field';
                        field.style.marginBottom = '0';
                        field.innerHTML = `
                            <label style="font-size: 9px; opacity: 0.7;" data-translate="${prop.label}">${window.T(prop.label)} (Prop ${prop.prop})</label>
                            <div style="display: flex; gap: 4px;">
                                <input type="number" class="item-id" value="${outfit[prop.id]?.item || -1}" placeholder="ID" style="flex: 1.5; height: 28px; font-size: 11px;">
                                <input type="number" class="texture-id" value="${outfit[prop.id]?.texture || 0}" placeholder="Tex" style="flex: 1; height: 28px; font-size: 11px;">
                            </div>
                        `;
                        field.querySelector('.item-id').onchange = (e) => updateOutfit(rankKey, oIdx, prop.id, 'item', e.target.value);
                        field.querySelector('.texture-id').onchange = (e) => updateOutfit(rankKey, oIdx, prop.id, 'texture', e.target.value);
                        propsGrid.appendChild(field);
                    });
                    item.appendChild(propsGrid);
                    container.appendChild(item);
                });
                groupsContainer.appendChild(group);
            });
        }
        inspectorContent.appendChild(wardrobeClone);
    }

    if (selectedNode.type === 'location') {
        const locations = [
            { id: 'duty', label: 'DUTY TOGGLE', icon: 'user-shield' },
            { id: 'stash', label: 'STASH', icon: 'box-open' },
            { id: 'garage', label: 'GARAGE MENU', icon: 'car' },
            { id: 'helipad', label: 'HELIPAD MENU', icon: 'helicopter' },
            { id: 'armory', label: 'ARMORY MENU', icon: 'gun' },
            { id: 'impound', label: 'IMPOUND MENU', icon: 'truck-pickup' },
            { id: 'boss_menu', label: 'BOSS MENU', icon: 'briefcase' }
        ];

        const locClone = cloneTemplate('tpl-location-node');
        const currentGlobalPed = selectedNode.pedType || 'police';
        
        const pedGlobalBtns = locClone.querySelector('.ped-global-btns');
        ['police', 'sheriff', 'fib'].forEach(type => {
            const btn = document.createElement('div');
            btn.className = `ped-type-btn ${currentGlobalPed === type ? 'active' : ''}`;
            btn.style.cssText = `flex: 1; text-align: center; font-size: 10px; padding: 10px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 6px; cursor: pointer; color: ${currentGlobalPed === type ? '#fff' : 'var(--text-dim)'}; ${currentGlobalPed === type ? 'border-color: var(--accent); background: var(--accent-dim);' : ''}`;
            btn.innerText = type.toUpperCase();
            btn.onclick = () => updateNodePedType(type);
            pedGlobalBtns.appendChild(btn);
        });

        const listContainer = locClone.querySelector('.location-list');
        if (!selectedNode.coordsList || Array.isArray(selectedNode.coordsList)) selectedNode.coordsList = {};

        locations.forEach(loc => {
            const coords = selectedNode.coordsList[loc.id];
            const coordStr = coords ? `${coords.x.toFixed(1)}, ${coords.y.toFixed(1)}, ${coords.z.toFixed(1)}${coords.h ? ` | H: ${coords.h.toFixed(1)}` : ''}` : window.T('no_location');
            const interactionType = (selectedNode.interactionTypes && selectedNode.interactionTypes[loc.id]) || 'zone';
            
            const field = document.createElement('div');
            field.className = 'field';
            field.style.marginBottom = '20px';
            field.innerHTML = `
                <label>${loc.label} ${interactionType === 'ped' ? `<span style="color:var(--accent); font-size:9px;">(${window.T('ped').toUpperCase()})</span>` : ''}</label>
                <div class="input-with-btn">
                    <input type="text" value="${coordStr}" readonly style="font-size: 11px;">
                    <button class="pick-btn-small btn-zone" title="Set Zone Interaction">
                        <i class="fas fa-crosshairs"></i>
                    </button>
                    <button class="pick-btn-small btn-ped ${interactionType === 'ped' ? 'active' : ''}" title="Set Ped Interaction">
                        <i class="fas fa-user"></i>
                    </button>
                </div>
            `;
            field.querySelector('.btn-zone').onclick = () => pickLocation(loc.id);
            field.querySelector('.btn-ped').onclick = () => pickLocation(loc.id, null, 'ped');
            listContainer.appendChild(field);
        });

        // Link Status
        const linkInfoBox = locClone.querySelector('.link-info-box');
        const isLinkedToVehicle = connections.some(c => {
            return (c.from === selectedNode.id || c.to === selectedNode.id) && 
                   nodes.some(n => (n.id === (c.from === selectedNode.id ? c.to : c.from)) && (n.type === 'vehicle' || n.type === 'helipad' || n.type === 'armory'));
        });

        if (!isLinkedToVehicle) {
            linkInfoBox.style.cssText = "margin-top: 10px; border-color: #ff444444; color: #ff4444; background: rgba(255, 68, 68, 0.05);";
            linkInfoBox.innerHTML = `<i class="fas fa-exclamation-triangle"></i> ${window.T('link_vehicle_warning')}`;
        } else {
            linkInfoBox.style.cssText = "margin-top: 10px; border-color: var(--accent); color: var(--accent); background: var(--accent-dim);";
            linkInfoBox.innerHTML = `<i class="fas fa-check-circle"></i> ${window.T('node_linked')}`;
        }
        
        inspectorContent.appendChild(locClone);
    }

    if (selectedNode.type === 'camera') {
        const camClone = cloneTemplate('tpl-camera-node');
        const listContainer = camClone.querySelector('.camera-list');
        if (!selectedNode.cameras) selectedNode.cameras = [];
        
        selectedNode.cameras.forEach((cam, index) => {
            const coordStr = cam.coords ? `${cam.coords.x.toFixed(1)}, ${cam.coords.y.toFixed(1)}, ${cam.coords.z.toFixed(1)}` : window.T('no_location');
            const item = document.createElement('div');
            item.className = 'door-config-item';
            item.style.cssText = "margin-bottom: 20px; padding: 12px; background: rgba(0,0,0,0.2); border-radius: 8px; border: 1px solid rgba(255,255,255,0.03);";
            item.innerHTML = `
                <div class="field" style="margin-bottom: 10px;">
                    <label style="font-size: 9px;" data-translate="camera_label">CAMERA LABEL</label>
                    <input type="text" class="cam-label" value="${cam.label || ''}" placeholder="Example: Front Entrance">
                </div>
                <div class="field" style="margin-bottom: 10px;">
                    <label style="font-size: 9px;" data-translate="location">LOCATION</label>
                    <div class="input-with-btn">
                        <input type="text" value="${coordStr}" readonly style="font-size: 11px;">
                        <button class="pick-btn-small btn-pick"><i class="fas fa-crosshairs"></i></button>
                    </div>
                </div>
                <div class="field" style="margin-bottom: 0;">
                    <label style="font-size: 9px;" data-translate="heading">HEADING</label>
                    <div class="input-with-btn">
                        <input type="number" class="cam-heading" step="0.1" value="${cam.coords ? (cam.coords.h || 0.0).toFixed(1) : '0.0'}">
                        <button class="delete-rank-btn" style="margin-left: 8px; width: 38px; height: 38px;"><i class="fas fa-trash"></i></button>
                    </div>
                </div>
            `;
            item.querySelector('.cam-label').onchange = (e) => updateCameraNodeInfo(index, 'label', e.target.value);
            item.querySelector('.cam-heading').onchange = (e) => updateCameraNodeInfo(index, 'heading', parseFloat(e.target.value));
            item.querySelector('.btn-pick').onclick = () => pickLocation('camera', index);
            item.querySelector('.delete-rank-btn').onclick = () => deleteCameraFromNode(index);
            applyTranslations(item);
            listContainer.appendChild(item);
        });

        camClone.querySelector('.add-camera-btn').onclick = () => addCameraToNode();
        inspectorContent.appendChild(camClone);
    }

    if (selectedNode.type === 'evidence') {
        const pedClone = cloneTemplate('tpl-ped-interaction-node');
        const interactionType = selectedNode.interactionType || 'zone';
        const currentPed = selectedNode.pedType || 'police';
        
        const label = pedClone.querySelector('.loc-label');
        label.setAttribute('data-translate', 'analysis_pc_location');
        label.innerText = window.T('analysis_pc_location');
        if (interactionType === 'ped') {
            label.innerHTML += ` <span style="color:var(--accent); font-size:9px;">(${window.T('ped').toUpperCase()})</span>`;
        }

        const coordStr = selectedNode.coords ? `${selectedNode.coords.x.toFixed(1)}, ${selectedNode.coords.y.toFixed(1)}, ${selectedNode.coords.z.toFixed(1)}` : window.T('no_location');
        pedClone.querySelector('input').value = coordStr;
        
        pedClone.querySelector('.btn-zone').onclick = () => pickLocation();
        const btnPed = pedClone.querySelector('.btn-ped');
        btnPed.className = `pick-btn-small btn-ped ${interactionType === 'ped' ? 'active' : ''}`;
        btnPed.onclick = () => pickLocation(null, null, 'ped');
        
        if (interactionType === 'ped') {
            const pedSelector = pedClone.querySelector('.ped-type-selector');
            pedSelector.classList.remove('hidden');
            const pedBtns = pedSelector.querySelector('.ped-btns');
            ['police', 'sheriff', 'fib'].forEach(type => {
                const btn = document.createElement('div');
                btn.className = `ped-type-btn ${currentPed === type ? 'active' : ''}`;
                btn.style.cssText = `flex: 1; text-align: center; font-size: 9px; padding: 4px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 4px; cursor: pointer; color: ${currentPed === type ? 'var(--accent)' : 'var(--text-dim)'}; ${currentPed === type ? 'border-color: var(--accent); background: var(--accent-dim);' : ''}`;
                btn.innerText = type.toUpperCase();
                btn.onclick = () => updateNodePedType(type);
                pedBtns.appendChild(btn);
            });
        }
        inspectorContent.appendChild(pedClone);
    }

    if (selectedNode.type === 'armory') {
        const armoryContainer = document.createElement('div');
        const extra = document.createElement('div');
        armoryContainer.appendChild(extra);
        if (!selectedNode.weapons) selectedNode.weapons = [];
        if (!selectedNode.items) selectedNode.items = [];

        // Weapons
        const weaponsHeader = document.createElement('label');
        weaponsHeader.style.cssText = "font-size: 10px; color: var(--text-dim); text-transform: uppercase; display: block; margin-top: 25px; margin-bottom: 10px;";
        weaponsHeader.setAttribute('data-translate', 'armory_weapons');
        weaponsHeader.innerText = window.T('armory_weapons');
        extra.appendChild(weaponsHeader);

        selectedNode.weapons.forEach((weapon, index) => {
            const item = document.createElement('div');
            item.className = 'door-config-item';
            item.style.cssText = "margin-bottom: 20px; padding: 12px; background: rgba(0,0,0,0.2); border-radius: 8px; border: 1px solid rgba(255,255,255,0.03);";
            item.innerHTML = `
                <div class="field" style="margin-bottom: 10px;">
                    <label style="font-size: 9px;" data-translate="weapon_label">WEAPON LABEL</label>
                    <input type="text" class="w-label" value="${weapon.label}" placeholder="Example: Pistol">
                </div>
                <div class="field" style="margin-bottom: 10px;">
                    <label style="font-size: 9px;" data-translate="spawn_code">ITEM NAME / SPAWN CODE</label>
                    <div class="input-with-btn">
                        <input type="text" class="w-model" value="${weapon.model}" placeholder="Example: weapon_pistol">
                        <button class="delete-rank-btn" style="margin-left: 8px; width: 38px; height: 38px;"><i class="fas fa-trash"></i></button>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 10px;">
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 9px;" data-translate="min_grade">MIN GRADE</label>
                        <input type="number" class="w-grade" value="${weapon.minGrade || 0}" min="0">
                    </div>
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 9px;" data-translate="armory_limit">LIMIT (0=UNL)</label>
                        <input type="number" class="w-limit" value="${weapon.limit || 0}" min="0">
                    </div>
                </div>
            `;
            item.querySelector('.w-label').onchange = (e) => updateWeaponInfo(index, 'label', e.target.value);
            item.querySelector('.w-model').onchange = (e) => updateWeaponInfo(index, 'model', e.target.value);
            item.querySelector('.w-grade').onchange = (e) => updateWeaponInfo(index, 'minGrade', parseInt(e.target.value));
            item.querySelector('.w-limit').onchange = (e) => updateWeaponInfo(index, 'limit', parseInt(e.target.value));
            item.querySelector('.delete-rank-btn').onclick = () => deleteWeaponFromArmory(index);
            applyTranslations(item);
            extra.appendChild(item);
        });

        const addWeaponBtn = document.createElement('div');
        addWeaponBtn.className = 'add-preset-btn';
        addWeaponBtn.style.marginTop = '10px';
        addWeaponBtn.innerHTML = `<i class="fas fa-plus"></i> <span data-translate="add_new_weapon">${window.T('add_new_weapon')}</span>`;
        addWeaponBtn.onclick = () => addWeaponToArmory();
        extra.appendChild(addWeaponBtn);

        // Items
        const itemsHeader = document.createElement('label');
        itemsHeader.style.cssText = "font-size: 10px; color: var(--text-dim); text-transform: uppercase; display: block; margin-top: 25px; margin-bottom: 10px;";
        itemsHeader.setAttribute('data-translate', 'armory_items');
        itemsHeader.innerText = window.T('armory_items');
        extra.appendChild(itemsHeader);

        selectedNode.items.forEach((item, index) => {
            const div = document.createElement('div');
            div.className = 'door-config-item';
            div.style.cssText = "margin-bottom: 20px; padding: 12px; background: rgba(0,0,0,0.2); border-radius: 8px; border: 1px solid rgba(255,255,255,0.03);";
            div.innerHTML = `
                <div class="field" style="margin-bottom: 10px;">
                    <label style="font-size: 9px;" data-translate="item_label">ITEM LABEL</label>
                    <input type="text" class="i-label" value="${item.label}" placeholder="Example: Radio">
                </div>
                <div class="field" style="margin-bottom: 10px;">
                    <label style="font-size: 9px;" data-translate="spawn_code">ITEM NAME / SPAWN CODE</label>
                    <div class="input-with-btn">
                        <input type="text" class="i-model" value="${item.model}" placeholder="Example: radio">
                        <button class="delete-rank-btn" style="margin-left: 8px; width: 38px; height: 38px;"><i class="fas fa-trash"></i></button>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 10px;">
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 9px;" data-translate="min_grade">MIN GRADE</label>
                        <input type="number" class="i-grade" value="${item.minGrade || 0}" min="0">
                    </div>
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 9px;" data-translate="armory_limit">LIMIT (0=UNL)</label>
                        <input type="number" class="i-limit" value="${item.limit || 0}" min="0">
                    </div>
                </div>
            `;
            div.querySelector('.i-label').onchange = (e) => updateItemInfo(index, 'label', e.target.value);
            div.querySelector('.i-model').onchange = (e) => updateItemInfo(index, 'model', e.target.value);
            div.querySelector('.i-grade').onchange = (e) => updateItemInfo(index, 'minGrade', parseInt(e.target.value));
            div.querySelector('.i-limit').onchange = (e) => updateItemInfo(index, 'limit', parseInt(e.target.value));
            div.querySelector('.delete-rank-btn').onclick = () => deleteItemFromArmory(index);
            applyTranslations(div);
            extra.appendChild(div);
        });

        const addItemBtn = document.createElement('div');
        addItemBtn.className = 'add-preset-btn';
        addItemBtn.style.marginTop = '10px';
        addItemBtn.innerHTML = `<i class="fas fa-plus"></i> <span data-translate="add_new_item">${window.T('add_new_item')}</span>`;
        addItemBtn.onclick = () => addItemToArmory();
        extra.appendChild(addItemBtn);

        inspectorContent.appendChild(armoryContainer);
    }

    if (selectedNode.type === 'boss_menu') {
        const pedClone = cloneTemplate('tpl-ped-interaction-node');
        const interactionType = selectedNode.interactionType || 'zone';
        const currentPed = selectedNode.pedType || 'police';
        
        const label = pedClone.querySelector('.loc-label');
        label.setAttribute('data-translate', 'boss_menu_location');
        label.innerText = window.T('boss_menu_location');
        if (interactionType === 'ped') {
            label.innerHTML += ` <span style="color:var(--accent); font-size:9px;">(${window.T('ped').toUpperCase()})</span>`;
        }

        const coordStr = selectedNode.coords ? `${selectedNode.coords.x.toFixed(1)}, ${selectedNode.coords.y.toFixed(1)}, ${selectedNode.coords.z.toFixed(1)}${selectedNode.coords.h !== undefined ? ` | H: ${selectedNode.coords.h.toFixed(1)}` : ''}` : window.T('no_location');
        pedClone.querySelector('input').value = coordStr;
        
        pedClone.querySelector('.btn-zone').onclick = () => pickLocation();
        const btnPed = pedClone.querySelector('.btn-ped');
        btnPed.className = `pick-btn-small btn-ped ${interactionType === 'ped' ? 'active' : ''}`;
        btnPed.onclick = () => pickLocation(null, null, 'ped');
        
        if (interactionType === 'ped') {
            const pedSelector = pedClone.querySelector('.ped-type-selector');
            pedSelector.classList.remove('hidden');
            const pedBtns = pedSelector.querySelector('.ped-btns');
            ['police', 'sheriff', 'fib'].forEach(type => {
                const btn = document.createElement('div');
                btn.className = `ped-type-btn ${currentPed === type ? 'active' : ''}`;
                btn.style.cssText = `flex: 1; text-align: center; font-size: 9px; padding: 4px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 4px; cursor: pointer; color: ${currentPed === type ? 'var(--accent)' : 'var(--text-dim)'}; ${currentPed === type ? 'border-color: var(--accent); background: var(--accent-dim);' : ''}`;
                btn.innerText = type.toUpperCase();
                btn.onclick = () => updateNodePedType(type);
                pedBtns.appendChild(btn);
            });
        }
        inspectorContent.appendChild(pedClone);
    }

    if (selectedNode.type === 'form_computer') {
        const pedClone = cloneTemplate('tpl-ped-interaction-node');
        const label = pedClone.querySelector('.loc-label');
        label.setAttribute('data-translate', 'form_computer_location');
        label.innerText = window.T('form_computer_location');

        const coordStr = selectedNode.coords ? `${selectedNode.coords.x.toFixed(1)}, ${selectedNode.coords.y.toFixed(1)}, ${selectedNode.coords.z.toFixed(1)}${selectedNode.coords.h !== undefined ? ` | H: ${selectedNode.coords.h.toFixed(1)}` : ''}` : window.T('no_location');
        pedClone.querySelector('input').value = coordStr;
        pedClone.querySelector('.btn-zone').onclick = () => pickLocation();
        const btnPed = pedClone.querySelector('.btn-ped');
        if (btnPed) btnPed.style.display = 'none';
        inspectorContent.appendChild(pedClone);
    }

    if (selectedNode.type === 'mdt_dispatch') {
        const pedClone = cloneTemplate('tpl-ped-interaction-node');
        const label = pedClone.querySelector('.loc-label');
        label.setAttribute('data-translate', 'mdt_dispatch_location');
        label.innerText = window.T('mdt_dispatch_location');

        const coordStr = selectedNode.coords ? `${selectedNode.coords.x.toFixed(1)}, ${selectedNode.coords.y.toFixed(1)}, ${selectedNode.coords.z.toFixed(1)}${selectedNode.coords.h ? ` | H: ${selectedNode.coords.h.toFixed(1)}` : ''}` : window.T('no_location');
        pedClone.querySelector('input').value = coordStr;
        pedClone.querySelector('.btn-zone').onclick = () => pickLocation();
        const btnPed = pedClone.querySelector('.btn-ped');
        if (btnPed) btnPed.style.display = 'none';
        inspectorContent.appendChild(pedClone);
    }

    if (selectedNode.type === 'ai_police_npc') {
        const pedClone = cloneTemplate('tpl-ped-interaction-node');
        const currentPed = selectedNode.pedType || 'police';
        const label = pedClone.querySelector('.loc-label');
        label.setAttribute('data-translate', 'ai_police_npc_location');
        label.innerText = window.T('ai_police_npc_location');

        const coordStr = selectedNode.coords ? `${selectedNode.coords.x.toFixed(1)}, ${selectedNode.coords.y.toFixed(1)}, ${selectedNode.coords.z.toFixed(1)}${selectedNode.coords.h ? ` | H: ${selectedNode.coords.h.toFixed(1)}` : ''}` : window.T('no_location');
        pedClone.querySelector('input').value = coordStr;
        pedClone.querySelector('.btn-zone').onclick = () => pickLocation(null, null, 'ped');
        const btnPed = pedClone.querySelector('.btn-ped');
        if (btnPed) btnPed.style.display = 'none';

        const pedSelector = pedClone.querySelector('.ped-type-selector');
        pedSelector.classList.remove('hidden');
        const pedBtns = pedSelector.querySelector('.ped-btns');
        pedBtns.innerHTML = '';
        ['police', 'sheriff', 'fib'].forEach(type => {
            const btn = document.createElement('div');
            btn.className = `ped-type-btn ${currentPed === type ? 'active' : ''}`;
            btn.style.cssText = `flex: 1; text-align: center; font-size: 9px; padding: 4px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 4px; cursor: pointer; color: ${currentPed === type ? 'var(--accent)' : 'var(--text-dim)'}; ${currentPed === type ? 'border-color: var(--accent); background: var(--accent-dim);' : ''}`;
            btn.innerText = type.toUpperCase();
            btn.onclick = () => updateNodePedType(type);
            pedBtns.appendChild(btn);
        });
        inspectorContent.appendChild(pedClone);

        const greetingField = document.createElement('div');
        greetingField.className = 'field';
        greetingField.innerHTML = `<label>${window.T('ai_police_npc_greeting')}</label>`;
        const greetingInput = document.createElement('input');
        greetingInput.type = 'text';
        greetingInput.value = selectedNode.greeting || '';
        greetingInput.placeholder = 'How can I help you today?';
        greetingInput.onchange = (e) => updateNode('greeting', e.target.value);
        greetingField.appendChild(greetingInput);
        inspectorContent.appendChild(greetingField);

        const knowledgeField = document.createElement('div');
        knowledgeField.className = 'field';
        knowledgeField.innerHTML = `<label>${window.T('ai_police_npc_knowledge')}</label>`;
        const knowledgeInput = document.createElement('textarea');
        knowledgeInput.value = selectedNode.knowledge || '';
        knowledgeInput.placeholder = 'Police academy will be on 2nd of this month. Add policies, schedules, SOPs, ranks, recruitment info, and anything this NPC should know.';
        knowledgeInput.style.minHeight = '190px';
        knowledgeInput.style.resize = 'vertical';
        knowledgeInput.onchange = (e) => updateNode('knowledge', e.target.value);
        knowledgeField.appendChild(knowledgeInput);
        inspectorContent.appendChild(knowledgeField);
    }

    if (selectedNode.type === 'vehicle' || selectedNode.type === 'helipad') {
        const vehClone = cloneTemplate('tpl-vehicle-node');

        // Points
        const pointTypes = [
            { key: 'spawnPoints', container: '.spawn-points-list', type: 'spawn', addBtn: '.add-spawn-btn' },
            { key: 'impoundSpawnPoints', container: '.impound-points-list', type: 'impound_spawn', addBtn: '.add-impound-btn' },
            { key: 'deletePoints', container: '.store-points-list', type: 'delete', addBtn: '.add-store-btn' }
        ];

        pointTypes.forEach(pt => {
            const list = vehClone.querySelector(pt.container);
            if (!selectedNode[pt.key]) selectedNode[pt.key] = [];
            
            selectedNode[pt.key].forEach((p, index) => {
                const item = document.createElement('div');
                item.className = 'door-config-item';
                item.style.cssText = "margin-bottom: 15px; padding: 12px; background: rgba(0,0,0,0.2); border-radius: 8px; border: 1px solid rgba(255,255,255,0.03);";
                item.innerHTML = `
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 9px; margin-bottom: 5px;" data-translate="world_position">${window.T('world_position')} (${index + 1})</label>
                        <div class="input-with-btn">
                            <input type="text" value="${p ? `${p.x.toFixed(1)}, ${p.y.toFixed(1)}, ${p.z.toFixed(1)}` : window.T('no_location')}" readonly style="font-size: 11px;">
                            <button class="pick-btn-small btn-pick"><i class="fas fa-crosshairs"></i></button>
                            <button class="delete-rank-btn btn-delete" style="margin-left: 8px;"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                `;
                item.querySelector('.btn-pick').onclick = () => pickLocation(pt.type, index);
                item.querySelector('.btn-delete').onclick = () => deletePoint(pt.type, index);
                list.appendChild(item);
            });
            vehClone.querySelector(pt.addBtn).onclick = () => addPoint(pt.type);
        });

        // Vehicles List
        const vehList = vehClone.querySelector('.vehicles-list');
        if (!selectedNode.vehicles) selectedNode.vehicles = [];
        
        const vehHeader = vehClone.querySelector('[data-translate="dept_vehicles"]');
        if (selectedNode.type === 'helipad') {
            vehHeader.setAttribute('data-translate', 'dept_aircraft');
            vehHeader.innerText = window.T('dept_aircraft');
        }

        selectedNode.vehicles.forEach((veh, index) => {
            const item = document.createElement('div');
            item.className = 'door-config-item';
            item.style.cssText = "margin-bottom: 15px; padding: 12px; background: rgba(0,0,0,0.2); border-radius: 8px; border: 1px solid rgba(255,255,255,0.03);";
            item.innerHTML = `
                <div class="field" style="margin-bottom: 10px;">
                    <label style="font-size: 8px; opacity: 0.6;" data-translate="vehicle_label">VEHICLE LABEL</label>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <input type="text" class="v-label" value="${veh.label}" placeholder="Label" style="flex: 1; height: 32px; font-size: 11px;">
                        <button class="delete-rank-btn btn-delete" style="width: 32px; height: 32px;"><i class="fas fa-trash" style="font-size: 10px;"></i></button>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px;">
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 8px; opacity: 0.6;" data-translate="spawn_code">SPAWN CODE</label>
                        <input type="text" class="v-model" value="${veh.model}" placeholder="vic" style="height: 32px; font-size: 11px;">
                    </div>
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 8px; opacity: 0.6;" data-translate="livery">LIVERY</label>
                        <input type="number" class="v-livery" value="${veh.livery !== undefined && veh.livery !== null ? veh.livery : ''}" min="0" placeholder="0" style="height: 32px; font-size: 11px;">
                    </div>
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 8px; opacity: 0.6;" data-translate="min_grade">MIN GRADE</label>
                        <input type="number" class="v-grade" value="${veh.minGrade !== undefined && veh.minGrade !== null ? veh.minGrade : ''}" min="0" placeholder="0" style="height: 32px; font-size: 11px;">
                    </div>
                </div>
            `;
            item.querySelector('.v-label').onchange = (e) => updateVehicleInfo(index, 'label', e.target.value);
            item.querySelector('.v-model').onchange = (e) => updateVehicleInfo(index, 'model', e.target.value);
            item.querySelector('.v-livery').onchange = (e) => updateVehicleInfo(index, 'livery', e.target.value === '' ? null : parseInt(e.target.value));
            item.querySelector('.v-grade').onchange = (e) => updateVehicleInfo(index, 'minGrade', e.target.value === '' ? 0 : parseInt(e.target.value));
            item.querySelector('.btn-delete').onclick = () => deleteVehicleFromNode(index);
            applyTranslations(item);
            vehList.appendChild(item);
        });

        vehClone.querySelector('.add-vehicle-btn').onclick = () => addVehicleToNode();
        inspectorContent.appendChild(vehClone);
    }

    if (selectedNode.type === 'door') {
        const doorClone = cloneTemplate('tpl-door-node');
        const listContainer = doorClone.querySelector('.door-list');
        if (!selectedNode.doors) selectedNode.doors = [];
        
        selectedNode.doors.forEach((door, index) => {
            const isDouble = door.isDouble || false;
            const coordStr = door.coords ? `${door.coords.x.toFixed(1)}, ${door.coords.y.toFixed(1)}, ${door.coords.z.toFixed(1)}` : window.T('no_door_selected');
            const coordStr2 = door.coords2 ? `${door.coords2.x.toFixed(1)}, ${door.coords2.y.toFixed(1)}, ${door.coords2.z.toFixed(1)}` : window.T('no_door_selected');
            const minRank = door.minRank !== undefined && door.minRank !== null ? Number(door.minRank) : 0;
            const controlDistance = door.controlDistance !== undefined && door.controlDistance !== null ? Number(door.controlDistance) : 2.0;
            
            const item = document.createElement('div');
            item.className = 'door-config-item';
            item.style.cssText = "margin-bottom: 25px; padding: 12px; background: rgba(0,0,0,0.2); border-radius: 8px; border: 1px solid rgba(255,255,255,0.03);";
            item.innerHTML = `
                <div class="field" style="margin-bottom: 10px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;">
                        <label style="font-size: 9px;" data-translate="door_label">DOOR LABEL</label>
                        <div style="display: flex; align-items: center; gap: 5px;">
                            <span style="font-size: 8px; opacity: 0.6; text-transform: uppercase;">Double Door</span>
                            <input type="checkbox" class="d-double" ${isDouble ? 'checked' : ''} style="width: 14px; height: 14px; cursor: pointer;">
                        </div>
                    </div>
                    <input type="text" class="d-label" value="${door.label || ''}" placeholder="Example: Front Entrance" style="height: 38px;">
                </div>
                
                <div class="field" style="margin-bottom: 0;">
                    <label style="font-size: 9px; margin-bottom: 5px;">${isDouble ? 'DOOR 1 SELECTION' : 'WORLD POSITION & SELECTION'}</label>
                    <div class="input-with-btn">
                        <input type="text" value="${coordStr}" readonly style="font-size: 11px; height: 38px;">
                        <button class="pick-btn-small btn-pick" style="width: 38px; height: 38px;"><i class="fas fa-crosshairs"></i></button>
                        <button class="delete-rank-btn btn-delete" style="margin-left: 8px; width: 38px; height: 38px;"><i class="fas fa-trash"></i></button>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: 10px;">
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 9px; opacity: 0.6; text-transform: uppercase;">Min Rank</label>
                        <input type="number" class="d-min-rank" value="${minRank}" min="0" placeholder="0" style="height: 32px; font-size: 11px;">
                    </div>
                    <div class="field" style="margin-bottom: 0;">
                        <label style="font-size: 9px; opacity: 0.6; text-transform: uppercase;">Control Distance</label>
                        <input type="number" class="d-control-distance" value="${controlDistance}" min="0.5" step="0.1" placeholder="2.0" style="height: 32px; font-size: 11px;">
                    </div>
                </div>

                <div class="field door-2-field" style="margin-top: 10px; margin-bottom: 0; display: ${isDouble ? 'block' : 'none'};">
                    <label style="font-size: 9px; margin-bottom: 5px;">DOOR 2 SELECTION</label>
                    <div class="input-with-btn">
                        <input type="text" value="${coordStr2}" readonly style="font-size: 11px; height: 38px;">
                        <button class="pick-btn-small btn-pick-2" style="width: 38px; height: 38px;"><i class="fas fa-crosshairs"></i></button>
                    </div>
                </div>

                <div class="hashes-info" style="font-size: 8px; color: var(--accent); margin-top: 8px; opacity: 0.5; font-family: monospace;">
                    ${door.hash ? `<div>HASH 1: ${door.hash}</div>` : ''}
                    ${isDouble && door.hash2 ? `<div>HASH 2: ${door.hash2}</div>` : ''}
                </div>
            `;
            
            const labelInput = item.querySelector('.d-label');
            const doubleCheckbox = item.querySelector('.d-double');
            const pickBtn = item.querySelector('.btn-pick');
            const pickBtn2 = item.querySelector('.btn-pick-2');
            const deleteBtn = item.querySelector('.btn-delete');
            const door2Field = item.querySelector('.door-2-field');
            const minRankInput = item.querySelector('.d-min-rank');
            const controlDistanceInput = item.querySelector('.d-control-distance');

            labelInput.onchange = (e) => updateDoorInfo(index, 'label', e.target.value);
            doubleCheckbox.onchange = (e) => {
                const checked = e.target.checked;
                updateDoorInfo(index, 'isDouble', checked);
                door2Field.style.display = checked ? 'block' : 'none';
                item.querySelector('label:nth-of-type(2)').innerText = checked ? 'DOOR 1 SELECTION' : 'WORLD POSITION & SELECTION';
            };
            minRankInput.onchange = (e) => {
                const parsed = parseInt(e.target.value, 10);
                updateDoorInfo(index, 'minRank', Number.isNaN(parsed) ? 0 : Math.max(0, parsed));
            };
            controlDistanceInput.onchange = (e) => {
                const parsed = parseFloat(e.target.value);
                updateDoorInfo(index, 'controlDistance', Number.isNaN(parsed) ? 2.0 : Math.max(0.5, parsed));
            };
            
            pickBtn.onclick = () => pickDoorLocation(index, 1);
            pickBtn2.onclick = () => pickDoorLocation(index, 2);
            deleteBtn.onclick = () => deleteDoorFromNode(index);
            
            applyTranslations(item);
            listContainer.appendChild(item);
        });

        doorClone.querySelector('.add-door-btn').onclick = () => addDoorToNode();
        inspectorContent.appendChild(doorClone);
    }

    if (selectedNode.type === 'k9') {
        const k9Clone = cloneTemplate('tpl-k9-node');
        const bedCoords = selectedNode.coords ? `${selectedNode.coords.x.toFixed(1)}, ${selectedNode.coords.y.toFixed(1)}, ${selectedNode.coords.z.toFixed(1)}${selectedNode.coords.h ? ` | H: ${selectedNode.coords.h.toFixed(1)}` : ''}` : window.T('no_location');
        const spawnCoords = selectedNode.spawnCoords ? `${selectedNode.spawnCoords.x.toFixed(1)}, ${selectedNode.spawnCoords.y.toFixed(1)}, ${selectedNode.spawnCoords.z.toFixed(1)}${selectedNode.spawnCoords.h ? ` | H: ${selectedNode.spawnCoords.h.toFixed(1)}` : ''}` : window.T('no_location');

        const inputs = k9Clone.querySelectorAll('input');
        inputs[0].value = bedCoords;
        inputs[1].value = spawnCoords;
        
        inspectorContent.appendChild(k9Clone);
    }
}

window.updateWeaponInfo = function(index, key, value) {
    if (selectedNode && selectedNode.weapons) {
        selectedNode.weapons[index][key] = value;
    }
}

window.updateItemInfo = function(index, key, value) {
    if (selectedNode && selectedNode.items) {
        selectedNode.items[index][key] = value;
    }
}

window.deleteWeaponFromArmory = function(index) {
    if (selectedNode && selectedNode.weapons) {
        selectedNode.weapons.splice(index, 1);
        renderInspector();
        renderCanvas();
    }
}

window.deleteItemFromArmory = function(index) {
    if (selectedNode && selectedNode.items) {
        selectedNode.items.splice(index, 1);
        renderInspector();
        renderCanvas();
    }
}

window.addWeaponToArmory = function() {
    if (selectedNode) {
        if (!selectedNode.weapons) selectedNode.weapons = [];
        selectedNode.weapons.push({ label: 'New Weapon', model: '', minGrade: 0 });
        renderInspector();
        renderCanvas();
    }
}

window.addCameraToNode = function() {
    if (!selectedNode) return;
    if (!selectedNode.cameras) selectedNode.cameras = [];
    selectedNode.cameras.push({ label: 'New Camera', coords: null });
    renderInspector();
    renderCanvas();
};

window.deleteCameraFromNode = function(index) {
    if (!selectedNode || !selectedNode.cameras) return;
    selectedNode.cameras.splice(index, 1);
    renderInspector();
    renderCanvas();
};

window.updateCameraNodeInfo = function(index, field, value) {
    if (!selectedNode || !selectedNode.cameras || !selectedNode.cameras[index]) return;
    if (field === 'heading') {
        if (!selectedNode.cameras[index].coords) {
            selectedNode.cameras[index].coords = { x: 0, y: 0, z: 0, h: value };
        } else {
            selectedNode.cameras[index].coords.h = value;
        }
    } else {
        selectedNode.cameras[index][field] = value;
    }
    renderInspector();
    renderCanvas();
};

window.addItemToArmory = function() {
    if (selectedNode) {
        if (!selectedNode.items) selectedNode.items = [];
        selectedNode.items.push({ label: 'New Item', model: '', minGrade: 0 });
        renderInspector();
        renderCanvas();
    }
}

// Removed window.toggleWeaponRankPerm since it's no longer used


window.updateDoorInfo = function(index, key, value) {
    if (selectedNode && selectedNode.doors) {
        selectedNode.doors[index][key] = value;
        saveData();
    }
}

window.deleteDoorFromNode = function(index) {
    if (selectedNode && selectedNode.doors) {
        selectedNode.doors.splice(index, 1);
        renderInspector();
        renderCanvas();
    }
}

window.addDoorToNode = function() {
    if (selectedNode) {
        if (!selectedNode.doors) selectedNode.doors = [];
        selectedNode.doors.push({ label: 'New Door', coords: null, hash: null, minRank: 0, controlDistance: 2.0 });
        renderInspector();
        renderCanvas();
    }
}

window.pickDoorLocation = function(index, doorNum = 1) {
    if (!selectedNode) return;
    app.classList.add('hidden');
    app.style.removeProperty('display'); // Fix: Ensure the UI actually disappears
    fetch(`https://${GetParentResourceName()}/startDoorPlacement`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            nodeId: selectedNode.id,
            doorIndex: index,
            doorNum: doorNum
        })
    });
}

window.updateOutfit = function(rankKey, index, component, subkey, value) {
    if (selectedNode && selectedNode.type === 'wardrobe') {
        if (!selectedNode.outfits) selectedNode.outfits = {};
        if (!selectedNode.outfits[rankKey]) selectedNode.outfits[rankKey] = [];
        if (!selectedNode.outfits[rankKey][index]) selectedNode.outfits[rankKey][index] = {};
        if (!selectedNode.outfits[rankKey][index][component]) selectedNode.outfits[rankKey][index][component] = {};
        
        selectedNode.outfits[rankKey][index][component][subkey] = parseInt(value);
        saveData(); // Auto-save on update
    }
}

window.updateOutfitLabel = function(rankKey, index, value) {
    if (selectedNode && selectedNode.outfits && selectedNode.outfits[rankKey]) {
        if (!selectedNode.outfits[rankKey][index]) selectedNode.outfits[rankKey][index] = {};
        selectedNode.outfits[rankKey][index].label = value;
        saveData();
    }
}

window.addOutfitToRank = function(rankKey) {
    if (selectedNode && selectedNode.type === 'wardrobe') {
        if (!selectedNode.outfits) selectedNode.outfits = {};
        
        // Data Migration: Ensure it's an array before pushing
        if (selectedNode.outfits[rankKey] && !Array.isArray(selectedNode.outfits[rankKey])) {
            selectedNode.outfits[rankKey] = [selectedNode.outfits[rankKey]];
        }
        
        if (!selectedNode.outfits[rankKey]) selectedNode.outfits[rankKey] = [];
        
        selectedNode.outfits[rankKey].push({
            label: "New Outfit",
            shirt: { item: 0, texture: 0 },
            pants: { item: 0, texture: 0 },
            shoes: { item: 0, texture: 0 }
        });
        
        renderInspector();
        saveData();
    }
}

window.deleteOutfitFromRank = function(rankKey, index) {
    if (selectedNode && selectedNode.outfits && selectedNode.outfits[rankKey]) {
        selectedNode.outfits[rankKey].splice(index, 1);
        renderInspector();
        saveData();
    }
}

window.updatePedType = function(locId, type) {
    if (selectedNode) {
        if (!selectedNode.pedTypes) selectedNode.pedTypes = {};
        selectedNode.pedTypes[locId] = type;
        renderInspector();
        saveData();
    }
}

window.updateNodePedType = function(type) {
    if (selectedNode) {
        selectedNode.pedType = type;
        renderInspector();
        saveData();
    }
}

window.updateNode = function(key, value) {
    if (selectedNode) {
        selectedNode[key] = value;
        renderCanvas();
        renderInspector();
        saveData(); // Auto-save on update

        if (selectedNode.type === 'department' && key === 'frameworkJob') {
            const linkedRankNodes = getLinkedRankNodesForDepartment(selectedNode.id);
            linkedRankNodes.forEach(rankNode => {
                syncRankNodeFromFramework(rankNode, true);
            });
        }
    }
}

window.togglePermission = function(rankKey, perm) {
    if (selectedNode && selectedNode.type === 'permission') {
        if (!selectedNode.rankPerms || Array.isArray(selectedNode.rankPerms)) selectedNode.rankPerms = {};
        if (!selectedNode.rankPerms[rankKey] || Array.isArray(selectedNode.rankPerms[rankKey])) selectedNode.rankPerms[rankKey] = {};
        
        selectedNode.rankPerms[rankKey][perm] = !selectedNode.rankPerms[rankKey][perm];
        renderInspector();
        saveData(); // Auto-save on update
    }
}

window.updateRank = function(index, key, value) {
    if (selectedNode && selectedNode.ranks) {
        selectedNode.ranks[index][key] = value;
        renderCanvas();
        refreshLinkedPermissionNodes(selectedNode.id);
        saveData(); // Auto-save on update
    }
}

window.toggleRankBossMenu = function(index) {
    if (selectedNode && selectedNode.ranks) {
        selectedNode.ranks[index].bossMenu = !selectedNode.ranks[index].bossMenu;
        renderInspector();
        saveData(); // Auto-save on update
    }
}

window.deleteRank = function(index) {
    if (selectedNode && selectedNode.ranks) {
        selectedNode.ranks.splice(index, 1);
        renderCanvas();
        renderInspector();
        refreshLinkedPermissionNodes(selectedNode.id);
        saveData(); // Auto-save on update
    }
}

window.addRankToList = function() {
    if (selectedNode) {
        if (!selectedNode.ranks) selectedNode.ranks = [];
        
        let maxLevel = -1;
        selectedNode.ranks.forEach(r => {
            if (r.level > maxLevel) maxLevel = r.level;
        });
        
        selectedNode.ranks.push({ name: 'New Rank', level: maxLevel + 1, pay: 500 });
        renderCanvas();
        renderInspector();
        refreshLinkedPermissionNodes(selectedNode.id);
        saveData(); // Auto-save on update
    }
}

window.updateVehicleInfo = function(index, key, value) {
    if (selectedNode && selectedNode.vehicles) {
        selectedNode.vehicles[index][key] = value;
    }
}

window.deleteVehicleFromNode = function(index) {
    if (selectedNode && selectedNode.vehicles) {
        selectedNode.vehicles.splice(index, 1);
        renderInspector();
    }
}

window.addVehicleToNode = function() {
    if (selectedNode) {
        if (!selectedNode.vehicles) selectedNode.vehicles = [];
        selectedNode.vehicles.push({ model: '', label: '', livery: null, minGrade: 0 });
        renderInspector();
    }
}

window.addPoint = function(type) {
    if (selectedNode) {
        if (type === 'spawn') {
            if (!selectedNode.spawnPoints) selectedNode.spawnPoints = [];
            selectedNode.spawnPoints.push(null);
        } else if (type === 'impound_spawn') {
            if (!selectedNode.impoundSpawnPoints) selectedNode.impoundSpawnPoints = [];
            selectedNode.impoundSpawnPoints.push(null);
        } else {
            if (!selectedNode.deletePoints) selectedNode.deletePoints = [];
            selectedNode.deletePoints.push(null);
        }
        renderInspector();
    }
}

window.deletePoint = function(type, index) {
    if (selectedNode) {
        if (type === 'spawn') selectedNode.spawnPoints.splice(index, 1);
        else if (type === 'impound_spawn') selectedNode.impoundSpawnPoints.splice(index, 1);
        else selectedNode.deletePoints.splice(index, 1);
        renderInspector();
    }
}

window.pickLocation = function(overrideLocType, pointIndex, interactionType) {
    if (!selectedNode) return;

    const defaultLocTypeByNode = {
        location: 'garage',
        vehicle: 'spawn',
        helipad: 'spawn',
        wardrobe: 'wardrobe',
        evidence: 'evidence',
        armory: 'armory',
        boss_menu: 'boss_menu',
        form_computer: 'form_computer',
        mdt_dispatch: 'mdt_dispatch',
        ai_police_npc: 'ai_police_npc',
        k9: 'bed',
        camera: 'camera'
    };

    let currentLocType = overrideLocType || selectedNode.locType || defaultLocTypeByNode[selectedNode.type];
    if (interactionType === 'ped' && !currentLocType) {
        currentLocType = selectedNode.type || 'location';
    }

    if (!currentLocType && selectedNode.type !== 'department') {
        return;
    }
    
    app.classList.add('hidden');
    app.style.removeProperty('display');
    
    fetch(`https://${GetParentResourceName()}/startPlacement`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            nodeId: selectedNode.id,
            type: selectedNode.type,
            blipId: selectedNode.blipId,
            blipColor: selectedNode.blipColor,
            blipName: selectedNode.blipName || selectedNode.label,
            locType: currentLocType,
            pointIndex: pointIndex,
            interactionType: interactionType
        })
    });
}

// Listen for Escape key to close
window.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        // Management Menu
        if (!app.classList.contains('hidden')) {
            saveData(true);
            app.classList.add('hidden');
            app.style.removeProperty('display');
            fetch(`https://${GetParentResourceName()}/close`, {
                method: 'POST'
            });
        }
        
        // Garage View
        if (!garageView.classList.contains('hidden')) {
            closeGarage();
        }
    }
});

// Canvas Interaction Logic
canvas.addEventListener('mousedown', (e) => {
    if (e.target === canvas || e.target === canvasContent || e.target === svg) {
        isPanning = true;
        lastMousePos = { x: e.clientX, y: e.clientY };
    }
});

let drawRequested = false;
function requestDraw() {
    if (!drawRequested) {
        drawRequested = true;
        requestAnimationFrame(() => {
            drawConnections();
            drawRequested = false;
        });
    }
}

document.addEventListener('mousemove', (e) => {
    if (isDragging && dragTarget && selectedNode) {
        const rect = canvas.getBoundingClientRect();
        const x = (e.clientX / window.resolutionScale - rect.left / window.resolutionScale - pan.x) / zoom - offset.x;
        const y = (e.clientY / window.resolutionScale - rect.top / window.resolutionScale - pan.y) / zoom - offset.y;
        
        dragTarget.style.left = `${x}px`;
        dragTarget.style.top = `${y}px`;
        selectedNode.x = x;
        selectedNode.y = y;
        requestDraw();
    } else if (isPanning) {
        const dx = (e.clientX - lastMousePos.x) / window.resolutionScale;
        const dy = (e.clientY - lastMousePos.y) / window.resolutionScale;
        pan.x += dx;
        pan.y += dy;
        lastMousePos = { x: e.clientX, y: e.clientY };
        updateCanvasTransform();
    }

    if (activePort && tempLine) {
        const fromNode = nodes.find(n => String(n.id) === String(activePort.id));
        const fromEl = document.getElementById(`node-${activePort.id}`);
        if (fromNode && fromEl) {
            // Adjust for port-out offset (20px outside node)
            const fromW = fromEl.offsetWidth;
            const fromH = fromEl.offsetHeight;
            const x1 = (fromNode.x || 0) + (fromW > 0 ? fromW : 160) + 20;
            const y1 = (fromNode.y || 0) + (fromH > 0 ? fromH : 80) / 2;
            const rect = canvas.getBoundingClientRect();
            // Convert physical mouse coordinates to logical coordinates inside the scaled #app
            const x2 = (e.clientX / window.resolutionScale - rect.left / window.resolutionScale - pan.x) / zoom;
            const y2 = (e.clientY / window.resolutionScale - rect.top / window.resolutionScale - pan.y) / zoom;
            const cp1x = x1 + (x2 - x1) / 2;
            const cp2x = x1 + (x2 - x1) / 2;
            tempLine.setAttribute('d', `M ${x1} ${y1} C ${cp1x} ${y1}, ${cp2x} ${y2}, ${x2} ${y2}`);
            tempLine.style.stroke = '#ffffff';
            tempLine.style.strokeWidth = '2px';
            tempLine.style.strokeDasharray = '5,5';
            tempLine.style.fill = 'none';
        }
    }
});

document.addEventListener('mouseup', (e) => {
    if (activePort && tempLine) {
        const portIn = e.target.closest('.port-in');
        if (portIn) {
            const toId = portIn.dataset.id;
            const exists = connections.some(c => c.from === activePort.id && c.to === toId);
            if (activePort.id !== toId && !exists) {
                connections.push({ from: activePort.id, to: toId });
            }
        }
        tempLine.remove();
        tempLine = null;
        activePort = null;
        drawConnections();
        // Refresh inspector if the connection was to a permission or wardrobe node
        if (selectedNode && (selectedNode.type === 'permission' || selectedNode.type === 'wardrobe')) {
            renderInspector();
        }
        saveData(); // Auto-save on link
    }
    isDragging = false;
    isPanning = false;
    dragTarget = null;
});

canvasContent.addEventListener('mousedown', (e) => {
    if (e.target.classList.contains('port-out')) {
        e.stopPropagation();
        activePort = { id: e.target.dataset.id };
        tempLine = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        tempLine.setAttribute('class', 'connection temp');
        tempLine.style.stroke = '#ffffff';
        tempLine.style.strokeWidth = '2px';
        tempLine.style.strokeDasharray = '5,5';
        tempLine.style.fill = 'none';
        svg.appendChild(tempLine);
    }
});

function drawConnections() {
    if (!svg) return;
    
    // Ensure SVG is the last child so it stays on top of nodes
    if (svg.parentElement) {
        svg.parentElement.appendChild(svg);
    }
    
    svg.innerHTML = '';
    
    // Use a single string for connections to avoid ID type issues
    connections.forEach(conn => {
        const fromId = String(conn.from);
        const toId = String(conn.to);
        
        const fromNode = nodes.find(n => String(n.id) === fromId);
        const toNode = nodes.find(n => String(n.id) === toId);
        
        if (fromNode && toNode) {
            const fromEl = document.getElementById(`node-${fromId}`);
            const toEl = document.getElementById(`node-${toId}`);
            
            // Default sizes if elements aren't fully rendered
            const fromW = fromEl ? fromEl.offsetWidth : 160;
            const fromH = fromEl ? fromEl.offsetHeight : 80;
            const toH = toEl ? toEl.offsetHeight : 80;
            
            const x1 = (fromNode.x || 0) + (fromW > 0 ? fromW : 160) + 20;
            const y1 = (fromNode.y || 0) + (fromH > 0 ? fromH : 80) / 2;
            const x2 = (toNode.x || 0) - 20;
            const y2 = (toNode.y || 0) + (toH > 0 ? toH : 80) / 2;
            
            if (isNaN(x1) || isNaN(y1) || isNaN(x2) || isNaN(y2)) return;
            
            const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            const cp1x = x1 + (x2 - x1) / 2;
            const cp2x = x1 + (x2 - x1) / 2;
            path.setAttribute('d', `M ${x1} ${y1} C ${cp1x} ${y1}, ${cp2x} ${y2}, ${x2} ${y2}`);
            path.setAttribute('class', 'connection');
            
            // Explicitly set styles to ensure visibility
            path.style.stroke = 'var(--accent)';
            path.style.strokeWidth = '2px';
            path.style.fill = 'none';
            path.style.pointerEvents = 'auto';
            
            path.addEventListener('click', (e) => {
                e.stopPropagation();
                connections = connections.filter(c => c !== conn);
                drawConnections();
            });
            svg.appendChild(path);
        }
    });
}

function getBlipHex(colorId) {
    const colors = {
        1: '#ff0000', 2: '#00ff00', 3: '#0000ff', 4: '#ffffff', 5: '#ffff00', 
        17: '#ff8000', 18: '#ff00ff', 21: '#ff0080', 25: '#00ff80', 29: '#8000ff', 
        31: '#80ff00', 35: '#0080ff', 38: '#00ffff'
    };
    return colors[colorId] || '#ffffff';
}

function findLinkedRankNode(nodeId) {
    // 1. Check for direct link to a rank node (any direction)
    for (const c of connections) {
        if (c.to === nodeId) {
            const n = nodes.find(n => n.id === c.from && n.type === 'rank');
            if (n) return n;
        }
        if (c.from === nodeId) {
            const n = nodes.find(n => n.id === c.to && n.type === 'rank');
            if (n) return n;
        }
    }

    // 2. Check for link to a department, then find that department's rank node
    let deptId = null;
    for (const c of connections) {
        if (c.to === nodeId) {
            const n = nodes.find(n => n.id === c.from && n.type === 'department');
            if (n) { deptId = n.id; break; }
        }
        if (c.from === nodeId) {
            const n = nodes.find(n => n.id === c.to && n.type === 'department');
            if (n) { deptId = n.id; break; }
        }
    }

    if (deptId) {
        for (const c of connections) {
            if (c.from === deptId) {
                const n = nodes.find(n => n.id === c.to && n.type === 'rank');
                if (n) return n;
            }
            if (c.to === deptId) {
                const n = nodes.find(n => n.id === c.from && n.type === 'rank');
                if (n) return n;
            }
        }
    }

    return null;
}

function refreshLinkedPermissionNodes(rankNodeId) {
    const linkedPermLinks = connections.filter(c => c.from === rankNodeId);
    linkedPermLinks.forEach(link => {
        const permNode = nodes.find(n => n.id === link.to && n.type === 'permission');
        if (permNode && selectedNode && selectedNode.id === permNode.id) {
            renderInspector();
        }
    });
}

document.addEventListener('click', (e) => {
    const nodeItem = e.target.closest('.node-item');
    if (nodeItem) {
        const type = nodeItem.dataset.type;
        if (!type) return;

        if (type === 'preset') {
            const presetId = nodeItem.dataset.id;
            if (presetId === 'lspd_full') {
                const presetData = {
                    divisions: {
                        lspd_1771421965586: [
                            { id: "div_1771423354_656", name: "K9 Units" }
                        ]
                    },
                    nodes: [
                        {
                            id: "rank_1771362842063_1_873570",
                            x: 1200.462957991278,
                            y: 833.8812353377124,
                            type: "rank",
                            label: "New Rank",
                            level: 0,
                            payment: 500,
                            ranks: [
                                { name: "Recruit", bossMenu: false, level: 0, pay: 50 },
                                { name: "Officer", bossMenu: false, level: 1, pay: 75 },
                                { name: "Sergeant", bossMenu: false, level: 2, pay: 100 },
                                { name: "Lieutenant", bossMenu: false, level: 3, pay: 125 },
                                { name: "Chief", bossMenu: true, level: 4, pay: 150 }
                            ]
                        },
                        {
                            id: "permission_1771362842063_2_553385",
                            x: 1584.001917431494,
                            y: 1014.3396043663237,
                            type: "permission",
                            label: "New permission",
                            permType: "duty",
                            rankPerms: {
                                rank_0: {},
                                rank_1: {},
                                rank_2: {},
                                rank_3: {},
                                rank_4: {}
                            }
                        },
                        {
                            id: "location_1771362842063_3_66131",
                            x: 1213.8502045724154,
                            y: 450.43013431587735,
                            type: "location",
                            label: "New location",
                            locType: "garage",
                            coordsList: {},
                            interactionTypes: {}
                        },
                        {
                            id: "door_1771362842063_4_175752",
                            x: 1309.0574627553437,
                            y: 711.458982170993,
                            type: "door",
                            label: "New door",
                            doors: []
                        },
                        {
                            id: "vehicle_1771362842063_5_283248",
                            x: 1586.7783808262116,
                            y: 532.6903006774786,
                            type: "vehicle",
                            label: "New vehicle",
                            locType: "spawn",
                            coordsList: [],
                            vehicles: [],
                            spawnPoints: [],
                            deletePoints: [],
                            impoundSpawnPoints: []
                        },
                        {
                            id: "armory_1771362842063_6_678382",
                            x: 1591.6200074440676,
                            y: 393.4935354141131,
                            type: "armory",
                            label: "New armory",
                            weapons: [
                                { label: "Combat Pistol", minGrade: 0, model: "weapon_combatpistol" },
                                { label: "Taser", minGrade: 0, model: "weapon_stungun" },
                                { label: "Nightstick", minGrade: 0, model: "weapon_nightstick" }
                            ],
                            items: [
                                { label: "Radio", minGrade: 0, model: "radio" },
                                { label: "Handcuffs", minGrade: 0, model: "handcuffs" },
                                { label: "Bandage", minGrade: 0, model: "bandage" }
                            ]
                        },
                        {
                            id: "k9_1771362842063_8_699289",
                            x: 1589.8626460650148,
                            y: 276.58351142069694,
                            type: "k9",
                            label: "New k9",
                            locType: "bed",
                            coords: null,
                            spawnCoords: null
                        },
                        {
                            id: "camera_1771362842063_9_929234",
                            x: 1224.6881235670016,
                            y: 582.5514104119545,
                            type: "camera",
                            label: "New camera",
                            locType: "camera",
                            coords: null,
                            cameras: [
                                { label: "New Camera", coords: null }
                            ]
                        },
                        {
                            id: "evidence_1771362842063_10_848460",
                            x: 1252.148965818388,
                            y: 999.7701349854711,
                            type: "evidence",
                            label: "New evidence",
                            coords: null
                        },
                        {
                            id: "lspd_1771421965586",
                            x: 856.5910738519999,
                            y: 696.0044201786451,
                            type: "department",
                            label: "LSPD",
                            displayName: "MIDNIGHT POLICE CONSTABULARY",
                            frameworkJob: "police",
                            blipId: 60,
                            blipColor: 3,
                            coords: null
                        },
                        {
                            id: "ai_police_npc_1786382299444",
                            x: 1593.1811430904404,
                            y: 142.05452330012395,
                            type: "ai_police_npc",
                            label: "AI Police NPC",
                            locType: "ai_police_npc",
                            pedType: "police",
                            greeting: "Hello. What can I help you with today?",
                            knowledge: "",
                            coords: null
                        },
                        {
                            id: "form_computer_1786383228133",
                            x: 1204.9031861453245,
                            y: 301.36124432490544,
                            type: "form_computer",
                            label: "Form Computer",
                            coords: null
                        },
                        {
                            id: "helipad_1786384271551",
                            x: 1598.0436791722937,
                            y: 656.319877516885,
                            type: "helipad",
                            label: "New helipad",
                            locType: "spawn",
                            coordsList: {},
                            vehicles: [],
                            spawnPoints: [],
                            deletePoints: [],
                            impoundSpawnPoints: []
                        },
                        {
                            id: "wardrobe_1786384296664",
                            x: 1578.9323421667302,
                            y: 824.226624065763,
                            type: "wardrobe",
                            label: "New wardrobe",
                            coords: null,
                            outfits: {}
                        }
                    ],
                    links: [
                        { from: "rank_1771362842063_1_873570", to: "permission_1771362842063_2_553385" },
                        { from: "location_1771362842063_3_66131", to: "armory_1771362842063_6_678382" },
                        { from: "location_1771362842063_3_66131", to: "vehicle_1771362842063_5_283248" },
                        { from: "location_1771362842063_3_66131", to: "k9_1771362842063_8_699289" },
                        { from: "lspd_1771421965586", to: "location_1771362842063_3_66131" },
                        { from: "lspd_1771421965586", to: "camera_1771362842063_9_929234" },
                        { from: "lspd_1771421965586", to: "door_1771362842063_4_175752" },
                        { from: "lspd_1771421965586", to: "rank_1771362842063_1_873570" },
                        { from: "lspd_1771421965586", to: "evidence_1771362842063_10_848460" },
                        { from: "location_1771362842063_3_66131", to: "ai_police_npc_1786382299444" },
                        { from: "lspd_1771421965586", to: "form_computer_1786383228133" },
                        { from: "location_1771362842063_3_66131", to: "helipad_1786384271551" },
                        { from: "rank_1771362842063_1_873570", to: "wardrobe_1786384296664" }
                    ],
                    pan: {
                        y: -89.9559728357159,
                        x: -212.10716832996036
                    }
                };
                
                // Reuse existing import logic but with preset data
                const textarea = document.getElementById('import-textarea');
                if (textarea) {
                    textarea.value = JSON.stringify(presetData);
                    window.confirmImport();
                }
            }
            return;
        }

        const deptId = nodeItem.dataset.id;
        const deptLabel = nodeItem.dataset.label;
        const centerX = (canvas.offsetWidth / 2 - pan.x) / zoom - 80;
        const centerY = (canvas.offsetHeight / 2 - pan.y) / zoom - 40;
        
        // Use the ID if it's a specific framework ID (police, bcso, sasp, ambulance)
        // Otherwise use the type as a base
        const finalId = deptId || type;
        
        const newNode = {
            id: (finalId === 'police' || finalId === 'bcso' || finalId === 'sasp' || finalId === 'ambulance') ? finalId : finalId + '_' + Date.now(),
            type: type,
            frameworkJob: type === 'department' ? 'police' : ((finalId === 'police' || finalId === 'bcso' || finalId === 'sasp' || finalId === 'ambulance') ? finalId : undefined),
            label: deptLabel || (type === 'rank' ? 'New Rank' : (type === 'boss_menu' ? 'Boss Menu' : (type === 'form_computer' ? 'Form Computer' : (type === 'mdt_dispatch' ? 'MDT Dispatch' : (type === 'ai_police_npc' ? 'AI Police NPC' : 'New ' + type))))),
            x: centerX,
            y: centerY,
            level: type === 'rank' ? 0 : undefined,
            payment: type === 'rank' ? 500 : undefined,
            permType: type === 'permission' ? 'duty' : undefined,
            locType: (type === 'location') ? 'garage' : ((type === 'vehicle' || type === 'helipad') ? 'spawn' : (type === 'k9' ? 'bed' : (type === 'camera' ? 'camera' : (type === 'ai_police_npc' ? 'ai_police_npc' : (type === 'mdt_dispatch' ? 'mdt_dispatch' : undefined))))),
            coordsList: (type === 'location' || type === 'vehicle' || type === 'helipad') ? {} : undefined,
            coords: (type === 'armory' || type === 'boss_menu' || type === 'form_computer' || type === 'mdt_dispatch' || type === 'ai_police_npc' || type === 'wardrobe' || type === 'k9' || type === 'camera') ? null : undefined,
            spawnCoords: type === 'k9' ? null : undefined,
            pedType: type === 'ai_police_npc' ? 'police' : undefined,
            greeting: type === 'ai_police_npc' ? 'Hello. What can I help you with today?' : undefined,
            knowledge: type === 'ai_police_npc' ? '' : undefined,
            weapons: type === 'armory' ? [
                { label: 'Combat Pistol', model: 'weapon_combatpistol', minGrade: 0 },
                { label: 'Taser', model: 'weapon_stungun', minGrade: 0 },
                { label: 'Nightstick', model: 'weapon_nightstick', minGrade: 0 }
            ] : undefined,
            items: type === 'armory' ? [
                { label: 'Radio', model: 'radio', minGrade: 0 },
                { label: 'Handcuffs', model: 'handcuffs', minGrade: 0 },
                { label: 'Bandage', model: 'bandage', minGrade: 0 }
            ] : undefined,
            outfits: type === 'wardrobe' ? {} : undefined,
            vehicles: (type === 'vehicle' || type === 'helipad') ? [] : undefined,
            doors: type === 'door' ? [] : undefined,
            spawnPoints: (type === 'vehicle' || type === 'helipad') ? [] : undefined,
            deletePoints: (type === 'vehicle' || type === 'helipad') ? [] : undefined,
            impoundSpawnPoints: (type === 'vehicle' || type === 'helipad') ? [] : undefined,
            ranks: type === 'rank' ? [] : undefined
        };
        nodes.push(newNode);
        renderCanvas();
        selectNode(newNode);
        return;
    }

    const categoryHeader = e.target.closest('.category-header');
    if (categoryHeader) {
        const category = categoryHeader.parentElement;
        const content = category.querySelector('.category-content');
        const icon = categoryHeader.querySelector('i');
        const isHidden = content.classList.toggle('hidden');
        category.classList.toggle('active', !isHidden);
        if (isHidden) {
            icon.className = 'fas fa-chevron-down';
        } else {
            icon.className = 'fas fa-chevron-up';
        }
    }
});

document.getElementById('close-inspector').addEventListener('click', () => {
    if (inspector) inspector.classList.add('hidden');
    selectedNode = null;
    document.querySelectorAll('.node').forEach(n => n.classList.remove('selected'));
});

// Prevent mouse wheel on number inputs from changing values, and handle zooming
document.addEventListener('wheel', function(e) {
    // If Boss Menu is open, don't handle zoom
    const bossMenu = document.getElementById('boss-menu-container');
    if (bossMenu && bossMenu.classList.contains('visible')) return;

    if (document.activeElement.type === 'number') {
        document.activeElement.blur();
    }

    // Only zoom if the mouse is over the canvas area
    const canvasRect = canvasContainer.getBoundingClientRect();
    if (e.clientX >= canvasRect.left && e.clientX <= canvasRect.right && 
        e.clientY >= canvasRect.top && e.clientY <= canvasRect.bottom) {
        
        const delta = e.deltaY > 0 ? 0.9 : 1.1;
        const newZoom = Math.min(Math.max(zoom * delta, 0.2), 3.0);
        
        if (newZoom !== zoom) {
            // Zoom centered on mouse position, accounting for resolution scaling
            const mouseX = (e.clientX - canvasRect.left) / window.resolutionScale;
            const mouseY = (e.clientY - canvasRect.top) / window.resolutionScale;
            
            pan.x = mouseX - (mouseX - pan.x) * (newZoom / zoom);
            pan.y = mouseY - (mouseY - pan.y) * (newZoom / zoom);
            
            zoom = newZoom;
            updateCanvasTransform();
        }
    }
});

document.getElementById('save-btn').addEventListener('click', () => {
    saveData(true);
});

document.getElementById('export-btn').addEventListener('click', () => {
    const data = JSON.stringify({ ...currentFullData, nodes, links: connections, pan });
    const textArea = document.createElement("textarea");
    textArea.value = data;
    document.body.appendChild(textArea);
    textArea.select();
    try {
        document.execCommand('copy');
        window.showNotification("Configuration Exported", [{ label: "Status", value: "Copied to Clipboard!" }]);
    } catch (err) {
        prompt("Copy this configuration:", data);
    }
    document.body.removeChild(textArea);
});

document.getElementById('import-btn').addEventListener('click', () => {
    const textarea = document.getElementById('import-textarea');
    textarea.value = '';
    const container = document.getElementById('import-modal-container');
    if (container) {
        container.classList.add('visible');
        textarea.focus();
    }
});

window.closeImportModal = function() {
    const container = document.getElementById('import-modal-container');
    if (container) container.classList.remove('visible');
};

window.confirmImport = function() {
    const input = document.getElementById('import-textarea').value;
    if (!input) return;

    try {
        const data = JSON.parse(input);
        const importedNodes = data.nodes || [];
        const importedLinks = data.links || data.connections || [];
        const importedDivisions = data.divisions || {};

        if (importedNodes.length > 0) {
            // Calculate centering offset to place the imported nodes in the middle of the CURRENT view
            const containerRect = canvasContainer.getBoundingClientRect();
            // Center of the visible container in canvas coordinates
            const viewCenterX = (containerRect.width / 2 - pan.x) / zoom;
            const viewCenterY = (containerRect.height / 2 - pan.y) / zoom;

            // Find center of imported nodes
            let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
            importedNodes.forEach(n => {
                minX = Math.min(minX, n.x);
                maxX = Math.max(maxX, n.x);
                minY = Math.min(minY, n.y);
                maxY = Math.max(maxY, n.y);
            });
            const importedCenterX = (minX + maxX) / 2;
            const importedCenterY = (minY + maxY) / 2;

            const offsetX = viewCenterX - importedCenterX;
            const offsetY = viewCenterY - importedCenterY;

            // Map old IDs to new unique IDs to avoid overwriting existing nodes
            const idMap = {};
            const timestamp = Date.now();

            importedNodes.forEach((node, index) => {
                const oldId = node.id;
                // Generate a truly unique ID for this instance
                const newId = `${node.type}_${Date.now()}_${index}_${Math.floor(Math.random() * 1000000)}`;
                idMap[oldId] = newId;
                
                // Update node data
                node.id = newId;
                node.x = (node.x || 0) + offsetX;
                node.y = (node.y || 0) + offsetY;
                
                nodes.push(node);
            });

            // Add links with updated IDs
            importedLinks.forEach(link => {
                const oldFrom = String(link.from || link.fromNode || "");
                const oldTo = String(link.to || link.toNode || "");
                const newFrom = idMap[oldFrom];
                const newTo = idMap[oldTo];
                if (newFrom && newTo) {
                    connections.push({ from: newFrom, to: newTo });
                }
            });

            if (importedDivisions && typeof importedDivisions === 'object' && !Array.isArray(importedDivisions)) {
                if (!currentFullData.divisions || Array.isArray(currentFullData.divisions)) currentFullData.divisions = {};
                Object.entries(importedDivisions).forEach(([oldDeptId, divs]) => {
                    const newDeptId = idMap[String(oldDeptId)] || oldDeptId;
                    if (!newDeptId || !Array.isArray(divs)) return;
                    if (!currentFullData.divisions[newDeptId]) currentFullData.divisions[newDeptId] = [];
                    divs.forEach((division, divIndex) => {
                        currentFullData.divisions[newDeptId].push({
                            ...division,
                            id: `${division.id || 'div'}_${timestamp}_${divIndex}`
                        });
                    });
                });
            }

            saveData();
            renderCanvas();
            
            // Second pass for connections to ensure DOM is ready and offsets are calculated
            setTimeout(() => {
                drawConnections();
            }, 100);

            window.showNotification("Configuration Appended", [{ label: "Status", value: "Nodes and links pasted into view!" }]);
            window.closeImportModal();
        } else {
            window.showNotification("Import Failed", [{ label: "Error", value: "Invalid configuration format (no nodes found)" }]);
        }
    } catch (e) {
        console.error("Import Error:", e);
        window.showNotification("Import Failed", [{ label: "Error", value: "Invalid JSON string" }]);
    }
};

document.getElementById('close-btn').addEventListener('click', () => {
    saveData(true);
    app.classList.add('hidden');
    app.style.removeProperty('display');
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST'
    });
});

document.getElementById('delete-node-btn').addEventListener('click', () => {
    if (selectedNode) {
        nodes = nodes.filter(n => n.id !== selectedNode.id);
        connections = connections.filter(c => c.from !== selectedNode.id && c.to !== selectedNode.id);
        selectedNode = null;
        renderCanvas();
        if (inspector) inspector.classList.add('hidden');
    }
});

// Tab Switching
document.querySelectorAll('.tab').forEach(tab => {
    tab.addEventListener('click', () => {
        const tabName = tab.dataset.tab;
        if (tabName === currentTab) return;

        // Update active tab UI
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');

        // Toggle views
        document.querySelectorAll('.tab-view').forEach(view => {
            view.classList.add('hidden');
        });

        if (tabName === 'members') {
            document.getElementById('members-tab').classList.remove('hidden');
            // Reset player selection when switching to members tab
            selectedPlayer = null;
            selectedPlayerInfo.style.display = 'flex';
            memberEditor.classList.add('hidden');
            memberEditor.style.display = 'none';
            refreshPlayersList();
        } else if (tabName === 'departments') {
            document.getElementById('departments-tab').classList.remove('hidden');
            renderCanvas();
        }

        currentTab = tabName;
    });
});

// Members Logic
function refreshPlayersList() {
    fetch(`https://${GetParentResourceName()}/getPlayers`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(data => {
        onlinePlayers = data;
        
        // Update selected player data if they are still online
        if (selectedPlayer) {
            const updated = onlinePlayers.find(p => p.id === selectedPlayer.id);
            if (updated) {
                selectedPlayer = updated;
                // Re-render editor with new data
                document.getElementById('edit-player-name').innerText = selectedPlayer.name;
                document.getElementById('edit-player-id').innerText = `ID: ${selectedPlayer.id}`;
                // Refresh rank select based on possibly new job
                const currentJob = selectedPlayer.jobName;
                const depts = nodes.filter(n => n.type === 'department');
                if (depts.find(d => d.id === currentJob)) {
                    hireDeptSelect.value = currentJob;
                    updateRankSelect(currentJob, selectedPlayer.jobGradeLevel);
                }
            } else {
                // Player went offline
                selectedPlayer = null;
                selectedPlayerInfo.style.display = 'flex';
                memberEditor.classList.add('hidden');
                memberEditor.style.display = 'none';
            }
        }
        
        renderPlayersList();
    });
}

function renderPlayersList() {
    const searchTerm = playerSearch.value.toLowerCase();
    playersList.innerHTML = '';
    
    const filtered = onlinePlayers.filter(p => 
        p.name.toLowerCase().includes(searchTerm) || 
        p.id.toString().includes(searchTerm)
    );

    filtered.forEach(player => {
        const card = document.createElement('div');
        card.className = `player-card ${selectedPlayer && selectedPlayer.id === player.id ? 'active' : ''}`;
        card.innerHTML = `
            <div class="player-icon"><i class="fas fa-user"></i></div>
            <div class="player-info">
                <span class="player-name">${player.name}</span>
                <span class="player-job">${player.jobLabel} (${player.jobGradeLabel})</span>
            </div>
        `;
        card.addEventListener('click', () => selectPlayer(player));
        playersList.appendChild(card);
    });
}

function selectPlayer(player) {
    selectedPlayer = player;
    renderPlayersList();
    
    selectedPlayerInfo.style.display = 'none';
    memberEditor.classList.remove('hidden');
    memberEditor.style.display = 'block';
    
    document.getElementById('edit-player-name').innerText = player.name;
    document.getElementById('edit-player-id').innerText = `ID: ${player.id}`;
    
    // Load departments into select
    hireDeptSelect.innerHTML = '<option value="" disabled selected>Select a department...</option>';
    const depts = nodes.filter(n => n.type === 'department');
    depts.forEach(dept => {
        const option = document.createElement('option');
        option.value = dept.id;
        option.innerText = dept.label;
        hireDeptSelect.appendChild(option);
    });

    // If player already in a managed dept, select it
    const currentJob = player.jobName;
    const matchingDept = depts.find(d => {
        const nodeId = d.id.toLowerCase();
        const frameworkJob = d.frameworkJob ? d.frameworkJob.toLowerCase() : null;
        const searchJob = currentJob.toLowerCase();
        return nodeId === searchJob || frameworkJob === searchJob;
    });
    
    if (matchingDept) {
        hireDeptSelect.value = matchingDept.id;
        updateRankSelect(matchingDept.id, player.jobGradeLevel);
    } else {
        hireRankSelect.innerHTML = '<option value="" disabled selected>Select department first...</option>';
    }
}

function updateRankSelect(deptId, currentGrade = null) {
    hireRankSelect.innerHTML = '';
    
    // Find rank node linked to this department (Search ALL links from this dept)
    const rankLink = connections.find(c => {
        if (c.from !== deptId) return false;
        const targetNode = nodes.find(n => n.id === c.to);
        return targetNode && targetNode.type === 'rank';
    });

    if (!rankLink) {
        hireRankSelect.innerHTML = '<option value="" disabled>No ranks configured for this department</option>';
        return;
    }

    const rankNode = nodes.find(n => n.id === rankLink.to && n.type === 'rank');
    if (!rankNode || !rankNode.ranks) {
        hireRankSelect.innerHTML = '<option value="" disabled>No ranks found</option>';
        return;
    }

    rankNode.ranks.forEach(rank => {
        const option = document.createElement('option');
        option.value = rank.level;
        option.innerText = `${rank.name} (Level ${rank.level})`;
        if (currentGrade !== null && rank.level === currentGrade) {
            option.selected = true;
        }
        hireRankSelect.appendChild(option);
    });
}

hireDeptSelect.addEventListener('change', () => {
    updateRankSelect(hireDeptSelect.value);
});

playerSearch.addEventListener('input', renderPlayersList);
document.getElementById('refresh-players-btn').addEventListener('click', refreshPlayersList);

document.getElementById('confirm-hire-btn').addEventListener('click', () => {
    console.log('Update button clicked');
    console.log('Selected Player:', selectedPlayer);
    console.log('Dept Value:', hireDeptSelect.value);
    console.log('Rank Value:', hireRankSelect.value);

    if (!selectedPlayer || !hireDeptSelect.value || hireRankSelect.value === '') {
        console.log('Validation failed');
        return;
    }
    
    fetch(`https://${GetParentResourceName()}/hirePlayer`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            playerId: selectedPlayer.id,
            job: hireDeptSelect.value,
            grade: parseInt(hireRankSelect.value)
        })
    }).then(() => {
        console.log('Hire request sent');
        refreshPlayersList();
    });
});

document.getElementById('fire-member-btn').addEventListener('click', () => {
    if (!selectedPlayer) return;
    
    console.log('Fire button clicked for player:', selectedPlayer.id);
    
    fetch(`https://${GetParentResourceName()}/hirePlayer`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            playerId: selectedPlayer.id,
            job: 'unemployed',
            grade: 0
        })
    }).then(() => {
        console.log('Fire request sent');
        refreshPlayersList();
    });
});

// --- RADAR SETUP UI ---
window.openRadarSetup = function(data) {
    const container = document.getElementById('radar-setup-container');
    const nameInput = document.getElementById('radar-name-input');
    const limitInput = document.getElementById('radar-limit-input');
    if (data.speedUnit) window.pltSpeedUnit = data.speedUnit;
    
    nameInput.value = "";
    limitInput.value = "80";
    updateSpeedUnitLabels(container);
    
    container.classList.remove('hidden');
    container.style.display = 'flex';
    container.dataset.deptId = data.deptId;
    container.dataset.coords = JSON.stringify(data.coords);
    container.dataset.heading = data.heading;
};

window.confirmRadarSetup = function() {
    const container = document.getElementById('radar-setup-container');
    const nameInput = document.getElementById('radar-name-input');
    const limitInput = document.getElementById('radar-limit-input');
    
    const name = nameInput.value || "Mobile Radar";
    const limit = parseInt(limitInput.value);
    
    if (isNaN(limit) || limit <= 0) {
        return;
    }
    
    fetch(`https://${GetParentResourceName()}/confirmRadarSetup`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            name: name,
            limit: limit,
            deptId: container.dataset.deptId,
            coords: JSON.parse(container.dataset.coords),
            heading: parseFloat(container.dataset.heading)
        })
    });
    
    window.closeRadarSetup();
};

window.closeRadarSetup = function() {
    const container = document.getElementById('radar-setup-container');
    container.classList.add('hidden');
    container.style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeRadarSetup`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};

window.removeRadar = function(radarId) {
    fetch(`https://${GetParentResourceName()}/removeRadar`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ radarId: radarId })
    });
};

window.updateRadarField = function(radarId, field, value) {
    const finalValue = (field === 'limit' || field === 'fineAmount') ? parseInt(value) : value;
    fetch(`https://${GetParentResourceName()}/updateRadarField`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            radarId: radarId, 
            field: field, 
            value: finalValue 
        })
    });
};
