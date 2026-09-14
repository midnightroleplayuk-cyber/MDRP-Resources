(function () {
    const state = {
        open: false,
        view: 'dashboard',
        monitors: [],
        meta: {},
        selectedCid: null,
        filter: 'all',
        search: '',
        attachPayload: null,
        config: {}
    };

    function resource() {
        return typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'plt_departments';
    }

    function post(name, body = {}) {
        return fetch(`https://${resource()}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        });
    }

    function esc(value) {
        return String(value ?? '').replace(/[&<>"']/g, (char) => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        }[char]));
    }

    function unix(value) {
        const n = Number(value || 0);
        if (!n) return 'N/A';
        return new Date(n * 1000).toLocaleString();
    }

    function ago(value) {
        const n = Number(value || 0);
        if (!n) return 'Never';
        const now = Number(state.meta.serverTime || Math.floor(Date.now() / 1000));
        const diff = Math.max(0, now - n);
        if (diff < 60) return `${diff}s ago`;
        if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
        return `${Math.floor(diff / 3600)}h ago`;
    }

    function activeMonitor() {
        return state.monitors.find((m) => m.citizenid === state.selectedCid) || state.monitors[0] || null;
    }

    function statusPill(value) {
        const safe = esc(value || 'unknown');
        return `<span class="am-pill ${safe}"><i class="fas fa-circle"></i>${safe.replaceAll('_', ' ')}</span>`;
    }

    function filteredMonitors() {
        const term = state.search.trim().toLowerCase();
        return state.monitors.filter((m) => {
            const matchesFilter = state.filter === 'all' || m.status === state.filter || m.signal === state.filter;
            const haystack = `${m.targetName || ''} ${m.citizenid || ''} ${m.caseNumber || ''} ${m.officerName || ''}`.toLowerCase();
            return matchesFilter && (!term || haystack.includes(term));
        });
    }

    function counts() {
        const monitors = state.monitors;
        return {
            active: monitors.filter((m) => m.status === 'active').length,
            alerts: monitors.reduce((total, m) => total + (m.events || []).filter((e) => ['tamper', 'zone_violation', 'battery_low', 'signal_lost'].includes(e.event_type)).length, 0),
            signal: monitors.filter((m) => ['signal_lost', 'no_signal'].includes(m.signal)).length,
            online: monitors.filter((m) => m.online).length
        };
    }

    function renderStats() {
        const c = counts();
        return `
            <div class="am-stats">
                <div class="am-stat"><span>Active Monitors</span><strong>${c.active}</strong></div>
                <div class="am-stat"><span>Online Signals</span><strong>${c.online}</strong></div>
                <div class="am-stat"><span>Signal Issues</span><strong>${c.signal}</strong></div>
                <div class="am-stat"><span>Total Alerts</span><strong>${c.alerts}</strong></div>
            </div>
        `;
    }

    function renderList() {
        const list = filteredMonitors();
        if (!state.selectedCid && list[0]) state.selectedCid = list[0].citizenid;

        return `
            <div class="am-list-panel">
                <div class="am-panel-head">
                    <h2>Subjects</h2>
                    <span class="am-muted">${list.length} shown</span>
                </div>
                <div class="am-filter-row">
                    <input class="am-input" placeholder="Search name, CID, case..." value="${esc(state.search)}" oninput="window.ankleMonitorSearch(this.value)">
                    <select class="am-select" onchange="window.ankleMonitorFilter(this.value)">
                        ${['all', 'active', 'suspended', 'expired', 'tampered', 'signal_lost', 'no_signal'].map((f) => `<option value="${f}" ${state.filter === f ? 'selected' : ''}>${f.replaceAll('_', ' ').toUpperCase()}</option>`).join('')}
                    </select>
                </div>
                <div class="am-monitor-list">
                    ${list.map((m) => `
                        <div class="am-monitor-row ${state.selectedCid === m.citizenid ? 'active' : ''}" onclick="window.ankleMonitorSelect('${esc(m.citizenid)}')">
                            <div class="am-row-title">
                                <span>${esc(m.targetName)}</span>
                                ${statusPill(m.signal)}
                            </div>
                            <div class="am-row-meta">
                                <span>${esc(m.caseNumber || 'No case')}</span>
                                <span>${Number(m.battery ?? 0)}%</span>
                            </div>
                        </div>
                    `).join('') || '<div class="am-empty">No monitors match this view.</div>'}
                </div>
            </div>
        `;
    }

    function renderEvents(events, limit) {
        const rows = (events || []).slice(0, limit || 12);
        if (!rows.length) return '<div class="am-muted">No recorded events.</div>';
        return rows.map((event) => `
            <div class="am-event">
                <span class="am-muted">${unix(event.created_at)}</span>
                <div><strong>${esc((event.event_type || 'event').replaceAll('_', ' '))}</strong><br>${esc(event.message || '')}</div>
                <span class="am-muted">${esc(event.officer_name || 'System')}</span>
            </div>
        `).join('');
    }

    function renderZones(monitor) {
        const zones = monitor.zones || [];
        return `
            <div class="am-section">
                <h3>Geofence Rules</h3>
                <div class="am-section-content">
                    ${zones.map((zone) => `
                        <div class="am-zone">
                            ${statusPill(zone.zone_type)}
                            <div><strong>${esc(zone.label)}</strong><br><span class="am-muted">${Number(zone.radius || 0)}m radius at ${Number(zone.x || 0).toFixed(1)}, ${Number(zone.y || 0).toFixed(1)}</span></div>
                            <button class="am-icon-btn" onclick="window.ankleMonitorDeleteZone('${esc(monitor.citizenid)}', ${Number(zone.id)})"><i class="fas fa-trash"></i></button>
                        </div>
                    `).join('') || '<div class="am-muted">No geofence rules set.</div>'}
                    <div class="am-zone-form" style="margin-top:12px;">
                        <input class="am-input" id="am-zone-label" placeholder="Zone label">
                        <select class="am-select" id="am-zone-type">
                            <option value="required">Allowed area - must stay inside</option>
                            <option value="restricted">Forbidden area - must stay outside</option>
                        </select>
                        <input class="am-input" id="am-zone-radius" type="number" min="10" value="150" placeholder="Radius">
                        <button class="am-btn primary" onclick="window.ankleMonitorAddZone('${esc(monitor.citizenid)}')">ADD</button>
                    </div>
                    <div class="am-muted" style="margin-top:8px;">New zones use your current officer location unless coordinates are edited in code later.</div>
                </div>
            </div>
        `;
    }

    function renderDetail() {
        const m = activeMonitor();
        if (!m) {
            return '<div class="am-detail-panel"><div class="am-empty">No ankle monitors are active for this department.</div></div>';
        }

        return `
            <div class="am-detail-panel">
                <div class="am-panel-head">
                    <h2>Subject Profile</h2>
                    <div>${statusPill(m.status)} ${statusPill(m.signal)}</div>
                </div>
                <div class="am-detail-body">
                    <div class="am-profile">
                        <div>
                            <h2>${esc(m.targetName)}</h2>
                            <p>${esc(m.citizenid)} · Case ${esc(m.caseNumber || 'Unassigned')}</p>
                        </div>
                        <div class="am-actions">
                            <button class="am-btn primary" onclick="window.ankleMonitorLocate('${esc(m.citizenid)}')"><i class="fas fa-location-dot"></i> LOCATE</button>
                            <button class="am-btn warning" onclick="window.ankleMonitorToggleStatus('${esc(m.citizenid)}', '${m.status === 'suspended' ? 'active' : 'suspended'}')">${m.status === 'suspended' ? 'REACTIVATE' : 'SUSPEND'}</button>
                            <button class="am-btn" onclick="window.ankleMonitorExtend('${esc(m.citizenid)}')">EXTEND</button>
                            <button class="am-btn danger" onclick="window.ankleMonitorRemove('${esc(m.citizenid)}')">REMOVE</button>
                        </div>
                    </div>

                    <div class="am-info-grid">
                        <div class="am-info"><span>Battery</span><strong>${Number(m.battery ?? 0)}%</strong></div>
                        <div class="am-info"><span>Last Ping</span><strong>${ago(m.lastPing)}</strong></div>
                        <div class="am-info"><span>Expires</span><strong>${unix(m.expiresAt)}</strong></div>
                        <div class="am-info"><span>Assigned Officer</span><strong>${esc(m.officerName || 'N/A')}</strong></div>
                        <div class="am-info"><span>Street</span><strong>${esc(m.lastStreet || 'Unknown')}</strong></div>
                        <div class="am-info"><span>Attached</span><strong>${unix(m.attachedAt)}</strong></div>
                    </div>

                    <div class="am-section">
                        <h3>Reason & Conditions</h3>
                        <div class="am-section-content">
                            <strong>Reason</strong><br>${esc(m.reason || 'No reason recorded.')}
                            <br><br><strong>Conditions</strong><br>${esc(m.conditions || 'No conditions recorded.')}
                        </div>
                    </div>

                    ${renderZones(m)}

                    <div class="am-section">
                        <h3>Recent Activity</h3>
                        <div class="am-section-content">${renderEvents(m.events, 10)}</div>
                    </div>
                </div>
            </div>
        `;
    }

    function renderDashboard() {
        return `
            <div class="am-workspace">
                ${renderStats()}
                <div class="am-panels">
                    ${renderList()}
                    ${renderDetail()}
                </div>
            </div>
        `;
    }

    function allEvents() {
        return state.monitors.flatMap((m) => (m.events || []).map((event) => ({ ...event, targetName: m.targetName, citizenid: m.citizenid })))
            .sort((a, b) => Number(b.created_at || 0) - Number(a.created_at || 0));
    }

    function renderEventView(type) {
        const rootEvents = allEvents().filter((event) => {
            if (type === 'alerts') return ['tamper', 'zone_violation', 'battery_low', 'signal_lost'].includes(event.event_type);
            return true;
        });

        return `
            <div class="am-workspace">
                ${renderStats()}
                <div class="am-detail-panel">
                    <div class="am-panel-head"><h2>${type === 'alerts' ? 'Alerts' : 'Audit Log'}</h2><span class="am-muted">${rootEvents.length} records</span></div>
                    <div class="am-detail-body">
                        ${rootEvents.map((event) => `
                            <div class="am-event">
                                <span class="am-muted">${unix(event.created_at)}</span>
                                <div><strong>${esc(event.targetName)} · ${esc((event.event_type || 'event').replaceAll('_', ' '))}</strong><br>${esc(event.message || '')}</div>
                                <button class="am-btn" onclick="window.ankleMonitorSelectAndDashboard('${esc(event.citizenid)}')">OPEN</button>
                            </div>
                        `).join('') || '<div class="am-empty">No records in this view.</div>'}
                    </div>
                </div>
            </div>
        `;
    }

    function renderAttach() {
        const payload = state.attachPayload || {};
        return `
            <div class="am-attach-panel">
                <div class="am-panel-head">
                    <h2>Apply Ankle Monitor</h2>
                    <span class="am-muted">${esc(payload.targetName || 'Unknown target')}</span>
                </div>
                <div class="am-attach-body">
                    <div class="am-attach-form">
                        <div class="am-attach-grid">
                            <input class="am-input" id="am-attach-case" placeholder="Case number / court order">
                            <input class="am-input" id="am-attach-duration" type="number" min="1" max="${Number(state.config.maxDurationHours || 720)}" value="${Number(state.config.defaultDurationHours || 72)}" placeholder="Duration hours">
                            <textarea class="am-textarea wide" id="am-attach-reason" placeholder="Reason for monitoring"></textarea>
                            <textarea class="am-textarea wide" id="am-attach-conditions" placeholder="Release conditions, restricted locations, curfew notes"></textarea>
                        </div>
                        <div class="am-actions">
                            <button class="am-btn" onclick="window.closeAnkleMonitor()">CANCEL</button>
                            <button class="am-btn primary" onclick="window.submitAnkleMonitorAttach()">ATTACH MONITOR</button>
                        </div>
                        <div class="am-muted">${state.config.requireItem ? `Requires item: ${esc(state.config.itemName || 'ankle_monitor')}` : 'Item requirement disabled in config.'}</div>
                    </div>
                </div>
            </div>
        `;
    }

    function render() {
        const root = document.getElementById('ankle-monitor-root');
        if (!root) return;

        document.querySelectorAll('.am-nav').forEach((btn) => {
            btn.classList.toggle('active', btn.dataset.amView === state.view);
        });

        if (state.view === 'attach') root.innerHTML = renderAttach();
        else if (state.view === 'alerts') root.innerHTML = renderEventView('alerts');
        else if (state.view === 'audit') root.innerHTML = renderEventView('audit');
        else if (state.view === 'zones') root.innerHTML = renderDashboard();
        else root.innerHTML = renderDashboard();
    }

    window.closeAnkleMonitor = function () {
        const container = document.getElementById('ankle-monitor-container');
        if (container) container.classList.add('hidden');
        state.open = false;
        post('closeAnkleMonitor');
    };

    window.ankleMonitorSetView = function (view) {
        if (state.view === 'attach') return;
        state.view = view || 'dashboard';
        render();
    };

    window.ankleMonitorRefresh = function () {
        post('ankleMonitorRefresh');
    };

    window.ankleMonitorSearch = function (value) {
        state.search = value || '';
        render();
    };

    window.ankleMonitorFilter = function (value) {
        state.filter = value || 'all';
        render();
    };

    window.ankleMonitorSelect = function (cid) {
        state.selectedCid = cid;
        render();
    };

    window.ankleMonitorSelectAndDashboard = function (cid) {
        state.selectedCid = cid;
        state.view = 'dashboard';
        render();
    };

    window.ankleMonitorLocate = function (cid) {
        const monitor = state.monitors.find((m) => m.citizenid === cid);
        post('ankleMonitorLocate', {
            citizenid: cid,
            coords: monitor && monitor.lastCoords,
            label: monitor && monitor.targetName
        });
    };

    window.ankleMonitorRemove = function (cid) {
        post('ankleMonitorRemove', { citizenid: cid, reason: 'Monitoring order completed.' });
    };

    window.ankleMonitorToggleStatus = function (cid, status) {
        post('ankleMonitorSetStatus', { citizenid: cid, status });
    };

    window.ankleMonitorExtend = function (cid) {
        post('ankleMonitorExtend', { citizenid: cid, hours: 24 });
    };

    window.ankleMonitorAddZone = function (cid) {
        const label = document.getElementById('am-zone-label')?.value || '';
        const zoneType = document.getElementById('am-zone-type')?.value || 'required';
        const radius = Number(document.getElementById('am-zone-radius')?.value || 150);
        post('ankleMonitorAddZone', { citizenid: cid, label, zoneType, radius });
    };

    window.ankleMonitorDeleteZone = function (cid, zoneId) {
        post('ankleMonitorDeleteZone', { citizenid: cid, zoneId });
    };

    window.submitAnkleMonitorAttach = function () {
        const payload = state.attachPayload || {};
        post('ankleMonitorAttach', {
            targetServerId: payload.targetServerId,
            caseNumber: document.getElementById('am-attach-case')?.value || '',
            durationHours: Number(document.getElementById('am-attach-duration')?.value || state.config.defaultDurationHours || 72),
            reason: document.getElementById('am-attach-reason')?.value || '',
            conditions: document.getElementById('am-attach-conditions')?.value || ''
        });
    };

    window.addEventListener('message', (event) => {
        const data = event.data || {};
        if (data.action === 'openAnkleMonitor') {
            const container = document.getElementById('ankle-monitor-container');
            if (container) container.classList.remove('hidden');
            state.open = true;
            state.view = data.mode || 'dashboard';
            state.attachPayload = data.payload || null;
            state.config = data.config || {};
            render();
        } else if (data.action === 'closeAnkleMonitor') {
            const container = document.getElementById('ankle-monitor-container');
            if (container) container.classList.add('hidden');
            state.open = false;
        } else if (data.action === 'ankleMonitorData') {
            state.monitors = data.monitors || [];
            state.meta = data.meta || {};
            if (state.selectedCid && !state.monitors.some((m) => m.citizenid === state.selectedCid)) {
                state.selectedCid = null;
            }
            render();
        }
    });

    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && state.open) {
            window.closeAnkleMonitor();
        }
    });
})();
