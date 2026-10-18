/* ════════════════════════════════════════════════════════════
   APEX HANDLING STUDIO: NUI application
   ------------------------------------------------------------
   Single-file app. Talks to Lua through fetch callbacks with a
   dual-endpoint fallback (classic resource host first, cfx-nui
   second: some builds silently drop one of them).
   ════════════════════════════════════════════════════════════ */

'use strict';

/* ─── NUI transport ─────────────────────────────────────────── */

const RESOURCE = (window.GetParentResourceName && window.GetParentResourceName()) || 'apex_handling';

async function nui(cb, data) {
    const body = JSON.stringify(data || {});
    const opts = { method: 'POST', headers: { 'Content-Type': 'application/json' }, body };
    try {
        const r = await fetch(`https://${RESOURCE}/${cb}`, opts);
        return await r.json();
    } catch (e) {
        try {
            const r2 = await fetch(`https://cfx-nui-${RESOURCE}/${cb}`, opts);
            return await r2.json();
        } catch (e2) {
            console.error('NUI callback failed on both hosts:', cb, e2);
            return null;
        }
    }
}

/* ─── i18n ──────────────────────────────────────────────────── */

/* ─── i18n ──────────────────────────────────────────────────────
   The live strings come from the Lua locale files (locales/<code>.lua)
   in the boot payload, so Config.locale drives the whole interface and
   a new language never touches this file.

   This English table is the offline fallback: it covers the moment
   before boot arrives, and any single key a translation leaves out.
   ────────────────────────────────────────────────────────────────── */

const I18N_EN = {
    studio_sub: "Handling Studio",
    tab_simple: "Simple",
    tab_advanced: "Advanced",
    tab_flags: "Flags",
    tab_telemetry: "Telemetry",
    tab_timing: "Timing",
    tab_presets: "Presets",
    tab_profiles: "Profiles",
    tab_xml: "XML",
    simple_title: "Quick tune",
    simple_hint: "Ten sliders that just work. Move one and feel it instantly. Everything maps onto real physics underneath. Perfect for fixing a broken addon car.",
    collapse_all: "Collapse all",
    copy: "Copy",
    export_file: "Export .meta",
    write_file: "Write to vehicle file",
    reset_stock: "Reset to stock",
    save_server: "Save on server",
    saved_server: "Saved on server",
    synced: "synced",
    dirty: "not synced",
    timing_title: "Performance timing",
    timing_hint: "Press Start road test: the studio closes and a live timer follows you. Stop completely to arm, then launch for 0-100 / 0-200 / ¼ mile. Brake from above 100 to a stop for braking distance. Also on the road via /handlingtiming.",
    presets_title: "Factory presets",
    presets_hint: "Complete, drivable tunes. Apply one, then fine-tune in Simple or Advanced.",
    save: "Save",
    share: "SHARE CODE",
    share_copy: "Copy code of current tune",
    share_import: "Import",
    meta_searching: "Locating handling.meta…",
    meta_found: "handling.meta found",
    meta_missing: "No handling.meta on this server",
    meta_missing_hint: "Live tuning & server overrides still work. File writing needs the file.",
    rescan: "Rescan files",
    write_needs_file: "No handling.meta located yet, click to rescan the server's files.",
    write_disabled: "File writing is off in the config, or you do not have full access.",
    apply_failed: "That change could not be applied to the vehicle.",
    apply: "Apply",
    load: "Load",
    delete: "Delete",
    speed: "Speed",
    gear: "gear",
    wheels: "WHEELS, slip · traction · brake",
    history: "HISTORY",
    trap: "trap",
    timing: "TIMING",
    adv_note_advanced: "Advanced flags live in CCarHandlingData, they apply ONLY when written to the file.",
    flags_soft_note: "Applied live; some bits only take effect on respawn or via file write.",
    copied: "Copied to clipboard.",
    share_bad: "Invalid share code.",
    share_ok: "Tune imported and applied.",
    preset_applied: "Preset applied.",
    confirm_write: "Write current tune into the vehicle's handling.meta on disk?",
    no_file: "No meta file found",
    armed: "ARMED",
    running: "RUN",
    idle: "idle",
    tele_hud_title: "Driving HUD",
    tele_hud_hint: "Keep a compact live telemetry overlay on screen while you drive, even with this menu closed.",
    hud_show: "Show HUD",
    hud_hide: "Hide HUD",
    timing_start: "Start road test",
    timing_stop: "Stop road test",
    timing_started: "Road test armed, stop fully, then launch!",
    timing_autoarm: "Stop completely to arm the next run",
    hud_position: "DRIVING HUD POSITION",
    hud_position_hint: "Which screen corner the speed / timing overlay sits in.",
    tune_profile: "TUNE PROFILE",
    tune_axes: "AXES",
    legend_current: "Current",
    legend_stock: "Factory",
    last_drive: "LAST DRIVE ON THIS VEHICLE",
    drive_empty: "No drive recorded yet. Turn the driving HUD on and go for a lap. The numbers land here.",
    drive_history: "DRIVE HISTORY",
    history_empty: "Only one drive recorded so far. Older drives will be listed here.",
    speed_trace: "Speed over the drive",
    peak_speed: "Top speed",
    peak_glat: "Peak lateral G",
    peak_glong: "Peak long. G",
    peak_rpm: "Peak RPM",
    peak_slip: "Peak wheel slip",
    settings_title: "Settings",
    brand_color: "BRAND COLOR",
    bg_color: "BACKGROUND",
    glow: "GLOW INTENSITY",
    custom: "Custom",
    compact: "Compact mode",
    compact_hint: "Slightly smaller text and spacing.",
    theme_reset: "Reset theme",
    done: "Done",
    next: "Next",
    prev: "Back",
    help_title: "How the Handling Studio works",
    restore_file: "Restore original",
    restore_confirm_short: "Click again to confirm",
    confirm_write_short: "Click again to write the file",
    share_legacy: "Old APEXH1 share code. It came from a build with a value bug, so it cannot be trusted. Ask whoever sent it for a new one.",
};


let LOCALE = 'en';
// boot.i18n first, then the built-in English, then the key itself so a
// missing string is visible rather than blank
const T = (k) => (S.i18n && S.i18n[k]) || I18N_EN[k] || k;
// catalog entries (field labels, preset names) carry their own per-language
// tables; fall back to English for any language they do not cover
const pick = (obj) => (obj && (obj[LOCALE] || obj.en)) || '';

function applyI18n() {
    document.querySelectorAll('[data-i18n]').forEach(el => { el.textContent = T(el.dataset.i18n); });
}

/* ─── State ─────────────────────────────────────────────────── */

const S = {
    open: false,
    access: false,
    units: 'kmh',
    boot: null,
    values: {},          // current meta-space values
    stock: {},
    fieldByName: {},
    advFlags: null,      // CCarHandlingData strAdvancedFlags (file only)
    advFlagsAvailable: false,
    // AIHandling has no runtime native, so it never comes back from the
    // vehicle. Keeping it in S.values meant every refresh (reset, profile
    // load, share import) silently wiped the user's choice while the
    // dropdown still showed it: and the file write then dropped it.
    aiHandling: null,
    metaInfo: null,
    metaFound: false,    // has the server located this car's handling.meta?
    flagTab: 'model',
    dirtySync: false,
    profiles: [],
    overrideActive: false,
    hasFileBackup: false,
    teleOn: false,       // telemetry pane visible
    teleHud: false,      // persistent driving HUD
    timingOn: false,
    drive: null,         // drive being recorded right now (see recordTelemetry)
    timingSaved: null,   // last results, persisted in localStorage
    timingHud: false,    // a road test is running
    inVehicle: true,     // overlays only show while driving
    hudPos: 'tr',        // which screen corner the driving HUD sits in
    i18n: null,          // interface strings for Config.locale (from Lua)
    help: null,          // tutorial steps for Config.locale (from Lua)
};

const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => Array.from(document.querySelectorAll(sel));

const KMH2MPH = 0.621371;
const speedU = () => S.units === 'mph' ? 'mph' : 'km/h';
const toU = (kmh) => S.units === 'mph' ? kmh * KMH2MPH : kmh;

/* ─── Toasts / tooltip ──────────────────────────────────────── */

function toast(msg, type = 'info') {
    const el = document.createElement('div');
    el.className = `toast ${type}`;
    el.textContent = msg;
    $('#toasts').appendChild(el);
    setTimeout(() => { el.classList.add('out'); setTimeout(() => el.remove(), 250); }, 3400);
}

const tipEl = () => $('#tooltip');
function bindTip(el, text) {
    el.addEventListener('mouseenter', () => {
        const t = tipEl();
        t.textContent = text;
        t.hidden = false;
        const r = el.getBoundingClientRect();
        const tw = t.offsetWidth, th = t.offsetHeight;
        let x = r.left - tw - 10;
        if (x < 8) x = Math.min(window.innerWidth - tw - 8, r.right + 10);
        let y = Math.min(Math.max(8, r.top + r.height / 2 - th / 2), window.innerHeight - th - 8);
        t.style.left = x + 'px'; t.style.top = y + 'px';
    });
    el.addEventListener('mouseleave', () => { tipEl().hidden = true; });
}

/* ─── Value helpers ─────────────────────────────────────────── */

function fieldChanged(name) {
    const f = S.fieldByName[name];
    const a = S.values[name], b = S.stock[name];
    if (a === undefined || b === undefined) return false;
    if (f && f.type === 'vec') {
        return ['x','y','z'].some(k => Math.abs((a[k]||0) - (b[k]||0)) > 1e-4);
    }
    return Math.abs(Number(a) - Number(b)) > (f && f.type !== 'float' ? 0 : Math.max(1e-4, Math.abs(Number(b)) * 1e-4));
}

// Keep a value inside its catalog range. Typed input, scrub gestures and
// imported share codes all pass through here, a slider physically cannot
// leave the range, but a typed number could otherwise send fMass=0 (or a
// negative traction curve) straight to live physics.
function clampField(f, v) {
    if (!f) return v;
    if (typeof f.min === 'number' && v < f.min) return f.min;
    if (typeof f.max === 'number' && v > f.max) return f.max;
    return v;
}

function fmtVal(f, v) {
    if (v === undefined || v === null) return '-';
    if (f.type === 'int' || f.type === 'flags') return String(Math.round(v));
    const av = Math.abs(v);
    const dec = av >= 100 ? 1 : av >= 10 ? 2 : 3;
    return Number(v).toFixed(dec);
}

let syncTimer = null;
function markDirtyAndSync() {
    S.dirtySync = true;
    const chip = $('#sync-state');
    chip.className = 'chip sync-dirty';
    chip.textContent = T('dirty');
    clearTimeout(syncTimer);
    syncTimer = setTimeout(async () => {
        const r = await nui('syncNow');
        if (r && r.ok) {
            S.dirtySync = false;
            chip.className = 'chip sync-ok';
            chip.textContent = T('synced');
        }
    }, 500);
}

// A refusal from the Lua side used to be dropped on the floor, which is
// how a slider that changes nothing produces no error anywhere. Surface
// it, but only once every few seconds: a drag fires many batches and each
// one would otherwise raise its own toast.
let lastApplyErr = 0;
function reportApply(r) {
    // No `err` means nothing was refused: the Lua side fills it in for
    // every real refusal, so silence here is genuinely "nothing to say".
    if (!r || !r.err) return;
    const now = Date.now();
    if (now - lastApplyErr < 4000) return;
    lastApplyErr = now;
    toast(r.err || T('apply_failed'), 'error');
}

let applyQueue = {};
let applyTimer = null;
let applyLast = 0;
const APPLY_MS = 40;                      // throttle window, not a delay

// Throttle, NOT a debounce. The old version cleared its timer on every
// slider tick, so while the pointer kept moving nothing was ever sent and
// the car only changed once the drag stopped: exactly the "moving the
// slider does not change the vehicle" report. Now the queue drains on a
// fixed cadence no matter how fast the input fires.
//
// The first call of a burst still schedules through the timer (with a 0 ms
// wait once the window has passed) so that every field of a multi-field
// slider, queued in the same event, leaves in ONE batch.
function flushApply() {
    const fields = applyQueue;
    applyQueue = {};
    applyTimer = null;
    applyLast = Date.now();
    if (!Object.keys(fields).length) return;
    nui('applyFields', { fields }).then(reportApply);
}

function queueApply(name, value) {
    S.values[name] = value;
    applyQueue[name] = value;
    if (!applyTimer) {
        applyTimer = setTimeout(flushApply, Math.max(0, APPLY_MS - (Date.now() - applyLast)));
    }
    markDirtyAndSync();
    refreshXml();
    refreshPerf();
}

// The radar reflects the tune, so it follows every edit. Debounced so a
// slider drag doesn't repaint the canvas on every frame.
let perfTimer = null;
function refreshPerf() {
    if (!S.teleOn) return;
    clearTimeout(perfTimer);
    perfTimer = setTimeout(() => {
        drawRadar();
        renderRadarAxes();
    }, 90);
}

/* ─── Icon set (inline SVG: no emoji anywhere) ─────────────── */

const SVG = (d, extra = '') =>
    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"
        stroke-linecap="round" stroke-linejoin="round">${d}${extra}</svg>`;

const ICONS = {
    // simple sliders
    speed:  SVG('<path d="M3 15a9 9 0 0 1 18 0"/><path d="M12 15l5-5"/>'),
    rocket: SVG('<path d="M12 3c3.5 2.4 5.5 6 5.5 10L12 21l-5.5-8C6.5 9 8.5 5.4 12 3Z"/><circle cx="12" cy="10" r="1.8"/>'),
    brake:  SVG('<circle cx="12" cy="12" r="8.5"/><circle cx="12" cy="12" r="3.2"/><path d="M12 3.5v5M12 15.5v5M3.5 12h5M15.5 12h5"/>'),
    tyre:   SVG('<circle cx="12" cy="12" r="8.5"/><circle cx="12" cy="12" r="3"/><path d="M12 3.5v5.5M12 15v5.5M3.5 12H9M15 12h5.5"/>'),
    curve:  SVG('<path d="M4 20c0-8 4-12 12-12"/><path d="M12 5.5 16.5 8 14 12.5"/>'),
    drift:  SVG('<path d="M20 12a8 8 0 1 1-2.4-5.7"/><path d="M20.5 4v4h-4"/>'),
    spring: SVG('<path d="M5 4h14M5 20h14"/><path d="M7 7h10l-10 3.5h10L7 14h10l-10 3"/>'),
    height: SVG('<path d="M12 3v18M8 6.5 12 3l4 3.5M8 17.5 12 21l4-3.5"/>'),
    weight: SVG('<path d="M12 3.5a2 2 0 1 1 0 4 2 2 0 0 1 0-4Z"/><path d="M8.5 8.5h7l2.5 12H6l2.5-12Z"/>'),
    wind:   SVG('<path d="M3 8h11a3 3 0 1 0-3-3"/><path d="M3 12h15a3 3 0 1 1-3 3"/><path d="M3 16h7"/>'),
    // presets
    city:   SVG('<path d="M3 21h18"/><path d="M5 21V9l5-3v15"/><path d="M14 21V11l5 2v8"/><path d="M7.5 12h0M7.5 15.5h0"/>'),
    sport:  SVG('<path d="M3 17h18"/><path d="M4.5 17l2-5.5h11l2 5.5"/><circle cx="7.5" cy="17" r="2"/><circle cx="16.5" cy="17" r="2"/>'),
    super:  SVG('<path d="M12 3.5 21 12l-9 8.5L3 12l9-8.5Z"/>'),
    hyper:  SVG('<path d="M12 2.5 14.4 9l6.6.5-5 4.3 1.6 6.4L12 16.7 6.4 20.2 8 13.8 3 9.5 9.6 9 12 2.5Z"/>'),
    rally:  SVG('<path d="M3 19h18"/><path d="M3 19 9 8l4 6 2.5-3.5L21 19"/>'),
    drag:   SVG('<path d="M6 3v18M12 3v18M18 3v18"/>'),
    track:  SVG('<ellipse cx="12" cy="12" rx="9" ry="6"/><ellipse cx="12" cy="12" rx="4" ry="2.2"/>'),
    muscle: SVG('<path d="M4 17h16"/><path d="M5 17l1.5-6h11L19 17"/><path d="M9 11V7h6v4"/>'),
    truck:  SVG('<path d="M2.5 16.5V6.5h11v10"/><path d="M13.5 9.5h4l4 3.5v3.5h-8"/><circle cx="7" cy="17.5" r="2"/><circle cx="17" cy="17.5" r="2"/>'),
    bike:   SVG('<circle cx="5.5" cy="17" r="3.5"/><circle cx="18.5" cy="17" r="3.5"/><path d="M5.5 17 10 8h5l3.5 9M9 8h6"/>'),
    f1:     SVG('<path d="M2.5 15h19"/><path d="M2.5 15l3-3h6l3-2.5h5"/><path d="M17 9.5h4"/><circle cx="6" cy="16.5" r="1.8"/><circle cx="18" cy="16.5" r="1.8"/>'),
};

/* ─── SIMPLE tab ────────────────────────────────────────────── */

const icon = (key) => ICONS[key] || SVG('<circle cx="12" cy="12" r="3"/>');

// Where a simple slider sits (0..100) for a given set of field values.
function sliderPos(sl, values) {
    const [name, from, to] = sl.map[0];
    const v = Number((values || {})[name]);
    if (isNaN(v)) return 50;
    return Math.max(0, Math.min(100, ((v - from) / (to - from)) * 100));
}

function simplePos(sl) {
    return sliderPos(sl, S.values);
}

function renderSimple() {
    const list = $('#simple-list');
    list.innerHTML = '';
    (S.boot.simple || []).forEach(sl => {
        const row = document.createElement('div');
        row.className = 'simple-row';
        row.dataset.key = sl.key;

        const info = document.createElement('div');
        info.className = 'sr-info';
        info.innerHTML = `<strong><i>${icon(sl.icon)}</i>${pick(sl.label)}</strong><small>${pick(sl.desc)}</small>`;

        const sliderWrap = document.createElement('div');
        sliderWrap.className = 'sr-slider';
        const range = document.createElement('input');
        range.type = 'range'; range.min = 0; range.max = 100; range.step = 0.5;
        range.value = simplePos(sl);
        range.style.setProperty('--val', range.value + '%');

        // Typeable value box: the slider is a convenience, not the only
        // way in: you can put an exact number here (and go past the
        // slider's comfort range, up to each field's real catalog limit).
        const val = document.createElement('input');
        val.className = 'sr-val';
        val.type = 'text';
        val.value = Math.round(range.value);

        // apply a 0..100 position to every field this slider drives
        const applyPos = (pos) => {
            const p = Number(pos) / 100;
            sl.map.forEach(([name, from, to]) => {
                const f = S.fieldByName[name];
                let v = from + p * (to - from);
                if (f && f.type === 'int') v = Math.round(v);
                queueApply(name, clampField(f, v));
            });
            renderAdvancedValues();
        };

        range.addEventListener('input', () => {
            range.style.setProperty('--val', range.value + '%');
            val.value = Math.round(range.value);
            row.classList.add('changed');
            applyPos(range.value);
        });

        const commitBox = () => {
            let v = parseFloat(val.value);
            if (isNaN(v)) { val.value = Math.round(simplePos(sl)); return; }
            v = Math.max(0, Math.min(100, v));
            val.value = Math.round(v);
            range.value = v;
            range.style.setProperty('--val', v + '%');
            row.classList.add('changed');
            applyPos(v);
        };
        // live while typing, and snap/normalise on blur or Enter
        val.addEventListener('input', () => {
            const v = parseFloat(val.value);
            if (isNaN(v) || v < 0 || v > 100) return;   // let them finish typing
            range.value = v;
            range.style.setProperty('--val', v + '%');
            row.classList.add('changed');
            applyPos(v);
        });
        val.addEventListener('blur', commitBox);
        val.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') { commitBox(); val.blur(); return; }
            // arrows nudge, shift for bigger steps
            if (e.key === 'ArrowUp' || e.key === 'ArrowDown') {
                e.preventDefault();
                const step = (e.shiftKey ? 10 : 1) * (e.key === 'ArrowUp' ? 1 : -1);
                val.value = Math.max(0, Math.min(100, (parseFloat(val.value) || 0) + step));
                commitBox();
            }
        });
        makeScrub(val, 1, commitBox);

        sliderWrap.appendChild(range);
        row.appendChild(info);
        row.appendChild(sliderWrap);
        row.appendChild(val);
        list.appendChild(row);
    });
}

function refreshSimplePositions() {
    $$('#simple-list .simple-row').forEach(row => {
        const sl = (S.boot.simple || []).find(s => s.key === row.dataset.key);
        if (!sl) return;
        const range = row.querySelector('input[type=range]');
        const val = row.querySelector('.sr-val');
        // don't yank the box out from under someone mid-edit
        if (document.activeElement === val) return;
        range.value = simplePos(sl);
        range.style.setProperty('--val', range.value + '%');
        val.value = Math.round(range.value);
    });
    refreshPerf();     // presets, resets and profile loads land here too
}

/* ─── ADVANCED tab ──────────────────────────────────────────── */

function makeScrub(input, step, onCommit) {
    let startX = null, startV = 0, moved = false;
    input.addEventListener('pointerdown', (e) => {
        if (document.activeElement === input) return;
        startX = e.clientX; startV = parseFloat(input.value) || 0; moved = false;
        input.setPointerCapture(e.pointerId);
    });
    input.addEventListener('pointermove', (e) => {
        if (startX === null) return;
        const dx = e.clientX - startX;
        if (Math.abs(dx) > 2) moved = true;
        if (moved) {
            const mult = e.shiftKey ? 10 : 1;
            const v = startV + Math.round(dx / 3) * step * mult;
            input.value = String(Number(v.toFixed(6)));
            input.dispatchEvent(new Event('input'));
        }
    });
    input.addEventListener('pointerup', (e) => {
        const wasScrub = startX !== null && moved;
        if (startX !== null && !moved) input.focus();
        startX = null;
        // Only commit when the pointer actually scrubbed. A plain click to
        // focus the box would otherwise re-apply the displayed (rounded)
        // value and publish a sync the user never asked for.
        if (wasScrub && onCommit) onCommit();
    });
}

function renderAdvanced() {
    const wrap = $('#adv-cats');
    wrap.innerHTML = '';
    (S.boot.categories || []).forEach((cat, ci) => {
        if (cat.key === 'flags') return; // flags get their own tab
        const fields = S.boot.fields.filter(f => f.cat === cat.key && f.type !== 'flags');
        if (!fields.length) return;

        const box = document.createElement('div');
        box.className = 'adv-cat' + (ci === 0 ? ' open' : '');
        box.dataset.cat = cat.key;

        const head = document.createElement('button');
        head.className = 'adv-cat-head';
        head.innerHTML = `<span>${pick(cat.label)}</span><span class="count">${fields.length}</span>`
            + `<span class="caret">${SVG('<path d="M9 5l7 7-7 7"/>')}</span>`;
        head.addEventListener('click', () => box.classList.toggle('open'));

        const body = document.createElement('div');
        body.className = 'adv-cat-body';

        fields.forEach(f => {
            const row = document.createElement('div');
            row.className = 'field-row';
            row.dataset.field = f.name;

            const nameBox = document.createElement('div');
            nameBox.className = 'fr-name';
            const info = document.createElement('span');
            info.className = 'fr-info';
            info.textContent = 'i';
            bindTip(info, `${f.name}: ${pick(f.desc)}`);
            const lblWrap = document.createElement('div');
            lblWrap.style.minWidth = '0';
            lblWrap.innerHTML = `<span class="lbl">${pick(f.label)}</span><span class="raw mono">${f.name}</span>`;
            nameBox.appendChild(info);
            nameBox.appendChild(lblWrap);
            row.appendChild(nameBox);

            const ctrl = document.createElement('div');
            ctrl.className = 'fr-ctrl';

            if (f.type === 'vec') {
                const vecWrap = document.createElement('div');
                vecWrap.className = 'vec-inputs';
                ['x','y','z'].forEach(axis => {
                    const lab = document.createElement('label');
                    lab.textContent = axis.toUpperCase();
                    const inp = document.createElement('input');
                    inp.className = 'fr-num'; inp.type = 'text';
                    inp.dataset.axis = axis;
                    const commit = () => {
                        const v = parseFloat(inp.value);
                        if (isNaN(v)) return;
                        const cur = Object.assign({x:0,y:0,z:0}, S.values[f.name]);
                        cur[axis] = v;
                        queueApply(f.name, cur);
                        updateRowState(row, f);
                    };
                    inp.addEventListener('input', commit);
                    makeScrub(inp, f.step || 0.01, commit);
                    vecWrap.appendChild(lab); vecWrap.appendChild(inp);
                });
                ctrl.appendChild(vecWrap);
            } else if (f.type === 'enum') {
                const sel = document.createElement('select');
                sel.className = 'fr-num';
                sel.style.width = '150px'; sel.style.cursor = 'pointer'; sel.style.textAlign = 'left';
                (f.options || []).forEach(o => {
                    const opt = document.createElement('option');
                    opt.value = o; opt.textContent = o;
                    sel.appendChild(opt);
                });
                sel.addEventListener('change', () => {
                    S.aiHandling = sel.value;       // file-write only
                    refreshXml();
                    markDirtyAndSync();
                });
                ctrl.appendChild(sel);
                const note = document.createElement('span');
                note.className = 'fr-unit';
                note.textContent = 'file';
                ctrl.appendChild(note);
            } else {
                const range = document.createElement('input');
                range.type = 'range';
                const isSpeed = f.name === 'fInitialDriveMaxFlatVel';
                range.min = f.min; range.max = f.max; range.step = f.step || 0.01;

                const num = document.createElement('input');
                num.className = 'fr-num'; num.type = 'text';

                const unit = document.createElement('span');
                unit.className = 'fr-unit';
                unit.textContent = isSpeed ? speedU() : (f.unit || '');

                const commitNum = () => {
                    let v = parseFloat(num.value);
                    if (isNaN(v)) return;
                    if (isSpeed && S.units === 'mph') v = v / KMH2MPH;
                    if (f.type === 'int') v = Math.round(v);
                    v = clampField(f, v);
                    range.value = v;
                    paintRange(range);
                    queueApply(f.name, v);
                    updateRowState(row, f);
                };
                range.addEventListener('input', () => {
                    let v = parseFloat(range.value);
                    if (f.type === 'int') v = Math.round(v);
                    num.value = fmtVal(f, isSpeed ? toU(v) : v);
                    paintRange(range);
                    queueApply(f.name, v);
                    updateRowState(row, f);
                });
                num.addEventListener('input', commitNum);
                makeScrub(num, f.step || 0.01, null);

                ctrl.appendChild(range);
                ctrl.appendChild(num);
                ctrl.appendChild(unit);
            }
            row.appendChild(ctrl);

            const reset = document.createElement('button');
            reset.className = 'fr-reset';
            reset.innerHTML = SVG('<path d="M3.5 12a8.5 8.5 0 1 0 2.6-6.1"/><path d="M3 4v4.5h4.5"/>');
            reset.title = 'stock';
            reset.addEventListener('click', () => {
                const sv = S.stock[f.name];
                if (sv === undefined) return;
                queueApply(f.name, (typeof sv === 'object') ? Object.assign({}, sv) : sv);
                fillRowInputs(row, f);
                updateRowState(row, f);
                refreshSimplePositions();
            });
            row.appendChild(reset);

            body.appendChild(row);
        });

        box.appendChild(head);
        box.appendChild(body);
        wrap.appendChild(box);
    });
    renderAdvancedValues();
}

function paintRange(range) {
    const min = parseFloat(range.min), max = parseFloat(range.max), v = parseFloat(range.value);
    const pct = ((v - min) / (max - min)) * 100;
    range.style.setProperty('--val', pct + '%');
}

function fillRowInputs(row, f) {
    if (f.type === 'enum') {
        // file-only value, held outside S.values (see S.aiHandling)
        const sel = row.querySelector('select');
        if (sel && S.aiHandling != null) sel.value = S.aiHandling;
        return;
    }
    const v = S.values[f.name];
    if (v === undefined) return;
    if (f.type === 'vec') {
        row.querySelectorAll('.fr-num').forEach(inp => {
            inp.value = fmtVal({ type: 'float' }, v[inp.dataset.axis]);
        });
    } else {
        const isSpeed = f.name === 'fInitialDriveMaxFlatVel';
        const range = row.querySelector('input[type=range]');
        const num = row.querySelector('.fr-num');
        const unit = row.querySelector('.fr-unit');
        if (range) { range.value = v; paintRange(range); }
        if (num) num.value = fmtVal(f, isSpeed ? toU(v) : v);
        if (unit && isSpeed) unit.textContent = speedU();
    }
}

function updateRowState(row, f) {
    row.classList.toggle('changed', fieldChanged(f.name));
}

function renderAdvancedValues() {
    $$('#adv-cats .field-row').forEach(row => {
        const f = S.fieldByName[row.dataset.field];
        if (!f) return;
        fillRowInputs(row, f);
        updateRowState(row, f);
    });
}

function bindAdvSearch() {
    $('#adv-search').addEventListener('input', () => {
        const q = $('#adv-search').value.trim().toLowerCase();
        $$('#adv-cats .field-row').forEach(row => {
            const f = S.fieldByName[row.dataset.field];
            const hay = (f.name + ' ' + pick(f.label) + ' ' + pick(f.desc)).toLowerCase();
            row.style.display = (!q || hay.includes(q)) ? '' : 'none';
        });
        if (q) $$('#adv-cats .adv-cat').forEach(c => c.classList.add('open'));
    });
    $('#btn-collapse-all').addEventListener('click', () => {
        $$('#adv-cats .adv-cat').forEach(c => c.classList.remove('open'));
    });
}

/* ─── FLAGS tab ─────────────────────────────────────────────── */

const FLAG_FIELD = { model: 'strModelFlags', handling: 'strHandlingFlags', damage: 'strDamageFlags' };

function currentFlagValue() {
    if (S.flagTab === 'advanced') return S.advFlags || 0;
    return Number(S.values[FLAG_FIELD[S.flagTab]] || 0);
}

function setFlagValue(v) {
    if (S.flagTab === 'advanced') {
        S.advFlags = v >>> 0;
        refreshXml();
        return;
    }
    // Flags must NOT go through queueApply: the batched 'applyFields'
    // endpoint deliberately skips flag fields (a bulk write of another
    // model's axle/wheel bits breaks vehicles). 'applyField' is the
    // explicit-edit endpoint that is allowed to write them and marks
    // the field as touched so Reset can restore its factory bits.
    const name = FLAG_FIELD[S.flagTab];
    const value = v >>> 0;
    S.values[name] = value;
    nui('applyField', { name, value }).then(reportApply);
    markDirtyAndSync();
    refreshXml();
}

function renderFlags() {
    const set = (S.boot.flagSets || {})[S.flagTab] || {};
    const grid = $('#flag-grid');
    grid.innerHTML = '';
    const value = currentFlagValue();
    const note = $('#flag-note');
    if (S.flagTab === 'advanced') {
        note.textContent = T('adv_note_advanced') + (S.advFlagsAvailable ? '' : ` (${T('no_file')})`);
    } else {
        note.textContent = T('flags_soft_note');
    }

    for (let bit = 0; bit < 32; bit++) {
        const def = set[bit] || set[String(bit)];
        if (!def) continue;
        const on = ((value >>> bit) & 1) === 1;
        const item = document.createElement('div');
        item.className = 'flag-item' + (on ? ' on' : '');
        item.innerHTML = `<span class="bit">${bit}</span><span class="fname">${def.name}</span>`;
        const chk = document.createElement('input');
        chk.type = 'checkbox';
        chk.checked = on;
        item.appendChild(chk);
        bindTip(item, pick(def.desc));
        const toggle = () => {
            const cur = currentFlagValue();
            const next = on ? (cur & ~(1 << bit)) : (cur | (1 << bit));
            setFlagValue(next >>> 0);
            renderFlags();
        };
        item.addEventListener('click', (e) => { e.preventDefault(); toggle(); });
        grid.appendChild(item);
    }
    $('#flag-hex').textContent = (currentFlagValue() >>> 0).toString(16).toUpperCase() || '0';
}

function bindFlagTabs() {
    $$('.flag-tab').forEach(btn => {
        btn.addEventListener('click', () => {
            $$('.flag-tab').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            S.flagTab = btn.dataset.set;
            renderFlags();
        });
    });
}

/* ════════════════════════════════════════════════════════════
   PERFORMANCE TAB
   ------------------------------------------------------------
   Live gauges made no sense here: you read this pane parked in a
   menu, so everything showed zero. Instead it answers two useful
   questions: "what shape is this tune?" (radar, current vs
   factory) and "what did the car actually do out there?" (the
   peaks from the last drive, plus a history you can open).
   ════════════════════════════════════════════════════════════ */

/* ── Tune profile radar ─────────────────────────────────────── */

// Axes are the simple-slider keys whose scale reads "more = more
// performance", so the shape is meaningful at a glance.
const RADAR_AXES = ['topspeed', 'accel', 'braking', 'grip', 'cornering', 'downforce'];

function radarSeries(values) {
    const simple = (S.boot && S.boot.simple) || [];
    return RADAR_AXES.map(key => {
        const sl = simple.find(s => s.key === key);
        return { key, label: sl ? pick(sl.label) : key, v: sl ? sliderPos(sl, values) : 0 };
    });
}

function drawRadar() {
    const cv = $('#perf-radar');
    if (!cv || !S.boot) return;
    const ctx = cv.getContext('2d');
    const W = cv.width, H = cv.height;
    ctx.clearRect(0, 0, W, H);

    const cur = radarSeries(S.values);
    const stock = radarSeries(S.stock);
    const n = cur.length;
    if (!n) return;

    const cx = W / 2, cy = H / 2 + 6, R = Math.min(W, H) / 2 - 46;
    const angleOf = (i) => (Math.PI * 2 * i / n) - Math.PI / 2;
    const css = getComputedStyle(document.documentElement);
    const brand = css.getPropertyValue('--brand-500').trim() || '#1F5EFF';
    const line1 = css.getPropertyValue('--line-1').trim() || '#1F1F21';
    const line3 = css.getPropertyValue('--line-3').trim() || '#38383C';
    const text3 = css.getPropertyValue('--text-3').trim() || '#7C7C82';

    // web
    ctx.strokeStyle = line1;
    ctx.lineWidth = 1;
    [0.25, 0.5, 0.75, 1].forEach(f => {
        ctx.beginPath();
        for (let i = 0; i < n; i++) {
            const a = angleOf(i), x = cx + Math.cos(a) * R * f, y = cy + Math.sin(a) * R * f;
            i ? ctx.lineTo(x, y) : ctx.moveTo(x, y);
        }
        ctx.closePath();
        ctx.stroke();
    });
    // spokes
    ctx.strokeStyle = line1;
    for (let i = 0; i < n; i++) {
        const a = angleOf(i);
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(cx + Math.cos(a) * R, cy + Math.sin(a) * R);
        ctx.stroke();
    }

    const plot = (series, stroke, fill, dash) => {
        ctx.beginPath();
        series.forEach((s, i) => {
            const a = angleOf(i), r = R * Math.max(0.02, s.v / 100);
            const x = cx + Math.cos(a) * r, y = cy + Math.sin(a) * r;
            i ? ctx.lineTo(x, y) : ctx.moveTo(x, y);
        });
        ctx.closePath();
        ctx.setLineDash(dash || []);
        ctx.fillStyle = fill;
        ctx.fill();
        ctx.strokeStyle = stroke;
        ctx.lineWidth = 2;
        ctx.stroke();
        ctx.setLineDash([]);
    };

    // factory underneath, current on top
    plot(stock, line3, 'rgba(255,255,255,.04)', [4, 4]);
    plot(cur, brand, hexToRgba(brand, .18));

    // vertices of the current tune
    ctx.fillStyle = brand;
    cur.forEach((s, i) => {
        const a = angleOf(i), r = R * Math.max(0.02, s.v / 100);
        ctx.beginPath();
        ctx.arc(cx + Math.cos(a) * r, cy + Math.sin(a) * r, 3, 0, Math.PI * 2);
        ctx.fill();
    });

    // labels
    ctx.fillStyle = text3;
    ctx.font = '600 10px Inter, system-ui, sans-serif';
    cur.forEach((s, i) => {
        const a = angleOf(i);
        const x = cx + Math.cos(a) * (R + 20), y = cy + Math.sin(a) * (R + 20);
        ctx.textAlign = Math.abs(Math.cos(a)) < 0.3 ? 'center' : (Math.cos(a) > 0 ? 'left' : 'right');
        ctx.textBaseline = Math.abs(Math.sin(a)) < 0.3 ? 'middle' : (Math.sin(a) > 0 ? 'top' : 'bottom');
        ctx.fillText(s.label.toUpperCase(), x, y);
    });
}

function hexToRgba(hex, a) {
    const c = hexToRgb(hex);
    return `rgba(${c.r},${c.g},${c.b},${a})`;
}

function renderRadarAxes() {
    const wrap = $('#radar-axes');
    if (!wrap) return;
    const cur = radarSeries(S.values), stock = radarSeries(S.stock);
    wrap.innerHTML = '';
    cur.forEach((s, i) => {
        const st = stock[i] ? stock[i].v : 0;
        const delta = s.v - st;
        const row = document.createElement('div');
        row.className = 'rax-row';
        row.innerHTML = `
            <span class="rax-name">${s.label}</span>
            <span class="rax-bar"><i style="width:${Math.round(s.v)}%"></i></span>
            <span class="rax-val mono">${Math.round(s.v)}</span>
            <span class="rax-delta mono ${delta > 0.5 ? 'up' : delta < -0.5 ? 'down' : ''}">${
                Math.abs(delta) < 0.5 ? '-' : (delta > 0 ? '+' : '') + Math.round(delta)
            }</span>`;
        wrap.appendChild(row);
    });
}

/* ── Drive recording ────────────────────────────────────────── */

const DRIVE_KEY = 'apexh_drives';
const DRIVE_MAX = 8;          // kept per vehicle
const TRACE_MAX = 160;        // samples in a stored speed trace

function loadDrives() {
    try { return JSON.parse(localStorage.getItem(DRIVE_KEY) || '{}') || {}; }
    catch (e) { return {}; }
}
function saveDrives(all) {
    try { localStorage.setItem(DRIVE_KEY, JSON.stringify(all)); } catch (e) { /* full */ }
}
function drivesFor(model) {
    const all = loadDrives();
    return Array.isArray(all[model]) ? all[model] : [];
}

// A drive accumulates passively while telemetry streams (i.e. whenever
// the HUD is on or the pane is open), the player never has to arm it.
function resetDrive(model) {
    S.drive = {
        model: model || (S.boot && S.boot.vehicle && S.boot.vehicle.name) || '?',
        samples: 0, moving: 0,
        peaks: { speed: 0, gLat: 0, gLong: 0, rpm: 0, slip: 0 },
        trace: [],
    };
}

function recordTelemetry(d) {
    if (!S.drive) resetDrive();
    const dr = S.drive;
    dr.samples++;
    if (d.speed > 1) dr.moving++;
    const p = dr.peaks;
    if (d.speed > p.speed) p.speed = d.speed;
    if (Math.abs(d.gLat) > p.gLat) p.gLat = Math.abs(d.gLat);
    if (Math.abs(d.gLong) > p.gLong) p.gLong = Math.abs(d.gLong);
    if (d.rpm > p.rpm) p.rpm = d.rpm;
    (d.wheels || []).forEach(w => { if (w.slip > p.slip) p.slip = w.slip; });
    dr.trace.push(Math.round(d.speed));
    if (dr.trace.length > TRACE_MAX) dr.trace.shift();
}

// Commit whatever was driven into this vehicle's history. Called when the
// studio opens (so the pane shows the lap you just did) and when the HUD
// is switched off.
function commitDrive() {
    const dr = S.drive;
    if (!dr || dr.moving < 12 || dr.peaks.speed < 5) return false;
    const all = loadDrives();
    const list = Array.isArray(all[dr.model]) ? all[dr.model] : [];
    list.unshift({
        t: Date.now(),
        peaks: dr.peaks,
        trace: dr.trace.slice(),
        samples: dr.samples,
    });
    all[dr.model] = list.slice(0, DRIVE_MAX);
    saveDrives(all);
    resetDrive(dr.model);
    return true;
}

/* ── Rendering: last drive + history ────────────────────────── */

function fmtWhen(ts) {
    const d = new Date(ts);
    const pad = (n) => String(n).padStart(2, '0');
    return `${pad(d.getDate())}/${pad(d.getMonth() + 1)} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function traceSvg(trace, w, h) {
    if (!trace || trace.length < 2) return '';
    const max = Math.max(60, ...trace);
    const pts = trace.map((v, i) => {
        const x = (i / (trace.length - 1)) * w;
        const y = h - (v / max) * (h - 4) - 2;
        return `${x.toFixed(1)},${y.toFixed(1)}`;
    });
    return `<svg class="trace" viewBox="0 0 ${w} ${h}" preserveAspectRatio="none">
        <polyline points="${pts.join(' ')}" fill="none" stroke="var(--brand-500)" stroke-width="2"
            stroke-linejoin="round" stroke-linecap="round"/>
        <polygon points="0,${h} ${pts.join(' ')} ${w},${h}" fill="var(--brand-a12)" stroke="none"/>
    </svg>`;
}

function driveStatsHtml(rec) {
    const p = rec.peaks || {};
    const cell = (label, value) =>
        `<div class="ds-cell"><span class="ds-val mono">${value}</span><label>${label}</label></div>`;
    return `<div class="drive-stats">
        ${cell(T('peak_speed'), Math.round(toU(p.speed || 0)) + ' ' + speedU())}
        ${cell(T('peak_glat'), (p.gLat || 0).toFixed(2) + ' G')}
        ${cell(T('peak_glong'), (p.gLong || 0).toFixed(2) + ' G')}
        ${cell(T('peak_rpm'), Math.round((p.rpm || 0) * 100) + '%')}
        ${cell(T('peak_slip'), Math.round((p.slip || 0) * 100) + '%')}
    </div>`;
}

function renderLastDrive() {
    const box = $('#drive-last');
    if (!box || !S.boot) return;
    const list = drivesFor(S.boot.vehicle.name);
    const rec = list[0];
    if (!rec) {
        box.innerHTML = `<div class="drive-empty">${T('drive_empty')}</div>`;
        return;
    }
    box.innerHTML = `
        <div class="perf-head">
            <span class="micro-label">${fmtWhen(rec.t)}</span>
        </div>
        ${driveStatsHtml(rec)}
        <div class="trace-wrap">${traceSvg(rec.trace, 600, 90)}</div>
        <div class="trace-cap">${T('speed_trace')}</div>`;
}

function renderDriveHistory() {
    const wrap = $('#drive-history');
    if (!wrap || !S.boot) return;
    const list = drivesFor(S.boot.vehicle.name);
    wrap.innerHTML = '';
    if (list.length < 2) {
        wrap.innerHTML = `<div class="drive-empty">${T('history_empty')}</div>`;
        return;
    }
    list.slice(1).forEach((rec) => {
        const row = document.createElement('div');
        row.className = 'dh-row';
        row.innerHTML = `
            <button class="dh-head">
                <span class="dh-when mono">${fmtWhen(rec.t)}</span>
                <span class="dh-peak mono">${Math.round(toU((rec.peaks || {}).speed || 0))} ${speedU()}</span>
                <span class="dh-caret">${SVG('<path d="M9 5l7 7-7 7"/>')}</span>
            </button>
            <div class="dh-body">
                ${driveStatsHtml(rec)}
                <div class="trace-wrap">${traceSvg(rec.trace, 600, 70)}</div>
            </div>`;
        row.querySelector('.dh-head').addEventListener('click', () => row.classList.toggle('open'));
        wrap.appendChild(row);
    });
}

function renderPerformance() {
    drawRadar();
    renderRadarAxes();
    renderLastDrive();
    renderDriveHistory();
}

/* ─── TELEMETRY stream (feeds the HUD + the recorder) ────────── */

function updateTeleHud(d) {
    $('#hud-speed').textContent = Math.round(toU(d.speed));
    $('#hud-speed-u').textContent = speedU();
    $('#hud-gear').textContent = d.gear === 0 ? 'R' : d.gear;
    // flat palette: the redline is a colour SWITCH, not a blend
    const rpmFill = $('#hud-rpm-fill');
    rpmFill.style.width = Math.round(d.rpm * 100) + '%';
    rpmFill.className = d.rpm >= 0.92 ? 'redline' : d.rpm >= 0.75 ? 'high' : '';
    $('#hud-g').textContent = Math.abs(d.gLat).toFixed(1) + '/' + Math.abs(d.gLong).toFixed(1);
    const wrap = $('#hud-wheels');
    const wheels = d.wheels || [];
    while (wrap.childElementCount < wheels.length) {
        const dot = document.createElement('span');
        dot.className = 'hud-wheel';
        wrap.appendChild(dot);
    }
    while (wrap.childElementCount > wheels.length) wrap.lastElementChild.remove();
    wheels.forEach((w, i) => {
        const el = wrap.children[i];
        el.style.background = w.slip > 0.5 ? 'var(--red)' : w.slip > 0.18 ? 'var(--yellow)' : 'var(--green)';
    });
}

function onTelemetry(d) {
    // The HUD is the only live surface now. The pane shows recorded
    // results, so every sample just feeds the recorder, which means a
    // drive is captured whether or not the studio is open.
    if (S.teleHud) updateTeleHud(d);
    recordTelemetry(d);
}

/* ─── TIMING tab + HUD ──────────────────────────────────────── */

function fmtT(v) { return v == null ? '-' : v.toFixed(2) + 's'; }

// persisted results (survive close/reopen and restarts)
function loadTimingSaved() {
    try { S.timingSaved = JSON.parse(localStorage.getItem('apexh_timing') || 'null'); } catch (e) { S.timingSaved = null; }
}
function saveTimingSaved() {
    try { localStorage.setItem('apexh_timing', JSON.stringify(S.timingSaved)); } catch (e) { /* full */ }
}

function renderTimingSaved() {
    const s = S.timingSaved || {};
    $('#tr-100').textContent = fmtT(s.t100);
    $('#tr-200').textContent = fmtT(s.t200);
    $('#tr-quarter').textContent = fmtT(s.tQuarter);
    $('#tr-trap').textContent = s.quarterSpeed ? Math.round(toU(s.quarterSpeed)) + ' ' + speedU() : '-';
    $('#tr-brake').textContent = s.brakeDist != null ? s.brakeDist.toFixed(1) + ' m' : '-';
    const hist = $('#timing-history');
    hist.innerHTML = '';
    (s.history || []).forEach(h => {
        const row = document.createElement('div');
        row.className = 'th-row';
        row.innerHTML = h;
        hist.appendChild(row);
    });
}

function onTimingLive(d) {
    $('#th-time').textContent = d.t.toFixed(2);
    $('#th-speed').textContent = Math.round(toU(d.speed));
    $('#th-speed-u').textContent = speedU();
    $('#th-dist').textContent = Math.round(d.dist);
    setTimingState('running');
}

function onTimingResult(r) {
    S.timingSaved = S.timingSaved || { history: [] };
    const s = S.timingSaved;
    s.history = s.history || [];
    if (r.kind === 'accel') {
        const d = r.data;
        s.t100 = d.t100; s.t200 = d.t200;
        s.tQuarter = d.tQuarter; s.quarterSpeed = d.quarterSpeed;
        s.history.unshift(`<b>ACCEL</b><span>0-100 ${fmtT(d.t100)}</span><span>0-200 ${fmtT(d.t200)}</span><span>¼ ${fmtT(d.tQuarter)}</span><span>trap ${d.quarterSpeed ? Math.round(toU(d.quarterSpeed)) : '-'}</span>`);
        $('#th-results').innerHTML = `<span>0-100 <b>${fmtT(d.t100)}</b></span><span>¼ <b>${fmtT(d.tQuarter)}</b></span>`;
    } else if (r.kind === 'brake') {
        const d = r.data;
        s.brakeDist = d.distance;
        // fromSpeed arrives in km/h: convert like the accel trap speed does,
        // otherwise the history reads "100-0" while the tab is set to mph
        s.history.unshift(`<b>BRAKE</b><span>${Math.round(toU(d.fromSpeed))}-0 ${speedU()}</span><span>${d.distance.toFixed(1)} m</span>`);
        $('#th-results').innerHTML = `<span>100-0 <b>${d.distance.toFixed(1)} m</b></span>`;
    }
    s.history = s.history.slice(0, 8);
    saveTimingSaved();
    renderTimingSaved();
    // The run is over; the next one needs no button press: come to a full
    // stop and the Lua side arms again on its own (it sends 'timingArmed').
    setTimingState('idle');
}

/* ─── PRESETS tab ───────────────────────────────────────────── */

function renderPresets() {
    const grid = $('#preset-grid');
    grid.innerHTML = '';
    (S.boot.presets || []).forEach(p => {
        const card = document.createElement('div');
        card.className = 'preset-card';
        card.innerHTML = `<h3><i>${icon(p.icon)}</i>${pick(p.label)}</h3><p>${pick(p.desc)}</p>`;
        const btn = document.createElement('button');
        btn.className = 'btn btn-ghost sm';
        btn.textContent = T('apply');
        btn.addEventListener('click', async () => {
            Object.entries(p.fields).forEach(([k, v]) => { S.values[k] = v; });
            await nui('applyFields', { fields: p.fields });
            markDirtyAndSync();
            renderAdvancedValues();
            refreshSimplePositions();
            renderFlags();
            refreshXml();
            toast(T('preset_applied'), 'success');
        });
        card.appendChild(btn);
        grid.appendChild(card);
    });
}

/* ─── PROFILES tab ──────────────────────────────────────────── */

function renderProfiles() {
    const list = $('#prof-list');
    list.innerHTML = '';
    (S.profiles || []).forEach(p => {
        const row = document.createElement('div');
        row.className = 'prof-row';
        row.innerHTML = `<span class="pr-name">${p.name}</span><span class="pr-meta mono">${p.model || ''} · ${(p.created || '').slice(0, 10)}</span>`;
        const load = document.createElement('button');
        load.className = 'btn btn-ghost sm';
        load.textContent = T('load');
        load.addEventListener('click', async () => {
            const r = await nui('profileApply', { id: p.id });
            if (r && r.ok) {
                S.values = r.handling || S.values;
                markDirtyAndSync();
                renderAdvancedValues(); refreshSimplePositions(); renderFlags(); refreshXml();
            }
        });
        const del = document.createElement('button');
        del.className = 'btn btn-danger sm';
        del.innerHTML = SVG('<path d="M4 7h16M9.5 7V4.5h5V7M6.5 7l1 13h9l1-13"/><path d="M10 11v5M14 11v5"/>');
        del.addEventListener('click', async () => {
            const r = await nui('profileDelete', { id: p.id });
            if (r && r.ok) {
                S.profiles = S.profiles.filter(x => x.id !== p.id);
                renderProfiles();
            } else if (r && r.err) {
                toast(r.err, 'error');
            }
        });
        row.appendChild(load); row.appendChild(del);
        list.appendChild(row);
    });
}

function bindProfiles() {
    $('#btn-prof-save').addEventListener('click', async () => {
        const name = $('#prof-name').value.trim();
        if (!name) { $('#prof-name').focus(); return; }
        const r = await nui('profileSave', { name });
        if (r && r.ok) {
            $('#prof-name').value = '';
            const lr = await nui('profileList');
            S.profiles = (lr && lr.list) || [];
            renderProfiles();
        } else if (r && r.err) {
            toast(r.err, 'error');
        }
    });

    $('#btn-share-export').addEventListener('click', () => {
        // APEXH2 carries an explicit space tag. APEXH1 codes had none and
        // were minted from a build whose display values were double-converted
        // (steering ~2291, every bias 1.0), so they are indistinguishable
        // from healthy ones by content, the version prefix is the only
        // safe way to tell them apart. Advanced flags stay out of the code:
        // they are file-only and belong to the target car's own meta.
        const payload = { v: 2, s: 'meta', m: S.boot.vehicle.name, f: S.values };
        const code = 'APEXH2:' + btoa(unescape(encodeURIComponent(JSON.stringify(payload))));
        const tmp = document.createElement('textarea');
        tmp.value = code;
        document.body.appendChild(tmp);
        tmp.select();
        document.execCommand('copy');
        tmp.remove();
        toast(T('copied'), 'success');
    });

    $('#btn-share-import').addEventListener('click', async () => {
        const raw = $('#share-input').value.trim();
        if (raw.startsWith('APEXH1:')) { toast(T('share_legacy'), 'error'); return; }
        if (!raw.startsWith('APEXH2:')) { toast(T('share_bad'), 'error'); return; }
        try {
            const payload = JSON.parse(decodeURIComponent(escape(atob(raw.slice(7)))));
            if (!payload || typeof payload.f !== 'object' || payload.s !== 'meta') throw new Error('bad');
            // A share code is foreign data: keep only known fields and clamp
            // every one to its catalog range, so a hand-edited or corrupted
            // code can never hand a live car a degenerate value.
            const fields = {};
            for (const [k, val] of Object.entries(payload.f)) {
                const f = S.fieldByName[k];
                if (!f || f.type === 'flags' || f.type === 'enum') continue;
                if (f.type === 'vec') {
                    if (!val || typeof val !== 'object') continue;
                    const out = {};
                    for (const ax of ['x', 'y', 'z']) {
                        const n = Number(val[ax]);
                        if (!Number.isFinite(n)) { out.bad = true; break; }
                        out[ax] = clampField(f, n);
                    }
                    if (!out.bad) fields[k] = out;
                } else {
                    const n = Number(val);
                    if (Number.isFinite(n)) fields[k] = clampField(f, f.type === 'int' ? Math.round(n) : n);
                }
            }
            if (!Object.keys(fields).length) throw new Error('empty');
            await nui('applyFields', { fields });
            // Advanced flags are NOT adopted from a foreign tune: they are
            // file-only bits that the next "Write to file" would bake into
            // THIS car's handling.meta.
            // flags are intentionally NOT applied from foreign tunes:
            // resync from the real vehicle so the UI shows the truth
            const h = await nui('getHandling');
            if (h && h.ok) S.values = h.handling;
            markDirtyAndSync();
            renderAdvancedValues(); refreshSimplePositions(); renderFlags(); refreshXml();
            $('#share-input').value = '';
            toast(T('share_ok'), 'success');
        } catch (e) {
            toast(T('share_bad'), 'error');
        }
    });
}

/* ─── XML tab ───────────────────────────────────────────────── */

function metaFloat(v) { return Number(v || 0).toFixed(6); }
function hex32(v) { const n = (Number(v) || 0) >>> 0; return n === 0 ? '0' : n.toString(16).toUpperCase(); }
function esc(s) { return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

function buildXml() {
    const lines = [];
    lines.push('<?xml version="1.0" encoding="UTF-8"?>');
    lines.push('<CHandlingDataMgr>');
    lines.push('  <HandlingData>');
    lines.push('    <Item type="CHandlingData">');
    lines.push(`      <handlingName>${S.boot.vehicle.name}</handlingName>`);
    (S.boot.fields || []).forEach(f => {
        // file-only fields live outside S.values
        const v = f.type === 'enum' ? S.aiHandling : S.values[f.name];
        if (v === undefined || v === null) return;
        if (f.type === 'vec') {
            lines.push(`      <${f.name} x="${metaFloat(v.x)}" y="${metaFloat(v.y)}" z="${metaFloat(v.z)}" />`);
        } else if (f.type === 'flags') {
            lines.push(`      <${f.name}>${hex32(v)}</${f.name}>`);
        } else if (f.type === 'enum') {
            lines.push(`      <${f.name}>${v}</${f.name}>`);
        } else if (f.type === 'int') {
            lines.push(`      <${f.name} value="${Math.round(v)}" />`);
        } else {
            lines.push(`      <${f.name} value="${metaFloat(v)}" />`);
        }
    });
    if (S.advFlags != null) {
        lines.push('      <SubHandlingData>');
        lines.push('        <Item type="CCarHandlingData">');
        lines.push(`          <strAdvancedFlags>${hex32(S.advFlags)}</strAdvancedFlags>`);
        lines.push('        </Item>');
        lines.push('        <Item type="NULL" />');
        lines.push('        <Item type="NULL" />');
        lines.push('      </SubHandlingData>');
    }
    lines.push('    </Item>');
    lines.push('  </HandlingData>');
    lines.push('</CHandlingDataMgr>');
    return lines.join('\n');
}

let xmlTimer = null;
function refreshXml() {
    clearTimeout(xmlTimer);
    xmlTimer = setTimeout(() => {
        if (!S.boot) return;
        const xml = buildXml();
        const html = esc(xml)
            .replace(/(&lt;\/?[\w]+)([^&]*?)(\/?&gt;)/g, '<span class="xtag">$1</span>$2<span class="xtag">$3</span>')
            .replace(/"([^"]*)"/g, '"<span class="xval">$1</span>"');
        $('#xml-view').innerHTML = html;
    }, 120);
}

// Buttons in the action bar are composite (SVG icon + label span). Writing
// textContent on the button itself would delete the icon and the data-i18n
// span for good, so always target the label node.
function labelNode(btn) {
    return btn.querySelector('span[data-i18n]') || btn.querySelector('span') || btn;
}

// Fields that have no runtime native and therefore never come back from
// Editor.Read: they live only in the UI and must ride along with the
// file-write / export request or the user's choice is silently lost.
function fileOnlyPayload() {
    return { advancedFlags: S.advFlags, aiHandling: S.aiHandling };
}

function bindXml() {
    $('#btn-xml-copy').addEventListener('click', () => {
        const tmp = document.createElement('textarea');
        tmp.value = buildXml();
        document.body.appendChild(tmp);
        tmp.select();
        document.execCommand('copy');
        tmp.remove();
        toast(T('copied'), 'success');
    });
    $('#btn-xml-export').addEventListener('click', async () => {
        await nui('exportXml', fileOnlyPayload());
    });
    // two-click confirm inline (CEF's blocking confirm() can hang)
    let restoreArmed = false, restoreTimer = null;
    $('#btn-xml-restore').addEventListener('click', async (e) => {
        if (S.access !== 'full') return;
        const btn = e.currentTarget;
        const lbl = labelNode(btn);
        if (!restoreArmed) {
            restoreArmed = true;
            btn.classList.add('btn-danger');
            lbl.textContent = T('restore_confirm_short') || 'Click again to confirm';
            clearTimeout(restoreTimer);
            restoreTimer = setTimeout(() => {
                restoreArmed = false;
                btn.classList.remove('btn-danger');
                lbl.textContent = T('restore_file');
            }, 3000);
            return;
        }
        clearTimeout(restoreTimer);
        restoreArmed = false;
        btn.classList.remove('btn-danger');
        lbl.textContent = T('restore_file');
        const r = await nui('restoreFile');
        if (r && r.ok) {
            S.values = r.handling || S.values;
            renderAdvancedValues(); refreshSimplePositions(); renderFlags(); refreshXml();
        }
    });
    // Writing rewrites a file inside another resource, two-click arm,
    // same pattern as Restore original (CEF's confirm() blocks the frame).
    let writeArmed = false, writeTimer = null, writeLabel = null;
    $('#btn-xml-rescan').addEventListener('click', () => rescanMeta(false));
    $('#btn-write').addEventListener('click', async (e) => {
        if (S.access !== 'full') return;
        const btn = e.currentTarget;
        const lbl = labelNode(btn);
        if (writeLabel === null) writeLabel = lbl.textContent;

        // No file located yet: rescan first and say what happened, rather
        // than sitting there unclickable.
        if (!S.metaFound) {
            btn.disabled = true;
            const found = await rescanMeta(true);
            btn.disabled = false;
            if (!found) {
                toast((S.metaInfo && S.metaInfo.reason) || T('meta_missing'), 'error');
                return;
            }
            toast(T('meta_found'), 'success');
            return;                       // let them confirm on the next click
        }

        if (!writeArmed) {
            writeArmed = true;
            btn.classList.add('btn-danger');
            lbl.textContent = T('confirm_write_short');
            // the two-click arm is invisible on a wide button: say it
            toast(T('confirm_write_short'), 'info');
            clearTimeout(writeTimer);
            writeTimer = setTimeout(() => {
                writeArmed = false;
                btn.classList.remove('btn-danger');
                lbl.textContent = writeLabel;
            }, 3000);
            return;
        }
        clearTimeout(writeTimer);
        writeArmed = false;
        btn.classList.remove('btn-danger');
        lbl.textContent = writeLabel;
        const w = await nui('metaWrite', fileOnlyPayload());
        if (w && !w.ok) toast(w.err || w.reason || T('meta_missing'), 'error');
        const info = await nui('metaFind');
        if (info) onMetaInfo(info);
    });
}

function onMetaInfo(info) {
    S.metaInfo = info;
    S.metaFound = !!(info && info.found);
    const box = $('#meta-status');
    if (S.metaFound) {
        box.className = 'meta-status found';
        $('#ms-title').textContent = T('meta_found');
        $('#ms-path').textContent = info.path || '';
        if (info.advancedFlags != null) {
            S.advFlags = info.advancedFlags >>> 0;
            S.advFlagsAvailable = true;
        } else {
            S.advFlagsAvailable = true;   // file found; tag can be inserted
            if (S.advFlags == null) S.advFlags = 0;
        }
        // only adopt the file's value when the user has not chosen one
        if (info.aiHandling && S.aiHandling == null) S.aiHandling = info.aiHandling;
    } else {
        box.className = 'meta-status missing';
        $('#ms-title').textContent = T('meta_missing');
        // the server now says WHY: show that instead of a generic hint
        $('#ms-path').textContent = (info && info.reason) || T('meta_missing_hint');
        S.advFlagsAvailable = false;
    }
    updateWriteButton();
    renderFlags();
    renderAdvancedValues();
    refreshXml();
}

// The write button must never become a control that ignores clicks. It
// stays live for anyone allowed to write files; when no handling.meta has
// been located yet, clicking it rescans and then explains itself. The old
// behaviour (disabled until a metaInfo said found) turned every failed
// lookup into a button that could not be pressed and gave no reason:
// exactly the "I can't click this one" report.
function updateWriteButton() {
    const allowed = S.access === 'full' && !!(S.boot && S.boot.metaWriteEnabled);
    const btn = $('#btn-write');
    btn.disabled = !allowed;
    btn.classList.toggle('needs-scan', allowed && !S.metaFound);
    btn.title = allowed
        ? (S.metaFound ? '' : T('write_needs_file'))
        : T('write_disabled');
    const rescan = $('#btn-xml-rescan');
    if (rescan) rescan.hidden = S.access !== 'full';
}

// Ask the server to rebuild its file index and look this car up again.
async function rescanMeta(quiet) {
    const box = $('#meta-status');
    box.className = 'meta-status';
    $('#ms-title').textContent = T('meta_searching');
    $('#ms-path').textContent = '';
    const r = await nui('metaRescan');
    // never leave the status stuck on "Locating…": a dropped callback has
    // to land somewhere the user can see it too
    onMetaInfo((r && r.meta) || { found: false, reason: T('meta_missing_hint') });
    if (!quiet) {
        if (r && r.meta && r.meta.found) toast(T('meta_found'), 'success');
        else toast((r && r.meta && r.meta.reason) || T('meta_missing'), 'error');
    }
    return !!(r && r.meta && r.meta.found);
}

/* ─── Tabs / access gating ──────────────────────────────────── */

function switchTab(key) {
    $$('.mode-tab').forEach(b => b.classList.toggle('active', b.dataset.tab === key));
    $$('.pane').forEach(p => p.classList.toggle('active', p.id === 'pane-' + key));

    const wantTele = key === 'telemetry';
    if (wantTele !== S.teleOn) {
        S.teleOn = wantTele;
        // the Lua side keeps streaming if the driving HUD is enabled
        nui('telemetry', { on: wantTele || S.teleHud });
    }
    if (wantTele) renderPerformance();
    if (key === 'timing') renderTimingSaved();
}

function applyAccessGates() {
    const full = S.access === 'full';
    const badge = $('#access-badge');
    badge.textContent = full ? 'FULL' : 'SIMPLE';
    badge.classList.toggle('simple', !full);
    // simple users: no advanced/flags/xml write, no server save
    ['advanced', 'flags', 'xml'].forEach(tab => {
        const btn = document.querySelector(`.mode-tab[data-tab="${tab}"]`);
        btn.style.display = full ? '' : 'none';
    });
    $('#btn-override').style.display = full ? '' : 'none';
    $('#btn-write').style.display = full ? '' : 'none';
    // both footer actions are full-only: hide the whole bar for
    // SIMPLE users instead of leaving an empty strip
    $('#actionbar').hidden = !full;
    updateWriteButton();
}

/* ════════════════════════════════════════════════════════════
   THEMING: every CSS var is derived from just two hex colors
   (brand + background), exactly like apex_bossmenu/apex_clothing.
   ════════════════════════════════════════════════════════════ */

const THEME_DEFAULT = { brand: '#1F5EFF', bg: '#0A0A0B', glow: 1, compact: false };
const BRAND_PRESETS = ['#1F5EFF', '#7C5CFF', '#02CC04', '#1C7E50', '#FF4D6D', '#FF8A00', '#00C2C7', '#E4C24A'];
const BG_PRESETS = [
    { label: 'Obsidian', v: '#0A0A0B' }, { label: 'Charcoal', v: '#121316' },
    { label: 'Midnight', v: '#0B1020' }, { label: 'Forest', v: '#0A140F' },
    { label: 'Wine', v: '#160A10' }, { label: 'Slate', v: '#14171C' },
];

let TH = Object.assign({}, THEME_DEFAULT);

function hexToRgb(h) {
    h = String(h || '').replace('#', '');
    if (h.length === 3) h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2];
    const n = parseInt(h, 16) || 0;
    return { r: (n >> 16) & 255, g: (n >> 8) & 255, b: n & 255 };
}
const mix = (c, t, a) => ({
    r: Math.round(c.r + (t.r - c.r) * a),
    g: Math.round(c.g + (t.g - c.g) * a),
    b: Math.round(c.b + (t.b - c.b) * a),
});
const rgbStr = (c) => `rgb(${c.r},${c.g},${c.b})`;
const rgbaStr = (c, a) => `rgba(${c.r},${c.g},${c.b},${a})`;

function applyTheme(th) {
    const root = document.documentElement.style;
    const white = { r: 255, g: 255, b: 255 };
    const black = { r: 0, g: 0, b: 0 };

    // Compact mode is independent of the colour ladders.
    root.setProperty('--fs-base', th.compact ? '12px' : '13px');
    document.body.classList.toggle('compact', !!th.compact);

    // At stock colours, leave the hand-tuned Apex palette in the
    // stylesheet alone: deriving it from two hex values lands a few
    // units off the canonical neutrals. Only a customised theme gets
    // the generated ladders.
    const stockBrand = th.brand.toLowerCase() === THEME_DEFAULT.brand.toLowerCase();
    const stockBg = th.bg.toLowerCase() === THEME_DEFAULT.bg.toLowerCase();
    const stockGlow = (th.glow === undefined ? 1 : th.glow) === 1;
    if (stockBrand && stockBg && stockGlow) {
        [
            'brand-500','brand-600','brand-700','brand-800','brand-400','brand-300','brand-200',
            'brand-a05','brand-a08','brand-a12','brand-a18','brand-a25','brand-a40',
            'surface-0','surface-1','surface-2','surface-3','surface-4','surface-5',
            'line-1','line-2','line-3','line-4',
        ].forEach(k => root.removeProperty('--' + k));
        return;
    }

    const b = hexToRgb(th.brand);
    root.setProperty('--brand-500', rgbStr(b));
    root.setProperty('--brand-600', rgbStr(mix(b, black, 0.18)));
    root.setProperty('--brand-700', rgbStr(mix(b, black, 0.34)));
    root.setProperty('--brand-800', rgbStr(mix(b, black, 0.48)));
    root.setProperty('--brand-400', rgbStr(mix(b, white, 0.22)));
    root.setProperty('--brand-300', rgbStr(mix(b, white, 0.42)));
    root.setProperty('--brand-200', rgbStr(mix(b, white, 0.6)));
    const g = th.glow === undefined ? 1 : th.glow;
    // same alpha ladder as the canonical palette
    [['a05', .06], ['a08', .10], ['a12', .15], ['a18', .18], ['a25', .25], ['a40', .40]]
        .forEach(([k, a]) => root.setProperty('--brand-' + k, rgbaStr(b, a * g)));

    const bg = hexToRgb(th.bg);
    root.setProperty('--surface-0', rgbStr(bg));
    root.setProperty('--surface-1', rgbStr(mix(bg, white, .045)));
    root.setProperty('--surface-2', rgbStr(mix(bg, white, .075)));
    root.setProperty('--surface-3', rgbStr(mix(bg, white, .125)));
    root.setProperty('--surface-4', rgbStr(mix(bg, white, .18)));
    root.setProperty('--surface-5', rgbStr(mix(bg, white, .24)));
    root.setProperty('--line-1', rgbStr(mix(bg, white, .09)));
    root.setProperty('--line-2', rgbStr(mix(bg, white, .14)));
    root.setProperty('--line-3', rgbStr(mix(bg, white, .22)));
    root.setProperty('--line-4', rgbStr(mix(bg, white, .32)));
}

function saveTheme() {
    try { localStorage.setItem('apexh_theme', JSON.stringify(TH)); } catch (e) { /* noop */ }
}
function loadTheme() {
    try {
        const raw = JSON.parse(localStorage.getItem('apexh_theme') || 'null');
        if (raw) TH = Object.assign({}, THEME_DEFAULT, raw);
    } catch (e) { TH = Object.assign({}, THEME_DEFAULT); }
    applyTheme(TH);
}

function markSwatches() {
    $$('#brand-swatches .swatch').forEach(s =>
        s.classList.toggle('active', s.dataset.hex.toLowerCase() === TH.brand.toLowerCase()));
    $$('#bg-swatches .swatch').forEach(s =>
        s.classList.toggle('active', s.dataset.hex.toLowerCase() === TH.bg.toLowerCase()));
    $('#brand-input').value = TH.brand;
    $('#bg-input').value = TH.bg;
    $('#brand-hex').textContent = TH.brand.toUpperCase();
    $('#bg-hex').textContent = TH.bg.toUpperCase();
    $('#glow-range').value = Math.round((TH.glow ?? 1) * 100);
    $('#glow-range').style.setProperty('--val', (Math.round((TH.glow ?? 1) * 100) / 2) + '%');
    $('#glow-val').textContent = Math.round((TH.glow ?? 1) * 100) + '%';
    $('#compact-toggle').checked = !!TH.compact;
    applyHudPos();
}

function setBrand(hex) { TH.brand = hex; applyTheme(TH); saveTheme(); markSwatches(); }
function setBg(hex) { TH.bg = hex; applyTheme(TH); saveTheme(); markSwatches(); }

function buildSettings() {
    const bWrap = $('#brand-swatches');
    bWrap.innerHTML = '';
    BRAND_PRESETS.forEach(hex => {
        const s = document.createElement('button');
        s.className = 'swatch';
        s.style.background = hex;
        s.dataset.hex = hex;
        s.addEventListener('click', () => setBrand(hex));
        bWrap.appendChild(s);
    });

    const gWrap = $('#bg-swatches');
    gWrap.innerHTML = '';
    BG_PRESETS.forEach(p => {
        const s = document.createElement('button');
        s.className = 'swatch';
        s.style.background = p.v;
        s.dataset.hex = p.v;
        s.title = p.label;
        s.addEventListener('click', () => setBg(p.v));
        gWrap.appendChild(s);
    });

    $('#brand-input').addEventListener('input', (e) => setBrand(e.target.value));
    $('#bg-input').addEventListener('input', (e) => setBg(e.target.value));

    $$('.hud-pos').forEach(b => b.addEventListener('click', () => setHudPos(b.dataset.pos)));

    $('#glow-range').addEventListener('input', (e) => {
        TH.glow = Number(e.target.value) / 100;
        e.target.style.setProperty('--val', (Number(e.target.value) / 2) + '%');
        $('#glow-val').textContent = e.target.value + '%';
        applyTheme(TH);
        saveTheme();
    });

    $('#compact-toggle').addEventListener('change', (e) => {
        TH.compact = e.target.checked;
        applyTheme(TH);
        saveTheme();
    });

    $('#btn-theme-reset').addEventListener('click', () => {
        TH = Object.assign({}, THEME_DEFAULT);
        applyTheme(TH);
        saveTheme();
        markSwatches();
    });
}

/* ════════════════════════════════════════════════════════════
   TUTORIAL
   ════════════════════════════════════════════════════════════ */

/* The tutorial ships in every locale file, so it follows Config.locale
   like the rest of the interface. This English copy is the fallback for
   the first paint and for any language that omits a step. */

const HELP_EN = [
    {
        "icon": "speed",
        "title": "What this is",
        "body": "A complete handling editor. Every change applies to your vehicle <b>instantly</b> and is synced to every other player, so what you feel is what everyone gets.",
        "list": [
            "Open it in the driver seat with <code>/handling</code>.",
            "Leaving the vehicle closes the studio and hides the overlays.",
            "<b>Reset to stock</b> (bottom left) always restores the factory values, exactly as they were."
        ]
    },
    {
        "icon": "curve",
        "title": "Simple vs Advanced",
        "body": "Two editors for two kinds of people.",
        "list": [
            "<b>Simple</b>, 10 sliders (top speed, acceleration, grip, drift, suspension…). Each one drives several real physics fields behind the scenes. Perfect for fixing a broken addon car without knowing what <code>fTractionCurveMax</code> means.",
            "<b>Advanced</b>: every single CHandlingData field, grouped by category, with sliders and drag-to-scrub number boxes. Search by name, and reset any field back to stock with the arrow that appears next to it.",
            "Values are always shown exactly as they appear in <code>handling.meta</code>: degrees, km/h, bias 0-1."
        ]
    },
    {
        "icon": "drift",
        "title": "Flags & Presets",
        "body": "Behaviour switches and ready-made tunes.",
        "list": [
            "<b>Flags</b>, model / handling / damage / advanced bits as named checkboxes with explanations. Advanced flags (diffs, gearbox…) only take effect when written to the file.",
            "<b>Presets</b>: 12 complete tunes: Street, Sport RWD, Supercar, Hypercar AWD, Drift, Rally, Drag, Track GT3, Muscle, Truck, Bike, F1. Apply one, then fine-tune.",
            "Presets never touch flags: so they can't break a vehicle's wheels or drivetrain."
        ]
    },
    {
        "icon": "rocket",
        "title": "Telemetry & Timing",
        "body": "Measure instead of guessing.",
        "list": [
            "<b>Driving HUD</b>, turn it on in Telemetry and a compact overlay (speed, gear, RPM, G, per-wheel slip) stays on screen while you drive, even with this menu closed.",
            "<b>Road test</b>: in Timing, press Start: the menu closes and a live timer follows you. Stop fully to arm, then launch for 0-100 / 0-200 / ¼ mile; brake from over 100 to a full stop for braking distance.",
            "Results come back here automatically and stay saved between sessions."
        ]
    },
    {
        "icon": "weight",
        "title": "Saving your work",
        "body": "Three levels, from temporary to permanent.",
        "list": [
            "<b>Profiles</b>, save named tunes and reload them on any car. Share codes (<code>APEXH1:…</code>) let you paste a tune to a friend on Discord.",
            "<b>Save on server</b>: the tune becomes the default for that model, for everyone, and survives restarts.",
            "<b>Write to vehicle file</b>: rewrites the real <code>handling.meta</code> inside the car's own resource (a backup is kept). Restart the resource and the game itself loads your tune. Zip the folder and anyone you send it to gets the car with your handling.",
            "The <b>XML</b> tab shows exactly what will be written, and can export a .meta file."
        ]
    }
];

const HELP_STEPS = () => {
    const from = (S.help && S.help.length) ? S.help : HELP_EN;
    // icons live in the JS icon set, not in translations
    return from.map((s, i) => Object.assign({}, s, { icon: (HELP_EN[i] || {}).icon || 'speed' }));
};


let helpIdx = 0;

function renderHelp() {
    const steps = HELP_STEPS();
    const s = steps[helpIdx];
    const body = $('#help-body');
    body.innerHTML = `
        <div class="help-step">
            <h3><i>${icon(s.icon)}</i>${s.title}</h3>
            <p>${s.body}</p>
            <ul>${(s.list || []).map(li => `<li><span>${li}</span></li>`).join('')}</ul>
        </div>`;
    $('#help-step').innerHTML = `<span class="help-dots">${
        steps.map((_, i) => `<span class="help-dot${i === helpIdx ? ' on' : ''}"></span>`).join('')
    }</span>`;
    $('#help-prev').disabled = helpIdx === 0;
    $('#help-next').textContent = helpIdx === steps.length - 1 ? T('done') : T('next');
}

function openModal(id) { $(id).hidden = false; }
function closeModal(id) { $(id).hidden = true; }

/* ─── Boot / lifecycle ──────────────────────────────────────── */

function onOpen(boot) {
    S.open = true;
    S.boot = boot;
    S.access = boot.access;
    S.units = localStorage.getItem('apexh_units') || boot.units || 'kmh';
    // opening the studio means we ARE in a vehicle
    S.inVehicle = true;
    // restore the persistent driving HUD preference
    if (!S.teleHud && localStorage.getItem('apexh_telehud') === '1') {
        S.teleHud = true;
        nui('telemetryHud', { on: true });
    }
    applyOverlays();
    // any locale code works: the strings arrive resolved from Lua, and
    // LOCALE only picks which variant of the catalog labels to show
    LOCALE = boot.locale || 'en';
    S.i18n = boot.i18n || null;
    S.help = boot.help || null;
    S.values = boot.handling || {};
    S.stock = boot.stock || {};
    S.advFlags = null;
    S.advFlagsAvailable = false;
    S.aiHandling = null;          // re-read from this car's own meta file
    S.fieldByName = {};
    (boot.fields || []).forEach(f => { S.fieldByName[f.name] = f; });
    // Opening the studio closes the book on whatever you just drove, so
    // the Performance tab answers "how did that lap go?" straight away.
    commitDrive();
    resetDrive(boot.vehicle.name);

    // reset per-vehicle UI state so nothing leaks from the last car:
    // the sync chip and the Save-on-server toggle must start clean and
    // are then updated by the async overrideState / syncNow messages.
    S.dirtySync = false;
    $('#sync-state').className = 'chip sync-ok';
    setOverrideActive(false);

    applyI18n();
    $('#units-label').textContent = speedU();
    $('#veh-label').textContent = boot.vehicle.label || boot.vehicle.name;
    $('#veh-model').textContent = boot.vehicle.name;
    $('#veh-plate').textContent = boot.vehicle.plate || '-';

    applyAccessGates();
    renderSimple();
    renderAdvanced();
    renderFlags();
    renderPresets();
    renderProfiles();
    refreshXml();
    loadTimingSaved();
    renderTimingSaved();
    updateHudButtons();
    markSwatches();
    switchTab('simple');

    // first ever open: show the tutorial once, unprompted
    if (!localStorage.getItem('apexh_seen_help')) {
        localStorage.setItem('apexh_seen_help', '1');
        helpIdx = 0;
        renderHelp();
        openModal('#modal-help');
    }

    $('#meta-status').className = 'meta-status';
    $('#ms-title').textContent = T('meta_searching');
    $('#ms-path').textContent = '';
    S.hasFileBackup = false;
    $('#btn-xml-restore').hidden = true;
    // the previous vehicle's file must not leak into this session, but the
    // button stays PRESSABLE: while the search is running (or if it comes
    // back empty) clicking it rescans and reports, instead of going dead
    S.metaInfo = null;
    S.metaFound = false;
    updateWriteButton();

    $('#app').hidden = false;
    document.body.style.pointerEvents = 'auto';
}

function onClose() {
    S.open = false;
    S.teleOn = false;
    S.timingOn = false;
    $('#app').hidden = true;
    document.body.style.pointerEvents = 'none';
    // the driving HUD (and any running road test) stays on screen
}

function updateHudButtons() {
    const b = $('#btn-tele-hud');
    b.textContent = T(S.teleHud ? 'hud_hide' : 'hud_show');
    b.classList.toggle('on', S.teleHud);

    // the road-test button is a toggle too: while a test is live it reads
    // as the way to stop it and hide the overlay
    const t = $('#btn-timing-start');
    if (t) {
        t.textContent = T(S.timingHud ? 'timing_stop' : 'timing_start');
        t.classList.toggle('on', S.timingHud);
    }
}

// 'idle' | 'armed' | 'running': drives the dot, the label and the hint
function setTimingState(state) {
    const dot = $('.th-dot'), lbl = $('#th-state'), hint = $('#th-hint');
    if (!lbl) return;
    if (dot) dot.className = 'th-dot ' + state;
    lbl.className = 'th-state ' + state;
    lbl.textContent = state === 'running' ? T('running')
        : state === 'armed' ? T('armed') : T('idle');
    // the hint only matters while we are waiting for the car to stop
    if (hint) hint.hidden = (state !== 'idle');
}

function setOverrideActive(active) {
    S.overrideActive = active;
    const b = $('#btn-override');
    b.classList.toggle('active', active);
    b.querySelector('span').textContent = active ? T('saved_server') : T('save_server');
}

// Overlays are vehicle-bound: on foot everything hides, and it all
// comes back (respecting each toggle) once you're driving again.
// Telemetry and timing share ONE panel, so the outer container shows
// whenever either section is on.
function applyOverlays() {
    const tele = S.teleHud && S.inVehicle;
    const timing = S.timingHud && S.inVehicle;
    $('#hud-tele').hidden = !tele;
    $('#hud-timing').hidden = !timing;
    $('#apex-hud').hidden = !(tele || timing);
}

/* ─── HUD placement ─────────────────────────────────────────── */

const HUD_POSITIONS = ['tl', 'tr', 'bl', 'br'];

function applyHudPos() {
    const hud = $('#apex-hud');
    HUD_POSITIONS.forEach(p => hud.classList.toggle('pos-' + p, p === S.hudPos));
    $$('.hud-pos').forEach(b => b.classList.toggle('active', b.dataset.pos === S.hudPos));
}

function setHudPos(pos) {
    if (!HUD_POSITIONS.includes(pos)) return;
    S.hudPos = pos;
    try { localStorage.setItem('apexh_hudpos', pos); } catch (e) { /* noop */ }
    applyHudPos();
}

function loadHudPos() {
    let saved = null;
    try { saved = localStorage.getItem('apexh_hudpos'); } catch (e) { /* noop */ }
    S.hudPos = HUD_POSITIONS.includes(saved) ? saved : 'tr';
    applyHudPos();
}

async function requestClose() {
    onClose();
    await nui('uiClose');
}

/* ─── Message router ────────────────────────────────────────── */

window.addEventListener('message', (e) => {
    const { action, payload } = e.data || {};
    switch (action) {
        case 'open': onOpen(payload); break;
        case 'close': onClose(); break;
        case 'notify': toast(payload.message, payload.type || 'info'); break;
        case 'telemetry': onTelemetry(payload); break;
        case 'metaInfo': onMetaInfo(payload); break;
        case 'profiles': S.profiles = payload.list || []; renderProfiles(); break;
        case 'overrideState': setOverrideActive(!!payload.active); break;
        case 'resetSource':
            // a file backup exists → the Restore-original button becomes
            // available, and Reset now recovers the true factory values
            S.hasFileBackup = !!payload.file;
            $('#btn-xml-restore').hidden = !(payload.file && S.access === 'full');
            // The .apexbak IS the factory baseline once it exists, so the
            // per-field "changed" marks and stock arrows must compare
            // against it: otherwise every field reads as modified after a
            // reset, and each arrow re-applies the baked (bad) values.
            if (payload.stock) {
                // LAYER, don't replace: the .apexbak parse only contains the
                // tags that file actually has, while the runtime snapshot
                // covers the whole catalog. Replacing it outright left every
                // absent field with no baseline: showing as "changed"
                // forever and with a dead reset arrow.
                const fileStock = Object.assign({}, payload.stock);
                delete fileStock.__advancedFlags;     // not a catalog field
                S.stock = Object.assign({}, S.stock, fileStock);
                renderAdvancedValues();
                refreshSimplePositions();
            }
            break;
        case 'timingLive': onTimingLive(payload); break;
        case 'timingResult': onTimingResult(payload); break;
        case 'timingArmed':
            setTimingState('armed');
            break;
        case 'timingHud':
            S.timingHud = !!payload.visible;
            applyOverlays();
            updateHudButtons();
            break;
        case 'overlays':
            S.inVehicle = !!payload.visible;
            applyOverlays();
            break;
    }
});

/* ─── Static bindings ───────────────────────────────────────── */

document.addEventListener('DOMContentLoaded', () => {
    document.body.style.pointerEvents = 'none';

    // theme is restored before anything renders, so there is no flash
    loadTheme();
    loadHudPos();
    buildSettings();

    $$('.mode-tab').forEach(btn => btn.addEventListener('click', () => switchTab(btn.dataset.tab)));

    $('#btn-close').addEventListener('click', requestClose);
    document.addEventListener('keydown', (e) => {
        if (e.key !== 'Escape' || !S.open) return;
        // Esc closes the topmost modal first, then the studio
        if (!$('#modal-help').hidden) { closeModal('#modal-help'); return; }
        if (!$('#modal-settings').hidden) { closeModal('#modal-settings'); return; }
        requestClose();
    });

    // ── settings modal ──
    $('#btn-settings').addEventListener('click', () => {
        markSwatches();
        openModal('#modal-settings');
    });

    // ── tutorial modal ──
    $('#btn-help').addEventListener('click', () => {
        helpIdx = 0;
        renderHelp();
        openModal('#modal-help');
    });
    $('#help-prev').addEventListener('click', () => {
        if (helpIdx > 0) { helpIdx--; renderHelp(); }
    });
    $('#help-next').addEventListener('click', () => {
        if (helpIdx < HELP_STEPS().length - 1) { helpIdx++; renderHelp(); }
        else closeModal('#modal-help');
    });

    // generic modal close (X, Done, click on the backdrop)
    $$('.modal').forEach(m => {
        m.addEventListener('click', (e) => {
            if (e.target === m || e.target.closest('[data-close]')) m.hidden = true;
        });
    });

    $('#btn-units').addEventListener('click', () => {
        S.units = S.units === 'kmh' ? 'mph' : 'kmh';
        localStorage.setItem('apexh_units', S.units);
        $('#units-label').textContent = speedU();
        renderAdvancedValues();
    });

    $('#btn-reset').addEventListener('click', async () => {
        const r = await nui('resetStock');
        if (r && r.ok) {
            // a missing snapshot (vehicle gone mid-await) must not blank the UI
            if (r.handling) S.values = r.handling;
            renderAdvancedValues(); refreshSimplePositions(); renderFlags(); refreshXml();
            $$('#simple-list .simple-row').forEach(x => x.classList.remove('changed'));
        }
    });

    // Save-on-server is a toggle: save when off, clear when already
    // active (removes the separate ✕ button entirely).
    $('#btn-override').addEventListener('click', async () => {
        if (S.overrideActive) {
            const r = await nui('overrideClear');
            if (r && r.ok) setOverrideActive(false);
        } else {
            const r = await nui('overrideSave');
            if (r && r.ok) setOverrideActive(true);
        }
    });

    // ── persistent driving HUD toggle ──
    $('#btn-tele-hud').addEventListener('click', async () => {
        S.teleHud = !S.teleHud;
        localStorage.setItem('apexh_telehud', S.teleHud ? '1' : '0');
        // turning the HUD off ends the drive being recorded
        if (!S.teleHud && commitDrive() && S.teleOn) renderPerformance();
        updateHudButtons();
        applyOverlays();
        await nui('telemetryHud', { on: S.teleHud });
    });

    // ── road test toggle: arm the live HUD, or turn it off again ──
    $('#btn-timing-start').addEventListener('click', async () => {
        if (S.timingHud) {
            S.timingHud = false;
            applyOverlays();
            updateHudButtons();
            await nui('timingHud', { on: false });
            return;
        }
        toast(T('timing_started'), 'info');
        setTimingState('armed');
        $('#th-results').innerHTML = '';
        S.timingHud = true;
        updateHudButtons();
        await nui('timingRoadTest');
    });

    bindAdvSearch();
    bindFlagTabs();
    bindProfiles();
    bindXml();
});
