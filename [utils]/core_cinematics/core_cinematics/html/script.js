/* ═══════════════════════════════════════════════════════════════════════════
   CORE CINEMATICS — script.js
════════════════════════════════════════════════════════════════════════════ */
'use strict';

// ── STATE ─────────────────────────────────────────────────────────────────────
const State = {
    keyframes:      [],
    cameraAnchor:   false,  // pin the player ped to the free camera (see CC.toggleCameraAnchor)
    selectedKfId:   null,
    // Multi-selection. selectedKfId stays the "primary" — the one whose
    // properties the side panel edits — while this is everything a drag moves.
    // Entries are { kind: 'kf' | 'text' | 'overlay', id }, so a marquee can hold
    // keyframes, 3D text clips and overlay recordings in one selection and drag
    // them together.
    selection:      [],
    fps:            30,
    durationSec:    30,
    currentFrame:   0,
    isPlaying:      false,
    isPositionMode: false,
    zoom:           2.0,
    shakeTypes:     [],
    colorFilters:   [],
    fovMin:         5,
    fovMax:         120,
    defaultFov:     50,
    draggingKfId:   null,
    dragStartX:     0,
    dragStartFrame: 0,
    nextId:         1,
    // World & Scenery settings
    worldSettings: { time: 12.0, freezeTime: false, weather: 'CLEAR', weatherOverride: true, rainEnabled: false, rainLevel: 0.0, windSpeed: 0, cityLights: false },
    fonts: [],
    // Interpolation settings
    interpSettings: { mode: 'eased', tension: 0.0, spring: 0.0 },
    // Vehicle recording (null when none loaded)
    vehicleRecording:  null,  // { duration, totalFrames, count }
    vehicleRecStart:   0,     // timeline frame where block starts
    vehicleRecEnd:     0,     // timeline frame where block ends
    vehicleRecTrimIn:  0,     // frames INTO the recording where playback starts (front trim)
    vehicleRecSelected: false, // whether the recording block is selected
    draggingVehRec:    null,  // { type, startX, origStart, origEnd, origTrimIn }
    // Main-recording clips. The recording file is immutable; cuts/trims are
    // metadata stored here (and in the project JSON as vehicleRecClips). One
    // clip = a slice of the source at a timeline position. Pre-cut: a single
    // clip spanning the whole recording (identical to the old single-bar view).
    vehicleRecClips:   [],    // [{ id, startFrame, endFrame, trimInFrame }]
    cutMode:           false, // razor tool armed — clicking a clip splits it
    draggingVehClip:   null,  // { clipIdx, type, startX, origStart, origEnd, origTrimIn }
    selectedVehClipIdx: null, // which main-rec clip is selected (for per-clip delete)
    // Live camera position (updated by Lua every 150ms + every frame in position mode)
    currentCamPos:  { x: 0, y: 0, z: 0 },
    currentCamRot:  { x: 0, y: 0, z: 0 },
    currentCamFov:  50,
    // Saved position before entering position mode (for ESC cancel)
    savedCamPos:    null,
    savedCamRot:    null,
    savedCamFov:    null,
    // 3D Text / Image
    textObjects:      [],   // [{ id, text, font, color, shadow, animation, animIn, animOut, size, coords, imageUrl?, aspect? }]
    textClips:        [],   // [{ id, textId, startFrame, endFrame }]
    nextTextId:       1,
    nextTextClipId:   1,
    imageAspect:      1.0,  // last auto-detected image aspect (w/h) for the text/image panel
    editingKind:      'text', // kind of 3D object being created/edited: 'text' | 'image'
    selectedClipId:   null,
    editingClipId:    null, // clip being edited in the text panel
    draggingClip:     null, // { clipId, type:'move'|'resizeL'|'resizeR', startX, origStart, origEnd }
    isTextPlacing:    false,
    shadowEnabled:    false,
    glowEnabled:      false,
    outlineEnabled:   false,
    colorShiftEnabled:false,
    colorShiftAdvanced:false,
    // Scene Editor
    sceneEntities:    [],   // [{ id, type:'ped'|'vehicle', model, pos, heading, anim, weapon, followPlayer, followDist, followSpeed, driveStyle }]
    nextSceneId:      1,
    selectedSceneId:  null,
    isScenePlacing:   false,
    predefinedAnims:  [],
    commonWeapons:    [],
    recEntityList:    [],   // [{ type:'vehicle'|'ped', idx, model, isPlayer }] from Lua
    rpemotesReady:    false, // true when the rpemotes fork's integration exports respond
    rpemotesLibrary:  [],    // [{ name, label, type }] full emote list from the fork
    pathSharingEnabled: true,
    // Ped appearance editor
    pedAppearanceEdit:    null,  // { entityId, model, appearance, debounceTimer }
    scenePedAppearances:  {},    // [entityId] = appearance (cache)
    scenePedVariationMax: {},    // [entityId] = { components, props } variation caps from Lua
    presets:              [],    // global reusable library [{ id, kind:'ped'|'vehicle', name, model, appearance?, props? }]
    presetTab:            'ped', // which half of the SAVED list is showing
    isVehiclePicking:     false, // choosing a car to seat a ped in (freecam + crosshair)
    vehiclePickPedId:     null,  // the ped that pick is for
    // Overlay layers (solo-vehicle recordings, session-only)
    overlayLayers:     [],   // [{ id, name, model, duration, totalFrames, startFrame, endFrame, trimInFrame }]
    selectedOverlayId: null, // id of selected overlay layer
    draggingOverlay:   null, // { layerIdx, type:'move'|'resizeL'|'resizeR', startX, origStart, origEnd, origTrimIn }
    recLoading:        false, // true while recording data is arriving via latent event
    // Project system
    currentProject:      null,  // { slug, name, createdAt, updatedAt }
    projectList:         [],
    autoSaveTimer:       null,
    autoSaveDirty:       false,
};

// ── NUI POST ──────────────────────────────────────────────────────────────────
function post(event, data = {}) {
    fetch(`https://core_cinematics/${event}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    }).catch(() => {});
}

async function postAwait(event, data = {}) {
    try {
        const res = await fetch(`https://core_cinematics/${event}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
        });
        return await res.json();
    } catch { return null; }
}

// ── LOCALE / TRANSLATION HELPER ───────────────────────────────────────────────
// Populated from Lua via the `show` NUI message (see onShow below).
// Usage: t('editor.save_project') or t('notifications.project_saved', { name: 'Intro' })
let _localeData = {};
function t(key, params) {
    const parts = String(key).split('.');
    let val = _localeData;
    for (const p of parts) {
        if (val && typeof val === 'object') val = val[p];
        else return key;
    }
    if (typeof val !== 'string') return key;
    if (params) {
        val = val.replace(/\{(\w+)\}/g, (_, k) =>
            params[k] !== undefined ? String(params[k]) : `{${k}}`);
    }
    return val;
}

// ── INIT / NUI MESSAGE HANDLER ────────────────────────────────────────────────
window.addEventListener('message', (e) => {
    const d = e.data;
    switch (d.type) {
        case 'show':             onShow(d);                   break;
        case 'hide':             onHide();                    break;
        case 'coordsUpdate':     onCoordsUpdate(d);           break;
        case 'frameUpdate':      onFrameUpdate(d.frame);      break;
        case 'positionModeOn':   onPositionModeOn();          break;
        case 'positionSaved':    onPositionSaved(d);          break;
        case 'positionCancelled':onPositionCancelled();       break;
        case 'playbackStarted':  onPlaybackStarted();         break;
        case 'playbackStopped':  onPlaybackStopped(d);        break;
        case 'playbackError':           showToast(d.msg, 'error');        break;
        case 'vehicleRecordingLoaded':  onVehicleRecordingLoaded(d);     break;
        case 'overlayLayersLoaded':     onOverlayLayersLoaded(d);        break;
        case 'textPlacementActive':     onTextPlacementOverlay(d.active); break;
        case 'textPlacementDone':       onTextPlacementDone(d);           break;
        case 'sceneEntitySpawned':      onSceneEntitySpawned(d);          break;
        case 'sceneEntityDeleted':      onSceneEntityDeleted(d);          break;
        case 'sceneCombatState':        onSceneCombatState(d);            break;
        case 'sceneSpawnError':         showToast(d.msg, 'error');        break;
        case 'sceneEntitySkipped':      onSceneEntitySkipped(d);          break;
        case 'sceneFollowFailed':       onSceneFollowFailed(d);           break;
        case 'scenePlacementActive':    onScenePlacementOverlay(d.active); break;
        case 'vehiclePickActive':       onVehiclePickOverlay(d.active);   break;
        case 'vehiclePickTarget':       setPickTarget(d.label);           break;
        case 'vehiclePickResult':       onVehiclePickResult(d);           break;
        case 'scenePlacementDone':      onScenePlacementDone(d);          break;
        case 'replayEntityClicked':     onReplayEntityClicked(d);         break;
        case 'sceneEntityClicked':      openSceneEntityProps(d.entityId); break;
        case 'modelSwapDone':           onModelSwapDone(d);               break;
        case 'modelSwapError':          showToast(d.msg, 'error');        break;
        case 'recordingEntityDeleted':  onRecordingEntityDeleted(d);      break;
        case 'fxUpdate':                onFxUpdate(d);                    break;
        case 'fxClear':                 onFxClear();                      break;
        case 'gameFps':                 onGameFps(d.fps);                 break;
        case 'recordingCountdown':      onRecordingCountdown();           break;
        case 'recordingStarted':        onRecordingStarted();             break;
        case 'toast':                   showToast(d.msg, d.level || 'info'); break;
        case 'exportSaved':             showToast(`${t('toasts.timeline_exported')}  →  ${d.path}`); break;
        case 'exportFailed':            showToast(d.msg || 'Export failed', 'error'); break;
        case 'recordingStopped':        onRecordingStopped();             break;
        case 'recordingFinished':       onRecordingFinished();            break;
        case 'recLoading':              State.recLoading = true;  renderTimeline(); break;
        case 'recLoaded':               State.recLoading = false; renderTimeline(); break;
        case 'tutorialAdderPos':        State._tutCarPos = d.pos;         break;
        case 'recordingTick':           onRecordingTick(d.elapsed);       break;
        case 'keyframesUpdated':
            // Lua mutated keyframes (e.g. recording deletion auto-unlocked
            // anything that was locked to a vehicle in that recording).
            // Refresh JS state so save/load and rendering match.
            if (Array.isArray(d.keyframes)) {
                State.keyframes = migrateKeyframeCuts(d.keyframes);
                renderTimeline();
                if (State.selectedKfId !== null) {
                    const kf = State.keyframes.find(k => k.id === State.selectedKfId);
                    if (kf) populateSidePanel(kf);
                }
            }
            break;
        case 'rpemotesStatus':       // legacy event name
        case 'animProviderStatus':
            State.rpemotesReady   = !!d.ready;
            if (Array.isArray(d.library)) State.rpemotesLibrary = d.library;
            updateRpemotesWarning();
            populateEmoteLibrary();
            updateSceneAnimMode();
            break;
        case 'projectList':             onProjectList(d.projects);        break;
        case 'projectTail':             onProjectTail(d.tail);            break;
        case 'projectTailError':        onProjectTailError(d.message);    break;
        case 'projectLoaded':           onProjectLoaded(d.data);          break;
        case 'projectSaved':            onProjectSaved(d.slug);           break;
        case 'projectDeleted':          onProjectDeleted(d.slug);         break;
        case 'projectMetaUpdated':
            // Server confirmed a settings save — rehydrate that entry in the
            // local list so badge / name / duration reflect what's on disk.
            if (d.entry && d.entry.slug) {
                const i = State.projectList.findIndex(p => p.slug === d.entry.slug);
                if (i >= 0) State.projectList[i] = Object.assign({}, State.projectList[i], d.entry);
                renderProjectList();
                // Mirror server-confirmed values onto the open project too,
                // so a server-side normalization (e.g. trimmed name) wins
                // over the optimistic value we set on apply.
                if (State.currentProject && State.currentProject.slug === d.entry.slug) {
                    if (typeof d.entry.name === 'string') {
                        State.currentProject.name = d.entry.name;
                        const tbName = document.getElementById('tb-project-name');
                        if (tbName) tbName.textContent = d.entry.name || State.currentProject.slug;
                    }
                    if (typeof d.entry.state === 'string') {
                        State.currentProject.state = d.entry.state;
                    }
                    if (typeof d.entry.durationSec === 'number') {
                        State.durationSec = d.entry.durationSec;
                        const durInput = document.getElementById('duration-input');
                        if (durInput) durInput.value = d.entry.durationSec;
                    }
                }
            }
            break;
        case 'projectLoadError':        showToast(d.msg, 'error');        break;
        case 'scenePedAppearance':      onScenePedAppearance(d);          break;
        case 'presetList':              onPresetList(d);                  break;
        case 'sceneSeatsCleared':       onSceneSeatsCleared(d);           break;
    }
});

// Walks the DOM and applies current locale to [data-i18n] / [data-i18n-attr] elements.
// Safe to call repeatedly. Elements tagged with `data-i18n-html` use innerHTML so
// markup inside the translated string (e.g. <strong>) is preserved.
function applyStaticI18n(root) {
    const scope = root || document;
    scope.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        const val = t(key);
        if (val === key) return;
        if (el.hasAttribute('data-i18n-html')) el.innerHTML = val;
        else el.textContent = val;
    });
    scope.querySelectorAll('[data-i18n-attr]').forEach(el => {
        const spec = el.getAttribute('data-i18n-attr');
        spec.split(';').forEach(pair => {
            const [attr, key] = pair.split(':').map(s => s && s.trim());
            if (!attr || !key) return;
            const val = t(key);
            if (val !== key) el.setAttribute(attr, val);
        });
    });
}

function onShow(d) {
    if (d.locale && typeof d.locale === 'object') {
        _localeData = d.locale;
        applyStaticI18n();
    }
    State.fps          = d.fps        || 30;
    State.shakeTypes   = d.shakes     || [];
    State.colorFilters = d.filters    || [];
    State.fonts        = d.fonts      || [];
    State.fovMin       = d.fovMin     || 5;
    State.fovMax       = d.fovMax     || 120;
    State.defaultFov   = d.defaultFov || 50;

    // Restore persisted duration from Lua; fall back to current State value (default 30)
    if (d.totalFrames && d.totalFrames > 0) {
        State.durationSec = d.totalFrames / State.fps;
    }

    State.predefinedAnims = d.predefinedAnims || [];
    State.commonWeapons  = d.commonWeapons  || [];
    State.externalKeyframes = Array.isArray(d.externalKeyframes) ? d.externalKeyframes : [];
    State.tutorialDefault = d.tutorialDefault !== false;
    State.weatherConflicts = Array.isArray(d.weatherConflicts) ? d.weatherConflicts : [];
    State.rpemotesReady    = !!d.rpemotesReady;
    State.isAdmin          = !!d.isAdmin;
    State.rpemotesLibrary  = Array.isArray(d.rpemotesLibrary) ? d.rpemotesLibrary : [];
    State.autosaveInterval = d.autosaveInterval || 30000;
    State.exporterUrl      = d.exporterUrl || 'http://127.0.0.1:7861';
    // 4K-upscale toggle only makes sense below 4K — at native 4K the
    // recorder's resolution cap makes it a no-op, so hide the rows.
    // NUI runs at the game's render resolution, so screen.width is
    // authoritative for "is this footage already 4K".
    {
        const sub4k = ((window.screen && window.screen.width) || window.innerWidth) < 3200;
        const row  = document.getElementById('export-upscale-row');
        const hint = document.getElementById('export-upscale-hint-row');
        if (row)  row.style.display  = sub4k ? '' : 'none';
        if (hint) hint.style.display = sub4k ? '' : 'none';
    }
    State.defaultInterp    = d.defaultInterp || 'eased';
    State.defaultEasing    = d.defaultEasing || 'ease';
    // Apply the configured default interp mode to the editor state if no project-specific setting has kicked in yet
    if (State.interpSettings && !State.currentProject) {
        State.interpSettings.mode = State.defaultInterp;
    }
    updateWeatherConflictWarning();
    updateRpemotesWarning();
    populateEmoteLibrary();
    updateSceneAnimMode();

    populateShakeDropdown();
    populateFilterDropdown();
    populateFontDropdown();
    populateSceneDropdowns();
    injectFontLinks(State.fonts);
    initCustomDropdowns();

    document.getElementById('app').classList.remove('hidden');
    document.getElementById('duration-input').value = State.durationSec;
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) Tutorial.onUIShown();

    // Show project overlay or timeline depending on whether a project is active
    if (State.currentProject) {
        hideProjectOverlay();
        document.getElementById('tb-project-name').textContent = State.currentProject.name || State.currentProject.slug;
        startAutoSave();
    } else {
        showProjectOverlay();
    }

    // Init share button state
    document.getElementById('tb-share-btn').classList.toggle('active', State.pathSharingEnabled);

    renderTimeline();
    updateTimecodeDisplay();
}

function onHide() {
    // A pick left running would keep an outline on a car and a banner on screen
    // with no focus left to dismiss either.
    endVehiclePick();
    document.getElementById('app').classList.add('hidden');
    document.getElementById('new-project-modal')?.classList.add('hidden');
    document.getElementById('project-settings-modal')?.classList.add('hidden');
    // The ruler tooltip is a fixed-position element on document.body — hiding
    // #app doesn't hide it because it lives outside the app container. Dismiss
    // it explicitly so it doesn't bleed into the world after closeUI.
    hideRulerTooltip();
    // Same story for the cinematic effects overlay — it is a sibling of #app,
    // so a fade/grain left active on the current keyframe would stay on screen
    // after the editor closes, with no focus left to dismiss it.
    onFxClear();
    // Final auto-save before closing, then stop the timer
    if (State.currentProject) autoSaveProject();
    if (State.autoSaveTimer) { clearInterval(State.autoSaveTimer); State.autoSaveTimer = null; }
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) Tutorial.onUIHidden();
}

function onVehicleRecordingLoaded(d) {
    const vc = d.count    || 0;
    const pc = d.pedCount || 0;
    const isNew = !State.vehicleRecording ||
                  State.vehicleRecording.totalFrames !== d.totalFrames ||
                  State.vehicleRecording.count       !== vc ||
                  State.vehicleRecording.pedCount    !== pc;

    State.vehicleRecording = { duration: d.duration, totalFrames: d.totalFrames, count: vc, pedCount: pc };
    State.recEntityList    = d.entities || [];

    // Lua always sends current timing — use it to restore exact block position
    State.vehicleRecStart  = d.startFrame  !== undefined ? d.startFrame  : 0;
    State.vehicleRecEnd    = d.endFrame    !== undefined ? d.endFrame    : d.totalFrames;
    State.vehicleRecTrimIn = d.trimInFrame !== undefined ? d.trimInFrame : 0;

    // Clip list — drives the multi-bar render + cut tool. Lua sends `clips`
    // (the authoritative vehicleRecClips); fall back to a single clip built
    // from the legacy envelope so older projects / first loads still work.
    if (Array.isArray(d.clips) && d.clips.length) {
        State.vehicleRecClips = d.clips.map((c, i) => ({
            id:          i + 1,
            startFrame:  c.startFrame  || 0,
            endFrame:    c.endFrame    != null ? c.endFrame : d.totalFrames,
            trimInFrame: c.trimInFrame || 0,
        }));
    } else {
        State.vehicleRecClips = [{
            id: 1,
            startFrame:  State.vehicleRecStart,
            endFrame:    State.vehicleRecEnd,
            trimInFrame: State.vehicleRecTrimIn,
        }];
    }

    // Auto-extend timeline if recording is longer than the current duration
    const recEndSec = Math.ceil(State.vehicleRecEnd / State.fps);
    if (recEndSec > State.durationSec) {
        State.durationSec = recEndSec;
        document.getElementById('duration-input').value = recEndSec;
        syncKeyframesToLua(); // persist the new totalFrames to Lua
    }

    renderTimeline();
    if (isNew) {
        let key;
        if (vc > 0 && pc > 0)      key = 'toasts.recording_loaded_mixed';
        else if (vc > 0)           key = vc > 1 ? 'toasts.vehicles_loaded' : 'toasts.vehicle_loaded';
        else                       key = pc > 1 ? 'toasts.peds_loaded'     : 'toasts.ped_loaded';
        showToast(t(key, { count: vc + pc, vehicles: vc, peds: pc, duration: d.duration.toFixed(1), frames: d.totalFrames }));
    }
}

function onCoordsUpdate(d) {
    if (!d.pos || !d.rot) return;
    State.currentCamPos = d.pos;
    State.currentCamRot = d.rot;
    State.currentCamFov = d.fov || State.defaultFov;

    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) Tutorial.onCoords(d.pos);

    // Update HUD
    document.getElementById('hud-pos').textContent =
        `X: ${d.pos.x.toFixed(2)} · Y: ${d.pos.y.toFixed(2)} · Z: ${d.pos.z.toFixed(2)}`;
    document.getElementById('hud-rot').textContent =
        `P: ${d.rot.x.toFixed(1)} · R: ${d.rot.y.toFixed(1)} · Y: ${d.rot.z.toFixed(1)}`;
    document.getElementById('hud-fov').textContent =
        `FOV: ${(d.fov || State.defaultFov).toFixed(1)}`;

    // If in position mode, update the side panel inputs live
    if (State.isPositionMode && State.selectedKfId !== null) {
        document.getElementById('sp-pos-x').value = d.pos.x.toFixed(4);
        document.getElementById('sp-pos-y').value = d.pos.y.toFixed(4);
        document.getElementById('sp-pos-z').value = d.pos.z.toFixed(4);
        document.getElementById('sp-rot-x').value = d.rot.x.toFixed(2);
        document.getElementById('sp-rot-y').value = d.rot.y.toFixed(2);
        document.getElementById('sp-rot-z').value = d.rot.z.toFixed(2);
        document.getElementById('sp-fov-slider').value = d.fov;
        document.getElementById('sp-fov-num').value    = (d.fov || State.defaultFov).toFixed(1);
    }

    // Feed live data to placement guide
    PlacementGuide.update(d.pos, d.rot, d.fov || State.defaultFov);
}

function onFrameUpdate(frame) {
    State.currentFrame = frame;
    updatePlayheadPosition();
    updateTimecodeDisplay();
    document.getElementById('frame-input').value = frame;
}

function onPositionModeOn() {
    State.isPositionMode = true;
    PlacementGuide.show('camera');
    document.getElementById('side-panel').classList.add('dimmed');
    document.getElementById('sp-pos-btn').disabled = true;
}

async function onPositionSaved(d) {
    State.isPositionMode = false;
    PlacementGuide.hide();
    document.getElementById('side-panel').classList.remove('dimmed');
    document.getElementById('sp-pos-btn').disabled = false;

    if (State.selectedKfId === null) return;
    const kf = State.keyframes.find(k => k.id === State.selectedKfId);
    if (!kf) return;

    kf.fov = d.fov;

    if (kf.lockedVehicle != null) {
        // Lua sends WORLD coords (GetCamCoord); a locked kf stores
        // vehicle-local offsets. Skipping this conversion was sending the
        // kf "into the sea" because the next render did
        // vehicleLocalToWorld(worldCoords) → vehicle.pos + (worldCoords
        // rotated by yaw) — somewhere across the map.
        const r = await postAwait('convertKeyframeLock', {
            frame: kf.frame,
            pos:   d.pos,
            rot:   d.rot,
            lockedVehicle: kf.lockedVehicle,
        });
        if (r && r.error === 'out_of_range') {
            // Vehicle isn't in its recorded path at this frame anymore.
            // Don't lose the user's placement — drop the lock and store world.
            delete kf.lockedVehicle;
            kf.pos = { x: d.pos.x, y: d.pos.y, z: d.pos.z };
            kf.rot = { x: d.rot.x, y: d.rot.y, z: d.rot.z };
            showToast(t('toasts.vehicle_out_of_range_at_kf'), 'error');
        } else if (r && r.pos) {
            kf.pos = r.pos;
            kf.rot = r.rot;
        } else {
            // Lua call failed — fall back to world coords + drop lock so
            // we don't end up with a kf whose "offset" is actually world.
            delete kf.lockedVehicle;
            kf.pos = { x: d.pos.x, y: d.pos.y, z: d.pos.z };
            kf.rot = { x: d.rot.x, y: d.rot.y, z: d.rot.z };
        }
    } else {
        kf.pos = { x: d.pos.x, y: d.pos.y, z: d.pos.z };
        kf.rot = { x: d.rot.x, y: d.rot.y, z: d.rot.z };
    }

    populateSidePanel(kf);
    syncKeyframesToLua();
    renderTimeline();
    showToast(t('toasts.camera_position_saved'));
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) {
        Tutorial.fire('tut:positionSaved');
    }
}

function onPositionCancelled() {
    State.isPositionMode = false;
    PlacementGuide.hide();
    document.getElementById('side-panel').classList.remove('dimmed');
    document.getElementById('sp-pos-btn').disabled = false;

    // Restore camera to keyframe's saved position
    if (State.selectedKfId !== null) {
        const kf = State.keyframes.find(k => k.id === State.selectedKfId);
        if (kf) post('previewKeyframe', { keyframe: kf });
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PLACEMENT GUIDE — Premiere Pro style viewfinder, controls bar, live data
// ═══════════════════════════════════════════════════════════════════════════════
const PlacementGuide = (function() {
    let _mode  = null;   // 'camera' | 'text' | 'scene'
    let _built = false;

    const MODE_CONFIG = {
        camera: {
            icon: 'fa-video',     get title() { return t('ui.pg_position_camera_title'); }, get label() { return t('ui.pg_camera_label'); },
            confirmKey: 'Backspace', get confirmLabel() { return t('ui.pg_save'); },
            showFov: true, showQE: true, showVert: true,
            get scrollLabel() { return t('ui.pg_fov'); },
            // Q/E in camera mode = roll the camera. Mouse already handles
            // yaw/pitch so this fills in the third axis (Dutch angles, etc).
            get qeLabel() { return t('ui.pg_roll'); },
        },
        text: {
            icon: 'fa-font',      get title() { return t('ui.pg_place_text_title'); },      get label() { return t('ui.pg_text_label'); },
            confirmKey: 'Enter',   get confirmLabel() { return t('ui.pg_confirm'); },
            showFov: false, showQE: true, showVert: true, showRF: true,
            get scrollLabel() { return t('ui.pg_distance'); },
            get qeLabel() { return t('ui.pg_rotate'); },
        },
        scene: {
            icon: 'fa-arrows-up-down-left-right', get title() { return t('ui.pg_place_entity_title'); }, get label() { return t('ui.pg_entity_label'); },
            confirmKey: 'Enter',   get confirmLabel() { return t('ui.pg_confirm'); },
            showFov: false, showQE: true, showVert: true,
            get scrollLabel() { return t('ui.pg_distance'); },
            get qeLabel() { return t('ui.pg_rotate'); },
        },
        // Picking a car to seat a ped in. Nothing is being MOVED, so there is
        // no scroll-distance and no Q/E rotate — the only inputs are flying and
        // looking, and the crosshair is the selection.
        seat: {
            icon: 'fa-car-side', get title() { return t('ui.pg_pick_vehicle_title'); }, get label() { return t('ui.pg_seat_label'); },
            confirmKey: 'Enter',   get confirmLabel() { return t('ui.pg_seat_confirm'); },
            showFov: false, showQE: false, showVert: true, showScroll: false,
            get scrollLabel() { return ''; },
        },
    };

    function buildRingTicks() {
        const g = document.getElementById('pg-ring-ticks');
        if (!g || g.childElementCount > 0) return;
        for (let deg = 0; deg < 360; deg += 5) {
            const isMajor = deg % 30 === 0;
            const r1 = isMajor ? 82 : 86;
            const r2 = 92;
            const rad = (deg - 90) * Math.PI / 180;
            const l = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            l.setAttribute('x1', 100 + r1 * Math.cos(rad));
            l.setAttribute('y1', 100 + r1 * Math.sin(rad));
            l.setAttribute('x2', 100 + r2 * Math.cos(rad));
            l.setAttribute('y2', 100 + r2 * Math.sin(rad));
            if (isMajor) l.classList.add('pg-tick-major');
            g.appendChild(l);
        }
        _built = true;
    }

    function updateFovArc(fov) {
        const path = document.getElementById('pg-fov-path');
        const label = document.getElementById('pg-fov-label');
        if (!path) return;
        // Map FOV (5–120) to arc half-angle (10°–80°)
        const halfAngle = 10 + ((fov - 5) / 115) * 70;
        const cx = 60, cy = 46, r = 38;
        const a1 = (270 - halfAngle) * Math.PI / 180;
        const a2 = (270 + halfAngle) * Math.PI / 180;
        const x1 = cx + r * Math.cos(a1);
        const y1 = cy + r * Math.sin(a1);
        const x2 = cx + r * Math.cos(a2);
        const y2 = cy + r * Math.sin(a2);
        const large = halfAngle > 90 ? 1 : 0;
        path.setAttribute('d', `M${x1},${y1} A${r},${r} 0 ${large} 1 ${x2},${y2}`);
        if (label) label.textContent = fov.toFixed(1);
    }

    function updateRing(yaw) {
        const needle = document.getElementById('pg-ring-needle');
        const degLabel = document.getElementById('pg-ring-deg');
        if (!needle) return;
        // Normalize yaw to 0-360
        let deg = ((yaw % 360) + 360) % 360;
        // No cx/cy here — the pivot comes from the CSS transform-origin. Passing
        // it twice composes both offsets and pivots the needle off-screen.
        needle.setAttribute('transform', `rotate(${deg})`);
        if (degLabel) degLabel.textContent = deg.toFixed(1) + '°';
    }

    function updatePitch(pitch) {
        const bar = document.getElementById('pg-pitch-bar');
        const label = document.getElementById('pg-pitch-label');
        if (!bar) return;
        // Pitch ranges -89 to 89, map to 0% (top) to 100% (bottom)
        const pct = 50 - (pitch / 89) * 50;
        bar.style.setProperty('--pg-pitch', pct + '%');
        if (label) label.textContent = pitch.toFixed(1) + '°';
    }

    return {
        show(mode) {
            _mode = mode;
            const cfg = MODE_CONFIG[mode];
            const el = document.getElementById('placement-guide');
            if (!el) return;

            // Build ticks on first show
            if (!_built) buildRingTicks();

            // Mode class
            el.className = 'mode-' + mode;

            // Configure controls
            document.querySelector('.pg-ctrl-icon i').className = 'fa-solid ' + cfg.icon;
            document.getElementById('pg-mode-title').textContent = cfg.title;
            document.getElementById('pg-mode-label').textContent = cfg.label;
            document.getElementById('pg-confirm-key').textContent = cfg.confirmKey;
            document.querySelector('#pg-ctrl-confirm span').textContent = cfg.confirmLabel;

            // Scroll label — some modes have nothing under the wheel at all.
            const showScroll = cfg.showScroll !== false;
            document.getElementById('pg-ctrl-scroll').classList.toggle('hidden', !showScroll);
            document.getElementById('pg-ctrl-sep-scroll').classList.toggle('hidden', !showScroll);
            if (showScroll) {
                document.querySelector('#pg-ctrl-scroll span').textContent = cfg.scrollLabel;
            }

            // Target chip: only the seat picker has something to name.
            const tgt = document.getElementById('pg-target');
            if (tgt) {
                tgt.classList.toggle('hidden', mode !== 'seat');
                if (mode === 'seat') setPickTarget(null);
            }

            // Show/hide Q/E, R/F (tilt, text mode only) and Vert controls
            document.getElementById('pg-ctrl-qe').classList.toggle('hidden', !cfg.showQE);
            document.getElementById('pg-ctrl-sep-qe').classList.toggle('hidden', !cfg.showQE);
            document.getElementById('pg-ctrl-rf').classList.toggle('hidden', !cfg.showRF);
            document.getElementById('pg-ctrl-sep-rf').classList.toggle('hidden', !cfg.showRF);
            document.getElementById('pg-ctrl-vert').classList.toggle('hidden', !cfg.showVert);
            document.getElementById('pg-ctrl-sep-vert').classList.toggle('hidden', !cfg.showVert);
            if (cfg.qeLabel) {
                document.querySelector('#pg-ctrl-qe span').textContent = cfg.qeLabel;
            }

            // FOV arc visibility
            document.getElementById('pg-fov-wrap').style.opacity = cfg.showFov ? '1' : '0.3';

            // Initial values from current state
            this.update(State.currentCamPos, State.currentCamRot, State.currentCamFov);

            el.classList.remove('hidden');
            document.getElementById('coords-hud').classList.add('hidden');
        },

        hide() {
            _mode = null;
            const el = document.getElementById('placement-guide');
            if (el) el.classList.add('hidden');
            document.getElementById('coords-hud').classList.remove('hidden');
        },

        update(pos, rot, fov) {
            if (!_mode) return;
            // Data bar
            const dx = document.getElementById('pg-dx');
            if (dx) {
                dx.textContent = pos.x.toFixed(2);
                document.getElementById('pg-dy').textContent = pos.y.toFixed(2);
                document.getElementById('pg-dz').textContent = pos.z.toFixed(2);
                document.getElementById('pg-dp').textContent = rot.x.toFixed(1);
                document.getElementById('pg-dr').textContent = rot.y.toFixed(1);
                document.getElementById('pg-dyaw').textContent = rot.z.toFixed(1);
                document.getElementById('pg-dfov').textContent = (fov || State.defaultFov).toFixed(1);
            }
            // Viewfinder elements
            updateRing(rot.z);
            updateFovArc(fov || State.defaultFov);
            updatePitch(rot.x);
        },

        isActive() { return _mode !== null; },
    };
})();

function onPlaybackStarted() {
    // A take starting is an answer to "am I still picking a car": no.
    endVehiclePick();
    State.isPlaying = true;
    document.getElementById('play-btn').innerHTML = '<i class="fa-solid fa-pause"></i>';
    document.getElementById('timeline-panel').classList.add('playback-active');
    document.getElementById('side-panel').classList.add('playback-active');
    document.getElementById('coords-hud').classList.add('hidden');
    // Panels slide away for playback → let the effects overlay fill the shot.
    document.getElementById('fx-overlay').classList.add('playback');
    hideRulerTooltip();
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) {
        document.getElementById('tut-root').classList.add('hidden');
    }
}

function onPlaybackStopped(d) {
    State.isPlaying = false;
    document.getElementById('play-btn').innerHTML = '<i class="fa-solid fa-play"></i>';
    document.getElementById('timeline-panel').classList.remove('playback-active');
    document.getElementById('side-panel').classList.remove('playback-active');
    document.getElementById('coords-hud').classList.remove('hidden');
    // Chrome is back → clip the effects overlay to the camera view again.
    document.getElementById('fx-overlay').classList.remove('playback');
    if (d && d.frame !== undefined) {
        State.currentFrame = d.frame;
        updatePlayheadPosition();
        updateTimecodeDisplay();
        document.getElementById('frame-input').value = d.frame;
    }
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) {
        document.getElementById('tut-root').classList.remove('hidden');
        Tutorial.fire('tut:playbackFinished');
    }
    // Auto-finalize the export when playback finishes (whether naturally or
    // via the timeline reaching its end). The user shouldn't have to click
    // Stop themselves — that'd make 99% of exports a two-step process.
    if (State.exportActive) finalizeExport();
}

// ── DROPDOWNS ─────────────────────────────────────────────────────────────────
function populateShakeDropdown() {
    const el = document.getElementById('sp-shake-type');
    el.innerHTML = '<option value="none">None</option>';
    State.shakeTypes.forEach(s => {
        const o = document.createElement('option');
        o.value = s.id; o.textContent = s.label;
        el.appendChild(o);
    });
}

function populateFilterDropdown() {
    const el = document.getElementById('sp-filter-id');
    el.innerHTML = '<option value="none">None</option>';
    State.colorFilters.forEach(f => {
        const o = document.createElement('option');
        o.value = f.id; o.textContent = f.label;
        el.appendChild(o);
    });
}

function populateFontDropdown() {
    const el = document.getElementById('tv-font');
    el.innerHTML = '';
    State.fonts.forEach(f => {
        const o = document.createElement('option');
        o.value         = f.family;
        o.textContent   = f.label;
        o.style.fontFamily = f.family;
        el.appendChild(o);
    });
    const syncSelectFont = () => {
        const opt = el.options[el.selectedIndex];
        el.style.fontFamily = opt ? opt.style.fontFamily : '';
    };
    syncSelectFont();
    el.addEventListener('change', syncSelectFont);
}

function injectFontLinks(fonts) {
    fonts.forEach(f => {
        if (!f.url) return;
        if (document.querySelector(`link[data-font="${f.family}"]`)) return;
        const link = document.createElement('link');
        link.rel              = 'stylesheet';
        link.href             = f.url;
        link.dataset.font     = f.family;
        document.head.appendChild(link);
    });
}

// ── KEYFRAME MANAGEMENT ───────────────────────────────────────────────────────
function makeKeyframe(frame, pos, rot, fov, kind) {
    return {
        id:     State.nextId++,
        frame:  frame,
        // Every kind lives on the same camera timeline. `kind` only changes what
        // the keyframe means and what colour it draws — 'camera' is a plain
        // shot, 'resume' carries a pose imported from another project.
        // Older projects have no kind field; they read as 'camera'.
        kind:   kind || 'camera',
        pos:    pos || { x: 0, y: 0, z: 0 },
        rot:    rot || { x: 0, y: 0, z: 0 },
        fov:    fov || State.defaultFov,
        easing: State.defaultEasing || 'ease',
        cut:    false,   // "cut to here" — hard-cut into this keyframe
        time:   { enabled: false, value: 12.0 },
        effects: {
            shake:      { type: 'none', amplitude: 0 },
            dof:        { enabled: false, near: 3.0, far: 50, fNumber: 1.2, strength: 1 },
            motionBlur: 0,
            filter:     { id: 'none', strength: 1 },
        },
    };
}

function sortKeyframes() {
    State.keyframes.sort((a, b) => a.frame - b.frame);
}

// Marker keyframes are timeline EVENTS (scene battle control, external
// triggers), not camera poses. They live in State.keyframes so selection,
// dragging, undo and project save/load all work unchanged, but everything
// that builds the camera path must look through cameraKfs() instead —
// Lua does the same split on its side of setKeyframes.
const MARKER_KINDS = { scene: true, external: true };
function isMarkerKf(kf) { return !!(kf && MARKER_KINDS[kf.kind]); }
function cameraKfs()    { return State.keyframes.filter(k => !MARKER_KINDS[k.kind]); }

function markerTitle(kf) {
    if (kf.kind === 'scene') {
        return kf.sceneAction === 'battle_start'
            ? tOr('html.labels.kf_battle_start', 'Start battle')
            : tOr('html.labels.kf_battle_stop',  'Stop battle');
    }
    const entry = (State.externalKeyframes || []).find(e => e.id === kf.externalId);
    return (entry && entry.label) || kf.externalLabel || kf.externalId || 'External';
}

function markerDescription(kf) {
    if (kf.kind === 'scene') {
        return kf.sceneAction === 'battle_start'
            ? tOr('ui.marker_battle_start_desc', 'When playback reaches this frame, every Scene Editor ped goes into combat. Playback always starts with the battle frozen.')
            : tOr('ui.marker_battle_stop_desc',  'When playback reaches this frame, the battle freezes and scene peds snap back to their placed poses.');
    }
    const entry = (State.externalKeyframes || []).find(e => e.id === kf.externalId);
    if (!entry) {
        return tOr('ui.marker_external_missing', 'This trigger is no longer in the config — it does nothing until "{id}" is added back.')
            .replace('{id}', kf.externalId || '?');
    }
    const fires = [];
    if (entry.clientEvent) fires.push(entry.clientEvent + ' (client)');
    if (entry.serverEvent) fires.push(entry.serverEvent + ' (server)');
    if (entry.export && entry.export.resource) fires.push(entry.export.resource + ':' + entry.export.func + ' (export)');
    if (entry.serverExport && entry.serverExport.resource) fires.push(entry.serverExport.resource + ':' + entry.serverExport.func + ' (server export)');
    return tOr('ui.marker_external_desc', 'Fires when playback reaches this frame: {fires}')
        .replace('{fires}', fires.join(', ') || '—');
}

// Legacy cuts lived on the OUTGOING keyframe (easing === 'cut' meant "hold me,
// then snap to the next keyframe"). The new model marks the keyframe you cut TO
// (kf.cut === "jump to here"). Convert old projects on load so the UI exposes a
// single intuitive toggle. Visually identical: the previous pose holds until the
// cut keyframe's frame, then snaps — either representation produces that.
function migrateKeyframeCuts(kfs) {
    if (!Array.isArray(kfs)) return kfs;
    const ordered = kfs.slice().sort((a, b) => a.frame - b.frame);
    for (let i = 0; i < ordered.length; i++) {
        if (ordered[i].easing === 'cut') {
            ordered[i].easing = 'linear';        // held pose — outgoing curve is irrelevant
            if (ordered[i + 1]) ordered[i + 1].cut = true;   // cut now lands on the next keyframe
        }
    }
    return kfs;
}

function syncKeyframesToLua() {
    post('setKeyframes', {
        keyframes:   State.keyframes,
        totalFrames: totalFrames(),
    });
}

function totalFrames() {
    return State.durationSec * State.fps;
}

// ── CC PUBLIC API ─────────────────────────────────────────────────────────────
const CC = window.CC = {};

CC.openWorldSettings = function() {
    hideAllViews();
    document.getElementById('sp-world-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('ui.title_world_scenery');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');
};

CC.openInterpSettings = function() {
    hideAllViews();
    document.getElementById('sp-interp-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('ui.title_interpolation');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');
    // Sync controls to current state
    document.getElementById('is-mode').value        = State.interpSettings.mode;
    document.getElementById('is-tension').value     = State.interpSettings.tension;
    document.getElementById('is-tension-num').value = State.interpSettings.tension.toFixed(2);
    document.getElementById('is-spring').value      = State.interpSettings.spring;
    document.getElementById('is-spring-num').value  = State.interpSettings.spring.toFixed(2);
    CC._updateInterpHint(State.interpSettings.mode);
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) Tutorial.fire('tut:interpOpened');
};

CC._updateInterpHint = function(mode) {
    const hints = {
        native: t('ui.interp_hint_native'),
        eased:  t('ui.interp_hint_eased'),
        spline: t('ui.interp_hint_spline'),
    };
    document.getElementById('is-mode-hint').textContent = hints[mode] || hints.native;
    const splineOnly = mode === 'spline';
    for (const id of ['is-tension-section', 'is-spring-section']) {
        const el = document.getElementById(id);
        el.style.opacity       = splineOnly ? '1'    : '0.35';
        el.style.pointerEvents = splineOnly ? 'auto' : 'none';
    }
};

CC.applyInterpSettings = function() {
    const mode    = document.getElementById('is-mode').value;
    const tension = parseFloat(document.getElementById('is-tension').value) || 0;
    const spring  = parseFloat(document.getElementById('is-spring').value)  || 0;
    const prevMode = State.interpSettings.mode;
    State.interpSettings.mode    = mode;
    State.interpSettings.tension = tension;
    State.interpSettings.spring  = spring;
    CC._updateInterpHint(mode);
    post('setInterpSettings', State.interpSettings);
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive() && mode !== prevMode) Tutorial.fire('tut:interpChanged');
};

// ── Playback tuning (debug knobs) ────────────────────────────────────────────
const PLAYBACK_TUNING_KEYS = [
    'pedLookahead', 'pedTaskSpeedCeiling', 'pedStoppingDistance', 'pedMovingThreshold',
    'pedEnterCarLookahead', 'pedExitCarGrace', 'pedJumpTriggerDist',
    'vehicleCorrectionStrength',
    'warmupSec',
];
let _ptDefaults = null;

function populatePlaybackTuning(values) {
    if (!values) return;
    for (const k of PLAYBACK_TUNING_KEYS) {
        const el = document.getElementById('pt-' + k);
        if (el && values[k] !== undefined) el.value = values[k];
    }
}

CC.openPlaybackTuning = async function() {
    hideAllViews();
    document.getElementById('sp-playback-tuning-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('html.panels.playback_tuning_title');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');
    // Pull current + defaults from Lua so the inputs reflect live values.
    const d = await postAwait('getPlaybackTuning', {});
    if (d && d.current)  populatePlaybackTuning(d.current);
    if (d && d.defaults) _ptDefaults = d.defaults;
};

// ── EXPORT (talks to core-cinematics-recorder over plain-HTTP localhost) ────
//
// We call the recorder directly with fetch() — localhost is "potentially
// trustworthy" per the W3C Mixed Content spec, so HTTP-from-HTTPS-context
// fetches to 127.0.0.1 are allowed. Lua's PerformHttpRequest is server-only
// in FiveM, so we couldn't relay through it even if we wanted to.
State.exportActive     = false;  // capturing
State.exportProcessing = false;  // /stop in flight (post-blur ffmpeg pass)
State.exportStartMs    = 0;
// Set from the moment the scene is staged for an export until the capture is
// wrapped up. The recorder is already rolling during the pre-roll, before
// playback (and therefore State.isPlaying) has started — the effects overlay
// reads this so that staged frame is rendered exactly as it will be exported.
State.exportStaging    = false;
let _exportElapsedTimer = null;

/// Wrapper around fetch() that:
///   - prefixes the recorder base URL
///   - JSON-encodes the request body
///   - JSON-decodes the response
///   - returns `{ ok: false, error }` on network failure (recorder offline,
///     blocked by mixed content, etc.) so callers can branch on `r.ok`.
async function exporterFetch(path, init) {
    const base = State.exporterUrl || 'http://127.0.0.1:7861';
    init = init || {};
    if (init.body && typeof init.body !== 'string') {
        init.body = JSON.stringify(init.body);
        init.headers = Object.assign({ 'Content-Type': 'application/json' }, init.headers || {});
    }
    try {
        const res = await fetch(base + path, init);
        if (!res.ok) return { ok: false, error: `HTTP ${res.status}` };
        // 204 / empty body is OK; JSON-parse only when body is present.
        const text = await res.text();
        if (!text) return { ok: true };
        return JSON.parse(text);
    } catch (e) {
        return { ok: false, error: e && e.message ? String(e.message) : 'fetch failed' };
    }
}

CC.openExport = async function() {
    hideAllViews();
    document.getElementById('sp-export-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('html.panels.export_title');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');

    // Restore the in-flight UI shape if the user navigated away while a
    // capture was running.
    refreshExportUi();

    pingExporter();
    // Pull recorder's persisted config so the Folder input reflects what's
    // actually on disk. Fire-and-forget — recorder offline path is already
    // handled by pingExporter setting the banner.
    loadExporterConfig();
};

// Forward 1Hz in-game fps samples from Lua (GetFrameTime native) to the
// recorder so its capture pipeline can sync to whatever the game's
// actually rendering at. Fire-and-forget; we don't await or surface
// errors because losing a single heartbeat is fine.
//
// Gate on an active/finishing export: the recorder .exe only runs while the
// user is capturing, so outside that window every POST to 127.0.0.1:7861
// fails — and while exporterFetch's catch swallows the rejection for *us*,
// CEF still logs each failed request as a red `net::ERR_CONNECTION_REFUSED`
// in the F12 console (a network-layer log JS can't suppress). Unthrottled
// that's one red line per second forever, even with the editor closed.
// Only heartbeating while exportActive/exportProcessing keeps the recorder
// synced during capture and stays completely silent the rest of the time.
function onGameFps(fps) {
    if (typeof fps !== 'number' || !isFinite(fps) || fps <= 0) return;
    if (!State.exportActive && !State.exportProcessing) return;
    exporterFetch('/game_fps', {
        method: 'POST',
        body:   { fps },
    });
}

async function pingExporter() {
    const r = await exporterFetch('/ping');
    const ok    = !!(r && r.ok);
    const verEl = document.getElementById('export-recorder-version');

    document.getElementById('export-status-banner').classList.toggle('hidden', ok);
    document.getElementById('export-status-ok')   .classList.toggle('hidden', !ok);
    document.getElementById('export-start-btn').disabled = !ok || State.exportActive;
    if (verEl) verEl.textContent = ok && r.version ? `v${r.version}` : '';
}

async function loadExporterConfig() {
    const r = await exporterFetch('/config');
    if (!r || !r.ok || !r.config) return;
    const folder = document.getElementById('export-folder');
    if (folder && typeof r.config.output_dir === 'string') {
        folder.value = r.config.output_dir;
    }
}

// Persist the Folder input back to the recorder's config.json. Wired to
// `onchange` (not `oninput`) so we save once the user commits the new
// path instead of after every keystroke.
CC.saveExportFolder = async function() {
    const v = document.getElementById('export-folder').value.trim();
    if (!v) return;
    const r = await exporterFetch('/config', { method: 'POST', body: { output_dir: v } });
    if (r && r.ok) {
        showToast(t('toasts.export_folder_saved') || 'Output folder saved');
    } else if (r && r.error) {
        showToast(r.error, 'error');
    }
};

CC.startExport = async function() {
    if (State.exportActive) return;
    if (!State.currentProject) {
        showToast(t('errors.no_project_open') || 'Open a project first', 'error');
        return;
    }
    if (cameraKfs().length < 2) {
        showToast(t('errors.need_two_keyframes') || 'Need at least 2 keyframes', 'error');
        return;
    }

    const upscaleEl = document.getElementById('export-upscale');
    const params = {
        target_fps:  parseInt(document.getElementById('export-fps').value, 10) || 60,
        motion_blur: document.getElementById('export-blur').value || 'off',
        output_name: (document.getElementById('export-name').value || '').trim() || null,
        // Opt-in 4K upscale (recorder post-pass lanczos to its res cap).
        // The toggle is hidden on native-4K screens, so this stays false there.
        upscale:     !!(upscaleEl && upscaleEl.checked),
    };

    // Export sequencing (avoids capturing the UI fade-out and the recorded
    // vehicles "flying" to their start positions at slowed timeScale):
    //
    //   1. Tell Lua to *prepare* the scene — hides UI/HUD and snaps every
    //      recorded entity + the camera to the start frame via jumpToFrame.
    //      No timeScale change yet; isPlaying stays false. The user's screen
    //      shows the static frame-0 state of the cinematic.
    //   2. Tell the recorder to start capturing — it now sees a clean,
    //      already-staged scene from its very first frame.
    //   3. Hold for ~1s so ffmpeg's spawn / encoder-init lag spike is
    //      absorbed by static pre-roll instead of stuttering through the
    //      first keyframe.
    //   4. Tell Lua to actually start playback — that's where timeScale
    //      drops into slow-mo and the per-tick replay starts animating.
    //
    // Failures at step 1 or 2 abort cleanly without leaving the UI hidden
    // on the user's screen.
    // From here the staged frame is export output, not editor preview — the
    // effects overlay renders it at full strength and full screen.
    State.exportStaging = true;
    post('prepareExport', { fromFrame: 0 });
    // One animation frame so the engine renders the staged scene before
    // we start the recorder. Without this, ffmpeg's first frame can land
    // on the half-painted snap-into-position transition.
    await new Promise(r => requestAnimationFrame(r));

    const r = await exporterFetch('/start', { method: 'POST', body: params });
    if (!r || !r.ok) {
        // Restore the UI immediately so the user isn't stuck on a hidden
        // HUD if /start fails. stopPlayback isn't needed (we never
        // started playing) but it does the un-hide work cleanly.
        State.exportStaging = false;
        post('stopPlayback', {});
        showToast((r && r.error) || t('toasts.export_start_failed') || 'Export failed to start', 'error');
        return;
    }

    State.exportActive  = true;
    State.exportStartMs = Date.now();
    refreshExportUi();

    // 1s static pre-roll. Game still at normal speed, scene already framed
    // at start-of-cinematic — recorder warms up on a stable frame.
    await new Promise(r => setTimeout(r, 1000));
    if (!State.exportActive) return;  // user hit Stop during the warmup
    // Time-warp ("EVE / Rockstar prolonged export"): slow the game so peds
    // and AI actually animate sub-frame instead of teleporting between
    // captured frames. Tied to motion_blur intensity — heavier blur means
    // more sub-frames to mix, so we drag the clock proportionally.
    const factorMap = { off: 1, light: 2, medium: 4, heavy: 8 };
    const blurFactor = factorMap[params.motion_blur] || 1;
    const exportTimeScale = blurFactor > 1 ? 1.0 / blurFactor : 1.0;
    // isExport tells Lua this pass must stay deterministic — no frame-count
    // changing behaviour (e.g. a wipe holding longer while the world streams).
    post('startPlayback', { fromFrame: 0, totalFrames: totalFrames(), exportTimeScale, isExport: true });
};

CC.stopExport = async function() {
    if (!State.exportActive) return;
    await runExportFinalize();
};

/// Called by onPlaybackStopped when playback ends naturally during an
/// export. Same code path as a user-initiated stop.
async function finalizeExport() {
    if (!State.exportActive) return;
    await runExportFinalize();
}

async function runExportFinalize() {
    State.exportActive     = false;
    State.exportStaging    = false;
    State.exportProcessing = true;  // post-blur ffmpeg pass can take a while
    refreshExportUi();
    // Stop playback (no-op if it already finished naturally) and tell the
    // recorder to wrap up. Recorder owns the timing on the post-blur pass.
    if (State.isPlaying) post('stopPlayback', {});
    const r = await exporterFetch('/stop', { method: 'POST' });
    State.exportProcessing = false;
    refreshExportUi();
    handleExportFinishResponse(r);
}

function handleExportFinishResponse(r) {
    if (r && r.ok && r.output_path) {
        showToast((t('toasts.export_complete') || 'Exported: ') + r.output_path);
    } else if (r && r.error) {
        showToast(r.error, 'error');
    }
}

function refreshExportUi() {
    const startBtn = document.getElementById('export-start-btn');
    const stopBtn  = document.getElementById('export-stop-btn');
    const progress = document.getElementById('export-progress');
    if (!startBtn) return;

    const busy = State.exportActive || State.exportProcessing;

    startBtn.classList.toggle('hidden', busy);
    stopBtn .classList.toggle('hidden', !State.exportActive);
    progress.classList.toggle('hidden', !busy);

    // Swap the progress label so the user knows the difference between
    // "still capturing in real time" and "post-process finishing up".
    const elapsedEl = document.getElementById('export-elapsed');
    if (State.exportProcessing && !State.exportActive) {
        if (elapsedEl) elapsedEl.textContent = t('html.labels.export_processing') || 'Processing motion blur…';
    } else if (elapsedEl && State.exportActive) {
        // Live timer takes over from updateExportElapsed.
    }

    if (State.exportActive) {
        if (_exportElapsedTimer) clearInterval(_exportElapsedTimer);
        _exportElapsedTimer = setInterval(updateExportElapsed, 250);
        updateExportElapsed();
    } else if (_exportElapsedTimer) {
        clearInterval(_exportElapsedTimer);
        _exportElapsedTimer = null;
    }
}

function updateExportElapsed() {
    const el = document.getElementById('export-elapsed');
    if (!el) return;
    const sec = Math.floor((Date.now() - State.exportStartMs) / 1000);
    const mm  = Math.floor(sec / 60);
    const ss  = sec % 60;
    el.textContent = `${String(mm).padStart(2,'0')}:${String(ss).padStart(2,'0')}`;
}

// Debounce so mid-keystroke partial values (typing "0.3" briefly produces
// "0", "0.", then "0.3") don't get applied before the user finishes typing.
let _ptApplyTimer = null;
CC.applyPlaybackTuning = function() {
    if (_ptApplyTimer) clearTimeout(_ptApplyTimer);
    _ptApplyTimer = setTimeout(() => {
        _ptApplyTimer = null;
        const out = {};
        for (const k of PLAYBACK_TUNING_KEYS) {
            const el = document.getElementById('pt-' + k);
            if (!el) continue;
            let v = parseFloat(el.value);
            if (isNaN(v)) continue;
            // Clamp to the input's declared bounds so a value above max
            // doesn't silently get dropped (which would leave the Lua side
            // pinned at whatever was last successfully posted, surprising
            // the user when their new edit appears to do nothing).
            const min = parseFloat(el.min);
            const max = parseFloat(el.max);
            if (!isNaN(min) && v < min) v = min;
            if (!isNaN(max) && v > max) v = max;
            out[k] = v;
        }
        post('setPlaybackTuning', out);
    }, 250);
};

CC.resetPlaybackTuning = function() {
    if (!_ptDefaults) return;
    populatePlaybackTuning(_ptDefaults);
    CC.applyPlaybackTuning();
};

CC.openRecordingSettings = function() {
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) Tutorial.fire('tut:openedRecordings');
    hideAllViews();
    document.getElementById('sp-record-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('ui.title_recording');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');
    // Pull a fresh integration status before showing the warning, so a player
    // who installed the fork mid-session sees the warning disappear without
    // needing to reopen the editor.
    post('refreshRpemotesStatus');
    updateRpemotesWarning();
};

CC.startVehicleRecord = async function() {
    // Recordings are stored against a project slug. Without an active project
    // the captured frames have nowhere to go and would silently overwrite the
    // last project's recording when the user later opens it.
    if (!State.currentProject) {
        showToast(t('errors.no_project_for_recording') || 'Open or create a project first', 'error');
        return;
    }
    const vehicles = document.getElementById('rec-vehicles').checked;
    const peds     = document.getElementById('rec-peds').checked;
    if (!vehicles && !peds) {
        showToast(t('errors.select_recording_target'), 'error');
        return;
    }
    // Starting a fresh capture wipes vehicleRecordings/pedRecordings on the Lua
    // side, so warn before clobbering an existing take. Skip the warning during
    // the tutorial (its scripted flow has nothing to lose) and when there are no
    // recorded frames yet.
    const hasRecording = !!(State.vehicleRecording && State.vehicleRecording.totalFrames > 0);
    if (hasRecording && !(typeof Tutorial !== 'undefined' && Tutorial.isActive())) {
        if (!await nuiConfirm(
                t('ui.confirm_overwrite_recording_title'),
                t('ui.confirm_overwrite_recording_message'))) {
            return;
        }
    }
    const tutActive = typeof Tutorial !== 'undefined' && Tutorial.isActive();
    if (tutActive) {
        // Block until Adder is spawned + player is warped in, THEN start the real record.
        await postAwait('tutorialSpawnAdder');
        post('startVehicleRecord', { vehicles, peds });
        Tutorial.fire('tut:recordingStarted');
        return;
    }
    post('startVehicleRecord', { vehicles, peds });
};

CC.setVehicleMotionBlur = function(enabled) {
    post('setVehicleMotionBlur', { enabled: !!enabled });
};

CC.backToMenu = function() {
    // If viewing scene entity props, go back to scene list (not main menu)
    if (!document.getElementById('sp-scene-props-view').classList.contains('hidden')) {
        CC.backFromSceneProps();
        return;
    }
    hideAllViews();
    document.getElementById('sp-menu-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('ui.title_no_keyframe_selected');
    State.editingClipId = null;
    State.selectedSceneId = null;
    deselectClip();
    post('unfocusEntity');
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) Tutorial.fire('tut:backToMenu');
};

CC.open3DTextPanel = function() {
    State.editingClipId = null;
    hideAllViews();
    document.getElementById('sp-text-view').classList.remove('hidden');
    // Show the kind chooser first; the form opens once Text/Image is picked.
    document.getElementById('tv-chooser').classList.remove('hidden');
    document.getElementById('tv-fields').classList.add('hidden');
    document.getElementById('tv-create-mode').classList.add('hidden');
    document.getElementById('tv-edit-mode').classList.add('hidden');
    document.getElementById('tv-lock-section').classList.add('hidden');
    document.getElementById('sp-title').textContent = t('text3d.title');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');
};

// Picks the kind of 3D object to create (text | image) and opens the matching
// form in create mode. Video is reserved for a future release.
CC.chooseTextKind = function(kind) {
    State.editingKind   = (kind === 'image') ? 'image' : 'text';
    State.editingClipId = null;
    resetTextForm();
    applyPanelKind(State.editingKind);
    document.getElementById('tv-chooser').classList.add('hidden');
    document.getElementById('tv-fields').classList.remove('hidden');
    document.getElementById('tv-create-mode').classList.remove('hidden');
    document.getElementById('tv-edit-mode').classList.add('hidden');
    document.getElementById('tv-lock-section').classList.add('hidden');
    document.getElementById('sp-title').textContent = (State.editingKind === 'image') ? '3D Image' : '3D Text';
};

// Shows/hides controls that don't apply to the current kind, swaps a couple of
// effect section titles so they read sensibly for images, and keeps the anim
// dropdown selection valid for the kind.
function applyPanelKind(kind) {
    State.editingKind = kind;
    const isImage = (kind === 'image');
    document.querySelectorAll('.tv-only-text').forEach(el => el.classList.toggle('kind-hidden', isImage));
    document.querySelectorAll('.tv-only-image').forEach(el => el.classList.toggle('kind-hidden', !isImage));

    const sel = document.getElementById('tv-anim');
    if (sel) {
        let curHidden = false;
        Array.from(sel.options).forEach(opt => {
            let hide = false;
            if (opt.classList.contains('anim-text-only'))  hide = isImage;
            if (opt.classList.contains('anim-image-only')) hide = !isImage;
            opt.hidden = hide; opt.disabled = hide;
            if (hide && opt.selected) curHidden = true;
        });
        if (curHidden) sel.value = 'fadeSlide';
    }

    // Image reuses the colorShift/gradient data fields but they read as a hue
    // cycle / tint overlay there, so relabel the section titles.
    const csT = document.getElementById('tv-colorshift-title');
    if (csT) csT.textContent = isImage ? 'HUE SHIFT' : t('html.panels.color_shift');
    const grT = document.getElementById('tv-gradient-title');
    if (grT) grT.textContent = isImage ? 'GRADIENT TINT' : t('html.panels.gradient_fill');
}

// Resets the create/edit form to defaults so a previous edit's values don't leak.
function resetTextForm() {
    document.getElementById('tv-text').value    = '';
    document.getElementById('tv-image-url').value = '';
    State.imageAspect = 1.0;
    { const _st = document.getElementById('tv-image-status'); if (_st) _st.textContent = IMAGE_HINT_DEFAULT; }
    document.getElementById('tv-font').value    = 'Arial';
    document.getElementById('tv-color').value   = '#ffffff';
    document.getElementById('tv-size').value     = 4;
    document.getElementById('tv-anim').value     = 'fadeSlide';
    document.getElementById('tv-anim-in').value  = 15;
    document.getElementById('tv-anim-out').value = 15;
    State.shadowEnabled = false;
    const sBtn = document.getElementById('tv-shadow-btn');
    sBtn.textContent = t('ui.off'); sBtn.classList.remove('active');
    State.glowEnabled = false;
    const gBtn = document.getElementById('tv-glow-btn');
    gBtn.textContent = t('ui.off'); gBtn.classList.remove('active');
    State.outlineEnabled = false;
    const oBtn = document.getElementById('tv-outline-btn');
    if (oBtn) { oBtn.textContent = t('ui.off'); oBtn.classList.remove('active'); }
    const ocl = document.getElementById('tv-outline-color');  if (ocl) ocl.value = '#000000';
    const owd = document.getElementById('tv-outline-width');  if (owd) owd.value = 2;
    State.colorShiftEnabled = false;
    const cBtn = document.getElementById('tv-chroma-btn');
    if (cBtn) { cBtn.textContent = t('ui.off'); cBtn.classList.remove('active'); }
    State.colorShiftAdvanced = false;
    const cAdv = document.getElementById('tv-chroma-adv-btn');
    if (cAdv) { cAdv.textContent = t('ui.off'); cAdv.classList.remove('active'); }
    const advRow = document.getElementById('tv-chroma-adv-row');
    if (advRow) advRow.classList.add('hidden');
    const colIn = document.getElementById('tv-chroma-colors');
    if (colIn) colIn.value = '';
    State.gradientEnabled = false;
    const grBtn = document.getElementById('tv-gradient-btn');
    if (grBtn) { grBtn.textContent = t('ui.off'); grBtn.classList.remove('active'); }
    const grFrom = document.getElementById('tv-gradient-from'); if (grFrom) grFrom.value = '#ffd966';
    const grTo   = document.getElementById('tv-gradient-to');   if (grTo)   grTo.value   = '#c08a1f';
    State.pulseEnabled = false;
    const pBtn = document.getElementById('tv-pulse-btn');
    if (pBtn) { pBtn.textContent = t('ui.off'); pBtn.classList.remove('active'); }
    const pSpd = document.getElementById('tv-pulse-speed'); if (pSpd) pSpd.value = 60;
};

CC.toggleShadow = function() {
    State.shadowEnabled = !State.shadowEnabled;
    const btn = document.getElementById('tv-shadow-btn');
    btn.textContent = State.shadowEnabled ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', State.shadowEnabled);
};

CC.toggleGlow = function() {
    State.glowEnabled = !State.glowEnabled;
    const btn = document.getElementById('tv-glow-btn');
    btn.textContent = State.glowEnabled ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', State.glowEnabled);
};

CC.toggleOutline = function() {
    State.outlineEnabled = !State.outlineEnabled;
    const btn = document.getElementById('tv-outline-btn');
    btn.textContent = State.outlineEnabled ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', State.outlineEnabled);
};

CC.toggleColorShift = function() {
    State.colorShiftEnabled = !State.colorShiftEnabled;
    const btn = document.getElementById('tv-chroma-btn');
    btn.textContent = State.colorShiftEnabled ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', State.colorShiftEnabled);
};

CC.toggleColorShiftAdvanced = function() {
    State.colorShiftAdvanced = !State.colorShiftAdvanced;
    const btn = document.getElementById('tv-chroma-adv-btn');
    btn.textContent = State.colorShiftAdvanced ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', State.colorShiftAdvanced);
    document.getElementById('tv-chroma-adv-row').classList.toggle('hidden', !State.colorShiftAdvanced);
};

CC.toggleGradient = function() {
    State.gradientEnabled = !State.gradientEnabled;
    const btn = document.getElementById('tv-gradient-btn');
    btn.textContent = State.gradientEnabled ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', State.gradientEnabled);
};

CC.togglePulse = function() {
    State.pulseEnabled = !State.pulseEnabled;
    const btn = document.getElementById('tv-pulse-btn');
    btn.textContent = State.pulseEnabled ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', State.pulseEnabled);
};

// ── 3D IMAGE HELPERS ──────────────────────────────────────────────────────────
// Auto-detect an image's natural size so the world billboard is never stretched
// — the user only picks an overall scale. The browser caches the load, so
// calling this again at place-time is cheap.
function detectImageAspect(url, cb) {
    if (!url) { cb(1.0, 0, 0); return; }
    const im = new Image();
    im.onload  = () => {
        const a = (im.naturalWidth > 0 && im.naturalHeight > 0)
            ? im.naturalWidth / im.naturalHeight : 1.0;
        cb(a, im.naturalWidth, im.naturalHeight);
    };
    im.onerror = () => cb(null, 0, 0);
    im.src = url;
}

const IMAGE_HINT_DEFAULT = 'Paste a direct image link — size auto-detected. Use the Size field below to scale.';

CC.onImageUrlInput = function() {
    const url    = document.getElementById('tv-image-url').value.trim();
    const status = document.getElementById('tv-image-status');
    if (!url) {
        State.imageAspect = 1.0;
        if (status) status.textContent = IMAGE_HINT_DEFAULT;
        return;
    }
    if (status) status.textContent = 'Loading image…';
    detectImageAspect(url, (a, w, h) => {
        // Ignore stale callbacks if the field changed while this was loading.
        if (document.getElementById('tv-image-url').value.trim() !== url) return;
        if (a === null) {
            State.imageAspect = 1.0;
            if (status) status.textContent = '⚠ Could not load that image URL.';
            return;
        }
        State.imageAspect = a;
        if (status) status.textContent = `Detected ${w}×${h} (aspect ${a.toFixed(2)}). Use the Size field to scale.`;
    });
};

CC.startTextPlacement = async function() {
    const isImage  = (State.editingKind === 'image');
    const text     = document.getElementById('tv-text').value.trim();
    const imageUrl = isImage ? document.getElementById('tv-image-url').value.trim() : '';
    if (isImage && !imageUrl) { showToast(t('toasts.image_url_required'), 'error'); return; }
    if (!isImage && !text)    { showToast(t('errors.enter_text_content'), 'error'); return; }
    const fontName  = document.getElementById('tv-font').value;
    const fontEntry = State.fonts.find(f => f.family === fontName);
    const config = {
        text:    text,
        imageUrl: imageUrl,
        aspect:   State.imageAspect || 1.0,
        font:    fontName,
        fontUrl: fontEntry ? (fontEntry.url || '') : '',
        color:   document.getElementById('tv-color').value,
        size:    parseFloat(document.getElementById('tv-size').value) || 4.0,
        shadow:  State.shadowEnabled,
        glow:    State.glowEnabled,
        outline:          State.outlineEnabled,
        outlineColor:     document.getElementById('tv-outline-color').value || '#000000',
        outlineWidth:     parseInt(document.getElementById('tv-outline-width').value) || 2,
        colorShift:       State.colorShiftEnabled,
        colorShiftColors: State.colorShiftAdvanced ? (document.getElementById('tv-chroma-colors').value || '') : '',
        colorShiftSpeed:  parseInt(document.getElementById('tv-chroma-speed').value) || 60,
        gradient:         State.gradientEnabled,
        gradientFrom:     document.getElementById('tv-gradient-from').value || '#ffd966',
        gradientTo:       document.getElementById('tv-gradient-to').value   || '#c08a1f',
        pulse:            State.pulseEnabled,
        pulseSpeed:       parseInt(document.getElementById('tv-pulse-speed').value) || 60,
        camPos:  { x: State.currentCamPos.x, y: State.currentCamPos.y, z: State.currentCamPos.z },
        camRot:  { x: State.currentCamRot.x, y: State.currentCamRot.y, z: State.currentCamRot.z },
    };

    // When re-placing an existing text, start the camera near the text's current
    // position. For locked text, coords are an offset — resolve the live world
    // pose via Lua so the freecam opens where the text actually appears.
    if (State.editingClipId !== null) {
        const clip = State.textClips.find(c => c.id === State.editingClipId);
        const obj  = clip ? State.textObjects.find(o => o.id === clip.textId) : null;
        if (obj && obj.coords) {
            let wc = obj.coords;
            if (obj.lockedEntity) {
                const r = await postAwait('getTextWorldAt', {
                    frame: State.currentFrame, coords: obj.coords,
                    lockedEntity: obj.lockedEntity, lockYaw: obj.lockYaw || 0,
                    orientWithEntity: obj.orientWithEntity !== false,
                });
                if (r && r.coords) wc = r.coords;
            }
            config.existingCoords = {
                x: wc.x, y: wc.y, z: wc.z,
                heading: wc.heading || 0,
                rx: wc.rx || 0,   // preserve pitch when re-placing
            };
        }
    }

    if (imageUrl) {
        // Re-detect at place-time so the aspect is correct even if Place was
        // clicked before the input's load finished (browser serves it cached).
        detectImageAspect(imageUrl, (a) => {
            config.aspect = a || State.imageAspect || 1.0;
            State.imageAspect = config.aspect;
            post('startTextPlacement', config);
        });
    } else {
        post('startTextPlacement', config);
    }
};

CC.saveClipEdit = function() {
    if (State.editingClipId === null) return;
    const clip = State.textClips.find(c => c.id === State.editingClipId);
    if (!clip) return;
    const obj = State.textObjects.find(o => o.id === clip.textId);
    if (!obj) return;
    obj.kind      = State.editingKind;
    const _isImg  = (State.editingKind === 'image');
    obj.text      = document.getElementById('tv-text').value.trim() || obj.text;
    // Image source only applies to image objects; text objects keep it empty.
    obj.imageUrl  = _isImg ? document.getElementById('tv-image-url').value.trim() : '';
    obj.aspect    = State.imageAspect || obj.aspect || 1.0;
    obj.font      = document.getElementById('tv-font').value;
    obj.color     = document.getElementById('tv-color').value;
    obj.size      = parseFloat(document.getElementById('tv-size').value) || 4.0;
    obj.shadow    = State.shadowEnabled;
    obj.glow      = State.glowEnabled;
    obj.outline          = State.outlineEnabled;
    obj.outlineColor     = document.getElementById('tv-outline-color').value || '#000000';
    obj.outlineWidth     = parseInt(document.getElementById('tv-outline-width').value) || 2;
    obj.colorShift         = State.colorShiftEnabled;
    obj.colorShiftAdvanced = State.colorShiftAdvanced;
    obj.colorShiftColors   = State.colorShiftAdvanced ? (document.getElementById('tv-chroma-colors').value || '') : '';
    obj.colorShiftSpeed    = parseInt(document.getElementById('tv-chroma-speed').value) || 60;
    obj.gradient           = State.gradientEnabled;
    obj.gradientFrom       = document.getElementById('tv-gradient-from').value || '#ffd966';
    obj.gradientTo         = document.getElementById('tv-gradient-to').value   || '#c08a1f';
    obj.pulse              = State.pulseEnabled;
    obj.pulseSpeed         = parseInt(document.getElementById('tv-pulse-speed').value) || 60;
    obj.animation = document.getElementById('tv-anim').value;
    obj.animIn    = parseInt(document.getElementById('tv-anim-in').value)  || 15;
    obj.animOut   = parseInt(document.getElementById('tv-anim-out').value) || 15;
    const start = parseInt(document.getElementById('tc-start').value) || 0;
    const end   = parseInt(document.getElementById('tc-end').value)   || (start + 60);
    clip.startFrame = Math.max(0, start);
    clip.endFrame   = Math.max(clip.startFrame + 1, end);
    syncTextToLua();
    renderTimeline();
    showToast(t('toasts.text_clip_saved'));
};

// Lock / unlock the selected text to a recorded vehicle or ped. Two-step
// convert (mirrors applyKeyframeLock): if already locked, first convert the
// stored offset back to world; then convert that world pose into the new lock
// (offset + lockYaw) or leave it as world. Lua owns the entity math.
CC.applyTextLock = async function() {
    if (State.editingClipId === null) return;
    const clip = State.textClips.find(c => c.id === State.editingClipId);
    const obj  = clip ? State.textObjects.find(o => o.id === clip.textId) : null;
    if (!obj || !obj.coords) return;

    const sel    = document.getElementById('tv-lock-entity');
    const newRef = sel.value === '' ? null : sel.value;
    const oldRef = (obj.lockedEntity === null || obj.lockedEntity === undefined || obj.lockedEntity === '') ? null : String(obj.lockedEntity);
    if (newRef === oldRef) return;
    const orient = obj.orientWithEntity !== false;

    // Resolve the text's current world coords.
    let wc = { x: obj.coords.x, y: obj.coords.y, z: obj.coords.z,
               heading: obj.coords.heading || 0, rx: obj.coords.rx || 0, ry: obj.coords.ry || 0 };
    if (oldRef != null) {
        const r = await postAwait('convertTextLock', {
            frame: State.currentFrame, coords: obj.coords,
            lockedEntity: null, fromEntity: oldRef,
            lockYaw: obj.lockYaw || 0, orientWithEntity: orient,
        });
        if (r && r.coords) wc = r.coords;
    }

    if (newRef != null) {
        const r = await postAwait('convertTextLock', {
            frame: State.currentFrame, coords: wc,
            lockedEntity: newRef, orientWithEntity: orient,
        });
        if (r && r.error === 'out_of_range') {
            showToast(t('toasts.text_entity_out_of_range'), 'error');
            sel.value = oldRef || '';
            return;
        }
        if (r && r.coords) {
            obj.coords = r.coords;
            obj.lockedEntity = newRef;
            obj.lockYaw = (typeof r.lockYaw === 'number') ? r.lockYaw : 0;
            obj.orientWithEntity = orient;
        }
        const label = sel.options[sel.selectedIndex] ? sel.options[sel.selectedIndex].textContent.trim() : 'entity';
        showToast(t('toasts.text_locked', { target: label }));
    } else {
        obj.coords = wc;
        delete obj.lockedEntity;
        delete obj.lockYaw;
        showToast(t('toasts.text_unlocked'));
    }

    const orientRow = document.getElementById('tv-lock-orient-row');
    if (orientRow) orientRow.classList.toggle('hidden', !obj.lockedEntity);

    syncTextToLua();
    renderTimeline();
};

// Toggle whether locked text rotates with the entity (decal) or only tracks
// its position with a fixed facing (floating title). Coords are stored as a
// world offset + lockYaw, so this is a pure render switch — no re-conversion.
CC.toggleTextOrient = function() {
    if (State.editingClipId === null) return;
    const clip = State.textClips.find(c => c.id === State.editingClipId);
    const obj  = clip ? State.textObjects.find(o => o.id === clip.textId) : null;
    if (!obj) return;
    obj.orientWithEntity = document.getElementById('tv-lock-orient').checked;
    syncTextToLua();
};

CC.updateClipTiming = function() {
    if (State.editingClipId === null) return;
    const clip = State.textClips.find(c => c.id === State.editingClipId);
    if (!clip) return;
    const start = parseInt(document.getElementById('tc-start').value) || 0;
    const end   = parseInt(document.getElementById('tc-end').value) || (start + 60);
    clip.startFrame = Math.max(0, start);
    clip.endFrame   = Math.max(clip.startFrame + 1, end);
    syncTextToLua();
    renderTextTrack(getTimelineWidth());
};

CC.deleteSelectedClip = function() {
    if (State.editingClipId === null) return;
    pushUndo();
    const clip = State.textClips.find(c => c.id === State.editingClipId);
    if (clip) {
        State.textClips   = State.textClips.filter(c => c.id !== clip.id);
        State.textObjects = State.textObjects.filter(o => o.id !== clip.textId);
    }
    State.editingClipId = null;
    deselectClip();
    syncTextToLua();
    renderTimeline();
    CC.backToMenu();
};

CC.applyWorldSettings = function() {
    State.worldSettings.time            = parseFloat(document.getElementById('ws-time-num').value) || 12.0;
    State.worldSettings.freezeTime      = document.getElementById('ws-freeze').checked;
    State.worldSettings.weather         = document.getElementById('ws-weather').value;
    State.worldSettings.weatherOverride = document.getElementById('ws-weather-override').checked;
    State.worldSettings.rainEnabled     = document.getElementById('ws-rain-enabled').checked;
    State.worldSettings.rainLevel       = parseFloat(document.getElementById('ws-rain-num').value) || 0.0;
    State.worldSettings.cityLights      = document.getElementById('ws-citylights').checked;
    post('setWorldSettings', State.worldSettings);
};

// ── ADD KEYFRAME ──────────────────────────────────────────────────────────────
//
// Add Keyframe opens a type menu. All types land on the same camera timeline;
// the kind decides what the keyframe carries and how it's coloured.

CC.toggleAddKeyframeMenu = function(ev) {
    if (ev) ev.stopPropagation();
    hideMarkerSubmenus();
    const menu = document.getElementById('add-kf-menu');
    menu.classList.toggle('hidden');
    if (menu.classList.contains('hidden')) return;
    // Close on the next click anywhere else. `once` means we never accumulate
    // listeners no matter how often the menu is opened.
    setTimeout(() => {
        document.addEventListener('click', () => menu.classList.add('hidden'), { once: true });
    }, 0);
};

function hideMarkerSubmenus() {
    document.getElementById('add-kf-scene-menu').classList.add('hidden');
    document.getElementById('add-kf-external-menu').classList.add('hidden');
}

// Second level of the Add Keyframe menu. 'scene' shows the two static battle
// actions; 'external' is rebuilt from the config every open so a config
// change lands without reopening the editor.
CC.openMarkerSubmenu = function(ev, which) {
    if (ev) ev.stopPropagation();
    document.getElementById('add-kf-menu').classList.add('hidden');

    if (which === 'external') {
        const list = State.externalKeyframes || [];
        if (!list.length) {
            showToast(tOr('toasts.no_external_keyframes',
                'No external keyframes configured — add entries to Config.ExternalKeyframes'), 'error');
            return;
        }
        const menu = document.getElementById('add-kf-external-menu');
        menu.innerHTML = '';
        list.forEach(entry => {
            const item = document.createElement('div');
            item.className = 'akf-item';
            const sub = [entry.clientEvent, entry.serverEvent,
                         entry.export && entry.export.resource ? entry.export.resource + ':' + entry.export.func : null,
                         entry.serverExport && entry.serverExport.resource ? entry.serverExport.resource + ':' + entry.serverExport.func : null]
                        .filter(Boolean).join(', ');
            item.innerHTML = '<span class="akf-dot kind-external"></span>' +
                '<div class="akf-text"><div class="akf-name"></div><div class="akf-sub"></div></div>';
            item.querySelector('.akf-name').textContent = entry.label || entry.id;
            item.querySelector('.akf-sub').textContent  = sub || tOr('ui.marker_no_triggers', 'no triggers defined');
            item.addEventListener('click', () => CC.addExternalMarker(entry.id));
            menu.appendChild(item);
        });
    }

    const menu = document.getElementById(which === 'external' ? 'add-kf-external-menu' : 'add-kf-scene-menu');
    menu.classList.remove('hidden');
    setTimeout(() => {
        document.addEventListener('click', () => menu.classList.add('hidden'), { once: true });
    }, 0);
};

CC.addKeyframeOfKind = function(kind) {
    document.getElementById('add-kf-menu').classList.add('hidden');
    if (kind === 'resume') { CC.openResumeModal(); return; }
    CC.addKeyframe();
};

// Marker inserts share insertKeyframe so undo / sorting / Lua sync / selection
// all behave exactly like a normal keyframe. The pose snapshot they carry is
// never read — markers are filtered out of every camera-path consumer.
CC.addSceneMarker = function(action) {
    hideMarkerSubmenus();
    const kf = insertKeyframe('scene', null, { sceneAction: action, easing: 'linear' });
    showToast(tOr('toasts.marker_added', '{name} marker added at frame {frame}')
        .replace('{name}', markerTitle(kf)).replace('{frame}', kf.frame));
};

CC.addExternalMarker = function(id) {
    hideMarkerSubmenus();
    const entry = (State.externalKeyframes || []).find(e => e.id === id);
    if (!entry) return;
    const kf = insertKeyframe('external', null, {
        externalId: entry.id, externalLabel: entry.label || entry.id, easing: 'linear',
    });
    showToast(tOr('toasts.marker_added', '{name} marker added at frame {frame}')
        .replace('{name}', markerTitle(kf)).replace('{frame}', kf.frame));
};

// Shared insert path. `pose` overrides the live camera (used by resume, which
// takes its pose from another project instead of from where you're standing).
function insertKeyframe(kind, pose, extra) {
    pushUndo();
    const kf = makeKeyframe(
        State.currentFrame,
        pose ? { ...pose.pos } : { ...State.currentCamPos },
        pose ? { ...pose.rot } : { ...State.currentCamRot },
        pose ? pose.fov       : State.currentCamFov,
        kind
    );
    if (extra) Object.assign(kf, extra);

    State.keyframes.push(kf);
    sortKeyframes();
    consumePendingTransition();
    syncKeyframesToLua();
    renderTimeline();
    selectKeyframe(kf.id);
    return kf;
}

// Add keyframe at current playhead using CURRENT CAMERA POSITION
CC.addKeyframe = function() {
    const kf = insertKeyframe('camera', null);
    showToast(t('toasts.keyframe_added', { id: kf.id, frame: kf.frame }));
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) Tutorial.fire('tut:keyframeAdded');
};

// ── RESUME FROM PROJECT ───────────────────────────────────────────────────────
//
// The point of the whole thing: a cinematic that spans several locations is
// several projects, and each one starts on the pose the previous one ended on.
// This keyframe carries that imported pose, and the transition sitting on it is
// what actually moves the camera from there into this project's first shot.

let _resumeQuery   = '';     // live search text in the resume picker
let _stagedResume  = null;   // imported pose not yet committed to the timeline

CC.onResumeSearch = function(value) {
    _resumeQuery = value || '';
    renderResumeList();
};

CC.openResumeModal = function() {
    document.getElementById('resume-error').classList.add('hidden');
    const list = document.getElementById('resume-list');
    list.innerHTML = `<div class="resume-empty">${t('ui.resume_loading')}</div>`;

    // Reset the search each open — a filter left over from last time reads as
    // "half my projects are missing".
    _resumeQuery = '';
    const search = document.getElementById('resume-search');
    if (search) search.value = '';

    document.getElementById('resume-modal').classList.remove('hidden');
    if (search) setTimeout(() => search.focus(), 30);
    // Always re-fetch: another director may have saved since this editor opened.
    post('listProjects');
};

CC.closeResumeModal = function() {
    document.getElementById('resume-modal').classList.add('hidden');
};

// Called whenever a project list arrives while the resume modal is open.
function renderResumeList() {
    const modal = document.getElementById('resume-modal');
    if (!modal || modal.classList.contains('hidden')) return;

    const list = document.getElementById('resume-list');
    // Exclude the project we're editing — resuming from yourself is a no-op
    // that would just duplicate your own last keyframe.
    const openSlug = State.currentProject && State.currentProject.slug;
    const rows = (State.projectList || []).filter(p => p.slug !== openSlug);

    // Search filters on both the display name and the slug, since the slug is
    // what shows in the browser and is often what sticks in the memory.
    const q = (_resumeQuery || '').trim().toLowerCase();
    const matches = q
        ? rows.filter(p => ((p.name || '') + ' ' + (p.slug || '')).toLowerCase().includes(q))
        : rows;

    if (!rows.length) {
        list.innerHTML = `<div class="resume-empty">${t('ui.resume_none')}</div>`;
        return;
    }
    if (!matches.length) {
        list.innerHTML = `<div class="resume-empty">${t('ui.resume_no_match')}</div>`;
        return;
    }

    list.innerHTML = '';
    [...matches].sort((a, b) => (b.updatedAt || 0) - (a.updatedAt || 0)).forEach(p => {
        // Deliberately the SAME markup and classes as the main-menu browser
        // (renderProjectList) so the state glow, icon tint and state pill come
        // from one place and can't drift. Only the delete button is left out —
        // this picker reads projects, it never removes them.
        const card = document.createElement('div');
        card.className = 'po-card';
        const state = p.state || 'shared';
        card.dataset.state = state;

        const date    = p.updatedAt ? new Date(p.updatedAt * 1000) : null;
        const dateStr = date
            ? date.toLocaleDateString(undefined, { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' })
            : '';

        const stateIcon  = state === 'locked' ? 'fa-lock' : state === 'admin' ? 'fa-shield-halved' : 'fa-globe';
        const stateLabel = t('project.state_' + state) || state;

        card.innerHTML =
            '<div class="po-card-icon"><i class="fa-solid fa-film"></i></div>' +
            '<div class="po-card-info">' +
              '<div class="po-card-name"></div>' +
              '<div class="po-card-meta"></div>' +
            '</div>' +
            '<div class="po-card-badges">' +
              '<span class="po-badge state-' + state + '"><i class="fa-solid ' + stateIcon + '"></i>' +
              '<span class="po-badge-label"></span></span>' +
            '</div>';
        // Project names are user input — set as text, never as markup.
        card.querySelector('.po-card-name').textContent  = p.name || p.slug;
        card.querySelector('.po-card-meta').textContent  = dateStr;
        card.querySelector('.po-badge-label').textContent = stateLabel;
        card.title = p.name || p.slug;

        card.onclick = () => {
            document.getElementById('resume-error').classList.add('hidden');
            post('getProjectTail', { slug: p.slug });
        };
        list.appendChild(card);
    });

    // Horizontal strip, and the mouse wheel only scrolls vertically by default —
    // without this the list looks stuck for anyone without a trackpad.
    list.onwheel = (e) => {
        if (e.deltaY === 0) return;
        e.preventDefault();
        list.scrollLeft += e.deltaY;
    };
}

// The imported pose came back from the server.
//
// Nothing is written to the timeline yet. The pose is STAGED and the transition
// picker runs against it; only Apply commits the keyframe. Inserting first and
// asking after left a stray keyframe behind every time someone backed out.
function onProjectTail(tail) {
    if (!tail || !tail.keyframe) { onProjectTailError(t('errors.resume_nothing')); return; }
    CC.closeResumeModal();

    const src = tail.keyframe;
    _stagedResume = {
        frame: State.currentFrame,
        pos:   { ...src.pos },
        rot:   { ...src.rot },
        fov:   src.fov || State.defaultFov,
        slug:  tail.slug,
        name:  tail.name,
    };

    CC.openTransitionModal();
}

// Commits the staged pose as a real keyframe. Returns it, or null if nothing
// was staged.
function commitStagedResume() {
    if (!_stagedResume) return null;
    const s = _stagedResume;
    _stagedResume = null;
    const kf = insertKeyframe('resume', { pos: s.pos, rot: s.rot, fov: s.fov }, {
        resumeSlug: s.slug,
        resumeName: s.name,
    });
    return kf;
}

function onProjectTailError(message) {
    const el = document.getElementById('resume-error');
    const modal = document.getElementById('resume-modal');
    if (modal && !modal.classList.contains('hidden') && el) {
        el.classList.remove('hidden');
        el.textContent = message || 'Could not read that project.';
    } else {
        showToast(message || 'Could not read that project.', 'error');
    }
}

// A resume keyframe added at the end of the timeline has no destination yet, so
// its transition can't be generated. The choice is parked on the keyframe and
// spent the moment a keyframe lands after it — which is exactly the flow the
// director follows: drop the resume pose, then go frame the first real shot.
function consumePendingTransition() {
    // Camera keyframes only: a parked transition must land on the next SHOT,
    // not on a battle/external marker that happens to sit in between (its
    // pose is a meaningless snapshot the generator would fly the camera to).
    const ordered = cameraKfs().sort((a, b) => a.frame - b.frame);
    for (let i = 0; i < ordered.length - 1; i++) {
        const kf = ordered[i];
        if (!kf.pendingTransition) continue;
        const from = kf, to = ordered[i + 1];
        const { id, opts, seconds } = kf.pendingTransition;

        // Honour the duration chosen when the transition was armed, now that
        // there's finally something to measure the gap against.
        if (seconds) {
            resizeTransitionGap(from, to, Math.max(2, Math.round(seconds * State.fps)));
        }
        if (Transitions.validate(id, from, to, State.fps)) continue;   // still not viable — leave it parked

        const result = Transitions.build(id, from, to, opts, {
            fps: State.fps, fovMin: State.fovMin, fovMax: State.fovMax,
            mk: (frame, pos, rot, fov) => makeKeyframe(frame, pos, rot, fov),
        });
        if (!result) continue;

        delete kf.pendingTransition;   // spend it once, never fight later edits
        (result.patch  || []).forEach(p => {
            if (!p.target) return;
            if (p.easing !== undefined) p.target.easing = p.easing;
            if (p.cut    !== undefined) p.target.cut    = p.cut;
        });
        (result.insert || []).forEach(k => { k.kind = 'transition'; State.keyframes.push(k); });
        sortKeyframes();
        showToast(t('toasts.transition_applied_new_shot', { name: Transitions.get(id).label }));
        return;
    }
}

CC.deleteSelectedKeyframe = function() {
    if (State.selectedKfId === null) return;
    pushUndo();
    // Deletes the whole selection, not just the primary — a multi-select that
    // only removed one of the highlighted keyframes would be a trap.
    const doomed = selectionCount()
        ? State.selection.filter(sel => sel.kind === 'kf').map(sel => sel.id)
        : [State.selectedKfId];
    const before = State.keyframes.length;
    State.keyframes = State.keyframes.filter(k => doomed.indexOf(k.id) < 0);
    if (doomed.length > 1) showToast(t('toasts.keyframes_deleted', { count: before - State.keyframes.length }));
    State.selectedKfId = null;
    clearSelection();
    syncKeyframesToLua();
    renderTimeline();
    hideSidePanel();
};

// ── TRANSITIONS ───────────────────────────────────────────────────────────────
//
// A transition fills the gap between the selected keyframe and the next one.
// It generates ordinary keyframes (see transitions.js) — nothing here becomes a
// special timeline object, so the result can be tweaked, moved or deleted like
// anything else the user placed by hand.

let _transPick     = null;   // id of the transition currently selected in the modal
let _transDuration = null;   // seconds chosen on the duration slider

/// t() hands back the key itself when a string is missing, so `t(k) || 'text'`
/// never reaches its fallback — it shows the raw key instead. This returns the
/// fallback in that case, which matters for the 15 locales that won't carry
/// these strings until they're translated.
function tOr(key, fallback) {
    const v = t(key);
    return (v === key) ? fallback : v;
}

// The selected keyframe and the one after it. `to` is null when the selection
// is the last keyframe on the timeline — which is the normal state right after
// dropping a resume keyframe, since the shot it leads into hasn't been framed
// yet. That case is legal: the choice gets parked on the keyframe instead.
function transitionPair() {
    // Markers can't anchor or receive a camera move — skip them entirely, so
    // "the next keyframe" always means the next real shot.
    const ordered = cameraKfs().sort((a, b) => a.frame - b.frame);

    // A staged resume isn't on the timeline yet, so it stands in as `from` and
    // the destination is whatever keyframe sits after the playhead.
    if (_stagedResume) {
        const from = {
            frame: _stagedResume.frame,
            pos:   _stagedResume.pos,
            rot:   _stagedResume.rot,
            fov:   _stagedResume.fov,
            kind:  'resume',
        };
        const to = ordered.find(k => k.frame > _stagedResume.frame) || null;
        return { from, to, staged: true };
    }

    if (State.selectedKfId === null) return null;
    const i = ordered.findIndex(k => k.id === State.selectedKfId);
    if (i < 0) return null;
    return { from: ordered[i], to: (i < ordered.length - 1) ? ordered[i + 1] : null, staged: false };
}

CC.openTransitionModal = function() {
    const pair = transitionPair();
    if (!pair) {
        showToast(tOr('toasts.transition_needs_next',
                  'Select a keyframe first — the transition runs from it into the next one.'), 'error');
        return;
    }

    // Park mode: no keyframe after this one yet, so the destination is unknown
    // and nothing can be generated or validated. The pick is stored and spent
    // the moment the next keyframe lands.
    const parked  = !pair.to;
    const seconds = parked ? null : (pair.to.frame - pair.from.frame) / State.fps;

    document.getElementById('trans-gap').textContent = parked
        ? 'applies when you add your next keyframe'
        : `gap ${seconds.toFixed(2)}s · ${pair.to.frame - pair.from.frame} frames`;

    // Built fresh each open so validity reflects THIS pair.
    const list = document.getElementById('trans-list');
    list.innerHTML = '';
    Transitions.catalog().forEach(def => {
        const res  = parked ? { ok: true } : Transitions.check(def.id, pair.from, pair.to, State.fps);
        // Only structural problems disable a card. "Needs more room" stays
        // pickable — picking it offers to stretch the gap instead of dead-ending.
        const hardBlocked = !res.ok && res.code === 'structural';
        const card = document.createElement('div');
        card.className = 'trans-card' + (hardBlocked ? ' disabled' : '');
        card.dataset.id = def.id;
        card.title = res.ok ? def.blurb : res.message;
        card.innerHTML = `<i class="${def.icon}"></i><span>${def.label}</span>` +
                         (!res.ok && res.code === 'duration' ? '<i class="fa-solid fa-clock" style="margin-left:auto;opacity:0.5;font-size:9px"></i>' : '');
        if (!hardBlocked) card.onclick = () => CC.onTransitionPick(def.id);
        list.appendChild(card);
    });

    // Open on whatever suits the distance rather than making the director learn
    // which transition belongs to which kind of jump.
    let initial = parked ? 'rise' : Transitions.suggest(pair.from, pair.to);
    if (!parked && Transitions.validate(initial, pair.from, pair.to, State.fps)) {
        const ok = Transitions.catalog().find(d => !Transitions.validate(d.id, pair.from, pair.to, State.fps));
        initial = ok ? ok.id : null;
    }

    document.getElementById('trans-modal').classList.remove('hidden');
    if (initial) {
        CC.onTransitionPick(initial);
        if (parked) {
            showTransitionWarning('No keyframe after this one yet. Your choice is saved and applied automatically as soon as you frame the next shot.');
        }
    } else {
        _transPick = null;
        document.getElementById('trans-blurb').textContent = '';
        showTransitionWarning(`This gap is ${seconds.toFixed(2)}s — too short for any transition. Move the keyframes further apart.`);
        document.getElementById('trans-apply').disabled = true;
    }
};

CC.closeTransitionModal = function() {
    document.getElementById('trans-modal').classList.add('hidden');
    // Backing out of the picker after choosing a project must leave the
    // timeline exactly as it was — the pose was only ever staged.
    if (_stagedResume) {
        _stagedResume = null;
        showToast(t('toasts.resume_cancelled'), 'info');
    }
};

CC.onTransitionPick = function(id) {
    _transPick = id;
    const def = Transitions.get(id);

    document.querySelectorAll('#trans-list .trans-card').forEach(c => {
        c.classList.toggle('selected', c.dataset.id === id);
    });
    document.getElementById('trans-blurb').textContent = def ? def.blurb : '';

    // Show only the option rows this transition actually reads. Each row is
    // tagged with the transition id it belongs to (`data-opt`); rows marked
    // 'always' (the duration slider) show for every transition.
    const optKey = { whip: 'degrees', rise: 'height', gtaswitch: 'height', zoompunch: 'punch', wipe: 'wipe' }[id];
    document.querySelectorAll('#trans-opts .trans-opt-row').forEach(row => {
        row.classList.toggle('hidden', row.dataset.opt !== optKey && row.dataset.opt !== 'always');
    });

    // Duration defaults to what this transition wants, and the slider floor is
    // what it mechanically needs.
    const slider = document.getElementById('trans-duration');
    const numBox = document.getElementById('trans-duration-num');
    if (slider && def) {
        const pairNow = transitionPair();
        const gapSec  = (pairNow && pairNow.to) ? (pairNow.to.frame - pairNow.from.frame) / State.fps : null;
        // Open on the transition's own recommendation, unless the existing gap
        // is already longer — then keep what the director laid out.
        const start   = gapSec != null ? Math.max(gapSec, def.defaultSeconds) : def.defaultSeconds;
        slider.min = numBox.min = def.minSeconds;
        slider.max = numBox.max = Math.max(12, Math.ceil(start * 1.5));
        CC.onTransitionDuration(start);
    }

    showTransitionWarning(null);
    document.getElementById('trans-apply').disabled = false;
};

// Duration is authoritative: the gap is made to match it on Apply. The note
// tells the director up-front whether that will push their later keyframes,
// so the timeline never reshuffles as a surprise.
CC.onTransitionDuration = function(value) {
    const sec = Math.max(0.1, parseFloat(value) || 0);
    document.getElementById('trans-duration').value     = sec;
    document.getElementById('trans-duration-num').value = sec.toFixed(1);
    _transDuration = sec;

    const note = document.getElementById('trans-duration-note');
    const pair = transitionPair();
    if (!note) return;

    if (!pair || !pair.to) {
        note.textContent = 'Placed when you add your next keyframe.';
        return;
    }
    const want  = Math.round(sec * State.fps);
    const have  = pair.to.frame - pair.from.frame;
    const delta = want - have;
    note.textContent = delta === 0
        ? `Fits the ${(have / State.fps).toFixed(1)}s gap you have.`
        : delta > 0
            ? `Gap is ${(have / State.fps).toFixed(1)}s — the landing keyframe and everything after it move ${delta} frames later.`
            : `Gap is ${(have / State.fps).toFixed(1)}s — the landing keyframe and everything after it move ${-delta} frames earlier.`;
};

// Makes the gap between `from` and `to` exactly `frames` long, carrying every
// later keyframe with it so the rest of the edit keeps its relative timing.
// Returns false if it couldn't (would collide with the keyframe before `from`).
function resizeTransitionGap(from, to, frames) {
    const delta = frames - (to.frame - from.frame);
    if (delta === 0) return true;

    if (delta < 0) {
        // Shrinking: the landing keyframe must not land on or before `from`.
        if (to.frame + delta <= from.frame) return false;
    }
    State.keyframes.forEach(k => { if (k.frame >= to.frame) k.frame += delta; });

    // Grow the timeline if the shift pushed past the end, otherwise the
    // keyframes we just moved would sit beyond the scrubber. CC.setDuration is
    // the real setter — it updates the duration input and re-syncs too.
    const lastFrame = State.keyframes.reduce((m, k) => Math.max(m, k.frame), 0);
    if (lastFrame >= totalFrames()) {
        CC.setDuration(Math.ceil((lastFrame + State.fps) / State.fps));
    }
    sortKeyframes();
    return true;
}

function showTransitionWarning(msg, offer) {
    const el = document.getElementById('trans-warning');
    if (!el) return;
    if (!msg) { el.classList.add('hidden'); el.innerHTML = ''; return; }
    el.classList.remove('hidden');
    el.innerHTML = '';

    const text = document.createElement('div');
    text.textContent = msg;
    el.appendChild(text);

    if (offer) {
        const btn = document.createElement('button');
        btn.className = 'msm-btn msm-btn-apply';
        btn.style.cssText = 'margin-top:8px;font-size:10px;padding:4px 10px';
        btn.textContent = offer.label;
        btn.onclick = offer.action;
        el.appendChild(btn);
    }
}

// Reads the option rows for whichever transition is selected. Rows that belong
// to other transitions are ignored, so stale values in hidden inputs can't leak
// into the generated keyframes.
function transitionOpts(id) {
    const num = elId => parseFloat(document.getElementById(elId).value);
    switch (id) {
        case 'whip':
            return { degrees: num('trans-degrees-num') || 60 };
        case 'rise':
        case 'gtaswitch':
            return document.getElementById('trans-height-auto').checked
                ? {}                                        // let the generator scale it from the distance
                : { height: num('trans-height-num') || 160 };
        case 'zoompunch':
            return { punch: num('trans-punch-num') || 0.45 };
        case 'wipe':
            return {
                angle:    num('trans-angle-num') || 0,
                color:    document.getElementById('trans-color').value || '#000000',
                softness: num('trans-softness-num') || 0,
            };
        default:
            return {};
    }
}

CC.applyTransition = function() {
    if (!_transPick) return;
    let pair = transitionPair();
    if (!pair) { CC.closeTransitionModal(); return; }

    // Apply is the commit point for a staged resume — this is the first moment
    // anything touches the timeline.
    if (pair.staged) {
        const kf = commitStagedResume();
        if (!kf) { CC.closeTransitionModal(); return; }
        selectKeyframe(kf.id);
        pair = transitionPair();
        if (!pair) { CC.closeTransitionModal(); return; }
    }

    // No destination yet — park the choice on the keyframe. consumePendingTransition
    // spends it as soon as a keyframe lands after this one.
    if (!pair.to) {
        pushUndo();
        pair.from.pendingTransition = {
            id:      _transPick,
            opts:    transitionOpts(_transPick),
            seconds: _transDuration,
        };
        syncKeyframesToLua();
        renderTimeline();
        document.getElementById('trans-modal').classList.add('hidden');
        showToast(t('toasts.transition_armed', { name: Transitions.get(_transPick).label }));
        return;
    }

    // The slider is authoritative: make the gap match the chosen duration
    // before generating anything.
    if (_transDuration) {
        const wantFrames = Math.max(2, Math.round(_transDuration * State.fps));
        if (!resizeTransitionGap(pair.from, pair.to, wantFrames)) {
            showTransitionWarning('That duration would collapse the gap onto the previous keyframe. Pick a longer one.');
            return;
        }
    }

    const why = Transitions.validate(_transPick, pair.from, pair.to, State.fps);
    if (why) { showTransitionWarning(why); return; }

    const result = Transitions.build(_transPick, pair.from, pair.to, transitionOpts(_transPick), {
        fps:    State.fps,
        fovMin: State.fovMin,
        fovMax: State.fovMax,
        mk:     (frame, pos, rot, fov) => makeKeyframe(frame, pos, rot, fov),
    });
    if (!result) { showTransitionWarning('Could not build that transition.'); return; }

    pushUndo();

    // Patches land on keyframes the user already had — only ever easing and the
    // cut flag, never their pose or frame, so applying a transition can't move
    // their work. Undo is captured above, so this stays reversible.
    (result.patch || []).forEach(p => {
        if (!p.target) return;
        if (p.easing !== undefined) p.target.easing = p.easing;
        if (p.cut    !== undefined) p.target.cut    = p.cut;
    });
    // Every keyframe the generator produced is part of the move, so the whole
    // run is coloured — not just the one you started from. It also tells the
    // streaming pre-warm which keyframes are staging poses (a switch's apex is
    // 900m of empty sky) versus the real destination on the ground.
    (result.insert || []).forEach(kf => { kf.kind = 'transition'; State.keyframes.push(kf); });

    sortKeyframes();
    syncKeyframesToLua();
    renderTimeline();
    CC.closeTransitionModal();

    const def   = Transitions.get(_transPick);
    const count = (result.insert || []).length;
    const line  = t('toasts.transition_applied', { name: def.label, count: count });
    showToast(line === 'toasts.transition_applied' ? `${def.label} added — ${count} keyframes` : line);
};

// Universal Delete-key handler. Looks at whatever the user has selected on
// the timeline (keyframe / overlay layer / text clip) and removes it. Lets
// the same shortcut work for every clip type instead of routing each through
// its own button.
CC.deleteSelected = function() {
    if (State.selectedKfId !== null) { CC.deleteSelectedKeyframe(); return; }
    if (State.selectedOverlayId !== null) {
        const idx = State.overlayLayers.findIndex(l => l.id === State.selectedOverlayId);
        if (idx >= 0) CC.deleteOverlayLayer(idx + 1);
        return;
    }
    // A single main-rec clip (a cut piece). Only removes that slice — never the
    // last one (deleting the whole recording stays on its own button).
    if (State.vehicleRecSelected && State.vehicleRecClips.length > 1
        && State.selectedVehClipIdx != null) {
        State.vehicleRecClips.splice(State.selectedVehClipIdx, 1);
        State.vehicleRecClips.forEach((c, i) => { c.id = i + 1; });
        State.selectedVehClipIdx = null;
        pushVehicleRecClips();
        renderTimeline();
        showToast(t('toasts.clip_removed', { count: State.vehicleRecClips.length }));
        return;
    }
    if (State.selectedClipId !== null) {
        const clip = State.textClips.find(c => c.id === State.selectedClipId);
        if (clip) {
            pushUndo();
            State.textClips   = State.textClips.filter(c => c.id !== clip.id);
            State.textObjects = State.textObjects.filter(o => o.id !== clip.textId);
            State.selectedClipId = null;
            State.editingClipId  = null;
            syncTextToLua();
            renderTimeline();
            hideSidePanel();
        }
    }
};

CC.clearAll = function() {
    if (State.keyframes.length === 0) return;
    State.keyframes = [];
    State.selectedKfId = null;
    syncKeyframesToLua();
    renderTimeline();
    hideSidePanel();
};

// Enter position mode for selected keyframe
CC.positionCamera = function() {
    if (State.selectedKfId === null) {
        showToast(t('errors.select_keyframe_first'), 'error');
        return;
    }
    post('startPositionMode', {});
};

// Auto-save all panel values to the selected keyframe on every change (debounced)
let _autoSaveDebounce = null;
CC.autoSavePanel = function() {
    clearTimeout(_autoSaveDebounce);
    _autoSaveDebounce = setTimeout(() => {
        if (State.selectedKfId === null) return;
        const kf = State.keyframes.find(k => k.id === State.selectedKfId);
        if (!kf) return;

        // Markers only own their frame — the rest of the panel is hidden and
        // its inputs still hold the previously selected keyframe's values.
        if (isMarkerKf(kf)) {
            kf.frame = parseInt(document.getElementById('sp-frame').value) || kf.frame;
            sortKeyframes();
            syncKeyframesToLua();
            renderTimeline();
            document.getElementById('sp-title').textContent = markerTitle(kf) + ' — ' + kf.frame;
            post('jumpToFrame', { frame: kf.frame });
            return;
        }

        kf.frame  = parseInt(document.getElementById('sp-frame').value)  || kf.frame;
        kf.easing = document.getElementById('sp-easing').value;
        // "Cut to here": hard-cut INTO this keyframe (previous shot holds, then jumps).
        kf.cut    = document.getElementById('sp-cut').checked;
        const timeChecked = document.getElementById('sp-time-enabled').checked;
        kf.time = {
            enabled: timeChecked,
            // When disabled, preserve the old stored value (don't overwrite with world settings display)
            value: timeChecked
                ? (parseFloat(document.getElementById('sp-time-num').value) || 12.0)
                : (kf.time ? kf.time.value : 12.0),
        };
        kf.pos = {
            x: parseFloat(document.getElementById('sp-pos-x').value) || 0,
            y: parseFloat(document.getElementById('sp-pos-y').value) || 0,
            z: parseFloat(document.getElementById('sp-pos-z').value) || 0,
        };
        kf.rot = {
            x: parseFloat(document.getElementById('sp-rot-x').value) || 0,
            y: parseFloat(document.getElementById('sp-rot-y').value) || 0,
            z: parseFloat(document.getElementById('sp-rot-z').value) || 0,
        };
        kf.fov = parseFloat(document.getElementById('sp-fov-num').value) || State.defaultFov;
        kf.effects = {
            shake: {
                type:      document.getElementById('sp-shake-type').value,
                amplitude: parseFloat(document.getElementById('sp-shake-amp-num').value) || 0,
            },
            dof: {
                enabled:  document.getElementById('sp-dof-enabled').checked,
                near:     parseFloat(document.getElementById('sp-dof-near').value)        || 3.0,
                far:      parseFloat(document.getElementById('sp-dof-far').value)         || 50,
                fNumber:  parseFloat(document.getElementById('sp-dof-fnum-num').value)    || 1.2,
                strength: parseFloat(document.getElementById('sp-dof-str-num').value)     || 1,
            },
            motionBlur: parseFloat(document.getElementById('sp-blur-num').value) || 0,
            timeScale:  parseFloat(document.getElementById('sp-timescale-num').value) || 1.0,
            filter: {
                id:       document.getElementById('sp-filter-id').value,
                strength: parseFloat(document.getElementById('sp-filter-str-num').value) || 1,
            },
            fade: {
                type:   document.getElementById('sp-fade-type').value || 'none',
                amount: parseFloat(document.getElementById('sp-fade-amount-num').value) || 0,
            },
            letterbox:  parseFloat(document.getElementById('sp-letterbox-ratio').value) || 0,
            vignette:   parseFloat(document.getElementById('sp-vignette-num').value) || 0,
            grain:      parseFloat(document.getElementById('sp-grain-num').value) || 0,
            // Carried over, not rebuilt: the wipe is authored by the transition
            // generator and has no panel controls, so rebuilding effects from
            // the panel alone would silently delete it the first time the user
            // nudged anything else on a wipe keyframe.
            wipe:       (kf.effects && kf.effects.wipe) || undefined,
        };

        sortKeyframes();
        syncKeyframesToLua();
        renderTimeline();
        const idx = cameraKfs().indexOf(kf) + 1;
        document.getElementById('sp-title').textContent = t('ui.title_keyframe', { idx: idx, frame: kf.frame });
        post('previewKeyframe', { keyframe: kf });
    }, 60);
};

CC.close = function() {
    // If a capture is in flight, finalise it so the recorder doesn't keep
    // ffmpeg running after the editor closes (orphaned capture would burn
    // CPU and produce a runaway file). Fire-and-forget — we don't await
    // the response since the editor is closing anyway.
    if (State.exportActive || State.exportProcessing) {
        exporterFetch('/stop', { method: 'POST' });
        State.exportActive     = false;
        State.exportStaging    = false;
        State.exportProcessing = false;
    }
    if (State.cutMode) CC.toggleCutMode(); // never reopen with the razor armed
    post('close', {});
};

// ── CAMERA ANCHOR ─────────────────────────────────────────────────────────────
//
// Pins the player ped to the free camera so the world — and its collision —
// streams wherever you fly, instead of staying around where your body is.
//
// Off by default, because while recording a take the director IS the actor and
// their ped has to stay put. Forced on once the project holds a recording:
// replayed vehicles and peds need the player inside the physics sim radius or
// they don't move at all.

function projectHasRecording() {
    return !!State.vehicleRecording || (State.overlayLayers || []).length > 0;
}

CC.toggleCameraAnchor = function() {
    if (projectHasRecording()) {
        showToast(t('toasts.anchor_required_for_recording'), 'info');
        return;
    }
    State.cameraAnchor = !State.cameraAnchor;
    post('setCameraAnchor', { enabled: State.cameraAnchor });
    refreshCameraAnchorBtn();
    showToast(State.cameraAnchor
        ? 'Player stuck to camera — the world loads where you fly'
        : 'Player released — fly freely, but distant ground may not be loaded');
};

// Keeps the button honest about the three states: off, on, forced-on.
function refreshCameraAnchorBtn() {
    const btn = document.getElementById('tb-anchor-btn');
    if (!btn) return;
    const forced = projectHasRecording();
    btn.classList.toggle('locked', forced);
    btn.classList.toggle('active', forced || !!State.cameraAnchor);
    btn.title = forced
        ? 'Player stuck to camera (required — this project has a recording)'
        : (State.cameraAnchor
            ? 'Player stuck to camera — click to release'
            : 'Stick player to camera — loads the world where you fly');
}

CC.togglePathSharing = function() {
    State.pathSharingEnabled = !State.pathSharingEnabled;
    const btn = document.getElementById('tb-share-btn');
    btn.classList.toggle('active', State.pathSharingEnabled);
    post('setPathSharing', { enabled: State.pathSharingEnabled });
    showToast(State.pathSharingEnabled ? t('toasts.path_sharing_on') : t('toasts.path_sharing_off'));
};

CC.newTimeline = async function() {
    if (State.keyframes.length > 0 || State.textClips.length > 0 || State.sceneEntities.length > 0) {
        if (!await nuiConfirm(t('ui.confirm_new_timeline_title'), t('ui.confirm_new_timeline_message'))) return;
    }
    State.keyframes    = []; State.selectedKfId = null; State.currentFrame = 0;
    State.textObjects  = []; State.textClips = [];
    State.nextTextId   = 1;  State.nextTextClipId = 1;
    State.nextId       = 1;
    // Clear scene entities
    State.sceneEntities.forEach(ent => post('deleteSceneEntity', { entityId: ent.id }));
    State.sceneEntities = []; State.nextSceneId = 1; State.selectedSceneId = null;
    State.durationSec  = 30;
    // Detach from current project
    State.currentProject = null;
    if (State.autoSaveTimer) { clearInterval(State.autoSaveTimer); State.autoSaveTimer = null; }
    document.getElementById('tb-project-name').textContent = t('project.untitled');
    document.getElementById('tb-autosave-status').textContent = '';
    document.getElementById('duration-input').value = 30;
    document.getElementById('frame-input').value    = 0;
    syncKeyframesToLua(); syncTextToLua();
    renderTimeline(); updateTimecodeDisplay(); hideSidePanel(); CC.backToMenu();
    showProjectOverlay();
};

CC.exportTimeline = function() {
    const proj = State.currentProject || {};
    post('exportTimeline', {
        state: {
            version:        2,
            exportedAt:     Math.floor(Date.now() / 1000),
            fps:            State.fps,
            duration:       State.durationSec,
            keyframes:      State.keyframes,
            textObjects:    State.textObjects,
            textClips:      State.textClips,
            sceneEntities:  State.sceneEntities,
            nextSceneId:    State.nextSceneId,
            worldSettings:  State.worldSettings,
            interpSettings: State.interpSettings,
            relGroups:      State.relGroups,
            relMatrix:      State.relMatrix,
            slug:           proj.slug || null,
            name:           proj.name || null,
            createdAt:      proj.createdAt || null,
            updatedAt:      proj.updatedAt || null,
            tutorialEnabled:!!proj.tutorialEnabled,
        },
    });
};

CC.importTimeline = function() { document.getElementById('import-file-input').click(); };

document.getElementById('import-file-input').addEventListener('change', (e) => {
    const file = e.target.files[0]; if (!file) return;
    const reader = new FileReader();
    reader.onload = (ev) => {
        try {
            const data = JSON.parse(ev.target.result);
            if (!data.keyframes) throw new Error(t('errors.invalid_format'));
            // Lua does the heavy lifting (restoring recordings, spawning replay
            // entities, bucket switch). It echoes the JS-facing portion back via
            // a 'projectLoaded'-style message so onProjectLoaded restores it.
            post('importTimeline', { bundle: data });
        } catch (err) { showToast(t('errors.import_failed', { error: err.message }), 'error'); }
    };
    reader.readAsText(file);
    e.target.value = '';
});

// ── SIDE PANEL ────────────────────────────────────────────────────────────────
function selectKeyframe(kfId, keepMulti) {
    // Cancel any pending auto-save from the previous keyframe so it doesn't
    // fire against the newly selected one
    clearTimeout(_autoSaveDebounce);

    State.selectedKfId = kfId;
    // Selecting one keyframe collapses the multi-selection to it, unless the
    // caller is the multi-select code itself just setting a primary.
    if (!keepMulti) State.selection = [{ kind: 'kf', id: kfId }];
    if (State.vehicleRecSelected) deselectVehicleRec();

    const kf = State.keyframes.find(k => k.id === kfId);
    if (!kf) return;

    // Move playhead to the keyframe's frame
    State.currentFrame = kf.frame;
    document.getElementById('frame-input').value = kf.frame;
    updatePlayheadPosition();
    updateTimecodeDisplay();

    renderTimeline();
    populateSidePanel(kf);
    showSidePanel(kf);

    // Seek the whole scene (vehicle/ped/overlay recordings + ped anchor) to
    // this frame so the preview matches what the keyframe will actually see —
    // otherwise vehicles/peds stay frozen wherever the playhead last was.
    // jumpToFrame returns nil state for the very-last keyframe, so we still
    // fire previewKeyframe to guarantee the cam lands on the kf's exact pos.
    post('jumpToFrame', { frame: kf.frame });
    // Markers carry no real pose — previewing one would fly the camera to a
    // stale snapshot. jumpToFrame alone shows the shot the marker sits inside.
    if (!isMarkerKf(kf)) post('previewKeyframe', { keyframe: kf, frame: kf.frame });
}

function populateSidePanel(kf) {
    // Marker keyframes only expose their frame + a description of what they
    // fire. Every camera section is hidden via the marker-mode class; the
    // early return leaves the hidden inputs stale, which is fine — autoSave
    // has its own marker branch and never reads them for a marker.
    const marker = isMarkerKf(kf);
    document.getElementById('sp-props').classList.toggle('marker-mode', marker);
    const markerSec = document.getElementById('sp-marker-section');
    if (markerSec) markerSec.classList.toggle('hidden', !marker);
    if (marker) {
        document.getElementById('sp-frame').value = kf.frame;
        document.getElementById('sp-marker-title').textContent =
            kf.kind === 'scene'
                ? tOr('html.panels.marker_scene', 'SCENE CONTROL')
                : tOr('html.panels.marker_external', 'EXTERNAL TRIGGER');
        document.getElementById('sp-marker-desc').textContent = markerDescription(kf);
        return;
    }

    const fx    = kf.effects || {};
    const shake = fx.shake  || { type: 'none', amplitude: 0 };
    const dof   = fx.dof    || { enabled: false, near: 0.5, far: 50, strength: 1 };
    const filter= fx.filter || { id: 'none', strength: 1 };
    const time  = kf.time   || { enabled: false, value: 12.0 };

    // Resume keyframes get an extra section naming the project the pose came
    // from, plus a way back into the transition picker.
    const resumeSec = document.getElementById('sp-resume-section');
    if (resumeSec) {
        const isResume = kf.kind === 'resume';
        resumeSec.classList.toggle('hidden', !isResume);
        if (isResume) {
            const armed = kf.pendingTransition
                ? ` · ${Transitions.get(kf.pendingTransition.id).label} armed`
                : '';
            document.getElementById('sp-resume-source').textContent =
                (kf.resumeName || kf.resumeSlug || 'unknown project') + armed;
        }
    }

    document.getElementById('sp-frame').value  = kf.frame;
    // Legacy source-side cut keyframes display as a plain ease in the dropdown;
    // their behaviour is migrated to the destination kf.cut flag on load.
    document.getElementById('sp-easing').value = (kf.easing && kf.easing !== 'cut') ? kf.easing : 'ease';
    document.getElementById('sp-cut').checked   = !!kf.cut;

    const timeEnabled  = !!time.enabled;
    const timeDisplay  = timeEnabled ? (time.value || 12) : State.worldSettings.time;
    document.getElementById('sp-time-enabled').checked  = timeEnabled;
    document.getElementById('sp-time-slider').value     = timeDisplay;
    document.getElementById('sp-time-slider').disabled  = !timeEnabled;
    document.getElementById('sp-time-num').value        = timeDisplay.toFixed(1);
    document.getElementById('sp-time-num').disabled     = !timeEnabled;

    document.getElementById('sp-pos-x').value = kf.pos.x.toFixed(4);
    document.getElementById('sp-pos-y').value = kf.pos.y.toFixed(4);
    document.getElementById('sp-pos-z').value = kf.pos.z.toFixed(4);
    document.getElementById('sp-rot-x').value = kf.rot.x.toFixed(4);
    document.getElementById('sp-rot-y').value = kf.rot.y.toFixed(4);
    document.getElementById('sp-rot-z').value = kf.rot.z.toFixed(4);

    // Populate the lock-to-vehicle dropdown for this kf. We ask Lua for the
    // recorded-vehicle list with distance from the kf's *current world
    // position* (so the user sees nearby cars first). The kf's world position
    // depends on whether it's already locked: if so we need Lua to compute
    // it from the offset; if not we use kf.pos directly.
    populateKeyframeLockDropdown(kf);

    const fov = kf.fov || State.defaultFov;
    document.getElementById('sp-fov-slider').value = fov;
    document.getElementById('sp-fov-num').value    = fov;

    document.getElementById('sp-shake-type').value    = shake.type || 'none';
    document.getElementById('sp-shake-amp').value     = shake.amplitude || 0;
    document.getElementById('sp-shake-amp-num').value = (shake.amplitude || 0).toFixed(2);

    document.getElementById('sp-dof-enabled').checked  = !!dof.enabled;
    document.getElementById('sp-dof-near').value        = dof.near    || 3.0;
    document.getElementById('sp-dof-far').value         = dof.far     || 50;
    document.getElementById('sp-dof-fnum').value        = dof.fNumber || 1.2;
    document.getElementById('sp-dof-fnum-num').value    = (dof.fNumber || 1.2).toFixed(1);
    document.getElementById('sp-dof-str').value         = dof.strength || 1;
    document.getElementById('sp-dof-str-num').value     = (dof.strength || 1).toFixed(2);

    document.getElementById('sp-blur').value     = fx.motionBlur || 0;
    document.getElementById('sp-blur-num').value = (fx.motionBlur || 0).toFixed(2);

    document.getElementById('sp-timescale').value     = fx.timeScale || 1.0;
    document.getElementById('sp-timescale-num').value = (fx.timeScale || 1.0).toFixed(2);

    document.getElementById('sp-filter-id').value       = filter.id || 'none';
    document.getElementById('sp-filter-str').value      = filter.strength || 1;
    document.getElementById('sp-filter-str-num').value  = (filter.strength || 1).toFixed(2);

    // Cinematic effects
    const fade = fx.fade || {};
    document.getElementById('sp-fade-type').value           = fade.type || 'none';
    document.getElementById('sp-fade-amount').value         = fade.amount || 0;
    document.getElementById('sp-fade-amount-num').value     = (fade.amount || 0).toFixed(2);
    document.getElementById('sp-letterbox-ratio').value     = fx.letterbox || 0;
    document.getElementById('sp-vignette').value            = fx.vignette || 0;
    document.getElementById('sp-vignette-num').value        = (fx.vignette || 0).toFixed(2);
    document.getElementById('sp-grain').value               = fx.grain || 0;
    document.getElementById('sp-grain-num').value           = (fx.grain || 0).toFixed(2);
}

// Hide ALL side panel views at once — call before showing any specific view
function hideAllViews() {
    document.getElementById('sp-menu-view').classList.add('hidden');
    document.getElementById('sp-world-view').classList.add('hidden');
    document.getElementById('sp-interp-view').classList.add('hidden');
    document.getElementById('sp-record-view').classList.add('hidden');
    document.getElementById('sp-rec-props-view').classList.add('hidden');
    document.getElementById('sp-overlay-props-view').classList.add('hidden');
    const pt = document.getElementById('sp-playback-tuning-view');
    if (pt) pt.classList.add('hidden');
    document.getElementById('sp-text-view').classList.add('hidden');
    document.getElementById('sp-scene-view').classList.add('hidden');
    document.getElementById('sp-scene-props-view').classList.add('hidden');
    const exp = document.getElementById('sp-export-view');
    if (exp) exp.classList.add('hidden');
    const pap = document.getElementById('ped-appearance-panel');
    if (pap) pap.classList.add('hidden');
    document.getElementById('sp-props').classList.add('hidden');
    document.getElementById('sp-footer').classList.add('hidden');
    document.getElementById('sp-back-btn').classList.add('hidden');
    document.getElementById('sp-delete-btn').classList.add('hidden');
    document.getElementById('sp-delete-clip-btn').classList.add('hidden');
    document.getElementById('sp-pos-btn').classList.add('hidden');
}

// ── Keyframe → vehicle lock dropdown ─────────────────────────────────────────
// Populates the dropdown with recorded vehicles annotated by distance from the
// kf's effective world position at its own frame. Lua does the heavy math
// (the kf's world pos depends on whether it's already locked).
//
// Canonicalize a stored `lockedVehicle` so legacy bare-number references
// (saved before overlay-layer vehicles were lockable) match the new "v:N"
// dropdown option values. Returns "" for null so equality with sel.value works.
function canonicalizeVehicleRef(ref) {
    if (ref === null || ref === undefined || ref === '') return '';
    if (typeof ref === 'number') return 'v:' + ref;
    const s = String(ref);
    if (/^\d+$/.test(s)) return 'v:' + s;  // numeric string → main
    return s;                              // already "v:N" or "o:N"
}

async function populateKeyframeLockDropdown(kf) {
    const sel = document.getElementById('sp-lock-vehicle');
    if (!sel) return;

    // Wipe stale options from the previously-selected kf BEFORE awaiting Lua.
    // Otherwise the dropdown shows the previous kf's vehicles (and selection)
    // during the round-trip — which is the "data leak" the user kept hitting.
    const myKfId = kf.id;
    sel.innerHTML = `<option value="">${t('html.labels.lock_none')}</option>`;
    sel.value = canonicalizeVehicleRef(kf.lockedVehicle);

    // We need the kf's *world* position to rank vehicles by distance. Ask Lua
    // to compute it — handles both locked (offset → world) and unlocked
    // (already world) cases without us having to duplicate the math here.
    const w = await postAwait('getKeyframeWorldAt', { frame: kf.frame, keyframe: kf });
    if (State.selectedKfId !== myKfId) return; // user moved on — don't clobber
    const wx = (w && w.pos && typeof w.pos.x === 'number') ? w.pos.x : kf.pos.x;
    const wy = (w && w.pos && typeof w.pos.y === 'number') ? w.pos.y : kf.pos.y;
    const wz = (w && w.pos && typeof w.pos.z === 'number') ? w.pos.z : kf.pos.z;

    const r = await postAwait('getRecordedVehiclesAtFrame', {
        frame: kf.frame, x: wx, y: wy, z: wz,
    });
    if (State.selectedKfId !== myKfId) return;
    const list = (r && r.vehicles) || [];

    sel.innerHTML = `<option value="">${t('html.labels.lock_none')}</option>`;
    for (const v of list) {
        const opt = document.createElement('option');
        opt.value = String(v.idx);
        // Peds get a "ped: " prefix and a "(you)" tag when it's the player —
        // mirrors the entity-card UI elsewhere. Vehicles render plain.
        if (v.kind === 'ped') {
            const youTag = v.isPlayer ? ' (you)' : '';
            opt.textContent = `ped: ${v.model}${youTag} · ${v.distance.toFixed(1)}m`;
        } else {
            opt.textContent = `${v.model} · ${v.distance.toFixed(1)}m`;
        }
        sel.appendChild(opt);
    }
    sel.value = canonicalizeVehicleRef(kf.lockedVehicle);
}

CC.applyKeyframeLock = async function() {
    if (State.selectedKfId === null) return;
    const kf = State.keyframes.find(k => k.id === State.selectedKfId);
    if (!kf) return;

    const sel    = document.getElementById('sp-lock-vehicle');
    // Vehicle refs are now strings ("v:N" for main, "o:N" for overlay-layer
    // vehicles). Legacy projects store a bare number — normalize to a string
    // so equality/serialization is consistent. Lua resolveVehicleRef accepts
    // both shapes either way.
    const normalizeRef = r => (r === null || r === undefined || r === '') ? null : String(r);
    const newIdx = sel.value === '' ? null : sel.value;
    const oldIdx = normalizeRef(kf.lockedVehicle);
    if (newIdx === oldIdx) return;  // no-op

    // Two-step convert: if kf is currently locked, first ask Lua to convert
    // its stored offset back to world (using oldIdx). Then ask to convert
    // that world pos/rot to the new lock state (newIdx, or world-stay).
    let wPos = { x: kf.pos.x, y: kf.pos.y, z: kf.pos.z };
    let wRot = { x: kf.rot.x, y: kf.rot.y, z: kf.rot.z };

    if (oldIdx != null) {
        const r = await postAwait('convertKeyframeLock', {
            frame: kf.frame, pos: wPos, rot: wRot,
            lockedVehicle: null, fromVehicle: oldIdx,
        });
        if (r && r.pos) { wPos = r.pos; wRot = r.rot; }
    }

    if (newIdx != null) {
        const r = await postAwait('convertKeyframeLock', {
            frame: kf.frame, pos: wPos, rot: wRot,
            lockedVehicle: newIdx,
        });
        if (r && r.error === 'out_of_range') {
            showToast(t('toasts.vehicle_out_of_range_at_kf'), 'error');
            sel.value = oldIdx || '';
            return;
        }
        if (r && r.pos) { kf.pos = r.pos; kf.rot = r.rot; kf.lockedVehicle = newIdx; }
    } else {
        kf.pos = wPos; kf.rot = wRot;
        delete kf.lockedVehicle;
    }

    // Refresh the side-panel pos/rot inputs and re-sync to Lua + redraw.
    document.getElementById('sp-pos-x').value = kf.pos.x.toFixed(4);
    document.getElementById('sp-pos-y').value = kf.pos.y.toFixed(4);
    document.getElementById('sp-pos-z').value = kf.pos.z.toFixed(4);
    document.getElementById('sp-rot-x').value = kf.rot.x.toFixed(4);
    document.getElementById('sp-rot-y').value = kf.rot.y.toFixed(4);
    document.getElementById('sp-rot-z').value = kf.rot.z.toFixed(4);
    syncKeyframesToLua();
    renderTimeline();
};

function showSidePanel(kf) {
    hideAllViews();
    const marker = isMarkerKf(kf);
    const idx = cameraKfs().indexOf(kf) + 1;
    document.getElementById('sp-title').textContent = marker
        ? markerTitle(kf) + ' — ' + kf.frame
        : t('ui.title_keyframe', { idx: idx, frame: kf.frame });
    document.getElementById('sp-props').classList.remove('hidden');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');
    document.getElementById('sp-delete-btn').classList.remove('hidden');
    // Free-fly repositioning is a camera concept — a marker has no pose to place.
    document.getElementById('sp-pos-btn').classList.toggle('hidden', marker);
    document.getElementById('sp-pos-btn').disabled = marker;
}

function hideSidePanel() {
    State.selectedKfId = null;
    clearSelection();
    State.editingClipId = null;
    State.selectedSceneId = null;
    if (State.vehicleRecSelected) deselectVehicleRec();
    if (State.selectedOverlayId) deselectOverlayLayer();
    deselectClip();
    hideAllViews();
    document.getElementById('sp-title').textContent = t('ui.title_no_keyframe_selected');
    document.getElementById('sp-menu-view').classList.remove('hidden');
}

// ── TIMELINE RENDERING ────────────────────────────────────────────────────────
// CAMERA track holds all keyframes; position/rotation/fov merged into single CAMERA track.
const TRACKS = ['camera'];

function frameToPixel(f) { return f * State.zoom; }
function pixelToFrame(px) { return Math.round(px / State.zoom); }
function getTimelineWidth() {
    const wrap = document.getElementById('timeline-scroll-wrap');
    return Math.max(frameToPixel(totalFrames()) + 200, wrap ? wrap.clientWidth : 800);
}

function renderTimeline() {
    // Cheap, and it's the one function that runs after anything that could add
    // or remove a recording (which is what forces the anchor on).
    refreshCameraAnchorBtn();
    const width = getTimelineWidth();

    // Ruler
    const canvas = document.getElementById('ruler-canvas');
    canvas.width = width;
    drawRuler(canvas.getContext('2d'), width);

    // Track widths
    document.getElementById('tracks-container').style.width = width + 'px';

    TRACKS.forEach(trackId => {
        const track = document.getElementById(`track-${trackId}`);
        track.style.width = width + 'px';
        track.querySelectorAll('.keyframe-marker, .kf-connector').forEach(el => el.remove());

        const kfs = State.keyframes;

        // Connectors join camera keyframes only — a marker sitting between two
        // shots is an event on the path, not a stop the path bends through.
        const camKfsSorted = kfs.filter(k => !MARKER_KINDS[k.kind]);
        for (let i = 0; i < camKfsSorted.length - 1; i++) {
            const x1 = frameToPixel(camKfsSorted[i].frame);
            const x2 = frameToPixel(camKfsSorted[i+1].frame);
            const line = document.createElement('div');
            line.className = 'kf-connector';
            line.style.left  = x1 + 'px';
            line.style.width = (x2 - x1) + 'px';
            track.appendChild(line);
        }

        // Diamonds
        kfs.forEach(kf => {
            const m = document.createElement('div');
            // Kind drives the marker colour so the shot structure is readable
            // straight off the track. Older projects have no kind → 'camera'.
            m.className   = 'keyframe-marker kf-' + (kf.kind || 'camera') +
                            (kf.id === State.selectedKfId ? ' selected' : '') +
                            (kf.pendingTransition ? ' kf-armed' : '');
            m.style.left  = frameToPixel(kf.frame) + 'px';
            m.dataset.kfId = kf.id;
            // Marquee hit-testing reads these; every selectable element carries
            // the pair so one rectangle test covers all of them.
            m.dataset.selKind = 'kf';
            m.dataset.selId   = kf.id;
            if (kf.kind === 'resume') {
                m.title = 'Resumed from "' + (kf.resumeName || kf.resumeSlug || '?') + '"';
            } else if (MARKER_KINDS[kf.kind]) {
                m.title = markerTitle(kf);
            }

            if (isKfSelected(kf.id)) m.classList.add('multi-selected');

            m.addEventListener('click', (e) => {
                e.stopPropagation();
                if (e.ctrlKey || e.metaKey) { toggleKfSelection(kf.id); return; }
                if (e.shiftKey)             { extendKfSelection(kf.id);  return; }
                State.selection = [{ kind: 'kf', id: kf.id }];
                selectKeyframe(kf.id);
            });
            m.addEventListener('mousedown', (e) => { e.stopPropagation(); startDrag(e, kf.id); });
            track.appendChild(m);
        });
    });

    // In/Out point markers
    const tc = document.getElementById('tracks-container');
    tc.querySelectorAll('.io-marker, .io-shade').forEach(el => el.remove());
    if (State.inPoint != null || State.outPoint != null) {
        const inX  = State.inPoint  != null ? frameToPixel(State.inPoint)  : 0;
        const outX = State.outPoint != null ? frameToPixel(State.outPoint) : width;
        // Shaded regions outside in/out
        if (State.inPoint != null && inX > 0) {
            const s = document.createElement('div'); s.className = 'io-shade';
            s.style.cssText = `left:0;width:${inX}px`; tc.appendChild(s);
        }
        if (State.outPoint != null && outX < width) {
            const s = document.createElement('div'); s.className = 'io-shade';
            s.style.cssText = `left:${outX}px;width:${width - outX}px`; tc.appendChild(s);
        }
        // Marker lines
        if (State.inPoint != null) {
            const m = document.createElement('div'); m.className = 'io-marker io-in';
            m.style.left = inX + 'px'; tc.appendChild(m);
        }
        if (State.outPoint != null) {
            const m = document.createElement('div'); m.className = 'io-marker io-out';
            m.style.left = outX + 'px'; tc.appendChild(m);
        }
    }

    updatePlayheadPosition();
    renderTextTrack(width);
    renderVehicleTrack(width);
    renderOverlayTracks(width);
    updateZoomBar();
}

function renderVehicleTrack(width) {
    const track = document.getElementById('track-vehicle');
    if (!track) return;
    track.style.width = width + 'px';
    track.querySelectorAll('.veh-rec-bar, .veh-rec-label, .veh-rec-loading').forEach(el => el.remove());

    // Show loading placeholder while recording data is arriving. vehicleRecStart
    // and vehicleRecEnd are restored from project meta before the latent event
    // carrying the frame payload arrives, so we can size the loader to the same
    // footprint the finished bar will occupy instead of spanning the whole track.
    if (State.recLoading && !State.vehicleRecording) {
        const loader = document.createElement('div');
        loader.className = 'veh-rec-loading';
        const start    = State.vehicleRecStart || 0;
        const end      = State.vehicleRecEnd   || 0;
        const barWidth = Math.max(8, frameToPixel(end - start));
        loader.style.left  = frameToPixel(start) + 'px';
        loader.style.right = 'auto';
        loader.style.width = barWidth + 'px';
        loader.innerHTML = '<span class="veh-rec-loading-label">Loading recording...</span>';
        track.appendChild(loader);
        return;
    }

    if (!State.vehicleRecording) return;

    const clips = (State.vehicleRecClips && State.vehicleRecClips.length)
        ? State.vehicleRecClips
        : [{ id: 1, startFrame: State.vehicleRecStart, endFrame: State.vehicleRecEnd, trimInFrame: State.vehicleRecTrimIn }];

    const vc = State.vehicleRecording.count    || 0;
    const pc = State.vehicleRecording.pedCount || 0;
    let labelKey;
    if (vc > 0 && pc > 0) labelKey = 'ui.veh_ped_rec_label';
    else if (vc > 0)      labelKey = 'ui.veh_rec_label';
    else                  labelKey = 'ui.ped_rec_label';
    const multi = clips.length > 1;

    clips.forEach((clip, idx) => {
        const x        = frameToPixel(clip.startFrame);
        const barWidth = Math.max(8, frameToPixel(clip.endFrame - clip.startFrame));

        const sel = State.vehicleRecSelected
            && (State.selectedVehClipIdx === idx || State.selectedVehClipIdx == null);
        const bar = document.createElement('div');
        bar.className = 'veh-rec-bar' + (sel ? ' selected' : '')
            + (isSelected('veh', idx) ? ' multi-selected' : '');
        bar.style.left  = x + 'px';
        bar.style.width = barWidth + 'px';
        bar.dataset.selKind = 'veh';
        bar.dataset.selId   = idx;

        // Left resize handle
        const hl = document.createElement('div');
        hl.className = 'veh-rec-handle-l';
        hl.addEventListener('mousedown', (e) => {
            e.stopPropagation();
            if (State.cutMode) return cutAtEvent(e, 'vehicle', idx);
            startVehicleRecClipDrag(e, idx, 'resizeL');
        });
        bar.appendChild(hl);

        // Label
        const label = document.createElement('span');
        label.className = 'veh-rec-label';
        const shownDur = ((clip.endFrame - clip.startFrame) / State.fps).toFixed(1);
        const base = t(labelKey, { count: vc || pc, vehicles: vc, peds: pc, duration: shownDur });
        label.textContent = multi ? `${base} · ${idx + 1}/${clips.length}` : base;
        bar.appendChild(label);

        // Right resize handle
        const hr = document.createElement('div');
        hr.className = 'veh-rec-handle-r';
        hr.addEventListener('mousedown', (e) => {
            e.stopPropagation();
            if (State.cutMode) return cutAtEvent(e, 'vehicle', idx);
            startVehicleRecClipDrag(e, idx, 'resizeR');
        });
        bar.appendChild(hr);

        bar.addEventListener('mousedown', (e) => {
            if (e.target === hl || e.target === hr) return;
            e.stopPropagation();
            if (State.cutMode) return cutAtEvent(e, 'vehicle', idx);
            selectVehicleRec();
            startVehicleRecClipDrag(e, idx, 'move');
        });

        track.appendChild(bar);
    });
}

// ── CUT TOOL (razor) ──────────────────────────────────────────────────────
// Stored as metadata only: the recording files never change — a "cut" just
// splits a clip's {start,end,trimIn} window into two over the same source.
CC.toggleCutMode = function() {
    State.cutMode = !State.cutMode;
    const btn = document.getElementById('tb-cut-btn');
    if (btn) btn.classList.toggle('active', State.cutMode);
    const area = document.getElementById('timeline-area');
    if (area) area.classList.toggle('cut-mode', State.cutMode);
    if (!State.cutMode) hideCutLine();
    showToast(State.cutMode
        ? 'Cut tool ON — click a recording or overlay clip to split it'
        : 'Cut tool OFF');
};

// Cut-mode hover guide: a dashed vertical line marking the exact frame the razor
// will split, shown only while hovering a cuttable bar so the seam position is
// clear before committing. Positioned in tracks-container space (same as the
// bars + playhead) so it scrolls/zooms with them.
function hideCutLine() {
    const line = document.getElementById('cut-line');
    if (line) line.style.display = 'none';
}

document.addEventListener('mousemove', (e) => {
    if (!State.cutMode) return;                       // disarm hides it explicitly
    const line = document.getElementById('cut-line');
    if (!line) return;
    const bar = e.target.closest && e.target.closest('.veh-rec-bar, .overlay-rec-bar');
    const tc  = document.getElementById('tracks-container');
    if (!bar || !tc) { line.style.display = 'none'; return; }
    const frame = Math.max(0, pixelToFrame(e.clientX - tc.getBoundingClientRect().left));
    line.style.left    = frameToPixel(frame) + 'px';
    line.style.display = 'block';
});

// Translate a click on a timeline bar into the absolute timeline frame under
// the cursor, then split the relevant clip there.
function cutAtEvent(e, kind, idx) {
    const track = document.getElementById(kind === 'vehicle' ? 'track-vehicle' : 'track-overlay');
    if (!track) return;
    const frame = Math.max(0, pixelToFrame(e.clientX - track.getBoundingClientRect().left));
    const ok = (kind === 'vehicle')
        ? splitVehicleRecClip(idx, frame)
        : splitOverlayLayer(idx + 1, frame);
    // One cut per arm — disarm the razor after a successful split so the next
    // click selects/drags as usual (matches Premiere's razor-then-pointer flow).
    if (ok && State.cutMode) CC.toggleCutMode();
}

// Split main-recording clip `idx` at timeline `frame` into two adjacent clips
// over the same source. trimIn of the right piece advances by how far into the
// left piece the cut fell, so the source plays continuously across the seam.
function splitVehicleRecClip(idx, frame) {
    const c = State.vehicleRecClips[idx];
    if (!c || frame <= c.startFrame || frame >= c.endFrame) {
        showToast(t('toasts.cut_point_outside_clip'), 'error');
        return false;
    }
    const before = JSON.parse(JSON.stringify(State.vehicleRecClips));
    const right = {
        id:          0,
        startFrame:  frame,
        endFrame:    c.endFrame,
        trimInFrame: c.trimInFrame + (frame - c.startFrame),
    };
    c.endFrame = frame;
    State.vehicleRecClips.splice(idx + 1, 0, right);
    State.vehicleRecClips.forEach((cc, i) => { cc.id = i + 1; });
    pushUndoVehCut(before, JSON.parse(JSON.stringify(State.vehicleRecClips)));
    pushVehicleRecClips();
    renderTimeline();
    showToast(t('toasts.clip_split', { count: State.vehicleRecClips.length }));
    return true;
}

// Send the authoritative clip list to Lua + persist to the project file.
function pushVehicleRecClips() {
    post('setVehicleRecClips', {
        clips: State.vehicleRecClips.map(c => ({
            startFrame:  c.startFrame,
            endFrame:    c.endFrame,
            trimInFrame: c.trimInFrame,
        })),
    });
    autoSaveProject();
}

// Per-clip drag/trim — same envelope math as the old single-bar drag, scoped
// to one clip of vehicleRecClips. Neighbours are left untouched (the cut tool
// produces adjacent clips; gaps/overlaps from dragging are allowed).
function startVehicleRecClipDrag(e, clipIdx, type) {
    // Same rule as the other clip types: group-move, per-item trim.
    if (type === 'move' && isSelected('veh', clipIdx) && selectionCount() > 1) {
        startGroupDrag(e); return;
    }
    const clip = State.vehicleRecClips[clipIdx];
    if (!clip || !State.vehicleRecording) return;
    e.preventDefault();
    State.selectedVehClipIdx = clipIdx;

    State.draggingVehClip = {
        clipIdx, type,
        startX:     e.clientX,
        origStart:  clip.startFrame,
        origEnd:    clip.endFrame,
        origTrimIn: clip.trimInFrame,
    };
    const totalRec = State.vehicleRecording.totalFrames;

    const onMove = (ev) => {
        const dv = State.draggingVehClip;
        if (!dv) return;
        const df    = Math.round((ev.clientX - dv.startX) / State.zoom);
        const total = totalFrames();

        if (dv.type === 'move') {
            const dur      = dv.origEnd - dv.origStart;
            const newStart = Math.max(0, Math.min(total - dur, dv.origStart + df));
            clip.startFrame  = newStart;
            clip.endFrame    = newStart + dur;
            clip.trimInFrame = dv.origTrimIn;
        } else if (dv.type === 'resizeL') {
            const maxDf = Math.min(dv.origEnd - dv.origStart - 1, totalRec - 1 - dv.origTrimIn);
            const clampedDf = Math.max(-dv.origTrimIn, Math.min(maxDf, df));
            clip.startFrame  = Math.max(0, dv.origStart + clampedDf);
            clip.trimInFrame = Math.max(0, dv.origTrimIn + clampedDf);
        } else if (dv.type === 'resizeR') {
            const maxEnd = dv.origStart + (totalRec - dv.origTrimIn);
            const newEnd = Math.max(dv.origStart + 1, Math.min(Math.min(total, maxEnd), dv.origEnd + df));
            clip.endFrame    = newEnd;
            clip.trimInFrame = dv.origTrimIn;
        }
        renderVehicleTrack(getTimelineWidth());
    };

    const onUp = () => {
        State.draggingVehClip = null;
        pushVehicleRecClips();
        renderVehicleTrack(getTimelineWidth());
        window.removeEventListener('mousemove', onMove);
        window.removeEventListener('mouseup', onUp);
    };
    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
}

// Split an overlay layer at timeline `frame`. Lua owns the frame data, so it
// performs the authoritative split (cloning the layer, sharing source frames)
// AND persists the recording file. We mirror the split locally for an instant
// UI update so the user sees two bars without waiting for the round-trip.
// Perform the overlay split (Lua cut + local mirror) WITHOUT recording an undo
// step. Shared by the user-initiated cut and by redo. Returns false if the
// frame doesn't fall inside the layer.
function performOverlaySplit(layerIdx, frame) {
    const layer = State.overlayLayers[layerIdx - 1];
    if (!layer || frame <= layer.startFrame || frame >= layer.endFrame) return false;
    post('cutOverlayLayer', { layerIdx, atFrame: frame });

    const right = Object.assign({}, layer, {
        startFrame:  frame,
        endFrame:    layer.endFrame,
        trimInFrame: layer.trimInFrame + (frame - layer.startFrame),
    });
    layer.endFrame = frame;
    State.overlayLayers.splice(layerIdx, 0, right);
    State.overlayLayers.forEach((l, i) => { l.id = i + 1; });
    State.selectedOverlayId = null;
    renderTimeline();
    // Refresh project metadata too: Lua rebuilds overlayLayerTimings from its
    // (now-split) overlayLayers, so the load-time timing merge can't revert the
    // left piece's new end. The heavy frame file is saved by Lua's cut handler.
    autoSaveProject();
    return true;
}

function splitOverlayLayer(layerIdx, frame) {
    const layer = State.overlayLayers[layerIdx - 1];
    if (!layer || frame <= layer.startFrame || frame >= layer.endFrame) {
        showToast(t('toasts.cut_point_outside_clip'), 'error');
        return false;
    }
    performOverlaySplit(layerIdx, frame);
    pushUndoOverlayCut(layerIdx, frame);
    showToast(t('toasts.overlay_split', { count: State.overlayLayers.length }));
    return true;
}

// Reverse an overlay cut: merge the right sibling back into the left piece.
// Lua performs the authoritative merge (and tears down the twin's entities);
// we mirror it locally for an instant UI update without a round-trip.
function undoOverlayCutLocal(layerIdx) {
    const left = State.overlayLayers[layerIdx - 1];
    const twin = State.overlayLayers[layerIdx];   // 0-based index == layerIdx
    if (left && twin) {
        left.endFrame = twin.endFrame;
        State.overlayLayers.splice(layerIdx, 1);
        State.overlayLayers.forEach((l, i) => { l.id = i + 1; });
    }
    State.selectedOverlayId = null;
    post('undoOverlayCut', { layerIdx });
    renderTimeline();
    autoSaveProject();
}

function selectVehicleRec() {
    // Deselect any keyframe, text clip, or overlay layer first so only one
    // timeline element ever appears selected at a time.
    if (State.selectedKfId !== null || State.selectedClipId !== null) {
        State.selectedKfId   = null;
        State.selectedClipId = null;
        State.editingClipId  = null;
    }
    if (State.selectedOverlayId) deselectOverlayLayer();
    State.vehicleRecSelected = true;

    // Show recording properties panel
    hideAllViews();
    document.getElementById('sp-rec-props-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('ui.title_recording');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');

    // Populate info
    if (State.vehicleRecording) {
        document.getElementById('rp-duration').textContent = State.vehicleRecording.duration.toFixed(1) + 's';
    }
    const vehCount = State.recEntityList ? State.recEntityList.filter(e => e.type === 'vehicle').length : 0;
    const pedCount = State.recEntityList ? State.recEntityList.filter(e => e.type === 'ped').length : 0;
    document.getElementById('rp-veh-count').textContent = vehCount;
    document.getElementById('rp-ped-count').textContent = pedCount;
    document.getElementById('rp-motionblur').checked = false;

    renderRecEntityList();
    renderVehicleTrack(getTimelineWidth());
    renderTimeline();
}

function deselectVehicleRec() {
    if (!State.vehicleRecSelected) return;
    State.vehicleRecSelected = false;
    State.selectedVehClipIdx = null;
    renderVehicleTrack(getTimelineWidth());
}

// Selecting an overlay layer block on the timeline opens a side panel mirror
// of the recording-props view: shows model + duration + active range and a
// delete button. Click anywhere else to deselect.
function selectOverlayLayer(layerIdx) {
    const layer = State.overlayLayers[layerIdx - 1];
    if (!layer) return;

    // Clear any other selection
    if (State.selectedKfId !== null || State.selectedClipId !== null) {
        State.selectedKfId   = null;
        State.selectedClipId = null;
        State.editingClipId  = null;
    }
    if (State.vehicleRecSelected) deselectVehicleRec();

    State.selectedOverlayId = layer.id;

    hideAllViews();
    document.getElementById('sp-overlay-props-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = layer.name || `Layer ${layer.id}`;
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');

    // Populate fields
    const dur     = (layer.totalFrames / State.fps).toFixed(1) + 's';
    const range   = ((layer.endFrame - layer.startFrame) / State.fps).toFixed(1) + 's';
    const tStart  = (layer.startFrame / State.fps).toFixed(1) + 's';
    document.getElementById('op-name').textContent     = layer.name || `Layer ${layer.id}`;
    document.getElementById('op-model').textContent    = layer.model || '—';
    document.getElementById('op-duration').textContent = dur;
    document.getElementById('op-range').textContent    = range;
    document.getElementById('op-start').textContent    = tStart;

    renderTimeline();
}

function deselectOverlayLayer() {
    if (!State.selectedOverlayId) return;
    State.selectedOverlayId = null;
    renderOverlayTracks(getTimelineWidth());
}

CC.deleteSelectedOverlay = async function() {
    const id = State.selectedOverlayId;
    if (!id) return;
    if (!await nuiConfirm(t('ui.confirm_delete_recording_title'), t('ui.confirm_delete_recording_message'))) return;
    CC.deleteOverlayLayer(id);
    State.selectedOverlayId = null;
    hideSidePanel();
};

function startVehicleRecDrag(e, type) {
    if (!State.vehicleRecording) return;
    e.preventDefault();

    State.draggingVehRec = {
        type,
        startX:      e.clientX,
        origStart:   State.vehicleRecStart,
        origEnd:     State.vehicleRecEnd,
        origTrimIn:  State.vehicleRecTrimIn,
    };

    const totalRec = State.vehicleRecording.totalFrames; // max frames in the recording

    const onMove = (ev) => {
        const dv = State.draggingVehRec;
        if (!dv) return;

        const dx = ev.clientX - dv.startX;
        const df = Math.round(dx / State.zoom);
        const total = totalFrames();

        if (dv.type === 'move') {
            // Shift entire block — trimIn stays the same (same portion of recording)
            const dur      = dv.origEnd - dv.origStart;
            const newStart = Math.max(0, Math.min(total - dur, dv.origStart + df));
            State.vehicleRecStart  = newStart;
            State.vehicleRecEnd    = newStart + dur;
            State.vehicleRecTrimIn = dv.origTrimIn; // unchanged
        } else if (dv.type === 'resizeL') {
            // Trim front: start + trimIn both advance by the same delta.
            // Min delta: -origTrimIn          (can't go before recording start)
            // Max delta: origEnd-origStart-1  (must keep at least 1 frame visible)
            //            also capped so trimIn never exceeds totalRec-1
            const maxDf = Math.min(
                dv.origEnd - dv.origStart - 1,   // keep ≥1 frame
                totalRec - 1 - dv.origTrimIn      // can't push trimIn past recording end
            );
            const clampedDf = Math.max(-dv.origTrimIn, Math.min(maxDf, df));
            State.vehicleRecStart  = Math.max(0, dv.origStart + clampedDf);
            State.vehicleRecTrimIn = Math.max(0, dv.origTrimIn + clampedDf);
        } else if (dv.type === 'resizeR') {
            // Trim end: end moves left — trimIn stays the same, duration shrinks
            // Constraint: can't expand past (totalRec - trimIn) frames, must keep at least 1 frame
            const maxEnd = dv.origStart + (totalRec - dv.origTrimIn);
            const newEnd = Math.max(dv.origStart + 1, Math.min(Math.min(total, maxEnd), dv.origEnd + df));
            State.vehicleRecEnd    = newEnd;
            State.vehicleRecTrimIn = dv.origTrimIn; // unchanged
        }

        renderVehicleTrack(getTimelineWidth());
    };

    const onUp = () => {
        State.draggingVehRec = null;
        post('setVehicleRecTiming', {
            startFrame:  State.vehicleRecStart,
            endFrame:    State.vehicleRecEnd,
            trimInFrame: State.vehicleRecTrimIn,
        });
        renderVehicleTrack(getTimelineWidth());
        window.removeEventListener('mousemove', onMove);
        window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
}

// ── OVERLAY LAYERS ───────────────────────────────────────────────────────────

function onOverlayLayersLoaded(d) {
    State.overlayLayers = (d.layers || []).map(l => ({
        id:          l.id,
        name:        l.name,
        model:       l.model,
        duration:    l.duration,
        totalFrames: l.totalFrames,
        startFrame:  l.startFrame  !== undefined ? l.startFrame  : 0,
        endFrame:    l.endFrame    !== undefined ? l.endFrame    : l.totalFrames,
        trimInFrame: l.trimInFrame !== undefined ? l.trimInFrame : 0,
    }));

    // Auto-extend timeline if any overlay goes past current duration
    for (const ol of State.overlayLayers) {
        const endSec = Math.ceil(ol.endFrame / State.fps);
        if (endSec > State.durationSec) {
            State.durationSec = endSec;
            document.getElementById('duration-input').value = endSec;
            syncKeyframesToLua();
        }
    }

    renderTimeline();
    if (State.overlayLayers.length > 0) {
        showToast(t('toasts.overlay_layers_loaded', { count: State.overlayLayers.length }));
    }
}

CC.startSoloRecord = function() {
    // Same project gate as the radius recorder — solo recordings are persisted
    // against the project slug so without one they'd silently overwrite the
    // last project's recording when re-opened.
    if (!State.currentProject) {
        showToast(t('errors.no_project_for_recording') || 'Open or create a project first', 'error');
        return;
    }
    post('startSoloRecord');
};

CC.deleteOverlayLayer = function(layerIdx) {
    post('deleteOverlayLayer', { layerIdx });
    State.overlayLayers.splice(layerIdx - 1, 1);
    // Re-index
    State.overlayLayers.forEach((l, i) => { l.id = i + 1; });
    State.selectedOverlayId = null;
    renderTimeline();
    // Persist the deletion to the recording file. Autosave only writes
    // metadata, so without this the layer would re-appear on next load.
    if (State.currentProject) post('saveProjectWithRecordings', getProjectData());
};

function renderOverlayTracks(width) {
    // Single fixed OVERLAY row that hosts every layer as its own clip-style
    // bar. Two display modes:
    //   • Selection mode (a layer is selected): selected = front (full color
    //     on top); others overlapping it = faded; others fully inside it =
    //     ghost (striped outline above the front so they stay clickable).
    //   • Default mode (nothing selected): "container" layers — those that
    //     fully cover at least one shorter layer in time — fade behind so
    //     the shorter clips stay readable on top in full color. No ghost
    //     stripes here, since nothing is being explicitly edited.
    const track = document.getElementById('track-overlay');
    if (!track) return;
    track.style.width = width + 'px';
    track.querySelectorAll('.overlay-rec-bar, .veh-rec-loading').forEach(el => el.remove());

    const overlaps = (a, b) => a && b
        && a.startFrame < b.endFrame
        && b.startFrame < a.endFrame;
    const fullyCovered = (a, b) => a && b
        && a.startFrame >= b.startFrame
        && a.endFrame   <= b.endFrame;

    const selectedIdx = State.selectedOverlayId
        ? State.overlayLayers.findIndex(l => l.id === State.selectedOverlayId)
        : -1;
    const selectedLayer = selectedIdx >= 0 ? State.overlayLayers[selectedIdx] : null;

    State.overlayLayers.forEach((layer, idx) => {
        const layerIdx = idx + 1; // 1-based to match Lua

        let isFront = false, isFaded = false, isGhost = false;
        if (selectedLayer) {
            isFront = layer.id === selectedLayer.id;
            isFaded = !isFront && overlaps(layer, selectedLayer);
            isGhost = isFaded && fullyCovered(layer, selectedLayer);
        } else {
            // Default mode — fade only when this layer fully contains another
            // shorter layer. Shorter clips on top stay full color, no ghost.
            isFaded = State.overlayLayers.some((other, oIdx) =>
                oIdx !== idx && fullyCovered(other, layer)
            );
        }

        // Loading placeholder — same striped animation used on the main vehicle track.
        if (layer.loading) {
            const loader = document.createElement('div');
            loader.className = 'veh-rec-loading';
            loader.style.left  = frameToPixel(layer.startFrame) + 'px';
            loader.style.right = 'auto';
            loader.style.width = Math.max(8, frameToPixel((layer.endFrame || layer.startFrame + State.fps) - layer.startFrame)) + 'px';
            loader.innerHTML = '<span class="veh-rec-loading-label">Loading layer...</span>';
            track.appendChild(loader);
            return;
        }

        // Render the block
        const x        = frameToPixel(layer.startFrame);
        const barWidth = Math.max(8, frameToPixel(layer.endFrame - layer.startFrame));

        const bar = document.createElement('div');
        bar.className = 'overlay-rec-bar'
            + (State.selectedOverlayId === layer.id ? ' selected' : '')
            + (isSelected('overlay', layerIdx) ? ' multi-selected' : '')
            + (isFaded && !isGhost ? ' faded' : '')
            + (isGhost ? ' ghost' : '');
        bar.style.left  = x + 'px';
        bar.style.width = barWidth + 'px';
        bar.dataset.selKind = 'overlay';
        bar.dataset.selId   = layerIdx;
        // Stacking: ghost > front > full-color > faded. In default mode (no
        // selection) ghost is unused, but we still need full-color clips to
        // render above their faded containers.
        if (isGhost)      bar.style.zIndex = '6';
        else if (isFront) bar.style.zIndex = '5';
        else if (isFaded) bar.style.zIndex = '1';
        else              bar.style.zIndex = '4';

        // Left resize handle
        const hl = document.createElement('div');
        hl.className = 'overlay-rec-handle-l';
        hl.addEventListener('mousedown', (e) => { e.stopPropagation(); if (State.cutMode) return cutAtEvent(e, 'overlay', layerIdx - 1); startOverlayDrag(e, layerIdx, 'resizeL'); });
        bar.appendChild(hl);

        // Label
        const lbl = document.createElement('span');
        lbl.className = 'overlay-rec-label';
        const shownDur = ((layer.endFrame - layer.startFrame) / State.fps).toFixed(1);
        lbl.textContent = `${layer.name || layer.model} · ${shownDur}s`;
        bar.appendChild(lbl);

        // Right resize handle
        const hr = document.createElement('div');
        hr.className = 'overlay-rec-handle-r';
        hr.addEventListener('mousedown', (e) => { e.stopPropagation(); if (State.cutMode) return cutAtEvent(e, 'overlay', layerIdx - 1); startOverlayDrag(e, layerIdx, 'resizeR'); });
        bar.appendChild(hr);

        bar.addEventListener('mousedown', (e) => {
            if (e.target === hl || e.target === hr) return;
            e.stopPropagation();
            if (State.cutMode) return cutAtEvent(e, 'overlay', layerIdx - 1);
            selectOverlayLayer(layerIdx);
            startOverlayDrag(e, layerIdx, 'move');
        });

        track.appendChild(bar);
    });
}

function startOverlayDrag(e, layerIdx, type) {
    const layer = State.overlayLayers[layerIdx - 1];
    if (!layer) return;
    e.preventDefault();

    // Same rule as text clips: group-move, per-item trim.
    if (type === 'move' && isSelected('overlay', layerIdx) && selectionCount() > 1) {
        startGroupDrag(e); return;
    }

    State.draggingOverlay = {
        layerIdx,
        type,
        startX:     e.clientX,
        origStart:  layer.startFrame,
        origEnd:    layer.endFrame,
        origTrimIn: layer.trimInFrame,
    };

    const totalRec = layer.totalFrames;

    const onMove = (ev) => {
        const dv = State.draggingOverlay;
        if (!dv) return;
        const dx = ev.clientX - dv.startX;
        const df = Math.round(dx / State.zoom);
        const total = totalFrames();

        if (dv.type === 'move') {
            const dur      = dv.origEnd - dv.origStart;
            const newStart = Math.max(0, Math.min(total - dur, dv.origStart + df));
            layer.startFrame  = newStart;
            layer.endFrame    = newStart + dur;
            layer.trimInFrame = dv.origTrimIn;
        } else if (dv.type === 'resizeL') {
            const maxDf = Math.min(dv.origEnd - dv.origStart - 1, totalRec - 1 - dv.origTrimIn);
            const clampedDf = Math.max(-dv.origTrimIn, Math.min(maxDf, df));
            layer.startFrame  = Math.max(0, dv.origStart + clampedDf);
            layer.trimInFrame = Math.max(0, dv.origTrimIn + clampedDf);
        } else if (dv.type === 'resizeR') {
            const maxEnd = dv.origStart + (totalRec - dv.origTrimIn);
            const newEnd = Math.max(dv.origStart + 1, Math.min(Math.min(total, maxEnd), dv.origEnd + df));
            layer.endFrame    = newEnd;
            layer.trimInFrame = dv.origTrimIn;
        }

        renderTimeline();
    };

    const onUp = () => {
        State.draggingOverlay = null;
        post('setOverlayTiming', {
            layerIdx:    layerIdx,
            startFrame:  layer.startFrame,
            endFrame:    layer.endFrame,
            trimInFrame: layer.trimInFrame,
        });
        autoSaveProject();
        renderTimeline();
        window.removeEventListener('mousemove', onMove);
        window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
}

function renderTextTrack(width) {
    const track = document.getElementById('track-text');
    if (!track) return;
    track.style.width = width + 'px';
    track.querySelectorAll('.text-clip').forEach(el => el.remove());

    // Same two-mode fade/ghost logic as the overlay track:
    //   • Selection mode: selected clip = front; partial overlaps = faded;
    //     fully-covered = ghost (striped outline above front).
    //   • Default mode (nothing selected): clips that fully contain another
    //     shorter clip fade so the shorter ones show on top. No ghost.
    const overlaps = (a, b) => a && b
        && a.startFrame < b.endFrame
        && b.startFrame < a.endFrame;
    const fullyCovered = (a, b) => a && b
        && a.startFrame >= b.startFrame
        && a.endFrame   <= b.endFrame;

    const selectedClipIdx = State.selectedClipId !== null
        ? State.textClips.findIndex(c => c.id === State.selectedClipId)
        : -1;
    const selectedClip = selectedClipIdx >= 0 ? State.textClips[selectedClipIdx] : null;

    State.textClips.forEach((clip, idx) => {
        const textObj  = State.textObjects.find(o => o.id === clip.textId);
        const label    = textObj ? textObj.text : t('text3d.default_label', { id: clip.textId });
        const x        = frameToPixel(clip.startFrame);
        const clipWidth = Math.max(8, frameToPixel(clip.endFrame - clip.startFrame));

        let isFront = false, isFaded = false, isGhost = false;
        if (selectedClip) {
            isFront = clip.id === selectedClip.id;
            isFaded = !isFront && overlaps(clip, selectedClip);
            isGhost = isFaded && fullyCovered(clip, selectedClip);
        } else {
            isFaded = State.textClips.some((other, oIdx) =>
                oIdx !== idx && fullyCovered(other, clip)
            );
        }

        const el = document.createElement('div');
        el.className = 'text-clip'
            + (clip.id === State.selectedClipId ? ' selected' : '')
            + (isSelected('text', clip.id) ? ' multi-selected' : '')
            + (isFaded && !isGhost ? ' faded' : '')
            + (isGhost ? ' ghost' : '');
        el.style.left  = x + 'px';
        el.style.width = clipWidth + 'px';
        el.dataset.selKind = 'text';
        el.dataset.selId   = clip.id;
        if (isGhost)      el.style.zIndex = '6';
        else if (isFront) el.style.zIndex = '5';
        else if (isFaded) el.style.zIndex = '1';
        else              el.style.zIndex = '4';
        el.dataset.clipId = clip.id;

        // Left resize handle
        const hl = document.createElement('div');
        hl.className = 'text-clip-handle-l';
        hl.addEventListener('mousedown', (e) => { e.stopPropagation(); startClipDrag(e, clip.id, 'resizeL'); });
        el.appendChild(hl);

        // Label
        const lbl = document.createElement('span');
        lbl.className = 'text-clip-label';
        lbl.textContent = label;
        el.appendChild(lbl);

        // Right resize handle
        const hr = document.createElement('div');
        hr.className = 'text-clip-handle-r';
        hr.addEventListener('mousedown', (e) => { e.stopPropagation(); startClipDrag(e, clip.id, 'resizeR'); });
        el.appendChild(hr);

        el.addEventListener('mousedown', (e) => {
            if (e.target === hl || e.target === hr) return;
            e.stopPropagation();
            selectClip(clip.id);
            startClipDrag(e, clip.id, 'move');
        });

        track.appendChild(el);
    });
}

function startClipDrag(e, clipId, type) {
    const clip = State.textClips.find(c => c.id === clipId);
    if (!clip) return;
    e.preventDefault();

    // Moving a clip that's part of a multi-selection drags the whole set.
    // Resize handles are deliberately excluded — trimming is per-clip.
    if (type === 'move' && isSelected('text', clipId) && selectionCount() > 1) {
        startGroupDrag(e); return;
    }

    State.draggingClip = {
        clipId,
        type,
        startX:    e.clientX,
        origStart: clip.startFrame,
        origEnd:   clip.endFrame,
    };

    const onMove = (ev) => {
        const dc = State.draggingClip;
        if (!dc) return;
        const c = State.textClips.find(c => c.id === dc.clipId);
        if (!c) return;

        const dx = ev.clientX - dc.startX;
        const df = Math.round(dx / State.zoom);
        const total = totalFrames();

        if (dc.type === 'move') {
            const dur = dc.origEnd - dc.origStart;
            const newStart = Math.max(0, Math.min(total - dur, dc.origStart + df));
            c.startFrame = newStart;
            c.endFrame   = newStart + dur;
        } else if (dc.type === 'resizeL') {
            c.startFrame = Math.max(0, Math.min(dc.origEnd - 1, dc.origStart + df));
        } else if (dc.type === 'resizeR') {
            c.endFrame = Math.max(dc.origStart + 1, Math.min(total, dc.origEnd + df));
        }
        renderTextTrack(getTimelineWidth());
    };

    const onUp = () => {
        State.draggingClip = null;
        syncTextToLua();
        renderTextTrack(getTimelineWidth());
        window.removeEventListener('mousemove', onMove);
        window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
}

function selectClip(clipId) {
    if (State.selectedKfId !== null || selectionCount()) { State.selectedKfId = null; clearSelection(); renderTimeline(); }
    if (State.vehicleRecSelected) deselectVehicleRec();
    State.selectedClipId = clipId;
    State.editingClipId  = clipId;
    const clip    = State.textClips.find(c => c.id === clipId);
    const textObj = clip ? State.textObjects.find(o => o.id === clip.textId) : null;
    State.editingKind = textObj ? (textObj.kind || (textObj.imageUrl ? 'image' : 'text')) : 'text';

    // Show text panel in edit mode
    document.getElementById('sp-menu-view').classList.add('hidden');
    document.getElementById('sp-world-view').classList.add('hidden');
    document.getElementById('sp-interp-view').classList.add('hidden');
    document.getElementById('sp-record-view').classList.add('hidden');
    document.getElementById('sp-props').classList.add('hidden');
    document.getElementById('sp-text-view').classList.remove('hidden');
    document.getElementById('tv-chooser').classList.add('hidden');
    document.getElementById('tv-fields').classList.remove('hidden');
    document.getElementById('tv-create-mode').classList.add('hidden');
    document.getElementById('tv-edit-mode').classList.remove('hidden');
    document.getElementById('tv-lock-section').classList.remove('hidden');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');
    document.getElementById('sp-delete-btn').classList.add('hidden');
    document.getElementById('sp-delete-clip-btn').classList.remove('hidden');
    document.getElementById('sp-pos-btn').classList.add('hidden');
    document.getElementById('sp-title').textContent = t('text3d.title_edit');

    // Populate form from textObj
    if (textObj) {
        document.getElementById('tv-text').value      = textObj.text || '';
        document.getElementById('tv-image-url').value = textObj.imageUrl || '';
        State.imageAspect = textObj.aspect || 1.0;
        { const _st = document.getElementById('tv-image-status');
          if (_st) _st.textContent = textObj.imageUrl
              ? `Image set (aspect ${(textObj.aspect || 1).toFixed(2)}). Use the Size field to scale.`
              : IMAGE_HINT_DEFAULT; }
        document.getElementById('tv-font').value      = textObj.font || 'Arial';
        document.getElementById('tv-color').value     = textObj.color || '#ffffff';
        document.getElementById('tv-size').value      = textObj.size || 4;
        document.getElementById('tv-anim').value      = textObj.animation || 'fadeSlide';
        document.getElementById('tv-anim-in').value   = textObj.animIn  || 15;
        document.getElementById('tv-anim-out').value  = textObj.animOut || 15;
        State.shadowEnabled = !!textObj.shadow;
        const sBtn = document.getElementById('tv-shadow-btn');
        sBtn.textContent = State.shadowEnabled ? t('ui.on') : t('ui.off');
        sBtn.classList.toggle('active', State.shadowEnabled);
        State.glowEnabled = !!textObj.glow;
        const gBtn = document.getElementById('tv-glow-btn');
        gBtn.textContent = State.glowEnabled ? t('ui.on') : t('ui.off');
        gBtn.classList.toggle('active', State.glowEnabled);

        State.outlineEnabled = !!textObj.outline;
        const oBtn = document.getElementById('tv-outline-btn');
        if (oBtn) {
            oBtn.textContent = State.outlineEnabled ? t('ui.on') : t('ui.off');
            oBtn.classList.toggle('active', State.outlineEnabled);
        }
        document.getElementById('tv-outline-color').value = textObj.outlineColor || '#000000';
        document.getElementById('tv-outline-width').value = textObj.outlineWidth || 2;

        State.colorShiftEnabled = !!textObj.colorShift;
        const cBtn = document.getElementById('tv-chroma-btn');
        if (cBtn) {
            cBtn.textContent = State.colorShiftEnabled ? t('ui.on') : t('ui.off');
            cBtn.classList.toggle('active', State.colorShiftEnabled);
        }
        State.colorShiftAdvanced = !!textObj.colorShiftAdvanced;
        const cAdv = document.getElementById('tv-chroma-adv-btn');
        if (cAdv) {
            cAdv.textContent = State.colorShiftAdvanced ? t('ui.on') : t('ui.off');
            cAdv.classList.toggle('active', State.colorShiftAdvanced);
        }
        document.getElementById('tv-chroma-adv-row').classList.toggle('hidden', !State.colorShiftAdvanced);
        document.getElementById('tv-chroma-colors').value = textObj.colorShiftColors || '';
        document.getElementById('tv-chroma-speed').value  = textObj.colorShiftSpeed  || 60;

        State.gradientEnabled = !!textObj.gradient;
        const grBtn = document.getElementById('tv-gradient-btn');
        if (grBtn) {
            grBtn.textContent = State.gradientEnabled ? t('ui.on') : t('ui.off');
            grBtn.classList.toggle('active', State.gradientEnabled);
        }
        document.getElementById('tv-gradient-from').value = textObj.gradientFrom || '#ffd966';
        document.getElementById('tv-gradient-to').value   = textObj.gradientTo   || '#c08a1f';

        State.pulseEnabled = !!textObj.pulse;
        const pBtn = document.getElementById('tv-pulse-btn');
        if (pBtn) {
            pBtn.textContent = State.pulseEnabled ? t('ui.on') : t('ui.off');
            pBtn.classList.toggle('active', State.pulseEnabled);
        }
        document.getElementById('tv-pulse-speed').value = textObj.pulseSpeed || 60;
    }
    if (clip) {
        document.getElementById('tc-start').value = clip.startFrame;
        document.getElementById('tc-end').value   = clip.endFrame;
    }
    if (textObj) {
        const orientCb = document.getElementById('tv-lock-orient');
        if (orientCb) orientCb.checked = textObj.orientWithEntity !== false;
        const orientRow = document.getElementById('tv-lock-orient-row');
        if (orientRow) orientRow.classList.toggle('hidden', !textObj.lockedEntity);
        populateTextLockDropdown(textObj);
    }
    applyPanelKind(State.editingKind);
    renderTextTrack(getTimelineWidth());
}

// Fills the text lock dropdown with recorded vehicles/peds ranked by distance
// from the text's effective world position at the playhead. Lua resolves that
// world pos (locked text is an offset, so we can't know it JS-side). Mirrors
// populateKeyframeLockDropdown — same getRecordedVehiclesAtFrame backend.
async function populateTextLockDropdown(textObj) {
    const sel = document.getElementById('tv-lock-entity');
    if (!sel) return;

    const myClipId = State.editingClipId;
    const cur = (textObj.lockedEntity === null || textObj.lockedEntity === undefined) ? '' : String(textObj.lockedEntity);
    sel.innerHTML = `<option value="">${t('html.labels.lock_none')}</option>`;
    sel.value = cur;

    const w = await postAwait('getTextWorldAt', {
        frame: State.currentFrame,
        coords: textObj.coords,
        lockedEntity: textObj.lockedEntity || null,
        lockYaw: textObj.lockYaw || 0,
        orientWithEntity: textObj.orientWithEntity !== false,
    });
    if (State.editingClipId !== myClipId) return; // user moved on
    const wx = (w && w.pos && typeof w.pos.x === 'number') ? w.pos.x : (textObj.coords ? textObj.coords.x : 0);
    const wy = (w && w.pos && typeof w.pos.y === 'number') ? w.pos.y : (textObj.coords ? textObj.coords.y : 0);
    const wz = (w && w.pos && typeof w.pos.z === 'number') ? w.pos.z : (textObj.coords ? textObj.coords.z : 0);

    const r = await postAwait('getRecordedVehiclesAtFrame', { frame: State.currentFrame, x: wx, y: wy, z: wz });
    if (State.editingClipId !== myClipId) return;
    const list = (r && r.vehicles) || [];

    sel.innerHTML = `<option value="">${t('html.labels.lock_none')}</option>`;
    for (const v of list) {
        const opt = document.createElement('option');
        opt.value = String(v.idx);
        if (v.kind === 'ped') {
            const youTag = v.isPlayer ? ' (you)' : '';
            opt.textContent = `ped: ${v.model}${youTag} · ${v.distance.toFixed(1)}m`;
        } else {
            opt.textContent = `${v.model} · ${v.distance.toFixed(1)}m`;
        }
        sel.appendChild(opt);
    }
    sel.value = cur;
}

function deselectClip() {
    State.selectedClipId = null;
    document.getElementById('sp-delete-clip-btn').classList.add('hidden');
    renderTextTrack(getTimelineWidth());
}

function syncTextToLua() {
    post('setTextData', {
        textObjects: State.textObjects,
        textClips:   State.textClips,
    });
}

// Text objects are visible as clips on the 3D TEXT track — no separate list panel needed
function renderTextObjectsList() {}

// ── TEXT PLACEMENT HANDLERS ───────────────────────────────────────────────────
function onTextPlacementOverlay(active) {
    State.isTextPlacing = active;
    if (active) {
        PlacementGuide.show('text');
        document.getElementById('side-panel').classList.add('dimmed');
    } else {
        PlacementGuide.hide();
        document.getElementById('side-panel').classList.remove('dimmed');
    }
}

async function onTextPlacementDone(d) {
    onTextPlacementOverlay(false);
    if (!d || !d.coords) {
        // Cancelled — if editing an existing clip, just update its coords to nothing (keep clip)
        return;
    }

    const isImage  = (State.editingKind === 'image');
    const text     = isImage ? document.getElementById('tv-text').value.trim()
                             : (document.getElementById('tv-text').value.trim() || t('text3d.default_text'));
    const imageUrl = isImage ? document.getElementById('tv-image-url').value.trim() : '';
    const aspect   = State.imageAspect || 1.0;
    const font    = document.getElementById('tv-font').value;
    const color   = document.getElementById('tv-color').value;
    const size    = parseFloat(document.getElementById('tv-size').value) || 4.0;
    const anim    = document.getElementById('tv-anim').value;
    const animIn  = parseInt(document.getElementById('tv-anim-in').value)  || 15;
    const animOut = parseInt(document.getElementById('tv-anim-out').value) || 15;

    if (State.editingClipId !== null) {
        // Re-placing an existing clip — update its textObject's coords. The
        // freecam returns WORLD coords; if the text is locked, re-anchor them
        // into the entity-offset model so the lock is preserved.
        const clip = State.textClips.find(c => c.id === State.editingClipId);
        const obj  = clip ? State.textObjects.find(o => o.id === clip.textId) : null;
        if (obj) {
            if (obj.lockedEntity) {
                const r = await postAwait('convertTextLock', {
                    frame: State.currentFrame, coords: d.coords,
                    lockedEntity: obj.lockedEntity,
                    orientWithEntity: obj.orientWithEntity !== false,
                });
                if (r && r.error === 'out_of_range') {
                    // Entity gone at this frame — drop the lock, keep world coords.
                    obj.coords = d.coords;
                    delete obj.lockedEntity; delete obj.lockYaw;
                    showToast(t('toasts.text_entity_out_of_range'), 'error');
                } else if (r && r.coords) {
                    obj.coords = r.coords;
                    obj.lockYaw = (typeof r.lockYaw === 'number') ? r.lockYaw : (obj.lockYaw || 0);
                    showToast(t('toasts.position_updated'));
                }
            } else {
                obj.coords = d.coords;
                showToast(t('toasts.position_updated'));
            }
            syncTextToLua();
        }
        return;
    }

    // New placement — create textObject + clip together
    const objId = State.nextTextId++;
    const obj = { id: objId, kind: State.editingKind, text, imageUrl, aspect, font, color, size, shadow: State.shadowEnabled, glow: State.glowEnabled,
                  outline:          State.outlineEnabled,
                  outlineColor:     document.getElementById('tv-outline-color').value || '#000000',
                  outlineWidth:     parseInt(document.getElementById('tv-outline-width').value) || 2,
                  colorShift:         State.colorShiftEnabled,
                  colorShiftAdvanced: State.colorShiftAdvanced,
                  colorShiftColors:   State.colorShiftAdvanced ? (document.getElementById('tv-chroma-colors').value || '') : '',
                  colorShiftSpeed:    parseInt(document.getElementById('tv-chroma-speed').value) || 60,
                  gradient:           State.gradientEnabled,
                  gradientFrom:       document.getElementById('tv-gradient-from').value || '#ffd966',
                  gradientTo:         document.getElementById('tv-gradient-to').value   || '#c08a1f',
                  pulse:              State.pulseEnabled,
                  pulseSpeed:         parseInt(document.getElementById('tv-pulse-speed').value) || 60,
                  animation: anim, animIn, animOut, coords: d.coords };
    const clip = { id: State.nextTextClipId++, textId: objId,
                   startFrame: State.currentFrame,
                   endFrame:   Math.min(totalFrames(), State.currentFrame + 60) };
    State.textObjects.push(obj);
    State.textClips.push(clip);
    syncTextToLua();
    renderTimeline();
    showToast(imageUrl
        ? '3D image added to timeline.'
        : t('toasts.text_added_to_timeline', { text: text.substring(0,20) }));
}

function deleteTextObject(textId) {
    State.textObjects = State.textObjects.filter(o => o.id !== textId);
    State.textClips   = State.textClips.filter(c => c.textId !== textId);
    if (State.selectedClipId !== null) {
        const stillExists = State.textClips.find(c => c.id === State.selectedClipId);
        if (!stillExists) { deselectClip(); CC.backToMenu(); }
    }
    syncTextToLua();
    renderTextObjectsList();
    renderTimeline();
    showToast(t('toasts.text_object_deleted'));
}

function drawRuler(ctx, width) {
    const h   = 22;
    ctx.clearRect(0, 0, width, h);
    ctx.fillStyle = 'rgba(48,48,48,0.98)';
    ctx.fillRect(0, 0, width, h);

    const fps   = State.fps;
    const total = totalFrames();

    // Pick a major interval (in frames) so labels are at least 65px apart
    const minLabelPx = 65;
    // Candidate step sizes in seconds, from fine to coarse
    const stepsSec = [0.5, 1, 2, 5, 10, 15, 30, 60, 120, 300];
    const stepSec  = stepsSec.find(s => s * State.zoom * fps >= minLabelPx) || 300;
    const majorInterval = Math.round(stepSec * fps);
    const minorInterval = Math.max(1, Math.round(majorInterval / 5));

    ctx.font      = '9px Segoe UI, sans-serif';
    ctx.textAlign = 'center';

    for (let f = 0; f <= total + majorInterval; f += minorInterval) {
        const x = frameToPixel(f);
        if (x > width) break;
        const isMajor = (f % majorInterval === 0);
        ctx.beginPath();
        ctx.strokeStyle = isMajor ? 'rgba(150,150,150,0.6)' : 'rgba(70,70,70,0.5)';
        ctx.moveTo(x, isMajor ? 0 : 12);
        ctx.lineTo(x, h);
        ctx.stroke();
        if (isMajor) {
            const sec = f / fps;
            const mm  = Math.floor(sec / 60);
            const ss  = Math.floor(sec % 60);
            ctx.fillStyle = '#999';
            ctx.fillText(
                `${String(mm).padStart(2,'0')}:${String(ss).padStart(2,'0')}`,
                x, 9
            );
        }
    }
}

function updatePlayheadPosition() {
    const x    = frameToPixel(State.currentFrame);
    const ph   = document.getElementById('playhead');
    const wrap = document.getElementById('timeline-scroll-wrap');
    ph.style.left = x + 'px';
    // Auto-scroll
    if (wrap) {
        const pw = wrap.clientWidth;
        if (x < wrap.scrollLeft + 40 || x > wrap.scrollLeft + pw - 40) {
            wrap.scrollLeft = Math.max(0, x - pw / 2);
        }
    }
}

// Ruler click → move playhead
document.getElementById('ruler-canvas').addEventListener('mousedown', (e) => {
    seekTo(e);
    const onMove = (ev) => seekTo(ev);
    const onUp   = () => { window.removeEventListener('mousemove', onMove); window.removeEventListener('mouseup', onUp); };
    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
});

function seekTo(e) {
    const rect = document.getElementById('ruler-canvas').getBoundingClientRect();
    const px   = e.clientX - rect.left;
    const frame = Math.max(0, Math.min(totalFrames(), pixelToFrame(px)));
    State.currentFrame = frame;
    document.getElementById('frame-input').value = frame;
    updatePlayheadPosition();
    updateTimecodeDisplay();
    post('jumpToFrame', { frame });
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive() && frame > 15) Tutorial.fire('tut:scrubbed');
}

// Scroll wheel zoom on timeline
document.getElementById('timeline-scroll-wrap').addEventListener('wheel', (e) => {
    if (e.ctrlKey || e.altKey) {
        e.preventDefault();
        State.zoom = Math.max(0.3, Math.min(20, State.zoom * (e.deltaY > 0 ? 0.87 : 1.15)));
        renderTimeline();
    }
}, { passive: false });

// Keep zoom bar in sync when user drags the native-less scroll
document.getElementById('timeline-scroll-wrap').addEventListener('scroll', updateZoomBar);

// ── PREMIERE-STYLE ZOOM / SCROLL BAR ─────────────────────────────────────────
function updateZoomBar() {
    const wrap  = document.getElementById('timeline-scroll-wrap');
    const bar   = document.getElementById('timeline-zoom-bar');
    const thumb = document.getElementById('tzb-thumb');
    if (!wrap || !bar || !thumb) return;

    const barW   = bar.clientWidth;
    const total  = totalFrames();
    const zoom   = State.zoom;
    if (total <= 0 || barW <= 0) return;

    const leftFrame  = wrap.scrollLeft / zoom;
    const rightFrame = (wrap.scrollLeft + wrap.clientWidth) / zoom;

    const tl = Math.max(0, (leftFrame  / total) * barW);
    const tr = Math.min(barW, (rightFrame / total) * barW);
    const tw = Math.max(24, tr - tl);

    thumb.style.left  = tl + 'px';
    thumb.style.width = tw + 'px';
}

(function initZoomBar() {
    const bar    = document.getElementById('timeline-zoom-bar');
    const thumb  = document.getElementById('tzb-thumb');
    const handleL = document.getElementById('tzb-handle-l');
    const handleR = document.getElementById('tzb-handle-r');

    const MIN_ZOOM           = 0.15;
    const MAX_ZOOM           = 20;
    const MIN_VISIBLE_FRAMES = 10;

    bar.addEventListener('mousedown', (e) => {
        e.preventDefault();
        const wrap  = document.getElementById('timeline-scroll-wrap');
        const barW  = bar.clientWidth;
        const total = totalFrames();

        const origScrollL  = wrap.scrollLeft;
        const origZoom     = State.zoom;
        const origLeftF    = origScrollL / origZoom;
        const origRightF   = (origScrollL + wrap.clientWidth) / origZoom;

        let type;
        if (e.target === handleL)                           type = 'zoomL';
        else if (e.target === handleR)                      type = 'zoomR';
        else if (e.target === thumb || thumb.contains(e.target)) type = 'pan';
        else {
            // Click on empty bar area — center view on that position
            const frac        = (e.clientX - bar.getBoundingClientRect().left) / barW;
            const targetFrame = frac * total;
            wrap.scrollLeft   = Math.max(0, targetFrame * State.zoom - wrap.clientWidth / 2);
            updateZoomBar();
            return;
        }

        const startX = e.clientX;

        const onMove = (ev) => {
            const dx    = ev.clientX - startX;
            const dFrac = dx / barW;           // fraction of total timeline moved
            const dFrame = dFrac * total;      // equivalent frame delta

            if (type === 'pan') {
                // Map zoom-bar pixels → scroll-wrap pixels proportionally
                const timelineW = total * origZoom;
                wrap.scrollLeft = Math.max(0, origScrollL + dx * (timelineW / barW));
                updateZoomBar();

            } else if (type === 'zoomL') {
                // Left handle: right frame is anchored, left frame moves
                const newLeftF     = origLeftF + dFrame;
                const newVisibleF  = Math.max(MIN_VISIBLE_FRAMES, origRightF - newLeftF);
                const newZoom      = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, wrap.clientWidth / newVisibleF));
                State.zoom         = newZoom;
                // Anchor right frame: scroll so origRightF stays at the right edge
                wrap.scrollLeft    = Math.max(0, origRightF * newZoom - wrap.clientWidth);
                renderTimeline();

            } else if (type === 'zoomR') {
                // Right handle: left frame is anchored, right frame moves
                const newRightF    = origRightF + dFrame;
                const newVisibleF  = Math.max(MIN_VISIBLE_FRAMES, newRightF - origLeftF);
                const newZoom      = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, wrap.clientWidth / newVisibleF));
                State.zoom         = newZoom;
                // Anchor left frame: scroll so origLeftF stays at the left edge
                wrap.scrollLeft    = Math.max(0, origLeftF * newZoom);
                renderTimeline();
            }
        };

        const onUp = () => {
            window.removeEventListener('mousemove', onMove);
            window.removeEventListener('mouseup', onUp);
        };

        window.addEventListener('mousemove', onMove);
        window.addEventListener('mouseup', onUp);
    });

    // Double-click zoom bar to fit entire timeline in view
    bar.addEventListener('dblclick', () => {
        const wrap  = document.getElementById('timeline-scroll-wrap');
        const total = totalFrames();
        if (total <= 0) return;
        State.zoom  = Math.max(0.15, (wrap.clientWidth - 20) / total);
        wrap.scrollLeft = 0;
        renderTimeline();
        showToast(t('toasts.timeline_fit_to_view'));
    });
})();

// ── CLICK EMPTY TRACK → DESELECT ─────────────────────────────────────────────
// Marquee starts on empty space inside the tracks area. Elements stopPropagation
// on their own mousedown, so this only fires on background.
document.getElementById('tracks-container').addEventListener('mousedown', (e) => {
    if (e.target === e.currentTarget || e.target.classList.contains('track')) {
        startMarquee(e, document.getElementById('tracks-container'));
    }
});

document.getElementById('tracks-container').addEventListener('mousedown', (e) => {
    if (e.target === e.currentTarget || e.target.classList.contains('track')) {
        if (State.selectedKfId !== null || State.vehicleRecSelected
            || State.selectedClipId !== null || State.selectedOverlayId !== null
            || selectionCount() > 0) {
            clearSelection();
            State.selectedKfId       = null;
            State.vehicleRecSelected = false;
            State.selectedClipId     = null;
            State.editingClipId      = null;
            State.selectedOverlayId  = null;
            hideSidePanel();
            renderTimeline();
        }
    }
});

// ── RULER HOVER TOOLTIP ───────────────────────────────────────────────────────
// Tip element is hoisted to module scope (via hideRulerTooltip) so callers
// outside this IIFE — playback start and UI hide — can dismiss it. Without
// that, the tooltip's only hide path was the ruler's own `mouseleave`, which
// never fires when the cursor is parked over the ruler at the moment Space
// triggers playback / the UI closes — leaving the tooltip rendered on top
// of the export recording.
let hideRulerTooltip = () => {};
(function initRulerTooltip() {
    const tip = document.createElement('div');
    Object.assign(tip.style, {
        position: 'fixed', display: 'none',
        background: 'rgba(20,20,20,0.92)', color: '#aaa',
        fontSize: '10px', fontFamily: "'Consolas', monospace",
        padding: '3px 8px', borderRadius: '3px',
        border: '1px solid #444', pointerEvents: 'none', zIndex: '999',
    });
    document.body.appendChild(tip);
    hideRulerTooltip = () => { tip.style.display = 'none'; };
    const ruler = document.getElementById('ruler-canvas');
    ruler.addEventListener('mousemove', (e) => {
        // Don't show the tip during playback — it would render on top of the
        // recorded frame even though the cursor hasn't left the ruler.
        if (State.isPlaying) { tip.style.display = 'none'; return; }
        const rect = ruler.getBoundingClientRect();
        const f    = Math.max(0, Math.min(totalFrames(), pixelToFrame(e.clientX - rect.left)));
        const sec  = Math.floor(f / State.fps);
        tip.textContent = `${pad(Math.floor(sec/60))}:${pad(sec%60)}:${pad(f%State.fps)}  f${f}`;
        tip.style.display = 'block';
        tip.style.left = (e.clientX + 14) + 'px';
        tip.style.top  = (e.clientY + 16) + 'px';
    });
    ruler.addEventListener('mouseleave', () => { tip.style.display = 'none'; });
})();

// ── DRAG ─────────────────────────────────────────────────────────────────────
const DRAG_THRESHOLD = 5; // pixels of movement before it counts as a drag

// ── MULTI-SELECTION ───────────────────────────────────────────────────────────
//
// State.selection is the full selection; State.selectedKfId stays the
// "primary" one whose properties the side panel shows. Dragging any member of a
// multi-selection moves the whole set, keeping the spacing between them.

function isSelected(kind, id) {
    return (State.selection || []).some(s => s.kind === kind && s.id === id);
}
function isKfSelected(id) { return isSelected('kf', id); }

function selectionCount() { return (State.selection || []).length; }

function clearSelection() { State.selection = []; }

function setKfSelection(ids, primary) {
    State.selection = ids.map(id => ({ kind: 'kf', id }));
    if (primary != null) selectKeyframe(primary, true);
    else renderTimeline();
}

function toggleKfSelection(id) {
    const cur = (State.selection || []).filter(s => !(s.kind === 'kf' && s.id === id));
    const removed = cur.length !== selectionCount();
    if (!removed) cur.push({ kind: 'kf', id });
    State.selection = cur;
    const kfs = cur.filter(s => s.kind === 'kf');
    const primary = !removed ? id : (kfs.length ? kfs[kfs.length - 1].id : null);
    if (primary != null) selectKeyframe(primary, true); else renderTimeline();
}

// Shift-click selects the contiguous run between the primary and the clicked
// keyframe, the way a file list or a timeline normally behaves.
function extendKfSelection(id) {
    const ordered = State.keyframes.slice().sort((a, b) => a.frame - b.frame);
    const anchor  = ordered.findIndex(k => k.id === State.selectedKfId);
    const target  = ordered.findIndex(k => k.id === id);
    if (anchor < 0 || target < 0) { setKfSelection([id], id); return; }
    const lo = Math.min(anchor, target), hi = Math.max(anchor, target);
    setKfSelection(ordered.slice(lo, hi + 1).map(k => k.id), id);
}

// Rubber-band selection, drawn on the tracks container so it spans every row
// rather than being trapped in one track. What the box touches is what gets
// selected — hit-testing is a plain rectangle intersection against the rendered
// elements, so it matches what you drew instead of approximating it from frame
// numbers per element type.
//
// Modifiers follow the usual convention: Shift adds to the selection, Ctrl/Cmd
// toggles what it touches. Neither held = start a fresh selection.
function startMarquee(e, container) {
    if (e.button !== 0) return;
    if (State.cutMode) return;                       // the razor owns clicks in cut mode

    const startX   = e.clientX;
    const startY   = e.clientY;
    const additive = e.shiftKey;
    const toggling = e.ctrlKey || e.metaKey;
    const baseline = (additive || toggling) ? (State.selection || []).slice() : [];

    const box = document.createElement('div');
    box.className = 'tl-marquee';
    let live = false;

    const onMove = (ev) => {
        const dx = ev.clientX - startX;
        const dy = ev.clientY - startY;
        if (!live && Math.abs(dx) < DRAG_THRESHOLD && Math.abs(dy) < DRAG_THRESHOLD) return;
        if (!live) { live = true; document.body.appendChild(box); }

        // Drawn in viewport coordinates on <body> so it isn't clipped by a
        // track's own overflow, and so it can span rows freely.
        const l = Math.min(startX, ev.clientX);
        const t = Math.min(startY, ev.clientY);
        const w = Math.abs(dx), h = Math.abs(dy);
        box.style.left = l + 'px'; box.style.top = t + 'px';
        box.style.width = w + 'px'; box.style.height = h + 'px';

        const band = { left: l, top: t, right: l + w, bottom: t + h };
        const hits = [];
        container.querySelectorAll('[data-sel-kind]').forEach(el => {
            const r = el.getBoundingClientRect();
            const intersects = r.left <= band.right && r.right >= band.left
                            && r.top  <= band.bottom && r.bottom >= band.top;
            if (!intersects) return;
            const kind = el.dataset.selKind;
            // ids are numeric for every kind except nothing currently — keep the
            // numeric form so it compares equal to the model's ids.
            const id = Number(el.dataset.selId);
            hits.push({ kind, id: Number.isNaN(id) ? el.dataset.selId : id });
        });

        let merged;
        if (toggling) {
            merged = baseline.slice();
            hits.forEach(h2 => {
                const i = merged.findIndex(m => m.kind === h2.kind && m.id === h2.id);
                if (i >= 0) merged.splice(i, 1); else merged.push(h2);
            });
        } else {
            merged = baseline.slice();
            hits.forEach(h2 => {
                if (!merged.some(m => m.kind === h2.kind && m.id === h2.id)) merged.push(h2);
            });
        }

        State.selection = merged;
        renderTimeline();
    };

    const onUp = () => {
        if (live) {
            box.remove();
            const sel = State.selection || [];
            const kfs = sel.filter(x => x.kind === 'kf');
            // Give the panel a primary so a marquee selection is immediately
            // editable, not just highlighted.
            if (kfs.length) selectKeyframe(kfs[kfs.length - 1].id, true); else renderTimeline();
            if (sel.length > 1) showToast(t('toasts.items_selected', { count: sel.length }));
        } else if (!additive && !toggling) {
            // A plain click on empty space clears the selection. Without this the
            // outlines stayed on screen with nothing obvious to clear them.
            if (selectionCount()) { clearSelection(); renderTimeline(); }
        }
        window.removeEventListener('mousemove', onMove);
        window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
}

// Drags every selected item — keyframes, 3D text clips and overlay recordings —
// by one shared frame delta. Each type stores its position differently
// (keyframes carry `frame`, clips and layers carry startFrame/endFrame), so the
// snapshot records whatever that type uses and the delta is applied back to it.
//
// The delta is clamped once against the whole set rather than per item, so the
// group keeps its internal spacing when it runs into either end of the
// timeline instead of bunching up against the edge.
function startGroupDrag(e) {
    pushUndo();
    const startX = e.clientX;
    const total  = totalFrames();

    const items = [];
    (State.selection || []).forEach(sel => {
        if (sel.kind === 'kf') {
            const k = State.keyframes.find(x => x.id === sel.id);
            if (k) items.push({ kind: 'kf', ref: k, start: k.frame, span: 0 });
        } else if (sel.kind === 'text') {
            const c = (State.textClips || []).find(x => x.id === sel.id);
            if (c) items.push({ kind: 'span', ref: c, start: c.startFrame, span: c.endFrame - c.startFrame });
        } else if (sel.kind === 'overlay') {
            const l = (State.overlayLayers || [])[sel.id - 1];
            if (l) items.push({ kind: 'span', ref: l, start: l.startFrame, span: l.endFrame - l.startFrame });
        } else if (sel.kind === 'veh') {
            const c = (State.vehicleRecClips || [])[sel.id];
            if (c) items.push({ kind: 'span', ref: c, start: c.startFrame, span: c.endFrame - c.startFrame });
        }
    });
    if (!items.length) return false;

    const minStart = Math.min(...items.map(i => i.start));
    const maxEnd   = Math.max(...items.map(i => i.start + i.span));
    let isDragging = false;

    const onMove = (ev) => {
        const dx = ev.clientX - startX;
        if (!isDragging && Math.abs(dx) < DRAG_THRESHOLD) return;
        isDragging = true;

        let df = Math.round(dx / State.zoom);
        df = Math.max(-minStart, Math.min(total - maxEnd, df));

        items.forEach(i => {
            if (i.kind === 'kf') {
                i.ref.frame = i.start + df;
            } else {
                i.ref.startFrame = i.start + df;
                i.ref.endFrame   = i.start + df + i.span;
            }
        });
        renderTimeline();
    };

    const onUp = () => {
        if (isDragging) {
            sortKeyframes();
            syncKeyframesToLua();
            // Text and overlay timings each have their own push to Lua; send one
            // per moved item so the server-side view matches what's on screen.
            if (items.some(i => i.kind === 'span' && i.ref.startFrame !== undefined && State.textClips.indexOf(i.ref) >= 0)) {
                syncTextToLua();
            }
            // pushVehicleRecClips is the real sender — it shapes the payload
            // (startFrame/endFrame/trimInFrame) and persists to the project.
            if ((State.selection || []).some(sel => sel.kind === 'veh')) {
                pushVehicleRecClips();
            }
            (State.selection || []).forEach(sel => {
                if (sel.kind !== 'overlay') return;
                const layer = (State.overlayLayers || [])[sel.id - 1];
                if (!layer) return;
                post('setOverlayTiming', {
                    layerIdx:    sel.id,
                    startFrame:  layer.startFrame,
                    endFrame:    layer.endFrame,
                    trimInFrame: layer.trimInFrame,
                });
            });
            autoSaveProject();
            renderTimeline();
        }
        window.removeEventListener('mousemove', onMove);
        window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
    return true;
}

function startDrag(e, kfId) {
    // Part of a multi-selection → the whole set moves together.
    if (isSelected('kf', kfId) && selectionCount() > 1) { startGroupDrag(e); return; }

    pushUndo();
    const startX = e.clientX;

    // Multi-selections are handled by startGroupDrag above, so from here this
    // is always the single-keyframe path.
    const group = [State.keyframes.find(k => k.id === kfId)].filter(Boolean);

    // Snapshot every start frame so the drag is always computed from the
    // original layout — accumulating per-tick deltas drifts.
    const starts = new Map(group.map(k => [k.id, k.frame]));
    const minStart = Math.min(...starts.values());
    const maxStart = Math.max(...starts.values());

    State.dragStartFrame = starts.get(kfId) || 0;
    State.draggingKfId   = kfId;
    let isDragging = false;

    const onMove = (ev) => {
        const dx = ev.clientX - startX;
        if (!isDragging && Math.abs(dx) < DRAG_THRESHOLD) return;
        isDragging = true;

        // Clamp the DELTA, not each keyframe, so the group keeps its spacing
        // when it runs into either end of the timeline.
        let df = Math.round(dx / State.zoom);
        df = Math.max(-minStart, Math.min(totalFrames() - maxStart, df));

        // Shift: snap to the nearest keyframe outside the moving group. Only
        // meaningful for a single drag — snapping a group on one member would
        // silently shift all the others off their frames.
        if (ev.shiftKey && group.length === 1) {
            const target = State.dragStartFrame + df;
            const others = State.keyframes.filter(k => !starts.has(k.id)).map(k => k.frame);
            const snapR  = Math.max(3, Math.round(8 / State.zoom));
            if (others.length > 0) {
                const near = others.reduce((b, f) => Math.abs(f - target) < Math.abs(b - target) ? f : b);
                if (Math.abs(near - target) <= snapR) df = near - State.dragStartFrame;
            }
        }

        group.forEach(k => { k.frame = starts.get(k.id) + df; });
        renderTimeline();
    };

    const onUp = () => {
        // Only re-render if we actually dragged — otherwise let the click event fire normally
        if (isDragging) {
            sortKeyframes();
            syncKeyframesToLua();
            renderTimeline();
        }
        State.draggingKfId = null;
        window.removeEventListener('mousemove', onMove);
        window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
}

// ── TRANSPORT ─────────────────────────────────────────────────────────────────
function setFrame(f) {
    f = Math.max(0, Math.min(totalFrames(), f));
    if (State.selectedSceneId !== null && State._entityFocused) {
        post('unfocusEntity');
        State._entityFocused = false;
    }
    State.currentFrame = f;
    document.getElementById('frame-input').value = f;
    updatePlayheadPosition();
    updateTimecodeDisplay();
    post('jumpToFrame', { frame: f });
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive() && f > 15) Tutorial.fire('tut:scrubbed');
}

CC.gotoStart   = () => setFrame(0);
CC.gotoEnd     = () => setFrame(totalFrames());
CC.stepBack    = () => setFrame(State.currentFrame - 1);
CC.stepForward = () => setFrame(State.currentFrame + 1);

CC.togglePlay = function() {
    if (State.isPlaying) {
        CC.stopPlayback();
    } else {
        post('startPlayback', { fromFrame: State.currentFrame, totalFrames: totalFrames() });
    }
};

CC.stopPlayback = function() { post('stopPlayback', {}); };

CC.jumpToFrame = function(f) { setFrame(f); };

CC.setDuration = function(sec) {
    sec = Math.max(1, Math.min(600, sec || 30));
    State.durationSec = sec;
    document.getElementById('duration-input').value = sec;
    renderTimeline();
    syncKeyframesToLua();
};

// ── TIMECODE ──────────────────────────────────────────────────────────────────
function updateTimecodeDisplay() {
    const f   = State.currentFrame;
    const fps = State.fps;
    const sec = Math.floor(f / fps);
    const hh  = Math.floor(sec / 3600);
    const mm  = Math.floor((sec % 3600) / 60);
    const ss  = sec % 60;
    const ff  = f % fps;
    document.getElementById('timecode-display').textContent =
        `${pad(hh)}:${pad(mm)}:${pad(ss)}:${pad(ff)}`;
}
function pad(n) { return String(n).padStart(2, '0'); }

// ── UNDO / REDO ──────────────────────────────────────────────────────────────
State.undoStack = [];
State.redoStack = [];
State.clipboard = null;
State.inPoint   = null;
State.outPoint  = null;

// The undo/redo stacks hold typed entries so one Ctrl+Z timeline covers every
// edit kind in the order it happened:
//   { kind:'state',      keyframes, textObjects, textClips }  — keyframe/text edits
//   { kind:'vehCut',     before, after }                      — main-recording cut
//   { kind:'overlayCut', layerIdx, atFrame }                  — overlay layer cut
// 'state' entries keep the original snapshot-swap semantics; cut entries carry
// both directions inline so undo/redo just re-applies the stored side.
function captureState() {
    return {
        kind:        'state',
        keyframes:   JSON.parse(JSON.stringify(State.keyframes)),
        textObjects: JSON.parse(JSON.stringify(State.textObjects)),
        textClips:   JSON.parse(JSON.stringify(State.textClips)),
    };
}

function applyStateSnapshot(snap) {
    State.keyframes    = snap.keyframes;
    State.textObjects  = snap.textObjects;
    State.textClips    = snap.textClips;
    State.selectedKfId = null; State.editingClipId = null;
    syncKeyframesToLua(); syncTextToLua(); renderTimeline(); hideSidePanel();
}

function pushUndoEntry(entry) {
    State.undoStack.push(entry);
    if (State.undoStack.length > 50) State.undoStack.shift();
    State.redoStack = [];
}

function pushUndo()                          { pushUndoEntry(captureState()); }
function pushUndoVehCut(before, after)       { pushUndoEntry({ kind: 'vehCut', before, after }); }
function pushUndoOverlayCut(layerIdx, atFrame) { pushUndoEntry({ kind: 'overlayCut', layerIdx, atFrame }); }

CC.undo = function() {
    if (!State.undoStack.length) return;
    const entry = State.undoStack.pop();
    if (entry.kind === 'vehCut') {
        State.redoStack.push(entry);
        State.vehicleRecClips    = JSON.parse(JSON.stringify(entry.before));
        State.selectedVehClipIdx = null;
        pushVehicleRecClips(); renderTimeline();
    } else if (entry.kind === 'overlayCut') {
        State.redoStack.push(entry);
        undoOverlayCutLocal(entry.layerIdx);
    } else {
        State.redoStack.push(captureState());
        applyStateSnapshot(entry);
    }
    showToast(t('toasts.undo'));
};

CC.redo = function() {
    if (!State.redoStack.length) return;
    const entry = State.redoStack.pop();
    if (entry.kind === 'vehCut') {
        State.undoStack.push(entry);
        State.vehicleRecClips    = JSON.parse(JSON.stringify(entry.after));
        State.selectedVehClipIdx = null;
        pushVehicleRecClips(); renderTimeline();
    } else if (entry.kind === 'overlayCut') {
        State.undoStack.push(entry);
        performOverlaySplit(entry.layerIdx, entry.atFrame);
    } else {
        State.undoStack.push(captureState());
        applyStateSnapshot(entry);
    }
    showToast(t('toasts.redo'));
};

// ── COPY / PASTE / DUPLICATE ─────────────────────────────────────────────────
CC.copyKeyframe = function() {
    if (State.selectedKfId !== null) {
        const kf = State.keyframes.find(k => k.id === State.selectedKfId);
        if (!kf) return;
        State.clipboard = { type: 'keyframe', data: JSON.parse(JSON.stringify(kf)) };
        showToast(t('toasts.keyframe_copied'));
    } else if (State.editingClipId !== null) {
        const clip = State.textClips.find(c => c.id === State.editingClipId);
        const obj  = clip ? State.textObjects.find(o => o.id === clip.textId) : null;
        if (!clip || !obj) return;
        State.clipboard = {
            type: 'textClip',
            clip: JSON.parse(JSON.stringify(clip)),
            obj:  JSON.parse(JSON.stringify(obj)),
        };
        showToast(t('toasts.text_clip_copied'));
    }
};

CC.pasteKeyframe = function() {
    if (!State.clipboard) { showToast(t('errors.nothing_to_paste'), 'error'); return; }
    pushUndo();
    if (State.clipboard.type === 'keyframe') {
        const kf  = JSON.parse(JSON.stringify(State.clipboard.data));
        kf.id     = State.nextId++;
        kf.frame  = State.currentFrame;
        State.keyframes.push(kf);
        sortKeyframes(); syncKeyframesToLua(); renderTimeline();
        selectKeyframe(kf.id);
        showToast(t('toasts.pasted_at_frame', { frame: kf.frame }));
    } else if (State.clipboard.type === 'textClip') {
        const obj = JSON.parse(JSON.stringify(State.clipboard.obj));
        obj.id    = State.nextTextId++;
        State.textObjects.push(obj);
        const dur  = State.clipboard.clip.endFrame - State.clipboard.clip.startFrame;
        const clip = {
            id:         State.nextTextClipId++,
            textId:     obj.id,
            startFrame: State.currentFrame,
            endFrame:   State.currentFrame + dur,
        };
        State.textClips.push(clip);
        syncTextToLua(); renderTimeline(); renderTextObjectsList();
        selectClip(clip.id);
        showToast(t('toasts.text_pasted_at_frame', { frame: clip.startFrame }));
    }
};

CC.duplicateKeyframe = function() {
    if (State.selectedKfId !== null) {
        const src = State.keyframes.find(k => k.id === State.selectedKfId);
        if (!src) return;
        pushUndo();
        const kf  = JSON.parse(JSON.stringify(src));
        kf.id     = State.nextId++;
        kf.frame  = Math.min(src.frame + 30, totalFrames());
        State.keyframes.push(kf);
        sortKeyframes(); syncKeyframesToLua(); renderTimeline();
        selectKeyframe(kf.id);
        showToast(t('toasts.duplicated_to_frame', { frame: kf.frame }));
    } else if (State.editingClipId !== null) {
        const clip = State.textClips.find(c => c.id === State.editingClipId);
        const obj  = clip ? State.textObjects.find(o => o.id === clip.textId) : null;
        if (!clip || !obj) return;
        pushUndo();
        const newObj = JSON.parse(JSON.stringify(obj));
        newObj.id    = State.nextTextId++;
        State.textObjects.push(newObj);
        const dur     = clip.endFrame - clip.startFrame;
        const newClip = {
            id:         State.nextTextClipId++,
            textId:     newObj.id,
            startFrame: clip.endFrame,
            endFrame:   clip.endFrame + dur,
        };
        State.textClips.push(newClip);
        syncTextToLua(); renderTimeline(); renderTextObjectsList();
        selectClip(newClip.id);
        showToast(t('toasts.text_duplicated'));
    }
};

// ── NUDGE KEYFRAME ───────────────────────────────────────────────────────────
CC.nudgeKeyframe = function(dir) {
    if (State.selectedKfId === null) return;
    const kf = State.keyframes.find(k => k.id === State.selectedKfId);
    if (!kf) return;
    pushUndo();
    kf.frame = Math.max(0, Math.min(totalFrames(), kf.frame + dir));
    sortKeyframes(); syncKeyframesToLua(); renderTimeline();
    setFrame(kf.frame);
};

// ── IN / OUT POINTS ──────────────────────────────────────────────────────────
CC.setInPoint = function() {
    State.inPoint = State.currentFrame;
    renderTimeline();
    showToast(t('toasts.in_point_set', { frame: State.inPoint }));
};

CC.setOutPoint = function() {
    State.outPoint = State.currentFrame;
    renderTimeline();
    showToast(t('toasts.out_point_set', { frame: State.outPoint }));
};

CC.clearInOut = function() {
    State.inPoint = null; State.outPoint = null;
    renderTimeline();
    showToast(t('toasts.in_out_cleared'));
};

// ── KEYBOARD SHORTCUTS ────────────────────────────────────────────────────────
document.addEventListener('keydown', (e) => {
    if (['INPUT','SELECT','TEXTAREA'].includes(e.target.tagName)) return;

    // Ctrl combos
    if (e.ctrlKey || e.metaKey) {
        switch (e.key) {
            case 'z': case 'Z':
                e.preventDefault();
                if (e.shiftKey) CC.redo(); else CC.undo();
                return;
            case 'y': case 'Y': e.preventDefault(); CC.redo();             return;
            case 'c': case 'C': e.preventDefault(); CC.copyKeyframe();     return;
            case 'v': case 'V': e.preventDefault(); CC.pasteKeyframe();    return;
            case 'd': case 'D': e.preventDefault(); CC.duplicateKeyframe();return;
        }
    }

    switch (e.key) {
        case ' ':          e.preventDefault(); CC.togglePlay();    break;
        case 'Home':       CC.gotoStart();                         break;
        case 'End':        CC.gotoEnd();                           break;
        case 'ArrowLeft':
            e.preventDefault();
            if (e.shiftKey) setFrame(Math.max(0, State.currentFrame - 10));
            else CC.stepBack();
            break;
        case 'ArrowRight':
            e.preventDefault();
            if (e.shiftKey) setFrame(Math.min(totalFrames(), State.currentFrame + 10));
            else CC.stepForward();
            break;
        case 'Delete':     CC.deleteSelected();                    break;
        case 'Escape':     if (State.cutMode) CC.toggleCutMode(); else CC.close(); break;
        case '+': case '=': State.zoom = Math.min(20, State.zoom*1.2); renderTimeline(); break;
        case '-':           State.zoom = Math.max(0.3, State.zoom/1.2); renderTimeline(); break;
        // J/K/L — Premiere Pro shuttle keys
        case 'j': case 'J': e.preventDefault(); setFrame(Math.max(0, State.currentFrame - 10)); break;
        case 'k': case 'K': e.preventDefault(); if (State.isPlaying) CC.stopPlayback();         break;
        case 'l': case 'L': e.preventDefault(); if (!State.isPlaying) CC.togglePlay();          break;
        // [ / ] — nudge selected keyframe
        case '[': CC.nudgeKeyframe(-1); break;
        case ']': CC.nudgeKeyframe(1);  break;
        // I / O — in/out points
        case 'i': case 'I': CC.setInPoint();  break;
        case 'o': case 'O': CC.setOutPoint(); break;
        // C — toggle the cut (razor) tool
        case 'c': case 'C': e.preventDefault(); CC.toggleCutMode(); break;
    }
});

// ── TOAST ─────────────────────────────────────────────────────────────────────
function showToast(msg, type = 'info') {
    const t = document.createElement('div');
    t.textContent = msg;
    Object.assign(t.style, {
        position:   'fixed',
        bottom:     '220px',
        left:       '50%',
        transform:  'translateX(-50%)',
        background: type === 'error' ? '#c62828' : 'rgba(28,28,28,0.95)',
        border:     `1px solid ${type === 'error' ? '#e53935' : 'rgba(74,144,217,0.4)'}`,
        color:      type === 'error' ? '#fff' : '#c8c8c8',
        fontFamily: "'Segoe UI',sans-serif",
        fontSize:   '12px',
        padding:    '7px 16px',
        borderRadius: '4px',
        zIndex:     '9999',
        pointerEvents: 'none',
        animation:  'fadeOut 2.5s forwards',
    });
    document.body.appendChild(t);
    setTimeout(() => t.remove(), 2500);
}

// ── PANEL INPUT WIRING ────────────────────────────────────────────────────────
// All inputs auto-save (and preview) the moment they change — no Apply needed.
(function initPanelInputs() {
    // Continuous inputs: save on every keystroke / slider tick (debounced via autoSavePanel)
    ['sp-pos-x','sp-pos-y','sp-pos-z','sp-rot-x','sp-rot-y','sp-rot-z',
     'sp-fov-num','sp-fov-slider',
     'sp-time-slider','sp-time-num',
     'sp-shake-amp','sp-shake-amp-num',
     'sp-dof-near','sp-dof-far','sp-dof-fnum','sp-dof-fnum-num','sp-dof-str','sp-dof-str-num',
     'sp-blur','sp-blur-num','sp-filter-str','sp-filter-str-num',
     'sp-timescale','sp-timescale-num',
     'sp-fade-amount','sp-fade-amount-num',
     'sp-vignette','sp-vignette-num',
     'sp-grain','sp-grain-num'].forEach(id => {
        document.getElementById(id).addEventListener('input', CC.autoSavePanel);
    });

    // Committed inputs: save when selection/value is finalised
    ['sp-frame','sp-easing','sp-cut','sp-time-enabled','sp-shake-type','sp-dof-enabled','sp-filter-id',
     'sp-fade-type','sp-letterbox-ratio'].forEach(id => {
        document.getElementById(id).addEventListener('change', CC.autoSavePanel);
    });
})();

// ── TIME ENABLE TOGGLE — immediate UI update ───────────────────────────────────
// Fires before the debounced autoSavePanel so the disabled state is instant
document.getElementById('sp-time-enabled').addEventListener('change', function() {
    const enabled = this.checked;
    const slider  = document.getElementById('sp-time-slider');
    const num     = document.getElementById('sp-time-num');
    slider.disabled = !enabled;
    num.disabled    = !enabled;
    if (!enabled) {
        // Show world settings time as a preview reference
        slider.value = State.worldSettings.time;
        num.value    = State.worldSettings.time.toFixed(1);
    } else {
        // Restore the keyframe's stored time value (not the world display)
        const kf  = State.keyframes.find(k => k.id === State.selectedKfId);
        const val = kf && kf.time && kf.time.value || State.worldSettings.time;
        slider.value = val;
        num.value    = val.toFixed(1);
    }
});

// ═══════════════════════════════════════════════════════════════════════════════
// NUI-SAFE PROMPT / CONFIRM (replaces browser prompt() and confirm())
// ═══════════════════════════════════════════════════════════════════════════════

function nuiPrompt(title, message, defaultValue) {
    return new Promise((resolve) => {
        const modal   = document.getElementById('prompt-modal');
        const input   = document.getElementById('pm-input');
        const confirm = document.getElementById('pm-confirm');
        const cancel  = document.getElementById('pm-cancel');

        document.getElementById('pm-title').textContent   = title;
        document.getElementById('pm-message').textContent  = message || '';
        document.getElementById('pm-message').style.display = message ? 'block' : 'none';
        input.value = defaultValue || '';
        input.style.display = 'block';
        confirm.textContent = t('ui.ok');
        modal.classList.remove('hidden');
        setTimeout(() => input.focus(), 50);

        function cleanup() {
            modal.classList.add('hidden');
            confirm.removeEventListener('click', onOk);
            cancel.removeEventListener('click', onCancel);
            input.removeEventListener('keydown', onKey);
            document.getElementById('pm-backdrop').removeEventListener('click', onCancel);
        }
        function onOk()     { cleanup(); resolve(input.value.trim() || null); }
        function onCancel() { cleanup(); resolve(null); }
        function onKey(e)   { if (e.key === 'Enter') onOk(); if (e.key === 'Escape') onCancel(); }

        confirm.addEventListener('click', onOk);
        cancel.addEventListener('click', onCancel);
        input.addEventListener('keydown', onKey);
        document.getElementById('pm-backdrop').addEventListener('click', onCancel);
    });
}

function nuiConfirm(title, message) {
    return new Promise((resolve) => {
        const modal   = document.getElementById('prompt-modal');
        const input   = document.getElementById('pm-input');
        const confirm = document.getElementById('pm-confirm');
        const cancel  = document.getElementById('pm-cancel');

        document.getElementById('pm-title').textContent   = title;
        document.getElementById('pm-message').textContent  = message || '';
        document.getElementById('pm-message').style.display = message ? 'block' : 'none';
        input.style.display = 'none';
        confirm.textContent = t('ui.confirm');
        modal.classList.remove('hidden');

        function cleanup() {
            modal.classList.add('hidden');
            confirm.removeEventListener('click', onOk);
            cancel.removeEventListener('click', onCancel);
            document.getElementById('pm-backdrop').removeEventListener('click', onCancel);
        }
        function onOk()     { cleanup(); resolve(true); }
        function onCancel() { cleanup(); resolve(false); }

        confirm.addEventListener('click', onOk);
        cancel.addEventListener('click', onCancel);
        document.getElementById('pm-backdrop').addEventListener('click', onCancel);
    });
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCENE EDITOR
// ═══════════════════════════════════════════════════════════════════════════════

function populateSceneDropdowns() {
    const animSel = document.getElementById('se-anim-preset');
    animSel.innerHTML = `<option value="">${t('ui.select_placeholder')}</option>`;
    State.predefinedAnims.forEach((a, i) => {
        const opt = document.createElement('option');
        opt.value = i;
        opt.textContent = a.label;
        animSel.appendChild(opt);
    });

    const weapSel = document.getElementById('se-weapon-preset');
    weapSel.innerHTML = `<option value="">${t('ui.select_placeholder')}</option>`;
    State.commonWeapons.forEach((w, i) => {
        const opt = document.createElement('option');
        opt.value = i;
        opt.textContent = w.label;
        weapSel.appendChild(opt);
    });
}

// ── Panel navigation ─────────────────────────────────────────────────────────
CC.openSceneEditor = function() {
    hideAllViews();
    document.getElementById('sp-scene-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('scene.title');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');
    State.selectedSceneId = null;
    endVehiclePick();
    renderSceneEntityList();
    renderRelGroupList();
    renderPresetList();
    post('listPresets');   // refresh the global saved peds + vehicles
};

// ── Entity list rendering ────────────────────────────────────────────────────
function renderSceneEntityList() {
    const list = document.getElementById('se-entity-list');
    if (State.sceneEntities.length === 0) {
        list.innerHTML = `<div class="sp-hint" style="padding:4px 0">${t('scene.no_entities_yet')}</div>`;
        return;
    }
    list.innerHTML = '';
    State.sceneEntities.forEach(ent => {
        const card = document.createElement('div');
        card.className = 'se-entity-card' + (ent.id === State.selectedSceneId ? ' selected' : '');
        const icon = ent.type === 'ped' ? 'fa-person' : ent.type === 'vehicle' ? 'fa-car' : 'fa-cube';
        // Color icon by relationship group
        const group = ent.group ? State.relGroups.find(g => g.name === ent.group) : null;
        const iconStyle = group ? `background:${group.color}20;color:${group.color}` : '';
        card.innerHTML = `
            <div class="se-entity-icon ${ent.type}" ${iconStyle ? `style="${iconStyle}"` : ''}><i class="fa-solid ${icon}"></i></div>
            <span class="se-entity-name">${ent.model}</span>
            <span class="se-entity-type">${ent.group || ent.type}</span>
        `;
        card.addEventListener('click', () => openSceneEntityProps(ent.id));
        list.appendChild(card);
    });
}

// ── Preset library (global, reusable across projects: peds AND vehicles) ────
// One list, two halves. A ped preset carries its full freemode appearance, a
// vehicle preset its full visual build (colours, mods, extras, livery, wheels,
// plate) — both captured live off the entity at save time, so what you see in
// the scene is exactly what comes back.
function onPresetList(d) {
    State.presets = (d && d.presets) || [];
    renderPresetList();
}

CC.setPresetTab = function(kind) {
    State.presetTab = (kind === 'vehicle') ? 'vehicle' : 'ped';
    ['ped', 'vehicle'].forEach(k => {
        const b = document.getElementById('se-preset-tab-' + k);
        if (b) b.classList.toggle('active', k === State.presetTab);
    });
    renderPresetList();
};

function renderPresetList() {
    const list = document.getElementById('se-preset-list');
    if (!list) return;
    const kind = State.presetTab || 'ped';
    // Entries saved before the library held vehicles carry no kind — they're peds.
    const presets = (State.presets || []).filter(p => (p.kind || 'ped') === kind);
    if (presets.length === 0) {
        list.innerHTML = `<div class="sp-hint" style="padding:4px 0">${
            kind === 'vehicle' ? t('scene.no_saved_vehicles') : t('scene.no_saved_peds')}</div>`;
        return;
    }
    list.innerHTML = '';
    presets.forEach(p => {
        const card = document.createElement('div');
        card.className = 'se-entity-card';
        const icon = kind === 'vehicle' ? 'fa-car' : 'fa-user-tag';
        // Clicking the card spawns the preset; the trash button deletes it.
        card.innerHTML = `
            <div class="se-entity-icon ${kind}"><i class="fa-solid ${icon}"></i></div>
            <span class="se-entity-name">${escapeHtml(p.name)}</span>
            <span class="se-entity-type">${escapeHtml(p.model)}</span>
            <button class="tb-btn se-preset-del" title="${t('scene.delete_preset_title')}" data-id="${p.id}"><i class="fa-solid fa-trash"></i></button>
        `;
        card.addEventListener('click', (e) => {
            if (e.target.closest('.se-preset-del')) return;   // let the delete button handle its own click
            CC.spawnFromPreset(p.id);
        });
        const del = card.querySelector('.se-preset-del');
        if (del) del.addEventListener('click', (e) => { e.stopPropagation(); CC.deletePreset(p.id); });
        list.appendChild(card);
    });
}

// Minimal HTML escape so a preset name can't inject markup into the list.
function escapeHtml(s) {
    return String(s == null ? '' : s)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

// Save the selected scene entity into the library. `kind` comes from whichever
// panel the button lives in and has to match the selection — the two panels
// share nothing but the flow.
CC.saveEntityAsPreset = function(kind) {
    const id  = State.selectedSceneId;
    const ent = id != null ? State.sceneEntities.find(e => e.id === id) : null;
    if (!ent || ent.type !== kind) { showToast(t('errors.preset_select_first'), 'error'); return; }
    const input = document.getElementById(kind === 'vehicle' ? 'se-veh-preset-name' : 'se-preset-name');
    const name  = (input ? input.value : '').trim();
    if (!name) { showToast(t('errors.preset_name_required'), 'error'); return; }
    post('savePresetFromScene', { entityId: id, name });
    if (input) input.value = '';
    showToast(t('toasts.preset_saving', { name }));
};

// Presets spawn in front of the editor camera and go straight into placement
// mode, exactly like a hand-typed model does.
function presetSpawnPoint() {
    return {
        pos:     { x: State.currentCamPos.x, y: State.currentCamPos.y, z: State.currentCamPos.z - 1.0 },
        heading: (State.currentCamRot.z + 180) % 360,
    };
}

CC.spawnFromPreset = function(presetId) {
    const p = (State.presets || []).find(x => x.id === presetId);
    if (!p) return;
    const { pos, heading } = presetSpawnPoint();
    const id = State.nextSceneId++;
    let ent;

    if ((p.kind || 'ped') === 'vehicle') {
        ent = {
            id, type: 'vehicle', model: p.model, pos, heading,
            followPlayer: false, followDist: 10, followSpeed: 25, driveStyle: 786603,
            vehProps: p.props || null,
            _needsPlacement: true,
        };
        State.sceneEntities.push(ent);
        post('spawnSceneVehicle', { id, model: p.model, pos, heading, props: p.props || null });
    } else {
        ent = {
            id, type: 'ped', model: p.model, pos, heading,
            anim: null, weapon: null, followPlayer: false, followDist: 5, followSpeed: 1.0,
            appearance: p.appearance || null,
            _needsPlacement: true,
        };
        State.sceneEntities.push(ent);
        if (p.appearance) State.scenePedAppearances[id] = p.appearance;
        post('spawnScenePed', { id, model: p.model, pos, heading, appearance: p.appearance || null });
    }

    State.selectedSceneId = id;
    renderSceneEntityList();
    showToast(t('toasts.preset_spawned', { name: p.name }));
};

CC.deletePreset = async function(presetId) {
    const p = (State.presets || []).find(x => x.id === presetId);
    const name = p ? p.name : '';
    const ok = await nuiConfirm(t('scene.delete_preset_title'), t('scene.delete_preset_body', { name }));
    if (!ok) return;
    post('deletePreset', { id: presetId });
};

// ═══════════════════════════════════════════════════════════════════════════════
// PED ↔ VEHICLE SEATING
// ═══════════════════════════════════════════════════════════════════════════════
// The seat lives on the ped (`ent.seat = { vehId, index }`), so it saves and
// restores with the project like any other ped setting. Everything here is a
// thin view over that: Lua owns whether the ped is actually in the seat and
// answers every call with the truth, which is what the panel re-renders from.

function seatLabel(index) {
    if (index === -1) return t('scene.seat_driver');
    if (index === 0)  return t('scene.seat_front_passenger');
    return t('scene.seat_rear', { n: index });
}

function renderPedSeatSection(ent) {
    const empty  = document.getElementById('se-seat-empty');
    const filled = document.getElementById('se-seat-filled');
    if (!empty || !filled) return;
    // A ref names its car by scene id, recording index or raw handle depending
    // on kind, so "is it seated" is "does the ref name anything at all".
    const s = ent && ent.seat;
    const seated = !!(s && (s.vehId != null || s.recIdx != null || s.handle != null));
    empty.classList.toggle('hidden', seated);
    filled.classList.toggle('hidden', !seated);
    if (!seated) return;

    // Lua stamps the model name onto the ref when it seats the ped — the panel
    // can't look a recording puppet or a world car up in State.sceneEntities.
    document.getElementById('se-seat-vehicle').textContent = s.label || '-';
    fillSeatDropdown(s, s.index);
}

// How many seats a car has is a property of the MODEL, and which are free
// changes as other peds are seated — so the list is asked for fresh every time
// rather than cached on the entity.
async function fillSeatDropdown(ref, current) {
    const sel = document.getElementById('se-seat-index');
    if (!sel) return;
    const res   = await postAwait('sceneGetVehicleSeats', { ref });
    const seats = (res && res.seats && res.seats.length) ? res.seats : [{ index: current, free: false }];
    sel.innerHTML = '';
    seats.forEach(st => {
        const opt = document.createElement('option');
        opt.value = String(st.index);
        // Taken seats stay listed and are marked rather than hidden, so a seat
        // that will bounce you isn't a silent surprise. The ped's own seat
        // reads as taken — don't mark that one.
        const taken = !st.free && st.index !== current;
        opt.textContent = seatLabel(st.index) + (taken ? ' · ' + t('scene.seat_taken') : '');
        sel.appendChild(opt);
    });
    sel.value = String(current);
}

CC.setPedSeatIndex = function() {
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent || !ent.seat) return;
    const idx = parseInt(document.getElementById('se-seat-index').value, 10);
    putPedInVehicle(ent, ent.seat, isNaN(idx) ? -1 : idx);
};

async function putPedInVehicle(ent, ref, seatIndex) {
    const res = await postAwait('scenePutInVehicle', { entityId: ent.id, ref, seat: seatIndex });
    if (!res || !res.ok) {
        showToast(t('toasts.seat_failed'), 'error');
        renderPedSeatSection(ent);   // snap the controls back to the truth
        return false;
    }
    ent.seat = res.seat;
    if (State.selectedSceneId === ent.id) renderPedSeatSection(ent);
    showToast(t('toasts.seated', { model: res.model || '', seat: seatLabel(res.seat.index) }));
    return true;
}

CC.removePedFromVehicle = async function() {
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent || !ent.seat) return;
    const res = await postAwait('sceneRemoveFromVehicle', { entityId: ent.id });
    ent.seat = null;
    if (res && res.pos) {
        // Lua stood the ped beside the car — the position boxes at the bottom
        // of the panel are still showing where it used to be.
        ent.pos     = res.pos;
        ent.heading = (res.heading != null) ? res.heading : ent.heading;
        document.getElementById('se-pos-x').value = (ent.pos.x || 0).toFixed(1);
        document.getElementById('se-pos-y').value = (ent.pos.y || 0).toFixed(1);
        document.getElementById('se-pos-z').value = (ent.pos.z || 0).toFixed(1);
        document.getElementById('se-heading').value = Math.round(ent.heading || 0);
    }
    renderPedSeatSection(ent);
    showToast(t('toasts.left_vehicle'));
};

// Lua dropped a seat under us: the car was deleted or claimed by a recording,
// or the ped was repositioned and had to step out first.
function onSceneSeatsCleared(d) {
    const ids = (d && d.entityIds) || [];
    let touched = false;
    ids.forEach(id => {
        const ent = State.sceneEntities.find(e => e.id === id);
        if (ent && ent.seat) { ent.seat = null; touched = true; }
    });
    if (!touched) return;
    const sel = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (sel && sel.type === 'ped') renderPedSeatSection(sel);
}

// ── Vehicle picking ─────────────────────────────────────────────────────────
// Click "Put in vehicle" and the editor hands you the placement freecam with a
// crosshair: fly to the car you mean, look at it, ENTER. Lua owns the whole
// mode (it owns the camera and the ray), so everything here is a view over the
// messages it sends — which is also why there is no key handling in this file
// for it: NUI has no focus while the freecam is up.
//
// Any car is a valid target — one the editor placed, a recording puppet, or a
// car that was just parked there — so there is no precondition to check before
// entering the mode.

CC.startVehiclePick = function() {
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent || ent.type !== 'ped') return;
    State.vehiclePickPedId = ent.id;
    post('startVehiclePick', { entityId: ent.id });
};

function onVehiclePickOverlay(active) {
    State.isVehiclePicking = active;
    if (active) {
        PlacementGuide.show('seat');
        document.getElementById('side-panel').classList.add('dimmed');
    } else {
        PlacementGuide.hide();
        document.getElementById('side-panel').classList.remove('dimmed');
        State.vehiclePickPedId = null;
    }
}

// Cancel from this side — the editor closing, or a take starting. Lua tears the
// freecam down and echoes vehiclePickActive:false back, which does the rest.
function endVehiclePick() {
    if (!State.isVehiclePicking) return;
    post('vehiclePickEnd');
    onVehiclePickOverlay(false);
}

// The car under the crosshair right now, or null when the crosshair is on sky,
// scenery, or a ped.
function setPickTarget(label) {
    const el = document.getElementById('pg-target');
    if (!el) return;
    el.classList.toggle('on-target', !!label);
    el.textContent = label ? t('scene.pick_vehicle_on', { model: label })
                           : t('scene.pick_vehicle_prompt');
}

async function onVehiclePickResult(d) {
    onVehiclePickOverlay(false);
    const ent = State.sceneEntities.find(e => e.id === d.entityId);
    if (!ent || !d.ref) return;
    // Default to the first free seat, driver first — that's what "put him in
    // that car" means nine times out of ten. An empty Lua table arrives as an
    // object rather than an array, so don't call .find on it blind.
    const seats = Array.isArray(d.seats) ? d.seats : [];
    const free  = seats.find(st => st.free);
    if (!free) { showToast(t('toasts.seat_failed'), 'error'); openSceneEntityProps(ent.id); return; }
    await putPedInVehicle(ent, d.ref, free.index);
    openSceneEntityProps(ent.id);
}

// ── Open entity properties (separate view) ───────────────────────────────────
function openSceneEntityProps(id) {
    State.selectedSceneId = id;
    const ent = State.sceneEntities.find(e => e.id === id);
    if (!ent) return;

    // Switch to props view
    hideAllViews();
    document.getElementById('sp-scene-props-view').classList.remove('hidden');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');

    const typeLabel = ent.type === 'ped' ? t('scene.type_ped') : ent.type === 'vehicle' ? t('scene.type_vehicle') : t('scene.type_prop');
    document.getElementById('sp-title').textContent = t('scene.title_entity', { type: typeLabel, model: ent.model });

    // Show correct property panel
    document.getElementById('se-ped-props').classList.toggle('hidden', ent.type !== 'ped');
    document.getElementById('se-veh-props').classList.toggle('hidden', ent.type !== 'vehicle');
    document.getElementById('se-prop-props').classList.toggle('hidden', ent.type !== 'prop');

    // Refresh the rpemotes-vs-native anim section visibility every time a ped
    // is opened so installing/removing the fork mid-session is reflected
    // without requiring an editor reload.
    if (ent.type === 'ped') updateSceneAnimMode();

    // Show/hide "Edit Appearance" section for freemode peds
    if (ent.type === 'ped') {
        const isFreemode = ent.model === 'mp_m_freemode_01' || ent.model === 'mp_f_freemode_01';
        const appSection = document.getElementById('se-ped-appearance-section');
        if (appSection) appSection.classList.toggle('hidden', !isFreemode);
        renderPedSeatSection(ent);
    }

    // The preset name boxes are per-save, not per-entity — a name left over
    // from the last thing you saved would silently rename this one.
    ['se-preset-name', 'se-veh-preset-name'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.value = '';
    });

    // Populate position
    if (ent.pos) {
        document.getElementById('se-pos-x').value = (ent.pos.x || 0).toFixed(1);
        document.getElementById('se-pos-y').value = (ent.pos.y || 0).toFixed(1);
        document.getElementById('se-pos-z').value = (ent.pos.z || 0).toFixed(1);
    }
    document.getElementById('se-heading').value = Math.round(ent.heading || 0);

    // ── Ped state ──
    if (ent.type === 'ped') {
        const fb = document.getElementById('se-ped-follow-btn');
        fb.textContent = ent.followPlayer ? t('ui.on') : t('ui.off');
        fb.classList.toggle('active', !!ent.followPlayer);
        // Follow settings — always populate from this entity so previous values don't leak
        document.getElementById('se-follow-dist').value  = ent.followDist  ?? 5;
        const pSpdSel = document.getElementById('se-follow-speed');
        pSpdSel.value = String(ent.followSpeed ?? 1.0);
        pSpdSel.dispatchEvent(new Event('change', { bubbles: false }));
        // Group + Combat
        populatePedGroupDropdown();
        document.getElementById('se-ped-group').value = ent.group || '';
        document.getElementById('se-ped-combat-ability').value = ent.combatAbility ?? 1;
        document.getElementById('se-ped-combat-movement').value = ent.combatMovement ?? 2;
        document.getElementById('se-ped-combat-range').value = ent.combatRange ?? 1;
        document.getElementById('se-ped-accuracy').value = ent.accuracy ?? 50;
        document.getElementById('se-ped-accuracy-val').textContent = ent.accuracy ?? 50;
        // Health
        document.getElementById('se-ped-health').value = ent.health || 200;
        document.getElementById('se-ped-health-val').value = ent.health || 200;
        document.getElementById('se-ped-armor').value = ent.armor || 0;
        document.getElementById('se-ped-armor-val').value = ent.armor || 0;
        const setToggle = (id, val) => { const b = document.getElementById(id); b.textContent = val ? t('ui.on') : t('ui.off'); b.classList.toggle('active', val); };
        setToggle('se-ped-invincible-btn', ent.invincible !== false);
        setToggle('se-ped-ragdoll-btn', ent.ragdoll !== false);
        setToggle('se-ped-flee-btn', ent.flee === true);
    }

    // ── Vehicle state ──
    if (ent.type === 'vehicle') {
        // setToggle MUST coerce to boolean — classList.toggle(c, undefined) is
        // treated by CEF as "no force given" and toggles the current state
        // instead of removing the class. That's how every untouched control
        // (engine/siren/neon/follow/doors/indicators) ended up stuck active.
        const setToggle = (id, val) => {
            const b = document.getElementById(id);
            const on = !!val;
            b.textContent = on ? t('ui.on') : t('ui.off');
            b.classList.toggle('active', on);
        };
        setToggle('se-veh-follow-btn', ent.followPlayer);
        // Chase settings — always populate from this entity so previous values don't leak
        document.getElementById('se-veh-follow-dist').value  = ent.followDist  ?? 10;
        const spdSel = document.getElementById('se-veh-follow-speed');
        spdSel.value = String(ent.followSpeed ?? 25);
        spdSel.dispatchEvent(new Event('change', { bubbles: false }));
        const dsSel = document.getElementById('se-veh-drive-style');
        dsSel.value = String(ent.driveStyle ?? 786603);
        dsSel.dispatchEvent(new Event('change', { bubbles: false }));
        // Escort (gentle follow) settings
        setToggle('se-veh-escort-btn', ent.escortPlayer);
        document.getElementById('se-veh-escort-dist').value = ent.escortDist ?? 8;
        const escSpdSel = document.getElementById('se-veh-escort-speed');
        escSpdSel.value = String(ent.escortSpeed ?? 15);
        escSpdSel.dispatchEvent(new Event('change', { bubbles: false }));
        const escDsSel = document.getElementById('se-veh-escort-style');
        escDsSel.value = String(ent.escortStyle ?? 786603);
        escDsSel.dispatchEvent(new Event('change', { bubbles: false }));
        setToggle('se-veh-engine-btn', ent.engine);
        setToggle('se-veh-siren-btn', ent.siren);
        setToggle('se-veh-neon-btn', ent.neon);
        // Lights mode (OFF/LOW/HIGH/INT) — scoped to the ENGINE & LIGHTS section.
        const lightBtns = document.querySelectorAll('#se-veh-props .sp-section:first-child .se-sm-btn');
        const lightMode = ent.lightMode | 0;
        lightBtns.forEach((b, i) => b.classList.toggle('active', i === lightMode));
        // Doors — selector matches both DOORS (6) and WINDOWS (4) grids; doors come first.
        const doorBtns = document.querySelectorAll('#se-veh-props .sp-section:nth-child(2) .se-grid-btn');
        doorBtns.forEach((b, i) => b.classList.toggle('active', !!(ent.doors && ent.doors[i])));
        // Windows — separate section so we don't leak smash state between vehicles.
        const winBtns = document.querySelectorAll('#se-veh-props .sp-section:nth-child(3) .se-grid-btn');
        winBtns.forEach((b, i) => b.classList.toggle('active', !!(ent.windows && ent.windows[i])));
        // Indicators — `hazard` is its own state, not derived from left+right, so
        // toggling individual blinkers doesn't make HAZARD light up too.
        const ind = ent.indicators || {};
        document.getElementById('se-veh-ind-left').classList.toggle('active', !!ind.left && !ent.hazard);
        document.getElementById('se-veh-ind-right').classList.toggle('active', !!ind.right && !ent.hazard);
        document.getElementById('se-veh-ind-hazard').classList.toggle('active', !!ent.hazard);
        // Appearance — always set (not conditionally) so previous entity values don't leak
        document.getElementById('se-veh-color1').value = ent.color1 || '#000000';
        document.getElementById('se-veh-color2').value = ent.color2 || '#000000';
        document.getElementById('se-veh-dirt').value = ent.dirtLevel || 0;
        document.getElementById('se-veh-dirt-val').textContent = ent.dirtLevel || 0;
        document.getElementById('se-veh-plate').value = ent.plateText || '';
        document.getElementById('se-veh-neon-color').value = ent.neonColor || '#0000ff';
        // Livery / extras / mods are per-model — fetched live from the vehicle
        refreshVehCustomization(ent);
    }

    // ── Prop state ──
    if (ent.type === 'prop') {
        const setToggle = (id, val) => { const b = document.getElementById(id); b.textContent = val ? t('ui.on') : t('ui.off'); b.classList.toggle('active', val); };
        setToggle('se-prop-freeze-btn', ent.frozen !== false);
        setToggle('se-prop-visible-btn', ent.visible !== false);
        setToggle('se-prop-fire-btn', ent.onFire === true);
    }

    renderSceneEntityList();
    initCustomDropdowns();

    // Focus camera on entity
    const focusDist = ent.type === 'vehicle' ? 6.0 : ent.type === 'prop' ? 4.0 : 3.0;
    post('focusEntity', { entityId: ent.id, dist: focusDist, zOff: ent.type === 'vehicle' ? 1.5 : 0.8 });
    State._entityFocused = true;
}

// ── Back from entity props to scene list ─────────────────────────────────────
CC.backFromSceneProps = function() {
    State.selectedSceneId = null;
    document.getElementById('sp-scene-props-view').classList.add('hidden');
    document.getElementById('sp-scene-view').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('scene.title');
    renderSceneEntityList();
    // Return camera to timeline position
    post('unfocusEntity');
    State._entityFocused = false;
};

// ══════════════════════════════════════════════════════════════════════════════
// PED APPEARANCE EDITOR
// ══════════════════════════════════════════════════════════════════════════════

// ── Helpers ──────────────────────────────────────────────────────────────────
function findComponent(appearance, slot) {
    if (!appearance.components) appearance.components = [];
    let c = appearance.components.find(x => x.slot === slot);
    if (!c) { c = { slot, drawable: 0, texture: 0, palette: 0 }; appearance.components.push(c); }
    return c;
}

function findProp(appearance, slot) {
    if (!appearance.props) appearance.props = [];
    let p = appearance.props.find(x => x.slot === slot);
    if (!p) { p = { slot, drawable: -1, texture: 0 }; appearance.props.push(p); }
    return p;
}

function findOverlay(appearance, slot) {
    if (!appearance.overlays) appearance.overlays = [];
    let o = appearance.overlays.find(x => x.slot === slot);
    if (!o) { o = { slot, value: 255, colourType: 1, colour1: 0, colour2: 0, opacity: 1.0 }; appearance.overlays.push(o); }
    return o;
}

function findFaceFeature(appearance, slot) {
    if (!appearance.faceFeatures) appearance.faceFeatures = [];
    let f = appearance.faceFeatures.find(x => x.slot === slot);
    if (!f) { f = { slot, value: 0 }; appearance.faceFeatures.push(f); }
    return f;
}

function scheduleAppearanceApply() {
    const edit = State.pedAppearanceEdit;
    if (!edit) return;
    if (edit.debounceTimer) clearTimeout(edit.debounceTimer);
    edit.debounceTimer = setTimeout(() => {
        post('sceneApplyPedAppearance', { entityId: edit.entityId, appearance: edit.appearance });
        // Mirror onto the saved scene-entity record so project save/export
        // includes the appearance — without this the freemode customisation
        // is only kept in the scenePedAppearances cache and is lost on save.
        const ent = State.sceneEntities.find(e => e.id === edit.entityId);
        if (ent) ent.appearance = edit.appearance;
        State.scenePedAppearances[edit.entityId] = edit.appearance;
    }, 50);
}

// ── Palette generation ───────────────────────────────────────────────────────
// 64 hair colors: approximate GTA V-style palette using HSL distribution
function buildHairPalette() {
    const colors = [
        '#1a0d00','#3b1f0a','#5a3010','#7a4520','#9b6030','#c08050','#d9a870','#f0d0a0',
        '#f5c8a0','#e8b080','#c07840','#8b5c28','#5c3010','#3a1e08','#1e0e04','#0d0602',
        '#c8c8c8','#a0a0a0','#787878','#505050','#383838','#202020','#101010','#050505',
        '#e8d0a0','#d4b870','#c0a040','#a08020','#786010','#504008','#302804','#181402',
        '#f0a060','#e07030','#c04820','#902810','#601008','#400808','#200404','#100202',
        '#a0d8f0','#60b8e0','#2090d0','#1060a0','#083070','#041848','#020830','#010418',
        '#80d080','#40a840','#208020','#0c5010','#063008','#031804','#010c02','#000601',
        '#d060d0','#a030a0','#701870','#480848','#300030','#180018','#0c000c','#060006',
    ];
    return colors;
}

// 32 eye colors
function buildEyePalette() {
    return [
        '#3a5a8a','#2d7a9a','#4a9a6a','#8a7a4a','#6a4a2a','#9a6a3a','#3a3a3a','#1a1a1a',
        '#6a8aba','#5aaaca','#6aca9a','#baba6a','#9a8a6a','#ca9a6a','#5a5a5a','#2a2a2a',
        '#9abaea','#8acafa','#8aeaca','#eaea9a','#ca9a8a','#faaa8a','#7a7a7a','#4a4a4a',
        '#badaea','#aaeaff','#aaffca','#ffffaa','#ffbaaa','#ffcaaa','#aaaaaa','#888888',
    ];
}

// 16 overlay/hair-detail colors
function buildOverlayPalette() {
    return [
        '#1a0d00','#3b1f0a','#5a3010','#7a4520','#9b6030','#c08050','#d9a870','#f0d0a0',
        '#c8c8c8','#787878','#383838','#101010','#e8d0a0','#d4b870','#c0a040','#a08020',
    ];
}

function renderPalette(containerId, colors, selectedIdx, onSelect) {
    const el = document.getElementById(containerId);
    if (!el) return;
    el.innerHTML = '';
    colors.forEach((color, i) => {
        const btn = document.createElement('button');
        btn.className = 'app-swatch' + (i === selectedIdx ? ' selected' : '');
        btn.style.background = color;
        btn.title = String(i);
        btn.addEventListener('click', () => onSelect(i));
        el.appendChild(btn);
    });
}

// ── Stepper helper ───────────────────────────────────────────────────────────
function wireAppStepper(decId, incId, valId, getVal, setVal, min, max) {
    const decBtn = document.getElementById(decId);
    const incBtn = document.getElementById(incId);
    const valEl  = document.getElementById(valId);
    if (!decBtn || !incBtn || !valEl) return;
    // `max` may be a function so the cap can change as state changes (e.g.
    // texture max depends on the currently-selected drawable for that slot).
    const resolveMax = () => (typeof max === 'function' ? max() : max);
    const resolveMin = () => (typeof min === 'function' ? min() : min);
    const writeVal = (v) => { valEl.value = String(v); };
    decBtn.addEventListener('click', () => {
        const v = Math.max(resolveMin(), getVal() - 1);
        setVal(v);
        writeVal(v);
        scheduleAppearanceApply();
    });
    incBtn.addEventListener('click', () => {
        const v = Math.min(resolveMax(), getVal() + 1);
        setVal(v);
        writeVal(v);
        scheduleAppearanceApply();
    });
    const commit = () => {
        const raw = parseInt(valEl.value, 10);
        if (Number.isNaN(raw)) { writeVal(getVal()); return; }
        const clamped = Math.min(resolveMax(), Math.max(resolveMin(), raw));
        setVal(clamped);
        writeVal(clamped);
        scheduleAppearanceApply();
    };
    valEl.addEventListener('change', commit);
    valEl.addEventListener('blur', commit);
    valEl.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') { e.preventDefault(); valEl.blur(); }
        else if (e.key === 'ArrowUp')   { e.preventDefault(); incBtn.click(); }
        else if (e.key === 'ArrowDown') { e.preventDefault(); decBtn.click(); }
    });
}

// Helpers to look up the per-slot variation cap shipped from Lua. Falls
// back to a generous default before the maxes round-trip arrives.
function compDrawableMax(slot) {
    const id = State.pedAppearanceEdit && State.pedAppearanceEdit.entityId;
    const m  = id != null && State.scenePedVariationMax[id];
    return (m && m.components && m.components[slot] && m.components[slot].drawableMax) ?? 200;
}
function compTextureMax(slot, drawable) {
    const id = State.pedAppearanceEdit && State.pedAppearanceEdit.entityId;
    const m  = id != null && State.scenePedVariationMax[id];
    if (!m || !m.components || !m.components[slot] || !m.components[slot].textures) return 200;
    return m.components[slot].textures[drawable] ?? 0;
}
function propDrawableMax(slot) {
    const id = State.pedAppearanceEdit && State.pedAppearanceEdit.entityId;
    const m  = id != null && State.scenePedVariationMax[id];
    return (m && m.props && m.props[slot] && m.props[slot].drawableMax) ?? 200;
}
function propTextureMax(slot, drawable) {
    const id = State.pedAppearanceEdit && State.pedAppearanceEdit.entityId;
    const m  = id != null && State.scenePedVariationMax[id];
    if (!m || !m.props || !m.props[slot] || drawable < 0) return 0;
    return m.props[slot].textures[drawable] ?? 0;
}

// ── Wire all controls (called once on DOMContentLoaded-equivalent) ───────────
let _appControlsWired = false;
function wireAppearanceControls() {
    if (_appControlsWired) return;
    _appControlsWired = true;

    const g = () => State.pedAppearanceEdit && State.pedAppearanceEdit.appearance;

    // HERITAGE
    wireAppStepper('app-mom-dec','app-mom-inc','app-mom-val',
        () => { const a = g(); return a ? (a.headBlend.shapeFirst || 0) : 0; },
        (v) => { const a = g(); if(!a) return; a.headBlend.shapeFirst = v; a.headBlend.skinFirst = v; },
        0, 45);
    wireAppStepper('app-dad-dec','app-dad-inc','app-dad-val',
        () => { const a = g(); return a ? (a.headBlend.shapeSecond || 0) : 0; },
        (v) => { const a = g(); if(!a) return; a.headBlend.shapeSecond = v; a.headBlend.skinSecond = v; },
        0, 45);

    const resemblanceEl = document.getElementById('app-resemblance');
    const resemblanceValEl = document.getElementById('app-resemblance-val');
    if (resemblanceEl) resemblanceEl.addEventListener('input', () => {
        const a = g(); if (!a) return;
        const v = parseFloat(resemblanceEl.value);
        a.headBlend.shapeMix = v;
        resemblanceValEl.textContent = v.toFixed(2);
        scheduleAppearanceApply();
    });

    const skinToneEl = document.getElementById('app-skin-tone');
    const skinToneValEl = document.getElementById('app-skin-tone-val');
    if (skinToneEl) skinToneEl.addEventListener('input', () => {
        const a = g(); if (!a) return;
        const v = parseFloat(skinToneEl.value);
        a.headBlend.skinMix = v;
        skinToneValEl.textContent = v.toFixed(2);
        scheduleAppearanceApply();
    });

    // HAIR style
    wireAppStepper('app-hair-style-dec','app-hair-style-inc','app-hair-style-val',
        () => { const a = g(); if(!a) return 0; return findComponent(a, 2).drawable; },
        (v) => { const a = g(); if(!a) return; findComponent(a, 2).drawable = v; },
        0, 100);

    // FACE — eyebrows (overlay slot 2)
    wireAppStepper('app-eyebrows-dec','app-eyebrows-inc','app-eyebrows-val',
        () => { const a = g(); if(!a) return 0; const o = findOverlay(a, 2); return o.value === 255 ? 0 : o.value; },
        (v) => { const a = g(); if(!a) return; findOverlay(a, 2).value = v; },
        0, 33);

    const eyebrowsOpacityEl = document.getElementById('app-eyebrows-opacity');
    const eyebrowsOpacityValEl = document.getElementById('app-eyebrows-opacity-val');
    if (eyebrowsOpacityEl) eyebrowsOpacityEl.addEventListener('input', () => {
        const a = g(); if (!a) return;
        const v = parseFloat(eyebrowsOpacityEl.value);
        findOverlay(a, 2).opacity = v;
        eyebrowsOpacityValEl.textContent = v.toFixed(2);
        scheduleAppearanceApply();
    });

    // FACE — beard (overlay slot 1)
    wireAppStepper('app-beard-dec','app-beard-inc','app-beard-val',
        () => { const a = g(); if(!a) return 0; const o = findOverlay(a, 1); return o.value === 255 ? 0 : o.value; },
        (v) => { const a = g(); if(!a) return; findOverlay(a, 1).value = v; },
        0, 28);

    const beardOpacityEl = document.getElementById('app-beard-opacity');
    const beardOpacityValEl = document.getElementById('app-beard-opacity-val');
    if (beardOpacityEl) beardOpacityEl.addEventListener('input', () => {
        const a = g(); if (!a) return;
        const v = parseFloat(beardOpacityEl.value);
        findOverlay(a, 1).opacity = v;
        beardOpacityValEl.textContent = v.toFixed(2);
        scheduleAppearanceApply();
    });

    // FACE — makeup (overlay slot 4)
    wireAppStepper('app-makeup-dec','app-makeup-inc','app-makeup-val',
        () => { const a = g(); if(!a) return 255; return findOverlay(a, 4).value; },
        (v) => { const a = g(); if(!a) return; findOverlay(a, 4).value = v; },
        0, 100);

    const makeupOpacityEl = document.getElementById('app-makeup-opacity');
    const makeupOpacityValEl = document.getElementById('app-makeup-opacity-val');
    if (makeupOpacityEl) makeupOpacityEl.addEventListener('input', () => {
        const a = g(); if (!a) return;
        const v = parseFloat(makeupOpacityEl.value);
        findOverlay(a, 4).opacity = v;
        makeupOpacityValEl.textContent = v.toFixed(2);
        scheduleAppearanceApply();
    });

    // FACE — lipstick (overlay slot 8)
    wireAppStepper('app-lipstick-dec','app-lipstick-inc','app-lipstick-val',
        () => { const a = g(); if(!a) return 255; return findOverlay(a, 8).value; },
        (v) => { const a = g(); if(!a) return; findOverlay(a, 8).value = v; },
        0, 100);

    const lipstickOpacityEl = document.getElementById('app-lipstick-opacity');
    const lipstickOpacityValEl = document.getElementById('app-lipstick-opacity-val');
    if (lipstickOpacityEl) lipstickOpacityEl.addEventListener('input', () => {
        const a = g(); if (!a) return;
        const v = parseFloat(lipstickOpacityEl.value);
        findOverlay(a, 8).opacity = v;
        lipstickOpacityValEl.textContent = v.toFixed(2);
        scheduleAppearanceApply();
    });

    // FACE — blemishes (overlay slot 0)
    wireAppStepper('app-blemishes-dec','app-blemishes-inc','app-blemishes-val',
        () => { const a = g(); if(!a) return 255; return findOverlay(a, 0).value; },
        (v) => { const a = g(); if(!a) return; findOverlay(a, 0).value = v; },
        0, 100);

    // Collapsible sections — every category but Quick Actions and Heritage
    // is collapsed by default, so the panel doesn't open as one giant scroll.
    [
        ['app-hair-header',     'app-hair-body'],
        ['app-face-header',     'app-face-body'],
        ['app-ff-header',       'app-ff-body'],
        ['app-clothing-header', 'app-clothing-body'],
        ['app-props-header',    'app-props-body'],
    ].forEach(([headerId, bodyId]) => {
        const h = document.getElementById(headerId);
        const b = document.getElementById(bodyId);
        if (!h || !b) return;
        h.addEventListener('click', () => {
            const expanded = h.classList.toggle('expanded');
            b.classList.toggle('expanded', expanded);
        });
    });

    // Build face features sliders once
    buildFaceFeatureSliders();

    // CLOTHING steppers
    const clothingSlots = [
        { slot: 11, id: 'comp11' },
        { slot: 8,  id: 'comp8'  },
        { slot: 9,  id: 'comp9'  },
        { slot: 4,  id: 'comp4'  },
        { slot: 6,  id: 'comp6'  },
        { slot: 7,  id: 'comp7'  },
        { slot: 1,  id: 'comp1'  },
        { slot: 10, id: 'comp10' },
        { slot: 5,  id: 'comp5'  },
    ];
    clothingSlots.forEach(({ slot, id }) => {
        wireAppStepper(`app-${id}-drw-dec`, `app-${id}-drw-inc`, `app-${id}-drw-val`,
            () => { const a = g(); if(!a) return 0; return findComponent(a, slot).drawable; },
            (v) => {
                const a = g(); if(!a) return;
                const c = findComponent(a, slot);
                c.drawable = v;
                // Reset texture when drawable changes — the new drawable may
                // not support the previous texture index.
                c.texture = 0;
                const tEl = document.getElementById(`app-${id}-tex-val`);
                if (tEl) tEl.value = '0';
            },
            0, () => compDrawableMax(slot));
        wireAppStepper(`app-${id}-tex-dec`, `app-${id}-tex-inc`, `app-${id}-tex-val`,
            () => { const a = g(); if(!a) return 0; return findComponent(a, slot).texture; },
            (v) => { const a = g(); if(!a) return; findComponent(a, slot).texture = v; },
            0, () => {
                const a = g(); if (!a) return 0;
                return compTextureMax(slot, findComponent(a, slot).drawable);
            });
    });

    // PROP steppers
    const propSlots = [0, 1, 2, 6, 7];
    propSlots.forEach(slot => {
        const id = `prop${slot}`;
        wireAppStepper(`app-${id}-drw-dec`, `app-${id}-drw-inc`, `app-${id}-drw-val`,
            () => { const a = g(); if(!a) return -1; return findProp(a, slot).drawable; },
            (v) => {
                const a = g(); if(!a) return;
                const p = findProp(a, slot);
                p.drawable = v;
                p.texture = 0;
                const tEl = document.getElementById(`app-${id}-tex-val`);
                if (tEl) tEl.value = '0';
            },
            -1, () => propDrawableMax(slot));
        wireAppStepper(`app-${id}-tex-dec`, `app-${id}-tex-inc`, `app-${id}-tex-val`,
            () => { const a = g(); if(!a) return 0; return findProp(a, slot).texture; },
            (v) => { const a = g(); if(!a) return; findProp(a, slot).texture = v; },
            0, () => {
                const a = g(); if (!a) return 0;
                return propTextureMax(slot, findProp(a, slot).drawable);
            });
    });
}

function buildFaceFeatureSliders() {
    const body = document.getElementById('app-ff-body');
    if (!body) return;
    const labels = [
        'Nose Width','Nose Peak Ht','Nose Length','Nose Bone Crv','Nose Tip',
        'Nose Twist','Brow High','Brow Forward','Cheekbone High','Cheekbone Width',
        'Cheek Width','Eyes Open','Lip Thickness','Jaw Width','Jaw Length',
        'Chin Lower','Chin Length','Chin Width','Chin Hole','Neck Thickness',
    ];
    body.innerHTML = '';
    labels.forEach((label, i) => {
        const row = document.createElement('div');
        row.className = 'sp-row';
        row.innerHTML = `
            <label class="sp-label" style="font-size:9px;width:72px">${label}</label>
            <input class="sp-range" type="range" id="app-ff-${i}" min="-1" max="1" step="0.1" value="0" />
            <span class="sp-input sp-input-sm" id="app-ff-${i}-val" style="pointer-events:none;text-align:center;width:40px;flex:0 0 40px">0.0</span>
        `;
        body.appendChild(row);
        const slider = document.getElementById(`app-ff-${i}`);
        const valEl  = document.getElementById(`app-ff-${i}-val`);
        if (slider) {
            slider.addEventListener('input', () => {
                const a = State.pedAppearanceEdit && State.pedAppearanceEdit.appearance;
                if (!a) return;
                const v = parseFloat(slider.value);
                findFaceFeature(a, i).value = v;
                valEl.textContent = v.toFixed(1);
                scheduleAppearanceApply();
            });
        }
    });
}

// ── Populate UI from appearance object ───────────────────────────────────────
function populateAppearanceUI() {
    const edit = State.pedAppearanceEdit;
    if (!edit || !edit.appearance) return;
    const a = edit.appearance;
    const isFreemode = !!a.freemode;

    // Heritage
    const heritageSection = document.getElementById('app-heritage-section');
    if (heritageSection) heritageSection.classList.toggle('hidden', !isFreemode);
    // Face
    const faceSection = document.getElementById('app-face-section');
    if (faceSection) faceSection.classList.toggle('hidden', !isFreemode);

    if (isFreemode && a.headBlend) {
        document.getElementById('app-mom-val').value = String(a.headBlend.shapeFirst || 0);
        document.getElementById('app-dad-val').value = String(a.headBlend.shapeSecond || 0);
        const res = a.headBlend.shapeMix != null ? a.headBlend.shapeMix : 0.5;
        const skin = a.headBlend.skinMix != null ? a.headBlend.skinMix : 0.5;
        document.getElementById('app-resemblance').value = res;
        document.getElementById('app-resemblance-val').textContent = res.toFixed(2);
        document.getElementById('app-skin-tone').value = skin;
        document.getElementById('app-skin-tone-val').textContent = skin.toFixed(2);
    }

    // Hair
    const hairComp = findComponent(a, 2);
    document.getElementById('app-hair-style-val').value = String(hairComp.drawable || 0);

    // Helper: creates a self-re-rendering swatch callback for a palette
    function makePaletteCallback(paletteId, colors, writeFn) {
        function cb(idx) {
            const aa = State.pedAppearanceEdit && State.pedAppearanceEdit.appearance;
            if (!aa) return;
            writeFn(aa, idx);
            renderPalette(paletteId, colors, idx, cb);
            scheduleAppearanceApply();
        }
        return cb;
    }

    const hairColors = buildHairPalette();
    renderPalette('app-hair-color-palette', hairColors, a.hairColor || 0,
        makePaletteCallback('app-hair-color-palette', hairColors, (aa, idx) => { aa.hairColor = idx; }));
    renderPalette('app-hair-highlight-palette', hairColors, a.hairHighlightColor || 0,
        makePaletteCallback('app-hair-highlight-palette', hairColors, (aa, idx) => { aa.hairHighlightColor = idx; }));

    // Eye color
    if (isFreemode) {
        const eyeColors = buildEyePalette();
        renderPalette('app-eye-color-palette', eyeColors, a.eyeColor || 0,
            makePaletteCallback('app-eye-color-palette', eyeColors, (aa, idx) => { aa.eyeColor = idx; }));
    }

    // Overlays
    if (isFreemode) {
        const overlayColors = buildOverlayPalette();

        const eyebrowsO = findOverlay(a, 2);
        document.getElementById('app-eyebrows-val').value = String(eyebrowsO.value === 255 ? 0 : eyebrowsO.value);
        document.getElementById('app-eyebrows-opacity').value = eyebrowsO.opacity != null ? eyebrowsO.opacity : 1;
        document.getElementById('app-eyebrows-opacity-val').textContent = (eyebrowsO.opacity != null ? eyebrowsO.opacity : 1).toFixed(2);
        renderPalette('app-eyebrows-color-palette', overlayColors, eyebrowsO.colour1 || 0,
            makePaletteCallback('app-eyebrows-color-palette', overlayColors, (aa, idx) => { findOverlay(aa, 2).colour1 = idx; }));

        const beardO = findOverlay(a, 1);
        document.getElementById('app-beard-val').value = String(beardO.value === 255 ? 0 : beardO.value);
        document.getElementById('app-beard-opacity').value = beardO.opacity != null ? beardO.opacity : 1;
        document.getElementById('app-beard-opacity-val').textContent = (beardO.opacity != null ? beardO.opacity : 1).toFixed(2);
        renderPalette('app-beard-color-palette', overlayColors, beardO.colour1 || 0,
            makePaletteCallback('app-beard-color-palette', overlayColors, (aa, idx) => { findOverlay(aa, 1).colour1 = idx; }));

        const makeupO = findOverlay(a, 4);
        document.getElementById('app-makeup-val').value = String(makeupO.value);
        document.getElementById('app-makeup-opacity').value = makeupO.opacity != null ? makeupO.opacity : 1;
        document.getElementById('app-makeup-opacity-val').textContent = (makeupO.opacity != null ? makeupO.opacity : 1).toFixed(2);
        renderPalette('app-makeup-color-palette', overlayColors, makeupO.colour1 || 0,
            makePaletteCallback('app-makeup-color-palette', overlayColors, (aa, idx) => { findOverlay(aa, 4).colour1 = idx; }));

        const lipstickO = findOverlay(a, 8);
        document.getElementById('app-lipstick-val').value = String(lipstickO.value);
        document.getElementById('app-lipstick-opacity').value = lipstickO.opacity != null ? lipstickO.opacity : 1;
        document.getElementById('app-lipstick-opacity-val').textContent = (lipstickO.opacity != null ? lipstickO.opacity : 1).toFixed(2);
        renderPalette('app-lipstick-color-palette', overlayColors, lipstickO.colour1 || 0,
            makePaletteCallback('app-lipstick-color-palette', overlayColors, (aa, idx) => { findOverlay(aa, 8).colour1 = idx; }));

        const blemishO = findOverlay(a, 0);
        document.getElementById('app-blemishes-val').value = String(blemishO.value);

        // Face features
        const labels20 = Array.from({ length: 20 }, (_, i) => i);
        labels20.forEach(i => {
            const ff = findFaceFeature(a, i);
            const slider = document.getElementById(`app-ff-${i}`);
            const valEl  = document.getElementById(`app-ff-${i}-val`);
            if (slider) slider.value = ff.value;
            if (valEl)  valEl.textContent = ff.value.toFixed(1);
        });
    }

    // Clothing
    const clothingMap = [
        { slot: 11, id: 'comp11' }, { slot: 8, id: 'comp8' },
        { slot: 9, id: 'comp9' },   { slot: 4, id: 'comp4' },
        { slot: 6, id: 'comp6' },   { slot: 7, id: 'comp7' },
        { slot: 1, id: 'comp1' },   { slot: 10, id: 'comp10' },
        { slot: 5, id: 'comp5' },
    ];
    clothingMap.forEach(({ slot, id }) => {
        const c = findComponent(a, slot);
        const drwEl = document.getElementById(`app-${id}-drw-val`);
        const texEl = document.getElementById(`app-${id}-tex-val`);
        if (drwEl) drwEl.value = String(c.drawable);
        if (texEl) texEl.value = String(c.texture);
    });

    // Props
    [0, 1, 2, 6, 7].forEach(slot => {
        const p = findProp(a, slot);
        const drwEl = document.getElementById(`app-prop${slot}-drw-val`);
        const texEl = document.getElementById(`app-prop${slot}-tex-val`);
        if (drwEl) drwEl.value = String(p.drawable);
        if (texEl) texEl.value = String(p.texture);
    });
}

// ── NUI handler ──────────────────────────────────────────────────────────────
function onScenePedAppearance(d) {
    if (!d || d.entityId == null || !d.appearance) return;
    State.scenePedAppearances[d.entityId] = d.appearance;
    if (d.maxes) State.scenePedVariationMax[d.entityId] = d.maxes;
    // Mirror onto the saved scene-entity record so project save/export
    // captures the initial snapshot (freemode default load + "copy from
    // player" both arrive through this handler).
    const ent = State.sceneEntities.find(e => e.id === d.entityId);
    if (ent) ent.appearance = d.appearance;
    const edit = State.pedAppearanceEdit;
    if (edit && edit.entityId === d.entityId) {
        edit.appearance = d.appearance;
        populateAppearanceUI();
    }
}

// ── CC API ───────────────────────────────────────────────────────────────────
CC.openPedAppearanceEditor = function() {
    const id = State.selectedSceneId;
    if (id == null) return;
    const ent = State.sceneEntities.find(e => e.id === id);
    if (!ent || ent.type !== 'ped') return;
    const isFreemode = ent.model === 'mp_m_freemode_01' || ent.model === 'mp_f_freemode_01';
    if (!isFreemode) return;

    wireAppearanceControls();

    State.pedAppearanceEdit = { entityId: id, model: ent.model, appearance: null, debounceTimer: null };

    hideAllViews();
    document.getElementById('ped-appearance-panel').classList.remove('hidden');
    document.getElementById('sp-title').textContent = t('html.panels.ped_appearance');
    document.getElementById('sp-footer').classList.remove('hidden');
    document.getElementById('sp-back-btn').classList.remove('hidden');

    if (State.scenePedAppearances[id]) {
        State.pedAppearanceEdit.appearance = State.scenePedAppearances[id];
        populateAppearanceUI();
    } else {
        post('sceneGetPedAppearance', { entityId: id });
    }
};

CC.closePedAppearanceEditor = function() {
    const edit = State.pedAppearanceEdit;
    if (edit && edit.debounceTimer) clearTimeout(edit.debounceTimer);
    State.pedAppearanceEdit = null;
    // Return to scene entity props for the ped
    const id = State.selectedSceneId;
    if (id != null) {
        openSceneEntityProps(id);
    } else {
        hideAllViews();
        document.getElementById('sp-scene-view').classList.remove('hidden');
        document.getElementById('sp-title').textContent = t('scene.title');
    }
};

CC.copyPlayerAppearanceToScenePed = function() {
    const edit = State.pedAppearanceEdit;
    if (!edit) return;
    post('sceneCopyPlayerAppearance', { entityId: edit.entityId });
};

CC.resetPedAppearance = function() {
    const edit = State.pedAppearanceEdit;
    if (!edit) return;
    post('sceneGetPedAppearance', { entityId: edit.entityId });
};

// ── Patch backToMenu to handle appearance panel ───────────────────────────────
// The existing CC.backToMenu checks sp-scene-props-view; when the appearance
// panel is open, we need to close it to go back to ped props, not main menu.
const _origBackToMenu = CC.backToMenu;
CC.backToMenu = function() {
    const pap = document.getElementById('ped-appearance-panel');
    if (pap && !pap.classList.contains('hidden')) {
        CC.closePedAppearanceEditor();
        return;
    }
    _origBackToMenu();
};

// ── Spawn ped ────────────────────────────────────────────────────────────────
CC.spawnScenePed = function() {
    const model = document.getElementById('se-ped-model').value.trim();
    if (!model) { showToast(t('errors.enter_ped_model'), 'error'); return; }
    const id  = State.nextSceneId++;
    const pos = { x: State.currentCamPos.x, y: State.currentCamPos.y, z: State.currentCamPos.z - 1.0 };
    const heading = (State.currentCamRot.z + 180) % 360;
    const ent = {
        id, type: 'ped', model, pos, heading,
        anim: null, weapon: null, followPlayer: false, followDist: 5, followSpeed: 1.0,
        _needsPlacement: true,
    };
    State.sceneEntities.push(ent);
    State.selectedSceneId = id;
    post('spawnScenePed', { id, model, pos, heading });
    renderSceneEntityList();
    document.getElementById('se-ped-model').value = '';
};

// ── Spawn vehicle ────────────────────────────────────────────────────────────
CC.spawnSceneVehicle = function() {
    const model = document.getElementById('se-veh-model').value.trim();
    if (!model) { showToast(t('errors.enter_vehicle_model'), 'error'); return; }
    const id  = State.nextSceneId++;
    const pos = { x: State.currentCamPos.x, y: State.currentCamPos.y, z: State.currentCamPos.z - 1.0 };
    const heading = (State.currentCamRot.z + 180) % 360;
    const ent = {
        id, type: 'vehicle', model, pos, heading,
        followPlayer: false, followDist: 10, followSpeed: 25, driveStyle: 786603,
        _needsPlacement: true,
    };
    State.sceneEntities.push(ent);
    State.selectedSceneId = id;
    post('spawnSceneVehicle', { id, model, pos, heading });
    renderSceneEntityList();
    document.getElementById('se-veh-model').value = '';
};

// ── Spawn callbacks ──────────────────────────────────────────────────────────
function onSceneEntitySpawned(d) {
    const ent = State.sceneEntities.find(e => e.id === d.id);
    if (ent && d.pos) {
        ent.pos = d.pos;
    }
    // Auto-enter placement mode for newly spawned entities
    if (ent && ent._needsPlacement) {
        delete ent._needsPlacement;
        State.selectedSceneId = ent.id;
        post('startScenePlacement', { entityId: ent.id, isNewSpawn: true });
    }
}

function onSceneEntityDeleted(d) {
    if (!d || d.entityId == null) return;
    State.sceneEntities = State.sceneEntities.filter(e => e.id !== d.entityId);
    if (State.selectedSceneId === d.entityId) State.selectedSceneId = null;
    renderSceneEntityList();
}

// Lua's vehicle-follow setup ran out of CreatePedInsideVehicle retries, gave
// up, re-froze the vehicle, and asked us to revert the toggle so the user
// isn't stuck looking at "Follow ON" on a vehicle that won't move.
function onSceneFollowFailed(d) {
    if (!d || d.id == null) return;
    const ent = State.sceneEntities.find(e => e.id === d.id);
    if (ent) ent.followPlayer = false;
    if (State.selectedSceneId === d.id) {
        const btn = document.getElementById('se-veh-follow-btn');
        if (btn) {
            btn.textContent = t('ui.off');
            btn.classList.remove('active');
        }
    }
    showToast(t('toasts.veh_follow_failed') || 'Vehicle follow failed to start. Try toggling again or respawning the vehicle.', 'error');
}

// Lua dropped this scene entity because a loaded recording captured the same
// real-world handle (`sourceSceneId` match) — the playback puppet will
// represent it. Mirror the removal in JS state so the entity list and the
// next project save don't try to keep restoring it.
function onSceneEntitySkipped(d) {
    if (!d || d.id == null) return;
    State.sceneEntities = State.sceneEntities.filter(e => e.id !== d.id);
    if (State.selectedSceneId === d.id) State.selectedSceneId = null;
    if (typeof renderSceneEntityList === 'function') renderSceneEntityList();
}

// ── Delete entity ────────────────────────────────────────────────────────────
CC.deleteSceneEntity = function() {
    if (State.selectedSceneId === null) return;
    const id = State.selectedSceneId;
    State.sceneEntities = State.sceneEntities.filter(e => e.id !== id);
    post('deleteSceneEntity', { entityId: id });
    CC.backFromSceneProps();
    showToast(t('toasts.entity_deleted'));
};

// ── Animations ───────────────────────────────────────────────────────────────
CC.playPresetAnim = function() {
    if (State.selectedSceneId === null) return;
    const idx = parseInt(document.getElementById('se-anim-preset').value);
    if (isNaN(idx) || !State.predefinedAnims[idx]) { showToast(t('errors.select_anim_preset'), 'error'); return; }
    const a = State.predefinedAnims[idx];
    const loop = document.getElementById('se-anim-loop').checked;
    post('scenePlayAnim', { entityId: State.selectedSceneId, dict: a.dict, name: a.anim, loop });
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (ent) ent.anim = { dict: a.dict, name: a.anim, loop };
};

CC.playCustomAnim = function() {
    if (State.selectedSceneId === null) return;
    const dict = document.getElementById('se-anim-dict').value.trim();
    const name = document.getElementById('se-anim-name').value.trim();
    if (!dict || !name) { showToast(t('errors.enter_anim_dict_name'), 'error'); return; }
    const loop = document.getElementById('se-anim-loop').checked;
    post('scenePlayAnim', { entityId: State.selectedSceneId, dict, name, loop });
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (ent) ent.anim = { dict, name, loop };
};

// ── rpemotes-routed emote section ────────────────────────────────────────────
// Populate the library dropdown with the cached emote list from the fork.
// Grouped by emoteType via <optgroup> so the user can scroll by category.
function populateEmoteLibrary() {
    const sel = document.getElementById('se-emote-library');
    if (!sel) return;
    sel.innerHTML = `<option value="">${t('ui.select_placeholder')}</option>`;
    if (!State.rpemotesLibrary || State.rpemotesLibrary.length === 0) return;

    const byType = {};
    for (const e of State.rpemotesLibrary) {
        const t = e.type || 'Emotes';
        (byType[t] = byType[t] || []).push(e);
    }
    // Stable type ordering — emotes first, then dances, props, animal, shared.
    const order = ['Emotes', 'Dances', 'PropEmotes', 'AnimalEmotes', 'Exits', 'Shared'];
    const seen = {};
    const renderGroup = (label, list) => {
        if (!list || list.length === 0) return;
        const og = document.createElement('optgroup');
        og.label = label;
        for (const e of list) {
            const opt = document.createElement('option');
            opt.value = JSON.stringify({ name: e.name, type: e.type });
            opt.textContent = e.label || e.name;
            og.appendChild(opt);
        }
        sel.appendChild(og);
    };
    for (const t of order) {
        if (byType[t]) { renderGroup(t, byType[t]); seen[t] = true; }
    }
    // Anything else not in the predefined order
    for (const t of Object.keys(byType)) {
        if (!seen[t]) renderGroup(t, byType[t]);
    }
}

// Toggle native vs rpemotes section depending on integration status.
function updateSceneAnimMode() {
    const native = document.getElementById('se-anim-section-native');
    const rpe    = document.getElementById('se-anim-section-rpemotes');
    if (!native || !rpe) return;
    if (State.rpemotesReady) {
        native.classList.add('hidden');
        rpe.classList.remove('hidden');
    } else {
        native.classList.remove('hidden');
        rpe.classList.add('hidden');
    }
}

CC.playSceneEmoteFromLibrary = function() {
    if (State.selectedSceneId === null) return;
    const raw = document.getElementById('se-emote-library').value;
    if (!raw) { showToast(t('errors.select_anim_preset'), 'error'); return; }
    let parsed;
    try { parsed = JSON.parse(raw); } catch (_e) { return; }
    post('scenePlayEmote', {
        entityId:  State.selectedSceneId,
        emote:     parsed.name,
        emoteType: parsed.type,
    });
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (ent) ent.emote = { name: parsed.name, type: parsed.type };
};

CC.playSceneEmoteFromCode = function() {
    if (State.selectedSceneId === null) return;
    const code = document.getElementById('se-emote-code').value.trim().toLowerCase();
    if (!code) { showToast(t('errors.enter_anim_dict_name'), 'error'); return; }
    // Try to look up the type from the cached library so PlayEmoteOnPed
    // routes through SharedEmoteData when needed; otherwise pass nil/default
    // and let the export fall back to EmoteData.
    const hit = State.rpemotesLibrary.find(e => (e.name || '').toLowerCase() === code);
    post('scenePlayEmote', {
        entityId:  State.selectedSceneId,
        emote:     code,
        emoteType: hit ? hit.type : null,
    });
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (ent) ent.emote = { name: code, type: hit ? hit.type : null };
};

CC.stopSceneEmote = function() {
    if (State.selectedSceneId === null) return;
    post('sceneStopEmote', { entityId: State.selectedSceneId });
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (ent) ent.emote = null;
};

// ── Weapons ──────────────────────────────────────────────────────────────────
CC.giveSceneWeapon = function() {
    if (State.selectedSceneId === null) return;
    const idx = parseInt(document.getElementById('se-weapon-preset').value);
    if (isNaN(idx) || !State.commonWeapons[idx]) { showToast(t('errors.select_weapon'), 'error'); return; }
    const w = State.commonWeapons[idx];
    post('sceneGiveWeapon', { entityId: State.selectedSceneId, weaponHash: w.hash });
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (ent) ent.weapon = w.hash;
};

// ── Follow ───────────────────────────────────────────────────────────────────
CC.togglePedFollow = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent) return;
    ent.followPlayer = !ent.followPlayer;
    ent.followDist   = parseFloat(document.getElementById('se-follow-dist').value) || 5;
    ent.followSpeed  = parseFloat(document.getElementById('se-follow-speed').value) || 1.0;
    const btn = document.getElementById('se-ped-follow-btn');
    btn.textContent = ent.followPlayer ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', ent.followPlayer);
    post('sceneSetFollow', { entityId: ent.id, follow: ent.followPlayer, dist: ent.followDist, speed: ent.followSpeed });
};

CC.toggleVehicleSceneFollow = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent) return;
    ent.followPlayer = !ent.followPlayer;
    ent.followDist   = parseFloat(document.getElementById('se-veh-follow-dist').value) || 10;
    ent.followSpeed  = parseFloat(document.getElementById('se-veh-follow-speed').value) || 25;
    ent.driveStyle   = parseInt(document.getElementById('se-veh-drive-style').value) || 786603;
    const btn = document.getElementById('se-veh-follow-btn');
    btn.textContent = ent.followPlayer ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', ent.followPlayer);
    // Mutex: chase + escort share the AI driver, so flip the other off here too.
    if (ent.followPlayer && ent.escortPlayer) {
        ent.escortPlayer = false;
        const eb = document.getElementById('se-veh-escort-btn');
        if (eb) { eb.textContent = t('ui.off'); eb.classList.remove('active'); }
    }
    post('sceneSetVehicleFollow', { entityId: ent.id, follow: ent.followPlayer, dist: ent.followDist, speed: ent.followSpeed, driveStyle: ent.driveStyle });
};

// Live-push vehicle chase settings when dropdowns/inputs change
CC.syncVehicleFollowSettings = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent || !ent.followPlayer) return;
    ent.followDist  = parseFloat(document.getElementById('se-veh-follow-dist').value) || 10;
    ent.followSpeed = parseFloat(document.getElementById('se-veh-follow-speed').value) || 25;
    ent.driveStyle  = parseInt(document.getElementById('se-veh-drive-style').value) || 786603;
    post('sceneUpdateVehicleFollowSettings', { entityId: ent.id, dist: ent.followDist, speed: ent.followSpeed, driveStyle: ent.driveStyle });
};

CC.toggleVehicleSceneEscort = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent) return;
    ent.escortPlayer = !ent.escortPlayer;
    ent.escortDist   = parseFloat(document.getElementById('se-veh-escort-dist').value) || 8;
    ent.escortSpeed  = parseFloat(document.getElementById('se-veh-escort-speed').value) || 15;
    ent.escortStyle  = parseInt(document.getElementById('se-veh-escort-style').value) || 786603;
    const btn = document.getElementById('se-veh-escort-btn');
    btn.textContent = ent.escortPlayer ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', ent.escortPlayer);
    // Mutex: enabling gentle follow cancels chase.
    if (ent.escortPlayer && ent.followPlayer) {
        ent.followPlayer = false;
        const cb_ = document.getElementById('se-veh-follow-btn');
        if (cb_) { cb_.textContent = t('ui.off'); cb_.classList.remove('active'); }
    }
    post('sceneSetVehicleEscort', { entityId: ent.id, follow: ent.escortPlayer, dist: ent.escortDist, speed: ent.escortSpeed, driveStyle: ent.escortStyle });
};

CC.syncVehicleEscortSettings = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent || !ent.escortPlayer) return;
    ent.escortDist  = parseFloat(document.getElementById('se-veh-escort-dist').value) || 8;
    ent.escortSpeed = parseFloat(document.getElementById('se-veh-escort-speed').value) || 15;
    ent.escortStyle = parseInt(document.getElementById('se-veh-escort-style').value) || 786603;
    post('sceneUpdateVehicleEscortSettings', { entityId: ent.id, dist: ent.escortDist, speed: ent.escortSpeed, driveStyle: ent.escortStyle });
};

// Live-push ped follow settings when inputs change
CC.syncPedFollowSettings = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent || !ent.followPlayer) return;
    ent.followDist  = parseFloat(document.getElementById('se-follow-dist').value) || 5;
    ent.followSpeed = parseFloat(document.getElementById('se-follow-speed').value) || 1.0;
    post('sceneUpdatePedFollowSettings', { entityId: ent.id, dist: ent.followDist, speed: ent.followSpeed });
};

// ── Prop spawn ───────────────────────────────────────────────────────────────
CC.spawnSceneProp = function() {
    const model = document.getElementById('se-prop-model').value.trim();
    if (!model) { showToast(t('errors.enter_prop_model'), 'error'); return; }
    const id  = State.nextSceneId++;
    const pos = { x: State.currentCamPos.x, y: State.currentCamPos.y, z: State.currentCamPos.z - 1.0 };
    const heading = (State.currentCamRot.z + 180) % 360;
    const ent = {
        id, type: 'prop', model, pos, heading,
        frozen: true, visible: true, onFire: false,
        _needsPlacement: true,
    };
    State.sceneEntities.push(ent);
    State.selectedSceneId = id;
    post('spawnSceneProp', { id, model, pos, heading });
    renderSceneEntityList();
    document.getElementById('se-prop-model').value = '';
};

// ── Prop settings ────────────────────────────────────────────────────────────
CC.togglePropSetting = function(key) {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent) return;
    ent[key] = !ent[key];
    const btnMap = { frozen: 'se-prop-freeze-btn', visible: 'se-prop-visible-btn', onFire: 'se-prop-fire-btn' };
    const btn = document.getElementById(btnMap[key]);
    btn.textContent = ent[key] ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', ent[key]);
    post('scenePropSetting', { entityId: ent.id, key, value: ent[key] });
};

// ── Vehicle controls ─────────────────────────────────────────────────────────
function getSelectedVeh() {
    if (State.selectedSceneId === null) return null;
    return State.sceneEntities.find(e => e.id === State.selectedSceneId && e.type === 'vehicle');
}

CC.toggleVehEngine = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    ent.engine = !ent.engine;
    const btn = document.getElementById('se-veh-engine-btn');
    btn.textContent = ent.engine ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', ent.engine);
    post('sceneVehEngine', { entityId: ent.id, on: ent.engine });
};

CC.toggleVehSiren = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    ent.siren = !ent.siren;
    const btn = document.getElementById('se-veh-siren-btn');
    btn.textContent = ent.siren ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', ent.siren);
    post('sceneVehSiren', { entityId: ent.id, on: ent.siren });
};

CC.setVehLights = function(mode) {
    const ent = getSelectedVeh(); if (!ent) return;
    ent.lightMode = mode;
    document.querySelectorAll('.se-sm-btn').forEach((b, i) => {
        if (b.closest('.sp-section')?.querySelector('.sp-section-title')?.textContent?.includes('ENGINE')) {
            // only target light buttons in the engine section
        }
    });
    // Simple: update via parent
    const btns = document.querySelectorAll('#se-veh-props .sp-section:first-child .se-sm-btn');
    btns.forEach(b => b.classList.remove('active'));
    if (btns[mode]) btns[mode].classList.add('active');
    post('sceneVehLights', { entityId: ent.id, mode });
};

CC.toggleVehDoor = function(door) {
    const ent = getSelectedVeh(); if (!ent) return;
    if (!ent.doors) ent.doors = [false,false,false,false,false,false];
    ent.doors[door] = !ent.doors[door];
    // Scope to the DOORS section — the prior selector (`.se-grid-btn` under
    // #se-veh-props) also matched the windows grid further down.
    const btns = document.querySelectorAll('#se-veh-props .sp-section:nth-child(2) .se-grid-btn');
    if (btns[door]) btns[door].classList.toggle('active', !!ent.doors[door]);
    post('sceneVehDoor', { entityId: ent.id, door, open: ent.doors[door] });
};

CC.smashVehWindow = function(win) {
    const ent = getSelectedVeh(); if (!ent) return;
    if (!ent.windows) ent.windows = [false,false,false,false];
    ent.windows[win] = true;
    const btns = document.querySelectorAll('#se-veh-props .sp-section:nth-child(3) .se-grid-btn');
    if (btns[win]) btns[win].classList.add('active');
    post('sceneVehWindow', { entityId: ent.id, window: win });
};

CC.toggleVehIndicator = function(dir) {
    const ent = getSelectedVeh(); if (!ent) return;
    if (!ent.indicators) ent.indicators = { left: false, right: false };
    if (dir === 'hazard') {
        // Hazard is its own state. Toggling it on flips both blinkers via Lua;
        // the visual stays distinct from L/R clicks (only HAZARD lights up).
        ent.hazard = !ent.hazard;
        ent.indicators.left  = ent.hazard;
        ent.indicators.right = ent.hazard;
    } else {
        // Touching a single blinker exits hazard mode.
        ent.hazard = false;
        ent.indicators[dir] = !ent.indicators[dir];
    }
    document.getElementById('se-veh-ind-left').classList.toggle('active', !!ent.indicators.left && !ent.hazard);
    document.getElementById('se-veh-ind-right').classList.toggle('active', !!ent.indicators.right && !ent.hazard);
    document.getElementById('se-veh-ind-hazard').classList.toggle('active', !!ent.hazard);
    post('sceneVehIndicator', { entityId: ent.id, left: ent.indicators.left, right: ent.indicators.right });
};

function hexToRgb(hex) {
    const r = parseInt(hex.slice(1,3), 16), g = parseInt(hex.slice(3,5), 16), b = parseInt(hex.slice(5,7), 16);
    return { r, g, b };
}

CC.setVehColor = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    const c1 = hexToRgb(document.getElementById('se-veh-color1').value);
    const c2 = hexToRgb(document.getElementById('se-veh-color2').value);
    ent.color1 = document.getElementById('se-veh-color1').value;
    ent.color2 = document.getElementById('se-veh-color2').value;
    post('sceneVehColor', { entityId: ent.id, r1: c1.r, g1: c1.g, b1: c1.b, r2: c2.r, g2: c2.g, b2: c2.b });
};

CC.setVehDirt = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    ent.dirtLevel = parseFloat(document.getElementById('se-veh-dirt').value);
    post('sceneVehDirt', { entityId: ent.id, level: ent.dirtLevel });
};

CC.setVehPlate = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    ent.plateText = document.getElementById('se-veh-plate').value;
    post('sceneVehPlate', { entityId: ent.id, text: ent.plateText });
};

CC.toggleVehNeon = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    ent.neon = !ent.neon;
    const btn = document.getElementById('se-veh-neon-btn');
    btn.textContent = ent.neon ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', ent.neon);
    post('sceneVehNeon', { entityId: ent.id, on: ent.neon });
};

CC.setVehNeonColor = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    const c = hexToRgb(document.getElementById('se-veh-neon-color').value);
    ent.neonColor = document.getElementById('se-veh-neon-color').value;
    post('sceneVehNeonColor', { entityId: ent.id, r: c.r, g: c.g, b: c.b });
};

// ── VEHICLE CUSTOMIZATION (livery / extras / wheels / mods) ─────────────────
// The available options are per-model (livery count, which extras exist, how
// many designs each mod slot has), so they're fetched live from the spawned
// vehicle every time its properties panel opens.

const VEH_MOD_LABELS = {
    0: 'Spoiler', 1: 'Front Bumper', 2: 'Rear Bumper', 3: 'Side Skirts',
    4: 'Exhaust', 6: 'Grille', 7: 'Hood', 10: 'Roof', 23: 'Wheels',
};

// Curated GTA paint palette indexes for pearlescent + wheel color
const VEH_COLOR_OPTIONS = [
    [0, 'Black'], [12, 'Matte Black'], [4, 'Silver'], [6, 'Steel Grey'],
    [111, 'Ice White'], [134, 'Pure White'], [27, 'Red'], [30, 'Blaze Red'],
    [35, 'Candy Red'], [38, 'Orange'], [37, 'Gold'], [88, 'Yellow'],
    [49, 'Dark Green'], [53, 'Green'], [54, 'Midnight Blue'], [59, 'Mariner Blue'],
    [64, 'Bright Blue'], [135, 'Hot Pink'], [145, 'Purple'], [120, 'Chrome'],
];

function ensureVehColorSelects() {
    const pearl = document.getElementById('se-veh-pearl');
    if (!pearl || pearl.options.length) return;
    // Leading blank option = "unchanged" so opening the panel never repaints the car
    const opts = '<option value="">—</option>' +
        VEH_COLOR_OPTIONS.map(([v, n]) => `<option value="${v}">${n}</option>`).join('');
    pearl.innerHTML = opts;
    document.getElementById('se-veh-wheelcolor').innerHTML = opts;
}

function vehModValLabel(m) {
    return m.index < 0 ? 'Stock' : `${m.index + 1}/${m.count}`;
}

async function refreshVehCustomization(ent) {
    ensureVehColorSelects();
    const liverySec = document.getElementById('se-veh-livery-section');
    const extrasSec = document.getElementById('se-veh-extras-section');
    const modsList  = document.getElementById('se-veh-mods-list');
    liverySec.classList.add('hidden');
    extrasSec.classList.add('hidden');
    modsList.innerHTML = '<div class="sp-hint" style="padding:4px 0">Loading…</div>';

    const d = await postAwait('sceneVehGetCustomization', { entityId: ent.id });
    if (State.selectedSceneId !== ent.id) return;  // user switched entity meanwhile
    if (!d || !d.ok) {
        modsList.innerHTML = '<div class="sp-hint" style="padding:4px 0">Vehicle not ready — reopen this panel</div>';
        return;
    }
    // Empty Lua tables arrive as {} instead of []
    d.extras = Array.isArray(d.extras) ? d.extras : [];
    d.mods   = Array.isArray(d.mods)   ? d.mods   : [];
    ent.customization = d;

    if ((d.liveryCount || 0) > 1) {
        liverySec.classList.remove('hidden');
        document.getElementById('se-veh-livery-val').textContent = `${(d.livery || 0) + 1}/${d.liveryCount}`;
    }

    const grid = document.getElementById('se-veh-extras-grid');
    grid.innerHTML = '';
    if (d.extras.length) {
        extrasSec.classList.remove('hidden');
        d.extras.forEach(ex => {
            const b = document.createElement('button');
            b.className = 'tb-btn se-grid-btn' + (ex.on ? ' active' : '');
            b.textContent = String(ex.id);
            b.onclick = () => {
                ex.on = !ex.on;
                b.classList.toggle('active', ex.on);
                post('sceneVehExtra', { entityId: ent.id, extra: ex.id, on: ex.on });
            };
            grid.appendChild(b);
        });
    }

    document.getElementById('se-veh-tint').value = String(d.windowTint >= 0 ? d.windowTint : 0);
    const wtSel = document.getElementById('se-veh-wheeltype');
    if ([...wtSel.options].some(o => o.value === String(d.wheelType))) wtSel.value = String(d.wheelType);
    const setColorSel = (id, v) => {
        const sel = document.getElementById(id);
        sel.value = [...sel.options].some(o => o.value === String(v)) ? String(v) : '';
    };
    setColorSel('se-veh-pearl', d.pearl);
    setColorSel('se-veh-wheelcolor', d.wheelColor);

    const xb = document.getElementById('se-veh-xenon-btn');
    xb.textContent = d.xenon ? t('ui.on') : t('ui.off');
    xb.classList.toggle('active', !!d.xenon);
    const xcSel = document.getElementById('se-veh-xenon-color');
    if ([...xcSel.options].some(o => o.value === String(d.xenonColor))) xcSel.value = String(d.xenonColor);

    renderVehModsList(ent);
}

function renderVehModsList(ent) {
    const wrap = document.getElementById('se-veh-mods-list');
    wrap.innerHTML = '';
    const mods = (ent.customization && ent.customization.mods) || [];
    if (!mods.length) {
        wrap.innerHTML = '<div class="sp-hint" style="padding:4px 0">No visual mods for this model</div>';
        return;
    }
    mods.forEach(m => {
        const row = document.createElement('div');
        row.className = 'sp-row';
        const label = document.createElement('label');
        label.className = 'sp-label';
        label.textContent = VEH_MOD_LABELS[m.slot] || ('Mod ' + m.slot);
        const box = document.createElement('div');
        box.className = 'se-btn-row';
        const prev = document.createElement('button');
        prev.className = 'tb-btn se-sm-btn';
        prev.innerHTML = '<i class="fa-solid fa-chevron-left"></i>';
        prev.onclick = () => CC.stepVehMod(m.slot, -1);
        const val = document.createElement('span');
        val.className = 'sp-input sp-input-sm';
        val.id = 'se-veh-mod-val-' + m.slot;
        val.style.cssText = 'pointer-events:none;text-align:center;flex:1';
        val.textContent = vehModValLabel(m);
        const next = document.createElement('button');
        next.className = 'tb-btn se-sm-btn';
        next.innerHTML = '<i class="fa-solid fa-chevron-right"></i>';
        next.onclick = () => CC.stepVehMod(m.slot, 1);
        box.append(prev, val, next);
        row.append(label, box);
        wrap.appendChild(row);
    });
}

CC.stepVehMod = function(slot, dir) {
    const ent = getSelectedVeh(); if (!ent || !ent.customization) return;
    const m = ent.customization.mods.find(x => x.slot === slot); if (!m) return;
    // Cycle: Stock (-1) → 0 … count-1 → back to Stock
    m.index += dir;
    if (m.index >= m.count) m.index = -1;
    if (m.index < -1) m.index = m.count - 1;
    const val = document.getElementById('se-veh-mod-val-' + slot);
    if (val) val.textContent = vehModValLabel(m);
    post('sceneVehMod', { entityId: ent.id, slot, index: m.index });
};

CC.stepVehLivery = function(dir) {
    const ent = getSelectedVeh(); if (!ent || !ent.customization) return;
    const d = ent.customization;
    if (!d.liveryCount || d.liveryCount < 2) return;
    d.livery = ((d.livery || 0) + dir + d.liveryCount) % d.liveryCount;
    document.getElementById('se-veh-livery-val').textContent = `${d.livery + 1}/${d.liveryCount}`;
    post('sceneVehLivery', { entityId: ent.id, index: d.livery, isMod: !!d.liveryIsMod });
};

CC.setVehWindowTint = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    post('sceneVehWindowTint', { entityId: ent.id, tint: parseInt(document.getElementById('se-veh-tint').value, 10) });
};

CC.setVehExtraColours = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    const p = document.getElementById('se-veh-pearl').value;
    const w = document.getElementById('se-veh-wheelcolor').value;
    if (p === '' && w === '') return;
    post('sceneVehExtraColours', {
        entityId: ent.id,
        pearl: p === '' ? -1 : parseInt(p, 10),   // -1 = keep current
        wheel: w === '' ? -1 : parseInt(w, 10),
    });
};

CC.setVehWheelType = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    post('sceneVehWheelType', { entityId: ent.id, wheelType: parseInt(document.getElementById('se-veh-wheeltype').value, 10) });
    // Wheel-design counts depend on the type — refetch the mod list
    setTimeout(() => { if (State.selectedSceneId === ent.id) refreshVehCustomization(ent); }, 200);
};

CC.toggleVehXenon = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    const c = ent.customization || (ent.customization = {});
    c.xenon = !c.xenon;
    const b = document.getElementById('se-veh-xenon-btn');
    b.textContent = c.xenon ? t('ui.on') : t('ui.off');
    b.classList.toggle('active', !!c.xenon);
    post('sceneVehXenon', { entityId: ent.id, on: c.xenon });
};

CC.setVehXenonColor = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    // Picking a color enables xenon too (the color is invisible otherwise)
    const c = ent.customization || (ent.customization = {});
    c.xenon = true;
    const b = document.getElementById('se-veh-xenon-btn');
    b.textContent = t('ui.on');
    b.classList.add('active');
    post('sceneVehXenonColor', { entityId: ent.id, color: parseInt(document.getElementById('se-veh-xenon-color').value, 10) });
};

CC.fixVehicle = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    ent.dirtLevel = 0;
    ent.windows = [false, false, false, false];
    document.getElementById('se-veh-dirt').value = 0;
    document.getElementById('se-veh-dirt-val').textContent = '0';
    document.querySelectorAll('#se-veh-props .sp-section:nth-child(3) .se-grid-btn').forEach(b => b.classList.remove('active'));
    post('sceneVehFix', { entityId: ent.id });
};

CC.maxTuneVehicle = function() {
    const ent = getSelectedVeh(); if (!ent) return;
    post('sceneVehMaxTune', { entityId: ent.id });
    showToast(t('toasts.max_tune_applied'), 'success');
};

// ═══════════════════════════════════════════════════════════════════════════════
// RELATIONSHIP GROUPS
// ═══════════════════════════════════════════════════════════════════════════════

const GROUP_COLORS = ['#4a9df0','#e06060','#5cb85c','#e0a030','#c060e0','#60c0c0','#e06090','#90e060'];
const REL_CYCLE = ['neutral', 'friendly', 'hostile'];

// State.relGroups = [{ name, color }]   — "Director" always at index 0
// State.relMatrix = { "GroupA->GroupB": "neutral"|"friendly"|"hostile" }
if (!State.relGroups) State.relGroups = [{ name: 'Director', color: '#4a9df0' }];
// Lua's JSON encoder serializes empty tables as [] (array). Coerce back to plain object
// so "A->B" property writes don't get dropped by JSON.stringify.
if (!State.relMatrix || Array.isArray(State.relMatrix)) State.relMatrix = {};

function getRelKey(a, b) { return a + '->' + b; }
function ensureMatrix() {
    if (!State.relMatrix || Array.isArray(State.relMatrix)) State.relMatrix = {};
}
function getRelation(a, b) { ensureMatrix(); return State.relMatrix[getRelKey(a, b)] || 'neutral'; }
function setRelation(a, b, rel) {
    ensureMatrix();
    State.relMatrix[getRelKey(a, b)] = rel;
    State.relMatrix[getRelKey(b, a)] = rel; // symmetric
}

CC.createRelGroup = async function() {
    const name = document.getElementById('se-group-name').value.trim();
    if (!name) { showToast(t('errors.enter_group_name'), 'error'); return; }
    if (State.relGroups.find(g => g.name.toLowerCase() === name.toLowerCase())) {
        showToast(t('errors.group_already_exists'), 'error'); return;
    }
    const color = GROUP_COLORS[State.relGroups.length % GROUP_COLORS.length];
    State.relGroups.push({ name, color });
    document.getElementById('se-group-name').value = '';
    renderRelGroupList();
    syncRelGroupsToLua();
    autoSaveProject();
    showToast(t('toasts.group_created', { name: name }));
};

CC.deleteRelGroup = async function(name) {
    if (name === 'Director') { showToast(t('errors.cannot_delete_director'), 'error'); return; }
    if (!await nuiConfirm(t('ui.confirm_delete_group_title'), t('ui.confirm_delete_group_message', { name: name }))) return;
    State.relGroups = State.relGroups.filter(g => g.name !== name);
    // Clean matrix entries
    for (const key of Object.keys(State.relMatrix)) {
        if (key.includes(name + '->') || key.includes('->' + name)) delete State.relMatrix[key];
    }
    // Unassign peds
    State.sceneEntities.filter(e => e.group === name).forEach(e => e.group = '');
    renderRelGroupList();
    syncRelGroupsToLua();
    autoSaveProject();
};

CC.openRelMatrix = function() {
    document.getElementById('rel-matrix-modal').classList.remove('hidden');
    renderRelMatrix();
};

CC.closeRelMatrix = function() {
    document.getElementById('rel-matrix-modal').classList.add('hidden');
};

function renderRelGroupList() {
    const list = document.getElementById('se-group-list');
    list.innerHTML = '';
    State.relGroups.forEach(g => {
        const item = document.createElement('div');
        item.className = 'se-group-item';
        const isDel = g.name !== 'Director';
        item.innerHTML = `
            <div class="se-group-color" style="background:${g.color}"></div>
            <span class="se-group-name">${g.name}</span>
            <div class="se-group-actions">
                <button onclick="CC.openRelMatrix()" title="Edit relationships"><i class="fa-solid fa-arrows-left-right"></i></button>
                ${isDel ? `<button onclick="CC.deleteRelGroup('${g.name}')" title="Delete"><i class="fa-solid fa-trash"></i></button>` : ''}
            </div>
        `;
        list.appendChild(item);
    });
    // Update ped group dropdowns
    populatePedGroupDropdown();
}

function populatePedGroupDropdown() {
    const sel = document.getElementById('se-ped-group');
    if (!sel) return;
    const current = sel.value;
    sel.innerHTML = `<option value="">${t('ui.none_placeholder')}</option>`;
    State.relGroups.forEach(g => {
        const opt = document.createElement('option');
        opt.value = g.name;
        opt.textContent = g.name;
        sel.appendChild(opt);
    });
    sel.value = current;
    initCustomDropdowns();
}

function renderRelMatrix() {
    const grid = document.getElementById('rmm-grid');
    const groups = State.relGroups;
    const n = groups.length;
    grid.style.gridTemplateColumns = `80px repeat(${n}, 1fr)`;
    grid.innerHTML = '';

    // Top-left empty corner
    grid.appendChild(Object.assign(document.createElement('div'), { className: 'rmm-cell header', textContent: '' }));
    // Column headers
    groups.forEach(g => {
        const cell = document.createElement('div');
        cell.className = 'rmm-cell header';
        cell.textContent = g.name;
        cell.style.color = g.color;
        grid.appendChild(cell);
    });

    // Rows
    groups.forEach((rowG, ri) => {
        // Row header
        const rh = document.createElement('div');
        rh.className = 'rmm-cell header';
        rh.textContent = rowG.name;
        rh.style.color = rowG.color;
        rh.style.textAlign = 'right';
        rh.style.paddingRight = '8px';
        grid.appendChild(rh);

        groups.forEach((colG, ci) => {
            const cell = document.createElement('div');
            if (ri === ci) {
                cell.className = 'rmm-cell self';
                cell.textContent = '—';
            } else {
                const rel = getRelation(rowG.name, colG.name);
                cell.className = 'rmm-cell ' + rel;
                cell.textContent = rel.substring(0, 4);
                cell.addEventListener('click', () => {
                    const cur = getRelation(rowG.name, colG.name);
                    const next = REL_CYCLE[(REL_CYCLE.indexOf(cur) + 1) % REL_CYCLE.length];
                    setRelation(rowG.name, colG.name, next);
                    syncRelGroupsToLua();
                    autoSaveProject();
                    renderRelMatrix();
                });
            }
            grid.appendChild(cell);
        });
    });
}

function syncRelGroupsToLua() {
    post('sceneSetRelGroups', {
        groups: State.relGroups,
        matrix: State.relMatrix,
    });
}

State.sceneCombatActive = false;

function renderCombatToggle() {
    const btn = document.getElementById('se-combat-toggle');
    if (!btn) return;
    const active = !!State.sceneCombatActive;
    btn.classList.toggle('danger', active);
    btn.innerHTML = active
        ? '<i class="fa-solid fa-stop"></i>&nbsp;<span>' + t('html.buttons.combat_stop') + '</span>'
        : '<i class="fa-solid fa-play"></i>&nbsp;<span>' + t('html.buttons.combat_start') + '</span>';
}

CC.toggleSceneCombat = function() {
    // Resync groups/matrix so Lua's relationship state is fresh before tasking combat.
    post('sceneSetRelGroups', { groups: State.relGroups, matrix: State.relMatrix });
    post('sceneToggleCombat', {});
};

function onSceneCombatState(d) {
    State.sceneCombatActive = !!(d && d.active);
    renderCombatToggle();
}

CC.resetScene = function() {
    post('sceneResetPositions', {});
    showToast(t('toasts.scene_reset'));
};

CC.clearScene = async function() {
    if (!State.sceneEntities || State.sceneEntities.length === 0) {
        showToast(t('toasts.scene_already_empty') || 'Scene already empty');
        return;
    }
    const ok = await nuiConfirm(
        t('ui.confirm_clear_scene_title') || 'Clear scene?',
        (t('ui.confirm_clear_scene_message') || 'Remove all {count} scene-editor entities? This cannot be undone.')
            .replace('{count}', State.sceneEntities.length)
    );
    if (!ok) return;
    State.sceneEntities.forEach(ent => post('deleteSceneEntity', { entityId: ent.id }));
    State.sceneEntities = [];
    if (typeof renderSceneEntityList === 'function') renderSceneEntityList();
    showToast(t('toasts.scene_cleared') || 'Scene cleared');
};

// ── Ped combat & health ──────────────────────────────────────────────────────
CC.applyPedCombat = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent) return;
    ent.group = document.getElementById('se-ped-group').value;
    ent.combatAbility = parseInt(document.getElementById('se-ped-combat-ability').value);
    ent.combatMovement = parseInt(document.getElementById('se-ped-combat-movement').value);
    ent.combatRange = parseInt(document.getElementById('se-ped-combat-range').value);
    ent.accuracy = parseInt(document.getElementById('se-ped-accuracy').value);
    post('scenePedCombat', {
        entityId: ent.id, group: ent.group,
        ability: ent.combatAbility, movement: ent.combatMovement,
        range: ent.combatRange, accuracy: ent.accuracy,
    });
    showToast(t('toasts.combat_applied'));
};

CC.togglePedState = function(key) {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent) return;
    const btnMap = { invincible: 'se-ped-invincible-btn', ragdoll: 'se-ped-ragdoll-btn', flee: 'se-ped-flee-btn' };
    if (ent[key] === undefined) ent[key] = key === 'flee' ? false : true;
    ent[key] = !ent[key];
    const btn = document.getElementById(btnMap[key]);
    btn.textContent = ent[key] ? t('ui.on') : t('ui.off');
    btn.classList.toggle('active', ent[key]);
};

CC.applyPedHealth = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent) return;
    ent.health = parseInt(document.getElementById('se-ped-health-val').value) || 200;
    ent.armor = parseInt(document.getElementById('se-ped-armor-val').value) || 0;
    post('scenePedHealth', {
        entityId: ent.id, health: ent.health, armor: ent.armor,
        invincible: ent.invincible !== false, canRagdoll: ent.ragdoll !== false, flee: ent.flee === true,
    });
    showToast(t('toasts.health_applied'));
};

CC.playPedScenario = function() {
    if (State.selectedSceneId === null) return;
    const scenario = document.getElementById('se-ped-scenario').value;
    if (!scenario) { showToast(t('errors.select_scenario'), 'error'); return; }
    post('scenePedScenario', { entityId: State.selectedSceneId, scenario });
};

CC.stopPedScenario = function() {
    if (State.selectedSceneId === null) return;
    post('scenePedStopScenario', { entityId: State.selectedSceneId });
};

// ── Position update from inputs ──────────────────────────────────────────────
CC.updateSceneEntityPos = function() {
    if (State.selectedSceneId === null) return;
    const ent = State.sceneEntities.find(e => e.id === State.selectedSceneId);
    if (!ent) return;
    ent.pos = {
        x: parseFloat(document.getElementById('se-pos-x').value) || 0,
        y: parseFloat(document.getElementById('se-pos-y').value) || 0,
        z: parseFloat(document.getElementById('se-pos-z').value) || 0,
    };
    ent.heading = parseFloat(document.getElementById('se-heading').value) || 0;
    post('sceneUpdatePos', { entityId: ent.id, pos: ent.pos, heading: ent.heading });
};

// ── Placement mode ───────────────────────────────────────────────────────────
CC.startScenePlacement = function() {
    if (State.selectedSceneId === null) return;
    post('startScenePlacement', { entityId: State.selectedSceneId });
};

function onScenePlacementOverlay(active) {
    State.isScenePlacing = active;
    if (active) {
        PlacementGuide.show('scene');
        document.getElementById('side-panel').classList.add('dimmed');
    } else {
        PlacementGuide.hide();
        document.getElementById('side-panel').classList.remove('dimmed');
        // If cancelled, open scene editor list
        if (State.selectedSceneId !== null) {
            CC.openSceneEditor();
        }
    }
}

function onScenePlacementDone(d) {
    onScenePlacementOverlay(false);
    if (!d || !d.pos) return;
    const ent = State.sceneEntities.find(e => e.id === d.entityId);
    if (ent) {
        ent.pos     = d.pos;
        ent.heading = d.heading || ent.heading;
    }
    showToast(t('toasts.entity_placed'));
    // Open entity properties after placement
    if (ent) openSceneEntityProps(ent.id);
}

// ═══════════════════════════════════════════════════════════════════════════════
// CINEMATIC EFFECTS OVERLAY (rendered during playback via NUI messages from Lua)
// ═══════════════════════════════════════════════════════════════════════════════

// Editor-time preview ceilings. On playback (and on an export-staged frame)
// effects render exactly as authored — full black is full black. While you're
// EDITING, a keyframe sitting at fade 1.0 turns the viewport into an opaque
// wall: you can't frame the next shot, you can't see which keyframe you're on,
// and the way out isn't obvious when there's nothing on screen to aim at. So
// the editor preview is capped — the effect still reads, the picture never
// disappears — and the badge reports the real authored value so nobody
// mistakes the cap for what gets exported.
const FX_EDIT_CAP = {
    fade:      0.60,
    vignette:  0.70,
    grain:     0.35,
    letterbox: 0.25,   // max share of the screen height per bar
    wipe:      0.65,   // a solid bar mid-sweep hides the shot you're framing
};

/// '#rrggbb' → 'r,g,b' for building rgba() gradient stops. Anything we can't
/// parse falls back to black rather than throwing mid-frame.
function hexToRgbTriplet(hex) {
    const m = /^#?([0-9a-f]{6})$/i.exec(String(hex || '').trim());
    if (!m) return '0,0,0';
    const n = parseInt(m[1], 16);
    return `${(n >> 16) & 255},${(n >> 8) & 255},${n & 255}`;
}

/// True when nothing of the editor is on screen and the overlay owns the whole
/// frame: during playback, and from the moment an export stages its first frame
/// (prepareExport runs with isPlaying still false, but the recorder is already
/// capturing — a clipped or capped overlay there would bake a wrong-looking
/// frame into the video).
function isFxFullscreen() {
    return !!(State.isPlaying || State.exportStaging || State.exportActive);
}

function onFxUpdate(d) {
    const overlay = document.getElementById('fx-overlay');
    const full    = isFxFullscreen();
    overlay.style.display = 'block';
    // Derive the geometry from the live playback state on every update rather
    // than trusting the class to have been toggled by the start/stop handlers.
    // A clear in the middle of a take used to drop .playback, and every effect
    // for the rest of that take then rendered clipped to the editor viewport —
    // a fade-out that left the left and bottom edges of the shot unfaded.
    overlay.classList.toggle('playback', full);

    // Real fade value when it had to be capped for the editor; null otherwise.
    let cappedFade = null;

    // Fade
    const fade = document.getElementById('fx-fade');
    const fadeType   = d.fadeType   || 'none';
    const fadeAmount = d.fadeAmount || 0;
    if (fadeType !== 'none' && fadeAmount > 0) {
        const shown = full ? fadeAmount : Math.min(fadeAmount, FX_EDIT_CAP.fade);
        if (shown < fadeAmount) cappedFade = fadeAmount;
        fade.style.background = fadeType === 'white' ? 'white' : 'black';
        fade.style.opacity = shown;
    } else {
        fade.style.opacity = 0;
    }

    // Vignette
    const vig = document.getElementById('fx-vignette');
    const vigRaw    = d.vignette || 0;
    const vigAmount = full ? vigRaw : Math.min(vigRaw, FX_EDIT_CAP.vignette);
    if (vigAmount > 0) {
        const spread = Math.round(120 - vigAmount * 80);
        const blur   = Math.round(60 + vigAmount * 80);
        vig.style.boxShadow = `inset 0 0 ${blur}px ${spread}px rgba(0,0,0,${vigAmount * 0.9})`;
        vig.style.opacity = 1;
    } else {
        vig.style.opacity = 0;
    }

    // Letterbox
    const lbTop    = document.getElementById('fx-letterbox-top');
    const lbBottom = document.getElementById('fx-letterbox-bottom');
    const ratio    = d.letterbox || 0;
    if (ratio > 0) {
        const screenRatio = window.innerWidth / window.innerHeight;
        if (ratio < screenRatio) {
            const targetH = window.innerWidth / ratio;
            let barH = Math.max(0, (window.innerHeight - targetH) / 2);
            if (!full) barH = Math.min(barH, window.innerHeight * FX_EDIT_CAP.letterbox);
            lbTop.style.height    = barH + 'px';
            lbBottom.style.height = barH + 'px';
        } else {
            lbTop.style.height    = '0';
            lbBottom.style.height = '0';
        }
    } else {
        lbTop.style.height    = '0';
        lbBottom.style.height = '0';
    }

    // Grain
    const grain    = document.getElementById('fx-grain');
    const grainRaw = d.grain || 0;
    grain.style.opacity = full ? grainRaw : Math.min(grainRaw, FX_EDIT_CAP.grain);

    // Wipe. Lua sends `progress` on a 0..2 scale — 0 and 2 are the bar fully
    // clear of the frame on either side, 1 is the covering moment the cut is
    // buried in. Outside that range there is nothing to draw.
    applyWipeStyle(d.wipe, full);

    updateFxCapBadge(cappedFade);
}

/// Positions the wipe bar for one frame. Kept separate from onFxUpdate so the
/// keyframe preview path can drive it directly at a fixed progress.
function applyWipeStyle(w, full) {
    const el = document.getElementById('fx-wipe');
    if (!el) return;

    const p = w && typeof w.progress === 'number' ? w.progress : -1;
    if (!w || w.type === 'none' || p <= 0 || p >= 2) {
        el.style.display = 'none';
        return;
    }

    const rgb      = hexToRgbTriplet(w.color);
    const softPct  = Math.max(0, Math.min(0.4, w.softness || 0)) * 100;
    const angle    = w.angle || 0;
    // 0..2 → -200%..+200% of the bar's own width, so p=1 lands it dead centre.
    const travel   = (p - 1) * 200;

    el.style.display   = 'block';
    el.style.opacity   = full ? 1 : FX_EDIT_CAP.wipe;
    el.style.transform = `rotate(${angle}deg) translateX(${travel}%) scale(2.4)`;
    el.style.background = softPct > 0
        ? `linear-gradient(to right, rgba(${rgb},0) 0%, rgb(${rgb}) ${softPct}%, rgb(${rgb}) ${100 - softPct}%, rgba(${rgb},0) 100%)`
        : `rgb(${rgb})`;
}

/// Small readout in the corner of the viewport while the editor preview is
/// holding an effect below its authored strength. Only the fade earns one —
/// it's the effect that can take the whole picture away, so it's the one you
/// need told about. `real` is the authored 0-1 value, or null to hide.
function updateFxCapBadge(real) {
    const badge = document.getElementById('fx-badge');
    if (!badge) return;
    if (real === null) { badge.classList.add('hidden'); return; }
    badge.classList.remove('hidden');
    badge.innerHTML = '<i class="fa-solid fa-eye-slash"></i>' +
                      '<span>' + Math.round(real * 100) + '%</span>';
}

function onFxClear() {
    const overlay = document.getElementById('fx-overlay');
    overlay.style.display = 'none';
    updateFxCapBadge(null);
    document.getElementById('fx-fade').style.opacity = 0;
    document.getElementById('fx-vignette').style.opacity = 0;
    document.getElementById('fx-letterbox-top').style.height = '0';
    document.getElementById('fx-letterbox-bottom').style.height = '0';
    document.getElementById('fx-grain').style.opacity = 0;
    const wipeEl = document.getElementById('fx-wipe');
    if (wipeEl) wipeEl.style.display = 'none';
}

// ═══════════════════════════════════════════════════════════════════════════════
// RECORDING COUNTDOWN + INDICATOR
// ═══════════════════════════════════════════════════════════════════════════════

function onRecordingCountdown() {
    const overlay   = document.getElementById('rec-overlay');
    const countdown = document.getElementById('rec-countdown');
    const indicator = document.getElementById('rec-indicator');
    const stopHint  = document.getElementById('rec-stop-hint');

    overlay.classList.remove('hidden', 'recording');
    indicator.classList.add('hidden');
    stopHint.classList.add('hidden');

    const nums = [3, 2, 1];
    let i = 0;

    function showNext() {
        if (i >= nums.length) {
            countdown.textContent = '';
            countdown.classList.remove('active');
            // Countdown done — tell Lua to actually start recording
            post('recordingCountdownDone');
            return;
        }
        countdown.textContent = nums[i];
        countdown.classList.remove('active');
        // Force reflow to restart animation
        void countdown.offsetWidth;
        countdown.classList.add('active');
        i++;
        setTimeout(showNext, 900);
    }
    showNext();
}

function onRecordingStarted() {
    const overlay   = document.getElementById('rec-overlay');
    const countdown = document.getElementById('rec-countdown');
    const indicator = document.getElementById('rec-indicator');
    const stopHint  = document.getElementById('rec-stop-hint');

    overlay.classList.remove('hidden');
    overlay.classList.add('recording');
    countdown.textContent = '';
    countdown.classList.remove('active');
    indicator.classList.remove('hidden');
    stopHint.classList.remove('hidden');
    stopHint.style.opacity = '1';
    document.getElementById('rec-timer').textContent = '00:00';

    // Fade out the stop hint after 4 seconds
    setTimeout(() => {
        stopHint.style.transition = 'opacity 1.5s';
        stopHint.style.opacity = '0';
    }, 4000);
}

function onRecordingTick(elapsed) {
    const mins = Math.floor(elapsed / 60);
    const secs = Math.floor(elapsed % 60);
    document.getElementById('rec-timer').textContent =
        String(mins).padStart(2, '0') + ':' + String(secs).padStart(2, '0');
}

function onRecordingStopped() {
    const overlay = document.getElementById('rec-overlay');
    overlay.classList.add('hidden');
    overlay.classList.remove('recording');
    document.getElementById('rec-indicator').classList.add('hidden');
    document.getElementById('rec-stop-hint').classList.add('hidden');
    document.getElementById('rec-countdown').textContent = '';
    if (typeof Tutorial !== 'undefined' && Tutorial.isActive()) {
        post('tutorialDespawnAdder');
        post('tutorialReopenUI');
        // Fire the advance after the UI reopens so the next step's target element exists
        setTimeout(() => Tutorial.fire('tut:recordingStopped'), 500);
    }
}

// ── Recording save (once, when recording finishes) ──────────────────────────
function onRecordingFinished() {
    if (!State.currentProject) return;
    // Save recording data to server via latent event (only when a recording actually finishes)
    post('saveProjectWithRecordings', getProjectData());
}

// ═══════════════════════════════════════════════════════════════════════════════
// MODEL SWAP (click replay entity → swap model)
// ═══════════════════════════════════════════════════════════════════════════════

State.modelSwapTarget = null; // { entityType:'vehicle'|'ped', recordingIdx, currentModel }

// ── Recording entity list ────────────────────────────────────────────────────
function renderRecEntityList() {
    const list = document.getElementById('rp-entity-list');
    if (!State.recEntityList || State.recEntityList.length === 0) {
        list.innerHTML = `<div class="sp-hint" style="padding:4px 0">${t('scene.no_recorded_entities')}</div>`;
        return;
    }
    list.innerHTML = '';
    State.recEntityList.forEach(ent => {
        const card = document.createElement('div');
        card.className = 'se-entity-card';
        const icon = ent.type === 'vehicle' ? 'fa-car' : 'fa-person';
        const badge = ent.isPlayer ? ` <span style="color:var(--accent);font-size:9px">${t('ui.you_badge')}</span>` : '';
        card.innerHTML = `
            <div class="se-entity-icon ${ent.type}"><i class="fa-solid ${icon}"></i></div>
            <span class="se-entity-name">${ent.model}${badge}</span>
            <span class="se-entity-type">${ent.type}</span>
        `;
        card.addEventListener('dblclick', () => {
            State.modelSwapTarget = {
                entityType:   ent.type,
                recordingIdx: ent.idx,
                currentModel: ent.model,
            };
            document.getElementById('msm-type').textContent    = ent.type === 'vehicle' ? t('scene.type_vehicle') : t('scene.type_ped');
            document.getElementById('msm-current').textContent = ent.model;
            document.getElementById('msm-new-model').value     = '';
            document.getElementById('model-swap-modal').classList.remove('hidden');
            setTimeout(() => document.getElementById('msm-new-model').focus(), 50);
        });
        list.appendChild(card);
    });
}

CC.deleteRecording = async function() {
    if (!State.vehicleRecording) return;
    if (!await nuiConfirm(t('ui.confirm_delete_recording_title'), t('ui.confirm_delete_recording_message'))) return;
    post('deleteRecording');
    State.vehicleRecording  = null;
    State.vehicleRecStart   = 0;
    State.vehicleRecEnd     = 0;
    State.vehicleRecTrimIn  = 0;
    State.vehicleRecSelected = false;
    State.recEntityList     = [];
    hideSidePanel();
    renderTimeline();
    // Persist the deletion to the recording file. Autosave only writes
    // metadata, so without this the recording would re-appear on next load.
    if (State.currentProject) post('saveProjectWithRecordings', getProjectData());
    showToast(t('toasts.recording_deleted'));
};

function onReplayEntityClicked(d) {
    State.modelSwapTarget = {
        entityType:   d.entityType,
        recordingIdx: d.recordingIdx,
        currentModel: d.currentModel,
    };
    const modal = document.getElementById('model-swap-modal');
    document.getElementById('msm-type').textContent    = d.entityType === 'vehicle' ? t('scene.type_vehicle') : t('scene.type_ped');
    document.getElementById('msm-current').textContent = d.currentModel;
    document.getElementById('msm-new-model').value     = '';
    modal.classList.remove('hidden');
    setTimeout(() => document.getElementById('msm-new-model').focus(), 50);
}

CC.closeModelSwap = function() {
    document.getElementById('model-swap-modal').classList.add('hidden');
    State.modelSwapTarget = null;
};

CC.applyModelSwap = function() {
    if (!State.modelSwapTarget) return;
    const newModel = document.getElementById('msm-new-model').value.trim();
    if (!newModel) { showToast(t('errors.enter_model_name'), 'error'); return; }
    post('swapReplayModel', {
        entityType:   State.modelSwapTarget.entityType,
        recordingIdx: State.modelSwapTarget.recordingIdx,
        newModel:     newModel,
    });
};

function onModelSwapDone(d) {
    document.getElementById('model-swap-modal').classList.add('hidden');
    showToast(t('toasts.model_swapped', { model: d.newModel }));
    State.modelSwapTarget = null;
    // Update entity list with new model name
    if (d.entityType && d.recordingIdx != null && State.recEntityList) {
        const ent = State.recEntityList.find(e => e.type === d.entityType && e.idx === d.recordingIdx);
        if (ent) ent.model = d.newModel;
        renderRecEntityList();
    }
}

CC.deleteFromRecording = async function() {
    if (!State.modelSwapTarget) return;
    const target = State.modelSwapTarget;
    const label  = `${target.entityType} ${target.currentModel}`;
    const ok = await nuiConfirm(
        t('ui.confirm_delete_recording_entity_title') || 'Remove from recording?',
        (t('ui.confirm_delete_recording_entity_message') || 'This entity will no longer appear in the recording: {entity}').replace('{entity}', label)
    );
    if (!ok) return;
    document.getElementById('model-swap-modal').classList.add('hidden');
    State.modelSwapTarget = null;
    post('deleteRecordingEntity', {
        entityType:   target.entityType,
        recordingIdx: target.recordingIdx,
    });
};

function onRecordingEntityDeleted(d) {
    if (!d || d.recordingIdx == null) return;
    showToast(t('toasts.recording_entity_deleted') || 'Entity removed from recording');
    if (State.recEntityList) {
        State.recEntityList = State.recEntityList.filter(e =>
            !(e.type === d.entityType && e.idx === d.recordingIdx)
        );
        renderRecEntityList();
    }
}

// Enter key in the model swap input
document.getElementById('msm-new-model').addEventListener('keydown', (e) => {
    if (e.key === 'Enter') { e.preventDefault(); CC.applyModelSwap(); }
    if (e.key === 'Escape') { e.preventDefault(); CC.closeModelSwap(); }
});

// Click backdrop to close
document.getElementById('msm-backdrop').addEventListener('click', () => CC.closeModelSwap());

// ── Viewport double-click → entity picker (raycast-based, server-side) ───────
// Double-click on the viewport zone fires a normalised mouse coord to Lua,
// which casts a real ShapeTest ray from the camera and matches the hit
// entity to vehicleSpawns / pedSpawns / sceneEntities. Hits open the
// appropriate edit panel (model-swap modal for replay entities, scene-props
// for scene-editor entities). Single-click is intentionally a no-op so users
// can interact with overlay UI without accidentally swapping models.
(function initViewportPicker() {
    const zone = document.getElementById('viewport-click-zone');
    if (!zone) return;

    function pickerInactive() {
        return State.isPlaying || State.isPositionMode || State.isTextPlacing
            || State.isScenePlacing || State.isVehiclePicking;
    }

    zone.addEventListener('dblclick', (e) => {
        if (pickerInactive()) return;
        post('clickReplayEntity', {
            mouseX: e.clientX / window.innerWidth,
            mouseY: e.clientY / window.innerHeight,
        });
    });
})();

// ═══════════════════════════════════════════════════════════════════════════════
// PROJECT SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

function showProjectOverlay() {
    document.getElementById('project-overlay').classList.remove('hidden');
    document.getElementById('tb-no-project').style.display = '';
    document.getElementById('tb-project-controls').style.display = 'none';
    // Dim timeline controls
    document.getElementById('top-bar-center').style.opacity = '0.3';
    document.getElementById('top-bar-center').style.pointerEvents = 'none';
    document.getElementById('top-bar-right').style.opacity = '0.3';
    document.getElementById('top-bar-right').style.pointerEvents = 'none';
    post('listProjects');
}

function hideProjectOverlay() {
    document.getElementById('project-overlay').classList.add('hidden');
    document.getElementById('tb-no-project').style.display = 'none';
    document.getElementById('tb-project-controls').style.display = 'flex';
    // Enable timeline controls
    document.getElementById('top-bar-center').style.opacity = '';
    document.getElementById('top-bar-center').style.pointerEvents = '';
    document.getElementById('top-bar-right').style.opacity = '';
    document.getElementById('top-bar-right').style.pointerEvents = '';
}

// Kept for backwards compat with onShow
CC.openProjectBrowser = function() { showProjectOverlay(); };
CC.closeProjectBrowser = function() { hideProjectOverlay(); };

function onProjectList(projects) {
    State.projectList = projects || [];
    renderProjectList();
    // The resume picker shares this list; it re-renders only when it's open.
    renderResumeList();
}

function renderProjectList() {
    const list = document.getElementById('po-list');
    list.classList.toggle('empty', State.projectList.length === 0);
    if (State.projectList.length === 0) {
        list.innerHTML = `
            <div class="po-empty">
                <div class="po-empty-icon"><i class="fa-solid fa-film"></i></div>
                <div class="po-empty-title">${t('project.no_projects_yet')}</div>
                <div class="po-empty-sub">${t('project.no_projects_sub')}</div>
            </div>`;
        return;
    }
    list.innerHTML = '';
    const sorted = [...State.projectList].sort((a, b) => (b.updatedAt || 0) - (a.updatedAt || 0));
    sorted.forEach(proj => {
        const card = document.createElement('div');
        card.className = 'po-card';
        const state = proj.state || 'shared';
        card.dataset.state = state;

        const date = proj.updatedAt ? new Date(proj.updatedAt * 1000) : null;
        const dateStr = date ? date.toLocaleDateString(undefined, {month:'short', day:'numeric', hour:'2-digit', minute:'2-digit'}) : '';

        // State badge
        const stateIcon  = state === 'locked' ? 'fa-lock' : state === 'admin' ? 'fa-shield-halved' : 'fa-globe';
        const stateLabel = t('project.state_' + state) || state;

        card.innerHTML = `
            <div class="po-card-icon"><i class="fa-solid fa-film"></i></div>
            <div class="po-card-info">
                <div class="po-card-name">${proj.name || proj.slug}</div>
                <div class="po-card-meta">${dateStr}</div>
            </div>
            <div class="po-card-badges">
                <span class="po-badge state-${state}"><i class="fa-solid ${stateIcon}"></i>${stateLabel}</span>
            </div>
        `;

        const delBtn = document.createElement('button');
        delBtn.className = 'po-card-delete';
        delBtn.innerHTML = '<i class="fa-solid fa-trash"></i>';
        delBtn.addEventListener('click', async (e) => {
            e.stopPropagation();
            if (!await nuiConfirm(t('project.confirm_delete_title'), t('project.confirm_delete_message', { name: proj.name }))) return;
            post('deleteProject', { slug: proj.slug });
        });
        card.appendChild(delBtn);

        card.addEventListener('click', () => {
            loadProjectBySlug(proj.slug);
        });
        list.appendChild(card);
    });
}

// Wipe everything tied to the currently-loaded project in JS State AND tell
// Lua to drop its cached recordings / overlays / spawns. Called when the user
// leaves one project for another (different slug), creates a fresh one, or
// deletes the active one. Safe to call when no project is loaded.
function wipeProjectStateFull() {
    // Anchor is per-project intent, not a global preference — a fresh project
    // starts released so you can act in it. Lua holds its own copy of the flag,
    // so it has to be told, not just reset here.
    State.cameraAnchor = false;
    post('setCameraAnchor', { enabled: false });
    // Timeline / content
    State.keyframes = []; State.selectedKfId = null; State.currentFrame = 0;
    State.textObjects = []; State.textClips = [];
    State.nextId = 1; State.nextTextId = 1; State.nextTextClipId = 1;
    State.selectedClipId = null; State.editingClipId = null;

    // Recording block + loading state
    State.vehicleRecording   = null;
    State.vehicleRecStart    = 0;
    State.vehicleRecEnd      = 0;
    State.vehicleRecTrimIn   = 0;
    State.vehicleRecSelected = false;
    State.recLoading         = false;
    State.recEntityList      = [];

    // Overlay layers
    State.overlayLayers     = [];
    State.selectedOverlayId = null;

    // Scene entities — tell Lua to despawn each one individually, then clear
    (State.sceneEntities || []).forEach(ent => post('deleteSceneEntity', { entityId: ent.id }));
    State.sceneEntities = []; State.nextSceneId = 1; State.selectedSceneId = null;
    State.relGroups = [{ name: 'Director', color: '#4a9df0' }]; State.relMatrix = {};

    // Project meta + autosave
    State.currentProject = null;
    if (State.autoSaveTimer) { clearInterval(State.autoSaveTimer); State.autoSaveTimer = null; }
    State.autoSaveDirty = false;

    // Reset duration / UI inputs
    State.durationSec = 30;
    const durInput = document.getElementById('duration-input');
    const frmInput = document.getElementById('frame-input');
    if (durInput) durInput.value = 30;
    if (frmInput) frmInput.value = 0;

    // Tell Lua to drop its cached state too (overlays, recordings, spawns, bucket)
    post('resetProjectState');

    syncKeyframesToLua(); syncTextToLua();
}

// Every project-list click goes through this. State is wiped and the project
// is always fetched fresh — no in-memory caching across project switches.
function loadProjectBySlug(slug) {
    wipeProjectStateFull();
    post('loadProject', { slug });
}

// ── New-project modal state + helpers ────────────────────────────────────────
let _npSelectedState = 'shared';

CC.createProject = function() {
    // Reset the modal to defaults each open.
    _npSelectedState = 'shared';
    document.getElementById('np-name').value = '';
    document.getElementById('np-duration').value = 30;
    document.getElementById('np-tutorial').checked = State.tutorialDefault !== false;
    refreshNewProjectStateTiles();
    refreshNewProjectAdminVisibility();
    document.getElementById('new-project-modal').classList.remove('hidden');
    setTimeout(() => document.getElementById('np-name').focus(), 80);
};

CC.cancelNewProject = function() {
    document.getElementById('new-project-modal').classList.add('hidden');
};

CC.selectNewProjectState = function(state) {
    _npSelectedState = state;
    refreshNewProjectStateTiles();
};

function refreshNewProjectStateTiles() {
    const grid = document.querySelector('#new-project-modal .np-state-grid');
    if (!grid) return;
    grid.querySelectorAll('.np-state-tile').forEach(tile => {
        tile.classList.toggle('selected', tile.dataset.state === _npSelectedState);
    });
}

// Hide the admin tile entirely when the user doesn't have the admin ACE.
function refreshNewProjectAdminVisibility() {
    const tile = document.getElementById('np-state-admin');
    if (!tile) return;
    const allowed = !!State.isAdmin;
    tile.classList.toggle('disabled', !allowed);
    if (!allowed && _npSelectedState === 'admin') {
        _npSelectedState = 'shared';
        refreshNewProjectStateTiles();
    }
}

CC.confirmNewProject = async function() {
    const name = (document.getElementById('np-name').value || '').trim();
    if (!name) { showToast(t('project.error_name_required'), 'error'); return; }
    const slug = name.toLowerCase().replace(/[^a-z0-9\-_ ]/g, '').replace(/\s+/g, '_').substring(0, 64);
    if (!slug) { showToast(t('project.error_invalid_name'), 'error'); return; }

    const duration = Math.max(1, Math.min(3600, parseInt(document.getElementById('np-duration').value, 10) || 30));
    const tutorialEnabled = document.getElementById('np-tutorial').checked;
    const state = _npSelectedState || 'shared';

    document.getElementById('new-project-modal').classList.add('hidden');

    // If a project was cached from a previous session (closeProject kept it),
    // auto-save it before we throw it away, then full-wipe so the new project
    // starts completely fresh (no overlay / recording / scene leakage).
    if (State.currentProject) autoSaveProject();
    wipeProjectStateFull();

    State.durationSec = duration;
    const durInput = document.getElementById('duration-input');
    if (durInput) durInput.value = duration;

    State.currentProject = {
        slug, name,
        createdAt: Math.floor(Date.now()/1000),
        updatedAt: Math.floor(Date.now()/1000),
        tutorialEnabled,
        state,
    };
    document.getElementById('tb-project-name').textContent = name;

    syncKeyframesToLua(); syncTextToLua();
    renderTimeline(); updateTimecodeDisplay(); hideSidePanel();
    hideProjectOverlay();

    // Save immediately — server picks up the `state` field on first save
    // and writes it into the index.
    autoSaveProject();
    startAutoSave();
    showToast(t('project.created', { name }));

    if (tutorialEnabled) setTimeout(() => Tutorial.start(), 600);
};

// ── Project settings modal (edit existing) ───────────────────────────────────
let _psTargetSlug    = null;
let _psSelectedState = 'shared';

// Top-bar gear button: edit settings for the currently-loaded project. Looks
// up the index entry by slug so the modal is pre-filled correctly even if
// State.currentProject doesn't carry the saved durationSec.
CC.openCurrentProjectSettings = function() {
    if (!State.currentProject) return;
    const slug = State.currentProject.slug;
    const fromList = State.projectList.find(p => p.slug === slug);
    const proj = Object.assign(
        { slug, name: State.currentProject.name, durationSec: State.durationSec, state: State.currentProject.state || 'shared' },
        fromList || {}
    );
    CC.openProjectSettings(proj);
};

CC.openProjectSettings = function(proj) {
    if (!proj) return;
    _psTargetSlug    = proj.slug;
    _psSelectedState = proj.state || 'shared';

    document.getElementById('ps-name').value     = proj.name || '';
    document.getElementById('ps-duration').value = proj.durationSec || 30;

    // Disable the admin tile when the user can't grant admin (keeps existing
    // admin selection visible if they're already an admin loading their own
    // admin project).
    const adminTile = document.getElementById('ps-state-admin');
    if (adminTile) adminTile.classList.toggle('disabled', !State.isAdmin);

    refreshSettingsStateTiles();
    document.getElementById('project-settings-modal').classList.remove('hidden');
    setTimeout(() => document.getElementById('ps-name').focus(), 80);
};

CC.closeProjectSettings = function() {
    document.getElementById('project-settings-modal').classList.add('hidden');
    _psTargetSlug = null;
};

CC.selectSettingsState = function(state) {
    _psSelectedState = state;
    refreshSettingsStateTiles();
};

function refreshSettingsStateTiles() {
    const grid = document.querySelector('#project-settings-modal .np-state-grid');
    if (!grid) return;
    grid.querySelectorAll('.np-state-tile').forEach(tile => {
        tile.classList.toggle('selected', tile.dataset.state === _psSelectedState);
    });
}

CC.applyProjectSettings = function() {
    if (!_psTargetSlug) return;
    const name     = (document.getElementById('ps-name').value || '').trim();
    const duration = Math.max(1, Math.min(3600, parseInt(document.getElementById('ps-duration').value, 10) || 30));
    if (!name) { showToast(t('project.error_name_required'), 'error'); return; }

    post('updateProjectMeta', {
        slug:        _psTargetSlug,
        name,
        state:       _psSelectedState,
        durationSec: duration,
    });

    // Optimistic local update so the list re-renders immediately.
    const idx = State.projectList.findIndex(p => p.slug === _psTargetSlug);
    if (idx >= 0) {
        State.projectList[idx].name        = name;
        State.projectList[idx].state       = _psSelectedState;
        State.projectList[idx].durationSec = duration;
        State.projectList[idx].updatedAt   = Math.floor(Date.now()/1000);
        renderProjectList();
    }

    // If the edited project is the one currently open in the editor, mirror
    // the change onto State.currentProject and the toolbar title so the
    // rename / state change shows immediately instead of waiting for a
    // reload. Without this, autoSaveProject keeps writing the old name and
    // the toolbar still shows the pre-rename string.
    if (State.currentProject && State.currentProject.slug === _psTargetSlug) {
        State.currentProject.name  = name;
        State.currentProject.state = _psSelectedState;
        State.durationSec          = duration;
        const tbName = document.getElementById('tb-project-name');
        if (tbName) tbName.textContent = name || State.currentProject.slug;
        const durInput = document.getElementById('duration-input');
        if (durInput) durInput.value = duration;
    }

    document.getElementById('project-settings-modal').classList.add('hidden');
    showToast(t('project.settings_saved'));
    _psTargetSlug = null;
};

CC.saveProject = function() {
    if (!State.currentProject) return;
    autoSaveProject();
    showToast(t('project.saved'));
};

CC.closeProject = async function() {
    if (State.currentProject) autoSaveProject();
    // Full wipe — no caching across project exits. State drops to blank; Lua
    // drops its recordings, overlays, scene entities, spawns, drift smoke,
    // cinematic bucket, and teleports the ped back to uiOriginPos.
    wipeProjectStateFull();
    hideSidePanel();
    showProjectOverlay();
};

function onProjectLoaded(raw) {
    try {
        const data = typeof raw === 'string' ? JSON.parse(raw) : raw;
        if (!data.slug) throw new Error(t('errors.invalid_project'));

        // Pull state from the index list (project JSON itself doesn't track
        // state — the server keeps it in the index file) so subsequent reads
        // of State.currentProject.state work for loaded projects too.
        const indexEntry = State.projectList.find(p => p.slug === data.slug);
        State.currentProject = {
            slug: data.slug, name: data.name,
            createdAt: data.createdAt, updatedAt: data.updatedAt,
            tutorialEnabled: !!data.tutorialEnabled,
            state: indexEntry ? indexEntry.state : 'shared',
        };

        // Restore timeline data
        State.keyframes    = migrateKeyframeCuts(data.keyframes || []);
        State.durationSec  = data.duration  || 30;
        State.fps          = data.fps       || 30;
        State.nextId       = 1;
        State.keyframes.forEach(kf => {
            kf.id = State.nextId++;
            // Migrate legacy numeric `lockedVehicle` to "v:N" so all equality
            // checks compare the same shape (otherwise number 1 and string
            // "v:1" wouldn't match even though they reference the same car).
            if (typeof kf.lockedVehicle === 'number') {
                kf.lockedVehicle = 'v:' + kf.lockedVehicle;
            }
        });

        State.textObjects    = data.textObjects || [];
        State.textClips      = data.textClips   || [];
        State.nextTextId     = State.textObjects.reduce((m, o) => Math.max(m, o.id + 1), 1);
        State.nextTextClipId = State.textClips.reduce((m, c) => Math.max(m, c.id + 1), 1);

        // Restore world settings if present and push to Lua
        if (data.worldSettings) {
            State.worldSettings = { ...State.worldSettings, ...data.worldSettings };
            post('setWorldSettings', State.worldSettings);
        }
        if (data.interpSettings) {
            State.interpSettings = { ...State.interpSettings, ...data.interpSettings };
            post('setInterpSettings', State.interpSettings);
            const isMode    = document.getElementById('is-mode');
            const isTension = document.getElementById('is-tension');
            const isTensNum = document.getElementById('is-tension-num');
            const isSpring  = document.getElementById('is-spring');
            const isSprNum  = document.getElementById('is-spring-num');
            if (isMode)    isMode.value    = State.interpSettings.mode;
            if (isTension) isTension.value = State.interpSettings.tension;
            if (isTensNum) isTensNum.value = State.interpSettings.tension.toFixed(2);
            if (isSpring)  isSpring.value  = State.interpSettings.spring;
            if (isSprNum)  isSprNum.value  = State.interpSettings.spring.toFixed(2);
            if (CC._updateInterpHint) CC._updateInterpHint(State.interpSettings.mode);
        }

        // Restore recording block timing (frame data restored by Lua)
        State.vehicleRecStart  = data.vehicleRecStart  || 0;
        State.vehicleRecEnd    = data.vehicleRecEnd    || 0;
        State.vehicleRecTrimIn = data.vehicleRecTrimIn || 0;

        // Overlay layer loading placeholders — show the striped loading bar on each
        // overlay track immediately using the saved timings from the project JSON.
        // Real layers replace these when overlayLayersLoaded arrives.
        const olTimings = Array.isArray(data.overlayLayerTimings) ? data.overlayLayerTimings : [];
        if (olTimings.length > 0) {
            State.overlayLayers = olTimings.map(t => ({
                id:          t.id,
                name:        t.name || 'Layer ' + t.id,
                model:       '',
                loading:     true,
                duration:    0,
                totalFrames: 0,
                startFrame:  Math.floor((t.startSec || 0) * State.fps),
                endFrame:    t.endSec ? Math.floor(t.endSec * State.fps) : Math.floor((t.startSec || 0) * State.fps) + 1,
                trimInFrame: Math.floor((t.trimInSec || 0) * State.fps),
            }));
        } else {
            State.overlayLayers = [];
        }

        document.getElementById('duration-input').value = State.durationSec;
        document.getElementById('tb-project-name').textContent = data.name || data.slug;

        // Restore relationship groups — coerce stray object payloads back to array
        State.relGroups = Array.isArray(data.relGroups) ? data.relGroups : [{ name: 'Director', color: '#4a9df0' }];
        if (data.relMatrix && !Array.isArray(data.relMatrix)) {
            State.relMatrix = data.relMatrix;
        } else {
            State.relMatrix = {};
        }

        // Restore scene entities with ALL their settings
        if (data.sceneEntities && data.sceneEntities.length > 0) {
            State.sceneEntities.forEach(ent => post('deleteSceneEntity', { entityId: ent.id }));
            State.sceneEntities = data.sceneEntities;
            State.nextSceneId   = data.nextSceneId || State.sceneEntities.reduce((m, e) => Math.max(m, e.id + 1), 1);
            // Send full entity data to Lua for spawn + restore
            post('sceneRestoreAll', {
                entities: State.sceneEntities,
                relGroups: State.relGroups,
                relMatrix: State.relMatrix,
            });
        }

        syncKeyframesToLua(); syncTextToLua();
        renderTimeline(); updateTimecodeDisplay(); hideSidePanel();
        hideProjectOverlay();
        document.getElementById('tb-project-name').textContent = data.name || data.slug;
        startAutoSave();
        showToast(t('project.loaded', { name: (data.name || data.slug) }));
        if (State.currentProject.tutorialEnabled) setTimeout(() => Tutorial.start(), 800);
    } catch (err) {
        showToast(t('errors.load_failed', { error: err.message }), 'error');
    }
}

function onProjectSaved(slug) {
    document.getElementById('tb-autosave-status').textContent = t('project.autosave_saved');
    setTimeout(() => {
        document.getElementById('tb-autosave-status').textContent = '';
    }, 2000);
}

function onProjectDeleted(slug) {
    State.projectList = State.projectList.filter(p => p.slug !== slug);
    renderProjectList();
    if (State.currentProject && State.currentProject.slug === slug) {
        // Deleted project was active — full wipe and fall back to list
        wipeProjectStateFull();
        renderTimeline(); updateTimecodeDisplay(); hideSidePanel();
        showProjectOverlay();
    }
    showToast(t('project.deleted'));
}

function getProjectData() {
    if (!State.currentProject) return null;
    return {
        slug:            State.currentProject.slug,
        name:            State.currentProject.name,
        createdAt:       State.currentProject.createdAt,
        updatedAt:       Math.floor(Date.now() / 1000),
        version:         1,
        fps:             State.fps,
        duration:        State.durationSec,
        // Server reads `state` only when there's no existing index entry for
        // this slug — i.e. on the *first* save of a freshly created project.
        // Without this field the new-project state picker (admin / locked /
        // shared) was being silently dropped and every new project landed as
        // 'shared'. For projects that already exist in the index the server
        // ignores this field, so it's safe to always send it.
        state:           State.currentProject.state,
        keyframes:       State.keyframes,
        textObjects:     State.textObjects,
        textClips:       State.textClips,
        worldSettings:   State.worldSettings,
        interpSettings:  State.interpSettings,
        vehicleRecStart:  State.vehicleRecStart,
        vehicleRecEnd:    State.vehicleRecEnd,
        vehicleRecTrimIn: State.vehicleRecTrimIn,
        sceneEntities:    State.sceneEntities,
        nextSceneId:      State.nextSceneId,
        relGroups:        State.relGroups,
        relMatrix:        State.relMatrix,
        tutorialEnabled:  !!State.currentProject.tutorialEnabled,
    };
}

function autoSaveProject() {
    if (!State.currentProject) return;
    const data = getProjectData();
    if (!data) return;
    document.getElementById('tb-autosave-status').textContent = t('project.autosave_saving');
    // Autosave only saves metadata (keyframes, text, settings, trim values).
    // Recording data is saved once when a recording finishes — not on every autosave.
    post('saveProjectMetadata', data);
}

function startAutoSave() {
    if (State.autoSaveTimer) clearInterval(State.autoSaveTimer);
    State.autoSaveTimer = setInterval(() => {
        if (State.currentProject) autoSaveProject();
    }, State.autosaveInterval || 30000); // auto-save interval from Config
}

// Mark dirty on any keyframe/text change so auto-save catches it
const _origSyncKf   = typeof syncKeyframesToLua === 'function' ? syncKeyframesToLua : null;
const _origSyncText = typeof syncTextToLua === 'function' ? syncTextToLua : null;

// ═══════════════════════════════════════════════════════════════════════════════
// MODEL BROWSER (visual ped/vehicle selector with images from FiveM docs)
// ═══════════════════════════════════════════════════════════════════════════════

const MODEL_DATA = {
    ped: {
        'Customizable': ['mp_m_freemode_01','mp_f_freemode_01'],
        'Ambient Male': ['a_m_m_afriamer_01','a_m_m_beach_01','a_m_m_beach_02','a_m_m_bevhills_01','a_m_m_bevhills_02','a_m_m_business_01','a_m_m_eastsa_01','a_m_m_eastsa_02','a_m_m_farmer_01','a_m_m_fatlatin_01','a_m_m_genfat_01','a_m_m_genfat_02','a_m_m_golfer_01','a_m_m_hasjew_01','a_m_m_hillbilly_01','a_m_m_hillbilly_02','a_m_m_indian_01','a_m_m_ktown_01','a_m_m_malibu_01','a_m_m_mexcntry_01','a_m_m_mexlabor_01','a_m_m_og_boss_01','a_m_m_paparazzi_01','a_m_m_polynesian_01','a_m_m_prolhost_01','a_m_m_rurmeth_01','a_m_m_salton_01','a_m_m_salton_02','a_m_m_salton_03','a_m_m_salton_04','a_m_m_skater_01','a_m_m_skidrow_01','a_m_m_socenlat_01','a_m_m_soucent_01','a_m_m_soucent_02','a_m_m_soucent_03','a_m_m_soucent_04','a_m_m_stlat_02','a_m_m_tennis_01','a_m_m_tourist_01','a_m_m_tramp_01','a_m_m_trampbeac_01','a_m_m_tranvest_01','a_m_m_tranvest_02'],
        'Ambient Female': ['a_f_m_beach_01','a_f_m_bevhills_01','a_f_m_bevhills_02','a_f_m_bodybuild_01','a_f_m_business_02','a_f_m_downtown_01','a_f_m_eastsa_01','a_f_m_eastsa_02','a_f_m_fatbla_01','a_f_m_fatcult_01','a_f_m_fatwhite_01','a_f_m_ktown_01','a_f_m_ktown_02','a_f_m_prolhost_01','a_f_m_salton_01','a_f_m_skidrow_01','a_f_m_soucent_01','a_f_m_soucent_02','a_f_m_soucentmc_01','a_f_m_tourist_01','a_f_m_tramp_01','a_f_m_trampbeac_01'],
        'Ambient Young Male': ['a_m_y_beach_01','a_m_y_beach_02','a_m_y_beach_03','a_m_y_beachvesp_01','a_m_y_beachvesp_02','a_m_y_bevhills_01','a_m_y_bevhills_02','a_m_y_breakdance_01','a_m_y_busicas_01','a_m_y_business_01','a_m_y_business_02','a_m_y_business_03','a_m_y_cyclist_01','a_m_y_dhill_01','a_m_y_downtown_01','a_m_y_eastsa_01','a_m_y_eastsa_02','a_m_y_epsilon_01','a_m_y_epsilon_02','a_m_y_gay_01','a_m_y_gay_02','a_m_y_genstreet_01','a_m_y_genstreet_02','a_m_y_golfer_01','a_m_y_hasjew_01','a_m_y_hippy_01','a_m_y_hipster_01','a_m_y_hipster_02','a_m_y_hipster_03','a_m_y_indian_01','a_m_y_jetski_01','a_m_y_juggalo_01','a_m_y_ktown_01','a_m_y_ktown_02','a_m_y_latino_01','a_m_y_methhead_01','a_m_y_mexthug_01','a_m_y_motox_01','a_m_y_motox_02','a_m_y_musclbeac_01','a_m_y_musclbeac_02','a_m_y_polynesian_01','a_m_y_roadcyc_01','a_m_y_runner_01','a_m_y_runner_02','a_m_y_salton_01','a_m_y_skater_01','a_m_y_skater_02','a_m_y_soucent_01','a_m_y_soucent_02','a_m_y_soucent_03','a_m_y_soucent_04','a_m_y_stbla_01','a_m_y_stbla_02','a_m_y_stlat_01','a_m_y_stwhi_01','a_m_y_stwhi_02','a_m_y_sunbathe_01','a_m_y_surfer_01','a_m_y_vindouche_01','a_m_y_vinewood_01','a_m_y_vinewood_02','a_m_y_vinewood_03','a_m_y_vinewood_04','a_m_y_yoga_01'],
        'Ambient Young Female': ['a_f_y_beach_01','a_f_y_bevhills_01','a_f_y_bevhills_02','a_f_y_bevhills_03','a_f_y_bevhills_04','a_f_y_business_01','a_f_y_business_02','a_f_y_business_03','a_f_y_business_04','a_f_y_eastsa_01','a_f_y_eastsa_02','a_f_y_eastsa_03','a_f_y_epsilon_01','a_f_y_fitness_01','a_f_y_fitness_02','a_f_y_genhot_01','a_f_y_golfer_01','a_f_y_hiker_01','a_f_y_hippie_01','a_f_y_hipster_01','a_f_y_hipster_02','a_f_y_hipster_03','a_f_y_hipster_04','a_f_y_indian_01','a_f_y_juggalo_01','a_f_y_runner_01','a_f_y_rurmeth_01','a_f_y_scdressy_01','a_f_y_skater_01','a_f_y_soucent_01','a_f_y_soucent_02','a_f_y_soucent_03','a_f_y_tennis_01','a_f_y_topless_01','a_f_y_tourist_01','a_f_y_tourist_02','a_f_y_vinewood_01','a_f_y_vinewood_02','a_f_y_vinewood_03','a_f_y_vinewood_04','a_f_y_yoga_01'],
        'Law Enforcement': ['s_m_y_cop_01','s_f_y_cop_01','s_m_y_sheriff_01','s_f_y_sheriff_01','s_m_y_hwaycop_01','s_m_m_ciasec_01','s_m_y_ranger_01','s_f_y_ranger_01','s_m_y_swat_01','s_m_y_marine_01','s_m_y_marine_02','s_m_y_marine_03','s_m_m_marine_01','s_m_m_marine_02','s_m_y_pilot_01','s_m_m_prisguard_01','s_m_y_prisguard_01','csb_cop','s_m_y_uscg_01'],
        'Emergency': ['s_m_y_fireman_01','s_m_m_paramedic_01','s_m_y_paramedic_01','s_m_m_doctor_01','s_m_y_autopsy_01','s_f_y_scrubs_01'],
        'Service Workers': ['s_m_m_bouncer_01','s_m_y_doorman_01','s_m_y_valet_01','s_m_y_waiter_01','s_f_y_bartender_01','s_m_m_janitor','s_m_y_garbage','s_m_y_busboy_01','s_m_y_chef_01','s_f_m_maid_01','s_m_y_airworker','s_m_y_construct_01','s_m_y_construct_02','s_m_m_lifeinvad_01','s_m_m_linecook','s_m_m_cntrybar_01'],
        'Gang Members': ['g_m_y_famca_01','g_m_y_famdnf_01','g_m_y_famfor_01','g_m_y_lost_01','g_m_y_lost_02','g_m_y_lost_03','g_f_y_lost_01','g_m_y_mexgang_01','g_m_y_mexgoon_01','g_m_y_mexgoon_02','g_m_y_mexgoon_03','g_m_y_pologoon_01','g_m_y_pologoon_02','g_m_y_salvaboss_01','g_m_y_salvagoon_01','g_m_y_salvagoon_02','g_m_y_salvagoon_03','g_m_y_strpunk_01','g_m_y_strpunk_02','g_m_y_ballaeast_01','g_m_y_ballaorig_01','g_m_y_ballasout_01','g_f_y_ballas_01','g_m_y_korean_01','g_m_y_korean_02','g_m_y_korlieut_01','g_m_m_armboss_01','g_m_m_armgoon_01','g_m_m_armlieut_01','g_m_m_chemwork_01','g_m_m_chiboss_01','g_m_m_chicold_01','g_m_m_chigoon_01','g_m_m_chigoon_02','g_m_m_korboss_01','g_m_m_mexboss_01','g_m_m_mexboss_02'],
        'Story Characters': ['player_zero','player_one','player_two','ig_abigail','ig_amandatownley','ig_andreas','ig_ashley','ig_ballasog','ig_bankman','ig_barry','ig_bestmen','ig_beverly','ig_brad','ig_bride','ig_car3guy1','ig_casey','ig_chef','ig_clay','ig_claypain','ig_cletus','ig_dale','ig_davenorton','ig_denise','ig_devin','ig_dom','ig_dreyfuss','ig_drfriedlander','ig_fabien','ig_fbisuit_01','ig_floyd','ig_groom','ig_hao','ig_hunter','ig_janet','ig_jay_norris','ig_jewelass','ig_jimmyboston','ig_jimmydisanto','ig_joeminuteman','ig_johnnyklebitz','ig_josef','ig_josh','ig_lamardavis','ig_lazlow','ig_lestercrest','ig_lifeinvad_01','ig_lifeinvad_02','ig_magenta','ig_manuel','ig_marnie','ig_maryann','ig_maude','ig_michelle','ig_milton','ig_molly','ig_mrk','ig_mrs_thornhill','ig_natalia','ig_nervousron','ig_nigel','ig_old_man1a','ig_old_man2','ig_omega','ig_oneil','ig_ortega','ig_paper','ig_patricia','ig_priest','ig_prolsec_02','ig_ramp_gang','ig_ramp_hic','ig_ramp_hipster','ig_ramp_mex','ig_roccopelosi','ig_russiandrunk','ig_screen_writer','ig_siemonyetarian','ig_solomon','ig_stevehains','ig_stretch','ig_talina','ig_tanisha','ig_taocheng','ig_taostranslator','ig_tenniscoach','ig_terry','ig_tomepsilon','ig_tonya','ig_tracydisanto','ig_tylerdix','ig_wade','ig_zimbor'],
    },
    vehicle: {
        'Super': ['adder','autarch','banshee2','bullet','cheetah','cyclone','deveste','emerus','entityxf','entity2','fmj','furia','gp1','italigtb','italigtb2','krieger','le7b','nero','nero2','osiris','penetrator','pfister811','prototipo','reaper','s80','sc1','scramjet','sheava','sultanrs','t20','taipan','tempesta','tezeract','thrax','turismor','tyrant','tyrus','vacca','vagner','visione','voltic','xa21','zentorno','zorrusso'],
        'Sports': ['alpha','banshee','bestia','buffalo','buffalo2','buffalo3','carbonizzare','comet2','comet3','comet4','comet5','coquette','drafter','elegy','elegy2','feltzer2','flashgt','furoregt','fusilade','futo','gb200','hotring','imorgon','issi7','italigto','jester','jester2','jogger','khamelion','komoda','kuruma','kuruma2','locust','lynx','massacro','massacro2','neo','neon','ninef','ninef2','omnis','paragon','paragon2','pariah','penumbra','penumbra2','raiden','rapidgt','rapidgt2','raptor','revolter','ruston','schafter2','schafter3','schafter4','schafter5','schafter6','schlagen','schwarzer','sentinel3','seven70','specter','specter2','sultan','sultan2','surano','swinger','tropos','verlierer2','vstr','zr380','zr3802','zr3803'],
        'Muscle': ['blade','buccaneer','buccaneer2','chino','chino2','clique','coquette3','deviant','dominator','dominator2','dominator3','dominator4','dominator5','dominator6','dukes','dukes2','ellie','faction','faction2','faction3','gauntlet','gauntlet2','gauntlet3','gauntlet4','hermes','hotknife','hustler','impaler','impaler2','impaler3','impaler4','imperator','imperator2','imperator3','lurcher','moonbeam','moonbeam2','nightshade','peyote','peyote2','phoenix','picador','ratloader','ratloader2','ruiner','ruiner2','ruiner3','sabregt','sabregt2','slamvan','slamvan2','slamvan3','stalion','stalion2','tampa','tampa3','tulip','vamos','vigero','virgo','virgo2','virgo3','voodoo','voodoo2','yosemite','yosemite2'],
        'Sports Classics': ['ardent','btype','btype2','btype3','casco','cheburek','cheetah2','coquette2','deluxo','dynasty','fagaloa','feltzer3','gt500','infernus2','jb700','jb7002','mamba','manana','manana2','michelli','monroe','nebula','peyote3','pigalle','rapidgt3','retinue','retinue2','savestra','stinger','stingergt','stromberg','swinger','torero','tornado','tornado2','tornado3','tornado4','tornado5','tornado6','turismo2','viseris','z190','ztype'],
        'Sedan': ['asea','asea2','asterope','cog55','cog552','cognoscenti','cognoscenti2','emperor','emperor2','emperor3','fugitive','glendale','glendale2','ingot','intruder','limo2','premier','primo','primo2','regina','schafter2','stafford','stanier','stratum','stretch','surge','tailgater','warrener','washington'],
        'SUV': ['baller','baller2','baller3','baller4','baller5','baller6','bjxl','cavalcade','cavalcade2','contender','dubsta','dubsta2','fq2','granger','gresley','habanero','huntley','landstalker','landstalker2','mesa','mesa2','mesa3','novak','patriot','patriot2','radi','rebla','rocoto','seminole','seminole2','serrano','squaddie','toros','xls','xls2'],
        'Pickup': ['bison','bobcatxl','bodhi2','dubsta3','kamacho','mesa3','sandking','sandking2','yosemite','yosemite2'],
        'Emergency': ['ambulance','fbi','fbi2','firetruk','lguard','pbus','police','police2','police3','police4','policeb','policeold1','policeold2','policet','polmav','pranger','predator','riot','riot2','sheriff','sheriff2'],
        'Military': ['apc','barrage','chernobog','crusader','halftrack','khanjali','minitank','rhino','scarab','scarab2','scarab3','thruster','trailersmall2'],
        'Motorcycle': ['akuma','avarus','bagger','bati','bati2','bf400','carbonrs','chimera','cliffhanger','daemon','daemon2','defiler','deathbike','deathbike2','deathbike3','diablous','diablous2','double','enduro','esskey','faggio','faggio2','faggio3','fcr','fcr2','gargoyle','hakuchou','hakuchou2','hexer','innovation','lectro','manchez','nemesis','nightblade','oppressor','oppressor2','pcj','ratbike','ruffian','sanchez','sanchez2','sanctus','shotaro','sovereign','thrust','vader','vindicator','vortex','wolfsbane','zombiea','zombieb'],
        'Helicopter': ['akula','annihilator','buzzard','buzzard2','cargobob','cargobob2','cargobob3','cargobob4','frogger','frogger2','havok','hunter','maverick','savage','seasparrow','skylift','supervolito','supervolito2','swift','swift2','valkyrie','valkyrie2','volatus'],
        'Plane': ['alphaz1','avenger','avenger2','besra','bombushka','cuban800','dodo','duster','howard','hydra','lazer','luxor','luxor2','mammatus','microlight','miljet','mogul','molotok','nimbus','nokota','pyro','rogue','seabreeze','shamal','starling','strikeforce','titan','tula','ultralight','velum','velum2','vestra','volatol'],
        'Boat': ['avisa','dinghy','dinghy2','dinghy3','dinghy4','jetmax','kosatka','marquis','predator','seashark','seashark2','seashark3','speeder','speeder2','squalo','submersible','submersible2','suntrap','toro','toro2','tropic','tropic2','tug'],
    }
};

State.modelBrowserMode = null; // 'ped' | 'vehicle'

CC.openModelBrowser = function(mode) {
    State.modelBrowserMode = mode;
    document.getElementById('model-browser').classList.remove('hidden');
    document.getElementById('mb-title').textContent = mode === 'ped' ? t('scene.select_ped_model') : t('scene.select_vehicle_model');
    document.getElementById('mb-search').value = '';
    renderModelBrowser();
};

CC.closeModelBrowser = function() {
    document.getElementById('model-browser').classList.add('hidden');
    State.modelBrowserMode = null;
};

function renderModelBrowser(filter) {
    const mode = State.modelBrowserMode;
    const data = MODEL_DATA[mode];
    if (!data) return;

    const cats    = document.getElementById('mb-categories');
    const search  = (filter || '').toLowerCase();

    // Build category list
    cats.innerHTML = '';
    const catNames = Object.keys(data);
    const validCats = [];
    catNames.forEach(catName => {
        let models = data[catName];
        if (search) models = models.filter(m => m.includes(search));
        if (models.length === 0) return;
        validCats.push({ name: catName, models });

        const catBtn = document.createElement('div');
        catBtn.className = 'mb-cat';
        const _catKey = 'scene.model_cat_' + catName.toLowerCase().replace(/[^a-z0-9]+/g, '_');
        const _catTr = t(_catKey);
        catBtn.textContent = (_catTr === _catKey ? catName : _catTr) + ' (' + models.length + ')';
        catBtn.addEventListener('click', () => {
            cats.querySelectorAll('.mb-cat').forEach(c => c.classList.remove('active'));
            catBtn.classList.add('active');
            renderModelCategory(mode, models);
        });
        cats.appendChild(catBtn);
    });

    // Auto-select first category
    if (validCats.length > 0) {
        cats.querySelector('.mb-cat').classList.add('active');
        renderModelCategory(mode, validCats[0].models);
    } else {
        document.getElementById('mb-grid').innerHTML = `<div style="grid-column:1/-1;text-align:center;color:#555;padding:40px">${t('scene.no_models_found')}</div>`;
    }
}

function renderModelCategory(mode, models) {
    const grid    = document.getElementById('mb-grid');
    const wrap    = document.getElementById('mb-grid-wrap');
    const imgBase = mode === 'ped' ? 'https://docs.fivem.net/peds/' : 'https://docs.fivem.net/vehicles/';
    const imgExt  = '.webp';

    grid.innerHTML = '';
    wrap.scrollTop = 0;

    const frag = document.createDocumentFragment();
    models.forEach(model => {
        const card = document.createElement('div');
        card.className = 'mb-card';
        card.innerHTML = `<div class="mb-card-img-wrap"><img class="mb-card-img${mode === 'vehicle' ? ' vehicle-img' : ''}" data-src="${imgBase}${model}${imgExt}" alt="${model}" onerror="this.style.display='none'"></div><div class="mb-card-name">${model}</div>`;
        card.addEventListener('click', () => {
            document.getElementById(mode === 'ped' ? 'se-ped-model' : 'se-veh-model').value = model;
            CC.closeModelBrowser();
        });
        frag.appendChild(card);
    });
    grid.appendChild(frag);

    // Lazy load images
    if (window._mbObserver) window._mbObserver.disconnect();
    window._mbObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                if (img.dataset.src && !img.src) img.src = img.dataset.src;
                window._mbObserver.unobserve(img);
            }
        });
    }, { root: wrap, rootMargin: '300px' });
    grid.querySelectorAll('img[data-src]').forEach(img => window._mbObserver.observe(img));
}

// Search handler — searches across ALL categories, renders results directly
document.getElementById('mb-search').addEventListener('input', (e) => {
    const search = e.target.value.trim().toLowerCase();
    if (!search) {
        renderModelBrowser(); // no search = back to category view
        return;
    }
    // Search across all categories
    const mode = State.modelBrowserMode;
    const data = MODEL_DATA[mode];
    if (!data) return;
    const results = [];
    for (const models of Object.values(data)) {
        models.forEach(m => { if (m.includes(search)) results.push(m); });
    }
    // Clear category active state
    document.querySelectorAll('#mb-categories .mb-cat').forEach(c => c.classList.remove('active'));
    renderModelCategory(mode, results);
});

// ESC to close
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && State.modelBrowserMode) {
        CC.closeModelBrowser();
    }
});

// ═══════════════════════════════════════════════════════════════════════════════
// CUSTOM DROPDOWN (replaces native <select class="sp-select">)
// ═══════════════════════════════════════════════════════════════════════════════

function initCustomDropdowns() {
    document.querySelectorAll('select.sp-select').forEach(sel => {
        if (sel.dataset.ccInit) return; // already initialized
        sel.dataset.ccInit = '1';

        const wrapper = document.createElement('div');
        wrapper.className = 'cc-dropdown';

        const trigger = document.createElement('div');
        trigger.className = 'cc-dropdown-trigger';
        trigger.innerHTML = `<span class="cc-dropdown-label"></span><i class="fa-solid fa-chevron-down cc-dropdown-arrow"></i>`;

        const menu = document.createElement('div');
        menu.className = 'cc-dropdown-menu';

        sel.parentNode.insertBefore(wrapper, sel);
        wrapper.appendChild(trigger);
        wrapper.appendChild(menu);
        wrapper.appendChild(sel); // keep select inside for value access

        function buildOptions() {
            menu.innerHTML = '';
            Array.from(sel.options).forEach((opt, i) => {
                const item = document.createElement('div');
                item.className = 'cc-dropdown-option' + (i === sel.selectedIndex ? ' selected' : '');
                item.textContent = opt.textContent;
                item.dataset.value = opt.value;
                if (opt.style.fontFamily) item.style.fontFamily = opt.style.fontFamily;
                item.addEventListener('click', (e) => {
                    e.stopPropagation();
                    sel.value = opt.value;
                    sel.dispatchEvent(new Event('change'));
                    updateLabel();
                    wrapper.classList.remove('open');
                });
                menu.appendChild(item);
            });
        }

        function updateLabel() {
            const lbl = trigger.querySelector('.cc-dropdown-label');
            const opt = sel.options[sel.selectedIndex];
            lbl.textContent = opt ? opt.textContent : '';
            lbl.style.fontFamily = opt && opt.style.fontFamily ? opt.style.fontFamily : '';
            // Update selected class
            menu.querySelectorAll('.cc-dropdown-option').forEach((el, i) => {
                el.classList.toggle('selected', i === sel.selectedIndex);
            });
        }

        trigger.addEventListener('click', (e) => {
            e.stopPropagation();
            // Close all other dropdowns
            document.querySelectorAll('.cc-dropdown.open').forEach(d => {
                if (d !== wrapper) d.classList.remove('open');
            });
            buildOptions();
            // Position menu using fixed coords from trigger rect
            const rect = trigger.getBoundingClientRect();
            menu.style.left  = rect.left + 'px';
            menu.style.width = rect.width + 'px';
            // Check if menu would overflow bottom of screen
            const spaceBelow = window.innerHeight - rect.bottom - 8;
            if (spaceBelow < 180) {
                // Open upward
                menu.style.top    = '';
                menu.style.bottom = (window.innerHeight - rect.top + 4) + 'px';
            } else {
                // Open downward
                menu.style.top    = (rect.bottom + 4) + 'px';
                menu.style.bottom = '';
            }
            wrapper.classList.toggle('open');
        });

        buildOptions();
        updateLabel();

        // Observe select for programmatic value changes (DOM mutations + child option updates)
        const observer = new MutationObserver(() => { buildOptions(); updateLabel(); });
        observer.observe(sel, { childList: true, subtree: true, attributes: true });

        // Sync label when value changes externally (e.g. from user-triggered change events)
        sel.addEventListener('change', () => updateLabel());

        // Patch the .value property setter so programmatic assignments like
        // `select.value = 'foo'` also refresh the custom dropdown label
        // (the built-in setter doesn't fire a mutation or change event).
        const proto    = Object.getPrototypeOf(sel);
        const origDesc = Object.getOwnPropertyDescriptor(proto, 'value');
        if (origDesc && !sel.__ccValuePatched) {
            sel.__ccValuePatched = true;
            Object.defineProperty(sel, 'value', {
                configurable: true,
                get() { return origDesc.get.call(this); },
                set(v) { origDesc.set.call(this, v); updateLabel(); },
            });
        }
    });
}

// Close dropdowns when clicking anywhere
document.addEventListener('click', () => {
    document.querySelectorAll('.cc-dropdown.open').forEach(d => d.classList.remove('open'));
});

// ── TUTORIAL ──────────────────────────────────────────────────────────────────
const Tutorial = (function() {
    const root       = () => document.getElementById('tut-root');
    const highlight  = () => document.getElementById('tut-highlight');
    const tooltip    = () => document.getElementById('tut-tooltip');
    const titleEl    = () => document.getElementById('tut-tip-title');
    const bodyEl     = () => document.getElementById('tut-tip-body');
    const stepEl     = () => document.getElementById('tut-tip-step');
    const hintEl     = () => document.getElementById('tut-tip-hint');

    let active = false, stepIdx = -1, interval = null, startFrame = 0, startKfCount = 0, camStart = null;

    const steps = [
        {
            get title() { return t('tutorial.s1_title'); },
            get body()  { return t('tutorial.s1_body'); },
            target: '[data-tut="recordings-menu"]',
            advanceEvent: 'tut:openedRecordings',
            get hint() { return t('tutorial.s1_hint'); },
        },
        {
            get title() { return t('tutorial.s2_title'); },
            get body()  { return t('tutorial.s2_body'); },
            target: '[data-tut="start-record"]',
            advanceEvent: 'tut:recordingStarted',
            get hint() { return t('tutorial.s2_hint'); },
            beforeClick: () => { post('tutorialSpawnAdder'); },
        },
        {
            get title() { return t('tutorial.s3_title'); },
            get body()  { return t('tutorial.s3_body'); },
            target: null,
            advanceEvent: 'tut:recordingStopped',
            get hint() { return t('tutorial.s3_hint'); },
            showWhenUIClosed: true,
        },
        {
            get title() { return t('tutorial.s4_title'); },
            get body()  { return t('tutorial.s4_body'); },
            target: '[data-tut="add-keyframe"]',
            advanceEvent: 'tut:keyframeAdded',
            get hint() { return t('tutorial.s4_hint'); },
        },
        {
            get title() { return t('tutorial.s5_title'); },
            get body()  { return t('tutorial.s5_body'); },
            target: '#sp-pos-btn',
            advanceEvent: 'tut:positionSaved',
            get hint() { return t('tutorial.s5_hint'); },
        },
        {
            get title() { return t('tutorial.s6_title'); },
            get body()  { return t('tutorial.s6_body'); },
            target: '#timeline-scroll-wrap',
            advanceEvent: 'tut:scrubbed',
            tooltipPlacement: 'above',
            get hint() { return t('tutorial.s6_hint'); },
            onEnter: () => { startFrame = State.currentFrame; },
        },
        {
            get title() { return t('tutorial.s7_title'); },
            get body()  { return t('tutorial.s7_body'); },
            target: '[data-tut="add-keyframe"]',
            advanceEvent: 'tut:keyframeAdded',
            get hint() { return t('tutorial.s7_hint'); },
        },
        {
            get title() { return t('tutorial.s8_title'); },
            get body()  { return t('tutorial.s8_body'); },
            target: '#sp-pos-btn',
            advanceEvent: 'tut:positionSaved',
            get hint() { return t('tutorial.s8_hint'); },
        },
        {
            get title() { return t('tutorial.s9_title'); },
            get body()  { return t('tutorial.s9_body'); },
            target: '#timeline-scroll-wrap',
            advanceEvent: 'tut:scrubbed',
            tooltipPlacement: 'above',
            get hint() { return t('tutorial.s9_hint'); },
            onEnter: () => { startFrame = State.currentFrame; },
        },
        {
            get title() { return t('tutorial.s10_title'); },
            get body()  { return t('tutorial.s10_body'); },
            target: '[data-tut="add-keyframe"]',
            advanceEvent: 'tut:keyframeAdded',
            get hint() { return t('tutorial.s10_hint'); },
        },
        {
            get title() { return t('tutorial.s11_title'); },
            get body()  { return t('tutorial.s11_body'); },
            target: '#sp-pos-btn',
            advanceEvent: 'tut:positionSaved',
            get hint() { return t('tutorial.s11_hint'); },
        },
        {
            get title() { return t('tutorial.s12_title'); },
            get body()  { return t('tutorial.s12_body'); },
            target: '#sp-back-btn',
            advanceEvent: 'tut:backToMenu',
            get hint() { return t('tutorial.s12_hint'); },
        },
        {
            get title() { return t('tutorial.s13_title'); },
            get body()  { return t('tutorial.s13_body'); },
            target: '[data-tut="interp-menu"]',
            advanceEvent: 'tut:interpOpened',
            get hint() { return t('tutorial.s13_hint'); },
        },
        {
            get title() { return t('tutorial.s14_title'); },
            get body()  { return t('tutorial.s14_body'); },
            target: () => document.querySelector('#is-mode')?.closest('.cc-dropdown') || document.getElementById('is-mode'),
            advanceEvent: 'tut:interpChanged',
            get hint() { return t('tutorial.s14_hint'); },
        },
        {
            get title() { return t('tutorial.s15_title'); },
            get body()  { return t('tutorial.s15_body'); },
            target: '#play-btn',
            advanceEvent: 'tut:playbackFinished',
            get hint() { return t('tutorial.s15_hint'); },
        },
        {
            get title() { return t('tutorial.s16_title'); },
            get body()  { return t('tutorial.s16_body'); },
            target: null,
            advanceEvent: null,
            get hint() { return t('tutorial.s16_hint'); },
            finalStep: true,
        },
    ];

    function findTarget(sel) {
        if (!sel) return null;
        let el;
        if (typeof sel === 'function') { try { el = sel(); } catch { el = null; } }
        else el = document.querySelector(sel);
        if (!el) return null;
        const r = el.getBoundingClientRect();
        if (r.width === 0 || r.height === 0) return null;
        return el;
    }

    function positionOverlay(el) {
        const hl = highlight();
        const tp = tooltip();
        if (el) {
            const r = el.getBoundingClientRect();
            const pad = 6;
            hl.style.display = '';
            hl.style.left   = (r.left - pad) + 'px';
            hl.style.top    = (r.top  - pad) + 'px';
            hl.style.width  = (r.width  + pad*2) + 'px';
            hl.style.height = (r.height + pad*2) + 'px';
            hl.classList.add('pulse');

            const tw = 320, th = 170;
            const step = steps[stepIdx];
            let left, top;
            if (step && step.tooltipPlacement === 'above') {
                left = Math.max(20, Math.min(window.innerWidth - tw - 20, r.left + r.width/2 - tw/2));
                top  = Math.max(20, r.top - th - 14);
            } else {
                left = r.right + 14;
                top  = r.top;
                if (left + tw > window.innerWidth - 20) left = Math.max(20, r.left - tw - 14);
                if (top  + th > window.innerHeight - 20) top  = Math.max(20, window.innerHeight - th - 20);
            }
            tp.style.left = left + 'px';
            tp.style.top  = top  + 'px';
        } else {
            hl.style.display = 'none';
            hl.classList.remove('pulse');
            tp.style.left = '50%';
            tp.style.top  = '50%';
            tp.style.transform = 'translate(-50%, -50%)';
            return;
        }
        tp.style.transform = '';
    }

    function render() {
        const step = steps[stepIdx];
        if (!step) return end();
        stepEl().textContent = t('tutorial.step_count', { current: stepIdx + 1, total: steps.length });
        titleEl().textContent = step.title;
        bodyEl().innerHTML    = step.body;
        hintEl().textContent  = step.hint || '';
        document.getElementById('tut-skip').textContent = step.finalStep ? t('tutorial.finish') : t('tutorial.skip');

        camStart = step.trackCameraMove && State.currentCamPos
            ? { ...State.currentCamPos } : null;

        const el = findTarget(step.target);
        positionOverlay(el);

        // Re-position on every frame while animating (menu opens can change layout)
        if (interval) clearInterval(interval);
        interval = setInterval(() => {
            const e = findTarget(step.target);
            positionOverlay(e);
        }, 150);

        // "beforeClick" hook: intercept the target click once
        if (step.beforeClick && el) {
            const handler = (ev) => {
                el.removeEventListener('click', handler, true);
                try { step.beforeClick(); } catch(e) {}
            };
            el.addEventListener('click', handler, true);
        }

        // Wire up the advance event
        if (step.advanceEvent) {
            const listener = () => {
                document.removeEventListener(step.advanceEvent, listener);
                next();
            };
            document.addEventListener(step.advanceEvent, listener);
        }
    }

    function next() {
        stepIdx++;
        if (stepIdx >= steps.length) return end();
        render();
    }

    function start() {
        if (active) return;
        active = true;
        stepIdx = -1;
        root().classList.remove('hidden');
        next();
    }

    function end() {
        active = false;
        if (interval) { clearInterval(interval); interval = null; }
        root().classList.add('hidden');
        if (State.currentProject) {
            State.currentProject.tutorialEnabled = false;
            autoSaveProject();
        }
    }

    // Event fanout — call from UI code
    function fire(name) { document.dispatchEvent(new Event(name)); }

    function onUIHidden() {
        const step = steps[stepIdx];
        if (!active) return;
        if (!step || !step.showWhenUIClosed) root().classList.add('hidden');
    }
    function onUIShown() {
        if (!active) return;
        root().classList.remove('hidden');
    }

    function onCoords(pos) {
        if (!active || !camStart || !pos) return;
        const dx = pos.x - camStart.x, dy = pos.y - camStart.y, dz = pos.z - camStart.z;
        if (dx*dx + dy*dy + dz*dz > 9) { // > 3 meters
            camStart = null;
            fire('tut:cameraMoved');
        }
    }


    return { start, end, fire, onCoords, onUIHidden, onUIShown, isActive: () => active };
})();

CC.tutorialSkip = () => Tutorial.end();

function updateWeatherConflictWarning() {
    const warn = document.getElementById('ws-conflict-warn');
    const names = document.getElementById('ws-conflict-names');
    if (!warn || !names) return;
    const list = State.weatherConflicts || [];
    if (list.length === 0) { warn.classList.add('hidden'); return; }
    names.innerHTML = list.map(n => `<b>${n}</b>`).join(', ');
    warn.classList.remove('hidden');
}

function updateRpemotesWarning() {
    const warn = document.getElementById('rp-emotes-warn');
    if (!warn) return;
    if (State.rpemotesReady) {
        warn.classList.add('hidden');
    } else {
        warn.classList.remove('hidden');
    }
}

// Project list: vertical wheel → horizontal scroll
(() => {
    const list = document.getElementById('po-list');
    if (!list) return;
    list.addEventListener('wheel', (e) => {
        if (list.classList.contains('empty')) return;
        if (e.deltaY === 0) return;
        e.preventDefault();
        list.scrollLeft += e.deltaY;
    }, { passive: false });
})();

// ── INIT ──────────────────────────────────────────────────────────────────────
initCustomDropdowns();
updateTimecodeDisplay();
