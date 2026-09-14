(function () {
    const state = {
        open: false,
        view: 'dashboard',
        monitors: [],
        meta: {},
        selectedCid: null,
        attachPayload: null,
        config: {},
        filter: 'live',
        modal: null,
        mapZoom: 1,
        mapPanX: 0,
        mapPanY: 0,
        draggingMap: false,
        mapDragMoved: false,
        dragStartX: 0,
        dragStartY: 0,
        dragPanX: 0,
        dragPanY: 0,
        voiceCid: null
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
        if (diff < 60) return `${diff}s`;
        if (diff < 3600) return `${Math.floor(diff / 60)}m`;
        return `${Math.floor(diff / 3600)}h`;
    }

    function mapConfig() {
        const map = state.config.map || {};
        const bounds = map.Bounds || map.bounds || {};
        return {
            image: map.Image || map.image || 'img/map.png',
            bounds: {
                minX: Number(bounds.minX ?? -4000),
                maxX: Number(bounds.maxX ?? 4500),
                minY: Number(bounds.minY ?? -4200),
                maxY: Number(bounds.maxY ?? 8000)
            }
        };
    }

    function clamp(value, min, max) {
        return Math.max(min, Math.min(max, value));
    }

    function applyMapTransform() {
        const canvas = document.querySelector('.am-map-canvas');
        if (!canvas) return;
        canvas.style.setProperty('--am-map-zoom', state.mapZoom.toFixed(3));
        canvas.style.setProperty('--am-map-pan-x', `${state.mapPanX}px`);
        canvas.style.setProperty('--am-map-pan-y', `${state.mapPanY}px`);
        canvas.style.setProperty('--am-pin-scale', (1 / Math.max(state.mapZoom, 0.01)).toFixed(3));

        const zoomLabel = document.querySelector('[data-am-map-zoom]');
        if (zoomLabel) zoomLabel.textContent = `${Math.round(state.mapZoom * 100)}%`;
    }

    function mapPoint(coords) {
        if (!coords) return null;
        const { bounds } = mapConfig();
        const x = Number(coords.x);
        const y = Number(coords.y);
        if (!Number.isFinite(x) || !Number.isFinite(y)) return null;

        const left = ((x - bounds.minX) / (bounds.maxX - bounds.minX)) * 100;
        const top = ((bounds.maxY - y) / (bounds.maxY - bounds.minY)) * 100;
        return {
            left: clamp(left, 0, 100),
            top: clamp(top, 0, 100)
        };
    }

    function mapCoordsFromEvent(event) {
        const canvas = document.querySelector('.am-map-canvas');
        if (!canvas) return null;

        const rect = canvas.getBoundingClientRect();
        if (!rect.width || !rect.height) return null;

        const left = clamp(((event.clientX - rect.left) / rect.width) * 100, 0, 100);
        const top = clamp(((event.clientY - rect.top) / rect.height) * 100, 0, 100);
        const { bounds } = mapConfig();

        return {
            x: bounds.minX + (left / 100) * (bounds.maxX - bounds.minX),
            y: bounds.maxY - (top / 100) * (bounds.maxY - bounds.minY),
            z: 0.0
        };
    }

    function activeMonitor() {
        if (state.selectedCid) {
            const selected = state.monitors.find((monitor) => monitor.citizenid === state.selectedCid);
            if (selected) return selected;
        }
        return liveMonitors()[0] || state.monitors[0] || null;
    }

    function liveMonitors() {
        return state.monitors.filter((monitor) => {
            if (!monitor.lastCoords) return false;
            if (state.filter === 'alerts') return ['tampered', 'signal_lost', 'no_signal', 'expired'].includes(monitor.signal) || monitor.status === 'tampered';
            if (state.filter === 'all') return true;
            return monitor.signal === 'online' && monitor.status === 'active';
        });
    }

    function statusClass(monitor) {
        if (!monitor) return 'unknown';
        if (monitor.status === 'tampered') return 'tampered';
        return monitor.signal || monitor.status || 'unknown';
    }

    function pill(value) {
        if (value === 'online') return '';
        const safe = esc(value || 'unknown');
        return `<span class="am-pill ${safe}">${safe.replaceAll('_', ' ')}</span>`;
    }

    function counts() {
        return {
            live: state.monitors.filter((m) => m.signal === 'online' && m.status === 'active').length,
            total: state.monitors.length,
            alerts: state.monitors.filter((m) => ['tampered', 'signal_lost', 'no_signal', 'expired'].includes(statusClass(m))).length,
            lowBattery: state.monitors.filter((m) => Number(m.battery || 0) <= 20).length
        };
    }

    function renderStats() {
        const c = counts();
        return `
            <div class="am-map-stats">
                <div><span>Live</span><strong>${c.live}</strong></div>
                <div><span>Total</span><strong>${c.total}</strong></div>
                <div><span>Alerts</span><strong>${c.alerts}</strong></div>
                <div><span>Low Battery</span><strong>${c.lowBattery}</strong></div>
            </div>
        `;
    }

    function renderPins() {
        const monitors = liveMonitors();
        return monitors.map((monitor) => {
            const point = mapPoint(monitor.lastCoords);
            if (!point) return '';
            const active = activeMonitor() && activeMonitor().citizenid === monitor.citizenid;
            const cls = statusClass(monitor);
            return `
                <button class="am-map-pin ${cls} ${active ? 'active' : ''}" style="left:${point.left}%; top:${point.top}%;" onmousedown="event.stopPropagation()" onclick="window.ankleMonitorSelect('${esc(monitor.citizenid)}')" title="${esc(monitor.targetName)}">
                    <span></span>
                    <strong>${esc((monitor.targetName || '?').slice(0, 1))}</strong>
                </button>
            `;
        }).join('');
    }

    function renderZonesOverlay(monitor) {
        if (!monitor || !monitor.zones) return '';
        return monitor.zones.map((zone) => {
            const point = mapPoint({ x: zone.x, y: zone.y, z: zone.z });
            if (!point) return '';
            const size = clamp(Number(zone.radius || 100) / 28, 18, 180);
            return `
                <div class="am-map-zone ${zone.zone_type}" style="left:${point.left}%; top:${point.top}%; width:${size}px; height:${size}px;">
                    <span>${esc(zone.label)}</span>
                </div>
            `;
        }).join('');
    }

    function renderZoneDraftOverlay() {
        const modal = state.modal;
        if (!modal || modal.type !== 'zone' || !modal.coords) return '';

        const point = mapPoint(modal.coords);
        if (!point) return '';

        const size = clamp(Number(modal.radius || 150) / 28, 18, 180);
        return `
            <div class="am-map-zone draft" style="left:${point.left}%; top:${point.top}%; width:${size}px; height:${size}px;">
                <span>${esc(modal.label || 'New zone')}</span>
            </div>
            <div class="am-zone-crosshair" style="left:${point.left}%; top:${point.top}%;"></div>
        `;
    }

    function renderMap() {
        const cfg = mapConfig();
        const selected = activeMonitor();
        const live = liveMonitors();
        return `
            <div class="am-live-map-panel">
                <div class="am-map-toolbar">
                    <div>
                        <strong>Live Los Santos Monitoring</strong>
                        <span>${live.length} subjects plotted from latest ankle-monitor pings</span>
                    </div>
                    <div class="am-map-filters">
                        <button class="${state.filter === 'live' ? 'active' : ''}" onclick="window.ankleMonitorMapFilter('live')">LIVE</button>
                        <button class="${state.filter === 'alerts' ? 'active' : ''}" onclick="window.ankleMonitorMapFilter('alerts')">ALERTS</button>
                        <button class="${state.filter === 'all' ? 'active' : ''}" onclick="window.ankleMonitorMapFilter('all')">ALL</button>
                    </div>
                </div>
                <div class="am-live-map ${state.modal?.type === 'zone' ? 'picking-zone' : ''}" onmousedown="window.ankleMonitorMapDragStart(event)" onclick="window.ankleMonitorMapClick(event)" onwheel="window.ankleMonitorMapWheel(event)">
                    <div class="am-map-controls" onmousedown="event.stopPropagation()" onclick="event.stopPropagation()">
                        <button onclick="window.ankleMonitorZoom(-0.15)"><i class="fas fa-minus"></i></button>
                        <span data-am-map-zoom>${Math.round(state.mapZoom * 100)}%</span>
                        <button onclick="window.ankleMonitorZoom(0.15)"><i class="fas fa-plus"></i></button>
                        <button onclick="window.ankleMonitorMapReset()"><i class="fas fa-expand"></i></button>
                    </div>
                    <div class="am-map-canvas" style="--am-map-zoom:${state.mapZoom}; --am-map-pan-x:${state.mapPanX}px; --am-map-pan-y:${state.mapPanY}px;">
                        <img src="${esc(cfg.image)}" onerror="this.onerror=null; this.src='img/map.png';" alt="Los Santos map" draggable="false">
                        <div class="am-map-grid"></div>
                        ${renderZonesOverlay(selected)}
                        ${renderZoneDraftOverlay()}
                        ${renderPins()}
                    </div>
                    ${live.length ? '' : '<div class="am-map-empty">No live ankle monitor coordinates received yet.</div>'}
                </div>
            </div>
        `;
    }

    function renderSubjectPanel() {
        const monitor = activeMonitor();
        if (!monitor) {
            return '<div class="am-map-subject"><div class="am-empty">Select a live map marker.</div></div>';
        }

        return `
            <div class="am-map-subject">
                <div class="am-subject-head">
                    <div>
                        <span>Selected Subject</span>
                        <h2>${esc(monitor.targetName)}</h2>
                        <p>${esc(monitor.citizenid)} / Case ${esc(monitor.caseNumber || 'Unassigned')}</p>
                    </div>
                    ${pill(statusClass(monitor))}
                </div>

                ${renderStats()}

                <div class="am-subject-actions">
                    <button class="am-btn route" onclick="window.ankleMonitorLocate('${esc(monitor.citizenid)}')"><i class="fas fa-location-dot"></i> ROUTE</button>
                    <button class="am-btn taze" onclick="window.ankleMonitorTaze('${esc(monitor.citizenid)}')"><i class="fas fa-bolt"></i> TAZE</button>
                    <button class="am-btn warning" onclick="window.ankleMonitorToggleStatus('${esc(monitor.citizenid)}', '${monitor.status === 'suspended' ? 'active' : 'suspended'}')">${monitor.status === 'suspended' ? 'REACTIVATE' : 'SUSPEND'}</button>
                    <button class="am-btn extend" onclick="window.ankleMonitorExtend('${esc(monitor.citizenid)}')">EXTEND</button>
                    <button class="am-btn danger" onclick="window.ankleMonitorRemove('${esc(monitor.citizenid)}')">REMOVE</button>
                </div>

                <div class="am-compact-grid">
                    <div><span>Battery</span><strong>${Number(monitor.battery ?? 0)}%</strong></div>
                    <div><span>Ping</span><strong>${ago(monitor.lastPing)} ago</strong></div>
                    <div><span>Expires</span><strong>${unix(monitor.expiresAt)}</strong></div>
                    <div><span>Street</span><strong>${esc(monitor.lastStreet || 'Unknown')}</strong></div>
                    <div><span>Officer</span><strong>${esc(monitor.officerName || 'N/A')}</strong></div>
                    <div><span>Coords</span><strong>${monitor.lastCoords ? `${Number(monitor.lastCoords.x).toFixed(1)}, ${Number(monitor.lastCoords.y).toFixed(1)}` : 'N/A'}</strong></div>
                </div>

                <div class="am-compact-notes">
                    <div><span>Reason</span><p>${esc(monitor.reason || 'No reason recorded.')}</p></div>
                    <div><span>Conditions</span><p>${esc(monitor.conditions || 'No conditions recorded.')}</p></div>
                </div>

                <div class="am-compact-zones">
                    <div class="am-compact-title">
                        <span>Zones</span>
                        <button onclick="window.ankleMonitorQuickZone('${esc(monitor.citizenid)}')"><i class="fas fa-plus"></i></button>
                    </div>
                    ${(monitor.zones || []).slice(0, 4).map((zone) => `
                        <div class="am-mini-zone">
                            ${pill(zone.zone_type)}
                            <strong>${esc(zone.label)}</strong>
                            <span>${Number(zone.radius || 0)}m</span>
                            <button onclick="window.ankleMonitorDeleteZone('${esc(monitor.citizenid)}', ${Number(zone.id)})"><i class="fas fa-trash"></i></button>
                        </div>
                    `).join('') || '<p class="am-muted">No zones set.</p>'}
                </div>
                <button class="am-btn voice ${(monitor.audioActive || state.voiceCid === monitor.citizenid) ? 'active' : ''}" onclick="window.ankleMonitorToggleVoice('${esc(monitor.citizenid)}')">
                    <i class="fas fa-headset"></i> ${(monitor.audioActive || state.voiceCid === monitor.citizenid) ? 'HANG UP LIVE AUDIO' : 'LIVE AUDIO'}
                </button>
            </div>
        `;
    }

    function renderSubjectStrip() {
        const monitors = liveMonitors();
        return `
            <div class="am-live-strip">
                ${monitors.slice(0, 10).map((monitor) => `
                    <button class="${activeMonitor() && activeMonitor().citizenid === monitor.citizenid ? 'active' : ''}" onclick="window.ankleMonitorSelect('${esc(monitor.citizenid)}')">
                        <strong>${esc(monitor.targetName)}</strong>
                        <span>${statusClass(monitor).replaceAll('_', ' ')} / ${ago(monitor.lastPing)} / ${Number(monitor.battery ?? 0)}%</span>
                    </button>
                `).join('') || '<div class="am-live-strip-empty">Waiting for live monitor pings.</div>'}
            </div>
        `;
    }

    function allEvents() {
        return state.monitors.flatMap((monitor) => (monitor.events || []).map((event) => ({ ...event, targetName: monitor.targetName, citizenid: monitor.citizenid })))
            .sort((a, b) => Number(b.created_at || 0) - Number(a.created_at || 0));
    }

    function renderEvents(type) {
        const events = allEvents().filter((event) => {
            if (type !== 'alerts') return true;
            return ['tamper', 'zone_violation', 'battery_low', 'signal_lost'].includes(event.event_type);
        }).slice(0, 12);

        return `
            <div class="am-map-workspace am-events-workspace">
                ${renderStats()}
                <div class="am-event-board">
                    ${events.map((event) => `
                        <button onclick="window.ankleMonitorSelectAndDashboard('${esc(event.citizenid)}')">
                            <span>${unix(event.created_at)}</span>
                            <strong>${esc(event.targetName)} / ${esc((event.event_type || 'event').replaceAll('_', ' '))}</strong>
                            <p>${esc(event.message || '')}</p>
                        </button>
                    `).join('') || '<div class="am-empty">No records in this view.</div>'}
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
                    </div>
                </div>
            </div>
        `;
    }

    function renderActionModal() {
        const modal = state.modal;
        if (!modal) return '';

        if (modal.type === 'remove') {
            return `
                <div class="am-ui-modal">
                    <div class="am-ui-modal-card">
                        <div class="am-ui-modal-head">
                            <h3>Remove Monitor</h3>
                            <button onclick="window.ankleMonitorCloseModal()"><i class="fas fa-times"></i></button>
                        </div>
                        <label>Removal reason</label>
                        <textarea class="am-textarea" id="am-modal-remove-reason">Monitoring order completed.</textarea>
                        <div class="am-ui-modal-actions">
                            <button class="am-btn" onclick="window.ankleMonitorCloseModal()">CANCEL</button>
                            <button class="am-btn danger" onclick="window.ankleMonitorSubmitModal()">REMOVE</button>
                        </div>
                    </div>
                </div>
            `;
        }

        if (modal.type === 'extend') {
            return `
                <div class="am-ui-modal">
                    <div class="am-ui-modal-card">
                        <div class="am-ui-modal-head">
                            <h3>Extend Order</h3>
                            <button onclick="window.ankleMonitorCloseModal()"><i class="fas fa-times"></i></button>
                        </div>
                        <label>Extension hours</label>
                        <input class="am-input" id="am-modal-extend-hours" type="number" min="1" value="24">
                        <div class="am-ui-modal-actions">
                            <button class="am-btn" onclick="window.ankleMonitorCloseModal()">CANCEL</button>
                            <button class="am-btn primary" onclick="window.ankleMonitorSubmitModal()">EXTEND</button>
                        </div>
                    </div>
                </div>
            `;
        }

        if (modal.type === 'zone') {
            return `<div class="am-zone-modal-layer">${renderZonePickerCard()}</div>`;
        }

        return '';
    }

    function renderZonePickerCard() {
        const modal = state.modal;
        if (!modal || modal.type !== 'zone') return '';

        const picked = modal.coords;
        const pickedText = picked
            ? `Selected: ${Number(picked.x).toFixed(1)}, ${Number(picked.y).toFixed(1)}`
            : 'Click the map to choose the zone center.';

        return `
            <div class="am-ui-modal-card am-zone-side-card">
                <div class="am-ui-modal-head">
                    <h3>Add Zone</h3>
                    <button onclick="window.ankleMonitorCloseModal()"><i class="fas fa-times"></i></button>
                </div>
                <label>Zone label</label>
                <input class="am-input" id="am-modal-zone-label" value="${esc(modal.label || 'Court ordered area')}" oninput="window.ankleMonitorModalLabelChanged(this.value)">
                <label>Zone type</label>
                <select class="am-select" id="am-modal-zone-type" onchange="window.ankleMonitorModalTypeChanged(this.value)">
                    <option value="required" ${modal.zoneType === 'restricted' ? '' : 'selected'}>Allowed area - must stay inside</option>
                    <option value="restricted" ${modal.zoneType === 'restricted' ? 'selected' : ''}>Forbidden area - must stay outside</option>
                </select>
                <label>Radius in meters</label>
                <input class="am-input" id="am-modal-zone-radius" type="number" min="10" value="${Number(modal.radius || 150)}" oninput="window.ankleMonitorModalRadiusChanged(this.value)">
                <div class="am-zone-picker-status ${picked ? 'picked' : ''}">
                    <i class="fas fa-crosshairs"></i>
                    <span>${esc(pickedText)}</span>
                </div>
                ${modal.error ? `<strong class="am-modal-error">${esc(modal.error)}</strong>` : ''}
                <div class="am-ui-modal-actions">
                    <button class="am-btn" onclick="window.ankleMonitorCloseModal()">CANCEL</button>
                    <button class="am-btn primary" onclick="window.ankleMonitorSubmitModal()">ADD ZONE</button>
                </div>
            </div>
        `;
    }

    function renderDashboard() {
        return `
            <div class="am-map-workspace">
                <div class="am-map-layout">
                    ${renderMap()}
                    ${renderSubjectPanel()}
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
        else if (state.view === 'alerts') root.innerHTML = renderEvents('alerts');
        else if (state.view === 'audit') root.innerHTML = renderEvents('audit');
        else root.innerHTML = renderDashboard();

        const container = document.getElementById('ankle-monitor-container');
        let modalRoot = document.getElementById('am-modal-root');
        if (!modalRoot && container) {
            modalRoot = document.createElement('div');
            modalRoot.id = 'am-modal-root';
            container.appendChild(modalRoot);
        }
        if (modalRoot) modalRoot.innerHTML = renderActionModal();
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

    window.ankleMonitorMapFilter = function (filter) {
        state.filter = filter || 'live';
        render();
    };

    window.ankleMonitorZoom = function (delta) {
        state.mapZoom = clamp(state.mapZoom + delta, 0.75, 3.5);
        if (state.mapZoom <= 1) {
            state.mapPanX = 0;
            state.mapPanY = 0;
        }
        applyMapTransform();
    };

    window.ankleMonitorMapReset = function () {
        state.mapZoom = 1;
        state.mapPanX = 0;
        state.mapPanY = 0;
        applyMapTransform();
    };

    window.ankleMonitorMapWheel = function (event) {
        event.preventDefault();
        const step = event.deltaY > 0 ? -0.12 : 0.12;
        window.ankleMonitorZoom(step);
    };

    window.ankleMonitorMapDragStart = function (event) {
        if (event.button !== 0) return;
        state.draggingMap = true;
        state.mapDragMoved = false;
        state.dragStartX = event.clientX;
        state.dragStartY = event.clientY;
        state.dragPanX = state.mapPanX;
        state.dragPanY = state.mapPanY;
        const map = document.querySelector('.am-live-map');
        if (map) map.classList.add('dragging');
    };

    window.ankleMonitorMapClick = function (event) {
        if (!state.modal || state.modal.type !== 'zone') return;
        if (event.target.closest('.am-map-controls') || event.target.closest('.am-map-pin')) return;
        if (state.mapDragMoved) return;

        const coords = mapCoordsFromEvent(event);
        if (!coords) return;

        state.modal.label = document.getElementById('am-modal-zone-label')?.value || state.modal.label || 'Court ordered area';
        state.modal.zoneType = document.getElementById('am-modal-zone-type')?.value === 'restricted' ? 'restricted' : 'required';
        state.modal.radius = Number(document.getElementById('am-modal-zone-radius')?.value || state.modal.radius || 150);
        state.modal.coords = coords;
        state.modal.error = '';
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

    window.ankleMonitorTaze = function (cid) {
        post('ankleMonitorTaze', { citizenid: cid });
    };

    window.ankleMonitorToggleVoice = function (cid) {
        post('ankleMonitorVoiceToggle', { citizenid: cid });
    };

    window.ankleMonitorRemove = function (cid) {
        state.modal = { type: 'remove', citizenid: cid };
        render();
    };

    window.ankleMonitorToggleStatus = function (cid, status) {
        post('ankleMonitorSetStatus', { citizenid: cid, status });
    };

    window.ankleMonitorExtend = function (cid) {
        state.modal = { type: 'extend', citizenid: cid };
        render();
    };

    window.ankleMonitorQuickZone = function (cid) {
        state.modal = { type: 'zone', citizenid: cid, radius: 150, coords: null, error: '' };
        render();
    };

    window.ankleMonitorCloseModal = function () {
        state.modal = null;
        render();
    };

    window.ankleMonitorModalRadiusChanged = function (value) {
        if (!state.modal || state.modal.type !== 'zone') return;
        const radius = Number(value);
        state.modal.radius = Number.isFinite(radius) ? radius : 150;
        const draft = document.querySelector('.am-map-zone.draft');
        if (draft) {
            const size = clamp(Number(state.modal.radius || 150) / 28, 18, 180);
            draft.style.width = `${size}px`;
            draft.style.height = `${size}px`;
        }
    };

    window.ankleMonitorModalLabelChanged = function (value) {
        if (!state.modal || state.modal.type !== 'zone') return;
        state.modal.label = value || 'Court ordered area';
        const draftLabel = document.querySelector('.am-map-zone.draft span');
        if (draftLabel) draftLabel.textContent = state.modal.label;
    };

    window.ankleMonitorModalTypeChanged = function (value) {
        if (!state.modal || state.modal.type !== 'zone') return;
        state.modal.zoneType = value === 'restricted' ? 'restricted' : 'required';
    };

    window.ankleMonitorSubmitModal = function () {
        const modal = state.modal;
        if (!modal) return;

        if (modal.type === 'remove') {
            const reason = document.getElementById('am-modal-remove-reason')?.value || 'Monitoring order completed.';
            post('ankleMonitorRemove', { citizenid: modal.citizenid, reason });
        } else if (modal.type === 'extend') {
            const hours = Number(document.getElementById('am-modal-extend-hours')?.value || 24);
            if (Number.isFinite(hours) && hours > 0) {
                post('ankleMonitorExtend', { citizenid: modal.citizenid, hours });
            }
        } else if (modal.type === 'zone') {
            const label = document.getElementById('am-modal-zone-label')?.value || 'Court ordered area';
            const zoneType = document.getElementById('am-modal-zone-type')?.value === 'restricted' ? 'restricted' : 'required';
            const radius = Number(document.getElementById('am-modal-zone-radius')?.value || 150);
            if (!modal.coords) {
                state.modal.label = label;
                state.modal.zoneType = zoneType;
                state.modal.radius = Number.isFinite(radius) ? radius : 150;
                state.modal.error = 'Choose the zone location on the map first.';
                render();
                return;
            }
            post('ankleMonitorAddZone', {
                citizenid: modal.citizenid,
                label,
                zoneType,
                radius: Number.isFinite(radius) ? radius : 150,
                x: modal.coords.x,
                y: modal.coords.y,
                z: modal.coords.z
            });
        }

        state.modal = null;
        render();
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
            if (state.selectedCid && !state.monitors.some((monitor) => monitor.citizenid === state.selectedCid)) {
                state.selectedCid = null;
            }
            if (!state.selectedCid && liveMonitors()[0]) {
                state.selectedCid = liveMonitors()[0].citizenid;
            }
            render();
        } else if (data.action === 'ankleMonitorVoiceState') {
            state.voiceCid = data.active ? data.citizenid : null;
            state.monitors = state.monitors.map((monitor) => ({
                ...monitor,
                audioActive: monitor.citizenid === data.citizenid ? data.active === true : monitor.audioActive
            }));
            render();
        }
    });

    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && state.open) {
            window.closeAnkleMonitor();
        }
    });

    window.addEventListener('mousemove', (event) => {
        if (!state.draggingMap) return;
        if (Math.abs(event.clientX - state.dragStartX) > 4 || Math.abs(event.clientY - state.dragStartY) > 4) {
            state.mapDragMoved = true;
        }
        state.mapPanX = state.dragPanX + (event.clientX - state.dragStartX);
        state.mapPanY = state.dragPanY + (event.clientY - state.dragStartY);
        applyMapTransform();
    });

    window.addEventListener('mouseup', () => {
        if (!state.draggingMap) return;
        state.draggingMap = false;
        const map = document.querySelector('.am-live-map');
        if (map) map.classList.remove('dragging');
    });

    setInterval(() => {
        if (state.open && state.view !== 'attach') {
            post('ankleMonitorRefresh');
        }
    }, 5000);
})();
