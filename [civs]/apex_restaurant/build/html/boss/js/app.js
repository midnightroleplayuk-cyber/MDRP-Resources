/* ============================================================
   Apex Boss Menu — Command Center UI
   ─────────────────────────────────────────────────────────────
   • Vertical rail navigation
   • Tactical map ON the Overview (centerpiece)
   • Same #1F5EFF accent as apex_banking, different look
   • All DOM access guarded with safe selectors (no null .classList)
   ============================================================ */

// ── Safe selectors (return null silently instead of crashing) ──
const $  = (sel, root = document) => root && root.querySelector ? root.querySelector(sel) : null;
const $$ = (sel, root = document) => Array.from((root || document).querySelectorAll(sel));
function on(el, ev, fn) { if (el) el.addEventListener(ev, fn); }

// Embedded inside apex_restaurant (iframe). Host resource is the restaurant,
// and every NUI callback is prefixed `bf_` so it never collides with the
// restaurant's own callbacks.
const RESOURCE_NAME = (typeof GetParentResourceName === 'function')
    ? GetParentResourceName()
    : 'apex_restaurant';

function post(name, payload) {
    return fetch(`https://${RESOURCE_NAME}/bf_${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload || {}),
    }).then(r => r.json().catch(() => ({}))).catch(() => ({}));
}
function call(name, payload) {
    return post('call', { name, payload });
}

const state = {
    open      : false,
    you       : null,
    job       : null,
    config    : null,
    theme     : null,
    activeTab : 'overview',
    employees : [],
    players   : [],
    notes     : [],
    logs      : [],
    payroll   : null,
    treasury  : 0,
    treasuryHistory: [],
    map       : null,
    mapBuilt  : false,
    playerMarkers: [],
    timers    : [],
    overviewMapMode: 'job',
    logsCategory: '',
};

function escapeHTML(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
        '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
    })[c]);
}
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
function fmtDur(secs) {
    if (secs <= 0) return 'now';
    const m = Math.floor(secs / 60), s = secs % 60;
    if (m <= 0) return `${s}s`;
    if (m < 60) return `${m}m`;
    const h = Math.floor(m / 60); const rm = m % 60;
    return `${h}h ${rm}m`;
}

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

/* ============================================================
   OPEN / CLOSE
   ============================================================ */
/* Server-wide theme default for one property.
   Precedence (lowest → highest of the SHARED defaults):
     Config.theme  (state.config.theme)  — the baseline EVERY player sees
     DB override   (state.theme)         — an optional admin-set global
   A player's OWN Settings choices (localStorage) are layered on top of
   this by every caller, so personal tweaks stay personal while
   Config.theme remains the default appearance for everyone. */
function serverThemeDefault(key, fallback) {
    const dbv = state.theme && state.theme[key];
    if (dbv && dbv !== '') return dbv;
    const cfgv = state.config && state.config.theme && state.config.theme[key];
    if (cfgv && cfgv !== '') return cfgv;
    return fallback;
}

function openShell(data) {
    state.you    = data.you    || {};
    state.job    = data.job    || { name: '', label: 'Unemployed', grades: [] };
    state.config = data.config || {};
    state.theme  = data.theme  || {};
    state.open   = true;

    // Personal choice (localStorage) wins; otherwise fall back to the
    // server-wide default driven by Config.theme.
    applyTheme(localStorage.getItem('boss-theme-color') || serverThemeDefault('brand', '#1F5EFF'));
    applyBackgroundRamp(localStorage.getItem('boss-theme-bg') || serverThemeDefault('bg', '#131314'));
    applySize(localStorage.getItem('boss-theme-size') || 'm');
    applyRailCollapsed(localStorage.getItem('boss-rail-collapsed') === '1');
    applyOpacity(localStorage.getItem('boss-theme-opacity') || 100);

    setText('#bid-name', state.you.name);
    setText('#bid-grade', `${state.you.gradeLabel || ('Grade ' + (state.you.grade || 0))}`);
    setText('#boss-job-label', state.job.label);
    setText('#set-name', state.you.name);
    setText('#set-job', state.job.label);
    setText('#set-grade', `Grade ${state.you.grade || 0}`);
    setText('#set-id', state.you.id);
    renderIdentity();

    const overlay = $('#boss-overlay'); if (overlay) overlay.hidden = false;
    setTab('overview', true);
    primeColorPresets();
    startClock();
    refreshAll();
    startAutoRefresh();
}
function closeShell() {
    state.open = false;
    const overlay = $('#boss-overlay'); if (overlay) overlay.hidden = true;
    if (state.map) {
        try { state.map.remove(); } catch (_) {}
        state.map = null; state.mapBuilt = false;
    }
    state.timers.forEach(clearInterval); state.timers = [];
}
function setText(sel, value) {
    const el = $(sel);
    if (el) el.textContent = (value == null || value === '') ? '' : String(value);
}

/* ============================================================
   TABS — vertical rail
   ============================================================ */
const TAB_LABELS = {
    overview : { icon: 'gauge-high',          eyebrow: 'Boss · Live',    title: 'Command Center' },
    analytics: { icon: 'chart-line',          eyebrow: 'Business',       title: 'Analytics' },
    employees: { icon: 'users',               eyebrow: 'Workforce',      title: 'Employees' },
    ranks    : { icon: 'layer-group',         eyebrow: 'Workforce',      title: 'Ranks & wages' },
    payroll  : { icon: 'money-check-dollar',  eyebrow: 'Finance',        title: 'Payroll' },
    treasury : { icon: 'vault',               eyebrow: 'Finance',        title: 'Treasury' },
    players  : { icon: 'map-location-dot',    eyebrow: 'Live',           title: 'Players online' },
    stash    : { icon: 'boxes-stacked',       eyebrow: 'Operations',     title: 'Private stash' },
    comms    : { icon: 'comments',            eyebrow: 'Comms',          title: 'Broadcast & notes' },
    logs     : { icon: 'clock-rotate-left',   eyebrow: 'Audit',          title: 'Audit log' },
    menu     : { icon: 'utensils',            eyebrow: 'Storefront',     title: 'Customer menu' },
    recipes  : { icon: 'flask',               eyebrow: 'Kitchen',        title: 'Recipes' },
    settings : { icon: 'sliders',             eyebrow: 'Profile',        title: 'Settings' },
};

function setTab(name, force) {
    if (!force && state.activeTab === name) return;
    if (!TAB_LABELS[name]) name = 'overview';
    state.activeTab = name;

    $$('.rail-btn').forEach(b => b.classList && b.classList.toggle('active', b.dataset.tab === name));
    $$('.pane').forEach(p => p.hidden = p.dataset.pane !== name);

    const meta = TAB_LABELS[name];
    const icEl  = $('#boss-tab-icon');
    if (icEl) icEl.className = 'fa-solid fa-' + meta.icon;
    setText('#boss-tab-eyebrow', meta.eyebrow);
    setText('#boss-tab-title',   meta.title);

    // Lazy refresh & map mount
    if (name === 'overview')  { ensureMap(); renderMapMarkers(); }
    if (name === 'analytics') refreshAnalytics();
    if (name === 'employees') renderEmployees();
    if (name === 'ranks')     renderRanks();
    if (name === 'payroll')   refreshPayroll();
    if (name === 'treasury')  refreshTreasury();
    if (name === 'players')   { if (!state.employees.length) refreshEmployees(); refreshPlayers(); startPlayersPoll(); }
    if (name === 'comms')     { refreshNotes(); refreshLogs(); }
    if (name === 'logs')      refreshLogs();
    if (name === 'menu')      openMenuEditor();
    if (name === 'recipes')   openRecipesEditor();
    if (name === 'stash')     refreshStash();
}

document.addEventListener('click', e => {
    const legacy = e.target.closest('[data-legacy]');
    if (legacy) { post('open_legacy', { tab: legacy.dataset.legacy }); return; }
    const rail = e.target.closest('.rail-btn');
    if (rail && rail.dataset.tab) { setTab(rail.dataset.tab); return; }
    const jump = e.target.closest('[data-jump-tab]');
    if (jump) { setTab(jump.dataset.jumpTab); return; }
});

on($('#boss-close'),   'click', () => post('close'));
on($('#boss-refresh'), 'click', refreshAll);

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
function refreshAll() {
    refreshEmployees();
    refreshTreasury();
    refreshPayroll();
    refreshLogs();
    refreshPlayers();
    refreshNotes();
}
function startAutoRefresh() {
    state.timers.push(setInterval(() => {
        refreshPlayers();
    }, 2500));
    state.timers.push(setInterval(() => {
        refreshTreasury();
        refreshEmployees();
        refreshPayroll();
    }, 12000));
    state.timers.push(setInterval(() => {
        if (state.activeTab !== 'comms') return;
        refreshNotes();
        refreshLogs();
    }, 5000));
}

/* ============================================================
   EMPLOYEES
   ============================================================ */
function refreshEmployees() {
    call('employees:list').then(r => {
        if (!r?.ok) return;
        state.employees = r.data || [];
        const total  = state.employees.length;
        const online = state.employees.filter(e => e.online).length;
        setText('#ov-headcount', total);
        setText('#ov-online',    online);
        setText('#bid-online',   online);
        setText('#bid-headcount',total);
        const railBadge = $('#rail-employees');
        if (railBadge) railBadge.textContent = total;
        if (state.activeTab === 'employees') renderEmployees();
        renderOnlineFeed();
        // If a player profile is open and that player is an employee but its
        // quick-action buttons aren't shown yet (employees arrived after the
        // profile rendered), rebuild it so the buttons appear without a click.
        if (state.activeTab === 'players' && _selectedPlayerId != null) {
            const p = state.players.find(x => String(x.id) === String(_selectedPlayerId));
            const isEmp = p && state.employees.some(e => (e.name || '') === p.name);
            const hasBtns = !!document.querySelector('#player-profile [onclick*="_popPromote"]');
            if (isEmp && !hasBtns) selectPlayer(_selectedPlayerId);
        }
    });
}

function renderOnlineFeed() {
    const root = $('#online-feed-list'); if (!root) return;
    const online = state.employees.filter(e => e.online);
    setText('#online-feed-count', online.length);
    if (online.length === 0) {
        root.innerHTML = `<div class="tx-empty" style="margin:6px;border:none;padding:12px">No one on duty</div>`;
        return;
    }
    root.innerHTML = online.map(e => `
        <div class="feed-row" data-id="${escapeHTML(e.identifier)}" ${e.src ? `data-src="${e.src}"` : ''}>
            <div class="feed-avatar with-pulse">${_empAvatarInner(e)}</div>
            <div class="feed-info">
                <div class="feed-name">${escapeHTML(e.name)}</div>
                <div class="feed-meta">G${e.grade} · ${fmtMoney(e.wage)}/cycle</div>
            </div>
            <button class="feed-locate" data-feed-locate title="Locate">
                <i class="fa-solid fa-location-arrow"></i>
            </button>
        </div>
    `).join('');
    hydrateMugs(online.map(e => e.src).filter(v => v != null));
}

// Inner HTML for an employee avatar: professional initials on the brand
// gradient as the base, with the player's REAL in-game GTA headshot
// swapped in once their ped is streamed (online only). No external
// avatar service / no stock photos — the img carries no src until the
// native headshot resolves, so the initials show until then.
function _empAvatarInner(e){
    const ini = initials(e.name);
    if (e.online && e.src != null){
        return `${ini}<img data-mug="${escapeAttr(e.src)}" alt="" loading="lazy" onerror="this.remove()">`;
    }
    return ini;
}

function renderEmployees() {
    const root  = $('#emp-list'); if (!root) return;
    const filt  = ($('#emp-filter')?.value || 'all');
    const query = ($('#emp-search')?.value || '').toLowerCase().trim();
    const rows  = state.employees.filter(e => {
        if (filt === 'online'  && !e.online) return false;
        if (filt === 'offline' &&  e.online) return false;
        return !query || (e.name || '').toLowerCase().includes(query);
    });
    setText('#emp-stats', `${rows.length} of ${state.employees.length} employees`);
    if (rows.length === 0) {
        root.innerHTML = `<div class="emp-empty">${t('emp_no_employees') || 'No employees match.'}</div>`;
        return;
    }
    root.innerHTML = rows.map(e => `
        <div class="emp-card" data-id="${escapeHTML(e.identifier)}">
            <div class="emp-avatar ${e.online ? 'online' : ''}">${_empAvatarInner(e)}</div>
            <div class="emp-main">
                <div class="emp-name-row">
                    <span class="emp-name">${escapeHTML(e.name || 'Unknown')}</span>
                    <span class="emp-tag ${e.online ? 'online' : ''}">${e.online ? 'Online' : 'Offline'}</span>
                </div>
                <div class="emp-meta">
                    <span>G<strong>${e.grade}</strong></span>
                    <span>Paid <strong>${fmtMoney(e.total_paid || 0)}</strong></span>
                </div>
            </div>
            <span class="emp-wage">${fmtMoney(e.wage)}</span>
            <div class="emp-actions">
                <button class="btn btn-ghost btn-sm" data-act="promote"><i class="fa-solid fa-arrow-up"></i> Promote</button>
                <button class="btn btn-ghost btn-sm" data-act="demote"><i class="fa-solid fa-arrow-down"></i> Demote</button>
                <button class="btn btn-ghost btn-sm" data-act="bonus"><i class="fa-solid fa-gift"></i> Bonus</button>
                <button class="btn btn-ghost btn-sm" data-act="locate" ${e.online ? '' : 'disabled'}><i class="fa-solid fa-location-arrow"></i></button>
                <button class="btn btn-ghost btn-sm" data-act="fire"><i class="fa-solid fa-user-xmark"></i></button>
            </div>
        </div>
    `).join('');
    hydrateMugs(rows.filter(e => e.online && e.src != null).map(e => e.src));
}

document.addEventListener('click', e => {
    const feedLoc = e.target.closest('[data-feed-locate]');
    if (feedLoc) {
        const row = feedLoc.closest('.feed-row');
        if (!row) return;
        const src = Number(row.dataset.src);
        if (src) call('players:locate', { target: src }).then(r => {
            if (r?.ok) toast('Waypoint set', 'success');
        });
        return;
    }
    const card = e.target.closest('.emp-card');
    if (!card) return;
    const act = e.target.closest('[data-act]');
    if (!act) return;
    const id = card.dataset.id;
    const emp = state.employees.find(x => x.identifier === id);
    const action = act.dataset.act;
    const after = (r) => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        toast(t('saved') || 'Saved', 'success');
        refreshEmployees();
    };
    if (action === 'promote') call('employees:promote', { identifier: id }).then(after);
    if (action === 'demote')  call('employees:demote',  { identifier: id }).then(after);
    if (action === 'fire')    confirmDlg(`Fire ${emp?.name || ''}?`, () => call('employees:fire', { identifier: id }).then(after));
    if (action === 'bonus')   bonusPrompt(emp);
    if (action === 'locate' && emp?.src) call('players:locate', { target: emp.src }).then(r => {
        if (r?.ok) toast('Waypoint set', 'success');
    });
});

on($('#emp-filter'),    'change', renderEmployees);
on($('#emp-search'),    'input',  renderEmployees);
on($('#emp-hire-btn'),  'click',  () => hirePrompt());

function hirePrompt() {
    call('employees:findOnline', { query: '' }).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        const targets = (r.data || []).filter(p => state.you ? Number(p.id) !== Number(state.you.id) : true);
        if (!targets.length) return toast('No online players nearby', 'warning');
        inputDlg({
            title: 'Hire employee',
            fields: [
                {
                    type: 'select',
                    label: 'Player',
                    key: 'id',
                    options: targets.map(p => ({
                        value: p.id,
                        label: `${p.name || 'Unknown'} · ID ${p.id} · ${p.distanceLabel || 'unknown distance'} · ${p.job || 'unemployed'}`
                    })),
                },
                { type: 'number', label: 'Starting grade', key: 'grade', value: 0 },
            ],
            onSubmit(v) {
                const tgt = Number(v.id); if (!tgt) return toast('Invalid ID', 'error');
                call('employees:hire', { target: tgt, grade: Number(v.grade) || 0 }).then(r => {
                    if (!r?.ok) return toast(r?.error || 'Failed', 'error');
                    toast(t('saved') || 'Saved', 'success');
                    refreshEmployees();
                    refreshPlayers();
                });
            }
        });
    });
}
function bonusPrompt(emp) {
    if (!emp) return;
    inputDlg({
        title: `Send bonus to ${emp.name}`,
        fields: [
            { type: 'number', label: 'Bonus amount', key: 'amount', value: 0 },
            { type: 'text',   label: 'Reason',       key: 'reason' },
        ],
        onSubmit(v) {
            const amt = Math.floor(Number(v.amount) || 0);
            if (amt <= 0) return toast('Invalid amount', 'error');
            call('bonuses:send', { identifier: emp.identifier, amount: amt, reason: v.reason || '' }).then(r => {
                if (!r?.ok) return toast(r?.error || 'Failed', 'error');
                toast(`Sent ${fmtMoney(amt)} to ${emp.name}`, 'success');
                refreshTreasury();
                refreshLogs();
            });
        }
    });
}

/* ============================================================
   RANKS
   ============================================================ */
function renderRanks() {
    call('ranks:get').then(r => {
        const root = $('#ranks-list'); if (!root) return;
        const grades = (r?.data || []).slice().sort((a, b) => a.grade - b.grade);
        if (!grades.length) { root.innerHTML = `<div class="emp-empty">No ranks defined.</div>`; return; }
        root.innerHTML = grades.map(g => `
            <div class="rank-card" data-grade="${g.grade}">
                <div class="rank-pill">G${g.grade}</div>
                <div class="rank-name">
                    <span class="rank-field-label">Rank</span>
                    <input class="rank-label-input" value="${escapeHTML(g.label || '')}" placeholder="Rank label">
                    <span class="rank-name-tag ${g.isBoss ? 'boss' : ''}">
                        ${g.isBoss ? '<i class="fa-solid fa-crown"></i> Boss-tier' : 'Standard'}
                    </span>
                </div>
                <div class="rank-field">
                    <span class="rank-field-label">Wage</span>
                    <input type="number" class="rank-field-input rank-wage" value="${Number(g.wage) || 0}">
                </div>
                <div class="rank-field">
                    <span class="rank-field-label">Pay every (min)</span>
                    <input type="number" class="rank-field-input rank-interval" value="${Number(g.payInterval) || 60}">
                </div>
                <button class="btn btn-primary btn-sm rank-save"><i class="fa-solid fa-check"></i> Save</button>
            </div>
        `).join('');
    });
}
document.addEventListener('click', e => {
    const btn = e.target.closest('.rank-save'); if (!btn) return;
    const row = btn.closest('.rank-card'); if (!row) return;
    const payload = {
        grade:        Number(row.dataset.grade),
        label:        row.querySelector('.rank-label-input')?.value || '',
        wage:         Number(row.querySelector('.rank-wage')?.value) || 0,
        payInterval:  Number(row.querySelector('.rank-interval')?.value) || 60,
    };
    call('ranks:save', payload).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        toast(t('saved') || 'Saved', 'success');
        refreshPayroll();
    });
});

/* ============================================================
   PAYROLL
   ============================================================ */
function refreshPayroll() {
    call('payroll:state').then(r => {
        if (!r?.ok) return;
        const s = r.data || {};
        state.payroll = s;
        setText('#payroll-total',    fmtMoney(s.totalDue || 0));
        setText('#ov-payroll-due',   fmtMoney(s.totalDue || 0));
        setText('#payroll-count',    (s.lines || []).reduce((acc, l) => acc + (l.count || 0), 0));
        setText('#payroll-treasury', fmtMoney(s.treasury || 0));
        if (s.nextIn) {
            const secs = Math.max(0, s.nextIn - Math.floor(Date.now() / 1000));
            setText('#payroll-next',     fmtDur(secs));
            setText('#ov-next-payroll',  fmtDur(secs));
        } else {
            setText('#payroll-next', 'Not scheduled');
            setText('#ov-next-payroll', 'Not scheduled');
        }
        const grid = $('#payroll-grid');
        if (grid) {
            grid.innerHTML = (s.lines || []).map(l => `
                <div class="payroll-line">
                    <div class="rank-pill">G${l.grade}</div>
                    <div class="pl-info">
                        <strong>${escapeHTML(l.label || ('Grade ' + l.grade))}</strong>
                        <small>Pays every ${l.payInterval}m</small>
                    </div>
                    <span class="pl-online ${l.count ? '' : 'zero'}"><i class="fa-solid fa-circle"></i> ${l.count} online</span>
                    <span class="emp-wage">${fmtMoney(l.due)}</span>
                </div>
            `).join('');
        }
    });
}
on($('#payroll-run'), 'click', () => {
    call('payroll:runNow').then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        toast(`Payroll complete. ${r.data?.paid || 0} paid.`, 'success');
        refreshPayroll();
        refreshTreasury();
    });
});

/* ============================================================
   TREASURY
   ============================================================ */
function compactMoney(n) {
    n = Math.floor(Number(n) || 0);
    const sym = state.config?.currency?.symbol ?? '$';
    const sign = n < 0 ? '-' : '';
    const abs = Math.abs(n);
    if (abs >= 1000) {
        const k = abs / 1000;
        return `${sign}${sym}${k % 1 === 0 ? k : k.toFixed(1)}k`;
    }
    return `${sign}${sym}${abs}`;
}

function treasuryDayKey(d) {
    if (!(d instanceof Date) || Number.isNaN(d.getTime())) return '';
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
}
function treasuryDateFrom(value) {
    if (value == null || value === '') return null;
    const n = Number(value);
    if (Number.isFinite(n) && n > 0) return new Date(n > 100000000000 ? n : n * 1000);
    if (typeof value === 'string') {
        const direct = new Date(value);
        if (!Number.isNaN(direct.getTime())) return direct;
        const sqlish = new Date(value.replace(' ', 'T'));
        if (!Number.isNaN(sqlish.getTime())) return sqlish;
    }
    return null;
}
function treasuryAmount(value) {
    if (typeof value === 'number') return Math.abs(value);
    const clean = String(value ?? '').replace(/[^\d.-]/g, '');
    return Math.abs(Number(clean) || 0);
}

function buildTreasuryDays(history) {
    const days = [];
    const now = new Date();
    for (let i = 6; i >= 0; i--) {
        const d = new Date(now.getFullYear(), now.getMonth(), now.getDate() - i);
        days.push({
            key: treasuryDayKey(d),
            label: d.toLocaleDateString(undefined, { weekday: 'short' }),
            in: 0,
            out: 0,
        });
    }
    const byKey = Object.fromEntries(days.map(d => [d.key, d]));
    (history || []).forEach(r => {
        const d = treasuryDateFrom(r.created_at);
        const key = treasuryDayKey(d);
        if (!byKey[key]) return;
        const amount = treasuryAmount(r.amount);
        const action = String(r.action || '').toLowerCase();
        if (action === 'deposit') byKey[key].in += amount;
        if (action === 'withdraw') byKey[key].out += amount;
    });
    return days;
}

function renderTreasuryChart(days) {
    const svg = $('#treasury-chart'); if (!svg) return;
    const rect = svg.getBoundingClientRect();
    const W = Math.max(260, Math.round(rect.width || 700));
    const H = Math.max(130, Math.round(rect.height || 180));
    svg.setAttribute('viewBox', `0 0 ${W} ${H}`);
    svg.innerHTML = '';

    const css = getComputedStyle(document.documentElement);
    const brand = (css.getPropertyValue('--brand-500') || '#1F5EFF').trim();
    const grey = (css.getPropertyValue('--text-3') || '#8A8A90').trim();
    const text3 = (css.getPropertyValue('--text-3') || '#999').trim();
    const line1 = (css.getPropertyValue('--line-1') || '#222').trim();
    const P = { t: 12, r: 14, b: 25, l: 50 };
    const innerW = W - P.l - P.r;
    const innerH = H - P.t - P.b;
    const max = Math.max(1, ...days.flatMap(d => [d.in || 0, d.out || 0]));
    const niceMax = (() => {
        const pow = Math.pow(10, Math.floor(Math.log10(max)));
        const norm = max / pow;
        return (norm <= 1 ? 1 : norm <= 2 ? 2 : norm <= 5 ? 5 : 10) * pow;
    })();
    const yFor = v => P.t + innerH - (v / niceMax) * innerH;
    const xFor = i => P.l + i * (innerW / Math.max(1, days.length - 1));

    [niceMax, niceMax / 2, 0].forEach(v => {
        const y = yFor(v);
        const l = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        l.setAttribute('x1', P.l); l.setAttribute('x2', W - P.r);
        l.setAttribute('y1', y); l.setAttribute('y2', y);
        l.setAttribute('stroke', line1);
        l.setAttribute('stroke-width', '1');
        svg.appendChild(l);
        const t = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        t.setAttribute('x', P.l - 9); t.setAttribute('y', y + 4);
        t.setAttribute('text-anchor', 'end');
        t.setAttribute('fill', text3);
        t.setAttribute('font-size', '10');
        t.setAttribute('font-family', 'JetBrains Mono, ui-monospace, monospace');
        t.textContent = compactMoney(v);
        svg.appendChild(t);
    });

    days.forEach((d, i) => {
        const t = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        t.setAttribute('x', xFor(i));
        t.setAttribute('y', H - 8);
        t.setAttribute('text-anchor', 'middle');
        t.setAttribute('fill', text3);
        t.setAttribute('font-size', '10');
        t.setAttribute('font-family', 'Inter, system-ui, sans-serif');
        t.textContent = d.label;
        svg.appendChild(t);
    });

    // gradient defs for the area fill under the deposits line
    const defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
    const grad = document.createElementNS('http://www.w3.org/2000/svg', 'linearGradient');
    grad.setAttribute('id', 'treasury-area'); grad.setAttribute('x1', '0'); grad.setAttribute('y1', '0');
    grad.setAttribute('x2', '0'); grad.setAttribute('y2', '1');
    [['0%', brand, 0.28], ['100%', brand, 0]].forEach(([off, col, op]) => {
        const s = document.createElementNS('http://www.w3.org/2000/svg', 'stop');
        s.setAttribute('offset', off); s.setAttribute('stop-color', col); s.setAttribute('stop-opacity', op);
        grad.appendChild(s);
    });
    defs.appendChild(grad); svg.appendChild(defs);

    const draw = (key, color, area) => {
        const pts = days.map((d, i) => [xFor(i), yFor(d[key] || 0)]);
        let path = `M ${pts[0][0]},${pts[0][1]}`;
        for (let i = 0; i < pts.length - 1; i++) {
            const p0 = pts[i - 1] || pts[i], p1 = pts[i], p2 = pts[i + 1], p3 = pts[i + 2] || p2;
            const tn = 0.2;
            path += ` C ${p1[0] + (p2[0] - p0[0]) * tn},${p1[1] + (p2[1] - p0[1]) * tn} ${p2[0] - (p3[0] - p1[0]) * tn},${p2[1] - (p3[1] - p1[1]) * tn} ${p2[0]},${p2[1]}`;
        }
        if (area) {
            const baseY = yFor(0);
            const ar = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            ar.setAttribute('d', `${path} L ${pts[pts.length - 1][0]},${baseY} L ${pts[0][0]},${baseY} Z`);
            ar.setAttribute('fill', 'url(#treasury-area)');
            svg.appendChild(ar);
        }
        const line = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        line.setAttribute('d', path);
        line.setAttribute('fill', 'none');
        line.setAttribute('stroke', color);
        line.setAttribute('stroke-width', '3');
        line.setAttribute('stroke-linecap', 'round');
        line.setAttribute('stroke-linejoin', 'round');
        svg.appendChild(line);
        pts.forEach(([x, y]) => {
            const c = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            c.setAttribute('cx', x); c.setAttribute('cy', y);
            c.setAttribute('r', '3.5');
            c.setAttribute('fill', color);
            c.setAttribute('stroke', 'var(--surface-2)');
            c.setAttribute('stroke-width', '2');
            svg.appendChild(c);
        });
    };
    draw('out', grey, false);
    draw('in', brand, true);
}

function renderTreasuryHistory() {
    const root = $('#treasury-history'); if (!root) return;
    const rows = (state.treasuryHistory || []).slice(0, 10);
    setText('#treasury-history-count', `${rows.length} transaction${rows.length === 1 ? '' : 's'}`);
    if (!rows.length) {
        root.innerHTML = `<div class="tx-empty">No treasury movement yet.</div>`;
        return;
    }
    root.innerHTML = rows.map(r => {
        const isIn = r.action === 'deposit';
        const cls = isIn ? 'in' : 'out';
        const icon = isIn ? 'arrow-down' : 'arrow-up';
        const sign = isIn ? '+' : '-';
        return `
            <div class="tx-row">
                <div class="tx-ic ${cls}"><i class="fa-solid fa-${icon}"></i></div>
                <div class="tx-meta">
                    <div class="tx-label">${isIn ? 'Deposit' : 'Withdraw'}</div>
                    <div class="tx-sub">${escapeHTML(r.actor || 'System')} · ${new Date((r.created_at || 0) * 1000).toLocaleString()}</div>
                </div>
                <div class="tx-amount ${isIn ? 'pos' : 'neg'}">${sign} ${fmtMoney(r.amount || 0)}</div>
            </div>
        `;
    }).join('');
}

function applyTreasurySnapshot(data) {
    const bal = data?.balance || 0;
    state.treasury = bal;
    state.treasuryHistory = Array.isArray(data?.history) ? data.history : [];
    setText('#ov-treasury',      fmtMoney(bal));
    setText('#treasury-balance', fmtMoney(bal));
    setText('#bid-treasury',     fmtMoney(bal));
    setText('#treasury-cash',    fmtMoney(data?.cash || 0));
    setText('#treasury-sync',    data?.sync ? 'Synced with society account.' : 'Local treasury ledger.');
    const days = buildTreasuryDays(state.treasuryHistory);
    setText('#treasury-in-7d',  fmtMoney(days.reduce((a, b) => a + b.in, 0)));
    setText('#treasury-out-7d', fmtMoney(days.reduce((a, b) => a + b.out, 0)));
    renderTreasuryChart(days);
    renderTreasuryHistory();
}

function refreshTreasury() {
    call('treasury:get').then(r => {
        if (!r?.ok) return;
        applyTreasurySnapshot(r.data || {});
    });
}
on($('#dep-go'), 'click', () => {
    const amt    = Math.floor(Number($('#dep-amount')?.value) || 0);
    const reason = $('#dep-reason')?.value || '';
    if (amt <= 0) return toast('Invalid amount', 'error');
    call('treasury:deposit', { amount: amt, reason }).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        if ($('#dep-amount')) $('#dep-amount').value = '';
        if ($('#dep-reason')) $('#dep-reason').value = '';
        applyTreasurySnapshot(r.data || {});
        toast(`Deposited ${fmtMoney(amt)}.`, 'success');
        refreshLogs();
    });
});
on($('#wd-go'), 'click', () => {
    const amt    = Math.floor(Number($('#wd-amount')?.value) || 0);
    const reason = $('#wd-reason')?.value || '';
    if (amt <= 0) return toast('Invalid amount', 'error');
    call('treasury:withdraw', { amount: amt, reason }).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        if ($('#wd-amount')) $('#wd-amount').value = '';
        if ($('#wd-reason')) $('#wd-reason').value = '';
        applyTreasurySnapshot(r.data || {});
        toast(`Withdrew ${fmtMoney(amt)}.`, 'success');
        refreshLogs();
    });
});
document.addEventListener('click', e => {
    const add = e.target.closest('[data-dep-add]');
    if (add) {
        const inp = $('#dep-amount');
        if (inp) inp.value = (Number(inp.value) || 0) + Number(add.dataset.depAdd);
    }
    const wa = e.target.closest('[data-wd-add]');
    if (wa) {
        const inp = $('#wd-amount');
        if (inp) inp.value = (Number(inp.value) || 0) + Number(wa.dataset.wdAdd);
    }
});

/* ============================================================
   PLAYERS  +  MAP
   ============================================================ */
const CENTER_X = 117.3, CENTER_Y = 172.8, SCALE_X = 0.02072, SCALE_Y = 0.0205;
const MAP_TILE = 'https://www.gtamap.xyz/mapStyles/styleAtlas/{z}/{x}/{y}.jpg';

function ensureMap() {
    if (state.mapBuilt) return state.map;
    const target = $('#boss-map');
    if (!target || typeof L === 'undefined') return null;
    const CRS = L.extend({}, L.CRS.Simple, {
        projection: L.Projection.LonLat,
        scale: z => Math.pow(2, z),
        zoom : s => Math.log(s) / Math.LN2,
        distance: (a, b) => {
            const dx = b.lng - a.lng, dy = b.lat - a.lat;
            return Math.sqrt(dx * dx + dy * dy);
        },
        transformation: new L.Transformation(SCALE_X, CENTER_X, -SCALE_Y, CENTER_Y),
        infinite: true,
    });
    const map = L.map('boss-map', {
        crs: CRS, minZoom: 2, maxZoom: 5, zoom: 3, center: [0, 0],
        zoomControl: true, preferCanvas: true,
        attributionControl: false,
        maxBounds: [[8000.0, -5500.0], [-8000.0, 5500.0]],
    });
    L.tileLayer(MAP_TILE, { minZoom: 2, maxZoom: 5, noWrap: true }).addTo(map);
    state.map = map;
    state.mapBuilt = true;
    // Resize after layout settles
    setTimeout(() => { try { map.invalidateSize(); } catch (_) {} }, 100);
    return map;
}

const JOB_COLORS = {
    police: '#4E9CE5', sheriff: '#4E9CE5', bcso: '#4E9CE5', state: '#4E9CE5',
    ambulance: '#E5564B', medic: '#E5564B', ems: '#E5564B', doctor: '#E5564B',
    mechanic: '#E5A93C', taxi: '#F0B429',
    cardealer: '#A66DF0', realestate: '#A66DF0', judge: '#A66DF0', lawyer: '#A66DF0',
    reporter: '#34C77B', unemployed: '#7C7C82',
};
function colourFor(p) {
    if (p.isStaff) return '#A66DF0';
    if (state.job && p.job === state.job.name) return '#1F5EFF';
    return JOB_COLORS[(p.job || '').toLowerCase()] || '#34C77B';
}

function mapSearchQuery() {
    return ($('#ov-map-search')?.value || '').toLowerCase().trim();
}

function playerMatchesMapQuery(p, query) {
    if (!query) return true;
    return [p.name, p.id, p.identifier, p.job, p.jobLabel, p.gradeLabel, p.vehicle, p.plate]
        .some(v => String(v || '').toLowerCase().includes(query));
}

function updateMapSearchUi(mode, count) {
    const input = $('#ov-map-search');
    if (input) input.placeholder = 'Search players...';
    setText('#ov-map-results', count);
}

let _playersPoll = null;
function startPlayersPoll() {
    if (_playersPoll) return;
    _playersPoll = setInterval(() => {
        if (state.open && state.activeTab === 'players') refreshPlayers();
        else { clearInterval(_playersPoll); _playersPoll = null; }
    }, 10000);
}
function refreshPlayers() {
    call('players:list').then(r => {
        if (!r?.ok) return;
        state.players = r.data || [];
        setText('#players-count',     `${state.players.length} online`);
        setText('#ov-server-pop',     state.players.length);
        const badge = $('#rail-players');
        if (badge) badge.textContent = state.players.length;
        renderPlayers();
        renderMapMarkers();
    });
}

function renderPlayers() {
    const root  = $('#players-list'); if (!root) return;
    const filt  = ($('#pl-filter')?.value || 'all');
    const job   = ($('#pl-filter-job')?.value || '').toLowerCase();
    const query = ($('#pl-search')?.value || '').toLowerCase().trim();
    let rows = state.players.slice();
    if (filt === 'staff')    rows = rows.filter(p => p.isStaff);
    if (filt === 'job' && job) rows = rows.filter(p => (p.job || '').toLowerCase() === job);
    if (query) rows = rows.filter(p => (p.name || '').toLowerCase().includes(query));
    if (rows.length === 0) {
        root.innerHTML = `<div class="emp-empty">No players match.</div>`;
        return;
    }
    root.innerHTML = rows.map(p => `
        <div class="player-card" data-id="${p.id}">
            ${_avatarHTML(p)}
            <div>
                <div class="player-name">${escapeHTML(p.name)} ${p.isStaff ? '<i class="fa-solid fa-shield-halved"></i>' : ''}</div>
                <div class="player-meta">${escapeHTML(p.jobLabel || p.job || 'No job')}</div>
            </div>
            <span class="player-id-pill">ID ${p.id}</span>
            <span class="player-id-pill">${p.ping ? p.ping + 'ms' : 'n/a'}</span>
        </div>
    `).join('');
    hydrateMugs(rows.map(p => p.id));

    // master-detail: keep the open profile intact across auto-refreshes.
    // Only (re)build it when the selection actually changes — otherwise we'd
    // tear down + re-fetch the activity feed every poll, making it flash.
    const stillThere = rows.find(p => String(p.id) === String(_selectedPlayerId));
    if (!stillThere) _selectedPlayerId = rows[0] ? rows[0].id : null;
    if (_selectedPlayerId != null) {
        $$('#players-list .player-card').forEach(c => c.classList.toggle('active', String(c.dataset.id) === String(_selectedPlayerId)));
        if (_profileRenderedId !== String(_selectedPlayerId)) selectPlayer(_selectedPlayerId);
    } else {
        renderPlayerProfile(null);
        _profileRenderedId = null;
    }
}

/* ── Player profile panel (apex_adminmenu-style master-detail) ── */
let _selectedPlayerId = null;
let _profileRenderedId = null;   // which player's profile DOM is currently built
function _initials(name){
    return (String(name || '?').trim().split(/\s+/).slice(0,2).map(w => w[0] || '').join('').toUpperCase()) || '?';
}
// Avatars — professional initials on the brand gradient as the base,
// with the player's REAL in-game GTA headshot (RegisterPedheadshot,
// ox_inventory-style) swapped in when their ped is streamed on the
// boss's client. No external avatar service / no stock photos: the img
// has no src until the native headshot resolves, so initials show first.
const _mug = {}; // serverId -> url(string) | false(checked,none) | undefined(unknown)
function _avatarInner(p){
    const mug = (p && p.id != null) ? ` data-mug="${escapeAttr(p.id)}"` : '';
    return `${_initials(p && p.name)}<img${mug} alt="" loading="lazy" onerror="this.remove()"><i class="player-av-dot"></i>`;
}
function _avatarHTML(p, cls){
    return `<span class="player-av ${cls || ''}">${_avatarInner(p)}</span>`;
}
function _applyMug(id){
    const url = _mug[id];
    if (typeof url !== 'string') return;
    $$(`img[data-mug="${id}"]`).forEach(img => { if (img.getAttribute('src') !== url) img.src = url; });
}
// Ask the client for a native headshot; swap it in when ready.
function hydrateMug(id, force){
    if (id == null) return;
    if (typeof _mug[id] === 'string') { _applyMug(id); return; }
    if (_mug[id] === false && !force) return;     // already checked, ped not streamed
    post('mugshot', { id }).then(r => {
        _mug[id] = (r && r.ok && r.url) ? r.url : false;
        _applyMug(id);
    }).catch(() => { _mug[id] = false; });
}
function hydrateMugs(ids){ (ids || []).forEach(id => hydrateMug(id)); }

// Sidebar identity card (the boss themselves) — name, grade + live headshot
function renderIdentity(){
    const you = state.you || {};
    setText('#cc-me-name', you.name || 'Boss');
    setText('#cc-me-grade', you.gradeLabel || (state.job?.label) || ('Grade ' + (you.grade || 0)));
    const av = $('#cc-me-avatar');
    if (av){
        av.innerHTML = _avatarInner(you);
        if (you.id != null) hydrateMug(you.id, true);
    }
}
function _fmtPlaytime(mins){
    if (mins == null) return '<span class="muted">Not tracked</span>';
    mins = Math.max(0, Math.floor(Number(mins) || 0));
    const h = Math.floor(mins / 60), m = mins % 60;
    return h ? `${h}h ${m}m` : `${m}m`;
}
function _ago(ts){
    if (!ts) return '';
    const s = Math.max(0, Math.floor(Date.now() / 1000) - Number(ts));
    if (s < 60) return 'just now';
    if (s < 3600) return Math.floor(s / 60) + 'm ago';
    if (s < 86400) return Math.floor(s / 3600) + 'h ago';
    return Math.floor(s / 86400) + 'd ago';
}
// Icons keyed first by the specific action, then by the log category.
const _ACT_ICON = {
    // action-level (preferred)
    hire:'user-plus', fire:'user-xmark', promote:'arrow-up', demote:'arrow-down',
    bonus:'gift', send:'bullhorn', add:'note-sticky', delete:'trash-can',
    deposit:'arrow-down', withdraw:'arrow-up', zone_save:'map-pin', zone_delete:'trash-can',
    // category-level (fallback)
    employees:'users', treasury:'building-columns', payroll:'money-bill-wave',
    announce:'bullhorn', notes:'note-sticky', note:'note-sticky', admin:'screwdriver-wrench',
    stash:'box-archive', rank:'layer-group', misc:'circle-dot',
};
const _ACT_LABEL = {
    hire:'Hired', fire:'Fired', promote:'Promoted', demote:'Demoted', bonus:'Bonus paid',
    send:'Announcement', add:'Note added', delete:'Note removed',
    deposit:'Deposit', withdraw:'Withdrawal', zone_save:'Zone saved', zone_delete:'Zone removed',
};
function _prettify(s){ s = String(s == null ? 'Action' : s).replace(/_/g, ' ').trim(); return s ? s.charAt(0).toUpperCase() + s.slice(1) : 'Action'; }
function _actIcon(a){ return _ACT_ICON[a.action] || _ACT_ICON[a.category] || _ACT_ICON[a.icon] || 'circle-dot'; }
function _actLabel(a){ return _ACT_LABEL[a.action] || _prettify(a.label || a.action || a.category); }
const _profileCache = {};   // id -> last player:profile data (avoids re-flashing "Loading…")
function _renderPlayerExtra(id, d){
    if (String(_selectedPlayerId) !== String(id)) return;   // selection changed meanwhile
    const ptEl = document.getElementById('pp-playtime');
    const acEl = document.getElementById('pp-activity');
    if (ptEl) ptEl.innerHTML = _fmtPlaytime(d.playtime) + (d.playtime != null ? ' <span class="muted">· this session</span>' : '');
    const acts = Array.isArray(d.actions) ? d.actions : [];
    if (acEl) acEl.innerHTML = acts.length ? acts.slice(0, 8).map(a => {
        const amt = a.amount != null ? `<span class="pp-act-amt">${fmtMoney(a.amount)}</span>` : '';
        return `<div class="pp-act">
            <span class="pp-act-ic"><i class="fa-solid fa-${escapeAttr(_actIcon(a))}"></i></span>
            <div class="pp-act-meta">
                <div class="pp-act-label">${escapeHTML(_actLabel(a))}</div>
                ${a.detail ? `<div class="pp-act-sub">${escapeHTML(a.detail)}</div>` : ''}
            </div>
            ${amt}
            <span class="pp-act-time">${escapeHTML(_ago(a.time))}</span>
        </div>`;
    }).join('') : '<div class="pp-act-empty">No recorded activity for this player.</div>';
}
function loadPlayerExtra(id){
    // Show cached data instantly so re-selecting a player never flashes
    // the "Loading…" placeholder; then refresh quietly in the background.
    if (_profileCache[id]) _renderPlayerExtra(id, _profileCache[id]);
    const fail = () => {
        if (String(_selectedPlayerId) !== String(id) || _profileCache[id]) return;
        const ptEl = document.getElementById('pp-playtime');
        const acEl = document.getElementById('pp-activity');
        if (ptEl) ptEl.innerHTML = '<span class="muted">Not tracked</span>';
        if (acEl) acEl.innerHTML = '<div class="pp-act-empty">No activity recorded.</div>';
    };
    let settled = false;
    const timer = setTimeout(() => { if (!settled) fail(); }, 6000);
    call('player:profile', { id }).then(r => {
        settled = true; clearTimeout(timer);
        if (!r || !r.ok || !r.data) return fail();
        _profileCache[id] = r.data;
        _renderPlayerExtra(id, r.data);
    }).catch(() => { settled = true; clearTimeout(timer); fail(); });
}
function renderPlayerProfile(p){
    const root = $('#player-profile'); if (!root) return;
    if (!p){
        root.innerHTML = `<div class="pp-empty"><span class="pp-empty-ic"><i class="fa-solid fa-id-card"></i></span><span>Select a player to view their profile</span></div>`;
        return;
    }
    const emp = state.employees.find(e => (e.name || '') === p.name);
    const veh = p.vehicle ? escapeHTML(p.vehicle) : 'On foot';
    const grade = emp ? ('Grade ' + emp.grade + (emp.gradeLabel ? ' · ' + escapeHTML(emp.gradeLabel) : '')) : 'Not an employee';
    const acts = [`<button class="btn btn-ghost btn-sm" onclick="window._loc(${p.id})"><i class="fa-solid fa-location-arrow"></i> Waypoint</button>`];
    if (emp){
        acts.push(`<button class="btn btn-ghost btn-sm" onclick="window._popPromote('${escapeAttr(emp.identifier)}')"><i class="fa-solid fa-arrow-up"></i> Promote</button>`);
        acts.push(`<button class="btn btn-ghost btn-sm" onclick="window._popDemote('${escapeAttr(emp.identifier)}')"><i class="fa-solid fa-arrow-down"></i> Demote</button>`);
        acts.push(`<button class="btn btn-primary btn-sm" onclick="window._popBonus('${escapeAttr(emp.identifier)}')"><i class="fa-solid fa-gift"></i> Bonus</button>`);
        acts.push(`<button class="btn btn-ghost btn-sm" onclick="window._popFire('${escapeAttr(emp.identifier)}')"><i class="fa-solid fa-user-xmark"></i> Fire</button>`);
    }
    root.innerHTML = `
        <div class="pp-card">
            <div class="pp-top">
                <div class="pp-avatar">${_initials(p.name)}<img data-mug="${escapeAttr(p.id)}" alt="" onerror="this.remove()"></div>
                <div>
                    <div class="pp-name">${escapeHTML(p.name)}${p.isStaff ? ' <i class="fa-solid fa-shield-halved pp-staff" title="Staff"></i>' : ''}</div>
                    <div class="pp-sub"><span class="pp-online">Online</span> · ID ${p.id}</div>
                </div>
            </div>
            <div class="pp-tags">
                <span class="pp-tag">${escapeHTML(p.jobLabel || p.job || 'No job')}</span>
                ${emp ? `<span class="pp-tag grade">G${emp.grade}</span>` : ''}
                <span class="pp-tag muted">${p.ping ? p.ping + 'ms' : 'n/a'}</span>
            </div>
            <div class="pp-stats">
                <div class="pp-stat"><span>Job</span><strong>${escapeHTML(p.jobLabel || p.job || 'No job')}</strong></div>
                <div class="pp-stat"><span>Grade</span><strong>${grade}</strong></div>
                <div class="pp-stat"><span>Vehicle</span><strong>${veh}</strong></div>
                <div class="pp-stat"><span>Ping</span><strong>${p.ping ? p.ping + ' ms' : 'n/a'}</strong></div>
                <div class="pp-stat"><span>Playtime</span><strong id="pp-playtime" class="muted">…</strong></div>
                <div class="pp-stat"><span>Server ID</span><strong>${p.id}</strong></div>
            </div>
            <div class="pp-actions">${acts.join('')}</div>
            <div class="pp-section">
                <div class="pp-sec-h"><i class="fa-solid fa-list-ul"></i> Recent activity</div>
                <div class="pp-activity" id="pp-activity"><div class="pp-act-empty">Loading…</div></div>
            </div>
        </div>`;
}
function selectPlayer(id){
    _selectedPlayerId = id;
    const p = state.players.find(x => String(x.id) === String(id));
    $$('#players-list .player-card').forEach(c => c.classList.toggle('active', String(c.dataset.id) === String(id)));
    renderPlayerProfile(p);
    if (p) { _profileRenderedId = String(id); loadPlayerExtra(id); hydrateMug(id, true); }
    else _profileRenderedId = null;
}
on($('#players-list'), 'click', e => {
    const card = e.target.closest('.player-card'); if (!card) return;
    selectPlayer(card.dataset.id);
});

function renderMapMarkers() {
    const map = ensureMap(); if (!map) return;
    state.playerMarkers.forEach(m => map.removeLayer(m));
    state.playerMarkers = [];

    const query = mapSearchQuery();

    // Helper: find the employee record so we can offer boss actions
    const empByName = (name) => state.employees.find(e => (e.name || '') === name);

    // Default: only employees of the boss's own company.
    const rows = state.players.filter(p => {
        if (!p.coords) return false;
        if (!state.job || p.job !== state.job.name) return false;
        return playerMatchesMapQuery(p, query);
    });
    updateMapSearchUi('players', rows.length);
    rows.forEach(p => {

        const isMine = state.you && p.id === state.you.id;
        const blipHtml = isMine
            ? `<div class="boss-blip boss-blip-self"></div>`
            : `<div class="boss-blip" style="--blip:#1F5EFF"></div>`;
        const marker = L.marker([p.coords.y, p.coords.x], {
            icon: L.divIcon({ className: 'boss-blip-icon', html: blipHtml, iconSize: [16, 16] }),
        });
        const emp = empByName(p.name);
        const vehLine = p.vehicle ? `<div class="pp-line"><i class="fa-solid fa-car"></i> ${escapeHTML(p.vehicle)}</div>` : '';
        let quickActions = `<div class="pp-actions"><button class="btn btn-ghost btn-sm" onclick="window._loc(${p.id})"><i class="fa-solid fa-location-arrow"></i> Waypoint</button>`;
        if (emp) {
            quickActions += `
                <button class="btn btn-ghost btn-sm" onclick="window._popPromote('${escapeAttr(emp.identifier)}')"><i class="fa-solid fa-arrow-up"></i> Promote</button>
                <button class="btn btn-ghost btn-sm" onclick="window._popDemote('${escapeAttr(emp.identifier)}')"><i class="fa-solid fa-arrow-down"></i> Demote</button>
                <button class="btn btn-primary btn-sm" onclick="window._popBonus('${escapeAttr(emp.identifier)}')"><i class="fa-solid fa-gift"></i> Bonus</button>
                <button class="btn btn-ghost btn-sm" onclick="window._popFire('${escapeAttr(emp.identifier)}')"><i class="fa-solid fa-user-xmark"></i> Fire</button>
            `;
        }
        quickActions += `</div>`;
        marker.bindPopup(`
            <div class="player-popup">
                <div class="pp-head">
                    <strong>${escapeHTML(p.name)}</strong>
                    <span class="pp-id">ID ${p.id}</span>
                </div>
                <div class="pp-meta">${escapeHTML(p.jobLabel || p.job || 'No job')}${emp ? ' · G' + emp.grade : ''}</div>
                ${vehLine}
                ${quickActions}
            </div>
        `, { maxWidth: 280 });
        marker.addTo(map);
        state.playerMarkers.push(marker);
    });
}

function escapeAttr(s) { return String(s == null ? '' : s).replace(/'/g, '&#39;').replace(/"/g, '&quot;'); }

// Map popup quick-action handlers
window._popPromote = function (id) {
    call('employees:promote', { identifier: id }).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        toast('Promoted', 'success'); refreshEmployees();
    });
};
window._popDemote = function (id) {
    call('employees:demote', { identifier: id }).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        toast('Demoted', 'success'); refreshEmployees();
    });
};
window._popFire = function (id) {
    const emp = state.employees.find(e => e.identifier === id);
    confirmDlg(`Fire ${emp?.name || 'this employee'}?`, () => {
        call('employees:fire', { identifier: id }).then(r => {
            if (!r?.ok) return toast(r?.error || 'Failed', 'error');
            toast('Fired', 'success'); refreshEmployees();
        });
    });
};
window._popBonus = function (id) {
    const emp = state.employees.find(e => e.identifier === id);
    if (emp) bonusPrompt(emp);
};

window._loc = function (pid) {
    call('players:locate', { target: pid }).then(r => {
        if (r?.ok) toast('Waypoint set', 'success');
    });
};

on($('#ov-map-search'), 'input', renderMapMarkers);
on($('#ov-map-recenter'), 'click', () => {
    const map = ensureMap(); if (!map) return;
    const me = state.players.find(p => state.you && p.id === state.you.id);
    if (me?.coords) map.setView([me.coords.y, me.coords.x], 4, { animate: true });
    else map.setView([0, 0], 3);
});

on($('#pl-search'), 'input',  () => { renderPlayers(); renderMapMarkers(); });
on($('#pl-filter'), 'change', e => {
    const sel = $('#pl-filter-job');
    if (sel) sel.style.display = e.target.value === 'job' ? '' : 'none';
    if (e.target.value === 'job' && sel) {
        const jobs = Array.from(new Set(state.players.map(p => p.job).filter(Boolean))).sort();
        sel.innerHTML = `<option value="">Select a job…</option>` + jobs.map(j => `<option value="${escapeHTML(j)}">${escapeHTML(j)}</option>`).join('');
    }
    renderPlayers(); renderMapMarkers();
});
on($('#pl-filter-job'), 'change', () => { renderPlayers(); renderMapMarkers(); });

document.addEventListener('click', e => {
    const row = e.target.closest('.player-card'); if (!row) return;
    const id = Number(row.dataset.id);
    const p = state.players.find(x => x.id === id);
    if (!p || !p.coords) return;
    const map = ensureMap(); if (!map) return;
    map.setView([p.coords.y, p.coords.x], 5, { animate: true });
});

/* ============================================================
   STASH (private per boss)
   ============================================================ */
function openStash() { post('openStash', {}); }
function refreshStash() {
    call('stash:info').then(r => {
        if (!r || !r.ok) return;
        const d = r.data || {};
        setText('#stash-slots',    (d.slots || 0) + ' slots');
        setText('#stash-weight',   Math.round((d.weight || 0) / 1000) + ' kg');
        setText('#stash-provider', d.provider || 'auto');
        setText('#stash-id',       d.id || '');
    });
}
on($('#stash-open'),          'click', openStash);
on($('#settings-open-stash'), 'click', openStash);
on($('#boss-open-stash'),     'click', openStash);

/* ============================================================
   NOTES
   ============================================================ */
function refreshNotes() {
    call('notes:list').then(r => {
        if (!r?.ok) return;
        state.notes = r.data || [];
        setText('#notes-count', state.notes.length);
        const root = $('#notes-list'); if (!root) return;
        if (state.notes.length === 0) {
            root.innerHTML = `<div class="emp-empty" style="margin:6px;font-size:11px;padding:14px">No notes pinned yet.</div>`;
            return;
        }
        root.innerHTML = state.notes.map(n => `
            <div class="note-row" data-id="${n.id}">
                <p>${escapeHTML(n.body)}</p>
                <div class="note-foot">
                    <div class="note-meta">${escapeHTML(n.author || 'Unknown')} · ${new Date((n.created_at || 0) * 1000).toLocaleString()}</div>
                    <button class="icon-btn" data-note-del="${n.id}" title="Delete"><i class="fa-solid fa-trash-can"></i></button>
                </div>
            </div>
        `).join('');
    });
}
on($('#note-post'), 'click', () => {
    const body = $('#note-body')?.value || '';
    if (!body.trim()) return toast('Note is empty.', 'error');
    call('notes:add', { body }).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        if ($('#note-body')) $('#note-body').value = '';
        refreshNotes();
    });
});
document.addEventListener('click', e => {
    const b = e.target.closest('[data-note-del]'); if (!b) return;
    const id = Number(b.dataset.noteDel);
    confirmDlg('Delete this note?', () => {
        call('notes:delete', { id }).then(refreshNotes);
    });
});

/* ============================================================
   ANNOUNCE — severity + templates + history
   ============================================================ */
const annState = { kind: 'info' };

// Severity pill picker
document.addEventListener('click', e => {
    const pill = e.target.closest('#ann-kind .ann-kind-pill');
    if (!pill) return;
    annState.kind = pill.dataset.kind || 'info';
    $$('#ann-kind .ann-kind-pill').forEach(b => b.classList.toggle('active', b === pill));
});

// Template buttons fill the textarea
document.addEventListener('click', e => {
    const tpl = e.target.closest('.ann-tpl');
    if (!tpl) return;
    const body = $('#ann-body');
    if (body) {
        body.value = tpl.textContent.trim();
        body.dispatchEvent(new Event('input'));
        body.focus();
    }
});

// Length counter
on($('#ann-body'), 'input', e => {
    const len = (e.target.value || '').length;
    setText('#ann-len', `${len} / 280`);
});

on($('#ann-send'), 'click', () => {
    const body  = $('#ann-body')?.value || '';
    const title = $('#ann-title')?.value || '';
    if (!body.trim()) return toast('Message is empty.', 'error');
    call('announce:send', { body, title, kind: annState.kind }).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed', 'error');
        toast('Broadcast sent.', 'success');
        if ($('#ann-body'))  $('#ann-body').value  = '';
        if ($('#ann-title')) $('#ann-title').value = '';
        setText('#ann-len', '0 / 280');
        refreshLogs();
    });
});

function refreshAnnounceHistory() {
    // Pulled from the audit log (category=announce) which is
    // already loaded by refreshLogs().
    const root = $('#ann-history-list'); if (!root) return;
    const items = (state.logs || [])
        .filter(l => l.category === 'announce')
        .slice(0, 30);
    setText('#ann-history-count', items.length);
    if (items.length === 0) {
        root.innerHTML = `<div class="emp-empty" style="margin:6px;font-size:11px;padding:14px">No broadcasts yet.</div>`;
        return;
    }
    root.innerHTML = items.map(l => {
        let body = '', kind = 'info', reach = '';
        if (l.details) {
            try {
                const d = typeof l.details === 'string' ? JSON.parse(l.details) : l.details;
                body  = d.body  || d.title || '';
                kind  = d.kind  || 'info';
                reach = d.reach != null ? `${d.reach} reached` : '';
            } catch (_) { body = String(l.details); }
        }
        return `
            <div class="ann-history-row kind-${escapeHTML(kind)}">
                <div class="ahr-head">
                    <span class="ahr-when">${new Date((l.created_at || 0) * 1000).toLocaleString()}</span>
                    <span class="ahr-reach">${escapeHTML(reach)}</span>
                </div>
                <p>${escapeHTML(body)}</p>
            </div>
        `;
    }).join('');
}

/* ============================================================
   LOGS
   ============================================================ */
const LOG_ICONS = {
    employees: 'users', payroll: 'money-check-dollar', treasury: 'vault',
    bonus: 'gift', notes: 'note-sticky',
    stash: 'boxes-stacked', announce: 'bullhorn', admin: 'shield-halved',
};

const LOG_KIND_ICON = {
    hire: 'user-plus', fire: 'user-minus', promote: 'arrow-up', demote: 'arrow-down',
    deposit: 'arrow-down-long', withdraw: 'arrow-up-long', bonus: 'gift',
    sale: 'cart-shopping', register: 'cash-register', delivery: 'truck',
    cook: 'fire-burner', prep: 'kitchen-set', stock_in: 'box-open', stock_out: 'box',
    npc_buy: 'truck-ramp-box', price: 'tag',
};
function refreshLogs() {
    return call('logs:list', {}).then(r => {
        if (!r?.ok) return;
        state.logs = r.data || [];
        renderLogs();
        renderTicker();
        if (state.activeTab === 'comms') refreshAnnounceHistory();
    });
}
function renderLogs() {
    const root = $('#logs-list'); if (!root) return;
    const cat = state.logsCategory || '';
    const rows = (state.logs || []).filter(l => !cat || l.category === cat);
    setText('#logs-count', rows.length + (rows.length === 1 ? ' entry' : ' entries'));
    if (!rows.length) { root.innerHTML = `<div class="emp-empty">No activity logged.</div>`; return; }
    root.innerHTML = rows.map(l => {
        const icon = LOG_KIND_ICON[l.kind] || 'circle-info';
        const catCls = l.category === 'management' ? 'log-mgmt' : 'log-rest';
        return `
            <div class="log-row ${catCls}">
                <div class="log-ic"><i class="fa-solid fa-${icon}"></i></div>
                <div class="log-body">
                    <div class="log-title">${escapeHTML(l.detail || l.kind || 'Action')}</div>
                    <div class="log-sub">${escapeHTML(l.actor || 'System')} · ${escapeHTML(l.when_ || '')}</div>
                </div>
                <div class="log-amount">${l.amount ? fmtMoney(l.amount) : ''}</div>
            </div>`;
    }).join('');
}
function renderTicker() {
    const bonuses = (state.logs || []).filter(l => l.kind === 'bonus');
    setText('#ov-bonus-24h',   fmtMoney(bonuses.reduce((a, b) => a + (b.amount || 0), 0)));
    setText('#ov-bonus-count', bonuses.length);
}
on($('#logs-filter'), 'click', e => {
    const b = e.target.closest('.hf-pill'); if (!b) return;
    $$('#logs-filter .hf-pill').forEach(x => x.classList.remove('active'));
    b.classList.add('active');
    state.logsCategory = b.dataset.cat || '';
    renderLogs();
});

/* ============================================================
   SETTINGS — appearance
   ============================================================ */
// ── colour helpers (HSL ramp re-tinting, like apex_banking) ──
function _hexToRgb(hex){const h=(hex||'').replace('#','');const n=h.length===3?h.split('').map(c=>c+c).join(''):h;return{r:parseInt(n.slice(0,2),16)||0,g:parseInt(n.slice(2,4),16)||0,b:parseInt(n.slice(4,6),16)||0};}
function _rgbToHsl({r,g,b}){r/=255;g/=255;b/=255;const mx=Math.max(r,g,b),mn=Math.min(r,g,b);let h,s,l=(mx+mn)/2;if(mx===mn){h=s=0;}else{const d=mx-mn;s=l>.5?d/(2-mx-mn):d/(mx+mn);switch(mx){case r:h=(g-b)/d+(g<b?6:0);break;case g:h=(b-r)/d+2;break;case b:h=(r-g)/d+4;break;}h/=6;}return{h:h*360,s:s*100,l:l*100};}
function _hslToHex(h,s,l){h/=360;s/=100;l/=100;const f=(p,q,t)=>{if(t<0)t+=1;if(t>1)t-=1;if(t<1/6)return p+(q-p)*6*t;if(t<1/2)return q;if(t<2/3)return p+(q-p)*(2/3-t)*6;return p;};let r,g,b;if(s===0){r=g=b=l;}else{const q=l<.5?l*(1+s):l+s-l*s;const p=2*l-q;r=f(p,q,h+1/3);g=f(p,q,h);b=f(p,q,h-1/3);}const to=x=>Math.round(x*255).toString(16).padStart(2,'0');return'#'+to(r)+to(g)+to(b);}
function _hexToRgba(hex,a){const{r,g,b}=_hexToRgb(hex);return`rgba(${r},${g},${b},${a})`;}

// Re-tint the FULL brand ramp from a chosen hex, setting exactly the
// --brand-* + alpha tokens this CSS reads (a06/a10/a15/a25/a40).
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

// Re-tint the surface/line ramp from a chosen background base hex.
// Fixed lightness deltas keep the layered dark look readable for any pick.
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
    // keep the bg-* aliases in sync (selectors read either)
    set('--bg',-3.5);set('--bg-sidebar',0);set('--bg-card',3);set('--bg-raised',7);
    set('--border',5);set('--border-hi',9.5);
}

const PRESET_COLORS = ['#1F5EFF','#4E9CE5','#34C77B','#E5A93C','#E5564B','#A66DF0','#F0B429','#0BA5A4'];
const PRESET_BGS    = ['#131314','#0F1218','#101616','#15110F','#141019','#0E1614','#181613','#1A1A1D'];

function primeColorPresets() {
    // accent
    const root = $('#theme-presets');
    if (root) {
        root.innerHTML = PRESET_COLORS.map(c => `<button class="color-preset" data-c="${c}" style="background:${c}"></button>`).join('');
        const active = localStorage.getItem('boss-theme-color') || serverThemeDefault('brand', '#1F5EFF');
        const inp = $('#theme-color-input'); if (inp) inp.value = active;
        setText('#theme-color-hex', active.toUpperCase());
        $$('#theme-presets .color-preset').forEach(b => b.classList.toggle('active', b.dataset.c.toLowerCase() === active.toLowerCase()));
    }
    // background
    const bgRoot = $('#bg-presets');
    if (bgRoot) {
        bgRoot.innerHTML = PRESET_BGS.map(c => `<button class="color-preset" data-bg="${c}" style="background:${c}"></button>`).join('');
        const activeBg = localStorage.getItem('boss-theme-bg') || serverThemeDefault('bg', '#131314');
        const bi = $('#theme-bg-input'); if (bi) bi.value = activeBg;
        setText('#theme-bg-hex', activeBg.toUpperCase());
        $$('#bg-presets .color-preset').forEach(b => b.classList.toggle('active', b.dataset.bg.toLowerCase() === activeBg.toLowerCase()));
    }
    // size
    const size = localStorage.getItem('boss-theme-size') || 'm';
    $$('#size-grid .size-btn').forEach(b => b.classList.toggle('active', b.dataset.size === size));
}

function applyTheme(hex) {
    if (!hex) return;
    applyBrandRamp(hex);
    setText('#theme-color-hex', hex.toUpperCase());
}
function applyBackground(hex) {
    if (!hex) return;
    applyBackgroundRamp(hex);
    setText('#theme-bg-hex', hex.toUpperCase());
}
function applySize(size) {
    const shell = $('.cc-shell'); if (!shell) return;
    shell.classList.remove('size-s','size-m','size-l','size-full');
    shell.classList.add('size-' + size);
}

/* ── Sidebar collapse (open by default, like the admin menu) ── */
function applyRailCollapsed(collapsed) {
    const shell = $('.cc-shell'); if (!shell) return;
    shell.classList.toggle('rail-collapsed', !!collapsed);
}
on($('#rail-collapse'), 'click', () => {
    const shell = $('.cc-shell'); if (!shell) return;
    const next = !shell.classList.contains('rail-collapsed');
    applyRailCollapsed(next);
    localStorage.setItem('boss-rail-collapsed', next ? '1' : '0');
});

/* ── UI opacity — applies to every boss panel (shell, creator, multijob, modals) ── */
function applyOpacity(pct) {
    pct = Math.max(55, Math.min(100, Math.round(Number(pct) || 100)));
    document.documentElement.style.setProperty('--ui-opacity', (pct / 100).toFixed(2));
    setText('#theme-opacity-val', pct + '%');
    const sl = $('#theme-opacity'); if (sl && Number(sl.value) !== pct) sl.value = pct;
}
on($('#theme-opacity'), 'input', e => {
    applyOpacity(e.target.value);
    localStorage.setItem('boss-theme-opacity', String(Math.round(Number(e.target.value) || 100)));
});

// Push the colour to the whole restaurant (server) so every employee's UI
// + the 3D marker re-tint. 'input' = live local preview; 'change' = commit.
function pushRestaurantColor(key, color) { try { call('theme:set', { key, color }); } catch (_) {} }
on($('#theme-color-input'), 'input', e => {
    applyTheme(e.target.value);
    localStorage.setItem('boss-theme-color', e.target.value);
    $$('#theme-presets .color-preset').forEach(b => b.classList.toggle('active', b.dataset.c.toLowerCase() === e.target.value.toLowerCase()));
});
on($('#theme-color-input'), 'change', e => pushRestaurantColor('brand', e.target.value));
on($('#theme-bg-input'), 'input', e => {
    applyBackground(e.target.value);
    localStorage.setItem('boss-theme-bg', e.target.value);
    $$('#bg-presets .color-preset').forEach(b => b.classList.toggle('active', b.dataset.bg.toLowerCase() === e.target.value.toLowerCase()));
});
on($('#theme-bg-input'), 'change', e => pushRestaurantColor('bg', e.target.value));
document.addEventListener('click', e => {
    const c = e.target.closest('#theme-presets .color-preset');
    if (c) {
        applyTheme(c.dataset.c);
        localStorage.setItem('boss-theme-color', c.dataset.c);
        const inp = $('#theme-color-input'); if (inp) inp.value = c.dataset.c;
        $$('#theme-presets .color-preset').forEach(b => b.classList.toggle('active', b === c));
        pushRestaurantColor('brand', c.dataset.c);
        return;
    }
    const bg = e.target.closest('#bg-presets .color-preset');
    if (bg) {
        applyBackground(bg.dataset.bg);
        localStorage.setItem('boss-theme-bg', bg.dataset.bg);
        const bi = $('#theme-bg-input'); if (bi) bi.value = bg.dataset.bg;
        $$('#bg-presets .color-preset').forEach(b => b.classList.toggle('active', b === bg));
        pushRestaurantColor('bg', bg.dataset.bg);
        return;
    }
    const s = e.target.closest('#size-grid .size-btn');
    if (s) {
        applySize(s.dataset.size);
        localStorage.setItem('boss-theme-size', s.dataset.size);
        $$('#size-grid .size-btn').forEach(b => b.classList.toggle('active', b === s));
    }
});
on($('#theme-reset-personal'), 'click', () => {
    localStorage.removeItem('boss-theme-color');
    localStorage.removeItem('boss-theme-bg');
    localStorage.removeItem('boss-theme-size');
    localStorage.removeItem('boss-theme-opacity');
    // Reset to the SERVER default (Config.theme), not a hard-coded colour.
    applyTheme(serverThemeDefault('brand', '#1F5EFF'));
    applyBackground(serverThemeDefault('bg', '#131314'));
    applySize('m'); applyOpacity(100);
    primeColorPresets();
    // Also clear the restaurant-wide override so all staff revert to default.
    try { call('theme:reset'); } catch (_) {}
});

/* ============================================================
   THEME BOOT — apply the saved/default theme the MOMENT the NUI
   loads, BEFORE the menu is ever opened, so the in-world 3D
   marker is already tinted with the player's colour. Without
   this the marker stayed on the CSS default until the menu was
   opened once (or the resource restarted).
   ============================================================ */
function bootTheme(serverTheme) {
    // Cache the server-wide default (Config.theme) pushed from Lua so
    // serverThemeDefault() works even before a full bootstrap (which only
    // runs for a boss when they actually open the menu).
    if (serverTheme && typeof serverTheme === 'object') {
        state.config = state.config || {};
        state.config.theme = Object.assign({}, state.config.theme || {}, serverTheme);
    }
    applyTheme(localStorage.getItem('boss-theme-color') || serverThemeDefault('brand', '#1F5EFF'));
    applyBackground(localStorage.getItem('boss-theme-bg') || serverThemeDefault('bg', '#131314'));
    applySize(localStorage.getItem('boss-theme-size') || 'm');
    applyOpacity(localStorage.getItem('boss-theme-opacity') || 100);
}

// Apply personal choices immediately on load (server default arrives a
// moment later via the 'themeBoot' message from the client script).
bootTheme();

/* ── Quick search (header): jump straight to a player or employee ── */
function _quickResults(q) {
    q = q.toLowerCase().trim();
    if (!q) return [];
    const out = [], seen = new Set();
    (state.players || []).forEach(p => {
        if ((p.name || '').toLowerCase().includes(q)) {
            out.push({ type: 'player', id: p.id, name: p.name, sub: (p.jobLabel || p.job || 'No job'), online: true });
            seen.add((p.name || '').toLowerCase());
        }
    });
    (state.employees || []).forEach(e => {
        const key = (e.name || '').toLowerCase();
        if (key.includes(q) && !seen.has(key)) {
            out.push({ type: 'emp', id: e.identifier, name: e.name, sub: 'Grade ' + e.grade + ' · ' + (e.online ? 'online' : 'offline'), online: !!e.online });
        }
    });
    return out.slice(0, 8);
}
function renderQuickSearch() {
    const box = $('#boss-search-results'); if (!box) return;
    const q = $('#boss-search')?.value || '';
    if (!q.trim()) { box.hidden = true; box.innerHTML = ''; return; }
    const res = _quickResults(q);
    box.hidden = false;
    box.innerHTML = res.length ? res.map(r => `
        <button class="cc-search-item" data-type="${r.type}" data-id="${escapeAttr(r.id)}" data-name="${escapeAttr(r.name)}">
            <span class="cc-search-ic"><i class="fa-solid fa-${r.type === 'player' ? 'user' : 'id-badge'}"></i></span>
            <span class="cc-search-meta">
                <span class="cc-search-name">${escapeHTML(r.name)}</span>
                <span class="cc-search-sub">${escapeHTML(r.sub)}</span>
            </span>
            <span class="cc-search-tag ${r.online ? 'online' : ''}">${r.online ? 'Online' : 'Offline'}</span>
        </button>`).join('') : `<div class="cc-search-empty">No matches for "${escapeHTML(q.trim())}"</div>`;
}
on($('#boss-search'), 'input', renderQuickSearch);
on($('#boss-search'), 'focus', renderQuickSearch);
on($('#boss-search'), 'keydown', e => {
    if (e.key === 'Escape') { e.target.value = ''; const b = $('#boss-search-results'); if (b) b.hidden = true; }
});
on($('#boss-search-results'), 'click', e => {
    const it = e.target.closest('.cc-search-item'); if (!it) return;
    const { type, id, name } = it.dataset;
    const inp = $('#boss-search'); if (inp) inp.value = '';
    const box = $('#boss-search-results'); if (box) box.hidden = true;
    if (type === 'player') {
        setTab('players');
        renderPlayers();
        selectPlayer(id);
        const card = document.querySelector(`#players-list .player-card[data-id="${id}"]`);
        if (card) card.scrollIntoView({ block: 'nearest' });
    } else {
        setTab('employees');
        const s = $('#emp-search'); if (s) { s.value = name; renderEmployees(); }
    }
});
document.addEventListener('click', e => {
    if (!e.target.closest('.cc-search')) { const b = $('#boss-search-results'); if (b) b.hidden = true; }
});
on($('#settings-refresh'), 'click', () => { refreshAll(); toast('Refreshed', 'success'); });

/* ============================================================
   QUICK ACTIONS
   ============================================================ */
document.addEventListener('click', e => {
    const q = e.target.closest('[data-quick]'); if (!q) return;
    const act = q.dataset.quick;
    if (act === 'hire')     { setTab('employees'); setTimeout(() => $('#emp-hire-btn')?.click(), 80); }
    if (act === 'payroll')  { setTab('payroll'); }
    if (act === 'deposit')  { setTab('treasury'); }
    if (act === 'announce') { setTab('announce'); }
});

/* ============================================================
   CONFIRM + INPUT DIALOGS
   ============================================================ */
function confirmDlg(message, onYes) {
    setText('#alert-title', 'Confirm');
    const c = $('#alert-content'); if (c) c.textContent = message;
    const overlay = $('#alert-overlay'); if (overlay) overlay.hidden = false;
    function close() {
        if (overlay) overlay.hidden = true;
        document.removeEventListener('click', clickHandler);
    }
    function clickHandler(e) {
        if (e.target.dataset?.action === 'alert-yes') { close(); onYes && onYes(); }
        if (e.target.dataset?.action === 'alert-no')  close();
    }
    document.addEventListener('click', clickHandler);
}
function inputDlg(opts) {
    setText('#input-title', opts.title || 'Input');
    const fields = $('#input-fields');
    if (fields) fields.innerHTML = (opts.fields || []).map(f => {
        const key = escapeHTML(f.key);
        const value = String(f.value ?? '');
        const control = f.type === 'select'
            ? `<select class="apex-input" data-key="${key}">
                ${(f.options || []).map(o => `
                    <option value="${escapeHTML(o.value)}" ${String(o.value) === value ? 'selected' : ''}>${escapeHTML(o.label || o.value)}</option>
                `).join('')}
            </select>`
            : `<input class="apex-input" type="${f.type || 'text'}" data-key="${key}" value="${escapeHTML(value)}">`;
        return `
            <div class="form-row">
                <label>${escapeHTML(f.label || '')}</label>
                ${control}
            </div>
        `;
    }).join('');
    const overlay = $('#input-overlay'); if (overlay) overlay.hidden = false;
    function close() {
        if (overlay) overlay.hidden = true;
        document.removeEventListener('click', clickHandler);
    }
    function clickHandler(e) {
        if (e.target.dataset?.action === 'input-submit') {
            const v = {};
            $$('#input-fields [data-key]').forEach(i => v[i.dataset.key] = i.value);
            close(); opts.onSubmit && opts.onSubmit(v);
        }
        if (e.target.dataset?.action === 'input-cancel') close();
    }
    document.addEventListener('click', clickHandler);
}

/* ============================================================
   NUI MESSAGE ROUTER
   ============================================================ */
/* ============================================================
   MENU + RECIPES EDITORS — native command-center tabs
   ============================================================ */
let ED = null;                 // { menu, style, recipes, items, anims }
let _edByName = {};            // name -> catalog item
let menuDraft = [];
let recDraft = null;
let recStation = 'preparation';
const REC_KINDS  = ['preparation', 'grill', 'assembly', 'fryer', 'drinks', 'coffee'];
const REC_LABELS = { preparation: 'Preparation', grill: 'Grill', assembly: 'Assembly', fryer: 'Fryer', drinks: 'Drinks', coffee: 'Coffee' };
const _arr = x => Array.isArray(x) ? x : [];

function loadEditor(then) {
    call('editor:data').then(r => {
        if (!r || !r.ok) { toast((r && r.error) || 'Could not load editor data', 'error'); return; }
        ED = r.data || {};
        _edByName = {};
        _arr(ED.items).forEach(it => _edByName[it.name] = it);
        menuDraft = _arr(ED.menu).map(m => ({
            name: m.name,
            label: m.label || (_edByName[m.name] && _edByName[m.name].label) || m.name,
            price: Math.round(m.price || 0),
            calories: m.calories || 0,
            image: (_edByName[m.name] && _edByName[m.name].image) || '',
        }));
        recDraft = {};
        REC_KINDS.forEach(k => {
            const src = ED.recipes && ED.recipes[k];
            recDraft[k] = Array.isArray(src) ? JSON.parse(JSON.stringify(src)) : [];
        });
        if (then) then();
    });
}
function itemOpts(sel) {
    return _arr(ED && ED.items).map(it => `<option value="${escapeHTML(it.name)}"${it.name === sel ? ' selected' : ''}>${escapeHTML(it.label)}</option>`).join('');
}

// Items that can be STOCKED/SOLD at the customer ped — every FOOD and DRINK
// item (mirrors the server's shop:deposit rule). The Menu builder offers
// exactly these, so the menu always matches what the ped can sell.
function sellableItems() {
    return _arr(ED && ED.items).filter(it => it.category === 'food' || it.category === 'drink');
}

// ── Searchable item picker (image + label + live search) ──────────
// `kind`+`idx`(+`extra`) identify the field it controls. `scope` = 'menu'
// restricts the list to sellable items; anything else = the full catalogue.
function itemPickOptions(q, current, scope) {
    q = (q || '').toLowerCase();
    const src = (scope === 'menu') ? sellableItems() : _arr(ED && ED.items);
    const rows = src
        .filter(it => !q || (it.label || '').toLowerCase().includes(q) || (it.name || '').toLowerCase().includes(q))
        .map(it => `<button type="button" class="ip-opt${it.name === current ? ' active' : ''}" data-name="${escapeHTML(it.name)}">`
            + `<img src="${escapeHTML(it.image || '')}" onerror="this.style.visibility='hidden'"><span>${escapeHTML(it.label || it.name)}</span></button>`)
        .join('');
    return rows || '<div class="ip-empty">No match</div>';
}
function itemPicker(kind, idx, currentName, extra, scope) {
    const it = _edByName[currentName] || { name: currentName, label: currentName, image: '' };
    const ex = (extra != null) ? ` data-pick-extra="${escapeHTML(String(extra))}"` : '';
    const sc = scope ? ` data-pick-scope="${escapeHTML(scope)}"` : '';
    return `<div class="item-pick" data-pick-kind="${kind}" data-pick-idx="${idx}"${ex}${sc} data-val="${escapeHTML(currentName)}">
        <button type="button" class="ip-trigger apex-input apex-input-sm">
            <img class="ip-img" src="${escapeHTML(it.image || '')}" onerror="this.style.visibility='hidden'">
            <span class="ip-label">${escapeHTML(it.label || it.name || '')}</span>
            <i class="fa-solid fa-chevron-down ip-caret"></i>
        </button>
        <div class="ip-menu" hidden>
            <div class="ip-search-wrap"><i class="fa-solid fa-magnifying-glass"></i><input type="text" class="ip-search" placeholder="Search item…" spellcheck="false"></div>
            <div class="ip-list">${itemPickOptions('', currentName, scope)}</div>
        </div>
    </div>`;
}

/* ── MENU ── */
const MENU_ACCENTS = ['#1F5EFF', '#8B5CF6', '#EC4899', '#EF4444', '#F97316', '#22C55E', '#06B6D4', '#EAB308'];
function openMenuEditor() {
    if (!ED) { loadEditor(() => { renderMenuPick(); renderMenuStyle(); renderMenuList(); }); return; }
    renderMenuPick(); renderMenuStyle(); renderMenuList();
}
function menuStyle() { ED.style = ED.style || { layout: 'grid', theme: 'dark', accent: '#1F5EFF' }; return ED.style; }
function renderMenuStyle() {
    const s = menuStyle();
    $$('#ms-layout button').forEach(b => b.classList.toggle('active', b.dataset.layout === (s.layout || 'grid')));
    $$('#ms-theme button').forEach(b => b.classList.toggle('active', b.dataset.theme === (s.theme || 'dark')));
    const ac = $('#ms-accent'); if (ac) ac.value = s.accent || '#1F5EFF';
    const lg = $('#ms-logo'); if (lg) lg.value = (s.logo && s.logo.indexOf('http') === 0) ? s.logo : '';
    const pr = $('#ms-presets');
    if (pr && !pr.dataset.built) {
        pr.dataset.built = '1';
        pr.innerHTML = MENU_ACCENTS.map(c => `<button class="ms-preset" style="background:${c}" data-accent="${c}"></button>`).join('');
    }
    $$('#ms-presets .ms-preset').forEach(b => b.classList.toggle('active', (b.dataset.accent || '').toLowerCase() === (s.accent || '').toLowerCase()));
}
function renderMenuPreview() {
    const wrap = $('#menu-preview'); if (!wrap) return;
    const s = menuStyle();
    const accent  = s.accent || '#1F5EFF';
    const layout  = s.layout || 'grid';
    const theme   = s.theme || 'dark';
    const hasLogo = !!(s.logo && s.logo.indexOf('http') === 0);
    const name    = (state.job && state.job.label) || 'Restaurant';

    // Render the SAME ementa the customer sees in the view menu (order-shell
    // read-only), so this preview is 1:1 with the live menu.
    const logo = hasLogo
        ? `<img class="order-logo" src="${escapeHTML(s.logo)}" onerror="this.style.display='none'">` : '';
    const head = `<header class="order-head">${logo}`
        + `<div class="order-head-left"><div>`
        + `<div class="order-eyebrow">View menu</div>`
        + `<div class="order-title">${escapeHTML(name)}</div>`
        + `</div></div></header>`;

    let gallery;
    if (!menuDraft.length) {
        gallery = `<section class="order-gallery"><div class="ementa-empty">No items on the menu yet</div></section>`;
    } else {
        const cards = menuDraft.map(m => {
            // Item image, with a fallback to the shipped local PNG if the
            // configured source is missing it (same as the live ementa).
            const fb   = 'nui://apex_restaurant/build/html/img/' + (m.name || 'restaurant_food') + '.png';
            const img  = m.image || fb;
            const desc = m.calories ? (m.calories + ' cal') : '';
            return `<div class="order-card">`
                + `<div class="order-card-img"><img src="${escapeHTML(img)}" data-fb="${escapeHTML(fb)}" onerror="this.onerror=null;this.src=this.dataset.fb"></div>`
                + `<div class="order-card-body">`
                + `<div class="order-card-label">${escapeHTML(m.label || m.name)}</div>`
                + (desc ? `<div class="order-card-desc">${escapeHTML(desc)}</div>` : '')
                + `<div class="order-card-foot"><span class="order-card-price">${escapeHTML(fmtMoney(m.price))}</span></div>`
                + `</div></div>`;
        }).join('');
        gallery = `<section class="order-gallery">${cards}</section>`;
    }

    wrap.className = 'menu-preview';
    wrap.innerHTML = `<div class="order-shell read-only layout-${layout} theme-${theme}${hasLogo ? ' has-logo' : ''}" style="--ementa-accent:${accent}">`
        + head + `<main class="order-body">${gallery}</main></div>`;
}
on($('#ms-layout'), 'click', e => { const b = e.target.closest('[data-layout]'); if (!b) return; menuStyle().layout = b.dataset.layout; renderMenuStyle(); renderMenuPreview(); });
on($('#ms-theme'), 'click', e => { const b = e.target.closest('[data-theme]'); if (!b) return; menuStyle().theme = b.dataset.theme; renderMenuStyle(); renderMenuPreview(); });
on($('#ms-presets'), 'click', e => { const b = e.target.closest('[data-accent]'); if (!b) return; menuStyle().accent = b.dataset.accent; renderMenuStyle(); renderMenuPreview(); });
on($('#ms-accent'), 'input', e => { menuStyle().accent = e.target.value; $$('#ms-presets .ms-preset').forEach(x => x.classList.remove('active')); renderMenuPreview(); });
on($('#ms-logo'), 'input', e => { const v = (e.target.value || '').trim(); menuStyle().logo = v.indexOf('https://i.ibb.co/') === 0 ? v : (v === '' ? null : menuStyle().logo); renderMenuPreview(); });
on($('#ms-logo-clear'), 'click', () => { menuStyle().logo = null; const lg = $('#ms-logo'); if (lg) lg.value = ''; renderMenuPreview(); });
function renderMenuPick() {
    const host = $('#menu-add-pick'); if (!host) return;
    const on = new Set(menuDraft.map(m => m.name));
    // Only items that can actually be stocked/sold at the customer ped
    // (FOOD + a recipe result) — same list employees can deposit there.
    const avail = sellableItems().filter(it => !on.has(it.name));
    const emptyLabel = 'All items added';
    host.innerHTML = avail.length
        ? itemPicker('menuadd', 0, avail[0].name, null, 'menu')
        : '<div class="item-pick" data-val=""><button type="button" class="ip-trigger apex-input apex-input-sm" disabled><span class="ip-label">' + emptyLabel + '</span></button></div>';
}
function renderMenuList() {
    const wrap = $('#menu-list'); if (!wrap) return;
    setText('#menu-count', menuDraft.length + (menuDraft.length === 1 ? ' item' : ' items'));
    wrap.innerHTML = menuDraft.length ? menuDraft.map((m, i) => `
        <div class="ed-row">
            <img class="ed-img" src="${escapeHTML(m.image || '')}" onerror="this.style.visibility='hidden'">
            <div class="ed-row-main"><div class="ed-row-name">${escapeHTML(m.label || m.name)}</div><div class="ed-row-sub">${escapeHTML(m.name)} · ${m.calories || 0} cal</div></div>
            <div class="ed-price"><span>$</span><input type="number" min="0" class="apex-input mono" data-price="${i}" value="${m.price || 0}"></div>
            <button class="icon-btn ghost" data-mdel="${i}" title="Remove"><i class="fa-solid fa-trash"></i></button>
        </div>`).join('') : '<div class="ed-empty">No items yet — pick one above and hit Add.</div>';
    renderMenuPreview();
}
on($('#menu-add-btn'), 'click', () => {
    const pick = $('#menu-add-pick .item-pick');
    const name = pick && pick.dataset.val;
    if (!name) return;
    if (menuDraft.some(m => m.name === name)) { toast('Already on the menu', 'info'); return; }
    const it = _edByName[name]; if (!it) return;
    menuDraft.push({ name: it.name, label: it.label, price: Math.round(it.price || 0), calories: it.calories || 0, image: it.image || '' });
    renderMenuPick(); renderMenuList();
});
on($('#menu-save-btn'), 'click', () => {
    call('menu:save', { menu: menuDraft.map(m => ({ name: m.name, label: m.label, price: m.price })), style: ED && ED.style }).then(r => {
        toast(r && r.ok ? 'Menu saved & broadcast' : ((r && r.error) || 'Save failed'), r && r.ok ? 'success' : 'error');
    });
});
on($('#menu-list'), 'input', e => {
    const pin = e.target.closest('[data-price]');
    if (pin && menuDraft[+pin.dataset.price]) menuDraft[+pin.dataset.price].price = Math.max(0, parseInt(pin.value, 10) || 0);
});
on($('#menu-list'), 'click', e => {
    const del = e.target.closest('[data-mdel]');
    if (del) { menuDraft.splice(+del.dataset.mdel, 1); renderMenuPick(); renderMenuList(); }
});

/* ── RECIPES ── */
function openRecipesEditor() {
    if (!ED) { loadEditor(() => { renderRecSubtabs(); renderRecList(); }); return; }
    renderRecSubtabs(); renderRecList();
}
function renderRecSubtabs() {
    const wrap = $('#rec-subtabs'); if (!wrap) return;
    wrap.innerHTML = REC_KINDS.map(k => `<button class="rec-subtab${k === recStation ? ' active' : ''}" data-station="${k}">${REC_LABELS[k]}<span class="of-count">${_arr(recDraft && recDraft[k]).length}</span></button>`).join('');
}
function itemImg(n) { return (_edByName[n] && _edByName[n].image) || ''; }
function imgTag(n, cls) { return `<img class="${cls}" src="${escapeHTML(itemImg(n))}" onerror="this.style.visibility='hidden'">`; }
function renderRecList() {
    const wrap = $('#rec-list'); if (!wrap || !recDraft) return;
    const list = recDraft[recStation] || [];
    const isPrep = recStation === 'preparation';
    if (!list.length) { wrap.innerHTML = '<div class="ed-empty">No recipes for this station — add one.</div>'; return; }
    wrap.innerHTML = list.map((rec, i) => {
        if (isPrep) {
            return `<div class="rec-card">
                <div class="rec-card-head"><span class="rec-card-n">#${i + 1}</span><span class="rec-head-spacer"></span><button class="icon-btn ghost" data-rdel="${i}"><i class="fa-solid fa-trash"></i></button></div>
                <div class="rec-prep">
                    <div class="rec-pick"><label>Input</label><div class="rec-pick-row">${itemPicker('rinput', i, rec.input)}</div></div>
                    <i class="fa-solid fa-arrow-right rec-arrow"></i>
                    <div class="rec-pick"><label>Output</label><div class="rec-pick-row">${itemPicker('routput', i, rec.output)}</div></div>
                </div></div>`;
        }
        const ings = Object.keys(rec.ingredients || {}).map(n =>
            `<div class="rec-ing">${itemPicker('ingname', i, n, n)}<input type="number" min="1" class="apex-input mono rec-qty" data-ingqty="${i}" data-n="${escapeHTML(n)}" value="${rec.ingredients[n]}"><button class="icon-btn ghost" data-ingdel="${i}" data-n="${escapeHTML(n)}"><i class="fa-solid fa-xmark"></i></button></div>`).join('');
        const animOpts = `<option value="">Auto (by category)</option>` + _arr(ED.anims).map(a => `<option value="${escapeHTML(a.key)}"${rec.anim === a.key ? ' selected' : ''}>${escapeHTML(a.label)}</option>`).join('');
        return `<div class="rec-card">
            <div class="rec-card-head">
                <span class="rec-card-n">#${i + 1}</span>
                ${itemPicker('rresult', i, rec.result)}
                <button class="icon-btn ghost" data-rdel="${i}"><i class="fa-solid fa-trash"></i></button>
            </div>
            <div class="rec-field"><label>Ingredients</label><div class="rec-ings">${ings}</div><button class="btn btn-ghost btn-sm" data-ingadd="${i}"><i class="fa-solid fa-plus"></i> Ingredient</button></div>
            <div class="rec-field"><label>Eat / drink animation</label><select class="apex-input apex-input-sm" data-ranim="${i}">${animOpts}</select></div></div>`;
    }).join('');
}
on($('#rec-subtabs'), 'click', e => {
    const b = e.target.closest('[data-station]'); if (!b) return;
    recStation = b.dataset.station; renderRecSubtabs(); renderRecList();
});
on($('#rec-add-btn'), 'click', () => {
    if (!recDraft) return;
    const first = _arr(ED.items)[0] || { name: '' };
    if (recStation === 'preparation') recDraft.preparation.push({ input: first.name, output: first.name });
    else recDraft[recStation].push({ result: first.name, ingredients: { [first.name]: 1 }, anim: '' });
    renderRecSubtabs(); renderRecList();
});
on($('#rec-save-btn'), 'click', () => {
    call('recipes:save', { recipes: recDraft }).then(r => {
        toast(r && r.ok ? 'Recipes saved & broadcast' : ((r && r.error) || 'Save failed'), r && r.ok ? 'success' : 'error');
    });
});
function closeItemPickers() { $$('.item-pick .ip-menu').forEach(m => { m.hidden = true; }); }
function applyItemPick(pick, name) {
    const kind = pick.dataset.pickKind;
    // Recipe-bound pickers mutate recDraft; standalone ones (e.g. the menu
    // "add" picker) just hold the chosen value, read elsewhere.
    if (kind === 'rinput' || kind === 'routput' || kind === 'rresult' || kind === 'ingname') {
        const list = recDraft && recDraft[recStation]; if (!list) return;
        const rec = list[+pick.dataset.pickIdx]; if (!rec) return;
        if (kind === 'rinput')       rec.input  = name;
        else if (kind === 'routput') rec.output = name;
        else if (kind === 'rresult') rec.result = name;
        else if (kind === 'ingname') {
            const oldN = pick.dataset.pickExtra;
            if (name !== oldN) {
                const q = rec.ingredients[oldN] || 1;
                delete rec.ingredients[oldN]; rec.ingredients[name] = q;
                renderRecList();   // key rename → re-render keeps every row in sync
            }
            return;
        }
    }
    // In-place visual update (image + label updates with the item) — snappy.
    pick.dataset.val = name;
    const it = _edByName[name] || { name, label: name, image: '' };
    const img = pick.querySelector('.ip-img'), lbl = pick.querySelector('.ip-label');
    if (img) { img.src = it.image || ''; img.style.visibility = ''; }
    if (lbl) lbl.textContent = it.label || it.name || name;
}

// Item-picker behaviour is delegated on the document so it works for EVERY
// picker (recipes + the menu builder), regardless of its container.
document.addEventListener('click', e => {
    let t;
    if ((t = e.target.closest('.ip-trigger'))) {           // open / close
        const pick = t.closest('.item-pick'), menu = pick && pick.querySelector('.ip-menu');
        const open = menu && !menu.hidden;
        closeItemPickers();
        if (menu && !open) {
            menu.hidden = false;
            // Absolute (anchored to the trigger) so a transformed ancestor
            // can't throw it across the screen. Flip up when there's no room.
            const r = t.getBoundingClientRect();
            menu.classList.toggle('ip-up', (window.innerHeight - r.bottom) < 260 && r.top > 260);
            const lst = menu.querySelector('.ip-list'); if (lst) lst.innerHTML = itemPickOptions('', pick.dataset.val, pick.dataset.pickScope);
            const s = menu.querySelector('.ip-search'); if (s) { s.value = ''; setTimeout(() => s.focus(), 0); }
        }
        return;
    }
    if ((t = e.target.closest('.ip-opt'))) {               // choose an item
        const pick = t.closest('.item-pick'); if (pick) applyItemPick(pick, t.dataset.name);
        closeItemPickers();
        return;
    }
    if (!e.target.closest('.item-pick')) closeItemPickers();
});
document.addEventListener('input', e => {                  // live search filter
    const s = e.target.closest('.ip-search'); if (!s) return;
    const pick = s.closest('.item-pick'), lst = pick && pick.querySelector('.ip-list');
    if (lst) lst.innerHTML = itemPickOptions(s.value, pick.dataset.val, pick.dataset.pickScope);
});

// Recipe-only row controls (animation / qty / delete / add ingredient).
on($('#rec-list'), 'change', e => {
    const list = recDraft && recDraft[recStation]; if (!list) return;
    const t = e.target.closest('[data-ranim]');
    if (t) list[+t.dataset.ranim].anim = t.value;
});
on($('#rec-list'), 'input', e => {
    const q = e.target.closest('[data-ingqty]');
    if (q) { const rec = recDraft[recStation][+q.dataset.ingqty]; if (rec) rec.ingredients[q.dataset.n] = Math.max(1, parseInt(q.value, 10) || 1); }
});
on($('#rec-list'), 'click', e => {
    const list = recDraft && recDraft[recStation]; if (!list) return;
    let t;
    if ((t = e.target.closest('[data-rdel]')))   { list.splice(+t.dataset.rdel, 1); renderRecSubtabs(); renderRecList(); return; }
    if ((t = e.target.closest('[data-ingdel]'))) { const rec = list[+t.dataset.ingdel]; if (rec) { delete rec.ingredients[t.dataset.n]; renderRecList(); } return; }
    if ((t = e.target.closest('[data-ingadd]'))) {
        const rec = list[+t.dataset.ingadd];
        if (rec) { const avail = _arr(ED.items).find(it => !(it.name in rec.ingredients)) || _arr(ED.items)[0]; if (avail) { rec.ingredients[avail.name] = 1; renderRecList(); } }
        return;
    }
});

/* ============================================================
   ANALYTICS — restaurant business dashboard (fed by the host)
   ============================================================ */
let _anData = null;
let _anFilter = 'all';
function refreshAnalytics() {
    call('analytics:get').then(r => {
        if (!r || !r.ok) return;
        _anData = r.data || {};
        renderAnalytics();
    });
}
function renderAnalytics() {
    const d = _anData || {};
    setText('#an-funds', fmtMoney(d.funds || 0));
    setText('#an-rev7',  fmtMoney(d.revenue7dSum || 0));
    const tot = d.totals || {};
    setText('#an-emp',   (tot.online || 0) + '/' + (tot.employees || 0));
    setText('#an-hours', fmtDur(tot.totalSeconds || 0));

    const filt = $('#an-filters');
    if (filt && !filt.dataset.built) {
        filt.dataset.built = '1';
        filt.innerHTML = ['all', 'register', 'delivery', 'customer'].map(s =>
            `<button class="an-filter${s === _anFilter ? ' active' : ''}" data-src="${s}">${s[0].toUpperCase() + s.slice(1)}</button>`).join('');
        filt.addEventListener('click', e => {
            const b = e.target.closest('[data-src]'); if (!b) return;
            _anFilter = b.dataset.src;
            $$('.an-filter').forEach(x => x.classList.toggle('active', x.dataset.src === _anFilter));
            renderAnChart();
        });
    }
    renderAnChart();

    const src = $('#an-sources');
    if (src) {
        const by = d.bySource || {};
        const entries = Object.keys(by).map(k => [k, by[k]]).sort((a, b) => b[1] - a[1]);
        const max = entries.reduce((m, e) => Math.max(m, e[1]), 0) || 1;
        src.innerHTML = entries.length
            ? entries.map(([k, v]) =>
                `<div class="an-src"><span class="an-src-k">${escapeHTML(k)}</span><div class="an-src-bar"><div class="an-src-fill" style="width:${Math.round(v / max * 100)}%"></div></div><span class="an-src-v mono">${escapeHTML(fmtMoney(v))}</span></div>`).join('')
            : '<div class="an-empty">No revenue logged yet</div>';
    }

    const duty = $('#an-duty');
    if (duty) {
        const list = (d.employees || []).filter(e => e.onDuty);
        duty.innerHTML = list.length
            ? list.map(e =>
                `<div class="an-duty-row"><span class="an-dot"></span><span class="an-duty-name">${escapeHTML(e.name || 'Employee')}</span><span class="an-duty-grade">G${e.grade || 0}</span><span class="an-duty-time mono">${escapeHTML(fmtDur(e.seconds || 0))}</span></div>`).join('')
            : '<div class="an-empty">Nobody on duty</div>';
    }
}
function renderAnChart() {
    const wrap = $('#an-chart'); if (!wrap) return;
    const d = _anData || {};
    const days = d.revenue7d || [];
    const vals = days.map(x => _anFilter === 'all' ? (x.value || 0) : ((x.sources && x.sources[_anFilter]) || 0));
    const max = vals.reduce((m, v) => Math.max(m, v), 0);
    if (max <= 0) { wrap.innerHTML = '<div class="an-empty an-chart-empty">No revenue logged in the last 7 days</div>'; return; }
    wrap.innerHTML = '<div class="an-bars">' + days.map((x, i) => {
        const pct = Math.max(2, Math.round(vals[i] / max * 100));
        return `<div class="an-bar-col"><div class="an-bar-track"><div class="an-bar-fill" style="height:${pct}%" title="${escapeHTML(fmtMoney(vals[i]))}"></div></div><span class="an-bar-lbl">${escapeHTML(x.label || '')}</span></div>`;
    }).join('') + '</div>';
}

function _bfTellParent(action) { try { if (window.parent && window.parent !== window) window.parent.postMessage({ action: action }, '*'); } catch (_) {} }

window.addEventListener('message', e => {
    const m = e.data || {};
    if (m.action === 'themeBoot') bootTheme(m.data && m.data.theme);
    if (m.action === 'open')  {
        try { openShell(m.data || {}); post('dbg', { at: 'open-shown' }); }
        catch (err) { post('dbg', { at: 'open-error', err: String(err && err.stack || err) }); }
        _bfTellParent('bf_open_ack');
    }
    if (m.action === 'close') closeShell();
    if (m.action === 'notify') localToast(m.data?.msg || '', m.data?.kind || 'info', m.data?.title || '', m.data?.duration || 4500);
    if (m.action === 'treasuryRefresh') refreshTreasury();
    if (m.action === 'announce') {
        if (state.activeTab === 'comms') {
            setTimeout(refreshLogs, 350);
            setTimeout(refreshLogs, 1200);
        }
    }
    if (m.action === 'worldPrompt') {
        const el = $('#world-prompt'); if (!el) return;
        if (m.data?.show) {
            setText('#world-prompt-label', m.data.label || '');
            el.hidden = false;
        } else el.hidden = true;
    }
    // ─── 3D Marker (apex_restaurant-style) ───
    if (m.action === 'show3DIcon') {
        const el = $('#world-3d-icon');
        if (!el) { console.warn('[apex_bossmenu] #world-3d-icon missing'); return; }
        const x = (Number(m.x) || 0) * window.innerWidth;
        const y = (Number(m.y) || 0) * window.innerHeight;
        const scale = Number(m.scale) || 1;
        el.style.left      = x + 'px';
        el.style.top       = y + 'px';
        el.style.transform = `translate(-50%, -50%) scale(${scale})`;
        const ic = $('#w3d-icon');
        if (ic) ic.className = 'fa-solid fa-' + (m.icon || 'crown');
        // The label is a <span> inside the bubble; the [E] chip sits next to it.
        const lbl = $('#w3d-label'); if (lbl) lbl.textContent = m.label || 'Open';
        // Allow the key to be configured from Lua (defaults to "E").
        const keyEl = document.querySelector('.w3d-key'); if (keyEl) keyEl.textContent = m.key || 'E';
        el.removeAttribute('hidden');
        el.style.display = '';
    }
    if (m.action === 'hide3DIcon') {
        const el = $('#world-3d-icon');
        if (el) { el.setAttribute('hidden', ''); el.style.display = 'none'; }
    }

    // ─── Multi-job picker ───
    if (m.action === 'multijob_open')  openMultijob(m.data || {});
    if (m.action === 'multijob_close') closeMultijob();

    // ─── Creator (zone editor) ───
    if (m.action === 'creator_open')  openCreator(m.data || {});
    if (m.action === 'creator_close') closeCreator();
    if (m.action === 'creator_jobs') {
        creator.jobs = (m.data && m.data.jobs) || [];
        populateJobsDropdown();
    }
    if (m.action === 'creator_laser_hud') {
        const hud = $('#cr-laser-hud');
        if (hud) hud.hidden = !(m.data && m.data.show);
    }
    if (m.action === 'creator_laser_pick') {
        // Restore the panel and stamp the coords on the form.
        const overlay = $('#creator-overlay'); if (overlay) overlay.hidden = false;
        const d = m.data || {};
        applyCoords(d);
        toast(d.surface === false ? 'No surface, using max range' : 'Coords captured',
              d.surface === false ? 'warning' : 'success');
    }
    if (m.action === 'creator_laser_cancel') {
        const overlay = $('#creator-overlay'); if (overlay) overlay.hidden = false;
    }
});

document.addEventListener('keydown', e => {
    if (state.open && e.key === 'Escape') post('close');
});

/* ============================================================
   MULTI-JOB PICKER — /jobs or hotkey
   ============================================================ */
const mj = { open: false, history: [], current: null, config: null };

function openMultijob(data) {
    mj.open    = true;
    mj.history = data.history || [];
    mj.current = data.current || null;
    mj.config  = data.config  || {};
    renderMultijob();
    const el = $('#multijob-overlay'); if (el) el.hidden = false;
}
function closeMultijob() {
    mj.open = false;
    const el = $('#multijob-overlay'); if (el) el.hidden = true;
}

function renderMultijob() {
    // Header — current job
    setText('#mj-current-job',   mj.current?.label || mj.current?.job || 'Unemployed');
    setText('#mj-current-grade', mj.current?.gradeLabel || (mj.current ? ('Grade ' + (mj.current.grade ?? 0)) : ''));
    const cap = mj.config?.limit;
    setText('#mj-cap', cap ? `History capped at ${cap} jobs` : '');

    const root = $('#mj-list'); if (!root) return;
    if (!mj.history.length) {
        root.innerHTML = `<div class="mj-empty">You haven't held any job yet. New jobs are added automatically as you switch.</div>`;
        return;
    }
    root.innerHTML = mj.history.map((j, i) => {
        const isCur = !!j.isCurrent;
        const keyHint = i < 9 ? `<span class="mj-row-key">[${i + 1}]</span>` : '';
        return `
            <div class="mj-row ${isCur ? 'is-current' : ''}" data-job="${escapeHTML(j.job)}">
                <div class="mj-row-icon"><i class="fa-solid fa-${_jobIcon(j.job, j.label)}"></i></div>
                <div class="mj-row-text">
                    <div class="mj-row-job">${escapeHTML(j.label || j.job)} ${keyHint}${isCur ? '<span class="mj-row-now"><i class="fa-solid fa-circle"></i> Active</span>' : ''}</div>
                    <div class="mj-row-meta">
                        <strong>${escapeHTML(j.gradeLabel || ('Grade ' + (j.grade ?? 0)))}</strong>
                        · ${escapeHTML(j.job)}
                    </div>
                </div>
                <div class="mj-row-actions">
                    ${isCur ? '' : `<button class="mj-row-forget" data-mj-forget="${escapeHTML(j.job)}" title="Forget this job">
                        <i class="fa-regular fa-trash-can"></i>
                    </button>`}
                </div>
                ${isCur
                    ? `<button class="btn btn-ghost mj-row-switch" disabled><i class="fa-solid fa-check"></i> Working</button>`
                    : `<button class="btn btn-primary mj-row-switch" data-mj-switch="${escapeHTML(j.job)}">Switch</button>`}
            </div>
        `;
    }).join('');
}

// Map a job name/label to a fitting Font Awesome icon (briefcase fallback)
function _jobIcon(name, label) {
    const s = ((name || '') + ' ' + (label || '')).toLowerCase();
    const map = [
        [/police|cop|sheriff|leo|lspd|bcso/, 'shield-halved'],
        [/ambulance|ems|medic|doctor|hospital|ambu/, 'truck-medical'],
        [/mechanic|garage|tuner|bennys|repair/, 'screwdriver-wrench'],
        [/taxi|cab|uber/, 'taxi'],
        [/realestate|realtor|estate|housing/, 'house'],
        [/lawyer|judge|legal|attorney/, 'scale-balanced'],
        [/cardealer|dealer|vehicleshop/, 'car'],
        [/bank|finance|treasur/, 'building-columns'],
        [/food|burger|restaurant|chef|cook|bar|pizza/, 'utensils'],
        [/gov|mayor|city|admin/, 'landmark'],
        [/news|reporter|media/, 'newspaper'],
        [/trucker|delivery|logistics|cargo/, 'truck'],
        [/farm|agri|fish|hunt/, 'tractor'],
        [/gang|mafia|cartel|crim/, 'user-secret'],
    ];
    for (const [re, ic] of map) if (re.test(s)) return ic;
    return 'briefcase';
}

on($('#mj-close'),   'click', () => post('multijob_close'));
on($('#mj-refresh'), 'click', () => {
    post('multijob_refresh').then(r => {
        if (!r?.ok || !r.data) return;
        mj.history = r.data.history || [];
        mj.current = r.data.current || null;
        mj.config  = r.data.config  || mj.config;
        renderMultijob();
    });
});

document.addEventListener('click', e => {
    const sw = e.target.closest('[data-mj-switch]');
    if (sw) {
        const job = sw.dataset.mjSwitch;
        if (!job) return;
        if (mj.current && mj.current.job === job) return;
        post('multijob_switch', { job });
        return;
    }
    const fg = e.target.closest('[data-mj-forget]');
    if (fg) {
        const job = fg.dataset.mjForget;
        if (!job) return;
        confirmDlg(`Forget "${job}" from your job history?`, () => {
            post('multijob_forget', { job }).then(() => {
                post('multijob_refresh').then(r => {
                    if (!r?.ok || !r.data) return;
                    mj.history = r.data.history || [];
                    mj.current = r.data.current || null;
                    mj.config  = r.data.config  || mj.config;
                    renderMultijob();
                });
            });
        });
    }
});

// Number keys 1..9 quick-switch
document.addEventListener('keydown', e => {
    if (!mj.open) return;
    if (e.key === 'Escape') { post('multijob_close'); return; }
    const n = parseInt(e.key, 10);
    if (!isNaN(n) && n >= 1 && n <= 9 && mj.history[n - 1]) {
        const job = mj.history[n - 1].job;
        if (mj.current && mj.current.job === job) return;
        post('multijob_switch', { job });
    }
});

/* ============================================================
   CREATOR (zone editor) — admin only
   ============================================================ */
const creator = {
    open: false,
    zones: [],
    jobs: [],
    editingId: null,
};

function openCreator(data) {
    creator.open = true;
    creator.zones = data.zones || [];
    creator.jobs  = data.jobs  || creator.jobs || [];
    creator.editingId = null;
    populateJobsDropdown();
    renderCreatorList();
    resetCreatorForm();
    const el = $('#creator-overlay'); if (el) el.hidden = false;
}
function closeCreator() {
    creator.open = false;
    const el = $('#creator-overlay'); if (el) el.hidden = true;
    const hud = $('#cr-laser-hud'); if (hud) hud.hidden = true;
    post('creator_close');
}

function populateJobsDropdown() {
    const sel = $('#cr-job'); if (!sel) return;
    const current = sel.value;
    const opts = ['<option value="">Select a job…</option>']
        .concat((creator.jobs || []).map(j =>
            `<option value="${escapeHTML(j.name)}">${escapeHTML(j.label || j.name)} (${escapeHTML(j.name)})</option>`
        ));
    sel.innerHTML = opts.join('');
    if (current) sel.value = current;
}

function renderCreatorList() {
    const root = $('#cr-zone-list'); if (!root) return;
    setText('#cr-zone-count', creator.zones.length);
    if (!creator.zones.length) {
        root.innerHTML = `<div class="cr-zone-empty">
            <span class="cr-zone-empty-ic"><i class="fa-solid fa-map-pin"></i></span>
            <span>No zones yet</span>
            <small>Hit <b>New zone</b> to place your first one.</small>
        </div>`;
        return;
    }
    root.innerHTML = creator.zones.map(z => `
        <div class="cr-zone-row ${creator.editingId === z.id ? 'active' : ''}" data-id="${escapeHTML(z.id)}">
            <span class="cr-zone-ic"><i class="fa-solid fa-${escapeAttr(z.icon || 'crown')}"></i></span>
            <div class="cr-zone-info">
                <div class="cr-zone-name">${escapeHTML(z.label || z.id)}</div>
                <div class="cr-zone-meta">${escapeHTML(z.job)} · ${(z.coords?.x || 0).toFixed(0)}, ${(z.coords?.y || 0).toFixed(0)}, ${(z.coords?.z || 0).toFixed(0)}</div>
            </div>
            <button class="icon-btn" data-cr-del="${escapeHTML(z.id)}" title="Delete"><i class="fa-solid fa-trash-can"></i></button>
        </div>
    `).join('');
}

function resetCreatorForm(z) {
    creator.editingId = z?.id || null;
    setText('#cr-form-eyebrow', z ? 'Editing zone' : 'New zone');
    setText('#cr-form-title',   z ? `${z.label || z.id}` : 'New boss-menu zone');
    const set = (id, v) => { const el = $(id); if (el) el.value = v; };
    set('#cr-id',     z?.id    || '');
    set('#cr-job',    z?.job   || '');
    set('#cr-label',  z?.label || 'Boss Menu');
    applyCreatorIcon(z?.icon || 'crown');
    set('#cr-radius', z?.radius || 2.0);
    set('#cr-x', z?.coords?.x ?? 0);
    set('#cr-y', z?.coords?.y ?? 0);
    set('#cr-z', z?.coords?.z ?? 0);
    set('#cr-h', z?.coords?.w ?? 0);
    const blip = $('#cr-blip'); if (blip) blip.checked = z ? !!z.blip : true;
    const idEl = $('#cr-id'); if (idEl) idEl.disabled = !!z;   // can't rename an existing zone
    updateCreatorPreview();
}

// Live preview of the in-world marker, mirrors the form fields
function updateCreatorPreview() {
    const icon = ($('#cr-icon')?.value || 'crown').trim() || 'crown';
    const ic = $('#cr-prev-icon'); if (ic) ic.className = 'fa-solid fa-' + icon;
    setText('#cr-prev-label', ($('#cr-label')?.value || 'Boss Menu').trim() || 'Boss Menu');
    const sel = $('#cr-job');
    const jobTxt = sel && sel.value ? (sel.options[sel.selectedIndex]?.text || sel.value) : 'No job selected';
    const jobEl = $('#cr-prev-job'); if (jobEl) jobEl.innerHTML = `<i class="fa-solid fa-briefcase"></i> ${escapeHTML(jobTxt)}`;
    const rad = (parseFloat($('#cr-radius')?.value) || 2).toFixed(1);
    const radEl = $('#cr-prev-radius'); if (radEl) radEl.innerHTML = `<i class="fa-solid fa-circle-dot"></i> ${rad}m`;
    const on = $('#cr-blip')?.checked;
    const blipEl = $('#cr-prev-blip'); if (blipEl) blipEl.innerHTML = `<i class="fa-solid fa-location-dot"></i> Blip ${on ? 'on' : 'off'}`;
}
['#cr-label', '#cr-radius'].forEach(id => on($(id), 'input', updateCreatorPreview));
['#cr-job', '#cr-blip'].forEach(id => on($(id), 'change', updateCreatorPreview));

/* ── Creator icon picker: dropdown of presets + custom name ── */
const CREATOR_ICONS = [
    'crown','shield-halved','briefcase','building','building-columns','landmark','star',
    'user-tie','users','user-secret','gavel','scale-balanced','car','truck-medical','screwdriver-wrench',
    'utensils','taxi','house','store','warehouse','gas-pump','hammer','wrench','fire',
    'helicopter','plane','ship','anchor','leaf','tree','fish','sack-dollar','vault','money-bill-wave',
    'key','id-card','headset','microphone','camera','dumbbell','syringe','pills','flask',
    'gun','handcuffs','traffic-light','road','box','clipboard','bell','flag','newspaper','tractor'
];
function applyCreatorIcon(name, fromCustom){
    name = (String(name == null ? 'crown' : name).trim().split(/\s+/).pop() || 'crown').replace(/^fa-/, '') || 'crown';
    const hidden = $('#cr-icon'); if (hidden) hidden.value = name;
    const glyph  = $('#cr-icon-glyph'); if (glyph) glyph.className = 'fa-solid fa-' + name;
    setText('#cr-icon-name', name);
    if (!fromCustom){
        const custom = $('#cr-icon-custom');
        if (custom) custom.value = CREATOR_ICONS.includes(name) ? '' : name;
    }
    $$('#cr-icon-grid .icon-opt').forEach(b => b.classList.toggle('active', b.dataset.icon === name));
    updateCreatorPreview();
}
function _toggleIconMenu(open){
    const picker = $('#cr-icon-picker'); const menu = $('#cr-icon-menu');
    if (!picker || !menu) return;
    const willOpen = (open != null) ? open : menu.hidden;
    menu.hidden = !willOpen;
    picker.classList.toggle('open', willOpen);
    if (willOpen){
        const cur = $('#cr-icon')?.value;
        $$('#cr-icon-grid .icon-opt').forEach(b => b.classList.toggle('active', b.dataset.icon === cur));
    }
}
(function initIconPicker(){
    const grid = $('#cr-icon-grid'); if (!grid) return;
    grid.innerHTML = CREATOR_ICONS.map(n =>
        `<button type="button" class="icon-opt" data-icon="${n}" title="${n}"><i class="fa-solid fa-${n}"></i></button>`
    ).join('');
    on($('#cr-icon-trigger'), 'click', e => { e.stopPropagation(); _toggleIconMenu(); });
    on(grid, 'click', e => { const b = e.target.closest('.icon-opt'); if (!b) return; applyCreatorIcon(b.dataset.icon); _toggleIconMenu(false); });
    on($('#cr-icon-custom'), 'input', e => applyCreatorIcon(e.target.value || 'crown', true));
    on($('#cr-icon-menu'), 'click', e => e.stopPropagation());
    document.addEventListener('click', () => _toggleIconMenu(false));
})();

on($('#cr-close'),    'click', closeCreator);
on($('#cr-reset'),    'click', () => resetCreatorForm());
on($('#cr-new-zone'), 'click', () => {
    creator.editingId = null;
    resetCreatorForm();
    renderCreatorList();
    const idEl = $('#cr-id'); if (idEl) { idEl.disabled = false; idEl.focus(); }
});

document.addEventListener('click', e => {
    const row = e.target.closest('.cr-zone-row[data-id]');
    if (row && !e.target.closest('[data-cr-del]')) {
        const z = creator.zones.find(x => x.id === row.dataset.id);
        if (z) resetCreatorForm(z);
        renderCreatorList();
        return;
    }
    const del = e.target.closest('[data-cr-del]');
    if (del) {
        const id = del.dataset.crDel;
        confirmDlg('Delete this zone?', () => {
            post('creator_delete', { id }).then(() => refreshCreator());
        });
    }
});

on($('#cr-use-coords'), 'click', () => {
    post('creator_get_coords').then(r => {
        if (!r) return;
        applyCoords(r);
        toast('Coords captured', 'success');
    });
});

// LASER PICK — hides the creator, switches the player to aim mode
// in-world. The Lua side will fire creator_laser_pick once they
// confirm with [E].
on($('#cr-laser'), 'click', () => {
    const overlay = $('#creator-overlay'); if (overlay) overlay.hidden = true;
    post('creator_laser_start');
});

function applyCoords(r) {
    if (!r) return;
    if ($('#cr-x')) $('#cr-x').value = r.x ?? 0;
    if ($('#cr-y')) $('#cr-y').value = r.y ?? 0;
    if ($('#cr-z')) $('#cr-z').value = r.z ?? 0;
    if ($('#cr-h')) $('#cr-h').value = r.heading ?? 0;
}

on($('#cr-save'), 'click', () => {
    const payload = {
        id:      ($('#cr-id')?.value || '').trim(),
        job:     ($('#cr-job')?.value || '').trim(),
        label:   ($('#cr-label')?.value || 'Boss Menu').trim(),
        icon:    ($('#cr-icon')?.value || 'crown').trim(),
        radius:  Number($('#cr-radius')?.value) || 2.0,
        x:       Number($('#cr-x')?.value) || 0,
        y:       Number($('#cr-y')?.value) || 0,
        z:       Number($('#cr-z')?.value) || 0,
        heading: Number($('#cr-h')?.value) || 0,
        blip:    !!$('#cr-blip')?.checked,
    };
    if (!payload.id)  return toast('ID is required', 'error');
    if (!payload.job) return toast('Pick a job from the dropdown', 'error');
    post('creator_save', payload).then(r => {
        if (!r?.ok) return toast(r?.error || 'Failed to save', 'error');
        toast(`Zone "${payload.id}" saved`, 'success');
        // After save: keep the panel open and reset so admins can
        // chain multiple zones quickly.
        refreshCreator().then(() => {
            creator.editingId = null;
            resetCreatorForm();
            renderCreatorList();
            const idEl = $('#cr-id'); if (idEl) idEl.focus();
        });
    });
});

function refreshCreator() {
    return post('creator_refresh').then(r => {
        if (!r?.ok) return;
        creator.zones = r.zones || [];
        renderCreatorList();
    });
}

// Tell the host page (apex_restaurant) we're loaded so it can deliver the
// pending 'open' right away (and on every reload).
_bfTellParent('bf_ready');
post('dbg', { at: 'iframe-loaded' });
