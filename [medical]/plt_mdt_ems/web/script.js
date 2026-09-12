// Safely get elements with error logging
function getEl(id) {
    const el = document.getElementById(id);
    if (!el) console.warn(`[PLT MDT] Element #${id} not found in DOM`);
    return el;
}

// Silence browser console output in production runtime
console.log = () => {};
console.warn = () => {};
console.error = () => {};

const mdtContainer = getEl('mdt-container');
const pages = document.querySelectorAll('.page');
const navTiles = document.querySelectorAll('.nav-tile');
const homeLogoBtn = getEl('home-logo-btn');
const statsBar = document.querySelector('.stats-bar');
const closeBtn = getEl('close-mdt-btn');

// Dashboard Elements
const bolosList = getEl('bolos-list-new');
const warrantsMiniList = getEl('warrants-mini-list');
const recentReportsList = getEl('recent-reports-list');
const notificationFeed = getEl('dispatch-notification-feed');
const onlineUnitsList = getEl('online-units-list');
const addWarrantBtn = getEl('open-create-warrant-new');

if (addWarrantBtn) {
    addWarrantBtn.onclick = () => {
        switchPage('charges');
    };
}

// Page Elements
const profileSearchResults = getEl('profile-search-results');
const vehicleSearchResults = getEl('vehicle-search-results');
const incidentSearchResults = getEl('incident-search-results');
const profileSearchInput = getEl('profile-search-input');
const vehicleSearchInput = getEl('vehicle-search-input');
const incidentSearchInput = getEl('incident-search-input');

// Global Data
let currentProfileData = null;
let currentCitizenData = [];
let currentVehicleData = [];
let currentActiveCitizenId = null;
let currentActiveCalls = []; // Store calls from plt_departments
let hospitalManagementCache = null;
let hospitalManagementLoaded = false;
let hospitalManagementLoading = null;
let canAssignDispatch = true;
let dispatchRoster = [];
let dispatchUnits = [];
let dispatchUiLockUntil = 0;
let dispatchRenderTimeout = null;
let dispatchAlertsRenderTimeout = null;
let liveDispatchNotifications = [];
let liveDispatchIndex = -1;
let enableDispatchLiveNotifications = true;
let mdtLocale = 'en';
let mdtTranslations = {};
let mdtTranslationLookup = null;
const MDT_DEFAULT_EN = {
    app_title: "MDT",
    close: "Close",
    back: "Back",
    save: "Save",
    cancel: "Cancel",
    confirm: "Confirm",
    delete: "Delete",
    create: "Create",
    update: "Update",
    search: "Search",
    loading: "Loading...",
    no_data: "No data found",
    unknown: "Unknown",
    submit: "Submit",
    online: "Online",
    offline: "Offline",
    on_duty: "On Duty",
    off_duty: "Off Duty",
    nav_home: "Home",
    nav_dashboard: "Dashboard",
    nav_profiles: "Profiles",
    nav_vehicles: "Reports",
    nav_medical_records: "Medical Tags Library",
    nav_incidents: "X-Ray",
    nav_warrants: "Warrants",
    nav_charges: "Charges",
    nav_dispatch: "Dispatch",
    nav_officers: "Officers",
    dispatch_title: "Dispatch",
    dispatch_no_recent_alerts: "No recent alerts",
    dispatch_assign: "Assign",
    dispatch_direction: "Direction",
    dispatch_locate: "Locate",
    dispatch_assign_unit_placeholder: "Assign unit...",
    dispatch_no_units_created: "No units created",
    dispatch_no_units_assigned: "No units assigned",
    dispatch_gps_set: "GPS set to alert location.",
    dispatch_no_gps: "No GPS data available for this alert.",
    dispatch_camera_feed: "Camera Feed",
    dispatch_live_cctv: "Live CCTV",
    dispatch_camera_connected: "Connected to selected city camera",
    dispatch_add_camera: "Add Camera",
    dispatch_camera_created: "Dispatch camera created.",
    dispatch_camera_no_permission: "You don't have permission to create cameras.",
    dispatch_camera_exit: "Exit",
    dispatch_notification_title: "Live Dispatch",
    dispatch_notification_dismiss: "Dismiss",
    unit_create: "Create Unit",
    unit_name: "Unit Name",
    unit_add_officer: "Add Officer",
    unit_remove: "Remove Unit",
    unit_available: "Available for assignment",
    personnel_activity: "Personnel Activity",
    no_online_officers: "No online officers",
    officer_profile: "Officer Profile",
    officer_callsign: "Callsign",
    officer_rank: "Rank",
    officer_department: "Department",
    officer_radio_channel: "Radio Channel",
    citizen_profiles: "Citizen Profiles",
    citizen_search_placeholder: "Search citizen by name...",
    citizen_no_results: "No citizens found",
    citizen_notes: "Notes",
    citizen_tags: "Tags",
    vehicle_records: "Vehicle Records",
    vehicle_search_placeholder: "Search plate / model...",
    vehicle_no_results: "No vehicles found",
    vehicle_owner: "Owner",
    vehicle_model: "Model",
    vehicle_plate: "Plate",
    vehicle_status: "Status",
    incidents_title: "Incidents",
    incident_create: "Create Incident",
    incident_search_placeholder: "Search incidents...",
    incident_no_results: "No incidents found",
    incident_evidence: "Evidence",
    incident_officers: "Officers Involved",
    incident_civilians: "Civilians Involved",
    warrants_title: "Warrants",
    warrant_create: "Create Warrant",
    warrant_no_results: "No warrants found",
    warrant_expires: "Expires",
    warrant_status: "Status",
    charges_title: "Criminal Code",
    charges_search_placeholder: "Search charges...",
    charges_no_results: "No charges found",
    charges_category: "Category",
    charges_fine: "Fine",
    charges_jail_time: "Jail Time",
    loading_warrants: "Loading warrants...",
    loading_reports: "Loading reports...",
    dashboard_no_active_bolos: "No active BOLOs",
    dashboard_no_active_warrants: "No active warrants",
    dashboard_no_recent_reports: "No recent reports",
    dashboard_no_notifications: "No notifications",
    dispatch_alert_default_title: "Dispatch Alert",
    dispatch_unknown_location: "Unknown Location",
    dispatch_no_units_online: "No units online",
    dispatch_no_units_created_yet: "No units created yet",
    dispatch_no_members: "No members",
    dispatch_no_available_officers: "No available officers",
    charges_no_selected: "No charges selected",
    charges_no_matching_offenses: "No matching offenses found. Please ensure charges are added to the database.",
    profile_no_vehicles_registered: "No vehicles registered.",
    profile_no_criminal_history: "No criminal history found.",
    profile_no_owner_information: "No owner information found.",
    profile_no_active_bolos_vehicle: "No active BOLOs for this vehicle.",
    incidents_no_description_provided: "No description provided.",
    incidents_no_summary_provided: "No summary provided.",
    incidents_no_linked_profiles: "No linked profiles.",
    warrants_no_title_provided: "No title provided",
    warrants_no_additional_details_provided: "No additional details provided.",
    generic_no_additional_notes: "No additional notes.",
    generic_no_additional_information: "No additional information.",
    bolo_unknown_owner: "Unknown Owner",
    officer_unknown_officer: "Unknown Officer",
    warrant_unknown_subject: "Unknown Subject",
    notify_mdt_loaded: "MDT successfully loaded",
    notify_no_permission: "You don't have permission.",
    notify_action_success: "Action completed successfully.",
    notify_action_failed: "Action failed.",
    notify_invalid_data: "Invalid data provided."
};
let dispatchCameras = [];
let dispatchCameraMarkers = {};
let canManageDispatchCameras = false;
let activeDispatchCameraId = null;
let selectedOfficerMarkerId = null;
let panicAlerts = [];
let mdtServerId = null;
let currentPharmacyData = null;
let currentXrayProfileData = null;
const PRESET_MEDICAL_DISEASES = [
    "Hypertension",
    "Diabetes Type 2",
    "Asthma",
    "Coronary Artery Disease",
    "COPD",
    "Epilepsy",
    "Chronic Kidney Disease",
    "Heart Failure",
    "Pneumonia",
    "Anemia",
    "Sepsis",
    "Migraine",
    "Anxiety Disorder",
    "Depression",
    "PTSD",
    "Allergic Reaction",
    "Fracture",
    "Concussion",
    "Burn Injury",
    "Infection"
];

// Map Context Menu State
let lastMapRightClick = null;
let mapSearchZones = [];
let mapCustomMarkers = [];

function buildMdtTranslationLookup() {
    const allTranslations = (mdtTranslations && typeof mdtTranslations === 'object') ? mdtTranslations : {};
    const enFromConfig = (allTranslations.en && typeof allTranslations.en === 'object') ? allTranslations.en : {};
    const active = (allTranslations[mdtLocale] && typeof allTranslations[mdtLocale] === 'object')
        ? allTranslations[mdtLocale]
        : enFromConfig;
    const lookup = {};

    Object.keys(MDT_DEFAULT_EN).forEach((key) => {
        const base = typeof MDT_DEFAULT_EN[key] === 'string' ? MDT_DEFAULT_EN[key].trim() : '';
        const translatedRaw = active[key];
        const translated = typeof translatedRaw === 'string' ? translatedRaw.trim() : '';
        if (!base || !translated || base === translated) return;
        lookup[base] = translated;
    });

    mdtTranslationLookup = lookup;
}

function getMdtTranslationValue(key, fallback) {
    const allTranslations = (mdtTranslations && typeof mdtTranslations === 'object') ? mdtTranslations : {};
    const enFromConfig = (allTranslations.en && typeof allTranslations.en === 'object') ? allTranslations.en : {};
    const active = (allTranslations[mdtLocale] && typeof allTranslations[mdtLocale] === 'object')
        ? allTranslations[mdtLocale]
        : enFromConfig;

    const fromActive = active && Object.prototype.hasOwnProperty.call(active, key) ? active[key] : undefined;
    if (typeof fromActive === 'string' && fromActive.trim() !== '') return fromActive;

    const fromDefault = MDT_DEFAULT_EN[key];
    if (typeof fromDefault === 'string' && fromDefault.trim() !== '') return fromDefault;

    return fallback;
}

function translateExactText(rawText) {
    if (typeof rawText !== 'string') return rawText;
    if (!mdtTranslationLookup) buildMdtTranslationLookup();
    if (!mdtTranslationLookup) return rawText;
    const trimmed = rawText.trim();
    if (!trimmed) return rawText;
    const translated = mdtTranslationLookup[trimmed];
    if (!translated) return rawText;
    return rawText.replace(trimmed, translated);
}

function applyMdtTranslationsToDom() {
    if (!document || !document.body) return;
    if (!mdtTranslations || !Object.keys(mdtTranslations).length) return;
    if (!mdtTranslationLookup) buildMdtTranslationLookup();
    if (!mdtTranslationLookup || !Object.keys(mdtTranslationLookup).length) return;

    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
    const textNodes = [];
    let node = walker.nextNode();
    while (node) {
        textNodes.push(node);
        node = walker.nextNode();
    }
    textNodes.forEach((textNode) => {
        const nextText = translateExactText(textNode.nodeValue || '');
        if (nextText !== textNode.nodeValue) textNode.nodeValue = nextText;
    });

    document.querySelectorAll('[placeholder],[title]').forEach((el) => {
        if (el.hasAttribute('placeholder')) {
            const oldPlaceholder = el.getAttribute('placeholder') || '';
            const newPlaceholder = translateExactText(oldPlaceholder);
            if (newPlaceholder !== oldPlaceholder) el.setAttribute('placeholder', newPlaceholder);
        }
        if (el.hasAttribute('title')) {
            const oldTitle = el.getAttribute('title') || '';
            const newTitle = translateExactText(oldTitle);
            if (newTitle !== oldTitle) el.setAttribute('title', newTitle);
        }
    });
}

let mdtTranslationApplyTimeout = null;
let mdtTranslationObserver = null;

function scheduleMdtTranslations() {
    if (mdtTranslationApplyTimeout) clearTimeout(mdtTranslationApplyTimeout);
    mdtTranslationApplyTimeout = setTimeout(() => {
        applyMdtTranslationsToDom();
    }, 40);
}

function initMdtTranslationObserver() {
    if (mdtTranslationObserver || !document || !document.body) return;
    mdtTranslationObserver = new MutationObserver(() => {
        scheduleMdtTranslations();
    });

    mdtTranslationObserver.observe(document.body, {
        childList: true,
        subtree: true,
        characterData: true,
        attributes: true,
        attributeFilter: ['placeholder', 'title']
    });
}

initMdtTranslationObserver();

// Navigation
function switchPage(pageId) {
    if (!pageId) return;
    if (pageId === 'fleet' || pageId === 'fleet_equipment' || pageId === 'equipment') {
        pageId = 'vehicles';
    }
    console.log("[PLT MDT] Switching to page:", pageId);

    pages.forEach(page => {
        page.classList.remove('active');
        if (page.id === pageId) {
            page.classList.add('active');

            // Reset to list view if it has sub-pages
            const listView = page.querySelector('.sub-page');
            if (listView) {
                showSubPage(page.id, listView.id);
            }
        }
    });

    if (pageId !== 'dispatch') {
        stopDispatchOfficerPolling();
    }

    // Handle Header Button Toggle (Close vs Back)
    if (closeBtn) {
        const btnIcon = closeBtn.querySelector('i');
        if (btnIcon) {
            if (pageId === 'home') {
                btnIcon.className = 'fas fa-times';
                closeBtn.classList.remove('back-mode');
            } else {
                btnIcon.className = 'fas fa-arrow-left';
                closeBtn.classList.add('back-mode');
            }
        }
    }

    // Handle Stats Bar visibility
    if (statsBar) {
        if (pageId === 'dashboard') {
            statsBar.classList.remove('hidden');
        } else {
            statsBar.classList.add('hidden');
        }
    }

    if (pageId === 'profiles') loadCitizens();
    else if (pageId === 'vehicles') loadVehicles();
    else if (pageId === 'warrants') loadWarrants();
    else if (pageId === 'dispatch') loadDispatch();
    else if (pageId === 'medical_records') {
        renderMedicalRecordsPage();
        loadCharges();
    }
    else if (pageId === 'charges') {
        if (hospitalManagementCache) {
            renderHospitalManagementData(hospitalManagementCache);
        }
        loadHospitalManagement();
    }
    else if (pageId === 'incidents') loadIncidents();
    else if (pageId === 'officers') loadOfficerProfile();
    else if (pageId === 'dashboard' || pageId === 'home') loadDashboard();

    // Re-apply static translation after page switches and sub-rendering.
    setTimeout(() => applyMdtTranslationsToDom(), 0);
}

function formatMoney(amount) {
    const value = Number(amount || 0);
    return `$${value.toLocaleString()}`;
}

function renderHospitalDutyLogs(logs) {
    const list = getEl('hm-duty-logs');
    if (!list) return;

    if (!Array.isArray(logs) || logs.length === 0) {
        list.innerHTML = '<div class="empty-state">No duty logs found.</div>';
        return;
    }

    list.innerHTML = logs.slice(0, 30).map((log) => {
        const action = String(log.action || 'No action');
        const isOn = action.toLowerCase().includes('on');
        const statusLabel = isOn ? 'ON DUTY' : 'OFF DUTY';
        const entryClass = isOn ? 'on' : 'off';
        return `
            <div class="hm-duty-entry ${entryClass}">
                <div class="hm-duty-entry-body">
                    <div class="hm-duty-entry-top">
                        <div class="hm-duty-entry-officer">${(log.officer || 'Unknown').toUpperCase()}</div>
                        <div class="hm-duty-entry-status">${statusLabel}</div>
                    </div>
                    <div class="hm-duty-entry-bottom">
                        <span class="hm-duty-entry-action">${action}</span>
                        <span class="hm-duty-entry-sep">•</span>
                        <span class="hm-duty-entry-time">${log.date || 'N/A'} ${log.time || ''}</span>
                    </div>
                </div>
            </div>
        `;
    }).join('');
}

function renderHospitalFinance(history, currentBalance) {
    const balanceEl = getEl('hm-current-balance');
    if (balanceEl) balanceEl.innerText = formatMoney(currentBalance);

    const list = getEl('hm-finance-list');
    if (!list) return;

    if (!Array.isArray(history) || history.length === 0) {
        list.innerHTML = '<div class="empty-state">No finance transactions yet.</div>';
        return;
    }

    list.innerHTML = history.slice(0, 25).map((tx) => `
        <div class="p-record-card" style="margin-bottom: 8px;">
            <div class="p-record-date">${tx.date || 'N/A'} • ${(tx.author || 'SYSTEM').toUpperCase()}</div>
            <div class="p-record-title">${(tx.type || 'transaction').toUpperCase()} - ${formatMoney(tx.amount || 0)}</div>
            <div class="p-record-desc">${tx.label || 'No label'} • Balance: ${formatMoney(tx.balance || 0)}</div>
        </div>
    `).join('');
}

function renderHospitalInsured(insured) {
    const list = getEl('hm-insured-list');
    if (!list) return;

    if (!Array.isArray(insured) || insured.length === 0) {
        list.innerHTML = '<div class="empty-state">No insured citizens found.</div>';
        return;
    }

    list.innerHTML = insured.slice(0, 40).map((entry) => `
        <div class="p-record-card" style="margin-bottom: 8px;">
            <div class="p-record-title">${(entry.name || entry.cid || 'Unknown').toUpperCase()}</div>
            <div class="p-record-desc">CID: ${entry.cid || 'N/A'}</div>
        </div>
    `).join('');
}

function renderHospitalSnapshot(snapshot) {
    const safe = snapshot || {};
    if (getEl('hm-kpi-onduty')) getEl('hm-kpi-onduty').innerText = String(safe.onDutyCount || 0);
    if (getEl('hm-kpi-members')) getEl('hm-kpi-members').innerText = String(safe.membersCount || 0);
    if (getEl('hm-kpi-insured')) getEl('hm-kpi-insured').innerText = String(safe.insuredCount || 0);
    if (getEl('hm-kpi-calls')) getEl('hm-kpi-calls').innerText = String(safe.activeCalls || 0);
    if (getEl('hm-dept-name')) getEl('hm-dept-name').innerText = String(safe.department || 'ambulance').toUpperCase();
}

function renderHospitalManagementData(data) {
    const snapshot = data && data.snapshot ? data.snapshot : {};
    renderHospitalSnapshot(snapshot);
    renderHospitalDutyLogs((data && data.dutyLogs) || []);
    renderHospitalFinance((data && data.financeHistory) || [], snapshot.currentBalance || 0);
    renderHospitalInsured((data && data.insured) || []);
}

async function loadHospitalManagement(options = {}) {
    const forceRefresh = options && options.forceRefresh === true;

    if (!forceRefresh && hospitalManagementCache) {
        renderHospitalManagementData(hospitalManagementCache);
        if (hospitalManagementLoaded) return hospitalManagementCache;
    }

    if (!forceRefresh && hospitalManagementLoading) {
        return hospitalManagementLoading;
    }

    hospitalManagementLoading = (async () => {
        try {
            const response = await fetch(`https://${GetParentResourceName()}/getHospitalManagementData`, {
                method: 'POST',
                body: JSON.stringify({})
            });
            const data = await response.json();
            hospitalManagementCache = data || {};
            hospitalManagementLoaded = true;
            renderHospitalManagementData(hospitalManagementCache);
            return hospitalManagementCache;
        } catch (err) {
            console.error("[PLT MDT] Error loading hospital management data:", err);
            if (!hospitalManagementCache) {
                renderHospitalDutyLogs([]);
                renderHospitalFinance([], 0);
                renderHospitalInsured([]);
            }
            return null;
        } finally {
            hospitalManagementLoading = null;
        }
    })();

    return hospitalManagementLoading;
}

function updateDispatchPermissionUI() {
    const dispatchPage = getEl('dispatch');
    if (!dispatchPage) return;
    dispatchPage.classList.toggle('dispatch-assign-locked', !canAssignDispatch);
}

function renderLiveDispatchNotification() {
    const toast = getEl('dispatch-live-toast');
    if (!toast) return;
    if (!enableDispatchLiveNotifications) {
        toast.classList.add('hidden');
        return;
    }

    if (!liveDispatchNotifications.length || liveDispatchIndex < 0) {
        toast.classList.add('hidden');
        return;
    }

    const active = liveDispatchNotifications[liveDispatchIndex];
    if (!active) {
        toast.classList.add('hidden');
        return;
    }

    const counterEl = getEl('dispatch-live-toast-counter');
    const codeEl = getEl('dispatch-live-toast-code');
    const messageEl = getEl('dispatch-live-toast-message');
    const locationEl = getEl('dispatch-live-toast-location');
    const timeEl = getEl('dispatch-live-toast-time');

    if (counterEl) counterEl.innerText = `${liveDispatchIndex + 1} / ${liveDispatchNotifications.length}`;
    if (codeEl) codeEl.innerText = `${active.code || 'ALERT'}`;
    
    if (messageEl) {
        let msg = active.title || 'Dispatch Alert';
        if (active.info) msg += ` - ${active.info}`;
        messageEl.innerText = msg;
    }
    
    if (locationEl) locationEl.innerText = `${active.location || 'Unknown Location'}`;
    if (timeEl) {
        const date = new Date(active.localTime || Date.now());
        timeEl.innerText = date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true });
    }

    toast.classList.remove('hidden');
}

function pushLiveDispatchNotification(call) {
    if (!call || typeof call !== 'object') return;
    if (!enableDispatchLiveNotifications) return;

    const exists = liveDispatchNotifications.some(n => String(n.id) === String(call.id));
    if (exists) return;

    liveDispatchNotifications.push({
        id: call.id || `live-${Date.now()}`,
        code: call.code,
        title: call.title,
        info: call.info,
        location: call.location,
        coords: call.coords,
        localTime: Date.now()
    });

    liveDispatchIndex = liveDispatchNotifications.length - 1;
    renderLiveDispatchNotification();
}

function navigateLiveDispatchNotification(direction) {
    if (!enableDispatchLiveNotifications) return;
    if (!liveDispatchNotifications.length) return;
    if (direction === 'left') {
        liveDispatchIndex = (liveDispatchIndex - 1 + liveDispatchNotifications.length) % liveDispatchNotifications.length;
    } else if (direction === 'right') {
        liveDispatchIndex = (liveDispatchIndex + 1) % liveDispatchNotifications.length;
    }
    renderLiveDispatchNotification();
}

async function loadDispatchCameras() {
    try {
        const [cameraResp, permResp] = await Promise.all([
            fetch(`https://${GetParentResourceName()}/getDispatchCameras`, { method: 'POST', body: JSON.stringify({}) }),
            fetch(`https://${GetParentResourceName()}/canManageDispatchCameras`, { method: 'POST', body: JSON.stringify({}) })
        ]);

        dispatchCameras = await cameraResp.json() || [];
        canManageDispatchCameras = (await permResp.json()) === true;
    } catch (_) {
        dispatchCameras = [];
        canManageDispatchCameras = false;
    }

    const addBtn = getEl('dispatch-add-camera-btn');
    if (addBtn) {
        addBtn.style.display = canManageDispatchCameras ? 'flex' : 'none';
    }

    renderDispatchCameraMarkers();
}

function renderDispatchCameraMarkers() {
    if (!map) return;

    const currentIds = new Set((dispatchCameras || []).map(c => String(c.id)));
    Object.keys(dispatchCameraMarkers).forEach(id => {
        if (!currentIds.has(String(id))) {
            map.removeLayer(dispatchCameraMarkers[id]);
            delete dispatchCameraMarkers[id];
        }
    });

    (dispatchCameras || []).forEach(camera => {
        if (!camera || !camera.coords) return;
        const coords = convertCoords(camera.coords.x, camera.coords.y);
        const camIcon = L.divIcon({
            className: 'dispatch-camera-marker',
            html: '<div class="camera-marker-glow"></div><div class="camera-marker-inner"><i class="fas fa-video"></i></div>',
            iconSize: [28, 28],
            iconAnchor: [14, 14]
        });

        if (dispatchCameraMarkers[camera.id]) {
            dispatchCameraMarkers[camera.id].setLatLng(coords);
            return;
        }

        const marker = L.marker(coords, { icon: camIcon, title: camera.label || 'Dispatch Camera' }).addTo(map);
        marker.on('click', () => openDispatchCameraFeed(camera));
        dispatchCameraMarkers[camera.id] = marker;
    });
}

function openDispatchCameraFeed(camera) {
    if (!camera) return;
    activeDispatchCameraId = camera.id;
    fetch(`https://${GetParentResourceName()}/openDispatchCameraFeed`, {
        method: 'POST',
        body: JSON.stringify({ camera })
    })
    .then(resp => resp.json())
    .then(success => {
        if (!success) return;
        if (mdtContainer) mdtContainer.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/closeMDT`, {
            method: 'POST',
            body: JSON.stringify({})
        }).catch(() => {});
    })
    .catch(() => {});
}

function closeDispatchCameraFeed() {
    activeDispatchCameraId = null;
    fetch(`https://${GetParentResourceName()}/closeDispatchCameraFeed`, {
        method: 'POST',
        body: JSON.stringify({})
    }).catch(() => {});
}

async function setWaypointToAlertCoords(alert) {
    const worldCoords = resolveAlertWorldCoords(alert);
    if (!worldCoords) return false;

    try {
        const resp = await fetch(`https://${GetParentResourceName()}/setWaypointToAlert`, {
            method: 'POST',
            body: JSON.stringify({ coords: worldCoords })
        });
        return (await resp.json()) === true;
    } catch (_) {
        return false;
    }
}

function setGpsToLiveNotification() {
    if (!liveDispatchNotifications.length || liveDispatchIndex < 0) return;
    const active = liveDispatchNotifications[liveDispatchIndex];
    if (!active) return;
    setWaypointToAlertCoords(active);
}

function dismissLiveNotification() {
    if (!liveDispatchNotifications.length || liveDispatchIndex < 0) return;
    liveDispatchNotifications.splice(liveDispatchIndex, 1);

    if (!liveDispatchNotifications.length) {
        liveDispatchIndex = -1;
    } else if (liveDispatchIndex >= liveDispatchNotifications.length) {
        liveDispatchIndex = liveDispatchNotifications.length - 1;
    }

    renderLiveDispatchNotification();
}

// Global initialization
window.addEventListener('load', () => {
    loadCharges(); // Pre-load charges for the record creation system
});

async function loadDashboard() {
    console.log("[PLT MDT] loadDashboard called");
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getDashboardData`, {
            method: 'POST',
            body: JSON.stringify({})
        });
        const data = await response.json();
        console.log("[PLT MDT] loadDashboard response data:", data);
        if (data) renderDashboardData(data);
    } catch (err) {
        console.error("[PLT MDT] Error loading dashboard data:", err);
    }
}

// Make globally accessible for HTML onclick
window.switchPage = switchPage;

if (closeBtn) {
    closeBtn.onclick = () => {
        if (closeBtn.classList.contains('back-mode')) {
            switchPage('home');
        } else {
            if (mdtContainer) mdtContainer.style.display = 'none';
            fetch(`https://${GetParentResourceName()}/closeMDT`, { method: 'POST', body: JSON.stringify({}) }).catch(() => {});
        }
    };
}

navTiles.forEach(tile => {
    tile.addEventListener('click', () => {
        if (tile.classList.contains('disabled')) return;
        const pageId = tile.getAttribute('data-page');
        switchPage(pageId);
    });
});

if (homeLogoBtn) {
    homeLogoBtn.addEventListener('click', () => {
        switchPage('home');
    });
}

function showSubPage(pageId, subPageId) {
    const page = document.getElementById(pageId);
    if (!page) return;

    page.querySelectorAll('.sub-page').forEach(sp => {
        sp.classList.remove('active');
        if (sp.id === subPageId) sp.classList.add('active');
    });

    if (pageId === 'profiles') {
        const isProfileOverlay = subPageId === 'profile-record-details' || subPageId === 'profile-create-record';
        page.classList.toggle('profile-record-mode', isProfileOverlay);
    }
}

// Return Buttons
document.querySelectorAll('.return-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        const target = btn.getAttribute('data-target');
        const pageId = btn.closest('.page').id;
        
        // If the target is a main page ID, use switchPage
        if (target === 'medical_records' || target === 'profiles' || target === 'dashboard' || target === 'vehicles') {
            switchPage(target);
        } else {
            showSubPage(pageId, target);
        }

        // If returning to Case Files main view
        if (pageId === 'incidents' && target === 'incident-view') {
            // If we are returning from "Create" and no incident is actually being viewed (ID is placeholder)
            const currentId = getEl('i-id') ? getEl('i-id').innerText : '#0000';
            if (currentId === '#0000') {
                if (incidentContentView) incidentContentView.classList.add('hidden');
                if (incidentListArea) incidentListArea.classList.remove('hidden');
                loadIncidents(); // Refresh the list
            }
        }
    });
});

// Dashboard Rendering
function renderDashboardData(data) {
    console.log("[PLT MDT] Rendering dashboard data:", data);
    if (!data) return;

    // Update Header Stats
    try {
        if (data.stats) {
            if (getEl('stat-active-warrants')) getEl('stat-active-warrants').innerText = data.stats.activeWarrants || '00';
            if (getEl('stat-reports-today')) getEl('stat-reports-today').innerText = `${data.stats.reportsToday || '00'}`;
            if (getEl('stat-recent-calls')) getEl('stat-recent-calls').innerText = `${data.stats.recentCalls || '00'} Waiting`;
            if (getEl('stat-active-calls')) getEl('stat-active-calls').innerText = `${data.stats.activeCalls || '00'} Ongoing`;
        }
    } catch (e) { console.error("[PLT MDT] Error rendering stats:", e); }

    // Integration for active calls from plt_departments
    try {
        if (data && data.calls && Array.isArray(data.calls)) {
            const now = Date.now();
            currentActiveCalls = data.calls.map(newCall => {
                const existingCall = currentActiveCalls.find(c => c.id === newCall.id);
                const mappedAssigned = (existingCall && Array.isArray(existingCall.assignedUnits) && existingCall.assignedUnits.length > 0)
                    ? existingCall.assignedUnits
                    : mapCallUnitsToAssignedUnits(newCall.units);
                const normalizedCoords = resolveAlertWorldCoords({ coords: newCall.coords }) || newCall.coords || null;
                if (existingCall && existingCall.localTime) {
                    return { ...newCall, coords: normalizedCoords, localTime: existingCall.localTime, assignedUnits: mappedAssigned };
                }
                return { ...newCall, coords: normalizedCoords, localTime: now, assignedUnits: mappedAssigned };
            });
            renderDispatchAlerts();
        }
    } catch (e) { console.error("[PLT MDT] Error rendering alerts:", e); }

    // Render BOLOs
    try {
        if (bolosList && data.bolos) {
            bolosList.innerHTML = '';
            if (data.bolos.length === 0) {
                bolosList.innerHTML = '<div class="empty-state">No active BOLOs</div>';
            } else {
                data.bolos.slice(0, 3).forEach(b => {
                    const card = document.createElement('div');
                    card.className = 'bolo-card clickable';
                    card.innerHTML = `
                        <div class="bolo-img">
                            ${b.image && (b.image.startsWith('http') || b.image.startsWith('img/')) ? `<img src="${b.image}">` : '<i class="fas fa-car"></i>'}
                        </div>
                        <div class="bolo-info">
                            <div class="bolo-plate">${b.plate || 'NO PLATE'}</div>
                            <div class="bolo-title">${(b.owner || 'Unknown Owner').toUpperCase()}</div>
                        </div>
                    `;
                    card.onclick = () => {
                        switchPage('incidents');
                        setTimeout(() => {
                            if (incidentSearchInput && b.plate) {
                                incidentSearchInput.value = String(b.plate);
                                searchIncidentSuggestions(String(b.plate), true);
                            }
                        }, 100);
                    };
                    bolosList.appendChild(card);
                });
            }
        }
    } catch (e) { console.error("[PLT MDT] Error rendering BOLOs:", e); }

    // Render Warrants
    try {
        if (warrantsMiniList && data.warrants) {
            warrantsMiniList.innerHTML = '';
            if (data.warrants.length === 0) {
                warrantsMiniList.innerHTML = '<div class="empty-state">No active operation alerts</div>';
            } else {
                data.warrants.slice(0, 4).forEach(w => {
                    const row = document.createElement('div');
                    row.className = 'list-row clickable thin-row';
                    row.innerHTML = `
                        <div>
                            <div class="title">${w.title}</div>
                            <div class="section-desc">${w.citizenid}</div>
                        </div>
                        <span class="status">ACTIVE</span>
                    `;
                    row.onclick = () => {
                        switchPage('charges');
                    };
                    warrantsMiniList.appendChild(row);
                });
            }
        }
    } catch (e) { console.error("[PLT MDT] Error rendering warrants:", e); }

    // Render Incidents
    try {
        if (recentReportsList && data.incidents) {
            recentReportsList.innerHTML = '';
            if (data.incidents.length === 0) {
                recentReportsList.innerHTML = '<div class="empty-state">No recent reports</div>';
            } else {
                data.incidents.slice(0, 4).forEach(inc => {
                    const row = document.createElement('div');
                    row.className = 'list-row clickable thin-row';
                    row.innerHTML = `
                        <div class="row-left">
                            <div class="title">${inc.title}</div>
                        </div>
                        <div class="row-right">
                            <span class="status-badge">${(inc.status || 'Active').split(' ')[0].toUpperCase()}</span>
                        </div>
                    `;
                    row.onclick = () => {
                        switchPage('vehicles');
                    };
                    recentReportsList.appendChild(row);
                });
            }
        }
    } catch (e) { console.error("[PLT MDT] Error rendering incidents:", e); }

    // Render Dispatch Feed
    try {
        if (notificationFeed && data.calls) {
            notificationFeed.innerHTML = '';
            if (data.calls.length === 0) {
                notificationFeed.innerHTML = '<div class="empty-state">No notifications</div>';
            } else {
                data.calls.slice(0, 2).forEach(call => {
                    const item = document.createElement('div');
                    item.className = 'notification-item clickable thin-row';
                    const timeStr = call.localTime ? new Date(call.localTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true }) : new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true });

                    item.innerHTML = `
                        <div class="notif-content">
                            <div class="notif-title">${call.title}</div>
                            <div class="notif-desc">${call.location || 'Unknown'} - ${call.info || ''}</div>
                        </div>
                        <div class="notif-time-badge">
                            <span>${timeStr}</span>
                            <i class="fas fa-clock"></i>
                        </div>
                    `;
                    item.onclick = () => {
                        switchPage('dispatch');
                    };
                    notificationFeed.appendChild(item);
                });
            }
        }
    } catch (e) { console.error("[PLT MDT] Error rendering feed:", e); }
}

function renderDashboardPlaceholders() {
    if (bolosList) {
        bolosList.innerHTML = '<div class="empty-state">No active BOLOs</div>';
    }
    if (warrantsMiniList) {
        warrantsMiniList.innerHTML = '<div class="empty-state">Loading warrants...</div>';
    }
    if (recentReportsList) {
        recentReportsList.innerHTML = '<div class="empty-state">Loading reports...</div>';
    }
    if (notificationFeed) {
        notificationFeed.innerHTML = '<div class="empty-state">No notifications</div>';
    }
}

function renderOnlineUnits(units) {
    if (!onlineUnitsList) return;
    
    // Ensure units is an array
    const officers = Array.isArray(units) ? units : [];
    
    // Update Header Stat
    if (getEl('stat-online-officers')) {
        getEl('stat-online-officers').innerText = `${officers.length} On Duty`;
    }

    onlineUnitsList.innerHTML = '';
    if (officers.length === 0) {
        onlineUnitsList.innerHTML = '<div class="empty-state">No units online</div>';
        return;
    }

    officers.forEach(unit => {
        const row = document.createElement('div');
        row.className = 'list-row clickable thin-row unit-dashboard-row'; // Added specific class
        if (unit.onDuty) row.classList.add('on-duty');
        else row.classList.add('off-duty');

        const avatarImg = (unit.image && (unit.image.startsWith('http') || unit.image.startsWith('img/'))) ? `<img src="${unit.image}" style="width: 100%; height: 100%; object-fit: cover;">` : '<i class="fas fa-user"></i>';
        row.innerHTML = `
            <div class="unit-avatar" style="border-radius: 0;">${avatarImg}</div>
            <div class="unit-info" style="flex: 1; min-width: 0; margin-left: 10px;">
                <h4 style="margin: 0; font-size: 11px; font-weight: 500;">${unit.name || 'Unknown'}</h4>
                <p style="margin: 0; font-size: 9px; color: var(--text-dim); font-weight: 400;"><i class="fas fa-walkie-talkie"></i> ${unit.callsign || 'N/A'}</p>
            </div>
            <div class="duty-indicator"></div>
        `;
        row.onclick = () => {
            switchPage('dispatch');
        };
        onlineUnitsList.appendChild(row);
    });
}

// Profile Search Logic
const profileContentView = getEl('profile-content-area');
const profileEmptyState = getEl('profile-empty-state');

if (profileSearchInput) {
    profileSearchInput.addEventListener('input', (e) => {
        const val = profileSearchInput.value.trim();
        if (val.length >= 2) {
            searchCitizenSuggestions(val);
        } else {
            if (profileSearchResults) profileSearchResults.classList.add('hidden');
        }
    });

    profileSearchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            const val = profileSearchInput.value.trim();
            if (val.length > 0) {
                // Perform direct search or pick first result
                searchCitizenSuggestions(val, true);
            }
        }
    });
}

// Close suggestions when clicking outside
document.addEventListener('click', (e) => {
    if (profileSearchInput && !profileSearchInput.contains(e.target) && profileSearchResults && !profileSearchResults.contains(e.target)) {
        profileSearchResults.classList.add('hidden');
    }
    if (vehicleSearchInput && !vehicleSearchInput.contains(e.target) && vehicleSearchResults && !vehicleSearchResults.contains(e.target)) {
        vehicleSearchResults.classList.add('hidden');
    }
    if (incidentSearchInput && !incidentSearchInput.contains(e.target) && incidentSearchResults && !incidentSearchResults.contains(e.target)) {
        incidentSearchResults.classList.add('hidden');
    }
});

async function searchCitizenSuggestions(query, pickFirst = false) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/searchProfile`, {
            method: 'POST',
            body: JSON.stringify({ query })
        });
        const results = await response.json();
        
        if (results && results.length > 0) {
            if (pickFirst) {
                selectCitizen(results[0].citizenid);
                if (profileSearchResults) profileSearchResults.classList.add('hidden');
            } else {
                renderSuggestions(results);
            }
        } else {
            if (profileSearchResults) profileSearchResults.classList.add('hidden');
            if (pickFirst && profileSearchInput) {
                profileSearchInput.style.borderColor = "#ff3e3e";
                setTimeout(() => { profileSearchInput.style.borderColor = "var(--border-color)"; }, 1000);
            }
        }
    } catch (err) {
        console.error("[PLT MDT] Error searching profile:", err);
    }
}

function renderSuggestions(results) {
    if (!profileSearchResults) return;
    profileSearchResults.innerHTML = '';
    profileSearchResults.classList.remove('hidden');

    results.forEach(res => {
        const char = res.charinfo;
        const div = document.createElement('div');
        div.className = 'suggestion-item';
        div.innerHTML = `
            <span class="s-name">${char.firstname} ${char.lastname}</span>
            <span class="s-cid">${res.citizenid}</span>
        `;
        div.onclick = () => {
            selectCitizen(res.citizenid);
            profileSearchResults.classList.add('hidden');
            if (profileSearchInput) profileSearchInput.value = `${char.firstname} ${char.lastname}`;
        };
        profileSearchResults.appendChild(div);
    });
}

// Profile Record Logic
const addRecordTrigger = getEl('p-add-record-trigger');
const submitRecordBtn = getEl('p-submit-record');
const processSentenceBtn = getEl('p-process-sentence');
const chargeSearchInputProfile = getEl('p-charge-search');
const chargeResultsProfile = getEl('p-charge-results');
const selectedChargesContainer = getEl('p-selected-charges');
const reductionSlider = getEl('p-reduction-slider');
const reductionValueText = getEl('reduction-value');
const recommendedText = getEl('sentence-recommended');
const medicalDiseaseSelect = getEl('p-medical-disease-select');
const medicalDiseaseNote = getEl('p-medical-disease-note');
const addMedicalTimelineEntryBtn = getEl('p-add-medical-timeline-entry');
const addMedicalTagBtnRecords = getEl('mr-add-medical-tag');
const newMedicalTagTitleRecords = getEl('mr-new-tag-title');
const newMedicalTagCategoryRecords = getEl('mr-new-tag-category');
const newMedicalTagDescriptionRecords = getEl('mr-new-tag-description');
const newMedicalTagFineRecords = getEl('mr-new-tag-fine');
const newMedicalTagJailRecords = getEl('mr-new-tag-jail');
const medicalRecordsCreateBtn = getEl('mr-create-tag-btn');

let selectedCharges = [];
let recommendedFine = 0;
let recommendedJail = 0;

function populateMedicalDiseaseOptions() {
    if (!medicalDiseaseSelect) return;
    medicalDiseaseSelect.innerHTML = '<option value="">Select disease...</option>';
    PRESET_MEDICAL_DISEASES.forEach((disease) => {
        const opt = document.createElement('option');
        opt.value = disease;
        opt.innerText = disease;
        medicalDiseaseSelect.appendChild(opt);
    });
}

populateMedicalDiseaseOptions();

if (addRecordTrigger) {
    addRecordTrigger.addEventListener('click', () => {
        if (!currentActiveCitizenId) return;
        showSubPage('profiles', 'profile-create-record');
        resetRecordForm();
    });
}

function resetRecordForm() {
    getEl('p-new-record-title').value = '';
    getEl('p-new-record-time').value = '';
    getEl('p-new-record-location').value = '';
    getEl('p-new-record-image').value = '';
    getEl('p-new-record-desc').value = '';
    getEl('p-new-record-fines').value = 0;
    getEl('p-new-record-jail').value = 0;
    getEl('p-new-record-warrant').value = 'no';
    if (reductionSlider) reductionSlider.value = 0;
    if (reductionValueText) reductionValueText.innerText = '0%';
    selectedCharges = [];
    recommendedFine = 0;
    recommendedJail = 0;
    updateSelectedChargesUI();
    updateSentenceUI();
}

function updateSelectedChargesUI() {
    if (!selectedChargesContainer) return;
    selectedChargesContainer.innerHTML = '';
    
    if (selectedCharges.length === 0) {
        selectedChargesContainer.innerHTML = '<div class="empty-state" style="font-size: 0.93vh; opacity: 0.5; width: 100%; text-align: center; padding: 0.46vh;">No charges selected</div>';
        return;
    }

    selectedCharges.forEach((charge, index) => {
        const pill = document.createElement('div');
        pill.className = 'charge-pill';
        pill.style.background = 'var(--primary-blue-alpha)';
        pill.style.border = '0.09vh solid var(--primary-blue-alpha-06)';
        pill.style.borderRadius = '0.37vh';
        pill.style.padding = '0.18vh 0.46vh';
        pill.style.fontSize = '0.83vh';
        pill.style.display = 'flex';
        pill.style.alignItems = 'center';
        pill.style.gap = '0.46vh';
        pill.innerHTML = `
            <span>${charge.title}</span>
            <i class="fas fa-times clickable" style="opacity: 0.6;"></i>
        `;
        pill.querySelector('.clickable').onclick = () => {
            selectedCharges.splice(index, 1);
            calculateTotals();
            updateSelectedChargesUI();
            updateSentenceUI();
        };
        selectedChargesContainer.appendChild(pill);
    });
}

function calculateTotals() {
    recommendedFine = 0;
    recommendedJail = 0;
    selectedCharges.forEach(c => {
        recommendedFine += c.fine || 0;
        recommendedJail += c.jail || 0;
    });
}

function updateSentenceUI() {
    if (recommendedText) recommendedText.innerText = `REC: $${recommendedFine.toLocaleString()} / ${recommendedJail} Months`;
    
    const reduction = reductionSlider ? parseInt(reductionSlider.value) : 0;
    const finalFine = Math.floor(recommendedFine * (1 - reduction / 100));
    const finalJail = Math.floor(recommendedJail * (1 - reduction / 100));

    const fineInput = getEl('p-new-record-fines');
    const jailInput = getEl('p-new-record-jail');
    
    if (fineInput) fineInput.value = finalFine;
    if (jailInput) jailInput.value = finalJail;
}

function clearMedicalTagFormRecords() {
    if (newMedicalTagTitleRecords) newMedicalTagTitleRecords.value = '';
    if (newMedicalTagCategoryRecords) newMedicalTagCategoryRecords.value = '';
    if (newMedicalTagDescriptionRecords) newMedicalTagDescriptionRecords.value = '';
    if (newMedicalTagFineRecords) newMedicalTagFineRecords.value = 0;
    if (newMedicalTagJailRecords) newMedicalTagJailRecords.value = 0;
}

async function submitMedicalTag(payload, submitBtn, onSuccessClear) {
    if (!payload.title) {
        if (submitBtn) {
            submitBtn.style.background = "#ff3e3e";
            setTimeout(() => { submitBtn.style.background = "var(--primary-blue)"; }, 1000);
        }
        return false;
    }

    try {
        const response = await fetch(`https://${GetParentResourceName()}/addMedicalTag`, {
            method: 'POST',
            body: JSON.stringify(payload)
        });
        const result = await response.json();
        if (result && result.success) {
            if (typeof onSuccessClear === 'function') onSuccessClear();
            await loadCharges();
            Framework.Notify("Medical tag created.", "success");
            return true;
        } else {
            Framework.Notify((result && result.message) || "Failed to create medical tag.", "error");
            return false;
        }
    } catch (err) {
        console.error("[PLT MDT] Error adding medical tag:", err);
        Framework.Notify("Failed to create medical tag.", "error");
        return false;
    }
}

if (reductionSlider) {
    reductionSlider.oninput = () => {
        if (reductionValueText) reductionValueText.innerText = `${reductionSlider.value}%`;
        updateSentenceUI();
    };
}

if (chargeSearchInputProfile) {
    chargeSearchInputProfile.addEventListener('input', () => {
        const val = chargeSearchInputProfile.value.trim().toLowerCase();
        if (val.length < 1 || !Array.isArray(allChargesData)) {
            chargeResultsProfile.innerHTML = '';
            chargeResultsProfile.classList.add('hidden');
            return;
        }

        const filtered = allChargesData.filter(c => 
            (c.title || '').toLowerCase().includes(val) || 
            (c.category || '').toLowerCase().includes(val)
        );

        if (filtered.length > 0) {
            chargeResultsProfile.classList.remove('hidden');
        } else {
            chargeResultsProfile.classList.add('hidden');
        }

        chargeResultsProfile.innerHTML = '';
        filtered.slice(0, 10).forEach(charge => {
            const div = document.createElement('div');
            div.className = 'suggestion-item';
            div.style.padding = '0.46vh 0.93vh';
            div.style.fontSize = '0.93vh';
            div.style.borderBottom = '0.09vh solid rgba(255,255,255,0.03)';
            div.innerHTML = `
                <div style="display: flex; justify-content: space-between;">
                    <span style="font-weight: 600;">${charge.title.toUpperCase()}</span>
                    <span style="opacity: 0.5;">$${charge.fine} / ${charge.jail}M</span>
                </div>
                <div style="font-size: 0.74vh; opacity: 0.4;">${charge.category}</div>
            `;
            div.onclick = () => {
                selectedCharges.push(charge);
                calculateTotals();
                updateSelectedChargesUI();
                updateSentenceUI();
                chargeSearchInputProfile.value = '';
                chargeResultsProfile.innerHTML = '';
                chargeResultsProfile.classList.add('hidden');
            };
            chargeResultsProfile.appendChild(div);
        });
    });
}

if (processSentenceBtn) {
    processSentenceBtn.addEventListener('click', async () => {
        if (!currentActiveCitizenId) return;
        
        const finalFine = parseInt(getEl('p-new-record-fines').value) || 0;
        const finalJail = parseInt(getEl('p-new-record-jail').value) || 0;
        const title = getEl('p-new-record-title').value.trim();

        if (selectedCharges.length === 0) {
            Framework.Notify("Please select at least one charge.", "error");
            return;
        }

        try {
            const response = await fetch(`https://${GetParentResourceName()}/processSentence`, {
                method: 'POST',
                body: JSON.stringify({
                    citizenid: currentActiveCitizenId,
                    fine: finalFine,
                    jail: finalJail,
                    charges: selectedCharges.map(c => c.title).join(', '),
                    title: title || "Sentence Applied"
                })
            });
            const result = await response.json();
            if (result.success) {
                // If it was successful, maybe also submit the record automatically?
                // For now just notify and go back
                Framework.Notify(result.message, "success");
                showSubPage('profiles', 'profile-view');
                selectCitizen(currentActiveCitizenId);
            } else {
                Framework.Notify(result.message, "error");
            }
        } catch (err) {
            console.error("[PLT MDT] Error processing sentence:", err);
        }
    });
}

if (submitRecordBtn) {
    submitRecordBtn.addEventListener('click', async () => {
        const title = getEl('p-new-record-title').value.trim();
        const time = getEl('p-new-record-time').value;
        const location = getEl('p-new-record-location').value.trim();
        const charges = selectedCharges.map(c => c.title).join(', ');
        const image = getEl('p-new-record-image').value.trim();
        const desc = getEl('p-new-record-desc').value.trim();
        const fines = getEl('p-new-record-fines').value || 0;
        const jail = getEl('p-new-record-jail').value || 0;
        const warrant = getEl('p-new-record-warrant').value || 'no';

        if (!title || selectedCharges.length === 0) {
            submitRecordBtn.style.background = "#ff3e3e";
            setTimeout(() => { submitRecordBtn.style.background = "var(--primary-blue)"; }, 1000);
            return;
        }

        try {
            const response = await fetch(`https://${GetParentResourceName()}/createCriminalRecord`, {
                method: 'POST',
                body: JSON.stringify({
                    citizenid: currentActiveCitizenId,
                    title: title,
                    time: time,
                    location: location,
                    charges: charges,
                    image: image,
                    description: desc,
                    fines: fines,
                    jail: jail,
                    warrant: warrant
                })
            });
            const success = await response.json();

            if (success) {
                // Refresh full profile if still on profiles page
                if (currentActiveCitizenId) selectCitizen(currentActiveCitizenId);
                
                resetRecordForm();

                // If it was a warrant, navigate to warrants page to show it
                if (warrant === 'yes') {
                    // Small delay to allow DB insert to propagate
                    setTimeout(() => {
                        switchPage('warrants');
                        loadDashboard(); // Refresh dashboard in background
                    }, 300);
                } else {
                    showSubPage('profiles', 'profile-view');
                }
            }
        } catch (err) {
            console.error("[PLT MDT] Error submitting record:", err);
        }
    });
}

if (addMedicalTagBtnRecords) {
    addMedicalTagBtnRecords.addEventListener('click', async () => {
        const title = newMedicalTagTitleRecords ? String(newMedicalTagTitleRecords.value || '').trim() : '';
        const category = newMedicalTagCategoryRecords ? String(newMedicalTagCategoryRecords.value || '').trim() : '';
        const description = newMedicalTagDescriptionRecords ? String(newMedicalTagDescriptionRecords.value || '').trim() : '';
        const fine = newMedicalTagFineRecords ? Math.max(0, parseInt(newMedicalTagFineRecords.value || '0', 10) || 0) : 0;
        const jail = newMedicalTagJailRecords ? Math.max(0, parseInt(newMedicalTagJailRecords.value || '0', 10) || 0) : 0;
        const created = await submitMedicalTag(
            { title, category, description, fine, jail },
            addMedicalTagBtnRecords,
            clearMedicalTagFormRecords
        );
        if (created) {
            showSubPage('medical_records', 'medical-records-view');
        }
    });
}

if (medicalRecordsCreateBtn) {
    medicalRecordsCreateBtn.addEventListener('click', () => {
        clearMedicalTagFormRecords();
        showSubPage('medical_records', 'medical-records-create');
    });
}

if (addMedicalTimelineEntryBtn) {
    addMedicalTimelineEntryBtn.addEventListener('click', async () => {
        if (!currentActiveCitizenId) return;
        const disease = medicalDiseaseSelect ? String(medicalDiseaseSelect.value || '').trim() : '';
        const note = medicalDiseaseNote ? String(medicalDiseaseNote.value || '').trim() : '';

        if (!disease) {
            addMedicalTimelineEntryBtn.style.background = "#ff3e3e";
            setTimeout(() => { addMedicalTimelineEntryBtn.style.background = "var(--primary-blue)"; }, 1000);
            return;
        }

        try {
            const response = await fetch(`https://${GetParentResourceName()}/addMedicalTimelineEntry`, {
                method: 'POST',
                body: JSON.stringify({
                    citizenid: currentActiveCitizenId,
                    disease: disease,
                    note: note
                })
            });
            const result = await response.json();
            if (result && result.success) {
                if (medicalDiseaseSelect) medicalDiseaseSelect.value = '';
                if (medicalDiseaseNote) medicalDiseaseNote.value = '';
                selectCitizen(currentActiveCitizenId);
            }
        } catch (err) {
            console.error("[PLT MDT] Error adding medical timeline entry:", err);
        }
    });
}

async function toggleLicense(citizenid, type, status) {
    // Optimistic Update for zero lag
    if (currentProfileData && String(currentProfileData.citizenid) === String(citizenid)) {
        let metadata = currentProfileData.metadata || {};
        if (typeof metadata === 'string') {
            try { metadata = JSON.parse(metadata); } catch(e) { metadata = {}; }
        }
        if (!metadata.licences) metadata.licences = {};
        metadata.licences[type] = status;
        currentProfileData.metadata = metadata;
        renderProfileData(currentProfileData);
    }

    try {
        await fetch(`https://${GetParentResourceName()}/toggleLicense`, {
            method: 'POST',
            body: JSON.stringify({ citizenid, type, status })
        });
    } catch (err) {
        console.error("[PLT MDT] Error toggling license:", err);
    }
}

async function updateLicensePoints(citizenid, type, amount) {
    // Optimistic Update for zero lag
    if (currentProfileData && String(currentProfileData.citizenid) === String(citizenid)) {
        let metadata = currentProfileData.metadata || {};
        if (typeof metadata === 'string') {
            try { metadata = JSON.parse(metadata); } catch(e) { metadata = {}; }
        }
        if (!metadata.licences) metadata.licences = {};
        
        const key = type === "driver" ? "points" : "weaponPoints";
        const current = Number(metadata.licences[key]) || 0;
        metadata.licences[key] = Math.max(0, current + amount);
        
        currentProfileData.metadata = metadata;
        renderProfileData(currentProfileData);
    }

    try {
        await fetch(`https://${GetParentResourceName()}/updateLicensePoints`, {
            method: 'POST',
            body: JSON.stringify({ citizenid, type, amount })
        });
    } catch (err) {
        console.error("[PLT MDT] Error updating license points:", err);
    }
}

async function selectCitizen(citizenid) {
    currentActiveCitizenId = citizenid;
    console.log("[PLT MDT] Selecting citizen:", citizenid);
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getFullProfile`, {
            method: 'POST',
            body: JSON.stringify({ citizenid })
        });
        const data = await response.json();
        
        if (data) {
            currentProfileData = data;
            renderProfileData(data);
            if (profileContentView) profileContentView.classList.remove('hidden');
            if (profileEmptyState) profileEmptyState.classList.add('hidden');
        }
    } catch (err) {
        console.error("[PLT MDT] Error loading full profile:", err);
    }
}

function renderProfileData(data) {
    let char = data.charinfo;
    if (typeof char === 'string') {
        try { char = JSON.parse(char); } catch(e) { console.error("Error parsing charinfo:", e); }
    }
    
    if (!char) {
        console.error("[PLT MDT] No character info found in data:", data);
        return;
    }

    const nameEl = getEl('p-name');
    const cidEl = getEl('p-cid');
    const phoneEl = getEl('p-phone');
    const addrEl = getEl('p-address');
    const imgEl = getEl('p-avatar');
    
    if (nameEl) nameEl.innerText = `${char.firstname || ''} ${char.lastname || ''}`;
    if (cidEl) cidEl.innerText = data.citizenid || 'N/A';
    if (phoneEl) phoneEl.innerText = char.phone || 'N/A';
    if (addrEl) addrEl.innerText = char.address || "123 Industrial St, Liberty City";
    
    // Profile Image
    if (imgEl) {
        if (data.p_image && (data.p_image.startsWith('http') || data.p_image.startsWith('img/'))) {
            imgEl.src = data.p_image;
        } else {
            imgEl.src = 'img/placeholder_avatar.png';
        }
    }
    
    // Triage Status
    const threatEl = getEl('p-threat');
    if (threatEl) {
        const vitals = data.vitals || {};
        const isCritical = vitals.isDead === true || Number(vitals.health || 100) <= 35;
        threatEl.classList.remove('low', 'high');

        if (isCritical) {
            threatEl.innerText = "TRIAGE: CRITICAL";
            threatEl.classList.add('high');
            threatEl.style.backgroundColor = "";
            threatEl.style.color = "";
        } else {
            threatEl.innerText = "TRIAGE: STABLE";
            threatEl.classList.add('low');
            threatEl.style.backgroundColor = "";
            threatEl.style.color = "";
        }
    }
    
    // Critical condition toggle UI
    const cardWarrantNoEl = getEl('p-card-warrant-no');
    const cardWarrantYesEl = getEl('p-card-warrant-yes');
    if (cardWarrantNoEl && cardWarrantYesEl) {
        const vitals = data.vitals || {};
        const isCritical = vitals.isDead === true || Number(vitals.health || 100) <= 35;
        if (isCritical) {
            cardWarrantYesEl.classList.add('active');
            cardWarrantNoEl.classList.remove('active');
        } else {
            cardWarrantNoEl.classList.add('active');
            cardWarrantYesEl.classList.remove('active');
        }
    }
    
    // Patient profile quick fields: blood type + known allergy
    const drivingLicenseFill = getEl('skill-driving-license');
    const weaponLicenseFill = getEl('skill-weapon-license');
    const bloodType = (data.blood_type && String(data.blood_type).trim()) || "Unknown";
    const knownAllergy = (data.allergies && String(data.allergies).trim()) || "None";
    const drPointsVal = getEl('driving-points-val');
    const wpPointsVal = getEl('weapon-points-val');

    if (drPointsVal) {
        drPointsVal.innerText = bloodType;
        drPointsVal.classList.remove('warning', 'danger');
    }
    if (wpPointsVal) {
        wpPointsVal.innerText = knownAllergy;
        wpPointsVal.classList.remove('warning', 'danger');
    }

    if (drivingLicenseFill) {
        drivingLicenseFill.style.width = `100%`;
        drivingLicenseFill.style.backgroundColor = "var(--primary-blue)";
    }
    if (weaponLicenseFill) {
        weaponLicenseFill.style.width = `100%`;
        weaponLicenseFill.style.backgroundColor = "var(--primary-blue)";
    }

    // Medical imaging (x-rays)
    const assetsContainer = getEl('p-assets-container');
    if (assetsContainer) {
        assetsContainer.innerHTML = '';
        if (data.xrays && data.xrays.length > 0) {
            data.xrays.slice(0, 8).forEach((xray, idx) => {
                let injuryText = "No findings recorded";
                if (Array.isArray(xray.injuries) && xray.injuries.length > 0) {
                    injuryText = xray.injuries.map((entry) => {
                        if (typeof entry === 'string') return entry;
                        if (entry && entry.bone) return entry.bone;
                        return "Unknown injury";
                    }).join(", ");
                }
                const div = document.createElement('div');
                div.className = 'p-asset-item';
                div.innerHTML = `
                    <span class="v-name">XRAY #${idx + 1}</span>
                    <span class="v-type">${xray.date || 'Date N/A'}</span>
                    <span class="v-plate">${injuryText}</span>
                `;
                assetsContainer.appendChild(div);
            });
        } else {
            assetsContainer.innerHTML = '<div class="empty-state">No x-ray scans recorded.</div>';
        }
    }

    // Medical tags library (available tags for note creation/billing)
    renderMedicalTagsLibrary();
    
    // Patient medical history (timeline)
    const recordsList = getEl('p-records-list');
    if (recordsList && data.medicalTimeline) {
        recordsList.innerHTML = '';
        if (data.medicalTimeline.length === 0) {
            recordsList.innerHTML = '<div class="empty-state">No medical history found.</div>';
        } else {
            data.medicalTimeline.forEach((record, index) => {
                const card = document.createElement('div');
                card.className = 'p-record-card';
                card.innerHTML = `
                    <div class="p-record-date">${record.date || 'N/A'} <span style="color: var(--primary-blue)">[${record.type || 'REPORT'}]</span></div>
                    <div class="p-record-title">${String(record.title || 'UNTITLED').toUpperCase()}</div>
                    <div class="p-record-divider"></div>
                    <div class="p-record-image">
                        <i class="fas fa-file-medical"></i>
                    </div>
                    <button class="p-record-btn ${index === 0 ? 'active' : ''}">View</button>
                `;

                card.querySelector('.p-record-btn').onclick = () => openRecordDetails({
                    id: record.id,
                    type: record.type,
                    title: record.title,
                    created_at: record.created_at,
                    location: record.location,
                    officer: record.officer,
                    charges: record.charges,
                    description: record.description,
                    fines: record.fines,
                    jail: record.jail,
                    warrant: record.warrant,
                    image: record.image
                });
                recordsList.appendChild(card);
            });
        }
    }
}

function renderMedicalTagsLibrary() {
    const recordsList = getEl('mr-records-list'); // Repurposed for Medical Records page
    if (recordsList) {
        recordsList.innerHTML = '';
        if (!Array.isArray(allChargesData) || allChargesData.length === 0) {
            recordsList.innerHTML = '<div class="mr-empty-state">No medical tags found.</div>';
            return;
        }

        const sortedTags = [...allChargesData].sort((a, b) => String(a.title || '').localeCompare(String(b.title || '')));
        sortedTags.forEach((tag, index) => {
            const card = document.createElement('div');
            card.className = 'mr-tag-row'; // Changed to match Medical Records page style
            card.innerHTML = `
                <div class="mr-col-tag">
                    <span class="mr-tag-name">${String(tag.title || 'Untitled Tag').toUpperCase()}</span>
                    <span class="mr-tag-desc">${String(tag.description || 'Medical tag with no description.')}</span>
                </div>
                <div class="mr-col-category">${String(tag.category || 'General Care')}</div>
                <div class="mr-col-fee">$${Number(tag.fine || 0).toLocaleString()}</div>
                <div class="mr-col-rest">${Number(tag.jail || 0)} DAYS</div>
                <div class="mr-col-action">
                    <button class="mr-open-btn">OPEN</button>
                </div>
            `;

            const openTagDetails = () => openRecordDetails({
                title: tag.title || 'Medical Tag',
                created_at: null,
                location: tag.category || 'General Care',
                officer: 'EMS TAG',
                charges: `$${Number(tag.fine || 0).toLocaleString()} / ${Number(tag.jail || 0)} days`,
                description: tag.description || 'Medical tag with no description.'
            });

            card.addEventListener('click', openTagDetails);
            const openBtn = card.querySelector('.mr-open-btn');
            if (openBtn) {
                openBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    openTagDetails();
                });
            }
            recordsList.appendChild(card);
        });
    }
}

function renderMedicalRecordsPage() {
    // Handled by renderMedicalTagsLibrary
}

function openRecordDetails(record) {
    if (!record) return;

    // Determine return target if not provided
    if (!record.fromPage) {
        const activePage = document.querySelector('.page.active');
        if (activePage && activePage.id !== 'profiles') {
            record.fromPage = activePage.id;
        }
    }

    // Switch to profiles page and the details sub-page
    switchPage('profiles');
    showSubPage('profiles', 'profile-record-details');

    // Ensure content area is visible (fixes "ENTER CITIZEN NAME" issue)
    if (profileContentView) profileContentView.classList.remove('hidden');
    if (profileEmptyState) profileEmptyState.classList.add('hidden');

    // Handle Return button target
    const returnBtn = document.querySelector('#profile-record-details .return-btn');
    if (returnBtn) {
        if (record.fromPage && record.fromPage !== 'profiles') {
            returnBtn.setAttribute('data-target', record.fromPage);
        } else {
            returnBtn.setAttribute('data-target', 'profile-view');
        }
    }

    const titleEl = getEl('p-detail-title');
    const timeEl = getEl('p-detail-time');
    const locEl = getEl('p-detail-location');
    const offEl = getEl('p-detail-officer');
    const chargesEl = getEl('p-detail-charges');
    const descEl = getEl('p-detail-desc');
    const finesEl = getEl('p-detail-fines');
    const jailEl = getEl('p-detail-jail');
    const warrantEl = getEl('p-detail-warrant');
    const imgBox = getEl('p-detail-image-box');
    const imgEl = getEl('p-detail-image');

    const deleteBtn = getEl('p-delete-record-btn');
    const completeWarrantBtn = getEl('p-complete-warrant-btn');

    if (titleEl) titleEl.innerText = (record.title || 'UNKNOWN').toUpperCase();
    
    let timeDisplay = 'N/A';
    if (record.created_at) {
        const d = new Date(record.created_at);
        if (!isNaN(d.getTime())) {
            timeDisplay = d.toLocaleString();
        }
    }
    if (timeEl) timeEl.innerText = timeDisplay;
    
    if (locEl) locEl.innerText = record.location || 'N/A';
    if (offEl) offEl.innerText = record.officer || 'SYSTEM';
    if (chargesEl) chargesEl.innerText = record.charges || 'None';
    if (descEl) descEl.innerText = record.description || 'No additional notes.';

    if (finesEl) {
        finesEl.innerText = `$${Number(record.fines || 0).toLocaleString()}`;
    }
    
    if (jailEl) {
        jailEl.innerText = `${record.jail || 0} MONTHS`;
    }
    
    if (warrantEl) {
        warrantEl.innerText = (record.warrant === 'yes' || record.type === 'WARRANT') ? 'YES' : 'NO';
        warrantEl.style.color = (record.warrant === 'yes' || record.type === 'WARRANT') ? '#ff3e3e' : 'white';
    }

    if (imgBox && imgEl) {
        if (record.image && (record.image.startsWith('http') || record.image.startsWith('img/'))) {
            imgEl.src = record.image;
            imgBox.classList.remove('hidden');
        } else {
            imgBox.classList.add('hidden');
        }
    }

    // Handle Action Buttons
    if (deleteBtn) deleteBtn.style.display = 'none';
    if (completeWarrantBtn) completeWarrantBtn.style.display = 'none';

    if (record.type === 'WARRANT') {
        if (completeWarrantBtn) {
            completeWarrantBtn.style.display = 'block';
            completeWarrantBtn.onclick = async () => {
                const response = await fetch(`https://${GetParentResourceName()}/completeWarrant`, {
                    method: 'POST',
                    body: JSON.stringify({ id: record.id })
                });
                if (await response.json()) {
                    selectCitizen(currentActiveCitizenId); // Refresh profile
                    showSubPage('profiles', 'profile-view');
                }
            };
        }
        if (deleteBtn) {
            deleteBtn.style.display = 'block';
            deleteBtn.innerText = "CANCEL WARRANT";
            deleteBtn.onclick = async () => {
                const response = await fetch(`https://${GetParentResourceName()}/deleteWarrant`, {
                    method: 'POST',
                    body: JSON.stringify({ id: record.id })
                });
                if (await response.json()) {
                    selectCitizen(currentActiveCitizenId); // Refresh profile
                    showSubPage('profiles', 'profile-view');
                }
            };
        }
    } else {
        if (deleteBtn) {
            deleteBtn.style.display = 'block';
            deleteBtn.innerText = "DELETE RECORD";
            deleteBtn.onclick = async () => {
                const response = await fetch(`https://${GetParentResourceName()}/deleteRecord`, {
                    method: 'POST',
                    body: JSON.stringify({ id: record.id })
                });
                if (await response.json()) {
                    selectCitizen(currentActiveCitizenId); // Refresh profile
                    showSubPage('profiles', 'profile-view');
                }
            };
        }
    }

    showSubPage('profiles', 'profile-record-details');
}

// Vehicle Search Logic
const vehicleContentView = getEl('vehicle-content-area');
const vehicleEmptyState = getEl('vehicle-empty-state');
const fleetStatusCard = getEl('fe-active-status-card');
const fleetMaintenanceState = getEl('fe-maintenance-state');
const fleetMaintenanceNote = getEl('fe-maintenance-note');
const fleetRefreshBtn = getEl('fe-refresh-btn');
const fleetFlagBrokenBtn = getEl('fe-flag-broken-btn');
const fleetMarkRepairedBtn = getEl('fe-mark-repaired-btn');
const fleetEquipmentSelect = getEl('fe-equipment-select');
const fleetEquipmentStatus = getEl('fe-equipment-status');
const fleetEquipmentNote = getEl('fe-equipment-note');
const fleetAddLogBtn = getEl('fe-add-log-btn');
const fleetLogsList = getEl('fe-logs-list');
const reportsListContainer = getEl('r-reports-list');
const createReportBtn = getEl('r-create-report-btn');
const submitReportBtn = getEl('r-submit-report');
const reportTitleInput = getEl('r-title');
const reportNoteInput = getEl('r-note');
const reportTagSearchInput = getEl('r-tag-search');
const reportTagResults = getEl('r-tag-results');
const reportSelectedTags = getEl('r-selected-tags');
let selectedReportTags = [];
let currentActiveFleetVehicle = null;
let currentFleetMaintenance = { isBroken: false, note: "", updatedAt: null, updatedBy: null };

if (vehicleSearchInput) {
    vehicleSearchInput.addEventListener('input', (e) => {
        const val = vehicleSearchInput.value.trim();
        if (val.length >= 2) {
            searchVehicleSuggestions(val);
        } else {
            if (vehicleSearchResults) vehicleSearchResults.classList.add('hidden');
        }
    });

    vehicleSearchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            const val = vehicleSearchInput.value.trim();
            if (val.length > 0) {
                searchVehicleSuggestions(val, true);
            }
        }
    });
}

async function refreshFleetEquipmentData() {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getFleetEquipmentData`, {
            method: 'POST',
            body: JSON.stringify({})
        });
        const data = await response.json();

        currentActiveFleetVehicle = data && data.activeVehicle ? data.activeVehicle : null;
        currentFleetMaintenance = (data && data.maintenance) || { isBroken: false, note: "", updatedAt: null, updatedBy: null };

        renderFleetStatusCard(currentActiveFleetVehicle, currentFleetMaintenance);
        renderEquipmentLogs((data && data.equipmentLogs) || []);
    } catch (err) {
        console.error("[PLT MDT] Error loading fleet/equipment data:", err);
    }
}

function renderFleetStatusCard(activeVehicle, maintenance) {
    if (!fleetStatusCard) return;

    if (!activeVehicle) {
        fleetStatusCard.innerHTML = `
            <div class="p-asset-item">
                <span class="v-name">NO ACTIVE EMS UNIT</span>
                <span class="v-type">Enter an Ambulance or Air-Med vehicle to sync status.</span>
                <span class="v-plate"><i class="fas fa-circle-info"></i> STANDBY</span>
            </div>
        `;
        if (fleetMaintenanceState) fleetMaintenanceState.innerText = "NORMAL";
        return;
    }

    const engine = Number(activeVehicle.engineHealth || 0);
    const body = Number(activeVehicle.bodyHealth || 0);
    const fuel = Number(activeVehicle.fuel || 0);
    const badge = maintenance && maintenance.isBroken ? "BROKEN" : "READY";

    fleetStatusCard.innerHTML = `
        <div class="p-asset-item">
            <span class="v-name">${(activeVehicle.unitType || 'Ambulance').toUpperCase()} • ${(activeVehicle.model || 'UNKNOWN').toUpperCase()}</span>
            <span class="v-type">Plate: ${(activeVehicle.plate || 'N/A').toUpperCase()}</span>
            <span class="v-plate">Status: ${badge}</span>
        </div>
        <div class="p-asset-item">
            <span class="v-name">Engine ${engine}% • Body ${body}% • Fuel ${fuel}%</span>
            <span class="v-type">Updated: ${(maintenance && maintenance.updatedAt) || 'Live'}</span>
            <span class="v-plate">${(maintenance && maintenance.note) ? maintenance.note : 'No maintenance note'}</span>
        </div>
    `;

    if (fleetMaintenanceState) {
        fleetMaintenanceState.innerText = maintenance && maintenance.isBroken ? "BROKEN - MECHANIC REQUIRED" : "NORMAL";
    }
}

function renderEquipmentLogs(logs) {
    if (!fleetLogsList) return;

    if (!logs || logs.length === 0) {
        fleetLogsList.innerHTML = '<div class="empty-state">No equipment logs recorded.</div>';
        return;
    }

    fleetLogsList.innerHTML = logs.slice(0, 20).map(log => `
        <div class="p-record-card" style="margin-bottom: 8px;">
            <div class="p-record-date">${log.time || 'N/A'} • ${(log.author || 'Unknown').toUpperCase()}</div>
            <div class="p-record-title">${(log.equipment || 'EQUIPMENT').toUpperCase()} - ${(log.status || 'UNKNOWN').toUpperCase()}</div>
            <div class="p-record-desc">${log.note && log.note !== '' ? log.note : 'No note attached.'}</div>
        </div>
    `).join('');
}

if (fleetRefreshBtn) {
    fleetRefreshBtn.addEventListener('click', () => {
        refreshFleetEquipmentData();
    });
}

if (fleetAddLogBtn) {
    fleetAddLogBtn.addEventListener('click', async () => {
        const equipment = fleetEquipmentSelect ? fleetEquipmentSelect.value : "";
        const status = fleetEquipmentStatus ? fleetEquipmentStatus.value : "";
        const note = fleetEquipmentNote ? fleetEquipmentNote.value.trim() : "";
        if (!equipment || !status) return;

        try {
            const response = await fetch(`https://${GetParentResourceName()}/addEquipmentLog`, {
                method: 'POST',
                body: JSON.stringify({ equipment, status, note })
            });
            const success = await response.json();
            if (success) {
                if (fleetEquipmentNote) fleetEquipmentNote.value = '';
                refreshFleetEquipmentData();
            }
        } catch (err) {
            console.error("[PLT MDT] Error adding equipment log:", err);
        }
    });
}

async function setFleetMaintenance(isBroken) {
    if (!currentActiveFleetVehicle) return;
    const note = fleetMaintenanceNote ? fleetMaintenanceNote.value.trim() : "";

    try {
        const response = await fetch(`https://${GetParentResourceName()}/setFleetMaintenance`, {
            method: 'POST',
            body: JSON.stringify({
                activeVehicle: currentActiveFleetVehicle,
                isBroken: isBroken,
                note: note
            })
        });
        const success = await response.json();
        if (success) {
            refreshFleetEquipmentData();
        }
    } catch (err) {
        console.error("[PLT MDT] Error setting fleet maintenance state:", err);
    }
}

if (fleetFlagBrokenBtn) {
    fleetFlagBrokenBtn.addEventListener('click', () => setFleetMaintenance(true));
}
if (fleetMarkRepairedBtn) {
    fleetMarkRepairedBtn.addEventListener('click', () => setFleetMaintenance(false));
}

function renderSelectedReportTags() {
    if (!reportSelectedTags) return;
    reportSelectedTags.innerHTML = '';
    if (!selectedReportTags.length) {
        reportSelectedTags.innerHTML = '<div class="empty-state" style="font-size: 0.93vh; opacity: 0.5; width: 100%; text-align: center; padding: 0.46vh;">No tags selected</div>';
        return;
    }

    selectedReportTags.forEach((tag, index) => {
        const pill = document.createElement('div');
        pill.className = 'charge-pill';
        pill.style.background = 'var(--primary-blue-alpha)';
        pill.style.border = '0.09vh solid var(--primary-blue-alpha-06)';
        pill.style.borderRadius = '0.37vh';
        pill.style.padding = '0.18vh 0.46vh';
        pill.style.fontSize = '0.83vh';
        pill.style.display = 'flex';
        pill.style.alignItems = 'center';
        pill.style.gap = '0.46vh';
        pill.innerHTML = `
            <span>${tag.title}</span>
            <i class="fas fa-times clickable" style="opacity: 0.6;"></i>
        `;
        pill.querySelector('.clickable').onclick = () => {
            selectedReportTags.splice(index, 1);
            renderSelectedReportTags();
        };
        reportSelectedTags.appendChild(pill);
    });
}

function renderReportsList(reports) {
    if (!reportsListContainer) return;
    reportsListContainer.innerHTML = '';
    const totalEl = getEl('r-kpi-total');
    const taggedEl = getEl('r-kpi-tagged');
    const untaggedEl = getEl('r-kpi-untagged');

    const total = Array.isArray(reports) ? reports.length : 0;
    const tagged = Array.isArray(reports) ? reports.filter((r) => Array.isArray(r.tags) && r.tags.length > 0).length : 0;
    const untagged = Math.max(0, total - tagged);
    if (totalEl) totalEl.innerText = String(total);
    if (taggedEl) taggedEl.innerText = String(tagged);
    if (untaggedEl) untaggedEl.innerText = String(untagged);

    if (!Array.isArray(reports) || reports.length === 0) {
        reportsListContainer.innerHTML = '<div class="mr-empty-state">No reports created yet.</div>';
        return;
    }

    reports.forEach((report) => {
        const row = document.createElement('article');
        row.className = 'report-card';
        const tags = Array.isArray(report.tags) ? report.tags.join(', ') : String(report.tags || '');
        const tagsCount = Array.isArray(report.tags) ? report.tags.length : (tags && tags !== 'None' ? 1 : 0);
        row.innerHTML = `
            <div class="report-card-top">
                <span class="report-chip report-chip-author">${String(report.author || 'EMS')}</span>
                <span class="report-chip report-chip-date">${String(report.date || 'N/A')}</span>
            </div>
            <h4 class="report-card-title">${String(report.title || 'UNTITLED REPORT').toUpperCase()}</h4>
            <p class="report-card-note">${String(report.note || 'No note provided.')}</p>
            <div class="report-card-meta">
                <span class="report-chip report-chip-tags">TAGS ${tagsCount}</span>
                <span class="report-tags-preview">${tags !== '' ? tags : 'None'}</span>
            </div>
            <div class="report-card-footer">
                <button class="reports-open-btn">OPEN REPORT</button>
            </div>
        `;

        const openReport = () => {
            // Check if we have a patient linked to this report
            if (report.citizenid) {
                switchPage('profiles');
                selectCitizen(report.citizenid);
                // We don't have a direct "open report" in profile yet, 
                // but at least it takes them to the right patient.
            } else {
                openRecordDetails({
                    title: report.title || 'Medical Report',
                    created_at: report.created_at || report.date,
                    location: report.location || 'EMS Department',
                    officer: report.author || 'EMS',
                    charges: tags !== '' ? tags : 'None',
                    description: report.note || 'No note provided.',
                    fines: 0,
                    jail: 0,
                    warrant: 'no'
                });
            }
        };

        row.addEventListener('click', openReport);
        const btn = row.querySelector('.reports-open-btn');
        if (btn) {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                openReport();
            });
        }

        reportsListContainer.appendChild(row);
    });
}

async function fetchReports() {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getReports`, {
            method: 'POST',
            body: JSON.stringify({})
        });
        const data = await response.json();
        renderReportsList(data || []);
    } catch (err) {
        renderReportsList([]);
    }
}

function resetReportForm() {
    if (reportTitleInput) reportTitleInput.value = '';
    if (reportNoteInput) reportNoteInput.value = '';
    if (reportTagSearchInput) reportTagSearchInput.value = '';
    if (reportTagResults) {
        reportTagResults.innerHTML = '';
        reportTagResults.classList.add('hidden');
    }
    selectedReportTags = [];
    renderSelectedReportTags();
}

if (createReportBtn) {
    createReportBtn.addEventListener('click', () => {
        resetReportForm();
        showSubPage('vehicles', 'reports-create');
    });
}

if (reportTagSearchInput) {
    reportTagSearchInput.addEventListener('input', () => {
        if (!reportTagResults) return;
        const val = reportTagSearchInput.value.trim().toLowerCase();
        if (val.length < 1 || !Array.isArray(allChargesData)) {
            reportTagResults.innerHTML = '';
            reportTagResults.classList.add('hidden');
            return;
        }
        const filtered = allChargesData.filter((c) =>
            (c.title || '').toLowerCase().includes(val) ||
            (c.category || '').toLowerCase().includes(val)
        );
        reportTagResults.innerHTML = '';
        if (!filtered.length) {
            reportTagResults.classList.add('hidden');
            return;
        }
        reportTagResults.classList.remove('hidden');
        filtered.slice(0, 12).forEach((charge) => {
            const div = document.createElement('div');
            div.className = 'suggestion-item';
            div.style.padding = '0.46vh 0.93vh';
            div.style.fontSize = '0.93vh';
            div.style.borderBottom = '0.09vh solid rgba(255,255,255,0.03)';
            div.innerHTML = `
                <div style="display:flex; justify-content:space-between;">
                    <span style="font-weight:600;">${String(charge.title || '').toUpperCase()}</span>
                    <span style="opacity:0.5;">${String(charge.category || 'General')}</span>
                </div>
            `;
            div.onclick = () => {
                const exists = selectedReportTags.some((tag) => String(tag.title || '').toLowerCase() === String(charge.title || '').toLowerCase());
                if (!exists) {
                    selectedReportTags.push(charge);
                    renderSelectedReportTags();
                }
                reportTagSearchInput.value = '';
                reportTagResults.innerHTML = '';
                reportTagResults.classList.add('hidden');
            };
            reportTagResults.appendChild(div);
        });
    });
}

if (submitReportBtn) {
    submitReportBtn.addEventListener('click', async () => {
        const title = reportTitleInput ? reportTitleInput.value.trim() : '';
        const note = reportNoteInput ? reportNoteInput.value.trim() : '';
        if (!title || !note) {
            submitReportBtn.style.background = "#ff3e3e";
            setTimeout(() => { submitReportBtn.style.background = "var(--primary-blue)"; }, 1000);
            return;
        }
        try {
            const response = await fetch(`https://${GetParentResourceName()}/createReport`, {
                method: 'POST',
                body: JSON.stringify({
                    title: title,
                    note: note,
                    tags: selectedReportTags.map((t) => t.title)
                })
            });
            const result = await response.json();
            if (result && result.success) {
                showSubPage('vehicles', 'reports-view');
                resetReportForm();
                fetchReports();
            }
        } catch (_) {}
    });
}

async function searchVehicleSuggestions(query, pickFirst = false) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/searchVehicle`, {
            method: 'POST',
            body: JSON.stringify({ query })
        });
        const results = await response.json();
        
        if (results && results.length > 0) {
            if (pickFirst) {
                selectVehicle(results[0].plate);
                if (vehicleSearchResults) vehicleSearchResults.classList.add('hidden');
            } else {
                renderVehicleSuggestions(results);
            }
        } else {
            if (vehicleSearchResults) vehicleSearchResults.classList.add('hidden');
        }
    } catch (err) {
        console.error("[PLT MDT] Error searching vehicle:", err);
    }
}

function renderVehicleSuggestions(results) {
    if (!vehicleSearchResults) return;
    vehicleSearchResults.innerHTML = '';
    vehicleSearchResults.classList.remove('hidden');

    results.forEach(res => {
        const div = document.createElement('div');
        div.className = 'suggestion-item';
        div.innerHTML = `
            <span class="s-name">${res.plate}</span>
            <span class="s-cid">${(res.vehicle || 'Unknown').toUpperCase()}</span>
        `;
        div.onclick = () => {
            selectVehicle(res.plate);
            vehicleSearchResults.classList.add('hidden');
            if (vehicleSearchInput) vehicleSearchInput.value = res.plate;
        };
        vehicleSearchResults.appendChild(div);
    });
}

// Vehicle Marker Logic
const addMarkerTrigger = getEl('v-add-marker-trigger');
const submitMarkerBtn = getEl('v-submit-marker');
const vehicleCameraBtn = getEl('v-camera-btn');
let currentActivePlate = null;

if (vehicleCameraBtn) {
    vehicleCameraBtn.addEventListener('click', () => {
        if (mdtContainer) mdtContainer.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/takeMDTPhoto`, {
            method: 'POST',
            body: JSON.stringify({ context: 'vehicle-bolo' })
        });
    });
}

if (addMarkerTrigger) {
    addMarkerTrigger.addEventListener('click', () => {
        if (!currentActivePlate) return;
        showSubPage('vehicles', 'vehicle-create-marker');
    });
}

if (submitMarkerBtn) {
    submitMarkerBtn.addEventListener('click', async () => {
        const title = getEl('v-new-marker-title').value.trim();
        const image = getEl('v-new-marker-image').value.trim();
        const desc = getEl('v-new-marker-desc').value.trim();

        if (!title || !desc) {
            submitMarkerBtn.style.background = "#ff3e3e";
            setTimeout(() => { submitMarkerBtn.style.background = "var(--primary-blue)"; }, 1000);
            return;
        }

        try {
            submitMarkerBtn.disabled = true; // Disable button to prevent double-click
            const response = await fetch(`https://${GetParentResourceName()}/createVehicleBolo`, {
                method: 'POST',
                body: JSON.stringify({
                    plate: currentActivePlate,
                    title: title,
                    image: image,
                    description: desc
                })
            });
            const success = await response.json();

            if (success) {
                // Small delay to ensure DB commit before refresh
                setTimeout(() => {
                    fetch(`https://${GetParentResourceName()}/getDashboardData`, {
                        method: 'POST',
                        body: JSON.stringify({})
                    }).then(resp => resp.json()).then(data => {
                        if (data) renderDashboardData(data);
                    });
                }, 300);

                // Refresh vehicle details
                selectVehicle(currentActivePlate);
                // Reset and return
                getEl('v-new-marker-title').value = '';
                getEl('v-new-marker-image').value = '';
                getEl('v-new-marker-desc').value = '';
                showSubPage('vehicles', 'vehicle-view');
            }
        } catch (err) {
            console.error("[PLT MDT] Error submitting vehicle marker:", err);
        } finally {
            submitMarkerBtn.disabled = false; // Re-enable button
        }
    });
}

function openVehicleMarkerDetails(bolo) {
    if (!bolo) return;

    showSubPage('vehicles', 'vehicle-marker-details');

    const titleEl = getEl('v-detail-title');
    const timeEl = getEl('v-detail-time');
    const plateEl = getEl('v-detail-plate');
    const descEl = getEl('v-detail-desc');
    const imgBox = getEl('v-detail-image-box');
    const imgEl = getEl('v-detail-image');
    const deleteBtn = getEl('v-delete-marker-btn');

    if (titleEl) titleEl.innerText = (bolo.title || 'ACTIVE BOLO ALERT').toUpperCase();
    if (timeEl) timeEl.innerText = new Date(bolo.created_at).toLocaleString();
    if (plateEl) plateEl.innerText = currentActivePlate || 'N/A';
    if (descEl) descEl.innerText = bolo.description || 'No additional notes.';

    if (imgBox && imgEl) {
        if (bolo.image && (bolo.image.startsWith('http') || bolo.image.startsWith('img/'))) {
            imgEl.src = bolo.image;
            imgBox.classList.remove('hidden');
        } else {
            imgBox.classList.add('hidden');
        }
    }

    if (deleteBtn) {
        deleteBtn.onclick = async () => {
            try {
                const response = await fetch(`https://${GetParentResourceName()}/deleteVehicleBolo`, {
                    method: 'POST',
                    body: JSON.stringify({ id: bolo.id })
                });
                if (await response.json()) {
                    selectVehicle(currentActivePlate); // Refresh
                    showSubPage('vehicles', 'vehicle-view');
                }
            } catch (err) {
                console.error("[PLT MDT] Error deleting vehicle bolo:", err);
            }
        };
    }
}

async function selectVehicle(plate) {
    currentActivePlate = plate;
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getVehicleDetails`, {
            method: 'POST',
            body: JSON.stringify({ plate })
        });
        const data = await response.json();
        
        if (data) {
            renderVehicleData(data);
            if (vehicleContentView) vehicleContentView.classList.remove('hidden');
            if (vehicleEmptyState) vehicleEmptyState.classList.add('hidden');
            refreshFleetEquipmentData();
        }
    } catch (err) {
        console.error("[PLT MDT] Error loading vehicle details:", err);
    }
}

function renderVehicleData(data) {
    const plateEl = getEl('v-plate');
    const platePreviewEl = getEl('v-plate-preview-text');
    const modelEl = getEl('v-model');
    const classEl = getEl('v-class');
    const colorEl = getEl('v-color');
    const statusEl = getEl('v-status');
    const ownerContainer = getEl('v-owner-card');
    
    const normalizedPlate = String(data.plate || 'N/A').toUpperCase().replace(/\s+/g, '');
    if (plateEl) plateEl.innerText = normalizedPlate;
    if (platePreviewEl) platePreviewEl.innerText = normalizedPlate;
    if (modelEl) modelEl.innerText = (data.vehicle || 'UNKNOWN').toUpperCase();
    if (classEl) classEl.innerText = "Personal"; // Dynamic class if you have it
    if (colorEl) colorEl.innerText = data.color || "Factory";
    
    if (statusEl) {
        const isStolen = data.stolen || false;
        statusEl.innerText = isStolen ? "Status: STOLEN" : "Status: REGISTERED";
        statusEl.style.borderColor = isStolen ? "#e74c3c" : "#2ecc71";
        statusEl.style.color = isStolen ? "#e74c3c" : "#2ecc71";
        statusEl.style.background = isStolen ? "rgba(231, 76, 60, 0.1)" : "rgba(46, 204, 113, 0.1)";
    }

    // Owner Info
    if (ownerContainer) {
        ownerContainer.innerHTML = '';
        if (data.ownerData) {
            const char = data.ownerData.charinfo;
            const div = document.createElement('div');
            div.className = 'p-asset-item';
            div.style.cursor = 'pointer';
            div.innerHTML = `
                <span class="v-name">${char.firstname} ${char.lastname}</span>
                <span class="v-type">${data.citizenid}</span>
                <span class="v-plate"><i class="fas fa-external-link-alt"></i> PROFILE</span>
            `;
            div.onclick = () => {
                switchPage('profiles');
                selectCitizen(data.citizenid);
            };
            ownerContainer.appendChild(div);
        } else {
            ownerContainer.innerHTML = '<div class="empty-state">No owner information found.</div>';
        }
    }

    // BOLOs (Markers)
    const markersList = getEl('v-markers-list');
    if (markersList) {
        markersList.innerHTML = '';
        if (data.bolos && data.bolos.length > 0) {
            data.bolos.forEach(bolo => {
                const card = document.createElement('div');
                card.className = 'p-record-card';
                
                let imageHtml = '';
                if (bolo.image && (bolo.image.startsWith('http') || bolo.image.startsWith('img/'))) {
                    imageHtml = `
                        <div class="record-image-preview" style="width: 100%; height: 85px; margin-top: 5px; overflow: hidden; border-radius: 4px; border: 1px solid rgba(255,255,255,0.1);">
                            <img src="${bolo.image}" style="width: 100%; height: 100%; object-fit: cover;">
                        </div>
                    `;
                } else {
                    // Placeholder if no image, to maintain layout consistency
                    imageHtml = `
                        <div class="record-image-preview" style="width: 100%; height: 85px; margin-top: 5px; display: flex; align-items: center; justify-content: center; background: rgba(255,255,255,0.02); border-radius: 4px; border: 1px dashed rgba(255,255,255,0.05);">
                            <i class="fas fa-image" style="opacity: 0.1; font-size: 20px;"></i>
                        </div>
                    `;
                }

                card.innerHTML = `
                    <div class="p-record-date">${new Date(bolo.created_at).toLocaleDateString()} <span style="color: #e74c3c">[BOLO]</span></div>
                    <div class="p-record-title" style="white-space: normal; line-height: 1.1; height: 32px; display: flex; align-items: center; justify-content: center;">${(bolo.title || 'ACTIVE BOLO ALERT').toUpperCase()}</div>
                    ${imageHtml}
                    <button class="p-record-btn" style="margin-top: auto;">Access</button>
                `;
                
                card.querySelector('.p-record-btn').onclick = () => {
                    openVehicleMarkerDetails(bolo);
                };

                markersList.appendChild(card);
            });
        } else {
            markersList.innerHTML = '<div class="empty-state">No active BOLOs for this vehicle.</div>';
        }
    }
}

function openVehicleMarkerDetails(bolo) {
    if (!bolo) return;

    showSubPage('vehicles', 'vehicle-marker-details');

    const titleEl = getEl('v-detail-title');
    const timeEl = getEl('v-detail-time');
    const plateEl = getEl('v-detail-plate');
    const descEl = getEl('v-detail-desc');
    const imgBox = getEl('v-detail-image-box');
    const imgEl = getEl('v-detail-image');
    const deleteBtn = getEl('v-delete-marker-btn');

    if (titleEl) titleEl.innerText = (bolo.title || 'ACTIVE BOLO ALERT').toUpperCase();
    if (plateEl) plateEl.innerText = bolo.plate || currentActivePlate || 'N/A';
    
    if (timeEl) {
        const d = new Date(bolo.created_at);
        timeEl.innerText = !isNaN(d.getTime()) ? d.toLocaleString() : 'N/A';
    }
    
    if (descEl) descEl.innerText = bolo.description || 'No additional notes.';

    if (imgBox && imgEl) {
        if (bolo.image && (bolo.image.startsWith('http') || bolo.image.startsWith('img/'))) {
            imgEl.src = bolo.image;
            imgBox.classList.remove('hidden');
        } else {
            imgBox.classList.add('hidden');
        }
    }

    if (deleteBtn) {
        deleteBtn.onclick = async () => {
            try {
                const response = await fetch(`https://${GetParentResourceName()}/deleteVehicleBolo`, {
                    method: 'POST',
                    body: JSON.stringify({ id: bolo.id })
                });
                if (await response.json()) {
                    selectVehicle(currentActivePlate); // Refresh
                    showSubPage('vehicles', 'vehicle-view');
                }
            } catch (err) {
                console.error("[PLT MDT] Error deleting BOLO:", err);
            }
        };
    }
}

// Case Files Logic
// Incident Search Logic
const incidentContentView = getEl('incident-content-area');
const incidentListArea = getEl('incident-list-area');
const incidentListGrid = getEl('incident-list-grid');
const addIncidentTrigger = getEl('i-header-create-btn'); // Updated ID
const submitIncidentBtn = getEl('i-submit-incident');

let currentActiveIncident = null;

if (addIncidentTrigger) {
    addIncidentTrigger.addEventListener('click', () => {
        // Clear hidden ID to signal a new creation
        getEl('i-form-id').value = '';
        getEl('incident-form-title').innerText = 'CREATE NEW CASE FILE';
        
        // Reset form
        getEl('i-new-title').value = '';
        getEl('i-new-citizenid').value = '';
        getEl('i-new-image').value = '';
        getEl('i-new-summary').value = '';
        getEl('i-new-description').value = '';
        getEl('i-new-status').value = 'Active Investigation';

        // Ensure the content area is visible so the sub-page can be seen
        if (incidentContentView) incidentContentView.classList.remove('hidden');
        if (incidentListArea) incidentListArea.classList.add('hidden');
        showSubPage('incidents', 'incident-create');
    });
}

const editIncidentTrigger = getEl('i-edit-incident-trigger');
if (editIncidentTrigger) {
    editIncidentTrigger.addEventListener('click', () => {
        if (!currentActiveIncident) return;

        // Populate form for editing
        getEl('i-form-id').value = currentActiveIncident.id;
        getEl('incident-form-title').innerText = 'EDIT CASE FILE #' + currentActiveIncident.id;
        
        getEl('i-new-title').value = currentActiveIncident.title || '';
        getEl('i-new-citizenid').value = currentActiveIncident.citizenid || '';
        getEl('i-new-image').value = currentActiveIncident.image || '';
        getEl('i-new-summary').value = currentActiveIncident.summary || '';
        getEl('i-new-description').value = currentActiveIncident.description || '';
        getEl('i-new-status').value = currentActiveIncident.status || 'Active Investigation';

        showSubPage('incidents', 'incident-create');
    });
}

const incidentCameraBtn = getEl('i-camera-btn');
if (incidentCameraBtn) {
    incidentCameraBtn.addEventListener('click', () => {
        if (mdtContainer) mdtContainer.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/takeMDTPhoto`, {
            method: 'POST',
            body: JSON.stringify({ context: 'incident-evidence' })
        });
    });
}

if (submitIncidentBtn) {
    submitIncidentBtn.addEventListener('click', async () => {
        const id = getEl('i-form-id').value;
        const title = getEl('i-new-title').value.trim();
        const status = getEl('i-new-status').value;
        const citizenid = getEl('i-new-citizenid').value.trim();
        const image = getEl('i-new-image').value.trim();
        const summary = getEl('i-new-summary').value.trim();
        const desc = getEl('i-new-description').value.trim();

        if (!title || !desc) {
            submitIncidentBtn.style.background = "#ff3e3e";
            setTimeout(() => { submitIncidentBtn.style.background = "var(--primary-blue)"; }, 1000);
            return;
        }

        try {
            const isEditing = id && id !== '';
            const endpoint = isEditing ? 'updateCaseFile' : 'createCaseFile';
            const payload = {
                title: title,
                status: status,
                citizenid: citizenid,
                image: image,
                summary: summary,
                description: desc
            };
            if (isEditing) payload.id = parseInt(id);

            const response = await fetch(`https://${GetParentResourceName()}/${endpoint}`, {
                method: 'POST',
                body: JSON.stringify(payload)
            });
            const result = await response.json();

            if (result) {
                // Reset form
                getEl('i-new-title').value = '';
                getEl('i-new-citizenid').value = '';
                getEl('i-new-image').value = '';
                getEl('i-new-summary').value = '';
                getEl('i-new-description').value = '';
                
                // Show newly created/edited incident
                const targetId = isEditing ? parseInt(id) : result;
                if (typeof targetId === 'number') {
                    selectIncident(targetId);
                } else {
                    loadIncidents();
                }
            } else {
                // Feedback for failure
                submitIncidentBtn.style.background = "#ff3e3e";
                submitIncidentBtn.innerText = "ERROR SAVING CASE";
                setTimeout(() => { 
                    submitIncidentBtn.style.background = "var(--primary-blue)"; 
                    submitIncidentBtn.innerHTML = '<i class="fas fa-save"></i> FINALIZE CASE FILE';
                }, 2000);
            }
        } catch (err) {
            console.error("[PLT MDT] Error submitting case file:", err);
            submitIncidentBtn.style.background = "#ff3e3e";
            submitIncidentBtn.innerText = "CONNECTION ERROR";
            setTimeout(() => { 
                submitIncidentBtn.style.background = "var(--primary-blue)"; 
                submitIncidentBtn.innerHTML = '<i class="fas fa-save"></i> FINALIZE CASE FILE';
            }, 2000);
        }
    });
}

if (incidentSearchInput) {
    incidentSearchInput.addEventListener('input', (e) => {
        const val = incidentSearchInput.value.trim();
        if (val.length >= 2) {
            searchIncidentSuggestions(val);
        } else if (incidentSearchResults) {
            incidentSearchResults.classList.add('hidden');
        }
    });

    incidentSearchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            const val = incidentSearchInput.value.trim();
            if (val.length > 0) searchIncidentSuggestions(val, true);
        }
    });
}

async function searchIncidentSuggestions(query, pickFirst = false) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/searchProfile`, {
            method: 'POST',
            body: JSON.stringify({ query })
        });
        const results = await response.json();

        if (results && results.length > 0) {
            if (pickFirst) {
                const char = results[0].charinfo || {};
                const name = `${char.firstname || ''} ${char.lastname || ''}`.trim();
                if (incidentSearchInput && name) incidentSearchInput.value = name;
                await selectXrayCitizen(results[0].citizenid);
                if (incidentSearchResults) incidentSearchResults.classList.add('hidden');
            } else {
                renderIncidentSuggestions(results);
            }
        } else if (incidentSearchResults) {
            incidentSearchResults.classList.add('hidden');
            if (pickFirst && incidentSearchInput) {
                incidentSearchInput.style.borderColor = "#ff3e3e";
                setTimeout(() => { incidentSearchInput.style.borderColor = "var(--border-color)"; }, 1000);
            }
        }
    } catch (err) {
        console.error("[PLT MDT] Error searching x-ray patients:", err);
    }
}

function renderIncidentSuggestions(results) {
    if (!incidentSearchResults) return;
    incidentSearchResults.innerHTML = '';
    if (!Array.isArray(results) || results.length === 0) {
        incidentSearchResults.classList.add('hidden');
        return;
    }

    incidentSearchResults.classList.remove('hidden');
    results.slice(0, 15).forEach((res) => {
        const char = res.charinfo || {};
        const name = `${char.firstname || ''} ${char.lastname || ''}`.trim() || 'Unknown Patient';
        const div = document.createElement('div');
        div.className = 'suggestion-item';
        div.innerHTML = `
            <span class="s-name">${name.toUpperCase()}</span>
            <span class="s-cid">${res.citizenid || 'N/A'}</span>
        `;
        div.onclick = async () => {
            incidentSearchResults.classList.add('hidden');
            if (incidentSearchInput) incidentSearchInput.value = name;
            await selectXrayCitizen(res.citizenid);
        };
        incidentSearchResults.appendChild(div);
    });
}

async function selectIncident(incidentId) {
    await selectXrayCitizen(incidentId);
}

async function selectXrayCitizen(citizenid) {
    if (!citizenid) return;
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getFullProfile`, {
            method: 'POST',
            body: JSON.stringify({ citizenid })
        });
        const data = await response.json();
        currentXrayProfileData = data || null;
        renderIncidentList(currentXrayProfileData);
    } catch (err) {
        console.error("[PLT MDT] Error loading x-ray patient:", err);
    }
}

function getXrayPartKey(entry) {
    const raw = String((entry && (entry.part || entry.bone || entry.name)) || '').toLowerCase();
    if (raw.includes('head') || raw.includes('skull')) return 'head';
    if (raw.includes('chest') || raw.includes('torso') || raw.includes('spine') || raw.includes('rib')) return 'chest';
    if (raw.includes('left') && (raw.includes('arm') || raw.includes('hand'))) return 'left_arm';
    if (raw.includes('right') && (raw.includes('arm') || raw.includes('hand'))) return 'right_arm';
    if (raw.includes('left') && (raw.includes('leg') || raw.includes('foot'))) return 'left_leg';
    if (raw.includes('right') && (raw.includes('leg') || raw.includes('foot'))) return 'right_leg';
    if (raw.includes('arm') || raw.includes('hand')) return 'left_arm';
    if (raw.includes('leg') || raw.includes('foot')) return 'left_leg';
    return 'chest';
}

function getXrayImagePath(entry, healthy = false) {
    const part = getXrayPartKey(entry);
    const type = String((entry && entry.type) || '').toLowerCase();
    const isBroken = !healthy && (type.includes('fracture') || type.includes('bullet') || type.includes('broken'));
    const fileMap = {
        head: { healthy: 'head-healthy.png', broken: 'head-broken.png' },
        chest: { healthy: 'chest-healthy.png', broken: 'chest-broken.png' },
        left_arm: { healthy: 'left-hand-healthy.png', broken: 'left-hand-broken.png' },
        right_arm: { healthy: 'right-hand-healthy.png', broken: 'right-hand-broken.png' },
        left_leg: { healthy: 'left-leg-healthy.png', broken: 'left-leg-broken.png' },
        right_leg: { healthy: 'right-leg-healthy.png', broken: 'right-leg-broken.png' }
    };
    const file = fileMap[part][isBroken ? 'broken' : 'healthy'];
    return `nui://plt_xray/assets/${file}`;
}

function normalizeXrayInjuries(xray) {
    let injuries = xray && xray.injuries;
    if (typeof injuries === 'string') {
        try { injuries = JSON.parse(injuries); } catch (e) { injuries = []; }
    }
    return Array.isArray(injuries) ? injuries : [];
}

function formatXrayFinding(entry) {
    if (typeof entry === 'string') return entry;
    const part = String((entry && (entry.part || entry.bone || entry.name)) || 'Body').replace(/_/g, ' ');
    const type = String((entry && entry.type) || 'finding').replace(/_/g, ' ');
    return `${part} ${type}`.toUpperCase();
}

function renderXrayPatientSummary(data) {
    const char = data && data.charinfo ? data.charinfo : {};
    const name = data ? (`${char.firstname || ''} ${char.lastname || ''}`.trim() || data.name || 'Unknown Patient') : 'NO PATIENT SELECTED';
    const skeletonImg = getEl('xray-healthy-skeleton');
    const skeletonMissing = skeletonImg ? skeletonImg.nextElementSibling : null;
    if (skeletonImg) {
        if (data) {
            skeletonImg.onerror = () => {
                skeletonImg.style.display = 'none';
                if (skeletonMissing) skeletonMissing.style.display = 'flex';
            };
            skeletonImg.onload = () => {
                skeletonImg.style.display = 'block';
                if (skeletonMissing) skeletonMissing.style.display = 'none';
            };
            if (!skeletonImg.getAttribute('src')) {
                skeletonImg.src = skeletonImg.dataset.src || 'nui://plt_mdt_ems/web/img/healthy.png';
            } else {
                skeletonImg.style.display = 'block';
            }
        } else {
            skeletonImg.removeAttribute('src');
            skeletonImg.style.display = 'none';
            if (skeletonMissing) skeletonMissing.style.display = 'none';
        }
    }
    if (getEl('xray-patient-name')) getEl('xray-patient-name').innerText = name.toUpperCase();
    if (getEl('xray-patient-cid')) getEl('xray-patient-cid').innerText = (data && data.citizenid) || 'N/A';
    if (getEl('xray-patient-blood')) getEl('xray-patient-blood').innerText = (data && data.blood_type) || 'Unknown';
    if (getEl('xray-patient-allergies')) getEl('xray-patient-allergies').innerText = (data && data.allergies) || 'None';
    if (getEl('xray-results-title')) getEl('xray-results-title').innerText = data ? 'LINKED X-RAY IMAGES' : 'SEARCH A PATIENT';
}

function renderIncidentList(profileData) {
    if (!incidentListGrid) return;
    incidentListGrid.innerHTML = '';
    renderXrayPatientSummary(profileData);

    if (!profileData) {
        const empty = document.createElement('div');
        empty.className = 'xray-empty-state';
        empty.innerHTML = '<i class="fas fa-x-ray"></i><p>SEARCH A PATIENT NAME OR CID TO VIEW X-RAY RECORDS</p>';
        incidentListGrid.appendChild(empty);
        return;
    }

    const xrays = Array.isArray(profileData.xrays) ? profileData.xrays : [];
    if (xrays.length === 0) {
        const empty = document.createElement('div');
        empty.className = 'xray-empty-state';
        empty.innerHTML = '<i class="fas fa-bone"></i><p>NO X-RAY SCANS RECORDED FOR THIS PATIENT</p>';
        incidentListGrid.appendChild(empty);
        return;
    }

    xrays.forEach((xray, index) => {
        const injuries = normalizeXrayInjuries(xray);
        const previewEntries = injuries.length > 0 ? injuries : [{ part: 'chest', type: 'healthy' }];
        const findingText = injuries.length > 0 ? injuries.map(formatXrayFinding).join(', ') : 'NO FINDINGS RECORDED';
        const card = document.createElement('div');
        card.className = 'xray-scan-card';
        card.innerHTML = `
            <div class="xray-scan-card-head">
                <div>
                    <span class="case-id">XRAY #${index + 1}</span>
                    <h3 class="case-title">${xray.date || xray.timestamp || 'DATE N/A'}</h3>
                </div>
                <div class="case-status-pill ${injuries.length > 0 ? 'status-pending-review' : 'status-closed'}">
                    ${injuries.length > 0 ? `${injuries.length} FINDING${injuries.length > 1 ? 'S' : ''}` : 'HEALTHY'}
                </div>
            </div>
            <div class="xray-image-strip">
                ${previewEntries.slice(0, 6).map((entry) => `
                    <div class="xray-linked-image">
                        <img src="${getXrayImagePath(entry, injuries.length === 0)}" alt="X-ray scan" style="width: 100%; max-width: 10vh; height: 7.4vh; object-fit: contain;">
                        <span>${formatXrayFinding(entry)}</span>
                    </div>
                `).join('')}
            </div>
            <div class="case-meta">
                <span><i class="fas fa-clipboard-list"></i> Findings: ${findingText}</span>
                <span><i class="fas fa-link"></i> Images linked from plt_xray assets.</span>
            </div>
        `;
        incidentListGrid.appendChild(card);
    });
}

async function loadIncidents() {
    if (incidentContentView) incidentContentView.classList.add('hidden');
    if (incidentListArea) incidentListArea.classList.remove('hidden');
    if (addIncidentTrigger) addIncidentTrigger.style.display = 'none';
    if (incidentSearchInput) {
        incidentSearchInput.placeholder = 'Search patient name or CID...';
    }
    renderIncidentList(currentXrayProfileData);
}

function getEmsAccessTag(item) {
    if (item && item.professionalOnly && item.prescriptionRequired) return 'EMS + RX';
    if (item && item.professionalOnly) return 'EMS ONLY';
    if (item && item.prescriptionRequired) return 'RX REQUIRED';
    return 'STANDARD';
}

function getOperationalPriority(item) {
    const label = String((item && item.label) || '').toLowerCase();
    const name = String((item && item.name) || '').toLowerCase();
    const combined = `${label} ${name}`;
    if (combined.includes('medkit') || combined.includes('bandage')) return 'CRITICAL';
    if (combined.includes('oxygen') || combined.includes('bp') || combined.includes('surgical')) return 'HIGH';
    if (combined.includes('antibiotic') || combined.includes('painkiller')) return 'MEDIUM';
    return 'NORMAL';
}

function getCostTier(item) {
    const price = Number((item && item.price) || 0);
    if (price >= 1200) return 'VERY HIGH';
    if (price >= 600) return 'HIGH';
    if (price >= 250) return 'MEDIUM';
    return 'LOW';
}

function renderPharmacyList(incidents, query = '') {
    if (!incidentListGrid) return;
    incidentListGrid.innerHTML = '';

    const pharmacy = (incidents && typeof incidents === 'object') ? incidents : {};
    const allItems = Array.isArray(pharmacy.items) ? pharmacy.items : [];
    const normalizedQuery = String(query || '').trim().toLowerCase();
    const items = allItems.filter((item) => {
        if (!normalizedQuery) return true;
        const label = String(item.label || '').toLowerCase();
        const name = String(item.name || '').toLowerCase();
        return label.includes(normalizedQuery) || name.includes(normalizedQuery);
    });

    const discountPct = Math.max(0, Math.round((1 - Number(pharmacy.insuranceDiscount || 1)) * 100));
    const prescriptions = Array.isArray(pharmacy.prescriptions) ? pharmacy.prescriptions : [];
    const emsOnlyCount = allItems.filter((item) => item && item.professionalOnly).length;
    const rxRequiredCount = allItems.filter((item) => item && item.prescriptionRequired).length;
    const criticalCount = allItems.filter((item) => getOperationalPriority(item) === 'CRITICAL').length;
    const expensiveCount = allItems.filter((item) => getCostTier(item) === 'VERY HIGH' || getCostTier(item) === 'HIGH').length;

    const overviewCard = document.createElement('div');
    overviewCard.className = 'case-card';
    overviewCard.innerHTML = `
        <div class="case-card-header">
            <span class="case-id">EMS FORMULARY OVERVIEW</span>
            <span class="case-date">Total items: ${allItems.length}</span>
            <div class="case-status-pill status-active-investigation">READ ONLY</div>
        </div>
        <div class="case-card-body">
            <h3 class="case-title">OPERATIONAL MEDICATION PROFILE</h3>
            <div class="case-meta">
                <span><i class="fas fa-user-shield"></i> EMS-only items: ${emsOnlyCount}</span>
                <span><i class="fas fa-file-prescription"></i> RX-required items: ${rxRequiredCount}</span>
                <span><i class="fas fa-triangle-exclamation"></i> Critical supplies: ${criticalCount}</span>
                <span><i class="fas fa-sack-dollar"></i> High-cost items: ${expensiveCount}</span>
                <span><i class="fas fa-percent"></i> Insurance discount policy: ${discountPct}%</span>
            </div>
            <div class="case-meta" style="margin-top: 0.7vh;">
                <span><i class="fas fa-circle-info"></i> Use this tab for decision support, not purchasing.</span>
                <span><i class="fas fa-clipboard-check"></i> Prioritize CRITICAL/HIGH items for station restock plans.</span>
            </div>
        </div>
    `;
    incidentListGrid.appendChild(overviewCard);

    const rxCard = document.createElement('div');
    rxCard.className = 'case-card';
    rxCard.innerHTML = `
        <div class="case-card-header">
            <span class="case-id">PRESCRIPTION LOAD</span>
            <span class="case-date">Tracked prescriptions</span>
            <div class="case-status-pill status-pending-review">${prescriptions.length} ACTIVE</div>
        </div>
        <div class="case-card-body">
            <h3 class="case-title">RX OPERATIONS SNAPSHOT</h3>
            <div class="case-meta">
                <span><i class="fas fa-notes-medical"></i> Active scripts in player inventory: ${prescriptions.length}</span>
                <span><i class="fas fa-vial"></i> RX-only formulary items: ${rxRequiredCount}</span>
                <span><i class="fas fa-user-doctor"></i> EMS professional formulary: ${emsOnlyCount}</span>
            </div>
        </div>
    `;
    incidentListGrid.appendChild(rxCard);

    if (items.length === 0) {
        const empty = document.createElement('div');
        empty.className = 'profile-empty';
        empty.innerHTML = '<i class="fas fa-pills"></i><p>NO LEGACY ITEMS FOUND</p>';
        incidentListGrid.appendChild(empty);
        return;
    }

    items.forEach((item) => {
        const priority = getOperationalPriority(item);
        const access = getEmsAccessTag(item);
        const costTier = getCostTier(item);
        const basePrice = Number(item.price || 0);

        const card = document.createElement('div');
        card.className = 'case-card';
        card.innerHTML = `
            <div class="case-card-header">
                <span class="case-id">${(item.name || 'ITEM').toUpperCase()}</span>
                <span class="case-date">${access}</span>
                <div class="case-status-pill status-active-investigation">${priority}</div>
            </div>
            <div class="case-card-body">
                <h3 class="case-title">${(item.label || item.name || 'Unknown Item').toUpperCase()}</h3>
                <div class="case-meta">
                    <span><i class="fas fa-tags"></i> Cost tier: ${costTier}</span>
                    <span><i class="fas fa-receipt"></i> Reference price: ${formatMoney(basePrice)}</span>
                    <span><i class="fas fa-notes-medical"></i> Prescription required: ${item.prescriptionRequired ? 'YES' : 'NO'}</span>
                    <span><i class="fas fa-helmet-safety"></i> EMS restricted: ${item.professionalOnly ? 'YES' : 'NO'}</span>
                </div>
                <div class="case-meta" style="margin-top: 0.7vh;">
                    <span><i class="fas fa-bullseye"></i> Restock priority: ${priority}</span>
                    <span><i class="fas fa-info-circle"></i> Use for shift planning and controlled-med audits.</span>
                </div>
            </div>
        `;
        incidentListGrid.appendChild(card);
    });
}

// Data Fetching
async function loadCitizens() {
    loadIncidents();
}

function renderIncidentData(data) {
    currentActiveIncident = data; // Store for editing
    if (getEl('i-id')) getEl('i-id').innerText = `#${data.id}`;
    if (getEl('i-title')) getEl('i-title').innerText = (data.title || 'UNKNOWN').toUpperCase();
    if (getEl('i-location')) getEl('i-location').innerText = data.location || 'N/A';
    
    let dateStr = 'N/A';
    if (data.created_at) {
        const d = new Date(data.created_at);
        if (!isNaN(d.getTime())) dateStr = d.toLocaleString();
    }
    if (getEl('i-date')) getEl('i-date').innerText = dateStr;
    
    if (getEl('i-officer')) getEl('i-officer').innerText = data.officer || 'SYSTEM';
    if (getEl('i-charges')) getEl('i-charges').innerText = data.charges || 'None';
    if (getEl('i-description')) getEl('i-description').innerText = data.description || 'No description provided.';
    if (getEl('i-summary')) getEl('i-summary').innerText = data.summary || 'No summary provided.';

    const statusBadge = getEl('i-status-badge');
    if (statusBadge) {
        statusBadge.innerText = `STATUS: ${(data.status || 'FILED').toUpperCase()}`;
        if (data.status === 'Closed') {
            statusBadge.style.borderColor = '#2ecc71';
            statusBadge.style.color = '#2ecc71';
            statusBadge.style.background = 'rgba(46, 204, 113, 0.1)';
        } else if (data.status === 'Pending Review') {
            statusBadge.style.borderColor = '#f1c40f';
            statusBadge.style.color = '#f1c40f';
            statusBadge.style.background = 'rgba(241, 196, 15, 0.1)';
        } else {
            statusBadge.style.borderColor = 'var(--primary-blue)';
            statusBadge.style.color = 'var(--primary-blue)';
            statusBadge.style.background = 'var(--primary-blue-alpha)';
        }
    }

    const imgBox = getEl('i-image-box');
    const imgEl = getEl('i-image');
    if (imgBox && imgEl) {
        if (data.image && (data.image.startsWith('http') || data.image.startsWith('img/'))) {
            imgEl.src = data.image;
            imgBox.classList.remove('hidden');
        } else {
            imgBox.classList.add('hidden');
        }
    }

    // Involved List
    const list = getEl('i-involved-list');
    if (list) {
        list.innerHTML = '';
        if (data.citizenid) {
            const div = document.createElement('div');
            div.className = 'p-asset-item';
            div.style.cursor = 'pointer';
            div.innerHTML = `
                <span class="v-name">${data.citizenName || 'Involved Person'}</span>
                <span class="v-type">${data.citizenid}</span>
                <span class="v-plate"><i class="fas fa-external-link-alt"></i> PROFILE</span>
            `;
            div.onclick = () => {
                switchPage('profiles');
                selectCitizen(data.citizenid);
            };
            list.appendChild(div);
        } else {
            list.innerHTML = '<div class="empty-state">No linked profiles.</div>';
        }
    }
}

async function loadPharmacyIncidentsLegacy() {
    if (incidentContentView) incidentContentView.classList.add('hidden');
    if (incidentListArea) incidentListArea.classList.remove('hidden');
    if (addIncidentTrigger) addIncidentTrigger.style.display = 'none';
    if (incidentSearchInput) {
        incidentSearchInput.placeholder = 'Search patient name or CID...';
    }

    try {
        const response = await fetch(`https://${GetParentResourceName()}/getPharmacyData`, {
            method: 'POST',
            body: JSON.stringify({})
        });
        const data = await response.json();
        currentPharmacyData = (data && typeof data === 'object') ? data : {};
        const query = incidentSearchInput ? incidentSearchInput.value.trim() : '';
        renderPharmacyIncidentListLegacy(currentPharmacyData, query);
        if (query.length >= 2) searchIncidentSuggestions(query);
    } catch (err) {
        console.error("[PLT MDT] Error loading pharmacy data:", err);
    }
}

function getEmsAccessTag(item) {
    if (item && item.professionalOnly && item.prescriptionRequired) return 'EMS + RX';
    if (item && item.professionalOnly) return 'EMS ONLY';
    if (item && item.prescriptionRequired) return 'RX REQUIRED';
    return 'STANDARD';
}

function getOperationalPriority(item) {
    const label = String((item && item.label) || '').toLowerCase();
    const name = String((item && item.name) || '').toLowerCase();
    const combined = `${label} ${name}`;
    if (combined.includes('medkit') || combined.includes('bandage')) return 'CRITICAL';
    if (combined.includes('oxygen') || combined.includes('bp') || combined.includes('surgical')) return 'HIGH';
    if (combined.includes('antibiotic') || combined.includes('painkiller')) return 'MEDIUM';
    return 'NORMAL';
}

function getCostTier(item) {
    const price = Number((item && item.price) || 0);
    if (price >= 1200) return 'VERY HIGH';
    if (price >= 600) return 'HIGH';
    if (price >= 250) return 'MEDIUM';
    return 'LOW';
}

function renderPharmacyIncidentListLegacy(incidents, query = '') {
    if (!incidentListGrid) return;
    incidentListGrid.innerHTML = '';

    const pharmacy = (incidents && typeof incidents === 'object') ? incidents : {};
    const allItems = Array.isArray(pharmacy.items) ? pharmacy.items : [];
    const normalizedQuery = String(query || '').trim().toLowerCase();
    const items = allItems.filter((item) => {
        if (!normalizedQuery) return true;
        const label = String(item.label || '').toLowerCase();
        const name = String(item.name || '').toLowerCase();
        return label.includes(normalizedQuery) || name.includes(normalizedQuery);
    });

    const discountPct = Math.max(0, Math.round((1 - Number(pharmacy.insuranceDiscount || 1)) * 100));
    const prescriptions = Array.isArray(pharmacy.prescriptions) ? pharmacy.prescriptions : [];
    const emsOnlyCount = allItems.filter((item) => item && item.professionalOnly).length;
    const rxRequiredCount = allItems.filter((item) => item && item.prescriptionRequired).length;
    const criticalCount = allItems.filter((item) => getOperationalPriority(item) === 'CRITICAL').length;
    const expensiveCount = allItems.filter((item) => getCostTier(item) === 'VERY HIGH' || getCostTier(item) === 'HIGH').length;

    const overviewCard = document.createElement('div');
    overviewCard.className = 'case-card';
    overviewCard.innerHTML = `
        <div class="case-card-header">
            <span class="case-id">EMS FORMULARY OVERVIEW</span>
            <span class="case-date">Total items: ${allItems.length}</span>
            <div class="case-status-pill status-active-investigation">READ ONLY</div>
        </div>
        <div class="case-card-body">
            <h3 class="case-title">OPERATIONAL MEDICATION PROFILE</h3>
            <div class="case-meta">
                <span><i class="fas fa-user-shield"></i> EMS-only items: ${emsOnlyCount}</span>
                <span><i class="fas fa-file-prescription"></i> RX-required items: ${rxRequiredCount}</span>
                <span><i class="fas fa-triangle-exclamation"></i> Critical supplies: ${criticalCount}</span>
                <span><i class="fas fa-sack-dollar"></i> High-cost items: ${expensiveCount}</span>
                <span><i class="fas fa-percent"></i> Insurance discount policy: ${discountPct}%</span>
            </div>
            <div class="case-meta" style="margin-top: 0.7vh;">
                <span><i class="fas fa-circle-info"></i> Use this tab for decision support, not purchasing.</span>
                <span><i class="fas fa-clipboard-check"></i> Prioritize CRITICAL/HIGH items for station restock plans.</span>
            </div>
        </div>
    `;
    incidentListGrid.appendChild(overviewCard);

    const rxCard = document.createElement('div');
    rxCard.className = 'case-card';
    rxCard.innerHTML = `
        <div class="case-card-header">
            <span class="case-id">PRESCRIPTION LOAD</span>
            <span class="case-date">Tracked prescriptions</span>
            <div class="case-status-pill status-pending-review">${prescriptions.length} ACTIVE</div>
        </div>
        <div class="case-card-body">
            <h3 class="case-title">RX OPERATIONS SNAPSHOT</h3>
            <div class="case-meta">
                <span><i class="fas fa-notes-medical"></i> Active scripts in player inventory: ${prescriptions.length}</span>
                <span><i class="fas fa-vial"></i> RX-only formulary items: ${rxRequiredCount}</span>
                <span><i class="fas fa-user-doctor"></i> EMS professional formulary: ${emsOnlyCount}</span>
            </div>
        </div>
    `;
    incidentListGrid.appendChild(rxCard);

    if (items.length === 0) {
        const empty = document.createElement('div');
        empty.className = 'profile-empty';
        empty.innerHTML = '<i class="fas fa-pills"></i><p>NO LEGACY ITEMS FOUND</p>';
        incidentListGrid.appendChild(empty);
        return;
    }

    items.forEach((item) => {
        const priority = getOperationalPriority(item);
        const access = getEmsAccessTag(item);
        const costTier = getCostTier(item);
        const basePrice = Number(item.price || 0);

        const card = document.createElement('div');
        card.className = 'case-card';
        card.innerHTML = `
            <div class="case-card-header">
                <span class="case-id">${(item.name || 'ITEM').toUpperCase()}</span>
                <span class="case-date">${access}</span>
                <div class="case-status-pill status-active-investigation">${priority}</div>
            </div>
            <div class="case-card-body">
                <h3 class="case-title">${(item.label || item.name || 'Unknown Item').toUpperCase()}</h3>
                <div class="case-meta">
                    <span><i class="fas fa-tags"></i> Cost tier: ${costTier}</span>
                    <span><i class="fas fa-receipt"></i> Reference price: ${formatMoney(basePrice)}</span>
                    <span><i class="fas fa-notes-medical"></i> Prescription required: ${item.prescriptionRequired ? 'YES' : 'NO'}</span>
                    <span><i class="fas fa-helmet-safety"></i> EMS restricted: ${item.professionalOnly ? 'YES' : 'NO'}</span>
                </div>
                <div class="case-meta" style="margin-top: 0.7vh;">
                    <span><i class="fas fa-bullseye"></i> Restock priority: ${priority}</span>
                    <span><i class="fas fa-info-circle"></i> Use for shift planning and controlled-med audits.</span>
                </div>
            </div>
        `;
        incidentListGrid.appendChild(card);
    });
}

// Data Fetching
async function loadCitizens() {
    // Redesigned profiles page doesn't pre-load all citizens anymore, it's search-based.
    // If you want a list view, you can re-enable this, but for now we match the search image.
}

async function loadVehicles() {
    showSubPage('vehicles', 'reports-view');
    if (!Array.isArray(allChargesData) || allChargesData.length === 0) {
        await loadCharges();
    }
    await fetchReports();
}

// Warrants Page Logic
// Warrants Page UI Actions
const createWarrantBtn = getEl('w-header-create-btn');
if (createWarrantBtn) {
    createWarrantBtn.onclick = () => {
        showSubPage('warrants', 'warrant-create-view');
    };
}

const submitWarrantBtn = getEl('w-submit-create-btn');
if (submitWarrantBtn) {
    submitWarrantBtn.addEventListener('click', async () => {
        const citizenid = getEl('w-new-citizenid').value.trim();
        const title = getEl('w-new-title').value.trim();
        const image = getEl('w-new-image').value.trim();
        const description = getEl('w-new-desc').value.trim();

        if (!citizenid || !title || !description) {
            submitWarrantBtn.style.background = "#ff3e3e";
            setTimeout(() => { submitWarrantBtn.style.background = "var(--primary-blue)"; }, 1000);
            return;
        }

        try {
            const response = await fetch(`https://${GetParentResourceName()}/createWarrant`, {
                method: 'POST',
                body: JSON.stringify({
                    citizenid,
                    title,
                    image,
                    description
                })
            });
            const success = await response.json();

            if (success) {
                // Reset form
                getEl('w-new-citizenid').value = '';
                getEl('w-new-title').value = '';
                getEl('w-new-image').value = '';
                getEl('w-new-desc').value = '';
                
                // Small delay to ensure DB sync before refreshing
                setTimeout(() => {
                    loadWarrants();
                    loadDashboard();
                    showSubPage('warrants', 'warrant-list-view');
                }, 300);
            }
        } catch (err) {
            console.error("[PLT MDT] Error creating warrant from warrants page:", err);
        }
    });
}

const viewDetailsBtn = getEl('w-btn-view-details');
if (viewDetailsBtn) {
    viewDetailsBtn.onclick = () => {
        const activeRow = document.querySelector('#warrants-list-body-new tr.active');
        if (activeRow && activeRow.warrantData) {
            const citizenid = activeRow.warrantData.citizenid;
            if (citizenid) {
                switchPage('profiles');
                selectCitizen(citizenid);
            }
        }
    };
}

const markReadBtn = getEl('w-btn-mark-read');
if (markReadBtn) {
    markReadBtn.onclick = async () => {
        const activeRow = document.querySelector('#warrants-list-body-new tr.active');
        if (activeRow && activeRow.warrantData) {
            const id = activeRow.warrantData.id;
            if (id) {
                await completeWarrantFromPage(id);
            }
        }
    };
}

async function loadWarrants() {
    console.log("[PLT MDT] loadWarrants called");
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getAllWarrants`, {
            method: 'POST'
        });
        const warrants = await response.json();
        console.log("[PLT MDT] loadWarrants response:", warrants);
        renderWarrantsList(warrants);
    } catch (err) {
        console.error("[PLT MDT] Error loading warrants:", err);
    }
}

function sanitizeHtml(value) {
    return String(value || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

function updateMyDutyPill() {
    const dutyEl = getEl('officer-duty-status');
    const pillEl = getEl('ems-my-duty-pill');
    if (!dutyEl || !pillEl) return;
    const onDuty = dutyEl.value === '1';
    pillEl.innerText = onDuty ? 'ON DUTY' : 'OFF DUTY';
    pillEl.style.color = onDuty ? '#adffd5' : '#ffd7d7';
    pillEl.style.borderColor = onDuty ? 'rgba(75, 188, 130, 0.55)' : 'rgba(208, 108, 108, 0.45)';
    pillEl.style.background = onDuty ? 'rgba(36, 121, 77, 0.48)' : 'rgba(115, 45, 45, 0.42)';
}

function renderEmsDirectoryHub(officers) {
    const listEl = getEl('ems-directory-list');
    const totalEl = getEl('ems-dir-total');
    const onDutyEl = getEl('ems-dir-onduty');
    if (!listEl) return;

    const rows = Array.isArray(officers) ? officers : [];
    const normalized = rows.map((row) => ({
        name: row && row.name ? row.name : 'Unknown Medic',
        rank: row && row.rank ? row.rank : 'EMS',
        callsign: row && row.callsign ? row.callsign : `MED-${row && row.id ? row.id : 'N/A'}`,
        onDuty: row && row.onDuty === true
    }));
    const onDutyCount = normalized.filter((row) => row.onDuty).length;

    if (totalEl) totalEl.innerText = String(normalized.length);
    if (onDutyEl) onDutyEl.innerText = String(onDutyCount);

    if (normalized.length === 0) {
        listEl.innerHTML = '<div class="empty-state">No staff currently online.</div>';
        return;
    }

    listEl.innerHTML = normalized.slice(0, 40).map((row) => `
        <div class="ems-directory-row">
            <div class="ems-directory-row-main">
                <div class="ems-directory-name">${sanitizeHtml(row.name)}</div>
                <div class="ems-directory-rank">${sanitizeHtml(row.rank)}</div>
            </div>
            <span class="ems-directory-callsign">${sanitizeHtml(row.callsign)}</span>
            <span class="ems-directory-duty ${row.onDuty ? 'on' : 'off'}">${row.onDuty ? 'ON' : 'OFF'}</span>
        </div>
    `).join('');
}

// Officer Profile Page Logic
async function loadOfficerProfile() {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getOfficerProfile`, {
            method: 'POST',
            body: JSON.stringify({})
        });
        
        if (!response.ok) return;
        const data = await response.json();
        
        if (data) {
            if (getEl('officer-name-display')) getEl('officer-name-display').textContent = data.name || 'Unknown Officer';
            if (getEl('officer-rank-display')) getEl('officer-rank-display').textContent = (data.rank || 'OFFICER').toUpperCase();
            if (getEl('officer-dept-display')) getEl('officer-dept-display').textContent = (data.job || 'EMS').toUpperCase();
            if (getEl('officer-callsign-input')) getEl('officer-callsign-input').value = data.callsign || '';
            if (getEl('officer-duty-status')) getEl('officer-duty-status').value = data.onDuty ? "1" : "0";
            
            if (data.image && (data.image.startsWith('http') || data.image.startsWith('img/'))) {
                if (getEl('officer-avatar-img')) getEl('officer-avatar-img').src = data.image;
            } else {
                if (getEl('officer-avatar-img')) getEl('officer-avatar-img').src = 'img/default_avatar.png';
            }

            updateMyDutyPill();
            renderEmsDirectoryHub(dispatchRoster);
        }
    } catch (error) {
        console.error("[PLT MDT] Error loading officer profile:", error);
    }
}

async function saveOfficerSettings(options = {}) {
    const showFeedback = !options.silent;
    const callsignEl = getEl('officer-callsign-input');
    const statusEl = getEl('officer-duty-status');
    const avatarEl = getEl('officer-avatar-img');
    const saveBtn = getEl('save-officer-settings');
    
    if (!callsignEl || !statusEl) return false;

    const callsign = callsignEl.value;
    const onDuty = statusEl.value === "1";
    const image = avatarEl ? (avatarEl.getAttribute('src') || avatarEl.src || null) : null;
    
    try {
        const response = await fetch(`https://${GetParentResourceName()}/saveOfficerSettings`, {
            method: 'POST',
            body: JSON.stringify({ callsign, onDuty, image })
        });
        
        const success = await response.json();
        
        if (success && showFeedback && saveBtn) {
            const originalText = saveBtn.textContent;
            saveBtn.textContent = 'SAVED!';
            saveBtn.style.backgroundColor = '#2ecc71';
            
            setTimeout(() => {
                saveBtn.textContent = originalText;
                saveBtn.style.backgroundColor = '';
            }, 2000);
        }

        return success === true;
    } catch (error) {
        console.error("[PLT MDT] Error saving officer profile:", error);
        return false;
    }
}

function renderWarrantsList(warrants) {
    console.log("[PLT MDT] Rendering warrants list:", warrants);
    const listBody = getEl('warrants-list-body-new');
    if (!listBody) return;
    listBody.innerHTML = '';

    if (!warrants || warrants.length === 0) {
        listBody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 40px; color: rgba(255,255,255,0.2);">NO ACTIVE WARRANTS FOUND</td></tr>';
        return;
    }

    warrants.forEach((w, index) => {
        const tr = document.createElement('tr');
        
        // Safety check for date
        let dateStr = 'N/A';
        try {
            if (w.created_at) {
                const dateObj = new Date(w.created_at);
                if (!isNaN(dateObj.getTime())) {
                    dateStr = dateObj.toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' }).replace(/\//g, '.');
                }
            }
        } catch (e) {
            console.error("[PLT MDT] Error parsing date:", e);
        }
        
        // Match the image columns: NR, Suspect Name, Warrant ID, Case Number, Officer Date, Status
        tr.innerHTML = `
            <td style="color: rgba(255,255,255,0.4)">${index + 1}</td>
            <td class="warrant-row-name">${w.citizenName || 'Unknown'}</td>
            <td style="color: var(--primary-blue)">#${String(w.id).padStart(4, '0')} - AC</td>
            <td style="color: rgba(255,255,255,0.4)">#101010${w.id || '201'}</td>
            <td>${dateStr}</td>
            <td style="text-align: center;">
                <span class="status-indicator ${w.status === 'active' ? 'status-active' : (w.status === 'completed' ? 'status-expired' : 'status-expired')}"></span>
            </td>
        `;

        tr.warrantData = w; // Attach data for the "View Details" button

        tr.onclick = () => {
            listBody.querySelectorAll('tr').forEach(r => r.classList.remove('active'));
            tr.classList.add('active');
            displayWarrantDetails(w);
        };

        listBody.appendChild(tr);
        if (index === 0) tr.click();
    });
}

function displayWarrantDetails(w) {
    if (!w) return;
    
    // New Design Elements
    const imgEl = getEl('w-detail-suspect-img');
    const nameEl = getEl('w-detail-suspect-name');
    const bioEl = getEl('w-detail-suspect-bio');
    const extraEl = getEl('w-detail-extra-info');

    // Use warrant image first, then suspect profile image, then default
    let displayImage = 'img/default_avatar.png';
    if (w.image && (w.image.startsWith('http') || w.image.startsWith('img/'))) {
        displayImage = w.image;
    } else if (w.suspectImage && w.suspectImage.startsWith('http')) {
        displayImage = w.suspectImage;
    }

    if (imgEl) imgEl.src = displayImage;
    if (nameEl) nameEl.innerText = w.citizenName || 'Unknown Subject';
    
    // In the image, Bio is the title/summary, and "Details Here" is the full report
    if (bioEl) bioEl.innerText = w.title || 'No title provided';
    
    if (extraEl) {
        extraEl.innerHTML = `
            <div style="margin-bottom: 10px; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 10px;">
                <div style="display: flex; justify-content: space-between; font-size: 10px; margin-bottom: 5px;">
                    <span style="color: var(--primary-blue); font-weight: 700;">WARRANT ID: #${w.id}</span>
                    <span style="opacity: 0.5;">DATE: ${new Date(w.created_at).toLocaleDateString()}</span>
                </div>
                <div style="font-size: 10px; text-align: left;">
                    <span style="opacity: 0.6;">OFFICER:</span> <span style="color: white;">${w.officer || 'SYSTEM'}</span>
                </div>
            </div>
            <div style="text-align: left; font-size: 11px; color: rgba(255,255,255,0.7); line-height: 1.5; white-space: pre-line;">
                ${w.description || 'No additional details provided.'}
            </div>
        `;
    }
}

// Search Logic for Warrants
const warrantSearchInput = getEl('warrant-search-input');
if (warrantSearchInput) {
    warrantSearchInput.addEventListener('input', async (e) => {
        const val = e.target.value.toLowerCase().trim();
        const response = await fetch(`https://${GetParentResourceName()}/getAllWarrants`, { method: 'POST' });
        let warrants = await response.json();
        
        if (val !== "") {
            warrants = warrants.filter(w => 
                (w.citizenName && w.citizenName.toLowerCase().includes(val)) ||
                (w.id && String(w.id).includes(val)) ||
                (w.officer && w.officer.toLowerCase().includes(val))
            );
        }
        renderWarrantsList(warrants);
    });
}

async function completeWarrantFromPage(id) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/completeWarrant`, {
            method: 'POST',
            body: JSON.stringify({ id })
        });
        if (await response.json()) {
            loadWarrants();
        }
    } catch (err) {
        console.error("[PLT MDT] Error completing warrant:", err);
    }
}

async function cancelWarrantFromPage(id) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/deleteWarrant`, {
            method: 'POST',
            body: JSON.stringify({ id })
        });
        if (await response.json()) {
            loadWarrants();
        }
    } catch (err) {
        console.error("[PLT MDT] Error canceling warrant:", err);
    }
}

async function completeWarrantFromPage(id) {
    try {
        const response = await fetch(`https://${GetParentResourceName()}/completeWarrant`, {
            method: 'POST',
            body: JSON.stringify({ id: id })
        });
        if (await response.json()) {
            loadWarrants(); // Refresh list
        }
    } catch (err) {
        console.error("[PLT MDT] Error completing warrant:", err);
    }
}

// Record Warrant Toggle
const warrantNoBtn = getEl('warrant-no');
const warrantYesBtn = getEl('warrant-yes');
const warrantHiddenInput = getEl('p-new-record-warrant');

if (warrantNoBtn && warrantYesBtn) {
    warrantNoBtn.addEventListener('click', () => {
        warrantNoBtn.classList.add('active');
        warrantYesBtn.classList.remove('active');
        if (warrantHiddenInput) warrantHiddenInput.value = 'no';
    });

    warrantYesBtn.addEventListener('click', () => {
        warrantYesBtn.classList.add('active');
        warrantNoBtn.classList.remove('active');
        if (warrantHiddenInput) warrantHiddenInput.value = 'yes';
    });
}

// Profile Card Warrant Toggle (Directly on profile)
document.addEventListener('click', async (e) => {
    const target = e.target;
    if (target.id === 'p-card-warrant-no' || target.id === 'p-card-warrant-yes') {
        if (!currentActiveCitizenId) return;
        const active = target.id === 'p-card-warrant-yes';
        console.log("[PLT MDT] Toggling warrant to:", active);
        
        // Immediate visual feedback
        if (active) {
            getEl('p-card-warrant-yes').classList.add('active');
            getEl('p-card-warrant-no').classList.remove('active');
        } else {
            getEl('p-card-warrant-no').classList.add('active');
            getEl('p-card-warrant-yes').classList.remove('active');
        }

        try {
            const response = await fetch(`https://${GetParentResourceName()}/toggleWarrant`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ citizenid: currentActiveCitizenId, active: active })
            });
            const result = await response.json();
            
            // Wait for DB to sync before refreshing full profile
            // Use config delay if available, default to 500ms
            const delay = (typeof Config !== 'undefined' && Config.WarrantSyncDelay) || 500;
            setTimeout(() => {
                selectCitizen(currentActiveCitizenId); 
            }, delay);
        } catch (err) {
            console.error("[PLT MDT] Error toggling warrant:", err);
        }
    }
});

// Avatar Update Logic
let avatarModalMode = 'citizen'; // 'citizen' or 'officer'
const avatarClickArea = getEl('p-avatar-click');
const officerPhotoBtn = getEl('officer-photo-btn');
const avatarModal = getEl('avatar-modal');
const closeAvatarModal = getEl('close-avatar-modal');
const avatarUrlInput = getEl('p-avatar-url-input');
const avatarSaveBtn = getEl('p-avatar-save-btn');
const avatarCameraBtn = getEl('p-avatar-camera-btn');

if (avatarClickArea && avatarModal) {
    avatarClickArea.addEventListener('click', () => {
        if (!currentActiveCitizenId) return;
        avatarModalMode = 'citizen';
        avatarModal.classList.remove('hidden');
        if (avatarUrlInput) avatarUrlInput.value = '';
    });
}

if (officerPhotoBtn && avatarModal) {
    officerPhotoBtn.addEventListener('click', () => {
        avatarModalMode = 'officer';
        avatarModal.classList.remove('hidden');
        if (avatarUrlInput) avatarUrlInput.value = '';
    });
}

if (closeAvatarModal && avatarModal) {
    closeAvatarModal.addEventListener('click', () => {
        avatarModal.classList.add('hidden');
    });
}

if (avatarSaveBtn) {
    avatarSaveBtn.addEventListener('click', async () => {
        const url = avatarUrlInput.value.trim();
        if (!url || !url.startsWith('http')) return;

        try {
            if (avatarModalMode === 'citizen') {
                const response = await fetch(`https://${GetParentResourceName()}/updateProfileImage`, {
                    method: 'POST',
                    body: JSON.stringify({ citizenid: currentActiveCitizenId, image: url })
                });
                const success = await response.json();
                if (success) {
                    if (avatarModal) avatarModal.classList.add('hidden');
                    selectCitizen(currentActiveCitizenId); // Refresh
                }
            } else if (avatarModalMode === 'officer') {
                const imgEl = getEl('officer-avatar-img');
                if (imgEl) imgEl.src = url;
                const success = await saveOfficerSettings({ silent: true });
                if (success && avatarModal) avatarModal.classList.add('hidden');
            }
        } catch (err) {
            console.error("[PLT MDT] Error updating profile image:", err);
        }
    });
}

if (avatarCameraBtn) {
    avatarCameraBtn.addEventListener('click', () => {
        if (avatarModalMode === 'citizen' && !currentActiveCitizenId) return;
        
        if (avatarModal) avatarModal.classList.add('hidden');
        if (mdtContainer) mdtContainer.style.display = 'none'; // Hide MDT for camera
        
        if (avatarModalMode === 'citizen') {
            fetch(`https://${GetParentResourceName()}/takeCitizenPhoto`, {
                method: 'POST',
                body: JSON.stringify({ citizenid: currentActiveCitizenId })
            });
        } else {
            fetch(`https://${GetParentResourceName()}/takeOfficerSelfie`, {
                method: 'POST',
                body: JSON.stringify({})
            });
        }
    });
}

function hexToRgba(hex, opacity) {
    let r = 0, g = 0, b = 0;
    if (hex.length == 4) {
        r = parseInt(hex[1] + hex[1], 16);
        g = parseInt(hex[2] + hex[2], 16);
        b = parseInt(hex[3] + hex[3], 16);
    } else if (hex.length == 7) {
        r = parseInt(hex.substring(1, 3), 16);
        g = parseInt(hex.substring(3, 5), 16);
        b = parseInt(hex.substring(5, 7), 16);
    }
    return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}

function applyThemeColor(color) {
    if (!color) return;
    
    document.documentElement.style.setProperty('--primary-blue', color);
    document.documentElement.style.setProperty('--highlight-glow', hexToRgba(color, 0.8));
    document.documentElement.style.setProperty('--primary-blue-alpha', hexToRgba(color, 0.1));
    document.documentElement.style.setProperty('--primary-blue-alpha-08', hexToRgba(color, 0.8));
    document.documentElement.style.setProperty('--primary-blue-alpha-06', hexToRgba(color, 0.6));
    document.documentElement.style.setProperty('--primary-blue-alpha-05', hexToRgba(color, 0.5));
    document.documentElement.style.setProperty('--primary-blue-alpha-04', hexToRgba(color, 0.4));
    document.documentElement.style.setProperty('--primary-blue-alpha-03', hexToRgba(color, 0.3));
    document.documentElement.style.setProperty('--primary-blue-alpha-02', hexToRgba(color, 0.2));
    document.documentElement.style.setProperty('--primary-blue-alpha-15', hexToRgba(color, 0.15));
    document.documentElement.style.setProperty('--primary-blue-alpha-08-low', hexToRgba(color, 0.08));
    document.documentElement.style.setProperty('--primary-blue-alpha-05-low', hexToRgba(color, 0.05));
    document.documentElement.style.setProperty('--primary-blue-alpha-15', hexToRgba(color, 0.15));
    document.documentElement.style.setProperty('--primary-blue-alpha-15', hexToRgba(color, 0.15));
    document.documentElement.style.setProperty('--primary-blue-alpha-08-low', hexToRgba(color, 0.08));
    document.documentElement.style.setProperty('--primary-blue-alpha-05-low', hexToRgba(color, 0.05));
    
    // Solid dark background for nav tiles
    const r = parseInt(color.substring(1, 3), 16);
    const g = parseInt(color.substring(3, 5), 16);
    const b = parseInt(color.substring(5, 7), 16);
    document.documentElement.style.setProperty('--primary-dark-solid', `rgb(${Math.floor(r * 0.05)}, ${Math.floor(g * 0.1)}, ${Math.floor(b * 0.15)})`);
}

// Global variable to store the default job color
let defaultJobColor = '#63A6C0';

// Initialize Theme Selector
function initThemeSelector() {
    const pickerBtn = getEl('theme-picker-btn');
    const colorInput = getEl('theme-color-input');
    const resetBtn = getEl('reset-theme');

    if (pickerBtn && colorInput) {
        pickerBtn.addEventListener('click', () => {
            colorInput.click();
        });

        colorInput.addEventListener('input', (e) => {
            const color = e.target.value;
            localStorage.setItem('mdt_user_theme', color);
            applyThemeColor(color);
        });
    }

    if (resetBtn) {
        resetBtn.addEventListener('click', () => {
            localStorage.removeItem('mdt_user_theme');
            applyThemeColor(defaultJobColor);
        });
    }
}

// Call init on script load
document.addEventListener('DOMContentLoaded', () => {
    initThemeSelector();

    const directionBtn = getEl('dispatch-live-direction-btn');
    if (directionBtn) {
        directionBtn.addEventListener('click', (e) => {
            e.preventDefault();
            setGpsToLiveNotification();
        });
    }

    const dismissBtn = getEl('dispatch-live-dismiss-btn');
    if (dismissBtn) {
        dismissBtn.addEventListener('click', (e) => {
            e.preventDefault();
            dismissLiveNotification();
        });
    }

    const addCameraBtn = getEl('dispatch-add-camera-btn');
    if (addCameraBtn) {
        addCameraBtn.addEventListener('click', () => {
            fetch(`https://${GetParentResourceName()}/createDispatchCamera`, {
                method: 'POST',
                body: JSON.stringify({})
            })
            .then(resp => resp.json())
            .then(success => {
                if (success) {
                    loadDispatchCameras();
                }
            })
            .catch(() => {});
        });
    }

    const closeFeedBtn = getEl('dispatch-camera-feed-close');
    if (closeFeedBtn) closeFeedBtn.addEventListener('click', closeDispatchCameraFeed);

    document.addEventListener('keydown', (e) => {
        const activeEl = document.activeElement;
        const isTyping = activeEl && (
            activeEl.tagName === 'INPUT' ||
            activeEl.tagName === 'TEXTAREA' ||
            activeEl.tagName === 'SELECT' ||
            activeEl.isContentEditable
        );
        if (isTyping) return;
        const canUseLiveToastHotkeys = enableDispatchLiveNotifications && liveDispatchNotifications.length > 0 && liveDispatchIndex >= 0;

        if (e.key === 'ArrowLeft' && canUseLiveToastHotkeys) {
            navigateLiveDispatchNotification('left');
            e.preventDefault();
        } else if (e.key === 'ArrowRight' && canUseLiveToastHotkeys) {
            navigateLiveDispatchNotification('right');
            e.preventDefault();
        } else if ((e.key === 'e' || e.key === 'E') && canUseLiveToastHotkeys) {
            setGpsToLiveNotification();
            e.preventDefault();
        } else if ((e.key === 'y' || e.key === 'Y') && canUseLiveToastHotkeys) {
            dismissLiveNotification();
            e.preventDefault();
        }
    });
});

// Global Message Handler
window.addEventListener('message', function (event) {
    const data = event.data;
    if (data.type === "openMDT") {
        canAssignDispatch = data.canAssignDispatch === true || data.canUseDispatch === true;
        enableDispatchLiveNotifications = false;
        mdtLocale = typeof data.locale === 'string' && data.locale.trim() ? data.locale.trim() : 'en';
        mdtTranslations = (data.translations && typeof data.translations === 'object') ? data.translations : {};
        panicAlerts = Array.isArray(data.panicAlerts) ? data.panicAlerts : [];
        mdtServerId = data.serverId !== undefined && data.serverId !== null ? String(data.serverId) : null;
        mdtTranslationLookup = null;
        liveDispatchNotifications = [];
        liveDispatchIndex = -1;
        renderLiveDispatchNotification();
        updateDispatchPermissionUI();

        if (mdtContainer) {
            mdtContainer.style.display = 'flex';
            mdtContainer.style.visibility = 'visible';
            mdtContainer.style.opacity = '1';
        }

        // Apply job-specific primary color
        if (data.color) {
            defaultJobColor = data.color;
            
            // Check for cached user preference
            const cachedColor = localStorage.getItem('mdt_user_theme');
            if (cachedColor) {
                applyThemeColor(cachedColor);
            } else {
                applyThemeColor(data.color);
            }
        }

        const titleEl = getEl('job-title-main');
        if (titleEl && data.jobLabel) {
            const appTitle = getMdtTranslationValue('app_title', 'MDT');
            titleEl.innerText = `${data.jobLabel.toUpperCase()} ${String(appTitle).toUpperCase()}`;
        }
        
        switchPage('home');
        loadOfficerProfile(); // Pre-load officer data
        loadCharges(); // Pre-load penal code for sentencing
        loadHospitalManagement(); // Warm cache so records list opens instantly
        renderDashboardPlaceholders();
        renderOnlineUnits(data.officers || []);
        dispatchRoster = Array.isArray(data.officers) ? data.officers : [];
        renderEmsDirectoryHub(dispatchRoster);
        setTimeout(() => applyMdtTranslationsToDom(), 0);
    } else if (data.type === "photoCaptured") {
        console.log("[PLT MDT] Photo captured, updating UI:", data.url);
        // Re-enable UI visibility if it was hidden
        if (mdtContainer) {
            mdtContainer.style.display = 'flex';
            mdtContainer.style.opacity = '1';
            mdtContainer.style.visibility = 'visible';
        }
        
        if (data.context === 'vehicle-bolo') {
            const imgInput = getEl('v-new-marker-image');
            if (imgInput && data.url) {
                imgInput.value = data.url;
                console.log("[PLT MDT] Vehicle BOLO image updated from camera.");
            }
        } else if (data.context === 'incident-evidence') {
            const imgInput = getEl('i-new-image');
            if (imgInput && data.url) {
                imgInput.value = data.url;
                console.log("[PLT MDT] Incident evidence image updated from camera.");
            }
        } else if (data.url && data.isOfficer) {
            getEl('officer-avatar-img').src = data.url;
            saveOfficerSettings({ silent: true });
        } else if (data.url && currentActiveCitizenId) {
            // Small delay to ensure DB update is processed before refresh
            setTimeout(() => {
                selectCitizen(currentActiveCitizenId); 
            }, 500);
        } else if (!data.url) {
            console.warn("[PLT MDT] No URL returned from photo capture.");
        }
    } else if (data.type === "updateDashboard") {
        renderDashboardData(data.dashboard);
    } else if (data.type === "navigateDispatchNotification") {
        if (data.direction === 'left' || data.direction === 'right') {
            navigateLiveDispatchNotification(data.direction);
        }
    } else if (data.type === "performDispatchNotificationDirection") {
        setGpsToLiveNotification();
    } else if (data.type === "dismissDispatchNotification") {
        dismissLiveNotification();
    } else if (data.type === "closeMDT") {
        hidePanicSelector();
        if (mdtContainer) mdtContainer.style.display = 'none';
    } else if (data.type === "openCameraOverlay") {
        const overlay = document.getElementById('camera-overlay');
        const label = document.getElementById('camera-overlay-label');
        if (overlay) overlay.classList.remove('hidden');
        if (label) label.innerText = data.label || "CCTV CAMERA";
        
        if (window.cameraTimeInterval) clearInterval(window.cameraTimeInterval);
        window.cameraTimeInterval = setInterval(() => {
            const timeEl = document.getElementById('camera-overlay-time');
            if (timeEl) {
                const now = new Date();
                const h = String(now.getHours()).padStart(2, '0');
                const m = String(now.getMinutes()).padStart(2, '0');
                const s = String(now.getSeconds()).padStart(2, '0');
                timeEl.innerText = `${h}:${m}:${s}`;
            }
        }, 1000);
    } else if (data.type === "closeCameraOverlay") {
        const overlay = document.getElementById('camera-overlay');
        if (overlay) overlay.classList.add('hidden');
        if (window.cameraTimeInterval) clearInterval(window.cameraTimeInterval);
    } else if (data.type === "updateOfficerLocations") {
        const incomingOfficers = Array.isArray(data.officers) ? data.officers : [];
        if (typeof updateMarkers === 'function') updateMarkers(incomingOfficers);
        renderOnlineUnits(incomingOfficers);
        dispatchRoster = incomingOfficers;
        renderEmsDirectoryHub(incomingOfficers);

        refreshDispatchRoster(incomingOfficers);
        setTimeout(() => applyMdtTranslationsToDom(), 0);
    } else if (data.type === "newDispatchCall") {
        if (data.call) {
            console.log("[PLT MDT] New dispatch call received:", data.call.id);
            // Check if call already exists to prevent duplicates
            const exists = currentActiveCalls.find(c => c.id === data.call.id);
            if (!exists) {
                const normalizedCoords = resolveAlertWorldCoords({ coords: data.call.coords }) || data.call.coords || null;
                const newCallObj = {
                    ...data.call,
                    coords: normalizedCoords,
                    localTime: Date.now(),
                    assignedUnits: mapCallUnitsToAssignedUnits(data.call.units)
                };
                
                currentActiveCalls.unshift(newCallObj);
                if (currentActiveCalls.length > 50) currentActiveCalls.pop();
                
                // Update all UI components that show calls
                renderDispatchAlerts();
                
                // Also update the dashboard feed in real-time
                if (notificationFeed) {
                    const emptyState = notificationFeed.querySelector('.empty-state');
                    if (emptyState) notificationFeed.innerHTML = '';
                    
                    const item = document.createElement('div');
                    item.className = 'notification-item clickable thin-row';
                    const timeStr = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true });

                    item.innerHTML = `
                        <div class="notif-content">
                            <div class="notif-title">${newCallObj.title}</div>
                            <div class="notif-desc">${newCallObj.location || 'Unknown'} - ${newCallObj.info || ''}</div>
                        </div>
                        <div class="notif-time-badge">
                            <span>${timeStr}</span>
                            <i class="fas fa-clock"></i>
                        </div>
                    `;
                    item.onclick = () => switchPage('dispatch');
                    notificationFeed.insertBefore(item, notificationFeed.firstChild);
                    
                    // Keep dashboard feed small
                    while (notificationFeed.children.length > 5) {
                        notificationFeed.lastChild.remove();
                    }
                }

                setTimeout(() => applyMdtTranslationsToDom(), 0);
            }
        }
    } else if (data.type === "mdtPharmacyData") {
        currentPharmacyData = (data && data.data && typeof data.data === 'object') ? data.data : {};
        // This legacy payload is ignored because the old inventory tab is now the X-Ray page.
    }
});

function mapCallUnitsToAssignedUnits(units) {
    if (!Array.isArray(units) || units.length === 0) return [];
    return units.map((unit, idx) => {
        if (typeof unit === 'string') return { id: `legacy-${idx}-${unit}`, label: unit };
        if (unit && typeof unit === 'object') {
            return {
                id: unit.id || `legacy-${idx}-${unit.callsign || unit.name || 'unit'}`,
                label: unit.label || unit.callsign || unit.name || `Unit ${idx + 1}`
            };
        }
        return { id: `legacy-${idx}`, label: `Unit ${idx + 1}` };
    });
}

function toNumberOrNull(value) {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
}

function parseCoordsFromString(text) {
    if (typeof text !== 'string' || text.trim() === '') return null;
    const trimmed = text.trim();

    // JSON-like payload
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
            const parsed = JSON.parse(trimmed);
            if (parsed && typeof parsed === 'object') return parsed;
        } catch (_) {}
    }

    // vec3(...) or any "num, num, num" style string
    const matches = trimmed.match(/-?\d+(?:\.\d+)?/g);
    if (matches && matches.length >= 2) {
        return {
            x: Number(matches[0]),
            y: Number(matches[1]),
            z: matches[2] !== undefined ? Number(matches[2]) : 0
        };
    }

    return null;
}

function getRawAlertCoords(alert) {
    if (!alert || typeof alert !== 'object') return null;
    return (
        alert.coords ||
        alert.coord ||
        alert.position ||
        alert.pos ||
        alert.gps ||
        alert.locationCoords ||
        null
    );
}

function getAlertWorldCoords(alert) {
    let raw = getRawAlertCoords(alert);
    if (typeof raw === 'string') raw = parseCoordsFromString(raw);
    if (!raw || typeof raw !== 'object') {
        raw = alert || {};
    }

    const x = toNumberOrNull(raw.x !== undefined ? raw.x : (raw.X !== undefined ? raw.X : (Array.isArray(raw) ? raw[0] : raw[1])));
    const y = toNumberOrNull(raw.y !== undefined ? raw.y : (raw.Y !== undefined ? raw.Y : (Array.isArray(raw) ? raw[1] : raw[2])));
    const zRaw =
        raw.z !== undefined ? raw.z
        : (raw.Z !== undefined ? raw.Z : (Array.isArray(raw) ? raw[2] : raw[3]));
    const z = toNumberOrNull(zRaw);

    if (x === null || y === null) return null;
    return { x, y, z: z === null ? 0 : z };
}

function isLikelyGtaWorldCoords(x, y) {
    if (x === null || y === null) return false;
    if (Math.abs(x) > 250 || Math.abs(y) > 250) return true;
    // Reject leaflet map-space values that were stored as x/y.
    if (x >= 0 && y >= 0 && x <= 1024 && y <= 1024) return false;
    return Math.abs(x) > 80 && Math.abs(y) > 80;
}

function resolveAlertWorldCoords(alert) {
    const parsed = getAlertWorldCoords(alert);
    if (!parsed) return null;

    const x = parsed.x;
    const y = parsed.y;
    const z = parsed.z || 0;

    if (isLikelyGtaWorldCoords(x, y)) {
        return { x, y, z };
    }

    // Coords may be stored as map lat/lng (or swapped x=lng,y=lat).
    const attempts = [
        convertMapToWorld(y, x),
        convertMapToWorld(x, y),
    ];

    for (let i = 0; i < attempts.length; i++) {
        const converted = attempts[i];
        if (converted && isLikelyGtaWorldCoords(converted.x, converted.y)) {
            return { x: converted.x, y: converted.y, z };
        }
    }

    return { x, y, z };
}

function getAlertMapCoords(alert) {
    const worldCoords = resolveAlertWorldCoords(alert);
    if (worldCoords) {
        const likelyMapSpace =
            worldCoords.x >= 0 &&
            worldCoords.y >= 0 &&
            worldCoords.x <= 1024 &&
            worldCoords.y <= 1024;

        if (likelyMapSpace) return [worldCoords.y, worldCoords.x];

        // If this looks like actual GTA world coords, convert them.
        return convertCoords(worldCoords.x, worldCoords.y);
    }

    let raw = getRawAlertCoords(alert);
    if (typeof raw === 'string') raw = parseCoordsFromString(raw);
    if (!raw || typeof raw !== 'object') raw = {};

    const lat = toNumberOrNull(
        raw.lat !== undefined ? raw.lat
        : (raw.latitude !== undefined ? raw.latitude : raw[1])
    );
    const lng = toNumberOrNull(
        raw.lng !== undefined ? raw.lng
        : (raw.lon !== undefined ? raw.lon
        : (raw.longitude !== undefined ? raw.longitude : raw[2]))
    );
    if (lat === null || lng === null) return null;
    return [lat, lng];
}

function focusMapOnAlert(alert, alertType) {
    if (!map) return false;
    const mapCoords = getAlertMapCoords(alert);
    if (!mapCoords) return false;

    map.setView(mapCoords, 2);

    const tempCircle = L.circle(mapCoords, {
        color: alertType === 'high' ? 'red' : 'orange',
        fillColor: alertType === 'high' ? '#f03' : '#f30',
        fillOpacity: 0.5,
        radius: 20
    }).addTo(map);

    setTimeout(() => map.removeLayer(tempCircle), 3000);
    return true;
}

function isDispatchPageActive() {
    const dispatchPage = getEl('dispatch');
    return !!dispatchPage && dispatchPage.classList.contains('active');
}

function touchDispatchUiInteraction() {
    dispatchUiLockUntil = Date.now() + 8000;
}

function isDispatchSelectInteracting() {
    if (Date.now() < dispatchUiLockUntil) return true;
    const activeEl = document.activeElement;
    return !!activeEl && activeEl.tagName === 'SELECT' && !!activeEl.closest('#dispatch');
}

function captureDispatchDropdownState() {
    const state = {
        createOfficer: '',
        assignByCall: {},
        memberByUnit: {}
    };

    const createSelect = getEl('dispatch-unit-officer');
    if (createSelect) state.createOfficer = createSelect.value || '';

    document.querySelectorAll('.assign-unit-select').forEach((select) => {
        const callId = select.dataset.callId;
        if (callId) state.assignByCall[String(callId)] = select.value || '';
    });

    document.querySelectorAll('.dispatch-unit-member-select').forEach((select) => {
        const unitId = select.dataset.unitId;
        if (unitId) state.memberByUnit[String(unitId)] = select.value || '';
    });

    return state;
}

function restoreDispatchDropdownState(state) {
    if (!state || typeof state !== 'object') return;

    const createSelect = getEl('dispatch-unit-officer');
    if (createSelect && state.createOfficer) {
        const hasOption = Array.from(createSelect.options).some((opt) => opt.value === state.createOfficer);
        if (hasOption) createSelect.value = state.createOfficer;
    }

    Object.keys(state.assignByCall || {}).forEach((callId) => {
        const select = document.querySelector(`.assign-unit-select[data-call-id="${callId}"]`);
        const value = state.assignByCall[callId];
        if (select && value) {
            const hasOption = Array.from(select.options).some((opt) => opt.value === value);
            if (hasOption) select.value = value;
        }
    });

    Object.keys(state.memberByUnit || {}).forEach((unitId) => {
        const select = document.querySelector(`.dispatch-unit-member-select[data-unit-id="${unitId}"]`);
        const value = state.memberByUnit[unitId];
        if (select && value) {
            const hasOption = Array.from(select.options).some((opt) => opt.value === value);
            if (hasOption) select.value = value;
        }
    });
}

function queueRenderDispatchAlerts(delay) {
    if (dispatchAlertsRenderTimeout) clearTimeout(dispatchAlertsRenderTimeout);
    dispatchAlertsRenderTimeout = setTimeout(() => {
        dispatchAlertsRenderTimeout = null;
        if (isDispatchSelectInteracting()) {
            queueRenderDispatchAlerts(500);
            return;
        }
        renderDispatchAlerts(true);
    }, delay || 400);
}

function isOfficerAssignedToAnyUnit(officerId) {
    return dispatchUnits.some(unit => Array.isArray(unit.members) && unit.members.some(member => String(member.id) === String(officerId)));
}

function normalizeDispatchUnit(unit) {
    if (!unit || typeof unit !== 'object') return null;
    if (Array.isArray(unit.members)) return unit;

    const legacyId = unit.officerId;
    const legacyName = unit.officerName;
    const legacyCallsign = unit.callsign;
    const members = [];

    if (legacyId !== undefined && legacyId !== null) {
        members.push({
            id: legacyId,
            name: legacyName || 'Unknown',
            callsign: legacyCallsign || ''
        });
    }

    return {
        id: unit.id || `unit-${Date.now()}`,
        label: unit.label || 'UNIT',
        members
    };
}

function normalizeDispatchUnits() {
    dispatchUnits = dispatchUnits
        .map(normalizeDispatchUnit)
        .filter(Boolean);
}

function getOfficerById(officerId) {
    return dispatchRoster.find(o => String(o.id) === String(officerId));
}

function getUnitById(unitId) {
    return dispatchUnits.find(u => u.id === unitId);
}

function bindDispatchUnitBuilder() {
    const createBtn = getEl('dispatch-create-unit-btn');
    const officerSelect = getEl('dispatch-unit-officer');
    const unitNameInput = getEl('dispatch-unit-name');
    if (!createBtn || createBtn.dataset.bound === 'true') return;

    createBtn.dataset.bound = 'true';
    [createBtn, officerSelect, unitNameInput].forEach(el => {
        if (!el) return;
        ['mousedown', 'focus', 'click', 'keydown', 'change', 'input'].forEach(evt => {
            el.addEventListener(evt, () => touchDispatchUiInteraction());
        });
    });

    createBtn.addEventListener('click', () => {
        const nameInput = getEl('dispatch-unit-name');
        const officerSelect = getEl('dispatch-unit-officer');
        if (!nameInput || !officerSelect) return;

        const label = (nameInput.value || '').trim();
        const officerId = officerSelect.value;
        touchDispatchUiInteraction();

        if (!label) {
            console.warn('[PLT MDT] Unit name is required.');
            return;
        }

        if (!officerId) {
            console.warn('[PLT MDT] Select at least one officer.');
            return;
        }

        if (isOfficerAssignedToAnyUnit(officerId)) {
            console.warn('[PLT MDT] Officer is already assigned to another unit.');
            return;
        }

        const officer = getOfficerById(officerId);
        if (!officer) {
            console.warn('[PLT MDT] Selected officer is no longer available.');
            return;
        }

        dispatchUnits.push({
            id: `unit-${Date.now()}-${Math.floor(Math.random() * 1000)}`,
            label,
            members: [
                {
                    id: officer.id,
                    name: officer.name,
                    callsign: officer.callsign || `Badge #${officer.id || '0'}`
                }
            ]
        });

        nameInput.value = '';
        officerSelect.value = '';
        refreshDispatchRoster(dispatchRoster, { refreshAlerts: true, forceImmediate: true });
    });
}

function populateDispatchUnitOfficerSelect() {
    const officerSelect = getEl('dispatch-unit-officer');
    if (!officerSelect) return;
    if (document.activeElement === officerSelect) return;

    const previousValue = officerSelect.value || '';

    const assignedOfficerIds = new Set();
    dispatchUnits.forEach(unit => {
        (unit.members || []).forEach(member => assignedOfficerIds.add(String(member.id)));
    });
    const availableOfficers = dispatchRoster.filter(officer => !assignedOfficerIds.has(String(officer.id)));

    officerSelect.innerHTML = '<option value="">Select officer...</option>';
    availableOfficers.forEach(officer => {
        const option = document.createElement('option');
        option.value = officer.id;
        option.innerText = `${officer.name} (${officer.callsign || ('Badge #' + (officer.id || '0'))})`;
        officerSelect.appendChild(option);
    });

    if (previousValue && Array.from(officerSelect.options).some((opt) => opt.value === previousValue)) {
        officerSelect.value = previousValue;
    }
}

function addOfficerToUnit(unitId, officerId) {
    const unit = getUnitById(unitId);
    const officer = getOfficerById(officerId);
    if (!unit || !officer) return;
    if (isOfficerAssignedToAnyUnit(officerId)) return;

    if (!Array.isArray(unit.members)) unit.members = [];
    unit.members.push({
        id: officer.id,
        name: officer.name,
        callsign: officer.callsign || `Badge #${officer.id || '0'}`
    });
    refreshDispatchRoster(dispatchRoster, { refreshAlerts: true, forceImmediate: true });
}

function assignUnitToCall(callId, unitId) {
    if (!canAssignDispatch) return;
    const call = currentActiveCalls.find(c => String(c.id) === String(callId));
    const unit = getUnitById(unitId);
    if (!call || !unit) return;

    if (!Array.isArray(call.assignedUnits)) {
        call.assignedUnits = mapCallUnitsToAssignedUnits(call.units);
    }

    if (!call.assignedUnits.some(assigned => assigned.id === unit.id)) {
        call.assignedUnits.push({ id: unit.id, label: unit.label });
    }

    renderDispatchAlerts(true);
}

function removeAssignedUnitFromCall(callId, unitId) {
    if (!canAssignDispatch) return;
    const call = currentActiveCalls.find(c => String(c.id) === String(callId));
    if (!call || !Array.isArray(call.assignedUnits)) return;

    call.assignedUnits = call.assignedUnits.filter(unit => unit.id !== unitId);
    renderDispatchAlerts(true);
}

function removeUnit(unitId) {
    dispatchUnits = dispatchUnits.filter(unit => unit.id !== unitId);
    currentActiveCalls.forEach(call => {
        if (Array.isArray(call.assignedUnits)) {
            call.assignedUnits = call.assignedUnits.filter(unit => unit.id !== unitId);
        }
    });
    refreshDispatchRoster(dispatchRoster, { refreshAlerts: true, forceImmediate: true });
}

function renderDispatchUnitBoard() {
    const boardList = getEl('dispatch-units-board-list');
    if (!boardList) return;
    const activeEl = document.activeElement;
    if (
        activeEl &&
        activeEl.closest('#dispatch') &&
        (activeEl.classList.contains('dispatch-unit-member-select') || activeEl.id === 'dispatch-unit-officer')
    ) {
        return;
    }

    const savedMemberState = captureDispatchDropdownState().memberByUnit;
    boardList.innerHTML = '';
    if (dispatchUnits.length === 0) {
        boardList.innerHTML = '<div class="empty-state">No units created yet</div>';
        return;
    }

    dispatchUnits.forEach(unit => {
        const members = Array.isArray(unit.members) ? unit.members : [];
        const onlineMembers = members.filter(member => !!getOfficerById(member.id));
        const isOnline = onlineMembers.length > 0;
        const isAssigned = currentActiveCalls.some(call => Array.isArray(call.assignedUnits) && call.assignedUnits.some(assigned => assigned.id === unit.id));
        const availableOfficerOptions = dispatchRoster
            .filter(officer => !isOfficerAssignedToAnyUnit(officer.id))
            .map(officer => `<option value="${officer.id}">${officer.name} (${officer.callsign || ('Badge #' + (officer.id || '0'))})</option>`)
            .join('');

        const card = document.createElement('div');
        const statusClass = isAssigned ? 'assigned' : (isOnline ? 'online' : 'offline');
        card.className = `dispatch-unit-card ${statusClass}`;
        card.innerHTML = `
            <div class="dispatch-unit-card-left">
                <div class="dispatch-unit-title">${unit.label}</div>
                <div class="dispatch-unit-meta">${members.length} member(s)</div>
                <div class="dispatch-unit-members">
                    ${members.length > 0
                        ? members.map(member => `<span class="dispatch-unit-member-chip">${member.name} (${member.callsign || 'NO CALLSIGN'})</span>`).join('')
                        : '<span class="dispatch-unit-member-chip">No members</span>'}
                </div>
                <div class="dispatch-unit-add-member">
                    <select class="dispatch-unit-member-select" data-unit-id="${unit.id}">
                        <option value="">Add officer...</option>
                        ${availableOfficerOptions || '<option value="">No available officers</option>'}
                    </select>
                    <button class="dispatch-unit-add-btn" data-unit-id="${unit.id}" type="button">ADD</button>
                </div>
            </div>
            <div class="dispatch-unit-card-right">
                <span class="dispatch-unit-state">${isAssigned ? 'ASSIGNED' : (isOnline ? 'ONLINE' : 'OFFLINE')}</span>
                <button class="dispatch-unit-remove-btn" data-unit-id="${unit.id}" type="button">REMOVE</button>
            </div>
        `;

        const removeBtn = card.querySelector('.dispatch-unit-remove-btn');
        if (removeBtn) {
            removeBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                removeUnit(unit.id);
            });
        }

        const addMemberBtn = card.querySelector('.dispatch-unit-add-btn');
        if (addMemberBtn) {
            addMemberBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                const select = card.querySelector('.dispatch-unit-member-select');
                const selectedOfficerId = select ? select.value : '';
                if (!selectedOfficerId) return;
                addOfficerToUnit(unit.id, selectedOfficerId);
            });
        }

        const memberSelect = card.querySelector('.dispatch-unit-member-select');
        if (memberSelect) {
            ['mousedown', 'pointerdown', 'focus', 'click', 'keydown', 'change', 'input'].forEach(evt => {
                memberSelect.addEventListener(evt, () => touchDispatchUiInteraction());
            });
        }

        const focusMember = members.find(member => !!getOfficerById(member.id));
        if (focusMember) {
            card.addEventListener('click', () => {
                const officer = getOfficerById(focusMember.id);
                if (officer) focusMapOnOfficer(officer);
            });
        }
        boardList.appendChild(card);
    });

    restoreDispatchDropdownState({ memberByUnit: savedMemberState });
}

function refreshDispatchRoster(officers, opts) {
    opts = opts || {};
    if (Array.isArray(officers)) {
        dispatchRoster = officers;
    }

    normalizeDispatchUnits();
    bindDispatchUnitBuilder();
    populateDispatchUnitOfficerSelect();

    const nameInput = getEl('dispatch-unit-name');
    const officerSelect = getEl('dispatch-unit-officer');
    const createBtn = getEl('dispatch-create-unit-btn');
    if (nameInput) nameInput.disabled = false;
    if (officerSelect) officerSelect.disabled = false;
    if (createBtn) createBtn.disabled = false;

    if (opts.forceImmediate === true || !isDispatchSelectInteracting()) {
        renderDispatchUnitBoard();
    }

    if (opts.refreshAlerts) {
        renderDispatchAlerts(true);
    }

    if (typeof updateMarkers === 'function') {
        updateMarkers(dispatchRoster || []);
    }
}

function renderDispatchUnits(officers) {
    refreshDispatchRoster(officers, { refreshAlerts: true });
}

function focusMapOnOfficer(officer) {
    if (map && officer.coords) {
        const coords = convertCoords(officer.coords.x, officer.coords.y);
        map.setView(coords, 0);
        selectedOfficerMarkerId = String(officer.id);
        updateMarkers(dispatchRoster || []);
        
        // Update location text
        const locText = getEl('current-location-text');
        if (locText) locText.innerHTML = `Assigned to: ${officer.name}`;
    }
}

function renderDispatchAlerts(force) {
    if (!force && isDispatchSelectInteracting()) {
        queueRenderDispatchAlerts(400);
        return;
    }

    const list = getEl('dispatch-alerts-assign-list');
    if (!list) return;

    const savedDropdownState = captureDispatchDropdownState();
    list.innerHTML = '';
    
    if (currentActiveCalls.length === 0) {
        list.innerHTML = '<div class="empty-state">No recent alerts</div>';
        return;
    }

    // Sort calls by localTime (latest first)
    const sortedCalls = [...currentActiveCalls].sort((a, b) => {
        return (b.localTime || 0) - (a.localTime || 0);
    });

    sortedCalls.forEach(alert => {
        if (!Array.isArray(alert.assignedUnits)) {
            alert.assignedUnits = mapCallUnitsToAssignedUnits(alert.units);
        }

        const div = document.createElement('div');
        const alertType = alert.code === '10-99' ? 'high' : 'medium';
        div.className = `alert-card-dispatch ${alertType} dispatch-assign-card`;
        
        // Use the locally registered time
        const date = new Date(alert.localTime || Date.now());
        const displayTime = date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true });
        const unitOptions = dispatchUnits.length > 0
            ? dispatchUnits.map(unit => `<option value="${unit.id}">${unit.label}</option>`).join('')
            : '<option value="">No units created</option>';
        const assignedUnitsHtml = (alert.assignedUnits && alert.assignedUnits.length > 0)
            ? alert.assignedUnits.map(unit => `<span class="assigned-unit-chip">${unit.label}<button type="button" class="chip-remove-btn" data-call-id="${alert.id}" data-unit-id="${unit.id}">x</button></span>`).join('')
            : '<div class="empty-state" style="font-size: 0.93vh; padding: 0;">No units assigned</div>';

        div.innerHTML = `
            <div class="alert-card-left dispatch-assign-left">
                <h4>${alert.code || 'ALERT'} | ${alert.title || 'Dispatch Call'}</h4>
                <p style="margin-bottom: 4px;"><i class="fas fa-location-dot" style="font-size: 9px; margin-right: 4px; opacity: 0.7;"></i> ${alert.location || 'Unknown Location'}</p>
                <p style="font-size: 10px; opacity: 0.9; color: var(--primary-blue); margin-bottom: 6px;">${alert.info || 'No additional information.'}</p>
                <div class="assigned-units-wrap">${assignedUnitsHtml}</div>
            </div>
            <div class="alert-card-right dispatch-assign-right">
                <span class="alert-time">${displayTime} <i class="far fa-clock"></i></span>
                <button class="dispatch-locate-btn" type="button">LOCATE</button>
                <div class="assign-controls">
                    <select class="assign-unit-select" data-call-id="${alert.id}">
                        <option value="">Assign unit...</option>
                        ${unitOptions}
                    </select>
                    <div class="assign-action-row">
                        <button class="dispatch-direction-btn" type="button" data-call-id="${alert.id}">DIRECTION</button>
                        <button class="dispatch-assign-btn" type="button" data-call-id="${alert.id}">ASSIGN</button>
                    </div>
                </div>
            </div>
        `;

        const locateBtn = div.querySelector('.dispatch-locate-btn');
        if (locateBtn) {
            locateBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                focusMapOnAlert(alert, alertType);
            });
        }

        const directionBtn = div.querySelector('.dispatch-direction-btn');
        if (directionBtn) {
            directionBtn.addEventListener('click', async (e) => {
                e.stopPropagation();
                const ok = await setWaypointToAlertCoords(alert);
                if (!ok) {
                    console.warn('[PLT MDT] No valid world coords for this alert.');
                }
            });
        }

        const assignBtn = div.querySelector('.dispatch-assign-btn');
        if (assignBtn) {
            assignBtn.disabled = !canAssignDispatch;
            assignBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                touchDispatchUiInteraction();
                const select = div.querySelector('.assign-unit-select');
                const selectedUnitId = select ? select.value : '';
                if (!selectedUnitId) return;
                assignUnitToCall(alert.id, selectedUnitId);
            });
        }

        const assignSelect = div.querySelector('.assign-unit-select');
        if (assignSelect) {
            assignSelect.disabled = !canAssignDispatch;
            ['mousedown', 'pointerdown', 'focus', 'click', 'keydown', 'change', 'input'].forEach(evt => {
                assignSelect.addEventListener(evt, () => touchDispatchUiInteraction());
            });
        }

        div.querySelectorAll('.chip-remove-btn').forEach(btn => {
            btn.disabled = !canAssignDispatch;
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                removeAssignedUnitFromCall(btn.dataset.callId, btn.dataset.unitId);
            });
        });

        div.addEventListener('click', () => {
            const mapCoords = getAlertMapCoords(alert);
            if (map && mapCoords) map.setView(mapCoords, 2);
        });
        
        list.appendChild(div);
    });

    restoreDispatchDropdownState(savedDropdownState);
}

// Map implementation
let map = null;
let officerMarkers = {};
let dispatchOfficerPollInterval = null;
let dispatchOfficerPollBusy = false;

async function fetchDispatchOfficerLocations() {
    if (dispatchOfficerPollBusy) return;
    dispatchOfficerPollBusy = true;
    try {
        const resp = await fetch(`https://${GetParentResourceName()}/getOfficerLocations`, {
            method: 'POST',
            body: JSON.stringify({})
        });
        const officers = await resp.json();
        refreshDispatchRoster(officers || []);
    } catch (_) {
        // Silent fail to avoid UI noise during short network hiccups.
    } finally {
        dispatchOfficerPollBusy = false;
    }
}

function startDispatchOfficerPolling() {
    if (dispatchOfficerPollInterval) return;
    fetchDispatchOfficerLocations();
    dispatchOfficerPollInterval = setInterval(() => {
        if (isDispatchPageActive()) {
            fetchDispatchOfficerLocations();
        }
    }, 2000);
}

function stopDispatchOfficerPolling() {
    if (!dispatchOfficerPollInterval) return;
    clearInterval(dispatchOfficerPollInterval);
    dispatchOfficerPollInterval = null;
}

function loadDispatch() {
    renderDispatchUnits(dispatchRoster);
    loadDispatchCameras();
    startDispatchOfficerPolling();
    setTimeout(() => {
        if (!map) initMap();
        else {
            if (map) map.invalidateSize();
        }
    }, 100);
}

function convertCoords(x, y) {
    // Calibrated based on user provided data points:
    // P1: World(61.17, -1903.49) -> Map(Lat 191.48, Lng 472.4)
    // P2: World(-173.43, 6480.88) -> Map(Lat 904.36, Lng 445.31)
    const lng = (0.115473 * x) + 465.3366;
    const lat = (0.085025 * y) + 353.324;
    return [lat, lng];
}

function updateMarkers(officers) {
    if (!map) return;

    // Remove markers for officers no longer online
    const officerIds = officers.map(o => o.id);
    if (selectedOfficerMarkerId && !officerIds.some(id => String(id) === String(selectedOfficerMarkerId))) {
        selectedOfficerMarkerId = null;
    }
    Object.keys(officerMarkers).forEach(id => {
        if (!officerIds.includes(parseInt(id))) {
            map.removeLayer(officerMarkers[id]);
            delete officerMarkers[id];
        }
    });

    officers.forEach(officer => {
        if (!officer.coords) return;
        
        const coords = convertCoords(officer.coords.x, officer.coords.y);
        
        if (officerMarkers[officer.id]) {
            // Update existing marker
            officerMarkers[officer.id].setLatLng(coords);
            
            // Update the HTML content to reflect status change
            const unitType = officer.isMobile ? 'IN VEHICLE' : 'ON FOOT';
            const icon = officerMarkers[officer.id].getIcon();
            const isSelected = String(selectedOfficerMarkerId) === String(officer.id);
            const newHtml = `
                <div class="marker-avatar-modern" style="--marker-color: ${getJobColor(officer.job)}">
                    <span class="marker-avatar-glow"></span>
                    <i class="fas fa-${officer.isMobile ? 'car-side' : 'user-shield'}"></i>
                </div>
                <div class="marker-label-new ${isSelected ? 'is-visible' : ''}">
                    <span class="unit-type">${unitType}</span>
                    <span class="unit-name">${officer.name}</span>
                </div>
            `;
            
            if (icon.options.html !== newHtml) {
                officerMarkers[officer.id].setIcon(L.divIcon({
                    className: 'officer-marker-new',
                    html: newHtml,
                    iconSize: [32, 32],
                    iconAnchor: [16, 16]
                }));
            }
        } else {
            // Create new marker with custom circular avatar icon (Matching design)
            const unitType = officer.isMobile ? 'IN VEHICLE' : 'ON FOOT';
            const isSelected = String(selectedOfficerMarkerId) === String(officer.id);
            const officerIcon = L.divIcon({
                className: 'officer-marker-new',
                html: `
                    <div class="marker-avatar-modern" style="--marker-color: ${getJobColor(officer.job)}">
                        <span class="marker-avatar-glow"></span>
                        <i class="fas fa-${officer.isMobile ? 'car-side' : 'user-shield'}"></i>
                    </div>
                    <div class="marker-label-new ${isSelected ? 'is-visible' : ''}">
                        <span class="unit-type">${unitType}</span>
                        <span class="unit-name">${officer.name}</span>
                    </div>
                `,
                iconSize: [32, 32],
                iconAnchor: [16, 16]
            });

            const marker = L.marker(coords, {
                icon: officerIcon,
                title: officer.name
            }).addTo(map);
            marker.on('click', (e) => {
                if (e && e.originalEvent) e.originalEvent.stopPropagation();
                selectedOfficerMarkerId = String(officer.id);
                if (typeof fetchDispatchOfficerLocations === 'function') {
                    fetchDispatchOfficerLocations();
                } else {
                    updateMarkers(dispatchRoster || []);
                }
            });
            officerMarkers[officer.id] = marker;
        }
    });

    renderDispatchCameraMarkers();
}

function getJobColor(job) {
    if (job === 'police') return '#63A6C0';
    if (job === 'sheriff') return '#e67e22';
    if (job === 'fib') return '#9b59b6';
    return '#ffffff';
}

function initMap() {
    const mapEl = getEl('dispatch-map');
    if (!mapEl || typeof L === 'undefined') return;
    if (map) return; 

    try {
        map = L.map('dispatch-map', { 
            crs: L.CRS.Simple, 
            minZoom: -2, 
            maxZoom: 3, 
            zoomControl: false, 
            attributionControl: false 
        });
        
        const bounds = [[0, 0], [1024, 1024]];
        L.imageOverlay('img/map.png', bounds).addTo(map);
        map.on('click', () => {
            hidePanicSelector();
            hideMapContextMenu();
            if (!selectedOfficerMarkerId) return;
            selectedOfficerMarkerId = null;
            updateMarkers(dispatchRoster || []);
        });
        map.on('contextmenu', (e) => {
            lastMapRightClick = e;
            showMapContextMenu(e.containerPoint);
        });
        map.on('move zoom', () => {
            hideMapContextMenu();
        });
        
        // Initial view: Focused on the city center with 1.5x zoom
        map.setView([400, 500], 1); 

        if (typeof updateMarkers === 'function') {
            updateMarkers(dispatchRoster || []);
        }
        
        // "YOU" Button Functionality
        const youBtn = document.querySelector('.you-btn');
        if (youBtn) {
            youBtn.onclick = () => {
                // Focus map on city center
                map.setView([400, 500], 1);
            };
        }

        const panicBtn = getEl('mdt-panic-btn');
        if (panicBtn) {
            panicBtn.onclick = () => {
                showPanicSelector();
            };
        }

        const closePanicBtn = getEl('close-panic-modal');
        if (closePanicBtn) {
            closePanicBtn.onclick = () => {
                hidePanicSelector();
            };
        }

        // Request initial positions
        fetch(`https://${GetParentResourceName()}/getOfficerLocations`, { 
            method: 'POST', 
            body: JSON.stringify({}) 
        }).catch(() => {});

        // Add Zoom Controls Logic
        const zoomInBtn = getEl('map-zoom-in');
        const zoomOutBtn = getEl('map-zoom-out');
        if (zoomInBtn) zoomInBtn.onclick = () => map.zoomIn();
        if (zoomOutBtn) zoomOutBtn.onclick = () => map.zoomOut();
        
        // Context Menu Action Listeners
        document.querySelectorAll('.context-item').forEach(item => {
            item.onclick = (e) => {
                e.stopPropagation();
                const action = item.dataset.action;
                handleMapContextAction(action);
                hideMapContextMenu();
            };
        });
        
    } catch (e) {
        console.error("[PLT MDT] Map Init Error:", e);
    }
}

function showMapContextMenu(point) {
    const menu = getEl('map-context-menu');
    if (!menu) return;
    
    menu.style.left = `${point.x + 5}px`;
    menu.style.top = `${point.y + 5}px`;
    menu.classList.remove('hidden');
    hidePanicSelector();
}

function hideMapContextMenu() {
    const menu = getEl('map-context-menu');
    if (menu) menu.classList.add('hidden');
}

function handleMapContextAction(action) {
    if (!lastMapRightClick) return;
    const latlng = lastMapRightClick.latlng;
    const world = convertMapToWorld(latlng.lat, latlng.lng);

    switch (action) {
        case 'search-zone':
            const zone = L.circle(latlng, {
                radius: 15,
                color: '#3498db',
                fillColor: '#3498db',
                fillOpacity: 0.2,
                weight: 2
            }).addTo(map);
            mapSearchZones.push(zone);
            
            // Auto-remove search zone after 10 seconds
            setTimeout(() => {
                if (map && zone) {
                    map.removeLayer(zone);
                    mapSearchZones = mapSearchZones.filter(z => z !== zone);
                }
            }, 10000);
            break;
            
        case 'create-call':
            showPanicSelector(latlng);
            break;
            
        case 'set-waypoint':
            fetch(`https://${GetParentResourceName()}/setWaypoint`, {
                method: 'POST',
                body: JSON.stringify({ x: world.x, y: world.y })
            }).catch(() => {});
            Framework.Notify("Waypoint set to clicked location.", "success");
            break;
            
        case 'mark-location':
            // Clear existing custom markers first (ensures only one "waypoint" marker exists)
            mapCustomMarkers.forEach(m => map.removeLayer(m));
            mapCustomMarkers = [];

            const marker = L.marker(latlng, {
                icon: L.divIcon({
                    className: 'custom-map-marker',
                    html: '<i class="fas fa-thumbtack" style="color: #e74c3c; font-size: 1.48vh;"></i>',
                    iconSize: [24, 24],
                    iconAnchor: [12, 24]
                })
            }).addTo(map);
            mapCustomMarkers.push(marker);
            break;
            
        case 'request-backup':
            triggerPanicAlert({ code: '10-78', title: 'EMS NEEDS HELP' }, latlng);
            break;
    }
}

function convertMapToWorld(lat, lng) {
    // Inverse of convertCoords:
    // lng = (0.115473 * x) + 465.3366  => x = (lng - 465.3366) / 0.115473
    // lat = (0.085025 * y) + 353.324   => y = (lat - 353.324) / 0.085025
    const x = (lng - 465.3366) / 0.115473;
    const y = (lat - 353.324) / 0.085025;
    return { x, y };
}

function showPanicSelector(customLatLng) {
    const modal = getEl('panic-modal');
    const list = getEl('panic-alerts-list');
    if (!modal || !list) return;

    list.innerHTML = '';
    
    // Default fallback if config fails to pass data
    const alerts = (panicAlerts && panicAlerts.length > 0) ? panicAlerts : [
        { code: "10-52", title: "PATIENT IN DISTRESS", color: "#ff3e3e", icon: "fa-heart-pulse" },
        { code: "10-78", title: "EMS NEEDS HELP", color: "#ff9800", icon: "fa-triangle-exclamation" },
    ];

    alerts.forEach(alert => {
        const item = document.createElement('div');
        item.className = 'panic-item';
        const color = (alert && alert.color) || '#ef4444';
        item.style.setProperty('--panic-color', color);
        item.innerHTML = `
            <span class="panic-code">${alert.code || '10-99'}</span>
            <span class="panic-title">${alert.title || 'Emergency Call'}</span>
        `;
        item.onclick = (e) => {
            e.stopPropagation();
            triggerPanicAlert(alert, customLatLng);
            hidePanicSelector();
        };
        list.appendChild(item);
    });

    modal.classList.remove('hidden');
}

function hidePanicSelector() {
    const modal = getEl('panic-modal');
    if (!modal) return;
    modal.classList.add('hidden');
}

function triggerPanicAlert(alert, customLatLng) {
    let coords = null;
    if (customLatLng) {
        coords = convertMapToWorld(customLatLng.lat, customLatLng.lng);
    }

    fetch(`https://${GetParentResourceName()}/triggerPanic`, {
        method: 'POST',
        body: JSON.stringify({ 
            code: alert.code,
            title: alert.title,
            coords: coords // Send custom coords if provided
        })
    }).catch(() => {});

    // Visual feedback on the map button
    const panicBtn = getEl('mdt-panic-btn');
    if (panicBtn) {
        panicBtn.style.animation = 'none';
        panicBtn.style.background = alert.color;
        setTimeout(() => {
            panicBtn.style.animation = 'panic-blink 1s infinite alternate';
            panicBtn.style.background = 'rgba(255, 0, 0, 0.1)';
        }, 2000);
    }
}

// Criminal Code Logic
let allChargesData = [];
let currentChargeFilter = 'All';

async function loadCharges() {
    console.log("[PLT MDT] Loading charges...");
    try {
        const response = await fetch(`https://${GetParentResourceName()}/getAllCharges`, {
            method: 'POST',
            body: JSON.stringify({})
        });
        const data = await response.json();
        if (data) {
            allChargesData = data;
            console.log("[PLT MDT] Charges loaded:", allChargesData.length);
        }
        
        // Only attempt to render if we are on the charges page or initialization
        const grid = getEl('charges-list-grid');
        if (grid) {
            renderChargeCategories();
            filterCharges(currentChargeFilter || 'All');
        }
        renderMedicalTagsLibrary();
        renderMedicalRecordsPage();
    } catch (err) {
        console.error("[PLT MDT] Error loading charges:", err);
        const grid = getEl('charges-list-grid');
        if (grid) grid.innerHTML = '<div class="empty-state">Failed to load criminal code.</div>';
    }
}

function renderChargeCategories() {
    const container = getEl('charge-categories');
    if (!container) return;

    if (!Array.isArray(allChargesData)) {
        console.warn("[PLT MDT] allChargesData is not an array:", allChargesData);
        container.innerHTML = '';
        return;
    }

    const categories = ['All', ...new Set(allChargesData.map(c => c.category || 'General'))];
    container.innerHTML = '';

    categories.forEach(cat => {
        const item = document.createElement('div');
        item.className = `category-item ${currentChargeFilter === cat ? 'active' : ''}`;
        
        // Count charges in this category
        const count = cat === 'All' ? allChargesData.length : allChargesData.filter(c => c.category === cat).length;
        
        item.innerHTML = `
            <span>${cat.toUpperCase()}</span>
            <span style="font-size: 9px; opacity: 0.4;">${count}</span>
        `;
        item.onclick = () => filterCharges(cat);
        container.appendChild(item);
    });
}

function filterCharges(category) {
    currentChargeFilter = category;
    
    // Update active state in sidebar
    document.querySelectorAll('.category-item').forEach(item => {
        const span = item.querySelector('span');
        if (span && span.innerText === category.toUpperCase()) item.classList.add('active');
        else item.classList.remove('active');
    });

    if (!Array.isArray(allChargesData)) return;

    const searchInput = getEl('charge-search-input');
    const searchVal = searchInput ? searchInput.value.toLowerCase() : '';
    
    const filtered = allChargesData.filter(c => {
        const matchesCat = category === 'All' || c.category === category;
        const matchesSearch = (c.title || '').toLowerCase().includes(searchVal) || (c.description || '').toLowerCase().includes(searchVal);
        return matchesCat && matchesSearch;
    });

    // Update Header
    const titleEl = getEl('current-category-title');
    const descEl = getEl('current-category-desc');
    const countEl = getEl('charge-count');

    if (titleEl) titleEl.innerText = category === 'All' ? 'ALL OFFENSES' : category.toUpperCase();
    if (descEl) descEl.innerText = `Reviewing ${filtered.length} documented laws under ${category === 'All' ? 'the entire penal code' : category}.`;
    if (countEl) countEl.innerText = filtered.length;

    renderChargesGrid(filtered);
}

function renderChargesGrid(charges) {
    const grid = getEl('charges-list-grid');
    if (!grid) return;
    grid.innerHTML = '';

    if (!Array.isArray(charges) || charges.length === 0) {
        grid.innerHTML = '<div class="empty-state">No matching offenses found. Please ensure charges are added to the database.</div>';
        return;
    }

    charges.forEach(charge => {
        const row = document.createElement('div');
        row.className = 'code-row';
        
        row.innerHTML = `
            <div class="col-offense">
                <span class="offense-title">${charge.title.toUpperCase()}</span>
                <span class="offense-desc">${charge.description}</span>
            </div>
            <div class="col-fine">
                <span class="fine-amount">$${charge.fine.toLocaleString()}</span>
            </div>
            <div class="col-jail">
                <span class="jail-time">${charge.jail} MONTHS</span>
            </div>
            <div class="col-actions">
                <button class="view-info-btn" title="View Full Description"><i class="fas fa-circle-info"></i></button>
            </div>
        `;

        row.querySelector('.view-info-btn').onclick = () => {
            // Reuse record details for full description popup
            openRecordDetails({
                title: charge.title,
                created_at: null,
                location: charge.category.toUpperCase(),
                officer: 'PENAL CODE',
                charges: `$${charge.fine.toLocaleString()} Fine / ${charge.jail} Months`,
                description: charge.description
            });
        };

        grid.appendChild(row);
    });
}

const chargeSearchInput = getEl('charge-search-input');
if (chargeSearchInput) {
    chargeSearchInput.addEventListener('input', () => {
        filterCharges(currentChargeFilter);
    });
}

const hospitalRefreshBtn = getEl('hm-refresh-btn');
if (hospitalRefreshBtn) {
    hospitalRefreshBtn.addEventListener('click', () => {
        loadHospitalManagement({ forceRefresh: true });
    });
}

// Officer Page Events
if (getEl('save-officer-settings')) {
    getEl('save-officer-settings').addEventListener('click', saveOfficerSettings);
}

if (getEl('officer-duty-status')) {
    getEl('officer-duty-status').addEventListener('change', updateMyDutyPill);
}

// ETA System Logic
window.submitETA = function() {
    const name = getEl('eta-form-name').value;
    const type = getEl('eta-form-type').value;
    const minutes = getEl('eta-form-minutes').value;

    fetch(`https://${GetParentResourceName()}/submitETA`, {
        method: 'POST',
        body: JSON.stringify({
            name: name,
            type: type,
            minutes: minutes
        })
    }).then(() => {
        // Optional: clear form or show success
    }).catch(err => {
        console.error("[PLT MDT] Error submitting ETA:", err);
    });
};
