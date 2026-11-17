(function () {
    const RESOURCE_NAME = (typeof GetParentResourceName === 'function')
        ? GetParentResourceName() : 'tw-builderjob';

    let data = null;
    let tab = 'lobbies';
    let searchRows = null;
    let detail = null;
    let busy = false;
    const openLobbies = new Set();
    let logs = null;
    let logCat = 'all';

    function api(name, body) {
        return fetch(`https://${RESOURCE_NAME}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(body || {}),
        }).then((r) => r.json()).catch(() => null);
    }

    function T(key, fallback) {
        const tbl = window.TW_LOCALES;
        return (tbl && tbl[key]) || fallback || key;
    }

    const esc = (s) => String(s === undefined || s === null ? '' : s)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

    const num = (n) => (Number(n) || 0).toLocaleString('en-US');
    const money = (n) => '$' + num(Math.round(Number(n) || 0));

    function ago(epoch) {
        const s = Math.max(0, Math.floor(Date.now() / 1000) - Number(epoch));
        if (s < 3600) return Math.floor(s / 60) + 'm';
        if (s < 86400) return Math.floor(s / 3600) + 'h';
        return Math.floor(s / 86400) + 'd';
    }

    function hoursStrip() {
        const h = (data && data.hours) || [];
        const total = h.reduce((a, b) => a + (b || 0), 0);
        if (!total) return '';
        const max = Math.max.apply(null, h) || 1;
        const bars = h.map((n, i) => {
            const pct = Math.round(((n || 0) / max) * 100);
            return `<i style="height:${Math.max(3, pct)}%" title="${i}:00 - ${n || 0}"></i>`;
        }).join('');
        return `
            <div class="ta-hours">
                <div class="ta-sec">${esc(T('admin_peak', 'When jobs get finished'))}</div>
                <div class="ta-hours-bars">${bars}</div>
                <div class="ta-hours-ax"><span>00</span><span>06</span><span>12</span><span>18</span><span>23</span></div>
            </div>`;
    }

    let root = null;

    function ensureRoot() {
        if (root) return root;
        root = document.createElement('div');
        root.id = 'twadmin-root';
        root.innerHTML = `
            <div class="ta-shell">
                <div class="newTitleBox">
                    <div class="newTitleIcon"><img src="./img/newLogo.png" alt="" class="newLogo"></div>
                    <div class="newTitleTextBox">
                        <h2 class="newTitleText">Tworst</h2>
                        <p class="newTitleSubText">Admin</p>
                    </div>
                </div>
                <div class="ta-panel">
                    <div class="ta-head">
                        <div class="ta-head-right">
                            <div class="ta-clock">
                                <svg class="ta-clock-ic" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><path d="M12 7.5V12l2.8 1.8" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                <span id="ta-clock"></span>
                            </div>
                            <button class="ta-icon-btn" id="ta-refresh" title="${esc(T('admin_refresh', 'Refresh'))}">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 1 1-2.64-6.36"/><path d="M21 4v5h-5"/></svg>
                            </button>
                            <button class="ta-btn close" id="ta-close" title="${esc(T('admin_close', 'Close'))}">✕</button>
                        </div>
                    </div>
                    <div class="ta-stats" id="ta-stats"></div>
                    <div class="ta-tabs" id="ta-tabs"></div>
                    <div class="ta-body" id="ta-body"></div>
                </div>
            </div>
            <div id="ta-detail"></div>`;
        document.body.appendChild(root);

        root.querySelector('#ta-close').addEventListener('click', close);
        const rf = root.querySelector('#ta-refresh');
        rf.addEventListener('click', () => {
            rf.classList.remove('spinning');
            void rf.offsetWidth;
            rf.classList.add('spinning');
            refresh();
        });

        root.addEventListener('mousedown', (e) => {
            if (e.target === root) close();
        });
        return root;
    }

    function renderStats() {
        const s = (data && data.summary) || {};
        document.getElementById('ta-clock').textContent = data && data.serverTime ? data.serverTime : '';
        document.getElementById('ta-stats').innerHTML = `
            <div class="ta-stat">
                <div class="k">${esc(T('admin_online', 'Online'))}</div>
                <div class="v">${num(s.online)}</div>
                <div class="sub">${num((data && data.lobbies || []).length)} ${esc(T('admin_lobbies', 'lobbies'))}</div>
            </div>
            <div class="ta-stat">
                <div class="k">${esc(T('admin_today', 'Today'))}</div>
                <div class="v accent">${money(s.todayMoney)}</div>
                <div class="sub">${num(s.todayJobs)} ${esc(T('admin_jobs', 'jobs'))}</div>
            </div>
            <div class="ta-stat">
                <div class="k">${esc(T('admin_week', 'This week'))}</div>
                <div class="v accent">${money(s.weekMoney)}</div>
                <div class="sub">${num(s.weekJobs)} ${esc(T('admin_jobs', 'jobs'))}</div>
            </div>
            <div class="ta-stat">
                <div class="k">${esc(T('admin_alltime', 'All time'))}</div>
                <div class="v">${money(s.allMoney)}</div>
                <div class="sub">${num(s.allTasks)} ${esc(T('admin_jobs', 'jobs'))}</div>
            </div>
            <div class="ta-stat">
                <div class="k">${esc(T('admin_workers', 'Workers'))}</div>
                <div class="v">${num(s.players)}</div>
                <div class="sub">${esc(T('admin_with_completions', 'with a finished job'))}</div>
            </div>`;
    }

    function renderTabs() {
        const lobbies = (data && data.lobbies) || [];
        const players = (data && data.topPlayers) || [];
        const regions = (data && data.regions) || [];
        const defs = [
            ['lobbies', T('admin_tab_lobbies', 'Lobbies'), lobbies.length],
            ['players', T('admin_tab_players', 'Players'), players.length],
            ['regions', T('admin_tab_regions', 'Regions'), regions.length],
            ['logs', T('admin_tab_logs', 'Logs'), logs ? logs.total : ''],
        ];
        const el = document.getElementById('ta-tabs');
        el.querySelectorAll('.ta-tab').forEach((b) => b.remove());
        if (!el.querySelector('.ta-tab-ind')) {
            const ind = document.createElement('div');
            ind.className = 'ta-tab-ind';
            el.insertBefore(ind, el.firstChild);
        }
        el.insertAdjacentHTML('beforeend', defs.map(([id, label, n]) =>
            `<button class="ta-tab ${tab === id ? 'on' : ''}" data-tab="${id}">${esc(label)}<span class="count">${n}</span></button>`
        ).join(''));
        el.querySelectorAll('.ta-tab').forEach((b) => {
            b.addEventListener('click', () => {
                tab = b.dataset.tab;
                searchRows = null;
                renderTabs();
                renderBody();
                if (tab === 'logs' && !logs) loadLogs(logCat);
            });
        });
        moveTabInd();
    }

    function moveTabInd() {
        const el = document.getElementById('ta-tabs');
        if (!el) return;
        const on = el.querySelector('.ta-tab.on');
        const ind = el.querySelector('.ta-tab-ind');
        if (!on || !ind) return;
        ind.style.left = on.offsetLeft + 'px';
        ind.style.width = on.offsetWidth + 'px';
    }

    function dur(secs) {
        const s = Math.max(0, Number(secs) || 0);
        if (s < 3600) return Math.floor(s / 60) + 'm';
        return Math.floor(s / 3600) + 'h' + String(Math.floor((s % 3600) / 60)).padStart(2, '0');
    }

    function lobbyCard(l) {
        const state = l.state === 'active' ? 'active' : (l.state === 'finished' ? 'finished' : 'waiting');
        const stateLabel = state === 'active' ? T('admin_state_active', 'working')
            : state === 'finished' ? T('admin_state_finished', 'finished')
                : T('admin_state_waiting', 'in lobby');

        const stuckAfter = ((data && data.stuckMinutes) || 90) * 60;
        const stuck = state === 'active' && l.elapsed && l.elapsed > stuckAfter;

        const crew = (l.players || []).map((p) => `
            <div class="ta-member ${p.isOwner ? 'owner' : ''}" data-id="${esc(p.identifier)}">
                <span>${esc(p.name)}</span>
                <span class="lvl">${esc(T('admin_lvl', 'lv'))}${esc(p.level || 1)}</span>
                ${p.share !== undefined && p.share !== null ? `<span class="share">${esc(p.share)}%</span>` : ''}
            </div>`).join('');

        const t = l.tasks;
        const prog = t ? `
            <div class="ta-prog">
                <div class="ta-prog-top">
                    <span>${esc(T('admin_tasks', 'Tasks'))} ${num(t.done)}/${num(t.total)}</span>
                    ${t.current ? `<span class="cur">${esc(t.current.label || '')}${t.current.need ? ' <b>' + num(t.current.made) + '/' + num(t.current.need) + '</b>' : ''}</span>` : ''}
                </div>
                <div class="ta-bar"><i style="width:${t.total ? Math.round((t.done / t.total) * 100) : 0}%"></i></div>
            </div>` : '';

        const key = String(l.ownerIdentifier || l.ownerName || '');
        const isOpen = openLobbies.has(key);
        const regionText = (l.regionName || T('admin_no_region', 'no region picked'))
            + (l.regionID ? ' · R' + l.regionID : '')
            + (l.siteId ? ' · ' + l.siteId : '');
        const chev = '<svg class="ta-lob-chev" viewBox="0 0 24 24" fill="none"><path d="M9 6l6 6-6 6" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/></svg>';
        const pcIcon = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a4 4 0 100-8 4 4 0 000 8zm0 2c-4 0-8 2-8 4.5V20h16v-1.5C20 16 16 14 12 14z"/></svg>';

        return `
            <div class="ta-lobby ${stuck ? 'stuck' : ''} ${isOpen ? 'open' : ''}" data-key="${esc(key)}">
                <div class="ta-lobby-sum" data-toggle="${esc(key)}">
                    ${chev}
                    <div class="ta-lobby-owner">${esc(l.ownerName)}</div>
                    <div class="ta-lobby-region">${esc(regionText)}</div>
                    <div class="ta-badge ${state}">${esc(stateLabel)}</div>
                    ${l.elapsed ? `<div class="ta-badge ${stuck ? 'stuckb' : 'time'}">${esc(dur(l.elapsed))}</div>` : ''}
                    ${stuck ? `<div class="ta-lob-warn">⚠ ${esc(T('admin_stuck_short', 'stuck'))}</div>` : ''}
                    <div class="ta-lob-spacer"></div>
                    ${t ? `<div class="ta-lob-quick">${esc(T('admin_tasks', 'Tasks'))} ${num(t.done)}/${num(t.total)}</div>` : ''}
                    <div class="ta-lob-pc">${pcIcon}${esc(l.playerCount)}</div>
                </div>
                <div class="ta-lobby-detail">
                    <div class="ta-lobby-detail-in">
                        ${stuck ? `<div class="ta-note bad">${esc(T('admin_stuck', 'Running far longer than any region normally takes. It may be stuck - the crew cannot start another job until this one ends.'))}</div>` : ''}
                        ${prog}
                        <div class="ta-crew">${crew}</div>
                        <div class="ta-lob-foot">
                            <button class="ta-end" data-end="${esc(l.ownerIdentifier)}">${esc(T('admin_force_end', 'End job'))}</button>
                        </div>
                    </div>
                </div>
            </div>`;
    }

    function playerRow(p, i) {
        return `
            <div class="ta-row" data-id="${esc(p.identifier)}">
                <div class="rank ${i < 3 ? 'top' : ''}">${i + 1}</div>
                <div class="who">
                    <img src="${esc(p.avatar || '')}" onerror="this.style.visibility='hidden'"/>
                    <span class="nm">${esc(p.name)}</span>
                    <span class="lv">${esc(T('admin_lvl', 'lv'))}${esc(p.level || 1)}</span>
                </div>
                <div class="money">${money(p.money)}</div>
                <div class="tasks">${num(p.tasks)}</div>
            </div>`;
    }

    const LOG_CATS = ['all', 'jobstart', 'jobfinish', 'lobby', 'economy', 'admin', 'security', 'error'];

    function catLabel(c) {
        const map = {
            all: T('admin_log_all', 'All'),
            jobstart: T('admin_log_jobstart', 'Started'),
            jobfinish: T('admin_log_jobfinish', 'Finished'),
            lobby: T('admin_log_lobby', 'Lobby'),
            economy: T('admin_log_economy', 'Payouts'),
            admin: T('admin_log_admin', 'Admin'),
            security: T('admin_log_security', 'Security'),
            error: T('admin_log_error', 'Errors'),
        };
        return map[c] || c;
    }

    function since(now, at) {
        const s = Math.max(0, Number(now) - Number(at));
        if (s < 60) return s + 's';
        if (s < 3600) return Math.floor(s / 60) + 'm';
        if (s < 86400) return Math.floor(s / 3600) + 'h';
        return Math.floor(s / 86400) + 'd';
    }

    function logRow(e, now) {
        const fields = (e.fields || []).map((f) =>
            `<span class="f"><b>${esc(f.n)}</b>${esc(f.v)}</span>`).join('');
        return `
            <div class="ta-log ${e.alert ? 'alert' : ''}">
                <div class="tm">${esc(since(now, e.at))}</div>
                <div class="cat c-${esc(e.cat)}">${esc(catLabel(e.cat))}</div>
                <div class="main">
                    <div class="ttl">${esc(e.title || e.key)}</div>
                    ${e.desc ? `<div class="dsc">${esc(e.desc)}</div>` : ''}
                    ${fields ? `<div class="fl">${fields}</div>` : ''}
                </div>
            </div>`;
    }

    function renderLogs() {
        const body = document.getElementById('ta-body');
        if (!logs) {
            body.innerHTML = `<div class="ta-empty">${esc(T('admin_log_loading', 'Loading...'))}</div>`;
            return;
        }
        if (logs.error) {
            body.innerHTML = `<div class="ta-note bad">${esc(logs.error)}</div>`;
            return;
        }

        const counts = logs.counts || {};
        const chips = LOG_CATS.map((c) => {
            const n = c === 'all' ? logs.total : (counts[c] || 0);
            const wired = c !== 'all' && logs.configured && logs.configured[c];
            return `<button class="ta-chip ${logCat === c ? 'on' : ''}" data-cat="${esc(c)}">${wired ? '<i class="dot"></i>' : ''}${esc(catLabel(c))}<span class="count">${num(n)}</span></button>`;
        }).join('');

        const rows = logs.rows || [];
        const note = !logs.discordOn
            ? T('admin_log_discord_off', 'Discord posting is switched off; this page still records everything.')
            : (logs.configured && !Object.keys(logs.configured).some((k) => logs.configured[k]))
                ? T('admin_log_no_webhook', 'No Discord webhook is configured (config/secrets/discord.lua). This page works without one.')
                : '';

        body.innerHTML = `
            ${note ? `<div class="ta-note">${esc(note)}</div>` : ''}
            <div class="ta-chips">${chips}</div>
            ${rows.length ? rows.map((e) => logRow(e, logs.now)).join('')
                : `<div class="ta-empty">${esc(T('admin_log_empty', 'Nothing logged yet.'))}</div>`}
            <div class="ta-foot">${esc(T('admin_log_foot', 'Kept in server memory and cleared on restart - the last') + ' ' + num(logs.keep || 300) + ' ' + T('admin_log_foot2', 'events. Discord is the permanent copy.'))}</div>`;

        body.querySelectorAll('.ta-log').forEach((el, i) => {
            el.style.animationDelay = Math.min(i * 0.03, 0.4) + 's';
        });

        body.querySelectorAll('.ta-chip').forEach((b) => {
            b.addEventListener('click', () => {
                logCat = b.dataset.cat;
                loadLogs(logCat);
            });
        });
    }

    function loadLogs(cat) {
        if (busy) return;
        busy = true;
        api('admin:getLogs', { cat: cat === 'all' ? null : cat }).then((res) => {
            busy = false;
            if (res && res.success && res.data) {
                logs = res.data;
            } else {
                logs = { error: (res && res.message) || T('admin_log_failed', 'Could not read the log.'), rows: [] };
            }
            renderTabs();
            if (tab === 'logs') renderLogs();
        });
    }

    function renderBody() {
        const body = document.getElementById('ta-body');

        if (tab === 'logs') { renderLogs(); return; }

        if (tab === 'lobbies') {
            const list = (data && data.lobbies) || [];
            body.innerHTML = list.length
                ? list.map(lobbyCard).join('')
                : `<div class="ta-empty">${esc(T('admin_no_lobbies', 'No active lobbies right now.'))}</div>`;

        } else if (tab === 'players') {
            const rows = searchRows || (data && data.topPlayers) || [];
            const note = (data && data.scanTruncated && !searchRows)
                ? `<div class="ta-note">${esc(T('admin_scan_note', 'More players have completions than the scan limit; statistics cover the top') + ' ' + (data.scanLimit || 500) + '.')}</div>`
                : '';
            body.innerHTML = `
                ${note}
                <div class="ta-search">
                    <input id="ta-q" placeholder="${esc(T('admin_search_ph', 'Search name or identifier...'))}" value=""/>
                    <button class="ta-btn" id="ta-q-go">${esc(T('admin_search', 'Search'))}</button>
                    ${searchRows ? `<button class="ta-btn" id="ta-q-clear">${esc(T('admin_clear', 'Clear'))}</button>` : ''}
                </div>
                <div class="ta-head-row">
                    <div></div><div>${esc(T('admin_player', 'Player'))}</div>
                    <div class="money">${esc(T('admin_earned', 'Earned'))}</div>
                    <div class="tasks">${esc(T('admin_jobs', 'jobs'))}</div>
                </div>
                ${rows.length ? rows.map(playerRow).join('')
                    : `<div class="ta-empty">${esc(T('admin_no_players', 'Nobody has finished a job yet.'))}</div>`}`;

            const q = document.getElementById('ta-q');
            const go = () => doSearch(q.value);
            document.getElementById('ta-q-go').addEventListener('click', go);
            q.addEventListener('keydown', (e) => { if (e.key === 'Enter') go(); });
            const clr = document.getElementById('ta-q-clear');
            if (clr) clr.addEventListener('click', () => { searchRows = null; renderBody(); });

        } else {
            const list = (data && data.regions) || [];
            const max = list.reduce((m, r) => Math.max(m, r.starts || 0), 0) || 1;
            const dash = '<span class="na">--</span>';

            const rows = list.map((r) => {
                const bad = r.abandonPct !== null && r.abandonPct !== undefined && r.abandonPct >= 50;
                return `
                <div class="ta-reg-row" data-region="${esc(r.regionID)}">
                    <div class="nm">${esc(r.regionName || ('R' + r.regionID))}
                        <span class="rid">R${esc(r.regionID)}</span>
                        <div class="ta-bar"><i style="width:${Math.max(2, Math.round(((r.starts || 0) / max) * 100))}%"></i></div>
                    </div>
                    <div class="n">${num(r.starts)}</div>
                    <div class="n">${num(r.completions)}</div>
                    <div class="n ${bad ? 'bad' : ''}">${r.abandonPct === null || r.abandonPct === undefined ? dash : r.abandonPct + '%'}</div>
                    <div class="n">${r.avgMinutes ? r.avgMinutes + '<span class="u">m</span>' : dash}</div>
                    <div class="n accent">${r.perMinute ? '$' + num(r.perMinute) : dash}${r.rateRatio && (r.rateRatio >= 1.5 || r.rateRatio <= 0.67) ? `<span class="ratio ${r.rateRatio >= 1.5 ? 'hi' : 'lo'}" title="${esc(T('admin_ratio_t', 'compared with the median region'))}">${r.rateRatio}x</span>` : ''}</div>
                    <div class="n">${r.avgCrew ? r.avgCrew : dash}</div>
                    <div class="n tm">${r.lastPlayed ? ago(r.lastPlayed) : dash}</div>
                </div>`;
            }).join('');

            const resetStrip = `
                <div class="ta-reset">
                    <span class="ta-reset-lbl">${esc(T('admin_reset_sites', 'Clear placed props'))}</span>
                    <button class="ta-end" data-reset="panelwall">${esc(T('admin_reset_r5', 'Region 5 - Panel Wall'))}</button>
                    <button class="ta-end" data-reset="job9">${esc(T('admin_reset_r9', 'Region 9 - Lumber'))}</button>
                </div>`;

            body.innerHTML = `
                ${hoursStrip()}
                ${resetStrip}
                <div class="ta-reg-head">
                    <div>${esc(T('admin_region', 'Region'))}</div>
                    <div class="n">${esc(T('admin_started', 'Started'))}</div>
                    <div class="n">${esc(T('admin_done', 'Done'))}</div>
                    <div class="n">${esc(T('admin_quit', 'Quit'))}</div>
                    <div class="n">${esc(T('admin_length', 'Length'))}</div>
                    <div class="n">${esc(T('admin_per_min', '$/min'))}</div>
                    <div class="n">${esc(T('admin_crew_avg', 'Crew'))}</div>
                    <div class="n">${esc(T('admin_last', 'Last'))}</div>
                </div>
                ${rows || `<div class="ta-empty">${esc(T('admin_no_regions', 'No completed jobs recorded yet.'))}</div>`}
                <div class="ta-foot">${esc(T('admin_region_foot', 'Started counts every crew that began the job; Quit is the share that never finished. $/min is the crew payout divided by real job length - the number that shows which region gets farmed.'))}</div>`;
        }

        body.querySelectorAll('.ta-lobby, .ta-row, .ta-reg-row').forEach((el, i) => {
            el.style.animationDelay = Math.min(i * 0.035, 0.4) + 's';
        });

        body.querySelectorAll('.ta-lobby').forEach((card) => {
            const det = card.querySelector('.ta-lobby-detail');
            const inner = card.querySelector('.ta-lobby-detail-in');
            if (!det || !inner) return;
            if (card.classList.contains('open')) det.style.maxHeight = inner.offsetHeight + 'px';
            const sum = card.querySelector('.ta-lobby-sum');
            sum.addEventListener('click', () => {
                const key = sum.dataset.toggle;
                const willOpen = !card.classList.contains('open');
                card.classList.toggle('open', willOpen);
                if (willOpen) {
                    openLobbies.add(key);
                    det.style.maxHeight = inner.offsetHeight + 'px';
                } else {
                    openLobbies.delete(key);
                    det.style.maxHeight = '0px';
                }
            });
        });

        body.querySelectorAll('[data-id]').forEach((n) => {
            n.addEventListener('click', () => openDetail(n.dataset.id));
        });

        body.querySelectorAll('[data-reset]').forEach((n) => {
            n.addEventListener('click', () => {
                if (n.dataset.armed !== '1') {
                    n.dataset.armed = '1';
                    const was = n.textContent;
                    n.textContent = T('admin_force_end_confirm', 'Sure?');
                    setTimeout(() => {
                        if (!n.isConnected) return;
                        n.dataset.armed = '';
                        n.textContent = was;
                    }, 3000);
                    return;
                }
                resetSite(n.dataset.reset);
            });
        });
        body.querySelectorAll('[data-end]').forEach((n) => {
            n.addEventListener('click', (e) => {
                e.stopPropagation();
                if (n.dataset.armed !== '1') {
                    n.dataset.armed = '1';
                    n.textContent = T('admin_force_end_confirm', 'Sure?');
                    setTimeout(() => {
                        if (!n.isConnected) return;
                        n.dataset.armed = '';
                        n.textContent = T('admin_force_end', 'End job');
                    }, 3000);
                    return;
                }
                forceEnd(n.dataset.end);
            });
        });
    }

    function renderAll() {
        renderStats();
        renderTabs();
        renderBody();
    }

    function renderDetail() {
        const host = document.getElementById('ta-detail');
        if (!detail) { host.innerHTML = ''; return; }
        const d = detail;

        const hist = (d.history || []).map((h) => `
            <div class="ta-hist">
                <div>${esc(h.regionName || ('R' + (h.regionID || '?')))}
                    <span class="tm">${esc(h.time || '')}</span></div>
                <div class="mn">${money(h.money)}</div>
                <div class="tm">${esc(h.crew || 1)} ${esc(T('admin_crew', 'crew'))}</div>
            </div>`).join('');

        host.innerHTML = `
            <div class="ta-detail">
                <div class="ta-detail-card">
                    <div class="ta-detail-head">
                        <img src="${esc(d.avatar || '')}" onerror="this.style.visibility='hidden'"/>
                        <div>
                            <div class="nm">${esc(d.name)}</div>
                            <div class="id">${esc(d.identifier)}</div>
                        </div>
                        <div class="ta-head-right">
                            <button class="ta-btn close" id="ta-d-close" title="${esc(T('admin_close', 'Close'))}">✕</button>
                        </div>
                    </div>
                    <div class="ta-detail-body">
                        ${d.activeLobby ? `<div class="ta-note">${esc(T('admin_in_lobby', 'In a lobby right now'))} — ${esc(d.activeLobby.regionName || T('admin_no_region', 'no region picked'))}${d.activeLobby.isOwner ? ' · ' + esc(T('admin_is_owner', 'owner')) : ''}</div>` : ''}
                        <div class="ta-mini">
                            <div class="ta-stat"><div class="k">${esc(T('admin_earned', 'Earned'))}</div><div class="v accent">${money(d.money)}</div></div>
                            <div class="ta-stat"><div class="k">${esc(T('admin_jobs', 'jobs'))}</div><div class="v">${num(d.tasks)}</div></div>
                            <div class="ta-stat"><div class="k">${esc(T('admin_level', 'Level'))}</div><div class="v">${num(d.level)}</div></div>
                        </div>
                        <div class="ta-sec">${esc(T('admin_recent', 'Recent jobs'))}</div>
                        ${hist || `<div class="ta-empty">${esc(T('admin_no_history', 'No job history stored.'))}</div>`}
                    </div>
                </div>
            </div>`;

        document.getElementById('ta-d-close').addEventListener('click', () => {
            detail = null;
            renderDetail();
        });
        host.querySelector('.ta-detail').addEventListener('mousedown', (e) => {
            if (e.target.classList.contains('ta-detail')) { detail = null; renderDetail(); }
        });
    }

    function doSearch(query) {
        if (busy) return;
        const q = String(query || '').trim();
        if (q.length < 2) return;
        busy = true;
        api('admin:searchPlayer', { query: q }).then((res) => {
            busy = false;
            searchRows = (res && res.success && res.data) ? res.data : [];
            renderBody();
            const box = document.getElementById('ta-q');
            if (box) { box.value = q; }
        });
    }

    function openDetail(identifier) {
        if (busy || !identifier) return;
        busy = true;
        api('admin:getPlayerDetail', { identifier }).then((res) => {
            busy = false;
            if (res && res.success && res.data) {
                detail = res.data;
                renderDetail();
            }
        });
    }

    function resetSite(key) {
        if (busy || !key) return;
        busy = true;
        api('admin:resetSite', { key }).then(() => {
            busy = false;
            refresh();
        });
    }

    function forceEnd(ownerIdentifier) {
        if (busy || !ownerIdentifier) return;
        busy = true;
        api('admin:forceEnd', { ownerIdentifier }).then(() => {
            busy = false;
            refresh();
        });
    }

    function refresh() {
        if (busy) return;
        busy = true;
        api('admin:refresh', {}).then((res) => {
            busy = false;
            if (res && res.success && res.data) {
                data = res.data;
                renderAll();
            }
        });
    }

    function open(payload) {
        ensureRoot();
        data = payload || null;
        tab = 'lobbies';
        searchRows = null;
        detail = null;
        logs = null;
        logCat = 'all';
        root.style.display = 'block';
        renderAll();
        renderDetail();
        requestAnimationFrame(() => requestAnimationFrame(() => {
            if (root) { root.classList.add('visible'); moveTabInd(); }
        }));
    }

    function close() {
        if (!root) return;
        root.classList.remove('visible');
        detail = null;
        renderDetail();
        api('admin:close', {});
        setTimeout(() => {
            if (root && !root.classList.contains('visible')) root.style.display = 'none';
        }, 260);
    }

    window.addEventListener('message', (event) => {
        const d = event.data || {};
        if (d.action === 'ADMIN_OPEN') open(d.payload);
    });

    window.addEventListener('keydown', (e) => {
        if (e.key !== 'Escape' || !root || !root.classList.contains('visible')) return;
        if (detail) { detail = null; renderDetail(); return; }
        close();
    });
})();
