/* ============================================================
   Apex Gangs — Command Center UI
   ─────────────────────────────────────────────────────────────
   • Collapsible vertical rail navigation (apex_bossmenu shell)
   • Live leaflet map on Overview with member blips
   • Same #1F5EFF accent + dark surface stack as bossmenu
   • Transport: post()/call() proxy → Lua RegisterNUICallback('call')
   • All DOM access guarded with safe selectors (no null .classList)
   ============================================================ */

// ── Safe selectors (return null silently instead of crashing) ──
const $  = (sel, root = document) => root && root.querySelector ? root.querySelector(sel) : null;
const $$ = (sel, root = document) => Array.from((root || document).querySelectorAll(sel));
function on(el, ev, fn) { if (el) el.addEventListener(ev, fn); }

const RESOURCE_NAME = (typeof GetParentResourceName === 'function')
    ? GetParentResourceName()
    : 'apex_gangs';

function post(name, payload) {
    return fetch(`https://${RESOURCE_NAME}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload || {}),
    }).then(r => r.json().catch(() => ({}))).catch(() => ({}));
}
// call(name) → { ok, data, error }. ALWAYS read r.data on success.
function call(name, payload) {
    return post('call', { name, payload });
}

const state = {
    open      : false,
    you       : null,
    gang      : null,
    config    : null,
    theme     : null,
    adminMode : false,
    gangs     : [],            // admin: every gang
    activeTab : 'overview',
    members   : [],
    players   : [],
    logs      : [],
    turf      : [],
    vault     : null,
    garage    : { vehicles: [], limit: 0 },
    rivals    : null,
    tasks     : [],
    upgrades  : null,
    medic     : null,
    map       : null,
    mapBuilt  : false,
    playerMarkers: [],
    turfMarkers  : [],
    // Airdrop: navbar countdown + live-map candidate-zones layer state.
    airdrop   : { next: null, enabled: false, zones: [], layer: null, shown: false, canEdit: false },
    timers    : [],
    logsCategory : '',
    adminGang : null,          // admin: gang currently being managed (passed to callbacks)
    raidTimer : null,
    // Creator (node-graph editor) shared data — read by both the Overview map
    // and the Editor. Set on creator_open, refreshed after any save/delete.
    creator   : { zones: [], turf: [], owners: [], here: { x: 0, y: 0, z: 0 } },
};

/* ============================================================
   HELPERS
   ============================================================ */
function escapeHTML(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
        '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
    })[c]);
}
function escapeAttr(s) { return String(s == null ? '' : s).replace(/'/g, '&#39;').replace(/"/g, '&quot;'); }
function round2(n) { return Math.round((Number(n) || 0) * 100) / 100; }
function fmtMoney(n) {
    n = Number(n) || 0;
    const sym = state.config?.currency?.symbol ?? '$';
    const sign = n < 0 ? '-' : '';
    const a = Math.abs(Math.floor(n)).toLocaleString('en-US');
    return state.config?.currency?.position === 'after'
        ? `${sign}${a} ${sym}` : `${sign}${sym}${a}`;
}
function t(key) {
    const tbl = state.config?.t || {};
    return tbl[key] || key;
}
function initials(name) {
    return String(name || '?').trim().split(/\s+/).map(p => p[0]).filter(Boolean).slice(0, 2).join('').toUpperCase() || '?';
}
// Try to paint a real character mugshot onto an avatar element. Falls back to
// the existing initials silently when the ped isn't streamed (ok:false).
// Idempotent + cached client-side, so re-rendering re-applies cheaply.
function applyMugshot(elOrSelector, serverId) {
    if (serverId == null || serverId === '') return;
    const el = typeof elOrSelector === 'string' ? $(elOrSelector) : elOrSelector;
    if (!el) return;
    post('mugshot', { id: Number(serverId) }).then(r => {
        if (r && r.ok && r.url) {
            el.classList.add('has-mug');
            el.style.backgroundImage = `url(${r.url})`;
        }
    });
}
function fmtDur(secs) {
    secs = Math.max(0, Math.floor(secs));
    if (secs <= 0) return 'now';
    const h = Math.floor(secs / 3600), m = Math.floor((secs % 3600) / 60), s = secs % 60;
    if (h > 0) return `${h}h ${m}m`;
    if (m > 0) return `${m}m ${s}s`;
    return `${s}s`;
}
function clock(secs) {
    secs = Math.max(0, Math.floor(secs));
    const m = Math.floor(secs / 60), s = secs % 60;
    const pad = n => n < 10 ? '0' + n : n;
    return `${pad(m)}:${pad(s)}`;
}
function ago(ts) {
    if (!ts) return 'never';
    const s = Math.max(0, Math.floor(Date.now() / 1000) - Number(ts));
    if (s < 60) return 'just now';
    if (s < 3600) return Math.floor(s / 60) + 'm ago';
    if (s < 86400) return Math.floor(s / 3600) + 'h ago';
    return Math.floor(s / 86400) + 'd ago';
}
function setText(sel, value) {
    const el = $(sel);
    if (el) el.textContent = (value == null || value === '') ? '' : String(value);
}
// Does the viewer hold a permission? '*' / admin / leader = all.
function hasPerm(key) {
    if (state.you?.isAdmin) return true;
    if (state.you?.isLeader) return true;
    const perms = state.you?.perms;
    if (!Array.isArray(perms)) return false;
    return perms.includes('*') || perms.includes(key);
}
// Resolve the gang argument we pass to server callbacks (admin can target any).
function gangArg() {
    if (state.adminMode && state.adminGang) return { gang: state.adminGang };
    return {};
}

/* ============================================================
   TOAST
   ============================================================ */
function localToast(msg, kind = 'info', title = '', duration = 4500) {
    const c = $('#notify-container'); if (!c) return;
    const card = document.createElement('div');
    card.className = `notify-card ${kind}`;
    const icon = ({info:'circle-info',success:'circle-check',warning:'triangle-exclamation',error:'circle-xmark'})[kind] || 'circle-info';
    card.innerHTML = `
        <div class="notify-header">
            <i class="notify-icon fa-solid fa-${icon}"></i>
            <div>
                ${title ? `<div class="notify-kicker">${escapeHTML(title)}</div>` : ''}
                <div class="notify-title">${escapeHTML(msg)}</div>
            </div>
        </div>`;
    c.appendChild(card);
    setTimeout(() => { card.style.opacity = '0'; setTimeout(() => card.remove(), 250); }, Number(duration) || 4500);
}
function toast(msg, kind = 'info', title = '', duration = 4500) {
    if (!msg) return;
    post('notify', { msg, kind, title, duration }).then(r => {
        if (!r?.handled) localToast(msg, kind, title, duration);
    });
}
// Friendly error strings for common server error codes.
const ERR = {
    no_permission: 'You lack permission for that.', no_gang: 'You are not in a gang.',
    not_authorized: 'Not authorized.', rank_too_high: "That rank is too high for you.",
    already_in_gang: 'That player is already in a gang.', gang_full: 'The gang is full.',
    insufficient_treasury: 'Not enough money in the safe.', insufficient_cash: 'You do not have that much cash.',
    too_small: 'Amount is too small.', too_big: 'Amount is too large.', cooldown: 'Still on cooldown.',
    need_scout: 'Scout the target first.', need_attackers: 'Not enough members online to raid.',
    not_in_zone: "You must be inside the rival's territory to scout them.", busy: 'Already in progress.',
    need_rep: 'Your gang needs more reputation to raid.', not_active: 'That contract is no longer active.',
    no_territory: 'That gang holds no territory to raid.',
    bad_task: 'Unknown task.', no_mission: 'No mission in progress.', bad_token: 'Mission expired — start it again.',
    garage_full: 'The garage is full.', maxed: 'Already at max level.', level_locked: 'Gang level too low.',
    escalation: "You can't grant a permission you don't hold.", last_rank: "Can't delete the last rank.",
    leader_rank: "Can't delete the leader rank.", rank_in_use: 'That rank still has members.',
    locked: 'This feature is locked.', disabled: 'This feature is disabled.', exists: 'A gang with that name already exists.',
    bad_name: 'Invalid gang name (3-22 chars).',
    // ── added with the security/logic hardening pass ──
    not_member: 'That player is not in your gang.',
    cannot_kick_leader: "You can't remove the gang leader.",
    too_far: 'You are too far away.', offline: 'That player is offline.',
    no_coords: 'Could not locate that player.',
    too_soon: 'Too soon — finish the job first.', mission_cooldown: 'Mission on cooldown — try again shortly.',
    wrong_time: 'Raids are only allowed at night.', need_defenders: 'That gang has no one to defend — pick an active target.',
    already_out: 'That vehicle is already out of the garage.', not_your_vehicle: 'That vehicle is not yours.',
    need_weapon: 'You need a firearm in hand for that.', gone: 'That is no longer available.', no_zones: 'No airdrop zones are enabled.',
};
function errMsg(code) { return ERR[code] || code || 'Failed'; }

/* ============================================================
   SERVER-WIDE THEME DEFAULT  (Config.theme → DB override)
   ============================================================ */
function serverThemeDefault(key, fallback) {
    const dbv = state.theme && state.theme[key];
    if (dbv && dbv !== '') return dbv;
    const cfgv = state.config && state.config.theme && state.config.theme[key];
    if (cfgv && cfgv !== '') return cfgv;
    return fallback;
}

/* ============================================================
   OPEN / CLOSE
   ============================================================ */
function openShell(data) {
    state.you       = data.you    || {};
    state.gang      = data.gang   || null;
    state.config    = data.config || {};
    state.theme     = data.theme  || {};
    state.adminMode = data.adminMode === true;
    state.gangs     = data.gangs  || [];
    state.adminGang = (state.adminMode && state.you?.gang) ? state.you.gang : null;
    state.open      = true;

    // Personal choice (localStorage) wins; otherwise server-wide default.
    applyTheme(localStorage.getItem('gang-theme-color') || serverThemeDefault('brand', '#1F5EFF'));
    applyBackgroundRamp(localStorage.getItem('gang-theme-bg') || serverThemeDefault('bg', '#131314'));
    applySize(localStorage.getItem('gang-theme-size') || 'm');
    applyRailCollapsed(localStorage.getItem('gang-rail-collapsed') === '1');
    applyOpacity(localStorage.getItem('gang-theme-opacity') || 100);

    applyFeatureGates();
    applyPermGates();
    renderIdentity();
    renderGangHeader();
    primeColorPresets();
    Graffiti.prime();
    syncCurrencySymbols();

    // Admin-only UI
    const adminBtn = $('.rail-btn[data-tab="admin"]');
    if (adminBtn) adminBtn.hidden = !state.adminMode;
    const saveRow = $('#theme-save-row'); if (saveRow) saveRow.hidden = !state.you?.isAdmin;

    const overlay = $('#gang-overlay'); if (overlay) overlay.hidden = false;
    setTab(state.adminMode ? 'admin' : 'overview', true);
    startClock();
    startAutoRefresh();
}
function closeShell() {
    state.open = false;
    const overlay = $('#gang-overlay'); if (overlay) overlay.hidden = true;
    if (state.map) {
        try { state.map.remove(); } catch (_) {}
        state.map = null; state.mapBuilt = false;
        state.playerMarkers = []; state.turfMarkers = [];
    }
    state.timers.forEach(clearInterval); state.timers = [];
    if (state.raidTimer) { clearInterval(state.raidTimer); state.raidTimer = null; }
}

// Hide tabs whose feature is disabled in Config.features.
function applyFeatureGates() {
    const f = state.config?.features || {};
    $$('.rail-btn[data-feature]').forEach(btn => {
        const key = btn.dataset.feature;
        if (key === 'admin') return; // controlled by adminMode
        // Operations groups scout + raid: hide only when both are off.
        if (key === 'operations') {
            btn.hidden = (f.scout === false && f.raid === false);
            return;
        }
        // overview/settings always on; respect the rest if the key exists
        if (Object.prototype.hasOwnProperty.call(f, key) && f[key] === false) {
            btn.hidden = true;
        } else {
            btn.hidden = false;
        }
    });
}

// Hide any [data-perm] control the viewer can't use (admins/leaders see all).
function applyPermGates(root) {
    $$('[data-perm]', root || document).forEach(el => {
        el.hidden = !hasPerm(el.dataset.perm);
    });
}

/* ============================================================
   GANG HEADER + IDENTITY
   ============================================================ */
function renderIdentity() {
    const you = state.you || {};
    setText('#cc-me-name', you.name || 'Member');
    setText('#cc-me-grade', you.rank?.label || (you.gang ? ('Grade ' + (you.grade || 0)) : (state.adminMode ? 'Administrator' : '—')));
    const av = $('#cc-me-avatar'); if (av) { av.textContent = initials(you.name); applyMugshot(av, you.src); }
    setText('#set-name', you.name);
    setText('#set-gang', state.gang?.label || (you.gang || 'No gang'));
    setText('#set-rank', you.rank?.label || ('Grade ' + (you.grade || 0)));
    setText('#set-id', you.identifier);
}

function renderGangHeader() {
    const g = state.gang;
    setText('#gang-label', g ? g.label : (state.adminMode ? 'Administration' : 'Command Center'));
    if (!g) {
        setText('#bid-gang-name', state.adminMode ? 'Admin' : '—');
        setText('#bid-rank', state.you?.isAdmin ? 'Admin' : '—');
        setText('#bid-online', 0); setText('#bid-max', 0); setText('#bid-level', '1');
        setText('#bid-treasury', fmtMoney(0)); $('#bid-rep') && ($('#bid-rep').innerHTML = '<i class="fa-solid fa-fire-flame-curved"></i> 0');
        return;
    }
    setText('#bid-gang-name', g.label);
    const dot = $('#bid-gang-dot'); if (dot) dot.style.background = g.color || 'var(--brand-500)';
    setText('#bid-rank', state.you?.rank?.label || ('Grade ' + (state.you?.grade || 0)));
    setText('#bid-max', g.maxMembers || 0);
    setText('#bid-level', g.level || 1);
    // Society money + reputation in the navbar (live).
    const treasury = (g.treasury != null) ? g.treasury : (state.vault?.balance || 0);
    setText('#bid-treasury', fmtMoney(treasury));
    const repEl = $('#bid-rep'); if (repEl) repEl.innerHTML = `<i class="fa-solid fa-fire-flame-curved"></i> ${(g.rep || 0).toLocaleString()}`;
    renderAirdropPill();

    // Identity card on overview
    const logo = $('#gi-logo'); if (logo) logo.style.background = `linear-gradient(150deg, ${g.color || '#5C7AFF'}, ${g.color || '#0048F0'})`;
    setText('#gi-name', g.label);
    setText('#gi-level', 'Lv ' + (g.level || 1));
    setText('#gi-leader', g.leader || 'No leader');
    setText('#ov-level', g.level || 1);
    setText('#ov-max', g.maxMembers || 0);
    setText('#ov-treasury', fmtMoney(state.vault?.balance ?? treasury));
    setText('#ov-level-meta', `${(g.xp || 0).toLocaleString()} / ${(g.nextXp || 0).toLocaleString()} XP`);
    const pct = g.nextXp > 0 ? Math.max(0, Math.min(100, (g.xp / g.nextXp) * 100)) : 0;
    const fill = $('#gi-xp-fill'); if (fill) fill.style.width = pct + '%';
    setText('#gi-xp-text', `${(g.xp || 0).toLocaleString()} / ${(g.nextXp || 0).toLocaleString()} XP`);
    const legendDot = $('#ov-legend-dot'); if (legendDot) legendDot.style.background = g.color || '#1F5EFF';
}

function syncCurrencySymbols() {
    const sym = state.config?.currency?.symbol ?? '$';
    setText('#dep-symbol', sym); setText('#wd-symbol', sym);
}

/* ============================================================
   TABS — vertical rail
   ============================================================ */
const TAB_LABELS = {
    admin     : { icon: 'user-shield',         eyebrow: 'Admin',       title: 'Gang administration' },
    overview  : { icon: 'gauge-high',          eyebrow: 'Gang · Live', title: 'Command Center' },
    members   : { icon: 'users',               eyebrow: 'Gang',        title: 'Members' },
    ranks     : { icon: 'layer-group',         eyebrow: 'Gang',        title: 'Ranks & permissions' },
    turf      : { icon: 'map-location-dot',    eyebrow: 'Territory',   title: 'Turf' },
    vault     : { icon: 'vault',               eyebrow: 'Finance',     title: 'Vault' },
    garage    : { icon: 'warehouse',           eyebrow: 'Fleet',       title: 'Gang garage' },
    operations: { icon: 'crosshairs',          eyebrow: 'Combat',      title: 'Operations' },
    tasks     : { icon: 'list-check',          eyebrow: 'Progress',    title: 'Tasks & contracts' },
    analytics : { icon: 'chart-line',          eyebrow: 'Intel',       title: 'Street standing' },
    upgrades  : { icon: 'arrow-up-right-dots', eyebrow: 'Progress',    title: 'Upgrades' },
    medic     : { icon: 'kit-medical',         eyebrow: 'Support',     title: 'Gang medic' },
    logs      : { icon: 'clock-rotate-left',   eyebrow: 'Audit',       title: 'Audit log' },
    settings  : { icon: 'sliders',             eyebrow: 'Profile',     title: 'Settings' },
};

function setTab(name, force) {
    if (!force && state.activeTab === name) return;
    if (!TAB_LABELS[name]) name = 'overview';
    state.activeTab = name;

    $$('.rail-btn').forEach(b => b.classList && b.classList.toggle('active', b.dataset.tab === name));
    $$('.pane').forEach(p => p.hidden = p.dataset.pane !== name);

    const meta = TAB_LABELS[name];
    const icEl = $('#gang-tab-icon');
    if (icEl) icEl.className = 'fa-solid fa-' + meta.icon;
    setText('#gang-tab-eyebrow', meta.eyebrow);
    setText('#gang-tab-title',   meta.title);

    // Lazy load each pane from its callback on activate
    if (name === 'admin')      refreshAdmin();
    if (name === 'overview')   { ensureMap(); refreshMembers(); refreshTurfCount(); refreshLogs(); refreshPlayersForMap(); renderMapMarkers(); renderTurfOnMap(); renderAirdropZones(); }
    if (name === 'members')    refreshMembers();
    if (name === 'ranks')      renderRanks();
    if (name === 'turf')       renderTurf();
    if (name === 'vault')      refreshVault();
    if (name === 'garage')     refreshGarageTab();
    if (name === 'operations') refreshOps();
    if (name === 'tasks')      refreshTasks();
    if (name === 'analytics')  refreshAnalytics();
    if (name === 'upgrades')   refreshUpgrades();
    if (name === 'medic')      refreshMedic();
    if (name === 'logs')       refreshLogs();
}

document.addEventListener('click', e => {
    const rail = e.target.closest('.rail-btn');
    if (rail && rail.dataset.tab) { setTab(rail.dataset.tab); return; }
    const jump = e.target.closest('[data-jump-tab]');
    if (jump) { setTab(jump.dataset.jumpTab); return; }
});

on($('#gang-close'),   'click', () => post('close'));
on($('#gang-refresh'), 'click', () => { refreshActive(); toast('Refreshed', 'success'); });

/* ============================================================
   CLOCK
   ============================================================ */
function startClock() {
    const el = $('#cc-clock'); if (!el) return;
    function tick() {
        const d = new Date();
        const pad = n => n < 10 ? '0' + n : n;
        el.textContent = `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
    }
    tick();
    state.timers.push(setInterval(tick, 1000));
}

/* ============================================================
   REFRESH ORCHESTRATION
   ============================================================ */
function refreshActive() {
    renderGangHeader();
    setTab(state.activeTab, true);
}
function startAutoRefresh() {
    // members + map blips
    state.timers.push(setInterval(() => {
        if (!state.open) return;
        if (state.activeTab === 'overview' || state.activeTab === 'members') refreshMembers();
    }, 4000));
    // airdrop navbar countdown — local 1s tick, server resync every 15s
    state.timers.push(setInterval(() => {
        if (!state.open || !airdropOn()) return;
        if (state.airdrop.enabled && state.airdrop.next != null && state.airdrop.next > 0) state.airdrop.next--;
        renderAirdropPill();
    }, 1000));
    state.timers.push(setInterval(() => { if (state.open) pollAirdrop(); }, 15000));
    pollAirdrop();
}

/* ============================================================
   MEMBERS
   ============================================================ */
function refreshMembers() {
    call('members:list', gangArg()).then(r => {
        if (!r.ok) { return; }
        state.members = r.data || [];
        const total = state.members.length;
        const online = state.members.filter(m => m.online).length;
        setText('#rail-members', total);
        setText('#bid-online', online);
        setText('#ov-online', online);
        setText('#ov-members', total);
        setText('#gi-members', `${online}/${total}`);
        renderOnlineFeed();
        if (state.activeTab === 'members') renderMembers();
        renderMapMarkers();
    });
}

function renderOnlineFeed() {
    const root = $('#online-feed-list'); if (!root) return;
    const online = state.members.filter(m => m.online);
    setText('#online-feed-count', online.length);
    if (!online.length) {
        root.innerHTML = `<div class="tx-empty" style="margin:6px;border:none;padding:12px">No members online</div>`;
        return;
    }
    root.innerHTML = online.map(m => `
        <div class="feed-row" data-src="${m.src != null ? m.src : ''}">
            <div class="feed-avatar with-pulse"${m.src != null ? ` data-mug="${m.src}"` : ''}>${escapeHTML(initials(m.name))}</div>
            <div class="feed-info">
                <div class="feed-name">${escapeHTML(m.name)}</div>
                <div class="feed-meta">${escapeHTML(m.gradeLabel || ('Grade ' + m.grade))}</div>
            </div>
            <span class="feed-dot" title="Online"></span>
        </div>
    `).join('');
    $$('[data-mug]', root).forEach(el => applyMugshot(el, el.dataset.mug));
}

function renderMembers() {
    const root = $('#mem-list'); if (!root) return;
    const filt  = ($('#mem-filter')?.value || 'all');
    const query = ($('#mem-search')?.value || '').toLowerCase().trim();
    const rows = state.members.filter(m => {
        if (filt === 'online'  && !m.online) return false;
        if (filt === 'offline' &&  m.online) return false;
        return !query || (m.name || '').toLowerCase().includes(query);
    });
    setText('#mem-stats', `${rows.length} of ${state.members.length} members`);
    if (!rows.length) {
        root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-users-slash"></i></span><span>No members match.</span></div>`;
        return;
    }
    root.innerHTML = rows.map(m => {
        const acts = [];
        if (hasPerm('promote_members')) acts.push(`<button class="btn btn-ghost btn-sm" data-mact="promote"><i class="fa-solid fa-arrow-up"></i> Promote</button>`);
        if (hasPerm('demote_members'))  acts.push(`<button class="btn btn-ghost btn-sm" data-mact="demote"><i class="fa-solid fa-arrow-down"></i> Demote</button>`);
        if (state.you?.isLeader || state.you?.isAdmin) acts.push(`<button class="btn btn-ghost btn-sm" data-mact="transfer"><i class="fa-solid fa-crown"></i> Make leader</button>`);
        if (hasPerm('kick_members'))    acts.push(`<button class="btn btn-ghost btn-sm" data-mact="kick"><i class="fa-solid fa-user-xmark"></i> Kick</button>`);
        return `
        <div class="emp-card" data-id="${escapeAttr(m.identifier)}">
            <div class="emp-avatar ${m.online ? 'online' : ''}"${m.src != null ? ` data-mug="${m.src}"` : ''}>${escapeHTML(initials(m.name))}</div>
            <div class="emp-main">
                <div class="emp-name-row">
                    <span class="emp-name">${escapeHTML(m.name || 'Unknown')}</span>
                    ${m.isLeader ? '<span class="emp-tag leader"><i class="fa-solid fa-crown"></i></span>' : ''}
                    <span class="emp-tag ${m.online ? 'online' : ''}">${m.online ? 'Online' : 'Offline'}</span>
                </div>
                <div class="emp-meta">
                    <span>G<strong>${m.grade}</strong></span>
                    <span>Seen <strong>${m.online ? 'now' : ago(m.last_seen)}</strong></span>
                </div>
            </div>
            <span class="emp-rankpill">${escapeHTML(m.gradeLabel || ('Grade ' + m.grade))}</span>
            <div class="emp-actions">${acts.join('')}</div>
        </div>`;
    }).join('');
    $$('[data-mug]', root).forEach(el => applyMugshot(el, el.dataset.mug));
}

document.addEventListener('click', e => {
    const card = e.target.closest('.emp-card[data-id]'); if (!card) return;
    const act = e.target.closest('[data-mact]'); if (!act) return;
    const id = card.dataset.id;
    const mem = state.members.find(x => x.identifier === id);
    const action = act.dataset.mact;
    const after = (r) => {
        if (!r.ok) return toast(errMsg(r.error), 'error');
        toast('Saved', 'success'); refreshMembers();
    };
    const base = gangArg();
    if (action === 'promote') call('members:promote', { ...base, identifier: id }).then(after);
    if (action === 'demote')  call('members:demote',  { ...base, identifier: id }).then(after);
    if (action === 'kick')    confirmDlg(`Kick ${mem?.name || 'this member'} from the gang?`, () => call('members:kick', { ...base, identifier: id }).then(after));
    if (action === 'transfer') confirmDlg(`Transfer leadership to ${mem?.name || 'this member'}? You will be demoted.`, () => call('members:transfer', { ...base, identifier: id }).then(after));
});

on($('#mem-filter'), 'change', renderMembers);
on($('#mem-search'), 'input',  renderMembers);
on($('#mem-invite-btn'), 'click', () => invitePrompt());

function invitePrompt() {
    const grades = (state.gang?.grades || []).slice().sort((a, b) => a.grade - b.grade);
    inputDlg({
        title: 'Invite member',
        fields: [
            { type: 'number', label: 'Player server ID', key: 'target' },
            { type: 'select', label: 'Starting rank', key: 'grade',
              options: grades.map(g => ({ value: g.grade, label: `${g.label} (G${g.grade})` })) },
        ],
        onSubmit(v) {
            const target = Number(v.target); if (!target) return toast('Invalid server ID', 'error');
            call('members:invite', { ...gangArg(), target, grade: Number(v.grade) || 0 }).then(r => {
                if (!r.ok) return toast(errMsg(r.error), 'error');
                toast('Invitation sent.', 'success'); refreshMembers();
            });
        }
    });
}

/* ============================================================
   RANKS — editable rows + permission grid
   ============================================================ */
function renderRanks() {
    call('ranks:list', gangArg()).then(r => {
        const root = $('#ranks-list'); if (!root) return;
        if (!r.ok) { root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-lock"></i></span><span>${escapeHTML(errMsg(r.error))}</span></div>`; return; }
        const data = r.data || {};
        const cat = data.catalogue || state.config?.permissions?.all || {};
        const grades = (data.grades || []).slice().sort((a, b) => a.grade - b.grade);
        if (!grades.length) { root.innerHTML = `<div class="pane-empty"><span>No ranks defined.</span></div>`; return; }
        const catKeys = Object.keys(cat);
        root.innerHTML = grades.map(g => {
            const has = Array.isArray(g.permissions) ? g.permissions : [];
            const allOn = has.includes('*');
            const perms = catKeys.map(k => {
                const checked = allOn || has.includes(k);
                return `<label class="perm-chk ${checked ? 'checked' : ''}">
                    <input type="checkbox" data-permkey="${escapeAttr(k)}" ${checked ? 'checked' : ''}>
                    <span>${escapeHTML(cat[k])}</span>
                </label>`;
            }).join('');
            return `
            <div class="rank-card" data-grade="${g.grade}">
                <div class="rank-head">
                    <div class="rank-pill">G${g.grade}</div>
                    <div class="rank-field">
                        <span class="rank-field-label">Rank label</span>
                        <input class="rank-input rank-label" value="${escapeAttr(g.label || '')}" placeholder="Rank label">
                    </div>
                    <div class="rank-field">
                        <span class="rank-field-label">Salary</span>
                        <input type="number" class="rank-input mono rank-salary" value="${Number(g.salary) || 0}" min="0">
                    </div>
                    <div class="rank-leader-toggle">
                        <span class="rank-field-label">Leader</span>
                        <label class="cr-switch">
                            <input type="checkbox" class="rank-leader" ${g.isLeader ? 'checked' : ''}>
                            <span class="cr-switch-track"><span class="cr-switch-thumb"></span></span>
                        </label>
                    </div>
                    <div class="rank-actions">
                        <button class="btn btn-ghost btn-sm rank-del" title="Delete rank"><i class="fa-solid fa-trash-can"></i></button>
                        <button class="btn btn-primary btn-sm rank-save"><i class="fa-solid fa-check"></i> Save</button>
                    </div>
                </div>
                <div class="rank-perms ${allOn ? 'all-on' : ''}">
                    <div class="rank-perms-head">
                        <span>Permissions</span>
                        <label class="rank-perms-all">
                            <input type="checkbox" class="rank-allperm" ${allOn ? 'checked' : ''}>
                            All permissions ( * )
                        </label>
                    </div>
                    <div class="perm-grid">${perms}</div>
                </div>
            </div>`;
        }).join('');
    });
}

// toggle visual checked class + "all" master
document.addEventListener('change', e => {
    const allChk = e.target.closest('.rank-allperm');
    if (allChk) {
        const wrap = allChk.closest('.rank-perms');
        if (wrap) wrap.classList.toggle('all-on', allChk.checked);
        return;
    }
    const pchk = e.target.closest('.perm-chk input');
    if (pchk) { const lbl = pchk.closest('.perm-chk'); if (lbl) lbl.classList.toggle('checked', pchk.checked); }
});

document.addEventListener('click', e => {
    const save = e.target.closest('.rank-save');
    if (save) {
        const card = save.closest('.rank-card'); if (!card) return;
        const allOn = card.querySelector('.rank-allperm')?.checked;
        let permissions;
        if (allOn) permissions = ['*'];
        else permissions = $$('.perm-chk input:checked', card).map(i => i.dataset.permkey).filter(Boolean);
        const payload = {
            ...gangArg(),
            grade:    Number(card.dataset.grade),
            label:    card.querySelector('.rank-label')?.value || '',
            isLeader: !!card.querySelector('.rank-leader')?.checked,
            salary:   Number(card.querySelector('.rank-salary')?.value) || 0,
            permissions,
        };
        call('ranks:save', payload).then(r => {
            if (!r.ok) return toast(errMsg(r.error), 'error');
            toast('Rank saved.', 'success'); renderRanks();
        });
        return;
    }
    const del = e.target.closest('.rank-del');
    if (del) {
        const card = del.closest('.rank-card'); if (!card) return;
        const grade = Number(card.dataset.grade);
        confirmDlg('Delete this rank?', () => {
            call('ranks:delete', { ...gangArg(), grade }).then(r => {
                if (!r.ok) return toast(errMsg(r.error), 'error');
                toast('Rank deleted.', 'success'); renderRanks();
            });
        });
        return;
    }
});

on($('#rank-add-btn'), 'click', () => {
    call('ranks:add', gangArg()).then(r => {
        if (!r.ok) return toast(errMsg(r.error), 'error');
        toast('Rank added.', 'success'); renderRanks();
    });
});

/* ============================================================
   TURF — territory readout
   ============================================================ */
function refreshTurfCount() {
    call('turf:overview').then(r => {
        if (!r.ok) return;
        state.turf = r.data || [];
        const mine = state.turf.filter(z => z.mine).length;
        setText('#ov-turf', mine);
        renderMapMarkers();
    });
}
function renderTurf() {
    call('turf:overview').then(r => {
        const root = $('#turf-list'); if (!root) return;
        if (!r.ok) { root.innerHTML = `<div class="pane-empty"><span>${escapeHTML(errMsg(r.error))}</span></div>`; return; }
        state.turf = r.data || [];
        const mine = state.turf.filter(z => z.mine).length;
        setText('#ov-turf', mine);
        setText('#turf-stats', `${state.turf.length} zones · ${mine} owned by your gang`);
        if (!state.turf.length) {
            root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-map-location-dot"></i></span><span>No territory defined yet.</span></div>`;
            return;
        }
        root.innerHTML = state.turf.map(z => {
            const ownerColor = z.mine ? (state.gang?.color || '#1F5EFF')
                : (z.owner ? '#E5564B' : '#7C7C82');
            const st = z.state || {};
            const contested = st.contested;
            const prog = Math.max(0, Math.min(100, Math.round(Number(st.progress) || 0)));
            let badge, badgeCls;
            if (contested) { badge = 'Contested'; badgeCls = 'contested'; }
            else if (prog > 0 && prog < 100) { badge = 'Capturing ' + prog + '%'; badgeCls = 'capturing'; }
            else if (z.owner) { badge = z.mine ? 'Held' : 'Owned'; badgeCls = 'held'; }
            else { badge = 'Neutral'; badgeCls = ''; }
            return `
            <div class="turf-card ${z.mine ? 'mine' : ''}" style="--turf-color:${ownerColor}">
                <div class="turf-top">
                    <div class="turf-name"><span class="turf-dot"></span>${escapeHTML(z.label || z.id)}</div>
                    ${z.mine ? '<span class="turf-mine-tag">Yours</span>' : ''}
                </div>
                <div class="turf-owner">Owner: <strong>${escapeHTML(z.ownerLabel || 'Neutral')}</strong></div>
                <div class="turf-state">
                    <div class="turf-bar"><span class="turf-bar-fill" style="width:${prog}%"></span></div>
                    <span class="turf-badge ${badgeCls}">${escapeHTML(badge)}</span>
                </div>
            </div>`;
        }).join('');
    });
}

/* ============================================================
   GRAFFITI — LAYERED EDITOR (mini graffiti-maker)
   ────────────────────────────────────────────────────────────
   Driven by the graffitiOpen / graffitiClose messages:
     graffitiOpen { gallery:['name.png',...], allowCustom,
                    fonts:[{font,label}], colors:['#hex',...],
                    images:[{id,label,url,...}] (legacy URL catalogue) }
     graffitiClose {}
   A single stage <canvas> composites a stack of layers (image | text |
   draw). The selected image/text layer can be dragged + corner-resized;
   a draw layer is painted freehand with the pen. SAVE flattens the whole
   composition to a PNG and posts:
     graffiti_choose { mode:'draw', drawing:<png>, width, height, color }
   EXIT / CLEAR(→exit) post graffiti_cancel. The data contract + the
   #graffiti-overlay id are kept intact (open/close API preserved).
   ============================================================ */
const Graffiti = (() => {
    const CANVAS_W = 640, CANVAS_H = 480;
    const FONT_MAP = {
        graffiti1: "'Impact','Arial Black',sans-serif",
        graffiti2: "'Arial Black','Impact',sans-serif",
        graffiti3: "'Bebas Neue','Impact',sans-serif",
        graffiti4: "'Brush Script MT','Comic Sans MS',cursive",
        graffiti5: "'Trebuchet MS','Arial Black',sans-serif",
    };
    const cssFont = (key) => FONT_MAP[key] || "'Impact','Arial Black',sans-serif";

    const S = {
        gallery: [], allowCustom: false, fonts: [], colors: ['#1F5EFF'],
        layers: [],            // bottom→top; each: {id,type,...,x,y,w,h,scale,rot,opacity,color}
        selId: null,           // selected layer id
        seq: 0,
        color: '#1F5EFF',
        // draw tool state
        pen: 'pen',            // 'pen' | 'eraser'
        pattern: 'round',      // round | marker | spray | chalk
        size: 12,
        opacity: 1,
        // history
        undoStack: [], redoStack: [],
        // interaction
        drag: null,            // {mode:'move'|'resize', id, ...}
        painting: null,        // active draw layer id while painting
        ctx: null, init: false,
    };

    const root   = () => $('#graffiti-overlay');
    const canvas = () => $('#gfe-canvas');
    const isOpen = () => { const el = root(); return !!el && !el.hidden; };
    const nextId = () => 'L' + (++S.seq);
    const getLayer = (id) => S.layers.find(l => l.id === id) || null;

    /* ── Image cache (so render() is synchronous after load) ── */
    const imgCache = {};   // src → HTMLImageElement
    function loadImage(src, crossOrigin, onReady) {
        if (imgCache[src] && imgCache[src].complete && imgCache[src].naturalWidth) {
            onReady(imgCache[src]); return;
        }
        const im = new Image();
        if (crossOrigin) im.crossOrigin = 'anonymous';
        im.onload  = () => { imgCache[src] = im; onReady(im); };
        im.onerror = () => { onReady(null); };
        im.src = src;
        imgCache[src] = im;
    }

    /* ── History (bounded ~30) ── */
    function snapshot() {
        // deep-ish clone of layers (strokes arrays cloned shallowly is fine for restore)
        return JSON.stringify(S.layers.map(l => ({
            ...l,
            strokes: l.strokes ? l.strokes.map(s => ({ ...s, pts: s.pts.slice() })) : undefined,
        })));
    }
    function pushHistory() {
        S.undoStack.push(snapshot());
        if (S.undoStack.length > 30) S.undoStack.shift();
        S.redoStack.length = 0;
    }
    function restore(json) {
        S.layers = JSON.parse(json);
        if (!getLayer(S.selId)) S.selId = null;
        renderLayerList(); render();
    }
    function undo() {
        if (!S.undoStack.length) return;
        S.redoStack.push(snapshot());
        restore(S.undoStack.pop());
    }
    function redo() {
        if (!S.redoStack.length) return;
        S.undoStack.push(snapshot());
        restore(S.redoStack.pop());
    }

    /* ── Layer creation ── */
    function addImageLayer(src, crossOrigin, label) {
        loadImage(src, crossOrigin, (im) => {
            if (!im) { toast('That image failed to load.', 'error'); return; }
            const maxW = CANVAS_W * 0.45;
            let w = im.naturalWidth, h = im.naturalHeight;
            if (w > maxW) { const k = maxW / w; w *= k; h *= k; }
            pushHistory();
            const layer = {
                id: nextId(), type: 'image', src, crossOrigin: !!crossOrigin,
                label: label || 'Image',
                x: (CANVAS_W - w) / 2, y: (CANVAS_H - h) / 2, w, h,
                rot: 0, opacity: 1,
            };
            S.layers.push(layer);
            S.selId = layer.id;
            renderLayerList(); render();
        });
    }
    function addTextLayer(text, fontKey, color) {
        pushHistory();
        const layer = {
            id: nextId(), type: 'text', text, font: fontKey, color: color || S.color,
            x: CANVAS_W / 2, y: CANVAS_H / 2, fontSize: 64,
            rot: 0, opacity: 1,
            w: 0, h: 0,   // measured at render
        };
        S.layers.push(layer);
        S.selId = layer.id;
        renderLayerList(); render();
    }
    function ensureDrawLayer() {
        // reuse the selected draw layer, else the topmost draw layer, else create
        let l = getLayer(S.selId);
        if (l && l.type === 'draw') return l;
        for (let i = S.layers.length - 1; i >= 0; i--) {
            if (S.layers[i].type === 'draw') { S.selId = S.layers[i].id; return S.layers[i]; }
        }
        const layer = { id: nextId(), type: 'draw', strokes: [], opacity: 1, x: 0, y: 0, w: CANVAS_W, h: CANVAS_H };
        S.layers.push(layer);
        S.selId = layer.id;
        renderLayerList();
        return layer;
    }
    function deleteLayer(id) {
        const idx = S.layers.findIndex(l => l.id === id);
        if (idx < 0) return;
        pushHistory();
        S.layers.splice(idx, 1);
        if (S.selId === id) S.selId = null;
        renderLayerList(); render();
    }

    /* ── Geometry helpers (for image/text layers) ── */
    function textMetrics(l) {
        const ctx = S.ctx; if (!ctx) return { w: 0, h: l.fontSize || 64 };
        ctx.save();
        ctx.font = `800 ${l.fontSize}px ${cssFont(l.font)}`;
        const m = ctx.measureText(l.text || '');
        ctx.restore();
        return { w: Math.max(8, m.width), h: (l.fontSize || 64) * 1.2 };
    }
    // returns {x,y,w,h} bounding box in canvas space
    function boxOf(l) {
        if (l.type === 'text') {
            const m = textMetrics(l);
            l.w = m.w; l.h = m.h;
            return { x: l.x - m.w / 2, y: l.y - m.h / 2, w: m.w, h: m.h };
        }
        return { x: l.x, y: l.y, w: l.w, h: l.h };
    }

    /* ── Render the whole composition (bottom→top) ── */
    function render() {
        const c = canvas(); const ctx = S.ctx; if (!c || !ctx) return;
        ctx.clearRect(0, 0, c.width, c.height);
        for (const l of S.layers) {
            ctx.save();
            ctx.globalAlpha = (l.opacity == null ? 1 : l.opacity);
            if (l.type === 'image') {
                const im = imgCache[l.src];
                if (im && im.complete && im.naturalWidth) {
                    ctx.drawImage(im, l.x, l.y, l.w, l.h);
                } else {
                    loadImage(l.src, l.crossOrigin, () => render());
                }
            } else if (l.type === 'text') {
                ctx.font = `800 ${l.fontSize}px ${cssFont(l.font)}`;
                ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
                ctx.fillStyle = l.color || '#1F5EFF';
                ctx.lineWidth = Math.max(2, l.fontSize * 0.04);
                ctx.strokeStyle = 'rgba(0,0,0,.55)';
                ctx.strokeText(l.text || '', l.x, l.y);
                ctx.fillText(l.text || '', l.x, l.y);
            } else if (l.type === 'draw') {
                paintStrokes(ctx, l.strokes || []);
            }
            ctx.restore();
        }
        renderHandles();
    }

    function paintStrokes(ctx, strokes) {
        for (const s of strokes) {
            const pts = s.pts || [];
            if (!pts.length) continue;
            ctx.save();
            ctx.globalAlpha = s.opacity == null ? 1 : s.opacity;
            ctx.globalCompositeOperation = s.erase ? 'destination-out' : 'source-over';
            ctx.lineCap = 'round'; ctx.lineJoin = 'round';
            ctx.strokeStyle = s.color; ctx.fillStyle = s.color;
            ctx.lineWidth = s.size;
            if (s.pattern === 'spray') {
                // dotted scatter along the path
                for (const p of pts) sprayDot(ctx, p.x, p.y, s.size, s.color);
            } else {
                if (s.pattern === 'marker') { ctx.lineCap = 'square'; ctx.globalAlpha = (s.opacity == null ? 1 : s.opacity) * 0.85; }
                if (s.pattern === 'chalk')  { ctx.globalAlpha = (s.opacity == null ? 1 : s.opacity) * 0.7; }
                ctx.beginPath();
                ctx.moveTo(pts[0].x, pts[0].y);
                for (let i = 1; i < pts.length; i++) ctx.lineTo(pts[i].x, pts[i].y);
                if (pts.length === 1) { ctx.lineTo(pts[0].x + 0.01, pts[0].y + 0.01); }
                ctx.stroke();
                if (s.pattern === 'chalk') for (const p of pts) chalkSpeck(ctx, p.x, p.y, s.size, s.color);
            }
            ctx.restore();
        }
    }
    function sprayDot(ctx, x, y, size, color) {
        const n = Math.max(6, Math.floor(size * 1.5));
        ctx.fillStyle = color;
        for (let i = 0; i < n; i++) {
            const a = Math.random() * Math.PI * 2;
            const r = Math.random() * size;
            ctx.globalAlpha *= 1;
            ctx.beginPath();
            ctx.arc(x + Math.cos(a) * r, y + Math.sin(a) * r, Math.max(0.5, size * 0.08), 0, Math.PI * 2);
            ctx.fill();
        }
    }
    function chalkSpeck(ctx, x, y, size, color) {
        ctx.fillStyle = color;
        for (let i = 0; i < 3; i++) {
            ctx.beginPath();
            ctx.arc(x + (Math.random() - 0.5) * size, y + (Math.random() - 0.5) * size, size * 0.12, 0, Math.PI * 2);
            ctx.fill();
        }
    }

    /* ── Selection handles (HTML overlay positioned over the canvas) ── */
    function renderHandles() {
        const wrap = $('#gfe-handles'); if (!wrap) return;
        const l = getLayer(S.selId);
        if (!l || l.type === 'draw') { wrap.innerHTML = ''; return; }
        const c = canvas(); const r = c.getBoundingClientRect();
        const sx = r.width / c.width, sy = r.height / c.height;
        const b = boxOf(l);
        const left = b.x * sx, top = b.y * sy, w = b.w * sx, h = b.h * sy;
        wrap.innerHTML =
            `<div class="gfe-sel" style="left:${left}px;top:${top}px;width:${w}px;height:${h}px">
                <span class="gfe-handle nw" data-h="nw"></span>
                <span class="gfe-handle ne" data-h="ne"></span>
                <span class="gfe-handle sw" data-h="sw"></span>
                <span class="gfe-handle se" data-h="se"></span>
            </div>`;
    }

    /* ── Pointer → canvas coords ── */
    function canvasPos(e) {
        const c = canvas(); const r = c.getBoundingClientRect();
        return {
            x: (e.clientX - r.left) * (c.width / r.width),
            y: (e.clientY - r.top) * (c.height / r.height),
        };
    }
    function hitLayer(pt) {
        // topmost image/text layer under the point
        for (let i = S.layers.length - 1; i >= 0; i--) {
            const l = S.layers[i];
            if (l.type === 'draw') continue;
            const b = boxOf(l);
            if (pt.x >= b.x && pt.x <= b.x + b.w && pt.y >= b.y && pt.y <= b.y + b.h) return l;
        }
        return null;
    }

    /* ── Stage pointer handlers (select/move/resize OR paint) ── */
    function onStageDown(e) {
        const c = canvas(); if (!c) return;
        try { c.setPointerCapture(e.pointerId); } catch (x) {}
        const pt = canvasPos(e);

        // resize handle?
        const hEl = e.target.closest && e.target.closest('.gfe-handle');
        const sel = getLayer(S.selId);
        if (hEl && sel && sel.type !== 'draw') {
            pushHistory();
            const b = boxOf(sel);
            S.drag = { mode: 'resize', id: sel.id, handle: hEl.dataset.h, start: pt, box: { ...b },
                       startFont: sel.fontSize };
            return;
        }

        const hit = hitLayer(pt);
        // If pen tool intent: paint when clicking empty space OR on a draw layer area.
        // We treat: clicking a non-draw layer → select/move. Clicking empty → paint.
        if (hit) {
            S.selId = hit.id;
            pushHistory();
            S.drag = { mode: 'move', id: hit.id, start: pt, ox: hit.x, oy: hit.y };
            renderLayerList(); render();
            return;
        }

        // empty space → freehand paint onto a draw layer
        startPaint(pt);
    }
    function startPaint(pt) {
        const layer = ensureDrawLayer();
        pushHistory();
        const stroke = {
            color: S.pen === 'eraser' ? '#000' : S.color,
            size: S.size, opacity: S.opacity, erase: S.pen === 'eraser',
            pattern: S.pattern, pts: [{ x: pt.x, y: pt.y }],
        };
        layer.strokes.push(stroke);
        S.painting = { id: layer.id, stroke };
        renderLayerList(); render();
    }
    function onStageMove(e) {
        if (S.painting) {
            const pt = canvasPos(e);
            S.painting.stroke.pts.push({ x: pt.x, y: pt.y });
            render();
            return;
        }
        if (!S.drag) return;
        const pt = canvasPos(e);
        const l = getLayer(S.drag.id); if (!l) return;
        if (S.drag.mode === 'move') {
            l.x = S.drag.ox + (pt.x - S.drag.start.x);
            l.y = S.drag.oy + (pt.y - S.drag.start.y);
        } else if (S.drag.mode === 'resize') {
            const b = S.drag.box;
            const dx = pt.x - S.drag.start.x, dy = pt.y - S.drag.start.y;
            let nx = b.x, ny = b.y, nw = b.w, nh = b.h;
            const hh = S.drag.handle;
            if (hh.includes('e')) nw = Math.max(12, b.w + dx);
            if (hh.includes('s')) nh = Math.max(12, b.h + dy);
            if (hh.includes('w')) { nw = Math.max(12, b.w - dx); nx = b.x + (b.w - nw); }
            if (hh.includes('n')) { nh = Math.max(12, b.h - dy); ny = b.y + (b.h - nh); }
            if (l.type === 'text') {
                const k = nh / b.h;
                l.fontSize = Math.max(8, Math.round((S.drag.startFont || l.fontSize) * k));
                const m = textMetrics(l);
                l.x = nx + m.w / 2; l.y = ny + m.h / 2;
            } else {
                l.x = nx; l.y = ny; l.w = nw; l.h = nh;
            }
        }
        render();
    }
    function onStageUp() {
        if (S.painting) { S.painting = null; render(); return; }
        if (S.drag) { S.drag = null; render(); }
    }

    /* ── LEFT panel: layer list (newest on top) ── */
    function layerTag(t) { return t === 'image' ? 'IMG' : t === 'text' ? 'TEXT' : 'DRAW'; }
    function layerLabel(l) {
        if (l.type === 'text') return l.text || 'Text';
        if (l.type === 'image') return l.label || 'Image';
        return 'Drawing';
    }
    function renderLayerList() {
        const wrap = $('#gfe-layer-list'); if (!wrap) return;
        if (!S.layers.length) {
            wrap.innerHTML = `<div class="gfe-layers-empty">No layers yet. Add an image, text, or start drawing.</div>`;
            return;
        }
        // newest on top → iterate reversed
        const rows = [];
        for (let i = S.layers.length - 1; i >= 0; i--) {
            const l = S.layers[i];
            const sel = l.id === S.selId ? ' is-selected' : '';
            const thumb = l.type === 'image'
                ? `<img class="gfe-row-thumb" src="${escapeAttr(l.src)}" alt="">`
                : l.type === 'text'
                    ? `<span class="gfe-row-thumb gfe-row-thumb--text" style="color:${escapeAttr(l.color || '#fff')}">A</span>`
                    : `<span class="gfe-row-thumb gfe-row-thumb--draw"><i class="fa-solid fa-paintbrush"></i></span>`;
            rows.push(
                `<div class="gfe-row${sel}" data-id="${escapeAttr(l.id)}">
                    <span class="gfe-row-tag gfe-tag-${l.type}">${layerTag(l.type)}</span>
                    ${thumb}
                    <span class="gfe-row-label">${escapeHTML(layerLabel(l))}</span>
                    <button type="button" class="gfe-row-del" data-del="${escapeAttr(l.id)}" title="Delete layer"><i class="fa-solid fa-trash-can"></i></button>
                </div>`);
        }
        wrap.innerHTML = rows.join('');
        $$('#gfe-layer-list .gfe-row').forEach(row => {
            on(row, 'click', (e) => {
                if (e.target.closest('.gfe-row-del')) return;
                S.selId = row.dataset.id;
                renderLayerList(); render();
            });
        });
        $$('#gfe-layer-list .gfe-row-del').forEach(b => on(b, 'click', (e) => {
            e.stopPropagation(); deleteLayer(b.dataset.del);
        }));
    }

    /* ── RIGHT: galleries / fonts / swatches ── */
    function renderGallery() {
        const wrap = $('#gfe-gallery'); if (!wrap) return;
        const items = [];
        (S.gallery || []).forEach(name => {
            if (typeof name === 'string' && name) items.push({ src: 'images/' + name, label: name, cors: false });
        });
        // surface legacy external-URL catalogue too, loaded by .url
        (S.images || []).forEach(im => {
            if (im && im.url) items.push({ src: im.url, label: im.label || im.id || 'Image', cors: true });
        });
        if (!items.length) { wrap.innerHTML = `<div class="gfe-gallery-empty">No images available.</div>`; return; }
        wrap.innerHTML = items.map((it, i) =>
            `<button type="button" class="gfe-gallery-item" data-i="${i}" title="${escapeAttr(it.label)}">
                <img src="${escapeAttr(it.src)}" alt="${escapeAttr(it.label)}" onerror="this.closest('.gfe-gallery-item').classList.add('is-broken')">
            </button>`).join('');
        $$('#gfe-gallery .gfe-gallery-item').forEach(btn => on(btn, 'click', () => {
            const it = items[parseInt(btn.dataset.i, 10)];
            if (it) addImageLayer(it.src, it.cors, it.label);
        }));
    }
    function renderFonts() {
        const sel = $('#gfe-font'); if (!sel) return;
        const fonts = S.fonts || [];
        sel.innerHTML = fonts.length
            ? fonts.map(f => `<option value="${escapeAttr(f.font)}">${escapeHTML(f.label || f.font)}</option>`).join('')
            : `<option value="graffiti1">Wildstyle</option>`;
    }
    function swatchHTML(colors, active) {
        return colors.map(c =>
            `<button type="button" class="gfe-swatch${c.toLowerCase() === active.toLowerCase() ? ' is-active' : ''}" data-color="${escapeAttr(c)}" style="--_c:${escapeAttr(c)}" title="${escapeAttr(c)}"></button>`
        ).join('');
    }
    function renderSwatches() {
        const colors = (S.colors && S.colors.length) ? S.colors : ['#1F5EFF'];
        const stage = $('#gfe-stage-swatches');
        const text  = $('#gfe-text-swatches');
        if (stage) {
            stage.innerHTML = swatchHTML(colors, S.color);
            $$('#gfe-stage-swatches .gfe-swatch').forEach(sw => on(sw, 'click', () => setColor(sw.dataset.color)));
        }
        if (text) {
            text.innerHTML = swatchHTML(colors, S.color);
            $$('#gfe-text-swatches .gfe-swatch').forEach(sw => on(sw, 'click', () => setColor(sw.dataset.color)));
        }
    }
    function setColor(hex) {
        S.color = hex;
        // if a text layer is selected, recolour it live
        const l = getLayer(S.selId);
        if (l && l.type === 'text') { pushHistory(); l.color = hex; render(); }
        $$('#gfe-stage-swatches .gfe-swatch, #gfe-text-swatches .gfe-swatch').forEach(sw =>
            sw.classList.toggle('is-active', (sw.dataset.color || '').toLowerCase() === hex.toLowerCase()));
        document.documentElement.style.setProperty('--gf-color', hex);
    }

    /* ── Tool wiring ── */
    function setTool(name) {
        $$('#gfe-toolbar .gfe-tool').forEach(b => b.classList.remove('is-active'));
        const el = name === 'select' ? $('#gfe-tool-select') : null;
        if (el) el.classList.add('is-active');
    }
    function setPen(mode) {
        S.pen = mode;
        $$('#gfe-draw-tools .gfe-seg-btn').forEach(b => b.classList.toggle('is-active', b.dataset.pen === mode));
    }
    function setPattern(p) {
        S.pattern = p;
        $$('#gfe-patterns .gfe-seg-btn').forEach(b => b.classList.toggle('is-active', b.dataset.pat === p));
    }

    /* ── Flatten + SAVE ──
       The server caps the drawing by data-URL STRING length (#drawing), so we
       shrink the flattened PNG until it fits that budget — it can NEVER be
       "too large". Aspect ratio is preserved (640:480) so the wall quad stays
       correct regardless of the export resolution. */
    function exportFit(c, maxBytes) {
        const target = Math.max(40000, Math.floor((Number(maxBytes) || 300000) * 0.92));
        const scales = [1, 0.85, 0.7, 0.55, 0.45, 0.36, 0.28, 0.22, 0.17];
        let last = null;
        for (const s of scales) {
            let url;
            if (s === 1) {
                url = c.toDataURL('image/png');
            } else {
                const w = Math.max(48, Math.round(c.width * s));
                const h = Math.max(36, Math.round(c.height * s));
                const tmp = document.createElement('canvas');
                tmp.width = w; tmp.height = h;
                const t = tmp.getContext('2d');
                t.imageSmoothingEnabled = true; t.imageSmoothingQuality = 'high';
                t.drawImage(c, 0, 0, w, h);
                url = tmp.toDataURL('image/png');
            }
            last = url;
            if (url.length <= target) return url;
        }
        return last;   // smallest attempt — a tiny PNG, effectively always under budget
    }
    function save() {
        const c = canvas(); if (!c) return;
        if (!S.layers.length) { toast('Add something to your graffiti first.', 'error'); return; }
        render();
        let url;
        try {
            url = exportFit(c, S.maxBytes);
        } catch (err) {
            toast('That image blocks export — host it with CORS or drop it in html/images.', 'error');
            return;
        }
        if (!url) { toast('Could not export the graffiti — try fewer / smaller images.', 'error'); return; }
        post('graffiti_choose', { mode: 'draw', drawing: url, width: c.width, height: c.height, color: S.color || '#1F5EFF' });
        hide();
    }

    function clearAll() {
        pushHistory();
        S.layers = []; S.selId = null; S.painting = null; S.drag = null;
        renderLayerList(); render();
    }

    /* ── Open / close ── */
    function setupOnce() {
        if (S.init) return;
        const c = canvas(); if (!c) return;
        c.width = CANVAS_W; c.height = CANVAS_H;
        S.ctx = c.getContext('2d', { willReadFrequently: true });

        // stage pointer
        on(c, 'pointerdown', onStageDown);
        on(c, 'pointermove', onStageMove);
        on(c, 'pointerup',   onStageUp);
        on(c, 'pointerleave', onStageUp);
        // handles live in the overlay above the canvas → forward their pointerdown
        on($('#gfe-handles'), 'pointerdown', (e) => {
            if (e.target.closest('.gfe-handle')) { onStageDown(e); }
        });
        on($('#gfe-handles'), 'pointermove', onStageMove);
        on($('#gfe-handles'), 'pointerup',   onStageUp);

        // toolbar
        on($('#gfe-tool-select'), 'click', () => setTool('select'));
        on($('#gfe-tool-del'), 'click', () => { if (S.selId) deleteLayer(S.selId); });
        on($('#gfe-undo'), 'click', undo);
        on($('#gfe-redo'), 'click', redo);
        on($('#gfe-deselect'), 'click', () => { S.selId = null; renderLayerList(); render(); });

        // draw controls
        on($('#gfe-size'), 'input', (e) => { S.size = parseInt(e.target.value, 10) || 12; const v = $('#gfe-size-val'); if (v) v.textContent = S.size; });
        on($('#gfe-opacity'), 'input', (e) => { S.opacity = (parseInt(e.target.value, 10) || 100) / 100; const v = $('#gfe-opacity-val'); if (v) v.textContent = Math.round(S.opacity * 100); });
        $$('#gfe-draw-tools .gfe-seg-btn').forEach(b => on(b, 'click', () => setPen(b.dataset.pen)));
        $$('#gfe-patterns .gfe-seg-btn').forEach(b => on(b, 'click', () => setPattern(b.dataset.pat)));

        // text
        on($('#gfe-text-add'), 'click', () => {
            const t = ($('#gfe-text')?.value || '').trim();
            if (!t) { toast('Type some text first.', 'error'); return; }
            const font = $('#gfe-font')?.value || (S.fonts?.[0]?.font) || 'graffiti1';
            addTextLayer(t, font, S.color);
            const inp = $('#gfe-text'); if (inp) inp.value = '';
        });

        // image url
        on($('#gfe-url-add'), 'click', () => {
            const u = ($('#gfe-url')?.value || '').trim();
            if (!/^https?:\/\/.+/i.test(u)) { toast('Enter a valid http(s) image URL.', 'error'); return; }
            addImageLayer(u, true, 'Image');
            const inp = $('#gfe-url'); if (inp) inp.value = '';
        });

        // footer
        on($('#gfe-exit'),  'click', cancel);
        on($('#gfe-close'), 'click', cancel);
        on($('#gfe-clear'), 'click', clearAll);
        on($('#gfe-save'),  'click', save);

        // veil right-click → exit
        on($('#gf-veil'), 'mousedown', e => { if (e.button === 2) cancel(); });
        on($('#gf-veil'), 'contextmenu', e => { e.preventDefault(); cancel(); });

        // keep handles aligned on resize
        on(window, 'resize', () => { if (isOpen()) renderHandles(); });

        S.init = true;
    }

    function prime() { /* no-op until graffitiOpen supplies data */ }

    function open(data) {
        data = data || {};
        S.gallery     = Array.isArray(data.gallery) ? data.gallery : [];
        S.images      = Array.isArray(data.images) ? data.images : [];
        S.allowCustom = data.allowCustom === true;
        S.fonts       = Array.isArray(data.fonts) ? data.fonts : [];
        S.colors      = Array.isArray(data.colors) && data.colors.length ? data.colors : ['#1F5EFF'];
        S.color       = S.colors[0];
        S.maxBytes    = Number(data.maxBytes) > 0 ? Number(data.maxBytes) : 300000;
        S.layers = []; S.selId = null; S.seq = 0;
        S.undoStack = []; S.redoStack = [];
        S.painting = null; S.drag = null;
        S.pen = 'pen'; S.pattern = 'round'; S.size = 12; S.opacity = 1;

        const el = root(); if (el) el.hidden = false;   // show first so canvas has layout
        setupOnce();

        renderGallery();
        renderFonts();
        renderSwatches();
        setColor(S.colors[0]);
        setPen('pen'); setPattern('round'); setTool('select');

        const urlRow = $('#gfe-url-row'); if (urlRow) urlRow.hidden = !S.allowCustom;
        const url = $('#gfe-url'); if (url) url.value = '';
        const txt = $('#gfe-text'); if (txt) txt.value = '';
        const nm  = $('#gfe-name'); if (nm) nm.value = '';
        const sz  = $('#gfe-size'); if (sz) sz.value = 12; const szv = $('#gfe-size-val'); if (szv) szv.textContent = '12';
        const op  = $('#gfe-opacity'); if (op) op.value = 100; const opv = $('#gfe-opacity-val'); if (opv) opv.textContent = '100';

        renderLayerList();
        render();
    }

    function hide() { const el = root(); if (el) el.hidden = true; }
    function cancel() { post('graffiti_cancel'); hide(); }

    return { prime, open, close: hide, cancel, isOpen };
})();

/* ============================================================
   GRAFFITI SPRAY PROGRESS — focus-less in-world progress card.
   Driven by graffitiProgress { start?, percent, title?, sub?, cancel? }
   and graffitiProgressEnd {}.
   ============================================================ */
const GraffitiProgress = (() => {
    const root = () => $('#graffiti-progress');
    function tick(d) {
        const el = root(); if (!el) return;
        // title/sub/cancel update whenever provided (the shake→paint transition
        // sends a new title without `start`, so it must not be gated on start).
        if (d.title)  $('#gfp-title').textContent  = d.title;
        if (d.sub)    $('#gfp-sub').textContent     = d.sub;
        if (d.cancel) $('#gfp-cancel').textContent  = d.cancel;
        if (d.start) { el.hidden = false; el.classList.add('is-in'); }
        if (typeof d.indeterminate === 'boolean') el.classList.toggle('is-indeterminate', d.indeterminate);
        const p = Math.max(0, Math.min(100, Math.round(d.percent || 0)));
        const fill = $('#gfp-fill'), pct = $('#gfp-pct');
        if (fill && !el.classList.contains('is-indeterminate')) fill.style.width = p + '%';
        if (pct)  pct.textContent  = p + '%';
    }
    function end() {
        const el = root(); if (!el) return;
        el.classList.remove('is-in'); el.hidden = true;
        const fill = $('#gfp-fill'); if (fill) fill.style.width = '0%';
    }
    return { tick, end };
})();

/* ============================================================
   OPERATION HUD — focus-less in-world HUD for SCOUT (single bar)
   and GANG WAR / raid (two-sided meter). Driven by opHud / opHudHide.
   ============================================================ */
const OpHUD = (() => {
    const root = () => $('#op-hud');
    let arrowDeg = 0;   // accumulated stash-arrow rotation (unwrapped, so it turns the short way)
    function fmtTime(sec) {
        sec = Math.max(0, Math.floor(Number(sec) || 0));
        const m = Math.floor(sec / 60), s = sec % 60;
        return m + ':' + String(s).padStart(2, '0');
    }
    function show(d) {
        const el = root(); if (!el) return;
        const war   = d.mode === 'war';
        const stash = d.mode === 'stash';
        el.classList.toggle('is-war', war);
        el.classList.toggle('is-stash', stash);
        setText('#ophud-time', fmtTime(d.timeLeft));
        setText('#ophud-title', d.label || (war ? 'GANG WAR' : stash ? 'ENEMY STASH' : 'SCOUT'));
        const single = $('#ophud-single'), warEl = $('#ophud-war'), stashEl = $('#ophud-stash');
        if (single)  single.hidden  = war || stash;
        if (warEl)   warEl.hidden    = !war;
        if (stashEl) stashEl.hidden  = !stash;
        if (war) {
            const a = d.a || {}, b = d.b || {};
            if (warEl) {
                warEl.style.setProperty('--a-color', a.color || '#1F5EFF');
                warEl.style.setProperty('--b-color', b.color || '#E5564B');
            }
            setText('#ophud-a-name', a.label || 'Attacker'); setText('#ophud-a-pct', (a.pct || 0) + '%');
            setText('#ophud-b-name', b.label || 'Defender'); setText('#ophud-b-pct', (b.pct || 0) + '%');
            const af = $('#ophud-war-a'), bf = $('#ophud-war-b');
            if (af) af.style.width = Math.max(0, Math.min(100, a.pct || 0)) + '%';
            if (bf) bf.style.width = Math.max(0, Math.min(100, b.pct || 0)) + '%';
        } else if (stash) {
            const arrow = $('#ophud-arrow');
            const target = (((Number(d.bearing) || 0) % 360) + 360) % 360;
            // unwrap to the nearest equivalent angle so the CSS transition always
            // turns the SHORT way (no 350°→10° full-circle backspin).
            const delta = (((target - (arrowDeg % 360)) % 360) + 540) % 360 - 180;
            arrowDeg += delta;
            if (arrow) arrow.style.setProperty('--ar', arrowDeg + 'deg');
            const dist = Math.max(0, Number(d.dist) || 0);
            setText('#ophud-stash-dist', dist >= 1000 ? (dist / 1000).toFixed(1) + ' km' : Math.round(dist) + ' m');
            setText('#ophud-stash-sub', d.sub || 'to enemy stash');
        } else {
            const p = Math.max(0, Math.min(100, Math.round(d.progress || 0)));
            setText('#ophud-players', d.players != null ? d.players : 1);
            setText('#ophud-pct', p + '%');
            const f = $('#ophud-fill'); if (f) f.style.width = p + '%';
        }
        if (el.hidden || d.start) { el.hidden = false; el.classList.remove('is-in'); void el.offsetWidth; el.classList.add('is-in'); }
    }
    function hide() {
        const el = root(); if (!el) return;
        el.classList.remove('is-in', 'is-stash'); el.hidden = true;
        const f = $('#ophud-fill'); if (f) f.style.width = '0%';
        arrowDeg = 0;
    }
    return { show, hide };
})();

/* ============================================================
   MISSION OBJECTIVES — focus-less step-by-step guide HUD.
   Driven by missionHud { title, steps:[{label,state,key}] } / missionHudHide.
   ============================================================ */
const MissionHUD = (() => {
    const root = () => $('#mission-hud');
    const ICON = { done: 'fa-circle-check', active: 'fa-location-arrow', todo: 'fa-circle' };
    function show(d) {
        const el = root(); if (!el) return;
        setText('#mhud-title', d.title || 'Mission');
        const list = $('#mhud-steps');
        if (list) {
            list.innerHTML = (d.steps || []).map(s => {
                const st = s.state || 'todo';
                return `<li class="mhud-step ${st}"><i class="fa-solid ${ICON[st] || ICON.todo}"></i>`
                     + `<span>${escapeHTML(s.label || '')}</span>`
                     + `${s.key ? `<span class="mhud-key">${escapeHTML(s.key)}</span>` : ''}</li>`;
            }).join('');
        }
        if (el.hidden) { el.hidden = false; el.classList.remove('is-in'); void el.offsetWidth; el.classList.add('is-in'); }
    }
    function hide() { const el = root(); if (el) { el.classList.remove('is-in'); el.hidden = true; } }
    return { show, hide };
})();

/* ============================================================
   GRAFFITI PLACEMENT CONTROLS — focus-less in-world control card
   with a live size/rotation readout. Driven by
   graffitiControls { start?, size, rotation, labels? } and
   graffitiControlsEnd {}.
   ============================================================ */
const GraffitiControls = (() => {
    const root = () => $('#graffiti-controls');
    function tick(d) {
        const el = root(); if (!el) return;
        if (d.start) {
            const lab = d.labels || {};
            const set = (id, v) => { const n = $(id); if (n && v) n.textContent = v; };
            set('#gfc-size-l', lab.size);   set('#gfc-rot-l', lab.rotation);
            set('#gfc-k-rotate', lab.rotate); set('#gfc-k-size', lab.size);
            set('#gfc-k-place', lab.place);   set('#gfc-k-cancel', lab.cancel);
            el.hidden = false; el.classList.add('is-in');
        }
        if (typeof d.size === 'number') {
            const n = $('#gfc-size'); if (n) n.textContent = Math.round(d.size * 100) + '%';
        }
        if (typeof d.rotation === 'number') {
            const n = $('#gfc-rot'); if (n) n.textContent = Math.round(((d.rotation % 360) + 360) % 360) + '°';
        }
    }
    function end() { const el = root(); if (!el) return; el.classList.remove('is-in'); el.hidden = true; }
    return { tick, end };
})();

/* ============================================================
   VAULT
   ============================================================ */
function buildVaultDays(history) {
    const since = Math.floor(Date.now() / 1000) - 7 * 86400;
    let inSum = 0, outSum = 0;
    (history || []).forEach(h => {
        if ((Number(h.created_at) || 0) < since) return;
        const amt = Math.abs(Number(h.amount) || 0);
        const a = String(h.action || '').toLowerCase();
        if (a.indexOf('deposit') !== -1) inSum += amt;
        if (a.indexOf('withdraw') !== -1) outSum += amt;
    });
    return { inSum, outSum };
}
function applyVault(data) {
    state.vault = data || {};
    setText('#vault-balance', fmtMoney(data?.balance || 0));
    setText('#ov-treasury',   fmtMoney(data?.balance || 0));
    setText('#vault-cash',    fmtMoney(data?.cash || 0));
    setText('#vault-sync',    data?.sync ? 'Synced with the society account.' : 'Local safe balance.');
    const d = buildVaultDays(data?.history);
    setText('#vault-in-7d',  fmtMoney(d.inSum));
    setText('#vault-out-7d', fmtMoney(d.outSum));
    renderVaultHistory(data?.history || []);
}
function renderVaultHistory(history) {
    const root = $('#vault-history'); if (!root) return;
    const rows = (history || []).slice(0, 40);
    setText('#vault-history-count', `${rows.length} transaction${rows.length === 1 ? '' : 's'}`);
    if (!rows.length) { root.innerHTML = `<div class="tx-empty">No transactions yet.</div>`; return; }
    root.innerHTML = rows.map(r => {
        const a = String(r.action || '').toLowerCase();
        const isIn = a.indexOf('deposit') !== -1;
        const isMoney = isIn || a.indexOf('withdraw') !== -1;
        const cls = isIn ? 'in' : 'out';
        const icon = isIn ? 'arrow-down' : (a.indexOf('open') !== -1 ? 'box-archive' : 'arrow-up');
        const label = a.indexOf('open') !== -1 ? 'Opened safe' : (isIn ? 'Deposit' : 'Withdraw');
        const amt = isMoney && r.amount ? `<div class="tx-amount ${isIn ? 'pos' : 'neg'}">${isIn ? '+' : '-'} ${fmtMoney(r.amount)}</div>` : '';
        return `
            <div class="tx-row">
                <div class="tx-ic ${cls}"><i class="fa-solid fa-${icon}"></i></div>
                <div class="tx-meta">
                    <div class="tx-label">${escapeHTML(label)}</div>
                    <div class="tx-sub">${escapeHTML(r.actor || 'System')} · ${new Date((r.created_at || 0) * 1000).toLocaleString()}</div>
                </div>
                ${amt}
            </div>`;
    }).join('');
}
function refreshVault() {
    call('vault:get').then(r => {
        if (!r.ok) {
            const root = $('#vault-history');
            if (root) root.innerHTML = `<div class="tx-empty">${escapeHTML(errMsg(r.error))}</div>`;
            return;
        }
        applyVault(r.data || {});
    });
}
on($('#dep-go'), 'click', () => {
    const amt = Math.floor(Number($('#dep-amount')?.value) || 0);
    if (amt <= 0) return toast('Invalid amount', 'error');
    call('vault:deposit', { amount: amt }).then(r => {
        if (!r.ok) return toast(errMsg(r.error), 'error');
        if ($('#dep-amount')) $('#dep-amount').value = '';
        applyVault(r.data || {});
        toast(`Deposited ${fmtMoney(amt)}.`, 'success');
    });
});
on($('#wd-go'), 'click', () => {
    const amt = Math.floor(Number($('#wd-amount')?.value) || 0);
    if (amt <= 0) return toast('Invalid amount', 'error');
    call('vault:withdraw', { amount: amt }).then(r => {
        if (!r.ok) return toast(errMsg(r.error), 'error');
        if ($('#wd-amount')) $('#wd-amount').value = '';
        applyVault(r.data || {});
        toast(`Withdrew ${fmtMoney(amt)}.`, 'success');
    });
});
document.addEventListener('click', e => {
    const add = e.target.closest('[data-dep-add]');
    if (add) { const inp = $('#dep-amount'); if (inp) inp.value = (Number(inp.value) || 0) + Number(add.dataset.depAdd); }
    const wa = e.target.closest('[data-wd-add]');
    if (wa) { const inp = $('#wd-amount'); if (inp) inp.value = (Number(inp.value) || 0) + Number(wa.dataset.wdAdd); }
});
/* ============================================================
   GARAGE — dedicated overlay (separate from the main menu)
   Driven by openGarage / garageSync messages from Lua.
   ============================================================ */
const Garage = {
    isOpen() { const el = $('#garage-overlay'); return !!(el && !el.hidden); },
    open(data) {
        state.garage = {
            vehicles: (data?.vehicles) || [],
            limit   : data?.limit ?? state.garage.limit ?? 0,
            point   : data?.point ?? state.garage.point ?? null,
        };
        const el = $('#garage-overlay'); if (el) el.hidden = false;
        Garage.render();
    },
    sync(data) {
        // Update the shared store and re-render whichever garage view is showing
        // (the overlay AND/OR the HQ-menu Garage tab) — e.g. after a store.
        state.garage = {
            vehicles: (data?.vehicles) || [],
            limit   : data?.limit ?? state.garage.limit ?? 0,
            point   : state.garage.point,
        };
        refreshGarageViews();
    },
    close() {
        const el = $('#garage-overlay'); if (el) el.hidden = true;
        post('garage_close', {});
    },
    render() {
        const root = $('#garage-body'); if (!root) return;
        const vehicles = state.garage.vehicles || [];
        const limit = state.garage.limit || 0;
        setText('#garage-count', `${vehicles.length} / ${limit || '∞'}`);
        root.innerHTML = garageCardsHTML(vehicles);
        applyPermGates(root);
    },
};

// Shared vehicle-card markup, used by BOTH the dedicated garage overlay and the
// HQ-menu Garage tab. Take/delete are wired via document-level delegation, so
// they work in either container.
function garageCardsHTML(vehicles) {
    if (!vehicles || !vehicles.length) {
        return `<div class="garage-empty">
            <span class="garage-empty-ic"><i class="fa-solid fa-warehouse"></i></span>
            <span>No vehicles stored yet — store the vehicle you're in.</span>
        </div>`;
    }
    return vehicles.map(v => {
        const stored = Number(v.stored) === 1;
        return `
        <div class="veh-card ${stored ? '' : 'is-out'}" data-vid="${v.id}">
            <div class="veh-ic"><i class="fa-solid fa-car-side"></i></div>
            <div class="veh-main">
                <div class="veh-label">${escapeHTML(v.label || v.model || 'Vehicle')}</div>
                <div class="veh-meta">
                    <span class="veh-plate">${escapeHTML(v.plate || '—')}</span>
                    <span class="veh-status ${stored ? 'stored' : 'out'}">${stored ? 'Stored' : 'Out'}</span>
                </div>
            </div>
            <div class="veh-actions">
                ${stored
                    ? `<button class="btn btn-primary btn-sm veh-take" data-perm="take_vehicle"><i class="fa-solid fa-key"></i> Take</button>`
                    : `<span class="veh-out-pill">Out</span>`}
                ${stored
                    ? `<button class="btn btn-ghost btn-sm veh-remove" data-perm="delete_vehicle" title="Delete vehicle from garage"><i class="fa-solid fa-trash"></i></button>`
                    : ''}
            </div>
        </div>`;
    }).join('');
}

// HQ-menu Garage tab: render from the shared state into its own body.
function renderHqGarage() {
    const body = $('#hq-garage-body'); if (!body) return;
    const vehicles = state.garage?.vehicles || [];
    const limit = state.garage?.limit || 0;
    setText('#hq-garage-count', `${vehicles.length} / ${limit || '∞'}`);
    body.innerHTML = garageCardsHTML(vehicles);
    applyPermGates(body);
}
// Pull the gang's garage list for the HQ tab.
function refreshGarageTab() {
    const body = $('#hq-garage-body'); if (body) body.innerHTML = `<div class="garage-empty"><span>Loading…</span></div>`;
    call('garage:list', {}).then(r => {
        if (!r.ok) {
            state.garage = { vehicles: [], limit: 0, point: null };
            if (body) body.innerHTML = `<div class="garage-empty"><span class="garage-empty-ic"><i class="fa-solid fa-lock"></i></span><span>${escapeHTML(errMsg(r.error))}</span></div>`;
            setText('#hq-garage-count', '0 / 0');
            return;
        }
        state.garage = { vehicles: r.data?.vehicles || [], limit: r.data?.limit ?? 0, point: r.data?.point ?? null };
        renderHqGarage();
    });
}
// Re-render whichever garage view(s) are currently on screen.
function refreshGarageViews() {
    if (Garage.isOpen && Garage.isOpen()) Garage.render();
    if (state.activeTab === 'garage') renderHqGarage();
}

// Take a stored vehicle. OPTIMISTIC: flip it to "out" immediately so the UI
// updates instantly, then reconcile with the server and close so the car spawns.
document.addEventListener('click', e => {
    const take = e.target.closest('.veh-take'); if (!take) return;
    const card = take.closest('.veh-card'); if (!card) return;
    const id = Number(card.dataset.vid);
    take.disabled = true;
    const prev = (state.garage?.vehicles || []).slice();
    state.garage.vehicles = prev.map(v => Number(v.id) === id ? { ...v, stored: 0 } : v);
    refreshGarageViews();
    call('garage:take', { id }).then(r => {
        if (!r.ok) { state.garage.vehicles = prev; refreshGarageViews(); return toast(errMsg(r.error), 'error'); }
        if (r.data?.vehicles) state.garage.vehicles = r.data.vehicles;
        if (r.data?.limit != null) state.garage.limit = r.data.limit;
        toast('Vehicle on the way.', 'success');
        refreshGarageViews();
        // close whichever view so the player can reach the car
        if (Garage.isOpen && Garage.isOpen()) Garage.close();
        else if (state.activeTab === 'garage') post('close');
    });
});
// Delete a stored vehicle. Gated by the 'delete_vehicle' permission. OPTIMISTIC:
// drop it from the list immediately, then reconcile (restore on failure).
document.addEventListener('click', e => {
    const rm = e.target.closest('.veh-remove'); if (!rm) return;
    const card = rm.closest('.veh-card'); if (!card) return;
    const id = Number(card.dataset.vid);
    const label = card.querySelector('.veh-label')?.textContent || 'this vehicle';
    confirmDlg(`Delete ${label} from the garage? This cannot be undone.`, () => {
        const prev = (state.garage?.vehicles || []).slice();
        state.garage.vehicles = prev.filter(v => Number(v.id) !== id);
        refreshGarageViews();
        call('garage:remove', { id }).then(r => {
            if (!r.ok) { state.garage.vehicles = prev; refreshGarageViews(); return toast(errMsg(r.error), 'error'); }
            if (r.data?.vehicles) state.garage.vehicles = r.data.vehicles;
            refreshGarageViews();
            toast('Vehicle deleted.', 'success');
        });
    });
});
// Store the live vehicle (overlay + HQ-tab buttons). Lua reads the current vehicle.
on($('#garage-store'), 'click', () => post('garage_store', {}));
on($('#hq-garage-store'), 'click', () => post('garage_store', {}));
// Close: ✕ button, the veil (click-outside / right-click), Escape (in the keydown handler).
on($('#garage-close'), 'click', () => Garage.close());
on($('#garage-veil'),  'click', () => Garage.close());
on($('#garage-veil'),  'contextmenu', e => { e.preventDefault(); Garage.close(); });
on($('#garage-panel'), 'contextmenu', e => { e.preventDefault(); Garage.close(); });

/* ============================================================
   OPERATIONS — scout + raid
   ============================================================ */
function refreshOps() {
    call('ops:rivals').then(r => {
        const root = $('#ops-list');
        if (!r.ok) { if (root) root.innerHTML = `<div class="pane-empty"><span>${escapeHTML(errMsg(r.error))}</span></div>`; return; }
        state.rivals = r.data || {};
        renderOpsCooldowns(state.rivals.scoutCd || 0, state.rivals.raidCd || 0);
        renderRivals(state.rivals.rivals || []);
    });
}
function renderOpsCooldowns(scout, raid) {
    const sEl = $('#ops-scout-cd'), rEl = $('#ops-raid-cd');
    if (sEl) {
        sEl.className = 'ops-cd ' + (scout > 0 ? 'cooling' : 'ready');
        sEl.innerHTML = `<i class="fa-solid fa-binoculars"></i> Scout ${scout > 0 ? fmtDur(scout) : 'ready'}`;
    }
    if (rEl) {
        rEl.className = 'ops-cd ' + (raid > 0 ? 'cooling' : 'ready');
        rEl.innerHTML = `<i class="fa-solid fa-fire"></i> Raid ${raid > 0 ? fmtDur(raid) : 'ready'}`;
    }
}
function renderRivals(rivals) {
    const root = $('#ops-list'); if (!root) return;
    if (!rivals.length) {
        root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-handshake-simple-slash"></i></span><span>No rival gangs.</span></div>`;
        return;
    }
    root.innerHTML = rivals.map(rv => {
        const color = rv.color || '#E5564B';
        return `
        <div class="rival-card" data-rival="${escapeAttr(rv.gang)}" style="--rival-color:${color}">
            <div class="rival-top">
                <div class="rival-logo">${escapeHTML(initials(rv.label || rv.gang))}</div>
                <div class="rival-meta">
                    <div class="rival-name">${escapeHTML(rv.label || rv.gang)}</div>
                    <div class="rival-sub">
                        <span>Lv ${rv.level || 1}</span>
                        <span class="online-dot"><i class="fa-solid fa-circle" style="font-size:6px"></i> ${rv.online || 0} online</span>
                    </div>
                </div>
            </div>
            <div class="rival-actions">
                <button class="btn btn-ghost btn-sm rival-scout" data-perm="start_scout"><i class="fa-solid fa-binoculars"></i> Scout</button>
                <button class="btn btn-danger btn-sm rival-raid" data-perm="start_raid"><i class="fa-solid fa-fire"></i> Raid</button>
            </div>
        </div>`;
    }).join('');
    applyPermGates(root);
}
document.addEventListener('click', e => {
    const scout = e.target.closest('.rival-scout');
    if (scout) {
        const card = scout.closest('.rival-card'); const target = card?.dataset.rival; if (!target) return;
        scout.disabled = true;
        call('ops:scout', { target }).then(r => {
            scout.disabled = false;
            if (!r.ok) return toast(errMsg(r.error), 'error');
            const d = r.data || {};
            // Menu scout is instant. (The on-site [E] recon is the channeled one.)
            if (d.success) showIntel(target, d.intel || {});
            else toast('Scout failed — no useful intel gathered.', 'warning');
            refreshOps();
        });
        return;
    }
    const raid = e.target.closest('.rival-raid');
    if (raid) {
        const card = raid.closest('.rival-card'); const target = card?.dataset.rival; if (!target) return;
        const label = card.querySelector('.rival-name')?.textContent || target;
        raidConfirm(target, label);
    }
});

/* Raid pre-launch dialog — cost (society money + REP) + optional
   "Capture their base" toggle (adds a surcharge + seizes a zone on win). */
function raidConfirm(target, label) {
    const overlay = $('#raid-overlay'); if (!overlay) return;
    const rc = state.config?.raid || {};
    const cb = rc.captureBase || {};
    const cap = $('#raid-cap');
    if (cap) cap.checked = false;
    const capWrap = $('#raid-cap-wrap');
    if (capWrap) capWrap.style.display = cb.enabled ? '' : 'none';
    setText('#raid-dlg-title', `Start raiding ${label}?`);
    const paint = () => {
        const on = !!(cap && cap.checked);
        const cash = (rc.cashCost || 0) + (on ? (cb.extraCash || 0) : 0);
        const rep = (rc.repCost || 0) + (on ? (cb.extraRep || 0) : 0);
        setText('#raid-cost-cash', fmtMoney(cash));
        setText('#raid-cost-rep', `${rep.toLocaleString()} REP`);
    };
    paint();
    overlay.hidden = false;
    const onToggle = () => paint();
    const close = () => {
        overlay.hidden = true;
        document.removeEventListener('click', click);
        if (cap) cap.removeEventListener('change', onToggle);
    };
    const click = (e) => {
        const a = e.target.closest('[data-action]')?.dataset.action;
        if (a === 'raid-yes') {
            const captureBase = !!(cap && cap.checked);
            close();
            call('ops:raid', { target, captureBase }).then(r => {
                if (!r.ok) return toast(errMsg(r.error), 'error');
                toast(captureBase ? 'Raid launched — going for their base.' : 'Raid launched.', 'success');
                refreshOps();
            });
        } else if (a === 'raid-no') {
            close();
        }
    };
    if (cap) cap.addEventListener('change', onToggle);
    document.addEventListener('click', click);
}
function showIntel(target, intel) {
    const def = intel.defenseState || 'unknown';
    inputDlg({
        title: `Intel · ${escapeHTML(target)}`,
        html: `
            <div class="intel-grid">
                <div class="intel-stat"><span>Level</span><strong>${intel.level ?? '—'}</strong></div>
                <div class="intel-stat"><span>Members online</span><strong>${intel.onlineMembers ?? 0}</strong></div>
                <div class="intel-stat"><span>Territory held</span><strong>${intel.turfCount ?? 0}</strong></div>
                <div class="intel-stat"><span>Vault (est.)</span><strong>${fmtMoney(intel.vaultEstimate || 0)}</strong></div>
                <div class="intel-stat"><span>Defense</span><strong>${escapeHTML(String(def).toUpperCase())}</strong></div>
                <div class="intel-stat"><span>HQ area</span><strong>${intel.hqArea ? Math.round(intel.hqArea.x) + ', ' + Math.round(intel.hqArea.y) : 'Unknown'}</strong></div>
            </div>`,
        fields: [],
        okLabel: 'Close',
        single: true,
    });
}

// Raid banner (raidBegin / raidEnd messages)
function startRaidBanner(label, duration) {
    const banner = $('#ops-raid-banner'); if (!banner) return;
    if (state.activeTab !== 'operations') setTab('operations');
    banner.hidden = false; banner.classList.remove('success');
    setText('#ops-raid-eyebrow', 'Raid in progress');
    setText('#ops-raid-title', `Raiding ${label || ''}`.trim());
    let left = Math.max(0, Math.floor(Number(duration) || 0));
    setText('#ops-raid-timer', clock(left));
    if (state.raidTimer) clearInterval(state.raidTimer);
    state.raidTimer = setInterval(() => {
        left -= 1;
        setText('#ops-raid-timer', clock(left));
        if (left <= 0) { clearInterval(state.raidTimer); state.raidTimer = null; setText('#ops-raid-timer', 'Resolving…'); }
    }, 1000);
}
function endRaidBanner(success, loot) {
    const banner = $('#ops-raid-banner'); if (!banner) return;
    if (state.raidTimer) { clearInterval(state.raidTimer); state.raidTimer = null; }
    banner.hidden = false; banner.classList.toggle('success', !!success);
    setText('#ops-raid-eyebrow', success ? 'Raid successful' : 'Raid failed');
    const money = loot?.money || 0;
    setText('#ops-raid-title', success ? `Looted ${fmtMoney(money)}` : 'No loot taken');
    setText('#ops-raid-timer', success ? '✓' : '✕');
    setTimeout(() => { if (banner) banner.hidden = true; }, 9000);
    refreshOps();
}

/* ============================================================
   TASKS
   ============================================================ */
function refreshTasks() {
    call('tasks:list').then(r => {
        const root = $('#tasks-list');
        if (!r.ok) { if (root) root.innerHTML = `<div class="pane-empty"><span>${escapeHTML(errMsg(r.error))}</span></div>`; return; }
        state.tasks = r.data || [];
        renderTasks();
    });
}
function renderTasks() {
    const root = $('#tasks-list'); if (!root) return;
    const tasks = state.tasks || [];
    const done = tasks.filter(x => x.status === 'completed').length;
    setText('#tasks-stats', `${tasks.length} tasks · ${done} completed`);
    if (!tasks.length) {
        root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-list-check"></i></span><span>No active tasks.</span></div>`;
        return;
    }
    const TASK_ICON = {
        assassination: 'crosshairs', body_disposal: 'skull', kidnapping: 'sack-xmark', narcotics_heist: 'cannabis',
        explore_hq: 'magnifying-glass-location', tag_streets: 'spray-can', recruit: 'user-plus',
        hold_turf: 'flag', stock_vault: 'box-archive', run_scout: 'binoculars', pull_raid: 'fire',
    };
    const TYPE_ICON = { mission: 'crosshairs', territory: 'map-location-dot', logistics: 'boxes-stacked', combat: 'fire', explore: 'magnifying-glass-location' };
    root.innerHTML = tasks.map(task => {
        const obj = Number(task.objective) || 0;
        const prog = Number(task.progress) || 0;
        const pct = obj > 0 ? Math.max(0, Math.min(100, (prog / obj) * 100)) : (task.status === 'completed' ? 100 : 0);
        const isDone = task.status === 'completed' || pct >= 100;
        const isMission = task.type === 'mission';
        const rw = task.reward || {};
        const icon = TASK_ICON[task.key] || TYPE_ICON[task.type] || 'list-check';
        // reward fields can be a fixed number OR a { min, max } range → show the max.
        const amt = v => (v && typeof v === 'object') ? (Number(v.max ?? v.min) || 0) : (Number(v) || 0);
        const money = amt(rw.money), rep = amt(rw.rep);
        const rewards = [
            money ? `<span class="tr-money"><i class="fa-solid fa-sack-dollar"></i> ${fmtMoney(money)}</span>` : '',
            rep   ? `<span class="tr-rep"><i class="fa-solid fa-fire-flame-curved"></i> ${rep.toLocaleString()} REP</span>` : '',
        ].join('');
        let action;
        if (isDone) {
            action = `<span class="task-done-tag"><i class="fa-solid fa-circle-check"></i> Completed</span>`;
        } else if (isMission) {
            action = `<button class="task-start" data-task-start="${escapeAttr(task.key)}">START <i class="fa-solid fa-angles-right"></i></button>`;
        } else {
            action = `<span class="task-prog-text mono">${prog} / ${obj || '∞'}</span>`;
        }
        const progressBar = (!isMission && !isDone)
            ? `<div class="task-bar"><span class="task-bar-fill" style="width:${pct}%"></span></div>` : '';
        return `
        <div class="task-card ${isMission ? 'mission' : 'contract'} ${isDone ? 'done' : ''}" data-task-type="${escapeAttr(task.type || '')}">
            <span class="task-accent"></span>
            <div class="task-ic"><i class="fa-solid fa-${icon}"></i></div>
            <div class="task-main">
                <div class="task-name-row">
                    <span class="task-name">${escapeHTML(task.name || task.key || 'Task')}</span>
                    <span class="task-chip">${escapeHTML(task.type || 'task')}</span>
                </div>
                <div class="task-desc">${escapeHTML(task.desc || '')}</div>
                ${progressBar}
            </div>
            <div class="task-side">
                <div class="task-rewards">${rewards}</div>
                ${action}
            </div>
        </div>`;
    }).join('');
}
on($('#tasks-reroll'), 'click', () => {
    call('tasks:refresh').then(r => {
        if (!r.ok) return toast(errMsg(r.error), 'error');
        toast('Tasks rerolled.', 'success'); refreshTasks();
    });
});
// START a mission task → server begins it in the world, then close the menu.
document.addEventListener('click', e => {
    const btn = e.target.closest('[data-task-start]'); if (!btn) return;
    const key = btn.dataset.taskStart; if (!key) return;
    btn.disabled = true;
    call('tasks:start', { key }).then(r => {
        btn.disabled = false;
        if (!r.ok) return toast(errMsg(r.error), 'error');
        toast('Mission started — follow the objective marker.', 'success');
        post('close');
    });
});

/* ============================================================
   ANALYTICS — "street standing" board of every gang.
   ============================================================ */
function refreshAnalytics() {
    call('analytics:get').then(r => {
        const root = $('#analytics-list');
        if (!r.ok) { if (root) root.innerHTML = `<div class="pane-empty"><span>${escapeHTML(errMsg(r.error))}</span></div>`; return; }
        state.analytics = r.data || [];
        renderAnalytics();
    });
}
function renderAnalytics() {
    const root = $('#analytics-list'); if (!root) return;
    const gangs = state.analytics || [];
    setText('#analytics-stats', `${gangs.length} gangs ranked by reputation`);
    if (!gangs.length) { root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-chart-line"></i></span><span>No gangs yet.</span></div>`; return; }
    const maxRep = Math.max(1, ...gangs.map(g => g.rep || 0));
    root.innerHTML = gangs.map((g, i) => {
        const color = g.color || '#1F5EFF';
        const pct = Math.max(2, Math.round(((g.rep || 0) / maxRep) * 100));
        return `
        <div class="an-row ${g.mine ? 'mine' : ''}" style="--an:${color}">
            <div class="an-rank">#${i + 1}</div>
            <div class="an-id">
                <span class="an-dot" style="background:${color}"></span>
                <div class="an-name-wrap">
                    <span class="an-name">${escapeHTML(g.label || g.gang)}${g.mine ? ' <span class="an-you">YOU</span>' : ''}</span>
                    <span class="an-sub">Lv ${g.level || 1} · <span class="an-on">${g.online || 0}</span>/${g.members || 0} online</span>
                </div>
            </div>
            <div class="an-rep"><div class="an-bar"><span style="width:${pct}%"></span></div><strong>${(g.rep || 0).toLocaleString()}</strong><small>REP</small></div>
            <div class="an-stat"><i class="fa-solid fa-map-location-dot"></i> ${g.turf || 0}</div>
            <div class="an-stat money"><i class="fa-solid fa-sack-dollar"></i> ${fmtMoney(g.treasury || 0)}${g.exact ? '' : '<sup>~</sup>'}</div>
        </div>`;
    }).join('');
}
on($('#analytics-refresh'), 'click', () => { refreshAnalytics(); toast('Refreshed', 'success'); });

/* ============================================================
   LIVE MAP — turf zones (click → Scout / Raid) — RP rules server-side.
   ============================================================ */
function renderTurfOnMap() {
    const map = ensureMap(); if (!map) return;
    (state.turfLayers || []).forEach(l => map.removeLayer(l));
    state.turfLayers = [];
    call('turf:map').then(r => {
        if (!r.ok) return;
        (r.data || []).forEach(z => {
            if (!z.coords) return;
            const color = z.ownerColor || '#9aa0aa';
            let layer;
            if (z.shape === 'poly' && z.points && z.points.length >= 3) {
                layer = L.polygon(z.points.map(p => [p.y, p.x]), { color, weight: 2, fillColor: color, fillOpacity: 0.16 });
            } else {
                layer = L.circle([z.coords.y, z.coords.x], { radius: z.radius || 50, color, weight: 2, fillColor: color, fillOpacity: 0.14 });
            }
            const ownerLabel = z.ownerLabel || (z.owner || 'Neutral');
            const canOps = z.owner && !z.mine;
            layer.bindPopup(`
                <div class="zone-popup">
                    <div class="zp-head"><span class="zp-dot" style="background:${color}"></span><strong>${escapeHTML(z.label || 'Territory')}</strong></div>
                    <div class="zp-owner">${escapeHTML(ownerLabel)}${z.mine ? ' · <b>your turf</b>' : ''}</div>
                    ${z.state && z.state.contested ? '<div class="zp-contested"><i class="fa-solid fa-triangle-exclamation"></i> Contested</div>' : ''}
                    ${canOps ? `<div class="zp-actions">
                        <button class="btn btn-ghost btn-sm" data-zone-scout="${escapeAttr(z.owner)}"><i class="fa-solid fa-binoculars"></i> Scout</button>
                        <button class="btn btn-danger btn-sm" data-zone-raid="${escapeAttr(z.owner)}"><i class="fa-solid fa-fire"></i> Raid</button>
                    </div>` : (!z.owner ? '<div class="zp-neutral">Neutral — spray graffiti to claim it</div>' : '')}
                </div>`, { maxWidth: 250 });
            layer.addTo(map);
            state.turfLayers.push(layer);
        });
    });
}
// Zone popup actions → ops (server enforces the RP rules + gates).
document.addEventListener('click', e => {
    const s = e.target.closest('[data-zone-scout]');
    if (s) {
        const t = s.dataset.zoneScout;
        call('ops:scout', { target: t }).then(r => {
            if (!r.ok) return toast(errMsg(r.error), 'error');
            const d = r.data || {};
            if (d.success) showIntel(t, d.intel || {}); else toast('Scout failed — no useful intel.', 'warning');
        });
        return;
    }
    const rd = e.target.closest('[data-zone-raid]');
    if (rd) {
        const t = rd.dataset.zoneRaid;
        raidConfirm(t, rd.dataset.zoneLabel || t);
        return;
    }
});

/* ============================================================
   UPGRADES
   ============================================================ */
function refreshUpgrades() {
    call('upgrades:list').then(r => {
        const root = $('#upg-list');
        if (!r.ok) { if (root) root.innerHTML = `<div class="pane-empty"><span>${escapeHTML(errMsg(r.error))}</span></div>`; return; }
        state.upgrades = r.data || {};
        renderUpgrades();
    });
}
const UPG_ICONS = {
    member_cap: 'users', vault_space: 'vault', garage_space: 'warehouse', graffiti_cap: 'spray-can',
    task_cd: 'bolt', raid_reward: 'sack-dollar', zone_reward: 'map-location-dot', hq_security: 'shield-halved',
    medic_unlock: 'kit-medical',
};
function renderUpgrades() {
    const root = $('#upg-list'); if (!root) return;
    const data = state.upgrades || {};
    const list = data.list || [];
    const level = data.level || state.gang?.level || 1;
    setText('#upg-stats', `Gang level ${level} · spend treasury to upgrade`);
    if (!list.length) {
        root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-arrow-up-right-dots"></i></span><span>No upgrades available.</span></div>`;
        return;
    }
    root.innerHTML = list.map(u => {
        const max = Number(u.max) || 1;
        const lvl = Number(u.level) || 0;
        const maxed = u.maxed || lvl >= max;
        const locked = level < (u.minLevel || 1);
        const pips = Array.from({ length: max }, (_, i) => `<span class="upg-pip ${i < lvl ? 'on' : ''}"></span>`).join('');
        const icon = UPG_ICONS[u.key] || 'circle-up';
        let btn;
        if (maxed) btn = `<button class="btn btn-ghost btn-sm" disabled><i class="fa-solid fa-check"></i> Maxed</button>`;
        else if (locked) btn = `<button class="btn btn-ghost btn-sm" disabled><i class="fa-solid fa-lock"></i> Lv ${u.minLevel}</button>`;
        else btn = `<button class="btn btn-primary btn-sm upg-buy" data-key="${escapeAttr(u.key)}" data-perm="buy_upgrades"><i class="fa-solid fa-cart-shopping"></i> Buy</button>`;
        return `
        <div class="upg-card ${maxed ? 'maxed' : ''} ${locked ? 'locked' : ''}">
            <div class="upg-head">
                <div class="upg-ic"><i class="fa-solid fa-${icon}"></i></div>
                <div class="upg-info">
                    <div class="upg-name">${escapeHTML(u.label || u.key)}</div>
                    <div class="upg-desc">${escapeHTML(u.desc || '')}</div>
                </div>
            </div>
            <div class="upg-level-row">
                <div class="upg-pips">${pips}</div>
                <span class="upg-lvl-text">${lvl}/${max}</span>
            </div>
            <div class="upg-foot">
                <span class="upg-cost ${maxed || locked ? 'locked-cost' : ''}">${maxed ? '—' : fmtMoney(u.cost)}</span>
                ${btn}
            </div>
        </div>`;
    }).join('');
    applyPermGates(root);
}
document.addEventListener('click', e => {
    const buy = e.target.closest('.upg-buy'); if (!buy) return;
    const key = buy.dataset.key; if (!key) return;
    buy.disabled = true;
    call('upgrades:buy', { key }).then(r => {
        buy.disabled = false;
        if (!r.ok) return toast(errMsg(r.error), 'error');
        toast('Upgrade purchased.', 'success');
        if (r.data?.list) { state.upgrades.list = r.data.list; renderUpgrades(); } else refreshUpgrades();
        renderGangHeader();
    });
});

/* ============================================================
   MEDIC
   ============================================================ */
function refreshMedic() {
    call('medic:status').then(r => {
        const root = $('#medic-wrap'); if (!root) return;
        if (!r.ok) { root.innerHTML = `<div class="pane-empty"><span>${escapeHTML(errMsg(r.error))}</span></div>`; return; }
        state.medic = r.data || {};
        renderMedic();
    });
}
function renderMedic() {
    const root = $('#medic-wrap'); if (!root) return;
    const m = state.medic || {};
    if (!m.unlocked) {
        root.innerHTML = `
            <div class="medic-locked">
                <div class="medic-locked-ic"><i class="fa-solid fa-lock"></i></div>
                <h3>Gang medic locked</h3>
                <p>Unlock the gang medic via the <b>Gang Medic</b> upgrade (or by reaching the required level). Once unlocked you can heal and revive members for a treasury cost.</p>
                <button class="btn btn-ghost" data-jump-tab="upgrades"><i class="fa-solid fa-arrow-up-right-dots"></i> Go to upgrades</button>
            </div>`;
        return;
    }
    root.innerHTML = `
        <div class="medic-grid">
            <div class="medic-card heal">
                <div class="medic-card-ic"><i class="fa-solid fa-heart-pulse"></i></div>
                <h3>Heal</h3>
                <p>Patch up and restore health to a nearby member.</p>
                <div class="medic-cost">${fmtMoney(m.healCost || 0)}</div>
                <button class="btn btn-primary btn-block" id="medic-heal" data-perm="use_medic"><i class="fa-solid fa-kit-medical"></i> Heal</button>
            </div>
            <div class="medic-card revive">
                <div class="medic-card-ic"><i class="fa-solid fa-staff-snake"></i></div>
                <h3>Revive</h3>
                <p>Bring a downed gang member back into the fight.</p>
                <div class="medic-cost">${fmtMoney(m.reviveCost || 0)}</div>
                <button class="btn btn-danger btn-block" id="medic-revive" data-perm="use_medic"><i class="fa-solid fa-heart-circle-bolt"></i> Revive</button>
            </div>
        </div>`;
    applyPermGates(root);
}
document.addEventListener('click', e => {
    if (e.target.closest('#medic-heal')) {
        call('medic:heal').then(r => { if (!r.ok) return toast(errMsg(r.error), 'error'); toast('Member healed.', 'success'); });
    }
    if (e.target.closest('#medic-revive')) {
        call('medic:revive').then(r => { if (!r.ok) return toast(errMsg(r.error), 'error'); toast('Member revived.', 'success'); });
    }
});

/* ============================================================
   LOGS
   ============================================================ */
const LOG_ICONS = {
    members: 'users', ranks: 'layer-group', vault: 'vault', turf: 'map-location-dot',
    graffiti: 'spray-can', scout: 'binoculars', raid: 'fire', upgrades: 'arrow-up-right-dots',
    garage: 'warehouse', medic: 'kit-medical', gang: 'flag', admin: 'shield-halved', tasks: 'list-check',
};
const LOG_LABELS = {
    invite: 'Member invited', kick: 'Member removed', promote: 'Promoted', demote: 'Demoted',
    transfer_lead: 'Leadership transferred', setgang: 'Gang set',
    rank_edit: 'Rank edited', rank_delete: 'Rank deleted',
    deposit_money: 'Deposit', withdraw_money: 'Withdrawal', open_safe: 'Safe opened',
    zone_save: 'Territory saved', force: 'Territory forced',
    store: 'Vehicle stored', take: 'Vehicle taken', remove: 'Vehicle removed',
    buy: 'Upgrade bought', heal: 'Member healed', revive: 'Member revived',
    create: 'Gang created', edit: 'Gang edited', delete: 'Gang deleted', reset: 'Gang reset',
    start: 'Raid started', success: 'Success', failed: 'Failed', scout: 'Scout',
};
function prettify(s) { s = String(s == null ? 'Action' : s).replace(/_/g, ' ').trim(); return s ? s.charAt(0).toUpperCase() + s.slice(1) : 'Action'; }
function refreshLogs() {
    call('logs:list', { category: state.logsCategory, limit: 200 }).then(r => {
        if (!r.ok) {
            const root = $('#logs-list');
            if (root) root.innerHTML = `<div class="pane-empty"><span>${escapeHTML(errMsg(r.error))}</span></div>`;
            state.logs = []; renderActivity();
            return;
        }
        state.logs = r.data || [];
        setText('#logs-count', `${state.logs.length} entries`);
        renderLogs();
        renderActivity();
    });
}
function renderLogs() {
    const root = $('#logs-list'); if (!root) return;
    if (!state.logs.length) { root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-clock-rotate-left"></i></span><span>No activity logged.</span></div>`; return; }
    root.innerHTML = state.logs.map(l => {
        const icon = LOG_ICONS[l.category] || 'circle-info';
        const label = LOG_LABELS[l.action] || prettify(l.action || l.category);
        return `
            <div class="log-row">
                <div class="log-ic"><i class="fa-solid fa-${icon}"></i></div>
                <div class="log-body">
                    <div class="log-title">${escapeHTML(label)}${l.target ? ` <span class="muted">→ ${escapeHTML(String(l.target).slice(0, 28))}</span>` : ''}</div>
                    <div class="log-sub">${escapeHTML(l.actor || 'System')} · ${new Date((l.created_at || 0) * 1000).toLocaleString()}</div>
                </div>
                <div class="log-amount">${l.amount ? fmtMoney(l.amount) : ''}</div>
            </div>`;
    }).join('');
}
function renderActivity() {
    const root = $('#ov-activity'); if (!root) return;
    const rows = (state.logs || []).slice(0, 14);
    setText('#ov-activity-count', rows.length);
    if (!rows.length) { root.innerHTML = `<span class="ticker-empty">No recent activity.</span>`; return; }
    root.innerHTML = rows.map(l => {
        const icon = LOG_ICONS[l.category] || 'circle-info';
        const label = LOG_LABELS[l.action] || prettify(l.action || l.category);
        return `<span class="ticker-item"><i class="fa-solid fa-${icon}"></i> <strong>${escapeHTML(label)}</strong> · ${escapeHTML(ago(l.created_at))}</span>`;
    }).join('');
}
on($('#logs-filter'), 'click', e => {
    const b = e.target.closest('.hf-pill'); if (!b) return;
    $$('#logs-filter .hf-pill').forEach(x => x.classList.remove('active'));
    b.classList.add('active');
    state.logsCategory = b.dataset.kind || '';
    refreshLogs();
});

/* ============================================================
   ADMIN — gang list management
   ============================================================ */
function refreshAdmin() {
    call('gang:listAll').then(r => {
        const root = $('#admin-list');
        if (!r.ok) { if (root) root.innerHTML = `<div class="pane-empty"><span>${escapeHTML(errMsg(r.error))}</span></div>`; return; }
        state.gangs = r.data || [];
        renderAdmin();
    });
}
function renderAdmin() {
    const root = $('#admin-list'); if (!root) return;
    const query = ($('#admin-search')?.value || '').toLowerCase().trim();
    const rows = state.gangs.filter(g => !query || (g.label || g.gang || '').toLowerCase().includes(query) || (g.gang || '').toLowerCase().includes(query));
    setText('#admin-stats', `${state.gangs.length} gang${state.gangs.length === 1 ? '' : 's'} on the server`);
    if (!rows.length) {
        root.innerHTML = `<div class="pane-empty"><span class="pane-empty-ic"><i class="fa-solid fa-flag"></i></span><span>No gangs yet. Create one to get started.</span></div>`;
        return;
    }
    root.innerHTML = rows.map(g => {
        const color = g.color || '#1F5EFF';
        return `
        <div class="admin-card" data-gang="${escapeAttr(g.gang)}" style="--gang-color:${color}">
            <div class="admin-top">
                <div class="admin-logo">${escapeHTML(initials(g.label || g.gang))}</div>
                <div class="admin-meta">
                    <div class="admin-name">${escapeHTML(g.label || g.gang)}</div>
                    <div class="admin-sub">
                        <span>Lv <strong>${g.level || 1}</strong></span>
                        <span><strong>${g.members || 0}</strong>/${g.maxMembers || 0} members</span>
                        <span><i class="fa-solid fa-fire-flame-curved" style="color:var(--brand-300)"></i> <strong>${(g.rep || 0).toLocaleString()}</strong> REP</span>
                        <span class="mono">${escapeHTML(g.gang)}</span>
                    </div>
                </div>
            </div>
            <div class="admin-actions">
                <button class="btn btn-ghost btn-sm" data-gact="manage"><i class="fa-solid fa-users-gear"></i> Manage</button>
                <button class="btn btn-ghost btn-sm" data-gact="rep"><i class="fa-solid fa-fire-flame-curved"></i> REP</button>
                <button class="btn btn-ghost btn-sm" data-gact="graffiti"><i class="fa-solid fa-spray-can"></i> Graffiti</button>
                <button class="btn btn-ghost btn-sm" data-gact="edit"><i class="fa-solid fa-pen"></i> Edit</button>
                <button class="btn btn-ghost btn-sm" data-gact="reset"><i class="fa-solid fa-rotate-left"></i> Reset</button>
                <button class="btn btn-ghost btn-sm" data-gact="delete"><i class="fa-solid fa-trash-can"></i> Delete</button>
            </div>
        </div>`;
    }).join('');
}
// Remove a single graffiti from the manager dialog.
document.addEventListener('click', e => {
    const del = e.target.closest('[data-graf-del]'); if (!del) return;
    const id = Number(del.dataset.grafDel); if (!id) return;
    call('graffiti:adminRemove', { id }).then(r => {
        if (!r.ok) return toast(errMsg(r.error), 'error');
        const row = del.closest('.gm-graf-row'); if (row) row.remove();
        toast('Graffiti removed.', 'success');
    });
});
on($('#admin-search'), 'input', renderAdmin);
on($('#admin-open-creator'), 'click', () => { post('creator_open_request'); toast('Opening the in-world creator…', 'info'); });
on($('#admin-create'), 'click', () => {
    inputDlg({
        title: 'Create gang',
        fields: [
            { type: 'text',  label: 'Name (id, lowercase, no spaces)', key: 'name' },
            { type: 'text',  label: 'Display label', key: 'label' },
            { type: 'color', label: 'Colour', key: 'color', value: '#1F5EFF' },
        ],
        onSubmit(v) {
            const name = (v.name || '').trim(); if (!name) return toast('Name is required', 'error');
            call('gang:create', { name, label: (v.label || '').trim(), color: v.color || '#1F5EFF' }).then(r => {
                if (!r.ok) return toast(errMsg(r.error), 'error');
                toast(`Gang "${r.data?.label || name}" created.`, 'success'); refreshAdmin();
            });
        }
    });
});
document.addEventListener('click', e => {
    const card = e.target.closest('.admin-card[data-gang]'); if (!card) return;
    const act = e.target.closest('[data-gact]'); if (!act) return;
    const gang = card.dataset.gang;
    const g = state.gangs.find(x => x.gang === gang);
    const action = act.dataset.gact;
    if (action === 'manage') {
        // Point the member/rank/etc callbacks at this gang and open the members tab.
        state.adminGang = gang;
        toast(`Managing ${g?.label || gang}.`, 'info');
        setTab('members'); refreshMembers();
        return;
    }
    if (action === 'rep') {
        inputDlg({
            title: `Reputation · ${g?.label || gang}`,
            html: `<div class="muted" style="margin-bottom:8px">Current: <strong>${(g?.rep || 0).toLocaleString()}</strong> REP. Use a negative amount to remove.</div>`,
            fields: [{ type: 'number', label: 'Amount (+/-)', key: 'amount', value: 100 }],
            onSubmit(v) {
                const amount = Number(v.amount) || 0; if (!amount) return toast('Enter an amount.', 'error');
                call('admin:giveRep', { gang, amount }).then(r => {
                    if (!r.ok) return toast(errMsg(r.error), 'error');
                    toast(`REP updated → ${(r.data?.rep || 0).toLocaleString()}.`, 'success'); refreshAdmin();
                });
            }
        });
        return;
    }
    if (action === 'graffiti') {
        call('graffiti:listGang', { gang }).then(r => {
            if (!r.ok) return toast(errMsg(r.error), 'error');
            const list = r.data || [];
            const rows = list.length ? list.map(t => `
                <div class="gm-graf-row" data-graf="${t.id}">
                    <span class="gm-graf-ic"><i class="fa-solid fa-${t.kind === 'image' ? 'image' : 'font'}"></i></span>
                    <span class="gm-graf-txt">${escapeHTML(t.text || t.image || t.url || '—')}</span>
                    <span class="gm-graf-loc mono">${Math.round(t.x)}, ${Math.round(t.y)}</span>
                    <button class="btn btn-ghost btn-sm gm-graf-del" data-graf-del="${t.id}" title="Remove this graffiti"><i class="fa-solid fa-trash"></i></button>
                </div>`).join('') : '<div class="muted" style="padding:10px">No graffiti for this gang.</div>';
            inputDlg({
                title: `Graffiti · ${g?.label || gang} (${list.length})`,
                html: `<div class="gm-graf-list">${rows}</div>`,
                okLabel: 'Close', single: true,
            });
        });
        return;
    }
    if (action === 'edit') {
        inputDlg({
            title: `Edit ${g?.label || gang}`,
            fields: [
                { type: 'text',   label: 'Display label', key: 'label', value: g?.label || '' },
                { type: 'color',  label: 'Colour', key: 'color', value: g?.color || '#1F5EFF' },
                { type: 'number', label: 'Max members', key: 'maxMembers', value: g?.maxMembers || 12 },
                { type: 'number', label: 'Level', key: 'level', value: g?.level || 1 },
            ],
            onSubmit(v) {
                call('gang:edit', { gang, label: v.label, color: v.color, maxMembers: Number(v.maxMembers) || 12, level: Number(v.level) || 1 }).then(r => {
                    if (!r.ok) return toast(errMsg(r.error), 'error');
                    toast('Gang updated.', 'success'); refreshAdmin();
                });
            }
        });
        return;
    }
    if (action === 'reset') {
        confirmDlg(`Reset ${g?.label || gang}'s level, XP and upgrades?`, () => {
            call('gang:reset', { gang }).then(r => { if (!r.ok) return toast(errMsg(r.error), 'error'); toast('Gang reset.', 'success'); refreshAdmin(); });
        });
        return;
    }
    if (action === 'delete') {
        confirmDlg(`Delete ${g?.label || gang}? This removes ALL its members, ranks, vault, garage and progress. This cannot be undone.`, () => {
            call('gang:delete', { gang }).then(r => { if (!r.ok) return toast(errMsg(r.error), 'error'); toast('Gang deleted.', 'success'); if (state.adminGang === gang) state.adminGang = null; refreshAdmin(); });
        });
    }
});

/* ============================================================
   QUICK ACTIONS (overview)
   ============================================================ */
document.addEventListener('click', e => {
    const q = e.target.closest('[data-quick]'); if (!q) return;
    const act = q.dataset.quick;
    if (act === 'invite') { setTab('members'); setTimeout(() => $('#mem-invite-btn')?.click(), 80); }
    if (act === 'vault')  setTab('vault');
    if (act === 'turf')   setTab('turf');
    if (act === 'ops')    setTab('operations');
});

/* ============================================================
   MAP — leaflet (GTA atlas tiles)
   ============================================================ */
const CENTER_X = 117.3, CENTER_Y = 172.8, SCALE_X = 0.02072, SCALE_Y = 0.0205;
const MAP_TILE = 'https://www.gtamap.xyz/mapStyles/styleAtlas/{z}/{x}/{y}.jpg';

function ensureMap() {
    if (state.mapBuilt) return state.map;
    const target = $('#gang-map');
    if (!target || typeof L === 'undefined') return null;
    const CRS = L.extend({}, L.CRS.Simple, {
        projection: L.Projection.LonLat,
        scale: z => Math.pow(2, z),
        zoom : s => Math.log(s) / Math.LN2,
        distance: (a, b) => { const dx = b.lng - a.lng, dy = b.lat - a.lat; return Math.sqrt(dx * dx + dy * dy); },
        transformation: new L.Transformation(SCALE_X, CENTER_X, -SCALE_Y, CENTER_Y),
        infinite: true,
    });
    const map = L.map('gang-map', {
        crs: CRS, minZoom: 2, maxZoom: 5, zoom: 3, center: [0, 0],
        zoomControl: true, preferCanvas: true,
        attributionControl: false,
        maxBounds: [[8000.0, -5500.0], [-8000.0, 5500.0]],
    });
    L.tileLayer(MAP_TILE, { minZoom: 2, maxZoom: 5, noWrap: true }).addTo(map);
    state.map = map;
    state.mapBuilt = true;
    setTimeout(() => { try { map.invalidateSize(); } catch (_) {} }, 100);
    return map;
}

function renderMapMarkers() {
    const map = ensureMap(); if (!map) return;
    state.playerMarkers.forEach(m => map.removeLayer(m));
    state.playerMarkers = [];

    const gangColor = state.gang?.color || '#1F5EFF';
    // Member blips come from the live players list, matched to this gang by name.
    let count = 0;
    (state.players || []).forEach(p => {
        if (!p.coords) return;
        const isMember = state.gang && p.gang === state.gang.name;
        if (!isMember) return;
        const isMine = state.you && p.id === state.you.src;
        const blipHtml = isMine
            ? `<div class="boss-blip boss-blip-self" style="--blip:${gangColor}"></div>`
            : `<div class="boss-blip" style="--blip:${gangColor}"></div>`;
        const marker = L.marker([p.coords.y, p.coords.x], {
            icon: L.divIcon({ className: 'boss-blip-icon', html: blipHtml, iconSize: [16, 16] }),
        });
        marker.bindPopup(`
            <div class="player-popup">
                <div class="pp-head">
                    <strong>${escapeHTML(p.name)}</strong>
                    <span class="pp-id">ID ${p.id}</span>
                </div>
                <div class="pp-meta">${escapeHTML(p.gradeLabel || ('Grade ' + (p.grade || 0)))}</div>
                ${p.vehicle ? `<div class="pp-line"><i class="fa-solid fa-car"></i> ${escapeHTML(p.vehicle)}</div>` : ''}
            </div>`, { maxWidth: 240 });
        marker.addTo(map);
        state.playerMarkers.push(marker);
        count++;
    });
    setText('#ov-map-results', count);
}

// Pull players for the map (members only need coords). Refresh on overview.
function refreshPlayersForMap() {
    call('players:list').then(r => {
        if (!r.ok) return;
        state.players = r.data || [];
        renderMapMarkers();
    });
}
on($('#ov-map-recenter'), 'click', () => {
    const map = ensureMap(); if (!map) return;
    const me = (state.players || []).find(p => state.you && p.id === state.you.src);
    if (me?.coords) map.setView([me.coords.y, me.coords.x], 4, { animate: true });
    else map.setView([0, 0], 3);
});

/* ============================================================
   AIRDROP — navbar countdown + live-map candidate zones
   ============================================================ */
function airdropOn() { return !!(state.config?.features?.airdrop); }

function fmtAirdropTime(s) {
    s = Math.max(0, Math.floor(Number(s) || 0));
    if (s >= 3600) { const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60); return `${h}h ${m}m`; }
    const m = Math.floor(s / 60), ss = s % 60;
    return `${String(m).padStart(2, '0')}:${String(ss).padStart(2, '0')}`;
}

function renderAirdropPill() {
    const pill = $('#bid-airdrop-pill'); if (!pill) return;
    if (!airdropOn()) { pill.hidden = true; return; }
    pill.hidden = false;
    const el = $('#bid-airdrop'); if (!el) return;
    if (!state.airdrop.enabled) { el.textContent = 'Off'; el.classList.add('muted'); return; }
    el.classList.remove('muted');
    el.textContent = (state.airdrop.next != null) ? fmtAirdropTime(state.airdrop.next) : '--:--';
}

function pollAirdrop() {
    if (!airdropOn()) { renderAirdropPill(); return; }
    call('airdrop:state').then(r => {
        if (!r.ok || !r.data) return;
        state.airdrop.enabled = !!r.data.enabled;
        state.airdrop.next = (r.data.nextInSeconds != null) ? r.data.nextInSeconds : null;
        renderAirdropPill();
    });
}

function drawAirdropZones() {
    const map = state.map; if (!map || typeof L === 'undefined') return;
    if (state.airdrop.layer) { try { map.removeLayer(state.airdrop.layer); } catch (e) {} }
    const grp = L.layerGroup();
    (state.airdrop.zones || []).forEach(z => {
        const color = z.enabled ? '#34C77B' : '#7C7C82';
        const circle = L.circle([z.y, z.x], {
            radius: z.radius || 60, color, weight: 2,
            fillColor: color, fillOpacity: z.enabled ? 0.16 : 0.05, dashArray: z.enabled ? null : '5',
        });
        circle.bindTooltip(`${z.label} — airdrops ${z.enabled ? 'ON' : 'OFF'}${state.airdrop.canEdit ? ' · click to toggle' : ''}`, { direction: 'top', sticky: true });
        if (state.airdrop.canEdit) {
            circle.on('click', () => {
                call('airdrop:toggleZone', { id: z.id, enabled: !z.enabled }).then(rr => {
                    if (!rr.ok) return toast(errMsg(rr.error), 'error');
                    z.enabled = !!rr.data.enabled;
                    drawAirdropZones();
                    toast(`${z.label}: airdrops ${z.enabled ? 'enabled' : 'disabled'}`, z.enabled ? 'success' : 'info');
                });
            });
        }
        grp.addLayer(circle);
    });
    state.airdrop.layer = grp;
    if (state.airdrop.shown) grp.addTo(map);
}

function renderAirdropZones() {
    if (!airdropOn()) return;
    const map = ensureMap(); if (!map) return;
    call('airdrop:zones').then(r => {
        if (!r.ok || !r.data) return;
        state.airdrop.zones  = r.data.zones || [];
        state.airdrop.canEdit = !!r.data.canEdit;
        drawAirdropZones();
    });
    // reflect feature availability on the toggle button
    const btn = $('#ov-map-airdrop'); if (btn) btn.hidden = false;
}

on($('#ov-map-airdrop'), 'click', () => {
    const map = ensureMap(); if (!map) return;
    state.airdrop.shown = !state.airdrop.shown;
    $('#ov-map-airdrop')?.classList.toggle('active', state.airdrop.shown);
    if (!state.airdrop.layer) { renderAirdropZones(); }
    else if (state.airdrop.shown) state.airdrop.layer.addTo(map);
    else { try { map.removeLayer(state.airdrop.layer); } catch (e) {} }
    // drop zones are server-wide — frame them all so they're actually visible
    if (state.airdrop.shown && (state.airdrop.zones || []).length) {
        try {
            const b = L.latLngBounds((state.airdrop.zones || []).map(z => [z.y, z.x]));
            map.fitBounds(b.pad(0.25), { animate: false, maxZoom: 4 });
        } catch (e) {}
    }
});
// feed-row click → recenter on that member
on($('#online-feed-list'), 'click', e => {
    const row = e.target.closest('.feed-row'); if (!row) return;
    const src = Number(row.dataset.src); if (!src) return;
    const p = (state.players || []).find(x => x.id === src);
    if (p?.coords) { ensureMap(); const map = state.map; if (map) map.setView([p.coords.y, p.coords.x], 5, { animate: true }); }
});

/* ============================================================
   THEME / APPEARANCE — colour helpers (verbatim from bossmenu)
   ============================================================ */
function _hexToRgb(hex){const h=(hex||'').replace('#','');const n=h.length===3?h.split('').map(c=>c+c).join(''):h;return{r:parseInt(n.slice(0,2),16)||0,g:parseInt(n.slice(2,4),16)||0,b:parseInt(n.slice(4,6),16)||0};}
function _rgbToHsl({r,g,b}){r/=255;g/=255;b/=255;const mx=Math.max(r,g,b),mn=Math.min(r,g,b);let h,s,l=(mx+mn)/2;if(mx===mn){h=s=0;}else{const d=mx-mn;s=l>.5?d/(2-mx-mn):d/(mx+mn);switch(mx){case r:h=(g-b)/d+(g<b?6:0);break;case g:h=(b-r)/d+2;break;case b:h=(r-g)/d+4;break;}h/=6;}return{h:h*360,s:s*100,l:l*100};}
function _hslToHex(h,s,l){h/=360;s/=100;l/=100;const f=(p,q,t)=>{if(t<0)t+=1;if(t>1)t-=1;if(t<1/6)return p+(q-p)*6*t;if(t<1/2)return q;if(t<2/3)return p+(q-p)*(2/3-t)*6;return p;};let r,g,b;if(s===0){r=g=b=l;}else{const q=l<.5?l*(1+s):l+s-l*s;const p=2*l-q;r=f(p,q,h+1/3);g=f(p,q,h);b=f(p,q,h-1/3);}const to=x=>Math.round(x*255).toString(16).padStart(2,'0');return'#'+to(r)+to(g)+to(b);}
function _hexToRgba(hex,a){const{r,g,b}=_hexToRgb(hex);return`rgba(${r},${g},${b},${a})`;}

function applyBrandRamp(hex){
    if(!hex)return;
    const root=document.documentElement.style;
    const{h,s}=_rgbToHsl(_hexToRgb(hex));
    root.setProperty('--brand-500',hex);
    root.setProperty('--brand-600',_hslToHex(h,s,47));
    root.setProperty('--brand-400',_hslToHex(h,s,65));
    root.setProperty('--brand-300',_hslToHex(h,s,75));
    [['a06',.06],['a10',.10],['a15',.15],['a25',.25],['a40',.40]]
        .forEach(([k,a])=>root.setProperty('--brand-'+k,_hexToRgba(hex,a)));
}
function applyBackgroundRamp(hex){
    if(!hex)return;
    const root=document.documentElement.style;
    const{h,s,l}=_rgbToHsl(_hexToRgb(hex));
    const clamp=(v,lo,hi)=>Math.max(lo,Math.min(hi,v));
    const base=clamp(l,3.5,12), sat=Math.min(s,50);
    const set=(name,dl)=>root.setProperty(name,_hslToHex(h,sat,clamp(base+dl,0,100)));
    set('--surface-0',-3.5);set('--surface-1',0);set('--surface-2',3);
    set('--surface-3',7);set('--surface-4',11);set('--surface-5',15);
    set('--line-1',5);set('--line-2',9.5);set('--line-3',15.5);set('--line-4',23);
    set('--bg',-3.5);set('--bg-sidebar',0);set('--bg-card',3);set('--bg-raised',7);
    set('--border',5);set('--border-hi',9.5);
}

const PRESET_COLORS = ['#1F5EFF','#4E9CE5','#34C77B','#E5A93C','#E5564B','#A66DF0','#F0B429','#0BA5A4'];
const PRESET_BGS    = ['#131314','#0F1218','#101616','#15110F','#141019','#0E1614','#181613','#1A1A1D'];

function primeColorPresets() {
    const root = $('#theme-presets');
    if (root) {
        root.innerHTML = PRESET_COLORS.map(c => `<button class="color-preset" data-c="${c}" style="background:${c}"></button>`).join('');
        const active = localStorage.getItem('gang-theme-color') || serverThemeDefault('brand', '#1F5EFF');
        const inp = $('#theme-color-input'); if (inp) inp.value = active;
        setText('#theme-color-hex', active.toUpperCase());
        $$('#theme-presets .color-preset').forEach(b => b.classList.toggle('active', b.dataset.c.toLowerCase() === active.toLowerCase()));
    }
    const bgRoot = $('#bg-presets');
    if (bgRoot) {
        bgRoot.innerHTML = PRESET_BGS.map(c => `<button class="color-preset" data-bg="${c}" style="background:${c}"></button>`).join('');
        const activeBg = localStorage.getItem('gang-theme-bg') || serverThemeDefault('bg', '#131314');
        const bi = $('#theme-bg-input'); if (bi) bi.value = activeBg;
        setText('#theme-bg-hex', activeBg.toUpperCase());
        $$('#bg-presets .color-preset').forEach(b => b.classList.toggle('active', b.dataset.bg.toLowerCase() === activeBg.toLowerCase()));
    }
    const size = localStorage.getItem('gang-theme-size') || 'm';
    $$('#size-grid .size-btn').forEach(b => b.classList.toggle('active', b.dataset.size === size));
}

function applyTheme(hex) { if (!hex) return; applyBrandRamp(hex); setText('#theme-color-hex', hex.toUpperCase()); }
function applyBackground(hex) { if (!hex) return; applyBackgroundRamp(hex); setText('#theme-bg-hex', hex.toUpperCase()); }
function applySize(size) {
    const shell = $('.cc-shell'); if (!shell) return;
    shell.classList.remove('size-s','size-m','size-l','size-full');
    shell.classList.add('size-' + size);
}
function applyRailCollapsed(collapsed) {
    const shell = $('.cc-shell'); if (!shell) return;
    shell.classList.toggle('rail-collapsed', !!collapsed);
}
on($('#rail-collapse'), 'click', () => {
    const shell = $('.cc-shell'); if (!shell) return;
    const next = !shell.classList.contains('rail-collapsed');
    applyRailCollapsed(next);
    localStorage.setItem('gang-rail-collapsed', next ? '1' : '0');
});

function applyOpacity(pct) {
    pct = Math.max(55, Math.min(100, Math.round(Number(pct) || 100)));
    document.documentElement.style.setProperty('--ui-opacity', (pct / 100).toFixed(2));
    setText('#theme-opacity-val', pct + '%');
    const sl = $('#theme-opacity'); if (sl && Number(sl.value) !== pct) sl.value = pct;
}
on($('#theme-opacity'), 'input', e => {
    applyOpacity(e.target.value);
    localStorage.setItem('gang-theme-opacity', String(Math.round(Number(e.target.value) || 100)));
});

on($('#theme-color-input'), 'input', e => {
    applyTheme(e.target.value);
    localStorage.setItem('gang-theme-color', e.target.value);
    $$('#theme-presets .color-preset').forEach(b => b.classList.toggle('active', b.dataset.c.toLowerCase() === e.target.value.toLowerCase()));
});
on($('#theme-bg-input'), 'input', e => {
    applyBackground(e.target.value);
    localStorage.setItem('gang-theme-bg', e.target.value);
    $$('#bg-presets .color-preset').forEach(b => b.classList.toggle('active', b.dataset.bg.toLowerCase() === e.target.value.toLowerCase()));
});
document.addEventListener('click', e => {
    const c = e.target.closest('#theme-presets .color-preset');
    if (c) {
        applyTheme(c.dataset.c);
        localStorage.setItem('gang-theme-color', c.dataset.c);
        const inp = $('#theme-color-input'); if (inp) inp.value = c.dataset.c;
        $$('#theme-presets .color-preset').forEach(b => b.classList.toggle('active', b === c));
        return;
    }
    const bg = e.target.closest('#bg-presets .color-preset');
    if (bg) {
        applyBackground(bg.dataset.bg);
        localStorage.setItem('gang-theme-bg', bg.dataset.bg);
        const bi = $('#theme-bg-input'); if (bi) bi.value = bg.dataset.bg;
        $$('#bg-presets .color-preset').forEach(b => b.classList.toggle('active', b === bg));
        return;
    }
    const s = e.target.closest('#size-grid .size-btn');
    if (s) {
        applySize(s.dataset.size);
        localStorage.setItem('gang-theme-size', s.dataset.size);
        $$('#size-grid .size-btn').forEach(b => b.classList.toggle('active', b === s));
    }
});
on($('#theme-reset-personal'), 'click', () => {
    localStorage.removeItem('gang-theme-color');
    localStorage.removeItem('gang-theme-bg');
    localStorage.removeItem('gang-theme-size');
    localStorage.removeItem('gang-theme-opacity');
    applyTheme(serverThemeDefault('brand', '#1F5EFF'));
    applyBackground(serverThemeDefault('bg', '#131314'));
    applySize('m'); applyOpacity(100);
    primeColorPresets();
});
on($('#theme-save-server'), 'click', () => {
    const brand = localStorage.getItem('gang-theme-color') || $('#theme-color-input')?.value || serverThemeDefault('brand', '#1F5EFF');
    const bg = localStorage.getItem('gang-theme-bg') || $('#theme-bg-input')?.value || serverThemeDefault('bg', '#131314');
    post('theme_save', { brand, bg }).then(r => {
        if (r?.ok) { state.theme = { brand, bg }; toast('Saved as server default.', 'success'); }
        else toast('Failed to save default.', 'error');
    });
});
on($('#settings-refresh'), 'click', () => { refreshActive(); toast('Refreshed', 'success'); });

/* ============================================================
   THEME BOOT — apply saved/default theme the moment NUI loads
   ============================================================ */
function bootTheme(serverTheme) {
    if (serverTheme && typeof serverTheme === 'object') {
        state.config = state.config || {};
        state.config.theme = Object.assign({}, state.config.theme || {}, serverTheme);
    }
    applyTheme(localStorage.getItem('gang-theme-color') || serverThemeDefault('brand', '#1F5EFF'));
    applyBackground(localStorage.getItem('gang-theme-bg') || serverThemeDefault('bg', '#131314'));
    applySize(localStorage.getItem('gang-theme-size') || 'm');
    applyOpacity(localStorage.getItem('gang-theme-opacity') || 100);
}
bootTheme();

/* ============================================================
   CONFIRM + INPUT DIALOGS
   ============================================================ */
function confirmDlg(message, onYes) {
    setText('#alert-title', 'Confirm');
    const c = $('#alert-content'); if (c) c.textContent = message;
    const overlay = $('#alert-overlay'); if (overlay) overlay.hidden = false;
    function close() { if (overlay) overlay.hidden = true; document.removeEventListener('click', clickHandler); }
    function clickHandler(e) {
        const a = e.target.closest('[data-action]')?.dataset.action;
        if (a === 'alert-yes') { close(); onYes && onYes(); }
        if (a === 'alert-no')  close();
    }
    document.addEventListener('click', clickHandler);
}
function inputDlg(opts) {
    setText('#input-title', opts.title || 'Input');
    const fields = $('#input-fields');
    const htmlBlock = opts.html ? `<div class="form-row" style="margin-bottom:0">${opts.html}</div>` : '';
    if (fields) fields.innerHTML = htmlBlock + (opts.fields || []).map(f => {
        const key = escapeAttr(f.key);
        const value = String(f.value ?? '');
        let control;
        if (f.type === 'select') {
            control = `<select class="apex-input" data-key="${key}">
                ${(f.options || []).map(o => `<option value="${escapeAttr(o.value)}" ${String(o.value) === value ? 'selected' : ''}>${escapeHTML(o.label || o.value)}</option>`).join('')}
            </select>`;
        } else if (f.type === 'color') {
            control = `<div class="color-pick"><label class="color-swatch-big"><input type="color" data-key="${key}" value="${escapeAttr(value || '#1F5EFF')}"></label><code class="iban-chip">${escapeHTML((value || '#1F5EFF').toUpperCase())}</code></div>`;
        } else {
            control = `<input class="apex-input" type="${f.type || 'text'}" data-key="${key}" value="${escapeAttr(value)}">`;
        }
        return `<div class="form-row"><label>${escapeHTML(f.label || '')}</label>${control}</div>`;
    }).join('');
    // submit button label + single mode (info dialog)
    const submitBtn = $('#input-overlay [data-action="input-submit"]');
    const cancelBtn = $('#input-overlay .input-actions [data-action="input-cancel"]');
    if (submitBtn) submitBtn.textContent = opts.okLabel || 'Confirm';
    if (cancelBtn) cancelBtn.style.display = opts.single ? 'none' : '';
    const overlay = $('#input-overlay'); if (overlay) overlay.hidden = false;
    function close() {
        if (overlay) overlay.hidden = true;
        if (cancelBtn) cancelBtn.style.display = '';
        document.removeEventListener('click', clickHandler);
    }
    function clickHandler(e) {
        const a = e.target.closest('[data-action]')?.dataset.action;
        if (a === 'input-submit') {
            const v = {};
            $$('#input-fields [data-key]').forEach(i => v[i.dataset.key] = i.value);
            close(); opts.onSubmit && opts.onSubmit(v);
        }
        if (a === 'input-cancel') close();
    }
    document.addEventListener('click', clickHandler);
}
// live color hex chip in dialogs
document.addEventListener('input', e => {
    const ci = e.target.closest('#input-fields input[type="color"]');
    if (ci) { const chip = ci.closest('.color-pick')?.querySelector('.iban-chip'); if (chip) chip.textContent = (ci.value || '').toUpperCase(); }
});

/* ============================================================
   NUI MESSAGE ROUTER
   ============================================================ */
window.addEventListener('message', e => {
    const m = e.data || {};
    if (m.action === 'themeBoot') { bootTheme(m.data && m.data.theme); return; }
    if (m.action === 'open')  { openShell(m.data || {}); return; }
    if (m.action === 'close') { closeShell(); return; }
    if (m.action === 'notify') { localToast(m.data?.msg || '', m.data?.kind || 'info', m.data?.title || '', m.data?.duration || 4500); return; }

    if (m.action === 'worldPrompt') {
        const el = $('#world-prompt'); if (!el) return;
        if (m.data?.show) { setText('#world-prompt-label', m.data.label || ''); el.hidden = false; }
        else el.hidden = true;
        return;
    }
    if (m.action === 'show3DIcon') {
        const el = $('#world-3d-icon'); if (!el) return;
        const d = m.data || {};
        const x = (Number(d.x) || 0) * window.innerWidth;
        const y = (Number(d.y) || 0) * window.innerHeight;
        el.style.left = x + 'px';
        el.style.top  = y + 'px';
        el.style.transform = 'translate(-50%, -50%)';
        const ic = $('#w3d-icon'); if (ic) ic.className = 'fa-solid fa-' + (d.icon || 'skull');
        const lbl = $('#w3d-label'); if (lbl) lbl.textContent = d.label || 'Open';
        const keyEl = document.querySelector('.w3d-key'); if (keyEl) keyEl.textContent = d.key || 'E';
        el.removeAttribute('hidden'); el.style.display = '';
        return;
    }
    if (m.action === 'hide3DIcon') {
        const el = $('#world-3d-icon'); if (el) { el.setAttribute('hidden', ''); el.style.display = 'none'; }
        return;
    }

    // ─── Live sync ───
    if (m.action === 'gangSync') {
        if (m.data?.gang) { state.gang = m.data.gang; renderGangHeader(); }
        return;
    }
    if (m.action === 'membersSync') {
        if (state.activeTab === 'members' || state.activeTab === 'overview') refreshMembers();
        return;
    }
    if (m.action === 'vaultRefresh') {
        if (state.activeTab === 'vault') refreshVault();
        return;
    }
    if (m.action === 'tasksRefresh') {
        if (state.activeTab === 'tasks') refreshTasks();
        return;
    }

    // ─── Garage (dedicated overlay) ───
    if (m.action === 'openGarage') { Garage.open(m.data || {}); return; }
    if (m.action === 'garageSync') { Garage.sync(m.data || {}); return; }

    // ─── Graffiti selector (dedicated overlay, spray-can item) ───
    if (m.action === 'graffitiOpen')  { Graffiti.open(m.data || m.payload || {}); return; }
    if (m.action === 'graffitiClose') { Graffiti.close(); return; }
    if (m.action === 'graffitiProgress')    { GraffitiProgress.tick(m.data || {}); return; }
    if (m.action === 'graffitiProgressEnd') { GraffitiProgress.end(); return; }
    if (m.action === 'graffitiControls')    { GraffitiControls.tick(m.data || {}); return; }
    if (m.action === 'graffitiControlsEnd') { GraffitiControls.end(); return; }

    // ─── Medic ───
    if (m.action === 'openMedic') { state.medic = m.data || {}; setTab('medic'); renderMedic(); return; }

    // ─── Raid banners ───
    if (m.action === 'raidBegin') { startRaidBanner(m.data?.label, m.data?.duration); return; }
    if (m.action === 'raidEnd')   { endRaidBanner(m.data?.success, m.data?.loot); return; }
    if (m.action === 'opHud')     { OpHUD.show(m.data || {}); return; }
    if (m.action === 'opHudHide') { OpHUD.hide(); return; }
    if (m.action === 'missionHud')     { MissionHUD.show(m.data || {}); return; }
    if (m.action === 'missionHudHide') { MissionHUD.hide(); return; }
    if (m.action === 'scoutResult') { const d = m.data || {}; showIntel(d.target, d.intel || {}); return; }

    // ─── Creator (node-graph editor) ───
    if (m.action === 'creator_open')  { Creator.open(m.data || m.payload || {}); return; }
    if (m.action === 'creator_close') { Creator.close(); return; }
    if (m.action === 'editor_minimize') { const el = $('#creator-overlay'); if (el) el.style.visibility = 'hidden'; return; }
    if (m.action === 'editor_restore')  { Creator.restore(m); return; }
    if (m.action === 'placement_hud_show') { PlacementHUD.show(m.data || m.payload || {}); return; }
    if (m.action === 'placement_hud_hide') { PlacementHUD.hide(); return; }
    // greenscreen backdrop for in-game UI recording (/ganggreen)
    if (m.action === 'ganggreen') { document.body.classList.toggle('ganggreen', !!(m.data && m.data.on)); return; }

    // ─── Command wheel (field actions) ───
    if (m.action === 'radial_open')    { CommandWheel.open(m.data || m.payload || {}); return; }
    if (m.action === 'radial_close')   { CommandWheel.close(); return; }
    if (m.action === 'radial_hostage') { CommandWheel.hostage(!!(m.data && m.data.show)); return; }
});

document.addEventListener('keydown', e => {
    if (e.key !== 'Escape') return;
    // Graffiti selector is a standalone overlay — Escape cancels it.
    if (Graffiti.isOpen()) { Graffiti.cancel(); return; }
    // Command wheel is a standalone overlay — Escape goes back, then dismisses.
    if (CommandWheel.isOpen()) { CommandWheel.onEscape(); return; }
    // Garage is a standalone overlay — Escape closes it.
    if (Garage.isOpen()) { Garage.close(); return; }
    // Creator is a standalone overlay — Escape closes it.
    if (Creator.isOpen()) {
        if (Creator.confirmIsOpen())  { Creator.hideConfirm(); return; }  // dismiss the unsaved prompt first
        if (Creator.newGangIsOpen())  { Creator.closeNewGang(); return; } // then the new-gang dialog
        if (Creator.drawIsOpen())     { Creator.closeDraw(); return; }    // then the draw modal
        Creator.requestClose(); return;                                   // guarded close (prompts if dirty)
    }
    if (!$('#alert-overlay')?.hidden || !$('#input-overlay')?.hidden) return; // let a modal close first
    if (state.open) post('close');
});

/* ============================================================
   CREATOR — in-world node-graph editor (apex_restaurant style)
   ────────────────────────────────────────────────────────────
   A blueprint canvas: the left sidebar lists every gang/owner; the
   palette adds node cards (HQ / safe / garage / medic / task /
   territory) wired to the selected owner's root node by bezier
   curves. The inspector edits the selected node. Placement uses the
   three in-world modes (my position · walk+E · laser) which return
   via the `editor_restore` message. Persistence is per-node:
     node_save  { kind, gang, id?, label, icon, x,y,z, heading, radius, blip, enabled }
     node_delete{ kind, id }
     creator_refresh -> { zones, turf }
   Data on creator_open: { zones, turf, owners, here }.
   ============================================================ */
const Creator = (() => {
    // ─── Node type registry (palette + inspector) ─────────
    const TYPES = {
        hq:        { icon: 'house-chimney',    label: 'HQ',         kind: 'hq',        color: '#34C77B' },
        safe:      { icon: 'vault',            label: 'Safe',       kind: 'safe',      color: '#5C7AFF' },
        garage:    { icon: 'warehouse',        label: 'Garage',     kind: 'garage',    color: '#E5A93C' },
        medic:     { icon: 'kit-medical',      label: 'Medic',      kind: 'medic',     color: '#E5564B' },
        task:      { icon: 'list-check',       label: 'Task Point', kind: 'task',      color: '#A66DF0' },
        territory: { icon: 'map-location-dot', label: 'Territory',  kind: 'territory', color: '#1F5EFF' },
    };
    const DEFAULT_ICON = { hq:'house-chimney', safe:'vault', garage:'warehouse', medic:'kit-medical', task:'list-check' };

    // ─── State ────────────────────────────────────────────
    const S = {
        open: false,
        owners: [],        // [{ gang, value, label, color }]
        activeOwner: null, // owner value (gang/job id)
        here: { x: 0, y: 0, z: 0, heading: 0 },
        nodes: [],         // [{ id, type, x, y, ref }] — ref is the saved row data
        connections: [],   // [{ from, to }]
        selected: null,
        dirty: false,      // unsaved in-memory edits (FEATURE 2 guard)
        zoom: 1,
        offset: { x: 0, y: 0 },
        // bag of ALL nodes grouped by owner, built once on open/refresh
        byOwner: {},       // ownerValue -> [ nodeRef ]
        tempConn: null,
        // ── Overview / map view ──
        view: 'overview',  // 'overview' | 'editor'
        ovMap: null, ovMapBuilt: false, ovTerrLayer: null, ovPinLayer: null,
        // ── Territory map-draw modal ──
        draw: { active: false, mode: 'circle', points: [], markers: [], poly: null,
                circle: null, center: null, radius: 80, z: 0, node: null },
    };

    // Leaflet map config — same projection/tiles as apex_redzone.
    const MAP = {
        CX: 117.3, CY: 172.8, SX: 0.02072, SY: 0.0205,
        TILE: 'https://www.gtamap.xyz/mapStyles/styleAtlas/{z}/{x}/{y}.jpg',
        BOUNDS: [[8000, -5500], [-8000, 5500]],
    };
    function makeCRS() {
        return L.extend({}, L.CRS.Simple, {
            projection: L.Projection.LonLat,
            scale: z => Math.pow(2, z),
            zoom: s => Math.log(s) / Math.LN2,
            distance: (a, b) => { const dx = b.lng - a.lng, dy = b.lat - a.lat; return Math.sqrt(dx * dx + dy * dy); },
            transformation: new L.Transformation(MAP.SX, MAP.CX, -MAP.SY, MAP.CY),
            infinite: true,
        });
    }

    // ─── DOM refs ─────────────────────────────────────────
    const root        = $('#creator-overlay');
    const gangList    = $('#ge-gang-list');
    const palette     = $('#ge-palette');
    const canvasWrap  = $('#ge-canvas-wrap');
    const nodesLayer  = $('#ge-nodes-layer');
    const connLayer   = $('#ge-connections');
    const tempLayer   = $('#ge-conn-temp');
    const canvasLayer = $('#ge-canvas-layer');
    const inspector   = $('#ge-insp-body');
    const insTitle    = $('#ge-insp-title');
    const insPill     = $('#ge-insp-pill');
    const insType     = $('#ge-insp-type');
    const zoomEl      = $('#ge-zoom');
    const statGangs   = $('#ge-status-gangs');
    const statNodes   = $('#ge-status-nodes');
    const statSel     = $('#ge-status-selected');
    const ownerNameEl = $('#ge-owner-name');
    const ownerChipEl = $('#ge-owner-chip');
    const mainEl      = $('#ge-main');
    const overviewBtn = $('#ge-overview-btn');

    function uid(p) { return p + '_' + Math.random().toString(36).slice(2, 9); }
    function num(v) { return (typeof v === 'number' ? v.toFixed(2) : (v == null ? '—' : v)); }

    // Creator-scoped error strings (don't mutate the shared ERR map the tabs use).
    const C_ERR = { exists: 'Already exists', bad_name: 'Invalid name',
                    db_error: 'Database error', not_authorized: 'Not authorised' };
    function cErr(code) { return C_ERR[code] || errMsg(code); }

    // ─── Dirty-state (FEATURE 2) ──────────────────────────
    const saveBtn   = $('#ge-save');
    const saveLabel = $('#ge-save-label');
    function setDirty(on) {
        S.dirty = !!on;
        if (saveBtn)   saveBtn.classList.toggle('is-dirty', S.dirty);
        if (saveLabel) saveLabel.textContent = S.dirty ? 'Save *' : 'Save';
    }
    function markDirty()  { if (!S.dirty) setDirty(true); }
    function clearDirty() { setDirty(false); }

    // Intercept a "leave" action when there are unsaved edits. If clean, run it
    // immediately; if dirty, show the 3-way confirm (Save / Discard / Cancel).
    function guard(proceed) {
        if (!S.dirty) { proceed && proceed(); return; }
        showConfirm({
            onSave() {
                // Run the save flow, then continue only if it fully succeeded.
                Promise.resolve(saveAll()).then(ok => { if (ok) proceed && proceed(); });
            },
            onDiscard() {
                clearDirty();
                // reload authoritative server state, then continue
                refresh(true);
                proceed && proceed();
            },
        });
    }

    // ─── Unsaved-changes confirm modal (#ge-confirm) ──────
    const confirmRoot = $('#ge-confirm');
    let confirmCbs = null;
    function showConfirm(cbs) {
        confirmCbs = cbs || {};
        if (confirmRoot) confirmRoot.hidden = false;
    }
    function hideConfirm() { if (confirmRoot) confirmRoot.hidden = true; confirmCbs = null; }
    function confirmIsOpen() { return !!(confirmRoot && !confirmRoot.hidden); }
    on($('#ge-confirm-cancel'),  'click', () => { hideConfirm(); });
    on($('#ge-confirm-discard'), 'click', () => { const cb = confirmCbs; hideConfirm(); cb && cb.onDiscard && cb.onDiscard(); });
    on($('#ge-confirm-save'),    'click', () => { const cb = confirmCbs; hideConfirm(); cb && cb.onSave && cb.onSave(); });

    function ownerOf(v) { return S.owners.find(o => (o.value || o.gang) === v); }
    function ownerColor(v) { const o = ownerOf(v); return (o && o.color) || '#1F5EFF'; }
    function ownerLabel(v) { const o = ownerOf(v); return (o && o.label) || v || '—'; }

    // ─── Build node refs from zones + turf ────────────────
    // A point node ref: { _id, _saved, type, kind, gang, label, icon, x, y, z, heading, radius, blip }
    // A territory node ref: { _id, _saved, type:'territory', kind:'territory', gang:<owner>, label, x,y,z, radius, blip, enabled }
    function buildFromData(zones, turf) {
        // Keep the shared store current so the Overview map re-reads it.
        state.creator.zones = zones || [];
        state.creator.turf  = turf  || [];
        state.creator.owners = S.owners;
        state.creator.here = S.here;
        S.byOwner = {};
        const push = (owner, ref) => { (S.byOwner[owner] = S.byOwner[owner] || []).push(ref); };

        (zones || []).forEach(z => {
            const c = z.coords || z;
            const owner = z.gang || '';
            push(owner, {
                _id: z.id, _saved: true, type: z.kind || 'hq', kind: z.kind || 'hq', gang: owner,
                label: z.label || '', icon: z.icon || DEFAULT_ICON[z.kind] || 'skull',
                x: Number(c.x) || 0, y: Number(c.y) || 0, z: Number(c.z) || 0,
                heading: Number(c.w != null ? c.w : c.heading) || 0,
                radius: Number(z.radius) || 2.0, blip: z.blip !== false,
                spawn: (z.meta && z.meta.spawn) || z.spawn || null,
            });
        });

        (turf || []).forEach(z => {
            const c = z.coords || z;
            const owner = z.owner || '';
            const ref = {
                _id: z.id, _saved: true, type: 'territory', kind: 'territory', gang: owner,
                label: z.label || 'Territory',
                x: Number(c.x) || 0, y: Number(c.y) || 0, z: Number(c.z) || 0,
                radius: Number(z.radius) || 50, blip: z.blip !== false, enabled: z.enabled !== false,
            };
            // carry the polygon so the draw modal can re-seed an existing poly
            if (Array.isArray(z.points) && z.points.length >= 3) {
                ref.points = z.points.map(p => ({ x: Number(p.x) || 0, y: Number(p.y) || 0 }));
            }
            push(owner, ref);
        });
    }

    function countFor(owner) { return (S.byOwner[owner] || []).length; }

    // ─── Open / close / restore ───────────────────────────
    function open(data) {
        S.open = true;
        S.owners = data.owners || data.gangs || [];
        S.here   = data.here || { x: 0, y: 0, z: 0, heading: 0 };
        // Shared store both the Overview map and the Editor read from.
        state.creator = {
            zones: data.zones || [], turf: data.turf || [],
            owners: S.owners, here: S.here,
        };
        buildFromData(data.zones, data.turf);
        S.selected = null;
        S.zoom = 1; S.offset = { x: 0, y: 0 };
        clearDirty();
        hideConfirm();
        if (root) { root.hidden = false; root.style.visibility = 'visible'; }
        renderPalette();
        // Default on open = Overview (no gang selected, Overview button active).
        showOverview();
    }
    function close() {
        S.open = false;
        if (root) { root.hidden = true; root.style.visibility = 'visible'; }
        closeDraw();
        if (S.ovMap) { try { S.ovMap.remove(); } catch (e) {} S.ovMap = null; S.ovMapBuilt = false; S.ovTerrLayer = null; S.ovPinLayer = null; }
        PlacementHUD.hide();
        window._coordsTarget = null;
    }
    function isOpen() { return S.open; }

    // ─── View (implied by selection): Overview (map) | Editor (node graph) ─
    // Overview button selected → Overview map · a gang selected → Editor.
    function setView(view) {
        S.view = (view === 'editor' || view === 'manager') ? view : 'overview';
        if (mainEl) mainEl.dataset.view = S.view;
        if (overviewBtn) overviewBtn.classList.toggle('active', S.view === 'overview');
        const managerBtn = $('#ge-manager-btn'); if (managerBtn) managerBtn.classList.toggle('active', S.view === 'manager');
        // Topbar context: Save lives in the Editor only; Overview shows its label.
        if (saveBtn) saveBtn.hidden = (S.view !== 'editor');
        // Manager tools (REP / Graffiti) show when a gang is selected (Editor).
        const mgrOn = (S.view === 'editor' && !!S.activeOwner);
        ['#ge-mgr-rep', '#ge-mgr-graffiti', '#ge-mgr-divider'].forEach(sel => { const b = $(sel); if (b) b.hidden = !mgrOn; });
        if (S.view === 'overview') {
            if (ownerNameEl) ownerNameEl.textContent = 'Overview';
            if (ownerChipEl) ownerChipEl.hidden = true;
            // Make sure the shared Leaflet element is back in the overview area
            // (the territory draw modal / view switches can leave it elsewhere,
            // which is what made the Overview map go blank after editing).
            const _ovHost = $('#ge-ov-maparea'), _ovMapEl = $('#ge-ov-map');
            if (_ovHost && _ovMapEl && _ovMapEl.parentElement !== _ovHost) _ovHost.appendChild(_ovMapEl);
            ensureOvMap();
            renderOverview();
            // map is now visible — recompute its size after layout settles.
            setTimeout(() => { try { S.ovMap && S.ovMap.invalidateSize(); } catch (e) {} }, 60);
        } else if (S.view === 'manager') {
            if (ownerNameEl) ownerNameEl.textContent = 'Manager';
            if (ownerChipEl) ownerChipEl.hidden = true;
            renderManager();
        }
    }

    // ─── Manager view: every gang with stats + REP/Graffiti actions ───
    function showManager() { S.activeOwner = null; S.selected = null; setView('manager'); }
    function renderManager() {
        const board = $('#ge-mgr-board'); if (!board) return;
        board.innerHTML = '<div class="muted" style="padding:14px">Loading…</div>';
        call('analytics:get').then(r => {
            if (!r.ok) { board.innerHTML = `<div class="muted" style="padding:14px">${escapeHTML(errMsg(r.error))}</div>`; return; }
            const gangs = r.data || [];
            setText('#ge-mgr-stats', `${gangs.length} gangs · ranked by reputation`);
            if (!gangs.length) { board.innerHTML = '<div class="muted" style="padding:14px">No gangs yet.</div>'; return; }
            const maxRep = Math.max(1, ...gangs.map(g => g.rep || 0));
            board.innerHTML = gangs.map((g, i) => {
                const color = g.color || '#1F5EFF';
                const pct = Math.max(2, Math.round(((g.rep || 0) / maxRep) * 100));
                return `
                <div class="ge-mgr-row" data-mgr-gang="${escapeAttr(g.gang)}" style="--an:${color}">
                    <div class="ge-mgr-rank">#${i + 1}</div>
                    <div class="ge-mgr-id">
                        <span class="ge-mgr-dot" style="background:${color}"></span>
                        <div style="min-width:0">
                            <div class="ge-mgr-name">${escapeHTML(g.label || g.gang)}</div>
                            <div class="ge-mgr-sub">Lv ${g.level || 1} · ${g.online || 0}/${g.members || 0} online · ${escapeHTML(g.gang)}</div>
                        </div>
                    </div>
                    <div class="ge-mgr-rep"><div class="ge-mgr-bar"><span style="width:${pct}%"></span></div><strong>${(g.rep || 0).toLocaleString()}</strong></div>
                    <div class="ge-mgr-stat"><i class="fa-solid fa-map-location-dot"></i>${g.turf || 0}</div>
                    <div class="ge-mgr-stat money"><i class="fa-solid fa-sack-dollar"></i>${fmtMoney(g.treasury || 0)}</div>
                    <div class="ge-mgr-acts">
                        <button class="btn btn-ghost btn-sm" data-mgr-act="edit" title="Edit zones"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="btn btn-ghost btn-sm" data-mgr-act="rep" title="Give / remove REP"><i class="fa-solid fa-fire-flame-curved"></i></button>
                        <button class="btn btn-ghost btn-sm" data-mgr-act="graffiti" title="Graffiti"><i class="fa-solid fa-spray-can"></i></button>
                        <button class="btn btn-ghost btn-sm ge-mgr-del" data-mgr-act="delete" title="Delete gang + its zones"><i class="fa-solid fa-trash"></i></button>
                    </div>
                </div>`;
            }).join('');
        });
    }

    // ─── Overview Leaflet map ─────────────────────────────
    function ensureOvMap() {
        if (S.ovMapBuilt && S.ovMap) return S.ovMap;
        const elMap = $('#ge-ov-map'); if (!elMap || typeof L === 'undefined') return null;
        // A previous map that wasn't fully torn down leaves its Leaflet id on the
        // container, so the next L.map() throws "already initialized" and the
        // overview map would only ever build on the FIRST open. Reset the
        // container so every re-open rebuilds cleanly.
        if (elMap._leaflet_id != null) { elMap._leaflet_id = null; elMap.innerHTML = ''; }
        const map = L.map(elMap, {
            crs: makeCRS(), minZoom: 2, maxZoom: 5, zoom: 3, center: [0, 0],
            zoomControl: true, preferCanvas: true, attributionControl: false,
            maxBounds: MAP.BOUNDS,
        });
        L.tileLayer(MAP.TILE, { minZoom: 2, maxZoom: 5, noWrap: true }).addTo(map);
        S.ovTerrLayer = L.layerGroup().addTo(map);
        S.ovPinLayer  = L.layerGroup().addTo(map);
        S.ovMap = map; S.ovMapBuilt = true;
        map.on('click', onDrawMapClick);   // polygon point drops while drawing
        setTimeout(() => { try { map.invalidateSize(); } catch (e) {} }, 80);
        return map;
    }
    function ovPinIcon() { return L.divIcon({ className: 'ge-ov-pin', iconSize: [14, 14], iconAnchor: [7, 7] }); }

    // Render territories (polys/circles) + point pins from the shared store.
    function renderOverview() {
        const cr = state.creator || { zones: [], turf: [], owners: [] };
        const zones = cr.zones || [], turf = cr.turf || [];
        // stats strip
        if ($('#ge-ov-gangs'))  $('#ge-ov-gangs').textContent  = (cr.owners || []).length;
        if ($('#ge-ov-points')) $('#ge-ov-points').textContent = zones.length;
        if ($('#ge-ov-terr'))   $('#ge-ov-terr').textContent   = turf.length;
        if (!S.ovMap || !S.ovTerrLayer || !S.ovPinLayer) return;
        S.ovTerrLayer.clearLayers();
        S.ovPinLayer.clearLayers();

        // territories
        turf.forEach(z => {
            const c = z.coords || z;
            const col = z.ownerColor || ownerColor(z.owner) || '#1F5EFF';
            const style = { color: col, weight: 2, fillColor: col, fillOpacity: 0.18, opacity: 0.9 };
            let layer = null;
            if (Array.isArray(z.points) && z.points.length >= 3) {
                layer = L.polygon(z.points.map(p => [p.y, p.x]), style);
            } else if (c && (Number(c.x) || Number(c.y))) {
                layer = L.circle([Number(c.y) || 0, Number(c.x) || 0], Object.assign({ radius: Number(z.radius) || 50 }, style));
            }
            if (!layer) return;
            const owner = z.ownerLabel || ownerLabel(z.owner);
            layer.bindTooltip(`${escapeHTML(z.label || 'Territory')} · ${escapeHTML(owner)}`, { direction: 'top', sticky: true });
            layer.addTo(S.ovTerrLayer);
        });

        // point nodes (hq/safe/garage/medic/task)
        zones.forEach(z => {
            const c = z.coords || z;
            if (!c || !(Number(c.x) || Number(c.y))) return;
            const m = L.marker([Number(c.y) || 0, Number(c.x) || 0], { icon: ovPinIcon() });
            const gang = z.gangLabel || ownerLabel(z.gang);
            m.bindTooltip(`${escapeHTML(z.label || z.kind || 'Point')} · ${escapeHTML(z.kind || '')} · ${escapeHTML(gang)}`, { direction: 'top' });
            m.addTo(S.ovPinLayer);
        });
    }

    // editor_restore handshake — write picked coords into the stashed inputs.
    function restore(m) {
        if (root) root.style.visibility = 'visible';
        const payload = (m && (m.payload || m.data)) || {};
        // garage vehicle-spawn ghost placement → write onto the node ref.
        if (payload.spawn && window._spawnTarget) {
            const sc = payload.coords;
            if (sc) { window._spawnTarget.spawn = { x: sc.x, y: sc.y, z: sc.z, w: payload.heading != null ? payload.heading : 0 }; markDirty(); }
            window._spawnTarget = null;
            renderInspector();
            return;
        }
        window._spawnTarget = null;
        const c = payload.coords;
        const t = window._coordsTarget;
        if (c && t) {
            if (t.x && typeof t.x.value !== 'undefined') {
                t.x.value = c.x; t.y.value = c.y; t.z.value = c.z;
                if (t.w) t.w.value = payload.heading != null ? payload.heading : 0;
                t.x.dispatchEvent(new Event('input'));
                t.y.dispatchEvent(new Event('input'));
                t.z.dispatchEvent(new Event('input'));
                if (t.w) t.w.dispatchEvent(new Event('input'));
                markDirty();   // coords moved via in-world placement
            }
        }
        window._coordsTarget = null;
    }

    // Delete a gang owner end-to-end: confirm → server wipe → drop it from the
    // owner list, sidebar, overview AND the analytics board (shared by the board
    // row trash button and the gang-owner sidebar trash button).
    function deleteGangFlow(gang, label) {
        if (!gang) return;
        confirmDlg(`Delete ${label || gang} and ALL of its zones, members, ranks, vault and progress? This cannot be undone.`, () => {
            call('gang:delete', { gang }).then(r => {
                if (!r.ok) return toast(errMsg(r.error), 'error');
                // Drop the owner locally, then RE-PULL {zones,turf} from the server
                // so the deleted gang's territories/points also leave the live map
                // (refresh() rebuilds the shared store + re-renders the current view).
                S.owners = S.owners.filter(o => (o.value || o.gang) !== gang);
                state.creator.owners = S.owners;
                if (S.activeOwner === gang) S.activeOwner = null;
                refresh(true);
                renderManager();
                toast('Gang deleted.', 'success');
            });
        });
    }

    // ─── Sidebar: gang/owner list ─────────────────────────
    function renderGangList() {
        if (!gangList) return;
        gangList.innerHTML = '';
        if (!S.owners.length) {
            gangList.appendChild(el('div', { class: 'ge-empty-hint' }, 'No gangs available'));
            return;
        }
        S.owners.forEach(o => {
            const val = o.value || o.gang;
            const row = el('div', {
                class: `ge-gang-row ${val === S.activeOwner ? 'active' : ''}`,
                // Clicking a gang switches to its Editor view (via selectOwner).
                // Guard: switching to a DIFFERENT gang with unsaved edits prompts first.
                onclick: () => { if (val === S.activeOwner) return; guard(() => selectOwner(val)); },
            },
                el('span', { class: 'ge-gang-dot', style: `background:${o.color || '#1F5EFF'}` }),
                el('div', { class: 'ge-gang-name' }, o.label || val),
                el('span', { class: 'ge-gang-badge' }, String(countFor(val))),
                // Delete this gang owner straight from the sidebar.
                el('button', {
                    class: 'ge-gang-del', title: 'Delete gang',
                    onclick: (ev) => { ev.stopPropagation(); deleteGangFlow(val, o.label || val); },
                }, el('i', { class: 'fa-solid fa-trash' }))
            );
            gangList.appendChild(row);
        });
    }

    // ─── Palette ──────────────────────────────────────────
    function renderPalette() {
        if (!palette) return;
        palette.innerHTML = '';
        Object.entries(TYPES).forEach(([t, def]) => {
            palette.appendChild(el('button', {
                class: 'ge-palette-btn',
                title: 'Add ' + def.label,
                style: `--_pc:${def.color}`,
                onclick: () => addNodeOfType(t),
            },
                el('i', { class: `fa-solid fa-${def.icon}` }),
                el('span', null, def.label)
            ));
        });
    }

    // ─── Select an owner → build its node graph ───────────
    // Selection drives the view: a gang → Editor, no gang → Overview.
    function selectOwner(owner) {
        S.activeOwner = owner;
        S.selected = null;
        if (ownerNameEl) ownerNameEl.textContent = owner ? ownerLabel(owner) : 'No gang selected';
        if (ownerChipEl) {
            if (owner) { ownerChipEl.hidden = false; ownerChipEl.textContent = owner; }
            else ownerChipEl.hidden = true;
        }
        syncNodesFromOwner();
        renderGangList();
        renderCanvas();
        renderInspector();
        setView(owner ? 'editor' : 'overview');
    }

    // Switch to the Overview map and deselect any gang.
    function showOverview() { selectOwner(null); }

    // Lay the owner's node refs out as a graph (root = owner, children = nodes).
    function syncNodesFromOwner() {
        S.nodes = [];
        S.connections = [];
        if (!S.activeOwner) return;

        const rootNode = { id: '__owner__', type: 'owner', x: 460, y: 260, ref: { value: S.activeOwner } };
        S.nodes.push(rootNode);

        const lane = { left: { x: rootNode.x - 320, y: rootNode.y - 220, dy: 104 },
                       right:{ x: rootNode.x + 320, y: rootNode.y - 220, dy: 104 } };
        const place = (ref, side) => {
            const id = ref._uid = ref._uid || uid('n');
            const ln = lane[side];
            const node = { id, type: ref.type, x: ln.x, y: ln.y, ref };
            ln.y += ln.dy;
            S.nodes.push(node);
            S.connections.push({ from: rootNode.id, to: id });
        };
        (S.byOwner[S.activeOwner] || []).forEach((ref, i) => {
            place(ref, ref.type === 'territory' ? 'left' : 'right');
        });
    }

    // ─── Canvas render ────────────────────────────────────
    function renderCanvas() {
        if (!nodesLayer) return;
        nodesLayer.innerHTML = '';
        connLayer.innerHTML = '';
        tempLayer.innerHTML = '';
        S.nodes.forEach(renderNode);
        S.connections.forEach(renderConnection);
        applyTransform();
        updateStatus();
    }

    function updateStatus() {
        if (zoomEl) zoomEl.textContent = Math.round(S.zoom * 100) + '%';
        if (statGangs) statGangs.textContent = S.owners.length + (S.owners.length === 1 ? ' gang' : ' gangs');
        const nodeCount = S.nodes.filter(n => n.type !== 'owner').length;
        if (statNodes) statNodes.innerHTML = '<i class="fa-solid fa-circle-nodes"></i> ' + nodeCount + ' nodes';
        const sel = S.selected ? S.nodes.find(n => n.id === S.selected) : null;
        if (statSel) statSel.textContent = sel ? titleFor(sel) : 'No selection';
    }

    function titleFor(node) {
        if (node.type === 'owner') return ownerLabel(node.ref.value);
        const def = TYPES[node.type] || TYPES.hq;
        return (node.ref && node.ref.label) ? node.ref.label : def.label;
    }
    function colorOf(node) {
        if (node.type === 'owner') return ownerColor(S.activeOwner);
        return (TYPES[node.type] || TYPES.hq).color;
    }

    function renderNode(node) {
        const def = node.type === 'owner'
            ? { icon: 'skull', label: 'Gang' }
            : (TYPES[node.type] || TYPES.hq);
        const tc = colorOf(node);
        const elNode = el('div', {
            class: `ge-node ${S.selected === node.id ? 'selected' : ''} ${node.type === 'owner' ? 'is-owner' : ''}`,
            dataset: { type: node.type, id: node.id },
            style: `left:${node.x}px;top:${node.y}px;--type-c:${tc}`,
            onmousedown: e => beginDragNode(e, node, elNode),
            onclick: e => { e.stopPropagation(); selectNode(node.id); },
        },
            el('div', { class: 'ge-node-head' },
                el('span', { class: 'ge-type-icon' }, el('i', { class: `fa-solid fa-${def.icon}` })),
                el('div', { class: 'ge-node-title' }, titleFor(node)),
                node.type !== 'owner' ? el('div', { class: 'ge-node-actions' },
                    el('button', { class: 'ge-node-act', title: 'Delete node',
                        onclick: e => { e.stopPropagation(); removeNode(node); } },
                        el('i', { class: 'fa-solid fa-xmark' }))
                ) : null,
                node.type !== 'owner' ? el('div', { class: 'ge-node-port in' }) : null,
                node.type === 'owner' ? el('div', { class: 'ge-node-port out' }) : null
            ),
            renderNodeBody(node)
        );
        nodesLayer.appendChild(elNode);
        node._el = elNode;
    }

    function renderNodeBody(node) {
        const body = el('div', { class: 'ge-node-body' });
        if (node.type === 'owner') {
            body.append(
                bodyRow('owner', node.ref.value || '—'),
                bodyRow('nodes', String((S.byOwner[S.activeOwner] || []).length))
            );
            return body;
        }
        const r = node.ref || {};
        body.append(bodyRow('coords', `${num(r.x)}, ${num(r.y)}, ${num(r.z)}`));
        if (node.type === 'territory') {
            body.append(bodyRow('radius', num(r.radius) + 'm'));
            body.append(bodyRow('state', r.enabled === false ? 'disabled' : 'enabled'));
        } else {
            body.append(bodyRow('head', num(r.heading) + '°'));
            body.append(bodyRow('radius', num(r.radius) + 'm'));
        }
        if (!r._saved) body.append(el('div', { class: 'ge-node-unsaved' }, 'unsaved'));
        return body;
    }
    function bodyRow(lbl, val) {
        return el('div', { class: 'ge-node-row' },
            el('span', { class: 'lbl' }, lbl),
            el('span', { class: 'val' }, String(val))
        );
    }

    // ─── Connections (bezier) ─────────────────────────────
    function outPort(node) { return { x: node.x + 200 + 5, y: node.y + 16 }; }
    function inPort(node)  { return { x: node.x - 5, y: node.y + 16 }; }
    function renderConnection(c) {
        const a = S.nodes.find(n => n.id === c.from);
        const b = S.nodes.find(n => n.id === c.to);
        if (!a || !b) return;
        const p1 = outPort(a), p2 = inPort(b);
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', bezier(p1, p2));
        path.setAttribute('class', 'ge-connection');
        connLayer.appendChild(path);
    }
    function bezier(p1, p2) {
        const dx = Math.max(40, Math.abs(p2.x - p1.x) * 0.5);
        return `M ${p1.x} ${p1.y} C ${p1.x + dx} ${p1.y}, ${p2.x - dx} ${p2.y}, ${p2.x} ${p2.y}`;
    }

    // ─── Node dragging ────────────────────────────────────
    function beginDragNode(e, node, elNode) {
        if (e.target.closest('.ge-node-port')) return;
        if (e.target.closest('.ge-node-act')) return;
        if (e.button !== 0) return;
        e.stopPropagation();
        elNode.classList.add('dragging');
        const sx = e.clientX, sy = e.clientY;
        const ox = node.x, oy = node.y;
        function move(ev) {
            node.x = ox + (ev.clientX - sx) / S.zoom;
            node.y = oy + (ev.clientY - sy) / S.zoom;
            elNode.style.left = node.x + 'px';
            elNode.style.top  = node.y + 'px';
            connLayer.innerHTML = '';
            S.connections.forEach(renderConnection);
        }
        function up() {
            elNode.classList.remove('dragging');
            document.removeEventListener('mousemove', move);
            document.removeEventListener('mouseup', up);
        }
        document.addEventListener('mousemove', move);
        document.addEventListener('mouseup', up);
    }

    // ─── Pan & zoom ───────────────────────────────────────
    let spaceDown = false;
    document.addEventListener('keydown', e => {
        if (!S.open) return;
        if (e.code === 'Space' && !e.repeat) { spaceDown = true; if (canvasWrap) canvasWrap.style.cursor = 'grab'; }
    });
    document.addEventListener('keyup', e => {
        if (e.code === 'Space') { spaceDown = false; if (canvasWrap) canvasWrap.style.cursor = ''; }
    });
    if (canvasWrap) {
        canvasWrap.addEventListener('mousedown', e => {
            if (e.target.closest('.ge-node') || e.target.closest('.ge-node-port')) return;
            if (e.target.closest('.ge-toolbar') || e.target.closest('.ge-shortcuts')) return;
            const isPan = (e.button === 1) || (e.button === 0 && spaceDown);
            if (e.button === 0 && !spaceDown) { selectNode(null); return; }
            if (!isPan) return;
            e.preventDefault();
            canvasWrap.classList.add('panning');
            const sx = e.clientX, sy = e.clientY;
            const ox = S.offset.x, oy = S.offset.y;
            function move(ev) { S.offset.x = ox + (ev.clientX - sx); S.offset.y = oy + (ev.clientY - sy); applyTransform(); }
            function up() {
                canvasWrap.classList.remove('panning');
                document.removeEventListener('mousemove', move);
                document.removeEventListener('mouseup', up);
            }
            document.addEventListener('mousemove', move);
            document.addEventListener('mouseup', up);
        });
        canvasWrap.addEventListener('wheel', e => {
            e.preventDefault();
            zoomBy(e.deltaY < 0 ? 1.1 : 1 / 1.1, { x: e.clientX, y: e.clientY });
        }, { passive: false });
    }
    function applyTransform() {
        if (nodesLayer) nodesLayer.style.transform = `translate(${S.offset.x}px,${S.offset.y}px) scale(${S.zoom})`;
        if (canvasLayer) canvasLayer.setAttribute('transform', `translate(${S.offset.x},${S.offset.y}) scale(${S.zoom})`);
    }
    function zoomBy(factor, anchor) {
        if (!canvasWrap) return;
        const rect = canvasWrap.getBoundingClientRect();
        const ax = anchor ? anchor.x - rect.left : rect.width / 2;
        const ay = anchor ? anchor.y - rect.top : rect.height / 2;
        const nz = Math.max(0.25, Math.min(2.5, S.zoom * factor));
        S.offset.x = ax - ((ax - S.offset.x) * (nz / S.zoom));
        S.offset.y = ay - ((ay - S.offset.y) * (nz / S.zoom));
        S.zoom = nz;
        applyTransform();
        if (zoomEl) zoomEl.textContent = Math.round(S.zoom * 100) + '%';
    }
    on($('#ge-zoom-in'),  'click', () => zoomBy(1.2));
    on($('#ge-zoom-out'), 'click', () => zoomBy(1 / 1.2));
    on($('#ge-zoom-reset'), 'click', () => { S.zoom = 1; S.offset = { x: 0, y: 0 }; applyTransform(); if (zoomEl) zoomEl.textContent = '100%'; });
    on($('#ge-zoom-fit'), 'click', () => {
        if (!S.nodes.length || !canvasWrap) return;
        const xs = S.nodes.map(n => n.x), ys = S.nodes.map(n => n.y);
        const minX = Math.min(...xs), maxX = Math.max(...xs) + 220;
        const minY = Math.min(...ys), maxY = Math.max(...ys) + 120;
        const rect = canvasWrap.getBoundingClientRect();
        const z = Math.min(1, Math.min(rect.width / (maxX - minX + 80), rect.height / (maxY - minY + 80)));
        S.zoom = z;
        S.offset = { x: (rect.width - (maxX - minX) * z) / 2 - minX * z, y: (rect.height - (maxY - minY) * z) / 2 - minY * z };
        applyTransform();
        if (zoomEl) zoomEl.textContent = Math.round(S.zoom * 100) + '%';
    });

    // ─── Selection & inspector ────────────────────────────
    function selectNode(id) {
        S.selected = id;
        $$('.ge-node').forEach(n => n.classList.toggle('selected', n.dataset.id === id));
        $$('.ge-connection').forEach((p, i) => {
            const c = S.connections[i];
            if (c) p.classList.toggle('active', c.from === id || c.to === id);
        });
        renderInspector();
        updateStatus();
    }

    function renderInspector() {
        if (!inspector) return;
        inspector.innerHTML = '';
        const node = S.nodes.find(n => n.id === S.selected);
        if (!node || node.type === 'owner') {
            insTitle.textContent = node ? titleFor(node) : 'Inspector';
            insPill.hidden = true;
            inspector.appendChild(el('div', { class: 'ge-insp-empty' },
                el('i', { class: 'fa-regular fa-hand-pointer' }),
                el('span', null, node ? 'This is the gang root. Pick a node to edit.' : 'Select a node to edit its properties')
            ));
            updateStatus();
            return;
        }
        const def = TYPES[node.type] || TYPES.hq;
        insTitle.textContent = titleFor(node);
        insPill.hidden = false;
        insType.textContent = def.label;
        insPill.querySelector('i').className = `fa-solid fa-${def.icon}`;
        const r = node.ref;

        if (node.type === 'territory') {
            // Territory is drawn ON THE MAP (redzone style), not placed in-world.
            inspector.append(
                group('Territory',
                    field('Label', textInput(r, 'label', 'Territory')),
                    drawField(node),
                    toggleField('Blip', r, 'blip', true),
                    toggleField('Enabled', r, 'enabled', true)
                ),
                deleteGroup(node)
            );
        } else {
            inspector.append(...[
                group(def.label,
                    field('Label', textInput(r, 'label', def.label)),
                    coordsField('Coords', r, true),
                    field('Heading', numInput(r, 'heading', 0)),
                    field('Radius', numInput(r, 'radius', 2.0, 0.1)),
                    field('Icon', textInput(r, 'icon', DEFAULT_ICON[node.type] || 'skull'))
                ),
                node.type === 'garage' ? spawnGroup(r) : null,
                deleteGroup(node)
            ].filter(Boolean));
        }
    }

    // Garage vehicle-spawn picker: a transparent ghost car you aim + rotate,
    // OR your feet + heading. Stored on the node and saved into zone meta.
    function spawnGroup(ref) {
        const status = el('div', { class: 'ge-spawn-status' });
        const paint = () => {
            status.textContent = (ref.spawn && ref.spawn.x != null)
                ? `Spawn set · ${Number(ref.spawn.x).toFixed(1)}, ${Number(ref.spawn.y).toFixed(1)} · ${Math.round(ref.spawn.w || 0)}°`
                : 'No spawn — vehicles drop next to the player';
        };
        paint();
        const ghost = el('button', { class: 'ge-spawn-btn' }, el('i', { class: 'fa-solid fa-car-side' }), ' Ghost car');
        ghost.addEventListener('click', async () => { window._spawnTarget = ref; await post('editor_vehicle_pick', { model: 'sentinel' }); });
        const feet = el('button', { class: 'ge-spawn-btn' }, el('i', { class: 'fa-solid fa-person' }), ' My feet');
        feet.addEventListener('click', async () => {
            const res = await post('editor_get_coords'); const c = res && res.coords; if (!c) return;
            ref.spawn = { x: Number(c.x), y: Number(c.y), z: Number(c.z), w: Number(res.heading) || 0 };
            markDirty(); paint();
        });
        const clr = el('button', { class: 'ge-spawn-btn ghost', title: 'Clear spawn' }, el('i', { class: 'fa-solid fa-xmark' }));
        clr.addEventListener('click', () => { ref.spawn = null; markDirty(); paint(); });
        return group('Vehicle spawn', status, el('div', { class: 'ge-spawn-actions' }, ghost, feet, clr));
    }

    function deleteGroup(node) {
        return el('div', { class: 'ge-group' },
            el('button', {
                class: 'ge-del-btn',
                onclick: () => removeNode(node),
            }, el('i', { class: 'fa-solid fa-trash' }), ' Delete node')
        );
    }

    // ── Inspector field helpers ──
    function group(title, ...children) {
        return el('div', { class: 'ge-group' }, el('div', { class: 'ge-group-title' }, title), ...children);
    }
    function field(label, control) {
        return el('div', { class: 'ge-field' }, el('label', { class: 'ge-field-label' }, label), control);
    }
    function textInput(ref, key, def = '') {
        const i = el('input', { class: 'apex-input', type: 'text', value: ref[key] != null ? ref[key] : def });
        if (ref[key] == null) ref[key] = def;
        i.addEventListener('input', () => { ref[key] = i.value; markDirty(); refreshNode(); });
        return i;
    }
    function numInput(ref, key, def = 0, step = 1) {
        const i = el('input', { class: 'apex-input', type: 'number', value: ref[key] != null ? ref[key] : def, step });
        if (ref[key] == null) ref[key] = def;
        i.addEventListener('input', () => { ref[key] = Number(i.value); markDirty(); refreshNode(); });
        return i;
    }
    function toggleField(label, ref, key, defaultOn = false) {
        const cur = ref[key] === undefined ? defaultOn : !!ref[key];
        if (ref[key] === undefined) ref[key] = cur;
        const t = el('div', { class: `ge-toggle ${cur ? 'on' : ''}` });
        t.addEventListener('click', () => { ref[key] = !ref[key]; t.classList.toggle('on', !!ref[key]); markDirty(); refreshNode(); });
        return el('div', { class: 'ge-field ge-toggle-row' },
            el('span', { class: 'ge-field-label', style: 'margin:0' }, label), t);
    }
    // Coords X/Y/Z (+ heading-aware) with the three placement buttons.
    function coordsField(label, ref, withHeading) {
        const inp = (key) => {
            const i = el('input', { class: 'apex-input', type: 'number', step: '0.01', value: ref[key] != null ? ref[key] : 0 });
            i.addEventListener('input', () => { ref[key] = Number(i.value); markDirty(); refreshNode(); });
            return i;
        };
        const x = inp('x'), y = inp('y'), z = inp('z');

        // [a] my position (instant)
        const here = el('button', { title: 'Use my position (right now)' }, el('i', { class: 'fa-solid fa-person-circle-check' }));
        here.addEventListener('click', async () => {
            const res = await post('editor_get_coords');
            const c = res && res.coords;
            if (!c) return;
            x.value = c.x; y.value = c.y; z.value = c.z;
            ref.x = Number(c.x); ref.y = Number(c.y); ref.z = Number(c.z);
            x.dispatchEvent(new Event('input')); y.dispatchEvent(new Event('input')); z.dispatchEvent(new Event('input'));
            if (withHeading && res.heading != null) {
                ref.heading = Number(res.heading);
                const hi = headingInputFor(); if (hi) { hi.value = res.heading; hi.dispatchEvent(new Event('input')); }
            }
            refreshNode();
        });
        // [b] walk + E
        const walk = el('button', { title: 'Walk to the spot, then [E]' }, el('i', { class: 'fa-solid fa-shoe-prints' }));
        walk.addEventListener('click', async () => {
            window._coordsTarget = { x, y, z, w: withHeading ? headingInputFor() : null };
            await post('editor_pick_coords');
        });
        // [c] laser
        const laser = el('button', { title: 'Laser pick (aim with camera)' }, el('i', { class: 'fa-solid fa-bullseye' }));
        laser.addEventListener('click', async () => {
            window._coordsTarget = { x, y, z, w: withHeading ? headingInputFor() : null };
            await post('editor_laser_pick');
        });

        return el('div', { class: 'ge-field' },
            el('label', { class: 'ge-field-label' }, label),
            el('div', { class: 'ge-coord-pick' }, x, y, z, here, walk, laser)
        );
    }
    // The heading input lives in its own field; find it in the inspector so
    // pick handshakes can also fill heading.
    function headingInputFor() {
        const labels = $$('.ge-field-label', inspector);
        for (const lab of labels) {
            if ((lab.textContent || '').trim().toLowerCase() === 'heading') {
                const f = lab.parentElement; if (f) return f.querySelector('input[type="number"]');
            }
        }
        return null;
    }
    // Territory: a "Draw on map" button + a small shape summary. Clicking opens
    // the map-draw modal (#ge-draw). No in-world placement buttons here.
    function drawField(node) {
        const r = node.ref || {};
        const hasPoly = Array.isArray(r.points) && r.points.length >= 3;
        const shape = hasPoly ? 'polygon' : 'circle';
        const detail = hasPoly ? `${r.points.length} points` : `${num(r.radius) || 50}m radius`;
        const summary = el('div', { class: 'ge-draw-summary' },
            el('span', { class: 'ge-draw-shape' }, el('i', { class: `fa-solid fa-${hasPoly ? 'draw-polygon' : 'circle-dot'}` }), ' ' + shape),
            el('span', { class: 'ge-draw-detail' }, detail)
        );
        const btn = el('button', { class: 'ge-draw-open-btn', onclick: () => openDraw(node) },
            el('i', { class: 'fa-solid fa-map-location-dot' }), ' Draw on map');
        return el('div', { class: 'ge-field' },
            el('label', { class: 'ge-field-label' }, 'Territory shape'),
            summary, btn
        );
    }

    function refreshNode() {
        const node = S.nodes.find(n => n.id === S.selected);
        if (!node || !node._el) return;
        const titleEl = node._el.querySelector('.ge-node-title');
        if (titleEl) titleEl.textContent = titleFor(node);
        const oldBody = node._el.querySelector('.ge-node-body');
        if (oldBody) oldBody.replaceWith(renderNodeBody(node));
    }

    // ─── Add / remove nodes ───────────────────────────────
    function addNodeOfType(type) {
        if (!S.activeOwner) { toast('Pick a gang first', 'warning'); return; }
        const def = TYPES[type];
        // Assign a STABLE id up-front so every save is an idempotent upsert
        // (the server only generates a new id when none is sent — which is what
        // caused nodes to duplicate on a second save).
        const stableId = `${slugify(S.activeOwner)}_${def.kind}_${Math.random().toString(36).slice(2, 9)}`;
        const ref = {
            _uid: uid('n'), _id: stableId, _saved: false, type, kind: def.kind, gang: S.activeOwner,
            label: def.label, icon: DEFAULT_ICON[type] || 'skull',
            x: Number(S.here.x) || 0, y: Number(S.here.y) || 0, z: Number(S.here.z) || 0,
            heading: Number(S.here.heading) || 0,
            radius: type === 'territory' ? 50 : 2.0,
            blip: true, enabled: true,
        };
        (S.byOwner[S.activeOwner] = S.byOwner[S.activeOwner] || []).push(ref);
        markDirty();   // new unsaved node added from the palette
        syncNodesFromOwner();
        renderGangList();
        renderCanvas();
        // auto-select the new node
        const newNode = S.nodes.find(n => n.ref === ref);
        if (newNode) selectNode(newNode.id);
    }

    function removeNode(node) {
        if (!node || node.type === 'owner') return;
        const ref = node.ref;
        const drop = () => {
            const arr = S.byOwner[S.activeOwner] || [];
            const i = arr.indexOf(ref);
            if (i >= 0) arr.splice(i, 1);
            if (S.selected === node.id) S.selected = null;
            syncNodesFromOwner();
            renderGangList();
            renderCanvas();
            renderInspector();
        };
        if (ref._saved && ref._id) {
            confirmDlg('Delete this node? This removes it from the world.', () => {
                post('node_delete', { kind: ref.kind, id: ref._id }).then(res => {
                    if (res && res.ok) { toast('Node deleted', 'success'); drop(); refresh(true); }
                    else toast(errMsg(res && res.error) || 'Delete failed', 'error');
                });
            });
        } else {
            drop();
            markDirty();   // removed an unsaved node from the graph
        }
    }

    // ══════════════════════════════════════════════════════
    // TERRITORY MAP-DRAW MODAL (#ge-draw) — redzone-style.
    // Reuses the single overview Leaflet instance, relocated into
    // the modal host while drawing (one Leaflet object per host).
    // ══════════════════════════════════════════════════════
    const drawRoot   = $('#ge-draw');
    const drawHost   = $('#ge-draw-host');
    const ovHost     = $('#ge-ov-maparea');
    function geDotIcon() { return L.divIcon({ className: 'ge-dot', iconSize: [16, 16], iconAnchor: [8, 8] }); }
    function brandCss() { return (getComputedStyle(document.documentElement).getPropertyValue('--brand-500').trim()) || '#1F5EFF'; }

    // Relocate the single #ge-ov-map element between the overview area and the
    // draw modal host (mirrors redzone's moveMap).
    function moveMap(host) {
        const m = $('#ge-ov-map');
        if (host && m && m.parentElement !== host) host.appendChild(m);
        ensureOvMap();
        setTimeout(() => { try { S.ovMap && S.ovMap.invalidateSize(); } catch (e) {} }, 60);
    }
    function clearDrawLayers() {
        if (!S.ovMap) return;
        S.draw.markers.forEach(m => { try { S.ovMap.removeLayer(m); } catch (e) {} });
        if (S.draw.poly)   { try { S.ovMap.removeLayer(S.draw.poly); } catch (e) {} }
        if (S.draw.circle) { try { S.ovMap.removeLayer(S.draw.circle); } catch (e) {} }
        S.draw.markers = []; S.draw.poly = null; S.draw.circle = null;
    }
    function updateDrawCount() { const c = $('#ge-draw-count'); if (c) c.textContent = S.draw.points.length; }
    function setDrawMode(mode) {
        S.draw.mode = (mode === 'poly') ? 'poly' : 'circle';
        if (drawRoot) drawRoot.dataset.mode = S.draw.mode;
        $$('.ge-draw-mode').forEach(b => b.classList.toggle('active', b.dataset.mode === S.draw.mode));
        const hint = $('#ge-draw-hint');
        if (hint) hint.innerHTML = S.draw.mode === 'poly'
            ? '<i class="fa-solid fa-draw-polygon"></i> Click the map to drop points · drag points to adjust'
            : '<i class="fa-solid fa-circle-dot"></i> Drag the centre dot to move it · use the slider for the radius';
        clearDrawLayers();
        if (S.draw.mode === 'circle') startCircleDraw();
        else startPolyDraw();
    }

    function openDraw(node) {
        if (!drawRoot) return;
        S.draw.node = node;
        const r = node.ref || {};
        if ($('#ge-draw-name')) $('#ge-draw-name').textContent = r.label || 'Territory';
        // seed center: node coords if set, else admin "here"
        const hasCoords = (Number(r.x) || Number(r.y));
        S.draw.center = { x: hasCoords ? Number(r.x) : (Number(S.here.x) || 0), y: hasCoords ? Number(r.y) : (Number(S.here.y) || 0) };
        S.draw.z = Number(r.z) || Number(S.here.z) || 0;
        S.draw.radius = Number(r.radius) || 80;
        S.draw.points = [];
        const hasPoly = Array.isArray(r.points) && r.points.length >= 3;
        drawRoot.hidden = false;
        moveMap(drawHost);
        // pre-fill the radius controls
        const rg = $('#ge-draw-radius'), rn = $('#ge-draw-radius-num');
        if (rg) rg.value = Math.min(S.draw.radius, Number(rg.max) || 400);
        if (rn) rn.value = Math.round(S.draw.radius);
        if (hasPoly) {
            setDrawMode('poly');
            (r.points || []).forEach(p => addDrawPoint(p.y, p.x));
            const p0 = (r.points || [])[0];
            if (p0) setTimeout(() => { try { S.ovMap.setView([p0.y, p0.x], 5, { animate: true }); S.ovMap.invalidateSize(); } catch (e) {} }, 90);
        } else {
            setDrawMode('circle');
        }
        updateDrawCount();
    }
    function closeDraw() {
        if (!drawRoot || drawRoot.hidden) { if (drawRoot) drawRoot.hidden = true; return; }
        S.draw.active = false;
        clearDrawLayers();
        S.draw.points = []; S.draw.center = null; S.draw.node = null;
        drawRoot.hidden = true;
        if (ovHost) moveMap(ovHost);   // return the map to the overview area
    }

    // ── circle ──
    function startCircleDraw() {
        if (!S.ovMap) return;
        S.draw.active = true;
        const center = [S.draw.center.y, S.draw.center.x];
        const br = brandCss();
        S.draw.circle = L.circle(center, { radius: S.draw.radius, color: br, weight: 2, fillColor: br, fillOpacity: 0.18 }).addTo(S.ovMap);
        const cm = L.marker(center, { draggable: true, icon: geDotIcon() }).addTo(S.ovMap);
        cm.on('drag', () => { const ll = cm.getLatLng(); S.draw.center = { x: ll.lng, y: ll.lat }; if (S.draw.circle) S.draw.circle.setLatLng(ll); });
        S.draw.markers.push(cm);
        setTimeout(() => {
            try {
                S.ovMap.invalidateSize();
                if (S.draw.circle) S.ovMap.fitBounds(S.draw.circle.getBounds().pad(0.6), { maxZoom: 6, animate: true });
                else S.ovMap.setView(center, 5, { animate: true });
            } catch (e) {}
        }, 90);
    }
    function applyDrawRadius(rad) {
        S.draw.radius = Math.max(10, rad || 80);
        const rg = $('#ge-draw-radius'), rn = $('#ge-draw-radius-num');
        if (rg) rg.value = Math.min(S.draw.radius, Number(rg.max) || 400);
        if (rn && document.activeElement !== rn) rn.value = Math.round(S.draw.radius);
        if (S.draw.circle) S.draw.circle.setRadius(S.draw.radius);
    }

    // ── polygon ──
    function startPolyDraw() {
        if (!S.ovMap) return;
        S.draw.active = true;
        S.draw.points = [];
        updateDrawCount();
    }
    function onDrawMapClick(e) {
        if (S.draw.active && S.draw.mode === 'poly') addDrawPoint(e.latlng.lat, e.latlng.lng);
    }
    function addDrawPoint(lat, lng) {
        if (!S.ovMap) return;
        const idx = S.draw.points.length;
        const m = L.marker([lat, lng], { draggable: true, icon: geDotIcon() }).addTo(S.ovMap);
        m.on('drag', () => { const ll = m.getLatLng(); S.draw.points[idx] = { x: ll.lng, y: ll.lat }; redrawPoly(); });
        S.draw.markers.push(m);
        S.draw.points.push({ x: lng, y: lat });
        redrawPoly(); updateDrawCount();
    }
    function redrawPoly() {
        if (!S.ovMap) return;
        if (S.draw.poly) { try { S.ovMap.removeLayer(S.draw.poly); } catch (e) {} S.draw.poly = null; }
        if (S.draw.points.length >= 2) {
            const br = brandCss();
            S.draw.poly = L.polygon(S.draw.points.map(p => [p.y, p.x]),
                { color: br, weight: 2, fillColor: br, fillOpacity: 0.18, dashArray: '5' }).addTo(S.ovMap);
        }
    }

    // ── save the drawn geometry into the node, then persist ──
    function saveDraw() {
        const node = S.draw.node; if (!node) return;
        const r = node.ref || {};
        const owner = r.gang || S.activeOwner;
        const label = r.label || 'Territory';
        let center, points = null, radius;
        if (S.draw.mode === 'poly') {
            if (S.draw.points.length < 3) { toast('Add at least 3 points', 'warning'); return; }
            points = S.draw.points.map(p => ({ x: p.x, y: p.y }));
            // centre = polygon centroid (for the stored coords/blip)
            const sx = points.reduce((a, p) => a + p.x, 0) / points.length;
            const sy = points.reduce((a, p) => a + p.y, 0) / points.length;
            center = { x: sx, y: sy };
            radius = Number(r.radius) || 50;
        } else {
            if (!S.draw.center) { toast('Place the circle first', 'warning'); return; }
            center = { x: S.draw.center.x, y: S.draw.center.y };
            radius = S.draw.radius;
        }
        // write geometry back onto the node ref
        r.x = center.x; r.y = center.y; r.z = S.draw.z || 0;
        r.radius = radius;
        if (points) r.points = points; else delete r.points;
        markDirty();   // territory geometry changed (cleared on the refresh after a successful save)

        const payload = {
            kind: 'territory', gang: owner, label,
            x: center.x, y: center.y, z: S.draw.z || 0,
            radius, blip: r.blip !== false, enabled: r.enabled !== false,
        };
        if (r._id) payload.id = r._id;
        if (points) payload.points = points;   // server decides shape by point count

        const btn = $('#ge-draw-save'); if (btn) { btn.disabled = true; btn.dataset.html = btn.innerHTML; btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Saving…'; }
        post('node_save', payload).then(res => {
            if (btn) { btn.disabled = false; if (btn.dataset.html) { btn.innerHTML = btn.dataset.html; delete btn.dataset.html; } }
            if (res && res.ok) {
                r._id = res.id || r._id; r._saved = true;
                toast('Territory saved', 'success');
                closeDraw();
                refresh(true);              // pull fresh data + re-render current view
                refreshNode();
            } else {
                toast(errMsg(res && res.error) || 'Save failed', 'error');
            }
        });
    }

    // draw modal wiring
    on($('#ge-draw-circle'), 'click', () => setDrawMode('circle'));
    on($('#ge-draw-poly'),   'click', () => setDrawMode('poly'));
    on($('#ge-draw-x'),      'click', closeDraw);
    on($('#ge-draw-cancel'), 'click', closeDraw);
    on($('#ge-draw-save'),   'click', saveDraw);
    on($('#ge-draw-undo'),   'click', () => {
        const m = S.draw.markers.pop(); if (m) try { S.ovMap.removeLayer(m); } catch (e) {}
        S.draw.points.pop(); redrawPoly(); updateDrawCount();
    });
    on($('#ge-draw-radius'),     'input', e => applyDrawRadius(Number(e.target.value) || 80));
    on($('#ge-draw-radius-num'), 'input', e => applyDrawRadius(Number(e.target.value) || 80));

    // ─── Save (per node) ──────────────────────────────────
    async function saveAll() {
        if (!S.activeOwner) { toast('Pick a gang first', 'warning'); return false; }
        const refs = (S.byOwner[S.activeOwner] || []).slice();
        if (!refs.length) { toast('No nodes to save', 'info'); clearDirty(); return true; }
        let okCount = 0, fail = 0;
        for (const ref of refs) {
            const payload = {
                kind: ref.kind, gang: S.activeOwner,
                label: ref.label, icon: ref.icon,
                x: Number(ref.x) || 0, y: Number(ref.y) || 0, z: Number(ref.z) || 0,
                heading: Number(ref.heading) || 0, radius: Number(ref.radius) || (ref.kind === 'territory' ? 50 : 2.0),
                blip: ref.blip !== false, enabled: ref.enabled !== false,
            };
            if (ref._id) payload.id = ref._id;
            // garage vehicle spawn (coords + heading) → stored in zone meta.
            if (ref.spawn && ref.spawn.x != null) {
                payload.meta = { spawn: { x: Number(ref.spawn.x) || 0, y: Number(ref.spawn.y) || 0, z: Number(ref.spawn.z) || 0, w: Number(ref.spawn.w) || 0 } };
            }
            // territory polygons MUST keep their points, or the server (which
            // decides the shape by point count, >=3 = poly) falls back to a
            // circle — turning a drawn polygon into a circumference.
            if (ref.kind === 'territory' && Array.isArray(ref.points) && ref.points.length >= 3) {
                payload.points = ref.points.map(p => ({ x: Number(p.x) || 0, y: Number(p.y) || 0 }));
            }
            const res = await post('node_save', payload);
            if (res && res.ok) { ref._id = res.id || ref._id; ref._saved = true; okCount++; }
            else fail++;
        }
        renderCanvas();
        renderInspector();
        if (fail === 0) { toast(`Saved ${okCount} node${okCount === 1 ? '' : 's'}`, 'success'); clearDirty(); }
        else toast(`Saved ${okCount}, ${fail} failed`, fail && !okCount ? 'error' : 'warning');
        if (okCount) refresh(true);   // keep the shared store + overview in sync
        return fail === 0;
    }

    // ─── Refresh from server ──────────────────────────────
    // Pulls fresh {zones,turf}, updates the shared store, then re-renders the
    // current view (Overview map or Editor). `silent` skips the toast (used
    // after a save/delete).
    function refresh(silent) {
        return post('creator_refresh').then(r => {
            if (!r) return;
            buildFromData(r.zones, r.turf);
            clearDirty();   // fresh server state — nothing unsaved
            // Preserve the current selection/view. In Overview (no gang) stay in
            // Overview; in Editor keep the gang if it still exists, else drop to
            // Overview rather than silently jumping into another gang.
            if (!S.activeOwner) {
                showOverview();
            } else {
                const stillThere = S.owners.some(o => (o.value || o.gang) === S.activeOwner);
                selectOwner(stillThere ? S.activeOwner : null);
            }
            if (S.view === 'overview') renderOverview();
            if (!silent) toast('Reloaded from server', 'info');
        });
    }

    // ═══════════════════════════════════════════════════════
    // NEW GANG / JOB DIALOG (#ge-newgang) — two modes (FEATURE 1)
    //   (a) "Use existing job"  → call('gang:create', {name,label,color})
    //   (b) "Create new job"    → call('creator:createJob', {name,label,color,grades})
    // Shared success handler adds the owner to the sidebar, selects it,
    // switches to the Editor and toasts.
    // ═══════════════════════════════════════════════════════
    const ngRoot     = $('#ge-newgang');
    const ngSelect   = $('#ge-ng-select');
    const ngELabel   = $('#ge-ng-elabel');
    const ngEColor   = $('#ge-ng-ecolor');
    const ngName     = $('#ge-ng-name');
    const ngLabel    = $('#ge-ng-label');
    const ngColor    = $('#ge-ng-color');
    const ngRanksList= $('#ge-ng-ranks-list');
    const ngCreateLbl= $('#ge-ng-create-label');
    const NG_DEFAULT_RANKS = [
        { grade: 0, name: 'recruit',    label: 'Recruit' },
        { grade: 1, name: 'member',     label: 'Member' },
        { grade: 2, name: 'lieutenant', label: 'Lieutenant' },
        { grade: 3, name: 'boss',       label: 'Boss' },
    ];
    let ngMode = 'existing';     // 'existing' | 'new'
    let ngAvail = [];            // [{value,label}] from creator:available

    // lowercase / no-spaces / a-z0-9_ slug (live as the user types Mode B name)
    function slugify(s) {
        return String(s || '').toLowerCase().trim()
            .replace(/[^a-z0-9_\s-]/g, '')
            .replace(/[\s-]+/g, '_')
            .replace(/_+/g, '_');
    }
    function ngLabelOf(v) { const o = ngAvail.find(o => String(o.value) === String(v)); return (o && o.label) || v; }

    function ngSetMode(mode) {
        ngMode = (mode === 'new') ? 'new' : 'existing';
        $$('#ge-ng-seg .ge-seg-btn').forEach(b => b.classList.toggle('active', b.dataset.ngmode === ngMode));
        $$('#ge-newgang .ge-ng-pane').forEach(p => p.hidden = p.dataset.ngpane !== ngMode);
        if (ngCreateLbl) ngCreateLbl.textContent = ngMode === 'new' ? 'Create job' : 'Register gang';
    }

    // ── ranks editor (Mode B) ──
    function ngRenderRanks(rows) {
        if (!ngRanksList) return;
        ngRanksList.innerHTML = '';
        (rows || []).forEach((row, i) => {
            const grade = el('input', { class: 'apex-input ge-ng-grade', type: 'number', min: '0', value: i });
            grade.disabled = true;   // grade is positional; managed by add/remove order
            const name  = el('input', { class: 'apex-input', type: 'text', placeholder: 'member',  value: row.name  || '' });
            const label = el('input', { class: 'apex-input', type: 'text', placeholder: 'Member',  value: row.label || '' });
            const del = el('button', { class: 'ge-ng-rank-del', title: 'Remove rank',
                onclick: () => { ngCollectRanks(); ngRanks.splice(i, 1); ngRenderRanks(ngRanks); } },
                el('i', { class: 'fa-solid fa-xmark' }));
            ngRanksList.appendChild(el('div', { class: 'ge-ng-rank' }, grade, name, label, del));
            row._name = name; row._label = label;
        });
    }
    let ngRanks = [];
    function ngCollectRanks() {
        ngRanks.forEach(r => { if (r._name) r.name = r._name.value; if (r._label) r.label = r._label.value; });
    }
    function ngAddRank() {
        ngCollectRanks();
        ngRanks.push({ name: '', label: '' });
        ngRenderRanks(ngRanks);
    }

    function ngOpen() {
        if (!ngRoot) return;
        // reset
        ngSetMode('existing');
        if (ngELabel) ngELabel.value = '';
        if (ngELabel) delete ngELabel.dataset.touched;
        if (ngEColor) { ngEColor.value = '#1F5EFF'; const c = $('#ge-ng-ecolor-hex'); if (c) c.textContent = '#1F5EFF'; }
        if (ngName)  ngName.value = '';
        if (ngLabel) ngLabel.value = '';
        if (ngColor) { ngColor.value = '#1F5EFF'; const c = $('#ge-ng-color-hex'); if (c) c.textContent = '#1F5EFF'; }
        ngRanks = NG_DEFAULT_RANKS.map(r => ({ name: r.name, label: r.label }));
        ngRenderRanks(ngRanks);

        // populate the existing-job select live
        if (ngSelect) ngSelect.innerHTML = '<option value="">Loading…</option>';
        ngRoot.hidden = false;
        if (ngName) setTimeout(() => { try { ngName.blur(); } catch (e) {} }, 0);

        call('creator:available').then(r => {
            ngAvail = (r && r.ok ? (r.data || []) : []).filter(o => o && o.value != null);
            if (!ngSelect) return;
            if (!ngAvail.length) {
                ngSelect.innerHTML = '<option value="">No unused jobs — use “Create new job”</option>';
            } else {
                ngSelect.innerHTML = ngAvail.map(o =>
                    `<option value="${escapeAttr(o.value)}">${escapeHTML(o.label || o.value)}</option>`).join('');
                if (ngELabel && !ngELabel.dataset.touched) ngELabel.value = ngLabelOf(ngSelect.value);
            }
        });
    }
    function ngClose() { if (ngRoot) ngRoot.hidden = true; }
    function ngIsOpen() { return !!(ngRoot && !ngRoot.hidden); }

    // shared post-create: register the owner in the sidebar, jump to it.
    function ngOnCreated(value, label, color, successMsg) {
        if (!S.owners.some(o => (o.value || o.gang) === value)) {
            S.owners.push({ gang: value, value, label, color });
            state.creator.owners = S.owners;
        } else {
            const o = ownerOf(value); if (o) { o.label = label; o.color = color; }
        }
        ngClose();
        toast(successMsg, 'success');
        // Selecting the new gang switches to its Editor view automatically.
        selectOwner(value);
    }

    function ngSubmit() {
        const btn = $('#ge-ng-create');
        const lock   = () => { if (btn) { btn.disabled = true; btn.dataset.html = btn.innerHTML; btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Working…'; } };
        const unlock = () => { if (btn) { btn.disabled = false; if (btn.dataset.html) { btn.innerHTML = btn.dataset.html; delete btn.dataset.html; } } };

        if (ngMode === 'existing') {
            const value = (ngSelect && ngSelect.value || '').trim();
            if (!value) return toast('Pick a job first', 'error');
            const label = (ngELabel && ngELabel.value || '').trim() || ngLabelOf(value);
            const color = (ngEColor && ngEColor.value) || '#1F5EFF';
            lock();
            call('gang:create', { name: value, label, color }).then(rr => {
                unlock();
                if (!rr.ok) return toast(cErr(rr.error), 'error');
                const finalLabel = (rr.data && rr.data.label) || label;
                ngOnCreated(value, finalLabel, color, 'Gang registered');
            });
            return;
        }

        // Mode B — create a brand-new job LIVE
        const name = slugify(ngName && ngName.value);
        if (!name || name.length < 2) return toast('Enter a valid job name', 'error');
        const label = (ngLabel && ngLabel.value || '').trim() || name;
        const color = (ngColor && ngColor.value) || '#1F5EFF';
        ngCollectRanks();
        let rows = ngRanks
            .map(r => ({ name: slugify(r.name), label: (r.label || '').trim() }))
            .filter(r => r.name || r.label);
        if (!rows.length) rows = NG_DEFAULT_RANKS.map(r => ({ name: r.name, label: r.label }));
        const grades = rows.map((r, i) => ({
            grade: i,
            name:  r.name  || ('grade' + i),
            label: r.label || r.name || ('Grade ' + i),
            salary: 0,
        }));
        lock();
        call('creator:createJob', { name, label, color, grades }).then(rr => {
            unlock();
            if (!rr.ok) return toast(cErr(rr.error), 'error');
            const finalName  = (rr.data && rr.data.name)  || name;
            const finalLabel = (rr.data && rr.data.label) || label;
            ngOnCreated(finalName, finalLabel, color, 'Job created live');
        });
    }

    function newGang() { ngOpen(); }

    // ── new-gang dialog wiring ──
    $$('#ge-ng-seg .ge-seg-btn').forEach(b => on(b, 'click', () => ngSetMode(b.dataset.ngmode)));
    on($('#ge-ng-x'),      'click', ngClose);
    on($('#ge-ng-cancel'), 'click', ngClose);
    on($('#ge-ng-create'), 'click', ngSubmit);
    on($('#ge-ng-addrank'),'click', ngAddRank);
    // live slugify the Mode-B job name
    on(ngName, 'input', () => { const p = ngName.selectionStart; const sl = slugify(ngName.value); if (ngName.value !== sl) { ngName.value = sl; try { ngName.setSelectionRange(p, p); } catch (e) {} } });
    // auto-fill the existing-job label until the user types their own
    on(ngSelect, 'change', () => { if (ngELabel && !ngELabel.dataset.touched) ngELabel.value = ngLabelOf(ngSelect.value); });
    on(ngELabel, 'input',  () => { if (ngELabel) ngELabel.dataset.touched = '1'; });
    // live colour hex chips
    on(ngEColor, 'input', () => { const c = $('#ge-ng-ecolor-hex'); if (c) c.textContent = (ngEColor.value || '').toUpperCase(); });
    on(ngColor,  'input', () => { const c = $('#ge-ng-color-hex');  if (c) c.textContent = (ngColor.value  || '').toUpperCase(); });

    // ─── Buttons / shortcuts ──────────────────────────────
    // Close (button + Escape) is guarded by the unsaved-changes check.
    function requestClose() { guard(() => { post('creator_close'); close(); }); }
    on($('#ge-close'),   'click', requestClose);
    on($('#ge-save'),    'click', () => saveAll());
    on($('#ge-refresh'), 'click', () => { if (S.view === 'manager') renderManager(); else refresh(); });

    // ── Manager tools (per selected gang) ──
    on($('#ge-mgr-rep'), 'click', () => {
        const gang = S.activeOwner; if (!gang) return;
        inputDlg({
            title: `Reputation · ${ownerLabel(gang)}`,
            html: `<div class="muted" style="margin-bottom:8px">Add reputation to this gang. Use a negative amount to remove.</div>`,
            fields: [{ type: 'number', label: 'Amount (+/-)', key: 'amount', value: 100 }],
            onSubmit(v) {
                const amount = Number(v.amount) || 0; if (!amount) return toast('Enter an amount.', 'error');
                call('admin:giveRep', { gang, amount }).then(r => {
                    if (!r.ok) return toast(errMsg(r.error), 'error');
                    toast(`REP updated → ${(r.data?.rep || 0).toLocaleString()}.`, 'success');
                });
            }
        });
    });
    on($('#ge-mgr-graffiti'), 'click', () => {
        const gang = S.activeOwner; if (!gang) return;
        call('graffiti:listGang', { gang }).then(r => {
            if (!r.ok) return toast(errMsg(r.error), 'error');
            const list = r.data || [];
            const rows = list.length ? list.map(t => `
                <div class="gm-graf-row" data-graf="${t.id}">
                    <span class="gm-graf-ic"><i class="fa-solid fa-${t.kind === 'image' ? 'image' : 'font'}"></i></span>
                    <span class="gm-graf-txt">${escapeHTML(t.text || t.image || t.url || '—')}</span>
                    <span class="gm-graf-loc mono">${Math.round(t.x)}, ${Math.round(t.y)}</span>
                    <button class="btn btn-ghost btn-sm gm-graf-del" data-graf-del="${t.id}" title="Remove this graffiti"><i class="fa-solid fa-trash"></i></button>
                </div>`).join('') : '<div class="muted" style="padding:10px">No graffiti for this gang.</div>';
            inputDlg({ title: `Graffiti · ${ownerLabel(gang)} (${list.length})`, html: `<div class="gm-graf-list">${rows}</div>`, okLabel: 'Close', single: true });
        });
    });
    on($('#ge-new-gang'),'click', newGang);
    // Overview sidebar entry: deselect the gang + show the map.
    // Guard: leaving a gang with unsaved edits prompts (Save / Discard / Cancel) first.
    on(overviewBtn, 'click', () => { if (S.view === 'overview' && !S.activeOwner) return; guard(showOverview); });
    on($('#ge-manager-btn'), 'click', () => { if (S.view === 'manager') return; guard(showManager); });
    // Manager board row actions (edit zones / give REP / graffiti).
    on($('#ge-mgr-board'), 'click', e => {
        const act = e.target.closest('[data-mgr-act]'); if (!act) return;
        const row = act.closest('[data-mgr-gang]'); const gang = row && row.dataset.mgrGang; if (!gang) return;
        const which = act.dataset.mgrAct;
        if (which === 'edit') { guard(() => selectOwner(gang)); return; }
        if (which === 'delete') {
            deleteGangFlow(gang, row.querySelector('.ge-mgr-name')?.textContent || gang);
            return;
        }
        if (which === 'rep') {
            inputDlg({
                title: `Reputation · ${ownerLabel(gang)}`,
                html: `<div class="muted" style="margin-bottom:8px">Add reputation (use a negative amount to remove).</div>`,
                fields: [{ type: 'number', label: 'Amount (+/-)', key: 'amount', value: 100 }],
                onSubmit(v) {
                    const amount = Number(v.amount) || 0; if (!amount) return toast('Enter an amount.', 'error');
                    call('admin:giveRep', { gang, amount }).then(r => {
                        if (!r.ok) return toast(errMsg(r.error), 'error');
                        toast(`REP updated → ${(r.data?.rep || 0).toLocaleString()}.`, 'success'); renderManager();
                    });
                }
            });
            return;
        }
        if (which === 'graffiti') {
            call('graffiti:listGang', { gang }).then(r => {
                if (!r.ok) return toast(errMsg(r.error), 'error');
                const list = r.data || [];
                const rows = list.length ? list.map(t => `
                    <div class="gm-graf-row" data-graf="${t.id}">
                        <span class="gm-graf-ic"><i class="fa-solid fa-${t.kind === 'image' ? 'image' : 'font'}"></i></span>
                        <span class="gm-graf-txt">${escapeHTML(t.text || t.image || t.url || '—')}</span>
                        <span class="gm-graf-loc mono">${Math.round(t.x)}, ${Math.round(t.y)}</span>
                        <button class="btn btn-ghost btn-sm gm-graf-del" data-graf-del="${t.id}" title="Remove this graffiti"><i class="fa-solid fa-trash"></i></button>
                    </div>`).join('') : '<div class="muted" style="padding:10px">No graffiti for this gang.</div>';
                inputDlg({ title: `Graffiti · ${ownerLabel(gang)} (${list.length})`, html: `<div class="gm-graf-list">${rows}</div>`, okLabel: 'Close', single: true });
            });
        }
    });

    document.addEventListener('keydown', e => {
        if (!S.open) return;
        const tag = (e.target && e.target.tagName) || '';
        const inField = tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT';
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 's') { e.preventDefault(); saveAll(); return; }
        if ((e.key === 'Delete' || e.key === 'Backspace') && S.selected && !inField) {
            const n = S.nodes.find(x => x.id === S.selected);
            if (n && n.type !== 'owner') { e.preventDefault(); removeNode(n); }
        }
        if ((e.key === '+' || (e.key === '=' && e.shiftKey))) { e.preventDefault(); zoomBy(1.15); }
        if ((e.key === '-' || e.key === '_'))                 { e.preventDefault(); zoomBy(1 / 1.15); }
    });

    // ─── tiny hyperscript helper (scoped to the editor) ───
    function el(tag, attrs, ...kids) {
        const n = document.createElement(tag);
        if (attrs) for (const k in attrs) {
            const v = attrs[k];
            if (v == null) continue;
            if (k === 'class') n.className = v;
            else if (k === 'dataset') for (const d in v) n.dataset[d] = v[d];
            else if (k === 'style') n.setAttribute('style', v);
            else if (k.slice(0, 2) === 'on' && typeof v === 'function') n.addEventListener(k.slice(2), v);
            else n.setAttribute(k, v);
        }
        kids.flat().forEach(c => { if (c == null) return; n.appendChild(typeof c === 'string' ? document.createTextNode(c) : c); });
        return n;
    }

    function drawIsOpen() { return !!(drawRoot && !drawRoot.hidden); }
    return { open, close, isOpen, restore, drawIsOpen, closeDraw,
             requestClose, confirmIsOpen, hideConfirm,
             newGangIsOpen: ngIsOpen, closeNewGang: ngClose };
})();

// ════════════════════════════════════════════════════════════
// PLACEMENT HUD — top-center keycap panel during in-world picks.
// ════════════════════════════════════════════════════════════
const PlacementHUD = (() => {
    const overlay  = $('#placement-hud');
    const eyebrow  = $('#placement-eyebrow');
    const titleEl  = $('#placement-title');
    const keysRoot = $('#placement-keys');
    function show(p) {
        if (!overlay) return;
        if (eyebrow) eyebrow.textContent = (p && p.eyebrow) || 'Placement';
        if (titleEl) titleEl.textContent = (p && p.title) || 'Pick a spot in the world';
        if (keysRoot) {
            keysRoot.innerHTML = '';
            ((p && p.keys) || []).forEach(k => {
                const span = document.createElement('span');
                span.className = 'placement-key';
                span.innerHTML = `<kbd>${escapeHTML(k.key || '')}</kbd><span>${escapeHTML(k.label || '')}</span>`;
                keysRoot.appendChild(span);
            });
        }
        overlay.hidden = false;
    }
    function hide() { if (overlay) overlay.hidden = true; }
    return { show, hide };
})();

/* ============================================================
   PLAYERS-FOR-MAP polling on overview (members map blips)
   ============================================================ */
setInterval(() => {
    if (state.open && state.activeTab === 'overview') refreshPlayersForMap();
}, 3000);

/* ============================================================
   COMMAND WHEEL — bespoke segmented tactical wheel
   ────────────────────────────────────────────────────────────
   A donut of SVG annular-sector wedges — one segment per item.
   The cursor's angle from the wheel centre picks the active wedge
   (atan2); the active wedge fills with a brand gradient, glows and
   extrudes outward along its bisector. A glass hub in the donut
   hole mirrors the active item. Submenus morph the wheel in place.

   Transport (matches the Lua — UNCHANGED):
     IN  radial_open    { items:<tree>, binds:{ open, actions:{id:KEY} } }
         radial_close   {}
         radial_hostage { show }
     OUT radial_select  { id }   (leaf clicked → then close)
         radial_dismiss {}       (esc / right-click / hub-close / vignette)
         radial_getbinds         → { open, actions }
         radial_setbind { target, key } → { ok, binds }
   Items tree node: { id, icon (full FA class), label, desc, children? }
   A node WITH children = submenu; WITHOUT = leaf. id:'settings' = binds view.
   ============================================================ */
const CommandWheel = (() => {
    // ── geometry (SVG user units; viewBox is 460×460) ──
    const VIEW   = 460;
    const CX     = VIEW / 2;     // 230
    const R_OUT  = 210;          // outer radius of the donut
    const R_IN   = 96;           // inner hole radius
    const R_ICON = 150;          // radius the icon overlays sit at
    const GAP    = 1.1;          // angular gap between wedges (deg) for the divider feel
    const EXTRUDE = 8;           // px the active wedge pushes outward

    // Allowed key NAMES for rebinding (must match the Lua RegisterKeyMapping side).
    const KEY_CHOICES = [
        'F1','F2','F3','F5','F6','F7','F8','F9','F10','F11','F12',
        'E','G','H','X','Z','B','V','CAPSLOCK','LEFTALT','LEFTCTRL','LEFTSHIFT',
        'NUM0','NUM1','NUM2','NUM3','NUM4','NUM5','NUM6','NUM7','NUM8','NUM9',
    ];
    // Friendly labels for the bind rows (top-level action ids → text/icon).
    const ACTION_META = {
        cuff:     { icon: 'fa-solid fa-handcuffs',       label: 'Cuff / uncuff' },
        bag:      { icon: 'fa-solid fa-mask',            label: 'Bag head' },
        trunk:    { icon: 'fa-solid fa-car-rear',        label: 'Put in trunk' },
        carry:    { icon: 'fa-solid fa-people-carry-box',label: 'Carry / fireman' },
        escort:   { icon: 'fa-solid fa-person-walking-arrow-right',label: 'Escort' },
        flattire: { icon: 'fa-solid fa-burst',           label: 'Flatten tires' },
        hostage:  { icon: 'fa-solid fa-user-lock',       label: 'Take hostage' },
        search:   { icon: 'fa-solid fa-magnifying-glass',label: 'Search player' },
    };
    const SVGNS = 'http://www.w3.org/2000/svg';

    const S = {
        open: false,
        items: [],            // root tree
        stack: [],            // breadcrumb of parent nodes (for submenus)
        binds: { open: '', actions: {} },
        view: 'wheel',        // 'wheel' | 'keys'
        active: -1,           // index of the angle-selected segment
        segCount: 0,          // current wedge count
        pickTarget: null,     // current key-picker target
    };

    // ── element cache ──
    let el = {};
    function cache() {
        el = {
            overlay : $('#cw-overlay'),
            vignette: $('#cw-vignette'),
            aura    : $('#cw-aura'),
            stage   : $('#cw-stage'),
            wheel   : $('#cw-wheel'),
            svg     : $('#cw-svg'),
            segs    : $('#cw-segs'),
            ticks   : $('#cw-ticks'),
            icons   : $('#cw-icons'),
            hub     : $('#cw-hub'),
            hubIcon : $('#cw-hub-icon'),
            hubLabel: $('#cw-hub-label'),
            hubDesc : $('#cw-hub-desc'),
            close   : $('#cw-close'),
            back    : $('#cw-back'),
            keys    : $('#cw-keys'),
            keysList: $('#cw-keys-list'),
            keysBack: $('#cw-keys-back'),
            picker  : $('#cw-picker'),
            pickGrid: $('#cw-picker-grid'),
            pickTitle: $('#cw-picker-title'),
        };
    }

    // current list of nodes shown on the wheel
    function currentNodes() {
        if (!S.stack.length) return S.items;
        const top = S.stack[S.stack.length - 1];
        return Array.isArray(top.children) ? top.children : [];
    }

    /* ── trig helper: polar→cartesian. 0deg = straight up, clockwise. ── */
    function pol(angDeg, radius) {
        const a = (angDeg - 90) * Math.PI / 180;
        return { x: CX + radius * Math.cos(a), y: CX + radius * Math.sin(a) };
    }
    /* ── annular-sector (donut wedge) path between two angles ── */
    function wedgePath(a0, a1, rOut, rIn) {
        const large = (a1 - a0) % 360 > 180 ? 1 : 0;
        const oS = pol(a0, rOut), oE = pol(a1, rOut);
        const iE = pol(a1, rIn),  iS = pol(a0, rIn);
        return [
            `M ${oS.x.toFixed(2)} ${oS.y.toFixed(2)}`,
            `A ${rOut} ${rOut} 0 ${large} 1 ${oE.x.toFixed(2)} ${oE.y.toFixed(2)}`,
            `L ${iE.x.toFixed(2)} ${iE.y.toFixed(2)}`,
            `A ${rIn} ${rIn} 0 ${large} 0 ${iS.x.toFixed(2)} ${iS.y.toFixed(2)}`,
            'Z',
        ].join(' ');
    }

    /* ── default hub text for the active view ── */
    function hubDefault() {
        if (S.stack.length) {
            const parent = S.stack[S.stack.length - 1];
            return { label: parent.label || 'Submenu', desc: parent.desc || 'choose an action', icon: parent.icon || 'fa-solid fa-skull' };
        }
        return { label: 'Gang Actions', desc: 'hover an action', icon: 'fa-solid fa-skull' };
    }
    function setHubIcon(faClass) {
        if (el.hubIcon) el.hubIcon.innerHTML = `<i class="${escapeAttr(faClass || 'fa-solid fa-skull')}"></i>`;
    }
    function setHub(label, desc, icon) {
        if (el.hubLabel) el.hubLabel.textContent = label || '';
        if (el.hubDesc)  el.hubDesc.textContent  = desc  || '';
        if (icon !== undefined) setHubIcon(icon);
    }
    function resetHub() { const d = hubDefault(); setHub(d.label, d.desc, d.icon); }

    /* ── RENDER the wheel of wedges ── */
    function renderWheel(stagger) {
        const nodes = currentNodes();
        const n = nodes.length || 1;
        S.segCount = n;
        const step = 360 / n;

        // outer rim micro-ticks (one per wedge boundary + a few subdivisions)
        let tickHTML = '';
        for (let i = 0; i < n; i++) {
            const a = i * step;
            const p0 = pol(a, R_OUT + 6), p1 = pol(a, R_OUT + 12);
            tickHTML += `<line x1="${p0.x.toFixed(1)}" y1="${p0.y.toFixed(1)}" x2="${p1.x.toFixed(1)}" y2="${p1.y.toFixed(1)}" class="cw-tick"></line>`;
        }
        if (el.ticks) el.ticks.innerHTML = tickHTML;

        // wedge <path>s
        let segHTML = '';
        nodes.forEach((node, i) => {
            const a0 = i * step + GAP / 2;
            const a1 = (i + 1) * step - GAP / 2;
            const mid = i * step + step / 2;
            const bx = Math.cos((mid - 90) * Math.PI / 180);
            const by = Math.sin((mid - 90) * Math.PI / 180);
            const hasKids = Array.isArray(node.children) && node.children.length > 0;
            const delay = stagger ? (i * 26) : 0;
            const d = wedgePath(a0, a1, R_OUT, R_IN);
            segHTML += `<path class="cw-seg${hasKids ? ' has-kids' : ''}" data-idx="${i}" d="${d}" style="--d:${delay}ms; --bx:${bx.toFixed(3)}; --by:${by.toFixed(3)}"></path>`;
        });
        if (el.segs) el.segs.innerHTML = segHTML;

        // HTML icon overlays at each wedge mid-angle
        if (el.icons) {
            el.icons.innerHTML = nodes.map((node, i) => {
                const mid = i * step + step / 2;
                const bx = Math.cos((mid - 90) * Math.PI / 180);
                const by = Math.sin((mid - 90) * Math.PI / 180);
                // position is % of the wheel box (R_ICON / R_OUT*... -> use VIEW scale)
                const px = (CX + bx * R_ICON) / VIEW * 100;
                const py = (CX + by * R_ICON) / VIEW * 100;
                const hasKids = Array.isArray(node.children) && node.children.length > 0;
                const delay = stagger ? (i * 26 + 60) : 0;
                const big = n <= 7; // tiny label only on roomy wheels
                // outward direction of this wedge, as an angle for the submenu arrow
                const ang = (mid - 90).toFixed(1);
                return `
                <div class="cw-ic" data-idx="${i}"
                     style="left:${px.toFixed(2)}%; top:${py.toFixed(2)}%; --bx:${bx.toFixed(3)}; --by:${by.toFixed(3)}; --ang:${ang}deg; --d:${delay}ms">
                    <i class="${escapeAttr(node.icon || 'fa-solid fa-circle')}"></i>
                    ${big ? `<span class="cw-ic-label">${escapeHTML((node.label || '').split(/\s|\//)[0])}</span>` : ''}
                    ${hasKids ? '<span class="cw-ic-more"><i class="fa-solid fa-angle-right"></i></span>' : ''}
                </div>`;
            }).join('');
        }

        S.active = -1;
        if (el.back)  el.back.hidden  = S.stack.length === 0;
        if (el.close) el.close.hidden = S.stack.length !== 0;
    }

    /* ── set which wedge is active (from mouse angle or keyboard) ── */
    function setActive(idx) {
        const nodes = currentNodes();
        if (idx === S.active) return;
        S.active = idx;
        // segments
        $$('.cw-seg', el.segs).forEach(p => p.classList.toggle('active', Number(p.dataset.idx) === idx));
        $$('.cw-ic', el.icons).forEach(ic => ic.classList.toggle('active', Number(ic.dataset.idx) === idx));
        // hub mirrors the active item, else defaults
        if (idx >= 0 && nodes[idx]) {
            const node = nodes[idx];
            const hasKids = Array.isArray(node.children) && node.children.length;
            setHub(node.label || '', node.desc || (hasKids ? 'open submenu' : 'select'), node.icon);
            if (el.hub) el.hub.classList.add('focus');
        } else {
            resetHub();
            if (el.hub) el.hub.classList.remove('focus');
        }
    }

    /* ── angle of the cursor relative to wheel centre → wedge index ── */
    function indexFromPoint(clientX, clientY) {
        if (!el.wheel) return -1;
        const r = el.wheel.getBoundingClientRect();
        const cx = r.left + r.width / 2;
        const cy = r.top + r.height / 2;
        const dx = clientX - cx, dy = clientY - cy;
        const dist = Math.hypot(dx, dy);
        // Only select when the cursor is actually OVER the ring band (the wedge),
        // not merely pointing in its direction from far away: reject the inner hub
        // hole AND anything beyond the outer rim.
        const px2unit = r.width / VIEW;
        if (dist < R_IN * px2unit * 0.92) return -1;
        if (dist > R_OUT * px2unit * 1.04) return -1;
        // angle: 0 = up, clockwise to match the wedges
        let ang = Math.atan2(dx, -dy) * 180 / Math.PI; // note (dx, -dy) makes up=0, CW positive
        if (ang < 0) ang += 360;
        const n = S.segCount || 1;
        return Math.floor(ang / (360 / n)) % n;
    }

    /* ── view transitions (wheel ↔ submenu ↔ keybinds) ── */
    function showWheel(animate) {
        S.view = 'wheel';
        if (el.keys)  el.keys.hidden = true;
        if (el.wheel) el.wheel.hidden = false;
        hidePicker();
        if (el.wheel && animate) { el.wheel.classList.remove('assemble'); void el.wheel.offsetWidth; el.wheel.classList.add('assemble'); }
        renderWheel(animate);
        resetHub();
        if (el.hub) el.hub.classList.remove('focus');
    }
    function openNode(node) { S.stack.push(node); showWheel(true); }
    function goBack() {
        if (S.view === 'keys') { showWheel(true); return; }
        if (S.stack.length) { S.stack.pop(); showWheel(true); }
    }

    /* ── KEYBINDS view ── */
    function bindableActionIds() {
        return S.items.map(it => it.id).filter(id => id && id !== 'settings');
    }
    function keyChip(key) {
        const k = (key && String(key).trim()) ? String(key).trim() : '';
        return `<button class="cw-keychip${k ? '' : ' empty'}" data-keychip>${k ? escapeHTML(k) : '—'}</button>`;
    }
    function renderKeys() {
        if (!el.keysList) return;
        const rows = [];
        rows.push(`
            <div class="cw-key-row" data-target="open">
                <span class="cw-key-row-ic"><i class="fa-solid fa-bullseye"></i></span>
                <div class="cw-key-row-txt"><strong>Open menu</strong><span>Toggles the command wheel</span></div>
                ${keyChip(S.binds.open)}
            </div>`);
        bindableActionIds().forEach(id => {
            const meta = ACTION_META[id] || { icon: 'fa-solid fa-keyboard', label: id };
            rows.push(`
                <div class="cw-key-row" data-target="${escapeAttr(id)}">
                    <span class="cw-key-row-ic"><i class="${escapeAttr(meta.icon)}"></i></span>
                    <div class="cw-key-row-txt"><strong>${escapeHTML(meta.label)}</strong><span class="mono">${escapeHTML(id)}</span></div>
                    ${keyChip(S.binds.actions ? S.binds.actions[id] : '')}
                </div>`);
        });
        el.keysList.innerHTML = rows.join('');
    }
    function showKeys() {
        S.view = 'keys';
        hidePicker();
        if (el.wheel) el.wheel.hidden = true;
        if (el.keys)  { el.keys.hidden = false; el.keys.classList.remove('in'); void el.keys.offsetWidth; el.keys.classList.add('in'); }
        renderKeys();
    }

    /* ── KEY PICKER popover ── */
    function showPicker(target, anchorBtn) {
        S.pickTarget = target;
        const allowNone = target !== 'open';
        if (el.pickTitle) el.pickTitle.textContent = target === 'open' ? 'Open menu key' : ((ACTION_META[target]?.label) || target);
        if (el.pickGrid) {
            const cur = target === 'open' ? S.binds.open : (S.binds.actions ? S.binds.actions[target] : '');
            let html = KEY_CHOICES.map(k =>
                `<button class="cw-keyopt${k === cur ? ' active' : ''}" data-key="${escapeAttr(k)}">${escapeHTML(k)}</button>`
            ).join('');
            if (allowNone) html += `<button class="cw-keyopt none${!cur ? ' active' : ''}" data-key="">None</button>`;
            el.pickGrid.innerHTML = html;
        }
        if (el.picker) {
            el.picker.hidden = false;
            if (anchorBtn && el.stage) {
                const sb = el.stage.getBoundingClientRect();
                const ab = anchorBtn.getBoundingClientRect();
                const left = ab.left - sb.left + ab.width / 2;
                const top  = ab.bottom - sb.top + 8;
                el.picker.style.left = Math.max(132, Math.min(sb.width - 132, left)) + 'px';
                el.picker.style.top  = Math.min(sb.height - 40, top) + 'px';
            }
        }
    }
    function hidePicker() { if (el.picker) el.picker.hidden = true; S.pickTarget = null; }

    function applyBind(target, key) {
        post('radial_setbind', { target, key }).then(r => {
            const res = r || {};
            if (res.binds) {
                S.binds = { open: res.binds.open || '', actions: res.binds.actions || {} };
            } else if (res.ok !== false) {
                if (target === 'open') S.binds.open = key;
                else { S.binds.actions = S.binds.actions || {}; if (key) S.binds.actions[target] = key; else delete S.binds.actions[target]; }
            }
            if (res.ok === false) toast('Could not set that key.', 'error');
            renderKeys();
        });
    }

    /* ── activate a node (the active wedge / a clicked wedge / a number key) ── */
    function activate(node) {
        if (!node) return;
        if (node.id === 'settings') { showKeys(); return; }
        if (Array.isArray(node.children) && node.children.length) { openNode(node); return; }
        selectLeaf(node.id);
    }
    function selectLeaf(id) { post('radial_select', { id }); close(true); }
    function dismiss()      { post('radial_dismiss', {});    close(true); }

    /* ── OPEN / CLOSE ── */
    function open(data) {
        cache();
        S.items = Array.isArray(data.items) ? data.items : [];
        S.binds = {
            open: (data.binds && data.binds.open) || '',
            actions: (data.binds && data.binds.actions) || {},
        };
        S.stack = [];
        S.view  = 'wheel';
        S.open  = true;
        if (!el.overlay) return;
        el.overlay.hidden = false;
        el.overlay.classList.remove('closing');
        void el.overlay.offsetWidth;
        el.overlay.classList.add('opening');
        // fire the expanding aura ring
        if (el.aura) { el.aura.classList.remove('fire'); void el.aura.offsetWidth; el.aura.classList.add('fire'); }
        showWheel(true);
    }
    function close(skipAnim) {
        if (!S.open) return;
        S.open = false;
        hidePicker();
        if (!el.overlay) return;
        if (skipAnim) {
            el.overlay.classList.remove('opening', 'closing');
            el.overlay.hidden = true;
            return;
        }
        el.overlay.classList.remove('opening');
        el.overlay.classList.add('closing');
        setTimeout(() => { if (!S.open && el.overlay) { el.overlay.hidden = true; el.overlay.classList.remove('closing'); } }, 180);
    }
    function onEscape() {
        if (S.view === 'keys') { showWheel(true); return; }
        if (S.stack.length) { goBack(); return; }
        dismiss();
    }

    /* ── HOSTAGE HUD (independent) ── */
    function hostage(show) {
        const h = $('#cw-hostage'); if (!h) return;
        if (show) {
            h.hidden = false;
            h.classList.remove('out'); void h.offsetWidth; h.classList.add('in');
        } else {
            h.classList.remove('in'); h.classList.add('out');
            setTimeout(() => { if (h.classList.contains('out')) h.hidden = true; }, 240);
        }
    }

    /* ── EVENT WIRING (delegated, bound once) ── */
    function wire() {
        const ov = $('#cw-overlay'); if (!ov || ov.dataset.wired) return;
        ov.dataset.wired = '1';

        // mouse-angle selection across the whole wheel
        on($('#cw-wheel'), 'mousemove', e => {
            if (!S.open || S.view !== 'wheel') return;
            setActive(indexFromPoint(e.clientX, e.clientY));
        });
        on($('#cw-wheel'), 'mouseleave', () => { if (S.view === 'wheel') setActive(-1); });

        // direct hover over an icon overlay also selects (covers the hole edge)
        on($('#cw-icons'), 'mousemove', e => {
            const ic = e.target.closest('.cw-ic'); if (!ic) return;
            setActive(Number(ic.dataset.idx));
        });

        // click handling
        ov.addEventListener('click', e => {
            if (e.target.closest('#cw-vignette')) { dismiss(); return; }
            if (e.target.closest('#cw-close'))    { dismiss(); return; }
            if (e.target.closest('#cw-back') || e.target.closest('#cw-keys-back')) { goBack(); return; }

            const opt = e.target.closest('.cw-keyopt');
            if (opt) { applyBind(S.pickTarget, opt.dataset.key || ''); hidePicker(); return; }
            if (e.target.closest('#cw-picker-x')) { hidePicker(); return; }

            const chip = e.target.closest('[data-keychip]');
            if (chip) { const row = chip.closest('.cw-key-row'); if (row) showPicker(row.dataset.target, chip); return; }

            // a direct click on an icon overlay
            const ic = e.target.closest('.cw-ic');
            if (ic) { activate(currentNodes()[Number(ic.dataset.idx)]); return; }

            // clicking anywhere on the wheel selects the angle-active wedge
            if (e.target.closest('#cw-wheel') && S.view === 'wheel') {
                // ignore clicks inside the hub hole (those are handled by close/back above)
                if (e.target.closest('#cw-hub')) return;
                if (S.active >= 0) { activate(currentNodes()[S.active]); return; }
            }
        });

        // right-click anywhere → back if in a submenu/keys, else dismiss
        ov.addEventListener('contextmenu', e => {
            e.preventDefault();
            if (S.view === 'keys' || S.stack.length) { goBack(); return; }
            dismiss();
        });

        // number keys 1..N pick the Nth segment (wheel view only)
        document.addEventListener('keydown', e => {
            if (!S.open || S.view !== 'wheel') return;
            const num = parseInt(e.key, 10);
            if (!num || num < 1) return;
            const node = currentNodes()[num - 1]; if (!node) return;
            e.preventDefault();
            activate(node);
        });
    }
    wire();

    return {
        open, close, hostage, onEscape,
        isOpen: () => S.open,
        // exposed for getbinds parity (Lua may also pull via radial_getbinds)
        getBinds: () => ({ open: S.binds.open, actions: S.binds.actions }),
    };
})();

/* ============================================================
   GLOBAL TOOLTIPS — styled help text on hover for any element with
   a `title` (or `data-tip`). The bubble lives on <body> with a fixed
   position + huge z-index, so it is NEVER clipped by an overflow:hidden
   parent. Flips above/below and clamps to the viewport at the edges.
   ============================================================ */
(function initTooltips() {
    function start() {
        if (document.getElementById('apex-tip')) return;
        const tip = document.createElement('div');
        tip.id = 'apex-tip';
        tip.setAttribute('aria-hidden', 'true');
        document.body.appendChild(tip);
        let cur = null;

        const textOf = el => el.getAttribute('data-tip') || el.getAttribute('title') || '';
        function place(el) {
            const r = el.getBoundingClientRect();
            const tw = tip.offsetWidth, th = tip.offsetHeight;
            let left = r.left + r.width / 2 - tw / 2;
            let top = r.top - th - 9, pos = 'top';
            if (top < 6) { top = r.bottom + 9; pos = 'bottom'; }        // no room above → below
            left = Math.max(6, Math.min(window.innerWidth - tw - 6, left));  // clamp horizontally
            top = Math.max(6, Math.min(window.innerHeight - th - 6, top));   // clamp vertically
            tip.style.left = Math.round(left) + 'px';
            tip.style.top = Math.round(top) + 'px';
            tip.dataset.place = pos;
            tip.style.setProperty('--tip-x', Math.round(r.left + r.width / 2 - left) + 'px');
        }
        // Icon-only = the element shows no visible text label (just an <i>/svg).
        // Buttons that already have a text label don't need help on hover.
        const isIconOnly = el => (el.textContent || '').trim() === '';
        function show(el) {
            const text = textOf(el); if (!text) return;
            // move native title → data-tip so the browser's own (clippable,
            // delayed) tooltip never appears alongside ours.
            if (el.hasAttribute('title')) { el.setAttribute('data-tip', el.getAttribute('title')); el.removeAttribute('title'); }
            cur = el;
            tip.textContent = text;
            place(el);
            tip.classList.add('show');
        }
        function hide() { if (!cur) return; cur = null; tip.classList.remove('show'); }

        document.addEventListener('mouseover', e => {
            const el = e.target.closest && e.target.closest('[title], [data-tip]');
            if (el) {
                if (!isIconOnly(el)) {
                    // has a visible text label → no help tooltip; also kill the
                    // native browser one so nothing pops up.
                    if (el.hasAttribute('title')) el.removeAttribute('title');
                    if (cur) hide();
                    return;
                }
                if (el !== cur) show(el);
            } else if (cur) hide();
        });
        document.addEventListener('mouseout', e => {
            if (!cur) return;
            const to = e.relatedTarget;
            if (!to || !cur.contains(to)) {
                if (!to || !(to.closest && to.closest('[title], [data-tip]') === cur)) hide();
            }
        });
        document.addEventListener('mousedown', hide, true);   // hide on click
        window.addEventListener('scroll', () => { if (cur) place(cur); }, true);
        window.addEventListener('resize', () => { if (cur) place(cur); });
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start);
    else start();
})();
